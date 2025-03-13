# Prog. Version..: '5.30.06-13.03.12(00003)'     #
# Pattern name...: axrr430.4gl
# Descriptions...: 退款沖帳清單
# Date & Author..: NO.FUN-B20014 11/02/14 By lilingyu 
# Modify.........: No.TQC-B30012 增加選擇退款類型
# Modify.........: No.FUN-C40001 12/04/13 By yinhy 增加開窗功能
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD              #FUN-B20014
           wc      STRING,
           s       LIKE type_file.chr3,      
           t       LIKE type_file.chr3,     
           u       LIKE type_file.chr3,    
           a       LIKE type_file.chr1,  
           b       LIKE type_file.chr1,     #TQC-B30012           
           more    LIKE type_file.chr1             
           END RECORD,
 
          g_amt1   LIKE type_file.num20_6,        
          g_amt2   LIKE type_file.num20_6
 
DEFINE   g_i       LIKE type_file.num5             
DEFINE   g_sql     STRING
DEFINE   g_str     STRING
DEFINE   l_table   STRING

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   
   LET g_sql = "ooa01.ooa_file.ooa01,",
               "ooa02.ooa_file.ooa02,",
               "ooa15.ooa_file.ooa15,",
               "ooa03.ooa_file.ooa03,",
               "ooa032.ooa_file.ooa032,",
               "oob03.oob_file.oob03,",
               "oob04.oob_file.oob04,",
               "oob05.oob_file.oob05,",
               "oob06.oob_file.oob06,",
               "oob07.oob_file.oob07,",
               "oob08.oob_file.oob08,",
               "oob09.oob_file.oob09,",
               "oob10.oob_file.oob10,",
               "oob12.oob_file.oob12,",
               "l_gem02.gem_file.gem02,",
               "l_str.type_file.chr8,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "azi07.azi_file.azi07"
   LET l_table = cl_prt_temptable('axrr430',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF         
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.a  = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET tm.b       = ARG_VAL(15)        #TQC-B30012
   
   CREATE TEMP TABLE r430_tmp_1       
   ( tmp01 LIKE azi_file.azi01,
     tmp02 LIKE type_file.chr1,  
     tmp03 LIKE type_file.num20_6,
     tmp04 LIKE type_file.num20_6)
 
   CREATE TEMP TABLE r430_tmp_2       
   ( tot01 LIKE azi_file.azi01,
     tot02 LIKE type_file.chr1,  
     tot03 LIKE type_file.num20_6,
     tot04 LIKE type_file.num20_6)
 
   CREATE TEMP TABLE r430_tmp_3       
   ( amt01 LIKE azi_file.azi01,
     amt02 LIKE type_file.chr1,  
     amt03 LIKE type_file.num20_6,
     amt04 LIKE type_file.num20_6)
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r430_tm(0,0)
      ELSE CALL r430()
   END IF
   DROP TABLE r430_tmp_1
   DROP TABLE r430_tmp_2
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION r430_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          
DEFINE p_row,p_col    LIKE type_file.num5          
DEFINE l_cmd          LIKE type_file.chr1000       
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 5 LET p_col = 18
   ELSE LET p_row = 5 LET p_col = 14
   END IF
 
   OPEN WINDOW r430_w AT p_row,p_col
        WITH FORM "axr/42f/axrr430"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.s    = '32'
   LET tm.t    = '  '
   LET tm.u    = 'YY'
   LET tm.a    = '3'
   LET tm.b    = '6'         #TQC-B30012
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ooa01,ooa02,ooa15,ooa03
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
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
 
        #No.FUN-C40001  --Begin
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ooa01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ooa"
                 LET g_qryparam.arg1 = "1"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooa01
                 NEXT FIELD ooa01
              WHEN INFIELD(ooa03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ11"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooa03
                 NEXT FIELD ooa03
              WHEN INFIELD(ooa15)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooa15
                 NEXT FIELD ooa15
              END CASE
        #No.FUN-C40001  --End

  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r430_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm2.u1,tm2.u2,tm2.u3,tm.a,tm.b,tm.more          #TQC-B30012 add tm.b
                 WITHOUT DEFAULTS
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[123]' THEN NEXT FIELD a END IF
 
 #TQC-B30012 --begin--
      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES '[123456]' then
            NEXT FIELD b 
         END IF 
 #TQC-B30012 --end--
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF

   ON ACTION CONTROLR
      CALL cl_show_req_fields()

      ON ACTION CONTROLG CALL cl_cmdask()
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
 
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
      CLOSE WINDOW r430_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='axrr430'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr430','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.a CLIPPED,"'" ,
                         " '",tm.b CLIPPED,"'",          #TQC-B30012
                         " '",g_rep_user CLIPPED,"'",          
                         " '",g_rep_clas CLIPPED,"'",         
                         " '",g_template CLIPPED,"'"          
         CALL cl_cmdat('axrr430',g_time,l_cmd)
      END IF
      CLOSE WINDOW r430_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r430()
   ERROR ""
END WHILE
   CLOSE WINDOW r430_w
END FUNCTION
 
FUNCTION r430()
DEFINE l_name    LIKE type_file.chr20,    
       l_sql     LIKE type_file.chr1000,      
       l_za05    LIKE type_file.chr1000,  
       l_order   ARRAY[5] OF LIKE type_file.chr20,        
       sr        RECORD order1    LIKE type_file.chr20,   
                        order2    LIKE type_file.chr20,  
                        ooa01     LIKE ooa_file.ooa01,
                        ooa02     LIKE ooa_file.ooa02,
                        ooa15     LIKE ooa_file.ooa15,
                        ooa03     LIKE ooa_file.ooa03,
                        ooa032    LIKE ooa_file.ooa032,
                        oob03     LIKE oob_file.oob03,
                        oob04     LIKE oob_file.oob04,
                        oob05     LIKE oob_file.oob05,
                        oob06     LIKE oob_file.oob06,
                        oob07     LIKE oob_file.oob07,
                        oob08     LIKE oob_file.oob08,
                        oob09     LIKE oob_file.oob09,
                        oob10     LIKE oob_file.oob10,
                        oob12     LIKE oob_file.oob12,
                        azi03     LIKE azi_file.azi03,
                        azi04     LIKE azi_file.azi04,
                        azi05     LIKE azi_file.azi05,
                        azi07     LIKE azi_file.azi07
                        END RECORD,
             l_curr     LIKE csd_file.csd04      
DEFINE       l_gem02     LIKE gem_file.gem02     
DEFINE       l_str       LIKE type_file.chr8    

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   CALL cl_del_data(l_table)                                    
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axrr430' 

     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ooauser', 'ooagrup')
 
      DELETE FROM r430_tmp_2;   
 
     LET l_sql = "SELECT '','',",
                 "     ooa01,ooa02,ooa15,ooa03,ooa032,oob03,oob04,oob05,",
                 "     oob06,oob07,oob08,oob09,oob10,oob12,azi03,azi04,azi05,azi07",
                 "  FROM ooa_file,oob_file,OUTER azi_file ",
                 " WHERE ooa01=oob01 ",
                 "   AND azi_file.azi01=oob_file.oob07 ",
                 "   AND ooaconf !='X' ",  
                 "   AND ooa37 = '2'",     
                 "   AND ", tm.wc CLIPPED
 
     CASE WHEN tm.a = '1'   #已確認
             LET l_sql = l_sql CLIPPED," AND ooaconf = 'Y'"
          WHEN tm.a = '2'   #未確認
             LET l_sql = l_sql CLIPPED," AND ooaconf = 'N'"
          WHEN tm.a = '3'   #全部
	     LET l_sql= l_sql CLIPPED
     END CASE

#TQC-B30012 --begin--
     IF tm.b = '6' THEN
        LET l_sql = l_sql CLIPPED
     ELSE
        LET l_sql = l_sql CLIPPED," AND ooa35 = ",tm.b CLIPPED
     END IF 
#TQC-B30012 --end--

     LET l_sql = l_sql CLIPPED," ORDER BY ooa01,ooa02,oob03"
     PREPARE r430_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF
     
     DECLARE r430_curs1 CURSOR FOR r430_prepare1

     LET g_pageno = 0 
     LET g_amt1 = 0
     LET g_amt2 = 0
     
     FOREACH r430_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF

      SELECT gem02 INTO l_gem02 FROM gem_file where gem01 = sr.ooa15
      CALL s_oob04(sr.oob03,sr.oob04) RETURNING l_str
      EXECUTE insert_prep USING 
        sr.ooa01,sr.ooa02,sr.ooa15,sr.ooa03,sr.ooa032,sr.oob03,sr.oob04,
        sr.oob05,sr.oob06,sr.oob07,sr.oob08,sr.oob09,sr.oob10,sr.oob12,
        l_gem02,l_str,sr.azi03,sr.azi04,sr.azi05,sr.azi07
     END FOREACH
                         
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'ooa01,ooa02,ooa15,ooa03')
           RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.t[1,1],";",
                 tm.t[2,2],";",g_azi04,";",tm.u[1,1],";",tm.u[2,2],";",
                 g_azi05,";",tm.s[3,3],";",tm.t[3,3],";",tm.u[3,3]
     CALL cl_prt_cs3('axrr430','axrr430',g_sql,g_str) 
END FUNCTION
