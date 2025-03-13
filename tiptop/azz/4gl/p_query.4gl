# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: p_query
# Descriptions...: 自定義查詢功能設定作業
# Date & Author..: 06/09/15 Echo   #FUN-690069
# Modify.........: No.FUN-6A0092 06/11/24 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-740075 07/04/13 By Xufeng "CLEAR FROM"應改為"CLEAR FORM"
# Modify.........: No.FUN-750084 07/05/23 By Echo 新增客製碼欄位、複製功能
# Modify.........: No.FUN-770079 07/07/24 By Echo 第二階段功能調整:欄位值轉換功能、查詢畫面 Input 功能...等
# Modify.........: No.FUN-770026 07/08/31 By shine p_addview
# Modify.........: No.TQC-790037 07/09/17 By Echo 轉換值設定:無法刪除「2:其他」資料
# Modify.........: No.TQC-790050 07/09/21 By Echo 複製資料出現異常
# Modify.........: No.FUN-7B0010 07/11/06 By Echo 功能調整<part1>
# Modify.........: No.TQC-7C0043 07/12/06 By Echo 在sql指令使用"||"進行欄位concatenate的動作，在切換page時會當掉...
# Modify.........: No.FUN-7C0020 07/12/06 By Echo 功能調整<part2>
# Modify.........: No.FUN-810021 08/01/09 By Echo 調整權限部份應與 p_zy 勾稽
# Modify.........: No.TQC-810053 08/01/17 By Echo 功能異常調整
# Modify.........: No.FUN-810062 08/01/23 By Echo 調整 p_query 作業可以在 Windows 版執行
# Modify.........: No.FUN-820043 08/02/13 By Echo p_query 功能調整
# Modify.........: No.MOD-8B0110 08/11/11 By Sarah AFTER FIELD zat04段,判斷順序是否有重複前,需先過濾zat04!=0
# Modify.........: No.FUN-8B0089 08/11/21 By Vicky 新增"匯出Excel"功能(For page查詢指令、欄位設定、分群、計算)
# Modify.........: No.TQC-950044 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A30017 10/05/05 By Jay  新增權限控制
# Modify.........: No:CHI-960099 10/05/05 By Jay  排除相同arg之檢核,增加相同arg之條件取代
# Modify.........: No.FUN-A60085 10/06/25 By Jay 呼叫cl_query_prt_getlength()只做一次CREATE TEMP TABLE
# Modify.........: No.CHI-A60010 10/08/17 By Jay 增加單身篩選資料功能
# Modify.........: No.FUN-A90024 10/11/25 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No.FUN-AC0011 10/03/08 By Jay 調整取得sql語法中table name與別名方式
# Modify.........: No.FUN-B50065 11/05/13 BY huangrh BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-B40058 11/05/17 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No:FUN-B90139 11/09/29 By tsai_yen 檢查簡繁字串
# Modify.........: No:FUN-BA0116 11/10/31 By joyce 新增繁簡體資料轉換action
# Modify.........: No:TQC-C60167 12/06/21 By LeoChang 修改使用when case的SQL語法造成列印無法正確呈現問題
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新資料畫面
# Modify.........: No:FUN-D30034 13/04/18 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds    #FUN-690069
 
GLOBALS "../../config/top.global"

DEFINE   g_zai                 RECORD LIKE zai_file.*  #自定義查詢設定主頁
DEFINE   g_zaj                 DYNAMIC ARRAY OF RECORD #定義query前應執行的process
           zaj02               LIKE zaj_file.zaj02,                             
           zaj03               LIKE zaj_file.zaj03,                             
           zaj04               LIKE zaj_file.zaj04,                             
           zaj05               LIKE zaj_file.zaj05,                             
           zaj06               LIKE zaj_file.zaj06 
                               END RECORD                            
DEFINE   g_zal                 DYNAMIC ARRAY OF RECORD #定義SQL欄位資料
           zal02               LIKE zal_file.zal02,                             
           zal03               LIKE zal_file.zal03,                             
           zal04               LIKE zal_file.zal04,                             
           zal05               LIKE zal_file.zal05,                             
           zal09               LIKE zal_file.zal09,    #FUN-7C0020                            
           zal08               LIKE zal_file.zal08,    #FUN-770079                            
           zal06               LIKE zal_file.zal06 
                               END RECORD                            
DEFINE   g_zam                 DYNAMIC ARRAY OF RECORD #定義Group
           zam02               LIKE zam_file.zam02,                             
           mzal04              LIKE zal_file.zal04,
           mzal05              LIKE zal_file.zal05,
           zam03               LIKE zam_file.zam03,                             
           zam04               LIKE zam_file.zam04,                             
           zam05               LIKE zam_file.zam05,                             
           zam08               LIKE zam_file.zam08,                             
           zam07               LIKE zam_file.zam07,                             
           zam06               LIKE zam_file.zam06 
                               END RECORD                            
DEFINE   g_zan                 DYNAMIC ARRAY OF RECORD #定義Sum
           zan02               LIKE zan_file.zan02,                             
           nzal04              LIKE zal_file.zal04,
           nzal05              LIKE zal_file.zal05,
           zan03               LIKE zan_file.zan03,                             
           zan07               LIKE zan_file.zan07,                             
           zan04               LIKE zan_file.zan04,                             
           zan05               LIKE zan_file.zan05,                             
           gzal04              LIKE zal_file.zal04,
           gzal05              LIKE zal_file.zal05,
           zan06               LIKE zan_file.zan06 
                               END RECORD                            
DEFINE   g_out                 DYNAMIC ARRAY OF RECORD #定義Layout
           out1                LIKE zao_file.zao02,                             
           out2                LIKE zao_file.zao04,                             
           out3                LIKE zao_file.zao04,                             
           out4                LIKE zao_file.zao04,                             
           out5                LIKE zao_file.zao04                             
                               END RECORD                            
DEFINE   g_zap                 RECORD                   #定義Layout-版面設定
           zap02               LIKE zap_file.zap02,                             
           zap03               LIKE zap_file.zap03,                             
           zap04               LIKE zap_file.zap04,                             
           zap05               LIKE zap_file.zap05,                             
           zap06               LIKE zap_file.zap06                             
                               END RECORD                            
DEFINE   g_zat                 DYNAMIC ARRAY OF RECORD #定義Field
           zat02               LIKE zat_file.zat02,                             
           tzal04              LIKE zal_file.zal04,
           tzal05              LIKE zal_file.zal05,
           zat03               LIKE zat_file.zat03,                             
           zat12               LIKE zat_file.zat12,     #FUN-7C0020                              
           zat04               LIKE zat_file.zat04,                             
           zat05               LIKE zat_file.zat05,                             
           zat06               LIKE zat_file.zat06, 
           zat07               LIKE zat_file.zat07,                             
           zat08               LIKE zat_file.zat08,                             
           zat09               LIKE zat_file.zat09,                             
           zat11               LIKE zat_file.zat11      #FUN-770079    
                               END RECORD                            
DEFINE   g_zau                 RECORD                   #權限設定
           zau02               LIKE zau_file.zau02,                             
           zau03               LIKE zau_file.zau03                             
                               END RECORD                            
DEFINE   g_zai_t               RECORD LIKE zai_file.*  
DEFINE   g_zaj_t               RECORD                   #定義query前應執行的process-舊值
           zaj02               LIKE zaj_file.zaj02,                             
           zaj03               LIKE zaj_file.zaj03,                             
           zaj04               LIKE zaj_file.zaj04,                             
           zaj05               LIKE zaj_file.zaj05,                             
           zaj06               LIKE zaj_file.zaj06 
                               END RECORD                            
DEFINE   g_zak                 RECORD LIKE zak_file.*  #定義查詢的SQL
DEFINE   g_zak_t               RECORD LIKE zak_file.*  #定義查詢的SQL
DEFINE   g_zal_t               RECORD                   #定義SQL欄位資料-舊值
           zal02               LIKE zal_file.zal02,                             
           zal03               LIKE zal_file.zal03,                             
           zal04               LIKE zal_file.zal04,                             
           zal05               LIKE zal_file.zal05,                             
           zal09               LIKE zal_file.zal09,    #FUN-7C0020                            
           zal08               LIKE zal_file.zal08,    #FUN-770079                            
           zal06               LIKE zal_file.zal06 
                               END RECORD                            
DEFINE   g_zam_t               RECORD                   #定義Group -舊值
           zam02               LIKE zam_file.zam02,                             
           mzal04              LIKE zal_file.zal04,
           mzal05              LIKE zal_file.zal05,
           zam03               LIKE zam_file.zam03,                             
           zam04               LIKE zam_file.zam04,                             
           zam05               LIKE zam_file.zam05,                             
           zam08               LIKE zam_file.zam08,                             
           zam07               LIKE zam_file.zam07,                             
           zam06               LIKE zam_file.zam06 
                               END RECORD                            
DEFINE   g_zan_t               RECORD                   #定義Sum -舊值
           zan02               LIKE zan_file.zan02,                             
           nzal04              LIKE zal_file.zal04,
           nzal05              LIKE zal_file.zal05,
           zan03               LIKE zan_file.zan03,                             
           zan07               LIKE zan_file.zan07,                             
           zan04               LIKE zan_file.zan04,                             
           zan05               LIKE zan_file.zan05,                             
           gzal04              LIKE zal_file.zal04,
           gzal05              LIKE zal_file.zal05,
           zan06               LIKE zan_file.zan06 
                               END RECORD                            
DEFINE   g_out_t               RECORD                  #定義Layout -舊值
           out1                LIKE zao_file.zao02,                             
           out2                LIKE zao_file.zao04,                             
           out3                LIKE zao_file.zao04,                             
           out4                LIKE zao_file.zao04,                             
           out5                LIKE zao_file.zao04                             
                               END RECORD                            
DEFINE   g_zap_t               RECORD                   #定義Layout-版面設定(舊)
           zap02               LIKE zap_file.zap02,                             
           zap03               LIKE zap_file.zap03,                             
           zap04               LIKE zap_file.zap04,                             
           zap05               LIKE zap_file.zap05,                             
           zap06               LIKE zap_file.zap06                             
                               END RECORD                            
DEFINE   g_zat_t               RECORD                   #定義Field
           zat02               LIKE zat_file.zat02,                             
           tzal04              LIKE zal_file.zal04,
           tzal05              LIKE zal_file.zal05,
           zat03               LIKE zat_file.zat03,                             
           zat12               LIKE zat_file.zat12,     #FUN-7C0020                              
           zat04               LIKE zat_file.zat04,                             
           zat05               LIKE zat_file.zat05,                             
           zat06               LIKE zat_file.zat06, 
           zat07               LIKE zat_file.zat07,                             
           zat08               LIKE zat_file.zat08,                             
           zat09               LIKE zat_file.zat09,                             
           zat11               LIKE zat_file.zat11      #FUN-770079    
                               END RECORD                            
DEFINE   g_zau_t               RECORD                   #權限設定
           zau02               LIKE zau_file.zau02,                             
           zau03               LIKE zau_file.zau03                             
                               END RECORD                            
DEFINE   g_swe01               STRING                  #SQL指令
DEFINE   g_swe01_t             STRING
DEFINE   g_swa01               LIKE type_file.chr1     #選擇sql產生方式
DEFINE   g_swa01_t             LIKE type_file.chr1
DEFINE   g_swa02               LIKE type_file.chr1     #選擇sql指令
DEFINE   g_swa02_t             LIKE type_file.chr1
DEFINE   g_page_choice         STRING                  #目前所選擇的Page
DEFINE   g_wizard_choice       STRING                  #目前所選擇的wizard_page
DEFINE   g_cnt                 LIKE type_file.num10,   #No.FUN-680135 INTGER
         g_cnt2                LIKE type_file.num10,   #No.FUN-680135 INTGER
         g_wc                  string,                 #No.FUN-580092 HCN
         g_wc2                 string,                 #No.FUN-580092 HCN
         g_wc3                 string,                 #No:CHI-A60010 查詢指令(SQL)頁籤下半部單身的查詢條件
         g_wc4                 string,                 #No:CHI-A60010 欄位設定頁籤單身的查詢條件
         g_wc5                 string,                 #No:CHI-A60010 權限設定頁籤單身的查詢條件
         g_wc6                 string,                 #No:CHI-A60010 分群(Group)頁籤單身的查詢條件
         g_wc7                 string,                 #No:CHI-A60010 計算(Sum)頁籤單身的查詢條件
         g_wc8                 string,                 #No:CHI-A60010 輸出格式(Layout)頁籤單身的查詢條件
         g_sql                 string,                 #No.FUN-580092 HCN
         g_ss                  LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1) # 決定後續步驟
         g_process_rec_b       LIKE type_file.num5,    #Process 單身筆數 #No.FUN-680135 SMALLINT
         g_sql_rec_b           LIKE type_file.num5,    #SQL 單身筆數     #No.FUN-680135 SMALLINT
         g_field_rec_b         LIKE type_file.num5,    #Feild 單身筆數   #No.FUN-680135 SMALLINT
         g_group_rec_b         LIKE type_file.num5,    #Group 單身筆數   #No.FUN-680135 SMALLINT
         g_sum_rec_b           LIKE type_file.num5,    #Sum 單身筆數     #No.FUN-680135 SMALLINT
         g_layout_rec_b        LIKE type_file.num5,    #Layout 單身筆數  #No.FUN-680135 SMALLINT
         l_ac                  LIKE type_file.num5,    # 目前處理的ARRAY CNT  #No.FUN-680135 SMALLINT
         l_w_ac                LIKE type_file.num5     # 目前處理的ARRAY CNT  #No.FUN-680135 SMALLINT
DEFINE   g_zaq_cnt             LIKE type_file.num10
DEFINE   g_zar_cnt             LIKE type_file.num10
DEFINE   g_zart_cnt            LIKE type_file.num10
DEFINE   g_zas_cnt             LIKE type_file.num10
DEFINE   g_msg                 LIKE type_file.chr1000  #No.FUN-680135
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5     #No.FUN-680135 SMALLINT
DEFINE   g_row_count           LIKE type_file.num10,   #No.FUN-580092 HCN     #No.FUN-680135 INTEGER
         g_curs_index         LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_jump               LIKE type_file.num10,   #No.FUN-680135 INTEGER
         g_no_ask             LIKE type_file.num5     #No.FUN-680135 SMALLINT
DEFINE   g_n                   LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_db_type             LIKE type_file.chr3  
DEFINE   g_items               STRING                  #動態-欄位代號
DEFINE   g_sum_items           STRING                  #動態-SUM 欄位代號
DEFINE   g_group_items         STRING                  #動態-Group 欄位代號
DEFINE   g_zaq                 DYNAMIC ARRAY OF RECORD 
           zaq04               LIKE zaq_file.zaq04,
           zaq02               LIKE zaq_file.zaq02,
           gat03               LIKE gat_file.gat03,
           zaq03               LIKE zaq_file.zaq03
                               END RECORD
DEFINE   g_zaq_t               RECORD 
           zaq04               LIKE zaq_file.zaq04,
           zaq02               LIKE zaq_file.zaq02,
           gat03               LIKE gat_file.gat03,
           zaq03               LIKE zaq_file.zaq03
                               END RECORD
DEFINE   g_zart                DYNAMIC ARRAY OF RECORD 
           zar02t              LIKE zar_file.zar02,
           zar03t              LIKE type_file.chr1000 
                               END RECORD
DEFINE   g_zart_t              RECORD 
           zar02t              LIKE zar_file.zar02,
           zar03t              LIKE type_file.chr1000 
                               END RECORD
DEFINE   g_zar                 DYNAMIC ARRAY OF RECORD 
           zar02               LIKE zar_file.zar02,
           zar03               LIKE zar_file.zar03,
           gaq03               LIKE gaq_file.gaq03
                               END RECORD
DEFINE   g_zar_t               RECORD 
           zar02               LIKE zar_file.zar02,
           zar03               LIKE zar_file.zar03,
           gaq03               LIKE gaq_file.gaq03
                               END RECORD
DEFINE   g_zas                 DYNAMIC ARRAY OF RECORD 
           zas02               LIKE  zas_file.zas02,
           zas03               LIKE  zas_file.zas03,
           zas04               LIKE  zas_file.zas04,
           zas05               LIKE  zas_file.zas05,
           zas06               LIKE  zas_file.zas06,
           zas07               LIKE  zas_file.zas07,
           zas08               LIKE  zas_file.zas08,
           zas09               LIKE  zas_file.zas09,
           zas10               LIKE  zas_file.zas10
                               END RECORD
DEFINE   g_zas_t               RECORD 
           zas02               LIKE  zas_file.zas02,
           zas03               LIKE  zas_file.zas03,
           zas04               LIKE  zas_file.zas04,
           zas05               LIKE  zas_file.zas05,
           zas06               LIKE  zas_file.zas06,
           zas07               LIKE  zas_file.zas07,
           zas08               LIKE  zas_file.zas08,
           zas09               LIKE  zas_file.zas09,
           zas10               LIKE  zas_file.zas10
                               END RECORD
DEFINE   g_sum_field           DYNAMIC ARRAY OF STRING
DEFINE   g_argv                DYNAMIC ARRAY OF STRING
DEFINE   g_module_id           STRING
DEFINE   g_zta01               LIKE zta_file.zta01    #FUN-750084
DEFINE   g_zta17               LIKE zta_file.zta17    #FUN-750084   
DEFINE   g_flag                LIKE zai_file.zai01    #FUN-770026                 
#FUN-770079
DEFINE   g_zay                 DYNAMIC ARRAY OF RECORD #定義資料轉換 Array
           zay04                LIKE zay_file.zay04,
           zay05                LIKE zay_file.zay05,
           zay06                LIKE zay_file.zay06,
           zay07                LIKE zay_file.zay07,
           memo                 LIKE ze_file.ze03
                               END RECORD                            
DEFINE   g_zay_t               RECORD                 
           zay04                LIKE zay_file.zay04,
           zay05                LIKE zay_file.zay05,
           zay06                LIKE zay_file.zay06,
           zay07                LIKE zay_file.zay07,
           memo                 LIKE ze_file.ze03
                               END RECORD                            
DEFINE   g_zay02               LIKE zay_file.zay02
DEFINE   g_zay_rec_b           LIKE type_file.num5,   # 轉換資料的單身筆數 
         l_rep_ac              LIKE type_file.num5,   # 目前處理的ARRAY CNT
         g_rep_upd_tag         LIKE type_file.num5    # 判斷是否更新過 zay_file 
#END FUN-770079
#FUN-7C0020
DEFINE   g_zz_cnt              LIKE type_file.num5     
DEFINE   g_win_curr            ui.Window
DEFINE   g_frm_curr            ui.Form
DEFINE   g_node_item           om.DomNode
DEFINE   g_node_child          om.DomNode
DEFINE   g_zai02_name          STRING
#END FUN-7C0020
 
MAIN
   DEFINE   l_i                LIKE type_file.num5
   DEFINE   l_module           LIKE gao_file.gao01
                           
   OPTIONS                                             # 改變一些系統預設值
      FIELD ORDER FORM,
      INPUT NO WRAP
   DEFER INTERRUPT                                     # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
     CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   #抓取參數值
   LET g_zai.zai01 = ARG_VAL(1)
   LET g_flag = ARG_VAL(1)               #FUN-770026
   FOR l_i = 1 TO 50
       LET g_argv[l_i] = ARG_VAL(l_i+1)
   END FOR
 
#   IF NOT cl_null(g_zai.zai01) THEN
   IF NOT cl_null(g_zai.zai01) AND ( g_argv[1] <>'p_addview' OR cl_null(g_argv[1])) THEN  #FUN-770026
       CALL p_query_cmdrun() 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
   END IF
 
   OPEN WINDOW p_query_w WITH FORM "azz/42f/p_query"
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_set_combo_lang("zal03")
 
   #-----指定combo q02的值-------------#
   LET g_module_id = ""
   DECLARE p_module_cur CURSOR FOR SELECT gao01 FROM gao_file ORDER BY gao01
   FOREACH p_module_cur INTO l_module
      IF cl_null(g_module_id) THEN
         LET g_module_id=l_module
      ELSE
         LET g_module_id = g_module_id CLIPPED,",",l_module CLIPPED
      END IF
   END FOREACH
 
   #-------------------------------------#
 
   LET g_forupd_sql = "SELECT * from zai_file  WHERE zai01 = ? AND zai05 = ? ", #FUN-750084
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_query_cl CURSOR FROM g_forupd_sql
 
   LET g_forupd_sql = "SELECT * from zak_file  WHERE zak01 = ? AND zak07 = ? ", #FUN-750084
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE zak_cl CURSOR FROM g_forupd_sql
 
 
   LET g_db_type=cl_db_get_database_type()
   LET g_page_choice = "query_sql"          #FUN-770079
 
   #FUN-7C0020
   LET g_win_curr = ui.Window.getCurrent()
   LET g_frm_curr = g_win_curr.getForm()
   LET g_node_item = g_frm_curr.findNode("FormField","zai_file.zai02")
   LET g_node_child = g_node_item.getFirstChild()
   LET g_zai02_name = g_node_child.getAttribute("comment")
   #END FUN-7C0020
 
   #...........#FUN-770026 BEGIN
   IF NOT cl_null(g_flag) AND g_argv[1] = 'p_addview' THEN 
      CALL p_query_q()
      CALL p_query_sql_i()
      LET g_flag = ""
      LET g_argv[1]=""
   END IF 
#..........#FUN-770026 END   

   CALL p_query_init()                          #CHI-A60010   
   CALL p_query_menu()
   CLOSE WINDOW p_query_w                       # 結束畫面
#No.FUN-6A0096 -- begin --
 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time
#No.FUN-6A0096 -- end --
END MAIN
 
FUNCTION p_query_curs()                         # QBE 查詢資料
 
   CLEAR FORM                                    # 清除畫面
   CALL g_zaj.clear()
   CALL g_zal.clear()
   CALL g_zat.clear()
   CALL g_zam.clear()
   CALL g_zan.clear()
   CALL g_out.clear()

   CALL p_query_init()                      #CHI-A60010
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

   IF NOT cl_null(g_flag) AND g_argv[1] = 'p_addview' THEN   #FUN-770026
      #LET g_wc = " zai01 like '",g_flag,"'"                   #FUN-770026
      LET g_wc = " zai01 like '",g_flag,"' AND zai05='", ARG_VAL(3),"'"    #No.FUN-810062
   ELSE                                                       #FUN-770026

   #NO.CHI-A60010--start----------------------
   #改寫CONSTRUCT架構,所以原本CONSTRUCT全部mark,改寫成利用DIALOG包起來
   #CONSTRUCT g_wc ON zai01,zai02,zai03,zai07,zai04,zai06,zai05,zaiuser,zaigrup,zaimodu,zaidate  #FUN-750084 #FUN-770079 #No.FUN-810021
   #     FROM zai01,zai02,zai03,zai07,zai04,zai06,zai05,zaiuser,zaigrup,zaimodu,zaidate          #FUN-750084 #FUN-770079 #No.FUN-810021
   # 
   #      ON IDLE g_idle_seconds
   #         CALL cl_on_idle()
   #         CONTINUE CONSTRUCT
   # 
   #      ON ACTION about         #MOD-4C0121
   #         CALL cl_about()      #MOD-4C0121
   # 
   #      ON ACTION help          #MOD-4C0121
   #         CALL cl_show_help()  #MOD-4C0121
   #
   #      ON ACTION controlg      #MOD-4C0121
   #         CALL cl_cmdask()     #MOD-4C0121
   #
   #      ON ACTION controlp
   #         CASE
   #             WHEN INFIELD(zai01)                     #MOD-530267
   #               CALL cl_init_qry_var()
   #               LET g_qryparam.form = "q_query"
   #               LET g_qryparam.arg1 =  g_lang
   #               LET g_qryparam.state = "c"
   #               LET g_qryparam.default1= g_zai.zai01
   #               CALL cl_create_qry() RETURNING g_qryparam.multiret
   #               DISPLAY g_qryparam.multiret TO zai01
   #               NEXT FIELD zai01
   #
   #             #No.FUN-810021
   #             WHEN INFIELD(zai07)                    
   #               CALL cl_init_qry_var()
   #               LET g_qryparam.form = "q_zz"
   #               LET g_qryparam.arg1 =  g_lang
   #               LET g_qryparam.state = "c"
   #               LET g_qryparam.default1= g_zai.zai07
   #               CALL cl_create_qry() RETURNING g_qryparam.multiret
   #               DISPLAY g_qryparam.multiret TO zai07
   #               NEXT FIELD zai07
   #             #END No.FUN-810021
   #         END CASE
   #
   #END CONSTRUCT
   #IF INT_FLAG THEN RETURN END IF
   #
   #CONSTRUCT g_wc2 ON zaj02,zaj03,zaj04,zaj05,zaj06,zak02,
   #                   zal02,zal03,zal04,zal05,zal09,zal08,zal06,     #FUN-770079  #FUN-7C0020
   #                   zat02,zat03,zat12,zat04,zat05,zat06,zat07,     #FUN-7C0020
   #                   zat08,zat09,zat11,                             #FUN-770079
   #                   zau02,zau03,
   #                   zam02,zam03,zam04,zam05,zam08,zam07,zam06,
   #                   zan02,zan03,zan07,zan04,zan05,zan06,
   #                   zap02,zap03,zap04,zap05,zap06
   #     FROM s_zaj[1].zaj02,s_zaj[1].zaj03,s_zaj[1].zaj04,
   #          s_zaj[1].zaj05,s_zaj[1].zaj06,zak02,
   #          s_zal[1].zal02,s_zal[1].zal03,s_zal[1].zal04,
   #          s_zal[1].zal05,s_zal[1].zal09,s_zal[1].zal08,s_zal[1].zal06,  #FUN-770079  #FUN-7C0020
   #          s_zat[1].zat02,s_zat[1].zat03,s_zat[1].zat12,s_zat[1].zat04,  #FUN-7C0020
   #          s_zat[1].zat05,s_zat[1].zat06,s_zat[1].zat07,
   #          s_zat[1].zat08,s_zat[1].zat09,s_zat[1].zat11,           #FUN-770079
   #          zau02,zau03,
   #          s_zam[1].zam02,s_zam[1].zam03,s_zam[1].zam04,
   #          s_zam[1].zam05,s_zam[1].zam08,s_zam[1].zam07,
   #          s_zam[1].zam06,
   #          s_zan[1].zan02,s_zan[1].zan03,s_zan[1].zan07,
   #          s_zan[1].zan04,s_zan[1].zan05,s_zan[1].zan06,
   #          zap02,zap03,zap04,zap05,zap06
   #
   #      ON IDLE g_idle_seconds
   #         CALL cl_on_idle()
   #         CONTINUE CONSTRUCT
   #
   #      ON ACTION about         #MOD-4C0121
   #         CALL cl_about()      #MOD-4C0121
   #
   #      ON ACTION help          #MOD-4C0121
   #         CALL cl_show_help()  #MOD-4C0121
   #
   #      ON ACTION controlg      #MOD-4C0121
   #         CALL cl_cmdask()     #MOD-4C0121
   #
   #END CONSTRUCT

      #CALL ui.Dialog.setDefaultUnbuffered(TRUE)  #設定DIALOG全程都是UNBUFFERED    
      DIALOG  
         CONSTRUCT g_wc ON zai01,zai02,zai03,zai07,zai04,zai06,zai05,zaiuser,zaigrup,zaimodu,zaidate,zaiud01  #FUN-750084 #FUN-770079 #No:FUN-810021
              FROM zai01,zai02,zai03,zai07,zai04,zai06,zai05,zaiuser,zaigrup,zaimodu,zaidate,zaiud01          #FUN-750084 #FUN-770079 #No:FUN-810021

               ON ACTION controlp
                  CASE
                      WHEN INFIELD(zai01)                     #MOD-530267
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_query"
                        LET g_qryparam.arg1 =  g_lang
                        LET g_qryparam.state = "c"
                        LET g_qryparam.default1= g_zai.zai01
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO zai01
                        NEXT FIELD zai01

                      #No:FUN-810021
                      WHEN INFIELD(zai07)                    
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_zz"
                        LET g_qryparam.arg1 =  g_lang
                        LET g_qryparam.state = "c"
                        LET g_qryparam.default1= g_zai.zai07
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO zai07
                        NEXT FIELD zai07
                      #END No:FUN-810021
                  END CASE
         END CONSTRUCT

         #輸入s_zaj與查詢指令(SQL)頁籤上半部SQL查詢語法的查詢條件
         CONSTRUCT g_wc2 ON zaj02,zaj03,zaj04,zaj05,zaj06,zak02
              FROM s_zaj[1].zaj02,s_zaj[1].zaj03,s_zaj[1].zaj04,
                   s_zaj[1].zaj05,s_zaj[1].zaj06,zak02
         END CONSTRUCT

         #輸入查詢指令(SQL)頁籤下半部單身的查詢條件
         CONSTRUCT g_wc3 ON zal02,zal03,zal04,zal05,zal09,zal08,zal06
              FROM s_zal[1].zal02,s_zal[1].zal03,s_zal[1].zal04,
                   s_zal[1].zal05,s_zal[1].zal09,s_zal[1].zal08,s_zal[1].zal06
         END CONSTRUCT

         #輸入欄位設定頁籤單身的查詢條件
         CONSTRUCT g_wc4 ON zat02,zat03,zat12,zat04,zat05,zat06,zat07, 
                            zat08,zat09,zat11
              FROM s_zat[1].zat02,s_zat[1].zat03,s_zat[1].zat12,s_zat[1].zat04,
                   s_zat[1].zat05,s_zat[1].zat06,s_zat[1].zat07,
                   s_zat[1].zat08,s_zat[1].zat09,s_zat[1].zat11
         END CONSTRUCT

         #輸入權限設定頁籤單身的查詢條件
         CONSTRUCT g_wc5 ON zau02,zau03
              FROM zau02,zau03
         END CONSTRUCT

         #輸入分群(Group)頁籤單身的查詢條件
         CONSTRUCT g_wc6 ON zam02,zam03,zam04,zam05,zam08,zam07,zam06
              FROM s_zam[1].zam02,s_zam[1].zam03,s_zam[1].zam04,
                   s_zam[1].zam05,s_zam[1].zam08,s_zam[1].zam07,
                   s_zam[1].zam06
         END CONSTRUCT

         #輸入計算(Sum)頁籤單身的查詢條件
         CONSTRUCT g_wc7 ON zan02,zan03,zan07,zan04,zan05,zan06
              FROM s_zan[1].zan02,s_zan[1].zan03,s_zan[1].zan07,
                   s_zan[1].zan04,s_zan[1].zan05,s_zan[1].zan06
         END CONSTRUCT

         #輸入輸出格式(Layout)頁籤單身的查詢條件
         CONSTRUCT g_wc8 ON zap02,zap03,zap04,zap05,zap06
              FROM zap02,zap03,zap04,zap05,zap06
         END CONSTRUCT
        
         ON ACTION accept
            EXIT DIALOG

         ON ACTION cancel
            LET INT_FLAG = TRUE 
            EXIT DIALOG
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
   
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121

         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121

         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
            
         ON ACTION exit  
            LET INT_FLAG = TRUE 
            EXIT DIALOG
      END DIALOG  
      #NO.CHI-A60010--end------------------------
   END IF    #FUN-770026
   IF INT_FLAG THEN RETURN END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND zaiuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND zaigrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND zaigrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('zaiuser', 'zaigrup')
   #End:FUN-980030

   #NO.CHI-A60010--start----------------------
   #組合查詢where條件式
   IF NOT cl_null(g_wc3) AND g_wc3 <> ' 1=1' THEN
      LET g_wc2 = g_wc2, " AND ", g_wc3
   END IF
   IF NOT cl_null(g_wc4) AND g_wc4 <> ' 1=1' THEN
      LET g_wc2 = g_wc2, " AND ", g_wc4
   END IF
   IF NOT cl_null(g_wc5) AND g_wc5 <> ' 1=1' THEN
      LET g_wc2 = g_wc2, " AND ", g_wc5
   END IF
   IF NOT cl_null(g_wc6) AND g_wc6 <> ' 1=1' THEN
      LET g_wc2 = g_wc2, " AND ", g_wc6
   END IF
   IF NOT cl_null(g_wc7) AND g_wc7 <> ' 1=1' THEN
      LET g_wc2 = g_wc2, " AND ", g_wc7
   END IF
   IF NOT cl_null(g_wc8) AND g_wc8 <> ' 1=1' THEN
      LET g_wc2 = g_wc2, " AND ", g_wc8
   END IF
   #NO.CHI-A60010--end------------------------
   
   IF g_wc2=' 1=1' OR cl_null(g_wc2) THEN                       #CHI-A60010把原本' 1=1 '改寫成' 1=1'最後面少一個空白
      LET g_sql= "SELECT UNIQUE zai01,zai05 FROM zai_file ",    #FUN-750084
                 " WHERE ", g_wc CLIPPED, " ORDER BY zai01"
   ELSE
      #FUN-750084
      LET g_sql="SELECT UNIQUE zai01,zai05 FROM zai_file, OUTER zaj_file,",
                " OUTER zal_file, OUTER zam_file, OUTER zan_file ,",
                " OUTER zak_file, OUTER zap_file, OUTER zat_file ,",
                " OUTER zau_file ",
                " WHERE zai01=zaj_file.zaj01 AND zai01=zal_file.zal01 ",
                " AND zai01 = zam_file.zam01 AND zai01=zan_file.zan01 ",
                " AND zai01 = zak_file.zak01 AND zai01=zap_file.zap01 ",
                " AND zai01 = zat_file.zat01 AND zai01=zau_file.zau01 ",
                " AND zai05 = zaj_file.zaj07 AND zai05=zal_file.zal07 ",  
                " AND zai05 = zam_file.zam09 AND zai05=zan_file.zan08 ",
                " AND zai05 = zak_file.zak07 AND zai05=zap_file.zap07 ",
                " AND zai05 = zat_file.zat10 AND zai05=zau_file.zau04 ",
                " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED," ORDER BY zai01"
      #END FUN-750084
   END IF
 
 
   PREPARE p_query_prepare FROM g_sql          # 預備一下
   DECLARE p_query_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR p_query_prepare
 
   IF g_wc2=' 1=1' OR cl_null(g_wc2) THEN
      LET g_sql= "SELECT COUNT(*) FROM zai_file WHERE ",g_wc CLIPPED
   ELSE
      #FUN-750084
      LET g_sql="SELECT COUNT(DISTINCT zai01) FROM zai_file, OUTER zaj_file,",
                " OUTER zal_file, OUTER zam_file, OUTER zan_file, ",
                " OUTER zak_file, OUTER zap_file, OUTER zat_file ,",
                " OUTER zau_file ",
                " WHERE zai01=zaj_file.zaj01 AND zai01=zal_file.zal01 ",
                " AND zai01 = zam_file.zam01 AND zai01=zan_file.zan01 ",
                " AND zai01 = zak_file.zak01 AND zai01=zap_file.zap01 ",
                " AND zai01 = zat_file.zat01 AND zai01=zau_file.zau01 ",
                " AND zai05 = zaj_file.zaj07 AND zai05=zal_file.zal07 ",  
                " AND zai05 = zam_file.zam09 AND zai05=zan_file.zan08 ",
                " AND zai05 = zak_file.zak07 AND zai05=zap_file.zap07 ",
                " AND zai05 = zat_file.zat10 AND zai05=zau_file.zau04 ",
                " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
      #END FUN-750084
   END IF
 
   PREPARE query_precount FROM g_sql
 
   DECLARE query_count CURSOR FOR query_precount
 
END FUNCTION
 
FUNCTION p_query_menu()
 
   WHILE TRUE
   
      CASE g_page_choice
         WHEN "query_process"
              CALL p_query_process_bp("G")
         WHEN "query_sql"
              #CALL p_query_sql_b_fill()                   # SQL     單身   #CHI-A60010 mark
              CALL p_query_sql_b_fill(g_wc3)               # SQL     單身   #CHI-A60010
              CALL p_query_sql_bp("G")
         WHEN "query_field"
              #CALL p_query_field_b_fill()                 # Field   單身   #CHI-A60010 mark
              CALL p_query_field_b_fill(g_wc4)             # Field   單身   #CHI-A60010
              CALL p_query_field_bp("G")
         WHEN "query_auth"
              CALL p_query_auth_menu()                     # 權限設定
         WHEN "query_group"
              #CALL p_query_group_b_fill()                 # Group   單身   #CHI-A60010 mark
              CALL p_query_group_b_fill(g_wc6)             # Group   單身   #CHI-A60010
              CALL p_query_group_bp("G")
         WHEN "query_sum"
              #CALL p_query_sum_b_fill()                   # Sum     單身   #CHI-A60010 mark
              CALL p_query_sum_b_fill(g_wc7)               # Sum     單身   #CHI-A60010
              CALL p_query_sum_bp("G")
         WHEN "query_layout"
              CALL p_query_layout_b_fill()                 # Layout  單身
              CALL p_query_layout_bp("G")
      END CASE
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL p_query_a()
            END IF
 
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
               CALL p_query_r()
            END IF
 
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL p_query_q()
            ELSE
               LET g_curs_index = 0
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CASE g_page_choice
                  WHEN "query_process"
                       CALL p_query_process_b()
                  WHEN "query_sql"
                       CALL p_query_sql_b()
                  WHEN "query_field"
                       CALL p_query_field_b()
                  WHEN "query_group"
                       CALL p_query_group_b()
                  WHEN "query_sum"
                       CALL p_query_sum_b()
                  WHEN "query_layout"
                       CALL p_query_layout_b()
               END CASE
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL p_query_u()
            END IF
 
         #FUN-750084
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL p_query_copy()
            END IF
         #END FUN-750084
 
         WHEN "help"                            # H.求助
            CALL cl_show_help()
 
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
 
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
 
         WHEN "sql_command"                     # 設定 SQL 語法
            IF cl_chk_act_auth() THEN           #FUN-A30017 
               CALL p_query_sql_i()
            END IF                              #FUN-A30017
   
         WHEN "layout_output"                   #版面設定  
            IF cl_chk_act_auth() THEN           #FUN-A30017   
               CALL p_query_layout_i()
            END IF                              #FUN-A30017
 
         WHEN "query_auth_i"                    #版面設定   
            IF cl_chk_act_auth() THEN           #FUN-A30017  
               CALL p_query_auth_i()
            END IF                              #FUN-A30017   
 
         WHEN "database_query"                  #資料庫查詢
            IF cl_chk_act_auth() THEN           #FUN-A30017 
               CALL p_query_dbqry()
            END IF                              #FUN-A30017   
        
         WHEN "output"                          #列印
            IF cl_chk_act_auth() THEN           #FUN-A30017 
               CALL p_query_out()
            END IF                              #FUN-A30017   
 
         #FUN-8B0089-begin-add
         WHEN "exporttoexcel"                   #匯出excel
            IF cl_chk_act_auth() THEN
               LET g_win_curr = ui.Window.getCurrent()
               LET g_frm_curr = g_win_curr.getForm()
               CASE g_page_choice
                 WHEN "query_sql"
                      LET g_node_item = g_frm_curr.findNode("Page","page03")
                      CALL cl_export_to_excel(g_node_item,base.TypeInfo.create(g_zal),'','')
                 WHEN "query_field"
                      LET g_node_item = g_frm_curr.findNode("Page","page07")
                      CALL cl_export_to_excel(g_node_item,base.TypeInfo.create(g_zat),'','')
                 WHEN "query_group"
                      LET g_node_item = g_frm_curr.findNode("Page","page04")
                      CALL cl_export_to_excel(g_node_item,base.TypeInfo.create(g_zam),'','')
                 WHEN "query_sum"
                      LET g_node_item = g_frm_curr.findNode("Page","page05")
                      CALL cl_export_to_excel(g_node_item,base.TypeInfo.create(g_zan),'','')
               END CASE
            END IF
         #FUN-8B0089-end-add
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_query_a()                            # Add  輸入
DEFINE l_i                    LIKE type_file.num5
 
   MESSAGE ""
   CLEAR FORM
   CALL g_zaj.clear()
   CALL g_zal.clear()
   CALL g_zat.clear()
   CALL g_zam.clear()
   CALL g_zan.clear()
   CALL g_out.clear()
   CALL cl_msg("")
   CALL p_query_init()                          #CHI-A60010
 
   INITIALIZE g_zai.*   LIKE zai_file.*
   INITIALIZE g_zai_t.* LIKE zai_file.*
   INITIALIZE g_zak.*   LIKE zak_file.*
   INITIALIZE g_zak_t.* LIKE zak_file.*
   INITIALIZE g_zau.* TO NULL                   #FUN-7C0020
 
   WHILE TRUE
      LET g_zai.zaiuser = g_user
      LET g_zai.zaigrup = g_grup                #使用者所屬群
      LET g_zai.zaidate = g_today
      LET g_zai.zai04 = 'N'
      LET g_zai.zai05 = 'N'
      LET g_zai.zai06 = 'N'                     #FUN-770079 
      LET g_zz_cnt = 0
 
      CALL p_query_i_id()
      IF INT_FLAG THEN                          # 使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      CALL p_query_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                          # 使用者不玩了
         CLEAR FORM                             # 清單頭
         CALL g_zaj.clear()
         CALL g_zal.clear()
         CALL g_zat.clear()
         CALL g_zam.clear()
         CALL g_zan.clear()
         CALL g_out.clear()
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      LET g_zai.zaioriu = g_user      #No.FUN-980030 10/01/04
      LET g_zai.zaiorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO zai_file VALUES(g_zai.*)     #DISK WRITE
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         ROLLBACK WORK 
          CALL cl_err3("ins","zai_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","",1)  #FUN-750084
          CONTINUE WHILE
      ELSE
         COMMIT WORK    
      END IF
 
      CALL g_zaj.clear()
      CALL g_zal.clear()
      CALL g_zat.clear()
      CALL g_zam.clear()
      CALL g_zan.clear()
      CALL g_out.clear()
 
      LET g_process_rec_b = 0
      LET g_sql_rec_b     = 0
      LET g_field_rec_b   = 0
      LET g_group_rec_b   = 0
      LET g_sum_rec_b     = 0
      LET g_layout_rec_b  = 0
      LET g_items = ""
      LET g_sum_items = ""
      LET g_group_items = ""
 
      #FUN-770079
      #LET g_page_choice = "query_process"
      LET l_w_ac = 1
      #CALL p_query_process_b()                          # 輸入單身
      #END FUN-770079
      LET g_action_choice = "insert"
      LET g_page_choice = "query_sql"
      CALL p_query_sql_i()
      LET g_action_choice = ""
      IF NOT cl_null(g_zak.zak02) THEN 
         #CALL p_query_sql_b_fill()               # Process 單身   #CHI-A60010  mark
         CALL p_query_sql_b_fill(" 1=1")          # Process 單身   #CHI-A60010 
         DISPLAY ARRAY g_zal TO s_zal.* ATTRIBUTE(COUNT=g_sql_rec_b,UNBUFFERED)
            BEFORE DISPLAY
               EXIT DISPLAY
         END DISPLAY
         LET l_w_ac = 1
         CALL p_query_sql_b()
 
         LET g_page_choice = "query_field"
         #CALL p_query_field_b_fill()                 # Field   單身   #CHI-A60010  mark
         CALL p_query_field_b_fill(" 1=1")            # Field   單身   #CHI-A60010 
         LET l_w_ac = 1
         CALL p_query_field_b()
 
         CALL p_query_auth_i()
 
         LET g_items = p_query_combobox()
         CALL cl_set_combo_items("mzal04",g_items,g_items)
         LET g_page_choice = "query_group"
         LET l_w_ac = 1
         CALL p_query_group_b()
 
         LET g_sum_items = ""
         FOR l_i = 1 TO g_sum_field.getLength()
             IF NOT cl_null(g_sum_field[l_i]) THEN
               IF cl_null(g_sum_items) THEN
                  LET g_sum_items = g_sum_field[l_i] CLIPPED
               ELSE
                  LET g_sum_items = g_sum_items,",",g_sum_field[l_i] CLIPPED
               END IF
             END IF
         END FOR
         LET g_sum_items = g_sum_items.toLowerCase()
         LET g_group_items = p_query_group_combobox()
         CALL cl_set_combo_items("gzal04",g_group_items,g_group_items)
         CALL cl_set_combo_items("nzal04",g_sum_items,g_sum_items)
 
         LET g_page_choice = "query_sum"
         LET l_w_ac = 1
         CALL p_query_sum_b()
 
         LET g_page_choice = "query_layout"
         LET l_w_ac = 1
         CALL p_query_layout_b()
         CALL p_query_layout_i()
      END IF
      LET g_zai_t.* = g_zai.*
      EXIT WHILE
   END WHILE
END FUNCTION
 
 
FUNCTION p_query_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_zai.zai01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
 
   LET g_zai_t.* = g_zai.*
 
   BEGIN WORK
   OPEN p_query_cl USING g_zai.zai01, g_zai.zai05   #FUN-750084
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE p_query_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH p_query_cl INTO g_zai.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("zai01 LOCK:",SQLCA.sqlcode,1)
      CLOSE p_query_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL p_query_title()                                     #FUN-7C0020
 
   LET g_zai.zaimodu=g_user                     #修改者
   LET g_zai.zaidate = g_today                  #修改日期
 
   WHILE TRUE
      CALL p_query_i("u")
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_zai.* = g_zai_t.*
         CALL p_query_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      UPDATE zai_file SET zai_file.* = g_zai.*  
       WHERE zai01 = g_zai.zai01 AND zai05 = g_zai.zai05     #FUN-750084
 
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("upd","zai_file",g_zai_t.zai01,g_zai_t.zai05,SQLCA.sqlcode,"","",0)    #No.FUN-660081  #FUN-750084
         CONTINUE WHILE
      END IF
 
      OPEN p_query_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
      LET g_jump = g_curs_index
      LET g_no_ask = TRUE
      CALL p_query_fetch('/')
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
 
FUNCTION p_query_i_id()
DEFINE l_zai01   LIKE zai_file.zai01
DEFINE l_i       LIKE type_file.num5
DEFINE l_q01     LIKE type_file.chr1
DEFINE l_q02     LIKE gao_file.gao01
DEFINE l_str     STRING
 
    OPEN WINDOW p_query_id WITH FORM "azz/42f/p_query_id" 
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
    CALL cl_load_style_list(NULL)
    CALL cl_ui_locale("p_query_id")
    CALL cl_set_combo_items("q02",g_module_id,g_module_id)
 
   LET l_q01 = "T"                                        #FUN-750084
  
   INPUT l_q01,l_q02 WITHOUT DEFAULTS FROM q01,q02
      #FUN-750084
      BEFORE INPUT 
         CALL cl_set_comp_entry("q01", "TRUE")
      #END FUN-750084 
   
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
   CALL cl_set_comp_entry("q01", "FALSE")            #FUN-750084
 
   IF NOT INT_FLAG THEN                            # 使用者不玩了
      LET INT_FLAG = 0
      LET l_zai01 = l_q01 CLIPPED,"QR",l_q02 CLIPPED,"____"
      DISPLAY l_zai01
      LET g_sql= "SELECT zai01 FROM zai_file ",
                 " WHERE UPPER(zai01) LIKE '",l_zai01 CLIPPED,"' ORDER BY zai01 DESC"
      DECLARE p_zai_cs CURSOR FROM g_sql      
      LET l_zai01 =""
      FOREACH p_zai_cs INTO l_zai01
          EXIT FOREACH
      END FOREACH
      LET l_i = l_zai01[7,10] + 1
      IF cl_null(l_i) OR l_i = 0 THEN
         LET l_i = 1
      END IF
      LET g_zai.zai01 = l_q01 CLIPPED,"QR",l_q02 CLIPPED,l_i USING '&&&&'
      LET l_str = g_zai.zai01 CLIPPED
      LET g_zai.zai01 = l_str.toLowerCase()
   END IF
   CLOSE WINDOW p_query_id
 
END FUNCTION
 
FUNCTION p_query_i(p_cmd)                       # 處理INPUT
   DEFINE   p_cmd      LIKE type_file.chr1    # a:輸入 u:更改 #No.FUN-680135 VARCHAR(1)
   DEFINE   l_zwacti   LIKE zw_file.zwacti,                   #FUN-650175
            l_n        LIKE type_file.num5    # 檢查重複用    #No.FUN-680135 SMALLINT
   DEFINE   l_str      STRING
   DEFINE   l_cnt      LIKE type_file.num5                    #FUN-810021
 
   LET g_ss = 'N'
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INPUT g_zai.zai01,g_zai.zai02,g_zai.zai03,g_zai.zai07,g_zai.zai04,g_zai.zai06,g_zai.zai05,g_zai.zaiud01  #darcy:2023/06/06 add zaiud01     #FUN-750084 #FUN-770079 #No.FUN-810021
            WITHOUT DEFAULTS FROM zai01,zai02,zai03,zai07,zai04,zai06,zai05,zaiud01 #darcy:2023/06/06 add zaiud01                      #FUN-750084 #FUN-770079 #No.FUN-810021
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL query_set_entry(p_cmd)
            CALL query_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            #FUN-770079
            IF g_zai.zai04 = "Y" THEN
               CALL cl_set_comp_entry("zai06",TRUE) 
            ELSE
               CALL cl_set_comp_entry("zai06",FALSE) 
            END IF
            #END FUN-770079
            #FUN-7C0020
            IF g_zz_cnt > 0 THEN
               CALL cl_set_comp_entry("zai02",FALSE) 
               CALL cl_err('','azz-275',0)
            ELSE
               CALL cl_set_comp_entry("zai02",TRUE) 
            END IF
            #END FUN-7C0020
 
      AFTER FIELD zai01 
         IF NOT cl_null(g_zai.zai01) THEN
            IF g_zai.zai01 != g_zai_t.zai01 OR g_zai_t.zai01 IS NULL  
            THEN
              #FUN-750084
              #SELECT count(*) INTO l_n FROM zai_file
              #  WHERE zai01 = g_zai.zai01  AND zai05 = g_zai.zai05 #FUN-750084
              #IF l_n > 0 THEN
              #   CALL cl_err('',-239,0)
              #   LET g_zai.zai01 = g_zai_t.zai01
              #   NEXT FIELD zai01
              #END IF
              #END FUN-750084
               LET l_str = g_zai.zai01  CLIPPED
               IF l_str.getIndexOf(' ',1) > 0 THEN
                  CALL cl_err(g_zai.zai01,'azz-252',0)
                  NEXT FIELD zai01
               END IF
               #FUN-7C0020
               SELECT COUNT(*) INTO g_zz_cnt FROM zz_file WHERE zz01=g_zai.zai01
               IF g_zz_cnt > 0 THEN
                  CALL cl_set_comp_entry("zai02",FALSE) 
                  CALL cl_err('','azz-275',0)
                  #FUN-810021
                  IF cl_null(g_zai.zai07) THEN
                     LET g_zai.zai07 = g_zai.zai01
                     DISPLAY g_zai.zai07 TO zai07
                  END IF
                  #END FUN-810021
               ELSE
                  CALL cl_set_comp_entry("zai02",TRUE) 
               END IF
               CALL p_query_title()
               #END FUN-7C0020
               END IF
         END IF
 
      #FUN-770079
       ON CHANGE zai04
          IF g_zai.zai04 = "Y" THEN
             CALL cl_set_comp_entry("zai06",TRUE) 
          ELSE
             LET g_zai.zai06 = "N"
             DISPLAY BY NAME g_zai.zai06
             CALL cl_set_comp_entry("zai06",FALSE) 
          END IF
      #END FUN-770079
 
      #FUN-810021
      AFTER FIELD zai07
         IF NOT cl_null(g_zai.zai07) THEN 
            IF g_zai.zai07 != g_zai_t.zai07 OR cl_null(g_zai_t.zai07) THEN
               SELECT COUNT(*) INTO l_cnt FROM zz_file 
                WHERE zz01 = g_zai.zai07
               IF l_cnt = 0 THEN
                  CALL cl_err('','azz-705',0)
                  NEXT FIELD zai07
               END IF
            END IF
         END IF
      #FUN-810021
      
      #FUN-810021
      #FUN-750084
      AFTER INPUT 
         IF INT_FLAG THEN                            # 使用者不玩了
            EXIT INPUT
         END IF
         IF g_zai.zai01 != g_zai_t.zai01 OR g_zai_t.zai01 IS NULL  
         THEN
            SELECT count(*) INTO l_n FROM zai_file
              WHERE zai01 = g_zai.zai01  AND zai05 = g_zai.zai05 #FUN-750084
            IF l_n > 0 THEN
               CALL cl_err('',-239,0)
               NEXT FIELD zai01
            END IF
         END IF
      #END FUN-750084
 
      ON ACTION controlp
          CASE
             WHEN INFIELD(zai01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_zz"
                LET g_qryparam.arg1 =  g_lang
                LET g_qryparam.default1= g_zai.zai01
                CALL cl_create_qry() RETURNING g_zai.zai01
                DISPLAY g_zai.zai01 TO zai01
                NEXT FIELD zai01
             WHEN INFIELD(zai07)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_zz"
                LET g_qryparam.arg1 =  g_lang
                LET g_qryparam.default1= g_zai.zai07
                CALL cl_create_qry() RETURNING g_zai.zai07
                DISPLAY g_zai.zai07 TO zai07
                NEXT FIELD zai07
             OTHERWISE
                EXIT CASE
          END CASE
      #END FUN-810021
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION CONTROLF                       #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
   END INPUT
 
END FUNCTION
 
FUNCTION p_query_q()                            #Query 查詢
   LET g_row_count = 0 #No.FUN-580092 HCN
   LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count) #No.FUN-580092 HCN
   MESSAGE ""
 
  #CLEAR FROM  #No.TQC-740075
   CLEAR FORM  #No.TQC-740075
   INITIALIZE g_zai.* TO NULL
   INITIALIZE g_zap.* TO NULL
   INITIALIZE g_zau.* TO NULL
   LET g_zak.zak02 = ""
   CALL g_zaj.clear()
   CALL g_zal.clear()
   CALL g_zat.clear()
   CALL g_zam.clear()
   CALL g_zan.clear()
   CALL g_out.clear()
   CALL p_query_init()                         #CHI-A60010
 
   DISPLAY '    ' TO FORMONLY.cnt
   CALL p_query_curs()                         #取得查詢條件
   IF INT_FLAG THEN                            #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN p_query_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                       #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_zai.zai01 TO NULL
      INITIALIZE g_zai.zai05 TO NULL           #FUN-750084
   ELSE
       OPEN  query_count
       FETCH query_count INTO g_row_count
 
       DISPLAY g_row_count TO FORMONLY.cnt #No.FUN-580092 HCN
      CALL p_query_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION p_query_fetch(p_flag)                #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1    #處理方式  #No.FUN-680135 VARCHAR(1)
 
   MESSAGE ""
   CASE p_flag
       #MOD-530271
      WHEN 'N' FETCH NEXT     p_query_b_curs INTO g_zai.zai01,g_zai.zai05 #FUN-750084
      WHEN 'P' FETCH PREVIOUS p_query_b_curs INTO g_zai.zai01,g_zai.zai05 #FUN-750084
      WHEN 'F' FETCH FIRST    p_query_b_curs INTO g_zai.zai01,g_zai.zai05 #FUN-750084
      WHEN 'L' FETCH LAST     p_query_b_curs INTO g_zai.zai01,g_zai.zai05 #FUN-750084
       #END MOD-530271
      WHEN '/'
         IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = FALSE
               RETURN
            END IF
         END IF
         FETCH ABSOLUTE g_jump p_query_b_curs INTO g_zai.zai01,g_zai.zai05 #FUN-750084
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zai.zai01,SQLCA.sqlcode,0)
      INITIALIZE g_zai.* TO NULL
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count #No.FUN-580092 HCN
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count) #No.FUN-580092 HCN
 
      SELECT * INTO g_zai.* FROM zai_file 
       WHERE zai01 = g_zai.zai01 AND zai05 = g_zai.zai05   #FUN-750084
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","zai_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","",1)  
      ELSE
         CALL p_query_show()
      END IF
   END IF
 
  # CALL p_query_b_display() 
 
END FUNCTION
 
FUNCTION p_query_show()                           # 將資料顯示在畫面上
 
   LET g_zai_t.* = g_zai.* 
 
   SELECT COUNT(*) INTO g_zz_cnt FROM zz_file WHERE zz01=g_zai.zai01
 
   CALL p_query_title() #No.FUN-7C0020 
 
   DISPLAY BY NAME g_zai.zai01,g_zai.zai02,g_zai.zai03,g_zai.zai07,g_zai.zai04,g_zai.zai06,g_zai.zai05,  #FUN-750084 #FUN-770079 #No.FUN-810021
                   g_zai.zaiuser,g_zai.zaigrup,g_zai.zaimodu,g_zai.zaidate,g_zai.zaiud01 #darcy:2023/06/06 add
 
   LET g_zak.zak02 = ""
   SELECT zak02,zak03,zak06 INTO g_zak.zak02,g_zak.zak03,g_zak.zak06
     FROM zak_file WHERE zak01 = g_zai.zai01 AND zak07 = g_zai.zai05 #FUN-750084
   DISPLAY g_zak.zak02 TO zak02
 
   INITIALIZE g_zap.* TO NULL
   INITIALIZE g_zau.* TO NULL
   CALL g_sum_field.clear()
 
   SELECT zau02,zau03 INTO g_zau.*  
     FROM zau_file where zau01 = g_zai.zai01 AND zau04 = g_zai.zai05 #FUN-750084

   IF g_wc8=' 1=1' OR cl_null(g_wc8) THEN                               #NO.CHI-A60010   #增加CONSTRUCT單身條件式
      SELECT zap02,zap03,zap04,zap05,zap06 INTO g_zap.* 
        FROM zap_file where zap01 = g_zai.zai01 AND zap07 = g_zai.zai05 #FUN-750084
   #NO.CHI-A60010--start----------------------
   #增加CONSTRUCT單身條件式
   ELSE
      LET g_sql = "SELECT zap02,zap03,zap04,zap05,zap06 ", 
                  "  FROM zap_file where zap01 = '", g_zai.zai01, "'", 
                  "    AND zap07 = '", g_zai.zai05, "' AND ", g_wc8
      PREPARE zap_pre FROM g_sql           #預備一下
      DECLARE zap_curs CURSOR FOR zap_pre
      OPEN zap_curs 
      FETCH zap_curs INTO g_zap.* 
   END IF
   #NO.CHI-A60010--end------------------------
 
   DISPLAY BY NAME g_zau.zau02,g_zau.zau03,
                   g_zap.zap02,g_zap.zap03,g_zap.zap04,g_zap.zap05,g_zap.zap06
 
   #CALL p_query_process_b_fill()                # Process 單身
   #NO.CHI-A60010--start----------------------
   #將單身資料加入where條件式篩選出來,增加傳遞where條件式參數
   #CALL p_query_sql_b_fill()                    # SQL     單身
   #CALL p_query_field_b_fill()                  # Field   單身
   #CALL p_query_group_b_fill()                  # Group   單身
   #CALL p_query_sum_b_fill()                    # Sum     單身
   #CALL p_query_layout_b_fill()                 # Layout  單身
   CALL p_query_sql_b_fill(g_wc3)                # SQL     單身
   CALL p_query_field_b_fill(g_wc4)              # Field   單身
   CALL p_query_group_b_fill(g_wc6)              # Group   單身
   CALL p_query_sum_b_fill(g_wc7)                # Sum     單身
   CALL p_query_layout_b_fill()                  # Layout  單身
   #NO.CHI-A60010--end------------------------
 
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION p_query_r()        # 取消整筆 (所有合乎單頭的資料)
   DEFINE  l_zai    RECORD LIKE zai_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_zai.zai01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN p_query_cl USING g_zai.zai01,g_zai.zai05 
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE p_query_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH p_query_cl INTO g_zai.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("zai01 LOCK:",SQLCA.sqlcode,1)
      CLOSE p_query_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF cl_delh(0,0) THEN                   #確認一下
      #FUN-750084
      DELETE FROM zai_file WHERE zai01=g_zai.zai01 AND zai05=g_zai.zai05 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zai_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         RETURN
      END IF
      DELETE FROM zaj_file WHERE zaj01=g_zai.zai01 AND zaj07=g_zai.zai05
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zaj_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         RETURN
      END IF
      DELETE FROM zak_file WHERE zak01=g_zai.zai01 AND zak07=g_zai.zai05
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zak_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         RETURN
      END IF
      DELETE FROM zal_file WHERE zal01=g_zai.zai01 AND zal07=g_zai.zai05
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zal_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         RETURN
      END IF
      DELETE FROM zam_file WHERE zam01=g_zai.zai01 AND zam09=g_zai.zai05
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zam_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         RETURN
      END IF
      DELETE FROM zan_file WHERE zan01=g_zai.zai01 AND zan08=g_zai.zai05
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zan_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         RETURN
      END IF
      DELETE FROM zao_file WHERE zao01=g_zai.zai01 AND zao05=g_zai.zai05
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zao_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         RETURN
      END IF
      DELETE FROM zap_file WHERE zap01=g_zai.zai01 AND zap07=g_zai.zai05
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zap_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         RETURN
      END IF
      DELETE FROM zaq_file WHERE zaq01=g_zai.zai01 AND zaq05=g_zai.zai05
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zaq_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         RETURN
      END IF
      DELETE FROM zar_file WHERE zar01=g_zai.zai01 AND zar05=g_zai.zai05
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zar_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         RETURN
      END IF
      DELETE FROM zas_file WHERE zas01=g_zai.zai01 AND zas11=g_zai.zai05
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zas_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         RETURN
      END IF
      DELETE FROM zat_file WHERE zat01=g_zai.zai01 AND zat10=g_zai.zai05
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zat_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         RETURN
      END IF
      DELETE FROM zav_file
        WHERE zav01 = '2' AND zav02 = g_zai.zai01 AND zav04=g_zai.zai05
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zav_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","",0)    #No.FUN-660081
         RETURN
      END IF
      DELETE FROM zau_file WHERE zau01=g_zai.zai01 AND zau04=g_zai.zai05
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zau_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         RETURN
      END IF
      #END FUN-750084
 
      #FUN-770079
      DELETE FROM zay_file WHERE zay01=g_zai.zai01 AND zay03=g_zai.zai05
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zay_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         RETURN
      END IF
      #END FUN-770079
 
     #CLEAR FROM  #No.TQC-740075
      CLEAR FORM  #No.TQC-740075
      INITIALIZE g_zai.* TO NULL
      INITIALIZE g_zap.* TO NULL
      INITIALIZE g_zau.* TO NULL
      LET g_zak.zak02 = ""
      CALL g_zaj.clear()
      CALL g_zal.clear()
      CALL g_zat.clear()
      CALL g_zam.clear()
      CALL g_zan.clear()
      CALL g_zaq.clear()
      CALL g_zart.clear()
      CALL g_zar.clear()
      CALL g_zas.clear()
      CALL g_zay.clear()                   #FUN-770079
      CALL g_out.clear()
 
      CLEAR FORM
 
      OPEN query_count
#FUN-B50065------begin---
      IF STATUS THEN
         CLOSE query_count
         COMMIT WORK
         RETURN
      END IF
#FUN-B50065------end------
      FETCH query_count INTO g_row_count
#FUN-B50065------begin---
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE query_count
         COMMIT WORK
         RETURN
      END IF
#FUN-B50065------end------
      DISPLAY g_row_count TO FORMONLY.cnt
 
      OPEN p_query_b_curs
      IF g_curs_index = g_row_count + 1 THEN #No.FUN-580092 HCN
          LET g_jump = g_row_count #No.FUN-580092 HCN
         CALL p_query_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL p_query_fetch('/')
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION p_query_process_b()                                 # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,   # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT
            l_n             LIKE type_file.num5,   # 檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,   # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,   # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,   #No.FUN-680135      SMALLINT
            l_allow_delete  LIKE type_file.num5    #No.FUN-680135      SMALLINT
   DEFINE k,i               LIKE type_file.num10   #No.FUN-680135      INTEGER
   DEFINE l_num             LIKE type_file.num10   #No.FUN-680135      INTEGERE   # FUN-580020
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_zai.zai01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT zaj02,zaj03,zaj04,zaj05,zaj06 FROM zaj_file ",
                     " WHERE zaj01 = ? AND zaj02 = ? AND zaj07 = ? FOR UPDATE " #FUN-750084
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_query_process_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   CALL FGL_DIALOG_SETFIELDORDER(FALSE) #NO.FUN-610033
 
   INPUT ARRAY g_zaj WITHOUT DEFAULTS FROM s_zaj.*
              ATTRIBUTE(COUNT=g_process_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_process_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_process_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_zaj_t.* = g_zaj[l_ac].*    #BACKUP
 
            OPEN p_query_process_cl USING g_zai.zai01,g_zaj_t.zaj02,g_zai.zai05 #FUN-750084
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_query_process_cl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_query_process_cl INTO g_zaj[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_zaj_t.zaj02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
 
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_zaj[l_ac].* TO NULL       #900423
         SELECT MAX(zaj02)+1 INTO g_zaj[l_ac].zaj02 
            FROM zaj_file where zaj01 = g_zai.zai01 AND zaj07=g_zai.zai05 #FUN-750084
         IF g_zaj[l_ac].zaj02 IS NULL THEN
            LET g_zaj[l_ac].zaj02 = 1
         END IF
         LET g_zaj[l_ac].zaj03 = 'Y'
         LET g_zaj[l_ac].zaj04 = 'A'
         LET g_zaj_t.* = g_zaj[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD zaj02
 
 
      AFTER FIELD zaj02
         IF NOT cl_null(g_zaj[l_ac].zaj02) THEN
            IF g_zaj[l_ac].zaj02 != g_zaj_t.zaj02 OR g_zaj_t.zaj02 IS NULL 
            THEN
               SELECT count(*) INTO l_n FROM zaj_file
                 WHERE zaj01 = g_zai.zai01 AND zaj02 = g_zaj[l_ac].zaj02
                   AND zaj07 = g_zai.zai05
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_zaj[l_ac].zaj02 = g_zaj_t.zaj02
                  NEXT FIELD zaj02
               END IF
            END IF
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         #FUN-750084
         INSERT INTO zaj_file (zaj01,zaj02,zaj03,zaj04,zaj05,zaj06,zaj07)  
                 VALUES (g_zai.zai01,g_zaj[l_ac].zaj02,g_zaj[l_ac].zaj03,
                         g_zaj[l_ac].zaj04,g_zaj[l_ac].zaj05,g_zaj[l_ac].zaj06,g_zai.zai05)
         #END FUN-750084
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","zaj_file",g_zai.zai01,g_zaj[l_ac].zaj02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_process_rec_b = g_process_rec_b + 1
            DISPLAY g_process_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF (NOT cl_null(g_zaj_t.zaj02))  THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM zaj_file
              WHERE zaj01 = g_zai.zai01 AND zaj02 = g_zaj[l_ac].zaj02
                AND zaj07 = g_zai.zai05                           #FUN-750084
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","zaj_file",g_zai.zai01,g_zaj[l_ac].zaj02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_process_rec_b = g_process_rec_b-1
            DISPLAY g_process_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_zaj[l_ac].* = g_zaj_t.*
            CLOSE p_query_process_cl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zaj[l_ac].zaj02,-263,1)
            LET g_zaj[l_ac].* = g_zaj_t.*
         ELSE
            UPDATE zaj_file SET zaj02 = g_zaj[l_ac].zaj02,
                                zaj03 = g_zaj[l_ac].zaj03,
                                zaj04 = g_zaj[l_ac].zaj04,
                                zaj05 = g_zaj[l_ac].zaj05,
                                zaj06 = g_zaj[l_ac].zaj06
             WHERE zaj01 = g_zai.zai01 AND zaj02 = g_zaj_t.zaj02
               AND zaj07 = g_zai.zai05                           #FUN-750084
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","zaj_file",g_zai.zai01,g_zaj_t.zaj02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_zaj[l_ac].* = g_zaj_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac          #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_zaj[l_ac].* = g_zaj_t.*
            #FUN-D30034---add---str---
            ELSE
               CALL g_zaj.deleteElement(l_ac)
               IF g_process_rec_b != 0 THEN
                  LET g_page_choice = "query_process"
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034---add---end---
            END IF
            CLOSE p_query_process_cl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac          #FUN-D30034 add
         CALL g_zaj.deleteElement(g_process_rec_b+1)
         CLOSE p_query_process_cl
         COMMIT WORK
 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF l_ac > 1 THEN
            LET g_zaj[l_ac].* = g_zaj[l_ac-1].*
            SELECT MAX(zaj02)+1 INTO g_zaj[l_ac].zaj02 FROM zaj_file 
             WHERE zaj01 = g_zai.zai01 AND zaj07=g_zai.zai05    #FUN-750084
             
            IF g_zaj[l_ac].zaj02 IS NULL THEN
               LET g_zaj[l_ac].zaj02 = 1
            END IF
            NEXT FIELD zaj02
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
   END INPUT
 
   #TQC-810053
   LET g_zai.zaimodu = g_user
   LET g_zai.zaidate = g_today
   UPDATE zai_file SET zaimodu=g_zai.zaimodu,zaidate=g_zai.zaidate
       WHERE zai01=g_zai.zai01
   DISPLAY BY NAME g_zai.zaimodu,g_zai.zaidate
   #END TQC-810053
 
   CLOSE p_query_process_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION p_query_sql_b()                                 # 單身
   DEFINE   l_w_ac_t          LIKE type_file.num5,   # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT
            l_n             LIKE type_file.num5,   # 檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,   # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,   # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,   #No.FUN-680135      SMALLINT
            l_allow_delete  LIKE type_file.num5    #No.FUN-680135      SMALLINT
   DEFINE k,i               LIKE type_file.num10   #No.FUN-680135      INTEGER
   DEFINE l_num             LIKE type_file.num10   #No.FUN-680135      INTEGERE   # FUN-580020
   DEFINE l_index           LIKE type_file.num5  
   DEFINE l_cnt             LIKE type_file.num5  
   DEFINE l_zak02           STRING
   DEFINE l_datatype        STRING                 #FUN-770079
   DEFINE l_length          STRING                 #FUN-770079
   DEFINE li_i              LIKE type_file.num5    #暫存用數值   # No:FUN-BA0116
   DEFINE lc_target         LIKE gay_file.gay01    #No:FUN-BA0116
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_zai.zai01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   IF cl_null(g_zak.zak02) THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   #LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_insert = FALSE
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT zal02,zal03,zal04,zal05,zal09,zal08,zal06 FROM zal_file",  #FUN-770079 #FUN-7C0020
                     "  WHERE zal01 = ? AND zal02 = ? AND zal03 = ? ",
                     "   AND zal07 = ? FOR UPDATE "               #FUN-750084
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_query_sql_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_w_ac_t = 0
   CALL FGL_DIALOG_SETFIELDORDER(FALSE) #NO.FUN-610033
 
   INPUT ARRAY g_zal WITHOUT DEFAULTS FROM s_zal.*
              ATTRIBUTE(COUNT=g_sql_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_sql_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_w_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_w_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_sql_rec_b >= l_w_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_zal_t.* = g_zal[l_w_ac].*    #BACKUP
 
            OPEN p_query_sql_cl USING g_zai.zai01,g_zal_t.zal02,g_zal_t.zal03,g_zai.zai05 #FUN-750084
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_query_sql_cl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_query_sql_cl INTO g_zal[l_w_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_zal_t.zal02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF

      ###FUN-B90139 START ###
      AFTER FIELD zal05
         IF NOT cl_unicode_check02(g_zal[l_w_ac].zal03, g_zal[l_w_ac].zal05,"1") THEN
            NEXT FIELD zal05
         END IF
      ###FUN-B90139 END ###
 
      #TQC-810053
      #FUN-770079
      #  CALL p_query_field_type(g_zal[l_w_ac].zal04) RETURNING l_datatype,l_length
      #  IF l_datatype = "number" OR l_datatype = "decimal" OR
      #     cl_null(l_datatype)
      #  THEN
      #     CALL cl_set_comp_entry("zal08", FALSE)
      #  ELSE
      #     CALL cl_set_comp_entry("zal08", TRUE)
      #  END IF
 
      #BEFORE FIELD zal08
      #  IF l_datatype = "number" OR l_datatype = "decimal" OR
      #     cl_null(l_datatype)
      #  THEN
      #      CALL cl_err(g_zal[l_w_ac].zal04,'azz-259', 0)
      #  END IF 
      #END TQC-810053
 
      AFTER FIELD zal08
         IF NOT cl_null(g_zal[l_w_ac].zal08) THEN
            IF g_zal[l_w_ac].zal08 <= 0 THEN
               CALL cl_err('','-32406', 0)
               NEXT FIELD zal08
            END IF
         END IF
      #END FUN-770079 
 
      BEFORE DELETE                            #是否取消單身
         IF (NOT cl_null(g_zal_t.zal02))  THEN
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            LET l_zak02 = g_zak.zak02
            LET l_index = l_zak02.getIndexOf(g_zal[l_w_ac].zal04,1)
            IF l_index != 0 THEN
              CALL cl_err('',"azz-126",1)
              CANCEL DELETE
            END IF
 
            IF NOT cl_confirm('azz-272') THEN
               CANCEL DELETE
            END IF
 
            DELETE FROM zal_file
              WHERE zal01 = g_zai.zai01 AND zal02 = g_zal[l_w_ac].zal02
                AND zal03 = g_zal[l_w_ac].zal03 AND zal07 = g_zai.zai05 #FUN-750084
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","zal_file",g_zai.zai01,g_zal[l_w_ac].zal02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF
 
            DELETE FROM zat_file
              WHERE zat01 = g_zai.zai01 AND zat02 = g_zal[l_w_ac].zal02
                AND zat10 = g_zai.zai05                      #FUN-750084
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","zat_file",g_zai.zai01,g_zal[l_w_ac].zal02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            DELETE FROM zav_file
              WHERE zav01 = '2' AND zav02 = g_zai.zai01 
                AND zav03 = g_zal[l_w_ac].zal04 
                AND zav04 = g_zai.zai05                      #FUN-750084
                AND zav05 = 'default'
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","zav_file",g_zai.zai01,g_zal[l_w_ac].zal04,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            #FUN-770079
            DELETE FROM zay_file
              WHERE zay01 = g_zai.zai01 
                AND zay02 = g_zal[l_w_ac].zal02
                AND zay03 = g_zai.zai05                      #FUN-750084
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","zay_file",g_zai.zai01,g_zal[l_w_ac].zal02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            #END FUN-770079
            DELETE FROM zam_file
              WHERE zam01 = g_zai.zai01 AND zam02 = g_zal[l_w_ac].zal02
                AND zam09 = g_zai.zai05                         #FUN-750084
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","zam_file",g_zai.zai01,g_zal[l_w_ac].zal02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            
            DELETE FROM zan_file
              WHERE zan01 = g_zai.zai01 AND zan02 = g_zal[l_w_ac].zal02
                AND zan08 = g_zai.zai05                         #FUN-750084 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","zan_file",g_zai.zai01,g_zal[l_w_ac].zal02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF
 
            LET g_sql_rec_b = g_sql_rec_b-1
            DISPLAY g_sql_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_zal[l_w_ac].* = g_zal_t.*
            CLOSE p_query_sql_cl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zal[l_w_ac].zal02,-263,1)
            LET g_zal[l_w_ac].* = g_zal_t.*
         ELSE
            #FUN-7C0020
            IF g_zal[l_w_ac].zal09 MATCHES "[JKMNOPQRST]"  THEN
               #TQC-810053
               SELECT COUNT(*) INTO l_cnt FROM zan_file
                WHERE zan01 = g_zai.zai01 AND zan02 = g_zal[l_w_ac].zal02
                  AND zan08 = g_zai.zai05                         #FUN-750084 
               IF l_cnt > 0 THEN
                  IF NOT cl_confirm('azz-276') THEN
                     NEXT FIELD zal09
                  END IF
               ELSE
                  SELECT COUNT(*) INTO l_cnt FROM zat_file
                    WHERE zat01 = g_zai.zai01 AND zat02 = g_zal[l_w_ac].zal02
                      AND zat10 = g_zai.zai05 AND zat07="Y"         #FUN-750084
                  IF l_cnt > 0 THEN
                     IF NOT cl_confirm('azz-276') THEN
                        NEXT FIELD zal09
                     END IF
                  END IF
               END IF
               #END TQC-810053
            END IF
            #END FUN-7C0020
 
            UPDATE zal_file SET zal02 = g_zal[l_w_ac].zal02,
                                zal03 = g_zal[l_w_ac].zal03,
                                zal04 = g_zal[l_w_ac].zal04,
                                zal05 = g_zal[l_w_ac].zal05,
                                zal06 = g_zal[l_w_ac].zal06,
                                zal09 = g_zal[l_w_ac].zal09,      #FUN-7C0020
                                zal08 = g_zal[l_w_ac].zal08       #FUN-770079
             WHERE zal01 = g_zai.zai01   AND zal02 = g_zal_t.zal02
               AND zal03 = g_zal_t.zal03 AND zal07 = g_zai.zai05  #FUN-750084
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","zal_file",g_zai.zai01,g_zal_t.zal02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_zal[l_w_ac].* = g_zal_t.*
               ROLLBACK WORK
            ELSE
               #FUN-7C0020
               IF g_zal[l_w_ac].zal09 MATCHES "[JKMNOPQRST]"  THEN
                  DELETE FROM zan_file
                    WHERE zan01 = g_zai.zai01 AND zan02 = g_zal_t.zal02
                      AND zan08 = g_zai.zai05                         #FUN-750084 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","zan_file",g_zai.zai01,g_zal_t.zal02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                     ROLLBACK WORK
                  ELSE
                    UPDATE zat_file SET zat07 = 'N', zat08 = '', zat09 = ''
                     WHERE zat01 = g_zai.zai01 AND zat02 = g_zal_t.zal02
                       AND zat10 = g_zai.zai05 
                     IF SQLCA.sqlcode THEN
                        CALL cl_err3("upd","zat_file",g_zai.zai01,g_zal_t.zal02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                        ROLLBACK WORK
                     ELSE
                        MESSAGE 'UPDATE O.K'
                        COMMIT WORK
                     END IF
                  END IF
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
               #END FUN-7C0020
            END IF
         END IF
 
      AFTER ROW
         LET l_w_ac = ARR_CURR()
         LET l_w_ac_t = l_w_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_zal[l_w_ac].* = g_zal_t.*
            END IF
            CLOSE p_query_sql_cl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CALL g_zal.deleteElement(g_sql_rec_b+1)
         CLOSE p_query_sql_cl
         COMMIT WORK
 
      # No:FUN-BA0116 ---start---
      ON ACTION translate_zhtw
         LET lc_target = ''
         #確認現在位置，決定待翻譯的目標語言別
         CASE
            WHEN g_zal[l_w_ac].zal03 = "0" LET lc_target = "2"
            WHEN g_zal[l_w_ac].zal03 = "2" LET lc_target = "0"
         END CASE

         #搜尋 PK值,找出正確待翻位置
         FOR li_i = 1 TO g_zal.getLength()
            IF li_i = l_ac THEN CONTINUE FOR END IF
            IF g_zal[li_i].zal02 = g_zal[l_w_ac].zal02
               AND g_zal[li_i].zal03 = lc_target THEN
               CASE  #決定待翻欄位
                  WHEN INFIELD(zal05)
                     LET g_zal[l_w_ac].zal05 = cl_trans_utf8_twzh(g_zal[l_w_ac].zal03,g_zal[li_i].zal05)
                     DISPLAY g_zal[l_w_ac].zal05 TO zal05
                     EXIT FOR
               END CASE
            END IF
         END FOR
      # No:FUN-BA0116 --- end ---

      ON ACTION CONTROLO                       #沿用所有欄位
         IF l_w_ac > 1 THEN
            LET g_zal[l_w_ac].* = g_zal[l_w_ac-1].*
            SELECT MAX(zal02)+1 INTO g_zal[l_w_ac].zal02 FROM zal_file 
             WHERE zal01 = g_zai.zai01 AND zal07 = g_zai.zai05    #FUN-750084
            IF g_zal[l_w_ac].zal02 IS NULL THEN
               LET g_zal[l_w_ac].zal02 = 1
            END IF
            NEXT FIELD zal02
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
   END INPUT
 
   #TQC-810053
   LET g_zai.zaimodu = g_user
   LET g_zai.zaidate = g_today
   UPDATE zai_file SET zaimodu=g_zai.zaimodu,zaidate=g_zai.zaidate
       WHERE zai01=g_zai.zai01
   DISPLAY BY NAME g_zai.zaimodu,g_zai.zaidate
   #END TQC-810053
 
   CLOSE p_query_sql_cl
   COMMIT WORK
   CALL p_query_sum_combobox()
   LET g_items = p_query_combobox()
 
END FUNCTION
 
FUNCTION p_query_field_b()                                 # 單身
   DEFINE l_w_ac_t          LIKE type_file.num5,   # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT
          l_n               LIKE type_file.num5,   # 檢查重複用        #No.FUN-680135 SMALLINT
          l_lock_sw         LIKE type_file.chr1,   # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
          p_cmd             LIKE type_file.chr1,   # 處理狀態          #No.FUN-680135 VARCHAR(1)
          l_allow_insert    LIKE type_file.num5,   #No.FUN-680135      SMALLINT
          l_allow_delete    LIKE type_file.num5    #No.FUN-680135      SMALLINT
   DEFINE l_zal02           LIKE zal_file.zal02
   DEFINE k,i               LIKE type_file.num10   #No.FUN-680135      INTEGER
   DEFINE l_num             LIKE type_file.num10   #No.FUN-680135      INTEGERE   # FUN-580020
   DEFINE l_cnt             LIKE type_file.num10 
   DEFINE l_str             STRING
   DEFINE l_tab             STRING
   DEFINE buf               base.StringBuffer
   DEFINE l_tok             base.StringTokenizer
   DEFINE l_status          LIKE type_file.num5
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_zai.zai01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   IF cl_null(g_zak.zak02) THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
  #LET l_allow_insert = cl_detail_input_auth("insert")
  #LET l_allow_delete = cl_detail_input_auth("delete")
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
 
   LET g_forupd_sql= "SELECT zat02,'','',zat03,zat12,zat04,zat05,", #FUN-7C0020
                     "       zat06,zat07,zat08,zat09,zat11",        #FUN-770079
                     "  FROM zat_file WHERE zat01 = ? AND zat02 = ? AND zat10 = ? FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_query_field_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_w_ac_t = 0
   CALL FGL_DIALOG_SETFIELDORDER(FALSE) #NO.FUN-610033
 
  #LET l_str = p_query_cut_spaces(g_zak.zak03)
   LET l_str = g_zak.zak03 CLIPPED                        #FUN-810062
   LET l_str = l_str.toUpperCase()
   LET buf = base.StringBuffer.create()
   CALL buf.append(l_str)
   CALL buf.replace("OUTER ","", 0)
   CALL buf.replace(" ","", 0)
   LET l_str  = buf.toString()
   LET l_str = l_str.toLowerCase()
 
   INPUT ARRAY g_zat WITHOUT DEFAULTS FROM s_zat.*
              ATTRIBUTE(COUNT=g_field_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_field_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_w_ac)
         END IF
         CALL cl_set_action_active("qry_param_setting", FALSE)
 
      BEFORE ROW
         LET p_cmd=''
         LET l_w_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_field_rec_b >= l_w_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_zat_t.* = g_zat[l_w_ac].*    #BACKUP
 
            OPEN p_query_field_cl USING g_zai.zai01,g_zat_t.zat02,g_zai.zai05 #FUN-750084
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_query_field_cl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_query_field_cl INTO g_zat[l_w_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_zat_t.zat02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT zal04,zal05 INTO g_zat[l_w_ac].tzal04,g_zat[l_w_ac].tzal05
                 FROM zal_file WHERE zal01 = g_zai.zai01 AND zal03 = g_lang 
                                 AND zal07 = g_zai.zai05 AND zal02 = g_zat[l_w_ac].zat02  #FUN-750084
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
         CALL p_query_set_entry_b()
         CALL p_query_set_no_entry_b()
 
      #FUN-7C0020
      AFTER FIELD zat12
         IF NOT cl_null(g_zat[l_w_ac].zat12) THEN
            IF g_zat[l_w_ac].zat12 <= 0 THEN
               CALL cl_err('','-32406', 0)
               NEXT FIELD zat12
            END IF
         END IF
      #END FUN-7C0020
 
      BEFORE FIELD zat04                                       #FUN-750084
         CALL p_query_set_entry_b()
 
      AFTER FIELD zat04
         IF g_zat[l_w_ac].zat04 != g_zat_t.zat04 OR cl_null(g_zat_t.zat04) OR
            cl_null(g_zat[l_w_ac].zat04)                       #FUN-770079
         THEN
            IF cl_null(g_zat[l_w_ac].zat04) THEN
               LET g_zat[l_w_ac].zat05 = "N"
               LET g_zat[l_w_ac].zat06 = ""
               DISPLAY BY NAME g_zat[l_w_ac].zat05,g_zat[l_w_ac].zat06
            ELSE
               IF g_zat[l_w_ac].zat04 != 0 THEN   #MOD-8B0110 add
                  SELECT COUNT(*) INTO l_cnt FROM zat_file
                    WHERE zat01 = g_zai.zai01 AND zat04 = g_zat[l_w_ac].zat04
                      AND zat10 = g_zai.zai05                          #FUN-750084
                  IF l_cnt > 0 THEN
                     LET g_n = 0
                     LET g_n = p_query_seq()
                     NEXT FIELD zat04
                  END IF
               END IF                             #MOD-8B0110 add
            END IF
         END IF
         CALL p_query_set_entry_b()
         CALL p_query_set_no_entry_b()
       
      BEFORE FIELD zat06
         CALL cl_set_action_active("qry_param_setting", TRUE)
 
      AFTER FIELD zat06
         CALL cl_set_action_active("qry_param_setting", FALSE)
 
      ON CHANGE zat05
         IF g_zat[l_w_ac].zat05 = 'N' THEN
            LET g_zat[l_w_ac].zat06 = ""
            DISPLAY BY NAME g_zat[l_w_ac].zat06
         END IF
         CALL p_query_set_entry_b()
         CALL p_query_set_no_entry_b()
 
      ON CHANGE zat07
         IF g_zat[l_w_ac].zat07 = 'N' THEN
            LET g_zat[l_w_ac].zat08 = ""
            LET g_zat[l_w_ac].zat09 = ""
            DISPLAY BY NAME g_zat[l_w_ac].zat08,g_zat[l_w_ac].zat09
         END IF
         CALL p_query_set_entry_b()
         CALL p_query_set_no_entry_b()
      
      BEFORE FIELD zat08
         IF g_zat[l_w_ac].zat07 <> "Y" THEN
            NEXT FIELD zat07
         END IF
         
      BEFORE FIELD zat09 
         IF g_zat[l_w_ac].zat07 <> "Y" THEN
            NEXT FIELD zat07
         END IF
         IF cl_null(g_zat[l_w_ac].zat08) THEN
            NEXT FIELD zat08
         END IF
         IF g_zat[l_w_ac].zat08 = '5' THEN
            CALL cl_set_action_active("controlp", FALSE)
         END IF
    
      AFTER FIELD zat09,zat08
         IF NOT cl_null(g_zat[l_w_ac].zat09) THEN
            IF g_zat[l_w_ac].zat08 = '5' THEN
               IF g_zat[l_w_ac].zat09 CLIPPED <> '0' THEN
                  LET i = g_zat[l_w_ac].zat09
                  IF i <= 0 OR i > 10 OR cl_null(i) THEN
                     CALL cl_err('','atm-113',0)
                     NEXT FIELD zat09
                  END IF 
               END IF
            ELSE
               IF g_zat[l_w_ac].zat09 <> 'aza17' THEN
                  SELECT COUNT(*) INTO l_cnt FROM zat_file,zal_file
                      WHERE zat01 = zal01 AND zat02 = zal02
                        AND zat01 = g_zai.zai01 AND zal04 = g_zat[l_w_ac].zat09
                        AND zat02 <> g_zat[l_w_ac].zat02
                        AND zat10 = g_zai.zai05                   #FUN-750084
                        AND zat10 = zal07                         #FUN-750084
                  IF l_cnt = 0 THEN
                     CALL cl_err('','azz-256',0)
                     NEXT FIELD zat09
                  END IF
                 #LET l_status = 0
                 #LET l_tok = base.StringTokenizer.createExt(l_str,",","",TRUE)
                 #WHILE l_tok.hasMoreTokens()
                 #   LET l_tab=l_tok.nextToken()
                 #   LET l_status = p_wizard_check_field(g_zat[l_w_ac].zat09 CLIPPED,l_tab,'N')
                 #   IF l_status THEN
                 #      EXIT WHILE
                 #   END IF
                 #END WHILE    
                 #IF NOT l_status THEN    
                 #   LET l_tab= l_str," + ",g_zat[l_w_ac].zat09
                 #   CALL cl_err(l_tab,"-1106",0)
                 #   NEXT FIELD zat09
                 #END IF
               END IF
            END IF
         END IF
         IF INFIELD(zaa19) THEN
            CALL cl_set_action_active("controlp", TRUE)
         END IF
 
      #FUN-770079
      ON CHANGE zat11
         IF g_zat[l_w_ac].zat11 != g_zat_t.zat11 THEN
            IF g_zat[l_w_ac].zat11 = 'Y' THEN
               IF p_query_replace(g_zat[l_w_ac].zat02) THEN
                  LET g_zat_t.zat11 = g_zat[l_w_ac].zat11
               ELSE
                  LET g_zat[l_w_ac].zat11 = g_zat_t.zat11
                  DISPLAY BY NAME g_zat[l_w_ac].zat11
               END IF
            ELSE 
               IF cl_confirm('azz-270') THEN  #已有轉換資料，是否刪除設定資料?
                  DELETE FROM zay_file
                    WHERE zay01 = g_zai.zai01 
                      AND zay02 = g_zat[l_w_ac].zat02 
                      AND zay03 = g_zai.zai05                      #FUN-750084 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","zay_file",g_zai.zai01,g_zat[l_w_ac].zat02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                     NEXT FIELD zat04
                  END IF
                  LET g_zat_t.zat11 = g_zat[l_w_ac].zat11
               ELSE
                  LET g_zat[l_w_ac].zat11 = g_zat_t.zat11
                  DISPLAY BY NAME g_zat[l_w_ac].zat11
               END IF
            END IF
         END IF
      #END FUN-770079
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_zat[l_w_ac].* = g_zat_t.*
            CLOSE p_query_field_cl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zat[l_w_ac].zat02,-263,1)
            LET g_zat[l_w_ac].* = g_zat_t.*
         ELSE
            UPDATE zat_file SET zat03 = g_zat[l_w_ac].zat03,
                                zat04 = g_zat[l_w_ac].zat04,
                                zat05 = g_zat[l_w_ac].zat05,
                                zat06 = g_zat[l_w_ac].zat06,
                                zat07 = g_zat[l_w_ac].zat07,
                                zat08 = g_zat[l_w_ac].zat08,
                                zat09 = g_zat[l_w_ac].zat09,
                                zat11 = g_zat[l_w_ac].zat11,       #FUN-770079
                                zat12 = g_zat[l_w_ac].zat12        #FUN-7C0020
             WHERE zat01 = g_zai.zai01 AND zat02 = g_zat_t.zat02
               AND zat10 = g_zai.zai05                             #FUN-750084
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","zat_file",g_zai.zai01,g_zat_t.zat02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_zat[l_w_ac].* = g_zat_t.*
            ELSE
               IF cl_null(g_zat[l_w_ac].zat06) THEN
                  DELETE FROM zav_file
                    WHERE zav01 = '2' AND zav02 = g_zai.zai01 
                      AND zav03 = g_zat[l_w_ac].tzal04 
                      AND zav04 = g_zai.zai05                      #FUN-750084 
                      AND zav05 = 'default'
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","zam_file",g_zai.zai01,g_zat[l_w_ac].tzal04,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                     NEXT FIELD zat04
                  END IF
               END IF
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_w_ac = ARR_CURR()
         LET l_w_ac_t = l_w_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_zat[l_w_ac].* = g_zat_t.*
            END IF
            CLOSE p_query_field_cl
            ROLLBACK WORK
            #FUN-770079
            CALL p_query_upd_zat11(g_zat[l_w_ac].zat02,g_zat[l_w_ac].zat11)
            DISPLAY BY NAME g_zat[l_w_ac].zat11
            #END FUN-770079
            EXIT INPUT
         END IF
         CALL g_zat.deleteElement(g_field_rec_b+1)
         CLOSE p_query_field_cl
         COMMIT WORK
         #FUN-770079
         CALL p_query_upd_zat11(g_zat[l_w_ac].zat02,g_zat[l_w_ac].zat11)
         DISPLAY BY NAME g_zat[l_w_ac].zat11
         #END FUN-770079
 
      ON ACTION qry_param_setting
         IF NOT cl_null(g_zat[l_w_ac].zat06) THEN
            CALL cl_set_qryparam("2",g_zai.zai01,g_zat[l_w_ac].tzal04,g_zai.zai05,"default","c")  #FUN-750084
         END IF
 
      ON ACTION qry_replace_setting
         IF p_query_replace(g_zat[l_w_ac].zat02) THEN
            LET g_zat[l_w_ac].zat11 = 'Y'
         ELSE
            LET g_zat[l_w_ac].zat11 = 'N'
         END IF
         LET g_zat_t.zat11 = g_zat[l_w_ac].zat11
         DISPLAY BY NAME g_zat[l_w_ac].zat11
         NEXT FIELD zat11
 
      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(zat06)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gab1"
               LET g_qryparam.default1 = g_zat[l_w_ac].zat06
               LET g_qryparam.default2 = NULL
               LET g_qryparam.arg1 = g_lang CLIPPED
               CALL cl_create_qry() RETURNING g_zat[l_w_ac].zat06
               DISPLAY BY NAME g_zat[l_w_ac].zat06
 
            #WHEN INFIELD(zat09)
            #  CALL q_gaq1(FALSE,TRUE,'',l_str) 
            #       RETURNING g_zat[l_w_ac].zat09
            #  DISPLAY BY NAME g_zat[l_w_ac].zat09
         END CASE
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
   END INPUT
 
   #TQC-810053
   LET g_zai.zaimodu = g_user
   LET g_zai.zaidate = g_today
   UPDATE zai_file SET zaimodu=g_zai.zaimodu,zaidate=g_zai.zaidate
       WHERE zai01=g_zai.zai01
   DISPLAY BY NAME g_zai.zaimodu,g_zai.zaidate
   #END TQC-810053
 
   CLOSE p_query_field_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION p_query_group_b()                                 # 單身
   DEFINE   l_w_ac_t          LIKE type_file.num5,   # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT
            l_n             LIKE type_file.num5,   # 檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,   # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,   # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,   #No.FUN-680135      SMALLINT
            l_allow_delete  LIKE type_file.num5    #No.FUN-680135      SMALLINT
   DEFINE k,i               LIKE type_file.num10   #No.FUN-680135      INTEGER
   DEFINE l_num             LIKE type_file.num10   #No.FUN-680135      INTEGERE   # FUN-580020
   DEFINE l_cnt             LIKE type_file.num10 
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_zai.zai01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT zam02,'','',zam03,zam04,zam05,zam08,zam07,zam06",
                     "  FROM zam_file WHERE zam01 = ? AND zam02 = ? AND zam09 = ? FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_query_group_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_w_ac_t = 0
   CALL FGL_DIALOG_SETFIELDORDER(FALSE) #NO.FUN-610033
 
   INPUT ARRAY g_zam WITHOUT DEFAULTS FROM s_zam.*
              ATTRIBUTE(COUNT=g_group_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_group_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_w_ac)
         END IF
         
      BEFORE ROW
         LET p_cmd=''
         LET l_w_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_group_rec_b >= l_w_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_zam_t.* = g_zam[l_w_ac].*    #BACKUP
 
            OPEN p_query_group_cl USING g_zai.zai01,g_zam_t.zam02,g_zai.zai05 #FUN-750084
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_query_group_cl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_query_group_cl INTO g_zam[l_w_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_zam_t.zam02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT zal04,zal05 INTO g_zam[l_w_ac].mzal04,g_zam[l_w_ac].mzal05
                 FROM zal_file WHERE zal01 = g_zai.zai01 AND zal03 = g_lang 
                                 AND zal07 = g_zai.zai05 AND zal02 = g_zam[l_w_ac].zam02 #FUN-750084
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
         CALL p_query_set_entry_b()
         CALL p_query_set_no_entry_b()
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_zam[l_w_ac].* TO NULL       #900423
         LET g_zam_t.* = g_zam[l_w_ac].*          #新輸入資料
         LET g_zam[l_w_ac].zam03 = 'N'
         LET g_zam[l_w_ac].zam04 = 'N'
         LET g_zam[l_w_ac].zam07 = 'N'
         LET g_zam[l_w_ac].zam08 = '1'
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD mzal04
 
      ON CHANGE mzal04
         CALL p_query_zal(g_zam[l_w_ac].mzal04)  
              RETURNING  g_zam[l_w_ac].zam02,g_zam[l_w_ac].mzal05
         DISPLAY BY NAME g_zam[l_w_ac].zam02
         DISPLAY g_zam[l_w_ac].mzal05 TO FORMONLY.mzal05
 
      AFTER FIELD mzal04
         IF NOT cl_null(g_zam[l_w_ac].mzal04) THEN
            IF g_zam[l_w_ac].mzal04 != g_zam_t.mzal04 OR g_zam_t.mzal04 IS NULL THEN
                 SELECT COUNT(*) INTO l_cnt FROM zam_file 
                    WHERE zam01=g_zai.zai01 AND zam02 = g_zam[l_w_ac].zam02
                      AND zam09=g_zai.zai05                    #FUN-750084
                 IF l_cnt > 0 THEN
                    CALL cl_err(g_zam[l_w_ac].mzal04,-239,0)
                    LET g_zam[l_w_ac].zam02 = g_zam_t.zam02
                    LET g_zam[l_w_ac].mzal04 = g_zam_t.mzal04
                    LET g_zam[l_w_ac].mzal05 = g_zam_t.mzal05
                    DISPLAY BY NAME g_zam[l_w_ac].zam02
                    DISPLAY g_zam[l_w_ac].mzal04 TO FORMONLY.mzal04
                    DISPLAY g_zam[l_w_ac].mzal05 TO FORMONLY.mzal05
                    NEXT FIELD mzal04
                 END IF
            END IF
         END IF 
 
      BEFORE FIELD zam04
         CALL cl_set_comp_entry("zam05,zam07,zam08", TRUE)
 
      ON CHANGE zam04
         CALL p_query_set_entry_b()
         CALL p_query_set_no_entry_b()
         IF g_zam[l_w_ac].zam04 = 'N' AND (NOT cl_null(g_zam[l_w_ac].zam05)) THEN
            LET g_zam[l_w_ac].zam05 = ""
            LET g_zam[l_w_ac].zam07 = "N"
            LET g_zam[l_w_ac].zam08 = "1"
         END IF
 
      AFTER FIELD zam04 
         IF g_zam[l_w_ac].zam04 = 'Y' AND cl_null(g_zam[l_w_ac].zam05) THEN 
            NEXT FIELD zam05
         END IF
 
      AFTER FIELD zam05 
         IF g_zam[l_w_ac].zam05 < 1 THEN
            NEXT FIELD  zam05
         END IF
         IF NOT cl_null(g_zam[l_w_ac].zam05) THEN
            IF g_zam[l_w_ac].zam05 != g_zam_t.zam05 OR g_zam_t.zam05 IS NULL THEN
                 SELECT COUNT(*) INTO l_cnt FROM zam_file 
                    WHERE zam01=g_zai.zai01 AND zam05 = g_zam[l_w_ac].zam05
                      AND zam09=g_zai.zai05                     #FUN-750084
                 IF l_cnt > 0 THEN
                    CALL cl_err(g_zam[l_w_ac].zam05,'axm-298',0)
                    NEXT FIELD zam05
                 END IF
            END IF
         ELSE 
            IF g_zam[l_w_ac].zam04 = 'Y'  THEN
                NEXT FIELD zam05
            END IF
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         #FUN-750084
         INSERT INTO zam_file (zam01,zam02,zam03,zam04,zam05,zam06,zam07,zam08,zam09) 
                 VALUES (g_zai.zai01,g_zam[l_w_ac].zam02,g_zam[l_w_ac].zam03,
                         g_zam[l_w_ac].zam04,g_zam[l_w_ac].zam05,g_zam[l_w_ac].zam06,
                         g_zam[l_w_ac].zam07,g_zam[l_w_ac].zam08,g_zai.zai05)
         #END FUN-750084
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","zam_file",g_zai.zai01,g_zam[l_w_ac].zam02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_group_rec_b = g_group_rec_b + 1
            DISPLAY g_group_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF (NOT cl_null(g_zam_t.zam02))  THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM zam_file
              WHERE zam01 = g_zai.zai01 AND zam02 = g_zam[l_w_ac].zam02
                AND zam09 = g_zai.zai05                         #FUN-750084
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","zam_file",g_zai.zai01,g_zam[l_w_ac].zam02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_group_rec_b = g_group_rec_b-1
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_zam[l_w_ac].* = g_zam_t.*
            CLOSE p_query_group_cl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zam[l_w_ac].zam02,-263,1)
            LET g_zam[l_w_ac].* = g_zam_t.*
         ELSE
            UPDATE zam_file SET zam02 = g_zam[l_w_ac].zam02,
                                zam03 = g_zam[l_w_ac].zam03,
                                zam04 = g_zam[l_w_ac].zam04,
                                zam05 = g_zam[l_w_ac].zam05,
                                zam07 = g_zam[l_w_ac].zam07,
                                zam08 = g_zam[l_w_ac].zam08,
                                zam06 = g_zam[l_w_ac].zam06
             WHERE zam01 = g_zai.zai01 AND zam02 = g_zam_t.zam02
               AND zam09 = g_zai.zai05                           #FUN-750084
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","zam_file",g_zai.zai01,g_zam_t.zam02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_zam[l_w_ac].* = g_zam_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_w_ac = ARR_CURR()
#        LET l_w_ac_t = l_w_ac         #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_zam[l_w_ac].* = g_zam_t.*
            #FUN-D30034---add---str---
            ELSE
               CALL g_zam.deleteElement(l_w_ac)
               IF g_group_rec_b != 0 THEN
                  LET g_page_choice = "query_group"
                  LET g_action_choice = "detail"
                  LET l_w_ac = l_w_ac_t
               END IF
            #FUN-D30034---add---end---
            END IF
            CLOSE p_query_group_cl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_w_ac_t = l_w_ac         #FUN-D30034 add
         CALL g_zam.deleteElement(g_group_rec_b+1)
         CLOSE p_query_group_cl
         COMMIT WORK
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF l_w_ac > 1 THEN
            LET g_zam[l_w_ac].* = g_zam[l_w_ac-1].*
            SELECT MAX(zam02)+1 INTO g_zam[l_w_ac].zam02 FROM zam_file 
             WHERE zam01 = g_zai.zai01  AND zam09 = g_zai.zai05    #FUN-750084
            IF g_zam[l_w_ac].zam02 IS NULL THEN
               LET g_zam[l_w_ac].zam02 = 1
            END IF
            NEXT FIELD zam02
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
   END INPUT
 
   #TQC-810053
   LET g_zai.zaimodu = g_user
   LET g_zai.zaidate = g_today
   UPDATE zai_file SET zaimodu=g_zai.zaimodu,zaidate=g_zai.zaidate
       WHERE zai01=g_zai.zai01
   DISPLAY BY NAME g_zai.zaimodu,g_zai.zaidate
   #END TQC-810053
 
   CLOSE p_query_group_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION p_query_sum_b()                                 # 單身
   DEFINE   l_w_ac_t          LIKE type_file.num5,   # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT
            l_n             LIKE type_file.num5,   # 檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,   # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,   # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,   #No.FUN-680135      SMALLINT
            l_allow_delete  LIKE type_file.num5    #No.FUN-680135      SMALLINT
   DEFINE k,i               LIKE type_file.num10   #No.FUN-680135      INTEGER
   DEFINE l_num             LIKE type_file.num10   #No.FUN-680135      INTEGERE   # FUN-580020
   DEFINE l_cnt             LIKE type_file.num10 
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_zai.zai01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT zan02,'','',zan03,zan07,zan04,zan05,'','',zan06",
                     "  FROM zan_file ",
                     " WHERE zan01 = ? AND zan02 = ? AND zan08 = ? FOR UPDATE "  #FUN-750084
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_query_sum_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_w_ac_t = 0
   CALL FGL_DIALOG_SETFIELDORDER(FALSE) #NO.FUN-610033
 
   INPUT ARRAY g_zan WITHOUT DEFAULTS FROM s_zan.*
              ATTRIBUTE(COUNT=g_sum_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_sum_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_w_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_w_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_sum_rec_b >= l_w_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_zan_t.* = g_zan[l_w_ac].*    #BACKUP
 
            OPEN p_query_sum_cl USING g_zai.zai01,g_zan_t.zan02,g_zai.zai05 #FUN-750084
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_query_sum_cl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_query_sum_cl INTO g_zan[l_w_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_zan_t.zan02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
              SELECT zal04,zal05 INTO g_zan[l_w_ac].nzal04,g_zan[l_w_ac].nzal05
                FROM zal_file
               WHERE zal01 = g_zai.zai01 AND zal03 = g_lang
                 AND zal07 = g_zai.zai05 AND zal02 = g_zan[l_w_ac].zan02  #FUN-750084
              SELECT zal04,zal05 INTO g_zan[l_w_ac].gzal04,g_zan[l_w_ac].gzal05
                FROM zal_file 
               WHERE zal01 = g_zai.zai01 AND zal03 = g_lang
                 AND zal07 = g_zai.zai05 AND zal02 = g_zan[l_w_ac].zan05  #FUN-750084
 
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
         CALL p_query_set_entry_b()
         CALL p_query_set_no_entry_b()
 
 
 
     BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_zan[l_w_ac].* TO NULL       #900423
         LET g_zan_t.* = g_zan[l_w_ac].*          #新輸入資料
         LET g_zan[l_w_ac].zan03 = 'A'
         LET g_zan[l_w_ac].zan04 = 'Y'
         LET g_zan[l_w_ac].zan07 = '1'
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD nzal04
 
      AFTER FIELD zan03 
         IF g_zan[l_w_ac].zan03 MATCHES "[ACDF]" AND 
            (g_zan[l_w_ac].zan04 IS NULL OR g_zan[l_w_ac].zan04 ="N" ) 
         THEN 
            LET g_zan[l_w_ac].zan04='Y'
            DISPLAY g_zan[l_w_ac].zan04 TO zan04
            NEXT FIELD zan04
         END IF
 
 
     ON CHANGE nzal04
        CALL p_query_zal(g_zan[l_w_ac].nzal04)
             RETURNING  g_zan[l_w_ac].zan02,g_zan[l_w_ac].nzal05
        DISPLAY BY NAME g_zan[l_w_ac].zan02
        DISPLAY g_zan[l_w_ac].nzal05 TO FORMONLY.nzal05
 
     AFTER FIELD nzal04
        IF NOT cl_null(g_zan[l_w_ac].nzal04) THEN
           IF g_zan[l_w_ac].nzal04 != g_zan_t.nzal04 OR g_zan_t.nzal04 IS NULL THEN
                SELECT COUNT(*) INTO l_cnt FROM zan_file
                 WHERE zan01 = g_zai.zai01 AND zan02 = g_zan[l_w_ac].zan02
                   AND zan08 = g_zai.zai05                          #FUN-750084  
                IF l_cnt > 0 THEN
                   CALL cl_err(g_zan[l_w_ac].nzal04,-239,0)
                   LET g_zan[l_w_ac].zan02 = g_zan_t.zan02
                   LET g_zan[l_w_ac].nzal04 = g_zan_t.nzal04
                   LET g_zan[l_w_ac].nzal05 = g_zan_t.nzal05
                   DISPLAY BY NAME g_zan[l_w_ac].zan02
                   DISPLAY g_zan[l_w_ac].nzal04 TO FORMONLY.nzal04
                   DISPLAY g_zan[l_w_ac].nzal05 TO FORMONLY.nzal05
                   NEXT FIELD nzal04
                END IF
           END IF
        END IF
 
     BEFORE FIELD zan04
        CALL cl_set_comp_entry("gzal04", TRUE)
 
     ON CHANGE zan04
        CALL p_query_set_entry_b()
        CALL p_query_set_no_entry_b()
        IF g_zan[l_w_ac].zan04 = 'N' AND (NOT cl_null(g_zan[l_w_ac].gzal04)) THEN
           LET g_zan[l_w_ac].zan05 = ""
           LET g_zan[l_w_ac].gzal04 = ""
           LET g_zan[l_w_ac].gzal05 = ""
        END IF
 
     AFTER FIELD zan04
        IF g_zan[l_w_ac].zan04 = 'Y' AND cl_null(g_zan[l_w_ac].gzal04) THEN
           NEXT FIELD gzal04
        ELSE
           CALL cl_set_comp_entry("gzal04", FALSE)
        END IF
 
     ON CHANGE gzal04
        CALL p_query_zal(g_zan[l_w_ac].gzal04)
             RETURNING  g_zan[l_w_ac].zan05,g_zan[l_w_ac].gzal05
        DISPLAY BY NAME g_zan[l_w_ac].zan05
        DISPLAY g_zan[l_w_ac].gzal05 TO FORMONLY.gzal05
 
    
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         #FUN-750084
         INSERT INTO zan_file (zan01,zan02,zan03,zan04,zan05,zan06,zan07,zan08) 
                 VALUES (g_zai.zai01,g_zan[l_w_ac].zan02,g_zan[l_w_ac].zan03,
                         g_zan[l_w_ac].zan04,g_zan[l_w_ac].zan05,g_zan[l_w_ac].zan06,
                         g_zan[l_w_ac].zan07,g_zai.zai05)
         #END FUN-750084
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","zan_file",g_zai.zai01,g_zan[l_w_ac].zan02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_sum_rec_b = g_sum_rec_b + 1
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF (NOT cl_null(g_zan_t.zan02))  THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM zan_file
              WHERE zan01 = g_zai.zai01 AND zan02 = g_zan[l_w_ac].zan02
                AND zan08 = g_zai.zai05                            #FUN-750084
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","zan_file",g_zai.zai01,g_zan[l_w_ac].zan02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_sum_rec_b = g_sum_rec_b-1
            DISPLAY g_sum_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_zan[l_w_ac].* = g_zan_t.*
            CLOSE p_query_sum_cl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zan[l_w_ac].zan02,-263,1)
            LET g_zan[l_w_ac].* = g_zan_t.*
         ELSE
            UPDATE zan_file SET zan02 = g_zan[l_w_ac].zan02,
                                zan03 = g_zan[l_w_ac].zan03,
                                zan07 = g_zan[l_w_ac].zan07,
                                zan04 = g_zan[l_w_ac].zan04,
                                zan05 = g_zan[l_w_ac].zan05,
                                zan06 = g_zan[l_w_ac].zan06
             WHERE zan01 = g_zai.zai01 AND zan02 = g_zan_t.zan02
               AND zan08 = g_zai.zai05                            #FUN-750084
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","zan_file",g_zai.zai01,g_zan_t.zan02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_zan[l_w_ac].* = g_zan_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_w_ac = ARR_CURR()
#        LET l_w_ac_t = l_w_ac           #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_zan[l_w_ac].* = g_zan_t.*
            #FUN-D30034---add---str---
            ELSE
               CALL g_zan.deleteElement(l_w_ac)
               IF g_sum_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_w_ac = l_w_ac_t
               END IF
            #FUN-D30034---add---end---

            END IF
            CLOSE p_query_sum_cl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_w_ac_t = l_w_ac           #FUN-D30034 add
         CALL g_zan.deleteElement(g_sum_rec_b+1)
         CLOSE p_query_sum_cl
         COMMIT WORK
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF l_w_ac > 1 THEN
            LET g_zan[l_w_ac].* = g_zan[l_w_ac-1].*
            SELECT MAX(zan02)+1 INTO g_zan[l_w_ac].zan02 FROM zan_file 
             WHERE zan01 = g_zai.zai01  AND zan08 = g_zai.zai05    #FUN-750084
            IF g_zan[l_w_ac].zan02 IS NULL THEN
               LET g_zan[l_w_ac].zan02 = 1
            END IF
            NEXT FIELD zan02
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
   END INPUT
 
   #TQC-810053
   LET g_zai.zaimodu = g_user
   LET g_zai.zaidate = g_today
   UPDATE zai_file SET zaimodu=g_zai.zaimodu,zaidate=g_zai.zaidate
       WHERE zai01=g_zai.zai01
   DISPLAY BY NAME g_zai.zaimodu,g_zai.zaidate
   #END TQC-810053
 
   CLOSE p_query_sum_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION p_query_layout_b()                                 # 單身
   DEFINE   l_w_ac_t          LIKE type_file.num5,   # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT
            l_n             LIKE type_file.num5,   # 檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,   # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,   # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,   #No.FUN-680135      SMALLINT
            l_allow_delete  LIKE type_file.num5    #No.FUN-680135      SMALLINT
   DEFINE k,i               LIKE type_file.num10   #No.FUN-680135      INTEGER
   DEFINE l_num             LIKE type_file.num10   #No.FUN-680135      INTEGERE   # FUN-580020
   DEFINE l_zao02           LIKE zao_file.zao02
   DEFINE l_cnt             LIKE type_file.num10 
   DEFINE l_i               LIKE type_file.num10 
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_zai.zai01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
 
 
   LET g_forupd_sql="SELECT zao04 FROM zao_file  WHERE zao01 = ? AND zao02 = ? ",
                    " AND zao03 = ? AND zao05 = ? FOR UPDATE "      #FUN-750084
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_query_layout_cl CURSOR FROM g_forupd_sql
 
   LET l_w_ac_t = 0
   CALL FGL_DIALOG_SETFIELDORDER(FALSE) #NO.FUN-610033
 
   #TQC-810053
   #SELECT COUNT(unique zao02) INTO l_cnt FROM zao_file 
   # WHERE zao01 = g_zai.zai01 AND zao05 = g_zai.zai05               #FUN-750084
   #IF l_cnt < 8 THEN
   #    DELETE FROM zao_file 
   #     WHERE zao01=g_zai.zai01 AND zao05=g_zai.zai05               #FUN-750084
   #    FOR l_i = 1 TO 8 
   #        LET g_out[l_i].out1=l_i
   #        IF l_i = 7 THEN
   #            LET g_out[l_i].out2='N'
   #            LET g_out[l_i].out3='N'
   #            LET g_out[l_i].out4='N'
   #            LET g_out[l_i].out5='N'
   #        ELSE
   #            LET g_out[l_i].out2='Y'
   #            LET g_out[l_i].out3='N'
   #            LET g_out[l_i].out4='Y'
   #            LET g_out[l_i].out5='Y'
   #        END IF
   #        #FUN-750084 
   #        INSERT INTO zao_file(zao01,zao02,zao03,zao04,zao05)
   #               VALUES(g_zai.zai01,l_i,'V',g_out[l_i].out2,g_zai.zai05) 
   #        INSERT INTO zao_file(zao01,zao02,zao03,zao04,zao05)
   #               VALUES(g_zai.zai01,l_i,'E',g_out[l_i].out3,g_zai.zai05) 
   #        INSERT INTO zao_file(zao01,zao02,zao03,zao04,zao05)
   #               VALUES(g_zai.zai01,l_i,'T',g_out[l_i].out4,g_zai.zai05) 
   #        INSERT INTO zao_file(zao01,zao02,zao03,zao04,zao05)
   #               VALUES(g_zai.zai01,l_i,'P',g_out[l_i].out5,g_zai.zai05) 
   #        IF SQLCA.sqlcode THEN
   #           CALL cl_err3("ins","zao_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","",0)
   #        #END FUN-750084 
   #           RETURN
   #        END IF
   #        LET g_layout_rec_b = 8
   #    END FOR
   #END IF
 
   CALL p_query_zao()
   #END TQC-810053
 
   INPUT ARRAY g_out WITHOUT DEFAULTS FROM s_out.*
              ATTRIBUTE(COUNT=g_layout_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_layout_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_w_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_w_ac = ARR_CURR()
         LET l_n  = ARR_COUNT()
 
         IF g_layout_rec_b >= l_w_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_out_t.* = g_out[l_w_ac].*    #BACKUP
            LET l_zao02 = l_w_ac
            OPEN p_query_layout_cl USING g_zai.zai01,l_zao02,'V',g_zai.zai05 #FUN-750084
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_query_layout_cl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_query_layout_cl INTO g_out[l_w_ac].out2
               IF SQLCA.sqlcode THEN
                  CALL cl_err(l_w_ac,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            OPEN p_query_layout_cl USING g_zai.zai01,l_zao02,'E',g_zai.zai05 #FUN-750084
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_query_layout_cl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_query_layout_cl INTO g_out[l_w_ac].out3
               IF SQLCA.sqlcode THEN
                  CALL cl_err(l_zao02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            OPEN p_query_layout_cl USING g_zai.zai01,l_zao02,'T',g_zai.zai05 #FUN-750084
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_query_layout_cl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_query_layout_cl INTO g_out[l_w_ac].out4
               IF SQLCA.sqlcode THEN
                  CALL cl_err(l_zao02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            OPEN p_query_layout_cl USING g_zai.zai01,l_zao02,'P',g_zai.zai05 #FUN-750084
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_query_layout_cl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_query_layout_cl INTO g_out[l_w_ac].out5
               IF SQLCA.sqlcode THEN
                  CALL cl_err(l_zao02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE FIELD out2,out3,out4
         CALL p_query_set_entry_b()
         CALL p_query_set_no_entry_b()
 
      AFTER FIELD out2,out3,out4
         CALL p_query_set_entry_b()
         CALL p_query_set_no_entry_b()
         IF l_w_ac = 7 THEN
            CALL cl_err('','azz-242',0)
         END IF
 
      BEFORE FIELD out5
         CALL p_query_set_entry_b()
         CALL p_query_set_no_entry_b()
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_out[l_w_ac].* = g_out_t.*
            CLOSE p_query_layout_cl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err('',-263,1)
            LET g_out[l_w_ac].* = g_out_t.*
         ELSE
            #FUN-750084
            UPDATE zao_file SET zao04=g_out[l_w_ac].out2
             WHERE zao01 = g_zai.zai01 AND zao02 =l_zao02 AND zao03 = 'V'
               AND zao05 = g_zai.zai05                           
 
            UPDATE zao_file SET zao04=g_out[l_w_ac].out3
             WHERE zao01 = g_zai.zai01 AND zao02 =l_zao02 AND zao03 = 'E'
               AND zao05 = g_zai.zai05
 
            UPDATE zao_file SET zao04 = g_out[l_w_ac].out4
             WHERE zao01 = g_zai.zai01 AND zao02 =l_zao02 AND zao03 = 'T'
               AND zao05 = g_zai.zai05
 
            UPDATE zao_file SET zao04 = g_out[l_w_ac].out5
             WHERE zao01 = g_zai.zai01 AND zao02 =l_zao02 AND zao03 = 'P'
               AND zao05 = g_zai.zai05
            #END FUN-750084
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","zao_file",g_zai.zai01,l_zao02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_out[l_w_ac].* = g_out_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_w_ac = ARR_CURR()
         LET l_w_ac_t = l_w_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_out[l_w_ac].* = g_out_t.*
            END IF
            CLOSE p_query_layout_cl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE p_query_layout_cl
         COMMIT WORK
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
   END INPUT
 
   #TQC-810053
   LET g_zai.zaimodu = g_user
   LET g_zai.zaidate = g_today
   UPDATE zai_file SET zaimodu=g_zai.zaimodu,zaidate=g_zai.zaidate
       WHERE zai01=g_zai.zai01
   DISPLAY BY NAME g_zai.zaimodu,g_zai.zaidate
   #END TQC-810053
 
   CLOSE p_query_layout_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION p_query_process_b_fill()                 #BODY FILL UP
   DEFINE   ls_sql2  STRING,
            l_zab05  LIKE zab_file.zab05
 
     LET g_sql = "SELECT zaj02,zaj03,zaj04,zaj05,zaj06 ",        #FUN-580020
                   "  FROM zaj_file ",
                   " WHERE zaj01 = '",g_zai.zai01 CLIPPED,"' ", 
                   "   AND zaj07 = '",g_zai.zai05 CLIPPED,"' ",  #FUN-750084
                   " ORDER BY zaj02"
 
    PREPARE zaj_pre FROM g_sql           #預備一下
    DECLARE zaj_curs CURSOR FOR zaj_pre
 
    CALL g_zaj.clear()
 
    LET g_cnt = 1
    LET g_process_rec_b = 0
 
    FOREACH zaj_curs INTO g_zaj[g_cnt].*
       LET g_process_rec_b = g_process_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_zaj.deleteElement(g_cnt)
 
    LET g_process_rec_b = g_cnt - 1
    LET g_cnt = 0
 
END FUNCTION
 
#FUNCTION p_query_sql_b_fill()               #BODY FILL UP   #CHI-A60010 mark
FUNCTION p_query_sql_b_fill(p_wc2)           #BODY FILL UP   #CHI-A60010
   DEFINE ls_sql2           STRING,
          l_zab05           LIKE zab_file.zab05
   DEFINE l_datatype        STRING                 #FUN-770079
   DEFINE l_length          STRING                 #FUN-770079
   DEFINE p_wc2             STRING                 #CHI-A60010
 
     LET g_sql = "SELECT zal02,zal03,zal04,zal05,zal09,zal08,zal06 ",    #FUN-580020 #FUN-770079  #FUN-7C0020
                   "  FROM zal_file ",
                   " WHERE zal01 = '",g_zai.zai01 CLIPPED,"' ",
                   "   AND zal07 = '",g_zai.zai05 CLIPPED,"' ",    #FUN-750084
                   "   AND ", p_wc2,                               #CHI-A60010
                   " ORDER BY zal02"
 
    PREPARE zal_pre FROM g_sql           #預備一下
    DECLARE zal_curs CURSOR FOR zal_pre
 
    CALL g_zal.clear()
 
    LET g_cnt = 1
    LET g_sql_rec_b = 0
 
    FOREACH zal_curs INTO g_zal[g_cnt].*
       LET g_sql_rec_b = g_sql_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF cl_null(g_zal[g_cnt].zal08) THEN
          CALL p_query_field_type(g_zal[g_cnt].zal04) RETURNING l_datatype,l_length
          IF cl_null(l_length) OR l_length = 0 THEN
             LET l_length = 20
          END IF  
          LET g_zal[g_cnt].zal08 = l_length
          UPDATE zal_file SET zal08 = g_zal[g_cnt].zal08
           WHERE zal01 = g_zai.zai01   AND zal02 = g_zal[g_cnt].zal02
             AND zal03 = g_zal[g_cnt].zal03 AND zal07 = g_zai.zai05 
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","zal_file",g_zai.zai01,g_zal[g_cnt].zal02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
          END IF
       END IF 
 
       #FUN-7C0020
       IF cl_null(g_zal[g_cnt].zal09) THEN
          LET g_zal[g_cnt].zal09 = 'G'
          UPDATE zal_file SET zal09 = g_zal[g_cnt].zal09
           WHERE zal01 = g_zai.zai01   AND zal02 = g_zal[g_cnt].zal02
             AND zal03 = g_zal[g_cnt].zal03 AND zal07 = g_zai.zai05 
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","zal_file",g_zai.zai01,g_zal[g_cnt].zal02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
          END IF
       END IF
       #END FUN-7C0020
 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_zal.deleteElement(g_cnt)
 
    LET g_sql_rec_b = g_cnt - 1
    LET g_cnt = 0
 
END FUNCTION

#FUNCTION p_query_group_b_fill()               #BODY FILL UP   #CHI-A60010 mark  
FUNCTION p_query_group_b_fill(p_wc2)           #BODY FILL UP   #CHI-A60010
   DEFINE   ls_sql2  STRING,
            l_zab05  LIKE zab_file.zab05
   DEFINE   p_wc2    STRING                  #CHI-A60010
 
     LET g_sql = "SELECT zam02,'','',zam03,zam04,zam05,zam08,zam07,zam06 ",    #FUN-580020
                 "  FROM zam_file ",
                 " WHERE zam01 = '",g_zai.zai01 CLIPPED,"' ",
                 "   AND zam09 = '",g_zai.zai05 CLIPPED,"' ",     #FUN-750084
                 "   AND ", p_wc2,                               #CHI-A60010
                 " ORDER BY zam02"
 
    PREPARE zam_pre FROM g_sql           #預備一下
    DECLARE zam_curs CURSOR FOR zam_pre
 
    CALL g_zam.clear()
 
    LET g_cnt = 1
    LET g_group_rec_b = 0
 
    FOREACH zam_curs INTO g_zam[g_cnt].*
       LET g_group_rec_b = g_group_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT zal04,zal05 INTO g_zam[g_cnt].mzal04,g_zam[g_cnt].mzal05
         FROM zal_file 
        WHERE zal01 = g_zai.zai01  AND zal07 = g_zai.zai05        #FUN-750084
          AND zal03 = g_lang AND zal02 = g_zam[g_cnt].zam02  
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_zam.deleteElement(g_cnt)
 
    LET g_group_rec_b = g_cnt - 1
    LET g_cnt = 0
 
  #LET g_items = p_query_combobox()
  #LET g_group_items = p_query_group_combobox()
  #CALL cl_set_combo_items("mzal04",g_items,g_items)
  #CALL cl_set_combo_items("gzal04",g_group_items,g_group_items)
   IF g_page_choice = "query_group" THEN
     LET g_items = p_query_combobox()
     CALL cl_set_combo_items("mzal04",g_items,g_items)
   END IF
 
 
END FUNCTION

#FUNCTION p_query_field_b_fill()               #BODY FILL UP   #CHI-A60010 mark
FUNCTION p_query_field_b_fill(p_wc2)           #BODY FILL UP   #CHI-A60010
   DEFINE   ls_sql2  STRING,
            l_zab05  LIKE zab_file.zab05
   DEFINE   l_zal08  LIKE zal_file.zal08                       #FUN-7C0020
   DEFINE   p_wc2    STRING                                    #CHI-A60010
 
    CALL p_query_field_change()
 
    LET g_sql = "SELECT zat02,'','',zat03,zat12,zat04,zat05,", #FUN-7C0020
                "       zat06,zat07,zat08,zat09,zat11",        #FUN-580020 #FUN-770079
                "  FROM zat_file ",
                " WHERE zat01 = '",g_zai.zai01 CLIPPED,"' ",
                "   AND zat10 = '",g_zai.zai05 CLIPPED,"' ",   #FUN-750084
                "   AND ", p_wc2,                              #CHI-A60010
                " ORDER BY zat02"
 
    PREPARE zat_pre FROM g_sql           #預備一下
    DECLARE zat_curs CURSOR FOR zat_pre
 
    CALL g_zat.clear()
 
    LET g_cnt = 1
    LET g_field_rec_b = 0
 
    FOREACH zat_curs INTO g_zat[g_cnt].*
       LET g_field_rec_b = g_field_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT zal04,zal05,zal08 INTO g_zat[g_cnt].tzal04,g_zat[g_cnt].tzal05,l_zal08  #FUN-7C0020
         FROM zal_file 
        WHERE zal01 = g_zai.zai01  AND zal07 = g_zai.zai05       #FUN-750084
          AND zal03 = g_lang AND zal02 = g_zat[g_cnt].zat02  
       IF cl_null(g_zat[g_cnt].tzal04) THEN
          SELECT unique zal04 INTO g_zat[g_cnt].tzal04 FROM zal_file 
           WHERE zal01 = g_zai.zai01 AND zal02 = g_zat[g_cnt].zat02  
             AND zal07 = g_zai.zai05                             #FUN-750084
       END IF
       #FUN-7C0020
       IF cl_null(g_zat[g_cnt].zat12) OR g_zat[g_cnt].zat12=0 THEN
          
          LET g_zat[g_cnt].zat12 = p_query_per_len(l_zal08)   #TQC-810053
          UPDATE zat_file SET zat12 = g_zat[g_cnt].zat12
           WHERE zat01 = g_zai.zai01   AND zat02 = g_zat[g_cnt].zat02
             AND zat10 = g_zai.zai05 
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","zat_file",g_zai.zai01,g_zat[g_cnt].zat02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
          END IF
       END IF
       #END FUN-7C0020
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_zat.deleteElement(g_cnt)
 
    LET g_field_rec_b = g_cnt - 1
    LET g_cnt = 0
 
    IF g_page_choice = "query_field" THEN
       IF g_sum_field.getLength() = 0 THEN
          CALL p_query_sum_combobox()
       END IF
    END IF
END FUNCTION

#FUNCTION p_query_sum_b_fill()               #BODY FILL UP   #CHI-A60010 mark 
FUNCTION p_query_sum_b_fill(p_wc2)           #BODY FILL UP   #CHI-A60010
   DEFINE   ls_sql2  STRING,
            l_zab05  LIKE zab_file.zab05
   DEFINE   l_i      LIKE type_file.num10
   DEFINE   p_wc2    STRING                  #CHI-A60010
 
     LET g_sql = "SELECT zan02,'','',zan03,zan07,zan04,zan05,'','',zan06 ",    #FUN-580020
                 "  FROM zan_file ",
                 " WHERE zan01 = '",g_zai.zai01 CLIPPED,"' ",
                 "   AND zan08 = '",g_zai.zai05 CLIPPED,"' ",    #FUN-750084
                 "   AND ", p_wc2,                               #CHI-A60010
                 " ORDER BY zan02"
 
    PREPARE zan_pre FROM g_sql           #預備一下
    DECLARE zan_curs CURSOR FOR zan_pre
 
    CALL g_zan.clear()
 
    LET g_cnt = 1
    LET g_sum_rec_b = 0
 
    FOREACH zan_curs INTO g_zan[g_cnt].*
       LET g_sum_rec_b = g_sum_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       SELECT zal04,zal05 INTO g_zan[g_cnt].nzal04,g_zan[g_cnt].nzal05
         FROM zal_file 
        WHERE zal01 = g_zai.zai01  AND zal07 = g_zai.zai05       #FUN-750084
          AND zal03 = g_lang AND zal02 = g_zan[g_cnt].zan02  
       SELECT zal04,zal05 INTO g_zan[g_cnt].gzal04,g_zan[g_cnt].gzal05
         FROM zal_file 
        WHERE zal01 = g_zai.zai01  AND zal07 = g_zai.zai05       #FUN-750084
          AND zal03 = g_lang AND zal02 = g_zan[g_cnt].zan05  
 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_zan.deleteElement(g_cnt)
 
    LET g_sum_rec_b = g_cnt - 1
    LET g_cnt = 0
    IF g_page_choice = "query_sum" THEN
       LET g_group_items = p_query_group_combobox()
       IF g_sum_field.getLength() = 0 THEN
          CALL p_query_sum_combobox()
       END IF
       LET g_sum_items = ""
       FOR l_i = 1 TO g_sum_field.getLength()
           IF NOT cl_null(g_sum_field[l_i]) THEN
             IF cl_null(g_sum_items) THEN
                LET g_sum_items = g_sum_field[l_i] CLIPPED
             ELSE
                LET g_sum_items = g_sum_items,",",g_sum_field[l_i] CLIPPED
             END IF
           END IF
       END FOR
       LET g_sum_items = g_sum_items.toLowerCase()
       CALL cl_set_combo_items("gzal04",g_group_items,g_group_items)
       CALL cl_set_combo_items("nzal04",g_sum_items,g_sum_items)
    END IF
 
END FUNCTION

FUNCTION p_query_layout_b_fill()               #BODY FILL UP
   DEFINE   ls_sql2  STRING,
            l_zab05  LIKE zab_file.zab05
   DEFINE   l_zao02  LIKE zao_file.zao02
   DEFINE   l_zao03  LIKE zao_file.zao03
   DEFINE   l_zao04  LIKE zao_file.zao04
   DEFINE   l_i      LIKE type_file.num10 
   DEFINE   l_cnt    LIKE type_file.num10 
 
    CALL g_out.clear()
 
    IF cl_null(g_zai.zai01) THEN
       RETURN
    END IF
 
    FOR l_i = 1 TO 8 
        LET g_out[l_i].out1=l_i
        LET g_out[l_i].out2='N'
        LET g_out[l_i].out3='N'
        LET g_out[l_i].out4='N'
        LET g_out[l_i].out5='N'
       #INSERT INTO zao_file(zao01,zao02,zao03,zao04)
       #       VALUES(g_zai.zai01,l_i,'V',g_out[l_i].out2) 
       #INSERT INTO zao_file(zao01,zao02,zao03,zao04)
       #       VALUES(g_zai.zai01,l_i,'E',g_out[l_i].out3) 
       #INSERT INTO zao_file(zao01,zao02,zao03,zao04)
       #       VALUES(g_zai.zai01,l_i,'T',g_out[l_i].out4) 
       #INSERT INTO zao_file(zao01,zao02,zao03,zao04)
       #       VALUES(g_zai.zai01,l_i,'V',g_out[l_i].out5) 
       #IF SQLCA.sqlcode THEN
       #   CALL cl_err3("ins","zai_file",g_zai.zai01,'',SQLCA.sqlcode,"","",0)
       #   RETURN
       #END IF
    END FOR
 
    LET g_sql = "SELECT zao02,zao03,zao04 FROM zao_file ",
                " WHERE zao01 = '",g_zai.zai01 CLIPPED,"' ",
                "   AND zao05 = '",g_zai.zai05 CLIPPED,"' ",    #FUN-750084
                " ORDER BY zao02"
    
    PREPARE zao_pre FROM g_sql           #預備一下
    DECLARE zao_curs CURSOR FOR zao_pre
    
    FOREACH zao_curs INTO l_zao02,l_zao03,l_zao04
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CASE l_zao03 
          WHEN 'V' #View
             LET g_out[l_zao02].out2 = l_zao04
          WHEN 'E' #Excel
             LET g_out[l_zao02].out3 = l_zao04
          WHEN 'T' #Text
             LET g_out[l_zao02].out4 = l_zao04
          WHEN 'P' #PDF
             LET g_out[l_zao02].out5 = l_zao04
       END CASE
    END FOREACH
 
    LET g_layout_rec_b = 8
 
END FUNCTION
 
FUNCTION p_query_process_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN 
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_zaj TO s_zaj.* ATTRIBUTE(COUNT=g_process_rec_b,UNBUFFERED)
      BEFORE DISPLAY
          CALL cl_navigator_setting(g_curs_index, g_row_count) #No.FUN-580092 HCN
 
      BEFORE ROW
         LET l_w_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query_sql                        #Select SQL
         LET g_page_choice = "query_sql"
         EXIT DISPLAY
 
      ON ACTION query_field                      #Field
         LET g_page_choice = "query_field"
         EXIT DISPLAY
 
      ON ACTION query_auth                       #Auth
         LET g_page_choice = "query_auth"
         EXIT DISPLAY
 
      ON ACTION query_group                      #Group
         LET g_page_choice = "query_group"
         EXIT DISPLAY
 
      ON ACTION query_sum                        #Sum
         LET g_page_choice = "query_sum"
         EXIT DISPLAY
 
      ON ACTION query_layout                     #Layout
         LET g_page_choice = "query_layout"
         EXIT DISPLAY
 
      ON ACTION database_query                   # 資料庫查詢
         LET g_action_choice='database_query'
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                 #No.FUN-550037 hmf
         CALL cl_set_combo_lang("zal03")         #FUN-7C0020
         CALL p_query_title()                    #FUN-7C0020
         EXIT DISPLAY
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete                           # R.取消
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION detail                           # B.單身
         LET g_action_choice="detail"
         LET l_w_ac = 1
         EXIT DISPLAY
      ON ACTION modify                           # Q.修改
         LET g_action_choice='modify'
         EXIT DISPLAY
 
      #FUN-750084
      ON ACTION reproduce                        # C.複製
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      #END FUN-750084
 
      ON ACTION output                           # O.列印
         LET g_action_choice='output'
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_w_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first                            # 第一筆
         CALL p_query_fetch('F')
          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
          IF g_process_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
          END IF
          ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous                         # P.上筆
         CALL p_query_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_process_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump                             # 指定筆
         CALL p_query_fetch('/')
          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_process_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next                             # N.下筆
         CALL p_query_fetch('N')
          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_process_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last                             # 最終筆
         CALL p_query_fetch('L')
          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_process_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controls                            #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_query_sql_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_zal TO s_zal.* ATTRIBUTE(COUNT=g_sql_rec_b,UNBUFFERED)
      BEFORE DISPLAY
          CALL cl_navigator_setting(g_curs_index, g_row_count) #No.FUN-580092 HCN
 
      BEFORE ROW
         LET l_w_ac = ARR_CURR()
         CALL cl_show_fld_cont()                 #No.FUN-550037 hmf
 
      ON ACTION database_query                   # 資料庫查詢
         LET g_action_choice='database_query'
         EXIT DISPLAY
 
      ON ACTION sql_command                      #SQL語法
         LET g_action_choice = "sql_command"
         EXIT DISPLAY 
 
     #ON ACTION sql_wizard                       #SQL自動精靈
     #   LET g_action_choice = "sql_wizard"
     #   EXIT DISPLAY
 
      ON ACTION query_process                    #Select SQL
         LET g_page_choice = "query_process"
         EXIT DISPLAY
 
      ON ACTION query_field                      #Field
         LET g_page_choice = "query_field"
         EXIT DISPLAY
 
      ON ACTION query_auth                       #Auth
         LET g_page_choice = "query_auth"
         EXIT DISPLAY
 
      ON ACTION query_group                      #Group
         LET g_page_choice = "query_group"
         EXIT DISPLAY
 
      ON ACTION query_sum                        #Sum
         LET g_page_choice = "query_sum"
         EXIT DISPLAY
 
      ON ACTION query_layout                     #Layout
         LET g_page_choice = "query_layout"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                 #No.FUN-550037 hmf
         CALL cl_set_combo_lang("zal03")         #FUN-7C0020
         CALL p_query_title()                    #FUN-7C0020
         EXIT DISPLAY
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete                           # R.取消
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION detail                           # B.單身
         LET g_action_choice="detail"
         LET l_w_ac = 1
         EXIT DISPLAY
      ON ACTION modify                           # Q.修改
         LET g_action_choice='modify'
         EXIT DISPLAY
 
      #FUN-750084
      ON ACTION reproduce                        # C.複製
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      #END FUN-750084
 
      ON ACTION output                           # O.列印
         LET g_action_choice='output'
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_w_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION first                            # 第一筆
         CALL p_query_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_sql_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous                         # P.上筆
         CALL p_query_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_sql_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump                             # 指定筆
         CALL p_query_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_sql_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next                             # N.下筆
         CALL p_query_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_sql_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last                             # 最終筆
         CALL p_query_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_sql_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
  	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      #FUN-8B0089--start--add--
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #FUN-8B0089--end--add--
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_query_field_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_zat TO s_zat.* ATTRIBUTE(COUNT=g_field_rec_b,UNBUFFERED)
      BEFORE DISPLAY
          CALL cl_navigator_setting(g_curs_index, g_row_count) #No.FUN-580092 HCN
 
      BEFORE ROW
         LET l_w_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query_process                    #Process
         LET g_page_choice = "query_process"
         EXIT DISPLAY
 
      ON ACTION query_sql                        #Select SQL
         LET g_page_choice = "query_sql"
         EXIT DISPLAY
 
      ON ACTION query_auth                       #Auth
         LET g_page_choice = "query_auth"
         EXIT DISPLAY
 
      ON ACTION query_group                      #Group
         LET g_page_choice = "query_group"
         EXIT DISPLAY
 
      ON ACTION query_sum                        #Sum
         LET g_page_choice = "query_sum"
         EXIT DISPLAY
 
      ON ACTION query_layout                     #Layout
         LET g_page_choice = "query_layout"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                 #No.FUN-550037 hmf
         CALL cl_set_combo_lang("zal03")         #FUN-7C0020
         CALL p_query_title()                    #FUN-7C0020
         EXIT DISPLAY
 
      ON ACTION database_query                   # 資料庫查詢
         LET g_action_choice='database_query'
         EXIT DISPLAY
      ON ACTION insert                           # A.輸入
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete                           # R.取消
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION detail                           # B.單身
         LET g_action_choice="detail"
         LET l_w_ac = 1
         EXIT DISPLAY
      ON ACTION modify                           # Q.修改
         LET g_action_choice='modify'
         EXIT DISPLAY
 
      #FUN-750084
      ON ACTION reproduce                        # C.複製
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      #END FUN-750084
 
      ON ACTION output                           # O.列印
         LET g_action_choice='output'
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_w_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first                            # 第一筆
         CALL p_query_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_field_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous                         # P.上筆
         CALL p_query_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_field_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump                             # 指定筆
         CALL p_query_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_field_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
  	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next                             # N.下筆
         CALL p_query_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_field_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last                             # 最終筆
         CALL p_query_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_field_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
 	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      #FUN-8B0089--start--add--
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #FUN-8B0089--end--add--
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_query_group_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN  
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_zam TO s_zam.* ATTRIBUTE(COUNT=g_group_rec_b,UNBUFFERED)
      BEFORE DISPLAY
          CALL cl_navigator_setting(g_curs_index, g_row_count) #No.FUN-580092 HCN
 
      BEFORE ROW
         LET l_w_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query_process                    #Process
         LET g_page_choice = "query_process"
         EXIT DISPLAY
 
      ON ACTION query_sql                        #Select SQL
         LET g_page_choice = "query_sql"
         EXIT DISPLAY
 
      ON ACTION query_field                      #Field
         LET g_page_choice = "query_field"
         EXIT DISPLAY
 
      ON ACTION query_auth                       #Auth
         LET g_page_choice = "query_auth"
         EXIT DISPLAY
 
      ON ACTION query_sum                        #Sum
         LET g_page_choice = "query_sum"
         EXIT DISPLAY
 
      ON ACTION query_layout                     #Layout
         LET g_page_choice = "query_layout"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                 #No.FUN-550037 hmf
         CALL cl_set_combo_lang("zal03")         #FUN-7C0020
         CALL p_query_title()                    #FUN-7C0020
         EXIT DISPLAY
 
      ON ACTION database_query                   # 資料庫查詢
         LET g_action_choice='database_query'
         EXIT DISPLAY
      ON ACTION insert                           # A.輸入
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete                           # R.取消
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION detail                           # B.單身
         LET g_action_choice="detail"
         LET l_w_ac = 1
         EXIT DISPLAY
      ON ACTION modify                           # Q.修改
         LET g_action_choice='modify'
         EXIT DISPLAY
 
      #FUN-750084
      ON ACTION reproduce                        # C.複製
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      #END FUN-750084
 
      ON ACTION output                           # O.列印
         LET g_action_choice='output'
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_w_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION first                            # 第一筆
         CALL p_query_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_group_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous                         # P.上筆
         CALL p_query_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_group_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump                             # 指定筆
         CALL p_query_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_group_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
  	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next                             # N.下筆
         CALL p_query_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_group_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last                             # 最終筆
         CALL p_query_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_group_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
 	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      #FUN-8B0089--start--add--
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #FUN-8B0089--end--add--
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_query_sum_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_zan TO s_zan.* ATTRIBUTE(COUNT=g_sum_rec_b,UNBUFFERED)
      BEFORE DISPLAY
          CALL cl_navigator_setting(g_curs_index, g_row_count) #No.FUN-580092 HCN
 
      BEFORE ROW
         LET l_w_ac = ARR_CURR()
         CALL cl_show_fld_cont()                 #No.FUN-550037 hmf
 
      ON ACTION query_process                    #Process
         LET g_page_choice = "query_process"
         EXIT DISPLAY
 
      ON ACTION query_sql                        #Select SQL
         LET g_page_choice = "query_sql"
         EXIT DISPLAY
 
      ON ACTION query_field                      #Field
         LET g_page_choice = "query_field"
         EXIT DISPLAY
 
      ON ACTION query_auth                       #Auth
         LET g_page_choice = "query_auth"
         EXIT DISPLAY
 
      ON ACTION query_group                      #Group
         LET g_page_choice = "query_group"
         EXIT DISPLAY
 
      ON ACTION query_layout                     #Layout
         LET g_page_choice = "query_layout"
         EXIT DISPLAY
 
      ON ACTION database_query                   # 資料庫查詢
         LET g_action_choice='database_query'
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                 #No.FUN-550037 hmf
         CALL cl_set_combo_lang("zal03")         #FUN-7C0020
         CALL p_query_title()                    #FUN-7C0020
         EXIT DISPLAY
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete                           # R.取消
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION detail                           # B.單身
         LET g_action_choice="detail"
         LET l_w_ac = 1
         EXIT DISPLAY
      ON ACTION modify                           # Q.修改
         LET g_action_choice='modify'
         EXIT DISPLAY
 
      #FUN-750084
      ON ACTION reproduce                        # C.複製
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      #END FUN-750084
 
      ON ACTION output                           # O.列印
         LET g_action_choice='output'
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_w_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION first                            # 第一筆
         CALL p_query_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_sum_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous                         # P.上筆
         CALL p_query_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_sum_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump                             # 指定筆
         CALL p_query_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_sum_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next                             # N.下筆
         CALL p_query_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_sum_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last                             # 最終筆
         CALL p_query_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_sum_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      #FUN-8B0089--start--add--
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #FUN-8B0089--end--add--
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_query_layout_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_out TO s_out.* ATTRIBUTE(COUNT=g_layout_rec_b,UNBUFFERED)
      BEFORE DISPLAY
          CALL cl_navigator_setting(g_curs_index, g_row_count) #No.FUN-580092 HCN
 
      BEFORE ROW
         LET l_w_ac = ARR_CURR()
         CALL cl_show_fld_cont()                 #No.FUN-550037 hmf
 
      ON ACTION database_query                   # 資料庫查詢
         LET g_action_choice='database_query'
         EXIT DISPLAY
 
      ON ACTION layout_output                    #版面設定
         LET g_action_choice = "layout_output"
         EXIT DISPLAY
 
      ON ACTION query_process                    #Process
         LET g_page_choice = "query_process"
         EXIT DISPLAY
 
      ON ACTION query_sql                        #Select SQL
         LET g_page_choice = "query_sql"
         EXIT DISPLAY
 
      ON ACTION query_field                      #Field
         LET g_page_choice = "query_field"
         EXIT DISPLAY
 
      ON ACTION query_auth                       #Auth
         LET g_page_choice = "query_auth"
         EXIT DISPLAY
 
      ON ACTION query_group                      #Group
         LET g_page_choice = "query_group"
         EXIT DISPLAY
 
      ON ACTION query_sum                        #Sum
         LET g_page_choice = "query_sum"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                 #No.FUN-550037 hmf
         CALL cl_set_combo_lang("zal03")         #FUN-7C0020
         CALL p_query_title()                    #FUN-7C0020
         EXIT DISPLAY
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete                           # R.取消
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION detail                           # B.單身
         LET g_action_choice="detail"
         LET l_w_ac = 1
         EXIT DISPLAY
      ON ACTION modify                           # Q.修改
         LET g_action_choice='modify'
         EXIT DISPLAY
 
      #FUN-750084
      ON ACTION reproduce                        # C.複製
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      #END FUN-750084
 
      ON ACTION output                           # O.列印
         LET g_action_choice='output'
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_w_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION first                            # 第一筆
         CALL p_query_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_layout_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous                         # P.上筆
         CALL p_query_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_layout_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump                             # 指定筆
         CALL p_query_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_layout_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next                             # N.下筆
         CALL p_query_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_layout_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last                             # 最終筆
         CALL p_query_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_layout_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_query_auth_menu()                     # 權限設定
 
   LET g_action_choice = " "
   MENU ""
      ON ACTION query_sql                        #Select SQL
         LET g_page_choice = "query_sql"
         EXIT MENU
 
      ON ACTION query_field                      #Field
         LET g_page_choice = "query_field"
         EXIT MENU
 
      ON ACTION query_group                      #Group
         LET g_page_choice = "query_group"
         EXIT MENU
 
      ON ACTION query_sum                        #Sum
         LET g_page_choice = "query_sum"
         EXIT MENU
 
      ON ACTION query_layout                     #Layout
         LET g_page_choice = "query_layout"
         EXIT MENU
 
      ON ACTION database_query                   # 資料庫查詢
         LET g_action_choice='database_query'
         EXIT MENU
 
      ON ACTION query_auth_i
         LET g_action_choice = "query_auth_i"
         EXIT MENU
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                 #No.FUN-550037 hmf
         CALL cl_set_combo_lang("zal03")         #FUN-7C0020
         CALL p_query_title()                    #FUN-7C0020
         EXIT MENU
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice="insert"
         EXIT MENU
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT MENU
 
      ON ACTION delete                           # R.取消
         LET g_action_choice="delete"
         EXIT MENU
 
      ON ACTION modify                           # Q.修改
         LET g_action_choice='modify'
         EXIT MENU
 
      #FUN-750084
      ON ACTION reproduce                        # C.複製
         LET g_action_choice="reproduce"
         EXIT MENU
      #END FUN-750084
 
      ON ACTION output                           # O.列印
         LET g_action_choice='output'
         EXIT MENU
 
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT MENU
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT MENU
 
      ON ACTION first                            # 第一筆
         CALL p_query_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
 
      ON ACTION previous                         # P.上筆
         CALL p_query_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
 
      ON ACTION jump                             # 指定筆
         CALL p_query_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
 
      ON ACTION next                             # N.下筆
         CALL p_query_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
 
      ON ACTION last                             # 最終筆
         CALL p_query_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
 
      ON ACTION controls                            #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT MENU
 
      #TQC-810053
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
         LET INT_FLAG=FALSE       
         LET g_action_choice = "exit"
         EXIT MENU
      #END TQC-810053
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE MENU
 
   END MENU
 
END FUNCTION
 
FUNCTION query_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680136  VARCHAR(1)
 
   IF (NOT g_before_input_done) OR INFIELD(zai01) THEN
      CALL cl_set_comp_entry("zai01",TRUE) 
   END IF
   #FUN-750084
   IF (NOT g_before_input_done) OR INFIELD(zai05) THEN
      CALL cl_set_comp_entry("zai05",TRUE) 
   END IF
   #END FUN-750084
END FUNCTION
 
FUNCTION query_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680136  VARCHAR(1)
 
   IF (NOT g_before_input_done) OR INFIELD(zai01) THEN
      IF p_cmd = 'u' THEN
         CALL cl_set_comp_entry("zai01",FALSE)
      END IF 
   END IF
   #FUN-750084
   IF (NOT g_before_input_done) OR INFIELD(zai05) THEN
      IF p_cmd = 'u' THEN
         CALL cl_set_comp_entry("zai05",FALSE) 
      END IF
   END IF
   #END FUN-750084
END FUNCTION
 
FUNCTION p_query_b_display()
 
   DISPLAY ARRAY g_zaj TO s_zaj.* ATTRIBUTE(COUNT=g_process_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY 
   DISPLAY ARRAY g_zal TO s_zal.* ATTRIBUTE(COUNT=g_sql_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY 
   DISPLAY ARRAY g_zat TO s_zat.* ATTRIBUTE(COUNT=g_field_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY 
   DISPLAY ARRAY g_zam TO s_zam.* ATTRIBUTE(COUNT=g_group_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY 
   DISPLAY ARRAY g_zan TO s_zan.* ATTRIBUTE(COUNT=g_sum_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY 
   DISPLAY ARRAY g_out TO s_out.* ATTRIBUTE(COUNT=g_layout_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY 
 
END FUNCTION
 
FUNCTION p_query_sql_i()
DEFINE l_cnt       LIKE type_file.num10 
DEFINE p_cmd       LIKE type_file.chr1    # a:輸入 u:更改 #No.FUN-680135 VARCHAR(1)
DEFINE l_zak02_o   LIKE zak_file.zak02
DEFINE l_text      STRING
DEFINE l_str       STRING
DEFINE l_str2      STRING
DEFINE l_sql       STRING
DEFINE l_tmp       STRING
DEFINE l_execmd    STRING
DEFINE l_tok       base.StringTokenizer 
DEFINE l_start     LIKE type_file.num5       #No.FUN-680135 SMALLINT
DEFINE l_end       LIKE type_file.num5       #No.FUN-680135 SMALLINT
DEFINE l_feld_tmp  LIKE type_file.chr1000    #No.FUN-680135 VARCHAR(55)
DEFINE lw_w        ui.window
DEFINE ln_w        om.DomNode
DEFINE ln_page     om.DomNode
DEFINE ls_pages    om.NodeList
DEFINE buf         base.StringBuffer
DEFINE l_field     RECORD
        field001, field002, field003, field004, field005, field006, field007,
        field008, field009, field010, field011, field012, field013, field014,
        field015, field016, field017, field018, field019, field020, field021,
        field022, field023, field024, field025, field026, field027, field028,
        field029, field030, field031, field032, field033, field034, field035,
        field036, field037, field038, field039, field040, field041, field042,
        field043, field044, field045, field046, field047, field048, field049,
        field050, field051, field052, field053, field054, field055, field056,
        field057, field058, field059, field060, field061, field062, field063,
        field064, field065, field066, field067, field068, field069, field070,
        field071, field072, field073, field074, field075, field076, field077,
        field078, field079, field080, field081, field082, field083, field084,
        field085, field086, field087, field088, field089, field090, field091,
        field092, field093, field094, field095, field096, field097, field098,
        field099, field100  LIKE gaq_file.gaq03     #No.FUN-680135 VARCHAR(255)
                  END RECORD
DEFINE l_i         LIKE type_file.num5              #FUN-770079
DEFINE l_p         LIKE type_file.num5              #FUN-770079 
DEFINE l_arg       STRING                           #FUN-770079
 
   IF cl_null(g_zai.zai01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   IF g_action_choice = 'insert' THEN
      #輸入 SQL Wizard 時，畫面應維持在 SQL page
      CALL ui.interface.refresh()
      LET lw_w=ui.window.getcurrent()
      LET ln_w = lw_w.getNode()
      LET ls_pages = ln_w.selectByTagName("Page")
      #FUN-770079
      #先隱藏 "欄位設定~輸出格式"等 page, 再顯示
      FOR l_i = 5 TO 9    
          LET ln_page = ls_pages.item(l_i)
          CALL ln_page.setAttribute("hidden", 1)
      END FOR
      CALL ui.interface.refresh()
      FOR l_i = 5 TO 9
          LET ln_page = ls_pages.item(l_i)
          CALL ln_page.setAttribute("hidden", 0)
      END FOR
      #END FUN-770079
   END IF
 
   DISPLAY g_zak.zak02 TO zak02
   LET g_zak_t.zak02 = g_zak.zak02
   LET l_zak02_o = g_zak.zak02
 
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM zak_file 
    WHERE zak01 = g_zai.zai01 AND zak07 = g_zai.zai05       #FUN-750084
   IF l_cnt > 0 THEN
       BEGIN WORK
       OPEN zak_cl USING g_zai.zai01,g_zai.zai05            #FUN-750084
       IF STATUS THEN
          CALL cl_err("DATA LOCK:",STATUS,1)
          CLOSE zak_cl
          ROLLBACK WORK
          RETURN
       END IF
       FETCH zak_cl INTO g_zak.*
       IF SQLCA.sqlcode THEN
          CALL cl_err("zak01 LOCK:",SQLCA.sqlcode,1)
          CLOSE zak_cl
          ROLLBACK WORK
          RETURN
       END IF
   END IF
 
   INPUT g_zak.zak02 WITHOUT DEFAULTS FROM zak02
      BEFORE INPUT 
        NEXT FIELD zak02
 
      BEFORE FIELD zak02 
        IF g_zak.zak02 IS NULL AND g_action_choice = 'insert' THEN
           CALL p_query_wizard('a')                             # SQL 自動精靈
           LET g_action_choice = ''
           DISPLAY g_zak.zak02 TO zak02
           LET g_zak_t.zak02 = g_zak.zak02
        END IF
        IF g_zak.zak06 != 'Y' OR cl_null(g_zak.zak06) THEN
           CALL cl_set_act_visible("sql_wizard", FALSE)
        END IF
 
      AFTER FIELD zak02
        IF cl_null(g_zak.zak02) OR g_zak.zak02 CLIPPED = "" THEN
            CALL cl_err('','mfg2726',0)
            NEXT FIELD zak02
        END IF 
        IF g_zak_t.zak02 != g_zak.zak02 AND g_zak.zak06="Y" THEN
           IF NOT cl_confirm('azz-251') THEN 
              NEXT FIELD zak02
           ELSE
              LET g_zak.zak06 = "N"
           END IF
        END IF
        IF NOT p_query_chk_arg() THEN
            NEXT FIELD zak02
        END IF
        LET buf = base.StringBuffer.create()
        CALL buf.append(g_zak.zak02 CLIPPED)
        CALL buf.replace( "\"","'", 0)
        LET g_zak.zak02  = buf.toString()
 
       #LET l_str= p_query_cut_spaces(g_zak.zak02)
        LET l_str= g_zak.zak02 CLIPPED                           #FUN-810062
        LET l_end = l_str.getIndexOf(';',1)
        IF l_end != 0 THEN
           LET l_str=l_str.subString(1,l_end-1)
        END IF
        LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,"\n","",TRUE)
        LET l_text = NULL
        WHILE l_tok.hasMoreTokens()
              LET l_tmp=l_tok.nextToken()
              IF l_text is null THEN
                 LET l_text = l_tmp.trim()
              ELSE
                 LET l_text = l_text CLIPPED,' ',l_tmp.trim()
              END IF
        END WHILE
        LET l_tmp=l_text
        LET l_execmd=l_tmp
 
        LET l_execmd = l_execmd.toLowerCase()
        LET l_start = l_execmd.getIndexOf('select',1)
        IF l_start = 0 THEN
           CALL cl_err('','azz-254',0)
           NEXT FIELD zak02
        END IF
 
        #FUN-770079 
        #若 SQL 語法裡有 arg (參數)時，將 arg 替換成 "1=1"
        LET l_str = l_execmd
        FOR l_i = 1 TO 50
            LET l_arg = "arg",l_i USING '<<<<<'
            LET l_p  = l_str.getIndexOf(l_arg,1)
            IF l_p > 0 THEN
               LET l_str = l_str.subString(1,l_p-1),"1=1",
                           l_str.subString(l_p+l_arg.getLength(),l_str.getLength())   
            END IF
        END FOR
        LET l_execmd = l_str
        #END FUN-770079 
 
        PREPARE sql_pre1 FROM l_execmd
        IF SQLCA.SQLCODE THEN
           CALL cl_err("prepare:",sqlca.sqlcode,1) 
           NEXT FIELD zak02
        END IF
 
        DECLARE sql_cur1 CURSOR FOR sql_pre1
        IF SQLCA.SQLCODE THEN
           CALL cl_err("DECLARE sql_cur1:",sqlca.sqlcode,1) 
           NEXT FIELD zak02
        END IF
 
        FOREACH sql_cur1 INTO l_field.*
           EXIT FOREACH
        END FOREACH
        IF SQLCA.SQLCODE THEN
           CALL cl_err("prepare:",sqlca.sqlcode,1) 
           NEXT FIELD zak02
        END IF
 
      ON ACTION sql_wizard
         DISPLAY g_zak.zak02 TO zak02
         CALL p_query_wizard('u')               # SQL 自動精靈
         DISPLAY g_zak.zak02 TO zak02
         LET g_zak_t.zak02 = g_zak.zak02
         IF g_zak.zak06 != 'Y' OR cl_null(g_zak.zak06) THEN
            CALL cl_set_act_visible("sql_wizard", FALSE)
         END IF
 
         
      ON ACTION controlf                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
   END INPUT 
   CALL cl_set_act_visible("sql_wizard", TRUE)
 
   IF INT_FLAG THEN
      LET g_zak.zak02 = l_zak02_o
      DISPLAY g_zak.zak02 TO zak02
      LET INT_FLAG = 0
      RETURN
   END IF
 
   LET l_execmd = l_execmd.toLowerCase()
   LET l_start = l_execmd.getIndexOf('select',1)
   LET l_end   = l_execmd.getIndexOf('from',1)
   LET l_str=l_tmp.subString(l_start+7,l_end-2)
   LET g_zak.zak04 = l_str 
   
   LET l_str2 = ""
   LET l_start = l_execmd.getIndexOf('from',1)
   LET l_end   = l_execmd.getIndexOf('where',1)
   IF l_end=0 THEN
      LET l_end   = l_execmd.getIndexOf('group',1)
      IF l_end=0 THEN
         LET l_end   = l_execmd.getIndexOf('order',1)
         IF l_end=0 THEN
            LET l_end=l_execmd.getLength()
            LET l_str  = l_tmp.subString(l_start+5,l_end)
         ELSE
            LET l_str  = l_tmp.subString(l_start+5,l_end-2)
            LET l_str2 = l_tmp.subString(l_end+6,l_execmd.getLength())
         END IF
      ELSE
         LET l_str=l_tmp.subString(l_start+5,l_end-2)
         LET l_str2 = l_tmp.subString(l_end+6,l_execmd.getLength())
      END IF
   ELSE
      LET l_str=l_tmp.subString(l_start+5,l_end-2)
      LET l_str2 = l_tmp.subString(l_end+6,l_execmd.getLength())
   END IF
   LET l_str=l_str.trim()
   LET g_zak.zak03 = l_str
 
   LET l_str2=l_str2.trim()
   LET g_zak.zak05 = l_str2
 
   IF l_cnt = 0 THEN
      #FUN-750084
      INSERT INTO zak_file(zak01,zak02,zak03,zak04,zak05,zak06,zak07)
             VALUES(g_zai.zai01,g_zak.zak02,g_zak.zak03,g_zak.zak04,g_zak.zak05,g_zak.zak06,g_zai.zai05) 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","zak_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","",0)
      #END FUN-750084
         RETURN
      END IF
      LET p_cmd = 'a'
   ELSE
      UPDATE zak_file set zak02 = g_zak.zak02, zak06 = g_zak.zak06
       WHERE zak01 = g_zai.zai01  AND zak07 = g_zai.zai05          #FUN-750084
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","zak_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","",0) #FUN-750084
         CLOSE zak_cl
         ROLLBACK WORK
         RETURN
      END IF
      LET p_cmd = 'u'
   END IF
   IF g_zak.zak06 = 'N' THEN
      #FUN-750084
      DELETE FROM zaq_file WHERE zaq01=g_zai.zai01 AND zaq05=g_zai.zai05  
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zaq_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         IF p_cmd = 'u' THEN
            CLOSE zak_cl
            ROLLBACK WORK
         END IF
         RETURN
      END IF
      DELETE FROM zar_file WHERE zar01=g_zai.zai01 AND zar05=g_zai.zai05
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zar_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         IF p_cmd = 'u' THEN
            CLOSE zak_cl
            ROLLBACK WORK
         END IF
         RETURN
      END IF
      DELETE FROM zas_file WHERE zas01=g_zai.zai01 AND zas11=g_zai.zai05
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zas_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         IF p_cmd = 'u' THEN
            CLOSE zak_cl
            ROLLBACK WORK
         END IF
         RETURN
      END IF
      #END FUN-750084
   END IF
 
   #TQC-810053
   LET g_zai.zaimodu = g_user
   LET g_zai.zaidate = g_today
   UPDATE zai_file SET zaimodu=g_zai.zaimodu,zaidate=g_zai.zaidate
       WHERE zai01=g_zai.zai01
   DISPLAY BY NAME g_zai.zaimodu,g_zai.zaidate
   #END TQC-810053
 
   COMMIT WORK
 
   CALL p_query_parse_sql(p_cmd)
   CALL p_query_field_change()
   CALL p_query_sum_combobox()
   CALL p_query_zao()                                #TQC-810053
   CALL p_query_zap()                                #TQC-810053
 
END FUNCTION
 
FUNCTION p_query_auth_i()
DEFINE l_cnt    LIKE type_file.num10 
DEFINE l_str    STRING
DEFINE l_tab    STRING
DEFINE buf      base.StringBuffer
DEFINE l_tok    base.StringTokenizer
DEFINE l_status LIKE type_file.num5
 
   IF cl_null(g_zai.zai01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   #FUN-750084
   SELECT COUNT(*) INTO l_cnt FROM zau_file 
    WHERE  zau01 = g_zai.zai01 AND zau04 = g_zai.zai05       
   IF l_cnt = 0 THEN
      INSERT INTO zau_file(zau01,zau02,zau03,zau04)
             VALUES(g_zai.zai01,'','',g_zai.zai05) 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","zau_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","",0)
         RETURN
      END IF
   END IF  
   #END FUN-750084
 
   LET g_zau_t.* = g_zau.*
 
  #LET l_str = p_query_cut_spaces(g_zak.zak03)
   LET l_str= g_zak.zak03 CLIPPED                           #FUN-810062
   LET l_str = l_str.toUpperCase()
   LET buf = base.StringBuffer.create()
   CALL buf.append(l_str)
   CALL buf.replace("OUTER ","", 0)
   CALL buf.replace(" ","", 0)
   LET l_str  = buf.toString()
   LET l_str = l_str.toLowerCase()
 
   INPUT g_zau.zau02,g_zau.zau03 WITHOUT DEFAULTS FROM zau02,zau03
 
      AFTER FIELD zau02
         IF NOT cl_null(g_zau.zau02) THEN
            IF g_zau.zau02 = g_zau.zau03 THEN
               CALL cl_err('',-239,0)
               NEXT FIELD zau02
            END IF 
            LET l_status = 0
            LET l_tok = base.StringTokenizer.createExt(l_str,",","",TRUE)
            WHILE l_tok.hasMoreTokens()
               LET l_tab=l_tok.nextToken()
               LET l_status = p_wizard_check_field(g_zau.zau02 CLIPPED,l_tab,'N')
               IF l_status THEN
                  EXIT WHILE
               END IF
            END WHILE
            IF NOT l_status THEN    
               LET l_tab= l_str," + ",g_zau.zau02
               CALL cl_err(l_tab,'-1106',0)
               NEXT FIELD zau02
            END IF
         END IF
 
      AFTER FIELD zau03
         IF NOT cl_null(g_zau.zau03) THEN
            IF g_zau.zau02 = g_zau.zau03  THEN
               CALL cl_err('',-239,0)
               NEXT FIELD zau03
            END IF
            LET l_status = 0
            LET l_tok = base.StringTokenizer.createExt(l_str,",","",TRUE)
            WHILE l_tok.hasMoreTokens()
               LET l_tab=l_tok.nextToken()
               LET l_status = p_wizard_check_field(g_zau.zau03 CLIPPED,l_tab,'N')
               IF l_status THEN
                  EXIT WHILE
               END IF
            END WHILE    
            IF NOT l_status THEN    
               LET l_tab= l_str," + ",g_zau.zau03
               CALL cl_err(l_tab,"-1106",0)
               NEXT FIELD zau03
            END IF
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN                            # 使用者不玩了
             EXIT INPUT
         END IF
         IF NOT cl_null(g_zau.zau02) OR NOT cl_null(g_zau.zau03) THEN
            IF cl_null(g_zau.zau02) THEN
               CALL cl_err('','mfg0037',0)
               NEXT FIELD zau02
            END IF
            IF cl_null(g_zau.zau03) THEN
               CALL cl_err('','mfg0037',0)
               NEXT FIELD zau03
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(zau02)
               CALL q_gaq1(FALSE,TRUE,'',l_str) 
                    RETURNING g_zau.zau02
               DISPLAY g_zau.zau02 TO zau02
             WHEN INFIELD(zau03)
               CALL q_gaq1(FALSE,TRUE,'',l_str) 
                    RETURNING g_zau.zau03
               DISPLAY g_zau.zau03 TO zau03
         END CASE
 
      ON ACTION controlf                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
   END INPUT 
   IF INT_FLAG THEN
      LET g_zau.* = g_zau_t.*
      DISPLAY BY NAME g_zau.zau02,g_zau.zau03
      LET INT_FLAG = 0
      RETURN
   END IF
 
   UPDATE zau_file set zau02 = g_zau.zau02 ,zau03 = g_zau.zau03
    WHERE zau01 = g_zai.zai01 AND zau04 = g_zai.zai05       #FUN-750084
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","zau_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","",0)  #FUN-750084
      RETURN
   END IF
   DISPLAY BY NAME g_zau.zau02,g_zau.zau03
 
   #TQC-810053
   LET g_zai.zaimodu = g_user
   LET g_zai.zaidate = g_today
   UPDATE zai_file SET zaimodu=g_zai.zaimodu,zaidate=g_zai.zaidate
       WHERE zai01=g_zai.zai01
   DISPLAY BY NAME g_zai.zaimodu,g_zai.zaidate
   #END TQC-810053
 
END FUNCTION
 
FUNCTION p_query_layout_i()
DEFINE l_cnt      LIKE type_file.num10 
 
   IF cl_null(g_zai.zai01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   #TQC-810053
   #LET l_cnt = 0
   #SELECT COUNT(*) INTO l_cnt FROM zap_file 
   # WHERE zap01 = g_zai.zai01 AND zap07 = g_zai.zai05               #FUN-750084
   #IF l_cnt = 0 THEN
   #   LET g_zap.zap02 = 66 
   #   LET g_zap.zap03 = 2                                           #FUN-7B0010
   #   LET g_zap.zap04 = 2                                           #FUN-7B0010
   #   LET g_zap.zap05 = 2                                           #FUN-7B0010
   #   LET g_zap.zap06 = 6600 
   #   #FUN-750084
   #   INSERT INTO zap_file(zap01,zap02,zap03,zap04,zap05,zap06,zap07)
   #          VALUES(g_zai.zai01,g_zap.zap02,g_zap.zap03,g_zap.zap04,g_zap.zap05,g_zap.zap06,g_zai.zai05) 
   #   IF SQLCA.sqlcode THEN
   #      CALL cl_err3("ins","zap_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","",0)
   #   #END FUN-750084
   #      RETURN
   #   END IF
   #   DISPLAY BY NAME g_zap.zap02,g_zap.zap03,g_zap.zap04,g_zap.zap05,g_zap.zap06
   #END IF  
 
   CALL p_query_zao()
   #END TQC-810053
 
   LET g_zap_t.* = g_zap.*
 
   INPUT g_zap.zap02,g_zap.zap03,g_zap.zap04,g_zap.zap05,g_zap.zap06
        WITHOUT DEFAULTS FROM zap02,zap03,zap04,zap05,zap06
 
      AFTER FIELD zap06
         #IF g_zap.zap06 > 6600 OR g_zap.zap06 < 1 THEN
          IF g_zap.zap06 <= 0  THEN                           #FUN-820043
             #CALL cl_err_msg('','azz-253','6600',0)
             CALL cl_err('','mfg9243',0)                      #FUN-820043
             NEXT FIELD zap06
          END IF
 
 
      ON ACTION controlf                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
   END INPUT 
   IF INT_FLAG THEN
      LET g_zap.* = g_zap_t.*
      DISPLAY BY NAME g_zap.zap02,g_zap.zap03,
                      g_zap.zap04,g_zap.zap05,g_zap.zap06
      LET INT_FLAG = 0
      RETURN
   END IF
 
   #TQC-810053
   LET g_zai.zaimodu = g_user
   LET g_zai.zaidate = g_today
   UPDATE zai_file SET zaimodu=g_zai.zaimodu,zaidate=g_zai.zaidate
       WHERE zai01=g_zai.zai01
   #END TQC-810053
 
   UPDATE zap_file set zap02 = g_zap.zap02 ,zap03 = g_zap.zap03,
                       zap04 = g_zap.zap04 ,zap05 = g_zap.zap05,
                       zap06 = g_zap.zap06
    WHERE zap01 = g_zai.zai01 AND zap07 = g_zai.zai05           #FUN-750084
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","zap_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","",0)  #FUN-750084
      RETURN
   END IF
   DISPLAY BY NAME g_zap.zap02,g_zap.zap03,g_zap.zap04,g_zap.zap05,g_zap.zap06,
                   g_zai.zaimodu,g_zai.zaidate        #TQC-810053
END FUNCTION
 
FUNCTION p_query_parse_sql(p_cmd)
    DEFINE p_cmd       LIKE type_file.chr1    # a:輸入 u:更改 #No.FUN-680135 VARCHAR(1)
    DEFINE l_text      STRING
    DEFINE l_str       STRING
    DEFINE l_sql       STRING
    DEFINE l_tmp       STRING
    DEFINE l_execmd    STRING
    DEFINE l_tok       base.StringTokenizer 
    DEFINE l_start     LIKE type_file.num5       #No.FUN-680135 SMALLINT
    DEFINE l_end       LIKE type_file.num5       #No.FUN-680135 SMALLINT
    DEFINE l_feld_tmp  LIKE type_file.chr1000    #No.FUN-680135 VARCHAR(55)
    DEFINE l_feld      DYNAMIC ARRAY OF STRING
    DEFINE l_length    DYNAMIC ARRAY OF LIKE type_file.num5    #No.FUN-680135 DYNAMIC ARRAY OF SMALLINT
    DEFINE l_feld_t    DYNAMIC ARRAY OF STRING
    DEFINE l_tab       DYNAMIC ARRAY OF STRING
    DEFINE l_tab_alias DYNAMIC ARRAY OF STRING
    DEFINE l_i         LIKE type_file.num5       #No.FUN-680135 SMALLINT
    DEFINE l_j         LIKE type_file.num5       #No.FUN-680135 SMALLINT
    DEFINE l_k         LIKE type_file.num5       #No.FUN-680135 SMALLINT
    DEFINE l_gaq03     LIKE zal_file.zal05
    DEFINE l_lang_arr  DYNAMIC ARRAY OF LIKE type_file.chr1      #No.FUN-680135 DYNAMIC ARRAY OF VARCHAR(1)
    DEFINE l_feld_cnt  LIKE type_file.num5       #No.FUN-680135 SMALLINT
    DEFINE l_tab_cnt   LIKE type_file.num5       #No.FUN-680135 SMALLINT
    DEFINE l_colname   LIKE zal_file.zal04,      #No.FUN-680135 VARCHAR(20)
           l_colnamec  LIKE gaq_file.gaq03,      #No.FUN-680135 VARCHAR(50)
           l_collen    LIKE type_file.num5,      #No.FUN-680135 SMALLINT
           l_coltype   LIKE zta_file.zta03,      #No.FUN-680135 VARCHAR(3)
           l_sel       LIKE type_file.chr1       #No.FUN-680135 VARCHAR(1)
    DEFINE l_cnt       LIKE type_file.num10 
    DEFINE l_zal       DYNAMIC ARRAY OF RECORD   #定義SQL欄位資料  #FUN-770079
           zal02         LIKE zal_file.zal02,                             
           zal04         LIKE zal_file.zal04,                             
           tag           LIKE type_file.chr1 
                         END RECORD                            
    DEFINE l_del_tag   LIKE type_file.chr1
    DEFINE l_del_tag2  LIKE type_file.chr1
    DEFINE l_tab_name  STRING                    #FUN-820043
    DEFINE l_table_tok base.StringTokenizer      #FUN-AC0011  
 
--  抓取所有的語言別
    DECLARE lang_arr CURSOR FOR
     SELECT UNIQUE gay01 FROM gay_file ORDER BY gay01
    LET l_i=1
    FOREACH lang_arr INTO l_lang_arr[l_i]
       IF sqlca.sqlcode THEN
          CONTINUE FOREACH
       END IF
       LET l_i=l_i+1
    END FOREACH
    FREE lang_arr
    CALL l_lang_arr.deleteElement(l_i)
 
    LET l_sel='I'
 
   #LET l_str=p_query_cut_spaces(g_zak.zak02)
    LET l_str= g_zak.zak02 CLIPPED                           #FUN-810062
    LET l_str = l_str.toLowerCase()
    LET l_end = l_str.getIndexOf(';',1)
    IF l_end != 0 THEN
       LET l_str=l_str.subString(1,l_end-1)
    END IF
    LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,"\n","",TRUE)
    WHILE l_tok.hasMoreTokens()
          LET l_tmp=l_tok.nextToken()
          IF l_text is null THEN
             LET l_text = l_tmp.trim()
          ELSE
             LET l_text = l_text CLIPPED,' ',l_tmp.trim()
          END IF
    END WHILE
    LET l_tmp=l_text
    LET l_execmd=l_tmp
    LET l_str=l_tmp
    LET l_start = l_tmp.getIndexOf('select',1)
    IF l_start=0 THEN
       CALL cl_err('can not execute this command!','!',0)
    LET INT_FLAG=1
    END IF
    LET l_end   = l_tmp.getIndexOf('from',1)
    LET l_str=l_str.subString(l_start+7,l_end-2)
    LET l_str=l_str.trim()
    LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,",","",TRUE)
    LET l_i=1
    WHILE l_tok.hasMoreTokens()
          LET l_feld[l_i]=l_tok.nextToken()
          LET l_feld[l_i]=l_feld[l_i].trim()
          LET l_i=l_i+1
    END WHILE
    LET l_feld_cnt=l_i-1
    
    LET l_str=l_tmp
    LET l_start = l_str.getIndexOf('from',1)
    LET l_end   = l_str.getIndexOf('where',1)
    IF l_end=0 THEN
       LET l_end   = l_str.getIndexOf('group',1)
       IF l_end=0 THEN
          LET l_end   = l_str.getIndexOf('order',1)
          IF l_end=0 THEN
             LET l_end=l_str.getLength()
             LET l_str=l_str.subString(l_start+5,l_end)
          ELSE
             LET l_str=l_str.subString(l_start+5,l_end-2)
          END IF
       ELSE
          LET l_str=l_str.subString(l_start+5,l_end-2)
       END IF
    ELSE
       LET l_str=l_str.subString(l_start+5,l_end-2)
    END IF
    LET l_str=l_str.trim()
    LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,",","",TRUE)
    LET l_j=1
    WHILE l_tok.hasMoreTokens()
          #---FUN-AC0011---start-----
          #因為sql語法中FROM後面的table有可能會以 JOIN 的形式出現
          #例1:SELECT XXX FROM nni_file nni LEFT OUTER JOIN nma_file ON nma01 = nni06, nnj_file LEFT OUTER JOIN nne_file ON nnj03 = nne01
          #例2:SELECT XXX FROM nni_file nni RIGHT OUTER JOIN nma_file ON nma01 = nni06, nnj_file LEFT OUTER JOIN nne_file ON nnj03 = nne01
          #例3:SELECT XXX FROM nni_file nni OUTER JOIN nma_file ON nma01 = nni06, nnj_file LEFT OUTER JOIN nne_file ON nnj03 = nne01
          LET l_str = l_tok.nextToken()

          #依照關鍵字去除,取代成逗號,以利分割table
          LET l_text = "left outer join"
          CALL cl_replace_str(l_str, l_text.toLowerCase(), ",") RETURNING l_str
          LET l_text = "right outer join"
          CALL cl_replace_str(l_str, l_text.toLowerCase(), ",") RETURNING l_str
          LET l_text = "outer join"
          CALL cl_replace_str(l_str, l_text.toLowerCase(), ",") RETURNING l_str
          WHILE l_str.getIndexOf("on", 1) > 0
                #準備將on後面的條件式去除,如:XXXXXX JOIN nma_file nma [ON nma01 = nni06], 
                LET l_start = l_str.getIndexOf("on", 1) 

                #從剛才找出on關鍵字地方關始找下一個逗號,應該就是此次所要截取的table名稱和別名
                #如果後面已找不到逗號位置,代表應該已到字串的最尾端
                LET l_end = l_str.getIndexOf(",", l_start)  
                IF l_end = 0 THEN
                   LET l_end = l_str.getLength() + 1   #因為下面會減1,所以這裡先加1
                END IF
                LET l_text = l_str.subString(l_start, l_end - 1)
                CALL cl_replace_str(l_str, l_text, " ") RETURNING l_str
          END WHILE

          #依逗號區隔出各table名稱和別名
          LET l_table_tok = base.StringTokenizer.createExt(l_str CLIPPED,",","",TRUE)
          WHILE l_table_tok.hasMoreTokens()
          #---FUN-AC0011---end-------
                #LET l_tab[l_j]=l_tok.nextToken()          #FUN-AC0011 mark 改成下面取tok方式
                LET l_tab[l_j] = l_table_tok.nextToken()   #FUN-AC0011
                LET l_tab[l_j]=l_tab[l_j].trim()
                IF l_tab[l_j].getIndexOf(' ',1) THEN
                   DISPLAY 'qazzaq:',l_tab[l_j].getIndexOf(' ',1)
                   LET l_tab_alias[l_j]=l_tab[l_j].subString(l_tab[l_j].getIndexOf(' ',1)+1,l_tab[l_j].getLength())
                   LET l_tab[l_j]=l_tab[l_j].subString(1,l_tab[l_j].getIndexOf(' ',1)-1)
                END IF
                LET l_j=l_j+1
          END WHILE   #FUN-AC0011
    END WHILE
    LET l_tab_cnt=l_j-1
 
    CALL cl_query_prt_temptable()     #No.FUN-A60085
         
    FOR l_i=1 TO l_feld_cnt
        IF l_feld[l_i]='*' THEN
           LET l_str=l_tmp
           LET l_start = l_str.getIndexOf('from',1)
           LET l_end   = l_str.getIndexOf('where',1)
           IF l_end=0 THEN
              LET l_end   = l_str.getIndexOf('group',1)
              IF l_end=0 THEN
                 LET l_end   = l_str.getIndexOf('order',1)
                 IF l_end=0 THEN
                    LET l_end=l_str.getLength()
                    LET l_str=l_str.subString(l_start+5,l_end)
                 ELSE
                    LET l_str=l_str.subString(l_start+5,l_end-2)
                 END IF
              ELSE
                 LET l_str=l_str.subString(l_start+5,l_end-2)
              END IF
           ELSE
              LET l_str=l_str.subString(l_start+5,l_end-2)
           END IF
           LET l_str=l_str.trim()
           LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,",","",TRUE)
           FOR l_j=1 TO l_tab_cnt 
              #CALL p_query_getlength(l_tab[l_j],l_sel,'m')
               CALL cl_query_prt_getlength(l_tab[l_j],l_sel,'m','0') #No.FUN-810062
               DECLARE p_query_insert_d_ifx CURSOR FOR
                       SELECT xabc03,xabc04 FROM xabc ORDER BY xabc01  #No.FUN-810062
               FOREACH p_query_insert_d_ifx INTO l_feld_tmp,l_length[l_i]
                  LET l_feld[l_i]=l_feld_tmp
                  LET l_i=l_i+1
               END FOREACH
               LET l_feld_cnt=l_i-1
           END FOR
           EXIT FOR   #確保避免因人為的sql錯誤產生多除的顯示欄位
        ELSE
           IF l_feld[l_i].getIndexOf('.',1) THEN
              IF l_feld[l_i].subString(l_feld[l_i].getIndexOf('.',1)+1,l_feld[l_i].getLength())='*' THEN
                 FOR l_j=1 TO l_tab_cnt
                     IF l_tab_alias[l_j] is null THEN
                        IF l_tab[l_j]=l_feld[l_i].subString(1,l_feld[l_i].getIndexOf('.',1)-1) THEN
                           LET l_k=l_i   #備份l_i的值
                           CALL l_feld.deleteElement(l_i) #刪除xxx.*那筆資料
                           CALL l_length.deleteElement(l_i) #刪除xxx.*那筆資料
                           CALL l_feld.insertElement(l_i)
                           CALL l_length.insertElement(l_i)
                          #CALL p_query_getlength(l_tab[l_j],l_sel,'m')
                           CALL cl_query_prt_getlength(l_tab[l_j],l_sel,'m','0') #No.FUN-810062
                           DECLARE p_query_insert_d1_ifx CURSOR FOR 
                                   SELECT xabc03,xabc04 FROM xabc ORDER BY xabc01 DESC   #No.FUN-810062
                           FOREACH p_query_insert_d1_ifx INTO l_feld_tmp,l_length[l_i]
                              LET l_feld[l_i]=l_tab[l_j],'.',l_feld_tmp    #FUN-820043
                              CALL l_feld.insertElement(l_i)
                              CALL l_length.insertElement(l_i)
                              LET l_k=l_k+1
                              LET l_feld_cnt=l_feld_cnt+1
                           END FOREACH
                           CALL l_feld.deleteElement(l_i) #刪除xxx.*那筆資料
                           CALL l_length.deleteElement(l_i) #刪除xxx.*那筆資料
                           LET l_feld_cnt=l_feld_cnt-1
                           LET l_i=l_k-1
                        END IF
                     ELSE
                        IF l_tab_alias[l_j]=l_feld[l_i].subString(1,l_feld[l_i].getIndexOf('.',1)-1) THEN
                           LET l_k=l_i   #備份l_i的值
                           CALL l_feld.deleteElement(l_i) #刪除xxx.*那筆資料
                           CALL l_length.deleteElement(l_i) #刪除xxx.*那筆資料
                           CALL l_feld.insertElement(l_i)
                           CALL l_length.insertElement(l_i)
                          #CALL p_query_getlength(l_tab[l_j],l_sel,'m')
                           CALL cl_query_prt_getlength(l_tab[l_j],l_sel,'m','0') #No.FUN-810062
                           DECLARE p_query_insert_d2_ifx CURSOR FOR 
                                   SELECT xabc03,xabc04 FROM xabc ORDER BY xabc01 DESC   #No.FUN-810062
                           FOREACH p_query_insert_d2_ifx INTO l_feld_tmp,l_length[l_i]
                              LET  l_feld[l_i]=l_tab_alias[l_j],".",l_feld_tmp           #FUN-820043
                              CALL l_feld.insertElement(l_i)
                              CALL l_length.insertElement(l_i)
                              LET l_k=l_k+1
                              LET l_feld_cnt=l_feld_cnt+1
                           END FOREACH
                           CALL l_feld.deleteElement(l_i) #刪除xxx.*那筆資料
                           CALL l_length.deleteElement(l_i) #刪除xxx.*那筆資料
                           LET l_feld_cnt=l_feld_cnt-1
                           LET l_i=l_k-1
                        END IF
                     END IF 
                 END FOR
              ELSE
                 LET l_tab_name =l_feld[l_i].subString(1,l_feld[l_i].getIndexOf('.',1)-1)    #FUN-820043
                 LET l_feld[l_i]=l_feld[l_i].subString(l_feld[l_i].getIndexOf('.',1)+1,l_feld[l_i].getLength())
                 LET l_length[l_i]=''
                #CALL p_query_getlength(l_feld[l_i],l_sel,'s')
                 CALL cl_query_prt_getlength(l_feld[l_i],l_sel,'s','0') #No.FUN-810062
                 DECLARE p_query_d_ifx CURSOR FOR 
                         SELECT xabc03,xabc04 FROM xabc ORDER BY xabc01 DESC  #No.FUN-810062
                 FOREACH p_query_d_ifx INTO l_feld_tmp,l_length[l_i]
                    IF l_feld[l_i] <> l_feld_tmp THEN   #TQC-C60167
                       LET l_feld[l_i] = l_tab_name, ".", l_feld[l_i]   #TQC-C60167
                    ELSE    #TQC-C60167
                       LET l_feld[l_i] = l_tab_name, ".", l_feld_tmp   #FUN-820043
                    END IF    #TQC-C60167
                 END FOREACH
              END IF
           ELSE
              LET l_length[l_i]=''
              #CALL p_query_getlength(l_feld[l_i],l_sel,'s')
              CALL cl_query_prt_getlength(l_feld[l_i],l_sel,'s','0') #No.FUN-810062
              DECLARE p_query_d1_ifx CURSOR FOR 
                      SELECT xabc03,xabc04 FROM xabc ORDER BY xabc01 DESC   #No.FUN-810062
              FOREACH p_query_d1_ifx INTO l_feld_tmp,l_length[l_i]
                 LET l_feld[l_i]=l_feld_tmp
              END FOREACH
           END IF
        END IF
    END FOR
    
    IF p_cmd = 'a' THEN
       LET l_j = 1
       LET l_colname=''
       FOR l_i = 1 TO l_feld_cnt
           LET l_colname=l_feld[l_i]
           #FUN-820043
           IF l_feld[l_i].getIndexOf('.',1) THEN
               LET l_feld_tmp=l_feld[l_i].subString(l_feld[l_i].getIndexOf('.',1)+1,l_feld[l_i].getLength())
           ELSE
               LET l_feld_tmp=l_feld[l_i]
           END IF
           #END FUN-820043
           FOR l_k=1 TO l_lang_arr.getLength()
               #FUN-770079
               SELECT COUNT(*) INTO l_cnt FROM zal_file 
                 WHERE zal01 = g_zai.zai01 AND zal04 = l_colname
                   AND zal03 = l_lang_arr[l_k]
                   AND zal07 = g_zai.zai05                     #FUN-750084 
               IF l_cnt = 0 THEN
                  LET l_gaq03=''
                  SELECT gaq03 INTO l_gaq03 FROM gaq_file
                   WHERE gaq01 = l_feld_tmp AND gaq02=l_lang_arr[l_k]  #FUN-820043
                  INSERT INTO zal_file(zal01,zal02,zal03,zal04,zal05,zal06,zal07,zal08,zal09)
                  VALUES(g_zai.zai01,l_j,l_lang_arr[l_k],l_colname,l_gaq03,'',g_zai.zai05,l_length[l_i],'G')   #FUN-750084 #FUN-770079 #FUN-7C0020
               END IF
               #END FUN-770079
           END FOR
           LET l_j=l_j+1
       END FOR
    ELSE
       LET l_colname=''
       FOR l_i = 1 TO l_feld_cnt
           LET l_colname=l_feld[l_i]
           #FUN-820043
           IF l_feld[l_i].getIndexOf('.',1) THEN
               LET l_feld_tmp=l_feld[l_i].subString(l_feld[l_i].getIndexOf('.',1)+1,l_feld[l_i].getLength())
           ELSE
               LET l_feld_tmp=l_feld[l_i]
           END IF
           #END FUN-820043
           SELECT COUNT(*) INTO l_cnt FROM zal_file 
             WHERE zal01 = g_zai.zai01 AND zal04 = l_colname
               AND zal07 = g_zai.zai05                               #FUN-750084
           IF l_cnt = 0 OR l_cnt < l_lang_arr.getLength() THEN
              IF l_cnt = 0 THEN 
                 SELECT MAX(zal02)+1 INTO l_j FROM zal_file 
                  WHERE zal01 = g_zai.zai01 AND zal07 = g_zai.zai05  #FUN-750084
                 IF l_j IS NULL THEN
                    LET l_j = 1
                 END IF
                 FOR l_k=1 TO l_lang_arr.getLength()
                     LET l_gaq03=''
                     SELECT gaq03 INTO l_gaq03 FROM gaq_file
                      WHERE gaq01=l_feld_tmp AND gaq02=l_lang_arr[l_k]  #FUN-820043
                     INSERT INTO zal_file(zal01,zal02,zal03,zal04,zal05,zal06,zal07,zal08,zal09)
                     VALUES(g_zai.zai01,l_j,l_lang_arr[l_k],l_colname,l_gaq03,'',g_zai.zai05,l_length[l_i],'G') #FUN-750084 #FUN-7C0020
                 END FOR
              ELSE
                 SELECT zal02 INTO l_j FROM zal_file 
                  WHERE zal01 = g_zai.zai01 AND zal04 = l_colname
                    AND zal07 = g_zai.zai05                          #FUN-750084
                 FOR l_k=1 TO l_lang_arr.getLength()
                     SELECT COUNT(*) INTO l_cnt FROM zal_file 
                       WHERE zal01 = g_zai.zai01 AND zal04 = l_colname
                         AND zal03 = l_lang_arr[l_k]
                         AND zal07 = g_zai.zai05                     #FUN-750084 
                     IF l_cnt = 0 THEN
                        LET l_gaq03=''
                        SELECT gaq03 INTO l_gaq03 FROM gaq_file
                         WHERE gaq01=l_colname AND gaq02=l_lang_arr[l_k]
                        INSERT INTO zal_file(zal01,zal02,zal03,zal04,zal05,zal06,zal07,zal08,zal09)
                        VALUES(g_zai.zai01,l_j,l_lang_arr[l_k],l_colname,l_gaq03,'',g_zai.zai05,l_length[l_i],'G')  #FUN-750084 #FUN-7C0020
                     END IF
                 END FOR
              END IF
           END IF
       END FOR
 
       #FUN-770079
       #若SQL有刪除的欄位,則詢問是否將相關資訊一併刪除
       LET l_del_tag = 'N'
       LET g_sql = "SELECT zal02,zal04,'N' FROM zal_file ",
                   " WHERE zal01 = '",g_zai.zai01 CLIPPED,"' ",
                   "   AND zal07 = '",g_zai.zai05 CLIPPED,"' ",    #FUN-750084
                   " ORDER BY zal02"
       PREPARE zal_tag_pre FROM g_sql           #預備一下
       DECLARE zal_tag_curs CURSOR FOR zal_tag_pre
       CALL l_zal.clear()
       LET l_cnt = 1
       FOREACH zal_tag_curs INTO l_zal[l_cnt].*
          IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          LET l_str = l_zal[l_cnt].zal04 CLIPPED
          LET l_del_tag2 = "Y"
          FOR l_i = 1 TO l_feld_cnt
              IF l_str = l_feld[l_i] THEN
                 LET l_zal[l_cnt].tag = 'Y'
                 LET l_del_tag2 = 'N'
                 EXIT FOR
              END IF
          END FOR
          IF l_del_tag = "N" AND l_del_tag2 = "Y" THEN
             LET l_del_tag = 'Y'
          END IF
          LET l_cnt = l_cnt + 1
       END FOREACH
 
       IF l_del_tag = 'Y' THEN
          IF cl_confirm('azz-273') THEN
 
             BEGIN WORK
 
             FOR l_i = 1 TO l_zal.getLength()
                 IF l_zal[l_i].tag = 'N' THEN
                    DELETE FROM zal_file
                      WHERE zal01 = g_zai.zai01 AND zal02 = l_zal[l_i].zal02
                        AND zal07 = g_zai.zai05 #FUN-750084
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("del","zal_file",g_zai.zai01,l_zal[l_i].zal02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                       ROLLBACK WORK
                       EXIT FOR
                    END IF
                    
                    DELETE FROM zat_file
                      WHERE zat01 = g_zai.zai01 AND zat02 = l_zal[l_i].zal02
                        AND zat10 = g_zai.zai05                      #FUN-750084
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("del","zat_file",g_zai.zai01,l_zal[l_i].zal02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                       ROLLBACK WORK
                       EXIT FOR
                    END IF
                    DELETE FROM zav_file
                      WHERE zav01 = '2' AND zav02 = g_zai.zai01 
                        AND zav03 = l_zal[l_i].zal04 
                        AND zav04 = g_zai.zai05                      #FUN-750084
                        AND zav05 = 'default'
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("del","zav_file",g_zai.zai01,l_zal[l_i].zal04,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                       ROLLBACK WORK
                       EXIT FOR
                    END IF
                    
                    DELETE FROM zay_file
                      WHERE zay01 = g_zai.zai01 AND zay02 = l_zal[l_i].zal02
                        AND zay03 = g_zai.zai05                      #FUN-750084
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("del","zay_file",g_zai.zai01,l_zal[l_i].zal02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                       ROLLBACK WORK
                       EXIT FOR
                    END IF
                    
                    DELETE FROM zam_file
                      WHERE zam01 = g_zai.zai01 AND zam02 = l_zal[l_i].zal02
                        AND zam09 = g_zai.zai05                         #FUN-750084
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("del","zam_file",g_zai.zai01,l_zal[l_i].zal02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                       ROLLBACK WORK
                       EXIT FOR
                    END IF
                    
                    DELETE FROM zan_file
                      WHERE zan01 = g_zai.zai01 AND zan02 = l_zal[l_i].zal02
                        AND zan08 = g_zai.zai05                         #FUN-750084 
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("del","zan_file",g_zai.zai01,l_zal[l_i].zal02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                       ROLLBACK WORK
                       EXIT FOR
                    END IF
                 END IF
             END FOR
             COMMIT WORK
          END IF
       END IF
       #END FUN-770079
    END IF
    IF INT_FLAG=1 THEN
    END IF
END FUNCTION
 
#FUN-810062
#FUNCTION p_query_cut_spaces(p_str)
#DEFINE p_str         STRING,
#       l_i           LIKE type_file.num5,   #No.FUN-680135 SMALLINT
#       l_flag        LIKE type_file.chr1,   #No.FUN-680135 VARCHAR(1) 
#       l_cmd         STRING,
#       l_desc_stop   LIKE type_file.num5    #No.FUN-680135 SMALLINT
#
#LET l_flag='N'
#LET l_desc_stop=-1
#LET p_str=p_str.trim()
#FOR l_i=1 TO p_str.getLength()
#    IF l_i<=l_desc_stop+1 THEN
#       CONTINUE FOR
#    ELSE
#       
#       CASE g_db_type                                           #FUN-750084
#        WHEN "IFX"                                              #FUN-750084
#          IF l_i=p_str.getIndexOf('{',l_i) THEN
#             LET l_desc_stop=p_str.getIndexOf('}',l_i)
#             LET l_cmd=l_cmd,p_str.subString(l_i,l_desc_stop+1)
#          ELSE
#             IF p_str.subString(l_i,l_i) != ' ' THEN
#                IF l_cmd.getLength()=0 THEN
#                   LET l_cmd=p_str.subString(l_i,l_i)
#                ELSE
#                   LET l_cmd=l_cmd,p_str.subString(l_i,l_i)
#                END IF
#                LET l_flag='N'
#             ELSE
#                IF l_flag='N' THEN
#                   LET l_flag='Y'
#                   LET l_cmd=l_cmd,p_str.subString(l_i,l_i)
#                END IF
#             END IF
#          END IF
#       #ELSE
#       WHEN "ORA"                                              #FUN-750084
#          IF l_i=p_str.getIndexOf('/*',l_i) THEN
#             LET l_desc_stop=p_str.getIndexOf('*/',l_i)
#             LET l_cmd=l_cmd,p_str.subString(l_i,l_desc_stop+1)
#          ELSE
#             IF p_str.subString(l_i,l_i) != ' ' THEN
#                IF l_cmd.getLength()=0 THEN
#                   LET l_cmd=p_str.subString(l_i,l_i)
#                ELSE
#                   LET l_cmd=l_cmd,p_str.subString(l_i,l_i)
#                END IF
#                LET l_flag='N'
#             ELSE
#                IF l_flag='N' THEN
#                   LET l_flag='Y'
#                   LET l_cmd=l_cmd,p_str.subString(l_i,l_i)
#                END IF
#             END IF
#          END IF
#        WHEN "MSV"                                             #FUN-750084
#
#       END CASE
#    END IF
#END FOR
#RETURN l_cmd
#END FUNCTION
#END FUN-810062
 
#No.FUN-810062
#p_flag = s 表single只查field
#p_flag = m 表multi查table所有的field
#FUNCTION p_query_getlength(p_tab,p_sel,p_flag)
#DEFINE p_tab        STRING
#DEFINE l_sql        STRING
#DEFINE l_sn         LIKE type_file.num5    #No.FUN-680135 SMALLINT
#DEFINE p_flag       LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1) 
#DEFINE l_feldname   LIKE type_file.chr1000 #No.FUN-680135 VARCHAR(55)
#DEFINE l_colname    LIKE gaq_file.gaq01,   #No.FUN-680135 VARCHAR(20)
#       l_colnamec   LIKE gaq_file.gaq03,   #No.FUN-680135 VARCHAR(50)
#       l_collen     LIKE type_file.num5,   #No.FUN-680135 SMALLINT
#       l_coltype    LIKE zta_file.zta03,   #No.FUN-680135 VARCHAR(3)
#       p_sel        LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
#DEFINE l_id         LIKE type_file.num10
#DEFINE l_cnt        LIKE type_file.num10   #FUN-7C0020
#
#    DROP TABLE xabc
##FUN-680135 --start
##   CREATE TEMP TABLE xabc
##   (
##     xabc01 SMALLINT,
##     xabc02 VARCHAR(55),
##     xabc03 SMALLINT
##   )
#    
#    CREATE TEMP TABLE xabc(
#      xabc01   SMALLINT,  
#      xabc02   VARCHAR(1000),
#      xabc03   SMALLINT)
##FUN-680135 --end      
#    LET l_sn=1
#
#    #FUN-7C0020
#    
#    LET g_zta17 = NULL
#    IF p_flag = 'm' THEN
#       LET g_zta01= p_tab CLIPPED
#       SELECT zta17 INTO g_zta17 
#         FROM zta_file WHERE zta01 = g_zta01 AND zta02 = g_dbs
#    ELSE
#       LET l_colname = p_tab CLIPPED
#       CASE g_db_type
#        WHEN "IFX"
#              SELECT COUNT(*) INTO l_cnt
#                FROM syscolumns c WHERE c.colname = l_colname
#        WHEN "ORA"
#              SELECT COUNT(*) INTO l_cnt
#                FROM user_tab_columns WHERE lower(column_name)= l_colname
#        WHEN "MSV"
#              SELECT COUNT(*) INTO l_cnt                       
#                FROM sys.columns WHERE sys.columns.name=l_colname   #FUN-810062
#       END CASE
#       IF l_cnt = 0 THEN
#          LET g_zta17 = 'ds'
#       END IF
#    END IF
#    LET l_colname = ""
#    #END FUN-7C0020
#
#    IF p_flag='m' THEN
#       #IF g_db_type="IFX" THEN
#       CASE g_db_type                                          #FUN-750084
#        WHEN "IFX"                                             #FUN-750084
#          #FUN-750084 
#          #FUN-7C0020
#          #LET g_zta17 = NULL
#          #LET g_zta01= p_tab CLIPPED
#          #SELECT zta17 INTO g_zta17 FROM zta_file 
#          # WHERE zta01 = g_zta01 AND zta02 = g_dbs
#          #END FUN-7C0020
#          IF NOT cl_null(g_zta17 CLIPPED) THEN 
#             LET l_sql="SELECT unique c.colno, c.colname,c.coltype,c.collength ",
#                       "  FROM ",g_zta17 CLIPPED,":syscolumns c,",
#                       "       ",g_zta17 CLIPPED,":systables t",
#                       " WHERE c.tabid=t.tabid AND t.tabname='",p_tab CLIPPED,"'",
#                       " ORDER BY c.colno "
#          ELSE
#             LET l_sql="SELECT unique c.colno,c.colname,c.coltype,c.collength FROM syscolumns c,systables t",
#                       " WHERE c.tabid=t.tabid AND t.tabname='",p_tab CLIPPED,"'",
#                       " ORDER BY c.colno "
#          END IF
#          #END FUN-750084
#          DECLARE p_query_getlength_d_ifx CURSOR FROM l_sql
#          FOREACH p_query_getlength_d_ifx INTO l_id,l_colname,l_coltype,l_collen
#             CASE WHEN l_coltype='1' or l_coltype='257'
#                       LET l_collen=5
#                  WHEN l_coltype='2' or l_coltype='258'
#                       LET l_collen=10
#                  WHEN l_coltype='5' or l_coltype='261'
#                       LET l_collen=20
#                  WHEN l_coltype='7' or l_coltype='263'
#                       LET l_collen=10
#             END CASE
#             CASE
#               WHEN p_sel='N'
#                  SELECT gaq03 INTO l_colnamec
#                    FROM gaq_file
#                   WHERE gaq01=l_colname
#                     AND gaq02=g_i
#                  IF cl_null(l_colnamec) THEN
#                     INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname,l_collen)
#                     LET l_sn=l_sn+1
#                  ELSE
#                     INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colnamec,l_collen)
#                     LET l_sn=l_sn+1
#                  END IF
#               WHEN p_sel='I'
#                  INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname,l_collen)
#                  LET l_sn=l_sn+1
#               OTHERWISE
#                  SELECT gaq03 INTO l_colnamec
#                    FROM gaq_file
#                   WHERE gaq01=l_colname
#                     AND gaq02=g_i
#                  LET l_feldname=l_colname CLIPPED,'(',l_colnamec CLIPPED,')'
#                  INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_feldname,l_collen)
#                  LET l_sn=l_sn+1
#             END CASE
#          END FOREACH
#       #ELSE
#       WHEN "ORA"                                                  #FUN-750084
#          #FUN-7C0020
#          IF NOT cl_null(g_zta17 CLIPPED) THEN 
#             LET l_sql="SELECT unique column_id,lower(column_name),decode(data_type,'VARCHAR2',data_length,'DATE',10,'NUMBER',data_PRECISION) FROM all_tab_columns",
#                       " WHERE lower(table_name)='",p_tab CLIPPED,"'",
#                       " ORDER BY column_id"
#          ELSE
#             LET l_sql="SELECT unique column_id,lower(column_name),decode(data_type,'VARCHAR2',data_length,'DATE',10,'NUMBER',data_PRECISION) FROM user_tab_columns",
#                       " WHERE lower(table_name)='",p_tab CLIPPED,"'",
#                       " ORDER BY column_id"
#          END IF
#          #END FUN-7C0020
#          DECLARE p_query_getlength_d CURSOR FROM l_sql
#          FOREACH p_query_getlength_d INTO l_id,l_colname,l_collen
#             CASE
#               WHEN p_sel='N'
#                  SELECT gaq03 INTO l_colnamec
#                    FROM gaq_file
#                   WHERE gaq01=l_colname
#                     AND gaq02=g_i
#                  IF cl_null(l_colnamec) THEN
#                     INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname,l_collen)
#                     LET l_sn=l_sn+1
#                  ELSE
#                     INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colnamec,l_collen)
#                     LET l_sn=l_sn+1
#                  END IF
#               WHEN p_sel='I'
#                  INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname,l_collen)
#                  LET l_sn=l_sn+1
#               OTHERWISE
#                  SELECT gaq03 INTO l_colnamec
#                    FROM gaq_file
#                   WHERE gaq01=l_colname
#                     AND gaq02=g_i
#                  INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname||'('||l_colnamec||')',l_collen)
#                  LET l_sn=l_sn+1
#             END CASE
#          END FOREACH
#        WHEN "MSV"                                              #FUN-750084
#
#       END CASE                                                 #FUN-750084
#    ELSE
#      
#       #IF g_db_type="IFX" THEN
#       CASE g_db_type                                           #FUN-750084
#        WHEN "IFX"                                              #FUN-750084
#          #FUN-750084 
#          #FUN-7C0020
#          # LET g_zta17 = NULL
#          # LET g_zta01= p_tab CLIPPED
#          # SELECT zta17 INTO g_zta17 FROM zta_file 
#          #  WHERE zta01 = g_zta01 AND zta02 = g_dbs
#          #END FUN-7C0020
#          IF NOT cl_null(g_zta17 CLIPPED) THEN 
#             LET l_sql="SELECT unique c.colno,c.colname,c.coltype,c.collength ",
#                       "  FROM ",g_zta17 CLIPPED,":syscolumns c",
#                       " WHERE c.colname='",p_tab CLIPPED,"'",
#                       " ORDER BY c.colno"
#          ELSE
#             LET l_sql="SELECT unique c.colno,c.colname,c.coltype,c.collength FROM syscolumns c",
#                       " WHERE c.colname='",p_tab CLIPPED,"'",
#                       " ORDER BY c.colno"
#          END IF
#          #END FUN-750084
#          DECLARE p_query_getlength_d1_ifx CURSOR FROM l_sql
#          FOREACH p_query_getlength_d1_ifx INTO l_id,l_colname,l_coltype,l_collen
#             CASE WHEN l_coltype='1' or l_coltype='257'
#                       LET l_collen=5
#                  WHEN l_coltype='2' or l_coltype='258'
#                       LET l_collen=10
#                  WHEN l_coltype='5' or l_coltype='261'
#                       LET l_collen=20
#                  WHEN l_coltype='7' or l_coltype='263'
#                       LET l_collen=10
#             END CASE
#             CASE
#               WHEN p_sel='N'
#                  SELECT gaq03 INTO l_colnamec
#                    FROM gaq_file
#                   WHERE gaq01=l_colname
#                     AND gaq02=g_i
#                  IF cl_null(l_colnamec) THEN
#                     INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname,l_collen)
#                  ELSE
#                     INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colnamec,l_collen)
#                  END IF
#               WHEN p_sel='I'
#                  INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname,l_collen)
#               OTHERWISE
#                  SELECT gaq03 INTO l_colnamec
#                    FROM gaq_file
#                   WHERE gaq01=l_colname
#                     AND gaq02=g_i
#                  LET l_feldname=l_colname CLIPPED,'(',l_colnamec CLIPPED,')'
#                  INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_feldname,l_collen)
#             END CASE
#          END FOREACH
#          IF cl_null(l_colname) AND (l_collen=0) THEN
#             LET l_feldname=p_tab
#             INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_feldname,20)  #TQC-7C0043
#          END IF
#       #ELSE
#       WHEN "ORA"                                                   #FUN-750084
#          #FUN-7C0020
#          IF NOT cl_null(g_zta17 CLIPPED) THEN 
#             LET l_sql="SELECT unique column_id,lower(column_name),decode(data_type,'VARCHAR2',data_length,'DATE',10,'NUMBER',data_PRECISION) FROM all_tab_columns",
#                       " WHERE lower(column_name)='",p_tab CLIPPED,"'",
#                       " ORDER BY column_id"
#          ELSE
#             LET l_sql="SELECT unique column_id,lower(column_name),decode(data_type,'VARCHAR2',data_length,'DATE',10,'NUMBER',data_PRECISION) FROM user_tab_columns",
#                       " WHERE lower(column_name)='",p_tab CLIPPED,"'",
#                       " ORDER BY column_id"
#          END IF
#          #END FUN-7C0020
#          DECLARE p_query_getlength_d1 CURSOR FROM l_sql
#          FOREACH p_query_getlength_d1 INTO l_id,l_colname,l_collen
#             CASE
#               WHEN p_sel='N'
#                  SELECT gaq03 INTO l_colnamec
#                    FROM gaq_file
#                   WHERE gaq01=l_colname
#                     AND gaq02=g_i
#                  IF cl_null(l_colnamec) THEN
#                     INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname,l_collen)
#                  ELSE
#                     INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colnamec,l_collen)
#                  END IF
#               WHEN p_sel='I'
#                  INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname,l_collen)
#               OTHERWISE
#                  SELECT gaq03 INTO l_colnamec
#                    FROM gaq_file
#                   WHERE gaq01=l_colname
#                     AND gaq02=g_i
#                  INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname||'('||l_colnamec||')',l_collen)
#             END CASE
#          END FOREACH
#          IF cl_null(l_colname) AND (l_collen=0) THEN  #for count(*)之類的用途
#             LET l_feldname=p_tab
#             INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_feldname,20)  #TQC-7C0043
#          END IF
#        WHEN "MSV"                                                 #FUN-750084
#       END CASE                                                    #FUN-750084
#    END IF
#END FUNCTION
#END No.FUN-810062
 
FUNCTION p_query_out()
DEFINE l_str  STRING
 
    IF g_zai.zai01 IS NULL THEN
       RETURN
    END IF
    LET l_str = g_zak.zak02
    IF l_str IS NULL THEN
       CALL cl_err(g_zai.zai01 CLIPPED,'azz-249',1)
       RETURN
    END IF
    IF l_str.getIndexOf('arg',1) > 0  THEN
       CALL cl_err('','azz-248',1)
       RETURN 
    END IF
    CALL cl_query_prt(g_zai.zai01,g_zai.zai05,l_str)      #FUN-750084
 
    #重新抓取 p_query 設定程式執行權限.
    IF (NOT cl_set_priv()) THEN            
         RETURN 
    END IF
 
END FUNCTION
 
FUNCTION p_query_dbqry()
DEFINE l_str  STRING
 
    IF g_zai.zai01 IS NULL THEN
       RETURN
    END IF
 
    LET l_str = g_zak.zak02
    IF l_str IS NULL THEN
       CALL cl_err(g_zai.zai01 CLIPPED,'azz-249',1)
       RETURN
    END IF
    IF l_str.getIndexOf('arg',1) > 0  THEN
       CALL cl_err('','azz-248',1)
       RETURN 
    END IF
    CALL cl_query_dbqry(g_zai.zai01,g_zai.zai05,g_zak.zak02)  #FUN-750084
 
    #TQC-810053
    #重新抓取 p_query 設定程式執行權限.
    IF (NOT cl_set_priv()) THEN
         RETURN
    END IF
    #END TQC-810053
 
END FUNCTION
 
FUNCTION p_query_chk_arg()
DEFINE l_i         LIKE type_file.num5
DEFINE l_p         LIKE type_file.num5
DEFINE l_arg       STRING
DEFINE l_str       STRING
 
   LET l_str = g_zak.zak02
   FOR l_i = 50 TO 1 STEP -1    #CHI-960099
       LET l_arg = "arg",l_i USING '<<<<<'
       LET l_p  = l_str.getIndexOf(l_arg,1)
       IF l_p > 0  THEN
          CALL cl_replace_str(l_str, l_arg, '') RETURNING l_str     #CHI-960099
       END IF
   END FOR
   IF l_str.getIndexOf('arg',1) > 0  THEN
      CALL cl_err('','azz-247',1)
      RETURN  0
   END IF
   RETURN  1
   
END FUNCTION
 
FUNCTION p_query_cmdrun() 
DEFINE   l_str              STRING
DEFINE   l_p                LIKE type_file.num5
DEFINE   l_arg              STRING
DEFINE   l_i                LIKE type_file.num5
 
       #FUN-750084 
       SELECT COUNT(*) INTO l_p FROM zai_file 
         WHERE zai01 = g_zai.zai01 AND zai05 = "Y" 
       IF l_p = 0 THEN
            SELECT COUNT(*) INTO l_p FROM zai_file 
              WHERE zai01 = g_zai.zai01 AND zai05 = "N"
            IF l_p = 0 THEN 
               CALL cl_err(g_zai.zai01 CLIPPED,'azz-255',1)           
               RETURN
            ELSE
               LET g_zai.zai05 = "N"
            END IF
       ELSE
          LET g_zai.zai05 = "Y"
       END IF
 
       SELECT zak02 INTO g_zak.zak02 FROM zak_file 
        WHERE zak01= g_zai.zai01 AND zak07 = g_zai.zai05
       IF g_zak.zak02 IS NULL THEN
          CALL cl_err(g_zai.zai01 CLIPPED,'azz-249',1)
          RETURN
       END IF
       #END FUN-750084 
 
       LET l_str = g_zak.zak02
       FOR l_i = 50 TO 1 STEP -1     #CHI-960099
           LET l_arg = "arg",l_i USING '<<<<<'
           LET l_p  = l_str.getIndexOf(l_arg,1)
           IF l_p > 0 AND g_argv[l_i] IS NOT NULL THEN
              CALL cl_replace_str(l_str, l_arg, g_argv[l_i] CLIPPED) RETURNING l_str     #CHI-960099 
           END IF
       END FOR
       LET g_zak.zak02 = l_str
 
       OPEN WINDOW p_query_w AT 5,1 WITH FORM "azz/42f/p_query"
          ATTRIBUTE(STYLE=g_win_style CLIPPED)
     
       CALL cl_ui_init()
       CLOSE WINDOW p_query_w
 
       CALL p_query_out()
END FUNCTION
 
FUNCTION p_query_combobox()
DEFINE l_sql        STRING
DEFINE l_colname    LIKE zal_file.zal04
DEFINE l_items      STRING
DEFINE l_i          LIKE type_file.num10   #No.FUN-680130 INTEGER
 
 
   LET l_sql = "SELECT unique zal04 FROM zal_file ",
               " WHERE zal01 = '",g_zai.zai01 CLIPPED,"' ",
               "   AND zal07 = '",g_zai.zai05 CLIPPED,"' ",   #FUN-750084
               " ORDER BY zal04"
   
   DECLARE combobox_cur CURSOR FROM l_sql
   LET l_i=0
   INITIALIZE l_items TO NULL
   FOREACH combobox_cur INTO l_colname
           LET l_i = l_i + 1
           IF l_i = 1 THEN
              LET l_items = l_colname CLIPPED
           ELSE
              LET l_items = l_items,",",l_colname CLIPPED
           END IF
   END FOREACH
   LET l_items = l_items.toLowerCase()
   RETURN l_items
 
END FUNCTION
 
FUNCTION p_query_sum_combobox()
DEFINE l_colname        LIKE zal_file.zal04
DEFINE l_zal02          LIKE zal_file.zal02
DEFINE l_datatype       STRING 
DEFINE l_i              LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_items          STRING
DEFINE l_sql            STRING
DEFINE l_cnt            LIKE type_file.num10   #FUN-750084
DEFINE l_length         STRING                 #FUN-770079
DEFINE l_str            STRING                 #FUN-820043
 
   LET l_sql = "SELECT unique zal02,zal04 FROM zal_file ",
               " WHERE zal01 = '",g_zai.zai01 CLIPPED,"' ",
               "   AND zal07 = '",g_zai.zai05 CLIPPED,"' ",    #FUN-750084
               "   AND zal09 NOT IN ('J','K','M','N','O','P','Q','R','S','T')",  #FUN-7C0020
               " ORDER BY zal04"
   
   DECLARE sum_com_cur CURSOR FROM l_sql
 
   #FUN-750084
   #CASE g_db_type
   #    WHEN "ORA"
   #         LET l_sql= "SELECT UNIQUE TABLE_NAME FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = UPPER( ? ) AND OWNER='DS'"
   #    WHEN "IFX"
   #         LET l_sql = "SELECT tabname FROM ds:syscolumns col, ds:systables tab WHERE col.colname = ? AND tab.tabid = col.tabid"  #FUN-750084
   #    WHEN "MSV"                                               #FUN-750084
   #END CASE
   #END FUN-750084
 
   #END FUN-5A0136
   #LET l_i=0
   CALL g_sum_field.clear()
   INITIALIZE l_items TO NULL
   FOREACH sum_com_cur INTO l_zal02,l_colname
       #FUN-820043
       LET l_str = l_colname CLIPPED
       IF l_str.getIndexOf('.',1) THEN
           LET l_str=l_str.subString(l_str.getIndexOf('.',1)+1,l_str.getLength())
       END IF
       #FUN-770079
       CALL p_query_field_type(l_str) RETURNING l_datatype,l_length
       #END FUN-770079 
       #END FUN-820043
 
       IF l_datatype = "number" OR l_datatype = "decimal" OR
          cl_null(l_datatype)
       THEN
           LET g_sum_field[l_zal02 CLIPPED] = l_colname
       END IF
   END FOREACH
  #LET l_items = l_items.toLowerCase()
  #RETURN l_items
 
END FUNCTION
 
FUNCTION p_query_group_combobox()
DEFINE l_sql            STRING
DEFINE l_colname        LIKE zal_file.zal04
DEFINE l_items          STRING
DEFINE l_i              LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_datatype       LIKE type_file.chr20 
DEFINE l_length         STRING
DEFINE l_table_name     LIKE gac_file.gac05
DEFINE l_index          LIKE type_file.num5  
DEFINE l_zak02          STRING
DEFINE l_tabname        STRING
 
   LET l_sql = "SELECT unique zal04 FROM zal_file,zam_file ",
               " WHERE zam01 = zal01 AND zam02 = zal02 ",
               "   AND zam04 = 'Y' ",
               "   AND zal01 = '",g_zai.zai01 CLIPPED,"' ",
               "   AND zal07 = '",g_zai.zai05 CLIPPED,"' ",      #FUN-750084
               "   AND zal07 = zam09 ",                          #FUN-750084
               " ORDER BY zal04"
   
   DECLARE group_com_cur CURSOR FROM l_sql
 
   #END FUN-5A0136
   LET l_i=0
   INITIALIZE l_items TO NULL
   FOREACH group_com_cur INTO l_colname
         LET l_i = l_i + 1
         IF l_i = 1 THEN
            LET l_items = l_colname CLIPPED
         ELSE
            LET l_items = l_items,",",l_colname CLIPPED
         END IF
   END FOREACH
   LET l_items = l_items.toLowerCase()
   RETURN l_items
 
END FUNCTION
 
FUNCTION p_query_zal(p_zal04)
DEFINE  p_zal04       LIKE zal_file.zal04
DEFINE  l_zal02       LIKE zal_file.zal02
DEFINE  l_zal05       LIKE zal_file.zal05
 
   SELECT zal02,zal05 INTO l_zal02,l_zal05 FROM zal_file
    WHERE zal01 = g_zai.zai01 AND zal03 = g_lang AND zal04 = p_zal04
      AND zal07 = g_zai.zai05                                #FUN-750084
 
   RETURN l_zal02,l_zal05
END FUNCTION
 
FUNCTION p_query_set_entry_b()
   CASE g_page_choice
      WHEN "query_field"
           IF NOT cl_null(g_zat[l_w_ac].zat04) OR INFIELD(zat04) THEN
              CALL cl_set_comp_entry("zat05", TRUE)
              IF g_zat[l_w_ac].zat05 = 'Y' THEN
                   CALL cl_set_comp_entry("zat06", TRUE)
              END IF
           END IF
           IF NOT cl_null(g_sum_field[g_zat[l_w_ac].zat02]) THEN
               CALL cl_set_comp_entry("zat07", TRUE)
               IF g_zat[l_w_ac].zat07 = 'Y' THEN
                    CALL cl_set_comp_entry("zat08,zat09", TRUE)
               END IF
           END IF
      WHEN "query_group"
           IF g_zam[l_w_ac].zam04 = 'Y' THEN
                CALL cl_set_comp_entry("zam05,zam07,zam08", TRUE)
           END IF
      WHEN "query_sum"
           IF g_zan[l_w_ac].zan04 = 'Y' THEN
                CALL cl_set_comp_entry("gzal04", TRUE)
           END IF
      WHEN "query_layout"
           IF l_w_ac <> 7 OR INFIELD(out5) THEN
                CALL cl_set_comp_entry("out2,out3,out4", TRUE)
           END IF
   END CASE
END FUNCTION
 
FUNCTION p_query_set_no_entry_b()
   CASE g_page_choice
      WHEN "query_field"
           IF cl_null(g_zat[l_w_ac].zat04) THEN
              CALL cl_set_comp_entry("zat05,zat06", FALSE)
           ELSE
              IF g_zat[l_w_ac].zat05 = 'N' THEN
                   CALL cl_set_comp_entry("zat06", FALSE)
              END IF
           END IF
           IF cl_null(g_sum_field[g_zat[l_w_ac].zat02]) THEN
               CALL cl_set_comp_entry("zat07,zat08,zat09", FALSE)
           ELSE
               IF g_zat[l_w_ac].zat07 = 'N' THEN
                    CALL cl_set_comp_entry("zat08,zat09", FALSE)
               END IF
           END IF
      WHEN "query_group"
           IF g_zam[l_w_ac].zam04 = 'N' THEN
                CALL cl_set_comp_entry("zam05", FALSE)
           END IF
      WHEN "query_sum"
           IF g_zan[l_w_ac].zan04 = 'N' THEN
                CALL cl_set_comp_entry("gzal04", FALSE)
           END IF
      WHEN "query_layout"
           IF (INFIELD(out2) OR INFIELD(out3) OR INFIELD(out4))
           AND l_w_ac = 7 
           THEN
                CALL cl_set_comp_entry("out2,out3,out4", FALSE)
           END IF
   END CASE
END FUNCTION
 
FUNCTION p_query_wizard(p_cmd)               # SQL 自動精靈
DEFINE p_cmd         LIKE type_file.chr1
 
    OPEN WINDOW p_wizard_w WITH FORM "azz/42f/p_sql_wizard" 
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
    CALL cl_load_style_list(NULL)
    CALL cl_ui_locale("p_sql_wizard")
 
   
   #IF p_cmd = 'a' OR (p_cmd = 'u' AND g_zak.zak02 IS NOT NULL) THEN
    IF p_cmd = 'a' THEN
         LET g_zak.zak06 = "N"
         CALL p_wizard_select(p_cmd)
         IF g_wizard_choice = "exit" THEN
              CLOSE WINDOW  p_wizard_w
              RETURN
         END IF
    END IF
    CALL cl_set_comp_visible("page03", FALSE)
 
    CALL g_zaq.clear()
    CALL g_zart.clear()
    CALL g_zar.clear()
    CALL g_zas.clear()
    LET g_zaq_cnt = g_zaq.getLength()
    LET g_zar_cnt = g_zar.getLength()
    LET g_zart_cnt = g_zart.getLength()
    LET g_zas_cnt = g_zas.getLength()
    LET g_swe01 = ""
    IF p_cmd = 'u' THEN
       CALL p_wizard_show()
    END IF
 
    CALL p_wizard_menu()
 
    IF g_wizard_choice != "wizard_finish" AND p_cmd = 'a' THEN
 
      LET g_zak.zak06 = 'N' 
       
      #FUN-750084
      DELETE FROM zaq_file WHERE zaq01 = g_zai.zai01 AND zaq05 = g_zai.zai05
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zaq_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         RETURN
      END IF
      DELETE FROM zar_file WHERE zar01 = g_zai.zai01 AND zar05 = g_zai.zai05
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zar_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         RETURN
      END IF
      DELETE FROM zas_file WHERE zas01 = g_zai.zai01 AND zas11 = g_zai.zai05
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zas_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         RETURN
      END IF
      #END FUN-750084
    END IF
    CALL cl_set_comp_visible("page03", TRUE)
    CLOSE WINDOW  p_wizard_w
END FUNCTION 
 
FUNCTION p_wizard_menu()
DEFINE l_cnt         LIKE type_file.num5
 
   LET g_wizard_choice = "wizard_table"
 
   WHILE TRUE
       IF g_wizard_choice <> "exit" AND g_wizard_choice <> 'wizard_table'
       THEN
           CALL p_wizard_zaq_b_fill()
       END IF
 
       CALL p_wizard_page_show()
 
       CASE g_wizard_choice
         WHEN "wizard_table"       
              CALL p_wizard_table()
 
         WHEN "wizard_field"       
              CALL p_wizard_field()
 
         WHEN "wizard_field_dis"       
              CALL p_wizard_field_dis()
 
         WHEN "wizard_cond"   
              CALL p_wizard_condition()
 
         WHEN "wizard_summ"     
              CALL p_wizard_summary()
 
         WHEN "help"                            # H.求助
            CALL cl_show_help()
            
         WHEN "wizard_finish"                   # 完成
            EXIT WHILE
 
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
 
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
 
       END CASE
   END WHILE
 
END FUNCTION 
 
FUNCTION p_wizard_show()
 
   CALL p_wizard_zaq_b_fill()
   CALL p_wizard_zart_b_fill()
   CALL p_wizard_zar_b_fill()
   CALL p_wizard_zas_b_fill()
 
END FUNCTION
 
FUNCTION p_wizard_select(p_cmd)
DEFINE p_cmd        LIKE type_file.chr1
 
   IF p_cmd = 'a' THEN
      CALL cl_set_comp_visible("g02", FALSE)
      LET g_swa01 = '1'
      DISPLAY g_swa01 TO swa01
   ELSE
      CALL cl_set_comp_visible("g01", FALSE)
      LET g_swa02 = '1'
      DISPLAY g_swa02 TO swa02
   END IF
   CALL cl_set_comp_visible("page01,page02,page04,page05,page06", FALSE)
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   INPUT g_swa01,g_swa02  WITHOUT DEFAULTS FROM swa01,swa02
   
     AFTER INPUT
        IF g_swa01 ='2' THEN
           LET g_wizard_choice="exit"
        ELSE
           IF g_wizard_choice = "wizard_table"  THEN
              LET g_zak.zak06 = "Y"
           END IF
        END IF
   
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
   
     ON ACTION CONTROLG
         CALL cl_cmdask()
   
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
   
     ON ACTION about         #MOD-4C0121
        CALL cl_about()      #MOD-4C0121
   
     ON ACTION help          #MOD-4C0121
        CALL cl_show_help()  #MOD-4C0121
   
     ON ACTION exit                             # Esc.結束
        LET g_wizard_choice="exit"
        ACCEPT INPUT 
   
     ON ACTION cancel2
        LET INT_FLAG=FALSE 		#MOD-570244	mars
        LET g_wizard_choice="exit"
        ACCEPT INPUT 
   
     ON ACTION wnext
        LET g_wizard_choice="wizard_table"
        ACCEPT INPUT
 
   END INPUT 
   CALL cl_set_act_visible("accept,cancel", TRUE)
   CALL cl_set_comp_visible("g01,g02,page01,page02,page04,page05,page06", TRUE)
  
   IF g_zak.zak06 = 'N' THEN
      #FUN-750084
      DELETE FROM zaq_file WHERE zaq01=g_zai.zai01 AND zaq05=g_zai.zai05
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zaq_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         RETURN
      END IF
      DELETE FROM zar_file WHERE zar01=g_zai.zai01 AND zar05=g_zai.zai05
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zar_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         RETURN
      END IF
      DELETE FROM zas_file WHERE zas01=g_zai.zai01 AND zas11=g_zai.zai05
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zas_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         RETURN
      END IF
      #END FUN-750084
   END IF
END FUNCTION
 
FUNCTION p_wizard_page_show()
 
   CALL cl_set_comp_visible("page01,page02,page04,page05,page06", FALSE)
   CASE g_wizard_choice
     WHEN "wizard_table"       
          CALL cl_set_comp_visible("page01", TRUE)
 
     WHEN "wizard_field"       
          CALL cl_set_comp_visible("page02", TRUE)
 
     WHEN "wizard_field_dis"       
          CALL cl_set_comp_visible("page06", TRUE)
 
     WHEN "wizard_cond"   
          CALL cl_set_comp_visible("page04", TRUE)
 
     WHEN "wizard_summ"     
          CALL cl_set_comp_visible("page05", TRUE)
   END CASE
END FUNCTION
 
FUNCTION p_wizard_table()
DEFINE  l_allow_insert  LIKE type_file.num5    #No.FUN-680135      SMALLINT
DEFINE  l_allow_delete  LIKE type_file.num5    #No.FUN-680135      SMALLINT
DEFINE  l_cnt           LIKE type_file.num10
DEFINE  l_i             LIKE type_file.num10,
        p_cmd           LIKE type_file.chr1    # 處理狀態          #No.FUN-680135 VARCHAR(1)
DEFINE  l_status        LIKE type_file.num5
DEFINE  l_lock_sw       LIKE type_file.chr1    # 單身鎖住否
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    LET g_forupd_sql= "SELECT zaq03,zaq02,zaq04  FROM zaq_file ",
                      "  WHERE zaq01='",g_zai.zai01 CLIPPED,"' ",
                      "   AND zaq05='",g_zai.zai05 CLIPPED,"' ",  #FUN-750084
                      "   AND zaq02 = ? FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE zaq_bcl CURSOR FROM g_forupd_sql     
 
    LET l_w_ac = 1
    CALL cl_set_act_visible("accept,cancel", FALSE)
    INPUT ARRAY g_zaq WITHOUT DEFAULTS FROM s_zaq.*
              ATTRIBUTE(COUNT= g_zaq_cnt,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_zaq_cnt != 0 THEN
            CALL fgl_set_arr_curr(l_w_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_w_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         IF g_zaq_cnt >= l_w_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_zaq_t.* = g_zaq[l_w_ac].*    #BACKUP
            OPEN zaq_bcl USING g_zaq[l_w_ac].zaq02
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN zaq_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH zaq_bcl INTO g_zaq[l_w_ac].zaq03,g_zaq[l_w_ac].zaq02,
                                  g_zaq[l_w_ac].zaq04
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_zaq_t.zaq02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
         IF l_w_ac = 1 THEN
            CALL cl_set_comp_entry("zaq03", FALSE)
         END IF
 
      BEFORE INSERT
         LET p_cmd='a'
         INITIALIZE g_zaq[l_w_ac].* TO NULL       #900423
         LET g_zaq[l_w_ac].zaq03 = 'N'
         LET g_zaq_t.* = g_zaq[l_w_ac].*          #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         IF l_w_ac = 1 THEN
            CALL cl_set_comp_entry("zaq03", FALSE)
         END IF
      
 
 
      AFTER FIELD zaq02
         IF g_zaq[l_w_ac].zaq02 IS NOT NULL THEN
            IF NOT p_query_tab(g_zaq[l_w_ac].zaq02) THEN
               DISPLAY '' TO FORMONLY.gat03
               NEXT FIELD zaq02
            END IF
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_zaq[l_w_ac].zaq02 != g_zaq_t.zaq02) THEN
               SELECT COUNT(*) INTO l_cnt FROM zaq_file 
                WHERE zaq02 = g_zaq[l_w_ac].zaq02 
                  AND zaq01 = g_zai.zai01 
                  AND zaq05 = g_zai.zai05                           #FUN-750084
               IF l_cnt > 0 THEN                  # Duplicated
                  CALL cl_err(g_zaq[l_w_ac].zaq02,-239,0)
                  NEXT FIELD zaq02
               END IF
               SELECT gat03 INTO g_zaq[l_w_ac].gat03 FROM gat_file 
                WHERE gat01=g_zaq[l_w_ac].zaq02 AND gat02=g_lang
            END IF
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_wizard_choice="exit"
            CANCEL INSERT
            EXIT INPUT
         END IF
         FOR l_i = g_zaq_cnt+1 TO l_w_ac+1 STEP -1
             IF l_w_ac <> l_i THEN
                UPDATE zaq_file SET zaq04 = l_i
                 WHERE zaq04 = g_zaq[l_i].zaq04 
                   AND zaq01 = g_zai.zai01 AND zaq05 = g_zai.zai05  #FUN-750084
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","zaq_file",g_zai.zai01,g_zaq[l_i].zaq04,SQLCA.sqlcode,"","",0)
                   CANCEL INSERT
                END IF
                LET g_zaq[l_i].zaq04 = l_i
                DISPLAY g_zaq[l_i].zaq04 TO zaq04
             END IF
         END FOR
         LET g_zaq[l_w_ac].zaq04 = l_w_ac
         INSERT INTO zaq_file(zaq01,zaq02,zaq03,zaq04,zaq05) 
              VALUES (g_zai.zai01,g_zaq[l_w_ac].zaq02,g_zaq[l_w_ac].zaq03,g_zaq[l_w_ac].zaq04,g_zai.zai05) #FUN-750084
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","zaq_file",g_zai.zai01,g_zaq[l_w_ac].zaq02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
            CANCEL INSERT
         ELSE
            LET g_zaq_cnt = g_zaq_cnt + 1
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF (NOT cl_null(g_zaq_t.zaq02))  THEN
            SELECT COUNT(*) INTO l_cnt FROM zar_file 
             WHERE zar02 = g_zaq_t.zaq02 AND zar01 = g_zai.zai01
               AND zar05 = g_zai.zai05                            #FUN-750084
            IF l_cnt > 0 THEN
               CALL cl_err(g_zaq_t.zaq02 CLIPPED,"azz-244",0)
               LET g_zaq[l_w_ac].* = g_zaq_t.*
               CANCEL DELETE
               NEXT FIELD zaq02
            END IF
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM zaq_file 
             WHERE zaq01 = g_zai.zai01 AND zaq02 = g_zaq[l_w_ac].zaq02  
               AND zaq05 = g_zai.zai05                            #FUN-750084 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","zaq_file",g_zai.zai01,g_zaq[l_w_ac].zaq02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_zaq_cnt = g_zaq_cnt-1
            LET p_cmd = 'd'
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_zaq[l_w_ac].* = g_zaq_t.*
            LET g_wizard_choice="exit"
            CLOSE zaq_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zaq[l_w_ac].zaq02,-263,1)
            LET g_zaq[l_w_ac].* = g_zaq_t.*
         ELSE
            IF g_zaq_t.zaq02 != g_zaq[l_w_ac].zaq02 THEN
               SELECT COUNT(*) INTO l_cnt FROM zar_file
                  WHERE zar01 = g_zai.zai01 AND zar02= g_zaq_t.zaq02 
                    AND zar05 = g_zai.zai05                          #FUN-750084
               IF l_cnt > 0 THEN
                  CALL cl_err(g_zaq_t.zaq02 CLIPPED,"azz-244",0)
                  LET g_zaq[l_w_ac].* = g_zaq_t.*
                  NEXT FIELD zaq02
               END IF
            END IF
            UPDATE zaq_file SET zaq02 = g_zaq[l_w_ac].zaq02,
                                zaq03 = g_zaq[l_w_ac].zaq03,
                                zaq04 = g_zaq[l_w_ac].zaq04
             WHERE zaq01 = g_zai.zai01 AND zaq02 = g_zaq_t.zaq02 
               AND zaq05 = g_zai.zai05                               #FUN-750084 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","zaq_file",g_zai.zai01,g_zaq_t.zaq02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_zaq[l_w_ac].* = g_zaq_t.*
               ROLLBACK WORK
            END IF
         END IF
         COMMIT WORK
 
      AFTER ROW
         LET l_w_ac = ARR_CURR()
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_zaq[l_w_ac].* = g_zaq_t.*
            END IF
            LET g_wizard_choice="exit"
            CLOSE zaq_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF p_cmd = 'd' THEN
            FOR l_i = l_w_ac TO g_zaq_cnt
                   IF l_i = 1 THEN
                      LET g_zaq[l_i].zaq03 = 'N'
                   END IF
                   UPDATE zaq_file SET zaq04 = l_i,zaq03=g_zaq[l_i].zaq03
                    WHERE zaq01 = g_zai.zai01 AND zaq04 = g_zaq[l_i].zaq04 
                      AND zaq05 = g_zai.zai05                     #FUN-750084
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","zaq_file",g_zai.zai01,g_zaq[l_i].zaq04,SQLCA.sqlcode,"","",0)
                   END IF
                   LET g_zaq[l_i].zaq04 = l_i
                   DISPLAY g_zaq[l_i].zaq04 TO zaq04
            END FOR
          END IF
         CALL g_zaq.deleteElement(g_zaq_cnt+1)
         IF l_w_ac = 1 THEN
            CALL cl_set_comp_entry("zaq03", TRUE)
         END IF
         COMMIT WORK
         CLOSE zaq_bcl
 
      ON ACTION CONTROLP
         CALL cl_set_act_visible("accept,cancel", TRUE)
         CASE
             WHEN INFIELD(zaq02)
               CALL cl_init_qry_var()
               #No.FUN-810062
               LET g_qryparam.form = "q_zta3"
               LET g_qryparam.default1 = g_zaq[l_w_ac].zaq02
               LET g_qryparam.default2 = NULL
               LET g_qryparam.arg1 = g_lang CLIPPED
               #CASE g_db_type                                             
               #  WHEN "MSV"
               #   LET g_qryparam.arg2 = FGL_GETENV("MSSQLAREA") CLIPPED,"_ds"
               #  OTHERWISE
                  LET g_qryparam.arg2 = 'ds'
               #END CASE
               #END No.FUN-810062
 
               CALL cl_create_qry() RETURNING g_zaq[l_w_ac].zaq02,g_zaq[l_w_ac].gat03
               DISPLAY g_zaq[l_w_ac].zaq02 TO zaq02
               DISPLAY g_zaq[l_w_ac].gat03 TO gat03
               
         END CASE
         CALL cl_set_act_visible("accept,cancel", FALSE)
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION exit                             # Esc.結束
         LET g_wizard_choice="exit"
         EXIT INPUT
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_wizard_choice="exit"
         EXIT INPUT
 
      ON ACTION cancel2
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_wizard_choice="exit"
         EXIT INPUT
 
      ON ACTION wnext
         LET g_wizard_choice="wizard_field"
         ACCEPT INPUT
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
   END INPUT
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_wizard_field()
DEFINE  l_allow_insert  LIKE type_file.num5    #No.FUN-680135      SMALLINT
DEFINE  l_allow_delete  LIKE type_file.num5    #No.FUN-680135      SMALLINT
DEFINE  l_cnt           LIKE type_file.num10
DEFINE  l_i             LIKE type_file.num10,
        p_cmd           LIKE type_file.chr1    # 處理狀態          #No.FUN-680135 VARCHAR(1)
DEFINE  l_str           STRING
DEFINE  ls_sql          STRING
DEFINE  l_status        LIKE type_file.num5
DEFINE  l_tok           base.StringTokenizer
DEFINE  l_lock_sw       LIKE type_file.chr1    # 單身鎖住否
DEFINE  l_zar03         LIKE zar_file.zar03
DEFINE  l_zar04         LIKE zar_file.zar04
DEFINE  l_tmp           STRING
DEFINE  l_zar_cnt       LIKE type_file.num5
DEFINE  l_zar           DYNAMIC ARRAY OF RECORD 
         zar03           LIKE zar_file.zar03,
         zar04           LIKE zar_file.zar04
                        END RECORD
DEFINE  buf             base.StringBuffer
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    LET l_w_ac = 1
 
 
    LET g_forupd_sql= "SELECT zar02,zar03  FROM zar_file ",
                      " WHERE zar01 = '",g_zai.zai01 CLIPPED,"' ",
                      "   AND zar05 = '",g_zai.zai05 CLIPPED,"' ", #FUN-750084
                      "   AND zar02 = ? ",
                      " ORDER BY zar03 " 
    DECLARE zart_bcl CURSOR FROM g_forupd_sql     
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    INPUT ARRAY g_zart WITHOUT DEFAULTS FROM s_zart.*
              ATTRIBUTE(COUNT= g_zart_cnt,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_zart_cnt != 0 THEN
            CALL fgl_set_arr_curr(l_w_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_w_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         IF g_zart_cnt >= l_w_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_zart_t.* = g_zart[l_w_ac].*    #BACKUP
            INITIALIZE g_zart[l_w_ac].* TO NULL       #900423
            #OPEN zart_bcl USING g_zart_t.zar02t
            #IF SQLCA.sqlcode THEN
            #   CALL cl_err("OPEN zart_bcl:", STATUS, 1)
            #   LET l_lock_sw = 'Y'
            #ELSE
               FOREACH zart_bcl USING g_zart_t.zar02t INTO g_zart[l_w_ac].zar02t,l_zar03
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_zart_t.zar02t,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  IF cl_null(g_zart[l_w_ac].zar03t) THEN
                      LET g_zart[l_w_ac].zar03t = l_zar03 CLIPPED
                  ELSE
                      LET g_zart[l_w_ac].zar03t = g_zart[l_w_ac].zar03t CLIPPED,
                                                  ",",l_zar03 CLIPPED
                  END IF
               END FOREACH
            #END IF
 
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET p_cmd='a'
         INITIALIZE g_zart[l_w_ac].* TO NULL       #900423
         LET g_zart_t.* = g_zart[l_w_ac].*          #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
 
      AFTER FIELD zar02t
         IF g_zart[l_w_ac].zar02t IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_zart[l_w_ac].zar02t != g_zart_t.zar02t) THEN
               SELECT COUNT(*) INTO l_cnt FROM zar_file 
                WHERE zar01 = g_zai.zai01 AND zar02 = g_zart[l_w_ac].zar02t
                  AND zar05 = g_zai.zai05                           #FUN-750084
               IF l_cnt > 0 THEN                  # Duplicated
                  CALL cl_err(g_zart[l_w_ac].zar02t,-239,0)
                  NEXT FIELD zar02t
               END IF
            END IF
            IF g_zart[l_w_ac].zar03t IS NOT NULL THEN
               LET l_status = p_wizard_check_field(g_zart[l_w_ac].zar03t CLIPPED,g_zart[l_w_ac].zar02t CLIPPED,'Y')
               IF NOT l_status THEN
                  NEXT FIELD zar02t
               END IF
            END IF
         END IF
 
      BEFORE FIELD zar03t
         IF g_zart[l_w_ac].zar02t IS NULL THEN
            CALL cl_err('','aws-067',0)
            NEXT FIELD zar02t
         END IF
 
      AFTER FIELD zar03t
         DISPLAY g_zart[l_w_ac].zar03t TO zart03t
         IF g_zart[l_w_ac].zar03t IS NOT NULL THEN
            IF g_zart[l_w_ac].zar03t != g_zart_t.zar03t OR g_zart_t.zar03t IS NULL THEN
               LET l_status = p_wizard_check_field(g_zart[l_w_ac].zar03t CLIPPED,g_zart[l_w_ac].zar02t CLIPPED,'Y')
               IF NOT l_status THEN
                  NEXT FIELD zar03t
               END IF
            END IF 
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_wizard_choice="exit"
            EXIT INPUT 
         END IF
         LET l_tmp = g_zart[l_w_ac].zar03t CLIPPED
         IF l_tmp.getIndexOf(',',1) > 0 THEN
            LET l_tok = base.StringTokenizer.createExt(l_tmp,",","",TRUE)
            SELECT MAX(zar04)+1 INTO l_zar_cnt FROM zar_file
             WHERE zar01 = g_zai.zai01 AND zar05 = g_zai.zai05     #FUN-750084
            IF cl_null(l_zar_cnt) OR l_zar_cnt = 0 THEN
               LET l_zar_cnt = 1
            END IF
            WHILE l_tok.hasMoreTokens()
                LET l_zar03=l_tok.nextToken()
                INSERT INTO zar_file (zar01,zar02,zar03,zar04,zar05) 
                        VALUES (g_zai.zai01,g_zart[l_w_ac].zar02t,l_zar03,l_zar_cnt,g_zai.zai05) #FUN-750084
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","zar_file",g_zai.zai01,g_zart[l_w_ac].zar02t,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                   EXIT WHILE
                ELSE
                   LET l_zar_cnt = l_zar_cnt + 1
                END IF
            END WHILE
         ELSE 
             INSERT INTO zar_file (zar01,zar02,zar03,zar04,zar05) 
                     VALUES (g_zai.zai01,g_zart[l_w_ac].zar02t,g_zart[l_w_ac].zar03t,l_zar_cnt,g_zai.zai05)  #FUN-750084
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","zar_file",g_zai.zai01,g_zart[l_w_ac].zar02t,SQLCA.sqlcode,"","",0)    #No.FUN-660081
             END IF
         END IF
         LET g_zart_cnt = g_zart_cnt + 1
 
      BEFORE DELETE                            #是否取消單身
         IF (NOT cl_null(g_zart_t.zar02t))  THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
 
            DELETE FROM zar_file
             WHERE zar01 = g_zai.zai01 AND zar02 = g_zart[l_w_ac].zar02t
               AND zar05 = g_zai.zai05                             #FUN-750084
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","zar_file",g_zai.zai01,g_zart[l_w_ac].zar02t,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               CANCEL DELETE
            END IF
            LET g_zart_cnt = g_zart_cnt-1
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_zart[l_w_ac].* = g_zart_t.*
            LET g_wizard_choice="exit"
            CLOSE zart_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zaq[l_w_ac].zaq02,-263,1)
            LET g_zaq[l_w_ac].* = g_zaq_t.*
         ELSE
            LET l_zar_cnt = 0
            LET l_tmp = g_zart[l_w_ac].zar03t CLIPPED
            IF l_tmp.getIndexOf(',',1) > 0 THEN
               LET l_tok = base.StringTokenizer.createExt(l_tmp,",","",TRUE)
               WHILE l_tok.hasMoreTokens()
                   LET l_tmp=l_tok.nextToken()
                   LET l_zar_cnt = l_zar_cnt + 1 
                   LET l_zar03 = l_tmp 
                   LET l_zar04 = 0
                   SELECT zar04 INTO l_zar04 FROM zar_file
                    WHERE zar01 = g_zai.zai01 AND zar02 = g_zart_t.zar02t
                      AND zar05 = g_zai.zai05 AND zar03 = l_zar03   #FUN-750084
                   IF cl_null(l_zar04) OR l_zar04 = 0 THEN
                      SELECT MAX(zar04)+1 INTO l_zar04 FROM zar_file
                       WHERE zar01 = g_zai.zai01 
                         AND zar05 = g_zai.zai05                    #FUN-750084
                   END IF
                   LET l_zar[l_zar_cnt].zar03 = l_zar03
                   LET l_zar[l_zar_cnt].zar04 = l_zar04
               END WHILE
            ELSE
               LET l_zar_cnt = l_zar_cnt + 1 
               LET l_zar[l_zar_cnt].zar03 = l_zar03
               LET l_zar[l_zar_cnt].zar04 = l_zar04
            END IF
            DELETE FROM zar_file 
             WHERE zar01 = g_zai.zai01 AND zar02=g_zart[l_w_ac].zar02t
               AND zar05 = g_zai.zai05                             #FUN-750084
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","zar_file",g_zai.zai01,g_zart[l_w_ac].zar02t,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
            ELSE
               FOR l_i = 1 TO l_zar_cnt 
                  INSERT INTO zar_file (zar01,zar02,zar03,zar04,zar05) 
                          VALUES (g_zai.zai01,g_zart[l_w_ac].zar02t,l_zar[l_i].zar03,l_zar[l_i].zar04,g_zai.zai05)  #FUN-750084
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("ins","zar_file",g_zai.zai01,g_zart[l_w_ac].zar02t,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                     ROLLBACK WORK
                     EXIT FOR
                  END IF
               END FOR
            END IF
         END IF
         COMMIT WORK
 
      AFTER ROW
         LET l_w_ac = ARR_CURR()
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_zart[l_w_ac].* = g_zart_t.*
            END IF
            LET g_wizard_choice="exit"
            CLOSE zart_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CALL g_zart.deleteElement(g_zart_cnt+1)
         COMMIT WORK
         CLOSE zart_bcl
 
      ON ACTION CONTROLP
         CALL cl_set_act_visible("accept,cancel", TRUE)
         CASE
             WHEN INFIELD(zar03t)
               CALL q_gaq1(TRUE,TRUE,g_zart[l_w_ac].zar03t,g_zart[l_w_ac].zar02t) 
                    RETURNING g_zart[l_w_ac].zar03t
               DISPLAY g_zart[l_w_ac].zar03t TO zar03t
         END CASE
         CALL cl_set_act_visible("accept,cancel", FALSE)
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION exit                             # Esc.結束
         LET g_wizard_choice="exit"
         EXIT INPUT
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_wizard_choice="exit"
         EXIT INPUT
 
      ON ACTION cancel2
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_wizard_choice="exit"
         EXIT INPUT
 
      ON ACTION wnext
         LET g_wizard_choice="wizard_field_dis"
         ACCEPT INPUT
 
      ON ACTION back
         LET g_wizard_choice="wizard_table"
         ACCEPT INPUT
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
   END INPUT
   CALL cl_set_act_visible("accept,cancel", TRUE)
   #CALL p_wizard_zart_b_fill()
   CALL p_wizard_zar_b_fill()
 
END FUNCTION
 
FUNCTION p_wizard_field_dis()
DEFINE  l_i                   LIKE type_file.num5
DEFINE  l_zar                 RECORD 
           zar02               LIKE zar_file.zar02,
           zar03               LIKE zar_file.zar03,
           gaq03               LIKE gaq_file.gaq03
                              END RECORD
    LET l_w_ac = 1
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_zar TO s_zar.* ATTRIBUTE(COUNT=g_zar_cnt,UNBUFFERED)
      BEFORE ROW
         LET l_w_ac = ARR_CURR()
         CALL cl_set_action_active("up,down", TRUE)
         IF l_w_ac = 1 THEN
            CALL cl_set_action_active("up", FALSE)
         END IF
         IF l_w_ac = g_zar_cnt THEN
            CALL cl_set_action_active("down", FALSE)
         END IF
 
         CALL cl_show_fld_cont()
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION exit                             # Esc.結束
         LET g_wizard_choice="exit"
         EXIT DISPLAY 
 
      ON ACTION up
         LET l_zar.* = g_zar[l_w_ac-1].*
         LET g_zar[l_w_ac-1].* = g_zar[l_w_ac].*
         LET g_zar[l_w_ac].* = l_zar.*
         LET l_w_ac = l_w_ac - 1
         CALL fgl_set_arr_curr(l_w_ac)
         IF l_w_ac = 1 THEN
            CALL cl_set_action_active("up", FALSE)
         END IF
 
      ON ACTION down
         LET l_zar.* = g_zar[l_w_ac+1].*
         LET g_zar[l_w_ac+1].* = g_zar[l_w_ac].*
         LET g_zar[l_w_ac].* = l_zar.*
         LET l_w_ac = l_w_ac + 1
         CALL fgl_set_arr_curr(l_w_ac)
         IF l_w_ac = g_zar_cnt THEN
            CALL cl_set_action_active("down", FALSE)
         END IF
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_wizard_choice="exit"
         EXIT DISPLAY
 
      ON ACTION cancel2
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_wizard_choice="exit"
         EXIT DISPLAY
 
      ON ACTION wnext
         LET g_wizard_choice="wizard_cond"
         EXIT DISPLAY
 
      ON ACTION back
         LET g_wizard_choice="wizard_field"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   IF g_wizard_choice != "exit" THEN
      DELETE FROM zar_file 
       WHERE zar01 = g_zai.zai01 AND zar05 = g_zai.zai05          #FUN-750084
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zar_file",g_zai.zai01,g_zart[l_w_ac].zar02t,SQLCA.sqlcode,"","",0)    #No.FUN-660081
      ELSE
         FOR l_i = 1 TO g_zar_cnt 
             INSERT INTO zar_file (zar01,zar02,zar03,zar04,zar05) 
                     VALUES (g_zai.zai01,g_zar[l_i].zar02,g_zar[l_i].zar03,l_i,g_zai.zai05)        #FUN-750084
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","zar_file",g_zai.zai01,g_zar[l_i].zar02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                EXIT FOR
             END IF
         END FOR
      END IF
   END IF
 
END FUNCTION
 
FUNCTION p_wizard_condition()
DEFINE  p_cmd           LIKE type_file.chr1    # 處理狀態
DEFINE  l_allow_insert  LIKE type_file.num5    #No.FUN-680135      SMALLINT
DEFINE  l_allow_delete  LIKE type_file.num5    #No.FUN-680135      SMALLINT
DEFINE  l_zas_cnt       LIKE type_file.num10
DEFINE  l_cnt           LIKE type_file.num10
DEFINE  l_i             LIKE type_file.num10
DEFINE  l_str           STRING
DEFINE  l_str2          STRING
DEFINE  l_check         LIKE type_file.chr1
DEFINE  l_zar03         LIKE type_file.chr1000
DEFINE  l_p             LIKE type_file.num5
DEFINE  l_status        LIKE type_file.num5
DEFINE  l_lock_sw       LIKE type_file.chr1    # 單身鎖住否
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    LET l_zas_cnt = g_zas.getLength()
    LET l_w_ac = 1
 
    LET g_forupd_sql= "SELECT zas02,zas03,zas04,zas05,zas06,zas07,zas08,zas09,",
                      " zas10 FROM zas_file ",
                      " WHERE zas01='",g_zai.zai01 CLIPPED,"' AND zas02 = ? ",
                      "   AND zas11='",g_zai.zai05 CLIPPED,"' "    #FUN-750084
    DECLARE zas_bcl CURSOR FROM g_forupd_sql     
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
 
    INPUT ARRAY g_zas WITHOUT DEFAULTS FROM s_zas.*
              ATTRIBUTE(COUNT= l_zas_cnt,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF l_zas_cnt != 0 THEN
            CALL fgl_set_arr_curr(l_w_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_w_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         IF g_zas_cnt >= l_w_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_zas_t.* = g_zas[l_w_ac].*    #BACKUP
            OPEN zas_bcl USING g_zas[l_w_ac].zas02
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN zas_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH zas_bcl INTO g_zas[l_w_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_zas_t.zas02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
         IF g_zas[l_w_ac].zas06 = '7'  OR
            g_zas[l_w_ac].zas06 = '8'  OR
            g_zas[l_w_ac].zas06 = '9'  OR 
            g_zas[l_w_ac].zas06 = '10' OR
            g_zas[l_w_ac].zas06 = '11' OR
            g_zas[l_w_ac].zas06 = '12' 
         THEN
             CALL cl_set_comp_entry("zas07", FALSE)
             IF g_zas[l_w_ac].zas06='11' OR g_zas[l_w_ac].zas06='12' THEN
                  CALL cl_set_comp_entry("zas08", FALSE)
             ELSE
                  CALL cl_set_comp_entry("zas08", TRUE)
             END IF
         ELSE
             CALL cl_set_comp_entry("zas07", TRUE)
             CALL cl_set_comp_entry("zas08", TRUE)
         END IF
 
      BEFORE INSERT
         LET p_cmd='a'
         INITIALIZE g_zas[l_w_ac].* TO NULL       #900423
 
        #SELECT MAX(zas04)+1 INTO g_zas[l_w_ac].zas04 FROM zas_file 
        #IF g_zas[l_w_ac].zas04 IS NULL THEN
        #   LET g_zas[l_w_ac].zas04 = 1
        #END IF
 
         LET g_zas_t.* = g_zas[l_w_ac].*          #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
 
      AFTER FIELD zas04
         IF g_zas[l_w_ac].zas04 IS NOT NULL THEN
            IF g_zas[l_w_ac].zas05 IS NOT NULL THEN
               LET l_status = p_wizard_check_field(g_zas[l_w_ac].zas05 CLIPPED,g_zas[l_w_ac].zas04 CLIPPED,'N')
               IF NOT l_status THEN
                  NEXT FIELD zas04
               END IF
            END IF
         END IF
 
      BEFORE FIELD zas05
         IF g_zas[l_w_ac].zas04 IS NULL THEN
            CALL cl_err('','aws-067',0)
            NEXT FIELD zas04
         END IF
 
      AFTER FIELD zas05
         IF g_zas[l_w_ac].zas05 IS NOT NULL THEN
            IF g_zas[l_w_ac].zas05 != g_zas_t.zas05 OR g_zas_t.zas05 IS NULL THEN
               LET l_status = p_wizard_check_field(g_zas[l_w_ac].zas05 CLIPPED,g_zas[l_w_ac].zas04 CLIPPED,'N')
               IF NOT l_status THEN
                  NEXT FIELD zas05
               END IF
            END IF
         END IF
 
      ON CHANGE zas06 
         IF g_zas[l_w_ac].zas06 = '7'  OR
            g_zas[l_w_ac].zas06 = '8'  OR
            g_zas[l_w_ac].zas06 = '9'  OR 
            g_zas[l_w_ac].zas06 = '10' OR
            g_zas[l_w_ac].zas06 = '11' OR
            g_zas[l_w_ac].zas06 = '12' 
         THEN
             CALL cl_set_comp_entry("zas07", FALSE)
             LET g_zas[l_w_ac].zas07 = ''
             IF g_zas[l_w_ac].zas06='11' OR g_zas[l_w_ac].zas06='12' THEN
                  CALL cl_set_comp_entry("zas08", FALSE)
                  LET g_zas[l_w_ac].zas08 = ''
             ELSE
                  CALL cl_set_comp_entry("zas08", TRUE)
             END IF
             DISPLAY BY NAME g_zas[l_w_ac].zas07,g_zas[l_w_ac].zas08
         ELSE
             CALL cl_set_comp_entry("zas07", TRUE)
             CALL cl_set_comp_entry("zas08", TRUE)
         END IF
 
      AFTER FIELD zas07
         IF g_zas[l_w_ac].zas07 IS NOT NULL THEN
            IF g_zas[l_w_ac].zas08 IS NOT NULL THEN
               LET l_status = p_wizard_check_field(g_zas[l_w_ac].zas08 CLIPPED,g_zas[l_w_ac].zas07 CLIPPED,'N')
               IF NOT l_status THEN
                  NEXT FIELD zas08
               END IF
            END IF
         END IF
 
      BEFORE FIELD zas08
         IF g_zas[l_w_ac].zas07 IS NOT NULL THEN
             CALL cl_set_action_active("controlp", TRUE)
         ELSE
             CALL cl_set_action_active("controlp", FALSE)
         END IF
 
      AFTER FIELD zas08
         IF g_zas[l_w_ac].zas08 IS NOT NULL THEN
            IF g_zas[l_w_ac].zas07 IS NOT NULL THEN
               LET l_status = p_wizard_check_field(g_zas[l_w_ac].zas08 CLIPPED,g_zas[l_w_ac].zas07 CLIPPED,'N')
               IF NOT l_status THEN
                  NEXT FIELD zas08
               END IF
            END IF
         END IF
         CALL cl_set_action_active("controlp", TRUE)
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_wizard_choice="exit"
            EXIT INPUT
         END IF
         FOR l_i = g_zas_cnt+1 TO l_w_ac+1 STEP -1
             IF l_w_ac <> l_i THEN
                UPDATE zas_file SET zas02 = l_i
                 WHERE zas01 = g_zai.zai01 AND zas02 = g_zas[l_i].zas02
                   AND zas11 = g_zai.zai05                       #FUN-750084
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","zas_file",g_zai.zai01,g_zas[l_i].zas02,SQLCA.sqlcode,"","",0)
                   CANCEL INSERT
                END IF
                LET g_zas[l_i].zas02 = l_i
                DISPLAY g_zas[l_i].zas02 TO zas02
             END IF
         END FOR
         LET g_zas[l_w_ac].zas02 = l_w_ac
         INSERT INTO zas_file(zas01,zas02,zas03,zas04,zas05,zas06,zas07,zas08,zas09,zas10,zas11)
         VALUES (g_zai.zai01,l_w_ac,g_zas[l_w_ac].zas03,g_zas[l_w_ac].zas04,
                 g_zas[l_w_ac].zas05,g_zas[l_w_ac].zas06,g_zas[l_w_ac].zas07,
                 g_zas[l_w_ac].zas08,g_zas[l_w_ac].zas09,g_zas[l_w_ac].zas10,g_zai.zai05)   #FUN-750084
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","zas_file",g_zai.zai01,g_zas[l_w_ac].zas02,SQLCA.sqlcode,"","",0)
         ELSE
            LET g_zas_cnt = g_zas_cnt + 1
         END IF
         
         #SELECT * INTO g_zas[l_w_ac].* FROM zas_file WHERE zas02 = l_w_ac 
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_zas[l_w_ac].* = g_zas_t.*
            LET g_wizard_choice="exit"
            CLOSE zas_bcl 
            ROLLBACK WORK
            EXIT INPUT
         END IF
         UPDATE zas_file 
            SET zas03 = g_zas[l_w_ac].zas03, zas04 = g_zas[l_w_ac].zas04,
                zas05 = g_zas[l_w_ac].zas05, zas06 = g_zas[l_w_ac].zas06,
                zas07 = g_zas[l_w_ac].zas07, zas08 = g_zas[l_w_ac].zas08,
                zas09 = g_zas[l_w_ac].zas09, zas10 = g_zas[l_w_ac].zas10
          WHERE zas01 = g_zai.zai01 AND zas02 = g_zas_t.zas02
            AND zas11 = g_zai.zai05                               #FUN-750084
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","zas_file",g_zai.zai01,g_zas_t.zas02,SQLCA.sqlcode,"","",0)
            LET g_zas[l_w_ac].* = g_zas_t.*
            ROLLBACK WORK
         END IF
         COMMIT WORK
 
      AFTER ROW
         LET l_w_ac = ARR_CURR()
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_zas[l_w_ac].* = g_zas_t.*
            END IF
            LET g_wizard_choice="exit"
            CLOSE zas_bcl 
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF p_cmd = 'd' THEN
            FOR l_i = l_w_ac TO g_zas_cnt
                   UPDATE zas_file SET zas02 = l_i
                    WHERE zas01 = g_zai.zai01 AND zas02 = g_zas[l_i].zas02
                      AND zas11 = g_zai.zai05                       #FUN-750084
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","zas_file",g_zai.zai01,g_zas[l_i].zas02,SQLCA.sqlcode,"","",0)
                   END IF
                   LET g_zas[l_i].zas02 = l_i
                   DISPLAY g_zas[l_i].zas02 TO zas02
            END FOR
          END IF
          CALL g_zas.deleteElement(g_zas_cnt+1)
          CLOSE zas_bcl 
          COMMIT WORK
          CALL cl_set_comp_entry("zas07", TRUE)
          CALL cl_set_comp_entry("zas08", TRUE)
 
      BEFORE DELETE                            #是否取消單身
         IF (NOT cl_null(g_zas_t.zas02))  THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
 
            DELETE FROM zas_file 
             WHERE zas01 = g_zai.zai01 AND zas02=g_zas[l_w_ac].zas02
               AND zas11 = g_zai.zai05                               #FUN-750084
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","zas_file",g_zai.zai01,g_zas[l_w_ac].zas02,SQLCA.sqlcode,"","",0)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET p_cmd = 'd'
            LET g_zas_cnt = g_zas_cnt-1
         END IF
         COMMIT WORK
 
      ON ACTION CONTROLP
         CALL cl_set_act_visible("accept,cancel", TRUE)
         CASE
             WHEN INFIELD(zas05)
               CALL q_gaq1(FALSE,TRUE,g_zas[l_w_ac].zas05,g_zas[l_w_ac].zas04)  RETURNING g_zas[l_w_ac].zas05
               DISPLAY g_zas[l_w_ac].zas05 TO zas05
             WHEN INFIELD(zas08)
               CALL q_gaq1(FALSE,TRUE,g_zas[l_w_ac].zas08,g_zas[l_w_ac].zas07)  RETURNING g_zas[l_w_ac].zas08
               DISPLAY g_zas[l_w_ac].zas08 TO zas08
         END CASE
         CALL cl_set_act_visible("accept,cancel", FALSE)
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION exit                             # Esc.結束
         LET g_wizard_choice="exit"
         EXIT INPUT
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_wizard_choice="exit"
         EXIT INPUT
 
      ON ACTION cancel2
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_wizard_choice="exit"
         EXIT INPUT
 
      ON ACTION back
         LET g_wizard_choice="wizard_field_dis"
         ACCEPT INPUT
 
      ON ACTION wnext
         LET g_wizard_choice="wizard_summ"
         ACCEPT INPUT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
   CALL cl_set_act_visible("accept,cancel", TRUE)
   CALL p_wizard_zas_b_fill()
END FUNCTION
 
FUNCTION p_wizard_summary()
 
    CALL p_wizard_swe01()
 
    LET g_swe01_t = g_swe01
 
    DISPLAY g_swe01 TO swe01
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    INPUT g_swe01  WITHOUT DEFAULTS FROM swe01
 
      AFTER INPUT
         IF g_wizard_choice = "wizard_finish" THEN
            IF g_swe01_t != g_swe01 THEN
               IF NOT cl_confirm('azz-251') THEN 
                  NEXT FIELD swe01
               ELSE
                  LET g_zak.zak06 = "N"
               END IF
            ELSE
               LET g_zak.zak06 = "Y"
            END IF
            IF NOT p_wizard_finish() THEN
               LET g_wizard_choice = "wizard_summ"
               NEXT FIELD swe01
            END IF
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION exit                             # Esc.結束
         LET g_wizard_choice="exit"
         ACCEPT INPUT 
 
      ON ACTION cancel2
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_wizard_choice="exit"
         ACCEPT INPUT 
 
      ON ACTION finish 
         LET g_wizard_choice="wizard_finish"
         ACCEPT INPUT 
 
      ON ACTION back
         LET g_wizard_choice="wizard_cond"
         ACCEPT INPUT 
 
   END INPUT 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION p_query_tab(p_tabname)
   DEFINE p_tabname    LIKE type_file.chr20,  #No.FUN-680130 VARCHAR(20)
          l_cnt        LIKE type_file.num5    #No.FUN-680130 SMALLINT
   DEFINE l_sql        STRING                 #No.FUN-810062 

   #---FUN-A90024---start-----
   #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
   #目前統一用sch_file紀錄TIPTOP資料結構
   ##FUN-5A0136
   #CASE g_db_type                             #FUN-7C0020
   #  WHEN "ORA"
   #      SELECT COUNT(*) INTO l_cnt FROM ALL_TABLES WHERE  #FUN-5A0136
   #      TABLE_NAME = UPPER(p_tabname) AND OWNER = 'DS'
   # 
   #  WHEN "IFX"
   #       SELECT COUNT(*) INTO l_cnt FROM ds:systables
   #        WHERE tabname = p_tabname
   #  #No.FUN-810062
   #  WHEN "MSV"
   #      LET l_sql = "SELECT COUNT(*) ",
   #                  "  FROM ",FGL_GETENV("MSSQLAREA") CLIPPED,"_ds.sys.objects",
   #                  " WHERE name = '",p_tabname CLIPPED,"'"
   #      PREPARE tab_precount FROM l_sql
   #      DECLARE tab_count CURSOR FOR tab_precount
   #      OPEN tab_count
   #      FETCH tab_count INTO l_cnt
   #  #END No.FUN-810062
   #END CASE
   ##END FUN-5A0136
   SELECT COUNT(*) INTO l_cnt FROM sch_file
     WHERE sch01 = p_tabname
   #---FUN-A90024---end-------
 
   IF l_cnt = 0 THEN
      CALL cl_err(p_tabname,NOTFOUND,0)
      RETURN 0
   ELSE
      RETURN 1
   END IF
END FUNCTION
 
FUNCTION p_wizard_zaq_b_fill()
DEFINE l_i           LIKE type_file.num5
DEFINE l_items       STRING
 
   CALL g_zaq.clear()
   LET g_forupd_sql= "SELECT zaq02,zaq03,zaq04  FROM zaq_file ",
                     " WHERE zaq01 = '",g_zai.zai01 CLIPPED,"' ",
                     "   AND zaq05 = '",g_zai.zai05 CLIPPED,"' ", #FUN-750084
                     " ORDER BY zaq04"
   DECLARE p_zaq2_cl CURSOR FROM g_forupd_sql     
   LET l_i = 1
   FOREACH p_zaq2_cl INTO g_zaq[l_i].zaq02,g_zaq[l_i].zaq03,g_zaq[l_i].zaq04
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF g_zaq[l_i].zaq02 IS NOT NULL THEN
          IF l_i = 1 THEN
             LET l_items = g_zaq[l_i].zaq02 CLIPPED
          ELSE
             LET l_items = l_items,",",g_zaq[l_i].zaq02 CLIPPED
          END IF
          SELECT gat03 INTO g_zaq[l_i].gat03 FROM gat_file 
           WHERE gat01=g_zaq[l_i].zaq02 AND gat02=g_lang
          LET l_i = l_i + 1
       ELSE 
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_zaq.deleteElement(l_i)
   LET g_zaq_cnt = l_i - 1
 
   IF g_zaq_cnt = 0 THEN
      CALL cl_err('','azz-243',1)
      LET g_wizard_choice = 'wizard_table'
      RETURN
   END IF
 
   LET l_items = l_items.toLowerCase()
   CALL cl_set_combo_items("zar02t",l_items,l_items)
   CALL cl_set_combo_items("zas04",l_items,l_items)
   CALL cl_set_combo_items("zas07",l_items,l_items)
   
END FUNCTION
 
FUNCTION p_wizard_zart_b_fill()
DEFINE l_i           LIKE type_file.num5
DEFINE l_j           LIKE type_file.num5
DEFINE l_items       STRING
DEFINE l_str         STRING
DEFINE l_tok         base.StringTokenizer
DEFINE l_tag         LIKE type_file.num5
DEFINE l_zar03         LIKE zar_file.zar03
 
   CALL g_zart.clear()
 
   LET g_forupd_sql= "SELECT unique zar02 FROM zar_file ",
                     " WHERE zar01 = '",g_zai.zai01 CLIPPED, "' ",
                     "   AND zar05 = '",g_zai.zai05 CLIPPED,"'"  #FUN-750084
   DECLARE p_zart_cl CURSOR FROM g_forupd_sql     
   
   LET g_forupd_sql= "SELECT zar03  FROM zar_file ",
                     " WHERE zar01 = '",g_zai.zai01 CLIPPED,"' AND zar02 = ? ",
                     "   AND zar05 = '",g_zai.zai05 CLIPPED,"' ", #FUN-750084
                     " ORDER BY zar03 "
   DECLARE p_zart2_cl CURSOR FROM g_forupd_sql     
   LET l_i   = 1
   FOREACH p_zart_cl INTO g_zart[l_i].zar02t
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF g_zart[l_i].zar02t IS NULL THEN
           EXIT FOREACH
       ELSE
          #OPEN p_zart2_cl USING g_zart[l_i].zar02t
           FOREACH p_zart2_cl USING g_zart[l_i].zar02t INTO l_zar03
               IF cl_null(g_zart[l_i].zar03t) THEN
                  LET g_zart[l_i].zar03t = l_zar03
                  LET l_j = 1
               ELSE
                  LET g_zart[l_i].zar03t = g_zart[l_i].zar03t CLIPPED,",",l_zar03 CLIPPED
               END IF
           END FOREACH
           LET l_i = l_i + 1
        END IF
   END FOREACH
   CALL g_zart.deleteElement(l_i)
   LET g_zart_cnt = l_i - 1
 
   IF g_zart_cnt = 0 AND g_wizard_choice <> "exit" 
      AND g_wizard_choice <> 'wizard_table' 
      AND g_wizard_choice <> 'wizard_field' 
   THEN
      CALL cl_err('','azz-245',1)
      LET g_wizard_choice = 'wizard_field'
   END IF
   
END FUNCTION
 
FUNCTION p_wizard_zar_b_fill()
DEFINE l_i           LIKE type_file.num5
DEFINE l_items       STRING
DEFINE l_str         STRING
DEFINE l_tok         base.StringTokenizer
DEFINE l_tag         LIKE type_file.num5
DEFINE l_zar04       LIKE zar_file.zar04
 
   CALL g_zar.clear()
   LET g_forupd_sql= "SELECT zar02,zar03,gaq03,zar04  FROM zar_file,gaq_file ",
                     " WHERE zar01 = '",g_zai.zai01 CLIPPED, "' ",
                     "   AND zar05 = '",g_zai.zai05 CLIPPED,"' ",  #FUN-750084
                     "   AND zar03 = gaq01 ",
                     "   AND gaq02 = '",g_lang,"'",
                     " ORDER BY zar04"
   DECLARE p_zar2_cl CURSOR FROM g_forupd_sql     
   LET l_i   = 1
   LET l_tag = 0
   FOREACH p_zar2_cl INTO g_zar[l_i].zar02,g_zar[l_i].zar03,g_zar[l_i].gaq03,l_zar04
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF g_zar[l_i].zar02 IS NULL THEN
           EXIT FOREACH
       ELSE
           LET l_i = l_i + 1
        END IF
   END FOREACH
   CALL g_zar.deleteElement(l_i)
   LET g_zar_cnt = l_i - 1
 
   IF g_zar_cnt = 0 AND g_wizard_choice <> "exit" 
      AND g_wizard_choice <> 'wizard_table' 
      AND g_wizard_choice <> 'wizard_field' 
   THEN
      CALL cl_err('','azz-245',1)
      LET g_wizard_choice = 'wizard_field'
   END IF
   
END FUNCTION
 
FUNCTION p_wizard_zas_b_fill()
DEFINE l_i           LIKE type_file.num5
DEFINE l_items       STRING
DEFINE l_str         STRING
DEFINE l_tok         base.StringTokenizer
DEFINE l_tag         LIKE type_file.num5
 
   CALL g_zas.clear()
   LET g_forupd_sql= "SELECT zas02,zas03,zas04,zas05,zas06,zas07,zas08,zas09,",
                     " zas10 FROM zas_file ",
                     " WHERE zas01 = '",g_zai.zai01 CLIPPED,"' ",
                     "   AND zas11 = '",g_zai.zai05 CLIPPED,"' ", #FUN-750084
                     " ORDER BY zas02"
   DECLARE p_zas2_cl CURSOR FROM g_forupd_sql     
   LET l_i   = 1
   LET l_tag = 0
   FOREACH p_zas2_cl INTO g_zas[l_i].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF g_zas[l_i].zas02 IS NULL THEN
           EXIT FOREACH
       ELSE
           LET l_i = l_i + 1
       END IF
   END FOREACH
   CALL g_zas.deleteElement(l_i)
   LET g_zas_cnt = l_i - 1
 
END FUNCTION
 
FUNCTION p_wizard_check_field(p_field,p_table,p_cmd)
DEFINE p_field   STRING
DEFINE p_table   STRING
DEFINE p_cmd     STRING
DEFINE l_str     STRING
DEFINE ls_sql    STRING
DEFINE l_status  LIKE type_file.num5
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_tok     base.StringTokenizer
 
   #FUN-7C0020
   LET g_zta17 = NULL
   LET g_zta01= p_table CLIPPED
   SELECT zta17 INTO g_zta17 
     FROM zta_file WHERE zta01 = g_zta01 AND zta02 = g_dbs
   #END FUN-7C0020
 
   IF p_field.getIndexOf(',',1) > 0 AND p_cmd = 'Y' THEN
      LET l_tok = base.StringTokenizer.createExt(p_field,",","",TRUE)
      WHILE l_tok.hasMoreTokens()
         LET l_str = l_tok.nextToken()
         #---FUN-A90024---start-----
         #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
         #目前統一用sch_file紀錄TIPTOP資料結構
         ##IF g_db_type = 'IFX' THEN
         #CASE g_db_type                                          #FUN-750084
         # WHEN "IFX"                                             #FUN-750084
         #   #FUN-750084 
         #   #FUN-7C0020
         #   #LET g_zta17 = NULL
         #   #LET g_zta01= p_table CLIPPED
         #   #SELECT zta17 INTO g_zta17 FROM zta_file 
         #   # WHERE zta01 = g_zta01 AND zta02 = g_dbs
         #   #END FUN-7C0020
         #   IF NOT cl_null(g_zta17 CLIPPED) THEN 
         #      LET ls_sql =
         #          "SELECT COUNT(*)",
         ##TQC-950044 MARK&ADD START----------------------------------------                                                                  
         ##          " FROM ",g_zta17 CLIPPED,":syscolumns c,",                                                                       
         ##         "      ",g_zta17 CLIPPED,":systables t",                                                                         
         ##          " FROM ",s_dbstring(g_zta17),"syscolumns c,",                                                                    
         ##          "      ",s_dbstring(g_zta17),"systables t",                                                                      
         ##TQC-950044 END---------------------------------------------------    
         #          " WHERE c.tabid=t.tabid AND t.tabname='",p_table,"'",
         #          "   AND c.colname='",l_str,"'"
         #   ELSE
         #      LET ls_sql =
         #          "SELECT COUNT(*)",
         #          " FROM syscolumns c,systables t",
         #          " WHERE c.tabid=t.tabid AND t.tabname='",p_table,"'",
         #          "   AND c.colname='",l_str,"'"
         #   END IF
         #   #END FUN-750084
         # WHEN "ORA"                                             #FUN-750084
         #   #FUN-7C0020
         #   IF NOT cl_null(g_zta17 CLIPPED) THEN 
         #      LET ls_sql =
         #          "SELECT COUNT(*) FROM all_tab_columns",
         #          " WHERE lower(table_name)='",p_table CLIPPED,"'",
         #          "   AND lower(column_name)='",l_str,"'"
         #   ELSE
         #      LET ls_sql =
         #          "SELECT COUNT(*) FROM user_tab_columns",
         #          " WHERE lower(table_name)='",p_table CLIPPED,"'",
         #          "   AND lower(column_name)='",l_str,"'"
         #   END IF
         #   #END FUN-7C0020
         # WHEN "MSV"                                             #FUN-750084
         #   #FUN-810062
         #   IF NOT cl_null(g_zta17 CLIPPED) THEN 
         #      LET ls_sql =
         #          "SELECT COUNT(*) ",
         #          "  FROM ",FGL_GETENV("MSSQLAREA") CLIPPED,"_",g_dbs CLIPPED,".sys.objects a,",
         #          "       ",FGL_GETENV("MSSQLAREA") CLIPPED,"_",g_dbs CLIPPED,".sys.columns b",
         #          " WHERE a.object_id = b.object_id ",
         #          "   AND a.name='",p_table CLIPPED,"'",
         #          "   AND b.name='",l_str,"'"
         #   ELSE
         #      LET ls_sql =
         #          "SELECT COUNT(*) FROM sys.objects a,sys.columns b",
         #          " WHERE a.object_id = b.object_id ",
         #          "   AND a.name='",p_table CLIPPED,"'",
         #          "   AND b.name='",l_str,"'"
         #   END IF
         #   #END FUN-810062
         #END CASE                                                #FUN-750084
         LET ls_sql = "SELECT COUNT(*) FROM sch_file ",
                      "  WHERE sch01 = '", p_table CLIPPED, "'",
                      "   AND sch02 = '", l_str CLIPPED, "'"
         #---FUN-A90024---end-------
 	     CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql        #FUN-920032
         PREPARE query2_precount FROM ls_sql
         DECLARE query2_count CURSOR FOR query2_precount
         OPEN query2_count
         FETCH query2_count INTO l_cnt
         IF l_cnt = 0 THEN
            LET l_str= p_table,"+",l_str
            CALL cl_err(l_str,NOTFOUND,0)
            RETURN 0
         END IF
      END WHILE
   ELSE
      #---FUN-A90024---start-----
      #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
      #目前統一用sch_file紀錄TIPTOP資料結構
      ##IF g_db_type = 'IFX' THEN
      #CASE g_db_type                                             #FUN-750084
      # WHEN "IFX"                                                #FUN-750084
      #   #FUN-750084 
      #   #FUN-7C0020
      #   #LET g_zta17 = NULL
      #   #LET g_zta01= p_table CLIPPED
      #   #SELECT zta17 INTO g_zta17 FROM zta_file 
      #   # WHERE zta01 = g_zta01 AND zta02 = g_dbs
      #   #END FUN-7C0020
      #   IF NOT cl_null(g_zta17 CLIPPED) THEN 
      #      LET ls_sql =
      #          "SELECT COUNT(*)",
      ##TQC-950044 MARK&ADD START---------------------------------                                                                         
      ##         " FROM ",g_zta17 CLIPPED,":syscolumns c,",                                                                          
      ##                  g_zta17 CLIPPED,":systables t",                                                                            
      #          " FROM ",s_dbstring(g_zta17),"syscolumns c,",                                                                       
      #                   s_dbstring(g_zta17),"systables t",                                                                         
      ##TQC-950044 END--------------------------------------------     
      #          " WHERE c.tabid=t.tabid AND t.tabname='",p_table,"'",
      #          "   AND c.colname='",p_field,"'"
      #   ELSE
      #      LET ls_sql =
      #          "SELECT COUNT(*)",
      #          " FROM syscolumns c,systables t",
      #          " WHERE c.tabid=t.tabid AND t.tabname='",p_table,"'",
      #          "   AND c.colname='",p_field,"'"
      #   END IF
      #   #END FUN-750084
      # WHEN "ORA"                                                #FUN-750084
      #   #FUN-7C0020
      #   IF NOT cl_null(g_zta17 CLIPPED) THEN 
      #      LET ls_sql =
      #          "SELECT COUNT(*) FROM all_tab_columns",
      #          " WHERE lower(table_name)='",p_table,"'",
      #          "   AND lower(column_name)='",p_field,"'"
      #   ELSE
      #      LET ls_sql =
      #          "SELECT COUNT(*) FROM user_tab_columns",
      #          " WHERE lower(table_name)='",p_table,"'",
      #          "   AND lower(column_name)='",p_field,"'"
      #   END IF
      #   #END FUN-7C0020
      # WHEN "MSV"                                                #FUN-750084
      #   #FUN-810062
      #   IF NOT cl_null(g_zta17 CLIPPED) THEN 
      #      LET ls_sql =
      #          "SELECT COUNT(*) ",
      #          "  FROM ",FGL_GETENV("MSSQLAREA") CLIPPED,"_",g_dbs CLIPPED,".sys.objects a,",
      #          "       ",FGL_GETENV("MSSQLAREA") CLIPPED,"_",g_dbs CLIPPED,".sys.columns b",
      #          " WHERE a.object_id = b.object_id ",
      #          "   AND a.name='",p_table CLIPPED,"'",
      #          "   AND b.name='",p_field,"'"
      #   ELSE
      #      LET ls_sql =
      #          "SELECT COUNT(*) FROM sys.objects a,sys.columns b",
      #          " WHERE a.object_id = b.object_id ",
      #          "   AND a.name='",p_table CLIPPED,"'",
      #          "   AND b.name='",p_field,"'"
      #   END IF
      #   #END FUN-810062
      #END CASE                                                   #FUN-750084
      LET ls_sql = "SELECT COUNT(*) FROM sch_file ",
                   "  WHERE sch01 = '", p_table CLIPPED, "'",
                   "   AND sch02 = '", p_field CLIPPED, "'"
      #---FUN-A90024---end-------
 	  CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql        #FUN-920032
      PREPARE query3_precount FROM ls_sql
      DECLARE query3_count CURSOR FOR query3_precount
      OPEN query3_count
      FETCH query3_count INTO l_cnt
      IF l_cnt = 0 THEN
         IF g_action_choice <> "query_auth_i" THEN
            LET l_str= p_table,"+",p_field
            CALL cl_err(l_str,NOTFOUND,0)
         END IF
         RETURN 0
      END IF
   END IF
   RETURN 1
END FUNCTION
 
FUNCTION p_wizard_swe01()
DEFINE l_i         LIKE type_file.num5
DEFINE l_tag       LIKE type_file.num5
DEFINE l_str       STRING
DEFINE l_tok       base.StringTokenizer 
DEFINE l_zas06     STRING
DEFINE l_zas10     STRING
DEFINE buf         base.StringBuffer
 
    LET l_tag = 0
    LET g_swe01 = "SELECT"
   
    #組 SQL 字串: SELECT 欄位
    FOR l_i = 1 TO g_zar_cnt
      LET l_str = g_zar[l_i].zar03 CLIPPED
      IF l_str.getIndexOf(',',1) > 0  THEN
         LET l_tok = base.StringTokenizer.createExt(l_str,",","",TRUE)
         WHILE l_tok.hasMoreTokens()
            LET l_str = l_tok.nextToken()
            IF l_i = 1 AND l_tag = 0 THEN
               LET g_swe01 = g_swe01," ",g_zar[l_i].zar02 CLIPPED,".",l_str
               LET l_tag = 1
            ELSE
               LET g_swe01 = g_swe01,",",g_zar[l_i].zar02 CLIPPED,".",l_str
            END IF
         END WHILE 
      ELSE
         IF l_i = 1 THEN
            LET g_swe01 = g_swe01," ",g_zar[l_i].zar02 CLIPPED,".",l_str
         ELSE
            LET g_swe01 = g_swe01,", ",g_zar[l_i].zar02 CLIPPED,".",l_str
         END IF
      END IF
    END FOR
 
    #組 SQL 字串:FROM TABLE
    LET g_swe01 = g_swe01 ,"\n  FROM"
    FOR l_i = 1 TO g_zaq_cnt
        IF l_i = 1 THEN
           LET g_swe01 = g_swe01," ",g_zaq[l_i].zaq02 CLIPPED
        ELSE
           IF g_zaq[l_i].zaq03 = 'Y' THEN
              LET g_swe01 = g_swe01,",OUTER ",g_zaq[l_i].zaq02 CLIPPED
           ELSE
              LET g_swe01 = g_swe01,",",g_zaq[l_i].zaq02 CLIPPED
           END IF
        END IF
    END FOR  
 
    #組 SQL 字串: WHERE 條件
    FOR l_i = 1 TO g_zas_cnt
        LET l_zas06 = ""
        LET l_zas10 = ""
        CASE g_zas[l_i].zas06
           WHEN '1'     LET l_zas06 = "="
           WHEN '2'     LET l_zas06 = ">"
           WHEN '3'     LET l_zas06 = "<"
           WHEN '4'     LET l_zas06 = ">="
           WHEN '5'     LET l_zas06 = "<="
           WHEN '6'     LET l_zas06 = "!="
           WHEN '7'     LET l_zas06 = "BETWEEN"
           WHEN '8'     LET l_zas06 = "NOT BETWEEN"
           WHEN '9'     LET l_zas06 = "LIKE "
           WHEN '10'    LET l_zas06 = "NOT LIKE" 
           WHEN '11'    LET l_zas06 = "IS NULL" 
           WHEN '12'    LET l_zas06 = "IS NOT NULL" 
        END CASE
        CASE g_zas[l_i].zas10
           WHEN '1'     LET l_zas10 = "OR"
           WHEN '2'     LET l_zas10 = "AND"
        END CASE       
 
        IF l_i = 1 THEN
           LET g_swe01 = g_swe01 ,"\n WHERE "
        ELSE
           LET g_swe01 = g_swe01,"       "
        END IF
        LET g_swe01 = g_swe01,
                 g_zas[l_i].zas03 CLIPPED," ",g_zas[l_i].zas04 CLIPPED,".",
                 g_zas[l_i].zas05 CLIPPED," ",l_zas06 CLIPPED," "
        IF g_zas[l_i].zas07 IS NOT NULL THEN
            LET g_swe01 = g_swe01,
                g_zas[l_i].zas07 CLIPPED,".", g_zas[l_i].zas08 CLIPPED," ",
                g_zas[l_i].zas09 CLIPPED," ",l_zas10 CLIPPED,"\n"
        ELSE
            IF g_zas[l_i].zas06 = '7'  OR g_zas[l_i].zas06 = '8'  OR
               g_zas[l_i].zas06 = '11' OR g_zas[l_i].zas06 = '12' 
            THEN
               LET g_swe01 = g_swe01, g_zas[l_i].zas08 CLIPPED," ",
                   g_zas[l_i].zas09 CLIPPED," ",l_zas10 CLIPPED,"\n"
            ELSE
               IF g_zas[l_i].zas06 = '9'  OR g_zas[l_i].zas06 = '10' THEN
                  LET buf = base.StringBuffer.create()
                  CALL buf.append(g_zas[l_i].zas08 CLIPPED)
                  CALL buf.replace( "*","%", 0)
                  LET g_zas[l_i].zas08  = buf.toString()
               END IF
               LET g_swe01 = g_swe01," '",g_zas[l_i].zas08 CLIPPED,"' ",
                   g_zas[l_i].zas09 CLIPPED," ",l_zas10 CLIPPED,"\n"
            END IF
        END IF
    END FOR  
 
END FUNCTION
 
FUNCTION p_wizard_finish()
DEFINE l_field     RECORD
        field001, field002, field003, field004, field005, field006, field007,
        field008, field009, field010, field011, field012, field013, field014,
        field015, field016, field017, field018, field019, field020, field021,
        field022, field023, field024, field025, field026, field027, field028,
        field029, field030, field031, field032, field033, field034, field035,
        field036, field037, field038, field039, field040, field041, field042,
        field043, field044, field045, field046, field047, field048, field049,
        field050, field051, field052, field053, field054, field055, field056,
        field057, field058, field059, field060, field061, field062, field063,
        field064, field065, field066, field067, field068, field069, field070,
        field071, field072, field073, field074, field075, field076, field077,
        field078, field079, field080, field081, field082, field083, field084,
        field085, field086, field087, field088, field089, field090, field091,
        field092, field093, field094, field095, field096, field097, field098,
        field099, field100  LIKE gaq_file.gaq03     #No.FUN-680135 VARCHAR(255)
                  END RECORD
 
        PREPARE wizard_pre FROM g_swe01
        IF SQLCA.SQLCODE THEN
           CALL cl_err('','zta-028',1)
           RETURN 0
        END IF
 
        DECLARE wizard_cur CURSOR FOR wizard_pre 
        IF SQLCA.SQLCODE THEN
           CALL cl_err('2->','zta-028',1)
           RETURN 0
        END IF
 
        FOREACH wizard_cur INTO l_field.*
           EXIT FOREACH
        END FOREACH
        IF SQLCA.SQLCODE THEN
           CALL cl_err("wizard_cur:",sqlca.sqlcode,1)
           RETURN 0
        END IF
 
        LET g_zak.zak02 = g_swe01
 
        
    RETURN 1
END FUNCTION
 
FUNCTION p_query_seq()
DEFINE k         LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE l_zat02   LIKE zat_file.zat02
DEFINE l_zat07   LIKE zat_file.zat07
 
    OPEN WINDOW p_zat_1 AT 8,23 WITH FORM "azz/42f/p_zaa_1"
         ATTRIBUTE (STYLE = g_win_style)
    CALL cl_ui_locale("p_zaa_1")
 
    LET g_n = 1                                #FUN-650175
 
    INPUT g_n WITHOUT DEFAULTS FROM a
        ON ACTION cancel
           LET g_n = 0
           EXIT INPUT
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
    END INPUT
    BEGIN WORK
    CASE g_n
         WHEN 1   #欄位順序調換
            FOR k = 1 to g_zat.getLength()
                IF (k <> l_w_ac) AND g_zat[k].zat04 = g_zat[l_w_ac].zat04 THEN
                  LET g_zat[k].zat04 = g_zat_t.zat04
                  UPDATE zat_file SET zat04 = g_zat_t.zat04
                   WHERE zat01 = g_zai.zai01 
                     AND zat10 = g_zai.zai05                       ##FUN-750084
                     AND zat02 = g_zat[k].zat02  
                  EXIT FOR
                END IF
            END FOR
 
            UPDATE zat_file SET zat04 = g_zat[l_w_ac].zat04
                WHERE zat01 = g_zai.zai01 AND zat02 = g_zat[l_w_ac].zat02
                  AND zat10 = g_zai.zai05                          #FUN-750084
            LET g_zat_t.zat04 = g_zat[l_w_ac].zat04
 
         WHEN 2         #以下欄位順序自動往後遞增一位
            FOR k = 1 to g_zat.getLength()
                IF (k <> l_w_ac)  AND g_zat[k].zat04 >= g_zat[l_w_ac].zat04
                  AND ((g_zat[k].zat04 <= g_zat_t.zat04) OR
                      (g_zat_t.zat04 <= g_zat[l_w_ac].zat04))
                THEN
                    LET g_zat[k].zat04 = g_zat[k].zat04 + 1
                    UPDATE zat_file SET zat04 = g_zat[k].zat04
                     WHERE zat01 = g_zai.zai01 AND zat02 = g_zat[k].zat02
                       AND zat10 = g_zai.zai05                     #FUN-750084  
                END IF
            END FOR
            UPDATE zat_file SET zat04 = g_zat[l_w_ac].zat04
              WHERE zat01 = g_zai.zai01 AND zat02 = g_zat[l_w_ac].zat02
                AND zat10 = g_zai.zai05                            #FUN-750084
            LET g_zat_t.zat04 = g_zat[l_w_ac].zat04
    END CASE
    CLOSE WINDOW p_zat_1
    RETURN g_n
END FUNCTION
 
FUNCTION p_query_field_change()
DEFINE l_cnt    LIKE type_file.num10
DEFINE i        LIKE type_file.num10
DEFINE l_zal02  LIKE zal_file.zal02
DEFINE l_zat04  LIKE zat_file.zat04
DEFINE l_zal08  LIKE zal_file.zal08                                #FUN-7C0020
 
   SELECT count(unique zal02) INTO l_cnt FROM zal_file
      WHERE zal01 = g_zai.zai01 AND zal07 = g_zai.zai05            #FUN-750084
   IF (g_field_rec_b = 0 AND l_cnt <> 0 ) OR (g_field_rec_b <> l_cnt) 
   THEN
       LET g_forupd_sql= "SELECT unique zal02,zal08 FROM zal_file ",  #FUN-7C0020
                         " WHERE zal01 = '",g_zai.zai01 CLIPPED,"' ",
                         "   AND zal07 = '",g_zai.zai05 CLIPPED,"' ", #FUN-750084
                         " order by zal02"
       
       DECLARE p_query_fld_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
       FOREACH p_query_fld_cl INTO l_zal02,l_zal08                  #FUN-7C0020
           SELECT count(*) into l_cnt FROM zat_file 
            WHERE zat01 = g_zai.zai01 AND zat02=l_zal02
              AND zat10 = g_zai.zai05                               #FUN-750084
           IF l_cnt = 0 THEN
              SELECT MAX(zat04)+1 INTO l_zat04 FROM zat_file 
               WHERE zat01 = g_zai.zai01 AND zat10 = g_zai.zai05    #FUN-750084
              IF cl_null(l_zat04)  OR l_zat04 = 0 THEN
                 LET l_zat04 = 1
              END IF
              LET l_zal08 = p_query_per_len(l_zal08)   #TQC-810053
 
              INSERT INTO zat_file(zat01,zat02,zat03,zat04,zat05,zat06,zat07,
                                   zat08,zat09,zat10,zat11,zat12)
                     VALUES(g_zai.zai01,l_zal02,'Y',l_zat04,'N','','N','','',g_zai.zai05,'N',l_zal08)  #FUN-750084 #FUN-770079 #FUN-7C0020
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","zat_file",g_zai.zai01,l_zal02,SQLCA.sqlcode,"","",0)
                 RETURN
              END IF
           END IF
       END FOREACH
   END IF
END FUNCTION
 
#FUN-750084
FUNCTION p_query_copy()
DEFINE
       l_newno         LIKE zai_file.zai01,
       l_newcust       LIKE zai_file.zai05,
       l_zai01_t       LIKE zai_file.zai01,
       l_zai05_t       LIKE zai_file.zai05
DEFINE l_str           STRING
DEFINE li_result       LIKE type_file.num5,     
       l_n             LIKE type_file.num5    # 檢查重複用    
 
    IF s_shut(0) THEN RETURN END IF
    IF g_zai.zai01 IS NULL THEN
        CALL cl_err('',-420,0)
        RETURN
    END IF
 
    LET l_zai01_t = g_zai.zai01
    LET l_zai05_t = g_zai.zai05
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
 
    LET g_before_input_done = FALSE  #No.MOD-480235
    CALL query_set_entry('a')         #No.MOD-480235
    LET g_before_input_done = TRUE   #No.MOD-480235
 
 
    INPUT l_newno,l_newcust FROM zai01,zai05  #No.B359
      BEFORE INPUT
         LET l_newcust = "N"
         DISPLAY l_newcust TO zai05
 
      AFTER FIELD zai01
         IF NOT cl_null(l_newno) THEN
            LET l_str = l_newno  CLIPPED
            IF l_str.getIndexOf(' ',1) > 0 THEN
               CALL cl_err(l_newno,'azz-252',0)
               NEXT FIELD zai01
            END IF
          END IF
 
      AFTER INPUT 
         SELECT count(*) INTO l_n FROM zai_file
           WHERE zai01 = l_newno  AND zai05 = l_newcust
         IF l_n > 0 THEN
            CALL cl_err('',-239,0)
            NEXT FIELD zai01
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
 
    END INPUT
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_zai.zai01
        RETURN
    END IF
 
    BEGIN WORK                                  #TQC-790050
 
    DROP TABLE y
    SELECT * FROM zai_file         #單頭複製
        WHERE zai01 = l_zai01_t AND zai05 = l_zai05_t
        INTO TEMP y
    UPDATE y
        SET zai01=l_newno,    #新的鍵值
            zai05=l_newcust,  #客製否
            zaiuser=g_user,   #資料所有者
            zaigrup=g_grup,   #資料所有者所屬群
            zaimodu=NULL,     #資料修改日期
            zaidate=g_today   #資料建立日期
 
    INSERT INTO zai_file
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","zai_file",l_newno,l_newcust,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK
        RETURN
    END IF
 
    #複製 zaj_file
    DROP TABLE x
    SELECT * FROM zaj_file         #單身複製
        WHERE zaj01=l_zai01_t AND zaj07=l_zai05_t
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","zaj_file",l_zai01_t,l_zai05_t,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
    UPDATE x
        SET zaj01=l_newno,   
            zaj07=l_newcust
    INSERT INTO zaj_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","zaj_file",l_newno,l_newcust,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
 
    #複製 zak_file
    DROP TABLE x
    SELECT * FROM zak_file         #單身複製
        WHERE zak01=l_zai01_t AND zak07=l_zai05_t
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","zak_file",l_zai01_t,l_zai05_t,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
    UPDATE x
        SET zak01=l_newno,   
            zak07=l_newcust
    INSERT INTO zak_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","zak_file",l_newno,l_newcust,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
 
    #複製 zal_file
    DROP TABLE x
    SELECT * FROM zal_file         #單身複製
        WHERE zal01=l_zai01_t AND zal07=l_zai05_t
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","zal_file",l_zai01_t,l_zai05_t,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
    UPDATE x
        SET zal01=l_newno,   
            zal07=l_newcust
    INSERT INTO zal_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","zal_file",l_newno,l_newcust,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
 
    #複製 zam_file
    DROP TABLE x
    SELECT * FROM zam_file         #單身複製
        WHERE zam01=l_zai01_t AND zam09=l_zai05_t
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","zam_file",l_zai01_t,l_zai05_t,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
    UPDATE x
        SET zam01=l_newno,   
            zam09=l_newcust
    INSERT INTO zam_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","zam_file",l_newno,l_newcust,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
 
    #複製 zan_file
    DROP TABLE x
    SELECT * FROM zan_file         #單身複製
        WHERE zan01=l_zai01_t AND zan08=l_zai05_t
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","zan_file",l_zai01_t,l_zai05_t,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
    UPDATE x
        SET zan01=l_newno,   
            zan08=l_newcust
    INSERT INTO zan_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","zan_file",l_newno,l_newcust,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
 
    #複製 zao_file
    DROP TABLE x
    SELECT * FROM zao_file         #單身複製
        WHERE zao01=l_zai01_t AND zao05=l_zai05_t
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","zao_file",l_zai01_t,l_zai05_t,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
    UPDATE x
        SET zao01=l_newno,   
            zao05=l_newcust
    INSERT INTO zao_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","zao_file",l_newno,l_newcust,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
 
    #複製 zap_file
    DROP TABLE x
    SELECT * FROM zap_file         #單身複製
        WHERE zap01=l_zai01_t AND zap07=l_zai05_t
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","zap_file",l_zai01_t,l_zai05_t,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
    UPDATE x
        SET zap01=l_newno,   
            zap07=l_newcust
    INSERT INTO zap_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","zap_file",l_newno,l_newcust,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
 
    #複製 zaq_file
    DROP TABLE x
    SELECT * FROM zaq_file         #單身複製
        WHERE zaq01=l_zai01_t AND zaq05=l_zai05_t
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","zaq_file",l_zai01_t,l_zai05_t,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
    UPDATE x
        SET zaq01=l_newno,   
            zaq05=l_newcust
    INSERT INTO zaq_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","zaq_file",l_newno,l_newcust,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
 
    #複製 zar_file
    DROP TABLE x
    SELECT * FROM zar_file         #單身複製
        WHERE zar01=l_zai01_t AND zar05=l_zai05_t
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","zar_file",l_zai01_t,l_zai05_t,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
    UPDATE x
        SET zar01=l_newno,   
            zar05=l_newcust
    INSERT INTO zar_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","zar_file",l_newno,l_newcust,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
 
    #複製 zas_file
    DROP TABLE x
    SELECT * FROM zas_file         #單身複製
        WHERE zas01=l_zai01_t AND zas11=l_zai05_t
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","zas_file",l_zai01_t,l_zai05_t,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
    UPDATE x
        SET zas01=l_newno,   
            zas11=l_newcust
    INSERT INTO zas_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","zas_file",l_newno,l_newcust,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
 
    #複製 zat_file
    DROP TABLE x
    SELECT * FROM zat_file         #單身複製
        WHERE zat01=l_zai01_t AND zat10=l_zai05_t
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","zat_file",l_zai01_t,l_zai05_t,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
    UPDATE x
        SET zat01=l_newno,   
            zat10=l_newcust
    INSERT INTO zat_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","zat_file",l_newno,l_newcust,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
 
    #複製 zau_file
    DROP TABLE x
    SELECT * FROM zau_file         #單身複製
        WHERE zau01=l_zai01_t AND zau04=l_zai05_t
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","zau_file",l_zai01_t,l_zai05_t,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
    UPDATE x
        SET zau01=l_newno,   
            zau04=l_newcust
    INSERT INTO zau_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","zau_file",l_newno,l_newcust,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
 
    #複製 zav_file
    DROP TABLE x
    SELECT * FROM zav_file         #單身複製
        WHERE zav01='2' AND zav02 = l_zai01_t AND zav04 = l_zai05_t
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","zav_file",l_zai01_t,l_zai05_t,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
    UPDATE x
        SET zav01=l_newno,   
            zav04=l_newcust
    INSERT INTO zav_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","zav_file",l_newno,l_newcust,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
 
    #FUN-770079
    #複製 zay_file
    DROP TABLE x
    SELECT * FROM zay_file         #單身複製
        WHERE zay01 = l_zai01_t AND zay03 = l_zai05_t
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","zay_file",l_zai01_t,l_zai05_t,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
    UPDATE x
        SET zay01=l_newno,   
            zay03=l_newcust
    INSERT INTO zay_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","zay_file",l_newno,l_newcust,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
    #END FUN-770079
    COMMIT WORK                                 #TQC-790050
 
    SELECT * INTO g_zai.* FROM zai_file
                   WHERE zai01 = l_newno AND zai05 = l_newcust
    CALL p_query_u()
    #SELECT * INTO g_zai.* FROM zai_file                          #FUN-C30027
    #               WHERE zai01 = l_zai01_t AND zai05 = l_zai05_t #FUN-C30027
    CALL p_query_show()
    DISPLAY BY NAME g_zai.zai01
END FUNCTION
#END FUN-750084
 
#FUN-770079
#[
# Description....: 取得 SQL 指令的欄位型態及長度
# Date & Author..: 2007/07/25 by Echo
# Parameter......: p_colname - CHAR - 欄位名稱
# Return.........: l_datatype - CHAR - 欄位型態
#                : l_length - CHAR - 欄位長度
#]
FUNCTION p_query_field_type(p_colname)
DEFINE p_colname        STRING                 #FUN-820043 
DEFINE l_colname        LIKE zal_file.zal04    #FUN-820043
DEFINE l_tabname        STRING
DEFINE l_cnt            LIKE type_file.num10   #FUN-750084
DEFINE l_sql            STRING
DEFINE l_table_name     LIKE gac_file.gac05
DEFINE l_length         STRING
DEFINE l_zak02          STRING
DEFINE l_index          LIKE type_file.num5  
DEFINE l_datatype       LIKE type_file.chr20 
DEFINE l_p              LIKE type_file.num5
DEFINE l_str            STRING                 #TQC-7C0043
DEFINE l_dbname         STRING                 ### FUN-810062 ###
 
    LET l_colname = p_colname.subString(p_colname.getIndexOf('.',1)+1,p_colname.getLength())  #FUN-820043
 
    LET l_tabname = ""
    #---FUN-A90024---start-----
    #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
    #目前統一用sch_file紀錄TIPTOP資料結構
    ##FUN-750084
    #CASE g_db_type 
    #  WHEN "ORA" 
    #    LET l_sql= "SELECT UNIQUE TABLE_NAME FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = UPPER( ? ) AND OWNER='DS'"
    #  WHEN "IFX" 
    #    SELECT COUNT(*) INTO l_cnt FROM syscolumns WHERE colname = l_colname
    #    IF l_cnt = 0 THEN 
    #       LET l_sql = "SELECT tabname FROM ds:syscolumns col, ds:systables tab WHERE col.colname = ? AND tab.tabid = col.tabid"  #FUN-750084
    #    ELSE
    #       LET l_sql = "SELECT tabname FROM syscolumns col, systables tab WHERE col.colname = ? AND tab.tabid = col.tabid"  #FUN-750084
    #    END IF
    #  WHEN "MSV"    
    #    #FUN-810062
    #    SELECT COUNT(*) INTO l_cnt FROM sys.columns WHERE name = l_colname 
    #    IF l_cnt = 0 THEN 
    #       LET l_sql =
    #           "SELECT distinct a.name ",
    #           "  FROM ",FGL_GETENV("MSSQLAREA") CLIPPED,"_",g_dbs CLIPPED,".sys.objects a,",
    #           "       ",FGL_GETENV("MSSQLAREA") CLIPPED,"_",g_dbs CLIPPED,".sys.columns b",
    #           " WHERE a.object_id = b.object_id ",
    #           "   AND b.name='",l_str,"'"
    #    ELSE
    #       LET l_sql = "SELECT distinct a.name ",
    #                   "  FROM sys.objects a, sys.columns b",
    #                   " WHERE b.name = ? ",
    #                   "   AND a.object_id = b.object_id"
    #    END IF
    #    #END FUN-810062
    #END CASE
 	# CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    #DECLARE table_cur CURSOR FROM l_sql
    ##END FUN-750084
    #FOREACH table_cur USING l_colname INTO l_table_name
    #   LET l_zak02 = g_zak.zak02
    #   #FUN-750084 
    #   IF g_db_type ="ORA" THEN
    #      LET l_zak02 = l_zak02.toUpperCase()
    #   END IF
    #   LET l_index = l_zak02.getIndexOf(l_table_name CLIPPED,1)
    #   #END FUN-750084 
    #   IF l_index != 0 THEN
    #       LET l_tabname = l_table_name
    #       EXIT FOREACH
    #   END IF
    #END FOREACH
    LET l_tabname = cl_get_table_name(l_colname CLIPPED)
    LET l_index = l_zak02.getIndexOf(l_table_name CLIPPED,1)
    IF l_index = 0 THEN
       LET l_tabname = ''
    END IF
    #---FUN-A90024---end-------
    #TQC-7C0043
    IF cl_null(l_tabname) THEN
        LET l_str = l_colname CLIPPED
        IF l_str.getIndexOF('|',1) > 0 THEN
           RETURN 'char',''
        ELSE
           RETURN '',''
        END IF
    END IF
    #END TQC-7C0043
 
    #FUN-810062
    CASE g_db_type                        
      WHEN "MSV"
         LET l_dbname =  FGL_GETENV('MSSQLAREA'),'_ds'
      OTHERWISE
         LET l_dbname = 'ds'
    END CASE
 
    CALL cl_get_column_info(l_dbname,l_tabname.toLowerCase(),l_colname)
        RETURNING l_datatype,l_length
    #END FUN-810062
    IF l_datatype  = 'date' THEN
       LET l_length = '10'
    END IF
    
    IF l_datatype = "number" OR l_datatype = "decimal" THEN
       LET l_p = l_length.getIndexOf(',',1)
       IF l_p > 0 THEN
          LET l_length = l_length.subString(1,l_p-1)
       END IF
    END IF
 
    RETURN l_datatype,l_length
 
END FUNCTION
 
# 查詢 SQL 指令的欄位型態
#[
# Description....: 維護欄位轉換值設定
# Date & Author..: 2007/07/25 by Echo
# Parameter......: p_zat02 - CHAR - 欄位序號
# Return.........: TRUE / FALSE
# Modify.........:
#]
FUNCTION p_query_replace(p_zay02) 
DEFINE p_zay02    LIKE zay_file.zay02
 
  LET g_zay02 = p_zay02 CLIPPED
  LET g_rep_upd_tag = 0
 
  OPEN WINDOW p_query_rep_w WITH FORM "azz/42f/p_query_replace"
  ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
  CALL cl_load_style_list(NULL)
  CALL cl_ui_locale("p_query_replace")
 
  LET g_sql = "SELECT zay04,zay05,zay06,zay07 FROM zay_file ",
                  " WHERE zay01 = '", g_zai.zai01 CLIPPED, "' ",
                  "   AND zay02 = '", g_zay02 CLIPPED, "' ",
                  "   AND zay03 = '", g_zai.zai05 CLIPPED, "' ",
                  " ORDER BY zay04,zay05"
  PREPARE replace_pre FROM g_sql
  DECLARE replace_curs CURSOR FOR replace_pre
 
  CALL p_query_rep_b_fill()
  
  CALL p_query_rep_menu()
 
  CLOSE WINDOW p_query_rep_w                       # 結束畫面
  IF g_zay_rec_b > 0 OR (g_zay_rec_b > 0 AND g_rep_upd_tag) THEN
     RETURN 1
  ELSE
     RETURN 0
  END IF
 
END FUNCTION
 
FUNCTION p_query_rep_b_fill()
 
   CALL g_zay.clear()
   LET g_cnt = 1
   LET g_zay_rec_b = 0
 
   FOREACH replace_curs INTO g_zay[g_cnt].*       #單身 ARRAY 填充
      LET g_zay_rec_b = g_zay_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF g_zay[g_cnt].zay04 = '2' THEN
         LET g_zay[g_cnt].zay05 = ''
      END IF
      IF g_zay[g_cnt].zay06 = '2' THEN
         SELECT ze03 INTO g_zay[g_cnt].memo FROM ze_file 
          WHERE ze01 = g_zay[g_cnt].zay07 AND ze02 = g_lang
      ELSE
         LET g_zay[g_cnt].memo = ''
      END IF
      
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_zay.deleteElement(g_cnt)
 
   LET g_zay_rec_b = g_cnt - 1
   LET g_cnt = 0
END FUNCTION
 
FUNCTION p_query_rep_menu()
 
  WHILE TRUE
     CALL p_query_rep_bp("G")
 
     CASE g_action_choice
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL p_query_rep_b()
           ELSE
              LET g_action_choice = NULL
           END IF
        WHEN "help"                            # H.求助
           CALL cl_show_help()
        WHEN "exit"                            # Esc.結束
           EXIT WHILE
 
     END CASE
  END WHILE
END FUNCTION
 
FUNCTION p_query_rep_b()                       # 單身
DEFINE   l_ac_t          LIKE type_file.num5,               # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
         l_n             LIKE type_file.num5,               # 檢查重複用        #No.FUN-680135 SMALLINT
         l_lock_sw       LIKE type_file.chr1,               # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
         p_cmd           LIKE type_file.chr1,               # 處理狀態          #No.FUN-680135 VARCHAR(1)
         l_allow_insert  LIKE type_file.num5,               #No.FUN-680135 SMALLINT
         l_allow_delete  LIKE type_file.num5                #No.FUN-680135 SMALLINT
DEFINE   l_zay05         LIKE zay_file.zay05 
DEFINE   li_zay05        LIKE zay_file.zay05 
 
   LET g_action_choice = ""
 
   IF cl_null(g_zay02) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT zay04,zay05,zay06,zay07,''",   #No.FUN-770078
                      " FROM zay_file ",
                     "  WHERE zay01 = '",g_zai.zai01 CLIPPED,"'",
                     "   AND zay02 = '",g_zay02 CLIPPED,"'",
                     "   AND zay03 = '",g_zai.zai05 CLIPPED,"'",
                     "   AND zay05 = ? FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE replace_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_zay WITHOUT DEFAULTS FROM s_zay.*
              ATTRIBUTE(COUNT=g_zay_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_zay_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_rep_ac)
         END IF
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_rep_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_zay_rec_b >= l_rep_ac THEN
            LET p_cmd='u'
            LET g_zay_t.* = g_zay[l_rep_ac].*  #BACKUP
 
            IF g_zay_t.zay04 = '1' THEN
               LET l_zay05 = g_zay_t.zay05
            ELSE
               LET l_zay05 = '*'
            END IF
            BEGIN WORK
            OPEN replace_bcl USING l_zay05
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN replace_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH replace_bcl INTO g_zay[l_rep_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH replace_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               IF g_zay[l_rep_ac].zay06 = '2' THEN
                  SELECT ze03 INTO g_zay[l_rep_ac].memo FROM ze_file 
                   WHERE ze01 = g_zay[l_rep_ac].zay07 AND ze02 = g_lang
                  
                  DISPLAY g_zay[l_rep_ac].memo TO FORMONLY.memo
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            IF g_zay[l_rep_ac].zay06 = '1' THEN
               CALL cl_set_action_active("controlp", FALSE)
            ELSE
               CALL cl_set_action_active("controlp", TRUE)
            END IF
            IF g_zay[l_rep_ac].zay04 = '1' THEN
               CALL cl_set_comp_entry("zay05",TRUE) 
            ELSE
               CALL cl_set_comp_entry("zay05",FALSE) 
               LET g_zay[l_rep_ac].zay05 = ''
            END IF
         END IF
 
      BEFORE INSERT
         LET p_cmd = 'a'
         LET l_n = ARR_COUNT()
         INITIALIZE g_zay[l_rep_ac].* TO NULL       #900423
         LET g_zay[l_rep_ac].zay04 = '1'
         LET g_zay[l_rep_ac].zay06 = '1'
         LET g_zay_t.* = g_zay[l_rep_ac].*          #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         CALL cl_set_action_active("controlp", FALSE)
         CALL cl_set_comp_entry("zay05",TRUE) 
         NEXT FIELD zay04
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF g_zay[l_rep_ac].zay04 = '2' THEN
            LET l_zay05 = '*'
         ELSE
            LET l_zay05 = g_zay[l_rep_ac].zay05
         END IF
         INSERT INTO zay_file(zay01,zay02,zay03,zay04,zay05,zay06,zay07)
                      VALUES (g_zai.zai01,g_zay02, g_zai.zai05,
                              g_zay[l_rep_ac].zay04,l_zay05,
                              g_zay[l_rep_ac].zay06,g_zay[l_rep_ac].zay07)
         IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","zay_file",g_zai.zai01,g_zay02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
             ROLLBACK WORK
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_zay_rec_b = g_zay_rec_b + 1
             LET g_rep_upd_tag = 1
         END IF
 
      ON CHANGE zay04
         IF g_zay[l_rep_ac].zay04 = '1' THEN
            CALL cl_set_comp_entry("zay05",TRUE) 
         ELSE
            CALL cl_set_comp_entry("zay05",FALSE) 
            LET g_zay[l_rep_ac].zay05 = ''
         END IF
         
      ON CHANGE zay06 
         IF g_zay[l_rep_ac].zay06 = '1' THEN
            CALL cl_set_action_active("controlp", FALSE)
            LET g_zay[l_rep_ac].memo = ''
            DISPLAY g_zay[l_rep_ac].memo TO FORMONLY.memo
         ELSE
            CALL cl_set_action_active("controlp", TRUE)
            SELECT ze03 INTO g_zay[l_rep_ac].memo FROM ze_file 
             WHERE ze01 = g_zay[l_rep_ac].zay07 AND ze02 = g_lang
            DISPLAY g_zay[l_rep_ac].memo TO FORMONLY.memo
            IF cl_null(g_zay[l_rep_ac].memo) THEN
               NEXT FIELD zay07
            END IF
         END IF
 
      AFTER FIELD zay07
         IF g_zay[l_rep_ac].zay06 = '2' THEN
            SELECT ze03 INTO g_zay[l_rep_ac].memo FROM ze_file 
             WHERE ze01 = g_zay[l_rep_ac].zay07 AND ze02 = g_lang
            DISPLAY g_zay[l_rep_ac].memo TO FORMONLY.memo
            IF cl_null(g_zay[l_rep_ac].memo) THEN
#               CALL cl_err("", "apy-207", 0)      #CHI-B40058
               CALL cl_err("","azz-315",0)         #CHI-B40058
               NEXT FIELD zay07
            END IF
         ELSE
            LET g_zay[l_rep_ac].memo = ''
            DISPLAY g_zay[l_rep_ac].memo TO FORMONLY.memo
         END IF
 
      BEFORE DELETE                            #是否取消單身
         #TQC-790037
         #IF NOT cl_null(g_zay_t.zay05) THEN
          IF (g_zay_t.zay04 = '1' AND NOT cl_null(g_zay_t.zay05)) OR
             (g_zay_t.zay04 = '2')
          THEN
         #END TQC-790037
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            IF g_zay[l_rep_ac].zay04 = '2' THEN
               LET l_zay05 = '*'
            ELSE
               LET l_zay05 = g_zay[l_rep_ac].zay05
            END IF
            DELETE FROM zay_file WHERE zay01 = g_zai.zai01
                                   AND zay02 = g_zay02
                                   AND zay03 = g_zai.zai05
                                   AND zay05 = l_zay05
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","zay_file",g_zai.zai01,g_zay02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            LET g_zay_rec_b = g_zay_rec_b - 1
            LET g_rep_upd_tag = 1
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_zay[l_rep_ac].* = g_zay_t.*
            CLOSE replace_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zay[l_rep_ac].zay05,-263,1)
            LET g_zay[l_rep_ac].* = g_zay_t.*
         ELSE
            IF g_zay[l_rep_ac].zay04 = '2' THEN
               LET l_zay05 = '*'
            ELSE
               LET l_zay05 = g_zay[l_rep_ac].zay05
            END IF
            
            IF g_zay_t.zay04 = '2' THEN
               LET li_zay05 = '*'
            ELSE
               LET li_zay05 = g_zay_t.zay05
            END IF
 
            UPDATE zay_file
               SET zay04 = g_zay[l_rep_ac].zay04,
                   zay05 = l_zay05,
                   zay06 = g_zay[l_rep_ac].zay06,
                   zay07 = g_zay[l_rep_ac].zay07  
             WHERE zay01 = g_zai.zai01
               AND zay02 = g_zay02
               AND zay03 = g_zai.zai05
               AND zay05 = li_zay05
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","zay_file",g_zai.zai01,g_zay02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_zay[l_rep_ac].* = g_zay_t.*
            ELSE
               LET g_rep_upd_tag = 1
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_rep_ac = ARR_CURR()
         LET l_ac_t = l_rep_ac
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #CKP
            IF p_cmd='u' THEN
               LET g_zay[l_rep_ac].* = g_zay_t.*   
            END IF
            CLOSE replace_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE replace_bcl
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(zay07)                     #MOD-530267
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ze"
               LET g_qryparam.arg1 =  g_lang
               LET g_qryparam.default1= g_zay[l_rep_ac].zay07
               CALL cl_create_qry() RETURNING g_zay[l_rep_ac].zay07,g_zay[l_rep_ac].memo
               DISPLAY g_zay[l_rep_ac].zay07 TO zay07
               DISPLAY g_zay[l_rep_ac].memo TO FORMONLY.memo
               NEXT FIELD zay07
         END CASE
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
   END INPUT
   CLOSE replace_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION p_query_rep_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_zay_rec_b)
   DISPLAY ARRAY g_zay TO s_zay.* ATTRIBUTE(UNBUFFERED)
 
      BEFORE ROW
         CALL SET_COUNT(g_zay_rec_b)
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET l_rep_ac = ARR_CURR()
 
      ON ACTION detail                           # B.單身
         LET g_action_choice='detail'
         LET l_rep_ac = 1
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_rep_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION help                             # H.說明
         LET g_action_choice='help'
         EXIT DISPLAY
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#若有更動 zay_file 時，zat11 欄位一定要更新
FUNCTION p_query_upd_zat11(p_zat02,p_zat11)
DEFINE p_zat02     LIKE zat_file.zat02
DEFINE p_zat11     LIKE zat_file.zat11
 
   UPDATE zat_file SET zat11 =  p_zat11   
    WHERE zat01 = g_zai.zai01 AND zat02 = p_zat02
      AND zat10 = g_zai.zai05                             #FUN-750084
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","zat_file",g_zai.zai01,p_zat02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
   END IF
END FUNCTION
 
#FUN-770079
 
#No.FUN-7C0020
#------------------------------------------------------------------------------#
# 取得 p_zz 設定"報表列印抬頭"內容                                             #
#------------------------------------------------------------------------------#
FUNCTION p_query_title()
 DEFINE l_gaz02           LIKE gaz_file.gaz02
 DEFINE l_gaz05           LIKE gaz_file.gaz05
 DEFINE l_gaz06           LIKE gaz_file.gaz06
 DEFINE l_str             STRING
 DEFINE l_sql             STRING
 
    LET l_str = g_zai02_name
 
    SELECT gaz06 INTO l_gaz06 FROM gaz_file
     WHERE gaz01 = g_zai.zai01 AND gaz02 = g_lang AND gaz05 = "Y"
    IF SQLCA.sqlcode THEN
      LET l_gaz06 = ''
    END IF
    LET l_gaz05 = 'Y'
    IF cl_null(l_gaz06) THEN
      SELECT gaz06 INTO l_gaz06 FROM gaz_file
       WHERE gaz01 = g_zai.zai01 AND gaz02 = g_lang AND gaz05 = "N"
      IF SQLCA.sqlcode THEN
        LET l_gaz06 = ''
      END IF
      LET l_gaz05 = 'N'
    END IF
   
    IF NOT cl_null(l_gaz06) THEN
       LET g_zai.zai02 = l_gaz06
       DISPLAY g_zai.zai02 TO zai02
 
       LET l_sql = "SELECT gaz02,gaz06 FROM gaz_file ",
                   " WHERE gaz01 = '",g_zai.zai01 CLIPPED,"'",
                   "   AND gaz05 = '",l_gaz05 CLIPPED,"'",
                   " ORDER BY gaz02 "
       DECLARE gaz_cur CURSOR FROM l_sql
       FOREACH gaz_cur INTO l_gaz02,l_gaz06
          IF NOT cl_null(l_gaz06) THEN
             LET l_str = l_str,
                         "\n ---( ",l_gaz02 CLIPPED,":",l_gaz06 CLIPPED," )--- "
          END IF
       END FOREACH
    END IF
 
    CALL g_node_child.setAttribute("comment",l_str)
END FUNCTION
#END No.FUN-7C0020
 
#TQC-810053
#預設 QBE 畫面欄位寬度
FUNCTION p_query_per_len(p_len)  
DEFINE p_len      LIKE type_file.num10
DEFINE l_len      LIKE type_file.num10
 
   CASE
       WHEN p_len <= 12
          LET l_len = 12
       WHEN p_len <= 20
          LET l_len = 20
       WHEN p_len <= 30
          LET l_len = 30
       OTHERWISE
          LET l_len = 40
   END CASE
 
   RETURN l_len
END FUNCTION
 
FUNCTION p_query_zao()
DEFINE l_cnt             LIKE type_file.num10 
DEFINE l_i               LIKE type_file.num10 
 
   SELECT COUNT(unique zao02) INTO l_cnt FROM zao_file 
    WHERE zao01 = g_zai.zai01 AND zao05 = g_zai.zai05               #FUN-750084
   IF l_cnt < 8 THEN
       DELETE FROM zao_file 
        WHERE zao01=g_zai.zai01 AND zao05=g_zai.zai05               #FUN-750084
       FOR l_i = 1 TO 8 
           LET g_out[l_i].out1=l_i
           IF l_i = 7 THEN
               LET g_out[l_i].out2='N'
               LET g_out[l_i].out3='N'
               LET g_out[l_i].out4='N'
               LET g_out[l_i].out5='N'
           ELSE
               LET g_out[l_i].out2='Y'
               LET g_out[l_i].out3='N'
               LET g_out[l_i].out4='Y'
               LET g_out[l_i].out5='Y'
           END IF
           #FUN-750084 
           INSERT INTO zao_file(zao01,zao02,zao03,zao04,zao05)
                  VALUES(g_zai.zai01,l_i,'V',g_out[l_i].out2,g_zai.zai05) 
           INSERT INTO zao_file(zao01,zao02,zao03,zao04,zao05)
                  VALUES(g_zai.zai01,l_i,'E',g_out[l_i].out3,g_zai.zai05) 
           INSERT INTO zao_file(zao01,zao02,zao03,zao04,zao05)
                  VALUES(g_zai.zai01,l_i,'T',g_out[l_i].out4,g_zai.zai05) 
           INSERT INTO zao_file(zao01,zao02,zao03,zao04,zao05)
                  VALUES(g_zai.zai01,l_i,'P',g_out[l_i].out5,g_zai.zai05) 
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","zao_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","",0)
           #END FUN-750084 
              RETURN
           END IF
           LET g_layout_rec_b = 8
       END FOR
    END IF
END FUNCTION
 
FUNCTION p_query_zap()
DEFINE l_cnt      LIKE type_file.num10 
 
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM zap_file 
    WHERE zap01 = g_zai.zai01 AND zap07 = g_zai.zai05               #FUN-750084
   IF l_cnt = 0 THEN
      LET g_zap.zap02 = 66 
      LET g_zap.zap03 = 2                                           #FUN-7B0010
      LET g_zap.zap04 = 2                                           #FUN-7B0010
      LET g_zap.zap05 = 2                                           #FUN-7B0010
      LET g_zap.zap06 = 6600 
      #FUN-750084
      INSERT INTO zap_file(zap01,zap02,zap03,zap04,zap05,zap06,zap07)
             VALUES(g_zai.zai01,g_zap.zap02,g_zap.zap03,g_zap.zap04,g_zap.zap05,g_zap.zap06,g_zai.zai05) 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","zap_file",g_zai.zai01,g_zai.zai05,SQLCA.sqlcode,"","",0)
      #END FUN-750084
         RETURN
      END IF
      DISPLAY BY NAME g_zap.zap02,g_zap.zap03,g_zap.zap04,g_zap.zap05,g_zap.zap06
   END IF  
END FUNCTION 
#END TQC-810053

#CHI-A60010--start----------------------
#將where條件式清空
FUNCTION p_query_init()
   LET g_wc2 =' 1=1'
   LET g_wc3 =' 1=1'
   LET g_wc4 =' 1=1'
   LET g_wc5 =' 1=1'
   LET g_wc6 =' 1=1'
   LET g_wc7 =' 1=1'
   LET g_wc8 =' 1=1'
END FUNCTION 
#CHI-A60010--end------------------------
