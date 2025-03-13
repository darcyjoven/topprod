# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: atmr400.4gl
# Descriptions...: 提案明細表打印
# Date & Author..: 06/03/30 by vivien
# Modify.........: No.FUN-680120 06/08/31 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-7B0031 07/11/06 By Carrier 加入g_bgjob的傳入參數
# Modify.........: No.FUN-860062 08/06/17 By dxfwo  CR報表
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm         RECORD
                     wc      STRING,               # QBE 條件
                     more    LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)             # 輸入其它特殊列印條件
                  END RECORD
DEFINE g_i        LIKE type_file.num5          #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE l_sql      LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
DEFINE l_zaa02    LIKE zaa_file.zaa02
DEFINE i          LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE l_table   STRING                        #No.FUN-860062
DEFINE g_sql     STRING                        #No.FUN-860062                                                           
DEFINE g_str     STRING                        #No.FUN-860062
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
#No.FUN-860062---Begin 
   LET g_sql = " tqa03.tqa_file.tqa03,",
               " tqa01.tqa_file.tqa01,",
               " tqa02.tqa_file.tqa02,",
               " tqaacti.tqa_file.tqaacti "
   LET l_table = cl_prt_temptable('atmr400',g_sql) CLIPPED                                                                          
   IF  l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,? )"  
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
 
   #--外部程式傳遞參數或 Background Job 時接受參數 --#
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_prtway = ARG_VAL(3)
   LET g_rep_user = ARG_VAL(4)
   LET g_rep_clas = ARG_VAL(5)
   LET g_template = ARG_VAL(6)
   LET g_bgjob    = ARG_VAL(7)  #No.TQC-7B0031
   IF cl_null(tm.wc) THEN
        CALL r400_tm(0,0)             # Input print condition
   ELSE LET tm.wc="tqa03= '",tm.wc CLIPPED,"'"
        CALL r400()                   # Read data and create out-file
   END IF
# No.FUN-680120-BEGIN
   CREATE TEMP TABLE curr_tmp(
     curr    LIKE ade_file.ade04,
     amt     LIKE type_file.num20_6,
     order1  LIKE ima_file.ima01,
     order2  LIKE ima_file.ima01,
     order3  LIKE ima_file.ima01);
# No.FUN-680120-END    
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION r400_tm(p_row,p_col)
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
 
   LET p_row = 3 LET p_col = 11
   OPEN WINDOW r400_w AT p_row,p_col WITH FORM "atm/42f/atmr400"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   #預設畫面欄位
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON tqa03
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                
            EXIT CONSTRUCT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         
            CALL cl_about()     
 
         ON ACTION help          
            CALL cl_show_help()  
 
         ON ACTION controlg      
            CALL cl_cmdask()     
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
      END CONSTRUCT
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r400_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.more
            WITHOUT DEFAULTS
 
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD more    #是否輸入其它特殊條件
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         
            CALL cl_about()      
 
         ON ACTION help          
            CALL cl_show_help()  
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r400_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='atmr400'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('atmr400','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",           
                        " '",g_rep_clas CLIPPED,"'",           
                        " '",g_template CLIPPED,"'"            
            CALL cl_cmdat('atmr400',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW r400_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
 
      CALL r400()
 
      ERROR ""
   END WHILE
 
   DROP TABLE curr_tmp   
 
   CLOSE WINDOW r400_w
 
END FUNCTION
 
FUNCTION r400()
DEFINE l_name    LIKE type_file.chr20         #No.FUN-680120 VARCHAR(20)         # External(Disk) file name
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6B0014
DEFINE l_sql     LIKE type_file.chr1000       # SQL STATEMENT        #No.FUN-680120 VARCHAR(1000)
DEFINE l_t1      STRING
DEFINE l_za05    LIKE ima_file.ima01           #No.FUN-680120 VARCHAR(40)
DEFINE sr        RECORD
                        tqa01   LIKE tqa_file.tqa01,
                        tqa02   LIKE tqa_file.tqa02,
                        tqa03   LIKE tqa_file.tqa03,
                        tqaacti LIKE tqa_file.tqaacti
                        END RECORD
 
   #抓取公司名稱
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                   #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND oeauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                   #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #群組權限
   #      LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
   #End:FUN-980030
 
   LET l_sql = "SELECT * FROM tqa_file ",
               " WHERE ", tm.wc CLIPPED,
               " ORDER BY tqa03,tqa01 "
                 
   PREPARE r400_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   DECLARE r400_curs1 CURSOR FOR r400_prepare1
 
#  CALL cl_outnam('atmr400') RETURNING l_name        #No.FUN-860062
 
#  START REPORT r400_rep TO l_name                   #No.FUN-860062 
   CALL cl_del_data(l_table)                         #No.FUN-860062
   LET g_pageno = 0
   FOREACH r400_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
#No.FUN-860062---Begin
           CASE
               WHEN sr.tqa03='1'
                    LET l_t1=g_x[10]
               WHEN sr.tqa03='2'
                    LET l_t1=g_x[11]
               WHEN sr.tqa03='3'
                    LET l_t1=g_x[12]
               WHEN sr.tqa03='4'    
                    LET l_t1=g_x[13]
               WHEN sr.tqa03='5'
                    LET l_t1=g_x[14]
               WHEN sr.tqa03='6'
                    LET l_t1=g_x[15]
               WHEN sr.tqa03='7'
                    LET l_t1=g_x[16]
               WHEN sr.tqa03='8'
                    LET l_t1=g_x[17]
               WHEN sr.tqa03='9'
                    LET l_t1=g_x[18]
               WHEN sr.tqa03='10'
                    LET l_t1=g_x[19]
               WHEN sr.tqa03='11'
                    LET l_t1=g_x[20]
               WHEN sr.tqa03='12'
                    LET l_t1=g_x[21]
               WHEN sr.tqa03='13'
                    LET l_t1=g_x[22]
               WHEN sr.tqa03='13'
                    LET l_t1=g_x[22]
               WHEN sr.tqa03='14'
                    LET l_t1=g_x[23]
               WHEN sr.tqa03='15'
                    LET l_t1=g_x[24]
               WHEN sr.tqa03='16'
                    LET l_t1=g_x[25]
               WHEN sr.tqa03='17'
                    LET l_t1=g_x[26]
               WHEN sr.tqa03='18'
                    LET l_t1=g_x[27]
               WHEN sr.tqa03='19'
                    LET l_t1=g_x[28]
               WHEN sr.tqa03='20'
                    LET l_t1=g_x[29]
           END CASE
#     OUTPUT TO REPORT r400_rep(sr.*)
      EXECUTE insert_prep USING sr.tqa03, sr.tqa01, sr.tqa02, sr.tqaacti
   END FOREACH
 
#  FINISH REPORT r400_rep
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(tm.wc,'tqa03')         
            RETURNING tm.wc                                                                                                           
    END IF                                                                                                                          
     LET g_str = tm.wc                                                       
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                              
     CALL cl_prt_cs3('atmr400','atmr400',l_sql,g_str) 
#No.FUN-860062---End
END FUNCTION
 
 
#No.FUN-860062---Begin
#REPORT r400_rep(sr)
#DEFINE l_last_sw    LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
#DEFINE sr        RECORD
#                    tqa01   LIKE tqa_file.tqa01,
#                    tqa02   LIKE tqa_file.tqa02,
#                    tqa03   LIKE tqa_file.tqa03,
#                    tqaacti LIKE tqa_file.tqaacti
#                 END RECORD,
#                l_str   LIKE ima_file.ima01,        #No.FUN-680120 VARCHAR(40)        
#                l_t1    STRING,                
#                l_str1  LIKE ima_file.ima01,        #No.FUN-680120 VARCHAR(40)            
#                l_str2  LIKE type_file.chr1000,     #No.FUN-680120 VARCHAR(100)     
#                l_str3  LIKE ima_file.ima01,        #No.FUN-680120 VARCHAR(40)            
#		l_sum   LIKE feb_file.feb10,        #No.FUN-680120 DECIMAL(10,2)
#		l_sum1  LIKE feb_file.feb10,        #No.FUN-680120 DECIMAL(10,2)  
#		l_amt_1 LIKE oeb_file.oeb14,   
#		l_amt_2 LIKE oeb_file.oeb12    
# 
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.tqa03,sr.tqa01
#
#  #格式設定
#  FORMAT
#   #列印表頭
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED, pageno_total
#
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],
#            g_x[32],
#            g_x[33],
#            g_x[34]
#      PRINT g_dash1
#      LET l_last_sw = 'y'
#
#   BEFORE GROUP OF sr.tqa03 
#           CASE
#               WHEN sr.tqa03='1'
#                    LET l_t1=g_x[10]
#               WHEN sr.tqa03='2'
#                    LET l_t1=g_x[11]
#               WHEN sr.tqa03='3'
#                    LET l_t1=g_x[12]
#               WHEN sr.tqa03='4'    
#                    LET l_t1=g_x[13]
#               WHEN sr.tqa03='5'
#                    LET l_t1=g_x[14]
#               WHEN sr.tqa03='6'
#                    LET l_t1=g_x[15]
#               WHEN sr.tqa03='7'
#                    LET l_t1=g_x[16]
#               WHEN sr.tqa03='8'
#                    LET l_t1=g_x[17]
#               WHEN sr.tqa03='9'
#                    LET l_t1=g_x[18]
#               WHEN sr.tqa03='10'
#                    LET l_t1=g_x[19]
#               WHEN sr.tqa03='11'
#                    LET l_t1=g_x[20]
#               WHEN sr.tqa03='12'
#                    LET l_t1=g_x[21]
#               WHEN sr.tqa03='13'
#                    LET l_t1=g_x[22]
#               WHEN sr.tqa03='13'
#                    LET l_t1=g_x[22]
#               WHEN sr.tqa03='14'
#                    LET l_t1=g_x[23]
#               WHEN sr.tqa03='15'
#                    LET l_t1=g_x[24]
#               WHEN sr.tqa03='16'
#                    LET l_t1=g_x[25]
#               WHEN sr.tqa03='17'
#                    LET l_t1=g_x[26]
#               WHEN sr.tqa03='18'
#                    LET l_t1=g_x[27]
#               WHEN sr.tqa03='19'
#                    LET l_t1=g_x[28]
#               WHEN sr.tqa03='20'
#                    LET l_t1=g_x[29]
#           END CASE 
#
#      PRINT COLUMN g_c[31],sr.tqa03 CLIPPED,'-',l_t1 CLIPPED;
#
#   ON EVERY ROW
#      PRINT COLUMN g_c[32],sr.tqa01 CLIPPED,
#            COLUMN g_c[33],sr.tqa02 CLIPPED,
#            COLUMN g_c[34],sr.tqaacti
#
#
#       ON LAST ROW
#           PRINT g_dash
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_last_sw = 'n'
#
#       PAGE TRAILER
#           IF l_last_sw = 'y' THEN
#              PRINT g_dash
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#
#END REPORT
#No.FUN-860062---End
#No.FUN-870144
