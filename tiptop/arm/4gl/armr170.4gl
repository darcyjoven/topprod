# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: armr170.4gl
# Descriptions...: RMA外箱黏貼單列印
# Date & Author..: 98/05/04 By Star
# Modify.........: No.MOD-4A0037 04/10/15 By Mandy ima133 由CHAR(15) 改為CHAR(20) 的影響
# Modify.........: No.FUN-4B0045 04/11/15 By Smapmin 客戶編號開窗
# Modify.........: No.FUN-550122 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-580013 05/08/17 By trisy 2.0憑証類報表修改,轉XML格式
# Modify.........: No.TQC-610087 06/04/03 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/26 By douzh l_time轉g_time
# Modify.........: No.FUN-730019 07/03/12 By Judy Crystal Report修改
# Modify.........: No.FUN-710080 07/04/04 By Sarah CR報表串cs3()增加傳一個參數
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B70176 11/07/28 By houlia 調整sql類型為string
# Modify.........: No.FUN-B80073 11/08/03 By minpp程序撰寫規範修改	
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No:TQC-C10039 12/01/14 By minpp  CR报表列印TIPTOP与EasyFlow签核图片 
# Modify.........: No.CHI-C80041 12/12/20 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(600),        # Where condition
              a,b     LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),
              more    LIKE type_file.chr1     #No.FUN-690010 VARCHAR(1)         # Input more condition(Y/N)
              END RECORD,
          g_rme01 LIKE rme_file.rme01,
          g_prin      LIKE type_file.num5    #No.FUN-690010 smallint
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
#FUN-730019.....begin
DEFINE   g_sql       STRING
DEFINE   l_table     STRING
DEFINE   g_str       STRING
#FUN-730019.....end
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ARM")) THEN
      EXIT PROGRAM
   END IF
 
 
#--------------------No.TQC-610087 modify------------
   LET g_pdate = ARG_VAL(1)         # Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6) 
   LET tm.wc   = ARG_VAL(7)
   LET g_prin  = ARG_VAL(8) #表由armt160 直接呼叫
   IF  g_prin is null then let g_prin=2 end if
   LET tm.a    = ARG_VAL(9)
   LET tm.b    = ARG_VAL(10)
  #LET g_rme01 = ARG_VAL(1)
  #LET g_rlang = g_lang
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
#FUN-730019.....begin 
   LET g_sql = "rme011.rme_file.rme011,rme04.rme_file.rme04,",
               "rme21.rme_file.rme21,rmf03.rmf_file.rmf03,",
               "rmf06.rmf_file.rmf06,rmf061.rmf_file.rmf061,",
               "rmf121.rmf_file.rmf121,rmf22.rmf_file.rmf22,",
               "rmf25.rmf_file.rmf25,rmf33.rmf_file.rmf33,",
               "rmq07.rmq_file.rmq07,rmq08.rmq_file.rmq08,",
               "ima131.ima_file.ima131,ima133.ima_file.ima133,",
                "sign_type.type_file.chr1,",      #簽核方式   #TQC-C10039
               "sign_img.type_file.blob ,",      #簽核圖檔   #TQC-C10039
               "sign_show.type_file.chr1,",      #是否顯示簽核資料(Y/N)  #TQC-C10039
               "sign_str.type_file.chr1000"      #簽核字串 #TQC-C10039
   LET l_table = cl_prt_temptable('armr170',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"  #TQC-C10039  ADD 4?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#FUN-730019.....end
#--------------------No.TQC-610087 modify------------
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80073 ADD #FUN-BB0047 從IF中拉出
   IF cl_null(tm.wc) or g_prin=1
      THEN CALL armr170_tm(0,0)        # Input print condition
      ELSE
          #LET tm.wc = "rme01='",tm.wc CLIPPED,"'"     #No.TQC-610087 mark
           CALL armr170()            # Read data and create out-file
   END IF
{  IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL armr170_tm(0,0)        # Input print condition
      ELSE CALL armr170()            # Read data and create out-file
   END IF }
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073 ADD #FUN-BB0047 從IF中拉出
END MAIN
 
FUNCTION armr170_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 14
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW armr170_w AT p_row,p_col
        WITH FORM "arm/42f/armr170"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a    = 'Y'
   LET tm.b    = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   IF g_prin !=1 then
      CONSTRUCT BY NAME tm.wc ON rme01,rme02,rme03
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
   ON ACTION CONTROLP
               IF INFIELD(rme03) THEN #客戶編號    #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_occ"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rme03
                  NEXT FIELD rme03
               END IF
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
         LET INT_FLAG = 0 CLOSE WINDOW armr170_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
   ELSE
     #LET tm.wc = "rme01='",g_rme01 CLIPPED,"'"     #No.TQC-610087 mark
      DISPLAY tm.wc[9,18] TO FORMONLY.rme01         #No.TQC-610087 modify
      DISPLAY g_rme01 TO FORMONLY.rme01
      LET tm.a='Y' LET tm.b='Y'
   END IF
   INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a IF cl_null(tm.a) THEN NEXT FIELD a END IF
      AFTER FIELD b IF cl_null(tm.b) THEN NEXT FIELD b END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW armr170_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='armr170'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('armr170','9031',1)
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
                         " 2 ",                      #No.TQC-610087 add              
                         " '",tm.a CLIPPED,"'",      #No.TQC-610087 add
                         " '",tm.b CLIPPED,"'",      #No.TQC-610087 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('armr170',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW armr170_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL armr170()
   ERROR ""
END WHILE
   CLOSE WINDOW armr170_w
END FUNCTION
 
FUNCTION armr170()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
    #     l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(1000)
          l_sql     string,      #TQC-B70176 
          l_za05    LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
          l_rmq07      LIKE rmq_file.rmq07,   #FUN-730019
          l_rmq08      LIKE rmq_file.rmq08,   #FUN-730019
          sr        RECORD
                    rme RECORD LIKE rme_file.*,
                    rmf RECORD LIKE rmf_file.*,
                    ima133  LIKE ima_file.ima133, #機種
                    ima131  LIKE ima_file.ima131  #分類
                 END RECORD
     DEFINE  l_img_blob     LIKE type_file.blob              #TQC-C10039
     LOCATE l_img_blob IN MEMORY   #blob初始化   #TQC-C10039 
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
     #No.FUN-BB0047--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     CALL cl_del_data(l_table)  #FUN-730019
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc CLIPPED," AND rmeuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc CLIPPED," AND rmegrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc CLIPPED," AND rmegrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rmeuser', 'rmegrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT rme_file.*,rmf_file.*,ima133,ima131 ",
                 "  FROM rme_file,rmf_file,OUTER ima_file ",
                 " WHERE rme01 = rmf01 AND rmf_file.rmf03 = ima_file.ima01 ",
                 "   AND rmeconf <> 'X' ",  #CHI-C80041
                 "   AND rmevoid='Y' AND ",tm.wc CLIPPED,
                 "  ORDER BY rme03,rme011,rmf33,rmf03,rmf06,rmf25 "
     PREPARE armr170_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
        EXIT PROGRAM
     END IF
     DECLARE armr170_curs1 CURSOR FOR armr170_prepare1
 
#    CALL cl_outnam('armr170') RETURNING l_name    #FUN-730019 mark
#    START REPORT armr170_rep TO l_name            #FUN-730019 mark
 
     LET g_pageno = 0
     FOREACH armr170_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
#FUN-730019.....begin
       SELECT rmq08,rmq07 INTO l_rmq08,l_rmq07 FROM rmq_file
        WHERE rmq01=sr.rme.rme01 and rmq05=sr.rmf.rmf33
       EXECUTE insert_prep USING sr.rme.rme011,sr.rme.rme04,sr.rme.rme21,
                                 sr.rmf.rmf03,sr.rmf.rmf06,sr.rmf.rmf061,
                                 sr.rmf.rmf121,sr.rmf.rmf22,sr.rmf.rmf25,
                                 sr.rmf.rmf33,l_rmq07,l_rmq08,sr.ima131,
                                 sr.ima133,"",l_img_blob, "N",""  #TQC-C10039 ADD "",l_img_blob, "N",""
#      OUTPUT TO REPORT armr170_rep(sr.*)
#FUN-730019.....end
     END FOREACH
#FUN-730019.....begin
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'rme01,rme02,rme03') RETURNING tm.wc
     LET g_str = tm.wc,";",tm.b,";",g_zz05,";",tm.a
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     LET g_cr_table = l_table                 #主報表的temp table名稱  #TQC-C10039
     LET g_cr_apr_key_f = "rme011"       #報表主鍵欄位名稱  #TQC-C10039
     CALL cl_prt_cs3('armr170','armr170',l_sql,g_str)   #FUN-710080 modify
#    FINISH REPORT armr170_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
#FUN-730019.....end
END FUNCTION
 
#FUN-730019.....begin mark
#REPORT armr170_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),
#          l_str        LIKE rmf_file.rmf06,    #No.FUN-690010 VARCHAR(60),
#          l_rmf22      LIKE rmf_file.rmf22,
#          l_rmf121     LIKE rmf_file.rmf121,
#          g_rmq07      LIKE rmq_file.rmq07,
#          g_rmq08      LIKE rmq_file.rmq08,
#          sr        RECORD
#                    rme RECORD LIKE rme_file.*,
#                    rmf RECORD LIKE rmf_file.*,
#                    ima133  LIKE ima_file.ima133, #機種
#                    ima131  LIKE ima_file.ima131  #分類
#                 END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.rme.rme03,sr.rme.rme011,sr.rmf.rmf33,sr.rmf.rmf03,
#           sr.rmf.rmf06,sr.rmf.rmf25
#
#  FORMAT
#   PAGE HEADER
##No.FUN-580013 --start--
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
##No.FUN-580013 --end--
#      PRINT ' '
#      LET g_pageno = g_pageno + 1
##No.FUN-580013 --start--
##     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
##           COLUMN g_len-7,g_x[3] CLIPPED,' ',PAGENO USING '<<<'
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
##No.FUN-580013 --end--
#      LET l_last_sw = 'n'
#      PRINT g_dash[1,g_len]
#
#   AFTER GROUP OF sr.rmf.rmf33
#      select rmq08,rmq07 into g_rmq08,g_rmq07 from rmq_file
#       where rmq01=sr.rme.rme01 and rmq05=sr.rmf.rmf33
#      PRINT g_dash2[1,g_len]
#
#      PRINT COLUMN 41,'TOTAL: ',g_rmq08 USING '#####.##','  ',
#            g_rmq07 USING '####&.##', ' KG'
#      PRINT g_dash2[1,g_len]
#
#   BEFORE GROUP OF sr.rmf.rmf33
#      PRINT
#      PRINT g_x[9]  CLIPPED,' ',sr.rme.rme011,'      ',
#            g_x[10] CLIPPED,' ',sr.rme.rme04
#      IF NOT cl_null(sr.rme.rme21) THEN
#         PRINT 'Remark : ',sr.rme.rme21
#      END IF
#      PRINT g_x[14] CLIPPED,' ',sr.rmf.rmf33 USING '-----'
#      PRINT g_dash2[1,g_len]
##No.FUN-580013 --start--
# #     PRINT g_x[12] CLIPPED,COLUMN 42,g_x[13] CLIPPED #MOD-4A0037
# #     PRINT "-------------------- ------------------------------- -------- ---------- ------------" #MOD-4A0037
#      PRINTX name = H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
#      PRINTX name = H2 g_x[37]
#      PRINT g_dash1
##No.FUN-580013 --end--
#   AFTER GROUP OF sr.rmf.rmf25
#      LET l_str = sr.rmf.rmf06 CLIPPED,sr.rmf.rmf061
#      LET l_rmf22 = GROUP SUM(sr.rmf.rmf22)
#      LET l_rmf121 = GROUP SUM(sr.rmf.rmf121)
#      NEED 2 LINES
#      IF tm.b = 'Y' AND sr.rmf.rmf03 = 'MISC' THEN
# #        PRINT l_str[1,52];                           #MOD-4A0037
#         PRINTX name = D1 COLUMN g_c[31],l_str[1,52]; #No.FUN-580013
#      ELSE
##No.FUN-580013 --start--
##        PRINT sr.rmf.rmf03,' ',
# #             COLUMN 22,sr.ima133 CLIPPED,            #MOD-4A0037
# #             COLUMN 43,sr.ima131;                    #MOD-4A0037
#         PRINTX name = D1
#              COLUMN g_c[31],sr.rmf.rmf03,' ',
#              COLUMN g_c[32],sr.ima133 CLIPPED,
#              COLUMN g_c[33],sr.ima131;
##No.FUN-580013 --end--
#      END IF
##No.FUN-580013 --start--
# #     PRINT COLUMN 54,l_rmf22 USING '####&.##',       #MOD-4A0037
# #           COLUMN 63,l_rmf121 USING '------,---';    #MOD-4A0037
##     IF sr.rmf.rmf25 = '5' THEN PRINT COLUMN 74,'Repaired'
##                           ELSE PRINT COLUMN 74,'Non Repaired' END IF
##     IF tm.a = 'Y' AND sr.rmf.rmf03 != 'MISC' THEN PRINT l_str END IF
#         PRINTX name = D1
#              COLUMN g_c[34],l_rmf22 USING '####&.##',
#              COLUMN g_c[35],l_rmf121 USING '------,---';
#      IF sr.rmf.rmf25 = '5' THEN PRINTX name = D1  COLUMN g_c[36],'Repaired'
#                            ELSE PRINTX name = D1  COLUMN g_c[36],'Non Repaired'
#      END IF
#      IF tm.a = 'Y' AND sr.rmf.rmf03 != 'MISC' THEN
#         PRINTX name = D2 COLUMN g_c[31],l_str
#      END IF
##No.FUN-580013 --end--
#   ON LAST ROW
#     #PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
### FUN-550122
#      PRINT
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#            PRINT g_x[15]
#            PRINT g_memo
#         ELSE
#            PRINT
#            PRINT
#         END IF
#      ELSE
#             PRINT g_x[15]
#             PRINT g_memo
#      END IF
### END FUN-550122
#
#END REPORT
#Patch....NO.TQC-610037 <> #
#FUN-730019.....end mark
