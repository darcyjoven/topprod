# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: ggli503.4gl
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
# Modify.........: No.FUN-A30122 10/08/23 By vealxu 合併帳別/合併資料庫的抓法改為CALL s_get_aaz641_asg,s_aaz641_asg
# Modify.........: No.FUN-A40049 10/09/06 By chenmoyan 去除多MARK的部分
# Modify.........: No.TQC-AB0320 10/11/30 By lixia 年度欄位輸入負數控管
# Modify.........: No.FUN-B50001 11/05/10 By lutingting agls101參數檔改為asz_file
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: NO.FUN-BB0037 11/11/22 By lilingyu 合併報表移植
# Modify.........: No.TQC-BB0246 11/12/02 By zhuhao 本幣原幣修改
# Modify.........: No:FUN-D30032 13/04/02 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE 
    g_bookno        LIKE aaa_file.aaa01,    #FUN-BB0037
    g_aaa           RECORD LIKE aaa_file.*,
    g_atl00         LIKE atl_file.atl00,   #帳套代碼(假單頭)     #No.FUN-740020
    g_atl01         LIKE atl_file.atl01,   #群組代號(假單頭)
    g_atl02         LIKE atl_file.atl02,   #科目編號(假單頭)
    g_atl06         LIKE atl_file.atl06,   #科目編號(假單頭)
    g_atl07         LIKE atl_file.atl07,   #科目編號(假單頭)
    g_atl08         LIKE atl_file.atl08,   #FUN-920122 add                
    g_atl09         LIKE atl_file.atl09,   #FUN-920122 add                
    g_atl00_t       LIKE atl_file.atl00,   #帳套代號(舊值)      #No.FUN-740020
    g_atl01_t       LIKE atl_file.atl01,   #群組代號(舊值)
    g_atl02_t       LIKE atl_file.atl02,   #科目編號(舊值)
    g_atl06_t       LIKE atl_file.atl06,   #科目編號(舊值)
    g_atl07_t       LIKE atl_file.atl07,   #科目編號(舊值)
    g_atl08_t       LIKE atl_file.atl08,   #FUN-920122 add                
    g_atl09_t       LIKE atl_file.atl09,   #FUN-920122 add                
    g_atl           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        atl03       LIKE atl_file.atl03,   #編號
        atl04       LIKE atl_file.atl04,   #說明
        atl05       LIKE atl_file.atl05    #金額
                    END RECORD,
    g_atl_t         RECORD                 #程式變數 (舊值)
        atl03       LIKE atl_file.atl03,   #編號
        atl04       LIKE atl_file.atl04,   #說明
        atl05       LIKE atl_file.atl05    #金額
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
DEFINE   g_dbs_asg03          LIKE type_file.chr21         #FUN-920122 add
DEFINE   g_plant_asg03        LIKE type_file.chr21         #FUN-A30122 add
DEFINE   g_asg05              LIKE asg_file.asg05          #FUN-920122 add
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
  
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
   
   LET g_sql = "atl06.atl_file.atl06,",
               "atl07.atl_file.atl07,",
               "atl08.atl_file.atl08,",
               "atl09.atl_file.atl09,",
               "asg02.asg_file.asg02,",
               "asg03.asg_file.asg03,",
               "atl01.atl_file.atl01,",
               "atj02.atj_file.atj02,",
               "atl02.atl_file.atl02,",
               "aag02.aag_file.aag02,",
               "atl03.atl_file.atl03,", 
               "atl04.atl_file.atl04,",
               "atl05.atl_file.atl05,",
               "atl00.atl_file.atl00,"
   LET l_table = cl_prt_temptable('ggli503',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?) "                                    
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                 

    LET p_row = ARG_VAL(2)        #No:MOD-4C0171                 #取得螢幕位置
    LET p_col = ARG_VAL(3)        #No:MOD-4C0171
    LET g_atl00      = NULL       #清除鍵值        #No.FUN-740020
    LET g_atl01      = NULL       #清除鍵值
    LET g_atl02      = NULL       #FUN-920122 add        
    LET g_atl06      = NULL       #FUN-920122 add         
    LET g_atl07      = NULL       #FUN-920122 add         
    LET g_atl08      = NULL       #FUN-920122 add         
    LET g_atl09      = NULL       #FUN-920122 add         
    LET g_atl00_t    = NULL       #No.FUN-740020
    LET g_atl01_t    = NULL
    LET g_atl06_t    = NULL       #FUN-920122 add         
    LET g_atl07_t    = NULL       #FUN-920122 add         
    LET g_atl08_t    = NULL       #FUN-920122 add         
    LET g_atl09_t    = NULL       #FUN-920122 add         

    IF g_bookno = ' ' OR g_bookno IS NULL THEN LET g_bookno = g_aaz.aaz64 END IF

    SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01 = g_bookno
    LET p_row = 3 LET p_col = 16
    OPEN WINDOW i932_w AT p_row,p_col      #顯示畫面
      WITH FORM "ggl/42f/ggli503"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
    
    CALL cl_ui_init()

    LET g_delete = 'N'
    CALL i932_menu()
    CLOSE WINDOW i932_w                    #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN

#QBE 查詢資料
FUNCTION i932_cs()
    CLEAR FORM                              #清除畫面
    CALL g_atl.clear()
    CALL cl_set_head_visible("","YES")      #No.FUN-6B0029

    INITIALIZE g_atl00 TO NULL    #No.FUN-750051
    INITIALIZE g_atl01 TO NULL    #No.FUN-750051
    INITIALIZE g_atl02 TO NULL    #No.FUN-750051
    INITIALIZE g_atl06 TO NULL    #No.FUN-750051
    INITIALIZE g_atl07 TO NULL    #No.FUN-750051
    INITIALIZE g_atl08 TO NULL    #FUN-920122 add
    INITIALIZE g_atl09 TO NULL    #FUN-920122 add

    CONSTRUCT g_wc ON atl08,atl09,atl00,atl06,atl07,atl01,atl02,
                      atl03,atl04,atl05                             #螢幕上取條件     #No.FUN-740020
                 FROM atl08,atl09,atl00,atl06,atl07,atl01,atl02,
                      s_atl[1].atl03,s_atl[1].atl04,s_atl[1].atl05

    BEFORE CONSTRUCT
       CALL cl_qbe_init()

    ON ACTION controlp                 # 沿用所有欄位
       CASE
          WHEN INFIELD(atl00)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aaa"    #No.MOD-740268
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO atl00
             NEXT FIELD atl00 
          WHEN INFIELD(atl01)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_atj"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO atl01
             NEXT FIELD atl01 
          WHEN INFIELD(atl02)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_gis1"   #FUN-920122 mod
             LET g_qryparam.multiret_index = "2"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO atl02
             NEXT FIELD atl02 
          WHEN INFIELD(atl08) #族群編號
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form = "q_asa1"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO atl08
             NEXT FIELD atl08
          WHEN INFIELD(atl09)  
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_asg"      
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO atl09  
             NEXT FIELD atl09
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
    LET g_sql="SELECT UNIQUE atl00,atl01,atl02,atl06,atl07,atl08,atl09 FROM atl_file ",     #FUN-920122 mod  #No.FUN-740020
              "    WHERE ", g_wc CLIPPED,
              "    ORDER BY atl00,atl01 "        #No.TQC-740093
    PREPARE i932_prepare FROM g_sql              #預備一下
    DECLARE i932_b_cs                            #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i932_prepare
                                                 #計算本次查詢單頭的筆數
   LET g_sql_tmp ="SELECT UNIQUE atl00,atl01,atl02,atl06,atl07,atl08,atl09 FROM atl_file ",  #FUN-920122 mod     
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
               IF g_atl01 IS NOT NULL THEN
                  LET g_doc.column1 = "atl01"
                  LET g_doc.value1 = g_atl01
                  LET g_doc.column2 = "atl02"
                  LET g_doc.value2 = g_atl02
                  LET g_doc.column3 = "atl06"    #FUN-920122 mod column4->column3
                  LET g_doc.value3 = g_atl06     #FUN-920122 mod column4->column3
                  LET g_doc.column4 = "atl07"    #FUN-920122 mod column5->column4
                  LET g_doc.value4 = g_atl07     #FUN-920122 mod column5->column4
                  LET g_doc.column5 = "atl08"    #FUN-920122 add
                  LET g_doc.value5 = g_atl08     #FUN-920122 add
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No:FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_atl),'','')
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
    CALL g_atl.clear()

    INITIALIZE g_atl00 LIKE atl_file.atl00      #No.FUN-740020
    INITIALIZE g_atl01 LIKE atl_file.atl01
    INITIALIZE g_atl02 LIKE atl_file.atl02
    INITIALIZE g_atl06 LIKE atl_file.atl06
    INITIALIZE g_atl07 LIKE atl_file.atl07
    INITIALIZE g_atl08 LIKE atl_file.atl08      #FUN-920122 add
    INITIALIZE g_atl09 LIKE atl_file.atl09      #FUN-920122 add

    LET g_atl00_t = NULL       #No.FUN-740020
    LET g_atl01_t = NULL
    LET g_atl02_t = NULL
    LET g_atl06_t = NULL
    LET g_atl07_t = NULL
    LET g_atl08_t = NULL      #FUN-920122 add
    LET g_atl09_t = NULL      #FUN-920122 add

    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i932_i("a")                           #輸入單頭
        IF INT_FLAG THEN                           #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        CALL g_atl.clear()
        SELECT COUNT(*) INTO l_n FROM atl_file 
         WHERE atl01 = g_atl01
           AND atl00 = g_atl00      #No.FUN-740020
           AND atl02 = g_atl02
           AND atl06 = g_atl06
           AND atl07 = g_atl07
           AND atl08 = g_atl08      #FUN-920122 add
           AND atl09 = g_atl09      #FUN-920122 add  

        LET g_rec_b = 0                    #No.FUN-680064
        IF l_n > 0 THEN
           CALL i932_b_fill('1=1')
         END IF
        CALL i932_b()                             #輸入單身
        LET g_atl01_t = g_atl01                   #保留舊值
        LET g_atl00_t = g_atl00       #No.FUN-740020
        LET g_atl02_t = g_atl02       #FUN-920122 add
        LET g_atl06_t = g_atl06       #FUN-920122 add
        LET g_atl07_t = g_atl07       #FUN-920122 add
        LET g_atl08_t = g_atl08       #FUN-920122 add
        LET g_atl09_t = g_atl09       #FUN-920122 add
        EXIT WHILE
    END WHILE
END FUNCTION

#處理INPUT
FUNCTION i932_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,                  #a:輸入 u:更改        #No.FUN-680098 CHAR(1)
    l_atl01         LIKE atl_file.atl01,
    l_atl00         LIKE atl_file.atl00,
    l_n1,l_n        LIKE type_file.num5          #FUN-920122 add

    DISPLAY g_atl08,g_atl09,g_atl00,g_atl06,g_atl07,g_atl01,g_atl02                    #FUN-920122 mod
         TO atl08,atl09,atl00,atl06,atl07,atl01,atl02                                  #FUN-920122 mod  #No.FUN-740020 

    LET g_before_input_done = FALSE
    CALL i932_set_entry(p_cmd)
    CALL i932_set_no_entry(p_cmd)
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029

    INPUT g_atl08,g_atl09,g_atl00,g_atl06,g_atl07,g_atl01,g_atl02      
        WITHOUT DEFAULTS
        FROM atl08,atl09,atl00,atl06,atl07,atl01,atl02     
 
#TQC-AB0320--add---str---
       AFTER FIELD atl06
          IF NOT cl_null(g_atl06) AND g_atl06 < 0 THEN
             CALL cl_err('', 'afa-370', 0)
             NEXT FIELD atl06
          END IF
#TQC-AB0320--add---end---

        AFTER FIELD atl07
         IF NOT cl_null(g_atl07) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_atl06
            IF g_azm.azm02 = 1 THEN
               IF g_atl07 > 12 OR g_atl07 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD atl07
               END IF
            ELSE
               IF g_atl07 > 13 OR g_atl07 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD atl07
               END IF
            END IF
         END IF

        AFTER FIELD atl01  #群組代號                
           IF NOT cl_null(g_atl01) THEN
              CALL i932_atl01('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_atl01,g_errno,0)
                 LET g_atl01 = g_atl01_t
                 DISPLAY g_atl01 TO atl01
                 NEXT FIELD atl01
              END IF
           END IF

        AFTER FIELD atl02  #科目編號
           IF NOT cl_null(g_atl02) THEN
              CALL i932_atl02('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_atl02,g_errno,0)
                 LET g_atl02 = g_atl02_t
                 DISPLAY g_atl02 TO atl02
                 NEXT FIELD atl02
              END IF
           END IF

      AFTER FIELD atl08   #族群代號
         IF cl_null(g_atl08) THEN
            CALL cl_err(g_atl08,'mfg0037',0)
            NEXT FIELD atl08
         ELSE
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM asa_file
             WHERE asa01=g_atl08
            IF cl_null(l_n) THEN LET l_n = 0 END IF
            IF l_n = 0 THEN
               CALL cl_err(g_atl08,'agl-223',0)
               NEXT FIELD atl08
            END IF
         END IF

      AFTER FIELD atl09 
         IF NOT cl_null(g_atl09) THEN 
               CALL i932_atl09('a',g_atl09,g_atl08)   #FUN-950051 add atl08
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_atl09,g_errno,0)
                  NEXT FIELD atl09
               END IF
            IF g_atl08 IS NOT NULL AND g_atl09 IS NOT NULL AND
               g_atl00 IS NOT NULL THEN
               LET l_n = 0   LET l_n1 = 0
               SELECT COUNT(*) INTO l_n FROM asa_file
                WHERE asa01=g_atl08 AND asa02=g_atl09
                  AND asa03=g_asg05
               SELECT COUNT(*) INTO l_n1 FROM asb_file
                WHERE asb01=g_atl08 AND asb04=g_atl09
                  AND asb05=g_asg05
               IF l_n+l_n1 = 0 THEN
                  CALL cl_err(g_atl09,'agl-223',0)
                  LET g_atl08 = g_atl08_t
                  LET g_atl09 = g_atl09_t
                  LET g_atl00 = g_atl00_t
                  DISPLAY BY NAME g_atl08,g_atl09,g_atl00
                  NEXT FIELD atl09
               END IF
            END IF
         END IF 

        ON ACTION CONTROLP                 # 沿用所有欄位
           CASE
              WHEN INFIELD(atl00)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aaa"    
                  LET g_qryparam.default1 = g_atl00
                  CALL cl_create_qry() RETURNING g_atl00 
                  DISPLAY g_atl00 TO atl00
                  NEXT FIELD atl00 
              WHEN INFIELD(atl01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_atj"
                 LET g_qryparam.default1 = g_atl01
                 CALL cl_create_qry() RETURNING g_atl01
                 DISPLAY g_atl01 TO atl01
                 NEXT FIELD atl01 
              WHEN INFIELD(atl02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gis1"     #FUN-920122 mod
                 LET g_qryparam.arg1 = g_atl00     #No.TQC-740093
                 LET g_qryparam.default1 = g_atl01
                 LET g_qryparam.default2 = g_atl02
                 CALL cl_create_qry() RETURNING l_atl01,g_atl02
                 DISPLAY g_atl02 TO atl02
                 NEXT FIELD atl02 
              WHEN INFIELD(atl08) #族群編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_asa1"
                 LET g_qryparam.default1 = g_atl08
                 CALL cl_create_qry() RETURNING g_atl08
                 DISPLAY g_atl08 TO atl08
                 NEXT FIELD atl08
              WHEN INFIELD(atl09)  
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_asg"    
                 LET g_qryparam.default1 = g_atl09
                 CALL cl_create_qry() RETURNING g_atl09
                 DISPLAY g_atl09 TO atl09 
                 NEXT FIELD atl09
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

FUNCTION i932_atl01(p_cmd) #群組代碼
DEFINE
    p_cmd      LIKE type_file.chr1,          #No.FUN-680098 CHAR(1)
    l_atj02    LIKE atj_file.atj02

   LET g_errno=''
   SELECT atj02 INTO l_atj02
       FROM atj_file
       WHERE atj01 = g_atl01
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-917' #無此群組代碼!!
                                LET l_atj02=NULL
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
       DISPLAY l_atj02 TO FORMONLY.atj02 
   END IF
END FUNCTION

FUNCTION i932_atl02(p_cmd) #科目編號
DEFINE
    p_cmd      LIKE type_file.chr1,          #No.FUN-680098  CHAR(1)
    l_aag02    LIKE aag_file.aag02

   LET g_errno=''
   SELECT *
       FROM gis_file
       WHERE gis01 = g_atl01
         AND gis00 = g_atl00       #No.FUN-740020
         AND gis02 = g_atl02
         AND gis04 = '4'        #人工輸入
         AND gis05 = g_atl08    #FUN-920122 add
         AND gis06 = g_atl09    #FUN-920122 add
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-001' #無此科目編號!!
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE

   LET g_sql = "SELECT aag02",
              #"  FROM ",g_dbs_asg03,"aag_file",  #FUN-A50102
               "  FROM ",cl_get_target_table(g_plant_new,'aag_file'),  #FUN-A50102
               " WHERE aag01 = '",g_atl02,"'",
               "   AND aag00 = '",g_atl00,"'"
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
        INITIALIZE g_atl01 TO NULL
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
        WHEN 'N' FETCH NEXT     i932_b_cs INTO g_atl00,g_atl01,g_atl02,g_atl06,g_atl07,g_atl08,g_atl09  #FUN-920122 add atl08,atl09     #No.FUN-740020
        WHEN 'P' FETCH PREVIOUS i932_b_cs INTO g_atl00,g_atl01,g_atl02,g_atl06,g_atl07,g_atl08,g_atl09  #FUN-920122 add atl08,atl09     #No.FUN-740020
        WHEN 'F' FETCH FIRST    i932_b_cs INTO g_atl00,g_atl01,g_atl02,g_atl06,g_atl07,g_atl08,g_atl09  #FUN-920122 add atl08,atl09     #No.FUN-740020
        WHEN 'L' FETCH LAST     i932_b_cs INTO g_atl00,g_atl01,g_atl02,g_atl06,g_atl07,g_atl08,g_atl09  #FUN-920122 add atl08,atl09     #No.FUN-740020
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
            FETCH ABSOLUTE g_jump i932_b_cs INTO g_atl00,g_atl01,g_atl02,g_atl06,g_atl07,g_atl08,g_atl09     #No.TQC-960360
            LET mi_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_atl01,SQLCA.sqlcode,0)
       INITIALIZE g_atl01 TO NULL             #No.FUN-6B0040  add
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

    DISPLAY g_atl08,g_atl09,g_atl00,g_atl06,g_atl07,g_atl01,g_atl02                         #FUN-920122 mod  
         TO atl08,atl09,atl00,atl06,atl07,atl01,atl02                                #單頭  #FUN-920122 mod   #No.FUN-740020

    CALL i932_atl01('d')
    CALL i932_atl02('d')
    CALL i932_atl09('d',g_atl09,g_atl08)              #FUN-920122 add  #FUN-950051 add atl08
    CALL i932_b_fill(g_wc)                    #單身
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

END FUNCTION


#取消整筆 (所有合乎單頭的資料)
FUNCTION i932_r()
    IF s_shut(0) THEN RETURN END IF           #檢查權限
    IF g_atl01 IS NULL THEN
       CALL cl_err("",-400,0)                 #No.FUN-6B0040
       RETURN
    END IF
    BEGIN WORK
    IF cl_delh(0,0) THEN                      #確認一下
        INITIALIZE g_doc.* TO NULL           #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "atl01"          #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_atl01           #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "atl02"          #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_atl02           #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "atl06"          #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_atl06           #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "atl07"          #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_atl07           #No.FUN-9B0098 10/02/24
        LET g_doc.column5 = "atl08"          #No.FUN-9B0098 10/02/24
        LET g_doc.value5 = g_atl08           #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                   #No.FUN-9B0098 10/02/24
        DELETE FROM atl_file WHERE atl01 = g_atl01
                               AND atl00 = g_atl00      #No.FUN-740020
                               AND atl02 = g_atl02
                               AND atl06 = g_atl06
                               AND atl07 = g_atl07
                               AND atl08 = g_atl08      #FUN-920122 add
                               AND atl09 = g_atl09      #FUN-920122 add
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","atl_file",g_atl01,g_atl02,SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660123
        ELSE
            CLEAR FORM
            DROP TABLE x
            PREPARE i932_precount_x2 FROM g_sql_tmp  
            EXECUTE i932_precount_x2                 
            CALL g_atl.clear()
            LET g_delete='Y'
            LET g_atl00 = NULL
            LET g_atl01 = NULL
            LET g_atl02 = NULL
            LET g_atl06 = NULL
            LET g_atl07 = NULL
            LET g_atl08 = NULL   #FUN-920122 add
            LET g_atl09 = NULL   #FUN-920122 add
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
   IF g_atl01 IS NULL OR g_atl02 IS NULL THEN
       RETURN
   END IF

   CALL cl_opmsg('b')                #單身處理的操作提示
   SELECT azi04 INTO t_azi04        #幣別檔小數位數讀取     #TQC-BB0246 modify g_azi04->t_azi04
     FROM azi_file
    WHERE azi01=g_aaa.aaa03

   LET g_forupd_sql = "SELECT atl03,atl04,atl05 FROM atl_file",
                      " WHERE atl00 = ? AND atl01 =? AND atl02 =? AND atl06 =?",     #No.FUN-740020
                      "   AND atl07 =? AND atl03 =? AND atl08 =? AND atl09 =? FOR UPDATE"  #FUN-920122 mod
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i932_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_atl WITHOUT DEFAULTS FROM s_atl.*
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
            LET g_atl_t.* = g_atl[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN i932_bcl USING g_atl00,g_atl01,g_atl02,g_atl06,g_atl07,g_atl_t.atl03,g_atl08,g_atl09   #FUN-920122 mod
            IF STATUS THEN
               CALL cl_err("OPEN i932_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            END IF
            FETCH i932_bcl INTO g_atl_t.* 
            IF SQLCA.sqlcode THEN
               CALL cl_err('lock atl',SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF

      AFTER FIELD atl03
         IF NOT cl_null(g_atl[l_ac].atl03) THEN
            IF g_atl[l_ac].atl03 != g_atl_t.atl03 OR g_atl_t.atl03 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM atl_file 
                WHERE atl01 = g_atl01 
                  AND atl00 = g_atl00      #No.FUN-740020
                  AND atl02 = g_atl02
                  AND atl06 = g_atl06
                  AND atl07 = g_atl07
                  AND atl08 = g_atl08      #FUN-920122 add
                  AND atl09 = g_atl09      #FUN-920122 add
                  AND atl03 = g_atl[l_ac].atl03
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_atl[l_ac].atl03 = g_atl_t.atl03
                  NEXT FIELD atl03
               END IF
            END IF
         END IF

      AFTER FIELD atl05
         IF g_atl[l_ac].atl05 < 0 THEN
            LET g_atl[l_ac].atl05 = NULL
            NEXT FIELD atl05
         END IF 
         IF NOT cl_null(g_atl[l_ac].atl05) THEN
            LET g_atl[l_ac].atl05 = cl_numfor(g_atl[l_ac].atl05,15,t_azi04)      #TQC-BB0246 modify g_azi04->t_azi04
         END IF
     
      BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_atl[l_ac].* TO NULL         #900423
          LET g_atl_t.* = g_atl[l_ac].*            #新輸入資料
          CALL cl_show_fld_cont()     #FUN-550037(smin)
          NEXT FIELD atl03

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
          INSERT INTO atl_file (atl00,atl01,atl02,atl03,atl06,atl07,atl04,atl05,atl08,atl09) #FUN-920122 add atl08,atl09  #No:MOD-470041   #No.FUN-740020
              VALUES(g_atl00,g_atl01,g_atl02,g_atl[l_ac].atl03,g_atl06,g_atl07,       #No.FUN-740020
                     g_atl[l_ac].atl04,g_atl[l_ac].atl05,g_atl08,g_atl09)             #FUN-920122 add atl08,atl09   
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","atl_file",g_atl01,g_atl02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF

      BEFORE DELETE                                #是否取消單身
         IF g_atl_t.atl03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN             #詢問是否確定
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM atl_file
             WHERE atl01 = g_atl01
               AND atl00 = g_atl00      #No.FUN-740020
               AND atl02 = g_atl02
               AND atl06 = g_atl06
               AND atl07 = g_atl07
               AND atl08 = g_atl08      #FUN-920122 add
               AND atl09 = g_atl09      #FUN-920122 add
               AND atl03 = g_atl_t.atl03 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","atl_file",g_atl01,g_atl02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
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
             LET g_atl[l_ac].* = g_atl_t.*
             CLOSE i932_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_atl[l_ac].atl03,-263,1)
             LET g_atl[l_ac].* = g_atl_t.*
          ELSE
             UPDATE atl_file SET atl03 = g_atl[l_ac].atl03,
                                 atl04 = g_atl[l_ac].atl04,
                                 atl05 = g_atl[l_ac].atl05 
              WHERE atl01 = g_atl01 
                AND atl00 = g_atl00     #No.FUN-740020
                AND atl02 = g_atl02
                AND atl06 = g_atl06
                AND atl07 = g_atl07
                AND atl03 = g_atl_t.atl03
                AND atl08 = g_atl08    #FUN-920122 add
                AND atl09 = g_atl09    #FUN-920122 add
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","atl_file",g_atl01,g_atl02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                LET g_atl[l_ac].* = g_atl_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF

      AFTER ROW
          LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac                  #FUN-D30032 Mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
            #LET g_atl[l_ac].* = g_atl_t.*   #FUN-D30032 Mark
             #FUN-D30032--add--str--
             IF p_cmd = 'u' THEN
                LET g_atl[l_ac].* = g_atl_t.*  
             ELSE
                CALL g_atl.deleteElement(l_ac)
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
          LET l_ac_t = l_ac                  #FUN-D30032 Add  
          LET g_atl_t.* = g_atl[l_ac].*
          CLOSE i932_bcl
          COMMIT WORK

      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(atl03) AND l_ac > 1 THEN
            LET g_atl[l_ac].* = g_atl[l_ac-1].*
            NEXT FIELD atl03
         END IF

      ON ACTION CONTROLZ
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
   CALL g_atl.clear()
   CONSTRUCT g_wc2 ON atl03,atl04,atl05                #螢幕上取條件
       FROM s_atl[1].atl03,s_atl[1].atl04,s_atl[1].atl05
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
 
    LET l_sql = "SELECT atl03,atl04,atl05 FROM atl_file",
                " WHERE atl01 = '",g_atl01,"'",
                "   AND atl00 = '",g_atl00,"'",      #No.FUN-740020
                "   AND atl02 = '",g_atl02,"'",
                "   AND atl06 = '",g_atl06,"'",
                "   AND atl07 = '",g_atl07,"'",
                "   AND atl08 = '",g_atl08,"'",      #FUN-920122 add
                "   AND atl09 = '",g_atl09,"'",      #FUN-920122 add
                "   AND ",p_wc CLIPPED,
                " ORDER BY atl03"  #No.TQC-740093

    PREPARE atl_pre FROM l_sql
    DECLARE atl_cs CURSOR FOR atl_pre

    CALL g_atl.clear()
    LET g_cnt = 1
    LET l_flag='N'
    LET g_rec_b=0
    FOREACH atl_cs INTO g_atl[g_cnt].*     #單身 ARRAY 填充
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
    CALL g_atl.deleteElement(g_cnt)
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
   DISPLAY ARRAY g_atl TO s_atl.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
      CALL cl_set_comp_entry("atl01",TRUE)
    END IF 

END FUNCTION

FUNCTION i932_set_no_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680098 CHAR(1)

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
       CALL cl_set_comp_entry("atl01",FALSE) 
    END IF 

    CALL cl_set_comp_entry("atl00",FALSE) #FUN-920122 add

END FUNCTION

FUNCTION  i932_atl09(p_cmd,p_atl09,p_atl08)   #FUN-950051 add atl08 
DEFINE p_cmd           LIKE type_file.chr1,         
       p_atl09         LIKE atl_file.atl09,
       l_asg02         LIKE asg_file.asg02,
       l_asg03         LIKE asg_file.asg03,
       l_asg05         LIKE asg_file.asg05,
       #l_aaz641        LIKE aaz_file.aaz641,   #FUN-B50001
       l_asz01         LIKE asz_file.asz01,
       p_atl08         LIKE atl_file.atl08,   #FUN-950051 add 
       l_asa09         LIKE asa_file.asa09    #FUN-950051 add    

    LET g_errno = ' '
    
   #FUN-A30122 ---------------------mod start---------------------
   #SELECT asa09 INTO l_asa09 FROM asa_file
   # WHERE asa01 = p_atl08   #族群
   #   AND asa02 = p_atl09   #公司編號
       SELECT asg02,asg03,asg05 INTO l_asg02,l_asg03,l_asg05 
         FROM asg_file
        WHERE asg01 = p_atl09
   #IF l_asa09 = 'Y' THEN
   #   LET g_plant_new = l_asg03      #營運中心
   #   CALL s_getdbs()
   #   LET g_dbs_asg03 = g_dbs_new    #所屬DB

   #  #LET g_sql = "SELECT aaz641 FROM ",g_dbs_asg03,"aaz_file",   #FUN-A50102
   #   LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),   #FUN-A50102
   #               " WHERE aaz00 = '0'"
   #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql #FUN-A50102
   #   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
   #   PREPARE i932_pre FROM g_sql
   #   DECLARE i932_cur CURSOR FOR i932_pre
   #   OPEN i932_cur
   #   FETCH i932_cur INTO l_aaz641    #合併後帳別
   #   IF cl_null(l_aaz641) THEN
   #       CALL cl_err(l_asg03,'agl-601',1)
   #   END IF
   #ELSE
   #   LET g_dbs_asg03 = s_dbstring(g_dbs CLIPPED)
   #   SELECT aaz641 INTO l_aaz641 FROM aaz_file WHERE aaz00 = '0'
   #END IF 
    
   # SELECT asg05 INTO l_asg05 FROM asg_file
   #  WHERE asg01 = p_atl09 
   #LET g_asg05 = l_asg05
   #FUN-A30122 ---------------------------mod end----------------------------
    LET g_asg05 = l_asg05  #FUN-A40049
    CALL s_aaz641_asg(p_atl08,p_atl09) RETURNING g_plant_asg03  #FUN-A30122                   
    #CALL s_get_aaz641_asg(g_plant_asg03) RETURNING l_aaz641         #FUN-A30122 #FUN-B50001
    CALL s_get_aaz641_asg(g_plant_asg03) RETURNING l_asz01
    LET g_plant_new = g_plant_asg03                             #FUN-A30122    
    #LET g_atl00 = l_aaz641     #FUN-B50001
    LET g_atl00 = l_asz01

    CASE
       WHEN SQLCA.SQLCODE=100 
          LET g_errno = 'mfg9142'
          LET l_asg02 = NULL
          LET l_asg03 = NULL 
       OTHERWISE
          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE

    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_asg02 TO FORMONLY.asg02 
       DISPLAY l_asg03 TO FORMONLY.asg03                                          
       DISPLAY g_atl00 TO FORMONLY.atl00 
    END IF

END FUNCTION

FUNCTION i932_out()
 DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680098  SMALLINT
    sr              RECORD
                        atl06       LIKE atl_file.atl06,
                        atl07       LIKE atl_file.atl07,
                        atl01       LIKE atl_file.atl01,   
                        atj02       LIKE atj_file.atj02,   
                        atl02       LIKE atl_file.atl02,   
                        atl03       LIKE atl_file.atl03,   
                        atl04       LIKE atl_file.atl04,   
                        atl05       LIKE atl_file.atl05,
                        aag02       LIKE aag_file.aag02,
                       atl00       LIKE aag_file.aag00      #No.FUN-740020
                     END RECORD,
     l_name          LIKE type_file.chr20                #External(Disk) file name        #No.FUN-680098 CHAR(20)
     DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-7C0043 
     DEFINE
            l_atl  RECORD
                   atl06     LIKE atl_file.atl06,
                   atl07     LIKE atl_file.atl07,
                   atl08     LIKE atl_file.atl08,
                   atl09     LIKE atl_file.atl09,
                   asg02     LIKE asg_file.asg02,
                   asg03     LIKE asg_file.asg03,
                   atl01     LIKE atl_file.atl01,
                   atj02     LIKE atj_file.atj02,
                   atl02     LIKE atl_file.atl02,
                   aag02     LIKE aag_file.aag02,
                   atl03     LIKE atl_file.atl03,
                   atl04     LIKE atl_file.atl04,
                   atl05     LIKE atl_file.atl05,
                   atl00     LIKE atl_file.atl00
                             END RECORD,
            l_sql            STRING,
            l_azp03          LIKE type_file.chr20
            
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog

     CALL cl_del_data(l_table) 

     LET g_sql = " SELECT atl06,atl07,atl08,atl09,asg02,asg03,atl01,atj02,atl02,'',atl03,atl04,atl05,atl00 ",
                 " FROM (atl_file LEFT OUTER JOIN atj_file ON atj01 =atl01) ",
                 " LEFT OUTER JOIN asg_file ON(asg01 = atl09) "
     PREPARE i932_p1 FROM g_sql
     DECLARE i932_p2 CURSOR FOR i932_p1
     FOREACH i932_p2 INTO l_atl.*
       SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = l_atl.asg03
          LET l_azp03 = s_dbstring(l_azp03 CLIPPED)   #FUN-9B0106
         #FUN-A50102--mod--str--
         #LET l_sql = "SELECT aag02 FROM ",l_azp03 CLIPPED,"aag_file WHERE aag00 ='",l_atl.atl00,"' AND",
          LET l_sql = "SELECT aag02 ",
                      "  FROM ",cl_get_target_table(l_atl.asg03,'aag_file'),
                      " WHERE aag00 ='",l_atl.atl00,"' AND",
         #FUN-A50102--mod--end
                      " aag01 = '",l_atl.atl02 ,"'"
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql     #FUN-A50102
          CALL cl_parse_qry_sql(l_sql,l_atl.asg03) RETURNING l_sql  #FUN-A50102
          PREPARE aag_sel FROM l_sql
          EXECUTE aag_sel INTO l_atl.aag02
          EXECUTE insert_prep USING l_atl.*
     END FOREACH      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
      IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(g_wc,'atl00,atl01,atl02,atl06,atl07') RETURNING g_wc
         LET g_str = g_wc
      END IF  
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED          

     LET g_str = g_str,";",g_azi04

     CALL cl_prt_cs3('ggli503','ggli503',l_sql,g_str)         
             
END FUNCTION
#No.FUN-9C0072 精簡程式碼

