# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: afar810.4gl
# Descriptions...: 固定資產變動明細表
# Date & Author..: 96/05/31 By STAR
# Modify.........: No.FUN-510035 05/01/25 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-530677 05/03/28 By Smapmin 列印部門名稱,人員姓名,廠商簡稱
# Modify.........: No.FUN-540057 05/05/09 By ice 發票號碼加大到16位
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By Jackho  本（原）幣取位修改
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-760182 07/06/27 By chenl   修正總筆數問題。
# Modify.........: No.FUN-850092 08/05/20 By arman   報表輸出至Crystal Reports功能    
#                                08/08/13 By Cockroach 21區追至31區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,       # Where condition       #No.FUN-680070 VARCHAR(1000)
              more    LIKE type_file.chr1,          # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
              s       LIKE type_file.chr3,          # Order by sequence       #No.FUN-680070 VARCHAR(3)
              t       LIKE type_file.chr3           # Eject sw       #No.FUN-680070 VARCHAR(3)
              END RECORD,
          m_codest  LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(34)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
# NO.FUN-850092 --begin                                                                                                             
DEFINE l_table        STRING,                                                                                                       
       g_str          STRING,                                                                                                       
       g_sql          STRING                                                                                                        
# No.FUN-850092 --end      
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
#NO.FUN-850092   ---begin                                                                                                           
   LET g_sql = " faj14.faj_file.faj14,  ",                                                                                          
               " faj15.faj_file.faj15,  ",                                                                                          
               " faj10.faj_file.faj10,  ",                                                                                          
               " faj20.faj_file.faj20,  ",                                                                                          
               " faj19.faj_file.faj19,  ",                                                                                          
               " faj02.faj_file.faj02,  ",                                                                                          
               " faj022.faj_file.faj022,",                                                                                          
               " fab02.fab_file.fab02,  ",                                                                                          
               " faj52.faj_file.faj52,  ",                                                                                          
               " faj26.faj_file.faj26,  ",                                                                                          
               " faj06.faj_file.faj06,  ",                                                                                          
               " faj08.faj_file.faj08,  ",                                                                                          
               " faj07.faj_file.faj07,  ",                                                                                          
               " pmc03.pmc_file.pmc03,  ",                                                                                          
               " gem02.gem_file.gem02,  ",                                                                                          
               " gen02.gen_file.gen02,  ",                                                                                          
               " faj17.faj_file.faj17,  ",                                                                                          
               " faj16.faj_file.faj16,  ",                                                                                          
               " faj49.faj_file.faj49,  ",                                                                                          
               " faj47.faj_file.faj47,  ",                                                                                          
               " faj511.faj_file.faj511,",                                                                                          
               " faj48.faj_file.faj48,  ",                                                                                          
               " faj51.faj_file.faj51,  ",       
               " faj04.faj_file.faj04,  ",                                                                                          
               " azi04.azi_file.azi04"                                                                                              
   LET l_table = cl_prt_temptable('afar810',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? )"                                                    
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
                                                                                                                                    
#NO.FUN-850092  --end          
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL afar810_tm(0,0)        # Input print condition
      ELSE CALL afar810()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afar810_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 18
 
   OPEN WINDOW afar810_w AT p_row,p_col WITH FORM "afa/42f/afar810"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s  = '12  '
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
      CONSTRUCT BY NAME tm.wc ON faj26,faj04,faj02,faj51
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
         LET INT_FLAG = 0 CLOSE WINDOW afar810_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
         INPUT BY NAME
            tm2.s1,tm2.s2,tm2.s3,
            tm2.t1,tm2.t2,tm2.t3,tm.more
            WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
            AFTER FIELD more
               IF tm.more = 'Y' THEN
                  CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                 g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
               END IF
            ON ACTION CONTROLR
               CALL cl_show_req_fields()
            ON ACTION CONTROLG
               CALL cl_cmdask()    # Command execution
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
         LET INT_FLAG = 0 CLOSE WINDOW afar810_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar810'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar810','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_lang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.s  CLIPPED,"'",
                            " '",tm.t  CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('afar810',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW afar810_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar810()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW afar810_w
END FUNCTION
 
FUNCTION afar810()
   DEFINE l_name    LIKE type_file.chr20,        # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0069
          l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(40)
          l_order   ARRAY[3] OF LIKE faj_file.faj51,         #No.FUN-540057       #No.FUN-680070 VARCHAR(16)
          sr        RECORD order1 LIKE faj_file.faj51,       #No.FUN-680070 VARCHAR(10)
                           order2 LIKE faj_file.faj51,       #No.FUN-680070 VARCHAR(10)
                           order3 LIKE faj_file.faj51,       #No.FUN-680070 VARCHAR(10)
                           ordert LIKE type_file.chr1000,    #No.FUN-680070 VARCHAR(30)
                           faj04  LIKE faj_file.faj04,
                           fab02  LIKE fab_file.fab02,
                           faj52  LIKE faj_file.faj52,
                           faj02  LIKE faj_file.faj02,
                           faj022 LIKE faj_file.faj022,
                           faj06  LIKE faj_file.faj06,
                           faj08  LIKE faj_file.faj08,
                           faj07  LIKE faj_file.faj07,
                           faj10  LIKE faj_file.faj10,
                           faj20  LIKE faj_file.faj20,
                           faj19  LIKE faj_file.faj19,
                           faj17  LIKE faj_file.faj17,
                           faj14  LIKE faj_file.faj14,
                           faj15  LIKE faj_file.faj15,
                           faj16  LIKE faj_file.faj16,
                           faj49  LIKE faj_file.faj49,
                           faj47  LIKE faj_file.faj47,
                           faj511 LIKE faj_file.faj511,
                           faj48  LIKE faj_file.faj48,
                           faj51  LIKE faj_file.faj51,
                           faj26  LIKE faj_file.faj26
                        END RECORD
DEFINE                                                  #No.FUN-850092                                                              
          l_pmc03      LIKE pmc_file.pmc03,             #No.FUN-850092                                                              
          l_gem02      LIKE gem_file.gem02,             #No.FUN-850092                                                              
          l_gen02      LIKE gen_file.gen02              #No.FUN-850092                                                              
     CALL cl_del_data(l_table)                                           #No.FUN-850092     
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fajuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fajgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fajgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')
     #End:FUN-980030
 
 
     LET l_sql = "SELECT '','','','',faj04,'',faj52,faj02,faj022,faj06,",
                 "       faj08,faj07,faj10,faj20,faj19,faj17,",
                 "       faj14,faj15,faj16,faj49,faj47,faj511,faj48,",
                 "       faj51,faj26 ",
                 "  FROM faj_file",
                 " WHERE fajconf = 'Y' ",
                 "   AND faj40 = '1' ",
		 "   AND faj14 > 0   ",
                 "   AND faj02 NOT IN ",
       "(SELECT fci03 FROM fci_file WHERE fci03=faj02 AND fci031=faj022 ) ",
                 "   AND ",tm.wc CLIPPED
#No.CHI-6A0004--begin
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#No.CHI-6A0004--end
 
     PREPARE afar810_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar810_curs1 CURSOR FOR afar810_prepare1
#No.FUN-850092--begin--  
#     CALL cl_outnam('afar810') RETURNING l_name      #No.FUN-850092--mark--  
 
#     START REPORT afar810_rep TO l_name              #No.FUN-850092--mark--  
#     LET g_pageno = 0
 
     FOREACH afar810_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
#      FOR g_i = 1 TO 3
#         CASE WHEN tm.s[g_i,g_i] = '1'
#                   LET l_order[g_i] = sr.faj26 USING 'yyyymmdd'
#              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.faj04
#              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.faj02
#              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.faj51
#              OTHERWISE LET l_order[g_i] = '-'
#         END CASE
#      END FOR
#      LET sr.order1 = l_order[1]
#      LET sr.order2 = l_order[2]
#      LET sr.order3 = l_order[3]
#      LET sr.ordert = sr.order1,sr.order2,sr.order3
       IF cl_null(sr.faj17)  THEN LET sr.faj17 = 0 END IF
       IF cl_null(sr.faj14)  THEN LET sr.faj14 = 0 END IF
       IF cl_null(sr.faj16)  THEN LET sr.faj16 = 0 END IF
       SELECT fab02 INTO sr.fab02 FROM fab_file WHERE fab01 = sr.faj04
#No.FUN-850092--end--      
#       OUTPUT TO REPORT afar810_rep(sr.*)               #No.FUN-850092--mark--      
#No.FUN-850092--begin--
       SELECT azi04 INTO t_azi04 FROM azi_file                                                                                      
        WHERE azi01=sr.faj15                                                                                                        
       SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = sr.faj10                                                               
       SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.faj20                                                               
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.faj19                                                               
          LET l_name = 'afar810'                                                                                                    
          EXECUTE insert_prep USING  sr.faj14,sr.faj15,sr.faj10,                                                                    
                                     sr.faj20,sr.faj19,sr.faj02,sr.faj022,                                                          
                                     sr.fab02,sr.faj52,sr.faj26,sr.faj06,sr.faj08,                                                  
                                     sr.faj07,l_pmc03,l_gem02,l_gen02,                                                              
                                     sr.faj17,sr.faj16,sr.faj49,sr.faj47,                                                           
                                     sr.faj511,sr.faj48,sr.faj51,sr.faj04,t_azi04              
     END FOREACH
 
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                        
    IF g_zz05 = 'Y' THEN                                                                                                            
         CALL cl_wcchp(tm.wc,'faj26,faj04,faj02,faj51')                                                                             
              RETURNING tm.wc                                                                                                       
    END IF                                                                                                                          
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                                             
     LET g_str = tm.wc,";",g_azi04,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3]                                                        
                  ,";",tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3]                                                                        
     CALL cl_prt_cs3('afar810',l_name,l_sql,g_str)                           
#No.FUN-850092 ----end  
#     FINISH REPORT afar810_rep                      #No.FUN-850092 -mark-
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)    #No.FUN-850092 -mark-
END FUNCTION
#No.FUN-850092 --mark begin--  
#REPORT afar810_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#         l_reccs      LIKE type_file.num20_6,      #No.FUN-680070 DEC(14,2)
#         l_recc       LIKE type_file.num20_6,      #No.FUN-680070 DEC(14,2)
##          l_azi04      LIKE azi_file.azi04,      #No.CHI-6A0004 mark
##          l_azi05      LIKE azi_file.azi05,      #No.CHI-6A0004 mark  
#         l_faj14      LIKE faj_file.faj14,       #No.FUN-680070 DEC(20,6)
#         l_str        STRING,
#         l_pmc03      LIKE pmc_file.pmc03,         #MOD-530677
#         l_gem02      LIKE gem_file.gem02,         #MOD-530677
#         l_gen02      LIKE gen_file.gen02,         #MOD-530677
#         sr           RECORD order1 LIKE faj_file.faj51,       #No.FUN-680070 VARCHAR(10)
#                             order2 LIKE faj_file.faj51,       #No.FUN-680070 VARCHAR(10)
#                             order3 LIKE faj_file.faj51,       #No.FUN-680070 VARCHAR(10)
#                             ordert LIKE type_file.chr1000,    #No.FUN-680070 VARCHAR(30)
#                             faj04  LIKE faj_file.faj04,
#                             fab02  LIKE fab_file.fab02,
#                             faj52  LIKE faj_file.faj52,
#                             faj02  LIKE faj_file.faj02,
#                             faj022 LIKE faj_file.faj022,
#                             faj06  LIKE faj_file.faj06,
#                             faj08  LIKE faj_file.faj08,
#                             faj07  LIKE faj_file.faj07,
#                             faj10  LIKE faj_file.faj10,
#                             faj20  LIKE faj_file.faj20,
#                             faj19  LIKE faj_file.faj19,
#                             faj17  LIKE faj_file.faj17,
#                             faj14  LIKE faj_file.faj14,
#                             faj15  LIKE faj_file.faj15,
#                             faj16  LIKE faj_file.faj16,
#                             faj49  LIKE faj_file.faj49,
#                             faj47  LIKE faj_file.faj47,
#                             faj511 LIKE faj_file.faj511,
#                             faj48  LIKE faj_file.faj48,
#                             faj51  LIKE faj_file.faj51,
#                             faj26  LIKE faj_file.faj26
#                      END RECORD
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.order1,sr.order2,sr.order3,sr.ordert
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED, pageno_total
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#           g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],
#            g_x[47],g_x[48],g_x[49],g_x[50],g_x[51],g_x[52]  #MOD-530677
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.order1
#    IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 10) THEN
#        SKIP TO TOP OF PAGE
#    END IF
 
#  BEFORE GROUP OF sr.order2
#    IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 10) THEN
#       SKIP TO TOP OF PAGE
#    END IF
 
#  BEFORE GROUP OF sr.order3
#    IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 10) THEN
#       SKIP TO TOP OF PAGE
#    END IF
#
#  AFTER GROUP OF sr.ordert
#     LET l_faj14 = GROUP SUM(sr.faj14)
#     PRINT COLUMN g_c[32],g_x[9] CLIPPED,
#           COLUMN g_c[33],l_reccs USING '###&',' ',g_x[10] CLIPPED,
#           COLUMN g_c[45],cl_numfor(l_faj14,45,g_azi04)
#     IF cl_null(l_recc) THEN LET l_recc = 0 END IF
#     LET l_recc = l_recc + l_reccs
#     LET l_reccs = 0
#     SKIP 1 LINE
#{
#  AFTER GROUP OF sr.order2
#     LET l_faj14 = GROUP SUM(sr.faj14)
#     PRINT COLUMN 10,g_x[18] CLIPPED,COLUMN 23,l_reccs USING '###&',
#           COLUMN 156,cl_numfor(l_faj14,14,g_azi04)
#     IF cl_null(l_recc) THEN LET l_recc = 0 END IF
#     LET l_recc = l_recc + l_reccs
#     SKIP 1 LINE
 
#  AFTER GROUP OF sr.order3
#     LET l_faj14 = GROUP SUM(sr.faj14)
#     PRINT COLUMN 10,g_x[18] CLIPPED,COLUMN 23,l_reccs USING '###&',
#           COLUMN 156,cl_numfor(l_faj14,14,g_azi04)
#     IF cl_null(l_recc) THEN LET l_recc = 0 END IF
#     LET l_recc = l_recc + l_reccs
#     SKIP 1 LINE
#}
#
 
#  ON EVERY ROW
#     SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file              #No.CHI-6A0004 l_azi-->t_azi
#      WHERE azi01=sr.faj15
#     SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = sr.faj10
#     SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.faj20
#     SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.faj19
#     LET l_str =  sr.faj02,'   ',sr.faj022
#     PRINT COLUMN g_c[31],sr.fab02[1,8],
#           COLUMN g_c[32],sr.faj52,
#           COLUMN g_c[33],l_str,
#           COLUMN g_c[34],sr.faj26,
#           COLUMN g_c[35],sr.faj06,
#           COLUMN g_c[36],sr.faj08[1,20],
#           COLUMN g_c[37],sr.faj07,
#           COLUMN g_c[38],sr.faj10,
#            COLUMN g_c[39],l_pmc03,   #MOD-530677
#           COLUMN g_c[40],sr.faj20,
#            COLUMN g_c[41],l_gem02,   #MOD-530677
#           COLUMN g_c[42],sr.faj19,
#            COLUMN g_c[43],l_gen02,   #MOD-530677
#           COLUMN g_c[44],cl_numfor(sr.faj17,44,0),
#           COLUMN g_c[45],cl_numfor(sr.faj14,45,g_azi04),
#           COLUMN g_c[46],sr.faj15,
#           COLUMN g_c[47],cl_numfor(sr.faj16,47,t_azi04),           #No.CHI-6A0004 l_azi-->t_azi
#           COLUMN g_c[48],sr.faj49,
#           COLUMN g_c[49],sr.faj47,
#           COLUMN g_c[50],sr.faj511,
#           COLUMN g_c[51],sr.faj48[1,12],
#           COLUMN g_c[52],sr.faj51
#     IF cl_null(l_reccs) THEN LET l_reccs = 0 END IF
#     LET l_reccs = l_reccs + 1
#  ON LAST ROW
#     LET l_faj14 = SUM(sr.faj14)
#     PRINT g_dash2[1,g_len]
#     PRINT COLUMN g_c[32], g_x[11] CLIPPED,
#          #COLUMN g_c[33], l_recc-1 USING '###&', ' ',g_x[10] CLIPPED, #No.TQC-760182 mark     
#           COLUMN g_c[33], l_recc USING '###&', ' ',g_x[10] CLIPPED,   #No.TQC-760182     
#           COLUMN g_c[45], cl_numfor(l_faj14,45,g_azi04)
#     PRINT g_dash[1,g_len]
#     LET l_last_sw = 'y'
#     PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#     LET l_recc = 0
 
#  PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#          PRINT g_dash2[1,g_len]
#          PRINT COLUMN g_c[32], g_x[11] CLIPPED,
#                COLUMN g_c[33], l_recc+1 USING '###&', ' ',g_x[10] CLIPPED,
#                COLUMN g_c[45], cl_numfor(SUM(sr.faj14),45,g_azi04)
#          PRINT g_dash[1,g_len]
#          PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#          LET l_recc = 0
#      ELSE
#          SKIP 4 LINE
#      END IF
 
#END REPORT
#No.FUN-850092 --mark end--  
