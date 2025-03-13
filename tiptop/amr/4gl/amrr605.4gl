# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: amrr605.4gl
# Descriptions...: 多工廠MRP采購建議表（依行動日）)
# Input parameter: 
# Return code....: 
# Date & Author..: 05/11/14 By Vivien
# Modify.........: No.TQC-650087 06/06/01 By Rayven mss_g_file和mst_g_file命名                                                      
#                  不規範，mss_g_file現使用msu_file，mst_g_file現使用msv_file，                                                     
#                  相關欄位做相應更改：mss_gv改為msu000，mst_gv改為msv000，                                                         
#                  mst_gplant改為msv031，mst_gplantv改為msv032 
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-850155 08/05/30 By destiny 報表改為CR輸出
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE  tm  RECORD                    # Print condition RECORD
           wc      LIKE type_file.chr1000,# Where condition      #NO.FUN-680082 VARCHAR(600)
           n       LIKE type_file.chr1,  #NO.FUN-680082 VARCHAR(1)
           msu000  LIKE msu_file.msu000,             
           s       LIKE type_file.chr3,  # 排序 (INPUT 條件)    #NO.FUN-680082 VARCHAR(03)
           t       LIKE type_file.chr3,  # 跳頁 (INPUT 條件)    #NO.FUN-680082 VARCHAR(03)
           more    LIKE type_file.chr1   # 輸入其它特殊列印條件 #NO.FUN-680082 VARCHAR(01)
           END RECORD                                               
DEFINE   g_cnt     LIKE type_file.num10  #NO.FUN-680082 INTEGER 
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
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL amrr605_tm(0,0)        # Input print condition
      ELSE CALL amrr605()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amrr605_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01      #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,     #NO.FUN-680082 SMALLINT
          l_cmd          LIKE type_file.chr1000   #NO.FUN-680082 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 14
   ELSE LET p_row = 4 LET p_col = 15
   END IF
 
   OPEN WINDOW amrr605_w AT p_row,p_col
        WITH FORM "amr/42f/amrr605" 
################################################################################
# START genero shell script ADD
      ATTRIBUTE (STYLE = g_win_style)
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.n    = '1'
   LET tm.more = 'N'
   LET tm.s    = '123'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
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
   CONSTRUCT BY NAME tm.wc ON msu11,msu02,msu01,msu03 
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION CONTROLP                                     
           CASE                                                
              WHEN INFIELD(msu02)                             
                CALL cl_init_qry_var()                           
                LET g_qryparam.form = "q_pmc2"                    
                LET g_qryparam.state = 'c'                         
                CALL cl_create_qry() RETURNING g_qryparam.multiret  
                DISPLAY g_qryparam.multiret TO msu02       
                NEXT FIELD msu02                            
              WHEN INFIELD(msu01)                            
                CALL cl_init_qry_var()                          
                LET g_qryparam.form = "q_ima14"                  
                LET g_qryparam.state = 'c'                        
                CALL cl_create_qry() RETURNING g_qryparam.multiret 
                DISPLAY g_qryparam.multiret TO msu01  
                NEXT FIELD msu01    
           END CASE       
                           
     ON ACTION locale
         #CALL cl_dynamic_locale()
         LET g_action_choice = "locale"
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
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('msuuser', 'msugrup') #FUN-980030
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW amrr605_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
 
   INPUT BY NAME tm.msu000,
                   tm2.s1,tm2.s2,tm2.s3,
                   tm2.t1,tm2.t2,tm2.t3,
                   tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD msu000
         IF cl_null(tm.msu000) THEN NEXT FIELD msu000 END IF
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
 
      ON ACTION about        
         CALL cl_about()    
 
      ON ACTION help         
         CALL cl_show_help()
 
   
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW amrr605_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amrr605'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amrr605','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",   
                         " '",g_rep_clas CLIPPED,"'",  
                         " '",g_template CLIPPED,"'"  
         CALL cl_cmdat('amrr605',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amrr605_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL amrr605()
   ERROR ""
END WHILE
   CLOSE WINDOW amrr605_w
END FUNCTION
 
FUNCTION amrr605()
   DEFINE l_name    LIKE type_file.chr20,      # External(Disk) file name     #NO.FUN-680082 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0076
          l_sql     LIKE type_file.chr1000,    # RDSQL STATEMENT              #NO.FUN-680082 VARCHAR(1000)
          l_order ARRAY[3] OF LIKE msu_file.msu01,                            #NO.FUN-680082 VARCHAR(20)
          sr    RECORD
                l_order1  LIKE msu_file.msu01,  #NO.FUN-680082 VARCHAR(20)
                l_order2  LIKE msu_file.msu01,  #NO.FUN-680082 VARCHAR(20) 
                l_order3  LIKE msu_file.msu01   #NO.FUN-680082 VARCHAR(20)
                  END RECORD,
          sr_mrp   RECORD 
                   msu01 like msu_file.msu01,
                   msu02 like msu_file.msu02,
                   msu03 like msu_file.msu03,
                   msu09 like msu_file.msu09,
                   msu11 like msu_file.msu11,
                   msv031 like msv_file.msv031,
                   msv032 like msv_file.msv032,
                   msv16 like msv_file.msv16
                   END RECORD
DEFINE    g_str     STRING                           #No.FUN-850155
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                    #No.FUN-850155 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET l_sql= "SELECT msu01,msu02,msu03,msu09,",
#               "       msu11,msv031,msv032,msv16",                              #No.FUN-850155
                "       msu11,msv031,msv032,msv16,ima02,ima25,pmc03",            #No.FUN-850155
#               "  FROM msu_file,msv_file",                                      #No.FUN-850155 
                " FROM msu_file LEFT OUTER JOIN ima_file ON msu01=ima01  LEFT OUTER JOIN pmc_file ON msu02=pmc01,msv_file ",        #No.FUN-850155 
                " WHERE msv01=msu01 AND msv02=msu02",
                "   AND msv03=msu03 AND msu000='",tm.msu000,"'",
                "   AND msu000 = msv000 ",
                "   AND msu09>'0' AND ",tm.wc clipped,
                " ORDER BY msu000,msu01,msu02,msu03"
#No.FUN-850155--begin--
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'msu11,msu02,msu01,msu03')                                                                              
        RETURNING tm.wc                                                                                                             
        LET g_str = tm.wc                                                                                                           
     END IF                                                                                                                         
     LET g_str =g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t[1,1],";",                                                  
                tm.t[2,2],";",tm.t[3,3],";",tm.msu000                                                                           
     CALL cl_prt_cs1('amrr605','amrr605',l_sql,g_str)
#    PREPARE amrr605_prepare1 FROM l_sql
#    IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
#       EXIT PROGRAM 
#    END IF
#    DECLARE lcur_gmrp CURSOR FOR amrr605_prepare1
 
#    CALL cl_outnam('amrr605') RETURNING l_name
#    START REPORT amrr605_rep TO l_name
#    LET g_pageno = 0
#    FOREACH lcur_gmrp INTO sr_mrp.*      
#      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#      FOR g_cnt = 1 TO 3
#        CASE
#          WHEN tm.s[g_cnt,g_cnt]='1' LET l_order[g_cnt]=sr_mrp.msu11
#          WHEN tm.s[g_cnt,g_cnt]='2' LET l_order[g_cnt]=sr_mrp.msu01
#          WHEN tm.s[g_cnt,g_cnt]='3' LET l_order[g_cnt]=sr_mrp.msu02
#          WHEN tm.s[g_cnt,g_cnt]='4' LET l_order[g_cnt]=sr_mrp.msu03
#          WHEN tm.s[g_cnt,g_cnt]='5' LET l_order[g_cnt]=sr_mrp.msv031
#          OTHERWISE LET l_order[g_cnt]='-'
#        END CASE
#      END FOR
#      LET sr.l_order1=l_order[1]
#      LET sr.l_order2=l_order[2]
#      LET sr.l_order3=l_order[3]
 
#      OUTPUT TO REPORT amrr605_rep(sr.*,sr_mrp.*)
#    END FOREACH
 
#    FINISH REPORT amrr605_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-850155--end--
END FUNCTION
#No.FUN-850155--begin--
#REPORT amrr605_rep(sr,sr_mrp)
#  DEFINE l_last_sw    LIKE type_file.chr1    #NO.FUN-680082 VARCHAR(1)
#  DEFINE l_pmc03      LIKE pmc_file.pmc03    #NO.FUN-680082 VARCHAR(10)
#  DEFINE l_ima02      LIKE ima_file.ima02
#  DEFINE l_ima25      LIKE ima_file.ima25
#  DEFINE mss		RECORD LIKE mss_file.*
#  DEFINE ima		RECORD LIKE ima_file.*
#  DEFINE sr RECORD
#            l_order1  LIKE msu_file.msu01,   #NO.FUN-680082 VARCHAR(20)
#            l_order2  LIKE msu_file.msu01,   #NO.FUN-680082 VARCHAR(20)
#            l_order3  LIKE msu_file.msu01    #NO.FUN-680082 VARCHAR(20)
#         END RECORD
#  DEFINE sr_mrp RECORD
#                msu01 like msu_file.msu01,
#                msu02 like msu_file.msu02,
#                msu03 like msu_file.msu03,
#                msu09 like msu_file.msu09,
#                msu11 like msu_file.msu11,
#                msv031 like msv_file.msv031,
#                msv032 like msv_file.msv032,
#                msv16 like msv_file.msv16
#                END RECORD
 
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# ORDER BY sr.l_order1,sr.l_order2,sr.l_order3,
#          sr_mrp.msu11,sr_mrp.msu01, sr_mrp.msu02, sr_mrp.msu03
#  FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     PRINT g_dash[1,g_len] CLIPPED
#     PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#           g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#           g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41]
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
 
#  BEFORE GROUP OF sr_mrp.msu11
#     PRINT COLUMN g_c[31],sr_mrp.msu11;
 
#  BEFORE GROUP OF sr_mrp.msu01
#     SELECT ima02,ima25 INTO l_ima02,l_ima25 FROM ima_file  
#      WHERE ima01=sr_mrp.msu01
#     PRINT COLUMN g_c[32],sr_mrp.msu01[1,20],
#           COLUMN g_c[33],l_ima02;
#
# BEFORE GROUP OF sr_mrp.msu02
#     LET l_pmc03 = ''
#     SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=sr_mrp.msu02
#     PRINT COLUMN g_c[34],sr_mrp.msu02[1,7],
#           COLUMN g_c[35],l_pmc03,
#           COLUMN g_c[36],sr_mrp.msu03 USING 'mm/dd',
#           COLUMN g_c[37],cl_numfor(sr_mrp.msu09,37,2);
#  ON EVERY ROW
#     PRINT COLUMN g_c[38],sr_mrp.msv031,
#           COLUMN g_c[39],sr_mrp.msv032,
#           COLUMN g_c[40],cl_numfor(sr_mrp.msv16,40,2),
#           COLUMN g_c[41],l_ima25
#
#  AFTER GROUP OF sr_mrp.msu11
#     PRINT g_dash2[1,g_len] CLIPPED
#  ON LAST ROW
#     LET l_last_sw = 'y'
#     PRINT g_dash[1,g_len]
#     PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9),g_x[7]
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash2[1,g_len] CLIPPED
#     PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9),g_x[6]
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-850155--end--
#FUN-870144
