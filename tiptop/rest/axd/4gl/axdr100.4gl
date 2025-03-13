# Prog. Version..: '5.10.00-08.01.04(00003)'     #
# Pattern name...: axdr100.4gl
# Descriptions...: 廠商庫存月統計表
# Date & Author..: 04/1/12	By Hawk
# Modify.........: No.MOD-4B0067 04/11/09 By Elva 將變數用Like方式定義,報表拉成一行
# Modify.........: No.MOD-4B0267 04/11/25 By Carrier  AXD系統中客戶編號長度擴大至10碼
# Modify.........: No:FUN-520024 05/02/25 報表轉XML By wujie
# Modify.........: No:TQC-610088 06/02/10 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No:FUN-680108 06/08/28 By zhuying 欄位形態定義為LIKE 
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
DATABASE ds

GLOBALS "../../config/top.global"

   DEFINE tm  RECORD                  
              wc      LIKE type_file.chr1000,    #No.FUN-680108 VARCHAR(500)     
              bdate   LIKE adq_file.adq04,      
              edate   LIKE adq_file.adq04,      
              more    LIKE type_file.chr1        #No.FUN-680108 VARCHAR(1)        
              END RECORD
            
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680108 SMALLINT 
MAIN
   OPTIONS
       FORM LINE     FIRST + 2,
       MESSAGE LINE  LAST,
       PROMPT LINE   LAST,
       INPUT NO WRAP
   DEFER INTERRUPT                   
   LET g_pdate  = ARG_VAL(1)          
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No:FUN-570264 ---end---

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXD")) THEN
      EXIT PROGRAM
   END IF
   IF NOT cl_null(tm.wc) THEN                                                   
      CALL r100()                                                               
   ELSE                                                                         
      CALL r100_tm(0,0)                                                         
   END IF 
END MAIN

FUNCTION r100_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No:FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680108 SMALLINT
       l_cmd          LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(1000)

 LET p_row = 3 LET p_col = 22 
   OPEN WINDOW r100_w AT p_row,p_col
        WITH FORM "axd/42f/axdr100" ATTRIBUTE(STYLE = g_win_style)
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL         
   LET tm.more = 'N'
   LET tm.bdate= g_today
   LET tm.edate= g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON adq01,adq02,adq03

      #No:FUN-580031 --start--
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No:FUN-580031 ---end---

      ON ACTION locale                                                          
         #CALL cl_dynamic_locale()                                             
         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
         LET g_action_choice = "locale"                                         
         EXIT CONSTRUCT                                                         
                                                                                
      ON IDLE g_idle_seconds                                                      
         CALL cl_on_idle()                                                        
         CONTINUE CONSTRUCT                                                       
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION exit                                                       
         LET INT_FLAG = 1                                                     
         EXIT CONSTRUCT                                                       

      #No:FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      #No:FUN-580031 ---end---

 END CONSTRUCT                                                                  
       IF g_action_choice = "locale" THEN                                       
          LET g_action_choice = ""                                              
          CALL cl_dynamic_locale()                                              
          CONTINUE WHILE                                                        
       END IF                
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW r100_w 
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.bdate,tm.edate,tm.more WITHOUT DEFAULTS HELP 1

      #No:FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No:FUN-580031 ---end---

      AFTER FIElD bdate
         IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF

      AFTER FIELD edate
         IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
         IF tm.bdate > tm.edate THEN NEXT FIELD bdate END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG CALL cl_cmdask()  

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

      #No:FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No:FUN-580031 ---end---

   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW r100_w 
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file  
             WHERE zz01='axdr100'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axdr100','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,     
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                     #------------No:TQC-610088 modify
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                     #------------No:TQC-610088 end
                         " '",g_rep_user CLIPPED,"'",           #No:FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No:FUN-570264
                         " '",g_template CLIPPED,"'"            #No:FUN-570264
         CALL cl_cmdat('axdr100',g_time,l_cmd)   
      END IF
      CLOSE WINDOW r100_w
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r100()
   ERROR ""
END WHILE
   CLOSE WINDOW r100_w
END FUNCTION

FUNCTION r100()
   DEFINE l_name    LIKE type_file.chr20,   #No.FUN-680108 VARCHAR(20)                   
#       l_time          LIKE type_file.chr8        #No.FUN-6A0091
          l_sql     LIKE type_file.chr1000, #No.FUN-680108 VARCHAR(300)
          l_chr     LIKE type_file.chr1,    #No.FUN-680108 VARCHAR(1)
          l_za05    LIKE za_file.za05,      #MOD-4B0067
          l_order   ARRAY[5] OF LIKE type_file.chr20,   #No.FUN-680108 VARCHAR(20)
          sr               RECORD 
                               adq01  LIKE adq_file.adq01,  
                               occ02  LIKE occ_file.occ02,
                               adq02  LIKE adq_file.adq02, 
                               cob02  LIKE cob_file.cob02, 
                               cob021 LIKE cob_file.cob021,
                               adq03  LIKE adq_file.adq03, 
                               adq04  LIKE adq_file.adq04, 
                               adq09  LIKE adq_file.adq09, 
                               adq10  LIKE adq_file.adq10  
                           END RECORD

       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

     LET l_sql = "SELECT adq01,'',adq02,'',adq03,adq04,adq09,adq10",
                 "  FROM adq_file",
                 " WHERE adq04 BETWEEN '",tm.bdate, "'",
                 "   AND '",tm.edate,"'",
                 "   AND ",tm.wc CLIPPED,
                 " ORDER BY adq01,adq02,adq03"

     PREPARE r100_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        EXIT PROGRAM 
     END IF
     DECLARE r100_curs1 CURSOR FOR r100_prepare1

     CALL cl_outnam('axdr100') RETURNING l_name
     START REPORT r100_rep TO l_name
     LET g_pageno = 0

     FOREACH r100_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
       OUTPUT TO REPORT r100_rep(sr.*)
     END FOREACH

     FINISH REPORT r100_rep

     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
END FUNCTION

REPORT r100_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,           #No.FUN-680108 VARCHAR(1)
          sr           RECORD 
                           adq01  LIKE adq_file.adq01,  
                           occ02  LIKE occ_file.occ02,
                           adq02  LIKE adq_file.adq02,  
                           cob02  LIKE cob_file.cob02, 
                           cob021 LIKE cob_file.cob021,
                           adq03  LIKE adq_file.adq03,  
                           adq04  LIKE adq_file.adq04, 
                           adq09  LIKE adq_file.adq09,
                           adq10  LIKE adq_file.adq10
                       END RECORD,
          l_adq09_a    LIKE adq_file.adq09,
          l_adq09_b    LIKE adq_file.adq09,
          l_adq09_c    LIKE adq_file.adq09,
          l_adq09_d    LIKE adq_file.adq09,
          l_adq09_e    LIKE adq_file.adq09,
          l_adr09      LIKE adr_file.adr09,
          l_bdate      LIKE type_file.dat,        #No.FUN-680108 DATE    
          l_edate      LIKE type_file.dat,        #No.FUN-680108 DATE
          l_yyyy       LIKE type_file.num5,       #No.FUN-680108 SMALLINT
          l_mon        LIKE type_file.num5,       #No.FUN-680108 SMALLINT
          l_days       INTERVAL DAY TO DAY 

  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.adq01,sr.adq02,sr.adq03
  FORMAT
   PAGE HEADER
      PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            LET g_pageno = g_pageno + 1                                         
            LET pageno_total = PAGENO USING '<<<',"/pageno"                     
            PRINT g_head CLIPPED,pageno_total  
      PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT COLUMN 1, g_x[9] CLIPPED,tm.bdate,'-',tm.edate                       
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
            g_x[37],g_x[38],g_x[38],g_x[40],g_x[41] 
      PRINT g_dash1
      LET l_last_sw = 'n'
   
 #MOD-4B0067  --begin
{  BEFORE GROUP OF sr.adq01 
      PRINT COLUMN 01,sr.adq01;

   BEFORE GROUP OF sr.adq02
      PRINT COLUMN 10,sr.adq02;

   BEFORE GROUP OF sr.adq03
      PRINT COLUMN  31,sr.adq03; }
   
   AFTER GROUP OF sr.adq03
      LET   l_adq09_a = GROUP SUM(sr.adq09) WHERE sr.adq10 = '1'
      LET   l_adq09_b = GROUP SUM(sr.adq09) WHERE sr.adq10 = '2'
      IF cl_null(l_adq09_a) THEN LET l_adq09_a = 0 END IF
      IF cl_null(l_adq09_b) THEN LET l_adq09_b = 0 END IF
      LET   l_adq09_c = l_adq09_a - l_adq09_b
      LET   l_adq09_d = GROUP SUM(sr.adq09) WHERE sr.adq10 = '3'
      IF cl_null(l_adq09_d) THEN LET l_adq09_d = 0 END IF
      CALL  s_mothck(tm.edate) RETURNING l_bdate,l_edate
      LET   l_adq09_e = GROUP SUM(sr.adq09) 
            WHERE sr.adq04 >= l_bdate AND sr.adq04 < tm.edate
      
      IF cl_null(l_adq09_e) THEN LET l_adq09_e = 0 END IF
      LET   l_mon = MONTH(l_edate) 
      IF l_mon = 1 THEN
          LET l_mon = 12 
          LET l_yyyy= YEAR(l_edate) - 1
      ELSE
          LET l_mon = l_mon - 1                    #取得前一月的年度和期別
          LET l_yyyy= YEAR(l_edate) 
      END IF
      LET   l_adr09 = 0
      SELECT adr09 INTO l_adr09 FROM adr_file
       WHERE adr01 = sr.adq01 AND adr02 = sr.adq02 
         AND adr03 = sr.adq03 AND adr04 = l_yyyy
         AND adr05 = l_mon

      LET l_adq09_e = l_adq09_e + l_adr09

      SELECT occ02 INTO sr.occ02 FROM occ_file
       WHERE occ01 = sr.adq01

      SELECT cob02 INTO sr.cob02 FROM cob_file
       WHERE cob01 = sr.adq02

      SELECT cob021 INTO sr.cob021 FROM cob_file                                
       WHERE cob01 = sr.adq02  

      PRINT COLUMN g_c[31],sr.adq01;
      PRINT COLUMN g_c[32],sr.occ02;
       PRINT COLUMN g_c[33],sr.adq02; #No.MOD-4B0267
      PRINT COLUMN g_c[34],sr.cob02;
      PRINT COLUMN g_c[35],sr.cob021;
       PRINT COLUMN g_c[36],sr.adq03; #No.MOD-4B0267
 #MOD-4B0067  --end
       PRINT COLUMN g_c[37],l_adq09_a USING '----------&.&&&', #No.MOD-4B0267
             COLUMN g_c[38],l_adq09_b USING '----------&.&&&', #No.MOD-4B0267
             COLUMN g_c[39],l_adq09_c USING '----------&.&&&', #No.MOD-4B0267
             COLUMN g_c[40],l_adq09_d USING '----------&.&&&', #No.MOD-4B0267
             COLUMN g_c[41],l_adq09_e USING '----------&.&&&'  #No.MOD-4B0267
   ON LAST ROW
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, 
            COLUMN (g_len-9), g_x[7] CLIPPED

   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, 
                    COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
