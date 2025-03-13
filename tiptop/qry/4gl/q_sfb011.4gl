# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Program name...: q_sfb011.4gl
# Descriptions...: FUN-C30163  By pauline 

DATABASE ds
GLOBALS "../../config/top.global"
DEFINE   ma_qry        DYNAMIC ARRAY OF RECORD
         check         LIKE type_file.chr1,   #如果不需要複選資料,則不要設定此欄位	#No.FUN-680131 VARCHAR(1)
         sfb01         LIKE sfb_file.sfb01,
         sfb13         LIKE sfb_file.sfb13,
         sfb05         LIKE sfb_file.sfb05,
         ima02         LIKE ima_file.ima02,
         ima021        LIKE ima_file.ima021,
         sfb04         LIKE sfb_file.sfb04,
         sfb08         LIKE sfb_file.sfb08,
         sfb081        LIKE sfb_file.sfb081,
         sfb09         LIKE sfb_file.sfb09,
         qcf22         LIKE qcf_file.qcf22
                       END RECORD
DEFINE   ma_qry_tmp    DYNAMIC ARRAY OF RECORD
         check         LIKE type_file.chr1,
         sfb01         LIKE sfb_file.sfb01,
         sfb13         LIKE sfb_file.sfb13,
         sfb05         LIKE sfb_file.sfb05,
         ima02         LIKE ima_file.ima02,
         ima021        LIKE ima_file.ima021,
         sfb04         LIKE sfb_file.sfb04,
         sfb08         LIKE sfb_file.sfb08,
         sfb081        LIKE sfb_file.sfb081,
         sfb09         LIKE sfb_file.sfb09,
         qcf22         LIKE qcf_file.qcf22
                       END RECORD
DEFINE   g_msg         LIKE type_file.chr1000,
         g_gen03       LIKE gen_file.gen03
 
DEFINE   mi_multi_sel  LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE)
DEFINE   mi_need_cons  LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE)
DEFINE   ms_cons_where STRING                  #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count LIKE type_file.num10    #每頁顯現資料筆數.
DEFINE   ms_ret1       STRING
DEFINE   ms_ret2       STRING
DEFINE   ms_default1   STRING
DEFINE   ms_default2   STRING
DEFINE   g_where       STRING
DEFINE   g_qcf01        LIKE qcf_file.qcf01
DEFINE   g_qcf04        LIKE qcf_file.qcf04

FUNCTION q_sfb011(pi_multi_sel,pi_need_cons,p_where,ps_default1,ps_default2,p_qcf01,p_qcf04)
   DEFINE   pi_multi_sel   LIKE type_file.num5,
            pi_need_cons   LIKE type_file.num5
   DEFINE   ps_default1    STRING,
            ps_default2    STRING,
            p_where        STRING 
   DEFINE   p_qcf01        LIKE qcf_file.qcf01
   DEFINE   p_qcf04        LIKE qcf_file.qcf04
   DEFINE   cb             ui.ComboBox
 
   WHENEVER ERROR CONTINUE
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_sfb011" ATTRIBUTE(STYLE="create_qry")
 
   CALL cl_ui_locale("q_sfb011")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
   LET ms_default1 = ps_default1
   LET ms_default2 = ps_default2
   LET g_where = p_where
   LET g_qcf01 = p_qcf01
   LET g_qcf04 = p_qcf04
   IF cl_null(g_where) THEN LET g_where = " 1=1 "  END IF
    
   IF cl_null(g_qcf04) THEN LET g_qcf04 = g_today END IF
   #不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   #在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("sfb01", "red")
   END IF
 
   CALL sfb011_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1
   ELSE
      RETURN ms_ret1,ms_ret2
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
##################################################
FUNCTION sfb011_qry_sel()
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
            CONSTRUCT ms_cons_where ON sfb01,sfb13,sfb05,ima02,ima021,sfb04,sfb08,sfb081,sfb09
               FROM s_sfb[1].sfb01,s_sfb[1].sfb13,s_sfb[1].sfb05,s_sfb[1].ima02,s_sfb[1].ima021,
                    s_sfb[1].sfb04,s_sfb[1].sfb08,s_sfb[1].sfb081,s_sfb[1].sfb09
 
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
 
         CALL sfb011_qry_prep_result_set()
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
 
      CALL sfb011_qry_set_display_data(li_start_index, li_end_index)
 
      LET li_curr_page = li_end_index / mi_page_count
 
      #若最後一頁不到整除的數目, 避免頁次不會再往上加
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN
         CALL sfb011_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL sfb011_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
 
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
##################################################
FUNCTION sfb011_qry_prep_result_set()
   DEFINE l_filter_cond STRING
   DEFINE ls_sql        STRING 
   DEFINE l_sql         STRING
   DEFINE ls_where      STRING
   DEFINE li_i          LIKE type_file.num10
   DEFINE l_sfb39       LIKE sfb_file.sfb39
   DEFINE l_sfb93       LIKE sfb_file.sfb93 
   DEFINE lr_qry        RECORD
         check         LIKE type_file.chr1,
         sfb01         LIKE sfb_file.sfb01,
         sfb13         LIKE sfb_file.sfb13,
         sfb05         LIKE sfb_file.sfb05,
         ima02         LIKE ima_file.ima02,
         ima021        LIKE ima_file.ima021,
         sfb04         LIKE sfb_file.sfb04,
         sfb08         LIKE sfb_file.sfb08,
         sfb081        LIKE sfb_file.sfb081,
         sfb09         LIKE sfb_file.sfb09,
         qcf22         LIKE qcf_file.qcf22
                        END RECORD
 
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_sfb011', 'oga_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
  
   IF cl_null(ms_cons_where) THEN LET ms_cons_where = " 1=1 " END IF 
   LET ls_sql = "SELECT 'N', sfb01, sfb13 ,sfb05,ima02,ima021,sfb04,sfb08,sfb081,sfb09 ,'' ",
               "   FROM sfb_file,ima_file",
               "   WHERE sfb05 = ima01  ",
               "     AND  ((sfb39='1' AND sfb081 > (sfb11+sfb09)) OR sfb39='2') ",
               "     AND  sfb87!='X' ",
               "     AND sfb94 = 'Y' AND sfb04 != '8'  ",
               "     AND ",ms_cons_where,
               "   ORDER BY sfb01 " 

                 
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
      SELECT sfb39,sfb93 INTO l_sfb39,l_sfb93 FROM sfb_file WHERE sfb01 = lr_qry.sfb01
      CALL sfb011_get_qcf22(lr_qry.sfb01, lr_qry.sfb05,lr_qry.sfb08,l_sfb39,l_sfb93) RETURNING lr_qry.qcf22
      IF cl_null(lr_qry.qcf22) THEN
         LET lr_qry.qcf22 = 0 
      END IF
      
      IF lr_qry.qcf22 = 0 OR lr_qry.qcf22 < 0 THEN
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
FUNCTION sfb011_qry_set_display_data(pi_start_index, pi_end_index)
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
FUNCTION sfb011_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
   DEFINE   li_i             LIKE type_file.num5
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_sfb.*
      ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED)
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_sfb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL sfb011_qry_reset_multi_sel(pi_start_index, pi_end_index)
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
         LET li_continue = TRUE
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_sfb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL sfb011_qry_reset_multi_sel(pi_start_index, pi_end_index)
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
         LET li_continue = TRUE
         EXIT INPUT
      ON ACTION refresh
         CALL sfb011_qry_refresh()
         LET pi_start_index = 1
         LET li_continue = TRUE
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE 
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN
            CALL GET_FLDBUF(s_sfb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL sfb011_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL sfb011_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE
            LET ms_ret1 = NULL
            LET ms_ret2 = NULL
         END IF
         LET li_continue = FALSE
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
            LET ms_ret2 = ms_default2
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
FUNCTION sfb011_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
FUNCTION sfb011_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_sfb.*
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
         CALL sfb011_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
 
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
            LET ms_ret2 = ms_default2
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
FUNCTION sfb011_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10

   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
##################################################
FUNCTION sfb011_qry_accept(pi_sel_index)
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
               CALL lsb_multi_sel.append(ma_qry[li_i].sfb01 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].sfb01 CLIPPED)
            END IF
         END IF
      END FOR
      #複選狀態只會有一組字串回傳值.
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].sfb01 CLIPPED
      LET ms_ret2 = ma_qry[pi_sel_index].sfb05 CLIPPED
   END IF
END FUNCTION

#計算工單待驗數量
FUNCTION sfb011_get_qcf22(p_qcf02, p_qcf021,p_sfb08,p_sfb39,p_sfb93)
   DEFINE p_qcf02     LIKE qcf_file.qcf02 
   DEFINE p_qcf021    LIKE qcf_file.qcf021
   DEFINE p_sfb08     LIKE sfb_file.sfb08
   DEFINE p_sfb39     LIKE sfb_file.sfb39
   DEFINE p_sfb93     LIKE sfb_file.sfb93
   DEFINE l_acc_qty   LIKE qcf_file.qcf22
   DEFINE l_sfv09     LIKE sfv_file.sfv09
   DEFINE l_ima153    LIKE ima_file.ima153  
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_cnt1      LIKE type_file.num5
   DEFINE l_sfb08     LIKE sfb_file.sfb08
   DEFINE l_ima55     LIKE ima_file.ima55
   DEFINE l_gfe03     LIKE gfe_file.gfe03
   DEFINE l_ecm03     LIKE ecm_file.ecm03  
   DEFINE l_ecm012    LIKE ecm_file.ecm012 
   DEFINE l_max_qcf22 LIKE qcf_file.qcf22
   DEFINE l_cnt3      LIKE type_file.num20
   DEFINE l_min_set   LIKE type_file.num20
   DEFINE l_char      LIKE type_file.chr1
   DEFINE un_post_qty LIKE qcf_file.qcf22
   DEFINE post_qty    LIKE qcf_file.qcf22 

   CALL s_get_ima153(p_qcf021) RETURNING l_ima153  

   IF p_sfb93='Y' THEN #是否使用製程
      LET l_max_qcf22=0

      CALL s_minp(p_qcf02,g_sma.sma73,l_ima153,'','','',g_qcf04)   #FUN-C70037
        RETURNING l_cnt3,l_min_set

      IF l_cnt3 !=0  THEN
         CALL cl_err('s_minp()','asf-549',0)
      ELSE
         IF l_char != 'N' THEN
            SELECT COUNT(*) INTO l_cnt FROM sfa_file WHERE sfa01 = p_qcf02
            SELECT COUNT(*) INTO l_cnt1 FROM sfa_file WHERE sfa01 = p_qcf02 AND sfa065 <>0
            IF l_cnt IS NULL  THEN LET l_cnt=0 END IF
            IF l_cnt1 IS NULL  THEN LET l_cnt1=0 END IF
            IF l_cnt = l_cnt1 THEN
            ELSE
               SELECT COUNT(*)  INTO l_cnt FROM sfa_file WHERE sfa01 = p_qcf02
                  AND sfa26 NOT MATCHES '[SUZ]' AND sfa065=0 AND sfa161>0 AND sfa11<>'E'     
               IF l_cnt <= 0 THEN
                  SELECT COUNT(*)  INTO l_cnt FROM sfa_file WHERE sfa01 = p_qcf02
                     AND sfa26 NOT MATCHES '[SUZ]' AND sfa161>0 AND (sfa11='E'OR sfa065 > 0)  
                  IF l_cnt > 0 THEN ELSE
                     IF g_sma.sma73 != 'N' THEN
                        SELECT ima55 INTO l_ima55  FROM sfb_file,ima_file
                         WHERE sfb01 = p_qcf02 AND sfb05 = ima01
                        SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01 = l_ima55
                        IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
                        LET l_min_set = s_trunc(l_min_set,l_gfe03)
                     END IF
                  END IF
               ELSE
                  IF g_sma.sma73 != 'N' THEN
                     SELECT ima55 INTO l_ima55  FROM sfb_file,ima_file
                      WHERE sfb01 = p_qcf02 AND sfb05 = ima01
                     SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01 = l_ima55
                     IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
                     LET l_min_set = s_trunc(l_min_set,l_gfe03)
                  END IF
               END IF
            END IF
         END IF
         IF p_sfb39 = "2" THEN
            LET l_min_set = p_sfb08
         END IF
      END IF

      CALL s_schdat_max_ecm03(p_qcf02) RETURNING l_ecm012,l_ecm03  
      SELECT (ecm311+ecm315) INTO l_max_qcf22 #良品轉出+bonus
        FROM ecm_file
       WHERE ecm01 = p_qcf02    #工單單號
         AND ecm03 = l_ecm03  AND ecm012 = l_ecm012            
     
      IF NOT cl_null(g_qcf01) THEN
         SELECT SUM(qcf22) INTO un_post_qty FROM qcf_file
          WHERE qcf02 = p_qcf02
            AND qcf14 = 'N'   #未確認
            AND qcf01 <> g_qcf01
     
         SELECT SUM(qcf091) INTO post_qty FROM qcf_file
          WHERE qcf02 = p_qcf02
            AND qcf14 = 'Y'   #確認
            AND qcf01 <> g_qcf01
            AND qcf09 <> '2'     #MOD-910106 add
      ELSE
         SELECT SUM(qcf22) INTO un_post_qty FROM qcf_file
          WHERE qcf02 = p_qcf02
            AND qcf14 = 'N'   #未確認
     
         SELECT SUM(qcf091) INTO post_qty FROM qcf_file
          WHERE qcf02 = p_qcf02
            AND qcf14 = 'Y'   #確認
            AND qcf09 <> '2'
      END IF
     
      IF un_post_qty IS NULL THEN
         LET un_post_qty = 0
      END IF
      IF post_qty IS NULL THEN
         LET post_qty = 0
      END IF
      IF l_min_set < l_max_qcf22 THEN
         LET l_acc_qty = l_min_set - un_post_qty - post_qty
      ELSE
         LET l_acc_qty = l_max_qcf22 - un_post_qty - post_qty
      END IF  
      RETURN l_acc_qty
   ELSE
      LET l_min_set = 0
      CALL s_minp(p_qcf02,g_sma.sma73,l_ima153,'','','',g_qcf04)   
           RETURNING l_cnt3,l_min_set
      IF l_cnt3 !=0  THEN
         CALL cl_err('s_minp()','asf-549',0)
      ELSE
         IF l_char != 'N' THEN
            SELECT COUNT(*) INTO l_cnt FROM sfa_file WHERE sfa01 = p_qcf02
            SELECT COUNT(*) INTO l_cnt1 FROM sfa_file WHERE sfa01 = p_qcf02 AND sfa065 <>0
            IF l_cnt IS NULL  THEN LET l_cnt=0 END IF
            IF l_cnt1 IS NULL  THEN LET l_cnt1=0 END IF
            IF l_cnt = l_cnt1 THEN
            ELSE
               SELECT COUNT(*)  INTO l_cnt FROM sfa_file WHERE sfa01 = p_qcf02
                  AND sfa26 NOT MATCHES '[SUZ]' AND sfa065=0 AND sfa161>0 AND sfa11<>'E'  
               IF l_cnt <= 0 THEN
                  SELECT COUNT(*)  INTO l_cnt FROM sfa_file WHERE sfa01 = p_qcf02
                     AND sfa26 NOT MATCHES '[SUZ]' AND sfa161>0 AND (sfa11='E'OR sfa065 > 0)          
                  IF l_cnt > 0 THEN ELSE
                     IF g_sma.sma73 != 'N' THEN
                        SELECT ima55 INTO l_ima55  FROM sfb_file,ima_file
                         WHERE sfb01 = p_qcf02 AND sfb05 = ima01
                        SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01 = l_ima55
                        IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
                        LET l_min_set = s_trunc(l_min_set,l_gfe03)
                     END IF
                  END IF
               ELSE
                  IF g_sma.sma73 != 'N' THEN
                     SELECT ima55 INTO l_ima55  FROM sfb_file,ima_file
                      WHERE sfb01 = p_qcf02 AND sfb05 = ima01
                     SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01 = l_ima55
                     IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
                     LET l_min_set = s_trunc(l_min_set,l_gfe03)
                  END IF
               END IF
            END IF
         END IF
      END IF
         
      IF NOT cl_null(g_qcf01) THEN
         SELECT SUM(qcf22) INTO un_post_qty FROM qcf_file
          WHERE qcf02 = p_qcf02
            AND qcf14='N'   #未確認
            AND qcf01 <> g_qcf01
      
         SELECT SUM(qcf091) INTO post_qty FROM qcf_file
          WHERE qcf02 = p_qcf02
            AND qcf14='Y'   #確認
            AND qcf01<>g_qcf01
      ELSE
         SELECT SUM(qcf22) INTO un_post_qty FROM qcf_file
          WHERE qcf02 = p_qcf02
            AND qcf14='N'   #未確認
      
         SELECT SUM(qcf091) INTO post_qty FROM qcf_file
          WHERE qcf02 = p_qcf02
            AND qcf14='Y'   #確認
      END IF
      
      IF cl_null(un_post_qty) THEN LET un_post_qty=0 END IF
      IF cl_null(post_qty) THEN LET post_qty=0 END IF
      
      IF cl_null(l_min_set) THEN LET l_min_set  =0 END IF
      
      LET l_acc_qty = l_min_set - un_post_qty - post_qty
      
      RETURN l_acc_qty
   END IF
END FUNCTION

#FUN-C30163 
