# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: afar360.4gl
# Descriptions...: 模具在外狀況明細表
# Input parameter:
# Return code....:
# Date & Author..: 00/03/08 By Alex Lin
# Modify.........: No.+207 010612 by linda 依類別 1.部門 2.廠商 讀名稱
# Modify         : No.MOD-530844 05/03/30 by alexlin VARCHAR->CHAR
# Modify.........: NO.FUN-550034 05/05/19 By jackie 單據編號加大
# Modify.........: No.MOD-570161 05/08/08 By Smapmin 在外數量已為0的就不要列出了
# Modify.........: No.FUN-580010 05/08/02 By vivien  憑証類報表轉XML
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-850015 08/05/06 By lala
#                                08/08/07 By Cockroach 接lala處理BUG單    
#                                08/08/14 By Cockroach 21區修改后追至31區
# Modify.........: No.TQC-970411 09/07/31 By Carrier 在外明細資料需審核的資料
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580010  --start
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #FUN-560079
  DEFINE g_seq_item    LIKE type_file.num5         #No.FUN-680070 SMALLINT
END GLOBALS
 
    DEFINE tm  RECORD				# Print condition RECORD
              wc   STRING,                      # Where Condition
              bdate LIKE type_file.dat,                          # 起始日期       #No.FUN-680070 DATE
              edate LIKE type_file.dat,                          # 結束日期       #No.FUN-680070 DATE
              a    LIKE type_file.chr1,                      # 特殊列印條件       #No.FUN-680070 VARCHAR(01)
              more LIKE type_file.chr1                       # 特殊列印條件       #No.FUN-680070 VARCHAR(01)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE   g_sql      STRING
DEFINE   g_str      STRING
DEFINE   l_table    STRING
#No.FUN-580010  --end
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
   
#No.FUN-850015---start---
   LET g_sql="feb02.feb_file.feb02,",
             "fea02.fea_file.fea02,",
             "feb06.feb_file.feb06,",
             "fed04.fed_file.fed04,",
             "fec02.fec_file.fec02,",
             "fec01.fec_file.fec01,",
             "gem02.gem_file.gem02,",
             "fef05.fef_file.fef05,",
#             "fef04.fef_file.fef04,",           #No.FUN-850015 By cockroach
#             "fef01.fef_file.fef01,",           #No.FUN-850015 By cockroach 
#             "fed04_1.fed_file.fed04,",         #No.FUN-850015 By cockroach 
#             "fef04_1.fef_file.fef04,",         #No.FUN-850015 By cockroach 
             "l_qty1.type_file.num10,",          #No.FUN-850015 By cockroach 
             "code.type_file.chr1"
   LET l_table = cl_prt_temptable('afar360',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED, l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
#No.FUN-850015---end---
 
   LET g_pdate  = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)   #TQC-610055
   LET tm.edate = ARG_VAL(9)   #TQC-610055
   LET tm.a = ARG_VAL(10)   #TQC-610055
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL r360_tm(0,0)		# Input print condition
      ELSE CALL r360()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION r360_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 18
 
   OPEN WINDOW r360_w AT p_row,p_col WITH FORM "afa/42f/afar360"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL       # Default condition
   LET tm.bdate  = g_today
   LET tm.edate  = g_today
   LET tm.a      = '2'
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
 
   WHILE TRUE
      DISPLAY BY NAME tm.a,tm.more
      CONSTRUCT BY NAME  tm.wc ON feb02
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
         LET INT_FLAG = 0 CLOSE WINDOW r360_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
 
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.bdate,tm.edate,tm.a,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD bdate
            IF cl_null(tm.bdate)  THEN
               NEXT FIELD bdate
            END IF
         AFTER FIELD edate
            IF cl_null(tm.edate) OR tm.edate < tm.bdate THEN
               NEXT FIELD edate
            END IF
         AFTER FIELD a
            IF cl_null(tm.a) THEN
               NEXT FIELD a
            END IF
            IF tm.a NOT MATCHES'[12]' THEN
               NEXT FIELD a
            END IF
         AFTER FIELD more
            IF tm.more NOT MATCHES'[YN]' THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()	# Command execution
 
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
         LET INT_FLAG = 0 CLOSE WINDOW r360_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='afar360'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar360','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.bdate,"'",
                        " '",tm.edate,"'" ,
                        " '",tm.a,"'" ,   #TQC-610055
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('afar360',g_time,l_cmd)	# Execute cmd at later time
         END IF
         CLOSE WINDOW r360_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r360()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r360_w
END FUNCTION
 
FUNCTION r360()
   DEFINE l_name     LIKE type_file.chr20, 		# External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0069
          l_i        LIKE type_file.num5,  		#       #No.FUN-680070 SMALLINT
          l_sql1     LIKE type_file.chr1000,		#       #No.FUN-680070 VARCHAR(1000)
          l_sql2     LIKE type_file.chr1000,		#       #No.FUN-680070 VARCHAR(1000)
          l_sql3     LIKE type_file.chr1000,		#       #No.FUN-680070 VARCHAR(1000)
          l_sql4     LIKE type_file.chr1000,		#       #No.FUN-680070 VARCHAR(1000)
          l_za05     LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(40)
          l_a1       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_fec03    LIKE fec_file.fec03,
          l_fec05    LIKE fec_file.fec05,
          l_fed04_1    LIKE fed_file.fed04,
          l_fef04_1    LIKE fef_file.fef04,
          l_qty1     LIKE type_file.num10,
          sr1        RECORD
                     feb02     LIKE    feb_file.feb02,   #模具編號
                     feb06     LIKE    feb_file.feb06,   #模具數量
                     fea02     LIKE    fea_file.fea02,   #模具名稱
                     code      LIKE    type_file.chr1,   #單別 (1,2)       #No.FUN-680070 VARCHAR(1)
                     fec01     LIKE    fec_file.fec01,   #領用單號
                     fec02     LIKE    fec_file.fec02,   #領用日期
                     fed04     LIKE    fed_file.fed04,   #領用數量
                     gem02     LIKE    gem_file.gem02,   #領用部門
                     fef05     LIKE    fef_file.fef05,   #領用單號-歸還用
                     fef04     LIKE    fef_file.fef04,                          #FUN-850015
                     fef01     LIKE    fef_file.fef01                           #FUN-850015
                     END RECORD
    DEFINE l_fed04_2  LIKE fed_file.fed04   #MOD-570161
    DEFINE l_fef04_2  LIKE fef_file.fef04   #MOD-570161
    DEFINE l_qty4     LIKE type_file.num10      #MOD-570161       #No.FUN-680070 INTEGER
   DEFINE l_cnt         LIKE type_file.num5         #No.FUN-680070 SMALLINT
   DEFINE l_zaa02           LIKE zaa_file.zaa02
     CALL cl_del_data(l_table)                                    #No.FUN-850015  By Cockroach
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql1 = " SELECT feb02,feb06,fea02,'','','','','',''",
                  " FROM feb_file,fea_file ",
                  " WHERE feb01 = fea01 ",
                  " AND ",tm.wc CLIPPED
 
     LET l_sql3 = " SELECT '1',fec01,fec02,fed04,gem02,'',fec03,fec05",
                  " FROM fec_file,fed_file,OUTER gem_file",
                  " WHERE fec01 = fed01 AND fed03 = ? " ,
                  " AND fec_file.fec03=gem_file.gem01 ",
                  " AND fecacti='Y' ",      #010831增 AND fecacti='Y'
                  " AND fecconf = 'Y' ",    #No.TQC-970411
                  " AND fec02 BETWEEN '",tm.bdate ,"' AND '",tm.edate,"' "
 
     LET l_sql2  = " SELECT '2',fee01,fee02,fef04,gem02,fef05,fee03,fee05",
                   " FROM fee_file,fef_file,OUTER gem_file",
                   " WHERE fef03 = ? AND fee01 = fef01 ",
                   " AND fee_file.fee03=gem_file.gem01 ",
                   " AND feeconf = 'Y' ",    #No.TQC-970411
                   " AND fee02 BETWEEN '",tm.bdate ,"' AND '",tm.edate,"' "
 
     PREPARE r360_p1 FROM l_sql1
        IF SQLCA.sqlcode THEN
           CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
           EXIT PROGRAM
              
        END IF
     DECLARE r360_c1 CURSOR FOR r360_p1
 
     PREPARE r360_p3 FROM l_sql3
        IF SQLCA.sqlcode THEN
           CALL cl_err('prepare3:',SQLCA.sqlcode,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
           EXIT PROGRAM
              
        END IF
     DECLARE r360_c3 CURSOR FOR r360_p3
 
     PREPARE r360_p2 FROM l_sql2
        IF SQLCA.sqlcode THEN
           CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
           EXIT PROGRAM
              
        END IF
     DECLARE r360_c2 CURSOR FOR r360_p2
 
#     CALL cl_outnam('afar360') RETURNING l_name    #No.FUN-850015 By cockroach 
 
#No.FUN-580010 --start
     IF tm.a = '1' THEN
        LET g_zaa[35].zaa06 = "N"
        LET g_zaa[37].zaa06 = "Y"
        LET g_zaa[38].zaa06 = "Y"
        LET g_zaa[39].zaa06 = "Y"
        LET g_zaa[40].zaa06 = "Y"
        LET g_zaa[41].zaa06 = "Y"
        LET g_zaa[42].zaa06 = "Y"
        LET g_zaa[43].zaa06 = "Y"
     ELSE
        LET g_zaa[35].zaa06 = "Y"
        LET g_zaa[37].zaa06 = "N"
        LET g_zaa[38].zaa06 = "N"
        LET g_zaa[39].zaa06 = "N"
        LET g_zaa[40].zaa06 = "N"
        LET g_zaa[41].zaa06 = "N"
        LET g_zaa[42].zaa06 = "N"
        LET g_zaa[43].zaa06 = "N"
     END IF
     CALL cl_prt_pos_len()
#No.FUN-580010 --end
 
#     START REPORT r360_rep TO l_name                #No.FUN-850015
     LET g_pageno = 0
 
     FOREACH r360_c1 INTO sr1.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach1:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
 #MOD-570161
      SELECT sum(fed04) INTO l_fed04_2 FROM fec_file,fed_file
        WHERE fed03 = sr1.feb02 AND fed01 = fec01
          AND fec02 <= tm.edate AND fecacti = 'Y'
          AND fecconf = 'Y'  #No.TQC-970411
      SELECT sum(fef04) INTO l_fef04_2 FROM fee_file,fef_file
        WHERE fef03 = sr1.feb02 AND fef01 = fee01
          AND fee02 <= tm.edate
          AND feeconf = 'Y'  #No.TQC-970411
      IF cl_null(l_fed04_2) THEN LET l_fed04_2 = 0 END IF
      IF cl_null(l_fef04_2) THEN LET l_fef04_2 = 0 END IF
      LET l_qty4 = l_fed04_2 - l_fef04_2
 #END MOD-570161
      SELECT sum(fed04) INTO l_fed04_1 FROM fec_file,fed_file
        WHERE fed03 =sr1.feb02 AND fed01=fec01
          AND fec02 < tm.bdate AND fecacti='Y'    #010831增 AND fecacti='Y'
          AND fecconf = 'Y'  #No.TQC-970411
      SELECT sum(fef04) INTO l_fef04_1 FROM fee_file,fef_file
        WHERE fef03 =sr1.feb02 AND fef01=fee01 AND fee02 < tm.bdate
          AND feeconf = 'Y'  #No.TQC-970411
      IF cl_null(l_fed04_1) THEN  LET l_fed04_1=0  END IF
      IF cl_null(l_fef04_1) THEN  LET l_fef04_1=0  END IF
      LET l_qty1= l_fed04_1 - l_fef04_1
       LET l_a1='Y'
       FOREACH r360_c3
       USING sr1.feb02  #領用
                       INTO sr1.code,sr1.fec01,sr1.fec02,sr1.fed04,
                            sr1.gem02,sr1.fef05,l_fec03,l_fec05
         IF STATUS THEN
            CALL cl_err('foreach3:',SQLCA.sqlcode,1) EXIT FOREACH END IF
            #No.+207 010612 by linda add
            IF l_fec05='2' THEN
               SELECT pmc03 INTO sr1.gem02
                 FROM pmc_file
               WHERE pmc01=l_fec03
            END IF
            #No.+207 end----
             IF l_qty4 > 0 THEN   #MOD-570161
#                OUTPUT TO REPORT r360_rep(sr1.*)#No.FUN-850015 By Cockroach
                EXECUTE insert_prep USING                           #No.FUN-850015 By cockroach 
                  sr1.feb02,sr1.fea02,sr1.feb06,sr1.fed04,sr1.fec02,
                  sr1.fec01,sr1.gem02,sr1.fef05,l_qty1,   sr1.code
            END IF
            LET l_a1='N'
       END FOREACH
       FOREACH r360_c2
       USING sr1.feb02   #歸還
                       INTO sr1.code,sr1.fec01,sr1.fec02,sr1.fed04,
                            sr1.gem02,sr1.fef05,l_fec03,l_fec05
         IF STATUS THEN
            CALL cl_err('foreach2:',SQLCA.sqlcode,1) EXIT FOREACH END IF
            #No.+207 010612 by linda add
            IF l_fec05='2' THEN
               SELECT pmc03 INTO sr1.gem02
                 FROM pmc_file
               WHERE pmc01=l_fec03
            END IF
            #No.+207 end----
             IF l_qty4 > 0 THEN   #MOD-570161
#               OUTPUT TO REPORT r360_rep(sr1.*)       #No.FUN-850015 By Cockroach
               EXECUTE insert_prep USING               #No.FUN-850015 By cockroach 
                 sr1.feb02,sr1.fea02,sr1.feb06,sr1.fed04,sr1.fec02,
                 sr1.fec01,sr1.gem02,sr1.fef05,l_qty1,   sr1.code
             END IF   #MOD-570161
            LET l_a1='N'
       END FOREACH
       IF l_a1 = 'Y' THEN
          LET sr1.code=''
          LET sr1.fec01=''
          LET sr1.fec02=''
          LET sr1.fed04=0
          LET sr1.fef05=''
           IF l_qty4 > 0 THEN   #MOD-570161
#             OUTPUT TO REPORT r360_rep(sr1.*)        #No.FUN-850015 By Cockroach
             EXECUTE insert_prep USING                #No.FUN-850015 By cockroach 
               sr1.feb02,sr1.fea02,sr1.feb06,sr1.fed04,sr1.fec02,
               sr1.fec01,sr1.gem02,sr1.fef05,l_qty1,   sr1.code
           END IF   #MOD-570161
       END IF
#No.FUN-850015 By Cockroach MARK START
#     EXECUTE insert_prep USING
#     sr1.feb02,sr1.fea02,sr1.feb06,sr1.fed04,sr1.fec02,sr1.fec01,sr1.gem02,sr1.fef05,sr1.fef04,sr1.fef01,
#     l_fed04_1,l_fef04_1,sr1.code
#No.FUN-850015 By Cockroach MARK END
     END FOREACH
     LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_wcchp(tm.wc,'feb02')
             RETURNING tm.wc
     LET g_str=tm.wc,";",tm.bdate,";",tm.edate
     IF tm.a = '1' THEN
        CALL cl_prt_cs3('afar360','afar360_1',g_sql,g_str)
     END IF
     IF tm.a = '2' THEN
        CALL cl_prt_cs3('afar360','afar360',g_sql,g_str)
     END IF
 
#     FINISH REPORT r360_rep                        #No.FUN-850015 By lala
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #No.FUN-850015 By lala
END FUNCTION
 
#No.FUN-850015 --MARK START-- 
#REPORT r360_rep(sr1)
#   DEFINE l_last_sw  LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#          l_sw,l_sy  LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#          l_sr       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#          l_fed04    LIKE fed_file.fed04,
#          l_fef04    LIKE fef_file.fef04,
#          l_qty1,l_qty2,l_qty3  LIKE type_file.num10,        #No.FUN-680070 INTEGER
#          sr1        RECORD
#                     feb02     LIKE    feb_file.feb02,   #模具編號
#                     feb06     LIKE    feb_file.feb06,   #模具數量
#                     fea02     LIKE    fea_file.fea02,   #模具名稱
#                     code      LIKE    type_file.chr1,   #單別 (1,2)       #No.FUN-680070 VARCHAR(1)
#                     fec01     LIKE    fec_file.fec01,   #領用單號
#                     fec02     LIKE    fec_file.fec02,   #領用日期
#                     fed04     LIKE    fed_file.fed04,   #領用數量
#                     gem02     LIKE    gem_file.gem02,   #領用部門
#                     fef05     LIKE    fef_file.fef05    #領用單號-歸還用
#                     END RECORD
 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
 
#  ORDER BY sr1.feb02,sr1.fec02,sr1.code,sr1.fec01
 
#  FORMAT
#   PAGE HEADER
#No.FUN-580010 --start
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
 
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      IF tm.a = '1' THEN PRINT g_x[18] CLIPPED
#      ELSE               PRINT g_x[19] CLIPPED
#      END IF
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#            g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],
#            g_x[42],g_x[43]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#No.FUN-580010  --end
 
#   BEFORE GROUP OF sr1.feb02
#      SELECT sum(fed04) INTO l_fed04 FROM fec_file,fed_file
#        WHERE fed03 =sr1.feb02 AND fed01=fec01
#          AND fec02 < tm.bdate AND fecacti='Y'    #010831增 AND fecacti='Y'
#      SELECT sum(fef04) INTO l_fef04 FROM fee_file,fef_file
#        WHERE fef03 =sr1.feb02 AND fef01=fee01 AND fee02 < tm.bdate
#      IF cl_null(l_fed04) THEN  LET l_fed04=0  END IF
#      IF cl_null(l_fef04) THEN  LET l_fef04=0  END IF
#      LET l_qty1= l_fed04 - l_fef04 #在外期初量
#      LET l_sr='y'
#      IF tm.a = '1' THEN
#No.FUN-580010 --start
#         PRINT COLUMN g_c[31],sr1.feb02 CLIPPED,
#               COLUMN g_c[32],sr1.fea02 CLIPPED,
#               COLUMN g_c[33],cl_numfor(sr1.feb06,33,0),
#               COLUMN g_c[34],cl_numfor(l_qty1,34,0);
#      ELSE
#         PRINT COLUMN g_c[31],sr1.feb02 CLIPPED,
#               COLUMN g_c[32],sr1.fea02[1,16],
#               COLUMN g_c[33],cl_numfor(sr1.feb06,33,0),
#               COLUMN g_c[34],cl_numfor(l_qty1,34,0);
#No.FUN-580010 --end
#         LET l_sr='y'
#      END IF
#      LET l_qty2=0
#      LET l_qty3=0
 
#   ON EVERY ROW
#      IF tm.a='2' THEN
#         IF cl_null(sr1.fed04) THEN  LET sr1.fed04=0  END IF
#         IF sr1.code='1' THEN
#            LET l_qty1=l_qty1+sr1.fed04
#         ELSE
#            LET l_qty1=l_qty1-sr1.fed04
#         END IF
#         CASE sr1.code
#No.FUN-580010 --start
#          WHEN '1' PRINT COLUMN g_c[37],g_x[20] CLIPPED;
#          WHEN '2' PRINT COLUMN g_c[37],g_x[21] CLIPPED;
#          OTHERWISE PRINT ;
#         END CASE
#No.FUN-550034-begin
#         PRINT COLUMN g_c[38],sr1.fec02 CLIPPED,
#               COLUMN g_c[39],sr1.fec01 CLIPPED,
#               COLUMN g_c[40],sr1.gem02[1,8],
#               COLUMN g_c[41],cl_numfor(sr1.fed04,41,0),
#               COLUMN g_c[42],cl_numfor(l_qty1,42,0),
#               COLUMN g_c[43],sr1.fef05 CLIPPED
#No.FUN-580010 --end
#      END IF
#      IF sr1.code='1' THEN LET l_qty2=l_qty2+sr1.fed04 END IF
#      IF sr1.code='2' THEN LET l_qty3=l_qty3+sr1.fed04 END IF
 
#   AFTER GROUP OF sr1.feb02
#         LET l_qty1=l_qty1 + l_qty2 - l_qty3
#         PRINT COLUMN g_c[35],cl_numfor(l_qty1,35,0)  #No.FUN-580010
#No.FUN-550034-end
 
#   ON LAST ROW
#      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#         THEN PRINT g_dash[1,g_len]
#            #-- TQC-630166 begin
#              #IF tm.wc[001,120] > ' ' THEN			# for 132
# 	      #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#              #IF tm.wc[121,240] > ' ' THEN
# 	      #   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#              #IF tm.wc[241,300] > ' ' THEN
# 	      #   PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#              CALL cl_prt_pos_wc(tm.wc)
#            #-- TQC-630166 end
#      END IF
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash[1,g_len]
#         PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE SKIP 2 LINE END IF
#END REPORT
#Patch....NO.TQC-610035 <> #
#No.FUN-850015---mark end---
