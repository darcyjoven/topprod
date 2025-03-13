# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: sapmt421.4gl
# Descriptions...: 請購單－專案資料維護作業
# Date & Author..: 92/11/17 By Apple
# Modify.........: NO.FUN-550060 05/05/31 By jackie 單據編號加大
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.FUN-810045 08/03/03 By rainy 專案管理相關修改:專案table  gja_file 改為 pja_file
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pmk01t         LIKE oay_file.oayslip,     #No.FUN-550060 	#No.FUN-680136 VARCHAR(5)
    g_pmk            RECORD LIKE pmk_file.*,
    g_pmk_t          RECORD LIKE pmk_file.*,
    g_pmk_o          RECORD LIKE pmk_file.*,
    g_pmk01_t        LIKE pmk_file.pmk01,
    g_wc,g_sql       string,                    #No.FUN-580092 HCN
    g_argv1          LIKE pmk_file.pmk01  	#No.FUN-680147
DEFINE   g_msg       LIKE ze_file.ze03          #No.FUN-680136 VARCHAR(72)


FUNCTION t421(g_argv2,p_pmk01)
DEFINE g_argv2       LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
       p_pmk01 LIKE pmk_file.pmk01,    
       l_sw          LIKE type_file.num5,   	#No.FUN-680136 SMALLINT
       l_chr         LIKE type_file.chr1        #No.FUN-680136 VARCHAR(1)

    WHENEVER ERROR CONTINUE
 
    INITIALIZE g_pmk.* TO NULL
    INITIALIZE g_pmk_t.* TO NULL
    INITIALIZE g_pmk_o.* TO NULL
    LET g_argv1 = p_pmk01

    OPEN WINDOW t421_w WITH FORM "apm/frm/apmt421" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("apmt421")
 
    SELECT * INTO  g_pmk.* FROM pmk_file WHERE pmk01 = p_pmk01
    IF SQLCA.sqlcode THEN  
       CALL cl_err3("sel","pmk_file",g_pmk.pmk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
       RETURN 
    END IF
    CALL t421_show()
    LET l_sw = 0
    #開立的P/R針對(已核准/已轉PO/結案/取消)的資料無修改權限
    IF (g_argv2 = '0' and g_pmk.pmk25 not matches'[1269]')
       OR (g_argv2 ='0' and g_pmk.pmkmksg = 'N' and 
           g_pmk.pmk25 not matches'[269]')
    THEN 
       CALL t421_u()
       LET l_sw = 1
       IF INT_FLAG THEN LET INT_FLAG = 0 END IF
    END IF
    #已核准的P/R針對(已轉PO/結案/取消)的資料無修改權限
    IF g_argv2 = '1' and g_pmk.pmk25 not matches'[269]' THEN 
       CALL t421_u()
       LET l_sw = 1
       IF INT_FLAG THEN LET INT_FLAG = 0 END IF
    END IF
    #已發出的P/R針對(已轉PO/結案/取消)的資料無修改權限
    IF g_argv2 = '2' and g_pmk.pmk25 not matches'[69]' THEN 
       CALL t421_u()
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
    CLOSE WINDOW t421_w
END FUNCTION
 
FUNCTION t421_i(p_cmd)
    DEFINE p_cmd           LIKE type_file.chr1       #No.FUN-680136 VARCHAR(1)
 
    INPUT BY NAME
        g_pmk.pmk05,g_pmk.pmk06,g_pmk.pmk28
        WITHOUT DEFAULTS 
 
      AFTER FIELD pmk05  		        #專案號碼
         IF NOT cl_null(g_pmk.pmk05) THEN 
           IF (g_pmk_o.pmk05 IS NULL) OR 
              (g_pmk.pmk05 != g_pmk_o.pmk05 ) THEN
               CALL t421_pmk05()
               IF NOT cl_null(g_errno) THEN  
                  CALL cl_err(g_pmk.pmk05,g_errno,0)
                  LET g_pmk.pmk05 = g_pmk_o.pmk05
                  DISPLAY BY NAME g_pmk.pmk05
                  NEXT FIELD pmk05
               END IF
           END IF
         END IF
         LET g_pmk_o.pmk05 = g_pmk.pmk05
 
       AFTER INPUT
        IF INT_FLAG THEN                         # 若按了DEL鍵
            CALL cl_err('',9001,0)
            EXIT INPUT 
        END IF
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pmk05) #專案號碼
#                 CALL q_gja(10,2,g_pmk.pmk05) RETURNING g_pmk.pmk05
#                 CALL FGL_DIALOG_SETBUFFER( g_pmk.pmk05 )
                  CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_gja"  #FUN-810045
                  LET g_qryparam.form = "q_pja3"  #FUN-810045 
                  LET g_qryparam.default1 = g_pmk.pmk05
                  CALL cl_create_qry() RETURNING g_pmk.pmk05
#                  CALL FGL_DIALOG_SETBUFFER( g_pmk.pmk05 )
 
                  DISPLAY BY NAME g_pmk.pmk05 
                  NEXT FIELD pmk05
              OTHERWISE EXIT CASE
            END CASE
 
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
   
FUNCTION  t421_pmk05()
  DEFINE l_pjaclose LIKE pja_file.pjaclose #No.FUN-960038
  #DEFINE l_gjaacti  LIKE gja_file.gjaacti   #FUN-810045
  DEFINE l_pjaacti  LIKE pja_file.pjaacti    #FUN-810045 
 
  LET g_errno = " "
 #FUN-810045 begin
  #SELECT gjaacti INTO l_gjaacti FROM gja_file 
  #               WHERE gja01 = g_pmk.pmk05 
  SELECT pjaacti,pjaclose INTO l_pjaacti,l_pjaclose FROM pja_file #No.FUN-960038 add pjaclose
                 WHERE pja01 = g_pmk.pmk05 
                   AND pjaacti = 'Y'
 #FUN-810045 end
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3064'
                                  LET l_pjaacti = 0  #FUN-810045 gja->pja 
       WHEN l_pjaacti='N' LET g_errno = '9028'       #FUN-810045 gja->pja
       WHEN l_pjaclose='Y' LET g_errno = 'abg-503'   #No.FUN-960038
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
   
FUNCTION t421_show()
    LET g_pmk_t.* = g_pmk.*
    LET g_pmk_o.* = g_pmk.*
    DISPLAY BY NAME g_pmk.pmk05,g_pmk.pmk06,g_pmk.pmk28
        
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t421_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_pmk.pmk01 IS NULL THEN
        CALL cl_err('',-421,0)
        RETURN
    END IF
    IF g_pmk.pmkacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_pmk.pmk01,9027,0)
        RETURN
    END IF
    MESSAGE ""
    LET g_pmk01_t = g_pmk.pmk01
    BEGIN WORK
    WHILE TRUE
        LET g_pmk_o.* = g_pmk.*
        CALL t421_i("u")                         # 欄位更改
        IF INT_FLAG THEN
#           LET INT_FLAG = 0
            LET g_pmk.*=g_pmk_t.*
            CALL t421_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE pmk_file SET pmk05 = g_pmk.pmk05,   # 更新DB
                            pmk06 = g_pmk.pmk06,
                            pmk28 = g_pmk.pmk28
            WHERE pmk01 = g_argv1                 # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_pmk.pmk01,SQLCA.sqlcode,0)   #No.FUN-660129
            CALL cl_err3("upd","pmk_file",g_pmk.pmk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
