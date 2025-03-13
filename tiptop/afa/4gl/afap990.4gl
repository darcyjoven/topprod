# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: afap990.4gl
# Descriptions...: 固定資產投資抵減媒體產生作業
# Input parameter:
# Return code....:
# Date & Author..: 96/03/15 By Lynn
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.MOD-730146 07/04/12 By claire zo12改zo02
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
		fcb01 	LIKE fcb_file.fcb01,	# Where condition		
		a       LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(16)
		b       LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(16)
		c       LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(10)
		d       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
		e       LIKE type_file.chr50, 		       #No.FUN-680070 VARCHAR(50)
                f       LIKE type_file.num10        #No.FUN-680070 INTEGER
              END RECORD,
          g_addr        LIKE zo_file.zo041
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
 
   LET g_trace = 'N'		             # default trace off
   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.fcb01 = ARG_VAL(7)
   LET tm.a     = ARG_VAL(8)
   LET tm.b     = ARG_VAL(9)
   LET tm.c     = ARG_VAL(10)
   LET tm.e     = ARG_VAL(11)
   LET tm.f     = ARG_VAL(12)
   #------------------------------
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL p990_tm(0,0)                        # Input print condition
   ELSE
      CALL afap990()                           # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION p990_tm(p_row,p_col)
 DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        l_n             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        l_cmd		LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
 
   OPEN WINDOW p990_w AT p_row,p_col
     WITH FORM "afa/42f/afap990"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   INITIALIZE tm.* TO NULL			# Default condition
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.d = 'Y'
   LET tm.e = ''
 
   WHILE TRUE
      DISPLAY BY NAME tm.a,tm.b,tm.c,tm.d,tm.e,tm.f
 
      INPUT BY NAME tm.fcb01,tm.a,tm.b,tm.c,tm.d,tm.e,tm.f WITHOUT DEFAULTS
 
         AFTER FIELD fcb01
            IF cl_null(tm.fcb01) THEN NEXT FIELD fcb01 END IF
 
         AFTER FIELD a
            IF cl_null(tm.a) THEN NEXT FIELD a END IF
 
         AFTER FIELD b
            IF cl_null(tm.b) THEN NEXT FIELD b END IF
 
         AFTER FIELD c
            IF cl_null(tm.c) THEN NEXT FIELD c END IF
 
         AFTER FIELD d
            IF cl_null(tm.d) OR tm.d NOT MATCHES '[YyNn]' THEN
               NEXT FIELD d
            ELSE
               IF tm.d MATCHES '[Yy]' THEN
                  SELECT zo041 INTO g_addr FROM zo_file WHERE zo01=g_rlang
                  NEXT FIELD f
               ELSE
                  NEXT FIELD e
               END IF
            END IF
 
         AFTER FIELD e
            IF cl_null(tm.e) AND  tm.d MATCHES '[Nn]' THEN NEXT FIELD e END IF
 
         AFTER FIELD f
            IF cl_null(tm.f) OR tm.f < 0 THEN NEXT FIELD f END IF
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
       ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p990_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
 
      IF NOT cl_sure(18,20) THEN
         CLOSE WINDOW p990_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
 
      CALL afap990()
 
      ERROR ""
 
   END WHILE
   CLOSE WINDOW p990_w
 
END FUNCTION
 
FUNCTION afap990()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0069
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT       #No.FUN-680070 VARCHAR(600)
          l_chr		LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          sr            RECORD
             fcb01      LIKE fcb_file.fcb01,
             fcb02      LIKE fcb_file.fcb02,
             fcb06      LIKE fcb_file.fcb06,
             fcc02      LIKE fcc_file.fcc02,
             fcc07      LIKE fcc_file.fcc07,
             fcc05      LIKE fcc_file.fcc05,
             fcc06      LIKE fcc_file.fcc06,
             fcc09      LIKE fcc_file.fcc09,
             fcc14      LIKE fcc_file.fcc14,
             fcc13      LIKE fcc_file.fcc13,
             fcc11      LIKE fcc_file.fcc11,
             fcc08      LIKE fcc_file.fcc08,
             fcc17      LIKE fcc_file.fcc17,
             fcc18      LIKE fcc_file.fcc18,
             fcc19      LIKE fcc_file.fcc19,
             fcc12      LIKE fcc_file.fcc12
                        END RECORD
 
 
    LET l_sql = "SELECT fcb01,fcb02,fcb06,fcc02,fcc07,",
                "fcc05,fcc06,fcc09,fcc14,fcc13,fcc11,fcc08,",
                "fcc17,fcc18,fcc19,fcc12",
                " FROM fcb_file,fcc_file",
                " WHERE fcb01=fcc01 " ,
                "   AND fcb01= '",tm.fcb01,"'",
                "   AND fcbconf = 'N' ",
                "  ORDER BY fcb02,fcc02"
    PREPARE p990_prepare FROM l_sql
 
    IF STATUS THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       RETURN
    END IF
 
    DECLARE p990_cs CURSOR FOR p990_prepare
 
    LET g_success='Y'
 
    BEGIN WORK
 
    LET l_name = tm.fcb01 CLIPPED,'.txt'
 
    START REPORT p990_rep TO l_name
 
#   LET g_pageno = 0
 
    FOREACH p990_cs INTO sr.*
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF
 
       OUTPUT TO REPORT p990_rep(sr.*)
 
    END FOREACH
 
    FINISH REPORT p990_rep
 
    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
    IF g_success ='Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
 
END FUNCTION
 
REPORT p990_rep(sr)
DEFINE l_last_sw     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_char        LIKE type_file.chr3,         #No.FUN-680070 VARCHAR(3)
       i             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       l_year        LIKE type_file.chr3,         #No.FUN-680070 VARCHAR(3)
       l_month       LIKE type_file.chr2,         #No.FUN-680070 VARCHAR(2)
       l_day         LIKE type_file.chr2,         #No.FUN-680070 VARCHAR(2)
       l_date        LIKE type_file.chr8,         #No.FUN-680070 VARCHAR(7)
       l_year17      LIKE type_file.chr3,         #No.FUN-680070 VARCHAR(3)
       l_month17     LIKE type_file.chr2,         #No.FUN-680070 VARCHAR(2)
       l_day17       LIKE type_file.chr2,         #No.FUN-680070 VARCHAR(2)
       l_date17      LIKE type_file.chr8,         #No.FUN-680070 VARCHAR(7)
       l_year18      LIKE type_file.chr3,         #No.FUN-680070 VARCHAR(3)
       l_month18     LIKE type_file.chr2,         #No.FUN-680070 VARCHAR(2)
       l_day18       LIKE type_file.chr2,         #No.FUN-680070 VARCHAR(2)
       l_date18     LIKE type_file.chr8,         #No.FUN-680070 VARCHAR(7)
       l_year19      LIKE type_file.chr3,         #No.FUN-680070 VARCHAR(3)
       l_month19     LIKE type_file.chr2,         #No.FUN-680070 VARCHAR(2)
       l_day19       LIKE type_file.chr2,         #No.FUN-680070 VARCHAR(2)
       l_date19      LIKE type_file.chr8,         #No.FUN-680070 VARCHAR(7)
       l_j           LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       l_zo02        LIKE zo_file.zo02,   #MOD-730146
       l_zo041       LIKE zo_file.zo041,
       l_zo05        LIKE zo_file.zo05,
       l_tel         LIKE zo_file.zo05,
       l_zo06        LIKE zo_file.zo06,
       sr   RECORD
            fcb01      LIKE fcb_file.fcb01,
            fcb02      LIKE fcb_file.fcb02,
            fcb06      LIKE fcb_file.fcb06,
            fcc02      LIKE fcc_file.fcc02,
            fcc07      LIKE fcc_file.fcc07,
            fcc05      LIKE fcc_file.fcc05,
            fcc06      LIKE fcc_file.fcc06,
            fcc09      LIKE fcc_file.fcc09,
            fcc14      LIKE fcc_file.fcc14,
            fcc13      LIKE fcc_file.fcc13,
            fcc11      LIKE fcc_file.fcc11,
            fcc08      LIKE fcc_file.fcc08,
            fcc17      LIKE fcc_file.fcc17,
            fcc18      LIKE fcc_file.fcc18,
            fcc19      LIKE fcc_file.fcc19,
            fcc12      LIKE fcc_file.fcc12
            END RECORD
 
  OUTPUT LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         TOP MARGIN g_top_margin
 
  ORDER BY sr.fcb01,sr.fcc02
 
  FORMAT
 
    PAGE HEADER
      LET l_year = YEAR(sr.fcb02)-1911 USING '&&&'
      LET l_month = MONTH(sr.fcb02) USING '&&'
      LET l_day = DAY(sr.fcb02) USING '&&'
      LET l_date = l_year,l_month,l_day
      SELECT zo02,zo041,zo05,zo06 INTO l_zo02,l_zo041,l_zo05,l_zo06   #MOD-730146 modify
        FROM zo_file WHERE zo01=g_rlang
      LET l_j = length(l_zo05)
      FOR i = 1 TO l_j
        IF l_zo05[i,i] = '-' THEN
           LET l_tel = ''
           LET l_tel = l_zo05[i+1,l_j]
           EXIT FOR
        END IF
      END FOR
 
      LET l_char = '@&@'
      PRINT l_date,l_char,'130000',l_char,sr.fcb06 CLIPPEd,l_char,'0028',l_char,'1',l_char,
            l_char,l_zo02 CLIPPED,l_char,'303',l_char,l_zo041 CLIPPED,l_char,l_char,   #MOD-730146 modify
            l_zo06 CLIPPED,l_char,g_addr CLIPPED,l_char,tm.a CLIPPED,l_char,tm.b CLIPPED,
            l_char,'03',l_char,l_tel CLIPPED,l_char,tm.c CLIPPED,l_char,l_char,l_char,
            l_char,l_char,l_char,l_char,l_char,l_char,l_char,l_char,l_char,
            tm.f*1000 USING '<<<<<<<<&',l_char,'1',l_char,l_char,l_char,
            l_char,l_char,l_char,l_char,l_char,l_char,l_char,l_char,l_char,
            l_char,l_char,l_char,l_char,l_char,l_char,l_char,l_char,
            l_char,l_char,'0',l_char,l_date,l_char,'1305',l_char
 
    ON EVERY ROW
      # 訂購日期
      LET l_year17 = YEAR(sr.fcc17)-1911 USING '&&&'
      LET l_month17 = MONTH(sr.fcc17) USING '&&'
      LET l_day17 = DAY(sr.fcc17) USING '&&'
      LET l_date17 = l_year,l_month,l_day17
      # 交貨日期
      LET l_year18 = YEAR(sr.fcc18)-1911 USING '&&&'
      LET l_month18 = MONTH(sr.fcc18) USING '&&'
      LET l_day18 = DAY(sr.fcc18) USING '&&'
      LET l_date18 = l_year18,l_month18,l_day18
      # 預定完成日
      LET l_year19 = YEAR(sr.fcc19)-1911 USING '&&&'
      LET l_month19 = MONTH(sr.fcc19) USING '&&'
      LET l_day19 = DAY(sr.fcc19) USING '&&'
      LET l_date19 = l_year19,l_month19,l_day19
 
      PRINT l_date,l_char,'0028',l_char,'1',l_char,sr.fcc02 USING '&&&',l_char,l_char,l_char,l_char,
            sr.fcc07 CLIPPED,l_char,sr.fcc05 CLIPPED,l_char,sr.fcc06 CLIPPED,l_char,sr.fcc07 CLIPPED,
            l_char,l_char,sr.fcc09 USING '<<&.&&',l_char,sr.fcc14[1,2],l_char,
            sr.fcc13 USING '<<<<<<<<&.&&',l_char,sr.fcc09*sr.fcc13 USING '<<<<<<<<&.&&',l_char,
            l_char,l_char,l_char,'2',l_char,sr.fcc11 CLIPPED,l_char,'1',l_char,sr.fcc08 CLIPPED,
            l_char,l_date17,l_char,l_date18,l_char,l_date19,l_char,'10',l_char,'0.00',l_char,'0.00',
            l_char,sr.fcc12 CLIPPED,l_char,l_date,l_char,'1305',l_char
 
END REPORT
 
#Patch....NO.TQC-610035 <001> #
