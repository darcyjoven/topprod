# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#{
# Program name  : q_apa3.4gl
# Program ver.  : 7.0
# Description   : 待沖暫估帳帳查詢
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Memo          : 
# Modify        :
# Modify        : No.FUN-5B0081  05/11/21   BY wujie 退貨立暫估,增加負數暫估
# Modify........: No.TQC-610006 06/01/04 By Smapmin 針對本幣未沖金額的抓取
#                                 應以apz27(月底重評價是否迴轉)的設定做區分
# Modify........: No.MOD-640329 06/04/13 By Smapmin 修改暫估未沖金額
# Modify........: No.FUN-660161 06/07/07 By cl  增加匯出Excel功能
# Modify........: No.FUN-680027 06/08/16 By wujie 多帳期修改
# Modify........: No.FUN-680029 06/08/29 By wujie 兩套帳修改，增加return api041
# Modify........: No.FUN-680131 06/09/01 By Carrier 欄位型態用LIKE定義
# Modify........: No.MOD-710006 07/01/02 By Smapmin 待沖暫估金額有誤
# Modify........: No.MOD-750056 07/05/14 By Smapmin 修改待沖暫估金額
# Modify........: No.MOD-830006 08/03/03 By chenl   增加對金額欄位的取位功能。
#}
 
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.FUN-880082 08/08/29 By tsai_yen 開窗全選功能
# Modify.........: No.MOD-890193 08/09/19 By wujie 若是在退貨折讓作業中開窗，，金額應該是正的
# Modify.........: No.CHI-930001 09/03/04 By Sarah 當差異處理(apa56)為5.沖期初開帳的暫估時,開窗要撈沒單身的暫估資料
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         apa00    LIKE apa_file.apa00,             #FUN-5B0081 
         apc01    LIKE apc_file.apc01,             #No.FUN-680027
         apa54    LIKE apa_file.apa54,                   
         apa541   LIKE apa_file.apa541,            #No.FUN-680029         
         apa22    LIKE apa_file.apa22,                   
         apc02    LIKE apc_file.apc02,             #No.FUN-680027
         amt1     LIKE apa_file.apa34f,                  
         amt2     LIKE apa_file.apa34
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         apa00        LIKE apa_file.apa00,             #FUN-5B0081 
         apc01        LIKE apc_file.apc01,             #No.FUN-680027
         apa54        LIKE apa_file.apa54,                   
         apa541       LIKE apa_file.apa541,            #No.FUN-680029         
         apa22        LIKE apa_file.apa22,                   
         apc02        LIKE apc_file.apc02,             #No.FUN-680027
         amt1         LIKE apa_file.apa34f,                  
         amt2         LIKE apa_file.apa34
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_ret0          STRING     #No.FUN-5B0081 -負數暫估 
DEFINE   ms_ret1          STRING     
DEFINE   ms_ret2          STRING     
DEFINE   ms_ret3          STRING     
DEFINE   ms_ret4          LIKE apa_file.apa34f
DEFINE   ms_ret5          LIKE apa_file.apa34
DEFINE   ms_ret6          LIKE apc_file.apc02       #No.FUN-680027
DEFINE   ms_ret7          STRING                    #No.FUN-680029
DEFINE   mi_apa06         LIKE apa_file.apa06,                            
         mi_apa07         LIKE apa_file.apa07 
DEFINE   ms_default1      STRING
DEFINE   g_apa01          LIKE apa_file.apa01   #MOD-640329
DEFINE   t_azi04          LIKE azi_file.azi04   #No.MOD-830006
 
 FUNCTION q_apa3(pi_multi_sel,pi_need_cons,ps_default1,p_apa06,p_apa07,p_apa01)   #MOD-640329
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    STRING,
            p_apa06        LIKE apa_file.apa06,
            p_apa07        LIKE apa_file.apa07,
            p_apa01        LIKE apa_file.apa01   #MOD-640329
 
 
   LET ms_default1 = ps_default1
   LET mi_apa06    = p_apa06
   LET mi_apa07    = p_apa07
   LET g_apa01     = p_apa01   #MOD-640329
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_apa3" ATTRIBUTE(STYLE="create_qry") #No.FUN-660161
 
   CALL cl_ui_locale("q_apa3")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
#No.FUN-680029--begin 
   IF g_aza.aza63='N' THEN
      CALL cl_set_comp_visible("apa541",FALSE)
   END IF
#No.FUN-680029--end
 
   # 2003/09/16 by Hiko : 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("apc01", "red")     #No.FUN-680027
   END IF
 
   CALL apa3_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 
   ELSE
#No.FUN-680029--begin
      IF g_aza.aza63 ='Y' THEN
         RETURN ms_ret1,ms_ret6,ms_ret2,ms_ret7,ms_ret3,ms_ret4,ms_ret5  
      ELSE      
         RETURN ms_ret1,ms_ret6,ms_ret2,'',ms_ret3,ms_ret4,ms_ret5       
      END IF
#No.FUN-680029--end
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
FUNCTION apa3_qry_sel()
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
 
      #LET ms_cons_where = " 1=1"   #MOD-750056
      IF (li_reconstruct) THEN
         MESSAGE ""
     
         #-----MOD-750056---------
         IF (mi_need_cons) THEN
            CONSTRUCT ms_cons_where ON apa00,apc01,apa54,apa541,apa22,apc02 
                                  FROM s_apa[1].apa00,s_apa[1].apc01,
                                       s_apa[1].apa54,s_apa[1].apa541,
                                       s_apa[1].apa22,s_apa[1].apc02
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
         
            END CONSTRUCT
         
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
         #-----END MOD-750056----- 
         CALL apa3_qry_prep_result_set() 
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
     
      CALL apa3_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL apa3_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL apa3_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
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
FUNCTION apa3_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,   	#No.FUN-680131 VARCHAR(1)
            apa00    LIKE apa_file.apa00,       #No.FUN-5B0081   
            apc01    LIKE apc_file.apc01,       #No.FUN-680027            
            apa54    LIKE apa_file.apa54,                   
            apa541   LIKE apa_file.apa541,      #No.FUN-680029             
            apa22    LIKE apa_file.apa22,                   
            apc02    LIKE apc_file.apc02,       #No.FUN-680027            
            amt1     LIKE apa_file.apa34f,                  
            amt2     LIKE apa_file.apa34
   END RECORD
   DEFINE   lr_arr   RECORD
            check    LIKE type_file.chr1,   	#No.FUN-680131 VARCHAR(1)
            apa00    LIKE apa_file.apa00,       #No.FUN-5B0081   
            apc01    LIKE apc_file.apc01,       #No.FUN-680027            
            apa54    LIKE apa_file.apa54,                   
            apa541   LIKE apa_file.apa541,      #No.FUN-680029             
            apa22    LIKE apa_file.apa22,                   
            apc02    LIKE apc_file.apc02,       #No.FUN-680027
            apc08    LIKE apc_file.apc08,       #No.FUN-680027
            apc10    LIKE apc_file.apc10,       #No.FUN-680027
            apc13    LIKE apc_file.apc13,       #No.FUN-680027
            apa13    LIKE apa_file.apa13        #No.MOD-830006
   END RECORD
   DEFINE l_api05    LIKE api_file.api05,   #MOD-640329
          l_api05f   LIKE api_file.api05f   #MOD-640329
   DEFINE l_apa00    LIKE apa_file.apa00    #No.MOD-890193   
   DEFINE l_apa56    LIKE apa_file.apa56    #CHI-930001 add
  
   SELECT apa56 INTO l_apa56 FROM apa_file WHERE apa01=g_apa01  #CHI-930001 add
 
#No.FUN-5B0081--begin 
   IF g_apz.apz27='Y' THEN   #TQC-610006
#     LET ls_sql = "SELECT 'N',apa00,apa01,apa54,apa22,apa34f,apa35f,apa73 ", 
 
      #Begin:FUN-980030
      LET l_filter_cond = cl_get_extra_cond_for_qry('q_apa3', 'apa_file')
      IF NOT cl_null(l_filter_cond) THEN
         LET ms_cons_where = ms_cons_where,l_filter_cond
      END IF
      #End:FUN-980030
      LET ls_sql = "SELECT 'N',apa00,apc01,apa54,apa541,apa22,apc02,apc08,apc10,apc13,apa13 ",      #No.FUN-680027  No.FUN-680029 #No.MOD-830006
                   #"  FROM apa_file",   #MOD-750056
                   "  FROM apa_file,apc_file",   #MOD-750056
                   " WHERE ",ms_cons_where,
                   "   AND apc01 =apa01"         #No.FUN-680027
   #-----TQC-610006---------
   ELSE
#     LET ls_sql = "SELECT 'N',apa00,apa01,apa54,apa22,apa34f,apa35f,apa34-apa35 ", 
      LET ls_sql = "SELECT 'N',apa00,apc01,apa54,apa541,apa22,apc02,apc08,apc10,apc09-apc11,apa13 ",      #No.FUN-680027   No.FUN-680029 #No.MOD-830006
                   #"  FROM apa_file",   #MOD-750056
                   "  FROM apa_file,apc_file",   #MOD-750056
                   " WHERE ",ms_cons_where,
                   "   AND apc01 =apa01"         #No.FUN-680027
   END IF
   #-----END TQC-610006-----
   IF NOT mi_multi_sel THEN
#      LET ls_where = "   AND  apa00 matches '1*' ",  #No.MOD-480129
#                    "   AND  apa41 = 'Y' ",                                         
       LET ls_where ="   AND  apa41 = 'Y' ",
                     "   AND  apa08 ='UNAP' ",                                       
                     "   AND (apa73-apa20*apa14) > 0 ",                              
                     "   AND apa06='",mi_apa06,"' AND apa07='",mi_apa07,"' "
   END IF
  #str CHI-930001 add
  #當差異處理為5.沖期初開帳的暫估時,開窗要撈沒單身的暫估資料
   IF l_apa56 = '5' THEN
      LET ls_where =ls_where CLIPPED,
                    "   AND apa01 NOT IN (SELECT apb01 FROM apb_file)"
   END IF
  #end CHI-930001 add
#  LET ls_sql = ls_sql CLIPPED, ls_where CLIPPED, " ORDER BY apa01"                                                                 
   LET ls_sql = ls_sql CLIPPED, ls_where CLIPPED, " ORDER BY apa00,apc01"                                                           
#No.FUN-5B0081--end 
 
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
      #No.MOD-830006--begin-- 
      SELECT azi04 INTO t_azi04 FROM azi_file
       WHERE azi01 = lr_arr.apa13 
      #No.MOD-830006---end---
      #-----MOD-640329---------
      SELECT SUM(api05),SUM(api05f) INTO l_api05,l_api05f
        FROM api_file,apa_file
         WHERE api01=apa01 AND api26 = lr_arr.apc01 AND
               #api01 <> g_apa01 AND apa42 <> 'X'   #MOD-710006
               api01 <> g_apa01 AND apa41 = 'N' AND apa42 = 'N'    #MOD-710006
               AND api40 =lr_arr.apc02          #No.FUN-680027
      IF cl_null(l_api05) THEN LET l_api05 = 0 END IF
      IF cl_null(l_api05f) THEN LET l_api05f = 0 END IF
      #-----END MOD-640329----- 
      #-----MOD-750056---------
#No.MOD-890193 --begin                                                          
      SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01 =g_apa01              
      IF lr_arr.apa00 = '26' AND l_apa00 MATCHES '[1*]' THEN                    
#     IF lr_arr.apa00 = '26' THEN                                               
#No.MOD-890193 --end  
         LET l_api05 = l_api05 * -1
         LET l_api05f = l_api05f * -1
      END IF
      #-----END MOD-750056-----
      LET lr_qry.check = lr_arr.check
      LET lr_qry.apa00 = lr_arr.apa00    #No.FUN-5B0081 
      LET lr_qry.apc01 = lr_arr.apc01    #No.FUN-680027
      LET lr_qry.apc02 = lr_arr.apc02    #No.FUN-680027
      LET lr_qry.apa54 = lr_arr.apa54
      LET lr_qry.apa541= lr_arr.apa541   #No.FUN-680029
      LET lr_qry.apa22 = lr_arr.apa22
      #-----MOD-640329---------
      #LET lr_qry.amt1  = lr_arr.apa34f - lr_arr.apa35f
      #LET lr_qry.amt2  = lr_arr.apa73                    
      LET lr_qry.amt1  = lr_arr.apc08 - lr_arr.apc10 - l_api05f
      LET lr_qry.amt2  = lr_arr.apc13 - l_api05                   
      #-----END MOD-640329----- 
      #-----MOD-750056---------
#No.MOD-890193 --begin                                                          
      SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01 =g_apa01              
      IF lr_arr.apa00 = '26' AND l_apa00 MATCHES '[1*]' THEN                    
#     IF lr_arr.apa00 = '26' THEN                                               
#No.MOD-890193 --end  
         LET lr_qry.amt1 = lr_qry.amt1 * -1
         LET lr_qry.amt2 = lr_qry.amt2 * -1
      END IF
      #-----END MOD-750056-----
      LET lr_qry.amt1 = cl_digcut(lr_qry.amt1,t_azi04)  #No.MOD-830006 
      LET lr_qry.amt2 = cl_digcut(lr_qry.amt2,g_azi04)  #No.MOD-830006 
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
FUNCTION apa3_qry_set_display_data(pi_start_index, pi_end_index)
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
FUNCTION apa3_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
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
         CALL apa3_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_apa.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL apa3_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL apa3_qry_refresh()
     
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
            CALL apa3_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL apa3_qry_accept(pi_start_index+ARR_CURR()-1)
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
FUNCTION apa3_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
FUNCTION apa3_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
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
         CALL apa3_qry_accept(pi_start_index+ARR_CURR()-1)
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
FUNCTION apa3_qry_refresh()
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
FUNCTION apa3_qry_accept(pi_sel_index)
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
               CALL lsb_multi_sel.append(ma_qry[li_i].apc01 CLIPPED)         #No.FUN-680027
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].apc01 CLIPPED)         #No.FUN-680027
            END IF
         END IF    
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret0 = ma_qry[pi_sel_index].apa00 CLIPPED   #No.FUN-5B0081  
      LET ms_ret1 = ma_qry[pi_sel_index].apc01 CLIPPED   #No.FUN-680027
      LET ms_ret2 = ma_qry[pi_sel_index].apa54 CLIPPED
      LET ms_ret7 = ma_qry[pi_sel_index].apa541 CLIPPED  #No.FUN-680029
      LET ms_ret3 = ma_qry[pi_sel_index].apa22 CLIPPED
      LET ms_ret6 = ma_qry[pi_sel_index].apc02 CLIPPED   #No.FUN-680027
      LET ms_ret4 = ma_qry[pi_sel_index].amt1
      LET ms_ret5 = ma_qry[pi_sel_index].amt2            #No.MOD-480131
   END IF
END FUNCTION
