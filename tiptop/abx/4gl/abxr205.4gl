# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: abxr205.4gl
# Descriptions...: 受託加工案件進出廠紀錄卡 
# Date & Author..: 2006/10/20 By kim
 
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-850089 08/05/30 By TSD.zeak 報表改寫由CR產出
# Modify.........: No.FUN-890101 08/09/23 By dxfwo  CR 追單到31區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80082 11/08/08 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      STRING,         # Where condition
              sdate   LIKE type_file.dat,
              edate   LIKE type_file.dat,
              rdate   LIKE type_file.dat,
              a       LIKE type_file.chr1,
              b       LIKE type_file.chr1,
              s       LIKE type_file.chr2,           # 排列順序項目     
              u       LIKE type_file.chr2,           # 小計     
              more    LIKE type_file.chr1            # Input more condition(Y/N)
              END RECORD
DEFINE   g_i             LIKE type_file.num5   #count/index for any purpose
DEFINE   g_yy1           LIKE type_file.chr4
DEFINE   g_mm1           LIKE type_file.chr4
DEFINE   g_yy2           LIKE type_file.chr4
DEFINE   g_mm2           LIKE type_file.chr4
#FUN-850089 By TSD.zeak  ---start---  
DEFINE l_table       STRING                   
DEFINE g_str         STRING  
DEFINE g_sql         STRING                 
#FUN-850089 By TSD.zeak  ----end----  
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                   # Supress DEL key function
 
   LET g_pdate    = ARG_VAL(1)       # Get arguments from command line
   LET g_towhom   = ARG_VAL(2)
   LET g_rlang    = ARG_VAL(3)
   LET g_bgjob    = ARG_VAL(4)
   LET g_prtway   = ARG_VAL(5)
   LET g_copies   = ARG_VAL(6)
   LET tm.wc      = ARG_VAL(7)
   LET tm.sdate   = ARG_VAL(8)
   LET tm.edate   = ARG_VAL(9)
   LET tm.rdate   = ARG_VAL(10)
   LET tm.a       = ARG_VAL(11)
   LET tm.b       = ARG_VAL(12)
   LET tm.s       = ARG_VAL(13)
   LET tm.u       = ARG_VAL(14)
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   #FUN-850089 By TSD.zeak  ---start---  
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "occ02.occ_file.occ02,",
               "bxi02.bxi_file.bxi02,",
               "bxj22.bxj_file.bxj22,",
               "bxj23.bxj_file.bxj23,",
               "bxi02_in.bxi_file.bxi02,",
               "bxj04_in.bxj_file.bxj04,",
               "ima02_in.ima_file.ima02,",
               "ima021_in.ima_file.ima021,",
               "bxj05_in.bxj_file.bxj05,",
               "bxj06_in.bxj_file.bxj06,",
               "bxd18_in.bxd_file.bxd18,",
               "bxi02_out.bxi_file.bxi02,",
               "bxj04_out.bxi_file.bxi04,",
               "ima02_out.ima_file.ima02,",
               "ima021_out.ima_file.ima021,",
               "bxj05_out.bxj_file.bxj05,",
               "bxj06_out1.bxj_file.bxj06,",
               "bxj06_out2.bxj_file.bxj06,",
               "bxj06_out3.bxj_file.bxj06,",
               "bnb01_out.bnb_file.bnb01,",
               "bxd18.bxd_file.bxd18,",
               "bxz100.bxz_file.bxz100,",
               "bxz101.bxz_file.bxz101,",
               "bxz102.bxz_file.bxz102,",
               "bxe02.bxe_file.bxe02,",
               "bxe03.bxe_file.bxe03,",
               "ima01.ima_file.ima01,",
               "ima1916.ima_file.ima1916"
 
   LET l_table = cl_prt_temptable('abxr205',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,
                        ?,?,?,?,?,?,?,?,?,?,
                        ?,?,?,?,?,?,?,?) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #FUN-850089 By TSD.zeak  ----end----  
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
   DROP TABLE r205_file;
   CREATE TEMP TABLE r205_file(
    order1        LIKE ima_file.ima02,
    order2        LIKE ima_file.ima02,
    occ02         LIKE occ_file.occ02, 
    bxi02         LIKE bxi_file.bxi02, 
    bxj22         LIKE bxj_file.bxj22, 
    bxj23         LIKE bxj_file.bxj23, 
    bxi02_in      LIKE bxi_file.bxi02, 
    bxj04_in      LIKE bxj_file.bxj04, 
    ima02_in      LIKE ima_file.ima02, 
    ima021_in     LIKE ima_file.ima021, 
    bxj05_in      LIKE bxj_file.bxj05, 
    bxj06_in      LIKE bxj_file.bxj06, 
    bxd18_in      LIKE bxd_file.bxd18,
    bxi02_out     LIKE bxi_file.bxi02, 
    bxj04_out     LIKE bxi_file.bxi04, 
    ima02_out     LIKE ima_file.ima02, 
    ima021_out    LIKE ima_file.ima02, 
    bxj05_out     LIKE bxj_file.bxj05, 
    bxj06_out1    LIKE bxj_file.bxj06, 
    bxj06_out2    LIKE bxj_file.bxj06, 
    bxj06_out3    LIKE bxj_file.bxj06, 
    bnb01_out     LIKE bnb_file.bnb01, 
    bxd18         LIKE bxd_file.bxd18,
    ima01         LIKE ima_file.ima01,
    ima1916       LIKE ima_file.ima1916,
    bxe02         LIKE bxe_file.bxe02,
    bxe03         LIKE bxe_file.bxe03); 
   DELETE FROM r205_file WHERE 1=1;
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80082--add--
   IF cl_null(tm.wc) THEN 
      CALL abxr205_tm(0,0)        # Input print condition
   ELSE
      CALL abxr205()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
END MAIN
 
FUNCTION abxr205_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000    
 
   LET p_row = 6 LET p_col = 22
 
   OPEN WINDOW abxr205_w AT p_row,p_col WITH FORM "abx/42f/abxr205"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.sdate = g_today
   LET tm.edate = g_today
   LET tm.rdate = g_today
   LET tm.a = 'N'
   LET tm.b = 'Y'
   LET tm2.s1 = '2'
   LET tm2.s2 = '1'
   LET tm2.u1 = 'Y'
   LET tm2.u2 = 'N'
   LET tm.more = 'N'
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
             LET g_qryparam.state = 'c'  
             LET g_qryparam.form = "q_ima20"
             CALL cl_create_qry() RETURNING g_qryparam.multiret 
             DISPLAY g_qryparam.multiret TO FORMONLY.ima01 
             NEXT FIELD ima01 
 
           WHEN INFIELD(ima1916)
             CALL cl_init_qry_var()
             LET g_qryparam.state = 'c'
             LET g_qryparam.form = "q_bxe01"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO FORMONLY.ima1916
             NEXT FIELD ima1916
 
           OTHERWISE
             EXIT CASE
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
      LET INT_FLAG = 0
      CLOSE WINDOW abxr205_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   
   INPUT BY NAME tm.sdate,tm.edate,tm.rdate,tm.a,tm.b,
                 tm2.s1,tm2.s2,tm2.u1,tm2.u2,tm.more
      WITHOUT DEFAULTS
 
      AFTER FIELD sdate
        IF NOT cl_null(tm.sdate) AND NOT cl_null(tm.edate) THEN 
           IF tm.sdate > tm.edate THEN
              CALL cl_err(tm.sdate,'mfg9234',0)
              NEXT FIELD sdate 
           END IF
        END IF
 
      AFTER FIELD edate
        IF NOT cl_null(tm.edate) AND NOT cl_null(tm.sdate) THEN
           IF tm.edate < tm.sdate THEN
              CALL cl_err(tm.edate,'anm-091',0)
              NEXT FIELD edate
           END IF
        END IF
 
      AFTER FIELD a
        IF tm.a NOT MATCHES '[YN]' THEN
           NEXT FIELD a
        END IF
 
      AFTER FIELD b
        IF tm.b NOT MATCHES '[YN]' THEN
           NEXT FIELD b
        END IF
 
      AFTER FIELD s1
        IF tm2.s1 NOT MATCHES '[12]' THEN
           NEXT FIELD s1
        END IF
 
      AFTER FIELD s2
        IF tm2.s2 NOT MATCHES '[12]' THEN
           NEXT FIELD s2
        END IF
 
      AFTER FIELD u1
        IF tm2.u1 NOT MATCHES '[YN]' THEN
           NEXT FIELD u1
        END IF
 
      AFTER FIELD u2
        IF tm2.u2 NOT MATCHES '[YN]' THEN
           NEXT FIELD u2
        END IF
 
      AFTER FIELD more
        IF tm.more = 'Y' THEN
           CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
        END IF
 
      AFTER INPUT   
         IF tm2.s1 = tm2.s2 THEN
            CALL cl_err('','abx-044',0)
            NEXT FIELD s1
         END IF
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
         LET tm.u = tm2.u1,tm2.u2
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
              RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
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
      LET INT_FLAG = 0
      CLOSE WINDOW abxr205_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='abxr205'
      IF SQLCA.SQLCODE OR cl_null(l_cmd) THEN
         CALL cl_err('abxr205','9031',1)
      ELSE
         LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                     " '",g_pdate CLIPPED,"'",
                     " '",g_towhom CLIPPED,"'",
                     " '",g_rlang CLIPPED,"'",
                     " '",g_bgjob CLIPPED,"'",
                     " '",g_prtway CLIPPED,"'",
                     " '",g_copies CLIPPED,"'",
                     " '",tm.wc CLIPPED,"'",
                     " '",tm.sdate CLIPPED,"'",
                     " '",tm.edate CLIPPED,"'",
                     " '",tm.rdate CLIPPED,"'",
                     " '",tm.a CLIPPED,"'",
                     " '",tm.b CLIPPED,"'",
                     " '",tm.s CLIPPED,"'",
                     " '",tm.u CLIPPED,"'",
                     " '",g_rep_user CLIPPED,"'",     
                     " '",g_rep_clas CLIPPED,"'",    
                     " '",g_template CLIPPED,"'"    
         CALL cl_cmdat('abxr205',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW abxr205_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abxr205()
   ERROR ""
END WHILE
CLOSE WINDOW abxr205_w
END FUNCTION
  
FUNCTION abxr205()
   DEFINE l_name       LIKE type_file.chr20,       # External(Disk) file name
#       l_time          LIKE type_file.chr8           #No.FUN-6A0062
          l_sql        STRING,            # RDSQL STATEMENT
          l_order      ARRAY[2] OF LIKE ima_file.ima02,
          l_cnt        LIKE type_file.num5,
          l_ima01      LIKE ima_file.ima01,
          l_ima1916  LIKE ima_file.ima1916,
          #FUN-850089 By TSD.zeak  ---start--- 
          l_bxe02      LIKE bxe_file.bxe02,
          l_bxe03      LIKE bxe_file.bxe03,
          #FUN-850089 By TSD.zeak  ----end----  
          l_data    RECORD
                    bxi01         LIKE bxi_file.bxi01,
                    bxi02         LIKE bxi_file.bxi02,
                    bxi15     LIKE bxi_file.bxi15,
                    bxj03         LIKE bxj_file.bxj03,
                    bxj04         LIKE bxj_file.bxj04,
                    bxj05         LIKE bxj_file.bxj05,
                    bxj06         LIKE bxj_file.bxj06,
                    bxj22     LIKE bxj_file.bxj22,
                    bxj23     LIKE bxj_file.bxj23
                    END RECORD,
              sr    RECORD
                    order1        LIKE ima_file.ima02,
                    order2        LIKE ima_file.ima02,
                    occ02         LIKE occ_file.occ02,
                    bxi02         LIKE bxi_file.bxi02,
                    bxj22     LIKE bxj_file.bxj22,
                    bxj23     LIKE bxj_file.bxj23,
                    bxi02_in      LIKE bxi_file.bxi02,
                    bxj04_in      LIKE bxj_file.bxj04,
                    ima02_in      LIKE ima_file.ima02,
                    ima021_in     LIKE ima_file.ima021,
                    bxj05_in      LIKE bxj_file.bxj05,
                    bxj06_in      LIKE bxj_file.bxj06,
                    bxd18_in  LIKE bxd_file.bxd18,
                    bxi02_out     LIKE bxi_file.bxi02,
                    bxj04_out     LIKE bxi_file.bxi04,
                    ima02_out     LIKE ima_file.ima02,
                    ima021_out    LIKE ima_file.ima021,
                    bxj05_out     LIKE bxj_file.bxj05,
                    bxj06_out1    LIKE bxj_file.bxj06,
                    bxj06_out2    LIKE bxj_file.bxj06,
                    bxj06_out3    LIKE bxj_file.bxj06,
                    bnb01_out     LIKE bnb_file.bnb01,
                    bxd18     LIKE bxd_file.bxd18,
                    #FUN-850089 By TSD.zeak  ---start--- 
                    ima01         LIKE ima_file.ima01,
                    ima1916       LIKE ima_file.ima1916,
                    bxe02         LIKE bxe_file.bxe02,
                    bxe03         LIKE bxe_file.bxe03
                    #FUN-850089 By TSD.zeak  ----end---- 
                    END RECORD,
              sr_t  RECORD
                    order1        LIKE ima_file.ima02,
                    order2        LIKE ima_file.ima02,
                    occ02         LIKE occ_file.occ02,
                    bxi02         LIKE bxi_file.bxi02,
                    bxj22     LIKE bxj_file.bxj22,
                    bxj23     LIKE bxj_file.bxj23,
                    bxi02_in      LIKE bxi_file.bxi02,
                    bxj04_in      LIKE bxj_file.bxj04,
                    ima02_in      LIKE ima_file.ima02,
                    ima021_in     LIKE ima_file.ima021,
                    bxj05_in      LIKE bxj_file.bxj05,
                    bxj06_in      LIKE bxj_file.bxj06,
                    bxd18_in  LIKE bxd_file.bxd18,
                    bxi02_out     LIKE bxi_file.bxi02,
                    bxj04_out     LIKE bxi_file.bxi04,
                    ima02_out     LIKE ima_file.ima02,
                    ima021_out    LIKE ima_file.ima021,
                    bxj05_out     LIKE bxj_file.bxj05,
                    bxj06_out1    LIKE bxj_file.bxj06,
                    bxj06_out2    LIKE bxj_file.bxj06,
                    bxj06_out3    LIKE bxj_file.bxj06,
                    bnb01_out     LIKE bnb_file.bnb01,
                    bxd18     LIKE bxd_file.bxd18,
                    #FUN-850089 By TSD.zeak  ---start--- 
                    ima01         LIKE ima_file.ima01,
                    ima1916       LIKE ima_file.ima1916,
                    bxe02         LIKE bxe_file.bxe02,
                    bxe03         LIKE bxe_file.bxe03
                    #FUN-850089 By TSD.zeak  ----end----                     
                    END RECORD

     #No.FUN-B80082--mark--Begin--- 
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time   #No.FUN-6A0062
     #No.FUN-B80082--mark--End----- 

     #FUN-850089 By TSD.zeak  ---start---  
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #------------------------------ CR (2) ------------------------------#
     #FUN-850089 By TSD.zeak  ----end----  
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'abxr205'
 
     # 推算起始日期的上期年度及月份
     IF MONTH(tm.sdate) = 1 THEN
        LET g_yy1 = YEAR(tm.sdate) - 1
        LET g_mm1 = 12
     ELSE
        LET g_yy1 = YEAR(tm.sdate)
        LET g_mm1 = MONTH(tm.sdate) - 1
     END IF
 
     # 計算起始日期的本期年度及月份
     LET g_yy2 = YEAR(tm.sdate)
     LET g_mm2 = MONTH(tm.sdate)
 
     LET l_sql = "SELECT ima01,ima1916 FROM ima_file ",
                 " WHERE (ima106 = '1' OR (ima106 = '6' AND ima1919 = 'Y'))",
                 "   AND ",tm.wc CLIPPED
     IF tm.a = 'Y' THEN
        LET l_sql = l_sql CLIPPED," AND ima15 = 'Y' "
     END IF 
     PREPARE abxr205_prepare1 FROM l_sql
     IF SQLCA.SQLCODE THEN
        CALL cl_err('prepare1:',SQLCA.SQLCODE,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
        EXIT PROGRAM
     END IF
     DECLARE abxr205_curs1 CURSOR FOR abxr205_prepare1
 
     LET l_sql = "SELECT * FROM r205_file ",
                 " ORDER BY occ02,order1,order2,bxi02,bxj22,bxj23 "
     PREPARE abxr205_prepare2 FROM l_sql
     IF SQLCA.SQLCODE THEN
        CALL cl_err('prepare2:',SQLCA.SQLCODE,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
        EXIT PROGRAM
     END IF
     DECLARE abxr205_curs3 CURSOR FOR abxr205_prepare2
 
     DELETE FROM r205_file WHERE 1=1;
 
#     CALL cl_outnam('abxr205') RETURNING l_name  #No.FUN-890101
 
#     START REPORT abxr205_rep TO l_name          #No.FUN-890101
     LET g_pageno = 0
     FOREACH abxr205_curs1 INTO l_ima01,l_ima1916 
       IF STATUS THEN
          CALL cl_err('foreach1:',STATUS,1)
          EXIT FOREACH
       END IF
 
       IF cl_null(l_ima1916) THEN
          LET l_ima1916 = ' '
       END IF
 
       LET l_cnt = 0    # 檢查此料件有無當期異動資料
       DECLARE abxr205_curs2 CURSOR FOR
         SELECT bxi01,bxi02,bxi15,bxj03,bxj04,
                bxj05,bxj06,bxj22,bxj23
           FROM bxi_file,bxj_file
          WHERE bxi01 = bxj01 
            AND bxi02 >= tm.sdate 
            AND bxi02 <= tm.edate 
            AND bxj04 = l_ima01 
            AND bxj22 IS NOT NULL 
            AND bxj23 IS NOT NULL
 
       FOREACH abxr205_curs2 INTO l_data.*
          IF STATUS THEN
             CALL cl_err('foreach2:',STATUS,1)
             CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
             EXIT PROGRAM
          END IF
 
          IF l_data.bxi15 NOT MATCHES '[1239]' THEN
             CONTINUE FOREACH
          END IF
 
          INITIALIZE sr.* TO NULL
 
          #FUN-850089 By TSD.zeak  ---start---  
          SELECT bxe02,bxe03
            INTO sr.bxe02,sr.bxe03
            FROM bxe_file
           WHERE bxe01 = l_ima1916 
          LET sr.ima01 = l_ima01
          LET sr.ima1916 = l_ima1916
          #FUN-850089 By TSD.zeak  ----end----  
 
          SELECT occ02 INTO sr.occ02
            FROM oea_file,occ_file
           WHERE oea01 = l_data.bxj22
             AND oea03 = occ01
          IF SQLCA.SQLCODE OR cl_null(sr.occ02) THEN
             LET sr.occ02 = ' '
          END IF
 
          IF NOT cl_null(l_data.bxi02) THEN
             LET sr.bxi02 = l_data.bxi02
          ELSE
             LET sr.bxi02 = ' '
          END IF
 
          IF NOT cl_null(l_data.bxj22) THEN
             LET sr.bxj22 = l_data.bxj22
          ELSE
             LET sr.bxj22 = ' '
          END IF
 
          IF NOT cl_null(l_data.bxj23) THEN
             LET sr.bxj23 = l_data.bxj23
          ELSE
             LET sr.bxj23 = ' '
          END IF
 
          # 入庫部份
          IF l_data.bxi15 = '1' THEN
             LET sr.bxi02_in = l_data.bxi02
             LET sr.bxj04_in = l_data.bxj04
             SELECT ima02,ima021
               INTO sr.ima02_in,sr.ima021_in
               FROM ima_file
              WHERE ima01 = sr.bxj04_in
             LET sr.bxj05_in = l_data.bxj05
             LET sr.bxj06_in = l_data.bxj06
 
             SELECT SUM(bxd18) INTO sr.bxd18_in
               FROM bxd_file
              WHERE bxd01 = sr.bxj04_in
                AND bxd03 = g_yy1
                AND bxd04 = g_mm1
             IF SQLCA.SQLCODE OR cl_null(sr.bxd18_in) THEN
                LET sr.bxd18_in = 0
             END IF
          ELSE
             #出廠部份
             IF l_data.bxi15 = '2' OR
                l_data.bxi15 = '3' OR
                l_data.bxi15 = '9' THEN
                LET sr.bxi02_out = l_data.bxi02
                LET sr.bxj04_out = l_data.bxj04
                SELECT ima02,ima021
                  INTO sr.ima02_out,sr.ima021_out
                  FROM ima_file
                 WHERE ima01 = sr.bxj04_out
                LET sr.bxj05_out = l_data.bxj05
                CASE l_data.bxi15 
                  WHEN '9' LET sr.bxj06_out1 = l_data.bxj06
                  WHEN '3' LET sr.bxj06_out2 = l_data.bxj06
                  WHEN '2' LET sr.bxj06_out3 = l_data.bxj06
                END CASE
 
                # 放行單編號
                DECLARE r205_bnb01 SCROLL CURSOR FOR
                  SELECT bnb01
                    FROM bnb_file,bnc_file,bxj_file,bxi_file
                   WHERE bnb01 = bnc01
                     AND bnc011 = bxj01
                     AND bnc012 = bxj03
                     AND bxj01 = bxi01
                     AND bxi01 = l_data.bxi01
                     AND bxj03 = l_data.bxj03
                  ORDER BY bnb02 DESC
                OPEN r205_bnb01
                IF STATUS THEN
                   LET sr.bnb01_out = ''
                END IF
                FETCH FIRST r205_bnb01 INTO sr.bnb01_out
                IF SQLCA.SQLCODE THEN
                   LET sr.bnb01_out = ''
                END IF
                CLOSE r205_bnb01
             END IF
          END IF
                
             #尚未出廠原料餘量
             SELECT SUM(bxd18) INTO sr.bxd18
               FROM bxd_file
              WHERE bxd01 = l_data.bxj04
                AND bxd03 = g_yy2
                AND bxd04 = g_mm2
             IF SQLCA.SQLCODE OR cl_null(sr.bxd18) THEN
                LET sr.bxd18 = 0
             END IF
 
          FOR g_i = 1 TO 2
            CASE
              WHEN tm.s[g_i,g_i] = '1'
                   LET l_order[g_i] = l_data.bxj04      #料件編號
              WHEN tm.s[g_i,g_i] = '2'
                   LET l_order[g_i] = l_ima1916       #保稅群組代碼
            END CASE
          END FOR
          LET sr.order1 = l_order[1]
          LET sr.order2 = l_order[2]
 
          INSERT INTO r205_file VALUES(sr.*)
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
             CALL cl_err('insert temp table:',SQLCA.SQLCODE,1)
             CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
             EXIT PROGRAM
          END IF
          LET l_cnt = l_cnt + 1
       END FOREACH
 
       #當期無異動者，且須列印上期餘量
       IF l_cnt = 0 AND tm.b = 'Y' THEN
          INITIALIZE sr.* TO NULL
          #FUN-850089 By TSD.zeak  ---start---  
          SELECT bxe02,bxe03
            INTO sr.bxe02,sr.bxe03
            FROM bxe_file
           WHERE bxe01 = l_ima1916 
          LET sr.ima01 = l_ima01
          LET sr.ima1916 = l_ima1916
          #FUN-850089 By TSD.zeak  ----end----  
          LET sr.occ02 = ' ' 
          LET sr.bxi02 = ' '
          LET sr.bxj22 = ' '
          LET sr.bxj23 = ' '
          LET sr.bxj04_in = l_ima01
          SELECT ima02,ima021,ima25
            INTO sr.ima02_in,sr.ima021_in,sr.bxj05_in
            FROM ima_file
           WHERE ima01 = l_ima01
       
          SELECT SUM(bxd18) INTO sr.bxd18
            FROM bxd_file
           WHERE bxd01 = l_ima01 
             AND bxd03 = g_yy2
             AND bxd04 = g_mm2
          IF SQLCA.SQLCODE OR cl_null(sr.bxd18) THEN
             LET sr.bxd18 = 0
          END IF
 
          FOR g_i = 1 TO 2
            CASE
              WHEN tm.s[g_i,g_i] = '1'
                   LET l_order[g_i] = l_ima01           #料件編號
              WHEN tm.s[g_i,g_i] = '2'
                   LET l_order[g_i] = l_ima1916       #保稅群組代碼
                   #FUN-850089 By TSD.zeak  ---start---  
                   SELECT bxe02,bxe03
                     INTO l_bxe02,l_bxe03
                     FROM bxe_file
                    WHERE bxe01 = l_ima1916 
                    IF cl_null(l_bxe02) THEN LET l_bxe02 = ' ' END IF
                    IF cl_null(l_bxe03) THEN LET l_bxe03 = ' ' END IF
                   #FUN-850089 By TSD.zeak  ----end----
            END CASE
          END FOR
          LET sr.order1 = l_order[1]
          LET sr.order2 = l_order[2]
 
          INSERT INTO r205_file VALUES(sr.*)
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
             #CALL cl_err(sr.order1,'!',1)
             #CALL cl_err(sr.order2,'!',1)
             CALL cl_err3("ins tmp","r205_file",sr.order1,sr.order2,SQLCA.SQLCODE,"","",1)
             CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
             EXIT PROGRAM
          END IF
       END IF
     END FOREACH
 
     LET l_cnt = 0 
     FOREACH abxr205_curs3 INTO sr.*
       IF STATUS THEN
          CALL cl_err('foreach3:',STATUS,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
          EXIT PROGRAM
       END IF
 
       LET l_cnt = l_cnt + 1 
       IF l_cnt = 1 THEN 
          LET sr_t.* = sr.*
          CONTINUE FOREACH
       ELSE
          IF tm.s[1,1] = '1' THEN
             IF sr.occ02 = sr_t.occ02 AND sr.order1 = sr_t.order1 THEN
                LET sr_t.bxd18 = NULL
             END IF
          ELSE
             IF sr.occ02 = sr_t.occ02 AND sr.order2 = sr_t.order2 THEN
                LET sr_t.bxd18 = NULL
             END IF
          END IF
          #FUN-850089 By TSD.zeak  ---start--- 
          EXECUTE insert_prep USING 
               sr_t.occ02, sr_t.bxi02, sr_t.bxj22, sr_t.bxj23, sr_t.bxi02_in,
               sr_t.bxj04_in,  sr_t.ima02_in,  sr_t.ima021_in, sr_t.bxj05_in,
               sr_t.bxj06_in,  sr_t.bxd18_in,  sr_t.bxi02_out, sr_t.bxj04_out,
               sr_t.ima02_out, sr_t.ima021_out,sr_t.bxj05_out,sr_t.bxj06_out1,
               sr_t.bxj06_out2,sr_t.bxj06_out3,sr_t.bnb01_out,sr_t.bxd18,
               g_bxz.bxz100,   g_bxz.bxz101,   g_bxz.bxz102,
               sr_t.bxe02,        sr_t.bxe03,        sr_t.ima01,       sr_t.ima1916
#          OUTPUT TO REPORT abxr205_rep(sr_t.*)          
          #FUN-850089 By TSD.zeak  ----end----                 
 
          LET sr_t.* = sr.*
       END IF
     END FOREACH
     IF l_cnt > 0 THEN
#        OUTPUT TO REPORT abxr205_rep(sr_t.*)
#hoho---------------------(S)
let sr_t.bxj06_in=1
let sr_t.bxj06_out1=1
let sr_t.bxj06_out2=2
let sr_t.bxj06_out3=3
#hoho---------------------(E)
        #FUN-850089 By TSD.zeak  ---start---  
        EXECUTE insert_prep USING 
             sr_t.occ02, sr_t.bxi02, sr_t.bxj22, sr_t.bxj23, sr_t.bxi02_in,
             sr_t.bxj04_in,  sr_t.ima02_in,  sr_t.ima021_in, sr_t.bxj05_in,
             sr_t.bxj06_in,  sr_t.bxd18_in,  sr_t.bxi02_out, sr_t.bxj04_out,
             sr_t.ima02_out, sr_t.ima021_out,sr_t.bxj05_out,sr_t.bxj06_out1,
             sr_t.bxj06_out2,sr_t.bxj06_out3,sr_t.bnb01_out,sr_t.bxd18,
             g_bxz.bxz100,   g_bxz.bxz101,    g_bxz.bxz102,
             sr_t.bxe02,        sr_t.bxe03,        sr_t.ima01,       sr_t.ima1916
        #FUN-850089 By TSD.zeak  ----end----  
     END IF
 
     #FUN-850089 By TSD.zeak      ---start---
#     FINISH REPORT abxr205_rep
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720005 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'ima01,ima1916')
             RETURNING g_str
     ELSE
        LET g_str = ' '
     END IF
     LET g_str = g_str,";",
                 YEAR(tm.rdate)-1911 USING '###',";",  #p2
                 MONTH(tm.rdate) USING '##',";",   #p3
                 DAY(tm.rdate) USING '##',";",     #p4
                 tm.s[1,1],";",                    #p5
                 tm.s[2,2],";",                    #p6
                 tm.u[1,1],";",                    #p7
                 tm.u[2,2]                         #p8
     CALL cl_prt_cs3('abxr205','abxr205',l_sql,g_str)   
     #------------------------------ CR (4) ------------------------------#
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #FUN-850089 By TSD.zeak  ----end----  
    
     #No.FUN-B80082--mark--Begin---
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0062
     #No.FUN-B80082--mark--End-----
END FUNCTION
 
#No.FUN-890101
#REPORT abxr205_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,
#          l_bxe02  LIKE bxe_file.bxe02,
#          l_bxe03  LIKE bxe_file.bxe03,
#          l_bxj06_sum  LIKE bxj_file.bxj06,
#          l_amt_1      LIKE bxj_file.bxj06,
#          l_amt_2      LIKE bxj_file.bxj06,
#          l_amt_3      LIKE bxj_file.bxj06,
#          l_amt_4      LIKE bxj_file.bxj06,
#                 sr    RECORD
#                       order1        LIKE ima_file.ima02,
#                       order2        LIKE ima_file.ima02,
#                       occ02         LIKE occ_file.occ02,
#                       bxi02         LIKE bxi_file.bxi02,
#                       bxj22     LIKE bxj_file.bxj22,
#                       bxj23     LIKE bxj_file.bxj23,
#                       bxi02_in      LIKE bxi_file.bxi02,
#                       bxj04_in      LIKE bxj_file.bxj04,
#                       ima02_in      LIKE ima_file.ima02,
#                       ima021_in     LIKE ima_file.ima021,
#                       bxj05_in      LIKE bxj_file.bxj05,
#                       bxj06_in      LIKE bxj_file.bxj06,
#                       bxd18_in  LIKE bxd_file.bxd18,
#                       bxi02_out     LIKE bxi_file.bxi02,
#                       bxj04_out     LIKE bxi_file.bxi04,
#                       ima02_out     LIKE ima_file.ima02,
#                       ima021_out    LIKE ima_file.ima021,
#                       bxj05_out     LIKE bxj_file.bxj05,
#                       bxj06_out1    LIKE bxj_file.bxj06,
#                       bxj06_out2    LIKE bxj_file.bxj06,
#                       bxj06_out3    LIKE bxj_file.bxj06,
#                       bnb01_out     LIKE bnb_file.bnb01,
#                       bxd18     LIKE bxd_file.bxd18
#                       END RECORD
#
#  OUTPUT 
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
#
#  ORDER EXTERNAL BY sr.occ02,sr.order1,sr.order2,sr.bxi02,sr.bxj22,sr.bxj23
# 
#  FORMAT
#   PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company)
#                         -FGL_WIDTH(g_bxz.bxz100)
#                         -FGL_WIDTH(g_bxz.bxz102))/2)+3,
#                  g_bxz.bxz100 CLIPPED,' ',
#                  g_company CLIPPED,' ',
#                  g_bxz.bxz102 CLIPPED,'                  ',
#                  g_x[11] CLIPPED,g_bxz.bxz101 CLIPPED
#     PRINT ''
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED
#     PRINT ''
#     PRINT COLUMN 01,g_x[12] CLIPPED,sr.occ02 CLIPPED
#     LET g_pageno = g_pageno + 1
#     PRINT COLUMN 01,g_x[2] CLIPPED,YEAR(tm.rdate) USING '####',g_x[19] CLIPPED,
#                                    MONTH(tm.rdate) USING '##',g_x[20] CLIPPED,
#                                    DAY(tm.rdate) USING '##',g_x[21] CLIPPED,
#           COLUMN (g_len-FGL_WIDTH(g_x[3])-3)+1,g_x[3] CLIPPED,
#                                                g_pageno USING '<<<'
#     PRINT g_dash     
#     PRINT g_x[31],
#           g_x[32],
#           g_x[33],
#           g_x[34],
#           g_x[35],
#           g_x[36],
#           g_x[37],
#           g_x[38],
#           g_x[39],
#           g_x[40],
#           g_x[41],
#           g_x[42],
#           g_x[43],
#           g_x[44],
#           g_x[45],
#           g_x[46],
#           g_x[47],
#           g_x[48]
#                
#     PRINT g_dash1
#     LET l_last_sw = 'n'
#
#  BEFORE GROUP OF sr.occ02
#     LET l_bxj06_sum = 0
#     SKIP TO TOP OF PAGE
#
#  BEFORE GROUP OF sr.order1
#     IF tm.s[1,1] = '1' THEN
#        LET l_bxj06_sum = 0
#     END IF
#
#  BEFORE GROUP OF sr.order2
#     IF tm.s[2,2] = '1' THEN
#        LET l_bxj06_sum = 0 
#     END IF
#
#  ON EVERY ROW
#     IF NOT cl_null(sr.bxj06_in) AND NOT cl_null(sr.bxd18_in) THEN
#        LET l_bxj06_sum = l_bxj06_sum + sr.bxj06_in
#        LET sr.bxd18_in = sr.bxd18_in + l_bxj06_sum
#     END IF
#     PRINT COLUMN g_c[31],sr.bxi02_in USING 'YY/MM/DD',
#           COLUMN g_c[32],sr.bxj04_in,
#           COLUMN g_c[33],sr.ima02_in,
#           COLUMN g_c[34],sr.ima021_in,
#           COLUMN g_c[35],sr.bxj05_in,
#           COLUMN g_c[36],cl_numfor(sr.bxj06_in,36,3),
#           COLUMN g_c[37],cl_numfor(sr.bxd18_in,37,3),
#           COLUMN g_c[38],sr.bxi02_out USING 'YY/MM/DD',
#           COLUMN g_c[39],sr.bxj04_out,
#           COLUMN g_c[40],sr.ima02_out,
#           COLUMN g_c[41],sr.ima021_out,
#           COLUMN g_c[42],sr.bxj05_out,
#           COLUMN g_c[43],cl_numfor(sr.bxj06_out1,43,3),
#           COLUMN g_c[44],cl_numfor(sr.bxj06_out2,44,3),
#           COLUMN g_c[45],cl_numfor(sr.bxj06_out3,45,3),
#           COLUMN g_c[46],sr.bnb01_out,
#           COLUMN g_c[47],cl_numfor(sr.bxd18,47,3)
#
#   AFTER GROUP of sr.order1
#      IF tm.u[1,1] = 'Y' THEN  
#         LET l_amt_1 = GROUP SUM(sr.bxj06_in)
#         LET l_amt_2 = GROUP SUM(sr.bxj06_out1)
#         LET l_amt_3 = GROUP SUM(sr.bxj06_out2)
#         LET l_amt_4 = GROUP SUM(sr.bxj06_out3)
#         CASE
#           WHEN l_amt_1 = 0  LET l_amt_1 = NULL
#           WHEN l_amt_2 = 0  LET l_amt_2 = NULL
#           WHEN l_amt_3 = 0  LET l_amt_3 = NULL
#           WHEN l_amt_4 = 0  LET l_amt_4 = NULL
#         END CASE
#         IF NOT(cl_null(l_amt_1) AND cl_null(l_amt_2) AND
#                cl_null(l_amt_3) AND cl_null(l_amt_4)) THEN
#            PRINT g_dash2
#            IF tm.s[1,1] = '1' THEN  # 以料號排序且小計
#               PRINT COLUMN g_c[34],sr.order1 CLIPPED,' ',g_x[16] CLIPPED,
#                     COLUMN g_c[35],g_x[17] CLIPPED;
#               IF NOT cl_null(l_amt_1) THEN
#                  PRINT COLUMN g_c[36],cl_numfor(l_amt_1,36,3);
#               END IF
#               IF NOT cl_null(l_amt_2) THEN
#                  PRINT COLUMN g_c[43],cl_numfor(l_amt_2,43,3);
#               END IF
#               IF NOT cl_null(l_amt_3) THEN
#                  PRINT COLUMN g_c[44],cl_numfor(l_amt_3,44,3);
#               END IF
#               IF NOT cl_null(l_amt_4) THEN
#                  PRINT COLUMN g_c[45],cl_numfor(l_amt_4,45,3)
#               END IF
#            ELSE                     # 以保稅群組代碼排序且小計 
#               LET l_bxe02 = ''
#               LET l_bxe03 = ''
#               SELECT bxe02,bxe03
#                 INTO l_bxe02,l_bxe03
#                 FROM bxe_file
#                WHERE bxe01 = sr.order1
#               IF NOT cl_null(sr.order1) THEN
#                  PRINT COLUMN g_c[32],sr.order1,' ',g_x[13] CLIPPED;
#               END IF
#               IF NOT cl_null(l_bxe02) THEN
#                  PRINT COLUMN g_c[33],l_bxe02,' ',g_x[14] CLIPPED;
#               END IF
#               IF NOT cl_null(l_bxe03) THEN
#                  PRINT COLUMN g_c[34],l_bxe03,' ',g_x[15] CLIPPED;
#               END IF
#               PRINT COLUMN g_c[35],g_x[17] CLIPPED;
#               IF NOT cl_null(l_amt_1) THEN
#                  PRINT COLUMN g_c[36],cl_numfor(l_amt_1,36,3);
#               END IF
#               IF NOT cl_null(l_amt_2) THEN
#                  PRINT COLUMN g_c[43],cl_numfor(l_amt_2,43,3);
#               END IF
#               IF NOT cl_null(l_amt_3) THEN
#                  PRINT COLUMN g_c[44],cl_numfor(l_amt_3,44,3);
#               END IF
#               IF NOT cl_null(l_amt_4) THEN
#                  PRINT COLUMN g_c[45],cl_numfor(l_amt_4,45,3)
#               END IF
#            END IF
#            PRINT ''
#         END IF
#      END IF
#
#   AFTER GROUP of sr.order2
#      IF tm.u[2,2] = 'Y' THEN  
#         LET l_amt_1 = GROUP SUM(sr.bxj06_in)
#         LET l_amt_2 = GROUP SUM(sr.bxj06_out1)
#         LET l_amt_3 = GROUP SUM(sr.bxj06_out2)
#         LET l_amt_4 = GROUP SUM(sr.bxj06_out3)
#         CASE
#           WHEN l_amt_1 = 0  LET l_amt_1 = NULL
#           WHEN l_amt_2 = 0  LET l_amt_2 = NULL
#           WHEN l_amt_3 = 0  LET l_amt_3 = NULL
#           WHEN l_amt_4 = 0  LET l_amt_4 = NULL
#         END CASE
#         IF NOT(cl_null(l_amt_1) AND cl_null(l_amt_2) AND
#                cl_null(l_amt_3) AND cl_null(l_amt_4)) THEN
#            PRINT g_dash2
#            IF tm.s[2,2] = '1' THEN  # 以料號排序且小計
#               PRINT COLUMN g_c[34],sr.order2 CLIPPED,' ',g_x[16] CLIPPED,
#                     COLUMN g_c[35],g_x[17] CLIPPED;
#               IF NOT cl_null(l_amt_1) THEN
#                  PRINT COLUMN g_c[36],cl_numfor(l_amt_1,36,3);
#               END IF
#               IF NOT cl_null(l_amt_2) THEN
#                  PRINT COLUMN g_c[43],cl_numfor(l_amt_2,43,3);
#               END IF
#               IF NOT cl_null(l_amt_3) THEN
#                  PRINT COLUMN g_c[44],cl_numfor(l_amt_3,44,3);
#               END IF
#               IF NOT cl_null(l_amt_4) THEN
#                  PRINT COLUMN g_c[45],cl_numfor(l_amt_4,45,3)
#               END IF
#            ELSE                     # 以保稅群組代碼排序且小計 
#               LET l_bxe02 = ''
#               LET l_bxe03 = ''
#               SELECT bxe02,bxe03
#                 INTO l_bxe02,l_bxe03
#                 FROM bxe_file
#                WHERE bxe01 = sr.order2
#               IF NOT cl_null(sr.order2) THEN
#                  PRINT COLUMN g_c[32],sr.order2,' ',g_x[13] CLIPPED;
#               END IF
#               IF NOT cl_null(l_bxe02) THEN
#                  PRINT COLUMN g_c[33],l_bxe02,' ',g_x[14] CLIPPED;
#               END IF
#               IF NOT cl_null(l_bxe03) THEN
#                  PRINT COLUMN g_c[34],l_bxe03,' ',g_x[15] CLIPPED;
#               END IF
#               PRINT COLUMN g_c[35],g_x[17] CLIPPED;
#               IF NOT cl_null(l_amt_1) THEN
#                  PRINT COLUMN g_c[36],cl_numfor(l_amt_1,36,3);
#               END IF
#               IF NOT cl_null(l_amt_2) THEN
#                  PRINT COLUMN g_c[43],cl_numfor(l_amt_2,43,3);
#               END IF
#               IF NOT cl_null(l_amt_3) THEN
#                  PRINT COLUMN g_c[44],cl_numfor(l_amt_3,44,3);
#               END IF
#               IF NOT cl_null(l_amt_4) THEN
#                  PRINT COLUMN g_c[45],cl_numfor(l_amt_4,45,3)
#               END IF
#            END IF
#            PRINT ''
#         END IF
#      END IF
#
#   ON LAST ROW     
#      PRINT g_dash
#      LET l_amt_1 = SUM(sr.bxj06_in)
#      LET l_amt_2 = SUM(sr.bxj06_out1)
#      LET l_amt_3 = SUM(sr.bxj06_out2)
#      LET l_amt_4 = SUM(sr.bxj06_out3)
#      IF NOT(cl_null(l_amt_1) AND cl_null(l_amt_2) AND
#             cl_null(l_amt_3) AND cl_null(l_amt_4)) THEN
#         PRINT COLUMN g_c[35],g_x[18] CLIPPED,
#               COLUMN g_c[36],cl_numfor(l_amt_1,36,3),
#               COLUMN g_c[43],cl_numfor(l_amt_2,43,3),
#               COLUMN g_c[44],cl_numfor(l_amt_3,44,3),
#               COLUMN g_c[45],cl_numfor(l_amt_4,45,3)
#      END IF
#      PRINT g_dash  
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, 
#            COLUMN (g_len-9), g_x[7] CLIPPED
#  
#   PAGE TRAILER   
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash
#         PRINT g_x[4],g_x[5] CLIPPED,
#               COLUMN (g_len-9),g_x[6] CLIPPED       
#      ELSE  
#         SKIP 2 LINE
#      END IF
#       
#END REPORT
#No.FUN-890101  
