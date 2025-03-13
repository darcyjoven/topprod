# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: afar103.4gl
# Desc/riptions..: 財產外送檢修單
# Date & Author..: 96/06/11 By Kitty
# Modify.........: No.FUN-510035 05/01/18 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-530271 05/05/24 By echo 新增報表備註
# Modify.........: No.FUN-5A0180 05/10/25 By Claire 報表調整可印FONT10
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0009 06/12/07 By Rayven 語言按紐在鼠標點擊下無效，要按鍵盤上‘ENTER’鍵，才會有效
# Modify.........: No.FUN-710083 07/01/31 By Ray Crystal Report修改
# Modify.........: No.TQC-730088 07/03/22 By Nicole 增加 CR參數
# Modify.........: No.TQC-780054 07/08/15 By xiaofeizhu 修改INSERT INTO temptable語法(不用ora轉換)
# Modify.........: No.FUN-940042 09/05/06 By TSD.Wind 在CR報表列印簽核欄
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A60084 10/06/12 By Carrier blob初始化
# Modify.........: No.TQC-C10034 12/01/19 By zhuhao 在CR報表列印簽核欄
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD				# Print condition RECORD
       	    	wc     	LIKE type_file.chr1000,		# Where condition       #No.FUN-680070 VARCHAR(1000)
                a       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    	        b    	LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
                more    LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
              END RECORD,
          g_zo          RECORD LIKE zo_file.*
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
#No.FUN-710083 --begin
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  g_str      STRING
#No.FUN-710083 --end
MAIN
   OPTIONS
          INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
 
 
   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#No.FUN-710083 --begin
   LET g_sql ="fau01.fau_file.fau01,",
              "fau02.fau_file.fau02,",
              "fau04.fau_file.fau04,",
              "fav02.fav_file.fav02,",
              "fav03.fav_file.fav03,",
              "fav031.fav_file.fav031,",
              "faj06.faj_file.faj06,",
              "faj08.faj_file.faj08,",
              "fav04.fav_file.fav04,",
              "faj18.faj_file.faj18,",
              "fag03.fag_file.fag03,",
              "fav05.fav_file.fav05,",
              "gem02.gem_file.gem02,",
              "sign_type.type_file.chr1,",   #簽核方式   #FUN-940042
              "sign_img.type_file.blob,",    #簽核方式   #FUN-940042
              "sign_show.type_file.chr1,",   #是否顯示簽核資料(Y/N)  #FUN-940042
              "sign_str.type_file.chr1000"   #TQC-C10034 add
   LET l_table = cl_prt_temptable('afar103',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
#  LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,              # TQC-780054
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,      # TQC-780054
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?,",
               "        ?, ?, ?, ?, ?, ?, ? ,?)"  #FUN-940042 Add 3 ?  #TQC-C10034 add 1?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-710083 --end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r103_tm(0,0)		# Input print condition
      ELSE CALL afar103()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION r103_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000       #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r103_w AT p_row,p_col WITH FORM "afa/42f/afar103"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a    = '2'
   LET tm.b    = '2'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fau01,fau02,fau03,fau04,fau05
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
         LET INT_FLAG = 0 CLOSE WINDOW r103_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES "[123]" THEN
               NEXT FIELD a
            END IF
 
         AFTER FIELD b
            IF cl_null(tm.b) OR tm.b NOT MATCHES "[123]" THEN
               NEXT FIELD b
            END IF
 
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()	# Command execution
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
         LET INT_FLAG = 0 CLOSE WINDOW r103_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='afar103'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar103','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.a CLIPPED,"'",
                            " '",tm.b CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afar103',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r103_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar103()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r103_w
END FUNCTION
 
FUNCTION afar103()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0069
          l_gem02       LIKE gem_file.gem02,           #部門名稱     #No.FUN-710083
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT       #No.FUN-680070 VARCHAR(1000)
          l_chr		LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_za05	LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(40)
          sr   RECORD
                     fau01     LIKE fau_file.fau01,    #請修單號
                     fau02     LIKE fau_file.fau02,    #日期
                     fau04     LIKE fau_file.fau04,    #請修單位
                     fav02     LIKE fav_file.fav02,    #項次
                     fav03     LIKE fav_file.fav03,    #財產編號
                     fav031    LIKE fav_file.fav031,   #附號
                     faj06     LIKE faj_file.faj06,    #品名
                     faj08     LIKE faj_file.faj08,    #規格
                     fav04     LIKE fav_file.fav04,    #數量
                     faj18     LIKE faj_file.faj18,    #單位
                     fag03     LIKE fag_file.fag03,    #原因說明
                     fav05     LIKE fav_file.fav05     #外送地點
        END RECORD
   ###FUN-940042 START ###
   DEFINE l_img_blob     LIKE type_file.blob
#TQC-C10034--mark--begin
  #DEFINE l_ii           INTEGER
  #DEFINE l_sql_2        LIKE type_file.chr1000        # RDSQL STATEMENT
  #DEFINE l_key          RECORD                  #主鍵
  #          v1          LIKE fas_file.fas01
  #                      END RECORD
#TQC-C10034--mark--end
   ###FUN-940042 END ###
 
     CALL cl_del_data(l_table)     #No.FUN-710083
     LOCATE l_img_blob IN MEMORY   #blob初始化   #MOD-A60084
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fauuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND faugrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND faugrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fauuser', 'faugrup')
     #End:FUN-980030
 
 
     LET l_sql = "SELECT fau01,fau02,fau04,fav02,fav03,fav031,",
                 "       faj06,faj08,fav04,faj18,fag03,fav05",
                 "  FROM fau_file,fav_file, OUTER faj_file,OUTER fag_file ",
                 " WHERE fau01 = fav01 ",
                 "   AND fauconf <> 'X' ",
                 "   AND fav_file.fav03=faj_file.faj02 ",
                 "   AND fav_file.fav031=faj_file.faj022 ",
                 "   AND fav_file.fav06 = fag_file.fag01 ",
                 "   AND ",tm.wc CLIPPED
 
     IF tm.a='1' THEN LET l_sql=l_sql CLIPPED," AND fauconf='Y' " END IF
     IF tm.a='2' THEN LET l_sql=l_sql CLIPPED," AND fauconf='N' " END IF
     IF tm.b='1' THEN LET l_sql=l_sql CLIPPED," AND faupost='Y' " END IF
     IF tm.b='2' THEN LET l_sql=l_sql CLIPPED," AND faupost='N' " END IF
     PREPARE r103_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r103_cs1 CURSOR FOR r103_prepare1
#No.FUN-710083 --begin
#    SELECT * INTO g_zo.* FROM zo_file WHERE zo01=g_rlang
#    CALL cl_outnam('afar103') RETURNING l_name
#    START REPORT r103_rep TO l_name
#    LET g_pageno = 0
#No.FUN-710083 --end
     FOREACH r103_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
#No.FUN-710083 --begin
       LET l_gem02 = ' '
       SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.fau04
       EXECUTE insert_prep USING sr.*,l_gem02,
                                 "",l_img_blob,"N",""    #FUN-940042   #TQC-C10034 add ""
#      OUTPUT TO REPORT r103_rep(sr.*)
#No.FUN-710083 --end
     END FOREACH
#No.FUN-710083 --begin
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'fau01,fau02,fau03,fau04,fau05')
          RETURNING tm.wc
     LET g_str = tm.wc,";",g_zz05
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED   #TQC-730088
   # CALL cl_prt_cs3('afar103',l_sql,g_str)
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     ###FUN-940042 START ###
     LET g_cr_table = l_table                 #主報表的temp table名稱
    #LET g_cr_gcx01 = "afai060"               #單別維護程式   #TQC-C10034 mark
     LET g_cr_apr_key_f = "fau01"             #報表主鍵欄位名稱，用"|"隔開 
#TQC-C10034--mark--begin
    #LET l_sql_2 = "SELECT DISTINCT fau01 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    #PREPARE key_pr FROM l_sql_2
    #DECLARE key_cs CURSOR FOR key_pr
    #LET l_ii = 1
    ##報表主鍵值
    #CALL g_cr_apr_key.clear()                #清空
    #FOREACH key_cs INTO l_key.*            
    #   LET g_cr_apr_key[l_ii].v1 = l_key.v1
    #   LET l_ii = l_ii + 1
    #END FOREACH
#TQC-C10034--mark--end
     ###FUN-940042 END ###
     CALL cl_prt_cs3('afar103','afar103',l_sql,g_str)
 
#    FINISH REPORT r103_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-710083 --end
END FUNCTION
 
#No.FUN-710083 --begin
#REPORT r103_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#          l_gem02       LIKE gem_file.gem02,           #部門名稱
#          l_fav06_1     LIKE fav_file.fav06,           #原因
#          l_fav06_2     LIKE fav_file.fav06,           #原因
#          g_head1       STRING,
#          sr   RECORD
#                     fau01     LIKE fau_file.fau01,    #請修單號
#                     fau02     LIKE fau_file.fau02,    #日期
#                     fau04     LIKE fau_file.fau04,    #請修單位
#                     fav02     LIKE fav_file.fav02,    #項次
#                     fav03     LIKE fav_file.fav03,    #財產編號
#                     fav031    LIKE fav_file.fav031,   #附號
#                     faj06     LIKE faj_file.faj06,    #品名
#                     faj08     LIKE faj_file.faj08,    #規格
#                     fav04     LIKE fav_file.fav04,    #數量
#                     faj18     LIKE faj_file.faj18,    #單位
#                     fag03     LIKE fag_file.fag03,    #原因說明
#                     fav05     LIKE fav_file.fav05     #外送地點
#        END RECORD
# 
#  OUTPUT TOP MARGIN 0
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN 6
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.fau01,sr.fav02
#
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
##     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED  #No.TQC-6C0009 mark
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED  #No.TQC-6C0009
#      LET g_head1 = g_x[9] CLIPPED,sr.fau01       #請修單號
#      PRINT g_head1
#      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.fau04
#      LET g_head1 =  g_x[11] CLIPPED,sr.fau04,' ',l_gem02,'   ',
#                     g_x[10] CLIPPED,sr.fau02     #請修單位,日期
#      PRINT g_head1
#      PRINT g_dash[1,g_len]
#      #FUN-5A0180-begin
#      #PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[35],g_x[36],g_x[37]
#      PRINTX name=H2 g_x[38],g_x[34]
#      PRINTX name=H3 g_x[39],g_x[40]
#      #FUN-5A0180-end
#      PRINT g_dash1
#      LET l_last_sw='n'
# 
#BEFORE GROUP OF sr.fau01
#      SKIP TO TOP OF PAGE
#
#ON EVERY ROW
#      LET l_fav06_1 =sr.fag03[1,10]
#      LET l_fav06_2 =sr.fag03[11,20]
#      #FUN-5A0180-begin
#      #PRINT COLUMN g_c[31],sr.fav02 USING '###',
#      #      COLUMN g_c[32],sr.fav03,
#      #      COLUMN g_c[33],sr.fav031,
#      #      COLUMN g_c[34],sr.faj06,
#      #      COLUMN g_c[35],sr.fav04 USING '######',
#      #      COLUMN g_c[36],l_fav06_1,
#      #      COLUMN g_c[37],sr.fav05
#      #PRINT COLUMN g_c[34],sr.faj08,
#      #      COLUMN g_c[35],sr.faj18,
#      #      COLUMN g_c[37],l_fav06_2
#      PRINTX name=D1
#            COLUMN g_c[31],sr.fav02 USING '###&', #FUN-590118
#            COLUMN g_c[32],sr.fav03,
#            COLUMN g_c[33],sr.fav031,
#            COLUMN g_c[35],sr.fav04 USING '####',' ',sr.faj18 CLIPPED,
#            COLUMN g_c[36],sr.fag03,
#            COLUMN g_c[37],sr.fav05
#      PRINTX name=D2
#            COLUMN g_c[34],sr.faj06
#      PRINTX name=D3
#            COLUMN g_c[34],sr.faj08
#      #FUN-5A0180-end
# ## MOD-530271
#ON LAST ROW
#      LET l_last_sw = 'y'
#
#PAGE TRAILER
#      PRINT g_dash[1,g_len]
#      #No.TQC-6C0009 --start--
#      PRINT g_x[4] CLIPPED;
#      IF l_last_sw = 'y' THEN
#         PRINT COLUMN (g_len-9), g_x[7] CLIPPED
#      ELSE
#         PRINT COLUMN (g_len-9), g_x[6] CLIPPED
#      END IF
#      PRINT
#      #No.TQC-6C0009 --end--
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[12]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#          PRINT g_x[12]
#          PRINT g_memo
#      END IF
# ## END MOD-530271
# 
#END REPORT
#No.FUN-710083 --end
