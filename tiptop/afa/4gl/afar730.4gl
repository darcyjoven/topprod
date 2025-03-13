# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: afar730.4gl
# Descriptions...: 投資抵減被刪除清單
# Date & Author..: 96/05/14 By STAR
# Modify.........: No.FUN-510035 05/01/25 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By Jackho  本（原）幣取位修改
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-780018 07/08/08 By xiaofeizhu 制作水晶報表
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80054 11/08/04 By fengrui  程式撰寫規範修正 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,       # Where condition       #No.FUN-680070 VARCHAR(1000)
              more    LIKE type_file.chr1,          # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
              s       LIKE type_file.chr5           # Order by sequence       #No.FUN-680070 VARCHAR(5)
              END RECORD,
          m_codest  LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(34)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE   l_table         STRING                      #No.FUN-780018                                                                 
DEFINE   g_sql           STRING                      #No.FUN-780018                                                                
DEFINE   g_str           STRING                      #No.FUN-780018                                                                
 
 
 
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
### *** FUN-780018 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
    LET g_sql = "fcc01.fcc_file.fcc01,",                                                                                            
                "fcc02.fcc_file.fcc02,",                                                                                            
                "fcc06.fcc_file.fcc06,",                                                                                            
                "fcc05.fcc_file.fcc05,",                                                                                          
                "fcc08.fcc_file.fcc08,",                                                                                            
                "faj51.faj_file.faj51,",                                                                                            
                "faj49.faj_file.faj49,",                                                                                            
                "fcc09.fcc_file.fcc09,",                                                                                            
                "fcc14.fcc_file.fcc14,",                                                                                            
                "fcc13.fcc_file.fcc13,",                                                                                            
                "fcc16.fcc_file.fcc16,",                                                                                            
                "fcc15.fcc_file.fcc15,",                                                                                            
                "fcc161.fcc_file.fcc16,",                                                                                            
                "fcc03.fcc_file.fcc03,",  
                "fcc031.fcc_file.fcc031,",                                                                                            
                "fcb03.fcb_file.fcb03,",                                                                                            
                "fcb04.fcb_file.fcb04,",                                                                                            
                "chr1.type_file.chr1,",                                                                                            
                "fcb05.fcb_file.fcb05,",                                                                                            
                "fcb06.fcb_file.fcb06,",                                                                                            
                "chr1a.type_file.chr1,",                                                                                          
                "azi04.azi_file.azi04"
    LET l_table = cl_prt_temptable('afar730',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生 
 
#----------------------------------------------------------CR (1) ------------# 
                                                                                         
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL afar730_tm(0,0)        # Input print condition
      ELSE CALL afar730()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afar730_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 18
 
   OPEN WINDOW afar730_w AT p_row,p_col WITH FORM "afa/42f/afar730"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s  = '123  '
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.s4   = tm.s[4,4]
   LET tm2.s5   = tm.s[5,5]
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fcb03,fcb04,fcb05,fcb06,fcc03
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
         LET INT_FLAG = 0 CLOSE WINDOW afar730_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
         INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.s4,tm2.s5,tm.more WITHOUT DEFAULTS
 
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
               LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1],tm2.s4[1,1],tm2.s5[1,1]
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
         LET INT_FLAG = 0 CLOSE WINDOW afar730_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar730'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar730','9031',1)
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
                            " '",tm.s  CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afar730',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW afar730_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar730()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW afar730_w
END FUNCTION
 
FUNCTION r730_create_temp1()
   DROP TABLE b1_temp
#No.FUN-680070  -- begin --
#   CREATE TEMP TABLE b1_temp(                                           
#     fcc14 VARCHAR(4),
#     fcc13 dec(20,6),                                                    
#     fcc15 SMALLINT);
   CREATE TEMP TABLE b1_temp(
     fcc14 LIKE fcc_file.fcc14,
     fcc13 LIKE fcc_file.fcc13,
     fcc15 LIKE fcc_file.fcc15);
#No.FUN-680070  -- end --
END FUNCTION
 
FUNCTION afar730()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0069
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680070 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE fcb_file.fcb06,         #No.FUN-680070 VARCHAR(10)
          l_fcc16,l_fcc161 LIKE fcc_file.fcc16,              #No.FUN-780018         
          l_str     STRING,                                  #No.FUN-780018                                                                    
          sr        RECORD order1 LIKE fcb_file.fcb06,       #No.FUN-680070 VARCHAR(10)
                           order2 LIKE fcb_file.fcb06,       #No.FUN-680070 VARCHAR(10)
                           order3 LIKE fcb_file.fcb06,       #No.FUN-680070 VARCHAR(10)
                           order4 LIKE fcb_file.fcb06,       #No.FUN-680070 VARCHAR(10)
                           order5 LIKE fcb_file.fcb06,       #No.FUN-680070 VARCHAR(10)
                           fcc01  LIKE fcc_file.fcc01,       #No.FUN-780018
                           fcc02  LIKE fcc_file.fcc02,
                           fcc06  LIKE fcc_file.fcc06,
                           fcc05  LIKE fcc_file.fcc05,
                           fcc08  LIKE fcc_file.fcc08,
                           faj51  LIKE faj_file.faj51,
                           faj49  LIKE faj_file.faj49,
                           fcc09  LIKE fcc_file.fcc09,
                           fcc14  LIKE fcc_file.fcc14,
                           fcc13  LIKE fcc_file.fcc13,
                           fcc16  LIKE fcc_file.fcc16,
                           fcc15  LIKE fcc_file.fcc15,
                           fcc161 LIKE fcc_file.fcc16,
                           fcc03  LIKE fcc_file.fcc03,
                           fcc031 LIKE fcc_file.fcc031,
                           fcb03  LIKE fcb_file.fcb03,
                           fcb04  LIKE fcb_file.fcb04,
                           code1  LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
                           fcb05  LIKE fcb_file.fcb05,
                           fcb06  LIKE fcb_file.fcb06,
                           code2  LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
                           fcc20  LIKE fcc_file.fcc20,
                           azi03  LIKE azi_file.azi03,
                           azi04  LIKE azi_file.azi04,
                           azi05  LIKE azi_file.azi05
                        END RECORD
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
                                                                                                                                    
#No.FUN-780018--end--  
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-780018 *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
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
 
#    LET l_sql = "SELECT '','','','','',fcc02,fcc06,fcc05,fcc08,faj51, ",                #FUN-780018
     LET l_sql = "SELECT '','','','','',fcc01,fcc02,fcc06,fcc05,fcc08,faj51, ",          #FUN-780018
                 "       faj49,fcc09,fcc14,fcc13,fcc16, ",
                 "       fcc15,(fcc16*fcc15)/100,fcc03,fcc031,fcb03,fcb04, ",
                 "       '',fcb05,fcb06,'',fcc20,azi03,azi04,azi05  ",
                 "  FROM fcb_file, fcc_file,OUTER faj_file, azi_file   ",
                 " WHERE fcc_file.fcc03 = faj_file.faj02 ",
                 "   AND fcc_file.fcc031= faj_file.faj022 ",
                 "   AND fcc14 = azi_file.azi01 ",
                 "   AND fcb01 = fcc01 ",
                 "   AND fcbconf != 'X' ", #010802 增
                 "   AND fcc04 != '0' ",
                 "   AND fcc20 IN ('4','6') ",
                 "   AND ",tm.wc CLIPPED
 
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
 
     PREPARE afar730_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar730_curs1 CURSOR FOR afar730_prepare1
 
#    CALL cl_outnam('afar730') RETURNING l_name                          #FUN-780018
 
#    START REPORT afar730_rep TO l_name                                  #FUN-780018
     LET g_pageno = 0
 
#    CALL r730_create_temp1()                                            #FUN-780018
     FOREACH afar730_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       # 若前面user 按下 control-t 則會顯示目前做到第 n 筆                                                                          
      {FOR g_i = 1 TO 5                                                  #FUN-780018
          CASE WHEN tm.s[g_i,g_i] = '1'
                    LET l_order[g_i] = sr.fcb03 USING 'yyyymmdd'
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.fcb04
               WHEN tm.s[g_i,g_i] = '3'
                    LET l_order[g_i] = sr.fcb05 USING 'yyyymmdd'
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.fcb06
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.fcc03
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       LET sr.order4 = l_order[4]
       LET sr.order5 = l_order[5]}                                      #FUN-780018
       IF cl_null(sr.fcc09) THEN LET sr.fcc09 = 0 END IF
       IF cl_null(sr.fcc13) THEN LET sr.fcc13 = 0 END IF
       IF cl_null(sr.fcc16) THEN LET sr.fcc16 = 0 END IF
       IF cl_null(sr.fcc15) THEN LET sr.fcc15 = 0 END IF
       IF cl_null(sr.fcc161) THEN LET sr.fcc161 = 0 END IF
       IF sr.fcc20='3' THEN LET sr.code1='Y' ELSE LET sr.code1=' ' END IF
       IF sr.fcc20='5' THEN LET sr.code2='Y' ELSE LET sr.code2=' ' END IF
       #---------小    計--------
#      UPDATE b1_temp SET fcc13=fcc13 + sr.fcc13                        #FUN-780018
#       WHERE fcc14  = sr.fcc14  AND fcc15  = sr.fcc15                  #FUN-780018
#       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN                            #FUN-780018
#          INSERT INTO b1_temp                                          #FUN-780018
#          VALUES(sr.fcc14,sr.fcc13,sr.fcc15)                           #FUN-780018
#       END IF                                                          #FUN-780018
#No.FUN-780018--add--     
          SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05 FROM azi_file                
          WHERE azi01=sr.fcc14                                                                                                           
#No.FUN-780018--end-- 
 
#      OUTPUT TO REPORT afar730_rep(sr.*)                              #FUN-780018
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-780018 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
                      sr.fcc01,sr.fcc02,sr.fcc06,sr.fcc05,sr.fcc08,sr.faj51,sr.faj49,sr.fcc09,sr.fcc14,
                      sr.fcc13,sr.fcc16,sr.fcc15,sr.fcc161,sr.fcc03,sr.fcc031,sr.fcb03,sr.fcb04,
                      sr.code1,sr.fcb05,sr.fcb06,sr.code2,t_azi04
          #------------------------------ CR (3) ------------------------------#
     END FOREACH
 
#    FINISH REPORT afar730_rep                                          #FUN-780018
#No.FUN-780018--begin                                                                                                               
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'fcb03,fcb04,fcb05,fcb06,fcc03')                                                                                         
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                        
#No.FUN-780018--end
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                        #FUN-780018
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-780018 **** ##           
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                             
    LET g_str = ''                                                                                                                  
    LET g_str = g_azi04,";",g_azi05,";",tm.wc,";",'',";",tm.s[1,1],";",                                                             
                tm.s[2,2],";",tm.s[3,3],";",tm.s[4,4],";",tm.s[5,5]                                         
    CALL cl_prt_cs3('afar730','afar730',l_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------# 
     
END FUNCTION
 
{ REPORT afar730_rep(sr)                                                #FUN-780018  
   DEFINE l_last_sw    LIKE type_file.chr1,           #No.FUN-680070 VARCHAR(1)
          l_fcc16,l_fcc161 LIKE fcc_file.fcc16,       #No.FUN-680070 DECIMAL(16,2)
#          l_azi03      LIKE azi_file.azi03,          #No.CHI-6A0004 mark
#          l_azi04      LIKE azi_file.azi04,          #No.CHI-6A0004 mark
#          l_azi05      LIKE azi_file.azi05,          #No.CHI-6A0004 mark 
          l_str        STRING,
          xr           RECORD fcc14  LIKE fcc_file.fcc14,
                              fcc13  LIKE fcc_file.fcc13,
                              fcc15  LIKE fcc_file.fcc15
                       END RECORD,
          sr           RECORD order1 LIKE fcb_file.fcb06,       #No.FUN-680070 VARCHAR(10)
                              order2 LIKE fcb_file.fcb06,       #No.FUN-680070 VARCHAR(10)
                              order3 LIKE fcb_file.fcb06,       #No.FUN-680070 VARCHAR(10)
                              order4 LIKE fcb_file.fcb06,       #No.FUN-680070 VARCHAR(10)
                              order5 LIKE fcb_file.fcb06,       #No.FUN-680070 VARCHAR(10)
                              fcc02  LIKE fcc_file.fcc02,
                              fcc06  LIKE fcc_file.fcc06,
                              fcc05  LIKE fcc_file.fcc05,
                              fcc08  LIKE fcc_file.fcc08,
                              faj51  LIKE faj_file.faj51,
                              faj49  LIKE faj_file.faj49,
                              fcc09  LIKE fcc_file.fcc09,
                              fcc14  LIKE fcc_file.fcc14,
                              fcc13  LIKE fcc_file.fcc13,
                              fcc16  LIKE fcc_file.fcc16,
                              fcc15  LIKE fcc_file.fcc15,
                              fcc161 LIKE fcc_file.fcc16,
                              fcc03  LIKE fcc_file.fcc03,
                              fcc031 LIKE fcc_file.fcc031,
                              fcb03  LIKE fcb_file.fcb03,
                              fcb04  LIKE fcb_file.fcb04,
                              code1  LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
                              fcb05  LIKE fcb_file.fcb05,
                              fcb06  LIKE fcb_file.fcb06,
                              code2  LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
                              fcc20  LIKE fcc_file.fcc20,
                              azi03  LIKE azi_file.azi03,
                              azi04  LIKE azi_file.azi04,
                              azi05  LIKE azi_file.azi05
                       END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,sr.order4,sr.order5
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
            g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],
            g_x[47],g_x[48],g_x[49]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
          SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05 FROM azi_file           #No.CHI-6A0004 l_azi-->t_azi
          WHERE azi01=sr.fcc14
          LET l_str = sr.fcc15 USING '##&','%'
          PRINT COLUMN g_c[31],sr.fcc02 USING '###&',
                COLUMN g_c[32],sr.fcc06,
                COLUMN g_c[33],sr.fcc05,
                COLUMN g_c[34],sr.fcc08,
                COLUMN g_c[35],sr.faj51,
                COLUMN g_c[36],sr.faj49,
                COLUMN g_c[37],cl_numfor(sr.fcc09,37,0),
                COLUMN g_c[38],sr.fcc14,
                COLUMN g_c[39],cl_numfor(sr.fcc13,39,t_azi04),                  #No.CHI-6A0004 l_azi-->t_azi
                COLUMN g_c[40],cl_numfor(sr.fcc16,40,g_azi04),
                COLUMN g_c[41],l_str,
                COLUMN g_c[42],cl_numfor(sr.fcc161,42,g_azi04);
          LET l_str = sr.fcc03,' ',sr.fcc031
          PRINT COLUMN g_c[43],l_str,
                COLUMN g_c[44],sr.fcb03,
                COLUMN g_c[45],sr.fcb04,
                COLUMN g_c[46],sr.code1,
                COLUMN g_c[47],sr.fcb05,
                COLUMN g_c[48],sr.fcb06,
                COLUMN g_c[49],sr.code2
 
   ON LAST ROW
        PRINT COLUMN g_c[32],g_x[9] CLIPPED ;
         DECLARE afar730_curs2 CURSOR FOR
          SELECT fcc14,fcc13,fcc15
            FROM b1_temp
 
         FOREACH afar730_curs2 INTO xr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET l_str = xr.fcc15 USING '##&','%'
           PRINT COLUMN g_c[38],xr.fcc14 ,
                 COLUMN g_c[39],cl_numfor(xr.fcc13,39,t_azi04),    #No.CHI-6A0004 l_azi-->t_azi
                 COLUMN g_c[41],l_str
         END FOREACH
        PRINT COLUMN g_c[32],g_x[10] CLIPPED ,
              COLUMN g_c[40],cl_numfor(SUM(sr.fcc16),40,g_azi05),
              COLUMN g_c[42],cl_numfor(SUM(sr.fcc161),42,g_azi05)
 
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
END REPORT}                                                           #FUN-780018
 
