# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: atmr253.4gl
# Descriptions...: 集團雜發申請單鉤稽表打印 
# Date & Author..: 06/04/03 By cl
# Modify.........: No.FUN-680120 06/08/31 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-750097 07/06/19 By cheunl 報表改寫為CR報表
# Modify.........: No.TQC-940093 09/04/16 By mike 資料庫使用s_dbstring 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A10056 10/01/12 by dxfwo  跨DB處理 
# Modify.........: No.FUN-A50102 10/06/11 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A70084 10/07/15 By lutingting GP5.2報表修改
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc     STRING,
           more   LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
           END RECORD
DEFINE g_rpt_name  LIKE type_file.chr20           #No.FUN-680120 VARCHAR(20)           # For TIPTOP 串 EasyFlow
DEFINE g_cnt       LIKE type_file.num10           #No.FUN-680120 INTEGER
DEFINE g_i         LIKE type_file.num5            #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE l_table        STRING                 #No.FUN-750097                                                                         
DEFINE g_str          STRING                 #No.FUN-750097                                                                         
DEFINE g_sql          STRING                 #No.FUN-750097
MAIN
   OPTIONS 
       
       INPUT NO WRAP
   DEFER INTERRUPT                      # Supress DEL key function
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF      
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
#No.FUN-750097 -----------start-----------------                                                                                    
    LET g_sql = " tsg01.tsg_file.tsg01,", 
                " tsg02.tsg_file.tsg02,", 
                " tsg03.tsg_file.tsg03,", 
                " tsg04.tsg_file.tsg04,", 
                " tsg06.tsg_file.tsg06,", 
                " tsg07.tsg_file.tsg07,", 
                " tsg17.tsg_file.tsg17,", 
                " tsg18.tsg_file.tsg18,", 
                " tsh02.tsh_file.tsh02,", 
                " tsh03.tsh_file.tsh03,", 
                " tsh04.tsh_file.tsh04,", 
                " tsh05.tsh_file.tsh05,", 
                " inb09.inb_file.inb09,", 
                " ina01.ina_file.ina01,", 
                " ima02.ima_file.ima02,", 
                " ima021.ima_file.ima021,", 
                " azp02.azp_file.azp02,", 
                " azq03.azq_file.azq03,", 
                " imd02.imd_file.imd02,", 
                " ime03.ime_file.ime03 " 
    LET l_table = cl_prt_temptable('atmr253',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",                                                                          
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                                  
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#No.FUN-750097---------------end------------
   LET tm.wc      = ARG_VAL(1)
   LET g_rpt_name = ARG_VAL(2)        
   LET g_rep_user = ARG_VAL(3)
   LET g_rep_clas = ARG_VAL(4)
   LET g_template = ARG_VAL(5)
   LET tm.more    = ARG_VAL(6)
   LET g_rpt_name = ARG_VAL(7)  #No.FUN-7C0078
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   IF cl_null(tm.wc) THEN
        CALL atmr253_tm(0,0)             # Input print condition
   ELSE LET tm.wc="tsg01= '",tm.wc CLIPPED,"'"
        CALL atmr253()                   # Read data and create out-file
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION atmr253_tm(p_row,p_col)
DEFINE lc_qbe_sn    LIKE gbm_file.gbm01
DEFINE p_row,p_col  LIKE type_file.num5,          #No.FUN-680120 SMALLINT
       l_cmd        LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(1000)
       l_dbs        LIKE type_file.chr21          #No.FUN-680120 VARCHAR(21)
DEFINE l_tsg03      LIKE tsg_file.tsg03,
       l_tsg04      LIKE tsg_file.tsg04,
       l_tsg06      LIKE tsg_file.tsg06,
       l_tsg07      LIKE tsg_file.tsg07
       
  LET p_row=7 LET p_col=7
  
  OPEN WINDOW atmr253_w AT p_row,p_col WITH FORM "atm/42f/atmr253"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
  
  CALL cl_ui_init()
  
  CALL cl_opmsg('p')
 
 
   LET g_rpt_name = ''
   INITIALIZE tm.* TO NULL  
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
  WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON tsg01,tsg02,tsg03,tsg05,tsg06,
                               tsg17,tsg18
 
      BEFORE CONSTRUCT
         LET l_tsg03=''
         LET l_tsg06=''
         CALL cl_qbe_init()
      
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(tsg01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_tsg"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tsg01  
           WHEN INFIELD(tsg03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_azp"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tsg03
               LET l_tsg03=g_qryparam.multiret
           WHEN INFIELD(tsg06)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_azp"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tsg06 
               LET l_tsg06=g_qryparam.multiret               
           OTHERWISE EXIT CASE   
      END CASE
      
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
    
    IF g_action_choice = "locale" THEN
       LET g_action_choice = ""
       CALL cl_dynamic_locale()
       CONTINUE WHILE
    END IF
    
    IF INT_FLAG THEN
       LET INT_FLAG = 0 CLOSE WINDOW atmr254_w 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
       EXIT PROGRAM
          
    END IF
    IF tm.wc=" 1=1" THEN
       CALL cl_err('','9046',0) CONTINUE WHILE
    END IF
    
    INPUT BY NAME  tm.more 
                
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
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION qbe_save
            CALL cl_qbe_save()        
    END INPUT    
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW atmr253_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='axmr410'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('atmr253','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",    
                        " '",g_rep_clas CLIPPED,"'",     
                        " '",g_template CLIPPED,"'"      
            CALL cl_cmdat('atmr253',g_time,l_cmd)
         END IF
         CLOSE WINDOW atmr253_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL atmr253()
      ERROR ""
   END WHILE
   CLOSE WINDOW atmr253_w   
END FUNCTION
 
FUNCTION atmr253()
DEFINE l_sql    STRING,
       l_sql1   STRING,
       l_name   LIKE type_file.chr20,            #No.FUN-680120 VARCHAR(20)
#       l_time       LIKE type_file.chr8       #No.FUN-6B0014
       l_dbs    LIKE type_file.chr21,            #No.FUN-680120 VARCHAR(21)
       t_dbs    LIKE type_file.chr21             #No.FUN-680120 VARCHAR(21)
DEFINE sr       RECORD
                tsg01    LIKE tsg_file.tsg01,
                tsg02    LIKE tsg_file.tsg02,
                tsg17    LIKE tsg_file.tsg17,
                tsg03    LIKE tsg_file.tsg03,
                tsg04    LIKE tsg_file.tsg04,
                tsg06    LIKE tsg_file.tsg06,
                tsg07    LIKE tsg_file.tsg07,
                tsg18    LIKE tsg_file.tsg18,
                ina01    LIKE ina_file.ina01,
                tsh02    LIKE tsh_file.tsh02,
                tsh03    LIKE tsh_file.tsh03,
                tsh04    LIKE tsh_file.tsh04,
                tsh05    LIKE tsh_file.tsh05,
                inb09    LIKE inb_file.inb09
                END RECORD
#No.FUN-750097-----------------start--------------                                                                                  
DEFINE              l_azp02a LIKE azp_file.azp02,                                                                                   
                    l_imd02a LIKE imd_file.imd02,                                                                                   
                    l_azp02b LIKE azp_file.azp02,                                                                                   
                    l_imd02b LIKE imd_file.imd02,                                                                                   
                    l_ima02  LIKE ima_file.ima02,                                                                                   
                    l_ima021 LIKE ima_file.ima021
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                       
#No.FUN-750097-----------------end----------------                
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND tskuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND tskgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN      #群組權限
     #         LET tm.wc = tm.wc clipped," AND tskgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('tskuser', 'tskgrup')
     #End:FUN-980030
      
     LET l_sql=" SELECT tsg01,tsg02,tsg17,tsg03,tsg04,tsg06,tsg07,tsg18, ",
               " '', tsh02,tsh03,tsh04,tsh05 ",
               " FROM tsg_file, tsh_file  ",
               " WHERE tsg01=tsh01 ",
               " AND ",tm.wc CLIPPED ,
               " ORDER BY tsg01,tsh02 "
     PREPARE r253_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM
     END IF
     DECLARE r253_curs1 CURSOR FOR r253_prepare1
#    CALL cl_outnam('atmr253') RETURNING l_name         #No.FUN-750097
#    START REPORT r253_rep TO l_name                    #No.FUN-750097
     LET g_pageno = 0
     FOREACH r253_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CALL r253_azp(sr.tsg06) RETURNING l_dbs
       LET l_sql1=" SELECT inb01,SUM(inb09) ",
#                 " FROM ",l_dbs,"ina_file,",l_dbs CLIPPED,"inb_file ",
                  " FROM ",cl_get_target_table(sr.tsg06, 'ina_file'),",", cl_get_target_table(sr.tsg06, 'inb_file'),  #NO.FUN-A10056
                  " WHERE ina01=inb01 AND ina1018='",sr.tsg01 CLIPPED,"'",
                  " AND inb03='",sr.tsh02 CLIPPED,"'",
                  " GROUP BY inb01 "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
 	     CALL cl_parse_qry_sql(l_sql1,sr.tsg06) RETURNING l_sql1            #NO.FUN-A10056
       PREPARE r253_prepare2 FROM l_sql1 
       IF SQLCA.sqlcode !=0 THEN
          CALL cl_err('prepare:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
          EXIT PROGRAM
       END IF
       DECLARE r253_curs2 CURSOR FOR r253_prepare2
       OPEN r253_curs2
       FETCH r253_curs2 INTO sr.ina01,sr.inb09
       IF SQLCA.sqlcode = 100 THEN
          LET sr.ina01=' '
          LET sr.inb09=0
       ELSE
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
       END IF
#No.FUN-750097-----------start-----------------
       SELECT azp02 INTO l_azp02a FROM azp_file WHERE azp01=sr.tsg03 
       SELECT azp02 INTO l_azp02b FROM azp_file WHERE azp01=sr.tsg06 
       CALL r253_azp(sr.tsg03) RETURNING l_dbs
       IF NOT cl_null(l_dbs) THEN
          #CALL r253_imd(sr.tsg04,l_dbs) RETURNING l_imd02a
          CALL r253_imd(sr.tsg07,sr.tsg03) RETURNING l_imd02a   #FUN-A50102
       ELSE
          LET l_imd02a = ' '
       END IF
       CALL r253_azp(sr.tsg06) RETURNING l_dbs
       IF NOT cl_null(l_dbs) THEN
          #CALL r253_imd(sr.tsg07,l_dbs) RETURNING l_imd02b
          CALL r253_imd(sr.tsg07,sr.tsg06) RETURNING l_imd02b   #FUN-A50102
       ELSE
          LET l_imd02b = ' '
       END IF
       SELECT ima02,ima021 INTO l_ima02,l_ima021 
         FROM ima_file WHERE ima01=sr.tsh03
#      OUTPUT TO REPORT r253_rep(sr.*)
       EXECUTE insert_prep USING
               sr.tsg01,sr.tsg02,sr.tsg03,sr.tsg04,sr.tsg06,sr.tsg07,sr.tsg17,sr.tsg18,
               sr.tsh02,sr.tsh03,sr.tsh04,sr.tsh05,sr.inb09,sr.ina01,l_ima02,l_ima021,
               l_azp02a,l_azp02b,l_imd02a,l_imd02b
     END FOREACH
#    FINISH REPORT r253_rep
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                               
     LET g_str = ''                                                                                                                 
     #是否列印選擇條件                                                                                                              
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'tsg01')                                                                                                
             RETURNING tm.wc                                                                                                        
        LET g_str = tm.wc                                                                                                           
     END IF                                                                                                                         
     CALL cl_prt_cs3('atmr253','atmr253',l_sql,g_str)                                                                                 
#No.FUN-750097-------------end--------------------
 
END FUNCTION
 
#No.FUN-750097----------start----------------
{REPORT r253_rep(sr)
DEFINE l_last_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
       l_dbs        LIKE type_file.chr21,            #No.FUN-680120 VARCHAR(21)
       l_mess       LIKE type_file.chr1000           #No.FUN-680120 VARCHAR(300)
DEFINE sr           RECORD
                    tsg01    LIKE tsg_file.tsg01,
                    tsg02    LIKE tsg_file.tsg02,
                    tsg17    LIKE tsg_file.tsg17,
                    tsg03    LIKE tsg_file.tsg03,
                    tsg04    LIKE tsg_file.tsg04,
                    tsg06    LIKE tsg_file.tsg06,
                    tsg07    LIKE tsg_file.tsg07,
                    tsg18    LIKE tsg_file.tsg18,
                    ina01    LIKE ina_file.ina01,
                    tsh02    LIKE tsh_file.tsh02,
                    tsh03    LIKE tsh_file.tsh03,
                    tsh04    LIKE tsh_file.tsh04,
                    tsh05    LIKE tsh_file.tsh05,
                    inb09    LIKE inb_file.inb09
                    END RECORD
DEFINE              l_azp02a LIKE azp_file.azp02,
                    l_imd02a LIKE imd_file.imd02,
                    l_azp02b LIKE azp_file.azp02,
                    l_imd02b LIKE imd_file.imd02,
                    l_ima02  LIKE ima_file.ima02,
                    l_ima021 LIKE ima_file.ima021,
                    l_sum1   LIKE tsh_file.tsh05,
                    l_sum2   LIKE inb_file.inb09
                
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
      PRINT g_dash[1,g_len]
      PRINTX name=H1 g_x[8],g_x[9],g_x[10],g_x[11],g_x[12],g_x[13],g_x[14],
                     g_x[15],g_x[16],g_x[17],g_x[18],g_x[21],g_x[22],g_x[23]
      PRINTX name=H2 g_x[24],g_x[26],g_x[19]
      PRINTX name=H3 g_x[25],g_x[27],g_x[20]
      PRINT g_dash1
      LET l_last_sw = 'n'
      LET l_mess=''
 
   BEFORE GROUP OF sr.tsg01
     SELECT azp02 INTO l_azp02a FROM azp_file WHERE azp01=sr.tsg03 
     SELECT azp02 INTO l_azp02b FROM azp_file WHERE azp01=sr.tsg06 
     CALL r253_azp(sr.tsg03) RETURNING l_dbs
     IF NOT cl_null(l_dbs) THEN
       #CALL r253_imd(sr.tsg04,l_dbs) RETURNING l_imd02a    #FUN-A70084
        CALL r253_imd(sr.tsg04,sr.tsg03) RETURNING l_imd02a    #FUN-A70084
     ELSE
        LET l_imd02a = ' '
     END IF
     CALL r253_azp(sr.tsg06) RETURNING l_dbs
     IF NOT cl_null(l_dbs) THEN
       #CALL r253_imd(sr.tsg07,l_dbs) RETURNING l_imd02b    #FUN-A70084
        CALL r253_imd(sr.tsg07,sr,tsg06) RETURNING l_imd02b    #FUN-A70084
     ELSE
        LET l_imd02b = ' '
     END IF
     PRINTX name=D1
           COLUMN g_c[8], sr.tsg01 CLIPPED,
           COLUMN g_c[9], sr.tsg02 CLIPPED,
           COLUMN g_c[10],sr.tsg17 CLIPPED,
           COLUMN g_c[11],sr.tsg03 CLIPPED,' ',l_azp02a CLIPPED,
           COLUMN g_c[12],sr.tsg04 CLIPPED,' ',l_imd02a CLIPPED,
           COLUMN g_c[13],sr.tsg06 CLIPPED,' ',l_azp02b CLIPPED,
           COLUMN g_c[14],sr.tsg07 CLIPPED,' ',l_imd02b CLIPPED,
           COLUMN g_c[15],sr.tsg18 CLIPPED,
           COLUMN g_c[16],sr.ina01 CLIPPED;
     
     ON EVERY ROW
        SELECT ima02,ima021 INTO l_ima02,l_ima021 
          FROM ima_file WHERE ima01=sr.tsh03
        PRINTX name=D1
               COLUMN g_c[17],sr.tsh02 USING '<<<<<',
               COLUMN g_c[18],sr.tsh03 CLIPPED,
               COLUMN g_c[21],sr.tsh04 CLIPPED,
               COLUMN g_c[22],sr.tsh05 USING '#,###,###,###,##&.##', 
               COLUMN g_c[23],sr.inb09 USING '####,###,##&.##'
        PRINTX name=D2
               COLUMN g_c[19],l_ima02 CLIPPED
        PRINTX name=D3
               COLUMN g_c[20],l_ima021 CLIPPED
               
              
      AFTER GROUP OF sr.tsg01
        PRINT g_dash2[1,g_len] 
       
     ON LAST ROW
        PRINT ''
        LET l_last_sw = 'y'               
        PRINT g_dash[1,g_len]
        PRINT g_x[4], COLUMN (g_len-9), g_x[6] CLIPPED
   
     PAGE TRAILER
        IF l_last_sw = 'n' THEN
           PRINT g_dash[1,g_len]
           PRINT g_x[4],COLUMN (g_len-9),g_x[5] CLIPPED  
        ELSE
           SKIP 2 LINE
        END IF
        PRINT
        IF l_last_sw = 'n' THEN
           IF g_memo_pagetrailer THEN
               PRINT g_x[4]
               PRINT g_memo
           ELSE
               PRINT
               PRINT
           END IF
        ELSE
               PRINT	
               PRINT g_memo
        END IF           
END REPORT}
#No.FUN-750097----------end------------------
 
 
 
FUNCTION r253_azp(l_azp01)
DEFINE l_azp01  LIKE azp_file.azp01,
       l_azp03  LIKE azp_file.azp03,                                                                                             
       l_dbs    LIKE type_file.chr21            #No.FUN-680120 VARCHAR(21)                                                                                                  
                                                                                                                                    
    LET g_errno=' '                                                                                                                 
    SELECT azp03 INTO l_azp03 FROM azp_file                                                                                         
     WHERE azp01=l_azp01                                                                                                            
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-025'                                                                          
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'                                                      
    END CASE                                                                                                                        
   #LET l_dbs = l_azp03 CLIPPED,"."            #TQC-940093                                                                          
    LET l_dbs = s_dbstring(l_azp03 CLIPPED)    #TQC-940093                                                                                                  
    RETURN l_dbs                                             
END FUNCTION
 
#FUNCTION r253_imd(l_imd01,l_dbs)                 #FUN-A50102
FUNCTION r253_imd(l_imd01,l_plant)
#DEFINE l_dbs    LIKE type_file.chr21,         #No.FUN-680120 VARCHAR(21)#FUN-A50102
DEFINE l_plant  LIKE azp_file.azp01,           #FUN-A50102
       l_sql2   LIKE type_file.chr1000         #No.FUN-680120 VARCHAR(3000)
DEFINE l_imd01  LIKE imd_file.imd01,
       l_imd02  LIKE imd_file.imd02
     
     LET g_errno=' '      
     #LET l_sql2 = " SELECT imd02 FROM ",l_dbs CLIPPED,"imd_file ",
     LET l_sql2 = " SELECT imd02 FROM ",cl_get_target_table(l_plant, 'imd_file'),#FUN-A50102
                  " WHERE imd01='",l_imd01 CLIPPED,"'"
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant) RETURNING l_sql2 #FUN-A50102
     PREPARE r253_pre1 FROM l_sql2
     IF SQLCA.sqlcode !=0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
     END IF
     DECLARE r253_cs1 CURSOR FOR r253_pre1
     OPEN r253_cs1
     FETCH r253_cs1 INTO l_imd02
     CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1100'
          OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     RETURN l_imd02
END FUNCTION
 
