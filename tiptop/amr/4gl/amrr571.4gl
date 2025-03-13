# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: amrr571.4gl
# Descriptions...: MRP 版本比較表
# Date & Author..: 01/12/06 By Apple 
# Modify.........: No.FUN-510046 05/01/28 By pengu 報表轉XML
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0080 06/11/17 By xumin 報表表頭調整
# Modify.........: No.FUN-750093 07/05/28 By jan 報表改為使用crystal report
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                           # Print condition RECORD
              wc       LIKE type_file.chr1000, # Where condition            #NO.FUN-680082 VARCHAR(600) 
              ver_no   LIKE mss_file.mss_v,    #NO.FUN-680082 VARCHAR(2)
              more     LIKE type_file.chr1     # Input more condition(Y/N)  #NO.FUN-680082 VARCHAR(1)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5   #count/index for any purpose #NO.FUN-680082 SMALLINT
DEFINE   g_str           STRING                #No.FUN-750093
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
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.ver_no = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL amrr571_tm(0,0)        # Input print condition
      ELSE CALL amrr571()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amrr571_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01     #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #NO.FUN-680082 SMALLINT
          l_n            LIKE type_file.num5,    #NO.FUN-680082 SMALLINT
          l_cmd          LIKE type_file.chr1000  #NO.FUN-680082 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 30
   ELSE LET p_row = 4 LET p_col = 15
   END IF
 
   OPEN WINDOW amrr571_w AT p_row,p_col
        WITH FORM "amr/42f/amrr571" 
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
{
   CONSTRUCT BY NAME tm.wc ON mss01,mss03 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
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
          CALL cl_show_fld_cont()   #FUN-550037(smin)
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW amrr571_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
}
   INPUT BY NAME tm.ver_no,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()   #FUN-550037(smin)
         LET g_action_choice = "locale"
 
      AFTER FIELD ver_no
         IF cl_null(tm.ver_no) THEN NEXT FIELD ver_no END IF
         SELECT COUNT(*) INTO l_n FROM msr_file
            WHERE msr_v=tm.ver_no
         IF l_n=0 THEN
            CALL cl_err(tm.ver_no,'amr-051',0)
            NEXT FIELD ver_no
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
      LET INT_FLAG = 0 CLOSE WINDOW amrr571_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amrr571'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amrr571','9031',1)
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
                         " '",tm.ver_no CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('amrr571',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amrr571_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL amrr571()
   ERROR ""
END WHILE
   CLOSE WINDOW amrr571_w
END FUNCTION
 
FUNCTION amrr571()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name      #NO.FUN-680082 VARCHAR(20)
#         l_time          LIKE type_file.chr8        #No.FUN-6A0076
          l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT               #NO.FUN-680082 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #NO.FUN-680082 VARCHAR(40)
          sr        RECORD 
                    msl03   LIKE msl_file.msl03,
                    msl04   LIKE msl_file.msl04
                    END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT msl03,msl04 FROM msl_file", 
                 " WHERE msl_v='",tm.ver_no,"'",
                 "   AND msl04 != '0' "
     CALL cl_prt_cs1('amrr571','amrr571',l_sql,g_str)   #No.FUN-750093
#No.FUN-750093--begin
#     PREPARE amrr571_prepare1 FROM l_sql
#     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
#        EXIT PROGRAM 
#     END IF
#     DECLARE amrr571_curs1 CURSOR FOR amrr571_prepare1
 
#     CALL cl_outnam('amrr571') RETURNING l_name
#     START REPORT amrr571_rep TO l_name
#     LET g_pageno = 0
#     FOREACH amrr571_curs1 INTO sr.*            
#       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#        OUTPUT TO REPORT amrr571_rep(sr.*)
#     END FOREACH
 
#     FINISH REPORT amrr571_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-750093--end
END FUNCTION
 
#No.FUN-750093--begin
{
REPORT amrr571_rep(sr)
   DEFINE l_last_sw  LIKE type_file.chr1        #NO.FUN-680082 VARCHAR(1)
   DEFINE sr         RECORD 
                     msl03   LIKE msl_file.msl03,
                     msl04   LIKE msl_file.msl04
                     END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
  LEFT MARGIN g_left_margin 
  BOTTOM MARGIN g_bottom_margin 
  PAGE LENGTH g_page_line
 
  ORDER BY sr.msl04,sr.msl03 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED   #TQC-6A0080
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED  #TQC-6A0080
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
 
      PRINT g_dash[1,g_len] CLIPPED
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      PRINT COLUMN g_c[31],sr.msl04 CLIPPED, #TQC-6A0080
            COLUMN g_c[32],sr.msl03 CLIPPED  #TQC-6A0080
 
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
END REPORT}
#No.FUN-750093--end
