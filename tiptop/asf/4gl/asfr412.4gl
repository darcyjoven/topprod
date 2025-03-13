# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: asfr412.4gl
# Descriptions...: PBI製程料件列印
# Date & Author..: 10/09/15 FUN-A90035 By vealxu
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正
# Modify.........: No.CHI-C60023 12/08/21 By bart 新增欄位-資料類別

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm          RECORD                          # Print condition RECORD
                   wc      LIKE type_file.chr1000, # Where condition      
                   more    LIKE type_file.chr1     # Input more condition(Y/N)  
                   END RECORD
DEFINE   g_sql           STRING  
DEFINE   g_str           STRING
DEFINE   l_table         STRING 
DEFINE   l_flag          LIKE type_file.chr1 


MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT             
       
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF

   LET g_sql =  "sfd01.sfd_file.sfd01,",        #PBI No
                "sfd02.sfd_file.sfd02,",        #PBI 項次
                "sfd03.sfd_file.sfd03,",        #工單號
                "sfb05.sfb_file.sfb05,",        #生產料件
                "ima02.ima_file.ima02,",        #產品名稱
                "ima021.ima_file.ima021,",      #規格
                "edg03.edg_file.edg03,",        #制程式
                "edg04.edg_file.edg04,",        #作業編號 
                "edh03.edh_file.edh03,",        #元件料號
                "ima02_s.ima_file.ima02,",      #元件名稱
                "ima021_s.ima_file.ima021,",    #元件規格
                "ima08_s.ima_file.ima08,",      #來源碼
                "edh04.edh_file.edh04,",        #生效日期
                "edh05.edh_file.edh05,",        #       
                "edh06.edh_file.edh06,",        #組成用量
                "edh07.edh_file.edh07,",        #底數
                "sfd09.sfd_file.sfd09"          #CHI-C60023
 
   LET l_table = cl_prt_temptable('asfr412',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
    
   LET g_pdate = ARG_VAL(1)     
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc =  ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  

   IF cl_null(g_bgjob) OR g_bgjob = 'N'  THEN 
      CALL asfr412_tm(0,0)   
   ELSE
      CALL asfr412()          
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION asfr412_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000 
          
   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW asfr412_w AT p_row,p_col WITH FORM "asf/42f/asfr412" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition  
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON sfd01,sfd03 
  
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()
            EXIT CONSTRUCT

         ON ACTION controlp
            CASE
              WHEN INFIELD(sfd01)   
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_sfc"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sfd01 
                   NEXT FIELD sfd01 
                   
              WHEN INFIELD(sfd03)   
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_sfb01"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sfd03 
                   NEXT FIELD sfd03      
            END CASE

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT

      END CONSTRUCT

      IF g_action_choice = "locale" THEN
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW artr512_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF cl_null(tm.wc) THEN
         LET tm.wc = "1=1"
      END IF   

      DISPLAY BY NAME tm.more
      
      INPUT BY NAME tm.more WITHOUT DEFAULTS 

         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)

         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
            END IF
                    
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
            
         ON ACTION CONTROLG 
            CALL cl_cmdask()  
            
         AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
            IF  cl_null(tm.more) OR tm.more NOT MATCHES '[YN]' THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME tm.more
            END IF
            IF  l_flag = 'Y' THEN
               CALL cl_err('','9033',0)
               NEXT FIELD edate
            END IF 
           
            
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         
            CALL cl_about()       
 
         ON ACTION help           
            CALL cl_show_help()   
 
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
            
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW asfr412_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
                                                                                                
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file   
          WHERE zz01='asfr412'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('asfr412','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,              
                       " '",g_pdate CLIPPED,"'",
                       " '",g_towhom CLIPPED,"'",
                       " '",g_rlang CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'",
                       " '",g_prtway CLIPPED,"'",
                       " '",g_copies CLIPPED,"'",
                       " '",tm.wc CLIPPED,"'" ,
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('asfr412',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW asfr412_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL asfr412()
      ERROR ""
   END WHILE
   CLOSE WINDOW asfr412_w
END FUNCTION

FUNCTION asfr412()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 
          sr        RECORD 
                    sfd01    LIKE sfd_file.sfd01, 
                    sfd02    LIKE sfd_file.sfd02,
                    sfd03    LIKE sfd_file.sfd03,
                    sfb05    LIKE sfb_file.sfb05,
                    ima02    LIKE ima_file.ima02, 
                    ima021   LIKE ima_file.ima021,
                    edg03    LIKE edg_file.edg03,
                    edg04    LIKE edg_file.edg04,
                    edh03    LIKE edh_file.edh03,
                    ima02_s  LIKE ima_file.ima02, 
                    ima021_s LIKE ima_file.ima021,
                    ima08_s  LIKE ima_file.ima08,
                    edh04    LIKE edh_file.edh04,
                    edh05    LIKE edh_file.edh05,
                    edh06    LIKE edh_file.edh06,
                    edh07    LIKE edh_file.edh07,  
                    sfd09    LIKE sfd_file.sfd09   #CHI-C60023
                    END RECORD 

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?,   ?, ?, ?, ?, ?,   ?, ?, ?, ?, ?, ?, ? )"  #CHI-C60023
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
      EXIT PROGRAM
   END IF
 
   LET l_sql = "SELECT sfd01,sfd02,sfd03,sfb05,'','',edg03,edg04,edh03,'','','',edh04,edh05,edh06,edh07,sfd09 ",  #CHI-C60023
               "  FROM sfd_file LEFT OUTER JOIN sfb_file ON sfd03 = sfb01,edg_file,edh_file ",
               " WHERE sfd01 = edg01 AND sfd02 = edg02  ",
               "   AND sfd03 = sfb01 ",
               "   AND sfd01 = edh01 AND sfd02 = edh011 and edh013 = edg03",
               "   AND ",tm.wc CLIPPED, 
               " ORDER BY sfd01,sfd02,edg03 "
   PREPARE asfr412_prepare FROM l_sql
   IF STATUS THEN
      CALL cl_err('preprare',STATUS,0)
   END IF
   DECLARE asfr412_curs  CURSOR FOR asfr412_prepare
   
   FOREACH asfr412_curs  INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      SELECT ima02,ima021 INTO sr.ima02,sr.ima021 FROM ima_file
       WHERE ima01 = sr.sfb05
      IF SQLCA.sqlcode THEN
         LET sr.ima02 = ' '
         LET sr.ima021 = ' '
      END IF       
 
      SELECT ima02,ima021,ima08 INTO sr.ima02_s,sr.ima021_s,sr.ima08_s FROM ima_file
       WHERE ima01 = sr.edh03     
      IF SQLCA.sqlcode THEN
         LET sr.ima02_s = ' '
         LET sr.ima021_s = ' '
         LET sr.ima08_s = ' '
      END IF 
   
      EXECUTE  insert_prep  USING sr.* 
   END FOREACH

   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'sfd01,sfd03,edg01,edg02,edg03,edh01,edh011,edh013')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF 
   CALL cl_prt_cs3(g_prog,'asfr412',l_sql,g_str)  

END FUNCTION
#FUN-A90035 ---------------------end-------------------
