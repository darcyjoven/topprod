# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: amrr530.4gl
# Descriptions...: MRP 交期調整表
# Input parameter: 
# Return code....: 
# Date & Author..: 96/06/10 By Roger
# Modify.........: No.FUN-510046 05/02/15 By pengu 報表轉XML
# Modify.........: No.FUN-550055 05/05/24 By day   單據編號加大
# Modify.........: No.FUN-570240 05/07/22 By vivien 料件編號欄位增加controlp
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610074 06/01/24 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.MOD-680006 06/08/07 By Pengu 報表->選擇多格式輸出->Word/Excel->表頭位置不正確
# Modify.........: No.FUN-680082 06/09/07 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-740112 07/04/23 By rainy po/pr/wo及項次不列印
# Modify.........: No.FUN-750112 07/05/31 By Jackho CR報表修改
# Modify.........: No.MOD-840148 08/04/19 By Pengu 若mst.mst08=NULL時應預設為0
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-C60186 12/06/27 By ck2yuan 清空mst 舊值
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                          #Print condition RECORD
              wc      LIKE type_file.chr1000, #NO.FUN-680082 VARCHAR(600)  # Where condition
             #n       LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(1)    #TQC-610074
              ver_no  LIKE mss_file.mss_v,    #NO.FUN-680082 VARCHAR(2)
              s       LIKE type_file.chr3,    #NO.FUN-680082 VARCHAR(3)
              t       LIKE type_file.chr3,    #NO.FUN-680082 VARCHAR(3)
              more    LIKE type_file.chr1     #NO.FUN-680082 VARCHAR(1)    # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_cnt        LIKE type_file.num10    #NO.FUN-680082 INTEGER   
DEFINE   g_i          LIKE type_file.num5     #NO.FUN-680082 SMALLINT   #count/index for any purpose
DEFINE   l_table      STRING                  ### FUN-750112 ###                                                                  
DEFINE   g_str        STRING                  ### FUN-750112 ###                                                                  
DEFINE   g_sql        STRING                  ### FUN-750112 ###
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
 
#--------FUN-750112--begin--CR(1)-----------#                                                                                       
    LET g_sql = " mss01.mss_file.mss01,",                                                                                           
                " ima02.ima_file.ima02,",                                                                                         
                " ima25.ima_file.ima25,",                                                                                         
                " mss02.mss_file.mss02,",                                                                                         
                " mss00.mss_file.mss00,",                                                                                         
                " mss03.mss_file.mss03,",                                                                                         
                " mss072.mss_file.mss072,",                                                                                         
                " mst08.mst_file.mst08,",                                                                                             
                " ima08.ima_file.ima08,",                                                                                         
                " ima67.ima_file.ima67,",                                                                                         
                " ima43.ima_file.ima43"                                                                                         
                                                                                                                                    
    LET l_table = cl_prt_temptable('amrr530',g_sql) CLIPPED                                                                         
    IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                        
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                " VALUES(?,?,?,?,?,?,?,?,?,?,?)"                                                                                                    
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#-------------------No.FUN-750112--end--CR(1)---------------#                                                                       
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610074-begin
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
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
   #TQC-610074-end
   IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL amrr530_tm(0,0)        # Input print condition
      ELSE CALL amrr530()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amrr530_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #NO.FUN-680082 SMALLINT
          l_cmd          LIKE type_file.chr1000  #NO.FUN-680082 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 14
   ELSE LET p_row = 4 LET p_col = 15
   END IF
 
   OPEN WINDOW amrr530_w AT p_row,p_col
        WITH FORM "amr/42f/amrr530" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   #LET tm.n    = '1'                 #TQC-610074
   LET tm.s    = '123'
   LET tm.more = 'N'
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
   CONSTRUCT BY NAME tm.wc ON mss01,ima67,mss02,ima08,ima43,mss03 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW amrr530_w 
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
      LET INT_FLAG = 0 CLOSE WINDOW amrr530_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amrr530'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amrr530','9031',1)
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
                         #TQC-610074-begin
                         " '",tm.ver_no CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         #TQC-610074-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('amrr530',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amrr530_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL amrr530()
   ERROR ""
END WHILE
   CLOSE WINDOW amrr530_w
END FUNCTION
 
FUNCTION amrr530()
   DEFINE l_name    LIKE type_file.chr20,   #NO.FUN-680082 VARCHAR(20)   # External(Disk) file name
#         l_time    LIKE type_file.chr8     #No.FUN-6A0076
          l_sql     LIKE type_file.chr1000, #NO.FUN-680082 VARCHAR(1000) # RDSQL STATEMENT
          l_chr     LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #NO.FUN-680082 VARCHAR(40)
          l_order ARRAY[3] OF LIKE mss_file.mss01,  #NO.FUN-680082 VARCHAR(40) #FUN-5B0105 20->40
          sr    RECORD
                l_order1 LIKE mss_file.mss01,  #NO.FUN-680082 VARCHAR(40) #FUN-5B0105 20->40
                l_order2 LIKE mss_file.mss01,  #NO.FUN-680082 VARCHAR(40) #FUN-5B0105 20->40
                l_order3 LIKE mss_file.mss01   #NO.FUN-680082 VARCHAR(40) #FUN-5B0105 20->40
          END RECORD,
          mss	RECORD LIKE mss_file.*,
          mst	RECORD LIKE mst_file.*,                 #No.FUN-750112
          ima	RECORD LIKE ima_file.*
 
#No.FUN-750112--begin--CR(2)                                                                                                       
     CALL cl_del_data(l_table)                                                                                                      
#No.FUN-750112--end--CR(2)  
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT *",
                 "  FROM mss_file, ima_file",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND mss01=ima01 AND (mss072-mss071)!=0 ",
                 "   AND mss_v='",tm.ver_no,"'"
     PREPARE amrr530_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM 
     END IF
     DECLARE amrr530_curs1 CURSOR FOR amrr530_prepare1
 
#No.FUN-750112--begin-----------------------------------------------#
#     CALL cl_outnam('amrr530') RETURNING l_name
#     START REPORT amrr530_rep TO l_name
#     LET g_pageno = 0
#No.FUN-750112--end-------------------------------------------------#
     FOREACH amrr530_curs1 INTO mss.*, ima.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#No.FUN-750112--begin-----------------------------------------------#
#       FOR g_cnt = 1 TO 3
#         CASE
#           WHEN tm.s[g_cnt,g_cnt]='1' LET l_order[g_cnt]=mss.mss01
#           WHEN tm.s[g_cnt,g_cnt]='2' LET l_order[g_cnt]=ima.ima08
#           WHEN tm.s[g_cnt,g_cnt]='3' LET l_order[g_cnt]=ima.ima67
#           WHEN tm.s[g_cnt,g_cnt]='4' LET l_order[g_cnt]=ima.ima43
#           WHEN tm.s[g_cnt,g_cnt]='5' LET l_order[g_cnt]=mss.mss02
#           WHEN tm.s[g_cnt,g_cnt]='6' LET l_order[g_cnt]=mss.mss03
#                                                         USING 'yyyymmdd'
#           OTHERWISE LET l_order[g_cnt]='-'
#         END CASE
#       END FOR
       INITIALIZE mst.* TO NULL   #MOD-C60186 add
       IF (mss.mss072-mss.mss071) < 0 THEN
          DECLARE r530_c2 CURSOR FOR
             SELECT * FROM mst_file
              WHERE mst01=mss.mss01 AND mst02=mss.mss02 AND mst03=mss.mss03
                AND mst_v=mss.mss_v
                AND mst05 MATCHES '6*'
                AND (mst06_fz = 'N' OR (mst06_fz IS NULL OR mst06_fz = ' ')) 
              ORDER BY mst04,mst05
          FOREACH r530_c2 INTO mst.*
#            LET l_string=mst.mst07[1,7],'  ',mst.mst04 USING 'mm/dd',
#                         '  ',mst.mst06              #No.FUN-550055
## Crystal Reports insert temp table --CR(3) ## 
            EXECUTE insert_prep USING                                                                                                   
                  mss.mss01,ima.ima02,ima.ima25,mss.mss02,mss.mss00,                                                                      
                  mss.mss03,mss.mss072,mst.mst08,ima.ima08,
                  ima.ima67,ima.ima43
## insert temp table--end--CR(3)             ##
          END FOREACH
       ELSE
          IF cl_null(mst.mst08) THEN LET mst.mst08 = 0 END IF   #No.MOD-840148 add
## Crystal Reports insert temp table --CR(3) ## 
          EXECUTE insert_prep USING                                                                                                   
             mss.mss01,ima.ima02,ima.ima25,mss.mss02,mss.mss00,                                                                      
             mss.mss03,mss.mss072,mst.mst08,ima.ima08,ima.ima67,
             ima.ima43
## insert temp table--end--CR(3)             ##
       END IF
#       OUTPUT TO REPORT amrr530_rep(sr.*,mss.*, ima.*)
     END FOREACH
 
#     FINISH REPORT amrr530_rep
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
## ****  Crystal Reports <<<< CALL cs3() >>>>--CR(4) ##                                                                             
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
     IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(tm.wc,'mss01,ima67,mss02,ima08,ima43,mss03')
              RETURNING tm.wc
         LET g_str = tm.wc
     END IF
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                 tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3]
     CALL cl_prt_cs3('amrr530','amrr530',l_sql,g_str)                                                                                
## ****  Crystal Reports <<<< CALL cs3() >>>>--CR(4) ##                                                                             
#No.FUN-750112--end-------------------------------------------------#
END FUNCTION
 
#No.FUN-750112--begin-----------------------------------------------#
#REPORT amrr530_rep(sr,mss, ima)
#   DEFINE l_last_sw     LIKE type_file.chr1     #NO.FUN-680082 VARCHAR(1)
#   DEFINE l_pmc03       LIKE pmc_file.pmc03     #NO.FUN-680082 VARCHAR(10)
#   DEFINE l_string      LIKE type_file.chr1000  #NO.FUN-680082 VARCHAR(25)
#   DEFINE mss		RECORD LIKE mss_file.*
#   DEFINE mst		RECORD LIKE mst_file.*
#   DEFINE ima		RECORD LIKE ima_file.*
#   DEFINE sr RECORD
#             l_order1 LIKE mss_file.mss01,  #NO.FUN-680082 VARCHAR(40) #FUN-5B0105 20->40
#             l_order2 LIKE mss_file.mss01,  #NO.FUN-680082 VARCHAR(40) #FUN-5B0105 20->40
#             l_order3 LIKE mss_file.mss01   #NO.FUN-680082 VARCHAR(40) #FUN-5B0105 20->40
#          END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin 
#       PAGE LENGTH g_page_line   #No.MOD-580242
#  ORDER BY sr.l_order1,sr.l_order2,sr.l_order3,mss.mss01,mss.mss02,mss.mss03
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT g_dash[1,g_len] CLIPPED
#    #FUN-740112
#      #PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#      #      g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#      #      g_x[39] CLIPPED,g_x[40] CLIPPED
#      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[40] CLIPPED
#    #FUN-740112
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.l_order1
#      IF tm.t[1,1]='Y' AND (PAGENO > 1 OR LINENO > 9) THEN
#         SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.l_order2
#      IF tm.t[2,2]='Y' AND (PAGENO > 1 OR LINENO > 9) THEN
#         SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.l_order3
#      IF tm.t[3,3]='Y' AND (PAGENO > 1 OR LINENO > 9) THEN
#         SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF mss.mss01
#      PRINT COLUMN g_c[31],mss.mss01,
#            COLUMN g_c[32],ima.ima02,
#            COLUMN g_c[33],ima.ima25
#   ON EVERY ROW
#      PRINT COLUMN g_c[34],mss.mss02[1,7],
#            COLUMN g_c[35],mss.mss00 USING '###&', #FUN-590118
#            COLUMN g_c[36],mss.mss03 USING 'mm/dd',
#            COLUMN g_c[37],cl_numfor((mss.mss072-mss.mss071),37,0) 
#      IF (mss.mss072-mss.mss071) < 0 THEN
#         DECLARE r530_c2 CURSOR FOR
#             SELECT * FROM mst_file
#              WHERE mst01=mss.mss01 AND mst02=mss.mss02 AND mst03=mss.mss03
#                AND mst_v=mss.mss_v
#                AND mst05 MATCHES '6*'
#                AND (mst06_fz = 'N' OR (mst06_fz IS NULL OR mst06_fz = ' ')) 
#              ORDER BY mst04,mst05
#         FOREACH r530_c2 INTO mst.*
#            LET l_string=mst.mst07[1,7],'  ',mst.mst04 USING 'mm/dd',
#                         '  ',mst.mst06              #No.FUN-550055
#           #FUN-740112
#            #PRINT COLUMN g_c[38],l_string,
#            #      COLUMN g_c[39],mst.mst061 USING '###&', #FUN-590118
#            #      COLUMN g_c[40],cl_numfor(mst.mst08,40,0) 
#            PRINT  COLUMN g_c[40],cl_numfor(mst.mst08,40,0) 
#           #FUN-740112 end
#         END FOREACH
#      END IF
#      PRINT
#   AFTER GROUP OF mss.mss01
#      PRINT g_dash2[1,g_len] CLIPPED
#   ON LAST ROW
#      LET l_last_sw = 'y'
#      PRINT g_dash[1,g_len] CLIPPED       #No.MOD-680006 add
#      PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7]
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len] CLIPPED     #No.MOD-680006 modify
#         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6]
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-750112--end-------------------------------------------------#
