# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: amrr500.4gl
# Descriptions...: MRP 模擬彙總報表
# Input parameter: 
# Return code....: 
# Date & Author..: 96/06/10 By Roger
# Modify.........: No.FUN-510046 05/02/15 By pengu 報表轉XML
# Modify.........: No.FUN-570240 05/07/22 By vivien 料件編號欄位增加controlp
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-5C0059 06/01/12 By kevin 欄位沒對齊
# Modify.........: No.TQC-610074 06/01/21 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.TQC-790177 07/09/29 By Carrier 去掉全型字符
# Modify.........: No.FUN-850048 08/05/19 By destiny 報表改為CR輸出
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.FUN-920183 09/03/20 By shiwuying MRP功能改善
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                # Print condition RECORD
              wc      LIKE type_file.chr1000,       # Where condition             #NO.FUN-680082 VARCHAR(600)   
              edate   LIKE type_file.dat,           #NO.FUN-680082 DATE
              ver_no  LIKE mss_file.mss_v,          #NO.FUN-680082 VARCHAR(3)
              n       LIKE type_file.chr2,          #NO.FUN-680082 VARCHAR(2)
              s       LIKE type_file.chr3,     #排列#NO.FUN-680082 VARCHAR(3)
              t       LIKE type_file.chr3,     #跳頁#NO.FUN-680082 VARCHAR(3)
              more    LIKE type_file.chr1           # Input more condition(Y/N)    #NO.FUN-680082 VARCHAR(1)
              END RECORD
 
DEFINE   g_cnt           LIKE type_file.num10        #NO.FUN-680082 INTEGER 
DEFINE   g_i             LIKE type_file.num5         #count/index for any purpose #NO.FUN-680082 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000      #NO.FUN-680082 VARCHAR(72) 
#No.FUN-850048--begin--
DEFINE   g_str           STRING                                                                    
DEFINE   l_table         STRING                                                                              
DEFINE   g_sql           STRING 
#No.FUN-850048--end--
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
#No.FUN-850048--begin--
   LET g_sql="mss01.mss_file.mss01,",
             "ima08.ima_file.ima08,",
             "ima67.ima_file.ima67,",
             "ima43.ima_file.ima43,",
             "mss02.mss_file.mss02,", 
             "ima25.ima_file.ima25,", 
             "mss00.mss_file.mss00,",
             "mss03.mss_file.mss03,",
             "mss041.mss_file.mss041,",
             "mss043.mss_file.mss043,", 
             "mss044.mss_file.mss044,",
             "mss051.mss_file.mss051,",
             "mss052.mss_file.mss052,",
             "mss053.mss_file.mss053,",
             "mss061.mss_file.mss061,",
             "mss062.mss_file.mss062,",
             "mss063.mss_file.mss063,",
             "mss064.mss_file.mss064,",
             "mss065.mss_file.mss065,", 
             "mss072.mss_file.mss072,", 
             "mss071.mss_file.mss071,",
             "mss08.mss_file.mss08,",
             "mss09.mss_file.mss09,",
             "g_msg.type_file.chr1000,",
             "ima02.ima_file.ima02"
     LET l_table = cl_prt_temptable('amrr500',g_sql) CLIPPED                                                                        
     IF l_table= -1 THEN EXIT PROGRAM END IF                                                                                        
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"                                                                                         
#               "        ?,?,?,?,?, ?,?,?,?,?,",                                                                                         
#               "        ?,?,?,?,?)"                                                                                           
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep',status,1) EXIT PROGRAM                                                                             
    END IF             
#No.FUN-850048--end--
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
#TQC-610074-begin
   LET tm.edate = ARG_VAL(8)
   LET tm.ver_no = ARG_VAL(9)
   LET tm.n = ARG_VAL(10)
   LET tm.s = ARG_VAL(11)
   LET tm.t = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   ##No.FUN-570264 ---end---
  #TQC-610074-end
   IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL amrr500_tm(0,0)        # Input print condition
      ELSE CALL amrr500()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amrr500_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01     #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #NO.FUN-680082 SMALLINT
          l_cmd          LIKE type_file.chr1000  #NO.FUN-680082 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col =14
   ELSE LET p_row = 3 LET p_col = 15
   END IF
 
   OPEN WINDOW amrr500_w AT p_row,p_col
        WITH FORM "amr/42f/amrr500" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.n    = '2'
   LET tm.more = 'N'
   LET tm.edate= g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.s = '123'
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N"  END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N"  END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N"  END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON mss01,ima67,mss02,ima08,ima43 
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION controlp                                                                                                 
         IF INFIELD(mss01) THEN                                                                                                  
#FUN-AA0059 --Begin--
          #  CALL cl_init_qry_var()                                                                                               
          #  LET g_qryparam.form = "q_ima"                                                                                       
          #  LET g_qryparam.state = "c"                                                                                           
          #  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
            CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
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
      LET INT_FLAG = 0 CLOSE WINDOW amrr500_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm.edate,tm.ver_no,tm.n,
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
      LET INT_FLAG = 0 CLOSE WINDOW amrr500_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amrr500'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amrr500','9031',1)
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
                         #TQC-610074-begin
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.ver_no CLIPPED,"'",
                         " '",tm.n CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         #TQC-610074-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('amrr500',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amrr500_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL amrr500()
   ERROR ""
END WHILE
   CLOSE WINDOW amrr500_w
END FUNCTION
 
FUNCTION amrr500()
   DEFINE l_name    LIKE type_file.chr20,    # External(Disk) file name         #NO.FUN-680082 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0076
          l_sql     LIKE type_file.chr1000,  # RDSQL STATEMENT                  #NO.FUN-680082 VARCHAR(1100)
          l_chr     LIKE type_file.chr1,     #NO.FUN-680082 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,  #NO.FUN-680082 VARCHAR(40)
          l_order   ARRAY[3] OF LIKE mss_file.mss01,  #NO.FUN-680082 VARCHAR(40)    #FUN-5B0105 20->40
     sr RECORD 
          l_order1  LIKE mss_file.mss01,   #FUN-5B0105 20->40   #NO.FUN-680082 VARCHAR(40) 
          l_order2  LIKE mss_file.mss01,   #FUN-5B0105 20->40   #NO.FUN-680082 VARCHAR(40) 
          l_order3  LIKE mss_file.mss01    #FUN-5B0105 20->40   #NO.FUN-680082 VARCHAR(40) 
      END RECORD,
          mss   RECORD LIKE mss_file.*, 
        # ima   RECORD LIKE ima_file.*
          l_ima02       LIKE ima_file.ima02,
          l_ima08       LIKE ima_file.ima08,
          l_ima67       LIKE ima_file.ima67,
          l_ima43       LIKE ima_file.ima43,
          l_ima25       LIKE ima_file.ima25
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    #No.FUN-850048                                    
     CALL cl_del_data(l_table)                                   #No.FUN-850048  
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT '','','',mss_file.*,ima02,ima25,ima08,ima67,ima43",
                 "  FROM mss_file, ima_file",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND mss01=ima01 ",
                 "   AND mss_v='",tm.ver_no,"'"
    IF tm.edate IS NOT NULL THEN
       LET l_sql=l_sql CLIPPED,
                 "   AND mss03<='",tm.edate,"'"
    END IF
    PREPARE amrr500_prepare1 FROM l_sql
    IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
       EXIT PROGRAM 
    END IF
    DECLARE amrr500_curs1 CURSOR FOR amrr500_prepare1
#No.FUN-850048--begin--
#    CALL cl_outnam('amrr500') RETURNING l_name
#    START REPORT amrr500_rep TO l_name
#    LET g_pageno = 0
    FOREACH amrr500_curs1 INTO sr.*,mss.*, l_ima02,l_ima25,l_ima08,l_ima67,l_ima43
#     FOR g_cnt = 1 TO 3 
#       CASE 
#          WHEN tm.s[g_cnt,g_cnt]='1' LET l_order[g_cnt] = mss.mss01
#         WHEN tm.s[g_cnt,g_cnt]='2' LET l_order[g_cnt] = l_ima08
#          WHEN tm.s[g_cnt,g_cnt]='3' LET l_order[g_cnt] = l_ima67
#          WHEN tm.s[g_cnt,g_cnt]='4' LET l_order[g_cnt] = l_ima43
#          WHEN tm.s[g_cnt,g_cnt]='5' LET l_order[g_cnt] = mss.mss02
#        OTHERWISE 
#             LET l_order[g_cnt]='-' 
#       END CASE 
#     END FOR 
#       LET sr.l_order1 = l_order[1] 
#       LET sr.l_order2 = l_order[2] 
#       LET sr.l_order3 = l_order[3] 
    
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     #No.FUN-920183 start -----
        IF (mss.mss041 = 0 OR cl_null(mss.mss041)) AND 
           (mss.mss043 = 0 OR cl_null(mss.mss043)) AND
           (mss.mss044 = 0 OR cl_null(mss.mss044)) AND 
           (mss.mss051 = 0 OR cl_null(mss.mss051)) AND
           (mss.mss052 = 0 OR cl_null(mss.mss052)) AND 
           (mss.mss053 = 0 OR cl_null(mss.mss053)) AND
           (mss.mss061 = 0 OR cl_null(mss.mss061)) AND 
           (mss.mss062 = 0 OR cl_null(mss.mss062)) AND
           (mss.mss063 = 0 OR cl_null(mss.mss063)) AND 
           (mss.mss064 = 0 OR cl_null(mss.mss064)) AND
           (mss.mss065 = 0 OR cl_null(mss.mss065)) AND 
           (mss.mss071 = 0 OR cl_null(mss.mss071)) AND
           (mss.mss072 = 0 OR cl_null(mss.mss072)) AND 
           (mss.mss08  = 0 OR cl_null(mss.mss08)) AND
           (mss.mss09  = 0 OR cl_null(mss.mss09)) THEN
           CONTINUE FOREACH
        END IF
     #No.FUN-920183 end -------
#  OUTPUT TO REPORT amrr500_rep(sr.*,mss.*, l_ima02,l_ima25,l_ima08,l_ima67,l_ima43)
     EXECUTE insert_prep USING mss.mss01,l_ima08,l_ima67,l_ima43,mss.mss02,l_ima25,mss.mss00,mss.mss03,
                               mss.mss041,mss.mss043,mss.mss044,mss.mss051,mss.mss052,mss.mss053,mss.mss061,
                               mss.mss062,mss.mss063,mss.mss064,mss.mss065,mss.mss072,mss.mss071,mss.mss08,
                               mss.mss09,g_msg,l_ima02
     END FOREACH
 
#     FINISH REPORT amrr500_rep
     IF g_zz05 = 'Y' THEN                                                                                                           
       CALL cl_wcchp(tm.wc,'mss01,ima67,mss02,ima08,ima43') 
        RETURNING tm.wc                                                                                                             
        LET g_str = tm.wc                                                                                                           
     END IF                                                                                                                         
     LET g_str=g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t[1,1],";",tm.t[2,2],";",
               tm.t[3,3],";",tm.n,";",tm.edate,";",tm.ver_no                                 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                               
     CALL cl_prt_cs3('amrr500','amrr500',g_sql,g_str)
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-850048--end--
END FUNCTION
#No.FUN-850048--begin--
#REPORT amrr500_rep(sr,mss, l_ima02,l_ima25,l_ima08,l_ima67,l_ima43)
#  DEFINE l_last_sw    LIKE type_file.chr1          #NO.FUN-680082 VARCHAR(1)
#  DEFINE 
#       sr RECORD l_order1     LIKE mss_file.mss01,  #FUN-5B0105 20->40  #NO.FUN-680082 VARCHAR(40)
#                 l_order2     LIKE mss_file.mss01,  #FUN-5B0105 20->40  #NO.FUN-680082 VARCHAR(40)
#                 l_order3     LIKE mss_file.mss01   #FUN-5B0105 20->40  #NO.FUN-680082 VARCHAR(40) 
#          END RECORD 
#  DEFINE mss           RECORD LIKE mss_file.*
#  DEFINE l_ima02       LIKE ima_file.ima02
#  DEFINE l_ima25       LIKE ima_file.ima25
#  DEFINE l_ima08       LIKE ima_file.ima08
#  DEFINE l_ima67       LIKE ima_file.ima67
#  DEFINE l_ima43       LIKE ima_file.ima43
#  DEFINE l_QOH         LIKE mss_file.mss041    #NO.FUN-680082 DEC(15,3)
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line   #No.MOD-580242
 
# ORDER BY sr.l_order1,sr.l_order2,sr.l_order3,mss.mss01,mss.mss02,mss.mss03
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     PRINT g_dash[1,g_len] CLIPPED
#     PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#           g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#           g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED,
#           g_x[43] CLIPPED,g_x[44] CLIPPED,g_x[45] CLIPPED,g_x[46] CLIPPED,
#           g_x[47] CLIPPED,g_x[48] CLIPPED,g_x[49] CLIPPED,g_x[50] CLIPPED,
#           g_x[51] CLIPPED,g_x[52] CLIPPED
#     PRINT g_dash1
#     LET l_last_sw = 'n'
#  BEFORE GROUP OF sr.l_order1 
#    IF tm.t[1,1] = 'Y' AND (PAGENO >1 OR LINENO >9) THEN 
#         SKIP TO TOP OF PAGE  
#    END IF 
#  BEFORE GROUP OF sr.l_order2 
#    IF tm.t[2,2] = 'Y' AND (PAGENO >1 OR LINENO >9) THEN 
#         SKIP TO TOP OF PAGE
#    END IF 
# BEFORE GROUP OF sr.l_order3 
#   IF tm.t[3,3] = 'Y' AND (PAGENO >1 OR LINENO >9) THEN 
#        SKIP TO TOP OF PAGE 
#   END IF 
 
#  BEFORE GROUP OF mss.mss02
#     PRINT COLUMN g_c[31],mss.mss01 CLIPPED;  #FUN-5B0014 [1,20];
#     PRINT COLUMN g_c[33],l_ima25,
#           COLUMN g_c[34],mss.mss02[1,7];
#     LET g_cnt=0
#     LET l_QOH=0
#  ON EVERY ROW
#     IF tm.n='2' THEN
#        LET g_cnt=g_cnt+1
#        IF g_cnt=2 THEN PRINT COLUMN g_c[32],l_ima02; END IF
#        #CALL r500_seq(mss.mss01,mss.mss02,mss.mss03)
#        LET l_QOH=l_QOH+(mss.mss051+mss.mss052+mss.mss053
#                        -mss.mss041-mss.mss043-mss.mss044)
#       PRINT COLUMN g_c[35],mss.mss00 USING '##########', #No.TQC-5C0059
#             COLUMN g_c[36],mss.mss03 USING 'mm/dd',
#             COLUMN g_c[37],cl_numfor(mss.mss041 ,37,0), 
#             COLUMN g_c[38],cl_numfor(mss.mss043 ,38,0), 
#             COLUMN g_c[39],cl_numfor(mss.mss044 ,39,0), 
#             COLUMN g_c[40],cl_numfor(mss.mss051 ,40,0), 
#             COLUMN g_c[41],cl_numfor(mss.mss052 ,41,0), 
#             COLUMN g_c[42],cl_numfor(mss.mss053 ,42,0), 
#             COLUMN g_c[43],cl_numfor(l_QOH      ,43,0), 
#             COLUMN g_c[44],cl_numfor(mss.mss061 ,44,0), 
#             COLUMN g_c[45],cl_numfor(mss.mss062 ,45,0), 
#             COLUMN g_c[46],cl_numfor(mss.mss063 ,46,0), 
#             COLUMN g_c[47],cl_numfor(mss.mss064 ,47,0), 
#             COLUMN g_c[48],cl_numfor(mss.mss065 ,48,0), 
#             COLUMN g_c[49],cl_numfor((mss.mss072-mss.mss071),49,0), 
#             COLUMN g_c[50],cl_numfor(mss.mss08  ,50,0), 
#             COLUMN g_c[51],cl_numfor(mss.mss09  ,51,0),
#             COLUMN g_c[52],g_msg[1,10] CLIPPED
#     END IF
#  AFTER GROUP OF mss.mss02
#     IF tm.n='2' THEN
#        IF g_cnt<2 THEN PRINT COLUMN g_c[32],l_ima02  END IF
#        PRINT
#     END IF
#     IF tm.n='1' THEN
#        LET l_QOH=GROUP SUM(mss.mss051+mss.mss052+mss.mss053
#                           -mss.mss041-mss.mss043-mss.mss044)
#        PRINT COLUMN g_c[35],mss.mss00 USING '#####',
#              COLUMN g_c[37],cl_numfor(GROUP SUM(mss.mss041) ,37,0),
#              COLUMN g_c[38],cl_numfor(GROUP SUM(mss.mss043) ,38,0),
#              COLUMN g_c[39],cl_numfor(GROUP SUM(mss.mss044) ,39,0),
#              COLUMN g_c[40],cl_numfor(GROUP SUM(mss.mss051) ,40,0),
#              COLUMN g_c[41],cl_numfor(GROUP SUM(mss.mss052) ,41,0),
#              COLUMN g_c[42],cl_numfor(GROUP SUM(mss.mss053) ,42,0),
#              COLUMN g_c[43],cl_numfor(l_QOH                 ,43,0),
#              COLUMN g_c[44],cl_numfor(GROUP SUM(mss.mss061) ,44,0),
#              COLUMN g_c[45],cl_numfor(GROUP SUM(mss.mss062) ,45,0),
#              COLUMN g_c[46],cl_numfor(GROUP SUM(mss.mss063) ,46,0),
#              COLUMN g_c[47],cl_numfor(GROUP SUM(mss.mss064) ,47,0),
#              COLUMN g_c[48],cl_numfor(GROUP SUM(mss.mss065) ,48,0),
#              COLUMN g_c[49],cl_numfor(GROUP SUM(mss.mss072-mss.mss071),49,0),
#              COLUMN g_c[50],cl_numfor(GROUP SUM(mss.mss08 ) ,50,0),
#              COLUMN g_c[51],cl_numfor(GROUP SUM(mss.mss09 ) ,51,0)
#        PRINT COLUMN g_c[32],l_ima02
#     END IF
#  ON LAST ROW
#     LET l_last_sw = 'y'
#     PRINT g_dash[1,g_len] CLIPPED
#     PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7]
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len] CLIPPED
#        PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6]
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-850048--end--
FUNCTION r500_seq(s1,s2,s3)
  DEFINE s1     LIKE mst_file.mst01   #NO.FUN-680082 VARCHAR(20)
  DEFINE s2     LIKE mst_file.mst02   #NO.FUN-680082 VARCHAR(20)
  DEFINE s3     LIKE mst_file.mst03   #NO.FUN-680082 DATE
  DEFINE seq    LIKE type_file.num5   #NO.FUN-680082 SMALLINT
  DECLARE r500_seq_c CURSOR FOR
     SELECT DISTINCT mst061 FROM mst_file
            WHERE mst01=s1 AND mst02=s2 AND mst03=s3 AND mst05='43'
              AND mst_v=tm.ver_no
            ORDER BY 1
  LET g_msg=''
  FOREACH r500_seq_c INTO seq
    LET g_msg=g_msg CLIPPED,seq USING '<<<<',','
  END FOREACH
END FUNCTION
#TQC-790177
#FUN-870144
