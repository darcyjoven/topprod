# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acor201.4gl
# Descriptions...: 合同出口成品報單狀況表
# Date & Author..: 00/09/26 By Amy
# Modify.........: NO.MOD-490398 04/11/23 BY Elva add HS Code,coc10,Customs No.
# Modify.........: NO.MOD-490398 04/12/24 BY Carrier 修改cno10之后的影響
# Modify.........: NO.MOD-490398 05/02/28 BY Elva 修改數量
# Modify.........: No.FUN-550036 05/05/19 By day   單據編號加大
# Modify.........: No.FUN-580110 05/08/24 By jackie 報表轉XML格式
# Modify.........: NO.FUN-590118 06/01/03 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610082 06/04/07 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-770006 07/07/16 By zhoufeng 報表輸出改為Crystal Reports
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(300)  # Where condition
               y      LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)               # NO.MOD-490398
              more    LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)  # Input more condition(Y/N)
              choice  LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
              END RECORD,
          l_orderA ARRAY[2] OF LIKE qcs_file.qcs03,       #No.FUN-680069 VARCHAR(10)
          l_tot_credit    LIKE cod_file.cod05
DEFINE    g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE    g_sql           STRING                  #No.FUN-770006
DEFINE    g_str           STRING                  #No.FUN-770006
DEFINE    l_table         STRING                  #No.FUN-770006
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
#No.FUN-770006 --start--
   LET g_sql="coc03.coc_file.coc03,cod02.cod_file.cod02,cod03.cod_file.cod03,",
             "cob02.cob_file.cob02,cob021.cob_file.cob021,",
             "cod06.cod_file.cod06,cod05.cod_file.cod05,cod09.cod_file.cod09,",
             "cod10.cod_file.cod10,cno01.cno_file.cno01,cno06.cno_file.cno06,",
             "cno07.cno_file.cno07,cno08.cno_file.cno08,",
             "chr20.type_file.chr20,cnp05.cnp_file.cnp05,",
             "cnp07.cnp_file.cnp07,cnp08.cnp_file.cnp08,azi03.azi_file.azi03,",
             "azi04.azi_file.azi04,azi05.azi_file.azi05"
   LET l_table = cl_prt_temptable('acor200',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-770006 --end--
 
 
   INITIALIZE tm.* TO NULL                # Default condition
    LET tm.y    = 'N'    #NO.MOD-490398
   LET tm.more = 'N'
   LET tm.choice = 'Y'
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
#----------------No.TQC-610082 modify
   LET tm.y      = ARG_VAL(8)
   LET tm.choice = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#----------------No.TQC-610082 end
 
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL acor201_tm(0,0)
      ELSE CALL acor201()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION acor201_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680069 SMALLINT
         l_cmd        LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(400)
 
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW acor201_w AT p_row,p_col WITH FORM "aco/42f/acor201"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
    LET tm.y   = 'N'    #NO.MOD-490398
   LET tm.more= 'N'
   LET tm.choice= 'Y'
 
 WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON coc01,coc04,coc10,coc03   #NO.MOD-490398
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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW acor201_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
    INPUT BY NAME tm.y,tm.choice,tm.more #NO.MOD-490398
      WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()     # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW acor201_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='acor201'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('acor201','9031',1)
      ELSE
         LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.y CLIPPED,"'",              #No.TQC-610082 add
                         " '",tm.choice CLIPPED,"'",         #No.TQC-610082 add 
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('acor201',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW acor201_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL acor201()
   ERROR ""
END WHILE
   CLOSE WINDOW acor201_w
END FUNCTION
 
FUNCTION acor201()
   DEFINE l_name     LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(20)  # External(Disk) file name
#       l_time          LIKE type_file.chr8         #No.FUN-6A0063
          l_sql      LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600)
          l_sql1     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600)
          l_chr      LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
          l_n        LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_za05     LIKE za_file.za05,  # NO.MOD-490398
          l_yy,l_mm  LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_order    ARRAY[5] OF LIKE qcs_file.qcs03,       #No.FUN-680069 VARCHAR(10)
          l_desc     LIKE zaa_file.zaa08,        #No.FUN-680069 VARCHAR(4)
           #No.MOD-490398  --begin
          sr            RECORD cod    RECORD LIKE cod_file.*,
                               cob09  LIKE cob_file.cob09,
                               cob02  LIKE cob_file.cob02,
                               cob021 LIKE cob_file.cob021,
                               coc03  LIKE coc_file.coc03
                        END RECORD,
           sr1          RECORD
                               cno01  LIKE cno_file.cno01,
                               cno03  LIKE cno_file.cno03,
                               cno031 LIKE cno_file.cno031,
                               cno04  LIKE cno_file.cno04,
                               cno06  LIKE cno_file.cno06,
                               cno07  LIKE cno_file.cno07,
                               cno08  LIKE cno_file.cno08,
                               cno10  LIKE cno_file.cno10,
                               cnp05  LIKE cnp_file.cnp05,
                               cnp06  LIKE cnp_file.cnp06,
                               cnp07  LIKE cnp_file.cnp07,
                               cnp08  LIKE cnp_file.cnp08
                          END RECORD
           #No.MOD-490398  --end
   DEFINE l_aco_total   LIKE type_file.num10,             #No.FUN-770006
          l_input_total LIKE type_file.num10,             #No.FUN-770006
          l_aco_sub     LIKE type_file.num10,             #No.FUN-770006
          l_i           LIKE type_file.num5               #No.FUN-770006 
 
     CALL cl_del_data(l_table)                            #No.FUN-770006
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 #NO.MOD-490398--begin
 #NO.MOD-490398--end
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN
     #        LET tm.wc = tm.wc clipped," AND cocuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN
     #        LET tm.wc = tm.wc clipped," AND cocgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc clipped," AND cocgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cocuser', 'cocgrup')
     #End:FUN-980030
 
      #No.MOD-490398  --begin
     LET l_sql = "SELECT cod_file.*,cob09,cob02,cob021,coc03",
                 "  FROM cod_file,cob_file,coc_file",
                 " WHERE cod01=coc01 AND cod03=cob01 ",
                 "   AND cocacti='Y' ",
                 "   AND ",tm.wc CLIPPED,
                 " ORDER BY coc03"
     PREPARE cod_pre FROM l_sql
     DECLARE cod_cs CURSOR FOR cod_pre
 
     LET l_sql1=" SELECT cno01,cno03,cno031,cno04,cno06,cno07,",
                "        cno08,cno10,SUM(cnp05),cnp06,cnp07,SUM(cnp08) ",
                "   FROM cno_file,cnp_file ",
                "  WHERE cnp01 = cno01 ",
                "    AND cno03='1' AND cno031 IN ('1','2')",
                "    AND cno04 IN ('1','2','4') ",
                "    AND cno10 = ? AND cnp02 = ? AND cnoconf='Y' ",
                "    AND cnoacti = 'Y' " ,
                "  GROUP BY cno01,cno03,cno031,cno04,cno06,cno07,cno08,cno10,cnp06,cnp07",
                "  ORDER BY cno06"
      #No.MOD-490398  --end
     PREPARE cno_pre FROM l_sql1
     DECLARE cno_cs CURSOR FOR cno_pre
#    CALL cl_outnam('acor201') RETURNING l_name              #No.FUN-770006
#No.FUN-580110 --start--
     IF tm.choice='N' THEN
#       LET g_zaa[31].zaa06='Y'                              #No.FUN-770006      
#       LET g_zaa[40].zaa06='Y'                              #No.FUN-770006
#       LET g_zaa[41].zaa06='Y'                              #No.FUN-770006
#       LET g_zaa[42].zaa06='Y'                              #No.FUN-770006
#       LET g_zaa[43].zaa06='Y'                              #No.FUN-770006
#       LET g_zaa[44].zaa06='Y'                              #No.FUN-770006
#       LET g_zaa[45].zaa06='Y'                              #No.FUN-770006
#       LET g_zaa[46].zaa06='Y'                              #No.FUN-770006
        LET l_name = 'acor201'                               #No.FUN-770006
     ELSE
#       LET g_zaa[31].zaa06='N'                              #No.FUN-770006
#       LET g_zaa[40].zaa06='N'                              #No.FUN-770006
#       LET g_zaa[41].zaa06='N'                              #No.FUN-770006
#       LET g_zaa[42].zaa06='N'                              #No.FUN-770006
#       LET g_zaa[43].zaa06='N'                              #No.FUN-770006
#       LET g_zaa[44].zaa06='N'                              #No.FUN-770006
#       LET g_zaa[45].zaa06='N'                              #No.FUN-770006
#       LET g_zaa[46].zaa06='N'                              #No.FUN-770006
        LET l_name = 'acor201_1'                             #No.FUN-770006
     END IF
#    CALL cl_prt_pos_len()                                   #No.FUN-770006
#No.FUN-580110 --end--
#    START REPORT r201_rep TO l_name                         #No.FUN_770006
       FOREACH cod_cs INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
         END IF
          #FOREACH cno_cs USING sr.coc04,sr.cod02 INTO sr1.* #No.MOD-490398
         FOREACH cno_cs USING sr.coc03,sr.cod.cod02 INTO sr1.* #No.MOD-490398
#            OUTPUT TO REPORT r201_rep(sr.*,sr1.*)  #NO.MOD-490398#No.FUN-770006
#No.FUN-770006 --start--
             LET l_aco_total=sr.cod.cod05+sr.cod.cod10 
             IF  cl_null(l_aco_total) THEN
                 LET l_aco_total = 0
             END IF
             LET l_input_total=sr.cod.cod09+sr.cod.cod101+sr.cod.cod106
                               -sr.cod.cod091-sr.cod.cod102- sr.cod.cod104
             IF  cl_null(l_input_total) THEN
                 LET l_input_total = 0
             END IF
             LET l_aco_sub=l_aco_total-l_input_total
             IF tm.y = 'Y' THEN
                SELECT cob09 INTO sr.cod.cod03 FROM cob_file
                       WHERE cob01=sr.cod.cod03
             END IF
             IF tm.choice = 'Y' THEN
#                LET l_i = 1
#                FOREACH cno_cs USING sr.coc03,sr.cod.cod02 INTO sr1.*
#                  IF SQLCA.sqlcode != 0 THEN
#                     CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
#                  END IF
                  IF sr1.cno031='2' THEN
                     LET sr1.cnp05 = sr1.cnp05 * -1
                     LET sr1.cnp08 = sr1.cnp08 * -1
                  END IF
                  SELECT UNIQUE azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
                         FROM azi_file,coc_file,cno_file,cnp_file
                         WHERE cnp01=sr1.cno01 AND cnp01=cno01 
                         AND cno10=coc03 AND azi01=coc02
                  EXECUTE insert_prep USING sr.coc03,sr.cod.cod02,sr.cod.cod03,
                                            sr.cob02,sr.cob021,sr.cod.cod06,
                                            l_aco_total,l_input_total,l_aco_sub,
                                            sr1.cno01,sr1.cno06,sr1.cno07,
                                            sr1.cno08,sr1.cno04,
                                            sr1.cnp05,sr1.cnp07,sr1.cnp08,
                                            g_azi03,g_azi04,g_azi05
#                  LET l_i = l_i+1
#                END FOREACH
#                IF l_i = 1 THEN
#                  EXECUTE insert_prep USING sr.coc03,sr.cod.cod02,sr.cod.cod03,
#                                            sr.cob02,sr.cob021,sr.cod.cod06,
#                                            l_aco_total,l_input_total,l_aco_sub,
#                                            '','','','','','0','','0','','',''
#                END IF
              ELSE 
                  EXECUTE insert_prep USING sr.coc03,sr.cod.cod02,sr.cod.cod03,
                                            sr.cob02,sr.cob021,sr.cod.cod06,
                                            l_aco_total,l_input_total,l_aco_sub,
                                            '','','','','','','','','','',''
              END IF
#No.FUN-770006 --end--
         END FOREACH                             
       END FOREACH
#    FINISH REPORT r201_rep                      #No.FUN-770006
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len) #No.FUN-770006
#No.FUN-770006 --start--
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'coc01,coc04,coc10,coc03')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str=g_str
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
     CALL cl_prt_cs3('acor201',l_name,l_sql,g_str)
#No.FUN-770006 --end--
END FUNCTION
#No.FUN-770006 --start-- mark
{REPORT r201_rep(sr,sr1)
   DEFINE l_last_sw     LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
          l_last        LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
          l_aco_total   LIKE type_file.num10,        #No.FUN-680069 INTEGER #合同總數
          l_input_total LIKE type_file.num10,        #No.FUN-680069 INTEGER #進口總數
          l_aco_sub     LIKE type_file.num10,        #No.FUN-680069 INTEGER #合同剩餘量
          l_qty_tot     LIKE type_file.num10,        #No.FUN-680069 INTEGER #小計數量
          l_money_tot   LIKE type_file.num10,        #No.FUN-680069 INTEGER #小計金額
          l_desc        LIKE zaa_file.zaa08,         #No.FUN-680069 VARCHAR(4)
          l_str         LIKE zaa_file.zaa08,         #No.FUN-680069 VARCHAR(40)   #NO.MOD-490398 050228
           #No.MOD-490398  --begin
          sr            RECORD cod    RECORD LIKE cod_file.*,
                               cob09  LIKE cob_file.cob09,
                               cob02  LIKE cob_file.cob02,
                               cob021 LIKE cob_file.cob021,
                               coc03  LIKE coc_file.coc03
                        END RECORD,
           sr1          RECORD
                               cno01  LIKE cno_file.cno01,
                               cno03  LIKE cno_file.cno03,
                               cno031 LIKE cno_file.cno031,
                               cno04  LIKE cno_file.cno04,
                               cno06  LIKE cno_file.cno06,
                               cno07  LIKE cno_file.cno07,
                               cno08  LIKE cno_file.cno08,
                               cno10  LIKE cno_file.cno10,
                               cnp05  LIKE cnp_file.cnp05,
                               cnp06  LIKE cnp_file.cnp06,
                               cnp07  LIKE cnp_file.cnp07,
                               cnp08  LIKE cnp_file.cnp08
                          END RECORD
           #No.MOD-490398  --end
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
   ORDER BY sr.coc03,sr.cod.cod02,sr1.cno01 #No.MOD-490398
  FORMAT
   PAGE HEADER
#No.FUN-580110 --start--
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT COLUMN (((g_len-FGL_WIDTH(g_x[1])))/2)+1 ,g_x[1]
      IF tm.choice = 'Y' THEN
         PRINT g_x[9] CLIPPED,sr.coc03
      ELSE
         PRINT
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw='N'
      LET l_last   ='Y'
       LET l_str = g_x[9]  #NO.MOD-490398 050228
 
#NO.FUN-550036-begin
           PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
                          g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46]
           PRINT g_dash1
 
    BEFORE GROUP OF sr.cod.cod02
           LET l_qty_tot = 0
           LET l_money_tot = 0
           LET l_last      = 'N'
 #NO.MOD-490398--begin
           LET l_last_sw = 'n'
           LET l_aco_total=sr.cod.cod05+sr.cod.cod10
 #NO.MOD-490398--050228--begin
#          LET l_input_total=(sr.cod.cod09+sr.cod.cod101+sr.cod.cod103+sr.cod.cod105+sr.cod.cod106)
#                             - sr.cod.cod104
           LET l_input_total=sr.cod.cod09+sr.cod.cod101+sr.cod.cod106-sr.cod.cod091-sr.cod.cod102
                              - sr.cod.cod104
 #NO.MOD-490398--050228--end
           LET l_aco_sub=l_aco_total-l_input_total
#           IF tm.choice = 'Y' THEN
            PRINTX name=D1
                 COLUMN g_c[31],sr.coc03 CLIPPED;
              IF tm.y = 'N' THEN
                 PRINTX name=D1
                   COLUMN g_c[32], sr.cod.cod02 USING '###&',#FUN-590118
                   COLUMN g_c[33],sr.cod.cod03 CLIPPED;
              ELSE
                 SELECT cob09 INTO sr.cob09 FROM cob_file WHERE cob01=sr.cod.cod03
                 PRINTX name=D1
                   COLUMN g_c[32], sr.cod.cod02 USING '&&&',
                   COLUMN g_c[33], sr.cob09 CLIPPED;
              END IF
              PRINTX name=D1
                    COLUMN g_c[34],sr.cob02 CLIPPED,
                    COLUMN g_c[35],sr.cob021 CLIPPED,
                    COLUMN g_c[36],sr.cod.cod06 CLIPPED,
                    COLUMN g_c[37],l_aco_total   USING '##########&.&&&' CLIPPED,
                    COLUMN g_c[38],l_input_total USING '##########&.&&&' CLIPPED,
                    COLUMN g_c[39],l_aco_sub     USING '##########&.&&&' CLIPPED;
 #NO.MOD-490398--end
 
   AFTER GROUP OF sr1.cno01
        IF tm.choice = 'Y' THEN
           CASE
                WHEN sr1.cno04='1' LET l_desc = g_x[23]
                WHEN sr1.cno04='2' LET l_desc = g_x[24]
                WHEN sr1.cno04='4' LET l_desc = g_x[26]
           END CASE
           IF sr1.cno031='2' THEN
              LET sr1.cnp05 =  sr1.cnp05 * -1
              LET sr1.cnp08 =  sr1.cnp08 * -1
           END IF
           #--取幣別
           SELECT UNIQUE azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
             FROM azi_file,coc_file,cno_file,cnp_file
            WHERE cnp01=sr1.cno01
              AND cnp01=cno01
               #AND cno10=coc04 #No.MOD-490398
               AND cno10=coc03 #No.MOD-490398
              AND azi01=coc02
 
 #NO.MOD-490398--begin
           PRINTX name=D1
                 COLUMN g_c[40],sr1.cno06 CLIPPED,
                 COLUMN g_c[41],sr1.cno07 CLIPPED,
                 COLUMN g_c[42],sr1.cno08 CLIPPED,
                 COLUMN g_c[43],l_desc CLIPPED,
                 COLUMN g_c[44],sr1.cnp05 USING '----------#.&&&' CLIPPED,
                 COLUMN g_c[45],cl_numfor(sr1.cnp07,45,g_azi03) CLIPPED,
                 COLUMN g_c[46],cl_numfor(sr1.cnp08,46,g_azi04) CLIPPED
 #NO.MOD-490398--end
           LET l_qty_tot = l_qty_tot + sr1.cnp05
           LET l_money_tot = l_money_tot + sr1.cnp08
        END IF
   AFTER GROUP OF sr.cod.cod02
#        IF tm.choice = 'Y' THEN
 
 #NO.MOD-490398--begin
            PRINTX name=S1
                  COLUMN g_c[42],g_x[22] CLIPPED,
                  COLUMN g_c[44],l_qty_tot USING '----------#.&&&',
                  COLUMN g_c[46],cl_numfor(l_money_tot,46,g_azi05)
 #NO.MOD-490398--end
            #--
#        END IF
#NO.FUN-550036-end
   ON LAST ROW
       LET l_last_sw = 'Y'
       PRINT g_dash[1,g_len] CLIPPED
       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
       IF l_last_sw = 'N'
         THEN PRINT g_dash[1,g_len] CLIPPED
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
       END IF
END REPORT}
#No.FUN-770006 --end--
