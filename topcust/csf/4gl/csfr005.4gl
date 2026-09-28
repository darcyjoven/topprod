# Prog. Version..:
#
# Pattern name...: csfr005.4gl
# Descriptions...: 产品入库单打印
# Date & Author..: 16/06/21 By guanyao
#HFBG-16030001
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE tm  RECORD                               
              wc      LIKE type_file.chr1000,      
              sfb81  LIKE sfb_file.sfb81          
              END RECORD  
 
DEFINE   g_cnt           LIKE type_file.num10      
DEFINE   g_i             LIKE type_file.num5       
DEFINE   g_msg           LIKE type_file.chr1000   
 
DEFINE   l_table         STRING
DEFINE   g_str           STRING
DEFINE   g_sql           STRING
DEFINE   g_ac            LIKE type_file.chr1

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CSF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
  
   LET g_sql="sfb01.sfb_file.sfb01,",
             "sfb81.sfb_file.sfb81,",
             "sfb05.sfb_file.sfb05,",
             "oea10.oea_file.oea10,",
             "sfb08.sfb_file.sfb08,",

             "l_a.type_file.num5,",
             "sfa03.sfa_file.sfa03,",
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",
             "sfa161.sfa_file.sfa161,",

             "sfa05.sfa_file.sfa05,",
             "sfa12.sfa_file.sfa12,",
             "sfa08.sfa_file.sfa08,",
             "ecb03.ecb_file.ecb03,",
             "ecb17.ecb_file.ecb17"
             
   LET  l_table = cl_prt_temptable('csfr005',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"                     
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   INITIALIZE tm.* TO NULL         
   LET g_pdate = ARG_VAL(1)       
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_ac       = ARG_VAL(8) 
   
   IF cl_null(tm.wc) THEN 
      CALL csfr005_tm(0,0)          
   ELSE
      CALL csfr005()                
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


FUNCTION csfr005_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd        LIKE type_file.chr1000      
 
   LET p_row = 9 LET p_col = 8
 
   OPEN WINDOW csfr005_w AT p_row,p_col WITH FORM "csf/42f/csfr005"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
  
   LET tm.sfb81 = g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
   LET g_ac = '1'
 
   CALL cl_opmsg('p')
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON sfb01
                              
     
         BEFORE CONSTRUCT
            CALL cl_qbe_init() 
 
         ON ACTION locale 
            CALL cl_show_fld_cont()                    
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(sfb01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_sfb"  #No.TQC-5B0095
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb01
                  NEXT FIELD sfb01
               OTHERWISE
                  EXIT CASE
            END CASE
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
 
         ON ACTION EXIT
            LET INT_FLAG = 1
            EXIT CONSTRUCT
         
         ON ACTION qbe_select
            CALL cl_qbe_select()
         
 
      END CONSTRUCT
         IF g_action_choice = "locale" THEN
            LET g_action_choice = ""
            CALL cl_dynamic_locale()
            CONTINUE WHILE
         END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW csfr005_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM         
      END IF
      IF tm.wc=" 1=1" THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
      
      INPUT BY NAME tm.sfb81  WITHOUT DEFAULTS
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW csfr005_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='csfr005'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('csfr005','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc,'\\\"', "'")
         LET l_cmd = l_cmd CLIPPED,        
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", 
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,           
                         " '",g_ac CLIPPED,"'"        
         CALL cl_cmdat('csfr005',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW csfr005_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL csfr005()
   ERROR ""
END WHILE
   CLOSE WINDOW csfr005_w
END FUNCTION


FUNCTION csfr005()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(3000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_oea03   LIKE oea_file.oea03, 
          l_sfb05   LIKE sfb_file.sfb05,
          sr        RECORD
             sfb01      LIKE sfb_file.sfb01,
             sfb81     LIKE sfb_file.sfb81,
             sfb05      LIKE sfb_file.sfb05,
             oea10      LIKE oea_file.oea10,
             sfb08      LIKE sfb_file.sfb08,

             l_a        LIKE type_file.num5,
             sfa03      LIKE sfa_file.sfa03,
             ima02      LIKE ima_file.ima02,
             ima021     LIKE ima_file.ima021,
             sfa161     LIKE sfa_file.sfa161,

             sfa05      LIKE sfa_file.sfa05,
             sfa12      LIKE sfa_file.sfa12,
             sfa08      LIKE sfa_file.sfa08,
             ecb03      LIKE ecb_file.ecb03,
             ecb17      LIKE ecb_file.ecb17
                    END RECORD
   DEFINE l_cnt     LIKE type_file.num5            

   DEFINE l_price LIKE ogb_file.ogb13

   DEFINE l_img_blob     LIKE type_file.blob
   LOCATE l_img_blob IN MEMORY             
 

     CALL cl_del_data(l_table) 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='csfr005' 
 
     LET tm.wc = tm.wc CLIPPED
     LET l_cnt = 1  
     IF g_ac  = '1' THEN 
        LET l_sql= "SELECT sfb01,sfb81,sfb05,oea10,sfb08,'',sfa03,",
                   "       ima02,ima021,sfa161,sfa05,sfa12,sfa08,'',''",
                   "  FROM sfb_file LEFT JOIN oea_file ON oea01 = sfb22,",
                   "       sfa_file LEFT JOIN ima_file ON ima01 = sfa03",
                   " WHERE ",tm.wc,
                   "   AND sfa01 =sfb01"
     ELSE 
        LET l_sql ="SELECT sfb01,sfb81,sfb05,oea10,sfb08,'','',",
                   "       '','','','','','',ecb03,ecb17",
                   "  FROM sfb_file LEFT JOIN oea_file ON oea01 = sfb22,",
                   "       ecb_file",
                   " WHERE ",tm.wc,
                   "   AND sfb05 = ecb01",
                   "   AND sfb06 = ecb02"
     END IF 
     IF NOT cl_null(tm.sfb81) THEN
        LET l_sql = l_sql CLIPPED," AND sfb81 = '",tm.sfb81,"'"
     END IF 
     LET l_sql = l_sql CLIPPED," ORDER BY sfb01"
                 
 
     PREPARE csfr005_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE csfr005_curs1 CURSOR FOR csfr005_prepare1
    
     FOREACH csfr005_curs1 INTO sr.*
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET sr.l_a = l_cnt 
        LET l_cnt = l_cnt +1
     EXECUTE insert_prep USING sr.*
     END FOREACH
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,',sfp01,sfp02')
             RETURNING tm.wc
     END IF
     LET g_str = tm.wc
     IF g_ac = 1 THEN 
        CALL cl_prt_cs3('csfr005','csfr005',g_sql,g_str)
     ELSE 
        CALL cl_prt_cs3('csfr005','csfr005_1',g_sql,g_str)
     END IF 

END FUNCTION
