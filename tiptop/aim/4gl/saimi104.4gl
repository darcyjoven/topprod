# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: saimi104.4gl
# Descriptions...: 料件基本資料維護作業-生管資料
# Date & Author..: 91/11/02 By Wu
# Modify ........: 92/06/18 畫面上增加 [生管資料處理狀況](ima93[4,4])
#                           的input查詢...... By Lin
# Modify.........: No.MOD-480155 04/08/26 By Nicola "預設製程料號","預設製程編號" 開窗無資料
# Modify.........: No.MOD-4A0063 04/10/05 By Mandy q_ime 的參數傳的有誤
# Modify.........: No.FUN-4A0041 04/10/06 By Echo 料號開窗
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.FUN-4C0053 04/12/08 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510017 05/01/28 By Mandy 報表轉XML
# Modify.........: No.MOD-540070 05/04/29 By pengu 無法正確顯示附圖
# Modify.........: No.FUN-560187 05/06/22 By kim 新增"MRP匯總時距(天)(ima909)"
# Modify.........: No.FUN-570110 05/07/13 By vivien KEY值更改控制
# Modify.........: No.MOD-560085 05/08/14 By kim ima55生產單位已有建立BOM的資料時加提示
# Modify.........: No.FUN-5A0049 05/10/13 By Sarah "發料前調撥"與"消耗性料件"選項不能同時勾選
# Modify.........: No.FUN-610080 06/01/20 By Sarah 增加"標準機器工時"欄位(ima912)
# Modify.........: No.TQC-630044 06/03/08 By Pengu不應控管"消耗性料件""發料前調撥"兩個屬性不能同時存在
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-640213 06/07/13 By rainy 連續二次查詢key值時,若第二次查詢不到key值時, 會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/25 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6A0078 06/11/09 By ice 修正報表格式錯誤
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-740138 07/04/22 By kim 當預設製程料號(ima571)與料號相同則不需檢查ima571
# Modify.........: No.TQC-750153 07/05/23 By kim 修正MOD-740138的錯誤
# Modify.........: No.TQC-760058 07/05/15 By rainy 將TQC-750153過到正式區
# Modify.........: No.MOD-7A0102 07/10/18 By Carol 調整圖形顯示
# Modify.........: NO.MOD-7A0192 07/10/30 BY yiting 按action "建立料件單位轉換"  應該帶料號至開啟視窗中
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840029 08/04/21 By sherry 報表改由CR輸出 
# Modify.........: No.FUN-850037 08/05/08 By baofei 調整g_sql所組成的SQL語法欄位個數與XML個數相同
# Modify.........: No.FUN-840194 08/06/20 By Sherry 增加變動前置時間批量(ima601)
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-910053 09/02/12 By jan 增加ima153欄位 
# Modify.........: No.CHI-970007 09/07/06 By mike 請將IF g_ima.ima94 is not null 的判斷改用呼叫cl_null()做判斷                      
# Modify.........: No.FUN-930143 09/08/14 By arman 處理狀況欄位可以查詢                      
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0178 09/10/29 By lilingyu 更改資料確實時,程序當出
# Modify.........: No.CHI-9A0028 09/10/29 By mike 在AFTER INPUT判断栏位必key时,错误讯息增加呈现栏位代号,避免user不知道哪个栏位被卡住
# Modify.........: No.TQC-9B0021 09/11/05 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-970027 09/11/12 By jan 修改ima111的檢查
# Modify.........: No.FUN-9C0072 10/01/05 By vealxu 精簡程式碼
# Modify.........: No:MOD-A50113 10/05/18 By Sarah 若ima571有值,ima94開窗用q_ecu101;若ima571沒值,ima94開窗用q_ecu1
# Modify.........: No:FUN-A50011 10/07/12 By yangfeng 增加aimi100中對子料件的更新
# Modify.........: No.FUN-A70145 10/07/30 By alex 調整ASE SQL
# Modify.........: No.FUN-A90049 10/09/25 By vealxu 1.只能允許查詢料件性質(ima120)='1' (企業料號')
#                                                   2.程式中如有  INSERT INTO ima_file 時料件性質(ima120)值給'1'(企業料號)
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No:FUN-AB0025 11/11/10 By lixh1  開窗BUG處理
# Modify.........: No.MOD-AC0161 10/12/18 By vealxu call 's_upd_ima_subparts('的程式段，都要先判斷如果行業別是鞋服業才做
# Modify.........: No.FUN-B10018 11/01/25 By vealxu 抓取ima94值有錯
# Modify.........: No:TQC-B20007 11/02/12 By destiny show的时候未显示oriu,orig
# Modify.........: No:TQC-B20087 11/02/17 By jan 1.調整製程編號開窗 2.修改sql
# Modify.........: No.TQC-B90177 11/09/29 By destiny oriu,orig不能查询 
# Modify.........: No.TQC-BA0085 11/10/17 By houlia ima561小於ima56的時候彈出建議對話框
# Modify.........: No.FUN-B90102 11/10/18 By qiaozy 服飾開發：子料件不可修改，母料件需要把ima資料更新到子料件中
# Modify.........: No.FUN-B90102 11/11/24 By qiaozy ima94缺省工艺编号可开窗录入/修改，不可由母料件值赋值
# Modify.........: No:FUN-BB0086 11/12/02 By tanxc 增加數量欄位小數取位
# Modify.........: No.FUN-B80032 11/12/15 By yangxf ima_file 更新揮寫rtepos
# Modify.........: No.CHI-BB0056 11/12/22 By ck2yuan ima136/ima137開窗增加控管需唯為WIP倉

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.TQC-C40155 12/04/18 By xianghui 修改時點取消，還原成舊值的處理
# Modify.........: No.TQC-C40219 12/04/24 By xianghui 修正TQC-C40155的問題
# Modify.........: No.CHI-C90006 12/11/13 By bart 失效判斷
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 添加庫位有效性檢查

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
  g_argv1      LIKE ima_file.ima01,
  g_ima        RECORD LIKE ima_file.*,
  g_ima_t      RECORD LIKE ima_file.*,
  g_ima_o      RECORD LIKE ima_file.*,
  g_ima01_t    LIKE ima_file.ima01,
  g_sw         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  g_wc,g_sql   STRING,                 #TQC-630166
  g_ima93_4    LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)#FUN-930143

DEFINE g_db_type  LIKE type_file.chr3  #No.FUN-930143 
DEFINE g_forupd_sql          STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_chr                 LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                   LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump                LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_no_ask             LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570110  #No.FUN-690026 SMALLINT
DEFINE g_str                 STRING                 #No.FUN-840029 
DEFINE g_ima55_t             LIKE ima_file.ima55    #No.FUN-BB0086 
DEFINE g_ima63_t             LIKE ima_file.ima63    #No.FUN-BB0086 

FUNCTION aimi104(p_argv1)
    DEFINE p_argv1         LIKE ima_file.ima01

    INITIALIZE g_ima.* TO NULL
    INITIALIZE g_ima_t.* TO NULL

 
    #--LOCK CURSOR
    LET g_forupd_sql = "SELECT * FROM ima_file WHERE ima01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)


    DECLARE aimi104_curl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET g_argv1 = p_argv1
    LET g_db_type=cl_db_get_database_type()    #No.FUN-930143

    OPEN WINDOW aimi104_w WITH FORM "aim/42f/aimi104"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    IF g_argv1 IS NOT NULL AND g_argv1 != ' '
       THEN CALL aimi104_q()
    END IF
 
    WHILE TRUE
      LET g_action_choice=""
    CALL aimi104_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW aimi104_w

END FUNCTION
 
FUNCTION aimi104_curs()
    CLEAR FORM
    IF g_argv1 IS NULL OR g_argv1 = " " THEN
       
       INITIALIZE g_ima.* TO NULL    #FUN-640213 add
       
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
           ima01, ima02, ima021,    ima08 , ima05, ima25 , ima03,ima93_4,  #No.FUN-930143 add ima93_4
           ima70, ima55, ima55_fac, ima110, ima56, ima561, ima562,ima909, ima153,#FUN-560187 add ima909 #FUN-910053 add ima153
           ima59, ima60, ima601,ima61,     ima62,  ima58,    #No.FUN-930143 add ima601
           ima912,   #FUN-610080
           ima571,ima94, ima111,
           ima67, ima68, ima69,
           ima63, ima63_fac, ima108, ima136, ima137, ima64, ima641,
           imauser, imagrup, imamodu, imadate, imaacti
           ,imaoriu,imaorig  #TQC-B90177
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
           ON ACTION controlp
               CASE
                  WHEN INFIELD(ima01)
#FUN-AA0059 --Begin--
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ima"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = "(ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"     #FUN-AB0025
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                 #  CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret   #FUN-AB0025
#FUN-AA0059 --End--
                   DISPLAY g_qryparam.multiret TO ima01
                   NEXT FIELD ima01
 
                  WHEN INFIELD(ima111)                       #預設工單單別
                     CALL q_smy(TRUE,TRUE,' ','ASF','1') RETURNING g_qryparam.multiret #TQC-670008
                     DISPLAY g_qryparam.multiret TO ima111
                     NEXT FIELD ima111
                  WHEN INFIELD(ima67)                         #采購員(ima67)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state="c"
                     LET g_qryparam.form ="q_gen"
                     LET g_qryparam.default1 = g_ima.ima67
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ima67
                     CALL aimi104_peo(g_ima.ima67,'d')
                     NEXT FIELD ima67
                  WHEN INFIELD(ima55)                       # 生產單位 (ima55)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state="c"
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_ima.ima55
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ima55
                     NEXT FIELD ima55
                  WHEN INFIELD(ima63)                       # 發料單位 (ima63)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state="c"
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_ima.ima63
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ima63
                     NEXT FIELD ima63
                  WHEN INFIELD(ima136)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state="c"
                     LET g_qryparam.form ="q_imd"
                      LET g_qryparam.default1 = g_ima.ima136 #MOD-4A0213
                      #LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213  #CHI-BB0056 mark
                     LET g_qryparam.arg1     = 'W'                                  #CHI-BB0056 add
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ima136
                     NEXT FIELD ima136
                  WHEN INFIELD(ima137)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state="c"
                     LET g_qryparam.form ="q_ime"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ima137
                     NEXT FIELD ima137
                  WHEN INFIELD(ima571)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state="c"
                     LET g_qryparam.form ="q_ecu1"
                     LET g_qryparam.default1 = g_ima.ima571
                     LET g_qryparam.multiret_index = 1
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ima571
                     NEXT FIELD ima571
                  WHEN INFIELD(ima94)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state="c"
                     LET g_qryparam.form ="q_ecu1"
                     LET g_qryparam.default1 = g_ima.ima571
                     LET g_qryparam.default2 = g_ima.ima94
                     LET g_qryparam.multiret_index = 2
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ima94
                     NEXT FIELD ima94
                  OTHERWISE EXIT CASE
               END CASE
 
           ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
           ON ACTION about         #MOD-4C0121
              CALL cl_about()      #MOD-4C0121
 
           ON ACTION HELP          #MOD-4C0121
              CALL cl_show_help()  #MOD-4C0121
 
           ON ACTION controlg      #MOD-4C0121
              CALL cl_cmdask()     #MOD-4C0121
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
    ELSE
      LET g_wc = " ima01 = '",g_argv1,"'"
    END IF
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
 
      LET g_wc=cl_replace_str(g_wc, "ima93_4", "ima93[4,4]")     #FUN-A70145
#     IF g_db_type = 'ORA' OR g_db_type = 'IFX' THEN
#        LET g_wc=cl_replace_str(g_wc, "ima93_4", "ima93[4,4]")  #No.TQC-9B0021
#     ELSE
#        IF g_db_type = 'MSV' THEN
#           LET g_wc=cl_replace_str(g_wc, "ima93_4", "ima93[4,4]")  #No.TQC-9B0021
#        END IF
#     END IF

#   LET g_sql="SELECT ima01 FROM ima_file WHERE ",g_wc CLIPPED, " ORDER BY ima01"                   #FUN-A90049 mark
    LET g_sql="SELECT ima01 FROM ima_file WHERE ( ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL ) AND ",g_wc CLIPPED, " ORDER BY ima01"  #FUN-A90049 add 
    PREPARE aimi104_prepare FROM g_sql             # RUNTIME 編譯
    DECLARE aimi104_curs                           # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR aimi104_prepare
    LET g_sql=
#       "SELECT COUNT(*) FROM ima_file WHERE ",g_wc CLIPPED                            #FUN-A90049 mark
        "SELECT COUNT(*) FROM ima_file WHERE ( ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL ) AND ",g_wc CLIPPED           #FUN-A90049 add  
    PREPARE aimi104_precount FROM g_sql
    DECLARE aimi104_count CURSOR FOR aimi104_precount
END FUNCTION
 
FUNCTION aimi104_menu()
   DEFINE l_cmd LIKE type_file.chr1000   #no.MOD-7A0192
 
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL aimi104_q()
            END IF
        ON ACTION NEXT
            CALL aimi104_fetch('N')
        ON ACTION PREVIOUS
            CALL aimi104_fetch('P')
        ON ACTION MODIFY
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL aimi104_u()
            END IF
       ON ACTION OUTPUT
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL aimi104_out()
            END IF
        ON ACTION HELP
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL i104_show_pic()
           CALL cl_show_fld_cont()   #FUN-550077
        ON ACTION EXIT
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL aimi104_fetch('/')
        ON ACTION FIRST
            CALL aimi104_fetch('F')
        ON ACTION LAST
            CALL aimi104_fetch('L')
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        ON ACTION related_document                 #相關文件             
           LET g_action_choice="related_document"      
              IF cl_chk_act_auth() THEN               
                 IF g_ima.ima01 IS NOT NULL THEN    
                  LET g_doc.column1 = "ima01" 
                  LET g_doc.value1 = g_ima.ima01         
                  CALL cl_doc()                       
              END IF                               
           END IF                                
 
        ON ACTION create_item
           LET g_action_choice="create_item"
           IF cl_chk_act_auth() THEN
              LET l_cmd = "aooi103 '",g_ima.ima01,"'"
              CALL cl_cmdrun_wait(l_cmd)
           END IF
 
        -- for Windows close event trapped
        ON ACTION CLOSE   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      &include "qry_string.4gl"
 
    END MENU
    CLOSE aimi104_curs
END FUNCTION
 
 
FUNCTION aimi104_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_cont          LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_ima08         LIKE ima_file.ima08,
        l_direct        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_direct2       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_cnt           LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_n             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_case          STRING,                  #No.FUN-BB0086 add
        l_imd10         LIKE imd_file.imd10     #CHI-BB0056
 
DISPLAY "aimi104_i : p_cmd=",p_cmd
    DISPLAY BY NAME g_ima.imauser,g_ima.imagrup,g_ima.imadate,
                    g_ima.imaacti
 
    LET g_ima93_4=g_ima.ima93[4,4]
    DISPLAY g_ima93_4 TO FORMONLY.ima93_4      #No.FUN-930143
    INPUT BY NAME
        g_ima.ima01,g_ima.ima02,g_ima.ima021,g_ima.ima08,g_ima.ima05,g_ima.ima25,
        g_ima.ima03,g_ima.ima70 ,g_ima.ima55,g_ima.ima55_fac,g_ima.ima110,
        g_ima.ima56,g_ima.ima561,g_ima.ima562,g_ima.ima909,g_ima.ima153,#FUN-560187 add ima909 #FUN-910053 add ima153
        g_ima.ima59,g_ima.ima60 ,g_ima.ima601,g_ima.ima61,g_ima.ima62,g_ima.ima58, #FUN-840194
        g_ima.ima912,   #FUN-610080
        g_ima.ima571,g_ima.ima94,g_ima.ima111,
        g_ima.ima67,g_ima.ima68,g_ima.ima69,
        g_ima.ima63,g_ima.ima63_fac,g_ima.ima108,g_ima.ima136,
        g_ima.ima137,g_ima.ima64,g_ima.ima641,
        g_ima.imauser, g_ima.imagrup, g_ima.imamodu,
        g_ima.imadate, g_ima.imaacti
      WITHOUT DEFAULTS
 
        BEFORE INPUT
             LET g_before_input_done = FALSE
             CALL i104_set_entry(p_cmd)
             CALL i104_set_no_entry(p_cmd)
             LET g_before_input_done = TRUE
             #No.FUN-BB0086--add--start-- 
             IF p_cmd = 'u' THEN 
                LET g_ima55_t = g_ima.ima55
                LET g_ima63_t = g_ima.ima63
             END IF 
             IF p_cmd = 'a' THEN 
                LET g_ima55_t = NULL 
                LET g_ima63_t = NULL 
             END IF 
             #No.FUN-BB0086--add--end--
 
#@@@@@可使為消耗性料件 1.多倉儲管理(sma12 = 'y')
#@@@@@                 2.使用製程(sma54 = 'y')
        AFTER FIELD ima70  #消耗料件
            IF g_ima.ima70 IS NOT NULL THEN
               IF g_ima.ima70 NOT MATCHES '[YN]'
                  THEN NEXT FIELD ima70
               END IF
               IF (g_ima_o.ima70 IS NULL) OR (g_ima_t.ima70 IS NULL)
                     OR (g_ima.ima70 != g_ima_o.ima70)
                 THEN IF g_ima.ima70 NOT MATCHES "[YN]"
                         OR g_ima.ima70 IS NULL THEN
                           CALL cl_err(g_ima.ima70,'mfg1002',0)
                           LET g_ima.ima70 = g_ima_o.ima70
                           DISPLAY BY NAME g_ima.ima70
                           NEXT FIELD ima70
                       END IF
               END IF
               LET g_ima_o.ima70 = g_ima.ima70
            END IF
 
        AFTER FIELD ima110
            IF cl_null(g_ima.ima110) OR g_ima.ima110 NOT MATCHES '[1234]'
            THEN LET g_ima.ima110 = g_ima_o.ima110
                 DISPLAY BY NAME g_ima.ima110
                 NEXT FIELD ima110
            END IF
            
 
        BEFORE FIELD ima55           #生產單位=NULL時, Default 庫存單位
            IF g_ima_o.ima55 IS NULL AND g_ima.ima55 IS NULL THEN
               LET g_ima.ima55=g_ima.ima25
               LET g_ima_o.ima55=g_ima.ima25
               DISPLAY BY NAME g_ima.ima55
            END IF
        AFTER FIELD ima55           #生產單位
            IF g_ima.ima55 IS NULL
               THEN LET g_ima.ima55=g_ima.ima25
                    DISPLAY BY NAME g_ima.ima55
            END IF
            IF  g_ima.ima55 IS NULL
               THEN LET g_ima.ima55 = g_ima_o.ima55
                    DISPLAY BY NAME g_ima.ima55
                    NEXT FIELD ima55
            END IF
            IF g_ima.ima55 IS NOT NULL
               THEN IF (g_ima_o.ima55 IS NULL) OR (g_ima.ima55 != g_ima_o.ima55)
                       THEN SELECT gfe01
                              FROM gfe_file WHERE gfe01=g_ima.ima55 AND
                                                  gfeacti IN ('Y','y')
                            IF SQLCA.sqlcode  THEN
                               CALL cl_err3("sel","gfe_file",g_ima.ima55,"",
                                            "mfg1325","","",1)  #No.FUN-660156
                               LET g_ima.ima55 = g_ima_o.ima55
                               DISPLAY BY NAME g_ima.ima55
                               NEXT FIELD ima55
#若料件生產單位與料件庫存單位相同，則轉換因子應為 1，不需輸入。
                            ELSE IF g_ima.ima55 = g_ima.ima25
                                 THEN LET g_ima.ima55_fac = 1
                                 ELSE CALL s_umfchk(g_ima.ima01,g_ima.ima55,
                                                    g_ima.ima25)
                                      RETURNING g_sw,g_ima.ima55_fac
                                      IF g_sw = '1' THEN
                                         CALL cl_err(g_ima.ima25,'mfg1206',0)
                                         LET g_ima.ima55 = g_ima_o.ima55
                                         DISPLAY BY NAME g_ima.ima55
                                         LET g_ima.ima55_fac = g_ima_o.ima55_fac
                                         DISPLAY BY NAME g_ima.ima55_fac
                                         NEXT FIELD ima55
                                      END IF
                                 END IF
                            END IF
                        LET l_cnt = 0
                        SELECT COUNT(*) INTO l_cnt FROM bma_file
                         WHERE bma01 = g_ima.ima01
                           AND bmaacti = 'Y'
                        IF l_cnt > 0 THEN
                           CALL cl_err('','aim-134',1)
                        END IF
                        DISPLAY BY NAME g_ima.ima55_fac
                  END IF

            END IF
            LET g_ima_o.ima55 = g_ima.ima55
            LET g_ima_o.ima55_fac = g_ima.ima55_fac
            LET l_direct2='U'
            #FUN-BB0086---add---start
            LET l_case = ""
            IF NOT cl_null(g_ima.ima56) AND g_ima.ima56<>0 THEN 
               IF NOT i104_ima56_check() THEN 
                  LET l_case = "ima56"
               END IF 
            END IF
            IF NOT cl_null(g_ima.ima561) AND g_ima.ima561<>0 THEN
               IF NOT i104_ima561_check() THEN 
                  LET l_case = "ima561"
               END IF 
            END IF
            
            LET g_ima55_t = g_ima.ima55
            CASE l_case
               WHEN "ima56"
                  NEXT FIELD ima56
               WHEN "ima561"
                  NEXT FIELD ima561
               OTHERWISE EXIT CASE
            END CASE    
            #FUN-BB0086---add---end
 
#為防本來已有生產單位與單位相同,而轉換率尚無值 MAY
        BEFORE FIELD ima55_fac
            IF g_ima.ima25 = g_ima.ima55 THEN LET g_ima.ima55_fac = 1 END IF
        AFTER FIELD ima55_fac
            IF g_ima.ima55_fac IS NULL OR g_ima.ima55_fac = ' '
               OR g_ima.ima55_fac <= 0
            THEN CALL cl_err(g_ima.ima55_fac,'mfg1322',0)
                 LET  g_ima.ima55_fac = g_ima_o.ima55_fac
                 DISPLAY BY NAME g_ima.ima55_fac
                 NEXT FIELD ima55_fac
            END IF
            LET g_ima_o.ima55_fac = g_ima.ima55_fac
 
        BEFORE FIELD ima56
             IF g_ima.ima56 IS NULL THEN LET g_ima.ima56 = 1 END IF
 
        AFTER FIELD ima56          #生產單位批數
 #若輸入為零表示不作控制，系統自動轉為  1。
           IF NOT i104_ima56_check() THEN NEXT FIELD ima56 END IF   #No.FUN-BB0086
           #FUN-BB0086--mark--start--
           #  IF g_ima.ima56 IS NULL OR g_ima.ima56 = ' '
           #    OR g_ima.ima56 < 0
           #    THEN
           #         CALL cl_err(g_ima.ima56,'mfg0013',0)
           #         LET g_ima.ima56 = g_ima_o.ima56
           #         DISPLAY BY NAME g_ima.ima56
           #         NEXT FIELD ima56
           #  END IF
           # LET g_ima_o.ima56 = g_ima.ima56
           #FUN-BB0086--mark--end--
 
        BEFORE FIELD ima561
             IF g_ima.ima561 IS NULL THEN LET g_ima.ima561= 0 END IF
 
        AFTER FIELD ima561          #最少生產數量
#輸入之數量應為前述生產單位批量的倍數    MAY
          IF NOT i104_ima561_check() THEN NEXT FIELD ima561 END IF   #No.FUN-BB0086
          #FUN-BB0086--mark--start--
          #IF  g_ima.ima561 >1 AND g_ima.ima56 >0
          #    THEN
          # #  IF (g_ima.ima56 mod g_ima.ima561) != 0 THEN     #TQC-BA0085
          #    IF (g_ima.ima56 mod g_ima.ima561) != 0 OR g_ima.ima561 < g_ima.ima56 THEN     #TQC-BA0085
          #       CALL aimi104_size()
          #    END IF
          #END IF
          #  IF g_ima.ima561 IS NULL OR g_ima.ima561 = ' '
          #      OR g_ima.ima561 < 0
          #      THEN CALL cl_err(g_ima.ima561,'mfg0013',0)
          #           LET g_ima.ima561 = g_ima_o.ima561
          #           DISPLAY BY NAME g_ima.ima561
          #           NEXT FIELD ima561
          #   END IF
          #  LET g_ima_o.ima561 = g_ima.ima561
          #FUN-BB0086--mark--end--
 
        AFTER FIELD ima562          #生產時損耗率
             IF g_ima.ima562 IS NULL OR g_ima.ima562 = ' '
               OR g_ima.ima562 < 0 OR g_ima.ima562 > 100
                THEN CALL cl_err(g_ima.ima62,'mfg1332',0)
                     LET g_ima.ima562 = g_ima_o.ima562
                     DISPLAY BY NAME g_ima.ima562
                     NEXT FIELD ima562
             END IF
            LET g_ima_o.ima562 = g_ima.ima562
 
        AFTER FIELD ima67            #計劃員
           IF (g_ima_o.ima67 IS NULL ) OR (g_ima.ima67 != g_ima_o.ima67)
               OR (g_ima_o.ima67 IS NOT NULL AND g_ima.ima67 IS NULL)
              THEN CALL aimi104_peo(g_ima.ima67,'a')
                   IF g_chr = 'E' THEN
                      CALL cl_err(g_ima.ima67,'mfg1312',0)
                      LET g_ima.ima67 = g_ima_o.ima67
                      DISPLAY BY NAME g_ima.ima67
                      NEXT FIELD ima67
                   END IF
            END IF
            LET g_ima_o.ima67 = g_ima.ima67
            LET l_direct = 'U'
 
        AFTER FIELD ima68          #需求時距
             IF g_ima.ima68 IS NULL OR g_ima.ima68 = ' '
                 OR g_ima.ima68 < 0
                THEN CALL cl_err(g_ima.ima68,'mfg0013',0)
                     LET g_ima.ima68 = g_ima_o.ima68
                     DISPLAY BY NAME g_ima.ima68
                     NEXT FIELD ima68
             END IF
            LET g_ima_o.ima68 = g_ima.ima68
 
        AFTER FIELD ima69          #計劃時距
             IF g_ima.ima69 IS NULL OR g_ima.ima69 = ' '
                 OR g_ima.ima69 < 0
                THEN CALL cl_err(g_ima.ima69,'mfg0013',0)
                     LET g_ima.ima69 = g_ima_o.ima69
                     DISPLAY BY NAME g_ima.ima69
                     NEXT FIELD ima69
             END IF
            LET g_ima_o.ima69 = g_ima.ima69
        AFTER FIELD ima571
          IF NOT cl_null(g_ima.ima571) THEN
             IF g_ima.ima01<>g_ima.ima571 THEN
                SELECT COUNT(*) INTO g_cnt FROM ecu_file WHERE ecu01=g_ima.ima571
                   AND ecuacti = 'Y'  #CHI-C90006
                IF g_cnt =0 THEN
                   CALL cl_err(g_ima.ima571,'aec-014',0)
                   LET g_ima.ima571 = g_ima_o.ima571
                   DISPLAY BY NAME g_ima.ima571
                   NEXT FIELD ima571
                END IF
             END IF
          END IF
 
        AFTER FIELD ima94
            LET g_msg=NULL
            IF NOT cl_null(g_ima.ima94) THEN #CHI-970007   
               IF NOT cl_null(g_ima.ima571) THEN
                 #FUN-B10018 -------mod start------
                  LET g_sql = "SELECT ecu03 FROM ecu_file ",
                              " WHERE ecu01 = '",g_ima.ima571,"'",
                              "   AND ecu02 = '",g_ima.ima94,"'",
                              "   AND ecuacti = 'Y' "  #CHI-C90006 
                  PREPARE ecu03_pre01 FROM g_sql
                  DECLARE ecu03_curs01 CURSOR FOR ecu03_pre01
                  FOREACH ecu03_curs01 INTO g_msg
                     EXIT FOREACH
                  END FOREACH  
                 #SELECT ecu03 INTO g_msg FROM ecu_file
                 # WHERE ecu01=g_ima.ima571 AND ecu02=g_ima.ima94
                 #FUN-B10018 -------mod end--------
               ELSE
                  #FUN-B10018 -------mod start------
                  LET g_sql = "SELECT ecu03 FROM ecu_file ",
                              " WHERE ecu02 = '",g_ima.ima94,"'",
                              " AND ecuacti = 'Y' "  #CHI-C90006 
                  PREPARE ecu03_pre02 FROM g_sql
                  DECLARE ecu03_curs02 CURSOR FOR ecu03_pre02
                  FOREACH ecu03_curs02 INTO g_msg
                     EXIT FOREACH
                  END FOREACH
                 #SELECT unique ecu03 INTO g_msg FROM ecu_file
                 # WHERE ecu02=g_ima.ima94
                 #FUN-B10018 -------mod end--------
               END IF
               IF STATUS=100         THEN #No.7926
                  CALL cl_err(g_ima.ima94,'aec-014',0)
                  LET g_ima.ima94 = g_ima_o.ima94
                  DISPLAY BY NAME g_ima.ima94
                  NEXT FIELD ima94
               END IF
             END IF
             DISPLAY g_msg TO ecu03
 
        AFTER FIELD ima58          #標準人工工時
             IF g_ima.ima58 IS NULL OR g_ima.ima58 = ' '
                OR g_ima.ima58 < 0
                THEN CALL cl_err(g_ima.ima58,'mfg0013',0)
                     LET g_ima.ima58 = g_ima_o.ima58
                     DISPLAY BY NAME g_ima.ima58
                     NEXT FIELD ima58
             END IF
             LET g_ima_o.ima58 = g_ima.ima58
 
        AFTER FIELD ima912         #標準機器工時
             IF g_ima.ima912 IS NULL OR g_ima.ima912 = ' '
                OR g_ima.ima912 < 0
                THEN CALL cl_err(g_ima.ima912,'mfg1322',0)  #不可空白，且輸入之值必須大於零
                     LET g_ima.ima912 = g_ima_o.ima912
                     DISPLAY BY NAME g_ima.ima912
                     NEXT FIELD ima912
             END IF
             LET g_ima_o.ima912 = g_ima.ima912
 
        AFTER FIELD ima59          #固定前置時間
             IF g_ima.ima59 IS NULL OR g_ima.ima59 = ' '
                OR g_ima.ima59 < 0
                THEN CALL cl_err(g_ima.ima59,'mfg0013',0)
                     LET g_ima.ima59 = g_ima_o.ima59
                     DISPLAY BY NAME g_ima.ima59
                     NEXT FIELD ima59
             END IF
            LET g_ima_o.ima59 = g_ima.ima59
 
        AFTER FIELD ima60          #變動前置時間
             IF g_ima.ima60 IS NULL OR g_ima.ima60 = ' '
                OR g_ima.ima60 < 0
                THEN CALL cl_err(g_ima.ima60,'mfg0013',0)
                     LET g_ima.ima60 = g_ima_o.ima60
                     DISPLAY BY NAME g_ima.ima60
                     NEXT FIELD ima60
             END IF
            LET g_ima_o.ima60 = g_ima.ima60
 
        AFTER FIELD ima601          #變動前置時間批量
             IF g_ima.ima601 IS NULL OR g_ima.ima601 = ' '
                OR g_ima.ima601 <= 0
                THEN CALL cl_err(g_ima.ima601,'mfg9243',0)
                     LET g_ima.ima601 = g_ima_o.ima601
                     DISPLAY BY NAME g_ima.ima601
                     NEXT FIELD ima601
             END IF
            LET g_ima_o.ima601 = g_ima.ima601
 
        AFTER FIELD ima61          #QC前置時間
             IF g_ima.ima61 IS NULL OR g_ima.ima61 = ' '
                OR g_ima.ima61 < 0
                THEN CALL cl_err(g_ima.ima61,'mfg0013',0)
                     LET g_ima.ima61 = g_ima_o.ima61
                     DISPLAY BY NAME g_ima.ima61
                     NEXT FIELD ima61
             END IF
            LET g_ima_o.ima61 = g_ima.ima61
 
        AFTER FIELD ima62          #累計前置時間
             IF g_ima.ima62 IS NULL OR g_ima.ima62 = ' '
                OR g_ima.ima62 < 0
                THEN CALL cl_err(g_ima.ima62,'mfg0013',0)
                     LET g_ima.ima62 = g_ima_o.ima62
                     DISPLAY BY NAME g_ima.ima62
                     NEXT FIELD ima62
             END IF
            LET g_ima_o.ima62 = g_ima.ima62
 
        AFTER FIELD ima111
          IF NOT cl_null(g_ima.ima111) THEN
             SELECT COUNT(*) INTO l_cnt FROM smy_file
              WHERE smyslip=g_ima.ima111 AND smysys='asf'
              AND smykind='1'   #FUN-970027
             IF l_cnt=0 THEN
                CALL cl_err(g_ima.ima111,'mfg0014',2)
                NEXT FIELD ima111
             END IF
          END IF
          LET l_direct='U'
 
        BEFORE FIELD ima63           #發料單位=NULL時, Default 庫存單位
            IF g_ima_o.ima63 IS NULL AND g_ima.ima63 IS NULL THEN
               LET g_ima.ima63=g_ima.ima25
               LET g_ima_o.ima63=g_ima.ima25
               DISPLAY BY NAME g_ima.ima63
            END IF
 
        AFTER FIELD ima63           #發料單位
#輸入時，若為空白，則預設值為庫存單位。
            IF g_ima.ima63 IS NULL
               THEN LET g_ima.ima63=g_ima.ima25
                    DISPLAY  BY NAME g_ima.ima63
            END IF
            IF  g_ima.ima63 IS NULL
              THEN LET g_ima.ima63 = g_ima_o.ima63
                   DISPLAY BY NAME g_ima.ima63
                   NEXT FIELD ima63
            END IF
            IF (g_ima_o.ima63 IS NULL) OR (g_ima.ima63 != g_ima_o.ima63)
              THEN SELECT gfe01
                     FROM gfe_file WHERE gfe01=g_ima.ima63 AND
                                         gfeacti IN ('Y','y')
                   IF SQLCA.sqlcode  THEN
                      CALL cl_err3("sel","gfe_file",g_ima.ima63,"",
                                   "mfg1326","","",1)  #No.FUN-660156
                      LET g_ima.ima63 = g_ima_o.ima63
                      DISPLAY BY NAME g_ima.ima63
                      NEXT FIELD ima63
                   ELSE IF g_ima.ima63 = g_ima.ima25
                        THEN LET g_ima.ima63_fac = 1
                        ELSE CALL s_umfchk(g_ima.ima01,g_ima.ima63,
                                           g_ima.ima25)
                             RETURNING g_sw,g_ima.ima63_fac
                             IF g_sw = '1' THEN
                                CALL cl_err(g_ima.ima63,'mfg1206',0)
                                LET g_ima.ima63 = g_ima_o.ima63
                                DISPLAY BY NAME g_ima.ima63
                                LET g_ima.ima63_fac = g_ima_o.ima63_fac
                                DISPLAY BY NAME g_ima.ima63_fac
                                NEXT FIELD ima63
                             END IF
                            END IF
                       DISPLAY BY NAME g_ima.ima63_fac
                  END IF
            END IF
            LET g_ima_o.ima63 = g_ima.ima63
            LET g_ima_o.ima63_fac = g_ima.ima63_fac
            
            #No.FUN-BB0086--add--start--
            LET l_case = ""
            IF NOT cl_null(g_ima.ima641) AND g_ima.ima641<>0 THEN
               CALL i104_ima641_check(l_direct) RETURNING l_case,l_direct
            END IF
            IF NOT cl_null(g_ima.ima64) AND g_ima.ima64<>0 THEN
               IF NOT i104_ima64_check() THEN
                  LET l_case = "ima64"
               END IF
            END IF
            LET g_ima63_t = g_ima.ima63
            CASE l_case 
               WHEN "ima64"
                  NEXT FIELD ima64
               WHEN "ima641"
                  NEXT FIELD ima641
               OTHERWISE EXIT CASE
            END CASE    
            #No.FUN-BB0086--add--start--
 
        BEFORE FIELD ima63_fac
#為防本來已有生產單位與單位相同,而轉換率尚無值 MAY
            IF g_ima.ima25 = g_ima.ima63 THEN
               LET g_ima.ima63_fac = 1
            END IF
 
        AFTER FIELD ima63_fac
            IF g_ima.ima63_fac IS NULL OR g_ima.ima63_fac = ' '
               OR g_ima.ima63_fac <= 0
            THEN CALL cl_err(g_ima.ima63_fac,'mfg1322',0)
                 LET g_ima.ima63_fac = g_ima_o.ima63_fac
                 DISPLAY BY NAME g_ima.ima63_fac
                 NEXT FIELD ima63_fac
            END IF
            LET g_ima_o.ima63_fac = g_ima.ima63_fac
 
 
        AFTER FIELD ima64          #發料單位批數
           IF NOT i104_ima64_check() THEN NEXT FIELD ima64 END IF   #No.FUN-BB0086
            #No.FUN-BB0086---mark---start--
            # IF g_ima.ima64 IS NULL OR g_ima.ima64 = ' '
            #   OR g_ima.ima64 < 0
            #    THEN CALL cl_err(g_ima.ima64,'mfg0013',0)
            #         LET g_ima.ima64 = g_ima_o.ima64
            #         DISPLAY BY NAME g_ima.ima64
            #         NEXT FIELD ima64
            # END IF
            #LET g_ima_o.ima64 = g_ima.ima64
            #No.FUN-BB0086---mark---end--
 
        AFTER FIELD ima641          #最少發料數量
           #No.FUN-BB0086--add--start---
           CALL i104_ima641_check(l_direct) RETURNING l_case,l_direct
           LET l_case = ""
           CASE l_case
              WHEN "ima641"
                 NEXT FIELD ima641
              WHEN "ima64"
                 NEXT FIELD ima64
              OTHERWISE EXIT CASE
           END CASE    
           #No.FUN-BB0086--add--end---
            #No.FUN-BB0086--mark--start--
            # IF g_ima.ima641 IS NULL OR g_ima.ima641 = ' '
            #   OR g_ima.ima641 < 0
            #    THEN CALL cl_err(g_ima.ima641,'mfg0013',0)
            #         LET g_ima.ima641 = g_ima_o.ima641
            #         DISPLAY BY NAME g_ima.ima641
            #         NEXT FIELD ima641
            # END IF
            # IF g_ima.ima64 >1 AND  g_ima.ima641 >0 THEN
            #    DISPLAY "ima64,ima641>0 in"
            #    IF (g_ima.ima641 MOD g_ima.ima64) != 0 THEN
            #      DISPLAY "mod !=0"
            #       CALL aimi104_size1()
            #    END IF
            #    IF g_ima.ima641 MOD g_ima.ima64 <> 0 THEN
            #       DISPLAY "mod <>0"
            #       CALL cl_err('','aim-402',0)
            #       NEXT FIELD ima64
            #    END IF
            # END IF
            # LET g_ima_o.ima641 = g_ima.ima641
            # LET l_direct = 'D'
            #No.FUN-BB0086--mark--end--
 
        AFTER FIELD ima108
            IF NOT cl_null(g_ima.ima108) THEN
               IF NOT cl_null(g_ima.ima108) THEN
                  IF g_ima.ima108 NOT MATCHES "[YN]" THEN NEXT FIELD ima108 END IF
               END IF
               LET g_ima_o.ima108 = g_ima.ima108
            END IF
 
        AFTER FIELD ima136
            IF g_ima.ima136 !=' ' AND g_ima.ima136 IS NOT NULL THEN
               SELECT * FROM imd_file WHERE imd01=g_ima.ima136 AND imdacti='Y'
               IF SQLCA.SQLCODE THEN  #No.7926
                  CALL cl_err3("sel","imd_file",g_ima.ima136,"",
                               "mfg1100","","",1)  #No.FUN-660156
                  LET g_ima.ima136 = g_ima_o.ima136
                  DISPLAY BY NAME g_ima.ima136
                  NEXT FIELD ima136
               END IF
               #----CHI-BB0056 str  add
               SELECT imd10 INTO l_imd10 FROM imd_file WHERE imd01=g_ima.ima136 AND imdacti='Y' AND imd20=g_plant
               IF NOT (l_imd10 =  'W') THEN
                  CALL cl_err(g_ima.ima136,'asf-724',0)
                  NEXT FIELD ima136
               END IF
               #----CHI-BB0056 end  add
            END IF
	IF NOT s_imechk(g_ima.ima136,g_ima.ima137) THEN NEXT FIELD ima137 END IF  #FUN-D40103 add
 
        AFTER FIELD ima137
	#FUN-D40103--mark--str--
        #    IF g_ima.ima137 !=' ' AND g_ima.ima137 IS NOT NULL THEN
        #       SELECT * FROM ime_file WHERE ime01=g_ima.ima136
        #                                AND ime02=g_ima.ima137
        #       IF SQLCA.SQLCODE THEN  #No.7926
        #          CALL cl_err3("sel","ime_file",g_ima.ima136,g_ima.ima137,
        #                       "mfg1101","","",1)  #No.FUN-660156
        #          LET g_ima.ima137 = g_ima_o.ima137
        #          DISPLAY BY NAME g_ima.ima137
        #          NEXT FIELD ima137
        #       END IF
        #    END IF
	#FUN-D40103--mark--end--
            #FUN-D40103--add--str--
            IF cl_null(g_ima.ima137) THEN LET g_ima.ima137 = ' ' END IF 
            IF NOT s_imechk(g_ima.ima136,g_ima.ima137) THEN 
               LET g_ima.ima137 = g_ima_o.ima137
               DISPLAY BY NAME g_ima.ima137
               NEXT FIELD ima137
            END IF 
            #FUN-D40103--add--str--
        AFTER FIELD ima153
          IF g_ima.ima153 < 0 THEN
             CALL cl_err('','aec-020',0)
             NEXT FIELD ima153
          END IF
       #FUN-910053--END--
 
        AFTER INPUT
           LET g_ima.imauser = s_get_data_owner("ima_file") #FUN-C10039
           LET g_ima.imagrup = s_get_data_group("ima_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF g_ima.ima01 IS NULL THEN  #料件編號
               CALL cl_err(g_ima.ima01,'9033',0)                                                                                    
               NEXT FIELD ima01                                                                                                     
            END IF
            IF g_ima.ima70 NOT MATCHES "[YN]" OR g_ima.ima70 IS NULL THEN
               CALL cl_err(g_ima.ima70,'9033',0)                                                                                    
               NEXT FIELD ima70                                                                                                     
            END IF
            IF g_ima.ima56 IS NULL THEN
               CALL cl_err(g_ima.ima56,'9033',0)                                                                                    
               NEXT FIELD ima56                                                                                                     
            END IF
            IF g_ima.ima561 IS NULL THEN
               CALL cl_err(g_ima.ima561,'9033',0)                                                                                   
               NEXT FIELD ima561                                                                                                    
            END IF
            IF g_ima.ima562 IS NULL THEN
               CALL cl_err(g_ima.ima562,'9033',0)                                                                                   
               NEXT FIELD ima562                                                                                                    
            END IF
            IF g_ima.ima58 IS NULL THEN
               CALL cl_err(g_ima.ima58,'9033',0)                                                                                    
               NEXT FIELD ima58                                                                                                     
            END IF
            IF g_ima.ima59 IS NULL THEN
               CALL cl_err(g_ima.ima59,'9033',0)                                                                                    
               NEXT FIELD ima59                                                                                                     
            END IF
            IF g_ima.ima60 IS NULL THEN
               CALL cl_err(g_ima.ima60,'9033',0)                                                                                    
               NEXT FIELD ima60                                                                                                     
            END IF
            IF g_ima.ima601 IS NULL THEN
               CALL cl_err(g_ima.ima601,'9033',0)                                                                                   
               NEXT FIELD ima601                                                                                                    
            END IF
            IF g_ima.ima61 IS NULL THEN
               CALL cl_err(g_ima.ima61,'9033',0)                                                                                    
               NEXT FIELD ima61                                                                                                     
            END IF
            IF g_ima.ima62 IS NULL THEN
               CALL cl_err(g_ima.ima62,'9033',0)                                                                                    
               NEXT FIELD ima62                                                                                                     
            END IF
            IF g_ima.ima55 IS NULL THEN  #生產單位
               LET g_ima.ima55=g_ima.ima25
               DISPLAY BY NAME g_ima.ima55
            END IF
            IF g_ima.ima55_fac IS NULL OR g_ima.ima55_fac<=0 THEN
               CALL cl_err(g_ima.ima55_fac,'9033',0)                                                                                
               NEXT FIELD ima55_fac                                                                                                 
            END IF
            IF g_ima.ima63 IS NULL THEN  #發料單位
               LET g_ima.ima63=g_ima.ima25
               DISPLAY BY NAME g_ima.ima63
            END IF
            IF g_ima.ima63_fac IS NULL  OR g_ima.ima63_fac<=0 THEN #發料批量
               CALL cl_err(g_ima.ima63_fac,'9033',0)                                                                                
               NEXT FIELD ima63_fac                                                                                                 
            END IF
            IF g_ima.ima64 IS NULL  THEN  #發料批量
               CALL cl_err(g_ima.ima64,'9033',0)                                                                                    
               NEXT FIELD ima64                                                                                                     
            END IF
            IF g_ima.ima641 IS NULL THEN  #發料數量
               CALL cl_err(g_ima.ima641,'9033',0)                                                                                   
               NEXT FIELD ima641                                                                                                    
            END IF
            IF g_ima.ima68 IS NULL  THEN  #需求時距
               CALL cl_err(g_ima.ima68,'9033',0)                                                                                    
               NEXT FIELD ima68                                                                                                     
            END IF
            IF g_ima.ima69 IS NULL  THEN  #計劃時距
               CALL cl_err(g_ima.ima69,'9033',0)                                                                                    
               NEXT FIELD ima69                                                                                                     
            END IF
            IF g_ima.ima110 IS NULL OR g_ima.ima110 NOT MATCHES "[1234]" THEN
               CALL cl_err(g_ima.ima110,'9033',0)                                                                                   
               NEXT FIELD ima110                                                                                                    
            END IF
            #發料前調撥否
            IF g_ima.ima108 IS NULL OR g_ima.ima108 NOT MATCHES "[YN]" THEN
               CALL cl_err(g_ima.ima108,'9033',0)                                                                                   
               NEXT FIELD ima108                                                                                                    
            END IF
            IF g_ima.ima912 IS NULL THEN
               CALL cl_err(g_ima.ima912,'9033',0)                                                                                   
               NEXT FIELD ima912                                                                                                    
            END IF
            IF g_ima.ima641>1 AND g_ima.ima64!=0 THEN
               IF g_ima.ima641 MOD g_ima.ima64 <> 0 THEN
                  DISPLAY BY NAME g_ima.ima64
                  DISPLAY BY NAME g_ima.ima641
                  CALL cl_err('','aim-402',0)
                  NEXT FIELD ima64
               END IF
            END IF
 
        ON ACTION create_unit
           CALL cl_cmdrun("aooi101 ")
 
        ON ACTION unit_conversion
           CALL cl_cmdrun("aooi102 ")
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(ima111)                       #預設工單單別
                  CALL q_smy(FALSE,FALSE,' ','ASF','1') RETURNING g_ima.ima111 #TQC-670008
                  DISPLAY  BY NAME g_ima.ima111
                  NEXT FIELD ima111
               WHEN INFIELD(ima67)                         #采購員(ima67)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gen"
                  LET g_qryparam.default1 = g_ima.ima67
                  CALL cl_create_qry() RETURNING g_ima.ima67
                  DISPLAY BY NAME g_ima.ima67
                  CALL aimi104_peo(g_ima.ima67,'d')
                  NEXT FIELD ima67
               WHEN INFIELD(ima55)                       # 生產單位 (ima55)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.default1 = g_ima.ima55
                  CALL cl_create_qry() RETURNING g_ima.ima55
                  DISPLAY BY NAME g_ima.ima55
                  NEXT FIELD ima55
               WHEN INFIELD(ima63)                       # 發料單位 (ima63)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.default1 = g_ima.ima63
                  CALL cl_create_qry() RETURNING g_ima.ima63
                  DISPLAY BY NAME g_ima.ima63
                  NEXT FIELD ima63
               WHEN INFIELD(ima136)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_imd"
                   LET g_qryparam.default1 = g_ima.ima136 #MOD-4A0213
                   #LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213  #CHI-BB0056 mark
                  LET g_qryparam.arg1     = 'W'                                  #CHI-BB0056 add
                  CALL cl_create_qry() RETURNING g_ima.ima136
                  DISPLAY BY NAME g_ima.ima136
                  NEXT FIELD ima136
               WHEN INFIELD(ima137)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_ime"
                   LET g_qryparam.default1 = g_ima.ima137 #MOD-4A0063
                   LET g_qryparam.arg1     = g_ima.ima136 #倉庫編號 #MOD-4A0063
                   #LET g_qryparam.arg2     = 'SW'         #倉庫類別 #MOD-4A0063 #CHI-BB0056 mark
                   LET g_qryparam.arg2     = 'W'                                 #CHI-BB0056 add
                  CALL cl_create_qry() RETURNING g_ima.ima137
                  DISPLAY BY NAME g_ima.ima137
                  NEXT FIELD ima137
               WHEN INFIELD(ima571)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_ecu1"
                  LET g_qryparam.default1 = g_ima.ima571
                  CALL cl_create_qry() RETURNING g_ima.ima571,g_ima.ima94
                  DISPLAY BY NAME g_ima.ima571,g_ima.ima571
                  NEXT FIELD ima571
               WHEN INFIELD(ima94)
                  CALL cl_init_qry_var()
                 #str MOD-A50113 mod
                 #LET g_qryparam.form ="q_ecu1"
                  IF NOT cl_null(g_ima.ima571) THEN
                     IF g_sma.sma541='Y' THEN    #TQC-B20087
                        LET g_qryparam.form ="q_ecu1_a" #TQC-B20087
                     ELSE  #TQC-B20087
                        LET g_qryparam.form ="q_ecu101"
                     END IF #TQC-B20087
                  ELSE
                     LET g_qryparam.form ="q_ecu1"
                  END IF
                 #end MOD-A50113 mod
                  LET g_qryparam.default1 = g_ima.ima571
                  LET g_qryparam.default2 = g_ima.ima94
                 #str MOD-A50113 add
                  IF NOT cl_null(g_ima.ima571) THEN
                     LET g_qryparam.arg1 = g_ima.ima571
                  END IF
                 #end MOD-A50113 mod
                  CALL cl_create_qry() RETURNING g_ima.ima571,g_ima.ima94
                  DISPLAY BY NAME g_ima.ima571,g_ima.ima94
                  NEXT FIELD ima94
               OTHERWISE EXIT CASE
            END CASE
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION HELP          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
END FUNCTION
 
 
FUNCTION aimi104_size()
DEFINE l_count          LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_ima561         LIKE ima_file.ima561
 
      LET l_count = g_ima.ima561 MOD g_ima.ima56
      IF l_count != 0 THEN
         LET l_count = g_ima.ima561/ g_ima.ima56
         LET l_ima561 = ( l_count + 1 ) * g_ima.ima56
         CALL cl_getmsg('mfg0047',g_lang) RETURNING g_msg
         WHILE g_chr IS NULL OR g_chr NOT MATCHES'[YNyn]'
            LET INT_FLAG = 0  ######add for prompt bug
           PROMPT g_msg CLIPPED,'(',l_ima561,')',':' FOR g_chr
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION HELP          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
           END PROMPT
           IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
         END WHILE
         IF g_chr ='Y' OR g_chr = 'y'  THEN
            LET g_ima.ima561 = l_ima561
         END IF
         DISPLAY BY NAME g_ima.ima56   #No.FUN-BB0086
         DISPLAY BY NAME g_ima.ima561
      END IF
      LET g_chr = NULL
END FUNCTION
 
FUNCTION aimi104_size1()  #檢查發料數量是否為發料批量之倍數及建議發料數量
DEFINE l_count         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_ima641        LIKE ima_file.ima641
 
      LET l_count = g_ima.ima641 MOD g_ima.ima64
      IF l_count != 0 THEN
         LET l_count = g_ima.ima641/ g_ima.ima64
         LET l_ima641 = ( l_count + 1 ) * g_ima.ima64
         CALL cl_getmsg('mfg0047',g_lang) RETURNING g_msg
         WHILE g_chr IS NULL OR g_chr NOT MATCHES'[YNyn]'
            LET INT_FLAG = 0  ######add for prompt bug
           PROMPT g_msg FOR g_chr
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION HELP          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
           END PROMPT
           IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
         END WHILE
         IF g_chr ='Y' OR g_chr = 'y'  THEN
           LET g_ima.ima641 = l_ima641
         END IF
         DISPLAY BY NAME g_ima.ima641
      END IF
      LET g_chr = NULL
END FUNCTION
 
 
FUNCTION aimi104_peo(p_key,p_cmd)    #人員
    DEFINE p_key     LIKE gen_file.gen01,
           p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_genacti LIKE gen_file.genacti,
           l_gen02   LIKE gen_file.gen02
 
    LET g_chr = ' '
    IF p_key IS NULL THEN
        LET l_gen02=NULL
    ELSE
        SELECT gen02,genacti INTO l_gen02,l_genacti
          FROM gen_file
           WHERE gen01 = p_key
         IF SQLCA.sqlcode
           THEN LET l_gen02 = NULL
                LET g_chr = 'E'
           ELSE
             IF l_genacti='N' THEN
                LET g_chr = 'E'
             END IF
        END IF
    END IF
    IF g_chr = ' ' OR p_cmd = 'd'
      THEN DISPLAY l_gen02 TO gen02
    END IF
END FUNCTION
 
FUNCTION aimi104_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL aimi104_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN aimi104_count
    FETCH aimi104_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN aimi104_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL
    ELSE
        CALL aimi104_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION aimi104_fetch(p_flima)
    DEFINE
        p_flima          LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    CASE p_flima
        WHEN 'N' FETCH NEXT     aimi104_curs INTO g_ima.ima01
        WHEN 'P' FETCH PREVIOUS aimi104_curs INTO g_ima.ima01
        WHEN 'F' FETCH FIRST    aimi104_curs INTO g_ima.ima01
        WHEN 'L' FETCH LAST     aimi104_curs INTO g_ima.ima01
        WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION HELP          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump aimi104_curs INTO g_ima.ima01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flima
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ima.* FROM ima_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ima01 = g_ima.ima01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","ima_file",g_ima.ima01,"",
                     SQLCA.sqlcode,"","",1)  #No.FUN-660156
    ELSE
        LET g_data_owner = g_ima.imauser #FUN-4C0053
        LET g_data_group = g_ima.imagrup #FUN-4C0053
        CALL aimi104_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION aimi104_show()
    LET g_ima_t.* = g_ima.*
    DISPLAY BY NAME
         g_ima.ima01, g_ima.ima05, g_ima.ima08, g_ima.ima25,g_ima.ima04,  #No.MOD-540070  Add ima04
        g_ima.ima02, g_ima.ima021, g_ima.ima03,g_ima.ima70, g_ima.ima110,
        g_ima.ima55, g_ima.ima55_fac, g_ima.ima56, g_ima.ima561, g_ima.ima562,g_ima.ima909, #FUN-560187 add ima909
        g_ima.ima59, g_ima.ima60,g_ima.ima601, g_ima.ima61, g_ima.ima62, g_ima.ima58, #FUN-840194
        g_ima.ima912,   #FUN-610080
        g_ima.ima67, g_ima.ima68, g_ima.ima69,
        g_ima.ima63, g_ima.ima63_fac,
        g_ima.ima108,g_ima.ima136, g_ima.ima137,g_ima.ima64, g_ima.ima641,
        g_ima.ima571,g_ima.ima94, g_ima.ima111,g_ima.ima153,           #FUN-910053 add ima153
        g_ima.imauser, g_ima.imagrup, g_ima.imamodu,
        g_ima.imadate, g_ima.imaacti,
        g_ima.imaoriu,g_ima.imaorig   #TQC-B20007 
    LET g_ima93_4=g_ima.ima93[4,4]
    DISPLAY g_ima93_4 TO FORMONLY.ima93_4      #NO.FUN-930143
    CALL aimi104_peo(g_ima.ima67,'d')
    LET g_msg=NULL
    IF g_ima.ima94 IS NOT NULL THEN
       IF g_ima.ima571 IS NULL THEN LET g_ima.ima571=' ' END IF
       DECLARE ecu03_cs1 CURSOR FOR   #TQC-B20087
        SELECT ecu03 FROM ecu_file
                WHERE ecu01=g_ima.ima571 AND ecu02=g_ima.ima94
       FOREACH ecu03_cs1 INTO g_msg #TQC-B20087
         EXIT FOREACH               #TQC-B20087
       END FOREACH                  #TQC-B20087
    END IF
    DISPLAY g_msg TO ecu03
    LET g_doc.column1 = "ima01"
    LET g_doc.value1 = g_ima.ima01
    CALL cl_get_fld_doc("ima04")
 
    CALL i104_show_pic()
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION aimi104_u()
    DEFINE l_ima   RECORD LIKE ima_file.*        #FUN-B80032
    IF s_shut(0) THEN RETURN END IF
    IF g_ima.ima01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_ima.imaacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_ima.ima01,'mfg1000',0)
        RETURN
    END IF
#FUN-B90102-------mark---begin--------
#FUN-B90102----add--begin---- 服飾行業，子料件不可更改
#   IF s_industry('slk') THEN
#      IF g_ima.ima151='N' AND g_ima.imaag='@CHILD' THEN
#         CALL cl_err(g_ima.ima01,'axm_665',1)
#         RETURN
#      END IF
#   END IF
#FUN-B90102----add--end---
#FUN-B90102-------mark---end---------

    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ima01_t = g_ima.ima01
    LET g_ima_o.* = g_ima.*
    BEGIN WORK   #No.+205 mark 拿掉
 
    OPEN aimi104_curl USING g_ima01_t
    IF STATUS THEN
       CALL cl_err("OPEN aimi104_curl:", STATUS, 1)
       CLOSE aimi104_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH aimi104_curl INTO g_ima.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_ima.imamodu = g_user                   #修改者
    LET g_ima.imadate = g_today                  #修改日期
    CALL aimi104_show()                          # 顯示最新資料
    WHILE TRUE
        CALL aimi104_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ima_t.imadate=g_ima_o.imadate        #TQC-C40219
            LET g_ima_t.imamodu=g_ima_o.imamodu        #TQC-C40219
            LET g_ima.*=g_ima_t.*              #TQC-C40155 #TQC-C40219
           #LET g_ima.*=g_ima_o.*              #TQC-C40155 #TQC-C40219
            CALL aimi104_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
       #FUN-B80032---------STA-------
        SELECT * INTO l_ima.*
          FROM ima_file
         WHERE ima01 = g_ima.ima01
         IF l_ima.ima02 <> g_ima.ima02 OR l_ima.ima021 <> g_ima.ima021
            OR l_ima.ima25 <> g_ima.ima25
            OR l_ima.ima151 <> g_ima.ima151 THEN
            IF g_aza.aza88 = 'Y' THEN
               UPDATE rte_file SET rtepos = '2' WHERE rte03 = g_ima.ima01 AND rtepos = '3'
            END IF
         END IF
       #FUN-B80032---------END-------
        LET g_ima.ima93[4,4] = 'Y'
        UPDATE ima_file SET ima_file.* = g_ima.*    # 更新DB
            WHERE ima01 = g_ima01_t                  # COLAUTH?
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","ima_file",g_ima01_t,"",
                         SQLCA.sqlcode,"","",1)  #No.FUN-660156
           CONTINUE WHILE
#No.FUN-A50011 ---begin---
        ELSE 
#MOD-AC0161 ---------------mod start---------------
#FUN-B90102------------MARK----BEGIN-------------
#            IF s_industry('slk') THEN
#               IF g_ima.ima151 = 'Y' THEN
#                  CALL s_upd_ima_subparts(g_ima.ima01)
#               END IF
#            END IF      
#FUN-B90102----------MARK-------END------------
#MOD-AC0161 ---------------mod end---------------------
#No.FUN-A50011  ---end---
        END IF
        
      IF g_ima.ima110<>g_ima_o.ima110 THEN
         UPDATE bmb_file SET bmb19=g_ima.ima110 WHERE BMB03=g_ima.ima01
           IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","ima_file",g_ima01_t,"",
                         SQLCA.sqlcode,"","",1)  #No.FUN-660156
           CONTINUE WHILE
           END IF
      END IF
       
      
        EXIT WHILE
    END WHILE
    CLOSE aimi104_curl
#FUN-B90102----add--begin---- 服飾行業，母料件更改后修改，更新子料件資料
    IF s_industry('slk') THEN
       IF g_ima.ima151='Y' THEN
          CALL i104_ins_ima()
       END IF
    END IF
#FUN-B90102----add--end---
     COMMIT WORK  #No.+205 mark 拿掉
END FUNCTION

#FUN-B90102----add--begin---- 服飾行業，母料件更改后修改，更新子料件資料
FUNCTION i104_ins_ima()
         
   UPDATE ima_file SET 
                      ima08=g_ima.ima08,ima05=g_ima.ima05,ima25=g_ima.ima25,
                      ima03=g_ima.ima03,ima70=g_ima.ima70,ima55=g_ima.ima55,ima55_fac=g_ima.ima55_fac,ima110=g_ima.ima110,
                      ima56=g_ima.ima56,ima561=g_ima.ima561,ima562=g_ima.ima562,
                      ima909=g_ima.ima909,ima153=g_ima.ima153,
                      ima59=g_ima.ima59,ima60=g_ima.ima60,ima601=g_ima.ima601,
                      ima61=g_ima.ima61,ima62=g_ima.ima62,ima58=g_ima.ima58,
                      ima912=g_ima.ima912,
#                     ima571=g_ima.ima571,ima94=g_ima.ima94,ima111=g_ima.ima111,   #mark by FUN-B90102   ima571,ima94不可由母料件赋值
                      ima111=g_ima.ima111,                                         #add by FUN-B90102
                      ima67=g_ima.ima67,ima68=g_ima.ima68,ima69=g_ima.ima69,
                      ima63=g_ima.ima63,ima63_fac=g_ima.ima63_fac,ima108=g_ima.ima108,ima136=g_ima.ima136,
                      ima137=g_ima.ima137,ima64=g_ima.ima64,ima641=g_ima.ima641,
                      imamodu=g_ima.imamodu,
                      imadate=g_ima.imadate
   WHERE ima01 IN (SELECT imx000 FROM imx_file WHERE imx00=g_ima.ima01)
END FUNCTION
#FUN-B90102---ADD---END-------
 
FUNCTION aimi104_out()
    DEFINE
        l_i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_name          LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
        l_za05          LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
        sr              RECORD LIKE ima_file.*,
        sr2             RECORD
                          gen02    LIKE gen_file.gen02
                        END RECORD,
        l_chr           LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aimi104' #No.FUN-840029
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT ima01,ima02,ima021,imaacti,ima55,ima55_fac,ima56,ima57,",                                                     
                    " ima63,ima63_fac,ima64,ima67,ima68,ima69,gen02 ",
               " FROM ima_file LEFT OUTER JOIN gen_file ON ima_file.ima67=gen_file.gen01 ",
              " WHERE ",g_wc CLIPPED
 
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'ima01,ima02,ima021,ima08,ima05,ima25,ima03,          
           ima70,ima55,ima55_fac,ima110,ima56,ima561,ima562,ima909,             
           ima59,ima60,ima601,ima61,ima62,ima58,     #FUN-840194
           ima912,                                                              
           ima571,ima94, ima111,                                                
           ima67,ima68,ima69,                                                   
           ima63,ima63_fac,ima108,ima136,ima137,ima64,ima641,                   
           imauser,imagrup,imamodu,imadate,imaacti')                            
       RETURNING g_str                                                          
    END IF                                                                      
    CALL cl_prt_cs1('aimi104','aimi104',g_sql,g_str)                            
END FUNCTION
 
FUNCTION i104_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("ima01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i104_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("ima01",FALSE)
#FUN-B90102---------begin------------
     IF s_industry('slk') THEN
        IF g_ima.ima151='N' AND g_ima.imaag='@CHILD' THEN
           CALL cl_set_comp_entry("ima70,ima55,ima55_fac,ima110,ima56,ima561,ima562,ima909,ima153,ima59,ima60,
                                   ima601,ima61,ima62,ima58,ima912,ima571,ima111,ima67,ima68,ima69,ima63,ima63_fac,
                                   ima108,ima136,ima137,ima64,ima641",FALSE)
        ELSE
           CALL cl_set_comp_entry("ima70,ima55,ima55_fac,ima110,ima56,ima561,ima562,ima909,ima153,ima59,ima60,
                                   ima601,ima61,ima62,ima58,ima912,ima571,ima111,ima67,ima68,ima69,ima63,ima63_fac,
                                   ima108,ima136,ima137,ima64,ima641",TRUE)
        END IF
     END IF
#FUN-B90102----------end-------------
   END IF
 
END FUNCTION
 
FUNCTION i104_show_pic()
   
     LET g_chr='N'
     IF g_ima.ima1010='1' THEN                                                                                             
        LET g_chr='Y'                                                                                                      
     END IF
     CALL cl_set_field_pic1(g_chr,""  ,""  ,""  ,""  ,g_ima.imaacti,""    ,"")
                           #確認 ,核准,過帳,結案,作廢,有效         ,申請  ,留置
     #圖形顯示
END FUNCTION
#No.FUN-9C0072 精簡程式碼 

#No.FUN-BB0086---add---start---
FUNCTION i104_ima56_check()
   IF NOT cl_null(g_ima.ima56) AND NOT cl_null(g_ima.ima55) THEN
      IF cl_null(g_ima.ima56) OR cl_null(g_ima55_t) OR g_ima_t.ima56 != g_ima.ima56 OR g_ima55_t != g_ima.ima44 THEN
         LET g_ima.ima56=s_digqty(g_ima.ima56,g_ima.ima55)
         DISPLAY BY NAME g_ima.ima56
      END IF
   END IF
   
   IF g_ima.ima56 IS NULL OR g_ima.ima56 = ' '
      OR g_ima.ima56 < 0
   THEN
      CALL cl_err(g_ima.ima56,'mfg0013',0)
      LET g_ima.ima56 = g_ima_o.ima56
      DISPLAY BY NAME g_ima.ima56
      RETURN FALSE 
   END IF
   LET g_ima_o.ima56 = g_ima.ima56
   RETURN TRUE
END FUNCTION

FUNCTION i104_ima561_check()
   IF NOT cl_null(g_ima.ima561) AND NOT cl_null(g_ima.ima55) THEN
      IF cl_null(g_ima.ima561) OR cl_null(g_ima55_t) OR g_ima_t.ima561 != g_ima.ima561 OR g_ima55_t != g_ima.ima44 THEN
         LET g_ima.ima561=s_digqty(g_ima.ima561,g_ima.ima55)
         DISPLAY BY NAME g_ima.ima561
      END IF
   END IF
   
   IF g_ima.ima561 >1 AND g_ima.ima56 >0 THEN
      IF (g_ima.ima56 MOD g_ima.ima561) != 0 OR g_ima.ima561 < g_ima.ima56 THEN     #TQC-BA0085
         CALL aimi104_size()
      END IF
   END IF
   IF g_ima.ima561 IS NULL OR g_ima.ima561 = ' '
      OR g_ima.ima561 < 0
   THEN CALL cl_err(g_ima.ima561,'mfg0013',0)
        LET g_ima.ima561 = g_ima_o.ima561
        DISPLAY BY NAME g_ima.ima561
        RETURN FALSE 
   END IF
   LET g_ima_o.ima561 = g_ima.ima561
   RETURN TRUE
END FUNCTION

FUNCTION i104_ima64_check()
   IF NOT cl_null(g_ima.ima64) AND NOT cl_null(g_ima.ima63) THEN
      IF cl_null(g_ima.ima64) OR cl_null(g_ima63_t) OR g_ima_t.ima64 != g_ima.ima64 OR g_ima63_t != g_ima.ima63 THEN
         LET g_ima.ima64=s_digqty(g_ima.ima64,g_ima.ima63)
         DISPLAY BY NAME g_ima.ima64
      END IF
   END IF
   
   IF g_ima.ima64 IS NULL OR g_ima.ima64 = ' '
      OR g_ima.ima64 < 0
   THEN CALL cl_err(g_ima.ima64,'mfg0013',0)
      LET g_ima.ima64 = g_ima_o.ima64
      DISPLAY BY NAME g_ima.ima64
      RETURN FALSE 
   END IF
   LET g_ima_o.ima64 = g_ima.ima64
   RETURN TRUE
END FUNCTION

FUNCTION i104_ima641_check(p_direct)
   DEFINE p_direct  LIKE type_file.chr1
   
   IF NOT cl_null(g_ima.ima641) AND NOT cl_null(g_ima.ima63) THEN
      IF cl_null(g_ima.ima641) OR cl_null(g_ima63_t) OR g_ima_t.ima641 != g_ima.ima641 OR g_ima63_t != g_ima.ima63 THEN
         LET g_ima.ima641=s_digqty(g_ima.ima641,g_ima.ima63)
         DISPLAY BY NAME g_ima.ima641
      END IF
   END IF
   
   IF g_ima.ima641 IS NULL OR g_ima.ima641 = ' '
      OR g_ima.ima641 < 0
   THEN CALL cl_err(g_ima.ima641,'mfg0013',0)
      LET g_ima.ima641 = g_ima_o.ima641
      DISPLAY BY NAME g_ima.ima641
      RETURN "ima641",p_direct
   END IF
   IF g_ima.ima64 >1 AND  g_ima.ima641 >0 THEN
      DISPLAY "ima64,ima641>0 in"
      IF (g_ima.ima641 MOD g_ima.ima64) != 0 THEN
         DISPLAY "mod !=0"
         CALL aimi104_size1()
      END IF
      IF g_ima.ima641 MOD g_ima.ima64 <> 0 THEN
         DISPLAY "mod <>0"
         CALL cl_err('','aim-402',0)
         RETURN "ima64",p_direct
      END IF
   END IF
   LET g_ima_o.ima641 = g_ima.ima641
   RETURN "",p_direct
END FUNCTION
#No.FUN-BB0086---add---end---

