# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: amsr522.4gl
# Descriptions...: MRP 採購/生產建議表(依行動日)
# Input parameter: 
# Return code....: 
# Date & Author..: 96/06/10 By Roger
# Modify.........: No.FUN-510036 05/01/18 By pengu 報表轉XML
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗 
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-5C0005 06/01/02 By kevin 欄位對齊
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610075 06/01/24 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680101 06/08/30 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-690116 06/10/16 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.TQC-6A0080 06/11/16 By cheunl 報表格式修改
# Modify.........: No.FUN-850082 08/05/16 By xiaofeizhu 將報表輸出改為CR
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                        # Print condition RECORD
              wc      LIKE type_file.chr1000,#NO.FUN-680101 VARCHAR(600)  # Where condition
              ver_no  LIKE mps_file.mps_v,  #NO.FUN-680101 VARCHAR(2)
              s       LIKE type_file.chr3,  #NO.FUN-680101 VARCHAR(3)
              t       LIKE type_file.chr3,  #NO.FUN-680101 VARCHAR(3)
              more    LIKE type_file.chr1   #NO.FUN-680101 VARCHAR(1)    # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_cnt        LIKE type_file.num10  #NO.FUN-680101 INTEGER  
DEFINE   g_i          LIKE type_file.num5   #NO.FUN-680101 SMALLINT   #count/index for any purpose
DEFINE   l_table        STRING,                 ### FUN-850082 ###                                                                  
         g_sql          STRING,                 ### FUN-850082 ###                                                                  
         g_str          STRING                  ### FUN-850082 ###
 
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
 
### *** FUN-850082 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
    LET g_sql = "mps11.mps_file.mps11,",                                                                                            
                "mps10.mps_file.mps10,",                                                                                            
                "mps09.mps_file.mps09,",                                                                                            
                "mps03.mps_file.mps03,",                                                                                            
                "mps01.mps_file.mps01,",                                                                                            
                "mps00.mps_file.mps00,",                                                                                            
                "ima25.ima_file.ima25,",                                                                                            
                "ima08.ima_file.ima08,",                                                                                            
                "ima67.ima_file.ima67,",                                                                                            
                "ima43.ima_file.ima43"                                                                                              
    LET l_table = cl_prt_temptable('amsr522',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                          
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610075-begin
   LET tm.ver_no = ARG_VAL(8)
   LET tm.s = ARG_VAL(9)
   LET tm.t = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   ##No.FUN-570264 ---end---
   #TQC-610075-end
   IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL amsr522_tm(0,0)        # Input print condition
      ELSE CALL amsr522()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amsr522_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,  #NO.FUN-680101 SMALLINT
          l_cmd          LIKE type_file.chr1000#NO.FUN-680101 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 17
   ELSE LET p_row = 4 LET p_col = 15
   END IF
 
   OPEN WINDOW amsr522_w AT p_row,p_col
        WITH FORM "ams/42f/amsr522" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET tm.s    = '123'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON mps11,mps01,ima08,ima67,ima43,mps03 
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
      LET INT_FLAG = 0 CLOSE WINDOW amsr522_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm.ver_no,
                   tm2.s1,tm2.s2,tm2.s3,
                   tm2.t1,tm2.t2,tm2.t3,
                   tm.more WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD ver_no
         IF cl_null(tm.ver_no) THEN NEXT FIELD ver_no END IF
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
      AFTER INPUT  
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
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
      LET INT_FLAG = 0 CLOSE WINDOW amsr522_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amsr522'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amsr522','9031',1)
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
                         " '",tm.ver_no CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         #TQC-610075-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('amsr522',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amsr522_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL amsr522()
   ERROR ""
END WHILE
   CLOSE WINDOW amsr522_w
END FUNCTION
 
FUNCTION amsr522()
   DEFINE l_name    LIKE type_file.chr20,  #NO.FUN-680101 VARCHAR(20)   # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0081
          l_sql     LIKE type_file.chr1000,#NO.FUN-680101 VARCHAR(1000) # RDSQL STATEMENT
          l_chr     LIKE type_file.chr1,   #NO.FUN-680101 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,#NO.FUN-680101 VARCHAR(40)
          l_order ARRAY[3] OF   LIKE mps_file.mps01,     #FUN-5B0105 20->40   #NO.FUN-680101 VARCHAR(40)
          sr    RECORD
                l_order1 LIKE mps_file.mps01,  #FUN-5B0105 20->40   #NO.FUN-680101 VARCHAR(40)
                l_order2 LIKE mps_file.mps01,  #FUN-5B0105 20->40   #NO.FUN-680101 VARCHAR(40)
                l_order3 LIKE mps_file.mps01   #FUN-5B0105 20->40   #NO.FUN-680101 VARCHAR(40)
          END RECORD,
          mps	RECORD LIKE mps_file.*,
          ima	RECORD LIKE ima_file.*
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-850082 *** ##                                                      
   CALL cl_del_data(l_table)                                                                                                        
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                           #FUN-850082                                   
   #------------------------------ CR (2) ------------------------------#
 
     LET l_sql = "SELECT *",
                 " FROM mps_file, ima_file",
                 " WHERE mps01=ima01 AND mps09 > 0 ",
                 " AND mps_v='",tm.ver_no,"'",
                 " AND ",tm.wc clipped
     PREPARE amsr522_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM 
     END IF
     DECLARE amsr522_curs1 CURSOR FOR amsr522_prepare1
 
#    CALL cl_outnam('amsr522') RETURNING l_name                                       #No.FUN-850082
#    START REPORT amsr522_rep TO l_name                                               #No.FUN-850082
#    LET g_pageno = 0                                                                 #No.FUN-850082
 
     FOREACH amsr522_curs1 INTO mps.*, ima.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
     #No.FUN-850082--Mark--Begin--#
#      FOR g_cnt = 1 TO 3
#        CASE
#          WHEN tm.s[g_cnt,g_cnt]='1' LET l_order[g_cnt]=mps.mps11
#                                                        USING 'yyyymmdd'
#          WHEN tm.s[g_cnt,g_cnt]='2' LET l_order[g_cnt]=mps.mps01
#          WHEN tm.s[g_cnt,g_cnt]='3' LET l_order[g_cnt]=ima.ima08
#          WHEN tm.s[g_cnt,g_cnt]='4' LET l_order[g_cnt]=ima.ima67
#          WHEN tm.s[g_cnt,g_cnt]='5' LET l_order[g_cnt]=ima.ima43
#          WHEN tm.s[g_cnt,g_cnt]='6' LET l_order[g_cnt]=mps.mps03
#                                                        USING 'yyyymmdd'
#          OTHERWISE LET l_order[g_cnt]='-'
#        END CASE
#      END FOR
#      LET sr.l_order1=l_order[1]
#      LET sr.l_order2=l_order[2]
#      LET sr.l_order3=l_order[3]
 
#      OUTPUT TO REPORT amsr522_rep(sr.*,mps.*, ima.*)
     #No.FUN-850082--Mark--End--#
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-850082 *** ##                                                      
         EXECUTE insert_prep USING                                                                                                  
                 mps.mps11,mps.mps10,mps.mps09,mps.mps03,mps.mps01,mps.mps00,                                                       
                 ima.ima25,ima.ima08,ima.ima67,ima.ima43                                                                  
     #------------------------------ CR (3) ------------------------------#
 
     END FOREACH
 
#    FINISH REPORT amsr522_rep                                                           #No.FUN-850082
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                                         #No.FUN-850082
 
#No.FUN-850082--begin                                                                                                               
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'mps11,mps01,ima08,ima67,ima43,mps03')                                                                 
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                        
#No.FUN-850082--end                                                                                                                 
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-850082 **** ##                                                        
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",                                                                
                tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.ver_no                                                                               
    CALL cl_prt_cs3('amsr522','amsr522',g_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
 
#No.FUN-850082--Mark--Begin--#
#REPORT amsr522_rep(sr,mps, ima)
#  DEFINE l_last_sw     LIKE type_file.chr1          #NO.FUN-680101 VARCHAR(1)
#  DEFINE l_pmc03       LIKE pmc_file.pmc03          #NO.FUN-680101 VARCHAR(10)
#  DEFINE mps		RECORD LIKE mps_file.*
#  DEFINE ima		RECORD LIKE ima_file.*
#  DEFINE sr RECORD
#            l_order1 LIKE mps_file.mps01, #FUN-5B0105 20->40   #NO.FUN-680101 VARCHAR(40)
#            l_order2 LIKE mps_file.mps01, #FUN-5B0105 20->40   #NO.FUN-680101 VARCHAR(40)
#            l_order3 LIKE mps_file.mps01  #FUN-5B0105 20->40   #NO.FUN-680101 VARCHAR(40)
#         END RECORD
 
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# ORDER BY sr.l_order1,sr.l_order2,sr.l_order3,
#          mps.mps11, mps.mps01, mps.mps03
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED    #No.TQC-6A0080
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED      #No.TQC-6A0080
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company            #No.TQC-6A0080
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]                   #No.TQC-6A0080
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
 
#     PRINT g_dash[1,g_len] CLIPPED
#     PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#           g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.l_order1
#     IF tm.t[1,1]='Y' AND (PAGENO > 1 OR LINENO > 9) THEN
#        SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF sr.l_order2
#     IF tm.t[2,2]='Y' AND (PAGENO > 1 OR LINENO > 9) THEN
#        SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF sr.l_order3
#     IF tm.t[3,3]='Y' AND (PAGENO > 1 OR LINENO > 9) THEN
#        SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF mps.mps11
#     PRINT COLUMN g_c[31],mps.mps11;
#  BEFORE GROUP OF mps.mps01
#     PRINT COLUMN g_c[32],mps.mps01 CLIPPED,  #FUN-5B0014 [1,20],
#           COLUMN g_c[33],ima.ima25;
#  ON EVERY ROW
#     PRINT COLUMN g_c[34],mps.mps00 USING '###&', #FUN-590118
#           COLUMN g_c[35],mps.mps03 USING 'mm/dd',
#           COLUMN g_c[36],mps.mps09 USING '--------,--&.&&',  #No.TQC-5C0005
#           COLUMN g_c[37],mps.mps10
#  AFTER GROUP OF mps.mps11
#     PRINT g_dash2[1,g_len] CLIPPED
#  ON LAST ROW
#     LET l_last_sw = 'y'
#     PRINT g_dash[1,g_len]
#     PRINT g_x[4] ,g_x[5],COLUMN (g_len-9),g_x[7]
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len] CLIPPED
#        PRINT g_x[4] ,g_x[5],COLUMN (g_len-9),g_x[6]
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-850082--Mark--End--#
#FUN-870144
