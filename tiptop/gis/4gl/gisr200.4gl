# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: gisr200.4gl
# Descriptions...: 進項發票底稿清單
# Date & Author..: 02/04/04 By Danny
# Modify.........: No.FUN-510024 05/01/27 By Smapmin 報表轉XML格式
# Modify.........: No.TQC-5B0049 05/11/08 By Claire 報表格式調整
# Modify.........: No.FUN-690009 06/09/04 By Dxfwo  欄位類型定義
 
# Modify.........: No.FUN-6A0098 06/10/26 By atsea l_time轉g_time
# Modify.........: No.FUN-860019 08/06/10 By TSD.zeak 傳統報表轉Crystal Report
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80047 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                    # Print condition RECORD
             #wc      VARCHAR(1000),       # Where condition
	      wc      STRING,		#TQC-630166
              #FUN-860019 -start-
              #s       LIKE type_file.chr2,     #NO FUN-690009  VARCHAR(2)  # Order by sequence
              #t       LIKE type_file.chr2,     #NO FUN-690009  VARCHAR(2)  # Eject sw
              #u       LIKE type_file.chr2,     #NO FUN-690009  VARCHAR(2)  #
              s       LIKE type_file.chr3,
              t       LIKE type_file.chr3,
              u       LIKE type_file.chr3,
              #FUN-860019 --end--
              more    LIKE type_file.chr1      #NO FUN-690009  VARCHAR(1)  # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i          LIKE type_file.num5      #NO FUN-690009 SMALLINT  #count/index for any purpose
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
   LET g_sql ="order1.ise_file.ise01,",
              "order2.ise_file.ise01,",
              "order3.ise_file.ise01,",
              "ise00.ise_file.ise00,",
              "ise01.ise_file.ise01,",
              "ise02.ise_file.ise02,",
              "ise03.ise_file.ise03,",
              "ise04.ise_file.ise04,",
              "ise05.ise_file.ise05,",
              "ise051.ise_file.ise051,",
              "ise052.ise_file.ise052,",
              "ise06.ise_file.ise06,",
              "ise061.ise_file.ise061,",
              "ise062.ise_file.ise062,",
              "ise07.ise_file.ise07,",
              "ise08.ise_file.ise08,",
              "ise08x.ise_file.ise08x,",
              "ise08t.ise_file.ise08t,",
              "ise09.ise_file.ise09,",
              "ise10.ise_file.ise10,",
              "ise11.ise_file.ise11,",
              "ise12.ise_file.ise12,",
              "ise13.ise_file.ise13,",
              "ise14.ise_file.ise14,",
              "ise15.ise_file.ise15,",
              "ise16.ise_file.ise16,",
              "ise17.ise_file.ise17,",
              "ise18.ise_file.ise18,",
              "ise19.ise_file.ise19,",
              "ise20.ise_file.ise20,",
              "iseuser.ise_file.iseuser,",
              "isegrup.ise_file.isegrup,",
              "isemodu.ise_file.isemodu,",
              "isemodd.ise_file.isemodd,",
              "isedate.ise_file.isedate,",
              "azi04.azi_file.azi04,",
              "azi05.azi_file.azi05"
   
   LET l_table = cl_prt_temptable('gisr200',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,
                        ?,?,?,?,?,?,?,?,?,?,
                        ?,?,?,?,?,?,?,?,?,?,
                        ?,?,?,?,?,?,?)"                                                                                                       
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80047--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL gisr200_tm(0,0)        # Input print condition
      ELSE CALL gisr200()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80047--add--
END MAIN
 
FUNCTION gisr200_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #NO FUN-690009 SMALLINT
          l_cmd          LIKE type_file.chr1000       #NO FUN-690009 VARCHAR(400)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW gisr200_w AT p_row,p_col
        WITH FORM "gis/42f/gisr200"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm2.s1  = '4'
   LET tm2.s2  = '2'
   LET tm2.t1  = 'Y'
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
   CONSTRUCT BY NAME tm.wc ON ise01,ise03,ise04,ise062,ise00,ise07
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
      LET INT_FLAG = 0 CLOSE WINDOW gisr200_w
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
      LET INT_FLAG = 0 CLOSE WINDOW gisr200_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80047--add--
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='gisr200'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('gisr200','9031',1)
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
         CALL cl_cmdat('gisr200',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW gisr200_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80047--add--
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gisr200()
   ERROR ""
END WHILE
   CLOSE WINDOW gisr200_w
END FUNCTION
 
FUNCTION gisr200()
   DEFINE l_name    LIKE type_file.chr20,    #NO FUN-690009 VARCHAR(20)  # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0098
          l_sql     LIKE type_file.chr1000,  #NO FUN-690009 VARCHAR(1000)# RDSQL STATEMENT
          l_za05    LIKE type_file.chr50,    #NO FUN-690009 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE ise_file.ise01,   #NO FUN-690009 VARCHAR(20)
          sr        RECORD
                    order1 LIKE ise_file.ise01,   #NO FUN-690009 VARCHAR(20)
                    order2 LIKE ise_file.ise01,   #NO FUN-690009 VARCHAR(20)
                    order3 LIKE ise_file.ise01,   #FUN-860019
                    ise    RECORD LIKE ise_file.*
                    END RECORD
     #No.FUN-B80047--mark--Begin--- 
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098
     #No.FUN-B80047--mark--End-----  
     CALL cl_del_data(l_table)  #No.FUN-750110
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND iseuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND isegrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND isegrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('iseuser', 'isegrup')
     #End:FUN-980030
 
     #LET l_sql = "SELECT '','',ise_file.*", #FUN-860019
     LET  l_sql = "SELECT '','','',ise_file.*", #FUN-860019
                 "  FROM ise_file ",
                 " WHERE ",tm.wc CLIPPED
 
     PREPARE gisr200_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80047--add--
        EXIT PROGRAM
     END IF
     DECLARE gisr200_curs1 CURSOR FOR gisr200_prepare1
 
     FOREACH gisr200_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #FOR g_i = 1 TO 2     #FUN-860019
        FOR g_i = 1 TO 3     #FUN-860019
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ise.ise01
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ise.ise03
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.ise.ise04
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.ise.ise062
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.ise.ise00
               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.ise.ise07
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]   #FUN-860019
       
       #FUN-860019 add CR(3)
       EXECUTE insert_prep USING
          sr.order1,    sr.order2,    sr.order3,    sr.ise.ise00, sr.ise.ise01, sr.ise.ise02,
          sr.ise.ise03, sr.ise.ise04, sr.ise.ise05, sr.ise.ise051,sr.ise.ise052,
          sr.ise.ise06, sr.ise.ise061,sr.ise.ise062,sr.ise.ise07, sr.ise.ise08,
          sr.ise.ise08x,sr.ise.ise08t,sr.ise.ise09, sr.ise.ise10, sr.ise.ise11,
          sr.ise.ise12, sr.ise.ise13, sr.ise.ise14, sr.ise.ise15, sr.ise.ise16,
          sr.ise.ise17, sr.ise.ise18, sr.ise.ise19, sr.ise.ise20, sr.ise.iseuser,
          sr.ise.isegrup,sr.ise.isemodu,sr.ise.isemodd,sr.ise.isedate,
          g_azi04,g_azi05
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
 
     CALL cl_prt_cs3('gisr200','gisr200',l_sql,g_str)
     #---FUN-860019 add---END
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098
     #No.FUN-BB0047--mark--End-----
END FUNCTION
#No.FUN-870144
