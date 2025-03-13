# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: afar820.4gl
# Descriptions...: 免稅盤點清單列印
# Date & Author..: 96/05/31 By STAR
# Modify.........: No.FUN-510035 05/01/25 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-550034 05/05/17 by day   單據編號加大
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By Jackho  本（原）幣取位修改
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-850010 08/05/08 Byve007 報表輸出方式改為CR
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                                   # Print condition RECORD
              wc      LIKE type_file.chr1000,       # Where condition            #No.FUN-680070 VARCHAR(1000)
              more    LIKE type_file.chr1,          # Input more condition(Y/N)  #No.FUN-680070 VARCHAR(1)
              sw      LIKE type_file.chr1,          #No.FUN-680070 VARCHAR(1)
              s       LIKE type_file.chr8,          # Order by sequence          #No.FUN-680070 VARCHAR(7)
              t       LIKE type_file.chr5           # Eject sw                   #No.FUN-680070 VARCHAR(5)
           END RECORD,
       m_codest       LIKE type_file.chr1000        #No.FUN-680070 VARCHAR(34)
#      g_azi03        LIKE azi_file.azi03,
#      g_azi05        LIKE azi_file.azi05
 
DEFINE g_i            LIKE type_file.num5           #count/index for any purpose #No.FUN-680070 SMALLINT
 
DEFINE t4             LIKE type_file.num5           #No.FUN-680070 SMALLINT
DEFINE l_table        STRING,                           #No.FUN-850010
       g_sql          STRING,                           #No.FUN-850010
       g_str          STRING                            #No.FUN-850010
 
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
   #No.FUN-850010--begin--
  
   LET g_sql = "faj20.faj_file.faj20,",
               "gen02.gen_file.gen02,",
               "fci03.fci_file.fci03,",
               "fci031.fci_file.fci031,",
               "fci05.fci_file.fci05,",
               "fci04.fci_file.fci04,",
               "fci08.fci_file.fci08,",
               "fci06.fci_file.fci06,",
               "fci01.fci_file.fci01,",
               "fci02.fci_file.fci02,",
               "fci09.fci_file.fci09,",
               "fci10.fci_file.fci10,",
               "fci15.fci_file.fci15,",
               "fci17.fci_file.fci17,",
               "fci14.fci_file.fci14,",
               "fci11.fci_file.fci11,",
               "fch01.fch_file.fch01,",
               "fch02.fch_file.fch02,",
               "faj19.faj_file.faj19,",
               "fci18.fci_file.fci18,",
               "faj02.faj_file.faj02"
   LET l_table = cl_prt_temptable('afar820',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "                                                                               
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                        
   #No.FUN-850010--end--
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.sw = ARG_VAL(10)   #TQC-610055
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL afar820_tm(0,0)        # Input print condition
      ELSE CALL afar820()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afar820_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 15
 
   OPEN WINDOW afar820_w AT p_row,p_col WITH FORM "afa/42f/afar820"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.sw = '1'
   LET tm.s  = '167 '
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
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.t4   = tm.t[4,4]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.s4) THEN LET tm2.s4 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.t4) THEN LET tm2.t4 = "N" END IF
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fch01,fch02,faj20,faj19,faj02,fci18,fci02
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
         LET INT_FLAG = 0 CLOSE WINDOW afar820_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
         INPUT BY NAME
            tm2.s1,tm2.s2,tm2.s3,tm2.s4,
            tm2.t1,tm2.t2,tm2.t3,tm2.t4,tm.sw,tm.more
            WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
            AFTER FIELD sw
               IF cl_null(tm.sw) OR tm.sw NOT MATCHES '[12]' THEN
                  NEXT FIELD sw
               ELSE
                  IF tm.sw = '2' THEN
                     LET tm.wc = tm.wc CLIPPED ,
                                " AND (fci07 = '' OR fci07 IS NULL) "
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
            AFTER INPUT
               LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1],tm2.s4[1,1]
               LET tm.t = tm2.t1,tm2.t2,tm2.t3,tm2.t4
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
         LET INT_FLAG = 0 CLOSE WINDOW afar820_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar820'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar820','9031',1)
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
                            " '",tm.sw  CLIPPED,"'",   #TQC-610055
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
 
            CALL cl_cmdat('afar820',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW afar820_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar820()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW afar820_w
END FUNCTION
 
FUNCTION afar820()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0069
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680070 VARCHAR(40)
#No.FUN-550034-begin
          l_order   ARRAY[6] OF LIKE fch_file.fch01,         #No.FUN-680070 VARCHAR(16)
          sr        RECORD order1 LIKE fch_file.fch01,       #No.FUN-680070 VARCHAR(16)
                           order2 LIKE fch_file.fch01,       #No.FUN-680070 VARCHAR(16)
                           order3 LIKE fch_file.fch01,       #No.FUN-680070 VARCHAR(16)
                           order4 LIKE fch_file.fch01,       #No.FUN-680070 VARCHAR(16)
                           order5 LIKE fch_file.fch01,       #No.FUN-680070 VARCHAR(16)
                           order6 LIKE fch_file.fch01,       #No.FUN-680070 VARCHAR(16)
                           ordert LIKE type_file.chr1000,    #No.FUN-680070 VARCHAR(30)
                           faj20  LIKE faj_file.faj20,
                           faj19  LIKE faj_file.faj19,
                           fci03  LIKE fci_file.fci03,
                           fci031  LIKE fci_file.fci031,
                           fci05  LIKE fci_file.fci05,
                           fci04  LIKE fci_file.fci04,
                           fci08  LIKE fci_file.fci08,
                           fci06  LIKE fci_file.fci06,
                           fci18  LIKE fci_file.fci18,
                           fci01  LIKE fci_file.fci01,
                           fci02  LIKE fci_file.fci02,
                           fci09  LIKE fci_file.fci09,
                           fci10  LIKE fci_file.fci10,
                           fci15  LIKE fci_file.fci15,
                           fci17  LIKE fci_file.fci17,
                           fci14  LIKE fci_file.fci14,
                           fci11  LIKE fci_file.fci11,
                           fch01  LIKE fch_file.fch01,
                           fch02  LIKE fch_file.fch02,
                           faj02  LIKE faj_file.faj02
                        END RECORD
   define l_order_smallint LIKE type_file.num5         #No.FUN-680070 smallint
#No.FUN-850010 --begin--   
define    l_gen02             LIKE gen_file.gen02,
          l_fci08             LIKE fci_file.fci08,  
          l_fci06             LIKE fci_file.fci06, 
          l_fci10             LIKE fci_file.fci10, 
          l_fci14             LIKE fci_file.fci14
#No.FUN-850010 --end--                    
#No.FUN-550034-end
     CALL cl_del_data(l_table)                         #No.FUN-850010
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog     #No.FUN-850010
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
 
 
   IF tm.sw = '1' THEN
     LET l_sql = "SELECT '','','','','','','',faj20,faj19,fci03,",
                 "fci031, ",
                 "       fci05,fci04,fci08,fci06,fci18,fci01, ",
                 "       fci02,fci20,fci21,fci22,fci17,fci14,fci11,",
                 "       fch01,fch02,faj02 ",
                 "  FROM faj_file,fci_file,fch_file ",
                 " WHERE faj02=fci03 ",
                 "   AND faj022=fci031 ",
                 "   AND fch01=fci01 ",
##Modify:2640
                 "   AND fchconf='Y'",
                 "   AND ",tm.wc CLIPPED
   ELSE
     LET l_sql = "SELECT '','','','','','','',faj20,faj19,",
                 "fci03,fci031, ",
                 "       fci05,fci04,fci08,fci06,fci18,fci01, ",
                 "       fci02,fci09,fci10,fci15,fci17,fci14,fci11,",
                 "       fch01,fch02,faj02 ",
                 "  FROM faj_file,fci_file,fch_file ",
                 " WHERE faj02=fci03 ",
                 "   AND faj022=fci031 ",
                 "   AND fch01=fci01 ",
                 "   AND fchconf !='X' ",  #010803 增
                 "   AND ",tm.wc CLIPPED
   END IF
#No.CHI-6A0004--begin
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#No.CHI-6A0004--end
 
     PREPARE afar820_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar820_curs1 CURSOR FOR afar820_prepare1
 
      CALL cl_outnam('afar820') RETURNING l_name
 
 #   START REPORT afar820_rep TO l_name                 #No.FUN-850010--mark--
     LET g_pageno = 0
 
     FOREACH afar820_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
       IF cl_null(sr.fci15) THEN LET sr.fci15 = 0 END IF
       FOR g_i = 1 TO 6
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.fch01
               WHEN tm.s[g_i,g_i] = '2'
                    LET l_order[g_i] = sr.fch02 USING 'yyyymmdd'
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.faj20
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.faj19
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.faj02
               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.fci18
               WHEN tm.s[g_i,g_i] = '7' # LET l_order[g_i] = sr.fci02
                                        let l_order_smallint =sr.fci02
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
 {     LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       LET sr.order4 = l_order[4]
       LET sr.order5 = l_order[5]
       LET sr.order6 = l_order[6]
       LET sr.ordert = sr.order1,sr.order2,sr.order3,sr.order4,sr.order5
                       ,sr.order6,l_order_smallint
  }
  #No.FUN-850010 --mark--                     
       IF cl_null(sr.fci02) THEN LET sr.fci02 = 0 END IF
       IF cl_null(sr.fci09) THEN LET sr.fci09 = 0 END IF
 #     OUTPUT TO REPORT afar820_rep(sr.*,l_order_smallint)         #No.FUN-850010--mark--
       #No.FUN-850010 --begin-- 
       SELECT gen02 INTO l_gen02 FROM gen_file
                WHERE gen01=sr.faj19
         IF sqlca.sqlcode <>0
            THEN LET l_gen02=' '
         END IF 
       LET l_fci08 = sr.fci08[1,10] 
       LET l_fci06 = sr.fci06[1,15]
       LET l_fci10 = sr.fci10[1,4] 
       LET l_fci14 = sr.fci14[1,12]        
       EXECUTE insert_prep USING sr.faj20,l_gen02,sr.fci03,sr.fci031,sr.fci05,
                                 sr.fci04,l_fci08,l_fci06,sr.fci01,sr.fci02,
                                 sr.fci09,l_fci10,sr.fci15,sr.fci17,l_fci14,
                                 sr.fci11,sr.fch01,sr.fch02,sr.faj19,sr.fci18,sr.faj02
       #No.FUN-850010--end--
     END FOREACH
     #No.FUn-850010 --begin--
     IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'fch01,fch02,faj20,faj19,faj02,fci18,fci02')                                                                       
              RETURNING tm.wc    
     END IF
     LET g_str=tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.s[4,4],";",tm.t[1,1],";",
                         tm.t[2,2],";",tm.t[3,3],";",tm.t[4,4],";",g_azi04                         
                                 
                                                                  
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
                                                      
     CALL cl_prt_cs3('afar820','afar820',l_sql,g_str)
      #No.FUN-850010  -END-- 
#    FINISH REPORT afar820_rep                                     #No.FUN-850010--mark--
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                   #No.FUN-850010--mark--
END FUNCTION
 
{REPORT afar820_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1          #No.FUN-680070 VARCHAR(1)
   DEFINE l_d       LIKE type_file.chr4,         #No.FUN-680070 VARCHAR(4)
          l_str     STRING,
#No.FUN-550034-begin
          sr        RECORD order1 LIKE fch_file.fch01,       #No.FUN-680070 VARCHAR(16)
                           order2 LIKE fch_file.fch01,       #No.FUN-680070 VARCHAR(16)
                           order3 LIKE fch_file.fch01,       #No.FUN-680070 VARCHAR(16)
                           order4 LIKE fch_file.fch01,       #No.FUN-680070 VARCHAR(16)
                           order5 LIKE fch_file.fch01,       #No.FUN-680070 VARCHAR(16)
                           order6 LIKE fch_file.fch01,       #No.FUN-680070 VARCHAR(16)
                           ordert LIKE type_file.chr1000,    #No.FUN-680070 VARCHAR(30)
                           faj20  LIKE faj_file.faj20,
                           faj19  LIKE faj_file.faj19,
                           fci03  LIKE fci_file.fci03,
                           fci031  LIKE fci_file.fci031,
                           fci05  LIKE fci_file.fci05,
                           fci04  LIKE fci_file.fci04,
                           fci08  LIKE fci_file.fci08,
                           fci06  LIKE fci_file.fci06,
                           fci18  LIKE fci_file.fci18,
                           fci01  LIKE fci_file.fci01,
                           fci02  LIKE fci_file.fci02,
                           fci09  LIKE fci_file.fci09,
                           fci10  LIKE fci_file.fci10,
                           fci15  LIKE fci_file.fci15,
                           fci17  LIKE fci_file.fci17,
                           fci14  LIKE fci_file.fci14,
                           fci11  LIKE fci_file.fci11,
                           fch01  LIKE fch_file.fch01,
                           fch02  LIKE fch_file.fch02,
                           faj02  LIKE faj_file.faj02,
                           order_smallint LIKE type_file.num5         #No.FUN-680070 smallint
                        END RECORD
   define l_gen02 like gen_file.gen02
   define i LIKE type_file.num5         #No.FUN-680070 smallint
#No.FUN-550034-end
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  #ORDER BY sr.order1,sr.order2,sr.order3,sr.ordert
  ORDER BY sr.order1,sr.order2,sr.order3,sr.order4,sr.order5,
           sr.order6,sr.order_smallint,sr.ordert
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
            g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
     IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 10) THEN
         SKIP TO TOP OF PAGE
     END IF
 
   BEFORE GROUP OF sr.order2
     IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 10) THEN
        SKIP TO TOP OF PAGE
     END IF
 
   BEFORE GROUP OF sr.order3
     IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 10) THEN
        SKIP TO TOP OF PAGE
     END IF
   BEFORE GROUP OF sr.order4
     IF tm.t[4,4] = 'Y' AND (PAGENO > 1 OR LINENO > 10) THEN
        SKIP TO TOP OF PAGE
     END IF
   BEFORE GROUP OF sr.order5
     IF tm.t[5,5] = 'Y' AND (PAGENO > 1 OR LINENO > 10) THEN
        SKIP TO TOP OF PAGE
     END IF
 
   AFTER GROUP OF sr.ordert
      PRINT COLUMN g_c[31],g_x[9] CLIPPED,
            COLUMN g_c[43],cl_numfor(GROUP SUM(sr.fci15),43,g_azi04)
      SKIP 1 LINE
 
   ON EVERY ROW
         SELECT gen02 INTO l_gen02 FROM gen_file
                WHERE gen01=sr.faj19
         IF sqlca.sqlcode <>0
            THEN LET l_gen02=' '
         END IF
         CASE sr.fci18
             WHEN '1'    LET l_d=g_x[11]
             WHEN '2'    LET l_d=g_x[12]
         END CASE
         LET l_str = sr.fci03,'   ',sr.fci031
         PRINT COLUMN g_c[31],sr.faj20,
               COLUMN g_c[32],l_gen02,
               COLUMN g_c[33],l_str,
               COLUMN g_c[34],sr.fci05,
               COLUMN g_c[35],sr.fci04,
               COLUMN g_c[36],sr.fci08[1,10],
               COLUMN g_c[37],sr.fci06[1,15],
               COLUMN g_c[38],l_d,
               COLUMN g_c[39],sr.fci01,
               COLUMN g_c[40],sr.fci02 USING '###&',
               COLUMN g_c[41],cl_numfor(sr.fci09,41,0),
               COLUMN g_c[42],sr.fci10[1,4],
               COLUMN g_c[43],cl_numfor(sr.fci15,43,g_azi04),
               COLUMN g_c[44],sr.fci17,
               COLUMN g_c[45],sr.fci14[1,12],
               COLUMN g_c[46],sr.fci11
 
   ON LAST ROW
      PRINT g_dash2[1,g_len]
      PRINT COLUMN g_c[31], g_x[10] CLIPPED,
            COLUMN g_c[43], cl_numfor(SUM(sr.fci15),43,g_azi04)
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
 
END REPORT
}
 #No.FUN-850010--mark--
#FUN-870144
