# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abmi611.4gl
# Descriptions...: 元件群組對替代群組維護作業
# Date & Author..: 03/04/18 Hjwang
# Modify.........: No:8765 03/11/25 By Melody i611_bma01_cur cursor order by 應
#                                             是 bmb01非bmb03
 # Modify.........: No.MOD-470041 04/07/16 By Nicola 修改INSERT INTO 語法
 # Modify.........: No.MOD-470051 04/07/21 By Mandy 加入相關文件功能
 # Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-510033 05/02/16 By Mandy 報表轉XML
# Modify.........: No.FUN-570110 05/07/14 By jackie 修正建檔程式key值是否可更改
# Modify.........: No.TQC-660046 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690022 06/09/14 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0002 06/10/19 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6C0148 06/12/26 BY day 顯示時會有畫面全空的情況
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770052 07/07/09 By xiaofeizhu 制作水晶報表
# Modify.........: No.MOD-790002 07/09/03 By Joe 程式段INSERT時,增加欄位(PK)預設值
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.FUN-980001 09/08/06 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A60132 10/06/29 By chenmoyan 把ds_report改為g_cr_db_str
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 規通料件整合(3)全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/25 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-BB0084 11/12/16 By lixh1 增加數量欄位小數取位
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE                                     #模組變數(Module Variables)
    g_cnt2,g_cnt3   LIKE type_file.num5,   #No.FUN-680096 SMALLINT #TQC-840066
    g_argv1         LIKE bob_file.bob01,   #上階主件 (假單頭)
    g_argv2         LIKE bob_file.bob02,   #元件群組
    g_bob01         LIKE bob_file.bob01,   #上階主件 (假單頭)
    g_bob02         LIKE bob_file.bob02,   #元件群組
    g_bob03         LIKE bob_file.bob03,   #替代群組
    g_bob07         LIKE bob_file.bob07,   #替代量
    g_bob14         LIKE bob_file.bob14,   #說明
    g_ima02         LIKE ima_file.ima02,   #品名規格
    g_ima021        LIKE ima_file.ima021,   #品名規格
    g_ima05         LIKE ima_file.ima05,   #目前使用版本
    g_ima08         LIKE ima_file.ima08,   #來源碼
    g_ima25         LIKE ima_file.ima25,
    g_ima63         LIKE ima_file.ima63,
    g_bob          DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
                bob04       LIKE bob_file.bob04,
                ima02b      LIKE ima_file.ima02,
                ima021b     LIKE ima_file.ima021,
                bob05       LIKE bob_file.bob05,
                bob06       LIKE bob_file.bob06,
                bob08       LIKE bob_file.bob08,
                bob09       LIKE bob_file.bob09,
                bob10       LIKE bob_file.bob10,
                bob11       LIKE bob_file.bob11,
                bob12       LIKE bob_file.bob12,
                bob13       LIKE bob_file.bob13
   END RECORD,
    g_bob_t        RECORD                  #變數舊值
                bob04       LIKE bob_file.bob04,
                ima02b      LIKE ima_file.ima02,
                ima021b     LIKE ima_file.ima021,
                bob05       LIKE bob_file.bob05,
                bob06       LIKE bob_file.bob06,
                bob08       LIKE bob_file.bob08,
                bob09       LIKE bob_file.bob09,
                bob10       LIKE bob_file.bob10,
                bob11       LIKE bob_file.bob11,
                bob12       LIKE bob_file.bob12,
                bob13       LIKE bob_file.bob13
   END RECORD,
    g_wc                    string,                #No.FUN-580092 HCN
    g_sql                   string,                #No.FUN-580092 HCN
    g_rec_b                 LIKE type_file.num5,   #單身筆數     #No.FUN-680096 SMALLINT
    l_ac                    LIKE type_file.num5,   #目前處理的ARRAY CNT     #No.FUN-680096 SMALLINT
    l_sl                    LIKE type_file.num5    #目前處理的SCREEN LINE   #No.FUN-680096 SMALLINT
 
DEFINE p_row,p_col          LIKE type_file.num5     #No.FUN-680096 SMALLINT
 
DEFINE g_forupd_sql     STRING                  #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt          LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose   #No.FUN-680096 SMALLINT
DEFINE   g_msg          LIKE ze_file.ze03       #No.FUN-680096 VARCHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5      #No.FUN-680096 SMALLINT
 
DEFINE   g_row_count    LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_jump         LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5     #No.FUN-680096 SMALLINT
DEFINE   l_table        STRING,                     ### FUN-770052 ###                                                             
         g_str          STRING                      ### FUN-770052 ###
 
MAIN
 
DEFINE
#       l_time    LIKE type_file.chr8         #No.FUN-6A0060
    l_za05     LIKE type_file.chr1000    #No.FUN-680096 VARCHAR(40)
 
    OPTIONS                                        #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                                #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
 
 
 
      CALL  cl_used(g_prog,g_time,1)               #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
## *** FUN-770052 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                      
    LET g_sql = "bob01.bob_file.bob01,",                                                                                            
                "bob02.bob_file.bob02,",                                                                                            
                "bob03.bob_file.bob03,",                                                                                            
                "bob04.bob_file.bob04,",                                                                                            
                "bob07.bob_file.bob07,",                                                                                            
                "bob08.bob_file.bob08,",                                                                                            
                "bob09.bob_file.bob09,",                                                                                            
                "bob10.bob_file.bob10,",               
                "ima02.ima_file.ima02,",  
                "ima02b.ima_file.ima02,",  
                "bob13.bob_file.bob13,",
                "bob11.bob_file.bob11,",                                                                                        
                "ima021.ima_file.ima021,",                                                                                          
                "ima021b.ima_file.ima021,",
                "bob14.bob_file.bob14"                                                                                           
    LET l_table = cl_prt_temptable('abmi611',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
#   LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,              #TQC-A60132                                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,     #TQC-A60132                                                                      
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                       
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#
 
    LET g_argv1 = ARG_VAL(1)               #傳key值
    LET g_argv2 = ARG_VAL(2)
    #就算 p_zz 設 "Y" 也不給做 替代表沒必要做 key 值修改
 
    LET p_row = 3 LET p_col = 3
 
    OPEN WINDOW i611_w AT p_row,p_col
         WITH FORM "abm/42f/abmi611"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    IF NOT cl_null(g_argv1) THEN
       CALL i611_q()
    ELSE
        LET g_argv1 = ''                   #清除鍵值
        LET g_argv2 = 0                    #清除鍵值
    END IF
    CALL i611_menu()
    CLOSE WINDOW i611_w                      #結束畫面
      CALL  cl_used(g_prog,g_time,2)         #計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
END MAIN
 
FUNCTION i611_curs()                         #QBE 查詢資料
 
    IF NOT cl_null(g_argv1) THEN
       LET g_wc ="bob01 = '",g_argv1 CLIPPED,"' AND bob02 =",g_argv2 CLIPPED
    ELSE
       CLEAR FORM                               #清除畫面
       CALL g_bob.clear()
        CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
   INITIALIZE g_bob01 TO NULL    #No.FUN-750051
   INITIALIZE g_bob02 TO NULL    #No.FUN-750051
   INITIALIZE g_bob03 TO NULL    #No.FUN-750051
       CONSTRUCT g_wc ON bob01,bob02,bob03,bob07,bob14,bob04,bob05,bob06,bob08,
                         bob09,bob10,bob11,bob12,bob13
                    FROM bob01,bob02,bob03,bob07,bob14,
                         s_bob[1].bob04,s_bob[1].bob05,s_bob[1].bob06,
                         s_bob[1].bob08,s_bob[1].bob09,s_bob[1].bob10,
                         s_bob[1].bob11,s_bob[1].bob12,s_bob[1].bob13
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bob01)
#                    CALL q_ima(0,0,g_bob01) RETURNING g_bob01
#FUN-AA0059 --Begin--
                   #  CALL cl_init_qry_var()
                   #  LET g_qryparam.form = "q_ima"
                   #  LET g_qryparam.state = "c"
                   #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                     DISPLAY g_qryparam.multiret TO bob01
                     NEXT FIELD bob01
                WHEN INFIELD(bob04)     #元件料號
#                    CALL q_ima(0,0,g_bob[1].bob04) RETURNING g_bob[1].bob04
#FUN-AA0059 --Begin--
                   #  CALL cl_init_qry_var()
                   #  LET g_qryparam.form = "q_ima"
                   #  LET g_qryparam.state = "c"
                   #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                     DISPLAY g_qryparam.multiret TO bob04
                     NEXT FIELD bob04
 
                WHEN INFIELD(bob05)     #作業編號
                   CALL q_ecd(TRUE,TRUE,g_bob[1].bob05)
                          RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bob05
                     NEXT FIELD bob05
 
                WHEN INFIELD(bob06)     #單位
#                    CALL q_gfe(3,3,g_bob[1].bob06) RETURNING g_bob[1].bob06
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gfe"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bob06
                     NEXT FIELD bob06
            END CASE
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
    END IF
 
    LET g_sql= "SELECT UNIQUE bob01,bob02,bob03,bob07,bob14 FROM bob_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY bob01,bob02,bob03,bob07,bob14 "
 
    PREPARE i611_prepare FROM g_sql          #預備一下
    DECLARE i611_b_curs                      #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i611_prepare
 
    LET g_sql = "SELECT UNIQUE bob01,bob02,bob03,bob07,bob14 FROM bob_file ",
                " WHERE ",g_wc CLIPPED
    PREPARE i611_precount FROM g_sql
    DECLARE i611_count CURSOR FOR i611_precount
 
    LET g_sql = "SELECT * FROM bob_file WHERE bob01 = ? "
 
    PREPARE i611_r_pre FROM g_sql
    DECLARE i611_r_dec CURSOR WITH HOLD FOR i611_r_pre
 
END FUNCTION
 
 
FUNCTION i611_menu()                         #中文的MENU
   DEFINE   l_cmd   LIKE type_file.chr50     #No.FUN-680096 VARCHAR(50)
 
 
 
   WHILE TRUE
      CALL i611_bp("G")
      CASE g_action_choice
 
       # BEFORE MENU
       #    IF NOT cl_null(g_argv1) THEN
       #       HIDE OPTION  "元件群組"
       #    END IF
 
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i611_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i611_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i611_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i611_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i611_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i611_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "元件群組"
         WHEN "itm_group"
            IF cl_chk_act_auth() AND NOT cl_null(g_bob01) THEN
               LET g_msg = "abmi611 '",g_bob01 CLIPPED,"' '",g_bob02 CLIPPED,"'"
               CALL cl_cmdrun(g_msg)
            END IF
          WHEN "related_document"                  #MOD-470051
            IF cl_chk_act_auth() THEN
               IF g_bob01 IS NOT NULL THEN
                  LET g_doc.column1 = "bob01"
                  LET g_doc.value1  = g_bob01
                  LET g_doc.column2 = "bob02"
                  LET g_doc.value2  = g_bob02
                  LET g_doc.column3 = "bob03"
                  LET g_doc.value3  = g_bob03
                  LET g_doc.column4 = "bob07"
                  LET g_doc.value4  = g_bob07
                  LET g_doc.column5 = "bob14"
                  LET g_doc.value5  = g_bob14
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bob),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION i611_a()                            #Add  輸入
 
    MESSAGE ""
 
    CLEAR FORM
    CALL g_bob.clear()
 
    INITIALIZE g_bob01 LIKE bob_file.bob01   #預設值及將數值類變數清成零
    INITIALIZE g_bob02 LIKE bob_file.bob02
    INITIALIZE g_bob03 LIKE bob_file.bob03
    INITIALIZE g_bob07 LIKE bob_file.bob07
    INITIALIZE g_bob14 LIKE bob_file.bob14
    LET g_wc = NULL
 
    CALL cl_opmsg('a')
 
    WHILE TRUE
        LET g_errno=''
        CALL i611_i("a")                     #輸入單頭
        IF INT_FLAG THEN                     #使用者不玩了
            LET g_bob01=NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF NOT cl_null(g_errno) THEN
           LET g_bob01=NULL
           LET INT_FLAG = 0
           EXIT WHILE
        END IF
 
        CALL g_bob.clear()
        LET g_rec_b = 0
        CALL i611_b()                        #輸入單身
 
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i611_u()
 
DEFINE l_bob01_t     LIKE bob_file.bob01,
       l_bob02_t     LIKE bob_file.bob02,
       l_bob03_t     LIKE bob_file.bob03,
       l_bob07_t     LIKE bob_file.bob07,
       l_bob14_t     LIKE bob_file.bob14
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_bob01) THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
 
    BEGIN WORK
    WHILE TRUE
        LET l_bob01_t = g_bob01 LET l_bob02_t = g_bob02
        LET l_bob03_t = g_bob03 LET l_bob07_t = g_bob07
        LET l_bob14_t = g_bob14
        CALL i611_show()
        CALL i611_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_bob01 = l_bob01_t
            LET g_bob02 = l_bob02_t
            LET g_bob03 = l_bob03_t
            LET g_bob07 = l_bob07_t
            LET g_bob14 = l_bob14_t
            CALL i611_show()
            CALL cl_err('','9001',0)
            ROLLBACK WORK
            EXIT WHILE
        END IF
 
        UPDATE bob_file
           SET bob07=g_bob07,
               bob14=g_bob14
         WHERE bob01=l_bob01_t
           AND bob02=l_bob02_t
           AND bob03=l_bob03_t
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
 #          CALL cl_err(g_bob01,SQLCA.sqlcode,0) #No.TQC-660046
           CALL cl_err3("upd","bob_file",l_bob01_t,l_bob02_t,SQLCA.sqlcode,"","",1) #TQC-660046
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
FUNCTION i611_i(p_cmd)                       #處理INPUT
 
DEFINE
    p_cmd   LIKE type_file.chr1,         #a:輸入 u:更改        #No.FUN-680096 VARCHAR(1)
    l_cnt   LIKE type_file.num5          #No.FUN-680096 SMALLINT
DEFINE  l_ima55     LIKE ima_file.ima55  #FUN-BB0084 
 
    IF NOT cl_null(g_argv1) THEN
       LET g_bob01 = g_argv1
       LET g_bob02 = g_argv2
       DISPLAY g_bob01,g_bob02 TO bob01,bob02
    END IF
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
    INPUT g_bob01,g_bob02,g_bob03,g_bob07,g_bob14 WITHOUT DEFAULTS
     FROM bob01,bob02,bob03,bob07,bob14
 
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i611_set_entry(p_cmd)
            CALL i611_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        BEFORE FIELD bob01
            IF p_cmd="u" THEN NEXT FIELD bob07 END IF
            IF NOT cl_null(g_argv1) THEN
               CALL i611_bob01('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err("chk_bob01:",g_errno,1) 
                  EXIT INPUT
               ELSE
                  NEXT FIELD bob03
               END IF
            END IF
 
        AFTER FIELD bob01                    #料件編號
            IF NOT cl_null(g_bob01) THEN
               #FUN-AA0059 -----------------------add start-------------------
                IF NOT s_chk_item_no(g_bob01,'') THEN
                   CALL cl_err('',g_errno,1) 
                   NEXT FIELD bob01
                END IF 
               #FUN-AA0059 ---------------------add end---------------------
                CALL i611_bob01('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err("ItemNo.:",g_errno,0) 
                   NEXT FIELD bob01
                END IF
            #FUN-BB0084 --------------Begin---------------    
                IF NOT cl_null(g_bob07) THEN
                   SELECT ima55 INTO l_ima55 FROM ima_file
                    WHERE ima01 = g_bob01
                   LET g_bob07 = s_digqty(g_bob07,l_ima55)
                   DISPLAY g_bob07 TO bob07
                END IF

            #FUN-BB0084 --------------End-----------------
            END IF
 
        AFTER FIELD bob03
            IF NOT cl_null(g_bob03) THEN
                IF p_cmd = 'a' THEN
                   SELECT COUNT(*) INTO l_cnt FROM bob_file
                    WHERE bob01 = g_bob01
                      AND bob02 = g_bob02
                      AND bob03 = g_bob03
                   IF l_cnt > 0 THEN
                      CALL cl_err('','-239',0)
                      NEXT FIELD bob03
                   END IF
                END IF
            END IF
 
        BEFORE FIELD bob07
            IF cl_null(g_bob07) THEN
               LET g_bob07 = 1
               DISPLAY g_bob07 TO bob07
            END IF
 
        AFTER FIELD bob07
            IF g_bob07 <= 0 THEN
               NEXT FIELD bob07
            END IF
        #FUN-BB0084 ------------Begin------------------
            IF NOT cl_null(g_bob07) THEN
               SELECT ima55 INTO l_ima55 FROM ima_file
                WHERE ima01 = g_bob01
               LET g_bob07 = s_digqty(g_bob07,l_ima55)
               DISPLAY g_bob07 TO bob07
            END IF   
        #FUN-BB0084 ------------End--------------------    
 
        AFTER INPUT
            IF INT_FLAG THEN  EXIT INPUT END IF
            IF cl_null(g_bob01) THEN NEXT FIELD bob01 END IF
            IF cl_null(g_bob02) THEN NEXT FIELD bob02 END IF
            IF cl_null(g_bob03) THEN NEXT FIELD bob03 END IF
            IF cl_null(g_bob07) OR g_bob07 <=0 THEN
                NEXT FIELD bob07
            END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bob01)
#                    CALL q_ima(0,0,g_bob01) RETURNING g_bob01
#FUN-AA0059 --Begin--
                   #  CALL cl_init_qry_var()
                   #  LET g_qryparam.form = "q_ima"
                   #  LET g_qryparam.default1 = g_bob01
                   #  CALL cl_create_qry() RETURNING g_bob01
                     CALL q_sel_ima(FALSE, "q_ima", "", g_bob01, "", "", "", "" ,"",'' )  RETURNING g_bob01
#FUN-AA0059 --End--
                     DISPLAY BY NAME g_bob01
                     NEXT FIELD bob01
                OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION qry_master_item
#                    CALL q_boa1(0,0,g_bob01,g_bob02) RETURNING g_bob01,g_bob02
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_boa1"
                     LET g_qryparam.default1 = g_bob01
                     LET g_qryparam.default2 = g_bob02
                     CALL cl_create_qry() RETURNING g_bob01,g_bob02
                     DISPLAY BY NAME g_bob01,g_bob02
                     NEXT FIELD bob01
 
        ON ACTION controlg       #TQC-860021
           CALL cl_cmdask()      #TQC-860021
 
        ON IDLE g_idle_seconds   #TQC-860021
           CALL cl_on_idle()     #TQC-860021
           CONTINUE INPUT        #TQC-860021
 
        ON ACTION about          #TQC-860021
           CALL cl_about()       #TQC-860021
 
        ON ACTION help           #TQC-860021
           CALL cl_show_help()   #TQC-860021
    END INPUT
END FUNCTION
 
FUNCTION  i611_bob01(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
    l_cnt           LIKE type_file.num5,      #No.FUN-680096 SMALLINT
    l_ima02         LIKE ima_file.ima02,
    l_ima021        LIKE ima_file.ima021,
    l_ima05         LIKE ima_file.ima05,
    l_ima08         LIKE ima_file.ima08,
    l_imaacti       LIKE ima_file.imaacti,
    l_bob02         LIKE bob_file.bob02
 
    LET g_errno = ' '
 
    SELECT ima02,ima021,ima05,ima08,imaacti
      INTO l_ima02,l_ima021,l_ima05,l_ima08,l_imaacti FROM ima_file
     WHERE ima_file.ima01 = g_bob01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET l_ima02 = NULL
                                   LET l_ima021= NULL
                                   LET l_ima05 = NULL
                                   LET l_ima08 = NULL
                                   LET l_imaacti = NULL
         WHEN l_imaacti='N'        LET g_errno = '9028'
      #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
      #FUN-690022------mod-------
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF p_cmd="a" THEN
       SELECT COUNT(*) INTO l_cnt FROM boa_file
        WHERE boa01 = g_bob01
       IF l_cnt = 0 THEN
          LET g_errno = 'abm-018'
       END IF
    END IF
    IF p_cmd='d' OR cl_null(g_errno) THEN
       DISPLAY l_ima02 TO FORMONLY.ima02
       DISPLAY l_ima021 TO FORMONLY.ima021
       DISPLAY l_ima05 TO FORMONLY.ima05
       DISPLAY l_ima08 TO FORMONLY.ima08
    END IF
END FUNCTION
 
FUNCTION i611_q()                            #Query 查詢
  DEFINE l_cnt          LIKE type_file.num5,          #No.FUN-680096 SMALLINT
         l_bob          RECORD
           bob01        LIKE bob_file.bob01,
           bob02        LIKE bob_file.bob02,
           bob03        LIKE bob_file.bob03,
           bob07        LIKE bob_file.bob07,
           bob14        LIKE bob_file.bob14
                        END RECORD
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bob01 TO NULL              #No.FUN-6A0002
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i611_curs()                         #取得查詢條件
    IF INT_FLAG THEN                         #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_bob01 TO NULL
        RETURN
    END IF
    OPEN i611_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.SQLCODE THEN                    #有問題
        CALL cl_err("",SQLCA.SQLCODE,0)
    ELSE
        FOREACH i611_count INTO l_bob.*
            LET g_row_count = g_row_count + 1
        END FOREACH
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i611_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i611_fetch(p_flag)                  #處理資料的讀取
 
DEFINE
    p_flag      LIKE type_file.chr1        #處理方式    #No.FUN-680096 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i611_b_curs INTO g_bob01,g_bob02,g_bob03
                                                ,g_bob07,g_bob14
        WHEN 'P' FETCH PREVIOUS i611_b_curs INTO g_bob01,g_bob02,g_bob03
                                                ,g_bob07,g_bob14
        WHEN 'F' FETCH FIRST    i611_b_curs INTO g_bob01,g_bob02,g_bob03
                                                ,g_bob07,g_bob14
        WHEN 'L' FETCH LAST     i611_b_curs INTO g_bob01,g_bob02,g_bob03
                                                ,g_bob07,g_bob14
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                END PROMPT
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump i611_b_curs
                       INTO  g_bob01,g_bob02,g_bob03,g_bob07,g_bob14
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_bob01,SQLCA.sqlcode,0)
       INITIALIZE g_bob01 TO NULL  #TQC-6B0105
       INITIALIZE g_bob02 TO NULL  #TQC-6B0105
       INITIALIZE g_bob03 TO NULL  #TQC-6B0105
       INITIALIZE g_bob07 TO NULL  #TQC-6B0105
       INITIALIZE g_bob14 TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    CALL i611_show()
END FUNCTION
 
FUNCTION i611_show()                                  #將資料顯示在畫面上
 
 DEFINE  l_tot    LIKE type_file.num5      #No.FUN-680096 SMALLINT
 DEFINE  l_cnt    LIKE type_file.num5      #No.FUN-680096 SMALLINT
 
    #No.TQC-6C0148--begin
#   SELECT COUNT(*) INTO l_cnt FROM bob_file
#    WHERE bob01=g_bob01 AND bob02=g_bob02
#      AND bob03=g_bob03 AND bob07=g_bob07
#      AND bob14=g_bob14
#   IF l_cnt=0 THEN
#      LET g_bob01='' LET g_bob02=''
#      LET g_bob03='' LET g_bob07=''
#      LET g_bob14=''
#   END IF
    #No.TQC-6C0148--end  
 
    DISPLAY g_bob01,g_bob02,g_bob03,g_bob07,g_bob14   #假單頭
         TO bob01,bob02,bob03,bob07,bob14
    CALL i611_bob01('d')                              #單身
 
    CALL i611_b_fill(g_wc)                            #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i611_r()                                    #取消整筆 (所有合乎單頭的資料)
 
  DEFINE l_cnt    LIKE type_file.num5,          #No.FUN-680096 SMALLINT
         l_bob          RECORD
           bob01        LIKE bob_file.bob01,
           bob02        LIKE bob_file.bob02,
           bob03        LIKE bob_file.bob03,
           bob07        LIKE bob_file.bob07,
           bob14        LIKE bob_file.bob14
                        END RECORD
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_bob01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET g_success = 'Y'
 
    BEGIN WORK
    IF l_cnt > 0 THEN
       IF NOT cl_confirm('abm-800') THEN
          ROLLBACK WORK
          RETURN
       END IF
    ELSE
       IF NOT cl_delh(0,0) THEN                   #確認一下
          ROLLBACK WORK
          RETURN
       END IF
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "bob01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1  = g_bob01      #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "bob02"      #No.FUN-9B0098 10/02/24
       LET g_doc.value2  = g_bob02      #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "bob03"      #No.FUN-9B0098 10/02/24
       LET g_doc.value3  = g_bob03      #No.FUN-9B0098 10/02/24
       LET g_doc.column4 = "bob07"      #No.FUN-9B0098 10/02/24
       LET g_doc.value4  = g_bob07      #No.FUN-9B0098 10/02/24
       LET g_doc.column5 = "bob14"      #No.FUN-9B0098 10/02/24
       LET g_doc.value5  = g_bob14      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                            #No.FUN-9B0098 10/02/24
    END IF
    IF l_cnt > 0 THEN
       IF g_success = 'N' THEN
          ROLLBACK WORK
          RETURN
       END IF
    END IF
 
    DELETE FROM bob_file
     WHERE bob01 = g_bob01
       AND bob02 = g_bob02
       AND bob03 = g_bob03
    IF SQLCA.sqlcode THEN
 #       CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0) #No.TQC-660046
        CALL cl_err3("del","bob_file",g_bob01,g_bob02,SQLCA.sqlcode,"","BODY DELETE",1) #TQC-660046
        ROLLBACK WORK
        CALL cl_rbmsg(1)
        RETURN
    ELSE
        CLEAR FORM
        CALL g_bob.clear()
        LET g_row_count = 0
        FOREACH i611_count INTO l_bob.*
            LET g_row_count = g_row_count + 1
        END FOREACH
        #FUN-B50062-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE i611_b_curs
           CLOSE i611_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-start--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN i611_b_curs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL i611_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL i611_fetch('/')
        END IF
        LET g_cnt=SQLCA.SQLERRD[3]
        MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
        COMMIT WORK
    END IF
 
    LET g_msg=TIME
 
    #重要資料異動記錄 aoo/azo_file
    INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)#FUN-980001 add plant & legal
       VALUES ('abmi611',g_user,g_today,g_msg,g_bob01,'delete',g_plant,g_legal)#FUN-980001 add plant & legal
 
END FUNCTION
 
FUNCTION i611_b()                          #單身
 
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT   #No.FUN-680096 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用  #No.FUN-680096 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否  #No.FUN-680096 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態   #No.FUN-680096 VARCHAR(1)
    l_cmd           LIKE type_file.chr1000,  #可新增否   #No.FUN-680096 VARCHAR(80)
    l_tot           LIKE type_file.num5,     #No.FUN-680096 SMALLINT
    l_cnt           LIKE type_file.num5,     #檢查重複用 #No.FUN-680096 SMALLINT
    l_allow_insert  LIKE type_file.num5,     #可新增否   #No.FUN-680096 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否   #No.FUN-680096 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
 
    IF cl_null(g_bob01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
       "SELECT bob04,'','',bob05,bob06,bob08,bob09,bob10,bob11,bob12,bob13 ",
       "  FROM bob_file ",
       "  WHERE bob01= ? ",
       "   AND bob02= ? ",
       "   AND bob03= ? ",
       "   AND bob04= ? ",
       "   AND bob05= ? ",
       "   AND bob06= ? ",
       "   FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i611_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_bob WITHOUT DEFAULTS FROM s_bob.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'              #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_bob_t.* = g_bob[l_ac].*  #BACKUP
                BEGIN WORK
                OPEN i611_bcl USING g_bob01,g_bob02,g_bob03,g_bob_t.bob04,g_bob_t.bob05,g_bob_t.bob06
                IF STATUS THEN
                    CALL cl_err("OPEN i611_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i611_bcl INTO g_bob[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err("i611_bcl:",SQLCA.sqlcode,1)
                    END IF
                    CALL i611_bob04('d')
                    LET g_bob_t.*=g_bob[l_ac].*
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD bob04
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
            #MOD-790002.................begin
            IF cl_null(g_bob[l_ac].bob05)  THEN
               LET g_bob[l_ac].bob05=' '
            END IF
            #MOD-790002.................end
 
             INSERT INTO bob_file (bob01,bob02,bob03,bob04,bob05,bob06,bob07,  #No.MOD-470041
                                  bob08,bob09,bob10,bob11,bob12,bob13,bob14)
                 VALUES (g_bob01,g_bob02,g_bob03,g_bob[l_ac].bob04,
                         g_bob[l_ac].bob05,g_bob[l_ac].bob06,g_bob07,
                         g_bob[l_ac].bob08,g_bob[l_ac].bob09,g_bob[l_ac].bob10,
                         g_bob[l_ac].bob11,"",g_bob[l_ac].bob13,g_bob14)
            IF SQLCA.sqlcode THEN
 #               CALL cl_err(g_bob01,SQLCA.sqlcode,0) #No.TQC-660046
                CALL cl_err3("ins","bob_file",g_bob01,g_bob02,SQLCA.sqlcode,"","",1) #TQC-660046
               #CKP
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            #CKP
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bob[l_ac].* TO NULL       #900423
            INITIALIZE g_bob_t.* TO NULL           #900423
            LET g_bob[l_ac].bob08 = 1
            LET g_bob[l_ac].bob09 = 1
            LET g_bob[l_ac].bob13 = 0
            LET g_bob[l_ac].bob10 = g_today
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bob04
 
        AFTER FIELD bob04
            IF NOT cl_null(g_bob[l_ac].bob04) THEN
               #FUN-AA0059 ------------------------------add start-------------------------
                IF NOT s_chk_item_no(g_bob[l_ac].bob04,'') THEN
                   CALL cl_err('',g_errno,1)
                   NEXT FIELD bob04
                END IF 
               #FUN-AA0059 -----------------------------add end--------------------------- 
                CALL i611_bob04('a')
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_bob[l_ac].bob04,g_errno,0) 
                    NEXT FIELD bob04
                END IF
                LET g_success = 'Y'
                CALL i611_chk_bom(g_bob01)
                IF g_success = 'N' THEN
                    CALL cl_err(g_bob[l_ac].bob04,'asf-077',0)
                    NEXT FIELD bob04
                END IF
            ELSE
                LET g_bob[l_ac].ima02b = " "
                LET g_bob[l_ac].ima021b = " "
            END IF
 
        AFTER FIELD bob05
            IF g_bob[l_ac].bob05 IS NULL THEN
                LET g_bob[l_ac].bob05 = ' '
            ELSE
                IF NOT cl_null(g_bob[l_ac].bob05) THEN
                   CALL i611_bob05('a')
                   IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_bob[l_ac].bob05,g_errno,0) 
                      NEXT FIELD bob05
                   END IF
                END IF
            END IF
 
        BEFORE FIELD bob06
            IF cl_null(g_bob[l_ac].bob06) THEN
               LET g_bob[l_ac].bob06 = g_ima63
            END IF
 
        AFTER FIELD bob06
            IF NOT cl_null(g_bob[l_ac].bob06) THEN
                CALL i611_bob06('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_bob[l_ac].bob06,g_errno,0) 
                   NEXT FIELD bob06
                END IF
                #CHECK KEY值是否有重覆
                IF p_cmd='a' OR ( p_cmd = 'u' AND
                   ( g_bob_t.bob04 !=g_bob[l_ac].bob04
                   OR g_bob_t.bob05 !=g_bob[l_ac].bob05
                   OR g_bob_t.bob06 !=g_bob[l_ac].bob06 )) THEN
                   LET l_cnt = 0
                   SELECT COUNT(*) INTO l_cnt FROM bob_file
                    WHERE bob01 = g_bob01
                      AND bob02 = g_bob02
                      AND bob03 = g_bob03
                      AND bob04 = g_bob[l_ac].bob04
                      AND bob05 = g_bob[l_ac].bob05
                      AND bob06 = g_bob[l_ac].bob06
                   IF l_cnt > 0 THEN
                      CALL cl_err(g_bob[l_ac].bob04,'-239',0)
                      NEXT FIELD bob06
                   END IF
 
                END IF
            END IF
 
        BEFORE FIELD bob08
            IF cl_null(g_bob[l_ac].bob08) THEN
                LET g_bob[l_ac].bob08 = 1
                #------MOD-5A0095 START----------
                DISPLAY BY NAME g_bob[l_ac].bob08
                #------MOD-5A0095 END------------
            END IF
 
        AFTER FIELD bob08
            IF NOT cl_null(g_bob[l_ac].bob08) THEN
                IF g_bob[l_ac].bob08 <= 0 THEN
                    CALL cl_err(g_bob[l_ac].bob13,"afa-040",0)
                    NEXT FIELD bob08
                END IF
            END IF
 
        BEFORE FIELD bob09
            IF p_cmd = "a" AND cl_null(g_bob[l_ac].bob09) THEN
                LET g_bob[l_ac].bob09 = 1.00
                #------MOD-5A0095 START----------
                DISPLAY BY NAME g_bob[l_ac].bob09
                #------MOD-5A0095 END------------
            END IF
 
        AFTER FIELD bob09
            IF NOT cl_null(g_bob[l_ac].bob09) THEN
                IF g_bob[l_ac].bob09 <= 0.00 THEN
                    CALL cl_err(g_bob[l_ac].bob13,"afa-040",0)
                    NEXT FIELD bob09
                END IF
            END IF
 
        BEFORE FIELD bob10
            IF cl_null(g_bob[l_ac].bob10) THEN
               LET g_bob[l_ac].bob10 = g_today
                #------MOD-5A0095 START----------
                DISPLAY BY NAME g_bob[l_ac].bob10
                #------MOD-5A0095 END------------
                #------MOD-5A0095 START----------
                DISPLAY BY NAME g_bob[l_ac].bob13
                #------MOD-5A0095 END------------
            END IF
 
        AFTER FIELD bob10
            IF NOT cl_null(g_bob[l_ac].bob10) THEN
                IF NOT cl_null(g_bob[l_ac].bob11) THEN
                  #失效日期不可小於生效日期
                   IF g_bob[l_ac].bob10 > g_bob[l_ac].bob11 THEN
                      CALL cl_err(g_bob[l_ac].bob11,'mfg2604',1)
                      NEXT FIELD bob10
                   END IF
                END IF
            END IF
 
        AFTER FIELD bob11
            IF NOT cl_null(g_bob[l_ac].bob11) THEN
              #失效日期不可小於生效日期
               IF g_bob[l_ac].bob10 > g_bob[l_ac].bob11 THEN
                  CALL cl_err(g_bob[l_ac].bob11,'mfg2604',1)
                  NEXT FIELD bob10
               END IF
            END IF
 
        BEFORE FIELD bob13
            IF cl_null(g_bob[l_ac].bob13) THEN
               LET g_bob[l_ac].bob13 = 0.00
            END IF
 
        AFTER FIELD bob13
            IF NOT cl_null(g_bob[l_ac].bob13) THEN
                IF g_bob[l_ac].bob13 < 0.00 THEN
                    CALL cl_err(g_bob[l_ac].bob13,"afa-040",0)
                    NEXT FIELD bob13
                END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_bob_t.bob04) THEN
               IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
               END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
               DELETE FROM bob_file
                WHERE bob01 = g_bob01
                  AND bob02 = g_bob02
                  AND bob03 = g_bob03
                  AND bob04 = g_bob_t.bob04
                  AND bob05 = g_bob_t.bob05
                  AND bob06 = g_bob_t.bob06
               IF SQLCA.sqlcode THEN
 #                  CALL cl_err("Del-ItemNo.:",SQLCA.sqlcode,0) #No.TQC-660046
                   CALL cl_err3("del","bob_file",g_bob01,g_bob02,SQLCA.sqlcode,"","Del-ItemNo",1) #TQC-660046
                   ROLLBACK WORK
                   CANCEL DELETE
               END IF
               COMMIT WORK
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bob[l_ac].* = g_bob_t.*
               CLOSE i611_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_bob[l_ac].bob04,-263,1)
                LET g_bob[l_ac].* = g_bob_t.*
            ELSE
                UPDATE bob_file
                   SET bob04=g_bob[l_ac].bob04,
                       bob05=g_bob[l_ac].bob05,
                       bob06=g_bob[l_ac].bob06,
                       bob08=g_bob[l_ac].bob08,
                       bob09=g_bob[l_ac].bob09,
                       bob10=g_bob[l_ac].bob10,
                       bob11=g_bob[l_ac].bob11,
                       bob13=g_bob[l_ac].bob13
                 WHERE bob01=g_bob01
                   AND bob02=g_bob02
                   AND bob03=g_bob03
                   AND bob04=g_bob_t.bob04
                   AND bob05=g_bob_t.bob05
                   AND bob06=g_bob_t.bob06
                IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
  #                  CALL cl_err(g_bob[l_ac].bob04,SQLCA.sqlcode,0) #No.TQC-660046
                    CALL cl_err3("upd","bob_file",g_bob01,g_bob02,SQLCA.sqlcode,"","",1) #TQC-660046
                    LET g_bob[l_ac].* = g_bob_t.*
                    ROLLBACK WORK
                ELSE
                    MESSAGE "UPDATE O.K"
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_bob[l_ac].* = g_bob_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_bob.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i611_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
          #CKP
          #LET g_bob_t.* = g_bob[l_ac].*          # 900423
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i611_bcl
            COMMIT WORK
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bob04)     #元件料號
#                    CALL q_ima(0,0,g_bob[l_ac].bob04) RETURNING g_bob[l_ac].bob04
#                    CALL FGL_DIALOG_SETBUFFER( g_bob[l_ac].bob04 )
#FUN-AA0059 --Begin--
                   #  CALL cl_init_qry_var()
                   #  LET g_qryparam.form = "q_ima"
                   #  LET g_qryparam.default1 = g_bob[l_ac].bob04
                   #  CALL cl_create_qry() RETURNING g_bob[l_ac].bob04
                      CALL q_sel_ima(FALSE, "q_ima", "", g_bob[l_ac].bob04, "", "", "", "" ,"",'' )  RETURNING g_bob[l_ac].bob04       
#FUN-AA0059 --End--
#                     CALL FGL_DIALOG_SETBUFFER( g_bob[l_ac].bob04 )
                      DISPLAY BY NAME g_bob[l_ac].bob04          #No.MOD-490371
                     NEXT FIELD bob04
 
                WHEN INFIELD(bob05)     #作業編號
                   CALL q_ecd(FALSE,TRUE,g_bob[l_ac].bob05) RETURNING g_bob[l_ac].bob05
#                   CALL FGL_DIALOG_SETBUFFER( g_bob[l_ac].bob05 )
                   DISPLAY g_bob[l_ac].bob05 TO bob05
                   NEXT FIELD bob05
 
                WHEN INFIELD(bob06)     #單位
#                    CALL q_gfe(3,3,g_bob[l_ac].bob06) RETURNING g_bob[l_ac].bob06
#                    CALL FGL_DIALOG_SETBUFFER( g_bob[l_ac].bob06 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gfe"
                     LET g_qryparam.default1 = g_bob[l_ac].bob06
                     CALL cl_create_qry() RETURNING g_bob[l_ac].bob06
#                     CALL FGL_DIALOG_SETBUFFER( g_bob[l_ac].bob06 )
                      DISPLAY BY NAME g_bob[l_ac].bob06          #No.MOD-490371
                     NEXT FIELD bob06
            END CASE
 
       #ON ACTION CONTROLN
       #    CALL i611_b_askkey()
       #    EXIT INPUT
 
#       ON ACTION CONTROLO                        #沿用所有欄位
#          IF INFIELD(bob02) AND l_ac > 1 THEN
#          IF l_ac > 1 THEN
#             LET g_bob[l_ac].* = g_bob[l_ac-1].*
#             NEXT FIELD bob04
#          END IF
 
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
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033
 
        END INPUT
 
    CLOSE i611_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i611_bob04(p_cmd)         #物件料號, 預帶入 bob06
 
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_imaacti LIKE ima_file.imaacti,
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021
 
    LET g_errno = ""
 
    SELECT ima02,ima021,ima63,imaacti,ima25
      INTO l_ima02,l_ima021,g_ima63,l_imaacti,g_ima25 FROM ima_file
     WHERE ima01 = g_bob[l_ac].bob04
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET l_ima02 = ""
                                   LET l_ima021= ""
                                   LET g_ima63 = ""
                                   LET g_ima25 = ""
                                   LET l_imaacti = ""
         WHEN l_imaacti='N'        LET g_errno = "9028"
      #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
      #FUN-690022------mod-------
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING "-------"
    END CASE
 
    IF p_cmd='a' OR cl_null(g_bob[l_ac].bob06) THEN
       LET g_bob[l_ac].bob06 = g_ima63
       DISPLAY g_bob[l_ac].bob06 TO s_bob[l_sl].bob06
    END IF
 
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       LET g_bob[l_ac].ima02b = l_ima02
       LET g_bob[l_ac].ima021b = l_ima021
    END IF
END FUNCTION
 
FUNCTION i611_bob05(p_cmd)         #作業編號
 
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_ecdacti LIKE ecd_file.ecdacti
 
    LET g_errno = ""
    SELECT ecdacti INTO l_ecdacti FROM ecd_file
     WHERE ecd01 = g_bob[l_ac].bob05
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = "aec-015"
         WHEN l_ecdacti='N'        LET g_errno = "9028"
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING "-------"
    END CASE
 
END FUNCTION
 
 
FUNCTION i611_bob06(p_cmd)         #單位
 
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_gfeacti LIKE gfe_file.gfeacti,
           l_gfe01   LIKE gfe_file.gfe01,
           l_sfa13   LIKE sfa_file.sfa13,
           l_n       LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
    LET g_errno = ""
    SELECT gfe01,gfeacti INTO l_gfe01,l_gfeacti FROM gfe_file
     WHERE gfe01 = g_bob[l_ac].bob06
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = "mfg1326"
         WHEN l_gfeacti="N"        LET g_errno = "9028"
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING "-------"
    END CASE
 
    IF NOT cl_null(g_errno) THEN
      #單身的『單位』要檢查對庫存單位是否有建立轉換率
       CALL s_umfchk(g_bob[l_ac].bob04,g_bob[l_ac].bob06,g_ima25)
           RETURNING l_n,l_sfa13
       IF l_n = 1 THEN
          LET g_errno = 'mfg3075'
       END IF
    END IF
 
END FUNCTION
 
FUNCTION i611_b_askkey()
 
DEFINE
    l_wc    LIKE type_file.chr1000   #No.FUN-680096 CHAT(200)
 
    CONSTRUCT l_wc ON bob04,bob05,bob06,bob08,bob09,bob10,bob11,bob12,bob13
                 FROM s_bob[1].bob04,s_bob[1].bob05,s_bob[1].bob06,
                      s_bob[1].bob08,s_bob[1].bob09,s_bob[1].bob10,
                      s_bob[1].bob11,s_bob[1].bob12,s_bob[1].bob13
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
    CALL i611_b_fill(l_wc)
END FUNCTION
 
FUNCTION i611_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc     LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(300)
 
    LET g_sql =
       "SELECT bob04,'','',bob05,bob06,bob08,bob09,bob10,bob11,bob12,",
       "       bob13 ",
       "  FROM bob_file",
       " WHERE bob01 = '",g_bob01 CLIPPED,"' ",
       "   AND bob02 = ",g_bob02,
       "   AND bob03 = ",g_bob03,
       "   AND ",p_wc CLIPPED
 
    PREPARE i611_prepare2 FROM g_sql           #預備一下
    DECLARE bob_curs CURSOR FOR i611_prepare2
    CALL g_bob.clear()
 
    LET g_cnt = 1
    FOREACH bob_curs INTO g_bob[g_cnt].*       #單身 ARRAY 填充
        SELECT ima02,ima021 INTO g_bob[g_cnt].ima02b,g_bob[g_cnt].ima021b FROM ima_file
         WHERE ima01 = g_bob[g_cnt].bob04
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
    #CKP
    CALL g_bob.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
 
FUNCTION i611_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bob TO s_bob.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         IF NOT cl_null(g_argv1) THEN
             CALL cl_set_act_visible("itm_group",FALSE)
         END IF
 
#     BEFORE ROW
#        LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i611_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i611_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i611_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i611_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i611_fetch('L')
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
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 元件群組
      ON ACTION itm_group
         LET g_action_choice="itm_group"
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
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document                   #MOD-470051
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i611_chk_bom(p_bmb01)
    DEFINE p_bmb01      LIKE bmb_file.bmb01,
           l_bma01      ARRAY[602] OF LIKE bma_file.bma01,  #No.FUN-680096 VARCHAR(20)
           l_bmb03      LIKE bmb_file.bmb03,
           l_cnt        LIKE type_file.num5,      #No.FUN-680096 SMALLINT
           i,j,k,arrno  LIKE type_file.num10      #No.FUN-680096 INTEGER
 
    IF g_success = 'N' THEN  RETURN END IF
    LET arrno=602
    DECLARE i611_bma01_cur CURSOR WITH HOLD FOR
     SELECT bmb01 FROM bmb_file
      WHERE bmb03 = p_bmb01
        AND bmb04 <= g_today
        AND ( bmb05 IS NULL OR bmb05 > g_today )
#     ORDER BY bmb03
      ORDER BY bmb01    #No:8765
 
    IF SQLCA.sqlcode THEN
       CALL cl_err('DECLARE i611_bma01_cur',SQLCA.sqlcode,1)
       RETURN
    END IF
 
    FOR j = 1 TO arrno
       #INITIALIZE l_bma01[j].* TO NULL
        LET l_bma01[j] = NULL
    END FOR
    LET k = 1
    FOREACH i611_bma01_cur INTO l_bma01[k]
        IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH i611_bma01_cur',SQLCA.sqlcode,1)
           RETURN
        END IF
        LET k = k + 1
        IF k > arrno THEN
           EXIT FOREACH
        END IF
    END FOREACH
 
    FOR i=1 TO k-1
        IF l_bma01[i] = g_bob[l_ac].bob04 THEN
           LET g_success= 'N'
           EXIT FOR
        END IF
      #找bmb03料件*****************************************#
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt  FROM bmb_file
          WHERE bmb01 = l_bma01[i]
            AND bmb03 = g_bob[l_ac].bob04
            AND bmb04 <= g_today
            AND ( bmb05 IS NULL OR bmb05 > g_today )
         IF l_cnt > 0 THEN
            LET g_success = 'N'
            EXIT FOR
         END IF
         IF g_success = 'Y' THEN
            CALL i611_chk_bom(l_bma01[i])
         END IF
    END FOR
 
END FUNCTION
 
FUNCTION i611_out()
DEFINE
    l_i         LIKE type_file.num5,          #No.FUN-680096 SMALLINT
    sr          RECORD
                bob01       LIKE bob_file.bob01,
                ima02       LIKE ima_file.ima02,
                ima021      LIKE ima_file.ima021,
                bob02       LIKE bob_file.bob02,
                bob03       LIKE bob_file.bob03,
                ima02b      LIKE ima_file.ima02,
                ima021b     LIKE ima_file.ima021,
                bob04       LIKE bob_file.bob04,
                bob05       LIKE bob_file.bob05,
                bob06       LIKE bob_file.bob06,
                bob07       LIKE bob_file.bob07,
                bob08       LIKE bob_file.bob08,
                bob09       LIKE bob_file.bob09,
                bob10       LIKE bob_file.bob10,
                bob11       LIKE bob_file.bob11,
                bob12       LIKE bob_file.bob12,
                bob13       LIKE bob_file.bob13,
                bob14       LIKE bob_file.bob14
    END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name   #No.FUN-680096 VARCHAR(20)
    l_za05          LIKE type_file.chr1000 #No.FUN-680096 VARCHAR(40)
    DEFINE l_sql    STRING                 #FUN-770052
    IF cl_null(g_wc) THEN
        LET g_wc="     bob01='",g_bob01,"'",
                 " AND bob02= ",g_bob02,
                 " AND bob03= ",g_bob03
    END IF
    IF cl_null(g_bob01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_wait()
#   CALL cl_outnam('abmi611') RETURNING l_name                      #FUN-770052
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-770052 *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-770052 add ###                                              
     #------------------------------ CR (2) ------------------------------# 
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
 
    LET g_sql="SELECT bob01,'','',bob02,bob03,'','',bob04,bob05,bob06,bob07,bob08,",
                    " bob09,bob10,bob11,bob12,bob13,bob14 ",
              "  FROM bob_file ",             # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
 
    PREPARE i611_p1 FROM g_sql                # uUNTIME 編譯
    DECLARE i611_curo                         # CURSOR
        CURSOR FOR i611_p1
 
#   START REPORT i611_rep TO l_name           #FUN-770052
 
    FOREACH i611_curo INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT ima02,ima021 INTO sr.ima02,sr.ima021 FROM ima_file
         WHERE ima01 = sr.bob01
        SELECT ima02,ima021 INTO sr.ima02b,sr.ima021b FROM ima_file
         WHERE ima01 = sr.bob04
        IF cl_null(sr.ima02)  THEN LET sr.ima02  = " " END IF
        IF cl_null(sr.ima021) THEN LET sr.ima021 = " " END IF
        IF cl_null(sr.ima02b) THEN LET sr.ima02b = " " END IF
        IF cl_null(sr.ima021b) THEN LET sr.ima021b = " " END IF
#       OUTPUT TO REPORT i611_rep(sr.*)       #FUN-770052
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-770052 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
                   sr.bob01,sr.bob02,sr.bob03,sr.bob04,sr.bob07,sr.bob08,                                                           
                   sr.bob09,sr.bob10,sr.ima02,sr.ima02b,sr.bob13,sr.bob11,
                   sr.ima021,sr.ima021b,sr.bob14
        #------------------------------ CR (3) ------------------------------# 
    END FOREACH
 
#   FINISH REPORT i611_rep                         #FUN-770052
 
    CLOSE i611_curo
    ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)              #FUN-770052
 
#--No.FUN-770052--str--add--#                                                                                                       
    IF g_zz05 = 'Y' THEN                                                                                                            
       CALL cl_wcchp(g_wc,'bob01,bob02,bob03,bob04,bob05,bob06')                                                                                                  
            RETURNING g_wc                                                                                                          
    END IF                                                                                                                          
#--No.FUN-770052--end--add--#
 
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-770052 **** ##                                                        
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                             
    LET g_str = g_wc                                                                                     
    CALL cl_prt_cs3('abmi611','abmi611',l_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#  
END FUNCTION
 
{REPORT i611_rep(sr)                               #FUN-770052
DEFINE
    l_trailer_sw    LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
    l_chr           LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
    l_tot           LIKE type_file.num20_6,  #No.FUN-680096 DECIMAL(20,6)
    l_page          LIKE type_file.num5,     #No.FUN-680096 SMALLINT
    l_dash          LIKE type_file.chr8,     #No.FUN-680096 VARCHAR(8)
    sr              RECORD
                bob01       LIKE bob_file.bob01,
                ima02       LIKE ima_file.ima02,
                ima021      LIKE ima_file.ima021,
                bob02       LIKE bob_file.bob02,
                bob03       LIKE bob_file.bob03,
                ima02b      LIKE ima_file.ima02,
                ima021b     LIKE ima_file.ima021,
                bob04       LIKE bob_file.bob04,
                bob05       LIKE bob_file.bob05,
                bob06       LIKE bob_file.bob06,
                bob07       LIKE bob_file.bob07,
                bob08       LIKE bob_file.bob08,
                bob09       LIKE bob_file.bob09,
                bob10       LIKE bob_file.bob10,
                bob11       LIKE bob_file.bob11,
                bob12       LIKE bob_file.bob12,
                bob13       LIKE bob_file.bob13,
                bob14       LIKE bob_file.bob14
    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.bob01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT
            PRINT g_dash
            PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
            PRINTX name=H2 g_x[39],g_x[40],g_x[41],g_x[42]
            PRINTX name=H3 g_x[43],g_x[44]
            PRINTX name=H4 g_x[45]
            PRINT g_dash1
            LET l_trailer_sw = "n"
 
        BEFORE GROUP OF sr.bob01  #料件編號
            SKIP TO TOP OF PAGE
 
        ON EVERY ROW
          PRINTX name=D1 COLUMN g_c[31],sr.bob01,
                         COLUMN g_c[32],sr.bob02 USING "#######&",
                         COLUMN g_c[33],sr.bob03 USING "#######&",
                         COLUMN g_c[34],sr.bob04,
                         COLUMN g_c[35],cl_numfor(sr.bob07,35,3),
                         COLUMN g_c[36],cl_numfor(sr.bob08,36,5),
                         COLUMN g_c[37],cl_numfor(sr.bob09,37,5),
                         COLUMN g_c[38],sr.bob10
          PRINTX name=D2 COLUMN g_c[39],sr.ima02,
                         COLUMN g_c[40],sr.ima02b,
                         COLUMN g_c[41],cl_numfor(sr.bob13,41,3),
                         COLUMN g_c[42],sr.bob11
          PRINTX name=D3 COLUMN g_c[43],sr.ima021,
                         COLUMN g_c[44],sr.ima021b
          PRINTX name=D4 COLUMN g_c[45],sr.bob14
 
        ON LAST ROW
            LET l_trailer_sw = "y"
 
        PAGE TRAILER
            PRINT g_dash
            IF l_trailer_sw = "y" THEN
                PRINT COLUMN   1,g_x[4] CLIPPED,
                      COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                PRINT COLUMN   1,g_x[4] CLIPPED,
                      COLUMN (g_len-9), g_x[5] CLIPPED
            END IF
END REPORT}                                     #FUN-770052
 
#單頭
FUNCTION i611_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("bob01,bob02,bob03",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i611_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF (NOT g_before_input_done) AND g_chkey = 'N' THEN  #No.FUN-570110
       IF p_cmd = 'u' THEN
           CALL cl_set_comp_entry("bob01,bob02,bob03",FALSE)
       END IF
       IF NOT cl_null(g_argv1) THEN
           CALL cl_set_comp_entry("bob01,bob02",FALSE)
       END IF
   END IF
 
END FUNCTION
#Patch....NO.MOD-5A0095 <001,002,003,004> #
