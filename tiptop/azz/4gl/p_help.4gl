# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: p_help.4gl
# Descriptions...: 使用者求助文件預覽作業
# Date & Author..: 04/04/02 alex
# Modify.........: No.FUN-4C0104 05/01/05 By alex 修改 4js bug 定義超長
# Modify.........: No.MOD-510166 05/01/27 By mandy 預覽的"作業目的"沒有show出內容
# Modify.........: No.FUN-520004 05/02/02 By alex 刪除群組被顯示, 修整客製碼相關資料
# Modify.........: No.FUN-520023 05/02/25 By alex 將 za 資料移至 ze_file
# Modify.........: No.MOD-530040 05/03/04 By alex 調整客製區 preview path
# Modify.........: No.FUN-530024 05/03/17 By alex 調整串接 p_helpfeld -> p_base_per
# Modify.........: No.MOD-540072 05/04/12 By alex 增加 -400 錯誤訊息顯示
# Modify.........: No.MOD-540140 05/04/20 By alex 刪除 HELP FILE
# Modify.........: No.MOD-540163 05/04/29 By alex 修改 order by 錯誤
# Modify.........: No.TQC-590032 05/10/17 By alex ag保持,C預抓C,若空則尋p資料(效能改善)
# Modify.........: No.FUN-660081 06/06/14 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0080 06/10/23 By Czl g_no_ask改成g_no_ask
# Modify.........: No.FUN-6A0096 06/10/27 By czl l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750068 07/07/05 By saki 行業別功能加入
# Modify.........: NO.FUN-7B0081 08/01/10 By alex 將gae06移至gbs07
# Modify.........: No.TQC-860017 08/06/06 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10130 10/01/15 By Carrier HIDE OPTION失效
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_help           RECORD
         gaz01           LIKE gaz_file.gaz01,
         gaz03           LIKE gaz_file.gaz03,
         gaz02           LIKE gaz_file.gaz02,
         gaz05           LIKE gaz_file.gaz05 #MOD-510166
                  END RECORD,
       g_help_t         RECORD 
         gaz01           LIKE gaz_file.gaz01,
         gaz03           LIKE gaz_file.gaz03,
         gaz02           LIKE gaz_file.gaz02,
         gaz05           LIKE gaz_file.gaz05 #MOD-510166
                  END RECORD,
       g_help01_t     LIKE gaz_file.gaz01
 
DEFINE g_txtedit      STRING,
       g_wc           STRING,
       g_sql          STRING,
       p_row,p_col    LIKE type_file.num5          #No.FUN-680135 SMALLINT 
DEFINE g_forupd_sql   STRING           #SELECT ... FOR UPDATE SQL
DEFINE g_cnt          LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE g_msg          STRING
DEFINE g_argv1        LIKE gaz_file.gaz01
DEFINE g_showflag     LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE g_jump         LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE g_no_ask       LIKE type_file.num5          #No.FUN-680135 SMALLINT #No.FUN-6A0080
DEFINE g_db_type      LIKE type_file.chr3          #No.FUN-750068
DEFINE g_gae12        DYNAMIC ARRAY OF LIKE gae_file.gae12  #No.FUN-750068
 
MAIN
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
   INITIALIZE g_help.* TO NULL
   INITIALIZE g_help_t.* TO NULL
 
   LET g_txtedit = ""
   LET g_showflag = "Y"
 
#  #TQC-590032
   LET g_sql=" SELECT gae04 FROM gae_file ",
              " WHERE gae01=? AND gae11=? AND gae02=? AND gae03=? AND gae12=? "  #No.FUN-750068
   PREPARE p_help_gae04_pre FROM g_sql
 
#  LET g_sql=" SELECT gae06 FROM gae_file ",    #FUN-7B0081
#             " WHERE gae01=? AND gae11=? AND gae02=? AND gae03=? AND gae12=? "  #No.FUN-750068
#  PREPARE p_help_gae06_pre FROM g_sql
 
   LET p_row = 1 LET p_col = 8
   OPEN WINDOW p_help_w AT p_row,p_col WITH FORM "azz/42f/p_help"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   CALL cl_set_combo_lang("gaz02")
 
   IF NOT cl_null(g_argv1) THEN
      # 2004/04/28 因為 p_help 本身沒有 insert 新增功能 故在此處開後門
      #            如果傳入值未曾在 p_purpose 中建立資料  則在此先安插
      #            一筆當下語言別的資料
      CALL p_help_check_default(g_argv1)
      CALL p_help_q()
   END IF
 
   CALL p_help_menu()  
 
   CLOSE WINDOW p_help_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
 
END MAIN
 
# 確認傳入值是否已建立資料  若無則塞一筆當下語言別的值令其開得出來
FUNCTION p_help_check_default(lc_gaz01)
 
   DEFINE lc_gaz01   LIKE gaz_file.gaz01
   DEFINE li_gaz01   LIKE type_file.num5     #FUN-680135 SMALLINT
 
   LET li_gaz01 = 0
   SELECT COUNT(*) INTO li_gaz01 FROM gaz_file
    WHERE gaz01=lc_gaz01 AND gaz02=g_lang
    ORDER BY gaz05
 
   IF li_gaz01 <= 0 THEN
      IF cl_confirm("azz-030") THEN
         INSERT INTO gaz_file (gaz01,gaz02,gazoriu,gazorig) VALUES (lc_gaz01,g_lang, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
      END IF
   END IF
   RETURN
 
END FUNCTION
 
FUNCTION p_help_curs()
 
   DEFINE ls_return   STRING
   DEFINE li_index    LIKE type_file.num5     #FUN-680135 SMALLINT
   DEFINE l_cnt       LIKE type_file.num10    #FUN-680135 INTEGER
   DEFINE l_gaz01     LIKE gaz_file.gaz01     #FUN-680135 VARCHAR(20)
   LET g_txtedit = ""
   CLEAR FORM
 
   IF cl_null(g_argv1) THEN
      CONSTRUCT BY NAME g_wc ON gaz01,gaz02
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(gaz01)
                  CALL cl_init_qry_var()       
                  LET g_qryparam.form = "q_gaz"
                  LET g_qryparam.default1= g_help.gaz01
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING ls_return
                  DISPLAY ls_return TO gaz01
                  NEXT FIELD gaz01
            END CASE
#TQC-860017 start
            ON ACTION about
               CALL cl_about()
 
            ON ACTION controlg
               CALL cl_cmdask()
 
            ON ACTION help
               CALL cl_show_help()
 
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
              CONTINUE CONSTRUCT
#TQC-860017 end          
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gazuser', 'gazgrup') #FUN-980030
 
      # 若 USER 未指定查詢語系, 則給予限定在目前語系中
      IF NOT cl_null(g_wc) THEN
         CALL g_wc.getIndexOf("gaz02",1) RETURNING li_index
         IF li_index = 0 THEN
            LET g_wc = g_wc.trim()," AND gaz02='",g_lang CLIPPED,"' "
         END IF
      END IF
      LET l_gaz01 = ls_return
   ELSE
      LET g_wc = " gaz01='",g_argv1 CLIPPED,"' AND gaz02='",g_lang CLIPPED,"' "
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM gaz_file
    WHERE gaz01= g_argv1 AND gaz02=g_lang 
 
 #  IF l_cnt > 1 THEN                # 組合出 SQL 指令 #MOD-510166 add gaz05
       LET g_sql=" SELECT UNIQUE gaz01,gaz02,gaz05 FROM gaz_file,zz_file ",
                  " WHERE ",g_wc CLIPPED," AND gaz01=zz01 ",
                  " ORDER BY gaz01, gaz05 DESC "
#  ELSE
 #                                   # 組合出 SQL 指令 #MOD-510166 add gaz05
#      LET g_sql=" SELECT gaz01,gaz02,gaz05 FROM gaz_file,zz_file ",
#                 " WHERE ",g_wc CLIPPED, " AND gaz05='N' ",
#                   " AND gaz01=zz01 ",
#                 " ORDER BY gaz01"
#  END IF
 
   PREPARE p_help_prepare FROM g_sql           # RUNTIME 編譯
   DECLARE p_help_curs                         # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR p_help_prepare
   IF l_cnt > 1 THEN
     LET g_sql= "SELECT COUNT(*) FROM gaz_file,zz_file ",
                " WHERE ",g_wc CLIPPED,"AND gaz05='Y' AND gaz01=zz01 "
   ELSE
     LET g_sql= "SELECT COUNT(*) FROM gaz_file,zz_file ",
                " WHERE ",g_wc CLIPPED,"AND gaz05='N' AND gaz01=zz01 "
   END IF
   PREPARE p_help_precount FROM g_sql
   DECLARE p_help_count CURSOR FOR p_help_precount
 
END FUNCTION
 
FUNCTION p_help_menu()
   DEFINE lc_module   LIKE zz_file.zz011   #模組定義檔模組名稱標準長度
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        #更改作業目的
        ON ACTION modify_purpose
            LET g_action_choice="modify_purpose" 
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_help.gaz01) THEN 
                  LET g_msg = "p_purpose '",g_help.gaz01 CLIPPED,"'"
                  CALL cl_cmdrun_wait(g_msg)
               ELSE
                   CALL cl_err('',-400,0)       #MOD-540072
               END IF
            END IF
 
        #更改作業特色
        ON ACTION modify_feature
            LET g_action_choice="modify_feature"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_help.gaz01) THEN 
                  LET g_msg = "p_feature '",g_help.gaz01 CLIPPED,"'"
                  CALL cl_cmdrun_wait(g_msg)
               ELSE
                   CALL cl_err('',-400,0)       #MOD-540072
               END IF
            END IF
 
        #維護 Action 說明
        ON ACTION modify_action_help
            LET g_action_choice="modify_action_help"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_help.gaz01) THEN 
                  LET g_msg = "p_base_act '",g_help.gaz01 CLIPPED,"'"
                  CALL cl_cmdrun_wait(g_msg)
               ELSE
                   CALL cl_err('',-400,0)      #MOD-540072
               END IF
            END IF
 
        #更改欄位說明
        ON ACTION modify_field_help
            LET g_action_choice="modify_field_help"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_help.gaz01) THEN 
#                 #FUN-530024
#                 LET g_msg = "p_helpfeld '",g_help.gaz01 CLIPPED,"'",
#                                       " '",g_help.gaz02 CLIPPED,"'"
                  LET g_msg = "p_base_per '",g_help.gaz01 CLIPPED,"'"
                  CALL cl_cmdrun_wait(g_msg)
               ELSE
                   CALL cl_err('',-400,0)       #MOD-540072
               END IF
            END IF
 
        #產生HTML格式文件
        ON ACTION gen_help_html
            LET g_action_choice="gen_help_html" 
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_help.gaz01) THEN
                  LET g_msg = "p_help_htm '",g_help.gaz01 CLIPPED,"' '",
                                             g_help.gaz02 CLIPPED,"'"
                  CALL cl_cmdrun_wait(g_msg)
                  CALL cl_err('','afa-116',1) #作業完成
               ELSE
                   CALL cl_err('',-400,0)      #MOD-540072
               END IF
            END IF
 
        #瀏覽HTML格式文件
        ON ACTION run_help_html
            LET g_action_choice="run_help_html"
            IF NOT cl_null(g_help.gaz01) THEN
                SELECT zz011 INTO lc_module FROM zz_file 
                 WHERE zz01=g_help.gaz01
                IF cl_null(g_help.gaz01) THEN
                   LET lc_module="azz"
                ELSE
                   LET lc_module=DOWNSHIFT(lc_module)
                END IF   
                CALL p_help_preview(lc_module)
            ELSE
                 CALL cl_err('',-400,0)       #MOD-540072
            END IF   
 
        ON ACTION query                          #"Q.查詢" HELP 32002
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN 
               CALL p_help_q() 
            END IF
 
        ON ACTION first                          #KEY(F)
            CALL p_help_fetch('F')
 
        ON ACTION previous                       #"P.上筆" HELP 32004
            CALL p_help_fetch('P')
 
        ON ACTION jump                           #KEY('/')
            CALL p_help_fetch('/')
 
        ON ACTION next                           #"N.下筆" HELP 32003
            CALL p_help_fetch('N') 
 
        ON ACTION last                           #KEY(L)
            CALL p_help_fetch('L')
 
        ON ACTION help                           #"H.說明" HELP 10102
            CALL cl_show_help()
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        ON ACTION exit                           #"Esc.結束"
           LET g_action_choice="exit"
           EXIT MENU
 
        ON ACTION controlg                       #KEY(CONTROL-G)
           CALL cl_cmdask()
 
        ON ACTION show_help
           IF g_showflag = "Y" THEN
              LET g_showflag = "N"
           ELSE
              LET g_showflag = "Y"
           END IF 
           DISPLAY g_showflag TO showflag
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
    END MENU
    CLOSE p_help_curs
END FUNCTION
 
 
FUNCTION p_help_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
 
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL p_help_curs()                          # 宣告 SCROLL CURSOR
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      RETURN
   END IF
 
   OPEN p_help_count
   FETCH p_help_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
 
   OPEN p_help_curs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_help.gaz01,SQLCA.sqlcode,0)
      INITIALIZE g_help.* TO NULL
      LET g_txtedit = ""
   ELSE
      CALL p_help_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION p_help_fetch(p_flgaz)
   DEFINE
       p_flgaz         LIKE type_file.chr1,         #FUN-680135 VARCHAR(1)
       l_abso          LIKE type_file.num10         #No.FUN-680135 INTEGER
 
   CASE p_flgaz
       WHEN 'N' FETCH NEXT     p_help_curs INTO g_help.gaz01,g_help.gaz02,g_help.gaz05 #MOD-510166
       WHEN 'P' FETCH PREVIOUS p_help_curs INTO g_help.gaz01,g_help.gaz02,g_help.gaz05 #MOD-510166
       WHEN 'F' FETCH FIRST    p_help_curs INTO g_help.gaz01,g_help.gaz02,g_help.gaz05 #MOD-510166
       WHEN 'L' FETCH LAST     p_help_curs INTO g_help.gaz01,g_help.gaz02,g_help.gaz05 #MOD-510166
      WHEN '/'
         IF (NOT g_no_ask) THEN          #No.FUN-6A0080
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
 
            PROMPT g_msg.trim(),': ' FOR g_jump
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
          FETCH ABSOLUTE g_jump p_help_curs INTO g_help.gaz01,g_help.gaz02,g_help.gaz05 #MOD-510166
         LET g_no_ask = FALSE        #No.FUN-6A0080
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_help.gaz01,SQLCA.sqlcode,0)
      INITIALIZE g_help.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE p_flgaz
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting(g_curs_index, g_row_count)
   END IF
 
    SELECT gaz01,gaz03,gaz02,gaz05 #MOD-510166
     INTO g_help.*
     FROM gaz_file 
    WHERE gaz01=g_help.gaz01 AND gaz02=g_help.gaz02 AND gaz05=g_help.gaz05 
 
   IF SQLCA.sqlcode THEN
      #CALL cl_err(g_help.gaz01,SQLCA.sqlcode,0)
      CALL cl_err3("sel","gaz_file",g_help.gaz01,g_help.gaz02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
   ELSE
      # 2004/05/10 要清除 g_txtedit 然後依照 g_showflag 決定是否要組 html
      LET g_txtedit=""
      IF g_showflag = "Y" THEN
         CALL p_help_compose()
      END IF
 
      CALL p_help_show()                      # 重新顯示
   END IF
 
END FUNCTION
 
FUNCTION p_help_show()
 
   LET g_help_t.* = g_help.*
 
   DISPLAY g_help.gaz01,g_help.gaz03,g_help.gaz02,g_txtedit,g_showflag
        TO gaz01,gaz03,gaz02,txthelp,showflag
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
 
FUNCTION p_help_compose()
 
   DEFINE l_x            ARRAY[10] OF LIKE type_file.chr50    #FUN-680135 ARRAY[10] OF VARCHAR(40)
#  DEFINE l_za05         LIKE za_file.za05
   DEFINE l_i            LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE l_gaz01        LIKE gaz_file.gaz01
   DEFINE l_gaz03        LIKE gaz_file.gaz03
   DEFINE l_gaz04        LIKE gaz_file.gaz04 
   DEFINE ls_tmpstring   STRING
 
#   DECLARE p_help_za_cur CURSOR FOR
#           SELECT za02,za05 FROM za_file
#            WHERE za01 = "p_help" AND za03 = g_help.gaz02
#   FOREACH p_help_za_cur INTO l_i,l_za05
#         LET l_x[l_i] = l_za05
#   END FOREACH
#  FUN-520023
   LET l_x[01]=cl_getmsg("azz-092",g_lang)
   LET l_x[02]=cl_getmsg("azz-093",g_lang)
   LET l_x[03]=cl_getmsg("azz-094",g_lang)
   LET l_x[04]=cl_getmsg("azz-095",g_lang)
   LET l_x[05]=cl_getmsg("azz-096",g_lang)
   LET l_x[06]=cl_getmsg("azz-097",g_lang)
   LET l_x[07]=cl_getmsg("azz-098",g_lang)
   LET l_x[08]=cl_getmsg("azz-099",g_lang)
   LET l_x[09]=cl_getmsg("azz-104",g_lang)
 
   LET g_txtedit="\n"
 
   #系統名稱
   LET g_txtedit=g_txtedit,l_x[01] CLIPPED,"\n"
   CALL p_help_get_module() RETURNING l_gaz01,l_gaz03
   LET g_txtedit=g_txtedit,"     ",l_gaz01 CLIPPED,"  ",l_gaz03 CLIPPED,"\n\n"
 
   #程式名稱
   LET g_txtedit=g_txtedit,l_x[02] CLIPPED,"\n"
 #  #MOD-540163
   CALL cl_get_progname(g_help.gaz01,g_help.gaz02) RETURNING l_gaz03
#  CALL p_help_get_prog() RETURNING l_gaz03
   LET g_txtedit=g_txtedit,"     ",g_help.gaz01 CLIPPED,"  ",l_gaz03 CLIPPED,"\n\n"
 
   #作業目的
   LET g_txtedit=g_txtedit,l_x[03] CLIPPED,"\n"
#  CALL p_help_get_purpose() RETURNING l_gaz03
#  CALL s_aligntxt_left(l_gaz03,5) RETURNING l_gaz03
#  LET g_txtedit=g_txtedit,l_gaz03,"\n\n"
   CALL p_help_get_purpose() RETURNING l_gaz04
   LET g_txtedit=g_txtedit,l_gaz04,"\n\n"
 
   #作業特點
   CALL p_help_get_feature() RETURNING ls_tmpstring
   IF NOT cl_null(ls_tmpstring) THEN
       LET g_txtedit=g_txtedit,l_x[04] CLIPPED,"\n"
       LET g_txtedit=g_txtedit,ls_tmpstring,"\n\n"
   END IF
 
   #操作功能
   LET g_txtedit=g_txtedit,l_x[05] CLIPPED,"\n"
   CALL p_help_get_action_memo() RETURNING ls_tmpstring
   LET g_txtedit=g_txtedit,ls_tmpstring,"\n\n"
 
   #欄位說明
   LET g_txtedit=g_txtedit,l_x[06] CLIPPED,"\n"
   CALL p_help_get_field_memo(l_gaz03) RETURNING ls_tmpstring
   LET g_txtedit=g_txtedit,ls_tmpstring,"\n\n"
 
 
END FUNCTION
 
 
FUNCTION p_help_get_module()  #取得模組代碼及對應語言名稱
 
   DEFINE lc_cmd         LIKE zz_file.zz08
   DEFINE ls_cmd         STRING
   DEFINE li_mod_index1  LIKE type_file.num5     #FUN-680135 SMALLINT
   DEFINE li_mod_index2  LIKE type_file.num5     #FUN-680135 SMALLINT
   DEFINE lc_mod_id      LIKE gaz_file.gaz01
   DEFINE lc_mod_name    LIKE gaz_file.gaz03
 
   SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01=g_help.gaz01
   LET ls_cmd = lc_cmd
   LET ls_cmd = ls_cmd.trim()
   LET li_mod_index1 = ls_cmd.getIndexOf("$",2)
   LET li_mod_index2 = ls_cmd.getIndexOf("i/",1)
   LET ls_cmd = ls_cmd.subString(li_mod_index1+1,li_mod_index2-1)
 
   LET ls_cmd = ls_cmd.toLowerCase()
   LET lc_mod_id = ls_cmd.trim()
 
 #  #MOD-540163
#  SELECT gaz03 INTO lc_mod_name FROM gaz_file
#   WHERE gaz01=lc_mod_id AND gaz02 = g_help.gaz02 order by gaz05
   CALL cl_get_progname(lc_mod_id,g_help.gaz02) RETURNING lc_mod_name
 
   LET lc_mod_id = UPSHIFT(lc_mod_id)
   RETURN lc_mod_id,lc_mod_name
 
END FUNCTION
 
 
#FUNCTION p_help_get_prog()
#
#   DEFINE lc_prog_name   LIKE gaz_file.gaz03
#
#   SELECT gaz03 INTO lc_prog_name FROM gaz_file
#    WHERE gaz01=g_help.gaz01 AND gaz02 = g_help.gaz02 order by gaz05
#
#   RETURN lc_prog_name
#
#END FUNCTION
 
# 取得作業目的
#FUNCTION p_help_get_purpose()
#
#   DEFINE l_gaz03   LIKE gaz_file.gaz03
#
#   SELECT gaz03 INTO l_gaz03 FROM gaz_file
#    WHERE gaz01=g_help.gaz01 AND gaz02 = g_help.gaz02 order by gaz05
#
#   RETURN l_gaz03
#
#END FUNCTION
 
# 取得作業目的
FUNCTION p_help_get_purpose()
 
   DEFINE l_gaz04   LIKE gaz_file.gaz04
 
   SELECT gaz04 INTO l_gaz04 FROM gaz_file
    WHERE gaz01 = g_help.gaz01 
      AND gaz02 = g_help.gaz02 
       AND gaz05 = g_help.gaz05 #MOD-510166
   
   RETURN l_gaz04
 
END FUNCTION
 
# 取得作業特點 分階層組合後輸出
FUNCTION p_help_get_feature()
 
   DEFINE ls_return      STRING
   DEFINE ls_sql         STRING
   DEFINE lc_char2       LIKE type_file.chr2     #FUN-680135 VARCHAR(2)
   DEFINE l_gbf          RECORD
            gbf03        LIKE gbf_file.gbf03,
            gbf04        LIKE gbf_file.gbf04,
            gbf05        LIKE gbf_file.gbf05
                         END RECORD
 
   LET ls_return = ""
   LET ls_sql = " SELECT gbf03,gbf04,gbf05 FROM gbf_file ",
                 " WHERE gbf01 = '",g_help.gaz01 CLIPPED,"' ",
                   " AND gbf02 = '",g_help.gaz02 CLIPPED,"' ",
                 " ORDER BY gbf03,gbf04 "
 
   PREPARE p_help_feature_pre FROM ls_sql
   DECLARE p_help_feature_curs CURSOR FOR p_help_feature_pre
   FOREACH p_help_feature_curs INTO l_gbf.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET lc_char2 = l_gbf.gbf03 CLIPPED
      IF l_gbf.gbf04 = 0 THEN
         LET ls_return=ls_return,"     ",lc_char2,
                       ".",l_gbf.gbf05,ASCII 10
      ELSE
         LET ls_return=ls_return,"          ", # l_gbf.gbf03,".",l_gbf.gbf04,
                       "-> ",l_gbf.gbf05,ASCII 10
      END IF
   END FOREACH
 
   RETURN ls_return
 
END FUNCTION
 
# 取得 Action memo 說明 分階層組合後輸出
FUNCTION p_help_get_action_memo()
 
   DEFINE ls_return       STRING
   DEFINE ls_gbd01        STRING
   DEFINE li_index        LIKE type_file.num5     #FUN-680135 SMALLINT
   DEFINE li_i            LIKE type_file.num5     #FUN-680135 SMALLINT
   DEFINE lc_gbd04        LIKE gbd_file.gbd04
   DEFINE lc_gbd05        LIKE gbd_file.gbd05
   DEFINE ls_sql          STRING
   DEFINE lc_gap02        LIKE gap_file.gap02
 
   LET ls_return=""
 
   LET ls_sql = " SELECT gap02 FROM gap_file ",
                 " WHERE gap01 = '",g_help.gaz01 CLIPPED,"' "
 
   PREPARE p_help_gap02_prepare FROM ls_sql           #預備一下
   DECLARE p_help_gap02_curs CURSOR FOR p_help_gap02_prepare
 
   FOREACH p_help_gap02_curs INTO lc_gap02
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET lc_gbd04 = ""    #No.FUN-750068
      LET lc_gbd05 = ""    #No.FUN-750068
 
      SELECT gbd04,gbd05 INTO lc_gbd04, lc_gbd05 FROM gbd_file
       WHERE gbd01=lc_gap02
         AND gbd02=g_help.gaz01
         AND gbd03=g_help.gaz02
         AND gbd07="N"
 
      IF SQLCA.SQLCODE THEN
         SELECT gbd04,gbd05 INTO lc_gbd04, lc_gbd05 FROM gbd_file
          WHERE gbd01=lc_gap02
            AND gbd02='standard'
            AND gbd03=g_help.gaz02
            AND gbd07="N"
      END IF
 
 
      IF NOT cl_null(lc_gbd04) THEN
         LET ls_return=ls_return.trimRight(),
         "      . ",lc_gbd04 CLIPPED," : ",lc_gbd05 CLIPPED,ASCII 10
      END IF
 
   END FOREACH
   RETURN ls_return
 
END FUNCTION
 
 
# 取得欄位說明 分階層組合後輸出
FUNCTION p_help_get_field_memo(lc_gaz03)
 
   DEFINE ls_return     STRING
   DEFINE lc_gaz03      LIKE gaz_file.gaz03
   DEFINE lc_gae02      LIKE gae_file.gae02
   DEFINE lc_gae04      LIKE gae_file.gae04
   DEFINE lc_gbs07      LIKE gbs_file.gbs07     #FUN-7B0081  
   DEFINE lc_gbs07p     LIKE gbs_file.gbs07     #FUN-7B0081  #TQC-590032
   DEFINE lc_gax02      LIKE gax_file.gax02
   DEFINE li_i          LIKE type_file.num5     #FUN-680135 SMALLINT
   DEFINE li_j          LIKE type_file.num5     #FUN-680135 SMALLINT
   DEFINE ls_sql        STRING
   DEFINE ls_gae01      STRING
   DEFINE lc_module     LIKE type_file.chr1     #FUN-680135 VARCHAR(1) #TQC-590032
   DEFINE lc_gae11      LIKE gae_file.gae11     #No.FUN-750068
   DEFINE lc_gae12      LIKE gae_file.gae12     #No.FUN-750068
   DEFINE lc_smb03      LIKE smb_file.smb03     #No.FUN-750068
   DEFINE li_noind_flag LIKE type_file.num5     #No.FUN-750068
 
   LET ls_return=""
 
   # 2004/05/03 輸出各個畫面檔名稱, 05/06 改為抓取 gax_file
   DECLARE p_help_per_memo CURSOR FOR
     SELECT gax02 FROM gax_file
      WHERE gax01=g_help.gaz01 AND gax04="Y"
 
   FOREACH p_help_per_memo INTO lc_gax02
      IF cl_null(lc_gax02) THEN
         EXIT FOREACH
      END IF
 
      # 抓取每個畫面元件的值 FUN-520004 gae有客製碼欄位 gae11
      LET li_j=0
      SELECT count(*) INTO li_j FROM gae_file
       WHERE gae01=lc_gax02 AND gae03=g_help.gaz02
         AND gae11="Y"  #客製若存在則抓客製資料, 整組進整組出
      IF li_j >= 1 THEN
         LET lc_module="C"
         LET lc_gae11 = "Y"     #No.FUN-750068
      ELSE
         LET lc_module="P"
         LET lc_gae11 = "N"     #No.FUN-750068
      END IF                    #TQC-590032
 
      #No.FUN-750068 --start--  增加行業別
      LET li_noind_flag = FALSE
      SELECT COUNT(UNIQUE gae12) INTO li_i FROM gae_file
       WHERE gae01=lc_gax02 AND gae03=g_help.gaz02 AND gae11=lc_gae11
      IF li_i = 1 THEN
         SELECT UNIQUE gae12 INTO lc_gae12 FROM gae_file
          WHERE gae01=lc_gax02 AND gae03=g_help.gaz02 AND gae11=lc_gae11
         IF lc_gae12 = "std" THEN
            LET li_noind_flag = TRUE
         END IF
      END IF
      LET g_sql = "SELECT UNIQUE gae12 FROM gae_file",
                  " WHERE gae01='",lc_gax02 CLIPPED,"' AND gae03='",g_help.gaz02 CLIPPED,"'",
                  "   AND gae11='",lc_gae11 CLIPPED,"'"
      PREPARE p_help_per_industry_pre FROM g_sql
      DECLARE p_help_per_industry CURSOR FOR p_help_per_industry_pre
      FOREACH p_help_per_industry INTO lc_gae12
         SELECT smb03 INTO lc_smb03 FROM smb_file WHERE smb01=lc_gae12 AND smb02=g_help.gaz02
      #No.FUN-750068 ---end---
 
 
         # 分畫面檔顯示, 並輔以 wintitle, 使 user 能衣現在畫面位置尋出要的說明
         IF lc_gax02 = g_help.gaz01 THEN
            LET ls_return = ls_return.trimRight(),"     ", lc_gaz03 CLIPPED
         ELSE
            LET lc_gae04=""
#           #TQC-590032
            IF lc_module="C" THEN
               EXECUTE p_help_gae04_pre
                 USING lc_gax02,"Y","wintitle",g_help.gaz02,lc_gae12   #No.FUN-750068
                  INTO lc_gae04
            END IF
            IF lc_module<>"C" OR cl_null(lc_gae04) THEN
               EXECUTE p_help_gae04_pre
                 USING lc_gax02,"N","wintitle",g_help.gaz02,lc_gae12   #No.FUN-750068
                  INTO lc_gae04
            END IF
 
#           IF li_j > 0 THEN
#              SELECT gae04 INTO lc_gae04 FROM gae_file
#               WHERE gae01=lc_gax02
#                 AND gae02="wintitle"
#                 AND gae03=g_help.gaz02 
#                 AND gae11="Y"
#           ELSE
#              SELECT gae04 INTO lc_gae04 FROM gae_file
#               WHERE gae01=lc_gax02
#                 AND gae02="wintitle"
#                 AND gae03=g_help.gaz02 
#                 AND gae11="N"
#           END IF
 
            LET ls_return = ls_return.trimRight(),"     ", lc_gae04 CLIPPED
         END IF
         #No.FUN-750068 --start--
         IF NOT li_noind_flag THEN
            LET ls_return = ls_return.trimRight(),"  (",lc_gax02 CLIPPED,")"
            LET ls_return = ls_return.trimRight(),"     <", lc_smb03 CLIPPED,">",ASCII 10
         ELSE
            LET ls_return = ls_return.trimRight(),"  (",lc_gax02 CLIPPED,")",ASCII 10
         END IF
         #No.FUN-750068 ---end---
 
         LET ls_gae01 = ""
         LET ls_gae01 = ls_gae01, "\t", "Field Description"
         LET ls_gae01 = ls_gae01, "(", "Field id",")"
         LET ls_gae01 = ls_gae01, " : ", "Field Memo"
         LET ls_return = ls_return, ls_gae01, ASCII 10
 
         LET ls_sql=" SELECT gae02,gae04,gbs07 FROM gae_file,gbs_file ", #FUN-7B0081
                     " WHERE gae01='",lc_gax02 CLIPPED,"' ",
                       " AND gae03='",g_help.gaz02 CLIPPED,"' ",
                       " AND gae12='",lc_gae12 CLIPPED,"' ",    #No.FUN-750068
                       " AND gbs01=gae01 AND gbs02=gae02 AND gbs03=gae03 ",
                       " AND gbs04=gae11 AND gbs05=gae12 "
 
         IF lc_module="C" THEN
            LET ls_sql = ls_sql.trim()," AND gae11='Y'"
            LET lc_gae11="Y"   #FUN-7B0081
         ELSE
            LET ls_sql = ls_sql.trim()," AND gae11='N'"
            LET lc_gae11="N"   #FUN-7B0081
         END IF
         LET ls_sql = ls_sql.trim()," ORDER BY gae02 "
 
         DECLARE p_help_field_memo CURSOR FROM ls_sql
         FOREACH p_help_field_memo INTO lc_gae02,lc_gae04,lc_gbs07 #FUN-7B0081
 
            IF SQLCA.SQLCODE THEN
               EXIT FOREACH
            END IF
 
            LET ls_gae01 = ""
            LET ls_gae01 = ls_gae01, "\t", lc_gae04 CLIPPED
            LET ls_gae01 = ls_gae01, "(", lc_gae02 CLIPPED,") : " #No.FUN-750068
            LET ls_gae01 = ls_gae01, "\n", lc_gbs07 CLIPPED       #FUN-7B0081
            LET ls_return = ls_return, ls_gae01, ASCII 10
 
         END FOREACH
 
         LET ls_return = ls_return,"\n\n\n"                       #No.FUN-750068
      END FOREACH                                                 #No.FUN-750068
   END FOREACH
   RETURN ls_return
 
END FUNCTION
 
 
FUNCTION p_help_preview(p_module)
  DEFINE p_module      LIKE zz_file.zz011
  DEFINE ls_help_url   STRING
  DEFINE lc_gae11      LIKE gae_file.gae11   #No.FUN-750068
  DEFINE lc_gae12      LIKE gae_file.gae12   #No.FUN-750068
  DEFINE li_cnt        LIKE type_file.num5   #No.FUN-750068
  DEFINE li_i          LIKE type_file.num5   #No.FUN-750068
  DEFINE ls_i          STRING                #No.FUN-750068
  DEFINE ls_btn_sn     STRING                #No.FUN-750068
 
  #MOD-530040
  LET ls_help_url = FGL_GETENV("FGLASIP")
  IF UPSHIFT(p_module[1,1])="C" THEN
      LET ls_help_url = ls_help_url.trim(), "/topcust/help/"
      LET lc_gae11 = "Y"   #No.FUN-750068
  ELSE
      LET ls_help_url = ls_help_url.trim(), "/tiptop/help/"
      LET lc_gae11 = "N"   #No.FUN-750068
  END IF
 
  #No.FUN-750068 --start--
  SELECT COUNT(UNIQUE gae12) INTO li_cnt FROM gae_file
   WHERE gae01=g_help.gaz01 AND gae03=g_help.gaz02
  IF li_cnt > 1 THEN
     LET g_sql = "SELECT UNIQUE gae12 FROM gae_file ",
                 " WHERE gae01='",g_help.gaz01 CLIPPED,"' AND gae03='",g_help.gaz02 CLIPPED,"'"
     PREPARE industry_list_pre FROM g_sql
     DECLARE industry_list_curs CURSOR FOR industry_list_pre
     LET li_cnt = 1
     FOREACH industry_list_curs INTO g_gae12[li_cnt]
        LET li_cnt = li_cnt + 1
     END FOREACH
     CALL g_gae12.deleteElement(li_cnt)
 
     MENU "Industry" ATTRIBUTE(STYLE="popup")
        BEFORE MENU
            #No.TQC-A10130  --Begin
            #HIDE OPTION ALL
            CALL cl_set_act_visible("btnb_1,btnb_2, btnb_3,btnb_4, btnb_5,btnb_6, btnb_7,btnb_8,
                                     btnb_9,btnb_10, btnb_11,btnb_12, btnb_13,btnb_14,
                                     btnb_15,btnb_16, btnb_17,btnb_18, btnb_19,btnb_20",FALSE)
            #No.TQC-A10130  --End  
            FOR li_i = 1 TO g_gae12.getLength()
                LET ls_i = li_i
                LET ls_btn_sn = "btnb_" || ls_i
                #No.TQC-A10130  --Begin
                #SHOW OPTION ls_btn_sn
                CALL cl_set_act_visible(ls_btn_sn,TRUE)
                #No.TQC-A10130  --End  
            END FOR
            CALL p_help_SetIndustryOption()
 
        ON ACTION btnb_1
           LET lc_gae12 = g_gae12[1]
           EXIT MENU
        ON ACTION btnb_2
           LET lc_gae12 = g_gae12[2]
           EXIT MENU
        ON ACTION btnb_3
           LET lc_gae12 = g_gae12[3]
           EXIT MENU
        ON ACTION btnb_4
           LET lc_gae12 = g_gae12[4]
           EXIT MENU
        ON ACTION btnb_5
           LET lc_gae12 = g_gae12[5]
           EXIT MENU
        ON ACTION btnb_6
           LET lc_gae12 = g_gae12[6]
           EXIT MENU
        ON ACTION btnb_7
           LET lc_gae12 = g_gae12[7]
           EXIT MENU
        ON ACTION btnb_8
           LET lc_gae12 = g_gae12[8]
           EXIT MENU
        ON ACTION btnb_9
           LET lc_gae12 = g_gae12[9]
           EXIT MENU
        ON ACTION btnb_10
           LET lc_gae12 = g_gae12[10]
           EXIT MENU
        ON ACTION btnb_11
           LET lc_gae12 = g_gae12[11]
           EXIT MENU
        ON ACTION btnb_12
           LET lc_gae12 = g_gae12[12]
           EXIT MENU
        ON ACTION btnb_13
           LET lc_gae12 = g_gae12[13]
           EXIT MENU
        ON ACTION btnb_14
           LET lc_gae12 = g_gae12[14]
           EXIT MENU
        ON ACTION btnb_15
           LET lc_gae12 = g_gae12[15]
           EXIT MENU
        ON ACTION btnb_16
           LET lc_gae12 = g_gae12[16]
           EXIT MENU
        ON ACTION btnb_17
           LET lc_gae12 = g_gae12[17]
           EXIT MENU
        ON ACTION btnb_18
           LET lc_gae12 = g_gae12[18]
           EXIT MENU
        ON ACTION btnb_19
           LET lc_gae12 = g_gae12[19]
           EXIT MENU
        ON ACTION btnb_20
           LET lc_gae12 = g_gae12[20]
           EXIT MENU
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
     END MENU
     IF INT_FLAG THEN
        LET INT_FLAG = FALSE
        RETURN
     END IF
  ELSE
     SELECT UNIQUE gae12 INTO lc_gae12 FROM gae_file
      WHERE gae01=g_help.gaz01 AND gae03=g_help.gaz02
  END IF
  IF lc_gae12 = "std" THEN
     LET ls_help_url = ls_help_url.trim() || g_help.gaz02 CLIPPED,
                       "/",DOWNSHIFT(p_module) CLIPPED,
                       "/HELP_",g_help.gaz01 CLIPPED,".htm"
  ELSE
     LET ls_help_url = ls_help_url.trim() || g_help.gaz02 CLIPPED,
                       "/",DOWNSHIFT(p_module) CLIPPED,
                       "/HELP_",g_help.gaz01 CLIPPED,"_",lc_gae12 CLIPPED,".htm"
  END IF
  #No.FUN-750068 ---end---
 
  IF NOT cl_open_url(ls_help_url) THEN
     CALL cl_err(ls_help_url,"lib-054",1)
  END IF
END FUNCTION
 
#No.FUN-750068 --start--
FUNCTION p_help_SetIndustryOption()
   DEFINE lwin_curr       ui.Window
   DEFINE lnode_win       om.DomNode
   DEFINE ln_menu         om.DomNode,
          ln_menuAction   om.DomNode
   DEFINE ll_menu         om.NodeList,
          ll_menuAction   om.NodeList
   DEFINE li_i            LIKE type_file.num10,
          li_j            LIKE type_file.num10
   DEFINE ls_j            STRING
   DEFINE lc_smb03        LIKE smb_file.smb03
 
 
   LET lwin_curr = ui.Window.getCurrent()
   LET lnode_win = lwin_curr.getNode()
   LET ll_menu = lnode_win.selectByPath("//Menu[@text=\"Industry\"]")
   LET ln_menu = ll_menu.item(1)
   IF ln_menu IS NULL THEN
      RETURN
   END IF
   LET ll_menuAction = ln_menu.selectByTagName("MenuAction")
   FOR li_i = 1 TO ll_menuAction.getLength()
       LET ln_menuAction = ll_menuAction.item(li_i)
       FOR li_j = 1 TO g_gae12.getLength()
           LET ls_j = li_j
           IF ln_menuAction.getAttribute("name") = "btnb_" || ls_j THEN
              SELECT smb03 INTO lc_smb03 FROM smb_file
               WHERE smb01=g_gae12[li_j] AND smb02=g_lang
              CALL ln_menuAction.setAttribute("text",lc_smb03 CLIPPED)
           END IF
       END FOR
   END FOR
END FUNCTION
#No.FUN-750068 ---end---
