# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aglu812.4gl
# Descriptions...: 異動明細資料載回作業
# Input parameter:
# Return code....:
# Date & Author..: 92/05/26 By Lee
#
# Modify.........: No.FUN-680098 06/09/04 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm       RECORD                                # CONDITION RECORD
          upload       LIKE type_file.chr1,           # Upload Data?          #No.FUN-680098  VARCHAR(1) 
          backup_device  LIKE type_file.chr1   ,      # Backup Device (1.Tape 2.Floppy) #No.FUN-680098  VARCHAR(1) 
          file_name      LIKE type_file.chr3   ,       # Upload File Name      #No.FUN-680098  VARCHAR(3) 
          file_extension LIKE type_file.chr6          # upload File Extension #No.FUN-680098 VARCHAR(6) 
            END RECORD,
       g_bookno           LIKE aba_file.aba00     # 帳別編號
DEFINE p_col,p_row        LIKE type_file.num5          #No.FUN-680098  smallint
 
MAIN
 
   DEFINE l_warn         LIKE type_file.num5       #No.FUN-680098  smallint
   DEFINE l_direction    LIKE type_file.chr1       #No.FUN-680098  VARCHAR(1)
 
   OPTIONS
      INPUT NO WRAP
      DEFER INTERRUPT               #Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   OPEN WINDOW u812_w AT p_row,p_col WITH FORM "agl/42f/aglu812"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   #initialize program variables
   INITIALIZE tm.* TO NULL
   LET tm.upload='Y'
   LET tm.file_name='aec'
 
   #get user options
   WHILE TRUE
      DISPLAY BY NAME tm.upload,tm.backup_device,tm.file_name,
                      tm.file_extension
 
      LET l_warn=1
 
      INPUT BY NAME tm.upload,tm.backup_device,tm.file_name,
                    tm.file_extension
       ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
 
         AFTER FIELD upload
            LET l_direction='D'
 
         BEFORE FIELD backup_device
            IF tm.upload='N' THEN
               IF l_direction='D' THEN
                  NEXT FIELD file_name
               ELSE
                  NEXT FIELD upload
               END IF
            END IF
 
         AFTER FIELD file_name
            LET l_direction='U'
 
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
      CALL aglu812()
      ERROR ""
   END WHILE
   CLOSE WINDOW u812_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglu812()
 
DEFINE l_status  LIKE type_file.num5,     #No.FUN-680098  smallint
       l_sql     LIKE type_file.chr1000   #No.FUN-680098  STRING
 
   IF NOT cl_sure(0,0) THEN RETURN END IF
 
   IF tm.upload='Y' THEN
      LET l_sql= "up_data ",tm.backup_device," ",
                  tm.file_name CLIPPED,'_',tm.file_extension CLIPPED
      RUN l_sql RETURNING l_status
      IF l_status THEN RETURN END IF
   END IF
 
   LET l_sql="upload ","aec_file ",
             tm.file_name CLIPPED,"_",tm.file_extension CLIPPED
   RUN l_sql RETURNING l_status
   IF l_status THEN RETURN END IF
END FUNCTION
 
#Patch....NO.TQC-610035 <001> #
