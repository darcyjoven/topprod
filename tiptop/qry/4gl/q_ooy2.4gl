# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#{
# Program name  : q_ooy2.4gl
# Program ver.  : 7.0
# Description   : 單據性質查詢
# Date & Author : 2012/02/21 by Downheal
# Memo          : 改自q_ooy.4gl 目的為改傳入固定參數(p_type='21' AND '22')
# Modify        :
#}
# Modify.........: No.FUN-C20103 12/02/21 By Downheal 改傳入固定參數
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,
         ooyslip  LIKE ooy_file.ooyslip,
         ooydesc  LIKE ooy_file.ooydesc,
         ooyauno  LIKE ooy_file.ooyauno,
         ooytype  LIKE ooy_file.ooytype 
END RECORD

DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,
		   ooyslip      LIKE ooy_file.ooyslip,
		   ooydesc      LIKE ooy_file.ooydesc,
		   ooyauno      LIKE ooy_file.ooyauno,
		   ooytype      LIKE ooy_file.ooytype
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).
DEFINE   ms_cons_where    STRING                  #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10    #每頁顯現資料筆數.
DEFINE   ms_default1      STRING     
DEFINE   ms_ret1          STRING 
DEFINE   ms_type          LIKE ooy_file.ooytype
DEFINE   ms_sys           LIKE smu_file.smu03
 
 
FUNCTION q_ooy2(pi_multi_sel,pi_need_cons,ps_default1,p_type,p_sys)
   DEFINE   pi_multi_sel   LIKE type_file.num5,
            pi_need_cons   LIKE type_file.num5,
            p_type         LIKE ooy_file.ooytype, 
            p_sys          LIKE smu_file.smu03,
            ps_default1    STRING   
            {%與回傳欄位的個數相對應,格式為ps_default+流水號}
 
 
   LET ms_default1 = ps_default1
   LET ms_type = p_type
   LET ms_sys = p_sys
   LET ms_sys = UPSHIFT(ms_sys)
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_ooy2" ATTRIBUTE(STYLE="create_qry")
 
   CALL cl_ui_locale("q_ooy2")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("ooyslip", "red")
   END IF
 
   CALL ooy2_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 
   ELSE
      RETURN ms_ret1 
   END IF
END FUNCTION
 
##################################################
# Description   : 畫面顯現與資料的選擇.
# Date & Author : 2012/02/21 by downheal
# Parameter   	 : none
# Return   	: void
# Memo      :
# Modify   	:
##################################################
FUNCTION ooy2_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,    #是否隱藏'上下頁'的按鈕
            li_reconstruct   LIKE type_file.num5,    #是否重新CONSTRUCT.預設為TRUE
            li_continue      LIKE type_file.num5     #是否繼續
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
         LET ms_cons_where = "1=1"
         
         CALL ooy2_qry_prep_result_set() 
         # 如果沒有設定'每頁顯現資料筆數',則預設為所有資料一起顯現.
         IF (mi_page_count = 0) THEN
            LET mi_page_count = ma_qry.getLength()
         END IF
         # 如果所設定的'每頁顯現資料筆數'超過/等於所有資料,則要隱藏'上下頁'的按鈕.
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
     
      CALL ooy2_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' 
         AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' 
         AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || 
              li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL ooy2_qry_input_array(ls_hide_act, li_start_index, li_end_index) 
         RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL ooy2_qry_display_array(ls_hide_act, li_start_index, li_end_index) 
         RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2012/02/21 by downheal
# Parameter   	: none
# Return       : void
# Memo        	:
# Modify       :
##################################################
FUNCTION ooy2_qry_prep_result_set()
   DEFINE l_filter_cond STRING
   DEFINE ls_sql        STRING,
          ls_where      STRING
   DEFINE li_i          LIKE type_file.num10,
          l_begin_key   LIKE ooy_file.ooyslip
   DEFINE lr_qry   RECORD
          check    LIKE type_file.chr1,
          ooyslip  LIKE ooy_file.ooyslip,
          ooydesc  LIKE ooy_file.ooydesc,
          ooyauno  LIKE ooy_file.ooyauno,
          ooytype  LIKE ooy_file.ooytype 
   END RECORD
   DEFINE g_gen03  LIKE gen_file.gen03
   DEFINE l_n      LIKE type_file.num10
 
   LET l_begin_key = ' '
 
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_ooy', 'ooy_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF

   LET ls_sql = "SELECT 'N',ooyslip,ooydesc,ooyauno,ooytype ", 
                " FROM ooy_file ",
                " WHERE ooyacti = 'Y' AND ",ms_cons_where
                
   IF NOT mi_multi_sel THEN
      #FUN-C20103 傳入參數固定為 '21','22'
      LET ls_where = ls_where CLIPPED," AND ooytype='21' OR ooytype='22'" 
   END IF

   IF ms_type ='16' OR ms_type ='27' THEN
      LET ls_sql = ls_sql CLIPPED," AND ooydmy1 ='N' "
   END IF

   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED," ORDER BY ooyslip "
 
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

      SELECT zx03 INTO g_gen03 FROM zx_file where zx01=g_user   #抓此人所屬部門

      IF SQLCA.SQLCODE THEN
         LET g_gen03=NULL
      END IF
        #權限先check user再check部門
        SELECT COUNT(*) INTO l_n FROM smu_file WHERE smu01=lr_qry.ooyslip
           AND upper(smu03)=ms_sys
        IF l_n>0 THEN                    #USER權限存有資料,並g_user判斷是否存在
           SELECT COUNT(*) INTO l_n FROM smu_file WHERE smu01=lr_qry.ooyslip 
              AND smu02=g_user AND upper(smu03)=ms_sys
              
           IF l_n=0 THEN
               IF g_gen03 IS NULL THEN   #g_user沒有部門           
                   CONTINUE FOREACH
               ELSE                      #CHECK g_user部門是否存在                                                    
                  SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=lr_qry.ooyslip
                     AND smv02=g_gen03 AND upper(smv03)=ms_sys 
                  IF l_n=0 THEN
                     CONTINUE FOREACH
                  END IF
               END IF
           END IF
        ELSE   #CHECK Dept               
           SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=lr_qry.ooyslip 
              AND upper(smv03)=ms_sys
              
            IF l_n>0 THEN
               IF g_gen03 IS NULL THEN    #g_user沒有部門     
                   CONTINUE FOREACH 
               ELSE                       #CHECK g_user部門是否存在
                  SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=lr_qry.ooyslip 
                     AND smv02=g_gen03 AND upper(smv03)=ms_sys
                  IF l_n=0 THEN
                     CONTINUE FOREACH
                  END IF
               END IF             
            END IF
        END IF     
 
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2012/02/21 by downheal
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#              : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Memo        	:
# Modify       :
##################################################
FUNCTION ooy2_qry_set_display_data(pi_start_index, pi_end_index)
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
# Description  : 採用INPUT ARRAY的方式來顯現查詢過後的資料.
# Date & Author: 2012/02/21 by downheal
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#              : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#              : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	: SMALLINT   是否繼續
#           : SMALLINT   是否重新查詢
#           : INTEGER    改變後的起始位置
# Memo      :
# Modify   	:
##################################################
FUNCTION ooy2_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
   DEFINE   li_i             LIKE type_file.num5
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_ooy.* ATTRIBUTE
      (INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED)
      
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
         
      ON ACTION prevpage
         CALL GET_FLDBUF(s_ooy.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL ooy2_qry_reset_multi_sel(pi_start_index, pi_end_index)
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
         LET li_continue = TRUE
         EXIT INPUT
         
      ON ACTION nextpage
         CALL GET_FLDBUF(s_ooy.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL ooy2_qry_reset_multi_sel(pi_start_index, pi_end_index)
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
         LET li_continue = TRUE
         EXIT INPUT
         
      ON ACTION refresh
         CALL ooy2_qry_refresh()
         LET pi_start_index = 1
         LET li_continue = TRUE
         EXIT INPUT
         
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
         EXIT INPUT
         
      ON ACTION accept
         IF ARR_CURR()>0 THEN 
            CALL GET_FLDBUF(s_ooy.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL ooy2_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL ooy2_qry_accept(pi_start_index+ARR_CURR()-1)
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
# Description   : 重設查詢資料關於'check'欄位的值.
# Date & Author : 2012/02/21 by downheal
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#              : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	   : void
# Memo        	:
# Modify   	   :
##################################################
FUNCTION ooy2_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Description   : 採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2012/02/21 by downheal
# Parameter   	 : ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	: SMALLINT   是否繼續
#           : SMALLINT   是否重新查詢
#           : INTEGER    改變後的起始位置
# Memo      :
# Modify   	:
##################################################
FUNCTION ooy2_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_ooy.*
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
         CALL ooy2_qry_accept(pi_start_index+ARR_CURR()-1)
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
# Date & Author : 2012/02/21 by downheal
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION ooy2_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  : 選擇並確認資料.
# Date & Author: 2012/02/21 by downheal
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引
# Return   	   : void
# Memo        	:
# Modify   	   :
##################################################
FUNCTION ooy2_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10

   # GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
               CALL lsb_multi_sel.append(ma_qry[li_i].ooyslip CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].ooyslip CLIPPED)
            END IF
         END IF    
      END FOR
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].ooyslip CLIPPED
      {%設定多個回傳值.格式為ms_ret+流水號}
   END IF
END FUNCTION
