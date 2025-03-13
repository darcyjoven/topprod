# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: amdi002.4gl
# Descriptions...: 媒體申報其他資料維護
# Date & Author..: 98/10/27 By Jimmy
# Modify.........: No.FUN-4C0050 04/12/09 By Nicola 權限控管修改
# Modify.........: No.TQC-620014 06/03/02 By Smapmin 新增ame09,ame10,ame11三個欄位
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660093 06/06/15 By xumin  cl_err To cl_err3
# Modify.........: No.FUN-680074 06/08/23 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-6A0150 06/11/15 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-950042 09/06/09 By baofei AFTER FIELD ame03 中g_aem.aem02 應該為g_ame.ame02                               
# Modify.........: No.TQC-980268 09/08/27 By lilingyu "固定資產"等多個欄位對負數未控管 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ame   RECORD LIKE ame_file.*,
    g_ame_t RECORD LIKE ame_file.*,
    g_ame_o RECORD LIKE ame_file.*,
    g_ame01_t LIKE ame_file.ame01,
    g_flag              LIKE type_file.chr1,          #No.FUN-680074 VARCHAR(1)
    g_sw                LIKE type_file.num5,          #No.FUN-680074 SMALLINT
    g_wc,g_sql          STRING                        #No.FUN-580092 HCN        #No.FUN-680074
 
DEFINE g_forupd_sql STRING                          #SELECT ... FOR UPDATE SQL  #No.FUN-680074
DEFINE g_before_input_done   STRING                 #No.FUN-680074
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680074 INTEGER
DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680074 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10         #No.FUN-680074 INTEGER
DEFINE g_curs_index    LIKE type_file.num10         #No.FUN-680074 INTEGER
DEFINE g_jump          LIKE type_file.num10         #No.FUN-680074 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5          #No.FUN-680074 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0068
    DEFINE p_row,p_col     LIKE type_file.num5      #No.FUN-680074 SMALLINT
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("AMD")) THEN
       EXIT PROGRAM
    END IF
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
 
    INITIALIZE g_ame.* TO NULL
    INITIALIZE g_ame_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM ame_file WHERE ame01 = ?  AND ame02 = ? AND ame03 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i002_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 4 LET p_col = 13
    OPEN WINDOW i002_w AT p_row,p_col
        WITH FORM "amd/42f/amdi002"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i002_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i002_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
END MAIN
 
FUNCTION i002_cs()
    CLEAR FORM
   INITIALIZE g_ame.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        ame01,  ame02,  ame03,ame04,
        ameuser, amegrup, amemodu, amedate,ameacti
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
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                 #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND ameuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                 #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND amegrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND amegrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ameuser', 'amegrup')
    #End:FUN-980030
 
    LET g_sql="SELECT ame01,ame02,ame03 FROM ame_file ",
              " WHERE ",g_wc CLIPPED,
              " ORDER BY ame01"
    PREPARE i002_prepare FROM g_sql     # RUNTIME 編譯
    DECLARE i002_cs                     # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i002_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ame_file WHERE ",g_wc CLIPPED
    PREPARE i002_precount FROM g_sql
    DECLARE i002_count CURSOR FOR i002_precount
    OPEN i002_count
    FETCH i002_count INTO g_row_count
    DISPLAY g_row_count TO cnt
END FUNCTION
 
FUNCTION i002_menu()
   DEFINE l_cmd         LIKE type_file.chr1000       #No.FUN-680074 VARCHAR(30)
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i002_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i002_q()
            END IF
        ON ACTION next
            CALL i002_fetch('N')
        ON ACTION previous
            CALL i002_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i002_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i002_r()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_action_choice = "exit"
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i002_fetch('/')
        ON ACTION first
            CALL i002_fetch('F')
        ON ACTION last
            CALL i002_fetch('L')

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
       
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        #No.FUN-6A0150-------add--------str----
        ON ACTION related_document             #相關文件"                        
         LET g_action_choice="related_document"           
            IF cl_chk_act_auth() THEN                     
               IF g_ame.ame01 IS NOT NULL THEN            
                  LET g_doc.column1 = "ame01"               
                  LET g_doc.column2 = "ame02"     
                  LET g_doc.column3 = "ame03"          
                  LET g_doc.value1 = g_ame.ame01            
                  LET g_doc.value2 = g_ame.ame02   
                  LET g_doc.value3 = g_ame.ame03         
                  CALL cl_doc()                             
               END IF                                        
            END IF                                           
         #No.FUN-6A0150-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i002_cs
END FUNCTION
 
 
FUNCTION i002_a()
  DEFINE #l_opc     LIKE apm_file.apm08,     #No.FUN-680074 VARCHAR(10) #No.TQC-6A0079
         l_des      LIKE type_file.chr4      #No.FUN-680074 VARCHAR(04)
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_ame.* TO NULL
    LET g_ame01_t = NULL
    LET g_ame_t.*=g_ame.*
    LET g_ame_o.*=g_ame.*
    LET g_ame.ame01 =NULL
    LET g_ame.ame02  = YEAR(g_today)
    LET g_ame.ame03  = MONTH(g_today)
    LET g_ame.ame04  = 0
    LET g_ame.ame05  = 0
    LET g_ame.ame06  = 0
    LET g_ame.ame07  = 0
    LET g_ame.ame08  = 0
    LET g_ame.ame09  = 0   #TQC-620014
    LET g_ame.ame10  = 0   #TQC-620014
    LET g_ame.ame11  = 0   #TQC-620014
 
    CALL cl_opmsg('a')
    BEGIN WORK
    WHILE TRUE
        LET g_ame.ameacti ='Y'
        LET g_ame.ameuser = g_user
        LET g_ame.ameoriu = g_user #FUN-980030
        LET g_ame.ameorig = g_grup #FUN-980030
        LET g_ame.amegrup = g_grup
        LET g_ame.amedate = g_today
        CALL i002_i("a")                         #各欄位輸入
        IF INT_FLAG THEN                         #若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_ame.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            ROLLBACK WORK
            EXIT WHILE
        END IF
        IF cl_null(g_ame.ame01) IS NULL OR                 # KEY 不可空白
           cl_null(g_ame.ame02) IS NULL OR
           cl_null(g_ame.ame03) IS NULL THEN
            CONTINUE WHILE
        END IF
        INSERT INTO ame_file VALUES(g_ame.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
       #    CALL cl_err(g_ame.ame01,SQLCA.sqlcode,0)
            CALL cl_err3("ins","ame_file",g_ame.ame01,g_ame.ame02,SQLCA.sqlcode,"","",1)   #No.FUN-660093
            CONTINUE WHILE
        END IF
        LET g_ame_t.* = g_ame.*                # 保存上筆資料
        SELECT ame01 INTO g_ame.ame01 FROM ame_file
                    WHERE ame01 = g_ame.ame01
        COMMIT WORK
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i002_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680074 VARCHAR(1)
        l_n             LIKE type_file.num5,          #No.FUN-680074 SMALLINT
        l_ama02      LIKE ama_file.ama02
 
    DISPLAY BY NAME g_ame.ameuser, g_ame.amegrup,
            g_ame.amemodu, g_ame.amedate,g_ame.ameacti
    INPUT BY NAME g_ame.ameoriu,g_ame.ameorig,
        g_ame.ame01, g_ame.ame02, g_ame.ame03,g_ame.ame04,g_ame.ame05,g_ame.ame08,
        #g_ame.ame06, g_ame.ame07   #TQC-620014
        g_ame.ame06, g_ame.ame07, g_ame.ame09, g_ame.ame10, g_ame.ame11   #TQC-620014
 
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i002_set_entry(p_cmd)
            CALL i002_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD ame01
            IF NOT cl_null(g_ame.ame01) THEN
               SELECT ama02 INTO l_ama02 FROM ama_file
                WHERE ama01=g_ame.ame01
               IF SQLCA.sqlcode THEN
           #      CALL cl_err('sel ama',SQLCA.sqlcode,0)
                  CALL cl_err3("sel","ama_file",g_ame.ame01,"",SQLCA.sqlcode,"","sel ama",1)   #No.FUN-660093
                  NEXT FIELD ame01
               END IF
               DISPLAY l_ama02 TO ame01_d
            END IF
 
        AFTER FIELD ame03
#No.TQC-720032 -- begin --
         IF NOT cl_null(g_ame.ame03) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
#              WHERE azm01 = g_aem.aem02    #TQC-950042                                                                             
              WHERE  azm01 = g_ame.ame02    #TQC-950042
            IF g_azm.azm02 = 1 THEN
               IF g_ame.ame03 > 12 OR g_ame.ame03 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD ame03
               END IF
            ELSE
               IF g_ame.ame03 > 13 OR g_ame.ame03 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD ame03
               END IF
            END IF
         END IF
#            IF (g_ame.ame03<1 AND g_ame.ame03>12) THEN
#                NEXT FIELD ame03
#            END IF
#No.TQC-720032 -- end --
            IF NOT cl_null(g_ame.ame03) THEN
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND (g_ame.ame01 != g_ame_t.ame01
                               OR  g_ame.ame02 != g_ame_t.ame02
                               OR  g_ame.ame03 != g_ame_t.ame03)) THEN
                  CALL i002_chk() RETURNING l_n
                  IF l_n > 0 THEN                  # Duplicated
                     CALL cl_err(g_ame.ame03,-239,0)
                     LET g_ame.ame03 = g_ame_t.ame03
                     DISPLAY BY NAME g_ame.ame03
                     NEXT FIELD ame03
                  END IF
               END IF
            END IF
 
#TQC-980268 --begin--
        AFTER FIELD ame02
          IF NOT cl_null(g_ame.ame02) THEN 
             IF g_ame.ame02 < 0 THEN 
                CALL cl_err('','aim-223',0)
                NEXT FIELD ame02
             END IF 
          END IF 
 
        AFTER FIELD ame04
          IF NOT cl_null(g_ame.ame04) THEN 
             IF g_ame.ame04 < 0 THEN 
                CALL cl_err('','aim-223',0)
                NEXT FIELD ame04
             END IF 
          END IF 
 
        AFTER FIELD ame05
          IF NOT cl_null(g_ame.ame05) THEN 
             IF g_ame.ame05 < 0 THEN 
                CALL cl_err('','aim-223',0)
                NEXT FIELD ame05
             END IF 
          END IF 
 
        AFTER FIELD ame06
          IF NOT cl_null(g_ame.ame06) THEN 
             IF g_ame.ame06 < 0 THEN 
                CALL cl_err('','aim-223',0)
                NEXT FIELD ame06
             END IF 
          END IF 
          
        AFTER FIELD ame07
          IF NOT cl_null(g_ame.ame07) THEN 
             IF g_ame.ame07 < 0 THEN 
                CALL cl_err('','aim-223',0)
                NEXT FIELD ame07
             END IF 
          END IF 
          
        AFTER FIELD ame08
          IF NOT cl_null(g_ame.ame08) THEN 
             IF g_ame.ame08 < 0 THEN 
                CALL cl_err('','aim-223',0)
                NEXT FIELD ame08
             END IF 
          END IF 
          
        AFTER FIELD ame09
          IF NOT cl_null(g_ame.ame09) THEN 
             IF g_ame.ame09 < 0 THEN 
                CALL cl_err('','aim-223',0)
                NEXT FIELD ame09
             END IF 
          END IF 
 
        AFTER FIELD ame10
          IF NOT cl_null(g_ame.ame10) THEN 
             IF g_ame.ame10 < 0 THEN 
                CALL cl_err('','aim-223',0)
                NEXT FIELD ame10
             END IF 
          END IF 
 
        AFTER FIELD ame11
          IF NOT cl_null(g_ame.ame11) THEN 
             IF g_ame.ame11 < 0 THEN 
                CALL cl_err('','aim-223',0)
                NEXT FIELD ame11
             END IF 
          END IF                                                                                 
#TQC-980268 --end--
 
        AFTER INPUT
           LET g_ame.ameuser = s_get_data_owner("ame_file") #FUN-C10039
           LET g_ame.amegrup = s_get_data_group("ame_file") #FUN-C10039
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND (g_ame.ame01 != g_ame_t.ame01
                           OR  g_ame.ame02 != g_ame_t.ame02
                           OR  g_ame.ame03 != g_ame_t.ame03)) THEN
               CALL i002_chk() RETURNING l_n
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_ame.ame03,-239,0)
                    LET g_ame.ame01 = g_ame_t.ame01
                    LET g_ame.ame02 = g_ame_t.ame02
                    LET g_ame.ame03 = g_ame_t.ame03
                    DISPLAY BY NAME g_ame.ame01
                    DISPLAY BY NAME g_ame.ame02
                    DISPLAY BY NAME g_ame.ame03
                    NEXT FIELD ame01
                END IF
            END IF
            LET g_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
 
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(ame01) THEN
        #        LET g_ame.* = g_ame_t.*
        #        CALL i002_show()
        #        NEXT FIELD ame01
        #    END IF
        #MOD-650015 --end
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION i002_chk()
  DEFINE l_n     LIKE type_file.num5          #No.FUN-680074 SMALLINT
 
  SELECT count(*) INTO l_n FROM ame_file
      WHERE ame01 = g_ame.ame01  AND
            ame02 = g_ame.ame02  AND
            ame03 = g_ame.ame03
  IF SQLCA.sqlcode THEN
 #     CALL cl_err("count ame",SQLCA.sqlcode,0)   #No.FUN-660093
      CALL cl_err3("sel","ame_file",g_ame.ame01,g_ame.ame02,SQLCA.sqlcode,"","COUNT ame",1)  #No.FUN-660093
  END IF
  RETURN l_n
END FUNCTION
 
FUNCTION i002_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ame.* TO NULL              #No.FUN-6A0150
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i002_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i002_count
    FETCH i002_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i002_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ame.ame01,SQLCA.sqlcode,0)
        INITIALIZE g_ame.* TO NULL
    ELSE
        CALL i002_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i002_fetch(p_flame)
    DEFINE
        p_flame         LIKE type_file.chr1,     #No.FUN-680074 VARCHAR(1)
        l_abso          LIKE type_file.num10     #No.FUN-680074 INTEGER
 
    CASE p_flame
        WHEN 'N' FETCH NEXT     i002_cs INTO g_ame.ame01,
                                             g_ame.ame02,g_ame.ame03
        WHEN 'P' FETCH PREVIOUS i002_cs INTO g_ame.ame01,
                                             g_ame.ame02,g_ame.ame03
        WHEN 'F' FETCH FIRST    i002_cs INTO g_ame.ame01,
                                             g_ame.ame02,g_ame.ame03
        WHEN 'L' FETCH LAST     i002_cs INTO g_ame.ame01,
                                             g_ame.ame02,g_ame.ame03
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump i002_cs INTO g_ame.ame01,
                                                g_ame.ame02,g_ame.ame03
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ame.ame01,SQLCA.sqlcode,0)
        INITIALIZE g_ame.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flame
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_ame.* FROM ame_file
       WHERE ame01 = g_ame.ame01 AND ame02 = g_ame.ame02 AND ame03 = g_ame.ame03 
    IF SQLCA.sqlcode THEN
  #    CALL cl_err(g_ame.ame01,SQLCA.sqlcode,0)
       CALL cl_err3("sel","ame_file",g_ame.ame01,g_ame.ame02,SQLCA.sqlcode,"","",1)   #No.FUN-660093
    ELSE
       LET g_data_owner = g_ame.ameuser     #No.FUN-4C0050
       LET g_data_group = g_ame.amegrup     #No.FUN-4C0050
       CALL i002_show()
    END IF
END FUNCTION
 
FUNCTION i002_show()
  DEFINE l_ama02    LIKE ama_file.ama02
 
    LET g_ame_t.* = g_ame.*
    SELECT ama02 INTO l_ama02 FROM ama_file
           WHERE ama01=g_ame.ame01
    IF SQLCA.sqlcode THEN
 #      CALL cl_err('sel ama',SQLCA.sqlcode,0)
        CALL cl_err3("sel","ama_file",g_ame.ame01,"",SQLCA.sqlcode,"","sel ama",1)       #No.FUN-660093
    END IF
    DISPLAY l_ama02 TO ame01_d
    DISPLAY BY NAME g_ame.ameoriu,g_ame.ameorig,
        g_ame.ame01, g_ame.ame02,g_ame.ame03, g_ame.ame04,g_ame.ame05,g_ame.ame08,
        #g_ame.ame06,g_ame.ame07,g_ame.ameuser,   #TQC-620014
        g_ame.ame06,g_ame.ame07,g_ame.ame09,g_ame.ame10,g_ame.ame11,g_ame.ameuser,   #TQC-620014
        g_ame.amegrup, g_ame.amemodu, g_ame.amedate, g_ame.ameacti
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i002_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_ame.ame01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #-->檢查資料是否為無效
    IF g_ame.ameacti ='N' THEN
        CALL cl_err(g_ame.ame01,'mfg1000',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ame01_t = g_ame.ame01
    BEGIN WORK
    OPEN i002_cl USING g_ame.ame01,g_ame.ame02,g_ame.ame03
    IF STATUS THEN
       CALL cl_err("OPEN i002_cl:", STATUS, 1)
       CLOSE i002_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i002_cl INTO g_ame.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ame.ame01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_ame.amemodu=g_user                     #修改者
    LET g_ame.amedate = g_today                  #修改日期
    CALL i002_show()                          # 顯示最新資料
    WHILE TRUE
        LET g_ame_o.* = g_ame.*
        CALL i002_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ame.*=g_ame_t.*
            CALL i002_show()
            CALL cl_err(g_ame.ame01,9001,0)
            EXIT WHILE
        END IF
        UPDATE ame_file SET ame_file.* = g_ame.*
            WHERE ame01=g_ame_o.ame01 AND ame02=g_ame_o.ame02 AND ame03=g_ame_o.ame03
        IF SQLCA.sqlcode THEN
     #      CALL cl_err(g_ame.ame01,SQLCA.sqlcode,0)
            CALL cl_err3("upd","ame_file",g_ame.ame01,g_ame.ame02,SQLCA.sqlcode,"","",1)   #No.FUN-660093  
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i002_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i002_r()
    DEFINE l_chr LIKE type_file.chr1,          #No.FUN-680074 VARCHAR(1)
           l_cnt LIKE type_file.num5           #No.FUN-680074 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ame.ame01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
    OPEN i002_cl USING g_ame.ame01,g_ame.ame02,g_ame.ame03
    IF STATUS THEN
       CALL cl_err("OPEN i002_cl:", STATUS, 1)
       CLOSE i002_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i002_cl INTO g_ame.*
    IF SQLCA.sqlcode THEN CALL cl_err(g_ame.ame01,SQLCA.sqlcode,0) RETURN END IF
    CALL i002_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ame01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "ame02"         #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "ame03"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ame.ame01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_ame.ame02      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_ame.ame03      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
        DELETE FROM ame_file WHERE ame01=g_ame.ame01 AND ame02=g_ame.ame02 AND ame03=g_ame.ame03
        IF SQLCA.SQLERRD[3]=0 THEN
     #     CALL cl_err(g_ame.ame01,SQLCA.sqlcode,0)
           CALL cl_err3("del","ame_file",g_ame.ame01,g_ame.ame02,SQLCA.sqlcode,"","",1)   #No.FUN-660093
        ELSE
           CLEAR FORM
           INITIALIZE g_ame.* TO NULL
           OPEN i002_count
           FETCH i002_count INTO g_row_count
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN i002_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL i002_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE
              CALL i002_fetch('/')
           END IF
        END IF
    END IF
    CLOSE i002_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i002_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680074 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ame01,ame02,ame03",TRUE)
   END IF
END FUNCTION
 
FUNCTION i002_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680074 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ame01,ame02,ame03",FALSE)
 END IF
END FUNCTION
 

