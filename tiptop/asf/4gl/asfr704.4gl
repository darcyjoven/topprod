# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: asfr704.4gl
# Descriptions...: 標 準 工 時 總 綱(工單)
# Date & Author..: 99/05/14 by patricia
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗
# Modify.........: No.FUN-580014 05/08/18 By jackie 轉XML
# Modify.........: No.TQC-5C0026 05/12/20 By kevin 欄位沒對齊
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60027 10/06/22 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60095 10/07/18 By jan SQL調整
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                       # Print condition RECORD
#                 wc       VARCHAR(600),      # Where condition   #TQC-603166
                  wc       STRING,         # Where condition   #TQC-603166
                  more     LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                 # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
 
 
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
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL r704_tm(0,0)        # Input print condition
      ELSE CALL asfr704()        # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r704_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680121 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(400)
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW r704_w AT p_row,p_col
        WITH FORM "asf/42f/asfr704"
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
   DISPLAY BY NAME tm.more # Condition
   CONSTRUCT BY NAME tm.wc ON ecm03_par,ecm01
#No.FUN-570240 --start--
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION controlp
            IF INFIELD(ecm03_par) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ecm03_par
               NEXT FIELD ecm03_par
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
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r704_w 
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
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r704_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM 
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file  WHERE zz01='asfr704'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr704','9031',1)
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
         CALL cl_cmdat('asfr704',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r704_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   CALL cl_wait()
   CALL asfr704()
   ERROR ""
END WHILE
   CLOSE WINDOW r704_w
END FUNCTION
 
FUNCTION asfr704()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
#         l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT   #TQC-630166        #No.FUN-680121 VARCHAR(1100)
          l_sql     STRING,                       # RDSQL STATEMENT   #TQC-630166
          l_cnt     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_sgd     RECORD LIKE sgd_file.*,
          sr        RECORD
                  ecm01     LIKE ecm_file.ecm01,
                  sfb08     LIKE sfb_file.sfb08,
                  ecm03_par LIKE ecm_file.ecm03_par,
                  ima02     LIKE ima_file.ima02,
                  ecm45     LIKE ecm_file.ecm45, #作業名稱
                  ecm06     LIKE ecm_file.ecm06,  #生產數
                  ecm14     LIKE ecm_file.ecm14,  #標準工時
                  ecm49     LIKE ecm_file.ecm49,  #單位人力
                  ecm16     LIKE ecm_file.ecm16,  #標準機器
                  ecm012    LIKE ecm_file.ecm012, #FUN-A60027 製程段號
                  ecm03     LIKE ecm_file.ecm03,  #製程序號
                  sgd05     LIKE sgd_file.sgd05,
                  sga02     LIKE sga_file.sga02,
                  sgd06     LIKE sgd_file.sgd06,
                  sgd08     LIKE sgd_file.sgd08,
                  sgd09     LIKE sgd_file.sgd09,
                  sgd11     LIKE sgd_file.sgd11
                    END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND ecmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND ecmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND ecmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ecmuser', 'ecmgrup')
     #End:FUN-980030
 
 
     LET l_sql="SELECT ecm01,sfb08,ecm03_par,ima02,ecm45,ecm06,ecm14,ecm49,",
               " ecm16,ecm012,ecm03,sgd05,sga02,sgd06,sgd08,sgd09,sgd11 ",      #FUN-A60027 add ecm012
            #No.B578 010522 BY ANN CHEN
         #    "FROM ecm_file,sgd_file,sfb_file,OUTER ima_file,OUTER sga_file",
      "   FROM   ecm_file left outer join sgd_file on sgd00=ecm01 AND sgd01=ecm03_par ",
      "   AND  sgd02 = ecm11 AND sgd03=ecm03 AND sgd04=ecm06 ,",
     #"   sfb_file left outer join dev_ds.dbo.ima_file on sfb05=ima01,sga_file", #FUN-A60095
      "   sfb_file LEFT OUTER JOIN ima_file ON sfb05=ima01,sga_file",  #FUN-A60095
      "   where  ecm01 = sfb01 ",
               "   AND sga01 = sgd05 AND sfb87!='X' ",
               "   AND " ,tm.wc CLIPPED
 
     PREPARE r704_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
           
     END IF
     DECLARE r704_cs1 CURSOR FOR r704_prepare1
     IF SQLCA.sqlcode THEN CALL cl_err('r704_cs1',STATUS,1) END IF
     CALL cl_outnam('asfr704') RETURNING l_name
     START REPORT r704_rep TO l_name
     FOREACH r704_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET sr.ecm14 = sr.ecm14 / 60
       LET sr.ecm16 = sr.ecm16 / 60
       #FUN-A60027 ----------------------start------------------------
       IF g_sma.sma541 = 'Y' THEN
          LET g_zaa[43].zaa06 = 'N'
          LET g_zaa[44].zaa06 = 'N'
       ELSE
          LET g_zaa[43].zaa06 = 'Y'
          LET g_zaa[44].zaa06 = 'Y' 
       END IF 
       #FUN-A60027 ---------------------end--------------------------
       OUTPUT TO REPORT r704_rep(sr.*)
     END FOREACH
     FINISH REPORT r704_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r704_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          sr        RECORD
                  ecm01     LIKE ecm_file.ecm01,
                  sfb08     LIKE sfb_file.sfb08,
                  ecm03_par LIKE ecm_file.ecm03_par,
                  ima02     LIKE ima_file.ima02,
                  ecm45     LIKE ecm_file.ecm45, #作業名稱
                  ecm06     LIKE ecm_file.ecm06,  #生產數
                  ecm14     LIKE ecm_file.ecm14,  #標準工時
                  ecm49     LIKE ecm_file.ecm49,  #單位人力
                  ecm16     LIKE ecm_file.ecm16,  #標準機器
                  ecm012    LIKE ecm_File.ecm012, #FUN-A60027
                  ecm03     LIKE ecm_file.ecm03,  #製程序號
                  sgd05     LIKE sgd_file.sgd05,
                  sga02     LIKE sga_file.sga02,
                  sgd06     LIKE sgd_file.sgd06,
                  sgd08     LIKE sgd_file.sgd08,
                  sgd09     LIKE sgd_file.sgd09,
                  sgd11     LIKE sgd_file.sgd11
                    END RECORD,
        l_sql    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(300)
        l_ecm14  LIKE ecm_file.ecm14,          #No.FUN-680121 DEC(9,2)
        l_ecm49  LIKE ecm_file.ecm49,          #No.FUN-680121 DEC(9,2)
        l_ecm16  LIKE ecm_file.ecm16           #No.FUN-680121 DEC(9,2)
 
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.ecm01,sr.ecm03,sr.sgd05
  FORMAT
   PAGE HEADER
#No.FUN-580014 --start--
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
      PRINT g_dash[1,g_len]
 
   BEFORE GROUP OF sr.ecm01
      SKIP TO TOP OF PAGE
      PRINT g_x[11] CLIPPED,sr.ecm01 ,
            COLUMN 37,g_x[14] CLIPPED,sr.sfb08 USING '############.###'
      PRINT g_x[13] CLIPPED,sr.ecm03_par CLIPPED
      PRINT g_x[12] CLIPPED,sr.ima02
      PRINT ' '
      PRINTX name=H1 g_x[43],g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]   #FUN-A60027 add g_x[43]
      PRINTX name=H2 g_x[44],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42]   #FUN-A60027 add g_x[44]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
 #BEFORE GROUP OF sr.ecm03                                   #FUN-A60027 mark
  BEFORE GROUP OF sr.ecm012                                  #FUN-A60027
      PRINTX name=D1
            COLUMN g_c[43],sr.ecm012 CLIPPED,                #FUN-A60027  
            COLUMN g_c[31],sr.ecm03 CLIPPED,
            COLUMN g_c[32],sr.ecm45 CLIPPED,
            COLUMN g_c[33],sr.ecm06[1,10] CLIPPED ,
            COLUMN g_c[34],sr.ecm14 USING '############.##',
            COLUMN g_c[35],sr.ecm49 USING '############.##',
            COLUMN g_c[36],sr.ecm16 USING '############.##'
 
  ON EVERY ROW
      IF g_sma.sma55 ='Y' THEN   #做製程單元管理
          PRINTX name=D2
                COLUMN g_c[44],'' CLIPPED,                #FUN-A60027
                COLUMN g_c[37],sr.sgd05 USING '######',
                COLUMN g_c[38],sr.sga02 CLIPPED,
                COLUMN g_c[39],sr.sgd06 USING '##########',  #No.TQC-5C0026
                COLUMN g_c[40],sr.sgd08 USING '############.##',
                COLUMN g_c[41],sr.sgd09 USING '############.##',
                COLUMN g_c[42],sr.sgd11 USING '###########.###'
      END IF
 
  AFTER GROUP OF sr.ecm03
      PRINT ' '
 
  AFTER GROUP OF sr.ecm01
       SELECT SUM(ecm14) INTO l_ecm14 FROM ecm_file
       WHERE ecm01 = sr.ecm01
       SELECT SUM(ecm49) INTO l_ecm49 FROM ecm_file
       WHERE ecm01 = sr.ecm01
       SELECT SUM(ecm16) INTO l_ecm16 FROM ecm_file
       WHERE ecm01 = sr.ecm01
       IF l_ecm14 IS NULL THEN LET l_ecm14 = 0 END IF 	
       IF l_ecm49 IS NULL THEN LET l_ecm49 = 0 END IF 	
       IF l_ecm16 IS NULL THEN LET l_ecm16 = 0 END IF 	
      PRINT ''
      PRINTX name=S1
            COLUMN g_c[33],g_x[17] CLIPPED,
            COLUMN g_c[34],l_ecm14 USING '############.##',
            COLUMN g_c[35],l_ecm49 USING '############.##',
            COLUMN g_c[36],l_ecm16 USING '############.##'
#No.FUN-580014 --end--
 
    ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN
#TQC-630166-start
          CALL cl_wcchp(tm.wc,'ecm03_par,ecm01')  #TQC-630166
               RETURNING tm.wc
          PRINT g_dash[1,g_len]
          CALL cl_prt_pos_wc(tm.wc) 
#             IF tm.wc[001,070] > ' ' THEN            # for 80
#              PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#             IF tm.wc[071,140] > ' ' THEN
#              PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#             IF tm.wc[141,210] > ' ' THEN
#              PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#TQC-630166-end
 
      END IF
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
     IF l_last_sw = 'n' THEN
        PRINT g_dash[1,g_len]
        PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
     ELSE
        SKIP 2 LINES
     END IF
END REPORT
#Patch....NO.TQC-610037 <> #
