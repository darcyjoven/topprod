# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: artr144.4gl
# Descriptions...: 營運中心營業日報表
# Date & Author..: No.FUN-B60148 11/07/01 By yangxf
# Modify.........: No:TQC-B70078 11/07/11 by pauline 修改銷售金額選取條件 一併顯示銷退金額
# Modify.........: No:TQC-B70204 11/07/28 By yangxf UNION 改成UNION ALL
# Modify.........: No:FUN-BA0074 11/11/07 by pauline 實際售價總額改抓取ogb14t,增加未稅總額欄位,抓取ogb14
# Modify.........: No.FUN-BC0026 12/01/30 By Pauline列印前是否有參考p_zz中的設定列印條件選項 
# Modify.........: No.FUN-C30298 12/03/28 By Pauline 請將artr144加上zxy的控管，與artr450一致
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE    tm       RECORD
          wc            LIKE type_file.chr1000,
          more          LIKE type_file.chr1
                   END RECORD
DEFINE    g_wc          STRING,
          g_str         STRING,
          g_sql         STRING,
          l_table       STRING
#FUN-C30298 add START
DEFINE   g_chk_azp01     LIKE type_file.chr1
DEFINE   g_chk_auth      STRING
DEFINE   g_azp01         LIKE azp_file.azp01
DEFINE   g_azp01_str     STRING
#FUN-C30298 add END 
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
                "oga02.oga_file.oga02,",
                "ogb01.ogb_file.ogb01,",
                "oga98.oga_file.oga98,",
                "ogb03.ogb_file.ogb03,",
                "ogb04.ogb_file.ogb04,",
                "ogb06.ogb_file.ogb06,",
                "ogb37.ogb_file.ogb37,",
                "ogb12.ogb_file.ogb12,",
                "ogb47.ogb_file.ogb47,",
       #         "ohb67.ohb_file.ohb67",  #FUN-BA0074 mark
                "ogb14t.ogb_file.ogb14t,", #FUN-BA0074 add
                "ogb14.ogb_file.ogb14"     #FUN-BA0074 add
                
   LET l_table = cl_prt_temptable('artr144',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?,   ?, ?, ?, ?, ?,   ?, ?, ?)"
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   CALL r144_tm(0,0)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION r144_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
DEFINE p_row,p_col    LIKE type_file.num5,
       l_cmd          LIKE type_file.chr1000,
       l_str          STRING
#FUN-C30298 add START
DEFINE tok            base.StringTokenizer
DEFINE l_zxy03        LIKE zxy_file.zxy03
#FUN-C30298 add END       

   IF p_row = 0 THEN LET p_row = 6 LET p_col = 14 END IF
   OPEN WINDOW r144_w AT p_row,p_col WITH FORM "art/42f/artr144"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   WHILE TRUE
      DISPLAY BY NAME tm.more 
      CONSTRUCT tm.wc ON azw01,rtz10,oga02
         FROM operating,city,oga02
           
         BEFORE CONSTRUCT
             CALL cl_qbe_init()

        #FUN-C30298 add START
         AFTER FIELD operating
            LET g_chk_azp01 = TRUE
            LET g_azp01_str = GET_FLDBUF(operating)
            LET g_chk_auth = ''
            IF NOT cl_null(g_azp01_str) AND g_azp01_str <> "*" THEN
               LET g_chk_azp01 = FALSE
               LET tok = base.StringTokenizer.create(g_azp01_str,"|")
               LET g_azp01 = ""
               WHILE tok.hasMoreTokens()
                  LET g_azp01 = tok.nextToken()
                  SELECT zxy03 INTO l_zxy03 FROM zxy_file WHERE zxy01 = g_user AND zxy03 = g_azp01
                  IF STATUS THEN
                     CONTINUE WHILE
                  ELSE
                     IF g_chk_auth IS NULL THEN
                        LET g_chk_auth = "'",l_zxy03,"'"
                     ELSE
                        LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
                     END IF
                  END IF
               END WHILE
               IF g_chk_auth IS NOT NULL THEN
                  LET g_chk_auth = "(",g_chk_auth,")"
               END IF
            END IF

            IF g_chk_azp01 THEN
               DECLARE r450_zxy_cs1 CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
               FOREACH r450_zxy_cs1 INTO l_zxy03
                 IF g_chk_auth IS NULL THEN
                    LET g_chk_auth = "'",l_zxy03,"'"
                 ELSE
                    LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
                 END IF
               END FOREACH
               IF g_chk_auth IS NOT NULL THEN
                  LET g_chk_auth = "(",g_chk_auth,")"
               END IF
            END IF
        #FUN-C30298 add END
              
         ON ACTION controlp
            CASE
               WHEN INFIELD(operating)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_azw"
                 #LET g_qryparam.where = " azw01 IN ",g_auth  #FUN-C30298 mark
                  LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"  #FUN-C30298 add
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
         CLOSE WINDOW r144_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM 
      END IF

      IF tm.wc= " 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF

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
         CLOSE WINDOW r144_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM 
      END IF
      CALL cl_wait()
      CALL artr144()
      ERROR ""
   END WHILE
   CLOSE WINDOW r144_w
END FUNCTION
 
FUNCTION artr144()
   DEFINE l_str          STRING,
          l_sql          STRING
   DEFINE l_azi04        LIKE azi_file.azi04
   DEFINE sr          RECORD
      operating          LIKE azw_file.azw01,
      opname             LIKE azw_file.azw08,
      oga02              LIKE oga_file.oga02,
      ogb01              LIKE ogb_file.ogb01,
      oga98              LIKE oga_file.oga98,
      ogb03              LIKE ogb_file.ogb03,
      ogb04              LIKE ogb_file.ogb04,
      ogb06              LIKE ogb_file.ogb06,
      ogb37              LIKE ogb_file.ogb37,
      ogb12              LIKE ogb_file.ogb12,
      ogb47              LIKE ogb_file.ogb47,
   #   ohb67              LIKE ohb_file.ohb67       #FUN-BA0074 mark
      ogb14t             LIKE ogb_file.ogb14t,      #FUN-BA0074 add
      ogb14              LIKE ogb_file.ogb14        #FUN-BA0074 add      
                      END RECORD
   DEFINE sr1         RECORD
      azw01              LIKE azw_file.azw01,
      azw08              LIKE azw_file.azw08,
      rtz10              LIKE rtz_file.rtz10
                      END RECORD
 
     CALL cl_del_data(l_table)
     LET l_sql = "SELECT DISTINCT azw01,azw08,rtz10 FROM azw_file,rtz_file ",
                " WHERE azw01 = rtz01  ",
               #" AND azw01 IN ",g_auth,  #FUN-C30298 mark
                " AND azw01 IN ",g_chk_auth,  #FUN-C30298 add  
                " ORDER BY azw01 "
     PREPARE r144_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE r144_cs1 CURSOR FOR r144_prepare1
     FOREACH r144_cs1 INTO sr1.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET tm.wc = cl_replace_str(tm.wc,"oha02","oga02")
       LET l_sql = 
     #     " SELECT '','',oga02,ogb01,oga98,ogb03,ogb04,ogb06,ogb37,ogb12,ogb47,'' ",        #FUN-BA0074 mark
          " SELECT '','',oga02,ogb01,oga98,ogb03,ogb04,ogb06,ogb37,ogb12,ogb47,ogb14t,ogb14 ",  #FUN-BA0074 add
          "   FROM ",cl_get_target_table(sr1.azw01,'oga_file'),",",
                     cl_get_target_table(sr1.azw01,'ogb_file'),",",
                     cl_get_target_table(sr1.azw01,'azw_file'),",",
                     cl_get_target_table(sr1.azw01,'rtz_file'),
          #"  WHERE oga00 = '1' ",
          "  WHERE oga09 IN ('2','3','4','6')",   #TQC-B70078 修改銷售金額選取條件
          #"    AND ogb14t > 0 ",      #TQC-B70078 一併顯示銷退金額
          "    AND oga01 = ogb01 ",
          "    AND ogapost = 'Y' ", 
          "    AND ogaplant = azw01 ",
          "    AND ogaplant ='",sr1.azw01,"'",
         #"    AND azw01 IN ",g_auth,   #FUN-C30298 mark
          "    AND azw01 IN ",g_chk_auth,   #FUN-C30298 add
          "    AND rtz01 = azw01 ",
          "    AND ",tm.wc
       LET tm.wc = cl_replace_str(tm.wc,"oga02","oha02")       
       LET l_sql = l_sql,
#         "   UNION SELECT '','',oha02,ohb01,oha98,ohb03,ohb04,ohb06,ohb37,ohb12*(-1),ohb67*(-1),'' ",   #TQC-B70204 mark
#          "   UNION ALL SELECT '','',oha02,ohb01,oha98,ohb03,ohb04,ohb06,ohb37,ohb12*(-1),ohb67*(-1),'' ",  #TQC-B70204     #FUN-BA0074 mark
          "   UNION ALL SELECT '','',oha02,ohb01,oha98,ohb03,ohb04,ohb06,ohb37,ohb12*(-1),ohb67*(-1),ohb14t*(-1),ohb14*(-1) ",  #FUN-BA0074 add 
          "   FROM ",cl_get_target_table(sr1.azw01,'oha_file'),",",
                     cl_get_target_table(sr1.azw01,'ohb_file'),",",   
                     cl_get_target_table(sr1.azw01,'azw_file'),",",
                     cl_get_target_table(sr1.azw01,'rtz_file'),
          #"  WHERE oha05 = '1' ",      #TQC-B70078 修改銷售金額選取條件 
          "  WHERE oha05 IN ('1','2')",
          #"    AND ohb14t < 0 ",       #TQC-B70078 一併顯示銷退金額
          "    AND oha01 = ohb01",
          "    AND ohapost = 'Y' ",
          "    AND ohaplant = azw01 ",
          "    AND ohaplant = '",sr1.azw01,"'",
         #"    AND azw01 IN ",g_auth,  #FUN-C30298 mark
          "    AND azw01 IN ",g_chk_auth,  #FUN-C30298 ad  
          "    AND rtz01 = azw01 ",
          "    AND ",tm.wc
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       PREPARE sel_pre FROM l_sql
       DECLARE sel_cs CURSOR FOR sel_pre
       FOREACH sel_cs INTO sr.*
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          LET sr.operating = sr1.azw01 
          LET sr.opname = sr1.azw08
    #      LET sr.ohb67 = sr.ogb37 * sr.ogb12 - sr.ogb47   #FUN-BA0074 mark
          EXECUTE insert_prep USING sr.*
          INITIALIZE sr.* TO NULL
       END FOREACH
       INITIALIZE sr1.* TO NULL
     END FOREACH
 
     SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = g_aza.aza17
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " ORDER BY operating,oga02,ogb01,ogb03"
     LET g_str = ''
    #LET g_str = tm.wc,";",l_azi04,";"  #FUN-BC0026 mark
  #FUN-BC0026 add START
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'azw01,rtz10,oga02')
        RETURNING tm.wc
        LET g_str = tm.wc,";",l_azi04,";"
        IF g_str.getLength() > 1000 THEN
           LET g_str = g_str.subString(1,600)
           LET g_str = g_str,"..."
        END IF
     END IF
     LET g_str = g_str,";",l_azi04,";"
  #FUN-BC0026 add END
     CALL cl_prt_cs3('artr144','artr144',l_sql,g_str)
END FUNCTION

#FUN-B60148
