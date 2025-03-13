# Prog. Version..: '5.30.06-13.03.12(00005)'     #
# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aimr100.4gl
# Desc/riptions..: 料件基本資料列印表
# Input parameter:
# Return code....:
# Date & Author..: 92/03/18 By jones
# Modify ........: 92/05/25 By David
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-5A0047 05/10/14 By Sarah 品名規格(ima02)放大到60碼
# Modify.........: No.TQC-5B0121 05/11/15 By Sarah 報表單頭料號長度應調整成40碼
# Modify.........: NO.FUN-5B0105 05/12/14 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610034 06/01/16 By pengu 背景時接參數個數與執行背景作業時帶的參數不同
# Modify.........: No.TQC-610072 06/03/07 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-740023 07/04/11 By Sarah cl_prt_cs1()參數增加為四個
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-930169 09/03/31 By tsai_yen 1.改成cs3, 2.列印料件的圖檔
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80070 11/08/08 By fanbj EXIT PROGRAM 前加cl_used(2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                          # Print condition RECORD
              wc       STRING, #TQC-630166   
              s        LIKE type_file.chr3,   # Order by sequence  #No.FUN-690026 VARCHAR(3)
              y        LIKE type_file.chr1,   # group code choice  #No.FUN-690026 VARCHAR(1)
              more     LIKE type_file.chr1    # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
              END RECORD,
          g_aza17      LIKE aza_file.aza17    # 本國幣別
DEFINE    g_i          LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE    g_sql        STRING                 #FUN-930169
DEFINE    g_str        STRING                 #FUN-930169
DEFINE 	  l_table      STRING                 #FUN-930169
 
###GENGRE###START
TYPE sr1_t RECORD
    ima01 LIKE ima_file.ima01,
    ima06 LIKE ima_file.ima06,
    ima05 LIKE ima_file.ima05,
    ima08 LIKE ima_file.ima08,
    ima02 LIKE ima_file.ima02,
    ima03 LIKE ima_file.ima03,
    ima13 LIKE ima_file.ima13,
    ima04 LIKE ima_file.ima04,
    ima14 LIKE ima_file.ima14,
    ima70 LIKE ima_file.ima70,
    ima15 LIKE ima_file.ima15,
    ima24 LIKE ima_file.ima24,
    ima07 LIKE ima_file.ima07,
    ima16 LIKE ima_file.ima16,
    ima37 LIKE ima_file.ima37,
    ima51 LIKE ima_file.ima51,
    ima52 LIKE ima_file.ima52,
    ima09 LIKE ima_file.ima09,
    ima10 LIKE ima_file.ima10,
    ima11 LIKE ima_file.ima11,
    ima12 LIKE ima_file.ima12,
    ima25 LIKE ima_file.ima25,
    ima73 LIKE ima_file.ima73,
    ima74 LIKE ima_file.ima74,
    ima29 LIKE ima_file.ima29,
    ima30 LIKE ima_file.ima30,
    gcb09 LIKE gcb_file.gcb09,
    gcb09_show LIKE type_file.chr1
END RECORD
###GENGRE###END

MAIN
   OPTIONS
      INPUT NO WRAP
    DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.y  = ARG_VAL(9)      #No.TQC-610034 add  #TQC-610072 順序順推
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   
   ###FUN-910012 START ###
   LET g_sql= "ima01.ima_file.ima01, ima06.ima_file.ima06,",
              "ima05.ima_file.ima05, ima08.ima_file.ima08,",
              "ima02.ima_file.ima02, ima03.ima_file.ima03,", 
              "ima13.ima_file.ima13, ima04.ima_file.ima04,", 
              "ima14.ima_file.ima14, ima70.ima_file.ima70,",
              "ima15.ima_file.ima15, ima24.ima_file.ima24,",
              "ima07.ima_file.ima07, ima16.ima_file.ima16,",
              "ima37.ima_file.ima37, ima51.ima_file.ima51,",
              "ima52.ima_file.ima52, ima09.ima_file.ima09,",
              "ima10.ima_file.ima10, ima11.ima_file.ima11,",
              "ima12.ima_file.ima12, ima25.ima_file.ima25,",
              "ima73.ima_file.ima73, ima74.ima_file.ima74,",
              "ima29.ima_file.ima29, ima30.ima_file.ima30,",
              "gcb09.gcb_file.gcb09, gcb09_show.type_file.chr1"
   LET l_table = cl_prt_temptable('aimr100',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   ###FUN-910012 END ###
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r110_tm(0,0)		# Input print condition
      ELSE CALL aimr100()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r110_tm(p_row,p_col)
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col	LIKE type_file.num5,   #No.FUN-690026 SMALLINT
       l_cmd		LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 14 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 2 LET p_col = 18
   ELSE
       LET p_row = 3 LET p_col = 14
   END IF
 
   OPEN WINDOW r110_w AT p_row,p_col
        WITH FORM "aim/42f/aimr100"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s    = '123'
   LET tm.y    = '0'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm2.s1='1'
   LET tm2.s2='2'
   LET tm2.s3='3'
WHILE TRUE
   DISPLAY BY NAME tm.s,tm.y,tm.more # Condition
   CONSTRUCT BY NAME tm.wc ON ima01,ima05,ima06,ima09,ima10,
			                  ima11,ima12,ima08
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION controlp
            IF INFIELD(ima01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            END IF
#No.FUN-570240 --end
 
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
      LET INT_FLAG = 0
      CLOSE WINDOW r110_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.s,tm.y,tm.more # Condition
#UI
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm.y,tm.more
                WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD y
         IF tm.y NOT MATCHES "[0-4]" OR tm.y IS NULL
            THEN NEXT FIELD y
         END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
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
  #   ON ACTION CONTROLP CALL r110_wc()       # Input detail Where Condition
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
      LET INT_FLAG = 0 CLOSE WINDOW r110_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr100'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr100','9031',1)
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
                         " '",tm.s CLIPPED,"'",
                         " '",tm.y CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr100',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r110_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr100()
   ERROR ""
END WHILE
    CALL aimg100_grdata()    ###GENGRE###
   CLOSE WINDOW r110_w
END FUNCTION
FUNCTION aimr100()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-690026 VARCHAR(20)
         #l_time          LIKE type_file.chr8	      #No.FUN-6A0074
          l_sql         STRING,  #TQC-630166	
          l_za05	LIKE za_file.za05,                #No.FUN-690026 VARCHAR(40)
          l_sta         LIKE type_file.chr20,         #No.FUN-690026 VARCHAR(20)
          l_order	ARRAY[3] OF LIKE ima_file.ima01,  #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
          sr        RECORD
                       ###FUN-930169 mark START ###
                       #order1 LIKE ima_file.ima01,   #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                       #order2 LIKE ima_file.ima01,   #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                       #order3 LIKE ima_file.ima01,   #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                       #l_sta  LIKE type_file.chr20,  #No.FUN-690026 VARCHAR(20)
                       ###FUN-930169 mark END ###
                       ima01  LIKE ima_file.ima01,
                       ima06  LIKE ima_file.ima06,
                       ima05  LIKE ima_file.ima05,
                       ima08  LIKE ima_file.ima08,
                       ima02  LIKE ima_file.ima02,
                       ima03  LIKE ima_file.ima03,
                       ima13  LIKE ima_file.ima13,
                       ima04  like ima_file.ima04,
                       ima14  LIKE ima_file.ima14,
                       ima70  LIKE ima_file.ima70,
                       ima15  LIKE ima_file.ima15,
                       ima24  LIKE ima_file.ima24,
                       ima07  LIKE ima_file.ima07,
                       ima16  LIKE ima_file.ima16,
                       ima37  LIKE ima_file.ima37,
                       ima51  LIKE ima_file.ima51,
                       ima52  LIKE ima_file.ima52,
                       ima09  LIKE ima_file.ima09,
                       ima10  LIKE ima_file.ima10,
                       ima11  LIKE ima_file.ima11,
                       ima12  LIKE ima_file.ima12,
                       ima25  LIKE ima_file.ima25,
                       ima73  LIKE ima_file.ima73,
                       ima74  LIKE ima_file.ima74,
                       ima29  LIKE ima_file.ima29,
                       ima30  LIKE ima_file.ima30,   
                       gcb09  LIKE gcb_file.gcb09,     #料件圖檔        #FUN-930169 
                       gcb09_show LIKE type_file.chr1 #是否顯示料件圖檔  #FUN-930169
                    END RECORD
 
   CALL cl_del_data(l_table)   #FUN-930169
   
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aimr100'
   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND imagrup LIKE '",g_grup CLIPPED,"%'"
      #CHI-8A0001 寫ora
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
   #End:FUN-980030
   
   ###FUN-930169 START ###
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                       "?,?,?,?,?, ?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN  
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80070--add--
      EXIT PROGRAM 
   END IF
   ###FUN-930169 END ###
   
   #LET l_sql = "SELECT  ' ',' ',' ',' ',",                    #FUN-930169 mark      
   #            " ima01,ima06,ima05,ima08,ima02,ima03, ",      #FUN-930169 mark
   LET l_sql = "SELECT ima01,ima06,ima05,ima08,ima02,ima03, ", #FUN-930169
	           " ima13,ima04,ima14,ima70,ima15,ima24, ",
               " ima07,ima16,ima37,ima51,ima52,ima09, ",
               " ima10,ima11,ima12,ima25, ",
               " ima73,ima74,ima29,ima30 ",
               " FROM ima_file ",
               " WHERE ", tm.wc CLIPPED   ,
               " ORDER BY ima01 "
   ###FUN-930169 START ###
   PREPARE aimr100_pr1 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE aimr100_cs1 CURSOR FOR aimr100_pr1
   
   FOREACH aimr100_cs1 INTO sr.ima01,sr.ima06,sr.ima05,sr.ima08,sr.ima02, sr.ima03,sr.ima13,sr.ima04,sr.ima14,sr.ima70,
                            sr.ima15,sr.ima24,sr.ima07,sr.ima16,sr.ima37, sr.ima51,sr.ima52,sr.ima09,sr.ima10,sr.ima11,
                            sr.ima12,sr.ima25,sr.ima73,sr.ima74,sr.ima29, sr.ima30
         
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      
      #料件圖檔    
      LET sr.gcb09 = NULL  
      LET sr.gcb09_show = "N"
      LOCATE sr.gcb09 IN MEMORY   #Store data of TEXT and BYTE variables.      
      LET l_sql = "SELECT gcb09 FROM gca_file,gcb_file",
                  " WHERE gcb_file.gcb01 = gca_file.gca07 AND gcb_file.gcb02 = gca_file.gca08",
                  "   AND gcb_file.gcb03 = gca_file.gca09 AND gcb_file.gcb04 = gca_file.gca10",
                  "   AND gca_file.gca01 = 'ima01=",sr.ima01 CLIPPED,"' AND gca_file.gca02 = ' '", 
                  "   AND gca_file.gca03 = ' '  AND gca_file.gca04 = ' '", 
                  "   AND gca_file.gca05 = ' ' AND gca_file.gca08 = 'FLD'", 
                  "   AND gca_file.gca09 = 'ima04' AND gca11 = 'Y'"
      PREPARE aimr100_pr2 FROM l_sql
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      
      DECLARE aimr100_cs2 SCROLL CURSOR FOR aimr100_pr2
      OPEN aimr100_cs2 
      FETCH aimr100_cs2 INTO sr.gcb09
      IF SQLCA.sqlcode THEN
         CALL cl_err(sr.ima01,SQLCA.sqlcode,0)  
         CLOSE aimr100_cs2
      ELSE
         LET sr.gcb09_show = "Y"
      END IF
      CLOSE aimr100_cs2
      
      EXECUTE insert_prep USING
         sr.ima01,sr.ima06,sr.ima05,sr.ima08,sr.ima02, sr.ima03,sr.ima13,sr.ima04,sr.ima14,sr.ima70,
         sr.ima15,sr.ima24,sr.ima07,sr.ima16,sr.ima37, sr.ima51,sr.ima52,sr.ima09,sr.ima10,sr.ima11,
         sr.ima12,sr.ima25,sr.ima73,sr.ima74,sr.ima29, sr.ima30,sr.gcb09,sr.gcb09_show
         
      FREE sr.gcb09   #Releases resources allocated to store the data of TEXT and BYTE variables
   END FOREACH
   
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   
   
   LET g_str = tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",   #排序
               tm.y                                         #排序-分群組碼               
  #CALL cl_prt_cs3('aimr100','aimr100',g_sql,g_str)
   CALL aimg100_grdata()
   ###FUN-930169 END ###
   
   #str FUN-740023 modify
   #CALL cl_prt_cs1('aimr100','aimr100',l_sql,'') #FUN-930169 mark
    ## *** Crystal report 2002/05/16 *** ##
    #IF g_aza.aza24='Y' THEN
       #CASE g_lang
       #     WHEN'0'
       #         IF cl_prt_cs1('aimr100',l_sql,g_x[1])='0' THEN RETURN END IF
       #     WHEN'2'
       #         IF cl_prt_cs1('aimr100_gb',l_sql,g_x[1])='0' THEN RETURN END IF
       #     OTHERWISE
       #         IF cl_prt_cs1('aimr100',l_sql,g_x[1])='0' THEN RETURN END IF
       #END CASE
    #END IF
    ## ********************************* ##
 
    #PREPARE r110_prepare1 FROM l_sql
    #IF SQLCA.sqlcode != 0 THEN
    #   CALL cl_err('prepare:',SQLCA.sqlcode,1) 
    #   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
    #   EXIT PROGRAM
    #      
    #END IF
    #DECLARE r110_cs1 CURSOR FOR r110_prepare1
#   # CALL fgl_report_set_document_handler(om.XmlWriter.createFileWriter("aimr100.xml"))
    #CALL cl_outnam('aimr100') RETURNING l_name
    #START REPORT r110_rep TO l_name
 
    #LET g_pageno = 0
    #FOREACH r110_cs1 INTO sr.*
    #  IF SQLCA.sqlcode != 0 THEN
    #     CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
    #   END IF
    #      CALL s_opc(sr.ima37) RETURNING l_sta
    #  IF sr.ima01 IS NULL THEN LET sr.ima01 = ' ' END IF
    #  IF sr.ima05 IS NULL THEN LET sr.ima05 = ' ' END IF
    #  IF sr.ima06 IS NULL THEN LET sr.ima06 = ' ' END IF
    #  IF sr.ima08 IS NULL THEN LET sr.ima08 = ' ' END IF
    #  FOR g_i = 1 TO 3
    #     CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ima01
    #          WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima05
    #          WHEN tm.s[g_i,g_i] = '3'
    #              CASE
    #   				 WHEN tm.y ='0' LET l_order[g_i] = sr.ima06
    #   				 WHEN tm.y ='1' LET l_order[g_i] = sr.ima09
    #   				 WHEN tm.y ='2' LET l_order[g_i] = sr.ima10
    #   				 WHEN tm.y ='3' LET l_order[g_i] = sr.ima11
    #   				 WHEN tm.y ='4' LET l_order[g_i] = sr.ima12
    #              END CASE
    #          WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.ima08
    #          OTHERWISE LET l_order[g_i] = '-'
    #     END CASE
    #  END FOR
    #  LET sr.order1 = l_order[1]
    #  LET sr.order2 = l_order[2]
    #  LET sr.order3 = l_order[3]
    #  LET sr.l_sta  = l_sta
    #  OUTPUT TO REPORT r110_rep(sr.*)
    #END FOREACH
 
    #FINISH REPORT r110_rep
 
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   #end FUN-740023 modify
END FUNCTION
 
###FUN-930169 mark START ###
#REPORT r110_rep(sr)
#  DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#         l_sw          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#         i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#         sr            RECORD
#                        order1 LIKE ima_file.ima01,  #FUN-5B0105 1->40  #No.FUN-690026 VARCHAR(40)
#                        order2 LIKE ima_file.ima01,  #FUN-5B0105 1->40  #No.FUN-690026 VARCHAR(40)
#                        order3 LIKE ima_file.ima01,  #FUN-5B0105 1->40  #No.FUN-690026 VARCHAR(40)
#                        l_sta  LIKE type_file.chr20, #No.FUN-690026 VARCHAR(20)
#                        ima01  LIKE ima_file.ima01,
#                        ima06  LIKE ima_file.ima06,
#                        ima05  LIKE ima_file.ima05,
#                        ima08  LIKE ima_file.ima08,
#                        ima02  LIKE ima_file.ima02,
#                        ima03  LIKE ima_file.ima03,
#                        ima13  LIKE ima_file.ima13,
#                        ima04  like ima_file.ima04,
#                        ima14  LIKE ima_file.ima14,
#                        ima70  LIKE ima_file.ima70,
#                        ima15  LIKE ima_file.ima15,
#                        ima24  LIKE ima_file.ima24,
#                        ima07  LIKE ima_file.ima07,
#                        ima16  LIKE ima_file.ima16,
#                        ima37  LIKE ima_file.ima37,
#                        ima51  LIKE ima_file.ima51,
#                        ima52  LIKE ima_file.ima52,
#                        ima09  LIKE ima_file.ima09,
#                        ima10  LIKE ima_file.ima10,
#                        ima11  LIKE ima_file.ima11,
#                        ima12  LIKE ima_file.ima12,
#                        ima25  LIKE ima_file.ima25,
#                        ima73  LIKE ima_file.ima73,
#                        ima74  LIKE ima_file.ima74,
#                        ima29  LIKE ima_file.ima29,
#                        ima30  LIKE ima_file.ima30
#                        END RECORD
#
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.ima01,sr.order1,sr.order2,sr.order3
# FORMAT
#  PAGE HEADER
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_today,'  ',TIME,' ',
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#     PRINT g_dash[1,g_len]
 
#     LET l_last_sw = 'n'
#
#  BEFORE GROUP OF sr.order1
#     IF (PAGENO > 1 OR LINENO > 9)
#        THEN SKIP TO TOP OF PAGE
#     END IF
#  BEFORE GROUP OF sr.order2
#     IF (PAGENO > 1 OR LINENO > 9)
#        THEN SKIP TO TOP OF PAGE
#     END IF
#  BEFORE GROUP OF sr.order3
#     IF (PAGENO > 1 OR LINENO > 9)
#        THEN SKIP TO TOP OF PAGE
#     END IF
#  BEFORE GROUP OF sr.ima01
#     IF (PAGENO > 1 OR LINENO > 9)
#        THEN SKIP TO TOP OF PAGE
#     END IF
#
#  ON EVERY ROW
#     PRINT COLUMN  2,g_x[11] CLIPPED,sr.ima01,
#          #start TQC-5B0121
#          #COLUMN 36,g_x[12] CLIPPED,sr.ima06,
#          #COLUMN 51,g_x[13] CLIPPED,sr.ima05,
#          #COLUMN 65,g_x[14] CLIPPED,sr.ima08
#           COLUMN 53,g_x[12] CLIPPED,sr.ima06,
#           COLUMN 68,g_x[13] CLIPPED,sr.ima05,
#           COLUMN 82,g_x[14] CLIPPED,sr.ima08
#          #end TQC-5B0121
#     PRINT COLUMN  2,g_x[15] CLIPPED,sr.ima02,
#          #COLUMN 51,g_x[16] CLIPPED,sr.ima03   #FUN-5A0047 mark
#          #start TQC-5B0121
#          #COLUMN 65,g_x[16] CLIPPED,sr.ima03   #FUN-5A0047
#           COLUMN 82,g_x[16] CLIPPED,sr.ima03   #FUN-5A0047
#          #end TQC-5B0121
#     PRINT '---------------------------------------------------------------',
#          #'-----------------'                  #FUN-5A0047 mark
#          #'------------------------------'     #FUN-5A0047                    #TQC-5B0110 mark
#           '-----------------------------------------------'     #FUN-5A0047   #TQC-5B0110
#     PRINT COLUMN  2,g_x[17] CLIPPED,sr.ima13,
#           COLUMN 48,g_x[41] CLIPPED,sr.ima09
#     PRINT COLUMN  2,g_x[18] CLIPPED,sr.ima04,
#           COLUMN 54,g_x[42] CLIPPED,sr.ima10
#     PRINT COLUMN  2,g_x[19] CLIPPED,sr.ima14,
#           COLUMN 54,g_x[43] CLIPPED,sr.ima11
#     PRINT COLUMN  2,g_x[21] CLIPPED,sr.ima70,
#           COLUMN 54,g_x[44] CLIPPED,sr.ima12
#     PRINT COLUMN  2,g_x[25] CLIPPED,sr.ima15,
#           COLUMN 40,g_x[52] CLIPPED
#     PRINT COLUMN  4,g_x[20] CLIPPED,sr.ima24,
#           COLUMN 48,g_x[45] CLIPPED,sr.ima25
#     PRINT COLUMN  4,g_x[27] CLIPPED,sr.ima07
#     PRINT COLUMN  4,g_x[29] CLIPPED,sr.ima16
#     PRINT COLUMN  2,g_x[31] CLIPPED,sr.ima37 CLIPPED,
#           COLUMN 17,sr.l_sta CLIPPED,
#           COLUMN 40,g_x[52] CLIPPED
#     PRINT COLUMN  2,g_x[34] CLIPPED,sr.ima51
#     PRINT COLUMN  2,g_x[36] CLIPPED,sr.ima52
#     PRINT '---------------------------------------------------------------',
#          #'-----------------'                  #FUN-5A0047 mark
#          #'------------------------------'     #FUN-5A0047                    #TQC-5B0110 mark
#           '-----------------------------------------------'     #FUN-5A0047   #TQC-5B0110
#     PRINT COLUMN  2,g_x[48] CLIPPED,sr.ima73,
#           COLUMN 23,g_x[49] CLIPPED,sr.ima74,
#           COLUMN 40,g_x[50] CLIPPED,sr.ima29,
#           COLUMN 62,g_x[51] CLIPPED,sr.ima30
 
#  ON LAST ROW
#     IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#        THEN
#          PRINT g_dash[1,g_len]
#       #TQC-630166
#       #      IF tm.wc[001,070] > ' ' THEN			# for 80
#	#             PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#       #      IF tm.wc[071,140] > ' ' THEN
# 	#             PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#       #      IF tm.wc[141,210] > ' ' THEN
# 	#             PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#       #      IF tm.wc[211,280] > ' ' THEN
# 	#             PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#       CALL cl_prt_pos_wc(tm.wc)
#       #END TQC-630166
 
#     END IF
#     PRINT g_dash[1,g_len]
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
#   IF l_last_sw = 'n'
#       THEN PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#       ELSE SKIP 2 LINES
#    END IF
#END REPORT
###FUN-930169 mark END ###
#Patch....NO.TQC-610036 <001> #

###GENGRE###START
FUNCTION aimg100_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aimg100")
        IF handler IS NOT NULL THEN
            START REPORT aimg100_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE aimg100_datacur1 CURSOR FROM l_sql
            FOREACH aimg100_datacur1 INTO sr1.*
                OUTPUT TO REPORT aimg100_rep(sr1.*)
            END FOREACH
            FINISH REPORT aimg100_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aimg100_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5

    
    
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company
            PRINTX tm.*
              
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        
        ON LAST ROW

END REPORT
###GENGRE###END
