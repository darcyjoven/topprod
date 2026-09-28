# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#{
# Program name  : cq_ecd.4gl
# Program ver.  : 7.0
# Description   : 作業說明資料查詢
# Date & Author : 2016/08/04 by guanyao
# Memo          : 
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         shm01    LIKE shm_file.shm01,
         shm012   LIKE shm_file.shm012,
         shm05    LIKE shm_file.shm05,     
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         wipqty   LIKE type_file.num15_3,
         shm01_1  LIKE type_file.chr50
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         shm01    LIKE shm_file.shm01,
         shm012   LIKE shm_file.shm012,
         shm05    LIKE shm_file.shm05,     
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         wipqty   LIKE type_file.num15_3,
         shm01_1  LIKE type_file.chr50
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_default1      STRING     
DEFINE   ms_ret1          STRING     #回傳欄位的變數
DEFINE   g_sql_w          STRING 
DEFINE   g_tc_pmm06_1     LIKE tc_pmm_file.tc_pmm06   
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose	#No.FUN-680131 SMALLINT
FUNCTION cq_ecd(pi_multi_sel,pi_need_cons,ps_default1,p_tc_pmmud05)
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    STRING 
   DEFINE   p_tc_pmmud05   STRING
 
   LET ms_default1 = ps_default1
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "cqry/42f/cq_ecd" ATTRIBUTE(STYLE="create_qry")  #No.FUN-660161
 
   CALL cl_ui_locale("cq_ecd")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons

   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 2003/09/16 by Hiko :
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("shm01", "red")
   END IF
   CALL cq_qry_table()
   CALL cq_ecd_tc_pmmud05(p_tc_pmmud05)
   CALL cecd_qry_sel()
   DROP TABLE cq_ecd_tmp
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 #複選資料只能回傳一個欄位的組合字串.
   ELSE
      RETURN ms_ret1 #回傳值(也許有多個).
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2003/09/22 by Winny
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION cecd_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 	#No.FUN-680131 SMALLINT
            li_continue      LIKE type_file.num5      #是否繼續.	#No.FUN-680131 SMALLINT
   DEFINE   li_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_curr_page     LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03
 
 
   LET mi_page_count = 100 #每頁顯現最大資料筆數.
   LET li_reconstruct = TRUE
 
   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      IF (li_reconstruct) THEN
         MESSAGE ""
     
         IF (mi_need_cons) THEN
            CONSTRUCT ms_cons_where ON shm01,shm012,shm05
                                  FROM s_shm[1].shm01,s_shm[1].shm012,s_shm[1].shm05
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            
            END CONSTRUCT
     
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
     
         CALL cecd_qry_prep_result_set() 
         # 2003/07/14 by Hiko : 如果沒有設定'每頁顯現資料筆數',則預設為所有資料一起顯現.
         IF (mi_page_count = 0) THEN
            LET mi_page_count = ma_qry.getLength()
         END IF
         # 2003/07/14 by Hiko : 如果所設定的'每頁顯現資料筆數'超過/等於所有資料,則要隱藏'上下頁'的按鈕.
         IF (mi_page_count >= ma_qry.getLength()) THEN
            LET ls_hide_act = "prevpage,nextpage"
         END IF
     
         IF (NOT mi_need_cons) THEN
            IF (ls_hide_act IS NULL) THEN
               LET ls_hide_act = "reconstruct"
            ELSE
               LET ls_hide_act = "prevpage,nextpage,reconstruct"
            END IF 
         END IF
     
         LET li_start_index = 1
     
         LET li_reconstruct = FALSE
      END IF
     
      LET li_end_index = li_start_index + mi_page_count - 1
     
      IF (li_end_index > ma_qry.getLength()) THEN
         LET li_end_index = ma_qry.getLength()
      END IF
     
      CALL cecd_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL cecd_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL cecd_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2003/09/22 by Winny
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION cecd_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
            shm01    LIKE shm_file.shm01,
            shm012   LIKE shm_file.shm012,
            shm05    LIKE shm_file.shm05,     
            ima02    LIKE ima_file.ima02,
            ima021   LIKE ima_file.ima021,
            wipqty   LIKE type_file.num15_3,
            shm01_1  LIKE type_file.chr50
   END RECORD
   DEFINE l_sql1     STRING
   DEFINE l_sql      STRING 
 
 
   DELETE FROM cq_ecd_tmp
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('cq_ecd', 'shm_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET l_sql = "SELECT 'N',shm01,shm012,shm05,ima02,ima021,0,''",
                "  FROM shm_file LEFT JOIN ima_file ON ima01 = shm05",
                " WHERE ",ms_cons_where
   LET l_sql = l_sql CLIPPED
   LET l_sql = l_sql CLIPPED,ls_where CLIPPED," ORDER BY shm01" 

   LET l_sql1 = "INSERT INTO cq_ecd_tmp ",l_sql 
   PREPARE cd_qry_ins FROM l_sql1
   EXECUTE cd_qry_ins

   LET l_sql1  = " MERGE INTO cq_ecd_tmp o ",
                 "      USING (SELECT sgm01,MIN(sgm03) sgm03", 
                 "               FROM sgm_file,shm_file",
                 "              WHERE sgm01 = shm01 ",g_sql_w CLIPPED,
                 "              GROUP BY sgm01) n ",
                 "         ON (o.shm01 = n.sgm01) ",
                 " WHEN MATCHED ",
                 " THEN ",
                 "    UPDATE ",
                 "       SET o.sgm03 = n.sgm03 "
   PREPARE cd_qry_pre FROM l_sql1
   EXECUTE cd_qry_pre

  #str---mark by guanyao160824
  # LET l_sql1  = " MERGE INTO cq_ecd_tmp o ",
  #               "      USING (SELECT sgm01,sgm03,",
  #               "             (sgm301+sgm302+sgm303+sgm304-sgm311-sgm312-sgm313-sgm314-sgm316-sgm317) wipqty ", 
  #               "               FROM sgm_file,shm_file",
  #               "              WHERE sgm01 = shm01 ",g_sql_w CLIPPED," ) n ",
  #               "         ON (o.shm01 = n.sgm01 AND o.sgm03 = n.sgm03) ",
  #               " WHEN MATCHED ",
  #               " THEN ",
  #               "    UPDATE ",
  #               "       SET o.wipqty = NVL(n.wipqty,0) "
  # PREPARE cd_qry_pre1 FROM l_sql1
  # EXECUTE cd_qry_pre1
  LET l_sql1  = " MERGE INTO cq_ecd_tmp o ",
                 "      USING (SELECT sgm01,sgm03,",
                 "             SUM(tc_shc12) wipqty ", 
                 "               FROM tc_shc_file,sgm_file",
                 "              WHERE sgm01 = tc_shc03 ",g_sql_w CLIPPED,
                 "                AND sgm03 = tc_shc06",
                 "              GROUP BY sgm01,sgm03) n ",
                 "         ON (o.shm01 = n.sgm01 AND o.sgm03 = n.sgm03) ",
                 " WHEN MATCHED ",
                 " THEN ",
                 "    UPDATE ",
                 "       SET o.wipqty = NVL(n.wipqty,0) "
   PREPARE cd_qry_pre1 FROM l_sql1
   EXECUTE cd_qry_pre1
   DELETE FROM cq_ecd_tmp WHERE sgm03 IN (SELECT tc_shb03||tc_shb06 FROM tc_shb_file)
  #end---mark by guanyao160824
   LET ls_sql = "SELECT check1,shm01,shm012,shm05,ima02,ima021,wipqty,shm01||sgm03",
                "  FROM cq_ecd_tmp",
                " WHERE wipqty>0"
 
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   FOR li_i = ma_qry.getLength() TO 1 STEP -1
      CALL ma_qry.deleteElement(li_i)
   END FOR
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO lr_qry.*
      
      #FUN-4C0001 判斷是否已達選取上限  add by hongmf 20041201 
      IF li_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
 
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2003/09/22 by Winny
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION cecd_qry_set_display_data(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_i             LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_j             LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = ma_qry_tmp.getLength() TO 1 STEP -1
      CALL ma_qry_tmp.deleteElement(li_i)
   END FOR
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry_tmp[li_j+1].* = ma_qry[li_i].*
      LET li_j = li_j + 1
   END FOR
 
   CALL SET_COUNT(ma_qry_tmp.getLength())
END FUNCTION
 
##################################################
# Description  	: 採用INPUT ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2003/09/22 by Winny
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION cecd_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_shm.* 
   ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
   #ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_shm.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL cecd_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_shm.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL cecd_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL cecd_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_shm.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL cecd_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL cecd_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                        #CHI-9C0048
            LET ms_ret1 = NULL       #CHI-9C0048
         END IF                      #CHI-9C0048
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF
 
         LET li_continue = FALSE
     
         EXIT INPUT
 
      #No.FUN-660161--begin
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161--end
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
      #No.FUN-840023 --start--
      ON ACTION qry_string
         CALL cl_qry_string("detail")
      #No.FUN-840023 ---end---
 
      ### FUN-880082 START ###
      ON ACTION selectall
         FOR li_i = 1 TO ma_qry_tmp.getLength()
             LET ma_qry_tmp[li_i].check = "Y"
         END FOR
 
      ON ACTION select_none
         FOR li_i = 1 TO ma_qry_tmp.getLength()
             LET ma_qry_tmp[li_i].check = "N"
         END FOR
      ### FUN-880082 END ###
 
   END INPUT
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description  	: 重設查詢資料關於'check'欄位的值.
# Date & Author : 2003/09/22 by Winny
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION cecd_qry_reset_multi_sel(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_i             LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_j             LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry[li_i].check = ma_qry_tmp[li_j+1].check
      LET li_j = li_j + 1
   END FOR
END FUNCTION
 
##################################################
# Description  	: 採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2003/09/22 by Winny
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION cecd_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_shm.*
      BEFORE DISPLAY
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
      
         LET li_continue = TRUE
      
         EXIT DISPLAY
      ON ACTION nextpage
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
      
         LET li_continue = TRUE
      
         EXIT DISPLAY
      ON ACTION refresh
         LET pi_start_index = 1
         LET li_continue = TRUE
      
         EXIT DISPLAY
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
      
         EXIT DISPLAY
      ON ACTION accept
         CALL cecd_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF
 
         LET li_continue = FALSE
      
         EXIT DISPLAY
 
      #No.FUN-660161--begin
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161--end
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
      #No.FUN-840023 --start--
      ON ACTION qry_string
         CALL cl_qry_string("detail")
      #No.FUN-840023 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description   : 重設查詢資料.
# Date & Author : 2003/09/22 by Winny
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION cecd_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2003/09/22 by Winny
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION cecd_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10  	#No.FUN-680131 INTEGER
 
 
   # 2004/06/03 by saki : GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
               CALL lsb_multi_sel.append(ma_qry[li_i].shm01_1 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].shm01_1 CLIPPED)
            END IF
         END IF    
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].shm01_1 CLIPPED
   END IF
END FUNCTION
 
##################################################
# Description  	: 
# Date & Author : 2003/09/22 by Winny
# Parameter   	: l_ecd05
# Return   	: l_a
# Memo        	:
# Modify   	:
##################################################



FUNCTION cq_ecd_tc_pmmud05(p_tc_pmmud05)
DEFINE p_multi_tc_pmm03    STRING 
DEFINE p_tc_pmmud05  LIKE tc_pmm_file.tc_pmmud05
DEFINE l_length    LIKE type_file.num5
DEFINE   temptext1       STRING
DEFINE   tok         base.StringTokenizer
DEFINE i             SMALLINT
DEFINE l_w           STRING 

    LET i = 1
    LET g_sql_w = ''
    LET tok = base.StringTokenizer.create(p_tc_pmmud05,"|")
    WHILE tok.hasMoreTokens()
       LET temptext1=tok.nextToken()
       #IF i = 1 THEN
       #   LET g_sql_w = "shm01 in (select sgm01 from sgm_file where sgm04 = '",temptext1,"')",
       #                "  AND shm01 not in (select tc_pmm03 from tc_pmm_file where tc_pmm06 = '",temptext1,"')"  #add by guanyao160729
       #   LET g_tc_pmm06_1 = temptext1
       #ELSE 
       LET g_sql_w = g_sql_w," AND sgm01 IN (SELECT sgm01 FROM sgm_file WHERE sgm04 = '",temptext1,"')",
                             #" AND sgm04 IN (SELECT sgm04 FROM sgm_file WHERE sgm04 = '",temptext1,"')",
                             " AND sgm01 NOT IN (SELECT tc_pmm03 FROM tc_pmm_file WHERE tc_pmm06 = '",temptext1,"')"#add by guanyao160729
       #END IF   
       IF i = 1 THEN
          LET l_w = "( '",temptext1,"'"
       ELSE 
          LET l_w = l_w,",'",temptext1,"'"
       END IF 
       LET i = i + 1
    END WHILE 
    LET g_sql_w = g_sql_w CLIPPED," AND sgm04 IN ",l_w,")" 
END FUNCTION 

FUNCTION cq_qry_table()
        CREATE TEMP TABLE cq_ecd_tmp(
            check1    VARCHAR(1),  
            shm01    VARCHAR(23),
            shm012   VARCHAR(20),
            shm05    VARCHAR(40),     
            ima02    VARCHAR(120),
            ima021   VARCHAR(120),
            wipqty   decimal(15,3),
            sgm03    decimal(5))
END FUNCTION 