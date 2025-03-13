# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: afar760.4gl
# Descriptions...: 投資抵減工作底稿
# Date & Author..: 96/05/15 By STAR
# Modify.........: No.FUN-510035 05/02/01 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-550034 05/05/17 by day   單據編號加大
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By Jackho  本（原）幣取位修改
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-780018 07/08/17 By xiaofeizhu 制作水晶報表
# Modify.........: No.TQC-950003 09/05/14 By Cockroach g_str傳參有誤
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0179 09/12/29 By tsai_yen EXECUTE裡不可有擷取字串的中括號[]
# Modify.........: No.TQC-A40084 10/04/20 By Carrier 标准格式修改
# Modify.........: No.FUN-B80054 11/08/04 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,   # Where condition       #No.FUN-680070 VARCHAR(1000)
              a       LIKE type_file.chr1,        # 格式       #No.FUN-680070 VARCHAR(1)
              more    LIKE type_file.chr1         # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
              END RECORD,
          m_codest  LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(34)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE   l_table         STRING                      #No.FUN-780018                                                                 
DEFINE   g_sql           STRING                      #No.FUN-780018                                                                 
DEFINE   g_str           STRING                      #No.FUN-780018                                                                 
DEFINE   l_table1        STRING                      #No.FUN-780018 
DEFINE   l_table2        STRING                      #No.FUN-780018 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   #No.TQC-A40084  --Begin
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)   #TQC-610055
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF

### *** FUN-780018 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
    LET g_sql = "fcc01.fcc_file.fcc01,",                                                                                            
                "fcc02.fcc_file.fcc02,",                                                                                            
                "faj47.faj_file.faj47,",                                                                                            
                "fcc03.fcc_file.fcc03,",                                                                                            
                "fcc031.fcc_file.fcc031,",                                                                                            
                "faj04.faj_file.faj04,",                                                                                            
                "fcc06.fcc_file.fcc06,",                                                                                            
                "fcc05.fcc_file.fcc05,",                                                                                            
                "fcc07.fcc_file.fcc07,",                                                                                            
                "fcc08.fcc_file.fcc08,",                                                                                            
                "faj51.faj_file.faj51,",                                                                                            
                "faj49.faj_file.faj49,",                                                                                            
                "fcc09.fcc_file.fcc09,",                                                                                           
                "fcc14.fcc_file.fcc14,",                                                                                            
                "fcc13.fcc_file.fcc13,",                                                                                          
                "fcc16.fcc_file.fcc16,",                                                                                            
                "fcc15.fcc_file.fcc15,",                                                                                            
                "num20_6.type_file.num20_6,",                                                                                             
                "gem02.gem_file.gem02,",                                                                                            
                "gen02.gen_file.gen02,",                                                                                            
                "fcc20.fcc_file.fcc20,",
                "azi04.azi_file.azi04" 
    LET l_table = cl_prt_temptable('afar760',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
                                                                                                                                    
    LET g_sql = "fcc14a.fcc_file.fcc14,",                                                                                           
                "num20_6a.type_file.num20_6,",                                                                                           
                "num20_6b.type_file.num20_6,",           
                "fcc15a.fcc_file.fcc15,",
                "num20_6c.type_file.num20_6,",
                "azi05.azi_file.azi05,",
                "fcc01.fcc_file.fcc01,",                                                                                            
                "fcc03.fcc_file.fcc03,",                                                                                            
                "fcc031.fcc_file.fcc031"                                                                                            
    LET l_table1 = cl_prt_temptable('afar7601',g_sql) CLIPPED   # 產生Temp Table                                                    
    IF l_table1 = -1 THEN EXIT PROGRAM END IF                   # Temp Table產生 
 
    LET g_sql = "fcc14b.fcc_file.fcc14,",                                                                                           
                "num20_6d.type_file.num20_6,",                                                                                      
                "num20_6e.type_file.num20_6,",                                                                                      
                "fcc15b.fcc_file.fcc15,",                                                                                           
                "num20_6f.type_file.num20_6,",                                                                                      
                "azi05.azi_file.azi05,",     
                "fcc01.fcc_file.fcc01,",                                                                                            
                "fcc03.fcc_file.fcc03,",                                                                                            
                "fcc031.fcc_file.fcc031"                                                                                            
    LET l_table2 = cl_prt_temptable('afar7602',g_sql) CLIPPED   # 產生Temp Table                                                    
    IF l_table2 = -1 THEN EXIT PROGRAM END IF                   # Temp Table產生
#----------------------------------------------------------CR (1) ---------------------------------------#
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
   #No.TQC-A40084  --End 
   
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL afar760_tm(0,0)        # Input print condition
      ELSE CALL afar760()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afar760_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 18
 
   OPEN WINDOW afar760_w AT p_row,p_col WITH FORM "afa/42f/afar760"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a    = '2'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fcb01,fcb02
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
         LET INT_FLAG = 0 CLOSE WINDOW afar760_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES '[1-2]' THEN
               NEXT FIELD a
            ELSE
               IF tm.a = '2' THEN
                  LET tm.wc = tm.wc CLIPPED ,
                             " AND fcc04 != '0' "
               END IF
            END IF
 
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
         LET INT_FLAG = 0 CLOSE WINDOW afar760_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar760'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar760','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.a CLIPPED,"'",   #TQC-610055
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afar760',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW afar760_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar760()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW afar760_w
END FUNCTION
 
FUNCTION afar760()
   DEFINE l_name    LIKE type_file.chr20,        # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8      #No.FUN-6A0069
          l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(40)
          l_gem02   LIKE   gem_file.gem02,                            #No.FUN-780018                                                           
          l_gen02   LIKE   gen_file.gen02,                            #No.FUN-780018
          xr               RECORD fcc14  LIKE fcc_file.fcc14,         #No.FUN-780018                                                                  
                                  cost1  LIKE type_file.num20_6,      #No.FUN-780018 DEC(20,6)                                          
                                  cost2  LIKE type_file.num20_6,      #No.FUN-780018 DEC(20,6)                                          
                                  fcc15  LIKE fcc_file.fcc15,         #No.FUN-780018                                                                  
                                  offset LIKE type_file.num20_6       #No.FUN-780018 DEC(20,6) 
                           END RECORD                                 #No.FUN-780018
DEFINE    sr               RECORD fcc01  LIKE fcc_file.fcc01,
                                  fcc02  LIKE fcc_file.fcc02,
                                  fcc03  LIKE fcc_file.fcc03,
                                  fcc031 LIKE fcc_file.fcc031,
                                  faj04  LIKE faj_file.faj04,
                                  fcc06  LIKE fcc_file.fcc06,
                                  fcc05  LIKE fcc_file.fcc05,
                                  fcc07  LIKE fcc_file.fcc07,
                                  fcc08  LIKE fcc_file.fcc08,
                                  faj51  LIKE faj_file.faj51,
                                  faj49  LIKE faj_file.faj49,
                                  amount LIKE fcc_file.fcc09,
                                  fcc14  LIKE fcc_file.fcc14,
                                  cost1  LIKE fcc_file.fcc13,
                                  cost2  LIKE fcc_file.fcc16,
                                  fcc15  LIKE fcc_file.fcc15,
                                  offset LIKE type_file.num20_6,      #No.FUN-680070 DEC(20,6)
                                  fcc20  LIKE fcc_file.fcc20,
                                  faj47  LIKE faj_file.faj47,
                                  faj20  LIKE faj_file.faj20,
                                  faj19  LIKE faj_file.faj19,
                                  azi03  LIKE azi_file.azi03,
                                  azi04  LIKE azi_file.azi04,
                                  azi05  LIKE azi_file.azi05
                        END RECORD
   ###TQC-9C0179 START ###
   DEFINE l_faj04 LIKE faj_file.faj04  
   DEFINE l_faj49 LIKE faj_file.faj49
   ###TQC-9C0179 END ###

#No.FUN-780018--begin--                                                                                                             
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
                         ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                          
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80054--add--
       EXIT PROGRAM                                                                            
    END IF                                                                                                                          
                                                                                                                                    
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                                          
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                                         
   PREPARE insert_prep1 FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep1:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80054--add--
       EXIT PROGRAM                                                                            
    END IF                              
 
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                                          
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                                
   PREPARE insert_prep2 FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep2:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80054--add--
       EXIT PROGRAM                                                                            
    END IF                                                                                            
#No.FUN-780018--end-- 
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-780018 *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
     CALL cl_del_data(l_table1)      
     CALL cl_del_data(l_table2)                                                                                               
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-780018                                                      
     #------------------------------ CR (2) ------------------------------#   
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fcbuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fcbgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fcbgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fcbuser', 'fcbgrup')
     #End:FUN-980030
 
     IF tm.a = '1' THEN
     LET l_sql = "SELECT fcc01,fcc02,fcc03,fcc031,faj04,fcc06,fcc05,fcc07, ",
                 "       fcc08,faj51,faj49,fcc09,fcc14,fcc13,fcc16,fcc15, ",
                 "       0                  ,fcc20,",
                 "       faj47,faj20,faj19,azi03,azi04,azi05 ",
                 "  FROM fcb_file, fcc_file,OUTER faj_file, azi_file ",
                 " WHERE fcc_file.fcc03 = faj_file.faj02  ",
                 "   AND fcc_file.fcc031= faj_file.faj022 ",
                 "   AND fcc14 = azi_file.azi01  ",
                 "   AND fcb01 = fcc01  ",
                 "   AND fcbconf !='X'  ", #010808增
                 "   AND ",tm.wc CLIPPED
     ELSE
     LET l_sql = "SELECT fcc01,fcc02,fcc03,fcc031,faj04,fcc06,fcc05,fcc07, ",
                 "       fcc08,faj51,faj49,fcc21,fcc14,fcc23,fcc24,fcc15, ",
                 "       0                  ,fcc20,",
                 "       faj47,faj20,faj19,azi03,azi04,azi05 ",
                 "  FROM fcb_file, fcc_file,OUTER faj_file, azi_file ",
                 " WHERE fcc_file.fcc03 = faj_file.faj02  ",
                 "   AND fcc_file.fcc031= faj_file.faj022 ",
                 "   AND fcc14 = azi_file.azi01  ",
                 "   AND fcb01 = fcc01  ",
                 "   AND fcbconf !='X'  ", #010808增
                 "   AND fcc04 IN ('1','2')",
                 "   AND ",tm.wc CLIPPED
     END IF
#No.CHI-6A0004--beign
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#     WHERE azi01=g_aza.aza17
#No.CHI-6A0004--end
 
     PREPARE afar760_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar760_curs1 CURSOR FOR afar760_prepare1
 
#    CALL cl_outnam('afar760') RETURNING l_name                               #FUN-780018
 
#    START REPORT afar760_rep TO l_name                                       #FUN-780018
     LET g_pageno = 0
 
     CALL r760_create_temp1()
     CALL r760_create_temp2()
     FOREACH afar760_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
#--No.FUN-780018--add--begin--#
         LET l_gem02 = ' '                                                                                                          
         SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.faj20                                                             
         IF cl_null(l_gem02) THEN LET l_gem02 = ' ' END IF                                                                          
                                                                                                                                    
         LET l_gen02 = ' '                                                                                                          
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.faj19                                                             
         IF cl_null(l_gen02) THEN LET l_gen02 = ' ' END IF
#--No.FUN-780018--add--end--#
       # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
       IF sr.amount IS NULL THEN LET sr.amount = 0 END IF
       IF sr.cost1  IS NULL THEN LET sr.cost1 = 0 END IF
       IF sr.cost2  IS NULL THEN LET sr.cost2 = 0 END IF
       #--- 々抵減金額[offset]:本幣成本*抵減率/100 四捨五入至元 --
       LET sr.offset = sr.cost2 * sr.fcc15 / 100
       #---------小    計--------
       UPDATE b1_temp SET cost1=cost1 + sr.cost1,
                          cost2=cost2 + sr.cost2
        WHERE fcc01 = sr.fcc01
          AND fcc14 = sr.fcc14
          AND fcc15 = sr.fcc15
        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
           INSERT INTO b1_temp
           VALUES(sr.fcc01,sr.fcc14,sr.cost1,sr.cost2,
                  sr.fcc15)
        END IF
#--No.FUN-780018--add--begin--#
         DECLARE afar760_curs2 CURSOR FOR                                                                                           
          SELECT fcc14,cost1,cost2,fcc15,(cost2*fcc15/100)                                                                          
            FROM b1_temp                                                                                                            
           WHERE fcc01 = sr.fcc01                                                                                                   
                                                                                                                                    
         FOREACH afar760_curs2 INTO xr.*                                                                                            
           IF SQLCA.sqlcode != 0 THEN                                                                                               
              CALL cl_err('foreach:',SQLCA.sqlcode,1)                                                                               
              EXIT FOREACH                                                                                                          
           END IF                                                                                                                   
           #---------總    計--------                                                                                               
           UPDATE b2_temp SET cost1=cost1 + xr.cost1,                                                                               
                              cost2=cost2 + xr.cost2                                                                                
            WHERE fcc14 = xr.fcc14                                                                                                  
              AND fcc15 = xr.fcc15                                                                                                  
            IF STATUS OR SQLCA.SQLERRD[3]=0 THEN                                                                                    
               INSERT INTO b2_temp                                                                                                  
               VALUES(xr.fcc14,xr.cost1,xr.cost2,
                      xr.fcc15)                                                                                                     
            END IF 
           EXECUTE insert_prep1 USING
                      xr.fcc14,xr.cost1,xr.cost2,xr.fcc15,xr.offset,sr.azi05,sr.fcc01,sr.fcc03,sr.fcc031
         END FOREACH
 
      DECLARE afar760_curs3 CURSOR FOR                                                                                              
       SELECT fcc14,cost1,cost2,fcc15,(cost2*fcc15/100)                                                                             
         FROM b2_temp                                                                                                               
         FOREACH afar760_curs3 INTO xr.*                                                                                            
           IF SQLCA.sqlcode != 0 THEN                                                                                               
              CALL cl_err('foreach:',SQLCA.sqlcode,1)                                                                               
              EXIT FOREACH                                                                                                          
           END IF 
           EXECUTE insert_prep2 USING
                      xr.fcc14,xr.cost1,xr.cost2,xr.fcc15,xr.offset,sr.azi05,sr.fcc01,sr.fcc03,sr.fcc031
         END FOREACH
#--No.fun-780018--add--end--#
{
       #---------總    計--------
       UPDATE b2_temp SET cost1=cost1 + sr.cost1,
                          cost2=cost2 + sr.cost2
        WHERE fcc14 = sr.fcc14
          AND fcc15 = sr.fcc15
        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
           INSERT INTO b2_temp
           VALUES(sr.fcc01,sr.fcc14,sr.cost1,sr.cost2,
                  sr.fcc15)
        END IF}
#      OUTPUT TO REPORT afar760_rep(sr.*)                                       #FUN-780018
        ###TQC-9C0179 START ###
        LET l_faj04 = sr.faj04[1,4]
        LET l_faj49 = sr.faj49[1,8]
        ###TQC-9C0179 END ###
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-780018 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
                      #sr.fcc01,sr.fcc02,sr.faj47,sr.fcc03,sr.fcc031,sr.faj04[1,4],sr.fcc06,sr.fcc05,sr.fcc07,sr.fcc08, #TQC-9C0179 mark
                      #sr.faj51,sr.faj49[1,8],sr.amount,sr.fcc14,sr.cost1,sr.cost2,sr.fcc15,sr.offset,l_gem02,l_gen02,  #TQC-9C0179 mark
                      sr.fcc01,sr.fcc02,sr.faj47,sr.fcc03,sr.fcc031,l_faj04,sr.fcc06,sr.fcc05,sr.fcc07,sr.fcc08, #TQC-9C0179
                      sr.faj51,l_faj49,sr.amount,sr.fcc14,sr.cost1,sr.cost2,sr.fcc15,sr.offset,l_gem02,l_gen02,  #TQC-9C0179
                      sr.fcc20,sr.azi04
          #------------------------------ CR (3) ------------------------------#
     END FOREACH
 
#    FINISH REPORT afar760_rep                                                  #FUN-780018
#No.FUN-780018--begin                                                                                                               
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'fcb01,fcb02,fcc04')                                                           
              RETURNING  tm.wc
         LET g_str= tm.wc                                                                                                      
      END IF
#No.FUN-780018--end
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                                #FUN-780018
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-780018 **** ##                                                        
    LET l_sql = "SELECT C.fcc14b,C.num20_6d,C.num20_6e,C.fcc15b,C.num20_6f,B.fcc14a,B.num20_6a,B.num20_6b,B.fcc15a,B.num20_6c,A.*",                                                                            
" FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A LEFT OUTER JOIN ",
"   ",g_cr_db_str CLIPPED,l_table1 CLIPPED," B ON ",
"A.fcc01=B.fcc01 AND A.fcc03=B.fcc03 AND A.fcc031=B.fcc031 LEFT OUTER JOIN ",
"   ",g_cr_db_str CLIPPED,l_table2 CLIPPED," C ON ",
"A.fcc01=C.fcc01 AND A.fcc03=C.fcc03 AND A.fcc031=C.fcc031 "
#    LET g_str = ''
   #LET g_str = g_str,":",g_azi05,";",g_azi04      #TQC-950003 MARK  
    LET g_str = g_str,";",g_azi05,";",g_azi04      #TQC-950003 ADD     
    CALL cl_prt_cs3('afar760','afar760',l_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------# 
END FUNCTION
 
{ REPORT afar760_rep(sr)                                                     #No.FUN-780018
   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          a_sql        LIKE type_file.chr1000,       # RDSQL STATEMENT       #No.FUN-680070 VARCHAR(600)
          l_fcc13,l_fcc16,l_fcc161 LIKE fcc_file.fcc16,       #No.FUN-680070 DECIMAL(16,2)
          l_gem02      LIKE   gem_file.gem02,
          l_gen02      LIKE   gen_file.gen02,
          l_str        STRING,
          xr           RECORD fcc14  LIKE fcc_file.fcc14,
                              cost1  LIKE type_file.num20_6,      #No.FUN-680070 DEC(20,6)
                              cost2  LIKE type_file.num20_6,      #No.FUN-680070 DEC(20,6)
                              fcc15  LIKE fcc_file.fcc15,
                              offset LIKE type_file.num20_6      #No.FUN-680070 DEC(20,6)
                       END RECORD,
          sr           RECORD fcc01  LIKE fcc_file.fcc01,
                              fcc02  LIKE fcc_file.fcc02,
                              fcc03  LIKE fcc_file.fcc03,
                              fcc031 LIKE fcc_file.fcc031,
                              faj04  LIKE faj_file.faj04,
                              fcc06  LIKE fcc_file.fcc06,
                              fcc05  LIKE fcc_file.fcc05,
                              fcc07  LIKE fcc_file.fcc07,
                              fcc08  LIKE fcc_file.fcc08,
                              faj51  LIKE faj_file.faj51,
                              faj49  LIKE faj_file.faj49,
                              amount LIKE fcc_file.fcc09,
                              fcc14  LIKE fcc_file.fcc14,
                              cost1  LIKE fcc_file.fcc13,
                              cost2  LIKE fcc_file.fcc16,
                              fcc15  LIKE fcc_file.fcc15,
                              offset LIKE type_file.num20_6,      #No.FUN-680070 DEC(20,6)
                              fcc20  LIKE fcc_file.fcc20,
                              faj47  LIKE faj_file.faj47,
                              faj20  LIKE faj_file.faj20,
                              faj19  LIKE faj_file.faj19,
                              azi03  LIKE azi_file.azi03,
                              azi04  LIKE azi_file.azi04,
                              azi05  LIKE azi_file.azi05
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.fcc01,sr.fcc02,sr.fcc03,sr.fcc031
  FORMAT
   PAGE HEADER
      IF pageno = 1 THEN
         PRINT "~x0;"
      ELSE
         PRINT
      END IF
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
            g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],
            g_x[47],g_x[48],g_x[49],g_x[50],g_x[51]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
 
      BEFORE GROUP OF sr.fcc01
          PRINT COLUMN g_c[31],sr.fcc01;
 
      ON EVERY ROW
         LET l_gem02 = ' '
         SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.faj20
         IF cl_null(l_gem02) THEN LET l_gem02 = ' ' END IF
 
         LET l_gen02 = ' '
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.faj19
         IF cl_null(l_gen02) THEN LET l_gen02 = ' ' END IF
         LET l_str = sr.fcc15 USING '##&','%'
         PRINT COLUMN g_c[32],sr.fcc02 USING '###&' CLIPPED,
               COLUMN g_c[33],sr.faj47 CLIPPED,    #No.FUN-550034
               COLUMN g_c[34],sr.fcc03 CLIPPED,
               COLUMN g_c[35],sr.fcc031 CLIPPED,
               COLUMN g_c[36],sr.faj04[1,4] CLIPPED,
               COLUMN g_c[37],sr.fcc06 CLIPPED,
               COLUMN g_c[38],sr.fcc05 CLIPPED,
               COLUMN g_c[39], sr.fcc07 CLIPPED,
               COLUMN g_c[40],sr.fcc08 CLIPPED,
               COLUMN g_c[41],sr.faj51 CLIPPED,
               COLUMN g_c[42],sr.faj49[1,8] CLIPPED,
               COLUMN g_c[43],cl_numfor(sr.amount,43,0) CLIPPED,
               COLUMN g_c[44],sr.fcc14 CLIPPED,
               COLUMN g_c[45],cl_numfor(sr.cost1,45,sr.azi04) CLIPPED,
               COLUMN g_c[46],cl_numfor(sr.cost2,46,g_azi04) CLIPPED,
               COLUMN g_c[47],l_str CLIPPED,
               COLUMN g_c[48],cl_numfor(sr.offset,48,g_azi04) CLIPPED,
               COLUMN g_c[49],l_gem02 CLIPPED,
               COLUMN g_c[50],l_gen02 CLIPPED,
               COLUMN g_c[51],sr.fcc20 CLIPPED
 
      AFTER GROUP OF sr.fcc01
         PRINT COLUMN g_c[43],g_x[9] CLIPPED;
         DECLARE afar760_curs2 CURSOR FOR
          SELECT fcc14,cost1,cost2,fcc15,(cost2*fcc15/100)
            FROM b1_temp
           WHERE fcc01 = sr.fcc01
 
         FOREACH afar760_curs2 INTO xr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           #---------總    計--------
           UPDATE b2_temp SET cost1=cost1 + xr.cost1,
                              cost2=cost2 + xr.cost2
            WHERE fcc14 = xr.fcc14
              AND fcc15 = xr.fcc15
            IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
               INSERT INTO b2_temp
               VALUES(xr.fcc14,xr.cost1,xr.cost2,
                      xr.fcc15)
            END IF
           LET l_str = xr.fcc15 USING '##&','%'
           PRINT COLUMN g_c[44],xr.fcc14 ,
                 COLUMN g_c[45],cl_numfor(xr.cost1,45,sr.azi05),
                 COLUMN g_c[46],cl_numfor(xr.cost2,46,g_azi05),
                 COLUMN g_c[47],l_str,
                 COLUMN g_c[48],cl_numfor(xr.offset,48,g_azi05)
         END FOREACH
 
   ON LAST ROW
      PRINT g_dash2[1,g_len]
      PRINT COLUMN g_c[43],g_x[10] CLIPPED;
      DECLARE afar760_curs3 CURSOR FOR
       SELECT fcc14,cost1,cost2,fcc15,(cost2*fcc15/100)
         FROM b2_temp
         FOREACH afar760_curs3 INTO xr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET l_str = xr.fcc15 USING '##&','%'
           PRINT COLUMN g_c[44],xr.fcc14 ,
                 COLUMN g_c[45],cl_numfor(xr.cost1,45,sr.azi05),
                 COLUMN g_c[46],cl_numfor(xr.cost2,46,g_azi05),
                 COLUMN g_c[47],l_str,
                 COLUMN g_c[48],cl_numfor(xr.offset,48,g_azi05)
         END FOREACH
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
       IF l_last_sw = 'n' THEN
           PRINT g_dash[1,g_len]
           PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
       ELSE
           SKIP 2 LINE
       END IF
END REPORT}                                                                   #FUN-780018
 
FUNCTION r760_create_temp1()
   DROP TABLE b1_temp
#No.FUN-680070  -- begin --
#   CREATE TEMP TABLE b1_temp(
#     fcc01 VARCHAR(16),    #No.FUN-550034
#     fcc14 VARCHAR(4),
#     cost1 dec(20,6),
#     cost2 dec(20,6),
#     fcc15 smallint);
   CREATE TEMP TABLE b1_temp(
     fcc01 LIKE fcc_file.fcc01,
     fcc14 LIKE fcc_file.fcc14,
     cost1 LIKE type_file.num20_6,
     cost2 LIKE type_file.num20_6,
     fcc15 LIKE fcc_file.fcc15);
#No.FUN-680070  -- end --
END FUNCTION
 
FUNCTION r760_create_temp2()
   DROP TABLE b2_temp
#No.FUN-680070  -- begin --
#   CREATE TEMP TABLE b2_temp(
#     fcc14 VARCHAR(4),
#     cost1 dec(20,6),
#     cost2 dec(20,6),
#     fcc15 smallint);
   CREATE TEMP TABLE b2_temp(
     fcc14 LIKE fcc_file.fcc14,
     cost1 LIKE type_file.num20_6,
     cost2 LIKE type_file.num20_6,
     fcc15 LIKE fcc_file.fcc15);
#No.FUN-680070  -- end --
END FUNCTION
