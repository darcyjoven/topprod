# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aicr050.4gl
# Descriptions...: 廠商外包檢驗日報表
# Date & Author..: No.FUN-7B0075 07/12/06 By Sunyanchun
# Modify.........: No.FUN-830084 08/03/24 By Sunyanchun BUG修改
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B90044 11/09/05 By lujh 程序撰寫規範修正
# Modify.........: No.FUN-BC0103 12/01/13 PIN COUNT以料號設定優先帶入,若無資料則帶icj_file設定
 
DATABASE ds
GLOBALS "../../config/top.global"
#No.FUN-830084----begin
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item     LIKE type_file.num5
END GLOBALS
 
   DEFINE tm  RECORD
        wc      STRING,                      # Where condition
        s       LIKE type_file.chr3,         # Order by sequence
        t       LIKE type_file.chr3,         # Eject sw
        u       LIKE type_file.chr3,         # Group total sw
        exm     LIKE type_file.chr1,
        d       LIKE type_file.chr1,
        more    LIKE type_file.chr1          # Input more condition(Y/N)
      END RECORD,
          l_pmh08        LIKE pmh_file.pmh08,
          g_orderA       ARRAY[3] OF LIKE type_file.chr50
DEFINE   g_i             LIKE type_file.num5
DEFINE   g_sma115        LIKE sma_file.sma115
DEFINE   g_sql           STRING
DEFINE   l_table         STRING
DEFINE   g_str           STRING
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                 # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
   IF NOT s_industry("icd") THEN                                                
      CALL cl_err('','aic-999',1)                                               
      EXIT PROGRAM                                                              
   END IF
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_sql = "order1.type_file.chr50,",
               "order2.type_file.chr50,",
               "order3.type_file.chr50,",
               "pmc03.pmc_file.pmc03,",
               "rva06.rva_file.rva06,",
               "rva01.rva_file.rva01,",
               "rvb02.rvb_file.rvb02,",
               "rvb05.rvb_file.rvb05,",
               "bmb03.bmb_file.bmb03,",
               "rvb38.rvb_file.rvb38,",
               "rvb04.rvb_file.rvb04,",
               "rvb03.rvb_file.rvb03,",
               "rvb07.rvb_file.rvb07,",
               "pmn07.pmn_file.pmn07,",
               "l_type.type_file.chr12,",
               "aaaa.type_file.chr1,",
               "l_pkg.type_file.chr50,",
               "rvb41.rvb_file.rvb41,",
               "bbbb.type_file.chr1,",
               "rvb85.rvb_file.rvb85,",
               "rvb83.rvb_file.rvb83,",
	       "ima021.ima_file.ima021"	
   #NO.FUN-7B0075---begin	       
   LET l_table = cl_prt_temptable('aicr050',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   #NO.FUN-7B0075---end
   LET g_pdate = ARG_VAL(1)                 # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.exm= ARG_VAL(11)
   LET tm.d  = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-B90044
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r050_tm(0,0)                        # Input print condition
   ELSE 
      CALL aicr050()                           # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
END MAIN
 
FUNCTION r050_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
 
   LET p_row = 4 LET p_col = 15
 
   OPEN WINDOW r050_w AT p_row,p_col WITH FORM "aic/42f/aicr050"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '314'
   LET tm.t    = 'YNN'
   LET tm.u    = 'NNY'
   LET tm.exm  = '1'
   LET tm.d    = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
    
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
   CONSTRUCT BY NAME tm.wc ON rva01,rva06,rva05,rvb04,rvb05
      BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
      ON ACTION CONTROLP
            IF INFIELD(rvb05) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rvb05
               NEXT FIELD rvb05
            END IF
 
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
      LET INT_FLAG = 0
      CLOSE WINDOW r050_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME
         tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3, tm2.u1,tm2.u2,tm2.u3,
         tm.exm,tm.d,tm.more
         WITHOUT DEFAULTS
      BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]"
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
      CLOSE WINDOW r050_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aicr050'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aicr050','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,          #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.exm CLIPPED,"'",
                         " '",tm.d  CLIPPED,"'"   ,
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'"
         CALL cl_cmdat('aicr050',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r050_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aicr050()
   ERROR ""
END WHILE
   CLOSE WINDOW r050_w
END FUNCTION
 
FUNCTION aicr050()
   DEFINE l_name    LIKE type_file.chr20,       # External(Disk) file name
          l_time    LIKE type_file.chr8,        # Used time for running the job
          l_sql     STRING,                     # RDSQL STATEMENT
          l_chr     LIKE type_file.chr1,
          l_za05    LIKE type_file.chr50,
          l_pmm22   LIKE pmm_file.pmm22,
          l_ima021  LIKE ima_file.ima021,
          l_order    ARRAY[6] OF LIKE type_file.chr50,
          sr               RECORD order1 LIKE type_file.chr50,
                                  order2 LIKE type_file.chr50,
                                  order3 LIKE type_file.chr50,
                                  rva01  LIKE rva_file.rva01,
                                  rva06  LIKE rva_file.rva06,
                                  rva05  LIKE rva_file.rva05,
                                  pmc03  LIKE pmc_file.pmc03,
                                  rvb05  LIKE rvb_file.rvb05,
                                  rvb07  LIKE rvb_file.rvb07,
                                  pmn07  LIKE pmn_file.pmn07,
                                  rvb04  LIKE rvb_file.rvb04,
                                  rvb03  LIKE rvb_file.rvb03,
                                  rvb83  LIKE rvb_file.rvb83,
                                  rvb85  LIKE rvb_file.rvb85,
				  rvb38  LIKE rvb_file.rvb38,
				  rvbiicd14 LIKE rvbi_file.rvbiicd14,
				  rvb41  LIKE rvb_file.rvb41,
				  rvb02  LIKE rvb_file.rvb02
                        END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5
     DEFINE i                  LIKE type_file.num5
     DEFINE l_zaa02            LIKE zaa_file.zaa02
     DEFINE l_bmb03            LIKE bmb_file.bmb03
     DEFINE l_sfa02            LIKE sfa_file.sfa02
     DEFINE l_pkg              LIKE type_file.chr50
     DEFINE l_type             LIKE type_file.chr12
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",                                                          
               "  ?, ?, ?, ?, ?, ?)"                                                                                                
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
        EXIT PROGRAM
     END IF
     CALL cl_del_data(l_table)
     #CALL cl_used(g_prog,l_time,1) RETURNING l_time      #FUN-B90044  MARK
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT sma115 INTO g_sma115 FROM sma_file
     SELECT azi03,azi04,azi05
       INTO g_azi03,g_azi04,g_azi05
       FROM azi_file
      WHERE azi01=g_aza.aza17
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN
     #        LET tm.wc = tm.wc clipped," AND rvauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN
     #         LET tm.wc = tm.wc clipped," AND rvagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN
     #         LET tm.wc = tm.wc clipped," AND rvagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rvauser', 'rvagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','','',",
                 "    rva01,rva06,rva05,pmc03,rvb05,rvb07,pmn07,",
                 "    rvb04,rvb03,rvb83,rvb85",
		 "    ,rvb38,rvbiicd14,rvb41,rvb02 ",
                 " FROM rva_file,rvb_file,ima_file,",
                 "               OUTER pmn_file, OUTER pmc_file,OUTER rvbi_file",
                 " WHERE rva01=rvb01 AND rvb_file.rvb04=pmn_file.pmn01 AND rvb_file.rvb03=pmn_file.pmn02",
                 "   AND rva_file.rva05=pmc_file.pmc01 AND rvb_file.rvb01=rvbi_file.rvbiicd01 ",
                 "   AND rvb_file.rvb02=rvbi_file.rvbiicd02 AND rvaconf !='X' ",
                 "   AND rvb05=ima01 ",
		 "   and rvb39='Y' ",
		 "   and rvbi_file.rvbiicd03 not in ('30','40','50','51')",
		 "   and rvb33=0 ",
		 "   and rvb29=0 ",
                 "   AND ",tm.wc CLIPPED
 
     IF tm.d='1' THEN
        LET l_sql = l_sql CLIPPED," AND rvaconf='Y' "
     END IF
     IF tm.d='2' THEN
        LET l_sql = l_sql CLIPPED," AND rvaconf='N' "
     END IF
     PREPARE r050_prepare1 FROM l_sql
     IF STATUS != 0 THEN
        CALL cl_err('prepare:',STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044   
        EXIT PROGRAM
     END IF
     DECLARE r050_cs1 CURSOR FOR r050_prepare1
     IF STATUS != 0 THEN
        CALL cl_err('declare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
        EXIT PROGRAM
     END IF
     
     FOREACH r050_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.rva01
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.rva06 USING 'YYYYMMDD'
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.rva05
	       WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.rvb04
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.rvb05
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       IF tm.exm = '1' OR tm.exm='2' THEN
          SELECT pmm22 INTO l_pmm22 FROM pmm_file
             WHERE pmm01=sr.rvb03
          SELECT pmh08 INTO l_pmh08 FROM pmh_file
             WHERE pmh01=sr.rvb05 AND pmh02=sr.rva05 AND pmh13=l_pmm22
               AND pmhacti = 'Y'                                           #CHI-910021
           IF tm.exm='1' AND l_pmh08='Y' THEN CONTINUE FOREACH END IF
           IF tm.exm='2' AND l_pmh08='N' THEN CONTINUE FOREACH END IF
       END IF
       SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01=sr.rvb05
       IF SQLCA.sqlcode THEN
          LET l_ima021 = NULL
       END IF
       SELECT bmb03 INTO l_bmb03 FROM bmb_file WHERE bmb01=sr.rvb05
       SELECT sfa02 INTO l_sfa02 FROM sfa_file WHERE sfa01=sr.rvb04
       #FUN-BC0103 --START--
       SELECT imaicd18||' '||imaicd19 INTO l_pkg FROM imaicd_file 
        WHERE imaicd00 = sr.rvbiicd14
       IF SQLCA.sqlcode THEN LET l_pkg = NULL END IF
       IF cl_null(l_pkg) THEN
       #FUN-BC0103 --END--
          SELECT icj04||' '||icj05 INTO l_pkg FROM icj_file 
           WHERE icj01=sr.rvbiicd14 and icj02=sr.rvb05 and icj03=sr.rva05
       END IF   #FUN-BC0103      
       IF l_sfa02=7 THEN
	  LET l_type='work'
       ELSE
          IF l_sfa02=8 then
	     LET l_type='unwork'
	  END IF
       END IF
       
       EXECUTE insert_prep USING
                   sr.order1,sr.order2,sr.order3,sr.pmc03,sr.rva06,
                   sr.rva01,sr.rvb02,sr.rvb05,l_bmb03,sr.rvb38,sr.rvb04,
                   sr.rvb03,sr.rvb07,sr.pmn07,l_type,'t',l_pkg,
                   sr.rvb41,'t',sr.rvb85,sr.rvb83,l_ima021
     END FOREACH
     LET l_sql= "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str= ''
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog 
     IF g_zz05 = 'Y' THEN                                                                                                          
       CALL cl_wcchp(tm.wc,'rva01,rva06,rva05,rvb04,rvb05')                                                                                               
            RETURNING tm.wc 
       LET g_str = tm.wc
     END IF
     LET g_str =g_str,";",tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3]
     CALL cl_prt_cs3('aicr050','aicr050',l_sql,g_str)    
END FUNCTION
#No.FUN-830084---end
