# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrr210.4gl
# Descriptions...: 繳交信用狀申請書(axrr210)
# Date & Author..: 99/01/20      by Billy
# Modify.........: No.FUN-4C0100 05/01/26 By Smapmin 調整單價.金額.匯率大小
# Modify.........: NO.FUN-550071 05/05/19 By jackie 單據編號加大
# Modify.........: No.FUN-550111 05/05/30 By echo 新增報表備註
# Modify.........: No.MOD-590512 05/10/03 By Dido 報表調整
# Modify.........: No.MOD-5A0168 05/10/28 By Smapmin 品名欄位放大
# Modify.........: No.TQC-5B0042 05/11/08 By kim 報表調整
# Modify.........: No.TQC-610059 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-670067 06/07/18 By baogui voucher型報表轉template1
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.TQC-6B0051 06/12/11 By xufeng 修改報表                   
# Modify.........: No.FUN-720053 07/02/28 By wujie 使用水晶報表打印
# Modify.........: No.TQC-730113 07/03/26 By Nicole 增加CR參數
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60056 10/07/12 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No.TQC-C10039 12/01/16 By JinJJ  CR報表列印TIPTOP與EasyFlow簽核圖片
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                              # Print condition RECORD
              wc      LIKE type_file.chr1000,     # Where condition #No.FUN-680123 VARCHAR(1000)
              more    LIKE type_file.chr1000      # Input more condition(Y/N) #No.FUN-680123 VARCHAR(01)
              END RECORD
 
DEFINE   g_i          LIKE type_file.num5         #count/index for any purpose  #No.FUN-680123 SMALLINT
DEFINE l_table        STRING                      #FUN-720053 add
DEFINE g_sql          STRING                      #FUN-720053 add
DEFINE g_str          STRING                      #FUN-720053 add
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                                 # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
 
#No.FUN-720053--begin
   LET g_sql = "ola01.ola_file.ola01,", 
               "ola011.ola_file.ola011,",
               "ola02.ola_file.ola02,", 
               "ola04.ola_file.ola04,", 
               "ola05.ola_file.ola05,", 
               "ola06.ola_file.ola06,", 
               "ola09.ola_file.ola09,", 
               "ola14.ola_file.ola14,", 
               "ola21.ola_file.ola21,", 
               "ola25.ola_file.ola25,", 
               "olb03.olb_file.olb03,", 
               "olb04.olb_file.olb04,", 
               "olb05.olb_file.olb05,", 
               "olb06.olb_file.olb06,", 
               "olb07.olb_file.olb07,", 
               "olb08.olb_file.olb08,", 
               "tax.olb_file.olb08,", 
               "olb11.olb_file.olb11,", 
               "azi03.azi_file.azi03,", 
               "azi04.azi_file.azi04,", 
               "occ02.occ_file.occ02,",
              "sign_type.type_file.chr1, sign_img.type_file.blob,",    #簽核方式, 簽核圖檔     #TQC-C10039
              "sign_show.type_file.chr1,sign_str.type_file.chr1000"    #是否顯示簽核資料(Y/N)  #TQC-C10039 
 
   LET l_table = cl_prt_temptable('axrr210',g_sql) CLIPPED  
   IF l_table = -1 THEN EXIT PROGRAM END IF                
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, ?,?,?,?)"  #TQC-C10039 add 4?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-720053--end
 
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
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(tm.wc) THEN
      CALL axrr210_tm(0,0)             # Input print condition
   ELSE
      CALL axrr210()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrr210_tm(p_row,p_col)
DEFINE lc_qbe_sn       LIKE gbm_file.gbm01        #No.FUN-580031
   DEFINE p_row,p_col  LIKE type_file.num5,       #No.FUN-680123 SMALLINT
          l_cmd        LIKE type_file.chr1000     #No.FUN-680123 VARCHAR(1000)
 
   LET p_row = 7 LET p_col = 16
 
   OPEN WINDOW axrr210_w AT p_row,p_col WITH FORM "axr/42f/axrr210"
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
   CONSTRUCT BY NAME tm.wc ON ola01, ola04
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
      LET INT_FLAG = 0 CLOSE WINDOW axrr210_w 
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
      LET INT_FLAG = 0 CLOSE WINDOW axrr210_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr210'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr210','9031',1)
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
                         " '",tm.wc CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axrr210',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr210_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr210()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr210_w
END FUNCTION
 
FUNCTION axrr210()
   DEFINE
          l_name    LIKE type_file.chr20,       # External(Disk) file name #No.FUN-680123 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0095
          l_sql     LIKE type_file.chr1000,     #No.FUN-680123 VARCHAR(1000)
          l_za05    LIKE type_file.chr1000,     #No.FUN-680123 VARCHAR(40)
          l_big5    LIKE type_file.chr1000,     #No.FUN-680123 VARCHAR(100)
          l_ola41   LIKE ola_file.ola41,        #FUN-A60056 
          sr        RECORD
                    ola01     LIKE   ola_file.ola01 ,
                    ola011    LIKE   ola_file.ola011 ,
                    ola02     LIKE   ola_file.ola02 ,
                    ola04     LIKE   ola_file.ola04 ,
                    ola05     LIKE   ola_file.ola05 ,
{ruby 1999/2/2}     ola06     LIKE   ola_file.ola06 ,
                    ola09     LIKE   ola_file.ola09 ,
                    ola14     LIKE   ola_file.ola14 ,
                    ola21     LIKE   ola_file.ola21 ,
                    ola25     LIKE   ola_file.ola25 ,
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
                    occ02     LIKE   occ_file.occ02
                    END RECORD
     DEFINE l_img_blob     LIKE type_file.blob    #TQC-C10039
  
#No.FUN-720053--begin
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axrr210'
#No.FUN-720053--end
     LOCATE l_img_blob IN MEMORY    #TQC-C10039
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-670067--begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axrr210'
#   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 108  END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-670067--end
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN#只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND olauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND olagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND olagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('olauser', 'olagrup')
     #End:FUN-980030
 
 
#1999/2/2 ruby ola06
     LET l_sql = "SELECT ola01, ola011, ola02, ola04, ola05, ola06,ola09, ",
                 "       ola14, ola21, ola25,olb03,olb04,olb05,olb06, ",
                 "       olb07, olb08,0, olb11,azi03,azi04,occ02,ola41 ",    #FUN-A60056 add ola41
                 "  FROM ola_file, OUTER olb_file,OUTER azi_file,",
                 " OUTER occ_file ",
                 " WHERE ola_file.ola01 = olb_file.olb01 AND ola_file.ola05=occ_file.occ01 " ,
                 "   AND ola_file.ola06=azi_file.azi01   AND olaconf !='X' ",  #010806增
                 "   AND ", tm.wc CLIPPED
 
     PREPARE axrr210_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM
     END IF
     DECLARE axrr210_curs1 CURSOR FOR axrr210_prepare1
 
#No.FUN-720053--begin
#     CALL cl_outnam('axrr210') RETURNING l_name
#     START REPORT axrr210_rep TO l_name
#
#     LET g_pageno = 0
#No.FUN-720053--end
     FOREACH axrr210_curs1 INTO sr.*,l_ola41    #FUN-A60056 add ola41
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
      #FUN-A60056--mod--str--
      #SELECT oea211 INTO sr.tax
      #    FROM oea_file WHERE oea01 = sr.olb04
       LET l_sql = "SELECT oea211 FROM ",cl_get_target_table(l_ola41,'oea_file'),
                   " WHERE oea01 = '",sr.olb04,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       CALL cl_parse_qry_sql(l_sql,l_ola41) RETURNING l_sql
       PREPARE sel_oea211 FROM l_sql
       EXECUTE sel_oea211 INTO sr.tax
      #FUN-A60056--mod--end
       IF sr.tax IS NULL THEN LET sr.tax = 0  END IF
 
#No.FUN-720053--begin
       EXECUTE insert_prep USING  sr.*,"",l_img_blob,"N",""    #TQC-C10039 add "",l_img_blob,"N",""
#      OUTPUT TO REPORT axrr210_rep(sr.*)
#No.FUN-720053--end
     END FOREACH
 
#No.FUN-720053--begin
#    FINISH REPORT axrr210_rep
     CALL cl_wcchp(tm.wc,'ola01,ola04') 
          RETURNING tm.wc 
   # LET g_sql = "SELECT * FROM ",l_table CLIPPED   #TQC-730113
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = tm.wc
   # CALL cl_prt_cs3('axrr210',g_sql,g_str)         #TQC-730113
     LET g_cr_table = l_table                 #主報表的temp table名稱   #TQC-C100399
     LET g_cr_apr_key_f = "ola01"             #報表主鍵欄位名稱  #TQC-C10039
     CALL cl_prt_cs3('axrr210','axrr210',g_sql,g_str)
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-720053--end
END FUNCTION
 
#No.FUN-710085--begin
#REPORT axrr210_rep(sr)
#   DEFINE
#          l_last_sw    LIKE type_file.chr1,        #No.FUN-680123 VARCHAR(1) 
#          l_occ        LIKE occ_file.occ02,
#          sr        RECORD
#                    ola01     LIKE   ola_file.ola01 ,
#                    ola011    LIKE   ola_file.ola011 ,
#                    ola02     LIKE   ola_file.ola02 ,
#                    ola04     LIKE   ola_file.ola04 ,
#                    ola05     LIKE   ola_file.ola05 ,
#{1999/2/2 ruby}     ola06     LIKE   ola_file.ola06 ,
#                    ola09     LIKE   ola_file.ola09 ,
#                    ola14     LIKE   ola_file.ola14 ,
#                    ola21     LIKE   ola_file.ola21 ,
#                    ola25     LIKE   ola_file.ola25 ,
#                    olb03     LIKE   olb_file.olb03 ,
#                    olb04     LIKE   olb_file.olb04 ,
#                    olb05     LIKE   olb_file.olb05 ,
#                    olb06     LIKE   olb_file.olb06 ,
#                    olb07     LIKE   olb_file.olb07 ,
#                    olb08     LIKE   olb_file.olb08 ,
#                    tax       LIKE   olb_file.olb08 ,
#                    olb11     LIKE   olb_file.olb11 ,
#                    azi03     LIKE   azi_file.azi03 ,
#                    azi04     LIKE   azi_file.azi04 ,
#                    occ02     LIKE   occ_file.occ02
#                    END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.ola01, sr.olb04 , sr.olb05
#  FORMAT
#   PAGE HEADER
##ruby 1999/2/2
##NO.FUN-670067--begin
#   #   PRINT ''
#   #   PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2  SPACES,g_company CLIPPED
#   #   PRINT
#   #   IF g_towhom IS NULL OR g_towhom = ' '
#   #      THEN PRINT '';
#   #      ELSE PRINT 'TO:',g_towhom;
#   #   END IF
#   #   PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#   #   PRINT ''
#   #   PRINT COLUMN 3,g_x[02] CLIPPED, g_pdate CLIPPED
#   #  #PRINT ''
#       PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#       LET g_pageno = g_pageno + 1  
#       LET pageno_total = PAGENO USING '<<<',"/pageno"  
#       PRINT g_head CLIPPED,pageno_total     
#       PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#       PRINT g_dash[1,g_len]
##NO.FUN-670067--end
#    # PRINT COLUMN 3,g_x[14] CLIPPED
##NO.FUN-550071--begin
#      PRINT COLUMN 3,g_x[15] CLIPPED ,
#            COLUMN 15, sr.ola01 CLIPPED ,COLUMN 32,'[',
#            COLUMN 33, sr.ola011 USING '##&' ,']',COLUMN 33,'[',
#            COLUMN 40, sr.ola02 CLIPPED,']'
##NO.FUN-550071--end
#      PRINT ''    
#      PRINT COLUMN 3,g_x[16] CLIPPED ,
#            COLUMN 15, sr.ola05 CLIPPED ,
#            COLUMN 26, sr.occ02
#      PRINT '' 
#      PRINT COLUMN 3, g_x[17] CLIPPED ,
#            COLUMN 15, sr.ola21 CLIPPED
#      PRINT '' 
#      PRINT COLUMN 3, g_x[18] CLIPPED ,
#            COLUMN 15, sr.ola04 CLIPPED
#      PRINT ''  
#      PRINT COLUMN 3, g_x[19] CLIPPED ,
#{1999/2/2 ruby ola06}
#            COLUMN 15, sr.ola06 clipped,cl_numfor(sr.ola09,18,sr.azi04),COLUMN 30,'(',
#            COLUMN 31, g_x[20] CLIPPED ,
#            COLUMN 56, g_x[21] CLIPPED ,COLUMN 79,')'
#      PRINT ''  
#      PRINT COLUMN 3, g_x[22] CLIPPED ,
#            COLUMN 15, sr.ola25 CLIPPED
#      PRINT ''  
#      PRINT COLUMN 3, g_x[23] CLIPPED ,
#            COLUMN 17, sr.ola14 ClIPPED
#     #SKIP 3 LINE #TQC-5B0042
##NO.FUN-670067--begin
##      g_dash[1,g_len] #TQC-5B0042
##      PRINT COLUMN 3,g_x[24] CLIPPED,COLUMN 67,g_x[27],g_x[25],g_x[26]     #MOD-5A0168
##      PRINT COLUMN 3,g_x[24],g_x[25],g_x[26]   #MOD-5A0168
##MOD-590512
# #     PRINT '  ---------------- ---- ----------------------------------------  --------------- ---- ---------------- ------------------ ------------------'  #MOD-5A0168
##      PRINT '  ---------------- ---- ------------------------------ --------------- ---- ---------------- ------------------ ------------------'   #MOD-5A0168
##     PRINT '  ---------------- ---- --------------- --------------- ---- ---------------- ------------------ ------------------'
##MOD-590512 End
#      PRINT g_dash2[1,g_len]
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],
#             g_x[35],g_x[36],g_x[37],g_x[38]
#      PRINT g_dash1
##NO.FUN-670067--END
#      LET l_last_sw = 'n'     #FUN-550111
#
#  BEFORE GROUP OF sr.ola01
#   #   LET g_pageno = 0  #NO.FUN-670067
#      SKIP TO TOP OF  PAGE
#
#  ON EVERY ROW
##NO.FUN-670067--begin
#    #  PRINT COLUMN 03, sr.olb04 CLIPPED,       
##No.FUN-550071 --start--
#    #        COLUMN 20, sr.olb05 USING '###&',
##MOD-590512
#   #         COLUMN 25, sr.olb11[1,40],  #MOD-5A0168
##            COLUMN 25, sr.olb11[1,30],   #MOD-5A0168
##           COLUMN 25, sr.olb11[1,15],
#   #         COLUMN 66, cl_numfor(sr.olb07,15,0),   #MOD-5A0168
##            COLUMN 55, cl_numfor(sr.olb07,15,0),   #MOD-5A0168
##           COLUMN 41, cl_numfor(sr.olb07,15,0),
#       #     COLUMN 83, sr.olb03 CLIPPED,   #MOD-5A0168
##            COLUMN 72, sr.olb03 CLIPPED,   #MOD-5A0168
##           COLUMN 57, sr.olb03 CLIPPED,
#    #        COLUMN 88, cl_numfor(sr.olb06,15,sr.azi03),   #MOD-5A0168
##            COLUMN 77, cl_numfor(sr.olb06,15,sr.azi03),   #MOD-5A0168
##           COLUMN 61, cl_numfor(sr.olb06,15,sr.azi03),
#      #      COLUMN 104, cl_numfor(sr.olb08,18,sr.azi04),   #MOD-5A0168
##            COLUMN 93, cl_numfor(sr.olb08,18,sr.azi04),   #MOD-5A0168
##           COLUMN 78, cl_numfor(sr.olb08,18,sr.azi04),
#     #       COLUMN 123, cl_numfor(sr.olb08 * ((sr.tax/100) / (1 + sr.tax/100)),   #MOD-5A0168
##    #        COLUMN 112, cl_numfor(sr.olb08 * ((sr.tax/100) / (1 + sr.tax/100)),   #MOD-5A0168
##    #       COLUMN 96, cl_numfor(sr.olb08 * ((sr.tax/100) / (1 + sr.tax/100)),
#            PRINT COLUMN g_c[31],sr.olb04 CLIPPED,
#                  COLUMN g_c[32],sr.olb05 USING '###&', 
#                  COLUMN g_c[33],sr.olb11[1,40],  
#                  COLUMN g_c[34],cl_numfor(sr.olb07,34,0), 
#                  COLUMN g_c[35],sr.olb03 CLIPPED,  
#                  COLUMN g_c[36],cl_numfor(sr.olb06,36,sr.azi03), 
#                  COLUMN g_c[37],cl_numfor(sr.olb08,37,sr.azi04),
#                  COLUMN g_c[38],cl_numfor(sr.olb08 * ((sr.tax/100) / (1 + sr.tax/100)), 
#                         18,sr.azi04)  
##MOD-590512 End
##NO.FUN-550071 ---end--
##NO.FUN-670067--end
### FUN-550111
#ON LAST ROW
##No.FUN-670067--begin
#  #  LET l_last_sw = 'y'
#     IF g_zz05 = 'Y' THEN 
#     END IF  #No.FUN-670067
#     PRINT g_dash[1,g_len]                                                                                                         
#     LET l_last_sw = 'y'                                                                                                           
#     PRINT g_x[7],g_x[11] CLIPPED, COLUMN (g_len-9), g_x[5] CLIPPED
#     PRINT     #No.TQC-6B0051
##No.FUN-670067--end 
#
#PAGE TRAILER
##No.FUN-670067--begin
##      PRINT COLUMN 04, g_x[11] CLIPPED
#       IF l_last_sw = 'n' THEN 
#                   PRINT g_dash[1,g_len] 
#                   PRINT g_x[7],g_x[11] CLIPPED, COLUMN (g_len-9), g_x[4] CLIPPED
#                   PRINT     #No.TQC-6B0051 
#       ELSE SKIP 3 LINE
#       END IF
##No.FUN-670067--end
#      #PRINT COLUMN 04, g_x[12] CLIPPED,
#      #     COLUMN 42, g_x[13] CLIPPED
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[12]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[12]
#             PRINT g_memo
#      END IF
### END FUN-550111
# 
#
#END REPORT
##Patch....NO.TQC-610037 <001> #
#No.FUN-710085--end
