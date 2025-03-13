# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmr652.4gl
# Descriptions...: 預算/費用差異表
# Date & Author..: 00/04/05 By Melody
# Modify.........: No.FUN-4C0095 04/12/28 By Mandy 報表轉XML
# Modify.........: No.MOD-530190 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: No.TQC-5B0212 05/11/30 By kevin 結束位置調整
# Modify.........: No.TQC-610085 06/04/06 By Claire Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-670003 06/07/10 By Czl  帳別權限修改
# Modify.........: No.FUN-680136 06/09/05 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-720010 07/02/09 By TSD.Michelle 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/30 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.FUN-810069 08/03/07 By lutingting 報表因預算變更增加欄位
# Modify.........: No.FUN-830139 08/04/11 By bnlent s_budamt.4gl參數變更
# Modify.........: No.TQC-840049 08/04/20 By bnlent s_budamt 科目參數調整
# Modify.........: No.TQC-840049 08/04/20 By lutingting更改CONSTRUCT及畫面各欄位順序
# Modify.........: No.MOD-840181 08/04/22 By lutingting更改CONSTRUCT及畫面各欄位順序
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-A40073 10/05/05 By liuxqa 追单TQC-960275 
# Modify.........: No:MOD-AB0144 10/11/16 By Smapmin 抓取已耗用的預算,要傳入期別
# Modify.........: No.FUN-B20054 11/02/24 By xianghui 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No.TQC-B40062 11/04/11 By lilingyu sql變量長度定義過短
# Modify.........: No.TQC-B60289 11/06/22 By suncx    wc定義類型錯誤   
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
	       #wc  	LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(500)	# Where condition
                wc      STRING,  #TQC-B60289
                bookno  LIKE aaa_file.aaa01,    # NO.FUN-670003
   		more	LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1) 		# Input more condition(Y/N)
              END RECORD
 
   DEFINE   g_cnt       LIKE type_file.num10    #No.FUN-680136 INTEGER
   DEFINE   g_i         LIKE type_file.num5     #count/index for any purpose   #No.FUN-680136 SMALLINT
   DEFINE   l_table        STRING,                 ### FUN-720010 ###
            g_str          STRING,                 ### FUN-720010 ###
            g_sql          STRING                  ### FUN-720010 ###
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
 
#No.FUN-810069--start--
## *** FUN-720010 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> TSD.Martin  *** ##
#    LET g_sql = "pnr03.pnr_file.pnr03,",     #部門編號
#               "pnr01.pnr_file.pnr01,",     #預算編號
#                "pnr02.pnr_file.pnr02,",     #科目編號
#                "pnr04.pnr_file.pnr04,",     #年度
#                "pns05.pns_file.pns05,",     #月份
#                "pns06.pns_file.pns06,",     #原始預算金額
#                "pns07.pns_file.pns07,",     #追加金額 
#                "pns08.pns_file.pns08,",     #挪用金額
#                "pns09.pns_file.pns09,",     #月預算金額
#                "afc07.afc_file.afc07,",     #巳消耗預算
#                "used_amt.afc_file.afc06,",  #各期預算
#                "afa02.afa_file.afa02,",     #預算名稱
#                "aag02.aag_file.aag02,",     #科目名稱
#                "gem02.gem_file.gem02,",     #部門名稱
#                "g_azi04.azi_file.azi04,",
#                "g_azi05.azi_file.azi05 " 
    LET g_sql = "afb01.afb_file.afb01,",
                "azf03.azf_file.azf03,",
                "afb02.afb_file.afb02,",
                "aag02.aag_file.aag02,",
                "afb041.afb_file.afb041,",
                "gem02.gem_file.gem02,",
                "afb03.afb_file.afb03,",
                "afb04.afb_file.afb04,",
                "afb042.afb_file.afb042,",
                "pja02.pja_file.pja02,",
                "afc05.afc_file.afc05,",
                "afc09.afc_file.afc09,",
                "afc08.afc_file.afc08,",
                "afc06.afc_file.afc06,",
                "used_amt.afc_file.afc06,",
                "afc07.afc_file.afc07,",
                "g_azi04.azi_file.azi04,",
                "g_azi05.azi_file.azi05"
#    LET l_table = cl_prt_temptable('apmr652',g_sql) CLIPPED   # 產生Temp Table
#    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
#    LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
#                " VALUES(?, ?, ?, ?, ?, ?, ? , ?, ? , ?, ",
#                "        ?, ?, ?, ?, ?, ?)"
    LET l_table = cl_prt_temptable('apmr652',g_sql) CLIPPED
    IF l_table = -1   THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES (?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?)" 
#No.FUN-810069--end 
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
#----------------------------------------------------------CR (1) ------------#
 
#-------------No.TQC-610085 mosify
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
   LET tm.bookno = ARG_VAL(8)	             # Get arguments from command line
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#-------------No.TQC-610085 end
   IF tm.wc IS NULL OR tm.wc=' '
      THEN CALL r652_tm(0,0)	
      ELSE CALL apmr652()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r652_tm(p_row,p_col)
 DEFINE lc_qbe_sn        LIKE gbm_file.gbm01     #No.FUN-580031
 DEFINE li_chk_bookno    LIKE type_file.num5     #No.FUN-680136 SMALLINT   #No.FUN-670003
 DEFINE p_row,p_col	 LIKE type_file.num5,    #No.FUN-680136 SMALLINT 
        l_cmd		 LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 14
 
   OPEN WINDOW r652_w AT p_row,p_col WITH FORM "apm/42f/apmr652"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL		         	# Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.bookno = g_aza.aza81  #No.FUN-B20054
   DISPLAY BY NAME tm.more    #No.FUN-B20054
WHILE TRUE
#No.FUN-B20054--add-start--
      DIALOG ATTRIBUTE(unbuffered)
         INPUT BY NAME tm.bookno ATTRIBUTE(WITHOUT DEFAULTS)
            AFTER FIELD bookno
              IF NOT cl_null(tm.bookno) THEN
                   CALL s_check_bookno(tm.bookno,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD bookno
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = tm.bookno
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",tm.bookno,"","agl-043","","",0)
                   NEXT FIELD  bookno
                END IF
             END IF
         END INPUT

#No.FUN-B20054--add-end--

   #CONSTRUCT BY NAME tm.wc ON pnr01,pnr02,pnr03,pnr04    #FUN-810069
   #CONSTRUCT BY NAME tm.wc ON afb01,afb02,afb041,afb03,afb04,afb042    #FUN-810069   #No.TQC-840049
   CONSTRUCT BY NAME tm.wc ON afb03,afb041,afb01,afb02,afb042,afb04    #No.TQC-840049  #No.MOD-840181
  
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--start-- 
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
#      LET INT_FLAG = 0 CLOSE WINDOW r652_w 
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
#      EXIT PROGRAM
#         
#   END IF
#   DISPLAY BY NAME tm.bookno,tm.more 		# Condition
#   INPUT BY NAME tm.bookno,tm.more WITHOUT DEFAULTS
#No.FUN-B20054--mark--end--     
    INPUT BY NAME tm.more  ATTRIBUTE(WITHOUT DEFAULTS)  #No.FUN-B20054
    #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--start-- 
#      AFTER FIELD bookno
#         IF cl_null(tm.bookno) 
#           THEN NEXT FIELD bookno 
#         END IF
#          #No.FUN-670003--begin
#             CALL s_check_bookno(tm.bookno,g_user,g_plant) 
#                  RETURNING li_chk_bookno
#             IF (NOT li_chk_bookno) THEN
#                NEXT FIELD bookno
#             END IF 
#             #No.FUN-670003--end
#         SELECT COUNT(*) INTO g_cnt FROM aaa_file
#            WHERE aaa01=tm.bookno
#         IF g_cnt=0 THEN
#            CALL cl_err(tm.bookno,'agl-095',0)
#            NEXT FIELD bookno
#         END IF
#No.FUN-B20054--mark--end--
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
#No.FUN-B20054--mark--start--
#      ON ACTION CONTROLR
#         CALL cl_show_req_fields()
#      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
#      ON ACTION CONTROLP
#         IF INFIELD(bookno) THEN
##           CALL q_aaa(FALSE,FALSE,tm.bookno) RETURNING tm.bookno
##           CALL FGL_DIALOG_SETBUFFER( tm.bookno )
#            CALL cl_init_qry_var()
#            LET g_qryparam.form = 'q_aaa'
#            LET g_qryparam.default1 = tm.bookno
#            CALL cl_create_qry() RETURNING tm.bookno
##            CALL FGL_DIALOG_SETBUFFER( tm.bookno )
#            DISPLAY tm.bookno TO FORMONLY.bookno
#            NEXT FIELD bookno
#            DISPLAY BY NAME tm.bookno
#         END IF
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
#No.FUN-B20054--add--start--
      ON ACTION CONTROLP
         IF INFIELD(bookno) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_aaa'
            LET g_qryparam.default1 = tm.bookno
            CALL cl_create_qry() RETURNING tm.bookno
         END IF
         IF INFIELD(afb02) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state= "c"
            LET g_qryparam.form = "q_aag02"
            LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"
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
      LET INT_FLAG = 0 CLOSE WINDOW r652_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
    END IF
   IF tm.wc IS NULL OR tm.wc=' ' THEN LET tm.wc=' 1=1 ' END IF    #No.FUN-B20054 
  IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr652'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr652','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bookno CLIPPED,"'",        #No.TQC-610085 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr652',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r652_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr652()
   ERROR ""
END WHILE
   CLOSE WINDOW r652_w
END FUNCTION
 
FUNCTION apmr652()
#No.TQC-840049  --Begin
 DEFINE l_flag          LIKE type_file.chr1
 DEFINE l_flag1         LIKE type_file.chr1
 DEFINE l_bookno1       LIKE aaa_file.aaa01
 DEFINE l_bookno2       LIKE aaa_file.aaa01
#No.TQC-840049  --End
   DEFINE l_name	LIKE type_file.chr20, 	# External(Disk) file name        #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  	# Used time for running the job   #No.FUN-680136 VARCHAR(8)
#         l_sql 	LIKE type_file.chr1000,	# RDSQL STATEMENT                 #No.FUN-680136 VARCHAR(1000)  #TQC-B40062
          l_sql 	STRING,                           #TQC-B40062
          l_za05	LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(40)
          amt1,amt2,amt3,amt4,amt5,amt6 LIKE afc_file.afc06, #MOD-530190
#No.FUN-810069--start--
#          sr            RECORD
#                           pnr03    LIKE pnr_file.pnr03,
#                           pnr01    LIKE pnr_file.pnr01,
#                           pnr02    LIKE pnr_file.pnr02,
#                           pnr04    LIKE pnr_file.pnr04,
#                           pns05    LIKE pns_file.pns05,
#                           pns06    LIKE pns_file.pns06,
#                           pns07    LIKE pns_file.pns07,
#                           pns08    LIKE pns_file.pns08,
#                           pns09    LIKE pns_file.pns09,
#                           afc07    LIKE afc_file.afc07,
#                           used_amt LIKE afc_file.afc06,#MOD-530190
#                           afa02    LIKE afa_file.afa02,
#                           aag02    LIKE aag_file.aag02,
#                           gem02    LIKE gem_file.gem02 
#                        END RECORD
          sr            RECORD
                           afb01    LIKE afb_file.afb01,
                           afb02    LIKE afb_file.afb02,
                           afb041   LIKE afb_file.afb041,
                           afb03    LIKE afb_file.afb03,
                           afb04    LIKE afb_file.afb04,
                           afb042   LIKE afb_file.afb042,
                           afc05    LIKE afc_file.afc05,
                           afc09    LIKE afc_file.afc09,
                           afc08    LIKE afc_file.afc08,
                           afc06    LIKE afc_file.afc06,
                           afc07    LIKE afc_file.afc07,
                           used_amt LIKE afc_file.afc06,
                           azf03    LIKE azf_file.azf03,
                           aag02    LIKE aag_file.aag02,
                           gem02    LIKE gem_file.gem02,
                           pja02    LIKE pja_file.pja02
                        END RECORD   
#No.FUN-810069--end
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'apmr652'   #NO.FUN-810069
#No.CHI-6A0004------Begin--------------------------
#     SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
#           FROM azi_file WHERE azi01=g_aza.aza17
#No.CHI-6A0004------End----------------------------
 
    ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720010 *** ##
    CALL cl_del_data(l_table)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-720010 add ###
    #------------------------------ CR (2) ------------------------------#
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET tm.wc = tm.wc clipped," AND pnruser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET tm.wc = tm.wc clipped," AND pnrgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET tm.wc = tm.wc clipped," AND pnrgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pnruser', 'pnrgrup')
    #End:FUN-980030
 
    CALL cl_outnam('apmr652') RETURNING l_name
 
#No.FUN-810069--start--
#    LET l_sql = " SELECT pnr03,pnr01,pnr02,pnr04,",
#                "        pns05,pns06,pns07,pns08,pns09",
#                "   FROM pnr_file,pns_file",
#                " WHERE pnr01=pns01 AND pnr02=pns02 ",
#                "   AND pnr03=pns03 AND pnr04=pns04 ",
#                "   AND ",tm.wc CLIPPED
     LET l_sql = " SELECT afb01,afb02,afb041,afb03,afb04,afb042,",
                 "        afc05,afc09,afc08,afc06,afc07",
                 "   FROM afb_file,afc_file",
                 "   WHERE afb01 = afc01",
                 "     AND afb02 = afc02",
                 "     AND afb03 = afc03",
                 "     AND afb04 = afc04",
                 "     AND afb041= afc041",
                 "     AND afb042= afc042",
                 "     AND ", tm.wc CLIPPED
#No.FUN-810069--end
    DISPLAY l_sql
    PREPARE r652_prepare  FROM l_sql
    IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
       EXIT PROGRAM 
    END IF
    DECLARE r652_cs  CURSOR FOR r652_prepare
    IF STATUS THEN CALL cl_err('declare',status,1) END IF
    LET g_pageno = 0
    INITIALIZE sr.* TO NULL
    FOREACH r652_cs INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       #-------------------------------------------------------- 已耗金額
      #CALL s_budamt(sr.pnr03,sr.pnr01,sr.pnr02,sr.pnr04,sr.pns05) #FUN-810069
      #CALL s_budamt(sr.afb041,sr.afb01,sr.afb02,sr.afb03,sr.afc05) #FUN-810069 #No.FUN-830139
      #No.TQC-840049 ...begin
      CALL s_get_bookno(sr.afb03) RETURNING l_flag,l_bookno1,l_bookno2
      IF l_bookno1 = tm.bookno THEN
         LET l_flag1 = '0'
      ELSE
         LET l_flag1 = '1'
      END IF
      #CALL s_budamt1(tm.bookno,sr.afb01,sr.afb02,sr.afb03,sr.afb04,sr.afb041,sr.afb042,0,l_flag) #FUN-810069 #No.FUN-830139   #MOD-AB0144
      CALL s_budamt1(tm.bookno,sr.afb01,sr.afb02,sr.afb03,sr.afb04,sr.afb041,sr.afb042,sr.afc05,l_flag) #FUN-810069 #No.FUN-830139   #MOD-AB0144
      #No.TQC-840049 ...end
            RETURNING amt1, amt2, amt3, amt4, amt5, amt6
       LET sr.used_amt=amt1+ amt2+ amt3+ amt4+ amt5+ amt6
       #-----------------------------------------------------------------
  
#No.FUN-810069--start-- 
       #SELECT afc07 INTO sr.afc07 FROM afc_file
       # WHERE afc05 = sr.pns05 
       #   AND afc01=sr.pnr01   #預算編號
       #   AND afc02=sr.pnr02   #科目
       #   AND afc03=sr.pnr04   #年度
       #   AND afc04=sr.pnr03   #部門
       
       #SELECT afa02 INTO sr.afa02 FROM afa_file WHERE afa01=sr.pnr01
       SELECT azf03 INTO sr.azf03 FROM azf_file WHERE azf01 = sr.afb01 AND azf02 = '2' 
       #SELECT aag02 INTO sr.aag02 FROM aag_file WHERE aag01=sr.pnr02
       #FUN-A40073 mod --str
       #SELECT aag02 INTO sr.aag02 FROM aag_file WHERE aag01=sr.afb02
       SELECT aag02 INTO sr.aag02 FROM aag_file WHERE aag01=sr.afb02 AND aag00 = tm.bookno 
       #FUN-A40073 mod --end
       #SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem01=sr.pnr03
       SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem01=sr.afb041
       SELECT pja02 INTO sr.pja02 FROM pja_file WHERE pja01=sr.afb042 
#No.FUN-810069--end
 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720010 *** ##
#No.FUN-810069--start--
#       EXECUTE insert_prep USING 
#               sr.pnr03,sr.pnr01,sr.pnr02,sr.pnr04,sr.pns05,
#               sr.pns06,sr.pns07,sr.pns08,sr.pns09,sr.afc07,
#               sr.used_amt,sr.afa02,sr.aag02,sr.gem02,g_azi04,g_azi05
       EXECUTE  insert_prep USING
                sr.afb01,sr.azf03,sr.afb02,sr.aag02,sr.afb041,sr.gem02,
                sr.afb03,sr.afb04,sr.afb042,sr.pja02,sr.afc05,sr.afc09,
                sr.afc08,sr.afc06,sr.used_amt,sr.afc07,g_azi04,g_azi05
#No.FUN-810069--end
       #------------------------------ CR (3) ------------------------------#
 
       INITIALIZE sr.* TO NULL
    END FOREACH
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720010 **** ##
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
    LET g_str = ''
    #是否列印選擇條件
#No.FUN-810069--start--
#    #IF g_zz05 = 'Y' THEN
#       CALL cl_wcchp(tm.wc,'pnr01,pnr02,pnr03,pnr04') 
#            RETURNING tm.wc
#       LET g_str = tm.wc
#    #END IF
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'afb01,afb02,afb041,afb03,afb04,afb042')
            RETURNING tm.wc
       LET g_str = tm.wc
    END IF
#No.FUN-810069--end
    LET g_str = g_str,";",tm.bookno
    CALL cl_prt_cs3('apmr652','apmr652',l_sql,g_str)   #FUN-710080 modify
    #------------------------------ CR (4) ------------------------------#
END FUNCTION
