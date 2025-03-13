# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axrg304.4gl
# Descriptions...: 電子發票副本列印
# Date & Author..: 13/01/23 by Lori(FUN-C90104)

DATABASE ds
GLOBALS "../../config/top.global"

DEFINE tm        RECORD
                     ome01 LIKE ome_file.ome01
                 END RECORD
DEFINE g_sql     STRING
DEFINE l_table   STRING,      #出貨明細
       l_table1  STRING,      #折扣明細
       l_table2  STRING       #款別明細
DEFINE g_ome01   LIKE ome_file.ome01

TYPE sr1_t   RECORD
             ome01   LIKE  ome_file.ome01,
             ome02   LIKE  ome_file.ome02,
             ome82   LIKE  ome_file.ome82,
             ome59t  LIKE  ome_file.ome59t,
             ome26   LIKE  ome_file.ome26,
             zo06    LIKE  zo_file.zo06,
             ome171  LIKE  ome_file.ome171,
             zo12    LIKE  zo_file.zo12,
             zo041   LIKE  zo_file.zo041,
             ome73   LIKE  ome_file.ome73,
             azp02   LIKE  azp_file.azp02,
             ome71   LIKE  ome_file.ome71,
             ome72   LIKE  ome_file.ome72,
             ome042  LIKE  ome_file.ome042,
             ogb04   LIKE  ogb_file.ogb04,
             ogb06   LIKE  ogb_file.ogb06,
             ogb12   LIKE  ogb_file.ogb12,
             ogb13   LIKE  ogb_file.ogb13,
             ogb14t  LIKE  ogb_file.ogb14t,
             ome59   LIKE  ome_file.ome59,
             ome59x  LIKE  ome_file.ome59x,
             ogi05   LIKE  ogi_file.ogi05,
             oga01   LIKE  oga_file.oga01,
             ogaplant LIKE oga_file.ogaplant,
             ogb03   LIKE  ogb_file.ogb03
             END RECORD

TYPE sr2_t   RECORD
             rxc00   LIKE  rxc_file.rxc00, 
             rxc01   LIKE  rxc_file.rxc01, 
             rxc02   LIKE  rxc_file.rxc02, 
             rxc03   LIKE  rxc_file.rxc03,
             rxc04   LIKE  rxc_file.rxc04, 
             rxc06   LIKE  rxc_file.rxc06, 
             raa03   LIKE  raa_file.raa03
             END RECORD
TYPE sr3_t   RECORD
             rxy01   LIKE  rxy_file.rxy01,
             ryx05   LIKE  ryx_file.ryx05,      #款別名稱
             rxy05   LIKE  rxy_file.rxy05
             END RECORD

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

   LET g_ome01 = ARG_VAL(1)

   LET g_sql = "ome01.ome_file.ome01,ome02.ome_file.ome02,ome82.ome_file.ome82,ome59t.ome_file.ome59t,ome26.ome_file.ome26,",
               "zo06.zo_file.zo06,ome171.ome_file.ome171,zo12.zo_file.zo12,zo041.zo_file.zo041,ome73.ome_file.ome73,",
               "azp02.azp_file.azp02,ome71.ome_file.ome71,ome72.ome_file.ome72,ome042.ome_file.ome042,ogb04.ogb_file.ogb04,",
               "ogb06.ogb_file.ogb06,ogb12.ogb_file.ogb12,ogb13.ogb_file.ogb13,ogb14t.ogb_file.ogb14t,",
               "ome59.ome_file.ome59,ome59x.ome_file.ome59x,ogi05.ogi_file.ogi05,oga01.oga_file.oga01,ogaplant.oga_file.ogaplant,",
               "ogb03.ogb_file.ogb03"
   LET l_table = cl_prt_temptable('axrg304',g_sql) CLIPPED
   IF l_table = -1 THEN
      EXIT PROGRAM
   END IF
   DISPLAY "l_table :",l_table

   LET g_sql = "rxc00.rxc_file.rxc00,rxc01.rxc_file.rxc01,rxc02.rxc_file.rxc02,rxc03.rxc_file.rxc03,rxc04.rxc_file.rxc04,",
               "rxc06.rxc_file.rxc06,raa03.raa_file.raa03"
   LET l_table1 = cl_prt_temptable('axrg3041',g_sql) CLIPPED
   IF l_table1 = -1 THEN
      EXIT PROGRAM
   END IF
   DISPLAY "l_table1:",l_table1

   LET g_sql = "rxy01.rxy_file.rxy01,ryx05.ryx_file.ryx05,rxy05.rxy_file.rxy05"
   LET l_table2 = cl_prt_temptable('axrg3042',g_sql) CLIPPED
   IF l_table2 = -1 THEN
      EXIT PROGRAM
   END IF
   DISPLAY "l_table2:",l_table2


   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   INITIALIZE tm.* TO NULL
   IF cl_null(tm.ome01) THEN
      CALL axrg304_tm(0,0)
   END IF
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION axrg304_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
   DEFINE l_cnt          LIKE type_file.num5
   DEFINE l_ome00        LIKE ome_file.ome00,
          l_ome22        LIKE ome_file.ome22,
          l_omevoid      LIKE ome_file.omevoid,
          l_omecncl      LIKE ome_file.omecncl

   IF p_row = 0 THEN LET p_row = 3 LET p_col = 12 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 5 LET p_col = 18
   ELSE
       LET p_row = 3 LET p_col = 12
   END IF

   OPEN WINDOW axtrw AT p_row,p_col
        WITH FORM "axr/42f/axrg304"

    ATTRIBUTE (STYLE = g_win_style CLIPPED)

    CALL cl_ui_init()

    CALL cl_opmsg('p')

    INITIALIZE tm.* TO NULL            # Default condition
    LET g_pdate  = g_today
    LET g_rlang  = g_lang
    LET g_copies = '1'
    LET l_cnt    = NULL

    WHILE TRUE
       INPUT BY NAME tm.ome01 ATTRIBUTES(WITHOUT DEFAULTS)
          BEFORE INPUT
             IF NOT cl_null(g_ome01) THEN
                LET tm.ome01 = g_ome01
                DISPLAY BY NAME tm.ome01
             END IF

          AFTER FIELD ome01
             SELECT COUNT(*) INTO l_cnt FROM ome_file WHERE ome01 = tm.ome01
             IF cl_null(l_cnt) OR l_cnt = 0 THEN
                CALL cl_err('','axr1001',1)
                NEXT FIELD ome01
             END IF

             SELECT ome00,ome22,omevoid,omecncl 
               INTO l_ome00,l_ome22,l_omevoid,l_omecncl
               FROM ome_file 
              WHERE ome01 = tm.ome01
             IF l_ome00 = '4' THEN
                CALL cl_err('','axr1002',1)
                NEXT FIELD ome01
             END IF
             IF l_ome22 = 'N' THEN
                CALL cl_err('','axr1003',1)
                NEXT FIELD ome01
             END IF
             IF l_omevoid = 'Y' THEN
                CALL cl_err('','axr1004',1)
                NEXT FIELD ome01
             END IF
             IF l_omecncl = 'Y' THEN
                CALL cl_err('','axr1005',1)
                NEXT FIELD ome01
             END IF

          ON ACTION close
             LET INT_FLAG = 1
             EXIT INPUT

       END INPUT
       IF INT_FLAG THEN
          LET INT_FLAG = 0 CLOSE WINDOW axrg304_w 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time
          CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
          EXIT PROGRAM
       END IF

       CALL axrg304()
       ERROR ""
    END WHILE

    CLOSE WINDOW axrg304_w
END FUNCTION

FUNCTION axrg304()
   DEFINE sr RECORD
               ome01   LIKE  ome_file.ome01,
               ome02   LIKE  ome_file.ome02,
               ome82   LIKE  ome_file.ome82,
               ome59t  LIKE  ome_file.ome59t,
               ome26   LIKE  ome_file.ome26,
               ome171  LIKE  ome_file.ome171,
               ome73   LIKE  ome_file.ome73,
               azp02   LIKE  azp_file.azp02,
               ome71   LIKE  ome_file.ome71,
               ome72   LIKE  ome_file.ome72,
               ome042  LIKE  ome_file.ome042,
               ogb04   LIKE  ogb_file.ogb04,
               ogb06   LIKE  ogb_file.ogb06,
               ogb12   LIKE  ogb_file.ogb12,
               ogb13   LIKE  ogb_file.ogb13,
               ogb14t  LIKE  ogb_file.ogb14t,
               ome59   LIKE  ome_file.ome59,
               ome59x  LIKE  ome_file.ome59x,
               ogi05   LIKE  ogi_file.ogi05,
               oga01   LIKE  oga_file.oga01,
               ogaplant LIKE oga_file.ogaplant,
               ogb03   LIKE  ogb_file.ogb03
             END RECORD
   DEFINE sr1 sr2_t
   DEFINE sr2 sr3_t
   DEFINE l_zo06      LIKE zo_file.zo06,
          l_zo12      LIKE zo_file.zo12,
          l_zo041     LIKE zo_file.zo041
   DEFINE l_sql       STRING

   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)

   SELECT zo06,zo12,zo041 INTO l_zo06,l_zo12,l_zo041 FROM zo_file WHERE zo01 = g_rlang
   LET g_company = l_zo06

   DISPLAY "l_table :",l_table
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?,",
               "        ?, ?, ?, ?, ?,",
               "        ?, ?, ?, ?, ?,",
               "        ?, ?, ?, ?, ?,",
               "        ?, ?, ?, ?, ?)"

   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
      EXIT PROGRAM
   END IF
  
   LET l_sql = "SELECT ome01 ,ome02,ome82 ,ome59t,ome26,",
               "       ome171,ome73,azp02 ,ome71 ,ome72,",
               "       ome042,ogb04,ogb06 ,ogb12 ,ogb13,",
               "       ogb14t,ome59,ome59x,ogi05 ,oga01,",
               "       ogaplant,ogb03",
               "  FROM ogi_file,ogb_file,oga_file,ome_file,azp_file ",
               " WHERE ogi01 = ogb01 ",
               "   AND ogi02 = ogb03 ",
               "   AND ogb01 = oga01 ",
               "   AND oga98 = ome72 ",
               "   AND ogaplant = ome73 ",
               "   AND ome73 = azp01 ",
               "   AND ome00 = '1' ",
               "   AND ome01 = '",tm.ome01,"' ",
               "   AND ome22 = 'Y' ",
               "   AND omevoid = 'N' ",
               "   AND omecncl = 'N' "
   PREPARE g304_pre1 FROM l_sql
   DECLARE g304_curs1 CURSOR FOR g304_pre1
   FOREACH g304_curs1 INTO sr.*
      DISPLAY "(Before Insert)sr.ome01: ",sr.ome01," ogb04: ",sr.ogb04,"   ,sr.ome71: ",sr.ome71
      EXECUTE insert_prep USING sr.ome01,sr.ome02 ,sr.ome82,sr.ome59t,sr.ome26,
                                l_zo06  ,sr.ome171,l_zo12  ,l_zo041  ,sr.ome73,
                                sr.azp02,sr.ome71 ,sr.ome72,sr.ome042,sr.ogb04,
                                sr.ogb06,sr.ogb12 ,sr.ogb13,sr.ogb14t,
                                sr.ome59,sr.ome59x,sr.ogi05,sr.oga01 ,sr.ogaplant,
                                sr.ogb03
      IF STATUS THEN
         CALL cl_err('insert_prep:',status,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
         EXIT PROGRAM
      END IF
   END FOREACH

   DISPLAY "l_table1:",l_table1
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?, ?, ?, ?, ?,",
               "        ?, ?)"

   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
      EXIT PROGRAM
   END IF

   #一般促銷
   LET l_sql = " SELECT rxc00,rxc01,rxc02,rxc03,rxc04,rxc06,raa03",
               "   FROM rxc_file,",g_cr_db_str CLIPPED,l_table,",rab_file,raa_file",
               "  WHERE rxc01 = oga01 ",
               "    AND rxc02 = ogb03 ",
               "    AND rxc04 = rab02 ",
               "    AND rabplant = ogaplant ",
               "    AND rab03 = raa02 ",
               "    AND rxc00 = '02' ",
               "    AND rxc03 = '01' "
   PREPARE ins_temp_01 FROM l_sql
   EXECUTE ins_temp_01
   PREPARE g304_pre2 FROM l_sql
   DECLARE g304_curs2 CURSOR FOR g304_pre2
   FOREACH g304_curs2 INTO sr1.*
      EXECUTE insert_prep1 USING sr1.rxc00,sr1.rxc01,sr1.rxc02,sr1.rxc03,sr1.rxc04,sr1.rxc06,sr1.raa03
   END FOREACH

   #組合促銷
   LET l_sql = " SELECT rxc00,rxc01,rxc02,rxc03,rxc04,rxc06,raa03",
               "   FROM rxc_file,",g_cr_db_str CLIPPED,l_table,",rae_file,raa_file",
               "  WHERE rxc01 = oga01 ",
               "    AND rxc02 = ogb03 ",
               "    AND rxc04 = rae02 ",
               "    AND raeplant = ogaplant ",
               "    AND rae03 = raa02 ",
               "    AND rxc00 = '02' ",
               "    AND rxc03 = '01' "
   PREPARE ins_temp_02 FROM l_sql
   EXECUTE ins_temp_02
   PREPARE g304_pre3 FROM l_sql
   DECLARE g304_curs3 CURSOR FOR g304_pre3
   FOREACH g304_curs3 INTO sr1.*
      EXECUTE insert_prep1 USING sr1.rxc00,sr1.rxc01,sr1.rxc02,sr1.rxc03,sr1.rxc04,sr1.rxc06,sr1.raa03
   END FOREACH

   #滿額促銷
   LET l_sql = " SELECT rxc00,rxc01,rxc02,rxc03,rxc04,rxc06,raa03",
               "   FROM rxc_file,",g_cr_db_str CLIPPED,l_table,",rah_file,raa_file",
               "  WHERE rxc01 = oga01 ",
               "    AND rxc02 = ogb03 ",
               "    AND rxc04 = rah02 ",
               "    AND rahplant = ogaplant ",
               "    AND rah03 = raa02 ",
               "    AND rxc00 = '02' ",
               "    AND rxc03 = '01' "
   PREPARE ins_temp_03 FROM l_sql
   EXECUTE ins_temp_03
   PREPARE g304_pre4 FROM l_sql
   DECLARE g304_curs4 CURSOR FOR g304_pre4
   FOREACH g304_curs4 INTO sr1.*
      EXECUTE insert_prep1 USING sr1.rxc00,sr1.rxc01,sr1.rxc02,sr1.rxc03,sr1.rxc04,sr1.rxc06,sr1.raa03
   END FOREACH

   #其他促銷
   LET l_sql = " SELECT rxc00,rxc01,rxc02,rxc03,rxc04,rxc06,raa03",
               "   FROM rxc_file,",g_cr_db_str CLIPPED,l_table,",rab_file,raa_file",
               "  WHERE rxc01 = oga01 ",
               "    AND rxc02 = ogb03 ",
               "    AND rxc04 = rab02 ",
               "    AND rabplant = ogbplant ",
               "    AND rab03 = raa02 ",
               "    AND rxc00 = '02' ",
               "    AND rxc03 = '01' "
   PREPARE ins_temp_04 FROM l_sql
   EXECUTE ins_temp_04
   PREPARE g304_pre5 FROM l_sql
   DECLARE g304_curs5 CURSOR FOR g304_pre5
   FOREACH g304_curs5 INTO sr1.*
      EXECUTE insert_prep1 USING sr1.rxc00,sr1.rxc01,sr1.rxc02,sr1.rxc03,sr1.rxc04,sr1.rxc06,sr1.raa03
   END FOREACH

   DISPLAY "l_table2:",l_table2
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?, ?, ?)"

   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
      EXIT PROGRAM
   END IF

   LET l_sql = " SELECT rxy01,ryx05,SUM(rxy05) ",
               " FROM rxy_file,",g_cr_db_str CLIPPED,l_table,",ryd_file,ryx_file ",
               "  WHERE rxy01 = oga01 ",
               "    AND rxy03 = ryd01 ",
               "    AND ryd06 = ryx03 ",
               "    AND ryx01 = 'ryq_file' ",
               "    AND ryx02 = 'ryq01' ",
               "    AND ryx04 = '",g_lang,"' ",
               "  GROUP BY rxy01,ryx05 "
   PREPARE ins_temp_05 FROM l_sql
   EXECUTE ins_temp_05
   PREPARE g304_pre6 FROM l_sql
   DECLARE g304_curs6 CURSOR FOR g304_pre6
   FOREACH g304_curs6 INTO sr2.*
      EXECUTE insert_prep2 USING sr2.rxy01,sr2.ryx05,sr2.rxy05
   END FOREACH
   
   LET g_cr_table = l_table
   LET g_cr_apr_key_f = "ome01"
   CALL g304_grdata()
END FUNCTION

FUNCTION g304_grdata()
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE sr1      sr1_t
   DEFINE l_cnt    LIKE type_file.num10
   DEFINE l_msg    STRING

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN RETURN END IF

   WHILE TRUE
       CALL cl_gre_init_pageheader()
       LET handler = cl_gre_outnam("axrg304")
       IF handler IS NOT NULL THEN
           START REPORT axrg304_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED 
           DECLARE axrg304_datacur1 CURSOR FROM l_sql
           FOREACH axrg304_datacur1 INTO sr1.*
               DISPLAY "sr1.ome01: ",sr1.ome01,"   sr1.obg04: ",sr1.ogb04,"   ,sr1.ome71: ",sr1.ome71
               OUTPUT TO REPORT axrg304_rep(sr1.*)
           END FOREACH
           FINISH REPORT axrg304_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT axrg304_rep(sr1)
   DEFINE sr1             sr1_t
   DEFINE sr2             sr2_t
   DEFINE sr3             sr3_t
   DEFINE l_lineno        LIKE type_file.num5
   DEFINE l_title_y       STRING
   DEFINE l_title_m       STRING
   DEFINE l_total_amt     LIKE lpu_file.lpu04
   DEFINE l_rtz13         LIKE rtz_file.rtz13
   DEFINE l_ome02_fmt     STRING
   DEFINE l_ome02_mon     STRING
   DEFINE l_sum_price     STRING
   DEFINE l_ogb04_cnt     LIKE type_file.num5
   DEFINE l_tax_flag      LIKE type_file.chr5
   DEFINE l_sql           STRING
   DEFINE l_ome73_name    STRING
   DEFINE l_ogb12         LIKE type_file.num20
   DEFINE l_ogb13         LIKE type_file.num20
   DEFINE l_ome042_show LIKE type_file.chr1
   DEFINE l_coin_show   LIKE type_file.chr1
   DEFINE l_max_cnt     LIKE type_file.num5
   DEFINE l_cnt         LIKE type_file.num5

   ORDER EXTERNAL BY sr1.ome01

   FORMAT
      FIRST PAGE HEADER
          PRINTX g_grPageHeader.*
          PRINTX g_user,g_pdate,g_prog,g_company

      BEFORE GROUP OF sr1.ome01
         LET l_ogb04_cnt = 0
         LET l_ome042_show = 'N'
         LET l_coin_show = 'N'
         LET l_max_cnt = 0
         LET l_cnt = 0

         LET l_title_y = YEAR(sr1.ome02)-1911
         PRINTX l_title_y

         LET l_ome02_fmt = sr1.ome02 USING "yyyy-mm-yy"
         PRINTX l_ome02_fmt

         LET l_ome02_mon = l_ome02_fmt.subString(6,7)

         CASE 
            WHEN l_ome02_mon = '01' OR l_ome02_mon = '02'
               LET l_title_m = '01-02'
            WHEN l_ome02_mon = '03' OR l_ome02_mon = '04'
               LET l_title_m = '03-04'
            WHEN l_ome02_mon = '05' OR l_ome02_mon = '06'
               LET l_title_m = '05-06'
            WHEN l_ome02_mon = '07' OR l_ome02_mon = '08'
               LET l_title_m = '07-08'
            WHEN l_ome02_mon = '09' OR l_ome02_mon = '10'
               LET l_title_m = '09-10'
            WHEN l_ome02_mon = '11' OR l_ome02_mon = '12' 
               LET l_title_m = '11-12'
           OTHERWISE
               LET l_title_m = NULL
         END CASE
         PRINTX l_title_m

      ON EVERY ROW
         PRINTX sr1.*

         LET l_ogb12 = s_trunc(sr1.ogb12,0)
         LET l_ogb13 = s_trunc(sr1.ogb13,0)
         IF sr1.ogb12 > 1 THEN
            LET l_sum_price = l_ogb13,'*',l_ogb12
         ELSE
            LET l_sum_price = l_ogb13
         END IF
         PRINTX l_sum_price

         IF sr1.ogi05 > 0 THEN
            LET l_tax_flag = 'TX'
         ELSE
            LET l_tax_flag = NULL
         END IF
         PRINTX l_tax_flag

         LET l_ome73_name = sr1.ome73,' ',sr1.azp02
         PRINTX l_ome73_name

         IF cl_null(sr1.ome042) OR sr1.ome042 = ' ' THEN
            LET l_ome042_show = 'Y'
         ELSE
            LET l_ome042_show = 'N'
         END IF
         PRINTX l_ome042_show

         LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                     " WHERE rxc01 = '",sr1.oga01 CLIPPED,"'",
                     "   AND rxc02 = '",sr1.ogb03 CLIPPED,"'",
                     "   AND rxc00 = '02'"
         START REPORT axrg304_subrep01
         DECLARE axrg304_repcur1 CURSOR FROM l_sql
         FOREACH axrg304_repcur1 INTO sr2.*
             DISPLAY "   rxc01: ",sr2.rxc01,",rxc03: ",sr2.rxc03
             OUTPUT TO REPORT axrg304_subrep01(sr2.*)
         END FOREACH
         FINISH REPORT axrg304_subrep01

      AFTER GROUP OF sr1.ome01 
         LET l_ogb04_cnt = GROUP COUNT(*)
         PRINTX l_ogb04_cnt

         LET l_sql = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED
         DECLARE axrg304_cnt CURSOR FROM l_sql
         EXECUTE axrg304_cnt INTO l_max_cnt

         LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                     " WHERE rxy01 = '",sr1.oga01 CLIPPED,"'",
                     " ORDER BY ryx05"
         START REPORT axrg304_subrep02
         DECLARE axrg304_repcur2 CURSOR FROM l_sql
         FOREACH axrg304_repcur2 INTO sr3.*
             LET l_cnt = l_cnt + 1
             IF l_cnt = l_max_cnt THEN
                LET l_coin_show = 'Y'
             ELSE
                LET l_coin_show = 'N'
             END IF
             DISPLAY "   rxy01: ",sr3.rxy01,",ryx05: ",sr3.ryx05
             OUTPUT TO REPORT axrg304_subrep02(sr3.*,l_coin_show)
         END FOREACH
         FINISH REPORT axrg304_subrep02
END REPORT

REPORT axrg304_subrep01(sr2)
   DEFINE sr2 sr2_t

   FORMAT
       ON EVERY ROW
           PRINTX sr2.*

END REPORT

REPORT axrg304_subrep02(sr3,p_coin_show)
   DEFINE sr3 sr3_t 
   DEFINE p_coin_show   LIKE type_file.chr1          
   DEFINE l_coin        LIKE type_file.num5

   FORMAT
       ON EVERY ROW
           PRINTX sr3.*
           PRINTX p_coin_show

           LET l_coin = 0
           PRINTX l_coin
       
END REPORT
#FUN-C90104
