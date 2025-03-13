# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmr651.4gl
# Descriptions...: 預算明細表
# Date & Author..: 00/04/05 By Melody
# Modify.........: No:7976 03/08/29 By Mandy Oracle 日期型態和數值型態不能跟' '比 where apb07 = ' ' ==>apb07是數值型態,所以要改成where apb07 is null
# Modify.........: No.FUN-4C0095 04/12/28 By Mandy 報表轉XML
# Modify.........: No.MOD-530190 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: NO.FUN-590118 06/01/04 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610085 06/04/06 By Claire Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680136 06/09/05 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-730033 07/03/27 By Carrier 會計科目加帳套
# Modify.........: No.FUN-740029 07/04/10 By dxfwo    會計科目加帳套
# Modify.........: No.FUN-810069 08/03/06 By shiwuying 1.相關請采購預算程式主檔(pnr_file/pns_file)改為(afb_file/afc_file)
#                                                      2.更改KEY值為:科目編號+WBS編碼+預算項目+部門+年度+月份+帳套
# Modify.........: No.FUN-840006 08/04/07 By hellen 項目管理，去掉預算編號相關欄位 pml66,pmn66,afa01,apb30
# Modify.........: No.TQC-840049 08/04/20 By shiwuying 畫面欄位順序調整
# Modify.........: No.MOD-840181 08/04/22 By shiwuying 畫面欄位順序調整
# Modify.........: NO.FUN-850139 08/05/29 By zhaijie 老報表修改為CR
# Modify.........: No.MOD-910213 09/01/19 By Smapmin pmn20-->pmn87
# Modify.........: No.FUN-920186 09/03/18 By lala  理由碼
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-A40073 10/05/05 By liuxqa modify sql
# Modify.........: No:MOD-B10109 11/01/18 By Summer 抓取請購/採購/雜項等資料時,都要考慮WBS跟專案編號
# Modify.........: No.FUN-B20054 11/02/24 By xianghui 先錄入帳套,科目根據帳套過濾;結構改為DIALOG

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
		wc  	LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(500)       # Where condition
   		more	LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)         # Input more condition(Y/N)
              END RECORD
 
DEFINE g_cnt           LIKE type_file.num10     #No.FUN-680136 INTEGER
DEFINE g_i             LIKE type_file.num5      #count/index for any purpose   #No.FUN-680136 SMALLINT
DEFINE g_bookno1       LIKE aza_file.aza81      #No.FUN-730033
DEFINE g_bookno2       LIKE aza_file.aza82      #No.FUN-730033
DEFINE g_flag          LIKE type_file.chr1      #No.FUN-730033
DEFINE g_afb00         LIKE afb_file.afb00       #No.FUN-B20054

#NO.FUN-850139--START---
DEFINE g_sql        STRING
DEFINE g_str        STRING
DEFINE l_table      STRING
#NO.FUN-850139--END---
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
#NO.FUN-850139--START---
   LET g_sql = "afb00.afb_file.afb00,",
               "afb01.afb_file.afb01,",
               "afb02.afb_file.afb02,",
               "afb03.afb_file.afb03,",
               "afb04.afb_file.afb04,",
               "afb041.afb_file.afb041,",
               "afb042.afb_file.afb042,",
               "afb10.afb_file.afb10,",
               "code.type_file.chr1,",
               "pml01.pml_file.pml01,",
               "pml02.pml_file.pml02,",
               "pml20.pml_file.pml20,",
               "pml44.pml_file.pml44,",
               "amt1.pml_file.pml44,",
               "pmn01.pmn_file.pmn01,",
               "pmn02.pmn_file.pmn02,",
               "pmn87.pmn_file.pmn87,",   #MOD-910213 pmn20-->pmn87
               "pmn44.pmn_file.pmn44,",
               "amt2.pmn_file.pmn44,",
               "apb01.apb_file.apb01,",
               "apb02.apb_file.apb02,",
               "apb09.apb_file.apb09,",
               "apb08.apb_file.apb08,",
               "amt3.apb_file.apb10,",
               "use1_amt.pml_file.pml44,",
               "use2_amt.pmn_file.pmn44,",
               "use3_amt.apb_file.apb10,",
               "l_azf03.azf_file.azf03,",
               "l_aag02.aag_file.aag02,",
               "l_gem02.gem_file.gem02,",
               "l_pja02.pja_file.pja02"
   LET l_table = cl_prt_temptable('apmr651',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF            
#NO.FUN-850139--end----
#-------------No.TQC-610085 modify
#  LET tm.more = 'N'
#  LET g_pdate = g_today
#  LET g_rlang = g_lang
#  LET g_bgjob = 'N'
#  LET g_copies = '1'
   LET g_pdate = ARG_VAL(1)                  # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)	             # Get arguments from command line
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
#-------------No.TQC-610085 end
   IF tm.wc IS NULL OR tm.wc=' '
      THEN CALL r651_tm(0,0)	
      ELSE CALL apmr651()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r651_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
    DEFINE li_chk_bookno  LIKE type_file.num5             #No.FUN-B20054
 
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW r651_w AT p_row,p_col WITH FORM "apm/42f/apmr651"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL		         	# Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_afb00 = g_aza.aza81   #No.FUn-B20054
WHILE TRUE
#No.FUN-B20054--add-start--
      DIALOG ATTRIBUTE(unbuffered)
         INPUT g_afb00 FROM afb00 ATTRIBUTE(WITHOUT DEFAULTS)
            AFTER FIELD afb00
              IF NOT cl_null(g_afb00) THEN
                   CALL s_check_bookno(g_afb00,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD afb00
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = g_afb00
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",g_afb00,"","agl-043","","",0)
                   NEXT FIELD  afb00
                END IF
             END IF
         END INPUT

#No.FUN-B20054--add-end--
#   CONSTRUCT BY NAME tm.wc ON pnr01,pnr02,pnr03,pnr04 #No.FUN-810069
#    CONSTRUCT BY NAME tm.wc ON afb00,afb01,afb02,afb03,afb04,afb041,afb042   #No.FUN-810069 #No.TQC-840049
#    CONSTRUCT BY NAME tm.wc ON afb00,afb03,afb041,afb01,afb02,afb042,afb04   #No.TQC-840049 #No.MOD-840181
#     CONSTRUCT BY NAME tm.wc ON afb00,afb03,afb01,afb02,afb041,afb042,afb04   #No.MOD-840181   #no.FUN-B20054
      CONSTRUCT BY NAME tm.wc ON afb03,afb01,afb02,afb041,afb042,afb04   #no.FUN-B20054
        #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--start--
# 
#     ON ACTION locale
#         #CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         LET g_action_choice = "locale"
#         EXIT CONSTRUCT
# 
#   ON IDLE g_idle_seconds
#      CALL cl_on_idle()
#      CONTINUE CONSTRUCT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
# 
#           ON ACTION exit
#           LET INT_FLAG = 1
#           EXIT CONSTRUCT
#         #No.FUN-580031 --start--
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
#         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--end-- 
END CONSTRUCT
#No.FUN-B20054--mark--start--
#       IF g_action_choice = "locale" THEN
#          LET g_action_choice = ""
#          CALL cl_dynamic_locale()
#          CONTINUE WHILE
#       END IF
# 
#   IF tm.wc IS NULL OR tm.wc=' ' THEN LET tm.wc=' 1=1 ' END IF
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW r651_w 
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
#      EXIT PROGRAM
#         
#   END IF
#   DISPLAY BY NAME tm.more 
#	
#   INPUT BY NAME tm.more WITHOUT DEFAULTS
#No.FUN-B20054--mark--end--
    INPUT BY NAME tm.more   ATTRIBUTE(WITHOUT DEFAULTS)  #No.FUN-B20054
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more      #輸入其它特殊列印條件
         IF tm.more  NOT MATCHES '[YN]' OR tm.more IS NULL  THEN
            NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
##No.FUN-B20054--mark--start--
#      ON ACTION CONTROLR
#         CALL cl_show_req_fields()
#      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
# 
#          ON ACTION exit
#          LET INT_FLAG = 1
#          EXIT INPUT
#         #No.FUN-580031 --start--
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--end-- 
   END INPUT
#No.FUN-B20054--add-start--
          ON ACTION controlp
            IF INFIELD(afb00) THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aaa'
                  LET g_qryparam.default1 = g_afb00
                  CALL cl_create_qry() RETURNING g_afb00
                  DISPLAY BY NAME g_afb00
            END IF
            IF INFIELD(afb02) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_aag02"
               LET g_qryparam.where = " aag00 = '",g_afb00 CLIPPED,"'"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO afb02
            END IF
       ON ACTION locale
          CALL cl_show_fld_cont()
          LET g_action_choice = "locale"
          EXIT DIALOG

       ON ACTION CONTROLR
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG

       ON ACTION about
          CALL cl_about()

       ON ACTION help
          CALL cl_show_help()

       ON ACTION exit
          LET INT_FLAG = 1
          EXIT DIALOG

       ON ACTION qbe_save
          CALL cl_qbe_save()

       ON ACTION accept
          EXIT DIALOG

       ON ACTION cancel
          LET INT_FLAG=1
          EXIT DIALOG
        END DIALOG
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
                                
#No.FUN-B20054--add-end--
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r651_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   IF tm.wc IS NULL OR tm.wc=' ' THEN LET tm.wc=' 1=1 ' END IF    #No.FUN-B20054
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr651'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr651','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
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
         CALL cl_cmdat('apmr651',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r651_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr651()
   ERROR ""
END WHILE
   CLOSE WINDOW r651_w
END FUNCTION
 
FUNCTION apmr651()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  		# Used time for running the job   #No.FUN-680136 VARCHAR(8)
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT                 #No.FUN-680136 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000,         #No.FUN-680136 VARCHAR(40)
          sr            RECORD
          #No.FUN-810069-------------BEGIN-----------------
          #              pnr01    LIKE pnr_file.pnr01,
          #              pnr02    LIKE pnr_file.pnr02,
          #              pnr03    LIKE pnr_file.pnr03,
          #              pnr04    LIKE pnr_file.pnr04,
          #              pnr10    LIKE pnr_file.pnr10,
                        afb00    LIKE afb_file.afb00,
                        afb01    LIKE afb_file.afb01,
                        afb02    LIKE afb_file.afb02,
                        afb03    LIKE afb_file.afb03,
                        afb04    LIKE afb_file.afb04,
                        afb041   LIKE afb_file.afb041,
                        afb042   LIKE afb_file.afb042,
                        afb10    LIKE afb_file.afb10,
          #No.FUN-810069-------------END--------------------
                        code     LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
                        pml01    LIKE pml_file.pml01,
                        pml02    LIKE pml_file.pml02,
                        pml20    LIKE pml_file.pml20,
                        pml44    LIKE pml_file.pml44,
                         amt1     LIKE pml_file.pml44,#MOD-530190
                        pmn01    LIKE pmn_file.pmn01,
                        pmn02    LIKE pmn_file.pmn02,
                        pmn87    LIKE pmn_file.pmn87,  #MOD-910213 pmn20-->pmn87
                        pmn44    LIKE pmn_file.pmn44,
                         amt2     LIKE pmn_file.pmn44,#MOD-530190
                        apb01    LIKE apb_file.apb01,
                        apb02    LIKE apb_file.apb02,
                        apb09    LIKE apb_file.apb09,
                        apb08    LIKE apb_file.apb08,
                         amt3     LIKE apb_file.apb10,#MOD-530190
                         use1_amt LIKE pml_file.pml44,#MOD-530190
                         use2_amt LIKE pmn_file.pmn44,#MOD-530190
                         use3_amt LIKE apb_file.apb10 #MOD-530190
                        END RECORD
#NO.FUN-850139----start---
DEFINE    l_afa02       LIKE afa_file.afa02
DEFINE    l_aag02       LIKE aag_file.aag02
DEFINE    l_gem02       LIKE gem_file.gem02
DEFINE    l_azf03       LIKE azf_file.azf03
DEFINE    l_pja02       LIKE pja_file.pja02
    CALL cl_del_data(l_table)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'apmr651'
#NO.FUN-850139----end----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.CHI-6A0004-------Begin-------------
#     SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
#           FROM azi_file WHERE azi01=g_aza.aza17
#No.CHI-6A0004-------End--------------
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
#         LET tm.wc = tm.wc clipped," AND pnruser = '",g_user,"'" #No.FUN-810069
     #         LET tm.wc = tm.wc clipped," AND afbuser = '",g_user,"'"  #No.FUN-810069
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
#         LET tm.wc = tm.wc clipped," AND pnrgrup MATCHES '",g_grup CLIPPED,"*'" #No.FUN-810069
     #         LET tm.wc = tm.wc clipped," AND pnrgrup MATCHES '",g_grup CLIPPED,"*'"  #No.FUN-810069
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
#        LET tm.wc = tm.wc clipped," AND pnrgrup IN ",cl_chk_tgrup_list() #No.FUN-810069
     #        LET tm.wc = tm.wc clipped," AND pnrgrup IN ",cl_chk_tgrup_list()  #No.FUN-810069
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('afbuser', 'afbgrup')
     #End:FUN-980030
 
#No.FUN-810069-------------BEGIN-----------------
#     LET l_sql="SELECT pnr01,pnr02,pnr03,pnr04,pnr10,'','','',0,0,0,'','',0,0,0,'','',0,0,0,0,0,0",
#               " FROM pnr_file WHERE 1=1 AND ",tm.wc CLIPPED
     LET l_sql="SELECT afb00,afb01,afb02,afb03,afb04,afb041,afb042,afb10,'','','',0,0,0,'','',0,0,0,'','',0,0,0,0,0,0",
                " FROM afb_file WHERE 1=1 AND ",tm.wc CLIPPED
#No.FUN-810069---------------END-----------------
     PREPARE r651_prepare  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        RETURN
     END IF
     DECLARE r651_cs CURSOR FOR r651_prepare
 
#     CALL cl_outnam('apmr651') RETURNING l_name            #NO.FUN-850139
 
#     START REPORT r651_rep TO l_name                       #NO.FUN-850139
 
     FOREACH r651_cs INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #---------------------- 請購
       LET sr.code='1'
      #MOD-B10109 mark --start-- 
      #DECLARE pml1_cur CURSOR FOR
      #   SELECT pml01,pml02,pml20-pml21,pml44,(pml20-pml21)*pml44
      #     FROM pmk_file,pml_file
      #    WHERE pmk01=pml01 AND pmk18='Y' AND pml16<'6'
#     #      AND pml66=sr.pnr01 AND pml40=sr.pnr02   #No.FUN-810069
#     #      AND pml67=sr.pnr03 AND pmk31=sr.pnr04   #No.FUN-810069
      #      AND pml40=sr.afb02     #No.FUN-810069   #No.FUN-840006 去掉pml66
      #      AND pml67=sr.afb041 AND pmk31=sr.afb03  #No.FUN-810069 
      #MOD-B10109 mark --end--
       #MOD-B10109 add --start-- 
       LET l_sql = "SELECT pml01,pml02,pml20-pml21,pml44,(pml20-pml21)*pml44 ",
                   "  FROM pmk_file,pml_file ",
                   " WHERE pmk01=pml01 AND pmk18='Y' AND pml16<'6' ",
                   "   AND pml40='",sr.afb02,"'",  
                   "   AND pmk31='",sr.afb03,"'"
       #部門
       IF NOT cl_null(sr.afb041) THEN
          LET l_sql = l_sql," AND pml67='",sr.afb041,"'"
       ELSE
          LET l_sql = l_sql," AND (pml67 IS NULL OR pml67='",sr.afb041,"')"
       END IF
       #專案代號
       IF NOT cl_null(sr.afb042) THEN
          LET l_sql = l_sql," AND pml12='",sr.afb042,"'"
       ELSE
          LET l_sql = l_sql," AND (pml12 IS NULL OR pml12='",sr.afb042,"')"
       END IF
       #WBS編碼
       IF NOT cl_null(sr.afb04) THEN
          LET l_sql = l_sql," AND pml121='",sr.afb04,"'"
       ELSE
          LET l_sql = l_sql," AND (pml121 IS NULL OR pml121='",sr.afb04,"')"
       END IF
       PREPARE r651_pml1_pre  FROM l_sql
       DECLARE pml1_cur CURSOR FOR r651_pml1_pre
       #MOD-B10109 add --end--
       FOREACH pml1_cur INTO sr.pml01,sr.pml02,sr.pml20,sr.pml44,sr.amt1
          SELECT COUNT(*) INTO g_cnt FROM pmm_file,pmn_file
             WHERE pmm01=pmn01 AND pmn24=sr.pml01 AND pmn25=sr.pml02
          IF g_cnt>0 THEN
             DECLARE pmn1_cur CURSOR FOR
               SELECT pmn01,pmn02,pmn87,pmn44,pmn87*pmn44   #MOD-910213 pmn20-->pmn87
                  FROM pmm_file,pmn_file
                 WHERE pmm01=pmn01 AND pmn24=sr.pml01 AND pmn25=sr.pml02
                   AND pmm25<'6'
             FOREACH pmn1_cur INTO sr.pmn01,sr.pmn02,sr.pmn87,sr.pmn44,sr.amt2   #MOD-910213 pmn20-->pmn87
                 SELECT COUNT(*) INTO g_cnt FROM apa_file,apb_file
                    WHERE apa01=apb01 AND apb06=sr.pmn01 AND apb07=sr.pmn02
                      AND apa42 = 'N'
                 IF g_cnt>0 THEN
                    DECLARE apb1_cur CURSOR FOR
                     SELECT apb01,apb02,SUM(apb09),SUM(apb08),SUM(apb10) FROM apa_file,apb_file
                        WHERE apa01=apb01 AND apb06=sr.pmn01 AND apb07=sr.pmn02
                          AND apa00[1,1]='1' AND apa42 = 'N'
                      GROUP BY apb01,apb02
                    FOREACH apb1_cur INTO sr.apb01,sr.apb02,sr.apb09,sr.apb08,sr.amt3
                         LET sr.pmn87=sr.pmn87-sr.apb09   #MOD-910213 pmn20-->pmn87
                         LET sr.amt2=sr.amt2-sr.amt3
                         LET sr.use1_amt=sr.amt1
                         LET sr.use2_amt=sr.amt2
                         LET sr.use3_amt=sr.amt3
                         IF sr.use1_amt IS NULL THEN LET sr.use1_amt=0 END IF
                         IF sr.use2_amt IS NULL THEN LET sr.use2_amt=0 END IF
                         IF sr.use3_amt IS NULL THEN LET sr.use3_amt=0 END IF
                         IF sr.pml20=0 THEN
                            LET sr.pml20=''
                            LET sr.pml44=''
                            LET sr.amt1 =''
                         END IF
                         IF sr.pmn87=0 THEN   #MOD-910213 pmn20-->pmn87
                            LET sr.pmn87=''   #MOD-910213 pmn20-->pmn87
                            LET sr.pmn44=''
                            LET sr.amt2 =''
                         END IF
                         IF sr.apb09=0 THEN
                            LET sr.apb09=''
                            LET sr.apb08=''
                            LET sr.amt3 =''
                         END IF
#NO.FUN-850139---START---------
##                         OUTPUT TO REPORT r651_rep(sr.pnr01,sr.pnr02,sr.pnr03,  #No.FUN-810069
##                                                   sr.pnr04,sr.pnr10,sr.code,   #No.FUN-810069
#                         OUTPUT TO REPORT r651_rep(sr.afb00,sr.afb01,sr.afb02,sr.afb03,              #No.FUN-810069
#                                                   sr.afb04,sr.afb041,sr.afb042,sr.afb10,sr.code,    #No.FUN-810069
#                                                   sr.pml01,sr.pml02,
#                                                   sr.pml20,sr.pml44,sr.amt1,
#                                                   sr.pmn01,sr.pmn02,
#                                                   sr.pmn87,sr.pmn44,sr.amt2,   #MOD-910213 pmn20-->pmn87
#                                                   sr.apb01,sr.apb02,
#                                                   sr.apb09,sr.apb08,sr.amt3,
#                                                   sr.use1_amt,sr.use2_amt,
#                                                   sr.use3_amt)
      #SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf02 = '2'          #FUN-920186
      SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf02 = '2' AND azf01 = sr.afb01    #FUN-920186
      CALL s_get_bookno(sr.afb03) RETURNING g_flag,g_bookno1,g_bookno2          
      IF g_flag =  '1' THEN  #抓不到帳別                                        
         CALL cl_err(sr.afb03,'aoo-081',1)                                      
      END IF
     SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=sr.afb02              
                                                AND aag00=g_bookno1
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.afb041              
      SELECT pja02 INTO l_pja02 FROM pja_file WHERE pja01=sr.afb042
      EXECUTE insert_prep USING
        sr.afb00,sr.afb01,sr.afb02,sr.afb03,sr.afb04,sr.afb041,sr.afb042,
        sr.afb10,sr.code,sr.pml01,sr.pml02,sr.pml20,sr.pml44,sr.amt1,sr.pmn01,
        sr.pmn02,sr.pmn87,sr.pmn44,sr.amt2,sr.apb01,sr.apb02,sr.apb09,sr.apb08,   #MOD-910213 pmn20-->pmn87
        sr.amt3,sr.use1_amt,sr.use2_amt,sr.use3_amt,l_azf03,l_aag02,l_gem02,l_pja02
#NO.FUN-850139---END-------- 
                    END FOREACH
                 ELSE
                    LET sr.use1_amt=sr.amt1
                    LET sr.use2_amt=sr.amt2
                    LET sr.use3_amt=0
                    IF sr.use1_amt IS NULL THEN LET sr.use1_amt=0 END IF
                    IF sr.use2_amt IS NULL THEN LET sr.use2_amt=0 END IF
                    IF sr.pml20=0 THEN
                       LET sr.pml20=''
                       LET sr.pml44=''
                       LET sr.amt1 =''
                    END IF
                    IF sr.pmn87=0 THEN   #MOD-910213 pmn20-->pmn87
                       LET sr.pmn87=''   #MOD-910213 pmn20-->pmn87
                       LET sr.pmn44=''
                       LET sr.amt2 =''
                    END IF
#NO.FUN-850139---START--------
##                    OUTPUT TO REPORT r651_rep(sr.pnr01,sr.pnr02,sr.pnr03, #No.FUN-810069
##                                              sr.pnr04,sr.pnr10,sr.code,  #No.FUN-810069
#                    OUTPUT TO REPORT r651_rep(sr.afb00,sr.afb01,sr.afb02,sr.afb03,           #No.FUN-810069
#                                              sr.afb04,sr.afb041,sr.afb042,sr.afb10,sr.code, #No.FUN-810069
#                                              sr.pml01,sr.pml02,
#                                              sr.pml20,sr.pml44,sr.amt1,
#                                              sr.pmn01,sr.pmn02,
#                                              sr.pmn87,sr.pmn44,sr.amt2,   #MOD-910213 pmn20-->pmn87
#                                              '','','','','',
#                                              sr.use1_amt,sr.use2_amt,
#                                              sr.use3_amt)
     #SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf02 = '2'                #MOD-B10109 mark
      SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf02 = '2' AND azf01=sr.afb01 #MOD-B10109
      CALL s_get_bookno(sr.afb03) RETURNING g_flag,g_bookno1,g_bookno2          
      IF g_flag =  '1' THEN  #抓不到帳別                                        
         CALL cl_err(sr.afb03,'aoo-081',1)                                      
      END IF
     SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=sr.afb02              
                                                AND aag00=g_bookno1
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.afb041              
      SELECT pja02 INTO l_pja02 FROM pja_file WHERE pja01=sr.afb042
      EXECUTE insert_prep USING
        sr.afb00,sr.afb01,sr.afb02,sr.afb03,sr.afb04,sr.afb041,sr.afb042,
        sr.afb10,sr.code,sr.pml01,sr.pml02,sr.pml20,sr.pml44,sr.amt1,
        sr.pmn01,sr.pmn02,sr.pmn87,sr.pmn44,sr.amt2,'','','','','',   #MOD-910213 pmn20-->pmn87
        sr.use1_amt,sr.use2_amt,sr.use3_amt,l_azf03,l_aag02,l_gem02,l_pja02
#NO.FUN-850139-------END---
                 END IF
             END FOREACH
          ELSE
             LET sr.use1_amt=sr.amt1
             LET sr.use2_amt=0
             LET sr.use3_amt=0
             IF sr.use1_amt IS NULL THEN LET sr.use1_amt=0 END IF
             IF sr.pml20=0 THEN
                LET sr.pml20=''
                LET sr.pml44=''
                LET sr.amt1 =''
             END IF
#NO.FUN-850139-----START-----
##             OUTPUT TO REPORT r651_rep(sr.pnr01,sr.pnr02,sr.pnr03,  #No.FUN-810069
##                                       sr.pnr04,sr.pnr10,sr.code,   #No.FUN-810069
#              OUTPUT TO REPORT r651_rep(sr.afb00,sr.afb01,sr.afb02,sr.afb03,          #No.FUN-810069
#                                        sr.afb04,sr.afb041,sr.afb042,sr.afb10,sr.code,#No.FUN-810069
#                                       sr.pml01,sr.pml02,
#                                       sr.pml20,sr.pml44,sr.amt1,
#                                       '','','','','',
#                                       '','','','','',
#                                       sr.use1_amt,sr.use2_amt,
#                                       sr.use3_amt)
     #SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf02 = '2'                #MOD-B10109 mark
      SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf02 = '2' AND azf01=sr.afb01 #MOD-B10109
      CALL s_get_bookno(sr.afb03) RETURNING g_flag,g_bookno1,g_bookno2          
      IF g_flag =  '1' THEN  #抓不到帳別                                        
         CALL cl_err(sr.afb03,'aoo-081',1)                                      
      END IF
     SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=sr.afb02              
                                                AND aag00=g_bookno1
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.afb041              
      SELECT pja02 INTO l_pja02 FROM pja_file WHERE pja01=sr.afb042
      EXECUTE insert_prep USING
        sr.afb00,sr.afb01,sr.afb02,sr.afb03,sr.afb04,sr.afb041,sr.afb042,
        sr.afb10,sr.code,sr.pml01,sr.pml02,sr.pml20,sr.pml44,sr.amt1,
        '','','','','','','','','','',sr.use1_amt,sr.use2_amt,
        sr.use3_amt,l_azf03,l_aag02,l_gem02,l_pja02
#NO.FUN-850139------END---
          END IF
       END FOREACH
       #---------------------- 採購
       LET sr.code='2'
      #MOD-B10109 mark --start-- 
      #DECLARE pmn2_cur CURSOR FOR
      #   SELECT pmn01,pmn02,pmn87,pmn44,pmn87*pmn44 FROM pmm_file,pmn_file   #MOD-910213 pmn20-->pmn87
      #    WHERE pmm01=pmn01 AND pmm18='Y' AND pmm25<'6'
#     #      AND pmn66=sr.pnr01 AND pmn40=sr.pnr02  #No.FUN-810069
#     #      AND pmn67=sr.pnr03 AND pmm31=sr.pnr04  #No.FUN-810069
      #      AND pmn40=sr.afb02  #No.FUN-810069     #No.FUN-840006 去掉pmn66 =sr.afb01
      #      AND pmn67=sr.afb041 AND pmm31=sr.afb03 #No.FUN-810069
      #      AND (pmn24=' ' OR pmn24 IS NULL) AND (pmn25 = ' ' OR pmn25 IS NULL)   #FUN-A40073 mod
      #      #AND (pmn24=' ' OR pmn24 IS NULL) AND (pmn25 IS NULL)                 #FUN-A40073 mark
      #MOD-B10109 mark --end-- 
       #MOD-B10109 add --start-- 
       LET l_sql = "SELECT pmn01,pmn02,pmn87,pmn44,pmn87*pmn44 ",
                   "  FROM pmm_file,pmn_file ",
                   " WHERE pmm01=pmn01 AND pmm18='Y' AND pmm25<'6'",
                   "   AND pmn40='",sr.afb02,"'",
                   "   AND pmm31='",sr.afb03,"'",
                   "   AND (pmn24=' ' OR pmn24 IS NULL) AND (pmn25=' ' OR pmn25 IS NULL)"
       #部門
       IF NOT cl_null(sr.afb041) THEN
          LET l_sql = l_sql," AND pmn67='",sr.afb041,"'"
       ELSE
          LET l_sql = l_sql," AND (pmn67 IS NULL OR pmn67='",sr.afb041,"')"
       END IF
       #專案代號
       IF NOT cl_null(sr.afb042) THEN
          LET l_sql = l_sql," AND pmn122='",sr.afb042,"'"
       ELSE
          LET l_sql = l_sql," AND (pmn122 IS NULL OR pmn122='",sr.afb042,"')"
       END IF
       #WBS編碼
       IF NOT cl_null(sr.afb04) THEN
          LET l_sql = l_sql," AND pmn96='",sr.afb04,"'"
       ELSE
          LET l_sql = l_sql," AND (pmn96 IS NULL OR pmn96='",sr.afb04,"')"
       END IF
       PREPARE r651_pmn2_pre  FROM l_sql
       DECLARE pmn2_cur CURSOR FOR r651_pmn2_pre
       #MOD-B10109 add --end--
       FOREACH pmn2_cur INTO sr.pmn01,sr.pmn02,sr.pmn87,sr.pmn44,sr.amt2   #MOD-910213 pmn20-->pmn87
          SELECT COUNT(*) INTO g_cnt FROM apa_file,apb_file
           WHERE apa01=apb01 AND apb06=sr.pmn01 AND apb07=sr.pmn02
             AND apa42 = 'N'
          IF g_cnt>0 THEN
             DECLARE apb2_cur CURSOR FOR
               SELECT apb01,apb02,SUM(apb09),SUM(apb08),SUM(apb10) FROM apa_file,apb_file
                WHERE apa01=apb01 AND apb06=sr.pmn01 AND apb07=sr.pmn02
                  AND apa00[1,1]='1' AND apa42 = 'N'
                GROUP BY apb01,apb02
             FOREACH apb2_cur INTO sr.apb01,sr.apb02,sr.apb09,sr.apb08,sr.amt3
                LET sr.pmn87=sr.pmn87-sr.apb09   #MOD-910213 pmn20-->pmn87
                LET sr.amt2=sr.amt2-sr.amt3
                LET sr.use1_amt=0
                LET sr.use2_amt=sr.amt2
                LET sr.use3_amt=sr.amt3
                IF sr.use2_amt IS NULL THEN LET sr.use2_amt=0 END IF
                IF sr.use3_amt IS NULL THEN LET sr.use3_amt=0 END IF
                IF sr.pmn87=0 THEN   #MOD-910213 pmn20-->pmn87
                   LET sr.pmn87=0   #MOD-910213 pmn20-->pmn87
                   LET sr.pmn44=''
                   LET sr.amt2 =''
                END IF
                IF sr.apb09=0 THEN
                   LET sr.apb09=''
                   LET sr.apb08=''
                   LET sr.amt3 =''
                END IF
#NO.FUN-850139-----START---
##                OUTPUT TO REPORT r651_rep(sr.pnr01,sr.pnr02,sr.pnr03, #No.FUN-810069
##                                          sr.pnr04,sr.pnr10,sr.code,  #No.FUN-810069
#                OUTPUT TO REPORT r651_rep(sr.afb00,sr.afb01,sr.afb02,sr.afb03,          #No.FUN-810069
#                                          sr.afb04,sr.afb041,sr.afb042,sr.afb10,sr.code,#No.FUN-810069
#                                          '','','','','',
#                                          sr.pmn01,sr.pmn02,
#                                          sr.pmn87,sr.pmn44,sr.amt2,   #MOD-910213 pmn20-->pmn87
#                                          sr.apb01,sr.apb02,
#                                          sr.apb09,sr.apb08,sr.amt3,
#                                          sr.use1_amt,sr.use2_amt,
#                                          sr.use3_amt)
     #SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf02 = '2'                #MOD-B10109 mark
      SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf02 = '2' AND azf01=sr.afb01 #MOD-B10109
      CALL s_get_bookno(sr.afb03) RETURNING g_flag,g_bookno1,g_bookno2          
      IF g_flag =  '1' THEN  #抓不到帳別                                        
         CALL cl_err(sr.afb03,'aoo-081',1)                                      
      END IF
     SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=sr.afb02              
                                                AND aag00=g_bookno1
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.afb041              
      SELECT pja02 INTO l_pja02 FROM pja_file WHERE pja01=sr.afb042
      EXECUTE insert_prep USING
        sr.afb00,sr.afb01,sr.afb02,sr.afb03,sr.afb04,sr.afb041,sr.afb042,
        sr.afb10,sr.code,'','','','','',sr.pmn01,sr.pmn02,sr.pmn87,sr.pmn44,   #MOD-910213 pmn20-->pmn87
        sr.amt2,sr.apb01,sr.apb02,sr.apb09,sr.apb08,sr.amt3,sr.use1_amt,
        sr.use2_amt,sr.use3_amt,l_azf03,l_aag02,l_gem02,l_pja02
#NO.FUN-850139---END----
             END FOREACH
          ELSE
             LET sr.use1_amt=0
             LET sr.use2_amt=sr.amt2
             LET sr.use3_amt=0
             IF sr.use2_amt IS NULL THEN LET sr.use2_amt=0 END IF
             IF sr.pmn87=0 THEN   #MOD-910213 pmn20-->pmn87
                LET sr.pmn87=''   #MOD-910213 pmn20-->pmn87
                LET sr.pmn44=''
                LET sr.amt2 =''
             END IF
#NO.FUN-850139-------START----
##             OUTPUT TO REPORT r651_rep(sr.pnr01,sr.pnr02,sr.pnr03, #No.FUN-810069
##                                       sr.pnr04,sr.pnr10,sr.code,  #No.FUN-810069
#             OUTPUT TO REPORT r651_rep(sr.afb00,sr.afb01,sr.afb02,sr.afb03,          #No.FUN-810069
#                                       sr.afb04,sr.afb041,sr.afb042,sr.afb10,sr.code,#No.FUN-810069
#                                       '','','','','',
#                                       sr.pmn01,sr.pmn02,
#                                       sr.pmn87,sr.pmn44,sr.amt2,   #MOD-910213 pmn20-->pmn87
#                                       '','','','','',
#                                       sr.use1_amt,sr.use2_amt,
#                                       sr.use3_amt)
     #SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf02 = '2'                #MOD-B10109 mark
      SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf02 = '2' AND azf01=sr.afb01 #MOD-B10109
      CALL s_get_bookno(sr.afb03) RETURNING g_flag,g_bookno1,g_bookno2          
      IF g_flag =  '1' THEN  #抓不到帳別                                        
         CALL cl_err(sr.afb03,'aoo-081',1)                                      
      END IF
     SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=sr.afb02              
                                                AND aag00=g_bookno1
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.afb041              
      SELECT pja02 INTO l_pja02 FROM pja_file WHERE pja01=sr.afb042
      EXECUTE insert_prep USING
        sr.afb00,sr.afb01,sr.afb02,sr.afb03,sr.afb04,sr.afb041,sr.afb042,
        sr.afb10,sr.code,'','','','','',sr.pmn01,sr.pmn02,sr.pmn87,sr.pmn44,   #MOD-910213 pmn20-->pmn87
        sr.amt2,'','','','','',sr.use1_amt,sr.use2_amt,sr.use3_amt,l_azf03,
        l_aag02,l_gem02,l_pja02
#NO.FUN-850139---END-----
          END IF
       END FOREACH
       #---------------------- 雜項
       LET sr.code='3'
      #MOD-B10109 mark --start-- 
      #DECLARE apb3_cur CURSOR FOR
      #  SELECT apb01,apb02,apb09,apb08,apb10 FROM apa_file,apb_file
      #   WHERE apa01=apb01 AND apa41='Y' AND apa00[1,1]='1'
#     #     AND apb30=sr.pnr01 AND apb25=sr.pnr02         #No.FUN-810069
#     #     AND apb26=sr.pnr03 AND YEAR(apa02)=sr.pnr04   #No.FUN-810069
#     #     AND apb30=sr.afb01 AND apb25=sr.afb02         #No.FUN-810069
      #     AND apb25=sr.afb02      #No.FUN-810069        #No.FUN-840006 去掉apb30 
      #     AND apb26=sr.afb041 AND YEAR(apa02)=sr.afb03  #No.FUN-810069
      #     AND (apb06=' ' OR apb06 IS NULL) AND apb07 IS NULL #No:7976
      #MOD-B10109 mark --end-- 
       #MOD-B10109 add --start-- 
       LET l_sql = "SELECT apb01,apb02,apb09,apb08,apb10 ",
                   "  FROM apa_file,apb_file ",
                   " WHERE apa01=apb01 AND apa41='Y' AND apa00 like '1%'",
                   "   AND apb25='",sr.afb02,"'",      
                   "   AND YEAR(apa02)='",sr.afb03,"'", 
                   "   AND (apb06=' ' OR apb06 IS NULL) AND apb07 IS NULL" 
       #部門
       IF NOT cl_null(sr.afb041) THEN
          LET l_sql = l_sql," AND apb26='",sr.afb041,"'"
       ELSE
          LET l_sql = l_sql," AND (apb26 IS NULL OR apb26='",sr.afb041,"')"
       END IF
       #專案代號
       IF NOT cl_null(sr.afb042) THEN
          LET l_sql = l_sql," AND apb35='",sr.afb042,"'"
       ELSE
          LET l_sql = l_sql," AND (apb35 IS NULL OR apb35='",sr.afb042,"')"
       END IF
       #WBS編碼
       IF NOT cl_null(sr.afb04) THEN
          LET l_sql = l_sql," AND apb36='",sr.afb04,"'"
       ELSE
          LET l_sql = l_sql," AND (apb36 IS NULL OR apb36='",sr.afb04,"')"
       END IF
       PREPARE r651_apb3_pre  FROM l_sql
       DECLARE apb3_cur CURSOR FOR r651_apb3_pre
       #MOD-B10109 add --end--
       FOREACH apb3_cur INTO sr.apb01,sr.apb02,sr.apb09,sr.apb08,sr.amt3
            LET sr.use1_amt=0
            LET sr.use2_amt=0
            LET sr.use3_amt=sr.amt3
            IF sr.use3_amt IS NULL THEN LET sr.use3_amt=0 END IF
            IF sr.apb09=0 THEN
               LET sr.apb09=''
               LET sr.apb08=''
               LET sr.amt3 =''
            END IF
#NO.FUN-850139---START---
##            OUTPUT TO REPORT r651_rep(sr.pnr01,sr.pnr02,sr.pnr03, #No.FUN-810069
##                                      sr.pnr04,sr.pnr10,sr.code,  #No.FUN-810069
#            OUTPUT TO REPORT r651_rep(sr.afb00,sr.afb01,sr.afb02,sr.afb03,           #No.FUN-810069
#                                      sr.afb04,sr.afb041,sr.afb042,sr.afb10,sr.code, #No.FUN-810069
#                                      '','','','','',
#                                      '','','','','',
#                                      sr.apb01,sr.apb02,
#                                      sr.apb09,sr.apb08,sr.amt3,
#                                      sr.use1_amt,sr.use2_amt,
#                                      sr.use3_amt)
     #SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf02 = '2'                #MOD-B10109 mark
      SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf02 = '2' AND azf01=sr.afb01 #MOD-B10109
      CALL s_get_bookno(sr.afb03) RETURNING g_flag,g_bookno1,g_bookno2          
      IF g_flag =  '1' THEN  #抓不到帳別                                        
         CALL cl_err(sr.afb03,'aoo-081',1)                                      
      END IF
     SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=sr.afb02              
                                                AND aag00=g_bookno1
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.afb041              
      SELECT pja02 INTO l_pja02 FROM pja_file WHERE pja01=sr.afb042
      EXECUTE insert_prep USING
        sr.afb00,sr.afb01,sr.afb02,sr.afb03,sr.afb04,sr.afb041,sr.afb042,
        sr.afb10,sr.code,'','','','','','','','','','',sr.apb01,sr.apb02,
        sr.apb09,sr.apb08,sr.amt3,sr.use1_amt,sr.use2_amt,sr.use3_amt,
        l_azf03,l_aag02,l_gem02,l_pja02
#NO.FUN-850139---END-----
       END FOREACH
     END FOREACH
 
#     FINISH REPORT r651_rep                                #NO.FUN-850139
#NO.FUN-850139----start----
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'afb00,afb03,afb01,afb02,afb041,afb042,afb04')
           RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",g_azi04,";",g_azi03,";",g_azi05
     CALL cl_prt_cs3('apmr651','apmr651',g_sql,g_str) 
#NO.FUN-850139--end---
     ERROR ' '
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)           #NO.FUN-850139
END FUNCTION
#NO.FUN-850139--start--
#REPORT r651_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
#          l_sql         LIKE type_file.chr1000,      #No.FUN-680136 VARCHAR(1000)
#          l_afa02       LIKE afa_file.afa02,
#          l_aag02       LIKE aag_file.aag02,
#          l_gem02       LIKE gem_file.gem02,
#          l_azf03       LIKE azf_file.azf03,
#          l_pja02       LIKE pja_file.pja02,
#          amt,amt1,amt2,amt3,amt4,amt5,amt6   LIKE pml_file.pml44,  #No.FUN-680136 DEC(15,3)
#          sr            RECORD
#          #No.FUN-810069-------------BEGIN-----------------                     
#          #              pnr01    LIKE pnr_file.pnr01,                          
#          #              pnr02    LIKE pnr_file.pnr02,                          
#          #              pnr03    LIKE pnr_file.pnr03,                          
#          #              pnr04    LIKE pnr_file.pnr04,                          
#          #              pnr10    LIKE pnr_file.pnr10,                          
#                        afb00    LIKE afb_file.afb00,                           
#                        afb01    LIKE afb_file.afb01,                           
#                        afb02    LIKE afb_file.afb02,                           
#                        afb03    LIKE afb_file.afb03,                           
#                        afb04    LIKE afb_file.afb04,                           
#                        afb041   LIKE afb_file.afb041,                          
#                        afb042   LIKE afb_file.afb042,                          
#                        afb10    LIKE afb_file.afb10,                           
#          #No.FUN-810069-------------END-------------------- 
#                        code     LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
#                        pml01    LIKE pml_file.pml01,
#                        pml02    LIKE pml_file.pml02,
#                        pml20    LIKE pml_file.pml20,
#                        pml44    LIKE pml_file.pml44,
#                         amt1     LIKE pml_file.pml44,#MOD-530190
#                        pmn01    LIKE pmn_file.pmn01,
#                        pmn02    LIKE pmn_file.pmn02,
#                        pmn87    LIKE pmn_file.pmn87,   #MOD-910213 pmn20-->pmn87
#                        pmn44    LIKE pmn_file.pmn44,
#                         amt2     LIKE pmn_file.pmn44,#MOD-530190
#                        apb01    LIKE apb_file.apb01,
#                        apb02    LIKE apb_file.apb02,
#                        apb09    LIKE apb_file.apb09,
#                        apb08    LIKE apb_file.apb08,
#                         amt3     LIKE apb_file.apb10,#MOD-530190
#                         use1_amt LIKE pml_file.pml44,#MOD-530190
#                         use2_amt LIKE pmn_file.pmn44,#MOD-530190
#                         use3_amt LIKE apb_file.apb10 #MOD-530190
#                        END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
##  ORDER BY sr.pnr01,sr.pnr02,sr.pnr03,sr.pnr04,sr.code,sr.pml01,sr.pml02, #No.FUN-810069
#   ORDER BY sr.afb00,sr.afb01,sr.afb02,sr.afb03,sr.afb04,sr.afb041,sr.afb042,sr.code,sr.pml01,sr.pml02, #No.FUN-810069
#           sr.pmn01,sr.pmn02,sr.apb01,sr.apb02
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT
#      PRINT g_dash
##No.FUN-810069-------------BEGIN-----------------
##     SELECT afa02 INTO l_afa02 FROM afa_file WHERE afa01=sr.pnr01
##                                                AND afa00=g_aza.aza81 #No.FUN-740029
#      #No.FUN-840006 080407 modify --begin
##     SELECT azf03 INTO l_azf03 FROM azf_file WHERE afa01=sr.afb01 
#      SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf02 = '2'
#      #No.FUN-840006 080407 modify --end
##     #No.FUN-730033  --Begin
##     CALL s_get_bookno(sr.pnr04) RETURNING g_flag,g_bookno1,g_bookno2
##     IF g_flag =  '1' THEN  #抓不到帳別
##        CALL cl_err(sr.pnr04,'aoo-081',1)
##     END IF
##     #No.FUN-730033  --End  
#      CALL s_get_bookno(sr.afb03) RETURNING g_flag,g_bookno1,g_bookno2          
#      IF g_flag =  '1' THEN  #抓不到帳別                                        
#         CALL cl_err(sr.afb03,'aoo-081',1)                                      
#      END IF
#
##      SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=sr.pnr02
##                                                AND aag00=g_bookno1  #No.FUN-730033
##      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.pnr03
##      PRINT COLUMN 01,g_x[11] CLIPPED,sr.pnr01 CLIPPED,COLUMN 40,l_afa02
##      PRINT COLUMN 01,g_x[12] CLIPPED,sr.pnr02 CLIPPED,COLUMN 40,l_aag02
##      PRINT COLUMN 01,g_x[13] CLIPPED,sr.pnr03 CLIPPED,COLUMN 40,l_gem02
##      PRINT COLUMN 01,g_x[14] CLIPPED,sr.pnr04
##      PRINT COLUMN 01,g_x[15] CLIPPED,cl_numfor(sr.pnr10,15,g_azi04)
#      SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=sr.afb02              
#                                                AND aag00=g_bookno1  #No.FUN-730
#      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.afb041              
#      SELECT pja02 INTO l_pja02 FROM pja_file WHERE pja01=sr.afb042
#      PRINT COLUMN 01,g_x[16] CLIPPED,sr.afb00   #帳別
#      PRINT COLUMN 01,g_x[11] CLIPPED,sr.afb01 CLIPPED,COLUMN 40,l_azf03  #預算項目        
#      PRINT COLUMN 01,g_x[12] CLIPPED,sr.afb02 CLIPPED,COLUMN 40,l_aag02  #科目編號
#      PRINT COLUMN 01,g_x[13] CLIPPED,sr.afb041 CLIPPED,COLUMN 40,l_gem02 #部門編號       
#      PRINT COLUMN 01,g_x[17] CLIPPED,sr.afb042 CLIPPED,COLUMN 40,l_pja02 #項目編號
#      PRINT COLUMN 01,g_x[18] CLIPPED,sr.afb04   #WBS編碼
#      PRINT COLUMN 01,g_x[14] CLIPPED,sr.afb03   #會計年度                               
#      PRINT COLUMN 01,g_x[15] CLIPPED,cl_numfor(sr.afb10,15,g_azi04)
##No.FUN-810069---------------END-----------------
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#            g_x[41],g_x[42],g_x[43],g_x[44],g_x[45]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
##   BEFORE GROUP OF sr.pnr04  #No.FUN-810069
#    BEFORE GROUP OF sr.afb03  #No.FUN-810069
#      SKIP TO TOP OF PAGE
#
#   BEFORE GROUP OF sr.pml01
#      PRINT COLUMN g_c[31],sr.pml01,
#            COLUMN g_c[32],sr.pml02 USING '###&', #FUN-590118
#            COLUMN g_c[33],cl_numfor(sr.pml20,33,2),
#            COLUMN g_c[34],cl_numfor(sr.pml44,34,g_azi03),
#            COLUMN g_c[35],cl_numfor(sr.amt1,35,g_azi04);
#   BEFORE GROUP OF sr.pmn01
#      PRINT COLUMN g_c[36],sr.pmn01,
#            COLUMN g_c[37],sr.pmn02 USING '###&', #FUN-590118
#            COLUMN g_c[38],cl_numfor(sr.pmn87,38,2),   #MOD-910213 pmn20-->pmn87
#            COLUMN g_c[39],cl_numfor(sr.pmn44,39,g_azi03),
#            COLUMN g_c[40],cl_numfor(sr.amt2,40,g_azi04);
#   ON EVERY ROW
#   PRINT    COLUMN g_c[41],sr.apb01,
#            COLUMN g_c[42],sr.apb02 USING '###&', #FUN-590118
#            COLUMN g_c[43],cl_numfor(sr.apb09,43,2),
#            COLUMN g_c[44],cl_numfor(sr.apb08,44,g_azi03),
#            COLUMN g_c[45],cl_numfor(sr.amt3,45,g_azi04)
#
#   AFTER GROUP OF sr.code
#      PRINT g_dash1
#
##   AFTER GROUP OF sr.pnr04  #No.FUN-810069
#   AFTER GROUP OF sr.afb03   #No.FUN-810069
#      PRINT COLUMN g_c[31],g_x[24] CLIPPED,COLUMN g_c[35],cl_numfor(GROUP SUM(sr.use1_amt+sr.use2_amt+sr.use3_amt),35,g_azi05)
#
#   ON LAST ROW
#      PRINT g_dash
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[45], g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[45], g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
##Patch....NO.TQC-610036 <001> #
#NO.FUN-850139-----end-----
