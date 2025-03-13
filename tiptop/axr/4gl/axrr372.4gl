# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axrr372.4gl
# Descriptions...: 銷貨日報表(外銷)
# Date & Author..: 95/10/06 by Nick
# Modify.........: No.FUN-4C0100 04/12/28 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-540155 05/05/09 By ching 少抓azi07
# Modify.........: No.FUN-540057 05/05/10 By wujie 發票號碼調整
# Modify.........: No.FUN-550071 05/05/25 By vivien 單據編號格式放大
# Modify.........: No.FUN-580121 05/08/22 by saki 報表背景執行功能
# Modify.........: No.FUN-680123 06/08/29 By hongmei欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.TQC-6C0147 06/12/26 By Rayven 報表格式調整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm RECORD
             wc         LIKE type_file.chr1000,  #No.FUN-680123 VARCHAR(1000)
             a,b,c      LIKE type_file.chr1,     #No.FUN-680123 VARCHAR(1)
             bdate      LIKE type_file.dat,      #No.FUN-680123 DATE
             edate      LIKE type_file.dat,      #No.FUN-680123 DATE
             more       LIKE type_file.chr1      # FUN-580121 Input more condition(Y/N) #No.FUN-680123 VARCHAR(1)
          END RECORD
 
DEFINE   g_i            LIKE type_file.num5      #count/index for any purpose #No.FUN-680123 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   #No.FUN-580121 --start--
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_lang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a = ARG_VAL(8)                  #No.FUN-580121
   LET tm.b = ARG_VAL(9)                  #No.FUN-580121
   LET tm.c = ARG_VAL(10)                 #No.FUN-580121
   LET tm.bdate = ARG_VAL(11)             #No.FUN-580121
   LET tm.edate = ARG_VAL(12)             #No.FUN-580121
   LET g_rep_user = ARG_VAL(13)           #No.FUN-570264
   LET g_rep_clas = ARG_VAL(14)           #No.FUN-570264
   LET g_template = ARG_VAL(15)           #No.FUN-570264
   #No.FUN-580121 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
 
   #No.FUN-580121 --start--
   IF cl_null(g_bgjob) OR g_bgjob = "N" THEN
      CALL axrr372_tm(0,0)             # Input print condition
   ELSE
      CALL axrr372()                   # Read data and create out-file
   END IF
   #No.FUN-580121 ---end---
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrr372_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680123 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 15
   OPEN WINDOW axrr372_w AT p_row,p_col
        WITH FORM "axr/42f/axrr372"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   #No.FUN-580121 --start--
   INITIALIZE tm.* TO NULL
   LET tm.bdate   = TODAY-1
   LET tm.more = "N"
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #No.FUN-580121 ---end---
 
WHILE TRUE
   INPUT BY NAME tm.a,tm.b,tm.c,tm.bdate,tm.edate,tm.more WITHOUT DEFAULTS  #No.FUN-580121
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
         IF cl_null(tm.edate) THEN
            LET tm.edate = tm.bdate
            DISPLAY BY NAME tm.edate
         END IF
      AFTER FIELD edate
         IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
         IF tm.edate < tm.bdate THEN
            NEXT FIELD bdate
         END IF
      #No.FUN-580121 --start--
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      #No.FUN-580121 ---end---
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT INPUT
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr372_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr372'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr372','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",                #No.FUN-580121
                         " '",tm.a CLIPPED,"'",                 #No.FUN-580121
                         " '",tm.b CLIPPED,"'",                 #No.FUN-580121
                         " '",tm.c CLIPPED,"'",                 #No.FUN-580121
                         " '",tm.bdate,"'",                     #No.FUN-580121
                         " '",tm.edate,"'",                     #No.FUN-580121
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axrr372',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr372_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr372()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr372_w
END FUNCTION
 
FUNCTION axrr372()
   DEFINE
          l_name    LIKE type_file.chr20,         # External(Disk) file name #No.FUN-680123 VARCHAR(20) 
#       l_time          LIKE type_file.chr8        #No.FUN-6A0095
          l_sql     LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(1000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(40)
          sr        RECORD
                   #oma00     VARCHAR(02),
                    oma00     LIKE oma_file.oma00,           #No.FUN-680123 VARCHAR(02)
                   #oma02     DATE,
                    oma02     LIKE oma_file.oma02,           #No.FUN-680123 DATE
                   #oma09     DATE,
                    oma09     LIKE oma_file.oma09,           #No.FUN-680123 DATE
#No.FUN540057--begin
                   #oma10     VARCHAR(16),
                    oma10     LIKE oma_file.oma10,           #No.FUN-680123 VARCHAR(16)
#No.FUN540057--end
                   #oma16     VARCHAR(16),                      #No.FUN-550071
                    oma16     LIKE oma_file.oma16,           #No.FUN-680123 VARCHAR(16)
                    oma03     LIKE oma_file.oma03,           #No.FUN-680123 VARCHAR(06)
                    oma032    LIKE oma_file.oma032,          #No.FUN-680123 VARCHAR(08)
                    oma01     like oma_file.oma01,           #No.FUN-550071
                    oma23     LIKE oma_file.oma23,           #No.FUN-680123 VARCHAR(4)
                   # Prog. Version..: '5.30.06-13.03.12(09,4),                     #No.7952
                    oma24     LIKE oma_file.oma24,           #No.FUN-680123 DEC(09,4)
                    oma52     LIKE oma_file.oma52,           #No.FUN-680123 DEC(20,6)
                    oma53     LIKE oma_file.oma53,           #No.FUN-680123 DEC(20,6) 
                    oma54     LIKE oma_file.oma54,           #No.FUN-680123 DEC(20,6)
                    oma56     LIKE oma_file.oma56,           #No.FUN-680123 DEC(20,6)
                  # oma58     DEC(9,4),                      #No.7952
                    oma58     LIKE oma_file.oma58,           #No.FUN-680123 DEC(9,4)
                    oma59     LIKE oma_file.oma59,           #No.FUN-680123 DEC(20,6)
                    omavoid   LIKE oma_file.omavoid          #No.FUN-680123 VARCHAR(01)
                    END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     IF cl_null(tm.wc) THEN
         LET tm.wc = ' 1=1'
     END IF
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND omauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND omagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND omagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup')
     #End:FUN-980030
 
     LET l_sql =" SELECT oma00,oma02,oma09,oma10,oma16,oma03,oma032,oma01,",
                "        oma23,oma24,oma52,oma53,oma54,oma56,oma58,oma59,",
                "        omavoid",
                "   FROM oma_file ",
                "  WHERE oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                "    AND (oma05 = '",tm.a ,"' OR oma05 = '",tm.b,"'",
                "     OR oma05 = '",tm.c,"')",
                "    AND oma00 NOT IN ('23','24')",
                "    AND oma08='2' ",    #NO:5857
                "    AND ",tm.wc CLIPPED
 
     PREPARE axrr372_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
         EXIT PROGRAM
            
     END IF
     DECLARE axrr372_curs1 CURSOR FOR axrr372_prepare1
 
{
     DECLARE axrr372_curs1 CURSOR FOR
                SELECT oma00,oma02,oma09,oma10,oma16,oma03,oma032,oma01,
                       oma23,oma24,oma52,oma53,oma54,oma56,oma58,oma59,omavoid
                  FROM oma_file
                 WHERE oma02 BETWEEN tm.bdate AND tm.edate
                   AND (oma05 = tm.a OR oma05 = tm.b OR oma05 = tm.c)
                   AND oma00 NOT IN ('23','24')
}
 
     CALL cl_outnam('axrr372') RETURNING l_name
     START REPORT axrr372_rep TO l_name
 
     LET g_pageno = 0
     FOREACH axrr372_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF sr.omavoid = 'Y' THEN
          LET sr.oma52  = 0 LET sr.oma53  = 0
          LET sr.oma54  = 0 LET sr.oma56  = 0 LET sr.oma59  = 0
       END IF
       IF sr.oma00 MATCHES '2*' THEN
          LET sr.oma52  = sr.oma52  * -1
          LET sr.oma53  = sr.oma53  * -1
          LET sr.oma54  = sr.oma54  * -1
          LET sr.oma56  = sr.oma56  * -1
          LET sr.oma59  = sr.oma59  * -1
       END IF
       OUTPUT TO REPORT axrr372_rep(sr.*)
     END FOREACH
 
     FINISH REPORT axrr372_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT axrr372_rep(sr)
   DEFINE 
          l_last_sw    LIKE type_file.chr1,             #No.FUN-680123 VARCHAR(1)
          g_head1      STRING,
          tot1,tot2,tot3,mmm1,mmm2,mmm3 LIKE type_file.num20_6,  #No.FUN-680123 DEC(20,6)
          sr        RECORD
                    oma00     LIKE oma_file.oma00,      #No.FUN-680123 VARCHAR(02)
                    oma02     LIKE oma_file.oma02,      #No.FUN-680123 DATE
                    oma09     LIKE oma_file.oma09,      #No.FUN-680123 DATE
#No.FUN540057--begin
                    oma10     LIKE oma_file.oma10,      #No.FUN-680123 VARCHAR(16)
#No.FUN540057--end
                   #oma16     VARCHAR(16),                 #No.FUN-550071
                    oma16     LIKE oma_file.oma16,      #No.FUN-680123 VARCHAR(16)
                    oma03     LIKE oma_file.oma03,      #No.FUN-680123 VARCHAR(06)
                    oma032    LIKE oma_file.oma58,      #No.FUN-680123 VARCHAR(08)
                   #oma01     VARCHAR(10),  
                    oma01     like oma_file.oma01,      #No.FUN-550071 
                    oma23     LIKE oma_file.oma23,      #No.FUN-680123 VARCHAR(4)
                    oma24     LIKE oma_file.oma24,      #No.FUN-680123 DEC(09,4)
                    oma52     LIKE oma_file.oma52,      #No.FUN-680123 DEC(20,6)
                    oma53     LIKE oma_file.oma53,      #No.FUN-680123 DEC(20,6)
                    oma54     LIKE oma_file.oma54,      #No.FUN-680123 DEC(20,6)
                    oma56     LIKE oma_file.oma56,      #No.FUN-680123 DEC(20,6)
                    oma58     LIKE oma_file.oma58,      #No.FUN-680123 DEC(9,4)
                    oma59     LIKE oma_file.oma59,      #No.FUN-680123 DEC(20,6)
                    omavoid   LIKE oma_file.omavoid     #No.FUN-680123 VARCHAR(01)
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.oma23, sr.oma00, sr.oma02, sr.oma01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   #No.TQC-6C0147 mark
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   #No.TQC-6C0147
      LET g_head1 = g_x[11] CLIPPED,' ',tm.a,' ',tm.b,' ',tm.c
      PRINT g_head1
      LET g_head1 = g_x[12] CLIPPED,' ', tm.bdate,'-',tm.edate
      PRINT g_head1
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
            g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
       SELECT azi03,azi04,azi05,azi07              #MOD-540155
        INTO t_azi03,t_azi04,t_azi05,t_azi07
        FROM azi_file
       WHERE azi01=sr.oma23
 
      DISPLAY sr.oma24
      PRINT COLUMN g_c[31],sr.oma01,
            COLUMN g_c[32],sr.oma16,
            COLUMN g_c[33],sr.oma02,
            COLUMN g_c[34],sr.oma03,
            COLUMN g_c[35],sr.oma032,
            COLUMN g_c[36],sr.oma10,
            COLUMN g_c[37],sr.oma09,
            COLUMN g_c[38],sr.oma23,
            COLUMN g_c[39],cl_numfor(sr.oma24,39,t_azi07),
            COLUMN g_c[40],cl_numfor(sr.oma54,40,t_azi04),
            COLUMN g_c[41],cl_numfor(sr.oma56,41,g_azi04),
            COLUMN g_c[42],cl_numfor(sr.oma58,42,t_azi07),
            COLUMN g_c[43],cl_numfor(sr.oma59,43,t_azi04);
 
      CASE WHEN sr.omavoid ='Y' PRINT COLUMN g_c[44],g_x[13] CLIPPED
           WHEN sr.oma00 MATCHES '2*'  PRINT COLUMN g_c[44],g_x[14] CLIPPED
           OTHERWISE            PRINT
      END CASE
 
   AFTER GROUP OF sr.oma23
      PRINT COLUMN g_c[37],g_x[24] CLIPPED,
            COLUMN g_c[38],sr.oma23,
            COLUMN g_c[40], cl_numfor(GROUP SUM(sr.oma54),40,t_azi05),
            COLUMN g_c[41],cl_numfor(GROUP SUM(sr.oma56),41,g_azi05),
            COLUMN g_c[43],cl_numfor(GROUP SUM(sr.oma59),43,t_azi05)
   ON LAST ROW
      SELECT SUM(oma54),SUM(oma56),SUM(oma59) INTO tot1,tot2,tot3
              FROM oma_file
             WHERE YEAR(oma02)=YEAR(sr.oma02)
               AND MONTH(oma02)=MONTH(sr.oma02)
               AND oma02 < sr.oma02
               AND oma00 NOT MATCHES "2*"
               AND omavoid='N'
               AND (oma05 = tm.a OR oma05 = tm.b OR oma05 = tm.c)
      IF tot1 IS NULL THEN LET tot1=0 END IF
      IF tot2 IS NULL THEN LET tot2=0 END IF
      IF tot3 IS NULL THEN LET tot3=0 END IF
      SELECT SUM(oma54),SUM(oma56),SUM(oma59) INTO mmm1,mmm2,mmm3
              FROM oma_file
             WHERE YEAR(oma02)=YEAR(sr.oma02)
               AND MONTH(oma02)=MONTH(sr.oma02)
               AND oma02 < sr.oma02
               AND oma00 MATCHES "2*"
               AND omavoid='N'
               AND (oma05 = tm.a OR oma05 = tm.b OR oma05 = tm.c)
      IF mmm1 IS NULL THEN LET mmm1=0 END IF
      IF mmm2 IS NULL THEN LET mmm2=0 END IF
      IF mmm3 IS NULL THEN LET mmm3=0 END IF
      LET mmm1=mmm1*-1 LET mmm2=mmm2*-1 LET mmm3=mmm3*-1
 PRINT COLUMN g_c[39],g_x[16] CLIPPED,
       COLUMN g_c[41],cl_numfor(tot2,41,g_azi05),
       COLUMN g_c[43],cl_numfor(tot3,43,t_azi05)
 PRINT COLUMN g_c[39],g_x[17] CLIPPED,
       COLUMN g_c[41],cl_numfor(mmm2,41,g_azi05),
       COLUMN g_c[43],cl_numfor(mmm3,43,t_azi05)
 LET tot1=tot1+mmm1 LET tot2=tot2+mmm2 LET tot3=tot3+mmm3
 PRINT COLUMN g_c[39],g_x[18] CLIPPED,
       COLUMN g_c[41],cl_numfor(tot2,41,g_azi05),
       COLUMN g_c[43],cl_numfor(tot3,43,t_azi05)
 PRINT COLUMN g_c[41],g_dash2[1,g_w[41]];
 PRINT COLUMN g_c[43],g_dash2[1,g_w[43]]
 PRINT COLUMN g_c[39],g_x[20] CLIPPED,
       COLUMN g_c[41],cl_numfor((SUM(sr.oma56 ) WHERE sr.oma00[1,1]!='2'),41,g_azi05),
       COLUMN g_c[43],cl_numfor((SUM(sr.oma59 ) WHERE sr.oma00[1,1]!='2'),43,t_azi05)
 PRINT COLUMN g_c[39],g_x[21] CLIPPED,
       COLUMN g_c[41],cl_numfor((SUM(sr.oma56 ) WHERE sr.oma00[1,1]='2'),41,g_azi05),
       COLUMN g_c[43],cl_numfor((SUM(sr.oma59 ) WHERE sr.oma00[1,1]='2'),43,t_azi05)
 PRINT COLUMN g_c[39],g_x[22] CLIPPED,
       COLUMN g_c[41],cl_numfor(SUM(sr.oma56 ),41,g_azi05),
       COLUMN g_c[43],cl_numfor(SUM(sr.oma59),43,t_azi05)
 PRINT COLUMN g_c[41],g_dash2[1,g_w[41]];
 PRINT COLUMN g_c[43],g_dash2[1,g_w[43]]
 PRINT COLUMN g_c[39],g_x[23] CLIPPED,
       COLUMN g_c[41],cl_numfor((SUM(sr.oma53)+SUM(sr.oma56 )+tot2),41,g_azi05),
       COLUMN g_c[43],cl_numfor((SUM(sr.oma59 )+tot3),43,t_azi05)
 #No.TQC-6C0147 --start--                                                                                                           
 PRINT g_dash[1,g_len]                                                                                                              
 PRINT g_x[25] CLIPPED,COLUMN (g_len-9),g_x[9] CLIPPED                                                                              
 LET l_last_sw = 'y'                                                                                                                
 #No.TQC-6C0147 --end--
 
   PAGE TRAILER
     IF l_last_sw = 'n' THEN  #No.TQC-6C0147
        PRINT g_dash[1,g_len]
     #No.TQC-6C0147 --start--                                                                                                       
        PRINT g_x[25] CLIPPED,COLUMN (g_len-9),g_x[8] CLIPPED                                                                       
     ELSE                                                                                                                           
        SKIP 2 LINE                                                                                                                 
     END IF                                                                                                                         
     #No.TQC-6C0147 --end--
END REPORT
