# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: p_base_per.4gl
# Descriptions...: 畫面程式聯結定義作業
# Date & Author..: 04/05/06 alex
# Modify.........: No.FUN-530024 05/03/17 By alex 新增串接 p_feldhelp
# Modify.........: No.MOD-530267 05/03/25 By alex 改 q_zz to q_gaz
# Modify.........: No.MOD-530427 05/03/26 By alex 新增時沒有自動帶出作業名
# Modify.........: No.MOD-540163 05/04/29 By alex 修正 order by錯誤
# Modify.........: NO.MOD-580056 05/08/05 By yiting key可更改
# Modify.........: NO.MOD-590329 05/10/03 By yiting 針對zz13設定，假雙檔程式單身不做控管
# Modify.........: No.FUN-660081 06/06/14 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0080 06/10/23 By Czl g_no_ask改成g_no_ask
# Modify.........: No.FUN-6A0096 06/10/27 By johnray l_time改為g_time
# Modify.........: No.FUN-6A0092 06/11/17 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-6B0081 07/04/09 By pengu 隱藏"更改"action按鈕
# Modify.........: No.TQC-740075 07/04/13 By Xufeng "CLEAR FROM"應改為"CLEAR FORM"
# Modify.........: No.MOD-810259 08/01/30 By alex 增加客製選項於單身中,便於連結
# Modify.........: No.MOD-850273 08/05/28 By Sarah 在Informix環境,LockCusor的SQL指令不可有OUTER等複雜指令,改寫g_forupd_sql
# Modify.........: No.FUN-860033 08/06/06 By alex 修正 ON IDLE區段
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0145 09/10/28 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-BC0056 11/12/26 By jrg542 串接 p_perscrty
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_gax01          LIKE gax_file.gax01,   # 類別代號 (假單頭)
         g_gax01_t        LIKE gax_file.gax01,   # 類別代號 (假單頭)
         g_gaz03          LIKE gaz_file.gaz03,   # PER檔名稱
         g_zz011          LIKE zz_file.zz011,    # MOD-810259
         g_smb01          LIKE smb_file.smb01,   # MOD-810259
         g_smb03          LIKE smb_file.smb03,   # MOD-810259
         g_gax_lock RECORD LIKE gax_file.*,      # FOR LOCK CURSOR TOUCH
         g_gax    DYNAMIC ARRAY of RECORD        # 程式變數
            gax02          LIKE gax_file.gax02,
            gae04          LIKE gae_file.gae04,
            gax04          LIKE gax_file.gax04,  #MOD-810259
            gax05          LIKE gax_file.gax05,
            gax03          LIKE gax_file.gax03
                      END RECORD,
         g_gax_t           RECORD                 # 變數舊值
            gax02          LIKE gax_file.gax02,
            gae04          LIKE gae_file.gae04,
            gax04          LIKE gax_file.gax04,  #MOD-810259
            gax05          LIKE gax_file.gax05,
            gax03          LIKE gax_file.gax03
                      END RECORD,
         g_cnt2                LIKE type_file.num5,   #FUN-680135 SMALLINT
         g_wc                  string,  #No.FUN-580092 HCN
         g_sql                 string,  #No.FUN-580092 HCN
         g_ss                  LIKE type_file.chr1,   #FUN-680135  VARCHAR(1) # 決定後續步驟
         g_rec_b               LIKE type_file.num5,   # 單身筆數   #No.FUN-680135 SMALLINT
         l_ac                  LIKE type_file.num5    # 目前處理的ARRAY CNT   #No.FUN-680135 SMALLINT
DEFINE   g_chr                 LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
DEFINE   g_cnt                 LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE   g_msg                 STRING
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5   #No.FUN-680135 SMALLINT
DEFINE   g_argv1               LIKE gax_file.gax01
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   g_jump         LIKE type_file.num10,        #No.FUN-680135 INTEGER
         g_no_ask       LIKE type_file.num5          #No.FUN-680135 SMALLINT #No.FUN-6A0080
 
MAIN
 
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                # 擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_gax01_t = NULL
 
   OPEN WINDOW p_base_per_w WITH FORM "azz/42f/p_base_per"
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   LET g_forupd_sql = "SELECT * FROM gax_file  WHERE gax01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_base_per_lock_u CURSOR FROM g_forupd_sql
 
   IF NOT cl_null(g_argv1) THEN
      CALL p_base_per_q()
   END IF
 
   CALL p_base_per_menu() 
 
   CLOSE WINDOW p_base_per_w                       # 結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p_base_per_curs()                        # QBE 查詢資料
   CLEAR FORM                                    # 清除畫面
   CALL g_gax.clear()
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = "gax01 = '",g_argv1 CLIPPED,"' "
   ELSE
      CALL cl_set_head_visible("grid01","YES")       #No.FUN-6A0092
 
      CONSTRUCT g_wc ON gax01,gax02,gax04,gax05,gax03
                   FROM gax01,         s_gax[1].gax02,   #MOD-810259
                        s_gax[1].gax04,s_gax[1].gax05,s_gax[1].gax03
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(gax01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gaz"   #MOD-530267
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gax01
                  NEXT FIELD gax01
 
               OTHERWISE
                  EXIT CASE
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
 
   LET g_sql= "SELECT UNIQUE gax01 FROM gax_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY gax01"
   PREPARE p_base_per_prepare FROM g_sql          # 預備一下
   DECLARE p_base_per_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR p_base_per_prepare
 
   LET g_sql = "SELECT COUNT(DISTINCT gax01) FROM gax_file ",
               " WHERE ",g_wc CLIPPED
 
   PREPARE p_base_per_precount FROM g_sql
   DECLARE p_base_per_count CURSOR FOR p_base_per_precount
END FUNCTION
 
FUNCTION p_base_per_menu()
 
   WHILE TRUE
      CALL p_base_per_bp("G")
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL p_base_per_a()
            END IF
 
         WHEN "modify"                          # U.修改
            IF cl_chk_act_auth() THEN
               CALL p_base_per_u()
            END IF
 
#        WHEN "delete"                          # R.取消
#           IF cl_chk_act_auth() THEN
#              CALL p_base_per_r()
#           END IF
 
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL p_base_per_q()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_base_per_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "help"                            # H.求助
            CALL cl_show_help()
 
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
 
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
 
         WHEN "modify_per"
            IF cl_null(l_ac) OR l_ac = 0 THEN
               LET l_ac = 1
            END IF
            IF NOT cl_null(g_gax01) AND NOT cl_null(g_gax[l_ac].gax02) THEN
               LET g_msg='p_per "',g_gax[l_ac].gax02,'" "',g_gax[l_ac].gax05,'" "',g_smb01,'" '  
               CALL cl_cmdrun_wait(g_msg)
            END IF
 
         WHEN "modify_perlang"
            IF cl_null(l_ac) OR l_ac = 0 THEN
               LET l_ac = 1
            END IF
            IF NOT cl_null(g_gax01) AND NOT cl_null(g_gax[l_ac].gax02) THEN
               LET g_msg='p_perlang "',g_gax[l_ac].gax02,'" "',g_gax[l_ac].gax05,'" "',g_smb01,'" '  
               CALL cl_cmdrun_wait(g_msg)
            END IF
 
         WHEN "modify_perright"
            IF cl_null(l_ac) OR l_ac = 0 THEN
               LET l_ac = 1
            END IF
            IF NOT cl_null(g_gax01) AND NOT cl_null(g_gax[l_ac].gax02) THEN
               LET g_msg='p_perright "',g_gax[l_ac].gax02,'"'
               CALL cl_cmdrun_wait(g_msg)
            END IF
 
         WHEN "modify_helpfeld"
            IF cl_null(l_ac) OR l_ac = 0 THEN
               LET l_ac = 1
            END IF
            IF NOT cl_null(g_gax01) AND NOT cl_null(g_gax[l_ac].gax02) THEN
               LET g_msg='p_helpfeld "',g_gax[l_ac].gax02,'" "',g_gax[l_ac].gax05,'" "',g_smb01,'" ' 
               CALL cl_cmdrun_wait(g_msg)
            END IF
            
         #No.FUN-BC0056  --- stsrt ---  
         WHEN "modify_perscrty"     
            IF cl_null(l_ac) OR l_ac = 0 THEN
               LET l_ac = 1
            END IF
            IF NOT cl_null(g_gax01) AND NOT cl_null(g_gax[l_ac].gax02) THEN
               IF g_gax01 <> g_gax[l_ac].gax02 THEN 
                  CALL cl_err(g_gax01,'azz1179',1)
               ELSE  
                  LET g_msg='p_perscrty "',g_gax[l_ac].gax02,'" "',g_gax[l_ac].gax05,'" "',g_smb01,'" ' 
                  CALL cl_cmdrun_wait(g_msg) 
               END IF 
            END IF
            #No.FUN-BC0056  --- end ---
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_base_per_a()                            # Add  輸入
   MESSAGE ""
   CLEAR FORM
   CALL g_gax.clear()
 
   INITIALIZE g_gax01 LIKE gax_file.gax01         # 預設值及將數值類變數清成零
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL p_base_per_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET g_gax01=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
 
      IF g_ss='N' THEN
         CALL g_gax.clear()
      ELSE
         CALL p_base_per_b_fill('1=1')             # 單身
      END IF
 
      CALL p_base_per_b()                          # 輸入單身
      LET g_gax01_t=g_gax01
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p_base_per_i(p_cmd)                       # 處理INPUT
   DEFINE   p_cmd        LIKE type_file.chr1       # a:輸入 u:更改        #No.FUN-680135 VARCHAR(1)
 
   LET g_ss = 'Y'
   DISPLAY g_gax01 TO gax01
   CALL cl_set_head_visible("grid01","YES")       #No.FUN-6A0092
 
   INPUT g_gax01 WITHOUT DEFAULTS FROM gax01
 
    #NO.MOD-580056------
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL p_base_per_set_entry(p_cmd)
         CALL p_base_per_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
   #--------END
 
 
      AFTER FIELD gax01                         # 查詢程式代號
         IF NOT cl_null(g_gax01) THEN
            IF g_gax01 != g_gax01_t OR cl_null(g_gax01_t) THEN
               SELECT COUNT(UNIQUE gax01) INTO g_cnt FROM gax_file
                WHERE gax01 = g_gax01
               IF g_cnt > 0 THEN
                  IF p_cmd = 'a' THEN
                     LET g_ss = 'Y'
                  END IF
               ELSE
                  IF p_cmd = 'u' THEN
                     CALL cl_err(g_gax01,-239,0)
                     LET g_gax01 = g_gax01_t
                     NEXT FIELD gax01
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_gax01,g_errno,0)
                  NEXT FIELD gax01
               END IF
            END IF
 
#           #MOD-810259
            SELECT zz011 INTO g_zz011 FROM zz_file WHERE zz01=g_gax01
            CALL p_base_per_smb03(g_gax01) RETURNING g_smb01,g_smb03
            LET g_gaz03=cl_get_progname(g_gax01,g_lang) #MOD-540163
            DISPLAY g_gaz03,g_smb03,g_zz011 TO gaz03,smb03,zz011
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(gax01)
               CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gaz"    #MOD-530267
               LET g_qryparam.default1= g_gax01
               LET g_qryparam.arg1 = g_lang CLIPPED
               CALL cl_create_qry() RETURNING g_gax01
               NEXT FIELD gax01
 
            OTHERWISE 
               EXIT CASE
         END CASE
 
      ON ACTION controlf                  #欄位說明
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
 
 
FUNCTION p_base_per_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_gax01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_gax01_t = g_gax01
 
   BEGIN WORK
   OPEN p_base_per_lock_u USING g_gax01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE p_base_per_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   FETCH p_base_per_lock_u INTO g_gax_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("gax01 LOCK:",SQLCA.sqlcode,1)
      CLOSE p_base_per_lock_u
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      CALL p_base_per_i("u")
      IF INT_FLAG THEN
         LET g_gax01 = g_gax01_t
         DISPLAY g_gax01 TO gax01
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE gax_file SET gax01 = g_gax01
       WHERE gax01 = g_gax01_t
      IF SQLCA.sqlcode THEN
         #CALL cl_err(g_gax01,SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("upd","gax_file",g_gax01_t,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
 
FUNCTION p_base_per_q()                            #Query 查詢
   MESSAGE ""
  #CLEAR FROM  #No.TQC-740075
   CLEAR FORM  #No.TQC-740075
   CALL g_gax.clear()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   DISPLAY '' TO FORMONLY.cnt
   CALL p_base_per_curs()                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN p_base_per_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_gax01 TO NULL
   ELSE
      CALL p_base_per_fetch('F')                 #讀出TEMP第一筆並顯示
      OPEN p_base_per_count
      FETCH p_base_per_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
FUNCTION p_base_per_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1,          #處理方式        #No.FUN-680135 VARCHAR(1) 
            l_abso   LIKE type_file.num10          #絕對的筆數      #No.FUN-680135 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_base_per_b_curs INTO g_gax01
      WHEN 'P' FETCH PREVIOUS p_base_per_b_curs INTO g_gax01
      WHEN 'F' FETCH FIRST    p_base_per_b_curs INTO g_gax01
      WHEN 'L' FETCH LAST     p_base_per_b_curs INTO g_gax01
      WHEN '/' 
         IF (NOT g_no_ask) THEN           #No.FUN-6A0080
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
 
            PROMPT g_msg CLIPPED,': ' FOR g_jump
 
               ON IDLE g_idle_seconds  #FUN-860033
                  CALL cl_on_idle()
          
               ON ACTION about         #MOD-4C0121
                  CALL cl_about()      #MOD-4C0121
          
               ON ACTION controlg      #MOD-4C0121
                  CALL cl_cmdask()     #MOD-4C0121
          
               ON ACTION help          #MOD-4C0121
                  CALL cl_show_help()  #MOD-4C0121
            END PROMPT
 
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
       FETCH ABSOLUTE g_jump p_base_per_b_curs INTO g_gax01
       LET g_no_ask = FALSE                #No.FUN-6A0080
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gax01,SQLCA.sqlcode,0)
      INITIALIZE g_gax01 TO NULL  #TQC-6B0105
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL p_base_per_show()
   END IF
END FUNCTION
 
FUNCTION p_base_per_show()                         # 將資料顯示在畫面上
 
#MOD-810259
   SELECT zz011 INTO g_zz011 FROM zz_file WHERE zz01=g_gax01
   CALL p_base_per_smb03(g_gax01) RETURNING g_smb01,g_smb03
   LET g_gaz03=cl_get_progname(g_gax01,g_lang)
 
   DISPLAY g_gax01,g_gaz03,g_smb03,g_zz011 TO gax01,gaz03,smb03,zz011
   CALL p_base_per_b_fill(g_wc)                    # 單身
 
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION p_base_per_r()        # 取消整筆 (所有合乎單頭的資料)
   DEFINE   l_cnt   LIKE type_file.num5,          #No.FUN-680135 SMALLINT
            l_gax   RECORD LIKE gax_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_gax01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM gax_file WHERE gax01 = g_gax01
      IF SQLCA.sqlcode THEN
         #CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("del","gax_file",g_gax01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
      ELSE
         CLEAR FORM
         CALL g_gax.clear()
         LET g_cnt = SQLCA.SQLERRD[3]
         OPEN p_base_per_count
         FETCH p_base_per_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count 
            CALL p_base_per_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE           #No.FUN-6A0080
            CALL p_base_per_fetch('/')
         END IF
        # LET g_cnt2 = g_cnt2 -1
        # DISPLAY g_cnt2 TO FORMONLY.cnt
        # MESSAGE 'Remove (',g_cnt2 USING '####&',') Row(s)'
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION p_base_per_b()                            # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,               # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
            l_n             LIKE type_file.num5,               # 檢查重複用        #No.FUN-680135 SMALLINT
            l_gau01         LIKE type_file.num5,               # 檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,               # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,               # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,               #No.FUN-680135 SMALLINT 
            l_allow_delete  LIKE type_file.num5                #No.FUN-680135 SMALLINT
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_gax01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
  #str MOD-850273 mod
  #在Informix環境,LockCusor的SQL指令不可有OUTER等複雜指令,改寫下面的SQL
  #LET g_forupd_sql= "SELECT gax02,gae04,gax04,gax05,gax03 ",  #MOD-810259
  #                   " FROM gax_file ,OUTER gae_file ",
  #                  "  WHERE gax01 = ? AND gax02 = ? ",
  #                    " AND gae_file.gae01=gax_file.gax02 AND gae_file.gae02='wintitle' ",
  #                    " AND gae_file.gae11=gax_file.gax05 ",
  #                    " AND gae_file.gae03= ? ",
  #                    " FOR UPDATE "
   LET g_forupd_sql= "SELECT gax02,' ',gax04,gax05,gax03 ",  #MOD-810259
                      " FROM gax_file ",
                     "  WHERE gax01 = ? AND gax02 = ? ",
                       " FOR UPDATE "
  #end MOD-850273 mod
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_base_per_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
   LET l_ac_t = 0
 
   INPUT ARRAY g_gax WITHOUT DEFAULTS FROM s_gax.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         LET g_before_input_done = TRUE
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_gax_t.* = g_gax[l_ac].*    #BACKUP
#NO.MOD-590329 MARK-------------------------
 #No.MOD-580056 --start
#           LET g_before_input_done = FALSE
#           CALL p_base_per_set_entry_b(p_cmd)
#           CALL p_base_per_set_no_entry_b(p_cmd)
#           LET g_before_input_done = TRUE
 #No.MOD-580056 --end
#NO.MOD-590329 MARK------------------------
           #OPEN p_base_per_bcl USING g_gax01,g_gax_t.gax02,g_lang   #MOD-850273 mark
            OPEN p_base_per_bcl USING g_gax01,g_gax_t.gax02          #MOD-850273
            IF SQLCA.sqlcode THEN 
               CALL cl_err("OPEN p_base_per_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
              #FETCH p_base_per_bcl INTO g_gax[l_ac].*   #MOD-850273 mark
               FETCH p_base_per_bcl INTO g_gax_t.*       #MOD-850273
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_base_per_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
                ELSE    #MOD-530427
                  SELECT gae04 INTO g_gax[l_ac].gae04 FROM gae_file
                   WHERE gae01=g_gax01 
                     AND gae02=g_gax[l_ac].gax02 AND gae03=g_lang
                  IF cl_null(g_gax[l_ac].gae04) AND g_gax[l_ac].gax02=g_gax01 THEN
                     LET g_gax[l_ac].gae04=g_gaz03
                     DISPLAY BY NAME g_gax[l_ac].gae04   #MOD-850273 add
                  END IF
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gax[l_ac].* TO NULL       #900423
         LET g_gax[l_ac].gax04="Y"              #MOD-530427
         LET g_gax[l_ac].gax05="Y"              #MOD-810259
         LET g_gax[l_ac].gax03="Y"              #MOD-530427
         LET g_gax_t.* = g_gax[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gax02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO gax_file (gax01,gax02,gax03,gax04,gax05)
              VALUES (g_gax01,
                      g_gax[l_ac].gax02,g_gax[l_ac].gax03,g_gax[l_ac].gax04,
                      g_gax[l_ac].gax05)    #MOD-810259
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_gax01,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","gax_file",g_gax01,g_gax[l_ac].gax02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD gax02
          #MOD-530427
         IF NOT cl_null(g_gax[l_ac].gax02) THEN
            SELECT gae04 INTO g_gax[l_ac].gae04 FROM gae_file
             WHERE gae01=g_gax[l_ac].gax02 AND gae02='wintitle'
               AND gae03=g_lang ORDER BY gae11
            IF cl_null(g_gax[l_ac].gae04) AND g_gax[l_ac].gax02=g_gax01 THEN
               LET g_gax[l_ac].gae04=g_gaz03
               DISPLAY BY NAME g_gax[l_ac].gae04   #MOD-850273 add
            END IF
         END IF
         IF g_gax[l_ac].gax02 != g_gax_t.gax02 OR g_gax_t.gax02 IS NULL THEN
            # 檢視 gax_file 中同一 Program Name (gax01) 下是否有相同的
            # Filed Name (gax02)
            SELECT COUNT(*) INTO l_n FROM gax_file
             WHERE gax01 = g_gax01 AND gax02 = g_gax[l_ac].gax02
            IF l_n > 0 THEN
               CALL cl_err(g_gax[l_ac].gax02,-239,0)
               LET g_gax[l_ac].gax02 = g_gax_t.gax02
               NEXT FIELD gax02
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_gax_t.gax02) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            IF l_gau01 > 0 THEN  #當刪除為主鍵的其中一筆資料時
               CALL cl_err("Deleting One of Several Primary Keys!","!",1)
            END IF
            DELETE FROM gax_file WHERE gax01 = g_gax01
                                   AND gax02 = g_gax[l_ac].gax02
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gax_t.gax02,SQLCA.sqlcode,0)
               CALL cl_err3("del","gax_file",g_gax01,g_gax_t.gax02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gax[l_ac].* = g_gax_t.*
            CLOSE p_base_per_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_gau01 > 0 THEN
            CALL cl_err("Primary Key CHANGING!","!",1)
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gax[l_ac].gax02,-263,1)
            LET g_gax[l_ac].* = g_gax_t.*
         ELSE
            UPDATE gax_file
               SET gax02 = g_gax[l_ac].gax02,
                   gax03 = g_gax[l_ac].gax03,
                   gax04 = g_gax[l_ac].gax04,
                   gax05 = g_gax[l_ac].gax05    #MOD-810259
             WHERE gax01 = g_gax01
               AND gax02 = g_gax_t.gax02
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gax[l_ac].gax02,SQLCA.sqlcode,0) #No.FUN-660081
               CALL cl_err3("upd","gax_file",g_gax01,g_gax_t.gax02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_gax[l_ac].* = g_gax_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30034 mark
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gax[l_ac].* = g_gax_t.*
              #str MOD-850273 add
               SELECT gae04 INTO g_gax[l_ac].gae04 FROM gae_file
                WHERE gae01=g_gax[l_ac].gax02 AND gae02='wintitle'
                  AND gae03=g_lang ORDER BY gae11
               IF cl_null(g_gax[l_ac].gae04) AND g_gax[l_ac].gax02=g_gax01 THEN
                  LET g_gax[l_ac].gae04=g_gaz03
                  DISPLAY BY NAME g_gax[l_ac].gae04
               END IF
              #end MOD-850273 add
            #FUN-D30034--add--begin--
            ELSE
               CALL g_gax.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE p_base_per_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30034 add
         CLOSE p_base_per_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(gax02) AND l_ac > 1 THEN
            LET g_gax[l_ac].* = g_gax[l_ac-1].*
            NEXT FIELD gax02
         END IF
 
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
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
  
      ON ACTION controls                             #No.FUN-6A0092                                                                       
         CALL cl_set_head_visible("grid01","AUTO")   #No.FUN-6A0092 
 
   END INPUT
   CLOSE p_base_per_bcl
   COMMIT WORK
END FUNCTION
 
 
FUNCTION p_base_per_b_fill(p_wc)              #BODY FILL UP
   DEFINE p_wc         LIKE type_file.chr1000 #No.FUN-680135  VARCHAR(300)
   DEFINE p_ac         LIKE type_file.num5    #FUN-680135 SMALLINT
 
    #No.TQC-9A0145  --Begin
    #LET g_sql = "SELECT gax02,gae04,gax03,gax04 ",  
    #             " FROM gax_file LEFT OUTER JOIN gae_file",  
    #                             " ON gae_file.gae01=gax_file.gax02 ",  
    #                            " AND gae_file.gae02='wintitle' ",  
    #                            " AND gae_file.gae03='",g_lang CLIPPED,"' ",  
    #            " WHERE gax01= '",g_gax01 CLIPPED,"' ",  
    #              " AND ",p_wc CLIPPED,  
    #            " ORDER BY gax02"
    LET g_sql = "SELECT gax02,gae04,gax04,gax05,gax03 ",                        
                 " FROM gax_file LEFT OUTER JOIN gae_file",                              
                 "               ON  gae_file.gae01=gax_file.gax02 ",                        
                 "               AND gae_file.gae01=gax_file.gax05 ",                        
                 "               AND gae_file.gae02='wintitle' ",                            
                 "               AND gae_file.gae03='",g_lang CLIPPED,"' ",                  
                " WHERE gax01= '",g_gax01 CLIPPED,"' ",                         
                  " AND ",p_wc CLIPPED,                                         
                " ORDER BY gax02"                
    #No.TQC-9A0145  --End  
 
    PREPARE p_base_per_prepare2 FROM g_sql           #預備一下
    DECLARE gax_curs CURSOR FOR p_base_per_prepare2
 
    CALL g_gax.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH gax_curs INTO g_gax[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       # 2004/05/18 如果gae04是空的,gax02同gax01,則填入 gae04=g_gaz03
       IF (g_gax[g_cnt].gae04 IS NULL OR g_gax[g_cnt].gae04=" ")
          AND g_gax[g_cnt].gax02=g_gax01 THEN
          LET g_gax[g_cnt].gae04=g_gaz03
       END IF
 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_gax.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p_base_per_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gax TO s_gax.* ATTRIBUTE(UNBUFFERED)
      BEFORE DISPLAY
         # 2004/01/17 by Hiko : 上下筆資料的ToolBar控制.
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
 
     #----------No.TQC-6B0081 mark
     #ON ACTION modify
     #   LET g_action_choice="modify"
     #   EXIT DISPLAY
     #----------No.TQC-6B0081 end
 
#     ON ACTION delete                           # R.取消
#        LET g_action_choice="delete"
#        EXIT DISPLAY
 
      ON ACTION detail                           # B.單身
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first                            # 第一筆
         CALL p_base_per_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous                         # P.上筆
         CALL p_base_per_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump                             # 指定筆
         LET g_no_ask = FALSE           #No.FUN-6A0080
         CALL p_base_per_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION next                             # N.下筆
         CALL p_base_per_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last                             # 最終筆
         CALL p_base_per_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION modify_per
         LET g_action_choice="modify_per"
         EXIT DISPLAY
 
      ON ACTION modify_perlang
         LET g_action_choice="modify_perlang"
         EXIT DISPLAY
 
      ON ACTION modify_perright
         LET g_action_choice="modify_perright"
         EXIT DISPLAY
 
#     #FUN-530024
      ON ACTION modify_helpfeld
         LET g_action_choice="modify_helpfeld"
         EXIT DISPLAY

      ON ACTION modify_perscrty                  #FUN-BC0056
         LET g_action_choice="modify_perscrty"
         EXIT DISPLAY
         
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                             #No.FUN-6A0092                                                                       
         CALL cl_set_head_visible("grid01","AUTO")   #No.FUN-6A0092 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 #No.MOD-580056 --start
FUNCTION p_base_per_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("gax01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION p_base_per_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("gax01",FALSE)
   END IF
 
END FUNCTION
 
#NO.MOD-590329 MARK------------------------
#FUNCTION p_base_per_set_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
#     CALL cl_set_comp_entry("gax02",TRUE)
#   END IF
 
#END FUNCTION
 
#FUNCTION p_base_per_set_no_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
#     CALL cl_set_comp_entry("gax02",FALSE)
#   END IF
 
#END FUNCTION
 
 
FUNCTION p_base_per_smb03(lc_zz01)    #MOD-810259
 
   DEFINE lc_zz01     LIKE zz_file.zz01
   DEFINE ls_zz01     STRING
   DEFINE lc_zz01n    LIKE zz_file.zz01
   DEFINE lc_smb03    LIKE smb_file.smb03
   DEFINE li_i        LIKE type_file.num5
 
   LET ls_zz01=DOWNSHIFT(lc_zz01 CLIPPED)
   IF NOT ls_zz01.getIndexOf("_",1) THEN
      SELECT smb03 INTO lc_smb03 FROM smb_file WHERE smb01='std' AND smb02=g_lang
      RETURN 'std',lc_smb03 CLIPPED
   END IF
   WHILE TRUE
      LET li_i=ls_zz01.getIndexOf("_",1)
      IF NOT li_i THEN EXIT WHILE END IF
      LET ls_zz01=ls_zz01.subString(li_i+1,ls_zz01.getLength())
   END WHILE
   LET lc_zz01n=ls_zz01.trim()
   SELECT COUNT(*) INTO li_i FROM smb_file WHERE smb01=lc_zz01n
   IF NOT li_i THEN
      LET lc_zz01n='std'
   END IF
   SELECT smb03 INTO lc_smb03 FROM smb_file WHERE smb01=lc_zz01n AND smb02=g_lang
   RETURN lc_zz01n CLIPPED,lc_smb03 CLIPPED
 
END FUNCTION
 
