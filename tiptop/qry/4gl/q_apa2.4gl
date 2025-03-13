# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#{
# Program name  : q_apa2.4gl
# Program ver.  : 7.0
# Description   : 待沖帳查詢
# Date & Author : 09/23 by carrier
# Modify........: No.FUN-580012 05/09/07 By elva 新增待扺沖帳功能
# Modify........: No.TQC-610006 06/01/04 By Smapmin 針對本幣未沖金額的抓取
#                                 應以apz27(月底重評價是否迴轉)的設定做區分
# Memo          :
# Modify........: No.FUN-660161 06/07/07 By cl  增加匯出Excel功能
# Modify........: No.FUN-680027 06/08/16 By wujie 多帳期修改
# Modify........: No.FUN-680131 06/09/01 By Carrier 欄位型態用LIKE定義
#}
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify........: No.TQC-6B0066 06/11/28 By wujie 多帳期二次修改，取消apc02的返回值
# Modify........: No.TQC-750140 07/05/24 By rainy 報銷還款 ""沖帳"" 時 待抵資料開窗查詢應只可查 aapq231(待抵借支款)(apa00='25')資料  
# Modify........: No.MOD-820129 08/03/12 By Smapmin 為暫估帳款不能進行沖帳
# Modify........: No.MOD-820002 08/03/12 By Smapmin 僅抓取同一付款廠商的資料
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.FUN-880082 08/08/29 By tsai_yen 開窗全選功能
# Modify.........: No.TQC-950113 09/05/22 By wujie   衝帳時帳款編號開窗可開出待扺借支款資料
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No:MOD-C30717 12/03/15 By zhangweib 新增傳入參數付款廠商
# Modify.........: No:TQC-BC0115 12/09/11 By wangwei 加傳apa02參數
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         apc01    LIKE apc_file.apc01,    #No.FUN-680027
         apa07    LIKE apa_file.apa07,
         apc02    LIKE apc_file.apc02,    #No.FUN-680027
#        apa035_u LIKE apa_file.apa35,
         apc13_u LIKE apc_file.apc13,     #No.FUN-680027
         apa25    LIKE apa_file.apa25
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         apc01        LIKE apc_file.apc01, #No.FUN-680027
         apa07        LIKE apa_file.apa07,
         apc02    LIKE apc_file.apc02,    #No.FUN-680027
#        apa035_u     LIKE apa_file.apa35,
         apc13_u LIKE apc_file.apc13,     #No.FUN-680027
         apa25        LIKE apa_file.apa25
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_default1      STRING     
DEFINE   ms_type          LIKE type_file.chr1      #No.FUN-680131 VARCHAR(1)
DEFINE   ms_apa06         LIKE apa_file.apa06   #MOD-820002
DEFINE   ms_apa02         LIKE apa_file.apa02   #TQC-BC0115
DEFINE   ms_apa07         LIKE apa_file.apa07   #No.MOD-C30717   Add
DEFINE   ms_ret1          STRING     
#DEFINE   ms_ret2          STRING     #No.FUN-680027    TQC-6B0066
 
#FUNCTION q_apa2(pi_multi_sel,pi_need_cons,ps_default1,ps_type) #FUN-580012     #MOD-820002
#FUNCTION q_apa2(pi_multi_sel,pi_need_cons,ps_default1,ps_type,ps_apa06) #FUN-580012     #MOD-820002    #No.MOD-C30717   Mark
#FUNCTION q_apa2(pi_multi_sel,pi_need_cons,ps_default1,ps_type,ps_apa06,ps_apa07)                        #No.MOD-C30717   Add   #TQC-BC0115   Mark
FUNCTION q_apa2(pi_multi_sel,pi_need_cons,ps_default1,ps_type,ps_apa06,ps_apa07,ps_apa02) #TQC-BC0115
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_type        LIKE type_file.chr1,     #No.FUN-680131 VARCHAR(1)
            ps_apa06       LIKE apa_file.apa06,     #MOD-820002
            ps_apa07       LIKE apa_file.apa07,     #No.MOD-C30717   Add
            ps_apa02       LIKE apa_file.apa02,     #TQC-BC0115      Add
            ps_default1    STRING    
            {%與回傳欄位的個數相對應,格式為ps_default+流水號}
 
 
   LET ms_default1 = ps_default1
   LET ms_type     = ps_type    #FUN-580012
   LET ms_apa06    = ps_apa06   #MOD-820002
   LET ms_apa07    = ps_apa07   #No.MOD-C30717   Add
   LET ms_apa02    = ps_apa02   #TQC-BC0115      Add
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_apa2" ATTRIBUTE(STYLE="create_qry") #No.FUN-660161
 
   CALL cl_ui_locale("q_apa2")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 2003/09/16 by Hiko : 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("apc01", "red")      #No.FUN-680027
   END IF
 
   CALL apa2_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1
   ELSE
#     RETURN ms_ret1,ms_ret2        #No.FUN-680027 
      RETURN ms_ret1                #No.TQC-6B0066 
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
FUNCTION apa2_qry_sel()
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
 
      IF (li_reconstruct) THEN
         MESSAGE ""
 
         IF (mi_need_cons) THEN
            CONSTRUCT ms_cons_where ON apc01,apa07,apc02,apa25   #No.FUN-680027
                                  FROM s_apa[1].apc01,s_apa[1].apa07,s_apa[1].apc02,s_apa[1].apa25   #No.FUN-680027
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            
            END CONSTRUCT
 
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
 
         CALL apa2_qry_prep_result_set()
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
 
      CALL apa2_qry_set_display_data(li_start_index, li_end_index)
 
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN
         CALL apa2_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL apa2_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
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
FUNCTION apa2_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,   	#No.FUN-680131 VARCHAR(1)
            apc01    LIKE apc_file.apc01,                   
            apa07    LIKE apa_file.apa07,                   
            apc02    LIKE apc_file.apc02,    #No.FUN-680027
#           apa035_u LIKE apa_file.apa35,                   
            apc13_u LIKE apc_file.apc13,     #No.FUN-680027
            apa25    LIKE apa_file.apa25
   END RECORD
#No.FUN-680027--begin
   DEFINE   lr_arr   RECORD
            check    LIKE type_file.chr1,   	#No.FUN-680131 VARCHAR(1)
            apc01    LIKE apc_file.apc01,                   
            apa07    LIKE apa_file.apa07,                   
            apc02    LIKE apc_file.apc02,    #No.FUN-680027
            apc06    LIKE apc_file.apc06,                   
            apc16    LIKE apc_file.apc16,                   
            apc13    LIKE apc_file.apc13,                   
            apa25    LIKE apa_file.apa25
   END RECORD
#No.FUN-680027--end
 
   IF g_apz.apz27='Y' THEN   #TQC-610006
 
      #Begin:FUN-980030
      LET l_filter_cond = cl_get_extra_cond_for_qry('q_apa2', 'apa_file')
      IF NOT cl_null(l_filter_cond) THEN
         LET ms_cons_where = ms_cons_where,l_filter_cond
      END IF
      #End:FUN-980030
      LET ls_sql = "SELECT 'N',apa01,apa07,apc02,apc06,apc16,apc13,apa25 ",    #No.FUN-680027
                   "  FROM apa_file,apc_file",
                   " WHERE ",ms_cons_where,  #No.FUN-680027
                   "   AND apa01 =apc01"  #No.FUN-680027
   #-----TQC-610006---------
   ELSE
      LET ls_sql = "SELECT 'N',apa01,apa07,apc02,apc06,apc16,apc09-apc11,apa25 ",   #No.FUN-680027
#     LET ls_sql = "SELECT 'N',apc01,apa07,apa14,apa20,apa34-apa35,apa25 ",
                   "  FROM apa_file,apc_file",
                   " WHERE ",ms_cons_where,  #No.FUN-680027
                   "   AND apa01 =apc01"  #No.FUN-680027
   END IF
   #-----END TQC-610006
 
   IF NOT mi_multi_sel THEN
      #FUN-580012  --begin
      IF ms_type = '1' THEN 
         LET ls_where = "   AND apa00 like '2%' ",                                 
#                       "   AND apa00 <>'25' ",       #TQC-750140   #No.TQC-950113
                        "   AND (apa08 <>'UNAP' OR apa08 IS NULL) ",     #MOD-820129
                        "   AND (apa58 = '2' OR apa58 = '3' OR apa58 is null ) ",       
                        "   AND (apa73-apa20) > 0 ",     #bug no:A064                   
                        "   AND apa42 = 'N' "
      ELSE
        #TQC-750140 begin
         IF ms_type = '3' THEN
           LET ls_where = "   AND apa00 = '25' ",     #TQC-750140                              
                          "   AND (apa58 = '2' OR apa58 = '3' OR apa58 is null ) ",       
                          "   AND (apa73-apa20) > 0 ",     #bug no:A064                   
                          "   AND apa42 = 'N' "
                         ,"   AND apa07 = '",ms_apa07,"'"   #No.MOD-C30717   Add
         ELSE
        #TQC-750140 end 
           LET ls_where = "   AND apa00 like '1%' ",                                   
                          "   AND (apa58 = '2' OR apa58 = '3' OR apa58 is null ) ",       
                          "   AND (apa73-apa20) > 0 ",     #bug no:A064                   
                          "   AND apa41 = 'Y' AND apa42 = 'N' "
         END IF
      END IF
      #FUN-580012  --end
   END IF
   #LET ls_sql = ls_sql,ls_where," ORDER BY apc01"    #MOD-820002
#No.TQC-950113 --begin
#  LET ls_sql = ls_sql,ls_where,"AND apa06 = '",ms_apa06,"' ORDER BY apc01"   #MOD-820002
 
 
   LET ls_sql = ls_sql,ls_where,"AND ((apa06 = '",ms_apa06,"' AND apa00!='25')",
                                " OR apa00 ='25') ORDER BY apc01"   #MOD-820002
 
 
#No.TQC-950113 --end
 
   DISPLAY "ls_sql=",ls_sql
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
 
      LET lr_qry.check    = lr_arr.check
      LET lr_qry.apc01    = lr_arr.apc01
      LET lr_qry.apc02    = lr_arr.apc02       #No.FUN-680027
      LET lr_qry.apa07    = lr_arr.apa07
#     LET lr_qry.apa035_u = lr_arr.apa73 - lr_arr.apa20 * lr_arr.apa14
      LET lr_qry.apc13_u = lr_arr.apc13 - lr_arr.apc16*lr_arr.apc06    #No.FUN-680027
      LET lr_qry.apa25    = lr_arr.apa25
 
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
FUNCTION apa2_qry_set_display_data(pi_start_index, pi_end_index)
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
FUNCTION apa2_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_{%Record Name}.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_{%Record Name}.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_apa.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL apa2_qry_reset_multi_sel(pi_start_index, pi_end_index)
 
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
 
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_apa.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL apa2_qry_reset_multi_sel(pi_start_index, pi_end_index)
 
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
 
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION refresh
         CALL apa2_qry_refresh()
 
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
            CALL apa2_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL apa2_qry_accept(pi_start_index+ARR_CURR()-1)
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
FUNCTION apa2_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
FUNCTION apa2_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
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
         CALL apa2_qry_accept(pi_start_index+ARR_CURR()-1)
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
FUNCTION apa2_qry_refresh()
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
FUNCTION apa2_qry_accept(pi_sel_index)
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
               CALL lsb_multi_sel.append(ma_qry[li_i].apc01 CLIPPED)   #No.FUN-680027
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].apc01 CLIPPED)   #No.FUN-680027
            END IF
         END IF
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值.
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].apc01 CLIPPED
#     LET ms_ret2 = ma_qry[pi_sel_index].apc02 CLIPPED    #No.FUN-680027   TQC-6B0066
      {%設定多個回傳值.格式為ms_ret+流水號}
   END IF
END FUNCTION
