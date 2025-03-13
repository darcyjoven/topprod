# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli932.4gl
# Descriptions...: 人工輸入金額設定
# Date & Author..: 01/02/13 Mandy  
# Modify.........: No:MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No:MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No:FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No:MOD-4C0171 05/01/06 By Nicola 修改參數第一個保留給帳別
# Modify.........: No:FUN-510007 05/02/15 By Nicola 報表架構修改
#                                                   增加列印會計名稱aag02
# Modify.........: No:FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No:FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No:FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No:FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No:FUN-6B0040 06/11/15 By jamie FUNCTION _fetch() 一開始應清空key值
# Modify.........: No:TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No:FUN-740020 07/04/05 By Lynn 會計科目加帳套-財務
# Modify.........: No:TQC-740093 07/04/19 By bnlent 會計科目加帳套-財務BUG
# Modify.........: No:MOD-740268 07/04/23 By bnlent 1、錄入時，帳套開窗有誤
#                                                   2、解決查詢筆數問題
# Modify.........: No:TQC-740305 07/04/28 By Lynn 金額欄位未管控，錄入負數仍能通過
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No:FUN-7C0043 07/12/20 By Cockroach 報表改為 p_query實現
# Modify.........: No:FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No:TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No:FUN-920122 09/05/21 By yiting 1.單頭欄位異動 
#                                                   2.科目編號處理：回頭CHECK agli931存在的科目(異動別為4.人工輸入) 為開窗資料，AFTER FIELD檢查時同邏輯
# Modify.........: No:FUN-920176 09/05/21 By jan 報表輸出方式改用CR
# Modify.........: NO.FUN-950051 09/05/26 By lutingting 由于agli002單頭增加"獨立會科合并"欄位,對檢查會科方式修改
# Modify.........: No.TQC-960360 09/06/25 By chenmoyan 按筆數FETCH的時候少INTO兩個變量
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0106 09/11/19 By kevin 用s_dbstring(l_dbs CLIPPED) 判斷跨資料庫
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/06/03 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A30122 10/08/23 By vealxu 合併帳別/合併資料庫的抓法改為CALL s_get_aaz641,s_aaz641_dbs
# Modify.........: No.FUN-A40049 10/09/06 By chenmoyan 去除多MARK的部分
# Modify.........: No.TQC-AB0320 10/11/30 By lixia 年度欄位輸入負數控管
# Modify.........: No.FUN-B50001 11/05/10 By lutingting agls101參數檔改為aaw_file
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-D30032 13/04/02 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE 
    g_bookno        LIKE aaa_file.aaa01,
    g_aaa           RECORD LIKE aaa_file.*,
    g_git00         LIKE git_file.git00,   #帳套代碼(假單頭)     #No.FUN-740020
    g_git01         LIKE git_file.git01,   #群組代號(假單頭)
    g_git02         LIKE git_file.git02,   #科目編號(假單頭)
    g_git06         LIKE git_file.git06,   #科目編號(假單頭)
    g_git07         LIKE git_file.git07,   #科目編號(假單頭)
    g_git08         LIKE git_file.git08,   #FUN-920122 add                
    g_git09         LIKE git_file.git09,   #FUN-920122 add                
    g_git00_t       LIKE git_file.git00,   #帳套代號(舊值)      #No.FUN-740020
    g_git01_t       LIKE git_file.git01,   #群組代號(舊值)
    g_git02_t       LIKE git_file.git02,   #科目編號(舊值)
    g_git06_t       LIKE git_file.git06,   #科目編號(舊值)
    g_git07_t       LIKE git_file.git07,   #科目編號(舊值)
    g_git08_t       LIKE git_file.git08,   #FUN-920122 add                
    g_git09_t       LIKE git_file.git09,   #FUN-920122 add                
    g_git           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        git03       LIKE git_file.git03,   #編號
        git04       LIKE git_file.git04,   #說明
        git05       LIKE git_file.git05    #金額
                    END RECORD,
    g_git_t         RECORD                 #程式變數 (舊值)
        git03       LIKE git_file.git03,   #編號
        git04       LIKE git_file.git04,   #說明
        git05       LIKE git_file.git05    #金額
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,        #TQC-630166  
    g_delete        LIKE type_file.chr1,      #若刪除資料,則要重新顯示筆數  #No.FUN-680098    CHAR(1) 
    g_rec_b         LIKE type_file.num5,      #單身筆數        #No.FUN-680098 SMALLINT
    l_ac            LIKE type_file.num5       #目前處理的ARRAY CNT        #No.FUN-680098 SMALLINT

#主程式開始
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL  
DEFINE   g_before_input_done  LIKE type_file.num5          #No.FUN-680098  SMALLINT
DEFINE   g_cnt                LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE   g_i                  LIKE type_file.num5          #cont/index for any purpose        #No.FUN-680098 SMALLINT
DEFINE   g_msg                LIKE type_file.chr1000       #No.FUN-680098 CHAR(72)
DEFINE   g_row_count          LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE   g_curs_index         LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE   g_jump               LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE   mi_no_ask            LIKE type_file.num5          #No.FUN-680098  SMALLINT
DEFINE   g_sql_tmp            STRING                       #No.MOD-740268
DEFINE   g_dbs_axz03          LIKE type_file.chr21         #FUN-920122 add
DEFINE   g_plant_axz03        LIKE type_file.chr21         #FUN-A30122 add
DEFINE   g_axz05              LIKE axz_file.axz05          #FUN-920122 add
DEFINE   l_sql                 STRING                                                 
DEFINE   l_table               STRING
DEFINE   g_str                 STRING     

MAIN
DEFINE
    p_row,p_col     LIKE type_file.num5             #開窗的位置       #No.FUN-680098 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
   
   LET g_sql = "git06.git_file.git06,",
               "git07.git_file.git07,",
               "git08.git_file.git08,",
               "git09.git_file.git09,",
               "axz02.axz_file.axz02,",
               "axz03.axz_file.axz03,",
               "git01.git_file.git01,",
               "gir02.gir_file.gir02,",
               "git02.git_file.git02,",
               "aag02.aag_file.aag02,",
               "git03.git_file.git03,", 
               "git04.git_file.git04,",
               "git05.git_file.git05,",
               "git00.git_file.git00,"
   LET l_table = cl_prt_temptable('agli932',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?) "                                    
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                 

    LET p_row = ARG_VAL(2)        #No:MOD-4C0171                 #取得螢幕位置
    LET p_col = ARG_VAL(3)        #No:MOD-4C0171
    LET g_git00      = NULL       #清除鍵值        #No.FUN-740020
    LET g_git01      = NULL       #清除鍵值
    LET g_git02      = NULL       #FUN-920122 add        
    LET g_git06      = NULL       #FUN-920122 add         
    LET g_git07      = NULL       #FUN-920122 add         
    LET g_git08      = NULL       #FUN-920122 add         
    LET g_git09      = NULL       #FUN-920122 add         
    LET g_git00_t    = NULL       #No.FUN-740020
    LET g_git01_t    = NULL
    LET g_git06_t    = NULL       #FUN-920122 add         
    LET g_git07_t    = NULL       #FUN-920122 add         
    LET g_git08_t    = NULL       #FUN-920122 add         
    LET g_git09_t    = NULL       #FUN-920122 add         

    IF g_bookno = ' ' OR g_bookno IS NULL THEN LET g_bookno = g_aaz.aaz64 END IF

    SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01 = g_bookno
    LET p_row = 3 LET p_col = 16
    OPEN WINDOW i932_w AT p_row,p_col      #顯示畫面
      WITH FORM "agl/42f/agli932"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
    
    CALL cl_ui_init()

    LET g_delete = 'N'
    CALL i932_menu()
    CLOSE WINDOW i932_w                    #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN

#QBE 查詢資料
FUNCTION i932_cs()
    CLEAR FORM                              #清除畫面
    CALL g_git.clear()
    CALL cl_set_head_visible("","YES")      #No.FUN-6B0029

    INITIALIZE g_git00 TO NULL    #No.FUN-750051
    INITIALIZE g_git01 TO NULL    #No.FUN-750051
    INITIALIZE g_git02 TO NULL    #No.FUN-750051
    INITIALIZE g_git06 TO NULL    #No.FUN-750051
    INITIALIZE g_git07 TO NULL    #No.FUN-750051
    INITIALIZE g_git08 TO NULL    #FUN-920122 add
    INITIALIZE g_git09 TO NULL    #FUN-920122 add

    CONSTRUCT g_wc ON git08,git09,git00,git06,git07,git01,git02,
                      git03,git04,git05                             #螢幕上取條件     #No.FUN-740020
                 FROM git08,git09,git00,git06,git07,git01,git02,
                      s_git[1].git03,s_git[1].git04,s_git[1].git05

    BEFORE CONSTRUCT
       CALL cl_qbe_init()

    ON ACTION controlp                 # 沿用所有欄位
       CASE
          WHEN INFIELD(git00)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aaa"    #No.MOD-740268
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO git00
             NEXT FIELD git00 
          WHEN INFIELD(git01)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_gir"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO git01
             NEXT FIELD git01 
          WHEN INFIELD(git02)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_gis1"   #FUN-920122 mod
             LET g_qryparam.multiret_index = "2"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO git02
             NEXT FIELD git02 
          WHEN INFIELD(git08) #族群編號
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form = "q_axa1"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO git08
             NEXT FIELD git08
          WHEN INFIELD(git09)  
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_axz"      
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO git09  
             NEXT FIELD git09
          OTHERWISE
             EXIT CASE
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
    
       ON ACTION qbe_select
         CALL cl_qbe_select() 
       ON ACTION qbe_save
         CALL cl_qbe_save()
    END CONSTRUCT

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN RETURN END IF
    LET g_sql="SELECT UNIQUE git00,git01,git02,git06,git07,git08,git09 FROM git_file ",     #FUN-920122 mod  #No.FUN-740020
              "    WHERE ", g_wc CLIPPED,
              "    ORDER BY git00,git01 "        #No.TQC-740093
    PREPARE i932_prepare FROM g_sql              #預備一下
    DECLARE i932_b_cs                            #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i932_prepare
                                                 #計算本次查詢單頭的筆數
   LET g_sql_tmp ="SELECT UNIQUE git00,git01,git02,git06,git07,git08,git09 FROM git_file ",  #FUN-920122 mod     
              "    WHERE ", g_wc CLIPPED,
              " INTO TEMP x "
    DROP TABLE x
    PREPARE i932_precount_x FROM g_sql_tmp  
    EXECUTE i932_precount_x
    LET g_sql="SELECT COUNT(*) FROM x"
    PREPARE i932_precount FROM g_sql
    DECLARE i932_count CURSOR FOR i932_precount
END FUNCTION

FUNCTION i932_menu()
   DEFINE l_cmd    LIKE  type_file.chr1000   #NO.FUN-7C0043
   WHILE TRUE
      CALL i932_bp("G")
      CASE g_action_choice
           WHEN "insert" 
                IF cl_chk_act_auth() THEN 
                   CALL i932_a()
                END IF
           WHEN "query" 
                IF cl_chk_act_auth() THEN
                   CALL i932_q()
                END IF
           WHEN "next" 
                CALL i932_fetch('N')
           WHEN "previous" 
                CALL i932_fetch('P')
           WHEN "delete" 
            IF cl_chk_act_auth() THEN
                CALL i932_r()
            END IF
           WHEN "detail" 
                IF cl_chk_act_auth() THEN
                   CALL i932_b()
                ELSE
                   LET g_action_choice = NULL
                END IF
           WHEN "output" 
                IF cl_chk_act_auth() THEN
                   CALL i932_out()                                                                                                 
                END IF
           WHEN "help" 
                CALL cl_show_help()
           WHEN "exit"
                 EXIT WHILE
           WHEN "jump"
                CALL i932_fetch('/')
           WHEN "controlg"
                CALL cl_cmdask()
          WHEN "related_document"  #No:MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_git01 IS NOT NULL THEN
                  LET g_doc.column1 = "git01"
                  LET g_doc.value1 = g_git01
                  LET g_doc.column2 = "git02"
                  LET g_doc.value2 = g_git02
                  LET g_doc.column3 = "git06"    #FUN-920122 mod column4->column3
                  LET g_doc.value3 = g_git06     #FUN-920122 mod column4->column3
                  LET g_doc.column4 = "git07"    #FUN-920122 mod column5->column4
                  LET g_doc.value4 = g_git07     #FUN-920122 mod column5->column4
                  LET g_doc.column5 = "git08"    #FUN-920122 add
                  LET g_doc.value5 = g_git08     #FUN-920122 add
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No:FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_git),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION


#Add  輸入
FUNCTION i932_a()
DEFINE   l_n    LIKE type_file.num5          #No.FUN-680098  SMALLINT
   
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM
    CALL g_git.clear()

    INITIALIZE g_git00 LIKE git_file.git00      #No.FUN-740020
    INITIALIZE g_git01 LIKE git_file.git01
    INITIALIZE g_git02 LIKE git_file.git02
    INITIALIZE g_git06 LIKE git_file.git06
    INITIALIZE g_git07 LIKE git_file.git07
    INITIALIZE g_git08 LIKE git_file.git08      #FUN-920122 add
    INITIALIZE g_git09 LIKE git_file.git09      #FUN-920122 add

    LET g_git00_t = NULL       #No.FUN-740020
    LET g_git01_t = NULL
    LET g_git02_t = NULL
    LET g_git06_t = NULL
    LET g_git07_t = NULL
    LET g_git08_t = NULL      #FUN-920122 add
    LET g_git09_t = NULL      #FUN-920122 add

    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i932_i("a")                           #輸入單頭
        IF INT_FLAG THEN                           #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        CALL g_git.clear()
        SELECT COUNT(*) INTO l_n FROM git_file 
         WHERE git01 = g_git01
           AND git00 = g_git00      #No.FUN-740020
           AND git02 = g_git02
           AND git06 = g_git06
           AND git07 = g_git07
           AND git08 = g_git08      #FUN-920122 add
           AND git09 = g_git09      #FUN-920122 add  

        LET g_rec_b = 0                    #No.FUN-680064
        IF l_n > 0 THEN
           CALL i932_b_fill('1=1')
         END IF
        CALL i932_b()                             #輸入單身
        LET g_git01_t = g_git01                   #保留舊值
        LET g_git00_t = g_git00       #No.FUN-740020
        LET g_git02_t = g_git02       #FUN-920122 add
        LET g_git06_t = g_git06       #FUN-920122 add
        LET g_git07_t = g_git07       #FUN-920122 add
        LET g_git08_t = g_git08       #FUN-920122 add
        LET g_git09_t = g_git09       #FUN-920122 add
        EXIT WHILE
    END WHILE
END FUNCTION

#處理INPUT
FUNCTION i932_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,                  #a:輸入 u:更改        #No.FUN-680098 CHAR(1)
    l_git01         LIKE git_file.git01,
    l_git00         LIKE git_file.git00,
    l_n1,l_n        LIKE type_file.num5          #FUN-920122 add

    DISPLAY g_git08,g_git09,g_git00,g_git06,g_git07,g_git01,g_git02                    #FUN-920122 mod
         TO git08,git09,git00,git06,git07,git01,git02                                  #FUN-920122 mod  #No.FUN-740020 

    LET g_before_input_done = FALSE
    CALL i932_set_entry(p_cmd)
    CALL i932_set_no_entry(p_cmd)
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029

    INPUT g_git08,g_git09,g_git00,g_git06,g_git07,g_git01,g_git02      
        WITHOUT DEFAULTS
        FROM git08,git09,git00,git06,git07,git01,git02     
 
#TQC-AB0320--add---str---
       AFTER FIELD git06
          IF NOT cl_null(g_git06) AND g_git06 < 0 THEN
             CALL cl_err('', 'afa-370', 0)
             NEXT FIELD git06
          END IF
#TQC-AB0320--add---end---

        AFTER FIELD git07
         IF NOT cl_null(g_git07) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_git06
            IF g_azm.azm02 = 1 THEN
               IF g_git07 > 12 OR g_git07 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD git07
               END IF
            ELSE
               IF g_git07 > 13 OR g_git07 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD git07
               END IF
            END IF
         END IF

        AFTER FIELD git01  #群組代號                
           IF NOT cl_null(g_git01) THEN
              CALL i932_git01('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_git01,g_errno,0)
                 LET g_git01 = g_git01_t
                 DISPLAY g_git01 TO git01
                 NEXT FIELD git01
              END IF
           END IF

        AFTER FIELD git02  #科目編號
           IF NOT cl_null(g_git02) THEN
              CALL i932_git02('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_git02,g_errno,0)
                 LET g_git02 = g_git02_t
                 DISPLAY g_git02 TO git02
                 NEXT FIELD git02
              END IF
           END IF

      AFTER FIELD git08   #族群代號
         IF cl_null(g_git08) THEN
            CALL cl_err(g_git08,'mfg0037',0)
            NEXT FIELD git08
         ELSE
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM axa_file
             WHERE axa01=g_git08
            IF cl_null(l_n) THEN LET l_n = 0 END IF
            IF l_n = 0 THEN
               CALL cl_err(g_git08,'agl-223',0)
               NEXT FIELD git08
            END IF
         END IF

      AFTER FIELD git09 
         IF NOT cl_null(g_git09) THEN 
               CALL i932_git09('a',g_git09,g_git08)   #FUN-950051 add git08
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_git09,g_errno,0)
                  NEXT FIELD git09
               END IF
            IF g_git08 IS NOT NULL AND g_git09 IS NOT NULL AND
               g_git00 IS NOT NULL THEN
               LET l_n = 0   LET l_n1 = 0
               SELECT COUNT(*) INTO l_n FROM axa_file
                WHERE axa01=g_git08 AND axa02=g_git09
                  AND axa03=g_axz05
               SELECT COUNT(*) INTO l_n1 FROM axb_file
                WHERE axb01=g_git08 AND axb04=g_git09
                  AND axb05=g_axz05
               IF l_n+l_n1 = 0 THEN
                  CALL cl_err(g_git09,'agl-223',0)
                  LET g_git08 = g_git08_t
                  LET g_git09 = g_git09_t
                  LET g_git00 = g_git00_t
                  DISPLAY BY NAME g_git08,g_git09,g_git00
                  NEXT FIELD git09
               END IF
            END IF
         END IF 

        ON ACTION CONTROLP                 # 沿用所有欄位
           CASE
              WHEN INFIELD(git00)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aaa"    
                  LET g_qryparam.default1 = g_git00
                  CALL cl_create_qry() RETURNING g_git00 
                  DISPLAY g_git00 TO git00
                  NEXT FIELD git00 
              WHEN INFIELD(git01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gir"
                 LET g_qryparam.default1 = g_git01
                 CALL cl_create_qry() RETURNING g_git01
                 DISPLAY g_git01 TO git01
                 NEXT FIELD git01 
              WHEN INFIELD(git02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gis1"     #FUN-920122 mod
                 LET g_qryparam.arg1 = g_git00     #No.TQC-740093
                 LET g_qryparam.default1 = g_git01
                 LET g_qryparam.default2 = g_git02
                 CALL cl_create_qry() RETURNING l_git01,g_git02
                 DISPLAY g_git02 TO git02
                 NEXT FIELD git02 
              WHEN INFIELD(git08) #族群編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_axa1"
                 LET g_qryparam.default1 = g_git08
                 CALL cl_create_qry() RETURNING g_git08
                 DISPLAY g_git08 TO git08
                 NEXT FIELD git08
              WHEN INFIELD(git09)  
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_axz"    
                 LET g_qryparam.default1 = g_git09
                 CALL cl_create_qry() RETURNING g_git09
                 DISPLAY g_git09 TO git09 
                 NEXT FIELD git09
              OTHERWISE
                 EXIT CASE
          END CASE
        ON ACTION controls                                        
           CALL cl_set_head_visible("","AUTO")                    
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
        
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION help          
           CALL cl_show_help()  

        ON ACTION CONTROLG
            CALL cl_cmdask()
    END INPUT
END FUNCTION

FUNCTION i932_git01(p_cmd) #群組代碼
DEFINE
    p_cmd      LIKE type_file.chr1,          #No.FUN-680098 CHAR(1)
    l_gir02    LIKE gir_file.gir02

   LET g_errno=''
   SELECT gir02 INTO l_gir02
       FROM gir_file
       WHERE gir01 = g_git01
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-917' #無此群組代碼!!
                                LET l_gir02=NULL
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
       DISPLAY l_gir02 TO FORMONLY.gir02 
   END IF
END FUNCTION

FUNCTION i932_git02(p_cmd) #科目編號
DEFINE
    p_cmd      LIKE type_file.chr1,          #No.FUN-680098  CHAR(1)
    l_aag02    LIKE aag_file.aag02

   LET g_errno=''
   SELECT *
       FROM gis_file
       WHERE gis01 = g_git01
         AND gis00 = g_git00       #No.FUN-740020
         AND gis02 = g_git02
         AND gis04 = '4'        #人工輸入
         AND gis05 = g_git08    #FUN-920122 add
         AND gis06 = g_git09    #FUN-920122 add
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-001' #無此科目編號!!
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE

   LET g_sql = "SELECT aag02",
              #"  FROM ",g_dbs_axz03,"aag_file",  #FUN-A50102
               "  FROM ",cl_get_target_table(g_plant_new,'aag_file'),  #FUN-A50102
               " WHERE aag01 = '",g_git02,"'",
               "   AND aag00 = '",g_git00,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
   PREPARE i932_pre_1 FROM g_sql
   DECLARE i932_cur_1 CURSOR FOR i932_pre_1
   OPEN i932_cur_1
   FETCH i932_cur_1 INTO l_aag02

   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-001' #無此科目編號!!
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF cl_null(g_errno) THEN 
       DISPLAY l_aag02 TO FORMONLY.aag02
   END IF
END FUNCTION

#Query 查詢
FUNCTION i932_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i932_cs()                         #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i932_b_cs                         #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                  #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_git01 TO NULL
    ELSE
        CALL i932_fetch('F')               #讀出TEMP第一筆並顯示
        OPEN i932_count
        FETCH i932_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  #
    END IF
END FUNCTION

#處理資料的讀取
FUNCTION i932_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式          #No.FUN-680098 CHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680098 INTEGER

    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i932_b_cs INTO g_git00,g_git01,g_git02,g_git06,g_git07,g_git08,g_git09  #FUN-920122 add git08,git09     #No.FUN-740020
        WHEN 'P' FETCH PREVIOUS i932_b_cs INTO g_git00,g_git01,g_git02,g_git06,g_git07,g_git08,g_git09  #FUN-920122 add git08,git09     #No.FUN-740020
        WHEN 'F' FETCH FIRST    i932_b_cs INTO g_git00,g_git01,g_git02,g_git06,g_git07,g_git08,g_git09  #FUN-920122 add git08,git09     #No.FUN-740020
        WHEN 'L' FETCH LAST     i932_b_cs INTO g_git00,g_git01,g_git02,g_git06,g_git07,g_git08,g_git09  #FUN-920122 add git08,git09     #No.FUN-740020
        WHEN '/' 
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i932_b_cs INTO g_git00,g_git01,g_git02,g_git06,g_git07,g_git08,g_git09     #No.TQC-960360
            LET mi_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_git01,SQLCA.sqlcode,0)
       INITIALIZE g_git01 TO NULL             #No.FUN-6B0040  add
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

    CALL i932_show()
END FUNCTION

#將資料顯示在畫面上
FUNCTION i932_show()

    DISPLAY g_git08,g_git09,g_git00,g_git06,g_git07,g_git01,g_git02                         #FUN-920122 mod  
         TO git08,git09,git00,git06,git07,git01,git02                                #單頭  #FUN-920122 mod   #No.FUN-740020

    CALL i932_git01('d')
    CALL i932_git02('d')
    CALL i932_git09('d',g_git09,g_git08)              #FUN-920122 add  #FUN-950051 add git08
    CALL i932_b_fill(g_wc)                    #單身
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

END FUNCTION


#取消整筆 (所有合乎單頭的資料)
FUNCTION i932_r()
    IF s_shut(0) THEN RETURN END IF           #檢查權限
    IF g_git01 IS NULL THEN
       CALL cl_err("",-400,0)                 #No.FUN-6B0040
       RETURN
    END IF
    BEGIN WORK
    IF cl_delh(0,0) THEN                      #確認一下
        INITIALIZE g_doc.* TO NULL           #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "git01"          #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_git01           #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "git02"          #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_git02           #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "git06"          #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_git06           #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "git07"          #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_git07           #No.FUN-9B0098 10/02/24
        LET g_doc.column5 = "git08"          #No.FUN-9B0098 10/02/24
        LET g_doc.value5 = g_git08           #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                   #No.FUN-9B0098 10/02/24
        DELETE FROM git_file WHERE git01 = g_git01
                               AND git00 = g_git00      #No.FUN-740020
                               AND git02 = g_git02
                               AND git06 = g_git06
                               AND git07 = g_git07
                               AND git08 = g_git08      #FUN-920122 add
                               AND git09 = g_git09      #FUN-920122 add
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","git_file",g_git01,g_git02,SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660123
        ELSE
            CLEAR FORM
            DROP TABLE x
            PREPARE i932_precount_x2 FROM g_sql_tmp  
            EXECUTE i932_precount_x2                 
            CALL g_git.clear()
            LET g_delete='Y'
            LET g_git00 = NULL
            LET g_git01 = NULL
            LET g_git02 = NULL
            LET g_git06 = NULL
            LET g_git07 = NULL
            LET g_git08 = NULL   #FUN-920122 add
            LET g_git09 = NULL   #FUN-920122 add
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN i932_count
            #FUN-B50062-add-start--
            IF STATUS THEN
               CLOSE i932_b_cs
               CLOSE i932_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end-- 
            FETCH i932_count INTO g_row_count
            #FUN-B50062-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i932_b_cs
               CLOSE i932_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end-- 
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i932_b_cs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i932_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i932_fetch('/')
            END IF
        END IF
    END IF
    COMMIT WORK
END FUNCTION

#單身
FUNCTION i932_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680098 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680098 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680098 CHAR(1)
   p_cmd           LIKE type_file.chr1,                 #處理狀態         #No.FUN-680098 CHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680098 SMALLINT
   l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680098 SMALLINT

   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF        #檢查權限
   IF g_git01 IS NULL OR g_git02 IS NULL THEN
       RETURN
   END IF

   CALL cl_opmsg('b')                #單身處理的操作提示
   SELECT azi04 INTO g_azi04        #幣別檔小數位數讀取
     FROM azi_file
    WHERE azi01=g_aaa.aaa03

   LET g_forupd_sql = "SELECT git03,git04,git05 FROM git_file",
                      " WHERE git00 = ? AND git01 =? AND git02 =? AND git06 =?",     #No.FUN-740020
                      "   AND git07 =? AND git03 =? AND git08 =? AND git09 =? FOR UPDATE"  #FUN-920122 mod
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i932_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_git WITHOUT DEFAULTS FROM s_git.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

      BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'                   #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b>=l_ac THEN
            LET p_cmd='u'                   
            LET g_git_t.* = g_git[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN i932_bcl USING g_git00,g_git01,g_git02,g_git06,g_git07,g_git_t.git03,g_git08,g_git09   #FUN-920122 mod
            IF STATUS THEN
               CALL cl_err("OPEN i932_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            END IF
            FETCH i932_bcl INTO g_git_t.* 
            IF SQLCA.sqlcode THEN
               CALL cl_err('lock git',SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF

      AFTER FIELD git03
         IF NOT cl_null(g_git[l_ac].git03) THEN
            IF g_git[l_ac].git03 != g_git_t.git03 OR g_git_t.git03 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM git_file 
                WHERE git01 = g_git01 
                  AND git00 = g_git00      #No.FUN-740020
                  AND git02 = g_git02
                  AND git06 = g_git06
                  AND git07 = g_git07
                  AND git08 = g_git08      #FUN-920122 add
                  AND git09 = g_git09      #FUN-920122 add
                  AND git03 = g_git[l_ac].git03
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_git[l_ac].git03 = g_git_t.git03
                  NEXT FIELD git03
               END IF
            END IF
         END IF

      AFTER FIELD git05
         IF g_git[l_ac].git05 < 0 THEN
            LET g_git[l_ac].git05 = NULL
            NEXT FIELD git05
         END IF 
         IF NOT cl_null(g_git[l_ac].git05) THEN
            LET g_git[l_ac].git05 = cl_numfor(g_git[l_ac].git05,15,g_azi04)
         END IF
     
      BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_git[l_ac].* TO NULL         #900423
          LET g_git_t.* = g_git[l_ac].*            #新輸入資料
          CALL cl_show_fld_cont()     #FUN-550037(smin)
          NEXT FIELD git03

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
          INSERT INTO git_file (git00,git01,git02,git03,git06,git07,git04,git05,git08,git09) #FUN-920122 add git08,git09  #No:MOD-470041   #No.FUN-740020
              VALUES(g_git00,g_git01,g_git02,g_git[l_ac].git03,g_git06,g_git07,       #No.FUN-740020
                     g_git[l_ac].git04,g_git[l_ac].git05,g_git08,g_git09)             #FUN-920122 add git08,git09   
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","git_file",g_git01,g_git02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF

      BEFORE DELETE                                #是否取消單身
         IF g_git_t.git03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN             #詢問是否確定
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM git_file
             WHERE git01 = g_git01
               AND git00 = g_git00      #No.FUN-740020
               AND git02 = g_git02
               AND git06 = g_git06
               AND git07 = g_git07
               AND git08 = g_git08      #FUN-920122 add
               AND git09 = g_git09      #FUN-920122 add
               AND git03 = g_git_t.git03 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","git_file",g_git01,g_git02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
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
             LET g_git[l_ac].* = g_git_t.*
             CLOSE i932_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_git[l_ac].git03,-263,1)
             LET g_git[l_ac].* = g_git_t.*
          ELSE
             UPDATE git_file SET git03 = g_git[l_ac].git03,
                                 git04 = g_git[l_ac].git04,
                                 git05 = g_git[l_ac].git05 
              WHERE git01 = g_git01 
                AND git00 = g_git00     #No.FUN-740020
                AND git02 = g_git02
                AND git06 = g_git06
                AND git07 = g_git07
                AND git03 = g_git_t.git03
                AND git08 = g_git08    #FUN-920122 add
                AND git09 = g_git09    #FUN-920122 add
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","git_file",g_git01,g_git02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                LET g_git[l_ac].* = g_git_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF

      AFTER ROW
          LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30032
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             #FUN-D30032--add--str--
             IF p_cmd='u' THEN
                LET g_git[l_ac].* = g_git_t.*
             ELSE
                CALL g_git.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             END IF
             #FUN-D30032--add--end--
             CLOSE i932_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac  #FUN-D30032
          LET g_git_t.* = g_git[l_ac].*
          CLOSE i932_bcl
          COMMIT WORK

      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(git03) AND l_ac > 1 THEN
            LET g_git[l_ac].* = g_git[l_ac-1].*
            NEXT FIELD git03
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
   
   END INPUT

   CLOSE i932_bcl
   COMMIT WORK

END FUNCTION

FUNCTION i932_b_askkey()
   CLEAR FORM
   CALL g_git.clear()
   CONSTRUCT g_wc2 ON git03,git04,git05                #螢幕上取條件
       FROM s_git[1].git03,s_git[1].git04,s_git[1].git05
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
   END CONSTRUCT

   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   CALL i932_b_fill(g_wc2)
END FUNCTION
   
FUNCTION i932_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            STRING,        #TQC-630166    
    l_flag          LIKE type_file.chr1,              #有無單身筆數        #No.FUN-680098 CHAR(1)
    l_sql           STRING        #TQC-630166        
 
    LET l_sql = "SELECT git03,git04,git05 FROM git_file",
                " WHERE git01 = '",g_git01,"'",
                "   AND git00 = '",g_git00,"'",      #No.FUN-740020
                "   AND git02 = '",g_git02,"'",
                "   AND git06 = '",g_git06,"'",
                "   AND git07 = '",g_git07,"'",
                "   AND git08 = '",g_git08,"'",      #FUN-920122 add
                "   AND git09 = '",g_git09,"'",      #FUN-920122 add
                "   AND ",p_wc CLIPPED,
                " ORDER BY git03"  #No.TQC-740093

    PREPARE git_pre FROM l_sql
    DECLARE git_cs CURSOR FOR git_pre

    CALL g_git.clear()
    LET g_cnt = 1
    LET l_flag='N'
    LET g_rec_b=0
    FOREACH git_cs INTO g_git[g_cnt].*     #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt=g_cnt+1
       LET l_flag='Y'
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_git.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    IF l_flag='N' THEN LET g_rec_b=0 END IF     #無單身時將筆數清為零
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION

FUNCTION i932_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 CHAR(1)


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_git TO s_git.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

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
      ON ACTION first 
         CALL i932_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
                              

      ON ACTION previous
         CALL i932_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
                              

      ON ACTION jump
         CALL i932_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
                              

      ON ACTION next
         CALL i932_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
                              

      ON ACTION last
         CALL i932_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
                              

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

#@    ON ACTION 相關文件  
       ON ACTION related_document  #No:MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION exporttoexcel   #No:FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
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
 

      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    

      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION



FUNCTION i932_set_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098  CHAR(1)

    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("git01",TRUE)
    END IF 

END FUNCTION

FUNCTION i932_set_no_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680098 CHAR(1)

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
       CALL cl_set_comp_entry("git01",FALSE) 
    END IF 

    CALL cl_set_comp_entry("git00",FALSE) #FUN-920122 add

END FUNCTION

FUNCTION  i932_git09(p_cmd,p_git09,p_git08)   #FUN-950051 add git08 
DEFINE p_cmd           LIKE type_file.chr1,         
       p_git09         LIKE git_file.git09,
       l_axz02         LIKE axz_file.axz02,
       l_axz03         LIKE axz_file.axz03,
       l_axz05         LIKE axz_file.axz05,
       #l_aaz641        LIKE aaz_file.aaz641,   #FUN-B50001
       l_aaw01         LIKE aaw_file.aaw01,
       p_git08         LIKE git_file.git08,   #FUN-950051 add 
       l_axa09         LIKE axa_file.axa09    #FUN-950051 add    

    LET g_errno = ' '
    
   #FUN-A30122 ---------------------mod start---------------------
   #SELECT axa09 INTO l_axa09 FROM axa_file
   # WHERE axa01 = p_git08   #族群
   #   AND axa02 = p_git09   #公司編號
       SELECT axz02,axz03,axz05 INTO l_axz02,l_axz03,l_axz05 
         FROM axz_file
        WHERE axz01 = p_git09
   #IF l_axa09 = 'Y' THEN
   #   LET g_plant_new = l_axz03      #營運中心
   #   CALL s_getdbs()
   #   LET g_dbs_axz03 = g_dbs_new    #所屬DB

   #  #LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",   #FUN-A50102
   #   LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),   #FUN-A50102
   #               " WHERE aaz00 = '0'"
   #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql #FUN-A50102
   #   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
   #   PREPARE i932_pre FROM g_sql
   #   DECLARE i932_cur CURSOR FOR i932_pre
   #   OPEN i932_cur
   #   FETCH i932_cur INTO l_aaz641    #合併後帳別
   #   IF cl_null(l_aaz641) THEN
   #       CALL cl_err(l_axz03,'agl-601',1)
   #   END IF
   #ELSE
   #   LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)
   #   SELECT aaz641 INTO l_aaz641 FROM aaz_file WHERE aaz00 = '0'
   #END IF 
    
   # SELECT axz05 INTO l_axz05 FROM axz_file
   #  WHERE axz01 = p_git09 
   #LET g_axz05 = l_axz05
   #FUN-A30122 ---------------------------mod end----------------------------
    LET g_axz05 = l_axz05  #FUN-A40049
    CALL s_aaz641_dbs(p_git08,p_git09) RETURNING g_plant_axz03  #FUN-A30122                   
    #CALL s_get_aaz641(g_plant_axz03) RETURNING l_aaz641         #FUN-A30122 #FUN-B50001
    CALL s_get_aaz641(g_plant_axz03) RETURNING l_aaw01
    LET g_plant_new = g_plant_axz03                             #FUN-A30122    
    #LET g_git00 = l_aaz641     #FUN-B50001
    LET g_git00 = l_aaw01

    CASE
       WHEN SQLCA.SQLCODE=100 
          LET g_errno = 'mfg9142'
          LET l_axz02 = NULL
          LET l_axz03 = NULL 
       OTHERWISE
          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE

    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_axz02 TO FORMONLY.axz02 
       DISPLAY l_axz03 TO FORMONLY.axz03                                          
       DISPLAY g_git00 TO FORMONLY.git00 
    END IF

END FUNCTION

FUNCTION i932_out()
 DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680098  SMALLINT
    sr              RECORD
                        git06       LIKE git_file.git06,
                        git07       LIKE git_file.git07,
                        git01       LIKE git_file.git01,   
                        gir02       LIKE gir_file.gir02,   
                        git02       LIKE git_file.git02,   
                        git03       LIKE git_file.git03,   
                        git04       LIKE git_file.git04,   
                        git05       LIKE git_file.git05,
                        aag02       LIKE aag_file.aag02,
                       git00       LIKE aag_file.aag00      #No.FUN-740020
                     END RECORD,
     l_name          LIKE type_file.chr20                #External(Disk) file name        #No.FUN-680098 CHAR(20)
     DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-7C0043 
     DEFINE
            l_git  RECORD
                   git06     LIKE git_file.git06,
                   git07     LIKE git_file.git07,
                   git08     LIKE git_file.git08,
                   git09     LIKE git_file.git09,
                   axz02     LIKE axz_file.axz02,
                   axz03     LIKE axz_file.axz03,
                   git01     LIKE git_file.git01,
                   gir02     LIKE gir_file.gir02,
                   git02     LIKE git_file.git02,
                   aag02     LIKE aag_file.aag02,
                   git03     LIKE git_file.git03,
                   git04     LIKE git_file.git04,
                   git05     LIKE git_file.git05,
                   git00     LIKE git_file.git00
                             END RECORD,
            l_sql            STRING,
            l_azp03          LIKE type_file.chr20
            
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog

     CALL cl_del_data(l_table) 

     LET g_sql = " SELECT git06,git07,git08,git09,axz02,axz03,git01,gir02,git02,'',git03,git04,git05,git00 ",
                 " FROM (git_file LEFT OUTER JOIN gir_file ON gir01 =git01) ",
                 " LEFT OUTER JOIN axz_file ON(axz01 = git09) "
     PREPARE i932_p1 FROM g_sql
     DECLARE i932_p2 CURSOR FOR i932_p1
     FOREACH i932_p2 INTO l_git.*
       SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = l_git.axz03
          LET l_azp03 = s_dbstring(l_azp03 CLIPPED)   #FUN-9B0106
         #FUN-A50102--mod--str--
         #LET l_sql = "SELECT aag02 FROM ",l_azp03 CLIPPED,"aag_file WHERE aag00 ='",l_git.git00,"' AND",
          LET l_sql = "SELECT aag02 ",
                      "  FROM ",cl_get_target_table(l_git.axz03,'aag_file'),
                      " WHERE aag00 ='",l_git.git00,"' AND",
         #FUN-A50102--mod--end
                      " aag01 = '",l_git.git02 ,"'"
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql     #FUN-A50102
          CALL cl_parse_qry_sql(l_sql,l_git.axz03) RETURNING l_sql  #FUN-A50102
          PREPARE aag_sel FROM l_sql
          EXECUTE aag_sel INTO l_git.aag02
          EXECUTE insert_prep USING l_git.*
     END FOREACH      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
      IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(g_wc,'git00,git01,git02,git06,git07') RETURNING g_wc
         LET g_str = g_wc
      END IF  
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED          

     LET g_str = g_str,";",g_azi04

     CALL cl_prt_cs3('agli932','agli932',l_sql,g_str)         
             
END FUNCTION
#No.FUN-9C0072 精簡程式碼

