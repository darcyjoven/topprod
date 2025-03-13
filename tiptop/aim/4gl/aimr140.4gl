# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aimr140.4gl
# Descriptions...: 料件異動資料查詢
# Input parameter: 
# Return code....: 
# Date & Author..: 92/06/09 By yen
# Modify.........: 92/12/14 By Pin
#                  單据編號應隨異動命令來決定抓何值(tlf026 or tlf036)
# Modify.........: 93/04/20 By Pin 
#                  tlf_file 分割              
# Modify.........: No.MOD-480137 04/08/11 By Nicola 輸入順序錯誤      
# Modify.........: No.FUN-510017 05/01/10 By Mandy 報表轉XML
# Modify.........: No.FUN-570240 05/07/26 By day   料件編號欄位加CONTROLP 
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610072 06/03/07 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-780012 07/08/07 By zhoufeng 報表產出改為Crystal Report 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A90024 10/12/01 By Jay 調整各DB利用sch_file取得table與field等資訊
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  tm        RECORD                          # Print condition RECORD
                  wc      STRING,                 # Where condition   #TQC-630166
                  bdate   LIKE type_file.dat,     # Begin date         #No.FUN-690026 DATE
                  edate   LIKE type_file.dat,     # End date           #No.FUN-690026 DATE
                  y       LIKE type_file.chr1,    # group code choice  #No.FUN-690026 VARCHAR(1)
                  s       LIKE type_file.chr3,    # Order by sequence  #No.FUN-690026 VARCHAR(3)
                  tbname  LIKE gat_file.gat01,    # table name #No.FUN-690026 VARCHAR(10)
                  more    LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
                  END RECORD
 
DEFINE   g_gettlf DYNAMIC ARRAY OF RECORD   
                  tbname  LIKE gat_file.gat01,    # table name #No.FUN-690026 VARCHAR(10)
                  bdate   LIKE type_file.dat,     #Transaction begin date  #No.FUN-690026 DATE
                  edate   LIKE type_file.dat,     #Transaction end   date  #No.FUN-690026 DATE
                  p_no    LIKE type_file.num10    #Transaction count  #No.FUN-690026 INTEGER
                  END RECORD
DEFINE   g_i      LIKE type_file.num5             #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE   g_sql    STRING                          #No.FUN-780012
DEFINE   g_str    STRING                          #No.FUN-780012
DEFINE   l_table  STRING                          #No.FUN-780012
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
   #No.FUN-780012 --start--
   LET g_sql="ima01.ima_file.ima01,ima05.ima_file.ima05,ima08.ima_file.ima08,",
             "ima06.ima_file.ima06,ima02.ima_file.ima02,tlf13.tlf_file.tlf13,",
             "tlf06.tlf_file.tlf06,tlf07.tlf_file.tlf07,tlf08.tlf_file.tlf08,",
             "tlf10.tlf_file.tlf10,tlf11.tlf_file.tlf11,",
             "tlf026.tlf_file.tlf026,tlf09.tlf_file.tlf09,",
             "ima09.ima_file.ima09,ima10.ima_file.ima10,ima11.ima_file.ima11,",
             "ima12.ima_file.ima12"
   LET l_table = cl_prt_temptable('aimr140',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-780012 --end--
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.bdate= ARG_VAL(8)
   LET tm.edate= ARG_VAL(9)
   LET tm.y    = ARG_VAL(10)
   LET tm.s    = ARG_VAL(11)
   LET tm.tbname= ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL q504_tm()	             	# Input print condition
      ELSE CALL aimr140()		          	# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION q504_tm()
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE l_cmd	     LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(1000)
       l_j,l_n       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       p_row,p_col   LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 2 LET p_col = 17
   ELSE
       LET p_row = 4 LET p_col = 9
   END IF
   OPEN WINDOW q504_w AT p_row,p_col
        WITH FORM "aim/42f/aimr140" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.y    = '0'
   LET tm.tbname='tlf_file'
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm2.s1   = '1'
   LET tm2.s2   = '2'
   LET tm2.s3   = '3'
WHILE TRUE
#--->怕只怕 user 再重新輸入條件,因此....
   FOR l_j=1  TO 70
       initialize g_gettlf[l_j].* TO NULL
   END FOR
   CONSTRUCT BY NAME tm.wc ON ima01,ima05,ima06,
                     ima09,ima10,ima11,ima12,ima08,tlf13                  
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
 
#No.FUN-570240  --start-                                         
      ON ACTION controlp                                         
            IF INFIELD(ima01) THEN                               
               CALL cl_init_qry_var()                            
               LET g_qryparam.form = "q_ima"                     
               LET g_qryparam.state = "c"                        
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                              
               DISPLAY g_qryparam.multiret TO ima01             
               NEXT FIELD ima01                                  
            END IF                                               
#No.FUN-570240 --end--       
   
   
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
  
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW q504_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.bdate,tm.edate,tm.y,
		   tm.s,tm.tbname,tm.more 	# Condition
#UI
    INPUT BY NAME tm.bdate,tm.edate,tm.tbname,            #No.MOD-480137
		 tm2.s1,tm2.s2,tm2.s3,tm.y,tm.more WITHOUT DEFAULTS 
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
      AFTER FIELD edate
         IF tm.edate < tm.bdate THEN
            CALL cl_err('','aap-100',0) NEXT FIELD bdate
         END IF
      AFTER FIELD y
         IF tm.y NOT MATCHES "[0-4]" OR tm.y IS NULL 
            THEN NEXT FIELD y
         END IF
 
      AFTER FIELD tbname
         IF cl_null(tm.tbname) THEN NEXT FIELD tbname END IF
          #BugNo:6597
          #---FUN-A90024---start-----
          #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
          #目前統一用sch_file紀錄TIPTOP資料結構
          #SELECT COUNT(distinct table_name) INTO l_n FROM all_tables WHERE table_name=rtrim(upper(tm.tbname))
          SELECT COUNT(distinct sch01) INTO l_n FROM sch_file WHERE sch01 = tm.tbname
          #---FUN-A90024---end-------
          IF l_n <= 0 THEN
              CALL cl_err(tm.tbname,'mfg9180',0)
              NEXT FIELD tbname
          END IF
      AFTER FIELD more
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
      ON ACTION select_mul_file  
         CALL s_gettlf(0,0)     # get file name
      #UI
 
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
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
      LET INT_FLAG = 0 CLOSE WINDOW q504_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr140'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr140','9031',1)
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
                         " '",tm.y CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.tbname CLIPPED,"'",            #TQC-610072
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr140',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW q504_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr140()
   ERROR ""
END WHILE
   CLOSE WINDOW q504_w
END FUNCTION
 
FUNCTION aimr140()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0074
          l_sql 	STRING,    		        # RDSQL STATEMENT  $TQC-630166
          l_za05	LIKE za_file.za05,              #No.FUN-690026 VARCHAR(40)
          l_order	ARRAY[5] OF LIKE ima_file.ima01,   #FUN-5B0105 10->40  #No.FUN-690026 VARCHAR(40)
          sr            RECORD order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                               order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                               order3 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
		               ima01 LIKE ima_file.ima01,#
                               ima02 LIKE ima_file.ima02,#品名規格
                               ima05 LIKE ima_file.ima05,#
                               ima06 LIKE ima_file.ima06,#
                               ima09 LIKE ima_file.ima09,#
                               ima10 LIKE ima_file.ima10,#
                               ima11 LIKE ima_file.ima11,#
                               ima12 LIKE ima_file.ima12,#
                               ima08 LIKE ima_file.ima08,#
                               tlf13 LIKE tlf_file.tlf13,#
                               tlf06 LIKE tlf_file.tlf06,#
                               tlf07 LIKE tlf_file.tlf07,#
                               tlf08 LIKE tlf_file.tlf08,#
                               tlf10 LIKE tlf_file.tlf10,#
                               tlf11 LIKE tlf_file.tlf11,#
                               tlf026 LIKE tlf_file.tlf026,#
                               tlf036 LIKE tlf_file.tlf036,#
                               tlf09 LIKE tlf_file.tlf09,#
                               clas  LIKE  ima_file.ima06
                        END RECORD,
           l_i          LIKE type_file.num5,    #No.FUN-690026 SMALLINT
           l_key        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_status     LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
     CALL cl_del_data(l_table)                  #No.FUN-780012
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#    CALL cl_outnam('aimr140') RETURNING l_name #No.FUN-780012
#    START REPORT q504_rep TO l_name            #No.FUN-780012
#    LET g_pageno = 0                           #No.FUN-780012
 
#*****************************************************************************#
#------->因tlf_file 已做分割處理,因此資料來源不只是從tlf_file來<--------------#
#*****************************************************************************#
 
     IF g_gettlf[1].tbname IS NULL OR g_gettlf[1].tbname=' '
        THEN LET g_gettlf[1].tbname='tlf_file'
     END IF
  
     FOR  l_i=1  TO 70      #最多70期
     IF g_gettlf[l_i].tbname IS NULL OR g_gettlf[l_i].tbname=' '
        THEN EXIT FOR
     END IF
    
         LET l_sql = "SELECT '','','',",
                     " ima01,ima02,ima05,ima06,ima09,",
            		 " ima10,ima11,ima12,ima08,",
                     " tlf13,tlf06,tlf07,tlf08,tlf10,tlf11,tlf026,",
                     " tlf036,tlf09,' ' ",
                     "  FROM ima_file, ",g_gettlf[l_i].tbname,
                     " WHERE tlf01 = ima01",
                     "   AND ",tm.wc
    	 IF tm.bdate IS NULL AND tm.edate IS NOT NULL THEN
    		LET l_sql = l_sql CLIPPED, " AND tlf06 <= '",tm.edate,"'" 
         END IF 
	     IF tm.bdate IS NOT NULL AND tm.edate IS NULL THEN
	    	LET l_sql = l_sql CLIPPED, " AND tlf06 >= '",tm.bdate,"'"
         END IF 
	     IF tm.bdate IS NOT NULL AND tm.edate IS NOT NULL THEN
		    LET l_sql = l_sql CLIPPED, " AND tlf06 <= '",tm.edate,"'",
                                       " AND tlf06 >= '",tm.bdate,"'"
          END IF 
          PREPARE q504_prepare1 FROM l_sql
          IF SQLCA.sqlcode != 0 THEN 
             CALL cl_err('prepare:',SQLCA.sqlcode,1) 
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
             EXIT PROGRAM 
          END IF
          DECLARE q504_cs1 CURSOR FOR q504_prepare1
 
          FOREACH q504_cs1 INTO sr.*
            IF SQLCA.sqlcode != 0 THEN 
               CALL cl_err('foreach:',SQLCA.sqlcode,1) 
               EXIT FOREACH 
            END IF
            CALL s_command(sr.tlf13) RETURNING l_status,l_key
	        IF l_status   MATCHES '[134]'          #FROM 
		       THEN  LET sr.tlf026=sr.tlf026
	           ELSE  LET sr.tlf026=sr.tlf036       #TO
		     END IF
#No.FUN-780012 --start-- mark
#            FOR g_i = 1 TO 3
#               CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ima01
#                    WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima05
#                    WHEN tm.s[g_i,g_i] = '3'
#                         CASE           
#     			            WHEN tm.y ='0' LET l_order[g_i] = sr.ima06
#	     	                               LET      sr.clas = sr.ima06
#		               	    WHEN tm.y ='1' LET l_order[g_i] = sr.ima09
#					                       LET      sr.clas = sr.ima09
#		                    WHEN tm.y ='2' LET l_order[g_i] = sr.ima10
#				                           LET      sr.clas = sr.ima10
#		                    WHEN tm.y ='3' LET l_order[g_i] = sr.ima11
#					                       LET      sr.clas = sr.ima11
#			                WHEN tm.y ='4' LET l_order[g_i] = sr.ima12
#				                           LET      sr.clas = sr.ima12
#                        END CASE 
#                  WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.ima08
#                  WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.tlf13
#                       OTHERWISE LET l_order[g_i] = '-'
#                 END CASE
#           END FOR
#           LET sr.order1 = l_order[1]
#           LET sr.order2 = l_order[2]
#           LET sr.order3 = l_order[3]
#           OUTPUT TO REPORT q504_rep(sr.*)
#No.FUN-780012 --end--
#No.FUN-780012 --start--
           EXECUTE insert_prep USING sr.ima01,sr.ima05,sr.ima08,sr.ima06,
                                     sr.ima02,sr.tlf13,sr.tlf06,sr.tlf07,
                                     sr.tlf08,sr.tlf10,sr.tlf11,sr.tlf026,
                                     sr.tlf09,sr.ima09,sr.ima10,sr.ima11,
                                     sr.ima12
#No.FUN-780012 --end--
         END FOREACH
 
    END FOR
 
#    FINISH REPORT q504_rep                            #No.FUN-780012
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)       #No.FUN-780012
#No.FUN-780012 --start--
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                    
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(tm.wc,'ima01,ima05,ima06,ima09,ima10,
                            ima11,ima12,ima08,tlf13')   
            RETURNING tm.wc                                                     
       LET g_str = tm.wc                                                        
    END IF
    LET g_str = g_str,";",tm.bdate,";",tm.edate,";",tm.s[1,1],";",
                tm.s[2,2],";",tm.s[3,3],";",tm.y
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED 
    CALL cl_prt_cs3('aimr140','aimr140',l_sql,g_str)
#No.FUN-780012 --end--
END FUNCTION
#No.FUN-780012 --start-- mark
#REPORT q504_rep(sr)
#   DEFINE l_str         STRING   #FUN-510017
#   DEFINE l_last_sw	LIKE type_file.chr1,              #No.FUN-690026 VARCHAR(1)
#          l_orderA      ARRAY[3] OF LIKE ima_file.ima01,  #FUN-5B0105 08->40  #No.FUN-690026 VARCHAR(40)
#          l_i           LIKE type_file.num5,              #處理排列順序於列印時所需控制  #No.FUN-690026 SMALLINT
#          sr            RECORD order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                               order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                               order3 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                               ima01 LIKE ima_file.ima01,#工程變異單單號
#                               ima02 LIKE ima_file.ima02,#品名規格
#                               ima05 LIKE ima_file.ima05,#
#                               ima06 LIKE ima_file.ima06,#
#                               ima09 LIKE ima_file.ima09,#
#                               ima10 LIKE ima_file.ima10,#
#                               ima11 LIKE ima_file.ima11,#
#                               ima12 LIKE ima_file.ima12,#
#                               ima08 LIKE ima_file.ima08,#
#                               tlf13 LIKE tlf_file.tlf13,#
#                               tlf06 LIKE tlf_file.tlf06,#
#                               tlf07 LIKE tlf_file.tlf07,#
#                               tlf08 LIKE tlf_file.tlf08,#
#                               tlf10 LIKE tlf_file.tlf10,#
#                               tlf11 LIKE tlf_file.tlf11,#
#                               tlf026 LIKE tlf_file.tlf026,#
#                               tlf036 LIKE tlf_file.tlf036,#
#                               tlf09 LIKE tlf_file.tlf09,#
#                               clas  LIKE  ima_file.ima06
#                       END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
#  ORDER BY  sr.ima01, sr.order1, sr.order2, sr.order3, sr.tlf06
#
#  FORMAT
#   PAGE HEADER
#      #處理排列順序於列印時所需控制
#      FOR l_i = 1 TO 3
#         CASE WHEN tm.s[l_i,l_i] = '1' LET l_orderA[l_i] = g_x[21]
#              WHEN tm.s[l_i,l_i] = '2' LET l_orderA[l_i] = g_x[22]
#              WHEN tm.s[l_i,l_i] = '3' LET l_orderA[l_i] = g_x[23]
#              WHEN tm.s[l_i,l_i] = '4' LET l_orderA[l_i] = g_x[24]
#              WHEN tm.s[l_i,l_i] = '5' LET l_orderA[l_i] = g_x[25]
#              OTHERWISE LET l_orderA[l_i] = ' '
#         END CASE
#      END FOR
#      LET l_str = g_x[20] CLIPPED,' ',
#            l_orderA[1] CLIPPED," - ",l_orderA[2] CLIPPED," - ",
#            l_orderA[3] CLIPPED
#
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno" 
#      PRINT g_head CLIPPED,pageno_total     
#      PRINT l_str
#      PRINT g_dash
#      PRINT g_x[11] CLIPPED, sr.ima01,COLUMN 41,g_x[12] CLIPPED,sr.ima05, #MOD-5B0310
#            COLUMN 52,g_x[13] CLIPPED, sr.ima08, #MOD-5B0310
#            COLUMN 64,g_x[14] CLIPPED, sr.clas   #MOD-5B0310
#      PRINT g_x[15] CLIPPED, sr.ima02
#      PRINT g_x[16] CLIPPED, tm.bdate, COLUMN 37, g_x[17] CLIPPED, tm.edate #MOD-5B0310
#      PRINT g_dash2
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
#      PRINT g_dash1 
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.ima01  
#      IF (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   ON EVERY ROW
#      PRINT COLUMN g_c[31],sr.tlf13,
#            COLUMN g_c[32],sr.tlf06,
#            COLUMN g_c[33],sr.tlf07,
#            COLUMN g_c[34],sr.tlf08,
#            COLUMN g_c[35],cl_numfor(sr.tlf10,35,3), 
#            COLUMN g_c[36],sr.tlf11,
#            COLUMN g_c[37],sr.tlf026,
#            COLUMN g_c[38],sr.tlf09
#{
#   AFTER GROUP OF sr.ima01
#     PRINT l_dash[1,g_len]
#     PRINT COLUMN (g_len-40),g_x[21] CLIPPED,': ',
#           sr.ima01 CLIPPED,'  ', g_x[26] CLIPPED
#}
#   ON LAST ROW
#      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#         THEN PRINT g_dash
#        #TQC-630166
#        #      IF tm.wc[001,070] > ' ' THEN			# for 80
# 	#	 PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#        #      IF tm.wc[071,140] > ' ' THEN
#	# 	 PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#        #      IF tm.wc[141,210] > ' ' THEN
#	# 	 PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#        #      IF tm.wc[211,280] > ' ' THEN
#	# 	 PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#         CALL cl_prt_pos_wc(tm.wc)
#        #END TQC-630166
#
#      END IF
#      PRINT g_dash
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[38], g_x[7] CLIPPED
#      LET l_last_sw = 'y'
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[38], g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-780012 --end--
