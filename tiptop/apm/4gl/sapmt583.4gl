# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: sapmt583.4gl
# Descriptions...: 無交期採購單－其他資料維護作業
# Date & Author..: 92/11/18 By Apple
# Modify ........: 01/03/30 BY Kammy
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/06 By Jackho 欄位類型修改
# Modify.........: No.TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pom        RECORD LIKE pom_file.*,
    g_pom_t      RECORD LIKE pom_file.*,
    g_pom_o      RECORD LIKE pom_file.*,
    g_pom01_t    LIKE pom_file.pom01,
    g_argv1      LIKE pom_file.pom01
DEFINE g_msg        LIKE ze_file.ze03            #No.FUN-680136 VARCHAR(72)

FUNCTION t583(g_argv2,p_pom01)
DEFINE 
    p_pom01      LIKE pom_file.pom01,
    g_argv2      LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
    l_sw         LIKE type_file.num5,         #No.FUN-680136 SMALLINT
    l_chr        LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)

    WHENEVER ERROR CONTINUE
 
    INITIALIZE g_pom.* TO NULL
    INITIALIZE g_pom_t.* TO NULL
    INITIALIZE g_pom_o.* TO NULL
    LET g_argv1 = p_pom01 

    OPEN WINDOW t583_w WITH FORM "apm/42f/apmt583" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("apmt583")
 
    SELECT * INTO  g_pom.* FROM pom_file WHERE pom01 = g_argv1
    IF SQLCA.sqlcode THEN  
       CALL cl_err3("sel","pom_file",g_pom.pom01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
       RETURN 
    END IF
    CALL t583_show()
    LET l_sw = 0
    #開立的P/R針對(已核准/已轉PO/結案/取消)的資料無修改權限
    IF (g_argv2 = '0' and g_pom.pom25 not matches'[1269]')
       OR (g_argv2 ='0' and g_pom.pommksg = 'N'
           and g_pom.pom25 not matches'[269]')
    THEN 
       CALL t583_u()
       LET l_sw = 1
       IF INT_FLAG THEN LET INT_FLAG = 0 END IF
    END IF
    #已核准的P/R針對(已轉PO/結案/取消)的資料無修改權限
    IF g_argv2 = '1' and g_pom.pom25 not matches'[269]' THEN 
       CALL t583_u()
       LET l_sw = 1
       IF INT_FLAG THEN LET INT_FLAG = 0 END IF
    END IF
    #已發出的P/R針對(結案/取消)的資料無修改權限 1993/01/14 pin modify
    IF g_argv2 = '2' and g_pom.pom25 not matches'[69]' THEN 
       CALL t583_u()
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
    CLOSE WINDOW t583_w
END FUNCTION
 
FUNCTION t583_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
    INPUT BY NAME
        g_pom.pom14,g_pom.pom15,g_pom.pom16,g_pom.pom17,
        g_pom.pom30,g_pom.pom44
        WITHOUT DEFAULTS  
 
       AFTER FIELD pom14
            IF cl_null(g_pom.pom14) THEN    #收貨部門
               DISPLAY ' ' TO FORMONLY.gem02_2
            ELSE
               IF g_pom_o.pom14 IS NULL OR
                  (g_pom.pom14 != g_pom_o.pom14 ) THEN
                   CALL t583_dep('a','2',g_pom.pom14)
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_pom.pom14,g_errno,0)
                        LET g_pom.pom14 = g_pom_o.pom14
                        DISPLAY BY NAME g_pom_o.pom14 
                        NEXT FIELD pom14
                    END IF
               END IF
            END IF  
            LET g_pom_o.pom14 = g_pom.pom14
 
       AFTER FIELD pom15
            IF cl_null(g_pom.pom15) THEN    #確認人  
               DISPLAY ' ' TO FORMONLY.gen02_2 
            ELSE
               IF (g_pom_o.pom15 IS NULL) OR
                  (g_pom.pom15 != g_pom_o.pom15 ) THEN
                   CALL t583_peo('a','2',g_pom.pom15)
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_pom.pom15,g_errno,0)
                        LET g_pom.pom15 = g_pom_o.pom15
                        DISPLAY BY NAME g_pom_o.pom15 
                        NEXT FIELD pom15
                    END IF
               END IF
            END IF  
            LET g_pom_o.pom15 = g_pom.pom15
 
       AFTER FIELD pom17                      #代理商
           IF cl_null(g_pom.pom17) THEN
               DISPLAY ' ' TO FORMONLY.pmc03
            ELSE IF (g_pom_o.pom17 IS NULL) OR
                    (g_pom.pom17 != g_pom_o.pom17 ) THEN
                    CALL t583_pom17('a',g_pom.pom17)
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_pom.pom17,g_errno,0)
                       LET g_pom.pom17 = g_pom_o.pom17
                       DISPLAY BY NAME g_pom_o.pom17 
                       NEXT FIELD pom17
                    END IF
                 END IF
            END IF  
 
       AFTER FIELD pom30       #印驗收單
           IF cl_null(g_pom.pom30 ) OR g_pom.pom30 NOT MATCHES'[YyNn]'
              THEN CALL cl_err(g_pom.pom30,'mfg1002',0)
                   LET g_pom.pom30 = g_pom_o.pom30
                   DISPLAY BY NAME g_pom.pom30 
                   NEXT FIELD pom30
           END IF
           LET g_pom_o.pom30= g_pom.pom30  
 
        AFTER FIELD pom44     #稅處理
            IF cl_null(g_pom.pom44) OR g_pom.pom44 NOT MATCHES'[1234]'
            THEN LET g_pom.pom44 = g_pom_o.pom44
                 DISPLAY BY NAME g_pom.pom44  
                 NEXT FIELD pom44
            END IF
            LET g_pom_o.pom44 = g_pom.pom44
 
       AFTER INPUT
        IF INT_FLAG THEN                         # 若按了DEL鍵
            CALL cl_err('',9001,0)
            EXIT INPUT 
        END IF
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pom14) #收貨部門
#                 CALL q_gem(10,3,g_pom.pom14) RETURNING g_pom.pom14
#                 CALL FGL_DIALOG_SETBUFFER( g_pom.pom14 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = g_pom.pom14
                  CALL cl_create_qry() RETURNING g_pom.pom14
#                  CALL FGL_DIALOG_SETBUFFER( g_pom.pom14 )
                  DISPLAY BY NAME g_pom.pom14 
                  NEXT FIELD pom14
               WHEN INFIELD(pom15) #確認人
#                 CALL q_gen(10,3,g_pom.pom15) RETURNING g_pom.pom15
#                 CALL FGL_DIALOG_SETBUFFER( g_pom.pom15 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.default1 = g_pom.pom15
                  CALL cl_create_qry() RETURNING g_pom.pom15
#                  CALL FGL_DIALOG_SETBUFFER( g_pom.pom15 )
                  DISPLAY BY NAME g_pom.pom15 
                  NEXT FIELD pom15
               WHEN INFIELD(pom17) #廠商資料
#                 CALL q_pmc1(0,0,g_pom.pom17) RETURNING g_pom.pom17
#                 CALL FGL_DIALOG_SETBUFFER( g_pom.pom17 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmc1"
                  LET g_qryparam.default1 = g_pom.pom17
                  CALL cl_create_qry() RETURNING g_pom.pom17
#                  CALL FGL_DIALOG_SETBUFFER( g_pom.pom17 )
                  DISPLAY BY NAME g_pom.pom17 
                  NEXT FIELD pom17
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
   
FUNCTION t583_dep(p_cmd,p_code,p_key)    #部門
    DEFINE p_cmd     LIKE type_file.chr1,       #No.FUN-680136 VARCHAR(1)
           p_code    LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
           p_key     LIKE gem_file.gem01,
           l_gem02   LIKE gem_file.gem02,
           l_gemacti   LIKE gem_file.gemacti
 
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
   
FUNCTION t583_peo(p_cmd,p_code,p_key)    #人員
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
   
FUNCTION t583_show()
# DEFINE  l_str  LIKE apm_file.apm08 	#No.FUN-680136 VARCHAR(10)   #No.TQC-6A0079
    LET g_pom_t.* = g_pom.*
    DISPLAY BY NAME 
        g_pom.pom14,g_pom.pom15,g_pom.pom16,g_pom.pom17,
        g_pom.pom44,g_pom.pom30
        
#   CALL t583_peo('d','1',g_pom.pom12)
    CALL t583_peo('d','2',g_pom.pom15)
#   CALL t583_dep('d','1',g_pom.pom13)
    CALL t583_dep('d','2',g_pom.pom14)
#   CALL t583_pom16('d',g_pom.pom16)
    CALL t583_pom17('d',g_pom.pom17)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t583_pom17(p_cmd,p_key)  #代理商  
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
        p_key       LIKE pmc_file.pmc01,
        l_pmc03     LIKE pmc_file.pmc03
 
 LET g_errno = " "
   SELECT pmc03 INTO l_pmc03 FROM pmc_file 
    WHERE pmc01 = g_pom.pom17  
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY l_pmc03 TO FORMONLY.pmc03 
  END IF
END FUNCTION
 
{-------------- modi by kitty 96-06-06 -----------------
FUNCTION t583_pom26()  #理由碼
  DEFINE  l_azfacti   LIKE azf_file.azfacti
 
LET g_errno = " "
  SELECT azfacti INTO l_azfacti FROM azf_file 
   WHERE azf01 = g_pom.pom26  AND azf02='2'
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3088'
                                  LET l_azfacti = 0   
       WHEN l_azfacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 ----------------------------------------------------- }
 
FUNCTION t583_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_pom.pom01 IS NULL THEN
        CALL cl_err('',-543,0)
        RETURN
    END IF
    IF g_pom.pomacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_pom.pom01,9027,0)
        RETURN
    END IF
    MESSAGE ""
    LET g_pom01_t = g_pom.pom01
    BEGIN WORK
    WHILE TRUE
        LET g_pom_o.* = g_pom.*
        CALL t583_i("u")                         # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_pom.*=g_pom_t.*
            CALL t583_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE pom_file SET pom_file.* = g_pom.*    # 更新DB
            WHERE pom01 = g_argv1                 # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_pom.pom01,SQLCA.sqlcode,0)   #No.FUN-660129
            CALL cl_err3("upd","pom_file",g_pom.pom01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
