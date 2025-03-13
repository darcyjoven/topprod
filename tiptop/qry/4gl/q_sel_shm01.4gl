# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Program name...: q_sel_shm01.4gl
# Descriptions...: FUN-C30163  By pauline 

DATABASE ds
GLOBALS "../../config/top.global"
DEFINE   ma_qry        DYNAMIC ARRAY OF RECORD
         check         LIKE type_file.chr1,   #如果不需要複選資料,則不要設定此欄
         shm01         LIKE shm_file.shm01,
         shm012        LIKE shm_file.shm012,
         shm05         LIKE shm_file.shm05,
         ima02         LIKE ima_file.ima02,
         ima021        LIKE ima_file.ima021,
         shm08         LIKE shm_file.shm08,
         shm09         LIKE shm_file.shm09,
         qcf22         LIKE qcf_file.qcf22
                       END RECORD
DEFINE   ma_qry_tmp    DYNAMIC ARRAY OF RECORD
         check         LIKE type_file.chr1,
         shm01         LIKE shm_file.shm01,
         shm012        LIKE shm_file.shm012,
         shm05         LIKE shm_file.shm05,
         ima02         LIKE ima_file.ima02,
         ima021        LIKE ima_file.ima021,
         shm08         LIKE shm_file.shm08,
         shm09         LIKE shm_file.shm09,
         qcf22         LIKE qcf_file.qcf22
                       END RECORD
DEFINE   g_msg         LIKE type_file.chr1000,
         g_gen03       LIKE gen_file.gen03
 
DEFINE   mi_multi_sel  LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE)
DEFINE   mi_need_cons  LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE)
DEFINE   ms_cons_where STRING                  #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count LIKE type_file.num10    #每頁顯現資料筆數.
DEFINE   ms_ret1       STRING
DEFINE   ms_default1   STRING
DEFINE   g_qcf01       LIKE qcf_file.qcf01
FUNCTION q_sel_shm01(pi_multi_sel,pi_need_cons,ps_default1,p_qcf01)
   DEFINE   pi_multi_sel   LIKE type_file.num5,
            pi_need_cons   LIKE type_file.num5
   DEFINE   ps_default1    STRING,
            p_qcf01        LIKE qcf_file.qcf01 
   DEFINE   cb             ui.ComboBox
 
   WHENEVER ERROR CONTINUE
   LET ms_default1 = ps_default1
   LET g_qcf01 = p_qcf01
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_sel_shm01" ATTRIBUTE(STYLE="create_qry")
 
   CALL cl_ui_locale("q_sel_shm01")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   #不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   #在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("shm01", "red")
   END IF
 
   CALL shm01_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1
   ELSE
      RETURN ms_ret1
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
##################################################
FUNCTION shm01_qry_sel()
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
            CONSTRUCT ms_cons_where ON shm01,shm012,shm05,ima02,ima021,shm08,shm09  
               FROM s_shm[1].shm01,s_shm[1].shm012,s_shm[1].shm05,s_shm[1].ima02,
                    s_shm[1].ima021,s_shm[1].shm08,s_shm[1].shm09
 
            ON ACTION controlg      
               CALL cl_cmdask()     
 
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
            ON ACTION about         
               CALL cl_about()      
 
            ON ACTION help          
               CALL cl_show_help()  
 
            END CONSTRUCT
 
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
 
         CALL shm01_qry_prep_result_set()
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
 
      CALL shm01_qry_set_display_data(li_start_index, li_end_index)
 
      LET li_curr_page = li_end_index / mi_page_count
 
      #若最後一頁不到整除的數目, 避免頁次不會再往上加
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN
         CALL shm01_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL shm01_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
 
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
##################################################
FUNCTION shm01_qry_prep_result_set()
   DEFINE l_filter_cond STRING
   DEFINE ls_sql        STRING 
   DEFINE l_sql         STRING
   DEFINE ls_where      STRING
   DEFINE li_i          LIKE type_file.num10
   DEFINE lr_qry        RECORD
         check    LIKE type_file.chr1,
         shm01         LIKE shm_file.shm01,
         shm012        LIKE shm_file.shm012,
         shm05         LIKE shm_file.shm05,
         ima02         LIKE ima_file.ima02,
         ima021        LIKE ima_file.ima021,
         shm08         LIKE shm_file.shm08,
         shm09         LIKE shm_file.shm09,
         qcf22         LIKE qcf_file.qcf22
                        END RECORD
 
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_sel_shm01', 'shm_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   
   LET ls_sql = "SELECT 'N',shm01,shm012,shm05,ima02,ima021,shm08,shm09 ,'' ",
               "   FROM shm_file, ima_file ",
               "   WHERE shm05 = ima_file.ima01 ",
               "     AND  shm28 = 'N' ",
               "     AND ",ms_cons_where,
               "   ORDER BY shm01 " 

                 
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   CALL ma_qry.clear()
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO lr_qry.*
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
      LET lr_qry.qcf22 = 0 

      CALL shm01_get_qcf22(lr_qry.shm01,lr_qry.shm012,lr_qry.shm05) RETURNING lr_qry.qcf22
      IF cl_null(lr_qry.qcf22) THEN
         LET lr_qry.qcf22 = 0 
      END IF
      
      IF lr_qry.qcf22 = 0 THEN
         CONTINUE FOREACH 
      END IF 

      #判斷是否已達選取上限
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
##################################################
FUNCTION shm01_qry_set_display_data(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_i             LIKE type_file.num10,
            li_j             LIKE type_file.num10
 
 
   CALL ma_qry_tmp.clear()
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry_tmp[li_j+1].* = ma_qry[li_i].*
      LET li_j = li_j + 1
   END FOR
 
   CALL SET_COUNT(ma_qry_tmp.getLength())
END FUNCTION
##################################################
# Description  	: 採用INPUT ARRAY的方式來顯現查詢過後的資料.
##################################################
FUNCTION shm01_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
   DEFINE   li_i             LIKE type_file.num5
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_shm.*
      ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED)
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_shm.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL shm01_qry_reset_multi_sel(pi_start_index, pi_end_index)
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
         LET li_continue = TRUE
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_shm.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL shm01_qry_reset_multi_sel(pi_start_index, pi_end_index)
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
         LET li_continue = TRUE
         EXIT INPUT
      ON ACTION refresh
         CALL shm01_qry_refresh()
         LET pi_start_index = 1
         LET li_continue = TRUE
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE 
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN
            CALL GET_FLDBUF(s_shm.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL shm01_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL shm01_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE
            LET ms_ret1 = NULL
         END IF
         LET li_continue = FALSE
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF
         LET li_continue = FALSE
         EXIT INPUT
 
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
 
      ON ACTION qry_string
         CALL cl_qry_string("detail")
   
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
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
##################################################
FUNCTION shm01_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
##################################################
FUNCTION shm01_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
 
 
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
         CALL shm01_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
 
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF
 
         LET li_continue = FALSE
         EXIT DISPLAY

      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')

      ON ACTION qry_string
         CALL cl_qry_string("detail")

      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
   END DISPLAY
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description   : 重設查詢資料.
##################################################
FUNCTION shm01_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10

   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
##################################################
FUNCTION shm01_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10
 
   #若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
               CALL lsb_multi_sel.append(ma_qry[li_i].shm01 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].shm01 CLIPPED)
            END IF
         END IF
      END FOR
      #複選狀態只會有一組字串回傳值.
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].shm01 CLIPPED
   END IF
END FUNCTION

#計算工單待驗數量
FUNCTION shm01_get_qcf22(p_shm01,p_shm012,p_shm05)
DEFINE p_shm01         LIKE shm_file.shm01
DEFINE p_shm012        LIKE shm_file.shm012
DEFINE p_shm05         LIKE shm_file.shm05
DEFINE l_err           LIKE ze_file.ze01
DEFINE l_qcf22         LIKE qcf_file.qcf22        
DEFINE l_acc_qty       LIKE qcf_file.qcf22        
DEFINE l_ecu012        LIKE ecu_file.ecu012       
DEFINE l_sgm03         LIKE sgm_file.sgm03        
DEFINE l_max_qcf22     LIKE qcf_file.qcf22
DEFINE l_sfb93         LIKE sfb_file.sfb93
DEFINE l_sfb05         LIKE sfb_file.sfb05
DEFINE l_sfb06         LIKE sfb_file.sfb06
DEFINE post_qty        LIKE qcf_file.qcf22
DEFINE l_ima55         LIKE ima_file.ima55
 
   LET l_qcf22 = 0   
   LET l_acc_qty = 0 
   LET l_max_qcf22=0
 
   SELECT ima55 INTO l_ima55 FROM ima_file WHERE ima01 = p_smh05

   SELECT sfb93,sfb06,sfb05 INTO l_sfb93,l_sfb06,l_sfb05
     FROM sfb_file
    WHERE sfb01 = p_shm012

   IF l_sfb93='Y' AND g_sma.sma541='Y' THEN
      SELECT ecu012 INTO l_ecu012 FROM ecu_file
       WHERE ecu01 = l_sfb05
         AND ecu02 = l_sfb06
         AND (ecu015 IS NULL OR ecu015=' ')
   END IF

   IF cl_null(l_ecu012) THEN LET l_ecu012 = ' ' END IF

   SELECT MAX(sgm03) INTO l_sgm03 FROM sgm_file
   WHERE sgm01 = p_shm01 
     AND sgm012= l_ecu012

   SELECT (sgm311+sgm315+sgm316+sgm317)
     INTO l_max_qcf22
     FROM sgm_file
    WHERE sgm01 = p_shm01
      AND sgm012 = l_ecu012
      AND sgm03  = l_sgm03

   IF cl_null(l_acc_qty) OR l_acc_qty =0 THEN
      LET l_acc_qty = l_max_qcf22
   END IF
   SELECT SUM(qcf22) INTO l_qcf22 FROM qcf_file
    WHERE qcf02 = p_shm012
      AND qcf01<>g_qcf01
      AND qcf03 = p_shm01 
   IF cl_null(l_qcf22) THEN LET l_qcf22 = 0 END IF

   SELECT SUM(qcf091) INTO post_qty FROM qcf_file
    WHERE qcf02 = g_qcf.qcf02
      AND qcf14='Y'   #確認
      AND qcf01<>g_qcf01
      AND qcf03 = p_shm01 
   IF post_qty IS NULL THEN LET post_qty=0 END IF 

   LET l_qcf22 = l_qcf22 + post_qty

   LET l_acc_qty = l_max_qcf22 - l_qcf22

   LET l_acc_qty = s_digqty(l_acc_qty,l_ima55)

   RETURN l_acc_qty 

END FUNCTION
 
#FUN-C30163 
