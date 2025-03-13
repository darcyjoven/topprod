# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aeci800.4gl
# Descriptions...: 工作中心工作曆維護作業
# Input parameter: 
# Return code....: 
# Date & Author..: 91/06/09 By LYS
# Modify.........: No.FUN-510032 05/02/21 By pengu 報表轉XML
# Modify.........: No.FUN-570110 05/07/14 By jackie 修正建檔程式key值是否可更改  
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.MOD-5A0004 05/10/07 By Rosayu 刪除資料後筆數不正確
# Modify.........: No.FUN-640160 06/04/24 By Sarah 增加"隔周休二日否?"選項
# Modify.........: No.FUN-660091 05/06/15 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-680073 06/08/21 By hongmei 欄位型態轉換
# Modify.........: No.FUN-6A0039 06/10/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-720019 07/02/28 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-840139 08/04/29 By TSD.Lori 改為CR報表
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.TQC-970164 09/07/22 By lilingyu 單身[效率%]欄位輸入負數,無相應提示信息
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0054 09/10/12 By xiaofeizhu 單身[工作時數]欄位輸入負數,無相應提示信息
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A50037 10/05/13 by destiny 整批生成时生成笔试不对 
# Modify.........: No:MOD-A80078 10/08/12 By sabrina l_name為zaa寫法，要mark。不然多語系報表無法列印
# Modify.........: No.TQC-B30187 11/03/28 by destiny 定义栏位时不能like mlc_file，此为synonmy table
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-BB0214 12/01/05 By SunLM 對ecn04做限定0<=ecn04<=24
# Modify.........: No.TQC-C80186 12/09/06 By qiull 整批插入資料之後立即顯示
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_ecn01         LIKE ecn_file.ecn01,   #類別代號 (假單頭)
    g_ecn03         LIKE ecn_file.ecn03,   #類別代號 (假單頭)
    g_ecn01_t       LIKE ecn_file.ecn01,   #類別代號 (舊值)
    g_ecn03_t       LIKE ecn_file.ecn03,   #類別代號 (舊值)
    g_ecn           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ecn02       LIKE ecn_file.ecn02,   #日期
        ecn04       LIKE ecn_file.ecn04,   #工作小時
        ecn05       LIKE ecn_file.ecn05    #效率調整%
                    END RECORD,
    g_ecn_t         RECORD                 #程式變數 (舊值)
        ecn02       LIKE ecn_file.ecn02,   #日期
        ecn04       LIKE ecn_file.ecn04,   #工作小時
        ecn05       LIKE ecn_file.ecn05    #效率調整%
                    END RECORD,
    g_wc,g_sql       STRING,                       #No.FUN-580092 HCN  
    g_rec_b          LIKE type_file.num5,          #單身筆數        #No.FUN-680073 SMALLINT
    g_ss             LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(01), #決定後續步驟
    p_row,p_col      LIKE type_file.num5,          #No.FUN-680073 SMALLINT SMALLINT
    l_ac             LIKE type_file.num5,          #目前處理的ARRAY CNT   #No.FUN-680073 SMALLINT
    l_sl             LIKE type_file.num5,          #No.FUN-680073 SMALLINT, #目前處理的SCREEN LINE  
   #start FUN-640160 add
    l_year_t         LIKE type_file.num5,          #No.FUN-680073 SMALLINT,
    l_month_t        LIKE type_file.num5,          #No.FUN-680073 SMALLINT,
    l_sat1           LIKE type_file.dat,           #No.FUN-680073 SMALLINT,
    l_sat2           LIKE type_file.dat            #No.FUN-680073 SMALLINT,
   #end FUN-640160 add
 
DEFINE g_forupd_sql      STRING                       #SELECT ... FOR UPDATE SQL     
DEFINE g_sql_tmp         STRING                       #No.TQC-720019
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680073 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680073 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680073 SMALLINT
DEFINE   g_head1         STRING
DEFINE   g_before_input_done    LIKE type_file.num5     #No.FUN-570110  #No.FUN-680073 SMALLINT
DEFINE   l_table         STRING       #No.FUN-840139 080429 By TSD.Lori
DEFINE   g_str           STRING       #No.FUN-840139 080429 By TSD.Lori 
 
MAIN
# DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0100
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AEC")) THEN
       EXIT PROGRAM
    END IF
 
    #No.FUN-840139 080429 By TSD.Lori------------------------(S)
    ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
    LET g_sql = "ecn01.ecn_file.ecn01,",
                "ecn02.ecn_file.ecn02,",
                "ecn03.ecn_file.ecn03,",
                "ecn04.ecn_file.ecn04,",
                "ecn05.ecn_file.ecn05,",
                "ecn06.ecn_file.ecn06"
 
    LET l_table = cl_prt_temptable('aeci800',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?, ?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
    #------------------------------ CR (1) ------------------------------#
    #No.FUN-840139 080429 By TSD.Lori------------------------(E)
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time      #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
    LET g_ecn01 = NULL                     #清除鍵值
    LET g_ecn01_t = NULL
    LET g_ecn03 = NULL                     #清除鍵值
    LET g_ecn03_t = NULL
    LET p_row = 3 LET p_col = 25
    OPEN WINDOW i800_w AT p_row,p_col   #顯示畫面
        WITH FORM "aec/42f/aeci800"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL i800_menu()
    CLOSE WINDOW i800_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time      #計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
END MAIN
 
#QBE 查詢資料
FUNCTION i800_curs()
    CLEAR FORM                             #清除畫面
    CALL g_ecn.clear()
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
   INITIALIZE g_ecn01 TO NULL    #No.FUN-750051
   INITIALIZE g_ecn03 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON ecn01,ecn03,ecn02,ecn04,ecn05    #螢幕上取條件
       FROM ecn01,ecn03,s_ecn[1].ecn02,s_ecn[1].ecn04,s_ecn[1].ecn05
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
 
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN RETURN END IF
    LET g_sql= "SELECT UNIQUE ecn01,ecn03 FROM ecn_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY ecn01,ecn03"
    PREPARE i800_prepare FROM g_sql      #預備一下
    DECLARE i800_b_curs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i800_prepare
 
#   LET g_sql= "SELECT UNIQUE ecn01,ecn03 FROM ecn_file ",      #No.TQC-720019
    LET g_sql_tmp= "SELECT UNIQUE ecn01,ecn03 FROM ecn_file ",  #No.TQC-720019
               " WHERE ", g_wc CLIPPED,
               "  INTO TEMP x "
#   #PREPARE i800_precount_x FROM g_sql #MOD-5A0004 mark      #No.TQC-720019
    #PREPARE i800_precount_x FROM g_sql_tmp #MOD-5A0004 mark  #No.TQC-720019
#MOD-5A0004 unmark
    DROP TABLE x
#   PREPARE i800_precount_x FROM g_sql      #No.TQC-720019
    PREPARE i800_precount_x FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i800_precount_x
 
        LET g_sql="SELECT COUNT(*) FROM x "
 
    PREPARE i800_precount FROM g_sql
    DECLARE i800_count CURSOR FOR i800_precount
#MOD-5A0004 unmark
END FUNCTION
 
FUNCTION i800_menu()
 
   WHILE TRUE
      CALL i800_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i800_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i800_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i800_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i800_u()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i800_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i800_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"     
            CALL cl_cmdask()
         WHEN "generate"
            IF cl_chk_act_auth() THEN 
               CALL i800_g()
            END IF
#FUN-4B0012
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ecn),'','')
            END IF
##
        #No.FUN-6A0039-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_ecn01 IS NOT NULL THEN
                LET g_doc.column1 = "ecn01"
                LET g_doc.column2 = "ecn03"
                LET g_doc.value1 = g_ecn01
                LET g_doc.value2 = g_ecn03
                CALL cl_doc()
             END IF 
          END IF
        #No.FUN-6A0039-------add--------end----
 
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i800_a()
    IF s_shut(0) THEN
       RETURN
    END IF
 
    MESSAGE ""
    CLEAR FORM
    CALL g_ecn.clear()
 
    INITIALIZE g_ecn01 LIKE ecn_file.ecn01
    INITIALIZE g_ecn03 LIKE ecn_file.ecn03
    LET g_ecn01_t = NULL
    LET g_ecn03_t = NULL
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i800_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_ss='N' THEN
           CALL g_ecn.clear()
           LET g_rec_b = 0
        ELSE
           CALL i800_b_fill('1=1')         #單身
        END IF
 
        CALL i800_b()                   #輸入單身
 
        LET g_ecn01_t = g_ecn01            #保留舊值
        LET g_ecn03_t = g_ecn03            #保留舊值
 
        EXIT WHILE
    END WHILE
    LET g_wc=' '
 
END FUNCTION
 
FUNCTION i800_u()
  DEFINE
         l_msg    LIKE type_file.chr1000  # No.FUN-680073  VARCHAR(60) 
    IF s_shut(0) THEN
        RETURN
    END IF
    IF cl_null(g_ecn01) THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ecn01_t = g_ecn01
    LET g_ecn03_t = g_ecn03
    BEGIN WORK
    WHILE TRUE
        CALL i800_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_ecn01=g_ecn01_t
            LET g_ecn03=g_ecn03_t
            DISPLAY g_ecn01,g_ecn03 TO ecn01,ecn03         #單頭
                
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_ecn01 != g_ecn01_t OR g_ecn03 != g_ecn03_t THEN  #更改單頭值
            UPDATE ecn_file SET ecn01 = g_ecn01,  #更新DB
                                ecn03 = g_ecn03  
                WHERE ecn01 = g_ecn01_t   
                  AND ecn03 = g_ecn03_t  
            IF SQLCA.sqlcode THEN
                LET l_msg = g_ecn01 clipped,'+',g_ecn03 clipped
#               CALL cl_err(l_msg,SQLCA.sqlcode,0) #No.FUN-660091
                CALL cl_err3("upd","ecn_file",g_ecn01_t,g_ecn03_t,SQLCA.sqlcode,"","",1) #FUN-660091
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i800_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,   #a:輸入 u:更改 #No.FUN-680073 VARCHAR(1)
    l_cnt           LIKE type_file.num5    #No.FUN-680073 SMALLINT
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
    LET g_ss='Y'
    INPUT g_ecn01,g_ecn03 WITHOUT DEFAULTS FROM ecn01,ecn03 
 
#No.FUN-570110 --start--                                                                                                            
           BEFORE INPUT                                                                                                             
                LET g_before_input_done = FALSE                                                                                     
                CALL i800_set_entry(p_cmd)                                                                                          
                CALL i800_set_no_entry(p_cmd)                                                                                       
                LET g_before_input_done = TRUE                                                                                      
#No.FUN-570110 --end--  
        AFTER FIELD ecn03                
            IF NOT cl_null(g_ecn03)  THEN
               IF g_ecn01 != g_ecn01_t OR g_ecn01_t IS NULL OR
                  g_ecn03 != g_ecn03_t OR g_ecn03_t IS NULL
               THEN
                   SELECT count(*) INTO l_cnt FROM ecn_file 
                     WHERE ecn01=g_ecn01 AND ecn03 = g_ecn03
                   IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
                   
                   IF p_cmd='a' AND l_cnt = 0 THEN LET g_ss='N' END IF
                   IF l_cnt > 0 
                   THEN CALL cl_err(g_ecn01,-239,0)
                        LET g_ecn01=g_ecn01_t
                        LET g_ecn03=g_ecn03_t
                        NEXT FIELD ecn01
                   END IF
               END IF
            END IF
 
        AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF 
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
    END INPUT
END FUNCTION
   
#Query 查詢
FUNCTION i800_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ecn01 TO NULL          #No.FUN-6A0039
    INITIALIZE g_ecn03 TO NULL          #No.FUN-6A0039
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i800_curs()                    #取得查詢條件
    IF INT_FLAG THEN                    #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i800_b_curs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_ecn01 TO NULL
        INITIALIZE g_ecn03 TO NULL
    ELSE
        #MOD-5A0004 mark
        #EXECUTE i800_precount_x
        #SELECT COUNT(*) INTO g_row_count FROM x 
        #DISPLAY g_row_count TO FORMONLY.cnt
        #MOD-5A0004 end mark
        #MOD-5A0004 unmark
        OPEN i800_count
        FETCH i800_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        #MOD-5A0004 unmark
        CALL i800_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i800_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    #No.FUN-680073 VARCHAR(1) VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數  #No.FUN-680073 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i800_b_curs INTO g_ecn01,g_ecn03
        WHEN 'P' FETCH PREVIOUS i800_b_curs INTO g_ecn01,g_ecn03
        WHEN 'F' FETCH FIRST    i800_b_curs INTO g_ecn01,g_ecn03
        WHEN 'L' FETCH LAST     i800_b_curs INTO g_ecn01,g_ecn03
        WHEN '/' 
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
               
               END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i800_b_curs INTO g_ecn01,g_ecn03
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_ecn01,SQLCA.sqlcode,0)
       INITIALIZE g_ecn01 TO NULL  #TQC-6B0105
       INITIALIZE g_ecn03 TO NULL  #TQC-6B0105
    ELSE
       CALL i800_show()
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i800_show()
    DISPLAY g_ecn01,g_ecn03 TO ecn01,ecn03    #單頭
        
    CALL i800_b_fill(g_wc)                    #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i800_r()
    IF s_shut(0) THEN
        RETURN
    END IF
    IF cl_null(g_ecn01) THEN 
       CALL cl_err("",-400,0)                 #No.FUN-6A0039
       RETURN 
    END IF
    BEGIN WORK
    IF cl_delh(0,0) THEN                      #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ecn01"      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "ecn03"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ecn01       #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_ecn03       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                   #No.FUN-9B0098 10/02/24
        DELETE FROM ecn_file WHERE ecn01 = g_ecn01
                               AND ecn03 = g_ecn03
        IF SQLCA.sqlcode THEN
#           CALL cl_err('del ecn_file',SQLCA.sqlcode,0) #No.FUN-660091
            CALL cl_err3("del","ecn_file",g_ecn01,g_ecn03,SQLCA.sqlcode,"","del ecn_file",1) #FUN-660091
        ELSE
            CLEAR FORM
            #MOD-5A0004 add
            DROP TABLE x
#           EXECUTE i800_precount_x                  #No.TQC-720019
            PREPARE i800_precount_x2 FROM g_sql_tmp  #No.TQC-720019
            EXECUTE i800_precount_x2                 #No.TQC-720019
            #MOD-5A0004 end
            CALL g_ecn.clear()
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            #MOD-5A0004 mark
            #EXECUTE i800_precount_x
            #SELECT COUNT(*) INTO g_row_count FROM x
            #DISPLAY g_row_count TO FORMONLY.cnt
            #MOD-5A0004 mark end
 
            #MOD-5A0004 unmark
            OPEN i800_count
            #FUN-B50062-add-start--
            IF STATUS THEN
               CLOSE i800_b_curs
               CLOSE i800_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            FETCH i800_count INTO g_row_count
            #FUN-B50062-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i800_b_curs
               CLOSE i800_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            #MOD-5A0004 unmark en
            OPEN i800_b_curs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i800_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i800_fetch('/')
            END IF
        END IF
    END IF
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i800_b()
DEFINE
    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT #No.FUN-680073 SMALLINT SMALLINT
    l_n             LIKE type_file.num5,      #檢查重複用        #No.FUN-680073 SMALLINT
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否        #No.FUN-680073 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,      #處理狀態          #No.FUN-680073 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,      #可新增否          #No.FUN-680073 SMALLINT
    l_allow_delete  LIKE type_file.num5       #可刪除否          #No.FUN-680073 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_ecn01) THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT ecn02,ecn04,ecn05 ",
                       "   FROM ecn_file ",
                       "  WHERE ecn01=? AND ecn03 =? ",
                       "    AND ecn02=? ",
                       "    FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i800_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_ecn WITHOUT DEFAULTS FROM s_ecn.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3  
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            IF g_rec_b>=l_ac THEN
            #IF g_ecn_t.ecn02 IS NOT NULL THEN
                LET p_cmd='u'
                LET g_ecn_t.* = g_ecn[l_ac].*  #BACKUP
 
                OPEN i800_bcl USING g_ecn01,g_ecn03,g_ecn_t.ecn02
 
                IF STATUS THEN
                   CALL cl_err("OPEN i800_bcl:", STATUS, 1)
                   CLOSE i800_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH i800_bcl INTO g_ecn[l_ac].* 
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_ecn_t.ecn02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF g_ecn[l_ac].ecn02 IS NULL THEN  #重要欄位空白,無效
                INITIALIZE g_ecn[l_ac].* TO NULL
            END IF
            INSERT INTO ecn_file(ecn01,ecn03,ecn02,ecn04,ecn05)
            VALUES(g_ecn01,g_ecn03,g_ecn[l_ac].ecn02,
                   g_ecn[l_ac].ecn04,g_ecn[l_ac].ecn05)
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_ecn[l_ac].ecn02,SQLCA.sqlcode,0) #No.FUN-660091
                CALL cl_err3("ins","ecn_file",g_ecn01,g_ecn[l_ac].ecn02,SQLCA.sqlcode,"","",1) #FUN-660091
                CANCEL INSERT
              ELSE
                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ecn[l_ac].* TO NULL      #900423
            LET g_ecn_t.* = g_ecn[l_ac].*         #新輸入資料
            DISPLAY g_ecn[l_ac].ecn02 TO ecn02
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ecn02
 
        AFTER FIELD ecn02                        #check 序號是否重複
            IF g_ecn[l_ac].ecn02 IS NOT NULL AND
               (g_ecn[l_ac].ecn02 != g_ecn_t.ecn02 OR
                g_ecn_t.ecn02 IS NULL) THEN
                SELECT count(*)
                    INTO l_n
                    FROM ecn_file
                    WHERE ecn01 = g_ecn01 AND ecn03 = g_ecn03 AND
                          ecn02 = g_ecn[l_ac].ecn02
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_ecn[l_ac].ecn02 = g_ecn_t.ecn02
                    DISPLAY g_ecn[l_ac].ecn02 TO s_ecn[l_sl].ecn02
                    NEXT FIELD ecn02
                  ELSE
                    IF g_chr = 'E' THEN
                        CALL cl_err('','-100',0)
                        NEXT FIELD ecn02
                    END IF
                END IF
            END IF
 
        AFTER FIELD ecn04 #工作小時
            IF g_ecn[l_ac].ecn04 IS NULL THEN
                NEXT FIELD ecn04
            END IF
#TQC-BB0214 MARK BEGIN
            #TQC-9A0054--Add--Begnin--#                                                                                             
#            IF NOT cl_null(g_ecn[l_ac].ecn04) THEN                                                                                  
#               IF g_ecn[l_ac].ecn04 < 0 THEN                                                                                        
#                   CALL cl_err('','aec-020',0)                                                                                      
#                  NEXT FIELD ecn04                                                                                                  
#               END IF                                                                                                               
#            END IF                                                                                                                  
            #TQC-9A0054--Add--End--#
#TQC-BB0214 MARK END
            #TQC-BB0214 BEGIN
            IF NOT cl_null(g_ecn[l_ac].ecn04) THEN                                                                                  
               IF g_ecn[l_ac].ecn04 > 24 OR g_ecn[l_ac].ecn04 < 0 THEN                                                                                        
                   CALL cl_err('','alm-092',0)                                                                                    
                  NEXT FIELD ecn04                                                                                                  
               END IF                                                                                                               
            END IF            
            #TQC-BB0214 END
 
        AFTER FIELD ecn05 #效率調整
            IF NOT cl_null(g_ecn[l_ac].ecn05) THEN
               IF g_ecn[l_ac].ecn05 < 0 OR
                  g_ecn[l_ac].ecn05 >100 THEN
                  CALL cl_err('','aec-002',0)  #TQC-970164
                  NEXT FIELD ecn05
               END IF
            END IF
    
        BEFORE DELETE                            #是否取消單身
            IF g_ecn_t.ecn02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM ecn_file
                    WHERE ecn01 = g_ecn01 AND ecn03 = g_ecn03 AND 
                          ecn02 = g_ecn_t.ecn02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_ecn_t.ecn02,SQLCA.sqlcode,0) #No.FUN-660091
                    CALL cl_err3("del","ecn_file",g_ecn01,g_ecn_t.ecn02,SQLCA.sqlcode,"","",1) #FUN-660091
                    ROLLBACK WORK
                    CANCEL DELETE 
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ecn[l_ac].* = g_ecn_t.*
               CLOSE i800_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ecn[l_ac].ecn02,-263,1)
               LET g_ecn[l_ac].* = g_ecn_t.*
            ELSE
               IF g_ecn[l_ac].ecn02 IS NULL THEN  #重要欄位空白,無效
                   INITIALIZE g_ecn[l_ac].* TO NULL
               END IF
               UPDATE ecn_file SET
                      ecn02=g_ecn[l_ac].ecn02,
                      ecn04=g_ecn[l_ac].ecn04,
                      ecn05=g_ecn[l_ac].ecn05
               WHERE ecn01= g_ecn01 AND ecn03 = g_ecn03
                 AND ecn02= g_ecn_t.ecn02
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_ecn[l_ac].ecn02,SQLCA.sqlcode,0) #No.FUN-660091
                   CALL cl_err3("upd","ecn_file",g_ecn01,g_ecn_t.ecn02,SQLCA.sqlcode,"","",1) #FUN-660091
                   LET g_ecn[l_ac].* = g_ecn_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_ecn[l_ac].* = g_ecn_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_ecn.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i800_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i800_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(ecn02) AND l_ac > 1 THEN
                LET g_ecn[l_ac].* = g_ecn[l_ac-1].*
                NEXT FIELD ecn02
            END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end                             
        
        END INPUT
 
    CLOSE i800_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i800_b_askkey()
DEFINE
    l_wc           LIKE type_file.chr1000  #No.FUN-680073 VARCHAR(200)
 
    CONSTRUCT l_wc ON ecn02,ecn04,ecn05    #螢幕上取條件
       FROM s_ecn[1].ecn02,s_ecn[1].ecn04,s_ecn[1].ecn05
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
 
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    CALL i800_b_fill(l_wc)
END FUNCTION
 
FUNCTION i800_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc        LIKE type_file.chr1000  #No.FUN-680073 VARCHAR(200)
 
    LET g_sql =
       " SELECT ecn02,ecn04,ecn05 ",
       "   FROM ecn_file",
       "  WHERE ecn01 = '",g_ecn01,"'",
       "    AND ecn03 = '",g_ecn03,"'",
       "    AND ",p_wc CLIPPED ,
       "  ORDER BY 1"
    PREPARE i800_prepare2 FROM g_sql      #預備一下
    DECLARE ecn_curs CURSOR FOR i800_prepare2
    CALL g_ecn.clear()
    LET g_cnt = 1
    FOREACH ecn_curs INTO g_ecn[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
 
      LET g_cnt = g_cnt + 1
      
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
     
    END FOREACH
    CALL g_ecn.deleteElement(g_cnt)
    LET g_rec_b= g_cnt -1 
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i800_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ecn TO s_ecn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION output
           LET g_action_choice="output"
           EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i800_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION previous
         CALL i800_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump
         CALL i800_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL i800_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last
         CALL i800_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 產生
      ON ACTION generate
         LET g_action_choice="generate"
         EXIT DISPLAY
 
   ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
#FUN-4B0012
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0039  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY  
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end                   
##
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i800_g()
DEFINE
   #l_dd      INTEGER, 
    l_dd      LIKE type_file.num10,         #No.FUN-680073 INTEGER,    
   #l_c       VARCHAR(01),
    l_c       LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(01)
    l_total   LIKE type_file.num5,          #No.FUN-680073 SMALLINT,
    l_cnt     LIKE type_file.num5,          #No.FUN-680073 SMALLINT
    l_percent LIKE nmz_file.nmz57,          #No.FUN-680073 DECIMAL(5,2),
    l_i       LIKE type_file.num10,         #No.FUN-680073 INTEGER,
    l_msg     LIKE type_file.chr1000,       # No.FUN-680073 VARCHAR(60),
    l_ecn RECORD LIKE ecn_file.*,
    l_ecn04 ARRAY[7] OF LIKE ecn_file.ecn04,# No.FUN-680073 DECIMAL(5,2), 
    l_ecn05 ARRAY[7] OF LIKE ecn_file.ecn05,# No.FUN-680073 DECIMAL(5,2),
    tm RECORD
        ecn01 LIKE ecn_file.ecn01,
        ecn03 LIKE ecn_file.ecn03,
        ecn02_b LIKE ecn_file.ecn02,
        ecn02_e LIKE ecn_file.ecn02,
        j       LIKE type_file.chr1,     #No.FUN-680073 VARCHAR(1),#FUN-640160 add
        c       LIKE ecn_file.ecn04,
        c1      LIKE ecn_file.ecn05,
        d       LIKE ecn_file.ecn04,
        d1      LIKE ecn_file.ecn05,
        e       LIKE ecn_file.ecn04,
        e1      LIKE ecn_file.ecn05,
        f       LIKE ecn_file.ecn04,
        f1      LIKE ecn_file.ecn05,
        g       LIKE ecn_file.ecn04,
        g1      LIKE ecn_file.ecn05,
        h       LIKE ecn_file.ecn04,
        h1      LIKE ecn_file.ecn05,
        i       LIKE ecn_file.ecn04,
        i1      LIKE ecn_file.ecn05
        END RECORD
   
    IF s_shut(0) THEN RETURN END IF
    OPEN WINDOW i800_g_w AT 5,14
       WITH FORM "aec/42f/aeci8001" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aeci8001")
 
    INITIALIZE tm.* TO NULL			# Default condition
    LET tm.j = 'N'   #FUN-640160 add
    LET tm.c = 8 LET tm.c1=100
    LET tm.d = 8 LET tm.d1=100
    LET tm.e = 8 LET tm.e1=100
    LET tm.f = 8 LET tm.f1=100
    LET tm.g = 8 LET tm.g1=100
    LET tm.h = 4 LET tm.h1=100
    LET tm.i = 0 LET tm.i1=0
    DISPLAY BY NAME tm.* 
 
    WHILE TRUE
        INPUT BY NAME tm.* WITHOUT DEFAULTS
      
           AFTER FIELD ecn02_e
              IF NOT cl_null(tm.ecn02_e) THEN 
                 IF tm.ecn02_e < tm.ecn02_b THEN
                    NEXT FIELD ecn02_b
                 END IF
                 SELECT count(*) INTO l_cnt FROM ecn_file
                    WHERE ecn01 = tm.ecn01
                      AND ecn03 = tm.ecn03
                      AND (ecn02 between tm.ecn02_b AND tm.ecn02_e)
                 IF l_cnt > 0 THEN
                    LET l_msg = tm.ecn01 clipped,'+',tm.ecn03 clipped,'+', 
                                tm.ecn02_b,'+',tm.ecn02_e
                    CALL cl_err(l_msg,-239,0)
                    NEXT FIELD ecn01
                 END IF 
              END IF 
 
          #start FUN-640160 add
           AFTER FIELD j
              IF tm.j NOT MATCHES"[YN]" OR tm.j IS NULL THEN
                 NEXT FIELD j
              END IF
          #end FUN-640160 add
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
           ON ACTION about         #MOD-4C0121
              CALL cl_about()      #MOD-4C0121
      
           ON ACTION help          #MOD-4C0121
              CALL cl_show_help()  #MOD-4C0121
      
           ON ACTION controlg      #MOD-4C0121
              CALL cl_cmdask()     #MOD-4C0121
        
        END INPUT
        #使用者不想繼續了
        IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
        IF NOT cl_sure(20,21) THEN CONTINUE WHILE END IF
        LET l_ecn04[1]=tm.c LET l_ecn05[1]=tm.c1
        LET l_ecn04[2]=tm.d LET l_ecn05[2]=tm.d1
        LET l_ecn04[3]=tm.e LET l_ecn05[3]=tm.e1
        LET l_ecn04[4]=tm.f LET l_ecn05[4]=tm.f1
        LET l_ecn04[5]=tm.g LET l_ecn05[5]=tm.g1
        LET l_ecn04[6]=tm.h LET l_ecn05[6]=tm.h1
        LET l_ecn04[7]=tm.i LET l_ecn05[7]=tm.i1
        #測試日期的順序是由小而大或由大而小, 後者, 將之調整過來
        IF tm.ecn02_b > tm.ecn02_e THEN
            LET l_ecn.ecn02=tm.ecn02_b
            LET tm.ecn02_b=tm.ecn02_e
            LET tm.ecn02_e=l_ecn.ecn02
        END IF
        LET l_total=tm.ecn02_e-tm.ecn02_b          
        LET l_cnt=0
        LET l_ecn.ecn01=tm.ecn01
        LET l_ecn.ecn03=tm.ecn03
        FOR l_i=tm.ecn02_b TO tm.ecn02_e
            LET l_cnt=l_cnt+1
            LET l_percent=(l_cnt/l_total)*100
            LET l_ecn.ecn02=DATE(l_i)
            MESSAGE '(',l_percent USING '<<<.<<%',')',l_ecn.ecn02
            LET l_dd=WEEKDAY(l_ecn.ecn02)
            IF l_dd = 0 THEN LET l_dd=7 END IF
            LET l_ecn.ecn04 = l_ecn04[l_dd]
            LET l_ecn.ecn05 = l_ecn05[l_dd]
           #start FUN-640160 add
            #判斷當星期六時,若tm.j='Y'(隔週休),隔週休的那個禮拜六ecn04=0,ecn05=0
             IF l_dd = 6 AND tm.j = 'Y' THEN
                CALL i800_Saturday(l_ecn.ecn02,l_ecn.ecn04,l_ecn.ecn05) 
                     RETURNING l_ecn.ecn04,l_ecn.ecn05
             END IF
           #end FUN-640160 add
            INSERT INTO ecn_file VALUES (l_ecn.*)
            #No.TQC-A50037--begin
            IF SQLCA.sqlcode THEN
               CALL cl_err('ins',SQLCA.sqlcode,1)
               EXIT FOR 
            END IF
            #No.TQC-A50037--end
        END FOR
        #MESSAGE l_total USING '<<<<<<<<&'," Row(s) Generated "    #No.TQC-A50037
        CALL cl_err(l_cnt,'aec-211',1)                             #No.TQC-A50037
        EXIT WHILE                                                 #No.TQC-A50037
    END WHILE                                               
    CLOSE WINDOW i800_g_w
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
    CALL i800_b_fill('1=1')                                        #No.TQC-A50037
    ERROR ""
    #TQC-C80186----add-----begin
    LET g_ecn01 = tm.ecn01                                        
    LET g_ecn03 = tm.ecn03   
    LET g_wc = ' 1=1'
    CALL i800_show()            
    #TQC-C80186----add----end                                   
END FUNCTION
 
#start FUN-640160 add
FUNCTION i800_Saturday(l_date,l_ecn04,l_ecn05)
   DEFINE
          l_date    LIKE type_file.dat     #No.FUN-680073 DATE
   DEFINE l_ecn04   LIKE ecn_file.ecn04
   DEFINE l_ecn05   LIKE ecn_file.ecn05
 
   IF (l_year_t=0 AND l_month_t=0) OR
      (YEAR(l_date) = l_year_t AND MONTH(l_date) != l_month_t) OR
      (YEAR(l_date) !=l_year_t ) THEN
      LET l_year_t = YEAR(l_date)
      LET l_month_t= MONTH(l_date)
      LET l_sat1 = l_date + 7
      LET l_sat2 = l_date + 21
   END IF
   IF l_date = l_sat1 OR l_date = l_sat2 THEN
      RETURN 0,0
   ELSE
      RETURN l_ecn04,l_ecn05
   END IF
 
END FUNCTION
#end FUN-640160 add
 
FUNCTION i800_week(p_date)
DEFINE
       p_date LIKE type_file.dat,           #No.FUN-680073 DATE
      #l_string LIKE mlc_file.mlc05,        #No.FUN-680073 VARCHAR(14)  #TQC-B30187
       l_string LIKE type_file.chr20,       #No.FUN-680073 VARCHAR(14)  #TQC-B30187
       l_week  LIKE aba_file.aba18,         #No.FUN-680073 VARCHAR(02)
       l_dd   LIKE type_file.num10          #No.FUN-680073 INTEGER
    CASE g_lang
      WHEN '0'
        LET l_string='一二三四五六日'
      WHEN '2'
        LET l_string='一二三四五六日'
      OTHERWISE 
        LET l_string='MoTuWeThFrSaSu'
    END CASE
    LET l_dd=WEEKDAY(p_date)
    IF l_dd=0 THEN LET l_dd=7 END IF
    LET l_dd=(l_dd-1)*2+1
    LET l_week=l_string[l_dd,l_dd+1]
    RETURN l_week
END FUNCTION
 
FUNCTION i800_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680073 SMALLINT
    l_week          LIKE aba_file.aba18,          #No.FUN-680073 VARCHAR(02)
    sr  RECORD LIKE ecn_file.*,
    l_name          LIKE type_file.chr20,         #No.FUN-680073 VARCHAR(20)#External(Disk) file name 
    l_za05          LIKE type_file.chr1000        #No.FUN-680073 VARCHAR(40) 
 
    #No.FUN-840139 080429 By TSD.Lori--------------(S)
    ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
    #------------------------------ CR (2) ------------------------------#
    #No.FUN-840139 080429 By TSD.Lori--------------(E)
 
    IF cl_null(g_wc) THEN
       LET g_wc=" ecn01='",g_ecn01,"' AND"," ecn03='",g_ecn03,"'"
    END IF
    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
   #CALL cl_outnam('aeci800') RETURNING l_name         #MOD-A80078 mark
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql="SELECT * FROM ecn_file",  # 組合出 SQL 指令
              " WHERE 1=1 AND ",g_wc CLIPPED
    PREPARE i800_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i800_curo                         # SCROLL CURSOR
        CURSOR FOR i800_p1
 
    #START REPORT i800_rep TO l_name          #No.FUN-840139 080429 By TSD.Lori mark
    FOREACH i800_curo INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
       #No.FUN-840139 080429 By TSD.Lori-----------------------------(S)
       #CALL i800_week(sr.ecn02) RETURNING l_week
       #OUTPUT TO REPORT i800_rep(sr.*,l_week)
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
        EXECUTE insert_prep USING sr.*
        #------------------------------ CR (3) -----------------------------
       #No.FUN-840139 080429 By TSD.Lori-----------------------------(E)
 
    END FOREACH
 
    #FINISH REPORT i800_rep    #No.FUN-840139 080429 By TSD.Lori mark
 
    CLOSE i800_curo
    ERROR ""
   #No.FUN-840139 080429 By TSD.Lori----------------(S)
   #CALL cl_prt(l_name,' ','1',g_len)
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED ,l_table CLIPPED
    LET g_str = g_wc
    CALL cl_prt_cs3('aeci800','aeci800',g_sql,g_str)
    #------------------------------ CR (4) ------------------------------#
   #No.FUN-840139 080429 By TSD.Lori----------------(E)
 
END FUNCTION
 
#No.FUN-840139 080429 By TSD.Lori mark-----------(S)
#REPORT i800_rep(sr,l_week)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,     #No.FUN-680073 VARCHAR(1) 
#    l_string LIKE mlc_file.mlc05,            # No.FUN-680073 VARCHAR(14)
#    l_week LIKE aba_file.aba18,              # No.FUN-680073 VARCHAR(02)
#    l_dd   LIKE type_file.num10,             #No.FUN-680073 INTEGER,
#    sr RECORD LIKE ecn_file.*
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line   #No.MOD-580242
#
#    ORDER BY sr.ecn01,sr.ecn03,sr.ecn02
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#
#            LET g_head1=g_x[12] CLIPPED, sr.ecn01,'   ',g_x[13] CLIPPED,sr.ecn03
#            PRINT g_head1
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#                  g_x[35] CLIPPED
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#
#        BEFORE GROUP OF sr.ecn03
#           SKIP TO TOP OF PAGE
#
#        ON EVERY ROW
#            PRINT COLUMN g_c[31],sr.ecn02,
#                  COLUMN g_c[32], l_week,
#                  COLUMN g_c[33], sr.ecn04 USING '--&.&&',
#                  COLUMN g_c[34], sr.ecn05 USING '---&.&&'
#            IF l_week='日' OR l_week='Su' THEN
#                PRINT g_dash2
#            END IF
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            LET l_trailer_sw = 'n'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-840139 080429 By TSD.Lori--------------------------(E)
 
#No.FUN-570110 --start--                                                                                                            
FUNCTION i800_set_entry(p_cmd)                                                                                                      
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1                    #No.FUN-680073 VARCHAR(1)
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("ecn01,ecn03",TRUE)                                                                                     
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
                                                                                                                                    
FUNCTION i800_set_no_entry(p_cmd)                                                                                                   
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1                   #No.FUN-680073 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("ecn01,ecn03",FALSE)                                                                                    
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
#No.FUN-570110 --end--
#FUN-870144 
