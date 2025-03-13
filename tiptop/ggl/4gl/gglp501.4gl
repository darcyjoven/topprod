# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: gglp501.4gl
# Descriptions...: 現金流量表直接法资料导入
# Date & Author..: 2010/11/12 By wuxj  
# Modify.........: NO.FUN-B40104 11/05/05 By jll 报表合并作业
# Modify.........: NO.TQC-B60373 11/06/30 By yinhy 錯誤碼'agl034'改為'agl-262'
# Modify.........: No.FUN-B70003 11/07/08 By lutingting 1.根據agli019設置的現金變動碼對應關係產生資料,依據合併后現金變動碼合併
#                                                       2.匯率按照agli019的設置取,gglp501畫面拿掉匯率取值方式
# Modify.........: No.FUN-B80135 11/08/22 By lujh 相關日期欄位不可小於關帳日期 
# Modify.........: NO.FUN-BB0037 11/11/22 By lilingyu 合併報表移植
# Modify.........: NO.TQC-C40010 12/04/05 By lujh 把必要字段controlz換成controlr

DATABASE ds

GLOBALS "../../config/top.global"    #FUN-BB0037
DEFINE tm  RECORD
	      a       LIKE atd_file.atd01, 
	      b       LIKE type_file.chr20,
	      c       LIKE aaa_file.aaa01, 
	      d       LIKE atd_file.atd02,
	      y       LIKE atd_file.atd03, 
	      m       LIKE atd_file.atd04
	      ,e       LIKE type_file.chr1   #FUN-B70003
	  END RECORD
DEFINE tm1 RECORD
	      wc      LIKE type_file.chr1000
	   END RECORD
DEFINE g_dept         DYNAMIC ARRAY OF RECORD
		      asa01      LIKE asa_file.asa01,  #族群代號
		      asa02      LIKE asa_file.asa02,  #合併個體
		      asa03      LIKE asa_file.asa03,  #合併個體帳別
		      asz01     LIKE asz_file.asz01, #合併帳別
		      asg06      LIKE asg_file.asg06   #記帳幣別
		      END RECORD
DEFINE    g_before_input_done  LIKE type_file.num5 
DEFINE    p_cmd                LIKE type_file.chr1 
DEFINE    g_msg                LIKE type_file.chr1000 
DEFINE    g_success            LIKE type_file.chr1 
DEFINE    g_str                STRING
DEFINE    g_sql                STRING
DEFINE    g_aaa03              LIKE aaa_file.aaa03
DEFINE    g_dbs_gl             LIKE azp_file.azp03
DEFINE    g_dbs_asg03          LIKE azp_file.azp03
DEFINE    g_flag               LIKE type_file.chr1 
DEFINE    g_aaa07              LIKE aaa_file.aaa07          #No.FUN-B80135
DEFINE    g_year               LIKE type_file.chr4          #No.FUN-B80135
DEFINE    g_month              LIKE type_file.chr2          #No.FUN-B80135
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT          

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   #FUN-B80135--add--str--
   SELECT aaa07 INTO g_aaa07 FROM aaa_file,asz_file
    WHERE aaa01 = asz01 AND asz00 = '0' 
   LET g_year = YEAR(g_aaa07)
   LET g_month= MONTH(g_aaa07) 
   #FUN-B80135--add--end

   IF cl_null(tm.c) THEN LET tm.c=g_aza.aza81 END IF

   CALL p009_tm()           

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION p009_tm()
   DEFINE li_chk_bookno  LIKE type_file.num5  
   DEFINE p_row,p_col    LIKE type_file.num5,
	  l_sw           LIKE type_file.chr1, 
	  l_cmd          LIKE type_file.chr1000  
   DEFINE l_n            LIKE type_file.num5
   DEFINE l_asa02        LIKE asa_file.asa02
   DEFINE l_asa03        LIKE asa_file.asa03

   CALL s_dsmark(tm.c) 
   LET p_row = 4 LET p_col = 4
   OPEN WINDOW p009_w1 AT p_row,p_col
     WITH FORM "ggl/42f/gglp501"  ATTRIBUTE (STYLE = g_win_style CLIPPED)                                     
  CALL cl_ui_init()
  CALL s_shwact(0,0,tm.c)                      
  CALL cl_set_comp_visible('d',FALSE)  
  #使用預設帳別之幣別
  SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.c                        
  IF SQLCA.sqlcode THEN
     CALL cl_err3("sel","aaa_file",tm.c,"",SQLCA.sqlcode,"","sel aaa:",0)                            
  END IF
  INITIALIZE tm.* TO NULL                                                    

  #LET tm.e = '1'    #FUN-B70003
  WHILE TRUE

     #INPUT BY NAME tm.a,tm.b,tm.c,tm.d,tm.y,tm.m,tm.e WITHOUT DEFAULTS   #FUN-B70003
     INPUT BY NAME tm.a,tm.b,tm.c,tm.d,tm.y,tm.m WITHOUT DEFAULTS         #FUN-B70003

        ON ACTION locale
           LET g_action_choice = "locale"
         CALL cl_show_fld_cont()              

        BEFORE INPUT
           CALL cl_set_comp_entry("b,c",FALSE)
           #LET tm.e = '1'    #FUN-B70003
           CALL cl_qbe_init()

        #No.FUN-B80135--mark--str--
        #AFTER FIELD y
        #   IF NOT cl_null(tm.y) THEN
        #      IF tm.y = 0 THEN
        #         NEXT FIELD y
        #      END IF
        #   END IF
        #No.FUN-B80135--mark--end

        #No.FUN-B80135--add--str--
        AFTER FIELD y
        IF NOT cl_null(tm.y) THEN
           IF tm.y < 0 THEN
              CALL cl_err(tm.y,'apj-035',0)
             NEXT FIELD y
           END IF
           IF tm.y<g_year THEN
              CALL cl_err(tm.y,'atp-164',0)
              NEXT FIELD y
           ELSE
              IF tm.y=g_year AND tm.m<=g_month THEN
                 CALL cl_err('','atp-164',0)
                 NEXT FIELD m
              END IF
           END IF 
        END IF
        #No.FUN-B80135--add--end   

        AFTER FIELD m
           IF NOT cl_null(tm.m) THEN
              SELECT azm02 INTO g_azm.azm02 FROM azm_file
               WHERE azm01 = tm.y
              IF g_azm.azm02 = '1' THEN
                 IF tm.m > 12 OR tm.m < 1 THEN
                    CALL cl_err('','agl-020',0)
                    NEXT FIELD m
                 END IF
              ELSE
                 IF tm.m > 13 OR tm.m < 1 THEN
                    CALL cl_err('','agl-020',0)
                    NEXT FIELD m
                 END IF
              END IF
              #FUN-B80135--add--str--
              IF NOT cl_null(tm.y) AND tm.y=g_year 
              AND tm.m<=g_month THEN
                  CALL cl_err('','atp-164',0)
                  NEXT FIELD m
              END IF 
              #FUN-B80135--add--end
           END IF

        AFTER FIELD a
           IF NOT cl_null(tm.a) THEN
              SELECT COUNT(*) INTO l_n FROM asa_file WHERE asa01 = tm.a AND asa04 = 'Y'
              IF l_n = 0 THEN
                 CALL cl_err(tm.a,100,0)
                 NEXT FIELD a
              END IF
              SELECT asa02,asa03 INTO l_asa02,l_asa03 FROM asa_file WHERE asa01 = tm.a AND asa04 = 'Y'
              LET tm.b = l_asa02
              LET tm.c = l_asa03
              DISPLAY l_asa02 TO FORMONLY.b
              DISPLAY l_asa03 TO FORMONLY.c
           ELSE
              NEXT FIELD a
           END IF

        AFTER FIELD d
          IF NOT cl_null(tm.d) THEN
             SELECT COUNT(*) INTO l_n FROM asg_file WHERE asg01 = tm.d
             IF l_n = 0 THEN
                #CALL cl_err(tm.d,'agl034',0)  #No.TQC-B60373
                CALL cl_err(tm.d,'agl-262',0)  #No.TQC-B60373
                NEXT FIELD d
             END IF
          END IF

        AFTER INPUT
           IF INT_FLAG THEN
              EXIT INPUT
           END IF

        #ON ACTION CONTROLZ    #TQC-C40010  mark
         ON ACTION CONTROLR    #TQC-C40010  add
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

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

        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(a)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_asa1"
                 LET g_qryparam.default1 = tm.a
                 CALL cl_create_qry() RETURNING tm.a
                 DISPLAY tm.a TO a
                 NEXT FIELD a
              WHEN INFIELD(d)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_asg1"
                 LET g_qryparam.default1 = tm.d
                 CALL cl_create_qry() RETURNING tm.d
                 DISPLAY tm.d TO d
                 NEXT FIELD d
           END CASE
        ON ACTION qbe_select
           CALL cl_qbe_select()

        ON ACTION qbe_save
           CALL cl_qbe_save()

     END INPUT

     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p009_w1
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   
        EXIT PROGRAM
     END IF

     CONSTRUCT BY NAME tm1.wc ON asg01 

     BEFORE CONSTRUCT
        CALL cl_qbe_init()

     ON ACTION CONTROLP
       CASE
           WHEN INFIELD(asg01) 
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_asg"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO asg01
              NEXT FIELD asg01   
        END CASE


     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT

     ON ACTION about
        CALL cl_about()

     ON ACTION help
        CALL cl_show_help()
     
     ON ACTION controlg
        CALL cl_cmdask()

     ON ACTION exit                            #加離開功能
        LET INT_FLAG = 1
        EXIT CONSTRUCT

     ON ACTION qbe_select
        CALL cl_qbe_select()

    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW p009_w1
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       EXIT PROGRAM
    END IF
     CALL p009()
     IF g_success = 'Y' THEN
        CALL cl_end2(1) RETURNING g_flag
     ELSE
        CALL cl_end2(2) RETURNING g_flag
     END IF
     IF g_flag THEN
        CONTINUE WHILE
     ELSE
        CLOSE WINDOW p009_w1
        EXIT WHILE
     END IF
  END WHILE
  CLOSE WINDOW p009_w1
END FUNCTION

FUNCTION p009()
DEFINE l_sql     STRING                    
DEFINE l_atd     RECORD LIKE atd_file.*
DEFINE sr        RECORD
       tib08     LIKE tib_file.tib08,
       tib09     LIKE tib_file.tib09,
       abb37     LIKE abb_file.abb37,
       tib05     LIKE tib_file.tib05,
       nml03     LIKE nml_file.nml03 
                 END RECORD
DEFINE l_asg01   LIKE asg_file.asg01
DEFINE l_azj02   LIKE azj_file.azj02
DEFINE l_azk02   LIKE azk_file.azk02
DEFINE l_flag    LIKE type_file.chr1
DEFINE g_no      LIKE type_file.num5  
DEFINE i         LIKE type_file.num5 
DEFINE l_asg03   LIKE asg_file.asg03
DEFINE l_tib05   LIKE tib_file.tib05 
DEFINE l_cnt     LIKE type_file.num5 
DEFINE l_tib08   LIKE tib_file.tib08 
DEFINE l_abb37   LIKE abb_file.abb37
#FUN-B70003--add--str--
DEFINE l_ath    RECORD
       ath06    LIKE ath_file.ath06,   #合併后現金變動碼
       atg02     LIKE atg_file.atg02,     #說明
       atg03     LIKE atg_file.atg03,     #變動分類
       ath07    LIKE ath_file.ath07,   #再衡量匯率類型
       ath08    LIKE ath_file.ath08    #換算匯率類型
                 END RECORD
#FUN-B70003--add--end

   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.c
   SELECT azi04 INTO t_azi04
     FROM azi_file WHERE azi01 = g_aaa03

    LET g_no = 1
    FOR g_no = 1 TO 300
        INITIALIZE g_dept[g_no].* TO NULL
    END FOR

    LET l_sql = "SELECT asg01 ",
                "  FROM asg_file",
                " WHERE ",tm1.wc CLIPPED
    PREPARE p009_asg_p FROM l_sql
    DECLARE p009_asg_c CURSOR FOR p009_asg_p
    LET g_no = 1
    FOREACH p009_asg_c INTO l_asg01
        LET l_sql=" SELECT UNIQUE asa01,asa02,asa03",
                  "   FROM asa_file ",
                  "  WHERE asa01='",tm.a,"'",
                  "    AND asa02 = '",l_asg01,"'",  
                  "  UNION ",
                  " SELECT UNIQUE asa01,asb04,asb05",
                  "   FROM asb_file,asa_file ",
                  "  WHERE asa01=asb01 AND asa02=asb02",
                  "    AND asa01='",tm.a,"'",
                  "    AND asb04 = '",l_asg01,"'", 
                  "  ORDER BY 1,2 "
        PREPARE p009_asa_p FROM l_sql
        IF STATUS THEN
           CALL cl_err('prepare:1',STATUS,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time
           EXIT PROGRAM
        END IF
        DECLARE p009_asa_c CURSOR FOR p009_asa_p
        FOREACH p009_asa_c INTO g_dept[g_no].*
           #合併帳別
           CALL s_aaz641_asg(g_dept[g_no].asa01,g_dept[g_no].asa02)
           RETURNING g_dbs_asg03
           CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING g_dept[g_no].asz01
           DELETE FROM atd_file WHERE atd01 = g_dept[g_no].asa01 AND atd02 = g_dept[g_no].asa02 
                                  AND atd03 = tm.y AND atd04 = tm.m 
           LET g_no=g_no+1
        END FOREACH
    END FOREACH
    LET g_no=g_no-1
    BEGIN WORK 
    LET g_success = 'Y'
    FOR i = 1 TO g_no

       SELECT asg03 INTO l_asg03 FROM asg_file WHERE asg01=g_dept[i].asa02
       SELECT azp03 INTO g_dbs_new FROM azp_file WHERE azp01 = l_asg03
       IF STATUS THEN LET g_dbs_new = NULL END IF
       IF NOT cl_null(g_dbs_new) THEN
          LET g_dbs_new=g_dbs_new CLIPPED,'.'
       END IF
       LET g_dbs_gl = g_dbs_new CLIPPED
       LET l_atd.atd02 = g_dept[i].asa02  
       #合併帳別
       CALL s_aaz641_asg(g_dept[i].asa01,g_dept[i].asa02)
       RETURNING g_dbs_asg03
       CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING g_dept[i].asz01
       LET l_sql = "SELECT SUM(tic07),tic06,tic08,tic03,nml03",
                   "  FROM ",cl_get_target_table(l_asg03,'tic_file,'),
                             cl_get_target_table(l_asg03,'nml_file'),
                   " WHERE tic00 = '",g_dept[i].asa03,"'",
                   "   AND nml01 = tic06 ",
                   "   AND tic01 = '",tm.y,"' AND tic02 = '",tm.m,"'",
                   " GROUP BY tic06,tic08,tic03,nml03"        
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       CALL cl_parse_qry_sql(l_sql,l_asg03) RETURNING l_sql  #FUN-B40104
      PREPARE tia_pre FROM l_sql
      DECLARE tia_cs CURSOR FOR tia_pre
      LET l_atd.atd01 = tm.a
      LET l_atd.atd03 = tm.y
      LET l_atd.atd04 = tm.m
#FUN-B70003--mod--str--
#     IF g_aza.aza04 = 'Y' THEN
#        SELECT asg06,asg07 INTO l_atd.atd07,l_atd.atd14
#          FROM asg_file,asa_file WHERE asg01 = asa02 AND asa01 = tm.a 
#     END IF
      LET l_atd.atd07 = g_aaa03
#FUN-B70003--mod--end
      SELECT asg06,asg07 INTO l_atd.atd10,l_atd.atd14   #FUN-B70003 add atd14
        FROM asg_file WHERE asg01 = l_atd.atd02
      LET l_atd.atd11 = '1'  

      FOREACH tia_cs INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         LET l_atd.atd05 = sr.tib09
         #FUN-B70003--add--str--
         SELECT ath06,atg02,atg03,ath07,ath08 INTO l_ath.*
           FROM ath_file,atg_file
          WHERE ath06 = atg01 AND ath02 = l_atd.atd01 AND ath01 = l_atd.atd02
            AND ath03 = sr.tib09
         IF NOT cl_null(l_ath.ath06) THEN LET l_atd.atd05 = l_ath.ath06 END IF 
         LET l_atd.atd16 = l_ath.atg02
         LET l_atd.atd17 = l_ath.atg03 
         #FUN-B70003--add--end
         LET l_atd.atd09 = sr.tib08
         IF sr.tib05 = '1' THEN
            LET l_tib05 = '2'
         ELSE
            LET l_tib05 = '1'
         END IF 
         IF cl_null(sr.abb37) THEN
            LET l_abb37='XXX'
         ELSE
            LET l_abb37= sr.abb37
         END IF 
         SELECT COUNT(*) INTO l_cnt FROM atd_file
          WHERE atd01 = l_atd.atd01 AND atd02 = l_atd.atd02
            AND atd03 = l_atd.atd03 AND atd04 = l_atd.atd04
            AND atd05 = sr.tib09 AND atd12 = l_abb37 
         IF l_cnt>0 THEN
            CONTINUE FOREACH
         END IF 
         LET l_sql = "SELECT SUM(tib08) ", 
                  "  FROM ",cl_get_target_table(l_asg03,'tia_file,'),   #FUN-B40104
                            cl_get_target_table(l_asg03,'tib_file,'),   #FUN-B40104
                            cl_get_target_table(l_asg03,'aba_file,'),   #FUN-B40104
                            cl_get_target_table(l_asg03,'abb_file'),   #FUN-B40104
                     
                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                  "   AND tia01 = tib01 AND tia02 = tib02 ",
                  "   AND tia05 = tib03 AND tia07 = tib05 ",
                  "   AND tia06 = tib04 ",
                  "   AND aba00 = tia05 AND tia05 = '",g_dept[i].asa03,"' ",
                  "   AND abb03 = tia06 ",
                  "   AND abb01 = tib06 ",
                  "   AND abb02 =tib07 ",
                  "   AND aba03 = '",tm.y,"' AND aba04 = '",tm.m,"'",
                  "   AND tib05 = '",l_tib05,"' AND abb37 = '",sr.abb37,"' and tib09 = '",sr.tib09,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_asg03) RETURNING l_sql  #FUN-B40104
         PREPARE sel_tib08 FROM l_sql
         EXECUTE sel_tib08 INTO l_tib08 
         IF cl_null(l_tib08) THEN LET l_tib08 = 0 END IF 
         IF sr.nml03 = '10' OR sr.nml03 = '20'  OR sr.nml03 = '30' OR sr.nml03 = '40' THEN   #借-贷
            IF l_tib05 = '1' THEN
               LET l_atd.atd09 = l_tib08-sr.tib08
            ELSE
               LET l_atd.atd09 = sr.tib08-l_tib08
            END IF 
         END IF 
         IF sr.nml03 = '11' or sr.nml03 = '21' OR sr.nml03 = '31' THEN   #贷-借
            IF l_tib05 = '1' THEN
               LET l_atd.atd09 = sr.tib08-l_tib08
            ELSE
               LET l_atd.atd09 = l_tib08-sr.tib08
            END IF
         END IF 
        #FUN-B70003--mod--str--
        #IF l_atd.atd07<>g_aaa03 THEN   ###個體公司幣別和合併幣別不相同    #
        #   CASE tm.e  
         IF l_atd.atd10<>g_aaa03 THEN   ###個體公司幣記賬別和合併幣別不相同    #
            CASE l_ath.ath07
        #FUN-B70003--mod--end
              WHEN 1
                 SELECT ase05 INTO l_atd.atd08 FROM ase_file WHERE ase01 = l_atd.atd03
                    AND ase02 = l_atd.atd04 AND ase03 = l_atd.atd10 AND ase04 = l_atd.atd14
              WHEN 2
                 SELECT ase06 INTO l_atd.atd08 FROM ase_file WHERE ase01 = l_atd.atd03
                    AND ase02 = l_atd.atd04 AND ase03 = l_atd.atd10 AND ase04 = l_atd.atd14
              WHEN 3
                 SELECT ase07 INTO l_atd.atd08 FROM ase_file WHERE ase01 = l_atd.atd03
                    AND ase02 = l_atd.atd04 AND ase03 = l_atd.atd10 AND ase04 = l_atd.atd14
              OTHERWISE
            END CASE
         ELSE
            LET l_atd.atd08 = 1
         END IF 
         IF l_atd.atd14<>g_aaa03 THEN   ###個體功能幣別和合併幣別不相同
        #   CASE tm.e               #FUN-B70003
            CASE l_ath.ath08      #FUN-B70003
              WHEN 1
                 SELECT ase05 INTO l_atd.atd15 FROM ase_file WHERE ase01 = l_atd.atd03
                    #AND ase02 = l_atd.atd04 AND ase03 = l_atd.atd07 AND ase04 = l_atd.atd14   #FUN-B70003
                    AND ase02 = l_atd.atd04 AND ase03 = l_atd.atd14 AND ase04 = l_atd.atd07
              WHEN 2
                 SELECT ase06 INTO l_atd.atd15 FROM ase_file WHERE ase01 = l_atd.atd03
                    #AND ase02 = l_atd.atd04 AND ase03 = l_atd.atd07 AND ase04 = l_atd.atd14   #FUN-B70003
                    AND ase02 = l_atd.atd04 AND ase03 = l_atd.atd14 AND ase04 = l_atd.atd07
              WHEN 3
                 SELECT ase07 INTO l_atd.atd15 FROM ase_file WHERE ase01 = l_atd.atd03
                    #AND ase02 = l_atd.atd04 AND ase03 = l_atd.atd07 AND ase04 = l_atd.atd14   #FUN-B70003
                    AND ase02 = l_atd.atd04 AND ase03 = l_atd.atd14 AND ase04 = l_atd.atd07
              OTHERWISE
            END CASE
         ELSE
            LET l_atd.atd15 = 1
         END IF
         IF cl_null(l_atd.atd08) THEN LET l_atd.atd08 = 1 END IF
         IF cl_null(l_atd.atd15) THEN LET l_atd.atd15 = 1 END IF #FUN-B70003
         LET l_atd.atd13 = l_atd.atd09*l_atd.atd08
         LET l_atd.atd06 = l_atd.atd13*l_atd.atd15
         #LET l_atd.atd06 = l_atd.atd09 * l_atd.atd08 
         LET l_atd.atd09 = cl_digcut(l_atd.atd09,t_azi04)
         LET l_atd.atd06 = cl_digcut(l_atd.atd06,t_azi04)
         LET l_atd.atd13 = cl_digcut(l_atd.atd13,t_azi04)
         LET l_atd.atd12 = sr.abb37  
         IF cl_null(l_atd.atd12) THEN LET l_atd.atd12 = 'XXX' END IF 
         IF cl_null(l_atd.atd05) THEN LET l_atd.atd05 = ' ' END IF
         LET l_atd.atdlegal=g_legal        #NO.FUN-B40104  #所属法人

         #FUN-B80135--add--str--
         IF l_atd.atd03 < g_year OR (l_atd.atd03 = g_year AND l_atd.atd04<=g_month) THEN 
            LET g_showmsg=l_atd.atd03,"/",l_atd.atd04
            CALL s_errmsg('atd03,atd04',g_showmsg,'','atp-164',1)
         END IF 
         #FUN-B80135--add--end
         
         INSERT INTO atd_file VALUES(l_atd.*)
#FUN-B70003--add--str--
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
            UPDATE atd_file SET atd09 = atd09+l_atd.atd09,
                                atd13 = atd13+l_atd.atd13,
                                atd06 = atd06+l_atd.atd06
             WHERE atd01 = l_atd.atd01
               AND atd02 = l_atd.atd02
               AND atd03 = l_atd.atd03
               AND atd04 = l_atd.atd04
               AND atd05 = l_atd.atd05
               AND atd12 = l_atd.atd12
#FUN-B70003--add--end
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('atd01',l_atd.atd01,'upd_atd',STATUS,1)  
               LET g_success = 'N' 
               CONTINUE FOREACH
            END IF
         END IF 
         LET l_flag = 'Y'
      END FOREACH     
   END FOR
   CALL s_showmsg()  
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      IF l_flag = 'Y' THEN 
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF   
   END IF
END FUNCTION
#NO.FUN-B40104
