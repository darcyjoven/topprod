# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: asms510.4gl
# Descriptions...: 指定關帳作業
# Date & Author..: 06/02/21 FUN-620048 By TSD.miki
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
   tm       RECORD
            sma51   LIKE sma_file.sma51,
            sma52   LIKE sma_file.sma52,
            sma53   LIKE sma_file.sma53,
            apz57   LIKE apz_file.apz57,
            ooz09   LIKE ooz_file.ooz09,
            nmz10   LIKE nmz_file.nmz10,
            faa09   LIKE faa_file.faa09,
            faa13   LIKE faa_file.faa13
            END RECORD,
   g_aaa    DYNAMIC ARRAY OF RECORD
            aaa01   LIKE aaa_file.aaa01,
            aaa02   LIKE aaa_file.aaa02,
            aaa07   LIKE aaa_file.aaa07
            END RECORD,
   g_rec_b  LIKE type_file.num10, #No.FUN-690010 INTEGER,     #單身筆數
   l_ac     LIKE type_file.num5,      #目前處理的ARRAY CNT   #No.FUN-690010 SMALLINT
   g_cnt    LIKE type_file.num10    #No.FUN-690010   INTEGER                                    #No.FUN-690010 INTEGER
 
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0089
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("ASM")) THEN
       EXIT PROGRAM
    END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #計算使用時間 (進入時間)  #No.FUN-6A0089
 
    LET p_row = 4 LET p_col = 2
    OPEN WINDOW s510_w AT p_row,p_col WITH FORM "asm/42f/asms510" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_init()
 
    CALL s510_q()
    CALL s510_menu()
    CLOSE WINDOW s510_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #計算使用時間 (退出使間)  #No.FUN-6A0089
END MAIN
 
#查詢資料
FUNCTION s510_q()
    CALL cl_opmsg('q')
    INITIALIZE tm.* TO NULL
    LET tm.sma51=g_sma.sma51
    LET tm.sma52=g_sma.sma52
    LET tm.sma53=g_sma.sma53
    SELECT apz57 INTO tm.apz57 FROM apz_file WHERE apz00='0'
    SELECT ooz09 INTO tm.ooz09 FROM ooz_file WHERE ooz00='0'
    SELECT nmz10 INTO tm.nmz10 FROM nmz_file WHERE nmz00='0'
    SELECT faa09,faa13 INTO tm.faa09,tm.faa13 FROM faa_file WHERE faa00='0'
    DISPLAY BY NAME tm.*
    CALL s510_b_fill() #單身
END FUNCTION
 
FUNCTION s510_menu()
   WHILE TRUE
      CALL s510_bp("G")
      CASE g_action_choice
         WHEN "button_asm"                 #庫存關帳
              IF cl_chk_act_auth() THEN
                 CALL cl_cmdrun_wait('asmp620')
                 SELECT sma51,sma52,sma53 INTO tm.sma51,tm.sma52,tm.sma53
                   FROM sma_file WHERE sma00='0'
                 DISPLAY BY NAME tm.sma51,tm.sma52,tm.sma53
              END IF
         WHEN "button_aap"                 #應付關帳
              IF cl_chk_act_auth() THEN
                 CALL cl_cmdrun_wait('aapp500')
                 SELECT apz57 INTO tm.apz57 FROM apz_file WHERE apz00='0'
                 DISPLAY BY NAME tm.apz57
              END IF
         WHEN "button_axr"                 #應收關帳
              IF cl_chk_act_auth() THEN
                 CALL cl_cmdrun_wait('axrp401')
                 SELECT ooz09 INTO tm.ooz09 FROM ooz_file WHERE ooz00='0'
                 DISPLAY BY NAME tm.ooz09
              END IF
         WHEN "button_anm"                 #票據關帳
              IF cl_chk_act_auth() THEN
                 CALL cl_cmdrun_wait('anmp600')
                 SELECT nmz10 INTO tm.nmz10 FROM nmz_file WHERE nmz00='0'
                 DISPLAY BY NAME tm.nmz10
              END IF
         WHEN "button_afa"                 #固資關帳
              IF cl_chk_act_auth() THEN
                 CALL cl_cmdrun_wait('afap010')
                 SELECT faa09,faa13 INTO tm.faa09,tm.faa13 FROM faa_file
                  WHERE faa00='0'
                 DISPLAY BY NAME tm.faa09,tm.faa13
              END IF
         WHEN "button_agl"                 #總帳關帳
              IF cl_chk_act_auth() THEN
                 CALL cl_cmdrun_wait('aglp301')
                 CALL s510_b_fill() #單身
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
 
FUNCTION s510_b_fill()              #BODY FILL UP
    DEFINE l_sql     LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(1000)
 
    LET l_sql = "SELECT aaa01,aaa02,aaa07 FROM aaa_file ORDER BY aaa01"
    PREPARE s510_pb FROM l_sql
    DECLARE s510_bcs CURSOR WITH HOLD FOR s510_pb    #BODY CURSOR
        
    FOR g_cnt = 1 TO g_aaa.getLength()               #單身 ARRAY 乾洗
       INITIALIZE g_aaa[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    FOREACH s510_bcs INTO g_aaa[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
	  EXIT FOREACH
       END IF
    END FOREACH
    CALL g_aaa.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
END FUNCTION
 
FUNCTION s510_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aaa TO s_aaa.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      CALL cl_show_fld_cont()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION button_asm                 #庫存關帳
         LET g_action_choice="button_asm"
         EXIT DISPLAY
 
      ON ACTION button_aap                 #應付關帳
         LET g_action_choice="button_aap"
         EXIT DISPLAY
 
      ON ACTION button_axr                 #應收關帳
         LET g_action_choice="button_axr"
         EXIT DISPLAY
 
      ON ACTION button_anm                 #票據關帳
         LET g_action_choice="button_anm"
         EXIT DISPLAY
 
      ON ACTION button_afa                 #固資關帳
         LET g_action_choice="button_afa"
         EXIT DISPLAY
 
      ON ACTION button_agl                 #總帳關帳
         LET g_action_choice="button_agl"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
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
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
