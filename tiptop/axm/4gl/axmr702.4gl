# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmr702.4gl
# Descriptions...: 業務員預計簽約明細表
# Input parameter:
# Return code....:
# Date & Author..: 02/12/04 By Carrier
# Modify.........: NO.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
#
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-850014 08/05/06 By xiaofeizhu 報表輸出改為CR
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-D50056 13/07/06 By yangtt 增加業務員編號、潛在客戶編號開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                           # Print condition RECORD
              wc     STRING,     # Where condition
              o      LIKE csd_file.csd04,      # No.FUN-680137 DEC(7,4)
              more   LIKE type_file.chr1       # No.FUN-680137 VARCHAR(1)     # Input more condition(Y/N)
          END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
 
#No.FUN-850014 --Add--Begin--                                                                                                       
  DEFINE   l_table         STRING                                                                                                   
  DEFINE   g_str           STRING                                                                                                   
  DEFINE   g_sql           STRING                                                                                                   
#No.FUN-850014 --Add--End--
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                            # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
#No.FUN-850014 --Add--Begin--                                                                                                       
#--------------------------CR(1)--------------------------------#                                                                   
   LET g_sql = " ofd23.ofd_file.ofd23,",
               " gen02.gen_file.gen02,",
               " ofd01.ofd_file.ofd01,",
               " ofd02.ofd_file.ofd02,",
               " ofd10.ofd_file.ofd10,",
               " ofd27.ofd_file.ofd27,",
               " ofd28.ofd_file.ofd28,",
               " ofd29.ofd_file.ofd29"
 
    LET l_table = cl_prt_temptable('axmr702',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                          
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?)"                                                                                    
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                                   
 
#--------------------------CR(1)--------------------------------#
 
   LET g_pdate = ARG_VAL(1)                   # Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.o    = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL r702_tm(0,0)               # Input print condition
      ELSE CALL r702()                     # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION r702_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col   LIKE type_file.num5,         #No.FUN-680137 SMALLINT
          l_cmd         LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 7 LET p_col = 18
 
   OPEN WINDOW r702_w AT p_row,p_col WITH FORM "axm/42f/axmr702"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.more = 'N'
   LET tm.o    = 0
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ofd23,ofd01,ofd10,ofd27
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---

   #TQC-D50056--add--start
      ON ACTION CONTROLP
         IF INFIELD (ofd23) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ofd23"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ofd23
            NEXT FIELD ofd23
         END IF
         IF INFIELD (ofd01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ofd"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ofd01
            NEXT FIELD ofd01
         END IF
   #TQC-D50056--add--end
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r702_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.o,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD o
         IF tm.o >100 OR tm.o <0 THEN NEXT FIELD o END IF
         IF cl_null(tm.o) THEN LET tm.o = 0 END IF
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
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()        # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW r702_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr702'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr702','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang   CLIPPED,"'",
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",
                         " '",tm.o     CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axmr702',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r702_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r702()
   ERROR ""
END WHILE
   CLOSE WINDOW r702_w
END FUNCTION
 
FUNCTION r702()
   DEFINE l_name        LIKE type_file.chr20,                # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8            #No.FUN-6A0094
          l_sql         LIKE type_file.chr1000,              # RDSQL STATEMENT                 #No.FUN-680137 VARCHAR(600)
          l_za05        LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          sr            RECORD ofd23 LIKE ofd_file.ofd23,
                               gen02 LIKE gen_file.gen02,
                               ofd01 LIKE ofd_file.ofd01,
                               ofd02 LIKE ofd_file.ofd02,
                               ofd10 LIKE ofd_file.ofd10,
                               ofd27 LIKE ofd_file.ofd27,
                               ofd28 LIKE ofd_file.ofd28,
                               ofd29 LIKE ofd_file.ofd29
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR                                    #No.FUN-850014
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-850014 *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-850014 add ###                                              
     #------------------------------ CR (2) ------------------------------#
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc CLIPPED," AND ofduser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc CLIPPED," AND ofdgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc CLIPPED," AND ofdgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ofduser', 'ofdgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT ofd23,gen02,ofd01,ofd02,ofd10,ofd27,ofd28,ofd29 ",
                 " FROM ofd_file,OUTER gen_file ",
                 "WHERE ofd_file.ofd23 = gen_file.gen01 ",
                 "  AND ofd29 >= ",tm.o,
                 "  AND ofd22 IN ('0','1','2') ",
                 "  AND ",tm.wc CLIPPED,
                 "ORDER BY ofd23 "
 
     PREPARE r702_prepare FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
           
     END IF
     DECLARE r702_cs CURSOR FOR r702_prepare
#    CALL cl_outnam('axmr702') RETURNING l_name                                         #No.FUN-850014
#    START REPORT r702_rep TO l_name                                                    #No.FUN-850014
 
#    LET g_pageno = 0                                                                   #No.FUN-850014
     FOREACH r702_cs INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
#      OUTPUT TO REPORT r702_rep(sr.*)                                                  #No.FUN-850014
 
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-850014 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
                   sr.ofd23,sr.gen02,sr.ofd01,sr.ofd02,sr.ofd10,sr.ofd27,sr.ofd28,sr.ofd29
          #------------------------------ CR (3) ------------------------------#
 
     END FOREACH
 
#    FINISH REPORT r702_rep                                                             #No.FUN-850014
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                                        #No.FUN-850014
 
#No.FUN-850014--begin                                                                                                               
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'ofd23,ofd01,ofd02,ofd10,ofd27,ofd28')                                                               
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                        
#No.FUN-850014--end                                                                                                                 
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-850014 **** ##                                                        
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = tm.wc,";",g_azi04                                                         
    CALL cl_prt_cs3('axmr702','axmr702',l_sql,g_str)                                                                                  
    #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
 
#No.FUN-850014--Mark--Begin--##
#REPORT r702_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
#         sr            RECORD ofd23 LIKE ofd_file.ofd23,
#                              gen02 LIKE gen_file.gen02,
#                              ofd01 LIKE ofd_file.ofd01,
#                              ofd02 LIKE ofd_file.ofd02,
#                              ofd10 LIKE ofd_file.ofd10,
#                              ofd27 LIKE ofd_file.ofd27,
#                              ofd28 LIKE ofd_file.ofd28,
#                              ofd29 LIKE ofd_file.ofd29
#                       END RECORD
 
# OUTPUT TOP MARGIN g_top_margin
# LEFT MARGIN g_left_margin
# BOTTOM MARGIN g_bottom_margin
# PAGE LENGTH g_page_line
# ORDER BY sr.ofd23,sr.ofd10,sr.ofd01
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<','/pageno'
#     PRINT g_head CLIPPED, pageno_total
#     PRINT ''
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31],
#           g_x[32],
#           g_x[33],
#           g_x[34],
#           g_x[35],
#           g_x[36],
#           g_x[37],
#           g_x[38]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.ofd23
#     PRINT COLUMN g_c[31],sr.ofd23 CLIPPED,
#           COLUMN g_c[32],sr.gen02 CLIPPED;
 
#  ON EVERY ROW
#      SELECT azi03,azi04,azi05               #No.CHI-6A0004
#        INTO g_azi03,g_azi04,g_azi05         #幣別檔小數位數讀取 #No.CHI-6A0004
#        FROM azi_file                        #No.CHI-6A0004
#       WHERE azi01=g_aza.aza17               #No.CHI-6A0004 
# 
#     PRINT COLUMN g_c[33],sr.ofd01 CLIPPED,
#           COLUMN g_c[34],sr.ofd02 CLIPPED,
#           COLUMN g_c[35],sr.ofd10 CLIPPED,
#           COLUMN g_c[36],sr.ofd27,
#           COLUMN g_c[37],cl_numfor(sr.ofd28,37,g_azi04),
#           COLUMN g_c[38],sr.ofd29 USING '#&.&&&&'
 
#ON LAST ROW
#     IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#     THEN
#        CALL cl_wcchp(tm.wc,'ofd23,ofd01,ofd02,ofd10,ofd27,ofd28')
#             RETURNING tm.wc
#        PRINT g_dash[1,g_len]
#        #TQC-630166
#        #     IF tm.wc[001,070] > ' ' THEN            # for 80
#        #PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#        #     IF tm.wc[071,140] > ' ' THEN
#        #PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#        #     IF tm.wc[141,210] > ' ' THEN
#        #PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#        #     IF tm.wc[211,280] > ' ' THEN
#        # PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#        CALL cl_prt_pos_wc(tm.wc)
#        #END TQC-630166
 
#     END IF
#     PRINT g_dash[1,g_len]
#     PRINT g_x[4] CLIPPED, COLUMN g_c[38], g_x[7] CLIPPED
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
#   IF l_last_sw = 'n'
#       THEN PRINT g_dash[1,g_len]
#            PRINT g_x[4] CLIPPED, COLUMN g_c[38], g_x[6] CLIPPED
#       ELSE SKIP 2 LINES
#    END IF
#END REPORT
#No.FUN-850014--Mark--End-##
#No.FUN-870144
