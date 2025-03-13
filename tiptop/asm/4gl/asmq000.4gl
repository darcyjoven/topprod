# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: asmq000.4gl
# Descriptions...: TIPTOP/MFG 目前關閉狀況查詢
# Date & Author..: 93/09/06 By David
# Modify.........: No.MOD-480380 04/08/26 By Nicola Ring Menu出現中文
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740155 07/04/26 By kim zz02以gaz03取代
# Modify.........: No.TQC-750041 07/05/15 By Lynn 筆數欄位位置有誤，被放置到狀態PAGE,且筆數未統計
# Modify.........: No.MOD-890127 08/09/17 By Sarah 將起始日與截止日的default值改為g_today
# Modify.........: No.CHI-960043 09/08/24 By dxfwo  本作業沒有呼叫cl_used(),當啟動aoos010做記錄時,則無法記錄本支作業的異動情況到p_used中
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
     DEFINE
        g_smi     RECORD LIKE smi_file.*,  
        g_smj     RECORD LIKE smj_file.*,  
        tm        RECORD
          a       LIKE type_file.chr1,  #No.FUN-690010  VARCHAR(01),
          date_1  LIKE type_file.dat,   #No.FUN-690010   DATE,
          date_2  LIKE type_file.dat    #No.FUN-690010  DATE
              END RECORD
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-690010 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03  #No.FUN-690010 VARCHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-690010 SMALLINT
MAIN
DEFINE p_row,p_col      LIKE type_file.num5    #No.FUN-690010 SMALLINT
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.CHI-960043
   LET p_row = 6 LET p_col = 15
   OPEN WINDOW asmq000_w AT p_row,p_col WITH FORM "asm/42f/asmq0001" 
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()   #No.MOD-480380
#  CLOSE WINDOW screen
#  CALL cl_ui_locale("asmq0001")
 
   CALL asmq000_q()
   IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW asmq000_w
       EXIT PROGRAM
   END IF
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
   CALL asmq000_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.CHI-960043 
END MAIN    
 
FUNCTION asmq000_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    ON ACTION help 
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        #EXIT MENU
    ON ACTION exit   
        CLOSE WINDOW asmq000_w1
            LET g_action_choice = "exit"
        EXIT MENU
    ON ACTION next 
        CALL asmq000_fetch('N')
    ON ACTION previous 
        CALL asmq000_fetch('P')
    ON ACTION first    
         CALL asmq000_fetch('F')
    ON ACTION last     
         CALL asmq000_fetch('L')
    ON ACTION jump    
         CALL asmq000_fetch('/')
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
            LET g_action_choice = "exit"
          CONTINUE MENU
    
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
END FUNCTION
 
 
FUNCTION asmq000_q()
   DEFINE l_sql            LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(300)
   DEFINE p_row,p_col      LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL asmq000_i()
   IF INT_FLAG THEN
      RETURN
   END IF
   CLOSE WINDOW asmq000_w
   LET p_row = 3 LET p_col = 3
   OPEN WINDOW asmq000_w1 AT p_row,p_col
   WITH FORM "asm/42f/asmq000" 
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   LET l_sql = " SELECT smj01,smj02,smj03,smj04,smj05 FROM smj_file "
   IF tm.a ='1' THEN
      LET l_sql = l_sql CLIPPED,
          " WHERE smj03 >= '",tm.date_1,"'",
          " AND  smj03 <= '",tm.date_2,"'" 
   ELSE
      LET l_sql = l_sql CLIPPED,
          " WHERE smj11 >=  '",tm.date_1,"'",
          " AND  smj11 <= '",tm.date_2,"'" 
   END IF
   PREPARE q000_prepare FROM l_sql           # RUNTIME 編譯
    DECLARE q000_curs  SCROLL CURSOR                 # SCROLL CURSOR
       WITH HOLD   FOR q000_prepare
   LET l_sql = " SELECT COUNT(*) FROM smj_file "
   IF tm.a ='1' THEN
      LET l_sql = l_sql CLIPPED,
          " WHERE smj03 >= '",tm.date_1,"'",
          " AND  smj03 <= '",tm.date_2,"'" 
   ELSE
      LET l_sql = l_sql CLIPPED,
          " WHERE smj11 >=  '",tm.date_1,"'",
          " AND  smj11 <= '",tm.date_2,"'" 
   END IF
   PREPARE q000_precount FROM l_sql
   DECLARE q000_count CURSOR FOR q000_precount
   OPEN q000_count
   FETCH q000_count INTO g_row_count
#  DISPLAY g_cnt TO FORMONLY.g_row_count     # No.TQC-750041
   DISPLAY g_row_count TO FORMONLY.ed15      # No.TQC-750041
   OPEN q000_curs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('Open :',SQLCA.sqlcode,0)
      INITIALIZE g_smj.* TO NULL
   ELSE
      CALL asmq000_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION asmq000_i()
   DEFINE   l_flag   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
     
   LET tm.a = '1'
  #str MOD-890127 mod
  #LET tm.date_1 = '01/01/01'
  #LET tm.date_2 = MDY(12,31,9999)
   LET tm.date_1 = g_today
   LET tm.date_2 = g_today
  #end MOD-890127 mod
#  LET tm.date_2 = DATE(2958464)
 
   DISPLAY BY NAME tm.a,tm.date_1,tm.date_2
 
   INPUT BY NAME tm.a,tm.date_1,tm.date_2 WITHOUT DEFAULTS 
 
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[12]' THEN
            NEXT FIELD a
         END IF
      
      AFTER FIELD date_1
         IF cl_null(tm.date_1) THEN
            NEXT FIELD date_1
         END IF
     
      AFTER FIELD date_2 
         IF cl_null(tm.date_2) THEN
            NEXT FIELD date_2
         END IF
         IF tm.date_1 > tm.date_2 THEN
            CALL cl_err('','mfg9234',1)
            NEXT FIELD date_1
         END IF
 
      AFTER INPUT
         LET l_flag ='N'
         IF INT_FLAG THEN
            RETURN       
         END IF
         IF cl_null(tm.a)  THEN
            DISPLAY BY NAME tm.a 
            LET l_flag = 'Y'
         END IF
         IF cl_null(tm.date_1)  THEN
            DISPLAY BY NAME tm.date_1 
            LET l_flag = 'Y'
         END IF
         IF cl_null(tm.date_2)  THEN
            DISPLAY BY NAME tm.date_2 
            LET l_flag = 'Y'
         END IF
         IF l_flag='Y' THEN    
            CALL cl_err('','9033',0)
            NEXT FIELD a    
         END IF
         IF tm.date_1 > tm.date_2 THEN
            CALL cl_err('','mfg9234',1)
            NEXT FIELD date_1
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
   END INPUT
END FUNCTION
 
FUNCTION asmq000_show()
   #DEFINE l_zz02_1 LIKE zz_file.zz02, #TQC-740155
   #       l_zz02_2 LIKE zz_file.zz02  #TQC-740155
 
    DISPLAY BY NAME g_smj.smj01,g_smj.smj02,g_smj.smj03,g_smj.smj04,
                    g_smj.smj05,g_smj.smj06,g_smj.smj09,g_smj.smj10,
                    g_smj.smj11,g_smj.smj12,g_smj.smj13,g_smj.smj14 
  
   #TQC-740155................begin 此段是amsq000.per才需要的,本程式CALL asmq0001.per
   #SELECT zz02 INTO l_zz02_1
   # FROM zz_file WHERE zz01 = g_smj.smj02
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err('Select zz_file1:',SQLCA.sqlcode,1)  
   #   LET l_zz02_1=' '
   #END IF
   #SELECT zz02 INTO l_zz02_2
   # FROM zz_file WHERE zz01 = g_smj.smj10
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err('Select zz_file1:',SQLCA.sqlcode,1)   
   #   LET l_zz02_2=' '
   #END IF
   #DISPLAY l_zz02_1 TO FORMONLY.p_desc1 
   #DISPLAY l_zz02_2 TO FORMONLY.p_desc2 
   #TQC-740155................end
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION asmq000_fetch(p_flag)
    DEFINE
        p_flag           LIKE type_file.chr1     #No.FUN-690010 VARCHAR(1)
 
    CASE p_flag 
        WHEN 'N' FETCH NEXT     q000_curs INTO  g_smj.smj01,g_smj.smj02,g_smj.smj03,g_smj.smj04,g_smj.smj05
        WHEN 'P' FETCH PREVIOUS q000_curs INTO  g_smj.smj01,g_smj.smj02,g_smj.smj03,g_smj.smj04,g_smj.smj05
        WHEN 'F' FETCH FIRST    q000_curs INTO  g_smj.smj01,g_smj.smj02,g_smj.smj03,g_smj.smj04,g_smj.smj05
        WHEN 'L' FETCH LAST     q000_curs INTO  g_smj.smj01,g_smj.smj02,g_smj.smj03,g_smj.smj04,g_smj.smj05
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
            FETCH ABSOLUTE g_jump q000_curs INTO  g_smj.smj01,g_smj.smj02,g_smj.smj03,g_smj.smj04,g_smj.smj05
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_smj.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_smj.* FROM smj_file
     WHERE smj01=g_smj.smj01 AND smj02=g_smj.smj02 AND smj03=g_smj.smj03 AND smj04=g_smj.smj04 AND smj05=g_smj.smj05
    IF SQLCA.sqlcode THEN
#      CALL cl_err('Select ',SQLCA.sqlcode,0)   #No.FUN-660138
       CALL cl_err3("sel","smj_file",g_smj.smj01,g_smj.smj09,SQLCA.sqlcode,"","",0) #No.FUN-660138
    ELSE
 
    CALL asmq000_show()
    END IF
END FUNCTION
 
