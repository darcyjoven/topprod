# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aoou010 (aoo.4gl)
# Descriptions...: 簽核作業目錄
# Date & Author..: 91/04/10 By LYS
# 1994/07/25(Lee): Add the processing of INT_FLAG When input PASSWORD
# Modify.........: No.MOD-480271 04/08/11 By Nicola 輸入密碼時，按確認當出
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/06 By yangtingting   1、離開MAIN時沒有cl_used(1)和cl_used(2)
#                                                           2、未加離開前得cl_used(2)

GLOBALS "../../config/top.global"
GLOBALS
     DEFINE
        g_dtype         LIKE type_file.chr1,           # Prog. Version..: '5.30.06-13.03.12(01),             # 使用日期別
        g_cnt           LIKE type_file.num10,          #No.FUN-680102 INTEGER
        g_msg           LIKE type_file.chr1000,       #No.FUN-680102 VARCHAR(72),
        g_pass          LIKE azb_file.azb01,           #No.FUN-680102CHAR(08),
        g_chr           LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
END GLOBALS
 
DEFINE g_go            LIKE type_file.chr1           # Prog. Version..: '5.30.06-13.03.12(01)          #是否通過密碼檢查
 
MAIN
DEFINE l_n             LIKE type_file.num10,         #No.FUN-680102 INTEGER
       l_go            LIKE type_file.chr1           #No.FUN-680102CHAR(01)
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
 
    LET l_go='N'
    IF NUM_ARGS() > 0 THEN
        LET l_n = ARG_VAL(1)
        LET l_go='Y'
    END IF
    IF l_go='Y' THEN
        IF l_n <0 OR l_n > 1 THEN
           LET l_n=NULL
           LET l_go='N'
        END IF
    END IF
 
    OPEN WINDOW u010_srn WITH FORM "aoo/42f/aoou010" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    CALL cl_set_comp_visible("select_all,cancel_all,cmt",FALSE)
    CALL u010_pass()
    IF g_go='N' THEN EXIT PROGRAM END IF
    WHILE TRUE
        IF s_shut(0) THEN EXIT WHILE END IF
        IF l_go='N' THEN
            LET l_n=0
            INPUT l_n FROM a  
                ON ACTION locale
                   CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
                   CONTINUE WHILE
 
                ON ACTION CONTROLR
                   CALL cl_show_req_fields()
                ON ACTION CONTROLG
                    CALL cl_cmdask()
 
                ON ACTION relogin 
                   CALL u010_pass()
                   IF g_go='N' THEN
                       EXIT PROGRAM
                   END IF
 
               ON ACTION cancel
                       EXIT PROGRAM
                   
 
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
            
            END INPUT
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                CONTINUE WHILE
            END IF
        END IF
        CASE l_n
            WHEN 0 EXIT WHILE
          # WHEN 1 CALL u011(0,0)
            WHEN 1 CALL u012()
            WHEN 2 CALL u015()
            WHEN 3 CALL u013()
            WHEN 4 CALL u014(g_dbs)
          # WHEN 5 CALL u015()
          # WHEN 6 CALL u016()
          # WHEN 7 CALL u017()
          # WHEN 8 CALL u018()
          # WHEN 9 CALL u019()
          # WHEN 10 CALL u021()
            WHEN 5  CALL u090()
            WHEN 6  CALL u022()
            WHEN 7  CALL u023()
        END CASE
        IF l_go='Y' THEN EXIT WHILE END IF
       #EXIT WHILE
    END WHILE
    CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
#檢查密碼
FUNCTION u010_pass()
DEFINE l_azb02         LIKE azb_file.azb02,
       l_pp RECORD
         dummy LIKE type_file.chr1,           #No.FUN-680102 VARCHAR(01),
         pass  LIKE azb_file.azb02
       END RECORD
 
    OPEN WINDOW cl_pass_w WITH FORM "aoo/42f/aoou0101" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aoou0101")
 
    LET g_go='N'      #NO:4233
    IF INT_FLAG THEN
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
    END IF
    LET l_pp.pass=NULL
    LET g_cnt=1
    WHILE TRUE
        INPUT g_pass WITHOUT DEFAULTS FROM u 
            AFTER FIELD u
                IF g_pass IS NULL THEN
                    NEXT FIELD u
                END IF
                SELECT azb02 INTO l_azb02 FROM azb_file WHERE azb01=g_pass
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_pass,'aoo-001',0)   #No.FUN-660131
                    CALL cl_err3("sel","azb_file",g_pass,"","aoo-001","","",0)    #No.FUN-660131
                    NEXT FIELD u
                END IF
                 IF l_azb02 IS NULL OR l_azb02 = ' ' THEN   #沒有設定密碼
                      LET g_go='Y'
                      EXIT INPUT
                 END IF
                 WHILE TRUE
                   CALL aoou010_pass() RETURNING l_pp.pass
                   IF g_go='N' THEN EXIT INPUT END IF
                   IF l_pp.pass IS NULL THEN CONTINUE WHILE END IF
                   IF l_pp.pass != l_azb02 AND l_azb02 IS NOT NULL THEN
                       CALL cl_err(g_cnt,'aoo-003',0)
                       LET g_cnt=g_cnt+1
                       LET l_pp.pass=NULL
                       IF g_cnt > 3 THEN
                           SLEEP 2
                           LET g_go = 'N'
                           EXIT INPUT
                       ELSE
                           CONTINUE WHILE
                       END IF
                   ELSE
                       LET g_go='Y'
                       EXIT WHILE
                   END IF
                 END WHILE
 
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
        IF INT_FLAG THEN
             LET INT_FLAG=0
             LET g_go = 'N'
             EXIT WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE WINDOW cl_pass_w
END FUNCTION
 
FUNCTION aoou010_pass()
   DEFINE l_pass LIKE type_file.chr20          #No.FUN-680102CHAR(20)
   DEFINE l_chr  LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
   DEFINE i      LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
   LET i = 1
   LET l_chr=''
   LET g_go=' '
   WHILE TRUE
     LET INT_FLAG = 0  ######add for prompt bug
     PROMPT '    PASSWORD:' FOR l_pass
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
 #-----No.MOD-480271-----    
#       ON ACTION accept
#          LET g_go='N'
#          RETURN
#-----END---------------    
     
 
     END PROMPT
     IF INT_FLAG THEN
	LET INT_FLAG=0
	LET l_pass = NULL
	LET g_go='N'
	EXIT WHILE
     END IF
    #IF FGL_LASTKEY()=13 THEN EXIT WHILE END IF
    #LET l_pass[i,i] = l_chr
    #LET i = i + 1
     EXIT WHILE
   END WHILE
   RETURN l_pass
END FUNCTION
