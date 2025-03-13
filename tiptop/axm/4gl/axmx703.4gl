# Prog. Version..: '5.30.07-13.05.16(00001)'     #
#
# Pattern name...: axmx703.4gl
# Descriptions...: 業務員潛在客戶名單
# Input parameter:
# Return code....:
# Date & Author..: 02/12/04 By Carrier
# Modify.........: NO.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
#
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6B0096 06/11/20 By Ray 結束格式不符
# Modify.........: No.TQC-750041 07/05/14 By Lynn 打印內空中,無效潛在客戶無特殊標記
# Modify.........: No.FUN-850014 08/05/06 By xiaofeizhu 報表輸出改為CR
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-CB0001 12/11/06 By yangtt CR轉XtraGrid
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                            # Print condition RECORD
              wc     STRING,   # Where condition
              d      LIKE type_file.chr1,       # No.FUN-680137 VARCHAR(1)
              more   LIKE type_file.chr1        # No.FUN-680137 VARCHAR(1)                   # Input more condition(Y/N)
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
   DEFER INTERRUPT                                   # Supress DEL key function
 
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
               " ofd03.ofd_file.ofd03,",                                                                                            
               " ofd05.ofd_file.ofd05,",                                                                                            
               " ofd37.ofd_file.ofd37,",                                                                                            
               " ofd38.ofd_file.ofd38,",                                                                                            
               " ofd31.ofd_file.ofd31,",
               " ofd33.ofd_file.ofd33,",
               " ofdacti.ofd_file.ofdacti,",
               " ofq02.ofq_file.ofq02,",  #FUN-CB0001
               " gea02.gea_file.gea02"    #FUN-CB0001
                                                                                                                                    
    LET l_table = cl_prt_temptable('axmx703',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"       #FUN-CB0001 add 2?                                                                             
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
                                                                                                                                    
#--------------------------CR(1)--------------------------------#
 
   LET g_pdate = ARG_VAL(1)              # Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.d    = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL x703_tm(0,0)            # Input print condition
      ELSE CALL x703()          # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION x703_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col   LIKE type_file.num5,         #No.FUN-680137 SMALLINT
          l_cmd         LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 18
 
   OPEN WINDOW x703_w AT p_row,p_col WITH FORM "axm/42f/axmx703"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.d    = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ofd23,ofd01,ofd10,ofd22,ofd03
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---

     #FUN-CB0001----add----str---
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ofd01)
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = 'q_ofd'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ofd01
               NEXT FIELD ofd01
            WHEN INFIELD(ofd23)
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_ofd23"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ofd23
               NEXT FIELD ofd23
            WHEN INFIELD(ofd10)
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = 'q_ofd10'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ofd10
               NEXT FIELD ofd10
            WHEN INFIELD(ofd03)
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_ofq"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ofd03
               NEXT FIELD ofd03
         END CASE
      #FUN-CB0001----add----end---
 
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
      LET INT_FLAG = 0 CLOSE WINDOW x703_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.d,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD d
        IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN
           NEXT FIELD d
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
      LET INT_FLAG = 0 CLOSE WINDOW x703_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='axmx703'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmx703','9031',1)
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
                         " '",tm.d     CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axmx703',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW x703_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL x703()
   ERROR ""
END WHILE
   CLOSE WINDOW x703_w
END FUNCTION
 
FUNCTION x703()
   DEFINE l_name        LIKE type_file.chr20,                # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8            #No.FUN-6A0094
          l_sql         LIKE type_file.chr1000,              # RDSQL STATEMENT        #No.FUN-680137 VARCHAR(600)
          l_za05        LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          sr            RECORD    ofd23 LIKE ofd_file.ofd23,
                                  gen02 LIKE gen_file.gen02,
                                  ofd01 LIKE ofd_file.ofd01,
                                  ofd02 LIKE ofd_file.ofd02,
                                  ofd03 LIKE ofd_file.ofd03,
                                  ofd05 LIKE ofd_file.ofd05,
                                  ofd10 LIKE ofd_file.ofd10,
                                  ofd22 LIKE ofd_file.ofd22,
                                  ofd37	LIKE ofd_file.ofd37,
                                  ofd38 LIKE ofd_file.ofd38,
                                  ofd31 LIKE ofd_file.ofd31,
                                  ofd33 LIKE ofd_file.ofd33,
                                  ofdacti LIKE ofd_file.ofdacti,                 # No.TQC-750041
                                  ofq02 LIKE ofq_file.ofq02,  #FUN-CB0001
                                  gea02 LIKE gea_file.gea02   #FUN-CB0001
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR                      # No.FUN-850014
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
 
     LET l_sql = "SELECT ofd23,gen02,ofd01,ofd02,ofd03,ofd05,",
                 "       ofd10,ofd22,ofd37,ofd38,ofd31,ofd33,ofdacti ",
                 " FROM ofd_file,OUTER gen_file ",
                 "WHERE ofd_file.ofd23 = gen_file.gen01 ",
                 "  AND ", tm.wc CLIPPED
 
     PREPARE x703_prepare FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
           
     END IF
     DECLARE x703_cs CURSOR FOR x703_prepare
 
#    CALL cl_outnam('axmx703') RETURNING l_name                                       #No.FUN-850014  
#    START REPORT x703_rep TO l_name                                                  #No.FUN-850014 
 
#    LET g_pageno = 0                                                                 #No.FUN-850014 
     FOREACH x703_cs INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
#      OUTPUT TO REPORT x703_rep(sr.*)                                                #No.FUN-850014  
 
       SELECT ofq02 INTO sr.ofq02 FROM ofq_file WHERE ofq01 = sr.ofd03    #FUN-CB0001 add
       IF SQLCA.sqlcode = 100 THEN
          LET sr.ofq02 = NULL
       END IF
       SELECT gea02 INTO sr.gea02 FROM gea_file WHERE gea01 = sr.ofd05    #FUN-CB0001 add
       IF SQLCA.sqlcode = 100 THEN
          LET sr.gea02 = NULL
       END IF
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-850014 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
                   sr.ofd23,sr.gen02,sr.ofd01,sr.ofd02,sr.ofd03,sr.ofd05,
                   sr.ofd37,sr.ofd38,sr.ofd31,sr.ofd33,sr.ofdacti,
                   sr.ofq02,sr.gea02   #FUN-CB0001                                          
          #------------------------------ CR (3) ------------------------------#
 
     END FOREACH
 
#    FINISH REPORT x703_rep                                                           #No.FUN-850014 
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                                      #No.FUN-850014   
 
#No.FUN-850014--begin                                                                                                               
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'ofd23,ofd01,ofd02,ofd10,ofd27,ofd28')                                                                 
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                        
#No.FUN-850014--end                                                                                                                 
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-850014 **** ##                                                        
###XtraGrid###    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
###XtraGrid###    LET g_str = tm.wc,";",tm.d                                                                                                   
###XtraGrid###    CALL cl_prt_cs3('axmx703','axmx703',l_sql,g_str)                                                                                
    LET g_xgrid.table = l_table    ###XtraGrid###
    IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(tm.wc,'ofd23,ofd01,ofd02,ofd10,ofd27,ofd28')
              RETURNING tm.wc
      END IF
    LET g_xgrid.order_field = "ofd23,ofd01"  #FUN-CB0001 add
    IF tm.d = 'Y' THEN    #FUN-CB0001 add
       LET g_xgrid.skippage_field = 'ofd23'   #FUN-CB0001 add
    END IF    #FUN-CB0001 add
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc   #FUN-CB0001 add
    CALL cl_xg_view()    ###XtraGrid###
    #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
 
#No.FUN-850014--Mark--Begin--##
#REPORT x703_rep(sr)
#  DEFINE l_last_sw      LIKE type_file.chr1,        # No.FUN-680137  VARCHAR(1)
#         sr               RECORD ofd23 LIKE ofd_file.ofd23,
#                                 gen02 LIKE gen_file.gen02,
#                                 ofd01 LIKE ofd_file.ofd01,
#                                 ofd02 LIKE ofd_file.ofd02,
#                                 ofd03 LIKE ofd_file.ofd03,
#                                 ofd05 LIKE ofd_file.ofd05,
#                                 ofd10 LIKE ofd_file.ofd10,
#                                 ofd22 LIKE ofd_file.ofd22,
#                                 ofd37	LIKE ofd_file.ofd37,
#                                 ofd38 LIKE ofd_file.ofd38,
#                                 ofd31 LIKE ofd_file.ofd31,
#                                 ofd33 LIKE ofd_file.ofd33,
#                                 ofdacti LIKE ofd_file.ofdacti                  # No.TQC-750041
#                         END RECORD
 
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY sr.ofd23,sr.ofd01
 
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
#           g_x[38],
#           g_x[39],
#           g_x[40],
#           g_x[41]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.ofd23
#     IF tm.d = 'Y' THEN SKIP TO TOP OF PAGE END IF
#     PRINT COLUMN g_c[31],sr.ofd23,
#           COLUMN g_c[32],sr.gen02;
 
#  ON EVERY ROW
#     PRINT COLUMN g_c[33],sr.ofd01 CLIPPED,
#           COLUMN g_c[34],sr.ofd02 CLIPPED,
#           COLUMN g_c[35],sr.ofd03 CLIPPED,
#           COLUMN g_c[36],sr.ofd05 CLIPPED,
#           COLUMN g_c[37],sr.ofd37 CLIPPED,
#           COLUMN g_c[38],sr.ofd38 CLIPPED,
#           COLUMN g_c[39],sr.ofd31 CLIPPED,
#           COLUMN g_c[40],sr.ofd33 CLIPPED,
#           COLUMN g_c[41],sr.ofdacti CLIPPED
 
#  AFTER GROUP OF sr.ofd23
#     PRINT
#
#  ON LAST ROW
#     IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#     THEN
#        CALL cl_wcchp(tm.wc,'ofd23,ofd01,ofd02,ofd10,ofd27,ofd28')
#             RETURNING tm.wc
#        PRINT g_dash[1,g_len]
#        #TQC-630166
#        #     IF tm.wc[001,120] > ' ' THEN                      # for 132
#        #        PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#        #     IF tm.wc[121,240] > ' ' THEN
#        #        PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#        #     IF tm.wc[241,300] > ' ' THEN
#        #        PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#        CALL cl_prt_pos_wc(tm.wc)
#        #END TQC-630166
 
#     END IF
#     PRINT g_dash[1,g_len]
#No.TQC-6B0096 --begin
#     PRINT g_x[4] CLIPPED, COLUMN g_c[40], g_x[7] CLIPPED
#     PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED
#No.TQC-6B0096 --end
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#No.TQC-6B0096 --begin
#             PRINT g_x[4] CLIPPED, COLUMN g_c[40], g_x[6] CLIPPED
#             PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED
#No.TQC-6B0096 --end
#        ELSE SKIP 2 LINES
#     END IF
#END REPORT
#No.FUN-850014--Mark--End--##
#No.FUN-870144


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
