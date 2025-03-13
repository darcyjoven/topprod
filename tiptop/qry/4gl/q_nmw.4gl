# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#{
# Program name  : q_nmw.4gl
# Program ver.  : 7.0
# Description   : 支票簿號碼檔查詢
# Date & Author : 20010/06/22 by Summer
# Memo          : 
# Modify.........: No:CHI-A60021 10/06/22 By Summer
#}
# Modify.........: No:TQC-B30123 11/03/15 By yinhy 支票薄號開窗可以帶出未勾選了“支票套印”的資資料

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,
         nmw01    LIKE nmw_file.nmw01,                     
         nma03    LIKE nma_file.nma03,                     
         nmw06    LIKE nmw_file.nmw06,                     
         nmw03    LIKE nmw_file.nmw03,                     
         nmw04    LIKE nmw_file.nmw04,                     
         nmw05    LIKE nmw_file.nmw05,                     
         nna03    LIKE nna_file.nna03,                     
         pcnt     LIKE type_file.num10
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,
         nmw01    LIKE nmw_file.nmw01,                     
         nma03    LIKE nma_file.nma03,                     
         nmw06    LIKE nmw_file.nmw06,                     
         nmw03    LIKE nmw_file.nmw03,                     
         nmw04    LIKE nmw_file.nmw04,                     
         nmw05    LIKE nmw_file.nmw05,                     
         nna03    LIKE nna_file.nna03,                     
         pcnt     LIKE type_file.num10
END RECORD

DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).
DEFINE   ms_cons_where    STRING                  #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10    #每頁顯現資料筆數.
DEFINE   ms_default1      STRING  
DEFINE   ms_ret1          STRING,
         ms_ret2          STRING,
         ms_ret3          STRING
DEFINE   g_bank_no        LIKE nmw_file.nmw01

FUNCTION q_nmw(pi_multi_sel,pi_need_cons,ps_default1,p_bank_no)
   DEFINE   pi_multi_sel   LIKE type_file.num5,
            pi_need_cons   LIKE type_file.num5,
            ps_default1    STRING,
            p_bank_no      LIKE nmw_file.nmw01
 
   LET ms_default1 = ps_default1
   LET g_bank_no= p_bank_no
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_nmw" ATTRIBUTE(STYLE="create_qry")

   CALL cl_ui_locale("q_nmw")

   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons

   #不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   #在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("nmw06,nmw03", "red")
   END IF

   CALL nmw_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 
   ELSE
      RETURN ms_ret1,ms_ret2,ms_ret3 
   END IF
END FUNCTION

##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2010/06/22 by Summer
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION nmw_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE.
            li_continue      LIKE type_file.num5      #是否繼續.
   DEFINE   li_start_index   LIKE type_file.num10,
            li_end_index     LIKE type_file.num10
   DEFINE   li_curr_page     LIKE type_file.num5
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03
 

   LET mi_page_count = 100 
   LET li_reconstruct = TRUE
 
   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""

      IF (li_reconstruct) THEN
         MESSAGE ""
     
         IF (mi_need_cons) THEN
          IF NOT cl_null(g_bank_no) THEN
            CONSTRUCT ms_cons_where ON nmw01, nmw06, nmw03, nmw04, nmw05      #CHI-A60021                             
                                  FROM s_nmw[1].nmw01,s_nmw[1].nmw06,s_nmw[1].nmw03,s_nmw[1].nmw04,s_nmw[1].nmw05
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            
            END CONSTRUCT
            LET ms_cons_where = ms_cons_where CLIPPED ,
                                " AND nmw01='",g_bank_no,"'"
          ELSE  CALL cl_opmsg('q')  
            CONSTRUCT ms_cons_where ON nmw01, nmw06, nmw03, nmw04, nmw05                                   
                                  FROM s_nmw[1].nmw01,s_nmw[1].nmw06,s_nmw[1].nmw03,s_nmw[1].nmw04,s_nmw[1].nmw05
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
                   CONTINUE CONSTRUCT
             
             END CONSTRUCT
             LET ms_cons_where = ms_cons_where CLIPPED     
          END IF
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
     
         CALL nmw_qry_prep_result_set() 
         #如果沒有設定'每頁顯現資料筆數',則預設為所有資料一起顯現.
         IF (mi_page_count = 0) THEN
            LET mi_page_count = ma_qry.getLength()
         END IF
         #如果所設定的'每頁顯現資料筆數'超過/等於所有資料,則要隱藏'上下頁'的按鈕.
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
     
      CALL nmw_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count

      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF

      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang

      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL nmw_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL nmw_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION

##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2010/06/22 by Summer
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION nmw_qry_prep_result_set()
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,
            nmw01    LIKE nmw_file.nmw01,                     
            nma03    LIKE nma_file.nma03,                     
            nmw06    LIKE nmw_file.nmw06,                     
            nmw03    LIKE nmw_file.nmw03,                     
            nmw04    LIKE nmw_file.nmw04,                     
            nmw05    LIKE nmw_file.nmw05,                     
            nna03    LIKE nna_file.nna03,                     
            pcnt     LIKE type_file.num10
   END RECORD
   DEFINE   l_point  LIKE type_file.num10,
            l_end    LIKE type_file.num10,
            l_being  LIKE type_file.num10,
            l_count2 LIKE type_file.num10,  #已用張數                                                                                         
            l_count4 LIKE type_file.num10,  #作廢張數                                                                                          
            l_pcnt   LIKE type_file.num10,  #可用張數
            l_cnt2   LIKE type_file.num10,   #領用張數
            l_nna04  LIKE nna_file.nna04,
            l_nna05  LIKE nna_file.nna05


   LET ls_sql = "SELECT 'N',nmw01,nma03,nmw06,nmw03,nmw04,nmw05,nna03,0",
                " FROM nmw_file,nna_file,nma_file",
                " WHERE ",ms_cons_where,
                "   AND nna01 = nmw01 ",
                "   AND nna021= nmw03 ",
                "   AND nna02 = nmw06 ",
                "   AND nna01 = nma01 ",
               # "   AND nna06 IN ('y','Y') ",     #TQC-B30123 mark
                " ORDER BY nmw01,nmw03,nmw06 "

   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   FOR li_i = ma_qry.getLength() TO 1 STEP -1
      CALL ma_qry.deleteElement(li_i)
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
      #----
      SELECT COUNT(*)                                                                                                   
        INTO l_count2 FROM nmd_file                                                                                       
       WHERE nmd03 = lr_qry.nmw01                                                                                             
         AND nmd31 = lr_qry.nmw06                                                                                             
         AND nmd02 BETWEEN lr_qry.nmw04 AND lr_qry.nmw05                                                                 
      SELECT COUNT(*)                                                                                                   
        INTO l_count4 FROM nnz_file                                                                                       
       WHERE nnz01 = lr_qry.nmw01                                                                                             
         AND nnz02 BETWEEN lr_qry.nmw04 AND lr_qry.nmw05                                                                 
      SELECT nna04,nna05 INTO l_nna04,l_nna05
        FROM nna_file,nma_file
       WHERE nna01 = lr_qry.nmw01
         AND nna02 = lr_qry.nmw06
         AND nna021= lr_qry.nmw03
         AND nna01 = nma01 AND nmaacti = 'Y'

      LET l_point = l_nna04 - l_nna05 + 1
      LET l_end   = lr_qry.nmw05[l_point,l_nna04]
      LET l_being = lr_qry.nmw04[l_point,l_nna04]
      LET l_cnt2 = (l_end - l_being) + 1 #領用張數
      LET l_pcnt = l_cnt2 - l_count2 - l_count4   #可用張數

      LET lr_qry.pcnt=l_pcnt
      #----
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION

##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2010/06/22 by Summer
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION nmw_qry_set_display_data(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_i             LIKE type_file.num10,
            li_j             LIKE type_file.num10
 

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
# Date & Author : 2010/06/22 by Summer
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION nmw_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5 
   DEFINE   li_i             LIKE type_file.num5
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_nma.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED)
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_nmw.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL nmw_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_nmw.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL nmw_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL nmw_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         CALL GET_FLDBUF(s_nmw.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL nmw_qry_reset_multi_sel(pi_start_index, pi_end_index)
         CALL nmw_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0
         IF (NOT mi_multi_sel) THEN
            LET ms_ret2 = ms_default1
         END IF

         LET li_continue = FALSE
     
         EXIT INPUT
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
   
      ON ACTION qry_string
         CALL cl_qry_string("detail")

      ON ACTION selectall
         FOR li_i = 1 TO ma_qry_tmp.getLength()
             LET ma_qry_tmp[li_i].check = "Y"
         END FOR

      ON ACTION select_none
         FOR li_i = 1 TO ma_qry_tmp.getLength()
             LET ma_qry_tmp[li_i].check = "N"
         END FOR

   END INPUT
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION

##################################################
# Description  	: 重設查詢資料關於'check'欄位的值.
# Date & Author : 2010/06/22 by Summer
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION nmw_qry_reset_multi_sel(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10 
   DEFINE   li_i             LIKE type_file.num10,
            li_j             LIKE type_file.num10 
 
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry[li_i].check = ma_qry_tmp[li_j+1].check
      LET li_j = li_j + 1
   END FOR
END FUNCTION

##################################################
# Description  	: 採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2010/06/22 by Summer
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION nmw_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10 
   DEFINE   li_continue      LIKE type_file.num5, 
            li_reconstruct   LIKE type_file.num5
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_nmw.*
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
         CALL nmw_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF

         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')

      ON ACTION qry_string
         CALL cl_qry_string("detail")

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION

##################################################
# Description   : 重設查詢資料.
# Date & Author : 2010/06/22 by Summer
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION nmw_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 


   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION

##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2010/06/22 by Summer
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION nmw_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10
 

   #GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF

   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
               CALL lsb_multi_sel.append(ma_qry[li_i].nmw06 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].nmw06 CLIPPED)
            END IF
         END IF    
      END FOR
      #複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].nmw06 CLIPPED
      LET ms_ret2 = ma_qry[pi_sel_index].nmw03 CLIPPED
      LET ms_ret3 = ma_qry[pi_sel_index].nna03 CLIPPED
   END IF
END FUNCTION
