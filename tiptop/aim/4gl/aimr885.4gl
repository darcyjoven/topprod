# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aimr885.4gl
# Descriptions...: 盤盈虧明細表
# Date & Author..: 08/05/29 #FUN-850151 by jamie
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-B50222 11/05/26 By vampire 抓取 pias10 欄位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#FUN-850151 ref.aimr899
DEFINE tm  RECORD            
           #wc              LIKE type_file.chr1000,   
           wc              STRING,             #NO.FUN-910082                          
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
   LET g_sql = "pias01.pias_file.pias01,",                                         
               "pias02.pias_file.pias02,",                                         
               "pias03.pias_file.pias03,",                                         
               "pias04.pias_file.pias04,",                                         
               "pias05.pias_file.pias05,",                                         
              #"pias09.pias_file.pias09,",              #MOD-B50222 mark
               "pias10.pias_file.pias10,",              #MOD-B50222 add    
               "pias30.pias_file.pias30,", 
               "ima02.ima_file.ima02,",                                         
               "ima021.ima_file.ima021,",                                         
               "img10.img_file.img10,",
               "pias09.pias_file.pias09,",              #MOD-B50222 add
               "ima131.ima_file.ima131,",
               "diff1.pias_file.pias30,",   
               "diff2.pias_file.pias30" 
                                                        
   LET l_table = cl_prt_temptable('aimr834',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
              #" VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?) "  #MOD-B50222 mark
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?) "  #MOD-B50222 add    
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
      THEN CALL r885_tm(0,0)        
      ELSE CALL r885()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION r885_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01                   
DEFINE p_row,p_col    LIKE type_file.num5                            
DEFINE l_cmd          LIKE type_file.chr1000                           
 
   IF p_row = 0 THEN LET p_row = 2 LET p_col = 11 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 3 LET p_col = 18
   ELSE
       LET p_row = 2 LET p_col = 11
   END IF
   OPEN WINDOW r885_w AT p_row,p_col
        WITH FORM "aim/42f/aimr885" 
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
   CONSTRUCT BY NAME tm.wc ON ima131,pias02,pias01,pias03,pias05,pias04
 
   BEFORE CONSTRUCT
     CALL cl_qbe_init()
 
      ON ACTION controlp                                                                                                 
         IF INFIELD(pias02) THEN                                                                                                  
            CALL cl_init_qry_var()                                                                                               
            LET g_qryparam.form = "q_ima"                                                                                       
            LET g_qryparam.state = "c"                                                                                           
            CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
            DISPLAY g_qryparam.multiret TO pias02                                                                                 
            NEXT FIELD pias02                                                                                                     
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
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW r885_w 
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
      CLOSE WINDOW r885_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file   
             WHERE zz01='aimr885'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr885','9031',1)
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
         CALL cl_cmdat('aimr885',g_time,l_cmd) 
      END IF
      CLOSE WINDOW r885_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r885()
   ERROR ""
END WHILE
   CLOSE WINDOW r885_w
END FUNCTION
 
FUNCTION r885()
DEFINE l_name    LIKE type_file.chr20                 # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
DEFINE l_sql     LIKE type_file.chr1000               # RDSQL STATEMENT  #No.FUN-690026 VARCHAR(1000)
DEFINE l_za05    LIKE za_file.za05       
DEFINE l_pias40   LIKE pias_file.pias40               
DEFINE l_pias50   LIKE pias_file.pias50               
DEFINE l_pias60   LIKE pias_file.pias60               
DEFINE sr        RECORD ima131 LIKE ima_file.ima131,
                        pias02  LIKE pias_file.pias02, 
                        ima02  LIKE ima_file.ima02,      
                        ima021 LIKE ima_file.ima021,          
                        pias09  LIKE pias_file.pias09,
                        pias10  LIKE pias_file.pias10,             #MOD-B50222 add         
                        pias05  LIKE pias_file.pias05,         
                        pias03  LIKE pias_file.pias03,         
                        pias04  LIKE pias_file.pias04,         
                        pias01  LIKE pias_file.pias01,         
                        img10  LIKE img_file.img10,    #FUN-850151       
                       #pias08  LIKE pias_file.pias08,         
                        pias30  LIKE pias_file.pias30,         
                        pias60  LIKE pias_file.pias60,         
                        diff1  LIKE pias_file.pias30, 
                        diff2  LIKE pias_file.pias30, 
                        ima06  LIKE ima_file.ima06,   
                        ima09  LIKE ima_file.ima09,   
                        ima10  LIKE ima_file.ima10,   
                        ima11  LIKE ima_file.ima11,   
                        ima12  LIKE ima_file.ima12    
                        END RECORD
     CALL cl_del_data(l_table)                                                
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                           
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
    #LET l_sql = "SELECT ima131, pias02, ima02,ima021, pias09, pias05, pias03,",     #MOD-B50222 mark 
     LET l_sql = "SELECT ima131, pias02, ima02,ima021, pias09, pias10, pias05, pias03,",     #MOD-B50222 add
                 "       pias04, pias01, pias08, pias30, pias60,0,0,", 
                 "       ima06,ima09,ima10,ima11,ima12,pias40,pias50",
                 "  FROM pias_file, ima_file, OUTER img_file",
                 " WHERE pias02=ima01",
                 "   AND pias_file.pias02=img_file.img01 AND pias_file.pias03=img_file.img02",
                 "   AND pias_file.pias04=img_file.img03 AND pias_file.pias05=img_file.img04",
                 "   AND ", tm.wc CLIPPED
     PREPARE r885_prepare1 FROM l_sql
     IF STATUS != 0 THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  
        EXIT PROGRAM 
     END IF
     DECLARE r885_curs1 CURSOR FOR r885_prepare1
 
     FOREACH r885_curs1 INTO sr.*,l_pias40,l_pias50
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       IF sr.img10 IS NULL THEN LET sr.img10=0 END IF
       IF sr.pias30 IS NULL THEN LET sr.pias30=0 END IF
      #-->複盤有值先以複盤為主
      #No.B480 010510 by linda mod 順序應為複盤二,複盤一,初盤二,初盤一
       IF not cl_null(sr.pias60)  THEN 
          LET sr.pias30 = sr.pias60 
       ELSE
          IF NOT cl_null(l_pias50) THEN
             LET sr.pias30=l_pias50
          ELSE
             IF NOT cl_null(l_pias40) THEN
                LET sr.pias30 = l_pias40
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
       IF tm.a='N' THEN LET sr.pias05=' ' END IF
       IF tm.b='N' THEN LET sr.pias03=' ' END IF
       IF tm.c='N' THEN LET sr.pias04=' ' END IF
       IF tm.a='N' OR tm.b='N' OR tm.c='N' THEN LET sr.pias01=' ' END IF
       IF tm.d='N' AND sr.img10=sr.pias30 THEN CONTINUE FOREACH END IF
       IF sr.img10 > sr.pias30
          THEN LET sr.diff2=sr.img10-sr.pias30 LET sr.diff1=0
          ELSE LET sr.diff1=sr.pias30-sr.img10 LET sr.diff2=0
       END IF
        EXECUTE insert_prep USING sr.pias01,sr.pias02,sr.pias03,sr.pias04,sr.pias05,
                                #sr.pias09,sr.pias30,sr.ima02,sr.ima021,sr.img10,         #MOD-B50222 mark
                                 sr.pias10,sr.pias30,sr.ima02,sr.ima021,sr.img10,         #MOD-B50222 add
                                #sr.ima131,sr.diff1,sr.diff2                              #MOD-B50222 mark
                                 sr.pias09,sr.ima131,sr.diff1,sr.diff2                    #MOD-B50222 add        
                            
     END FOREACH
      IF g_zz05 = 'Y' THEN                                                      
         CALL cl_wcchp(tm.wc,'ima131,pias02,pias01,pias03,pias05,pias04')                         
              RETURNING tm.wc                                                   
      END IF                                                                    
      LET g_str=tm.wc,";",tm.e,";",tm.f,";",tm.g
                                                                          
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
   CALL cl_prt_cs3('aimr885','aimr885',l_sql,g_str) 
END FUNCTION
