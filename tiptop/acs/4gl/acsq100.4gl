# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acsq100.4gl
# Descriptions...: 模擬選擇條件狀況查詢
# Date & Author..: 92/01/15 By Nora 
# Modify.........: 92/03/26 By Pin
# Modify.........: No.FUN-660089 06/06/16 By cheunl cl_err --> cl_err3
#
# Modify.........: No.FUN-680071 06/09/08 By chen 類型轉換
# Modify.........: No.FUN-6A0064 06/10/27 By king l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
#       g_csc RECORD
#           csc01   LIKE csc_file.csc01,   # 成本模擬版本代號(0-9)
#           csc02   LIKE csc_file.csc02,   # 模擬日期
#           csc03   LIKE csc_file.csc03,   # 模擬時間
#           csc04   LIKE csc_file.csc04,   # 模擬者
#           csc05   LIKE csc_file.csc05,   # 模擬料件編號範圍
#           csc06   LIKE csc_file.csc06,   # 模擬分群碼範圍
#           csc07   LIKE csc_file.csc07,   # 有效日期
#           csc08   LIKE csc_file.csc08,   # 分群碼使用料件主檔
#           csc09   LIKE csc_file.csc09,   # 製程編號
#           csc10   LIKE csc_file.csc10,   # 採購料件是否使用自製成本計算
#           csc11   LIKE csc_file.csc11,   # 自製料件是否使用採購成本計算
#           csc12   LIKE csc_file.csc12,   # 大宗料件是否iuding
#           csc13   LIKE csc_file.csc13    # 模擬版本描述說明
#       END RECORD,
#       g_csc_t RECORD
#           csc01   LIKE csc_file.csc01,   # 成本模擬版本代號(0-9)
#           csc02   LIKE csc_file.csc02,   # 模擬日期
#           csc03   LIKE csc_file.csc03,   # 模擬時間
#           csc04   LIKE csc_file.csc04,   # 模擬者
#           csc05   LIKE csc_file.csc05,   # 模擬料件編號範圍
#           csc06   LIKE csc_file.csc06,   # 模擬分群碼範圍
#           csc07   LIKE csc_file.csc07,   # 有效日期
#           csc08   LIKE csc_file.csc08,   # 分群碼使用料件主檔
#           csc09   LIKE csc_file.csc09,   # 製程編號
#           csc10   LIKE csc_file.csc10,   # 採購料件是否使用自製成本計算
#           csc11   LIKE csc_file.csc11,   # 自製料件是否使用採購成本計算
#           csc12   LIKE csc_file.csc12,   # 大宗料件是否iuding
#           csc13   LIKE csc_file.csc13    # 模擬版本描述說明
#       END RECORD,
 		g_csc RECORD LIKE csc_file.*,
         g_wc        string,  #No.FUN-580092 HCN
        g_argv1     LIKE csc_file.csc01,      # INPUT ARGUMENT - 1
        g_csc01     LIKE csc_file.csc01,      # 所要查詢的key
         g_sql           string   #No.FUN-580092 HCN
 
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-680071 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-680071 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680071 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-680071 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-680071 SMALLINT
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0064
    DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-680071 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ACS")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0064
    LET g_argv1      = ARG_VAL(1)          #參數值(1)收款客戶編號
 
    LET p_row = 3 LET p_col = 5
    OPEN WINDOW q100_w1 AT p_row,p_col WITH FORM 'acs/42f/acsq100' 
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN
       CALL q100_q()
    END IF
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL q100_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0064
END MAIN
 
#QBE 查詢資料
FUNCTION q100_curs()
    CLEAR FORM                             #清除畫面
 
   INITIALIZE g_csc.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON csc01               # 螢幕上取單頭條件
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
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
    LET g_sql = "SELECT csc01",
                " FROM csc_file",
                " WHERE ",g_wc CLIPPED
    PREPARE q100_prepare FROM g_sql
    DECLARE q100_c1 SCROLL CURSOR FOR q100_prepare
    LET g_sql = " SELECT COUNT(*) FROM csc_file WHERE ",g_wc CLIPPED
    PREPARE q100_precount FROM g_sql
    DECLARE q100_count CURSOR FOR q100_precount
END FUNCTION
 
FUNCTION q100_menu()
    MENU ""
      BEFORE MENU   
         CALL cl_navigator_setting( g_curs_index, g_row_count )
        ON ACTION query 
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                CALL q100_q()
            END IF
        ON ACTION next 
            CALL q100_fetch('N')
        ON ACTION previous 
            CALL q100_fetch('P')
        ON ACTION help 
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#          EXIT MENU
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION jump
            CALL q100_fetch('/')
        ON ACTION first
            CALL q100_fetch('F')
        ON ACTION last
            CALL q100_fetch('L')
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE MENU
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
END FUNCTION
 
#Query 查詢
FUNCTION q100_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    CLEAR FORM
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL q100_curs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN q100_c1                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_csc.* TO NULL
    ELSE
       OPEN q100_count
       FETCH q100_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL q100_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION q100_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  #No.FUN-680071 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數  #No.FUN-680071 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q100_c1 INTO g_csc.csc01 
        WHEN 'P' FETCH PREVIOUS q100_c1 INTO g_csc.csc01 
        WHEN 'F' FETCH FIRST    q100_c1 INTO g_csc.csc01 
        WHEN 'L' FETCH LAST     q100_c1 INTO g_csc.csc01 
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
            FETCH ABSOLUTE g_jump q100_c1 INTO g_csc.csc01 
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       LET g_msg=g_csc.csc01 CLIPPED
       CALL cl_err(g_msg,SQLCA.sqlcode,0)
       INITIALIZE g_csc.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_csc.* FROM csc_file WHERE csc01 = g_csc.csc01
    IF SQLCA.sqlcode THEN
        LET g_msg=g_csc.csc01
#       CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660089
        CALL cl_err3("sel","csc_file",g_msg,"",SQLCA.sqlcode,"","",0)     #No.FUN-660089
        INITIALIZE g_csc.* TO NULL
        RETURN
    END IF
 
    CALL q100_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION q100_show()
    DEFINE   l_msg    LIKE oea_file.oea01    #No.FUN-680071 VARCHAR(12)
	 DISPLAY BY NAME
        g_csc.csc01,g_csc.csc02,g_csc.csc03,g_csc.csc04,g_csc.csc05,
        g_csc.csc06,g_csc.csc07,g_csc.csc08,g_csc.csc09,g_csc.csc10,
        g_csc.csc11,g_csc.csc12,g_csc.csc13,g_csc.csc16
        
    CALL q100_csc04()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q100_csc04()
    DEFINE    l_gen02  LIKE   gen_file.gen02
    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_csc.csc06
                 AND genacti = 'Y'
    IF SQLCA.sqlcode THEN 
       LET l_gen02 = ' '
    END IF
    DISPLAY l_gen02 TO FORMONLY.d01
END FUNCTION
 
