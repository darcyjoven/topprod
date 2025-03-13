# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: sapmt556.4gl
# Descriptions...: 採購單細項－廠外加工資料維護
# Date & Author..: 92/12/31 By Keith
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/06 By Jackho 欄位類型修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pmn         RECORD LIKE pmn_file.*,
    g_pmn_t       RECORD LIKE pmn_file.*,
    g_pmn_o       RECORD LIKE pmn_file.*,
    g_pmn01_t     LIKE pmn_file.pmn01,
    g_pmm02       LIKE pmm_file.pmm02,
    g_pmm45       LIKE pmm_file.pmm45,
    g_wc,g_sql    string,                      #No.FUN-580092 HCN
    g_cmd         LIKE type_file.chr1000,      #No.FUN-680136 VARCHAR(100)
    g_argv1       LIKE pmn_file.pmn01         #No.FUN-680136 INTEGER
DEFINE   
    g_msg         LIKE ze_file.ze03            #No.FUN-680136 VARCHAR(72)

FUNCTION t556(g_argv2,p_pmn01)
DEFINE
    p_pmn01        LIKE pmn_file.pmn01,
    g_argv2        LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(1)
    l_sw           LIKE type_file.num5,        #No.FUN-680136 SMALLINT
    l_chr          LIKE type_file.chr1         #No.FUN-680136 VARCHAR(1)

    WHENEVER ERROR CONTINUE
 
    INITIALIZE g_pmn.* TO NULL
    INITIALIZE g_pmn_t.* TO NULL
    INITIALIZE g_pmn_o.* TO NULL
    LET g_argv1 = p_pmn01
    OPEN WINDOW t556_w AT 8,38
         WITH FORM "apm/42f/apmt556" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("apmt556")
 
    SELECT * INTO  g_pmn.* FROM pmn_file WHERE pmn01 = p_pmn01
    IF SQLCA.sqlcode THEN  
#      CALL cl_err(g_pmn.pmn01,SQLCA.sqlcode,0)   #No.FUN-660129
       CALL cl_err3("sel","pmn_file",g_pmn.pmn01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
       RETURN 
    END IF
    CALL t556_show()
    LET l_sw = 0
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
    CLOSE WINDOW t556_w
END FUNCTION
 
FUNCTION t556_show()
    LET g_pmn_t.* = g_pmn.*
    SELECT pmm02,pmm45 INTO g_pmm02,g_pmm45 FROM pmm_file
                      WHERE pmm01 = g_pmn.pmn01 AND pmm18 !='X'
    DISPLAY BY NAME g_pmn.pmn41,g_pmn.pmn43,g_pmn.pmn431
        
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
