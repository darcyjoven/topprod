# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: ammr120.4gl
# Descriptions...: 逾期未結模治具開發案明細表
# Date & Author..: 01/01/18 By Faith
# Modify.........: No.FUN-4C0099 05/02/03 By kim 報表轉XML功能
# Modify.........: No.FUN-550114 05/05/26 By echo 新增報表備註
# Modify.........: No.MOD-550092 05/05/12 By Mandy RUN程式就會出現"lib-219"的錯誤訊息
# Modify.........: No.FUN-570240 05/07/26 By vivien 料件編號欄位增加controlp
# Modify.........: No.TQC-5B0062 05/11/08 By Claire 報表表尾列印位置調整
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.FUN-680100 06/08/28 By huchenghao 類型轉換
 
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-750093 07/06/11 By arman 報表改為使用crystal report
# Modify.........: No.FUN-750093 07/07/30 By arman 增加打印條件
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80065 11/08/05 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD            
           wc      STRING,                       #No.FUN-680100 # Where Condition  #TQC-630166
           s       LIKE type_file.chr3,          #No.FUN-680100 VARCHAR(03)
           t       LIKE type_file.chr3,          #No.FUN-680100 VARCHAR(03)
           u       LIKE type_file.chr3,          #No.FUN-680100 VARCHAR(03)
           amt_sw  LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)  
           more    LIKE type_file.chr1           #No.FUN-680100 VARCHAR(1)
           END RECORD,
          l_str    LIKE zaa_file.zaa08,          #No.FUN-680100 VARCHAR(14)
          g_orderA ARRAY[3] OF LIKE ima_file.ima01        #No.FUN-680100 VARCHAR(40)#FUN-5B0105 10->40
 
DEFINE   g_i             LIKE type_file.num5                #count/index for any purpose        #No.FUN-680100 SMALLINT
DEFINE   g_str           STRING                       #NO.FUN-750093
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT   
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMM")) THEN
      EXIT PROGRAM
   END IF
 
 
   LET g_pdate = ARG_VAL(1)      
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80065--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N' 
      THEN CALL r120_tm(0,0)        
      ELSE CALL r120()             
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
END MAIN
 
FUNCTION r120_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5           #No.FUN-680100 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000        #No.FUN-680100 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 10 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 17 
   ELSE LET p_row = 5 LET p_col = 10
   END IF
 
   OPEN WINDOW r120_w AT p_row,p_col
        WITH FORM "amm/42f/ammr120" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL        
   LET tm.s    = '123'
   LET tm.t    = '   '
   LET tm.u    = 'Y  '
   LET tm.more = 'N'
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
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON mmg01,mmg03,mmg09,mmg02,mmg04,mmg07  
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION controlp                                                                                                 
         IF INFIELD(mmg04) THEN                                                                                                  
            CALL cl_init_qry_var()                                                                                               
            LET g_qryparam.form = "q_ima"                                                                                       
            LET g_qryparam.state = "c"                                                                                           
            CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
            DISPLAY g_qryparam.multiret TO mmg04                                                                                 
            NEXT FIELD mmg04                                                                                                     
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('mmguser', 'mmggrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW r120_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                   tm2.t1,tm2.t2,tm2.t3,
                   tm2.u1,tm2.u2,tm2.u3,
                   tm.more WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
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
      ON ACTION CONTROLG CALL cl_cmdask()  
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
      LET INT_FLAG = 0 
      CLOSE WINDOW r120_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file   
             WHERE zz01='ammr120'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('ammr120','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,     
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('ammr120',g_time,l_cmd) 
      END IF
      CLOSE WINDOW r120_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r120()
   ERROR ""
END WHILE
   CLOSE WINDOW r120_w
END FUNCTION
 
FUNCTION r120()
DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680100 VARCHAR(20)
#       l_time       LIKE type_file.chr8        #No.FUN-6A0076
       l_sql     STRING,                       # RDSQL STATEMENT     #TQC-630166        #No.FUN-680100
       l_za05    LIKE type_file.chr1000,       #No.FUN-680100 VARCHAR(40)
       l_order   ARRAY[5] OF LIKE ima_file.ima01,               #No.FUN-680100 VARCHAR(40)#FUN-5B0105 20->40
       sr        RECORD order1    LIKE ima_file.ima01,          #No.FUN-680100 VARCHAR(40)#FUN-5B0105 20->40
                        order2    LIKE ima_file.ima01,          #No.FUN-680100 VARCHAR(40)#FUN-5B0105 20->40
                        order3    LIKE ima_file.ima01,          #No.FUN-680100 VARCHAR(40)#FUN-5B0105 20->40
                        mmg01     LIKE mmg_file.mmg01,   #開發案號
                        mmg02     LIKE mmg_file.mmg02,   #執行工單號
                        mmg04     LIKE mmg_file.mmg04,   #模治具料號
                        mmg05     LIKE mmg_file.mmg05,   #性質
                        mmi02     LIKE mmi_file.mmi02,   #說明
                        mmg21     LIKE mmg_file.mmg21,   #製品料號
                        mmg17     LIKE mmg_file.mmg17,   #完工比率
                        mmg18     LIKE mmg_file.mmg18,   #已耗費用
                        mmg19     LIKE mmg_file.mmg19,   #已耗工時
                        mmg191    LIKE mmg_file.mmg191,  #人工費用
                        mmg06     LIKE mmg_file.mmg06,   #開立日期
                        mmg07     LIKE mmg_file.mmg07,   #需求日期
                        mmg03     LIKE mmg_file.mmg03,   #類別
                        mmg08     LIKE mmg_file.mmg08,   #結案日期
                        mmg09     LIKE mmg_file.mmg09,   #需求部門
                        ima02     LIKE ima_file.ima02,   #品名
                        ima021    LIKE ima_file.ima021,  #規格
                        gem02     LIKE gem_file.gem02    #需求部門 
                        END RECORD
       #No.FUN-B80065--mark--Begin--- 
       #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
       #No.FUN-B80065--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT '','',' ', ",
                 "     mmg01,mmg02,mmg04,mmg05,mmi02,mmg21,  ",
                 "     mmg17,mmg18,mmg19,mmg191,mmg06,mmg07, ",
                 "     mmg03,mmg08,mmg09,ima02,ima021,gem02 ",
                 "  FROM mmg_file,ima_file,gem_file,",
                 " mmi_file ",
                 " WHERE ima_file.ima01=mmg21 AND gem_file.gem01=mmg09 ", 
                 "   AND mmi_file.mmi01=mmg05 AND mmi03='1' ", 
                 "   AND ", tm.wc CLIPPED
     
     LET l_sql = l_sql CLIPPED," ORDER BY mmg01,mmg02 "
#NO.FUN-750093 --------begin
#    PREPARE r120_prepare1 FROM l_sql
#    IF SQLCA.sqlcode != 0 THEN 
#       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
#       EXIT PROGRAM 
#    END IF
#    DECLARE r120_curs1 CURSOR FOR r120_prepare1
#    IF cl_prichk('$') THEN
 #MOD-550092 MARK 掉,待'$'解決方法出來再改
#    IF cl_chk_act_auth() THEN
#       LET tm.amt_sw = 'Y'
#    ELSE
#       LET tm.amt_sw = 'N'
#    END IF
     LET tm.amt_sw = 'Y'
##MOD-550092(end)
#    CALL cl_outnam('ammr120') RETURNING l_name
#    START REPORT r120_rep TO l_name
#    LET g_pageno = 0
#    FOREACH r120_curs1 INTO sr.*
#       IF SQLCA.sqlcode != 0 THEN 
#          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
#       END IF
#       FOR g_i = 1 TO 3
#           CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.mmg01
#                                         LET g_orderA[g_i]= g_x[15]
#                WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.mmg02
#                                         LET g_orderA[g_i]= g_x[16]
#                WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.mmg03
#                                         LET g_orderA[g_i]= g_x[17]
#                WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.mmg04
#                                         LET g_orderA[g_i]= g_x[18]
#                WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.mmg09
#                                         LET g_orderA[g_i]= g_x[19]
#                WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.mmg07
#                                         LET g_orderA[g_i]= g_x[19]
#                OTHERWISE LET l_order[g_i]  = '-'       
#                          LET g_orderA[g_i] = ' '          #清為空白
#           END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
#       IF cl_null(sr.mmg18) THEN LET sr.mmg18=0 END IF
#       IF cl_null(sr.mmg19) THEN LET sr.mmg19=0 END IF
#       IF cl_null(sr.mmg191) THEN LET sr.mmg191=0 END IF
#      IF tm.amt_sw = 'N' THEN
#         LET sr.mmg18  = ' '
#         LET sr.mmg191 = ' '
#      END IF
 
#       OUTPUT TO REPORT r120_rep(sr.*)
#    END FOREACH
 
#    FINISH REPORT r120_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #NO.FUN-750093
     IF g_zz05 = 'Y' THEN  
        CALL cl_wcchp(tm.wc,'mmg01,mmg02,mmg03,mmg04,mmg09')
             RETURNING tm.wc
     LET g_str = tm.wc
     END IF 
     LET g_str =tm.amt_sw,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                tm.t,";",g_azi04,";",tm2.u1,";",g_azi05,";",
                tm2.u2,";",tm2.u3,";",g_str
     CALL  cl_prt_cs1('ammr120','ammr120',l_sql,g_str) #NO.FUN-750093
#NO.FUN-750093 -------------------end 
END FUNCTION
 
#NO.FUN-750093 ----------begin
{REPORT r120_rep(sr)
DEFINE l_last_sw    LIKE type_file.chr1,                        #No.FUN-680100 VARCHAR(1)
       sr        RECORD order1    LIKE ima_file.ima01,          #No.FUN-680100 VARCHAR(40)#FUN-5B0105 20->40
                        order2    LIKE ima_file.ima01,          #No.FUN-680100 VARCHAR(40)#FUN-5B0105 20->40
                        order3    LIKE ima_file.ima01,          #No.FUN-680100 VARCHAR(40)#FUN-5B0105 20->40
                        mmg01     LIKE mmg_file.mmg01,   #開發案號
                        mmg02     LIKE mmg_file.mmg02,   #執行工單號
                        mmg04     LIKE mmg_file.mmg04,   #模治具料號
                        mmg05     LIKE mmg_file.mmg05,   #性質
                        mmi02     LIKE mmi_file.mmi02,   #說明
                        mmg21     LIKE mmg_file.mmg21,   #製品料號
                        mmg17     LIKE mmg_file.mmg17,   #完工比率
                        mmg18     LIKE mmg_file.mmg18,   #已耗費用
                        mmg19     LIKE mmg_file.mmg19,   #已耗工時
                        mmg191    LIKE mmg_file.mmg191,  #人工費用
                        mmg06     LIKE mmg_file.mmg06,   #開立日期
                        mmg07     LIKE mmg_file.mmg07,   #需求日期
                        mmg03     LIKE mmg_file.mmg03,   #類別
                        mmg08     LIKE mmg_file.mmg08,   #結案日期
                        mmg09     LIKE mmg_file.mmg09,   #需求部門
                        ima02     LIKE ima_file.ima02,   #品名
                        ima021    LIKE ima_file.ima021,  #規格
                        gem02     LIKE gem_file.gem02    #需求部門 
                        END RECORD,
                l_desc      LIKE type_file.chr4,         #No.FUN-680100 VARCHAR(04)
		l_mmg18     LIKE mmg_file.mmg18,
		l_mmg19     LIKE mmg_file.mmg19,
		l_amt191    LIKE mmg_file.mmg191
 
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr.mmg01,sr.order1,sr.order2,sr.order3
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT g_x[9] CLIPPED,
            g_orderA[1] CLIPPED,'-',
            g_orderA[2] CLIPPED,'-',
            g_orderA[3] CLIPPED,'-',l_str CLIPPED
      PRINT g_dash
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                     g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
                     g_x[41],g_x[42]
      PRINTX name=H2 g_x[43],g_x[44],g_x[45], g_x[46],g_x[47],
                     g_x[48],g_x[49]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   ON EVERY ROW
      CASE sr.mmg03
           WHEN '1'   LET l_desc=g_x[16] CLIPPED
           WHEN '2'   LET l_desc=g_x[17] CLIPPED
           WHEN '3'   LET l_desc=g_x[18] CLIPPED
           WHEN '4'   LET l_desc=g_x[19] CLIPPED
           OTHERWISE  LET l_desc='    '
      END CASE
      PRINTX name=D1 COLUMN g_c[31],sr.mmg01,
                     COLUMN g_c[32],sr.mmg02,
                     COLUMN g_c[33],sr.mmg04,
                     COLUMN g_c[34],sr.mmg06,
                     COLUMN g_c[35],sr.mmg05,
                     COLUMN g_c[36],sr.mmi02,
                     COLUMN g_c[37],sr.mmg21,
                     COLUMN g_c[38],sr.gem02,
                     COLUMN g_c[39],sr.mmg17 USING '##&.&&&',
                     COLUMN g_c[40],cl_numfor(sr.mmg18,40,g_azi04),
                     COLUMN g_c[41],cl_numfor(sr.mmg19,41,0),
                     COLUMN g_c[42],cl_numfor(sr.mmg191,42,g_azi04)
      PRINTX name=D2 COLUMN g_c[44],sr.mmg07,
                     COLUMN g_c[45],sr.mmg03,
                     COLUMN g_c[46],l_desc,
                     COLUMN g_c[47],sr.ima02,
                     COLUMN g_c[48],sr.ima021,
                     COLUMN g_c[49],sr.mmg08
 
   AFTER GROUP OF sr.order1
      IF tm.u[1,1] = 'Y' THEN
         LET l_mmg18=GROUP SUM(sr.mmg18)
         LET l_mmg19=GROUP SUM(sr.mmg19)
         LET l_amt191=GROUP SUM(sr.mmg191)
         IF cl_null(l_amt191) THEN LET l_amt191=0 END IF      
         PRINTX name=S1 COLUMN g_c[39],g_x[10] CLIPPED,
                        COLUMN g_c[40],cl_numfor(l_mmg18,40,g_azi05),
                        COLUMN g_c[41],cl_numfor(l_mmg19,41,0),
                        COLUMN g_c[42],cl_numfor(l_amt191,42,g_azi05)
         PRINTX name=D1 COLUMN g_c[40],g_dash[1,g_w[40]],
                        COLUMN g_c[41],g_dash[1,g_w[41]],
                        COLUMN g_c[42],g_dash[1,g_w[42]]
      END IF
 
   AFTER GROUP OF sr.order2
      IF tm.u[2,2] = 'Y' THEN
         LET l_mmg18=GROUP SUM(sr.mmg18)
         LET l_mmg19=GROUP SUM(sr.mmg19)
         LET l_amt191=GROUP SUM(sr.mmg191)
         IF cl_null(l_amt191) THEN LET l_amt191=0 END IF      
         PRINTX name=S1 COLUMN g_c[39],g_x[10] CLIPPED,
                        COLUMN g_c[40],cl_numfor(l_mmg18,40,g_azi05),
                        COLUMN g_c[41],cl_numfor(l_mmg19,41,0),
                        COLUMN g_c[42],cl_numfor(l_amt191,42,g_azi05)
         PRINTX name=D1 COLUMN g_c[40],g_dash[1,g_w[40]],
                        COLUMN g_c[41],g_dash[1,g_w[41]],
                        COLUMN g_c[42],g_dash[1,g_w[42]]
      END IF
 
   AFTER GROUP OF sr.order3
      IF tm.u[3,3] = 'Y' THEN
         LET l_mmg18=GROUP SUM(sr.mmg18)
         LET l_mmg19=GROUP SUM(sr.mmg19)
         LET l_amt191=GROUP SUM(sr.mmg191)
         IF cl_null(l_amt191) THEN LET l_amt191=0 END IF      
         PRINTX name=S1 COLUMN g_c[39],g_x[10] CLIPPED,
                        COLUMN g_c[40],cl_numfor(l_mmg18,40,g_azi05),
                        COLUMN g_c[41],cl_numfor(l_mmg19,41,0),
                        COLUMN g_c[42],cl_numfor(l_amt191,42,g_azi05)
         PRINTX name=D1 COLUMN g_c[40],g_dash[1,g_w[40]],
                        COLUMN g_c[41],g_dash[1,g_w[41]],
                        COLUMN g_c[42],g_dash[1,g_w[42]]
      END IF
 
   ON LAST ROW
      LET l_mmg18=SUM(sr.mmg18)
      LET l_mmg19=SUM(sr.mmg19)
      LET l_amt191=SUM(sr.mmg191)
      IF cl_null(l_amt191) THEN LET l_amt191=0 END IF
      PRINTX name=S1 COLUMN g_c[39],g_x[10] CLIPPED,
                     COLUMN g_c[40],cl_numfor(l_mmg18,40,g_azi05),
                     COLUMN g_c[41],cl_numfor(l_mmg19,41,0),
                     COLUMN g_c[42],cl_numfor(l_amt191,42,g_azi05)
      PRINTX name=D1 COLUMN g_c[40],g_dash[1,g_w[40]],
                     COLUMN g_c[41],g_dash[1,g_w[41]],
                     COLUMN g_c[42],g_dash[1,g_w[42]]
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'mmg01,mmg02,mmg03,mmg04,mmg09')
              RETURNING tm.wc
         PRINT g_dash
#TQC-630166
#        PRINT g_x[8] CLIPPED,tm.wc[001,132] CLIPPED 
         CALL cl_prt_pos_wc(tm.wc)
      ELSE
         SKIP 1 LINE
      END IF
      PRINT g_dash
## FUN-550114
      IF l_last_sw = 'n' THEN
         PRINT g_x[4] CLIPPED,
              # COLUMN 13,g_x[12] CLIPPED, COLUMN 43,g_x[13] CLIPPED,
              # COLUMN 71,g_x[14] CLIPPED, COLUMN 99,g_x[15] CLIPPED,
               COLUMN (g_len-9), g_x[6] CLIPPED  #TQC-5B0062
      ELSE
         PRINT g_x[4] CLIPPED,
              # COLUMN 13,g_x[12] CLIPPED, COLUMN 43,g_x[13] CLIPPED,
              # COLUMN 71,g_x[14] CLIPPED, COLUMN 99,g_x[15] CLIPPED,
               COLUMN (g_len-9), g_x[7] CLIPPED
      END IF
      PRINT ''
      IF l_last_sw = 'n' THEN
         IF g_memo_pagetrailer THEN
             PRINT g_x[12]
             PRINT g_memo
         ELSE
             PRINT
             PRINT
         END IF
      ELSE
             PRINT g_x[12]
             PRINT g_memo
      END IF
## END FUN-550114
 
END REPORT
}
#NO.FUN-750093  -------------end
