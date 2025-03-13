# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: sapmt551.4gl
# Descriptions...: 採購單細項－交貨資料
# Date & Author..: 92/11/24 By Apple
# Modify.........: NO.FUN-550060 05/05/31 By jackie 單據編號加大
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/06 By Jackho 欄位類型修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30177 11/05/19 By lixiang UPDATE pmn_file時，如果pmn58為null則給'0' 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pmn01t         LIKE oay_file.oayslip,     #No.FUN-550060 	#No.FUN-680136 VARCHAR(5)
    g_pmn            RECORD LIKE pmn_file.*,
    g_pmn_t          RECORD LIKE pmn_file.*,
    g_pmn_o          RECORD LIKE pmn_file.*,
    g_pmn01_t        LIKE pmn_file.pmn01,
    g_wc,g_sql       string,                    #No.FUN-580092 HCN
    g_argv1          LIKE pmn_file.pmn01  	#No.FUN-680136 INTEGER
DEFINE
    g_msg            LIKE ze_file.ze03          #No.FUN-680136 VARCHAR(72)

FUNCTION t551(g_argv2,p_pmn01)
DEFINE
    p_pmn01          LIKE pmn_file.pmn01,   
    g_argv2          LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
    l_sw             LIKE type_file.num5,   	#No.FUN-680136 SMALLINT
    l_pmmmksg        LIKE pmm_file.pmmmksg,
    l_chr            LIKE type_file.chr1        #No.FUN-680136 VARCHAR(1)

    WHENEVER ERROR CONTINUE
 
    INITIALIZE g_pmn.* TO NULL
    INITIALIZE g_pmn_t.* TO NULL
    INITIALIZE g_pmn_o.* TO NULL
    LET g_argv1 = p_pmn01

    OPEN WINDOW t551_w WITH FORM "apm/42f/apmt551" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("apmt551")
 
    SELECT * INTO  g_pmn.* FROM pmn_file WHERE pmn01 = p_pmn01
    IF SQLCA.sqlcode THEN  
       CALL cl_err3("sel","pmn_file",g_pmn.pmn01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
       RETURN 
    END IF
    CALL t551_show()
    LET l_sw = 0
    SELECT pmmmksg INTO l_pmmmksg FROM pmm_file
                  WHERE pmm01 = g_pmn.pmn01 
    #開立的P/R針對(已核准/已轉PO/結案/取消)的資料無修改權限
    IF    (g_argv2= '0' and g_pmn.pmn16 not matches'[126789]') 
       OR (g_argv2 = '0' and l_pmmmksg ='N' and 
           g_pmn.pmn16 not matches'[26789]')
    THEN 
       CALL t551_u()
       LET l_sw = 1
       IF INT_FLAG THEN LET INT_FLAG = 0 END IF
    END IF
    #已核准的P/R針對(已轉PO/結案/取消)的資料無修改權限
    IF g_argv2 = '1' and g_pmn.pmn16 not matches'[26789]' THEN 
       CALL t551_u()
       LET l_sw = 1
       IF INT_FLAG THEN LET INT_FLAG = 0 END IF
    END IF
    #已發出的P/R針對(結案/取消)的資料無修改權限
    IF g_argv2 = '2' and g_pmn.pmn16 not matches'[6789]' THEN 
       CALL t551_u()
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
    CLOSE WINDOW t551_w
END FUNCTION
 
FUNCTION t551_i(p_cmd)
    DEFINE p_cmd           LIKE type_file.chr1         #No.FUN-680136 VARCHAR(1)
 
    INPUT BY NAME
        g_pmn.pmn14,g_pmn.pmn15,g_pmn.pmn13,g_pmn.pmn36,g_pmn.pmn37
        WITHOUT DEFAULTS 
 
        AFTER FIELD pmn13    #超短交限率 
            IF g_pmn.pmn13 IS NULL OR g_pmn.pmn13 = ' '
              OR g_pmn.pmn13 < 0  OR g_pmn.pmn13 > 100
            THEN CALL cl_err(g_pmn.pmn13,'mfg0013',0)
                 LET g_pmn.pmn13 = g_pmn_o.pmn13
                 DISPLAY g_pmn.pmn13 TO pmn13
                 NEXT FIELD pmn13
            END IF
            LET g_pmn_o.pmn13 = g_pmn.pmn13
 
        AFTER FIELD pmn14    #部份交貨 
          IF cl_null(g_pmn.pmn14) OR g_pmn.pmn14 NOT MATCHES'[yYnN]' 
           THEN CALL cl_err(g_pmn.pmn14,'mfg1002',0)
               LET g_pmn.pmn14 = g_pmn_o.pmn14
               DISPLAY BY NAME g_pmn.pmn14
               NEXT FIELD pmn14
            END IF
            LET g_pmn_o.pmn14 = g_pmn.pmn14
 
        AFTER FIELD pmn15    #提前交貨
            IF cl_null(g_pmn.pmn15) OR g_pmn.pmn15 NOT MATCHES'[yYnN]' THEN
               CALL cl_err(g_pmn.pmn15,'mfg1002',0)
               LET g_pmn.pmn15 = g_pmn_o.pmn15
               DISPLAY BY NAME g_pmn.pmn15
               NEXT FIELD pmn15
            END IF
            LET g_pmn_o.pmn15 = g_pmn.pmn15
 
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
 
FUNCTION t551_show()
    LET g_pmn_t.* = g_pmn.*
    DISPLAY BY NAME g_pmn.pmn14,g_pmn.pmn15,g_pmn.pmn13,
                    g_pmn.pmn36,g_pmn.pmn37
        
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t551_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_pmn.pmn01 IS NULL THEN
        CALL cl_err('',-551,0)
        RETURN
    END IF
    MESSAGE ""
    LET g_pmn01_t = g_pmn.pmn01
    BEGIN WORK
    WHILE TRUE
        LET g_pmn_o.* = g_pmn.*
        CALL t551_i("u")                         # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_pmn.*=g_pmn_t.*
            CALL t551_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        
        IF cl_null(g_pmn.pmn58) THEN LET g_pmn.pmn58 = 0 END IF    #No.FUN-B30177

        UPDATE pmn_file SET pmn_file.* = g_pmn.*    # 更新DB
            WHERE pmn01 = g_argv1                 # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_pmn.pmn01,SQLCA.sqlcode,0)   #No.FUN-660129
            CALL cl_err3("upd","pmn_file",g_pmn.pmn01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
