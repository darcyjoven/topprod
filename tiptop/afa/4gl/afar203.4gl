# Prog. Version..: '5.30.06-13.03.19(00010)'     #
#
# Pattern name...: afar203.4gl
# Descriptions...: 固定資產變動明細表
# Date & Author..: 96/06/12 By Charis
# Modify.........: No.CHI-480001 04/08/16 By Danny   新增大陸版報表段(減值準備)
# Modify.........: No.FUN-510035 05/01/18 By Smapmin 報表轉XML格式
# Modify.........: No.TQC-630156 06/03/27 By Smapmin 直接資本化視為本期增加
# Modify.........: No.FUN-660060 06/06/28 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-650148 06/07/06 By Smapmin 增加追溯功能
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0081 06/11/13 By baogui 日期不應該居中
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.MOD-730124 07/03/28 By Smapmin 恢復TQC-630156修改部份
#                                                    恢復FUN-650148修改部份
# Modify.........: No.TQC-760182 07/06/26 By chenl   增加報錯信息。
# Modify.........: No.TQC-770026 07/07/06 By Smapmin 恢復MOD-730124修改部份
# Modify.........: No.FUN-770033 07/08/03 By destiny 報表改為使用crystal report
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.MOD-980086 09/08/12 By Carrier 除去在期初前的已處置的資產
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A50109 10/05/20 By sabrina 累積折舊、帳面價值金額有誤
# Modify.........: No:MOD-A80142 10/08/20 By wujie   期初计算错误
# Modify.........: No:MOD-B20143 11/02/24 By wujie   资产净额没有抓本期数
# Modify.........: No:MOD-B30077 11/03/09 By Dido 截止年度需提示錯誤訊息 
# Modify.........: No:MOD-B40169 11/04/19 By Dido 第二段 FOREACH tmp04 應給予 tmp01 
# Modify.........: No:TQC-C50105 12/05/15 By xuxz “資產類型faj04”應可以開窗口選擇資料
# Modify.........: No:MOD-C30845 12/06/28 By Elise 取消g_faj14計算 
# Modify.........: No.CHI-C50014 12/06/28 By Elise 本期立帳不可任列到期初
# Modify.........: No:MOD-C70177 12/07/17 By Polly 需多考慮多部門分攤金額
# Modify.........: No:MOD-C90056 12/09/07 By suncx 修正CHI-C50014有關g_fap56s取值查詢條件的錯誤

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,       # Where condition       #No.FUN-680070 VARCHAR(1000)
	      yy1     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
	      mm1     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
	      yy2     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
	      mm2     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
              more    LIKE type_file.chr1           # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
           END RECORD,
          l_a1,l_a2,l_b1,l_b2   LIKE type_file.num20_6,      #No.FUN-680070 DEC(20,6)
          g_descripe ARRAY[3] OF LIKE type_file.chr20,   # Report Heading & prompt       #No.FUN-680070 VARCHAR(14)
          g_fap   RECORD    LIKE fap_file.*,
          g_tot_bal LIKE type_file.num20_6,      # User defined variable       #No.FUN-680070 DECIMAL(13,2)
          g_fan07  LIKE fan_file.fan07,  #分攤方式=(13)  折舊金額
          g_fan07n LIKE fan_file.fan07,  #分攤方式='2'   被分攤折舊金額
          g_fan07t  LIKE fan_file.fan07,     #分攤方式 ='2'  被分攤折舊金額  #MOD-C70177 add
          g_fap661 LIKE fap_file.fap661,
          g_fap55  LIKE fap_file.fap55,
          g_fap54  LIKE fap_file.fap54,
          g_fap56  LIKE fap_file.fap56,
          g_fap57  LIKE fap_file.fap57,
          g_fap57_1 LIKE fap_file.fap57,   #CHI-C50014 add
          g_fap54_1 LIKE fap_file.fap54,   #CHI-C50014 add
          g_fap540 LIKE fap_file.fap54,
          g_fap570 LIKE fap_file.fap57,
          g_fap661n LIKE fap_file.fap661,
          g_fap55n  LIKE fap_file.fap55,
          g_fap54n LIKE fap_file.fap54,
          g_fap56n LIKE fap_file.fap56,
          g_fap56s  LIKE fap_file.fap56,   #CHI-C50014 add
          g_fap57n LIKE fap_file.fap57,
          g_fap540n LIKE fap_file.fap54,
          g_fap570n LIKE fap_file.fap57,
          g_bdate1 LIKE type_file.dat,          #No.FUN-680070 DATE
          g_edate1 LIKE type_file.dat,          #No.FUN-680070 DATE
          g_bdate2 LIKE type_file.dat,          #No.FUN-680070 DATE
          g_edate2 LIKE type_file.dat,          #No.FUN-680070 DATE
          g_k     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          g_t1,g_t2,g_t3,g_t4   LIKE fap_file.fap45,      #No.CHI-480001
          g_t5,g_t6,g_t7,g_t8   LIKE fap_file.fap45,      #No.MOD-B20143
          g_fap45               LIKE fap_file.fap45,      #No.CHI-480001
          g_fap45n              LIKE fap_file.fap45,      #No.CHI-480001
          g_fap54d              LIKE fap_file.fap54,      #No.CHI-480001
          g_fap54e              LIKE fap_file.fap54       #No.CHI-480001
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.TQC-760182 add
DEFINE   g_faj14   LIKE faj_file.faj14   #TQC-770026
DEFINE   g_str           STRING                  #No.FUN-770033                                                                     
DEFINE   l_table         STRING                  #No.FUN-770033                                                                     
DEFINE   g_sql           STRING                  #No.FUN-770033
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
#No.FUN-770033--start--                                                                                                             
   LET g_sql="fab02.fab_file.fab02,",                                                                                              
             "faj04.faj_file.faj04,",                                                                                              
             "order1.type_file.chr1,",                                                                                              
             "tmp01.faj_file.faj60,",                                                                                            
             "tmp02.faj_file.faj60,",                                                                                              
             "tmp03.faj_file.faj60,",                                                                                              
             "tmp04.faj_file.faj60"
   LET l_table = cl_prt_temptable('afar203',g_sql) CLIPPED                                                                        
   IF l_table= -1 THEN EXIT PROGRAM END IF                                                                                        
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
             " VALUES(?,?,?,?, ?,?,?)"                                                                                         
   PREPARE insert_prep FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                  
      CALL cl_err('insert_prep',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                          
#No.FUN-770033--end--
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.yy1= ARG_VAL(8)
   LET tm.mm1= ARG_VAL(9)
   LET tm.yy2= ARG_VAL(10)
   LET tm.mm2= ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL afar203_tm(0,0)        # Input print condition
      ELSE CALL afar203()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afar203_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          l_cmd          LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 35
 
   OPEN WINDOW afar203_w AT p_row,p_col WITH FORM "afa/42f/afar203"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.yy2   = g_faa.faa07
   LET tm.mm2   = g_faa.faa08
WHILE TRUE
 
   CONSTRUCT BY NAME tm.wc ON faj04
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
         #TQC-C50105--add--str
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(faj04)   #資產類別
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_fab"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO faj04
                  NEXT FIELD faj04
            END CASE
         #TQC-C50105--add--end
 
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
      LET INT_FLAG = 0 CLOSE WINDOW afar203_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
   DISPLAY BY NAME tm.yy1,tm.mm1,tm.yy2,tm.mm2,tm.more
                  # Condition
   INPUT tm.yy1,tm.mm1,tm.yy2,tm.mm2,tm.more WITHOUT DEFAULTS
         FROM FORMONLY.yy1,FORMONLY.mm1,FORMONLY.yy2,FORMONLY.mm2,
              FORMONLY.more
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD yy1
         IF cl_null(tm.yy1) THEN NEXT FIELD FORMONLY.yy1 END IF
 
      AFTER FIELD mm1
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.mm1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy1
            IF g_azm.azm02 = 1 THEN
               IF tm.mm1 > 12 OR tm.mm1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm1
               END IF
            ELSE
               IF tm.mm1 > 13 OR tm.mm1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm1
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF cl_null(tm.mm1) THEN NEXT FIELD FORMONLY.mm1 END IF
 
      AFTER FIELD yy2
         IF cl_null(tm.yy2) THEN NEXT FIELD FORMONLY.yy2 END IF
         IF tm.yy2> g_faa.faa07  THEN    ##不可大於固定資產年度
            CALL cl_err('','afa-122',0)  #MOD-B30077
            NEXT FIELD FORMONLY.yy2
         END IF
 
      AFTER FIELD mm2
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.mm2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy2
            IF g_azm.azm02 = 1 THEN
               IF tm.mm2 > 12 OR tm.mm2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm2
               END IF
            ELSE
               IF tm.mm2 > 13 OR tm.mm2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm2
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF cl_null(tm.mm2) THEN NEXT FIELD FORMONLY.mm2 END IF
##No.3014 modify 1999/02/23
       # IF tm.mm2> g_faa.faa08  THEN    ##不可大於固定資產期別
       #    NEXT FIELD FORMONLY.mm2
       # END IF
         IF tm.yy2*12+tm.mm2 <  tm.yy1*12+tm.mm1 THEN
            NEXT FIELD yy2
         END IF
         IF tm.yy2*12+tm.mm2 > g_faa.faa07*12+g_faa.faa08 THEN
            LET g_msg = tm.yy2,'/',tm.mm2 CLIPPED   #No.TQC-760182 add
            CALL cl_err(g_msg,'afa-122',1)     #No.TQC-760182 add
            NEXT FIELD mm2
         END IF
##-------------------------------
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]"
            THEN NEXT FIELD FORMONLY.more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
      #-----TQC-860018---------
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      
      ON ACTION about         
         CALL cl_about()      
      
      ON ACTION help          
         CALL cl_show_help()  
      #-----END TQC-860018-----
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW afar203_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='afar203'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('afar203','9031',1)
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
                         " '",tm.yy1 CLIPPED,"'",
                         " '",tm.mm1 CLIPPED,"'",
                         " '",tm.yy2 CLIPPED,"'",
                         " '",tm.mm2 CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('afar203',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW afar203_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL afar203()
   ERROR ""
END WHILE
   CLOSE WINDOW afar203_w
END FUNCTION
 
FUNCTION afar203()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0069
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE za_file.za05,            #No.FUN-680070 VARCHAR(40)
          l_tmp04   LIKE faj_file.faj60,          # 本期累折
          l_order   ARRAY[5] OF LIKE type_file.chr20,     #No.FUN-680070 VARCHAR(10)
          sr        RECORD order1 LIKE type_file.chr1,    #列印區分類別     #No.FUN-680070 VARCHAR(1)
                           faj04  LIKE faj_file.faj04,    # 資產分類
                           faj02  LIKE faj_file.faj02,
                           faj022 LIKE faj_file.faj022,
                           fab02  LIKE fab_file.fab02,    #
                          #MOD-C90056 modify begin---------------------------
                          #tmp01  LIKE faj_file.faj56,    # 期初
                          #tmp02  LIKE faj_file.faj56,    # 本期增
                          #tmp03  LIKE faj_file.faj56,    # 本期處份
                          #tmp04  LIKE faj_file.faj56,    # 期末
                           tmp01  LIKE faj_file.faj60,    # 期初
                           tmp02  LIKE faj_file.faj60,    # 本期增
                           tmp03  LIKE faj_file.faj60,    # 本期處份
                           tmp04  LIKE faj_file.faj60,    # 期末
                          #MOD-C90056 modify end-----------------------------
                           faj14  LIKE faj_file.faj14,    #
                           faj141 LIKE faj_file.faj141,   #
                           faj59  LIKE faj_file.faj59,    #
                           faj32  LIKE faj_file.faj32,    #
                           faj60  LIKE faj_file.faj60,    #
                           faj101 LIKE faj_file.faj101,   #No.CHI-480001
                           faj102 LIKE faj_file.faj102    #No.CHI-480001
                    END RECORD
   DEFINE l_cnt     LIKE type_file.num5   #No.MOD-980086
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     CALL cl_del_data(l_table)                                   #No.FUN-770033
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                                         #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fajuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                                         #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fajgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN                            #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fajgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')
     #End:FUN-980030
 
     # 計算會計期間起迄日期
     CALL s_azn01(tm.yy1,tm.mm1) RETURNING g_bdate1,g_edate1
     CALL s_azn01(tm.yy2,tm.mm2) RETURNING g_bdate2,g_edate2
     LET l_sql = "SELECT '',",
                 "       faj04,faj02,faj022,fab02,",
                 "       0,0,0,0,faj14,faj141,faj59,faj32,faj60,",
                 "       faj101,faj102  ",                       #No.CHI-480001
                 "  FROM faj_file,OUTER fab_file",
                 " WHERE fajconf='Y' AND faj43<>'0' AND ",tm.wc CLIPPED,
                 " AND faj26 <='",g_edate2,"'",  #CHI-C50014 remark
                #" AND faj26 <= ? ",             #No.MOD-A80142   #CHI-C50014 mark
                 " AND faj_file.faj04 = fab_file.fab01 "
     PREPARE afar203_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar203_curs1 CURSOR FOR afar203_prepare1
    #-------------------------CHI-C50014----------------------------------------(S)
     LET l_sql = "SELECT '',",
                 "       faj04,faj02,faj022,fab02,",
                 "       0,0,0,0,faj14,faj141,faj59,faj32,faj60,",
                 "       faj101,faj102  ",
                 "  FROM faj_file,OUTER fab_file",
                 " WHERE fajconf = 'Y' ",
                 "  AND faj43 <> '0' ",
                 "  AND ",tm.wc CLIPPED,
                 "  AND faj26 < '",g_bdate1,"'",
                 "  AND faj_file.faj04 = fab_file.fab01 "
     PREPARE afar203_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
     END IF
     DECLARE afar203_curs2 CURSOR FOR afar203_prepare2
    #-------------------------CHI-C50014----------------------------------------(E)
#No.FUN-770033--start--
#     CALL cl_outnam('afar203') RETURNING l_name
#     START REPORT afar203_rep TO l_name
     LET g_pageno = 0
 
     FOREACH afar203_curs1 INTO sr.*                      #CHI-C50014 remark
    #FOREACH afar203_curs1 USING g_edate2 INTO sr.*       #No.MOD-A80142  #CHI-C50014 mark
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #No.MOD-980086  --Begin
       #---上線後(5)出售(6)銷帳報廢不包含(當年度處份者要納入)
       SELECT COUNT(*) INTO l_cnt FROM fap_file
        WHERE fap02=sr.faj02 AND fap021=sr.faj022
          AND fap77 IN ('5','6')   AND (YEAR(fap04) < tm.yy1  
          OR (YEAR(fap04) = tm.yy1 AND MONTH(fap04) < tm.mm1))
       IF l_cnt > 0 THEN CONTINUE FOREACH END IF
       #No.MOD-980086  --End  
       # 推算至起始日期之資產成本
       CALL r203_cal1(sr.*)
       # 推算至當期之資產成本
       CALL r203_cal2(sr.*)
       #-----TQC-770026---------
       LET g_faj14 = 0
       SELECT faj14 INTO g_faj14 FROM faj_file
          WHERE faj02=sr.faj02 AND faj022=sr.faj022 AND faj37='Y' AND
                faj26 >= g_bdate1 AND faj26 <= g_edate2
       IF cl_null(g_faj14) THEN LET g_faj14 = 0 END IF
       #-----END TQC-770026-----
 
       # 成本推算
       # 期初成本  資本化   (盤、出)  (改、重)
#No.MOD-A80142 --begin
#       LET sr.tmp01=sr.faj14+sr.faj141-sr.faj59 - g_fap661 +g_fap56
#                    - g_fap54 - g_fap540 #調整
#                    - g_faj14   #TQC-770026
       LET sr.tmp01 =0 
#No.MOD-A80142 --end
       LET sr.tmp02=g_fap661n+g_fap54n+g_fap540n
                    + g_faj14   #TQC-770026
       LET l_a1=sr.tmp01
       LET sr.tmp03=g_fap56n
       LET sr.tmp04=sr.tmp01+sr.tmp02-sr.tmp03
       LET l_b1=sr.tmp04
       LET sr.order1='1'
#      OUTPUT TO REPORT afar203_rep(sr.*)
       EXECUTE insert_prep USING
                           sr.fab02,sr.faj04,sr.order1,sr.tmp01,sr.tmp02,sr.tmp03,
                           sr.tmp04  
       # 累折推算
       # 期初累折                       資本化   (盤、出)   調整
       # 累積折舊之'本期增加'改抓 fan07
#No.MOD-A80142 --begin
#       LET sr.tmp01=sr.faj32-sr.faj60 - g_fap55 +
#                   #g_fap57 - g_fap570-g_fan07-g_fan07n   #MOD-A50109 mark
#                    g_fap57 - g_fan07-g_fan07n            #MOD-A50109 add
       LET sr.tmp01 =0 
#No.MOD-A80142 --end
       LET sr.tmp02=g_fan07
       LET l_a2=sr.tmp01
       LET sr.tmp03=g_fap57n
       LET sr.tmp04=sr.tmp01+sr.tmp02-sr.tmp03
       LET l_b2=sr.tmp04
       LET sr.order1='2'
#      OUTPUT TO REPORT afar203_rep(sr.*)
       EXECUTE insert_prep USING                                                                                                    
                           sr.fab02,sr.faj04,sr.order1,sr.tmp01,sr.tmp02,sr.tmp03,                                                   
                           sr.tmp04
       # 累折推算
       # 帳面累折
                        # 成本 - 累折
       LET sr.tmp01=l_a1-l_a2
       #LET sr.tmp02=(g_fap661n+g_fap54n+g_fap540n)-(g_fan07)   #TQC-770026
       LET sr.tmp02=(g_fap661n+g_fap54n+g_fap540n+g_faj14)-(g_fan07)   #TQC-770026
       #LET sr.tmp03= ' '    #TQC-770026
       LET sr.tmp03= g_fap56n-g_fap57n    #TQC-770026
       LET sr.tmp04=l_b1-l_b2
       LET sr.order1='3'
#      OUTPUT TO REPORT afar203_rep(sr.*)
       EXECUTE insert_prep USING                                                                                                    
                           sr.fab02,sr.faj04,sr.order1,sr.tmp01,sr.tmp02,sr.tmp03,                                                   
                           sr.tmp04
       #No.CHI-480001
       LET g_t1 = sr.tmp01
       LET g_t2 = sr.tmp04
#No.MOD-B20143 --begin
       LET g_t5 = sr.tmp02
       LET g_t6 = sr.tmp03
#No.MOD-B20143 --end
       IF cl_null(sr.faj101) THEN LET sr.faj101 = 0 END IF
       IF cl_null(sr.faj102) THEN LET sr.faj102 = 0 END IF
       IF g_aza.aza26 = '2' THEN		
          # 減值準備
#No.MOD-A80142 --begin
#          LET sr.tmp01=sr.faj101-sr.faj102+g_fap45-g_fap54d-g_fap54e
          LET sr.tmp01 =0 
#No.MOD-A80142 --end
          LET sr.tmp02=g_fap54d
          LET sr.tmp03=g_fap45n
          LET sr.tmp04=sr.tmp01+sr.tmp02-sr.tmp03
          LET sr.order1='4'
#         OUTPUT TO REPORT afar203_rep(sr.*)
          EXECUTE insert_prep USING                                                                                                    
                              sr.fab02,sr.faj04,sr.order1,sr.tmp01,sr.tmp02,sr.tmp03,                                                  
                              sr.tmp04
          LET g_t3 = sr.tmp01
          LET g_t4 = sr.tmp04
#No.MOD-B20143 --begin
          LET g_t7 = sr.tmp02
          LET g_t8 = sr.tmp03
#No.MOD-B20143 --end
          IF cl_null(g_t1) THEN LET g_t1 = 0 END IF
          IF cl_null(g_t2) THEN LET g_t2 = 0 END IF
          IF cl_null(g_t3) THEN LET g_t3 = 0 END IF
          IF cl_null(g_t4) THEN LET g_t4 = 0 END IF
#No.MOD-B20143 --begin
          IF cl_null(g_t5) THEN LET g_t5 = 0 END IF
          IF cl_null(g_t6) THEN LET g_t6 = 0 END IF
          IF cl_null(g_t7) THEN LET g_t7 = 0 END IF
          IF cl_null(g_t8) THEN LET g_t8 = 0 END IF
#No.MOD-B20143 --end
 
          # 資產淨額
          LET sr.tmp01=g_t1-g_t3               # 帳面價值 - 提列減值
#No.MOD-B20143 --begin
          #LET sr.tmp02=' '
          #LET sr.tmp03= ' '
          LET sr.tmp02=g_t5-g_t7
          LET sr.tmp03=g_t6-g_t8
#No.MOD-B20143 --end
          LET sr.tmp04=g_t2-g_t4
          LET sr.order1='5'
#         OUTPUT TO REPORT afar203_rep(sr.*)
          EXECUTE insert_prep USING                                                                                                    
                              sr.fab02,sr.faj04,sr.order1,sr.tmp01,sr.tmp02,sr.tmp03,                                                   
                              sr.tmp04
       END IF
       #end add
     END FOREACH
#No.MOD-A80142 --begin
    #FOREACH afar203_curs1 USING g_bdate1 INTO sr.*         #CHI-C50014 mark
     FOREACH afar203_curs2 INTO sr.*                        #CHI-C50014 add 
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #No.MOD-980086  --Begin
       #---上線後(5)出售(6)銷帳報廢不包含(當年度處份者要納入)
       SELECT COUNT(*) INTO l_cnt FROM fap_file
        WHERE fap02=sr.faj02 AND fap021=sr.faj022
          AND fap77 IN ('5','6')   AND (YEAR(fap04) < tm.yy1  
          OR (YEAR(fap04) = tm.yy1 AND MONTH(fap04) < tm.mm1))
       IF l_cnt > 0 THEN CONTINUE FOREACH END IF
       #No.MOD-980086  --End  
       # 推算至起始日期之資產成本
       CALL r203_cal1(sr.*)
       # 推算至當期之資產成本
       CALL r203_cal2(sr.*)
      #------MOD-C30845------------------------mark
      ##-----TQC-770026---------
      #LET g_faj14 = 0
      #SELECT faj14 INTO g_faj14 FROM faj_file
      #   WHERE faj02=sr.faj02 AND faj022=sr.faj022 AND faj37='Y' AND
      #         faj26 <= g_bdate1 
      #IF cl_null(g_faj14) THEN LET g_faj14 = 0 END IF
      ##-----END TQC-770026----- 
      #------MOD-C30845------------------------mark
 
       # 成本推算
       # 期初成本  資本化   (盤、出)  (改、重)

      #-------------------------MOD-C30845----------------------------(S)
      #LET sr.tmp01=sr.faj14+sr.faj141-sr.faj59 - g_fap661 +g_fap56
      #             - g_fap54 - g_fap540  #調整
      #             - g_faj14             #TQC-770026  
     #-------------------------CHI-C50014----------------------------(S)
     # LET sr.tmp01 = sr.faj14 + sr.faj141 - sr.faj59 - g_fap661
     #              + g_fap56n - g_fap54 - g_fap540
       LET sr.tmp01 = sr.faj14 + sr.faj141 - sr.faj59 - g_fap661
                    + g_fap56s - g_fap540 - g_fap54_1
     #-------------------------CHI-C50014----------------------------(E)
      #-------------------------MOD-C30845----------------------------(E)
       LET sr.tmp02=0
       LET l_a1=sr.tmp01
       LET sr.tmp03=0
      #LET sr.tmp04=0           #MOD-B40169 mark
       LET sr.tmp04=sr.tmp01    #MOD-B40169
      #LET l_b1=0               #MOD-B40169 mark
       LET l_b1=sr.tmp04        #MOD-B40169
       LET sr.order1='1'
       EXECUTE insert_prep USING
                           sr.fab02,sr.faj04,sr.order1,sr.tmp01,sr.tmp02,sr.tmp03,
                           sr.tmp04  
       # 累折推算
       # 期初累折                       資本化   (盤、出)   調整
       # 累積折舊之'本期增加'改抓 fan07
       LET sr.tmp01=sr.faj32-sr.faj60 - g_fap55 +
                   #g_fap57 - g_fap570-g_fan07-g_fan07n     #MOD-A50109 mark
                   #g_fap57 - g_fan07-g_fan07n              #MOD-A50109 add   #CHI-C50014 mark
                    g_fap57 - g_fan07 - g_fan07n+ g_fap57_1 #CHI-C50014 add

       LET sr.tmp02=0
       LET l_a2=sr.tmp01
       LET sr.tmp03=0
      #LET sr.tmp04=0           #MOD-B40169 mark
       LET sr.tmp04=sr.tmp01    #MOD-B40169
      #LET l_b2=0               #MOD-B40169 mark
       LET l_b2=sr.tmp04        #MOD-B40169
       LET sr.order1='2'
       EXECUTE insert_prep USING                                                                                                    
                           sr.fab02,sr.faj04,sr.order1,sr.tmp01,sr.tmp02,sr.tmp03,                                                   
                           sr.tmp04
       # 累折推算
       # 帳面累折
                        # 成本 - 累折
       LET sr.tmp01=l_a1-l_a2
       LET sr.tmp02= 0
       LET sr.tmp03= 0 
      #LET sr.tmp04= 0          #MOD-B40169 mark
       LET sr.tmp04=l_b1-l_b2   #MOD-B40169
       LET sr.order1='3'
       EXECUTE insert_prep USING                                                                                                    
                           sr.fab02,sr.faj04,sr.order1,sr.tmp01,sr.tmp02,sr.tmp03,                                                   
                           sr.tmp04
       #No.CHI-480001
       LET g_t1 = sr.tmp01
       LET g_t2 = sr.tmp04
#No.MOD-B20143 --begin
       LET g_t5 = sr.tmp02
       LET g_t6 = sr.tmp03
#No.MOD-B20143 --end
       IF cl_null(sr.faj101) THEN LET sr.faj101 = 0 END IF
       IF cl_null(sr.faj102) THEN LET sr.faj102 = 0 END IF
       IF g_aza.aza26 = '2' THEN		
          # 減值準備
          LET sr.tmp01=sr.faj101-sr.faj102+g_fap45-g_fap54d-g_fap54e
          LET sr.tmp02= 0
          LET sr.tmp03= 0
         #LET sr.tmp04= 0                            #MOD-B40169 mark
          LET sr.tmp04=sr.tmp01+sr.tmp02-sr.tmp03    #MOD-B40169
          LET sr.order1='4'
          EXECUTE insert_prep USING                                                                                                    
                              sr.fab02,sr.faj04,sr.order1,sr.tmp01,sr.tmp02,sr.tmp03,                                                  
                              sr.tmp04
          LET g_t3 = sr.tmp01
          LET g_t4 = sr.tmp04
#No.MOD-B20143 --begin
          LET g_t7 = sr.tmp02
          LET g_t8 = sr.tmp03
#No.MOD-B20143 --end
          IF cl_null(g_t1) THEN LET g_t1 = 0 END IF
          IF cl_null(g_t2) THEN LET g_t2 = 0 END IF
          IF cl_null(g_t3) THEN LET g_t3 = 0 END IF
          IF cl_null(g_t4) THEN LET g_t4 = 0 END IF
#No.MOD-B20143 --begin
          IF cl_null(g_t5) THEN LET g_t5 = 0 END IF
          IF cl_null(g_t6) THEN LET g_t6 = 0 END IF
          IF cl_null(g_t7) THEN LET g_t7 = 0 END IF
          IF cl_null(g_t8) THEN LET g_t8 = 0 END IF
#No.MOD-B20143 --end
 
          # 資產淨額
          LET sr.tmp01=g_t1-g_t3               # 帳面價值 - 提列減值
#No.MOD-B20143 --begin
          #LET sr.tmp02=' '
          #LET sr.tmp03= ' '
          LET sr.tmp02=g_t5-g_t7
          LET sr.tmp03=g_t6-g_t8
#No.MOD-B20143 --end
          LET sr.tmp04=g_t2-g_t4
          LET sr.order1='5'
          EXECUTE insert_prep USING                                                                                                    
                              sr.fab02,sr.faj04,sr.order1,sr.tmp01,sr.tmp02,sr.tmp03,                                                   
                              sr.tmp04
       END IF
     END FOREACH
#No.MOD-A80142 --end 
#     FINISH REPORT afar203_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
      SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   
      IF g_zz05 = 'Y' THEN                                                                                                           
         CALL cl_wcchp(tm.wc,'faj04')                                                            
         RETURNING tm.wc                                                                                                             
         LET g_str = tm.wc                                                                                                           
      END IF
      LET g_str=tm.yy1,";",tm.mm1 USING '&&',";",tm.yy2,";",tm.mm2 USING '&&',";",g_azi05,";",g_str
      LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                 
      CALL cl_prt_cs3('afar203','afar203',g_sql,g_str)
#No.FUN-770033--end--
END FUNCTION
 
# 推算至起始日期之資產成本、累折
FUNCTION r203_cal1(sr)
 DEFINE  sr               RECORD order1 LIKE type_file.chr1,        #列印區分類別       #No.FUN-680070 VARCHAR(1)
                                 faj04  LIKE faj_file.faj04,    # 資產分類
                                 faj02  LIKE faj_file.faj02,
                                 faj022 LIKE faj_file.faj022,
                                 fab02  LIKE fab_file.fab02,    #
                                 tmp01  LIKE faj_file.faj56,    # 期初
                                 tmp02  LIKE faj_file.faj56,    # 本期增
                                 tmp03  LIKE faj_file.faj56,    # 本期處份
                                 tmp04  LIKE faj_file.faj56,    # 期末
                                 faj14  LIKE faj_file.faj14,    #
                                 faj141 LIKE faj_file.faj141,    #
                                 faj59  LIKE faj_file.faj59,    #
                                 faj32  LIKE faj_file.faj32,    #
                                 faj60  LIKE faj_file.faj60,    #
                                 faj101 LIKE faj_file.faj101,   #No.CHI-480001
                                 faj102 LIKE faj_file.faj102    #No.CHI-480001
                       END RECORD
       # 資本化
       SELECT SUM(fap661),SUM(fap55) INTO g_fap661,g_fap55
          FROM fap_file
          WHERE fap03='1' 
            AND fap02=sr.faj02 
            AND fap021=sr.faj022 
           #AND fap04<=g_bdate1   #No.MOD-A80142        #CHI-C50014 mark
            AND fap04 >g_bdate1                         #CHI-C50014 add
       IF cl_null(g_fap661) THEN LET g_fap661=0  END IF
       IF cl_null(g_fap55) THEN LET g_fap55=0  END IF
       # 盤點、出售、報廢、銷帳
       SELECT SUM(fap56),SUM(fap57) INTO g_fap56,g_fap57 FROM fap_file
           WHERE fap03 IN ('2','4','5','6') AND fap02=sr.faj02 AND fap021=sr.faj022
                AND fap04<=g_bdate1   #No.MOD-A80142
       IF cl_null(g_fap56) THEN LET g_fap56=0  END IF
       IF cl_null(g_fap57) THEN LET g_fap57=0  END IF
      #----------------------CHI-C50014--------------------(S)
        SELECT SUM(fap57) INTO g_fap57_1
          FROM fap_file
         WHERE fap03 IN ('2','4','5','6')
           AND fap02 = sr.faj02
           AND fap021 = sr.faj022
           AND fap04 > g_bdate1
       IF cl_null(g_fap57_1) THEN LET g_fap57_1=0  END IF
      #----------------------CHI-C50014--------------------(E)
       # 改良、重估
       SELECT SUM(fap54) INTO g_fap54 FROM fap_file
          WHERE fap03 IN ('7','8') AND fap02=sr.faj02 AND fap021=sr.faj022 AND
           fap04<=g_bdate1   #No.MOD-A80142
       IF cl_null(g_fap54) THEN LET g_fap54=0  END IF
      #----------------------CHI-C50014--------------------(S)
       SELECT SUM(fap54) INTO g_fap54_1
         FROM fap_file
        WHERE fap03 IN ('7','8')
          AND fap02 = sr.faj02
          AND fap021 = sr.faj022
          AND fap04 > g_bdate1
       IF cl_null(g_fap54_1) THEN LET g_fap54_1 = 0  END IF
      #----------------------CHI-C50014--------------------(E)
       # 調整
       SELECT SUM(fap54),SUM(fap57) INTO g_fap540,g_fap570  FROM fap_file
          WHERE fap03 IN ('9') AND fap02=sr.faj02 AND fap021=sr.faj022 AND
           fap04<=g_bdate1   #No.MOD-A80142
       IF cl_null(g_fap540) THEN LET g_fap540=0  END IF
       IF cl_null(g_fap570) THEN LET g_fap570=0  END IF
 
       # 出售、報廢、銷帳之減值準備
       #No.CHI-480001
       SELECT SUM(fap45) INTO g_fap45 FROM fap_file
        WHERE fap03 matches '[456]' AND fap02=sr.faj02 AND fap021=sr.faj022
          AND fap04<=g_bdate1   #No.MOD-A80142
       IF cl_null(g_fap45) THEN LET g_fap45=0 END IF
       #end
 
END FUNCTION
 
# 推算當期之資產成本、累折
FUNCTION r203_cal2(sr)
 DEFINE  sr               RECORD order1 LIKE type_file.chr1,        #列印區分類別       #No.FUN-680070 VARCHAR(1)
                                 faj04  LIKE faj_file.faj04,    # 資產分類
                                 faj02  LIKE faj_file.faj02,
                                 faj022 LIKE faj_file.faj022,
                                 fab02  LIKE fab_file.fab02,    #
                                 tmp01  LIKE faj_file.faj56,    # 期初
                                 tmp02  LIKE faj_file.faj56,    # 本期增
                                 tmp03  LIKE faj_file.faj56,    # 本期處份
                                 tmp04  LIKE faj_file.faj56,    # 期末
                                 faj14  LIKE faj_file.faj14,    #
                                 faj141 LIKE faj_file.faj141,    #
                                 faj59  LIKE faj_file.faj59,    #
                                 faj32  LIKE faj_file.faj32,    #
                                 faj60  LIKE faj_file.faj60,    #
                                 faj101 LIKE faj_file.faj101,   #No.CHI-480001
                                 faj102 LIKE faj_file.faj102    #No.CHI-480001
                       END RECORD
       #Modify :
         SELECT SUM(fan07) INTO g_fan07 FROM fan_file
          WHERE fan01 = sr.faj02 AND fan02 = sr.faj022
           #AND fan041 = '1'            #MOD-A50109 mark
            AND fan041 IN ('1','2')     #MOD-A50109 add 
            AND fan05 !='2'
            AND mdy(fan04,1,fan03) BETWEEN g_bdate1 AND g_edate2
         IF cl_null(g_fan07)  THEN LET g_fan07 = 0 END IF
         SELECT SUM(fan07) INTO g_fan07n FROM fan_file
          WHERE fan01 = sr.faj02 AND fan02 = sr.faj022
            AND fan05 !='2'
           #AND fan041 = '1'            #MOD-A50109 mark
            AND fan041 IN ('1','2')     #MOD-A50109 add 
            AND mdy(fan04,1,fan03) > g_edate2   
         IF cl_null(g_fan07n) THEN LET g_fan07n = 0 END IF
      #-------------------------------MOD-C70177------------------(S)
         SELECT SUM(fan07) INTO g_fan07t
           FROM fan_file
         WHERE fan01 = sr.faj02
           AND fan02 = sr.faj022
           AND fan05 ='2'
           AND fan041 = '2'
           AND mdy(fan04,1,fan03) BETWEEN g_bdate1 AND g_edate2
         IF cl_null(g_fan07t) THEN LET g_fan07t = 0 END IF
         LET g_fan07 = g_fan07 + g_fan07t
      #-------------------------------MOD-C70177------------------(E)
       # 資本化
       SELECT SUM(fap661),SUM(fap55) INTO g_fap661n,g_fap55n
          FROM fap_file
          WHERE fap03='1' AND fap02=sr.faj02 AND fap021=sr.faj022 AND
           fap04 between g_bdate1 and g_edate2
       IF cl_null(g_fap661n) THEN LET g_fap661n=0  END IF
       IF cl_null(g_fap55n) THEN LET g_fap55n=0  END IF
       # 盤點、出售、報廢、銷帳
       SELECT SUM(fap56),SUM(fap57) INTO g_fap56n,g_fap57n 
         FROM fap_file
        WHERE fap03 IN ('2','4','5','6') 
          AND fap02=sr.faj02 
          AND fap021=sr.faj022
          AND fap04 between g_bdate1 and g_edate2

       IF cl_null(g_fap56n) THEN LET g_fap56n=0  END IF
       IF cl_null(g_fap57n) THEN LET g_fap57n=0  END IF
      #---------------------------CHI-C50014-----------------(S)
       SELECT SUM(fap56) INTO g_fap56s
         FROM fap_file,faj_file
        WHERE fap03 IN ('2','4','5','6')
          AND fap02=sr.faj02
          AND fap021=sr.faj022
         #AND fap04 between g_bdate1 AND g_edate2     #MOD-C90056 mark
          AND fap04 > g_bdate1                        #MOD-C90056
          AND fap02 = faj02
          AND fap021 = faj022
          AND faj26 < g_bdate1

       IF cl_null(g_fap56s) THEN LET g_fap56s=0  END IF
      #---------------------------CHI-C50014-----------------(E)
 
       # 改良、重估
       SELECT SUM(fap54) INTO g_fap54n FROM fap_file
          WHERE fap03 IN ('7','8') AND fap02=sr.faj02 AND fap021=sr.faj022 AND
                fap04 between g_bdate1 and g_edate2
       IF cl_null(g_fap54n) THEN LET g_fap54n=0  END IF
       # 調整
       SELECT SUM(fap54),SUM(fap57) INTO g_fap540n,g_fap570n  FROM fap_file
          WHERE fap03 IN ('9') AND fap02=sr.faj02 AND fap021=sr.faj022 AND
           fap04 between g_bdate1 and g_edate2
       IF cl_null(g_fap540n) THEN LET g_fap540n=0  END IF
       IF cl_null(g_fap570n) THEN LET g_fap570n=0  END IF
 
       #No.CHI-480001
       #出售、報廢、銷帳之減值準備
       SELECT SUM(fap45) INTO g_fap45n FROM fap_file
        WHERE fap03 matches '[456]' AND fap02=sr.faj02 AND fap021=sr.faj022
          AND fap04 between g_bdate1 and g_edate2
       IF cl_null(g_fap45n) THEN LET g_fap45n=0  END IF
       #減值準備
       SELECT SUM(fap54) INTO g_fap54d FROM fap_file
        WHERE fap03 matches '[D]' AND fap02=sr.faj02 AND fap021=sr.faj022
          AND fap04 between g_bdate1 and g_edate2
       IF cl_null(g_fap54d) THEN LET g_fap54d=0 END IF
       SELECT SUM(fap54) INTO g_fap54e FROM fap_file
        WHERE fap03 matches '[D]' AND fap02=sr.faj02 AND fap021=sr.faj022
          AND fap04 > g_edate2
       IF cl_null(g_fap54e) THEN LET g_fap54e=0 END IF
       #end
END FUNCTION
#No.FUN-77033--start-- 
{REPORT afar203_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          sr               RECORD order1 LIKE type_file.chr1,        #列印區分類別       #No.FUN-680070 VARCHAR(1)
                                  faj04  LIKE faj_file.faj04,    # 資產分類
                                  faj02  LIKE faj_file.faj02,
                                  faj022 LIKE faj_file.faj022,
                                  fab02  LIKE fab_file.fab02,    #
                                  tmp01  LIKE faj_file.faj56,    # 期初
                                  tmp02  LIKE faj_file.faj56,    # 本期增
                                  tmp03  LIKE faj_file.faj56,    # 本期處份
                                  tmp04  LIKE faj_file.faj56,    # 期末
                                  faj14  LIKE faj_file.faj14,    #
                                  faj141 LIKE faj_file.faj141,    #
                                  faj59  LIKE faj_file.faj59,    #
                                  faj32  LIKE faj_file.faj32,    #
                                  faj60  LIKE faj_file.faj60,    #
                                  faj101 LIKE faj_file.faj101,   #No.CHI-480001
                                  faj102 LIKE faj_file.faj102    #No.CHI-480001
                        END RECORD,
      l_amt        LIKE type_file.num20_6,      #No.FUN-680070 DECIMAL(17,5)
      l_chr        LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      g_head1      STRING,
      str          STRING
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.faj04
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      LET g_head1 = g_x[8] CLIPPED,tm.yy1 CLIPPED,g_x[15] CLIPPED,tm.mm1 USING '&&',
                    g_x[16] CLIPPED,g_x[17] CLIPPED,tm.yy2 CLIPPED,
                    g_x[15] CLIPPED,tm.mm2 USING '&&',g_x[16] CLIPPED
      PRINT g_head1                                        #FUN-660060 remark    #TQC-6A0081
 #    PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)+1,g_head1 #FUN-660060          #TQC-6A0081 mark
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      CASE
         WHEN sr.order1='1'
              PRINT g_x[9]
         WHEN sr.order1='2'
              PRINT g_x[10]
         WHEN sr.order1='3'
              PRINT g_x[11]
         #No.CHI-480001
         WHEN sr.order1='4'
              PRINT g_x[12]
         WHEN sr.order1='5'
              PRINT g_x[13]
         #end
      END CASE
 
   AFTER GROUP OF sr.faj04
         LET str = sr.faj04,' ',sr.fab02[1,12]
         PRINT
            COLUMN g_c[31],str,
            COLUMN g_c[32],cl_numfor(GROUP SUM(sr.tmp01),32,g_azi05),
            COLUMN g_c[33],cl_numfor(GROUP SUM(sr.tmp02),33,g_azi05),
            COLUMN g_c[34],cl_numfor(GROUP SUM(sr.tmp03),34,g_azi05),
            COLUMN g_c[35],cl_numfor(GROUP SUM(sr.tmp04),35,g_azi05)
 
   AFTER GROUP OF sr.order1
         PRINT COLUMN g_c[31],g_x[14] CLIPPED,
               COLUMN g_c[32],cl_numfor(GROUP SUM(sr.tmp01),32,g_azi05),
               COLUMN g_c[33],cl_numfor(GROUP SUM(sr.tmp02),33,g_azi05),
               COLUMN g_c[34],cl_numfor(GROUP SUM(sr.tmp03),34,g_azi05),
               COLUMN g_c[35],cl_numfor(GROUP SUM(sr.tmp04),35,g_azi05)
         PRINT
 
   ON LAST ROW
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-770033--end--
