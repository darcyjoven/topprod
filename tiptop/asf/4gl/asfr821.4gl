# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: asfr821.4gl
# Descriptions...: Run Card品質異常記錄狀況明細表
# Date & Author..: 00/08/21 By Mandy
# Modify.........: NO.FUN-510029 05/01/13 By Carol 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.MOD-530461 05/05/04 By pengu 加列印功能，直接與asfr821串
# Modify.........: No.TQC-610080 06/03/03 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680121 06/09/01 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/11/01 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.TQC-750041 07/05/11 By johnray 5.0版更，報表修改
# Modify.........: No.TQC-770003 07/07/03 By zhoufeng 維護幫助按鈕
# Modify.........: No.TQC-790118 07/09/20 By Judy 報表中無"結束"字樣
# Modify.........: No.FUN-830152 08/04/08 By baofei  報表打印改為CR輸出  
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                # Print condition RECORD
              wc      STRING,                       # Where condition  #NO.TQC-630166 
              #wc      VARCHAR(600),                   # Where condition
              type    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)# 確認否
              more    LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)# 是否輸入其它特殊列印條件?
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE   g_shh01         LIKE shh_file.shh01    #No.MOD-530461
DEFINE   g_str           STRING              #No.FUN-830152
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610080-begin
   LET tm.type  = ARG_VAL(8)
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL asfr821_tm(0,0)           # Input print condition
      ELSE CALL asfr821()                 # Read data and create out-file
   END IF
   #LET tm.more  = ARG_VAL(8)
   ##-----------------------------No.MOD-530461---------------------------
   #LET g_shh01  = ARG_VAL(9)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(10)
   #LET g_rep_clas = ARG_VAL(11)
   #LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
   #IF cl_null(g_shh01) THEN
   #   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
   # Prog. Version..: '5.30.06-13.03.12(0,0)        # Input print condition
   #      ELSE CALL asfr821()              # Read data and create out-file
   #   END IF
   #ELSE
   #   LET tm.wc="shh01= '",g_shh01 CLIPPED,"'"
   #   LET g_rlang = g_lang
   #   CALL asfr821()                    # Read data and create out-file
   #END IF
   #TQC-610080-end
   #----------------------------------No.MOD-530461--------------------
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION asfr821_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680121 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(400)
 
   IF p_row = 0 THEN
      LET p_row = 5 LET p_col = 12
   END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 12
   END IF
 
   OPEN WINDOW asfr821_w AT p_row,p_col WITH FORM "asf/42f/asfr821"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET tm.type = '3'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON shh01,shh02,shh03,shh031
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
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
         ON ACTION help
            CALL cl_show_help()               #No.TQC-770003
 
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW asfr821_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more      # Condition
   INPUT BY NAME tm.type,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD type
         IF tm.type NOT MATCHES "[123]" OR tm.type IS NULL THEN
            NEXT FIELD a
         END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
         IF tm.more = "Y" THEN
                 CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
      ON ACTION CONTROLG
             CALL cl_cmdask()    # Command execution
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
         ON ACTION help
            CALL cl_show_help()                 #No.TQC-770003
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW asfr821_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='asfr821'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr821','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.type CLIPPED,"'",              #TQC-610080
                        #" '",tm.more CLIPPED,"'",              #TQC-610080 
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('asfr821',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW asfr821_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL asfr821()
   ERROR ""
END WHILE
CLOSE WINDOW asfr821_w
END FUNCTION
 
FUNCTION asfr821()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
#         l_order   ARRAY[5] OF LIKE apm_file.apm08,        #No.FUN-680121 VARCHAR(10) # TQC-6A0079
          sr        RECORD
                       shh01  LIKE shh_file.shh01,
                       shh02  LIKE shh_file.shh02,
                       shh03  LIKE shh_file.shh03,
                       shh031 LIKE shh_file.shh031,
                       shm05  LIKE shm_file.shm05,
                       shh05  LIKE shh_file.shh05,
                       shh06  LIKE shh_file.shh06,
                       shh14  LIKE shh_file.shh14
                    END RECORD
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-830152  
     SELECT zo02 INTO g_company FROM zo_file
      WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND shhuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND shhgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND shhgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('shhuser', 'shhgrup')
     #End:FUN-980030
 
#No.FUN-830152---Begin
#    LET l_sql = "SELECT shh01,shh02,shh03,shh031,shm05,shh05,shh06,shh14 ",
#                 "  FROM shh_file, OUTER shm_file ",
#                 " WHERE shm_file.shm01 = shh031",
#                 "   AND shh031 IS NOT NULL AND shh031 <> ' ' AND shh14!='X' ",
#                 "   AND ",tm.wc CLIPPED
     LET l_sql = "SELECT shh01,shh02,shh03,shh031,shm05,shh05,shh06,shh14,ima02,ima021 ",                                                        
                 "  FROM shh_file LEFT OUTER JOIN shm_file ON shm01=shh031,ima_file ",                                                                                
                 " WHERE  ima01 = shm05 ",                                                                                           
                 "   AND shh031 IS NOT NULL AND shh031 <> ' ' AND shh14!='X' ",                                                     
                 "   AND ",tm.wc CLIPPED 
#No.FUN-830152---End
     IF tm.type = '1' THEN LET l_sql = l_sql CLIPPED ," AND shh14='N' " END IF
     IF tm.type = '2' THEN LET l_sql = l_sql CLIPPED ," AND shh14='Y' " END IF
     LET l_sql = l_sql CLIPPED, " ORDER BY shh01 "
#No.FUN-830152---Begin
#    PREPARE asfr821_prepare1 FROM l_sql
#    IF SQLCA.sqlcode != 0 THEN
#        CALL cl_err('prepare:',SQLCA.sqlcode,1)
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
#        EXIT PROGRAM
#    END IF
#    DECLARE asfr821_curs1 CURSOR FOR asfr821_prepare1
 
#    CALL cl_outnam('asfr821') RETURNING l_name
#    START REPORT asfr821_rep TO l_name
 
#    LET g_pageno = 0
#    FOREACH asfr821_curs1 INTO sr.*
#      IF SQLCA.sqlcode != 0  THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1)
#          EXIT FOREACH
#      END IF
#      OUTPUT TO REPORT asfr821_rep(sr.*)
#    END FOREACH
 
#    FINISH REPORT asfr821_rep
    IF g_zz05 = 'Y' THEN                                                                                                            
         CALL cl_wcchp(tm.wc,'shh01,shh02,shh03,shh031')                                                                      
              RETURNING tm.wc                                                                                                        
      END IF                                                                                                                        
      LET g_str=tm.wc                                                                                                                
                                                                                                                                    
   CALL cl_prt_cs1('asfr821','asfr821',l_sql,g_str) 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-830152---End
END FUNCTION
#No.FUN-830152---Begin
#REPORT asfr821_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#         exhaust      LIKE bed_file.bed07,          #No.FUN-680121 DECIMAL(12,3)
#         l_sfe06      LIKE sfe_file.sfe06,
#         l_sfe16      LIKE sfe_file.sfe16,
#         l_ima02      LIKE ima_file.ima02,
#         l_ima021     LIKE ima_file.ima021,
#         sr           RECORD
#                      shh01  LIKE shh_file.shh01,
#                      shh02  LIKE shh_file.shh02,
#                      shh03  LIKE shh_file.shh03,
#                      shh031 LIKE shh_file.shh031,
#                      shm05  LIKE shm_file.shm05,
#                      shh05  LIKE shh_file.shh05,
#                      shh06  LIKE shh_file.shh06,
#                      shh14  LIKE shh_file.shh14
#                      END RECORD
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.shh01
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<','/pageno'
#     PRINT g_head CLIPPED, pageno_total
#     PRINT ''
#
#     PRINT g_dash
#     PRINT g_x[31],
#           g_x[32],
#           g_x[33],
#           g_x[34],
#           g_x[35],
#           g_x[36],
#           g_x[37],
#           g_x[38],
#           g_x[39],
#           g_x[40]
#     PRINT g_dash1
 
#  ON EVERY ROW
#     LET l_ima02 = ''
#     LET l_ima021= ''
#     SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
#      WHERE ima01 = sr.shm05
#     PRINT COLUMN g_c[31],sr.shh01,
#           COLUMN g_c[32],sr.shh02,
#           COLUMN g_c[33],sr.shh03,
#           COLUMN g_c[34],sr.shh031,
#           COLUMN g_c[35],sr.shm05,
#           COLUMN g_c[36],l_ima02,
#           COLUMN g_c[37],l_ima021,
#           COLUMN g_c[38],sr.shh05,
#           COLUMN g_c[39],sr.shh06 USING '########',
#           COLUMN g_c[40],sr.shh14
 
#  ON LAST ROW
#     IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#        CALL cl_wcchp(tm.wc,'sfh01,sfh04,shh02')
#             RETURNING tm.wc
#        PRINT g_dash
##NO.TQC-630166 start--
##         IF tm.wc[001,070] > ' ' THEN            # for 80
##              PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
##         IF tm.wc[071,140] > ' ' THEN
##              PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
##         IF tm.wc[141,210] > ' ' THEN
##              PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
##         IF tm.wc[211,280] > ' ' THEN
##              PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#         CALL cl_prt_pos_wc(tm.wc)
##NO.TQC-630166 end--
#     END IF
#     PRINT g_dash
##      PRINT g_x[4] CLIPPED, COLUMN g_c[39], g_x[7] CLIPPED       #No.TQC-750041
##        PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED       #No.TQC-750041 #TQC-790118
#        PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED       #TQC-790118
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
#     IF l_last_sw = 'n' THEN
#        PRINT g_dash
##         PRINT g_x[4] CLIPPED, COLUMN g_c[39], g_x[6] CLIPPED
#        PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED       #No.TQC-750041
#     ELSE
#        SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-830152---End
