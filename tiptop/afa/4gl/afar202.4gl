# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: afar202.4gl
# Descriptions...: 固定資產新增明細表
# Date & Author..: 96/06/10 By Lynn
# Modify.........: No.FUN-510035 05/01/18 By Smapmin 報表轉XML格式
# Modify.........: NO.FUN-550034 05/05/28 By ice 單據編號加大
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By Jackho  本（原）幣取位修改
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0009 06/12/05 By Rayven 報表打印格式調整
# Modify.........: No.FUN-770033 07/08/02 By destiny 報表改為使用crystal report
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0179 09/12/29 By tsai_yen EXECUTE裡不可有擷取字串的中括號[]
# Modify.........: No:FUN-C30104 12/03/20 By Sakura 增加"列印項目"1.財簽、2.財簽二
# Modify.........: No.MOD-D10255 13/01/30 By Polly  調整分頁tm.t參數的傳遞
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,   # Where condition       #No.FUN-680070 VARCHAR(1000)
              bdate   LIKE type_file.dat,          #No.FUN-680070 DATE
              edate   LIKE type_file.dat,          #No.FUN-680070 DATE
              s       LIKE type_file.chr3,      # Order by sequence       #No.FUN-680070 VARCHAR(3)
              t       LIKE type_file.chr3,      # Eject sw       #No.FUN-680070 VARCHAR(3)
              v       LIKE type_file.chr3,      # Group total sw       #No.FUN-680070 VARCHAR(3)
              p       LIKE type_file.chr1,      #FUN-C30104 add  #列印項目
              more    LIKE type_file.chr1       # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
              END RECORD,
           g_descripe ARRAY[7] OF LIKE type_file.chr20,   # Report Heading & prompt       #No.FUN-680070 VARCHAR(14)
           g_tot_bal  LIKE type_file.num20_6,   # User defined variable       #No.FUN-680070 (13,2)
           g_k        LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
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
    LET g_sql="faj02.faj_file.faj02,",                                                                                              
              "faj022.faj_file.faj022,",                                                                                            
              "faj04.faj_file.faj04,",                                                                                              
              "faj05.faj_file.faj05,",                                                                                              
              "faj06.faj_file.faj06,",                                                                                              
              "faj07.faj_file.faj07,",                                                                                              
              "faj08.faj_file.faj08,",                                                                                              
              "faj14.faj_file.faj14,",                                                                                              
              "faj15.faj_file.faj15,",                                                                                              
              "faj16.faj_file.faj16,",                                                                                              
              "faj17.faj_file.faj17,",                                                                                              
              "faj19.faj_file.faj19,",                                                                                              
              "faj20.faj_file.faj20,",                                                                                              
              "faj26.faj_file.faj26,",                                                                                              
              "faj27.faj_file.faj27,",                                                                                              
              "faj27_1.faj_file.faj27,",                                                                                              
              "faj29.faj_file.faj29,",                                                                                              
              "faj45.faj_file.faj45,",                                                                                              
              "faj47.faj_file.faj47,",
              "faj51.faj_file.faj51,",
              "faj52.faj_file.faj52,",
              "gen02.gen_file.gen02,",
              "l_pmc03.pmc_file.pmc03,",
              "t_azi04.azi_file.azi04"
     LET l_table = cl_prt_temptable('afar202',g_sql) CLIPPED                                                                        
     IF l_table= -1 THEN EXIT PROGRAM END IF                                                                                        
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?, ?,?,?,?,",                                                                                         
               "        ?,?,?,?, ?,?,?,?,",                                                                                         
               "        ?,?,?,?, ?,?,?,?)"                                                                                              
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
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.s  = ARG_VAL(10)
   LET tm.t  = ARG_VAL(11)
   LET tm.v  = ARG_VAL(12)
   LET tm.p  = ARG_VAL(13)   #FUN-C30104 add
  #FUN-C30104---mark--START
  ##No:FUN-570264 --start--
  #LET g_rep_user = ARG_VAL(13)
  #LET g_rep_clas = ARG_VAL(14)
  #LET g_template = ARG_VAL(15)
  #LET g_rpt_name = ARG_VAL(16)  #No:FUN-7C0078
  ##No:FUN-570264 ---end---
  #FUN-C30104---mark--END
  #FUN-C30104---add--START
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No:FUN-7C0078
  #FUN-C30104---add--END
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL afar202_tm(0,0)        # Input print condition
      ELSE CALL afar202()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afar202_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 12
 
   OPEN WINDOW afar202_w AT p_row,p_col WITH FORM "afa/42f/afar202"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET tm.p    = '1' #FUN-C30104 add
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
   LET tm2.u1   = tm.v[1,1]
   LET tm2.u2   = tm.v[2,2]
   LET tm2.u3   = tm.v[3,3]
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
      CONSTRUCT BY NAME tm.wc ON faj04,faj05,faj02,faj022,faj20,faj19,faj14
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
         LET INT_FLAG = 0 CLOSE WINDOW afar202_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
         INPUT BY NAME
            tm.bdate,tm.edate,tm2.s1,tm2.s2,tm2.s3,
            tm2.t1,tm2.t2,tm2.t3,tm2.u1,tm2.u2,tm2.u3,tm.p,tm.more #FUN-C30104 add tm.p
            WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
            AFTER FIELD bdate
               IF tm.bdate IS NULL THEN
                  NEXT FIELD FORMONLY.bdate
               END IF
 
            AFTER FIELD edate
               IF tm.edate IS NULL THEN
                  NEXT FIELD FORMONLY.edate
               END IF
               IF tm.edate < tm.bdate THEN
                  CALL cl_err(tm.edate,'aap-100',0)
                  NEXT FIELD FORMONLY.edate
               END IF
 
           #FUN-C30104 add START
            AFTER FIELD p
               IF tm.p NOT MATCHES "[12]" OR cl_null(tm.p) THEN
                  NEXT FIELD p
               END IF
           #FUN-C30104 add END
 
            AFTER FIELD more
               IF tm.more NOT MATCHES "[YN]" THEN
                  NEXT FIELD FORMONLY.more
               END IF
               IF tm.more = 'Y' THEN
                  CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
               END IF
            ON ACTION CONTROLZ
               CALL cl_show_req_fields()
            ON ACTION CONTROLG
               CALL cl_cmdask()    # Command execution
 
            AFTER INPUT
               LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
               LET tm.t = tm2.t1,tm2.t2,tm2.t3
               LET tm.v = tm2.u1,tm2.u2,tm2.u3
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
         LET INT_FLAG = 0 CLOSE WINDOW afar202_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar202'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar202','9031',1)
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
                            " '",tm.s CLIPPED,"'",
                            " '",tm.t CLIPPED,"'",
                            " '",tm.v CLIPPED,"'" ,
                            " '",tm.p CLIPPED,"'", #FUN-C30104 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afar202',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW afar202_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar202()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW afar202_w
END FUNCTION
 
FUNCTION afar202()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0069
         #l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_sql     STRING,                       #FUN-C30104 add
          l_chr     LIKE type_file.chr1,          #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680070 VARCHAR(40)
          l_order    ARRAY[5] OF LIKE type_file.chr21,                       #No.FUN-550034       #No.FUN-680070 VARCHAR(16)
          sr               RECORD order1 LIKE type_file.chr21,               #No.FUN-550034       #No.FUN-680070 VARCHAR(16)
                                  order2 LIKE type_file.chr21,               #No.FUN-550034       #No.FUN-680070 VARCHAR(16)
                                  order3 LIKE type_file.chr21,               #No.FUN-550034       #No.FUN-680070 VARCHAR(16)
                                  faj04 LIKE faj_file.faj04,    # 資產分類
                                  faj05 LIKE faj_file.faj05,    # 資產分類
                                  fab02 LIKE fab_file.fab02,    #
                                  faj02 LIKE faj_file.faj02,    # 財產編號
                                  faj022 LIKE faj_file.faj022,  # 財產附號
                                  faj20 LIKE faj_file.faj20,    # 保管部門
                                  faj19 LIKE faj_file.faj19,    # 保管人
                                  gen02 LIKE gen_file.gen02,    #
                                  faj07 LIKE faj_file.faj07,    # 英文名稱
                                  faj06 LIKE faj_file.faj06,    # 中文名稱
                                  faj17 LIKE faj_file.faj17,    # 數量
                                  faj08 LIKE faj_file.faj08,    # 規格型號
                                  faj26 LIKE faj_file.faj26,    # 入帳日期
                                  faj27 LIKE faj_file.faj27,    # 折舊年月
                                  faj29 LIKE faj_file.faj29,    # 耐用年限
                                  faj14 LIKE faj_file.faj14,    # 本幣成本
                                  faj16 LIKE faj_file.faj16,    # 原幣金額
                                  faj15 LIKE faj_file.faj15,    # 幣別
                                  faj10 LIKE faj_file.faj10,    # 廠商
                                  faj47 LIKE faj_file.faj47,    # 採購單
                                  faj51 LIKE faj_file.faj51,    # 發票號碼
                                  faj49 LIKE faj_file.faj49,    # 進口編號
                                  faj52 LIKE faj_file.faj52,    # 傳票號碼
                                  faj45 LIKE faj_file.faj45     # 帳款號碼
                        END RECORD
   DEFINE l_pmc03    LIKE pmc_file.pmc03     #No.FUN-770033
   ###TQC-9C0179 START ###
   DEFINE l_faj27_1 LIKE faj_file.faj27  
   DEFINE l_faj27_2 LIKE faj_file.faj27
   ###TQC-9C0179 END ###
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    #No.FUN-770033 
     CALL cl_del_data(l_table)                                   #No.FUN-770033 
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                                        #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fajuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                                        #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fajgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN                           #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fajgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')
     #End:FUN-980030

     IF tm.p = '1' THEN #FUN-C30104 add
        LET l_sql = "SELECT '','','',",
                    " faj04, faj05, fab02,",
                    " faj02,faj022,faj20,faj19,gen02,faj07,faj06,faj17,",
                    " faj08,faj26,faj27,faj29,faj14,faj16,",
                    " faj15,faj10,faj47,faj51,faj49,faj52,faj45",
                    "  FROM faj_file,OUTER fab_file,OUTER gen_file",
                    " WHERE fajconf='Y' AND faj43 != 'X' AND ",
                    " faj_file.faj04 = fab_file.fab01 AND faj_file.faj19 = gen_file.gen01 AND ",tm.wc CLIPPED,
                    " AND faj26 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
    #FUN-C30104---add---START
     ELSE
        LET l_sql = "SELECT '','','',",
                    " faj04, faj05, fab02,",
                    " faj02,faj022,faj20,faj19,gen02,faj07,faj06,faj17,",
                    " faj08,faj262,faj272,faj292,faj14,faj16,",
                    " faj15,faj10,faj47,faj51,faj49,faj52,faj45",
                    "  FROM faj_file,OUTER fab_file,OUTER gen_file",
                    " WHERE fajconf='Y' AND faj43 != 'X' AND ",
                    " faj_file.faj04 = fab_file.fab01 AND faj_file.faj19 = gen_file.gen01 AND ",tm.wc CLIPPED,
                    " AND faj26 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
     END IF
    #FUN-C30104---add---END 
     PREPARE afar202_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar202_curs1 CURSOR FOR afar202_prepare1
 
#No.FUN-770033--start--
#    CALL cl_outnam('afar202') RETURNING l_name
#     START REPORT afar202_rep TO l_name
     LET g_pageno = 0
 
     FOREACH afar202_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF NOT (cl_null(sr.faj15) or sr.faj15=g_aza.aza17 )
       THEN LET  sr.faj51=sr.faj49
       END IF
     
     SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=sr.faj10                                                                  
     IF SQLCA.sqlcode THEN LET l_pmc03=sr.faj10 END IF                                                                             
     SELECT azi04 INTO t_azi04 FROM azi_file                                              
       WHERE azi01=sr.faj15
      {FOR g_i = 1 TO 3
        CASE
          WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj04
                                   LET g_descripe[g_i]=g_x[11]
          WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.faj05
                                   LET g_descripe[g_i]=g_x[10]
          WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.faj02
                                   LET g_descripe[g_i]=g_x[12]
          WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.faj022
                                   LET g_descripe[g_i]=g_x[9]
          WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.faj20
                                   LET g_descripe[g_i]=g_x[13]
          WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.faj19
                                   LET g_descripe[g_i]=g_x[14]
          WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.faj14
                                   LET g_descripe[g_i]=g_x[15]
          OTHERWISE LET l_order[g_i] = '-'
        END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       OUTPUT TO REPORT afar202_rep(sr.*)}

     ###TQC-9C0179 START ###
     LET l_faj27_1 = sr.faj27[1,4]
     LET l_faj27_2 = sr.faj27[5,6]
     ###TQC-9C0179 END ###
     EXECUTE insert_prep USING                                                                                                      
                         sr.faj02,sr.faj022,sr.faj04,sr.faj05,sr.faj06,sr.faj07,                                                    
                         sr.faj08,sr.faj14,sr.faj15,sr.faj16,sr.faj17,sr.faj19,                                           
                         #sr.faj20,sr.faj26,sr.faj27[1,4],sr.faj27[5,6],sr.faj29, #TQC-9C0179 mark
                         sr.faj20,sr.faj26,l_faj27_1,l_faj27_2,sr.faj29,          #TQC-9C0179
                         sr.faj45,sr.faj47,sr.faj51,sr.faj52,sr.gen02,l_pmc03,
                         t_azi04
 
     END FOREACH
 
#     FINISH REPORT afar202_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     IF g_zz05 = 'Y' THEN                                                                                                           
       CALL cl_wcchp(tm.wc,'faj04,faj05,faj02,faj022,faj20,faj19,faj14')                                     
        RETURNING tm.wc                                                                                                             
        LET g_str = tm.wc                                                                                                           
     END IF 
    #---------------------------MOD-D10255------------------------------(S)
    #--MOD-D10255--mark
    #LET g_str=g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t[1,1],";",
    #           tm.t[2,2],";",tm.t[3,3],";",tm.v[1,1],";",tm.v[2,2],";",tm.v[3,3],";",
    #           g_azi04,";",g_azi05
    #--MOD-D10255--mark
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",
                 tm.t,";",tm.t,";",tm.v[1,1],";",tm.v[2,2],";",tm.v[3,3],";",
                 g_azi04,";",g_azi05
    #---------------------------MOD-D10255------------------------------(E)
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                               
     CALL cl_prt_cs3('afar202','afar202',g_sql,g_str) 
#No.FUN-770033--end--
END FUNCTION
 
#No.FUN-770033--start--
{REPORT afar202_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,                 #No.FUN-680070 VARCHAR(1)
          sr           RECORD order1 LIKE type_file.chr21,  #No.FUN-550034       #No.FUN-680070 VARCHAR(16)
                              order2 LIKE type_file.chr21,  #No.FUN-550034       #No.FUN-680070 VARCHAR(16)
                              order3 LIKE type_file.chr21,  #No.FUN-550034       #No.FUN-680070 VARCHAR(16)
                              faj04 LIKE faj_file.faj04,    # 資產分類
                              faj05 LIKE faj_file.faj05,    # 資產分類
                              fab02 LIKE fab_file.fab02,    #
                              faj02 LIKE faj_file.faj02,    # 財產編號
                              faj022 LIKE faj_file.faj022,  # 財產附號
                              faj20 LIKE faj_file.faj20,    # 保管部門
                              faj19 LIKE faj_file.faj19,    # 保管人
                              gen02 LIKE gen_file.gen02,    #
                              faj07 LIKE faj_file.faj07,    # 英文名稱
                              faj06 LIKE faj_file.faj06,    # 中文名稱
                              faj17 LIKE faj_file.faj17,    # 數量
                              faj08 LIKE faj_file.faj08,    # 規格型號
                              faj26 LIKE faj_file.faj26,    # 入帳日期
                              faj27 LIKE faj_file.faj27,    # 折舊年月
                              faj29 LIKE faj_file.faj29,    # 耐用年限
                              faj14 LIKE faj_file.faj14,    # 本幣成本
                              faj16 LIKE faj_file.faj16,    # 原幣金額
                              faj15 LIKE faj_file.faj15,    # 幣別
                              faj10 LIKE faj_file.faj10,    # 廠商
                              faj47 LIKE faj_file.faj47,    # 採購單
                              faj51 LIKE faj_file.faj51,    # 發票號碼
                              faj49 LIKE faj_file.faj49,    # 進口編號
                              faj52 LIKE faj_file.faj52,    # 傳票號碼
                              faj45 LIKE faj_file.faj45     # 帳款號碼
                       END RECORD,
      l_amt        LIKE type_file.num20_6,                      #No.FUN-680070 DECIMAL(17,5)
#      l_azi04      LIKE azi_file.azi04,                        #No.CHI-6A0004 mark 
      l_chr        LIKE type_file.chr1                          #No.FUN-680070 VARCHAR(1)
  define l_pmc03   LIKE pmc_file.pmc03                          #No.FUN-680070 VARCHAR(8)
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3 #,sr.faj04
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  #No.TQC-6C0009 mark
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  #No.TQC-6C0009
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
            g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],
            g_x[47],g_x[48],g_x[49],g_x[50],g_x[51]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   ON EVERY ROW
      SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=sr.faj10
      IF SQLCA.sqlcode THEN LET l_pmc03=sr.faj10 END IF
      SELECT azi04 INTO t_azi04 FROM azi_file                 #No.CHI-6A0004 l_azi-->t_azi  
       WHERE azi01=sr.faj15
         PRINT
           COLUMN g_c[31],sr.faj04,
           COLUMN g_c[32],sr.faj05,
           COLUMN g_c[33],sr.faj02,
           COLUMN g_c[34],sr.faj022,
           COLUMN g_c[35],sr.faj20,
           COLUMN g_c[36],sr.gen02[1,8],
           COLUMN g_c[37], sr.faj07,
           COLUMN g_c[38], sr.faj06,
           COLUMN g_c[39], cl_numfor(sr.faj17,39,0),
           COLUMN g_c[40], sr.faj08[1,20],
           COLUMN g_c[41], sr.faj26,
           COLUMN g_c[42], sr.faj27[1,4],'/',sr.faj27[5,6],
           COLUMN g_c[43], sr.faj29 USING '---&',g_x[17] CLIPPED,
           COLUMN g_c[44], cl_numfor(sr.faj14,44,g_azi04),
           COLUMN g_c[45], cl_numfor(sr.faj16,45,t_azi04),          #No.CHI-6A0004 l_azi-->t_azi
           COLUMN g_c[46], sr.faj15,
#          COLUMN g_c[47], l_pmc03[1,8],      #No.TQC-6C0009 mark
           COLUMN g_c[47], l_pmc03,           #No.TQC-6C0009
           COLUMN g_c[48], sr.faj47,
           COLUMN g_c[49], sr.faj51,
#          COLUMN g_c[50], sr.faj52[1,12],
           COLUMN g_c[50], sr.faj52,          #No.FUN-550034
           COLUMN g_c[51], sr.faj45
## Modify:2595  98/10/21-------------
   AFTER GROUP OF sr.order1
      IF tm.v[1,1] = 'Y' THEN
         PRINT
         PRINT COLUMN g_c[42],g_descripe[1],
               COLUMN g_c[44],cl_numfor(GROUP SUM(sr.faj14),44,g_azi05)
         PRINT
      END IF
 
   AFTER GROUP OF sr.order2
      IF tm.v[2,2] = 'Y'
         THEN
         PRINT
         PRINT COLUMN g_c[42],g_descripe[2],
               COLUMN g_c[44],cl_numfor(GROUP SUM(sr.faj14),44,g_azi05)
         PRINT
      END IF
 
   AFTER GROUP OF sr.order3
      IF tm.v[3,3] = 'Y'
         THEN PRINT
              PRINT COLUMN g_c[42],g_descripe[3],
              COLUMN g_c[44],cl_numfor(GROUP SUM(sr.faj14),44,g_azi05)
         PRINT
      END IF
 
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
