# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: p_zo.4gl
# Descriptions...: 公司名稱建立
# Date & Author..: 91/05/31 By LYS
# Modify.........: No.MOD-4B0050 04/11/08 By Mandy 地址改回原本地址(一)/地址(二)各char(40)
# Modify.........: No.FUN-4C0040 04/12/07 By pengu Data and Group權限控管
# Modify.........: No.MOD-4C0047 04/12/08 By pengu 開戶銀行欄位(controlp 功能異常)
#                                開窗選取後,程式會自動關閉,直接輸入並不會
# Modify.........: No.FUN-510050 05/01/28 By pengu 報表轉XML
# Modify.........: No.FUN-540029 05/04/18 By coco  add logo
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.TQC-670093 06/07/26 By CoCo  開放logo的權限為777
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6C0120 06/12/21 By Ray 復制改為標准寫法
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740061 07/04/12 By Ray 復制錯誤
# Modify.........: No.FUN-750016 07/05/08 By CoCo CR Logo與PDF一致,副檔名都為jpg 
# Modify.........: No.FUN-860033 08/06/06 By alex 修正 ON IDLE區段
# Modify.........: No.FUN-970006 09/07/28 By jacklai CR Logo呼叫Web Service上傳到CR主機
# Modify.........: No.FUN-9A0024 09/10/13 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0113 09/11/19 By alex 改chmod為使用Genero API
# Modify.........: No.FUN-9C0126 09/12/23 By chenmoyan 新增产出符合XBRL上传格式档案1.TXT 2.EXCEL 
# Modify.........: No.FUN-B50065 11/05/13 BY huangrh BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新資料畫面
# Modify.........: No:FUN-C20106 12/08/29 By pauline 語言別下拉動態增加英文選項

IMPORT com  #No.FUN-970006
IMPORT xml  #No.FUN-970006
IMPORT os

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../aws/4gl/aws_crupload_cli.inc"    #No.FUN-970006
 
DEFINE g_zo           RECORD LIKE zo_file.*,
       g_zo_t         RECORD LIKE zo_file.*,
       g_zo01_t       LIKE zo_file.zo01,
       g_wc,g_sql     string,                 #No.FUN-580092 HCN
       g_buf          LIKE type_file.chr1000  
DEFINE g_forupd_sql   STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_cnt          LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE g_i            LIKE type_file.num5     #count/index for any purpose #No.FUN-680135 SMALLINT
DEFINE g_msg          LIKE type_file.chr1000  #No.FUN-680135 
DEFINE g_curs_index   LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE g_row_count    LIKE type_file.num10    #No.FUN-580092 HCN #No.FUN-680135 INTEGER
DEFINE g_jump         LIKE type_file.num10,   #No.FUN-680135 INTEGER
       g_no_ask       LIKE type_file.num5     #No.FUN-680135 SMALLINT
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
 
   INITIALIZE g_zo.* TO NULL
   INITIALIZE g_zo_t.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM zo_file WHERE zo01 =? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_zo_curl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW p_zo_w WITH FORM "azz/42f/p_zo"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   # 2004/07/15 新增語言別選項
  #CALL cl_set_combo_lang("zo01")   #FUN-C20106 mark
   CALL zo_combo_items("zo01")    #動態設定ComboBox的Item   #FUN-C20106 add
 
   CALL p_zo_menu()
   CLOSE WINDOW p_zo_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
 
END MAIN
 
FUNCTION p_zo_curs()
 
   CLEAR FORM
    CONSTRUCT BY NAME g_wc ON zo01,zo02,zo12,zo07,zo06,zo041,zo042,zo05,zo09, #MOD-4B0050 加zo042
                             zo11,zo13,zo10,zo16,           #FUN-9C0126 add zo16
                             zouser,zogrup,zomodu,zodate
       ON ACTION CONTROLP
         IF INFIELD(zo13) THEN
#           CALL q_nma(0,0,g_zo.zo13) RETURNING g_zo.zo13
#           CALL FGL_DIALOG_SETBUFFER( g_zo.zo13 )
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_nma"
            LET g_qryparam.default1 = g_zo.zo13
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO zo13
            NEXT FIELD zo13
         END IF
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END CONSTRUCT
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND zouser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND zogrup = '",g_grup,"'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #        LET g_wc = g_wc clipped," AND  zogrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('zouser', 'zogrup')
   #End:FUN-980030
 
   IF cl_null(g_wc) THEN
      LET g_wc=" 1=1 "
   END IF
   LET g_sql="SELECT zo01 FROM zo_file ", # 組合出 SQL 指令
             " WHERE ",g_wc CLIPPED, " ORDER BY zo01"
   PREPARE p_zo_prepare FROM g_sql           # RUNTIME 編譯
   DECLARE p_zo_curs                         # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR p_zo_prepare
 
   LET g_sql= "SELECT COUNT(*) FROM zo_file WHERE ",g_wc CLIPPED
   PREPARE p_zo_precount FROM g_sql
   DECLARE p_zo_count CURSOR FOR p_zo_precount
 
END FUNCTION
FUNCTION p_zo_menu()
 
   DEFINE l_cmd  LIKE type_file.chr1000  #No.FUN-680135 
    MENU ""
        BEFORE MENU
            CALL cl_navigator_setting(g_curs_index, g_row_count) #No.FUN-580092 HCN
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL p_zo_a()
            END IF
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL p_zo_q()
            END IF
 
        ON ACTION next
            CALL p_zo_fetch('N')
 
        ON ACTION previous
            CALL p_zo_fetch('P')
 
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL p_zo_u()
            END IF
 
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL p_zo_r()
            END IF
 
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL p_zo_copy()
            END IF
 
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL p_zo_out()
            END IF
 
        ON ACTION help
            CALL cl_show_help()
 
        ON ACTION exit
            EXIT MENU
 
        ON ACTION jump
            CALL p_zo_fetch('/')
 
        ON ACTION first
            CALL p_zo_fetch('F')
 
        ON ACTION last
            CALL p_zo_fetch('L')
 
        ON ACTION controlg
            CALL cl_cmdask()
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON ACTION locale
           CALL cl_dynamic_locale()                
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           # 2004/07/15 新增語言別選項
          #CALL cl_set_combo_lang("zo01")   #FUN-C20106 mark
           CALL zo_combo_items("zo01")    #動態設定ComboBox的Item   #FUN-C20106 add
           CALL p_zo_img()      ###  FUN-540029  ###
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE MENU
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
    END MENU
    CLOSE p_zo_curs
END FUNCTION
 
FUNCTION p_zo_a()
 
   MESSAGE ""
   CLEAR FORM                                   # 清螢墓欄位內容
   INITIALIZE g_zo.* LIKE zo_file.*
   LET g_zo01_t = NULL
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_zo.zouser = g_user
      LET g_zo.zooriu = g_user #FUN-980030
      LET g_zo.zoorig = g_grup #FUN-980030
      LET g_zo.zogrup = g_grup               #使用者所屬群
      LET g_zo.zodate = g_today
 
      CALL p_zo_i("a")                      # 各欄位輸入
 
      IF INT_FLAG THEN                         # 若按了DEL鍵
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF
 
      IF g_zo.zo01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      INSERT INTO zo_file VALUES(g_zo.*)       # DISK WRITE
 
      IF SQLCA.sqlcode THEN
         #CALL cl_err(g_zo.zo01,SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("ins","zo_file",g_zo.zo01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
         CONTINUE WHILE
      ELSE
         LET g_zo_t.* = g_zo.*                # 保存上筆資料
         SELECT zo01 INTO g_zo.zo01 FROM zo_file
          WHERE zo01 = g_zo.zo01
      END IF
 
      EXIT WHILE
   END WHILE
   LET g_wc=' '
 
END FUNCTION
 
FUNCTION p_zo_i(p_cmd)
   DEFINE
       p_cmd           LIKE type_file.chr1,    #No.FUN-680135 
       l_n             LIKE type_file.num5,    #No.FUN-680135 SMALLINT
       ls_file,l_cmd   STRING,
       ls_server_file  STRING
   DEFINE l_fb         BYTE                    #No.FUN-970006
   DEFINE l_filename   STRING                  #No.FUN-970006
   DEFINE l_status     LIKE type_file.num10    #No.FUN-970006
   DEFINE l_result     STRING                  #No.FUN-970006
   DEFINE l_str        STRING                  #No.FUN-970006
 
   DISPLAY BY NAME g_zo.zouser
   DISPLAY BY NAME g_zo.zogrup
   DISPLAY BY NAME g_zo.zodate
    INPUT BY NAME  g_zo.zooriu,g_zo.zoorig,g_zo.zo01,g_zo.zo02,g_zo.zo12,g_zo.zo07,g_zo.zo06,g_zo.zo041,g_zo.zo042,  #MOD-4B0050 加zo042
                 g_zo.zo05,g_zo.zo09,g_zo.zo11,g_zo.zo13,g_zo.zo10,g_zo.zo16,               #FUN-9C0126 add zo16
                 g_zo.zouser,g_zo.zogrup,g_zo.zomodu,g_zo.zodate
       WITHOUT DEFAULTS
 
      AFTER FIELD zo01
         IF NOT cl_null(g_zo.zo01) THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND g_zo.zo01 != g_zo01_t) THEN
               SELECT COUNT(*) INTO l_n FROM zo_file
                WHERE zo01 = g_zo.zo01
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_zo.zo01,-239,0)
                  LET g_zo.zo01 = g_zo01_t
                  DISPLAY BY NAME g_zo.zo01
                  NEXT FIELD zo01
               END IF
            END IF
         END IF
 
      AFTER FIELD zo02
         IF g_zo.zo12 IS NULL THEN
            LET g_zo.zo12=g_zo.zo02
            DISPLAY BY NAME g_zo.zo12
         END IF
 
      AFTER FIELD zo13
         IF NOT cl_null(g_zo.zo13) THEN
            CALL p_zo_zo13('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_zo.zo13,g_errno,0)
               LET g_zo.zo13 = g_zo_t.zo13
               DISPLAY BY NAME g_zo.zo13
               NEXT FIELD zo13
            END IF
         END IF
 
      ON ACTION CONTROLP
         IF INFIELD(zo13) THEN
#           CALL q_nma(0,0,g_zo.zo13) RETURNING g_zo.zo13
#           CALL FGL_DIALOG_SETBUFFER( g_zo.zo13 )
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_nma"
            LET g_qryparam.default1 = g_zo.zo13
             CALL cl_create_qry() RETURNING g_zo.zo13    #MOD-4C0047 加RETURNING
            DISPLAY BY NAME g_zo.zo13
            NEXT FIELD zo13
         END IF
 
      ON ACTION controlo                        # 沿用所有欄位
         IF INFIELD(zo01) THEN
            LET g_zo.* = g_zo_t.*
            #No.FUN-9A0024--begin 
            #DISPLAY BY NAME g_zo.*
            DISPLAY BY NAME g_zo.zooriu,g_zo.zoorig, g_zo.zo01,g_zo.zo02,g_zo.zo12,g_zo.zo07,
                            g_zo.zo06,g_zo.zo041,g_zo.zo042,g_zo.zo05,g_zo.zo09,g_zo.zo11,
                            g_zo.zo13,g_zo.zo10,g_zo.zouser,g_zo.zogrup,g_zo.zomodu,g_zo.zodate
            #No.FUN-9A0024--end             
            NEXT FIELD zo01
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION controlf                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
###  FUN-540029  ###
      ON ACTION update
         IF NOT cl_null(g_zo.zo01) THEN
            LET ls_file = cl_browse_file()
            IF NOT cl_null(ls_file) THEN
               ### FUN-750016 start ###
               #LET ls_server_file = "$TOP/doc/pic/pdf_logo_",g_dbs CLIPPED,g_zo.zo01,".gif"
               #LET ls_server_file = "$TOP/doc/pic/pdf_logo_",g_dbs CLIPPED,g_zo.zo01,".jpg"    #NO.FUN-970006 marked
               LET ls_server_file = FGL_GETENV("TOP"),"/doc/pic/pdf_logo_",g_dbs CLIPPED,g_zo.zo01,".jpg"   #NO.FUN-970006 add
               ### FUN-750016 end ### 
               LET l_cmd = "rm ",ls_server_file CLIPPED
               RUN l_cmd
               IF NOT cl_upload_file(ls_file, ls_server_file) THEN
                  CALL cl_err(NULL, "lib-212", 1)
                  RETURN
               ELSE
                  #No.FUN-970006 --start--
                  #將檔案內容讀取到BYTE變數
                  LOCATE l_fb IN FILE ls_server_file
                  LET l_filename = "pdf_logo_",g_dbs CLIPPED,g_zo.zo01,".jpg"
                  CALL fgl_ws_setOption("http_invoketimeout", 60)         #若 60 秒內無回應則放棄
 
                  #透過Web Service將檔案上傳到CR主機
                  CALL Uploader_Upload(l_filename, l_fb) RETURNING l_status, l_result
 
                  IF l_status = 0 THEN
                      IF l_result = "0" THEN
                         LET l_str = cl_getmsg("azz-762", g_lang) CLIPPED
                      ELSE
                         LET l_str = l_result CLIPPED
                      END IF
                      CALL cl_err(l_str, '!', 1)
                  ELSE
                      IF fgl_getenv('FGLGUI') = '1' THEN
                         LET l_str = "Connection failed:\n\n", 
                                     "  [Code]: ", wserror.code, "\n",
                                     "  [Action]: ", wserror.action, "\n",
                                     "  [Description]: ", wserror.description
                      ELSE
                         LET l_str = "Connection failed: ", wserror.description
                      END IF
                      CALL cl_err(l_str, '!', 1)   #連接失敗
                  END IF                  
                  #No.FUN-970006 --end--
                  
                  ### TQC-670093 ###
#                 LET l_cmd = "chmod 777 ",ls_server_file CLIPPED," 2>/dev/null"
#                 RUN l_cmd
                  IF os.Path.chrwx(ls_server_file CLIPPED, 511) THEN   #FUN-9B0113 7*64+7*8+7=511
                  END IF
                  ### TQC-670093 ###
                  CALL p_zo_img()
               END IF
            END IF
         END IF
###  FUN-540029  ###
 
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
 
END FUNCTION
 
FUNCTION p_zo_zo13(p_cmd)  #銀行代號
   DEFINE p_cmd	LIKE type_file.chr1,       #No.FUN-680135 
          l_nma03 LIKE nma_file.nma03,
          l_nma04 LIKE nma_file.nma04,
          l_nmaacti LIKE nma_file.nmaacti
 
   LET g_errno = ' '
   SELECT nma03,nma04,nmaacti
     INTO l_nma03,l_nma04,l_nmaacti
     FROM nma_file
    WHERE nma01 = g_zo.zo13
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-013'
                           LET l_nma03 = NULL
                           LET l_nma04 = NULL
        WHEN l_nmaacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF g_errno = ' ' OR p_cmd = 'd' THEN
      DISPLAY l_nma03 TO FORMONLY.nma03
      DISPLAY l_nma04 TO FORMONLY.nma04
   END IF
 
END FUNCTION
 
FUNCTION p_zo_q()
 
    LET g_row_count = 0 #No.FUN-580092 HCN
   LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count) #No.FUN-580092 HCN
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL p_zo_curs()                          # 宣告 SCROLL CURSOR
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      RETURN
   END IF
 
   OPEN p_zo_count
    FETCH p_zo_count INTO g_row_count #No.FUN-580092 HCN
    DISPLAY g_row_count TO FORMONLY.cnt   #No.FUN-580092 HCN
 
   OPEN p_zo_curs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zo.zo01,SQLCA.sqlcode,0)
      INITIALIZE g_zo.* TO NULL
   ELSE
      CALL p_zo_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION p_zo_fetch(p_flzo)
   DEFINE
       p_flzo          LIKE type_file.chr1,         #No.FUN-680135 
       l_abso          LIKE type_file.num10         #No.FUN-680135 INTEGER
 
   CASE p_flzo
      WHEN 'N' FETCH NEXT     p_zo_curs INTO g_zo.zo01
      WHEN 'P' FETCH PREVIOUS p_zo_curs INTO g_zo.zo01
      WHEN 'F' FETCH FIRST    p_zo_curs INTO g_zo.zo01
      WHEN 'L' FETCH LAST     p_zo_curs INTO g_zo.zo01
      WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump p_zo_curs INTO g_zo.zo01
            LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zo.zo01,SQLCA.sqlcode,0)
      INITIALIZE g_zo.* TO NULL  #TQC-6B0105
      LET g_zo.zo01 = NULL      #TQC-6B0105
      RETURN
   ELSE
      CASE p_flzo
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count #No.FUN-580092 HCN
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
       CALL cl_navigator_setting(g_curs_index, g_row_count) #No.FUN-580092 HCN
   END IF
 
   SELECT * INTO g_zo.* FROM zo_file            # 重讀DB,因TEMP有不被更新特性
    WHERE zo01 = g_zo.zo01
 
   IF SQLCA.sqlcode THEN
      #CALL cl_err(g_zo.zo01,SQLCA.sqlcode,0)  #No.FUN-660081
      CALL cl_err3("sel","zo_file",g_zo.zo01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
   ELSE                                     #FUN-4C0040權限控管
      LET g_data_owner=g_zo.zouser
      LET g_data_group=g_zo.zogrup
      CALL p_zo_show()                      # 重新顯示
   END IF
 
END FUNCTION
 
FUNCTION p_zo_show()
 
   LET g_zo_t.* = g_zo.*
    DISPLAY BY NAME g_zo.zooriu,g_zo.zoorig, g_zo.zo01,g_zo.zo02,g_zo.zo12,g_zo.zo07,g_zo.zo06,g_zo.zo041,g_zo.zo042, #MOD-4B0050  加zo042
                   g_zo.zo05,g_zo.zo09,g_zo.zo11,g_zo.zo13,g_zo.zo10,g_zo.zo16,               #FUN-9C0126 add zo16
                   g_zo.zouser,g_zo.zogrup,g_zo.zomodu,g_zo.zodate
 
   CALL p_zo_zo13('d')
   CALL p_zo_img()   ###  FUN-540029  ###
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION p_zo_u()
 
   IF g_zo.zo01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_zo01_t = g_zo.zo01
   BEGIN WORK
 
   OPEN p_zo_curl USING g_zo.zo01
 
   FETCH p_zo_curl INTO g_zo.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zo.zo01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_zo.zomodu=g_user                     #修改者
   LET g_zo.zodate = g_today                  #修改日期
 
   CALL p_zo_show()                          # 顯示最新資料
 
   WHILE TRUE
      CALL p_zo_i("u")                      # 欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      UPDATE zo_file SET zo_file.* = g_zo.*    # 更新DB
       WHERE zo01 = g_zo.zo01             # COLAUTH?
 
      IF SQLCA.sqlcode THEN
         #CALL cl_err(g_zo.zo01,SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("upd","zo_file",g_zo01_t,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
         CONTINUE WHILE
      END IF
 
      EXIT WHILE
   END WHILE
 
   CLOSE p_zo_curl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION p_zo_r()
    DEFINE
        l_chr                   LIKE type_file.chr1,          #No.FUN-680135
        ls_server_file,l_cmd    STRING  ### TQC-670093 ###
 
   IF g_zo.zo01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN p_zo_curl USING g_zo.zo01
 
   FETCH p_zo_curl INTO g_zo.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zo.zo01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   CALL p_zo_show()
 
   IF cl_delete() THEN
      DELETE FROM zo_file WHERE zo01 = g_zo.zo01
 
      IF SQLCA.sqlcode THEN
         #CALL cl_err(g_zo.zo01,SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("del","zo_file",g_zo.zo01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
      ELSE
         ### TQC-670093 ###
         ### FUN-750016 start ###
         #LET ls_server_file = "$TOP/doc/pic/pdf_logo_",g_dbs CLIPPED,g_zo.zo01,".gif"
         LET ls_server_file = "$TOP/doc/pic/pdf_logo_",g_dbs CLIPPED,g_zo.zo01,".jpg"
         ### FUN-750016 end ### 
         LET l_cmd = "rm ",ls_server_file CLIPPED
         RUN l_cmd
         ### TQC-670093 ###
         CLEAR FORM
         INITIALIZE g_zo.* LIKE zo_file.*
         OPEN p_zo_count
#FUN-B50065------begin---
         IF STATUS THEN
            CLOSE p_zo_count
            CLOSE p_zo_curl
            COMMIT WORK
            RETURN
         END IF
#FUN-B50065------end------
          FETCH p_zo_count INTO g_row_count #No.FUN-580092 HCN
#FUN-B50065------begin---
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE p_zo_count
             CLOSE p_zo_curl
             COMMIT WORK
             RETURN
          END IF
#FUN-B50065------end------
          DISPLAY g_row_count TO FORMONLY.cnt #No.FUN-580092 HCN
         OPEN p_zo_curs
          IF g_curs_index = g_row_count + 1 THEN #No.FUN-580092 HCN
             LET g_jump = g_row_count #No.FUN-580092 HCN
            CALL p_zo_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL p_zo_fetch('/')
         END IF
      END IF
   END IF
 
   CLOSE p_zo_curl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION p_zo_copy()
    DEFINE
        l_n             LIKE type_file.num5,          #No.FUN-680135 SMALLINT
        l_newno         LIKE zo_file.zo01,
        l_oldno         LIKE zo_file.zo01       #No.TQC-6C0120
 
#No.TQC-6C0120 --begin
#  IF g_zo.zo01 IS NULL THEN
#     CALL cl_err('',-400,0)
#     RETURN
#  END IF
 
#  CALL cl_getmsg('copy',g_lang) RETURNING g_msg
#           LET INT_FLAG = 0  ######add for prompt bug
#  PROMPT g_msg CLIPPED,': ' FOR l_newno
 
#  IF INT_FLAG OR l_newno IS NULL THEN
#     LET INT_FLAG = 0
#     RETURN
#  END IF
 
#  SELECT count(*) INTO l_n FROM zo_file
#   WHERE zo01 = l_newno
 
#  IF l_n > 0 THEN
#     CALL cl_err(g_zo.zo01,-239,0)
#     RETURN
#  END IF
 
#  DROP TABLE x
 
#  SELECT * FROM zo_file
#   WHERE zo01=g_zo.zo01
#    INTO TEMP x
 
#  UPDATE x SET zo01=l_newno,    #資料鍵值
#               zouser=g_user,   #資料所有者
#               zogrup=g_grup,   #資料所有者所屬群
#               zomodu=NULL,     #資料修改日期
#               zodate=g_today   #資料建立日期
 
#  INSERT INTO zo_file SELECT * FROM x
 
#  IF SQLCA.sqlcode THEN
#     #CALL cl_err(g_zo.zo01,SQLCA.sqlcode,0)  #No.FUN-660081
#     CALL cl_err3("ins","zo_file",l_newno,"",SQLCA.sqlcode,"","",0)           #No.FUN-660081
#  ELSE
#     MESSAGE 'ROW(',l_newno,') O.K'
#  END IF
 
 
    IF g_zo.zo01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_set_comp_entry("zo01",TRUE)      #No.TQC-740061
 
    INPUT l_newno FROM zo01
 
        AFTER FIELD zo01
           IF l_newno IS NOT NULL THEN
              SELECT count(*) INTO g_cnt FROM zo_file
                  WHERE zo01 = l_newno
              IF g_cnt > 0 THEN
                 CALL cl_err(l_newno,-239,0)
                  NEXT FIELD zo01
              END IF
           END IF
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about   
         CALL cl_about()
 
      ON ACTION help   
         CALL cl_show_help()
 
      ON ACTION controlg   
         CALL cl_cmdask() 
 
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_zo.zo01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM zo_file
        WHERE zo01=g_zo.zo01
        INTO TEMP x
    UPDATE x
        SET zo01=l_newno,    #資料鍵值
            zouser=g_user,   #資料所有者
            zogrup=g_grup,   #資料所有者所屬群
            zomodu=NULL,     #資料修改日期
            zodate=g_today   #資料建立日期
    INSERT INTO zo_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","zo_file",g_zo.zo01,"",SQLCA.sqlcode,"","",0) 
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_zo.zo01
        LET g_zo.zo01 = l_newno
        SELECT zo_file.* INTO g_zo.* FROM zo_file
               WHERE zo01 = l_newno
        CALL cl_set_comp_entry("zo01",FALSE)
        CALL p_zo_u()
        #SELECT zo_file.* INTO g_zo.* FROM zo_file  #FUN-C30027
        #       WHERE zo01 = l_oldno                #FUN-C30027
    END IF
    #LET g_zo.zo01 = l_oldno  #FUN-C30027
    CALL p_zo_show()
#No.TQC-6C0120 --end
END FUNCTION
 
FUNCTION p_zo_out()
    DEFINE
        l_i             LIKE type_file.num5,       #No.FUN-680135 SMALLINT
        l_name          LIKE type_file.chr20,      # External(Disk) file name  #No.FUN-680135 
        l_za05          LIKE type_file.chr1000,    #No.FUN-680135 
        l_chr           LIKE type_file.chr1        #No.FUN-680135
 
    IF cl_null(g_wc) THEN
       LET g_wc=" zo01='",g_zo.zo01,"'"
    END IF
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
#       CALL cl_err('',-400,0)
#       RETURN
#   END IF
    CALL cl_wait()
    #LET l_name = 'p_zo.out'
    CALL cl_outnam('p_zo') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM zo_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE p_zo_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE p_zo_curo                         # SCROLL CURSOR
         CURSOR FOR p_zo_p1
 
    START REPORT p_zo_rep TO l_name
 
    FOREACH p_zo_curo INTO g_zo.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT p_zo_rep(g_zo.*)
    END FOREACH
 
    FINISH REPORT p_zo_rep
 
    CLOSE p_zo_curo
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
###  FUN-540029  ###
FUNCTION p_zo_img()
   DEFINE   ls_pdfimg,ls_img_url       STRING
 
   LET ls_img_url = FGL_GETENV("FGLASIP") || "/tiptop/pic/pdf_logo_"
   ### FUN-750016 start ###
   #LET ls_pdfimg = ls_img_url CLIPPED,g_dbs CLIPPED,g_zo.zo01,".gif"
   LET ls_pdfimg = ls_img_url CLIPPED,g_dbs CLIPPED,g_zo.zo01,".jpg"
   ### FUN-750016 end ###
   display ls_pdfimg
### before change img should let the img = null ###
   DISPLAY NULL TO pdfimg
   DISPLAY ls_pdfimg TO pdfimg
END FUNCTION
###  FUN-540029  ###
 
REPORT p_zo_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680135 
        sr RECORD LIKE zo_file.*,
        l_chr           LIKE type_file.chr1     #No.FUN-680135 
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.zo01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
                  g_x[35] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
        ON EVERY ROW
            PRINT COLUMN g_c[31], sr.zo01,
                  COLUMN g_c[32], sr.zo02,
                  COLUMN g_c[33], sr.zo05,
                  COLUMN g_c[34], sr.zo09,
                  COLUMN g_c[35], sr.zo06
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
 
#FUN-C20106 add START
FUNCTION zo_combo_items(ps_field_name)
   DEFINE ps_values,ps_items  STRING
   DEFINE ps_field_name       STRING
   DEFINE pc_gay01            LIKE gay_file.gay01
   DEFINE pc_gay03            LIKE gay_file.gay03
   DEFINE l_n                 LIKE type_file.num5

   DECLARE p_lang_item_cs CURSOR FOR SELECT gay01, gay03 FROM gay_file
                                      WHERE gayacti = "Y"
                                      ORDER BY gay01 
   IF SQLCA.SQLCODE THEN
      CALL cl_err("gay_file", "lib-044", 1)
      RETURN
   END IF
   LET l_n = 0 
   SELECT COUNT(*) INTO l_n FROM gay_file
     WHERE gay01 = '1' AND gayacti = 'Y'

   LET ps_values = ''
   LET ps_items = ''

   FOREACH p_lang_item_cs INTO pc_gay01, pc_gay03
      IF l_n = 0 OR cl_null(l_n) THEN   #不存在英文則動態入英文選項
         IF pc_gay01 > 1 THEN
            LET ps_values = ps_values, '1,'
            LET ps_items = ps_items,  '1:English,'  
            LET l_n = 1
         END IF
      END IF
      LET ps_values = ps_values, pc_gay01, ','
      LET ps_items = ps_items, pc_gay01, ':', pc_gay03 CLIPPED, ','   
   END FOREACH
   LET ps_values = ps_values.subString(1, ps_values.getLength() - 1)
   LET ps_items = ps_items.subString(1, ps_items.getLength() - 1)
   
   CALL cl_set_combo_items(ps_field_name, ps_values, ps_items)
END FUNCTION
#FUN-C20106 add END 
