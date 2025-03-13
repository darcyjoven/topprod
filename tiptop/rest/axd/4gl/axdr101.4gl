# Prog. Version..: '5.10.00-08.01.04(00006)'     #
# Pattern name...: axdr101.4gl
# Descriptions...: 廠商庫存月統計表
# Date & Author..: 04/1/13	By Hawk
# Modify.........: No.MOD-4B0067 04/11/09 By Elva 將變數用Like方式定義,報表拉成一行
# Modify.........: No.MOD-4B0267 04/11/25 By Carrier  AXD系統中客戶編號長度擴大至10碼
# Modify.........: No:FUN-520024 05/02/25 報表轉XML By wujie
# Modify.........: No:TQC-610088 06/02/10 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No:FUN-680108 06/08/28 By zhuying 欄位形態定義為LIKE
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:TQC-6A0095 06/11/13 By xumin 期別靠右顯示更改
# Modify.........: No:TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No:FUN-740082 07/04/23 By TSD.Sideny 報表改寫由Crystal Report產出

DATABASE ds

GLOBALS "../../config/top.global"

   DEFINE tm  RECORD                  
              wc      LIKE type_file.chr1000, #No.FUN-680108 VARCHAR(500)     
              yyyy    LIKE type_file.num5,    #No.FUN-680108 SMALLINT      
              m1      LIKE type_file.num5,    #No.FUN-680108 SMALLINT     
              m2      LIKE type_file.num5,    #No.FUN-680108 SMALLINT     
              a       LIKE type_file.chr1,    #No.FUN-680108 VARCHAR(1)
              more    LIKE type_file.chr1     #No.FUN-680108 VARCHAR(1)       
              END RECORD
DEFINE   g_i          LIKE type_file.num5     #count/index for any purpose        #No.FUN-680108 SMALLINT
# NO:FUN-740082 07/04/23 By TSD.Sideny --start--
DEFINE   l_table     STRING
DEFINE   g_sql       STRING
DEFINE   g_str       STRING
# NO:FUN-740082 07/04/23 By TSD.Sideny ---end---

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
#-------------No:TQC-610088 modify
   LET tm.wc    = ARG_VAL(7)
   LET tm.yyyy  = ARG_VAL(8)
   LET tm.m1    = ARG_VAL(9)
   LET tm.m2    = ARG_VAL(10)
   LET tm.a     = ARG_VAL(11)
#-------------No:TQC-610088 modify
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No:FUN-570264 ---end---

    IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXD")) THEN
      EXIT PROGRAM
   END IF

  #NO:FUN-740082 07/04/23 By TSD.Sideny --start--
   LET g_sql = "adr01.adr_file.adr01,",
               "occ02.occ_file.occ02,",
               "adr02.adr_file.adr02,",
               "cob02.cob_file.cob02,",
               "cob021.cob_file.cob021,",
               "adr03.adr_file.adr03,",
               "adr04.adr_file.adr04,",
               "adr05.adr_file.adr05,",
               "adr06.adr_file.adr06,",
               "adr07.adr_file.adr07,",
               "adr08.adr_file.adr08,",
               "adr09.adr_file.adr09,",
               "last_adr09.adr_file.adr09,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05 "

   LET l_table = cl_prt_temptable('axdr101',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
  #NO:FUN-740082 07/04/23 By TSD.Sideny ---end---

   IF NOT cl_null(tm.wc) THEN                                                   
      CALL r101()                                                               
   ELSE                                                                         
      CALL r101_tm(0,0)                                                         
   END IF 
END MAIN

FUNCTION r101_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01      #No:FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,     #No.FUN-680108 SMALLINT
       l_cmd          LIKE type_file.chr1000   #No.FUN-680108 VARCHAR(1000)

   LET p_row = 3 LET p_col = 12 
   
   OPEN WINDOW r101_w AT p_row,p_col
        WITH FORM "axd/42f/axdr101" ATTRIBUTE(STYLE = g_win_style)
   CALL cl_ui_init()
   
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL       
   LET tm.yyyy = YEAR(g_today)  
   LET tm.m1   = MONTH(g_today)
   LET tm.m2   = MONTH(g_today)
   LET tm.a    = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON adr01,adr02,adr03

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
      CLOSE WINDOW r101_w 
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF

   INPUT BY NAME tm.yyyy,tm.m1,tm.m2,tm.a,tm.more WITHOUT DEFAULTS HELP 1

      #No:FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No:FUN-580031 ---end---

      AFTER FIELD yyyy
          IF cl_null(tm.yyyy) THEN NEXT FIELD yyyy END IF
      AFTER FIELD m1
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yyyy
            IF g_azm.azm02 = 1 THEN
               IF tm.m1 > 12 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            ELSE
               IF tm.m1 > 13 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF cl_null(tm.m1) THEN NEXT FIELD m1 END IF                          
#         IF tm.m1 < 1 OR tm.m1 > 12 THEN NEXT FIELD m1 END IF               #No.TQC-720032
      AFTER FIELD m2                                                           
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yyyy
            IF g_azm.azm02 = 1 THEN
               IF tm.m2 > 12 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            ELSE
               IF tm.m2 > 13 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF cl_null(tm.m2) THEN NEXT FIELD m2 END IF                          
#         IF tm.m2 < 1 OR tm.m2 > 12 THEN NEXT FIELD m2 END IF               #No.TQC-720032
         IF tm.m2 < tm.m1 THEN NEXT FIELD m1 END IF 
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
      CLOSE WINDOW r101_w 
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file  
             WHERE zz01='axdr101'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axdr101','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,     
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang   CLIPPED,"'",
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'" ,     #No:TQC-610088 add
                         " '",tm.yyyy  CLIPPED,",",
                         " '",tm.m1    CLIPPED,",",
                         " '",tm.m2    CLIPPED,",",
                         " '",tm.a     CLIPPED,",",
                         " '",g_rep_user CLIPPED,"'",   #No:FUN-570264
                         " '",g_rep_clas CLIPPED,"'",   #No:FUN-570264
                         " '",g_template CLIPPED,"'"    #No:FUN-570264
         CALL cl_cmdat('axdr101',g_time,l_cmd)   
      END IF
      CLOSE WINDOW r101_w
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r101()
   ERROR ""
 END WHILE
 CLOSE WINDOW r101_w
END FUNCTION

FUNCTION r101()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680108 VARCHAR(20)     
#       l_time          LIKE type_file.chr8        #No.FUN-6A0091
          l_sql     LIKE type_file.chr1000,       #No.FUN-680108 VARCHAR(300)
          l_chr     LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(1)
          l_za05    LIKE za_file.za05,            #MOD-4B0067
          l_order   ARRAY[5] OF LIKE type_file.chr20,  #No.FUN-680108 VARCHAR(20) 
          l_yy,l_mm LIKE type_file.num5,          #No.FUN-680108 SMALLINT
          l_i,l_i1  LIKE type_file.num5,          #No.FUN-680108 SMALLINT
          l_adr09   LIKE adr_file.adr09,
          sr1       RECORD 
                        adr01      LIKE adr_file.adr01,  
                        adr02      LIKE adr_file.adr02,  
                        adr03      LIKE adr_file.adr03
                    END RECORD,
          sr        RECORD 
                        adr01      LIKE adr_file.adr01,  
                        occ02      LIKE occ_file.occ02,
                        adr02      LIKE adr_file.adr02,  
                        cob02      LIKE cob_file.cob02,
                        cob021     LIKE cob_file.cob021,
                        adr03      LIKE adr_file.adr03,  
                        adr04      LIKE adr_file.adr04,  
                        adr05      LIKE adr_file.adr05,  
                        adr06      LIKE adr_file.adr06,  
                        adr07      LIKE adr_file.adr07,  
                        adr08      LIKE adr_file.adr08,  
                        adr09      LIKE adr_file.adr09,
                        last_adr09 LIKE adr_file.adr09
                    END RECORD

       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

    #NO:FUN-740082 07/04/23 By TSD.Sideny --start--
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axdr101'
    #NO:FUN-740082 07/04/23 By TSD.Sideny ---end---

     LET l_sql = "SELECT UNIQUE adr01,adr02,adr03",
                 "  FROM adr_file",
                 " WHERE ",tm.wc CLIPPED,
                 " ORDER BY adr01,adr02,adr03" 

     PREPARE r101_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        EXIT PROGRAM 
     END IF
     DECLARE r101_curs1 CURSOR FOR r101_prepare1

    #NO:FUN-740082 07/04/23 By TSD.Sideny --start--
    #CALL cl_outnam('axdr101') RETURNING l_name
    #START REPORT r101_rep TO l_name
    #NO:FUN-740082 07/04/23 By TSD.Sideny ---end---
     LET g_pageno = 0

     IF tm.m1 = 1 THEN   #期初
        LET l_mm = 12
        LET l_yy = tm.yyyy - 1
     ELSE
        LET l_mm = tm.m1 - 1
        LET l_yy = tm.yyyy
     END IF

     FOREACH r101_curs1 INTO sr1.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
       #計算期初數量
       SELECT adr09 INTO l_adr09 FROM adr_file
        WHERE adr01 = sr1.adr01 AND adr02 = sr1.adr02 
          AND adr03 = sr1.adr03 
          AND adr04 = l_yy AND adr05 = l_mm
       IF cl_null(l_adr09) THEN LET l_adr09 = 0 END IF
       #計算期間
        SELECT COUNT(*) INTO l_i1 
          FROM adr_file
         WHERE adr01 = sr1.adr01 AND adr02 = sr1.adr02 
           AND adr03 = sr1.adr03 AND adr04 = tm.yyyy
           AND adr05 BETWEEN tm.m1 AND tm.m2
           AND (adr06 <> 0 OR adr07 <> 0 OR adr08 <> 0 OR adr09 <>0)
        IF cl_null(l_i1) THEN LET l_i1 = 0 END IF
             #期初為零且期間為零
        IF l_adr09=0 AND l_i1=0 THEN 
           IF tm.a = 'Y' THEN
              LET sr.adr01=sr1.adr01
              LET sr.adr02=sr1.adr02
              LET sr.adr03=sr1.adr03
              LET sr.adr04=0
              LET sr.adr05=0
              LET sr.last_adr09=0
             #NO:FUN-740082 07/04/23 By TSD.Sideny --start--
             #OUTPUT TO REPORT r101_rep(sr.*)

              LET sr.occ02 = NULL
              SELECT occ02 INTO sr.occ02 FROM occ_file
               WHERE occ01 = sr.adr01

              LET sr.cob02 = NULL
              SELECT cob02 INTO sr.cob02 FROM cob_file
               WHERE cob01 = sr.adr02

              LET sr.cob021 = NULL
              SELECT cob021 INTO sr.cob021 FROM cob_file
               WHERE cob01 = sr.adr02

              EXECUTE insert_prep USING sr.adr01,sr.occ02,sr.adr02,sr.cob02,
                                        sr.cob021,sr.adr03,sr.adr04,sr.adr05,
                                        sr.adr06,sr.adr07,sr.adr08,sr.adr09,
                                        sr.last_adr09,g_azi03,g_azi04,g_azi05

             #NO:FUN-740082 07/04/23 By TSD.Sideny ---end---
            ELSE
              CONTINUE FOREACH
            END IF
         ELSE
            #期初不為零或期間不為零
            FOR l_i = tm.m1 TO tm.m2
                 LET sr.adr01=sr1.adr01
                 LET sr.adr02=sr1.adr02
                 LET sr.adr03=sr1.adr03
                 LET sr.adr04=tm.yyyy
                 LET sr.adr05=l_i
                 LET sr.last_adr09 = l_adr09
                 SELECT adr06,adr07,adr08,adr09 
                   INTO sr.adr06,sr.adr07,sr.adr08,sr.adr09
                   FROM adr_file
                  WHERE adr01=sr.adr01 AND adr02=sr.adr02
                    AND adr03=sr.adr03 AND adr04=sr.adr04
                    AND adr05=sr.adr05
                 IF cl_null(sr.adr06) THEN LET sr.adr06=0 END IF 
                 IF cl_null(sr.adr07) THEN LET sr.adr07=0 END IF 
                 IF cl_null(sr.adr08) THEN LET sr.adr08=0 END IF 
                 IF cl_null(sr.adr09) THEN LET sr.adr09=0 END IF
                 IF sr.adr06 = 0 AND sr.adr07 = 0 AND
                    sr.adr08 = 0 AND sr.adr09 = 0 AND
                    tm.a = 'N' THEN
                       CONTINUE FOR
                 END IF
                #NO:FUN-740082 07/04/23 By TSD.Sideny --start--
                #OUTPUT TO REPORT r101_rep(sr.*)

                 LET sr.occ02 = NULL
                 SELECT occ02 INTO sr.occ02 FROM occ_file
                  WHERE occ01 = sr.adr01

                 LET sr.cob02 = NULL
                 SELECT cob02 INTO sr.cob02 FROM cob_file
                  WHERE cob01 = sr.adr02

                 LET sr.cob021 = NULL
                 SELECT cob021 INTO sr.cob021 FROM cob_file
                  WHERE cob01 = sr.adr02

                 EXECUTE insert_prep USING sr.adr01,sr.occ02,sr.adr02,sr.cob02,
                                           sr.cob021,sr.adr03,sr.adr04,sr.adr05,
                                           sr.adr06,sr.adr07,sr.adr08,sr.adr09,
                                           sr.last_adr09,g_azi03,g_azi04,g_azi05
                #NO:FUN-740082 07/04/23 By TSD.Sideny ---end---
            END FOR
          END IF
     END FOREACH

    #NO:FUN-740082 07/04/23 By TSD.Sideny --start--
    #FINISH REPORT r101_rep
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'adr01,adr02,adr03')
             RETURNING tm.wc
        LET g_str = tm.wc CLIPPED
     ELSE
        LET g_str = " "
     END IF
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
     LET g_str = g_str

     CALL cl_prt_cs3('axdr101','axdr101',g_sql,g_str)
    #NO:FUN-740082 07/04/23 By TSD.Sideny ---end---

     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
END FUNCTION

#NO:FUN-740082 07/04/23 By TSD.Sideny --start--
{
REPORT r101_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(1)
          sr           RECORD 
                        adr01      LIKE adr_file.adr01,  
                        occ02      LIKE occ_file.occ02,
                        adr02      LIKE adr_file.adr02,
                        cob02      LIKE cob_file.cob02,
                        cob021     LIKE cob_file.cob021,
                        adr03      LIKE adr_file.adr03,  
                        adr04      LIKE adr_file.adr04,  
                        adr05      LIKE adr_file.adr05,  
                        adr06      LIKE adr_file.adr06,  
                        adr07      LIKE adr_file.adr07,  
                        adr08      LIKE adr_file.adr08,  
                        adr09      LIKE adr_file.adr09,
                        last_adr09 LIKE adr_file.adr09
                       END RECORD

  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.adr01,sr.adr02,sr.adr03,sr.adr04,sr.adr05
  FORMAT
   PAGE HEADER
      PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            LET g_pageno = g_pageno + 1                                         
            LET pageno_total = PAGENO USING '<<<',"/pageno"                     
            PRINT g_head CLIPPED,pageno_total            

      PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT ' '
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],
            g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41] 
      PRINT g_dash1
      LET l_last_sw = 'n'
 #MOD-4B0067(BEGIN)---By Day   
#  BEFORE GROUP OF sr.adr01 
#     PRINT COLUMN 01,sr.adr01;

#  BEFORE GROUP OF sr.adr02
#     PRINT COLUMN 10,sr.adr02;  

   BEFORE GROUP OF sr.adr03

      SELECT occ02 INTO sr.occ02 FROM occ_file
       WHERE occ01 = sr.adr01

      SELECT cob02 INTO sr.cob02 FROM cob_file
       WHERE cob01 = sr.adr02

      SELECT cob021 INTO sr.cob021 FROM cob_file
       WHERE cob01 = sr.adr02

         PRINT COLUMN g_c[31],sr.adr01 CLIPPED,  #TQC-6A0095
                COLUMN g_c[32],sr.occ02 CLIPPED,   #No.MOD-4B0267  #TQC-6A0095
                COLUMN g_c[33],sr.adr02 CLIPPED,      #No.MOD-4B0267  #TQC-6A0095
                COLUMN g_c[34],sr.cob02 CLIPPED,    #No.MOD-4B0267   #TQC-6A0095
                COLUMN g_c[35],sr.cob021 CLIPPED,         #No.MOD-4B0267 #TQC-6A0095
                COLUMN g_c[36],sr.adr03 CLIPPED,              #No.MOD-4B0267  #TQC-6A0095
                COLUMN g_c[37],g_x[09] CLIPPED,                      #No.MOD-4B0267
                COLUMN g_c[38],sr.last_adr09 USING '----------&.&&&'  #No.MOD-4B0267

   ON EVERY ROW
      IF sr.adr05 <> 0 THEN
      SELECT occ02 INTO sr.occ02 FROM occ_file
       WHERE occ01 = sr.adr01

      SELECT cob02 INTO sr.cob02 FROM cob_file
       WHERE cob01 = sr.adr02

      SELECT cob021 INTO sr.cob021 FROM cob_file
       WHERE cob01 = sr.adr02

         PRINT COLUMN g_c[31],sr.adr01 CLIPPED,                      #TQC-6A0095
                COLUMN g_c[32],sr.occ02 CLIPPED,     #No.MOD-4B0267  #TQC-6A0095
                COLUMN g_c[33],sr.adr02 CLIPPED,    #No.MOD-4B0267   #TQC-6A0095
                COLUMN g_c[34],sr.cob02 CLIPPED,     #No.MOD-4B0267  #TQC-6A0095
                COLUMN g_c[35],sr.cob021 CLIPPED,    #No.MOD-4B0267  #TQC-6A0095
                COLUMN g_c[36],sr.adr03 CLIPPED,     #No.MOD-4B0267  #TQC-6A0095
                COLUMN g_c[37],cl_numfor(sr.adr05,5,0),# USING '<<<',             #No.MOD-4B0267   #TQC-6A0095
                COLUMN g_c[38],sr.adr06 USING '----------&.&&&',  #No.MOD-4B0267
                COLUMN g_c[39],sr.adr07 USING '----------&.&&&',  #No.MOD-4B0267
                COLUMN g_c[40],sr.adr08 USING '----------&.&&&',  #No.MOD-4B0267
                COLUMN g_c[41],sr.adr09 USING '----------&.&&&'   #No.MOD-4B0267
      END IF
   
   AFTER GROUP OF sr.adr03
      IF sr.adr05 <> 0 THEN
         PRINT COLUMN  g_c[37],g_dash2[1,g_w[37]],
               COLUMN  g_c[38],g_dash2[1,g_w[38]],
               COLUMN  g_c[39],g_dash2[1,g_w[39]],
               COLUMN  g_c[39],g_dash2[1,g_w[39]]
          PRINTX name=S1 COLUMN g_c[37],g_x[10] CLIPPED,                           #No.MOD-4B0267
                COLUMN g_c[38],GROUP SUM(sr.adr06) USING '----------&.&&&',#No.MOD-4B0267
                COLUMN g_c[39],GROUP SUM(sr.adr07) USING '----------&.&&&',#No.MOD-4B0267
                COLUMN g_c[40],GROUP SUM(sr.adr08) USING '----------&.&&&' #No.MOD-4B0267
      END IF
      PRINT 
 #MOD-4B0067(END)
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
}
#NO:FUN-740082 07/04/23 By TSD.Sideny ---end---
