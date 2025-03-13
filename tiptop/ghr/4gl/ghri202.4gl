# Prog. Version..: '5.25.02-11.04.13(00010)'     #
#
# Pattern name...: ghri202.4gl
# Descriptions...: 人事考勤权限设定作业
# Date & Author..: 11/09/28 By xieyonglu
 

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 
    g_tc_hraa01         LIKE tc_hraa_file.tc_hraa01,             #user-id    (假單頭)
    g_tc_hraa01_t       LIKE tc_hraa_file.tc_hraa01,             #user-id    (舊值)
    g_tc_hraa02         LIKE tc_hraa_file.tc_hraa02,  
    g_tc_hraa02_t       LIKE tc_hraa_file.tc_hraa01,             #user-id    (舊值)
    g_zx07          LIKE zx_file.zx07,               #No.MOD-670105 add 
    g_tc_hraa           DYNAMIC ARRAY OF RECORD          #程式變數(Program Variables)
        tc_hraa03       LIKE tc_hraa_file.tc_hraa03,             #plant-no
        gem02          LIKE gem_file.gem02           #plant-name
                    END RECORD,
    g_tc_hraa_t         RECORD                           #程式變數 (舊值)
        tc_hraa03       LIKE tc_hraa_file.tc_hraa03,             #plant-no
        gem02          LIKE gem_file.gem02           #plant-name
                    END RECORD,
    g_wc                STRING,                      #TQC-630166 
    g_wc2               STRING,                      #TQC-630166
    g_sql               STRING,                      #TQC-630166
    g_rec_b             LIKE type_file.num5,         #單身筆數 #No.FUN-680135 SMALLINT
    g_succ              LIKE type_file.chr1,         #No.FUN-680135 VARCHAR(1)
    l_ac                LIKE type_file.num5          #目前處理的ARRAY CNT #No.FUN-680135 SMALLINT
DEFINE   g_forupd_sql   STRING                       #SELECT ... FOR UPDATE SQL
DEFINE   g_before_input_done  LIKE type_file.num5   #NO.MOD-580056 #No.FUN-680135 SMALLINT
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   g_i            LIKE type_file.num5          #count/index for any purpose  #No.FUN-680135 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680135 VARCHAR(72)
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5          #No.FUN-680135 SMALLINT #FUN-6A0080
DEFINE   g_argv1        LIKE tc_hraa_file.tc_hraa01
 
MAIN
   OPTIONS                                           #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                   #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)                          # user id
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0096
 
   LET g_tc_hraa01 = NULL                     #清除鍵值
   LET g_tc_hraa01_t = NULL
   LET g_tc_hraa02 = NULL                     #清除鍵值
   LET g_tc_hraa02_t = NULL
   
   OPEN WINDOW ghri202_w WITH FORM "ghr/42f/ghri202"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
       
   IF NOT cl_null(g_argv1) THEN
      CALL ghri202_q()
   END IF
 
   CALL ghri202_menu()
 
   CLOSE WINDOW ghri202_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION ghri202_cs()
 
   CLEAR FORM                             #清除畫面
   LET g_tc_hraa01=NULL
   LET g_tc_hraa02=NULL
   CALL g_tc_hraa.clear()
 
   IF NOT cl_null(g_argv1)  THEN
 
      LET g_wc = "tc_hraa01 ='",g_argv1 CLIPPED,"'" CLIPPED
 
   ELSE
      CALL cl_set_head_visible("","YES")   #No.FUN-6A0092  
      CONSTRUCT g_wc ON tc_hraa01,tc_hraa02,tc_hraa03
           FROM tc_hraa01,tc_hraa02,s_tc_hraa[1].tc_hraa03
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(tc_hraa01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_zx"
                  LET g_qryparam.state ="c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_hraa01
 
               WHEN INFIELD(tc_hraa03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gem"
                  LET g_qryparam.state ="c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_hraa03
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
     END CONSTRUCT
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
     IF INT_FLAG THEN RETURN END IF
   END IF
 
   LET g_sql="SELECT UNIQUE tc_hraa01,tc_hraa02 FROM tc_hraa_file ", # 組合出 SQL 指令
              " WHERE ", g_wc CLIPPED,
              " ORDER BY tc_hraa01"
   PREPARE ghri202_prepare FROM g_sql      #預備一下
   DECLARE ghri202_bcs                     #宣告成可捲動的
       SCROLL CURSOR  WITH HOLD FOR ghri202_prepare
 
   LET g_sql = "SELECT COUNT(DISTINCT tc_hraa01) FROM tc_hraa_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY 1" 
   PREPARE ghri202_precount FROM g_sql
   DECLARE ghri202_count CURSOR FOR ghri202_precount
 
END FUNCTION
 
FUNCTION ghri202_menu()
   WHILE TRUE
      CALL ghri202_bp("G")
      CASE g_action_choice
 
           WHEN "insert" 
            IF cl_chk_act_auth() THEN 
                CALL ghri202_a()
            END IF
 
           WHEN "query" 
            IF cl_chk_act_auth() THEN
                CALL ghri202_q()
            END IF
 
           WHEN "delete" 
            IF cl_chk_act_auth() THEN
                CALL ghri202_r()
            END IF
 
           WHEN "reproduce"             #FUN-7C0041
            IF cl_chk_act_auth() THEN
                CALL ghri202_copy()
            END IF
 
           WHEN "detail" 
            IF cl_chk_act_auth() THEN
                CALL ghri202_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
          WHEN "output" 
            IF cl_chk_act_auth()
               THEN CALL ghri202_out()
            END IF
 
           WHEN "help" 
            CALL cl_show_help()
 
           WHEN "exit"
            EXIT WHILE
 
           WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION ghri202_a()
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   MESSAGE ""
   CLEAR FORM
   CALL g_tc_hraa.clear()
 
   LET g_tc_hraa01 = NULL
   LET g_tc_hraa01_t = NULL
   LET g_tc_hraa02 = NULL
   LET g_tc_hraa02_t = NULL
 
   DISPLAY g_tc_hraa01 TO tc_hraa01
   DISPLAY g_tc_hraa02 TO tc_hraa02
   #預設值及將數值類變數清成零
   CALL cl_opmsg('a')
 
    WHILE TRUE
       CALL ghri202_i("a")                   #輸入單頭
       IF INT_FLAG THEN                   #使用者不玩了
          LET INT_FLAG = 0
          CALL cl_err('',9001,0)
          EXIT WHILE
       END IF
       CALL g_tc_hraa.clear()
       LET g_rec_b = 0
       DISPLAY g_rec_b TO FORMONLY.cn2  
 
       CALL ghri202_b()                   #輸入單身
 
       LET g_tc_hraa01_t = g_tc_hraa01            #保留舊值
       LET g_tc_hraa02_t = g_tc_hraa02
       EXIT WHILE
    END WHILE
    LET g_wc=' '
 
END FUNCTION
 
FUNCTION ghri202_u()
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
 
   IF cl_null(g_tc_hraa01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_tc_hraa01_t = g_tc_hraa01
   LET g_tc_hraa02_t = g_tc_hraa02
 
   WHILE TRUE
      CALL ghri202_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET g_tc_hraa01_t = g_tc_hraa01
         LET g_tc_hraa02_t = g_tc_hraa02
         DISPLAY g_tc_hraa01 TO tc_hraa01     #單頭
         DISPLAY g_tc_hraa02 TO tc_hraa02     #單頭
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_tc_hraa01 != g_tc_hraa01_t THEN #更改單頭值
         UPDATE tc_hraa_file SET tc_hraa01 = g_tc_hraa01        #更新DB
          WHERE tc_hraa01 = g_tc_hraa01_t                   #COLAUTH?
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","tc_hraa_file",g_tc_hraa01_t,"",SQLCA.sqlcode,"","",1)    #No.FUN-660081
            CONTINUE WHILE
         END IF
      END IF
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION ghri202_i(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改 #No.FUN-680135 VARCHAR(1)
   l_n             LIKE type_file.num5        #No.FUN-680135 SMALLINT
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT g_tc_hraa01,g_tc_hraa02 WITHOUT DEFAULTS FROM tc_hraa01,tc_hraa02

      AFTER FIELD tc_hraa01            
         IF NOT cl_null(g_tc_hraa01) THEN
            SELECT COUNT(*) INTO l_n FROM tc_hraa_file
             WHERE tc_hraa01=g_tc_hraa01
            IF l_n>0 then
               CALL cl_err(g_tc_hraa01,-239,0)
               NEXT FIELD tc_hraa01
            END IF
            SELECT zx02 INTO g_tc_hraa02 FROM zx_file WHERE zx01 = g_tc_hraa01
            IF sqlca.sqlcode THEN
               #CALL cl_err("Select p_zx,",SQLCA.SQLCODE,1)   #No.FUN-660081
               CALL cl_err3("sel","zx_file",g_tc_hraa01,"",SQLCA.sqlcode,"","Select p_zx",1)   #No.FUN-660081
               NEXT FIELD tc_hraa01
            ELSE 
               DISPLAY g_tc_hraa02 TO tc_hraa02
            END IF
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(tc_hraa01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_zx"
               LET g_qryparam.default1 = g_tc_hraa01
               CALL cl_create_qry() RETURNING g_tc_hraa01
               DISPLAY g_tc_hraa01 TO tc_hraa01
         END CASE
 
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
 
END FUNCTION
 
FUNCTION ghri202_q()
  DEFINE l_tc_hraa01  LIKE tc_hraa_file.tc_hraa01,
         l_tc_hraa02  LIKE tc_hraa_file.tc_hraa02,
         l_cnt    LIKE type_file.num10   #No.FUN-680135 INTEGER
 
   CALL cl_opmsg('q')
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
 
   CALL ghri202_cs()                    #取得查詢條件
 
   IF INT_FLAG THEN                   #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_tc_hraa01 TO NULL
      INITIALIZE g_tc_hraa02 TO NULL
      RETURN
   END IF
 
   OPEN ghri202_count
   FETCH ghri202_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt  
 
   OPEN ghri202_bcs                      #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_tc_hraa01 TO NULL
      INITIALIZE g_tc_hraa02 TO NULL
   ELSE
      CALL ghri202_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION ghri202_fetch(p_flag)
DEFINE
   p_flag      LIKE type_file.chr1,    #處理方式   #No.FUN-680135 VARCHAR(1) 
   l_abso      LIKE type_file.num10    #絕對的筆數 #No.FUN-680135 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     ghri202_bcs INTO g_tc_hraa01,g_tc_hraa02
      WHEN 'P' FETCH PREVIOUS ghri202_bcs INTO g_tc_hraa01,g_tc_hraa02
      WHEN 'F' FETCH FIRST    ghri202_bcs INTO g_tc_hraa01,g_tc_hraa02
      WHEN 'L' FETCH LAST     ghri202_bcs INTO g_tc_hraa01,g_tc_hraa02
      WHEN '/' 
         IF (NOT g_no_ask) THEN        #FUN-6A0080
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
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
         FETCH ABSOLUTE g_jump ghri202_bcs INTO g_tc_hraa01,g_tc_hraa02
         LET g_no_ask = FALSE        #FUN-6A0080
   END CASE
 
   LET g_succ='Y'
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_tc_hraa01,SQLCA.sqlcode,0)
      INITIALIZE g_tc_hraa01 TO NULL  #TQC-6B0105
      LET g_succ='N'
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL ghri202_show()
   END IF
 
END FUNCTION
 
FUNCTION ghri202_show()
 
   DISPLAY g_tc_hraa01 TO tc_hraa01        #單頭
   DISPLAY g_tc_hraa02 TO tc_hraa02
 
   CALL ghri202_b_fill()             #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION ghri202_r()
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
 
   IF g_tc_hraa01 IS NULL THEN
      RETURN
   END IF
 
    #MOD-4B0310 檢查若 zx_file 中有該user資料,就不可以砍整筆
   SELECT zx01 FROM zx_file WHERE zx01=g_tc_hraa01
   IF NOT STATUS THEN
      CALL cl_err_msg(NULL, "azz-074",g_tc_hraa01 CLIPPED,10)
      RETURN
   END IF
 
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM tc_hraa_file WHERE tc_hraa01 = g_tc_hraa01 
      IF SQLCA.sqlcode THEN
         #CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("del","tc_hraa_file",g_tc_hraa01,"",SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
      ELSE
         CLEAR FORM
         CALL g_tc_hraa.clear()
         LET g_tc_hraa01 = NULL
         LET g_tc_hraa02 = NULL
 
         OPEN ghri202_count
         FETCH ghri202_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN ghri202_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL ghri202_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE       #FUN-6A0080
            CALL ghri202_fetch('/')
         END IF
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
      END IF
   END IF
 
   COMMIT WORK
 
END FUNCTION
 
FUNCTION ghri202_b()
DEFINE
   l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
   l_n             LIKE type_file.num5,      #檢查重複用        #No.FUN-680135 SMALLINT
   l_lock_sw       LIKE type_file.chr1,      #單身鎖住否        #No.FUN-680135 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,      #處理狀態          #No.FUN-680135 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,      #可新增否          #No.FUN-680135 SMALLINT
   l_allow_delete  LIKE type_file.num5       #可刪除否          #No.FUN-680135 SMALLINT
#TQC-B30219 --------------STA
DEFINE tok         base.StringTokenizer
DEFINE l_gem01     LIKE gem_file.gem01
DEFINE l_flag      LIKE type_file.chr1

   LET l_flag = 'N'
#TQC-B30219 --------------END 

   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF           #檢查權限
   IF g_tc_hraa01 IS NULL THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT tc_hraa03,'' FROM tc_hraa_file",
                      " WHERE tc_hraa01=? AND tc_hraa03=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE ghri202_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_tc_hraa WITHOUT DEFAULTS FROM s_tc_hraa.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET g_tc_hraa_t.* = g_tc_hraa[l_ac].*      #BACKUP
            LET p_cmd='u'
            OPEN ghri202_bcl USING g_tc_hraa01,g_tc_hraa_t.tc_hraa03
            IF STATUS THEN
               CALL cl_err("OPEN ghri202_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH ghri202_bcl INTO g_tc_hraa[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_tc_hraa_t.tc_hraa03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT gem02 INTO g_tc_hraa[l_ac].gem02
                       FROM gem_file
                      WHERE gem01 = g_tc_hraa[l_ac].tc_hraa03
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
          INSERT INTO tc_hraa_file(tc_hraa01,tc_hraa02,tc_hraa03)   #No.MOD-470041
                       VALUES(g_tc_hraa01,g_tc_hraa02,g_tc_hraa[l_ac].tc_hraa03)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tc_hraa_file",g_tc_hraa01,g_tc_hraa[l_ac].tc_hraa03,SQLCA.sqlcode,"","",0)    #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            COMMIT WORK
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_tc_hraa[l_ac].* TO NULL      #900423
         LET g_tc_hraa_t.* = g_tc_hraa[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD tc_hraa03
 
      BEFORE FIELD tc_hraa03                        #default 序號
         IF cl_null(g_tc_hraa[l_ac].tc_hraa03) THEN
            LET g_tc_hraa[l_ac].tc_hraa03=""
         ELSE
            IF g_rec_b < 2 THEN
               DISPLAY g_tc_hraa[l_ac].tc_hraa03 TO tc_hraa03
            END IF 
         END IF 
 
      AFTER FIELD tc_hraa03                        #check 序號是否重複
         IF NOT cl_null(g_tc_hraa[l_ac].tc_hraa03) THEN 
            SELECT gem02 INTO g_tc_hraa[l_ac].gem02 FROM gem_file 
             WHERE gem01 = g_tc_hraa[l_ac].tc_hraa03
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("sel","gem_file",g_tc_hraa[l_ac].tc_hraa03,"",SQLCA.sqlcode,"","Plant No.",1)    #No.FUN-660081
               NEXT FIELD tc_hraa03
            END IF
         END IF
 
         IF g_tc_hraa[l_ac].tc_hraa03 != g_tc_hraa_t.tc_hraa03 OR g_tc_hraa_t.tc_hraa03 IS NULL THEN
            SELECT count(*) INTO l_n FROM tc_hraa_file
             WHERE tc_hraa01 = g_tc_hraa01
               AND tc_hraa03 = g_tc_hraa[l_ac].tc_hraa03
            IF l_n > 0 THEN
               CALL cl_err(g_tc_hraa[l_ac].tc_hraa03,-239,0)
               LET g_tc_hraa[l_ac].tc_hraa03 = g_tc_hraa_t.tc_hraa03
               NEXT FIELD tc_hraa03
            END IF
         END IF
          
      BEFORE DELETE
         IF g_tc_hraa_t.tc_hraa03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
 
            DELETE FROM tc_hraa_file
             WHERE tc_hraa01 = g_tc_hraa01 
               AND tc_hraa03 = g_tc_hraa_t.tc_hraa03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","tc_hraa_file",g_tc_hraa01,g_tc_hraa_t.tc_hraa03,SQLCA.sqlcode,"","",0)    #No.FUN-660081
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
            LET g_tc_hraa[l_ac].* = g_tc_hraa_t.*
            CLOSE ghri202_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_tc_hraa[l_ac].tc_hraa03,-263,1)
            LET g_tc_hraa[l_ac].* = g_tc_hraa_t.*
         ELSE
            UPDATE tc_hraa_file SET tc_hraa03 = g_tc_hraa[l_ac].tc_hraa03
             WHERE tc_hraa01=g_tc_hraa01
               AND tc_hraa03=g_tc_hraa_t.tc_hraa03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","tc_hraa_file",g_tc_hraa01,g_tc_hraa_t.tc_hraa03,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_tc_hraa[l_ac].* = g_tc_hraa_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_tc_hraa[l_ac].* = g_tc_hraa_t.*
            END IF
            CLOSE ghri202_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE ghri202_bcl
         COMMIT WORK
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(tc_hraa03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gem"
               IF p_cmd = 'u' THEN
                  LET g_qryparam.default1 = g_tc_hraa[l_ac].tc_hraa03
                  CALL cl_create_qry() RETURNING g_tc_hraa[l_ac].tc_hraa03
                  DISPLAY g_tc_hraa[l_ac].tc_hraa03 TO tc_hraa03
               ELSE
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  LET tok = base.StringTokenizer.createExt(g_qryparam.multiret,"|",'',TRUE)
                    WHILE tok.hasMoreTokens()
                       LET l_gem01 = tok.nextToken()
                       IF cl_null(l_gem01) THEN
                          CONTINUE WHILE
                       ELSE
                         SELECT COUNT(*) INTO l_n  FROM tc_hraa_file
                          WHERE tc_hraa01 = g_tc_hraa01 AND tc_hraa03 = l_gem01
                         IF l_n > 0 THEN
                            CONTINUE WHILE
                         END IF
                       END IF
                       INSERT INTO tc_hraa_file VALUES (g_tc_hraa01,g_tc_hraa02,l_gem01)
                    END WHILE
                   LET l_flag = 'Y'
                   EXIT INPUT
               END IF
#TQC-B30219 ------------------END
         END CASE
 
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
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
   END INPUT

   IF l_flag = 'Y' THEN
       CALL ghri202_b_fill()
       CALL ghri202_b()
   END IF
   CLOSE ghri202_bcl
   COMMIT WORK
        
END FUNCTION
   
FUNCTION ghri202_b_fill()              #BODY FILL UP
 
   LET g_sql = "SELECT tc_hraa03,gem02 ",
                " FROM tc_hraa_file LEFT OUTER JOIN gem_file ", 
                                " ON tc_hraa_file.tc_hraa03 = gem_file.gem01 ", 
               " WHERE tc_hraa_file.tc_hraa01 = '",g_tc_hraa01 CLIPPED,"' ",
               " ORDER BY tc_hraa03 "
   PREPARE ghri202_prepare2 FROM g_sql      #預備一下
   DECLARE zyy_cs CURSOR FOR ghri202_prepare2
 
   CALL g_tc_hraa.clear()
   LET g_cnt = 1
   LET g_rec_b=0
 
   FOREACH zyy_cs INTO g_tc_hraa[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_tc_hraa.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION ghri202_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680135 CHAR(1)
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_tc_hraa TO s_tc_hraa.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
        BEFORE DISPLAY
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
 
        ON ACTION insert
           LET g_action_choice="insert"
           EXIT DISPLAY
 
        ON ACTION query
           LET g_action_choice="query"     
           EXIT DISPLAY
 
        ON ACTION delete
           LET g_action_choice="delete"    
           EXIT DISPLAY
 
        ON ACTION detail
           LET g_action_choice="detail"    
           LET l_ac = 1
           EXIT DISPLAY
 
        ON ACTION help
           LET g_action_choice="help"      
           EXIT DISPLAY
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
           EXIT DISPLAY
 
        ON ACTION output
           LET g_action_choice="output"
           EXIT DISPLAY
 
        ON ACTION exit
           LET g_action_choice="exit" 
           EXIT DISPLAY
 
        ON ACTION accept
           LET g_action_choice="detail"
           LET l_ac = ARR_CURR()
           EXIT DISPLAY
     
        ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice="exit"
           EXIT DISPLAY
 
        ON ACTION first
           CALL ghri202_fetch('F')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 
        ON ACTION previous
           CALL ghri202_fetch('P')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 
        ON ACTION jump
           CALL ghri202_fetch('/')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 
        ON ACTION next
           CALL ghri202_fetch('N')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 
        ON ACTION last
           CALL ghri202_fetch('L')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 
        ON ACTION reproduce  #FUN-7C0041
           LET g_action_choice="reproduce"
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
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION ghri202_copy()    #FUN-7C0041
 
   DEFINE l_newno      LIKE tc_hraa_file.tc_hraa01,
          l_oldno      LIKE tc_hraa_file.tc_hraa01 
   DEFINE lc_zx01      LIKE zx_file.zx01
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
 
   IF cl_null(g_tc_hraa01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT l_newno FROM tc_hraa01
 
      AFTER FIELD tc_hraa01
         IF cl_null(l_newno) THEN
            NEXT FIELD tc_hraa01
         END IF
         SELECT count(*) INTO g_cnt FROM tc_hraa_file
          WHERE tc_hraa01 = l_newno
         IF g_cnt > 0 THEN
            CALL cl_err(l_newno,-239,0)
            NEXT FIELD tc_hraa01
         END IF
 
      ON ACTION about         #FUN-860033
         CALL cl_about()      #FUN-860033
 
      ON ACTION controlg      #FUN-860033
         CALL cl_cmdask()     #FUN-860033
 
      ON ACTION help          #FUN-860033
         CALL cl_show_help()  #FUN-860033
 
      ON IDLE g_idle_seconds  #FUN-860033
          CALL cl_on_idle()
          CONTINUE INPUT
 
   END INPUT
 
   IF INT_FLAG OR l_newno IS NULL THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM tc_hraa_file WHERE tc_hraa01=g_tc_hraa01 INTO TEMP x
 
   UPDATE x SET tc_hraa01=l_newno     #資料鍵值
 
   INSERT INTO tc_hraa_file SELECT * FROM x
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","tc_hraa_file",l_newno,"",SQLCA.sqlcode,"","",0)   
      RETURN
   END IF
 
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE 'COPY(',g_cnt USING '<<<<',') Rows O.K'
 
END FUNCTION
 
 
FUNCTION ghri202_out()
 
DEFINE l_cmd        LIKE type_file.chr1000
    IF cl_null(g_wc) THEN
       LET g_wc=" tc_hraa01='",g_tc_hraa01,"'"
    END IF
    IF g_wc IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    LET l_cmd = 'p_query "ghri202" "',g_wc CLIPPED,'"'
    CALL cl_cmdrun(l_cmd)
END FUNCTION
 
 
