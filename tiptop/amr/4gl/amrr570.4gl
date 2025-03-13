# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: amrr570.4gl
# Descriptions...: MRP 版本比較表
# Date & Author..: 97/08/21 By Melody
# Modify.........: No.FUN-510046 05/02/15 By pengu 報表轉XML
# Modify.........: No.FUN-570240 05/07/22 By vivien 料件編號欄位增加controlp
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: NO.MOD-720041 07/02/06 By TSD.GILL 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/29 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.CHI-860021 08/07/07 By sherry 無對應資料仍應比對 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-970075 09/11/04 By jan 當第一個版本無資料而第二個版本有資料時,會無法呈現此差異
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                          # Print condition RECORD
              wc      LIKE type_file.chr1000, # Where condition        #NO.FUN-680082 VARCHAR(600)
              ver_no1 LIKE mss_file.mss_v,                             #NO.FUN-680082 VARCHAR(2)
              ver_no2 LIKE mss_file.mss_v,                             #NO.FUN-680082 VARCHAR(2)
              more    LIKE type_file.chr1     # Input more condition(Y/N)  #NO.FUN-680082 VARCHAR(1)
              END RECORD
 
DEFINE   g_i         LIKE type_file.num5     #count/index for any purpose   #NO.FUN-680082 SMALLINT
 
#NO.MOD-720041 07/02/06 BY TSD.GILL --START
DEFINE l_table     STRING  
DEFINE g_sql       STRING   
DEFINE g_str       STRING   
#NO.MOD-720041 07/02/06 BY TSD.GILL --END
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116
 
   #NO.MOD-720041 07/02/06 BY TSD.GILL --START
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "mss01.mss_file.mss01,",
               "ima02.ima_file.ima02,",
               "mss02.mss_file.mss02,",
               "mss03.mss_file.mss03,",
               "code.type_file.chr1,",
               "num1.mss_file.mss041,",              
               "num2.mss_file.mss041,",              
               "num1_2.mss_file.mss041"              
   LET l_table = cl_prt_temptable('amrr570',g_sql) CLIPPED   # 產生Temp Table 
   IF l_table = -1 THEN 
      EXIT PROGRAM 
   END IF        
   # Temp Table產生   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, 
               " VALUES(?,?,?,?,?, ?,?,?)"   
   PREPARE insert_prep FROM g_sql   
   IF STATUS THEN     
      CALL cl_err('insert_prep:',status,1) 
      EXIT PROGRAM   
   END IF
   #NO.MOD-720041 07/02/06 BY TSD.GILL --END
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.ver_no1 = ARG_VAL(8)
   LET tm.ver_no2 = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL amrr570_tm(0,0)        # Input print condition
      ELSE CALL amrr570()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amrr570_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01      #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,     #NO.FUN-680082 SMALLINT
          l_n            LIKE type_file.num5,     #NO.FUN-680082 SMALLINT
          l_cmd          LIKE type_file.chr1000   #NO.FUN-680082 VARCHAR(400) 
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 14
   ELSE LET p_row = 4 LET p_col = 15
   END IF
 
   OPEN WINDOW amrr570_w AT p_row,p_col
        WITH FORM "amr/42f/amrr570" 
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
   CONSTRUCT BY NAME tm.wc ON mss01,mss03 
 
     #No.FUN-570240 --start
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
      ON ACTION controlp                                                                                                 
         IF INFIELD(mss01) THEN                                                                                                  
            CALL cl_init_qry_var()                                                                                               
            LET g_qryparam.form = "q_ima"                                                                                       
            LET g_qryparam.state = "c"                                                                                           
            CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
            DISPLAY g_qryparam.multiret TO mss01                                                                                 
            NEXT FIELD mss01                                                                                                     
         END IF                                                            
     #No.FUN-570240 --end  
 
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
      LET INT_FLAG = 0 CLOSE WINDOW amrr570_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
 
   INPUT BY NAME tm.ver_no1, tm.ver_no2, tm.more WITHOUT DEFAULTS
      #No.FUN-580031 --start--
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD ver_no1
         IF cl_null(tm.ver_no1) THEN NEXT FIELD ver_no1 END IF
         SELECT COUNT(*) INTO l_n FROM mss_file
            WHERE mss_v=tm.ver_no1
         IF l_n=0 THEN
            CALL cl_err(tm.ver_no1,'amr-051',0)
            NEXT FIELD ver_no1
         END IF
      AFTER FIELD ver_no2
         IF cl_null(tm.ver_no2) THEN NEXT FIELD ver_no2 END IF
         SELECT COUNT(*) INTO l_n FROM mss_file
            WHERE mss_v=tm.ver_no2
         IF l_n=0 THEN
            CALL cl_err(tm.ver_no2,'amr-051',0)
            NEXT FIELD ver_no2
         END IF
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
      ON ACTION CONTROLG 
         CALL cl_cmdask()    # Command execution
 
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
      LET INT_FLAG = 0 CLOSE WINDOW amrr570_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amrr570'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amrr570','9031',1)
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
                         " '",tm.ver_no1 CLIPPED,"'",
                         " '",tm.ver_no2 CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('amrr570',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amrr570_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL amrr570()
   ERROR ""
END WHILE
   CLOSE WINDOW amrr570_w
END FUNCTION
 
#NO.MOD-720041 07/02/06 BY TSD.GILL --START
#原本的程式碼，全部mark起來，改用Crystal Report寫法
{
FUNCTION amrr570()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name      #NO.FUN-680082 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0076
          l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT               #NO.FUN-680082 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #NO.FUN-680082 VARCHAR(40) 
          l_mss     RECORD LIKE mss_file.*,
          sr        RECORD 
                    mss_v   LIKE mss_file.mss_v,
                    mss01   LIKE mss_file.mss01,
                    mss02   LIKE mss_file.mss02,
                    mss03   LIKE mss_file.mss03,
                    mss041  LIKE mss_file.mss041,
                    mss043  LIKE mss_file.mss043,
                    mss044  LIKE mss_file.mss044,
                    mss051  LIKE mss_file.mss051,
                    mss052  LIKE mss_file.mss052,
                    mss053  LIKE mss_file.mss053,
                    mss061  LIKE mss_file.mss061,
                    mss062  LIKE mss_file.mss061,
                    mss063  LIKE mss_file.mss063,
                    mss064  LIKE mss_file.mss064,
                    mss065  LIKE mss_file.mss065,
                    code    LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(01)
                    num1    LIKE mss_file.mss041,   #NO.FUN-680082 DEC(15,3)
                    num2    LIKE mss_file.mss041    #NO.FUN-680082 DEC(15,3)
                    END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT mss_v,mss01,mss02,mss03,mss041,mss043,mss044,",
                 "       mss051,mss052,mss053,mss061,mss062,mss063,mss064,",
                 "       mss065,'',0,0 FROM mss_file ",
                 " WHERE ",tm.wc,
                 "   AND mss_v='",tm.ver_no1,"'"
     PREPARE amrr570_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM 
     END IF
     DECLARE amrr570_curs1 CURSOR FOR amrr570_prepare1
 
     CALL cl_outnam('amrr570') RETURNING l_name
     START REPORT amrr570_rep TO l_name
     LET g_pageno = 0
     FOREACH amrr570_curs1 INTO sr.*            
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       IF sr.mss041 IS NULL THEN LET sr.mss041=0 END IF
       IF sr.mss043 IS NULL THEN LET sr.mss043=0 END IF
       IF sr.mss044 IS NULL THEN LET sr.mss044=0 END IF
       IF sr.mss051 IS NULL THEN LET sr.mss051=0 END IF
       IF sr.mss052 IS NULL THEN LET sr.mss052=0 END IF
       IF sr.mss053 IS NULL THEN LET sr.mss053=0 END IF
       IF sr.mss061 IS NULL THEN LET sr.mss061=0 END IF
       IF sr.mss062 IS NULL THEN LET sr.mss062=0 END IF
       IF sr.mss063 IS NULL THEN LET sr.mss063=0 END IF
       IF sr.mss064 IS NULL THEN LET sr.mss064=0 END IF
       IF sr.mss065 IS NULL THEN LET sr.mss065=0 END IF
       #---------------------------------------------------- 版本比較
       SELECT * INTO l_mss.* FROM mss_file
          WHERE mss_v=tm.ver_no2
            AND mss01=sr.mss01 AND mss02=sr.mss02 AND mss03=sr.mss03 
       IF STATUS THEN CONTINUE FOREACH END IF
       IF l_mss.mss041 IS NULL THEN LET l_mss.mss041=0 END IF
       IF l_mss.mss043 IS NULL THEN LET l_mss.mss043=0 END IF
       IF l_mss.mss044 IS NULL THEN LET l_mss.mss044=0 END IF
       IF l_mss.mss051 IS NULL THEN LET l_mss.mss051=0 END IF
       IF l_mss.mss052 IS NULL THEN LET l_mss.mss052=0 END IF
       IF l_mss.mss053 IS NULL THEN LET l_mss.mss053=0 END IF
       IF l_mss.mss061 IS NULL THEN LET l_mss.mss061=0 END IF
       IF l_mss.mss062 IS NULL THEN LET l_mss.mss062=0 END IF
       IF l_mss.mss063 IS NULL THEN LET l_mss.mss063=0 END IF
       IF l_mss.mss064 IS NULL THEN LET l_mss.mss064=0 END IF
       IF l_mss.mss065 IS NULL THEN LET l_mss.mss065=0 END IF
       IF sr.mss041!=l_mss.mss041 THEN
          LET sr.code='1'
          LET sr.num1=sr.mss041
          LET sr.num2=l_mss.mss041
          OUTPUT TO REPORT amrr570_rep(sr.*)
       END IF
       IF sr.mss043!=l_mss.mss043 THEN
          LET sr.code='2'
          LET sr.num1=sr.mss043
          LET sr.num2=l_mss.mss043
          OUTPUT TO REPORT amrr570_rep(sr.*)
       END IF
       IF sr.mss044!=l_mss.mss044 THEN
          LET sr.code='3'
          LET sr.num1=sr.mss044
          LET sr.num2=l_mss.mss044
          OUTPUT TO REPORT amrr570_rep(sr.*)
       END IF
       IF sr.mss051!=l_mss.mss051 THEN
          LET sr.code='4'
          LET sr.num1=sr.mss051
          LET sr.num2=l_mss.mss051
          OUTPUT TO REPORT amrr570_rep(sr.*)
       END IF
       IF sr.mss052!=l_mss.mss052 THEN
          LET sr.code='5'
          LET sr.num1=sr.mss052
          LET sr.num2=l_mss.mss052
          OUTPUT TO REPORT amrr570_rep(sr.*)
       END IF
       IF sr.mss053!=l_mss.mss053 THEN
          LET sr.code='6'
          LET sr.num1=sr.mss053
          LET sr.num2=l_mss.mss053
          OUTPUT TO REPORT amrr570_rep(sr.*)
       END IF
       IF sr.mss061!=l_mss.mss061 THEN
          LET sr.code='7'
          LET sr.num1=sr.mss061
          LET sr.num2=l_mss.mss061
          OUTPUT TO REPORT amrr570_rep(sr.*)
       END IF
       IF sr.mss062!=l_mss.mss062 THEN
          LET sr.code='8'
          LET sr.num1=sr.mss062
          LET sr.num2=l_mss.mss062
          OUTPUT TO REPORT amrr570_rep(sr.*)
       END IF
       IF sr.mss063!=l_mss.mss063 THEN
          LET sr.code='9'
          LET sr.num1=sr.mss063
          LET sr.num2=l_mss.mss063
          OUTPUT TO REPORT amrr570_rep(sr.*)
       END IF
       IF sr.mss064!=l_mss.mss064 THEN
          LET sr.code='A'
          LET sr.num1=sr.mss064
          LET sr.num2=l_mss.mss064
          OUTPUT TO REPORT amrr570_rep(sr.*)
       END IF
       IF sr.mss065!=l_mss.mss065 THEN
          LET sr.code='B'
          LET sr.num1=sr.mss065
          LET sr.num2=l_mss.mss065
          OUTPUT TO REPORT amrr570_rep(sr.*)
       END IF
       #-----------------------------------------------------------------
     END FOREACH
 
     FINISH REPORT amrr570_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT amrr570_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1      #NO.FUN-680082 VARCHAR(1)
   DEFINE l_ima02      LIKE ima_file.ima02 
   DEFINE l_str        LIKE zaa_file.zaa08      #NO.FUN-680082 VARCHAR(10)
   DEFINE sr        RECORD 
                    mss_v   LIKE mss_file.mss_v,
                    mss01   LIKE mss_file.mss01,
                    mss02   LIKE mss_file.mss02,
                    mss03   LIKE mss_file.mss03,
                    mss041  LIKE mss_file.mss041,
                    mss043  LIKE mss_file.mss043,
                    mss044  LIKE mss_file.mss044,
                    mss051  LIKE mss_file.mss051,
                    mss052  LIKE mss_file.mss052,
                    mss053  LIKE mss_file.mss053,
                    mss061  LIKE mss_file.mss061,
                    mss062  LIKE mss_file.mss061,
                    mss063  LIKE mss_file.mss063,
                    mss064  LIKE mss_file.mss064,
                    mss065  LIKE mss_file.mss065,
                    code    LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(01)
                    num1    LIKE mss_file.mss041,   #NO.FUN-680082 DEC(15,3)
                    num2    LIKE mss_file.mss041    #NO.FUN-680082 DEC(15,3)
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin 
         BOTTOM MARGIN g_bottom_margin 
         PAGE LENGTH g_page_line   #No.MOD-580242
 
  ORDER BY sr.mss01,sr.mss02,sr.mss03,sr.code
 
  FORMAT
 
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
 
      PRINT g_dash[1,g_len] CLIPPED
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      CASE sr.code
           WHEN '1' LET l_str=g_x[13] CLIPPED
           WHEN '2' LET l_str=g_x[14] CLIPPED
           WHEN '3' LET l_str=g_x[15] CLIPPED
           WHEN '4' LET l_str=g_x[16] CLIPPED
           WHEN '5' LET l_str=g_x[17] CLIPPED
           WHEN '6' LET l_str=g_x[18] CLIPPED
           WHEN '7' LET l_str=g_x[19] CLIPPED
           WHEN '8' LET l_str=g_x[20] CLIPPED
           WHEN '9' LET l_str=g_x[21] CLIPPED
           WHEN 'A' LET l_str=g_x[22] CLIPPED
           WHEN 'B' LET l_str=g_x[23] CLIPPED
      END CASE 
      SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=sr.mss01
      PRINT COLUMN g_c[31],sr.mss01,
            COLUMN g_c[32],l_ima02,
            COLUMN g_c[33],sr.mss02,
            COLUMN g_c[34],sr.mss03,
            COLUMN g_c[35],l_str,
            COLUMN g_c[36],cl_numfor(sr.num1,36,2), 
            COLUMN g_c[37],cl_numfor(sr.num2,37,2),
            COLUMN g_c[38],cl_numfor(sr.num2-sr.num1,38,2) 
   
   AFTER GROUP OF sr.mss01
      PRINT ''
 
   ON LAST ROW
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
    IF l_last_sw = 'n'
        THEN PRINT g_dash[1,g_len]
             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
        ELSE SKIP 2 LINES
     END IF
END REPORT
}
 
FUNCTION amrr570()
   DEFINE l_sql     STRING,
          sr        RECORD 
                    mss_v   LIKE mss_file.mss_v,
                    mss01   LIKE mss_file.mss01,
                    mss02   LIKE mss_file.mss02,
                    mss03   LIKE mss_file.mss03,
                    mss041  LIKE mss_file.mss041,
                    mss043  LIKE mss_file.mss043,
                    mss044  LIKE mss_file.mss044,
                    mss051  LIKE mss_file.mss051,
                    mss052  LIKE mss_file.mss052,
                    mss053  LIKE mss_file.mss053,
                    mss061  LIKE mss_file.mss061,
                    mss062  LIKE mss_file.mss061,
                    mss063  LIKE mss_file.mss063,
                    mss064  LIKE mss_file.mss064,
                    mss065  LIKE mss_file.mss065,
                    code    LIKE type_file.chr1,  
                    num1    LIKE mss_file.mss041,
                    num2    LIKE mss_file.mss041
                    END RECORD,
          l_mss     RECORD LIKE mss_file.*
   DEFINE l_mss01   LIKE mss_file.mss01   #FUN-970075
   DEFINE l_mss02   LIKE mss_file.mss02   #FUN-970075
   DEFINE l_mss03   LIKE mss_file.mss03   #FUN-970075
 
   #NO.MOD-720041 07/02/06 BY TSD.GILL --START
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> MOD-720045 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #NO.MOD-720041 07/02/06 BY TSD.GILL --END
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang   
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
 
#FUN-970075--begin--mod----------------------------------
#  LET l_sql = "SELECT mss_v,mss01,mss02,mss03,mss041,mss043,mss044,",
#              "       mss051,mss052,mss053,mss061,mss062,mss063,mss064,",
#              "       mss065,'',0,0 FROM mss_file ",
#              " WHERE ",tm.wc,
#              "   AND mss_v='",tm.ver_no1,"'"
   LET l_sql = "SELECT DISTINCT mss01,mss02,mss03 FROM mss_file ",
               " WHERE ",tm.wc,
               "   AND (mss_v='",tm.ver_no1,"'",
               "    OR mss_v='",tm.ver_no2,"')"
#FUN-970075--end--mod-------------------------------------
   PREPARE amrr570_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM 
   END IF
   DECLARE amrr570_curs1 CURSOR FOR amrr570_prepare1
  #FOREACH amrr570_curs1 INTO sr.*                    #FUN-970075
   FOREACH amrr570_curs1 INTO l_mss01,l_mss02,l_mss03 #FUN-970075             
      IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH 
      END IF
     
      #FUN-970075--begin--add------------
      INITIALIZE sr.* TO NULL
      SELECT mss_v,mss01,mss02,mss03,mss041,mss043,mss044,
             mss051,mss052,mss053,mss061,mss062,mss063,mss064,
             mss065,'',0,0 
        INTO sr.* FROM mss_file
       WHERE mss01=l_mss01
         AND mss02=l_mss02
         AND mss03=l_mss03
         AND mss_v = tm.ver_no1
      IF SQLCA.sqlcode = 100 THEN
         LET sr.mss01=l_mss01
         LET sr.mss02=l_mss02
         LET sr.mss03=l_mss03
      END IF
      #FUN-970075--end--add---------------

      IF sr.mss041 IS NULL THEN LET sr.mss041=0 END IF
      IF sr.mss043 IS NULL THEN LET sr.mss043=0 END IF
      IF sr.mss044 IS NULL THEN LET sr.mss044=0 END IF
      IF sr.mss051 IS NULL THEN LET sr.mss051=0 END IF
      IF sr.mss052 IS NULL THEN LET sr.mss052=0 END IF
      IF sr.mss053 IS NULL THEN LET sr.mss053=0 END IF
      IF sr.mss061 IS NULL THEN LET sr.mss061=0 END IF
      IF sr.mss062 IS NULL THEN LET sr.mss062=0 END IF
      IF sr.mss063 IS NULL THEN LET sr.mss063=0 END IF
      IF sr.mss064 IS NULL THEN LET sr.mss064=0 END IF
      IF sr.mss065 IS NULL THEN LET sr.mss065=0 END IF
      #---------------------------------------------------- 版本比較
      INITIALIZE l_mss.* TO NULL
      SELECT * INTO l_mss.* FROM mss_file
         WHERE mss_v=tm.ver_no2
           AND mss01=l_mss01   #FUN-970075
           AND mss02=l_mss02   #FUN-970075
           AND mss03=l_mss03   #FUN-970075
      #No.CHI-860021---Begin
      #IF STATUS THEN            
      #   CONTINUE FOREACH 
      #END IF
      #No.CHI-860021---End
      IF l_mss.mss041 IS NULL THEN LET l_mss.mss041=0 END IF
      IF l_mss.mss043 IS NULL THEN LET l_mss.mss043=0 END IF
      IF l_mss.mss044 IS NULL THEN LET l_mss.mss044=0 END IF
      IF l_mss.mss051 IS NULL THEN LET l_mss.mss051=0 END IF
      IF l_mss.mss052 IS NULL THEN LET l_mss.mss052=0 END IF
      IF l_mss.mss053 IS NULL THEN LET l_mss.mss053=0 END IF
      IF l_mss.mss061 IS NULL THEN LET l_mss.mss061=0 END IF
      IF l_mss.mss062 IS NULL THEN LET l_mss.mss062=0 END IF
      IF l_mss.mss063 IS NULL THEN LET l_mss.mss063=0 END IF
      IF l_mss.mss064 IS NULL THEN LET l_mss.mss064=0 END IF
      IF l_mss.mss065 IS NULL THEN LET l_mss.mss065=0 END IF
 
      IF sr.mss041!=l_mss.mss041 THEN
         LET sr.code='1'
         LET sr.num1=sr.mss041
         LET sr.num2=l_mss.mss041
         
         CALL r570_ins_tmp(sr.mss01,sr.mss02,sr.mss03,sr.code,sr.num1,sr.num2)
      END IF
      IF sr.mss043!=l_mss.mss043 THEN
         LET sr.code='2'
         LET sr.num1=sr.mss043
         LET sr.num2=l_mss.mss043
         CALL r570_ins_tmp(sr.mss01,sr.mss02,sr.mss03,sr.code,sr.num1,sr.num2)
      END IF
      IF sr.mss044!=l_mss.mss044 THEN
         LET sr.code='3'
         LET sr.num1=sr.mss044
         LET sr.num2=l_mss.mss044
         CALL r570_ins_tmp(sr.mss01,sr.mss02,sr.mss03,sr.code,sr.num1,sr.num2)
      END IF
      IF sr.mss051!=l_mss.mss051 THEN
         LET sr.code='4'
         LET sr.num1=sr.mss051
         LET sr.num2=l_mss.mss051
         CALL r570_ins_tmp(sr.mss01,sr.mss02,sr.mss03,sr.code,sr.num1,sr.num2)
      END IF
      IF sr.mss052!=l_mss.mss052 THEN
         LET sr.code='5'
         LET sr.num1=sr.mss052
         LET sr.num2=l_mss.mss052
         CALL r570_ins_tmp(sr.mss01,sr.mss02,sr.mss03,sr.code,sr.num1,sr.num2)
      END IF
      IF sr.mss053!=l_mss.mss053 THEN
         LET sr.code='6'
         LET sr.num1=sr.mss053
         LET sr.num2=l_mss.mss053
         CALL r570_ins_tmp(sr.mss01,sr.mss02,sr.mss03,sr.code,sr.num1,sr.num2)
      END IF
      IF sr.mss061!=l_mss.mss061 THEN
         LET sr.code='7'
         LET sr.num1=sr.mss061
         LET sr.num2=l_mss.mss061
         CALL r570_ins_tmp(sr.mss01,sr.mss02,sr.mss03,sr.code,sr.num1,sr.num2)
      END IF
      IF sr.mss062!=l_mss.mss062 THEN
         LET sr.code='8'
         LET sr.num1=sr.mss062
         LET sr.num2=l_mss.mss062
         CALL r570_ins_tmp(sr.mss01,sr.mss02,sr.mss03,sr.code,sr.num1,sr.num2)
      END IF
      IF sr.mss063!=l_mss.mss063 THEN
         LET sr.code='9'
         LET sr.num1=sr.mss063
         LET sr.num2=l_mss.mss063
         CALL r570_ins_tmp(sr.mss01,sr.mss02,sr.mss03,sr.code,sr.num1,sr.num2)
      END IF
      IF sr.mss064!=l_mss.mss064 THEN
         LET sr.code='A'
         LET sr.num1=sr.mss064
         LET sr.num2=l_mss.mss064
         CALL r570_ins_tmp(sr.mss01,sr.mss02,sr.mss03,sr.code,sr.num1,sr.num2)
      END IF
      IF sr.mss065!=l_mss.mss065 THEN
         LET sr.code='B'
         LET sr.num1=sr.mss065
         LET sr.num2=l_mss.mss065
         CALL r570_ins_tmp(sr.mss01,sr.mss02,sr.mss03,sr.code,sr.num1,sr.num2)
      END IF
      INITIALIZE l_mss.* TO NULL
   END FOREACH
 
   #NO.MOD-720041 07/02/06 BY TSD.GILL --START
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ## 
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件   
   LET g_str =''
   IF g_zz05 = 'Y' THEN      
      CALL cl_wcchp(tm.wc,'mss01,mss03') RETURNING tm.wc
      LET g_str = tm.wc   
   END IF 
   IF cl_null(g_str) THEN
      LET g_str=' ' 
   END IF
   LET g_str = g_str,";",tm.ver_no1,";",tm.ver_no2   
   CALL cl_prt_cs3('amrr570','amrr570',l_sql,g_str)   #FUN-710080 modify
   #------------------------------ CR (4) ------------------------------#
   #NO.MOD-720041 07/02/06 BY TSD.GILL --END
 
END FUNCTION
 
FUNCTION r570_ins_tmp(p_mss01,p_mss02,p_mss03,p_code,p_num1,p_num2)
   DEFINE p_mss01      LIKE mss_file.mss01
   DEFINE p_mss02      LIKE mss_file.mss02
   DEFINE p_mss03      LIKE mss_file.mss03
   DEFINE p_code       LIKE type_file.chr1
   DEFINE p_num1       LIKE mss_file.mss041 
   DEFINE p_num2       LIKE mss_file.mss041 
   DEFINE l_ima02      LIKE ima_file.ima02 
   DEFINE l_num1_2     LIKE mss_file.mss041
 
   SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=p_mss01
   LET l_num1_2 = p_num2 - p_num1
   IF cl_null(l_num1_2) THEN
      LET l_num1_2 = 0 
   END IF
 
   #NO.MOD-720041 07/02/06 BY TSD.GILL --START
   ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##   
   EXECUTE insert_prep USING
       p_mss01,l_ima02,p_mss02,p_mss03,p_code,p_num1,p_num2,l_num1_2
   #------------------------------ CR (3) ------------------------------#
   #NO.MOD-720041 07/02/06 BY TSD.GILL --END
      
END FUNCTION 
 
#NO:PKGCR-AMR01 07/02/06 BY TSD.GILL --END
