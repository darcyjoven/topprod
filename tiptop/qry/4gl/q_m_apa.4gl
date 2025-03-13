# Prog. Version..: '5.30.06-13.03.27(00010)'     #
#
# Program name   : q_m_apa.4gl
# Program ver.   : 7.0
# Description    : 多工廠帳款資料查詢
# Date & Author  : 2003/09/23 by Winny
# Memo           : 
# Modify.........: No.FUN-4C0030 04/12/07 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.MOD-670014 06/07/05 By Smapmin 新增重新查詢功能
# Modify.........: No.FUN-660161 06/07/07 By cl  增加匯出Excel功能
# Modify.........: No.FUN-680027 06/08/28 By cl  多帳期處理 
# Modify.........: No.FUN-680131 06/09/01 By Carrier 欄位型態用LIKE定義
# Modify.........: No.TQC-6A0042 06/10/23 By Smapmin 當apz26='Y'時,才使用p_dbs的變數
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify.........: No.FUN-6A0092 06/11/17 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.MOD-710062 07/01/11 By Smapmin 資料庫名稱不應影響原主程式
# Modify.........: No.TQC-760075 07/06/08 By Rayven 當aapt600調用此程式時不需要判斷apz26
# Modify.........: No.MOD-7B0115 07/11/13 By xufeng 衝賬的時候不應該帶出暫估的帳款
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.MOD-840409 08/04/24 By Carrier 加入傳入參數'簡稱',用于過濾開出來的資料
# Modify.........: NO.MOD-860078 08/06/10 BY yiting ON IDLE處理
# Modify.........: No.FUN-880082 08/09/01 By tsai_yen 開窗全選功能
# Modify.........: No.TQC-950048 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()  
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-990069 09/09/24 By baofei GP集團架構修改,sub相關參數
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No.TQC-A20062 10/03/01 By lutingting 拿掉參數apz26 
# Modify.........: No.FUN-A50102 10/06/23 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A70102 10/07/13 By Dido 增加付款日期參數作為過濾條件  
# Modify.........: No:MOD-B70047 11/07/07 By Dido 未付金額應包含 apc14/apc15
# Modify.........: No.FUN-C90027 12/09/27 By xuxz 添加aapt335的內容
# Modify.........: No:FUN-CB0066 11/11/20 By wujie aapt330系列可以开窗复选
# Modify.........: No:MOD-D30156 13/03/15 By Polly 調整過濾實際廠商加幣別條件
# Modify.........: No:FUN-D80047 13/08/15 By lujh aapt120,aapt110,aapt330衝賬時，開窗和AFTER FIELD時檢查預對應的aapt150單据是否已經付款,沒有付款則不可以使用。
# Modify.........: No:FUN-D80086 13/08/22 By lujh 賬款部分開窗選賬款單時，畫面下面加個合計金額，能自動把勾選的賬款金額計算出來

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
        #No.FUN-680027--begin-- mark
        #apa01    LIKE apa_file.apa01,
        #apa36    LIKE apa_file.apa36,
        #apa08    LIKE apa_file.apa08,
        #apa12    LIKE apa_file.apa12,
        #apa24    LIKE apa_file.apa24,
        #apa35u   LIKE apa_file.apa35
        #No.FUN-680027--end-- mark
        #No.FUN-680027--begin-- add
         apc01    LIKE apc_file.apc01,
         apa36    LIKE apa_file.apa36,
         apc02    LIKE apc_file.apc02,
         apc12    LIKE apc_file.apc12,
         apc04    LIKE apc_file.apc04,
         apc05    LIKE apc_file.apc05,
         apc13_u  LIKE apc_file.apc13 
        #No.FUN-680027--end-- add
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
       ##No.FUN-680027--begin-- mark
       # apa01    LIKE apa_file.apa01,
       # apa36    LIKE apa_file.apa36,
       # apa08    LIKE apa_file.apa08,
       # apa12    LIKE apa_file.apa12,
       # apa24    LIKE apa_file.apa24,
       # apa35u   LIKE apa_file.apa35
       ##No.FUN-680027--end-- mark
        #No.FUN-680027--begin-- add
         apc01    LIKE apc_file.apc01,
         apa36    LIKE apa_file.apa36,
         apc02    LIKE apc_file.apc02,
         apc12    LIKE apc_file.apc12,
         apc04    LIKE apc_file.apc04,
         apc05    LIKE apc_file.apc05,
         apc13_u  LIKE apc_file.apc13 
        #No.FUN-680027--end-- add
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_default1      STRING    
DEFINE   ms_ret1          STRING     #回傳欄位的變數
DEFINE   ms_ret2          LIKE apc_file.apc02   #回傳欄位的變數   #No.FUN-680027  #No.FUN-680131 SMALLINT
#DEFINE   g_dbs	          LIKE type_file.chr21 	#No.FUN-680131 VARCHAR(21)
DEFINE   g_vendor         LIKE apa_file.apa06   #No.FUN-680131 VARCHAR(10)
DEFINE   g_abbr           LIKE apa_file.apa07   #MOD-840409
DEFINE   g_emp_no	  LIKE gen_file.gen01   #No.FUN-680131 VARCHAR(8)
DEFINE   g_cur   	  LIKE apa_file.apa13   #No.FUN-680131 VARCHAR(4)
DEFINE   g_aptype         LIKE apa_file.apa00   #No.FUN-680131 VARCHAR(2)
DEFINE   g_amt            LIKE apa_file.apa35   #FUN-4C0030  #No.FUN-680131 DEC(20,6)
DEFINE   l_dbs            LIKE type_file.chr30  #MOD-710062
DEFINE   g_paydate        LIKE apa_file.apa02   #MOD-A70102
DEFINE   g_input          LIKE type_file.chr1   #No.FUN-CB0066 
#DEFINE   g_amt1           LIKE apa_file.apa35   #FUN-D80086 add
 
#FUNCTION q_m_apa(pi_multi_sel,pi_need_cons,p_dbs,p_vendor,p_emp_no,p_cur,p_aptype,ps_default1,p_abbr)  #No.MOD-840409  #FUN-990069
#FUNCTION q_m_apa(pi_multi_sel,pi_need_cons,p_plant,p_vendor,p_emp_no,p_cur,p_aptype,ps_default1,p_abbr)  #No.MOD-840409   #FUN-990069          #MOD-A70102 mark
FUNCTION q_m_apa(pi_multi_sel,pi_need_cons,p_plant,p_vendor,p_emp_no,p_cur,p_aptype,ps_default1,p_abbr,p_paydate)  #No.MOD-840409  #FUN-990069  #MOD-A70102
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    STRING  , #預設回傳值(在取消時會回傳此類預設值).
            p_plant        LIKE type_file.chr10,        #FUN-990069 
            p_dbs	   LIKE type_file.chr21, 	#No.FUN-680131 VARCHAR(21)
            p_vendor       LIKE apa_file.apa06,         #No.FUN-680131 VARCHAR(10)
            p_emp_no	   LIKE gen_file.gen01,         #No.FUN-680131 VARCHAR(8)
            p_cur   	   LIKE apa_file.apa13,         #No.FUN-680131 VARCHAR(4)
            p_aptype       LIKE apa_file.apa00          #No.FUN-680131 VARCHAR(2)
   DEFINE   p_abbr         LIKE apa_file.apa07          #No.MOD-840409
   DEFINE   p_paydate      LIKE apa_file.apa02          #MOD-A70102
   DEFINE   g_db_type      LIKE type_file.chr3          #TQC-6A0042
 
#No.FUN-CB0066 --begin
#为aapt330/aapt331/aapt332/aapt335系列特别使用的，input时可以开窗复选，回传多行数据
    LET g_input = 'N' 
    IF NOT pi_multi_sel AND 
       (g_prog = 'aapt330' OR g_prog = 'aapt331' OR g_prog = 'aapt332' OR g_prog = 'aapt335') THEN
       	LET g_input = 'Y' 
       	LET  pi_multi_sel = TRUE 
    END IF 
#No.FUN-CB0066 --end
#FUN-990069--begin            
    IF cl_null(p_plant) THEN   
       LET p_dbs = NULL        
       LET g_plant_new = p_plant #FUN-A50102
    ELSE                      
       LET g_plant_new = p_plant 
       CALL s_getdbs()        
       LET p_dbs = g_dbs_new  
    END IF                     
#FUN-990069--end
   LET ms_default1 = ps_default1
   #LET g_dbs = p_dbs CLIPPED,":"  #MOD-4A0171
   #-----TQC-6A0042---------
#  IF g_apz.apz26 = 'Y' AND NOT cl_null(p_dbs) THEN  #No.TQC-760075 mark
#  IF (g_apz.apz26 = 'Y' OR g_prog = 'aapt600') AND NOT cl_null(p_dbs) THEN #No.TQC-760075   #TQC-A20062
   IF g_prog = 'aapt600' AND NOT cl_null(p_dbs) THEN #TQC-A20062
      LET g_db_type=cl_db_get_database_type()
#TQC-950048  MARK&ADD START-------------------------------------- 
#     IF g_db_type='IFX' THEN
#        #LET g_dbs = p_dbs CLIPPED,":"   #MOD-710062
#        LET l_dbs = p_dbs CLIPPED,":"   #MOD-710062
#     ELSE
#        #LET g_dbs = p_dbs CLIPPED,"."   #MOD-710062
#        LET l_dbs = p_dbs CLIPPED,"."   #MOD-710062
#     END IF
      LET l_dbs = s_dbstring(p_dbs)   #ADD                                                                                          
#TQC-950048 END----------------------------------------------------     
   END IF
   #-----END TQC-6A0042-----
   LET g_vendor = p_vendor
   LET g_abbr   = p_abbr     #No.MOD-840409
   LET g_emp_no = p_emp_no
   LET g_cur = p_cur
   LET g_aptype = p_aptype
   LET g_paydate = p_paydate     #MOD-A70102
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_m_apa" ATTRIBUTE(STYLE="create_qry") #No.FUN-660161
 
   CALL cl_ui_locale("q_m_apa")
 
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
 
   CALL m_apa_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 #複選資料只能回傳一個欄位的組合字串.
   ELSE
      RETURN ms_ret1,ms_ret2 #回傳值(也許有多個).  #No.FUN-680027 add ms_ret2
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
FUNCTION m_apa_qry_sel()
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
          # CONSTRUCT ms_cons_where ON apa01,apa36,apa08,apa12,apa24,apa35_u #No.FUN-680027 mark 
          #                        FROM s_apa[1].apa01,s_apa[1].apa36,       #No.FUN-680027 mark  
          #                             s_apa[1].apa08,s_apa[1].apa12,       #No.FUN-680027 mark   
          #                             s_apa[1].apa24,s_apa[1].apa35_u      #No.FUN-680027 mark   
            CALL cl_set_head_visible("grid01,grid02","YES")       #No.FUN-6A0092
 
            CONSTRUCT ms_cons_where ON apc01,apa36,apc02,apc12,apc04,apc05,apc13_u    #No.FUN-680027 add 
                                   FROM s_apa[1].apc01,s_apa[1].apa36,s_apa[1].apc02, #No.FUN-680027 add   
                                        s_apa[1].apc12,s_apa[1].apc04,                #No.FUN-680027 add  
                                        s_apa[1].apc05,s_apa[1].apc13_u               #No.FUN-680027 add   
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
         #-----END MOD-670014-----
 
         CALL m_apa_qry_prep_result_set() 
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
     
      CALL m_apa_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL m_apa_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL m_apa_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
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
FUNCTION m_apa_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   l_db_type    LIKE type_file.chr3    #No.FUN-680131 VARCHAR(3)
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,   #如果不需要複選資料,則不要設定此欄位	#No.FUN-680131 VARCHAR(1)
           #No.FUN-680027--begin-- mark
           #apa01    LIKE apa_file.apa01,
           #apa36    LIKE apa_file.apa36,
           #apa08    LIKE apa_file.apa08,
           #apa12    LIKE apa_file.apa12,
           #apa24    LIKE apa_file.apa24,
           #apa35u   LIKE apa_file.apa35
           #No.FUN-680027--end-- mark
           #No.FUN-680027--begin-- add
            apc01    LIKE apc_file.apc01,
            apa36    LIKE apa_file.apa36,
            apc02    LIKE apc_file.apc02,
            apc12    LIKE apc_file.apc12,
            apc04    LIKE apc_file.apc04,
            apc05    LIKE apc_file.apc05,
            apc13_u  LIKE apc_file.apc13 
           #No.FUN-680027--end-- add
   END RECORD
 
   LET l_db_type=cl_db_get_database_type()
  
  #No.FUN-680027--begin-- mark
  #LET ls_sql = "SELECT 'N',apa01,apa36,apa08,apa12,apa24,",
  #             "       apa34f-apa35f-apa20",
  #             #" FROM ",g_dbs CLIPPED," apa_file",   #MOD-670014
  #             " FROM apa_file",   #MOD-670014
  #             #" WHERE apaacti = 'Y' ",ms_cons_where   #MOD-670014
  #             " WHERE apaacti = 'Y' AND ",ms_cons_where   #MOD-670014
  #No.FUN-680027--end-- mark
  #No.FUN-680027--begin-- add
   #-----TQC-6A0042---------
#  IF g_apz.apz26='Y' THEN                       #No.TQC-760075 mark
#  IF g_apz.apz26='Y' OR g_prog = 'aapt600' THEN #No.TQC-760075   #TQC-A20062
   IF g_prog = 'aapt600' THEN    #TQC-A20062
 
      #Begin:FUN-980030
      LET l_filter_cond = cl_get_extra_cond_for_qry('q_m_apa', 'apc_file')
      IF NOT cl_null(l_filter_cond) THEN
         LET ms_cons_where = ms_cons_where,l_filter_cond
      END IF
      #End:FUN-980030
      LET ls_sql = "SELECT 'N',apc01,apa36,apc02,apc12,apc04,apc05,",
                   "       apc08-apc10-apc16-apc14 ",     #MOD-B70047 add apc14
                   #" FROM ",g_dbs CLIPPED,"apa_file,",g_dbs CLIPPED,"apc_file ",     #MOD-710062
                   #" FROM ",l_dbs CLIPPED,"apa_file,",l_dbs CLIPPED,"apc_file ",     #MOD-710062
                   " FROM ",cl_get_target_table(g_plant_new,'apa_file') ,"a ,", #FUN-A50102    #FUN-D80047 add a
                            cl_get_target_table(g_plant_new,'apc_file'),     #FUN-A50102
                  #" WHERE apaacti = 'Y' AND apa01=apc01  AND ",ms_cons_where        #MOD-A70102 mark
                   " WHERE apaacti = 'Y' AND apa01=apc01 ",                          #MOD-A70102
                   "   AND apa02 <= '",g_paydate,"' AND ",ms_cons_where              #MOD-A70102 
   ELSE
   #-----END TQC-6A0042-----
      LET ls_sql = "SELECT 'N',apc01,apa36,apc02,apc12,apc04,apc05,",
                   "       apc08-apc10-apc16-apc14 ",     #MOD-B70047 add apc14
                   " FROM apa_file a,apc_file ",     #FUN-D80047 add a
                  #" WHERE apaacti = 'Y' AND apa01=apc01  AND ",ms_cons_where        #MOD-A70102 mark
                   " WHERE apaacti = 'Y' AND apa01=apc01 ",                          #MOD-A70102
                   "   AND apa02 <= '",g_paydate,"' AND ",ms_cons_where              #MOD-A70102 
   END IF
  #No.FUN-680027--end-- add
  #IF NOT mi_multi_sel AND g_input = 'Y' THEN   #No.FUN-CB0066 add g_input #MOD-D30156 mark
   IF NOT mi_multi_sel OR g_input = 'Y' THEN    #MOD-D30156 add
      #No.MOD-840409   --Begin
      LET ls_where = "   AND apa06 = '",g_vendor CLIPPED,"'",
                     "   AND apa07 = '",g_abbr   CLIPPED,"'",   #No.MOD-840409
                     "   AND apa13 = '",g_cur    CLIPPED,"'",
                   # "   AND apa34f > (apa35f+apa20) AND apa41='Y' "  #No.FUN-680027 mark
                     "   AND apc08  > (apc10+apc16+apc14) AND apa41='Y' ",  #No.FUN-680027 add #MOD-B70047 add apc14
                     #FUN-D80047--add--str--
                     "   AND NOT EXISTS ",
                     " (SELECT 1 FROM apa_file b,oox_file",
                     "   WHERE oox03 = apa01 ",
                     "     AND apa00 = '15' ",
                     "     AND a.apa01 = b.apa01 ",
                     "     AND oox01 = ",g_apz.apz21,
                     "     AND oox02 = ",g_apz.apz22,
                     "     AND apa34f-apa35f != 0 ",
                     "     AND apa34-apa35-oox10 != 0 )"
                     #FUN-D80047--add--end--
      #No.MOD-840409   --End  
       #MOD-4A0171
      IF l_db_type='IFX' THEN
         LET ls_where=ls_where CLIPPED,
                     "   AND apa21 MATCHES '",g_emp_no CLIPPED,"'",
                     "   AND apa00 MATCHES '",g_aptype CLIPPED,"'",
                     "   AND apa00 <>'16'",      #MOD-7B0115
                     "   AND apa00 <>'26'"       #yinhy131014
      ELSE
         CALL s_chen_str(g_emp_no) RETURNING g_emp_no
         CALL s_chen_str(g_aptype) RETURNING g_aptype
         LET ls_where=ls_where CLIPPED,
                     "   AND apa21 LIKE    '",g_emp_no CLIPPED,"'",
                     "   AND apa00 LIKE    '",g_aptype CLIPPED,"'",
                     "   AND apa00 <>'16'",      #MOD-7B0115
                     "   AND apa00 <>'26'"       #yinhy131014
      END IF
      #--
   END IF
  #FUN-C90027--add--str
   IF g_prog = 'aapt335' THEN
      IF g_aptype = '1%' THEN
         LET ls_where=ls_where CLIPPED,
                     "  AND apa00 <> '16' "
      END IF
      IF g_aptype = '2%' THEN
         LET ls_where=ls_where CLIPPED,
                     "  AND apa00 <> '26' "
      END IF
   END IF
  #FUN-C90027--add--end
  #LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED," ORDER BY apa01"         #No.FUN-680027 mark
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED," ORDER BY apc01,apc02"   #No.FUN-680027 add
 
   DISPLAY "ls_sql=",ls_sql
 	 CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql        #FUN-920032
         CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql #FUN-A50102 
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   FOR li_i = ma_qry.getLength() TO 1 STEP -1
      CALL ma_qry.deleteElement(li_i)
   END FOR
 
   LET li_i = 1
 
   LET g_amt=0
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
    # LET g_amt = g_amt + ma_qry[li_i].apa35u   #No.FUN-680027 mark
      LET g_amt = g_amt + ma_qry[li_i].apc13_u  #No.FUN-680027 add
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
FUNCTION m_apa_qry_set_display_data(pi_start_index, pi_end_index)
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
FUNCTION m_apa_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
   #LET g_amt1 = 0   #FUN-D80086 add
   #DISPLAY g_vendor TO formonly.vendor    #FUN-D80086 add
   #DISPLAY g_emp_no TO formonly.emp_no    #FUN-D80086 add
   #DISPLAY g_cur TO formonly.cur          #FUN-D80086 add
   #DISPLAY g_abbr  TO formonly.abbr       #FUN-D80086 add 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_apa.* 
   ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
   #ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      #FUN-D80086--add--str--   
#      ON CHANGE CHECK
#        IF ma_qry_tmp[ARR_CURR()].CHECK = 'Y' THEN
#           LET g_amt1 = g_amt1 + ma_qry_tmp[ARR_CURR()].apc13_u   
#        ELSE
#           LET g_amt1 = g_amt1 - ma_qry_tmp[ARR_CURR()].apc13_u       
#        END IF 
#        DISPLAY g_amt1 TO tot1
      #FUN-D80086--add--end--          
      ON ACTION prevpage
         CALL GET_FLDBUF(s_apa.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL m_apa_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_apa.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL m_apa_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL m_apa_qry_refresh()
     
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
            CALL m_apa_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL m_apa_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                        #CHI-9C0048
            LET ms_ret1 = NULL       #CHI-9C0048
         END IF                      #CHI-9C0048
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG=0 #No.CHI-690081
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF
 
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("grid01,grid02","AUTO")           #No.FUN-6A0092
 
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
FUNCTION m_apa_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
FUNCTION m_apa_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY g_vendor TO vendor
   DISPLAY g_abbr   TO abbr     #No.MOD-840409
   DISPLAY g_cur    TO cur
   DISPLAY g_emp_no TO emp_no
   DISPLAY g_amt    TO tot   
 
   DISPLAY g_vendor
   DISPLAY g_abbr               #No.MOD-840409
   DISPLAY g_cur   
   DISPLAY g_emp_no
   DISPLAY g_amt
 
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
         CALL m_apa_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG=0 #No.CHI-690081
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
    
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("grid01,grid02","AUTO")           #No.FUN-6A0092
 
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
FUNCTION m_apa_qry_refresh()
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
FUNCTION m_apa_qry_accept(pi_sel_index)
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
             # CALL lsb_multi_sel.append(ma_qry[li_i].apa01 CLIPPED)  #No.FUN-680027 mark
               CALL lsb_multi_sel.append(ma_qry[li_i].apc01 CLIPPED)  #No.FUN-680027 add
            ELSE
             # CALL lsb_multi_sel.append("|" || ma_qry[li_i].apa01 CLIPPED)  #No.FUN-680027 mark
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].apc01 CLIPPED)  #No.FUN-680027 add
            END IF
         END IF    
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
#No.FUN-CB0066 --begin
#为aapt330/aapt331/aapt332/aapt335系列特别使用的，可以开窗复选，回传多行数据，格式为“单号,行号|单号,行号|单号,行号”
      IF g_input = 'Y' THEN 
         LET lsb_multi_sel = base.StringBuffer.create()
         
         FOR li_i = 1 TO ma_qry.getLength()
            IF (ma_qry[li_i].check = 'Y') THEN
               IF (lsb_multi_sel.getLength() = 0) THEN
                  CALL lsb_multi_sel.append(ma_qry[li_i].apc01||","||ma_qry[li_i].apc02 CLIPPED) 
               ELSE
                  CALL lsb_multi_sel.append("|" || ma_qry[li_i].apc01||","||ma_qry[li_i].apc02 CLIPPED)
               END IF
            END IF    
         END FOR 
         LET ms_ret1 = lsb_multi_sel.toString()      	
      END IF 
      LET g_input = 'N' 
#No.FUN-CB0066 --end
   ELSE
     #LET ms_ret1 = ma_qry[pi_sel_index].apa01 CLIPPED #No.FUN-680027 mark
      LET ms_ret1 = ma_qry[pi_sel_index].apc01 CLIPPED #No.FUN-680027 add 
      LET ms_ret2 = ma_qry[pi_sel_index].apc02 CLIPPED #No.FUN-680027 add 
   END IF
END FUNCTION
