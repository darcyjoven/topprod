# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aicr053.4gl
# Descriptions...: 委外工單自動產生記錄查詢
# Input parameter:
# Return code....:
# Date & Author..: 10/02/25 by jan (#FUN-A30027)

DATABASE ds

GLOBALS "../../config/top.global"

   DEFINE tm  RECORD
  		          wc  	 STRING,     
                date1  LIKE type_file.dat,     
                date2  LIKE type_file.dat,    
                time1  LIKE sfb_file.sfb14,   
                time2  LIKE sfb_file.sfb14
              END RECORD
   DEFINE l_table        STRING                                                         
   DEFINE g_sql          STRING                                                           
   DEFINE g_str          STRING 

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
      LET g_sql = " idp01.idp_file.idp01,",
                  " idp02.idp_file.idp02,",
                  " idp03.idp_file.idp03,",
                  " idp04.idp_file.idp04,",
                  " idp05.idp_file.idp05,",
                  " idp06.idp_file.idp06,",
                  " idp07.idp_file.idp07,",
                  " idp08.idp_file.idp08,",
                  " idp09.idp_file.idp09,",
                  " idp10.idp_file.idp10,",
                  " idp11.idp_file.idp11,",
                  " idp12.idp_file.idp12 "
      LET l_table = cl_prt_temptable('aicr053',g_sql) CLIPPED                                                                          
      IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
      LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
                  " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?)"  
      PREPARE insert_prep FROM g_sql                                                                                                   
      IF STATUS THEN                                                                                                                   
         CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
      END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   CALL r053_tm()	
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION r053_tm()
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01 
   DEFINE l_h1,l_m1     LIKE type_file.chr2
 

   OPEN WINDOW r053_w WITH FORM "aic/42f/aicr053"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()


   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.date1 = g_today
   LET tm.date2 = g_today
   LET g_bgjob = 'N'
   
WHILE TRUE
   DISPLAY BY NAME tm.date1,tm.date2
   INPUT BY NAME tm.date1,tm.time1,tm.date2,tm.time2
               WITHOUT DEFAULTS

         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)

      AFTER FIELD date1
         IF NOT cl_null(tm.date1) THEN
            IF NOT cl_null(tm.date2) THEN
               IF tm.date1 > tm.date2 THEN
                   CALL cl_err('','mfg9234',0)
                   NEXT FIELD tm.date1
               END IF
            END IF
         END IF
         
      AFTER FIELD date2
         IF NOT cl_null(tm.date2) THEN
            IF NOT cl_null(tm.date1) THEN
               IF tm.date1 > tm.date2 THEN
                   CALL cl_err('','mfg9234',0)
                   NEXT FIELD tm.date2
               END IF
            END IF
         END IF
         
      AFTER FIELD time1                                                                                                           
             IF NOT cl_null(tm.time1) THEN                                                                                       
                 LET l_h1=tm.time1[1,2]                                                                                          
                 LET l_m1=tm.time1[4,5]                                                                                          
                 IF cl_null(l_h1) OR cl_null(l_m1) OR l_h1<'00' OR l_h1>='24' OR l_m1<'00' OR l_m1>='60' THEN                                                                      
                    CALL cl_err(tm.time1,'asf-807',1)                                                                            
                    NEXT FIELD time1                                                                                               
                 END IF                                                                                                             
             END IF
      
      AFTER FIELD time2                                                                                                           
             IF NOT cl_null(tm.time2) THEN                                                                                       
                 LET l_h1=tm.time2[1,2]                                                                                          
                 LET l_m1=tm.time2[4,5]                                                                                          
                 IF cl_null(l_h1) OR cl_null(l_m1) OR l_h1<'00' OR l_h1>='24' OR l_m1<'00' OR l_m1>='60' THEN                                                                               
                    CALL cl_err(tm.time2,'asf-807',1)                                                                            
                    NEXT FIELD time2                                                                                                
                 END IF                                                                                                             
             END IF        

      ON ACTION CONTROLR
         CALL cl_show_req_fields()
         
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION locale   
         CALL cl_dynamic_locale() 
         CALL cl_show_fld_cont()

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No:FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No:FUN-580031 ---end---

   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r053_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aicr053()
END WHILE
CLOSE WINDOW r053_w
CALL cl_used(g_prog,g_time,2) RETURNING g_time 
EXIT PROGRAM
END FUNCTION
 
FUNCTION aicr053()
   DEFINE  sr      RECORD                                                                                                           
                   idp01   LIKE idp_file.idp01,                                                                                     
                   idp02   LIKE idp_file.idp02,                                                                                     
                   idp03   LIKE idp_file.idp03,                                                                                     
                   idp04   DATETIME YEAR TO MINUTE,                                                                                 
                   idp05   LIKE idp_file.idp05,                                                                                     
                   idp06   LIKE idp_file.idp06,                                                                                     
                   idp07   LIKE idp_file.idp07,                                                                                     
                   idp08   LIKE idp_file.idp08,
                   idp09   LIKE idp_file.idp09,
                   idp10   LIKE idp_file.idp10,
                   idp11   LIKE idp_file.idp11,
                   idp12   LIKE idp_file.idp12
                   END RECORD
   DEFINE l_sql     STRING
   DEFINE l_chr1    STRING
   DEFINE l_chr2    STRING

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET l_chr1 = tm.date1,' ',tm.time1
     LET l_chr2 = tm.date2,' ',tm.time2
     LET l_sql = " SELECT * ",
                 "   FROM idp_file",
                #"  WHERE idp04 BETWEEN to_date('",l_chr1,"','yy/mm/dd hh24:mi') ",
                #"    AND to_date('",l_chr2,"','yy/mm/dd hh24:mi') ",
                 "  WHERE idp04 BETWEEN cast('",l_chr1,"' as datetime) ",
                 "    AND cast('",l_chr2,"' as datetime) ",
                 "  ORDER BY idp04"
     
     PREPARE r053_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
            
     END IF
     DECLARE r053_cs1 CURSOR FOR r053_prepare1

     CALL cl_del_data(l_table)                          #No:FUN-7C0034
     
     FOREACH r053_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       EXECUTE insert_prep USING sr.*
    END FOREACH
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                                                                  
   LET g_str = l_chr1,";",l_chr2                                                               
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                              
   CALL cl_prt_cs3('aicr053','aicr053',l_sql,g_str)
END FUNCTION
#FUN-A30027
