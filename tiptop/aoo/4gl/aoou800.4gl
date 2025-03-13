# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aoou800.4gl
# Descriptions...: 下載資料載回作業
# Input parameter: 
# Return code....: 
# Date & Author..: 92/05/26 By Lee
# Modify.........: No.MOD-4A0252 04/10/20 By Smapmin 新增置回資料庫檔名開窗功能
# Modify.........: NO.FUN-590002 05/12/27 By Monster radio type 應都要給預設值
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0161 09/10/28 By Carrier SQL STANDARDIZE
# Modify.........: No.CHI-A10003 10/04/15 By Summer 將l_table的變數定義成STRING
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used(2) 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                          # CONDITION RECORD
         upload          LIKE type_file.chr1,    #No.FUN-680102 VARCHAR(1),   # Upload Data?
         backup_device   LIKE type_file.chr1,    #No.FUN-680102 VARCHAR(1),         # Backup Device (1.Tape 2.Floppy)
         file_name       LIKE type_file.chr3,    #No.FUN-680102 VARCHAR(3),         # Upload File Name
         file_extension  LIKE type_file.chr8,     #No.FUN-680102  VARCHAR(8),        # upload File Extension
         table_name      LIKE type_file.chr3     #No.FUN-680102  VARCHAR(3),        # load into table name
           END RECORD
DEFINE p_col,p_row       LIKE type_file.num5     #No.FUN-680102 SMALLINT
DEFINE l_direction       LIKE type_file.chr1     #No.FUN-680102CHAR(1)
MAIN
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                          # Supress DEL key function
 
    IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211 
   LET p_row=0 LET p_col=0
 
   OPEN WINDOW u800_w AT p_row,p_col WITH FORM "aoo/42f/aoou800" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL
  
   WHILE TRUE
      #NO.FUN-590002-start----
      LET tm.backup_device = '1'
      #NO.FUN-590002-end----
      DISPLAY BY NAME tm.upload, tm.backup_device, tm.file_name,
                      tm.file_extension,           tm.table_name
 
#     LET l_warn=1
      INPUT BY NAME tm.upload, tm.backup_device, tm.file_name,
                    tm.file_extension,           tm.table_name
      WITHOUT DEFAULTS
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
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(file_name)
                    RUN 'showlog'
 
               WHEN INFIELD(file_extension)
                    RUN 'showlog'
 
                #MOD-4A0252加入置回資料庫檔名開窗功能
               WHEN INFIELD(table_name)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "i"
                    LET g_qryparam.form ="q_zta1"
                    CALL cl_create_qry() RETURNING tm.table_name
                    DISPLAY tm.table_name TO table_name
                    NEXT FIELD table_name
               OTHERWISE EXIT CASE
            END CASE
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG 
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          #No.MOD-480423
         ON ACTION exit              #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
          #No.MOD-480423 (end)
      
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
      CALL aoou800()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW u800_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211 
END MAIN
 
 
FUNCTION aoou800()
   DEFINE l_table STRING,   #No.FUN-680102CHAR(20),  #No.CHI-A10003 mod LIKE type_file.chr20,-->STRING,
          l_file  LIKE type_file.chr1000       #No.FUN-680102CHAR(30)
   DEFINE l_status LIKE type_file.num5,          #No.FUN-680102SMALLINT,
          l_sql    LIKE type_file.chr1000       #No.FUN-680102CHAR(1000)
 
   IF NOT cl_sure(14,20) THEN
      RETURN
   END IF
 
   IF tm.upload='Y' THEN
      LET l_sql= "up_data ",tm.backup_device," ",
                 tm.file_name CLIPPED,'_',tm.file_extension CLIPPED
      RUN l_sql RETURNING l_status
      IF l_status THEN
         RETURN
      END IF
   END IF
 
  #No.8568
   LET l_table=tm.table_name,'_file'
   LET l_file =tm.file_name CLIPPED,"_",tm.file_extension CLIPPED
   LET l_sql=
   #No.TQC-9A0161  --Begin
#  "SELECT * FROM ",l_table," WHERE rowid=9999  INTO TEMP u800_tmp"
   "SELECT * FROM ",l_table," WHERE 1 <> 1      INTO TEMP u800_tmp"
   #No.TQC-9A0161  --End  
   PREPARE load_p1 FROM l_sql
   EXECUTE load_p1
   DELETE FROM u800_tmp WHERE 1=1
   LOAD FROM l_file INSERT INTO u800_tmp
          LET l_sql=
             "INSERT INTO ",l_table CLIPPED," SELECT * FROM u800_tmp"
          PREPARE load_p2 FROM l_sql
          EXECUTE load_p2
          DROP TABLE u800_tmp
         #LOAD FROM l_file INSERT INTO l_table
 
END FUNCTION
{
	LET l_sql="upload ",tm.table_name," ",
		tm.file_name CLIPPED,"_",tm.file_extension CLIPPED
	RUN l_sql RETURNING l_status
END FUNCTION
}
