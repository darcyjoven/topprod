# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: apmr930.4gl
# Desc/riptions..: 请購變更單列印
# Date & Author..: 10/09/03 By Carrier  #No.FUN-A80115
# Modify.........:
# Modify.........: No.FUN-B80088 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No:FUN-BA0078 11/11/03 By xumm 整合單據列印EF簽核
# Modify.........: No:TQC-C10039 12/01/13 By minpp  CR报表列印TIPTOP与EasyFlow签核图片调整
DATABASE ds  #No.FUN-A80115

GLOBALS "../../config/top.global"

DEFINE tm               RECORD                            # Print condition RECORD
                        wc   LIKE type_file.chr1000,      # Where condition
                        a    LIKE type_file.chr1,
                        more LIKE type_file.chr1
                        END RECORD
DEFINE g_i              LIKE type_file.num5               #count/index for any purpose
DEFINE g_sql            STRING
DEFINE l_str            STRING
DEFINE l_table          STRING                                                       

MAIN
   OPTIONS
     INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time


   LET g_pdate         = ARG_VAL(1)                   # Get arguments from command line
   LET g_towhom        = ARG_VAL(2)
   LET g_rlang         = ARG_VAL(3)
   LET g_bgjob         = ARG_VAL(4)
   LET g_prtway        = ARG_VAL(5)
   LET g_copies        = ARG_VAL(6)
   LET tm.wc           = ARG_VAL(7)
   LET tm.a            = ARG_VAL(8)
   LET g_rep_user      = ARG_VAL(09)
   LET g_rep_clas      = ARG_VAL(10)
   LET g_template      = ARG_VAL(11)
   LET g_xml.subject   = ARG_VAL(12)
   LET g_xml.body      = ARG_VAL(13)
   LET g_xml.recipient = ARG_VAL(14)
   LET g_rpt_name      = ARG_VAL(15)

   IF cl_null(g_rlang) THEN
      LET g_rlang = g_lang
   END IF

   LET g_sql = "pne01.pne_file.pne01,     pne02.pne_file.pne02,",
               "pmk09.pmk_file.pmk09,     pmc03.pmc_file.pmc03,",
               "pmk21.pmk_file.pmk21,     pmk43.pmk_file.pmk43,",
               "gec07.gec_file.gec07,     pne03.pne_file.pne03,",
               "pne04.pne_file.pne04,     azf03.azf_file.azf03,",
               "pne05.pne_file.pne05,     gen02.gen_file.gen02,",
               "pne06.pne_file.pne06,     pne09.pne_file.pne09,",
               "pne10.pne_file.pne10,     pne11.pne_file.pne11,",
               "pne12.pne_file.pne12,     pne13.pne_file.pne13,",
               "pne09b.pne_file.pne09b,   pne10b.pne_file.pne10b,",
               "pne11b.pne_file.pne11b,   pne12b.pne_file.pne12b,",
               "pne13b.pne_file.pne13b,   pnf01.pnf_file.pnf01,",
               "pnf02.pnf_file.pnf02,     pnf03.pnf_file.pnf03,",
               "pnf04b.pnf_file.pnf04b,   pnf041b.pnf_file.pnf041b,",
               "ima021b.ima_file.ima021,  pnf20b.pnf_file.pnf20b,",
               "pnf07b.pnf_file.pnf07b,   pnf83b.pnf_file.pnf83b,",
               "pnf84b.pnf_file.pnf84b,   pnf85b.pnf_file.pnf85b,",
               "pnf80b.pnf_file.pnf80b,   pnf81b.pnf_file.pnf81b,",
               "pnf82b.pnf_file.pnf82b,   pnf86b.pnf_file.pnf86b,",
               "pnf87b.pnf_file.pnf87b,   pnf41b.pnf_file.pnf41b,",
               "pnf12b.pnf_file.pnf12b,   pnf121b.pnf_file.pnf121b,",
               "pnf122b.pnf_file.pnf122b, pnf33b.pnf_file.pnf33b,",
               "pmk04.pmk_file.pmk04,  ",
               "pnf04a.pnf_file.pnf04a,",
               "pnf041a.pnf_file.pnf041a, ima021a.ima_file.ima021, ",
               "pnf20a.pnf_file.pnf20a,   pnf07a.pnf_file.pnf07a,",
               "pnf83a.pnf_file.pnf83a,   pnf84a.pnf_file.pnf84a,",
               "pnf85a.pnf_file.pnf85a,   pnf80a.pnf_file.pnf80a,",
               "pnf81a.pnf_file.pnf81a,   pnf82a.pnf_file.pnf82a,",
               "pnf86a.pnf_file.pnf86a,   pnf87a.pnf_file.pnf87a,",
               "pnf41a.pnf_file.pnf41a,   pnf12a.pnf_file.pnf12a,",
               "pnf121a.pnf_file.pnf121a, pnf122a.pnf_file.pnf122a,",
               "pnf33a.pnf_file.pnf33a,   pnf50.pnf_file.pnf50,",
               "strb.type_file.chr1000,   stra.type_file.chr1000,",
               "azi02.azi_file.azi02,     azi02n.azi_file.azi02,",
               "pma02.pma_file.pma02,     pma02n.pma_file.pma02,",
               "oah02.oah_file.oah02,     oah02n.oah_file.oah02,",
               "pme031.pme_file.pme031,   pme032.pme_file.pme032,",
               "pme033.pme_file.pme033,   pme034.pme_file.pme034,",
               "pme035.pme_file.pme035,   pme031a.pme_file.pme031,",
               "pme032a.pme_file.pme032,  pme033a.pme_file.pme033,",
               "pme034a.pme_file.pme034,  pme035a.pme_file.pme035,",
               "pme031b.pme_file.pme031,  pme032b.pme_file.pme032,",
               "pme033b.pme_file.pme033,  pme034b.pme_file.pme034,",
               "pme035b.pme_file.pme035,  pme031c.pme_file.pme031,",
               "pme032c.pme_file.pme032,  pme033c.pme_file.pme033,",
               "pme034c.pme_file.pme034,  pme035c.pme_file.pme035,",  #No.FUN-BA0078 add 2,
               "sign_type.type_file.chr1, sign_img.type_file.blob,",  #簽核方式, 簽核圖檔    #No.FUN-BA0078 add
               "sign_show.type_file.chr1,",                             #是否顯示簽核資料(Y/N) #No.FUN-BA0078 add
               "sign_str.type_file.chr1000"      #簽核字串 #TQC-C10039

   LET l_table = cl_prt_temptable('apmr930',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF

   IF cl_null(g_bgjob) OR g_bgjob = 'N'      # If background job sw is off
      THEN CALL r930_tm(0,0)                 # Input print condition
      ELSE CALL apmr930()                    # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION r930_tm(p_row,p_col)
   DEFINE lc_qbe_sn        LIKE gbm_file.gbm01
   DEFINE p_row,p_col      LIKE type_file.num5
   DEFINE l_cmd            LIKE type_file.chr1000

   LET p_row = 4 LET p_col = 15

   OPEN WINDOW r930_w AT p_row,p_col WITH FORM "apm/42f/apmr930"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
   LET tm.a     = '1'
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON pne01,pne03,pne02

         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pne01)   #请购单号
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pne01"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pne01
                    NEXT FIELD pne01
               OTHERWISE EXIT CASE
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
         LET INT_FLAG = 0 CLOSE WINDOW r930_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM

      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME tm.a,tm.more                # Condition
      INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)

         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
               THEN NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG CALL cl_cmdask()      # Command execution

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
         LET INT_FLAG = 0 CLOSE WINDOW r930_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
          WHERE zz01='apmr930'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('apmr930','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_rlang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.a CLIPPED,"'",
                            " '",g_rep_user CLIPPED,"'",
                            " '",g_rep_clas CLIPPED,"'",
                            " '",g_template CLIPPED,"'",
                            " '",g_rpt_name CLIPPED,"'"
            CALL cl_cmdat('apmr930',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r930_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL apmr930()
      ERROR ""
   END WHILE
   CLOSE WINDOW r930_w
END FUNCTION

FUNCTION apmr930()
   DEFINE l_sql        LIKE type_file.chr1000     # RDSQL STATEMENT
   DEFINE sr           RECORD
                       pne01         LIKE pne_file.pne01,
                       pne02         LIKE pne_file.pne02,
                       pmk09         LIKE pmk_file.pmk09,
                       pmc03         LIKE pmc_file.pmc03,
                       pmk21         LIKE pmk_file.pmk21,
                       pmk43         LIKE pmk_file.pmk43,
                       gec07         LIKE gec_file.gec07,
                       pne03         LIKE pne_file.pne03,
                       pne04         LIKE pne_file.pne04,
                       azf03         LIKE azf_file.azf03,
                       pne05         LIKE pne_file.pne05,
                       gen02         LIKE gen_file.gen02,
                       pne06         LIKE pne_file.pne06,
                       pne09         LIKE pne_file.pne09,
                       pne10         LIKE pne_file.pne10,
                       pne11         LIKE pne_file.pne11,
                       pne12         LIKE pne_file.pne12,
                       pne13         LIKE pne_file.pne13,
                       pne09b        LIKE pne_file.pne09b,
                       pne10b        LIKE pne_file.pne10b,
                       pne11b        LIKE pne_file.pne11b,
                       pne12b        LIKE pne_file.pne12b,
                       pne13b        LIKE pne_file.pne13b,
                       pnf01         LIKE pnf_file.pnf01,
                       pnf02         LIKE pnf_file.pnf02,
                       pnf03         LIKE pnf_file.pnf03,
                       pnf04b        LIKE pnf_file.pnf04b,
                       pnf041b       LIKE pnf_file.pnf041b,
                       ima021b       LIKE ima_file.ima021,
                       pnf20b        LIKE pnf_file.pnf20b,
                       pnf07b        LIKE pnf_file.pnf07b,
                       pnf83b        LIKE pnf_file.pnf83b,
                       pnf84b        LIKE pnf_file.pnf84b,
                       pnf85b        LIKE pnf_file.pnf85b,
                       pnf80b        LIKE pnf_file.pnf80b,
                       pnf81b        LIKE pnf_file.pnf81b,
                       pnf82b        LIKE pnf_file.pnf82b,
                       pnf86b        LIKE pnf_file.pnf86b,
                       pnf87b        LIKE pnf_file.pnf87b,
                       pnf41b        LIKE pnf_file.pnf41b,
                       pnf12b        LIKE pnf_file.pnf12b,
                       pnf121b       LIKE pnf_file.pnf121b,
                       pnf122b       LIKE pnf_file.pnf122b,
                       pnf33b        LIKE pnf_file.pnf33b,
                       pmk04         LIKE pmk_file.pmk04,
                       pnf04a        LIKE pnf_file.pnf04a,
                       pnf041a       LIKE pnf_file.pnf041a,
                       ima021a       LIKE ima_file.ima021,
                       pnf20a        LIKE pnf_file.pnf20a,
                       pnf07a        LIKE pnf_file.pnf07a,
                       pnf83a        LIKE pnf_file.pnf83a,
                       pnf84a        LIKE pnf_file.pnf84a,
                       pnf85a        LIKE pnf_file.pnf85a,
                       pnf80a        LIKE pnf_file.pnf80a,
                       pnf81a        LIKE pnf_file.pnf81a,
                       pnf82a        LIKE pnf_file.pnf82a,
                       pnf86a        LIKE pnf_file.pnf86a,
                       pnf87a        LIKE pnf_file.pnf87a,
                       pnf41a        LIKE pnf_file.pnf41a,
                       pnf12a        LIKE pnf_file.pnf12a,
                       pnf121a       LIKE pnf_file.pnf121a,
                       pnf122a       LIKE pnf_file.pnf122a,
                       pnf33a        LIKE pnf_file.pnf33a,
                       pnf50         LIKE pnf_file.pnf50
                       END RECORD
   DEFINE l_str2       LIKE type_file.chr1000
   DEFINE l_str1       LIKE type_file.chr1000
   DEFINE l_ima906     LIKE ima_file.ima906
   DEFINE l_ima906a    LIKE ima_file.ima906
   DEFINE l_pnf85b     STRING
   DEFINE l_pnf82b     STRING
   DEFINE l_pnf20b     STRING
   DEFINE l_pnf85a     STRING
   DEFINE l_pnf82a     STRING
   DEFINE l_pnf20a     STRING
   DEFINE l_azi02      LIKE azi_file.azi02
   DEFINE l_azi02n     LIKE azi_file.azi02
   DEFINE l_pma02      LIKE pma_file.pma02
   DEFINE l_pma02n     LIKE pma_file.pma02
   DEFINE l_oah02      LIKE oah_file.oah02
   DEFINE l_oah02n     LIKE oah_file.oah02
   DEFINE l_pme031     LIKE pme_file.pme031
   DEFINE l_pme032     LIKE pme_file.pme032
   DEFINE l_pme033     LIKE pme_file.pme033
   DEFINE l_pme034     LIKE pme_file.pme034
   DEFINE l_pme035     LIKE pme_file.pme035
   DEFINE l_pme031a    LIKE pme_file.pme031
   DEFINE l_pme032a    LIKE pme_file.pme032
   DEFINE l_pme033a    LIKE pme_file.pme033
   DEFINE l_pme034a    LIKE pme_file.pme034
   DEFINE l_pme035a    LIKE pme_file.pme035
   DEFINE l_pme031b    LIKE pme_file.pme031
   DEFINE l_pme032b    LIKE pme_file.pme032
   DEFINE l_pme033b    LIKE pme_file.pme033
   DEFINE l_pme034b    LIKE pme_file.pme034
   DEFINE l_pme035b    LIKE pme_file.pme035
   DEFINE l_pme031c    LIKE pme_file.pme031
   DEFINE l_pme032c    LIKE pme_file.pme032
   DEFINE l_pme033c    LIKE pme_file.pme033
   DEFINE l_pme034c    LIKE pme_file.pme034
   DEFINE l_pme035c    LIKE pme_file.pme035
   DEFINE l_zo041      LIKE zo_file.zo041
   DEFINE l_zo05       LIKE zo_file.zo05
   DEFINE l_zo09       LIKE zo_file.zo09
#TQC-C10039--mod--str
   ###No.FUN-BA0078 START###
     DEFINE   l_img_blob     LIKE type_file.blob
#    DEFINE   l_ii           INTEGER
#    DEFINE   l_key          RECORD                  #主鍵
#                v1          LIKE pne_file.pne01,
#                v2          LIKE pne_file.pne02
#                END RECORD
#  ###No.FUN-BA0078 END###
#TQC-C10039--mod--end--
   SELECT zo02,zo041,zo05,zo09 INTO g_company,l_zo041,l_zo05,l_zo09
     FROM zo_file WHERE zo01 = g_rlang

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pneuser', 'pnegrup')

   LET l_sql = "SELECT pne01,   pne02,  '',      '',      '',     0,      '',     ",
               "       pne03,   pne04,  '',      pne05,   '',     pne06,  pne09,  ",
               "       pne10,   pne11,  pne12,   pne13,   pne09b, pne10b, pne11b, ",
               "       pne12b,  pne13b, pnf01,   pnf02,   pnf03,  pnf04b, pnf041b,",
               "       '',      pnf20b, pnf07b,  pnf83b,  pnf84b, pnf85b, pnf80b, ",
               "       pnf81b,  pnf82b, pnf86b,  pnf87b,  pnf41b, pnf12b, pnf121b,",
               "       pnf122b, pnf33b, '',      pnf04a,  pnf041a,'',     pnf20a,",
               "       pnf07a,  pnf83a, ",
               "       pnf84a,  pnf85a, pnf80a,  pnf81a,  pnf82a, pnf86a, pnf87a, ",
               "       pnf41a,  pnf12a, pnf121a, pnf122a, pnf33a, pnf50           ",
               "  FROM pne_file,pnf_file ",
               " WHERE pne01 = pnf01 AND pne02 = pnf02 ",
               "   AND pne06 <> 'X' ",
               "   AND pneacti = 'Y' ",
               "   AND ",tm.wc CLIPPED

   CASE tm.a
     WHEN '1' LET l_sql=l_sql CLIPPED," AND pne06='N' "
     WHEN '2' LET l_sql=l_sql CLIPPED," AND pne06='Y' "
   END CASE
   LET l_sql=l_sql CLIPPED," ORDER BY pne01,pne02,pnf03"

   PREPARE r930_pr1 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE r930_cs1 CURSOR FOR r930_pr1
#TQC-C10039--mark--str
###No.FUN-BA0078 START ###
#    #單據key值
#    LET l_sql = "SELECT pne01,pne02",
#                "  FROM pne_file,pnf_file ",
#                " WHERE pne_file.pne01 = pnf_file.pnf01 AND pne_file.pne02 = pnf_file.pnf02 ",
#                "   AND pne_file.pne06 <> 'X' ",
#                "   AND pneacti = 'Y' ",
#                "   AND ",tm.wc CLIPPED

#  CASE tm.a
#    WHEN '1' LET l_sql=l_sql CLIPPED," AND pne06='N' "
#    WHEN '2' LET l_sql=l_sql CLIPPED," AND pne06='Y' "
#  END CASE
#  LET l_sql=l_sql CLIPPED," ORDER BY pne01,pne02"

#  PREPARE r930_pr2 FROM l_sql
#  IF SQLCA.sqlcode THEN
#     CALL cl_err('prepare:',SQLCA.sqlcode,1)
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time
#     EXIT PROGRAM
#  END IF
#  DECLARE r930_cs2 CURSOR FOR r930_pr2
###No.FUN-BA0078 END ###
#TQC-C10039--mark--end
   CALL cl_del_data(l_table)
   LOCATE l_img_blob IN MEMORY #blob初始化  #No.FUN-BA0078 add

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?) "    #No.FUN-BA0078 add 3? #TQC-C10039 add 1?

   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
      EXIT PROGRAM
   END IF

   FOREACH r930_cs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      SELECT pmk04,pmk09,pmk21,pmk43 INTO sr.pmk04,sr.pmk09,sr.pmk21,sr.pmk43
        FROM pmk_file
       WHERE pmk01 = sr.pne01

      LET l_azi02  = '' LET l_azi02n = ''
      LET l_pma02  = '' LET l_pma02n = ''
      LET l_oah02  = '' LET l_oah02n = ''
      SELECT pmc03  INTO sr.pmc03   FROM pmc_file WHERE pmc01 = sr.pmk09
      SELECT gec07  INTO sr.gec07   FROM gec_file WHERE gec01 = sr.pmk21 AND gec011 = '1'
      SELECT azf03  INTO sr.azf03   FROM azf_file WHERE azf01 = sr.pne04 AND azf02 = '2'
      SELECT gen02  INTO sr.gen02   FROM gen_file WHERE gen01 = sr.pne05
      SELECT ima021 INTO sr.ima021b FROM ima_file WHERE ima01 = sr.pnf04b
      SELECT ima021 INTO sr.ima021a FROM ima_file WHERE ima01 = sr.pnf04a
      SELECT azi02  INTO l_azi02    FROM azi_file WHERE azi01 = sr.pne09
      SELECT azi02  INTO l_azi02n   FROM azi_file WHERE azi01 = sr.pne09b
      SELECT pma02  INTO l_pma02    FROM pma_file WHERE pma01 = sr.pne10
      SELECT pma02  INTO l_pma02n   FROM pma_file WHERE pma01 = sr.pne10b
      SELECT oah02  INTO l_oah02    FROM oah_file WHERE oah01 = sr.pne11
      SELECT oah02  INTO l_oah02n   FROM oah_file WHERE oah01 = sr.pne11b

      LET l_pme031  = '' LET l_pme032  = ''
      LET l_pme033  = '' LET l_pme034  = '' LET l_pme035  = ''
      LET l_pme031a = '' LET l_pme032a = ''
      LET l_pme033a = '' LET l_pme034a = '' LET l_pme035a = ''
      LET l_pme031b = '' LET l_pme032b = ''
      LET l_pme033b = '' LET l_pme034b = '' LET l_pme035b = ''
      LET l_pme031c = '' LET l_pme032c = ''
      LET l_pme033c = '' LET l_pme034c = '' LET l_pme035c = ''

      SELECT pme031,pme032,pme033,pme034,pme035
        INTO l_pme031,l_pme032,l_pme033,l_pme034,l_pme035
        FROM pme_file
       WHERE pme01 = sr.pne12
      SELECT pme031,pme032,pme033,pme034,pme035
        INTO l_pme031a,l_pme032a,l_pme033a,l_pme034a,l_pme035a
        FROM pme_file
       WHERE pme01 = sr.pne12b
      SELECT pme031,pme032,pme033,pme034,pme035
        INTO l_pme031b,l_pme032b,l_pme033b,l_pme034b,l_pme035b
        FROM pme_file
       WHERE pme01 = sr.pne13
      SELECT pme031,pme032,pme033,pme034,pme035
        INTO l_pme031c,l_pme032c,l_pme033c,l_pme034c,l_pme035c
        FROM pme_file
       WHERE pme01 = sr.pne13b

      LET l_ima906 = ''
      SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=sr.pnf04b

      LET l_str2 = ""
      IF g_sma.sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.pnf85b) RETURNING l_pnf85b
                LET l_str2 = l_pnf85b, sr.pnf83b CLIPPED
                IF cl_null(sr.pnf85b) OR sr.pnf85b = 0 THEN
                   CALL cl_remove_zero(sr.pnf82b) RETURNING l_pnf82b
                   LET l_str2 = l_pnf82b, sr.pnf80b CLIPPED
                ELSE
                   IF NOT cl_null(sr.pnf82b) AND sr.pnf82b > 0 THEN
                      CALL cl_remove_zero(sr.pnf82b) RETURNING l_pnf82b
                      LET l_str2 = l_str2 CLIPPED,',',l_pnf82b, sr.pnf80b CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.pnf85b) AND sr.pnf85b > 0 THEN
                    CALL cl_remove_zero(sr.pnf85b) RETURNING l_pnf85b
                    LET l_str2 = l_pnf85b , sr.pnf83b CLIPPED
                END IF
         END CASE
      ELSE
      END IF

      LET l_ima906a = ''
      SELECT ima906 INTO l_ima906a FROM ima_file WHERE ima01=sr.pnf04a

      LET l_str1 = ""
      IF g_sma.sma115 = "Y" THEN
         CASE l_ima906a
            WHEN "2"
                CALL cl_remove_zero(sr.pnf85a) RETURNING l_pnf85a
                LET l_str1 = l_pnf85a, sr.pnf83a CLIPPED
                IF cl_null(sr.pnf85a) OR sr.pnf85a = 0 THEN
                    CALL cl_remove_zero(sr.pnf82a) RETURNING l_pnf82a
                    LET l_str1 = l_pnf82a, sr.pnf80a CLIPPED
                ELSE
                   IF NOT cl_null(sr.pnf82a) AND sr.pnf82a > 0 THEN
                      CALL cl_remove_zero(sr.pnf82a) RETURNING l_pnf82a
                      LET l_str1 = l_str1 CLIPPED,',',l_pnf82a, sr.pnf80a CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.pnf85a) AND sr.pnf85a > 0 THEN
                    CALL cl_remove_zero(sr.pnf85a) RETURNING l_pnf85a
                    LET l_str1 = l_pnf85a , sr.pnf83a CLIPPED
                END IF
         END CASE
      ELSE
      END IF

      IF g_sma.sma116 MATCHES '[13]' THEN
         IF sr.pnf07b <> sr.pnf86b THEN
            CALL cl_remove_zero(sr.pnf20b) RETURNING l_pnf20b
            LET l_str2 = l_str2 CLIPPED,"(",l_pnf20b,sr.pnf07b CLIPPED,")"
         END IF
         IF sr.pnf07a <> sr.pnf86a THEN
            CALL cl_remove_zero(sr.pnf20a) RETURNING l_pnf20a
            LET l_str1 = l_str1 CLIPPED,"(",l_pnf20a,sr.pnf07a CLIPPED,")"
         END IF
      END IF


      EXECUTE insert_prep USING sr.*,l_str2,l_str1,
              l_azi02,   l_azi02n,  l_pma02,   l_pma02n,  l_oah02,
              l_oah02n,  l_pme031,  l_pme032,  l_pme033,  l_pme034,
              l_pme035,  l_pme031a, l_pme032a, l_pme033a, l_pme034a,
              l_pme035a, l_pme031b, l_pme032b, l_pme033b, l_pme034b,
              l_pme035b, l_pme031c, l_pme032c, l_pme033c, l_pme034c,
              #l_pme035c   #No.FUN-BA0078 mark
              l_pme035c,"",l_img_blob,"N",""   #No.FUN-BA0078 add #TQC-C10039 add ""
      IF SQLCA.sqlcode THEN
         CALL cl_err('execute insert_prep',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
   END FOREACH
   LET g_sql ="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED

   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'pne01,pne03,pne02')
      RETURNING tm.wc
   END IF
   LET l_str = tm.wc CLIPPED,";",g_zz05 CLIPPED,";",g_sma.sma116,";",g_sma.sma115
                            ,";",l_zo041,";",l_zo05,";",l_zo09
#TQC-C10039--MARK--STR
###No.FUN-BA0078 START###
     LET g_cr_table = l_table                 #主報表的temp table名稱
#    LET g_cr_gcx01 = "asmi300"               #單別維護程式
     LET g_cr_apr_key_f = "pne01|pne02"       #報表主鍵欄位名稱，用"|"隔開
#    LET l_ii = 1
#    #報表主鍵值
#    CALL g_cr_apr_key.clear()                #清空
#    FOREACH r930_cs2 INTO l_key.*
#       LET g_cr_apr_key[l_ii].v1 = l_key.v1
#       LET g_cr_apr_key[l_ii].v2 = l_key.v2
#       LET l_ii = l_ii + 1
#    END FOREACH
###No.FUN-BA00078 END###
#TQC-C10039--mark--end
   CALL cl_prt_cs3('apmr930','apmr930',g_sql,l_str)

END FUNCTION


