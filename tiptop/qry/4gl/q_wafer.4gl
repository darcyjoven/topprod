# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: q_wafer.4gl
# Description   : wafer採購單查詢
# Date & Author : 08/03/03 By kim (FUN-810038)
#
# Modify........: No.CHI-7A0029 08/03/21 By kim 定義錯誤
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.FUN-880082 08/09/01 By tsai_yen 開窗全選功能
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-980025 09/10/09 By dxfwo hardcode的部分修改
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
 
DATABASE ds
 
#FUN-810038
 
GLOBALS "../../config/top.global" #CHI-7A0029
 
DEFINE   pmn_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,
         pmm01    LIKE pmm_file.pmm01,                      
         pmn02    LIKE pmn_file.pmn02,                      
         pmm09    LIKE pmm_file.pmm09,                      
         pmc03    LIKE pmc_file.pmc03,                      
         pmn04    LIKE pmn_file.pmn04,                      
         pmn041   LIKE pmn_file.pmn041,                    
         pmn20    LIKE pmn_file.pmn20,                      
         pmn82    LIKE pmn_file.pmn82,                      
         qty      LIKE pmn_file.pmn20
                  END RECORD
DEFINE   pmn_qry_tmp   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,
         pmm01    LIKE pmm_file.pmm01,                      
         pmn02    LIKE pmn_file.pmn02,                      
         pmm09    LIKE pmm_file.pmm09,                      
         pmc03    LIKE pmc_file.pmc03,                      
         pmn04    LIKE pmn_file.pmn04,                      
         pmn041   LIKE pmn_file.pmn041,                    
         pmn20    LIKE pmn_file.pmn20,                      
         pmn82    LIKE pmn_file.pmn82,                      
         qty      LIKE pmn_file.pmn20
                      END RECORD
DEFINE   mi_multi_sel     LIKE type_file.num5   #是否需要複選資料(TRUE/FALSE).
DEFINE   mi_need_cons     LIKE type_file.num5   #是否需要CONSTRUCT(TRUE/FALSE).
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10    #每頁顯現資料筆數.
DEFINE   ms_default1      STRING 
DEFINE   ms_default2      STRING 
DEFINE   ms_ret1          STRING     #回傳欄位的變數
DEFINE   ms_ret2          STRING     #回傳欄位的變數
DEFINE   mc_dbs           LIKE type_file.chr21
 
FUNCTION q_wafer(pi_multi_sel,pi_need_cons,ps_default1,ps_default2)
   DEFINE   pi_multi_sel   LIKE type_file.num5,
            pi_need_cons   LIKE type_file.num5,
            ps_default1    STRING,      #預設回傳值(在取消時會回傳此類預設值).
            ps_default2    STRING       #預設回傳值(在取消時會回傳此類預設值).
 
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET ms_default1 = ps_default1
   LET ms_default2 = ps_default2
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_wafer" ATTRIBUTE(STYLE="createqry")
 
   CALL cl_ui_locale("q_wafer")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("pmm01,pmn02","red")
   END IF
 
   CALL wafer_qry_sel()
 
   CLOSE WINDOW w_qry
   LET INT_FLAG = 0
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 
   ELSE
      RETURN ms_ret1,ms_ret2
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Parameter   	: none
# Return   	: void
##################################################
FUNCTION wafer_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,   #是否隱藏'上下頁'的按鈕.
            li_reconstruct   LIKE type_file.num5,   #是否重新CONSTRUCT.預設為TRUE. 
            li_continue      LIKE type_file.num5    #是否繼續.
   DEFINE   li_start_index   LIKE type_file.num10,
            li_end_index     LIKE type_file.num10
   DEFINE   li_curr_page     LIKE type_file.num5
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03
 
 
   LET mi_page_count = 100   # 每頁顯現最大資料筆數.
   LET li_reconstruct = TRUE
 
   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      IF (li_reconstruct) THEN
         MESSAGE ""
     
         IF (mi_need_cons) THEN
            CONSTRUCT ms_cons_where ON pmm01,pmn02,pmm09,pmn04,
                                       pmn041,pmn20,pmn82
                 FROM s_wafer[1].pmm01, s_wafer[1].pmn02,
                      s_wafer[1].pmm09, s_wafer[1].pmn04,
                      s_wafer[1].pmn041,s_wafer[1].pmn20,
                      s_wafer[1].pmn82
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            
            END CONSTRUCT
            IF INT_FLAG THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         ELSE
            LET ms_cons_where=' 1=1'
         END IF
     
         CALL wafer_qry_prep_result_set() 
 
         #如果沒有設定'每頁顯現資料筆數',則預設為所有資料一起顯現.
         IF (mi_page_count = 0) THEN
            LET mi_page_count = pmn_qry.getLength()
         END IF
 
         #如果所設定的'每頁顯現資料筆數'超過/等於所有資料,則要隱藏'上下頁'的按鈕
         IF (mi_page_count >= pmn_qry.getLength()) THEN
            LET ls_hide_act = "prevpage,nextpage"
         END IF
         IF (NOT mi_need_cons) THEN
            IF cl_null(ls_hide_act) THEN
               LET ls_hide_act = "reconstruct"
            ELSE
               LET ls_hide_act = "prevpage,nextpage,reconstruct"
            END IF 
         END IF
     
         LET li_start_index = 1
     
         LET li_reconstruct = FALSE
      END IF
     
      LET li_end_index = li_start_index + mi_page_count - 1
     
      IF (li_end_index > pmn_qry.getLength()) THEN
         LET li_end_index = pmn_qry.getLength()
      END IF
     
      CALL wafer_qry_set_display_data(li_start_index,li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file 
       WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file 
       WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || pmn_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN
         CALL wafer_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL wafer_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Parameter   	: none
# Return        : void
##################################################
FUNCTION wafer_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,
            pmm01    LIKE pmm_file.pmm01,                      
            pmn02    LIKE pmn_file.pmn02,                      
            pmm09    LIKE pmm_file.pmm09,                      
            pmc03    LIKE pmc_file.pmc03,                      
            pmn04    LIKE pmn_file.pmn04,                      
            pmn041   LIKE pmn_file.pmn041,                    
            pmn20    LIKE pmn_file.pmn20,                      
            pmn82    LIKE pmn_file.pmn82,                      
            qty      LIKE pmn_file.pmn20
   END RECORD
   DEFINE   l_n      LIKE type_file.num10
   DEFINE   l_sql    STRING
   DEFINE   l_sfa05  LIKE sfa_file.sfa05
 
 
 
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_wafer', 'pmn_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET ls_sql = "SELECT 'N',pmn01,pmn02,pmm09,pmc03,pmn04,pmn041, ",
                "       pmn20,pmn82,0 ",
                "  FROM pmn_file,pmm_file,pmc_file",
                " WHERE ",ms_cons_where,
                "   AND pmn01 = pmm01 AND pmm02 IN('WB0','WB2') ",
                "   AND pmmacti = 'Y' AND pmm25 <> '6' AND pmm09 = pmc01 " 
 
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED," ORDER BY pmn01,pmn02 "
 
  ##NO.FUN-980025 GP5.2 add--begin						
   IF (NOT mi_multi_sel ) THEN						
        CALL cl_parse_qry_sql( ls_sql, g_plant ) RETURNING ls_sql						
   END IF						
  ##NO.FUN-980025 GP5.2 add--end
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   FOR li_i = pmn_qry.getLength() TO 1 STEP -1
      CALL pmn_qry.deleteElement(li_i)
   END FOR
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO lr_qry.*
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
 
      #判斷是否已達選取上限
      IF li_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
   
      #撈取資料判斷
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM sfb_file,sfbi_file
       WHERE sfb86 = lr_qry.pmm01 
         AND sfbi01 = sfb01
         AND sfbiicd15 = lr_qry.pmn02
         AND sfb87 <> 'X' 
 
      IF l_n > 0 THEN
         LET l_n = 0   LET l_sfa05 = 0
         SELECT SUM(sfa05) INTO l_sfa05 
           FROM sfa_file,sfb_file,sfbi_file
          WHERE sfa01 = sfb01 AND sfb87 <> 'X'
            AND sfbi01 = sfb01
            AND sfb86 = lr_qry.pmm01 AND sfbiicd15 = lr_qry.pmn02
            AND sfa03 = lr_qry.pmn04
         IF cl_null(l_sfa05) THEN LET l_sfa05 = 0 END IF
         LET lr_qry.qty = lr_qry.pmn20 - l_sfa05
         IF lr_qry.qty <= 0 THEN CONTINUE FOREACH END IF
      ELSE
         LET lr_qry.qty = lr_qry.pmn20
      END IF
 
      LET pmn_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Parameter   	: pi_start_index   LIKE type_file.num10   所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10   所要顯現的查詢資料結束位置
# Return        : void
##################################################
FUNCTION wafer_qry_set_display_data(pi_start_index,pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_i             LIKE type_file.num10,
            li_j             LIKE type_file.num10
 
 
   #FOR li_i = pmn_qry_tmp.getLength() TO 1 STEP -1
   #   CALL pmn_qry_tmp.deleteElement(li_i)
   #END FOR
 
   CALL pmn_qry_tmp.clear()
 
   FOR li_i = pi_start_index TO pi_end_index
      LET pmn_qry_tmp[li_j+1].* = pmn_qry[li_i].*
      LET li_j = li_j + 1
   END FOR
 
   CALL SET_COUNT(pmn_qry_tmp.getLength())
END FUNCTION
 
##################################################
# Description  	: 採用INPUT ARRAY的方式來顯現查詢過後的資料.
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10   所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10   所要顯現的查詢資料結束位置
# Return   	: LIKE type_file.num5   是否繼續
#               : LIKE type_file.num5   是否重新查詢
#               : LIKE type_file.num10    改變後的起始位置
##################################################
FUNCTION wafer_qry_input_array(ps_hide_act,pi_start_index,pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   INPUT ARRAY pmn_qry_tmp WITHOUT DEFAULTS FROM s_wafer.* 
   ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
   #ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
 
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF NOT cl_null(ps_hide_act) THEN 
            CALL cl_set_act_visible(ps_hide_act,FALSE)
         END IF
 
      ON ACTION prevpage
         CALL GET_FLDBUF(s_wafer.check) RETURNING pmn_qry_tmp[ARR_CURR()].check
         CALL wafer_qry_reset_multi_sel(pi_start_index, pi_end_index)
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
         LET li_continue = TRUE
         EXIT INPUT
 
      ON ACTION nextpage
         CALL GET_FLDBUF(wafer_check) RETURNING pmn_qry_tmp[ARR_CURR()].check
         CALL wafer_qry_reset_multi_sel(pi_start_index, pi_end_index)
         IF ((pi_start_index + mi_page_count) <= pmn_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
         LET li_continue = TRUE
         EXIT INPUT
 
      ON ACTION refresh
         CALL wafer_qry_refresh()
         LET pi_start_index = 1
         LET li_continue = TRUE
         EXIT INPUT
 
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
         EXIT INPUT
 
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_wafer.check) RETURNING pmn_qry_tmp[ARR_CURR()].check
            CALL wafer_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL wafer_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                        #CHI-9C0048
            LET ms_ret1 = NULL       #CHI-9C0048
         END IF                      #CHI-9C0048
         LET li_continue = FALSE
         EXIT INPUT
 
      ON ACTION cancel
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF
         LET li_continue = FALSE
         EXIT INPUT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
      #No.FUN-840023 --start--
      ON ACTION qry_string
         CALL cl_qry_string("detail")
      #No.FUN-840023 ---end---
 
      ### FUN-880082 START ###
      ON ACTION selectall
         FOR li_i = 1 TO pmn_qry_tmp.getLength()
             LET pmn_qry_tmp[li_i].check = "Y"
         END FOR
 
      ON ACTION select_none
         FOR li_i = 1 TO pmn_qry_tmp.getLength()
             LET pmn_qry_tmp[li_i].check = "N"
         END FOR
      ### FUN-880082 END ###
 
   END INPUT
   RETURN li_continue,li_reconstruct,pi_start_index
 
END FUNCTION
 
##################################################
# Description  	: 重設查詢資料關於'check'欄位的值.
# Parameter   	: pi_start_index   LIKE type_file.num10   所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10   所要顯現的查詢資料結束位置
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION wafer_qry_reset_multi_sel(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_i             LIKE type_file.num10,
            li_j             LIKE type_file.num10
 
 
   FOR li_i = pi_start_index TO pi_end_index
      LET pmn_qry[li_i].check = pmn_qry_tmp[li_j+1].check
      LET li_j = li_j + 1
   END FOR
END FUNCTION
 
##################################################
# Description  	: 採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10   所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10   所要顯現的查詢資料結束位置
# Return   	: LIKE type_file.num5   是否繼續
#               : LIKE type_file.num5   是否重新查詢
#               : LIKE type_file.num10    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION wafer_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
 
 
   DISPLAY ARRAY pmn_qry_tmp TO s_wafer.*
      BEFORE DISPLAY
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF NOT cl_null(ps_hide_act) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
 
      ON ACTION prevpage
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
         LET li_continue = TRUE
         EXIT DISPLAY
 
      ON ACTION nextpage
         IF ((pi_start_index + mi_page_count) <= pmn_qry.getLength()) THEN
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
         CALL wafer_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
         EXIT DISPLAY
 
      ON ACTION cancel
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF
         LET li_continue = FALSE
         EXIT DISPLAY
 
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
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION wafer_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10
 
 
   FOR li_i = 1 TO pmn_qry.getLength()
      LET pmn_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Parameter   	: pi_sel_index   LIKE type_file.num10   所選擇的資料索引
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION wafer_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10 
 
 
   # GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO pmn_qry.getLength()
         IF (pmn_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
               CALL lsb_multi_sel.append(pmn_qry[li_i].pmm01 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || pmn_qry[li_i].pmm01 CLIPPED)
            END IF
         END IF    
      END FOR
      # 複選狀態只會有一組字串回傳值.
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = pmn_qry[pi_sel_index].pmm01 CLIPPED
      LET ms_ret2 = pmn_qry[pi_sel_index].pmn02 CLIPPED
   END IF
END FUNCTION
