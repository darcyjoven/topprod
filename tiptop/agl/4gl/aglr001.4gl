# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aglr001.4gl
# Descriptions...: 部門結構表
# Date & Author..: 96/09/12 By Melody
# Modify.........: No.MOD-4C0171 05/01/06 By Nicola 修改參數第一個保留給帳別
# Modify.........: No.TQC-650044 06/05/15 By Echo 憑證類的報表因報表寬度(p_zz)為0或NULL,導致報表當掉
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680098 06/08/30 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-750022 07/05/09 By Lynn 打印內容中:"FROM"位置在報表名之上
# Modify.........: No.FUN-830053 08/03/25 By baofei 報表打印改為CR輸出 
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80057 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                        # Print condition RECORD
           wc     LIKE type_file.chr1000,# Where condition              #No.FUN-680098 VARCHAR(300)
           more   LIKE type_file.chr1    # Input more condition(Y/N)    #No.FUN-680098  VARCHAR(1) 
           END RECORD
DEFINE g_abd01_a  LIKE abd_file.abd01
DEFINE g_bookno   LIKE aah_file.aah00    #帳別   #TQC-610056
DEFINE g_i        LIKE type_file.num5    #count/index for any purpose   #No.FUN-680098 smallint
#No.FUN-830053---Begin
DEFINE g_abd01    LIKE abd_file.abd01
DEFINE g_gem02    LIKE gem_file.gem02
DEFINE l_table    STRING
DEFINE g_str      STRING
DEFINE g_sql      STRING                                                                                                       
#No.FUN-830053---End
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                         # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114 #FUN-BB0047
#No.FUN-830053---Begin 
   LET g_sql = "p_level.type_file.num5,",
               "abd01.abd_file.abd01,",
               "abd02.abd_file.abd02,",
               "gem02.gem_file.gem02"      # 對應當前記錄中的下層部門編號,
                                           # 因CR中依abd02做層階分組
   LET l_table = cl_prt_temptable('aglr001',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF 
#No.FUN-830053---End  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047
    #-----No.MOD-4C0171-----
   LET g_bookno = ARG_VAL(1)     #TQC-610056
   LET g_pdate  = ARG_VAL(2)                # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc    = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
    #-----No.MOD-4C0171 END-----
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL aglr001_tm(0,0)             # Input print condition
      ELSE CALL aglr001()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglr001_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01        #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680098  smallint
          l_cmd          LIKE type_file.chr1000  #No.FUN-680098  VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 10 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 32
   ELSE LET p_row = 4 LET p_col = 10
   END IF
   OPEN WINDOW aglr001_w AT p_row,p_col
        WITH FORM "agl/42f/aglr001"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON abd01
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
         LET INT_FLAG = 0 CLOSE WINDOW aglr001_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
 
      DISPLAY BY NAME tm.more
      INPUT BY NAME tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
         ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
         LET INT_FLAG = 0 CLOSE WINDOW aglr001_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
                WHERE zz01='aglr001'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglr001','9031',1)   
         ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                            " '",g_bookno CLIPPED,"'",   #TQC-610056
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
             CALL cl_cmdat('aglr001',g_time,l_cmd)    # Execute cmd at later time #MOD-4C0171
         END IF
         CLOSE WINDOW aglr001_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL aglr001()
      ERROR ""
   END WHILE
   CLOSE WINDOW aglr001_w
END FUNCTION
 
 
FUNCTION aglr001()
   DEFINE l_name  LIKE type_file.chr20,   # External(Disk) file name   #No.FUN-680098 VARCHAR(20) 
#         l_time  LIKE type_file.chr8     #No.FUN-6A0073
          l_sql   LIKE type_file.chr1000, # RDSQL STATEMENT            #No.FUN-680098 VARCHAR(1000) 
          l_abd01 LIKE abd_file.abd01,
          l_za05  LIKE za_file.za05       #No.FUN-680098 VARCHAR(40)
   DEFINE l_gem02 LIKE gem_file.gem02     #No.FUN-830053
 
#No.FUN-830053---Begin
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?) "                                                                                                
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
      EXIT PROGRAM                                                                             
   END IF        
#No.FUN-830053---End
   CALL cl_del_data(l_table)      #No.FUN-830053
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aglr001'
   #TQC-650044
   #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
   #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
   #END TQC-650044
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND abduser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND abdgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND abdgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('abduser', 'abdgrup')
   #End:FUN-980030
 
   LET l_sql = "SELECT UNIQUE abd01",
               " FROM abd_file WHERE  ",tm.wc,
               " ORDER BY 1"
   PREPARE aglr001_p1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   DECLARE aglr001_curs1 CURSOR FOR aglr001_p1
 
#   CALL cl_outnam('aglr001') RETURNING l_name   #No.FUN-830053
#   START REPORT r001_rep TO l_name              #No.FUN-830053
#   LET g_pageno = 0                             #No.FUN-830053
 
   FOREACH aglr001_curs1 INTO l_abd01
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
#No.FUN-830053---Begin   
      SELECT gem02 INTO l_gem02 FROM gem_file
       WHERE gem01=l_abd01 AND gemacti='Y'
      IF SQLCA.sqlcode THEN LET l_gem02=' ' END IF
      EXECUTE insert_prep USING '0','',l_abd01,l_gem02     # 設'0'為所有部門的上層部門,
                                                           # 以便CR中以次ID字段abd02分組
      IF STATUS THEN
         CALL cl_err("execute insert_prep:",STATUS,1)
         EXIT FOREACH
      END IF
#No.FUN-830053---End 
      LET g_abd01_a=l_abd01
      CALL r001_bom(0,l_abd01)
   END FOREACH
#No.FUN-830053---Begin   
#  FINISH REPORT r001_rep
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   LET g_str= g_towhom
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
   CALL cl_prt_cs3('aglr001','aglr001',l_sql,g_str)
#No.FUN-830053---End 
END FUNCTION
 
FUNCTION r001_bom(p_level,p_key)
   DEFINE p_level    LIKE type_file.num5,          #No.FUN-680098   smallint
          p_key      LIKE abd_file.abd01,
          l_ac,i     LIKE type_file.num5,          #No.FUN-680098  smallint
          arrno      LIKE type_file.num5,          #No.FUN-680098  smallint
          l_gem02    LIKE gem_file.gem02,          #No.FUN-830053
          l_cmd      LIKE type_file.chr1000,       #No.FUN-680098  VARCHAR(300)
          sr DYNAMIC ARRAY OF RECORD  
             abd01   LIKE abd_file.abd01,
             abd02   LIKE abd_file.abd02
          END RECORD
   IF p_level>20 THEN CALL cl_err('','mfg2733',1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF
   LET p_level=p_level+1
   IF p_level=1 THEN
      INITIALIZE sr[1].* TO NULL
      LET g_pageno=0
      LET sr[1].abd02=p_key
   END IF
   LET arrno=600
   WHILE TRUE
      LET l_cmd="SELECT abd01,abd02 FROM abd_file ",
                " WHERE abd01='",p_key,"' ORDER BY abd01,abd02 "
      PREPARE r001_ppp FROM l_cmd
      IF SQLCA.SQLCODE THEN
         CALL cl_err("P1:",SQLCA.SQLCODE,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
      DECLARE r001_cur CURSOR FOR r001_ppp
 
      LET l_ac=1
      FOREACH r001_cur INTO sr[l_ac].*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('r001_cur',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          LET l_ac=l_ac+1
          IF  l_ac=arrno THEN EXIT FOREACH END IF
      END FOREACH
      FOR i=1 TO l_ac-1
#No.FUN-830053---Begin
#        OUTPUT TO REPORT r001_rep(p_level,sr[i].*,g_abd01_a)
         SELECT gem02 INTO l_gem02 FROM gem_file
          WHERE gem01=sr[i].abd02 AND gemacti='Y'
         IF SQLCA.sqlcode THEN LET l_gem02=' ' END IF
         EXECUTE insert_prep USING p_level,sr[i].*,l_gem02
         IF STATUS THEN
            CALL cl_err("execute insert_prep:",STATUS,1)
            EXIT FOR
         END IF
#No.FUN-830053---End 
         IF sr[i].abd01 IS NOT NULL THEN
             CALL r001_bom(p_level,sr[i].abd02)
          END IF
      END FOR
      IF l_ac < arrno THEN EXIT WHILE END IF
   END WHILE
END FUNCTION
 
#No.FUN-830053---Begin 
#REPORT r001_rep(p_level,sr,p_abd01_a)
#  DEFINE l_trailer_sw LIKE type_file.chr1,   #No.FUN-680098 VARCHAR(1)
#         p_abd01_a    LIKE abd_file.abd01,
#         l_gem02      LIKE gem_file.gem02,
#         sr           RECORD
#                      abd01   LIKE abd_file.abd01,
#                      abd02   LIKE abd_file.abd02
#         END RECORD,
#         t,l_i,l_j,p_level	LIKE type_file.num5     #No.FUN-680098 smallint
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# FORMAT
#   PAGE HEADER
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
##     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED      # No.TQC-750022
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           COLUMN (g_len-FGL_WIDTH(g_user)-15),'FROM:',g_user CLIPPED, COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'     # No.TQC-750022
#     PRINT ''
#     SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=p_abd01_a
#                                               AND gemacti='Y'
#     IF SQLCA.sqlcode THEN LET l_gem02=' ' END IF
#     PRINT p_abd01_a CLIPPED,' ',l_gem02
#     LET t=1
#     LET l_trailer_sw = 'y'
 
#   BEFORE GROUP OF p_abd01_a
#     LET g_pageno = 0
#     SKIP TO TOP OF PAGE
 
#   ON EVERY ROW
#   # SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.abd02
#   #                                           AND gemacti='Y'
#   # IF SQLCA.sqlcode THEN LET l_gem02=' ' END IF
#     IF p_level > t THEN
#        FOR l_i = 1 TO p_level PRINT g_x[13] CLIPPED; END FOR
#        PRINT " "
#     END IF
#     IF p_level < t THEN
#        FOR l_i = 1 TO p_level PRINT g_x[13] CLIPPED; END FOR
#        PRINT g_x[14] CLIPPED
#     END IF
#     FOR l_i = 1 TO p_level-1 PRINT g_x[13] CLIPPED; END FOR
#     #No.B606 100531 by linda 將上面三行搬至此, 換頁才不會印錯
#     SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.abd02
#                                               AND gemacti='Y'
#     IF SQLCA.sqlcode THEN LET l_gem02=' ' END IF
#     #No.B606 end ---
#     PRINT g_x[15] CLIPPED,g_x[16] CLIPPED,sr.abd02 CLIPPED,' ',l_gem02
#     LET t = p_level
 
#   AFTER GROUP OF p_abd01_a
#     FOR l_i = 1 TO p_level PRINT g_x[14] CLIPPED; END FOR print ''
#     LET l_trailer_sw = 'y'
#
# PAGE TRAILER
#   IF l_trailer_sw='y' THEN
#      PRINT ' '
#      PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#   ELSE
#      SKIP 2 LINE
#   END IF
#   IF l_trailer_sw='n' THEN
#      PRINT ' '
#      PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#   ELSE
#      SKIP 2 LINE
#   END IF
#END REPORT
#No.FUN-830053---End 
#Patch....NO.TQC-610035 <001> #
#FUN-870144
