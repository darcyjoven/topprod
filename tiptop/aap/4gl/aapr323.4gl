# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: aapr323.4gl
# Descriptions...: 應付退款沖帳明細表列印作業
# Date & Author..: No.FUN-B20019 11/02/12 by yinhy
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
 
DATABASE ds
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   # Print condition RECORD  #FUN-B20019
                 wc        STRING,      # Where condition
                 g        LIKE type_file.chr1,
                 s        LIKE type_file.chr2,
                 t        LIKE type_file.chr2,
                 u        LIKE type_file.chr2,
                 more     LIKE type_file.chr1 
              END RECORD,
          g_orderA    ARRAY[2] OF LIKE zaa_file.zaa08,      # VARCHAR(16), #排序名稱
          g_sum1      LIKE apf_file.apf08,
          g_sum2      LIKE apf_file.apf10,
          g_sum3      LIKE apg_file.apg05,
          g_sum4      LIKE aph_file.aph05,
          g_sum5      LIKE aph_file.aph05f,
          p_sql       STRING   #TQC-630166
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose
DEFINE    g_sql       STRING                     #No.FUN-770093
DEFINE    g_str       STRING                     #No.FUN-770093
DEFINE    l_table     STRING                     #No.FUN-770093
DEFINE    l_table1    STRING                     #No.FUN-770093
DEFINE    l_table2    STRING                     #No.FUN-770093
DEFINE    l_table3    STRING                     #No.FUN-770093
DEFINE    l_table4    STRING                     #No.FUN-770093
DEFINE    l_table5    STRING                     #No.FUN-770093
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055 #FUN-BB0047
 
   LET g_sql="apf44.apf_file.apf44,apf01.apf_file.apf01,apf02.apf_file.apf02,",
             "apf03.apf_file.apf03,apf12.apf_file.apf12,apf05.apf_file.apf05,",
             "gem02.gem_file.gem02,apf06.apf_file.apf06,apf08.apf_file.apf08,",
             "apf10.apf_file.apf10,azi05.azi_file.azi05,apf04.apf_file.apf04"
   LET l_table = cl_prt_temptable('aapr323',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql="apg01.apg_file.apg01,apg02.apg_file.apg02,apg04.apg_file.apg04,",
             "apa08.apa_file.apa08,apg05.apg_file.apg05,azi04.azi_file.azi04,",
             "l_n1.type_file.num5"   
   LET l_table1 = cl_prt_temptable('aapr3231',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql="aph01.aph_file.aph01,aph02.aph_file.aph02,aph03.aph_file.aph03,",
             "aph05.aph_file.aph05,aph04.aph_file.aph04,aph07.aph_file.aph07,",
             "azi04_1.azi_file.azi04,",
             "aph13.aph_file.aph13,aph05f.aph_file.aph05f,azi04_2.azi_file.azi04,",
             "l_n2.type_file.num5"   
   LET l_table2 = cl_prt_temptable('aapr3232',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql="curr2.apf_file.apf06,apf08_3.apf_file.apf08,",
             "apf10_3.apf_file.apf10,apg05_3.apg_file.apg05,",
             "aph05_3.aph_file.aph05,aph05f_3.aph_file.aph05f,",
             "order1_2.type_file.chr50,order2_2.type_file.chr50,",
             "azi05_3.azi_file.azi05,azi05_3_2.azi_file.azi05"
   LET l_table3 = cl_prt_temptable('aapr3233',g_sql) CLIPPED
   IF l_table3 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql="curr1.apf_file.apf06,apf08_2.apf_file.apf08,",                    
             "apf10_2.apf_file.apf10,apg05_2.apg_file.apg05,", 
             "aph05_2.aph_file.aph05,aph05f_2.aph_file.aph05f,",
             "order1_1.type_file.chr50,azi05_2.azi_file.azi05,",
             "azi05_2_2.azi_file.azi05"
   LET l_table4 = cl_prt_temptable('aapr3234',g_sql) CLIPPED
   IF l_table4 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql="curr.apf_file.apf06,apf08_1.apf_file.apf08,",                    
             "apf10_1.apf_file.apf10,apg05_1.apg_file.apg05,",           
             "aph05_1.aph_file.aph05,aph05f_1.aph_file.aph05f,azi05_1.azi_file.azi05,",
             "azi05_1_2.azi_file.azi05"
   LET l_table5 = cl_prt_temptable('aapr3235',g_sql) CLIPPED
   IF l_table5 = -1 THEN EXIT PROGRAM END IF
 
 
   DROP TABLE curr_tmp1
   CREATE TEMP TABLE curr_tmp1(
     curr  LIKE apf_file.apf06,
     apf08 LIKE apf_file.apf08,
     apf10 LIKE apf_file.apf10,
     apg05 LIKE apg_file.apg05,
     aph05 LIKE aph_file.aph05,
     aph05f LIKE aph_file.aph05f,
     order1 LIKE zaa_file.zaa08,
     order2 LIKE zaa_file.zaa08);
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add 
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.g = ARG_VAL(8)
   LET tm.s  = ARG_VAL(9)
   LET tm.t  = ARG_VAL(10)
   LET tm.u  = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r323_tm(0,0)
   ELSE
      CALL r323()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
 
FUNCTION r323_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd        LIKE type_file.chr1000
 
   LET p_row = 2 LET p_col = 18
   OPEN WINDOW r323_w AT p_row,p_col
     WITH FORM "aap/42f/aapr323"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '12'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON apf44,apf01,apf02,apf03,apf06,apf04
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()
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
         LET INT_FLAG = 0
         CLOSE WINDOW r323_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      LET tm.g = '3'
 
      INPUT BY NAME tm.g,tm2.s1,tm2.s2,tm2.t1,tm2.t2,
                    tm2.u1,tm2.u2,tm.more WITHOUT DEFAULTS
 
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD g
            IF tm.g NOT MATCHES "[123]" OR cl_null(tm.g)
               THEN NEXT FIELD g
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         AFTER INPUT
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
            LET tm.t = tm2.t1,tm2.t2
            LET tm.u = tm2.u1,tm2.u2
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
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
         CLOSE WINDOW r323_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr323'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr323','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.g CLIPPED,"'",
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.u CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'",
                         " '",g_rpt_name CLIPPED,"'" 
            CALL cl_cmdat('aapr323',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r323_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r323()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r323_w
 
END FUNCTION
 
FUNCTION r323()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name
          l_sql     STRING,                 # RDSQL STATEMENT
          l_chr     LIKE type_file.chr1,
          l_order   ARRAY[2] OF   LIKE apf_file.apf01,
          sr        RECORD order1 LIKE apf_file.apf01,
                           order2 LIKE apf_file.apf01,
                           apf01 LIKE apf_file.apf01,   #付款單單頭檔
                           apf02 LIKE apf_file.apf02,
                           apf03 LIKE apf_file.apf03,
                           apf04 LIKE apf_file.apf04,
                           apf05 LIKE apf_file.apf05,
                           apf44 LIKE apf_file.apf44,
                           apf06 LIKE apf_file.apf06,
                           apf08 LIKE apf_file.apf08,
                           apf10 LIKE apf_file.apf10,
                           apf12 LIKE apf_file.apf12,
                           azi03 LIKE azi_file.azi03,
                           azi04 LIKE azi_file.azi04,
                           azi05 LIKE azi_file.azi05,
                           gem02 LIKE gem_file.gem02
                    END RECORD
   DEFINE sr1       DYNAMIC ARRAY OF RECORD
                           apg02 LIKE apg_file.apg02,
                           apg03 LIKE apg_file.apg03,
                           apg04 LIKE apg_file.apg04,
                           apg05 LIKE apg_file.apg05,
                           apa08 LIKE apa_file.apa08,
                           apa13 LIKE apa_file.apa13,
                           l_n   LIKE type_file.num5
                    END RECORD,
          sr2       DYNAMIC ARRAY OF RECORD
                           aph02 LIKE aph_file.aph02,
                           aph03 LIKE aph_file.aph03,
                           aph04 LIKE aph_file.aph04,
                           aph05 LIKE aph_file.aph05,
                           aph05f LIKE aph_file.aph05f,
                           aph07 LIKE aph_file.aph07,
                           aph13 LIKE aph_file.aph13,
                           l_n   LIKE type_file.num5
                    END RECORD,
          t_azi04      LIKE azi_file.azi04, 
          t_azi05      LIKE azi_file.azi05,
          n_sum1       LIKE apf_file.apf08,
          n_sum2       LIKE apf_file.apf10,
          n_sum3       LIKE apg_file.apg05,
          n_sum4       LIKE aph_file.aph05,
          n_sum5       LIKE aph_file.aph05f,
          m_sum1       LIKE apf_file.apf08,
          m_sum2       LIKE apf_file.apf10,
          m_sum3       LIKE apg_file.apg05,
          m_sum4       LIKE aph_file.aph05,
          m_sum5       LIKE aph_file.aph05f,
          l_curr       LIKE apf_file.apf06,
          l_idx        LIKE type_file.num5,
          l_order1     LIKE type_file.chr50,
          l_order2     LIKE type_file.chr50, 
          l_n          LIKE type_file.num5
  
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM 
   END IF
 
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
             " VALUES(?,?,?,?,?, ?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
 
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,     
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)" 
   PREPARE insert_prep2 FROM g_sql                                              
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep2:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM                        
   END IF  
 
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,               
             " VALUES(?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep3 FROM g_sql                                              
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep3:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM                        
   END IF  
 
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,               
             " VALUES(?,?,?,?,?, ?,?,?,?)" 
   PREPARE insert_prep4 FROM g_sql                                              
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep4:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM                        
   END IF  
 
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table5 CLIPPED,               
             " VALUES(?,?,?,?,?, ?,?,?)"  
   PREPARE insert_prep5 FROM g_sql                                              
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep5:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM                        
   END IF  
 
   CALL cl_del_data(l_table)   
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)
   CALL cl_del_data(l_table3)
   CALL cl_del_data(l_table4)
   CALL cl_del_data(l_table5)
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apfuser', 'apfgrup')
 
   DELETE FROM curr_tmp1;

 
   LET l_sql = "SELECT '','',",
               " apf01, apf02, apf03, apf04, apf05, apf44, apf06,",
               " apf08f, apf10f, apf12, azi03, azi04, azi05 ,''",
               " FROM apf_file ",
               " LEFT OUTER JOIN azi_file ON azi_file.azi01 = apf_file.apf06",  #幣別
               " WHERE ",
               " apf41 <> 'X' ",
               " AND apf00 = '32' ",
               " AND ", tm.wc CLIPPED
 
   PREPARE r323_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   DECLARE r323_curs1 CURSOR FOR r323_prepare1
 

   LET g_sum1 = 0
   LET g_sum2 = 0
   LET g_sum3 = 0
   LET g_sum4 = 0
   LET g_sum5 = 0   #MOD-820063
 
   FOREACH r323_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT gem02 INTO sr.gem02 FROM gem_file
       WHERE gem01 = sr.apf05
 
      IF cl_null(sr.azi03) THEN LET sr.azi03 = 0 END IF
      IF cl_null(sr.azi04) THEN LET sr.azi04 = 0 END IF
      IF cl_null(sr.azi05) THEN LET sr.azi05 = 0 END IF
      IF cl_null(sr.apf08) THEN LET sr.apf08 = 0 END IF
      IF cl_null(sr.apf10) THEN LET sr.apf10 = 0 END IF
 
      FOR g_i = 1 TO 2
         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.apf44
              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.apf01   
              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.apf02 USING 'YYYY/MM/DD'
              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.apf03   
              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.apf06   
              WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.apf04
              OTHERWISE LET l_order[g_i]  = '-'
         END CASE
      END FOR
 
      LET sr.order1 = l_order[1]
      LET sr.order2 = l_order[2]
      IF sr.order1 IS NULL THEN LET sr.order1 = ' '  END IF
      IF sr.order2 IS NULL THEN LET sr.order2 = ' '  END IF
 

      SELECT azi05 INTO t_azi05 FROM azi_file
          WHERE azi01 = sr.apf06
      EXECUTE insert_prep USING sr.apf44,sr.apf01,sr.apf02,sr.apf03,
                                sr.apf12,sr.apf05,sr.gem02,sr.apf06,
                                sr.apf08,sr.apf10,t_azi05,sr.apf04
      INSERT INTO curr_tmp1 VALUES(sr.apf06,sr.apf08,sr.apf10,0,0,0,sr.order1,sr.order2)
 
      LET n_sum1 = 0
      LET n_sum2 = 0
      LET n_sum3 = 0
      LET n_sum4 = 0
      LET n_sum5 = 0
 
      LET m_sum1 = 0
      LET m_sum2 = 0
      LET m_sum3 = 0
      LET m_sum4 = 0
      LET m_sum5 = 0
 
      FOR l_idx =1 TO 600
            INITIALIZE sr1[l_idx].* TO NULL
            INITIALIZE sr2[l_idx].* TO NULL
            LET sr2[l_idx].aph07=''
      END FOR
 
      DECLARE sr1_curs CURSOR FOR
         SELECT apg02,apg03,apg04,apg05f,apa08,apa13
           FROM apg_file LEFT OUTER JOIN apa_file ON apa_file.apa01 = apg_file.apg04
          WHERE apg01 = sr.apf01
          ORDER BY apg02
      LET l_idx = 1
      LET l_n = 1
      FOREACH sr1_curs INTO sr1[l_idx].*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach apg_file error!',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET sr1[l_idx].l_n = l_n
         IF cl_null(sr1[l_idx].apg05) THEN
            LET sr1[l_idx].apg05 = 0
         END IF
 
         IF sr1[l_idx].apg03 !=g_plant THEN
            LET p_sql="SELECT apa08 FROM apa_file ",
                      " WHERE apa01='",sr1[l_idx].apg04,"'"
 	    CALL cl_replace_sqldb(p_sql) RETURNING p_sql
            PREPARE apa_xxx FROM p_sql
 
            OPEN  apa_xxx
            FETCH apa_xxx INTO sr1[l_idx].apa08
            IF STATUS THEN
               LET sr1[l_idx].apa08 =''
            END IF
            CLOSE apa_xxx
         END IF
         LET l_idx = l_idx + 1
         LET l_n = l_n + 1
      END FOREACH
 
      LET l_idx = 1
      DECLARE sr2_curs CURSOR FOR
         SELECT aph02,aph03,aph04,aph05,aph05f,aph07,aph13
           FROM aph_file
          WHERE aph01 = sr.apf01
          ORDER BY aph02
      LET l_idx = 1
      LET l_n = 1
      FOREACH sr2_curs INTO sr2[l_idx].*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach aph_file error!',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET sr2[l_idx].l_n = l_n
         IF cl_null(sr2[l_idx].aph05) THEN
            LET sr2[l_idx].aph05 = 0
         END IF
         IF cl_null(sr2[l_idx].aph05f) THEN
            LET sr2[l_idx].aph05f = 0
         END IF
         LET l_idx = l_idx + 1
         LET l_n = l_n + 1
      END FOREACH
 
      FOR l_idx = 1 TO 600
         IF (sr1[l_idx].apg04 IS NULL) AND (sr1[l_idx].apg05 IS NULL)
            AND (sr2[l_idx].aph03 IS NULL) AND (sr2[l_idx].aph05 IS NULL) THEN
            EXIT FOR
         ELSE
            IF sr1[l_idx].apg04 IS NOT NULL OR sr1[l_idx].apg05 IS NOT NULL THEN
               SELECT azi04 INTO t_azi04 FROM azi_file
                WHERE azi01 = sr1[l_idx].apa13
               EXECUTE insert_prep1 USING
                  sr.apf01,sr1[l_idx].apg02,sr1[l_idx].apg04,
                  sr1[l_idx].apa08,sr1[l_idx].apg05,t_azi04,
                  sr1[l_idx].l_n   
               INSERT INTO curr_tmp1 VALUES(sr1[l_idx].apa13,0,0,sr1[l_idx].apg05,0,0,sr.order1,sr.order2)
            END IF
            SELECT azi04 INTO t_azi04 FROM azi_file                       
                WHERE azi01 = sr2[l_idx].aph13
            EXECUTE insert_prep2 USING
               sr.apf01,sr2[l_idx].aph02,sr2[l_idx].aph03,
               sr2[l_idx].aph05,sr2[l_idx].aph04,sr2[l_idx].aph07,t_azi04,
               sr2[l_idx].aph13,sr2[l_idx].aph05f,g_azi04,
               sr2[l_idx].l_n 
            IF sr2[l_idx].aph03 IS NOT NULL OR 
               sr2[l_idx].aph05 IS NOT NULL THEN
               INSERT INTO curr_tmp1 VALUES(sr2[l_idx].aph13,0,0,0,sr2[l_idx].aph05,sr2[l_idx].aph05f,sr.order1,sr.order2)      #MOD-820063
            END IF
         END IF
      END FOR
   END FOREACH
 

   IF tm.u[1,1] = 'Y' THEN
      DECLARE tmp1_cs1 CURSOR FOR
             SELECT order1,curr,SUM(apf08),SUM(apf10),SUM(apg05),SUM(aph05),SUM(aph05f)
                FROM curr_tmp1
             GROUP BY order1,curr
      FOREACH tmp1_cs1  
         INTO l_order1,l_curr,n_sum1,n_sum2,n_sum3,n_sum4,n_sum5
         SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01=l_curr
         IF cl_null(n_sum1) THEN LET n_sum1 = 0 END IF   
         IF cl_null(n_sum2) THEN LET n_sum2 = 0 END IF   
         IF cl_null(n_sum3) THEN LET n_sum3 = 0 END IF   
         IF cl_null(n_sum4) THEN LET n_sum4 = 0 END IF
         IF cl_null(n_sum5) THEN LET n_sum5 = 0 END IF
         EXECUTE insert_prep4 USING l_curr,n_sum1,n_sum2,n_sum3,n_sum4,n_sum5,   
                                    l_order1,t_azi05,g_azi05
      END FOREACH
   END IF
   IF tm.u[2,2] = 'Y' THEN
      DECLARE tmp1_cs2 CURSOR FOR                                               
             SELECT order1,order2,curr,SUM(apf08),SUM(apf10),SUM(apg05),SUM(aph05),SUM(aph05f)
                FROM curr_tmp1                                                  
             GROUP BY order1,order2,curr                                         
      FOREACH tmp1_cs2 
         INTO l_order1,l_order2,l_curr,m_sum1,m_sum2,m_sum3,m_sum4,m_sum5
         SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01=l_curr
         IF cl_null(m_sum1) THEN LET m_sum1 = 0 END IF   
         IF cl_null(m_sum2) THEN LET m_sum2 = 0 END IF   
         IF cl_null(m_sum3) THEN LET m_sum3 = 0 END IF   
         IF cl_null(m_sum4) THEN LET m_sum4 = 0 END IF
         IF cl_null(m_sum5) THEN LET m_sum5 = 0 END IF
         EXECUTE insert_prep3 USING l_curr,m_sum1,m_sum2,m_sum3,m_sum4,m_sum5,
                                    l_order1,l_order2,t_azi05,g_azi05
      END FOREACH
   END IF
   DECLARE tmp1_cs3 CURSOR FOR                                               
          SELECT curr,SUM(apf08),SUM(apf10),SUM(apg05),SUM(aph05),SUM(aph05f)
              FROM curr_tmp1                                                  
          GROUP BY curr                                       
   FOREACH tmp1_cs3                                                          
      INTO l_curr,g_sum1,g_sum2,g_sum3,g_sum4,g_sum5
      SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01=l_curr
      IF cl_null(g_sum1) THEN LET g_sum1 = 0 END IF   
      IF cl_null(g_sum2) THEN LET g_sum2 = 0 END IF   
      IF cl_null(g_sum3) THEN LET g_sum3 = 0 END IF   
      IF cl_null(g_sum4) THEN LET g_sum4 = 0 END IF
      IF cl_null(g_sum5) THEN LET g_sum5 = 0 END IF
      EXECUTE insert_prep5 USING l_curr,g_sum1,g_sum2,g_sum3,g_sum4,g_sum5,t_azi05,g_azi05
   END FOREACH
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
   IF g_zz05='Y' THEN
      CALL cl_wcchp(tm.wc,'apf44,apf01,apf02,apf03,apf06,apf04')
          RETURNING tm.wc
      LET g_str =tm.wc
   END IF
   LET g_str=g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.t[1,1],";",
             tm.t[2,2],";",tm.u[1,1],";",tm.u[2,2],";",tm.g
   LET l_sql="SELECT A.*,D.* ",
             "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A LEFT OUTER JOIN ",
             "       (SELECT B.*,C.* FROM ",
                       g_cr_db_str CLIPPED,l_table1 CLIPPED," B FULL OUTER JOIN ",
                       g_cr_db_str CLIPPED,l_table2 CLIPPED," C",
             "            ON B.apg01=C.aph01 AND B.l_n1=C.l_n2) D ",
             "    ON A.apf01=D.apg01 OR A.apf01=D.aph01","|",
             "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,"|",
             "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED,"|",
             "SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED
   CALL cl_prt_cs3('aapr323','aapr323',l_sql,g_str)
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80105  MARK
 
END FUNCTION
