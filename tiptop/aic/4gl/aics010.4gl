# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aics010.4gl
# Description....: ICD參數設定作業
# Date & Author..: FUN-7B0015 07/11/05 By lilingyu 
# Modify.........: FUN-830065 07/03/21 By lilingyu 增加ica09的判斷
# Modify.........: MOD-840154 08/04/20 By lilingyu 處理spare part理由碼
# Modify.........: FUN-920054 09/02/24 By jan 新增 委外發料單別 欄位
# Modify.........: FUN-920172 09/02/26 By jan 新增 是否使用New Code申請流程 欄位
# Modify.........: CHI-920080 09/02/26 By jan 移除掉以下欄位：
# ........................................... ica01,ica07,ica08,ica09,ica16,ica17,ica31
# Modify.........: FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: FUN-A30027 10/05/10 By jan 新增ica042欄位
# Modify.........: FUN-A30092 10/05/10 By jan 新增ica28欄位
# Modify.........: FUN-A30072 10/05/10 By jan 新增ica32欄位
# Modify.........: TQC-AC0293 10/12/20 By vealxu sfp01的開窗/檢查要排除smy73='Y'的單據
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used(2)
# Modify.........: No.FUN-C30250 12/03/22 By bart 加一參數ica44"廠內工單自動產生發料單",預設為"Y"
# Modify.........: No.FUN-C30274 12/04/09 By jason 加一參數ica33 "委外採購單是否自動發出"
# Modify.........: No.FUN-C90121 12/10/17 By bart 加一參數ica45 新增欄位 回貨價格設定
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 添加庫位有效性檢查 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ica            RECORD LIKE ica_file.*, 
       g_ica_t          RECORD LIKE ica_file.*,
       g_ica_o          RECORD LIKE ica_file.*  
 
DEFINE g_forupd_sql        STRING                #SELECT ... FOR UPDATE SQL
DEFINE g_cnt               LIKE type_file.num10  
DEFINE g_i                 LIKE type_file.num5   #count/index for any purpose
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_t1                LIKE oay_file.oayslip   #FUN-920054
DEFINE g_sql               STRING                  #TQC-AC0293 
 
MAIN
   DEFINE l_time           LIKE type_file.chr8                                                                                          
   DEFINE p_row,p_col      LIKE type_file.num5      
 
   OPTIONS
          INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   #NO.FUN-7B0015  --Begin--
   IF NOT s_industry("icd") THEN
      CALL cl_err('','aic-999',1)
      EXIT PROGRAM
   END IF
   #NO.FUN-7B0015  --End
 
   LET p_row = 5 LET p_col = 13
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211 
   OPEN WINDOW aics010_w AT p_row,p_col
      WITH FORM "aic/42f/aics010"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL s010_init()
  
   CALL aics010_show()
    
   LET g_action_choice=""
   CALL aics010_menu()
 
   CLOSE WINDOW aics010_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211 
END MAIN
 
FUNCTION aics010_show()
 
   SELECT * INTO g_ica.* FROM ica_file WHERE ica00 = '0'
 
   DISPLAY BY NAME #g_ica.ica01,                         #CHI-920080
                    g_ica.ica04,g_ica.ica05,g_ica.ica06,
                   #g_ica.ica16,g_ica.ica17,             #CHI-920080
                   #g_ica.ica07,g_ica.ica08,g_ica.ica31, #CHI-920080
                   #g_ica.ica09,                         #CHI-920080
                    g_ica.ica41,g_ica.ica40,g_ica.ica042, #FUN-920054 add ica41 #FUN-920172 add ica40 #FUN-A30027
                    g_ica.ica43,g_ica.ica28,g_ica.ica32,   #FUN-A30027 #FUN-A30092 #FUN-A30072
                    g_ica.ica33,g_ica.ica44, #FUN-C30250 #FUN-C30274 add ica33
                    g_ica.ica45  #FUN-C90121
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION aics010_menu()
 
   MENU ""
      ON ACTION modify
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL aics010_u()
         END IF
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont() 
 
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
         LET g_action_choice = "exit"
         CONTINUE MENU
 
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
         LET INT_FLAG=FALSE
         LET g_action_choice = "exit"
         EXIT MENU
 
   END MENU
 
END FUNCTION
 
 
FUNCTION aics010_u()
 
   MESSAGE ""
   CALL cl_opmsg('u')
    LET g_forupd_sql = " SELECT * FROM ica_file",
                     "  WHERE ica00 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE ica_curl CURSOR FROM g_forupd_sql
   BEGIN WORK
     # LOCK TABLE ica_file IN EXCLUSIVE MODE
      OPEN ica_curl  USING '0'
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('open cursor',SQLCA.sqlcode,1)
         RETURN
      END IF
 
      FETCH ica_curl INTO g_ica.*
      IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('',SQLCA.sqlcode,0)
          RETURN
      END IF
 
      LET g_ica_o.* = g_ica.*
      LET g_ica_t.* = g_ica.*
 
      WHILE TRUE
         CALL aics010_i()
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            CALL aics010_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
         END IF
         UPDATE ica_file SET   #ica01 = g_ica.ica01,  #CHI-920080
                                ica04 = g_ica.ica04,
                                ica05 = g_ica.ica05,
                                ica06 = g_ica.ica06,
                               #ica07 = g_ica.ica07, #CHI-920080 
                               #ica08 = g_ica.ica08, #CHI-920080
                               #ica09 = g_ica.ica09, #CHI-920080
                               #ica16 = g_ica.ica16, #CHI-920080
                               #ica17 = g_ica.ica17, #CHI-920080
                               #ica31 = g_ica.ica31, #CHI-920080
                                ica41 = g_ica.ica41, #FUN-920054
                                ica042= g_ica.ica042, #FUN-920054 #FUN-A30027
                                ica43 = g_ica.ica43, #FUN-A30027
                                ica28 = g_ica.ica28, #FUN-A30092
                                ica32 = g_ica.ica32, #FUN-A30072
                                ica33 = g_ica.ica33, #FUN-C30274
                                ica40 = g_ica.ica40, #FUN-920172  
                                ica44 = g_ica.ica44, #FUN-C30250 
                                ica45 = g_ica.ica45  #FUN-C90121
         WHERE ica00 = '0'
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err('',SQLCA.sqlcode,0)
            CONTINUE WHILE
         END IF
      #   UNLOCK TABLE ica_file
 
         IF INT_FLAG THEN
            CONTINUE WHILE
         ELSE
            LET INT_FLAG = 0
            EXIT WHILE
         END IF
      #  EXIT WHILE
      END WHILE
   CLOSE ica_curl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION aics010_i()
DEFINE l_imd09   LIKE imd_file.imd09
DEFINE l_imdacti LIKE imd_file.imdacti
DEFINE l_azfacti LIKE azf_file.azfacti
DEFINE l_iccacti LIKE icc_file.iccacti
DEFINE l_ice01 LIKE ice_file.ice01
DEFINE li_result LIKE type_file.num5   #FUN-920054
DEFINE l_smy73   LIKE smy_file.smy73   #TQC-AC0293
 
   INPUT BY NAME #g_ica.ica01                         #CHI-920080
                 g_ica.ica04,g_ica.ica32,g_ica.ica33,g_ica.ica05,g_ica.ica06, #FUN-A30072 #FUN-C30274 add ica33
                 g_ica.ica43,g_ica.ica28,  #FUN-A30027 #FUN-A30092
                 #g_ica.ica16,g_ica.ica17,             #CHI-920080
                 #g_ica.ica07,g_ica.ica08,g_ica.ica09, #CHI-920080
                 #g_ica.ica31,                         #CHI-920080
                 g_ica.ica41,g_ica.ica042,g_ica.ica40,   #FUN-920054 #FUN-920172 #FUN-A30027
                 g_ica.ica44,g_ica.ica45  #FUN-C30250  #FUN-C90121
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
#        CALL s010_set_entry()           #CHI-920080 
#        CALL s010_set_no_entry()        #CHI-920080 
         LET g_before_input_done = TRUE
     
#CHI-920080--begin--mark--    
#      AFTER FIELD ica01 
#         IF NOT cl_null(g_ica.ica01) THEN
#            IF g_ica.ica01 NOT MATCHES "[YN]" THEN
#               LET g_ica.ica01 = g_ica_o.ica01
#               DISPLAY BY NAME g_ica.ica01
#               NEXT FIELD ica01
#            END IF
#            LET g_ica_o.ica01 = g_ica.ica01
#         END IF
#CHI-920080--END--mark
 
      AFTER FIELD ica04 
         IF NOT cl_null(g_ica.ica04) THEN
            IF g_ica.ica04 NOT MATCHES "[YN]" THEN
               LET g_ica.ica04 = g_ica_o.ica04
               DISPLAY BY NAME g_ica.ica04
               NEXT FIELD ica04
            END IF
            LET g_ica_o.ica04 = g_ica.ica04
         END IF
 
      AFTER FIELD ica05 
         IF NOT cl_null(g_ica.ica05) THEN
            SELECT imdacti INTO l_imdacti FROM imd_file
             WHERE imd01 = g_ica.ica05
               AND imd10 = "S"
            IF SQLCA.SQLCODE THEN
               CALL cl_err(g_ica.ica05,'aic-034',0)
               LET g_ica.ica05 = g_ica_o.ica05
               DISPLAY BY NAME g_ica.ica05
               NEXT FIELD ica05
            END IF
            IF l_imdacti != "Y" THEN
               CALL cl_err(g_ica.ica05,'aic-035',0)
               LET g_ica.ica05 = g_ica_o.ica05
               DISPLAY BY NAME g_ica.ica05
               NEXT FIELD ica05
            END IF
            LET g_ica_o.ica05 = g_ica.ica05
         END IF
	#FUN-D40103--add--str--
         IF g_ica.ica06 IS NOT NULL THEN 
            IF NOT s010_chk_ica06() THEN NEXT FIELD ica06 END IF
         END IF
         #FUN-D40103--add--end--
 
 
#FUN-A30092--begin--add----------------
      AFTER FIELD ica28 
         IF NOT cl_null(g_ica.ica28) THEN
            SELECT imdacti INTO l_imdacti FROM imd_file
             WHERE imd01 = g_ica.ica28
               AND imd09 = 'N'
               AND imd10 = "S"
            IF SQLCA.SQLCODE THEN
               CALL cl_err(g_ica.ica28,'aic-217',0)
               LET g_ica.ica28 = g_ica_o.ica28
               DISPLAY BY NAME g_ica.ica28
               NEXT FIELD ica28
            END IF
            IF l_imdacti != "Y" THEN
               CALL cl_err(g_ica.ica28,'aic-035',0)
               LET g_ica.ica28 = g_ica_o.ica28
               DISPLAY BY NAME g_ica.ica28
               NEXT FIELD ica28
            END IF
            LET g_ica_o.ica28 = g_ica.ica28
         END IF
#FUN-A30092--end--add--------------------------

      AFTER FIELD ica06 
#FUN-D40103--mark--str--
#         IF NOT cl_null(g_ica.ica06) THEN
##            IF cl_null(g_ica.ica05) THEN
##               CALL cl_err(g_ica.ica06,-070,0)
##               LET g_i = 0 
##               SELECT COUNT(*) INTO g_i FROM ime_file
##                WHERE ime01 = g_ica.ica05
##                  AND ime02 = g_ica.ica06
##                  AND ime04 = "S"
##            ELSE
#               LET g_i = 0 
#               SELECT COUNT(*) INTO g_i FROM ime_file
#                WHERE ime02 = g_ica.ica06
##                  AND ime04 = "S"
##            END IF
#            IF g_i = 0 THEN
#               CALL cl_err(g_ica.ica06,'aic-036',0)
#               LET g_ica.ica06 = g_ica_o.ica06
#               DISPLAY BY NAME g_ica.ica06
#               NEXT FIELD ica06
#            END IF
#            LET g_ica_o.ica06 = g_ica.ica06
#         END IF
#FUN-D40103--mark--end-- 
	#FUN-D40103--add--str--
         IF cl_null(g_ica.ica06) THEN LET g_ica.ica06 = ' ' END IF 
         IF NOT s010_chk_ica06() THEN NEXT FIELD ica06 END IF 
         LET g_ica_o.ica06 = g_ica.ica06 
         #FUN-D40103--add--end--

#CHI-920080--begin--mark--
#      AFTER FIELD ica07 
#         IF NOT cl_null(g_ica.ica07) THEN
#           IF g_ica.ica07 NOT MATCHES "[YN]" THEN
#               LET g_ica.ica07 = g_ica_o.ica07
#               DISPLAY BY NAME g_ica.ica07
#               NEXT FIELD ica07
#            END IF
#            LET g_ica_o.ica07 = g_ica.ica07
#         END IF
 
#      BEFORE FIELD ica08
#         CALL s010_set_entry()
 
#      AFTER FIELD ica08 
#         IF NOT cl_null(g_ica.ica08) THEN
#            IF g_ica.ica08 NOT MATCHES "[YN]" THEN
#                  LET g_ica.ica08 = g_ica_o.ica08
#                  DISPLAY BY NAME g_ica.ica08
#                  NEXT FIELD ica08
#            END IF
#            CALL s010_set_no_entry()
#            LET g_ica_o.ica08 = g_ica.ica08
            
#         END IF
 
#      AFTER FIELD ica09 
#         IF NOT cl_null(g_ica.ica09) THEN
#            IF g_ica.ica09 NOT MATCHES "[123]" THEN
#               LET g_ica.ica09 = g_ica_o.ica09
#               DISPLAY BY NAME g_ica.ica09
#               NEXT FIELD ica09
#            END IF
#            LET g_ica_o.ica08 = g_ica.ica08
#         #  NEXT FIELD ica08      #MOD-840154
#         END IF
 
#     AFTER FIELD ica16 
#        IF NOT cl_null(g_ica.ica16) THEN
#           SELECT iccacti INTO l_iccacti FROM icc_file
#            WHERE icc01 = g_ica.ica16
#           IF SQLCA.SQLCODE THEN
#              CALL cl_err(g_ica.ica16,'aic-037',0)
#              LET g_ica.ica16 = g_ica_o.ica16
#              DISPLAY BY NAME g_ica.ica16
#              NEXT FIELD ica16
#           END IF
#           IF l_iccacti != "Y" THEN
#              CALL cl_err(g_ica.ica16,'aic-038',0)
#              LET g_ica.ica16 = g_ica_o.ica16
#              DISPLAY BY NAME g_ica.ica16
#              NEXT FIELD ica16
#           END IF
#           LET g_ica_o.ica16 = g_ica.ica16
#        END IF
 
#     AFTER FIELD ica17 
#        IF NOT cl_null(g_ica.ica17) THEN
#           IF SQLCA.SQLCODE THEN
#              CALL cl_err(g_ica.ica17,'aic-039',0)
#              LET g_ica.ica17 = g_ica_o.ica17
#              DISPLAY BY NAME g_ica.ica17
#              NEXT FIELD ica17
#           END IF
#           LET g_ica_o.ica17 = g_ica.ica17
#        END IF
#  
#     AFTER FIELD ica31
#        IF NOT cl_null(g_ica.ica31) THEN
#           SELECT azfacti INTO l_azfacti FROM azf_file                                                                             
#            WHERE azf01 = g_ica.ica31                                                                                       
#              AND azf02 = "2"                                                                                                      
#           IF SQLCA.SQLCODE THEN                                                                                                   
#              CALL cl_err(g_ica.ica31,'aic-040',0)                                                                          
#              LET g_ica.ica31 = g_ica_o.ica31                                                                        
#              DISPLAY BY NAME g_ica.ica31                                                                                   
#              NEXT FIELD ica31                                                                                                 
#           END IF                                                                                                                  
#           IF l_azfacti != "Y" THEN                                                                                                
#              CALL cl_err(g_ica.ica31,'aic-041',0)                                                                          
#              LET g_ica.ica31 = g_ica_o.ica31                                                                        
#              DISPLAY BY NAME g_ica.ica31                                                                                   
#              NEXT FIELD ica31                                                                                                 
#           END IF                                                                                                                  
#            LET g_ica_o.ica31 = g_ica.ica31
#            #NO.FUN-830065 --Begin--
#            IF g_ica.ica08 = 'N' THEN
#            # NEXT FIELD ica01       #MOD-840154 
#            ELSE
#            #  NEXT FIELD ica09
#           END IF                   
#           #NO.FUN-830065  -End-                                                
#        END IF                    
#CHI-920080--END--mark--
 
      #FUN-920054--BEGIN--
      AFTER FIELD ica41
        IF NOT cl_null(g_ica.ica41) THEN
           IF g_ica_o.ica41 != g_ica.ica41 OR g_ica_o.ica41 IS NULL THEN
              CALL s_check_no("asf",g_ica.ica41,g_ica_o.ica41,'3',"ica_file","ica41","")
              RETURNING li_result,g_ica.ica41
              LET g_ica.ica41=g_ica.ica41[1,g_doc_len]
              DISPLAY BY NAME g_ica.ica41
              IF (NOT li_result) THEN
                 LET g_ica.ica41=g_ica_o.ica41
                 NEXT FIELD ica41
              END IF
           END IF
          #TQC-AC0293 ---------add start-------------
           SELECT smy73 INTO l_smy73 FROM smy_file
            WHERE smyslip = g_ica.ica41
           IF l_smy73 = 'Y' THEN
              CALL cl_err('ica41','asf-872',0)
              LET g_ica.ica41=g_ica_o.ica41
              NEXT FIELD ica41
           END IF
          #TQC-AC0293 ---------add end-------------
        END IF
      #FUN-920054--END--
 
      #FUN-A30027--BEGIN------
      AFTER FIELD ica042                                                                                                             
        IF NOT cl_null(g_ica.ica042) THEN                                                                                            
           IF g_ica_o.ica042 != g_ica.ica042 OR g_ica_o.ica042 IS NULL THEN                                                            
              CALL s_check_no("asf",g_ica.ica042,g_ica_o.ica042,'1',"ica_file","ica042","")                                            
              RETURNING li_result,g_ica.ica042                                                                                       
              LET g_ica.ica042=g_ica.ica042[1,g_doc_len]                                                                              
              DISPLAY BY NAME g_ica.ica042                                                                                           
              IF (NOT li_result) THEN                                                                                               
                 LET g_ica.ica042=g_ica_o.ica042                                                                                      
                 NEXT FIELD ica042                                                                                                   
              END IF                                                                                                                
           END IF                                                                                                                   
          #TQC-AC0293 ---------add start-------------
           SELECT smy73 INTO l_smy73 FROM smy_file
            WHERE smyslip = g_ica.ica042
           IF l_smy73 = 'Y' THEN
              CALL cl_err('ica042','asf-872',0)
              LET g_ica.ica042=g_ica_o.ica042
              NEXT FIELD ica042
           END IF     
          #TQC-AC0293 ---------add end-------------   
        END IF
      #FUN-A30027--end--add-----
  
      #FUN-A30027--begin--add-----
      ON ACTION browse
         LET g_ica.ica43 = cl_browse_dir()
         DISPLAY g_ica.ica43  TO ica43
      #FUN-A30027--end--add---
      
      AFTER INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            CALL aics010_show()
            EXIT INPUT
         END IF
      
         IF NOT cl_null(g_ica.ica06) AND
            NOT cl_null(g_ica.ica05) THEN
           
            LET g_i = 0 
            SELECT COUNT(*) INTO g_i FROM ime_file
               WHERE ime01 = g_ica.ica05
                 AND ime02 = g_ica.ica06
                 AND ime05 = 'Y'
            IF SQLCA.SQLCODE THEN                                                                                           
               CALL cl_err(g_ica.ica05,'aic-042',0)                                                                         
               LET g_ica.ica05 = g_ica_o.ica05 
               LET g_ica.ica06 = g_ica_o.ica06                                                                            
               DISPLAY BY NAME g_ica.ica05,g_ica.ica06                                                                                  
               NEXT FIELD ica05                                                                                             
            END IF                 
          ELSE
            LET g_i = 0 
            SELECT COUNT(*) INTO g_i FROM ime_file
             WHERE ime01 = g_ica.ica05
               AND ime05 = 'Y'
         END IF
         IF g_i = 0 THEN
            CALL cl_err(g_ica.ica05,'aic-042',0)
            LET g_ica.ica05 = g_ica_o.ica05
            DISPLAY BY NAME g_ica.ica05
            NEXT FIELD ica05
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ica05) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_imd"
               LET g_qryparam.arg1 = "S"
               LET g_qryparam.default1 = g_ica.ica05
               CALL cl_create_qry() RETURNING g_ica.ica05
               DISPLAY BY NAME g_ica.ica05
               NEXT FIELD ica05
 
            #FUN-A30092--begin--add-----
            WHEN INFIELD(ica28) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_imd"
               LET g_qryparam.arg1 = "S"
               LET g_qryparam.where = " imd09 = 'N' " 
               LET g_qryparam.default1 = g_ica.ica28
               CALL cl_create_qry() RETURNING g_ica.ica28
               DISPLAY BY NAME g_ica.ica28
               NEXT FIELD ica28
            #FUN-A30092--end--add--------

            WHEN INFIELD(ica06)
                  CALL cl_init_qry_var()
                  IF NOT cl_null(g_ica.ica05) THEN
                  LET g_qryparam.form = "q_ime"
                  LET g_qryparam.arg1 = g_ica.ica05
                  LET g_qryparam.arg2 = "S"
                  LET g_qryparam.default1 = g_ica.ica06
                  CALL cl_create_qry() RETURNING g_ica.ica06
                ELSE
                   CALL cl_err("","-070",0)
#                  LET g_qryparam.form = "q_ime1"
#                  LET g_qryparam.arg1 = "S"
#                  LET g_qryparam.default1 = g_ica.ica05
#                  LET g_qryparam.default2 = g_ica.ica06
#                  CALL cl_create_qry() RETURNING g_ica.ica05,
#                                                 g_ica.ica06
               END IF
#               DISPLAY BY NAME g_ica.ica05,g_ica.ica06
               DISPLAY BY NAME g_ica.ica06
               NEXT FIELD ica06
 
#CHI-920080--BEGIN--mark--
#           WHEN INFIELD(ica16) 
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_icc"
#              LET g_qryparam.default1 = g_ica.ica16
#              CALL cl_create_qry() RETURNING g_ica.ica16
#              DISPLAY BY NAME g_ica.ica16
#              NEXT FIELD ica16
 
#           WHEN INFIELD(ica17) 
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_ice1"
#              LET g_qryparam.default1 = g_ica.ica17
#              CALL cl_create_qry() RETURNING g_ica.ica17
#              DISPLAY BY NAME g_ica.ica17
#              NEXT FIELD ica17
 
#           WHEN INFIELD(ica31)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_azf"
#              LET g_qryparam.arg1 = "2" 
#              LET g_qryparam.default1 = g_ica.ica31
#              CALL cl_create_qry() RETURNING g_ica.ica31
#              DISPLAY BY NAME g_ica.ica31
#              NEXT FIELD ica31  
#CHI-920080--end--mark
 
            #FUN-920054--BEGIN--
            WHEN INFIELD(ica41)
               LET g_sql = " (smy73 <> 'Y' OR smy73 is null) "           #TQC-AC0293 
               CALL smy_qry_set_par_where(g_sql)      #TQC-AC0293
               CALL q_smy( FALSE, TRUE,g_t1,'ASF','3') RETURNING g_t1
               LET g_ica.ica41 = g_t1
               DISPLAY BY NAME g_ica.ica41
               NEXT FIELD ica41
            #FUN-920054--END-
 
            #FUN-A30027--begin------
            WHEN INFIELD(ica042)
               LET g_sql = " (smy73 <> 'Y' OR smy73 is null) "          #TQC-AC0293
               CALL smy_qry_set_par_where(g_sql)     #TQC-AC0293
               CALL q_smy( FALSE, TRUE,g_t1,'ASF','1') RETURNING g_t1
               LET g_ica.ica042 = g_t1
               DISPLAY BY NAME g_ica.ica042
               NEXT FIELD ica042
            #FUN-A30027--end-------

            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
END FUNCTION
 
#CHI-920080--BEGIN--MARK--
#FUNCTION s010_set_entry()
 
#  IF INFIELD(ica08) THEN
#     CALL cl_set_comp_entry("ica09",TRUE)
#  END IF
 
#END FUNCTION
 
#FUNCTION s010_set_no_entry()
 
#  IF g_ica.ica08 = 'N' THEN
#     CALL cl_set_comp_entry("ica09",FALSE)
#  END IF
 
#END FUNCTION
#CHI-920080--end--mark--
 
FUNCTION s010_init()
     LET g_ica.ica00 = '0'                                                                                                   
     LET g_i = 0                                                                                                             
     SELECT COUNT(*) INTO g_i FROM ica_file                                                                                  
     WHERE ica00 = '0'                                                                                                      
  IF cl_null(g_i) OR g_i < = 0 THEN                                                                                       
#    LET g_ica.ica01 = "Y"     #CHI-920080                                                                                           
     LET g_ica.ica04 = "N"                                                                                                
     LET g_ica.ica06 = ''                                                                                                 
#    LET g_ica.ica07 = "N"     #CHI-920080                                                                          
#    LET g_ica.ica08 = "N"     #CHI-920080                                                                                     
#    LET g_ica.ica09 = '1'     #CHI-920080                                                                                           
     LET g_ica.ica40 = 'N'     #FUN-920172
     LET g_ica.ica32 = 'N'     #FUN-A30072
     LET g_ica.ica33 = 'N'     #FUN-C30274
     LET g_ica.ica44 = 'Y'     #FUN-C30250
     LET g_ica.ica45 = '1'     #FUN-C90121
     INSERT INTO ica_file VALUES(g_ica.*)                                                                                 
     IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN                                                                        
        CALL cl_err('',SQLCA.sqlcode,0)                                                                                   
     END IF                                                                                                               
  END IF    
END FUNCTION
	
	#FUN-D40103--add--str--
FUNCTION s010_chk_ica06()
DEFINE l_imeacti LIKE ime_file.imeacti
DEFINE l_err     LIKE ime_file.ime02  #TQC-D50116 add

   IF NOT cl_null(g_ica.ica06) THEN
      LET g_i = 0 
      SELECT COUNT(*) INTO g_i FROM ime_file
       WHERE ime02 = g_ica.ica06
         AND ime01 = g_ica.ica05  #FUN-D40103 add
      #   AND ime04 = "S"
      IF g_i = 0 THEN
         CALL cl_err(g_ica.ica06,'aic-036',0)
         LET g_ica.ica06 = g_ica_o.ica06
         DISPLAY BY NAME g_ica.ica06
         RETURN FALSE 
      END IF
   END IF
   LET l_imeacti = ''
   SELECT imeacti INTO l_imeacti FROM ime_file
    WHERE ime02 = g_ica.ica06
      AND ime01 = g_ica.ica05  
   IF l_imeacti = 'N' THEN
      LET l_err = g_ica.ica06                          #TQC-D50116 add
      IF cl_null(l_err) THEN LET l_err = "' '" END IF  #TQC-D50116 add 
      CALL cl_err_msg("","aim-507",g_ica.ica05 || "|" || l_err ,0)  #TQC-D50116 
      LET g_ica.ica06 = g_ica_o.ica06
      DISPLAY BY NAME g_ica.ica06
      RETURN FALSE 
   END IF 
   RETURN TRUE
END FUNCTION
#FUN-D40103--add--end--
