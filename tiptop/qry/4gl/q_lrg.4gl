# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Program name...: q_sel_lrg.4gl
# Descriptions...: FUN-CA0158  By Belle  

DATABASE ds
GLOBALS "../../config/top.global"
DEFINE   ma_qry        DYNAMIC ARRAY OF RECORD
         check         LIKE type_file.chr1,   #如果不需要複選資料,則不要設定此欄位	#No.FUN-680131 VARCHAR(1)
         lrf01         LIKE lrf_file.lrf02,   #券號
         lpx02         LIKE lpx_file.lpx02    #券種
                       END RECORD
DEFINE   ma_qry_tmp    DYNAMIC ARRAY OF RECORD
         check         LIKE type_file.chr1,
         lrf01         LIKE lrf_file.lrf02,   #券號
         lpx02         LIKE lpx_file.lpx02    #券種
                       END RECORD
DEFINE   g_msg         LIKE type_file.chr1000,
         g_gen03       LIKE gen_file.gen03
 
DEFINE   mi_multi_sel  LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE)
DEFINE   mi_need_cons  LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE)
DEFINE   ms_cons_where STRING                  #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count LIKE type_file.num10    #每頁顯現資料筆數.
DEFINE   ms_ret1       STRING
DEFINE   ms_default1   STRING
DEFINE   g_date1       LIKE type_file.dat
DEFINE   g_date2       LIKE type_file.dat

FUNCTION q_lrg(pi_multi_sel,pi_need_cons,ps_default1,ps_yy1,ps_mm1,ps_yy2,ps_mm2)
   DEFINE   pi_multi_sel   LIKE type_file.num5,
            pi_need_cons   LIKE type_file.num5
   DEFINE   ps_default1    STRING,
            ps_yy1         LIKE type_file.chr4,
            ps_yy2         LIKE type_file.chr4,
            ps_mm1         LIKE type_file.chr2,
            ps_mm2         LIKE type_file.chr2
   DEFINE   cb             ui.ComboBox
 
   WHENEVER ERROR CONTINUE
   LET ms_default1 = ps_default1
   IF cl_null(ms_default1) THEN LET ms_default1 = g_plant END IF
   LET g_date1 = MDY(ps_mm1,'1',ps_yy1)
   IF ps_mm2 = 12 THEN
      LET g_date2 = MDY('1','1',ps_yy2 +1) -1
   ELSE
      LET g_date2 = MDY(ps_mm2+1,'1',ps_yy2) -1
   END IF
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_lrg" ATTRIBUTE(STYLE="create_qry")
 
   CALL cl_ui_locale("q_lrg")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   #不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   #在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("lrf01", "red")
   END IF
 
   CALL lrg_qry_sel()
 
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
FUNCTION lrg_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE.	#No.FUN-680131 SMALLINT
            li_continue      LIKE type_file.num5      #是否繼續.	#No.FUN-680131 SMALLINT
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
            CONSTRUCT ms_cons_where ON lrf01,lpx02
                                  FROM s_lrg[1].lrf01, s_lrg[1].lpx02
 
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
 
         CALL lrg_qry_prep_result_set()
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
 
      CALL lrg_qry_set_display_data(li_start_index, li_end_index)
 
      LET li_curr_page = li_end_index / mi_page_count
 
      #若最後一頁不到整除的數目, 避免頁次不會再往上加
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN
         CALL lrg_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL lrg_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
 
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
##################################################
FUNCTION lrg_qry_prep_result_set()
   DEFINE l_filter_cond STRING
   DEFINE ls_sql        STRING 
   DEFINE l_sql         STRING
   DEFINE ls_where      STRING
   DEFINE li_i          LIKE type_file.num10
   DEFINE l_n           LIKE type_file.num5
   DEFINE l_tok         base.StringTokenizer
   DEFINE l_plant       LIKE azw_file.azw01
   DEFINE lr_qry        RECORD
                         check    LIKE type_file.chr1,
                         lrf01    LIKE lrf_file.lrf02,   #券號
                         lpx02    LIKE lpx_file.lpx02    #券種
                        END RECORD
 
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_lrg', 'lrg_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   
   LET l_tok = base.StringTokenizer.create(ms_default1,'|')
   WHILE l_tok.hasMoreTokens()
      LET l_plant = l_tok.nextToken()     
      SELECT COUNT(*) INTO l_n FROM azw_file 
       WHERE azw01 = l_plant
      IF l_n > 0 THEN
         LET l_sql = " SELECT DISTINCT 'N',ima01,ima02 FROM ima_file WHERE ima01 IN ",
                     "       (  SELECT DISTINCT lrg02 FROM ",cl_get_target_table(l_plant,'lrg_file'),
                     "                     JOIN ",cl_get_target_table(l_plant,'lrl_file'), " ON lrg01 = lrl01 ",
                     "             WHERE lrl11  = 'Y' AND lrl15='0' AND lrgplant ='",l_plant,"'",
                     "               AND lrl13 BETWEEN CAST('",g_date1,"' AS DATE) AND CAST('",g_date2,"' AS DATE)",
                     "        UNION ALL ",
                     "          SELECT DISTINCT lpx32 FROM ",cl_get_target_table(l_plant,'lpx_file') ," JOIN lqe_file ON lqe02 = lpx01 ",
                     "            WHERE lqe01 IN ( SELECT lrf02 FROM ", cl_get_target_table(l_plant,'lrf_file') ,
                     "                                          JOIN ",cl_get_target_table(l_plant,'lrj_file'), " ON lrf01 = lrj01",
                     "                                         WHERE lrj10 = 'Y' AND lrj14 = '0' AND lrfplant='",l_plant,"'",
                     "                                AND lrj12 BETWEEN CAST('",g_date1,"' AS DATE) AND CAST('",g_date2,"' AS DATE)) )"
         IF cl_null(ls_sql) THEN
            LET ls_sql = l_sql
         ELSE
            LET ls_sql = ls_sql, " UNION ", l_sql
         END IF
      END IF
   END WHILE
                 
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   CALL ma_qry.clear()
 
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
      
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
##################################################
FUNCTION lrg_qry_set_display_data(pi_start_index, pi_end_index)
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
FUNCTION lrg_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
   DEFINE   li_i             LIKE type_file.num5
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_lrg.*
      ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED)
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_lrg.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL lrg_qry_reset_multi_sel(pi_start_index, pi_end_index)
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
         LET li_continue = TRUE
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_lrg.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL lrg_qry_reset_multi_sel(pi_start_index, pi_end_index)
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
         LET li_continue = TRUE
         EXIT INPUT
      ON ACTION refresh
         CALL lrg_qry_refresh()
         LET pi_start_index = 1
         LET li_continue = TRUE
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE 
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN
            CALL GET_FLDBUF(s_lrg.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL lrg_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL lrg_qry_accept(pi_start_index+ARR_CURR()-1)
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
FUNCTION lrg_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
FUNCTION lrg_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_lrg.*
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
         CALL lrg_qry_accept(pi_start_index+ARR_CURR()-1)
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
FUNCTION lrg_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10

   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
##################################################
FUNCTION lrg_qry_accept(pi_sel_index)
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
               CALL lsb_multi_sel.append(ma_qry[li_i].lrf01 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].lrf01 CLIPPED)
            END IF
         END IF
      END FOR
      #複選狀態只會有一組字串回傳值.
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].lrf01 CLIPPED
   END IF
END FUNCTION
#FUN-CA0158
