# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gapr910.4gl
# Descriptions...: 廠商業務明細帳列印
# Date & Author..: 03/05/19 by Carrier
# Modify.........: No.FUN-540057 05/05/10 By wujie 發票號碼調整
# Modify.........: No.FUN-550030 05/05/20 By ice 單據編號欄位放大
# Modify.........: No.TQC-630166 06/03/16 By 整批修改，將g_wc[1,70]改為g_wc.subString(1,......)寫法
# Modify.........: No.TQC-630193 06/03/21 By Smapmin 重新抓取g_len
# Modify.........: No.FUN-660071 06/06/13 By Carrier cl_err --> cl_err3
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-670003 06/07/10 By Czl  帳別權限修改
# Modify.........: NO.FUN-670107 06/08/24 BY flowld voucher型報表轉template1
# Modify.........: No.FUN-690009 06/09/04 By Dxfwo  欄位類型定義
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-740064 07/04/16 By arman 會計科目加帳套
# Modify.........: No.TQC-920071 09/02/23 By zhaijie 修正SQL語法 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B10053 11/01/20 By yinhy 科目查询自动过滤,調整帳套位置
# Modify.........: No:FUN-B80049 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm          RECORD                         # Print condition RECORD
   		  #wc      VARCHAR(1000),            # Where condition
                   wc 	   STRING,		  #TQC-630166
	 	   a       LIKE type_file.chr1000,  #NO FUN-690009 VARCHAR(20) 
		   bdate   LIKE type_file.dat,      #NO FUN-690009 DATE
		   edate   LIKE type_file.dat,      #NO FUN-690009 DATE
                   o       LIKE aaa_file.aaa01,     #NO.FUN-670003 
                   b       LIKE type_file.chr1,     #NO FUN-690009 VARCHAR(01)
                   c       LIKE azi_file.azi01,     #NO FUN-690009 VARCHAR(4)
                   d       LIKE type_file.chr1,     #NO FUN-690009 VARCHAR(01)
                   e       LIKE type_file.chr1,     #NO FUN-690009 VARCHAR(01)
		   more    LIKE type_file.chr1      # Prog. Version..: '5.30.06-13.03.12(01)    # Input more condition(Y/N)
                   END RECORD,
       g_d         LIKE type_file.chr1,         #NO FUN-690009 VARCHAR(01)
       g_print     LIKE type_file.num5,         #NO FUN-690009 SMALLINT
       g_aaa03     LIKE aaa_file.aaa03,
       g_aza17     LIKE aza_file.aza17,
       l_aza17     LIKE aza_file.aza17,
       g_qcyef     LIKE npq_file.npq07,
       g_qcye      LIKE npq_file.npq07,
       g_npq07f_l  LIKE npq_file.npq07,
       g_npq07f_r  LIKE npq_file.npq07,
       g_npq07_l   LIKE npq_file.npq07,
       g_npq07_r   LIKE npq_file.npq07
DEFINE   g_i       LIKE type_file.num5     #NO FUN-690009 SMALLINT   #count/index for any purpose
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   #-----TQC-610053---------
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a = ARG_VAL(8)
   LET tm.bdate = ARG_VAL(9)
   LET tm.edate = ARG_VAL(10)
   LET tm.o = ARG_VAL(11)
   LET tm.b = ARG_VAL(12)
   LET tm.c = ARG_VAL(13)
   LET tm.d = ARG_VAL(14)
   LET tm.e = ARG_VAL(15)
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   #-----END TQC-610053-----
 
   LET tm.wc = ARG_VAL(1)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(2)
   LET g_rep_clas = ARG_VAL(3)
   LET g_template = ARG_VAL(4)
   #No.FUN-570264 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   #CALL cl_used(g_prog,g_time,1) RETURNING g_time            #FUN-B80049   ADD  #FUN-BB0047 mark
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   INITIALIZE tm.* TO NULL                # Default condition
 
   #-->使用預設帳別之幣別
   SELECT aaa03 INTO l_aza17 FROM aaa_file WHERE aaa01 = g_apz.apz02b
   IF SQLCA.sqlcode THEN LET l_aza17 = g_aza.aza17 END IF     #使用本國幣別
   IF cl_null(tm.wc) THEN
       CALL gapr910_tm(0,0)             # Input print condition
   ELSE
       CALL gapr910()   #TQC-610053
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
END MAIN
 
FUNCTION gapr910_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01      #No.FUN-580031
DEFINE li_chk_bookno  LIKE type_file.num5      #No.FUN-670003 #NO FUN-690009 SMALLINT
DEFINE p_row,p_col    LIKE type_file.num5,     #NO FUN-690009 SMALLINT
       l_n            LIKE type_file.num5,     #NO FUN-690009 SMALLINT
       l_flag         LIKE type_file.num5,     #NO FUN-690009 SMALLINT
       l_cmd          LIKE type_file.chr1000   #NO FUN-690009 VARCHAR(1000)
 
   OPEN WINDOW gapr910_w WITH FORM "gap/42f/gapr910"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET tm.o = g_apz.apz02b
   LET tm.b = 'N'
   LET tm.c = ''
   LET tm.d = '1'
   LET tm.e = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   DISPLAY BY NAME tm.a,tm.bdate,tm.edate,tm.o,tm.b,tm.c,tm.d,tm.e,tm.more
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON npq21,npp01
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
  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW gapr910_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   #INPUT BY NAME tm.a,tm.bdate,tm.edate,tm.o,tm.b,tm.c,tm.d,tm.e,tm.more
   INPUT BY NAME tm.o,tm.a,tm.bdate,tm.edate,tm.b,tm.c,tm.d,tm.e,tm.more
                 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
        LET l_flag = 0
        IF cl_null(tm.a) THEN
           CALL cl_err('','mfg3018',0)
           NEXT FIELD a
        ELSE
           SELECT COUNT(*) INTO l_n FROM aag_file
            WHERE aag01 = tm.a AND aag07 IN ('2','3')
              AND aag00 = tm.o         #NO.FUN-740064
           #No.FUN-B10053  --Begin
           #IF l_n = 0 THEN CALL cl_err(tm.a,'aap-021',0) NEXT FIELD a END IF
           IF l_n = 0 THEN 
              CALL cl_err(tm.a,'aap-021',0) 
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_aag'
              LET g_qryparam.construct = 'N'
              LET g_qryparam.default1 = tm.a
              LET g_qryparam.arg1 = tm.o
              LET g_qryparam.where = " aag07 IN ('2','3')  AND aagacti='Y' AND aag01 LIKE '",tm.a CLIPPED ,"%'"
              CALL cl_create_qry() RETURNING tm.a
              DISPLAY BY NAME tm.a 
              NEXT FIELD a 
           END IF
           #No.FUN-B10053  --End
        END IF
 
      AFTER FIELD bdate
        IF cl_null(tm.bdate) THEN
           CALL cl_err('','mfg3018',0)
           NEXT FIELD bdate
        END IF
 
      AFTER FIELD edate
        IF cl_null(tm.edate) THEN
           CALL cl_err('','mfg3018',0)
           NEXT FIELD edate
        END IF
        IF YEAR(tm.bdate) <> YEAR(tm.edate) THEN
           CALL cl_err('','gxr-001',0)
           NEXT FIELD bdate END IF
        IF tm.bdate > tm.edate THEN
           CALL cl_err('','aap-100',0)
           NEXT FIELD bdate
        END IF
 
      AFTER FIELD o
        IF cl_null(tm.o) THEN CALL cl_err('','mfg3018',0) NEXT FIELD o END IF
           #No.FUN-670003--begin
         CALL s_check_bookno(tm.o,g_user,g_plant) 
             RETURNING li_chk_bookno
         IF (NOT li_chk_bookno) THEN
             NEXT FIELD o
         END IF 
         #No.FUN-670003--end
        SELECT * FROM aaa_file WHERE aaa01 = tm.o
        IF SQLCA.sqlcode THEN
           #No.FUN-660071  --Begin
           #CALL cl_err('',SQLCA.sqlcode,0)
           CALL cl_err3("sel","aaa_file",tm.o,"",SQLCA.sqlcode,"","",0) #No.FUN-660071
           NEXT FIELD o
           #No.FUN-660071  --End  
        END IF
        #No.FUN-B10053  --Begin
        IF NOT cl_null(tm.a) THEN
           SELECT COUNT(*) INTO l_n FROM aag_file
            WHERE aag01 = tm.a AND aag07 IN ('2','3')
              AND aag00 = tm.o
           IF l_n = 0 THEN CALL cl_err(tm.a,'aap-021',0) NEXT FIELD a END IF
        END IF
        #No.FUN-B10053  --End
        SELECT aaa03 INTO l_aza17 FROM aaa_file WHERE aaa01 = tm.o
        IF SQLCA.sqlcode THEN LET l_aza17 = g_aza.aza17 END IF   #使用本國幣別
 
      AFTER FIELD b
        LET l_flag = 1
        IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
           NEXT FIELD b
        END IF
        IF tm.b = 'N' THEN
           LET tm.c = NULL
           DISPLAY BY NAME tm.c
        END IF
 
      BEFORE FIELD c
        IF l_flag = 1 THEN
             IF tm.b = 'N' THEN NEXT FIELD d END IF
        ELSE IF l_flag = 2 THEN
                IF tm.b = 'N' THEN NEXT FIELD o END IF
             END IF
        END IF
 
      AFTER FIELD c
        IF tm.b = 'Y' THEN
           IF cl_null(tm.c) THEN NEXT FIELD c END IF
           SELECT COUNT(*) INTO l_n FROM azi_file WHERE azi01 = tm.c
           IF l_n = 0 THEN CALL cl_err(tm.c,'aap-002',0) NEXT FIELD c END IF
        END IF
 
      AFTER FIELD d
        LET l_flag = 2
        IF cl_null(tm.d) OR tm.d NOT MATCHES '[123]' THEN NEXT FIELD d END IF
 
      AFTER FIELD e
        IF cl_null(tm.e) OR tm.e NOT MATCHES '[YN]' THEN
           NEXT FIELD e
        END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
     AFTER INPUT
        IF tm.b = 'N' THEN LET tm.c = '' DISPLAY BY NAME tm.c END IF
        IF tm.b = 'Y' AND cl_null(tm.c) THEN NEXT FIELD c END IF
     ON ACTION CONTROLP
        CASE WHEN INFIELD(a)     #科目代號
#                  CALL q_aag(8,5,tm.a,'23','','')
#                       RETURNING tm.a
#                  CALL FGL_DIALOG_SETBUFFER( tm.a )
################################################################################
# START genero shell script ADD
    CALL cl_init_qry_var()
    LET g_qryparam.form = 'q_aag'
    LET g_qryparam.default1 = tm.a
    LET g_qryparam.arg1 = tm.o         #NO.FUN-740064
    CALL cl_create_qry() RETURNING tm.a
#    CALL FGL_DIALOG_SETBUFFER( tm.a )
# END genero shell script ADD
################################################################################
                   DISPLAY BY NAME tm.a
                   NEXT FIELD a
             WHEN INFIELD(c)     #科目代號
#                  CALL q_azi(8,5,tm.c)
#                       RETURNING tm.c
#                  CALL FGL_DIALOG_SETBUFFER( tm.c )
################################################################################
# START genero shell script ADD
    CALL cl_init_qry_var()
    LET g_qryparam.form = 'q_azi'
    LET g_qryparam.default1 = tm.c
    CALL cl_create_qry() RETURNING tm.c
#    CALL FGL_DIALOG_SETBUFFER( tm.c )
# END genero shell script ADD
################################################################################
                   DISPLAY BY NAME tm.c
                   NEXT FIELD c
        END CASE
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
 
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
      CLOSE WINDOW gapr910_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='gapr910'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('gapr910','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate   CLIPPED,"'",
                         " '",g_towhom  CLIPPED,"'",
                         " '",g_lang    CLIPPED,"'",
                         " '",g_bgjob   CLIPPED,"'",
                         " '",g_prtway  CLIPPED,"'",
                         " '",g_copies  CLIPPED,"'",
                         " '",tm.wc     CLIPPED,"'",
                         " '",tm.a      CLIPPED,"'",
                         " '",tm.bdate  CLIPPED,"'",
                         " '",tm.edate  CLIPPED,"'",
                         " '",tm.o      CLIPPED,"'",
                         " '",tm.b      CLIPPED,"'",
                         " '",tm.c      CLIPPED,"'",
                         " '",tm.d      CLIPPED,"'",
                         " '",tm.e      CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('gapr910',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW gapr910_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gapr910()
   ERROR ""
END WHILE
   CLOSE WINDOW gapr910_w
END FUNCTION
 
FUNCTION gapr910()
   DEFINE l_name    LIKE type_file.chr20,    #NO FUN-690009 VARCHAR(20)    # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0097
          l_sql     LIKE type_file.chr1000,  #NO FUN-690009 VARCHAR(1000)
          l_sql1    LIKE type_file.chr1000,  #NO FUN-690009 VARCHAR(1000)
          l_apa09   LIKE apa_file.apa09,
          l_apa08   LIKE apa_file.apa08,
          l_totf    LIKE apm_file.apm06f,     #apm before period
          l_tot     LIKE apm_file.apm06,
          l_npq07f  LIKE npq_file.npq07f,     #npq before period
          l_npq07   LIKE npq_file.npq07f,
          d_npq07f  LIKE npq_file.npq07f,     #debit before period
          d_npq07   LIKE npq_file.npq07f,
          c_npq07f  LIKE npq_file.npq07f,     #credit before period
          c_npq07   LIKE npq_file.npq07f,
          m_npq07   LIKE npq_file.npq07f,     #middle period
          m_npq07f  LIKE npq_file.npq07f,
          l_qcye    LIKE npq_file.npq07,      #total before period
          l_qcyef   LIKE npq_file.npq07,
          l_npp01   LIKE npp_file.npp01,
          l_flag    LIKE type_file.chr1,     #NO FUN-690009 VARCHAR(01)
          l_i       LIKE type_file.num5,     #NO FUN-690009 SMALLINT
          l_term    LIKE type_file.chr1000,  #NO FUN-690009 VARCHAR(300)
          sr1       RECORD
                        npq21    LIKE npq_file.npq21,
                        npq22    LIKE npq_file.npq22
                    END RECORD,
          sr        RECORD
                        npp01    LIKE npp_file.npp01,
                        npp02    LIKE npp_file.npp02,
                        npq03    LIKE npq_file.npq03,
                        aag02    LIKE aag_file.aag02,
                        npq06    LIKE npq_file.npq06,
                        npq07f   LIKE npq_file.npq07f,
                        npq07    LIKE npq_file.npq07,
                        npq21    LIKE npq_file.npq21,
                        npq22    LIKE occ_file.occ18,
                        npq24    LIKE npq_file.npq24,
                        apa09    LIKE apa_file.apa09,
                        apa08    LIKE apa_file.apa08,
                        qcyef    LIKE npq_file.npq07,
                        qcye     LIKE npq_file.npq07
                    END RECORD
 
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-BB0047--mark--End-----
     SELECT aaf03 INTO g_company FROM aaf_file
      WHERE aaf01 = tm.o AND aaf02 = g_rlang
 
     IF tm.b = 'Y' THEN
        LET g_aza17 = tm.c
     ELSE
        LET g_aza17 = l_aza17
     END IF
     IF tm.d = '1' THEN
        LET g_d = 'Y'
     ELSE
        LET g_d = 'N'
     END IF
     SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_aza17      #No.CHI-6A0004
     IF SQLCA.sqlcode THEN 
        #CALL cl_err('sel azi',SQLCA.sqlcode,0)  #No.FUN-660071
        CALL cl_err3("sel","azi_file",g_aza17,"",SQLCA.sqlcode,"","",0) #No.FUN-660071
     END IF
 
     LET l_term = "  WHERE nppsys = npqsys AND npp00 = npq00 ",
                  "    AND npp01 = npq01 AND npp011 = npq011 ",
                  "    AND nppsys = 'AP' AND npp011 = 1 ",
                  "    AND npq03 = '",tm.a CLIPPED,"'",
                  "    AND npp06 = '",g_plant,"'",
                  "    AND npp07 = '",tm.o,"'",
                  "    AND ",tm.wc CLIPPED
     IF tm.b = "Y" THEN
        LET l_term = l_term CLIPPED," AND npq24 = '",tm.c CLIPPED,"'"
     END IF
     LET l_sql = " SELECT UNIQUE npq21,'' FROM npq_file,npp_file ",
                 l_term
     PREPARE gapr910_pr1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
        EXIT PROGRAM
     END IF
     DECLARE gapr910_curs1 CURSOR FOR gapr910_pr1
 
     LET l_sql1="SELECT npp01,npp02,npq03,aag02,npq06,SUM(npq07f),",
                "       SUM(npq07),npq21,npq22,npq24,'','',0,0 ",
                " FROM npp_file,npq_file,aag_file ",l_term CLIPPED,
                "   AND npq03 = aag01 ",
                "   AND npp07 = aag00  AND aag00 = '",tm.o ,"'", #NO.FUN-740064  #TQC-920071
                "   AND npq21 = ? ",
                "   AND npp02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                " GROUP BY npp01,npp02,npq03,aag02,npq06,npq21,npq22,npq24 ",
                " ORDER BY npq21,npq22,npq03,npp02,npp01,npq06 "
     PREPARE gapr910_prepare1 FROM l_sql1
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
        EXIT PROGRAM
     END IF
     DECLARE gapr910_curs CURSOR FOR gapr910_prepare1
     LET l_sql1 =" SELECT npp01,SUM(npq07f),SUM(npq07) ",
                 "   FROM npq_file,npp_file ",l_term CLIPPED,
                 "  AND npq21 = ? ",
                 "  AND YEAR(npp02) = ",YEAR(tm.bdate),
                 "  AND MONTH(npp02)= ",MONTH(tm.bdate),
                 "  AND npp02 < '",tm.bdate,"'",
                 "  AND npq06 = ? ",
                 "  GROUP BY npp01"
     PREPARE gapr910_prepare3 FROM l_sql1
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
        EXIT PROGRAM
     END IF
     DECLARE gapr910_curd CURSOR FOR gapr910_prepare3
 
     CALL cl_outnam('gapr910') RETURNING l_name
# NO.FUN-670107 --start--
#     #-----TQC-630193---------
#     IF g_len = 0 OR g_len IS NULL THEN
#        IF tm.b = 'N' THEN LET g_len = 116 ELSE LET g_len = 164 END IF
#     END IF
#     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#     #-----END TQC-630193-----
# NO.FUN-670107 ---end---
 
# NO.FUN-670107 --start--
     IF tm.b = 'N' THEN
      LET g_zaa[31].zaa06 = "N"
      LET g_zaa[32].zaa06 = "N"
      LET g_zaa[33].zaa06 = "N"
      LET g_zaa[34].zaa06 = "N"
      LET g_zaa[35].zaa06 = "N"
      LET g_zaa[36].zaa06 = "N"
      LET g_zaa[37].zaa06 = "Y"
      LET g_zaa[38].zaa06 = "Y"
      LET g_zaa[39].zaa06 = "Y"
      LET g_zaa[40].zaa06 = "Y"
      LET g_zaa[41].zaa06 = "N"
      LET g_zaa[42].zaa06 = "N"
      LET g_zaa[43].zaa06 = "Y"
      LET g_zaa[44].zaa06 = "Y"
    ELSE
      LET g_zaa[31].zaa06 = "N"
      LET g_zaa[32].zaa06 = "N"
      LET g_zaa[33].zaa06 = "N"
      LET g_zaa[34].zaa06 = "N"
      LET g_zaa[35].zaa06 = "Y"
      LET g_zaa[36].zaa06 = "Y"
      LET g_zaa[37].zaa06 = "N"
      LET g_zaa[38].zaa06 = "N"
      LET g_zaa[39].zaa06 = "N"
      LET g_zaa[40].zaa06 = "N"
      LET g_zaa[41].zaa06 = "N"
      LET g_zaa[42].zaa06 = "Y"
      LET g_zaa[43].zaa06 = "N"
      LET g_zaa[44].zaa06 = "N"
    END IF
      CALL cl_prt_pos_len()
# NO.FUN-670107 ---end---
 
     IF tm.b = 'N' THEN   #本幣
        START REPORT gapr910_rep TO l_name
     ELSE                 #原幣
        START REPORT gapr910_rep1 TO l_name
     END IF
     LET g_pageno = 0
 
     FOREACH gapr910_curs1 INTO sr1.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,0) EXIT FOREACH
       END IF
       IF tm.b = "N" THEN
          SELECT SUM(apm06-apm07)  #前幾期的余額
            INTO l_tot FROM apm_file
           WHERE apm01 = sr1.npq21 AND apm00 = tm.a
             AND apm04 = YEAR(tm.bdate)
             AND apm05 < MONTH(tm.bdate)
             AND apm08 = g_plant AND apm09 = tm.o
       ELSE
          SELECT SUM(apm06f-apm07f),SUM(apm06-apm07)  #前幾期的余額
            INTO l_totf,l_tot FROM apm_file
           WHERE apm01 = sr1.npq21 AND apm00 = tm.a
             AND apm11 = g_aza17
             AND apm04 = YEAR(tm.bdate)
             AND apm05 < MONTH(tm.bdate)
             AND apm08 = g_plant AND apm09 = tm.o
       END IF
       IF cl_null(l_totf) THEN LET l_totf = 0 END IF
       IF cl_null(l_tot) THEN LET l_tot = 0 END IF
 
       LET d_npq07f = 0     LET d_npq07 = 0
       FOREACH gapr910_curd USING sr1.npq21,'1' INTO l_npp01,l_npq07f,l_npq07
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,0)
             EXIT FOREACH
          END IF
          CALL r910_apa(0,l_npp01) RETURNING l_flag,l_apa09,l_apa08
          IF l_flag = 'N' THEN CONTINUE FOREACH END IF
          LET d_npq07  = d_npq07  + l_npq07
          LET d_npq07f = d_npq07f + l_npq07f
       END FOREACH
       IF cl_null(d_npq07f) THEN LET d_npq07f = 0 END IF
       IF cl_null(d_npq07)  THEN LET d_npq07  = 0 END IF
 
       LET c_npq07f = 0     LET c_npq07 = 0
       FOREACH gapr910_curd USING sr1.npq21,'2' INTO l_npp01,l_npq07f,l_npq07
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,0)
             EXIT FOREACH
          END IF
          CALL r910_apa(0,l_npp01) RETURNING l_flag,l_apa09,l_apa08
          IF l_flag = 'N' THEN CONTINUE FOREACH END IF
          LET c_npq07  = c_npq07  + l_npq07
          LET c_npq07f = c_npq07f + l_npq07f
       END FOREACH
       IF cl_null(c_npq07f) THEN LET c_npq07f = 0 END IF
       IF cl_null(c_npq07)  THEN LET c_npq07  = 0 END IF
 
       LET l_qcyef = l_totf + d_npq07f - c_npq07f  #原幣期初余額
       LET l_qcye  = l_tot + d_npq07  - c_npq07   #本幣期初余額
 
       IF tm.b = 'N' THEN
          SELECT SUM(npq07) INTO m_npq07  #當期異動
            FROM npp_file,npq_file
           WHERE nppsys=npqsys and npp00=npq00
             AND npp01=npq01   AND npp011 = npq011
             AND nppsys = 'AP' AND npp011 = 1
             AND npq03 = tm.a  AND npq21 = sr1.npq21
             AND npp02 BETWEEN tm.bdate AND tm.edate
             AND npp06 = g_plant AND npp07 = tm.o
        ELSE
          SELECT SUM(npq07f),SUM(npq07) INTO m_npq07f,m_npq07  #當期異動
            FROM npp_file,npq_file
           WHERE nppsys=npqsys and npp00=npq00
             AND npp01=npq01   AND npp011 = npq011
             AND nppsys = 'AP' AND npp011 = 1
             AND npq03 = tm.a  AND npq24 = g_aza17
             AND npq21 = sr1.npq21
             AND npp02 BETWEEN tm.bdate AND tm.edate
             AND npp06 = g_plant AND npp07 = tm.o
        END IF
        IF cl_null(m_npq07f) THEN LET m_npq07f = 0 END IF
        IF cl_null(m_npq07)  THEN LET m_npq07  = 0 END IF
 
        IF tm.e = 'N' THEN  #期初為零且無異動不打印
           IF tm.b = 'N' AND l_qcye = 0 AND m_npq07 = 0 THEN  #本幣
              CONTINUE FOREACH
           END IF
           IF tm.b = 'Y' AND l_qcyef = 0 AND l_qcye = 0   #外幣
              AND m_npq07f = 0 AND m_npq07 = 0 THEN
                 CONTINUE FOREACH
           END IF
        END IF
        LET g_print = 0
        FOREACH gapr910_curs USING sr1.npq21 INTO sr.*
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,0)
             EXIT FOREACH
          END IF
          CALL r910_apa(1,sr.npp01) RETURNING l_flag,l_apa09,l_apa08
          IF l_flag = 'N' THEN CONTINUE FOREACH END IF
          LET sr.apa09 = l_apa09
          LET sr.apa08 = l_apa08
          LET sr.qcyef = l_qcyef
          LET sr.qcye  = l_qcye
          IF tm.b = 'N' THEN   #本幣
             OUTPUT TO REPORT gapr910_rep(sr.*)
          ELSE                 #原幣
             OUTPUT TO REPORT gapr910_rep1(sr.*)
          END IF
          LET g_print = g_print + 1
        END FOREACH
        IF g_print = 0 THEN   #沒有打印過
           IF tm.e = 'N' THEN  #這時存在一種情況是它是有異動的，但是它的異動
              IF tm.b = 'N' AND l_qcyef = 0 THEN  #沒有被打印，即不滿足打印
                 CONTINUE FOREACH                 #條件，則判斷是否要打印
              END IF
              IF tm.b = 'Y' AND l_qcyef = 0 AND l_qcye = 0 THEN
                 CONTINUE FOREACH
              END IF
           END IF
           LET sr.npp01 = ''
           LET sr.npp02 =''
           LET sr.npq03 = tm.a
           SELECT aag02 INTO sr.aag02 FROM aag_file
            WHERE aag01 = tm.a
              AND aag00 = tm.o     #NO.FUN-740064
           LET sr.npq07f =0
           LET sr.npq07 = 0
           LET sr.npq21 = sr1.npq21
           SELECT UNIQUE  npq22 INTO sr.npq22
             FROM npq_file
            WHERE npq21 = sr1.npq21
           IF SQLCA.sqlcode THEN
              LET sr.npq22 = ''
           END IF
           LET sr.npq24 = g_aza17
           LET sr.apa09 =''
           LET sr.apa08 =''
           LET sr.qcye  = l_qcye
           LET sr.qcyef = l_qcyef
           IF tm.b = 'N' THEN   #本幣
              OUTPUT TO REPORT gapr910_rep(sr.*)
           ELSE                 #原幣
              OUTPUT TO REPORT gapr910_rep1(sr.*)
           END IF
        END IF
     END FOREACH
 
     IF tm.b = 'N' THEN   #本幣
        FINISH REPORT gapr910_rep
     ELSE                 #原幣
        FINISH REPORT gapr910_rep1
     END IF
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-BB0047--mark--End-----
END FUNCTION
 
REPORT gapr910_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,    #NO FUN-690009 VARCHAR(1)
          sr        RECORD
                        npp01    LIKE npp_file.npp01,
                        npp02    LIKE npp_file.npp02,
                        npq03    LIKE npq_file.npq03,
                        aag02    LIKE aag_file.aag02,
                        npq06    LIKE npq_file.npq06,
                        npq07f   LIKE npq_file.npq07f,
                        npq07    LIKE npq_file.npq07,
                        npq21    LIKE npq_file.npq21,
                        npq22    LIKE occ_file.occ18,
                        npq24    LIKE npq_file.npq24,
                        apa09    LIKE apa_file.apa09,
                        apa08    LIKE apa_file.apa08,
                        qcyef    LIKE npq_file.npq07,
                        qcye     LIKE npq_file.npq07
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.npq21,sr.npq22,sr.npq03,sr.npp02,sr.npp01,sr.npq06
  FORMAT
   PAGE HEADER
# NO.FUN-670107 --start--
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      PRINT COLUMN (g_len-FGL_WIDTH(g_company CLIPPED))/2+1,g_company CLIPPED
#      IF g_towhom IS NULL OR g_towhom = ' '
#         THEN PRINT '';
#         ELSE PRINT 'TO:',g_towhom;
#      END IF
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#    PRINT (g_len-FGL_WIDTH(g_x[1] CLIPPED))/2 SPACES,g_x[1]
 
     LET g_pageno = g_pageno + 1
     LET pageno_total = PAGENO USING '<<<',"/pageno"
     PRINT g_head CLIPPED,pageno_total 
 
    PRINT COLUMN (g_len-FGL_WIDTH(g_x[1] CLIPPED))/2+1,g_x[1]    
 
      PRINT ' '
 
#      LET g_pageno = g_pageno + 1
      PRINT COLUMN 01,g_x[11] CLIPPED,
            COLUMN 10,sr.npq21 CLIPPED,' ',sr.npq22 CLIPPED
      PRINT COLUMN 01,g_x[12] CLIPPED,
            COLUMN 10,sr.aag02 CLIPPED,'(',sr.npq03 CLIPPED,')'
#      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
       PRINT COLUMN 01,g_x[14] CLIPPED,tm.bdate,'-',tm.edate,
             COLUMN 38,g_x[26] CLIPPED,tm.o
#            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT g_dash
# NO.FUN-670107 ---end---
# NO.FUN-670107 --start--
##NO.FUN540057--begin
#      PRINT COLUMN  1,g_x[15] CLIPPED,
#            COLUMN 53,g_x[16] CLIPPED,   #No.FUN-550030
#            COLUMN 96,g_x[17] CLIPPED    #No.FUN-550030
#      PRINT '-------- ---------------- -------- ---------------- ',    #No.FUN-550030
#            '------------------ ------------------  --  ------------------'
##NO.FUN540057--end
       PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
             g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
             g_x[41],g_x[42],g_x[43],g_x[44]
       PRINT g_dash1  
# NO.FUN-670107 ---end---   
    LET l_last_sw ='n'
 
   BEFORE GROUP OF sr.npq21
     SKIP TO TOP OF PAGE
     LET g_qcye = sr.qcye
     LET g_npq07_l = 0
     LET g_npq07_r = 0
#     PRINT COLUMN 1,g_x[23] CLIPPED;  # NO.FUN-670107
      PRINT COLUMN g_c[31],g_x[23] CLIPPED; # NO.FUN-670107
     IF sr.qcye > 0 THEN
# NO.FUN-670107 --start--
##NO.FUN540057--begin
#        PRINT COLUMN 92,g_x[24].substring(1,2),        #No.FUN-550030
#              COLUMN 95,cl_numfor(sr.qcye,18,g_azi04)  #No.FUN-550030
 
        PRINT COLUMN g_c[41],g_x[24].substring(1,2),
              COLUMN g_c[42],cl_numfor(sr.qcye,42,t_azi04)    #No.CHI-6A0004 
 
     ELSE
        IF sr.qcye = 0 THEN
#           PRINT COLUMN 92,g_x[24].substring(5,6),       #No.FUN-550030
#                 COLUMN 95,cl_numfor(sr.qcye,18,g_azi04) #No.FUN-550030
 
            PRINT COLUMN g_c[41],g_x[24].substring(5,6),
                  COLUMN g_c[42],cl_numfor(sr.qcye,42,t_azi04)  #No.CHI-6A0004   
      ELSE
 
#           PRINT COLUMN 92,g_x[24].substring(3,4),          #No.FUN-550030
#                 COLUMN 95,cl_numfor(sr.qcye*-1,18,g_azi04) #No.FUN-550030
 
            PRINT COLUMN g_c[41],g_x[24].substring(3,4),
                  COLUMN g_c[42],cl_numfor(sr.qcye*-1,42,t_azi04)   #No.CHI-6A0004 
#NO.FUN540057--end
# NO.FUN-670107 ---end---
        END IF
     END IF
 
   ON EVERY ROW
     IF sr.npq07 <> 0 THEN
# NO.FUN-670107 --start--
#        PRINT COLUMN   1,sr.npp02,
#              COLUMN  10,sr.npp01 CLIPPED,
#              COLUMN  27,sr.apa09,     #No.FUN-550030
##NO.FUN540057--begin
#              COLUMN  36,sr.apa08;      #No.FUN-550030
         
        PRINT COLUMN g_c[31],sr.npp02,
              COLUMN g_c[32],sr.npp01 CLIPPED,
              COLUMN g_c[33],sr.apa09,
              COLUMN g_c[34],sr.apa08;
 
        IF sr.npq06 = '1' THEN
#           PRINT COLUMN 52,cl_numfor(sr.npq07,18,g_azi04);  #No.FUN-550030
          PRINT COLUMN g_c[35],cl_numfor(sr.npq07,35,t_azi04);    #No.CHI-6A0004 
 
          LET g_qcye = g_qcye + sr.npq07
           LET g_npq07_l = g_npq07_l + sr.npq07
        ELSE
#           PRINT COLUMN 71,cl_numfor(sr.npq07,18,g_azi04);  #No.FUN-550030
          PRINT COLUMN g_c[36],cl_numfor(sr.npq07,36,t_azi04);     #No.CHI-6A0004 
 
          LET g_qcye = g_qcye - sr.npq07
           LET g_npq07_r = g_npq07_r + sr.npq07
        END IF
        IF g_qcye > 0 THEN
#           PRINT COLUMN 92,g_x[24].substring(1,2),           #No.FUN-550030
#                 COLUMN 95,cl_numfor(g_qcye,18,g_azi04)      #No.FUN-550030
 
           PRINT COLUMN g_c[41],g_x[24].substring(1,2),
                 COLUMN g_c[42],cl_numfor(g_qcye,42,t_azi04)    #No.CHI-6A0004 
    
       ELSE
           IF g_qcye = 0 THEN
#              PRINT COLUMN 92,g_x[24].substring(5,6),        #No.FUN-550030
#                    COLUMN 95,cl_numfor(g_qcye,18,g_azi04)   #No.FUN-550030
 
              PRINT COLUMN g_c[41],g_x[24].substring(5,6), 
                    COLUMN g_c[42],cl_numfor(g_qcye,42,t_azi04)    #No.CHI-6A0004 
          ELSE
#              PRINT COLUMN 92,g_x[24].substring(3,4),         #No.FUN-550030
#                    COLUMN 95,cl_numfor(g_qcye*-1,18,g_azi04) #No.FUN-550030
 
              PRINT COLUMN g_c[41],g_x[24].substring(3,4),
                    COLUMN g_c[42],cl_numfor(g_qcye*-1,42,t_azi04)    #No.CHI-6A0004 
          END IF
        END IF
     END IF
 
   AFTER GROUP OF sr.npq21
#     PRINT COLUMN 1,g_x[25] CLIPPED,
#           COLUMN 52,cl_numfor(g_npq07_l,18,g_azi04),     #No.FUN-550030
#           COLUMN 71,cl_numfor(g_npq07_r,18,g_azi04);     #No.FUN-550030
 
      PRINT COLUMN g_c[31],g_x[25] CLIPPED,
            COLUMN g_c[35],cl_numfor(g_npq07_l,35,t_azi04),   #No.CHI-6A0004 
            COLUMN g_c[36],cl_numfor(g_npq07_r,36,t_azi04);   #No.CHI-6A0004 
 
    IF g_qcye > 0 THEN
#        PRINT COLUMN 92,g_x[24].substring(1,2),           #No.FUN-550030
#              COLUMN 95,cl_numfor(g_qcye,18,g_azi04)      #No.FUN-550030
 
        PRINT COLUMN g_c[41],g_x[24].substring(1,2),
              COLUMN g_c[42],cl_numfor(g_qcye,42,t_azi04)   #No.CHI-6A0004   
    ELSE
        IF g_qcye = 0 THEN
#           PRINT COLUMN 92,g_x[24].substring(5,6),         #No.FUN-550030
#                 COLUMN 95,cl_numfor(g_qcye,18,g_azi04)    #No.FUN-550030
 
            PRINT COLUMN g_c[41],g_x[24].substring(5,6),
                  COLUMN g_c[42],cl_numfor(g_qcye,42,t_azi04)  #No.CHI-6A0004  
       ELSE
#           PRINT COLUMN 92,g_x[24].substring(3,4),         #No.FUN-550030
#                 COLUMN 95,cl_numfor(g_qcye*-1,18,g_azi04) #No.FUN-550030
 
            PRINT COLUMN g_c[41],g_x[24].substring(3,4),
                  COLUMN g_c[42],cl_numfor(g_qcye*-1,42,t_azi04)    #No.CHI-6A0004 
#NO.FUN540057--end
        END IF
     END IF
# NO.FUN-670107 ---end---
 
   ON LAST ROW
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE SKIP 2 LINE
      END IF
 
END REPORT
 
REPORT gapr910_rep1(sr)
   DEFINE l_last_sw LIKE type_file.chr1,    #NO FUN-690009 VARCHAR(1)
          sr        RECORD
                        npp01    LIKE npp_file.npp01,
                        npp02    LIKE npp_file.npp02,
                        npq03    LIKE npq_file.npq03,
                        aag02    LIKE aag_file.aag02,
                        npq06    LIKE npq_file.npq06,
                        npq07f   LIKE npq_file.npq07f,
                        npq07    LIKE npq_file.npq07,
                        npq21    LIKE npq_file.npq21,
                        npq22    LIKE occ_file.occ18,
                        npq24    LIKE npq_file.npq24,
                        apa09    LIKE apa_file.apa09,
                        apa08    LIKE apa_file.apa08,
                        qcyef    LIKE npq_file.npq07,
                        qcye     LIKE npq_file.npq07
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.npq21,sr.npq22,sr.npq03,sr.npp02,sr.npp01,sr.npq06
  FORMAT
   PAGE HEADER
# NO.FUN-670107 --start--
#      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
       PRINT COLUMN(g_len-FGL_WIDTH(g_company CLIPPED))/2+1,g_company CLIPPED 
#    IF g_towhom IS NULL OR g_towhom = ' '
#         THEN PRINT '';
#         ELSE PRINT 'TO:',g_towhom;
#      END IF
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
     
       LET g_pageno = g_pageno + 1
       LET pageno_total = PAGENO USING '<<<',"/pageno"
       PRINT g_head CLIPPED,pageno_total
 
#     PRINT (g_len-FGL_WIDTH(g_x[1] CLIPPED))/2 SPACES,g_x[1]
      PRINT COLUMN (g_len-FGL_WIDTH(g_x[1] CLIPPED))/2+1,g_x[1]
 
      PRINT ' '
 
#      LET g_pageno = g_pageno + 1
      PRINT COLUMN 01,g_x[11] CLIPPED,
            COLUMN 10,sr.npq21 CLIPPED,' ',sr.npq22 CLIPPED
      PRINT COLUMN 01,g_x[12] CLIPPED,
            COLUMN 10,sr.aag02 CLIPPED,'(',sr.npq03 CLIPPED,')'
#      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
       PRINT COLUMN 01,g_x[14] CLIPPED,tm.bdate,'-',tm.edate,
             COLUMN 38,g_x[13] CLIPPED,g_aza17 CLIPPED,
             COLUMN 50,g_x[26] CLIPPED,tm.o
#            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT g_dash
# NO.FUN-670107 ---end---
# NO.FUN-670107 --start--
##No.FUN540057--begin
#      PRINT COLUMN 53,g_x[18] CLIPPED,
#            COLUMN 91,g_x[19] CLIPPED,
#            COLUMN 133,g_x[20] CLIPPED
#      PRINT '                                                   ',
#            ' ------------------------------------- ',
#            '-------------------------------------      ',
#            '-------------------------------------'
#      PRINT COLUMN  1,g_x[15] CLIPPED,
#            COLUMN 53,g_x[21] CLIPPED,
#            COLUMN 91,g_x[21] CLIPPED,
#            COLUMN 129,g_x[22] CLIPPED,
#            COLUMN 134,g_x[21] CLIPPED
#      PRINT '-------- ---------------- -------- ---------------- ',
#            '------------------ ------------------ ------------------ ',
#            '------------------  --  ------------------ ------------------'
##No.FUN540057--end
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41],g_x[42],g_x[43],g_x[44]
      PRINT g_dash1
# NO.FUN-670107 ---end--- 
 
    LET l_last_sw ='n'
 
   BEFORE GROUP OF sr.npq21
     SKIP TO TOP OF PAGE
     LET g_qcyef = sr.qcyef
     LET g_qcye  = sr.qcye
     LET g_npq07f_l = 0
     LET g_npq07f_r = 0
     LET g_npq07_l = 0
     LET g_npq07_r = 0
#     PRINT COLUMN 1,g_x[23] CLIPPED; # NO.FUN-670107
     PRINT COLUMN g_c[31],g_x[23] CLIPPED; #NO.FUN-670107
    IF sr.qcyef > 0 THEN
# NO.FUN-670107 --start--
##No.FUN540057--begin
#        PRINT COLUMN 130,g_x[24].substring(1,2),
#              COLUMN 133,cl_numfor(sr.qcyef,18,g_azi04),
#              COLUMN 152,cl_numfor(sr.qcye,18,g_azi04)
 
         PRINT COLUMN g_c[41],g_x[24].substring(1,2),
               COLUMN g_c[43],cl_numfor(sr.qcyef,43,g_azi04),
               COLUMN g_c[44],cl_numfor(sr.qcye,44,g_azi04)  
    ELSE
        IF sr.qcyef = 0 THEN
#           PRINT COLUMN 130,g_x[24].substring(5,6),
#                 COLUMN 133,cl_numfor(sr.qcyef,18,g_azi04),
#                 COLUMN 152,cl_numfor(sr.qcye,18,g_azi04)
 
            PRINT COLUMN g_c[41],g_x[24].substring(5,6),
                  COLUMN g_c[43],cl_numfor(sr.qcyef,43,t_azi04),      #No.CHI-6A0004 
                  COLUMN g_c[44],cl_numfor(sr.qcye,44,t_azi04)       #No.CHI-6A0004 
 
       ELSE
#           PRINT COLUMN 130,g_x[24].substring(3,4),
#                 COLUMN 133,cl_numfor(sr.qcyef*-1,18,g_azi04),
#                 COLUMN 152,cl_numfor(sr.qcye*-1,18,g_azi04)
 
             PRINT COLUMN g_c[41],g_x[24].substring(3,4),
                   COLUMN g_c[43],cl_numfor(sr.qcyef*-1,43,t_azi04),    #No.CHI-6A0004 
                   COLUMN g_c[44],cl_numfor(sr.qcye*-1,44,t_azi04)       #No.CHI-6A0004 
 
# NO.FUN-670107 ---end---
       END IF
     END IF
# NO.FUN-670107 
   ON EVERY ROW
     IF sr.npq07f <> 0 OR sr.npq07 <> 0 THEN
#        PRINT COLUMN   1,sr.npp02,
#              COLUMN  10,sr.npp01 CLIPPED,
#              COLUMN  27,sr.apa09,
#              COLUMN  36,sr.apa08;
 
         PRINT COLUMN g_c[31],sr.npp02,
               COLUMN g_c[32],sr.npp01 CLIPPED,
               COLUMN g_c[33],sr.apa09,
               COLUMN g_c[34],sr.apa08; 
   
    IF sr.npq06 = '1' THEN
 
#          PRINT COLUMN  53,cl_numfor(sr.npq07f,18,g_azi04),
#                COLUMN  72,cl_numfor(sr.npq07,18,g_azi04);
            
           PRINT COLUMN g_c[37],cl_numfor(sr.npq07f,37,t_azi04),    #No.CHI-6A0004 
                 COLUMN g_c[38],cl_numfor(sr.npq07,38,t_azi04);      #No.CHI-6A0004 
 
          LET g_qcyef = g_qcyef + sr.npq07f
           LET g_qcye  = g_qcye  + sr.npq07
           LET g_npq07f_l = g_npq07f_l + sr.npq07f
           LET g_npq07_l  = g_npq07_l  + sr.npq07
        ELSE
#           PRINT COLUMN  91,cl_numfor(sr.npq07f,18,g_azi04),
#                 COLUMN 110,cl_numfor(sr.npq07,18,g_azi04);
               
            PRINT COLUMN g_c[39],cl_numfor(sr.npq07f,39,t_azi04),     #No.CHI-6A0004 
                  COLUMN g_c[40],cl_numfor(sr.npq07,40,t_azi04);      #No.CHI-6A0004  
 
          LET g_qcyef = g_qcyef - sr.npq07f
           LET g_qcye  = g_qcye - sr.npq07
           LET g_npq07f_r = g_npq07f_r + sr.npq07f
           LET g_npq07_r  = g_npq07_r  + sr.npq07
        END IF
        IF g_qcyef > 0 THEN
#           PRINT COLUMN 130,g_x[24].substring(1,2),
#                 COLUMN 133,cl_numfor(g_qcyef,18,g_azi04),
#                 COLUMN 152,cl_numfor(g_qcye,18,g_azi04)
            
            PRINT COLUMN g_c[41],g_x[24].substring(1,2),
                  COLUMN g_c[43],cl_numfor(g_qcyef,43,t_azi04),
                  COLUMN g_c[44],cl_numfor(g_qcye,44,t_azi04)    #No.CHI-6A0004  
       ELSE
           IF g_qcyef = 0 THEN
#              PRINT COLUMN 130,g_x[24].substring(5,6),
#                    COLUMN 133,cl_numfor(g_qcyef,18,g_azi04),
#                    COLUMN 152,cl_numfor(g_qcye,18,g_azi04)
 
               
           PRINT COLUMN g_c[41],g_x[24].substring(5,6),
                 COLUMN g_c[43],cl_numfor(g_qcyef,43,t_azi04),   #No.CHI-6A0004 
                 COLUMN g_c[44],cl_numfor(g_qcye,44,t_azi04)     #No.CHI-6A0004 
 
          ELSE
#              PRINT COLUMN 130,g_x[24].substring(3,4),
#                    COLUMN 133,cl_numfor(g_qcyef*-1,18,g_azi04),
#                    COLUMN 152,cl_numfor(g_qcye*-1,18,g_azi04)
 
               
           PRINT COLUMN g_c[41],g_x[24].substring(3,4),
                 COLUMN g_c[43],cl_numfor(g_qcyef*-1,43,t_azi04),   #No.CHI-6A0004 
                 COLUMN g_c[44],cl_numfor(g_qcye*-1,44,t_azi04)     #No.CHI-6A0004 
 
          END IF
        END IF
     END IF
 
   AFTER GROUP OF sr.npq21
#     PRINT COLUMN 1,g_x[25] CLIPPED,
#           COLUMN 53,cl_numfor(g_npq07f_l,18,g_azi04),
#           COLUMN 72,cl_numfor(g_npq07_l,18,g_azi04),
#           COLUMN 87,cl_numfor(g_npq07f_r,18,g_azi04),
#           COLUMN 107,cl_numfor(g_npq07_r,18,g_azi04);
 
      PRINT COLUMN g_c[31],g_x[25] CLIPPED,
            COLUMN g_c[37],cl_numfor(g_npq07f_l,37,t_azi04),   #No.CHI-6A0004 
            COLUMN g_c[38],cl_numfor(g_npq07_l,38,t_azi04),    #No.CHI-6A0004 
            COLUMN g_c[39],cl_numfor(g_npq07f_r,39,t_azi04),   #No.CHI-6A0004 
            COLUMN g_c[40],cl_numfor(g_npq07_r,40,t_azi04);    #No.CHI-6A0004 
    IF g_qcyef > 0 THEN
#        PRINT COLUMN 130,g_x[24].substring(1,2),
#              COLUMN 133,cl_numfor(g_qcyef,18,g_azi04),
#              COLUMN 152,cl_numfor(g_qcye,18,g_azi04)
 
         PRINT COLUMN g_c[41],g_x[24].substring(1,2),
               COLUMN g_c[43],cl_numfor(g_qcyef,43,t_azi04),   #No.CHI-6A0004 
               COLUMN g_c[44],cl_numfor(g_qcye,44,t_azi04)     #No.CHI-6A0004 
    ELSE
        IF g_qcyef = 0 THEN
#           PRINT COLUMN 130,g_x[24].substring(5,6),
#                 COLUMN 133,cl_numfor(g_qcyef,18,g_azi04),
#                 COLUMN 152,cl_numfor(g_qcye,18,g_azi04)
 
            
           PRINT COLUMN g_c[41],g_x[24].substring(5,6),
                 COLUMN g_c[43],cl_numfor(g_qcyef,43,t_azi04),   #No.CHI-6A0004 
                 COLUMN g_c[44],cl_numfor(g_qcye,44,t_azi04)     #No.CHI-6A0004 
 
       ELSE
#           PRINT COLUMN 130,g_x[24].substring(3,4),
#                 COLUMN 133,cl_numfor(g_qcyef*-1,18,g_azi04),
#                 COLUMN 152,cl_numfor(g_qcye*-1,18,g_azi04)
  
            
           PRINT COLUMN g_c[41],g_x[24].substring(3,4),
                 COLUMN g_c[43],cl_numfor(g_qcyef*-1,43,t_azi04),   #No.CHI-6A0004 
                 COLUMN g_c[44],cl_numfor(g_qcye*-1,44,t_azi04)     #No.CHI-6A0004 
 
       END IF
     END IF
#No.FUN540057--end
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         PRINT g_dash[1,g_len]
         #TQC-630166
	 #     IF tm.wc[001,070] > ' ' THEN                      # for 80
         #        PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
         #     IF tm.wc[071,140] > ' ' THEN
         #        PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
         #     IF tm.wc[141,210] > ' ' THEN
         #        PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
         #     IF tm.wc[211,280] > ' ' THEN
         #        PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
	  CALL cl_prt_pos_wc(tm.wc)
         #END TQC-630166
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE SKIP 2 LINE
      END IF
 
END REPORT
 
FUNCTION r910_apa(p_i,p_apa01)
  DEFINE  l_apa09   LIKE apa_file.apa09,
          l_apa08   LIKE apa_file.apa08,
          l_apa41   LIKE apa_file.apa41,
          l_apf41   LIKE apf_file.apf41,
          p_apa01   LIKE apa_file.apa01,
          p_i       LIKE type_file.num5,     #NO FUN-690009 SMALLINT
          l_oox00   LIKE oox_file.oox00,     #NO FUN-690009 VARCHAR(02)
          l_oox01   LIKE oox_file.oox01,     #NO FUN-690009 SMALLINT
          l_oox02   LIKE type_file.num5,     #NO FUN-690009 SMALLINT
          l_i       LIKE type_file.num5,     #NO FUN-690009 SMALLINT
          l_flag    LIKE type_file.chr1      #NO FUN-690009 VARCHAR(1)
 
   LET l_flag = 'Y'   #it is valid
   SELECT apa09,apa08,apa41 INTO l_apa09,l_apa08,l_apa41
     FROM apa_file
    WHERE apa01 = p_apa01
      AND apaacti = 'Y'
   IF SQLCA.sqlcode THEN
      SELECT apf41 INTO l_apf41 FROM apf_file
       WHERE apf01 = p_apa01
         AND apfacti = 'Y'
      IF SQLCA.sqlcode THEN
         LET l_oox00 = p_apa01[1,2]
         LET l_oox01 = p_apa01[3,6] USING "&&&&"
         LET l_oox02 = p_apa01[7,8] USING "&&"
         SELECT COUNT(*) INTO l_i FROM oox_file
          WHERE oox00 = l_oox00
            AND oox01 = l_oox01
            AND oox02 = l_oox02
         IF l_i = 0 OR tm.d = '2' THEN
            LET l_flag = 'N'
         END IF
      ELSE
         IF p_i = 0 THEN           #before period
            IF l_apf41 <> 'Y' THEN
               LET l_flag = 'N'
            END IF
         ELSE                      #middle period
            IF tm.d <> '3' THEN
               IF l_apf41 <> g_d THEN
                  LET l_flag = 'N' #it is unvalid
               END IF
            END IF
         END IF
      END IF
   ELSE
      IF p_i = 0 THEN
         IF l_apa41 <> 'Y' THEN
            LET l_flag = 'N'
         END IF
       ELSE
         IF tm.d <> '3' THEN
            IF l_apa41 <> g_d THEN
               LET l_flag = 'N'
            END IF
         END IF
      END IF
   END IF
   RETURN l_flag,l_apa09,l_apa08
END FUNCTION
#Patch....NO.TQC-610037 <001> #
