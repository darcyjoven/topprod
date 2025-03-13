# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: afaq200.4gl
# Descriptions...: 固定資產投資抵減查詢
# Date & Author..: 96/06/18 By Sophia
# Modify.........: 97/06/05 By Star Add M. 全部更新
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.MOD-690101 06/10/17 By Smapmin 查詢時,不能抵減原因的開窗應該要能多選
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0208 06/12/30 By wujie   修改部分欄位的帶出值
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_faj      RECORD   LIKE faj_file.*,
    g_faj02_t  LIKE faj_file.faj02,
    g_faj022_t LIKE faj_file.faj022,
    g_faj42_t  LIKE faj_file.faj42,
    g_faj813_t LIKE faj_file.faj813,
    g_faj491_t LIKE faj_file.faj491,
    g_argv1             LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(15)
     g_wc,g_sql          string  #No.FUN-580092 HCN
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680070 INTEGER
MAIN
#    DEFINE l_time          LIKE type_file.chr8         #No.FUN-680070 VARCHAR(8) #NO.FUN-6A0069 
    DEFINE p_row,p_col      LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AFA")) THEN
       EXIT PROGRAM
    END IF
 
 
      CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #NO.FUN-6A0069
    INITIALIZE g_faj.* TO NULL
    LET g_forupd_sql = " SELECT * FROM faj_file WHERE faj01 = ? AND faj02 = ? AND faj022 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE q200_cl CURSOR FROM g_forupd_sql
    LET p_row = 2 LET p_col = 3
    OPEN WINDOW q200_w AT p_row,p_col
        WITH FORM "afa/42f/afaq200"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#    IF cl_chk_act_auth() THEN
#       CALL q200_q()
#    END IF
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL q200_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW q200_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
END MAIN
 
FUNCTION q200_cs()
    CLEAR FORM
    INITIALIZE g_faj.* TO NULL
   INITIALIZE g_faj.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
    faj02, faj022, faj06, faj07, faj08,
    faj04, faj19, faj20, faj17, faj82, faj83,faj25,faj26,faj16,faj15,faj14,
    faj47, faj49, faj45, faj51, faj84, faj85, faj42,
    faj813, faj491,faj80, faj81, faj811, faj812, faj423
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
    ON ACTION controlp
       CASE
           WHEN INFIELD(faj813)    #不能抵減原因
               #CALL q_fai(FALSE,TRUE,g_faj.faj813) RETURNING g_faj.faj813   #MOD-690101
               CALL q_fai(TRUE,TRUE,g_faj.faj813) RETURNING g_qryparam.multiret   #MOD-690101
               #DISPLAY g_faj.faj813 TO faj813   #MOD-690101
               DISPLAY g_qryparam.multiret TO faj813   #MOD-690101
               NEXT FIELD faj813
            OTHERWISE EXIT CASE
        END CASE
      # ON KEY(F1) NEXT FIELD faj04
      # ON KEY(F2) NEXT FIELD faj42
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
    #====>資料權限的檢查
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
 
 
    MESSAGE  'WAIT'
 
    LET g_sql="SELECT faj01,faj02,faj022",
              "  FROM faj_file ",              # 組合出 SQL 指令
              " WHERE faj42 IN ('2','4','6')",
              "   AND ",g_wc CLIPPED
    PREPARE q200_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE q200_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR q200_prepare
 
    LET g_sql="SELECT COUNT(*) ",
              "  FROM faj_file ",
              " WHERE ",g_wc CLIPPED, # 捉出符合QBE條件的
              "   AND faj42 IN ('2','4','6')"
    PREPARE q200_count_pr FROM g_sql                           # row的個數
    DECLARE q200_count CURSOR FOR q200_count_pr
END FUNCTION
 
FUNCTION q200_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL q200_q()
            END IF
            NEXT OPTION "next"
        ON ACTION next
            CALL q200_fetch('N')
        ON ACTION previous
            CALL q200_fetch('P')
        ON ACTION modify
             LET g_action_choice="modify"
             IF cl_chk_act_auth() THEN
                CALL q200_u()
             END IF
            NEXT OPTION "next"
        #@ON ACTION 全部更改
        ON ACTION update_all
             LET g_action_choice="update_all"
             IF cl_chk_act_auth() THEN
                CALL q200_m()
             END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
         ON ACTION jump
            CALL q200_fetch('/')
        ON ACTION first
            CALL q200_fetch('F')
        ON ACTION last
            CALL q200_fetch('L')
 
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
    CLOSE q200_cs
END FUNCTION
 
 
FUNCTION q200_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    CALL q200_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN q200_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_faj.faj02,SQLCA.sqlcode,0)
    ELSE
        OPEN q200_count
        FETCH q200_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL q200_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q200_fetch(p_flfaj)
    DEFINE
        p_flfaj          LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_abso          LIKE type_file.num10        #No.FUN-680070 INTEGER
 
    CASE p_flfaj
      WHEN 'N' FETCH NEXT     q200_cs INTO g_faj.faj01,g_faj.faj02,g_faj.faj022
      WHEN 'P' FETCH PREVIOUS q200_cs INTO g_faj.faj01,g_faj.faj02,g_faj.faj022
      WHEN 'F' FETCH FIRST    q200_cs INTO g_faj.faj01,g_faj.faj02,g_faj.faj022
      WHEN 'L' FETCH LAST     q200_cs INTO g_faj.faj01,g_faj.faj02,g_faj.faj022
      WHEN '/'
        CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
        PROMPT g_msg CLIPPED,': ' FOR l_abso
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
#              CONTINUE PROMPT
 
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
        FETCH ABSOLUTE l_abso q200_cs INTO g_faj.faj01,g_faj.faj02,g_faj.faj022
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_faj.faj02,SQLCA.sqlcode,0)
        INITIALIZE g_faj.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flfaj
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_faj.* FROM faj_file    # 重讀DB,因TEMP有不被更新特性
     WHERE faj01 = g_faj.faj01 AND faj02 = g_faj.faj02 AND faj022 = g_faj.faj022
     IF SQLCA.sqlcode THEN
#        CALL cl_err(g_faj.faj02,SQLCA.sqlcode,0)   #No.FUN-660136
         CALL cl_err3("sel","faj_file",g_faj.faj02,g_faj.faj022,SQLCA.sqlcode,"","",0)   #No.FUN-660136
         RETURN
     END IF
    CALL q200_show()                      # 重新顯示
END FUNCTION
 
FUNCTION q200_i(p_cmd)
   DEFINE   p_cmd    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
            l_flag   LIKE type_file.chr1,    #判斷必要欄位是否有輸入       #No.FUN-680070 VARCHAR(1)
            l_n      LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_gl     LIKE type_file.chr20        #No.FUN-680070 VARCHAR(20)
 
 
   INPUT BY NAME g_faj.faj813,g_faj.faj491 WITHOUT DEFAULTS
 
      AFTER FIELD faj813
         LET g_msg = g_faj.faj813
         IF g_msg[1,1] = '.' THEN
            LET g_msg = g_msg[2,10]
            SELECT fai02 INTO g_faj.faj813 FROM fai_file
             WHERE fai01 = g_msg AND faiacti = 'Y'
            DISPLAY BY NAME g_faj.faj813
            NEXT FIELD faj813
         END IF
 
      ON ACTION mntn_memo_code
               CALL cl_cmdrun('afai070' CLIPPED)
 
      ON ACTION controlp
         CASE
             WHEN INFIELD(faj813)    #不能抵減原因
                 CALL q_fai(FALSE,TRUE,g_faj.faj813) RETURNING g_faj.faj813
#                 CALL FGL_DIALOG_SETBUFFER( g_faj.faj813 )
                 DISPLAY g_faj.faj813 TO faj813
                 NEXT FIELD faj813
              OTHERWISE EXIT CASE
          END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
   END INPUT
END FUNCTION
 
FUNCTION q200_show()
    DEFINE
      l_gl      LIKE type_file.chr20        #No.FUN-680070 VARCHAR(12)
#No.TQC-6C0208--begin                                                                                                               
    DEFINE l_fab02   LIKE fab_file.fab02                                                                                            
    DEFINE l_gen02   LIKE gen_file.gen02                                                                                            
    DEFINE l_gem02   LIKE gem_file.gem02                                                                                            
#No.TQC-6C0208--end 
 
     DISPLAY BY NAME
    g_faj.faj02, g_faj.faj022,g_faj.faj06, g_faj.faj07, g_faj.faj08,
    g_faj.faj04, g_faj.faj25, g_faj.faj26, g_faj.faj20, g_faj.faj19,
    g_faj.faj17, g_faj.faj80, g_faj.faj423,g_faj.faj16,
    g_faj.faj15, g_faj.faj14, g_faj.faj47, g_faj.faj45, g_faj.faj49,
    g_faj.faj51, g_faj.faj42, g_faj.faj491,g_faj.faj813,
    g_faj.faj82, g_faj.faj83, g_faj.faj84, g_faj.faj85, g_faj.faj81,
    g_faj.faj811,g_faj.faj812
    CALL q200_faj42(g_faj.faj42) RETURNING l_gl
    DISPLAY l_gl TO FORMONLY.g1
    OPEN q200_count
    FETCH q200_count INTO g_row_count
    DISPLAY g_row_count TO cnt
#No.TQC-6C0208--begin                                                                                                               
    SELECT fab02 INTO l_fab02 FROM fab_file WHERE fab01 = g_faj.faj04                                                               
    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_faj.faj19                                                               
    SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = g_faj.faj20                                                               
    DISPLAY l_fab02 TO fab02                                                                                                        
    DISPLAY l_gen02 TO gen02                                                                                                        
    DISPLAY l_gem02 TO gem02                                                                                                        
#No.TQC-6C0208--end 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q200_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_faj.faj02 IS NULL THEN     #未先查詢即選UPDATE
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_faj.faj42 not matches '[246]' THEN
       CALL cl_err(g_faj.faj42,'afa-327',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_faj42_t  = g_faj.faj42
    LET g_faj813_t = g_faj.faj813
    LET g_faj491_t = g_faj.faj491
    LET g_success = 'Y'
    BEGIN WORK
    OPEN q200_cl USING g_faj.faj01,g_faj.faj02,g_faj.faj022
    FETCH q200_cl INTO g_faj.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_faj.faj02,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL q200_show()                          # 顯示最新資料
    WHILE TRUE
        CALL q200_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            CALL q200_show()
            CALL cl_err('',9001,0)
            RETURN
        END IF
        UPDATE faj_file SET faj813 = g_faj.faj813,
                            faj491 = g_faj.faj491
         WHERE faj01 = g_faj.faj01 AND faj02 = g_faj.faj02 AND faj022 = g_faj.faj022             # COLAUTH?
        IF SQLCA.sqlcode THEN
            LET g_success = 'N'
#           CALL cl_err(g_faj.faj02,SQLCA.sqlcode,0)   #No.FUN-660136
            CALL cl_err3("upd","faj_file",g_faj.faj01,g_faj.faj02,SQLCA.sqlcode,"","",0)   #No.FUN-660136
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE q200_cl
       IF g_success = 'Y'
          THEN COMMIT WORK
          ELSE ROLLBACK WORK
       END IF
END FUNCTION
 
FUNCTION q200_faj42(l_faj42)   #抵減碼說明
DEFINE
      l_faj42   LIKE faj_file.faj42,
      l_bn       LIKE type_file.chr20        #No.FUN-680070 VARCHAR(20)
 
     CASE l_faj42
         WHEN '0'
            CALL cl_getmsg('afa-076',g_lang) RETURNING l_bn
         WHEN '1'
            CALL cl_getmsg('afa-077',g_lang) RETURNING l_bn
         WHEN '2'
            CALL cl_getmsg('afa-078',g_lang) RETURNING l_bn
         WHEN '3'
            CALL cl_getmsg('afa-079',g_lang) RETURNING l_bn
         WHEN '4'
            CALL cl_getmsg('afa-080',g_lang) RETURNING l_bn
         WHEN '5'
            CALL cl_getmsg('afa-081',g_lang) RETURNING l_bn
         WHEN '6'
            CALL cl_getmsg('afa-082',g_lang) RETURNING l_bn
         OTHERWISE EXIT CASE
      END CASE
      RETURN(l_bn)
END FUNCTION
 
FUNCTION q200_m()
    DEFINE l_faj813     LIKE faj_file.faj813
    DEFINE l_faj        RECORD LIKE faj_file.*
    DEFINE l_n          LIKE type_file.num5         #No.FUN-680070 SMALLINT
    DEFINE p_row,p_col      LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    LET p_row = 6 LET p_col = 50
    OPEN WINDOW q200_m AT p_row,p_col
        WITH FORM "afa/42f/afaq200_m"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("afaq200_m")
 
    IF INT_FLAG THEN CLOSE WINDOW q200_m RETURN END IF
 
   # DISPLAY g_cnt TO FORMONLY.g_cnt
 
    INPUT l_faj813 FROM faj813
 
         AFTER FIELD faj813
            IF cl_null(l_faj813) THEN NEXT FIELD faj813 END IF
            LET g_msg = l_faj813
            IF g_msg[1,1] = '.' THEN
               LET g_msg = g_msg[2,10]
               SELECT fai02 INTO l_faj813 FROM fai_file
                WHERE fai01 = g_msg AND faiacti = 'Y'
               DISPLAY l_faj813 TO FORMONLY.faj813
               NEXT FIELD faj813
            END IF
 
       ON ACTION mntn_memo_code   #不能抵減原因
          CALL cl_cmdrun('afai070' CLIPPED)
 
       ON ACTION controlp
          CASE
              WHEN INFIELD(faj813)    #不能抵減原因
                 CALL q_fai(FALSE,TRUE,g_faj.faj813) RETURNING l_faj813
#                 CALL FGL_DIALOG_SETBUFFER( l_faj813 )
                 DISPLAY l_faj813 TO faj813
                 NEXT FIELD faj813
              OTHERWISE EXIT CASE
          END CASE
 
        AFTER INPUT
          IF INT_FLAG THEN EXIT INPUT END IF
 
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
    IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW q200_m  RETURN END IF
 
    IF NOT cl_sure(0,0) THEN RETURN END IF
    MESSAGE 'Wait ...........'
    # 合併碼 非合併
    LET g_sql = "SELECT faj_file.* FROM faj_file",
                " WHERE faj42 IN ('2','4','6') ",
                "  AND ",g_wc CLIPPED
    PREPARE q200_preparex FROM g_sql      #預備一下
    DECLARE q200_m_cur1 CURSOR FOR q200_preparex
 
    BEGIN WORK LET g_success = 'Y'
    LET l_n = 0
    FOREACH q200_m_cur1 INTO l_faj.*
        IF STATUS THEN
           CALL cl_err('err q200_m_cur1',STATUS,0)
           LET g_success = 'N' EXIT FOREACH
        END IF
##No.2977 modify 1998/12/28
    #   UPDATE faj_file SET faj42 = '0',  #不扺減
##-----------------------
        UPDATE faj_file SET faj813 = l_faj813
         WHERE faj02 = l_faj.faj02 AND faj022 = l_faj.faj022
        IF SQLCA.sqlcode THEN
#          CALL cl_err('err upd faj',STATUS,0)   #No.FUN-660136
           CALL cl_err3("upd","faj_file",l_faj.faj02,l_faj.faj022,STATUS,"","err upd faj",0)   #No.FUN-660136
           LET g_success = 'N' EXIT FOREACH
        END IF
        LET l_n = l_n + 1
    END FOREACH
    IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK  END IF
    MESSAGE ' '
    DISPLAY l_n TO FORMONLY.cnt
    CALL cl_anykey('')
    CLOSE WINDOW q200_m
END FUNCTION
 
