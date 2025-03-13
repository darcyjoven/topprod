# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: anmr601.4gl
# Descriptions...: 投資狀況明細表
# Input parameter:
# Return code....:
# Date & Author..: 2000/07/24 By Mandy
# Modify.........: No.FUN-4C0098 05/01/04 By pengu 報表轉XML
# Modify.........: No.FUN-590111 05/10/04 By Nicola 平倉欄位修改
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/29 By Rainy 表頭期間置於中間
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
#
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-7B0026 07/11/12 By lutingting轉為用 crystal report輸出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD		                    # Print condition RECORD
               wc      STRING,                      #Where Condiction
               bdate   LIKE type_file.dat,          #No.FUN-680107 DATE
               edate   LIKE type_file.dat,          #No.FUN-680107 DATE
               type    LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)#是否只列印有異動的資料
               more    LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)#是否列印其它條件
               END     RECORD,
               l_dash  LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(140)
 
DEFINE   g_i           LIKE type_file.num5          #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE   g_head1       STRING
    DEFINE   g_str         STRING                       #No.FUN-7B0026
    DEFINE   g_sql         STRING                       #No.FUN-7B0026
    DEFINE   l_table       STRING                       #No.FUN-7B0026
    DEFINE   l_table1      STRING                       #No.FUN-7B0026
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
#No.FUN-7B0026--start--
    LET g_sql ="gsb05.gsb_file.gsb05,",
               "gsb03.gsb_file.gsb03,",
               "gsb01.gsb_file.gsb01,",
               "gsb06.gsb_file.gsb06,",
               "gsb10.gsb_file.gsb10,",
               "gsb101.gsb_file.gsb101,",
               "azi05.azi_file.azi05,",
               "l_cnt.type_file.num5"
    LET l_table = cl_prt_temptable('anmr601',g_sql) CLIPPED
    IF l_table=-1 THEN EXIT PROGRAM END IF
    LET g_sql = "gsb01_1.gsb_file.gsb01,",
                "gse01.gse_file.gse01,",
                "gse02.gse_file.gse02,",
                "gse05.gse_file.gse05,",
                "gse06.gse_file.gse06,",
                "gse25.gse_file.gse25,",
                "l_total_05.gse_file.gse05,",
                "l_total_06.gse_file.gse06,",
                "l_total_25.gse_file.gse25"
    LET l_table1 = cl_prt_temptable('anmr6011',g_sql) CLIPPED
    IF l_table1=-1 THEN EXIT PROGRAM END IF
#No.FUN-7B0026--end--     
 
    LET g_pdate = ARG_VAL(1)		# Get arguments from command line
    LET g_towhom = ARG_VAL(2)
    LET g_rlang = ARG_VAL(3)
    LET g_bgjob = ARG_VAL(4)
    LET g_prtway = ARG_VAL(5)
    LET g_copies = ARG_VAL(6)
    LET tm.wc  = ARG_VAL(7)
    LET tm.bdate  = ARG_VAL(8)
    LET tm.edate  = ARG_VAL(9)
    LET tm.type  = ARG_VAL(10)   #TQC-610058
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
    IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
        THEN CALL anmr601_tm()	        	# Input print condition
        ELSE CALL anmr601()			# Read data and create out-file
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr601_tm()
DEFINE lc_qbe_sn    LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col  LIKE type_file.num5,   #No.FUN-680107 SMALLINT
       l_cmd        LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(400)
       l_flag       LIKE type_file.chr1,   #是否必要欄位有輸入 #No.FUN-680107 VARCHAR(1)
       l_jmp_flag   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   LET p_row = 4 LET p_col = 15
    OPEN WINDOW anmr601_w AT p_row,p_col
        WITH FORM "anm/42f/anmr601"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL cl_opmsg('p')
    INITIALIZE tm.* TO NULL			# Default condition
    LET tm.bdate   = g_today
    LET tm.edate   = g_today
    LET tm.type    = 'Y'
    LET tm.more    = 'N'
    LET g_pdate    = g_today
    LET g_rlang    = g_lang
    LET g_bgjob    = 'N'
    LET g_copies   = '1'
WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON gsb01,gsb05   #No.FUN-590111
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
        LET INT_FLAG = 0 CLOSE WINDOW anmr601_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
           
    END IF
    IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
    INPUT BY NAME tm.bdate,tm.edate,tm.type,tm.more
        WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
   #AFTER FIELD bdate
   #    IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
   #AFTER FIELD edate
   #    IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
   #    IF tm.edate < tm.bdate THEN NEXT FIELD bdate END IF
    AFTER FIELD type
        IF tm.type NOT MATCHES "[YN]" OR tm.type IS NULL OR
           cl_null(tm.type) THEN
            NEXT FIELD type
        END IF
    AFTER FIELD more
        IF tm.edate < tm.bdate THEN
           CALL cl_err('','aap-100',1)
           NEXT FIELD bdate
        END IF
        IF cl_null(tm.bdate) THEN LET l_flag = 'N' END IF
 
        IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL OR tm.more = ' '
            THEN NEXT FIELD more
        END IF
        IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
                RETURNING g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies
        END IF
    AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
        LET l_flag='N'
        IF INT_FLAG THEN EXIT INPUT  END IF
        IF cl_null(tm.bdate) THEN
            LET l_flag='Y'
            CALL cl_err('','9033',0)
            DISPLAY BY NAME tm.bdate
            NEXT FIELD bdate
        END IF
        IF cl_null(tm.edate)  THEN
            LET l_flag='Y'
            CALL cl_err('','9033',0)
            DISPLAY BY NAME tm.edate
            NEXT FIELD edate
        END IF
        IF cl_null(tm.type)  THEN
            LET l_flag='Y'
            CALL cl_err('','9033',0)
            DISPLAY BY NAME tm.type
            NEXT FIELD type
        END IF
        IF tm.edate < tm.bdate THEN
           CALL cl_err('','aap-100',1)
           NEXT FIELD bdate
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
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0 CLOSE WINDOW anmr601_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
           
    END IF
    IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
            WHERE zz01='anmr601'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('anmr601','9031',1)   
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
                         " '",tm.type CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('anmr601',g_time,l_cmd)	# Execute cmd at later time
        END IF
        CLOSE WINDOW anmr601_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
    END IF
    CALL cl_wait()
    CALL anmr601()
    ERROR ""
END WHILE
    CLOSE WINDOW anmr601_w
END FUNCTION
 
FUNCTION anmr601()
    DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name #No.FUN-680107 VARCHAR(20)
#       l_time           LIKE type_file.chr8	    #No.FUN-6A0082
           l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
           l_za05	LIKE type_file.chr1000,         #標題內容 #No.FUN-680107 VARCHAR(40)
           l_order      ARRAY[2] OF LIKE cre_file.cre08,#No.FUN-680107 ARRAY[2] OF VARCHAR(10) #排列順序
           l_i          LIKE type_file.num5,            #No.FUN-680107 SMALLINT
           l_cnt        LIKE type_file.num5,            #No.FUN-680107 SMALLINT
           sr           RECORD
                             gsb05    LIKE gsb_file.gsb05,
                             gsb03    LIKE gsb_file.gsb03,
                             gsb01    LIKE gsb_file.gsb01,
                             gsb06    LIKE gsb_file.gsb06,
                           # gsb07    LIKE gsb_file.gsb07,   #No.FUN-590111 Mark
                             gsb10    LIKE gsb_file.gsb10,
                             gsb101   LIKE gsb_file.gsb101
                         END RECORD
 
       DEFINE l_total_05  LIKE gse_file.gse05,   #No.FUN-7B0026                                                                
           l_total_06  LIKE gse_file.gse06,   #No.FUN-7B0026                                                                
           l_total_25  LIKE gse_file.gse25,   #No.FUN-7B0026
           l_gse01     LIKE gse_file.gse01,  #平倉單號   #No.FUN-7B0026                                                                   
           l_gse02     LIKE gse_file.gse02,  #平倉日期   #No.FUN-7B0026                                                                   
           l_gse05     LIKE gse_file.gse05,  #平倉數量   #No.FUN-7B0026                                                     
           l_gse06     LIKE gse_file.gse06,  #平倉金額   #No.FUN-7B0026                                                     
           l_gse25     LIKE gse_file.gse25   #投資損益   #No.FUN-7B0026 
#No.FUN-7B0026--start--
    CALL cl_del_data(l_table)                            
    CALL cl_del_data(l_table1)
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?,?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN 
         CALL cl_err('insert_prep:',status,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
         EXIT PROGRAM
    END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                " VALUES(?,?,?,?,?,?,?,?,?)"
    PREPARE insert_prep1 FROM g_sql
    IF STATUS THEN
         CALL cl_err("insert_prep1:",STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
         EXIT PROGRAM
    END IF 
#No.FUN-7B0026--end--                           
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='anmr601' #No.FUN-7B0026
#NO.CHI-6A0004--BEGIN
#    SELECT azi04 INTO g_azi04 FROM azi_file WHERE azi01 = g_aza.aza17  #NO.CHI-6A0004
#    IF SQLCA.sqlcode THEN 
#      CALL cl_err(g_azi04,SQLCA.sqlcode,0) #FUN-660148
#       CALL cl_err3("sel","azi_file",g_aza.aza17,"",STATUS,"","",0) #FUN-660148
#    END IF
#NO.CHI-6A0004--END
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND gsbuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND gsbgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND gsbgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('gsbuser', 'gsbgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT gsb05,gsb03,gsb01,gsb06,gsb10,gsb101",  #No.FUN-590111
                 " FROM gsb_file ",
                 " WHERE ",tm.wc CLIPPED,
                 " AND gsb03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
                 " AND gsbconf !='X' ",#010816增
                 " ORDER BY gsb05,gsb03,gsb01"
    PREPARE anmr601_prepare1 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:anmr601_prepare1',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
           
    END IF
    DECLARE anmr601_curs1 CURSOR FOR anmr601_prepare1
#   CALL cl_outnam('anmr601') RETURNING l_name               #No.FUN-7B0026 Mark
#   START REPORT anmr601_rep TO l_name                       #No.FUN-7B0026 Mark
#   LET g_pageno = 0                                         #No.FUN-7B0026 Mark
    FOREACH anmr601_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
#No.FUN-7B0026--start
        LET l_total_05  = 0                                                                                                         
        LET l_total_06  = 0                                                                                                         
        LET l_total_25  = 0 
        SELECT COUNT(*) INTO l_cnt FROM gse_file                                                                                    
            WHERE gse03 = sr.gsb01                                                                                                  
              AND gseconf !='X'
        EXECUTE insert_prep USING
           sr.gsb05,sr.gsb03,sr.gsb01,sr.gsb06,sr.gsb10,sr.gsb101,g_azi05,l_cnt
#       OUTPUT TO REPORT anmr601_rep(sr.*)               #No.FUN-7B0026 Mark
                DECLARE gse_curs CURSOR FOR                                                                                     
                          SELECT gse01,gse02,gse05,gse06,gse25 FROM gse_file   #No.FUN-590111                                         
                              WHERE gse03 = sr.gsb01                                                                                  
                                AND gseconf !='X'  #010816 W                                                                          
                     FOREACH gse_curs INTO l_gse01,l_gse02,l_gse05,l_gse06,l_gse25   #No:590111                                      
                          IF STATUS THEN                                                                                              
                         CALL cl_err('foreach:gse_curs',STATUS,1) EXIT FOREACH                                                   
                         END IF                                                                                                      
                         LET l_total_05 = l_total_05 + l_gse05   #No.FUN-590111                                                      
                         LET l_total_06 = l_total_06 + l_gse06   #No.FUN-590111                                                      
                         LET l_total_25 = l_total_25 + l_gse25   #No.FUN-590111                                                      
                         EXECUTE insert_prep1 USING
                            sr.gsb01, l_gse01,l_gse02,l_gse05,l_gse06,l_gse25,
                            l_total_05,l_total_06,l_total_25                                                                                                            
                     END FOREACH
    END FOREACH
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
    IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'gsb01,gsb05')
              RETURNING tm.wc
        LET g_str = tm.wc
    END IF
    LET g_str = g_str,";",tm.bdate,";",tm.edate,";",tm.type,";",g_azi05
    CALL cl_prt_cs3('anmr601','anmr601',l_sql,g_str)
#No.FUN-7B0026--end
#    FINISH REPORT anmr601_rep                 #No.FUN-7B0026 Mark
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #No.FUN-7B0026 Mark
END FUNCTION
 
#No.FUN-7B0026--start
#REPORT anmr601_rep(sr)
#    DEFINE l_last_sw   LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
#           l_gsb01_t   LIKE gsb_file.gsb01,   #投資單號
#           l_cnt       LIKE type_file.num5,   #No.FUN-680107 SMALLINT
#           l_total_05  LIKE gse_file.gse05,   #No.FUN-590111
#           l_total_06  LIKE gse_file.gse06,   #No.FUN-590111
#           l_total_25  LIKE gse_file.gse25,   #No.FUN-590111
#           sr          RECORD
#                           gsb05    LIKE gsb_file.gsb05,   #種類
#                           gsb03    LIKE gsb_file.gsb03,   #投資日期
#                           gsb01    LIKE gsb_file.gsb01,   #投資單號
#                           gsb06    LIKE gsb_file.gsb06,   #投資標的
                         # gsb07    LIKE gsb_file.gsb07,   #幣別   #No.FUN-590111
#                           gsb10    LIKE gsb_file.gsb10,   #投資數量
#                           gsb101   LIKE gsb_file.gsb101   #投資金額
#                       END RECORD,
#           l_gse01     LIKE gse_file.gse01,  #平倉單號
#           l_gse02     LIKE gse_file.gse02,  #平倉日期
#           l_gse05     LIKE gse_file.gse05,  #平倉數量   #No.FUN-590111
#           l_gse06     LIKE gse_file.gse06,  #平倉金額   #No.FUN-590111
#           l_gse25     LIKE gse_file.gse25   #投資損益   #No.FUN-590111
 
#    OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
#    ORDER BY sr.gsb05,sr.gsb03,sr.gsb01
#    FORMAT
#    PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#        LET g_pageno=g_pageno+1
#        LET pageno_total=PAGENO USING '<<<',"/pageno"
#        PRINT g_head CLIPPED,pageno_total
#        LET g_head1=g_x[9] CLIPPED,tm.bdate,'-',tm.edate
        #PRINT g_head1                                         #FUN-660060 remark
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)+1, g_head1 #FUN-660060
#        PRINT g_dash[1,g_len]
#        PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#              g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,   #No.FUN-590111
#              g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED
#        PRINT g_dash1
#        LET l_last_sw = 'n'
#        LET l_gsb01_t = '          '
 
#    BEFORE GROUP OF sr.gsb01   #No.FUN-590111
#        LET l_total_05  = 0
#        LET l_total_06  = 0
#        LET l_total_25  = 0
 
#    ON EVERY ROW
#NO.CHI-6A0004--BEGIN
##      SELECT azi03,azi04,azi05
##        INTO g_azi03,g_azi04,g_azi05
##        FROM azi_file
##       WHERE azi01=g_aza.aza17   #No.FUN-590111
##NO.CHI-6A0004--END
#        SELECT COUNT(*) INTO l_cnt FROM gse_file
#            WHERE gse03 = sr.gsb01
#              AND gseconf !='X'  #010816增
#        IF tm.type = 'Y' AND l_cnt > 0 OR tm.type = 'N' THEN
#            PRINT COLUMN g_c[31],sr.gsb05  CLIPPED,
#                  COLUMN g_c[32],sr.gsb03  CLIPPED,
#                  COLUMN g_c[33],sr.gsb01  CLIPPED,
#                  COLUMN g_c[34],sr.gsb06  CLIPPED,
#                # COLUMN g_c[35],sr.gsb07  CLIPPED,   #No.FUN-590111 Mark
#                  COLUMN g_c[36],cl_numfor(sr.gsb10,36,3),
#                  COLUMN g_c[37],cl_numfor(sr.gsb101,37,g_azi05);
#            DECLARE gse_curs CURSOR FOR
#                SELECT gse01,gse02,gse05,gse06,gse25 FROM gse_file   #No.FUN-590111
#                    WHERE gse03 = sr.gsb01
#                      AND gseconf !='X'  #010816增
#            FOREACH gse_curs INTO l_gse01,l_gse02,l_gse05,l_gse06,l_gse25   #No:590111
#                IF STATUS THEN
#                    CALL cl_err('foreach:gse_curs',STATUS,1) EXIT FOREACH   
#                END IF
#                PRINT COLUMN g_c[38],l_gse01  CLIPPED,
#                      COLUMN g_c[39],l_gse02  CLIPPED,
#                      COLUMN g_c[40],cl_numfor(l_gse05,40,3),        #No.FUN-590111
#                      COLUMN g_c[41],cl_numfor(l_gse06,41,g_azi05),  #No.FUN-590111
#                      COLUMN g_c[42],cl_numfor(l_gse25,42,g_azi05)   #No.FUN-590111
#                LET l_total_05 = l_total_05 + l_gse05   #No.FUN-590111
#                LET l_total_06 = l_total_06 + l_gse06   #No.FUN-590111
#                LET l_total_25 = l_total_25 + l_gse25   #No.FUN-590111
 
#            END FOREACH
#            IF tm.type = 'Y' OR (tm.type ='N' AND l_cnt > 0) THEN
#                PRINT COLUMN g_c[38],g_x[10] CLIPPED,
#                      COLUMN g_c[40],cl_numfor(l_total_05,40,3),        #No.FUN-590111
#                      COLUMN g_c[41],cl_numfor(l_total_06,41,g_azi05),  #No.FUN-590111
#                      COLUMN g_c[42],cl_numfor(l_total_25,42,g_azi05)   #No.FUN-590111
#            END IF
#            IF (tm.type = 'N' AND l_cnt <= 0 ) THEN
#                PRINT COLUMN  76,''
#            END IF
#        END IF
 
#    ON LAST ROW
#        IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#            THEN PRINT g_dash[1,g_len]
            #TQC-630166
            #IF tm.wc[001,120] > ' ' THEN			# for 132
 		#PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
                #IF tm.wc[121,240] > ' ' THEN
 		#    PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
                #    IF tm.wc[241,300] > ' ' THEN
 		#        PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#             CALL cl_prt_pos_wc(tm.wc)
                   #END TQC-630166
 
#        END IF
#        PRINT g_dash[1,g_len]
#        LET l_last_sw = 'y'
#        PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#    PAGE TRAILER
#       IF l_last_sw = 'n'
#           THEN PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#       ELSE SKIP 2 LINE
#       END IF
#END REPORT
 
#No.FUN-7B0026--end
