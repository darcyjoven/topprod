# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: afar740.4gl
# Descriptions...: 尚未投資抵減清單
# Date & Author..: 96/05/15 By STAR
# Modify.........: No.FUN-510035 05/01/25 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-550034 05/05/17 by day   單據編號加大
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By Jackho  本（原）幣取位修改
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-780018 07/08/09 BY xiaofeizhu 將報表改為CR或者p_query格式輸出
# Modify.........: No.FUN-840006 08/04/03 By hellen  項目管理，去掉預算編號相關欄位
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,   # Where condition       #No.FUN-680070 VARCHAR(1000)
              more    LIKE type_file.chr1,          # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
              a       LIKE type_file.chr1,          #是否僅列印尚未投資抵減者(Y/N)       #No.FUN-680070 VARCHAR(1)
              s       LIKE type_file.chr6           # Order by sequence       #No.FUN-680070 VARCHAR(6)
              END RECORD,
          m_codest  LIKE type_file.chr1000          #No.FUN-680070 VARCHAR(34)
 
DEFINE   g_i             LIKE type_file.num5        #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE   g_str           STRING                     #No.FUN-780018
 
 
 
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
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)   #TQC-610055
   LET tm.s  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL afar740_tm(0,0)        # Input print condition
      ELSE CALL afar740()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afar740_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 18
 
   OPEN WINDOW afar740_w AT p_row,p_col WITH FORM "afa/42f/afar740"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a  = 'Y'
   LET tm.s  = '123   '
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
      CONSTRUCT BY NAME tm.wc ON faj26,faj04,faj49,faj45,faj47,faj20  #No.FUN-840006 去掉faj50
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
         LET INT_FLAG = 0 CLOSE WINDOW afar740_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
         INPUT BY NAME tm.a,tm2.s1,tm2.s2,tm2.s3,tm2.s4,tm2.s5, tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
            AFTER FIELD a
               IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
                  NEXT FIELD a
               ELSE
                  IF tm.a = 'Y' THEN
                     LET tm.wc = tm.wc CLIPPED ,
                                " AND faj42  = '1' "
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
         LET INT_FLAG = 0 CLOSE WINDOW afar740_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar740'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar740','9031',1)
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
                            " '",tm.s  CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
            CALL cl_cmdat('afar740',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW afar740_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar740()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW afar740_w
END FUNCTION
 
FUNCTION afar740()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0069
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680070 VARCHAR(40)
#No.FUN-550034-begin
          l_order   ARRAY[6] OF LIKE faj_file.faj45,         #No.FUN-680070 VARCHAR(16)
          sr        RECORD order1 LIKE faj_file.faj45,       #No.FUN-680070 VARCHAR(16)
                           order2 LIKE faj_file.faj45,       #No.FUN-680070 VARCHAR(16)
                           order3 LIKE faj_file.faj45,       #No.FUN-680070 VARCHAR(16)
                           order4 LIKE faj_file.faj45,       #No.FUN-680070 VARCHAR(16)
                           order5 LIKE faj_file.faj45,       #No.FUN-680070 VARCHAR(16)
                           order6 LIKE faj_file.faj45,       #No.FUN-680070 VARCHAR(16)
                           faj02  LIKE faj_file.faj02,
                           faj022 LIKE faj_file.faj022,
                           faj26  LIKE faj_file.faj26,
                           faj04  LIKE faj_file.faj04,
#                          faj50  LIKE faj_file.faj50,       #No.FUN-840006 去掉faj50
                           faj47  LIKE faj_file.faj47,
                           faj07  LIKE faj_file.faj07,
                           faj06  LIKE faj_file.faj06,
                           faj10  LIKE faj_file.faj10,
                           faj08  LIKE faj_file.faj08,
                           faj17  LIKE faj_file.faj17,
                           faj45  LIKE faj_file.faj45,
                           faj51  LIKE faj_file.faj51,
                           faj49  LIKE faj_file.faj49,
                           faj16  LIKE faj_file.faj16,
                           faj15  LIKE faj_file.faj15,
                           faj14  LIKE faj_file.faj14,
                           faj20  LIKE faj_file.faj20,
                           faj19  LIKE faj_file.faj19,
                           faj42  LIKE faj_file.faj42,
                           azi03  LIKE azi_file.azi03,
                           azi04  LIKE azi_file.azi04,
                           azi05  LIKE azi_file.azi05
                    END RECORD
#No.FUN-550034-end
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fajuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fajgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fajgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')
     #End:FUN-980030
 
 
     LET l_sql = "SELECT '','','','','','',faj02,faj022,faj26,faj04, ",
                 "       faj47,faj07,faj06,faj10,faj08, ",    #No.FUN-840006 去掉faj50
                 "       faj17,faj45,faj51,faj49,faj16,faj15, ",
                 "       faj14,faj20,faj19,faj42, ",
                 "       azi03,azi04,azi05 ",
                 "  FROM faj_file, azi_file  ",
                 " WHERE faj15 = azi01 ",
                 "   AND faj42 NOT IN ('0','4','6')",
                 "   AND ",tm.wc CLIPPED
#No.CHI-6A0004--begin
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#No.CHI-6A0004--end
#No.FUN-780018--mark--begin--
    {PREPARE afar740_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar740_curs1 CURSOR FOR afar740_prepare1
 
     CALL cl_outnam('afar740') RETURNING l_name
 
     START REPORT afar740_rep TO l_name
     LET g_pageno = 0
 
     FOREACH afar740_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
       FOR g_i = 1 TO 6
          CASE WHEN tm.s[g_i,g_i] = '1'
                    LET l_order[g_i] = sr.faj26 USING 'yyyymmdd'
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.faj04
#              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.faj50 #No.FUN-840006 去掉faj50
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.faj49
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.faj45
               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.faj47
               WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.faj20
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       LET sr.order4 = l_order[4]
       LET sr.order5 = l_order[5]
       LET sr.order6 = l_order[6]
       OUTPUT TO REPORT afar740_rep(sr.*)
     END FOREACH
 
     FINISH REPORT afar740_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)}            #No.FUN-780018
 
#No.FUN-780018--add--begin--
SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                      
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'faj26,faj04,faj49,faj45,faj47,faj20,faj42')    #No.FUN-840006 去掉faj50                                                 
              RETURNING tm.wc                                                                                                       
         LET g_str = tm.wc                                                                                                          
      END IF  
      LET g_str = g_str,";",g_azi04,";",g_azi05,";",tm.s[1,1],";",tm.s[2,2],";",                                                                  
                  tm.s[3,3],";",tm.s[4,4],";",tm.s[5,5],";",tm.s[6,6]                                                                                  
      CALL cl_prt_cs1('afar740','afar740',l_sql,g_str)
END FUNCTION
#No.FUN-780018--end--
 
{REPORT afar740_rep(sr)                                      #No.FUN-780018
#No.FUN-550034-begin
   DEFINE l_last_sw     LIKE type_file.chr1,                 #No.FUN-680070 VARCHAR(1)
          sr            RECORD order1 LIKE faj_file.faj45,   #No.FUN-680070 VARCHAR(16)
                           order2 LIKE faj_file.faj45,       #No.FUN-680070 VARCHAR(16)
                           order3 LIKE faj_file.faj45,       #No.FUN-680070 VARCHAR(16)
                           order4 LIKE faj_file.faj45,       #No.FUN-680070 VARCHAR(16)
                           order5 LIKE faj_file.faj45,       #No.FUN-680070 VARCHAR(16)
                           order6 LIKE faj_file.faj45,       #No.FUN-680070 VARCHAR(16)
                           faj02  LIKE faj_file.faj02,
                           faj022 LIKE faj_file.faj022,
                           faj26  LIKE faj_file.faj26,
                           faj04  LIKE faj_file.faj04,
#                          faj50  LIKE faj_file.faj50,       #No.FUN-840006 去掉faj50
                           faj47  LIKE faj_file.faj47,
                           faj07  LIKE faj_file.faj07,
                           faj06  LIKE faj_file.faj06,
                           faj10  LIKE faj_file.faj10,
                           faj08  LIKE faj_file.faj08,
                           faj17  LIKE faj_file.faj17,
                           faj45  LIKE faj_file.faj45,
                           faj51  LIKE faj_file.faj51,
                           faj49  LIKE faj_file.faj49,
                           faj16  LIKE faj_file.faj16,
                           faj15  LIKE faj_file.faj15,
                           faj14  LIKE faj_file.faj14,
                           faj20  LIKE faj_file.faj20,
                           faj19  LIKE faj_file.faj19,
                           faj42  LIKE faj_file.faj42,
                           azi03  LIKE azi_file.azi03,
                           azi04  LIKE azi_file.azi04,
                           azi05  LIKE azi_file.azi05
                        END RECORD
#No.FUN-550034-end
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,sr.order4,sr.order5,sr.order6
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
            g_x[47],g_x[48],g_x[49],g_x[50]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
         PRINT COLUMN g_c[31],sr.faj02,
               COLUMN g_c[32],sr.faj022,
               COLUMN g_c[33],sr.faj26,
               COLUMN g_c[34],sr.faj04,
#              COLUMN g_c[35],sr.faj50[1,10],  #No.FUN-840006 去掉faj50
               COLUMN g_c[36],sr.faj47,
               COLUMN g_c[37],sr.faj07,
               COLUMN g_c[38],sr.faj06,
               COLUMN g_c[39],sr.faj10,
               COLUMN g_c[40],sr.faj08[1,20],
               COLUMN g_c[41],cl_numfor(sr.faj17,41,0),
               COLUMN g_c[42],sr.faj45,
               COLUMN g_c[43],sr.faj51,
               COLUMN g_c[44],sr.faj49,
               COLUMN g_c[45],cl_numfor(sr.faj16,45,sr.azi04),
               COLUMN g_c[46],sr.faj15,
               COLUMN g_c[47],cl_numfor(sr.faj14,47,g_azi04),
               COLUMN g_c[48],sr.faj20,
               COLUMN g_c[49],sr.faj19,
               COLUMN g_c[50],sr.faj42
 
   ON LAST ROW
      PRINT g_dash2[1,g_len]
      PRINT COLUMN g_c[31],g_x[9] CLIPPED,
            COLUMN g_c[47],cl_numfor(SUM(sr.faj14),47,g_azi05)
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
 
END REPORT}
#No.FUN-780018--end--
 
