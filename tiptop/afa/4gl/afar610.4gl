# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: afar610.4gl
# Descriptions...: 固定資產盤點清冊
# Date & Author..: 96/05/08 By Sophia
# Modify.........: No.FUN-510035 05/02/02 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0009 06/12/08 By Rayven 表頭制表日期等位置調整
# Modify.........: No.MOD-6C0184 06/12/29 By Smapmin 應列印出原保管資料
# Modify.........: No.FUN-770052 07/08/03 By xiaofeizhu 制作水晶報表
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0036 10/08/09 By vealxu 增加"族群"之欄位
# Modify.........: No.CHI-AB0020 10/11/22 By Summer 增加保管人姓名,部門名稱,位置名稱
# Modify.........: No.MOD-D10259 13/01/29 By Polly 調整傳入分頁參數值
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD                    # Print condition RECORD
              wc       STRING,           # Where condition
              s        LIKE type_file.chr4,           # Order by sequence       #No.FUN-680070 VARCHAR(4)
              t        LIKE type_file.chr3,           # Eject sw       #No.FUN-680070 VARCHAR(3)
              more     LIKE type_file.chr1            # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
              END RECORD,
          g_str     LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(40)
          g_desc    LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(10)
          g_yy      LIKE type_file.chr4,         #No.FUN-680070 VARCHAR(4)
          g_mm      LIKE type_file.chr2         #No.FUN-680070 VARCHAR(2)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE   l_table         STRING,                 ### FUN-770052 ###                                                                    
         g_sql           STRING                  ### FUN-770052 ### 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
### *** FUN-770052 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
    LET g_sql = "fca01.fca_file.fca01,",                                                                                            
                "fca02.fca_file.fca02,",                                                                                            
                "fca03.fca_file.fca03,",                                                                                            
                "fca031.fca_file.fca031,",                                                                                          
                "fca05.fca_file.fca05,",                                                                                            
                "gem02.gem_file.gem02,", #CHI-AB0020 add                                                                                            
                "fca06.fca_file.fca06,",                                                                                            
                "gen02.gen_file.gen02,", #CHI-AB0020 add                                                                                           
                "fca07.fca_file.fca07,",                                                                                            
                "faf02.faf_file.faf02,", #CHI-AB0020 add                                                                                           
                "faj26.faj_file.faj26,",                                                                                            
                "faj07.faj_file.faj07,",                                                                                            
                "faj06.faj_file.faj06,",                                                                                           
                "faj08.faj_file.faj08,",                                                                                           
                "num5.type_file.num5,",                                                                                           
                "fca04.fca_file.fca04,",                                                                                           
                "faj04.faj_file.faj04,",
                "fca21.fca_file.fca21"                #FUN-9A0036 add fca21    
    LET l_table = cl_prt_temptable('afar610',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"  #CHI-AB0020 mod                                   
                #" VALUES(?, ?, ?, ?, ?, ?, ?,      #CHI-AB0020 mark                                                                              
                #         ?, ?, ?, ?, ?, ?, ?, ?)"  #FUN-9A0036 add ? #CHI-AB0020 mark                                                                                    
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#
 
   LET g_pdate  = ARG_VAL(1)       # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.s     = ARG_VAL(8)
   LET tm.t     = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N' # If background job sw is off
      THEN CALL r610_tm(0,0)         # Input print condition
      ELSE CALL r610()               # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION r610_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r610_w AT p_row,p_col WITH FORM "afa/42f/afar610"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '123'
   LET tm.t    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_yy = YEAR(g_today)
   LET g_mm = MONTH(g_today)
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
      CONSTRUCT BY NAME tm.wc ON fca01,faj04,fca03,fca04,fca06,fca05,fca07,
                              faj26
 
## No:2377 modify 1998/07/17  -----------
 
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
## --------------------------------------
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r610_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc =  " 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
         INPUT BY NAME
            tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,tm.more
            WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
            AFTER FIELD more
               IF cl_null(tm.more) OR tm.more NOT MATCHES '[YN]' THEN
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
         LET INT_FLAG = 0 CLOSE WINDOW r610_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar610'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar610','9031',1)
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
                            " '",tm.s CLIPPED,"'",
                            " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afar610',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW r610_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r610()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r610_w
END FUNCTION
 
FUNCTION r610()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0069
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680070 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE fca_file.fca01,     #No.FUN-680070 VARCHAR(30)
          sr        RECORD order1 LIKE fca_file.fca01,   #No.FUN-680070 VARCHAR(20)
                           order2 LIKE fca_file.fca01,   #No.FUN-680070 VARCHAR(20)
                           order3 LIKE fca_file.fca01,   #No.FUN-680070 VARCHAR(20)
                           fca01  LIKE fca_file.fca01,   #盤點編號
                           fca02  LIKE fca_file.fca02,   #盤點序號
                           fca03  LIKE fca_file.fca03,   #財產編號
                           fca031 LIKE fca_file.fca031,  #財產附號
                           fca04  LIKE fca_file.fca04,   #序號範圍
                           fca05  LIKE fca_file.fca05,   #保管部門
                           gem02  LIKE gem_file.gem02,   #部門名稱 #CHI-AB0020 add
                           fca06  LIKE fca_file.fca06,   #保管人
                           gen02  LIKE gen_file.gen02,   #保管人名稱 #CHI-AB0020 add
                           fca07  LIKE fca_file.fca07,   #存放位置
                           faf02  LIKE faf_file.faf02,   #存放位置名稱 #CHI-AB0020 add
                           faj04  LIKE faj_file.faj04,   #資產類別
                           faj20  LIKE faj_file.faj20,   #保管部門
                           faj19  LIKE faj_file.faj19,   #保管人
                           faj21  LIKE faj_file.faj21,   #存放位置
                           faj26  LIKE faj_file.faj26,   #入帳日期
                           faj07  LIKE faj_file.faj07,   #英文名稱
                           faj06  LIKE faj_file.faj06,   #中文名稱
                           faj08  LIKE faj_file.faj08,   #規格型號
                           fcacnt LIKE type_file.num5,   #No.FUN-680070 SMALLINT
                           flag   LIKE type_file.chr1,   #No.FUN-680070 VARCHAR(01)
                           fca21  LIKE fca_file.fca21    #FUN-9A0036 add 
                    END RECORD
     DEFINE  g_head1       STRING                        #FUN-770052
 
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
 
 
     LET l_sql = "SELECT '','','',",           #組SQL
                 "fca01,fca02,fca03,fca031,fca04,fca05,gem02,fca06,gen02,fca07,faf02,", #CHI-AB0020 add gem02,gen02,faf02
                 "faj04,faj20,faj19,faj21,",
                 "faj26,faj07,faj06,faj08,faj17-faj58,'Y',fca21",     #FUN-9A0036 add fca21 
                #"  FROM fca_file,faj_file", #CHI-AB0020 mark
                 "  FROM faj_file,fca_file", #CHI-AB0020
                 "  LEFT JOIN gem_file ON fca05 = gem01 ", #CHI-AB0020 add
                 "  LEFT JOIN gen_file ON fca06 = gen01 ", #CHI-AB0020 add
                 "  LEFT JOIN faf_file ON fca07 = faf01 ", #CHI-AB0020 add
                 " WHERE fca03 = faj02 ",
                 "   AND fca031 = faj022 ",
                 "   AND ",tm.wc
 
     PREPARE r610_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r610_curs1 CURSOR FOR r610_prepare1
#    CALL cl_outnam('afar610') RETURNING l_name               #FUN-770052    
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-770052 *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-770052 add ###                                              
     #------------------------------ CR (2) ------------------------------# 
 
#    START REPORT r610_rep TO l_name                          #FUN-770052
     LET g_pageno = 0
 
     FOREACH r610_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
     { FOR g_i = 1 TO 3                                               #FUN-770052
         CASE
           WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.fca01
           WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.faj04
           WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.fca03
           WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.fca04
           WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.fca06
           WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.fca05
           WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.fca07
           WHEN tm.s[g_i,g_i] = '8' LET l_order[g_i] = sr.faj26 USING 'yyyymmdd'
           OTHERWISE LET l_order[g_i] = '-'
         END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
#      OUTPUT TO REPORT r610_rep(sr.*)}                                #FUN-770052
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-770052 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
                   sr.fca01,sr.fca02,sr.fca03,sr.fca031,sr.fca05,sr.gem02,sr.fca06,sr.gen02,sr.fca07,sr.faf02,sr.faj26, #CHI-AB0020 add gem02,gen02,faf02
                   sr.faj07,sr.faj06,sr.faj08,sr.fcacnt,sr.fca04,sr.faj04,sr.fca21               #FUN9A0036 add fca21
          #------------------------------ CR (3) ------------------------------#
     END FOREACH
 
#    FINISH REPORT r610_rep                                            #FUN-770052
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                       #FUN-770052
#No.FUN-770052--begin                                                                                                               
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'fca01,faj04,fca03,fca04,fca06,fca05,fca07')                                                               
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                        
    LET g_head1= g_yy CLIPPED,'年',g_mm CLIPPED,'月'                     #FUN-770052
#No.FUN-770052--end  
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-770052 **** ##                                                        
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = g_head1,";",'',";",tm.wc,";",g_azi04,";",tm.s[1,1],";",                                                          
                tm.s[2,2],";",tm.s[3,3],";",                                                                                        
                tm.t,";",tm.t,";",tm.t                                     #MOD-D10259 add
               #tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3]                      #MOD-D10259 mark
    CALL cl_prt_cs3('afar610','afar610',l_sql,g_str)                                                                                  
    #------------------------------ CR (4) ------------------------------# 
END FUNCTION
 
{REPORT r610_rep(sr)                                     #FUN-770052
   DEFINE l_last_sw LIKE type_file.chr1,                 #No.FUN-680070 VARCHAR(1)
          sr        RECORD order1 LIKE fca_file.fca01,   #No.FUN-680070 VARCHAR(30)
                           order2 LIKE fca_file.fca01,   #No.FUN-680070 VARCHAR(30)
                           order3 LIKE fca_file.fca01,   #No.FUN-680070 VARCHAR(30)
                           fca01  LIKE fca_file.fca01,   #盤點編號
                           fca02  LIKE fca_file.fca02,   #盤點序號
                           fca03  LIKE fca_file.fca03,   #財產編號
                           fca031 LIKE fca_file.fca031,  #財產附號
                           fca04  LIKE fca_file.fca04,   #序號範圍
                           fca05  LIKE fca_file.fca05,   #保管部門
                           fca06  LIKE fca_file.fca06,   #保管人
                           fca07  LIKE fca_file.fca07,   #存放位置
                           faj04  LIKE faj_file.faj04,   #資產類別
                           faj20  LIKE faj_file.faj20,   #保管部門
                           faj19  LIKE faj_file.faj19,   #保管人
                           faj21  LIKE faj_file.faj21,   #存放位置
                           faj26  LIKE faj_file.faj26,   #入帳日期
                           faj07  LIKE faj_file.faj07,   #英文名稱
                           faj06  LIKE faj_file.faj06,   #中文名稱
                           faj08  LIKE faj_file.faj08,   #規格型號
                           fcacnt LIKE type_file.num5,   #No.FUN-680070 SMALLINT
                           flag   LIKE type_file.chr1    #No.FUN-680070 VARCHAR(01)
                    END RECORD,
      l_chr        LIKE type_file.chr1,                  #No.FUN-680070 VARCHAR(1)
      l_str        STRING,
      g_head1      STRING
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,sr.fca01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  #No.TQC-6C0009 mark
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  #No.TQC-6C0009 
      LET g_head1 = g_yy CLIPPED,g_x[12],
                    g_mm CLIPPED,g_x[13]
      PRINT g_head1
      PRINT g_dash[1,g_len]
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
                     g_x[38],g_x[39],g_x[40],g_x[41]
      PRINTX name=H2 g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],
                     g_x[49],g_x[50],g_x[51],g_x[52],g_x[53],g_x[54],g_x[55]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   ON EVERY ROW
      LET l_str = sr.fca01,'  ',cl_numfor(sr.fca02,4,0)
      PRINTX name=D2 COLUMN g_c[42],l_str;                             #盤點編號,序號
      LET l_str = sr.fca03,'  ',sr.fca031
      PRINTX name=D2 COLUMN g_c[43],l_str,                             #財產編號,附號
            #-----MOD-6C0184---------
            #COLUMN g_c[44],sr.faj20,                          #保管部門
            #COLUMN g_c[45],sr.faj19,                          #保管人
            #COLUMN g_c[46],sr.faj21,                          #存放位置
            COLUMN g_c[44],sr.fca05,                          #保管部門
            COLUMN g_c[45],sr.fca06,                          #保管人
            COLUMN g_c[46],sr.fca07,                          #存放位置
            #-----END MOD-6C0184-----
            COLUMN g_c[47],sr.faj26,                          #入帳日期
            COLUMN g_c[48],sr.faj07[1,20],                    #英文名稱
            COLUMN g_c[49],sr.faj06[1,20],                    #中文名稱
            COLUMN g_c[50],sr.faj08[1,20],                    #規格型號
            COLUMN g_c[51],cl_numfor(sr.fcacnt,51,g_azi04)          #NO:7502
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'fca01,faj04,fca03,fca04,fca06,fca05,fca07')
              RETURNING tm.wc
         PRINT g_dash[1,g_len]
        #-- TQC-630166 begin
          #    IF tm.wc[001,070] > ' ' THEN            # for 80
          #PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
          #    IF tm.wc[071,140] > ' ' THEN
          #PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
          #    IF tm.wc[141,210] > ' ' THEN
          #PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
          #    IF tm.wc[211,280] > ' ' THEN
          #PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
          CALL cl_prt_pos_wc(tm.wc)
        #--TQC-630166 end
      END IF
      PRINT g_dash[1,g_len]
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED  #No.TQC-6C0009
      PRINT #No.TQC-6C0009
      PRINT g_x[9] CLIPPED,'                ',
            g_x[10] CLIPPED,'                ',
            g_x[11] CLIPPED
      LET l_last_sw = 'y'
#     PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED  #No.TQC-6C0009 mark
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED  #No.TQC-6C0009
      PRINT #No.TQC-6C0009
      PRINT g_x[9] CLIPPED,'                ',
            g_x[10] CLIPPED,'                ',
            g_x[11] CLIPPED
#     PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED  #No.TQC-6C0009 mark
#        ELSE SKIP 3 LINE  #No.TQC-6C0009 mark
         ELSE SKIP 4 LINE  #No.TQC-6C0009
      END IF
END REPORT}                                                                  #FUN-770052
