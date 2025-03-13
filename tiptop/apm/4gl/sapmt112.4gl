# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: sapmt112.4gl
# Descriptions...: 採購收貨列印資料
# Date & Author..: 92/12/03 By Apple
# Modify.........: No.FUN-660129 06/06/19 By rayven cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_rva       RECORD LIKE rva_file.*,
    g_rva_t     RECORD LIKE rva_file.*,
    g_rva_o     RECORD LIKE rva_file.*,
    g_rva01_t   LIKE rva_file.rva01,
    g_argv1     LIKE type_file.num10  	#No.FUN-680147
 
FUNCTION t112(p_rva01)
    DEFINE p_rva01     LIKE rva_file.rva01

    WHENEVER ERROR CALL cl_err_msg_log
 
    INITIALIZE g_rva.* TO NULL
    INITIALIZE g_rva_t.* TO NULL
    INITIALIZE g_rva_o.* TO NULL
    LET g_argv1 = p_rva01

    OPEN WINDOW t112_w WITH FORM "apm/42f/apmt112"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("apmt112")
 
    SELECT * INTO  g_rva.* FROM rva_file WHERE rva01 = p_rva01
    IF SQLCA.sqlcode THEN  
       CALL cl_err3("sel","rva_file",g_rva.rva01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
       RETURN 
    END IF
 
    CALL t112_show()
 
    CALL t112_u()
 
    IF INT_FLAG THEN LET INT_FLAG = 0 END IF
    CLOSE WINDOW t112_w
END FUNCTION
 
FUNCTION t112_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
    INPUT BY NAME
        g_rva.rva20,g_rva.rva21,g_rva.rva22,g_rva.rva23, 
        g_rva.rvaprno,g_rva.rva28
        WITHOUT DEFAULTS 
 
       AFTER FIELD rva20
          IF NOT cl_null(g_rva.rva20) THEN
             IF g_rva.rva20 NOT MATCHES'[YN]' THEN
                NEXT FIELD rva20
             END IF
          END IF
 
       AFTER FIELD rva22
          IF NOT cl_null(g_rva.rva22) THEN
             IF g_rva.rva22 NOT MATCHES'[YN]' THEN
                NEXT FIELD rva22
             END IF
          END IF
 
       AFTER INPUT
          IF INT_FLAG THEN                         # 若按了DEL鍵
             CALL cl_err('',9001,0)
             EXIT INPUT 
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
   
FUNCTION t112_show()
    LET g_rva_t.* = g_rva.*
    DISPLAY BY NAME 
        g_rva.rva20,g_rva.rva21,g_rva.rva22,g_rva.rva23, 
        g_rva.rvaprno,g_rva.rva28
        
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t112_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_rva.rva01 IS NULL THEN
        CALL cl_err('',-421,0)
        RETURN
    END IF
    IF g_rva.rvaacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_rva.rva01,9027,0)
        RETURN
    END IF
    MESSAGE ""
    LET g_rva01_t = g_rva.rva01
    BEGIN WORK
    WHILE TRUE
        LET g_rva_o.* = g_rva.*
        CALL t112_i("u")                         # 欄位更改
        IF INT_FLAG THEN
            LET g_rva.*=g_rva_t.*
            CALL t112_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE rva_file SET rva_file.* = g_rva.*    # 更新DB
         WHERE rva01 = g_argv1                 # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_rva.rva01,SQLCA.sqlcode,0)   #No.FUN-660129
            CALL cl_err3("upd","rva_file",g_rva.rva01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
