# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: aglr024.4gl
# Descriptions...: 合併報表關係人應收應付交易明細表
# Date & Author..: 12/04/13 By Lori(FUN-BB0052)
# Modify.........: No.FUN-C10024 12/05/16 By minpp 帳套取歷年主會計帳別檔tna_file
# Modify.........: No.MOD-C70123 12/07/10 By Elise 非MISC時，INSERT INTO r024_tmp的最後一個欄位(line)應為2

DATABASE ds
#FUN-BB0052
GLOBALS "../../config/top.global"

DEFINE tm         RECORD
                  axf13   LIKE axf_file.axf13,   #族群代號
                  axf16   LIKE axf_file.axf16,   #合併主體
                  bdate   LIKE type_file.dat,    #起始日期
                  edate   LIKE type_file.dat,    #截止日期
                  e       LIKE type_file.chr1,   #列印明細資料
                  more    LIKE type_file.chr1    #Input more condition(Y/N)
                  END RECORD 
DEFINE g_str      STRING
DEFINE g_sql      STRING
DEFINE l_table    STRING
DEFINE g_bookno   LIKE aah_file.aah00
DEFINE g_bookno1     LIKE aza_file.aza81      #FUN-C10024
DEFINE g_bookno2     LIKE aza_file.aza82      #FUN-C10024
DEFINE g_flag        LIKE type_file.chr1      #FUN-C10024
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   LET g_sql = "order1.type_file.num5,",
               "order2.type_file.num5,",
               "axf09_l.axf_file.axf09,",
               "oma18_l.oma_file.oma18,",
               "aag02_l.aag_file.aag02,",
               "oma02_l.oma_file.oma02,",
               "oma01_l.oma_file.oma01,",
               "oma10_l.oma_file.oma10,",
               "oma67_l.oma_file.oma67,",
               "oma23_l.oma_file.oma23,",
               "oma54t_l.oma_file.oma54t,",
               "axf10_r.axf_file.axf10,",
               "oma18_r.oma_file.oma18,",
               "aag02_r.aag_file.aag02,",
               "oma02_r.oma_file.oma02,",
               "oma01_r.oma_file.oma01,",
               "oma10_r.oma_file.oma10,",
               "oma67_r.oma_file.oma67,",
               "oma23_r.oma_file.oma23,",
               "oma54t_r.oma_file.oma54t"
   LET l_table = cl_prt_temptable('aglr024',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,? ,?,?,?,?,? ,?,?,?,?,? ,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114

   LET g_bookno   = ARG_VAL(1)
   LET g_pdate    = ARG_VAL(2)
   LET g_towhom   = ARG_VAL(3)
   LET g_rlang    = ARG_VAL(4)
   LET g_bgjob    = ARG_VAL(5)
   LET g_prtway   = ARG_VAL(6)
   LET g_copies   = ARG_VAL(7)
   LET tm.axf13   = ARG_VAL(8)
   LET tm.axf16   = ARG_VAL(9)
   LET tm.bdate   = ARG_VAL(10)
   LET tm.edate   = ARG_VAL(11)
   LET tm.e       = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r024_tm()
   ELSE
      CALL r024()
   END IF
   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION r024_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_n            LIKE type_file.num5,
          l_sw           LIKE type_file.chr1,
          l_cmd          LIKE type_file.chr1000

   LET p_row = 2 LET p_col = 20

   OPEN WINDOW r024_w AT p_row,p_col WITH FORM "agl/42f/aglr024" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL

   LET tm.e = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

   WHILE TRUE
      LET l_sw = 1

      INPUT BY NAME tm.axf13,tm.axf16,tm.bdate,tm.edate,tm.e,tm.more
            WITHOUT DEFAULTS  

         BEFORE INPUT
            CALL cl_qbe_init()

         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT INPUT

         AFTER FIELD axf13    #族群編號
            IF NOT cl_null(tm.axf13) THEN
               SELECT UNIQUE axa01 FROM axa_file WHERE axa01=tm.axf13
               IF STATUS THEN
                  CALL cl_err3("sel","axa_file",tm.axf13,tm.axf16,"agl-11","","",0)
                  NEXT FIELD axf13
               END IF
            ELSE
               NEXT FIELD axf13
            END IF
         AFTER FIELD axf16    #公司編號
            IF NOT cl_null(tm.axf16) THEN
               SELECT count(*) INTO l_n FROM axa_file
                WHERE axa01=tm.axf13 AND axa02=tm.axf16
               IF l_n = 0  THEN
                  CALL cl_err('sel axa:','agl-118',0)
                  NEXT FIELD axf16
               END IF
            ELSE
               NEXT FIELD axf16
            END IF
         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
            END IF

         AFTER INPUT 
            IF INT_FLAG THEN EXIT INPUT END IF
            IF cl_null(tm.bdate) THEN
               LET l_sw = 0 
               DISPLAY BY NAME tm.bdate
               CALL cl_err('',9033,0)
            END IF
            IF cl_null(tm.edate) THEN
               LET l_sw = 0 
               DISPLAY BY NAME tm.edate
            END IF

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(axf13)   #族群代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_axa5"
                  LET g_qryparam.default1 = tm.axf13
                  CALL cl_create_qry() RETURNING tm.axf13
                  DISPLAY BY NAME tm.axf13
                  NEXT FIELD axf13
               WHEN INFIELD(axf16)   #合併主體
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_axa3"
                  LET g_qryparam.arg1 = tm.axf13
                  LET g_qryparam.default1 = tm.axf16
                  CALL cl_create_qry() RETURNING tm.axf16
                  DISPLAY BY NAME tm.axf16
                  NEXT FIELD axf16
            END CASE

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

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()

      END INPUT

       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r008_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
            
      END IF

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aglr024'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglr024','9031',1)   
         ELSE
            LET l_cmd = l_cmd CLIPPED,          #(at time fglgo xxxx p1 p2 p3)
                        " '",g_bookno CLIPPED,"'",
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_rlang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.axf13 CLIPPED,"'",
                        " '",tm.axf16 CLIPPED,"'",
                        " '",tm.bdate CLIPPED,"'",
                        " '",tm.edate CLIPPED,"'",
                        " '",tm.e CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",
                        " '",g_rep_clas CLIPPED,"'",
                        " '",g_template CLIPPED,"'" 
            CALL cl_cmdat('aglr024',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW r024_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r024()
      ERROR ""
   END WHILE
   CLOSE WINDOW r024_w
END FUNCTION

FUNCTION r024()
   DEFINE g_oma     RECORD LIKE oma_file.*
   DEFINE g_occ     RECORD LIKE occ_file.*
   DEFINE g_apa     RECORD LIKE apa_file.*
   DEFINE g_pmc     RECORD LIKE pmc_file.*
   DEFINE l_axf09   LIKE axf_file.axf09
   DEFINE l_axf10   LIKE axf_file.axf10
   DEFINE l_aag02   LIKE aag_file.aag02
   DEFINE l_apk03   LIKE apk_file.apk03,
          l_apk06f  LIKE apk_file.apk06f
   DEFINE tmp1      RECORD
                      axf09  LIKE axf_file.axf09,
                      axf10  LIKE axf_file.axf10,
                      oma18  LIKE oma_file.oma18,
                      aag02  LIKE aag_file.aag02,
                      oma02  LIKE oma_file.oma02,
                      oma01  LIKE oma_file.oma01,
                      oma10  LIKE oma_file.oma10,
                      oma67  LIKE oma_file.oma67,
                      oma23  LIKE oma_file.oma23,
                      oma54t LIKE oma_file.oma54t,
                      line   LIKE type_file.num5
                    END RECORD
   DEFINE prt_l     DYNAMIC ARRAY OF RECORD         #--- 陣列 for 來源公司 (左)
                      axf09  LIKE axf_file.axf09,
                      oma18  LIKE oma_file.oma18,
                      aag02  LIKE aag_file.aag02,
                      oma02  LIKE oma_file.oma02,
                      oma01  LIKE oma_file.oma01,
                      oma10  LIKE oma_file.oma10,
                      oma67  LIKE oma_file.oma67,
                      oma23  LIKE oma_file.oma23,
                      oma54t LIKE oma_file.oma54t
                    END RECORD
   DEFINE prt_r     DYNAMIC ARRAY OF RECORD         #--- 陣列 for 目的公司 (右)
                      axf10  LIKE axf_file.axf10,
                      oma18  LIKE oma_file.oma18,
                      aag02  LIKE aag_file.aag02,
                      oma02  LIKE oma_file.oma02,
                      oma01  LIKE oma_file.oma01,
                      oma10  LIKE oma_file.oma10,
                      oma67  LIKE oma_file.oma67,
                      oma23  LIKE oma_file.oma23,
                      oma54t LIKE oma_file.oma54t
                    END RECORD
   DEFINE l_row_l   LIKE type_file.num5,
          l_row_r   LIKE type_file.num5,
          l_row     LIKE type_file.num5,
          r_row     LIKE type_file.num5,
          i,j       LIKE type_file.num5,
          l_last    LIKE type_file.num5
   DEFINE l_sql     LIKE type_file.chr1000
   DEFINE l_oma18   LIKE oma_file.oma18,
          l_oma23   LIKE oma_file.oma23,
          l_oma54t  LIKE oma_file.oma54t
   DEFINE g_axz03_axf09 LIKE axz_file.axz03
   #DEFINE g_dbs_axf09   LIKE azp_file.azp03
   DEFINE g_axz03_axf10 LIKE axz_file.axz03
   #DEFINE g_dbs_axf10   LIKE azp_file.azp03
   CALL cl_del_data(l_table)

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   CALL r024_create_temp_table()
   
  #先將資料整理到r024_tmp
   LET l_sql = "SELECT UNIQUE axf09,axf10 FROM axf_file",
               " WHERE axf13 = '",tm.axf13,"' AND axf16 = '",tm.axf16,"'",
               " ORDER BY axf09,axf10"
   PREPARE r024_axf_p FROM l_sql 
   DECLARE r024_axf_c CURSOR FOR r024_axf_p
   FOREACH r024_axf_c INTO l_axf09,l_axf10
     #來源公司
     #取得營運中心代碼
      SELECT axz03 INTO g_axz03_axf09 FROM axz_file
       WHERE axz01 = l_axf09
     #取得資料庫名稱
      #SELECT azp03 INTO g_dbs_axf09 FROM azp_file
      # WHERE azp01 = g_axz03_axf09
      #IF STATUS THEN
      #   LET g_dbs_axf09 = NULL
      #END IF
      #LET g_dbs_axf09 = s_dbstring(g_dbs_axf09 CLIPPED)
     #來源公司-AR(應收)
      #LET l_sql =" SELECT * FROM ",g_dbs_axf09,"oma_file,occ_file",
      #           "  WHERE oma03 = occ01 ",
      #           "    AND occ37  = 'Y'",
      #           "    AND (oma00 = '12' OR oma00 = '14' OR oma00 = '21')",
      #           "    AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
      #           "    AND omaconf  = 'Y'",
      #           "  ORDER BY oma18,oma02,oma01,oma23"
                 
      LET l_sql =" SELECT * FROM ",cl_get_target_table(g_axz03_axf09, 'oma_file'),",",cl_get_target_table(g_axz03_axf09, 'occ_file'),
                 "  WHERE oma03 = occ01 ",
                 "    AND occ37  = 'Y'",
                 "    AND (oma00 = '12' OR oma00 = '14' OR oma00 = '21')",
                 "    AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "    AND omaconf  = 'Y'",
                 "  ORDER BY oma18,oma02,oma01,oma23"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
      CALL cl_parse_qry_sql(l_sql,g_axz03_axf09) RETURNING l_sql 
      
      PREPARE r024_p_1 FROM l_sql 
      DECLARE r024_c_1 CURSOR FOR r024_p_1
      FOREACH r024_c_1 INTO g_oma.*,g_occ.*
         IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
         LET l_aag02 = " "
         CALL s_get_bookno(YEAR(g_oma.oma02))  RETURNING g_flag,g_bookno1,g_bookno2 #FUN-C10024--ADD
         SELECT aag02 INTO l_aag02
           FROM aag_file
          WHERE aag01 = g_oma.oma18
            AND aag00 = g_bookno1    #FUN-C10024--ADD
         INSERT INTO r024_tmp VALUES (l_axf09,l_axf10,g_oma.oma18,l_aag02,g_oma.oma02,g_oma.oma01
                                     ,g_oma.oma10,g_oma.oma67,g_oma.oma23,g_oma.oma54t,1)
      END FOREACH
     #來源公司-AP(應付)
      #LET l_sql = " SELECT * FROM ",g_dbs_axf09,"apa_file,pmc_file",
      #            "  WHERE apa05 = pmc01",
      #            "    AND pmc903 = 'Y'",
      #            "    AND (apa00 = '11' OR apa00 = '12' OR apa00 = '15' OR apa00 = '16')",
      #            "    AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
      #            "    AND apa41  = 'Y'",
      #            "  ORDER BY apa54,apa02,apa01,apa13"
      
      LET l_sql = " SELECT * FROM ",cl_get_target_table(g_axz03_axf09, 'apa_file'),",",cl_get_target_table(g_axz03_axf09, 'pmc_file'),
                  "  WHERE apa05 = pmc01",
                  "    AND pmc903 = 'Y'",
                  "    AND (apa00 = '11' OR apa00 = '12' OR apa00 = '15' OR apa00 = '16')",
                  "    AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                  "    AND apa41  = 'Y'",
                  "  ORDER BY apa54,apa02,apa01,apa13"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
      CALL cl_parse_qry_sql(l_sql,g_axz03_axf09) RETURNING l_sql  
                  
      PREPARE r024_p_2 FROM l_sql
      DECLARE r024_c_2 CURSOR FOR r024_p_2
      FOREACH r024_c_2 INTO g_apa.*,g_pmc.*
         IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
         LET l_aag02 = " "
         CALL s_get_bookno(YEAR(g_apa.apa02))  RETURNING g_flag,g_bookno1,g_bookno2 #FUN-C10024--ADD
         SELECT aag02 INTO l_aag02
           FROM aag_file
          WHERE aag01 = g_apa.apa54
            AND aag00 = g_bookno1       #FUN-C10024--ADD
         IF g_apa.apa08 = 'MISC' THEN
            LET l_sql = " SELECT apk03,apk06f FROM apk_file WHERE apk01 = '",g_apa.apa01,"'"
            PREPARE r024_p_3 FROM l_sql 
            DECLARE r024_c_3 CURSOR FOR r024_p_3
            FOREACH r024_c_3 INTO l_apk03,l_apk06f
               INSERT INTO r024_tmp VALUES (l_axf09,l_axf10,g_apa.apa54,l_aag02,g_apa.apa02,g_apa.apa01
                                           ,l_apk03,' ',g_apa.apa13,l_apk06f,1)
            END FOREACH
         ELSE
           INSERT INTO r024_tmp VALUES (l_axf09,l_axf10,g_apa.apa54,l_aag02,g_apa.apa02,g_apa.apa01
                                       ,g_apa.apa08,' ',g_apa.apa13,g_apa.apa34f,1)
         END IF
      END FOREACH

     #目的公司
     #取得營運中心代碼
      SELECT axz03 INTO g_axz03_axf10 FROM axz_file
       WHERE axz01 = l_axf10
     #取得資料庫名稱
      #SELECT azp03 INTO g_dbs_axf10 FROM azp_file
      # WHERE azp01 = g_axz03_axf10
      #IF STATUS THEN
      #   LET g_dbs_axf10 = NULL
      #END IF
      #LET g_dbs_axf10 = s_dbstring(g_dbs_axf10 CLIPPED)
     #目的公司-AR(應收)
      #LET l_sql =" SELECT * FROM ",g_dbs_axf10,"oma_file,occ_file",
      #           "  WHERE oma03 = occ01 ",
      #           "    AND occ37  = 'Y'",
      #           "    AND (oma00 = '12' OR oma00 = '14' OR oma00 = '21')",
      #           "    AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
      #           "    AND omaconf = 'Y'",
      #           "  ORDER BY oma18,oma02,oma01,oma23"

      LET l_sql =" SELECT * FROM ",cl_get_target_table(g_axz03_axf10, 'oma_file'),",",cl_get_target_table(g_axz03_axf10, 'occ_file'),
                 "  WHERE oma03 = occ01 ",
                 "    AND occ37  = 'Y'",
                 "    AND (oma00 = '12' OR oma00 = '14' OR oma00 = '21')",
                 "    AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "    AND omaconf = 'Y'",
                 "  ORDER BY oma18,oma02,oma01,oma23"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
      CALL cl_parse_qry_sql(l_sql,g_axz03_axf10) RETURNING l_sql
                 
      PREPARE r024_p_4 FROM l_sql
      DECLARE r024_c_4 CURSOR FOR r024_p_4
      FOREACH r024_c_4 INTO g_oma.*,g_occ.*
         IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
         LET l_aag02 = " "
         CALL s_get_bookno(YEAR(g_oma.oma02))  RETURNING g_flag,g_bookno1,g_bookno2 #FUN-C10024--ADD
         SELECT aag02 INTO l_aag02
           FROM aag_file
          WHERE aag01 = g_oma.oma18
            AND aag00 = g_bookno1       #FUN-C10024  
         INSERT INTO r024_tmp VALUES (l_axf09,l_axf10,g_oma.oma18,l_aag02,g_oma.oma02,g_oma.oma01
                                     ,g_oma.oma10,g_oma.oma67,g_oma.oma23,g_oma.oma54t,2)
      END FOREACH
     #目的公司-AP(應付)
      #LET l_sql = " SELECT * FROM ",g_dbs_axf10,"apa_file,pmc_file",
      #            "  WHERE apa05 = pmc01",
      #            "   AND pmc903 = 'Y'",
      #            "   AND (apa00 = '11' OR apa00 = '12' OR apa00 = '15' OR apa00 = '16')",
      #            "   AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
      #            "   AND apa41 = 'Y'"

      LET l_sql = " SELECT * FROM ",cl_get_target_table(g_axz03_axf10, 'apa_file'),",",cl_get_target_table(g_axz03_axf10, 'pmc_file'),
                  "  WHERE apa05 = pmc01",
                  "   AND pmc903 = 'Y'",
                  "   AND (apa00 = '11' OR apa00 = '12' OR apa00 = '15' OR apa00 = '16')",
                  "   AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                  "   AND apa41 = 'Y'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
      CALL cl_parse_qry_sql(l_sql,g_axz03_axf10) RETURNING l_sql
                  
      PREPARE r024_p_5 FROM l_sql 
      DECLARE r024_c_5 CURSOR FOR r024_p_5
      FOREACH r024_c_5 INTO g_apa.*,g_pmc.*
         IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
         LET l_aag02 = " "
         CALL s_get_bookno(YEAR(g_apa.apa02))  RETURNING g_flag,g_bookno1,g_bookno2 #FUN-C10024--ADD       
         SELECT aag02 INTO l_aag02
           FROM aag_file
          WHERE aag01 = g_apa.apa54
            AND aag00 = g_bookno1       #FUN-C10024--ADD
         IF g_apa.apa08 = 'MISC' THEN
            LET l_sql = "SELECT apk03,apk06f FROM apk_file WHERE apk01 = '",g_apa.apa01,"'"
            PREPARE r024_p_6 FROM l_sql 
            DECLARE r024_c_6 CURSOR FOR r024_p_6
            FOREACH r024_c_6 INTO l_apk03,l_apk06f
               INSERT INTO r024_tmp VALUES (l_axf09,l_axf10,g_apa.apa54,l_aag02,g_apa.apa02,g_apa.apa01
                                           ,l_apk03,' ',g_apa.apa13,l_apk06f,2)
            END FOREACH
         ELSE
           INSERT INTO r024_tmp VALUES (l_axf09,l_axf10,g_apa.apa54,l_aag02,g_apa.apa02,g_apa.apa01
                                      #,g_apa.apa08,' ',g_apa.apa13,g_apa.apa34f,1)  #MOD-C70123 mark
                                       ,g_apa.apa08,' ',g_apa.apa13,g_apa.apa34f,2)  #MOD-C70123
         END IF
      END FOREACH
   END FOREACH

  #彙總r024_tmp資料
   LET j = 0
   LET l_sql = "SELECT UNIQUE axf09,axf10 FROM axf_file",
               " WHERE axf13 = '",tm.axf13,"' AND axf16 = '",tm.axf16,"'",
               " ORDER BY axf09,axf10"
   PREPARE r024_tmp_p FROM l_sql
   DECLARE r024_tmp_c CURSOR FOR r024_tmp_p
   FOREACH r024_tmp_c INTO l_axf09,l_axf10
      LET j = j+1
      LET l_row = 0
      LET r_row = 0
      CALL prt_l.clear()
      CALL prt_r.clear()
     #來源公司
      LET l_sql = " SELECT UNIQUE oma18 FROM r024_tmp",
                  "  WHERE line = '1'",
                  "    AND axf09 = '",l_axf09,"' AND axf10 = '",l_axf10,"'",
                  "  ORDER BY oma18"
      PREPARE r024_p_l1 FROM l_sql
      DECLARE r024_c_l1 CURSOR FOR r024_p_l1
      FOREACH r024_c_l1 INTO l_oma18
         IF tm.e = 'Y' THEN
            LET l_sql = " SELECT * FROM r024_tmp",
                        "  WHERE line = '1'",
                        "    AND axf09 = '",l_axf09,"' AND axf10 = '",l_axf10,"'",
                        "    AND oma18 = '",l_oma18,"'",
                        "  ORDER BY oma18,oma02,oma01,oma23"
            PREPARE r024_p_l2 FROM l_sql 
            DECLARE r024_c_l2 CURSOR FOR r024_p_l2
            FOREACH r024_c_l2 INTO tmp1.*
               IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
               LET l_row=l_row+1
               LET prt_l[l_row].axf09 = l_axf09
               LET prt_r[l_row].axf10 = l_axf10
               LET prt_l[l_row].oma18 = tmp1.oma18
               LET prt_l[l_row].aag02 = tmp1.aag02
               LET prt_l[l_row].oma02 = tmp1.oma02
               LET prt_l[l_row].oma01 = tmp1.oma01
               LET prt_l[l_row].oma10 = tmp1.oma10
               LET prt_l[l_row].oma67 = tmp1.oma67
               LET prt_l[l_row].oma23 = tmp1.oma23
               LET prt_l[l_row].oma54t= tmp1.oma54t
            END FOREACH
         END IF
         LET l_sql = " SELECT oma23,aag02,sum(oma54t) FROM r024_tmp",
                     "  WHERE line = '1'",
                     "    AND axf09 = '",l_axf09,"' AND axf10 = '",l_axf10,"'",
                     "    AND oma18 = '",l_oma18,"'",
                     " GROUP BY oma23,aag02"
         PREPARE r024_p_l3 FROM l_sql
         DECLARE r024_c_l3 CURSOR FOR r024_p_l3
         FOREACH r024_c_l3 INTO l_oma23,l_aag02,l_oma54t
            LET l_row=l_row+1
            LET prt_l[l_row].axf09 = l_axf09
            LET prt_r[l_row].axf10 = l_axf10
            LET prt_l[l_row].oma18 = l_oma18
            LET prt_l[l_row].aag02 = l_aag02
            LET prt_l[l_row].oma02 = " "
            LET prt_l[l_row].oma01 = " "
            LET prt_l[l_row].oma10 = " "
            LET prt_l[l_row].oma67 = "sum1"
            LET prt_l[l_row].oma23 = l_oma23
            LET prt_l[l_row].oma54t= l_oma54t
         END FOREACH
      END FOREACH
     #目的公司
      LET l_sql = " SELECT UNIQUE oma18 FROM r024_tmp",
                  "  WHERE line = '2'",
                  "    AND axf09 = '",l_axf09,"' AND axf10 = '",l_axf10,"'",
                  "  ORDER BY oma18"
      PREPARE r024_p_r1 FROM l_sql 
      DECLARE r024_c_r1 CURSOR FOR r024_p_r1
      FOREACH r024_c_r1 INTO l_oma18
         IF tm.e = 'Y' THEN
            LET l_sql = " SELECT * FROM r024_tmp",
                        "  WHERE line = '2'",
                        "    AND oma18 = '",l_oma18,"'",
                        "    AND axf09 = '",l_axf09,"' AND axf10 = '",l_axf10,"'",
                        "  ORDER BY oma18,oma02,oma01,oma23"
            PREPARE r024_p_r2 FROM l_sql
            DECLARE r024_c_r2 CURSOR FOR r024_p_r2
            FOREACH r024_c_r2 INTO tmp1.*
               IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
               LET r_row=r_row+1
               LET prt_l[r_row].axf09 = l_axf09
               LET prt_r[r_row].axf10 = l_axf10
               LET prt_r[r_row].oma18 = tmp1.oma18
               LET prt_r[r_row].aag02 = tmp1.aag02
               LET prt_r[r_row].oma02 = tmp1.oma02
               LET prt_r[r_row].oma01 = tmp1.oma01
               LET prt_r[r_row].oma10 = tmp1.oma10
               LET prt_r[r_row].oma67 = tmp1.oma67
               LET prt_r[r_row].oma23 = tmp1.oma23
               LET prt_r[r_row].oma54t= tmp1.oma54t
            END FOREACH
         END IF
         LET l_sql = " SELECT oma23,aag02,sum(oma54t) FROM r024_tmp",
                     "  WHERE line = '2'",
                     "    AND axf09 = '",l_axf09,"' AND axf10 = '",l_axf10,"'",
                     "    AND oma18 = '",l_oma18,"'",
                     " GROUP BY oma23,aag02"
         PREPARE r024_p_r3 FROM l_sql
         DECLARE r024_c_r3 CURSOR FOR r024_p_r3
         FOREACH r024_c_r3 INTO l_oma23,l_aag02,l_oma54t
            LET r_row=r_row+1
            LET prt_l[r_row].axf09 = l_axf09
            LET prt_r[r_row].axf10 = l_axf10
            LET prt_r[r_row].oma18 = l_oma18
            LET prt_r[r_row].aag02 = l_aag02
            LET prt_r[r_row].oma02 = " "
            LET prt_r[r_row].oma01 = " "
            LET prt_r[r_row].oma10 = " "
            LET prt_r[r_row].oma67 = "sum1"
            LET prt_r[r_row].oma23 = l_oma23
            LET prt_r[r_row].oma54t= l_oma54t
         END FOREACH
      END FOREACH

      IF r_row = 0 THEN LET r_row = 1 END IF
      IF l_row = 0 THEN LET l_row = 1 END IF
      IF l_row > r_row THEN
         LET l_last=l_row
      ELSE
         LET l_last=r_row
      END IF
    
      FOR i=1 TO l_last
         IF NOT cl_null(prt_l[i].axf09) AND NOT cl_null(prt_r[i].axf10) THEN
            EXECUTE insert_prep USING 
                j,i 
               ,prt_l[i].axf09,prt_l[i].oma18,prt_l[i].aag02
               ,prt_l[i].oma02,prt_l[i].oma01,prt_l[i].oma10
               ,prt_l[i].oma67,prt_l[i].oma23,prt_l[i].oma54t
               ,prt_r[i].axf10,prt_r[i].oma18,prt_r[i].aag02
               ,prt_r[i].oma02,prt_r[i].oma01,prt_r[i].oma10
               ,prt_r[i].oma67,prt_r[i].oma23,prt_r[i].oma54t
         END IF
      END FOR
   END FOREACH
  #總計
   LET j = j+1
   LET l_row = 0
   LET r_row = 0
   CALL prt_l.clear()
   CALL prt_r.clear()
   LET l_sql = " SELECT oma18,oma23,aag02,sum(oma54t) FROM r024_tmp",
               "  WHERE line = '1'",
               " GROUP BY oma18,oma23,aag02",
               " ORDER BY oma18,oma23"
   PREPARE r024_p_l4 FROM l_sql
   DECLARE r024_c_l4 CURSOR FOR r024_p_l4
   FOREACH r024_c_l4 INTO l_oma18,l_oma23,l_aag02,l_oma54t
      LET l_row=l_row+1
      LET prt_l[l_row].axf09 = " " 
      LET prt_r[l_row].axf10 = " " 
      LET prt_l[l_row].oma18 = l_oma18
      LET prt_l[l_row].aag02 = l_aag02
      LET prt_l[l_row].oma02 = " "
      LET prt_l[l_row].oma01 = " "
      LET prt_l[l_row].oma10 = " "
      LET prt_l[l_row].oma67 = "sum2"
      LET prt_l[l_row].oma23 = l_oma23
      LET prt_l[l_row].oma54t= l_oma54t
   END FOREACH

   LET l_sql = " SELECT oma18,oma23,aag02,sum(oma54t) FROM r024_tmp",
               "  WHERE line = '2'",
               " GROUP BY oma18,oma23,aag02",
               " ORDER BY oma18,oma23"
   PREPARE r024_p_r4 FROM l_sql
   DECLARE r024_c_r4 CURSOR FOR r024_p_r4
   FOREACH r024_c_r4 INTO l_oma18,l_oma23,l_aag02,l_oma54t
      LET r_row=r_row+1
      LET prt_l[r_row].axf09 = " "
      LET prt_r[r_row].axf10 = " "
      LET prt_r[r_row].oma18 = l_oma18
      LET prt_r[r_row].aag02 = l_aag02
      LET prt_r[r_row].oma02 = " "
      LET prt_r[r_row].oma01 = " "
      LET prt_r[r_row].oma10 = " "
      LET prt_r[r_row].oma67 = "sum2"
      LET prt_r[r_row].oma23 = l_oma23
      LET prt_r[r_row].oma54t= l_oma54t
   END FOREACH
   IF r_row = 0 THEN LET r_row = 1 END IF
   IF l_row = 0 THEN LET l_row = 1 END IF
   IF l_row > r_row THEN
      LET l_last=l_row
   ELSE
      LET l_last=r_row
   END IF

   FOR i=1 TO l_last
      EXECUTE insert_prep USING
          j,i
         ,prt_l[i].axf09,prt_l[i].oma18,prt_l[i].aag02
         ,prt_l[i].oma02,prt_l[i].oma01,prt_l[i].oma10
         ,prt_l[i].oma67,prt_l[i].oma23,prt_l[i].oma54t
         ,prt_r[i].axf10,prt_r[i].oma18,prt_r[i].aag02
         ,prt_r[i].oma02,prt_r[i].oma01,prt_r[i].oma10
         ,prt_r[i].oma67,prt_r[i].oma23,prt_r[i].oma54t
   END FOR
 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED             
   LET g_str = ""
   IF tm.e = 'Y' THEN
      CALL cl_prt_cs3('aglr024','aglr024',g_sql,g_str) 
   ELSE
      CALL cl_prt_cs3('aglr024','aglr024_1',g_sql,g_str) 
   END IF
END FUNCTION

FUNCTION r024_create_temp_table()
   DROP TABLE r024_tmp
   CREATE TEMP TABLE r024_tmp(
   axf09  LIKE axf_file.axf09,
   axf10  LIKE axf_file.axf09,
   oma18  LIKE oma_file.oma18,
   aag02  LIKE aag_file.aag02,
   oma02  LIKE oma_file.oma02,
   oma01  LIKE oma_file.oma01,
   oma10  LIKE oma_file.oma10,
   oma67  LIKE oma_file.oma67,
   oma23  LIKE oma_file.oma23,
   oma54t LIKE oma_file.oma54t,
   line   LIKE type_file.num5)
END FUNCTION
