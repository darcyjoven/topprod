# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: apmu010 (aoo.4gl)
# Descriptions...: 採購管理系統簽核作業
# Date & Author..: 93/01/08 By Apple
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.TQC-830045 08/03/24 By Mandy g_pass DEFINE err
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40028 11/04/12 By xianghui  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS
    DEFINE
           g_dtype         LIKE type_file.chr1,          # 使用日期別 #No.FUN-680136 VARCHAR(1)
           g_cnt           LIKE type_file.num10,         #No.FUN-680136 INTEGER
           g_msg           LIKE ze_file.ze03,            #No.FUN-680136 VARCHAR(72)
          #g_pass          LIKE azb_file.azb02           #TQC-830045 mark
           g_pass          LIKE azb_file.azb01           #TQC-830045 mod
END GLOBALS
 
    DEFINE
           g_go            LIKE type_file.chr1           #是否通過密碼檢查	#No.FUN-680136 VARCHAR(1)
    DEFINE p_row,p_col     LIKE type_file.num5           #No.FUN-680136 SMALLINT 
 
MAIN
 
   DEFINE
           l_n             LIKE type_file.num10,         #No.FUN-680136 INTEGER
           l_go            LIKE type_file.chr1   	 #No.FUN-680136 VARCHAR(1)
 
    OPTIONS
        FORM        LINE FIRST + 2,
        MESSAGE     LINE LAST,
        PROMPT      LINE LAST,
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
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
       LET p_row = 3 LET p_col = 17
       OPEN WINDOW apmu010_w AT p_row,p_col
            WITH FORM "apm/42f/apmu010" 
             ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
  # ELSE
  #    OPEN FORM u010_srn FROM 'apm/42f/apmu010'
  #    DISPLAY FORM u010_srn 
  # END IF
 
    CALL u010_pass()
    IF g_go='N' THEN
        EXIT PROGRAM
    END IF
    WHILE TRUE
        IF s_shut(0) THEN EXIT WHILE END IF
        IF l_go='N' THEN
            INPUT l_n FROM a 
                ON ACTION CONTROLR
                   CALL cl_show_req_fields()
 
                ON ACTION CONTROLN
                   CALL u010_pass()
                   IF g_go='N' THEN
                       EXIT PROGRAM
                   END IF
                ON ACTION CONTROLG 
                   CALL cl_cmdask()
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
                   CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
                ON ACTION locale
                   CALL cl_dynamic_locale()
                   CALL cl_show_fld_cont()   #FUN-550037(smin)
    
                ON ACTION cancel
                   EXIT PROGRAM 
 
            END INPUT
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                CONTINUE WHILE
            END IF
        END IF
        CASE l_n
            WHEN 0 EXIT WHILE
            WHEN 1 CALL u012()
            WHEN 2 CALL u013()
            OTHERWISE EXIT CASE
        END CASE
        IF l_go='Y' THEN EXIT WHILE END IF
        EXIT WHILE		# 931004 By Roger (For unknown reason in GVC)
    END WHILE
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
#檢查密碼
FUNCTION u010_pass()
DEFINE
    l_azb02       LIKE azb_file.azb02,
    l_pp RECORD
          dummy   LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
          pass    LIKE azb_file.azb02
        END RECORD
 
    LET g_go='N'
 
    OPEN WINDOW cl_pass_w WITH FORM "aoo/42f/aoou0101" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aoou0101")
 
    LET l_pp.pass=NULL
    LET g_cnt=1
    WHILE TRUE
        INPUT g_pass WITHOUT DEFAULTS FROM u
            AFTER FIELD u
                IF cl_null(g_pass) THEN NEXT FIELD u END IF
                SELECT azb02
                    INTO l_azb02
                    FROM azb_file
                    WHERE azb01=g_pass
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_pass,'aoo-001',0)
                    NEXT FIELD u
                END IF
                 IF l_azb02 IS NULL OR l_azb02 = ' ' THEN   #沒有設定密碼
                      LET g_go='Y'
                      EXIT INPUT
                 END IF
              WHILE TRUE
                CALL apmu010_pass() RETURNING l_pp.pass
                IF g_go='N' THEN
                   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B40028
                   EXIT PROGRAM
                 END IF
                DISPLAY "l_pp.pass=",l_pp.pass
                IF l_pp.pass IS NULL THEN CONTINUE WHILE END IF
                IF l_pp.pass != l_azb02 AND l_azb02 IS NOT NULL THEN
                    CALL cl_err(g_cnt,'aoo-003',0)
                    LET g_cnt=g_cnt+1
                    LET l_pp.pass=NULL
                    IF g_cnt > 3 THEN
                        SLEEP 2
                        EXIT INPUT
                    ELSE
                        CONTINUE WHILE
                    END IF
                ELSE
                    LET g_go='Y' 
                    EXIT WHILE
                END IF
              END WHILE
            ON ACTION CONTROLR
               CALL cl_show_req_fields()
            ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()   #FUN-550037(smin)
 
            ON ACTION CONTROLG CALL cl_cmdask()
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
        
        END INPUT
        IF INT_FLAG THEN
             LET INT_FLAG=0
             EXIT WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE WINDOW cl_pass_w
    
END FUNCTION
 
FUNCTION apmu010_pass()
   DEFINE l_pass LIKE azb_file.azb02
   DEFINE l_chr  LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
   DEFINE i      LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
   LET i = 1
     LET INT_FLAG = 0  ######add for prompt bug
     PROMPT '     PASSWORD:' FOR l_pass ATTRIBUTE(INVISIBLE)
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
       # ON ACTION accept
       #    LET g_go='Y'
 
        ON ACTION cancel
           LET g_go='N'
           LET l_pass = NULL
           RETURN l_pass 
 
     
     END PROMPT
     IF INT_FLAG THEN LET l_pass = NULL LET l_chr = NULL END IF
     #IF l_chr IS NULL THEN END WHILE END IF
     #LET l_pass[i,i] = l_chr
     #LET i = i + 1
   #END WHILE
   DISPLAY "g_go=",g_go 
   DISPLAY "l_pass=",l_pass 
   LET g_go='Y'
   RETURN l_pass  
 
END FUNCTION
