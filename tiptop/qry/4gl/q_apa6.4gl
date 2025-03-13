# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#{
# Program name  : q_apa6.4gl
# Description   : 成本分攤來源帳款查詢
# Date & Author : MOD-730048 07/03/14 By Smapmin 
# Modify........: No.MOD-820050 08/03/12 By Smapmin 資料來源增加13/16/25類
# Modify.........: No.MOD-830144 08/03/19 By Smapmin 來源帳款日期不需卡成本關帳日.
#}
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.FUN-880082 08/08/29 By tsai_yen 開窗全選功能
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No:MOD-A80107 10/08/13 By Dido 檢核分攤資料應過濾作廢資料 
# Modify.........: No:MOD-A80248 10/09/02 By Dido 若已被沖帳應過濾不可再做分攤 
# Modify.........: No:CHI-B90029 11/10/06 By Polly 修正aapt900分攤來源的帳款編號開窗時篩選資料有誤
# Modify.........: No:FUN-C70093 12/08/17 By minpp 增加傳入得參數pi_prog,pi_aqb02,pi_ac,pi_rec_b 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,
         apa01    LIKE apa_file.apa01,
         apa02    LIKE apa_file.apa02, 
         apa06    LIKE apa_file.apa06,
         apa07    LIKE apa_file.apa07,
         apa31    LIKE apa_file.apa31
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,
         apa01    LIKE apa_file.apa01,
         apa02    LIKE apa_file.apa02, 
         apa06    LIKE apa_file.apa06,
         apa07    LIKE apa_file.apa07,
         apa31    LIKE apa_file.apa31
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5   #是否需要複選資料(TRUE/FALSE).
DEFINE   mi_need_cons     LIKE type_file.num5   #是否需要CONSTRUCT(TRUE/FALSE).
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10    #每頁顯現資料筆數.
DEFINE   ms_ret1          STRING     
DEFINE   mi_prog          LIKE type_file.chr20  #程式代號  #FUN-C70093
DEFINE   mi_aqb02         LIKE aqb_file.aqb02              #FUN-C70093
DEFINE   mi_ac,mi_rec_b   LIKE type_file.num5              #FUN-C70093            
#FUNCTION q_apa6(pi_multi_sel,pi_need_cons)                #FUN-C70093
 FUNCTION q_apa6(pi_multi_sel,pi_need_cons,pi_prog,pi_aqb02,pi_ac,pi_rec_b)        #FUN-C70093
   DEFINE   pi_multi_sel   LIKE type_file.num5,
            pi_need_cons   LIKE type_file.num5,
            pi_prog        LIKE type_file.chr20,  #程式代號 #FUN-C70093
            pi_aqb02       LIKE aqb_file.aqb02,             #FUN-C70093    
            pi_ac,pi_rec_b  LIKE type_file.num5              #FUN-C70093
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_apa6" ATTRIBUTE(STYLE="create_qry")  
 
   CALL cl_ui_locale("q_apa6")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
   LET mi_prog      = pi_prog         #FUN-C70093
   LET mi_aqb02     = pi_aqb02        #FUN-C70093
   LET mi_ac        = pi_ac           #FUN-C70093
   LET mi_rec_b     = pi_rec_b        #FUN-C70093
   #不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   #在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("apa01", "red")
   END IF
 
   CALL apa6_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 
   ELSE
      RETURN ms_ret1 
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION apa6_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,   #是否隱藏'上下頁'的按鈕.
            li_reconstruct   LIKE type_file.num5,   #是否重新CONSTRUCT.預設為TRUE.
            li_continue      LIKE type_file.num5    #是否繼續.
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
            CONSTRUCT ms_cons_where ON apa01,apa02,apa06,apa07,apa31
                                  FROM s_apa[1].apa01,s_apa[1].apa02,
                                       s_apa[1].apa06,s_apa[1].apa07,
                                       s_apa[1].apa31
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            
            END CONSTRUCT
 
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
 
         CALL apa6_qry_prep_result_set()
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
 
      CALL apa6_qry_set_display_data(li_start_index, li_end_index)
 
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN
         CALL apa6_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL apa6_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
 
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION apa6_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,
            apa01    LIKE apa_file.apa01,
            apa02    LIKE apa_file.apa02, 
            apa06    LIKE apa_file.apa06,
            apa07    LIKE apa_file.apa07,
            apa31    LIKE apa_file.apa31
   END RECORD
   DEFINE   lr_arr   RECORD
            check    LIKE type_file.chr1,
            apa00    LIKE apa_file.apa00,
            apa01    LIKE apa_file.apa01,
            apa02    LIKE apa_file.apa02, 
            apa06    LIKE apa_file.apa06,
            apa07    LIKE apa_file.apa07,
            apa31    LIKE apa_file.apa31
   END RECORD
   DEFINE   l_aqb04  LIKE aqb_file.aqb04
   DEFINE   l_cnt    LIKE type_file.num5   #MOD-820050
   DEFINE   l_aqb02  LIKE aqb_file.aqb02   #FUN-C70093 
   DEFINE   l_tt     LIKE apa_file.apa00   #FUN-C70093  
   DEFINE   l_sql    STRING                #FUN-C70093
   DEFINE   l_apa00  LIKE apa_file.apa00   #FUN-C70093 
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_apa6', 'apa_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET ls_sql = "SELECT 'N',apa00,apa01,apa02,apa06,apa07,apa31 ",
                "  FROM apa_file",
                " WHERE apaacti='Y' ",
               #"   AND (apa00='12' OR apa00='22' OR apa00='23') ",   #MOD-820050
                "   AND (apa00='12' OR apa00='22' OR apa00='23' OR ",  #MOD-820050
                "        apa00='13' OR apa00='16' OR apa00='25') ",   #MOD-820050
                "   AND apa41='Y' ",
                "   AND ",ms_cons_where
 #              " ORDER BY apa01"                           #FUN-C70093
  #FUN-C70093---ADD--STR
  IF mi_prog='aapt910' THEN  
     IF (NOT cl_null(mi_aqb02) AND mi_ac>1) OR (NOT cl_null(mi_aqb02) AND mi_rec_b>1) THEN
         SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01=mi_aqb02
         IF l_apa00 MATCHES '1*' THEN
            LET l_tt='1%'
         ELSE
            LET l_tt='2%'
         END IF
         LET ls_sql = ls_sql CLIPPED , " AND apa00 LIKE '",l_tt,"' "
      END IF
   END IF
   LET ls_sql=ls_sql CLIPPED," ORDER BY apa01"
   #FUN-C70093---ADD---END
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   FOR li_i = ma_qry.getLength() TO 1 STEP -1
      CALL ma_qry.deleteElement(li_i)
   END FOR
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO lr_arr.*
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
 
      IF lr_arr.apa00 = '22' THEN
         LET lr_arr.apa31 = lr_arr.apa31 * -1
      END IF
      IF cl_null(lr_arr.apa31) THEN LET lr_arr.apa31 = 0 END IF
 
     #-MOD-A80248-add-
      LET l_cnt = 0 
      IF g_apz.apz27 = 'N' THEN
         SELECT COUNT(*) INTO l_cnt 
           FROM apa_file
          WHERE apa01 = lr_arr.apa01 
            AND (apa34-apa35) = 0 
            AND apa42 = 'N'
            AND apa00 = '23'               #CHI-B90029 add
      ELSE
         SELECT COUNT(*) INTO l_cnt 
           FROM apa_file
          WHERE apa01 = lr_arr.apa01 
            AND apa73 = 0 
            AND apa42 = 'N'
            AND apa00 = '23'               #CHI-B90029 add
      END IF
      IF l_cnt > 0 THEN
         CONTINUE FOREACH
      END IF
     #-MOD-A80248-end-

      IF NOT mi_multi_sel THEN 
        #SELECT SUM(aqb04) INTO l_aqb04 FROM aqb_file             #MOD-A80107 mark
         SELECT SUM(aqb04) INTO l_aqb04 FROM aqb_file,aqa_file    #MOD-A80107
           WHERE aqb02 = lr_arr.apa01
             AND aqa01 = aqb01 AND aqaconf <> 'X'                 #MOD-A80107
         IF cl_null(l_aqb04) THEN LET l_aqb04 = 0 END IF
         
         IF l_aqb04 = lr_arr.apa31 THEN 
            CONTINUE FOREACH
         END IF
         #-----MOD-820050---------
         IF lr_arr.apa00 = '16' THEN
            LET l_cnt=0
            SELECT COUNT(*) INTO l_cnt FROM apb_file
              WHERE apb01=lr_arr.apa01
                AND apb21 IS NOT NULL
            IF l_cnt > 0 THEN
               CONTINUE FOREACH
            END IF
         END IF
         #-----MOD-830144--------- 
         #IF lr_arr.apa02 <= g_sma.sma53 THEN
         #   CONTINUE FOREACH
         #END IF
         #-----END MOD-830144-----
         #-----END MOD-820050-----
      END IF
 
      LET lr_qry.apa01 = lr_arr.apa01
      LET lr_qry.apa02 = lr_arr.apa02
      LET lr_qry.apa06 = lr_arr.apa06
      LET lr_qry.apa07 = lr_arr.apa07
      LET lr_qry.apa31 = lr_arr.apa31
 
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: pi_start_index   LIKE type_file.num10   所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10   所要顯現的查詢資料結束位置
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION apa6_qry_set_display_data(pi_start_index, pi_end_index)
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
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10   所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10   所要顯現的查詢資料結束位置
# Return   	: LIKE type_file.num5   是否繼續
#               : LIKE type_file.num5   是否重新查詢
#               : LIKE type_file.num10    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION apa6_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_apa.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_apa.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_apa.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL apa6_qry_reset_multi_sel(pi_start_index, pi_end_index)
 
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
 
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_apa.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL apa6_qry_reset_multi_sel(pi_start_index, pi_end_index)
 
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
 
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION refresh
         CALL apa6_qry_refresh()
 
         LET pi_start_index = 1
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_apa.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL apa6_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL apa6_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                        #CHI-9C0048
            LET ms_ret1 = NULL       #CHI-9C0048
         END IF                      #CHI-9C0048
         LET li_continue = FALSE
 
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 
         IF (NOT mi_multi_sel) THEN
         END IF
 
         LET li_continue = FALSE
 
         EXIT INPUT
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
   
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
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: pi_start_index   LIKE type_file.num10   所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10   所要顯現的查詢資料結束位置
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION apa6_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10   所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10   所要顯現的查詢資料結束位置
# Return   	: LIKE type_file.num5   是否繼續
#               : LIKE type_file.num5   是否重新查詢
#               : LIKE type_file.num10    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION apa6_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_apa.*
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
         CALL apa6_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
 
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 
         IF (NOT mi_multi_sel) THEN
         END IF
 
         LET li_continue = FALSE
 
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
   
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
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION apa6_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: pi_sel_index   LIKE type_file.num10   所選擇的資料索引
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION apa6_qry_accept(pi_sel_index)
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
               CALL lsb_multi_sel.append(ma_qry[li_i].apa01 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].apa01 CLIPPED)
            END IF
         END IF
      END FOR
      #複選狀態只會有一組字串回傳值.
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].apa01 CLIPPED
      {%設定多個回傳值.格式為ms_ret+流水號}
   END IF
END FUNCTION
#MOD-730048
