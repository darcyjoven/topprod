# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#{
# Program name  : q_apy2.4gl
# Program ver.  : 7.0
# Description   : 單據性質查詢
# Input parameter: p_kind 單據性質 (*:表示所有的單據性質)
#                  p_key 單別
#                  p_sys 系統別
# Date & Author : 2012/02/21 by Downheal
# Memo          : 改傳入固定參數(p_kind='21','22','26')
# Modify        :
#}
# Modify........: No.FUN-C20103 12/02/21 By Downheal 改傳入固定參數

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         apyslip  LIKE apy_file.apyslip,
         apydesc  LIKE apy_file.apydesc,
         apyauno  LIKE apy_file.apyauno,
         apydmy2  LIKE apy_file.apydmy2
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         apyslip      LIKE apy_file.apyslip,
         apydesc      LIKE apy_file.apydesc,
         apyauno      LIKE apy_file.apyauno,
         apydmy2      LIKE apy_file.apydmy2
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_default1      STRING
DEFINE   ms_ret1          STRING
DEFINE   mi_kind          LIKE apy_file.apykind    #單據性質
DEFINE   mi_sys           LIKE zz_file.zz011      #No.FUN-680131 VARCHAR(3)
 
FUNCTION q_apy2(pi_multi_sel,pi_need_cons,ps_default1,p_kind,p_sys)
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    STRING  ,
            p_kind         LIKE apy_file.apykind,   #單據性質
            p_sys          LIKE zz_file.zz011   	#No.FUN-680131 VARCHAR(3)
 
 
   LET ms_default1 = ps_default1
   LET mi_kind = p_kind
   LET mi_sys  = p_sys
   LET mi_sys  = UPSHIFT(mi_sys) #TQC-670008 add
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_apy2" ATTRIBUTE(STYLE="create_qry") #No.FUN-660161
 
   CALL cl_ui_locale("q_apy2")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 2003/09/16 by Hiko : 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("apyslip", "red")
   END IF
 
   CALL apy2_qry_sel()
 
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
FUNCTION apy2_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 	#No.FUN-680131 SMALLINT
            li_continue      LIKE type_file.num5      #是否繼續.	#No.FUN-680131 SMALLINT
   DEFINE   li_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_curr_page     LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03
 
 
   LET mi_page_count = 100
   LET li_reconstruct = TRUE
 
   WHILE TRUE
      CLEAR FORM
 
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      LET ms_cons_where = " 1=1"
      IF (li_reconstruct) THEN  #No.TQC-970258
         MESSAGE ""
 
         #No.TQC-970258  --Begin
         IF (mi_need_cons) THEN
            CONSTRUCT BY NAME ms_cons_where ON apyslip,apydesc,apyauno,apydmy2
 
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
         #No.TQC-970258  --End
 
         CALL apy2_qry_prep_result_set()
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
#              LET ls_hide_act = "reconstruct"  #No.TQC-970258
            ELSE
#              LET ls_hide_act = "prevpage,nextpage,reconstruct"  #No.TQC-970258
#              LET ls_hide_act = "prevpage,nextpage"              #No.TQC-970258
            END IF
         END IF
 
         LET li_start_index = 1
 
         LET li_reconstruct = FALSE
      END IF
 
      LET li_end_index = li_start_index + mi_page_count - 1
 
      IF (li_end_index > ma_qry.getLength()) THEN
         LET li_end_index = ma_qry.getLength()
      END IF
 
      CALL apy2_qry_set_display_data(li_start_index, li_end_index)
 
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN
         CALL apy2_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL apy2_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
 
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description   : 準備查詢畫面的資料集.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: none
# Return       : void
# Memo        	:
# Modify       :
##################################################
FUNCTION apy2_qry_prep_result_set()
   DEFINE l_filter_cond STRING
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,
            apyslip  LIKE apy_file.apyslip,
            apydesc  LIKE apy_file.apydesc,
            apyauno  LIKE apy_file.apyauno,
            apydmy2  LIKE apy_file.apydmy2
   END RECORD
   DEFINE   g_gen03  LIKE gen_file.gen03
   DEFINE   l_n      LIKE type_file.num10
 

   LET l_filter_cond = cl_get_extra_cond_for_qry('q_apy', 'apy_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF

   LET ls_sql = "SELECT 'N',apyslip,apydesc,apyauno,apydmy2",
                " FROM apy_file ",
                " WHERE apyacti = 'Y' AND ",ms_cons_where
   IF NOT mi_multi_sel THEN
      #IF mi_kind != '*' THEN   #若指定單據性質
      # No.FUN-C20103   改傳入固定參數
         LET ls_where = ls_where CLIPPED," AND apykind='21' OR apykind='22' OR apykind='26'"
      #END IF
   END IF
   
   IF g_prog ='aaps100' OR g_prog ='aapt335' THEN   #No.TQC-BC0195 
      IF g_apz.apz68 ='Y' THEN 
         LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED,"AND apydmy3 ='Y'  ORDER BY apyslip "
      ELSE 
         LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED,"AND apydmy3 ='N'  ORDER BY apyslip "
      END IF 
   ELSE 
      LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED," ORDER BY apyslip "
   END IF 

   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   CALL ma_qry.clear()
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO lr_qry.*
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
 
      #FUN-4C0001 判斷是否已達選取上限  add by hongmf 20041201
      IF li_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
 
      #------------------------------------------------------ 970909 Roger
      #NO:6842
      #--------------No.MOD-660032 modify
       #SELECT gen03 INTO g_gen03 FROM gen_file where gen01=g_user   #抓此人所屬部門
        SELECT zx03 INTO g_gen03 FROM zx_file where zx01=g_user   #抓此人所屬部門
      #--------------No.MOD-660032 end
      IF SQLCA.SQLCODE THEN
          LET g_gen03=NULL
      END IF
      #權限先check user再check部門
      #SELECT COUNT(*) INTO l_n FROM smu_file WHERE smu01=lr_qry.apyslip AND smu03=mi_sys   #CHECK USER        #TQC-670008 remark
      SELECT COUNT(*) INTO l_n FROM smu_file WHERE smu01=lr_qry.apyslip AND upper(smu03)=mi_sys   #CHECK USER  #TQC-670008
      IF l_n>0 THEN                                                #USER權限存有資料,並g_user判斷是否存在
         #SELECT COUNT(*) INTO l_n FROM smu_file WHERE smu01=lr_qry.apyslip AND smu02=g_user AND smu03=mi_sys        #TQC-670008 remark
         SELECT COUNT(*) INTO l_n FROM smu_file WHERE smu01=lr_qry.apyslip AND smu02=g_user AND upper(smu03)=mi_sys  #TQC-670008
         IF l_n=0 THEN
             IF g_gen03 IS NULL THEN                               #g_user沒有部門
                 CONTINUE FOREACH
             ELSE                                                  #CHECK g_user部門是否存在
                 #SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=lr_qry.apyslip AND smv02=g_gen03 AND smv03=mi_sys       #TQC-670008 remark
                 SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=lr_qry.apyslip AND smv02=g_gen03 AND upper(smv03)=mi_sys #TQC-670008
                 IF l_n=0 THEN
                    CONTINUE FOREACH
                 END IF
             END IF
         END IF
      ELSE                                                          #CHECK Dept
         #SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=lr_qry.apyslip AND smv03=mi_sys        #TQC-670008 remark
         SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=lr_qry.apyslip AND upper(smv03)=mi_sys  #TQC-670008
          IF l_n>0 THEN
             IF g_gen03 IS NULL THEN                                #g_user沒有部門
                 CONTINUE FOREACH
             ELSE                                                   #CHECK g_user部門是否存在
                 #SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=lr_qry.apyslip AND smv02=g_gen03 AND smv03=mi_sys        #TQC-670008 remark
                 SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=lr_qry.apyslip AND smv02=g_gen03 AND upper(smv03)=mi_sys  #TQC-670008
                 IF l_n=0 THEN
                    CONTINUE FOREACH
                 END IF
             END IF
          END IF
        END IF
      #NO:6842
      #------------------------------------------------------ 970909 Roger
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION apy2_qry_set_display_data(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_i             LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_j             LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   CALL ma_qry_tmp.clear()
 
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
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION apy2_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_apy.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_apy.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_apy.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL apy2_qry_reset_multi_sel(pi_start_index, pi_end_index)
 
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
 
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_apy.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL apy2_qry_reset_multi_sel(pi_start_index, pi_end_index)
 
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
 
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION refresh
         CALL apy2_qry_refresh()
 
         LET pi_start_index = 1
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_apy.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL apy2_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL apy2_qry_accept(pi_start_index+ARR_CURR()-1)
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
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION apy2_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION apy2_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_apy.*
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
         LET mi_need_cons = TRUE   #No.TQC-970258
 
         EXIT DISPLAY
      ON ACTION accept
         CALL apy2_qry_accept(pi_start_index+ARR_CURR()-1)
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
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION apy2_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION apy2_qry_accept(pi_sel_index)
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
               CALL lsb_multi_sel.append(ma_qry[li_i].apyslip CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].apyslip CLIPPED)
            END IF
         END IF
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值.
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].apyslip CLIPPED
   END IF
END FUNCTION
