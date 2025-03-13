# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gisp120.4gl
# Descriptions...: 銷項發票資料匯入作業
# Date & Author..: 02/04/16 By Danny
# Modify ........: No.FUN-540007 05/06/14 By wujie 增加從客戶端匯入資料的功能 
# Modify.........: No.FUN-580006 05/08/15 By ice 修正發票底稿作業與航天金穗防偽稅控系統接口,資料來源以稅卡回傳為准
# Modify.........: No.FUN-630077 06/04/17 By ice 航天金穗發票匯入時,產生到ome_file,以利后續作業能查到發票資料
# Modify.........: No.MOD-650036 06/05/09 By Carrier 發票刪除/作廢時,更新ogb60,CALL s_upd_ogb60
# Modify.........: No.FUN-660146 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-690009 06/09/04 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0098 06/10/26 By atsea l_time轉g_time
# Modify.........: No.TQC-790089 07/09/18 By jamie 重複的錯誤碼-239在5X的informix錯誤代碼會變成-268 Constraint
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0014 09/12/09 By shiwuying s_insome
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2) 
# Modify.........: No:FUN-910088 11/12/29 By chenjing 增加數量欄位小數取位

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_sql     STRING,  #No.FUN-580092 HCN
        g_txt1    LIKE type_file.chr20,        #NO FUN-690009 VARCHAR(20)       
        g_txt2    LIKE type_file.chr20         #NO FUN-690009 VARCHAR(20)
#No.FUN-540007--begin                                                                                                               
DEFINE  g_target  LIKE type_file.chr1000,      #NO FUN-690009 VARCHAR(100)                                                                                                    
        g_fileloc LIKE type_file.chr1000       #NO FUN-690009 VARCHAR(100)                                                                                                      
#No.FUN-540007--end 
DEFINE  channel_r base.Channel                 #No.FUN-540007 
DEFINE  i         LIKE type_file.num5          #NO FUN-690009 SMALLIN
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8      #No.FUN-6A0098
   DEFINE p_row,p_col   LIKE type_file.num5    #NO FUN-690009 SMALLINT
 
   OPTIONS
      INPUT NO WRAP
      DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GIS")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
   OPEN WINDOW p120 AT p_row,p_col
      WITH FORM "gis/42f/gisp120" 
################################################################################
#  START genero shell script ADD
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
#  END genero shell script ADD
################################################################################
 
   CALL cl_opmsg('z')
#No.FUN-540007--begin
#  DROP TABLE seq_file
#  CREATE TEMP TABLE seq_file(ss VARCHAR(500))
#  IF STATUS THEN CALL cl_err('create tmp',STATUS,1) EXIT PROGRAM END IF
   CALL p120_menu()
#  CALL p120()
#No.FUN-540007--end   
   CLOSE WINDOW p120
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098
END MAIN
 
#No.FUN-540007--begin                                                                                                               
FUNCTION p120_menu()                                                                                                                
   DEFINE l_cmd  LIKE type_file.chr1000     #NO FUN-690009 VARCHAR(100)                                                                                                       
   MENU ""                                                                                                                         
                                                                                                                                   
      ON ACTION client                                                                                                            
         LET g_action_choice="client"                                                                                            
         IF cl_chk_act_auth() THEN                                                                                               
            CALL p120_c()                                                                                                      
         END IF                                                                                                                  
 
      ON ACTION host                                                                                                              
         LET g_action_choice="host"                                                                                              
         IF cl_chk_act_auth() THEN                                                                                               
            CALL p120_h()                                                                                                      
         END IF                                                                                                                  
 
      ON ACTION help                                                                                                              
         CALL cl_show_help()                                                                                                     
 
      ON ACTION exit                                                                                                              
         LET g_action_choice = "exit"                                                                                            
         EXIT MENU                                                                                                               
 
      ON ACTION controlg   
         CALL cl_cmdask()                                                                                                        
 
      ON ACTION locale                                                                                                            
         CALL cl_dynamic_locale()                                                                                                
 
      ON IDLE g_idle_seconds                                                                                                      
         CALL cl_on_idle()                                                                                                        
         CONTINUE MENU                                                                                                            
 
      ON ACTION about                                                                                                             
         CALL cl_about()                                                                                                          
 
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145                                                                                                        
         LET INT_FLAG=FALSE #MOD-570244mars
         LET g_action_choice = "exit"                                                                                             
         EXIT MENU                                                                                                                
 
   END MENU                                                                                                                        
END FUNCTION                                                                                                                        
#No.FUN-540007--end  
 
FUNCTION p120_h()         #No.FUN-540007
#No.FUN-580006 --start--
#No.FUN-540007--begin                                                                                                               
#  DROP TABLE seq_file                                                                                                           
#  CREATE TEMP TABLE seq_file(ss VARCHAR(500))                                                                                      
#  IF STATUS THEN CALL cl_err('create tmp',STATUS,1) EXIT PROGRAM END IF 
#No.FUN-540007--end  
#No.FUN-580006 --end--
   WHILE TRUE
      LET g_txt1 = 'INVSALE.TXT'
      LET g_txt2 = 'INVWAST.TXT'
#     DELETE FROM seq_file     #No.FUN-580006
 
      INPUT BY NAME g_txt1,g_txt2 WITHOUT DEFAULTS 
       
         AFTER FIELD g_txt1
            IF cl_null(g_txt1) THEN
               NEXT FIELD g_txt1
            END IF
 
         AFTER FIELD g_txt2
            IF cl_null(g_txt2) THEN
               NEXT FIELD g_txt2
            END IF
################################################################################
# START genero shell script ADD
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
      
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 EXIT WHILE
      END IF
      IF NOT cl_sure(0,0) THEN
         RETURN 
      END IF
      CALL cl_wait()
      CALL p120_t_h()          #No.FUN-540007
      ERROR ''
      CALL cl_end(0,0)
      IF INT_FLAG THEN 
         LET INT_FLAG = 0 EXIT WHILE
      END IF
   END WHILE
 
END FUNCTION
 
#No.FUN-580006
FUNCTION p120_t_h()              #No.FUN-540007
#  DEFINE l_sql         VARCHAR(600)
#  DEFINE l_name        VARCHAR(20)
#  DEFINE l_cnt         SMALLINT
#  DEFINE ss            VARCHAR(1000)
#  DEFINE l_str         ARRAY[20] OF VARCHAR(100)
#  DEFINE m_isc         RECORD LIKE isc_file.*
#  DEFINE m_isd         RECORD LIKE isd_file.*
#  DEFINE l_i,l_j,l_b,l_e,l_len     SMALLINT
   DEFINE i  LIKE type_file.num5          #NO FUN-690009 SMALLINT
   LET channel_r = base.Channel.create()                                                                                         
   FOR i = 1 TO 2
      IF i = 1 THEN 
         LET g_target  = FGL_GETENV("TEMPDIR"),"\/",g_txt1 
      END IF
      IF i = 2 THEN 
         LET g_target  = FGL_GETENV("TEMPDIR"),"\/",g_txt2
      END IF
      CALL p120_t_c()
   END FOR
 
#  LET g_success='Y'
#  BEGIN WORK
#  FOR i = 1 TO 2
#     DELETE FROM seq_file
#     IF i = 1 THEN
#        LOAD FROM g_txt1 INSERT INTO seq_file
#     ELSE
#        LOAD FROM g_txt2 INSERT INTO seq_file
#     END IF
#     DECLARE p120_curs1 CURSOR FOR SELECT * FROM seq_file
#     FOREACH p120_curs1 INTO ss
#        IF STATUS THEN
#           CALL cl_err('p120_curs1',STATUS,1) LET g_success = 'N' EXIT FOREACH
#        END IF
#        LET l_len = length(ss)
#        LET l_i = 0
#        FOR l_i = 1 TO 20 LET l_str[l_i] = NULL END FOR
#        LET l_i = 0
#        LET l_j = 0
#        LET l_b = 1
#        FOR l_i = 1 TO l_len
#           IF ss[l_i,l_i]=',' THEN
#              LET l_j = l_j + 1
#              LET l_e = l_i - 1
#              LET l_str[l_j] = ss[l_b,l_e]
#              LET l_b = l_i + 1
#           END IF
#        END FOR
#        LET l_str[l_j+1] = ss[l_b,l_len]
#        IF l_len > 88 THEN 
#           IF i = 1 THEN
#              LET m_isc.isc00 = '0'
#           ELSE
#              LET m_isc.isc00 = '1'
#           END IF
#           LET m_isc.isc01 = l_str[1]
#           LET m_isc.isc02 = l_str[2]
#           LET m_isc.isc03 = l_str[3] 
#           LET m_isc.isc04 = l_str[4]
#           LET m_isc.isc05 = l_str[5]
#           LET m_isc.isc06 = l_str[6]
#           LET m_isc.isc06 = m_isc.isc06 * 100
#           LET m_isc.isc07 = l_str[7]
#           LET m_isc.isc08 = l_str[8]
#           LET m_isc.isc09 = l_str[9]
#           LET m_isc.isc10 = l_str[10]
#           LET m_isc.isc11 = l_str[11]
#           LET m_isc.isc12 = l_str[12]
#           LET m_isc.isc13 = l_str[13]
#           LET m_isc.isc14 = l_str[14]
#           LET m_isc.isc15 = l_str[15]
#           LET m_isc.isc16 = l_str[16]
#           LET m_isc.isc17 = l_str[17]
#           #產生銷項發票歷史記錄單頭檔
#           INSERT INTO isc_file VALUES(m_isc.*)
#           IF STATUS != 0 AND STATUS != -239 THEN
#              CALL cl_err('ins isc',STATUS,1) LET g_success='N' EXIT FOREACH
#           END IF
#           IF STATUS = -239 THEN
#              UPDATE isc_file SET * = m_isc.*
#               WHERE isc00 = m_isc.isc00 AND isc01 = m_isc.isc01
#                 AND isc04 = m_isc.isc04
#              IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#                 CALL cl_err('upd isc',STATUS,1) LET g_success='N' EXIT FOREACH
#              END IF
#           END IF
#           #更新銷項發票底稿單頭檔
#           IF m_isc.isc00 = '0' THEN  #已開發票
#              UPDATE isa_file SET isa01 = m_isc.isc01,isa02 = m_isc.isc17,
#                                  isa03 = m_isc.isc03,isa07 = '2'
#               WHERE isa01 = ' ' AND isa04 = m_isc.isc04
#              IF STATUS THEN
#                 CALL cl_err('upd isa',STATUS,1) LET g_success='N' EXIT FOREACH
#              END IF
#           ELSE                       #作廢發票
#              UPDATE isa_file SET isa07 = 'V'
#               WHERE isa01 = m_isc.isc01 AND isa04 = m_isc.isc04
#              IF STATUS THEN
#                 CALL cl_err('upd isa#2',STATUS,1) LET g_success='N' EXIT FOREACH
#              END IF
#           END IF
#           #更新銷項發票底稿單身檔
#           IF m_isc.isc00 = '0' THEN  #已開發票
#              UPDATE isb_file SET isb01 = m_isc.isc01
#               WHERE isb01 = ' ' AND isb02 = m_isc.isc04
#              IF STATUS THEN
#                 CALL cl_err('upd isb',STATUS,1) LET g_success='N' EXIT FOREACH
#              END IF
#           END IF
#           #更新應收帳款單頭檔
#           IF m_isc.isc00 = '0' THEN  #已開發票
#              UPDATE oma_file SET oma10 = m_isc.isc01, oma09 = m_isc.isc03
#               WHERE oma01 = m_isc.isc04
#              IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#                 CALL cl_err('upd oma',STATUS,1) LET g_success='N' EXIT FOREACH
#              END IF
#           ELSE                       #作廢發票
#              UPDATE oma_file SET oma10 = '', oma09 = ''
#               WHERE oma01 = m_isc.isc04
#              IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#                 CALL cl_err('upd oma',STATUS,1) LET g_success='N' EXIT FOREACH
#              END IF
#           END IF
#        ELSE
#           LET m_isd.isd00 = m_isc.isc00
#           LET m_isd.isd01 = m_isc.isc01
#           LET m_isd.isd02 = m_isc.isc04
#           LET m_isd.isd03 = l_str[1]
#           LET m_isd.isd04 = l_str[2]
#           LET m_isd.isd05 = l_str[3]
#           LET m_isd.isd06 = l_str[4]
#           LET m_isd.isd07 = l_str[5]
#           LET m_isd.isd08 = l_str[6]
#           LET m_isd.isd09 = l_str[7]
#           #產生銷項發票歷史記錄單身檔
#           INSERT INTO isd_file VALUES(m_isd.*)
#           IF STATUS != 0 AND STATUS != -239 THEN
#              CALL cl_err('ins isd',STATUS,1) LET g_success='N' EXIT FOREACH
#           END IF
#           IF STATUS = -239 THEN
#              UPDATE isd_file SET * = m_isd.*
#               WHERE isd00 = m_isd.isd00 AND isd01 = m_isd.isd01
#                 AND isd02 = m_isd.isd02 AND isd03 = m_isd.isd03
#              IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#                 CALL cl_err('upd isd',STATUS,1) LET g_success='N' EXIT FOREACH
#              END IF
#           END IF
#        END IF
#     END FOREACH 
#  END FOR
#  IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION
 
#No.FUN-540007--begin
FUNCTION p120_c()
 
   LET g_fileloc = "C:\/TIPTOP\/INVOUT.TXT"                                                                                      
   LET channel_r = base.Channel.create()                                                                                         
   LET g_target  = FGL_GETENV("TEMPDIR"),"\/", "INVOUT_",g_dbs CLIPPED,".TXT"  
 
   WHILE TRUE
      INPUT BY NAME g_fileloc WITHOUT DEFAULTS 
         AFTER FIELD g_fileloc
            IF cl_null(g_fileloc) THEN
               NEXT FIELD g_fileloc
            END IF
 
         ON ACTION update
            LET g_fileloc = cl_browse_file()
            DISPLAY g_fileloc TO FORMONLY.g_fileloc  
         
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
      
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 EXIT WHILE
      END IF
      IF NOT cl_sure(0,0) THEN
         RETURN 
      END IF
      IF g_fileloc IS NOT NULL THEN 
         IF NOT cl_upload_file(g_fileloc,g_target) THEN
            CALL cl_err("Can't upload file: ", g_fileloc, 0)
            RETURN 
         END IF
      ELSE CONTINUE WHILE END IF
      CALL cl_wait()
      CALL p120_t_c()
      ERROR ''
      CALL cl_end(0,0)
      IF INT_FLAG THEN 
         LET INT_FLAG = 0 EXIT WHILE
      END IF
   END WHILE
 
END FUNCTION
 
FUNCTION p120_t_c()
   DEFINE l_sql         LIKE type_file.chr1000   #NO FUN-690009 VARCHAR(600)
   DEFINE l_name        LIKE type_file.chr20     #NO FUN-690009 VARCHAR(20)
   DEFINE l_cnt         LIKE type_file.num5      #NO FUN-690009 SMALLINT
   DEFINE m_isc  RECORD LIKE isc_file.*
   DEFINE m_isd  RECORD LIKE isd_file.*
   DEFINE l_i,l_j,l_b,l_e,l_len     LIKE type_file.num5    #NO FUN-690009 SMALLINT
   DEFINE tok           base.StringTokenizer
   DEFINE ss            STRING
   DEFINE l_tmp         STRING
   DEFINE l_str         DYNAMIC ARRAY OF STRING
   DEFINE l_sw          LIKE type_file.chr1       # Prog. Version..: '5.30.06-13.03.12(01)  #  '1':發票單頭  '2':發票單身   '0':無效資料
   DEFINE l_oma21       LIKE oma_file.oma21       #No.FUN-630077 稅別
 
   LET g_success='Y'
   LET l_sw='0'
   BEGIN WORK
   CALL channel_r.openFile(g_target,  "r")
   IF STATUS THEN
      CALL cl_err("Can't open file: ", STATUS, 0)
      RETURN
   END IF
   WHILE channel_r.read(ss)
      LET tok = base.StringTokenizer.createExt(ss,"~~",'',TRUE)
      IF ss.substring(1,2)='//' THEN 
         LET l_sw= '1' 
         CONTINUE WHILE 
      END IF
      IF ss.substring(1,2) IS NULL THEN LET l_sw= '0' END IF
      CASE l_sw
         WHEN '1' 
            LET l_i=0
            LET l_j=0
            CALL l_str.clear()
            WHILE tok.hasMoreTokens()
               LET l_i=l_i+1
               IF l_i MOD 2 THEN 
                  LET l_j=l_j+1
                  LET l_str[l_j]=tok.nextToken()
               ELSE 
                  LET l_tmp= tok.nextToken()
               END IF
            END WHILE
            #No.FUN-580006 --start--
            LET m_isc.isc00 = l_str[1]
            LET m_isc.isc01 = l_str[5]
            LET m_isc.isc02 = l_str[6]
            LET m_isc.isc03 = l_str[7] 
            LET m_isc.isc04 = l_str[9]
            LET m_isc.isc05 = l_str[10]
            LET m_isc.isc06 = l_str[11]
            LET m_isc.isc05 = m_isc.isc05 * m_isc.isc06
            LET m_isc.isc06 = m_isc.isc06 * 100
            LET m_isc.isc07 = l_str[13]
            LET m_isc.isc08 = l_str[14]
            LET m_isc.isc09 = l_str[15]
            LET m_isc.isc10 = l_str[16]
            LET m_isc.isc11 = l_str[19]
            LET m_isc.isc12 = l_str[20]
            LET m_isc.isc13 = l_str[22]
            LET m_isc.isc14 = l_str[21]
            LET m_isc.isc15 = l_str[23]
            LET m_isc.isc16 = l_str[24]
            LET m_isc.isc17 = l_str[4]
            LET m_isc.isclegal = g_legal  #FUN-980011 add
            #產生銷項發票歷史記錄單頭檔
            #No.FUN-580006 --end--
            INSERT INTO isc_file VALUES(m_isc.*)
           #IF STATUS != 0 AND STATUS != -239 THEN                         #TQC-790089 mark
            IF STATUS != 0 AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN  #TQC-790089 mod
#              CALL cl_err('ins isc',STATUS,1)    #No.FUN-660146
              #CALL cl_err3("ins","isc_file",m_isc.isc01,m_isc.isc04,STATUS,"","ins isc",1)        #TQC-790089 mark #No.FUN-660146
               CALL cl_err3("ins","isc_file",m_isc.isc01,m_isc.isc04,SQLCA.SQLCODE,"","ins isc",1) #TQC-790089 mod  #No.FUN-660146
               LET g_success='N' 
               EXIT WHILE
            END IF
           #IF STATUS = -239 THEN                     #TQC-790089 mark
            IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #TQC-790089 mod
               UPDATE isc_file SET * = m_isc.*
                WHERE isc00 = m_isc.isc00 AND isc01 = m_isc.isc01
                  AND isc04 = m_isc.isc04
               IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#                 CALL cl_err('upd isc',STATUS,1)    #No.FUN-660146
                  CALL cl_err3("upd","isc_file",m_isc.isc01,m_isc.isc04,STATUS,"","upd isc",1)   #No.FUN-660146
                  LET g_success='N' 
                  EXIT WHILE
               END IF
            END IF
            #更新銷項發票底稿單頭檔
            IF m_isc.isc00 = '0' THEN  #已開發票
               UPDATE isa_file SET isa01 = m_isc.isc01,isa02 = m_isc.isc17,
                                   isa03 = m_isc.isc03,isa07 = '2'
                WHERE isa01 = ' ' AND isa04 = m_isc.isc04
               IF STATUS THEN
#                 CALL cl_err('upd isa',STATUS,1)   #No.FUN-660146
                  CALL cl_err3("upd","isa_file",m_isc.isc04,"",STATUS,"","upd isa",1)   #No.FUN-660146
                  LET g_success='N' EXIT WHILE
               END IF
            ELSE                       #作廢發票
               UPDATE isa_file SET isa07 = 'V'
                WHERE isa01 = m_isc.isc01 AND isa04 = m_isc.isc04
               IF STATUS THEN
#                 CALL cl_err('upd isa#2',STATUS,1)  #No.FUN-660146
                  CALL cl_err3("upd","isa_file",m_isc.isc01,m_isc.isc04,STATUS,"","upd isa#2",1)   #No.FUN-660146
                  LET g_success='N' EXIT WHILE  
               END IF
            END IF
            #更新銷項發票底稿單身檔
            IF m_isc.isc00 = '0' THEN  #已開發票
               UPDATE isb_file SET isb01 = m_isc.isc01
                WHERE isb01 = ' ' AND isb02 = m_isc.isc04
               IF STATUS THEN
#                 CALL cl_err('upd isb',STATUS,1)   #No.FUN-660146
                  CALL cl_err3("upd","isb_file",m_isc.isc04,"",STATUS,"","upd isb",1)   #No.FUN-660146
                  LET g_success='N' EXIT WHILE 
               END IF
            END IF
            #更新應收帳款單頭檔
            IF m_isc.isc00 = '0' THEN  #已開發票
               UPDATE oma_file SET oma10 = m_isc.isc01, oma09 = m_isc.isc03
                WHERE oma01 = m_isc.isc04
               IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#                 CALL cl_err('upd oma',STATUS,1)   #No.FUN-660146
                  CALL cl_err3("upd","oma_file",m_isc.isc04,"",STATUS,"","upd oma",1)   #No.FUN-660146
                  LET g_success='N' EXIT WHILE 
               END IF
               CALL s_upd_ogb60(m_isc.isc04)  #No.MOD-650036
            ELSE                      #作廢發票 
               UPDATE oma_file SET oma10 = '', oma09 = ''
                WHERE oma01 = m_isc.isc04
               IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#                 CALL cl_err('upd oma',STATUS,1)   #No.FUN-660146
                  CALL cl_err3("upd","oma_file",m_isc.isc04,"",STATUS,"","upd oma",1)   #No.FUN-660146
                  LET g_success='N' EXIT WHILE 
               END IF
               CALL s_upd_ogb60(m_isc.isc04)  #No.MOD-650036
            END IF
            #No.FUN-630077 --start--
            #一并產生發票資料(ome_file)
            SELECT oma21 INTO l_oma21 FROM oma_file WHERE oma01 = m_isc.isc04
         #  CALL s_insome(m_isc.isc04,l_oma21)    #No.FUN-9C0014
            CALL s_insome(m_isc.isc04,l_oma21,'') #No.FUN-9C0014
            #更新最大單號
            UPDATE oom_file SET oom09=m_isc.isc01, 
                                oom10=m_isc.isc03
                          WHERE oom07 <= m_isc.isc01
                            AND m_isc.isc01 <= oom08
                            AND (m_isc.isc01 > oom09 OR oom09 IS NULL)
            IF SQLCA.SQLCODE THEN
#              CALL cl_err('upd oom09:',SQLCA.SQLCODE,1)   #No.FUN-660146
               CALL cl_err3("upd","oom_file","","",SQLCA.sqlcode,"","upd oom09",1)   #No.FUN-660146
               LET g_success = 'N'
               EXIT WHILE
            END IF
            #No.FUN-630077 --end--
            LET l_sw='2'
         WHEN '2' 
            LET l_i=0
            LET l_j=0
            CALL l_str.clear()
            WHILE tok.hasMoreTokens()
               LET l_i=l_i+1
               IF l_i MOD 2 THEN 
                  LET l_j=l_j+1
                  LET l_str[l_j]=tok.nextToken()
               ELSE 
                  LET l_tmp=tok.nextToken()
               END IF 
            END WHILE
            #No.FUN-580006 --start--
            LET m_isd.isd00 = m_isc.isc00
            LET m_isd.isd01 = m_isc.isc01
            LET m_isd.isd02 = m_isc.isc04
            LET m_isd.isd03 = l_str[2]
            LET m_isd.isd04 = l_str[3]
            LET m_isd.isd05 = l_str[4]
            LET m_isd.isd06 = l_str[5]
            LET m_isd.isd06 = s_digqty(m_isd.isd06,m_isd.isd04)   #FUN-910088--add--
            LET m_isd.isd07 = l_str[6]
            LET m_isd.isd08 = l_str[11]
            LET m_isd.isd09 = l_str[1]
            LET m_isd.isdlegal = g_legal  #FUN-980011 add
            #產生銷項發票歷史記錄單身檔
            #No.FUN-580006 --end--
            INSERT INTO isd_file VALUES(m_isd.*)
           #IF STATUS != 0 AND STATUS != -239 THEN                          #TQC-790089 mark
            IF STATUS != 0 AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN   #TQC-790089 mod 
#              CALL cl_err('ins isd',STATUS,1)   #No.FUN-660146
               CALL cl_err3("ins","isd_file",m_isd.isd01,m_isd.isd02,STATUS,"","ins isd",1)   #No.FUN-660146
               LET g_success='N' EXIT WHILE 
            END IF
           #IF STATUS = -239 THEN                         #TQC-790089 mark
            IF cl_sql_dup_value(SQLCA.SQLCODE) THEN       #TQC-790089 mod  
               UPDATE isd_file SET * = m_isd.*
                WHERE isd00 = m_isd.isd00 AND isd01 = m_isd.isd01
                  AND isd02 = m_isd.isd02 AND isd03 = m_isd.isd03
               IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#                 CALL cl_err('upd isd',STATUS,1)   #No.FUN-660146
                  CALL cl_err3("upd","isd_file",m_isd.isd01,m_isd.isd02,STATUS,"","upd isd",1)   #No.FUN-660146
                  LET g_success='N' EXIT WHILE 
               END IF
            END IF
      END CASE
   END WHILE 
   CALL channel_r.close()
   IF g_success='Y' THEN 
      COMMIT WORK 
   ELSE 
      ROLLBACK WORK 
   END IF
END FUNCTION
#No.FUN-540007--end
