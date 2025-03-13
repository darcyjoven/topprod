# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: asdq101.4gl
# Descriptions...: 標準成本工單入庫查詢
# Date & Author..: 00/08/01 By Mandy
# Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
# Modify.........: No.FUN-660120 06/06/16 By CZH cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-C30831 12/03/23 By ck2yuan 加上查詢條件避免查詢失敗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     g_stg   RECORD LIKE stg_file.*,
    g_stg_t RECORD LIKE stg_file.*,
     g_wc,g_sql          string  #No.FUN-580092 HCN
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
 
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-690010 SMALLINT
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0089
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASD")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
    INITIALIZE g_stg.* TO NULL
    INITIALIZE g_stg_t.* TO NULL
#   DECLARE t101_cl CURSOR FOR              # LOCK CURSOR
#       SELECT * FROM stg_file
#       WHERE stg02 = g_stg.stg02 AND stg03 = g_stg.stg03 AND stg04 = g_stg.stg04 AND stg06 = g_stg.stg06
#       FOR UPDATE
    LET p_row = 2 LET p_col = 20
    OPEN WINDOW t101_w AT p_row,p_col
      WITH FORM "asd/42f/asdq101"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
#    CALL t101_q()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL t101_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW t101_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
END MAIN
 
FUNCTION t101_cs()
    CLEAR FORM
   INITIALIZE g_stg.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        	stg01, stg04,
               #sfb05, ima02,                    #MOD-C30831 mark
                sfb05,                           #MOD-C30831 add
                stg02, stg03,
        	stg05, stg051, stg06, stg07, stg20,
        	stg21, stg22 , stg23, stg24, stg25,
        	stg16, stg17 , stg18, stg19,
        	stg12, stg13 , stg14, stg15,
        	stg08, stg09 , stg10, stg11
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      #MOD-530850
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(sfb05)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO sfb05
            NEXT FIELD sfb05
         OTHERWISE
            EXIT CASE
       END CASE
    #--
 
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
    LET g_sql="SELECT stg02,stg03,stg04,stg06,stg05,stg051  ",      #MOD-C30831 add ,stg05,stg051
              "  FROM stg_file ",
              "  LEFT OUTER JOIN sfb_file on stg04=sfb01 ",         #MOD-C30831 add
              " WHERE ",g_wc CLIPPED,
              " ORDER BY stg02,stg03,stg04,stg06 "
    PREPARE t101_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t101_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t101_prepare
   #LET g_sql= "SELECT COUNT(*) FROM stg_file WHERE ",g_wc CLIPPED    #MOD-C30831 mark
    LET g_sql= "SELECT COUNT(*) FROM stg_file ",                      #MOD-C30831 add
               "  LEFT OUTER JOIN sfb_file on stg04=sfb01 ",          #MOD-C30831 add
               " WHERE ",g_wc CLIPPED                                 #MOD-C30831 add
    PREPARE t101_precount FROM g_sql
    DECLARE t101_count CURSOR FOR t101_precount
END FUNCTION
 
FUNCTION t101_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL t101_q()
            END IF
        ON ACTION next
            CALL t101_fetch('N')
        ON ACTION previous
            CALL t101_fetch('P')
        ON ACTION help
                     CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            #EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL t101_fetch('/')
        ON ACTION first
            CALL t101_fetch('F')
        ON ACTION last
            CALL t101_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE t101_cs
END FUNCTION
 
FUNCTION g_stg_zero()
	LET g_stg.stg16 = 0
	LET g_stg.stg17 = 0
	LET g_stg.stg18 = 0
	LET g_stg.stg19 = 0
 
	LET g_stg.stg12 = 0
	LET g_stg.stg13 = 0
	LET g_stg.stg14 = 0
	LET g_stg.stg15 = 0
 
	LET g_stg.stg08 = 0
	LET g_stg.stg09 = 0
	LET g_stg.stg10 = 0
	LET g_stg.stg11 = 0
END FUNCTION
 
FUNCTION t101_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t101_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t101_count
    FETCH t101_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t101_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('open t101_cs:',SQLCA.sqlcode,0)
        INITIALIZE g_stg.* TO NULL
    ELSE
        CALL t101_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t101_fetch(p_flstg)
    DEFINE
        p_flstg         LIKE type_file.chr1,         #No.FUN-690010 VARCHAR(1),
        l_abso          LIKE type_file.num10   #No.FUN-690010 INTEGER
 
    CASE p_flstg
        WHEN 'N' FETCH NEXT     t101_cs INTO g_stg.stg02,
                                             g_stg.stg03,g_stg.stg04,g_stg.stg06,       #MOD-C30831  add ,
                                             g_stg.stg05,g_stg.stg051                   #MOD-C30831  add
        WHEN 'P' FETCH PREVIOUS t101_cs INTO g_stg.stg02,
                                             g_stg.stg03,g_stg.stg04,g_stg.stg06,       #MOD-C30831  add ,
                                             g_stg.stg05,g_stg.stg051                   #MOD-C30831  add
        WHEN 'F' FETCH FIRST    t101_cs INTO g_stg.stg02,
                                             g_stg.stg03,g_stg.stg04,g_stg.stg06,       #MOD-C30831  add ,
                                             g_stg.stg05,g_stg.stg051                   #MOD-C30831  add
        WHEN 'L' FETCH LAST     t101_cs INTO g_stg.stg02,
                                             g_stg.stg03,g_stg.stg04,g_stg.stg06,       #MOD-C30831  add ,
                                             g_stg.stg05,g_stg.stg051                   #MOD-C30831  add
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
            FETCH ABSOLUTE g_jump t101_cs INTO g_stg.stg02,
                                             g_stg.stg03,g_stg.stg04,g_stg.stg06,       #MOD-C30831  add ,
                                             g_stg.stg05,g_stg.stg051                   #MOD-C30831  add
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_stg.stg01,SQLCA.sqlcode,0)
        INITIALIZE g_stg.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flstg
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_stg.* FROM stg_file            # 重讀DB,因TEMP有不被更新特性
       WHERE stg02 = g_stg.stg02 AND stg03 = g_stg.stg03 AND stg04 = g_stg.stg04 AND stg06 = g_stg.stg06
         AND stg05 = g_stg.stg05 AND stg051 = g_stg.stg051                                                    #MOD-C30831  add
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_stg.stg01,SQLCA.sqlcode,0)   #No.FUN-660120
        CALL cl_err3("sel","stg_file",g_stg.stg02,g_stg.stg03,SQLCA.sqlcode,"","",0)   #No.FUN-660120
    ELSE
 
        CALL t101_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t101_show()
    DEFINE l_ima02  LIKE ima_file.ima02
    DEFINE l_sfb05  LIKE sfb_file.sfb05
    LET g_stg_t.* = g_stg.*
    DISPLAY BY NAME
        g_stg.stg01,g_stg.stg04,
        g_stg.stg02,g_stg.stg03,
        g_stg.stg05,g_stg.stg051,g_stg.stg06,g_stg.stg07,g_stg.stg20,
        g_stg.stg21,g_stg.stg22 ,g_stg.stg23,g_stg.stg24,g_stg.stg25,
        g_stg.stg16,g_stg.stg12 ,g_stg.stg08,
        g_stg.stg17,g_stg.stg13 ,g_stg.stg09,
        g_stg.stg18,g_stg.stg14 ,g_stg.stg10,
        g_stg.stg19,g_stg.stg15 ,g_stg.stg11
    LET l_ima02 = NULL
    LET l_sfb05 = NULL
    SELECT sfb05 INTO l_sfb05 FROM sfb_file
        WHERE sfb01 = g_stg.stg04
    SELECT ima02 INTO l_ima02 FROM ima_file
        WHERE ima01 = l_sfb05
    DISPLAY l_sfb05,l_ima02 TO sfb05,ima02
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #
