# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: ammg220.4gl
# Desc/riptions..: 零件需求單列印
# Date & Author..: 01/01/02 By Plum
# Modify.........: No.FUN-550054 05/05/17 By yoyo單據編號格式放大
# Modify.........: No.FUN-550114 05/05/26 By echo 新增報表備註
# Modify.........: No.FUN-570174 05/07/18 By yoyo項次欄位加大
# Modify.........: No.FUN-590110 05/09/23 By vivien 報表轉XML
# Modify.........: No.FUN-660094 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-680100 06/08/28 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題處理
# Modify.........: No.FUN-710091 07/02/14 By xufeng 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730113 07/04/02 By Nicole 增加CR參數
# Modify.........: No.TQC-780049 07/08/15 By Sarah 修改INSERT INTO temptable語法(不用ora轉換)
# Modify.........: No.FUN-850062 08/05/16 By baofei 報表打印不出來，報錯 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B40092 11/05/19 By xujing \t特殊字元導致轉GR的時候p_gengre出錯	
# Modify.........: No.FUN-B40092 11/05/19 By xujing 憑證類報表轉GRW 
# Modify.........: No.FUN-B40092 11/08/17 By xujing 程式規範修改
# Modify.........: No.FUN-BB0047 11/11/16 By fengrui  調整時間函數問題
# Modify.........: No:FUN-C40026 12/04/10 By xumm GR動態簽核
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				      # Print condition RECORD
       	    	wc     	LIKE type_file.chr1000,       #No.FUN-680100 VARCHAR(600)# Where condition
                 a      LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
                more	LIKE type_file.chr1           #No.FUN-680100 VARCHAR(1)
              END RECORD
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680100 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680100 SMALLINT
#No.FUN-710091  --begin
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING
#No.FUN-710091  --end  
###GENGRE###START
TYPE sr1_t RECORD
    mma01 LIKE mma_file.mma01,
    mma02 LIKE mma_file.mma02,
    mma03 LIKE mma_file.mma03,
    mma021 LIKE mma_file.mma021,
    mma04 LIKE mma_file.mma04,
    mma05 LIKE mma_file.mma05,
    mma051 LIKE mma_file.mma051,
    mma06 LIKE mma_file.mma06,
    mma07 LIKE mma_file.mma07,
    mma08 LIKE mma_file.mma08,
    mma09 LIKE mma_file.mma09,
    mma10 LIKE mma_file.mma10,
    mma11 LIKE mma_file.mma11,
    mma12 LIKE mma_file.mma12,
    mma13 LIKE mma_file.mma13,
    mma14 LIKE mma_file.mma14,
    mma15 LIKE mma_file.mma15,
    mma16 LIKE mma_file.mma16,
    mma17 LIKE mma_file.mma17,
    mma18 LIKE mma_file.mma18,
    mma19 LIKE mma_file.mma19,
    mma20 LIKE mma_file.mma20,
    mma21 LIKE mma_file.mma21,
    mma211 LIKE mma_file.mma211,
    mmaacti LIKE mma_file.mmaacti,
    mmauser LIKE mma_file.mmauser,
    mmagrup LIKE mma_file.mmagrup,
    mmamodu LIKE mma_file.mmamodu,
    mmadate LIKE mma_file.mmadate,
    mmb01 LIKE mmb_file.mmb01,
    mmb02 LIKE mmb_file.mmb02,
    mmb03 LIKE mmb_file.mmb03,
    mmb04 LIKE mmb_file.mmb04,
    mmb05 LIKE mmb_file.mmb05,
    mmb06 LIKE mmb_file.mmb06,
    mmb07 LIKE mmb_file.mmb07,
    mmb08 LIKE mmb_file.mmb08,
    mmb09 LIKE mmb_file.mmb09,
    mmb10 LIKE mmb_file.mmb10,
    mmb11 LIKE mmb_file.mmb11,
    mmb12 LIKE mmb_file.mmb12,
    mmb121 LIKE mmb_file.mmb121,
    mmb13 LIKE mmb_file.mmb13,
    mmb131 LIKE mmb_file.mmb131,
    mmb132 LIKE mmb_file.mmb132,
    mmb14 LIKE mmb_file.mmb14,
    mmb141 LIKE mmb_file.mmb141,
    mmb15 LIKE mmb_file.mmb15,
    mmb16 LIKE mmb_file.mmb16,
    mmb17 LIKE mmb_file.mmb17,
    mmb18 LIKE mmb_file.mmb09,
    mmb19 LIKE mmb_file.mmb19,
    mmb20 LIKE mmb_file.mmb20,
    mmbacti LIKE mmb_file.mmbacti,
    ima02 LIKE ima_file.ima02,
    ima021 LIKE ima_file.ima021,
    gem02 LIKE gem_file.gem02,
    mmi02 LIKE mmi_file.mmi02,
    mmc02 LIKE mmc_file.mmc02,
    azi03 LIKE azi_file.azi03,   #FUN-C40026 add,
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

   #CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-BB0047  mark
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMM")) THEN
      EXIT PROGRAM
   END IF
 
 
   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #No.FUN-710091  --begin
   LET g_sql = "mma01.mma_file.mma01,",
               "mma02.mma_file.mma02,",
               "mma03.mma_file.mma03,",
               "mma021.mma_file.mma021,",
               "mma04.mma_file.mma04,",
               "mma05.mma_file.mma05,",
               "mma051.mma_file.mma051,",
               "mma06.mma_file.mma06,",
               "mma07.mma_file.mma07,",
               "mma08.mma_file.mma08,",
               "mma09.mma_file.mma09,",
               "mma10.mma_file.mma10,",
               "mma11.mma_file.mma11,",
               "mma12.mma_file.mma12,",
               "mma13.mma_file.mma13,",
               "mma14.mma_file.mma14,",
               "mma15.mma_file.mma15,",
               "mma16.mma_file.mma16,",
               "mma17.mma_file.mma17,",
               "mma18.mma_file.mma18,",
               "mma19.mma_file.mma19,",
               "mma20.mma_file.mma20,",
               "mma21.mma_file.mma21,",
               "mma211.mma_file.mma211,",
               "mmaacti.mma_file.mmaacti,",
               "mmauser.mma_file.mmauser,",
               "mmagrup.mma_file.mmagrup,",
               "mmamodu.mma_file.mmamodu,",
               "mmadate.mma_file.mmadate,",
               "mmb01.mmb_file.mmb01,",
               "mmb02.mmb_file.mmb02,",
               "mmb03.mmb_file.mmb03,",
               "mmb04.mmb_file.mmb04,",
               "mmb05.mmb_file.mmb05,",
               "mmb06.mmb_file.mmb06,",
               "mmb07.mmb_file.mmb07,",
               "mmb08.mmb_file.mmb08,",
               "mmb09.mmb_file.mmb09,",
               "mmb10.mmb_file.mmb10,",
               "mmb11.mmb_file.mmb11,",
               "mmb12.mmb_file.mmb12,",
               "mmb121.mmb_file.mmb121,",
               "mmb13.mmb_file.mmb13,",
               "mmb131.mmb_file.mmb131,",
               "mmb132.mmb_file.mmb132,",
               "mmb14.mmb_file.mmb14,",
               "mmb141.mmb_file.mmb141,",
               "mmb15.mmb_file.mmb15,",
               "mmb16.mmb_file.mmb16,",
               "mmb17.mmb_file.mmb17,",
               "mmb18.mmb_file.mmb09,",
               "mmb19.mmb_file.mmb19,",
               "mmb20.mmb_file.mmb20,",
               "mmbacti.mmb_file.mmbacti,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "gem02.gem_file.gem02,",
               "mmi02.mmi_file.mmi02,",
               "mmc02.mmc_file.mmc02,",
               "azi03.azi_file.azi03,",        #FUN-C40026 add 2,
              #FUN-C40026----add---str----
              "sign_type.type_file.chr1,",  #簽核方式
              "sign_img.type_file.blob,",   #簽核圖檔
              "sign_show.type_file.chr1,",
              "sign_str.type_file.chr1000"
              #FUN-C40026----add---end----
   LET l_table = cl_prt_temptable('ammg220',g_sql) CLIPPED
   IF  l_table = -1 THEN
       #CALL cl_used(g_prog, g_time,2) RETURNING g_time #FUN-B40092  #No.FUN-BB0047  mark
       CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
       EXIT PROGRAM 
   END IF
   #No.FUN-710091  --end  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-BB0047  add
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL g220_tm(0,0)		# Input print condition
      ELSE CALL ammg220()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
END MAIN
 
FUNCTION g220_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,          #No.FUN-680100 SMALLINT
          l_cmd		LIKE type_file.chr1000        #No.FUN-680100 VARCHAR(400)
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 8 LET p_col = 17
   ELSE LET p_row = 5 LET p_col = 14
   END IF
 
   OPEN WINDOW g220_w AT p_row,p_col
        WITH FORM "amm/42f/ammg220"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON mma01,mma021,mma15,mma02,mma05,mma08
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
      LET INT_FLAG = 0 CLOSE WINDOW g220_w 
      CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40092
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF cl_null(tm.a) THEN LET tm.a='N' END IF
         IF cl_null(tm.a) OR tm.a NOT MATCHES "[YN]" THEN
            NEXT FIELD a
         END IF
 
      AFTER FIELD more
         IF cl_null(tm.more) THEN LET tm.more='N' END IF
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
            NEXT FIELD more
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
      LET INT_FLAG = 0 CLOSE WINDOW g220_w 
      CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40092
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='ammg220'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('ammg220','9031',1)
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
                         " '",tm.a CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('ammg220',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW g220_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL ammg220()
   ERROR ""
END WHILE
   CLOSE WINDOW g220_w
END FUNCTION
 
FUNCTION ammg220()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680100 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0076
          l_sql 	STRING,		# RDSQL STATEMENT        #No.FUN-680100
          l_chr		LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
          sr   RECORD
               mma      RECORD LIKE mma_file.*,
               mmb      RECORD LIKE mmb_file.*,
               ima02           LIKE ima_file.ima02,    #品名
               ima021          LIKE ima_file.ima021,   #規格
               gem02           LIKE gem_file.gem02,    #部門
               mmi02           LIKE mmi_file.mmi02,    #需求類別
               mmc02           LIKE mmc_file.mmc02     #加工碼
        END RECORD
     DEFINE l_img_blob       LIKE type_file.blob  #FUN-C40026 add

#       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076 #FUN-B40092 mark
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #No.FUN-710091  --begin
     LOCATE l_img_blob      IN MEMORY            #FUN-C40026 add
     CALL cl_del_data(l_table)
     LET l_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-780049
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"     #FUN-C40026 add 4?
     PREPARE insert_prep FROM l_sql
     IF STATUS THEN
        CALL cl_err("insert_prep:",STATUS,1)  
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
        EXIT PROGRAM
     END IF
     #No.FUN-710091  --end  
 
     LET l_sql="SELECT mma_file.*,mmb_file.*,ima02,ima021,gem02,mmi02,''    ",
               "  FROM mma_file LEFT OUTER JOIN mmb_file ON (mma01 = mmb01) ",
               " LEFT OUTER JOIN gem_file ON (mma15 = gem01) LEFT OUTER JOIN mmi_file ON (mma14 = mmi01) AND mmi_file. mmi03 = '2' LEFT OUTER JOIN  ima_file ON (mma05 = ima01) ",
               
               
               
               
               "   WHERE mmaacti<> 'X' AND ",tm.wc CLIPPED
 
     PREPARE g220_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40092
        CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
        EXIT PROGRAM
     END IF
     DECLARE g220_cs1 CURSOR FOR g220_prepare1
 #   CALL cl_outnam('ammg220') RETURNING l_name  #No.FUN-710091 
 #   START REPORT g220_rep TO l_name   #No.FUN-710091 
 #   LET g_pageno = 0  #No.FUN-710091 
  #NO.CHI-6A0004--BEGIN
  #   SELECT azi03 INTO g_azi03 FROM azi_file WHERE azi01=g_aza.aza17 
  #   IF cl_null(g_azi03) THEN LET g_azi03=0 END IF
  #NO.CHI-6A0004--END                                            
   FOREACH g220_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) 
          EXIT FOREACH
       END IF
        #MOD-490043
       LET sr.mmc02=''
#       SELECT mmc02 INTO sr.mmc02 FROM mmc_file WHERE mmc01 = sr.mmb05
        SELECT mmc02 INTO sr.mmc02 FROM mmc_file WHERE mmc01 = sr.mmb.mmb05     
       #--
    #  OUTPUT TO REPORT g220_rep(sr.*)  #No.FUN-710091
   
    #No.FUN-710091  --begin
#       EXECUTE insert_prep USING sr.*,g_azi03    #No.FUN-850062
    EXECUTE insert_prep USING sr.mma.mma01,sr.mma.mma02,sr.mma.mma03,sr.mma.mma021,
                              sr.mma.mma04,sr.mma.mma05,sr.mma.mma051,sr.mma.mma06,
                              sr.mma.mma07,sr.mma.mma08,sr.mma.mma09,sr.mma.mma10,
                              sr.mma.mma11,sr.mma.mma12,sr.mma.mma13,sr.mma.mma14,
                              sr.mma.mma15,sr.mma.mma16,sr.mma.mma17,sr.mma.mma18,
                              sr.mma.mma19,sr.mma.mma20,sr.mma.mma21,sr.mma.mma211,
                              sr.mma.mmaacti,sr.mma.mmauser,sr.mma.mmagrup,sr.mma.mmamodu,
                              sr.mma.mmadate,sr.mmb.mmb01,sr.mmb.mmb02,sr.mmb.mmb03,
                              sr.mmb.mmb04,sr.mmb.mmb05,sr.mmb.mmb06,sr.mmb.mmb07,
                              sr.mmb.mmb08,sr.mmb.mmb09,sr.mmb.mmb10,sr.mmb.mmb11,
                              sr.mmb.mmb12,sr.mmb.mmb121,sr.mmb.mmb13,sr.mmb.mmb131,
                              sr.mmb.mmb132,sr.mmb.mmb14,sr.mmb.mmb141,sr.mmb.mmb15,
                              sr.mmb.mmb16,sr.mmb.mmb17,sr.mmb.mmb18,sr.mmb.mmb19,
                              sr.mmb.mmb20,sr.mmb.mmbacti,sr.ima02,sr.ima021,sr.gem02,
                              sr.mmi02,sr.mmc02,g_azi03,        #No.FUN-850062      #FUN-C40026 add ,
                              "",l_img_blob,"N",""    #FUN-C40026 add
    #No.FUN-710091  --end  
     END FOREACH
     LET g_cr_table = l_table                 #FUN-C40026 add
     LET g_cr_apr_key_f = "mma01"             #FUN-C40026 add
     #No.FUN-710091  --begin
   # LET g_sql = "SELECT * FROM ",l_table CLIPPED  #TQC-730113
###GENGRE###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_wcchp(tm.wc,'mma01,mma021,mma15,mma02,mma05,mma08')                          RETURNING  tm.wc
###GENGRE###     LET g_str = tm.wc
   # CALL cl_prt_cs3("ammg220",g_sql,g_str)        #TQC-730113
###GENGRE###     CALL cl_prt_cs3('ammg220','ammg220',g_sql,g_str)
    CALL ammg220_grdata()    ###GENGRE###
     #No.FUN-710091  --end  
 
   # FINISH REPORT g220_rep  #No.FUN-710091 
 
   # CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #No.FUN-710091 
#       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076  #FUN-B40092 mark
END FUNCTION
#No.FUN-710091  --begin
#REPORT g220_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
#          sr   RECORD
#               mma      RECORD LIKE mma_file.*,
#               mmb      RECORD LIKE mmb_file.*,
#               ima02           LIKE ima_file.ima02,    #品名
#               ima021          LIKE ima_file.ima021,   #規格
#               gem02           LIKE gem_file.gem02,    #部門
#               mmi02           LIKE mmi_file.mmi02,    #需求類別
#               mmc02           LIKE mmc_file.mmc02     #加工碼
#               END RECORD,
#        l_desc       LIKE type_file.chr4,          #No.FUN-680100 VARCHAR(04)
#        l_mma17      LIKE type_file.chr4           #No.FUN-680100 VARCHAR(04)
# 
#  OUTPUT TOP MARGIN 0
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN 6
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.mma.mma01,sr.mmb.mmb02
#  FORMAT
#   PAGE HEADER
#      CASE sr.mma.mma20
#           WHEN '1'   LET l_desc=g_x[41] CLIPPED
#           WHEN '2'   LET l_desc=g_x[42] CLIPPED
#           WHEN '3'   LET l_desc=g_x[43] CLIPPED
#           WHEN '4'   LET l_desc=g_x[44] CLIPPED
#           OTHERWISE  LET l_desc='    '
#      END CASE
##No.FUN-590110 --start
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1 ,g_company
#      PRINT ' '
#      IF sr.mma.mma17='Y' THEN
#         LET l_mma17=g_x[38] CLIPPED
#      ELSE
#         LET l_mma17=g_x[39] CLIPPED
#      END IF
#      LET g_pageno = g_pageno + 1
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      PRINT ' '
#      LET pageno_total=PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED,pageno_total
#      PRINT g_dash[1,g_len]
#      PRINT g_x[11] CLIPPED,sr.mma.mma01,
#            COLUMN 32,g_x[19] CLIPPED,l_mma17,
#            COLUMN 62,g_x[26] CLIPPED,sr.mma.mma04,
#            COLUMN 72,g_x[27] CLIPPED,sr.mma.mmaacti
#      PRINT g_x[12] CLIPPED,sr.mma.mma02,
#            COLUMN 32,g_x[20] CLIPPED,sr.mma.mma05,
#            g_x[40] CLIPPED,sr.mma.mma051
#      PRINT COLUMN 41,sr.ima02
#      PRINT g_x[13] CLIPPED,sr.mma.mma02 CLIPPED,' ',sr.mma.mma03 CLIPPED,COLUMN 41,sr.ima021
#      PRINT g_x[14] CLIPPED,sr.mma.mma07,
#            COLUMN 32,g_x[21] CLIPPED,sr.mma.mma08
#      PRINT g_x[15] CLIPPED,sr.mma.mma11,
#            COLUMN 32,g_x[22] CLIPPED,sr.mma.mma12
#      PRINT g_x[16] CLIPPED,sr.mma.mma09 USING '########&',' ',sr.mma.mma10,
#            COLUMN 32,g_x[23] CLIPPED,sr.mma.mma14,' ',sr.mmi02
#      PRINT g_x[17] CLIPPED,sr.mma.mma20,' ',l_desc,
#            COLUMN 32,g_x[24] CLIPPED,sr.mma.mma15,' ',sr.gem02
#      PRINT g_x[18] CLIPPED,sr.mma.mma21,' ',sr.mma.mma211,
#            COLUMN 32,g_x[25] CLIPPED,sr.mma.mma16
#      PRINT g_dash[1,g_len]
#      LET g_cnt=1 LET l_last_sw='n'
##No.FUN-590110 --end
#
#   BEFORE GROUP OF sr.mma.mma01
#      SKIP TO TOP OF PAGE
#
#   ON EVERY ROW
##No.FUN-590110 --start
##No.FUN-570174--start--
#      IF tm.a='Y' THEN
#         IF g_cnt=1 THEN
#            PRINTX name=H1 g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48]
#            PRINTX name=H2 g_x[49],g_x[50],g_x[51],g_x[52],g_x[53],g_x[54],g_x[55]                                 #No.FUN-570174
#            PRINTX name=H3 g_x[56],g_x[57],g_x[58],g_x[59],g_x[60]       #No.FUN-550054
#         PRINT g_dash1
#         END IF
#         PRINTX name=D1
#               COLUMN g_c[41],sr.mmb.mmb02 USING '###&',
#               COLUMN g_c[42],sr.mmb.mmb06 CLIPPED,
#               COLUMN g_c[43],sr.mmb.mmb07 CLIPPED,
#               COLUMN g_c[44],sr.mmb.mmb12 CLIPPED,
#               COLUMN g_c[45],cl_numfor(sr.mmb.mmb10,45,g_azi03),
#               COLUMN g_c[46],sr.mmb.mmb09 USING '##############&',
#               COLUMN g_c[47],sr.mmb.mmb11 USING '#######&',
#	       COLUMN g_c[48],sr.mmb.mmbacti
#         PRINTX name=D2
#               COLUMN g_c[50],sr.mmb.mmb05 CLIPPED,
#               COLUMN g_c[51],sr.mmc02 CLIPPED,
#	       COLUMN g_c[52],sr.mmb.mmb121 CLIPPED,
#               COLUMN g_c[53],cl_numfor(sr.mmb.mmb16,53,g_azi03),
#               COLUMN g_c[54],sr.mmb.mmb18 USING '##############&',
#               COLUMN g_c[55],sr.mmb.mmb17 USING '#######&'
#	 PRINTX name=D3
#               COLUMN g_c[57],sr.mmb.mmb131 CLIPPED,
#               COLUMN g_c[58],sr.mmb.mmb132 CLIPPED,   #No.FUN-550054
#               COLUMN g_c[59],sr.mmb.mmb20 CLIPPED,
#               COLUMN g_c[60],cl_numfor(sr.mmb.mmb19,60,g_azi03)
#         PRINT COLUMN g_c[42],g_x[36] CLIPPED,sr.mmb.mmb15
#         LET g_cnt=g_cnt+1
#      END IF
##No.FUN-570174--end--
##No.FUN-590110 --end
#
#   ON LAST ROW
#      LET l_last_sw='y'
#
#   PAGE TRAILER
#      IF l_last_sw= 'n' THEN
#         PRINT g_dash[1,g_len]
#         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
#         PRINT g_dash[1,g_len]
#         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      END IF
### FUN-550114
#      PRINT ''
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[38]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[38]
#             PRINT g_memo
#      END IF
### END FUN-550114
#
#END REPORT
#No.FUN-710091  --end
#Patch....NO.TQC-610035 <001> #

###GENGRE###START
FUNCTION ammg220_grdata()
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
        LET handler = cl_gre_outnam("ammg220")
        IF handler IS NOT NULL THEN
            START REPORT ammg220_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY mma01,mmb02"
          
            DECLARE ammg220_datacur1 CURSOR FROM l_sql
            FOREACH ammg220_datacur1 INTO sr1.*
                OUTPUT TO REPORT ammg220_rep(sr1.*)
            END FOREACH
            FINISH REPORT ammg220_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT ammg220_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B40092------add------str
    DEFINE l_mma17 STRING
    DEFINE l_desc  STRING
    DEFINE l_mmb10_fmt STRING
    DEFINE l_mmb16_fmt STRING
    DEFINE l_mmb19_fmt STRING
    #FUN-B40092------add------end
    
    ORDER EXTERNAL BY sr1.mma01,sr1.mmb02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.mma01
            #FUN-B40092------add------str
            IF sr1.mma17 == 'Y' THEN
               LET l_mma17 = cl_gr_getmsg("gre-051",g_lang,0)
            ELSE 
               LET l_mma17 = cl_gr_getmsg("gre-051",g_lang,1)
            END IF
            LET  l_desc = cl_gr_getmsg("gre-050",g_lang,sr1.mma20)
            PRINTX l_desc
            PRINTX l_mma17
            #FUN-B40092------add------end
            LET l_lineno = 0
        BEFORE GROUP OF sr1.mmb02

        
        ON EVERY ROW
            #FUN-B40092------add------str
            LET l_mmb10_fmt = cl_gr_numfmt('mmb_file','mmb10',g_azi03)
            PRINTX l_mmb10_fmt
            LET l_mmb16_fmt = cl_gr_numfmt('mmb_file','mmb16',g_azi03)
            PRINTX l_mmb16_fmt
            LET l_mmb19_fmt = cl_gr_numfmt('mmb_file','mmb19',g_azi03)
            PRINTX l_mmb19_fmt
            #FUN-B40092------add------end
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.mma01
        AFTER GROUP OF sr1.mmb02

        
        ON LAST ROW

END REPORT
###GENGRE###END
