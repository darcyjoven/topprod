# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr270.4gl
# Descriptions...: 應收票據呆帳提列明細表
# Input parameter:
# Return code....:
# Date & Author..: 94/05/03 By Apple
#                    增加選項(1).原幣 (2).本幣
# Modify.........: No.FUN-4C0098 05/03/02 By pengu 修改單價、金額欄位寬度
# Modify.........: No.FUN-580010 05/08/02 By will 報表轉XML格式
# Modify.........: No.TQC-5C0051 05/12/09 By kevin 修改欄位寬度 for unicode
# Modify.........: No.MOD-640032 06/04/09 By Smapmin 列印原幣時,應依幣別分別計算
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6B0189 06/12/04 By Smapmin 增加報表列印條件
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD		
              wc    LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(600)
              sdate LIKE type_file.dat,    #No.FUN-680107 DATE
              c     LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
              more  LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
              END RECORD,
          g_str     LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(120)
 
DEFINE   g_i        LIKE type_file.num5    #count/index for any purpose  #No.FUN-680107 SMALLINT
#No.FUN-580010  --begin
#DEFINE   g_dash          VARCHAR(400)  #Dash line
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT   #Report page no
#DEFINE   g_zz05          VARCHAR(1)    #Print tm.wc ?(Y/N)
#No.FUN-580010  --end
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.sdate  = ARG_VAL(8)
   LET tm.c      = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr270_tm()	        	# Input print condition
      ELSE CALL anmr270()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr270_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_cmd	      LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(400)
          l_flag      LIKE type_file.chr1,    #是否必要欄位有輸入 #No.FUN-680107 VARCHAR(1)
          l_jmp_flag  LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
   LET p_row = 4 LET p_col = 14
   OPEN WINDOW anmr270_w AT p_row,p_col
        WITH FORM "anm/42f/anmr270"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.sdate = g_today
   LET tm.c    = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nmh15, nmh11, nmh10, nmh29
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr270_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm.sdate,tm.c,tm.more
                   WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD sdate
         IF tm.sdate IS NULL OR tm.sdate = ' '
         THEN NEXT FIELD sdate
         END IF
 
      AFTER FIELD c
         IF tm.c NOT MATCHES '[12]' THEN
            NEXT FIELD c
         END IF
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            OR cl_null(tm.more)
         THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
     AFTER INPUT
       IF INT_FLAG THEN EXIT INPUT  END IF
       IF tm.sdate IS NULL OR tm.sdate = ' ' THEN
           DISPLAY BY NAME tm.sdate
           NEXT FIELD sdate
       END IF
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr270_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmr270'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('anmr270','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,	
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang   CLIPPED,"'",
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",
                         " '",tm.sdate CLIPPED,"'",
                         " '",tm.c  CLIPPED,"'",   #TQC-610058
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('anmr270',g_time,l_cmd)	
      END IF
      CLOSE WINDOW anmr270_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr270()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr270_w
END FUNCTION
 
FUNCTION anmr270()
   DEFINE l_name	LIKE type_file.chr20, 	# External(Disk) file name #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0082
          l_sql 	LIKE type_file.chr1000,	# RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_za05	LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(40)
          sr            RECORD
                  nmh02  LIKE nmh_file.nmh02,   #票面金額
                  nmh03  LIKE nmh_file.nmh03,   #幣別   #MOD-640032
                  nmh05  LIKE nmh_file.nmh05,   #到期日
                  nmh15  LIKE nmh_file.nmh15,   #部門
                  nmh11  LIKE nmh_file.nmh11,   #客戶編號
                  nmh30  LIKE nmh_file.nmh30,   #客戶簡稱
                  azk03  LIKE azk_file.azk03,   #每日匯率
                  azk04  LIKE azk_file.azk04,   #每日匯率   
                  buck   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1) #區間  
              END RECORD,
          l_day   LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          #l_buck1,l_buck2,l_buck3,l_buck4      VARCHAR(12)
          l_buck1,l_buck2,l_buck3,l_buck4       LIKE zaa_file.zaa08 #No.FUN-680107 VARCHAR(15) #No.TQC-5C0051
    #-----MOD-640032---------
    DEFINE sr1     RECORD
                   nmh15 LIKE nmh_file.nmh15,
                   nmh11 LIKE nmh_file.nmh11,
                   nmh30 LIKE nmh_file.nmh30,
                   nmh03 LIKE nmh_file.nmh03,
                   amt_1 LIKE nmh_file.nmh02,
                   amt_2 LIKE nmh_file.nmh02,
                   amt_3 LIKE nmh_file.nmh02,
                   amt_4 LIKE nmh_file.nmh02
                   END RECORD
    #-----END MOD-640032-----
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-580010  --begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'anmr270'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 160 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-580010  --end
 
     #-----MOD-640032---------
     DROP TABLE r270_tmp
#No.FUN-680107 --START
#     CREATE TEMP TABLE r270_tmp
#            (nmh15 VARCHAR(6),
#             nmh11 VARCHAR(10), 
#             nmh30 VARCHAR(30),
#             nmh03 VARCHAR(4),
#             amt_1 DEC(20,6),
#             amt_2 DEC(20,6),
#             amt_3 DEC(20,6),
#             amt_4 DEC(20,6))
     CREATE TEMP TABLE r270_tmp(
             nmh15 LIKE nmh_file.nmh15,
             nmh11 LIKE nmh_file.nmh11,
             nmh30 LIKE nmh_file.nmh30,
             nmh03 LIKE nmh_file.nmh03,
             amt_1 LIKE type_file.num20_6,
             amt_2 LIKE type_file.num20_6,
             amt_3 LIKE type_file.num20_6,
             amt_4 LIKE type_file.num20_6)
#No.FUN-680107 --END
     #-----END MOD-640032-----
#NO.CHI-6A0004--BEGINE
#     SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
# 		FROM azi_file WHERE azi01 = g_aza.aza17
#
#       IF SQLCA.sqlcode THEN
#         CALL cl_err(g_azi04,SQLCA.sqlcode,0)   #No.FUN-660148
#          CALL cl_err3("sel","azi_file",g_aza.aza17,"",SQLCA.sqlcode,"","",0) #No.FUN-660148
#       END IF
#NO.CHI-6A0004--END
   CALL cl_outnam('anmr270') RETURNING l_name
   FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '-' END FOR
 
   #-----MOD-640032---------
   #START REPORT anmr270_rep TO l_name   
   IF tm.c !='1' THEN
      START REPORT r270_rep TO l_name
   ELSE
      START REPORT r270_rep2 TO l_name
   END IF
   #-----END MOD-640032
   LET g_pageno  = 0
   LET l_buck1 = ''  LET l_buck2 = ''
   LET l_buck3 = ''  LET l_buck4 = ''
   IF g_nmz.nmz23 IS NOT NULL AND g_nmz.nmz23 > 0 THEN
      LET l_buck1 = '0 -',g_nmz.nmz23 using'###',' ',g_x[14].SubString(1,2)
      LET g_zaa[34].zaa08 = l_buck1   #No.FUN-580010
   END IF
   IF g_nmz.nmz24 IS NOT NULL AND g_nmz.nmz24 > 0 THEN
      LET l_buck2 = g_nmz.nmz23 + 1 using '###','-',
                    g_nmz.nmz24     using'###',' ',g_x[14].SubString(1,2)
      LET g_zaa[35].zaa08 = l_buck2   #No.FUN-580010
   END IF
   IF g_nmz.nmz25 IS NOT NULL AND g_nmz.nmz25 > 0 THEN
      LET l_buck3 = g_nmz.nmz24 + 1 using '###','-',
                    g_nmz.nmz25     using'###',' ',g_x[14].SubString(1,2)
      LET g_zaa[36].zaa08 = l_buck3   #No.FUN-580010
   END IF
   IF g_nmz.nmz26 IS NOT NULL AND g_nmz.nmz26 > 0 THEN
      LET l_buck4 = g_nmz.nmz26     using'###',' ',g_x[14]
      LET g_zaa[37].zaa08 = l_buck4   #No.FUN-580010
   END IF
   LET g_str ='    ', l_buck1 clipped,'           ','    ',l_buck2 clipped,'           ',
              '    ', l_buck3 clipped,'           ','    ',l_buck4 clipped
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND nmhuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND nmhgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND nmhgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmhuser', 'nmhgrup')
   #End:FUN-980030
 
   #LET l_sql = "SELECT nmh02, nmh05, nmh15, nmh11, nmh30, ",   #MOD-640032
   LET l_sql = "SELECT nmh02, nmh03, nmh05, nmh15, nmh11, nmh30, ",   #MOD-640032
               " azk03,azk04,'' ",
               " FROM  nmh_file LEFT OUTER JOIN azk_file ON azk01 = nmh03 AND azk02 = '",tm.sdate,"'",
               " WHERE nmh04 <= '",tm.sdate,"'",
               "   AND nmh38 <> 'X' ",
               "   AND (nmh35 is null or nmh35 >'",tm.sdate," ')",
               "   AND ",tm.wc clipped,
               " ORDER BY nmh15,nmh11,nmh03 "   #MOD-640032
 
    PREPARE anmr270_prepare FROM l_sql
    DECLARE anmr270_curs CURSOR FOR anmr270_prepare
 
 
 
    FOREACH anmr270_curs INTO sr.*
       IF SQLCA.sqlcode
       THEN CALL cl_err('foreach',SQLCA.sqlcode,0)
            EXIT FOREACH
       END IF
       IF sr.azk03 IS NULL OR sr.azk03 = ' ' OR sr.azk03 = 0
       THEN LET sr.azk03 = 1
       END IF
       IF sr.azk04 IS NULL OR sr.azk04 = ' ' OR sr.azk04 = 0
       THEN LET sr.azk04 = 1
       END IF
       #-->97/04/29 By Charis依選項換算成台幣
       IF tm.c='2' THEN
          LET sr.nmh02 = sr.nmh02 * ((sr.azk03 + sr.azk04) /2 )
       END IF
       #-->天數 (預兌日-基準日期)
       LET l_day = sr.nmh05 - tm.sdate
 
       #-->區間一
       IF l_day <= g_nmz.nmz23 THEN 
          LET sr.buck = '1'   
          INSERT INTO r270_tmp(nmh15,nmh11,nmh30,nmh03,amt_1)   #MOD-640032
             VALUES(sr.nmh15,sr.nmh11,sr.nmh30,sr.nmh03,sr.nmh02)   #MOD-640032
       END IF
       #-->區間二
       IF l_day > g_nmz.nmz23 AND l_day <= g_nmz.nmz24 THEN
          LET sr.buck = '2'
          INSERT INTO r270_tmp(nmh15,nmh11,nmh30,nmh03,amt_2)   #MOD-640032
             VALUES(sr.nmh15,sr.nmh11,sr.nmh30,sr.nmh03,sr.nmh02)   #MOD-640032
       END IF
       #-->區間三
       IF l_day > g_nmz.nmz24 AND l_day <= g_nmz.nmz25 THEN
          LET sr.buck = '3'  
          INSERT INTO r270_tmp(nmh15,nmh11,nmh30,nmh03,amt_3)   #MOD-640032
             VALUES(sr.nmh15,sr.nmh11,sr.nmh30,sr.nmh03,sr.nmh02)   #MOD-640032
       END IF
       #-->區間四
       IF l_day > g_nmz.nmz25 AND l_day <= g_nmz.nmz26 THEN
          LET sr.buck = '4'   
          INSERT INTO r270_tmp(nmh15,nmh11,nmh30,nmh03,amt_4)   #MOD-640032
             VALUES(sr.nmh15,sr.nmh11,sr.nmh30,sr.nmh03,sr.nmh02)   #MOD-640032
       END IF
       IF l_day > g_nmz.nmz26 THEN 
          LET sr.buck = '4' 
          INSERT INTO r270_tmp(nmh15,nmh11,nmh30,nmh03,amt_4)   #MOD-640032
             VALUES(sr.nmh15,sr.nmh11,sr.nmh30,sr.nmh03,sr.nmh02)   #MOD-640032
       END IF
       #-----MOD-640032---------
       IF tm.c != '1' THEN   
          OUTPUT TO REPORT r270_rep(sr.*)
       END IF 
       #-----END MOD-640032-----
       #OUTPUT TO REPORT anmr270_rep(sr.*)   #MOD-640032
    END FOREACH
  
    #-----MOD-640032---------
    IF tm.c = '1' THEN
       LET l_sql = "SELECT nmh15,nmh11,nmh30,nmh03,SUM(amt_1),SUM(amt_2),SUM(amt_3),",
                   " SUM(amt_4) ",
                   " FROM r270_tmp ",
                   " GROUP BY nmh15,nmh11,nmh30,nmh03",
                   " ORDER BY nmh15,nmh11,nmh30,nmh03"
       PREPARE r270_prepare2 FROM l_sql
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('prepare:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
          EXIT PROGRAM
       END IF
       DECLARE r270_curs2 CURSOR FOR r270_prepare2
    
       FOREACH r270_curs2 INTO sr1.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          IF cl_null(sr1.amt_1) THEN LET sr1.amt_1 = 0 END IF
          IF cl_null(sr1.amt_2) THEN LET sr1.amt_2 = 0 END IF
          IF cl_null(sr1.amt_3) THEN LET sr1.amt_3 = 0 END IF
          IF cl_null(sr1.amt_4) THEN LET sr1.amt_4 = 0 END IF
         
          OUTPUT TO REPORT r270_rep2(sr1.*)
       END FOREACH
    END IF
    IF tm.c != '1' THEN
       FINISH REPORT r270_rep
    ELSE
       FINISH REPORT r270_rep2
    END IF
    #FINISH REPORT anmr270_rep
    #-----END MOD-640032-----
 
    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r270_rep(sr)   #MOD-640032
   DEFINE l_last_sw      LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
          sr  RECORD
                  nmh02  LIKE nmh_file.nmh02,   #票面金額
                  nmh03  LIKE nmh_file.nmh03,   #幣別   #MOD-640032
                  nmh05  LIKE nmh_file.nmh05,   #到期日
                  nmh15  LIKE nmh_file.nmh15,   #部門
                  nmh11  LIKE nmh_file.nmh11,   #客戶編號
                  nmh30  LIKE nmh_file.nmh30,   #客戶簡稱
                  azk03  LIKE azk_file.azk03,   #每日匯率
                  azk04  LIKE azk_file.azk04,   #每日匯率
                  buck   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1) #區間  
              END RECORD,
         l_cus1,l_cus2           LIKE nmh_file.nmh02,
         l_cus3,l_cus4           LIKE nmh_file.nmh02,
         l_custot                LIKE nmh_file.nmh02,
         l_nmh02_b1, l_nmh02_b2  LIKE nmh_file.nmh02,
         l_nmh02_b3, l_nmh02_b4  LIKE nmh_file.nmh02,
         l_tot                   LIKE nmh_file.nmh02,
         l_g1, l_g2, l_g3, l_g4  LIKE nmh_file.nmh02,
         l_gsum                  LIKE nmh_file.nmh02
 
  OUTPUT TOP MARGIN g_top_margin
  LEFT MARGIN g_left_margin
  BOTTOM MARGIN g_bottom_margin
  PAGE LENGTH g_page_line
  ORDER BY sr.nmh15,sr.nmh11
  FORMAT
   PAGE HEADER
#No.FUN-580010  -begin
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
      PRINT
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT g_x[11] clipped,tm.sdate
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]  
      PRINT g_dash1
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
#           column 52,g_x[11] clipped,tm.sdate,'    ',
#		    COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#     PRINT g_dash[1,g_len]
#     PRINT column  2,g_x[12] clipped,column 39,g_str clipped,
#           column 138,g_x[13] clipped
#     PRINT '------ -------------------             ',
#           '------------------      ------------------      ',
#           '------------------      ------------------      -----------------'
#No.FUN-580010  -end
      LET l_last_sw = 'n'
 
   AFTER GROUP OF sr.nmh11    #客戶
         LET l_cus1 = GROUP SUM(sr.nmh02) WHERE  sr.buck = '1'
         IF l_cus1 IS NULL OR l_cus1 = ' ' THEN LET l_cus1 = 0 END IF
         LET l_cus2 = GROUP SUM(sr.nmh02) WHERE  sr.buck = '2'
         IF l_cus2 IS NULL OR l_cus2 = ' ' THEN LET l_cus2 = 0 END IF
         LET l_cus3 = GROUP SUM(sr.nmh02) WHERE  sr.buck = '3'
         IF l_cus3 IS NULL OR l_cus3 = ' ' THEN LET l_cus3 = 0 END IF
         LET l_cus4 = GROUP SUM(sr.nmh02) WHERE  sr.buck = '4'
         IF l_cus4 IS NULL OR l_cus4 = ' ' THEN LET l_cus4 = 0 END IF
         LET l_custot = l_cus1 + l_cus2 + l_cus3 + l_cus4
         IF l_cus1 = 0 THEN LET l_cus1 = NULL END IF
         IF l_cus2 = 0 THEN LET l_cus2 = NULL END IF
         IF l_cus3 = 0 THEN LET l_cus3 = NULL END IF
         IF l_cus4 = 0 THEN LET l_cus4 = NULL END IF
#No.FUN-580010  -begin
#        PRINT sr.nmh15,' ',sr.nmh11,' ',sr.nmh30 clipped,
#              column   39,cl_numfor(l_cus1,18,g_azi05) CLIPPED,   #區間一
#              column   65,cl_numfor(l_cus2,18,g_azi05) CLIPPED,   #區間二
#              column   87,cl_numfor(l_cus3,18,g_azi05) CLIPPED,   #區間三
#              column  109,cl_numfor(l_cus4,18,g_azi05) CLIPPED,   #區間四
#              column 131,cl_numfor(l_custot,18,g_azi05) CLIPPED  #小計
         PRINT COLUMN g_c[31], sr.nmh15,
               COLUMN g_c[32], sr.nmh11,
               COLUMN g_c[33], sr.nmh30,
               COLUMN g_c[34], cl_numfor(l_cus1,18,g_azi05) CLIPPED,   #區間一
               COLUMN g_c[35], cl_numfor(l_cus2,18,g_azi05) CLIPPED,   #區間二
               COLUMN g_c[36], cl_numfor(l_cus3,18,g_azi05) CLIPPED,   #區間三
               COLUMN g_c[37], cl_numfor(l_cus4,18,g_azi05) CLIPPED,   #區間四
               COLUMN g_c[38], cl_numfor(l_custot,18,g_azi05) CLIPPED  #小計
#No.FUN-580010  -end
 
 
   AFTER GROUP OF sr.nmh15    #部門
         LET l_nmh02_b1 = GROUP SUM(sr.nmh02) WHERE  sr.buck = '1'
         IF l_nmh02_b1 IS NULL OR l_nmh02_b1 = ' '
         THEN LET l_nmh02_b1 = 0
         END IF
         LET l_nmh02_b2 = GROUP SUM(sr.nmh02) WHERE  sr.buck = '2'
         IF l_nmh02_b2 IS NULL OR l_nmh02_b2 = ' '
         THEN LET l_nmh02_b2 = 0
         END IF
         LET l_nmh02_b3 = GROUP SUM(sr.nmh02) WHERE  sr.buck = '3'
         IF l_nmh02_b3 IS NULL OR l_nmh02_b3 = ' '
         THEN LET l_nmh02_b3 = 0
         END IF
         LET l_nmh02_b4 = GROUP SUM(sr.nmh02) WHERE  sr.buck = '4'
         IF l_nmh02_b4 IS NULL OR l_nmh02_b4 = ' '
         THEN LET l_nmh02_b4 = 0
         END IF
         LET l_tot = l_nmh02_b1 + l_nmh02_b2 + l_nmh02_b3 + l_nmh02_b4
 
         LET l_g1  = l_nmh02_b1 * g_nmz.nmz27 / 100
         LET l_g2  = l_nmh02_b2 * g_nmz.nmz28 / 100
         LET l_g3  = l_nmh02_b3 * g_nmz.nmz29 / 100
         LET l_g4  = l_nmh02_b4 * g_nmz.nmz30 / 100
         LET l_gsum = l_g1 + l_g2 + l_g3 + l_g4
         PRINT g_dash2[1,g_len]
         IF l_nmh02_b1 = 0 THEN LET l_nmh02_b1 = NULL END IF
         IF l_nmh02_b2 = 0 THEN LET l_nmh02_b2 = NULL END IF
         IF l_nmh02_b3 = 0 THEN LET l_nmh02_b3 = NULL END IF
         IF l_nmh02_b4 = 0 THEN LET l_nmh02_b4 = NULL END IF
#No.FUN-580010  -begin
#        PRINT column  21,g_x[15] clipped,
#              column  39,cl_numfor(l_nmh02_b1,18,g_azi05) CLIPPED, #區間一
#              column  65,cl_numfor(l_nmh02_b2,18,g_azi05) CLIPPED, #區間二
#              column  87,cl_numfor(l_nmh02_b3,18,g_azi05) CLIPPED, #區間三
#              column 109,cl_numfor(l_nmh02_b4,18,g_azi05) CLIPPED, #區間四
#              column 131,cl_numfor(l_tot,18,g_azi05)      CLIPPED  #小計
         PRINT COLUMN g_c[33],g_x[15] clipped,
               COLUMN g_c[34],cl_numfor(l_nmh02_b1,18,g_azi05) CLIPPED, #區間一
               COLUMN g_c[35],cl_numfor(l_nmh02_b2,18,g_azi05) CLIPPED, #區間二
               COLUMN g_c[36],cl_numfor(l_nmh02_b3,18,g_azi05) CLIPPED, #區間三
               COLUMN g_c[37],cl_numfor(l_nmh02_b4,18,g_azi05) CLIPPED, #區間四
               COLUMN g_c[38],cl_numfor(l_tot,18,g_azi05)      CLIPPED  #小計
#No.FUN-580010  -end
 
         IF l_g1 = 0 THEN LET l_g1 = NULL END IF
         IF l_g2 = 0 THEN LET l_g2 = NULL END IF
         IF l_g3 = 0 THEN LET l_g3 = NULL END IF
         IF l_g4 = 0 THEN LET l_g4 = NULL END IF
#No.FUN-580010  -begin
         PRINT COLUMN g_c[33],g_x[16];
               IF l_g1 IS NOT NULL THEN
#                 PRINT g_nmz.nmz27 using '#&.&#','% ',
                  PRINT COLUMN g_c[34],cl_numfor(l_g1,18,g_azi05) CLIPPED;
               END IF
               IF l_g2 IS NOT NULL THEN
#                 PRINT COLUMN  60,g_nmz.nmz28 using '#&.&#','% ',
                  PRINT COLUMN g_c[35],cl_numfor(l_g2,18,g_azi05) CLIPPED;
               END IF
               IF l_g3 IS NOT NULL THEN
#                 PRINT COLUMN  82,g_nmz.nmz29 using '#&.&#','% ',
                  PRINT COLUMN g_c[36],cl_numfor(l_g3,18,g_azi05) CLIPPED;
               END IF
               IF l_g4 IS NOT NULL THEN
#                 PRINT COLUMN  104,g_nmz.nmz30 using '#&.&#','% ',
                  PRINT COLUMN g_c[37],cl_numfor(l_g4,18,g_azi05) CLIPPED;
               END IF
         PRINT COLUMN g_c[38],cl_numfor(l_gsum,18,g_azi05) CLIPPED
         PRINT g_dash2[1,g_len]
#        PRINT column 21,g_x[16] clipped;
#              IF l_g1 IS NOT NULL THEN
#                 PRINT column  32,g_nmz.nmz27 using '#&.&#','% ',
#                       column 39,cl_numfor(l_g1,18,g_azi05) CLIPPED;
#              END IF
#              IF l_g2 IS NOT NULL THEN
#                 PRINT column  60,g_nmz.nmz28 using '#&.&#','% ',
#                       column 65,cl_numfor(l_g2,18,g_azi05) CLIPPED;
#              END IF
#              IF l_g3 IS NOT NULL THEN
#                 PRINT column  82,g_nmz.nmz29 using '#&.&#','% ',
#                       column 87,cl_numfor(l_g3,18,g_azi05) CLIPPED;
#              END IF
#              IF l_g4 IS NOT NULL THEN
#                 PRINT column  104,g_nmz.nmz30 using '#&.&#','% ',
#                       column 109,cl_numfor(l_g4,18,g_azi05) CLIPPED;
#              END IF
#        PRINT column 131,cl_numfor(l_gsum,18,g_azi05) CLIPPED
#        PRINT g_dash2[1,g_len]
#No.FUN-580010  -end
 
   ON LAST ROW
      #-----TQC-6B0189---------
      IF  g_zz05 = 'Y' THEN
          CALL cl_wcchp(tm.wc,'nmh15, nmh11, nmh10, nmh29')
               RETURNING tm.wc
          PRINT g_dash
          CALL cl_prt_pos_wc(tm.wc)
      END IF
      PRINT g_dash
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN(g_len-9), g_x[7] CLIPPED
      #-----END TQC-6B0189-----
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      #-----TQC-6B0189---------
      #IF g_pageno = 0 OR l_last_sw = 'y'
      #   THEN PRINT g_dash
      #        PRINT column 12,g_x[17] clipped,
      #              column 52,g_x[18] clipped,
      #              column 92,g_x[19] clipped
      #   ELSE SKIP 2 LINE
      #END IF
      IF l_last_sw = 'n' THEN
         PRINT g_dash
         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN(g_len-9), g_x[6] CLIPPED
      ELSE
         SKIP 2 LINE
      END IF
      #-----END TQC-6B0189-----
END REPORT
 
#-----MOD-640032---------
REPORT r270_rep2(sr)
   DEFINE  l_last_sw LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
           l_nmh03   LIKE nmh_file.nmh03,
           l_tot1    LIKE nmh_file.nmh02,
           l_tot2    LIKE nmh_file.nmh02,
           l_tot3    LIKE nmh_file.nmh02,
           l_tot4    LIKE nmh_file.nmh02
   DEFINE sr      RECORD
                  nmh15 LIKE nmh_file.nmh15,
                  nmh11 LIKE nmh_file.nmh11,
                  nmh30 LIKE nmh_file.nmh30,
                  nmh03 LIKE nmh_file.nmh03,
                  amt_1 LIKE nmh_file.nmh02,
                  amt_2 LIKE nmh_file.nmh02,
                  amt_3 LIKE nmh_file.nmh02,
                  amt_4 LIKE nmh_file.nmh02
                  END RECORD
   
 
  OUTPUT TOP MARGIN g_top_margin
  LEFT MARGIN g_left_margin
  BOTTOM MARGIN g_bottom_margin
  PAGE LENGTH g_page_line
  ORDER BY sr.nmh15,sr.nmh11,sr.nmh03
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
      PRINT
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT g_x[11] clipped,tm.sdate
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[39],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]  
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.nmh15
      PRINT COLUMN g_c[31],sr.nmh15;
 
   BEFORE GROUP OF sr.nmh11
      PRINT COLUMN g_c[32],sr.nmh11,
            COLUMN g_c[33],sr.nmh30 CLIPPED;
 
   BEFORE GROUP OF sr.nmh03
      PRINT COLUMN g_c[39],sr.nmh03;
 
   AFTER GROUP OF sr.nmh03
      PRINT COLUMN g_c[34], cl_numfor(sr.amt_1,34,g_azi05) CLIPPED,
            COLUMN g_c[35], cl_numfor(sr.amt_2,35,g_azi05) CLIPPED,
            COLUMN g_c[36], cl_numfor(sr.amt_3,36,g_azi05) CLIPPED,
            COLUMN g_c[37], cl_numfor(sr.amt_4,37,g_azi05) CLIPPED,
            COLUMN g_c[38], cl_numfor(sr.amt_1+sr.amt_2+sr.amt_3+sr.amt_4,38,g_azi05) CLIPPED
 
   AFTER GROUP OF sr.nmh15
      PRINT g_dash2
      PRINT COLUMN g_c[33],g_x[15] CLIPPED;
 
      DECLARE r270_c1 CURSOR FOR 
         SELECT nmh03,SUM(amt_1),SUM(amt_2),SUM(amt_3),SUM(amt_4)
           FROM r270_tmp 
           WHERE nmh15 = sr.nmh15  
           GROUP BY nmh03 ORDER BY nmh03
      FOREACH r270_c1 INTO l_nmh03,l_tot1,l_tot2,l_tot3,l_tot4
         IF cl_null(l_tot1) THEN LET l_tot1 = 0 END IF
         IF cl_null(l_tot2) THEN LET l_tot2 = 0 END IF
         IF cl_null(l_tot3) THEN LET l_tot3 = 0 END IF
         IF cl_null(l_tot4) THEN LET l_tot4 = 0 END IF
 
         PRINT COLUMN g_c[39],l_nmh03,
               COLUMN g_c[34],cl_numfor(l_tot1,34,g_azi05),
               COLUMN g_c[35],cl_numfor(l_tot2,35,g_azi05),
               COLUMN g_c[36],cl_numfor(l_tot3,36,g_azi05),
               COLUMN g_c[37],cl_numfor(l_tot4,37,g_azi05),
               COLUMN g_c[38],cl_numfor(l_tot1+l_tot2+l_tot3+l_tot4,38,g_azi05)
      END FOREACH
 
      PRINT COLUMN g_c[33],g_x[16];
      DECLARE r270_c2 CURSOR FOR 
         SELECT nmh03,SUM(amt_1),SUM(amt_2),SUM(amt_3),SUM(amt_4)
           FROM r270_tmp 
           WHERE nmh15 = sr.nmh15  
           GROUP BY nmh03 ORDER BY nmh03
      FOREACH r270_c2 INTO l_nmh03,l_tot1,l_tot2,l_tot3,l_tot4
         IF cl_null(l_tot1) THEN LET l_tot1 = 0 END IF
         IF cl_null(l_tot2) THEN LET l_tot2 = 0 END IF
         IF cl_null(l_tot3) THEN LET l_tot3 = 0 END IF
         IF cl_null(l_tot4) THEN LET l_tot4 = 0 END IF
 
         LET l_tot1 = l_tot1 * g_nmz.nmz27 / 100
         LET l_tot2 = l_tot2 * g_nmz.nmz27 / 100
         LET l_tot3 = l_tot3 * g_nmz.nmz27 / 100
         LET l_tot4 = l_tot4 * g_nmz.nmz27 / 100
 
         PRINT COLUMN g_c[39],l_nmh03,
               COLUMN g_c[34],cl_numfor(l_tot1,34,g_azi05),
               COLUMN g_c[35],cl_numfor(l_tot2,35,g_azi05),
               COLUMN g_c[36],cl_numfor(l_tot3,36,g_azi05),
               COLUMN g_c[37],cl_numfor(l_tot4,37,g_azi05),
               COLUMN g_c[38],cl_numfor(l_tot1+l_tot2+l_tot3+l_tot4,38,g_azi05)
      END FOREACH
 
      PRINT 
 
   ON LAST ROW
      #-----TQC-6B0189---------
      IF  g_zz05 = 'Y' THEN
          CALL cl_wcchp(tm.wc,'nmh15, nmh11, nmh10, nmh29')
               RETURNING tm.wc
          PRINT g_dash
          CALL cl_prt_pos_wc(tm.wc)
      END IF
      PRINT g_dash
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN(g_len-9), g_x[7] CLIPPED
      #-----END TQC-6B0189-----
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      #-----TQC-6B0189---------
      #IF g_pageno = 0 OR l_last_sw = 'y'
      #   THEN PRINT g_dash
      #        PRINT column 12,g_x[17] clipped,
      #              column 52,g_x[18] clipped,
      #              column 92,g_x[19] clipped
      #   ELSE SKIP 2 LINE
      #END IF
      IF l_last_sw = 'n' THEN
         PRINT g_dash 
         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN(g_len-9), g_x[6] CLIPPED
      ELSE
         SKIP 2 LINE   
      END IF
      #-----END TQC-6B0189-----
END REPORT
#-----END MOD-640032-----
#Patch....NO.TQC-610036 <001> #
