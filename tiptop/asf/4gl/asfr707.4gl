# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: asfr707.4gl
# Descriptions...: 機種/工單資料表
# Date & Author..: 99/05/24 By Iceman
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: NO.FUN-510029 05/01/13 By Carol 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.TQC-5C0026 05/12/06 By kevin 欄位沒對齊
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0102 06/11/15 By johnray 報表修改
# Modify.........: No.TQC-940163 09/05/11 By mike l_shb111,l_shb113回傳不唯一    
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.FUN-A60076 10/06/22 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   # Print condition RECORD
              wc     STRING,           # Where condition  #TQC-630166
              more   LIKE type_file.chr1         #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
 
MAIN
   OPTIONS
       INPUT NO WRAP,
       FIELD ORDER FORM
   DEFER INTERRUPT                 # Supress DEL key function
 
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
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL r707_tm(0,0)        # Input print condition
      ELSE CALL asfr707()        # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r707_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680121 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(400)
 
   OPEN WINDOW r707_w WITH FORM "asf/42f/asfr707"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   DISPLAY BY NAME tm.more # Condition
   CONSTRUCT BY NAME tm.wc ON sfb05
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
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r707_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM 
   END IF
   IF tm.wc= " 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF
   DISPLAY BY NAME tm.more # Condition
   INPUT BY NAME tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
             NEXT FIELD more
         END IF
         IF tm.more = 'Y' THEN
             CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
             RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
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
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r707_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM 
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file  WHERE zz01='asfr707'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr707','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('asfr707',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r707_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   CALL cl_wait()
   CALL asfr707()
   ERROR ""
END WHILE
   CLOSE WINDOW r707_w
END FUNCTION
 
FUNCTION asfr707()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
#         l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #TQC-630166         #No.FUN-680121 VARCHAR(1100)
          l_sql     STRING,                       # RDSQL STATEMENT  #TQC-630166
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_cnt     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
         #l_shb111  LIKE shb_file.shb111,         #TQC-940163  
         #l_shb113  LIKE shb_file.shb113,         #TQC-940163  
          ss        LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_s1      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          i         LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          j         LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          sr               RECORD
                           sfb05  LIKE sfb_file.sfb05,  #產品編號
                           ima02  LIKE ima_file.ima02,  #料品名稱
                           ima021 LIKE ima_file.ima021,  #規格
                           sfb01  LIKE sfb_file.sfb01,  #工單編號
                           sfb08  LIKE sfb_file.sfb08,  #生產量
                           sfb09  LIKE sfb_file.sfb09,  #入庫量
                           sfb12  LIKE sfb_file.sfb12,  #報廢量
                           ecm03  LIKE ecm_file.ecm03,  #op#
                           ecm012 LIKE ecm_file.ecm012, #FUN-A60076 製程段號
                           ecm45  LIKE ecm_file.ecm45,  #作業編號
                           ecm01  LIKE ecm_file.ecm01,
                           ecm14  LIKE ecm_file.ecm14,
                           shb111 LIKE shb_file.shb111, #TQC-940163 
                           shb113 LIKE shb_file.shb113, #TQC-940163  
#                          a      LIKE ima_file.ima26,  #No.FUN-680121 DEC(15,3)#實工
#                          b      LIKE ima_file.ima26,  #No.FUN-680121 DEC(15,3)#標工
#                          c      LIKE ima_file.ima26   #No.FUN-680121 DEC(15,3)#效率
                           a      LIKE type_file.num15_3,  ###GP5.2  #NO.FUN-A20044
                           b      LIKE type_file.num15_3,  ###GP5.2  #NO.FUN-A20044
                           c      LIKE type_file.num15_3   ###GP5.2  #NO.FUN-A20044
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND sfbuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
     #End:FUN-980030
 
     LET l_sql = " SELECT sfb05,ima02,ima021,sfb01,sfb08,sfb09,sfb12,",
                #"        ecm03,ecm45,ecm01,ecm14,'','',''",         #TQC-940163  
                #"        ecm03,ecm45,ecm01,ecm14,shb111,shb113,'','',''", #TQC-940163   #FUN-A60076 mark
                 "        ecm03,ecm012,ecm45,ecm01,ecm14,shb111,shb113,SUM(shb032),SUM((ecm14/60)*(shb111+shb113)),''",        #FUN-A60076   
                 " FROM sfb_file,ecm_file,shb_file,OUTER ima_file",
                 " WHERE sfb01 = ecm01",                      #巳產生製程追蹤檔
                 "   AND ima_file.ima01 = sfb_file.sfb05",
                 "   AND shb05 = sfb01 AND sfb87!='X' ",
                 "   AND shbconf = 'Y' ",    #FUN-A70095
                 "   AND ",tm.wc CLIPPED,
                 " GROUP BY sfb05,ima02,ima021,sfb01,sfb08,sfb09,sfb12, ",                      #FUN-A60076
                 "          ecm03,ecm012,ecm45,ecm01,ecm14,shb111,shb113"                       #FUN-A60076      
     PREPARE r707_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
           
     END IF
     DECLARE r707_cs1 CURSOR FOR r707_prepare1
     CALL cl_outnam('asfr707') RETURNING l_name
     START REPORT r707_rep TO l_name
     LET g_pageno = 0
     FOREACH r707_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
#No.FUN-A60076 --------------mark------------------
#        SELECT SUM(shb032) INTO sr.a FROM shb_file,ecm_file
#         WHERE shb05=sr.sfb01
#           AND shb06=sr.ecm03
#           AND ecm01 = shb05
#         GROUP BY shb05,shb06
#No.FUN-A60076 ------------mark-------------------
       IF sr.a IS NULL THEN LET sr.a=0 END IF
#TQC-940163 -----start     
      #SELECT shb111,shb113 INTO l_shb111,l_shb113
      #  FROM shb_file
      # WHERE shb05 = sr.sfb01
      #LET sr.b=(sr.ecm14/60)*(l_shb111+l_shb113)
      #LET sr.b=(sr.ecm14/60)*(sr.shb111+sr.shb113)    #FUN-A60076 mark 
#TQC-940163  ----end   
       LET sr.c=sr.b/sr.a*100
       IF sr.c IS NULL THEN LET sr.c = 0 END IF
       #FUN-A60076 -------------------start---------------------
       IF g_sma.sma541 = 'Y' THEN
          LET g_zaa[43].zaa06 = 'N'  
       ELSE
          LET g_zaa[43].zaa06 = 'Y'
       END IF 
       #FUN-A60076 -------------------end-----------------------
       OUTPUT TO REPORT r707_rep(sr.*)
     END FOREACH
     FINISH REPORT r707_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r707_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_str         LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)
          l_sw          LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_sta         LIKE oea_file.oea01,          #No.FUN-680121 VARCHAR(12)
          l_sta1        LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(22)
          l_sql1,l_sql2 LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(300)
          l_bmb16       LIKE bmb_file.bmb16,
          l_ecm         RECORD LIKE ecm_file.*,
          l_nedhur      LIKE eca_file.eca09,          #No.FUN-680121 DECIMAL(8,2)
#         l_a           LIKE ima_file.ima26,          #No.FUN-680121 DECIMAL(15,3)
#         l_b           LIKE ima_file.ima26,          #No.FUN-680121 DECIMAL(15,3)
#         l_c           LIKE ima_file.ima26,          #No.FUN-680121 DECIMAL(15,3)
          l_a           LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
          l_b           LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
          l_c           LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
          sr            RECORD
                           sfb05  LIKE sfb_file.sfb05,  #產品編號
                           ima02  LIKE ima_file.ima02,  #料品名稱
                           ima021 LIKE ima_file.ima021, #規格
                           sfb01  LIKE sfb_file.sfb01,  #工單編號
                           sfb08  LIKE sfb_file.sfb08,  #生產量
                           sfb09  LIKE sfb_file.sfb09,  #入庫量
                           sfb12  LIKE sfb_file.sfb12,  #報廢量
                           ecm03  LIKE ecm_file.ecm03,  #op#
                           ecm012 LIKE ecm_file.ecm012, #FUN-A60076
                           ecm45  LIKE ecm_file.ecm45,  #作業編號
                           ecm01  LIKE ecm_file.ecm01,
                           ecm14  LIKE ecm_file.ecm14,
                           shb111 LIKE shb_file.shb111, #TQC-940163   
                           shb113 LIKE shb_file.shb113, #TQC-940163     
#                          a      LIKE ima_file.ima26,          #No.FUN-680121 DEC(15,3)#實工
#                          b      LIKE ima_file.ima26,          #No.FUN-680121 DEC(15,3)#標工
#                          c      LIKE ima_file.ima26           #No.FUN-680121 DEC(15,3)#效率
                           a      LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
                           b      LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
                           c      LIKE type_file.num15_3        ###GP5.2  #NO.FUN-A20044
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.sfb05,sr.sfb01,sr.ecm03
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   #No.TQC-6A0102
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   #No.TQC-6A0102
      PRINT ''
 
      PRINT g_dash CLIPPED    #No.TQC-6A0102
      PRINT g_x[31],
            g_x[32],
            g_x[33],
            g_x[34],
            g_x[35],
            g_x[36],
            g_x[37],
            g_x[38],
            g_x[43],        #FUN-A60076
            g_x[39],
            g_x[40],
            g_x[41],
            g_x[42]
      PRINT g_dash1 CLIPPED  #No.TQC-6A0102
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.sfb05
      PRINT COLUMN g_c[31],sr.sfb05,
            COLUMN g_c[32],sr.ima02 CLIPPED,
            COLUMN g_c[33],sr.ima021 CLIPPED;
 
   BEFORE GROUP OF sr.sfb01
      LET l_a = 0
      LET l_b = 0
      LET l_c = 0
      PRINT COLUMN g_c[34],sr.sfb01,
            COLUMN g_c[35],sr.sfb08 USING '###,###,###,###',
            COLUMN g_c[36],sr.sfb09 USING '##,###,###.####',
            COLUMN g_c[37],sr.sfb12 USING '##,###,###.####';
 
   AFTER  GROUP OF sr.ecm03
      PRINT COLUMN g_c[38],sr.ecm03 USING '##########',#No.TQC-5C0026
            COLUMN g_c[43],sr.ecm012,               #FUN-A60076
            COLUMN g_c[39],sr.ecm45,
            COLUMN g_c[40],sr.a USING '#######.##', #No.TQC-5C0026
            COLUMN g_c[41],sr.b USING '#######.##', #No.TQC-5C0026
            COLUMN g_c[42],sr.c USING '#######.##'  #No.TQC-5C0026
      IF sr.a IS NULL THEN LET sr.a = 0 END IF
      IF sr.b IS NULL THEN LET sr.b = 0 END IF
      IF sr.c IS NULL THEN LET sr.c = 0 END IF
      LET l_a = sr.a + l_a
      LET l_b = sr.b + l_b
      LET l_c = sr.c + l_c
 
   AFTER  GROUP OF sr.sfb01
      PRINT g_dash2 CLIPPED  #No.TQC-6A0102
      PRINT COLUMN g_c[39],g_x[09] CLIPPED,
            COLUMN g_c[40],l_a USING '#######.##', #No.TQC-5C0026
            COLUMN g_c[41],l_b USING '#######.##', #No.TQC-5C0026
            COLUMN g_c[42],l_c USING '#######.##'  #No.TQC-5C0026
 
    ON LAST ROW
      IF g_zz05 = 'Y'   THEN
#TQC-630166-start
          CALL cl_wcchp(tm.wc,'sfb05')  #TQC-630166
               RETURNING tm.wc
          PRINT g_dash[1,g_len] CLIPPED  #No.TQC-6A0102
          CALL cl_prt_pos_wc(tm.wc) 
#             IF tm.wc[001,120] > ' ' THEN            # for 132
#               PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             IF tm.wc[121,240] > ' ' THEN
#               PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             IF tm.wc[241,300] > ' ' THEN
#               PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#TQC-630166-end
      END IF
      PRINT g_dash CLIPPED  #No.TQC-6A0102
      PRINT g_x[4] CLIPPED, COLUMN g_c[42], g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
     IF l_last_sw = 'n' THEN
        PRINT g_dash CLIPPED   #No.TQC-6A0102
        PRINT g_x[4] CLIPPED, COLUMN g_c[42], g_x[6] CLIPPED
     ELSE
      SKIP 2 LINE
     END IF
END REPORT
