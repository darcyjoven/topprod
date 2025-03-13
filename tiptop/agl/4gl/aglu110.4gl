# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aglu110.4gl
# Descriptions...: 歷史傳票資料清除作業
# Input parameter:
# Return code....:
# Date & Author..: 92/05/27 By Lee
#                  By Melody    unload 加入 abapost="Y" 條件
# Modify.........: No.FUN-680098 06/09/04 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.TQC-740027 07/04/13 By Smapmin 無法下載
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B40056 11/06/03 By guoch 刪除資料時一併刪除tic_file的資料
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
	tm  RECORD					#CONDITION RECORD
		wc        LIKE type_file.chr1000,       #Where Condiction     #No.FUN-680098 VARCHAR(300) 
		download  LIKE type_file.chr1,          #DownLoad Data?       #No.FUN-680098 VARCHAR(1) 
		file_name LIKE type_file.chr3,          #DownLoad File Name   #No.FUN-680098 VARCHAR(3) 
		file_extension  LIKE type_file.dat,  	#DownLoad File Extension  #No.FUN-680098 smallint
		backup    LIKE type_file.chr1,  	#Backup Data?        #No.FUN-680098 VARCHAR(1) 
		backup_device LIKE type_file.chr1,  	#Backup Device (1.Tape 2.Floppy)  #No.FUN-680098 VARCHAR(1) 
		cleanup   LIKE type_file.chr1,  		#CleanUp Date?     #No.FUN-680098 VARCHAR(1) 
		more      LIKE type_file.chr1  		#是否輸入其它特殊列印條件  #No.FUN-680098 VARCHAR(1) 
		END RECORD,
	g_file_extension   LIKE type_file.chr6,         #No.FUN-680098 VARCHAR(6) 
	g_bookno           LIKE aba_file.aba00          #帳別編號
 
DEFINE   g_chr             LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1) 
DEFINE   g_tempdir       STRING     #$TEMPDIR路徑   #TQC-740027
DEFINE   g_file          STRING     #下載下來檔案的全路徑   #TQC-740027
DEFINE   g_select        STRING     #SELECT 條件   #TQC-740027
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
 
 
  LET g_bookno=g_aaz.aaz64   #TQC-740027
  LET g_tempdir = FGL_GETENV("TEMPDIR")   #TQC-740027
 
	#initialize program
 
	IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN	# If background job sw is off
		CALL u110_tm()						# Input condition
	ELSE
		CALL aglu110()						# Read data and process it
	END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION u110_tm()
DEFINE
	p_row,p_col	LIKE type_file.num5,          #No.FUN-680098 SMALLINT
	l_cmd		LIKE type_file.chr1000,       #No.FUN-680098 VARCHAR(400) 
	l_warn          LIKE type_file.num5,          #No.FUN-680098 smallint
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
	OPEN WINDOW u110_w AT p_row,p_col
		WITH FORM "agl/42f/aglu110"
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
	LET tm.file_name='aba'
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
		CONSTRUCT tm.wc
			ON aba02,aba03,aba04,aba01
			FROM invoice_date,years,period,invoice_number
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
				WHERE zz01='aglu110'
			IF SQLCA.sqlcode OR l_cmd IS NULL THEN
				CALL cl_err('aglu110','9031',1)
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
				CALL cl_cmdat('aglu110',g_time,l_cmd)
			END IF
			CLOSE WINDOW u110_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
			EXIT PROGRAM
		END IF
#		CALL cl_wait()
		CALL aglu110()
		ERROR ""
	END WHILE
	CLOSE WINDOW u110_w
END FUNCTION
 
FUNCTION aglu110()
DEFINE
	l_status   LIKE type_file.num5,      #No.FUN-680098  SMALLINT
	l_aba00 LIKE aba_file.aba00,        #No.FUN-680098 INT # saki 20070821 rowid chr18 -> num10 
	l_aba01 LIKE aba_file.aba01,
	l_file_name1 LIKE type_file.chr20,   #No.FUN-680098  VARCHAR(15) 
	l_file_name2 LIKE type_file.chr20,   #No.FUN-680098  VARCHAR(15)  
	l_file_name3 LIKE type_file.chr20,   #No.FUN-680098  VARCHAR(15) 
	l_sql LIKE type_file.chr1000       #No.FUN-680098  VARCHAR(500) 
 
	IF tm.download='N'
		AND tm.backup='N'
		AND tm.cleanup='N' THEN
		RETURN
	END IF
 
	IF g_bgjob='N' THEN
		IF NOT cl_sure(16,19) THEN RETURN END IF
	END IF
 
	LET l_file_name1=tm.file_name CLIPPED,'_',g_file_extension CLIPPED
	LET l_file_name2=l_file_name1 CLIPPED,'_b'
	LET l_file_name3=l_file_name1 CLIPPED,'_n'
#	***Note***
#	若您更改本部份, 則請注意單引號及雙引號的使用,
#	因為當您將它傳給shell解釋時, 會產生不同的效果。詳細內容, 請讀下列資料:
#   Quoting (節錄自ksh的manual)
#   Each of the specified metacharacters (See ``Definitions'' above) has a
#   special meaning to the shell and causes termination of a word unless
#   quoted.  A character may be quoted (that is, made to stand for itself) by
#   preceding it with a backslash (\).  The pair ``\<Enter>'' is ignored.
#   All characters enclosed between a pair of single quote marks (' ') are
#   quoted.  A single quote cannot appear within single quotes.  Inside dou-
#   ble quote marks (""), parameter and command substitution occur and ``\''
#   quotes the characters \, ', " and $.  The meaning of $* and $@ is identi-
#   cal when not quoted or when used as a parameter assignment value or as a
#   file name.  However, when used as a command argument, $* is equivalent to
#   "$1d$2d...", where d is the first character of the IFS parameter, whereas
#   $@ is equivalent to "$1" "$2"....  Inside grave quote marks (` `) \
#   quotes the characters \, `, and $.  If the grave quotes occur within dou-
#   ble quotes then \ also quotes the character ".
#   The special meaning of reserved words or aliases can be removed by quot-
#   ing any character of the reserved word.  The recognition of function
#   names or special command names listed below cannot be altered by quoting
#   them.
#--->使用單引號將資料括起來傳給shell, 以防止其將某些字元拿來作解釋(例如*)
#    (若使用雙引號時, shell會解釋傳遞的參數及命令的取代,Inside double quote
#     marks (""), parameter and command substitution occur and ``\'' quotes
#     the characters \, ', " and $.) 但是單引號中不能再有單引號(A single
#     quote cannot appear within single quotes,) 故此, 需將字串使用雙引號括
#     起來
#
	IF tm.download='Y' THEN
                #-----TQC-740027---------
		#單頭
                LET g_file = g_tempdir,'/',l_file_name1
                LET g_select = 
                       " SELECT * FROM aba_file ",
                       "   WHERE  abapost = 'Y' AND aba00 = '",g_bookno,"'",
                       "     AND ",tm.wc CLIPPED
                LET l_sql = 'unloadx ',g_dbs,' ',g_file,' "',g_select,'"'
                RUN l_sql RETURNING l_status
                IF l_status THEN 
                   CALL cl_err('','agl-311',1)
                   RETURN 
                ELSE 
                   CALL cl_err('','agl-314',1)
                END IF
		#單身
                LET g_file = g_tempdir,'/',l_file_name2
                LET g_select = 
                       " SELECT * FROM aba_file,abb_file ",
                       "   WHERE abb01=aba01 AND abb00=aba00 ",
                       "     AND abapost = 'Y' AND aba00 = '",g_bookno,"'",
                       "     AND ",tm.wc CLIPPED
                LET l_sql = 'unloadx ',g_dbs,' ',g_file,' "',g_select,'"'
                RUN l_sql RETURNING l_status
                IF l_status THEN 
                   CALL cl_err('','agl-312',1)
                   RETURN 
                ELSE
                   CALL cl_err('','agl-315',1)
                END IF
		#額外摘要
                LET g_file = g_tempdir,'/',l_file_name3
                LET g_select = 
                       " SELECT * FROM aba_file,abc_file ",
                       "   WHERE abc01=aba01 AND abc00=aba00 ",
                       "     AND abapost = 'Y' AND aba00 = '",g_bookno,"'",
                       "     AND ",tm.wc CLIPPED
                LET l_sql = 'unloadx ',g_dbs,' ',g_file,' "',g_select,'"'
                RUN l_sql RETURNING l_status
                IF l_status THEN 
                   CALL cl_err('','agl-313',1)
                   RETURN 
                ELSE
                   CALL cl_err('','agl-316',1)
                END IF
                ##單頭
                #LET l_sql=
                #        "unload '",l_file_name1,
                #        " select * from aba_file",
                #        ' where abapost="Y" ans aba00="',g_bookno,
                #        '" and ',tm.wc CLIPPED,"'"
                #RUN l_sql RETURNING l_status
                #IF l_status THEN RETURN END IF
                #
                ##單身
                #LET l_sql=
                #        "unload '",l_file_name2,
                #        " select abb_file.* from aba_file,abb_file",
                #        ' where abb01=aba01 and abb00=aba00',
                #        ' and abapost="Y" and aba00="',g_bookno,
                #        '" and ',tm.wc CLIPPED,"'"
                #RUN l_sql RETURNING l_status
                #IF l_status THEN RETURN END IF
                #
                ##額外摘要
                #LET l_sql=
                #        "unload '",l_file_name3,
                #        " select abc_file.* from aba_file,abc_file",
                #        ' where abc01=aba01 and abc00=aba00',
                #        ' and abapost="Y" and aba00="',g_bookno,
                #        '" and ',tm.wc CLIPPED,"'"
                #RUN l_sql RETURNING l_status
                #IF l_status THEN RETURN END IF
	END IF
 
	IF tm.backup='Y' THEN
		LET l_sql="back_data ",tm.backup_device,		#1.Device
			" ",g_bgjob,								#2.bgjob
			" ",l_file_name1," ",l_file_name2,			#3.file name
			" ",l_file_name3
		RUN l_sql RETURNING l_status
		IF l_status THEN RETURN END IF
	END IF
 
	IF tm.cleanup='Y' THEN
		MESSAGE "delete data ..."
		LET l_sql="SELECT aba00,aba01",
			" FROM aba_file ",
			" where abapost='Y'",
			" and aba00='",g_bookno,
			"' and ",tm.wc CLIPPED
		PREPARE u110_p000 FROM l_sql
		IF SQLCA.sqlcode THEN RETURN END IF
		DECLARE u110_curh CURSOR FOR u110_p000
		IF SQLCA.sqlcode THEN RETURN END IF
 
		LET l_sql= "DELETE FROM abc_file WHERE abc00=? AND abc01=?"
		PREPARE u110_dabc FROM l_sql
		IF SQLCA.sqlcode THEN RETURN END IF
 
		LET l_sql= "DELETE FROM abb_file WHERE abb00=? AND abb01=?"
		PREPARE u110_dabb FROM l_sql
		IF SQLCA.sqlcode THEN RETURN END IF
 
		LET l_sql= "DELETE FROM aba_file WHERE aba00 = ? AND aba01 = ?"
		PREPARE u110_daba FROM l_sql
		IF SQLCA.sqlcode THEN RETURN END IF

#FUN-B40056 -begin 
    LET l_sql= "DELETE FROM tic_file WHERE tic00 = ? AND tic04 = ?"
		PREPARE u110_dtic FROM l_sql
		IF SQLCA.sqlcode THEN RETURN END IF
#FUN-B40056 -end
 
		LET l_status=0
		FOREACH u110_curh INTO l_aba00,l_aba01
			IF g_bgjob='N' THEN
				MESSAGE 'Delete ...',l_aba01
			END IF
			LET l_status=l_status+1
 
			EXECUTE u110_dabc USING g_bookno,l_aba01
			IF SQLCA.sqlcode THEN CONTINUE FOREACH END IF
 
			EXECUTE u110_dabb USING g_bookno,l_aba01
			IF SQLCA.sqlcode THEN CONTINUE FOREACH END IF
			
#FUN-B40056 -begin
      EXECUTE u110_dtic USING g_bookno,l_aba01
			IF SQLCA.sqlcode THEN CONTINUE FOREACH END IF
#FUN-B40056 -end
 
			EXECUTE u110_daba USING l_aba00,l_aba01
		END FOREACH
            LET INT_FLAG = 0  ######add for prompt bug
		PROMPT l_status ," ROW(S) DELETED ..." FOR g_chr
		   ON IDLE g_idle_seconds
		      CALL cl_on_idle()
#		      CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
		
		END PROMPT
	END IF
END FUNCTION
#Patch....NO.TQC-610035 <001> #
