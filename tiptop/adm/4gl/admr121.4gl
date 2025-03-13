# Prog. Version..: '5.30.06-13.04.01(00009)'     #
#
# Pattern name...: admr121.4gl
# Descriptions...: 銷退理由分析表
# Input parameter:
# Date & Author..: 02/08/01 By Kitty
# Modify.........: No.FUN-4C0099 05/01/18 By kim 報表轉XML功能
# Modify.........: No.FUN-660090 06/06/23 By Douzh cl_err --> cl_err3
# Modify.........: No.FUN-680097 06/08/28 By chen 類型轉換
# Modify.........: No.FUN-690111 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-750027 070713 by TSD.pinky Add CR report
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.TQC-A40116 10/04/26 BY liuxqa modify sql
# Modify.........: No:MOD-A70180 10/07/23 By Sarah 權限控管段抓取的欄位fakuser與fakgrup應改為ohauser與ohagrup
# Modify.........: No:MOD-C90117 12/10/12 By Elise 理由說明應依銷退單抓取aooi301(azf_file)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				        # Print condition RECORD
              wc     STRING,                            # Where Condition  No.TQC-630166 
              bdate  LIKE type_file.dat,                #No.FUN-680097 DATE
              edate  LIKE type_file.dat,                #No.FUN-680097 DATE
              more   LIKE type_file.chr1                # 特殊列印條件     #No.FUN-680097 VARCHAR(1)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680097 SMALLINT
DEFINE   l_table        STRING, #FUN-750027###
       g_str          STRING, #FUN-750027###
       g_sql          STRING  #FUN-750027###
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ADM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690111
    #str FUN-750027 add
 ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
 LET g_sql=" ohb50.ohb_file.ohb50,", 
          #"oak02.oak_file.oak02, ",  #MOD-C90117 mark
           "azf03.azf_file.azf03, ",  #MOD-C90117
           "aa.type_file.num10,   ",
           "bb.ala_file.ala21,    ",
           "omb16.omb_file.omb16, ",
           "cc.ala_file.ala21,     ",
           "azi04.azi_file.azi04"
 LET l_table = cl_prt_temptable('admr121',g_sql) CLIPPED   # 產生Temp Table
 IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
 LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A40116 mod
             " VALUES(?,?,?,?,?, ?,?)"
 PREPARE insert_prep FROM g_sql
 IF STATUS THEN
    CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
 END IF
 #------------------------------ CR (1) ------------------------------#
 #end FUN-750027 add
 
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   CALL r121_tmp()
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r121_tm(0,0)	
      ELSE CALL r121()		
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
END MAIN
 
FUNCTION r121_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680097 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680097 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 11 END IF
   OPEN WINDOW r121_w AT p_row,p_col
        WITH FORM "adm/42f/admr121"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
WHILE TRUE
   CONSTRUCT BY NAME  tm.wc ON oha03
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
      LET INT_FLAG = 0
      CLOSE WINDOW r121_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.bdate,tm.edate,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN
            NEXT FIELD bdate
         END IF
 
      AFTER FIELD edate
         IF cl_null(tm.edate) OR (tm.bdate>tm.edate) THEN
            NEXT FIELD edate
         END IF
 
      AFTER FIELD more
         IF tm.more NOT MATCHES'[YN]' THEN
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
      LET INT_FLAG = 0
      CLOSE WINDOW r121_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='admr121'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('admr121','9031',1)   
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
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('admr121',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r121_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r121()
   ERROR ""
END WHILE
   CLOSE WINDOW r121_w
END FUNCTION
 
FUNCTION r121()
   DEFINE l_name     LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680097 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0100
          l_sql      LIKE type_file.chr1000,		# RDSQL STATEMENT        #No.FUN-680097 VARCHAR(1000)
          l_za05     LIKE type_file.chr1000,       #No.FUN-680097 VARCHAR(40)
          l_ohb50     LIKE    ohb_file.ohb50,    #
          l_aa        LIKE    type_file.num10,   # #No.FUN-680097 INTEGER
          l_omb16     LIKE    omb_file.omb16,    #
          l_tmp_aa        LIKE    type_file.num10,  #   #No.FUN-680097 INTEGER
          l_tmp_omb16     LIKE    omb_file.omb16,    #
          sr         RECORD
                     ohb50     LIKE    ohb_file.ohb50,    #銷退理由
                    #oak02     LIKE    oak_file.oak02,    #理由說明   #MOD-C90117 mark
                     azf03     LIKE    azf_file.azf03,    #理由說明   #MOD-C90117
                     aa        LIKE    type_file.num10,   #次數             #No.FUN-680097 INTEGER
                     bb        LIKE    ala_file.ala21,    #次數百分比       #No.FUN-680097 DEC(6,2)
                     omb16     LIKE    omb_file.omb16,    #銷退本幣金額
                     cc        LIKE    ala_file.ala21     #銷退百分比       #No.FUN-680097 DEC(6,2)  
                     END RECORD
     
   #str FUN-750027 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 =  g_prog  #FUN-750027 ad
   #------------------------------ CR (2) ------------------------------#
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fakuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
     #     END IF
    #LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fakuser', 'fakgrup')  #MOD-A70180 mark
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ohauser', 'ohagrup')  #MOD-A70180
     #End:FUN-980030
 
     DELETE FROM admr121_tmp
     #--取銷退金額
     LET l_sql = " SELECT ohb50,count(*),SUM(omb16) ",
                 " FROM oha_file,ohb_file,oma_file,omb_file",
                 " WHERE oma00 ='21' AND oha01=ohb01 AND oma01=omb01",
                 "  AND  ohb01=omb31 AND ohb03=omb32 ",
                 "  AND  oha02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "  AND  ohaconf='Y' AND ohapost='Y' AND omaconf='Y' ",
                 "  AND  omavoid='N' AND ",tm.wc CLIPPED,
                 "  GROUP BY ohb50 "
 
 
     PREPARE r121_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)   
 
 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
        EXIT PROGRAM
     END IF
     DECLARE r121_c1 CURSOR FOR r121_p1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('declare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
        EXIT PROGRAM
     END IF
#     CALL cl_outnam('admr121') RETURNING l_name
 
#     START REPORT r121_rep TO l_name
 
     LET g_pageno = 0
     FOREACH r121_c1 INTO l_ohb50,l_aa,l_omb16
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       INSERT INTO admr121_tmp VALUES (l_ohb50,l_aa,l_omb16)
     END FOREACH
 
     #--將暫存檔的資料丟到sr列印
     DECLARE r121_temp CURSOR FOR
      SELECT tmp_ohb50,' ',tmp_aa,0,tmp_omb16,0 FROM admr121_tmp
     FOREACH r121_temp INTO sr.*
       IF STATUS THEN CALL cl_err('foreach temp',STATUS,0) EXIT FOREACH END IF
       SELECT SUM(tmp_aa),SUM(tmp_omb16) INTO l_tmp_aa,l_tmp_omb16 FROM admr121_tmp
       IF cl_null(l_tmp_aa) OR l_tmp_aa=0 THEN
           LET sr.bb=0
       ELSE
           LET sr.bb=sr.aa/l_tmp_aa*100
       END IF
       IF  cl_null(l_tmp_omb16) OR l_tmp_omb16=0 THEN
           LET sr.cc=0
       ELSE
           LET sr.cc=sr.omb16/l_tmp_omb16*100
       END IF
      #MOD-C90117---mod---S
      #SELECT oak02 INTO sr.oak02 FROM oak_file
      # WHERE oak01=sr.ohb50
       LET sr.azf03 = ' '
       SELECT azf03 INTO sr.azf03 FROM azf_file
        WHERE azf01 = sr.ohb50
      #MOD-C90117---mod---E
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 ***
        EXECUTE insert_prep USING sr.*,g_azi04
       #------------------------------ CR (3) ----------------------
 
     END FOREACH
 
  #   FINISH REPORT r121_rep
 
  #   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
  #str FUN-750027 add
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'oha03') RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str ,";",tm.bdate,";",tm.edate
     CALL cl_prt_cs3('admr121','admr121',l_sql,g_str)
  #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
 
FUNCTION r121_tmp()
#No.FUN-680097-BEGIN	
  CREATE TEMP TABLE admr121_tmp(
    tmp_ohb50     LIKE ohb_file.ohb50,
    tmp_aa        LIKE type_file.num10, 
    tmp_omb16     LIKE omb_file.omb16)
#No.FUN-680097-END   
 
END FUNCTION
