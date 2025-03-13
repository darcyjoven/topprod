# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: acor306.4gl
# Descriptions...: 保稅料件異常檢核表
# Date & Author..: 03/01/13 By Maggie
# Modify.........: NO.MOD-490398 04/11/23 BY Elva 去掉ima75,LIKE定義方式
# Modify.........: No.FUN-510042 05/01/20 By pengu 報表轉XML
# Modify.........: No.FUN-570243 05/07/25 By Trisy 料件編號開窗
# Modify.........: No.TQC-610082 06/04/19 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-750115 07/05/28 By sherry 報表改為使用Crystal Reports
# Modify.........: No.FUN-760085 07/07/17 By sherry Crystal Report增加打印條件
# Modify.........: No.TQC-780054 07/08/17 By sherry 將31區的INFORMIX語法改成ORCALE語法
# Modify.........: No.MOD-7B0223 07/11/27 By lutingting 添加 抓取是否打印選擇條件
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-A40034 10/04/19 By houlia 追單TQC-A10137
# Modify.........: NO.TQC-A40116 10/04/26 BY liuxqa modify sql

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600) # Where condition
              more    LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1) # Input more condition(Y/N)
              END RECORD
DEFINE   g_i          LIKE type_file.num5      #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE   g_sql        LIKE type_file.chr1000      #No.FUN-680069 VARCHAR(600)
DEFINE   l_table      STRING         #No.FUN-750115
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
 #No.FUN-750115---Begin                                                         
     LET g_sql ="ima01.ima_file.ima01,",                                        
                "ima02.ima_file.ima02,",                                        
                "ima021.ima_file.ima021,",                                      
                "ima15.ima_file.ima15,",                                        
                "l_i.type_file.num5"                                            
     LET l_table = cl_prt_temptable('acor306',g_sql)CLIPPED                     
     IF l_table = -1 THEN EXIT PROGRAM END IF                                   
                                                                                
     #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED," values(?,?,?,?,?) " 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED," values(?,?,?,?,?) "  #TQC-A40116 mod 
     PREPARE insert_prep FROM g_sql                                             
     IF SQLCA.sqlcode THEN                                                      
        CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM                       
     END IF                                                                     
 #No.FUN-750115---End        
 
   INITIALIZE tm.* TO NULL                # Default condition
   LET tm.more = 'N'
   LET g_pdate = ARG_VAL(1)
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL acor306_tm(0,0)
      ELSE CALL acor306()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION acor306_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680069 SMALLINT
         l_cmd        LIKE type_file.chr1000        #No.FUN-680069 VARCHAR(400)
 
   LET p_row = 5 LET p_col = 30
 
   OPEN WINDOW acor306_w AT p_row,p_col WITH FORM "aco/42f/acor306"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more= 'N'
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
 
 WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON ima01,coa03  #NO.MOD-490398
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
#No.FUN-570243 --start--
      ON ACTION CONTROLP
            IF INFIELD(ima01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            END IF
#No.FUN-570243 --end--
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
      LET INT_FLAG = 0 CLOSE WINDOW acor306_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more NOT MATCHES '[YN]' OR tm.more IS NULL THEN
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
      ON ACTION CONTROLG CALL cl_cmdask()     # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW acor306_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='acor306'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('acor306','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang   CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",
                        #" '",tm.more  CLIPPED,"'",         #No.TQC-610082 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('acor306',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW acor306_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL acor306()
   ERROR ""
END WHILE
   CLOSE WINDOW acor306_w
END FUNCTION
 
FUNCTION acor306()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(20) # External(Disk) file name
#         l_time    LIKE type_file.chr8        #No.FUN-6A0063
          l_sql     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600)
          l_za05    LIKE cob_file.cob01,         #No.FUN-680069 VARCHAR(40)
          sr        RECORD
                    ima01  LIKE ima_file.ima01,  #料件編號
                    ima02  LIKE ima_file.ima02,  #品名規格
                    ima021 LIKE ima_file.ima021, #品名規格
                    ima15  LIKE ima_file.ima15,  #保稅與否
                    cob01  LIKE cob_file.cob01,
                    chr    LIKE type_file.chr1   #No.FUN-680069 VARCHAR(01)
                    END RECORD
   DEFINE l_str     LIKE type_file.chr1000    #No.FUN-750115
   DEFINE l_i       LIKE type_file.num5       #No.FUN-750115
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'acor306'    #No.MOD-7B0223
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND coquser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND coqgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND coqgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('coquser', 'coqgrup')
     #End:FUN-980030
 
     #LET l_sql = "SELECT ima01,ima02,ima15,cob01,'' ",
     LET l_sql = "SELECT ima01,ima02,ima021,ima15,'','' ",
 #NO.MOD-490398--begin
#                "  FROM ima_file,OUTER cob_file ",
#                " WHERE cob01 = ima75 ",
                 #"  FROM ima_file,cob_file,OUTER coa_file ",
             #   "  FROM ima_file LEFT OUTER JOIN coa_file ON ima01 = coa01 ",    #No.FUN-750115
             #No.TQC-780054---Begin 
             #   "  FROM ima_file LEFT OUTER JOIN coa_file ON ima01 = coa01 ",         
                 "  FROM ima_file LEFT OUTER JOIN coa_file ON ima01 = coa01 ",    
                 #" WHERE coa01 = ima01 AND coa03 = cob01 ",
                 #" WHERE 1 = 1",    
                 " WHERE 1 = 1",
             #No.TQC-780054---End  
 #NO.MOD-490398--end
                 "   AND ",tm.wc CLIPPED
 
     PREPARE acor306_prepare FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor306_curs CURSOR FOR acor306_prepare
 
#No.FUN-750115---Begin
#    CALL cl_outnam('acor306') RETURNING l_name    
#    START REPORT acor306_rep TO l_name            
#    LET g_pageno = 0 
     CALL cl_del_data(l_table) 
#No.FUN-750115---End 
 
     FOREACH acor306_curs INTO sr.*
        IF SQLCA.sqlcode  THEN
           CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
        END IF
#        IF sr.ima15 = 'Y' AND cl_null(sr.cob01) THEN
#           LET sr.chr = '1'
#          OUTPUT TO REPORT acor306_rep(sr.*)    #No.FUN-750115
#        END IF
#        IF sr.ima15 = 'N' AND NOT cl_null(sr.cob01) THEN
#           LET sr.chr = '2'
#           OUTPUT TO REPORT acor306_rep(sr.*)
#        END IF
#No.FUN-750115---Begin   
     LET l_i=0
     SELECT COUNT(*) INTO l_i FROM coa_file,cob_file                        
          WHERE coa01=sr.ima01 AND coa03=cob01
          IF (l_i=0 AND sr.ima15='Y') OR (l_i<>0 AND sr.ima15='N') THEN
          EXECUTE insert_prep USING
                sr.ima01,sr.ima02,sr.ima021,sr.ima15,l_i
          END IF
     END FOREACH
 
#    FINISH REPORT acor306_rep     #No.FUN-750115
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED        #CHI-A40034
     #No.FUN-760085---Begin 
     IF g_zz05 = 'Y' THEN                                                     
        CALL cl_wcchp(tm.wc,'ima01,coa03')      
          RETURNING tm.wc                                                     
        LET l_str = tm.wc          
     END IF                                                                   
     LET l_str = tm.wc         
     #No.FUN-760085---End
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     CALL cl_prt_cs3('acor306','acor306',l_sql,l_str) 
#No.FUN-750115---End
END FUNCTION
 
#No.FUN-750115---Begin
{
REPORT acor306_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
          l_i       LIKE type_file.num5,          #No.FUN-680069 SMALLINT
          sr        RECORD
                    ima01  LIKE ima_file.ima01,  #料件編號
                    ima02  LIKE ima_file.ima02,  #品名規格
                    ima021 LIKE ima_file.ima021,  #品名規格
                    ima15  LIKE ima_file.ima15,  #保稅與否
                    cob01  LIKE cob_file.cob01,
                    chr    LIKE type_file.chr1         #No.FUN-680069 VARCHAR(1)
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 
  ORDER BY sr.ima01
  FORMAT
   PAGE HEADER
      PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT ' '
      PRINT g_dash[1,g_len]
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[34] CLIPPED,g_x[33] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
 #NO.MOD-490398--begin
         LET l_i = 0
         SELECT COUNT(*) INTO l_i FROM coa_file,cob_file
          WHERE coa01=sr.ima01 AND coa03=cob01
         IF l_i = 0 THEN
            IF sr.ima15 = 'Y' THEN
               PRINT COLUMN g_c[31],sr.ima01,
                     COLUMN g_c[32],sr.ima02,
                     COLUMN g_c[34],sr.ima021,
                     COLUMN g_c[33],g_x[13]
            END IF
         ELSE
            IF sr.ima15 = 'N' THEN
               PRINT COLUMN g_c[31],sr.ima01,
                     COLUMN g_c[32],sr.ima02,
                     COLUMN g_c[33],g_x[14]
            END IF
         END IF
 #NO.MOD-490398--end
 
   ON LAST ROW
       PRINT g_dash[1,g_len] CLIPPED
       LET l_last_sw = 'y'
       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len] CLIPPED
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-750115---End
