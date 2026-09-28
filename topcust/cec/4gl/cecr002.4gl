# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: cecr002.4gl
# Descriptions...: 实盘差异分析表
# Date & Author..: 2016/08/11 guanyao

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

#GLOBALS
#  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
#  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
#  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
#  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
#  DEFINE g_seq_item     LIKE type_file.num5 
#END GLOBALS
#No.FUN-580004--end
DEFINE tm  RECORD 
           wc        STRING,
           more    LIKE type_file.chr30   
        END RECORD 
DEFINE g_tc_bwc07     VARCHAR(1000)
DEFINE  g_i             LIKE type_file.num5     
DEFINE  g_msg           LIKE type_file.chr1000    
DEFINE l_oaz23          LIKE oaz_file.oaz23 
DEFINE g_sma116         LIKE sma_file.sma116
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE i                LIKE type_file.num10       # No.FUN-680137 INTEGER
DEFINE l_i,l_cnt        LIKE type_file.num5         #No.FUN-680137 SMALLINT

#FUN-710081--start
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  l_str      STRING
#FUN-710081--end
 
MAIN
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CEC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
   INITIALIZE tm.* TO NULL                # Default condition
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.more = ARG_VAL(8)#str---add by huanglf160815
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)
  
   DISPLAY "g_rpt_name:",g_rpt_name
  
    LET g_sql ="ecu01.ecu_inplan.ecu01,",
               "ecu11.ecu_inplan.ecu11,",
               "l_chr.type_file.chr20,",
               "imaud07.ima_file.imaud07,",#str---add byhuanglf160815
               "imaud10.ima_file.imaud10,",

               "ecb03.ecb_inplan.ecb03,",
               "ecb06.ecb_inplan.ecb06,",
               "ecb17.ecb_inplan.ecb17,",
               "ecb40.ecb_inplan.ecb40,",
               "ecbud04.ecb_inplan.ecbud04,",

               "ecbud05.ecb_inplan.ecbud05,",
               "ecbud03.ecb_inplan.ecbud03,",
               "ecbud02.ecb_inplan.ecbud02,",
               "ima02.ima_file.ima02,",#str---add byhuanglf160815
               "title.type_file.chr30,",

               "title1.type_file.chr30,",  #add by guanyao160928
               "imaud06.ima_file.imaud06,",  #add by huanglf161017
               "ecu02.ecu_inplan.ecu02"
               
   LET l_table = cl_prt_temptable('cecr002',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   
   IF cl_null(tm.wc) THEN
      CALL cecr002_tm(0,0)             
   ELSE      
      CALL cecr002()
   END IF 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION cecr002_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,         
          l_cmd          LIKE type_file.chr1000   
   DEFINE l_str          LIKE type_file.chr1000
   DEFINE l_sql          LIKE type_file.chr1000
   DEFINE l_ecu01        STRING
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW cecr002_w AT p_row,p_col WITH FORM "cec/42f/cecr002"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)  
   CALL cl_ui_init()
   SELECT oaz23 INTO l_oaz23 FROM oaz_file
   CALL cl_opmsg('p')
 #--------------No.TQC-610089 modify  
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 #--------------No.TQC-610089 end 
   WHILE TRUE
   DIALOG ATTRIBUTE (UNBUFFERED)

       
      CONSTRUCT BY NAME tm.wc ON ecu01,ecu02        
         BEFORE CONSTRUCT
             CALL cl_qbe_init() 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT DIALOG 
            
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ecu01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_ecu01"
                 LET g_qryparam.state ="c"
                 CALL cl_create_qry() RETURNING l_ecu01
                 DISPLAY l_ecu01 TO ecu01
                 NEXT FIELD ecu01

               WHEN INFIELD(ecu02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "cq_ecu02_1"
                 LET g_qryparam.state ="c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ecu02
                 NEXT FIELD ecu02
            END CASE        
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG 
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT DIALOG
 
         ON ACTION qbe_select
            CALL cl_qbe_select()


         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END CONSTRUCT
      
      ON ACTION ACCEPT  
          ACCEPT DIALOG   

      ON ACTION CANCEL  
          LET INT_FLAG=1   
          EXIT DIALOG      
          
    END DIALOG  
      
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW cecr002_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF 
      IF tm.wc=" 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01 = 'cecr002'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('cecr002','9031',1)
         ELSE
#            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,       
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",                       
                         " '",g_rlang CLIPPED,"'", 
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'" , 
                        " '",tm.more CLIPPED,"'" ,        #str---add by huanglf160815                
                        " '",g_rep_user CLIPPED,"'",          
                        " '",g_rep_clas CLIPPED,"'",           
                        " '",g_template CLIPPED,"'",           
                         " '",g_rpt_name CLIPPED,"'"           
            CALL cl_cmdat('cecr002',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW cecr002_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF
 
      CALL cl_wait() 
      CALL cecr002() 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW cecr002_w
 
END FUNCTION
 
FUNCTION cecr002()
   DEFINE sr        RECORD
               ecu01    LIKE ecu_inplan.ecu01,
               ecu11    LIKE ecu_inplan.ecu11,
               l_chr    LIKE type_file.chr20,
               imaud07  LIKE ima_file.imaud07,
               imaud10  LIKE ima_file.imaud10,
               
               ecb03    LIKE ecb_inplan.ecb03,
               ecb06    LIKE ecb_inplan.ecb06,
               ecb17    LIKE ecb_inplan.ecb17,
               ecb40    LIKE ecb_inplan.ecb40,
               ecbud04  LIKE ecb_inplan.ecbud04,

               ecbud05  LIKE ecb_inplan.ecbud05,
               ecbud03  LIKE ecb_inplan.ecbud03,
               ecbud02  LIKE ecb_inplan.ecbud02,
               ima02    LIKE ima_file.ima02, #str---add by huanglf160815
               title    LIKE type_file.chr30,
               
               title1    LIKE type_file.chr30, #add by guanyao160928
               imaud06   LIKE ima_file.imaud06, #add by huanglf161017
               ecu02     LIKE ecu_inplan.ecu02    #add by huanglf161018
                    END RECORD
   DEFINE l_zo041     LIKE zo_file.zo041 
   DEFINE l_zo05      LIKE zo_file.zo05  
   DEFINE l_zo09      LIKE zo_file.zo09
   DEFINE l_occ01     LIKE occ_file.occ01
   DEFINE l_sql       STRING
   DEFINE l_cmd,g_wc2a,g_wc2b       STRING 
   DEFINE l_ima06    LIKE ima_file.ima06
   DEFINE l_sql1      STRING 
   DEFINE l_n        LIKE  type_file.chr30
   DEFINE l_imaud10  LIKE  type_file.chr30
   DEFINE l_x        LIKE type_file.num5   #add by guanyao160901
   
   CALL cl_del_data(l_table)  
  #公司全名zo02、公司地址zo041、公司電話zo05、公司傳真zo09
   LET l_zo041 = NULL  LET l_zo05 = NULL  LET l_zo09 = NULL
   SELECT zo02,zo041,zo05,zo09 INTO g_company,l_zo041,l_zo05,l_zo09
     FROM zo_file WHERE zo01=g_rlang
  #end FUN-810029 mod 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang 

   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'cecr002'  
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " values(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?  ,?,?,?)"   #add ? by guanyao160928
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF   
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ecuuser', 'ecugrup')  

   #LET l_sql = "SELECT ecu01,ecu11,imaud07||'/'||imaud10,ecb03,ecb06,ecb17,ecb40,trim(ecbud04),trim(ecbud05),trim(ecbud03),trim(ecbud02),ima02,''",
   LET l_sql = "SELECT ecu01,'','',trim(imaud07),trim(imaud10),ecb03,ecb06,ecb17,ecb40,trim(ecbud04),trim(ecbud05),trim(ecbud03),trim(ecbud02),ima02,'','',imaud06,ecu02",
               "  FROM ecb_inplan,ecu_inplan LEFT JOIN ima_file ON ima01=ecu01 ",
               " WHERE ecu01 = ecb01 AND ecu012=ecb012 AND ecu02=ecb02",
               "   AND ",tm.wc CLIPPED
   PREPARE prep_aaa FROM l_sql
   DECLARE decl_aaa CURSOR FOR prep_aaa
   FOREACH decl_aaa INTO sr.*
      SELECT ima06 INTO l_ima06 FROM ima_file WHERE ima01 = sr.ecu01
      SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01 = sr.ecu01 AND imaud07 LIKE '%mm%'
      SELECT to_char(sr.imaud10) INTO l_imaud10 FROM ima_file WHERE ima01 = sr.ecu01
     IF l_n = 0 THEN 
      LET sr.l_chr = sr.imaud07 CLIPPED,'mm/' CLIPPED,l_imaud10 CLIPPED,'pcs' CLIPPED
     ELSE  
      LET sr.l_chr = sr.imaud07 CLIPPED,'/' CLIPPED,l_imaud10 CLIPPED,'pcs' CLIPPED
     END IF 
     #str-----add by guanyao160901
     SELECT instr(sr.ecu01,'-') INTO l_x FROM dual 
     IF l_x>0 THEN 
        SELECT substr(sr.ima02,l_x+1) INTO sr.title FROM dual 
        LET sr.title = sr.title CLIPPED,'流程单'
        LET sr.title1 = '料件名称'
     END IF 
     #str---add by guanyao160928
     IF l_x = 0 THEN 
        LET sr.title1 = '客户料号'
     END IF 
     #end---add by guanyao160928
     IF cl_null(sr.title) THEN 
     #end-----add by guanyao160901
        IF tm.more = '1' THEN LET sr.title = 'SMT流程单' END IF
        IF tm.more = '2' THEN LET sr.title = '柔板流程单' END IF
        IF tm.more = '3' THEN LET sr.title = 'TCC流程单' END IF
     END IF 
      EXECUTE insert_prep USING sr.*
   END FOREACH                     

   LET l_str = l_str CLIPPED,";",tm.wc

   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_prt_cs3('cecr002','cecr002',l_sql,l_str)
 
END FUNCTION

