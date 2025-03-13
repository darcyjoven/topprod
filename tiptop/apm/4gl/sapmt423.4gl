# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: sapmt423.4gl
# Descriptions...: 請購單－其他資料維護作業
# Date & Author..: 92/11/18 By Apple
#        Modify..: 94/08/12 By Danny (Add pmk18,pmk31,pmk32,pmk29,pmk26,pmk30)
#                  By Kitty (dele pmk12,13,18,31,32,26,29,41)
# Modify.........: NO.FUN-550060 05/05/31 By jackie 單據編號加大
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pmk01t    LIKE aba_file.aba00,        #No.FUN-550060 	#No.FUN-680136 VARCHAR(5)
    g_pmk       RECORD LIKE pmk_file.*,
    g_pmk_t     RECORD LIKE pmk_file.*,
    g_pmk_o     RECORD LIKE pmk_file.*,
    g_pmk01_t   LIKE pmk_file.pmk01,
    g_argv1     LIKE pmk_file.pmk01        #No.FUN-680136 INTEGER
DEFINE g_msg       LIKE type_file.chr1000      #No.FUN-680136 VARCHAR(72) 

FUNCTION t423(g_argv2,p_pmk01)
    DEFINE g_argv2      LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
           p_pmk01 LIKE pmk_file.pmk01,  
           l_sw         LIKE type_file.num5,     #No.FUN-680136 SMALLINT
           l_chr        LIKE type_file.chr1

    WHENEVER ERROR CONTINUE
 
    INITIALIZE g_pmk.* TO NULL
    INITIALIZE g_pmk_t.* TO NULL
    INITIALIZE g_pmk_o.* TO NULL
    LET g_argv1 = p_pmk01 
 
    OPEN WINDOW t423_w WITH FORM "apm/42f/apmt423" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("apmt423")
 
    SELECT * INTO  g_pmk.* FROM pmk_file WHERE pmk01 = p_pmk01
    IF SQLCA.sqlcode THEN  
       CALL cl_err3("sel","pmk_file",g_pmk.pmk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
       RETURN 
    END IF
    CALL t423_show()
    LET l_sw = 0
    #開立的P/R針對(已核准/已轉PO/結案/取消)的資料無修改權限
    IF (g_argv2 = '0' and g_pmk.pmk25 not matches'[1269]')
       OR (g_argv2 ='0' and g_pmk.pmkmksg = 'N' and 
           g_pmk.pmk25 not matches'[269]')
    THEN 
       CALL t423_u()
       LET l_sw = 1
       IF INT_FLAG THEN LET INT_FLAG = 0 END IF
    END IF
    #已核准的P/R針對(已轉PO/結案/取消)的資料無修改權限
    IF g_argv2 = '1' and g_pmk.pmk25 not matches'[269]' THEN 
       CALL t423_u()
       LET l_sw = 1
       IF INT_FLAG THEN LET INT_FLAG = 0 END IF
    END IF
    IF g_argv2 = '2' and g_pmk.pmk25 not matches'[69]' THEN 
       CALL t423_u()
       LET l_sw = 1
       IF INT_FLAG THEN LET INT_FLAG = 0 END IF
    END IF
    IF NOT l_sw THEN 
       CALL cl_getmsg('mfg6012',g_lang) RETURNING g_msg
       WHILE TRUE
            LET INT_FLAG = 0  ######add for prompt bug
          PROMPT g_msg CLIPPED FOR l_chr   
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
#                CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
          
          END PROMPT
             IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
             EXIT WHILE 
       END WHILE
    END IF
    CLOSE WINDOW t423_w
END FUNCTION
 
FUNCTION t423_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
    INPUT BY NAME
        g_pmk.pmk14,g_pmk.pmk15,g_pmk.pmk16,
        g_pmk.pmk17,g_pmk.pmk30
        WITHOUT DEFAULTS 
 
 {------------ modi by kitty 96-06-06 ---------------------
       AFTER FIELD pmk12
            IF cl_null(g_pmk.pmk12) THEN 
               DISPLAY ' ' TO  FORMONLY.gen02_1
            ELSE IF (g_pmk_o.pmk12 IS NULL) OR
                    (g_pmk.pmk12 != g_pmk_o.pmk12 ) THEN
                     CALL t423_peo('a','1',g_pmk.pmk12)
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_pmk.pmk12,g_errno,0)
                        LET g_pmk.pmk12 = g_pmk_o.pmk12
                        DISPLAY BY NAME g_pmk_o.pmk12 
                        NEXT FIELD pmk12
                     END IF
                 END IF
            END IF  
            LET g_pmk_o.pmk12 = g_pmk.pmk12
 
       AFTER FIELD pmk13
            IF cl_null(g_pmk.pmk13) THEN    #請購部門
               DISPLAY ' ' TO  FORMONLY.gem02_1
            ELSE IF (g_pmk_o.pmk13 IS NULL) OR
                     (g_pmk.pmk13 != g_pmk_o.pmk13 ) THEN
                      CALL t423_dep('a','1',g_pmk.pmk13)
                      IF NOT cl_null(g_errno) THEN
                         CALL cl_err(g_pmk.pmk13,g_errno,0)
                         LET g_pmk.pmk13 = g_pmk_o.pmk13
                         DISPLAY BY NAME g_pmk_o.pmk13 
                         NEXT FIELD pmk13
                     END IF
                 END IF
            END IF  
            LET g_pmk_o.pmk13 = g_pmk.pmk13
  ---------------------------------------------------------- }
 
       AFTER FIELD pmk14
            IF cl_null(g_pmk.pmk14) THEN    #收貨部門
               DISPLAY ' ' TO  FORMONLY.gem02_2
            ELSE IF (g_pmk_o.pmk14 IS NULL) OR
                    (g_pmk.pmk14 != g_pmk_o.pmk14 ) THEN
                     CALL t423_dep('a','2',g_pmk.pmk14)
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_pmk.pmk14,g_errno,0)
                        LET g_pmk.pmk14 = g_pmk_o.pmk14
                        DISPLAY BY NAME g_pmk_o.pmk14 
                        NEXT FIELD pmk14
                     END IF
                 END IF
            END IF  
            LET g_pmk_o.pmk14 = g_pmk.pmk14
 
       AFTER FIELD pmk15
            IF cl_null(g_pmk.pmk15) THEN    #確認人  
               DISPLAY ' ' TO FORMONLY.gen02_2
            ELSE IF (g_pmk_o.pmk15 IS NULL) OR
                    (g_pmk.pmk15 != g_pmk_o.pmk15 ) THEN
                    CALL t423_peo('a','2',g_pmk.pmk15)
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_pmk.pmk15,g_errno,0)
                       LET g_pmk.pmk15 = g_pmk_o.pmk15
                       DISPLAY BY NAME g_pmk_o.pmk15 
                       NEXT FIELD pmk15
                    END IF
                 END IF
            END IF  
            LET g_pmk_o.pmk15 = g_pmk.pmk15
 
{------------------- modi by kitty  96-06-06 --------------
         AFTER FIELD pmk18                       #FOB 條件
             IF NOT cl_null(g_pmk.pmk18 ) THEN 
               IF g_pmk.pmk18 NOT MATCHES '[0123]' THEN
                  CALL cl_err(g_pmk.pmk18,'mfg3016',0)
                  LET g_pmk.pmk18 = g_pmk_o.pmk18
                  DISPLAY BY NAME g_pmk.pmk18 
                  NEXT FIELD pmk18
               END IF
             END IF
             LET g_pmk_o.pmk18 = g_pmk.pmk18
 ---------------------------------------------------------- }
 
       AFTER FIELD pmk17                      #代理商
           IF cl_null(g_pmk.pmk17) THEN
               DISPLAY ' ' TO FORMONLY.pmc03
            ELSE IF (g_pmk_o.pmk17 IS NULL) OR
                    (g_pmk.pmk17 != g_pmk_o.pmk17 ) THEN
                    CALL t423_pmk17('a',g_pmk.pmk17)
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_pmk.pmk17,g_errno,0)
                       LET g_pmk.pmk17 = g_pmk_o.pmk17
                       DISPLAY BY NAME g_pmk_o.pmk17 
                       NEXT FIELD pmk17
                    END IF
                 END IF
            END IF  
 
       AFTER FIELD pmk30                      #印驗收單
           IF NOT cl_null(g_pmk.pmk30 ) THEN
               IF g_pmk.pmk30 NOT MATCHES'[YyNn]' THEN 
                   CALL cl_err(g_pmk.pmk30,'mfg1002',0)
                   LET g_pmk.pmk30 = g_pmk_o.pmk30
                   DISPLAY BY NAME g_pmk.pmk30 
                   NEXT FIELD pmk30
               END IF
               LET g_pmk_o.pmk30= g_pmk.pmk30  
           END IF
 
 
       AFTER INPUT
        IF INT_FLAG THEN                         # 若按了DEL鍵
            CALL cl_err('',9001,0)
            EXIT INPUT 
        END IF
 
        ON ACTION CONTROLP
            CASE
               {--------- modi by kitty 96-06-06 -------------
               WHEN INFIELD(pmk12) #請購員
#                 CALL q_gen(10,3,g_pmk.pmk12) RETURNING g_pmk.pmk12
#                 CALL FGL_DIALOG_SETBUFFER( g_pmk.pmk12 )
                  DISPLAY BY NAME g_pmk.pmk12 
                  NEXT FIELD pmk12
               WHEN INFIELD(pmk13) #請購部門
#                 CALL q_gem(10,3,g_pmk.pmk13) RETURNING g_pmk.pmk13
#                 CALL FGL_DIALOG_SETBUFFER( g_pmk.pmk13 )
                  DISPLAY BY NAME g_pmk.pmk13 
                  NEXT FIELD pmk13
                ----------------------------------------------- }
               WHEN INFIELD(pmk14) #收貨部門
#                 CALL q_gem(10,3,g_pmk.pmk14) RETURNING g_pmk.pmk14
#                 CALL FGL_DIALOG_SETBUFFER( g_pmk.pmk14 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = g_pmk.pmk14
                  CALL cl_create_qry() RETURNING g_pmk.pmk14
#                  CALL FGL_DIALOG_SETBUFFER( g_pmk.pmk14 )
 
                  DISPLAY BY NAME g_pmk.pmk14 
                  NEXT FIELD pmk14
               WHEN INFIELD(pmk15) #確認人
#                 CALL q_gen(10,3,g_pmk.pmk15) RETURNING g_pmk.pmk15
#                 CALL FGL_DIALOG_SETBUFFER( g_pmk.pmk15 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.default1 = g_pmk.pmk15
                  CALL cl_create_qry() RETURNING g_pmk.pmk15
#                  CALL FGL_DIALOG_SETBUFFER( g_pmk.pmk15 )
 
                  DISPLAY BY NAME g_pmk.pmk15 
                  NEXT FIELD pmk15
               WHEN INFIELD(pmk17) #廠商資料
#                 CALL q_pmc1(0,0,g_pmk.pmk17) RETURNING g_pmk.pmk17
#                 CALL FGL_DIALOG_SETBUFFER( g_pmk.pmk17 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmc1"
                  LET g_qryparam.default1 = g_pmk.pmk17
                  CALL cl_create_qry() RETURNING g_pmk.pmk17
#                  CALL FGL_DIALOG_SETBUFFER( g_pmk.pmk17 )
                  DISPLAY BY NAME g_pmk.pmk17 
                  NEXT FIELD pmk17
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
   
FUNCTION t423_dep(p_cmd,p_code,p_key)    
    DEFINE p_cmd     LIKE type_file.chr1,       #No.FUN-680136 VARCHAR(1)
           p_code    LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
           p_key     LIKE gem_file.gem01,
           l_gem02   LIKE gem_file.gem02,
           l_gemacti LIKE gem_file.gemacti
 
  LET g_errno = ' '
  SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file 
           WHERE gem01 = p_key
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                 LET l_gem02 = NULL
         WHEN l_gemacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     IF p_code = '1' THEN 
        DISPLAY l_gem02 TO FORMONLY.gem02_1 
     ELSE 
        DISPLAY l_gem02 TO FORMONLY.gem02_2
     END IF
  END IF
END FUNCTION 
   
FUNCTION t423_peo(p_cmd,p_code,p_key)    #人員
    DEFINE p_cmd       LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
           p_code      LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
           p_key       LIKE gen_file.gen01,
           l_gen02     LIKE gen_file.gen02,
           l_genacti   LIKE gen_file.genacti
 
  LET g_errno = ' '
  SELECT gen02,genacti INTO l_gen02,l_genacti 
        FROM gen_file WHERE gen01 = p_key
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                           LET l_gen02 = NULL
       WHEN l_genacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     IF p_code = '1' THEN 
        DISPLAY l_gen02 TO FORMONLY.gen02_1 
     ELSE 
        DISPLAY l_gen02 TO FORMONLY.gen02_2
     END IF
  END IF
END FUNCTION 
   
FUNCTION t423_show()
# DEFINE  l_str  LIKE apm_file.apm08 	#No.FUN-680136 VARCHAR(10) #No.TQC-6A0079
    LET g_pmk_t.* = g_pmk.*
    DISPLAY BY NAME 
        g_pmk.pmk14,g_pmk.pmk15,g_pmk.pmk16,g_pmk.pmk17,g_pmk.pmk30
        
#   CALL t423_peo('d','1',g_pmk.pmk12)
    CALL t423_peo('d','2',g_pmk.pmk15)
#   CALL t423_dep('d','1',g_pmk.pmk13)
    CALL t423_dep('d','2',g_pmk.pmk14)
#   CALL t423_pmk16('d',g_pmk.pmk16)
    CALL t423_pmk17('d',g_pmk.pmk17)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t423_pmk17(p_cmd,p_key)  #代理商  
 DEFINE p_cmd       LIKE type_file.chr1,      #No.FUN-680136 VARCHAR(1)
        p_key       LIKE pmc_file.pmc01,
        l_pmc03     LIKE pmc_file.pmc03
 
 LET g_errno = " "
   SELECT pmc03 INTO l_pmc03 FROM pmc_file 
    WHERE pmc01 = g_pmk.pmk17  
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY l_pmc03 TO FORMONLY.pmc03 
  END IF
END FUNCTION
 
{------------ modi by kitty 96-06-06 ------------------
FUNCTION t423_pmk26()  #理由碼
  DEFINE  l_azfacti   LIKE azf_file.azfacti
 
 LET g_errno = " "
   SELECT azfacti INTO l_azfacti FROM azf_file 
    WHERE azf01 = g_pmk.pmk26  AND azf02='2'
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3088'
                                   LET l_azfacti = 0   
        WHEN l_azfacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 END FUNCTION
------------------------------------------------------- }
 
FUNCTION t423_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_pmk.pmk01 IS NULL THEN
        CALL cl_err('',-421,0)
        RETURN
    END IF
    IF g_pmk.pmkacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_pmk.pmk01,9027,0)
        RETURN
    END IF
    MESSAGE ""
    LET g_pmk01_t = g_pmk.pmk01
    BEGIN WORK
    WHILE TRUE
        LET g_pmk_o.* = g_pmk.*
        CALL t423_i("u")                         # 欄位更改
        IF INT_FLAG THEN
            LET g_pmk.*=g_pmk_t.*
            CALL t423_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE pmk_file SET pmk_file.* = g_pmk.*    # 更新DB
            WHERE pmk01 = g_pmk.pmk01                 # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_pmk.pmk01,SQLCA.sqlcode,0)   #No.FUN-660129
            CALL cl_err3("upd","pmk_file",g_pmk.pmk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
