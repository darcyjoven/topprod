# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: aimt701.4gl
# Descriptions...: 工廠間調撥結案作業
# Date & Author..: 93/07/07 By Apple
# Modify.........: No.FUN-550029 05/05/30 By vivien 單據編號格式放大
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690022 06/09/15 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-770057 07/08/02 By rainy 改為單檔多欄
# Modify.........: No.TQC-950003 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring() 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980093 09/09/22 By TSD.sar2436  GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-A50102 10/06/08 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现 
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_chlang  LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE
    g_imm          RECORD LIKE imm_file.*,
    g_imm_t        RECORD LIKE imm_file.*,
   #FUN-770057 begin
    #g_imn          RECORD LIKE imn_file.*,
    g_imn  DYNAMIC ARRAY OF  RECORD
            imn27      LIKE  imn_file.imn27,
            imn02      LIKE  imn_file.imn02,
            imn03      LIKE  imn_file.imn03,
            ima02      LIKE  ima_file.ima02,
            ima08      LIKE  ima_file.ima08,
            ima05      LIKE  ima_file.ima05,
            imn04      LIKE  imn_file.imn04,
            imn05      LIKE  imn_file.imn05,
            imn06      LIKE  imn_file.imn06,
            imn091     LIKE  imn_file.imn091,
            imn092     LIKE  imn_file.imn092,
            imn07      LIKE  imn_file.imn07,
            imn08      LIKE  imn_file.imn08,
            imn09      LIKE  imn_file.imn09,
            imn11      LIKE  imn_file.imn11,
            imn22      LIKE  imn_file.imn22,
            imn23      LIKE  imn_file.imn23
          END RECORD,
    g_imn_t     RECORD
            imn27      LIKE  imn_file.imn27,
            imn02      LIKE  imn_file.imn02,
            imn03      LIKE  imn_file.imn03,
            ima02      LIKE  ima_file.ima02,
            ima08      LIKE  ima_file.ima08,
            ima05      LIKE  ima_file.ima05,
            imn04      LIKE  imn_file.imn04,
            imn05      LIKE  imn_file.imn05,
            imn06      LIKE  imn_file.imn06,
            imn091     LIKE  imn_file.imn091,
            imn092     LIKE  imn_file.imn092,
            imn07      LIKE  imn_file.imn07,
            imn08      LIKE  imn_file.imn08,
            imn09      LIKE  imn_file.imn09,
            imn11      LIKE  imn_file.imn11,
            imn22      LIKE  imn_file.imn22,
            imn23      LIKE  imn_file.imn23
          END RECORD,
    g_imn041  LIKE imn_file.imn041,   #轉出營運中心
    g_imn151  LIKE imn_file.imn151,   #轉入營運中心
    mi_need_cons     LIKE type_file.num5,
    g_rec_b        LIKE type_file.num5,
    l_ac,l_ac_t    LIKE type_file.num5,
    g_wc,g_sql     STRING, 
    g_row_count    LIKE type_file.num10,
    g_curs_index   LIKE type_file.num10,
    g_cnt          LIKE type_file.num10,
    g_msg          LIKE type_file.chr1000,
    g_jump         LIKE type_file.num10,
    mi_no_ask      LIKE type_file.num5,
   #FUN-770057 end
    g_imm01_t      LIKE imm_file.imm01,
    g_imn01_t      LIKE imn_file.imn01
DEFINE p_row,p_col LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0074
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
 
   LET p_row = 2 LET p_col = 7
 
   OPEN WINDOW t701_w AT p_row,p_col
        WITH FORM "aim/42f/aimt701"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL t701_cur()
   LET mi_need_cons = 1  #讓畫面一開始進去就停在查詢   #FUN-770057
   CALL t701()   #FUN-770057
   #CALL t701_p()     #FUN-770057
   CLOSE WINDOW t701_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
END MAIN
 
#FUN-770057 begin
FUNCTION t701_cs()
  CALL cl_set_act_visible("accept,cancel", TRUE)
  CONSTRUCT g_wc ON imm01 FROM imm01
     BEFORE CONSTRUCT
       CALL cl_qbe_init()
 
     ON ACTION CONTROLP
       CASE
         WHEN INFIELD(imm01)
           CALL cl_init_qry_var()
           LET g_qryparam.form ="q_imm102"
           LET g_qryparam.default1 = g_imm.imm01
           LET g_qryparam.arg1     = "4"
           LET g_qryparam.arg2     = ""
           CALL cl_create_qry() RETURNING g_imm.imm01
           DISPLAY BY NAME g_imm.imm01
           NEXT FIELD imm01
       END CASE
 
     AFTER FIELD imm01   #調撥單號
       IF g_imm.imm01 IS NOT NULL OR g_imm.imm01 != ' ' THEN
            CALL t701_imm01()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_imm.imm01,g_errno,0)
               LET g_imm.imm01 = g_imm01_t
               DISPLAY BY NAME g_imm.imm01
               NEXT FIELD imm01
            END IF
        END IF
        LET g_imm01_t = g_imm.imm01
 
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
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('immuser', 'immgrup') #FUN-980030
  CALL cl_set_act_visible("accept,cancel", FALSE)
 
  IF INT_FLAG THEN
     #LET INT_FLAG = 0
     RETURN
  END IF
  
  LET g_sql = "SELECT UNIQUE  imm01 ",
              "  FROM imm_file, imn_file ",
                  " WHERE imm01 = imn01",
                  "   AND imm10 ='4'",     ##imm10為'4'二階段工廠調撥
                  "   AND ", g_wc CLIPPED 
  PREPARE t701_prepare FROM g_sql
  DECLARE t701_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t701_prepare
END FUNCTION
#FUN-770057 end
 
 
FUNCTION t701_cur()
 DEFINE  l_sql  LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(600)
 
    LET l_sql=
        "SELECT imn_file.* ",
        " FROM  imn_file  ",
        " WHERE imn01= ? ",
        "   AND imn02= ? ",
        "   FOR UPDATE "
    LET l_sql=cl_forupd_sql(l_sql)

    PREPARE imn_p FROM l_sql
    DECLARE imn_lock CURSOR FOR imn_p
END FUNCTION
 
#FUN-770057 begin
FUNCTION t701()
  CLEAR FORM
  WHILE TRUE
     IF (mi_need_cons) THEN
        LET mi_need_cons = 0
        CALL t701_q()
     END IF
     CALL t701_p1()
     IF INT_FLAG THEN EXIT WHILE END IF
     CASE g_action_choice
        WHEN "select_all"   #全部選取
          CALL t701_sel_all('Y')
 
        WHEN "select_non"   #全部不選
          CALL t701_sel_all('N')
        WHEN "closed"
          CALL t701_closed()   #結案
     END CASE
  END WHILE
END FUNCTION
 
FUNCTION t701_p1()
 
 
     LET g_action_choice = " "
     IF g_rec_b = 0 THEN 
        CALL cl_err(g_imm.imm01,'axr-369',1)
        LET mi_need_cons = 1
        RETURN 
     END IF 
     CALL cl_set_act_visible("accept,cancel", FALSE)
 
     INPUT ARRAY g_imn WITHOUT DEFAULTS FROM s_imn.*  #顯示並進行選擇
       ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = FALSE,DELETE ROW = FALSE,APPEND ROW= FALSE)
       BEFORE ROW
         LET l_ac = ARR_CURR()
         #CALL fgl_set_arr_curr(l_ac)
         CALL cl_show_fld_cont()
         LET l_ac_t = l_ac
       ON CHANGE imn27
           IF cl_null(g_imn[l_ac].imn27) THEN
              LET g_imn[l_ac].imn27 = 'Y'
           END IF
 
       ON ACTION query
           LET mi_need_cons = 1
           EXIT INPUT
 
       ON ACTION select_all   #全部選取
           LET g_action_choice="select_all"
           EXIT INPUT
 
       ON ACTION select_non   #全部不選
           LET g_action_choice="select_non"
           EXIT INPUT
 
       ON ACTION closed
           LET g_action_choice="closed"
           EXIT INPUT
 
       ON ACTION help
           CALL cl_show_help()
           EXIT INPUT
 
       ON ACTION controlg
           CALL cl_cmdask()
 
       ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()
 
       ON ACTION exit
           LET g_action_choice="exit"
           EXIT INPUT
 
       ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
       ON ACTION about
           CALL cl_about()
 
     END INPUT
     CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t701_q()
  LET g_row_count = 0
  LET g_curs_index = 0
  CALL cl_navigator_setting( g_curs_index, g_row_count )
  INITIALIZE g_imm.* TO NULL     
  CALL cl_opmsg('q')
  MESSAGE ""
  
  WHILE TRUE
    CLEAR FORM
    CALL g_imn.clear()
    LET  g_rec_b = 0
    CALL t701_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
    END IF
 
    OPEN t701_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
         CALL cl_err('',SQLCA.sqlcode,0)
         INITIALIZE g_imm.* TO NULL
    ELSE
         CALL t701_fetch('F')               # 讀出TEMP第一筆並顯示
         IF NOT cl_null(g_imm.imm01) THEN
            EXIT WHILE
         END IF
    END IF
  END WHILE
END FUNCTION
 
FUNCTION t701_fetch(p_flag)
 DEFINE  p_flag          LIKE type_file.chr1
 
 
  CASE p_flag
     WHEN 'N' FETCH NEXT     t701_cs INTO g_imm.imm01
     WHEN 'P' FETCH PREVIOUS t701_cs INTO g_imm.imm01
     WHEN 'F' FETCH FIRST    t701_cs INTO g_imm.imm01
     WHEN 'L' FETCH LAST     t701_cs INTO g_imm.imm01
     WHEN '/'
         IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0  
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
         FETCH ABSOLUTE g_jump t701_cs INTO g_imm.imm01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)
       INITIALIZE g_imm.* TO NULL  
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
   SELECT * INTO g_imm.* FROM imm_file WHERE imm01=g_imm_imm01
   LET g_data_owner = g_imm.immuser      
   LET g_data_group = g_imm.immgrup      
   LET g_data_plant = g_imm.immplant #FUN-980030
   CALL t701_show()
END FUNCTION
 
FUNCTION t701_show()
  DEFINE
   l_gem02         LIKE gem_file.gem02,
   l_azp02_1       LIKE azp_file.azp02,
   l_azp02_2       LIKE azp_file.azp02,
   l_gen02         LIKE gen_file.gen02
 
   LET g_imm_t.* = g_imm.*                #保存單頭舊值
   DISPLAY BY NAME g_imm.imm01,  g_imm.imm02,  g_imm.imm09,
                   g_imm.immuser,g_imm.immgrup,g_imm.immmodu,
                   g_imm.immdate,g_imm.immacti
   CALL cl_set_field_pic("","","","","",g_imm.immacti)
   CALL t701_imm09(g_imm.imm09)
 
   SELECT DISTINCT imn041,imn151 INTO g_imn041,g_imn151
     FROM imn_file WHERE imn01 = g_imm.imm01
   IF SQLCA.sqlcode  THEN
      CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)
      LET g_imn041 = ''
      LET g_imn151 = ''
      LET l_azp02_1 = ''
      LET l_azp02_2 = ''
   ELSE
      SELECT azp02 INTO l_azp02_1 FROM azp_file
       WHERE azp01 = g_imn041
      SELECT azp02 INTO l_azp02_2 FROM azp_file
       WHERE azp01 = g_imn151
   END IF
   DISPLAY g_imn041 TO imn041
   DISPLAY g_imn151 TO imn151
   DISPLAY l_azp02_1 TO FORMONLY.azp02_1
   DISPLAY l_azp02_2 TO FORMONLY.azp02_2
 
   CALL t701_b_fill()
END FUNCTION
 
 
FUNCTION t701_b_fill()
  LET g_sql="SELECT 'N',   imn02, imn03, ima02,ima08,ima05,imn04,imn05,",
            "       imn06, imn091,imn092,imn07,imn08,imn09,imn11,imn22,imn23",
            "  FROM imn_file,ima_file ",
            " WHERE imn03 = ima01 ",
            "   AND imn01 = '", g_imm.imm01,"'",
            "   AND imn27 = 'N'",
            " ORDER BY imn02 "
  PREPARE t701_bp FROM g_sql
  DECLARE imn_curs CURSOR FOR t701_bp
  
 
  CALL g_imn.clear()
  LET g_cnt = 1
  FOREACH imn_curs INTO g_imn[g_cnt].*
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
    LET g_cnt = g_cnt + 1
    IF g_cnt > g_max_rec THEN
      CALL cl_err( '', 9035, 0 )
      EXIT FOREACH
    END IF
  END FOREACH
  CALL g_imn.deleteElement(g_cnt)
  LET g_rec_b=g_cnt - 1
 
  DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION
 
FUNCTION t701_sel_all(p_flag)
 DEFINE  p_flag   LIKE type_file.chr1
 DEFINE  l_i      LIKE type_file.num5
 FOR l_i = 1 TO g_rec_b
   LET g_imn[l_i].imn27 = p_flag
   DISPLAY BY NAME g_imn[l_i].imn27
 END FOR
END FUNCTION
 
FUNCTION t701_closed()
  IF cl_sure(21,18) THEN
     BEGIN WORK
     LET g_success = 'Y'
     CALL t701_udimn2()
        IF g_success = 'Y'
             THEN CALL cl_cmmsg(1) COMMIT WORK
                  CALL cl_end(20,18)
                  LET mi_need_cons = 1
             ELSE CALL cl_rbmsg(1) ROLLBACK WORK
        END IF
  END IF
END FUNCTION
#FUN-770057 end
 
##FUN-770057 remark
##FUNCTION t701_p()
## DEFINE  l_imm01_t   LIKE imm_file.imm01
##
##    CALL cl_opmsg('a')
##    MESSAGE ""
##    WHILE TRUE
##       LET g_imm_t.* = g_imm.*
##       INITIALIZE g_imm.* TO NULL  # 將變數內容清成空白
##       INITIALIZE g_imn.* TO NULL  # 將變數內容清成空白
##       LET g_success = 'Y'
##       CLEAR FORM                           # 清螢幕欄位內容
##       BEGIN WORK
##       LET g_imm.imm01 = g_imm_t.imm01
##       LET g_imm.imm02 = g_imm_t.imm02
##       LET g_imm.imm09 = g_imm_t.imm09
##       LET g_chlang='N'
##       CALL t701_i()                        # 各欄位輸入
##       IF INT_FLAG THEN                     # 若按了DEL鍵
##          LET INT_FLAG = 0
##          CLEAR FORM
##          EXIT WHILE
##       END IF
##       IF g_chlang='Y' THEN CONTINUE WHILE END IF
##       IF cl_sure(21,18) THEN
##          CALL t701_udimn()
##             IF g_success = 'Y'
##                  THEN CALL cl_cmmsg(1) COMMIT WORK
##                       CALL cl_end(20,18)
##                  ELSE CALL cl_rbmsg(1) ROLLBACK WORK
##             END IF
##       END IF
##    END WHILE
##END FUNCTION
 
##FUN-770057 remark
##FUNCTION t701_i()
##
##  INPUT BY NAME g_imm.imm01,g_imn.imn02
##        WITHOUT DEFAULTS
##
##      ON ACTION locale
##          ROLLBACK WORK
##          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
##          CALL cl_dynamic_locale()
##          CALL cl_set_field_pic("","","","","",g_imm.immacti)
##          LET g_chlang='Y' EXIT INPUT
##
##        AFTER FIELD imm01   #調撥單號
##         IF g_imm.imm01 IS NOT NULL OR g_imm.imm01 != ' ' THEN
##                 CALL t701_imm01()
##                 IF NOT cl_null(g_errno) THEN
##                    CALL cl_err(g_imm.imm01,g_errno,0)
##                    LET g_imm.imm01 = g_imm01_t
##                    DISPLAY BY NAME g_imm.imm01
##                    NEXT FIELD imm01
##                 END IF
##          END IF
##            LET g_imm01_t = g_imm.imm01
##
##        AFTER FIELD imn02                        #調撥單項次
##            IF g_imn.imn02 IS NOT NULL AND
##               g_imn.imn02 != ' ' AND g_imn.imn02 != 0
##            THEN CALL t701_imn02()
##                 IF NOT cl_null(g_errno) THEN
##                    CALL cl_err(g_imn.imn02,g_errno,0)
##                    NEXT FIELD imn02
##                 END IF
##                 IF g_imn.imn11 = 0 AND g_imn.imn23 = 0 THEN
##                    CALL cl_err(g_imn.imn02,'mfg3473',0)
##                 END IF
##            END IF
##
##        AFTER INPUT
##            IF INT_FLAG THEN RETURN END IF
##            IF g_imm.imm01 IS NULL OR g_imm.imm01 = ' ' THEN
##                 NEXT FIELD imm01
##            END IF
##            IF g_imn.imn02 IS NULL OR g_imn.imn02 = ' ' THEN
##                 NEXT FIELD imn02
##            END IF
##
##        ON ACTION controlp
##            CASE
##               WHEN INFIELD(imm01) #調撥單號
##                  CALL cl_init_qry_var()
##                  LET g_qryparam.form ="q_imm102"
##                  LET g_qryparam.default1 = g_imm.imm01
##                  LET g_qryparam.arg1     = "4"
##                  LET g_qryparam.arg2     = ""
##                  CALL cl_create_qry() RETURNING g_imm.imm01
###                  CALL FGL_DIALOG_SETBUFFER( g_imm.imm01 )
##                  DISPLAY BY NAME g_imm.imm01
##                  NEXT FIELD imm01
## 
##               WHEN INFIELD(imn02) #調撥項次
##                  CALL cl_init_qry_var()
##                  LET g_qryparam.form     = "q_imn1"
##                  LET g_qryparam.default1 = g_imm.imm01
##                  IF NOT cl_null(g_imm.imm01) THEN
##                     LET g_qryparam.construct = "N"
##                     LET g_qryparam.where = " imn01='",g_imm.imm01,"'"
##                  END IF
##                  CALL cl_create_qry() RETURNING g_imm.imm01,
##	 				         g_imn.imn02,
##                                                 g_imn.imn03
###                  CALL FGL_DIALOG_SETBUFFER( g_imm.imm01 )
###                  CALL FGL_DIALOG_SETBUFFER( g_imn.imn02 )
###                  CALL FGL_DIALOG_SETBUFFER( g_imn.imn03 )
##                  SELECT imn04,imn05,imn06,imn09
##                    INTO g_imn.imn04,g_imn.imn05,g_imn.imn06,g_imn.imn09
##                    FROM imn_file
##                   WHERE imn27 IN ('N','n') AND imn01 = g_imm.imm01
##                     AND imn02 = g_imn.imn02 AND imn03 = g_imn.imn03
##                  DISPLAY BY NAME g_imn.imn02,g_imn.imn03,
##                                  g_imn.imn04,
##                                  g_imn.imn05,g_imn.imn06,g_imn.imn09
##                  NEXT FIELD imn02
## 
##               OTHERWISE EXIT CASE
##            END CASE
##
##        ON ACTION CONTROLF
##         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
##         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
## 
##   ON ACTION CONTROLR
##      CALL cl_show_req_fields()
##
##         ON ACTION CONTROLG
##            CALL cl_cmdask()
##       ON IDLE g_idle_seconds
##          CALL cl_on_idle()
##          CONTINUE INPUT
## 
##      ON ACTION about         #MOD-4C0121
##         CALL cl_about()      #MOD-4C0121
## 
##      ON ACTION help          #MOD-4C0121
##         CALL cl_show_help()  #MOD-4C0121
## 
## 
##    END INPUT
##END FUNCTION
 
#調撥單號
FUNCTION t701_imm01()
    DEFINE l_immacti LIKE imm_file.immacti
    #01/08/03 mandy 增加有效無效碼的控管
    #         WHERE條件改為imm10='4' 二階段工廠調撥
    LET g_errno = ' '
    SELECT imm02,imm03,imm05,imm06,imm07,imm08,imm09,immacti
      INTO g_imm.imm02,g_imm.imm03,g_imm.imm05,g_imm.imm06,
           g_imm.imm07,g_imm.imm08,g_imm.imm09,l_immacti
      FROM imm_file
     WHERE imm01 = g_imm.imm01 AND imm10 ='4' #imm10為'4'二階段工廠調撥
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3384'
                       LET g_imm.imm02 = NULL LET g_imm.imm03 = NULL
                       LET g_imm.imm07 = NULL LET g_imm.imm08 = NULL
                       LET g_imm.imm09 = NULL
         WHEN g_imm.imm05 != g_imm.imm06 AND g_imm.imm03 = 'Y'
              LET g_errno = 'mfg3459'
         WHEN l_immacti !='Y'
              LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) THEN
       DISPLAY BY NAME g_imm.imm02,g_imm.imm09,
                       g_imm.immuser,g_imm.immgrup,g_imm.immmodu,
                       g_imm.immdate,g_imm.immacti
       CALL cl_set_field_pic("","","","","",g_imm.immacti)
       CALL t701_imm09(g_imm.imm09)
    END IF
END FUNCTION
 
FUNCTION t701_imm09(p_imm09)  #申請人員
    DEFINE p_imm09 LIKE imm_file.imm09,
           l_gen02 LIKE gen_file.gen02,
           l_gen03 LIKE gen_file.gen03,
           l_gem02 LIKE gem_file.gem02,
           l_genacti LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,gen03,genacti
           INTO l_gen02,l_gen03,l_genacti
           FROM gen_file WHERE gen01 = p_imm09
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3096'
                            LET l_gen02 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
	SELECT gem02 INTO l_gem02
		FROM gem_file WHERE gem01=l_gen03
    IF cl_null(g_errno) THEN
       DISPLAY l_gen02 TO FORMONLY.gen02
       DISPLAY l_gen03 TO FORMONLY.gen03
       DISPLAY l_gem02 TO FORMONLY.gem02
    END IF
END FUNCTION
 
##FUN-770057 remark
##FUNCTION t701_imn02()  #調撥項次
##  DEFINE l_ima02    LIKE ima_file.ima02,
##         l_ima05    LIKE ima_file.ima05,
##         l_ima08    LIKE ima_file.ima08,
##         l_imaacti  LIKE ima_file.imaacti
##
##    LET g_errno = ' '
###---->讀取調撥單單身檔(LOCK 此筆資料)，兩工廠的調撥資料皆要(LOCK)
##    OPEN imn_lock USING g_imm.imm01,g_imn.imn02
##    FETCH imn_lock
##        INTO g_imn.*
##    IF SQLCA.sqlcode THEN
##        #---->已被別的使用者鎖住
##        IF SQLCA.sqlcode=-246 OR STATUS =-250 THEN
##            LET g_errno = 'mfg3463'
##        ELSE
##            LET g_errno = 'mfg3464'
##        END IF
##        RETURN
##    END IF
##    IF g_imn.imn27 = 'Y' THEN  LET g_errno ='mfg3488'  RETURN END IF
##
##    DISPLAY BY NAME g_imn.imn03, g_imn.imn041,g_imn.imn04,
##                    g_imn.imn05, g_imn.imn06, g_imn.imn091,
##                    g_imn.imn092,g_imn.imn07, g_imn.imn08,
##                    g_imn.imn09, g_imn.imn11,
##                    g_imn.imn151,g_imn.imn22, g_imn.imn23
## 
##    CALL t701_plantnam('1',g_imn.imn041)
##    CALL t701_plantnam('2',g_imn.imn151)
##
###---->讀取料件主檔相關資料
##    SELECT ima02,ima05,ima08,imaacti
##      INTO l_ima02,l_ima05,l_ima08,l_imaacti
##      FROM ima_file
##      WHERE ima01 = g_imn.imn03
##    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg0002'
##                                  LET l_ima02 = NULL
##         WHEN l_imaacti='N' LET g_errno = '9028'
##    #FUN-690022------mod-------
##         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
##    #FUN-690022------mod-------
##         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
##	END CASE
##    IF cl_null(g_errno) THEN
##       DISPLAY l_ima02 TO FORMONLY.ima02
##       DISPLAY l_ima05 TO FORMONLY.ima05
##       DISPLAY l_ima08 TO FORMONLY.ima08
##    END IF
##END FUNCTION
 
FUNCTION t701_plantnam(p_code,p_plant)
    DEFINE p_code  LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           p_plant LIKE imn_file.imn151,
           l_azp02 LIKE azp_file.azp02,
           l_azp06 LIKE azp_file.azp06,
           l_azp07 LIKE azp_file.azp07
 
    LET g_errno = ' '
 	SELECT azp02,azp06,azp07 INTO l_azp02,l_azp06,l_azp07
                             FROM azp_file
                    		WHERE azp01 = p_plant
 
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg9142'
                                  LET l_azp02 = NULL
                                  LET l_azp06 = NULL
                                  LET l_azp07 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) THEN
       IF p_code = '1' THEN
          DISPLAY l_azp02 TO FORMONLY.azp02_1
       ELSE
          DISPLAY l_azp02 TO FORMONLY.azp02_2
          DISPLAY l_azp06 TO FORMONLY.azp06
          DISPLAY l_azp07 TO FORMONLY.azp07
       END IF
    END IF
END FUNCTION
 
##FUN-770057 begin
#FUNCTION t701_udimn()
#  DEFINE l_sql  LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(600)
#
#    LET l_sql = "UPDATE ",g_dbs CLIPPED,".imn_file",
#                " SET imn27 = 'Y' ",
#                " WHERE imn01= '",g_imm.imm01,"'",
#                "   AND imn02= ",g_imn.imn02 CLIPPED
#    PREPARE imn_up_d1 FROM l_sql
#    EXECUTE imn_up_d1
#    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#       LET g_success='N'
#       CALL cl_err('(s_upimn:ckp#1)',SQLCA.sqlcode,1)
#       RETURN
#    END IF
#
#    IF g_imn.imn041 != g_plant THEN
#         LET g_plant_new = g_imn.imn041
#    ELSE LET g_plant_new = g_imn.imn151
#    END IF
#    IF NOT s_chknplt(g_plant_new,'MFG','MFG') THEN
#       CALL cl_err(g_plant_new,'aom-696',1)
#       LET g_success='N'
#       RETURN
#    END IF
#    LET l_sql = "UPDATE ",g_dbs_new CLIPPED,"imn_file",
#                " SET imn27 = 'Y' ",
#                " WHERE imn01= '",g_imm.imm01,"'",
#                "   AND imn02= ",g_imn.imn02 CLIPPED
#    PREPARE imn_up_d2 FROM l_sql
#    EXECUTE imn_up_d2
#    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#       LET g_success='N'
#       CALL cl_err('(s_upimn:ckp#2)',SQLCA.sqlcode,1)
#       RETURN
#    END IF
#END FUNCTION
 
FUNCTION t701_udimn2()
  DEFINE l_sql  LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(600)
  DEFINE l_i    LIKE type_file.num5
  DEFINE l_dbs_tra     LIKE azw_file.azw05    #FUN-980092 add
  DEFINE l_dbs_tra2    LIKE azw_file.azw05    #FUN-980092 add
  DEFINE l_plant_new   LIKE azp_file.azp01    #FUN-980092 add
  DEFINE l_plant_new2  LIKE azp_file.azp01    #FUN-980092 add
  
 
   #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
   LET g_plant_new = g_plant
   LET l_plant_new = g_plant_new
   CALL s_gettrandbs()
   LET l_dbs_tra = g_dbs_tra
   #--End   FUN-980093 add-------------------------------------
 
    IF g_imn041 != g_plant THEN
         LET g_plant_new = g_imn041
    ELSE LET g_plant_new = g_imn151
    END IF
    IF NOT s_chknplt(g_plant_new,'MFG','MFG') THEN
       CALL cl_err(g_plant_new,'aom-696',1)
       LET g_success='N'
       RETURN
    END IF
 
   #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
   LET l_plant_new2 = g_plant_new
   CALL s_gettrandbs()
   LET l_dbs_tra2 = g_dbs_tra
   #--End   FUN-980093 add-------------------------------------
 
 
#    LET l_sql = "UPDATE ",g_dbs CLIPPED,".imn_file",    #TQC-950003 MARK                                                           
    #LET l_sql = "UPDATE ",s_dbstring(g_dbs),"imn_file",  #TQC-950003 ADD  #FUN-980093 mark 
   #LET l_sql = "UPDATE ",l_dbs_tra CLIPPED,"imn_file",  #TQC-950003 ADD  #FUN-980093 add #FUN-A50102
    LET l_sql = "UPDATE ",cl_get_target_table(l_plant_new,'imn_file'),    #FUN-A50102
                " SET imn27 = 'Y' ",
                " WHERE imn01= ?",
                "   AND imn02= ?"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980093
    PREPARE imn_up_d1 FROM l_sql
 
 
    #LET l_sql = "UPDATE ",g_dbs_new CLIPPED,"imn_file", #FUN-980093 mark
   #LET l_sql = "UPDATE ",l_dbs_tra2 CLIPPED,"imn_file",  #FUN-980093 add   #FUN-A50102
    LET l_sql = "UPDATE ",cl_get_target_table(l_plant_new2,'imn_file'),      #FUN-A50102  
                " SET imn27 = 'Y' ",
                " WHERE imn01= ?",
                "   AND imn02= ?"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,l_plant_new2) RETURNING l_sql #FUN-980093
    PREPARE imn_up_d2 FROM l_sql
 
    FOR  l_i = 1 TO g_rec_b   
       IF g_imn[l_i].imn27 = 'Y' THEN
         EXECUTE imn_up_d1 USING g_imm.imm01,g_imn[l_i].imn02
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            LET g_success='N'
            CALL cl_err('(s_upimn:ckp#1)',SQLCA.sqlcode,1)
            RETURN
         END IF
 
         EXECUTE imn_up_d2 USING g_imm.imm01,g_imn[l_i].imn02
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            LET g_success='N'
            CALL cl_err('(s_upimn:ckp#2)',SQLCA.sqlcode,1)
            RETURN
         END IF
       END IF
    END FOR
END FUNCTION
##FUN-770057
 
#Patch....NO.TQC-610036 <> #
