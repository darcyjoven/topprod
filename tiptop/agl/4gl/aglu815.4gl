# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aglu815.4gl
# Descriptions...: 異動明細資料清除作業
# Input parameter:
# Return code....:
# Date & Author..: 92/05/26 By Lee
# Modify.........: No.FUN-680098 06/09/04 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
	tm  RECORD					#CONDITION RECORD
		wc        LIKE type_file.chr1000,	#Where Condiction   #No.FUN-680098  VARCHAR(300) 
		download  LIKE type_file.chr1,  	#DownLoad Data?             #No.FUN-680098  VARCHAR(1) 
		file_name LIKE type_file.chr3,  	#DownLoad File Name         #No.FUN-680098  VARCHAR(3) 
		file_extension LIKE type_file.dat,   	#DownLoad File Extension            #No.FUN-680098  date
		backup    LIKE type_file.chr1,  	#Backup Data?       #No.FUN-680098  VARCHAR(1) 
		backup_device LIKE type_file.chr1,  	#Backup Device (1.Tape 2.Floppy)#No.FUN-680098  VARCHAR(1) 
		cleanup   LIKE type_file.chr1,  	#CleanUp Date?#No.FUN-680098  VARCHAR(1) 
		more      LIKE type_file.chr1  		#是否輸入其它特殊列印條件   #No.FUN-680098  VARCHAR(1) 
		END RECORD,
	g_file_extension  LIKE type_file.chr8,          #No.FUN-680098  VARCHAR(6) 
	g_bookno  LIKE aba_file.aba00 #帳別編號
 
MAIN
	#set up options
	OPTIONS
  INPUT NO WRAP
	DEFER INTERRUPT					# Supress DEL key function
 
    IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
 
 
	#initialize program
 
	IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN	# If background job sw is off
		CALL u815_tm()						# Input condition
	ELSE
		CALL aglu815()						# Read data and process it
	END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION u815_tm()
DEFINE
	p_row,p_col	LIKE type_file.num5,          #No.FUN-680098 SMALLINT
	l_cmd		LIKE type_file.chr1000,       #No.FUN-680098 VARCHAR(400) 
	l_warn    LIKE type_file.num5,                #No.FUN-680098 smallint 
	l_direction  LIKE type_file.chr1,             #No.FUN-680098 VARCHAR(1) 
	l_jmp_flag LIKE type_file.chr1                #No.FUN-680098 VARCHAR(1) 
 
	#set up screen
	CALL s_dsmark(g_bookno)
	LET p_row=52
	LET p_col=40-(p_row/2)
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4
      LET p_col = 30
   ELSE LET p_row = 4
   END IF
	OPEN WINDOW u815_w AT p_row,p_col
		WITH FORM "agl/42f/aglu815"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
 
 
	CALL s_shwact(0,0,g_bookno)
	CALL cl_opmsg('p')
 
	#initialize program variables
	INITIALIZE tm.* TO NULL
	LET tm.download='N'
	LET tm.file_name='aah'
	LET tm.file_extension=g_today USING 'YYMMDD'
	LET tm.backup='N'
	LET tm.cleanup='N'
	LET tm.more='Y'
	LET g_pdate=g_today
	LET g_rlang=g_lang
	LET g_bgjob='N'
	LET g_copies='1'
	LET l_jmp_flag='N'
 
	WHILE TRUE
		CONSTRUCT BY NAME tm.wc ON aah02,aah03
       ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
END CONSTRUCT
		IF INT_FLAG THEN
			LET INT_FLAG = 0 EXIT WHILE
		END IF
 
		DISPLAY BY NAME
			tm.download,tm.file_name,tm.file_extension,
			tm.backup,tm.backup_device,tm.cleanup,tm.more
			
		LET l_warn=1
 
		INPUT BY NAME
			tm.download,tm.file_name,tm.file_extension,
			tm.backup,tm.backup_device,tm.cleanup,tm.more
			
 
			BEFORE FIELD file_name
				IF tm.download='N' THEN
					NEXT FIELD cleanup
				END IF
 
			BEFORE FIELD file_extension
				IF tm.download='N' THEN
					NEXT FIELD download
				END IF
 
			AFTER FIELD file_extension
				LET g_file_extension=tm.file_extension USING 'YYMMDD'
				DISPLAY g_file_extension TO file_extension
 
			AFTER FIELD backup
				LET l_direction='D'
 
			BEFORE FIELD backup_device
				IF tm.download='N' THEN
					NEXT FIELD download
				END IF
				IF tm.backup='N' THEN
					IF l_direction='D' THEN
						NEXT FIELD cleanup
					ELSE
						NEXT FIELD backup
					END IF
				END IF
 
			AFTER FIELD cleanup
				LET l_direction='U'
 
			AFTER FIELD more
				IF tm.more NOT MATCHES "[YN]" THEN
					NEXT FIELD more
				END IF
				IF tm.more = 'N' THEN
					CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
						g_bgjob,g_time,g_prtway,g_copies)
						RETURNING g_pdate,g_towhom,g_rlang,
						g_bgjob,g_time,g_prtway,g_copies
				END IF
 
			AFTER INPUT
				IF tm.download='N'
					AND tm.backup='N'
					AND tm.cleanup='N' THEN
					IF l_warn THEN
						CALL cl_err('','agl-120',0)
						LET l_warn=0
						NEXT FIELD download
					END IF
				END IF
 
                   ON ACTION CONTROLR
                      CALL cl_show_req_fields()
                   ON ACTION CONTROLG
                      CALL cl_cmdask()	# Command execution
                   ON IDLE g_idle_seconds
		      CALL cl_on_idle()
		      CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
		
		END INPUT
 
		IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
 
		IF g_bgjob = 'Y' THEN
			SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
				WHERE zz01='aglu815'
			IF SQLCA.sqlcode OR l_cmd IS NULL THEN
				CALL cl_err('aglu815','9031',1)
			ELSE
				LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
					" '",g_bookno CLIPPED,"'",
					" '",g_pdate CLIPPED,"'",
					" '",g_towhom CLIPPED,"'",
					" '",g_lang CLIPPED,"'",
					" '",g_bgjob CLIPPED,"'",
					" '",g_prtway CLIPPED,"'",
					" '",g_copies CLIPPED,"'",
					" '",tm.wc CLIPPED,"'",
					" '",tm.download CLIPPED,"'",
					" '",tm.file_name CLIPPED,"'",
					" '",tm.file_extension CLIPPED,"'",
					" '",tm.backup CLIPPED,"'",
					" '",tm.backup_device CLIPPED,"'"
				CALL cl_cmdat('aglu815',g_time,l_cmd)
			END IF
			CLOSE WINDOW u815_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
			EXIT PROGRAM
		END IF
		CALL cl_wait()
		CALL aglu815()
		ERROR ""
	END WHILE
	CLOSE WINDOW u815_w
END FUNCTION
 
FUNCTION aglu815()
DEFINE
	l_status   LIKE type_file.num5,   #No.FUN-680098  SMALLINT
	l_sql      LIKE type_file.chr1000 #No.FUN-680098  VARCHAR(500)
 
	IF tm.download='N'
		AND tm.backup='N'
		AND tm.cleanup='N' THEN
		RETURN
	END IF
 
	IF g_bgjob='N' THEN
		IF NOT cl_sure(0,0) THEN RETURN END IF
	END IF
 
	IF tm.download='Y' THEN
		LET l_sql=
			"unload '",tm.file_name CLIPPED,
			'_',g_file_extension CLIPPED,
			" select * from aah_file",
			' where aah00="',g_bookno,'" and ',tm.wc CLIPPED,
			"'"
		RUN l_sql RETURNING l_status
		IF l_status THEN RETURN END IF
	END IF
 
	IF tm.backup='Y' THEN
		LET l_sql="back_data ",tm.backup_device," ",	#device
			" ",g_bgjob,								#bgjob
			tm.file_name,"_",g_file_extension			#file_name
		RUN l_sql RETURNING l_status
		IF l_status THEN RETURN END IF
	END IF
 
	IF tm.cleanup='Y' THEN
		MESSAGE "delete data ..."
		LET l_sql="DELETE FROM aah_file ",
			" WHERE aah00='",g_bookno,"' AND ",tm.wc CLIPPED
		PREPARE u815_del FROM l_sql
		IF SQLCA.sqlcode THEN RETURN END IF
		EXECUTE u815_del
		IF g_bgjob='N' THEN
            LET INT_FLAG = 0  ######add for prompt bug
			PROMPT SQLCA.SQLERRD[3]," ROW(S) DELETED ..." FOR l_status
			   ON IDLE g_idle_seconds
			      CALL cl_on_idle()
#			      CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
			
			END PROMPT
		END IF
	END IF
END FUNCTION
#Patch....NO.TQC-610035 <001> #
