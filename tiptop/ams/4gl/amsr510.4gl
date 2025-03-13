# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: amsr510.4gl
# Descriptions...: MPS 模擬明細表
# Input parameter: 
# Return code....: 
# Date & Author..: 96/06/10 By Roger
# Modify.........: No.FUN-510036 05/01/18 By pengu 報表轉XML
# Modify.........: No.FUN-550056 05/05/20 By Trisy 單據編號加大
# Modify.........: No.FUN-550110 05/05/26 By ching 特性BOM功能修改
# Modify.........: No.FUN-560011 05/06/06 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗 
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.TQC-5C0005 05/12/06 By kevin  欄位沒對齊
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610075 06/01/24 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660108 06/06/12 BY cheunl  cl_err --->cl_err3
# Modify.........: No.FUN-680101 06/08/30 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-690116 06/10/16 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.TQC-6A0080 06/11/16 By cheunl   修改報表格式
# Modify.........: No.TQC-6C0190 06/12/27 By Ray 報表問題修改
# Modify.........: No.TQC-750041 07/05/15 By mike  報表格式修改
# Modify.........: No.FUN-850082 08/05/06 By xiaofeizhu 報表輸出改為CR
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,   #NO.FUN-680101 VARCHAR(600)    # Where condition
             #n       VARCHAR(1),        #TQC-610075
              ver_no  LIKE mps_file.mps_v,      #NO.FUN-680101 VARCHAR(2)
              part1   LIKE bma_file.bma01,      #NO.FUN-680101 VARCHAR(40)     #FUN-560011
              part2   LIKE ima_file.ima01,      #NO.FUN-680101 VARCHAR(40)     #FUN-560011
              print_adj LIKE type_file.chr1,    #NO.FUN-680101 VARCHAR(1)
              print_plp LIKE type_file.chr1,    #NO.FUN-680101 VARCHAR(1)
              order   LIKE type_file.chr1,      #NO.FUN-680101 VARCHAR(1)
              more    LIKE type_file.chr1       #NO.FUN-680101 VARCHAR(1)      # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5    #NO.FUN-680101 SMALLINT     #count/index for any purpose
DEFINE   g_head1         STRING
 
#No.FUN-850082 --Add--Begin--                                                                                                       
  DEFINE   l_table         STRING                                                                                                   
  DEFINE   g_str           STRING                                                                                                   
  DEFINE   g_sql           STRING                                                                                                   
#No.FUN-850082 --Add--End--
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMS")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116
 
#No.FUN-850082 --Add--Begin--                                                                                                       
#--------------------------CR(1)--------------------------------#                                                                   
   LET g_sql = " mps03.mps_file.mps03,",
               " mps01.mps_file.mps01,",
               " mps00.mps_file.mps00,",
               " mpt07.mpt_file.mpt07,",
               " mpt061.mpt_file.mpt061,",  
               " mpt06.mpt_file.mpt06,",
               " mpt05.mpt_file.mpt05,",
               " mpt04.mpt_file.mpt04,",
               " ima02.ima_file.ima02,", 
               " ima25.ima_file.ima25,",
               " ima67.ima_file.ima67,",  
               " ima43.ima_file.ima43,",
               " l_buf.mpt_file.mpt05,", 
               " qty1.mpt_file.mpt08,",
               " qty2.mpt_file.mpt08"                                                                                      
                                                                                                                                    
    LET l_table = cl_prt_temptable('amsr510',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 
                         ?, ?, ?, ?, ?)"                                                                                   
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
                                                                                                                                    
#--------------------------CR(1)--------------------------------# 
#No.FUN-850082 --Add--End--
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610075-begin
   LET tm.ver_no   = ARG_VAL(8)
   LET tm.part1    = ARG_VAL(9)
   LET tm.part2    = ARG_VAL(10)
   LET tm.print_adj= ARG_VAL(11)
   LET tm.print_plp= ARG_VAL(12)
   LET tm.order    = ARG_VAL(13)
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   ##No.FUN-570264 ---end---
   #TQC-610075-end
   IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL amsr510_tm(0,0)        # Input print condition
      ELSE CALL amsr510()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amsr510_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,  #NO.FUN-680101 SMALLINT
          l_cmd          LIKE type_file.chr1000#NO.FUN-680101 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 17
   ELSE LET p_row = 3 LET p_col = 15
   END IF
 
   OPEN WINDOW amsr510_w AT p_row,p_col
        WITH FORM "ams/42f/amsr510" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
  #LET tm.n    = '2'                  #TQC-610075
   LET tm.print_adj = 'Y'
   LET tm.print_plp = 'Y'
   LET tm.order = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON mps01,ima08,ima67,ima43,mps03 
#No.FUN-570240 --start--                                                                                    
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION CONTROLP                                                                                              
            IF INFIELD(mps01) THEN                                                                                                  
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = "q_ima"                                                                                       
               LET g_qryparam.state = "c"                                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO mps01                                                                                 
               NEXT FIELD mps01                                                                                                     
            END IF  
#No.FUN-570240 --end-- 
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW amsr510_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm.ver_no, tm.part1, tm.part2,
                 tm.print_adj, tm.print_plp, tm.order,tm.more
                 WITHOUT DEFAULTS 
#No.FUN-570240 --start--     
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD ver_no
         IF cl_null(tm.ver_no) THEN NEXT FIELD ver_no END IF
      AFTER FIELD part1
         IF NOT cl_null(tm.part1) THEN
            SELECT bma01 FROM bma_file WHERE bma01=tm.part1
            IF STATUS THEN
  #            CALL cl_err('sel bma:',STATUS,0)  #No.FUN-660108
               CALL cl_err3("sel","bma_file",tm.part1,"",STATUS,"","sel bma:",0)      #No.FUN-660108
               NEXT FIELD part1
            END IF
         END IF
      AFTER FIELD part2
         IF NOT cl_null(tm.part2) THEN
            SELECT ima01 FROM ima_file WHERE ima01=tm.part2
            IF STATUS THEN
   #           CALL cl_err('sel ima:',STATUS,0)   No.FUN-660108
               CALL cl_err3("sel","ima_file",tm.part2,"",STATUS,"","sel ima:",0)      #No.FUN-660108
               NEXT FIELD part2
            END IF
         END IF
      AFTER FIELD order
         IF cl_null(tm.order) THEN NEXT FIELD order END IF
         IF tm.order NOT MATCHES '[123]' THEN
            LET tm.order='1'
            NEXT FIELD order
         END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLP
         CASE WHEN INFIELD(part1)
#                  CALL q_bma(0,0,tm.part1) RETURNING tm.part1
#                  CALL FGL_DIALOG_SETBUFFER( tm.part1 )
################################################################################
# START genero shell script ADD
    CALL cl_init_qry_var()
    LET g_qryparam.form = 'q_bma'
    LET g_qryparam.default1 = tm.part1
    CALL cl_create_qry() RETURNING tm.part1
#    CALL FGL_DIALOG_SETBUFFER( tm.part1 )
# END genero shell script ADD
################################################################################
                   DISPLAY BY NAME tm.part1
              WHEN INFIELD(part2)
#                  CALL q_ima(0,0,tm.part2) RETURNING tm.part2
#                  CALL FGL_DIALOG_SETBUFFER( tm.part2 )
################################################################################
# START genero shell script ADD
    CALL cl_init_qry_var()
    LET g_qryparam.form = 'q_ima'
    LET g_qryparam.default1 = tm.part2
    CALL cl_create_qry() RETURNING tm.part2
#    CALL FGL_DIALOG_SETBUFFER( tm.part2 )
# END genero shell script ADD
################################################################################
                   DISPLAY BY NAME tm.part2
         END CASE
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
      LET INT_FLAG = 0 CLOSE WINDOW amsr510_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amsr510'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amsr510','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         #TQC-610075-begin
                         " '",tm.ver_no    CLIPPED,"'",
                         " '",tm.part1     CLIPPED,"'",
                         " '",tm.part2     CLIPPED,"'",
                         " '",tm.print_adj CLIPPED,"'",
                         " '",tm.print_plp CLIPPED,"'",
                         " '",tm.order CLIPPED,"'",
                         #TQC-610075-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('amsr510',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amsr510_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL amsr510()
   ERROR ""
END WHILE
   CLOSE WINDOW amsr510_w
END FUNCTION
 
FUNCTION amsr510()
   DEFINE l_name    LIKE type_file.chr20,  #NO.FUN-680101 VARCHAR(20)   # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0081
          l_sql     LIKE type_file.chr1000,#NO.FUN-680101 VARCHAR(1000) # RDSQL STATEMENT
          l_chr     LIKE type_file.chr1,   #NO.FUN-680101 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,#NO.FUN-680101 VARCHAR(40)
          l_order   LIKE ima_file.ima67,   #NO.FUN-680101 VARCHAR(20)
          mps	RECORD LIKE mps_file.*,
          mpt	RECORD LIKE mpt_file.*,
          ima	RECORD LIKE ima_file.*
 
   DEFINE qty1,qty2,bal LIKE mpt_file.mpt08                           #No.FUN-850082
   DEFINE l_buf         LIKE mpt_file.mpt05                           #No.FUN-850082    
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-850082 *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-850082 add ###                                              
     #------------------------------ CR (2) ------------------------------#
 
     CASE WHEN tm.part1 IS NOT NULL
               CALL r510_bom1_main()
               LET l_sql = "SELECT mps_file.*, ima_file.*",
                           "  FROM r510_tmp, mps_file, ima_file",
                           " WHERE ",tm.wc CLIPPED,
                           "   AND partno=mps01",
                           "   AND mps01=ima01 ",
                           "   AND mps_v='",tm.ver_no,"'"
          WHEN tm.part2 IS NOT NULL
               CALL r510_bom2_main()
               LET l_sql = "SELECT mps_file.*, ima_file.*",
                           "  FROM r510_tmp, mps_file, ima_file",
                           " WHERE ",tm.wc CLIPPED,
                           "   AND partno=mps01",
                           "   AND mps01=ima01 ",
                           "   AND mps_v='",tm.ver_no,"'"
          OTHERWISE
               LET l_sql = "SELECT mps_file.*, ima_file.*",
                           "  FROM mps_file, ima_file",
                           " WHERE ",tm.wc CLIPPED,
                           "   AND mps01=ima01 ",
                           "   AND mps_v='",tm.ver_no,"'"
     END CASE
     PREPARE amsr510_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM 
     END IF
     DECLARE amsr510_curs1 CURSOR FOR amsr510_prepare1
 
#    CALL cl_outnam('amsr510') RETURNING l_name                                    #No.FUN-850082
#    START REPORT amsr510_rep TO l_name                                            #No.FUN-850082
#    LET g_pageno = 0                                                              #No.FUN-850082
     FOREACH amsr510_curs1 INTO mps.*, ima.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       message mps.mps01 clipped
       CALL ui.Interface.refresh()
#      IF tm.order='1' THEN                                                        #No.FUN-850082
#         LET l_order=ima.ima67                                                    #No.FUN-850082
#      END IF                                                                      #No.FUN-850082
#      IF tm.order='2' THEN                                                        #No.FUN-850082
#         LET l_order=ima.ima43                                                    #No.FUN-850082
#      END IF                                                                      #No.FUN-850082
#      IF tm.order='3' THEN                                                        #No.FUN-850082
#       LET l_order=' '                                                            #No.FUN-850082      
#      END IF                                                                      #No.FUN-850082
       DECLARE amsr510_curs2 CURSOR FOR
          SELECT * FROM mpt_file
            WHERE mpt01=mps.mps01 AND mpt03=mps.mps03
              AND mpt_v=mps.mps_v
       FOREACH amsr510_curs2 INTO mpt.*
         #message 'mpt:',mpt.mpt01 clipped
#        OUTPUT TO REPORT amsr510_rep(l_order,mps.*, mpt.*, ima.*)                 #No.FUN-850082
 
#No.FUN-850082--Add--Begin--##
      LET l_buf=mpt.mpt05,s_mpt05(mpt.mpt05)                                                                                        
      IF mpt.mpt05 MATCHES '4*' OR mpt.mpt05='39'                                                                   
         THEN LET qty1=mpt.mpt08 LET qty2=0                                                                                         
         ELSE LET qty2=mpt.mpt08 LET qty1=0                                                                                         
      END IF
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-850082 *** ##                                                   
         EXECUTE insert_prep USING                                                                                                
                 mps.mps03,mps.mps01,mps.mps00,mpt.mpt07,mpt.mpt061,
                 mpt.mpt06,mpt.mpt05,mpt.mpt04,ima.ima02,ima.ima25,
                 ima.ima67,ima.ima43,l_buf,qty1,qty2                                          
        #------------------------------ CR (3) ------------------------------#
#No.FUN-850082--Add--End--##
 
       END FOREACH
       INITIALIZE mpt.* TO NULL
       LET mpt.mpt01=mps.mps01
       LET mpt.mpt03=mps.mps03
       LET mpt.mpt04=mps.mps03
       IF tm.print_adj='Y' THEN
          IF mps.mps072-mps.mps071 != 0 THEN
             LET mpt.mpt05='71'
             LET mpt.mpt08=mps.mps072-mps.mps071
#            OUTPUT TO REPORT amsr510_rep(l_order,mps.*, mpt.*, ima.*)             #No.FUN-850082
#No.FUN-850082--Add--Begin--##                                                                                                      
      LET l_buf=mpt.mpt05,s_mpt05(mpt.mpt05)                                                                                        
      IF mpt.mpt05 MATCHES '4*' OR mpt.mpt05='39'                                                                                   
         THEN LET qty1=mpt.mpt08 LET qty2=0                                                                                         
         ELSE LET qty2=mpt.mpt08 LET qty1=0                                                                                         
      END IF                                                                                                                        
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-850082 *** ##                                                     
         EXECUTE insert_prep USING                                                                                                  
                 mps.mps03,mps.mps01,mps.mps00,mpt.mpt07,mpt.mpt061,                                                 
                 mpt.mpt06,mpt.mpt05,mpt.mpt04,ima.ima02,ima.ima25,                                                  
                 ima.ima67,ima.ima43,l_buf,qty1,qty2                                                                          
        #------------------------------ CR (3) ------------------------------#                                                      
#No.FUN-850082--Add--End--##
          END IF
       END IF
       IF tm.print_plp='Y' THEN
          IF mps.mps09 != 0 THEN
             IF ima.ima08='M'
                THEN LET mpt.mpt05=' M' # 這樣才會排在前面
                ELSE LET mpt.mpt05=' P' # 這樣才會排在前面
             END IF
             LET mpt.mpt08=mps.mps09
#            OUTPUT TO REPORT amsr510_rep(l_order,mps.*, mpt.*, ima.*)             #No.FUN-850082
#No.FUN-850082--Add--Begin--##                                                                                                      
      LET l_buf=mpt.mpt05,s_mpt05(mpt.mpt05)                                                                                        
      IF mpt.mpt05 MATCHES '4*' OR mpt.mpt05='39'                                                                                   
         THEN LET qty1=mpt.mpt08 LET qty2=0                                                                                         
         ELSE LET qty2=mpt.mpt08 LET qty1=0                                                                                         
      END IF                                                                                                                        
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-850082 *** ##                                                     
         EXECUTE insert_prep USING                                                                                                  
                 mps.mps03,mps.mps01,mps.mps00,mpt.mpt07,mpt.mpt061,                                                 
                 mpt.mpt06,mpt.mpt05,mpt.mpt04,ima.ima02,ima.ima25,                                                  
                 ima.ima67,ima.ima43,l_buf,qty1,qty2                                                                          
        #------------------------------ CR (3) ------------------------------#                                                      
#No.FUN-850082--Add--End--##
          END IF
       END IF
     END FOREACH
 
#    FINISH REPORT amsr510_rep                                                     #No.FUN-850082
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                                   #No.FUN-850082
 
#No.FUN-850082--begin                                                                                                               
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'mps01,ima08,ima67,ima43,mps03')                                                                 
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                        
#No.FUN-850082--end                                                                                                                 
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-850082 **** ##                                                        
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = tm.wc,";",tm.order,";",tm.ver_no                                                                                                   
    CALL cl_prt_cs3('amsr510','amsr510',l_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
 
FUNCTION r510_bom1_main()
   DEFINE l_ima910   LIKE ima_file.ima910   #FUN-550110
   DELETE FROM r510_tmp
   IF STATUS THEN
      CREATE TEMP TABLE r510_tmp (
                                   partno LIKE type_file.chr1000)      
      CREATE UNIQUE INDEX r510_tmp_i1 ON r510_tmp(partno)
   END IF
   INSERT INTO r510_tmp VALUES(tm.part1)
   IF STATUS THEN
# Prog. Version..: '5.30.06-13.03.12(0) r510_tmp:',STATUS,1)  #No.FUN-660108
    CALL cl_err3("ins","r510_tmp","","",STATUS,"","ins(0) r510_tmp",1)       #No.FUN-660108
    END IF
   #FUN-550110
   LET l_ima910=''
   SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=tmp.part1
   IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
   #--
   CALL r510_bom1(0,tm.part1,l_ima910)  #FUN-550110
END FUNCTION
 
FUNCTION r510_bom2_main()
   DEFINE l_ima910   LIKE ima_file.ima910   #FUN-550110
   DELETE FROM r510_tmp
   IF STATUS THEN
      CREATE TEMP TABLE r510_tmp (
                                  partno LIKE type_file.chr1000)  
      CREATE UNIQUE INDEX r510_tmp_i1 ON r510_tmp(partno)
   END IF
   INSERT INTO r510_tmp VALUES(tm.part2)
   IF STATUS THEN 
# Prog. Version..: '5.30.06-13.03.12(0) r510_tmp:',STATUS,1)  #No.FUN-660108
   CALL cl_err3("ins","r510_tmp","","",STATUS,"","ins(0) r510_tmp",1)       #No.FUN-660108
   END IF
   #FUN-550110
   LET l_ima910=''
   SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=tm.part2 
   IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
   #--
   CALL r510_bom2(0,tm.part2,l_ima910)  #FUN-550110
END FUNCTION
 
FUNCTION r510_bom1(p_level,p_key,p_key2)  #FUN-550110
   DEFINE p_level	LIKE type_file.num5,    #NO.FUN-680101 SMALLINT
          p_key		LIKE bma_file.bma01,    #主件料件編號
          p_key2        LIKE ima_file.ima910,   #FUN-550110
          l_ac,i	LIKE type_file.num5,    #NO.FUN-680101 SMALLINT
          arrno		LIKE type_file.num5,    #NO.FUN-680101 SMALLINT 	#BUFFER SIZE (可存筆數)
          sr DYNAMIC ARRAY OF RECORD            #每階存放資料
              bmb03 LIKE bmb_file.bmb03,        #元件料號
              bma01 LIKE bmb_file.bmb01         #NO.FUN-680101 VARCHAR(20) 
          END RECORD,
          l_sql		LIKE type_file.chr1000  #NO.FUN-680101 VARCHAR(1000)
   DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
    IF p_level > 20 THEN CALL cl_err('','mfg2733',1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
       EXIT PROGRAM 
    END IF
    LET p_level = p_level + 1
    LET arrno = 600
    LET l_sql= "SELECT bmb03,bma01",
               " FROM bmb_file, OUTER bma_file",
               " WHERE bmb01='", p_key,"' AND bmb_file.bmb03 = bma_file.bma01",
               "   AND bmb29 ='",p_key2,"' "  #FUN-550110
    PREPARE r510_ppp FROM l_sql
    DECLARE r510_cur CURSOR FOR r510_ppp
    LET l_ac = 1
    FOREACH r510_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
       #FUN-8B0035--BEGIN--                                                                                                    
       LET l_ima910[l_ac]=''
       SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
       IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
       #FUN-8B0035--END--
       LET l_ac = l_ac + 1			# 但BUFFER不宜太大
       IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('fore r510_cur:',STATUS,1) END IF
    FOR i = 1 TO l_ac-1		# 讀BUFFER傳給REPORT
        message p_level,' ',sr[i].bmb03 clipped
        INSERT INTO r510_tmp VALUES(sr[i].bmb03)
        IF sr[i].bma01 IS NOT NULL THEN 
          #CALL r510_bom1(p_level,sr[i].bmb03,' ')  #FUN-550110#FUN-8B0035
           CALL r510_bom1(p_level,sr[i].bmb03,l_ima910[i])  #FUN-8B0035
        END IF
    END FOR
END FUNCTION
 
FUNCTION r510_bom2(p_level,p_key,p_key2)  #FUN-550110
   DEFINE p_level	LIKE type_file.num5,     #NO.FUN-680101 SMALLINT
          p_key		LIKE bmb_file.bmb01,     #NO.FUN-680101 VARCHAR(20) #元件料件編號
          p_key2        LIKE ima_file.ima910,    #FUN-550110
          l_ac,i	LIKE type_file.num5,     #NO.FUN-680101 SMALLINT
          arrno		LIKE type_file.num5,     #NO.FUN-680101	SMALLINT #BUFFER SIZE (可存筆數)
          sr DYNAMIC ARRAY OF RECORD             #每階存放資料
              bmb01     LIKE bmb_file.bmb01,     #主件料號
              bmb03     LIKE bmb_file.bmb03 	 #還有沒有
          END RECORD,
          l_sql		LIKE type_file.chr1000    #NO.FUN-680101 VARCHAR(1000)
   DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
    IF p_level > 20 THEN CALL cl_err('','mfg2733',1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
       EXIT PROGRAM 
    END IF
    LET p_level = p_level + 1
    LET arrno = 600
    LET l_sql= "SELECT a.bmb01, b.bmb03",
               " FROM bmb_file a, OUTER bmb_file b",
               " WHERE a.bmb03='", p_key,"' AND a.bmb01 = b.bmb03",
               "   AND a.bmb29 ='",p_key2,"' "  #FUN-550110
    PREPARE r510_ppp2 FROM l_sql
    DECLARE r510_cur2 CURSOR FOR r510_ppp2
    LET l_ac = 1
    FOREACH r510_cur2 INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
       #FUN-8B0035--BEGIN-- 
       LET l_ima910[l_ac]=''
       SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb01
       IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
       #FUN-8B0035--END-- 
       LET l_ac = l_ac + 1			# 但BUFFER不宜太大
       IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('fore r510_cur:',STATUS,1) END IF
    FOR i = 1 TO l_ac-1		# 讀BUFFER傳給REPORT
        message p_level,' ',sr[i].bmb01 clipped
        INSERT INTO r510_tmp VALUES(sr[i].bmb01)
        IF sr[i].bmb03 IS NOT NULL THEN 
          #CALL r510_bom2(p_level,sr[i].bmb01,' ')  #FUN-550110#FUN-8B0035
           CALL r510_bom2(p_level,sr[i].bmb01,l_ima910[i])  #FUN-8B0035
        END IF
    END FOR
END FUNCTION
 
#No.FUN-850082--Mark--Begin--##
#REPORT amsr510_rep(l_order,mps, mpt, ima)
#  DEFINE l_last_sw     LIKE type_file.chr1          #NO.FUN-680101 VARCHAR(1)
#  DEFINE l_buf		LIKE mpt_file.mpt05          #NO.FUN-680101 VARCHAR(10)
#  DEFINE mps		RECORD LIKE mps_file.*
#  DEFINE mpt		RECORD LIKE mpt_file.*
#  DEFINE ima		RECORD LIKE ima_file.*
#  DEFINE l_order       LIKE ima_file.ima67          #NO.FUN-680101 VARCHAR(20)
#  DEFINE qty1,qty2,bal	LIKE mpt_file.mpt08          #NO.FUN-680101 DEC(15,3)
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line   #No.MOD-580242
# ORDER BY l_order,mps.mps01,mps.mps03,mpt.mpt04,mpt.mpt05
# FORMAT
#     PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED       #No.TQC-6A0080
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED       #No.TQC-6A0080
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     IF tm.order = '1' THEN
#        LET g_head1=g_x[38],l_order
#        PRINT g_head1
#     ELSE
#        IF tm.order = '2' THEN
#           LET g_head1= g_x[39],l_order
#           PRINT g_head1
#        ELSE
#           PRINT ' '
#        END IF
#     END IF
#     LET g_head1=g_x[16] CLIPPED, tm.ver_no
#     PRINT g_head1
#     PRINT g_dash[1,g_len] CLIPPED
#     PRINT g_x[41] clipped,g_x[42] clipped,g_x[43] clipped,g_x[44] clipped,
#           g_x[45] clipped,g_x[46] clipped,g_x[47] clipped,g_x[48] clipped,
#           g_x[49] clipped,g_x[50] clipped
#     PRINT g_dash1
#     LET l_last_sw = "n"
 
#  BEFORE GROUP OF l_order
#     IF tm.order MATCHES '[12]' THEN
#        SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF mps.mps01
#     PRINT COLUMN g_c[41],g_x[17] CLIPPED,
#           COLUMN g_c[42],mps.mps01 CLIPPED,      #No.TQC-6A0080
#           COLUMN g_c[43],g_x[18] CLIPPED,
#           COLUMN g_c[44],ima.ima02 CLIPPED,         #No.TQC-6A0080
#           COLUMN g_c[45],g_x[19] CLIPPED,ima.ima25 CLIPPED    #No.TQC-6A0080
#     LET qty1=0 LET qty2=0 LET bal=0
 
#  BEFORE GROUP OF mps.mps03
#     PRINT COLUMN g_c[41],mps.mps00 CLIPPED USING '###&', #No.TQC-5C0005 #FUN-590118      #No.TQC-6A0080
#           COLUMN g_c[42],mps.mps03 CLIPPED;   #No.TQC-6A0080
 
#  ON EVERY ROW
#     LET l_buf=mpt.mpt05,s_mpt05(mpt.mpt05)
#     IF mpt.mpt05 MATCHES '4*' OR mpt.mpt05='39'  #bugno:6431 add 
#        THEN LET qty1=mpt.mpt08 LET qty2=0
#        ELSE LET qty2=mpt.mpt08 LET qty1=0
#     END IF
#     LET bal=bal-qty1+qty2
#     PRINT COLUMN g_c[43],mpt.mpt04 CLIPPED,      #No.TQC-6A0080
#           COLUMN g_c[44],l_buf CLIPPED,         #No.TQC-6A0080
#           COLUMN g_c[45],qty1 CLIPPED USING '---,---,---',        #No.TQC-6A0080     #No.TQC-6C0190
#           COLUMN g_c[45],qty1 CLIPPED USING '---,---,--- ---',     #No.TQC-6C0190
#           COLUMN g_c[46],qty2 CLIPPED USING '---,---,---,---',        #No.TQC-6A0080
#           COLUMN g_c[47],bal CLIPPED USING '---,---,---,--&',' ', #No.TQC-5C0005
#           COLUMN g_c[48],mpt.mpt06[1,10], 
#           COLUMN g_c[48],mpt.mpt06 CLIPPED,     #No.FUN-550056      #No.TQC-6A0080
#           COLUMN g_c[49],mpt.mpt061 CLIPPED USING '###&', #FUN-590118    #No.TQC-6A0080
#           COLUMN g_c[50],mpt.mpt07 CLIPPED
#  AFTER GROUP OF mps.mps03
#     PRINT ' '
#  AFTER GROUP OF mps.mps01
#     PRINT g_dash2[1,g_len] CLIPPED
#  ON LAST ROW
#     LET l_last_sw = 'y'    #No.TQC-750041
#     PRINT g_dash[1,g_len] CLIPPED
#    #PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] #TQC-5B0019 mark 
#     PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED  #TQC-5B0019    #No.TQC-6A0080
#     LET l_last_sw = "y"    #No.TQC-750041 
 
#  PAGE TRAILER
#     IF l_last_sw = "n"
#        THEN PRINT g_dash[1,g_len] CLIPPED
#             PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED     #No.TQC-6A0080
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-850082--Mark--End--##
 
FUNCTION s_mpt05(p1)
   DEFINE p1 STRING       #NO.FUN-680101 VARCHAR(2)
   DEFINE p2 STRING       #NO.FUN-680101 VARCHAR(10)
        CASE WHEN p1='40' LET p2=g_x[21]    
             WHEN p1='41' LET p2=g_x[22]    
             WHEN p1='42' LET p2=g_x[23]    
             WHEN p1='43' LET p2=g_x[24]    
             WHEN p1='44' LET p2=g_x[25]    
             WHEN p1='45' LET p2=g_x[26]    
             WHEN p1='51' LET p2=g_x[27]    
             WHEN p1='52' LET p2=g_x[28]    
             WHEN p1='53' LET p2=g_x[29]    
             WHEN p1='61' LET p2=g_x[30]    
             WHEN p1='62' LET p2=g_x[31]    
             WHEN p1='63' LET p2=g_x[32]    
             WHEN p1='64' LET p2=g_x[33]    
             WHEN p1='65' LET p2=g_x[34]    
             WHEN p1='71' LET p2=g_x[35]    
             WHEN p1=' P' LET p2=g_x[36]    
             WHEN p1=' M' LET p2=g_x[37]    
             WHEN p1='39' LET p2=g_x[40]     #bugno:6431 add
        END CASE
   RETURN p2
END FUNCTION
#FUN-870144
