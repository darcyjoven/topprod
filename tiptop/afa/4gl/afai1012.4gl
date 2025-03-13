# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: afai1012.4gl
# Descriptions...: 固定資產稅簽資料維護作業
# Date & Author..: 96/06/11 By Lynn  
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_fak   RECORD LIKE fak_file.*,
    g_fak_t RECORD LIKE fak_file.*,
    g_fak_o RECORD LIKE fak_file.*,
    g_fak01_t LIKE fak_file.fak01,
    g_fak02_t LIKE fak_file.fak02,
    l_count   LIKE type_file.num5                 #No.FUN-680070 SMALLINT
 
FUNCTION i101_2(g_argv1,g_argv2,g_argv3)
DEFINE g_argv1        LIKE fak_file.fak01,        #No.FUN-680070 VARCHAR(10)
       g_argv2        LIKE fak_file.fak02,        #No.FUN-680070 VARCHAR(10)
       g_argv3        LIKE fak_file.fak022,       #No.FUN-680070 VARCHAR(04)
       l_sw           LIKE type_file.num5,        #No.FUN-680070 SMALLINT
       l_chr          LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    INITIALIZE g_fak.* TO NULL
    INITIALIZE g_fak_t.* TO NULL
    INITIALIZE g_fak_o.* TO NULL
 
    OPEN WINDOW i101_1_w WITH FORM "afa/42f/afai1012" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_locale("afai1012")
 
    SELECT * INTO g_fak.* FROM fak_file 
       WHERE fak01=g_argv1        
         AND fak02=g_argv2
         AND fak022=g_argv3
    IF SQLCA.sqlcode THEN  
       CALL cl_err3("sel","fak_file",g_argv1,g_argv2,SQLCA.sqlcode,"","",1)  #No.FUN-660136
       RETURN 
    END IF
    IF g_fak.fak01 IS NULL OR g_fak.fak02 IS NULL THEN RETURN END IF
    CALL i101_2_show()
    CALL i101_2_u()
 
    CLOSE WINDOW i101_1_w
 
END FUNCTION
 
 
FUNCTION i101_2_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_n             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        a1              LIKE type_file.chr20        #No.FUN-680070 VARCHAR(20)
 
    INPUT BY NAME
        g_fak.fak61,g_fak.fak62,g_fak.fak63,g_fak.fak64,
        g_fak.fak65,g_fak.fak66,g_fak.fak67,g_fak.fak68 
        WITHOUT DEFAULTS 
 
       AFTER FIELD fak61
           IF g_fak.fak61 NOT MATCHES '[0-5]' THEN NEXT FIELD fak61 END IF
           IF NOT cl_null(g_fak.fak61) THEN
              CALL i101_2_fak61(g_fak.fak61) RETURNING a1
              DISPLAY a1 TO FORMONLY.a1 
           ELSE
              DISPLAY ' ' TO FORMONLY.a1 
           END IF
        
       BEFORE FIELD fak68
           IF g_fak.fak68 IS NULL OR g_fak.fak68 = 0 THEN 
              LET g_fak.fak68 = g_fak.fak62 - g_fak.fak67
              DISPLAY g_fak.fak68 TO fak68 
           END IF
 
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
   
FUNCTION i101_2_show()
  DEFINE a1    LIKE type_file.chr20        #No.FUN-680070 VARCHAR(20)
    DISPLAY BY NAME 
        g_fak.fak61,g_fak.fak62,g_fak.fak63,g_fak.fak64,
        g_fak.fak65,g_fak.fak66,g_fak.fak67,g_fak.fak68,
        g_fak.fak69,g_fak.fak70 
    CALL i101_2_fak61(g_fak.fak61) RETURNING a1 
    DISPLAY a1 TO FORMONLY.a1 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i101_2_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_fak.fak01 IS NULL OR g_fak.fak02 IS NULL THEN
        CALL cl_err('',-421,0)
        RETURN
    END IF
    MESSAGE ""
    LET g_fak01_t = g_fak.fak01
    LET g_fak02_t = g_fak.fak02
    BEGIN WORK
    WHILE TRUE
        LET g_fak_o.* = g_fak.*
        CALL i101_2_i("u")        
        IF INT_FLAG THEN
            LET g_fak.*=g_fak_t.*
            CALL i101_2_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE fak_file SET fak_file.* = g_fak.* 
            WHERE fak01=g_fak.fak01 AND fak02=g_fak.fak02
              AND fak022=g_fak.fak022 
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_fak.fak01,SQLCA.sqlcode,0)   #No.FUN-660136
            CALL cl_err3("upd","fak_file",g_fak.fak01,g_fak.fak02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
FUNCTION i101_2_fak61(l_fak61)
DEFINE
      l_fak61   LIKE fak_file.fak61,
      l_bn       LIKE type_file.chr20        #No.FUN-680070 VARCHAR(20)
 
     CASE l_fak61
         WHEN '0'
            CALL cl_getmsg('afa-008',g_lang) RETURNING l_bn
         WHEN '1' 
            CALL cl_getmsg('afa-009',g_lang) RETURNING l_bn
         WHEN '2' 
            CALL cl_getmsg('afa-010',g_lang) RETURNING l_bn
         WHEN '3' 
            CALL cl_getmsg('afa-011',g_lang) RETURNING l_bn
         WHEN '4' 
            CALL cl_getmsg('afa-012',g_lang) RETURNING l_bn
         WHEN '5' 
            CALL cl_getmsg('afa-013',g_lang) RETURNING l_bn
         OTHERWISE EXIT CASE
      END CASE
      RETURN(l_bn)
END FUNCTION
