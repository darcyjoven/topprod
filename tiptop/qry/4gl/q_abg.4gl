# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#{
# Program name  : q_abg.4gl
# Program ver.  : 7.0
# Description   : 立帳資料查詢
# Date & Author : 2003/09/22 by Carrier
# Memo          :
# Modify        : No.FUN-5C0015 06/01/02 BY kevin 增加異動碼abb31~abb36
# Modify........: No.FUN-660161 06/07/07 By cl  增加匯出Excel功能
# Modify........: No.FUN-680131 06/08/31 By Carrier 欄位型態用LIKE定義
#}
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.FUN-880082 08/08/26 By tsai_yen 開窗全選功能
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No:FUN-B40026 11/06/20 By zhangweib 取消FUN-5C0015 處理段
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         abg11    LIKE abg_file.abg11,
         abg12    LIKE abg_file.abg12,
         abg13    LIKE abg_file.abg13,
         abg14    LIKE abg_file.abg14,
         abg04    LIKE abg_file.abg04,
         abg01    LIKE abg_file.abg01,
         abg02    LIKE abg_file.abg02
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         abg11        LIKE abg_file.abg11,
         abg12        LIKE abg_file.abg12,
         abg13        LIKE abg_file.abg13,
         abg14        LIKE abg_file.abg14,
         abg04        LIKE abg_file.abg04,
         abg01        LIKE abg_file.abg01,
         abg02        LIKE abg_file.abg02
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_ret1          STRING     
DEFINE   ms_ret2          STRING     
DEFINE   mi_type          LIKE abg_file.abg00   #帳別
DEFINE   mi_date          LIKE aba_file.aba02   #日期                     
DEFINE   mi_abb03         LIKE abg_file.abg03   #科目編號                 
DEFINE   mi_abb05         LIKE abg_file.abg05   #部門                     
DEFINE   mi_abb11         LIKE abg_file.abg11   #異動碼(一)               
DEFINE   mi_abb12         LIKE abg_file.abg12   #異動碼(二)               
DEFINE   mi_abb13         LIKE abg_file.abg13   #異動碼(三)               
DEFINE   mi_abb14         LIKE abg_file.abg14   #異動碼(四)
#FUN-B40026   ---start   Mark
## No.FUN-5C0015 add By kevin (s)
#DEFINE   mi_abb31         LIKE abg_file.abg31   #異動碼(五)
#DEFINE   mi_abb32         LIKE abg_file.abg32   #異動碼(六)
#DEFINE   mi_abb33         LIKE abg_file.abg33   #異動碼(七)
#DEFINE   mi_abb34         LIKE abg_file.abg34   #異動碼(八)
#DEFINE   mi_abb35         LIKE abg_file.abg35   #異動碼(九)
#DEFINE   mi_abb36         LIKE abg_file.abg36   #異動碼(十) 
## No.FUN-5C0015 add By kevin (e)
#FUN-B40026   ---end     Mark
 
 
## No.FUN-5C0015 mod By kevin (s)              #FUN-B40026   Mark
FUNCTION q_abg(pi_multi_sel,pi_need_cons,p_type,p_date,p_abb03,p_abb05,p_abb11,p_abb12,p_abb13,p_abb14)   #FUN-B40026   Unmark
#FUNCTION q_abg(pi_multi_sel,pi_need_cons,p_type,p_date,p_abb03,p_abb05,p_abb11,p_abb12,p_abb13,p_abb14,  #FUN-B40026   Mark
#              p_abb31,p_abb32,p_abb33,p_abb34,p_abb35,p_abb36)                                           #FUN-B40026   Mark
## No.FUN-5C0015 mod By kevin (e)                                                                         #FUN-B40026   Mark
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            p_type         LIKE abg_file.abg00,  #帳別
            p_date         LIKE aba_file.aba02,  #日期
            p_abb03        LIKE abg_file.abg03,  #科目編號
            p_abb05        LIKE abg_file.abg05,  #部門
            p_abb11        LIKE abg_file.abg11,  #異動碼(一)
            p_abb12        LIKE abg_file.abg12,  #異動碼(二)
            p_abb13        LIKE abg_file.abg13,  #異動碼(三)
            p_abb14        LIKE abg_file.abg14   #異動碼(四)
#FUN-B40026   ---start   Mark
#           # No.FUN-5C0015 add By kevin (s)
#          ,p_abb31        LIKE abg_file.abg31,  #異動碼(五)
#           p_abb32        LIKE abg_file.abg32,  #異動碼(六)
#           p_abb33        LIKE abg_file.abg33,  #異動碼(七)
#           p_abb34        LIKE abg_file.abg34,  #異動碼(八)
#           p_abb35        LIKE abg_file.abg35,  #異動碼(九)
#           p_abb36        LIKE abg_file.abg36   #異動碼(十)
#           # No.FUN-5C0015 add By kevin (e)
#FUN-B40026   ---end     Mark
 
 
    LET mi_type  = p_type
    LET mi_date  = p_date
    LET mi_abb03 = p_abb03
    LET mi_abb05 = p_abb05
    LET mi_abb11 = p_abb11
    LET mi_abb12 = p_abb12
    LET mi_abb13 = p_abb13
    LET mi_abb14 = p_abb14
#FUN-B40026   ---start   Mark
#   # No.FUN-5C0015-3 add By kevin (s)
#   LET mi_abb31 = p_abb31
#   LET mi_abb32 = p_abb32
#   LET mi_abb33 = p_abb33
#   LET mi_abb34 = p_abb34
#   LET mi_abb35 = p_abb35
#   LET mi_abb36 = p_abb36
#   # No.FUN-5C0015 add By kevin (e)
#FUN-B40026   ---end     Mark
 
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_abg" ATTRIBUTE(STYLE="create_qry")  #No.FUN-660161
 
   CALL cl_ui_locale("q_abg")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 2003/09/16 by Hiko : 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("abg01", "red")
#     CALL cl_set_comp_font_color("abg02", "red")
   END IF
 
   CALL abg_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 
   ELSE
      RETURN ms_ret1,ms_ret2 
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
FUNCTION abg_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE.	#No.FUN-680131 SMALLINT
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
      IF (li_reconstruct) THEN
         MESSAGE ""
 
         IF (mi_need_cons) THEN
            CONSTRUCT ms_cons_where ON abg11,abg12,abg13,abg14,abg04,abg01,abg02
                                  FROM s_abg[1].abg11,s_abg[1].abg12,
                                       s_abg[1].abg13,s_abg[1].abg14,
                                       s_abg[1].abg04,s_abg[1].abg01,
                                       s_abg[1].abg02
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            
            END CONSTRUCT
 
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
 
         CALL abg_qry_prep_result_set()
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
 
      CALL abg_qry_set_display_data(li_start_index, li_end_index)
 
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN
         CALL abg_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL abg_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
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
FUNCTION abg_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,   	#No.FUN-680131 VARCHAR(1)
            abg11    LIKE abg_file.abg11,
            abg12    LIKE abg_file.abg12,
            abg13    LIKE abg_file.abg13,
            abg14    LIKE abg_file.abg14,
            abg04    LIKE abg_file.abg04,
            abg01    LIKE abg_file.abg01,
            abg02    LIKE abg_file.abg02
   END RECORD
   DEFINE   l_cnt    LIKE type_file.num10       #No.FUN-680131 INTEGER
 
 
 
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_abg', 'abg_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET ls_sql = "SELECT 'N',abg11,abg12,abg13,abg14,abg04,abg01,abg02", 
                " FROM abg_file",
                " WHERE ",ms_cons_where
   
   IF NOT mi_multi_sel THEN
      LET ls_where = "   AND abg03='",  mi_abb03 CLIPPED,"'",   #科目編號              
                     "   AND (abg05='", mi_abb05 CLIPPED,"'",  #部門             
                     "    OR  abg05 IS NULL) ",                                     
                     "   AND abg11='",  mi_abb11 CLIPPED,"'",   #異動碼(一)            
                     "   AND abg12='",  mi_abb12 CLIPPED,"'",   #異動碼(二)            
                     "   AND abg13='",  mi_abb13 CLIPPED,"'",   #異動碼(三)            
                     "   AND abg14='",  mi_abb14 CLIPPED,"'",   #異動碼(四) 
#FUN-B40026   ---start   Mark
#                    # NO.FUN-5C0015 add By kevin (s)           
#                    "   AND abg3=1'",  mi_abb31 CLIPPED,"'",   #異動碼(五)            
#                    "   AND abg3=2'",  mi_abb32 CLIPPED,"'",   #異動碼(六)            
#                    "   AND abg3=3'",  mi_abb33 CLIPPED,"'",   #異動碼(七)            
#                    "   AND abg3=4'",  mi_abb34 CLIPPED,"'",   #異動碼(八)            
#                    "   AND abg3=5'",  mi_abb35 CLIPPED,"'",   #異動碼(九)            
#                    "   AND abg3=6'",  mi_abb36 CLIPPED,"'",   #異動碼(十)            
#                    # NO.FUN-5C0015 add By kevin (e)           
#FUN-B40026   ---end     Mark
                     "   AND abg06 <='",mi_date  CLIPPED,"'"
      IF NOT cl_null(mi_type) THEN   #帳別                                        
         LET ls_where = ls_where CLIPPED," AND abg00 = '",mi_type,"'"                       
      END IF 
   END IF
 
 
   LET ls_sql = ls_sql,ls_where," ORDER BY abg01,abg02" 
 
 
 
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
 
      #FUN-4C0001 判斷是否已達選取上限  add by hongmf 20041201 
      IF li_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
      SELECT COUNT(*) INTO l_cnt FROM abh_file                                
       WHERE abh07 = lr_qry.abg01                         
         AND abh08 = lr_qry.abg02                         
      IF l_cnt != 0   THEN CONTINUE FOREACH END IF 
 
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
FUNCTION abg_qry_set_display_data(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_i             LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_j             LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
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
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION abg_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_abg.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_abg.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_abg.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL abg_qry_reset_multi_sel(pi_start_index, pi_end_index)
         
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
         
         LET li_continue = TRUE

         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_abg.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL abg_qry_reset_multi_sel(pi_start_index, pi_end_index)
  
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
  
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION refresh
         CALL abg_qry_refresh()
 
         LET pi_start_index = 1
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048 
            CALL GET_FLDBUF(s_abg.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL abg_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL abg_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                        #CHI-9C0048                                
            LET ms_ret1 = NULL       #CHI-9C0048                                
         END IF                      #CHI-9C0048 
         LET li_continue = FALSE
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
#        IF (NOT mi_multi_sel) THEN
#            LET ms_ret1 = ms_default1
#        END IF
 
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
FUNCTION abg_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
FUNCTION abg_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_abg.*
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
         CALL abg_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
 
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
#        IF (NOT mi_multi_sel) THEN
#            LET ms_ret1 = ms_default1
#        END IF
 
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
FUNCTION abg_qry_refresh()
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
FUNCTION abg_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   # 2004/06/03 by saki : GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
               CALL lsb_multi_sel.append(ma_qry[li_i].abg01 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].abg01 CLIPPED)
            END IF
         END IF
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值.
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].abg01 CLIPPED
      LET ms_ret2 = ma_qry[pi_sel_index].abg02 CLIPPED
      {%設定多個回傳值.格式為ms_ret+流水號}
   END IF
END FUNCTION
