# Prog. Version..: '5.30.07-13.05.16(00001)'     #
#
# Pattern name...: amrx580.4gl
# Descriptions...: MRP-PLP 與 PR 數量比較表
# Date & Author..: 97/08/21 By Melody
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.FUN-510046 05/01/28 By pengu 報表轉XML
# Modify.........: No.FUN-570240 05/07/22 By vivien 料件編號欄位增加controlp
# Modify.........: No.TQC-640132 06/04/18 By Nicola 日期調整
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-690047 06/09/27 By Sarah 抓取請購單資料時,需將pml38='Y'條件加入
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-750093 07/06/13 By zhoufeng 報表改為使用Crystal Reports
# Modify.........: No.MOD-8B0050 08/11/14 By Pengu sr.diff必須先取絕對值再和tm.num比較
# Modify.........: No.MOD-8B0056 08/11/14 By Pengu 當mss_file和pml_file資料有多筆時會互相影響SUM計算
# Modify.........: No.FUN-8B0002 09/031/01 By lilingyu 屾樓賸pml_file
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-B60237 11/06/28 By zhangll sql增加關聯條件
# Modify.........: No.FUN-CB0004 12/11/02 By dongsz CR轉XtraGrid
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                          # Print condition RECORD
            # wc      LIKE type_file.chr1000, # Where condition            #NO.FUN-680082 VARCHAR(600)  #FUN-CB0004 mark
              wc      STRING,                 #FUN-CB0004 add
              bdate   LIKE type_file.dat,     #NO.FUN-680082 DATE
              edate   LIKE type_file.dat,     #NO.FUN-680082 DATE
              ver_no  LIKE mss_file.mss_v,    #NO.FUN-680082 VARCHAR(2)
              num     LIKE type_file.num5,    #NO.FUN-680082 SMALLINT
              more    LIKE type_file.chr1     # Input more condition(Y/N)  #NO.FUN-680082 VARCHAR(1)
              END RECORD
 
DEFINE   g_i          LIKE type_file.num5     #count/index for any purpose #NO.FUN-680082 SMALLINT
DEFINE   g_head1      STRING
DEFINE   g_sql        STRING                  #No.FUN-750093
DEFINE   l_table      STRING                  #No.FUN-750093
DEFINE   g_str        STRING                  #No.FUN-750093
 
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
 
#No.FUN-750093 --start--
   LET g_sql="mss01.mss_file.mss01,ima02.ima_file.ima02,ima021.ima_file.ima021,",
             "ima25.ima_file.ima25,mss09.mss_file.mss09,pml20.pml_file.pml20,",
             "chr8.type_file.chr8"
 
   LET l_table = cl_prt_temptable('amrx580',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-750093 --end--
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.ver_no = ARG_VAL(10)
   LET tm.num = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL amrx580_tm(0,0)        # Input print condition
      ELSE CALL amrx580()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amrx580_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01    #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,   #NO.FUN-680082 SMALLINT
          l_n            LIKE type_file.num5,   #NO.FUN-680082 SMALLINT
          l_cmd          LIKE type_file.chr1000 #NO.FUN-680082 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 24
   ELSE LET p_row = 4 LET p_col = 15
   END IF
 
   OPEN WINDOW amrx580_w AT p_row,p_col
        WITH FORM "amr/42f/amrx580" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.num = 0   
   LET tm.more = 'N'
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON mss01 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW amrx580_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
 
   INPUT BY NAME tm.bdate,tm.edate,tm.ver_no,tm.num,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD ver_no
         IF cl_null(tm.ver_no) THEN NEXT FIELD ver_no END IF
         SELECT COUNT(*) INTO l_n FROM mss_file
            WHERE mss_v=tm.ver_no
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
      LET INT_FLAG = 0 CLOSE WINDOW amrx580_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amrx580'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amrx580','9031',1)
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
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.ver_no CLIPPED,"'",
                         " '",tm.num CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('amrx580',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amrx580_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL amrx580()
   ERROR ""
END WHILE
   CLOSE WINDOW amrx580_w
END FUNCTION
 
FUNCTION amrx580()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name     #NO.FUN-680082 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0076
      #   l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT    #NO.FUN-680082 VARCHAR(1000)  #FUN-CB0004 mark
          l_sql     STRING,                 #FUN-CB0004 add
          l_chr     LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #NO.FUN-680082 VARCHAR(40)
          sr        RECORD 
                    mss01   LIKE mss_file.mss01,
                    mss09   LIKE mss_file.mss09,
                    pml20   LIKE pml_file.pml20,
                    diff    LIKE mss_file.mss09     #NO.FUN-680082 DECIMAL(6,2)
                    END RECORD
#No.FUN-750093 --start--
   DEFINE l_ima02   LIKE ima_file.ima02
   DEFINE l_ima021  LIKE ima_file.ima021
   DEFINE l_ima25   LIKE ima_file.ima25
   DEFINE l_diff    LIKE type_file.chr8
   DEFINE l_str     STRING                   #FUN-CB0004 add
#No.FUN-750093 --end--
 
     CALL cl_del_data(l_table)               #No.FUN-750093
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
    #----------------No.MOD-8B0056 modify
    #LET l_sql = "SELECT mss01,SUM(mss09),SUM(pml20),0 ",
    #            "  FROM mss_file,pml_file ",
    #            " WHERE mss01=pml04 AND ",tm.wc clipped,
    #            "   AND mss_v='",tm.ver_no,"'" 
     LET l_sql = "SELECT mss01,SUM(mss09),0,0 ",
              #   "  FROM mss_file ",            #NO.FUN-8B0002
                 "  FROM mss_file,pml_file ",    #NO.FUN-8B0002
                #" WHERE ",tm.wc clipped,
                 " WHERE mss01=pml04 AND ",tm.wc clipped,  #MOD-B60237 mod
                 "   AND mss_v='",tm.ver_no,"'" 
    #----------------No.MOD-8B0056 end
     IF NOT cl_null(tm.bdate) AND tm.edate IS NOT NULL THEN
        LET l_sql=l_sql CLIPPED,
                 "   AND mss03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
                 "   AND pml35 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' "   #No.TQC-640132
     END IF
     LET l_sql=l_sql CLIPPED,"   AND pml38='Y'"   #FUN-690047 add  #可用/不可用
     LET l_sql=l_sql CLIPPED," GROUP BY mss01 "
     PREPARE amrx580_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM 
     END IF
     DECLARE amrx580_curs1 CURSOR FOR amrx580_prepare1
 
#     CALL cl_outnam('amrx580') RETURNING l_name  #No.FUN-750093
#     START REPORT amrx580_rep TO l_name          #No.FUN-750093
#     LET g_pageno = 0                            #No.FUN-750093
     FOREACH amrx580_curs1 INTO sr.*            
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      #----------------No.MOD-8B0056 add
       IF NOT cl_null(tm.bdate) AND tm.edate IS NOT NULL THEN
          SELECT SUM(pml20) INTO sr.pml20 FROM pml_file,pmk_file
                            WHERE pml04 = sr.mss01
                              AND pml01=pmk01
                              AND pml38 = 'Y'
                              AND pmk18 != 'X'
                              AND pml35 >=tm.bdate AND pml35 <= tm.edate
       ELSE 
          SELECT SUM(pml20) INTO sr.pml20 FROM pml_file,pmk_file
                            WHERE pml04 = sr.mss01
                              AND pml01=pmk01
                              AND pml38 = 'Y'
                              AND pmk18 != 'X'
       END IF
      #----------------No.MOD-8B0056 end
       IF sr.mss09 IS NULL THEN LET sr.mss09=0 END IF
       IF sr.pml20 IS NULL THEN LET sr.pml20=0 END IF
       #------------------------------------------------------- 計算差異率
       IF sr.mss09=0 THEN 
          IF sr.pml20=0 THEN 
             LET sr.diff=0 
          ELSE
             LET sr.diff=100
          END IF
       ELSE
          LET sr.diff=(sr.mss09-sr.pml20)/sr.mss09*100 
       END IF
      #----------No.MOD-8B0050 add 
       IF sr.diff < 0 THEN
          LET sr.diff = sr.diff * -1
       END IF
      #----------No.MOD-8B0050 end 
       #------------------------------------------------------------------
#No.FUN-750093 --start--
       SELECT ima02,ima021,ima25 INTO l_ima02,l_ima021,l_ima25 FROM ima_file
              WHERE ima01=sr.mss01
       IF STATUS THEN LET l_ima02='' LET l_ima021='' LET l_ima25='' END IF
       LET l_diff=sr.diff USING '##&.&','%'
       IF sr.diff>=tm.num THEN
#          OUTPUT TO REPORT amrx580_rep(sr.*)       #No.FUN-750093
           EXECUTE insert_prep USING sr.mss01,l_ima02,l_ima021,l_ima25,
                                     sr.mss09,sr.pml20,l_diff 
       END IF
     END FOREACH
 
#     FINISH REPORT amrx580_rep                     #No.FUN-750093
#
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #No.FUN-750093
#No.FUN-750093 --start--
    LET g_xgrid.table = l_table    ###XtraGrid###
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN              #FUN-CB0004 add
        CALL cl_wcchp(tm.wc,'mss01')
           RETURNING tm.wc
     END IF                            #FUN-CB0004 add
###XtraGrid###     LET g_str = tm.ver_no,";",tm.bdate,";",tm.edate,";",tm.wc
###XtraGrid###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###XtraGrid###     CALL cl_prt_cs3('amrx580','amrx580',l_sql,g_str)
   #FUN-CB0004--add--str---
    LET g_xgrid.order_field = "mss01"
    LET g_xgrid.grup_field = "mss01"
    LET g_xgrid.footerinfo1 = cl_getmsg("mss-001",g_lang),': ',tm.ver_no,"|",cl_getmsg('lib-035',g_lang),': ',tm.bdate,' - ',tm.edate
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc     
   #FUN-CB0004--add--end---
    CALL cl_xg_view()    ###XtraGrid###
#No.FUN-750093 --end--
END FUNCTION
#No.FUN-750093 --start--mark
{REPORT amrx580_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1          #NO.FUN-680082 VARCHAR(1)
   DEFINE l_ima02   LIKE ima_file.ima02 
   DEFINE l_ima021  LIKE ima_file.ima021
   DEFINE l_ima25   LIKE ima_file.ima25 
   DEFINE l_diff    LIKE type_file.chr8          #NO.FUN-680082 VARCHAR(6)
   DEFINE sr        RECORD 
                    mss01   LIKE mss_file.mss01,
                    mss09   LIKE mss_file.mss09,
                    pml20   LIKE pml_file.pml20,
                    diff    LIKE pml_file.pml20  #NO.FUN-680082 DECIMAL(6,2)
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
  LEFT MARGIN g_left_margin 
  BOTTOM MARGIN g_bottom_margin 
  PAGE LENGTH g_page_line
 
  ORDER BY sr.mss01
 
  FORMAT
 
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
 
      LET g_head1=g_x[13] CLIPPED,tm.ver_no,'       ',g_x[14] CLIPPED,tm.bdate,'-',tm.edate
      PRINT g_head1
      PRINT g_dash[1,g_len] CLIPPED
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      SELECT ima02,ima021,ima25 INTO l_ima02,l_ima021,l_ima25 FROM ima_file WHERE ima01=sr.mss01
      IF STATUS THEN LET l_ima02='' LET l_ima021='' LET l_ima25='' END IF
      LET l_diff=sr.diff USING '##&.&','%'
      PRINT COLUMN g_c[31],sr.mss01,
             COLUMN g_c[32],l_ima02 CLIPPED, #MOD-4A0238
            COLUMN g_c[33],l_ima021,
            COLUMN g_c[34],l_ima25, 
            COLUMN g_c[35],cl_numfor(sr.mss09,35,2),
            COLUMN g_c[36],cl_numfor(sr.pml20,36,2),
            COLUMN g_c[37],l_diff
   
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
#No.FUN-750093 --end--


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
