# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: axrr440.4gl
# Descriptions...: 應收調帳單打印
# Date & Author..: No.FUN-B20019 11/02/11 by yinhy
# Modify.........: No:FUN-B80072 11/08/08 By Lujh 模組程序撰寫規範修正
# Modify.........: No.TQC-C10039 12/01/17 By JinJJ  CR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C40001 12/04/13 By yinhy 增加開窗功能

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                                # Print condition RECORD  #FUN-B20019
              wc      LIKE type_file.chr1000, 
              n       LIKE type_file.chr1,
              more    LIKE type_file.chr1           # Input more condition(Y/N)
              END RECORD,
          l_n         LIKE type_file.num5           #SMALLINT
 
DEFINE   g_i          LIKE type_file.num5           #count/index for any purpose
DEFINE   g_sql        STRING 
DEFINE   g_str        STRING
DEFINE   l_table      STRING
DEFINE   l_table1     STRING
DEFINE   l_table2     STRING
DEFINE   l_table3     STRING
DEFINE   l_table4     STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                                  # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_sql="ooa01.ooa_file.ooa01,ooa02.ooa_file.ooa02,ooa03.ooa_file.ooa03,",
             "ooa032.ooa_file.ooa032,ooa15.ooa_file.ooa15,",
             "gem02.gem_file.gem02,ooa13.ooa_file.ooa13,oob02.oob_file.oob02,oob03.oob_file.oob03,", 
             "ooc02.ooc_file.ooc02,oob05.oob_file.oob05,oob24.oob_file.oob24,oob06.oob_file.oob06,",
             "oob07.oob_file.oob07,oob08.oob_file.oob08,oob09.oob_file.oob09,oob27.oob_file.oob27,",
             "oob10.oob_file.oob10,oob11.oob_file.oob11,aag02.aag_file.aag02,",
             "oob12.oob_file.oob12,azi04.azi_file.azi04,azi05.azi_file.azi05,",
             "azi07.azi_file.azi07,",
             "sign_type.type_file.chr1, sign_img.type_file.blob,",    #簽核方式, 簽核圖檔     #FUN-940042
             "sign_show.type_file.chr1,sign_str.type_file.chr1000"   #是否顯示簽核資料(Y/N)  #FUN-940042 #TQC-C10039 add sign_str.type_file.chr1000
   LET l_table = cl_prt_temptable('axrr440',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
 
   LET g_sql = "oao01.oao_file.oao01,",
               "oao03.oao_file.oao03,",
               "oao05.oao_file.oao05,",
               "oao06.oao_file.oao06 "
   LET l_table1 = cl_prt_temptable('axrr4401',g_sql) CLIPPED                      
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "oao01_1.oao_file.oao01,",                                         
               "oao03_1.oao_file.oao03,",                                         
               "oao05_1.oao_file.oao05,",                                         
               "oao06_1.oao_file.oao06 "                                          
                                                                                
   LET l_table2 = cl_prt_temptable('axrr4402',g_sql) CLIPPED                    
   IF l_table2 = -1 THEN EXIT PROGRAM END IF      
 
   LET g_sql = "oao01_2.oao_file.oao01,",                                         
               "oao03_2.oao_file.oao03,",                                         
               "oao05_2.oao_file.oao05,",                                         
               "oao06_2.oao_file.oao06 "                                          
                                                                                
   LET l_table3 = cl_prt_temptable('axrr4403',g_sql) CLIPPED                    
   IF l_table3 = -1 THEN EXIT PROGRAM END IF                          
 
   LET g_sql = "oao01_3.oao_file.oao01,",                                         
               "oao03_3.oao_file.oao03,",                                         
               "oao05_3.oao_file.oao05,",                                         
               "oao06_3.oao_file.oao06 "                                          
                                                                                
   LET l_table4 = cl_prt_temptable('axrr4404',g_sql) CLIPPED                    
   IF l_table4 = -1 THEN EXIT PROGRAM END IF                          
 
   INITIALIZE tm.* TO NULL 
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.n = ARG_VAL(8)
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)
   
   CREATE TEMP TABLE r440_tmp
   (tmp01 LIKE azi_file.azi01,
    tmp02 LIKE type_file.chr1,  
    tmp03 LIKE type_file.num20_6,
    tmp04 LIKE type_file.num20_6)

   create unique index r440_tmp_01 on r440_tmp(tmp01,tmp02);
   IF cl_null(tm.wc) THEN
      CALL axrr440_tm(0,0)             # Input print condition
   ELSE 
      CALL axrr440()                   # Read data and create out-file
   END IF
   DROP TABLE r440_tmp
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION axrr440_tm(p_row,p_col)
   DEFINE lc_qbe_sn         LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 5 LET p_col = 18
   ELSE LET p_row = 5 LET p_col = 15
   END IF
 
   OPEN WINDOW axrr440_w AT p_row,p_col
        WITH FORM "axr/42f/axrr440"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.n ='1'
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ooa01,ooa02,ooa03,ooa15,oob24
       BEFORE CONSTRUCT
           CALL cl_qbe_init()

       ON ACTION locale
          CALL cl_show_fld_cont() 
          LET g_action_choice = "locale"
          EXIT CONSTRUCT
 
       ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
       ON ACTION about
          CALL cl_about()
       ON ACTION HELP
          CALL cl_show_help()
 
       ON ACTION controlg
          CALL cl_cmdask()
  
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT CONSTRUCT

       ON ACTION qbe_select
          CALL cl_qbe_select()
        #No.FUN-C40001  --Begin
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ooa01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ooa"
                 LET g_qryparam.arg1 = "3"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooa01
                 NEXT FIELD ooa01
              WHEN INFIELD(ooa03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ11"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooa03
                 NEXT FIELD ooa03
              WHEN INFIELD(ooa15)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooa15
                 NEXT FIELD ooa15
              WHEN INFIELD(oob24)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ11"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oob24
                 NEXT FIELD oob24
              END CASE
        #No.FUN-C40001  --End

    END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr440_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF

   INPUT BY NAME tm.n,tm.more WITHOUT DEFAULTS
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD n
         IF cl_null(tm.n) OR tm.n NOT MATCHES '[123]' THEN
            NEXT FIELD n
         END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT

      ON ACTION qbe_save
         CALL cl_qbe_save()

   END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr440_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF

   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr440'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr440','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.n CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'",
                         " '",g_rpt_name CLIPPED,"'" 
         CALL cl_cmdat('axrr440',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr440_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr440()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr440_w
END FUNCTION
 
FUNCTION axrr440()
   DEFINE l_name    LIKE type_file.chr20,        # External(Disk) file name
          l_sql     LIKE type_file.chr1000, 
          l_za05    LIKE type_file.chr1000,
          sr        RECORD
                    ooa01     LIKE ooa_file.ooa01,
                    ooa02     LIKE ooa_file.ooa02,
                    ooa03     LIKE ooa_file.ooa03,
                    ooa032    LIKE ooa_file.ooa032,
                    ooa15     LIKE ooa_file.ooa15,
                    gem02     LIKE gem_file.gem02,
                    ooa13     LIKE ooa_file.ooa13,
                    ooaconf   LIKE ooa_file.ooaconf,
                    oob02     LIKE oob_file.oob02,  
                    oob03     LIKE oob_file.oob03,
                    oob04     LIKE oob_file.oob04,
                    oob05     LIKE oob_file.oob05,
                    oob24     LIKE oob_file.oob24,
                    oob06     LIKE oob_file.oob06,
                    oob07     LIKE oob_file.oob07,
                    oob08     LIKE oob_file.oob08,
                    oob09     LIKE oob_file.oob09,
                    oob27     LIKE oob_file.oob27,
                    oob10     LIKE oob_file.oob10,
                    oob11     LIKE oob_file.oob11, 
                    aag00     LIKE aag_file.aag00,
                    aag02     LIKE aag_file.aag02,
                    oob12     LIKE oob_file.oob12,
                    azi03     LIKE azi_file.azi03,
                    azi04     LIKE azi_file.azi04,
                    azi05     LIKE azi_file.azi05,
                    azi07     LIKE azi_file.azi07
                    END RECORD
   DEFINE l_flag1    LIKE type_file.chr1                                                                      
   DEFINE l_bookno1  LIKE aza_file.aza81                                                                      
   DEFINE l_bookno2  LIKE aza_file.aza82
   DEFINE l_oob04a   LIKE ooc_file.ooc02
   DEFINE l_oao06    LIKE oao_file.oao06
   DEFINE l_img_blob     LIKE type_file.blob
#   DEFINE l_ii           INTEGER                             #TQC-C10039
#   DEFINE l_sql_2        LIKE type_file.chr1000        # RDSQL STATEMENT    #TQC-C10039
#   DEFINE l_key          RECORD                  #主鍵      #TQC-C10039
#             v1          LIKE ooa_file.ooa01                #TQC-C10039
#                         END RECORD                        #TQC-C10039

   DEFINE l_ooz29   LIKE ooz_file.ooz29

     LOCATE l_img_blob IN MEMORY
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ", 
                 "        ?,?,?,?,?, ?,?,?)"    #TQC-C10039 add 1?
     PREPARE insert_prep FROM g_sql                                               
     IF STATUS THEN                                                               
        CALL cl_err('insert_prep',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
        EXIT PROGRAM                          
     END IF             
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " VALUES(?,?,?,?)"  
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                          
                 " VALUES(?,?,?,?)"                                                 
     PREPARE insert_prep2 FROM g_sql                                            
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep2',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
        EXIT PROGRAM                       
     END IF 

     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,            
                 " VALUES(?,?,?,?)"                                                  
     PREPARE insert_prep3 FROM g_sql                                            
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep3',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
        EXIT PROGRAM                       
     END IF 

     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,            
                 " VALUES(?,?,?,?)"                                                  
     PREPARE insert_prep4 FROM g_sql                                            
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep4',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
        EXIT PROGRAM                       
     END IF 

     CALL cl_del_data(l_table)             
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
     CALL cl_del_data(l_table3)
     CALL cl_del_data(l_table4)
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

    LET l_sql="SELECT ooa01,ooa02,ooa03,ooa032,ooa15,gem02,ooa13,ooaconf, ",
               "       oob02,oob03,oob04,oob05,oob24,oob06,oob07,oob08,oob09,oob27,oob10, ",
               "       oob11,aag00,aag02,oob12,", 
               "       azi03,azi04,azi05,azi07",
               "  FROM ooa_file LEFT OUTER JOIN gem_file ON ooa_file.ooa15=gem_file.gem01,",
               "       oob_file LEFT OUTER JOIN aag_file ON oob_file.oob11=aag_file.aag01",
               "       LEFT OUTER JOIN azi_file ON oob_file.oob07=azi_file.azi01",
               " WHERE ooa01=oob01", 
               "   AND ooaconf != 'X'", 
               "   AND ooa37 = '3' ",
               "   AND ",tm.wc CLIPPED,
               " ORDER BY ooa01 "
     PREPARE axrr440_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE axrr440_curs1 CURSOR FOR axrr440_prepare1

     FOREACH axrr440_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD     
          EXIT FOREACH
       END IF
       CALL s_get_bookno(YEAR(sr.ooa02)) RETURNING l_flag1,l_bookno1,l_bookno2                                                      
       IF l_flag1 = '1' THEN                                                                                                        
          CALL cl_err(YEAR(sr.ooa02),'aoo-081',1)                                 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD                                                  
          EXIT PROGRAM                                                                                                              
       END IF                                                                                                                       
                                                                                                            
       IF sr.aag00 <> l_bookno1 THEN CONTINUE FOREACH END IF
       IF tm.n = '1' AND sr.ooaconf = 'N' THEN CONTINUE FOREACH END IF
       IF tm.n='2' AND sr.ooaconf ='Y' THEN CONTINUE FOREACH END IF

       DECLARE memo_c2 CURSOR FOR 
        SELECT oao06 FROM oao_file                 
          WHERE oao01=sr.ooa01                     
            AND oao03=sr.oob02 AND oao05='1'                
       FOREACH memo_c2 INTO l_oao06                                          
          IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF                        
          EXECUTE insert_prep2 USING sr.ooa01,sr.oob02,'1',l_oao06  
       END FOREACH                                                            
 
       DECLARE memo_c3 CURSOR FOR 
        SELECT oao06 FROM oao_file                 
          WHERE oao01=sr.ooa01                     
            AND oao03=sr.oob02 AND oao05='2'                
       FOREACH memo_c3 INTO l_oao06                                          
          IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF                        
          EXECUTE insert_prep3 USING sr.ooa01,sr.oob02,'2',l_oao06  
       END FOREACH                                                            
 
       LET l_oob04a=''
           IF sr.oob03 = '1' THEN
              CASE sr.oob04
                   WHEN '1' LET l_oob04a=cl_getmsg('axr-920',g_lang)
                   WHEN '2' LET l_oob04a=cl_getmsg('axr-921',g_lang)
                   WHEN '3' LET l_oob04a=cl_getmsg('axr-922',g_lang)
                   WHEN '4' LET l_oob04a=cl_getmsg('axr-923',g_lang)
                   WHEN '5' LET l_oob04a=cl_getmsg('axr-924',g_lang)
                   WHEN '6' LET l_oob04a=cl_getmsg('axr-925',g_lang)
                   WHEN '7' LET l_oob04a=cl_getmsg('axr-926',g_lang)
                   WHEN '8' LET l_oob04a=cl_getmsg('axr-927',g_lang)
                   WHEN '9' LET l_oob04a=cl_getmsg('axr-928',g_lang)
              END CASE
           ELSE
              CASE sr.oob04
                   WHEN '1' LET l_oob04a=cl_getmsg('axr-929',g_lang)
                   WHEN '2' LET l_oob04a=cl_getmsg('axr-930',g_lang)
                   WHEN '4' LET l_oob04a=cl_getmsg('axr-931',g_lang)
                   WHEN '7' LET l_oob04a=cl_getmsg('axr-932',g_lang)
                   WHEN '9' LET l_oob04a=cl_getmsg('axr-922',g_lang)
              END CASE
           END IF
       IF cl_null(l_oob04a) THEN
          SELECT ooc02 INTO l_oob04a FROM ooc_file WHERE ooc01 = sr.oob04
       END IF 
       LET l_oob04a = sr.oob04,' ',l_oob04a CLIPPED
       EXECUTE insert_prep USING sr.ooa01,sr.ooa02,sr.ooa03,sr.ooa032,sr.ooa15,
                                 sr.gem02,sr.ooa13,sr.oob02,sr.oob03,l_oob04a,sr.oob05,
                                 sr.oob24,sr.oob06,sr.oob07,sr.oob08,sr.oob09,sr.oob27,sr.oob10,
                                 sr.oob11,sr.aag02,sr.oob12,sr.azi04,sr.azi05,
                                 sr.azi07,
                                 "",l_img_blob,"N",""    #TQC-C10039 add ""

     END FOREACH

     LET l_sql = "SELECT DISTINCT ooa01 FROM ",
                  g_cr_db_str CLIPPED,l_table CLIPPED
     PREPARE r440_p FROM l_sql
     DECLARE r440_curs CURSOR FOR r440_p
     FOREACH r440_curs INTO sr.ooa01
        DECLARE memo_c1 CURSOR FOR 
         SELECT oao06 FROM oao_file                 
           WHERE oao01=sr.ooa01                     
             AND oao03=0 AND oao05='1'                
        FOREACH memo_c1 INTO l_oao06                                          
           IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF                        
           EXECUTE insert_prep1 USING sr.ooa01,'','1',l_oao06  
        END FOREACH              
        DECLARE memo_c4 CURSOR FOR 
         SELECT oao06 FROM oao_file                 
           WHERE oao01=sr.ooa01                     
             AND oao03=0 AND oao05='2'                
        FOREACH memo_c4 INTO l_oao06                                          
           IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF                        
           EXECUTE insert_prep4 USING sr.ooa01,'','2',l_oao06  
        END FOREACH              
     END FOREACH
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'ooa01,ooa02,ooa03,ooa15,oob24')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     SELECT ooz29 INTO l_ooz29 FROM ooz_file
     LET g_str = g_str,";",g_azi04,";",l_ooz29
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED 
 
# TQC-C10039-begin-
     LET g_cr_table = l_table                 #主報表的temp table名稱
#     LET g_cr_gcx01 = "axri010"               #單別維護程式
     LET g_cr_apr_key_f = "ooa01"             #報表主鍵欄位名稱，用"|"隔開 
#     LET l_sql_2 = "SELECT DISTINCT ooa01 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
#     PREPARE key_pr FROM l_sql_2
#     DECLARE key_cs CURSOR FOR key_pr
#     LET l_ii = 1
#     #報表主鍵值
#     CALL g_cr_apr_key.clear()                #清空
#     FOREACH key_cs INTO l_key.*            
#        LET g_cr_apr_key[l_ii].v1 = l_key.v1
#        LET l_ii = l_ii + 1
#     END FOREACH
# TQC-C10039-end-
     CALL cl_prt_cs3('axrr440','axrr440',l_sql,g_str)

END FUNCTION
