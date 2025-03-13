# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: axrr212.4gl
# Descriptions...: 領用信用狀申請書(axrr212)
# Date & Author..: 99/01/20      by plum
# Modify.........: No.FUN-4C0100 05/01/26 By Smapmin 調整單價.金額.匯率大小
# Modify.........: NO.FUN-550071 05/05/19 By jackie 單據編號加大
# Modify.........: No.FUN-550111 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-580010 05/08/08 By yoyo 憑証類報表原則修改
# Modify.........: No.MOD-590514 05/10/03 By Dido 報表調整
# Modify.........: No.TQC-5B0042 05/11/08 By kim 調整報表格式
# Modify.........: NO.FUN-590118 06/01/10 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610059 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60056 10/07/12 By lutingting GP5.2財務串前段問題整批調整
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                          # Print condition RECORD
              wc      LIKE type_file.chr1000, # Where condition #No.FUN-680123 VARCHAR(1000)
              more    LIKE type_file.chr1     # Input more condition(Y/N) #No.FUN-680123 VARCHAR(01)
              END RECORD
 
DEFINE   g_i          LIKE type_file.num5     #count/index for any purpose #No.FUN-680123 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
 
 
 
   #-----TQC-610059---------
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #-----END TQC-610059-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
   IF cl_null(tm.wc) THEN
      CALL axrr212_tm(0,0)             # Input print condition
   ELSE
      CALL axrr212()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrr212_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01      #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,     #No.FUN-680123 SMALLINT 
          l_cmd          LIKE type_file.chr1000   #No.FUN-680123 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 6 LET p_col = 16 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 7 LET p_col = 15
   ELSE LET p_row = 6 LET p_col = 16
   END IF
 
   OPEN WINDOW axrr212_w AT p_row,p_col
        WITH FORM "axr/42f/axrr212"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON olc29,olc28,olc01,olc04
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
      LET INT_FLAG = 0 CLOSE WINDOW axrr212_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW axrr212_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr212'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr212','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axrr212',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr212_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr212()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr212_w
END FUNCTION
 
FUNCTION axrr212()
   DEFINE 
          l_name    LIKE type_file.chr20,      # External(Disk) file name #No.FUN-680123 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0095
          l_sql     LIKE type_file.chr1000,    #No.FUN-680123 VARCHAR(1000)
          l_za05    LIKE type_file.chr1000,    #No.FUN-680123 VARCHAR(40)
          l_big5    LIKE type_file.chr1000,    #No.FUN-680123 VARCHAR(100)
          sr        RECORD
                    olc29     LIKE   olc_file.olc29 ,
                    olc28     LIKE   olc_file.olc28 ,
                    ola02     LIKE   ola_file.ola02 ,
                    ola04     LIKE   ola_file.ola04 ,
{ruby 1999/2/2}     ola06     LIKE   ola_file.ola06 ,
                    ola21     LIKE   ola_file.ola21 ,
                    ola09     LIKE   ola_file.ola09 ,
                    ola10     LIKE   ola_file.ola10 ,
                    olc01     LIKE   olc_file.olc01 ,
                    olc05     LIKE   olc_file.olc05 ,
                    olc08     LIKE   olc_file.olc08 ,
                    olc11     LIKE   olc_file.olc11 ,
                    olc12     LIKE   olc_file.olc12 ,
                    olc13     LIKE   olc_file.olc13 ,
                    olb03     LIKE   olb_file.olb03 ,
                    olb04     LIKE   olb_file.olb04 ,
                    olb05     LIKE   olb_file.olb05 ,
                    olb06     LIKE   olb_file.olb06 ,
                    olb07     LIKE   olb_file.olb07 ,
                    olb08     LIKE   olb_file.olb08 ,
                    tax       LIKE   olb_file.olb08 ,
                    olb11     LIKE   olb_file.olb11 ,
                    azi03     LIKE   azi_file.azi03 ,
                    azi04     LIKE   azi_file.azi04 ,
                    occ02     LIKE   occ_file.occ02 ,
                    ola41     LIKE   ola_file.ola41      #FUN-A60056
                    END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN#只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND olcuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND olcgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND olcgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('olcuser', 'olcgrup')
     #End:FUN-980030
 
 
#ruby 1999/2/2 ola06
     LET l_sql = "SELECT olc29, olc28, ola02, ola04, ola06,ola21,",
                 "       ola09,ola10,olc01,olc05,  ",
                 "       olc08,olc11,olc12,olc13,olb03,olb04,olb05,olb06, ",
                 "       olb07, olb08,0, olb11,0,0,occ02 ",
                 "  FROM olc_file,OUTER (olb_file),ola_file,OUTER occ_file ",
                 " WHERE olc_file.olc29 = ola_file.ola01 AND ola_file.ola01=olb_file.olb01 AND olc_file.olc05=occ_file.occ01 " ,
                 " AND olaconf !='X'  AND ", tm.wc CLIPPED #010806增
 
     PREPARE axrr212_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM
     END IF
     DECLARE axrr212_curs1 CURSOR FOR axrr212_prepare1
 
     CALL cl_outnam('axrr212') RETURNING l_name
     START REPORT axrr212_rep TO l_name
 
     LET g_pageno = 0
     FOREACH axrr212_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF cl_null(sr.ola09) THEN LET sr.ola09=0 END IF
       IF cl_null(sr.ola10) THEN LET sr.ola10=0 END IF
 
      #FUN-A60056--mod--str--
      #SELECT oea211 INTO sr.tax
      #    FROM oea_file WHERE oea01 = sr.olb04
       LET l_sql = "SELECT oea211 FROM ",cl_get_target_table(sr.ola41,'oea_file'),
                   " WHERE oea01 = '",sr.olb04,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       CALL cl_parse_qry_sql(l_sql,sr.ola41) RETURNING l_sql
       PREPARE sel_oea211 FROM l_sql
       EXECUTE sel_oea211 INTO sr.tax
      #FUN-A60056--mod--end
       IF sr.tax IS NULL THEN LET sr.tax = 0  END IF
 
       SELECT azi03,azi04 INTO sr.azi03,sr.azi04 FROM azi_file WHERE azi01 = sr.ola06  
       IF sr.azi03 IS NULL THEN LET sr.azi03 = 0  END IF
       IF sr.azi04 IS NULL THEN LET sr.azi04 = 0  END IF
 
       OUTPUT TO REPORT axrr212_rep(sr.*)
     END FOREACH
 
     FINISH REPORT axrr212_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT axrr212_rep(sr)
   DEFINE 
          l_last_sw    LIKE type_file.chr1,       #No.FUN-680123 VARCHAR(1)
          l_occ        LIKE occ_file.occ02,
          sr        RECORD
                    olc29     LIKE   olc_file.olc29 ,
                    olc28     LIKE   olc_file.olc28 ,
                    ola02     LIKE   ola_file.ola02 ,
                    ola04     LIKE   ola_file.ola04 ,
{ruby 1999/2/2}     ola06     LIKE   ola_file.ola06 ,
                    ola21     LIKE   ola_file.ola21 ,
                    ola09     LIKE   ola_file.ola09 ,
                    ola10     LIKE   ola_file.ola10 ,
                    olc01     LIKE   olc_file.olc01 ,
                    olc05     LIKE   olc_file.olc05 ,
                    olc08     LIKE   olc_file.olc08 ,
                    olc11     LIKE   olc_file.olc11 ,
                    olc12     LIKE   olc_file.olc12 ,
                    olc13     LIKE   olc_file.olc13 ,
                    olb03     LIKE   olb_file.olb03 ,
                    olb04     LIKE   olb_file.olb04 ,
                    olb05     LIKE   olb_file.olb05 ,
                    olb06     LIKE   olb_file.olb06 ,
                    olb07     LIKE   olb_file.olb07 ,
                    olb08     LIKE   olb_file.olb08 ,
                    tax       LIKE   olb_file.olb08 ,
                    olb11     LIKE   olb_file.olb11 ,
		    azi03     LIKE   azi_file.azi03 ,
                    azi04     LIKE   azi_file.azi04 ,
                    occ02     LIKE   occ_file.occ02 ,
                    ola41     LIKE   ola_file.ola41      #FUN-A60056 add ola41
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr.olc29, sr.olc28,sr.olb04 , sr.olb05
  FORMAT
   PAGE HEADER
#ruby 1999/2/2
      PRINT ''
#No.FUN-580010--start
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
      LET g_pageno = g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT g_head CLIPPED,pageno_total
#No.FUN-580010--end
#     PRINT ''
#     PRINT COLUMN 3,g_x[02] CLIPPED, g_pdate CLIPPED
     #PRINT '' #TQC-5B0042
      PRINT g_dash #TQC-5B0042
      PRINT COLUMN 3,g_x[15] CLIPPED ,
#No.FUN-550071--begin
            COLUMN 15, sr.olc29 CLIPPED ,COLUMN 32,'[',
            COLUMN 33, sr.olc28 USING '##&' ,']',COLUMN 33,'[',
            COLUMN 40, sr.ola02 CLIPPED,']'
#No.FUN-550071--end
      PRINT ''
      PRINT COLUMN 3,g_x[16] CLIPPED ,
            COLUMN 15, sr.olc05 CLIPPED ,
            COLUMN 26, sr.occ02
      PRINT ''
      PRINT COLUMN 3, g_x[17] CLIPPED ,
            COLUMN 15, sr.ola21 CLIPPED
      PRINT ''
      PRINT COLUMN 3, g_x[18] CLIPPED ,
            COLUMN 15, sr.ola04 CLIPPED
      PRINT ''
      PRINT COLUMN 3, g_x[19] CLIPPED ,
            COLUMN 15, sr.olc01 CLIPPED
      PRINT ''
      PRINT COLUMN 3, g_x[20] CLIPPED ,
#ruby 1999/2/2 ola06
            COLUMN 15, sr.ola06 clipped,cl_numfor(sr.olc11,18,sr.azi04),
            COLUMN 41, g_x[21] CLIPPED ,cl_numfor(sr.ola09-sr.ola10,18,sr.azi04)
      PRINT ''
      PRINT COLUMN 3, g_x[22] CLIPPED ,
            COLUMN 15, sr.olc12 CLIPPED
      PRINT ''
      PRINT COLUMN 3, g_x[23] CLIPPED ,
            COLUMN 17, sr.olc08 ClIPPED
      PRINT ''
      PRINT COLUMN 3, g_x[24] CLIPPED ,
            COLUMN 15, sr.olc13 CLIPPED
     #SKIP 3 LINE #TQC-5B0042
      PRINT g_dash #TQC-5B0042
#No.FUN-580010--start
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[38]
      PRINTX name=H2 g_x[37]
      PRINT g_dash1
#No.FUN-550034
#No.FUN-580010--end
      LET l_last_sw = 'n'                  #FUN-550111
 
  BEFORE GROUP OF sr.olc29
#     LET g_pageno = 0
      SKIP TO TOP OF  PAGE
 
  BEFORE GROUP OF sr.olc28
#     LET g_pageno = 0
      SKIP TO TOP OF  PAGE
 
  ON EVERY ROW
#No.FUN-580010--start
      PRINTX name=D1
            COLUMN g_c[31], sr.olb04 CLIPPED,
#MOD-590514
            #COLUMN g_c[32], sr.olb05 USING '####&', #FUN-590118 mark
            COLUMN g_c[32], sr.olb05 USING '###&',  #FUN-590118 unmark
#MOD-590514 End
#           COLUMN g_c[33], sr.olb11[1,15] ,
            COLUMN g_c[33], cl_numfor(sr.olb07,33,0),
            COLUMN g_c[34], sr.olb03 CLIPPED,
            COLUMN g_c[35], cl_numfor(sr.olb06,35,sr.azi03),
            COLUMN g_c[36], cl_numfor(sr.olb08,36,sr.azi04),
            COLUMN g_c[38], cl_numfor(sr.olb08*((sr.tax/100) / (1+ sr.tax/100)),
                       38,sr.azi04)
      PRINTX name=D2 COLUMN g_c[37],sr.olb11
#No.FUN-580010--end
#No.FUN-550071 ---end--
## FUN-550111
   ON LAST ROW
      LET l_last_sw = 'y'
 
   PAGE TRAILER
 
     #PRINT COLUMN 04, g_x[12] CLIPPED ,
     #      COLUMN 42, g_x[13] CLIPPED
      IF l_last_sw = 'n' THEN
         IF g_memo_pagetrailer THEN
             PRINT g_x[12]
             PRINT g_memo
         ELSE
             PRINT
             PRINT
         END IF
      ELSE
             PRINT g_x[12]
             PRINT g_memo
      END IF
## END FUN-550111
END REPORT
#Patch....NO.TQC-610037 <> #
