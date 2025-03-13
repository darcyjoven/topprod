# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: artg142.4gl
# Descriptions...: 營運中心人員銷售預測目標與實際比較表
# Date & Author..: No.FUN-B50069 11/05/20 by baogc
# Modify.........: No:FUN-B60146 11/06/28 By yangxf 加入選項判別實績抓取來源
# Modify.........: No:FUN-B70100 11/07/25 By baogc 取實際銷售金額時，應扣除銷退部份的金額
# Modify.........: No.FUN-BC0026 12/01/30 By Pauline列印前是否有參考p_zz中的設定列印條件選項 
# Modify.........: No.FUN-C40071 12/04/25 By xjll CR轉GR
# Modify.........: No.FUN-C80043 12/08/24 By yangxf 修改中间库表

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE    tm       RECORD
          wc            LIKE type_file.chr1000,
          saleyear      LIKE type_file.num5,
          salemonth     LIKE type_file.num5,
          from          LIKE type_file.chr1,      #FUN-B60146
          sort          LIKE type_file.chr1,
          more          LIKE type_file.chr1
                   END RECORD
DEFINE    g_wc          STRING,
          g_str         STRING,
          g_sql         STRING,
          l_table       STRING
DEFINE    g_posdb       LIKE ryg_file.ryg00
DEFINE    g_posdb_link  LIKE ryg_file.ryg02
 
###GENGRE###START
TYPE sr1_t RECORD
    operating LIKE azw_file.azw01,
    opname LIKE azw_file.azw08,
    staff LIKE rwu_file.rwu03,
    staffname LIKE gen_file.gen02,
    monactual LIKE rwu_file.rwu201,
    montarget LIKE rwu_file.rwu201,
    monrate LIKE type_file.num15_3,
    yearactual LIKE rwu_file.rwu201,
    yeartarget LIKE rwu_file.rwu201,
    yearrate LIKE type_file.num15_3
END RECORD
###GENGRE###END

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
                "staff.rwu_file.rwu03,",
                "staffname.gen_file.gen02,",
                "monactual.rwu_file.rwu201,",
                "montarget.rwu_file.rwu201,",
                "monrate.type_file.num15_3,",
                "yearactual.rwu_file.rwu201,",
                "yeartarget.rwu_file.rwu201,",
                "yearrate.type_file.num15_3,"
                
   LET l_table = cl_prt_temptable('artg142',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   CALL g142_tm(0,0)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table) #FUN-C40071
END MAIN
 
FUNCTION g142_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
DEFINE p_row,p_col    LIKE type_file.num5,
       l_cmd          LIKE type_file.chr1000,
       l_str          STRING
       
   IF p_row = 0 THEN LET p_row = 6 LET p_col = 14 END IF
   OPEN WINDOW g142_w AT p_row,p_col WITH FORM "art/42f/artg142"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET tm.from = '1'                               #FUN-B60146
   LET tm.sort = '1'
   LET tm.saleyear = YEAR(g_today)
   LET tm.salemonth = MONTH(g_today)
   WHILE TRUE
#     DISPLAY BY NAME tm.more,tm.sort,tm.saleyear,tm.salemont               #FUN-B60146 mark   
      DISPLAY BY NAME tm.more,tm.from,tm.sort,tm.saleyear,tm.salemonth      #FUN-B60146
      CONSTRUCT tm.wc ON rtz01,rtz10
         FROM operating,city
           
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
              
         ON ACTION controlp
            CASE
               WHEN INFIELD(operating)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_zxy"
                  LET g_qryparam.arg1 = g_user
                  LET g_qryparam.where = " zxy03 IN (SELECT azw01 FROM azw_file",
                                         "            WHERE azw01 NOT IN (",
                                         "                  SELECT azw07 FROM azw_file",
                                         "                   WHERE azw07 IS NOT NULL))",
                                         " AND zxy03 IN",g_auth
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

   #     ON ACTION accept
   #        EXIT CONSTRUCT
   #     
   #     ON ACTION cancel
   #        LET INT_FLAG = 1
   #        EXIT CONSTRUCT
 
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
         CLOSE WINDOW g142_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table) #FUN-C40071
         EXIT PROGRAM 
      END IF

      IF tm.wc= " 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF

#     INPUT BY NAME tm.saleyear,tm.salemonth,tm.sort                 #FUN-B60146 mark 
      INPUT BY NAME tm.saleyear,tm.salemonth,tm.from,tm.sort         #FUN-B60146
         ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)

         AFTER FIELD saleyear
            IF NOT cl_null(tm.saleyear) THEN
               LET l_str = tm.saleyear
               IF l_str.getLength() <> 4 THEN
                  CALL cl_err('','alm-672',0)
                  NEXT FIELD saleyear
               END IF
            END IF

         AFTER FIELD salemonth
            IF NOT cl_null(tm.salemonth) THEN
               IF tm.salemonth < 1 OR tm.salemonth > 12 THEN
                  CALL cl_err('','art-837',0)
                  NEXT FIELD salemonth
               END IF
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

   #     ON ACTION accept
   #        EXIT INPUT
   #     
   #     ON ACTION cancel
   #        LET INT_FLAG = 1
   #        EXIT INPUT
 
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
         CLOSE WINDOW g142_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table) #FUN-C40071
         EXIT PROGRAM 
      END IF

      INPUT BY NAME tm.more ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
         
         BEFORE INPUT
            LET g_pdate = g_today        #FUN-C40071--add
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

   #     ON ACTION accept
   #        EXIT INPUT
   #     
   #     ON ACTION cancel
   #        LET INT_FLAG = 1
   #        EXIT INPUT
 
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
         CLOSE WINDOW g142_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table) #FUN-C40071
         EXIT PROGRAM 
      END IF
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rtzuser', 'rtzgrup')
      CALL cl_wait()
      CALL artg142()
      ERROR ""
   END WHILE
   CLOSE WINDOW g142_w
END FUNCTION
 
FUNCTION artg142()
   DEFINE l_str          STRING,
          l_sql          STRING
   DEFINE l_rwu          RECORD LIKE rwu_file.*
   DEFINE l_days         LIKE type_file.num5
   DEFINE l_bdate        LIKE type_file.dat
   DEFINE l_edate        LIKE type_file.dat
   DEFINE l_begin        LIKE type_file.dat
   DEFINE l_posdb        LIKE ryg_file.ryg00
   DEFINE l_posdb_link   LIKE ryg_file.ryg02
   DEFINE l_ryg00        LIKE ryg_file.ryg00
   DEFINE l_bdate_pos    LIKE type_file.chr8
   DEFINE l_edate_pos    LIKE type_file.chr8
   DEFINE l_enddate      LIKE type_file.chr8
   DEFINE sr          RECORD
      operating       LIKE azw_file.azw01,
      opname          LIKE azw_file.azw08,
      staff           LIKE rwu_file.rwu03,
      staffname       LIKE gen_file.gen02,
      monactual       LIKE rwu_file.rwu201,
      montarget       LIKE rwu_file.rwu201,
      monrate         LIKE type_file.num15_3,
      yearactual      LIKE rwu_file.rwu201,
      yeartarget      LIKE rwu_file.rwu201,
      yearrate        LIKE type_file.num15_3
                      END RECORD
   DEFINE sr1         RECORD
      rtz01           LIKE rtz_file.rtz01,
      rtz10           LIKE rtz_file.rtz10
                      END RECORD
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> *** ##
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET l_days = cl_days(tm.saleyear,tm.salemonth)
     LET l_begin = MDY(1,1,tm.saleyear)
     LET l_bdate = MDY(tm.salemonth,1,tm.saleyear)
     LET l_edate = MDY(tm.salemonth,l_days,tm.saleyear)
     LET l_enddate = MDY(12,31,tm.saleyear)
     LET l_ryg00= 'ds_pos1'
     SELECT ryg00,ryg02 INTO l_posdb,l_posdb_link FROM ryg_file WHERE ryg00 = l_ryg00
     LET g_posdb=s_dbstring(l_posdb)
     LET g_posdb_link=g142_dblinks(l_posdb_link)
 
     LET l_sql ="SELECT rtz01,rtz10 ",
                "  FROM ",cl_get_target_table(g_plant,'rtz_file'),
                " WHERE rtz01 IN ( ",
                "       SELECT azw01 FROM ",cl_get_target_table(g_plant,'azw_file'),
                "        WHERE azw01 NOT IN (" ,
                "              SELECT azw07 FROM ",cl_get_target_table(g_plant,'azw_file'),
                "               WHERE azw07 IS NOT NULL) ",
                "          AND azw01 IN( ",
                "              SELECT zxy03 FROM ",cl_get_target_table(g_plant,'zxy_file'),
                "               WHERE zxy01 = '",g_user,"') ",
                "          AND azwacti = 'Y') ",
                "   AND ",tm.wc,
                "   AND rtz28 = 'Y' ",
                "   AND rtz01 IN ",g_auth,
                " ORDER BY rtz01"
 
     PREPARE g142_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table) #FUN-C40071
        EXIT PROGRAM
     END IF
     DECLARE g142_cs1 CURSOR FOR g142_prepare1
     FOREACH g142_cs1 INTO sr1.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET l_sql = 
          "SELECT rwu01,'',rwu03,'','','','','','','' ",
          "  FROM ",cl_get_target_table(sr1.rtz01,'rwu_file'),
          " WHERE rwu01 = '",sr1.rtz01,"' ",
          "   AND rwu02 = '",tm.saleyear,"' " 
       PREPARE sel_rwu_pre FROM l_sql
       DECLARE sel_rwu_cs CURSOR FOR sel_rwu_pre
       FOREACH sel_rwu_cs INTO sr.*
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          LET l_sql = "SELECT * ",
                      "  FROM ",cl_get_target_table(sr1.rtz01,'rwu_file'),
                      " WHERE rwu01 = '",sr1.rtz01,"' ",
                      "   AND rwu02 = '",tm.saleyear,"' ",
                      "   AND rwu03 = '",sr.staff,"' " 
          PREPARE sel_rwu_pre1 FROM l_sql
          EXECUTE sel_rwu_pre1 INTO l_rwu.*
          CASE tm.salemonth
             WHEN 1
                LET sr.montarget = l_rwu.rwu201
             WHEN 2
                LET sr.montarget = l_rwu.rwu202
             WHEN 3
                LET sr.montarget = l_rwu.rwu203
             WHEN 4
                LET sr.montarget = l_rwu.rwu204
             WHEN 5
                LET sr.montarget = l_rwu.rwu205
             WHEN 6
                LET sr.montarget = l_rwu.rwu206
             WHEN 7
                LET sr.montarget = l_rwu.rwu207
             WHEN 8
                LET sr.montarget = l_rwu.rwu208
             WHEN 9
                LET sr.montarget = l_rwu.rwu209
             WHEN 10
                LET sr.montarget = l_rwu.rwu210
             WHEN 11
                LET sr.montarget = l_rwu.rwu211
             WHEN 12
                LET sr.montarget = l_rwu.rwu212
             
          END CASE
          LET sr.yeartarget = l_rwu.rwu201 + l_rwu.rwu202 + l_rwu.rwu203 +
                              l_rwu.rwu204 + l_rwu.rwu205 + l_rwu.rwu206 +
                              l_rwu.rwu207 + l_rwu.rwu208 + l_rwu.rwu209 +
                              l_rwu.rwu210 + l_rwu.rwu211 + l_rwu.rwu212

          LET l_bdate_pos = l_bdate USING "YYYYMMDD"
          LET l_edate_pos = l_edate USING "YYYYMMDD"
#FUN-C80043 add begin ---
          CASE tm.from
             WHEN '1'
                LET l_sql =
                   "SELECT SUM(CASE TYPE WHEN 0 THEN amt ELSE amt*(-1) END) FROM ",g_posdb,"td_sale_detail",g_posdb_link,
                   ",",g_posdb,"td_sale",g_posdb_link,
                   " WHERE td_sale.shop = '",sr.operating,"' ",
                   "   AND td_sale.shop = td_sale_detail.shop ",
                   "   AND td_sale.SaleNO = td_sale_detail.SaleNO",
                   "   AND Bdate >= '",l_bdate_pos,"'",
                   "   AND Bdate <= '",l_edate_pos,"'",
                   "   AND TYPE IN ('0','1','2') ",
                   "   AND opno IN (SELECT ryi01 FROM ",cl_get_target_table(sr1.rtz01,'ryi_file'),
                   "                            WHERE ryi02 = '",sr.staff,"' ",
                   "                              AND ryiacti = 'Y') "
                   
                PREPARE sel_amt_pre1 FROM l_sql
                EXECUTE sel_amt_pre1 INTO sr.monactual
                LET l_bdate_pos = l_begin USING "YYYYMMDD"
                LET l_sql =
                   "SELECT SUM(CASE TYPE WHEN 0 THEN amt ELSE amt*(-1) END) FROM ",g_posdb,"td_sale_detail",g_posdb_link,
                   ",",g_posdb,"td_sale",g_posdb_link,
                   " WHERE td_sale.shop = '",sr.operating,"' ",             
                   "   AND td_sale.shop = td_sale_detail.shop ",
                   "   AND td_sale.SaleNO = td_sale_detail.SaleNO",
                   "   AND Bdate >= '",l_bdate_pos,"'",
                   "   AND Bdate <= '",l_edate_pos,"'",
                   "   AND TYPE IN ('0','1','2') ",
                   "   AND opno IN (SELECT ryi01 FROM ",cl_get_target_table(sr1.rtz01,'ryi_file'),
                   "                            WHERE ryi02 = '",sr.staff,"' ",
                   "                              AND ryiacti = 'Y') "
                PREPARE sel_amt_pre2 FROM l_sql
                EXECUTE sel_amt_pre2 INTO sr.yearactual
             WHEN '2'
                LET l_sql =
                   "SELECT SUM(rww04) FROM ",cl_get_target_table(sr1.rtz01,'rwv_file'),
                   ",",cl_get_target_table(sr1.rtz01,'rww_file'),
                   " WHERE rwvplant = '",sr.operating,"' ",
                   "   AND rwv02 >= '",l_bdate,"'",
                   "   AND rwv02 <= '",l_edate,"'",
                   "   AND rww03 = '",sr.staff,"' ",
                   "   AND rwvconf = 'Y' ",
                   "   AND rwv01 = rww01 "
                PREPARE sel_rwv03_pre1 FROM l_sql
                EXECUTE sel_rwv03_pre1 INTO sr.monactual
                LET l_sql =
                   "SELECT SUM(rww04) FROM ",cl_get_target_table(sr1.rtz01,'rwv_file'),
                   ",",cl_get_target_table(sr1.rtz01,'rww_file'),
                   " WHERE rwvplant = '",sr.operating,"' ",
                   "   AND rwv02 >= '",l_begin,"'",
                   "   AND rwv02 <= '",l_enddate,"'",
                   "   AND rww03 = '",sr.staff,"' ",
                   "   AND rwvconf = 'Y' ",
                   "   AND rwv01 = rww01 "
                PREPARE sel_rwv03_pre2 FROM l_sql
                EXECUTE sel_rwv03_pre2 INTO sr.yearactual
          END CASE
#FUN-C80043 add end -----
#FUN-C80043 mark begin ---
##FUN-B60146 -------------------start------------------- 
#          CASE tm.from
#             WHEN '1'
#                LET l_sql = 
#                   "SELECT SUM(amt) FROM ",g_posdb,"POSDB",g_posdb_link,
#                   " WHERE shop = '",sr.operating,"' ",
#                   "   AND fdate BETWEEN '",l_bdate_pos,"' AND '",l_edate_pos,"' ",
#                   "   AND opno IN (SELECT ryi01 FROM ",cl_get_target_table(sr1.rtz01,'ryi_file'),
#                   "                          WHERE ryi02 = '",sr.staff,"' ",
#                #  "                            AND ryiacti = 'Y') ",  #FUN-B70100 MARK
#                   "                            AND ryiacti = 'Y') "   #FUN-B70100 ADD
#                #  "   AND amt > 0"                                    #FUN-B70100 MARK
#                PREPARE sel_amt_pre1 FROM l_sql
#                EXECUTE sel_amt_pre1 INTO sr.monactual
#      
#                LET l_bdate_pos = l_begin USING "YYYYMMDD"
#      
#                LET l_sql = 
#                   "SELECT SUM(amt) FROM ",g_posdb,"POSDB",g_posdb_link,
#                   " WHERE shop = '",sr.operating,"' ",
#                   "   AND fdate BETWEEN '",l_bdate_pos,"' AND '",l_edate_pos,"' ",
#                   "   AND opno IN (SELECT ryi01 FROM ",cl_get_target_table(sr1.rtz01,'ryi_file'),
#                   "                          WHERE ryi02 = '",sr.staff,"' ",
#                #  "                            AND ryiacti = 'Y') ",  #FUN-B70100 MARK
#                   "                            AND ryiacti = 'Y') "   #FUN-B70100 ADD
#                #  "   AND amt > 0"                                    #FUN-B70100 MARK
#                PREPARE sel_amt_pre2 FROM l_sql
#                EXECUTE sel_amt_pre2 INTO sr.yearactual
#             WHEN '2'
#                LET l_sql =  
#                   "SELECT SUM(rww04) FROM ",cl_get_target_table(sr1.rtz01,'rwv_file'),
#                   ",",cl_get_target_table(sr1.rtz01,'rww_file'),
#                   " WHERE rwvplant = '",sr.operating,"' ",
#                   "   AND rwv02  BETWEEN '",l_bdate,"' AND '",l_edate,"' ",
#                   "   AND rww03 = '",sr.staff,"' ",
#                   "   AND rwvconf = 'Y' ",
#                #  "   AND rwv01 = rww01 ",  #FUN-B70100 MARK
#                   "   AND rwv01 = rww01 "   #FUN-B70100 ADD
#                #  "   AND rww04 > 0"        #FUN-B70100 MARK
#                PREPARE sel_rwv03_pre1 FROM l_sql
#                EXECUTE sel_rwv03_pre1 INTO sr.monactual
#                LET l_sql =
#                   "SELECT SUM(rww04) FROM ",cl_get_target_table(sr1.rtz01,'rwv_file'),
#                   ",",cl_get_target_table(sr1.rtz01,'rww_file'),
#                   " WHERE rwvplant = '",sr.operating,"' ",
#                   "   AND rwv02  BETWEEN '",l_begin,"' AND '",l_enddate,"' ",
#                   "   AND rww03 = '",sr.staff,"' ",
#                   "   AND rwvconf = 'Y' ",
#                #  "   AND rwv01 = rww01 ",  #FUN-B70100 MARK
#                   "   AND rwv01 = rww01 "   #FUN-B70100 ADD
#                #  "   AND rww04 > 0"        #FUN-B70100 MARK
#                PREPARE sel_rwv03_pre2 FROM l_sql
#                EXECUTE sel_rwv03_pre2 INTO sr.yearactual
#          END CASE
##FUN-B60146 -------------------end------------------- 
#FUN-C80043 mark end ----
          IF cl_null(sr.monactual) THEN
             LET sr.monactual = 0
          END IF
          IF cl_null(sr.yearactual) THEN
             LET sr.yearactual = 0
          END IF

          LET sr.monrate = cl_digcut(sr.monactual/sr.montarget * 100,2)
          LET sr.yearrate = cl_digcut(sr.yearactual/sr.yeartarget * 100,2)

          LET l_sql = "SELECT azw08 ",
                      "  FROM ",cl_get_target_table(sr1.rtz01,'azw_file'),
                      " WHERE azw01 = '",sr.operating,"' ",
                      "   AND azwacti = 'Y'"
          PREPARE sel_azw_pre FROM l_sql
          EXECUTE sel_azw_pre INTO sr.opname

          LET l_sql = "SELECT gen02 ",
                      "  FROM ",cl_get_target_table(sr1.rtz01,'gen_file'),
                      " WHERE gen01 = '",sr.staff,"' ",
                      "   AND genacti = 'Y'"
          PREPARE sel_gen_pre FROM l_sql
          EXECUTE sel_gen_pre INTO sr.staffname

       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
          EXECUTE insert_prep USING sr.*
          INITIALIZE sr.* TO NULL
       END FOREACH
       INITIALIZE sr1.* TO NULL
     END FOREACH
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " ORDER BY operating"
   CASE tm.sort
      WHEN '1'
         LET l_sql = l_sql,",monrate"
      WHEN '2'
###GENGRE###         LET l_sql = l_sql,",yearrate"
   END CASE
   #是否列印選擇條件
   LET g_str = ''
   IF g_zz05 = 'Y' THEN
     #CALL cl_wcchp(tm.wc,'oga01,tc_ogb004,tc_ogb008')  #FUN-BC0026 mark
      CALL cl_wcchp(tm.wc,'rtz01,rtz10')  #FUN-BC0026 add 
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
###GENGRE###   LET g_str = g_str,";",tm.saleyear,";",tm.salemonth
###GENGRE###   CALL cl_prt_cs3('artg142','artg142',l_sql,g_str)
    CALL artg142_grdata()    ###GENGRE###
END FUNCTION

FUNCTION g142_dblinks(l_db_links)
DEFINE l_db_links LIKE ryg_file.ryg02

  IF l_db_links IS NULL OR l_db_links = ' ' THEN
     RETURN ' '
  ELSE
     LET l_db_links = '@',l_db_links CLIPPED
     RETURN l_db_links
  END IF

END FUNCTION

#FUN-B50069


###GENGRE###START
FUNCTION artg142_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("artg142")
        IF handler IS NOT NULL THEN
            START REPORT artg142_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE artg142_datacur1 CURSOR FROM l_sql
            FOREACH artg142_datacur1 INTO sr1.*
                OUTPUT TO REPORT artg142_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg142_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg142_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_sale_year_month STRING          #FUN-C40071 add 
    DEFINE sr1_o      sr1_t                  #FUN-C40071 add
    DEFINE l_display  STRING                 #FUN-C40071 add
    DEFINE l_display1  STRING                 #FUN-C40071 add
    
    ORDER EXTERNAL BY sr1.operating
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name  #FUN-C40071--add g_ptime,g_user_name
            PRINTX tm.*
            LET sr1_o.operating = NULL  #FUN-C40071--add
            LET sr1_o.opname = NULL     #FUN-C40071--add
              
        BEFORE GROUP OF sr1.operating
         LET l_sale_year_month = tm.saleyear,'/',tm.salemonth  #FUN-C40071--add 
         PRINTX l_sale_year_month                              #FUN-C40071--add
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-C40071 sta
            IF NOT cl_null(sr1_o.operating) OR NOT cl_null(sr1_o.opname) THEN
               IF sr1_o.operating != sr1.operating THEN
                  LET l_display = 'Y'
               ELSE
                  LET l_display = 'N'
               END IF
            ELSE
               LET l_display = 'Y'
            END IF
            PRINTX l_display
           
#           IF NOT cl_null(sr1_o.opname) THEN
#              IF sr1_o.opname != sr1.opname THEN
#                 LET l_display1 = 'Y'
#              ELSE
#                 LET l_display1 = 'N'
#              END IF
#           ELSE
#              LET l_display1 = 'Y'
#           END IF
#           PRINTX l_display1     

            LET sr1_o.*=sr1.*
            PRINTX sr1.*
          #FUN-C40071 end

        AFTER GROUP OF sr1.operating

        
        ON LAST ROW

END REPORT
###GENGRE###END
