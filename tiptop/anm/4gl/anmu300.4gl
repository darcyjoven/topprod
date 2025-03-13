# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: anmu300.4gl
# Descriptions...: 銀行存款異動記錄清除作業
# Input parameter:
# Return code....:
# Date & Author..: 92/06/08 By MAY
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
#
 
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.MOD-940337 09/04/27 By lilingyu tm.more的預設值改成 N
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used(2) 
# Modify.........: No.FUN-B40056 11/06/07 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/18 By elva 现金流量表修正
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
	tm  RECORD					#CONDITION RECORD
		wc        LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(300)		#Where Condiction
		download  LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)		#DownLoad Data?
		file_name LIKE type_file.chr3,          #No.FUN-680107 VARCHAR(3)		#DownLoad File Name
		file_extension LIKE type_file.dat,      #No.FUN-680107 DATE	  #DownLoad File Extension
		backup    LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)		#Backup Data?
		cleanup   LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)		#CleanUp Date?
		more      LIKE type_file.chr1           #No.FUN-680107 VARCHAR(1)		#是否輸入其它特殊列印條件
		END RECORD,
	g_file_extension LIKE type_file.dat,            #No.FUN-680107 VARCHAR(06) 
	g_bookno  LIKE aba_file.aba00 #帳別編號
 
MAIN
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
    CALL u300_tm()
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211 
END MAIN
 
FUNCTION u300_tm()
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01           #No.FUN-580031
DEFINE p_row,p_col      LIKE type_file.num5,          #No.FUN-680107 SMALLINT
       l_cmd            LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(400)
       l_warn           LIKE type_file.num5,          #No.FUN-680107 SMALLINT
       l_direction      LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
       l_jmp_flag       LIKE type_file.chr1           #No.FUN-680107 VARCHAR(1)
 
   LET p_row = 4 LET p_col = 30
   OPEN WINDOW u300_w AT p_row,p_col WITH FORM "anm/42f/anmu300"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL
   LET tm.download='N'
   LET tm.file_name='nme'
   LET tm.file_extension=g_today USING 'YYMMDD'
   LET tm.backup='N'
   LET tm.cleanup='N'
#  LET tm.more='Y'    #MOD-940337
   LET tm.more='N'    #MOD-940337
   LET g_pdate=g_today
   LET g_rlang=g_lang
   LET g_bgjob='N'
   LET g_copies='1'
   LET l_jmp_flag='N'
 
   #get user options
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON nme02
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
 
 
          #No.MOD-470217
         ON ACTION locale                    #genero
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
          #No.MOD-470217 (end)
 
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmeuser', 'nmegrup') #FUN-980030
       #No.MOD-470217
      IF g_action_choice = "locale" THEN  #genero
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
       #No.MOD-470217 (end)
      IF INT_FLAG THEN
         LET INT_FLAG = 0 EXIT WHILE
      END IF
 
      DISPLAY BY NAME
          tm.download,tm.file_name,tm.file_extension,
          tm.backup,tm.cleanup,tm.more
		
      LET l_warn=1
      INPUT BY NAME tm.download,tm.file_name,tm.file_extension,
	            tm.backup,tm.cleanup,tm.more
        WITHOUT DEFAULTS    #MOD-940337  
 
                #No.FUN-580031 --start--
                BEFORE INPUT
                    CALL cl_qbe_display_condition(lc_qbe_sn)
                #No.FUN-580031 ---end---
 
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
                        IF INT_FLAG THEN EXIT INPUT END IF
			IF tm.download='N'
				AND tm.backup='N'
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
 
 
                    #No.MOD-470217
                   ON ACTION locale
                      LET g_action_choice = "locale"
                      EXIT INPUT
                    #No.MOD-470217(end)
 
                    #No.MOD-480423
                   ON ACTION exit              #加離開功能genero
                      LET INT_FLAG = 1
                      EXIT INPUT
                    #No.MOD-480423 (end)
 
                   #No.FUN-580031 --start--
                   ON ACTION qbe_save
                      CALL cl_qbe_save()
                   #No.FUN-580031 ---end---
		
		END INPUT
                 #No.MOD-470217
                IF g_action_choice = "locale" THEN  #genero
                   LET g_action_choice = ""
                   CALL cl_dynamic_locale()
                   CALL cl_show_fld_cont()   #FUN-550037(smin)
                   CONTINUE WHILE
                END IF
                 #No.MOD-470217(end)
 
		IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
		CALL anmu300()
		ERROR ""
	END WHILE
	CLOSE WINDOW u300_w
END FUNCTION
 
FUNCTION anmu300()
DEFINE
	l_status   LIKE type_file.num5,          #No.FUN-680107 SMALLINT
	l_sql      LIKE type_file.chr1000        #No.FUN-680107 VARCHAR(500)
 
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
			" select * from nme_file",
			' where ',tm.wc CLIPPED,
			"'"
		RUN l_sql RETURNING l_status
		IF l_status THEN RETURN END IF
	END IF
 
	IF tm.backup='Y' THEN
		LET l_sql="back_data ",#tm.backup_device," ",	#device
			g_bgjob," ",								#bgjob
			tm.file_name,"_",g_file_extension			#file_name
		RUN l_sql RETURNING l_status
		IF l_status THEN RETURN END IF
	END IF
 
	IF tm.cleanup='Y' THEN
	
    #FUN-B40056 --begin
        IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021
		LET l_sql="DELETE FROM tic_file ",
			        " WHERE tic04 IN (",
			        "SELECT nme12 FROM nme_file",
			        " WHERE ",tm.wc CLIPPED,")"
		PREPARE u300_del_tic FROM l_sql
		IF SQLCA.sqlcode THEN RETURN END IF
		EXECUTE u300_del_tic
        END IF
		#FUN-B40056 --end	
	
		MESSAGE "delete data ..."
		LET l_sql="DELETE FROM nme_file ",
			" WHERE ",tm.wc CLIPPED
		PREPARE u300_del FROM l_sql
		IF SQLCA.sqlcode THEN RETURN END IF
		EXECUTE u300_del
	
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
#Patch....NO.TQC-610036 <001> #
