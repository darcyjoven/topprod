# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: afai1002.4gl
# Descriptions...: 固定資產稅簽資料維護作業
# Date & Author..: 96/06/11 By Lynn  
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_faj   RECORD LIKE faj_file.*,
    g_faj_t RECORD LIKE faj_file.*,
    g_faj_o RECORD LIKE faj_file.*,
    g_faj01_t LIKE faj_file.faj01,
    g_faj02_t LIKE faj_file.faj02,
    l_count         LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    g_argv1         LIKE faj_file.faj01,         #No.FUN-680070 VARCHAR(10)
    g_argv2         LIKE faj_file.faj02,         #No.FUN-680070 VARCHAR(10)
    g_argv3         LIKE faj_file.faj022         #No.FUN-680070 VARCHAR(04)
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
 
FUNCTION i100_2(p_argv1,p_argv2,p_argv3)
DEFINE     p_argv1         LIKE faj_file.faj01,         #No.FUN-680070 VARCHAR(10)
           p_argv2         LIKE faj_file.faj02,         #No.FUN-680070 VARCHAR(10)
           p_argv3         LIKE faj_file.faj022,        #No.FUN-680070 VARCHAR(04)
           l_sw            LIKE type_file.num5,         #No.FUN-680070 SMALLINT
           l_chr           LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    INITIALIZE g_faj.* TO NULL
    INITIALIZE g_faj_t.* TO NULL
    INITIALIZE g_faj_o.* TO NULL
 
    LET g_argv1 = p_argv1
    LET g_argv2 = p_argv2
    LET g_argv3 = p_argv3
 
    OPEN WINDOW i100_1_w WITH FORM "afa/42f/afai1002" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_locale("afai1002")
 
    SELECT * INTO g_faj.* FROM faj_file 
       WHERE faj01=g_argv1        
         AND faj02=g_argv2
         AND faj022=g_argv3
    IF SQLCA.sqlcode THEN  
       CALL cl_err3("sel","faj_file",g_argv1,g_argv2,SQLCA.sqlcode,"","",1)  #No.FUN-660136
       RETURN 
    END IF
    IF g_faj.faj01 IS NULL OR g_faj.faj02 IS NULL THEN RETURN END IF
 
    LET g_forupd_sql = "SELECT * FROM faj_file WHERE faj01=? AND faj02=? AND faj022=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_cl2 CURSOR  FROM g_forupd_sql              # LOCK CURSOR
 
    CALL i100_2_show()
    CALL i100_2_u()
    CLOSE WINDOW i100_1_w
 
END FUNCTION
 
FUNCTION i100_2_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_n             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        a1              LIKE type_file.chr20        #No.FUN-680070 VARCHAR(20)
 
    INPUT BY NAME
        g_faj.faj61,g_faj.faj62,g_faj.faj63,g_faj.faj64,
        g_faj.faj65,g_faj.faj66,g_faj.faj67,g_faj.faj68 
        WITHOUT DEFAULTS 
 
       AFTER FIELD faj61
           IF g_faj.faj61 NOT MATCHES '[0-5]' THEN NEXT FIELD faj61 END IF
           IF NOT cl_null(g_faj.faj61) THEN
              CALL i100_2_faj61(g_faj.faj61) RETURNING a1
              DISPLAY a1 TO FORMONLY.a1 
           ELSE
              DISPLAY ' ' TO FORMONLY.a1
           END IF
        
       BEFORE FIELD faj68
           IF g_faj.faj68 IS NULL OR g_faj.faj68 = 0 THEN 
              LET g_faj.faj68 = g_faj.faj62 - g_faj.faj67
              DISPLAY g_faj.faj68 TO faj68 
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
   
FUNCTION i100_2_show()
  DEFINE a1    LIKE type_file.chr20        #No.FUN-680070 VARCHAR(20)
    DISPLAY BY NAME 
        g_faj.faj61,g_faj.faj62,g_faj.faj63,g_faj.faj64,
        g_faj.faj65,g_faj.faj66,g_faj.faj67,g_faj.faj68,
      # g_faj.faj69,g_faj.faj70 
      #No.B605 modify by linda 
        g_faj.faj69,g_faj.faj70,g_faj.faj201,
        g_faj.faj205,g_faj.faj206  
    CALL i100_2_faj61(g_faj.faj61) RETURNING a1 
    DISPLAY a1 TO FORMONLY.a1
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i100_2_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_faj.faj01 IS NULL OR g_faj.faj02 IS NULL THEN
        CALL cl_err('',-421,0)
        RETURN
    END IF
    MESSAGE ""
    LET g_faj01_t = g_faj.faj01
    LET g_faj02_t = g_faj.faj02
    BEGIN WORK
    #No.B375 010517 by linda add
 
    OPEN i100_cl2 USING g_argv1,g_argv2,g_argv3
 
    IF STATUS THEN
       CALL cl_err("OPEN i100_cl2:", STATUS, 1)
       CLOSE i100_cl2
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i100_cl2 INTO g_faj.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_faj.faj01,SQLCA.sqlcode,0)
        RETURN
    END IF
    #No.B375 end---
    WHILE TRUE
        LET g_faj_o.* = g_faj.*
        CALL i100_2_i("u")        
        IF INT_FLAG THEN
            LET g_faj.*=g_faj_t.*
            CALL i100_2_show()
            LET INT_FLAG=0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE faj_file SET faj_file.* = g_faj.* 
            WHERE faj01=g_faj.faj01 AND faj02=g_faj.faj02
              AND faj022=g_faj.faj022 
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_faj.faj01,SQLCA.sqlcode,0)   #No.FUN-660136
            CALL cl_err3("upd","faj_file",g_faj.faj01,g_faj.faj02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i100_cl2   #No.B375 add
    COMMIT WORK
END FUNCTION
 
FUNCTION i100_2_faj61(l_faj61)
DEFINE
      l_faj61   LIKE faj_file.faj61,
      l_bn       LIKE type_file.chr20        #No.FUN-680070 VARCHAR(20)
 
     CASE l_faj61
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
