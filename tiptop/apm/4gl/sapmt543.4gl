# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: sapmt543.4gl
# Descriptions...: 採購單－其他資料維護作業
# Date & Author..: 92/11/18 By Apple
#        Modify..: 94/08/11 By Danny (Add pmm18,pmm44,pmm31,pmm32,pmm29
#                                     pmm26,pmm30) 
#                  By Kitty (刪除 pmm12,pmm13,pmm41,pmm18,pmm31,pmm32,pmm29,26)
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/06 By Jackho 欄位類型修改
# Modify.........: No.TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pmm        RECORD LIKE pmm_file.*,
    g_pmm_t      RECORD LIKE pmm_file.*,
    g_pmm_o      RECORD LIKE pmm_file.*,
    g_pmm01_t    LIKE pmm_file.pmm01,
    g_argv1      LIKE pmm_file.pmm01
DEFINE   g_msg         LIKE ze_file.ze03            #No.FUN-680136 VARCHAR(72)


FUNCTION t543(g_argv2,p_pmm01)
    DEFINE p_pmm01        LIKE pmm_file.pmm01,    
           g_argv2         LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
           l_sw            LIKE type_file.num5,   	#No.FUN-680136 SMALLINT
           l_chr           LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
    WHENEVER ERROR CONTINUE

    INITIALIZE g_pmm.* TO NULL
    INITIALIZE g_pmm_t.* TO NULL
    INITIALIZE g_pmm_o.* TO NULL
    LET g_argv1 = p_pmm01 

    OPEN WINDOW t543_w WITH FORM "apm/42f/apmt543" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("apmt543")
 
    SELECT * INTO  g_pmm.* FROM pmm_file WHERE pmm01 = g_argv1
    IF SQLCA.sqlcode THEN  
#      CALL cl_err(g_pmm.pmm01,SQLCA.sqlcode,0)   #No.FUN-660129
       CALL cl_err3("sel","pmm_file",g_pmm.pmm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
       RETURN 
    END IF
    CALL t543_show()
    LET l_sw = 0
    #開立的P/R針對(已核准/已轉PO/結案/取消)的資料無修改權限
    IF (g_argv2 = '0' and g_pmm.pmm25 not matches'[1269]')
       OR (g_argv2 ='0' and g_pmm.pmmmksg = 'N'
           and g_pmm.pmm25 not matches'[269]')
    THEN 
       CALL t543_u()
       LET l_sw = 1
       IF INT_FLAG THEN LET INT_FLAG = 0 END IF
    END IF
    #已核准的P/R針對(已轉PO/結案/取消)的資料無修改權限
    IF g_argv2 = '1' and g_pmm.pmm25 not matches'[269]' THEN 
       CALL t543_u()
       LET l_sw = 1
       IF INT_FLAG THEN LET INT_FLAG = 0 END IF
    END IF
    #已發出的P/R針對(結案/取消)的資料無修改權限 1993/01/14 pin modify
    IF g_argv2 = '2' and g_pmm.pmm25 not matches'[69]' THEN 
       CALL t543_u()
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
    CLOSE WINDOW t543_w
END FUNCTION
 
FUNCTION t543_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
    INPUT BY NAME
        g_pmm.pmm14,g_pmm.pmm15,g_pmm.pmm16,g_pmm.pmm17,
        g_pmm.pmm30,g_pmm.pmm44
        WITHOUT DEFAULTS  
 
     { ------------- modi by kitty 96-06-06 ----------------------
       AFTER FIELD pmm12
            IF cl_null(g_pmm.pmm12) THEN    #確認人  
               DISPLAY ' ' TO FORMONLY.gen02_1 
            ELSE IF (g_pmm_o.pmm12 IS NULL) OR
                  (g_pmm.pmm12 != g_pmm_o.pmm12 ) THEN
                   CALL t543_peo('a','1',g_pmm.pmm12)
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_pmm.pmm12,g_errno,0)
                        LET g_pmm.pmm12 = g_pmm_o.pmm12
                        DISPLAY BY NAME g_pmm_o.pmm12 
                        NEXT FIELD pmm12
                    END IF
                 END IF
            END IF  
            LET g_pmm_o.pmm12 = g_pmm.pmm12
 
       AFTER FIELD pmm13
            IF cl_null(g_pmm.pmm13) THEN    #採購部門
                 DISPLAY ' ' TO FORMONLY.gem02_1 
            ELSE IF g_pmm_o.pmm13 IS NULL OR
                  (g_pmm.pmm13 != g_pmm_o.pmm13 ) THEN
                   CALL t543_dep('a','1',g_pmm.pmm13)
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_pmm.pmm13,g_errno,0)
                        LET g_pmm.pmm13 = g_pmm_o.pmm13
                        DISPLAY BY NAME g_pmm_o.pmm13 
                        NEXT FIELD pmm13
                    END IF
               END IF
            END IF  
            LET g_pmm_o.pmm13 = g_pmm.pmm13
       ---------------------------------------------------------- }
 
       AFTER FIELD pmm14
            IF cl_null(g_pmm.pmm14) THEN    #收貨部門
               DISPLAY ' ' TO FORMONLY.gem02_2
            ELSE
               IF g_pmm_o.pmm14 IS NULL OR
                  (g_pmm.pmm14 != g_pmm_o.pmm14 ) THEN
                   CALL t543_dep('a','2',g_pmm.pmm14)
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_pmm.pmm14,g_errno,0)
                        LET g_pmm.pmm14 = g_pmm_o.pmm14
                        DISPLAY BY NAME g_pmm_o.pmm14 
                        NEXT FIELD pmm14
                    END IF
               END IF
            END IF  
            LET g_pmm_o.pmm14 = g_pmm.pmm14
 
       AFTER FIELD pmm15
            IF cl_null(g_pmm.pmm15) THEN    #確認人  
               DISPLAY ' ' TO FORMONLY.gen02_2 
            ELSE
               IF (g_pmm_o.pmm15 IS NULL) OR
                  (g_pmm.pmm15 != g_pmm_o.pmm15 ) THEN
                   CALL t543_peo('a','2',g_pmm.pmm15)
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_pmm.pmm15,g_errno,0)
                        LET g_pmm.pmm15 = g_pmm_o.pmm15
                        DISPLAY BY NAME g_pmm_o.pmm15 
                        NEXT FIELD pmm15
                    END IF
               END IF
            END IF  
            LET g_pmm_o.pmm15 = g_pmm.pmm15
 
    {-------------- modi by kitty 96-06-06 -----------------------
       AFTER FIELD pmm41
            IF cl_null(g_pmm.pmm41) OR g_pmm.pmm41 NOT MATCHES'[YN]'
            THEN NEXT FIELD pmm41
            END IF
 
         AFTER FIELD pmm18                       #FOB 條件
             IF cl_null(g_pmm.pmm18) OR 
                g_pmm.pmm18 NOT MATCHES '[0123]' THEN
                CALL cl_err(g_pmm.pmm18,'mfg3016',0)
                  LET g_pmm.pmm18 = g_pmm_o.pmm18
                  DISPLAY BY NAME g_pmm.pmm18 
                  NEXT FIELD pmm18
             END IF
             LET g_pmm_o.pmm18 = g_pmm.pmm18
 
       AFTER FIELD pmm31                        #會計年度
           IF cl_null(g_pmm.pmm31) THEN
              NEXT FIELD pmm31
           END IF
           IF NOT cl_null(g_pmm.pmm31) THEN 
               SELECT azm01 FROM azm_file 
                           WHERE azm01 = g_pmm.pmm31
               IF SQLCA.sqlcode THEN 
#                 CALL cl_err(g_pmm.pmm31,'mfg3078',0)    #No.FUN-660129
                  CALL cl_err3("sel","azm_file",g_pmm.pmm31,"","mfg3078","","",1)  #No.FUN-660129
                  LET g_pmm.pmm31 = g_pmm_o.pmm31
                  DISPLAY BY NAME g_pmm.pmm31 
                  NEXT FIELD pmm31
               END IF
#              IF g_pmm.pmm31 < g_sma.sma51 THEN 
#                 CALL cl_err(g_pmm.pmm31,'mfg3256',0)
#                 LET g_pmm.pmm31 = g_pmm_o.pmm31
#                 DISPLAY BY NAME g_pmm.pmm31 
#                 NEXT FIELD pmm31
#              END IF 
           END IF
           LET g_pmm_o.pmm31 = g_pmm.pmm31
 
       AFTER FIELD pmm32  		        #會計期間
           IF cl_null(g_pmm.pmm32) THEN
              NEXT FIELD pmm32
           END IF
           IF NOT cl_null(g_pmm.pmm32)
               AND (g_pmm.pmm32 > 13  OR g_pmm.pmm32 < 0 )
             THEN CALL cl_err(g_pmm.pmm32,'mfg3078',0)
                  LET g_pmm.pmm32 = g_pmm_o.pmm32
                  DISPLAY BY NAME g_pmm.pmm32 
                  NEXT FIELD pmm32
           END IF
#          IF (g_pmm.pmm32 < g_sma.sma52 AND g_pmm.pmm31 = g_sma.sma51) 
#             AND g_argv2 !='2' THEN
#             CALL cl_err(g_pmm.pmm32,'mfg3257',0)
#             LET g_pmm.pmm32 = g_pmm_o.pmm32
#             DISPLAY BY NAME g_pmm.pmm32 
#             NEXT FIELD pmm32
#          END IF
           LET g_pmm_o.pmm32 = g_pmm.pmm32
 
      AFTER FIELD pmm29  		        #會計科目
           IF cl_null(g_pmm.pmm29) AND (g_pmm.pmm02 = 'EXP '  OR 
              g_pmm.pmm02 = 'CAP ') THEN
              NEXT FIELD pmm29
           END IF
           IF NOT cl_null(g_pmm.pmm29)  THEN 
              IF (g_pmm_o.pmm29 IS NULL) OR ( g_pmm_t.pmm29 IS NULL)
                 OR (g_pmm_o.pmm29 != g_pmm.pmm29) THEN
                 IF g_sma.sma03='Y' THEN
                    IF NOT s_actchk3(g_pmm.pmm29) THEN 
                       CALL cl_err(g_pmm.pmm29,'mfg0018',0)
                       LET g_pmm.pmm29 = g_pmm_o.pmm29
                       DISPLAY BY NAME g_pmm.pmm29 
                       NEXT FIELD pmm29
                    END IF
                  END IF
              END IF
           END IF
           LET g_pmm_o.pmm29 = g_pmm.pmm29
 
       AFTER FIELD pmm26          #理由碼
           IF NOT cl_null(g_pmm.pmm26) THEN
              IF g_pmm_o.pmm26 IS NULL OR g_pmm_o.pmm26 != g_pmm.pmm26 THEN 
                 CALL t543_pmm26()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_pmm.pmm26,g_errno,0)
                    LET g_pmm.pmm26 = g_pmm_o.pmm26
                    DISPLAY BY NAME g_pmm.pmm26 
                    NEXT FIELD pmm26
                 END IF
              END IF
           END IF
           LET g_pmm_o.pmm26= g_pmm.pmm26  
   --------------------------------------------------------------- }
 
       AFTER FIELD pmm17                      #代理商
           IF cl_null(g_pmm.pmm17) THEN
               DISPLAY ' ' TO FORMONLY.pmc03
            ELSE IF (g_pmm_o.pmm17 IS NULL) OR
                    (g_pmm.pmm17 != g_pmm_o.pmm17 ) THEN
                    CALL t543_pmm17('a',g_pmm.pmm17)
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_pmm.pmm17,g_errno,0)
                       LET g_pmm.pmm17 = g_pmm_o.pmm17
                       DISPLAY BY NAME g_pmm_o.pmm17 
                       NEXT FIELD pmm17
                    END IF
                 END IF
            END IF  
 
       AFTER FIELD pmm30       #印驗收單
           IF cl_null(g_pmm.pmm30 ) OR g_pmm.pmm30 NOT MATCHES'[YyNn]'
              THEN CALL cl_err(g_pmm.pmm30,'mfg1002',0)
                   LET g_pmm.pmm30 = g_pmm_o.pmm30
                   DISPLAY BY NAME g_pmm.pmm30 
                   NEXT FIELD pmm30
           END IF
           LET g_pmm_o.pmm30= g_pmm.pmm30  
 
#bugno:5389..................................
        BEFORE FIELD pmm44  #扣抵區分 
            IF cl_null(g_pmm.pmm44) THEN 
               LET g_pmm.pmm44 = '1'
               DISPLAY BY NAME g_pmm.pmm44 
            END IF 
#bugno end...................................
        AFTER FIELD pmm44   #扣抵區分  
        #   IF cl_null(g_pmm.pmm44) OR g_pmm.pmm44 NOT MATCHES'[1234]'#bugno.5225,5389
            IF NOT cl_null(g_pmm.pmm44) AND g_pmm.pmm44 NOT MATCHES '[12]' #bugno:5389,6374 
            THEN LET g_pmm.pmm44 = g_pmm_o.pmm44
                 DISPLAY BY NAME g_pmm.pmm44  
                 NEXT FIELD pmm44
            END IF
            LET g_pmm_o.pmm44 = g_pmm.pmm44
 
       AFTER INPUT
        IF INT_FLAG THEN                         # 若按了DEL鍵
            CALL cl_err('',9001,0)
            EXIT INPUT 
        END IF
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pmm14) #收貨部門
#                   CALL q_gem(10,3,g_pmm.pmm14) RETURNING g_pmm.pmm14
#                   CALL FGL_DIALOG_SETBUFFER( g_pmm.pmm14 )
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.default1 = g_pmm.pmm14
                    CALL cl_create_qry() RETURNING g_pmm.pmm14
#                    CALL FGL_DIALOG_SETBUFFER( g_pmm.pmm14 )
                    DISPLAY BY NAME g_pmm.pmm14 
                    NEXT FIELD pmm14
               WHEN INFIELD(pmm15) #確認人
#                   CALL q_gen(10,3,g_pmm.pmm15) RETURNING g_pmm.pmm15
#                   CALL FGL_DIALOG_SETBUFFER( g_pmm.pmm15 )
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.default1 = g_pmm.pmm15
                    CALL cl_create_qry() RETURNING g_pmm.pmm15
#                    CALL FGL_DIALOG_SETBUFFER( g_pmm.pmm15 )
                    DISPLAY BY NAME g_pmm.pmm15 
                    NEXT FIELD pmm15
               WHEN INFIELD(pmm17) #廠商資料
#                   CALL q_pmc1(0,0,g_pmm.pmm17) RETURNING g_pmm.pmm17
#                   CALL FGL_DIALOG_SETBUFFER( g_pmm.pmm17 )
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pmc1"
                    LET g_qryparam.default1 = g_pmm.pmm17
                    CALL cl_create_qry() RETURNING g_pmm.pmm17
#                    CALL FGL_DIALOG_SETBUFFER( g_pmm.pmm17 )
                    DISPLAY BY NAME g_pmm.pmm17 
                    NEXT FIELD pmm17
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
   
FUNCTION t543_dep(p_cmd,p_code,p_key)    #部門
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
   
FUNCTION t543_peo(p_cmd,p_code,p_key)    #人員
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
   
FUNCTION t543_show()
# DEFINE  l_str  LIKE apm_file.apm08 	#No.FUN-680136 VARCHAR(10) #No.TQC-6A0079
    LET g_pmm_t.* = g_pmm.*
    DISPLAY BY NAME 
        g_pmm.pmm14,g_pmm.pmm15,g_pmm.pmm16,g_pmm.pmm17,
        g_pmm.pmm44,g_pmm.pmm30
        
#   CALL t543_peo('d','1',g_pmm.pmm12)
    CALL t543_peo('d','2',g_pmm.pmm15)
#   CALL t543_dep('d','1',g_pmm.pmm13)
    CALL t543_dep('d','2',g_pmm.pmm14)
#   CALL t543_pmm16('d',g_pmm.pmm16)
    CALL t543_pmm17('d',g_pmm.pmm17)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t543_pmm17(p_cmd,p_key)  #代理商  
 DEFINE p_cmd       LIKE type_file.chr1,      #No.FUN-680136 VARCHAR(1)
        p_key       LIKE pmc_file.pmc01,
        l_pmc03     LIKE pmc_file.pmc03
 
 LET g_errno = " "
   SELECT pmc03 INTO l_pmc03 FROM pmc_file 
    WHERE pmc01 = g_pmm.pmm17  
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY l_pmc03 TO FORMONLY.pmc03 
  END IF
END FUNCTION
 
{-------------- modi by kitty 96-06-06 -----------------
FUNCTION t543_pmm26()  #理由碼
  DEFINE  l_azfacti   LIKE azf_file.azfacti
 
LET g_errno = " "
  SELECT azfacti INTO l_azfacti FROM azf_file 
   WHERE azf01 = g_pmm.pmm26  AND azf02='2'
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3088'
                                  LET l_azfacti = 0   
       WHEN l_azfacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 ----------------------------------------------------- }
 
FUNCTION t543_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_pmm.pmm01 IS NULL THEN
        CALL cl_err('',-543,0)
        RETURN
    END IF
    IF g_pmm.pmmacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_pmm.pmm01,9027,0)
        RETURN
    END IF
    MESSAGE ""
    LET g_pmm01_t = g_pmm.pmm01
    BEGIN WORK
    WHILE TRUE
        LET g_pmm_o.* = g_pmm.*
        CALL t543_i("u")                         # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_pmm.*=g_pmm_t.*
            CALL t543_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE pmm_file SET pmm_file.* = g_pmm.*    # 更新DB
            WHERE pmm01 = g_argv1                 # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_pmm.pmm01,SQLCA.sqlcode,0)   #No.FUN-660129
            CALL cl_err3("upd","pmm_file",g_pmm.pmm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
