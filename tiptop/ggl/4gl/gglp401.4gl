# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: gglp401.4gl
# Descriptions...: 上报程序 (整批資料處理作業)
# Date & Author..: #FUN-B50001 11/05/05 by  zhangweib 
# Modify.........: No.TQC-B60373 11/06/30 By yinhy 錯誤碼'agl-246'改為'aap-129'
# Modify.........: No.TQC-B70142 11/07/19 By guoch g_dbs_a抓取時有誤
# Modify.........: No.FUN-B70062 11/07/26 By guoch 上层公司族群编号栏位开窗
# Modify.........: No.FUN-B80135 11/08/22 By lujh 相關日期欄位不可小於關帳日期 
# Modify.........: No.FUN-B90025 11/09/04 By lutingting asilegal,asioriu,asiorig给值
# Modify.........: No.FUN-B90045 11/09/05 By lutingting SQL錯誤
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植
# Modify.........: NO.TQC-C40010 12/04/05 By lujh 把必要字段controlz換成controlr

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm      RECORD                      #FUN-BB0036
                a  LIKE azp_file.azp01,   #集团公司营运中心
                b  LIKE asa_file.asa01,   #集团公司族群编号 
                c  LIKE asz_file.asz01,  #族群帐套
                h  LIKE asa_file.asa02,   #上传人所在公司编号
                d  LIKE type_file.num5,   #会计年度
                e  LIKE type_file.num5,   #期别
                f  LIKE gen_file.gen01,   #上传人编号     #暂时不用
                g  LIKE asa_file.asa01    #上传人族群编号  
               END RECORD,
       close_y,close_m LIKE type_file.num5,   #closing year & month
       l_yy,l_mm       LIKE type_file.num5,
       b_date          LIKE type_file.dat,    #期間起始日期
       e_date          LIKE type_file.dat,    #期間起始日期
       g_bookno        LIKE aea_file.aea00    #帳別
DEFINE ls_date         STRING,
       l_flag          LIKE type_file.chr1,
       g_change_lang   LIKE type_file.chr1
DEFINE g_dbs_a         LIKE azp_file.azp03    #集团营运中心对应DB
DEFINE g_sql           STRING                 
DEFINE g_asz01         LIKE asz_file.asz01
DEFINE g_aaa07         LIKE aaa_file.aaa07    #No.FUN-B80135
DEFINE g_year          LIKE type_file.chr4    #No.FUN-B80135
DEFINE g_month         LIKE type_file.chr2    #No.FUN-B80135

MAIN

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   LET g_bookno = ARG_VAL(1)
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.a    = ARG_VAL(2)                   #集团公司营运中心
   LET tm.b    = ARG_VAL(3)                   #集团公司族群编号
   LET tm.c    = ARG_VAL(3)                   #族群帐套
   LET tm.d    = ARG_VAL(4)                   #会计年度
   LET tm.e    = ARG_VAL(5)                   #期别
   LET tm.f    = ARG_VAL(6)                   #上传人编号        #暂时不用
   LET tm.g    = ARG_VAL(7)                   #上传人族群编号    #暂时不用
   LET g_bgjob     = ARG_VAL(8)
   LET tm.h    = ARG_VAL(9)
   IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   
   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      SELECT aaz64 INTO g_bookno FROM aaz_file
   END IF
   WHILE TRUE
      LET g_change_lang = FALSE
      IF g_bgjob = 'N' THEN
         CALL gglp401_tm(0,0)
         IF cl_sure(21,21) THEN
            CALL cl_wait()
            LET g_success = 'Y'
            BEGIN WORK
            CALL s_showmsg_init()
            CALL p008()
            CALL s_showmsg()     
            IF g_success='Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW gglp401_w
               EXIT WHILE
            END IF
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p008()
         CALL s_showmsg()
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END  IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION gglp401_tm(p_row,p_col)
   DEFINE  p_row,p_col     LIKE type_file.num5      
   DEFINE  lc_cmd          LIKE type_file.chr1000  
   DEFINE  l_cnt           LIKE type_file.num5
   DEFINE  l_azm02         LIKE azm_file.azm02

   CALL s_dsmark(g_bookno)

   LET p_row = 4 LET p_col = 26

   OPEN WINDOW gglp401_w AT p_row,p_col WITH FORM "ggl/42f/gglp401" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
   CALL cl_set_comp_visible("f",FALSE)
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('q')
   WHILE TRUE 
      IF s_shut(0) THEN RETURN END IF
      CLEAR FORM 
      INITIALIZE tm.* TO NULL			# Defaealt condition

      SELECT azp03 INTO g_dbs_a FROM azp_file WHERE azp01 = tm.a
      CALL s_dbstring(g_dbs_a) RETURNING g_dbs_a

      LET g_bgjob = 'N'
      INPUT tm.a,tm.b,tm.c,tm.h,tm.d,tm.e,tm.f,tm.g,g_bgjob WITHOUT DEFAULTS 
       FROM a,b,c,h,d,e,f,g,g_bgjob    #FUN-B90045 

         AFTER FIELD a    #集团营运中心
            IF cl_null(tm.a) THEN
               NEXT FIELD a
            ELSE
               SELECT azp01 FROM azp_file WHERE azp01 = tm.a 
               IF STATUS = 100 THEN
                  CALL cl_err(tm.a,'aap-025',0)
                  NEXT FIELD a
               END IF 
               
             #TQC-B70142 --beatk
               LET g_dbs_a = tm.a
             #TQC-B70142 --end
               
               LET g_sql = "SELECT asz01 FROM ",cl_get_target_table(g_dbs_a,'asz_file')
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,g_dbs_a) RETURNING g_sql
               PREPARE sel_asz01 FROM g_sql
               EXECUTE sel_asz01 INTO tm.c
               IF cl_null(tm.c) THEN
                  CALL cl_err(tm.a,'agl-601',0)
                  NEXT FIELD b
               END IF
               DISPLAY tm.c TO FORMONLY.c
            END IF 

         AFTER FIELD b    #集团族群编号
            IF NOT cl_null(tm.b) THEN
               LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_dbs_a,'asa_file'), 
                           " WHERE asa01 = '",tm.b,"'" 
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,g_dbs_a) RETURNING g_sql
               PREPARE sel_asa01 FROM g_sql
               EXECUTE sel_asa01 INTO l_cnt
               IF l_cnt<1 THEN
                  #CALL cl_err(tm.b,'agl-246',0)  #No.TQC-B60373
                  CALL cl_err(tm.b,'aap-129',0)   #No.TQC-B60373
                  NEXT FIELD b
               END IF 
            ELSE
               NEXT FIELD b
            END IF

         #FUN-B80135--add--str--
         AFTER FIELD d
            LET g_sql ="SELECT aaa07 ",  
                       "  FROM ",cl_get_target_table(g_dbs_a,'aaa_file'),
                       "  WHERE aaa01='",tm.c,"'" CLIPPED              
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql    
            CALL cl_parse_qry_sql(g_sql,g_dbs_a) RETURNING g_sql  
            PREPARE sel_aaa07 FROM g_sql
            EXECUTE sel_aaa07 INTO g_aaa07
            LET g_year = YEAR(g_aaa07)
            LET g_month= MONTH(g_aaa07) 
            IF NOT cl_null(tm.d) THEN
               IF tm.d < 0 THEN
                  CALL cl_err(tm.d,'apj-035',0)
                  NEXT FIELD d
               END IF
               IF tm.d < g_year THEN
                  CALL cl_err(tm.d,'atp-164',0)
                  NEXT FIELD d
               ELSE
                  IF tm.d = g_year AND tm.e <= g_month THEN
                     CALL cl_err('','atp-164',0)
                     NEXT FIELD e
                  END IF 
               END IF 
            END IF 
         #No.FUN-B80135--add--end  

                         
         AFTER FIELD e    #期别
            IF NOT cl_null(tm.e) THEN
               SELECT azm02 INTO l_azm02 FROM azm_file
                WHERE azm01 = tm.d
               IF l_azm02 = 1 THEN
                  IF tm.e > 12 OR tm.e < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD e
                  END IF
               ELSE
                  IF tm.e > 13 OR tm.e < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD e 
                  END IF
               END IF
               #FUN-B80135--add--str--
               IF NOT cl_null(tm.d) AND tm.d=g_year 
               AND tm.e<=g_month THEN
                  CALL cl_err('','atp-164',0)
                  NEXT FIELD e
               END IF 
              #FUN-B80135--add--end
            ELSE
               NEXT FIELD e
            END IF

         AFTER FIELD g
            IF NOT cl_null(tm.g) THEN
               SELECT COUNT(*) INTO l_cnt FROM asa_file
                WHERE asa01 = tm.g
               IF l_cnt<1 THEN
                  #CALL cl_err(tm.g,'agl-246',0)   #No.TQC-B60373
                  CALL cl_err(tm.g,'aap-129',0)    #No.TQC-B60373
                  NEXT FIELD g
               END IF 
            ELSE
               NEXT FIELD g
            END IF 
            
         AFTER FIELD h
            IF NOT cl_null(tm.h) THEN
               LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_dbs_a,'asb_file'),
                           " WHERE asb01 = '",tm.b,"' AND asb04 = '",tm.h,"'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,g_dbs_a) RETURNING g_sql
               PREPARE sel_asb04_pre FROM g_sql
               DECLARE sel_asb04_cur CURSOR FOR sel_asb04_pre
               EXECUTE sel_asb04_cur INTO l_cnt
               IF l_cnt < 1 THEN
                  #CALL cl_err(tm.h,'agl-444',0)  #No.TQC-B60373
                  CALL cl_err(tm.h,'aap-129',0)   #No.TQC-B60373
                  NEXT FIELD h
               END IF 
            ELSE
               NEXT FIELD h
            END IF 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(a)   #集团公司营运中心
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_azp'
                   LET g_qryparam.default1 = tm.a
                   CALL cl_create_qry() RETURNING tm.a
                   DISPLAY BY NAME tm.a
                   NEXT FIELD a
              #FUN-B70062 --beatk
               WHEN INFIELD(b)
                   CALL q_asa6(FALSE,TRUE,tm.b,g_dbs_a) RETURNING tm.b
                   DISPLAY BY NAME tm.b
                   NEXT FIELD b
              #FUN-B70062 --end
               OTHERWISE EXIT CASE
            END CASE

         #ON ACTION CONTROLZ      #TQC-C40010  mark
          ON ACTION CONTROLR      #TQC-C40010  add
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
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
   
         BEFORE INPUT
            CALL cl_qbe_init()

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()

         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_change_lang = TRUE
            EXIT INPUT

      END INPUT
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW gglp401_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01= 'gglp401'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('gglp401','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " ''",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",   
                         " '",tm.d CLIPPED,"'",  
                         " '",tm.e CLIPPED,"'",  
                         " '",tm.f CLIPPED,"'",
                         " '",tm.g CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('gglp401',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW gglp401_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION p008()
DEFINE l_asi    RECORD LIKE asi_file.*
DEFINE l_atc    RECORD LIKE atc_file.*
DEFINE l_atcc   RECORD LIKE atcc_file.*
DEFINE l_asa02  LIKE asa_file.asa02 
DEFINE l_atcc10 LIKE atcc_file.atcc10
DEFINE l_atcc11 LIKE atcc_file.atcc11
#FUN-B90045--add--str--
DEFINE l_atcc16 LIKE atcc_file.atcc16
DEFINE l_atcc17 LIKE atcc_file.atcc17
DEFINE l_atcc19 LIKE atcc_file.atcc19
DEFINE l_atcc20 LIKE atcc_file.atcc20
#FUN-B90045--add--end

   CALL s_showmsg_init() 
   ### -->1.結轉前先刪除舊資料
   SELECT asz01 INTO g_asz01 FROM asz_file   #下层公司帐别
   LET g_sql= "DELETE FROM ",cl_get_target_table(g_dbs_a,'asi_file'),
              " WHERE asi00 = '",tm.c,"'",    #族群帐别
              "   AND asi01 = '",tm.b,"'",    #族群编号
              "   AND asi06 = '",tm.d,"'",    #年度
              "   AND asi07 = '",tm.e,"'",    #期别
              "   AND asi04 = '",tm.h,"'",    #上层公司 编号
              "   AND asi041 = '",g_asz01,"'" #下层合并帐别  
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_dbs_a) RETURNING g_sql
   PREPARE del_asi FROM g_sql
   EXECUTE del_asi
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('del','asi',tm.c,SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   SELECT asa02 INTO l_asa02 FROM asa_file WHERE asa01 = tm.g
      AND asa04 = 'Y'
   INITIALIZE l_asi.* TO NULL
   INITIALIZE l_atc.* TO NULL
   INITIALIZE l_atcc.* TO NULL

   ### -->2.開始抛砖资料
   DECLARE atc_cs CURSOR FOR 
       SELECT * FROM atc_file 
        WHERE atc00 = g_asz01     #帐别 
          AND atc01 = tm.g         #族群编号
          AND atc02 = l_asa02      #上层公司
          AND atc06 = tm.d         #年度
          AND atc07 = tm.e         #期别

   FOREACH atc_cs INTO l_atc.*
      IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
      END IF                                                     

      IF SQLCA.sqlcode THEN
         LET g_showmsg=g_asz01,"/",tm.g,"/",l_asa02,"/",tm.d,"/",tm.e
         CALL s_errmsg('atc00,atc01,atc02,atc06,atc07',g_showmsg,'(atc_cs1#1:foreach)',SQLCA.sqlcode,1)
         LET g_success='N' RETURN                             
      END IF
       
      LET l_asi.asi00 = tm.c
      LET l_asi.asi01 = tm.b 
      LET g_sql = "SELECT asa02 FROM ",cl_get_target_table(g_dbs_a,'asa_file'),
                  " WHERE asa01 = '",tm.b,"'",
                  "   AND asa04 = 'Y'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_dbs_a) RETURNING g_sql
      PREPARE sel_asa02_1 FROM g_sql
      EXECUTE sel_asa02_1 INTO l_asi.asi02
      LET l_asi.asi03 = tm.c 
      LET l_asi.asi04 = tm.h
      LET l_asi.asi041 =g_asz01  
      LET l_asi.asi05 = l_atc.atc05 
      SELECT aag02 INTO l_asi.asi051 FROM aag_file
       WHERE aag01 = l_asi.asi05 AND aag00 = g_asz01
      LET l_asi.asi06 = tm.d
      LET l_asi.asi07 = tm.e

      LET l_atcc10 = 0
      LET l_atcc11 = 0
      #FUN-B90045--add--str--
      LET l_atcc16 = 0
      LET l_atcc17 = 0
      LET l_atcc19 = 0
      LET l_atcc20 = 0
      #FUN-B90045--add--end
      SELECT SUM(atcc10),SUM(atcc11) 
            ,SUM(atcc16),SUM(atcc17),SUM(atcc19),SUM(atcc20)   #FUN-B90045
        INTO l_atcc10,l_atcc11 
            ,l_atcc16,l_atcc17,l_atcc19,l_atcc20               #FUN-B90045
        FROM atcc_file
       WHERE atcc00 = g_asz01     #帐别
         AND atcc01 = tm.g         #族群编号
         AND atcc02 = l_asa02      #上层公司
         AND atcc08 = tm.d         #年度
         AND atcc09 = tm.e
         AND atcc05 = l_atc.atc05
         AND (atcc07 IS NOT NULL AND  atcc07 <> ' ')
         AND atcc22 = l_atc.atc20   #FUN-B90045

      IF cl_null(l_atcc10) THEN LET l_atcc10 = 0 END IF 
      IF cl_null(l_atcc11) THEN LET l_atcc11 = 0 END IF 
      #FUN-B90045--add--str--
      IF cl_null(l_atcc16) THEN LET l_atcc16 = 0 END IF 
      IF cl_null(l_atcc17) THEN LET l_atcc17 = 0 END IF 
      IF cl_null(l_atcc19) THEN LET l_atcc19 = 0 END IF 
      IF cl_null(l_atcc20) THEN LET l_atcc20 = 0 END IF 
      #FUN-B90045--add--end
      LET l_asi.asi08 = l_atc.atc08-l_atcc10
      LET l_asi.asi09 = l_atc.atc09-l_atcc11  
      LET l_asi.asi10 = l_atc.atc10
      LET l_asi.asi11 = l_atc.atc11
      LET l_asi.asi12 = l_atc.atc12
      LET l_asi.asi13 = ' '
      LET l_asi.asi14 = ' '
      LET l_asi.asi15 = ' '
      LET l_asi.asi16 = ' '
      LET l_asi.asi17 = ' '
#FUN-B90045--mod--str--
#     LET l_asi.asi18 = l_atc.atc14
#     LET l_asi.asi19 = l_atc.atc15
#     LET l_asi.asi21 = l_atc.atc17
#     LET l_asi.asi22 = l_atc.atc18
      LET l_asi.asi18 = l_atc.atc14-l_atcc16
      LET l_asi.asi19 = l_atc.atc15-l_atcc17
      LET l_asi.asi21 = l_atc.atc17-l_atcc19
      LET l_asi.asi22 = l_atc.atc18-l_atcc20
#FUN-B90045--mod--end
      LET l_asi.asi20 = l_atc.atc16
      LET l_asi.asi23 = l_atc.atc19
      LET l_asi.asi24 = l_atc.atc20
      LET l_asi.asiconf = 'Y'
      LET l_asi.asipost = 'N'
      LET l_asi.asiacti = 'Y'
      LET l_asi.asiuser = g_user
      LET l_asi.asigrup = g_grup
      LET l_asi.asilegal = g_legal   #FUN-B90025
      LET l_asi.asiorig = g_grup     #FUN-B90025
      LET l_asi.asioriu = g_user     #FUN-B90025
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_dbs_a,'asi_file'),
                  "     VALUES(?,?,?,?,?, ?,?,?,?,?,",
                  "            ?,?,?,?,?, ?,?,?,?,?,",
                  "            ?,?,?,?,?, ?,?,?,?,?,",
                  "            ?,?,?,?,?, ?,?)"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_dbs_a) RETURNING g_sql
      PREPARE insert_pre_1 FROM g_sql
      EXECUTE insert_pre_1 USING l_asi.*
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
         LET g_showmsg=tm.c,"/",tm.b,"/",l_asi.asi05,"/",l_asi.asi13
         CALL s_errmsg('asi00,asi01',g_showmsg,'ins_asi',SQLCA.sqlcode,1)
         LET g_success='N' 
      END IF
   END FOREACH
 
   INITIALIZE l_asi.* TO NULL
   DECLARE atcc_cs CURSOR FOR
       SELECT * FROM atcc_file
        WHERE atcc00 = g_asz01     #帐别
          AND atcc01 = tm.g         #族群编号
          AND atcc02 = l_asa02      #上层公司
          AND atcc08 = tm.d         #年度
          AND atcc09 = tm.e         #期别

   FOREACH atcc_cs INTO l_atcc.*
      IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success='Y'
      END IF

      IF SQLCA.sqlcode THEN
         LET g_showmsg=g_asz01,"/",tm.g,"/",l_asa02,"/",tm.d,"/",tm.e
         CALL s_errmsg('atcc00,atcc01,atcc02,atcc08,atcc09',g_showmsg,'(atcc_cs1#1:foreach)',SQLCA.sqlcode,1)
         LET g_success='N' RETURN
      END IF

      #luttb--101213--add--str--
      IF cl_null(l_atcc.atcc07) THEN
         CONTINUE FOREACH
      END IF 
      #luttb--101213--add--end
      INITIALIZE l_asi.* TO NULL
      LET l_asi.asi00 = tm.c
      LET l_asi.asi01 = tm.b
      LET g_sql = "SELECT asa02 FROM ",cl_get_target_table(g_dbs_a,'asa_file'),
                  " WHERE asa01 = '",tm.b,"'",
                  "   AND asa04 = 'Y'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_dbs_a) RETURNING g_sql
      PREPARE sel_asa02_2 FROM g_sql
      EXECUTE sel_asa02_2 INTO l_asi.asi02
      LET l_asi.asi03 = tm.c
      LET l_asi.asi04 = tm.h
      LET l_asi.asi041 =g_asz01  
      LET l_asi.asi05 = l_atcc.atcc05
      SELECT aag02 INTO l_asi.asi051 FROM aag_file
       WHERE aag01 = l_asi.asi05 AND aag00 = g_asz01
      LET l_asi.asi06 = tm.d
      LET l_asi.asi07 = tm.e
      LET l_asi.asi08 = l_atcc.atcc10
      LET l_asi.asi09 = l_atcc.atcc11
      LET l_asi.asi10 = l_atcc.atcc12
      LET l_asi.asi11 = l_atcc.atcc13
      LET l_asi.asi12 = l_atcc.atcc14
      LET l_asi.asi13 = l_atcc.atcc07
      LET l_asi.asi14 = ' '
      LET l_asi.asi15 = ' '
      LET l_asi.asi16 = ' '
      LET l_asi.asi17 = ' '
      LET l_asi.asi18 = l_atcc.atcc16
      LET l_asi.asi19 = l_atcc.atcc17
      LET l_asi.asi20 = l_atcc.atcc18
      LET l_asi.asi21 = l_atcc.atcc19
      LET l_asi.asi22 = l_atcc.atcc20
      LET l_asi.asi23 = l_atcc.atcc21
      LET l_asi.asi24 = l_atcc.atcc22
      LET l_asi.asiconf = 'Y'
      LET l_asi.asipost = 'N'
      LET l_asi.asiacti = 'Y'
      LET l_asi.asiuser = g_user
      LET l_asi.asigrup = g_grup
      LET l_asi.asilegal = g_legal   #FUN-B90025
      LET l_asi.asiorig = g_grup     #FUN-B90025
      LET l_asi.asioriu = g_user     #FUN-B90025
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_dbs_a,'asi_file'),
                  "     VALUES(?,?,?,?,?, ?,?,?,?,?,",
                  "            ?,?,?,?,?, ?,?,?,?,?,",
                  "            ?,?,?,?,?, ?,?,?,?,?,",
                  "            ?,?,?,?,?, ?,?)"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_dbs_a) RETURNING g_sql
      PREPARE insert_pre_2 FROM g_sql
      EXECUTE insert_pre_2 USING l_asi.*
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         LET g_showmsg=tm.c,"/",tm.b,"/",l_asi.asi05,"/",l_asi.asi13
         CALL s_errmsg('asi00,asi01',g_showmsg,'ins_asi',SQLCA.sqlcode,1)
         LET g_success='N'
      END IF
   END FOREACH


   IF g_totsuccess="N" THEN                                                        
      LET g_success="N"                                                           
   END IF                                                                          

END FUNCTION
#FUN-B50001
