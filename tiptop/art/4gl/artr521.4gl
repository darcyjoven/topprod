# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: artr521.4gl
# Descriptions...: 營運中心銷貨折價統計表
# Date & Author..: No.FUN-B70068 11/07/19 By yangxf
# Modify.........: No:TQC-B70204 11/07/28 By yangxf UNION 改成UNION ALL
# Modify.........: No.FUN-BC0026 12/01/30 By Pauline列印前是否有參考p_zz中的設定列印條件選項 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE    tm       RECORD
          wc            LIKE type_file.chr1000,
          dis           LIKE type_file.chr1,
          more          LIKE type_file.chr1
                   END RECORD
DEFINE    g_wc          STRING,
          g_str         STRING,
          g_sql         STRING,
          l_table       STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_sql  = "operating.azw_file.azw01,",
                "opname.azw_file.azw08,",
                "l_count.type_file.num20,",
                "l_sum.type_file.num20,",
                "rxc03.rxc_file.rxc03,",
                "l_rxccount.type_file.num20,",
                "l_rxcsum.type_file.num20"
   LET l_table = cl_prt_temptable('artr521',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?)"
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   CALL r521_tm(0,0)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION r521_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
DEFINE p_row,p_col    LIKE type_file.num5,
       l_cmd          LIKE type_file.chr1000,
       l_str          STRING
       
   IF p_row = 0 THEN LET p_row = 6 LET p_col = 14 END IF
   OPEN WINDOW r521_w AT p_row,p_col WITH FORM "art/42f/artr521"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET tm.dis ='N'
   WHILE TRUE
      DISPLAY BY NAME tm.more,tm.dis 
      CONSTRUCT tm.wc ON azw01,rtz10,oga02,ima131
         FROM operating,city,oga02,categories
           
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
              
         ON ACTION controlp
            CASE
               WHEN INFIELD(operating)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_azw"
                  LET g_qryparam.where = " azw01 IN ",g_auth
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO operating
                  NEXT FIELD operating
               WHEN INFIELD(city)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_ryf"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO city
                  NEXT FIELD city
               WHEN INFIELD(categories)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_oba_13"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO categories
                  NEXT FIELD categories   
            END CASE

         ON ACTION locale
            CALL cl_show_fld_cont()
            CALL cl_dynamic_locale()
            CONTINUE WHILE
         ON ACTION help
            CALL cl_show_help()   
            CONTINUE WHILE   
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE WHILE

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION close
            LET INT_FLAG = 1
            EXIT CONSTRUCT
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
      END CONSTRUCT

      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW r521_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM 
      END IF
      
      IF tm.wc= " 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF

      INPUT BY NAME tm.dis ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         ON ACTION locale
            CALL cl_show_fld_cont()
            CALL cl_dynamic_locale()
            CONTINUE WHILE
         ON ACTION help
            CALL cl_show_help()   
            CONTINUE WHILE         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE WHILE
         ON ACTION controlg
            CALL cl_cmdask()

 
         ON ACTION close
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
      END INPUT
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW r521_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM 
      END IF
      
      INPUT BY NAME tm.more ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
         
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF

         ON ACTION locale
            CALL cl_show_fld_cont()
            CALL cl_dynamic_locale()
            CONTINUE WHILE
         ON ACTION help
            CALL cl_show_help()   
            CONTINUE WHILE         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE WHILE
         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION close
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW r521_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM 
      END IF
      CALL cl_wait()
      CALL artr521()
      ERROR ""
   END WHILE
   CLOSE WINDOW r521_w
END FUNCTION
 
FUNCTION artr521()
   DEFINE l_str          STRING,
          l_sql          STRING
   DEFINE l_azi04        LIKE azi_file.azi04
   DEFINE sr          RECORD
      operating          LIKE azw_file.azw01,
      opname             LIKE azw_file.azw08,
      l_count            LIKE type_file.num20,
      l_sum              LIKE type_file.num20, 
      rxc03              LIKE rxc_file.rxc03,
      l_rxccount         LIKE type_file.num20,
      l_rxcsum           LIKE type_file.num20
                      END RECORD
   DEFINE sr1         RECORD
      azw01              LIKE azw_file.azw01,
      azw08              LIKE azw_file.azw08,
      rtz10              LIKE rtz_file.rtz10
                      END RECORD
 
     CALL cl_del_data(l_table)
     LET l_sql = "SELECT DISTINCT azw01,azw08,rtz10 FROM azw_file,rtz_file ",
                " WHERE azw01 = rtz01  ",
                " AND azw01 IN ",g_auth,
                " ORDER BY azw01 "
     PREPARE r521_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE r521_cs1 CURSOR FOR r521_prepare1
     FOREACH r521_cs1 INTO sr1.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET tm.wc = cl_replace_str(tm.wc,"oha02","oga02")
       LET l_sql = 
          " SELECT  '','','','',rxc03,COUNT(rxc03),SUM(rxc06) ",
          "   FROM ",cl_get_target_table(sr1.azw01,'oga_file'),",",
                     cl_get_target_table(sr1.azw01,'ogb_file'),",",
                     cl_get_target_table(sr1.azw01,'azw_file'),",",
                     cl_get_target_table(sr1.azw01,'rtz_file'),",",
                     cl_get_target_table(sr1.azw01,'rxc_file'),",",
                     cl_get_target_table(sr1.azw01,'ima_file'),
          "  WHERE oga09 IN ('2','3','4','6')",  
          "    AND oga01 = rxc01 ",
          "    AND ogb03 = rxc02",
          "    AND rxc00 = '02' ",
          "    AND oga01 = ogb01 ",
          "    AND ogapost = 'Y' ", 
          "    AND rxcplant = azw01 ",
          "    AND ogb04 = ima01 ",
          "    AND rxcplant ='",sr1.azw01,"'",
          "    AND azw01 IN ",g_auth,
          "    AND rtz01 = azw01 ",
          "    AND ",tm.wc,
          "    GROUP BY rxc03 "
       LET tm.wc = cl_replace_str(tm.wc,"oga02","oha02")       
       LET l_sql = l_sql,
#         "   UNION SELECT '','','','',rxc03,COUNT(rxc03),SUM(rxc06)*(-1) ",   #TQC-B70204 mark
          "   UNION ALL SELECT '','','','',rxc03,COUNT(rxc03),SUM(rxc06)*(-1) ",   #TQC-B70204
          "   FROM ",cl_get_target_table(sr1.azw01,'oha_file'),",",
                     cl_get_target_table(sr1.azw01,'ohb_file'),",",   
                     cl_get_target_table(sr1.azw01,'azw_file'),",",
                     cl_get_target_table(sr1.azw01,'rtz_file'),",",
                     cl_get_target_table(sr1.azw01,'rxc_file'),",",
                     cl_get_target_table(sr1.azw01,'ima_file'),
          "  WHERE oha05 IN ('1','2')",
          "    AND ohb03 = rxc02",
          "    AND rxc01 = oha01",
          "    AND rxc00 = '03' ",
          "    AND oha01 = ohb01",
          "    AND ohapost = 'Y' ",
          "    AND rxcplant = azw01 ",
          "    AND ima01 = ohb04 ",
          "    AND rxcplant = '",sr1.azw01,"'",
          "    AND azw01 IN ",g_auth,
          "    AND rtz01 = azw01 ",
          "    AND ",tm.wc,
          "    GROUP BY rxc03 "
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       PREPARE sel_pre FROM l_sql
       DECLARE sel_cs CURSOR FOR sel_pre
       FOREACH sel_cs INTO sr.*    
          LET sr.operating = sr1.azw01 
          LET sr.opname = sr1.azw08
          EXECUTE insert_prep USING sr.*
          INITIALIZE sr.* TO NULL
       END FOREACH
       LET l_sql = "SELECT SUM(l_rxccount),SUM(l_rxcsum) FROM ds_report.",l_table CLIPPED,
                   " WHERE operating = '",sr1.azw01,"'"
       PREPARE sel_pre_1 FROM l_sql
       EXECUTE sel_pre_1 INTO sr.l_count,sr.l_sum 
       LET l_sql = "UPDATE ds_report.",l_table CLIPPED,
                   " SET l_count = '",sr.l_count,"',",
                   " l_sum = '",sr.l_sum,"'",
                   " WHERE operating = '",sr1.azw01,"'" 
       PREPARE upd_pre FROM l_sql
       EXECUTE upd_pre
       INITIALIZE sr1.* TO NULL
     END FOREACH
 
     LET l_sql = "SELECT operating,opname,l_count,l_sum,rxc03,sum(l_rxccount) l_rxccount,sum(l_rxcsum) l_rxcsum ",
                 "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " GROUP BY operating,opname,l_count,l_sum,rxc03 ",
                 " ORDER BY operating,rxc03 "
     SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = g_aza.aza17
     LET g_str = ''
    #LET g_str = tm.wc,";",l_azi04,";"  #FUN-BC0026 mark
  #FUN-BC0026 add START
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'azw01,rtz10,oga02,ima131')
       RETURNING tm.wc
       LET g_str =tm.wc
       IF g_str.getLength() > 1000 THEN
          LET g_str = g_str.subString(1,600)
          LET g_str = g_str,"..."
       END IF
    END IF
    LET g_str = g_str,";",l_azi04,";"
  #FUN-BC0026 add END
     CASE
       WHEN tm.dis='Y'
           CALL cl_prt_cs3('artr521','artr521_1',l_sql,g_str)
       WHEN tm.dis='N'
           CALL cl_prt_cs3('artr521','artr521_2',l_sql,g_str)
    END CASE
END FUNCTION

#FUN-B70068
