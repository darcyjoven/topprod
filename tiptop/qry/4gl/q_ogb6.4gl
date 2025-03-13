# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Program name...: q_ogb6.4gl
# Descriptions...: FUN-C30163  By pauline 

DATABASE ds
GLOBALS "../../config/top.global"
DEFINE   ma_qry        DYNAMIC ARRAY OF RECORD
         check         LIKE type_file.chr1,   #如果不需要複選資料,則不要設定此欄位	#No.FUN-680131 VARCHAR(1)
         oga01         LIKE oga_file.oga01,
         oga02         LIKE oga_file.oga02,
         ogb03         LIKE ogb_file.ogb03,
         ogb04         LIKE ogb_file.ogb04,
         ogb06         LIKE ogb_file.ogb06,
         ogb09         LIKE ogb_file.ogb09,
         ogb12         LIKE ogb_file.ogb12,
         ima02         LIKE ima_file.ima02,
         oga04         LIKE oga_file.oga04,
         occ02         LIKE occ_file.occ02,
         qcs22         LIKE qcs_file.qcs22
                       END RECORD
DEFINE   ma_qry_tmp    DYNAMIC ARRAY OF RECORD
         check         LIKE type_file.chr1,
         oga01         LIKE oga_file.oga01,
         oga02         LIKE oga_file.oga02,
         ogb03         LIKE ogb_file.ogb03,
         ogb04         LIKE ogb_file.ogb04,
         ogb06         LIKE ogb_file.ogb06,
         ogb09         LIKE ogb_file.ogb09,
         ogb12         LIKE ogb_file.ogb12,
         ima02         LIKE ima_file.ima02,
         oga04         LIKE oga_file.oga04,
         occ02         LIKE occ_file.occ02,
         qcs22         LIKE qcs_file.qcs22 
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
DEFINE   g_show_qcs22  LIKE type_file.chr1    #是否顯示待驗量
DEFINE   g_qcs00       LIKE qcs_file.qcs00    #資料來源 
DEFINE   g_cmd         LIKE type_file.chr1      #處理狀態
DEFINE   g_qcs05_o     LIKE qcs_file.qcs05      #分批順序

FUNCTION q_ogb6(pi_multi_sel,pi_need_cons,p_where,ps_default1,ps_default2,p_show_qcs22,p_qcs00,p_cmd,p_qcs05_o)
   DEFINE   pi_multi_sel   LIKE type_file.num5,
            pi_need_cons   LIKE type_file.num5
   DEFINE   ps_default1    STRING,
            ps_default2    STRING,
            p_where        STRING,
            p_show_qcs22   LIKE type_file.chr1,     #是否顯示待驗量 
            p_qcs00        LIKE qcs_file.qcs00,     #資料來源 
            p_cmd          LIKE type_file.chr1,     #處理狀態
            p_qcs05_o      LIKE qcs_file.qcs05      #分批順序 
   DEFINE   cb             ui.ComboBox
 
   WHENEVER ERROR CONTINUE
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_ogb6" ATTRIBUTE(STYLE="create_qry")
 
   CALL cl_ui_locale("q_ogb6")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
   LET ms_default1 = ps_default1
   LET ms_default2 = ps_default2
   LET g_where = p_where
   LET g_show_qcs22 = p_show_qcs22   
   LET g_qcs00 = p_qcs00
   LET g_cmd = p_cmd
   LET g_qcs05_o = p_qcs05_o
   IF cl_null(g_where) THEN LET g_where = " 1=1 "  END IF
   IF cl_null(g_show_qcs22) THEN LET g_show_qcs22 = 'N' END IF 
    
   IF g_qcs00 = '5' THEN
      CALL cl_set_comp_visible("ima02,oga04,occ02",FALSE)
   END IF
   IF g_qcs00 = '6' THEN
      CALL cl_set_comp_visible("ogb06,ogb09,ogb12",FALSE)   
   END IF
 
   #不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   #在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("oga01", "red")
   END IF
 
   CALL ogb6_qry_sel()
 
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
FUNCTION ogb6_qry_sel()
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
            CONSTRUCT ms_cons_where ON oga01,oga02,ogb03,ogb04,ogb06,ogb09,ogb12 ,ima02,oga04,occ02 
               FROM s_ogb[1].oga01,s_ogb[1].oga02,s_ogb[1].ogb03,s_ogb[1].ogb04,s_ogb[1].ogb06,
                    s_ogb[1].ogb09,s_ogb[1].ogb12,s_ogb[1].ima02,s_ogb[1].oga04,s_ogb[1].occ02
 
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
 
         CALL ogb6_qry_prep_result_set()
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
 
      CALL ogb6_qry_set_display_data(li_start_index, li_end_index)
 
      LET li_curr_page = li_end_index / mi_page_count
 
      #若最後一頁不到整除的數目, 避免頁次不會再往上加
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN
         CALL ogb6_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL ogb6_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
 
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
##################################################
FUNCTION ogb6_qry_prep_result_set()
   DEFINE l_filter_cond STRING
   DEFINE ls_sql        STRING 
   DEFINE l_sql         STRING
   DEFINE ls_where      STRING
   DEFINE li_i          LIKE type_file.num10
   DEFINE lr_qry        RECORD
         check         LIKE type_file.chr1,
         oga01         LIKE oga_file.oga01,
         oga02         LIKE oga_file.oga02,
         ogb03         LIKE ogb_file.ogb03,
         ogb04         LIKE ogb_file.ogb04,
         ogb06         LIKE ogb_file.ogb06,
         ogb09         LIKE ogb_file.ogb09,
         ogb12         LIKE ogb_file.ogb12,    
         ima02         LIKE ima_file.ima02,    
         oga04         LIKE oga_file.oga04,
         occ02         LIKE occ_file.occ02,
         qcs22         LIKE qcs_file.qcs22 
                        END RECORD
 
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_ogb6', 'oga_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   
   LET ls_sql = "SELECT 'N', oga01,oga02,ogb03,ogb04,ogb06,ogb09,ogb12 ,ima02,oga04,occ02,'' ",
               "   FROM oga_file,ogb_file,ima_file,occ_file ",
               "   WHERE oga01 = ogb01 ",
               "     AND ogb04 = ima01 ",
               "     AND oga04 = occ01 ",
               "     AND ogaconf = 'Y' ",
               "     AND ogapost = 'N' ",
               "     AND ogb19 = 'Y' ",
               "     AND ",g_where,
               "     AND ",ms_cons_where,
               "   ORDER BY oga01 " 

                 
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   CALL ma_qry.clear()
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO lr_qry.*
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
      LET lr_qry.qcs22 = 0 

      CALL ogb6_get_qcs22(g_qcs00,lr_qry.oga01,lr_qry.ogb03,lr_qry.ogb04) RETURNING lr_qry.qcs22
      IF cl_null(lr_qry.qcs22) THEN
         LET lr_qry.qcs22 = 0 
      END IF
      
      IF lr_qry.qcs22 = 0 OR lr_qry.qcs22 < 0 THEN
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
FUNCTION ogb6_qry_set_display_data(pi_start_index, pi_end_index)
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
FUNCTION ogb6_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
   DEFINE   li_i             LIKE type_file.num5
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_ogb.*
      ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED)
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_ogb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL ogb6_qry_reset_multi_sel(pi_start_index, pi_end_index)
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
         LET li_continue = TRUE
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_ogb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL ogb6_qry_reset_multi_sel(pi_start_index, pi_end_index)
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
         LET li_continue = TRUE
         EXIT INPUT
      ON ACTION refresh
         CALL ogb6_qry_refresh()
         LET pi_start_index = 1
         LET li_continue = TRUE
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE 
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN
            CALL GET_FLDBUF(s_ogb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL ogb6_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL ogb6_qry_accept(pi_start_index+ARR_CURR()-1)
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
FUNCTION ogb6_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
FUNCTION ogb6_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_ogb.*
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
         CALL ogb6_qry_accept(pi_start_index+ARR_CURR()-1)
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
FUNCTION ogb6_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10

   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
##################################################
FUNCTION ogb6_qry_accept(pi_sel_index)
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
               CALL lsb_multi_sel.append(ma_qry[li_i].oga01 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].oga01 CLIPPED)
            END IF
         END IF
      END FOR
      #複選狀態只會有一組字串回傳值.
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].oga01 CLIPPED
      LET ms_ret2 = ma_qry[pi_sel_index].ogb03 CLIPPED
   END IF
END FUNCTION

#計算工單待驗數量
FUNCTION ogb6_get_qcs22(p_qcs00,p_oga01,p_ogb03,p_ogb04)
   DEFINE p_qcs00         LIKE qcs_file.qcs00
   DEFINE p_oga01         LIKE oga_file.oga01
   DEFINE p_ogb03         LIKE ogb_file.ogb03
   DEFINE p_ogb04         LIKE ogb_file.ogb04  
   DEFINE l_qcs22         LIKE qcs_file.qcs22
   DEFINE l_qcs22s        LIKE qcs_file.qcs22
   DEFINE l_rvb07s        LIKE rvb_file.rvb07      
   DEFINE l_qcs091        LIKE qcs_file.qcs091 
   DEFINE l_qsa06         LIKE qsa_file.qsa06
   DEFINE l_ima44         LIKE ima_file.ima44 

   LET l_qcs22 = 0 
   LET l_qcs22s = 0 
   LET l_rvb07s = 0 
   LET l_qcs091 = 0 
   CASE
      WHEN p_qcs00 = '1'
         #收貨量允許有小數位
         SELECT rvb07 INTO l_rvb07s FROM rvb_file
          WHERE rvb01 = p_oga01 
            AND rvb02 = p_ogb03 
      WHEN p_qcs00 = 'A' OR p_qcs00 = 'B'
         SELECT inb16 INTO l_rvb07s 
           FROM inb_file
          WHERE inb01 = p_oga01 
            AND inb03 = p_ogb03 
      WHEN p_qcs00 = 'C'
         SELECT imn10 INTO l_rvb07s
           FROM imn_file
          WHERE imn01 = p_oga01 
            AND imn02 = p_ogb03 
      WHEN p_qcs00 = 'D'
         SELECT imn22 INTO l_rvb07s
           FROM imn_file
          WHERE imn01 = p_oga01 
            AND imn02 = p_ogb03
      WHEN p_qcs00 = 'E'
         SELECT imp04 INTO l_rvb07s
           FROM imp_file
          WHERE imp01 = p_oga01 
            AND imp02 = p_ogb03
      WHEN p_qcs00 = 'F'
         SELECT imq07 INTO l_rvb07s
           FROM imq_file
          WHERE imq01 = p_oga01 
            AND imq02 = p_ogb03
      WHEN p_qcs00 = 'G'
         SELECT qsa06 INTO l_rvb07s
           FROM qsa_file
          WHERE qsa01 = p_oga01 
      WHEN p_qcs00 = 'H'
         SELECT ohb12 INTO l_rvb07s
           FROM ohb_file
          WHERE ohb01 = p_oga01 
            AND ohb03 = p_ogb03
      WHEN p_qcs00 = '5' OR p_qcs00 = '6'
         SELECT ogb12 INTO l_rvb07s
           FROM ogb_file
          WHERE ogb01 = p_oga01 
            AND ogb03 = p_ogb03
      WHEN p_qcs00 = '7'
         SELECT srg05 INTO l_rvb07s
           FROM srg_file
          WHERE srg01 = p_oga01 
            AND srg02 = p_ogb03
   END CASE

   IF SQLCA.sqlcode OR cl_null(l_rvb07s) THEN
      LET l_rvb07s = 0
   END IF

   IF p_qcs00 NOT MATCHES '[2Z56]' THEN 
      # 若判斷qcs22=0 才重計會造成先入驗退量後打收貨單時,不會重計l_rvb07s, 造成送驗量不合理也沒控卡
         #送驗量允許有小數位
         IF g_cmd = 'a' THEN   #新增狀態
            SELECT SUM(qcs22) INTO l_qcs22s FROM qcs_file
             WHERE qcs01 = p_oga01 
               AND qcs02 = p_ogb03
               AND qcs14 != 'X'
               AND qcs00 IN ('1','A','B','C','D','E','F','G','H')  
         ELSE                  #修改狀態
            SELECT SUM(qcs22) INTO l_qcs22s FROM qcs_file
             WHERE qcs01 = p_oga01
               AND qcs02 = p_ogb03
               AND qcs14 != 'X'
               AND qcs00 IN ('1','A','B','C','D','E','F','G','H')
               AND NOT qcs05 = g_qcs05_o   #當為修改狀態時,必須要扣除已送驗量
         END IF
         IF STATUS OR l_qcs22s IS NULL THEN
            LET l_qcs22s = 0
         END IF
         LET l_qcs22 = l_rvb07s - l_qcs22s
         SELECT ima44 INTO l_ima44 FROM ima_file
          WHERE ima01 = p_ogb04 
         LET l_qcs22 = s_digqty(l_qcs22,l_ima44)
   END IF
   IF p_qcs00 MATCHES '[56H]' THEN   
         SELECT SUM(qcs22) INTO l_qcs22 FROM qcs_file
          WHERE qcs01 = p_oga01 
            AND qcs02 = p_ogb03
            AND qcs14 = 'N'
            AND qcs00 IN ('5','6')
         IF STATUS OR l_qcs22 IS NULL THEN
            LET l_qcs22 = 0
         END IF
         SELECT SUM(qcs091) INTO l_qcs091 FROM qcs_file
          WHERE qcs01 = p_oga01 
            AND qcs02 = p_ogb03
            AND qcs14 = 'Y'
            AND qcs00 IN ('5','6')
         IF STATUS OR l_qcs091 IS NULL THEN
            LET l_qcs091 = 0
         END IF
         LET l_qcs22s = l_qcs22 + l_qcs091
         LET l_qcs22 = l_rvb07s - l_qcs22s
         SELECT ima44 INTO l_ima44 FROM ima_file
          WHERE ima01 = p_ogb04
         LET l_qcs22 = s_digqty(l_qcs22,l_ima44)
   END IF 

   IF p_qcs00 = 'G' THEN
      SELECT qsa06 INTO l_qsa06
        FROM qsa_file
       WHERE qsa01 = p_oga01 
         AND qsa08 = 'Y'
         AND qsa06 > 0
   END IF

   RETURN l_qcs22

END FUNCTION

#FUN-C30163 
