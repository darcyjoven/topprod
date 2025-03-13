# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: anmu101.4gl
# Descriptions...: 應付票據異動記錄清除作業
# Date & Author..: 92/06/08 By MAY
# Modify.........: No.FUN-680107 06/09/07 By ice 欄位類型修改
#
 
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.MOD-940337 09/04/27 By lilingyu tm.more的預設值改成 N
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/01By yangtingting   1、離開MAIN時沒有cl_used(1)和cl_used(2)
#                                                           2、未加離開前得cl_used(2) 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
	tm  RECORD                              #CONDITION RECORD
            wc           LIKE type_file.chr1000,#Where Condiction #No.FUN-680107 VARCHAR(300)
	    download     LIKE type_file.chr1,   #DownLoad Data? #No.FUN-680107 VARCHAR(1)
	    backup       LIKE type_file.chr1,   #Backup Data? #No.FUN-680107 VARCHAR(1)
	    cleanup      LIKE type_file.chr1,   #CleanUp Date? #No.FUN-680107 VARCHAR(1)
	    more         LIKE type_file.chr1    #是否輸入其它特殊列印條件 #No.FUN-680107 VARCHAR(1)
	END RECORD,
	g_file_extension LIKE aab_file.aab02    #No.FUN-680107 VARCHAR(6)
DEFINE  g_chr            LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
MAIN
	#set up options
	OPTIONS
  INPUT NO WRAP
	DEFER INTERRUPT		                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
   CALL u101_tm()
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211 
END MAIN
 
FUNCTION u101_tm()
DEFINE
   p_row,p_col LIKE type_file.num5,   #No.FUN-680107 SMALLINT
   l_cmd       LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(400)
   l_warn      LIKE type_file.num5,   #No.FUN-680107 SMALLINT
   l_direction LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
   l_jmp_flag  LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   LET p_row = 4
   LET p_col = 30
   OPEN WINDOW u101_w AT p_row,p_col
	WITH FORM "anm/42f/anmu101"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
	CALL cl_opmsg('p')
 
	#initialize program variables
	INITIALIZE tm.* TO NULL
	LET tm.download='N'
       #LET tm.file_name='nmf'
       #LET tm.file_extension=g_today USING 'YYMMDD'
	LET tm.backup='N'
	LET tm.cleanup='N'
#	LET tm.more='Y'  #MOD-940337
	LET tm.more='N'  #MOD-940337
	LET g_pdate=g_today
	LET g_rlang=g_lang
	LET g_bgjob='N'
	LET g_copies='1'
	LET l_jmp_flag='N'
 
	WHILE TRUE
	CONSTRUCT BY NAME tm.wc ON nmf02
	   ON IDLE g_idle_seconds
	      CALL cl_on_idle()
	      CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
            #No.MOD-470214
           ON ACTION locale                    #genero
              LET g_action_choice = "locale"
              EXIT CONSTRUCT
            #No.MOD-470214 (end)
 
            #No.MOD-480423
           ON ACTION exit              #加離開功能genero
              LET INT_FLAG = 1
              EXIT CONSTRUCT
            #No.MOD-480423 (end)
	
	END CONSTRUCT
         #No.MOD-470214
        IF g_action_choice = "locale" THEN  #genero
           LET g_action_choice = ""
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()   #FUN-550037(smin)
           CONTINUE WHILE
        END IF
         #No.MOD-470214 (end)
	IF INT_FLAG THEN
           LET INT_FLAG = 0 EXIT WHILE
        END IF
 
	DISPLAY BY NAME tm.download,   #tm.file_name,tm.file_extension,
			tm.backup,tm.cleanup,tm.more
			
	LET l_warn=1
	INPUT BY NAME tm.download,   #tm.file_name,tm.file_extension,
                      tm.backup  , tm.cleanup,tm.more
          WITHOUT DEFAULTS    #MOD-940337
			
 
              AFTER FIELD backup
		LET l_direction='D'
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
                IF tm.download='N' AND tm.backup='N'
                   AND tm.cleanup='N' THEN
                   IF l_warn THEN
                      CALL cl_err('','anm-120',0)
                      LET l_warn=0
                      NEXT FIELD download
                   END IF
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
 
 
              #No.MOD-470214
             ON ACTION locale
                LET g_action_choice = "locale"
                EXIT INPUT
              #No.MOD-470214(end)
 
              #No.MOD-480423
             ON ACTION exit              #加離開功能genero
                LET INT_FLAG = 1
                EXIT INPUT
              #No.MOD-480423 (end)
		
	END INPUT
         #No.MOD-470214
        IF g_action_choice = "locale" THEN  #genero
           LET g_action_choice = ""
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()   #FUN-550037(smin)
           CONTINUE WHILE
        END IF
         #No.MOD-470214(end)
 
	IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
 
		IF g_bgjob = 'Y' THEN
			SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
				WHERE zz01='anmu101'
			IF SQLCA.sqlcode OR l_cmd IS NULL THEN
                           CALL cl_err('anmu101','9031',1)
			ELSE
			LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
				" '",g_pdate CLIPPED,"'",
				" '",g_towhom CLIPPED,"'",
				" '",g_lang CLIPPED,"'",
				" '",g_bgjob CLIPPED,"'",
				" '",g_prtway CLIPPED,"'",
				" '",g_copies CLIPPED,"'",
				" '",tm.wc CLIPPED,"'",
				" '",tm.download CLIPPED,"'",
			       #" '",tm.file_name CLIPPED,"'",
			       #" '",tm.file_extension CLIPPED,"'",
				" '",tm.backup CLIPPED,"'"#,
				CALL cl_cmdat('anmu101',g_time,l_cmd)
			END IF
			CLOSE WINDOW u101_w
			CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
                        EXIT PROGRAM
		END IF
		CALL anmu101()
		ERROR ""
	END WHILE
	CLOSE WINDOW u101_w
END FUNCTION
 
FUNCTION anmu101()
DEFINE
   l_status     LIKE type_file.num5,    #No.FUN-680107 SMALLINT
   l_npl01      LIKE npl_file.npl01,
   l_file_name1 LIKE type_file.chr20,   #No.FUN-680107 VARCHAR(15)
   l_file_name2 LIKE type_file.chr20,   #No.FUN-680107 VARCHAR(15)
   l_file_name3 LIKE type_file.chr20,   #No.FUN-680107 VARCHAR(15)
   l_i,l_j      LIKE type_file.num5,    #No.FUN-680107 SMALLINT
   l_buf        LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(500)
   l_sql        LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(500)
 
   IF tm.download='N'
      AND tm.backup='N'
      AND tm.cleanup='N' THEN
      RETURN
   END IF
 
	IF g_bgjob='N' THEN
		IF NOT cl_sure(0,0) THEN RETURN END IF
	END IF
	LET l_file_name1='nmf_file.txt'
	LET l_file_name2='npl_file.txt'
	LET l_file_name3='npm_file.txt'
 
	IF tm.download='Y' THEN
		#異動記錄檔(nmf_file)
		LET l_sql=
			"unload '",l_file_name1,
			" select * from nmf_file",
			' where ',tm.wc CLIPPED,"'"
		RUN l_sql RETURNING l_status
		IF l_status THEN RETURN END IF
 
		#異動單頭檔(npl_file)
		LET l_sql=
			"unload '",l_file_name2,
			" select * from npl_file",
			' where ',tm.wc CLIPPED,"'"
                 ## 將nmf 轉換為npl
                     LET l_buf=l_sql
                     LET l_j=length(l_buf)
                     FOR l_i=1 TO l_j
                        IF l_buf[l_i,l_i+4]='nmf02' THEN
                              LET l_buf[l_i,l_i+4]='npl02'
                        END IF
                     END FOR
                     LET l_sql = l_buf
 
		RUN l_sql RETURNING l_status
		IF l_status THEN RETURN END IF
 
		#異動單身檔(npm_file)
		LET l_sql=
			"unload '",l_file_name3,
			" select npm_file.* from npl_file,npm_file",
			' where npl01=npm01 ',
			' and ',tm.wc CLIPPED,"'"
                 ## 將nmf 轉換為npl
                     LET l_buf=l_sql
                     LET l_j=length(l_buf)
                     FOR l_i=1 TO l_j
                        IF l_buf[l_i,l_i+4]='nmf02' THEN
                              LET l_buf[l_i,l_i+4]='npl02'
                        END IF
                     END FOR
                     LET l_sql = l_buf
		RUN l_sql RETURNING l_status
		IF l_status THEN RETURN END IF
 
	END IF
 
	IF tm.backup='Y' THEN
		LET l_sql="back_data ",#tm.backup_device,	#1.Device
			" ",g_bgjob,				#2.bgjob
			" ",l_file_name1," ",l_file_name2,	#3.file name
			" ",l_file_name3
		RUN l_sql RETURNING l_status
		IF l_status THEN RETURN END IF
	END IF
 
	IF tm.cleanup='Y' THEN
		MESSAGE "delete data ..."
		LET l_sql="DELETE FROM nmf_file ",
			" WHERE ",tm.wc CLIPPED
		PREPARE u101_del FROM l_sql
		IF SQLCA.sqlcode THEN RETURN END IF
		EXECUTE u101_del
		IF g_bgjob='N' THEN
            LET INT_FLAG = 0  ######add for prompt bug
			PROMPT SQLCA.SQLERRD[3]," ROW(S) DELETED ..." FOR l_status
		END IF
 
		LET l_sql="SELECT npl01",
			" FROM npl_file ",
			" where ",tm.wc CLIPPED
                 ## 將nmf 轉換為npl
                     LET l_buf=l_sql
                     LET l_j=length(l_buf)
                     FOR l_i=1 TO l_j
                        IF l_buf[l_i,l_i+4]='nmf02' THEN
                              LET l_buf[l_i,l_i+4]='npl02'
                        END IF
                     END FOR
                     LET l_sql = l_buf
		PREPARE u101_p000 FROM l_sql
		IF SQLCA.sqlcode THEN RETURN END IF
		DECLARE u101_curh CURSOR FOR u101_p000
		IF SQLCA.sqlcode THEN RETURN END IF
 
		LET l_sql= "DELETE FROM npm_file WHERE npm01=? "
		PREPARE u101_dnpm FROM l_sql
		IF SQLCA.sqlcode THEN RETURN END IF
 
		LET l_sql= "DELETE FROM npl_file WHERE npl01=?"
		PREPARE u101_dnpl FROM l_sql
		IF SQLCA.sqlcode THEN RETURN END IF
 
		LET l_status=0
		FOREACH u101_curh INTO l_npl01
			IF g_bgjob='N' THEN
				MESSAGE 'Delete ...',l_npl01
			END IF
			LET l_status=l_status+1
 
			EXECUTE u101_dnpm USING l_npl01
			IF SQLCA.sqlcode THEN CONTINUE FOREACH END IF
 
			EXECUTE u101_dnpl USING l_npl01
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
#Patch....NO.TQC-610036 <001> #
