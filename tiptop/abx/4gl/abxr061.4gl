# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: abxr061.4gl
# Descriptions...: 按月彙報內銷登記簿
# LIKE type_file.dat & Author..: 06/11/06 By kim
# Modify.........: No.FUN-850089 08/05/26 By TSD.odyliao 傳統報表轉Crystal Report
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80082 11/08/08 By fengrui  程式撰寫規範修正 
# Modify.........: No.MOD-CC0165 12/12/26 By Elise 放大異動原因代碼1、異動原因代碼2欄位

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                      # Print condition RECORD
              wc      STRING,         # Where condition
              a       LIKE bxr_file.bxr01,    #MOD-CC0165 mod chr2 -> bxr01
              a2      LIKE bxr_file.bxr01,    #MOD-CC0165 mod chr2 -> bxr01           
              bdate   LIKE type_file.dat,
              edate   LIKE type_file.dat,
              s       LIKE type_file.chr2,           # 排列順序項目     
              u       LIKE type_file.chr2,           # 小計     
              yy      LIKE type_file.num5,              # 申報年       
              mm      LIKE type_file.num5,              # 申報月    
              detail_flag  LIKE type_file.chr1,      # 明細列印否    
              choice  LIKE type_file.chr1,           # 資料來源   
              more    LIKE type_file.chr1             # Input more condition(Y/N)
              END RECORD,
          g_bxr02       LIKE bxr_file.bxr02
 
DEFINE   g_i             LIKE type_file.num5   #count/index for any purpose
DEFINE   g_bxe01     LIKE bxe_file.bxe01 
DEFINE   g_bxe02     LIKE bxe_file.bxe02
DEFINE   g_bxe03     LIKE bxe_file.bxe03
DEFINE   g_bxz05         LIKE type_file.num20_6 
DEFINE   g_bxj15         LIKE bxj_file.bxj15 
DEFINE   g_sql           STRING   #FUN-850089 add
DEFINE   g_str           STRING   #FUN-850089 add
DEFINE   l_table         STRING   #FUN-850089 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   LET g_pdate = ARG_VAL(1)       # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s      = ARG_VAL(8)
   LET tm.u      = ARG_VAL(9)
   LET tm.yy     = ARG_VAL(10)
   LET tm.mm     = ARG_VAL(11)
   LET tm.bdate  = ARG_VAL(12)
   LET tm.edate  = ARG_VAL(13)
   LET tm.a      = ARG_VAL(14)
   LET tm.a2     = ARG_VAL(15)
   LET tm.detail_flag = ARG_VAL(16)
   LET tm.choice = ARG_VAL(17)
   LET tm.more   = ARG_VAL(18)
   LET g_rep_user = ARG_VAL(19)
   LET g_rep_clas = ARG_VAL(20)
   LET g_template = ARG_VAL(21)
 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
#FUN-850089 ----START---- add
LET g_sql = "order1.ima_file.ima01,",
            "order2.ima_file.ima01,",
            "ima01.ima_file.ima01,",
            "ima02.ima_file.ima02,",
            "ima021.ima_file.ima021,",
            "ima22.ima_file.ima22,",
            "ima1916.ima_file.ima1916,",
            "oga27.oga_file.oga27,",
            "intax.type_file.num20_6,",
            "saltax.type_file.num20_6,",
            "tax.type_file.num20_6,",
            "occ02.occ_file.occ02,",
            "bxi03.bxi_file.bxi03,",
            "bxj14.bxj_file.bxj14,",
            "bxj13.bxj_file.bxj13,",
            "bxj06.bxj_file.bxj06,",
            "bxj20.bxj_file.bxj20,",
            "bxj15.bxj_file.bxj15,",
            "bxi04.bxi_file.bxi04,",
            "bxj05.bxj_file.bxj05,",
            "bxj11.bxj_file.bxj11,",
            "bxj10.bxj_file.bxj10,",
            "bxe01.bxe_file.bxe01,",
            "bxe02.bxe_file.bxe02,",
            "bxe03.bxe_file.bxe03,",
            "bxz05.bxz_file.bxz05,",
            "bxz101.bxz_file.bxz101"
 
   LET l_table = cl_prt_temptable('abxr061',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
            " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
            "        ?,?,?,?,?, ?,?,?,?,?, ?,?)"
 
PREPARE insert_prep FROM g_sql
 
IF STATUS THEN
     CALL cl_err('insert_prep:',status,1)
     EXIT PROGRAM
END IF
#------------------------------ CR (1) ------------------------------#
#FUN-850089 ----END----  add
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80082--add-- 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' # If background job sw is off
      THEN CALL abxr061_tm(4,15)        # Input print condition
      ELSE CALL abxr061()               # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
END MAIN
 
FUNCTION abxr061_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000    
 
   LET p_row = 6 LET p_col = 22
 
   OPEN WINDOW abxr061_w AT p_row,p_col WITH FORM "abx/42f/abxr061"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s = '21'
   LET tm.u = 'NN'
   LET tm2.s1 = tm.s[1,1]   
   LET tm2.s2 = tm.s[2,2]
   LET tm2.u1 = tm.u[1,1]
   LET tm2.u2 = tm.u[2,2]
   LET tm.detail_flag = 'Y'
   LET tm.choice = '1'
   LET tm.more = 'N'
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima01,ima1916
 
      ON ACTION CONTROLP
         CASE    
           WHEN INFIELD(ima01)
             CALL cl_init_qry_var()   
             LET g_qryparam.form = "q_ima"
             LET g_qryparam.state = 'c'  
             CALL cl_create_qry() RETURNING g_qryparam.multiret 
             DISPLAY g_qryparam.multiret TO ima01 
             NEXT FIELD ima01 
           WHEN INFIELD(ima1916)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_bxe01"
             LET g_qryparam.state = 'c'
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ima1916
             NEXT FIELD ima1916
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
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr061_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   
   INPUT BY NAME tm2.s1,tm2.s2,tm2.u1,tm2.u2,
                 tm.yy,tm.mm,tm.bdate,tm.edate,tm.a,tm.a2,
                 tm.detail_flag,tm.choice,tm.more
      WITHOUT DEFAULTS
 
      AFTER FIELD yy
           IF NOT cl_null(tm.yy) AND (tm.yy <= 0) THEN   
              NEXT FIELD yy   
           END IF     
 
      AFTER FIELD mm         
           IF NOT cl_null(tm.mm) AND (tm.mm < 1 OR tm.mm > 12) THEN   
              NEXT FIELD mm   
           END IF     
 
      AFTER FIELD choice     
           IF tm.choice NOT MATCHES "[1-2]" THEN  
              NEXT FIELD choice   
           END IF  
 
      AFTER FIELD detail_flag  
           IF tm.detail_flag NOT MATCHES "[YN]" THEN 
              NEXT FIELD detail_flag
           END IF    
 
      AFTER FIELD bdate
           IF NOT cl_null(tm.bdate) THEN
              IF NOT cl_null(tm.edate) THEN 
                 IF tm.edate < tm.bdate THEN
                    NEXT FIELD bdate 
                 END IF
              END IF
           END IF
 
      AFTER FIELD edate
           IF NOT cl_null(tm.edate) THEN
              IF NOT cl_null(tm.bdate) THEN
                 IF tm.edate < tm.bdate THEN
                    NEXT FIELD edate
                 END IF
              END IF
           END IF
 
      AFTER FIELD a
           IF NOT cl_null(tm.a) THEN
              LET  g_bxr02 = NULL 
              SELECT bxr02 INTO g_bxr02 FROM bxr_file WHERE bxr01 = tm.a
              IF STATUS THEN
                 CALL cl_err('err bxr01 ',STATUS,0)
                 NEXT FIELD a
              END IF
              DISPLAY g_bxr02 TO b
           ELSE
              DISPLAY ' ' TO b2
           END IF
 
      AFTER FIELD a2
           IF NOT cl_null(tm.a2) THEN
              LET  g_bxr02 = NULL
              SELECT bxr02 INTO g_bxr02 FROM bxr_file WHERE bxr01 = tm.a2
              IF STATUS THEN
                 CALL cl_err('err bxr01 ',STATUS,0)
                 NEXT FIELD a2
              END IF
              DISPLAY g_bxr02 TO b2
           ELSE 
              DISPLAY ' ' TO b2
           END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER INPUT   
           LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
           LET tm.u = tm2.u1,tm2.u2
 
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(a)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_bxr'
                 LET g_qryparam.default1 = tm.a
                 CALL cl_create_qry() RETURNING tm.a
                 DISPLAY BY NAME tm.a             
                 NEXT FIELD a
              WHEN INFIELD(a2)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_bxr'
                 LET g_qryparam.default1 = tm.a2
                 CALL cl_create_qry() RETURNING tm.a2
                 DISPLAY BY NAME tm.a2        
                 NEXT FIELD a2
              OTHERWISE
                 EXIT CASE
           END CASE
 
      ON ACTION CONTROLR
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
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr061_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abxr061'
      IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
         CALL cl_err('abxr061','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s       CLIPPED,"'",
                         " '",tm.u       CLIPPED,"'",
                         " '",tm.yy      CLIPPED,"'",
                         " '",tm.mm      CLIPPED,"'",
                         " '",tm.bdate   CLIPPED,"'",
                         " '",tm.edate   CLIPPED,"'",
                         " '",tm.a       CLIPPED,"'",
                         " '",tm.a2      CLIPPED,"'",
                         " '",tm.detail_flag   CLIPPED,"'",
                         " '",tm.choice  CLIPPED,"'",
                         " '",tm.more    CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",     
                         " '",g_rep_clas CLIPPED,"'",    
                         " '",g_template CLIPPED,"'"    
 
         CALL cl_cmdat('abxr061',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW abxr061_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abxr061()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr061_w
END FUNCTION
 
FUNCTION abxr061()
   DEFINE l_name    LIKE type_file.chr20,       # External(Disk) file name
          l_sql     STRING,            # RDSQL STATEMENT
          l_chr     LIKE type_file.chr1,
          l_bnb14   LIKE type_file.num10,
          l_sfa03   LIKE sfa_file.sfa03,
          l_order   ARRAY[2] OF LIKE ima_file.ima01
   DEFINE sr   RECORD
               order1     LIKE ima_file.ima01,
               order2     LIKE ima_file.ima01,
               ima01  LIKE ima_file.ima01,
               ima02  LIKE ima_file.ima02,
               ima021 LIKE ima_file.ima021,
               ima22  LIKE ima_file.ima22,
               ima1916 LIKE ima_file.ima1916,
               oga27  LIKE oga_file.oga27,
               intax  LIKE type_file.num20_6,
               saltax LIKE type_file.num20_6,
               tax    LIKE type_file.num20_6,
               occ02  LIKE occ_file.occ02
               END RECORD
   DEFINE l_bxi RECORD LIKE bxi_file.*,
          l_bxj RECORD LIKE bxj_file.*
   DEFINE l_bnb RECORD LIKE bnb_file.*,
          l_bnc RECORD LIKE bnc_file.*
 
  #FUN-850089 ----START---- add
   CALL cl_del_data(l_table)
  #------------------------------ CR (2) ------------------------------#
  #FUN-850089 ----END---- add
     #No.FUN-B80082--mark--Begin--- 
     #CALL cl_used(g_prog,g_time,1) RETURNING g_time 
     #No.FUN-B80082--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    
     IF tm.choice = '1' THEN
        LET l_sql ="SELECT '','',",
                   " ima01,ima02,ima021,ima22,ima1916, ",
                   " oga27,0,0,0,'',bxi_file.*,bxj_file.* ",
                   "  FROM ima_file,bxi_file,bxj_file,OUTER oga_file ",
                   " WHERE ",tm.wc CLIPPED,
                   "   AND bxi01 = bxj01 ",
                   "   AND ima01 = bxj04 ",
                   "   AND bxi_file.bxi01 = oga_file.oga01 ",
                   "   AND bxi02 >='",tm.bdate,"'",
                   "   AND bxi02 <='",tm.edate,"'"
 
     ELSE
        LET l_sql ="SELECT '','',",
                    " ima01,ima02,ima021,ima22,ima1916, ",
                    " oga27,0,0,0,'',bxi_file.*,bxj_file.*,",
                    " bnb_file.*,bnc_file.* ",
                    "  FROM ima_file,bxi_file,bxj_file,OUTER oga_file, ",
                    "       bnb_file,bnc_file ",
                    " WHERE ",tm.wc CLIPPED,
                    "   AND bxi01 = bxj01 ",
                    "   AND ima01 = bnc03 ",
                    "   AND bnb01 = bnc01 ",
                    "   AND bnb04 = bxi01 ",
                    "   AND bnc02 = bxj03 ",
                    "   AND bxi_file.bxi01 = oga_file.oga01 ",
                    "   AND bxi02 >='",tm.bdate,"'",
                    "   AND bxi02 <='",tm.edate,"'"
 
     END IF
      
     IF NOT cl_null(tm.a2) THEN 
        LET l_sql = l_sql CLIPPED," AND (bxi08='",tm.a,"' OR bxi08='",tm.a2,"') "     
     ELSE 
        LET l_sql = l_sql CLIPPED," AND bxi08='",tm.a,"' "     
     END IF
     IF NOT cl_null(tm.yy) THEN 
        LET l_sql = l_sql CLIPPED," AND bxi11=",tm.yy     
     END IF
     IF NOT cl_null(tm.mm) THEN   
        LET l_sql = l_sql CLIPPED," AND bxi12=",tm.mm
     END IF
 
     PREPARE abxr061_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
        EXIT PROGRAM
     END IF
     DECLARE abxr061_curs1 CURSOR FOR abxr061_prepare1
 
     LET g_bxz05 = g_bxz.bxz05   # 保證金期初金額
     FOREACH abxr061_curs1 INTO sr.*,l_bxi.*,l_bxj.*,l_bnb.*,l_bnc.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF tm.choice = '2' THEN
          LET l_bxi.bxi03 = l_bnb.bnb05
          LET l_bxj.bxj06 = l_bnc.bnc06
          LET l_bxj.bxj20 = l_bnc.bnc08 * l_bnc.bnc09
          LET l_bxj.bxj15 = l_bnc.bnc10
          LET l_bxj.bxj10 = l_bnb.bnb15
          LET l_bxj.bxj05 = l_bnc.bnc05
          LET l_bxj.bxj14 = l_bnb.bnb02
          LET l_bxj.bxj13 = l_bnb.bnb01
       END IF
       SELECT occ02 INTO sr.occ02 FROM occ_file
        WHERE occ01 = l_bxi.bxi03
       IF STATUS OR cl_null(sr.occ02) THEN
           SELECT pmc03 INTO sr.occ02 FROM pmc_file
               WHERE pmc01 = l_bxi.bxi03
           IF STATUS OR cl_null(sr.occ02) THEN
               LET sr.occ02 = ' '
           END IF
       END IF
       IF cl_null(sr.ima22) THEN LET sr.ima22 = 0 END IF
       IF cl_null(l_bxj.bxj06) THEN LET l_bxj.bxj06 = 0 END IF
       IF cl_null(l_bxj.bxj20) THEN LET l_bxj.bxj20 = 0 END IF
       IF cl_null(l_bxj.bxj15) THEN LET l_bxj.bxj15 = 0 END IF
       LET sr.intax  = l_bxj.bxj15 * sr.ima22 / 100
       LET sr.saltax = (l_bxj.bxj15 + sr.intax) * 0.05
       LET sr.tax    = sr.intax + sr.saltax
 
       FOR g_i = 1 TO 2
           CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ima01  #料件編號
                WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima1916  #保稅群組代碼
                WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.occ02  #客戶編號
                OTHERWISE LET l_order[g_i]  = '-'
           END CASE
       END FOR  
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
 
#FUN-850089 ----START----  add
       IF tm.s[1,1] = '2' THEN
           LET g_bxe01 = sr.ima1916
           CALL r061_bxe01()
       END IF  
       EXECUTE insert_prep USING 
               sr.order1,sr.order2,sr.ima01,sr.ima02,sr.ima021,
               sr.ima22,sr.ima1916,sr.oga27,sr.intax,sr.saltax, 
               sr.tax,sr.occ02,
               l_bxi.bxi03,l_bxj.bxj14,l_bxj.bxj13,l_bxj.bxj06,
               l_bxj.bxj20,l_bxj.bxj15,l_bxi.bxi04,l_bxj.bxj05,
               l_bxj.bxj11,l_bxj.bxj10,g_bxe01,g_bxe02,g_bxe03,
               g_bxz.bxz05,g_bxz.bxz101 
 
#FUN-850089 ----END----  add
     END FOREACH
 
  #FUN-840139  ----START---- add
   SELECT zz05 INTO g_zz05 FROM zz_file
       WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'') RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
 
    LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.u,
                ";",g_bxz.bxz100,";",g_bxz.bxz102,";",tm.detail_flag,
                ";",tm.yy,";",tm.mm USING '##'
    CALL cl_prt_cs3('abxr061','abxr061',l_sql,g_str)
   #------------------------------ CR (4) ------------------------------#
  #FUN-850089 ----END----  add

     #No.FUN-B80082--mark--Begin--- 
     #CALL cl_used(g_prog,g_time,2) RETURNING g_time
     #No.FUN-B80082--mark--End-----
END FUNCTION
#No.FUN-870144
 
# 保稅規格代碼、品名、規格
FUNCTION r061_bxe01()
 
 LET g_bxe02 = NULL
 LET g_bxe03 = NULL
 
 SELECT bxe02,bxe03 INTO g_bxe02,g_bxe03
  FROM bxe_file
  WHERE bxe01 = g_bxe01
 
END FUNCTION
 
