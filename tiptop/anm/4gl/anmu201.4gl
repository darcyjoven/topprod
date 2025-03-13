# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: anmu201.4gl
# Descriptions...: 應收票據異動記錄清除作業
# Input parameter:
# Return code....:
# Date & Author..: 92/06/08 By MAY
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
#
 
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.MOD-940337 09/04/27 By lilingy tm.more的預設值改成N
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used(2) 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
	tm  RECORD					#CONDITION RECORD
		wc       LIKE type_file.chr1000,    #No.FUN-680107 VARCHAR(300)		#Where Condiction
		download LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1)		#DownLoad Data?
                #file_name VARCHAR(3),		    #DownLoad File Name
	       #file_extension DATE,	            #DownLoad File Extension
		backup   LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1)		#Backup Data?
	#backup_device VARCHAR(1),	                    #Backup Device (1.Tape 2.Floppy)
		cleanup  LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1)		#CleanUp Date?
		more     LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1)		#是否輸入其它特殊列印條件
	END RECORD,
	g_file_extension LIKE type_file.dat         #No.FUN-680107 VARCHAR(06)
 
DEFINE   g_chr           LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1)
MAIN
	#set up options
	OPTIONS
  INPUT NO WRAP
	DEFER INTERRUPT					# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
   CALL u201_tm()
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION u201_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE
	p_row,p_col	LIKE type_file.num5,          #No.FUN-680107 SMALLINT
	l_cmd	        LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(400)
	l_warn          LIKE type_file.num5,          #No.FUN-680107 SMALLINT
	l_direction     LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(01)
	l_jmp_flag      LIKE type_file.chr1           #No.FUN-680107 VARCHAR(1)
 
      LET p_row = 4
      LET p_col = 30
 
      OPEN WINDOW u201_w AT p_row,p_col
           WITH FORM "anm/42f/anmu201"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
	CALL cl_opmsg('p')
 
	#initialize program variables
	INITIALIZE tm.* TO NULL
	LET tm.download='N'
       #LET tm.file_name='nmi'
       #LET tm.file_extension=g_today USING 'YYMMDD'
	LET tm.backup='N'
	LET tm.cleanup='N'
#	LET tm.more='Y'   #MOD-940337
	LET tm.more='N'   #MOD-940337
	LET g_pdate=g_today
	LET g_rlang=g_lang
	LET g_bgjob='N'
	LET g_copies='1'
	LET l_jmp_flag='N'
 
	WHILE TRUE
           CONSTRUCT BY NAME tm.wc ON nmi02
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
               ON IDLE g_idle_seconds
                       CALL cl_on_idle()
		       CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                #No.MOD-470216
               ON ACTION locale                    #genero
                  LET g_action_choice = "locale"
                  EXIT CONSTRUCT
                #No.MOD-470216 (end)
 
                #No.MOD-480423
               ON ACTION exit              #加離開功能genero
                  LET INT_FLAG = 1
                  EXIT CONSTRUCT
                #No.MOD-480423 (end)
		
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
		#No.FUN-580031 --end--       HCN
           END CONSTRUCT
           LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
            #No.MOD-470216
           IF g_action_choice = "locale" THEN  #genero
              LET g_action_choice = ""
              CALL cl_dynamic_locale()
              CALL cl_show_fld_cont()   #FUN-550037(smin)
              CONTINUE WHILE
           END IF
            #No.MOD-470216 (end)
           IF INT_FLAG THEN
              LET INT_FLAG = 0 EXIT WHILE
           END IF
 
           DISPLAY BY NAME tm.download,tm.backup,tm.cleanup,tm.more
			
           LET l_warn=1
           INPUT BY NAME tm.download, tm.backup,tm.cleanup,tm.more
              WITHOUT DEFAULTS   #MOD-940337 
			
                #No.FUN-580031 --start--
                BEFORE INPUT
                    CALL cl_qbe_display_condition(lc_qbe_sn)
                #No.FUN-580031 ---end---
 
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
 
                  ON ACTION CONTROLG
                     CALL cl_cmdask()	# Command execution
 
		  ON IDLE g_idle_seconds
		     CALL cl_on_idle()
		     CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
                   #No.MOD-470216
                  ON ACTION locale
                     LET g_action_choice = "locale"
                     EXIT INPUT
                   #No.MOD-470216(end)
 
                  ON ACTION exit              #加離開功能genero
                     LET INT_FLAG = 1
                     EXIT INPUT
                   #No.MOD-480423 (end)
 
                  #No.FUN-580031 --start--
                  ON ACTION qbe_save
                     CALL cl_qbe_save()
                  #No.FUN-580031 ---end---
		
		END INPUT
                 #No.MOD-470216
                IF g_action_choice = "locale" THEN  #genero
                   LET g_action_choice = ""
                   CALL cl_dynamic_locale()
                   CALL cl_show_fld_cont()   #FUN-550037(smin)
                   CONTINUE WHILE
                END IF
                 #No.MOD-470216(end)
		IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
		CALL anmu201()
		ERROR ""
	END WHILE
	CLOSE WINDOW u201_w
END FUNCTION
 
FUNCTION anmu201()
DEFINE
	l_status     LIKE type_file.num5,        #No.FUN-680107 SMALLINT
	l_npn01      LIKE npn_file.npn01,
	l_file_name1 LIKE type_file.chr20,       #No.FUN-680107 VARCHAR(15)
	l_file_name2 LIKE type_file.chr20,       #No.FUN-680107 VARCHAR(15)
	l_file_name3 LIKE type_file.chr20,       #No.FUN-680107 VARCHAR(15)
        l_i,l_j      LIKE type_file.num5,        #No.FUN-680107 SMALLINT
        l_buf        LIKE type_file.chr1000,     #No.FUN-680107 VARCHAR(500)
	l_sql        LIKE type_file.chr1000      #No.FUN-680107 VARCHAR(500)
 
	IF tm.download='N'
		AND tm.backup='N'
		AND tm.cleanup='N' THEN
		RETURN
	END IF
 
	IF g_bgjob='N' THEN
		IF NOT cl_sure(0,0) THEN RETURN END IF
	END IF
	LET l_file_name1='nmi_file.txt'
	LET l_file_name2='npn_file.txt'
	LET l_file_name3='npo_file.txt'
 
	IF tm.download='Y' THEN
		#異動記錄檔(nmi_file)
		LET l_sql=
			"unload '",l_file_name1,
			" select * from nmi_file",
			' where ',tm.wc CLIPPED,"'"
		RUN l_sql RETURNING l_status
		IF l_status THEN RETURN END IF
 
		#異動單頭檔(npn_file)
		LET l_sql=
			"unload '",l_file_name2,
			" select * from npn_file",
			' where ',tm.wc CLIPPED,"'"
                 ## 將nmi 轉換為npn
                     LET l_buf=l_sql
                     LET l_j=length(l_buf)
                     FOR l_i=1 TO l_j
                        IF l_buf[l_i,l_i+4]='nmi02' THEN
                              LET l_buf[l_i,l_i+4]='npn02'
                        END IF
                     END FOR
                     LET l_sql = l_buf
 
		RUN l_sql RETURNING l_status
		IF l_status THEN RETURN END IF
 
		#異動單身檔(npo_file)
		LET l_sql=
			"unload '",l_file_name3,
			" select npo_file.* from npn_file,npo_file",
			' where npn01=npo01 ',
			' and ',tm.wc CLIPPED,"'"
                 ## 將nmi 轉換為npn
                     LET l_buf=l_sql
                     LET l_j=length(l_buf)
                     FOR l_i=1 TO l_j
                        IF l_buf[l_i,l_i+4]='nmi02' THEN
                              LET l_buf[l_i,l_i+4]='npn02'
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
		LET l_sql="DELETE FROM nmi_file ",
			" WHERE ",tm.wc CLIPPED
		PREPARE u201_del FROM l_sql
		IF SQLCA.sqlcode THEN RETURN END IF
		EXECUTE u201_del
		IF g_bgjob='N' THEN
            LET INT_FLAG = 0  ######add for prompt bug
			PROMPT SQLCA.SQLERRD[3]," ROW(S) DELETED ..." FOR l_status
		END IF
 
		LET l_sql="SELECT npn01",
			" FROM npn_file ",
			" where ",tm.wc CLIPPED
                 ## 將nmi 轉換為npn
                     LET l_buf=l_sql
                     LET l_j=length(l_buf)
                     FOR l_i=1 TO l_j
                        IF l_buf[l_i,l_i+4]='nmi02' THEN
                              LET l_buf[l_i,l_i+4]='npn02'
                        END IF
                     END FOR
                     LET l_sql = l_buf
		PREPARE u201_p000 FROM l_sql
		IF SQLCA.sqlcode THEN RETURN END IF
		DECLARE u201_curh CURSOR FOR u201_p000
		IF SQLCA.sqlcode THEN RETURN END IF
 
		LET l_sql= "DELETE FROM npo_file WHERE npo01=? "
		PREPARE u201_dnpo FROM l_sql
		IF SQLCA.sqlcode THEN RETURN END IF
 
		LET l_sql= "DELETE FROM npn_file WHERE npn01=?"
		PREPARE u201_dnpn FROM l_sql
		IF SQLCA.sqlcode THEN RETURN END IF
 
		LET l_status=0
		FOREACH u201_curh INTO l_npn01
			IF g_bgjob='N' THEN
				MESSAGE 'Delete ...',l_npn01
			END IF
			LET l_status=l_status+1
 
			EXECUTE u201_dnpo USING l_npn01
			IF SQLCA.sqlcode THEN CONTINUE FOREACH END IF
 
			EXECUTE u201_dnpn USING l_npn01
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
