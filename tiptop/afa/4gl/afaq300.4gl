# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: afaq300.4gl
# Descriptions...: 固定資產相關資料查詢
# Date & Author..: 97/10/03 By Kevin 改自asfq300.4gl
# Modify.........: No:9478 04/04/22 By Kitty FUNCTION q300_2()要加上DISPLAY
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-7B0056 07/11/13 By Rayven 點擊“營運中心切換“到其它庫，資料庫并沒有被切換
# Modify.........: No.FUN-840006 08/04/03 By hellen  項目管理，去掉預算編號相關欄位
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.FUN-B10030 11/01/19 By Mengxw Remove "switch_plant"action
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_faj   RECORD LIKE faj_file.*,
    g_bbb_flag      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_argv1         LIKE faj_file.faj02,
    g_argv2         LIKE faj_file.faj022
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_bookno       LIKE aaa_file.aaa01         #No.TQC-7B0056
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8           #No.FUN-6A0069
    DEFINE p_row,p_col  LIKE type_file.num5         #No.FUN-680070 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
    LET g_argv1=ARG_VAL(1)
    LET g_argv2=ARG_VAL(2)
    LET p_row = 2 LET p_col = 2
 
    OPEN WINDOW t301_w AT p_row,p_col WITH FORM "afa/42f/afaq300"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF g_argv1<>' ' THEN CALL q300_q() END IF
    CALL q300()
    CLOSE WINDOW t301_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
END MAIN
 
FUNCTION q300()
    LET g_wc2=' 1=1'
#No.TQC-7B0056 --start--
#   LET g_forupd_sql = "SELECT * FROM faj_file WHERE faj01 = ? AND faj02 = ? AND faj022 = ? FOR UPDATE"
 
#   DECLARE q300_cl CURSOR FROM g_forupd_sql                   # LOCK CURSOR
    CALL q300_lock_cur()
#No.TQC-7B0056 --end--
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL q300_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
END FUNCTION
 
FUNCTION q300_cs()
    IF g_argv1<>' ' THEN
       LET g_wc=" faj02='",g_argv1,"' AND "," faj022='",g_argv2,"'"
     ELSE
       CLEAR FORM                             #清除畫面
   INITIALIZE g_faj.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
           faj02, faj022, faj06, faj07, faj08, faj20,
           faj17, faj04, faj25, faj26, faj19, faj14
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
       IF INT_FLAG THEN RETURN END IF
    END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND fajuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND fajgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND fajgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')
    #End:FUN-980030
 
    LET g_sql = "SELECT faj01, faj02, faj022 FROM faj_file",
                " WHERE ", g_wc CLIPPED,
                " ORDER BY 2"
 
    PREPARE q300_prepare FROM g_sql
    DECLARE q300_cs SCROLL CURSOR WITH HOLD FOR q300_prepare
 
    LET g_sql="SELECT COUNT(*) FROM faj_file WHERE ",g_wc CLIPPED
    PREPARE q300_precount FROM g_sql
    DECLARE q300_count CURSOR FOR q300_precount
END FUNCTION
 
#中文的MENU
FUNCTION q300_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON ACTION query
              LET g_action_choice="query"
              IF cl_chk_act_auth() THEN
                 CALL q300_q()
              END IF
      ON ACTION next
              CALL q300_fetch('N')
      ON ACTION previous
              CALL q300_fetch('P')
      #@ON ACTION 憑證資料查詢
      ON ACTION query_certificate
              CALL q300_b('1')
      #@ON ACTION 投資抵減資料查詢
      ON ACTION query_investment_crediting
              CALL q300_b('2')
      #@ON ACTION 抵押資料查詢
      ON ACTION query_mortgage
              CALL q300_b('3')
      #@ON ACTION 工廠切換
      #--FUN-B10030--start--
     # ON ACTION switch_plant
#No.TQC-7B0056 --start--
#             CALL cl_cmdrun('aoos901')
     #         CALL q300_chgdbs()
     #--FUN-B10030--end--     
#No.TQC-7B0056 --end--
      ON ACTION help  CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#      EXIT MENU
      ON ACTION exit
            LET g_action_choice = "exit"
       EXIT MENU
      ON ACTION jump
         CALL q300_fetch('/')
      ON ACTION first
         CALL q300_fetch('F')
      ON ACTION last
         CALL q300_fetch('L')
     #COMMAND KEY(CONTROL-G)
      ON ACTION CONTROLG
         CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
            LET g_action_choice = "exit"
          CONTINUE MENU
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
END FUNCTION
 
 
FUNCTION q300_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q300_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 INITIALIZE g_faj.* TO NULL RETURN END IF
    MESSAGE " SEARCHING ! "
    OPEN q300_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_faj.* TO NULL
    ELSE
       OPEN q300_count
       FETCH q300_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q300_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q300_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q300_cs INTO g_faj.faj01,g_faj.faj02,g_faj.faj022
        WHEN 'P' FETCH PREVIOUS q300_cs INTO g_faj.faj01,g_faj.faj02,g_faj.faj022
        WHEN 'F' FETCH FIRST    q300_cs INTO g_faj.faj01,g_faj.faj02,g_faj.faj022
        WHEN 'L' FETCH LAST     q300_cs INTO g_faj.faj01,g_faj.faj02,g_faj.faj022
        WHEN '/'
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR l_abso
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
#                   CONTINUE PROMPT
 
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
            FETCH ABSOLUTE l_abso q300_cs INTO g_faj.faj01,g_faj.faj02,g_faj.faj022
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_faj.faj02,SQLCA.sqlcode,0)
        INITIALIZE g_faj.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_faj.* FROM faj_file WHERE faj01 = g_faj.faj01 AND faj02 = g_faj.faj02 AND faj022 = g_faj.faj022
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_faj.faj02,SQLCA.sqlcode,0)   #No.FUN-660136
        CALL cl_err3("sel","faj_file",g_faj.faj02,"",SQLCA.sqlcode,"","",0)   #No.FUN-660136
        INITIALIZE g_faj.* TO NULL
        RETURN
    END IF
 
    CALL q300_show()
END FUNCTION
 
FUNCTION q300_show()
 DEFINE  l_fab02  LIKE fab_file.fab02,
         l_gen02  LIKE gen_file.gen02,
         l_gem02  LIKE gem_file.gem02
 
    DISPLAY BY NAME
        g_faj.faj02, g_faj.faj022, g_faj.faj06, g_faj.faj07, g_faj.faj08,
        g_faj.faj20, g_faj.faj17,  g_faj.faj04, g_faj.faj25, g_faj.faj26,
        g_faj.faj19, g_faj.faj14
 
    SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=g_faj.faj20
    IF SQLCA.sqlcode THEN LET l_gem02 = '  ' END IF
    DISPLAY l_gem02 TO FORMONLY.gem02
 
    SELECT fab02 INTO l_fab02 FROM fab_file WHERE fab01=g_faj.faj04
    IF SQLCA.sqlcode THEN LET l_fab02 = '  ' END IF
    DISPLAY l_fab02 TO FORMONLY.fab02
 
    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_faj.faj19
    IF SQLCA.sqlcode THEN LET l_gen02 = '  ' END IF
    DISPLAY l_gen02 TO FORMONLY.gen02
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q300_b(p_flag)
   DEFINE p_flag        LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
   LET g_bbb_flag = p_flag
   CASE WHEN g_bbb_flag='1' CALL q300_1()
        WHEN g_bbb_flag='2' CALL q300_2()
        WHEN g_bbb_flag='3' CALL q300_3()
   END CASE
END FUNCTION
 
FUNCTION q300_1()
DEFINE p_row,p_col      LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE ls_tmp STRING
    SELECT * INTO g_faj.* FROM faj_file WHERE faj02 = g_faj.faj02
                                          AND faj022= g_faj.faj022
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_faj.faj02,SQLCA.sqlcode,0)   #No.FUN-660136
        CALL cl_err3("sel","faj_file",g_faj.faj02,g_faj.faj022,SQLCA.sqlcode,"","",0)   #No.FUN-660136
        INITIALIZE g_faj.* TO NULL
        RETURN
    END IF
    LET p_row = 12 LET p_col = 3
    OPEN WINDOW q300_1_w AT p_row,p_col WITH FORM "afa/42f/afaq300_1"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("afaq300_1")
 
    DISPLAY BY NAME g_faj.faj44, g_faj.faj45, g_faj.faj451, g_faj.faj46,
            g_faj.faj461, g_faj.faj47, g_faj.faj471, g_faj.faj48,
            g_faj.faj49,  g_faj.faj51, g_faj.faj52   #No.FUN-840006 080403 去掉g_faj.faj50
    CALL cl_anykey('')
    CLOSE WINDOW q300_1_w
END FUNCTION
 
FUNCTION q300_2()
 DEFINE l_duedate  LIKE type_file.dat,          #No.FUN-680070 DATE
        l_yy,l_mm,l_dd  LIKE type_file.num10        #No.FUN-680070 INTEGER
 DEFINE p_row,p_col     LIKE type_file.num5         #No.FUN-680070 SMALLINT
 DEFINE ls_tmp STRING
 
    SELECT * INTO g_faj.* FROM faj_file WHERE faj02 = g_faj.faj02
                                          AND faj022= g_faj.faj022
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_faj.faj02,SQLCA.sqlcode,0)   #No.FUN-660136
        CALL cl_err3("sel","faj_file",g_faj.faj02,g_faj.faj022,SQLCA.sqlcode,"","",0)   #No.FUN-660136
        INITIALIZE g_faj.* TO NULL
        RETURN
    END IF
    LET p_row = 12 LET p_col = 3
    OPEN WINDOW q300_2_w AT p_row,p_col WITH FORM "afa/42f/afaq300_2"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("afaq300_2")
 
 
    DISPLAY g_faj.faj80, g_faj.faj42, g_faj.faj813,
            g_faj.faj423, g_faj.faj811, g_faj.faj812,
            g_faj.faj82, g_faj.faj83, g_faj.faj84, g_faj.faj85 TO     #No:9478
            faj80, faj42, faj813, faj423, faj811, faj812 ,
            faj82, faj83, faj84, faj85                                #No:9478
    LET l_yy = YEAR(g_faj.faj26)
    LET l_mm = MONTH(g_faj.faj26)
    LET l_dd = DAY(g_faj.faj26)
    LET l_duedate =  MDY(l_mm,l_dd,l_yy + 3)
    DISPLAY l_duedate TO FORMONLY.duedate
 
    CALL cl_anykey('')
    CLOSE WINDOW q300_2_w
END FUNCTION
 
FUNCTION q300_3()
DEFINE p_row,p_col      LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE ls_tmp STRING
    SELECT * INTO g_faj.* FROM faj_file WHERE faj02 = g_faj.faj02
                                          AND faj022= g_faj.faj022
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_faj.faj02,SQLCA.sqlcode,0)   #No.FUN-660136
        CALL cl_err3("sel","faj_file",g_faj.faj02,g_faj.faj022,SQLCA.sqlcode,"","",0)   #No.FUN-660136
        INITIALIZE g_faj.* TO NULL
        RETURN
    END IF
    LET p_row = 12 LET p_col = 3
    OPEN WINDOW q300_3_w AT p_row,p_col WITH FORM "afa/42f/afaq300_3"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("afaq300_3")
 
 
    DISPLAY BY NAME g_faj.faj86, g_faj.faj87, g_faj.faj91, g_faj.faj90,
            g_faj.faj88, g_faj.faj89
    CALL cl_anykey('')
    CLOSE WINDOW q300_3_w
END FUNCTION
 
#No.TQC-7B0056 --start--
#--FUN-B10030--start--
#FUNCTION q300_chgdbs()
#  DEFINE l_dbs   LIKE type_file.chr21
#  DEFINE l_cnt   LIKE type_file.num5
 
#    CALL cl_getmsg('aom-303',g_lang) RETURNING g_msg
#    PROMPT g_msg FOR g_plant
#       ON IDLE g_idle_seconds
#         CALL cl_on_idle()
 
#       ON ACTION about 
#         CALL cl_about()
 
#      ON ACTION help
#         CALL cl_show_help()
                                                                                                                                    
#      ON ACTION controlg
#         CALL cl_cmdask()
 
#   END PROMPT
#   IF g_plant IS NULL THEN RETURN END IF
#   LET l_cnt = 0
#   SELECT COUNT(*) INTO l_cnt FROM zxy_file
#     WHERE zxy01 = g_user AND zxy03 = g_plant
#   IF l_cnt = 0 THEN 
#      CALL cl_err(g_user,'sub-118',1)
#      RETURN
#   END IF
#   SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_plant
#   IF STATUS THEN ERROR 'WRONG database!' RETURN END IF 
#   CALL cl_ins_del_sid(2) #FUN-980030    #FUN-990069
#   CALL cl_ins_del_sid(2,'') #FUN-980030    #FUN-990069
#   CLOSE DATABASE
#   DATABASE l_dbs
 #  CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
#   CALL cl_ins_del_sid(1,g_plant) #FUN-980030  #FUN-990069
#   IF STATUS THEN ERROR 'open database error!' RETURN END IF
#   LET g_plant = g_plant
#   LET g_dbs   = l_dbs
#   SELECT aaz64 INTO g_bookno FROM aaz_file 
#   CURRENT WINDOW IS SCREEN 
#   CALL s_dsmark(g_bookno)
#   CALL cl_dsmark(0)
#   CURRENT WINDOW IS t301_w
#   CLEAR FORM
#   CALL s_shwact(3,2,g_bookno)
#   CALL q300_lock_cur()
#END FUNCTION
#--FUN-B10030--end-- 
FUNCTION q300_lock_cur()
   LET g_forupd_sql = "SELECT * FROM faj_file WHERE faj01 = ? AND faj02 = ? AND faj022 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE q300_cl CURSOR FROM g_forupd_sql
END FUNCTION
#No.TQC-7B0056 --end--
