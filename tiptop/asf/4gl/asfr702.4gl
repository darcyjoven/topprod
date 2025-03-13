# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asfr702.4gl
# Descriptions...: 個人出勤狀況月報表
# Date & Author..: 99/07/02 By Kammy
# Modify.........: No.TQC-5B0023 05/11/07 By kim 報表列印'下一頁'位置超出報表寬度
# Modify.........: No.TQC-610080 06/03/03 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-670067 06/07/21 By Jackho voucher型報表轉template1
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/10/31 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.TQC-6B0002 06/11/21 By johnray 報表修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(800)
              yy      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
              mm      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
              more    LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
              END RECORD,
          g_shg   RECORD LIKE shg_file.*,
          g_str1  LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(200)
          g_str2  LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(200)
          g_str3  LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(200)
          g_no    LIKE type_file.num5           #No.FUN-680121 SMALLINT
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose        #No.FUN-680121 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway =ARG_VAL(5)
   LET g_copies =ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.yy = ARG_VAL(8)
   LET tm.mm = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
   DROP TABLE r702_tmp
  #No.FUN-680121-BEGIN
   CREATE TEMP TABLE r702_tmp(
    dept      LIKE gen_file.gen03,
    type      LIKE type_file.chr1,  
    day       LIKE type_file.num5,  
    hour      LIKE sge_file.sge03);
  #No.FUN-680121-END
   create unique index r702_tmp_01 on r712_tmp(dept,type,day);
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL asfr702_tm(0,0)
   ELSE
      CALL asfr702()
   END IF
   DROP TABLE r702_tmp
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION asfr702_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_flag         LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_cmd          LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(400)
          l_cnt1         LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_cnt2         LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_cnt3         LIKE type_file.num5           #No.FUN-680121 SMALLINT
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 15
   END IF
   OPEN WINDOW asfr702_w AT p_row,p_col
        WITH FORM "asf/42f/asfr702"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.yy= YEAR(g_today)
   LET tm.mm= MONTH(g_today)
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON gen03,gen01
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
      LET INT_FLAG = 0 CLOSE WINDOW asfr702_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.yy,tm.mm,tm.more  WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD mm
            IF tm.mm IS NULL OR tm.mm < 1 OR tm.mm >12 THEN
               LET tm.mm = MONTH(g_today)
               NEXT FIELD mm
            END IF
      AFTER FIELD more
         IF cl_null(tm.more) OR tm.more NOT MATCHES '[YN]' THEN
            NEXT FIELD more
         END IF
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER INPUT
 
         IF INT_FLAG THEN EXIT INPUT  END IF
         LET l_flag = 'N'
         SELECT COUNT(*) INTO l_cnt1 FROM shb_file
          WHERE YEAR(shb03)=tm.yy AND MONTH(shb03)=tm.mm
            AND shbconf = 'Y'    #FUN-A70095
         SELECT COUNT(*) INTO l_cnt2 FROM shg_file
          WHERE YEAR(shg01)=tm.yy AND MONTH(shg01)=tm.mm
         SELECT COUNT(*) INTO l_cnt3 FROM sge_file
          WHERE YEAR(sge01)=tm.yy AND MONTH(sge01)=tm.mm
         IF l_cnt1 = 0 AND l_cnt2=0 AND l_cnt3 = 0 THEN
            LET l_flag='Y'
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF l_flag='Y' THEN
      CALL cl_err('','mfg9089',1)
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW asfr702_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='asfr702'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr702','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                      " '",g_pdate CLIPPED,"'",
                      " '",g_towhom CLIPPED,"'",
                      " '",g_lang CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'",
                      " '",g_prtway CLIPPED,"'",
                      " '",g_copies CLIPPED,"'",
                      " '",tm.wc CLIPPED,"'" ,               #TQC-610080 
                      " '",tm.yy CLIPPED,"'" ,
                      " '",tm.mm CLIPPED,"'" ,
                      " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                      " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                      " '",g_template CLIPPED,"'"            #No.FUN-570264
           CALL cl_cmdat('asfr702',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL asfr702()
   ERROR ""
END WHILE
   CLOSE WINDOW asfr702_w
END FUNCTION
 
FUNCTION asfr702()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          i         LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_n       LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_hh      LIKE sge_file.sge03,
          l_mm      LIKE sge_file.sge03,
          l_nn      LIKE sge_file.sge03,
          l_day     LIKE type_file.dat,           #No.FUN-680121 DATE
          l_hour    LIKE sge_file.sge03,
          sr RECORD
             gen03  LIKE gen_file.gen03,           #部門
             gen01  LIKE gen_file.gen01,           #卡別
             type   LIKE type_file.chr1,           #No.FUN-680121 VARCHAR(1)
             hh     LIKE shb_file.shb032,          #時數
             dd     LIKE type_file.num5,           #No.FUN-680121 SMALLINT#日期
             sge03  LIKE sge_file.sge03
          END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-670067--begin
#     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'asfr702'         
#     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 190 END IF                    
#     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR                    
#No.FUN-670067--end 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #         LET tm.wc = tm.wc clipped," AND genuser = '",g_user,"'"
    #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND gengrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND gengrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('genuser', 'gengrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT gen03,gen01,'','','','','','',0 ",
                 " FROM gen_file",
                 " WHERE genacti = 'Y' ",
                 "   AND ", tm.wc CLIPPED,
                 " ORDER BY gen03,gen01 "
 
     PREPARE asfr702_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
           
     END IF
     DECLARE asfr702_curs1 CURSOR FOR asfr702_prepare1
     CALL cl_outnam('asfr702') RETURNING l_name
     START REPORT asfr702_rep TO l_name
     LET g_pageno = 0
     DELETE FROM r702_tmp
     FOREACH asfr702_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
 
          #------- 上班時數 (select shb_file,type='1')  ------
          LET sr.type='1' LET g_i = 1 LET l_hour=0 LET l_day=''
          DECLARE shb_cs CURSOR FOR
           SELECT SUM(shb032)/60,shb03 FROM shb_file
            WHERE shb04=sr.gen01
              AND YEAR(shb03)=tm.yy AND MONTH(shb03)=tm.mm
              AND shbconf = 'Y'     #FUN-A70095
            GROUP BY shb03 ORDER BY shb03
          FOREACH shb_cs INTO l_hour,l_day
              IF DAY(l_day) > g_i THEN
                 FOR i = g_i TO DAY(l_day)-1
                     LET sr.hh= 0
                     LET sr.dd = g_i
                     OUTPUT TO REPORT asfr702_rep(sr.*)
                     LET g_i = g_i + 1
                 END FOR
              END IF
              LET sr.hh =l_hour
              LET sr.dd =DAY(l_day)
              OUTPUT TO REPORT asfr702_rep(sr.*)
              LET g_i = g_i + 1
          END FOREACH
          IF cl_null(l_day) THEN LET l_n = 0 ELSE LET l_n=DAY(l_day) END IF
          IF l_n < 31 THEN
             LET l_n = l_n +1
             FOR i = l_n TO 31
                 LET sr.hh=0
                 LET sr.dd =i
                 OUTPUT TO REPORT asfr702_rep(sr.*)
             END FOR
          END IF
 
          #------- 轉稼時數 (select shg_file,type='2')  ------
          LET sr.type = '2' LET g_i = 1 LET l_hour=0 LET l_day=''
          DECLARE shg_cs CURSOR FOR
           SELECT SUM(shg05),shg01 FROM shg_file
            WHERE YEAR(shg01)=tm.yy AND MONTH(shg01)=tm.mm
              AND shg02 = sr.gen01
            GROUP BY shg01 ORDER BY shg01
          FOREACH shg_cs INTO l_hour,l_day
              IF DAY(l_day) > g_i THEN
                 FOR i = g_i TO DAY(l_day)-1
                     LET sr.hh = 0
                     LET sr.dd = g_i
                     OUTPUT TO REPORT asfr702_rep(sr.*)
                     LET g_i = g_i + 1
                 END FOR
              END IF
              LET sr.hh =l_hour
              LET sr.dd =DAY(l_day)
              OUTPUT TO REPORT asfr702_rep(sr.*)
              LET g_i = g_i + 1
          END FOREACH
          IF cl_null(l_day) THEN LET l_n = 0 ELSE LET l_n=DAY(l_day) END IF
          IF l_n < 31 THEN
             LET l_n = l_n +1
             FOR i = l_n TO 31
                 LET sr.hh=0
                 LET sr.dd =i
                 OUTPUT TO REPORT asfr702_rep(sr.*)
             END FOR
          END IF
 
          #------- 加班時數 (select sge_file,type='3')  ------
          LET sr.type = '3' LET g_i = 1 LET l_hour=0 LET l_day=''
          DECLARE sge_cs CURSOR FOR
           SELECT SUM(sge03),sge01 FROM sge_file
            WHERE YEAR(sge01)=tm.yy AND MONTH(sge01)=tm.mm
              AND sge02=sr.gen01
            GROUP BY sge01 ORDER BY sge01
          FOREACH sge_cs INTO l_hour,l_day
              IF DAY(l_day) > g_i THEN
                 FOR i = g_i TO DAY(l_day)-1
                     LET sr.sge03=0
                     LET sr.hh= 0
                     LET sr.dd = g_i
                     OUTPUT TO REPORT asfr702_rep(sr.*)
                     LET g_i = g_i + 1
                 END FOR
              END IF
              LET sr.sge03=l_hour
              LET sr.hh=0
              LET sr.dd =DAY(l_day)
              OUTPUT TO REPORT asfr702_rep(sr.*)
              LET g_i = g_i + 1
          END FOREACH
          IF cl_null(l_day) THEN LET l_n = 0 ELSE LET l_n = DAY(l_day) END IF
          IF l_n < 31 THEN
             LET l_n = l_n + 1
             FOR i = l_n TO 31
                 LET sr.sge03=0
                 LET sr.hh=0
                 LET sr.dd=i
                 OUTPUT TO REPORT asfr702_rep(sr.*)
             END FOR
          END IF
     END FOREACH
     FINISH REPORT asfr702_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT asfr702_rep(sr)
   DEFINE 
#No.FUN-670067--begin
          l_dept           LIKE gem_file.gem02,          #No.FUN-680121 VARCHAR(30)
          l_num            LIKE gen_file.gen02,          #No.FUN-680121 VARCHAR(30)
          l_name           LIKE gen_file.gen02,          #No.FUN-680121 VARCHAR(30)
          l_hours          LIKE gen_file.gen02,          #No.FUN-680121 VARCHAR(30)
          li_flag  DYNAMIC ARRAY OF RECORD 
             flag1         LIKE type_file.num5,          #No.FUN-680121  SMALLINT
             flag2         LIKE type_file.num5,          #No.FUN-680121  SMALLINT     
             flag3         LIKE type_file.num5           #No.FUN-680121  SMALLINT     
                       END RECORD,                       
          li_sum  DYNAMIC ARRAY OF RECORD 
             sum1         LIKE type_file.num5,          #No.FUN-680121  SMALLINT 
             sum2         LIKE type_file.num5,          #No.FUN-680121  SMALLINT    
             sum3         LIKE type_file.num5           #No.FUN-680121  SMALLINT     
                       END RECORD,                       
          li_int          LIKE type_file.num5,          #No.FUN-680121  SMALLINT            
#No.FUN-670067--end
          l_last_sw        LIKE type_file.chr1,         #No.FUN-680121  VARCHAR(1)
          l_gem02          LIKE gem_file.gem02,
          l_gen02          LIKE gen_file.gen02,
          l_hour1          LIKE sge_file.sge03,
          l_hour2          LIKE sge_file.sge03,
          l_hour3          LIKE sge_file.sge03,
          l_mm             LIKE sge_file.sge03,
          l_nn             LIKE sge_file.sge03,
          type_sum1        LIKE sge_file.sge03,
          type_sum2        LIKE sge_file.sge03,
          type_sum3        LIKE sge_file.sge03,
          sum_1            LIKE sge_file.sge03,
          sum_2            LIKE sge_file.sge03,
          sum_3            LIKE sge_file.sge03,
          l_over_h         LIKE sge_file.sge03,
          l_over_sum       LIKE sge_file.sge03,
          sr RECORD
             gen03         LIKE gen_file.gen03,           #部門
             gen01         LIKE gen_file.gen01,           #卡別
             type          LIKE type_file.chr1,           #No.FUN-680121 VARCHAR(1)
             hh            LIKE shb_file.shb032,          #時數
             dd            LIKE type_file.num5,           #No.FUN-680121 SMALLINT
             sge03  LIKE sge_file.sge03
          END RECORD,
          l_flag1          LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_flag2          LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_flag3          LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_i              LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_n              LIKE type_file.num5           #No.FUN-680121 SMALLINT
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER EXTERNAL BY sr.gen03,sr.gen01,sr.dd,sr.type
# ORDER EXTERNAL BY sr.gen03,sr.type
  FORMAT
   PAGE HEADER
#No.FUN-670067--begin
#      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#      PRINT ' '
#      PRINT (g_len-18)/2 SPACES,g_x[1] CLIPPED
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#            COLUMN (g_len-14)/2,g_x[09] CLIPPED, tm.yy USING'####','/',
#                   tm.mm USING'##',
#            COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '&&&'
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED                                                   
       LET g_pageno = g_pageno + 1                                                                                                   
       LET pageno_total = PAGENO USING '<<<',"/pageno"                                                                               
       PRINT g_head CLIPPED,pageno_total                                                                                             
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#No.FUN-670067--end
      PRINT
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'n'
    
#No.FUN-670067--begin                                                                                                       
#   BEFORE GROUP OF sr.gen03                                                                                                
           SKIP TO TOP OF PAGE                                                                                                   
#      PRINT g_x[11] CLIPPED,sr.gen03,' ',l_gem02                                                                           
#No.FUN-670067--end                                                                                                         
       LET sum_1=0 LET sum_2=0 LET sum_3=0
       PRINT g_x[31]; 
       PRINT g_x[64];
       FOR l_i=1 TO 31  
           LET g_zaa[31+l_i].zaa08 = l_i
           PRINT g_x[31+l_i];   
       END FOR   
       PRINT g_x[63]
       PRINT g_dash1
       SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.gen03                                                          
       LET l_dept = g_x[11] CLIPPED,' ',sr.gen03 CLIPPED
       PRINT COLUMN g_c[31],l_dept CLIPPED;          #部門
       LET l_dept = l_gem02 CLIPPED
       PRINT COLUMN g_c[64],l_dept CLIPPED          
       PRINT
 
#No.FUN-670067--begin
#   BEFORE GROUP OF sr.gen01
#      PRINT ' '
#      NEED 5 LINE
#      PRINT g_x[12] CLIPPED, sr.gen01,
#            COLUMN 21,g_x[13] CLIPPED,l_gen02
#      PRINT g_x[14] CLIPPED;                             
#      FOR l_i= 1 TO 31 PRINT '  ',l_i USING '&&','  '; END FOR
#      PRINT g_x[25] CLIPPED
  
   BEFORE GROUP OF sr.gen01
     FOR l_i=1 TO 31
         LET li_sum[l_i].sum1=0
         LET li_sum[l_i].sum2=0
         LET li_sum[l_i].sum3=0
     END FOR 
     LET sum_1=0     LET sum_2=0     LET sum_3=0                                                                                   
     LET type_sum1=0 LET type_sum2=0 LET type_sum3=0                                                                               
     LET l_flag1=0   LET l_flag2=0   LET l_flag3=0                                                                                 
     LET g_str1=''                                                                                                
     LET g_str2=''                                                                                                
     LET g_str3=''
     LET li_int = 1
     
  AFTER GROUP OF sr.type
     CASE sr.type                                                                                                                  
        WHEN '1'  #------------------------上班時數-------------------------------
           IF li_int > 31 THEN LET li_int = 1 END IF
           LET li_flag[li_int].flag1 =  sr.hh USING '&.&&'
           LET type_sum1 = type_sum1 + sr.hh
        WHEN '2'  #------------------------轉嫁時數-------------------------------
           IF li_int > 31 THEN LET li_int = 1 END IF
           LET li_flag[li_int].flag2 =  sr.hh USING '&.&&'
           LET type_sum2 = type_sum2 + sr.hh
     END CASE
       IF sr.type='1' OR sr.type='2' THEN                                                                                            
         SELECT COUNT(*) INTO l_n FROM r702_tmp                                                                                     
          WHERE r702_tmp.dept=sr.gen03 AND r702_tmp.type=sr.type                                                                    
            AND r702_tmp.day=sr.dd                                                                                                  
         IF l_n > 0 THEN                                                                                                            
            UPDATE r702_tmp SET hour=(hour+sr.hh)                                                                                   
             WHERE r702_tmp.dept=sr.gen03 AND r702_tmp.type=sr.type                                                                 
               AND r702_tmp.day=sr.dd                                                                                               
         ELSE                                                                                                                       
            INSERT INTO r702_tmp VALUES(sr.gen03,sr.type,sr.dd,sr.hh)                                                               
         END IF                                                                                                                     
       END IF
 
   AFTER GROUP OF sr.dd
      IF sr.type ='3' THEN
         IF li_int > 31 THEN LET li_int = 1 END IF
         LET li_flag[li_int].flag3 =  sr.hh
         LET type_sum3 = type_sum3 + sr.hh
      END IF
      LET li_int = li_int + 1
      SELECT COUNT(*) INTO l_n FROM r702_tmp                                                                                  
             WHERE r702_tmp.dept=sr.gen03 AND r702_tmp.type=sr.type                                                                 
               AND r702_tmp.day=sr.dd                                                                                               
      IF l_n > 0 THEN                                                                                                         
         UPDATE r702_tmp SET hour=(hour+sr.hh)                                                                                
                WHERE r702_tmp.dept=sr.gen03 AND r702_tmp.type=sr.type                                                              
                AND r702_tmp.day=sr.dd                                                                                            
      ELSE                                                                                                                    
         INSERT INTO r702_tmp VALUES(sr.gen03,sr.type,sr.dd,sr.hh)                                                            
      END IF
    
   AFTER GROUP OF sr.gen01                                                                                                          
      LET g_str1=type_sum1 USING '&&.##'                                                                        
      LET g_str2=type_sum2 USING '&&.##'                                                                        
      LET g_str3=type_sum3 USING '&&.##'                                                                        
      LET l_num = g_x[12] CLIPPED,' ',sr.gen01
      PRINT COLUMN g_c[31],l_num;             #卡別
      #------------------------上班時數-------------------------------
      LET l_num = g_x[15] CLIPPED
      PRINT COLUMN g_c[64],l_num;
      PRINT COLUMN g_c[32],li_flag[1].flag1 USING '##&.&&',
            COLUMN g_c[33],li_flag[2].flag1 USING '##&.&&',
            COLUMN g_c[34],li_flag[3].flag1 USING '##&.&&',
            COLUMN g_c[35],li_flag[4].flag1 USING '##&.&&',
            COLUMN g_c[36],li_flag[5].flag1 USING '##&.&&',
            COLUMN g_c[37],li_flag[6].flag1 USING '##&.&&',
            COLUMN g_c[38],li_flag[7].flag1 USING '##&.&&',
            COLUMN g_c[39],li_flag[8].flag1 USING '##&.&&',
            COLUMN g_c[40],li_flag[9].flag1 USING '##&.&&',
            COLUMN g_c[41],li_flag[10].flag1 USING '##&.&&',
            COLUMN g_c[42],li_flag[11].flag1 USING '##&.&&',
            COLUMN g_c[43],li_flag[12].flag1 USING '##&.&&',
            COLUMN g_c[44],li_flag[13].flag1 USING '##&.&&',
            COLUMN g_c[45],li_flag[14].flag1 USING '##&.&&',
            COLUMN g_c[46],li_flag[15].flag1 USING '##&.&&',
            COLUMN g_c[47],li_flag[16].flag1 USING '##&.&&',
            COLUMN g_c[48],li_flag[17].flag1 USING '##&.&&',
            COLUMN g_c[49],li_flag[18].flag1 USING '##&.&&',
            COLUMN g_c[50],li_flag[19].flag1 USING '##&.&&',
            COLUMN g_c[51],li_flag[20].flag1 USING '##&.&&',
            COLUMN g_c[52],li_flag[21].flag1 USING '##&.&&',
            COLUMN g_c[53],li_flag[22].flag1 USING '##&.&&',
            COLUMN g_c[54],li_flag[23].flag1 USING '##&.&&',
            COLUMN g_c[55],li_flag[24].flag1 USING '##&.&&',
            COLUMN g_c[56],li_flag[25].flag1 USING '##&.&&',
            COLUMN g_c[57],li_flag[26].flag1 USING '##&.&&',
            COLUMN g_c[58],li_flag[27].flag1 USING '##&.&&',
            COLUMN g_c[59],li_flag[28].flag1 USING '##&.&&',
            COLUMN g_c[60],li_flag[29].flag1 USING '##&.&&',
            COLUMN g_c[61],li_flag[30].flag1 USING '##&.&&',
            COLUMN g_c[62],li_flag[31].flag1 USING '##&.&&';
      FOR l_i=1 TO 31
          LET li_sum[l_i].sum1=li_sum[l_i].sum1+li_flag[l_i].flag1
      END FOR
      PRINT COLUMN g_c[63],type_sum1 USING '###&&.&&'                                                                                                                 
      #------------------------轉嫁時數-------------------------------
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.gen01
      LET l_name = g_x[13] CLIPPED,' ',l_gen02
      PRINT COLUMN g_c[31],l_name;             #員工姓名
      LET l_name = g_x[16] CLIPPED
      PRINT COLUMN g_c[64],l_name;                                                               
      PRINT COLUMN g_c[32],li_flag[1].flag2 USING '##&.&&',
            COLUMN g_c[33],li_flag[2].flag2 USING '##&.&&',
            COLUMN g_c[34],li_flag[3].flag2 USING '##&.&&',
            COLUMN g_c[35],li_flag[4].flag2 USING '##&.&&',
            COLUMN g_c[36],li_flag[5].flag2 USING '##&.&&',
            COLUMN g_c[37],li_flag[6].flag2 USING '##&.&&',
            COLUMN g_c[38],li_flag[7].flag2 USING '##&.&&',
            COLUMN g_c[39],li_flag[8].flag2 USING '##&.&&',
            COLUMN g_c[40],li_flag[9].flag2 USING '##&.&&',
            COLUMN g_c[41],li_flag[10].flag2 USING '##&.&&',
            COLUMN g_c[42],li_flag[11].flag2 USING '##&.&&',
            COLUMN g_c[43],li_flag[12].flag2 USING '##&.&&',
            COLUMN g_c[44],li_flag[13].flag2 USING '##&.&&',
            COLUMN g_c[45],li_flag[14].flag2 USING '##&.&&',
            COLUMN g_c[46],li_flag[15].flag2 USING '##&.&&',
            COLUMN g_c[47],li_flag[16].flag2 USING '##&.&&',
            COLUMN g_c[48],li_flag[17].flag2 USING '##&.&&',
            COLUMN g_c[49],li_flag[18].flag2 USING '##&.&&',
            COLUMN g_c[50],li_flag[19].flag2 USING '##&.&&',
            COLUMN g_c[51],li_flag[20].flag2 USING '##&.&&',
            COLUMN g_c[52],li_flag[21].flag2 USING '##&.&&',
            COLUMN g_c[53],li_flag[22].flag2 USING '##&.&&',
            COLUMN g_c[54],li_flag[23].flag2 USING '##&.&&',
            COLUMN g_c[55],li_flag[24].flag2 USING '##&.&&',
            COLUMN g_c[56],li_flag[25].flag2 USING '##&.&&',
            COLUMN g_c[57],li_flag[26].flag2 USING '##&.&&',
            COLUMN g_c[58],li_flag[27].flag2 USING '##&.&&',
            COLUMN g_c[59],li_flag[28].flag2 USING '##&.&&',
            COLUMN g_c[60],li_flag[29].flag2 USING '##&.&&',
            COLUMN g_c[61],li_flag[30].flag2 USING '##&.&&',
            COLUMN g_c[62],li_flag[31].flag2 USING '##&.&&';
      FOR l_i=1 TO 31
          LET li_sum[l_i].sum2=li_sum[l_i].sum2+li_flag[l_i].flag2
      END FOR
      PRINT COLUMN g_c[63],g_str2 USING '###&&.&&'                                                                                                                  
      #------------------------加班時數-------------------------------
      LET l_name = ' '
      PRINT COLUMN g_c[31],l_name;              #加班時數
      LET l_name = g_x[17] CLIPPED
      PRINT COLUMN g_c[64],l_name;              #加班時數
      PRINT COLUMN g_c[32],li_flag[1].flag3 USING '##&.&&',
            COLUMN g_c[33],li_flag[2].flag3 USING '##&.&&',
            COLUMN g_c[34],li_flag[3].flag3 USING '##&.&&',
            COLUMN g_c[35],li_flag[4].flag3 USING '##&.&&',
            COLUMN g_c[36],li_flag[5].flag3 USING '##&.&&',
            COLUMN g_c[37],li_flag[6].flag3 USING '##&.&&',
            COLUMN g_c[38],li_flag[7].flag3 USING '##&.&&',
            COLUMN g_c[39],li_flag[8].flag3 USING '##&.&&',
            COLUMN g_c[40],li_flag[9].flag3 USING '##&.&&',
            COLUMN g_c[41],li_flag[10].flag3 USING '##&.&&',
            COLUMN g_c[42],li_flag[11].flag3 USING '##&.&&',
            COLUMN g_c[43],li_flag[12].flag3 USING '##&.&&',
            COLUMN g_c[44],li_flag[13].flag3 USING '##&.&&',
            COLUMN g_c[45],li_flag[14].flag3 USING '##&.&&',
            COLUMN g_c[46],li_flag[15].flag3 USING '##&.&&',
            COLUMN g_c[47],li_flag[16].flag3 USING '##&.&&',
            COLUMN g_c[48],li_flag[17].flag3 USING '##&.&&',
            COLUMN g_c[49],li_flag[18].flag3 USING '##&.&&',
            COLUMN g_c[50],li_flag[19].flag3 USING '##&.&&',
            COLUMN g_c[51],li_flag[20].flag3 USING '##&.&&',
            COLUMN g_c[52],li_flag[21].flag3 USING '##&.&&',
            COLUMN g_c[53],li_flag[22].flag3 USING '##&.&&',
            COLUMN g_c[54],li_flag[23].flag3 USING '##&.&&',
            COLUMN g_c[55],li_flag[24].flag3 USING '##&.&&',
            COLUMN g_c[56],li_flag[25].flag3 USING '##&.&&',
            COLUMN g_c[57],li_flag[26].flag3 USING '##&.&&',
            COLUMN g_c[58],li_flag[27].flag3 USING '##&.&&',
            COLUMN g_c[59],li_flag[28].flag3 USING '##&.&&',
            COLUMN g_c[60],li_flag[29].flag3 USING '##&.&&',
            COLUMN g_c[61],li_flag[30].flag3 USING '##&.&&',
            COLUMN g_c[62],li_flag[31].flag3 USING '##&.&&';
       FOR l_i=1 TO 31
          LET li_sum[l_i].sum3=li_sum[l_i].sum3+li_flag[l_i].flag3
       END FOR
      PRINT COLUMN g_c[63],g_str3 USING '###&&.&&'                                                                                                                  
 
#     LET sum_1=0     LET sum_2=0     LET sum_3=0
#     LET type_sum1=0 LET type_sum2=0 LET type_sum3=0
#     LET l_flag1=0   LET l_flag2=0   LET l_flag3=0
#     LET g_str1=g_x[15] CLIPPED
#     LET g_str2=g_x[16] CLIPPED
#     LET g_str3=g_x[17] CLIPPED
 
#
#  AFTER GROUP OF sr.type
#     CASE sr.type
#          WHEN '1' LET l_flag1 = l_flag1 + 1
#                   IF l_flag1 = 1 THEN
#                      LET g_str1 = g_str1 CLIPPED,sr.hh USING '&.##',' '
#                   ELSE
#                      LET g_str1 = g_str1 CLIPPED,'  ',sr.hh USING '&.##'
#                   END IF
#                   LET type_sum1 = type_sum1 + sr.hh
 
#          WHEN '2' LET l_flag2 = l_flag2 + 1
#                   IF l_flag2 = 1 THEN
#                      LET g_str2 = g_str2 CLIPPED,sr.hh USING '&.##',' '
#                   ELSE
#                      LET g_str2 = g_str2 CLIPPED,'  ',sr.hh USING '&.##'
#                   END IF
#                   LET type_sum2 = type_sum2 + sr.hh
#     END CASE
#     IF sr.type='1' OR sr.type='2' THEN
#        SELECT COUNT(*) INTO l_n FROM r702_tmp
#         WHERE r702_tmp.dept=sr.gen03 AND r702_tmp.type=sr.type
#           AND r702_tmp.day=sr.dd
#        IF l_n > 0 THEN
#           UPDATE r702_tmp SET hour=(hour+sr.hh)
#            WHERE r702_tmp.dept=sr.gen03 AND r702_tmp.type=sr.type
#              AND r702_tmp.day=sr.dd
#        ELSE
#           INSERT INTO r702_tmp VALUES(sr.gen03,sr.type,sr.dd,sr.hh)
#        END IF
#     END IF
 
#   AFTER GROUP OF sr.dd
#     IF sr.type ='3' THEN
#           LET l_flag3 = l_flag3 + 1
#           LET l_mm = GROUP SUM(sr.hh) WHERE sr.type='1'
#           LET l_nn = GROUP SUM(sr.hh) WHERE sr.type='2'
#           LET sr.hh= l_mm + l_nn - sr.sge03
#           IF l_flag3 = 1 THEN
#              LET g_str3 = g_str3 CLIPPED,sr.hh USING '&.##',' '
#           ELSE
#              LET g_str3 = g_str3 CLIPPED,'  ',sr.hh USING '&.##'
#           END IF
#           LET type_sum3 = type_sum3 + sr.hh
#           SELECT COUNT(*) INTO l_n FROM r702_tmp
#            WHERE r702_tmp.dept=sr.gen03 AND r702_tmp.type=sr.type
#              AND r702_tmp.day=sr.dd
#           IF l_n > 0 THEN
#              UPDATE r702_tmp SET hour=(hour+sr.hh)
#               WHERE r702_tmp.dept=sr.gen03 AND r702_tmp.type=sr.type
#                 AND r702_tmp.day=sr.dd
#           ELSE
#              INSERT INTO r702_tmp VALUES(sr.gen03,sr.type,sr.dd,sr.hh)
#           END IF
#     END IF
 
#  AFTER GROUP OF sr.gen01
#     LET g_str1=g_str1 CLIPPED,'  ',type_sum1 USING '&&.##'
#     LET g_str2=g_str2 CLIPPED,'  ',type_sum2 USING '&&.##'
#     LET g_str3=g_str3 CLIPPED,'  ',type_sum3 USING '&&.##'
#     PRINT g_str1
#     PRINT g_str2
#     PRINT g_str3
#No.FUN-670067--end
 
 AFTER GROUP OF sr.gen03                             #依部門小計
     PRINT 
#No.FUN-670067--begin
#     PRINT g_x[21] CLIPPED
     LET l_hours = g_x[21] CLIPPED
     PRINT COLUMN g_c[31],l_hours;
     LET l_hours = g_x[18] CLIPPED
     PRINT COLUMN g_c[64],l_hours;
   #------------------------上班時數-------------------------------
      LET l_hour1=0
      FOR l_i=1 TO 31
          LET l_hour1=l_hour1+li_sum[l_i].sum1
          PRINT COLUMN g_c[31+l_i],l_hour1 USING '##&.&&';
          LET sum_1=sum_1 + l_hour1
      END FOR
#     FOR l_i=1 TO 31
#         SELECT SUM(hour) INTO l_hour1 FROM r702_tmp
#          WHERE r702_tmp.dept=sr.gen03 AND r702_tmp.type='1'
#           AND r702_tmp.day=l_i
    #     PRINT l_hour1 USING '&.##','  ';
#         PRINT COLUMN g_c[31+l_i],l_hour1 USING '&.##';
#         LET sum_1=sum_1 + l_hour1
#     END FOR
#    PRINT sum_1 USING '&&.##'            #上班時數合計
     PRINT COLUMN g_c[63],sum_1 USING '###&&.##'
    #------------------------轉稼時數-------------------------------
     LET l_hours = ' '
     PRINT COLUMN g_c[31],l_hours;
      LET l_hours=g_x[19] CLIPPED
      PRINT COLUMN g_c[64],l_hours;
      LET l_hour2=0
      FOR l_i=1 TO 31
          LET l_hour2=l_hour2+li_sum[l_i].sum2
          PRINT COLUMN g_c[31+l_i],l_hour2 USING '##&.&&';
          LET sum_2=sum_2 + l_hour2
      END FOR
#      PRINT g_x[19] CLIPPED ;
#     FOR l_i=1 TO 31
#        SELECT SUM(hour) INTO l_hour2 FROM r702_tmp
#          WHERE r702_tmp.dept=sr.gen03 AND r702_tmp.type='2'
#           AND r702_tmp.day=l_i
#         PRINT l_hour2 USING '&.##','  ';
#         PRINT g_c[31+l_i],l_hour2 USING '&.##';  
#       LET sum_2=sum_2 + l_hour2
#     END FOR
#      PRINT sum_2 USING '&&.##'            #轉嫁時數合計
      PRINT COLUMN g_c[63],sum_2 USING '###&&.##'            #轉嫁時數合計
    #------------------------加班時數-------------------------------
     LET l_hours = ' '
     PRINT COLUMN g_c[31],l_hours;
      LET l_hours = g_x[20] CLIPPED
      PRINT COLUMN g_c[64],l_hours;
      LET l_hour3=0
      FOR l_i=1 TO 31
          LET l_hour3=l_hour3+li_sum[l_i].sum3
          PRINT COLUMN g_c[31+l_i],l_hour3 USING '##&.&&';
          LET sum_3=sum_3 + l_hour3
      END FOR
#     LET l_hours='             ',g_x[20] CLIPPED ;
#     PRINT COLUMN g_c[31],l_hours;
    # FOR l_i=1 TO 31
    #     SELECT SUM(hour) INTO l_hour3 FROM r702_tmp
    #      WHERE r702_tmp.dept=sr.gen03 AND r702_tmp.type='3'
    #       AND r702_tmp.day=l_i
#         PRINT l_hour3 USING '&.##','  ';
    #     PRINT COLUMN g_c[31+l_i],l_hour3 USING '&.##';
    #     LET sum_3=sum_3 + l_hour3
    # END FOR
#      PRINT sum_3 USING '&&.##'            #轉嫁時數合計
      PRINT COLUMN g_c[63],sum_3 USING '###&&.##' 
 
   ON LAST ROW
      LET sum_1 = 0 LET sum_2 = 0 LET sum_3 = 0
      PRINT
      LET l_hours = g_x[25]
      PRINT COLUMN g_c[31],l_hours;
      LET l_hours = g_x[22] CLIPPED
      PRINT COLUMN g_c[64],l_hours;
      #------------------------上班時數-------------------------------
      FOR l_i=1 TO 31
          SELECT SUM(hour) INTO l_hour1 FROM r702_tmp
           WHERE r702_tmp.type='1' AND r702_tmp.day=l_i
   #      PRINT l_hour1 USING '&.##','  ';
          PRINT COLUMN g_c[31+l_i],l_hour1 USING '##&.&&';
          LET sum_1=sum_1 + l_hour1
      END FOR
#      PRINT sum_1 USING '&&.##'                    #上班時數合計
      PRINT COLUMN g_c[63],sum_1 USING '###&&.##' 
     #------------------------轉稼時數-------------------------------
#      PRINT g_x[23] CLIPPED ;
      LET l_hours = ' '
      PRINT COLUMN g_c[31],l_hours;
      LET l_hours=g_x[23] CLIPPED
      PRINT COLUMN g_c[64],l_hours;
      FOR l_i=1 TO 31
          SELECT SUM(hour) INTO l_hour2 FROM r702_tmp
           WHERE r702_tmp.type='2' AND r702_tmp.day=l_i
#          PRINT l_hour2 USING '&.##','  ';
          PRINT COLUMN g_c[31+l_i],l_hour2 USING '##&.&&';
          LET sum_2=sum_2 + l_hour2
      END FOR
#      PRINT sum_2 USING '&&.##'            #轉嫁時數合計
      PRINT COLUMN g_c[63],sum_2 USING '###&&.##'
      #------------------------加班時數-------------------------------
#      PRINT g_x[24] CLIPPED ;
      LET l_hours = ' '
      PRINT COLUMN g_c[31],l_hours;
      LET l_hours=g_x[24] CLIPPED
      PRINT COLUMN g_c[64],l_hours;
      FOR l_i=1 TO 31
          SELECT SUM(hour) INTO l_hour3 FROM r702_tmp
           WHERE r702_tmp.type='3' AND r702_tmp.day=l_i
#          PRINT l_hour3 USING '&.##','  ';
          PRINT COLUMN g_c[31+l_i],l_hour3 USING '##&.&&';
          LET sum_3=sum_3 + l_hour3
      END FOR
#      PRINT sum_3 USING '&&.##'            #加班時數合計
      PRINT COLUMN g_c[63],sum_3 USING '###&&.##'
#No.FUN-670067--end
      PRINT g_dash[1,g_len]
#No.TQC-6B0002 -- begin --
#      PRINT COLUMN (g_len-9),g_x[7] #TQC-5B0023
#      PRINT COLUMN 01,g_x[4]        #FUN-670067
      PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#No.TQC-6B0002 -- end --
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]
#         PRINT COLUMN (g_len-9),g_x[6] #TQC-5B0023   #No.TQC-6B0002
         PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
         SKIP 2 LINE
      END IF
END REPORT
#Patch....NO.TQC-610037 <001> #
