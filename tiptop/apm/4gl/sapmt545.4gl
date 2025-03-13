# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: sapmt545.4gl
# Descriptions...: 採購單－預付資料維護作業
# Date & Author..: 92/11/24 By Apple
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/06 By Jackho 欄位類型修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pmm          RECORD LIKE pmm_file.*,
    g_pmm_t        RECORD LIKE pmm_file.*,
    g_pmm_o        RECORD LIKE pmm_file.*,
    g_pmm01_t      LIKE pmm_file.pmm01,
    g_wc,g_sql     string,                      #No.FUN-580092 HCN
    g_argv1        LIKE pmm_file.pmm01  	#No.FUN-680136 INTEGER
DEFINE
    g_msg          LIKE ze_file.ze03            #No.FUN-680136 VARCHAR(72)

FUNCTION t545(g_argv2,p_pmm01)
DEFINE 
    p_pmm01        LIKE pmm_file.pmm01,     
    g_argv2        LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
    l_sw           LIKE type_file.num5,   	#No.FUN-680136 SMALLINT
    l_chr          LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)

    WHENEVER ERROR CONTINUE
 
    INITIALIZE g_pmm.* TO NULL
    INITIALIZE g_pmm_t.* TO NULL
    INITIALIZE g_pmm_o.* TO NULL
    LET g_argv1 = p_pmm01

    OPEN WINDOW t545_w WITH FORM "apm/42f/apmt545" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("apmt545")
 
    SELECT * INTO  g_pmm.* FROM pmm_file WHERE pmm01 = p_pmm01
    IF SQLCA.sqlcode THEN  
       CALL cl_err3("sel","pmm_file",g_pmm.pmm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
       RETURN 
    END IF
    CALL t545_show()
    LET l_sw = 0
    #開立的P/R針對(已核准/已轉PO/結案/取消)的資料無修改權限
    IF (g_argv2 = '0' and g_pmm.pmm25 not matches'[1269]')
      OR (g_argv2 = '0' and g_pmm.pmmmksg = 'N'
         and g_pmm.pmm25 not matches'[269]')
    THEN 
       CALL t545_u()
       LET l_sw = 1
       IF INT_FLAG THEN LET INT_FLAG = 0 END IF
    END IF
    #已核准的P/R針對(已轉PO/結案/取消)的資料無修改權限
    IF g_argv2 = '1' and g_pmm.pmm25 not matches'[269]' THEN 
       CALL t545_u()
       LET l_sw = 1
       IF INT_FLAG THEN LET INT_FLAG = 0 END IF
    END IF
    #已發出的P/R針對(結案/取消)的資料無修改權限 1993/01/14 pin modify
    IF g_argv2 = '2' and g_pmm.pmm25 not matches'[69]' THEN 
       CALL t545_u()
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
    CLOSE WINDOW t545_w
END FUNCTION
 
FUNCTION t545_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
    INPUT BY NAME g_pmm.pmm46,g_pmm.pmm49,g_pmm.pmm47,g_pmm.pmm48
        WITHOUT DEFAULTS 
 
       AFTER FIELD pmm46    
           IF cl_null(g_pmm.pmm46) OR g_pmm.pmm46 < 0
            THEN NEXT FIELD pmm46
           END IF
 
       AFTER FIELD pmm49
           IF cl_null(g_pmm.pmm49) OR g_pmm.pmm49 NOT MATCHES'[YN]'
            THEN NEXT FIELD  pmm49
           END IF
 
       AFTER INPUT
        IF INT_FLAG THEN                         # 若按了DEL鍵
            CALL cl_err('',9001,0)
            EXIT INPUT 
        END IF
 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
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
   
FUNCTION t545_show()
    LET g_pmm_t.* = g_pmm.*
    DISPLAY BY NAME g_pmm.pmmprsw,g_pmm.pmmprno,g_pmm.pmmprdt
      
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t545_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_pmm.pmm01 IS NULL THEN
        CALL cl_err('',-545,0)
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
        CALL t545_i("u")                         # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_pmm.*=g_pmm_t.*
            CALL t545_show()
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
