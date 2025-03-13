# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: ammg200.4gl
# Desc/riptions..: 加工需求單列印
# Date & Author..: 00/12/14 By Chihming
# Modify.........: No.FUN-4C0099 05/02/02 By kim 報表轉XML功能
# Modify.........: No.FUN-550114 05/05/26 By echo 新增報表備註
# Modify.........: No.FUN-570174 05/07/18 By yoyo 項次欄位加大 
# Modify.........: No.TQC-5B0110 05/11/11 By CoCo 料號位置調整
# Modify.........: No.FUN-680100 06/08/28 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0087 06/11/16 By king 改正報表中有關錯誤
# Modify.........: No.TQC-6A0080 06/11/20 By xumin 報表標題居中
# Modify.........: No.FUN-730010 07/03/13 By chenl 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730113 07/04/02 By Nicole 增加CR參數
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50018 11/05/18 By xumm CR轉GRW
# Modify.........: No.FUN-B80065 11/08/05 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-B50018 11/08/11 By xumm 程式規範修改
# Modify.........: No:FUN-C40026 12/04/10 By xumm GR動態簽核
# Modify.........: No.FUN-C50008 12/05/15 By GR程式優化
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD		         	      # Print condition RECORD
       	    	wc      LIKE type_file.chr1000,       #No.FUN-680100 VARCHAR(600)#Where condition
                a       LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
    	        b    	LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
  		more	LIKE type_file.chr1           #No.FUN-680100 VARCHAR(1)
              END RECORD,
          g_zo          RECORD LIKE zo_file.*
DEFINE    g_i           LIKE type_file.num5           #count/index for any purpose        #No.FUN-680100 SMALLINT
#No.FUN-730010--begin--
DEFINE    l_table       STRING
DEFINE    g_sql         STRING
DEFINE    g_str         STRING
#No.FUN-730010--end--
###GENGRE###START
TYPE sr1_t RECORD
    mma01 LIKE mma_file.mma01,
    mma02 LIKE mma_file.mma02,
    mma03 LIKE mma_file.mma03,
    mma05 LIKE mma_file.mma05,
    mma051 LIKE mma_file.mma051,
    mma06 LIKE mma_file.mma06,
    mma07 LIKE mma_file.mma07,
    mma08 LIKE mma_file.mma08,
    mma09 LIKE mma_file.mma09,
    mma10 LIKE mma_file.mma10,
    mma11 LIKE mma_file.mma11,
    mma12 LIKE mma_file.mma12,
    mma14 LIKE mma_file.mma14,
    mma15 LIKE mma_file.mma15,
    mma16 LIKE mma_file.mma16,
    mma17 LIKE mma_file.mma17,
    mma19 LIKE mma_file.mma19,
    mmaacti LIKE mma_file.mmaacti,
    mmb02 LIKE mmb_file.mmb02,
    mmb05 LIKE mmb_file.mmb05,
    mmb06 LIKE mmb_file.mmb06,
    mmb07 LIKE mmb_file.mmb07,
    mmb08 LIKE mmb_file.mmb08,
    mmb09 LIKE mmb_file.mmb09,
    mmb10 LIKE mmb_file.mmb10,
    mmb11 LIKE mmb_file.mmb11,
    mmb12 LIKE mmb_file.mmb12,
    mmb121 LIKE mmb_file.mmb121,
    mmb15 LIKE mmb_file.mmb15,
    mmb19 LIKE mmb_file.mmb19,
    mmbacti LIKE mmb_file.mmbacti,
    mmc02 LIKE mmc_file.mmc02,
    pmc03 LIKE pmc_file.pmc03,
    gem02 LIKE gem_file.gem02,
    mmi02 LIKE mmi_file.mmi02,
    ima02 LIKE ima_file.ima02,
    ima021 LIKE ima_file.ima021,
    l_mfghour LIKE mmb_file.mmb09,    #FUN-B50018
    l_pmcfare LIKE mmb_file.mmb09,    #FUN-B50018
    l_mmb11_mmb09_mmb19 LIKE mmb_file.mmb09,    #FUN-B50018
    azi03 LIKE azi_file.azi03,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05,        #FUN-C40026 add,
#FUN-C40026----add---str---
    sign_type LIKE type_file.chr1,
    sign_img  LIKE type_file.blob,
    sign_show LIKE type_file.chr1,
    sign_str  LIKE type_file.chr1000
#FUN-C40026----add---end---
END RECORD
###GENGRE###END

MAIN
   OPTIONS
          INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMM")) THEN
      EXIT PROGRAM
   END IF
 
  #No.FUN-730010--begin--
   LET g_sql = "mma01.mma_file.mma01,",
               "mma02.mma_file.mma02,",
               "mma03.mma_file.mma03,",
               "mma05.mma_file.mma05,",
               "mma051.mma_file.mma051,",
               "mma06.mma_file.mma06,",
               "mma07.mma_file.mma07,",
               "mma08.mma_file.mma08,",
               "mma09.mma_file.mma09,",
               "mma10.mma_file.mma10,",
               "mma11.mma_file.mma11,",
               "mma12.mma_file.mma12,",
               "mma14.mma_file.mma14,",
               "mma15.mma_file.mma15,",
               "mma16.mma_file.mma16,",
               "mma17.mma_file.mma17,",
               "mma19.mma_file.mma19,",
               "mmaacti.mma_file.mmaacti,",
               "mmb02.mmb_file.mmb02,",
               "mmb05.mmb_file.mmb05,",
               "mmb06.mmb_file.mmb06,",
               "mmb07.mmb_file.mmb07,",
               "mmb08.mmb_file.mmb08,",
               "mmb09.mmb_file.mmb09,",
               "mmb10.mmb_file.mmb10,",
               "mmb11.mmb_file.mmb11,",
               "mmb12.mmb_file.mmb12,",
               "mmb121.mmb_file.mmb121,",
               "mmb15.mmb_file.mmb15,",
               "mmb19.mmb_file.mmb19,",
               "mmbacti.mmb_file.mmbacti,",
               "mmc02.mmc_file.mmc02,",
               "pmc03.pmc_file.pmc03,",
               "gem02.gem_file.gem02,",
               "mmi02.mmi_file.mmi02,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "l_mfghour.mmb_file.mmb09,",       #FUN-B50018 ADD
               "l_pmcfare.mmb_file.mmb09,",       #FUN-B50018 ADD
               "l_mmb11_mmb09_mmb19.mmb_file.mmb09,",       #FUN-B50018 ADD
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",           #FUN-C40026 add 2,
              #FUN-C40026----add---str----
              "sign_type.type_file.chr1,",  #簽核方式
              "sign_img.type_file.blob,",   #簽核圖檔
              "sign_show.type_file.chr1,",
              "sign_str.type_file.chr1000"
              #FUN-C40026----add---end----
 
   LET l_table = cl_prt_temptable('ammg200',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?, ",
               "        ?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?)"        #FUN-B50018 ADD 3?     #FUN-C40026 add 4?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM
   END IF
  #No.FUN-730010--end--
 
   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80065--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL g200_tm(0,0)		# Input print condition
      ELSE CALL ammg200()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
   CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
END MAIN
 
FUNCTION g200_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,          #No.FUN-680100 SMALLINT
          l_cmd		LIKE type_file.chr1000        #No.FUN-680100 VARCHAR(600)
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 8 LET p_col = 17
   ELSE LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW g200_w AT p_row,p_col
        WITH FORM "amm/42f/ammg200" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a    = 'N'
   LET tm.b    = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON mma01,mma15,mma07 
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('mmauser', 'mmagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW g200_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
      CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF cl_null(tm.a) THEN LET tm.a='N' END IF          
         IF cl_null(tm.a) OR tm.a NOT MATCHES "[YN]" THEN
            NEXT FIELD a
         END IF
      AFTER FIELD b
         IF cl_null(tm.b) THEN LET tm.b='N' END IF          
         IF cl_null(tm.b) OR tm.b NOT MATCHES "[YN]" THEN
            NEXT FIELD b
         END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
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
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW g200_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
      CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='ammg200'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('ammg200','9031',1)
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
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('ammg200',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW g200_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
      CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL ammg200()
   ERROR ""
END WHILE
   CLOSE WINDOW g200_w
END FUNCTION
 
FUNCTION ammg200()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680100 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0076
          l_sql 	STRING,		# RDSQL STATEMENT        #No.FUN-680100
          l_chr		LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
          l_za05	LIKE type_file.chr1000,       #No.FUN-680100 VARCHAR(40)
          sr   RECORD 
                     mma01     LIKE mma_file.mma01,  
                     mma02     LIKE mma_file.mma02,  
                     mma03     LIKE mma_file.mma03,  
                     mma05     LIKE mma_file.mma05,  
                     mma051    LIKE mma_file.mma051,
                     mma06     LIKE mma_file.mma06,  
                     mma07     LIKE mma_file.mma07,  
                     mma08     LIKE mma_file.mma08,  
                     mma09     LIKE mma_file.mma09,  
                     mma10     LIKE mma_file.mma10,  
                     mma11     LIKE mma_file.mma11,  
                     mma12     LIKE mma_file.mma12, 
                     mma14     LIKE mma_file.mma14, 
                     mma15     LIKE mma_file.mma15,  
                     mma16     LIKE mma_file.mma16, 
                     mma17     LIKE mma_file.mma17, 
                     mma19     LIKE mma_file.mma19, 
                     mmaacti   LIKE mma_file.mmaacti,
                     mmb02     LIKE mmb_file.mmb02,  
                     mmb05     LIKE mmb_file.mmb05, 
                     mmb06     LIKE mmb_file.mmb06, 
                     mmb07     LIKE mmb_file.mmb07, 
                     mmb08     LIKE mmb_file.mmb08,
                     mmb09     LIKE mmb_file.mmb09,
                     mmb10     LIKE mmb_file.mmb10, 
                     mmb11     LIKE mmb_file.mmb11, 
                     mmb12     LIKE mmb_file.mmb12, 
                     mmb121    LIKE mmb_file.mmb121,
                     mmb15     LIKE mmb_file.mmb15, 
                     mmb19     LIKE mmb_file.mmb19,
                     mmbacti   LIKE mmb_file.mmbacti, 
                     mmc02     LIKE mmc_file.mmc02,  
                     pmc03     LIKE pmc_file.pmc03, 
                     gem02     LIKE gem_file.gem02, 
                     mmi02     LIKE mmi_file.mmi02, 
                     ima02     LIKE ima_file.ima02,
                     ima021    LIKE ima_file.ima021,
                     l_mfghour LIKE mmb_file.mmb09,    #FUN-B50018
                     l_pmcfare LIKE mmb_file.mmb09,    #FUN-B50018
                     l_mmb11_mmb09_mmb19 LIKE mmb_file.mmb09    #FUN-B50018
        END RECORD
DEFINE  l_azi03      LIKE azi_file.azi03      #No.FUN-730010 
DEFINE  l_azi04      LIKE azi_file.azi04      #No.FUN-730010  
DEFINE  l_azi05      LIKE azi_file.azi05      #No.FUN-730010 
DEFINE  l_img_blob   LIKE type_file.blob      #FUN-C40026 add    
 
     #No.FUN-B80065--mark--Begin--- 
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
     #No.FUN-B80065--mark--End-----
     LOCATE l_img_blob      IN MEMORY            #FUN-C40026 add
     CALL cl_del_data(l_table)                                   #No.FUN-730010 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='ammg200'   #No.FUN-730010  
     SELECT azi03,azi04,azi05 INTO l_azi03,l_azi04,l_azi05 FROM azi_file #No.FUN-730010 
      WHERE azi01=g_aza17                                                #No.FUN-730010    
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET l_sql = "SELECT mma01,mma02,mma03,mma05,mma051,mma06,mma07,mma08,", 
                 " mma09,mma10,mma11,mma12,mma14,mma15,mma16,mma17,",
                 " mma19,mmaacti,mmb02,mmb05,mmb06,mmb07,",
                 " mmb08,mmb09,mmb10,mmb11,mmb12,mmb121,mmb15,mmb19,mmbacti,",
                 #" '','','','','','','','','' ",   #FUN-C50008 mark--
                 "mmc02,pmc03,gem02,mmi02,ima02,ima021,'','',''",#FUN-C50008 Add
                 #" FROM mma_file,mmb_file ",       #FUN-C50008 mark--
              #FUN-C50008--add--str
                 "  FROM mma_file LEFT OUTER JOIN gem_file ON (gem01=mma15) ",
                 "                LEFT OUTER JOIN mmi_file ON (mmi01=mma14) ",
                 "                LEFT OUTER JOIN ima_file ON (ima01=mma05),",
                 "       mmb_file LEFT OUTER JOIN mmc_file ON (mmc01=mmb05) ",              
                 "                LEFT OUTER JOIN pmc_file ON (pmc01=mmb08) ", 
              #FUN-C50008--add--end
                 " WHERE mma01 = mmb01 ",
                 "   AND mma17 <> 'X' ",
                 "   AND ",tm.wc CLIPPED
 
     IF tm.a='N' THEN LET l_sql=l_sql CLIPPED," AND mma17='Y' " END IF
     IF tm.b='N' THEN LET l_sql=l_sql CLIPPED," AND mmbacti='Y' " END IF
     
     PREPARE g200_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
        CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
        EXIT PROGRAM 
     END IF
     DECLARE g200_cs1 CURSOR FOR g200_prepare1
     SELECT * INTO g_zo.* FROM zo_file WHERE zo01=g_rlang
    #No.FUN-730010--begin-- mark
    #CALL cl_outnam('ammg200') RETURNING l_name
    #START REPORT g200_rep TO l_name
    #LET g_pageno = 0
    #No.FUN-730010--end-- mark
     FOREACH g200_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
    #FUN-C50008--mark--str  
    #   SELECT mmc02 INTO sr.mmc02 FROM mmc_file WHERE mmc01 = sr.mmb05
    #   IF SQLCA.sqlcode THEN LET sr.mmc02 = '' END IF
 
    #   SELECT pmc03 INTO sr.pmc03 FROM pmc_file WHERE pmc01 = sr.mmb08
    #   IF SQLCA.sqlcode THEN LET sr.pmc03 = '' END IF
 
    #   SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem01 = sr.mma15
    #   IF SQLCA.sqlcode THEN LET sr.gem02 = '' END IF
 
    #   SELECT mmi02 INTO sr.mmi02 FROM mmi_file WHERE mmi01 = sr.mma14
    #   IF SQLCA.sqlcode THEN LET sr.mmi02 = '' END IF
 
    #   SELECT ima02,ima021 INTO sr.ima02,sr.ima021 FROM ima_file  
    #    WHERE ima01 = sr.mma05
    #   IF SQLCA.sqlcode THEN LET sr.ima02= ''  LET sr.ima021 = '' END IF
    #FUN-C50008--mark--end

    #FUN-C50008--add--str
     IF cl_null(sr.mmc02) THEN LET sr.mmc02 = '' END IF
     IF cl_null(sr.pmc03) THEN LET sr.pmc03 = '' END IF
     IF cl_null(sr.gem02) THEN LET sr.gem02 = '' END IF
     IF cl_null(sr.mmi02) THEN LET sr.mmi02 = '' END IF
     IF cl_null(sr.ima02) THEN LET sr.ima02= ''  END IF
     IF cl_null(sr.ima021) THEN LET sr.ima021 = '' END IF
    #FUN-C50008--add--end

       #FUN-B50018-------add-----str----
       IF sr.mmb05 = 'M' THEN LET sr.l_mfghour = sr.mmb11 ELSE LET sr.l_mfghour = 0 END IF
       LET sr.l_mmb11_mmb09_mmb19 = sr.mmb11 * sr.mmb09 * sr.mmb19 
       IF sr.mmb05 != 'M' THEN LET sr.l_pmcfare = sr.mmb09 * sr.mmb10 END IF
       #FUN-B50018-------add-----end----  
       #EXECUTE insert_prep USING sr.*,l_azi03,l_azi04,l_azi05    #FUN-C40026 mark
       EXECUTE insert_prep USING sr.*,l_azi03,l_azi04,l_azi05,"",l_img_blob,"N",""    #FUN-C40026 add
      #OUTPUT TO REPORT g200_rep(sr.*)  #No.FUN-730010 mark
     END FOREACH
 
    LET g_cr_table = l_table                 #FUN-C40026 add
    LET g_cr_apr_key_f = "mma01"             #FUN-C40026 add
    #No.FUN-730010--begin--
    #FINISH REPORT g200_rep
   # LET g_sql = " SELECT * FROM ",l_table CLIPPED   #TQC-730113
###GENGRE###     LET g_sql = " SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'mma01,mma07,mma15') RETURNING tm.wc
     ELSE                                               #FUN-C40026 add
        CALL cl_wcchp(tm.wc,'mma01') RETURNING tm.wc    #FUN-C40026 add
     END IF
###GENGRE###     LET g_str = tm.wc
   # CALL cl_prt_cs3('ammg200',g_sql,g_str)      #TQC-730113
###GENGRE###     CALL cl_prt_cs3('ammg200','ammg200',g_sql,g_str)
    CALL ammg200_grdata()    ###GENGRE###
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    #  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
    #No.FUN-730010--end--
END FUNCTION
 
##No.FUN-730010--begin-- mark
#REPORT g200_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
#          l_dash        LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
#          l_n           LIKE type_file.num5,          #No.FUN-680100 SMALLINT
#          sr   RECORD 
#                     mma01     LIKE mma_file.mma01,    
#                     mma02     LIKE mma_file.mma02,    
#                     mma03     LIKE mma_file.mma03,    
#                     mma05     LIKE mma_file.mma05,    
#                     mma051    LIKE mma_file.mma051,
#                     mma06     LIKE mma_file.mma06,    
#                     mma07     LIKE mma_file.mma07,    
#                     mma08     LIKE mma_file.mma08,    
#                     mma09     LIKE mma_file.mma09,    
#                     mma10     LIKE mma_file.mma10,    
#                     mma11     LIKE mma_file.mma11,    
#                     mma12     LIKE mma_file.mma12,    
#                     mma14     LIKE mma_file.mma14,    
#                     mma15     LIKE mma_file.mma15,    
#                     mma16     LIKE mma_file.mma16,    
#                     mma17     LIKE mma_file.mma17,   
#                     mma19     LIKE mma_file.mma19,  
#                     mmaacti   LIKE mma_file.mmaacti, 
#                     mmb02     LIKE mmb_file.mmb02,  
#                     mmb05     LIKE mmb_file.mmb05,   
#                     mmb06     LIKE mmb_file.mmb06,   
#                     mmb07     LIKE mmb_file.mmb07,  
#                     mmb08     LIKE mmb_file.mmb08,  
#                     mmb09     LIKE mmb_file.mmb09,  
#                     mmb10     LIKE mmb_file.mmb10,  
#                     mmb11     LIKE mmb_file.mmb11,  
#                     mmb12     LIKE mmb_file.mmb12,  
#                     mmb121    LIKE mmb_file.mmb121, 
#                     mmb15     LIKE mmb_file.mmb15,  
#                     mmb19     LIKE mmb_file.mmb19,
#                     mmbacti   LIKE mmb_file.mmbacti, 
#                     mmc02     LIKE mmc_file.mmc02,  
#                     pmc03     LIKE pmc_file.pmc03,  
#                     gem02     LIKE gem_file.gem02,  
#                     mmi02     LIKE mmi_file.mmi02,  
#                     ima02     LIKE ima_file.ima02,
#                     ima021    LIKE ima_file.ima021
#        END RECORD,
#        pmcfare    LIKE mmb_file.mmb10,
#        mfghour    LIKE mmb_file.mmb10,
#        totamt     LIKE mmb_file.mmb10,
#        l_flag     LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
#        l_str      LIKE type_file.chr1000        #No.FUN-680100 VARCHAR(40)
#   
#  OUTPUT TOP MARGIN 0
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN 6
#         PAGE LENGTH g_page_line
#  ORDER BY sr.mma01,sr.mmb02
#  FORMAT
#   PAGE HEADER
#     #PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/3)+1,g_company
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company #No.TQC-6A0087
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1]   #TQC-6A0080
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED,pageno_total
#      PRINT 
#      PRINT g_dash
#      PRINT g_x[11] CLIPPED,sr.mma01
###TQC-5B0110&051112 START##
#      PRINT g_x[16] CLIPPED,sr.mma02,' ',sr.mma03,
#          #  COLUMN 50,g_x[12] CLIPPED,sr.mma07
#            COLUMN 50,g_x[12] CLIPPED,sr.mma07,'  ',g_x[17] CLIPPED,sr.mma08
#      PRINT g_x[13] CLIPPED,sr.mma05,g_x[23] CLIPPED,sr.mma051
###TQC-5B0110&051112 END##
#      PRINT COLUMN 10,sr.ima02 CLIPPED,' ',sr.ima021
#      PRINT g_x[14] CLIPPED,sr.mma06,
#            COLUMN 50,g_x[18] CLIPPED,sr.mma11
#      PRINT g_x[15] CLIPPED,sr.mma09,' ',sr.mma10,
#            COLUMN 50,g_x[19] CLIPPED,sr.mma12
#      PRINT g_x[20] CLIPPED,sr.mma14,' ',sr.mmi02,
#            COLUMN 50,g_x[21] CLIPPED,sr.mma15,' ',sr.gem02
#      PRINT g_x[22] CLIPPED,sr.mma16 CLIPPED
#      PRINT 
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#                     g_x[36],g_x[37],g_x[38]
#      PRINTX name=H2 g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],
#                     g_x[44],g_x[45]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
# 
#BEFORE GROUP OF sr.mma01
#      SKIP TO TOP OF PAGE
#      UPDATE mma_file SET sr.mma19 = 'Y' WHERE mma01=sr.mma01
#      LET totamt=0
#      LET pmcfare = 0
#      LET mfghour = 0
#      LET l_flag = 'N'
#
#ON EVERY ROW 
#      PRINTX name=D1 COLUMN g_c[31],sr.mmb02 USING '####',          #No.FUN-570174
#                     COLUMN g_c[32],sr.mmb05,
#                     COLUMN g_c[33],sr.mmc02,
#                     COLUMN g_c[34],sr.mmb08,
#                     COLUMN g_c[35],cl_numfor(sr.mmb09,35,0),
#                     COLUMN g_c[36],cl_numfor(sr.mmb11,36,0),
#                     COLUMN g_c[37],sr.mmb12,
#	             COLUMN g_c[38],sr.mmb07
#      PRINTX name=D2 COLUMN g_c[40],sr.mmb06,
#                     COLUMN g_c[41],sr.pmc03,
#                     COLUMN g_c[42],cl_numfor(sr.mmb19,42,g_azi03),
#                     COLUMN g_c[43],cl_numfor(sr.mmb10,43,g_azi04),
#                     COLUMN g_c[44],sr.mmb121,
#                     COLUMN g_c[45],sr.mmbacti
#      PRINT COLUMN 04,sr.mmb15   #備註
#
#AFTER GROUP OF sr.mma01
#      LET pmcfare = GROUP SUM(sr.mmb10*sr.mmb09) WHERE sr.mmb05<>'M'
#      IF cl_null(pmcfare) THEN LET pmcfare = 0 END IF
#      LET mfghour = GROUP SUM(sr.mmb11) WHERE sr.mmb05='M'
#      IF cl_null(mfghour) THEN LET mfghour = 0 END IF
#      LET totamt = pmcfare + GROUP SUM(sr.mmb11*sr.mmb09*sr.mmb19)/60
#
#      PRINT COLUMN 1,g_x[24] CLIPPED,COLUMN 8,cl_numfor(pmcfare,15,g_azi05),
#            COLUMN 26,g_x[25] CLIPPED,COLUMN 35,mfghour USING '######&.&&',
#            COLUMN 53,g_x[26] CLIPPED,COLUMN 62,cl_numfor(totamt,15,g_azi05)
##     LET g_pageno=0
#      LET l_flag='Y'
#  
### FUN-550114
#   ON LAST ROW
#      LET l_last_sw = 'y'
#      PRINT g_dash[1,g_len]   #TQC-6A0080
#      PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED   #No.TQC-6A0080
#      PRINT g_x[27]   #No.TQC-6A0080
#      PRINT g_memo    #No.TQC-6A0080
#
#   PAGE TRAILER
#     #IF l_flag= 'Y' THEN
#     #   PRINT COLUMN 01,g_x[27] CLIPPED,
#     #         COLUMN 25,g_x[28] CLIPPED,
#     #         COLUMN 50,g_x[29] CLIPPED
#     #   SKIP 1 LINE
#     #ELSE
#     #  SKIP 2 LINE
#     #END IF
#
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_dash[1,g_len]   #TQC-6A0080
#             PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED   #No.TQC-6A0080
#             PRINT g_x[27]
#             PRINT g_memo
#         ELSE
#             PRINT g_dash[1,g_len]   #TQC-6A0080
#             PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED   #No.TQC-6A0080
#             PRINT
#             PRINT
#         END IF
#      ELSE
#         SKIP 4 LINE    #No.TQC-6A0080
#      END IF
### END FUN-550114
#
#END REPORT
##No.FUN-730010--end-- mark

###GENGRE###START
FUNCTION ammg200_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
   
    LOCATE sr1.sign_img IN MEMORY    #FUN-C40026 add
    CALL cl_gre_init_apr()           #FUN-C40026 add
 
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("ammg200")
        IF handler IS NOT NULL THEN
            START REPORT ammg200_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," ORDER BY mma01,mmb02"
          
            DECLARE ammg200_datacur1 CURSOR FROM l_sql
            FOREACH ammg200_datacur1 INTO sr1.*
                OUTPUT TO REPORT ammg200_rep(sr1.*)
            END FOREACH
            FINISH REPORT ammg200_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT ammg200_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5

    #FUN-B50018----add-----str-----------------
    DEFINE  l_ima02_ima021           STRING
    DEFINE  l_mfghour_sum            LIKE mmb_file.mmb11
    DEFINE  l_mma02_mma03            STRING
    DEFINE  l_mma03                  STRING
    DEFINE  l_mma09_mma10            STRING
    DEFINE  l_mma09                  STRING 
    DEFINE  l_mma14_mmi02            STRING
    DEFINE  l_mma15_gem02            STRING
    DEFINE  l_totamt                 LIKE mmb_file.mmb11
    DEFINE  l_pmcfare_sum            LIKE mmb_file.mmb09
    DEFINE  l_mmb11_mmb09_mmb19_sum     LIKE mmb_file.mmb09
    DEFINE  l_mmb11_mmb09_mmb19_sum_1   LIKE type_file.num10
    DEFINE  l_mmb19_fmt        STRING
    DEFINE  l_mmb10_fmt        STRING
    DEFINE  l_pmcfare_sum_fmt  STRING
    DEFINE  l_totamt_fmt       STRING
     
    #FUN-B50018----add-----end-----------------   
 
    ORDER EXTERNAL BY sr1.mma01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.mma01
            LET l_lineno = 0

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            
            #FUN-B50018----add-----str-----------------
            LET l_mmb19_fmt = cl_gr_numfmt('mmb_file','mmb19',sr1.azi03)
            PRINTX l_mmb19_fmt
            LET l_mmb10_fmt = cl_gr_numfmt('mmb_file','mmb10',sr1.azi03)
            PRINTX l_mmb10_fmt
            LET   l_ima02_ima021 = sr1.ima02,' ',sr1.ima021
            PRINTX  l_ima02_ima021

            LET l_mma03 = sr1.mma03 USING '###,###,##&'
            LET   l_mma02_mma03 = sr1.mma02,' ',l_mma03
            PRINTX  l_mma02_mma03

            LET l_mma09 = sr1.mma09   USING '###,###,##&'
            LET   l_mma09_mma10 = l_mma09,' ',sr1.mma10
            PRINTX  l_mma09_mma10

            LET   l_mma14_mmi02 = sr1.mma14,' ',sr1.mmi02
            PRINTX  l_mma14_mmi02

            LET   l_mma15_gem02 = sr1.mma15,' ',sr1.gem02
            PRINTX  l_mma15_gem02

            #FUN-B50018----add-----end-----------------

            PRINTX sr1.*

        AFTER GROUP OF sr1.mma01

            #FUN-B50018----add-----str----------------- 
            LET l_mfghour_sum = GROUP SUM(sr1.l_mfghour)
            PRINTX l_mfghour_sum   
            
            LET l_pmcfare_sum = GROUP SUM(sr1.l_pmcfare)
            PRINTX l_pmcfare_sum

            LET l_mmb11_mmb09_mmb19_sum = GROUP SUM(sr1.l_mmb11_mmb09_mmb19) 
            PRINTX l_mmb11_mmb09_mmb19_sum
            
            LET l_mmb11_mmb09_mmb19_sum_1 = l_mmb11_mmb09_mmb19_sum/60 USING "---,--&.&&"
            LET   l_totamt = l_pmcfare_sum + l_mmb11_mmb09_mmb19_sum_1
            PRINTX  l_totamt


            LET l_pmcfare_sum_fmt = cl_gr_numfmt('mmb_file','mmb09',sr1.azi05)
            PRINTX l_pmcfare_sum_fmt
            LET   l_totamt_fmt = cl_gr_numfmt('mmb_file','mmb09',sr1.azi05)
            PRINTX  l_totamt_fmt
            #FUN-B50018----add-----end-----------------

        ON LAST ROW

END REPORT
###GENGRE###END
