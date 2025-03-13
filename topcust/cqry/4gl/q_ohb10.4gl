# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#{
# Program name   : q_ogb10.4gl
# Program ver.   : 7.0
# Description    : 訂單資料查詢-過濾已開立出貨或出通訂單資料
# Date & Author  : 2009/04/10 by Dido copy from q_ogb.4gl
# Memo           : 


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         oga01    LIKE oga_file.oga01,
         oga02    LIKE oga_file.oga02,
         ogb03    LIKE ogb_file.ogb03,
         ogb04    LIKE ogb_file.ogb04,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,         #TQC-C60093 add
         ogb091   LIKE ogb_file.ogb091,
         ogb12    LIKE ogb_file.ogb12,   
         ogb60    LIKE ogb_file.ogb60,
         ogbud02  LIKE ogb_file.ogbud02
END RECORD
#-----MOD-8C0110---------
DEFINE   ma_qry2  DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,          #No.FUN-680131 VARCHAR(1)
         oga01    LIKE oga_file.oga01,
         oga02    LIKE oga_file.oga02,
         ogb03    LIKE ogb_file.ogb03,
         ogb04    LIKE ogb_file.ogb04,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,         #TQC-C60093 add
         ogb091   LIKE ogb_file.ogb091,
         ogb12    LIKE ogb_file.ogb12,
         ogb60    LIKE ogb_file.ogb60,
         ogbud02  LIKE ogb_file.ogbud02
END RECORD
DEFINE   ma_qry3  DYNAMIC ARRAY OF RECORD
         oga01    LIKE oga_file.oga01
         END RECORD
#-----END MOD-8C0110-----
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,          #No.FUN-680131 VARCHAR(1)
         oga01    LIKE oga_file.oga01,
         oga02    LIKE oga_file.oga02,
         ogb03    LIKE ogb_file.ogb03,
         ogb04    LIKE ogb_file.ogb04,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,         #TQC-C60093 add
         ogb091   LIKE ogb_file.ogb091,
         ogb12    LIKE ogb_file.ogb12,
         ogb60    LIKE ogb_file.ogb60,
         ogbud02  LIKE ogb_file.ogbud02
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_cus           LIKE oga_file.oga03,
         ms_oga01         LIKE oga_file.oga01,
         ms_oga213        LIKE oga_file.oga213,
         ms_oga211        LIKE oga_file.oga211,
         ms_oga24         LIKE oga_file.oga24,
         ms_oga04         LIKE oga_file.oga04,
         ms_oga21         LIKE oga_file.oga21,
         ms_oga23         LIKE oga_file.oga23,
         ms_oga25         LIKE oga_file.oga25,
         ms_ogb03         LIKE ogb_file.ogb03,
         ms_oga16         LIKE oga_file.oga16,   #MOD-8C0110
         ms_oga08         LIKE oga_file.oga08,   #MOD-8C0110
         ms_oga32         LIKE oga_file.oga32,   #MOD-8C0110
         ms_argv0         LIKE type_file.chr1    #MOD-8C0110
DEFINE   mr_ohb           RECORD LIKE ohb_file.*
DEFINE   mr_ogb           RECORD LIKE ogb_file.*
DEFINE   g_cnt            LIKE type_file.num10 	#No.FUN-680131 INTEGER
DEFINE   g_oha01         LIKE oha_file.oha01,
         g_oha03         LIKE oha_file.oha03 

FUNCTION q_ohb10(pi_multi_sel,pi_need_cons,ps_cus,ps_oga01,ps_oga213,ps_oga211,
               ps_oga24,ps_oga04,ps_oga21,ps_oga23,ps_oga25,ps_argv0) 
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   ps_cus          LIKE oga_file.oga03,
            ps_oga01        LIKE oga_file.oga01,
            ps_oga213       LIKE oga_file.oga213,
            ps_oga211       LIKE oga_file.oga211,
            ps_oga24        LIKE oga_file.oga24,
            ps_oga04        LIKE oga_file.oga04,
            ps_oga21        LIKE oga_file.oga21,
            ps_oga23        LIKE oga_file.oga23,
            ps_oga25        LIKE oga_file.oga25,
            ps_argv0        LIKE type_file.chr1   #MOD-8C0110
 DEFINE   p_oha01    LIKE oha_file.oha01,
          p_oha03    LIKE oha_file.oha03
 
   WHENEVER ERROR CONTINUE
   LET g_oha01=p_oha01
   LET g_oha03=p_oha03
    LET ms_cus    = ps_cus
   LET ms_oga01  = ps_oga01
   LET ms_oga213 = ps_oga213
   LET ms_oga211 = ps_oga211
   LET ms_oga24  = ps_oga24
   LET ms_oga04  = ps_oga04
   LET ms_oga21  = ps_oga21
   LET ms_oga23  = ps_oga23
   LET ms_oga25  = ps_oga25
   LET ms_argv0  = ps_argv0
   OPEN WINDOW w_qry WITH FORM "cqry/42f/q_ohb10" ATTRIBUTE(STYLE="create_qry")  #No.FUN-660161
 
   CALL cl_ui_locale("q_ohb10")
 
   LET mi_multi_sel = TRUE
   LET mi_need_cons = pi_need_cons
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   CALL ogb_qry_sel_ohb10()
 
   CLOSE WINDOW w_qry
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2004/02/27 by saki
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION ogb_qry_sel_ohb10()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 	#No.FUN-680131 SMALLINT
            li_continue      LIKE type_file.num5      #是否繼續.	#No.FUN-680131 SMALLINT
   DEFINE   li_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_curr_page     LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03
  #MOD-780285-begin-add
   DEFINE l_ogb912a  LIKE ogb_file.ogb912,
          l_ogb915a  LIKE ogb_file.ogb915,
          l_ogb917a  LIKE ogb_file.ogb917
  #MOD-780285-end-add
 
 
   LET mi_page_count = 100 
   LET li_reconstruct = TRUE
 
   WHILE TRUE
      CLEAR FORM
     
      DISPLAY g_oha03 TO oha03 
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      LET ms_cons_where=" 1=1"
      IF (li_reconstruct) THEN
         MESSAGE ""
     
         IF (mi_need_cons) THEN
            CONSTRUCT BY NAME ms_cons_where ON oga01,oga02,ogb03,ogb04,ima02,ima021,ogb091,ogb12,  #TQC-C60093 add ogb06,ima021
                                               ogb60,ogbud02
     
            #-----MOD-A90122---------
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
            #-----END MOD-A90122-----
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
     
         CALL ogb_qry_prep_result_set_ohb10() 
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
     
      CALL ogb_qry_set_display_data_ohb10(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      # 2004/02/25 by saki : 若最後一頁不到整除的數目, 避免頁次不會再往上加
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL ogb_qry_input_array_ohb10(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL ogb_qry_display_array_ohb10(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2004/02/27 by saki
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION ogb_qry_prep_result_set_ohb10()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql     STRING,
            ls_where   STRING
   DEFINE   li_i       LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry     RECORD
            check    LIKE type_file.chr1,          #No.FUN-680131 VARCHAR(1)
         oga01    LIKE oga_file.oga01,
         oga02    LIKE oga_file.oga02,
         ogb03    LIKE ogb_file.ogb03,
         ogb04    LIKE ogb_file.ogb04,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,         #TQC-C60093 add
         ogb091   LIKE ogb_file.ogb091,
         ogb12    LIKE ogb_file.ogb12,   
         ogb60    LIKE ogb_file.ogb60,
         ogbud02  LIKE ogb_file.ogbud02
   END RECORD
   DEFINE   l_ogb12    LIKE ogb_file.ogb12           #MOD-940130
 
 
#   IF cl_null(ms_oga16) THEN   #MOD-8C0110
 
      LET l_filter_cond = cl_get_extra_cond_for_qry('q_ohb10', 'oga_file')
      IF NOT cl_null(l_filter_cond) THEN
         LET ms_cons_where = ms_cons_where,l_filter_cond
      END IF
      #End:FUN-980030
      LET ls_sql = "SELECT 'N',oga01,oga02,ogb03,ogb04,ima02,ima021,ogb091,ogb12,ogb60,ogbud02 ",
                   " FROM oga_file,ogb_file,ima_file",    #TQC-C60093 add ima_file
                   " WHERE oga01 = ogb01",
                   "   AND ogb04 = ima01",       #TQC-C60093
                   "   AND oga03 = '",ms_cus CLIPPED,"'",
                   "   AND ogaconf = 'Y' ",
                   "   AND oga04   = '",ms_oga04,"' ", #帳款客戶
                   "   AND oga21   = '",ms_oga21,"' ", #稅別 
                   "   AND oga23   = '",ms_oga23,"' ", #幣別 
                   "   AND oga25   = '",ms_oga25,"' ", #銷售分類 
                   "   AND oga09='2' ",
                   "   AND ",ms_cons_where CLIPPED,
               #    "   AND oga08 = '",ms_oga08,"' ",   #MOD-8C0110
                   "   AND oga00 != '0' ",   #MOD-B90198 add
                   " ORDER BY oga01,ogb03 "
   #-----MOD-8C0110---------
 #  ELSE
 #     LET ls_sql = "SELECT 'N',oga01,oga02,ogb03,ogb04,ogb06,ima021,ogb091,ogb12,ogb24,ogb25,(ogb12-ogb24+ogb25),ogb15",  #TQC-780032 mod  #MOD-780285 modify -ogb24  #MOD-7B0195 +ogb25   #TQC-C60093 add ogb06,ima021,
  #                 " FROM oga_file,ogb_file,ima_file",    #TQC-C60093 add ima_file
  #                 " WHERE oga01 = ogb01",
  #                 "   AND ogb04 = ima01",       #TQC-C60093
  #                 "   AND ogaconf = 'Y' ",
  ###                 "   AND oga01 = '",ms_oga16,"' ",
  #                 "   AND ",ms_cons_where CLIPPED,
  #                 "   AND ogb70 = 'N' ",          
  #                 "   AND ogb12-ogb24+ogb25 > 0", 
  #                 "   AND oga08 = '",ms_oga08,"' ",  
  #                 "   AND oga00 != '0' ",   #MOD-B90198 add
  #                 " ORDER BY oga01,ogb03 "
  # END IF
   #-----END MOD-8C0110-----
 
#FUN-990069---begin 
   IF (NOT mi_multi_sel ) THEN
      CALL cl_parse_qry_sql( ls_sql, g_plant ) RETURNING ls_sql
   END IF     
#FUN-990069---end  
              
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
 
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2004/02/27 by saki
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION ogb_qry_set_display_data_ohb10(pi_start_index, pi_end_index)
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
# Date & Author : 2004/02/27 by saki
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION ogb_qry_input_array_ohb10(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_ogb.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_ogb.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_ogb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL ogb_qry_reset_multi_sel_ohb10(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_ogb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL ogb_qry_reset_multi_sel_ohb10(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL ogb_qry_refresh_ohb10()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_ogb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL ogb_qry_reset_multi_sel_ohb10(pi_start_index, pi_end_index)
            IF cl_sure(0,0) THEN
               CALL ogb_qry_accept_ohb10(pi_start_index+ARR_CURR()-1)
            ELSE
               CLOSE WINDOW w_qry 
            END IF
         END IF                      #CHI-9C0048
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         LET li_continue = FALSE
     
         EXIT INPUT
 
      #No.FUN-660161 --begin--
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161 --end--

      #-----MOD-A90122---------
      ON ACTION controlg      
         CALL cl_cmdask()     

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
      #-----END MOD-A90122-----
 
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
# Date & Author : 2004/02/27 by saki
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION ogb_qry_reset_multi_sel_ohb10(pi_start_index, pi_end_index)
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
# Date & Author : 2004/02/27 by saki
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION ogb_qry_display_array_ohb10(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
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
         CALL ogb_qry_accept_ohb10(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         LET li_continue = FALSE
      
         EXIT DISPLAY
 
      #No.FUN-660161 --begin--
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161 --end--

      #-----MOD-A90122---------
      ON ACTION controlg      
         CALL cl_cmdask()     

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY 
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
      #-----END MOD-A90122-----
 
   END DISPLAY
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description   : 重設查詢資料.
# Date & Author : 2004/02/27 by saki
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION ogb_qry_refresh_ohb10()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2004/02/27 by saki
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION ogb_qry_accept_ohb10(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_i2,li_i3     LIKE type_file.num10,       #MOD-8C0110
            #-----MOD-990181---------
            l_ogbi          RECORD LIKE ogbi_file.*,
            l_imaicd04      LIKE imaicd_file.imaicd04,
            l_cnt           LIKE type_file.num5,
            l_flag          LIKE type_file.chr1   
            #-----END MOD-990181----- 
 
   LET g_success='Y'
   BEGIN WORK
   #   SELECT MAX(ogb03)+1 INTO ms_ogb03 FROM ogb_file WHERE ogb01 = ms_oga01 
      #@@@ 95/07/05 by danny
      IF cl_null(ms_ogb03) THEN LET ms_ogb03=1 END IF
      #@@@
      #-----MOD-8C0110---------
      LET li_i2 = 1
      LET li_i3 = 1
      CALL ma_qry2.clear()
      CALL ma_qry3.clear()
      FOR li_i = 1 TO ma_qry.getLength()   
          IF (ma_qry[li_i].check = 'Y') THEN
              LET ma_qry2[li_i2].* = ma_qry[li_i].*
              IF li_i2 > 1 THEN
                 IF ma_qry2[li_i2].oga01 <> ma_qry2[li_i2-1].oga01 THEN
                    LET ma_qry3[li_i3].oga01 = ma_qry[li_i].oga01
                    LET li_i3 = li_i3 + 1
                 END IF
              ELSE
                 LET ma_qry3[li_i3].oga01 = ma_qry[li_i].oga01
                 LET li_i3 = li_i3 + 1
              END IF
              LET li_i2 = li_i2 + 1
          END IF
      END FOR
      CALL ma_qry2.deleteElement(li_i2)
      CALL ma_qry3.deleteElement(li_i3)
      CALL s_showmsg_init() 
      CALL q_ogb_chk_ohb10()
      IF g_success = 'Y' THEN 
      #-----END MOD-8C0110-----
         FOR li_i = 1 TO ma_qry.getLength()   
            IF (ma_qry[li_i].check = 'Y') THEN
               INITIALIZE mr_ogb.* TO NULL
               SELECT * INTO mr_ogb.* FROM ogb_file
               WHERE ogb01=ma_qry[li_i].oga01 AND ogb03=ma_qry[li_i].ogb03
               LET mr_ohb.ohb01 = ms_oga01
               SELECT MAX(ohb03+1) INTO mr_ohb.ohb03 FROM ohb_file WHERE ohb01=ms_oga01
               IF cl_null( mr_ohb.ohb03) THEN LET  mr_ohb.ohb03 =1 END IF
               LET mr_ohb.ohb04=mr_ogb.ogb04
               LET mr_ohb.ohb05=mr_ogb.ogb05
               LET mr_ohb.ohb05_fac=mr_ogb.ogb05_fac
               LET mr_ohb.ohb06=mr_ogb.ogb06    
               LET mr_ohb.ohb08=g_plant
               LET mr_ohb.ohb09='S009'      #mr_ogb.ogb09
               LET mr_ohb.ohb091=' '           #mr_ogb.ogb091               
               LET mr_ohb.ohb092=' '           #mr_ogb.ogb092
               SELECT  count(*) into l_cnt FROM img_file
               WHERE img01=mr_ohb.ohb04 AND img02='S009' AND img03=' ' AND img04=' ' 
               IF l_cnt=0 THEN
                  CALL s_add_img(mr_ohb.ohb04,mr_ohb.ohb09,
                        mr_ohb.ohb091,mr_ohb.ohb092,
                        ms_oga01, mr_ohb.ohb03, g_today)
               END IF 

               #tianry add 
               LET mr_ohb.ohb12=mr_ogb.ogb12
               LET mr_ohb.ohb13=mr_ogb.ogb13
               LET mr_ohb.ohb14=mr_ogb.ogb14
               LET mr_ohb.ohb14t=mr_ogb.ogb14t
               LET mr_ohb.ohb15=mr_ogb.ogb15
               LET mr_ohb.ohb15_fac=mr_ogb.ogb15_fac
               LET mr_ohb.ohb16=mr_ogb.ogb16
               LET mr_ohb.ohb31=ma_qry[li_i].oga01
               LET mr_ohb.ohb32=ma_qry[li_i].ogb03
               LET mr_ohb.ohb33=mr_ogb.ogb31
               LET mr_ohb.ohb34=mr_ogb.ogb32
               LET mr_ohb.ohb50='XT'
               LET mr_ohb.ohb60=0
               LET mr_ohb.ohb916=mr_ogb.ogb916 
               LET mr_ohb.ohb917=mr_ogb.ogb917
               LET mr_ohb.ohb1003=mr_ogb.ogb1006 
               LET mr_ohb.ohb1004=mr_ogb.ogb1012
               LET mr_ohb.ohb1005=mr_ogb.ogb1005
               LET mr_ohb.ohb61=mr_ogb.ogb19
               LET mr_ohb.ohb64=mr_ogb.ogb44
               LET mr_ohb.ohb67=mr_ogb.ogb47
              # IF g_azw.azw04='2' THEN
                  LET mr_ohb.ohb68='N'
              # ELSE
              #    LET mr_ohb.ohb64 = '1'
              # END IF
               LET mr_ohb.ohbplant=mr_ogb.ogbplant
               LET mr_ohb.ohblegal=mr_ogb.ogblegal
               LET mr_ohb.ohb37=mr_ogb.ogb37
               INSERT INTO ohb_file VALUES(mr_ohb.*)
               IF STATUS THEN 
                  CALL cl_err3("ins","ohb_file","","",STATUS,"","",0)   #No.FUN-670090
                  #CALL cl_err('ins ohb',STATUS,1) LET g_success='N'
                  EXIT FOR
               ELSE
               END IF
            END IF    
         END FOR
      END IF   #MOD-8C0110
      CALL s_showmsg()   #MOD-8C0110
      IF g_success='Y' THEN
         COMMIT WORK 
      ELSE
         ROLLBACK WORK
      END IF
      MESSAGE ''
END FUNCTION
 
 
 
FUNCTION q_ogb_chk_ohb10()
   DEFINE l_chr1,l_chr2 LIKE type_file.chr1,
          l_rec_b       LIKE type_file.num10,
          l_i           LIKE type_file.num10,
          l_oga         RECORD LIKE oga_file.*,
          l_i2          LIKE type_file.num10,
          l_cnt         LIKE type_file.num5,
          l_t1          LIKE oay_file.oayslip,
          l_oay22_oga   LIKE oay_file.oay22,
          l_oga18       LIKE oga_file.oga18,
          l_oga23       LIKE oga_file.oga23,
          l_oga24       LIKE oga_file.oga24,
          l_oga904      LIKE oga_file.oga904,
          l_oga161      LIKE oga_file.oga161,
          l_oga163      LIKE oga_file.oga163,
          l_ogb         RECORD LIKE ogb_file.*,
          li_result     LIKE type_file.num5, 
          l_poz         RECORD LIKE poz_file.*,
          l_oga99       LIKE oga_file.oga99,  
          l_flow        LIKE oga_file.oga904,
          l_oga904_2    LIKE oga_file.oga904   #MOD-AC0261
   DEFINE l_oax06       LIKE oax_file.oax06    #MOD-C40132 add
 
   LET l_chr1 = 'N'
   LET l_chr2 = 'N'
   LET l_rec_b = ma_qry3.getLength()
   FOR l_i = 1 TO l_rec_b
       SELECT * INTO l_oga.* FROM oga_file 
        WHERE oga01 = ma_qry3[l_i].oga01
       IF l_chr1 = 'N' THEN 
          FOR l_i2 = 1 TO l_rec_b
              SELECT oga18,oga23,oga24 INTO l_oga18,l_oga23,l_oga24 
                FROM oga_file
               WHERE oga01 = ma_qry3[l_i2].oga01
              IF l_oga.oga18 <> l_oga18 OR 
                 (l_oga.oga18 = 'Y' AND 
                  (l_oga.oga23 <> l_oga23 OR l_oga.oga24 <> l_oga24)) THEN
                 CALL s_errmsg('','','','axm-608',1)
                 LET g_success = 'N'
                 LET l_chr1 = 'Y' 
                 EXIT FOR
              END IF 
          END FOR 
       END IF
       IF l_chr2 = 'N' THEN 
          FOR l_i2 = 1 TO l_rec_b
              SELECT oga904 INTO l_oga904 
                FROM oga_file
               WHERE oga01 = ma_qry3[l_i2].oga01
               IF l_oga.oga904 <> l_oga904 THEN
                  CALL s_errmsg('','','','axm-501',1)
                  LET g_success = 'N'
                  LET l_chr2 = 'Y'
                  EXIT FOR
               END IF
               #-----MOD-AC0261---------
               #-----END MOD-AC0261-----
          END FOR 
       END IF
       IF l_chr1 = 'Y' AND l_chr2 = 'Y' THEN 
          EXIT FOR
       END IF
   END FOR
 
   IF l_rec_b > 1 THEN 
      FOR l_i = 1 TO l_rec_b
           LET l_oga161=0
           LET l_oga163=0
           SELECT oga161,oga163 INTO l_oga161,l_oga163 FROM oga_file
            WHERE oga01 = ma_qry3[l_i].oga01
           IF l_oga161 > 0 OR l_oga163 > 0 THEN
              CALL s_errmsg('oga01',ma_qry3[l_i].oga01,'','axm-076',1)
              LET g_success = 'N'
           END IF
      END FOR
   END IF
 
   {SELECT * INTO l_oga.* FROM oga_file WHERE oga01 = ms_oga01
   FOR l_i = 1 TO l_rec_b
       CASE l_oga.oga00 
        WHEN '1' 
             #CALL s_check_no("axm",ma_qry3[l_i].oga01,"","30","","","")
              CALL s_check_no("axm",ma_qry3[l_i].oga01,ma_qry3[l_i].oga01,"30","","","") #MOD-B60012 mod
                RETURNING li_result,ma_qry3[l_i].oga01
        WHEN '2'
             #CALL s_check_no("axm",ma_qry3[l_i].oga01,"","32","","","")
              CALL s_check_no("axm",ma_qry3[l_i].oga01,ma_qry3[l_i].oga01,"32","","","") #MOD-B60012 mod
                RETURNING li_result,ma_qry3[l_i].oga01
        WHEN '3'
             #CALL s_check_no("axm",ma_qry3[l_i].oga01,"","33","","","")
              CALL s_check_no("axm",ma_qry3[l_i].oga01,ma_qry3[l_i].oga01,"33","","","") #MOD-B60012 mod
                RETURNING li_result,ma_qry3[l_i].oga01
        WHEN '4'
             #CALL s_check_no("axm",ma_qry3[l_i].oga01,"","34","","","")
              CALL s_check_no("axm",ma_qry3[l_i].oga01,ma_qry3[l_i].oga01,"34","","","") #MOD-B60012 mod
                RETURNING li_result,ma_qry3[l_i].oga01
        WHEN '5'
             #CALL s_check_no("axm",ma_qry3[l_i].oga01,"","35","ogb_file","ogb31","")
              CALL s_check_no("axm",ma_qry3[l_i].oga01,ma_qry3[l_i].oga01,"35","ogb_file","ogb31","") #MOD-B60012 mod
                RETURNING li_result,ma_qry3[l_i].oga01
        WHEN '6' 
             #CALL s_check_no("axm",ma_qry3[l_i].oga01,"","30","","","")
              CALL s_check_no("axm",ma_qry3[l_i].oga01,ma_qry3[l_i].oga01,"30","","","") #MOD-B60012 mod
                RETURNING li_result,ma_qry3[l_i].oga01
        WHEN '7'
             #CALL s_check_no("axm",ma_qry3[l_i].oga01,"","33","","","")
              CALL s_check_no("axm",ma_qry3[l_i].oga01,ma_qry3[l_i].oga01,"33","","","") #MOD-B60012 mod
                RETURNING li_result,ma_qry3[l_i].oga01
        WHEN 'A'
             #CALL s_check_no("axm",ma_qry3[l_i].oga01,"","22","","","")
              CALL s_check_no("axm",ma_qry3[l_i].oga01,ma_qry3[l_i].oga01,"22","","","") #MOD-B60012 mod
                RETURNING li_result,ma_qry3[l_i].oga01
        WHEN 'B'
             #CALL s_check_no("axm",ma_qry3[l_i].oga01,"","22","","","")
              CALL s_check_no("axm",ma_qry3[l_i].oga01,ma_qry3[l_i].oga01,"22","","","") #MOD-B60012 mod
                RETURNING li_result,ma_qry3[l_i].oga01
       END CASE 
       #IF NOT li_result THEN #MOD-C40132 mark
       SELECT oax06 INTO l_oax06 FROM oax_file            #MOD-C40132 add
       IF NOT li_result AND NOT (ms_argv0 MATCHES '[456]' AND l_oax06 = 'Y') THEN #MOD-C40132 add
          CALL s_errmsg('oga01',ma_qry3[l_i].oga01,'','mfg0015',1)
          LET g_success='N'
       END IF
 
 
       SELECT * INTO l_oga.* FROM oga_file where oga01 = ma_qry3[l_i].oga01
       IF l_oga.oga044 <> l_oga.oga044 THEN
          CALL s_errmsg('oga01',ma_qry3[l_i].oga01,'','axm-916',1)
          LET g_success = 'N'
       END IF
       
       LET l_cnt = 0 
       SELECT COUNT(*) INTO l_cnt FROM oep_file 
          WHERE oep01 = ma_qry3[l_i].oga01
            AND oepconf = 'N' 
       IF l_cnt > 0  THEN
          CALL s_errmsg('oga01',ma_qry3[l_i].oga01,'','axm-118',1)
          LET g_success = 'N'
       END IF
       LET l_cnt = 0 
       SELECT COUNT(*) INTO l_cnt FROM oep_file 
          WHERE oep01 = ma_qry3[l_i].oga01 
            AND oep09 <> '2' 
            AND oepconf = 'Y' #MOD-C40078 add
       IF l_cnt > 0  THEN
          CALL s_errmsg('oga01',ma_qry3[l_i].oga01,'','axm-119',1)
          LET g_success = 'N'
       END IF
       
       IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
          LET l_t1 = ma_qry3[l_i].oga01[1,g_doc_len]
          SELECT oay22 INTO l_oay22_oga FROM oay_file WHERE oayslip =l_t1
          LET l_t1 = ms_oga01[1,g_doc_len]
          SELECT oay22 INTO l_oay22_oga FROM oay_file WHERE oayslip =l_t1
          IF l_oay22_oga != l_oay22_oga THEN
              CALL s_errmsg('oga01',ma_qry3[l_i].oga01,'','atm-521',1)
              LET g_success = 'N'
          END IF
       END IF
       
       IF ma_qry3[l_i].oga01[1,4] !='MISC' THEN
          IF NOT cl_null(l_oga.ogahold) THEN
             CALL s_errmsg('oga01',ma_qry3[l_i].oga01,'','axm-151',1)
             LET g_success = 'N'
          END IF
          IF l_oga.oga32 != ms_oga32 THEN	#收款條件不符
             CALL s_errmsg('oga01',ma_qry3[l_i].oga01,'','axm-143',1)
             LET g_success = 'N'
          END IF
          IF cl_null(l_oga.oga909) OR l_oga.oga909 = 'N' THEN
             IF l_oga.oga901 = 'Y' THEN
                CALL s_errmsg('oga01',ma_qry3[l_i].oga01,'','tri-015',1)
                LET g_success = 'N'
             END IF
          END IF
          IF l_oga.oga909 = 'Y' THEN
             #是否為三角貿易訂單
             IF cl_null(l_oga.oga901) OR l_oga.oga901='N' THEN
                CALL s_errmsg('oga01',ma_qry3[l_i].oga01,'','tri-014',1)
                LET g_success = 'N'
             END IF
             #是否三角貿易已拋轉各廠
             IF l_oga.oga905 = 'N'  OR l_oga.oga905 IS NULL THEN
                CALL s_errmsg('oga01',ma_qry3[l_i].oga01,'','axm-307',1)
                LET g_success = 'N'
             END IF
             #檢查流程代碼
             CALL q_ogb_chkpoz_ohb10(l_oga.*,ma_qry3[l_i].oga01) 
               RETURNING li_result,l_poz.*,l_oga99,l_flow 
             IF NOT li_result THEN 
                LET g_success='N'
             END IF 
       
             IF ms_argv0 MATCHES '[456]' THEN #多角出貨    
                IF l_poz.poz011 = '1' THEN  #正拋方式
                   #檢查是否為起始訂單
                   IF l_oga.oga906 = 'N' OR cl_null(l_oga.oga906) THEN
                      CALL s_errmsg('oga01',ma_qry3[l_i].oga01,'','axm-409',1)
                      LET g_success = 'N'
                   END IF
                END IF
                IF l_poz.poz011 = '2' THEN  #反拋方式
                   IF NOT q_ogb_last_ohb10(l_flow,ma_qry3[l_i].oga01) THEN
                      LET g_success = 'N'
                   END IF
                END IF
                #判斷銷售段 OR 代採段之訂單
                IF ms_argv0 = '4' THEN       #銷售段
                   IF l_oga.oga11 ='6' THEN
                      CALL s_errmsg('oga01',ma_qry3[l_i].oga01,'','axm-022',1)
                      LET g_success = 'N'
                   END IF
                   IF l_poz.poz00 ='2' THEN
                      CALL s_errmsg('oga01',ma_qry3[l_i].oga01,'','tri-008',1)
                      LET g_success = 'N'
                   END IF
                END IF
                IF ms_argv0 = '6' THEN       #代採段
                   IF l_oga.oga11 <> '6' THEN
                      CALL s_errmsg('oga01',ma_qry3[l_i].oga01,'','axm-023',1)
                      LET g_success = 'N'
                   END IF
                   IF l_poz.poz011 <> '2' THEN 
                      CALL s_errmsg('oga01',ma_qry3[l_i].oga01,'','axm-027',1)
                      LET g_success = 'N'
                   END IF
                   IF l_poz.poz00 ='1' THEN
                      CALL s_errmsg('oga01',ma_qry3[l_i].oga01,'','tri-008',1)
                      LET g_success = 'N'
                   END IF
                END IF
             END IF
          END IF
       END IF
   END FOR
   }
   FOR l_i = 1 TO ma_qry2.getLength()
       SELECT * INTO l_oga.* FROM oga_file WHERE oga01 = ma_qry2[l_i].oga01
       SELECT * INTO l_ogb.* FROM ogb_file 
         WHERE ogb01=ma_qry2[l_i].oga01 AND ogb03=ma_qry2[l_i].ogb03
 
       IF ma_qry2[l_i].oga01[1,4] !='MISC' THEN
          IF ms_argv0 MATCHES '[246]' AND NOT cl_null(l_oga.oga011) THEN 
             LET l_cnt = 0 
             SELECT COUNT(*) INTO l_cnt FROM oga_file,ogb_file
              WHERE oga01=l_oga.oga011 
                AND oga01=ogb01 AND (oga09 = '1' OR oga09 = '5')  
                AND ogb31=ma_qry2[l_i].oga01 AND ogb32=ma_qry2[l_i].ogb03
             IF l_cnt=0 THEN 	
                LET g_showmsg = ma_qry2[l_i].oga01,"/",ma_qry2[l_i].ogb03
                CALL s_errmsg('oga01,ogb03',g_showmsg,'','axm-224',1)
                LET g_success = 'N'
             END IF
          END IF
       
     {     IF ms_argv0 MATCHES '[246]' AND l_ogb.ogb1003='1' THEN
             IF ((l_ogb.ogb12*((100+l_oga.oga09)/100))-
                 l_ogb.ogb24+l_ogb.ogb25) <= 0 THEN 
                LET g_showmsg = ma_qry2[l_i].oga01,"/",ma_qry2[l_i].ogb03
                CALL s_errmsg('oga01,ogb03',g_showmsg,'','axm-148',1)
                LET g_success = 'N'
             END IF
          END IF 
          IF l_ogb.ogb70 = 'Y' THEN
             LET g_showmsg = ma_qry2[l_i].oga01,"/",ma_qry2[l_i].ogb03
             CALL s_errmsg('oga01,ogb03',g_showmsg,'','axm-150',1)
             LET g_success = 'N'
          END IF  }
       END IF
   END FOR
END FUNCTION
 
 
