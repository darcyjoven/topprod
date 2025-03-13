# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: asrr260.4gl
# Descriptions...: 機台(生產線)稼動率分析表(每月)
# Input parameter:
# Return code....:
# Date & Author..: 06/03/03 By kim
# Modify.........: No.FUN-680130 06/08/31 By zhuying 欄位形態定義為LIKE
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-6C0142 06/12/28 By ray 表頭調整
# Modify.........: No.TQC-770003 07/07/01 By hongmei help按鈕不可用
# Modify.........: No.FUN-7B0103 07/11/22 BY xiaofeizhu報表改為Crystal Report或p_query
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80063 11/08/05 By fanbj  EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD		               # Print condition RECORD
        wc      STRING,                        # Where Condition                    
        yy      LIKE type_file.num5,           #No.FUN-680130 SMALLINT
        mm      LIKE type_file.num5,           #No.FUN-680130 SMALLINT
      	more	LIKE type_file.chr1   	       # Input more condition(Y/N)   #No.FUN-680130 VARCHAR(1)
           END RECORD,
        g_argv1       LIKE srf_file.srf03
DEFINE  g_cnt         LIKE type_file.num10    #No.FUN-680130 INTEGER
DEFINE  g_i           LIKE type_file.num5     #count/index for any purpose   #No.FUN-680130 SMALLINT
DEFINE  l_table       STRING,                 ### FUN-7B0103 ###                                                                    
        g_str         STRING,                 ### FUN-7B0103 ###                                                                    
        g_sql         STRING                  ### FUN-7B0103 ###
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASR")) THEN
      EXIT PROGRAM
   END IF
### *** FUN-7B0103 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
   LET g_sql = "srf03.srf_file.srf03,",                                                                                             
               "eci06.eci_file.eci06,",                                                                                             
               "time1.srg_file.srg10,",                                                                                             
               "time2.srg_file.srg10,",                                                                                             
               "time3.srg_file.srg10"                                                                                               
    LET l_table = cl_prt_temptable('asrr260',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                " VALUES(?, ?, ?, ?, ?)"                                                                                         
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET g_argv1  = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      # FUN-B80063--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN       # If background job sw is off
      IF cl_null(g_argv1) THEN
         CALL r260_tm()
      ELSE
         LET tm.wc=" srf03 = '",g_argv1,"'"
         CALL cl_wait()
         CALL r260_out()
      END IF
   ELSE                                  	# Read data and create out-file
       CALL r260_out()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
END MAIN
 
FUNCTION r260_tm()
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE l_cmd		LIKE type_file.chr1000#No.FUN-680130 VARCHAR(66)
   DEFINE p_row,p_col   LIKE type_file.num5   #No.FUN-680130 SMALLINT
 
   LET p_row = 5 LET p_col = 20
   OPEN WINDOW r260_w AT p_row,p_col
        WITH FORM "asr/42f/asrr260"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.yy=YEAR(g_today)
   LET tm.mm=MONTH(g_today)              
   LET tm.more = 'N'
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON srf03
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
           ON ACTION CONTROLP
              CASE
                 WHEN INFIELD(srf03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_eci"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO srf03
                   NEXT FIELD srf03
              END CASE
           ON ACTION locale
               LET g_action_choice = "locale"
               CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
               EXIT CONSTRUCT
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE CONSTRUCT
              
           ON ACTION CONTROLG 
              CALL cl_cmdask()
 
           ON ACTION help           #No.TQC-770003                                                                                                     
              CALL cl_show_help()   #No.TQC-770003
 
           ON ACTION exit
              LET INT_FLAG = 1
              EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('srfuser', 'srfgrup') #FUN-980030
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      EXIT WHILE
   END IF
 
   DISPLAY BY NAME tm.yy,tm.mm,tm.more # Condition
   INPUT BY NAME tm.yy,tm.mm,tm.more WITHOUT DEFAULTS
 
      #No.FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD mm
         IF (NOT cl_null(tm.yy)) AND (NOT cl_null(tm.mm)) THEN
            IF MDY(tm.mm,1,tm.yy) IS NULL THEN
               NEXT FIELD yy
            END IF
         END IF
      AFTER FIELD more
    	 IF tm.more NOT MATCHES '[YN]' THEN
    	    NEXT FIELD more
    	 END IF
       IF tm.more = 'Y'
          THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
       END IF
 
      ON ACTION CONTROLP
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG 
         CALL cl_cmdask()	# Command execution
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
      #No.FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      EXIT WHILE
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='asrr260'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asrr260','9031',1)   
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('asrr260',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r260_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r260_out()
   ERROR ""
 END WHILE
 CLOSE WINDOW r260_w
END FUNCTION
 
FUNCTION r260_out()
#     DEFINE   l_time LIKE type_file.chr8       #No.FUN-6B0014
DEFINE    l_name   LIKE type_file.chr20,         #No.FUN-680130 VARCHAR(20)
          l_sql    STRING, 
          l_eca06  LIKE eca_file.eca06,
          l_eci05  LIKE eci_file.eci05,
          l_eci09  LIKE eci_file.eci09,
          l_count  LIKE type_file.num10,         #No.FUN-680130 INTEGER
          l_bdate,l_edate  LIKE type_file.dat,   #No.FUN-680130 DATE
          l_ecn03  LIKE ecn_file.ecn03,
          sr  RECORD
                 srf03 LIKE srf_file.srf03,
                 eci06 LIKE eci_file.eci06,
                 srg10 LIKE srg_file.srg10,
                 time1 LIKE srg_file.srg10, #實際機器生產工時
                 time2 LIKE srg_file.srg10, #最大產能
                 time3 LIKE srg_file.srg10  #稼動率
              END RECORD
 
     # No.FUN-B80063----start mark---------------------------------------------------------------
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6B0014
     # No.FUN-B80063----start mark----------------------------------------------------------------

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET l_bdate=MDY(tm.mm,1,tm.yy)
     LET l_edate=r260_GETLASTDAY(MDY(tm.mm,1,tm.yy))
     LET l_sql = " SELECT srf03,'',SUM(srg10),0,0,0 FROM srf_file,srg_file",
                 "  WHERE srf01=srg01 AND ",tm.wc CLIPPED,
                 "    AND srfconf='Y'"
     IF (NOT cl_null(tm.yy)) AND (NOT cl_null(tm.mm)) THEN
        LET l_sql=l_sql," AND srf02>='",l_bdate,"'"
        LET l_sql=l_sql," AND srf02<='",l_edate,"'"
     END IF
     LET l_sql=l_sql," GROUP BY srf03"
     PREPARE r260_pr1 FROM l_sql
     IF STATUS THEN 
        CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
        EXIT PROGRAM 
     END IF
     DECLARE r260_cs1 CURSOR FOR r260_pr1
 
#    CALL cl_outnam('asrr260') RETURNING l_name                 #No.FUN-7B0103            
     ## *** 與 Crystal Reports 串聯段 -- <<<< 清除暫存資料 >>>> --- FUN-7B0103 *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-7B0103 add ###                                              
     #------------------------------ CR (2) ------------------------------#
     LET g_pageno = 0
#    START REPORT r260_rep TO l_name                            #No.FUN-7B0103 
 
     FOREACH r260_cs1 INTO sr.*
        IF STATUS THEN 
           CALL cl_err('for srf:',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
           EXIT PROGRAM
        END IF
        SELECT MAX(ecn03) INTO l_ecn03 FROM ecn_file
           WHERE ecn02 BETWEEN l_bdate AND l_edate
        SELECT COUNT(ecn02) INTO l_count FROM ecn_file
           WHERE ecn02 BETWEEN l_bdate AND l_edate
             AND ecn03 = l_ecn03
        IF SQLCA.sqlcode OR cl_null(l_count) OR (l_count=0) THEN
           LET l_count=0
           CALL cl_err('sel ecn04',100,0)                 
        END IF
        SELECT eci06 INTO sr.eci06 FROM eci_file
           WHERE eci01=sr.srf03
        IF SQLCA.sqlcode THEN
           LET sr.eci06=''
        END IF
        LET sr.time1=sr.srg10/60
        
        SELECT eca06,eci05,eci09 INTO l_eca06,l_eci05,l_eci09 
           FROM eca_file,eci_file WHERE eca01=eci03 
                                    AND eci01=sr.srf03
        CASE l_eca06
           WHEN "1" #機器產能
              LET sr.time2=l_eci05
           WHEN "2" #人工產能
              LET sr.time2=l_eci09
           OTHERWISE 
              LET sr.time2=0
        END CASE
        LET sr.time2=sr.time2*l_count
        LET sr.time3=(sr.time1/sr.time2)*100
#       OUTPUT TO REPORT r260_rep(sr.*)                                            #No.FUN-7B0103
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-7B0103 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
                   sr.srf03,sr.eci06,sr.time1,sr.time2,sr.time3                                                            
          #------------------------------ CR (3) ------------------------------#
     END FOREACH
 
#No.FUN-7B0103--Begin-Add                                                                                                           
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'srf03')                                                                                               
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                        
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-7B0103 **** ##                                                     
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = tm.wc,";",tm.yy,";",tm.mm                                                                                     
    CALL cl_prt_cs3('asrr260','asrr260',l_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#                                                          
#No.FUN-7B0103--End-Add
 
#    FINISH REPORT r260_rep                                                        #No.FUN-7B0103
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                                   #No.FUN-7B0103
     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6B0014
     #No.FUN-BB0047--mark--End-----
END FUNCTION
 
#No.FUN-7B0103--Begin-Mark--
#REPORT r260_rep(sr)
#  DEFINE l_str     STRING, 
#         l_last_sw LIKE type_file.chr1,    #No.FUN-680130 VARCHAR(1)
#         sr  RECORD
#                srf03 LIKE srf_file.srf03,
#                eci06 LIKE eci_file.eci06,
#                srg10 LIKE srg_file.srg10,
#                time1 LIKE srg_file.srg10, #實際機器生產工時
#                time2 LIKE srg_file.srg10, #最大產能
#                time3 LIKE srg_file.srg10  #嫁動率
#             END RECORD
#
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
 
#  ORDER BY sr.srf03
 
# FORMAT
#    PAGE HEADER
#       PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
#No.TQC-6C0142 --begin
#       LET g_pageno = g_pageno + 1
#       LET pageno_total = PAGENO USING '<<<'
#       PRINT g_x[2] CLIPPED,TODAY,' ',TIME;
#       PRINT COLUMN (g_len-FGL_WIDTH(g_user)-14),'FROM:',g_user CLIPPED;
#       PRINT COLUMN g_len-7,g_x[3] CLIPPED,pageno_total USING '<<<'
#       PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#       LET l_str=g_x[11] CLIPPED,' ',tm.yy,' / ',tm.mm
#       PRINT COLUMN ((g_len-FGL_WIDTH(l_str))/2)+1,l_str 
#       PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#       LET g_pageno = g_pageno + 1
#       LET pageno_total = PAGENO USING '<<<'
#       PRINT g_x[2] CLIPPED,TODAY,' ',TIME;
#       LET l_str=g_x[11] CLIPPED,' ',tm.yy,' / ',tm.mm
#       PRINT COLUMN ((g_len-FGL_WIDTH(l_str))/2)+1,l_str;
#       PRINT COLUMN (g_len-FGL_WIDTH(g_user)-14),'FROM:',g_user CLIPPED;
#       PRINT COLUMN g_len-7,g_x[3] CLIPPED,pageno_total USING '<<<'
#No.TQC-6C0142 --end
#       PRINT g_dash
#       PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
#       PRINT g_dash1
#       LET l_last_sw = 'n'
 
#    ON EVERY ROW
#     PRINT COLUMN g_c[31],sr.srf03,
#           COLUMN g_c[32],sr.eci06,
#           COLUMN g_c[33],cl_numfor(sr.time1,33,3),
#           COLUMN g_c[34],cl_numfor(sr.time2,34,3),
#           COLUMN g_c[35],cl_numfor(sr.time3,35,3)
 
#    ON LAST ROW
#       LET l_last_sw = 'y'
 
#    PAGE TRAILER
#       PRINT g_dash
#       IF l_last_sw = 'n' THEN
#          PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[9] CLIPPED
#       ELSE 
#          PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[10] CLIPPED
#       END IF
#END REPORT
#No.FUN-7B0103-End-Mark--
 
FUNCTION r260_GETLASTDAY(p_date)
DEFINE p_date    LIKE type_file.dat        #No.FUN-680130 DATE
   IF p_date IS NULL OR p_date=0 THEN
      RETURN 0
   END IF
   IF MONTH(p_date)=12 THEN
      RETURN MDY(1,1,YEAR(p_date)+1)-1
   ELSE
      RETURN MDY(MONTH(p_date)+1,1,YEAR(p_date))-1
   END IF
END FUNCTION
