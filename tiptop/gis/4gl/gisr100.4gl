# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: gisr100.4gl
# Descriptions...: 銷項發票底稿清單
# Date & Author..: 02/04/15 By Danny
# Modify.........: No.FUN-510024 05/01/27 By Smapmin 報表轉XML格式
# Modify.........: NO.FUN-5B0015 05/11/02 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.TQC-630166 06/03/16 By 整批修改，將g_wc[1,70]改為g_wc.subString(1,......)寫法
# Modify.........: No.FUN-690009 06/09/04 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0098 06/10/26 By atsea l_time轉g_time
# Modify.........: No.FUN-860019 08/06/10 By TSD.liquor 傳統報表轉Crystal Report
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80047 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
             #wc      VARCHAR(1000),      # Where condition
	      wc      STRING,         # TQC-630166
              s       LIKE type_file.chr5,     #NO FUN-690009 VARCHAR(2)    # Order by sequence
              t       LIKE type_file.chr5,     #NO FUN-690009 VARCHAR(2)    # Eject sw
              u       LIKE type_file.chr5,     #NO FUN-690009 VARCHAR(2)    #
              more    LIKE type_file.chr1      #NO FUN-690009 VARCHAR(1)    # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i          LIKE type_file.num5      #NO FUN-690009 SMALLINT   #count/index for any purpose
DEFINE   l_table              STRING,    #FUN-860019 add
         g_sql                STRING,    #FUN-860019 add
         g_str                STRING     #FUN-860019 add
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GIS")) THEN
      EXIT PROGRAM
   END IF
 
   #---FUN-860019 add ---start
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql ="order1.isa_file.isa04,",
              "order2.isa_file.isa04,",
              "order3.isa_file.isa04,",
              "isa04.isa_file.isa04,",
              "isb03.isb_file.isb03,",
              "isa051.isa_file.isa051,",
              "isa052.isa_file.isa052,",
              "isa062.isa_file.isa062,",
              "isa07.isa_file.isa07,",
              "isa061.isa_file.isa061,",
              "isa01.isa_file.isa01,",
              "isb05.isb_file.isb05,",
              "isb09.isb_file.isb09,",
              "isb09x.isb_file.isb09x,",
              "isb09t.isb_file.isb09t,",
              "azi04.azi_file.azi04,",
              "azi05.azi_file.azi05"
   
   LET l_table = cl_prt_temptable('gisr100',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   #------------------------------ CR (1) ------------------------------#
   #---FUN-860019 add ---end
 
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.s    = ARG_VAL(8)
   LET tm.t    = ARG_VAL(9)
   LET tm.u    = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80047--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL gisr100_tm(0,0)        # Input print condition
      ELSE CALL gisr100()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80047--add--
END MAIN
 
FUNCTION gisr100_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01      #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,     #NO FUN-690009 SMALLINT
          l_cmd          LIKE type_file.chr1000   #NO FUN-690009 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 14
   OPEN WINDOW gisr100_w AT p_row,p_col
        WITH FORM "gis/42f/gisr100"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm2.s1  = '3'
   LET tm2.s2  = '2'
   LET tm2.t1  = 'N'
   LET tm2.t2  = 'N'
   LET tm2.t3  = 'N'
   LET tm2.u1  = 'Y'
   LET tm2.u2  = 'N'
   LET tm2.u3  = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON isa04,isa05,isa062,isa00,isa07
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
           #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW gisr100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80047--add--
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
     INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                   tm2.t1,tm2.t2,tm2.t3,
                   tm2.u1,tm2.u2,tm2.u3,
                   tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
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
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW gisr100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80047--add--
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='gisr100'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('gisr100','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('gisr100',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW gisr100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80047--add--
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gisr100()
   ERROR ""
END WHILE
   CLOSE WINDOW gisr100_w
END FUNCTION
 
FUNCTION gisr100()
   DEFINE l_name    LIKE type_file.chr20,     #NO FUN-690009 VARCHAR(20)    # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0098
          l_sql     LIKE type_file.chr1000,   #NO FUN-690009 VARCHAR(1000)  # RDSQL STATEMENT
          l_za05    LIKE type_file.chr1000,   #NO FUN-690009 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE isa_file.isa04,  #NO FUN-690009 VARCHAR(20)
          sr        RECORD
                    order1 LIKE isa_file.isa04,       #NO FUN-690009 VARCHAR(20)
                    order2 LIKE isa_file.isa04,       #NO FUN-690009 VARCHAR(20)
                    order3 LIKE isa_file.isa04,       #FUN-860019 add
                    isa    RECORD LIKE isa_file.*,
                    isb    RECORD LIKE isb_file.*
                    END RECORD
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?)" 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80047--add--
      EXIT PROGRAM
   END IF
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   #------------------------------ CR (2) ------------------------------#
      #No.FUN-B80047--mark--Begin--- 
      # CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098
      #No.FUN-B80047--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND isauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND isagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND isagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('isauser', 'isagrup')
     #End:FUN-980030
 
    #LET l_sql = "SELECT '','',isa_file.*,isb_file.* ",    #FUN-860019 mod 2 -> 3
     LET l_sql = "SELECT '','','',isa_file.*,isb_file.* ", #FUN-860019 mod 2 -> 3
                 "  FROM isa_file,isb_file ",
                 " WHERE isa01 = isb01 AND isa04 = isb02 ",
                 "   AND ",tm.wc CLIPPED
 
     PREPARE gisr100_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80047--add--
        EXIT PROGRAM
     END IF
     DECLARE gisr100_curs1 CURSOR FOR gisr100_prepare1
 
     FOREACH gisr100_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       FOR g_i = 1 TO 3  #FUN-860019 mod 2 -> 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.isa.isa04
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.isa.isa05
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.isa.isa062
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.isa.isa00
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.isa.isa07
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]  #FUN-860019 add
       #FUN-860019 add CR(3)
       EXECUTE insert_prep USING 
           sr.order1,sr.order2,sr.order3,sr.isa.isa04,sr.isb.isb03,
           sr.isa.isa051,sr.isa.isa052,sr.isa.isa062,sr.isa.isa07,
           sr.isa.isa061,sr.isa.isa01,sr.isb.isb05,sr.isb.isb09,
           sr.isb.isb09x, sr.isb.isb09t,g_azi04,g_azi05
       #FUN-860019 add end
     END FOREACH
 
     #FUN-860019  ---start---
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> 
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
  
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'isa04,isa05,isa062,isa00,isa07')
             RETURNING g_str
     ELSE
        LET g_str = ''
     END IF
 
     LET g_str = g_str,";",tm.t,";",tm.u
 
     CALL cl_prt_cs3('gisr100','gisr100',l_sql,g_str)
     #---FUN-860019 add---END
 
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098
     #No.FUN-BB0047--mark--End-----
END FUNCTION
#No.FUN-870144
