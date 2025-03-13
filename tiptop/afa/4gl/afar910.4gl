# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Desc/riptions...:動產擔保交易登記標的物明細表
# Input parameter:
# Return code....:
# Date & Author..: 96/06/18 By Star
# Modify         : No.MOD-530844 05/03/30 by alexlin VARCHAR->CHAR
# Modify.........: No.MOD-590097 05/09/08 By Tracy 報表畫線寫入zaa
# Modify.........: No.TQC-5A0021 05/10/14 By Sarah 在列印時,sr.faj06只取25碼(因為報表格式只留25碼的寬度)
# Modify.........: No.TQC-610039 06/01/12 by cl 4gl中的全形字符維護到zaa中
# Modify.........: No.TQC-660085 06/06/19 By Smapmin 因應afat900中如果fce06為null時，會指定十個空白
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0009 06/12/06 By Rayven 抬頭格式有錯誤
# Modify.........: No.MOD-730146 07/04/12 By claire zo12改zo02
# Modify.........: No.FUN-850010 08/05/06 By ve007 報表輸出方式 改為CR
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD
                   wc      LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(1000)
                   more    LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
              END RECORD,
          g_zo   RECORD LIKE zo_file.*
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
    define g_ct LIKE type_file.num5         #No.FUN-680070 smallint
    define g_pme record like pme_file.*
DEFINE l_table        STRING,                           #No.FUN-850010
       g_sql          STRING,                           #No.FUN-850010
       g_str          STRING                            #No.FUN-850010    
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                         # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
    #No.FUN-850010--begin--
   LET g_sql = "l_ct.type_file.num5,",
               "fce02.fce_file.fce02,",
               "faj06.faj_file.faj06,",
               "faj07.faj_file.faj07,",
               "faj08.faj_file.faj08,",
               "faj12.faj_file.faj12,", 
               "faj11.faj_file.faj11,",
               "faj29a.faj_file.faj29,",
               "faj29b.faj_file.faj30,",
               "fce21.fce_file.fce21,",
               "fce20.fce_file.fce20,",
               "fce04a.fce_file.fce04,",
               "fce04b.fce_file.fce04,",
               "fcd01.fcd_file.fcd01,",
               "faj26.faj_file.faj26,",
               "pme033a.pme_file.pme033,",
               "pme033b.pme_file.pme033"           
   LET l_table = cl_prt_temptable('afar910',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "                                                                               
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                        
   #No.FUN-850010--end--
 
   let g_page_line =52
   LET g_pdate = ARG_VAL(1)                 # Get arguments from command line
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
      THEN CALL r910_tm(0,0)        # Input print condition
      ELSE CALL afar910()        # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION r910_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 35
 
   OPEN WINDOW r910_w AT p_row,p_col WITH FORM "afa/42f/afar910"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fcd01
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
         LET INT_FLAG = 0 CLOSE WINDOW r910_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
 
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
         LET INT_FLAG = 0 CLOSE WINDOW r910_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar910'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar910','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_lang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('afar910',g_time,l_cmd)
         END IF
         CLOSE WINDOW r910_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar910()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r910_w
END FUNCTION
 
FUNCTION afar910()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0069
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT       #No.FUN-680070 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(40)
          sr               RECORD
                           fce02     LIKE fce_file.fce02,
                           faj06     LIKE faj_file.faj06,
                           faj07     LIKE faj_file.faj07,
                           faj08     LIKE faj_file.faj08,
                           faj12     LIKE faj_file.faj12,
                           faj11     LIKE faj_file.faj11,
                           faj29     LIKE faj_file.faj29,
                           faj30     LIKE faj_file.faj30,
                           fce21     LIKE fce_file.fce21,
                           fce20     LIKE fce_file.fce20,
                           fce04     LIKE fce_file.fce04,
                           fcd01     LIKE fcd_file.fcd01,
                           faj26     LIKE faj_file.faj26,
                           faj15     like faj_file.faj15,
                           faj25     like faj_file.faj25,
                           faj21     like faj_file.faj21
                        END RECORD
     define l_ct LIKE type_file.num5         #No.FUN-680070 smallint
     #No.FUN-850010 --begin--
     DEFINE    l_fce04       LIKE fce_file.fce04,
               l_faj29a      LIKE faj_file.faj29,
               l_faj29b      LIKE type_file.num20_6,
               l_faj12       LIKE faj_file.faj12,
               l_faj11       LIKE faj_file.faj11,
               l_faj06       LIKE faj_file.faj06,
               l_faj07       LIKE faj_file.faj07,
               l_faj08       LIKE faj_file.faj08,
               l_pme033a     LIKE pme_file.pme033,
               l_pme033b     LIKE pme_file.pme033
     #No.FUn-850010 --end--
     
     CALL cl_del_data(l_table)                                    #No.FUN-850010
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog     #No.FUN-850010
   #----- jeffery update ----#
     let g_ct =0
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    SELECT * INTO g_zo.* FROM zo_file WHERE zo01= g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'afar910'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 197 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
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
 
     LET l_sql = "SELECT fce02,faj06,faj07,faj08,faj12,faj11,faj29,faj30, ",
            #---- jeffery update ----#
            #    "       fce21,fce20,fce04,fcd01 ",
                 "  fce21,fce20,fce04,fcd01,faj26,faj15,faj25,faj21 ",
                 "  FROM faj_file,fce_file,fcd_file ",
                 " WHERE faj02 = fce03 ",
                 "   AND faj022= fce031",
                 "   AND fajconf='Y' ",
                 #"   AND (fce06 = ' ' OR fce06 IS NULL) ",   #TQC-660085
                 "   AND (fce06 = '          ' OR fce06 IS NULL) ",   #TQC-660085
                 "   AND fcd01 = fce01 ",
                 "   AND fcdconf != 'X' ",  #010803增
                 "   AND ",tm.wc
#測試用SQL
#    LET l_sql = "SELECT 1,faj06,faj07,faj08,faj12,faj11,faj29,faj30, ",
#                "  'PCS',100,10000,'ABC-123456',faj26,faj15,faj25,faj21 ",
#                "  FROM faj_file ",
#                " WHERE fajconf = 'Y' "   #010803增
 
     PREPARE r910_prepare FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r910_cs CURSOR FOR r910_prepare
 
 #   CALL cl_outnam('afar910') RETURNING l_name        #No.FUN-850010 --mark--
 
 #   START REPORT r910_rep TO l_name                   #No.FUN-850010 --mark--
     LET g_pageno=0
 
     LET l_ct =0
     FOREACH r910_cs INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       let l_ct = l_ct +1
       #-------- 抓存放位置 --------#
       case
          when sr.faj21 ="1"
               select * into g_pme.* from pme_file where pme01="MS011"
          otherwise
               select * into g_pme.* from pme_file where pme01="MS021"
       end case
       IF cl_null(sr.fce02) THEN LET sr.fce02 = 0 END IF
       IF cl_null(sr.fce20) THEN LET sr.fce20 = 0 END IF
       IF cl_null(sr.fce04) THEN LET sr.fce04 = 0 END IF
       IF cl_null(sr.fce21) THEN LET sr.fce21 ="SET" END IF
       if sr.faj26 >= "96/10/01"
          then let sr.faj26 = "96/09/30"
       end if
       #No>FUN-850010--begin--
       IF sr.faj29 = 0 OR sr.faj30=0 THEN
         LET l_faj29a = 0
         LET l_faj29b = 0
       ELSE
          LET l_faj29a = sr.faj29 - sr.faj30
          LET l_faj29b = sr.faj30 / sr.faj29
       END IF
       IF sr.fce04=0 OR sr.fce20 = 0 THEN
          LET l_fce04 = 0
       ELSE
          LET l_fce04 = sr.fce04 / sr.fce20
       END IF
       if sr.faj12 is null or sr.faj12=" "
         then call r910_check_prt_place(sr.faj15) returning l_faj12
       else 
          let l_faj12 = sr.faj12
       end if
       LET l_faj06=sr.faj06[1,25]
       LET l_faj07=sr.faj07[1,25]
       LET l_faj08=sr.faj08[1,20]
       LET l_faj11=sr.faj11[1,8]
       LET l_faj12=l_faj12[1,8]
       LET l_pme033a = g_pme.pme033[1,16]
       lET l_pme033b = g_pme.pme033[17,30]
#      OUTPUT TO REPORT r910_rep(sr.*,g_pme.pme033,l_ct)              #No.FUN-850010 --mark--  
       EXECUTE  insert_prep USING l_ct,sr.fce02,l_faj06,l_faj07,l_faj08,l_faj12,
                                         l_faj11,l_faj29a,l_faj29b,sr.fce21,
                                         sr.fce20,sr.fce04,l_fce04,sr.fcd01,
                                         sr.faj26,l_pme033a,l_pme033b 
       #No.FUN-850010--end--
     END FOREACH
     #No.FUn-850010 --begin--
     IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'fcd01')                                                                       
              RETURNING tm.wc    
     END IF
     LET g_str=tm.wc ,";",g_azi05,";",g_zo.zo02[1,24],";",g_zo.zo10[1,30],";",g_azi03                          
                                 
                                                                  
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
                                                      
     CALL cl_prt_cs3('afar910','afar910',l_sql,g_str)
     #No.FUN-850010--end--
#    FINISH REPORT r910_rep                                   #No.FUN-850010 --mark--  
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)              #No.FUN-850010 --mark--  
END FUNCTION
 #No.FUN-850010 --mark--  
 {
REPORT r910_rep(sr,p_ct)
   DEFINE a LIKE type_file.chr5         #No.FUN-680070 VARCHAR(5)
   DEFINE x1,x2 ARRAY[10] OF LIKE type_file.chr20        #No.FUN-680070 VARCHAR(10)
   DEFINE l_last_sw        LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          sr               RECORD
                           fce02     LIKE fce_file.fce02,
                           faj06     LIKE faj_file.faj06,
                           faj07     LIKE faj_file.faj07,
                           faj08     LIKE faj_file.faj08,
                           faj12     LIKE faj_file.faj12,
                           faj11     LIKE faj_file.faj11,
                           faj29     LIKE faj_file.faj29,
                           faj30     LIKE faj_file.faj30,
                           fce21     LIKE fce_file.fce21,
                           fce20     LIKE fce_file.fce20,
                           fce04     LIKE fce_file.fce04,
                           fcd01     LIKE fcd_file.fcd01,
                      #    faj26     like faj_file.faj26,
                           faj26     LIKE type_file.chr8    ,       #No.FUN-680070 VARCHAR(8)
                           faj15     like faj_file.faj15,
                           faj25     like faj_file.faj25,
                           faj21     like faj_file.faj21,
                           pme033     like pme_file.pme033
                        END RECORD,
 
        l_fce04       LIKE fce_file.fce04,
        l_fce04a      LIKE fce_file.fce04,
        l_faj29a      LIKE faj_file.faj29,
        l_faj29b      LIKE type_file.num20_6      #No.FUN-680070 dec(3,2)
      # l_faj29b      LIKE faj_file.faj29
    define p_ct LIKE type_file.num5         #No.FUN-680070 smallint
    define l_amt like  fce_file.fce04
    define last_flag LIKE type_file.num5         #No.FUN-680070 smallint
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.fcd01,sr.fce02
  FORMAT
   PAGE HEADER
      #------- 每頁小計初設值=0 --------#
#     let l_amt = 0
      PRINT COLUMN 55,g_company CLIPPED #No.TQC-6C0009
      PRINT COLUMN 62, g_x[11] CLIPPED,
            COLUMN 79, g_x[12] CLIPPED
   #  PRINT COLUMN 23, g_company CLIPPED ,' ',g_x[1] CLIPPED,
#     PRINT COLUMN 9, g_company CLIPPED ,' ',g_x[1] CLIPPED,    # No.TQC-610039 #No.TQC-6C0009 mark
      PRINT COLUMN 49, g_x[1] CLIPPED,   #No.TQC-6C0009
            COLUMN 62, g_x[13] CLIPPED,
            COLUMN 75, g_x[16] CLIPPED
      PRINT COLUMN 62, g_x[14] CLIPPED,
            COLUMN 79, g_x[15] CLIPPED
      LET g_pageno = g_pageno + 1
      PRINT COLUMN 2,g_x[73],g_pageno USING '###', g_x[74]      # No.TQC-610039
      PRINT g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],
            g_x[51],g_x[52]   #No.MOD-590097
 
      PRINT COLUMN   1,g_x[42],g_x[75],                   # No.TQC-610039
            COLUMN   7,g_x[42],g_x[18],15 SPACES,
            COLUMN  35,g_x[42],g_x[20],10 SPACES,
            COLUMN  57,g_x[42],g_x[22],2 SPACES,
            COLUMN  67,g_x[42],g_x[23],2 SPACES,
            COLUMN  77,g_x[42],g_x[24],
            COLUMN  87,g_x[42],g_x[25],
            COLUMN  95,g_x[42],g_x[27],
            COLUMN 103,g_x[42],g_x[29],
            COLUMN 109,g_x[42],g_x[30],
            COLUMN 127,g_x[42],COLUMN 140,g_x[31] CLIPPED,
            COLUMN 167,g_x[42],
            COLUMN 185,g_x[42],g_x[34],
            COLUMN 195,g_x[42]
 
      PRINT COLUMN   1,g_x[42],g_x[76],        # No.TQC-610039
            COLUMN   7,g_x[42],g_x[19],2 SPACES,
            COLUMN  35,g_x[42],g_x[21],14 SPACES,
            COLUMN  57,g_x[42],
            COLUMN  67,g_x[42],
            COLUMN  77,g_x[42],g_x[40],
            COLUMN  87,g_x[42],g_x[26],
            COLUMN  95,g_x[42],g_x[28],
            COLUMN 103,g_x[42],
            COLUMN 109,g_x[42],
            COLUMN 127,g_x[42],g_x[32] CLIPPED,
            COLUMN 167,g_x[42],g_x[33] CLIPPED,
            COLUMN 185,g_x[42],
            COLUMN 195,g_x[42]
      PRINT g_x[53],g_x[54],g_x[55],g_x[56],g_x[57],g_x[58],g_x[59],g_x[60],
            g_x[61],g_x[62]  #No.MOD-590097
   BEFORE GROUP OF sr.fcd01
      let l_amt = 0
      let last_flag = false
      SKIP TO TOP OF PAGE
 
ON EVERY ROW
      let g_ct = g_ct +1
      let l_amt = l_amt +sr.fce04
      IF sr.faj29 = 0 OR sr.faj30=0 THEN
         LET l_faj29a = 0
         LET l_faj29b = 0
      ELSE
         LET l_faj29a = sr.faj29 - sr.faj30
      #---- jeffery 96/10/18 update ----#
         LET l_faj29b = sr.faj30 / sr.faj29
      #  LET l_faj29b = sr.faj29 / sr.faj30
      END IF
      IF sr.fce04=0 OR sr.fce20 = 0 THEN
         LET l_fce04a = 0
      ELSE
         LET l_fce04a = sr.fce04 / sr.fce20
      END IF
  #----- jeffery 96/10/30 update -----#
  #   PRINT COLUMN   1,g_x[42],sr.fce02 USING '##',
 #    PRINT COLUMN   1,g_x[42],p_ct using '####',
      PRINT COLUMN   1,g_x[42],g_ct using '####',
           #COLUMN   7,g_x[42],sr.faj06,         #TQC-5A0021 mark
            COLUMN   7,g_x[42],sr.faj06[1,25],   #TQC-5A0021
            COLUMN  35,g_x[42],sr.faj08[1,20],
            COLUMN  57,g_x[42];
      if sr.faj12 is null or sr.faj12=" "
         then print r910_check_prt_place(sr.faj15) clipped;
         else print sr.faj12[1,8];
      end if
      print
       #    COLUMN  57,g_x[42],sr.faj12[1,8],
            COLUMN  67,g_x[42],sr.faj11[1,8],
        #   COLUMN  77,g_x[42],
            COLUMN  77,g_x[42], sr.faj26 clipped,#- 用入帳日 替代 出廠日 -#
       #    COLUMN  87,g_x[42],l_faj29a USING '######',
            COLUMN  87,g_x[42],l_faj29a/12 USING '##&.# ',
 
            COLUMN  95,g_x[42],l_faj29b USING '##&.##',
            COLUMN 103,g_x[42],sr.fce21,
            COLUMN 109,g_x[42],cl_numfor(sr.fce20,15,0),
            COLUMN 127,g_x[42],cl_numfor(l_fce04a,15,g_azi03),
            COLUMN 145,g_x[42],cl_numfor(sr.fce04,19,g_azi05),
            COLUMN 167,g_x[42],sr.pme033[1,16],
            COLUMN 185,g_x[42],
            COLUMN 195,g_x[42]
      PRINT COLUMN   1,g_x[42],
            COLUMN   7,g_x[42],sr.faj07[1,25],
            COLUMN  35,g_x[42],
            COLUMN  57,g_x[42],
            COLUMN  67,g_x[42],
            COLUMN  77,g_x[42],
            COLUMN  87,g_x[42],
            COLUMN  95,g_x[42],
            COLUMN 103,g_x[42],
            COLUMN 109,g_x[42],
            COLUMN 127,g_x[42],
            COLUMN 145,g_x[42],sr.pme033[17,30],
            COLUMN 167,g_x[42],
            COLUMN 185,g_x[42],
            COLUMN 195,g_x[42]
 
      PRINT g_x[53],g_x[54],g_x[55],g_x[56],g_x[57],g_x[58],g_x[59],g_x[60],
            g_x[61],g_x[62]  #No.MOD-590097
      if lineno = g_page_line
         then
      PRINT COLUMN   1,g_x[42],
            COLUMN   7,g_x[42],
            COLUMN  35,g_x[42],
            COLUMN  57,g_x[42],
            COLUMN  67,g_x[42],
            COLUMN  77,g_x[42],
            COLUMN  87,g_x[42],
            COLUMN  95,g_x[42],
            COLUMN 103,g_x[42],
            COLUMN 109,g_x[42],
            COLUMN 127,g_x[42],g_x[77],             # No.TQC-610039
            COLUMN 145,g_x[42],cl_numfor(l_amt,19,g_azi05),
            COLUMN 167,g_x[42],
            COLUMN 185,g_x[42],
            COLUMN 195,g_x[42]
     PRINT g_x[63],g_x[64],g_x[65],g_x[66],g_x[67],g_x[68],g_x[69],g_x[70],
           g_x[71],g_x[72]  #No.MOD-590097
           let l_amt =0
      end if
 
   AFTER GROUP OF sr.fcd01
      LET l_fce04 =GROUP SUM(sr.fce04)
 
      PRINT COLUMN   1,g_x[42],
            COLUMN   7,g_x[42],
            COLUMN  35,g_x[42],
            COLUMN  57,g_x[42],
            COLUMN  67,g_x[42],
            COLUMN  77,g_x[42],
            COLUMN  87,g_x[42],
            COLUMN  95,g_x[42],
            COLUMN 103,g_x[42], 
            COLUMN 109,g_x[42],
            COLUMN 127,g_x[42],g_x[77],               # No.TQC-610039
            COLUMN 145,g_x[42],cl_numfor(l_amt,19,g_azi05),
            COLUMN 167,g_x[42],
            COLUMN 185,g_x[42],
            COLUMN 195,g_x[42]
            let l_amt =0
      PRINT g_x[53],g_x[54],g_x[55],g_x[56],g_x[57],g_x[58],g_x[59],g_x[60],
            g_x[61],g_x[62]  #No.MOD-590097
      PRINT COLUMN   1,g_x[42],
        #   COLUMN   7,g_x[42],g_x[41] CLIPPED,
            COLUMN   7,g_x[42],
            COLUMN  35,g_x[42],
            COLUMN  57,g_x[42],
            COLUMN  67,g_x[42],
            COLUMN  77,g_x[42],
            COLUMN  87,g_x[42],
            COLUMN  95,g_x[42],
            COLUMN 103,g_x[42],
            COLUMN 109,g_x[42],
            COLUMN 127,g_x[42],g_x[78],                       #No.TQC-610039
            COLUMN 145,g_x[42],cl_numfor(l_fce04,19,g_azi05),
            COLUMN 167,g_x[42],
            COLUMN 185,g_x[42],
            COLUMN 195,g_x[42]
     PRINT g_x[63],g_x[64],g_x[65],g_x[66],g_x[67],g_x[68],g_x[69],g_x[70],
           g_x[71],g_x[72]  #No.MOD-590097
      let last_flag = true
  PAGE TRAILER
     skip 1 line
##Modify:2645
 #No.TQC-610039-begin
 {   # print column 2,"甲方申請人 : 台灣茂矽電子股份有限公司",
      print column 2,"甲方申請人 : ",g_zo.zo02[1,24] CLIPPED,   #MOD-730146 
   #       column 55," ^", column 68," ^", column 78," ^",
           column 90,"乙方申請人 : "
   #       column 138," ^", column 149," ^", column 158," ^"
     print column 55,"公",column 68,"負",column 78,"代",
           column 138,"公",column 149,"負",column 158,"代"
     print column 5,"負責人 : ",g_zo.zo10[1,30] CLIPPED,
           column 55,"司",column 68,"責",column 78,"理",
           column 94,"負責人 : ",
           column 138,"司",column 149,"責",column 158,"理"
     print column 55,"印",column 68,"人",column 78,"人",
           column 138 ,"印",column 149,"人",column 158,"人"
     print column 5,"代理人 : ",
           column 55,"鑑",column 68,"印",column 78,"印",
           column 94,"代理人 : ",
           column 138,"鑑",column 149,"印",column 158,"印"
  #  print column 55," ^",column 68,"鑑",column 78,"鑑",
     print column 68,"鑑",column 78,"鑑",
  #        column 102,"經 理 : 趙 正 雄",
       #   column 138," ^",column 149,"鑑",column 158,"鑑"
           column 149,"鑑",column 158,"鑑"
  #  print column 68," ^",column 78," ^",
  #        column 149," ^",column 158," ^"
     skip 1 line
   }
{     print column 2,g_x[79],g_zo.zo02[1,24] CLIPPED,  #MOD-730146 modify
           column 90,g_x[80]
     print column 55,g_x[81],column 68,g_x[82],column 78,g_x[83],
           column 138,g_x[81],column 149,g_x[82],column 158,g_x[83]
     print column 5,g_x[84],g_zo.zo10[1,30] CLIPPED,
           column 55,g_x[85],column 68,g_x[86],column 78,g_x[87],
           column 94,g_x[84],
           column 138,g_x[85],column 149,g_x[86],column 158,g_x[87]
     print column 55,g_x[88],column 68,g_x[91],column 78,g_x[91],
           column 138 ,g_x[88],column 149,g_x[91],column 158,g_x[91]
     print column 5,g_x[89],
           column 55,g_x[90],column 68,g_x[88],column 78,g_x[88],
           column 94,g_x[89],
           column 138,g_x[90],column 149,g_x[88],column 158,g_x[88]
     print column 68,g_x[90],column 78,g_x[90],
           column 149,g_x[90],column 158,g_x[90]
     skip 1 line
     #No.TQC-610039-end
    
END REPORT}
#--------------------------------------#
 
 #No.FUN-850010 --mark--  
function r910_check_prt_place(p_faj15)
  define p_faj15 like faj_file.faj15
  define l_str LIKE type_file.chr20        #No.FUN-680070 VARCHAR(10)
  case
     when  p_faj15="USD"
           let l_str ="U.S.A"
     when  p_faj15="YEN"
           let l_str ="JAPAN"
     when  p_faj15="DM"
           let l_str ="GERMANY"
     when  p_faj15="GBP"
           let l_str ="ENGLAND"
     when  p_faj15="NLG"
           let l_str ="ENGLAND"
     when  p_faj15="SFR"
           let l_str ="SWIZERLAND"
     otherwise
           let l_str ="TAIWAN"
 end case
 return l_str
end function
#Patch....NO.TQC-610035 <001,002> #
#FUN-870144
