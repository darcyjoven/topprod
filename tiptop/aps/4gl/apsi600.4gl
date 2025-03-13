# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: apsi600.4gl
# Descriptions...: 料件基本資料檢示/調整
# Date & Author..: 98/04/09 By duke   #FUN-940046 
# Modify.........: No.FUN-B50022 11/05/10 By Mandy---GP5.25 追版:以上為GP5.1 的單號---
# Modify.........: No.FUN-BB0085 11/12/01 By xianghui 增加數量欄位小數取位

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_ima   RECORD LIKE ima_file.*,
    g_ima_t RECORD LIKE ima_file.*,
    g_vmi           RECORD LIKE vmi_file.*,   #FUN-940046  ADD
    g_vmi_t         RECORD LIKE vmi_file.*,   #FUN-940046  ADD
    g_ima01_t      LIKE ima_file.ima01,
    g_wc           STRING,                    
    g_sql          STRING,                    
   #g_ima_rowid    LIKE type_file.chr18,   #FUN-B50022 mark
    g_ima01        LIKE ima_file.ima01,    #FUN-B50022 add
    g_sta          LIKE type_file.chr20   

DEFINE g_forupd_sql          STRING                  #SELECT ... FOR UPDATE NOWAIT SQL  
DEFINE g_forupd_sql2         STRING                  #FUN-940096 ADD
DEFINE g_before_input_done   STRING
DEFINE g_chr                 LIKE type_file.chr1     
DEFINE g_cnt                 LIKE type_file.num10     
DEFINE g_i                   LIKE type_file.num5     #count/index for any purpose #No.FUN-680082 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000 
DEFINE g_row_count           LIKE type_file.num10    
DEFINE g_curs_index          LIKE type_file.num10    
DEFINE g_jump                LIKE type_file.num10    
DEFINE mi_no_ask             LIKE type_file.num5     
DEFINE l_sql            STRING                                                                                                      
DEFINE g_str            STRING                                                                                                      
DEFINE l_table          STRING 
MAIN
    DEFINE p_row,p_col       LIKE type_file.num5     

    #FUN-B50022 ---mod---str---
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
    #FUN-B50022 ---mod---end---

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("APS")) THEN
       EXIT PROGRAM
    END IF
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
    INITIALIZE g_ima.* TO NULL
    INITIALIZE g_ima_t.* TO NULL
    INITIALIZE g_vmi.* TO NULL
    INITIALIZE g_vmi_t.* TO NULL
   #LET g_forupd_sql = "SELECT * FROM ima_file WHERE ROWID = ? FOR UPDATE NOWAIT" #FUN-B50022 mark
    LET g_forupd_sql = "SELECT * FROM ima_file WHERE ima01 = ? FOR UPDATE "       #FUN-B50022 add
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) #FUN-B50022 add
    DECLARE i600_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR


    LET p_row = 4 LET p_col = 3
    OPEN WINDOW i600_w AT p_row,p_col
         WITH FORM "aps/42f/apsi600"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()

      LET g_action_choice=""
    LET g_chkey = 'N'             
    CALL i600_menu()

    CLOSE WINDOW i600_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION i600_cs()
    CLEAR FORM
    INITIALIZE g_ima.* TO NULL   
    INITIALIZE g_vmi.* TO NULL
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
       ima01,ima37,ima139,ima45,ima46,ima47,ima48,
       ima49,ima491,ima50,ima27,ima28,ima64,ima641,ima56,ima561,ima562,ima59,
       ima60,ima61,imauser,imagrup,imamodu,imadate,imaacti
     

       BEFORE CONSTRUCT
          CALL cl_qbe_init()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       ON ACTION qbe_select
          CALL cl_qbe_select()
       ON ACTION qbe_save
          CALL cl_qbe_save()

    END CONSTRUCT

   #LET g_sql="SELECT ROWID,ima01 FROM ima_file  WHERE  ",g_wc CLIPPED #FUN-B50022 mark
    LET g_sql="SELECT ima01 FROM ima_file  WHERE  ",g_wc CLIPPED       #FUN-B50022 add
    PREPARE i600_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i600_cs                           # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i600_prepare

    LET g_sql="SELECT COUNT(*) FROM ima_file  WHERE ",g_wc CLIPPED
    PREPARE i600_precount FROM g_sql
    DECLARE i600_count CURSOR FOR i600_precount
END FUNCTION

FUNCTION i600_menu()
    MENU ""

        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i600_q()
            END IF
        ON ACTION next
            CALL i600_fetch('N')
        ON ACTION previous
            CALL i600_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i600_u()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i600_fetch('/')
        ON ACTION first
            CALL i600_fetch('F')
        ON ACTION last
            CALL i600_fetch('L')

        COMMAND KEY(CONTROL-G)
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION controlg      
           CALL cl_cmdask()    
 
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_ima.ima01 IS NOT NULL THEN
                  LET g_doc.column1 = "ima01"
                  LET g_doc.value1 = g_ima.ima01
                  CALL cl_doc()
               END IF
           END IF

           LET g_action_choice = "exit"
           CONTINUE MENU
 
        -- for Windows close event trapped
        COMMAND KEY(INTERRUPT)
            LET INT_FLAG=FALSE 		
            LET g_action_choice = "exit"
            EXIT MENU

    END MENU
    CLOSE i600_cs
END FUNCTION

FUNCTION i600_i(p_cmd)
    DEFINE p_cmd           LIKE type_file.chr1,    
           l_flag          LIKE type_file.chr1,    
           l_n             LIKE type_file.num5     

    INPUT BY NAME
          g_ima.ima01,g_ima.ima27,g_ima.ima28,g_ima.ima37,g_ima.ima139,g_ima.ima45,
          g_ima.ima46,g_ima.ima47,g_ima.ima48,g_ima.ima49,g_ima.ima491,
          g_ima.ima50,g_ima.ima64,g_ima.ima641,g_ima.ima56,g_ima.ima561,
          g_ima.ima562,g_ima.ima59,g_ima.ima60,g_ima.ima61,
          g_vmi.vmi03,g_vmi.vmi05,g_vmi.vmi08,
          g_vmi.vmi11,g_vmi.vmi15,g_vmi.vmi16,g_vmi.vmi17,
          g_vmi.vmi23,g_vmi.vmi24,
          g_vmi.vmi25,g_vmi.vmi28,g_vmi.vmi35,g_vmi.vmi36,
          g_vmi.vmi37,g_vmi.vmi38,g_vmi.vmi40,g_vmi.vmi44,g_vmi.vmi45,
          g_vmi.vmi47,
          g_vmi.vmi49,g_vmi.vmi50,g_vmi.vmi51,g_vmi.vmi52,g_vmi.vmi53,
          g_vmi.vmi54,g_vmi.vmi55,g_vmi.vmi56,
          g_vmi.vmi60,
          g_vmi.vmi57,
          g_vmi.vmi65  

          WITHOUT DEFAULTS

        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i600_set_entry(p_cmd)
           CALL i600_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE

        AFTER FIELD ima27
            IF g_ima.ima27 IS NULL THEN LET g_ima.ima27=0 END IF
            IF g_ima.ima27<0 THEN
               CALL cl_err(g_ima.ima27,'aim-391',0)
               NEXT FIELD ima27
            END IF
            LET g_ima.ima27 = s_digqty(g_ima.ima27,g_ima.ima25)    #FUN-BB0085
            DISPLAY BY NAME g_ima.ima27                            #FUN-BB0085

        AFTER FIELD ima28
            IF g_ima.ima28 IS NULL THEN LET g_ima.ima28=0 END IF
            IF g_ima.ima28<0 THEN
               CALL cl_err(g_ima.ima28,'aim-391',0)
               NEXT FIELD ima28
            END IF
            LET g_ima.ima28 = s_digqty(g_ima.ima28,g_ima.ima25)    #FUN-BB0085
            DISPLAY BY NAME g_ima.ima28                            #FUN-BB0085

        AFTER FIELD ima37
          IF g_ima.ima37 IS NOT NULL THEN
            IF g_ima.ima37 NOT MATCHES "[012345]"  THEN
               CALL cl_err(g_ima.ima37,'mfg1003',0)
               NEXT FIELD ima37
            END IF
            #CALL s_opc(g_ima.ima37) RETURNING g_sta
            #DISPLAY g_sta TO FORMONLY.ima37_d
            IF g_ima.ima37='0' AND g_ima.ima08 NOT MATCHES '[MPVZ]' THEN
               CALL cl_err(g_ima.ima37,'mfg3201',0)
               NEXT FIELD ima37
            END IF
          END IF

        AFTER FIELD ima45
            IF g_ima.ima45 IS NULL THEN LET g_ima.ima45=0 END IF
            IF g_ima.ima45 < 0 THEN
               CALL cl_err(g_ima.ima45,'mfg0013',0)
               NEXT FIELD ima45
            END IF
            LET g_ima.ima45 = s_digqty(g_ima.ima45,g_ima.ima44)    #FUN-BB0085
            DISPLAY BY NAME g_ima.ima45                            #FUN-BB0085

        AFTER FIELD ima46
            IF g_ima.ima46 < 0 THEN
               CALL cl_err(g_ima.ima46,'mfg0013',0)
               NEXT FIELD ima46
            END IF
            IF g_ima.ima45 != 0 THEN  #採購批量=0時,不控制
               IF g_ima.ima45>1 THEN
                  CALL apsi600_size()
               END IF
            END IF
            LET g_ima.ima46 = s_digqty(g_ima.ima46,g_ima.ima44)    #FUN-BB0085
            DISPLAY BY NAME g_ima.ima46                            #FUN-BB0085

        AFTER FIELD ima47
            IF g_ima.ima47 < 0  OR g_ima.ima47 > 100 THEN
               CALL cl_err(g_ima.ima47,'mfg1332',0)
               NEXT FIELD ima47
            END IF

        AFTER FIELD ima48
            IF g_ima.ima48 < 0 THEN
               CALL cl_err(g_ima.ima48,'mfg0013',0)
               NEXT FIELD ima48
            END IF

        AFTER FIELD ima49
            IF g_ima.ima49 < 0 THEN
               CALL cl_err(g_ima.ima49,'mfg0013',0)
               NEXT FIELD ima49
            END IF

        AFTER FIELD ima491
            IF g_ima.ima491<0 THEN
               CALL cl_err(g_ima.ima491,'mfg0013',0)
               NEXT FIELD ima491
            END IF

        AFTER FIELD ima50
            IF g_ima.ima50 < 0 THEN
               CALL cl_err(g_ima.ima50,'mfg0013',0)
               NEXT FIELD ima50
            END IF

        AFTER FIELD ima56
            IF g_ima.ima56 < 0 THEN
               CALL cl_err(g_ima.ima56,'mfg0013',0)
               NEXT FIELD ima56
            END IF
            LET g_ima.ima56 = s_digqty(g_ima.ima56,g_ima.ima55)    #FUN-BB0085
            DISPLAY BY NAME g_ima.ima56                            #FUN-BB0085

        AFTER FIELD ima561
            IF g_ima.ima561< 0 THEN
               CALL cl_err(g_ima.ima561,'mfg0013',0)
               NEXT FIELD ima561
            END IF
            LET g_ima.ima561 = s_digqty(g_ima.ima561,g_ima.ima55)    #FUN-BB0085
            DISPLAY BY NAME g_ima.ima561                             #FUN-BB0085

        AFTER FIELD ima562
            IF g_ima.ima562< 0 THEN
               CALL cl_err(g_ima.ima562,'mfg0013',0)
               NEXT FIELD ima562
            END IF

        AFTER FIELD ima59
            IF g_ima.ima59 < 0 THEN
               CALL cl_err(g_ima.ima59,'mfg0013',0)
               NEXT FIELD ima59
            END IF

        AFTER FIELD ima60
            IF g_ima.ima60 < 0 THEN
               CALL cl_err(g_ima.ima60,'mfg0013',0)
               NEXT FIELD ima60
            END IF

        AFTER FIELD ima61
            IF g_ima.ima61 < 0 THEN
               CALL cl_err(g_ima.ima61,'mfg0013',0)
               NEXT FIELD ima61
            END IF

        AFTER FIELD ima64
            IF g_ima.ima64 < 0 THEN
               CALL cl_err(g_ima.ima64,'mfg0013',0)
               NEXT FIELD ima64
            END IF
            LET g_ima.ima64 = s_digqty(g_ima.ima64,g_ima.ima63)    #FUN-BB0085
            DISPLAY BY NAME g_ima.ima64                            #FUN-BB0085

        AFTER FIELD ima641
            IF g_ima.ima641 < 0 THEN
               CALL cl_err(g_ima.ima641,'mfg0013',0)
               NEXT FIELD ima641
            END IF
            LET g_ima.ima641 = s_digqty(g_ima.ima641,g_ima.ima63)    #FUN-BB0085
            DISPLAY BY NAME g_ima.ima641                             #FUN-BB0085

        AFTER FIELD vmi03
           IF NOT cl_null(g_vmi.vmi03) THEN
              IF g_vmi.vmi03 NOT MATCHES '[012]' THEN
                 NEXT FIELD vmi03
              END IF
           END IF
           LET g_vmi_t.vmi03 = g_vmi.vmi03

        AFTER FIELD vmi11
            IF NOT cl_null(g_vmi.vmi11) THEN
               IF g_vmi.vmi11 NOT MATCHES '[01]' THEN
                  NEXT FIELD vmi11
               END IF
            END IF
            LET g_vmi_t.vmi11 = g_vmi.vmi11


        AFTER FIELD vmi15
            IF NOT cl_null(g_vmi.vmi15) THEN
               IF g_vmi.vmi15 NOT MATCHES '[01]' THEN
                  NEXT FIELD vmi15
               END IF
            END IF
            LET g_vmi_t.vmi15 = g_vmi.vmi15

        AFTER FIELD vmi65
           IF cl_null(g_vmi.vmi65) OR
              (NOT cl_null(g_vmi.vmi65) AND g_vmi.vmi65<0)  THEN
              CALL cl_err('','aps-406',0)
              NEXT FIELD vmi65
           END IF
           LET g_vmi_t.vmi65 = g_vmi.vmi65

        AFTER FIELD vmi08
           IF cl_null(g_vmi.vmi08) OR
              (NOT cl_null(g_vmi.vmi08) AND g_vmi.vmi08<0)  THEN
              CALL cl_err('','aps-406',0)
              NEXT FIELD vmi08
           END IF
           LET g_vmi_t.vmi08 = g_vmi.vmi08

       AFTER FIELD vmi16
           IF NOT cl_null(g_vmi.vmi16) and g_vmi.vmi16<0 THEN
              CALL cl_err('','aps-406',0)
              NEXT FIELD vmi16
           END IF
           LET g_vmi_t.vmi16 = g_vmi.vmi16
       AFTER FIELD vmi17
          IF NOT cl_null(g_vmi.vmi17) and g_vmi.vmi17<0 THEN
             CALL cl_err('','aps-406',0)
             NEXT FIELD vmi17
          END IF
          LET g_vmi_t.vmi17 = g_vmi.vmi17
       AFTER FIELD vmi24
          IF NOT cl_null(g_vmi.vmi24) and g_vmi.vmi24<0 THEN
             CALL cl_err('','aps-406',0)
             NEXT FIELD vmi24
          END IF
          LET g_vmi_t.vmi24 = g_vmi.vmi24

      AFTER FIELD vmi35
         IF NOT cl_null(g_vmi.vmi35) and g_vmi.vmi35<0 THEN
            CALL cl_err('','aps-406',0)
            NEXT FIELD vmi35
         END IF
         LET g_vmi_t.vmi35 = g_vmi.vmi35

      AFTER FIELD vmi37
         IF NOT cl_null(g_vmi.vmi37) and g_vmi.vmi37<0 THEN
            CALL cl_err('','aps-406',0)
            NEXT FIELD vmi37
         END IF
         LET g_vmi_t.vmi37 = g_vmi.vmi37

      AFTER FIELD vmi38
         IF NOT cl_null(g_vmi.vmi38) and g_vmi.vmi38<0 THEN
            CALL cl_err('','aps-406',0)
            NEXT FIELD vmi38
         END IF
         LET g_vmi_t.vmi38 = g_vmi.vmi38

      AFTER FIELD vmi60
         IF NOT cl_null(g_vmi.vmi60) and g_vmi.vmi60<0 THEN
            CALL cl_err('','aps-406',0)
            NEXT FIELD vmi60
         END IF
         LET g_vmi_t.vmi60 = g_vmi.vmi60


        AFTER INPUT
           LET g_ima.imauser = s_get_data_owner("ima_file") #FUN-C10039
           LET g_ima.imagrup = s_get_data_group("ima_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0)
               NEXT FIELD ima27
            END IF

	ON KEY(F1) NEXT FIELD ima37

        ON KEY(F2) NEXT FIELD ima56

 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION CONTROLF                        # 欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help() 
 
    END INPUT
END FUNCTION

FUNCTION i600_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ima.* TO NULL                         
    INITIALIZE g_vmi.* TO NULL
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i600_cs()                                      #宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN i600_count
    FETCH i600_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i600_cs                                        #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('open i600_cs:',SQLCA.sqlcode,0)
       INITIALIZE g_ima.* TO NULL
       INITIALIZE g_vmi.* TO NULL 
    ELSE
       CALL i600_fetch('F')                              #讀出TEMP第一筆並顯示
    END IF
END FUNCTION

FUNCTION i600_fetch(p_flima)
    DEFINE p_flima          LIKE type_file.chr1,   
            l_abso           LIKE type_file.num10   

    CASE p_flima
        WHEN 'N' FETCH NEXT     i600_cs INTO g_ima.ima01 #FUN-B50022 mod
        WHEN 'P' FETCH PREVIOUS i600_cs INTO g_ima.ima01 #FUN-B50022 mod
        WHEN 'F' FETCH FIRST    i600_cs INTO g_ima.ima01 #FUN-B50022 mod
        WHEN 'L' FETCH LAST     i600_cs INTO g_ima.ima01 #FUN-B50022 mod
        WHEN '/'
            IF (NOT mi_no_ask) THEN       
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
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
            FETCH ABSOLUTE g_jump i600_cs INTO g_ima.ima01 #FUN-B50022 mod
            LET mi_no_ask = FALSE         
    END CASE

    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
       INITIALIZE g_ima.* TO NULL  
       INITIALIZE g_vmi.* TO NULL
      #LET g_ima_rowid = NULL      #FUN-B50022 mark
       RETURN
    ELSE
       CASE p_flima
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF

    SELECT * INTO g_ima.* FROM ima_file            # 重讀DB,因TEMP有不被更新特性
      #WHERE ROWID = g_ima_rowid  #FUN-B50022 mark 
       WHERE ima01 = g_ima.ima01  #FUN-B50022 add

    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
    ELSE
       LET g_data_owner=g_ima.imauser          
       LET g_data_group=g_ima.imagrup
       SELECT * INTO g_vmi.* FROM vmi_file
         WHERE vmi01 = g_ima.ima01
       IF SQLCA.SQLCODE=100 THEN
          LET g_vmi.vmi01 = g_ima.ima01
          LET g_vmi.vmi03 = 0
          LET g_vmi.vmi04 = 0
          LET g_vmi.vmi05 = 0
          LET g_vmi.vmi08 = 999999                       
          LET g_vmi.vmi11 = 0
          LET g_vmi.vmi15 = 0
          LET g_vmi.vmi16 = 999
          LET g_vmi.vmi17 = 999
          LET g_vmi.vmi21 = 0
          LET g_vmi.vmi22 = 0
          LET g_vmi.vmi23 = 0
          LET g_vmi.vmi24 = 1
          LET g_vmi.vmi25 = 0
          LET g_vmi.vmi19 = 0
          LET g_vmi.vmi35 = 0
          LET g_vmi.vmi36 = NULL
          LET g_vmi.vmi37 = 7
          LET g_vmi.vmi38 = 0
          LET g_vmi.vmi40 = NULL
          LET g_vmi.vmi44 = NULL
          LET g_vmi.vmi45 = NULL
          LET g_vmi.vmi47 = 0
          LET g_vmi.vmi49 = 5   
          LET g_vmi.vmi50 = 10    
          LET g_vmi.vmi64 = 0
          LET g_vmi.vmi57 = 1   
          LET g_vmi.vmi56 = 0  
          LET g_vmi.vmi60 = 0 
          LET g_vmi.vmi65 = 0   
          INSERT INTO vmi_file VALUES(g_vmi.*)
          IF STATUS THEN
             CALL cl_err3("ins","vmi_file",g_ima.ima01,"",SQLCA.sqlcode,
                                  "","",1)  
          ELSE
             UPDATE ima_file SET imadate=g_today WHERE ima01 = g_ima.ima01
             SELECT * INTO g_vmi.*  FROM vmi_file
              WHERE vmi01 = g_ima.ima01
          END IF
       END IF
       CALL i600_show()                      # 重新顯示
    END IF
END FUNCTION

FUNCTION i600_show()
    LET g_ima_t.* = g_ima.*
    LET g_vmi_t.* = g_vmi.*
    DISPLAY BY NAME
        g_ima.ima01,g_ima.ima05,g_ima.ima08,g_ima.ima25,g_ima.ima02,
        g_ima.ima021, g_ima.ima03,
        g_ima.ima27,g_ima.ima28,g_ima.ima37,g_ima.ima139,g_ima.ima133,g_ima.ima45,   #FUN-650069 add g_ima.ima133
        g_ima.ima46,g_ima.ima47,g_ima.ima48,g_ima.ima49,g_ima.ima491,
        g_ima.ima50,g_ima.ima56,g_ima.ima561,g_ima.ima562,g_ima.ima59,
        g_ima.ima60,g_ima.ima61,g_ima.ima64,g_ima.ima641,
        g_ima.imauser,g_ima.imagrup,g_ima.imamodu,g_ima.imadate,g_ima.imaacti,
        g_vmi.vmi03,g_vmi.vmi05,g_vmi.vmi08,
        g_vmi.vmi11,g_vmi.vmi15,g_vmi.vmi16,g_vmi.vmi17,
        g_vmi.vmi23,g_vmi.vmi24,
        g_vmi.vmi25,g_vmi.vmi28,g_vmi.vmi35,g_vmi.vmi36,
        g_vmi.vmi37,g_vmi.vmi38,g_vmi.vmi40,g_vmi.vmi44,g_vmi.vmi45,
        g_vmi.vmi47,
        g_vmi.vmi49,g_vmi.vmi50,g_vmi.vmi51,g_vmi.vmi52,g_vmi.vmi53,
        g_vmi.vmi54,g_vmi.vmi55,g_vmi.vmi56,
        g_vmi.vmi60,
        g_vmi.vmi57,
        g_vmi.vmi65  

    CALL cl_show_fld_cont()                   
END FUNCTION

FUNCTION i600_u()
    IF g_ima.ima01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ima01_t = g_ima.ima01
    BEGIN WORK

   #OPEN i600_cl USING g_ima_rowid #FUN-B50022 mark
    OPEN i600_cl USING g_ima.ima01 #FUN-B50022 add
    IF STATUS THEN
       CALL cl_err("OPEN i600_cl:", STATUS, 1)
       CLOSE i600_cl
       ROLLBACK WORK
       RETURN
    END IF
   #FUN-940096  MOD --str--
   #FETCH i600_cl INTO g_ima.*,g_vmi.*               # 對DB鎖定
    FETCH i600_cl INTO g_ima.*
   #FUN-940096  MOD  --END--

    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       RETURN
    END IF
   #FUN-940096  ADD  --STR--
   #LET g_forupd_sql2 = "SELECT * FROM vmi_file WHERE vmi01 = ? FOR UPDATE NOWAIT" #FUN-B50022 mark
    LET g_forupd_sql2 = "SELECT * FROM vmi_file WHERE vmi01 = ? FOR UPDATE "       #FUN-B50022 add
    LET g_forupd_sql2 = cl_forupd_sql(g_forupd_sql2) #FUN-B50022 add
    DECLARE i6002_cl CURSOR FROM g_forupd_sql2              # LOCK CURSOR
    OPEN i6002_cl USING g_ima.ima01
    IF SQLCA.sqlcode THEN
      CALL cl_err("OPEN i6002_cl:", STATUS, 1)
      CLOSE i6002_cl
      ROLLBACK WORK
      RETURN
    END IF
   #FUN-940096  ADD  --END--

    CALL i600_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i600_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ima.*=g_ima_t.*
            LET g_vmi.*=g_vmi_t.*
            CALL i600_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_ima.imamodu = g_user
        LET g_ima.imadate = g_today
        UPDATE ima_file SET ima_file.* = g_ima.*  # 更新DB
           #WHERE ROWID = g_ima_rowid             # COLAUTH? #FUN-B50022 mark
            WHERE ima01 = g_ima.ima01                        #FUN-B50022 add
        UPDATE vmi_file SET vmi_file.* = g_vmi.*
            WHERE vmi01 = g_ima.ima01
        IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","ima_file",g_ima01_t,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
            CONTINUE WHILE
        ELSE
            CALL i600_show()
            MESSAGE 'UPDATE OK!'
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i600_cl
    COMMIT WORK
END FUNCTION

FUNCTION apsi600_size()
DEFINE   l_count         LIKE type_file.num5,    
         l_ima46         LIKE ima_file.ima46

   LET l_count = g_ima.ima46 MOD g_ima.ima45
   IF l_count != 0 THEN
      LET l_count = g_ima.ima46/ g_ima.ima45
      LET l_ima46 = ( l_count + 1 ) * g_ima.ima45
      CALL cl_getmsg('mfg0047',g_lang) RETURNING g_msg
      WHILE g_chr IS NULL OR g_chr NOT MATCHES'[YNyn]'
            LET INT_FLAG = 0  ######add for prompt bug
          PROMPT g_msg CLIPPED,'(',l_ima46,')',':' FOR g_chr
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
 
             ON ACTION about         
                CALL cl_about()      
        
             ON ACTION help          
                CALL cl_show_help()  
        
             ON ACTION controlg      
                CALL cl_cmdask()     
 
          END PROMPT
          IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
      END WHILE
      IF g_chr ='Y' OR g_chr = 'y'  THEN
         LET g_ima.ima46 = l_ima46
         LET g_ima.ima46 = s_digqty(g_ima.ima46,g_ima.ima44)    #FUN-BB0085
      END IF
      DISPLAY BY NAME g_ima.ima46
   END IF
   LET g_chr = NULL
END FUNCTION

FUNCTION i600_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1     

   IF INFIELD(buk_type) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("buk_code",TRUE)
   END IF
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("ima01",TRUE)
   END IF
END FUNCTION

FUNCTION i600_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1      

   IF g_sma.sma31='N' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ima50",FALSE)
   END IF
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("ima01",FALSE)
   END IF
END FUNCTION

