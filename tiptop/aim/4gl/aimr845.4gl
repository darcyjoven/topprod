# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aimr845.4gl
# Descriptions...: 刻號/BIN盤盈虧明細表
# Date & Author..: 08/05/29 #FUN-B70032 by jason
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#FUN-B70032 ref.aimr885
DEFINE tm  RECORD            
           #wc              LIKE type_file.chr1000,   
           wc              STRING,             
           yy,mm           LIKE type_file.num5,                               
           a,b,c,d,e,f,g,h LIKE type_file.chr1,                              
           more            LIKE type_file.chr1                               
           END RECORD 
DEFINE g_i LIKE type_file.num5     #count/index for any purpose  
DEFINE l_table        STRING,
       l_table1       STRING,
       g_str          STRING,                                                   
       g_sql          STRING                                                  
                                                       
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT   
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
   LET g_sql = "piad01.piad_file.piad01,",                                         
               "piad02.piad_file.piad02,",                                         
               "piad03.piad_file.piad03,",                                         
               "piad04.piad_file.piad04,",                                         
               "piad05.piad_file.piad05,",                                         
               "piad06.piad_file.piad06,",
               "piad07.piad_file.piad07,",
               "piad10.piad_file.piad10,",              
               "piad30.piad_file.piad30,", 
               "ima02.ima_file.ima02,",                                         
               "ima021.ima_file.ima021,",                                         
               "img10.img_file.img10,",
               "piad09.piad_file.piad09,",              
               "ima131.ima_file.ima131,",
               "diff1.piad_file.piad30,",   
               "diff2.piad_file.piad30" 
                                                        
   LET l_table = cl_prt_temptable('aimr834',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?) "  
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF  
 
   LET g_pdate = ARG_VAL(1)      
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob =  ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)
   LET tm.d  = ARG_VAL(11)
   LET tm.e  = ARG_VAL(12)
   LET tm.f  = ARG_VAL(13)
   LET tm.g  = ARG_VAL(14)
   LET tm.h  = ARG_VAL(15)
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   LET g_rpt_name = ARG_VAL(19)  
   IF cl_null(g_bgjob) OR g_bgjob = 'N' 
      THEN CALL r845_tm(0,0)        
      ELSE CALL r845()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION r845_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01                   
DEFINE p_row,p_col    LIKE type_file.num5                            
DEFINE l_cmd          LIKE type_file.chr1000                           
 
   IF p_row = 0 THEN LET p_row = 2 LET p_col = 11 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 3 LET p_col = 18
   ELSE
       LET p_row = 2 LET p_col = 11
   END IF
   OPEN WINDOW r845_w AT p_row,p_col
        WITH FORM "aim/42f/aimr845" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL        
   LET tm.a    = 'Y'
   LET tm.b    = 'Y'
   LET tm.c    = 'Y'
   LET tm.d    = 'N'
   LET tm.e    = '0'
   LET tm.f    = 'Y'
   LET tm.g    = 'N'
   LET tm.h    = '5'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima131,piad02,piad01,piad03,piad05,piad04
 
   BEFORE CONSTRUCT
     CALL cl_qbe_init()
 
      ON ACTION controlp                                                                                                 
         IF INFIELD(piad02) THEN                                                                                                  
            CALL cl_init_qry_var()                                                                                               
            LET g_qryparam.form = "q_ima"                                                                                       
            LET g_qryparam.state = "c"                                                                                           
            CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
            DISPLAY g_qryparam.multiret TO piad02                                                                                 
            NEXT FIELD piad02                                                                                                     
         END IF                                                            
 
      ON ACTION locale
         CALL cl_show_fld_cont()    
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
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
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
 END CONSTRUCT
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') 
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW r845_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   INPUT BY NAME tm.a,tm.b,tm.c,tm.d,tm.f,tm.g,tm.e,tm.h,tm.more  
		WITHOUT DEFAULTS   
 
     BEFORE INPUT
       CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG 
         CALL cl_cmdask()  
 
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
      LET INT_FLAG = 0 
      CLOSE WINDOW r845_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file   
             WHERE zz01='aimr845'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr845','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,     
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", 
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",
                         " '",tm.f CLIPPED,"'",
                         " '",tm.g CLIPPED,"'",
                         " '",tm.h CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",                         
                         " '",g_rep_clas CLIPPED,"'",                         
                         " '",g_template CLIPPED,"'",                         
                         " '",g_rpt_name CLIPPED,"'"                          
         CALL cl_cmdat('aimr845',g_time,l_cmd) 
      END IF
      CLOSE WINDOW r845_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r845()
   ERROR ""
END WHILE
   CLOSE WINDOW r845_w
END FUNCTION
 
FUNCTION r845()
DEFINE l_name    LIKE type_file.chr20                 # External(Disk) file name  
DEFINE l_sql     LIKE type_file.chr1000               # RDSQL STATEMENT  
DEFINE l_za05    LIKE za_file.za05       
DEFINE l_piad40   LIKE piad_file.piad40               
DEFINE l_piad50   LIKE piad_file.piad50               
DEFINE l_piad60   LIKE piad_file.piad60               
DEFINE sr        RECORD ima131 LIKE ima_file.ima131,
                        piad02  LIKE piad_file.piad02, 
                        ima02  LIKE ima_file.ima02,      
                        ima021 LIKE ima_file.ima021,          
                        piad09  LIKE piad_file.piad09,
                        piad10  LIKE piad_file.piad10,             
                        piad05  LIKE piad_file.piad05,
                        piad06  LIKE piad_file.piad06,
                        piad07  LIKE piad_file.piad07,         
                        piad03  LIKE piad_file.piad03,         
                        piad04  LIKE piad_file.piad04,         
                        piad01  LIKE piad_file.piad01,         
                        img10  LIKE img_file.img10,    
                       #piad08  LIKE piad_file.piad08,         
                        piad30  LIKE piad_file.piad30,         
                        piad60  LIKE piad_file.piad60,         
                        diff1  LIKE piad_file.piad30, 
                        diff2  LIKE piad_file.piad30, 
                        ima06  LIKE ima_file.ima06,   
                        ima09  LIKE ima_file.ima09,   
                        ima10  LIKE ima_file.ima10,   
                        ima11  LIKE ima_file.ima11,   
                        ima12  LIKE ima_file.ima12    
                        END RECORD
     CALL cl_del_data(l_table)                                                
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                           
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
        
     LET l_sql = "SELECT ima131, piad02, ima02,ima021, piad09, piad10, piad05, ",     
                 "       piad06, piad07, piad03, piad04, piad01, piad08, piad30, ", 
                 "       piad60,0,0,ima06,ima09,ima10,ima11,ima12,piad40,piad50",
                 "  FROM piad_file, ima_file, OUTER img_file",
                 " WHERE piad02=ima01",
                 "   AND piad_file.piad02=img_file.img01 AND piad_file.piad03=img_file.img02",
                 "   AND piad_file.piad04=img_file.img03 AND piad_file.piad05=img_file.img04",
                 "   AND ", tm.wc CLIPPED
     PREPARE r845_prepare1 FROM l_sql
     IF STATUS != 0 THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  
        EXIT PROGRAM 
     END IF
     DECLARE r845_curs1 CURSOR FOR r845_prepare1
 
     FOREACH r845_curs1 INTO sr.*,l_piad40,l_piad50
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       IF sr.img10 IS NULL THEN LET sr.img10=0 END IF
       IF sr.piad30 IS NULL THEN LET sr.piad30=0 END IF
      #-->複盤有值先以複盤為主
      #順序應為複盤二,複盤一,初盤二,初盤一
       IF not cl_null(sr.piad60)  THEN 
          LET sr.piad30 = sr.piad60 
       ELSE
          IF NOT cl_null(l_piad50) THEN
             LET sr.piad30=l_piad50
          ELSE
             IF NOT cl_null(l_piad40) THEN
                LET sr.piad30 = l_piad40
             END IF
          END IF
       END IF
       CASE WHEN tm.h='0' LET sr.ima131=sr.ima06
            WHEN tm.h='1' LET sr.ima131=sr.ima09
            WHEN tm.h='2' LET sr.ima131=sr.ima10
            WHEN tm.h='3' LET sr.ima131=sr.ima11
            WHEN tm.h='4' LET sr.ima131=sr.ima12
            OTHERWISE     LET sr.ima131=sr.ima131
       END CASE
       IF tm.a='N' THEN LET sr.piad05=' ' END IF
       IF tm.b='N' THEN LET sr.piad03=' ' END IF
       IF tm.c='N' THEN LET sr.piad04=' ' END IF
       IF tm.a='N' OR tm.b='N' OR tm.c='N' THEN LET sr.piad01=' ' END IF
       IF tm.d='N' AND sr.img10=sr.piad30 THEN CONTINUE FOREACH END IF
       IF sr.img10 > sr.piad30
          THEN LET sr.diff2=sr.img10-sr.piad30 LET sr.diff1=0
          ELSE LET sr.diff1=sr.piad30-sr.img10 LET sr.diff2=0
       END IF
        EXECUTE insert_prep USING sr.piad01,sr.piad02,sr.piad03,sr.piad04,sr.piad05,                                      
                                 sr.piad06,sr.piad07,sr.piad10,sr.piad30,sr.ima02,
                                 sr.ima021,sr.img10,sr.piad09,sr.ima131,sr.diff1,sr.diff2                    
                            
     END FOREACH
      IF g_zz05 = 'Y' THEN                                                      
         CALL cl_wcchp(tm.wc,'ima131,piad02,piad01,piad03,piad05,piad04')                         
              RETURNING tm.wc                                                   
      END IF                                                                    
      LET g_str=tm.wc,";",tm.e,";",tm.f,";",tm.g
                                                                          
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
   CALL cl_prt_cs3('aimr845','aimr845',l_sql,g_str) 
END FUNCTION
