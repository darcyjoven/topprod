# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name   : q_m_apa2.4gl
# Program ver.   : 7.0
# Description    : 多工廠帳款資料查詢
# Date & Author  : 2003/09/23 by Winny
# Memo           : 
# Modify.........: No.FUN-4C0030 04/12/07 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-5B0081 05/11/21 By wujie 退貨立暫估相關修改 
# Modify.........: No.TQC-610006 06/01/04 By Smapmin 針對本幣未沖金額的抓取
#                                 應以apz27(月底重評價是否迴轉)的設定做區分
# Modify.........: No.MOD-670014 06/07/05 By Smapmin 新增重新查詢功能
# Modify.........: No.FUN-660161 06/07/07 By cl  增加匯出Excel功能
# Modify.........: No.FUN-680027 06/08/28 By cl  多帳期處理
# Modify.........: No.FUN-680131 06/09/01 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690080 06/11/01 By ice 增加apa_file,apc_file之間的關聯
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify.........: No.MOD-710062 07/01/11 By Smapmin 資料庫名稱不應影響原主程式
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.MOD-860078 08/06/10 BY yiting ON IDLE處理
# Modify.........: No.MOD-880203 08/08/29 By Sarah 開窗需過濾掉aapt210的apa58='1'的資料
# Modify.........: No.FUN-880082 08/09/01 By tsai_yen 開窗全選功能
# Modify.........: No.MOD-890039 08/09/03 By Sarah WHERE條件過濾apa08!='UNAP',改為(apa08!='UNAP' OR apa08 IS NULL)
# Modify.........: No.MOD-8C0229 08/12/25 By Sarah 開窗內容不過濾幣別apa13
# Modify.........: No.TQC-950048 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()  
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-990069 09/09/24 By baofei GP集團架構修改,sub相關參數
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No.TQC-A20062 10/03/01 By lutingting 參數apz26拿掉
# Modify.........: No.FUN-A50102 10/06/23 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No:CHI-B50055 11/06/24 By Dido 畫面增加 apa25 備註欄位 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
        #No.FUN-680027--begin-- mark
        #apa01    LIKE apa_file.apa01,
        #apa02    LIKE apa_file.apa02,
        #apa35_u  LIKE apa_file.apa35
        #No.FUN-680027--end-- mark
        #No.FUN-680027--begin-- add
         apc01    LIKE apc_file.apc01,
         apa02    LIKE apa_file.apa02,
         apc02    LIKE apc_file.apc02,
         apc13_u  LIKE apc_file.apc13,
         apa25    LIKE apa_file.apa25     #CHI-B50055
        #No.FUN-680027--end-- add
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
        #No.FUN-680027--begin-- mark
        #apa01    LIKE apa_file.apa01,
        #apa02    LIKE apa_file.apa02,
        #apa35_u  LIKE apa_file.apa35
        #No.FUN-680027--end-- mark
        #No.FUN-680027--begin-- add
         apc01    LIKE apc_file.apc01,
         apa02    LIKE apa_file.apa02,
         apc02    LIKE apc_file.apc02,
         apc13_u  LIKE apc_file.apc13,
         apa25    LIKE apa_file.apa25     #CHI-B50055
        #No.FUN-680027--end-- add
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_default1      STRING    
DEFINE   ms_ret1          STRING     #回傳欄位的變數
DEFINE   ms_ret2          LIKE apc_file.apc02   #回傳欄位的變數   #No.FUN-680027 add  #No.FUN-680131 SMALLINT
#DEFINE   g_dbs            LIKE type_file.chr21 	#No.FUN-680131 VARCHAR(21)
DEFINE   g_vendor         LIKE apa_file.apa06   #No.FUN-680131 VARCHAR(10)
DEFINE   g_emp_no         LIKE gen_file.gen01   #No.FUN-680131 VARCHAR(8)
DEFINE   g_cur            LIKE apa_file.apa13   #No.FUN-680131 VARCHAR(4)
DEFINE   g_aptype         LIKE apa_file.apa00   #No.FUN-680131 VARCHAR(2)
DEFINE   g_amt            LIKE apa_file.apa35   #FUN-4C0030  #No.FUN-680131 DECIMAL(20,6)
DEFINE   l_dbs            LIKE type_file.chr30     #MOD-710062
DEFINE   g_db_type        LIKE type_file.chr3     #MOD-710062 
 
#FUNCTION q_m_apa2(pi_multi_sel,pi_need_cons,p_dbs,p_vendor,p_emp_no,p_cur,p_aptype,ps_default1)  #FUN-990069    
FUNCTION q_m_apa2(pi_multi_sel,pi_need_cons,p_plant,p_vendor,p_emp_no,p_cur,p_aptype,ps_default1)   #FUN-990069
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    STRING  , #預設回傳值(在取消時會回傳此類預設值).
            p_plant        LIKE type_file.chr10, #FUN-990069 
            p_dbs          LIKE type_file.chr21, 	#No.FUN-680131 VARCHAR(21)
            p_vendor       LIKE apa_file.apa06,  #No.FUN-680131 VARCHAR(10)
            p_emp_no       LIKE gen_file.gen01,  #No.FUN-680131 VARCHAR(8)
            p_cur          LIKE apa_file.apa13,  #No.FUN-680131 VARCHAR(4)
            p_aptype       LIKE apa_file.apa00   #No.FUN-680131 VARCHAR(2)
            
#FUN-990069--begin            
    #IF cl_null(p_plant) THEN  #FUN-A50102 
    #   LET p_dbs = NULL        #FUN-A50102
    #ELSE                      #FUN-A50102
       LET g_plant_new = p_plant 
    #   CALL s_getdbs()        #FUN-A50102
    #   LET p_dbs = g_dbs_new  #FUN-A50102
    #END IF                     #FUN-A50102
#FUN-990069--end
   LET ms_default1 = ps_default1
   #-----MOD-710062---------
   #LET g_dbs = p_dbs   
  #IF g_apz.apz26 = 'Y' AND NOT cl_null(p_dbs) THEN    #TQC-A20062
   #IF NOT cl_null(p_dbs) THEN     #TQC-A20062
   IF NOT cl_null(p_plant) THEN #FUN-A50102
      LET g_db_type=cl_db_get_database_type()
#TQC-950048 MARK&ADD START---------------------  
#     IF g_db_type='IFX' THEN
#        LET l_dbs = p_dbs CLIPPED,":"  
#     ELSE
#        LET l_dbs = p_dbs CLIPPED,"."   
#     END IF
      #LET l_dbs = s_dbstring(p_dbs)   #add                                                                                          
#TQC-950048  END----------------------    
   END IF
   #-----END MOD-710062-----
   LET g_vendor = p_vendor
   LET g_emp_no = p_emp_no
   LET g_cur = p_cur
   LET g_aptype = p_aptype
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_m_apa2" ATTRIBUTE(STYLE="create_qry")  #No.FUN-660161
 
   CALL cl_ui_locale("q_m_apa2")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 2003/09/16 by Hiko :
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("apa01", "red")
   END IF
 
   CALL m_apa2_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 #複選資料只能回傳一個欄位的組合字串.
   ELSE
      RETURN ms_ret1,ms_ret2  #回傳值(也許有多個). #No.FUN-680027 add ms_ret2
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2003/09/23 by Winny
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION m_apa2_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 	#No.FUN-680131 SMALLINT
            li_continue      LIKE type_file.num5      #是否繼續.	#No.FUN-680131 SMALLINT
   DEFINE   li_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_curr_page     LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03
 
 
   LET mi_page_count = 100 #每頁顯現最大資料筆數.
   LET li_reconstruct = TRUE
 
   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      IF (li_reconstruct) THEN
         MESSAGE ""
         #-----MOD-670014---------
         IF (mi_need_cons) THEN
          # CONSTRUCT ms_cons_where ON apa01,apa02,apa35_u              #No.FUN-680027 mark 
          #                        FROM s_apa[1].apa01,s_apa[1].apa02,  #No.FUN-680027 mark  
          #                             s_apa[1].apa35_u                #No.FUN-680027 mark    
            CONSTRUCT ms_cons_where ON apc01,apa02,apc02,apc13_u,apa25  #No.FUN-680027 add  #CHI-B50055 add apa25 
                                   FROM s_apa[1].apc01,s_apa[1].apa02,  #No.FUN-680027 add  
                                        s_apa[1].apc02,s_apa[1].apc13_u,#No.FUN-680027 add
                                        s_apa[1].apa25                  #CHI-B50055
#--NO.MOD-860078 start---
  
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
#--NO.MOD-860078 end------- 
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
         #LET ms_cons_where = "1=1"
         #-----END MOD-670014-----
 
     
         CALL m_apa2_qry_prep_result_set() 
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
     
      CALL m_apa2_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL m_apa2_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL m_apa2_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2003/09/23 by Winny
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION m_apa2_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
    DEFINE   l_db_type    LIKE type_file.chr3    #MOD-4A0219  #No.FUN-680131 VARCHAR(3)
 
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,   #如果不需要複選資料,則不要設定此欄位	#No.FUN-680131 VARCHAR(1)
           #No.FUN-680027--begin-- mark
           #apa01    LIKE apa_file.apa01,
           #apa02    LIKE apa_file.apa02,
           #apa35_u  LIKE apa_file.apa35
           #No.FUN-680027--end-- mark
           #No.FUN-680027--begin-- add
            apc01    LIKE apc_file.apc01,
            apa02    LIKE apa_file.apa02,
            apc02    LIKE apc_file.apc02,
            apc13_u  LIKE apc_file.apc13,
            apa25    LIKE apa_file.apa25     #CHI-B50055
           #No.FUN-680027--end-- add
   END RECORD
 
    LET l_db_type=cl_db_get_database_type() #MOD-4A0219
 
   IF g_apz.apz27='Y' THEN   #TQC-610006
     #No.FUN-680027--begin--mark
     #LET ls_sql = "SELECT 'N',apa01,apa02,apa73-apa20*apa14",
     #              " FROM ",g_dbs,"apa_file",  #MOD-4A0219
     #             " WHERE ",ms_cons_where
     #No.FUN-680027--end-- mark
     #No.FUN-680027--begin--add
 
      #Begin:FUN-980030
      LET l_filter_cond = cl_get_extra_cond_for_qry('q_m_apa2', 'apc_file')
      IF NOT cl_null(l_filter_cond) THEN
         LET ms_cons_where = ms_cons_where,l_filter_cond
      END IF
      #End:FUN-980030
      LET ls_sql = "SELECT 'N',apc01,apa02,apc02,apc13-apc16*apa14,apa25 ",  #CHI-B50055 add apa25
                    #-----MOD-710062---------
                    #" FROM ",g_dbs,"apa_file ,",   
                    #         g_dbs,"apc_file  ", 
                    #" FROM ",l_dbs,"apa_file ,",   
                    #         l_dbs,"apc_file  ",
                   " FROM ",cl_get_target_table(g_plant_new,'apa_file'),",", #FUN-A50102   
                            cl_get_target_table(g_plant_new,'apc_file'),     #FUN-A50102 
                    #-----END MOD-710062-----
                   " WHERE ",ms_cons_where,
                   "   AND apa01 = apc01 "   #No.FUN-690080
     #No.FUN-680027--end-- add
   #-----TQC-610006---------
   ELSE 
     #No.FUN-680027--begin-- mark
     #LET ls_sql = "SELECT 'N',apa01,apa02,(apa34-apa35)-apa20*apa14",
     #              " FROM ",g_dbs,"apa_file",  #MOD-4A0219
     #             " WHERE ",ms_cons_where
     #No.FUN-680027--end-- mark
     #No.FUN-680027--begin-- add
      LET ls_sql = "SELECT 'N',apc01,apa02,apc02,(apc09-apc11)-apc16*apa14,apa25 ", #CHI-B50055 add apa25
                    #-----MOD-710062---------
                    #" FROM ",g_dbs,"apa_file ,",
                    #         g_dbs,"apc_file  ",
                    #" FROM ",l_dbs,"apa_file ,",
                    #         l_dbs,"apc_file  ",
                    " FROM ",cl_get_target_table(g_plant_new,'apa_file'),",", #FUN-A50102
                             cl_get_target_table(g_plant_new,'apc_file'),     #FUN-A50102
                    #-----END MOD-710062-----
                   " WHERE ",ms_cons_where,
                   "   AND apa01 = apc01 "   #No.FUN-690080
   END IF
   #-----END TQC-610006-----
   IF NOT mi_multi_sel THEN
      LET ls_where = " AND apaacti = 'Y'",
                     "   AND apa42 = 'N' ",
   	             "   AND apa06 = '",g_vendor CLIPPED,"'",
   	            #"   AND apa13 = '",g_cur    CLIPPED,"'",   #MOD-8C0229 mark
   	            #"   AND (apa73-apa20*apa14) > 0"   #No.FUN-680027 mark
   	             "   AND (apc13-apc16*apa14) > 0"   #No.FUN-680027 add
      #MOD-4A0219
     IF l_db_type='IFX' THEN
        LET ls_where=ls_where CLIPPED,
                    "   AND apa21 IN ",cl_parse(g_emp_no CLIPPED),
                    "   AND apa00 MATCHES '",g_aptype CLIPPED,"'"
     ELSE
        CALL s_chen_str(g_emp_no) RETURNING g_emp_no
        CALL s_chen_str(g_aptype) RETURNING g_aptype
        LET ls_where=ls_where CLIPPED,
                    "   AND apa21 LIKE    '",g_emp_no CLIPPED,"'",
                    "   AND apa00 LIKE    '",g_aptype CLIPPED,"'"
     END IF
     #--
 
   END IF
  #LET ls_sql = ls_sql CLIPPED," AND apa08 !='UNAP' "    #No.FUN-5B0081     #MOD-890039 mark
   LET ls_sql = ls_sql CLIPPED," AND (apa08 != 'UNAP' OR apa08 IS NULL) "   #MOD-890039
  #str MOD-880203 add
  #開窗需過濾掉aapt210的apa58='1'的資料
   IF g_aptype = '21' THEN
      LET ls_sql = ls_sql CLIPPED," AND apa58 != '1'"
   END IF
  #end MOD-880203 add
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED," ORDER BY apa01"
 
 
   DISPLAY "ls_sql=",ls_sql
 	 CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql        #FUN-920032
         CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql #FUN-A50102 
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   FOR li_i = ma_qry.getLength() TO 1 STEP -1
      CALL ma_qry.deleteElement(li_i)
   END FOR
 
   LET li_i = 1
   LET g_amt = 0
 
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
 
     #LET g_amt = g_amt + lr_qry.apa35_u   #No.FUN-680027 mark
      LET g_amt = g_amt + lr_qry.apc13_u   #No.FUn-680027 add
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2003/09/23 by Winny
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION m_apa2_qry_set_display_data(pi_start_index, pi_end_index)
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
# Date & Author : 2003/09/23 by Winny
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION m_apa2_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_apa.* 
   ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
   #ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_apa.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL m_apa2_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_apa.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL m_apa2_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL m_apa2_qry_refresh()
     
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
            CALL m_apa2_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL m_apa2_qry_accept(pi_start_index+ARR_CURR()-1)
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
# Date & Author : 2003/09/23 by Winny
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION m_apa2_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Date & Author : 2003/09/23 by Winny
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION m_apa2_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
    #MOD-4A0219
   DISPLAY g_vendor TO vendor
   DISPLAY g_cur    TO cur
   DISPLAY g_emp_no TO emp_no
   DISPLAY g_amt    TO tot   
   #--
 
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
         CALL m_apa2_qry_accept(pi_start_index+ARR_CURR()-1)
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
# Date & Author : 2003/09/23 by Winny
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION m_apa2_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2003/09/23 by Winny
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION m_apa2_qry_accept(pi_sel_index)
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
              #CALL lsb_multi_sel.append(ma_qry[li_i].apa01 CLIPPED)   #No.FUN-680027 mark
               CALL lsb_multi_sel.append(ma_qry[li_i].apc01 CLIPPED)   #No.FUN-680027 add
            ELSE
              #CALL lsb_multi_sel.append("|" || ma_qry[li_i].apa01 CLIPPED)  #No.FUN-680027 mark
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].apc01 CLIPPED)  #No.FUN-680027 add
            END IF
         END IF    
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].apc01 CLIPPED
      LET ms_ret2 = ma_qry[pi_sel_index].apc02 CLIPPED    #No.FUN-680027 add
   END IF
END FUNCTION
 
