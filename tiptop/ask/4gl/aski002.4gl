# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: aski002.4gl
# Descriptions...: 計件薪資系數維護作業
# Date & Author..: No.FUN-870117 07/07/20 By hongmei
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-940168 09/08/25 By alex 調整cl_used位置
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80030 11/08/03 By minpp 模组程序撰写规范修改
# Modify.........: No:FUN-D40030 13/04/07 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_skk01         LIKE skk_file.skk01,             #user-id    (假單頭)
    g_skk01_t       LIKE skk_file.skk01,             #user-id    (舊值)
    g_skk04         LIKE skk_file.skk04,             #類型
    g_skk04_t       LIKE skk_file.skk04,
    g_gem02         LIKE gem_file.gem02,             #部門名稱
    g_skk           DYNAMIC ARRAY OF RECORD          #程式變數(Program Variables)
        skk02       LIKE skk_file.skk02,             #年
        skk03       LIKE skk_file.skk03,             #月
        skk05       LIKE skk_file.skk05,             #說明
        skk06       LIKE skk_file.skk06,             #系數
        skkacti     LIKE skk_file.skkacti            #有效否
                    END RECORD,
    g_skk_t         RECORD                           #程式變數 (舊值)
        skk02       LIKE skk_file.skk02,
        skk03       LIKE skk_file.skk03,
        skk05       LIKE skk_file.skk05,
        skk06       LIKE skk_file.skk06,
        skkacti     LIKE skk_file.skkacti
                    END RECORD,
    g_wc                STRING,                      
    g_wc2               STRING,                      
    g_sql               STRING,                      
    g_rec_b             LIKE type_file.num5,         #單身筆數 
    g_succ              LIKE type_file.chr1,         
    l_ac                LIKE type_file.num5          #目前處理的ARRAY CNT 
DEFINE   g_forupd_sql   STRING                       #SELECT ... FOR UPDATE  SQL
DEFINE   g_before_input_done  LIKE type_file.num5   
DEFINE   g_cnt          LIKE type_file.num10         
DEFINE   g_i            LIKE type_file.num5          #count/index for any purpose  
DEFINE   g_msg          LIKE type_file.chr1000       
DEFINE   g_curs_index   LIKE type_file.num10         
DEFINE   g_row_count    LIKE type_file.num10         
DEFINE   g_jump         LIKE type_file.num10         
DEFINE   g_no_ask      LIKE type_file.num5          
DEFINE   g_argv1        LIKE skk_file.skk01
 
MAIN
   OPTIONS                                           #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                   #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)                          # user id
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASK")) THEN
      EXIT PROGRAM
   END IF
 
   IF NOT s_industry('slk') THEN
      CALL cl_err("","-1000",1)
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time     #TQC-940168
 
   LET g_skk01 = NULL                     #清除鍵值
   LET g_skk01_t = NULL
   LET g_skk04_t = NULL
 
   OPEN WINDOW i002_w WITH FORM "ask/42f/aski002"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
       
   CALL i002_menu()
 
   CLOSE WINDOW i002_w                    #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION i002_cs()
 
   CLEAR FORM                             #清除畫面
    LET g_skk01=NULL
   CALL g_skk.clear()
 
#   IF NOT cl_null(g_argv1)  THEN
#
#      LET g_wc = "skk01 ='",g_argv1 CLIPPED,"'" CLIPPED
#
#   ELSE
#      CALL cl_set_head_visible("","YES") 
      CONSTRUCT g_wc ON skk01,skk04,skk02,skk03,skk05,skk06,skkacti
                   FROM skk01,skk04,s_skk[1].skk02,s_skk[1].skk03,
                        s_skk[1].skk05,s_skk[1].skk06,s_skk[1].skkacti
             BEFORE CONSTRUCT
                 CALL cl_qbe_init()
         ON ACTION controlp
            CASE
               WHEN INFIELD(skk01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gem"
                  LET g_qryparam.state ="c"
                  LET g_qryparam.default1 = g_skk01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO skk01
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
     END CONSTRUCT
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
     IF INT_FLAG THEN RETURN END IF
#  END IF
 
   LET g_sql="SELECT UNIQUE skk01,skk04 FROM skk_file ", # 組合出 SQL 指令
              " WHERE ", g_wc CLIPPED,
              " ORDER BY skk01"
   PREPARE i002_prepare FROM g_sql      #預備一下
   DECLARE i002_cs                      #宣告成可捲動的
       SCROLL CURSOR  WITH HOLD FOR i002_prepare
 
   LET g_sql = "SELECT COUNT(*) ",
               "FROM (SELECT UNIQUE skk01,skk04 FROM skk_file) ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY 1" 
   PREPARE i002_precount FROM g_sql
   DECLARE i002_count CURSOR FOR i002_precount
 
END FUNCTION
 
FUNCTION i002_menu()
   WHILE TRUE
      CALL i002_bp("G")
      CASE g_action_choice
 
           WHEN "insert" 
            IF cl_chk_act_auth() THEN 
                CALL i002_a()
            END IF
 
           WHEN "query" 
            IF cl_chk_act_auth() THEN
                CALL i002_q()
            END IF
       
           WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i002_u()
            END IF
     
#          WHEN "reproduce"
#           IF cl_chk_act_auth() THEN
#              CALL i002_copy()
#           END IF
 
           WHEN "delete" 
            IF cl_chk_act_auth() THEN
                CALL i002_r()
            END IF
 
           WHEN "detail" 
            IF cl_chk_act_auth() THEN
                CALL i002_b()
            ELSE
               LET g_action_choice = NULL
            END IF
          
           WHEN "exporttoexcel"                                                
            IF cl_chk_act_auth() THEN                                           
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_skk),'','')
            END IF        
 
#          WHEN "output" 
#           IF cl_chk_act_auth()
#              THEN CALL i002_out()
#           END IF
 
           WHEN "help" 
            CALL cl_show_help()
 
           WHEN "exit"
            EXIT WHILE
 
           WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i002_a()
 
   MESSAGE ""
   CLEAR FORM
   CALL g_skk.clear()
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   INITIALIZE g_skk01 LIKE skk_file.skk01
   INITIALIZE g_skk04 LIKE skk_file.skk04
 
   LET g_skk01 = NULL
   LET g_skk01_t = NULL
   LET g_skk04 ='1'
  
#  DISPLAY  g_skk01,g_skk04  TO skk01,skk04 
#  DISPLAY BY NAME g_skk01,g_skk04  
   #預設值及將數值類變數清成零
   CALL cl_opmsg('a')
 
    WHILE TRUE
       CALL i002_i("a")                   #輸入單頭
       IF INT_FLAG THEN                   #使用者不玩了
          LET INT_FLAG = 0
          CALL cl_err('',9001,0)
          EXIT WHILE
       END IF
       IF cl_null(g_skk01) THEN
          CONTINUE WHILE
       END IF
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_skk01,SQLCA.sqlcode,1)  #FUN-B80030 ADD
          ROLLBACK WORK
         # CALL cl_err(g_skk01,SQLCA.sqlcode,1) #FUN-B80030 MARK
          CONTINUE WHILE
       ELSE
          COMMIT WORK
       END IF
 
       CALL g_skk.clear()
       LET g_rec_b = 0
       DISPLAY g_rec_b TO FORMONLY.cn2  
 
       CALL i002_b()                      #輸入單身
 
       LET g_skk01_t = g_skk01            #保留舊值
       LET g_skk04_t = g_skk04
       EXIT WHILE
    END WHILE
    LET g_wc=' '
 
END FUNCTION
 
FUNCTION i002_u()
 
   IF s_shut(0) THEN RETURN END IF        #檢查權限
 
   IF cl_null(g_skk01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_skk01_t = g_skk01
   LET g_skk04_t = g_skk04
 
   WHILE TRUE
      CALL i002_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET g_skk01=g_skk01_t
         LET g_skk04=g_skk04_t
         DISPLAY g_skk01 TO skk01           #單頭
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
#      IF g_skk01 != g_skk01_t THEN                  #更改單頭值
         UPDATE skk_file SET skk01 = g_skk01,       #更新DB
                             skk04 = g_skk04        
          WHERE skk01 = g_skk01_t                   #COLAUTH?
            AND skk04 = g_skk04_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","skk_file",g_skk01_t,"",SQLCA.sqlcode,"","",1)   
            CONTINUE WHILE
         END IF
#      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i002_i(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改  
   l_n             LIKE type_file.num5
   
   IF s_shut(0) THEN
      RETURN
   END IF 
 
   DISPLAY  g_skk01,g_skk04  TO skk01,skk04
   INPUT  g_skk01,g_skk04 WITHOUT DEFAULTS  FROM skk01,skk04  
      AFTER FIELD skk01                       #部門編號  
         IF NOT cl_null(g_skk01) THEN
            CALL i002_skk01('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_skk01,g_errno,0)
               NEXT FIELD skk01
            END IF
            SELECT COUNT(*) INTO l_n FROM gem_file 
                                     WHERE gem01 = g_skk01 
                                       AND gemacti='Y'
               IF l_n = 0 THEN
                 CALL cl_err(g_skk01,'asfi115',0)
                 NEXT FIELD skk01
               END IF
            END IF   
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(skk01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gem"
               LET g_qryparam.default1 = g_skk01
               CALL cl_create_qry() RETURNING g_skk01
               DISPLAY g_skk01 TO skk01
         END CASE
 
      ON ACTION CONTROLR
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
 
END FUNCTION
 
FUNCTION i002_q()
  DEFINE l_skk01  LIKE skk_file.skk01,
         l_gem02  LIKE gem_file.gem02,
         l_cnt    LIKE type_file.num10    
 
   CALL cl_opmsg('q')
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
 
   CALL i002_cs()                     #取得查詢條件
 
   IF INT_FLAG THEN                   #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
 
   OPEN i002_count
   FETCH i002_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt  
 
   OPEN i002_cs                        #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      CALL i002_fetch('F')             #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i002_fetch(p_flag)
DEFINE
   p_flag      LIKE type_file.chr1,    #處理方式    
   l_abso      LIKE type_file.num10    #絕對的筆數  
   
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i002_cs INTO g_skk01,g_skk04
      WHEN 'P' FETCH PREVIOUS i002_cs INTO g_skk01,g_skk04
      WHEN 'F' FETCH FIRST    i002_cs INTO g_skk01,g_skk04
      WHEN 'L' FETCH LAST     i002_cs INTO g_skk01,g_skk04
      WHEN '/' 
         IF (NOT g_no_ask) THEN         
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
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
         FETCH ABSOLUTE g_jump i002_cs INTO g_skk01,g_skk04
         LET g_no_ask = FALSE        
   END CASE
 
   LET g_succ='Y'
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_skk01,SQLCA.sqlcode,0)
      INITIALIZE g_skk01 TO NULL  
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
      CALL i002_show()
   END IF
 
END FUNCTION
 
FUNCTION i002_show()
 
#   LET g_skk01_t = g_skk01
#   LET g_skk04_t = g_skk04
    DISPLAY g_skk01 TO skk01
    DISPLAY g_skk04 TO skk04
 
   CALL i002_skk01('d')  
   CALL i002_b_fill(g_wc)                 #單身
 
   CALL cl_show_fld_cont()        
END FUNCTION
 
FUNCTION i002_r()
 
   IF s_shut(0) THEN RETURN END IF        #檢查權限
 
   IF g_skk01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   
#  SELECT * INTO g_skk01,g_skk04 FROM skk_file
#   WHERE skk01 = g_skk01
#     AND skk04 = g_skk04
    
   BEGIN WORK
#  OPEN i002_cl USING g_skk.skk01,g_skk.skk02,g_skk.skk03,g_skk.skk04
#  IF STATUS THEN
#     CALL cl_err("OPEN i002_cl:",STATUS,1)
#     CLOSE i002_cl
#     ROLLBACK WORK
#     RETURN
#  END IF
   
#  FETCH i002_cl INTO g_skk01,g_skk04
#  IF SQLCA.sqlcode THEN
#     CALL cl_err(g_skk01,SQLCA.sqlcode,0)
#     ROLLBACK WORK                                                             
#     RETURN                                                                    
#  END IF
 
#  CALL i002_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM skk_file WHERE skk01 = g_skk01
                             AND skk04 = g_skk04 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","skk_file",g_skk01,"",SQLCA.sqlcode,"","BODY DELETE",0)    
      ELSE
         CLEAR FORM
         CALL g_skk.clear()
         LET g_skk01 = NULL
#        LET g_gem02 = NULL
         OPEN i002_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE i002_cs
            CLOSE i002_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH i002_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i002_cs
            CLOSE i002_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i002_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i002_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE        
            CALL i002_fetch('/')
         END IF
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
      END IF
   END IF
 
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i002_b()
DEFINE
   l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT 
   l_n             LIKE type_file.num5,      #檢查重複用        
   l_lock_sw       LIKE type_file.chr1,      #單身鎖住否        
   p_cmd           LIKE type_file.chr1,      #處理狀態          
   l_allow_insert  LIKE type_file.num5,      #可新增否          
   l_allow_delete  LIKE type_file.num5       #可刪除否          
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF           #檢查權限
   IF g_skk01 IS NULL THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT skk02,skk03,skk05,skk06,skkacti FROM skk_file",
                      " WHERE skk01=? AND skk02=? AND skk03=? AND skk04=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i002_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_skk WITHOUT DEFAULTS FROM s_skk.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         LET g_rec_b  = ARR_COUNT()
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
            LET g_skk_t.* = g_skk[l_ac].*      #BACKUP
            LET p_cmd='u'
            OPEN i002_cl USING g_skk01,g_skk[l_ac].skk02,
                               g_skk[l_ac].skk03,g_skk04
            IF STATUS THEN
               CALL cl_err("OPEN i002_cl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH i002_cl INTO g_skk[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_skk04_t,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()      
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_skk[l_ac].* TO NULL 
         LET g_skk[l_ac].skk02 = YEAR(g_today)
         LET g_skk[l_ac].skk03 = MONTH(g_today)     
         LET g_skk[l_ac].skkacti = 'Y'      
         LET g_skk_t.* = g_skk[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     
         NEXT FIELD skk02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
          INSERT INTO skk_file(skk01,skk02,skk03,skk04,skk05,skk06,skkacti)   
                        VALUES(g_skk01,g_skk[l_ac].skk02,g_skk[l_ac].skk03,
                               g_skk04,g_skk[l_ac].skk05,g_skk[l_ac].skk06,
                               g_skk[l_ac].skkacti)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","skk_file",g_skk01,g_skk04,SQLCA.sqlcode,"","",0)  
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            COMMIT WORK
         END IF
 
      AFTER FIELD skk02
         IF NOT cl_null(g_skk[l_ac].skk02) THEN
            IF length(g_skk[l_ac].skk02) <>'4' THEN
               CALL cl_err('','ask-003',0)
               NEXT FIELD skk02
            END IF
         END IF   
     
      AFTER FIELD skk03
         IF NOT cl_null(g_skk[l_ac].skk03) THEN
            IF g_skk[l_ac].skk03<'1' OR g_skk[l_ac].skk03>'12' THEN
               CALL cl_err('','ask-004',0)
               NEXT FIELD skk03
            END IF
         END IF 
                   
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_skk_t.skk02) THEN
            IF NOT cl_delb(0,0) THEN
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM skk_file
             WHERE skk01=g_skk01
               AND skk04=g_skk04
               AND skk02=g_skk_t.skk02
               AND skk03=g_skk_t.skk03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","skk_file","","",SQLCA.sqlcode,"","",1)  
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
      
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_skk[l_ac].* = g_skk_t.*
            CLOSE i002_cl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_skk[l_ac].skk02,-263,1)
            LET g_skk[l_ac].* = g_skk_t.*
         ELSE
            UPDATE skk_file SET skk02 = g_skk[l_ac].skk02,
                                skk03 = g_skk[l_ac].skk03,
                                skk05 = g_skk[l_ac].skk05,
                                skk06 = g_skk[l_ac].skk06,
                                skkacti=g_skk[l_ac].skkacti
             WHERE skk01=g_skk01
               AND skk04=g_skk04
               AND skk02=g_skk_t.skk02
               AND skk03=g_skk_t.skk03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","skk_file","","",SQLCA.sqlcode,"","",0)   
               LET g_skk[l_ac].* = g_skk_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac             #FUN-D40030 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_skk[l_ac].* = g_skk_t.*
            #FUN-D40030---add---str---
            ELSE
               CALL g_skk.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030---add---end---
            END IF
            CLOSE i002_cl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac           #FUN-D40030 add
         CLOSE i002_cl
         COMMIT WORK
 
      ON ACTION CONTROLR
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
                                                                                      
      CALL cl_set_head_visible("","AUTO")                                                                                        
     
 
   END INPUT
 
   CLOSE i002_cl
   COMMIT WORK
        
END FUNCTION
   
FUNCTION i002_b_fill(p_wc)              #BODY FILL UP
 
  DEFINE
     # p_wc  LIKE type_file.chr1000
     p_wc           STRING       #NO.FUN-910082   
 
   LET g_sql = "SELECT skk02,skk03,skk05,skk06,skkacti ",
               " FROM skk_file ",
               " WHERE skk01 = '",g_skk01 CLIPPED,"' ",
               " AND   skk04 = '",g_skk04 CLIPPED,"' ",
               " ORDER BY 1"
   PREPARE i002_prepare2 FROM g_sql      #預備一下
   DECLARE skk_cs CURSOR FOR i002_prepare2
      
   CALL g_skk.clear() 
   LET g_cnt = 1
   LET g_rec_b=0
 
   FOREACH skk_cs INTO g_skk[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_skk.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i002_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1          
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
   DISPLAY g_skk01 TO skk01               #單頭
   DISPLAY g_skk04 TO skk04
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_skk TO s_skk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
        BEFORE DISPLAY
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        BEFORE ROW
           LET l_ac = ARR_CURR()
           CALL cl_show_fld_cont()                   
 
        ON ACTION insert
           LET g_action_choice="insert"
           EXIT DISPLAY
 
        ON ACTION query
           LET g_action_choice="query"     
           EXIT DISPLAY
 
        ON ACTION delete
           LET g_action_choice="delete"    
           EXIT DISPLAY
        
#       ON ACTION reproduce
#          LET g_action_choice="reproduce"
#          EXIT DISPLAY
 
        ON ACTION modify 
           LET g_action_choice="modify"
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
           CALL cl_show_fld_cont()                   
           EXIT DISPLAY
 
#        ON ACTION output
#           LET g_action_choice="output"
#           EXIT DISPLAY
 
        ON ACTION exporttoexcel                                                 
           LET g_action_choice = 'exporttoexcel'                                  
           EXIT DISPLAY
 
        ON ACTION exit
           LET g_action_choice="exit" 
           EXIT DISPLAY
 
        ON ACTION accept
           LET g_action_choice="detail"
           LET l_ac = ARR_CURR()
           EXIT DISPLAY
     
        ON ACTION cancel
           LET INT_FLAG=FALSE 		
           LET g_action_choice="exit"
           EXIT DISPLAY
 
        ON ACTION first
           CALL i002_fetch('F')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                   
 
        ON ACTION previous
           CALL i002_fetch('P')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1) 
           END IF
	         ACCEPT DISPLAY                   
 
        ON ACTION jump
           CALL i002_fetch('/')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
           END IF
	         ACCEPT DISPLAY                   
 
        ON ACTION next
           CALL i002_fetch('N')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
           END IF
	         ACCEPT DISPLAY                   
 
        ON ACTION last
           CALL i002_fetch('L')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
           END IF
	         ACCEPT DISPLAY                   
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION controlg      
           CALL cl_cmdask()     
 
        AFTER DISPLAY
           CONTINUE DISPLAY
 
        ON ACTION controls                                                                                                             
           CALL cl_set_head_visible("","AUTO")                                                                                        
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i002_skk01(p_cmd)                                                      
DEFINE     p_cmd     LIKE type_file.chr1,                                       
           l_gem02   LIKE gem_file.gem02,
           l_gemacti LIKE gem_file.gemacti                                      
   LET g_errno=' '                                                              
                                                 
   SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file 
                            WHERE gem01 = g_skk01
                              AND gemacti='Y'                                                                              
    CASE WHEN SQLCA.SQLCODE=100
             LET g_errno = 'mfg3015'
             LET l_gem02   =  NULL
        WHEN l_gemacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO FORMONLY.gem02
   END IF
END FUNCTION
 
#FUNCTION i002_copy()
#
#   DEFINE l_oldno1      LIKE skk_file.skk01,
#          l_newno1      LIKE skk_file.skk01 
#   DEFINE l_newno2      LIKE gem_file.gem02
#
#   IF s_shut(0) THEN RETURN END IF                #檢查權限
#
#   IF cl_null(g_skk01) THEN
#      CALL cl_err('',-400,0)
#      RETURN
#   END IF
#   LET g_skk01_t = g_skk01
#   CALL cl_set_head_visible("","YES")   
#   INPUT l_newno1 FROM skk01
#
#      AFTER FIELD skk01
#         IF NOT cl_null(l_newno1) THEN
#            IF l_newno1 !='*' THEN
#               SELECT * FROM skk_file WHERE skk01 = l_newno1 
#               IF SQLCA.sqlcode THEN 
#                  CALL cl_err3("sel","skk_file",l_newno1,"","mfg2727","","",0)    
#                  NEXT FIELD skk01
#               END IF
#               SELECT gem02 INTO l_newno2 FROM gem_file WHERE gem01 = l_newno1 
#               IF SQLCA.sqlcode THEN 
#                  CALL cl_err3("sel","gem_file",l_newno1,"",SQLCA.sqlcode,"","",1)    
#                  NEXT FIELD skk01
#               ELSE
#                  DISPLAY l_newno2 TO gem02
#               END IF
#            END IF
#         END IF
#
#      ON ACTION controlp
#         CASE
#            WHEN INFIELD(skk01)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_gem"
#               LET g_qryparam.default1 = g_skk01
#               CALL cl_create_qry() RETURNING g_skk01
#               DISPLAY g_skk01 TO skk01
#         END CASE
#
#      ON ACTION CONTROLR
#         CALL cl_show_req_fields()
#
#      ON ACTION CONTROLG
#         CALL cl_cmdask()
#
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
# 
#      ON ACTION about          
#         CALL cl_about()       
# 
#      ON ACTION help           
#         CALL cl_show_help()   
# 
#
#   END INPUT
#
#   IF INT_FLAG OR l_newno1 IS NULL THEN
#      LET INT_FLAG = 0
#      CALL i002_show()
#      RETURN
#   END IF
#
#   DROP TABLE x
#
#   SELECT * FROM skk_file WHERE skk01=g_skk01 
#                            AND skk04=g_skk04 INTO TEMP x
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("sel","skk_file","","",SQLCA.sqlcode,"","",1)  
#      RETURN
#   END IF
#
#   UPDATE x SET skk01=l_newno1     #資料鍵值
#
#   INSERT INTO skk_file SELECT * FROM x
#
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("ins","skk_file","","",SQLCA.sqlcode,"","",0)     
#   ELSE
#      LET g_msg = l_newno1 CLIPPED
#      MESSAGE 'ROW(',g_msg,') O.K' 
#      LET l_oldno1 = g_skk01
#      LET g_skk01 = l_newno1
#      CALL i002_b()
#      LET g_skk01 = l_oldno1 
#      CALL i002_show()
#   END IF
#
#END FUNCTION
#   
#
#FUNCTION i002_out()
#DEFINE
#    l_i             LIKE type_file.num5,    
#    sr              RECORD
#        skk01       LIKE skk_file.skk01,    
#        gem02       LIKE gem_file.gem02,
#        skk04       LIKE skk_file.skk04,
#        skk02       LIKE skk_file.skk02, 
#        skk03       LIKE skk_file.skk03,
#        skk05       LIKE skk_file.skk05,
#        skk06       LIKE skk_file.skk06
#                    END RECORD,
#    l_name          LIKE type_file.chr20,   
#    l_za05          LIKE type_file.chr1000  
#
#    IF cl_null(g_wc) THEN
#       LET g_wc=" skk01='",g_skk01,"'"
#    END IF
#    IF g_wc IS NULL THEN
#       CALL cl_err('',-400,0)
#       RETURN
#    END IF
#    CALL cl_wait()
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'agli012'
#
#    LET g_sql= "SELECT skk01,gem02,skk04,skk02,skk03,skk05,skk06,skkacti ",
#               " FROM skk_file,gem_file ", 
#               " WHERE ",g_wc CLIPPED,
#               " AND gem01 = skk01 " 
#    PREPARE i002_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE i002_co                           # SCROLL CURSOR
#         CURSOR FOR i002_p1
#
##   CALL cl_outnam('i002') RETURNING l_name
#
##   START REPORT i002_rep TO l_name
#
##   FOREACH i002_co INTO sr.*
##       IF SQLCA.sqlcode THEN
##           CALL cl_err('foreach:',SQLCA.sqlcode,1)
##           EXIT FOREACH
##       END IF
##       OUTPUT TO REPORT i002_rep(sr.*)
##   END FOREACH
#
##   FINISH REPORT i002_rep
#
##   CLOSE i002_co
#
##   CALL cl_prt(l_name,' ','1',g_len)
#    #是否列印選擇條件
#    IF g_zz05 = 'Y' THEN                                                        
#      CALL cl_wcchp(g_wc,'skk01,skk04')
#           RETURNING g_wc                                                       
#    ELSE                                                                        
#      LET g_wc = ''                                                             
#    END IF                                                                      
#                                                                                
#   CALL cl_prt_cs1('aski002','aski002',g_sql,g_wc)
#END FUNCTION
#
#
#REPORT i002_rep(sr)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,    
#    sr              RECORD
#        skk01       LIKE skk_file.skk01,    
#        gem02       LIKE gem_file.gem02,
#        skk04       LIKE skk_file.skk04,
#        skk02       LIKE skk_file.skk02, 
#        skk03       LIKE skk_file.skk03,
#        skk05       LIKE skk_file.skk05,
#        skk06       LIKE skk_file.skk06
#                    END RECORD
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line    
#
#    ORDER BY sr.skk01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#
#        BEFORE GROUP OF sr.skk01 
#            PRINT COLUMN g_c[31],sr.skk01, 
#                  COLUMN g_c[32],sr.gem02,
#                  COLUMN g_c[33],sr.skk04;
#
#        ON EVERY ROW
#            PRINT COLUMN g_c[34],sr.skk02,
#                  COLUMN g_c[35],sr.skk03,
#                  COLUMN g_c[36],sr.skk05,
#                  COLUMN g_c[37],sr.skk06
#
#        AFTER  GROUP OF sr.skk01  
#              SKIP 1 LINE
#
#        ON LAST ROW
#            IF g_zz05 = 'Y'          
#               THEN PRINT g_dash[1,g_len]
#            CALL cl_prt_pos_wc(g_wc)
#            END IF
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-870117 
