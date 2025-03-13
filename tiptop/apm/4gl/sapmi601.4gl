# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: sapmi601.4gl
# Descriptions...: 廠商評鑑資料－廠商資料維護作業
# Date & Author..: 92/12/28 By Keith
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pmc          RECORD LIKE pmc_file.*,
    g_pmc_t        RECORD LIKE pmc_file.*,
    g_pmc_o        RECORD LIKE pmc_file.*,
    g_pmc01_t      LIKE pmc_file.pmc01,
    g_pmc05        LIKE pmc_file.pmc05,
    g_cmd          LIKE type_file.chr1000,      #No.FUN-680136 VARCHAR(100)
    g_argv1        LIKE type_file.num10  	#No.FUN-680136 INTEGER
DEFINE p_row,p_col LIKE type_file.num5          #No.FUN-680136 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
 
 
FUNCTION sapmi601(g_argv2)        
    DEFINE g_argv2         LIKE pmc_file.pmc01,
           l_chr           LIKE type_file.chr1           #No.FUN-680136 VARCHAR(1)

    WHENEVER ERROR CONTINUE
 
    INITIALIZE g_pmc.* TO NULL
    INITIALIZE g_pmc_t.* TO NULL
    INITIALIZE g_pmc_o.* TO NULL
    LET g_pmc.pmc01 = g_argv2
    LET p_row = 10 LET p_col = 48
 
    OPEN WINDOW sapmi601_w WITH FORM "apm/42f/apmi601" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("apmi601")
 
    LET g_forupd_sql = "SELECT * FROM pmc_file",
                       "  WHERE pmc01 = ? ",
                       "   FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i601_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    CALL sapmi601_u()
    IF INT_FLAG THEN LET INT_FLAG = 0  END IF
    CLOSE WINDOW sapmi601_w
END FUNCTION
 
FUNCTION sapmi601_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
        l_cmd           LIKE type_file.chr1000,      #No.FUN-680136 VARCHAR(60)
        l_n             LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
    INPUT BY NAME
        g_pmc.pmc906,g_pmc.pmc905,g_pmc.pmc907,g_pmc.pmc18,g_pmc.pmc19,
        g_pmc.pmc20,g_pmc.pmc21
        WITHOUT DEFAULTS 
 
       AFTER INPUT
        IF INT_FLAG THEN                         # 若按了DEL鍵
            CALL cl_err('',9001,0)
            EXIT INPUT 
        END IF
 
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
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
    END INPUT
END FUNCTION
 
   
FUNCTION sapmi601_show()
# DEFINE  l_str  LIKE apm_file.apm08 	#No.FUN-680136 VARCHAR(10)  #No.TQC-6A0079
    LET g_pmc_t.* = g_pmc.*
    DISPLAY BY NAME g_pmc.pmc906,g_pmc.pmc905,g_pmc.pmc907,g_pmc.pmc18,
                    g_pmc.pmc19,g_pmc.pmc20,g_pmc.pmc21 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION sapmi601_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_pmc.pmc01 IS NULL THEN
        CALL cl_err('',-421,0)
        RETURN
    END IF
    IF g_pmc.pmcacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_pmc.pmc01,9027,0)
        RETURN
    END IF
    MESSAGE ""
    LET g_pmc01_t = g_pmc.pmc01
 
    BEGIN WORK
 
    OPEN i601_cl USING g_pmc.pmc01
    IF STATUS THEN
       CALL cl_err("OPEN i601_cl:", STATUS, 1)
       CLOSE i601_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i601_cl INTO g_pmc.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL sapmi601_show()
    WHILE TRUE
        LET g_pmc_o.* = g_pmc.*
        CALL sapmi601_i("u")                         # 欄位更改
        IF INT_FLAG THEN
            LET g_pmc.*=g_pmc_t.*
            CALL sapmi601_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE pmc_file SET pmc_file.* = g_pmc.*    # 更新DB
            WHERE pmc01 = g_pmc.pmc01           
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)   #No.FUN-660129
            CALL cl_err3("upd","pmc_file",g_pmc.pmc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
