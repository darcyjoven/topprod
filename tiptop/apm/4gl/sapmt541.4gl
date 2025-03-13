# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: sapmt541.4gl
# Descriptions...: 採購單－專案資料維護作業
# Date & Author..: 92/11/24 By Apple
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/06 By Jackho 欄位類型修改
# Modify.........: No.FUN-810045 08/03/03 By rainy  專案管理相關修改:專案table gja_file 改為 pja_file 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pmm            RECORD LIKE pmm_file.*,
    g_pmm_t          RECORD LIKE pmm_file.*,
    g_pmm_o          RECORD LIKE pmm_file.*,
    g_pmm01_t        LIKE pmm_file.pmm01,
    g_wc,g_sql       string,                    #No.FUN-580092 HCN
    g_argv1          LIKE type_file.num10  	#No.FUN-680136 INTEGER
 
DEFINE g_msg            LIKE ze_file.ze03          #No.FUN-680136 VARCHAR(72)

FUNCTION t541(g_argv2,p_pmm01)

DEFINE 
    g_argv2         LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
    p_pmm01         LIKE pmm_file.pmm01, 
    l_sw            LIKE type_file.num5,   	#No.FUN-680136 SMALLINT
    l_chr           LIKE type_file.chr1         #No.FUN-680136 VARCHAR(1)
 
    WHENEVER ERROR CONTINUE

    INITIALIZE g_pmm.* TO NULL
    INITIALIZE g_pmm_t.* TO NULL
    INITIALIZE g_pmm_o.* TO NULL
    LET g_argv1 = p_pmm01

    OPEN WINDOW t541_w WITH FORM "apm/42f/apmt541" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("apmt541")
 
    SELECT * INTO  g_pmm.* FROM pmm_file WHERE pmn01 = p_pmn01
    IF SQLCA.sqlcode THEN  
       CALL cl_err3("sel","pmm_file",g_pmm.pmm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
       RETURN 
    END IF
    CALL t541_show()
    LET l_sw = 0
    #開立的P/R針對(已核准/已轉PO/結案/取消)的資料無修改權限
    IF  (g_argv2 = '0' and g_pmm.pmm25 not matches'[1269]' )
       OR (g_argv2 = '0' and g_pmm.pmmmksg = 'N' and
           g_pmm.pmm25 not matches'[269]')
     THEN 
       CALL t541_u()
       LET l_sw = 1
       IF INT_FLAG THEN LET INT_FLAG = 0 END IF
    END IF
    #已核准的P/R針對(已轉PO/結案/取消)的資料無修改權限
    IF g_argv2 = '1' and g_pmm.pmm25 not matches'[269]' THEN 
       CALL t541_u()
       LET l_sw = 1
       IF INT_FLAG THEN LET INT_FLAG = 0 END IF
    END IF
    #已發出的P/R針對(結案/取消)的資料無修改權限 1993/01/14 pin modify
    IF g_argv2 = '2' and g_pmm.pmm25 not matches'[69]' THEN 
       CALL t541_u()
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
    CLOSE WINDOW t541_w
END FUNCTION
 
FUNCTION t541_i(p_cmd)
    DEFINE p_cmd           LIKE type_file.chr1       #No.FUN-680136 VARCHAR(1)
 
    INPUT BY NAME
        g_pmm.pmm06,g_pmm.pmm28
        WITHOUT DEFAULTS 
     {------------- modi by kitty 96-06-06 ------------
      AFTER FIELD pmm05  		        #專案號碼
         IF NOT cl_null(g_pmm.pmm05) THEN 
           IF (g_pmm_o.pmm05 IS NULL) OR 
              (g_pmm.pmm05 != g_pmm_o.pmm05 ) THEN
               CALL t541_pmm05()
               IF NOT cl_null(g_errno) THEN  
                  CALL cl_err(g_pmm.pmm05,g_errno,0)
                  LET g_pmm.pmm05 = g_pmm_o.pmm05
                  DISPLAY BY NAME g_pmm.pmm05
                  NEXT FIELD pmm05
               END IF
           END IF
         END IF
         LET g_pmm_o.pmm05 = g_pmm.pmm05
         ---------------------------------------------- }
 
       AFTER INPUT
        IF INT_FLAG THEN                         # 若按了DEL鍵
            CALL cl_err('',9001,0)
            EXIT INPUT 
        END IF
 
        ON ACTION CONTROLP
           {----------- modi by kitty 96-06-05---------------
            CASE
               WHEN INFIELD(pmm05) #專案號碼
#                 CALL q_gja(10,2,g_pmm.pmm05) RETURNING g_pmm.pmm05
#                 CALL FGL_DIALOG_SETBUFFER( g_pmm.pmm05 )
                  CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_gja"   #FUN-810045
                  LET g_qryparam.form = "q_pja2"   #FUN-810045 
                  LET g_qryparam.default1 = g_pmm.pmm05
                  CALL cl_create_qry() RETURNING g_pmm.pmm05
#                  CALL FGL_DIALOG_SETBUFFER( g_pmm.pmm05 )
                  DISPLAY BY NAME g_pmm.pmm05 
                  NEXT FIELD pmm05
              OTHERWISE EXIT CASE
            END CASE
            ----------------------------------------------- }
 
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
   
{-------------- modi by kitty 96-06-06 -------------------
#FUNCTION  t541_pmm05()
#  DEFINE l_gjaacti  LIKE gja_file.gjaacti 
#
#  LET g_errno = " "
#  SELECT gjaacti INTO l_gjaacti FROM gja_file 
#                 WHERE gja01 = g_pmm.pmm05 
#
#   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3064'
#                                  LET l_gjaacti = 0   
#       WHEN l_gjaacti='N' LET g_errno = '9028'
#       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
#   END CASE
#END FUNCTION
 ------------------------------------------------------- }
    
FUNCTION t541_show()
    LET g_pmm_t.* = g_pmm.*
    LET g_pmm_o.* = g_pmm.*
    DISPLAY BY NAME g_pmm.pmm06,g_pmm.pmm28
        
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t541_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_pmm.pmm01 IS NULL THEN
        CALL cl_err('',-541,0)
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
        CALL t541_i("u")                         # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_pmm.*=g_pmm_t.*
            CALL t541_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE pmm_file SET pmm06 = g_pmm.pmm06,   # 更新DB
                            pmm28 = g_pmm.pmm28
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
