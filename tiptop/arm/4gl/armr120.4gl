# Prog. Version..: '5.30.06-13.03.12(00006)'     #
 
# Pattern name...: armr120.4gl
# Descriptions...: RMA Index Record 列印
# Date & Author..: 98/02/12 By Alan
# Modify.........: No.FUN-4B0045 04/11/15 By Smapmin 客戶編號,部門開窗
# Modify.........: No.FUN-510044 05/02/02 By Mandy 報表轉XML
# Modify.........: No.TQC-5C0021 05/12/06 By Nicola 接下頁超出報表
# Modify.........: No.TQC-5C0064 05/12/13 By kevin 結束位置調整
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6C0213 07/01/12 By chenl 報表尾部修正。
# Modify.........: No.FUN-860018 08/06/06 By TSD.SusanWu 報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By chenmoyan 追單到31區 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B70174 11/07/29 By houlia 調整部門欄位開窗資料
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.CHI-C80041 12/12/20 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm    RECORD                    # Print condition RECORD
                wc      LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(600),        # Where condition
                more    LIKE type_file.chr1     #No.FUN-690010 VARCHAR(1)           # Input more condition(Y/N)
             END RECORD
DEFINE g_i   LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE l_table        STRING                    #FUN-860018 add
DEFINE g_str          STRING                    #FUN-860018 add
DEFINE g_sql          STRING                    #FUN-860018 add
 
MAIN
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-BB0047  mark

   IF (NOT cl_user()) THEN
      #CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #houlia  #No.FUN-BB0047 
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ARM")) THEN
      #CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #houlia #No.FUN-BB0047 
      EXIT PROGRAM
   END IF
 
   LET g_pdate = ARG_VAL(1)               # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
 
   ## --> FUN-860018 CR(1)
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> *** ##
   LET g_sql = "rma01.rma_file.rma01, ",
               "rma02.rma_file.rma02, ",
               "rma03.rma_file.rma03, ",
               "rma04.rma_file.rma04, ",
               "rma09.rma_file.rma09, ",
               "rma11.rma_file.rma11, ",
               "rma18.rma_file.rma18, ",
               "rma20.rma_file.rma20, ",
               "rmb111.rmb_file.rmb111, ",
               "rmb12.rmb_file.rmb12, ",
               "rme02.rme_file.rme02  "
 
   LET l_table = cl_prt_temptable("armr120",g_sql) CLIPPED
   IF l_table = -1 THEN 
      #CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-BB0047 
      EXIT PROGRAM 
   END IF
 
   LET g_sql = " INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?) "
   PREPARE insert_prep FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err("insert_prep",SQLCA.sqlcode,1)
      #CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-BB0047 
      EXIT PROGRAM
   END IF
   ## <-- FUN-860018 CR(1)
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-BB0047 add
 
   IF cl_null(g_bgjob) OR g_bgjob='N' THEN
      CALL armr120_tm(0,0)
   ELSE
      CALL armr120()
   END IF
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #houlia
  
END MAIN
 
FUNCTION armr120_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col  LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 14
   #  CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #houlia  #No.FUN-BB0047 mark
 
   OPEN WINDOW armr120_w AT p_row,p_col
     WITH FORM "arm/42f/armr120"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON rma01,rma02,rma03,rma20,rma14
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION CONTROLP
            IF INFIELD(rma03) THEN #客戶編號    #FUN-4B0045
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_occ"
               LET g_qryparam.state    = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rma03
               NEXT FIELD rma03
            END IF
            IF INFIELD(rma14) THEN #部門    #FUN-4B0045
               CALL cl_init_qry_var()
           #   LET g_qryparam.form     = "q_occ"    #TQC-B70174
               LET g_qryparam.form     = "q_gem"    #TQC-B70174
               LET g_qryparam.state    = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rma14
               NEXT FIELD rma14
            END IF
 
         ON ACTION locale
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
         LET INT_FLAG = 0
         CLOSE WINDOW armr120_w
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #houlia
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
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
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW armr120_w
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='armr120'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('armr120','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('armr120',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW armr120_w
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
 
      CALL armr120()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW armr120_w
        
END FUNCTION
 
FUNCTION armr120()
   DEFINE l_name    LIKE type_file.chr20,          # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
          l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_order   ARRAY[5] OF LIKE type_file.chr20,   #No.FUN-690010 VARCHAR(20),
          sr        RECORD
                       rma02  LIKE rma_file.rma02,
                       rma01  LIKE rma_file.rma01,
                       rma03  LIKE rma_file.rma03,  #FUN-510044
                       rma04  LIKE rma_file.rma04,
                       rma06  LIKE rma_file.rma06,
                       rma11  LIKE rma_file.rma11,
                       rma09  LIKE rma_file.rma09,
                       rma20  LIKE rma_file.rma20,
                       rma18  LIKE rma_file.rma18,
                      #rma19  LIKE rma_file.rma19,
                       rme02  LIKE rme_file.rme02,
                       rmb12  LIKE rmb_file.rmb12,
                       rmb111 LIKE rmb_file.rmb111
                    END RECORD
 
   CALL cl_del_data(l_table)  ##CR(2) FUN-860018
 
   #No.FUN-BB0047--mark--Begin---
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
   #No.FUN-BB0047--mark--End-----
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog ##FUN-860018 CR(2)
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND rmauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND rmagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND rmagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rmauser', 'rmagrup')
   #End:FUN-980030
 
 
   LET l_sql = "SELECT rma02,rma01,rma03,rma04,rma06,rma11,", #FUN-510044 add rma03
               "       rma09,rma20,rma18,'',sum(rmb12),sum(rmb111) ",
               "  FROM rma_file,OUTER rmb_file  ",
               " WHERE ",tm.wc CLIPPED,
               "   AND  rma_file.rma01=rmb_file.rmb01 ",
               " GROUP BY rma02,rma01,rma03,rma04,rma06,rma11,rma09,rma20,rma18 "
 
   PREPARE armr120_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE armr120_curs1 CURSOR FOR armr120_prepare1
 
   FOREACH armr120_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT rme02 INTO sr.rme02 FROM rme_file
       WHERE rme01 IN (SELECT MAX(rme01) FROM rme_file
                        WHERE rme011=sr.rma01 AND rmevoid='Y'
                          AND rmeconf <> 'X' )  #CHI-C80041
 
      ## --> FUN-860018 CR(3)
      EXECUTE insert_prep USING sr.rma01, sr.rma02, sr.rma03,
                                sr.rma04, sr.rma09, sr.rma11,
                                sr.rma18, sr.rma20, sr.rmb111,
                                sr.rmb12, sr.rme02
      ## <-- FUN-860018
   END FOREACH
 
   ## --> FUN-860018 CR(4)
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> **** ##
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      LET g_str = cl_wcchp(tm.wc,"rma01,rma02,rma03,rma20,rma14")
   ELSE
      LET g_str = ''
   END IF
   CALL cl_prt_cs3('armr120','armr120',g_sql,g_str)
   ## <-- FUN-860018 CR(4)
 
   #No.FUN-BB0047--mark--Begin---
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
   #No.FUN-BB0047--mark--End-----
END FUNCTION
#No.FUN-870144
