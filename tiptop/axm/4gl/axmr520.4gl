# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: axmr520.4gl
# Descriptions...: 訂單交貨異常表
# Input parameter:
# Return code....:
# Date & Author..: NO:FUN-A80002 10/07/30 By xiaofeizhu
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改
# Modify.........: No:MOD-C20178 12/02/22 By Vampire 條件請改串出貨單身ogb31、ogb32
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc       STRING,                  
              s        LIKE type_file.chr3,     
              t        LIKE type_file.chr3,     
              u        LIKE type_file.chr3,     
              a        LIKE type_file.num5,     
              b        LIKE type_file.num5,     
              c        LIKE oad_file.oad041,    
              d        LIKE oad_file.oad041,    
              more     LIKE type_file.chr1     
              END RECORD,
          l_cd         LIKE type_file.chr1000,  
          l_i          LIKE type_file.num5      
   DEFINE g_i          LIKE type_file.num5     
   DEFINE l_table      STRING,                  
          g_str        STRING,                 
          g_sql        STRING                  
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
 
   LET g_pdate = ARG_VAL(1)         # Get arguments from command line
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
   LET tm.b  = ARG_VAL(12)
   LET tm.c  = ARG_VAL(13)
   LET tm.d  = ARG_VAL(14)
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axmr520_tm(0,0)        # Input print condition
      ELSE CALL axmr520()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION axmr520_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         
   DEFINE p_row,p_col    LIKE type_file.num5,        
          l_cmd          LIKE type_file.chr1000      
 
   LET p_row = 3 LET p_col = 16
 
   OPEN WINDOW axmr520_w AT p_row,p_col WITH FORM "axm/42f/axmr520"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '31'
   LET tm.a    = '0'
   LET tm.b    = '0'
   LET tm.c    = '0'
   LET tm.d    = '0'
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
   IF cl_null(tm2.s1) THEN LET tm2.s1 = "3"  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = "1"  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oea01,oea02,oea03,oeb04,oeb15     

         BEFORE CONSTRUCT
             CALL cl_qbe_init()

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(oea01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oea5"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea01
                 NEXT FIELD oea01
 
               WHEN INFIELD(oea03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea03
                 NEXT FIELD oea03
 
               WHEN INFIELD(oea04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea04
                 NEXT FIELD oea04
 
               WHEN INFIELD(oeb04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oeb04
                 NEXT FIELD oeb04
            END CASE

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

 
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmr520_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more         
   
   INPUT BY NAME
                 
                 tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3, tm2.u1,tm2.u2,tm2.u3,
       tm.a,tm.c,tm.b,tm.d,tm.more
       WITHOUT DEFAULTS

         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD a
         IF cl_null(tm.a) THEN NEXT FIELD a  END IF
      AFTER FIELD b
         IF cl_null(tm.b) THEN NEXT FIELD b  END IF
      AFTER FIELD c
         IF tm.c > 100  AND cl_null(tm.c) THEN NEXT FIELD c  END IF
      AFTER FIELD d
         IF tm.d > 100  AND cl_null(tm.d) THEN NEXT FIELD d  END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
         IF cl_null(tm.a) THEN NEXT FIELD a  END IF
         IF cl_null(tm.b) THEN NEXT FIELD b  END IF
         IF tm.c > 100  AND cl_null(tm.c) THEN NEXT FIELD c  END IF
         IF tm.d > 100  AND cl_null(tm.d) THEN NEXT FIELD d  END IF
      #UI
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr520_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr520'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr520','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", 
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'",           
                         " '",g_rpt_name CLIPPED,"'"            
         CALL cl_cmdat('axmr520',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr520_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr520()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr520_w
END FUNCTION
 
FUNCTION axmr520()
   DEFINE l_name    LIKE type_file.chr20,         
          l_time    LIKE type_file.chr8,
          l_sql     STRING,         
          l_chr     LIKE type_file.chr1,          
          l_za05    LIKE type_file.chr1000,     
          l_repflag LIKE type_file.chr1,         
          l_order    ARRAY[5] OF LIKE aaf_file.aaf03,             
          sr               RECORD order1 LIKE aaf_file.aaf03,     
                                  order2 LIKE aaf_file.aaf03,     
                                  order3 LIKE aaf_file.aaf03,         
                                  oea01 LIKE oea_file.oea01,
                                  oea02 LIKE oea_file.oea02,
                                  oea03 LIKE oea_file.oea03,
                                  occ02 LIKE occ_file.occ02,
                                  oeb04 LIKE oeb_file.oeb04,
                                  oeb06 LIKE oeb_file.oeb06,
                                  ima021 LIKE ima_file.ima021, 
                                  oeb12 LIKE oeb_file.oeb12,
                                  oeb24 LIKE oeb_file.oeb24,
                                  oeb15 LIKE oeb_file.oeb15,
                                  oeb03 LIKE oeb_file.oeb03,
                                  oga02 LIKE oga_file.oga02,
                                  l_a   LIKE type_file.num5,     
                                  l_b   LIKE type_file.num5,      
                                  l_c   LIKE oad_file.oad041,     
                                  l_d   LIKE oad_file.oad041      
                                  
                                  
                        END RECORD
 
      
     LET g_sql = " oea01.oea_file.oea01,",
                 " oea02.oea_file.oea02,",
                 " oea03.oea_file.oea03,",
                 " occ02.occ_file.occ02,",
                 " oeb04.oeb_file.oeb04,",
                 " oeb06.oeb_file.oeb06,",
                 " ima021.ima_file.ima021,",
                 " oeb12.oeb_file.oeb12,",
                 " oeb24.oeb_file.oeb24,",
                 " oeb15.oeb_file.oeb15,",
                 " oga02.oga_file.oga02,", 
                 " l_a.type_file.num5,",
                 " l_b.type_file.num5,",
                 " l_c.oad_file.oad041,",
                 " l_d.oad_file.oad041" 
 
     LET l_table = cl_prt_temptable('axmr520',g_sql) CLIPPED
     IF l_table = -1 THEN
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
         EXIT PROGRAM 
     END IF
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? )"       
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
        EXIT PROGRAM
     END IF
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')

    LET l_sql = "SELECT '','','',",
                "       oea01,oea02,oea03,'',oeb04,oeb06,'',oeb12,oeb24,oeb15,oeb03,",
                "       '','','','',''",                            
                "  FROM oea_file,oeb_file",     
            " WHERE oea01=oeb01 AND oeaconf <> 'X' ",             
            "  AND ", tm.wc

     PREPARE axmr520_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM           
     END IF
     DECLARE axmr520_curs1 CURSOR FOR axmr520_p1
 
     LET l_sql="SELECT MAX(oga02) FROM oga_file,ogb_file ",
               #" WHERE oga01=ogb01 AND oga16=? AND ogb03=? AND ogaconf !='X' " #MOD-C20178 mark
               " WHERE oga01=ogb01 AND ogb31=? AND ogb32=? AND ogaconf !='X' "  #MOD-C20178 add
 
     PREPARE axmr520_p2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM           
     END IF
     DECLARE axmr520_curs2 scroll CURSOR FOR axmr520_p2
 
     FOREACH axmr520_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT occ02 INTO sr.occ02
         FROM occ_file
        WHERE occ01 = sr.oea03
       SELECT ima021 INTO sr.ima021
         FROM ima_file
        WHERE ima01 = sr.oeb04        

      OPEN axmr520_curs2 USING sr.oea01,sr.oeb03
      FETCH first axmr520_curs2 INTO sr.oga02
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('fetch:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

   LET l_repflag='N'
#----------------------------------------- 提前/延遲
   IF cl_null(sr.oga02) THEN
      IF g_today-sr.oeb15 > tm.b THEN
         LET l_repflag='Y'
         LET sr.l_b=g_today-sr.oeb15
      END IF
   ELSE
         IF sr.oeb15-sr.oga02 > tm.a THEN
            LET l_repflag='Y'
            LET sr.l_a=sr.oeb15-sr.oga02
         END IF
        IF sr.oga02-sr.oeb15 > tm.b THEN
           LET l_repflag='Y'
           LET sr.l_b=sr.oga02-sr.oeb15
        END IF
   END IF
#----------------------------------------- 超交/短交
     IF sr.oeb12 != 0 THEN
         IF (sr.oeb24-sr.oeb12)/sr.oeb12*100 > tm.c THEN
            LET l_repflag='Y'
            LET sr.l_c=(sr.oeb24-sr.oeb12)/sr.oeb12*100
         END IF
         IF (sr.oeb12-sr.oeb24)/sr.oeb12*100 > tm.d THEN
            LET l_repflag='Y'
            LET sr.l_d=(sr.oeb12-sr.oeb24)/sr.oeb12*100
         END IF
     END IF
     IF l_repflag='Y' THEN
        IF cl_null(sr.l_a) THEN
           LET sr.l_a = 0
        END IF   
        IF cl_null(sr.l_b) THEN
           LET sr.l_b = 0
        END IF
        IF cl_null(sr.l_c) THEN
           LET sr.l_c = 0
        END IF
        IF cl_null(sr.l_d) THEN
           LET sr.l_d = 0
        END IF                

        EXECUTE insert_prep USING
                sr.oea01,sr.oea02,sr.oea03,sr.occ02,sr.oeb04,sr.oeb06,sr.ima021,      
                sr.oeb12,sr.oeb24,sr.oeb15,sr.oga02,sr.l_a,sr.l_b,sr.l_c,sr.l_d
     END IF
     END FOREACH
 
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'oea01,oea02,oea03,oeb04,oeb15')                   
              RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.u
     CALL cl_prt_cs3('axmr520','axmr520',l_sql,g_str)

END FUNCTION
#FUN-A80002
