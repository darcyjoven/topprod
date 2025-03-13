# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: atmr320.4gl
# Descriptions...: 配送schedule表列印
# Date & Author..: 06/03/30 By Sarah
# Modify.........: No.FUN-630027 06/03/30 By Sarah 新增"配送schedule表列印"
# Modify.........: No.FUN-680120 06/08/31 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-6C0119 06/12/20 By Ray 表頭調整
# Modify.........: No.TQC-790074 07/09/12 By lumxa 打印時程序抬頭名稱在“制表日期”下面
# Modify.........: No.FUN-860062 08/06/17 By dxfwo  CR報表
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm        RECORD		              # Print condition RECORD
                  wc       STRING,            # Where Condition
                  bdate    LIKE type_file.dat,          #No.FUN-680120 DATE
                  edate    LIKE type_file.dat,          #No.FUN-680120 DATE
                  more     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)	      # Input more condition(Y/N)
                 END RECORD
DEFINE g_cnt     LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE g_i       LIKE type_file.num5          #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE l_table   STRING                       #No.FUN-860062                                                             
DEFINE l_sql     STRING                       #No.FUN-860062 
DEFINE g_sql     STRING                       #No.FUN-860062                                                           
DEFINE g_str     STRING                       #No.FUN-860062
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   LET g_pdate  = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
#No.FUN-860062---Begin 
   LET g_sql = " oea1015.oea_file.oea1015,",
               " pmc03.pmc_file.pmc03,",
               " oea03.oea_file.oea03,",
               " oea032.oea_file.oea032,",
               " oea04.oea_file.oea04,",
               " occ02.occ_file.occ02,",
               " oea01.oea_file.oea01,",
               " oea02.oea_file.oea02,",
               " oea10.oea_file.oea10,",
               " oeb03.oeb_file.oeb03,",
               " oeb04.oeb_file.oeb04,",
               " oeb06.oeb_file.oeb06,",
               " oeb16.oeb_file.oeb16,",
               " oeb05.oeb_file.oeb05,",
               " oeb12.oeb_file.oeb12 "
   LET l_table = cl_prt_temptable('atmr320',g_sql) CLIPPED                                                                          
   IF  l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,? )"  
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF
            
#No.FUN-860062---End  
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN     # If background job sw is off
      CALL r320_tm()
   ELSE
      CALL r320_out()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION r320_tm()
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE l_cmd		LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(400)
   DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
   LET p_row = 5 LET p_col = 20
   OPEN WINDOW r320_w AT p_row,p_col WITH FORM "atm/42f/atmr320"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more = 'N'
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'   
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON oea1015,oea03,oea032,oea04
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(oea1015)   #代送商
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_pmc8'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea1015
                  NEXT FIELD oea1015
               WHEN INFIELD(oea03)     #客戶編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_occ"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea03
                  NEXT FIELD oea03
               WHEN INFIELD(oea04)     #送貨客戶
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_occ"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea04
                  NEXT FIELD oea04
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
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup') #FUN-980030
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
 
      #預設訂單日期範圍為本月第一天~本月最後一天
      LET tm.bdate = MDY(MONTH(g_today),1,YEAR(g_today))
      IF MONTH(tm.bdate)=12 THEN
         LET tm.edate = MDY(1,1,YEAR(tm.bdate)+1)-1
      ELSE
         LET tm.edate = MDY(MONTH(tm.bdate)+1,1,YEAR(tm.bdate))-1
      END IF
      DISPLAY BY NAME tm.bdate,tm.edate,tm.more
 
      INPUT BY NAME tm.bdate,tm.edate,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         ON CHANGE bdate
            IF MONTH(tm.bdate)=12 THEN
               LET tm.edate = MDY(1,1,YEAR(tm.bdate)+1)-1
            ELSE
               LET tm.edate = MDY(MONTH(tm.bdate)+1,1,YEAR(tm.bdate))-1
            END IF
            DISPLAY BY NAME tm.edate
 
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
         SELECT zz08 INTO l_cmd FROM zz_file WHERE zz01='atmr320'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('atmr320','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_lang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.bdate CLIPPED,"'",
                            " '",tm.edate CLIPPED,"'",
                            " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                            " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                            " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('atmr320',g_time,l_cmd)	# Execute cmd at later time
         END IF
         CLOSE WINDOW r320_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r320_out()
      ERROR ""
   END WHILE
   CLOSE WINDOW r320_w
END FUNCTION
 
FUNCTION r320_out()
#     DEFINE   l_time LIKE type_file.chr8       #No.FUN-6B0014
DEFINE    l_name   LIKE type_file.chr20,         #No.FUN-680120 VARCHAR(20)
          l_sql    STRING,
          l_eca06  LIKE eca_file.eca06,
          l_eci05  LIKE eci_file.eci05,
          l_eci09  LIKE eci_file.eci09,
          sr       RECORD
                    oea1015  LIKE oea_file.oea1015,
                    pmc03    LIKE pmc_file.pmc03,
                    oea03    LIKE oea_file.oea03,
                    oea032   LIKE oea_file.oea032, 
                    oea04    LIKE oea_file.oea04,
                    occ02    LIKE occ_file.occ02, 
                    oea01    LIKE oea_file.oea01,
                    oea02    LIKE oea_file.oea02,
                    oea10    LIKE oea_file.oea10,
                    oeb03    LIKE oeb_file.oeb03,
                    oeb04    LIKE oeb_file.oeb04,
                    oeb06    LIKE oeb_file.oeb06,
                    oeb16    LIKE oeb_file.oeb16,
                    oeb05    LIKE oeb_file.oeb05,
                    oeb12    LIKE oeb_file.oeb12
                   END RECORD
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   LET l_sql = "SELECT oea1015,pmc03,oea03,oea032,oea04,occ02,oea01,",
               "       oea02,oea10,oeb03,oeb04,oeb06,oeb16,oeb05,oeb12 ",
               "  FROM oea_file,oeb_file,pmc_file,occ_file ",
               " WHERE oea01 = oeb01 ",
               "   AND oea1015 = pmc01 ",
               "   AND oea04 = occ01 ",
               "   AND ",tm.wc CLIPPED,
               "   AND oeaconf = 'Y' ",
               "   AND oea02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
               " ORDER BY oea1015,oea03,oea04,oea01"
   PREPARE r320_p1 FROM l_sql
   IF STATUS THEN 
      CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM 
   END IF
   DECLARE r320_c1 CURSOR FOR r320_p1
 
#  CALL cl_outnam('atmr320') RETURNING l_name  #No.FUN-860062
 
   LET g_pageno = 0
#  START REPORT r320_rep TO l_name             #No.FUN-860062
   CALL cl_del_data(l_table)                   #No.FUN-860062
 
   FOREACH r320_c1 INTO sr.*
     IF STATUS THEN 
        CALL cl_err('FOREACH:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM
     END IF
#No.FUN-860062---Begin
#    OUTPUT TO REPORT r320_rep(sr.*)
     EXECUTE insert_prep USING  sr.oea1015, sr.pmc03, sr.oea03, sr.oea032, sr.oea04, sr.occ02, 
                                sr.oea01,   sr.oea02, sr.oea10, sr.oeb03,  sr.oeb04, sr.oeb06,
                                sr.oeb16,   sr.oeb05, sr.oeb12    
   END FOREACH
 
#  FINISH REPORT r320_rep
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(tm.wc,'oea1015,oea03,oea032,oea04')         
            RETURNING tm.wc                                                                                                           
    END IF                                                                                                                          
     LET g_str = tm.wc,";",tm.bdate,";",tm.edate                                                         
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                              
     CALL cl_prt_cs3('atmr320','atmr320',l_sql,g_str) 
#No.FUN-860062---End
END FUNCTION
#No.FUN-860062---Begin
#REPORT r320_rep(sr)
#   DEFINE l_str        STRING,
#          l_last_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
#          sr           RECORD
#                        oea1015  LIKE oea_file.oea1015,
#                        pmc03    LIKE pmc_file.pmc03,
#                        oea03    LIKE oea_file.oea03,
#                        oea032   LIKE oea_file.oea032, 
#                        oea04    LIKE oea_file.oea04,
#                        occ02    LIKE occ_file.occ02, 
#                        oea01    LIKE oea_file.oea01,
#                        oea02    LIKE oea_file.oea02,
#                        oea10    LIKE oea_file.oea10,
#                        oeb03    LIKE oeb_file.oeb03,
#                        oeb04    LIKE oeb_file.oeb04,
#                        oeb06    LIKE oeb_file.oeb06,
#                        oeb16    LIKE oeb_file.oeb16,
#                        oeb05    LIKE oeb_file.oeb05,
#                        oeb12    LIKE oeb_file.oeb12
#                       END RECORD
#
#   OUTPUT TOP MARGIN g_top_margin
#          LEFT MARGIN g_left_margin
#          BOTTOM MARGIN g_bottom_margin
#          PAGE LENGTH g_page_line
#
#   ORDER EXTERNAL BY sr.oea1015,sr.oea03,sr.oea04,sr.oea01
#
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
#        PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]     #TQC-790074                           
##No.TQC-6C0119 --begin
#        LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<'
#        PRINT g_x[2] CLIPPED,TODAY,' ',TIME;
#        PRINT COLUMN ((g_len-FGL_WIDTH(l_str))/2)+1,
#              COLUMN (g_len-FGL_WIDTH(g_user)-14),'FROM:',g_user CLIPPED,
#              COLUMN g_len-7,g_x[3] CLIPPED,pageno_total USING '<<<'
##No.TQC-6C0119 --end
##       PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]     #TQC-790074                           
##No.TQC-6C0119 --begin
#        PRINT
##       LET g_pageno = g_pageno + 1
##       LET pageno_total = PAGENO USING '<<<'
##       PRINT g_x[2] CLIPPED,TODAY,' ',TIME;
##       PRINT COLUMN ((g_len-FGL_WIDTH(l_str))/2)+1,
##             COLUMN (g_len-FGL_WIDTH(g_user)-14),'FROM:',g_user CLIPPED,
##             COLUMN g_len-7,g_x[3] CLIPPED,pageno_total USING '<<<'
##No.TQC-6C0119 --end
#        PRINT g_dash
#
#     BEFORE GROUP of sr.oea1015
#        SKIP TO TOP OF PAGE
#        PRINT g_x[11] CLIPPED,sr.oea1015,1 SPACES,sr.pmc03
#        PRINT g_x[12] CLIPPED,tm.bdate,'-',tm.edate
#        PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#              g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]
#        PRINT g_dash1
#        LET l_last_sw = 'n'
#
#     ON EVERY ROW
#        PRINT COLUMN g_c[31],sr.oea03,
#              COLUMN g_c[32],sr.oea032,
#              COLUMN g_c[33],sr.oea04,
#              COLUMN g_c[34],sr.occ02,
#              COLUMN g_c[35],sr.oea01,
#              COLUMN g_c[36],sr.oea02,
#              COLUMN g_c[37],sr.oea10,
#              COLUMN g_c[38],sr.oeb03,
#              COLUMN g_c[39],sr.oeb04,
#              COLUMN g_c[40],sr.oeb06,
#              COLUMN g_c[41],sr.oeb16,
#              COLUMN g_c[42],sr.oeb05,
#              COLUMN g_c[43],sr.oeb12
#
#     ON LAST ROW
#        LET l_last_sw = 'y'
#
#     PAGE TRAILER
#        PRINT g_dash
#        IF l_last_sw = 'n' THEN
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[9] CLIPPED
#        ELSE 
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[10] CLIPPED
#        END IF
#END REPORT
#No.FUN-860062---End
#No.FUN-870144
