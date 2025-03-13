# Prog. Version..: '5.30.06-13.04.22(00003)'     #
# Pattern name...: agli942.4gl
# Descriptions...: 人工輸入金額設定
# Date & Author..: FUN-BC0123 12/03/07 by Lori
# Modify.........: 12/07/16 By Polly MOD-C70175 人工輸入金額拿除小於0的控卡
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE    #FUN-BC0123
    g_bookno        LIKE aaa_file.aaa01,
    g_aaa           RECORD LIKE aaa_file.*,
    g_gix00         LIKE gix_file.gix00,   #帳套代碼(假單頭)
    g_gix01         LIKE gix_file.gix01,   #群組代號(假單頭)
    g_gix02         LIKE gix_file.gix02,   #科目編號(假單頭)
    g_gix06         LIKE gix_file.gix06,   #科目編號(假單頭)
    g_gix07         LIKE gix_file.gix07,   #科目編號(假單頭)
    g_gix00_t       LIKE gix_file.gix00,   #帳套代號(舊值)
    g_gix01_t       LIKE gix_file.gix01,   #群組代號(舊值)
    g_gix02_t       LIKE gix_file.gix02,   #科目編號(舊值)
    g_gix06_t       LIKE gix_file.gix06,   #科目編號(舊值)
    g_gix07_t       LIKE gix_file.gix07,   #科目編號(舊值)
    g_gix           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        gix03       LIKE gix_file.gix03,   #編號
        gix04       LIKE gix_file.gix04,   #說明
        gix05       LIKE gix_file.gix05    #金額
                    END RECORD,
    g_gix_t         RECORD                 #程式變數 (舊值)
        gix03       LIKE gix_file.gix03,   #編號
        gix04       LIKE gix_file.gix04,   #說明
        gix05       LIKE gix_file.gix05    #金額
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,
    g_delete        LIKE type_file.chr1,      #若刪除資料,則要重新顯示筆數
    g_rec_b         LIKE type_file.num5,      #單身筆數
    l_ac            LIKE type_file.num5       #目前處理的ARRAY CNT

#主程式開始
DEFINE g_forupd_sql         STRING                 #SELECT ... FOR UPDATE NOWAIT SQL  
DEFINE g_before_input_done  LIKE type_file.num5
DEFINE g_cnt                LIKE type_file.num10
DEFINE g_i                  LIKE type_file.num5    #cont/index for any purpose
DEFINE g_msg                LIKE type_file.chr1000
DEFINE g_row_count          LIKE type_file.num10
DEFINE g_curs_index         LIKE type_file.num10
DEFINE g_jump               LIKE type_file.num10
DEFINE mi_no_ask            LIKE type_file.num5
DEFINE g_sql_tmp            STRING

MAIN
DEFINE
    p_row,p_col     LIKE type_file.num5    #開窗的位置

    OPTIONS                                #改變一些系統預設值        
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time


   LET p_row = ARG_VAL(2)        #取得螢幕位置
   LET p_col = ARG_VAL(3)
   LET g_gix00      = NULL       #清除鍵值
   LET g_gix01      = NULL       #清除鍵值
   LET g_gix00_t    = NULL
   LET g_gix01_t    = NULL
   IF g_bookno = ' ' OR g_bookno IS NULL THEN LET g_bookno = g_aaz.aaz64 END IF
   SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01 = g_bookno
   LET p_row = 3 LET p_col = 16
   OPEN WINDOW i942_w AT p_row,p_col      #顯示畫面
     WITH FORM "agl/42f/agli942"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()
   LET g_forupd_sql = " SELECT * FROM gix_file ",
                      " WHERE gix00 = ? AND gix01 = ? AND gix02 = ?",
                      "   AND gix06 = ? AND gix07 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i942_cl CURSOR FROM g_forupd_sql

   LET g_delete = 'N'
   CALL i942_menu()
   CLOSE WINDOW i942_w                    #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION i942_cs()
   CLEAR FORM                              #清除畫面
   CALL g_gix.clear()
   CALL cl_set_head_visible("","YES")

   INITIALIZE g_gix00 TO NULL
   INITIALIZE g_gix01 TO NULL
   INITIALIZE g_gix02 TO NULL
   INITIALIZE g_gix06 TO NULL
   INITIALIZE g_gix07 TO NULL
   CONSTRUCT g_wc ON gix06,gix07,gix00,gix01,gix02,gix03,gix04,gix05 #螢幕上取條件
        FROM gix06,gix07,gix00,
             gix01,gix02,s_gix[1].gix03,s_gix[1].gix04,s_gix[1].gix05

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION controlp                 # 沿用所有欄位
         CASE
            WHEN INFIELD(gix00)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_aaa"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO gix00
               NEXT FIELD gix00 
            WHEN INFIELD(gix01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_giq"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO gix01
               NEXT FIELD gix01 
            WHEN INFIELD(gix02)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_giw"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO gix02
               NEXT FIELD gix02 
            OTHERWISE
               EXIT CASE
         END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION qbe_select
         CALL cl_qbe_select() 

      ON ACTION qbe_save
         CALL cl_qbe_save()

   END CONSTRUCT

   IF INT_FLAG THEN RETURN END IF
   LET g_sql= " SELECT UNIQUE gix00,gix01,gix02,gix06,gix07 FROM gix_file ",     #No.FUN-740020
              "  WHERE ", g_wc CLIPPED,
              "  ORDER BY gix00,gix01 "  #No.TQC-740093
   PREPARE i942_prepare FROM g_sql              #預備一下
   DECLARE i942_b_cs                            #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i942_prepare
                                                #計算本次查詢單頭的筆數
   LET g_sql_tmp = " SELECT UNIQUE gix00,gix01,gix02,gix06,gix07 FROM gix_file ",     
                   "  WHERE ", g_wc CLIPPED,
                   "   INTO TEMP x "
   DROP TABLE x
   PREPARE i942_precount_x FROM g_sql_tmp  
   EXECUTE i942_precount_x
   LET g_sql="SELECT COUNT(*) FROM x"
   PREPARE i942_precount FROM g_sql
   DECLARE i942_count CURSOR FOR i942_precount
END FUNCTION

FUNCTION i942_menu()
   DEFINE l_cmd    LIKE  type_file.chr1000
   WHILE TRUE
      CALL i942_bp("G")
      CASE g_action_choice
          WHEN "insert" 
             IF cl_chk_act_auth() THEN 
                CALL i942_a()
             END IF
          WHEN "query" 
             IF cl_chk_act_auth() THEN
                CALL i942_q()
             END IF
          WHEN "modify"                          # u.更新
            IF cl_chk_act_auth() THEN
               CALL i942_u()
            END IF
          WHEN "next" 
             CALL i942_fetch('N')
          WHEN "previous" 
             CALL i942_fetch('P')
          WHEN "delete" 
             IF cl_chk_act_auth() THEN
                CALL i942_r()
             END IF
          WHEN "detail" 
             IF cl_chk_act_auth() THEN
                CALL i942_b()
             ELSE
                LET g_action_choice = NULL
             END IF
          WHEN "help" 
             CALL cl_show_help()
          WHEN "exit"
             EXIT WHILE
          WHEN "jump"
             CALL i942_fetch('/')
          WHEN "controlg"
             CALL cl_cmdask()
          WHEN "related_document"
             IF cl_chk_act_auth() THEN
                IF g_gix01 IS NOT NULL THEN
                   LET g_doc.column1 = "gix01"
                   LET g_doc.value1 = g_gix01
                   LET g_doc.column2 = "gix02"
                   LET g_doc.value2 = g_gix02
                   LET g_doc.column4 = "gix06"
                   LET g_doc.value4 = g_gix06
                   LET g_doc.column5 = "gix07"
                   LET g_doc.value5 = g_gix07
                   CALL cl_doc()
                END IF
             END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gix),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION


#Add  輸入
FUNCTION i942_a()
DEFINE   l_n    LIKE type_file.num5
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   MESSAGE ""
   CLEAR FORM
   CALL g_gix.clear()
   INITIALIZE g_gix00 LIKE gix_file.gix00
   INITIALIZE g_gix01 LIKE gix_file.gix01
   INITIALIZE g_gix02 LIKE gix_file.gix02
   INITIALIZE g_gix06 LIKE gix_file.gix06
   INITIALIZE g_gix07 LIKE gix_file.gix07
   LET g_gix00_t = NULL
   LET g_gix01_t = NULL
   LET g_gix02_t = NULL
   LET g_gix06_t = NULL
   LET g_gix07_t = NULL
  #預設值及將數值類變數清成零
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i942_i("a")                           #輸入單頭
      IF INT_FLAG THEN                           #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      CALL g_gix.clear()
      SELECT COUNT(*) INTO l_n FROM gix_file 
       WHERE gix01 = g_gix01
         AND gix00 = g_gix00
         AND gix02 = g_gix02
         AND gix06 = g_gix06
         AND gix07 = g_gix07
      LET g_rec_b = 0
      IF l_n > 0 THEN
         CALL i942_b_fill('1=1')
      END IF
      CALL i942_b()                             #輸入單身
      LET g_gix01_t = g_gix01                   #保留舊值
      LET g_gix00_t = g_gix00       #No.FUN-740020
      EXIT WHILE
   END WHILE
END FUNCTION

#處理INPUT
FUNCTION i942_i(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,                  #a:輸入 u:更改
   l_gix01         LIKE gix_file.gix01,
   l_gix00         LIKE gix_file.gix00

   DISPLAY g_gix06,g_gix07,g_gix00,g_gix01,g_gix02 TO gix06,gix07,gix00,gix01,gix02

   LET g_before_input_done = FALSE
   CALL i942_set_entry(p_cmd)
   CALL i942_set_no_entry(p_cmd)
   LET g_before_input_done = TRUE
   CALL cl_set_head_visible("","YES")

   INPUT g_gix06,g_gix07,g_gix00,g_gix01,g_gix02 WITHOUT DEFAULTS
    FROM gix06,gix07,gix00,gix01,gix02
 
      AFTER FIELD gix00
         IF NOT cl_null(g_gix00) THEN
            CALL i942_gix00(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_gix00,g_errno,0)
               NEXT FIELD gix00
            END IF
         END IF

      AFTER FIELD gix07
         IF NOT cl_null(g_gix07) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
             WHERE azm01 = g_gix06
            IF g_azm.azm02 = 1 THEN
               IF g_gix07 > 12 OR g_gix07 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD gix07
               END IF
            ELSE
               IF g_gix07 > 13 OR g_gix07 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD gix07
               END IF
            END IF
         END IF
      AFTER FIELD gix01  #群組代號                
         IF NOT cl_null(g_gix01) THEN
            CALL i942_gix01('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_gix01,g_errno,0)
               LET g_gix01 = g_gix01_t
               DISPLAY g_gix01 TO gix01
               NEXT FIELD gix01
            END IF
         END IF

      AFTER FIELD gix02  #科目編號
         IF NOT cl_null(g_gix02) THEN
            CALL i942_gix02('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_gix02,g_errno,0)
               LET g_gix02 = g_gix02_t
               DISPLAY g_gix02 TO gix02
               NEXT FIELD gix02
            END IF
         END IF

      ON ACTION CONTROLP                 # 沿用所有欄位
         CASE
            WHEN INFIELD(gix00)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"    
               LET g_qryparam.default1 = g_gix00
               CALL cl_create_qry() RETURNING g_gix00 
               DISPLAY g_gix00 TO gix00
               NEXT FIELD gix00 
            WHEN INFIELD(gix01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_giq"
               LET g_qryparam.default1 = g_gix01
               CALL cl_create_qry() RETURNING g_gix01
               DISPLAY g_gix01 TO gix01
               NEXT FIELD gix01 
            WHEN INFIELD(gix02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_giw"
               LET g_qryparam.arg1 = g_gix00
               LET g_qryparam.arg2 = g_gix01
               LET g_qryparam.default1 = g_gix02
               CALL cl_create_qry() RETURNING g_gix02
               DISPLAY g_gix02 TO gix02
               NEXT FIELD gix02 
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

FUNCTION i942_gix01(p_cmd) #群組代碼
DEFINE
    p_cmd      LIKE type_file.chr1,
    l_giq02    LIKE giq_file.giq02

   LET g_errno=''
   SELECT giq02 INTO l_giq02
       FROM giq_file
       WHERE giq01 = g_gix01
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-917' #無此群組代碼!!
                                LET l_giq02=NULL
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
       DISPLAY l_giq02 TO FORMONLY.giq02 
   END IF
END FUNCTION

FUNCTION i942_gix02(p_cmd) #科目編號
DEFINE
    p_cmd    LIKE type_file.chr1,
    l_giw04  LIKE giw_file.giw04,
    l_aag02  LIKE aag_file.aag02

   LET g_errno=''
   SELECT giw04 INTO l_giw04 FROM giw_file
    WHERE giw00 = g_gix00
      AND giw01 = g_gix01
      AND giw02 = g_gix02
   CASE
      WHEN SQLCA.sqlcode=100   LET g_errno='agl-001' #無此科目編號!!
                               RETURN
      WHEN l_giw04 <> '4'      LET g_errno='agl1028'
                               RETURN
      OTHERWISE                LET g_errno=SQLCA.sqlcode USING '------'
   END CASE

   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = g_gix02
                                             AND aag00 = g_gix00
   CASE
      WHEN SQLCA.sqlcode=100   LET g_errno='agl-001' #無此科目編號!!
      OTHERWISE                LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF cl_null(g_errno) THEN 
      DISPLAY l_aag02 TO FORMONLY.aag02
   END IF
END FUNCTION

#Query 查詢
FUNCTION i942_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CALL i942_cs()                         #取得查詢條件
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i942_b_cs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                  #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_gix01 TO NULL
   ELSE
      CALL i942_fetch('F')                #讀出TEMP第一筆並顯示
      OPEN i942_count
      FETCH i942_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
   END IF
END FUNCTION

#處理資料的讀取
FUNCTION i942_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,                 #處理方式
   l_abso          LIKE type_file.num10                 #絕對的筆數

   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i942_b_cs INTO g_gix00,g_gix01,g_gix02,g_gix06,g_gix07
      WHEN 'P' FETCH PREVIOUS i942_b_cs INTO g_gix00,g_gix01,g_gix02,g_gix06,g_gix07
      WHEN 'F' FETCH FIRST    i942_b_cs INTO g_gix00,g_gix01,g_gix02,g_gix06,g_gix07
      WHEN 'L' FETCH LAST     i942_b_cs INTO g_gix00,g_gix01,g_gix02,g_gix06,g_gix07
      WHEN '/' 
           IF (NOT mi_no_ask) THEN
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0  ######add for prompt bug
              PROMPT g_msg CLIPPED,': ' FOR g_jump
                 ON IDLE g_idle_seconds
                    CALL cl_on_idle()
                 ON ACTION about
                    CALL cl_about()
                 ON ACTION help
                    CALL cl_show_help()
                 ON ACTION controlg
                    CALL cl_cmdask()
              END PROMPT
              IF INT_FLAG THEN
                 LET INT_FLAG = 0
                 EXIT CASE
              END IF
           END IF
      FETCH ABSOLUTE g_jump i942_b_cs INTO g_gix00,g_gix01,g_gix02,g_gix06,g_gix07
      LET mi_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_gix01,SQLCA.sqlcode,0)
       INITIALIZE g_gix01 TO NULL
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

    CALL i942_show()
END FUNCTION

#將資料顯示在畫面上
FUNCTION i942_show()
   DISPLAY g_gix06,g_gix07,g_gix00,g_gix01,g_gix02 TO gix06,gix07,gix00,gix01,gix02    #單頭
   CALL i942_gix01('d')
   CALL i942_gix02('d')
   CALL i942_b_fill(g_wc)                    #單身
   CALL cl_show_fld_cont()
END FUNCTION

#取消整筆 (所有合乎單頭的資料)
FUNCTION i942_r()
   IF s_shut(0) THEN RETURN END IF           #檢查權限
   IF g_gix01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   BEGIN WORK
   IF cl_delh(0,0) THEN                      #確認一下
      INITIALIZE g_doc.* TO NULL
      LET g_doc.column1 = "gix01"
      LET g_doc.value1 = g_gix01
      LET g_doc.column2 = "gix02"
      LET g_doc.value2 = g_gix02
      LET g_doc.column4 = "gix06"
      LET g_doc.value4 = g_gix06
      LET g_doc.column5 = "gix07"
      LET g_doc.value5 = g_gix07
      CALL cl_del_doc()             
      DELETE FROM gix_file WHERE gix01 = g_gix01
                             AND gix00 = g_gix00
                             AND gix02 = g_gix02
                             AND gix06 = g_gix06
                             AND gix07 = g_gix07
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","gix_file",g_gix01,g_gix02,SQLCA.sqlcode,"","BODY DELETE:",1)
      ELSE
         CLEAR FORM
         DROP TABLE x
         PREPARE i942_precount_x2 FROM g_sql_tmp  
         EXECUTE i942_precount_x2                 
         CALL g_gix.clear()
         LET g_delete='Y'
         LET g_gix00 = NULL
         LET g_gix01 = NULL
         LET g_gix02 = NULL
         LET g_gix06 = NULL
         LET g_gix07 = NULL
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         OPEN i942_count
         FETCH i942_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i942_b_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i942_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i942_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION

#單身
FUNCTION i942_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
   l_n             LIKE type_file.num5,                #檢查重複用
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否
   p_cmd           LIKE type_file.chr1,                #處理狀態
   l_allow_insert  LIKE type_file.num5,                #可新增否
   l_allow_delete  LIKE type_file.num5                 #可刪除否

   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF        #檢查權限
   IF g_gix01 IS NULL OR g_gix02 IS NULL THEN
       RETURN
   END IF

   CALL cl_opmsg('b')               #單身處理的操作提示
   SELECT azi04 INTO g_azi04        #幣別檔小數位數讀取
     FROM azi_file
    WHERE azi01=g_aaa.aaa03

   LET g_forupd_sql = "SELECT gix03,gix04,gix05 FROM gix_file",
                      " WHERE gix00 = ? AND gix01 =? AND gix02 =? AND gix06 =?",
                      "   AND gix07 =? AND gix03 =? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i942_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_gix WITHOUT DEFAULTS FROM s_gix.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

      BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         IF g_rec_b>=l_ac THEN
            LET p_cmd='u'                   
            LET g_gix_t.* = g_gix[l_ac].*
            BEGIN WORK
            OPEN i942_bcl USING g_gix00,g_gix01,g_gix02,g_gix06,g_gix07,g_gix_t.gix03
            IF STATUS THEN
               CALL cl_err("OPEN i942_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            END IF
            FETCH i942_bcl INTO g_gix_t.* 
            IF SQLCA.sqlcode THEN
               CALL cl_err('lock gix',SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            CALL cl_show_fld_cont()
         END IF

      AFTER FIELD gix03
         IF NOT cl_null(g_gix[l_ac].gix03) THEN
            IF g_gix[l_ac].gix03 != g_gix_t.gix03 OR g_gix_t.gix03 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM gix_file 
                WHERE gix01 = g_gix01 
                  AND gix00 = g_gix00
                  AND gix02 = g_gix02
                  AND gix06 = g_gix06
                  AND gix07 = g_gix07
                  AND gix03 = g_gix[l_ac].gix03
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_gix[l_ac].gix03 = g_gix_t.gix03
                  NEXT FIELD gix03
               END IF
            END IF
         END IF

      AFTER FIELD gix05
        #IF g_gix[l_ac].gix05 < 0 THEN        #MOD-C70175 mark
         IF g_gix[l_ac].gix05 = 0 THEN        #MOD-C70175 add
            CALL cl_err('','gap-143',0)       #MOD-C70175 add
            LET g_gix[l_ac].gix05 = NULL
            NEXT FIELD gix05
         END IF 
         IF NOT cl_null(g_gix[l_ac].gix05) THEN
            LET g_gix[l_ac].gix05 = cl_numfor(g_gix[l_ac].gix05,15,g_azi04)
         END IF
     
      BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_gix[l_ac].* TO NULL
          LET g_gix_t.* = g_gix[l_ac].*            #新輸入資料
          CALL cl_show_fld_cont()
          NEXT FIELD gix03

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
          INSERT INTO gix_file (gix00,gix01,gix02,gix03,gix06,gix07,gix04,gix05)
              VALUES(g_gix00,g_gix01,g_gix02,g_gix[l_ac].gix03,g_gix06,g_gix07,
                     g_gix[l_ac].gix04,g_gix[l_ac].gix05)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","gix_file",g_gix01,g_gix02,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF

      BEFORE DELETE                                #是否取消單身
         IF g_gix_t.gix03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN             #詢問是否確定
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM gix_file
             WHERE gix01 = g_gix01
               AND gix00 = g_gix00
               AND gix02 = g_gix02
               AND gix06 = g_gix06
               AND gix07 = g_gix07
               AND gix03 = g_gix_t.gix03 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","gix_file",g_gix01,g_gix02,SQLCA.sqlcode,"","",1)
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
             LET g_gix[l_ac].* = g_gix_t.*
             CLOSE i942_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_gix[l_ac].gix03,-263,1)
             LET g_gix[l_ac].* = g_gix_t.*
          ELSE
             UPDATE gix_file SET gix03 = g_gix[l_ac].gix03,
                                 gix04 = g_gix[l_ac].gix04,
                                 gix05 = g_gix[l_ac].gix05 
              WHERE gix01 = g_gix01 
                AND gix00 = g_gix00
                AND gix02 = g_gix02
                AND gix06 = g_gix06
                AND gix07 = g_gix07
                AND gix03 = g_gix_t.gix03
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","gix_file",g_gix01,g_gix02,SQLCA.sqlcode,"","",1)
                LET g_gix[l_ac].* = g_gix_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF

      AFTER ROW
          LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac  #FUN-D30032 mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
            #LET g_gix[l_ac].* = g_gix_t.*  #FUN-D30032 mark
            #FUN-D30032--add--begin--
             IF p_cmd = 'u' THEN
                LET g_gix[l_ac].* = g_gix_t.*
             ELSE
                CALL g_gix.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             END IF  
            #FUN-D30032--add--end----
             CLOSE i942_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac  #FUN-D30032 add
          LET g_gix_t.* = g_gix[l_ac].* 
          CLOSE i942_bcl
          COMMIT WORK

      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(gix03) AND l_ac > 1 THEN
            LET g_gix[l_ac].* = g_gix[l_ac-1].*
            NEXT FIELD gix03
         END IF

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT

   CLOSE i942_bcl
   COMMIT WORK

END FUNCTION

FUNCTION i942_b_askkey()
   CLEAR FORM
   CALL g_gix.clear()
   CONSTRUCT g_wc2 ON gix03,gix04,gix05                #螢幕上取條件
        FROM s_gix[1].gix03,s_gix[1].gix04,s_gix[1].gix05
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION qbe_select
         CALL cl_qbe_select() 

      ON ACTION qbe_save
         CALL cl_qbe_save()

   END CONSTRUCT

   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   CALL i942_b_fill(g_wc2)
END FUNCTION
   
FUNCTION i942_b_fill(p_wc)              #BODY FILL UP
DEFINE
   p_wc            STRING,
   l_flag          LIKE type_file.chr1,#有無單身筆數
   l_sql           STRING
 
   LET l_sql = "SELECT gix03,gix04,gix05 FROM gix_file",
               " WHERE gix01 = '",g_gix01,"'",
               "   AND gix00 = '",g_gix00,"'",
               "   AND gix02 = '",g_gix02,"'",
               "   AND gix06 = '",g_gix06,"'",
               "   AND gix07 = '",g_gix07,"'",
               "   AND ",p_wc CLIPPED,
               " ORDER BY gix03"

   PREPARE gix_pre FROM l_sql
   DECLARE gix_cs CURSOR FOR gix_pre
   CALL g_gix.clear()
   LET g_cnt = 1
   LET l_flag='N'
   LET g_rec_b=0
   FOREACH gix_cs INTO g_gix[g_cnt].*     #單身 ARRAY 填充
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
   CALL g_gix.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF l_flag='N' THEN LET g_rec_b=0 END IF     #無單身時將筆數清為零
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
END FUNCTION

FUNCTION i942_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gix TO s_gix.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first 
         CALL i942_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION previous
         CALL i942_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION jump
         CALL i942_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION next
         CALL i942_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION last
         CALL i942_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION exporttoexcel
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
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
         AFTER DISPLAY
         CONTINUE DISPLAY  

      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i942_set_entry(p_cmd) 
   DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("gix00,gix01,gix02,gix06,gix07",TRUE)
   END IF 
END FUNCTION

FUNCTION i942_set_no_entry(p_cmd) 
   DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("gix00,gix01,gix02,gix06,gix07",FALSE) 
   END IF 
END FUNCTION

FUNCTION i942_gix00(p_cmd)
DEFINE   p_cmd       LIKE type_file.chr1
DEFINE   l_aaaacti   LIKE aaa_file.aaaacti
   LET g_errno = ' '
   SELECT aaaacti INTO l_aaaacti FROM aaa_file
    WHERE aaa01 = g_gix00

   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'anm-062'
        WHEN l_aaaacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
END FUNCTION
FUNCTION i942_u()
   DEFINE l_gix_lock    RECORD LIKE gix_file.*
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_chkey = 'N' THEN
      CALL cl_err('','agl-266',1)
      RETURN
   END IF
   LET g_gix00_t = g_gix00
   LET g_gix01_t = g_gix01
   LET g_gix02_t = g_gix02
   LET g_gix06_t = g_gix06
   LET g_gix07_t = g_gix07

   BEGIN WORK
   OPEN i942_cl USING g_gix00,g_gix01,g_gix02,g_gix06,g_gix07
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE i942_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i942_cl INTO l_gix_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("gix00 LOCK:",SQLCA.sqlcode,1)
      CLOSE i942_cl
      ROLLBACK WORK
      RETURN
   END IF

   WHILE TRUE
      CALL i942_i("u")
      IF INT_FLAG THEN
         LET g_gix00 = g_gix00_t
         LET g_gix01 = g_gix01_t
         LET g_gix02 = g_gix02_t
         LET g_gix06 = g_gix06_t
         LET g_gix07 = g_gix07_t
         DISPLAY g_gix00,g_gix01,g_gix02,g_gix06,g_gix07 TO gix00,gix01,gix02,gix06,gix07
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE gix_file SET gix00 = g_gix00, gix01 = g_gix01
                         ,gix02 = g_gix02, gix06 = g_gix06
                         ,gix07 = g_gix07
       WHERE gix00 = g_gix00_t
         AND gix01 = g_gix01_t
         AND gix02 = g_gix02_t
         AND gix06 = g_gix06_t
         AND gix07 = g_gix07_t
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","gix_file",g_gix00_t,g_gix01_t,SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION

