# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: sapmt435.4gl
# Descriptions...: 請購單細項－廠外加工資料維護
# Date & Author..: 92/12/31 By Keith
# Modify.........: NO.FUN-550060 05/05/31 By jackie 單據編號加大
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pml01t       LIKE oay_file.oayslip,       #No.FUN-550060 	#No.FUN-680136 VARCHAR(5)
    g_pml          RECORD LIKE pml_file.*,
    g_pml_t        RECORD LIKE pml_file.*,
    g_pml_o        RECORD LIKE pml_file.*,
    g_pml01_t      LIKE pml_file.pml01,
    g_pmk02        LIKE pmk_file.pmk02,
    g_pmk45        LIKE pmk_file.pmk45,
    g_wc,g_sql     string,                      #No.FUN-580092 HCN
    g_cmd          LIKE type_file.chr1000,      #No.FUN-680136 VARCHAR(100)
    g_argv1     LIKE pml_file.pml01  	#No.FUN-680136 INTEGER
 
DEFINE  g_msg          LIKE ze_file.ze03            #No.FUN-680136 VARCHAR(72)

FUNCTION t435(g_argv2,p_pml01)
    DEFINE g_argv2         LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
           p_pml01 LIKE pml_file.pml01,       
           l_sw            LIKE type_file.num5,   	#No.FUN-680136 SMALLINT
           l_chr           LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)

    WHENEVER ERROR CONTINUE
 
    INITIALIZE g_pml.* TO NULL
    INITIALIZE g_pml_t.* TO NULL
    INITIALIZE g_pml_o.* TO NULL
    LET g_argv1 = p_pml01

    OPEN WINDOW t435_w WITH FORM "apm/42f/apmt435" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("apmt435")

    SELECT * INTO  g_pml.* FROM pml_file WHERE pml01 = p_pml01
    IF SQLCA.sqlcode THEN  
       CALL cl_err3("sel","pml_file",g_pml.pml01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
       RETURN 
    END IF
    CALL t435_show()
    LET l_sw = 0
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
    CLOSE WINDOW t435_w
END FUNCTION
 
FUNCTION t435_show()
    LET g_pml_t.* = g_pml.*
    DISPLAY BY NAME g_pml.pml41,g_pml.pml43,g_pml.pml431
        
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
