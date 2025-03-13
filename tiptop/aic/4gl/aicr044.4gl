# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aicr044.4gl
# Descriptions...: 委外加工單
# Date & Author..: No.FUN-7B0027 07/12/05 By lala
# Modify.........: No.FUN-7B0027
# MOdify.........: No.FUN-830068
# Modify.........: No.TQC-950072 09/05/14 BY ve007 含有sfbiicd09 的條件拿掉
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60027 10/06/07 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-B60074 11/06/24 By xianghui 更改報表列印欄位
# Modify.........: No.FUN-B80083 11/08/08 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
		wc  	STRING,
                a       LIKE type_file.chr1,
    	        b       LIKE type_file.chr1,
                c       LIKE type_file.num5,
                more    LIKE type_file.chr1
              END RECORD
   DEFINE l_table STRING
   DEFINE g_str   STRING
   DEFINE g_sql   STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("aic")) THEN
      EXIT PROGRAM
   END IF
  
   IF NOT s_industry("icd") THEN                                                
      CALL cl_err('','aic-999',1) EXIT PROGRAM                                  
   END IF
 
   #CALL cl_used(g_prog,g_time,1)RETURNING g_time #FUN-BB0047 mark

   #FUN-B60074-mark-str--
   #LET g_sql="pmn02.pmn_file.pmn02,",
   #          "pmm09.pmm_file.pmm09,",
   #          "pmm01.pmm_file.pmm01,",
   #          "pmm04.pmm_file.pmm04,",
   #          "sfa03.sfa_file.sfa03,",
   #          "pmn04.pmn_file.pmn04,",
   #          "pmniicd15.pmni_file.pmniicd15,",
   #          "sfa06.sfa_file.sfa06,",
   #          "oeb15.oeb_file.oeb15,",
   #          "pmc03.pmc_file.pmc03,",
   #          "pmn33.pmn_file.pmn33,",
   #          "ima021.ima_file.ima021,",
   #          "sfaiicd03.sfai_file.sfaiicd03,",
   #          "img10.img_file.img10,",
   #          "sfb08.sfb_file.sfb08,",
   #          "oeb917.oeb_file.oeb917,",
   #          "pmniicd01.pmni_file.pmniicd01,",
   #          "oao06.oao_file.oao06,",
   #          "oebiicd03.oebi_file.oebiicd03,",
   #          "pmniicd03.pmni_file.pmniicd03"
   #FUN-B60074-mark-end--
   #FUN-B60074-add-str--
   LET g_sql="sfe28.sfe_file.sfe28,",
             "sfe07.sfe_file.sfe07,",
             "sfe10.sfe_file.sfe10,",
             "sfb05.sfb_file.sfb05,",
             "pmn04.pmn_file.pmn04,",
             "pmn56.pmn_file.pmn56,",
             "pmniicd11.pmni_file.pmniicd11,",
             "pmn82.pmn_file.pmn82,",
             "pmn85.pmn_file.pmn85,",
             "pmn33.pmn_file.pmn33,",
             "l_method.type_file.chr10,",
             "l_foot.type_file.chr10, ",
             "l_part.type_file.chr10 "
   #FUN-B60074-add-end--
   
   LET l_table = cl_prt_temptable('aicr044',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED, l_table CLIPPED,
             #" VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"  #FUN-B60074
              " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)"                        #FUN-B60074

   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1)RETURNING g_time #FUN-BB0047 add
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r044_tm(0,0)
      ELSE CALL aicr044()
   END IF
   CALL cl_used(g_prog,g_time,2)RETURNING g_time
END MAIN
 
FUNCTION r044_tm(p_row,p_col)
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01,
          p_row,p_col	LIKE type_file.num5,
          l_cmd         LIKE type_file.chr1000
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW r044_w AT p_row,p_col WITH FORM "aic/42f/aicr044"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmm01,pmm04
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r044_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80083    ADD
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more
   INPUT BY NAME tm.more WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()
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
      LET INT_FLAG = 0 CLOSE WINDOW r044_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80083    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
       WHERE zz01='aicr044'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aicr044','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'"
         CALL cl_cmdat('aicr044',g_time,l_cmd)
      END IF
      CLOSE WINDOW r044_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80083    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aicr044()
   ERROR ""
END WHILE
   CLOSE WINDOW r044_w
END FUNCTION
 
FUNCTION aicr044()
   DEFINE l_sql  STRING,
          l_name LIKE type_file.chr20,
          l_time LIKE type_file.chr8,
          l_za05 LIKE za_file.za05,
          sr     RECORD
                 #FUN-B60074-mark-str--
                 #pmm01    LIKE pmm_file.pmm01,
                 #pmm09    LIKE pmm_file.pmm09,
                 #pmm22    LIKE pmm_file.pmm22,
                 #pmn02    LIKE pmn_file.pmn02,
                 #pmn04    LIKE pmn_file.pmn04,
                 #pmn041   LIKE pmn_file.pmn041,
                 #pmn20    LIKE pmn_file.pmn20,
                 #pmn31    LIKE pmn_file.pmn31,
                 #pmm04    LIKE pmm_file.pmm04,
                 #pmn33    LIKE pmn_file.pmn33,
                 #pmniicd16 LIKE pmni_file.pmniicd16,
                 #pmniicd01 LIKE pmni_file.pmniicd01,
                 #pmniicd02 LIKE pmni_file.pmniicd02,
                 #pmniicd15 LIKE pmni_file.pmniicd15,
                 #pmn41    LIKE pmn_file.pmn41,
                 #pmniicd03 LIKE pmni_file.pmniicd03,
                 #sfb08     LIKE sfb_file.sfb08
                 #FUN-B60074-mark-end--
                 #FUN-B60074-add-str--
                 sfe28     LIKE sfe_file.sfe28,
                 sfe07     LIKE sfe_file.sfe07,
                 sfe10     LIKE sfe_file.sfe10,   
                 sfb05     LIKE sfb_file.sfb05,
                 pmn04     LIKE pmn_file.pmn04,
                 pmn56     LIKE pmn_file.pmn56,
                 pmniicd11 LIKE pmni_file.pmniicd11,
                 pmn82     LIKE pmn_file.pmn82,
                 pmn85     LIKE pmn_file.pmn85,
                 pmn33     LIKE pmn_file.pmn33,
                 l_method  LIKE type_file.chr10,
                 l_foot    LIKE type_file.chr10,
                 l_part    LIKE type_file.chr10
                 #FUN-B60074-add-end--
                 END RECORD
#FUN-B60074-mark-str-- 
##No.FUN-7B0027--start--
#   DEFINE l_username      LIKE gen_file.gen02
#   DEFINE l_sfa03         LIKE sfa_file.sfa03
#   DEFINE l_sfaiicd03     LIKE sfai_file.sfaiicd03
#   DEFINE l_sfb08         LIKE sfb_file.sfb08
#   DEFINE l_oeb15         LIKE oeb_file.oeb15
#   DEFINE l_oeb917        LIKE oeb_file.oeb917
#   DEFINE l_oebiicd03     LIKE oebi_file.oebiicd03
#   DEFINE l_orderqty      LIKE oeb_file.oeb917
#   DEFINE l_oao06         LIKE oao_file.oao06
#   DEFINE l_img10         LIKE img_file.img10
#   DEFINE l_sfa06         LIKE sfa_file.sfa06
#   DEFINE l_ima021        LIKE ima_file.ima021
#   DEFINE l_pmc03         LIKE pmc_file.pmc03
##No.FUN-7B0027---end---
#FUN-B60074-mark-end--
   
     CALL cl_del_data(l_table)
    # CALL cl_used(g_prog,l_time,1) RETURNING l_time  #FUN-B80083 MARK
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80083    ADD
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN
     #LET tm.wc = tm.wc clipped," AND pmmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN
     #        LET tm.wc = tm.wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN
     #        LET tm.wc = tm.wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('user', 'grup')
     #End:FUN-980030
     #FUN-B60074-mark-str--
     #   LET l_sql = "SELECT ",
     #            " pmm01,pmm09,pmm22,pmn02,pmn04,pmn041,pmn20,pmn31",
	 # 	 ",pmm04,pmn33,pmniicd16,pmniicd01,pmniicd02,pmniicd15,pmn41",
	 #	 ",pmniicd03,sfb08 ",
     #            " FROM pmm_file,pmn_file,sfb_file,pmni_file,sfbi_file ",
     #            " WHERE pmm01 = pmn01 and pmm01=sfb01",
     #            " AND pmn01 = pmni01 ",
     #            " AND pmn02 = pmni02 ",
     #            " AND sfb01 = sfbi01 ",
     #            " AND pmn011 = 'SUB' ",
	 #	 " AND sfb02=7 ",
	 #	# " AND sfbiicd09 not in ('30','40','50','51')",               #NO.TQC-950072
     #            " AND pmn16 IN ('2') AND ",tm.wc
     #FUN-B60074-mark-end--
     #FUN-B60074-add-str--
     LET l_sql = " SELECT sfe28,sfe07,sfe10,sfb05,pmn04,pmn56,pmniicd11,",
		         " pmn82,pmn85,pmn33,'','','' ",
                 " FROM pmm_file,pmn_file,sfe_file,pmni_file,sfb_file ",
                 " WHERE pmm01=pmn01 AND sfe01=sfb01 AND pmn01=pmni01 AND sfe01=pmn41 AND pmn02=pmni02",
                 " AND pmn011 = 'SUB' ",
                 " AND sfb02=7 ",
                 " AND pmn16 IN ('2') AND ",tm.wc," ORDER BY sfe28"
     #FUN-B60074-add-end--

     PREPARE r044_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80083    ADD
        EXIT PROGRAM
     END IF
     DECLARE r044_curs1 CURSOR FOR r044_prepare1
 
     FOREACH r044_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
     #FUN-B60074-mark-str--
     # SELECT ima021 
     #   INTO l_ima021 FROM ima_file 
     #  WHERE ima01=sr.pmn04
     # IF SQLCA.sqlcode THEN
     #     LET l_ima021 = NULL
     # END IF
     # SELECT pmc03 
     #   INTO l_pmc03 FROM pmc_file 
     #  WHERE pmc01=sr.pmm09
     # IF SQLCA.sqlcode THEN
     #     LET l_pmc03 = NULL
     # END IF
     # 
     # SELECT oeb15,oeb917,oebiicd03 
     #   INTO l_oeb15,l_oeb917,l_oebiicd03 FROM oeb_file,oebi_file 
     # WHERE oeb01=sr.pmniicd01 and oeb03=sr.pmniicd02 
     #   and oebi01=sr.pmniicd01 and oebi03=sr.pmniicd02   
     # IF SQLCA.sqlcode THEN
	 #LET l_orderqty=0
     # ELSE
	 #LET l_orderqty=l_oeb917+(l_oeb917*l_oebiicd03/100)
     # END IF
     # SELECT oao06 
     #   INTO l_oao06 FROM oao_file 
     #  WHERE oao01=sr.pmniicd01 and oao03=sr.pmniicd02
     # IF SQLCA.sqlcode THEN LET l_oao06 = NULL END IF
     # SELECT sfa03,sfa06,sfaiicd03 
     #   INTO l_sfa03,l_sfa06,l_sfaiicd03 FROM sfa_file,sfai_file
     #  WHERE sfa01=sr.pmm01 and sfai03=sr.pmn04
     #    AND sfa012 = sfai012 AND afa013 = sfai013    #FUN-A60027 add     
     # DECLARE tc_ime_cur1 CURSOR FOR
     # SELECT sum(img10) FROM img_file
     # WHERE img01 LIKE l_sfa03||'%' AND img04 LIKE l_sfaiicd03||'%'
     #   FOREACH tc_ime_cur1 INTO l_img10 END FOREACH
     #   EXECUTE insert_prep USING
     #      sr.pmn02,sr.pmm09,sr.pmm01,sr.pmm04,l_sfa03,sr.pmn04,sr.pmniicd15,
     #	    l_sfa06,l_oeb15,l_pmc03,sr.pmn33,l_ima021,l_sfaiicd03,l_img10,
     #      l_sfb08,l_orderqty,sr.pmniicd01,l_oao06,l_oebiicd03,sr.pmniicd03
     #FUN-B60074-mark-end--
     #FUN-B60074-add-str--
     LET sr.l_method = 'NA'
     LET sr.l_foot = 'NA'
     LET sr.l_part = 'NA'
     EXECUTE insert_prep USING
             sr.sfe28,sr.sfe07,sr.sfe10,sr.sfb05,sr.pmn04,sr.pmn56,
	         sr.pmniicd11,sr.pmn82,sr.pmn85,sr.pmn33,sr.l_method,sr.l_foot,sr.l_part
     #FUN-B60074-add-end--

     END FOREACH
     LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_wcchp(tm.wc,'pmm01,pmm04')
             RETURNING tm.wc
     LET g_str=tm.wc
     CALL cl_prt_cs3('aicr044','aicr044',g_sql,g_str)
     #CALL cl_used(g_prog,l_time,2) RETURNING l_time   #FUN-B80083 MARK
     #No.FUN-BB0047--mark--Begin---
     # CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80083    ADD
     #No.FUN-BB0047--mark--End-----
END FUNCTION
# Modify: No.FUN-7B0027
# Modify: No.FUN-830068
