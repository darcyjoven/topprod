# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: afar252.4gl
# Desc/riptions..: 量測儀器記錄表
# Date & Author..: 00/03/22 By Iceman
# Modify.........: No.FUN-510035 05/01/19 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-660060 06/06/26 By Rainy 表頭期間置於中間
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0009 06/12/08 By Rayven 表頭制表日期等位置調整
# Modify.........: No.MOD-720082 07/02/12 By Smapmin 校驗日期判斷錯誤
# Modify.........: No.FUN-850015 08/05/06 By lala
# Modify.........: No.MOD-8B0253 08/11/25 By Sarah 增加r252_c2 CURSOR,抓取fgc02,fgc03,gen02,fgc05,fge03欄位
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AB0316 10/11/30 By suncx1 函數返回值與接收返回值的變量的類型不一致，導致截位現象
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD				#Print condition RECORD
   	    wc      LIKE type_file.chr1000,     #Where condition       #No.FUN-680070 VARCHAR(1000)
            bdate   LIKE type_file.dat,         #No.FUN-680070 DATE
	    edate   LIKE type_file.dat,         #No.FUN-680070 DATE
            s       LIKE type_file.chr2,        #No.FUN-680070 VARCHAR(2)
            t       LIKE type_file.chr2,        #No.FUN-680070 VARCHAR(2)
            more    LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
          END RECORD 
DEFINE g_zo         RECORD LIKE zo_file.*
DEFINE g_i          LIKE type_file.num5         #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE g_sql        STRING
DEFINE g_str        STRING
DEFINE l_table      STRING
 
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
 
#No.FUN-850015---start---
   LET g_sql="fga01.fga_file.fga01,fga06.fga_file.fga06,",
             "fga08.fga_file.fga08,fga07.fga_file.fga07,",
             "fga09.fga_file.fga09,fgc02.fgc_file.fgc02,",
             "fgc03.fgc_file.fgc03,gen02.gen_file.gen02,",
             #"fgc05.fgc_file.fgc05,bn.type_file.chr4,",       #TQC-AB0316 mark
             "fgc05.fgc_file.fgc05,bn.ze_file.ze03,",          #TQC-AB0316 modify
             "fge03.fge_file.fge03,fga12.fga_file.fga12,",
             "fga03.fga_file.fga03,fga21.fga_file.fga21,",
             "fga14.fga_file.fga14,fga16.fga_file.fga16"
   LET l_table = cl_prt_temptable('afar252',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED, l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
#No.FUN-850015---end---
 
   LET g_pdate  = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.s     = ARG_VAL(10)
   LET tm.t     = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r252_tm(0,0)		# Input print condition
      ELSE CALL afar252()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION r252_tm(p_row,p_col)
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01      #No.FUN-580031
   DEFINE p_row,p_col   LIKE type_file.num5,     #No.FUN-680070 SMALLINT
          l_cmd         LIKE type_file.chr1000   #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r252_w AT p_row,p_col WITH FORM "afa/42f/afar252"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s = '12'
   LET tm.bdate = g_today    #NO:8149
   LET tm.edate = g_today
   LET tm.t = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fga01,fga12,fga03,fga21,fga14,fga16
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
         LET INT_FLAG = 0 CLOSE WINDOW r252_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
 
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
 
   #  DISPLAY BY NAME tm.s,tm.t,tm.more
      INPUT BY NAME
         tm.bdate,tm.edate,tm2.s1,tm2.s2,
         tm2.t1,tm2.t2,tm.more
         WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD bdate
            IF cl_null(tm.bdate) THEN
               NEXT FIELD bdate
            END IF
 
         AFTER FIELD edate
            IF cl_null(tm.edate) OR tm.edate < tm.bdate THEN
               CALL cl_err('','aap-100',0)
               NEXT FIELD edate
            END IF
 
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
            CALL cl_cmdask()	# Command execution
 
         AFTER INPUT
             LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
             LET tm.t = tm2.t1,tm2.t2
 
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
         LET INT_FLAG = 0 CLOSE WINDOW r252_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='afar252'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar252','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.bdate CLIPPED,"'",
                        " '",tm.edate CLIPPED,"'" ,
                        " '",tm.s CLIPPED,"'" ,   #TQC-610055
                        " '",tm.t CLIPPED,"'" ,   #TQC-610055
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('afar252',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r252_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar252()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r252_w
END FUNCTION
 
FUNCTION afar252()
   DEFINE l_name     LIKE type_file.chr20,             #External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#         l_time     LIKE type_file.chr8               #No.FUN-6A0069
          l_sql      LIKE type_file.chr1000,           #RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_chr      LIKE type_file.chr1,              #No.FUN-680070 VARCHAR(1)
          l_za05     LIKE type_file.chr1000,           #No.FUN-680070 VARCHAR(40)
          l_order    ARRAY[5] OF LIKE fga_file.fga01,  #No.FUN-680070 VARCHAR(10)
          l_n        LIKE type_file.num5,              #No.FUN-850015
          sr         RECORD
                      order1 LIKE fga_file.fga01,      #No.FUN-680070 VARCHAR(10)
                      order2 LIKE fga_file.fga01,      #No.FUN-680070 VARCHAR(10)
                      fga01  LIKE fga_file.fga01,      #儀器編號
                      fga06  LIKE fga_file.fga06,      #中文名稱
                      fga08  LIKE fga_file.fga08,      #規格型號/精密度
                      fga07  LIKE fga_file.fga07,      #英文
                      fga09  LIKE fga_file.fga09,      #精密度
                      fga24  LIKE fga_file.fga24,
                      fga25  LIKE fga_file.fga25,      #校驗人員 #NO:8149
                      fga12  LIKE fga_file.fga12,
                      fga03  LIKE fga_file.fga03,
                      fga21  LIKE fga_file.fga21,
                      fga14  LIKE fga_file.fga14,
                      fga16  LIKE fga_file.fga16,
                      fgc02  LIKE fgc_file.fgc02,      #校驗日期
                      fgc03  LIKE fgc_file.fgc03,      #校驗編號
                      gen02  LIKE gen_file.gen02,      #校驗人員
                      fgc05  LIKE fgc_file.fgc05,      #不良原因
                      fge03  LIKE fge_file.fge03,      #不良原因明
                      #desc   LIKE type_file.chr4       #校驗結果       #No.FUN-680070 VARCHAR(4) #TQC-AB0316 mark
                      desc   LIKE ze_file.ze03         #校驗結果        #TQC-AB0316 add
                     END RECORD
 
   CALL cl_del_data(l_table)   #MOD-8B0253 add
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND fgauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND fgagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND fgagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fgauser', 'fgagrup')
   #End:FUN-980030
 
   #No:8149
   LET l_sql = "SELECT '','',fga01,fga06,fga08,fga07,fga09,fga24,fga25,",
               "      fga12,fga03,fga21,fga14,fga16",
               "  FROM fga_file ",
               #" WHERE fga23 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",   #MOD-720082
               " WHERE fga22 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",   #MOD-720082
               "   AND ",tm.wc CLIPPED
 
   PREPARE r252_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM
   END IF
   DECLARE r252_cs1 CURSOR FOR r252_prepare1
 
#  SELECT * INTO g_zo.* FROM zo_file WHERE zo01=g_rlang   #MOD-8B0253 mark
#No.FUN-850015---start---
#  CALL cl_outnam('afar252') RETURNING l_name
 
#  START REPORT r252_rep TO l_name
#  LET g_pageno = 0
 
   FOREACH r252_cs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      CALL r252_fga24(sr.fga24) RETURNING sr.desc
      FOR g_i = 1 TO 2
         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.fga01
              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.fga12
              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.fga03
              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.fga21
              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.fga14
              WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.fga16
              OTHERWISE LET l_order[g_i] = '-'
         END CASE
      END FOR
      LET sr.order1 = l_order[1]
      LET sr.order2 = l_order[2]
 
     #str MOD-8B0253 add
      LET sr.fgc02='' LET sr.fgc03='' LET sr.fgc05=''
      LET sr.gen02='' LET sr.fge03=''
      LET l_n = 0
      SELECT COUNT(*) INTO l_n
        FROM fgc_file,OUTER gen_file,OUTER fge_file
       WHERE fgc01 = sr.fga01
         AND fgc_file.fgc04 =gen_file.gen01
         AND fgc_file.fgc05 =fge_file.fge01
         AND fgc011!= 0
      IF l_n != 0 THEN
         DECLARE r252_c2 CURSOR FOR
            SELECT fgc02,fgc03,gen02,fgc05,fge03
              FROM fgc_file,OUTER gen_file,OUTER fge_file
             WHERE fgc01 = sr.fga01
               AND fgc_file.fgc04 =gen_file.gen01
               AND fgc_file.fgc05 =fge_file.fge01
               AND fgc011!= 0
         FOREACH r252_c2 INTO sr.fgc02,sr.fgc03,sr.gen02,sr.fgc05,sr.fge03
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach r252_c2:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            EXECUTE insert_prep USING
               sr.fga01,sr.fga06,sr.fga08,sr.fga07,sr.fga09,
               sr.fgc02,sr.fgc03,sr.gen02,sr.fgc05,sr.desc,
               sr.fge03,sr.fga12,sr.fga03,sr.fga21,sr.fga14,
               sr.fga16
         END FOREACH
      ELSE
         EXECUTE insert_prep USING
            sr.fga01,sr.fga06,sr.fga08,sr.fga07,sr.fga09,
            sr.fgc02,sr.fgc03,sr.gen02,sr.fgc05,sr.desc,
            sr.fge03,sr.fga12,sr.fga03,sr.fga21,sr.fga14,
            sr.fga16
      END IF
     #end MOD-8B0253 add
 
     #str MOD-8B0253 mark
     #SELECT COUNT(*) INTO l_n FROM fgc_file,gen_file,OUTER fge_file
     # WHERE fgc01 = sr.fga01
     #   AND gen01 = sr.fga12
     #   AND fgc_file.fgc05 =fge_file.fge01
     #   AND fgc011 != 0
     #EXECUTE insert_prep USING
     #   sr.fga01,sr.fga06,sr.fga08,sr.fga07,sr.fga09,
     #   sr.fgc02,sr.fgc03,sr.gen02,sr.fgc05,sr.desc,
     #   sr.fge03,sr.fga12,sr.fga03,sr.fga21,sr.fga14,
     #   sr.fga16
     #end MOD-8B0253 mark
#     OUTPUT TO REPORT r252_rep(sr.*)
   END FOREACH
 
   LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_wcchp(tm.wc,'fga01,fga12,fga03,fga21,fga14,fga16')
        RETURNING tm.wc
   LET g_str=tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.t[1,1]
   CALL cl_prt_cs3('afar252','afar252',g_sql,g_str)
#  FINISH REPORT r252_rep
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
#REPORT r252_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,              #No.FUN-680070 VARCHAR(1)
#          l_n           LIKE type_file.num5,              #No.FUN-680070 SMALLINT
#          g_head1       STRING,
#          str           STRING,
#          sr         RECORD order1 LIKE fga_file.fga01,   #No.FUN-680070 VARCHAR(10)
#                            order2 LIKE fga_file.fga01,   #No.FUN-680070 VARCHAR(10)
#                            fga01  LIKE fga_file.fga01,   #儀器編號
#                            fga06  LIKE fga_file.fga06,   #中文名稱
#                            fga08  LIKE fga_file.fga08,   #規格型號/精密度
#                            fga07  LIKE fga_file.fga07,   #英文
#                            fga09  LIKE fga_file.fga09,   #精密度
#                            fga24  LIKE fga_file.fga24,
#                            fga25  LIKE fga_file.fga25,   #NO:8149
#                            fga12  LIKE fga_file.fga12,
#                            fga03  LIKE fga_file.fga03,
#                            fga21  LIKE fga_file.fga21,
#                            fga14  LIKE fga_file.fga14,
#                            fga16  LIKE fga_file.fga16,
#                            fgc02  LIKE fgc_file.fgc02,   #校驗日期
#                            fgc03  LIKE fgc_file.fgc03,   #校驗編號
#                            gen02  LIKE gen_file.gen02,   #桲蝷H員
#                            fgc05  LIKE fgc_file.fgc05,   #不良原因
#                            fge03  LIKE fge_file.fge03,   #不良原因明
#                            desc   LIKE type_file.chr4    #校驗結果       #No.FUN-680070 VARCHAR(4)
#                    END RECORD
 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
 
#  ORDER BY sr.order1,sr.order2,sr.fga01,sr.fga08,sr.fga09
 
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
##     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED  #No.TQC-6C0009 mark
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED  #No.TQC-6C0009
#      LET g_head1 = g_x[9] CLIPPED,tm.bdate,'-',tm.edate
#      #PRINT g_head1                       #FUN-660060 remark
#      PRINT COLUMN (g_len-25)/2+1, g_head1 #FUN-660060
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
#      PRINT g_dash1
#      LET l_last_sw='n'
 
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y'
#         THEN SKIP TO TOP OF PAGE
#      END IF
 
#   BEFORE GROUP OF sr.fga01
#      PRINT COLUMN g_c[31],sr.fga01;
 
#   AFTER GROUP OF sr.fga01
 
#      LET l_n=1
#      DECLARE r252_c2 CURSOR FOR
#             SELECT fgc02,fgc03,gen02,fgc05,fge03
#                    FROM fgc_file,gen_file,OUTER fge_file
#                   WHERE fgc01 = sr.fga01
#                     AND gen01 = sr.fga12
#                     AND fgc_file.fgc05 =fge_file.fge01
#                     AND fgc011 != 0
#         FOREACH r252_c2 INTO sr.fgc02,sr.fgc03,sr.gen02,sr.fgc05,sr.fge03
#          IF SQLCA.sqlcode != 0 THEN
#             CALL cl_err('foreach r252c2:',SQLCA.sqlcode,1)
#          EXIT FOREACH
#          END IF
#            CASE WHEN l_n =1
#             LET str = sr.fgc05,'-',sr.fge03
#             PRINT  COLUMN g_c[32],sr.fga06 CLIPPED,
#                    COLUMN g_c[33],sr.fga08 CLIPPED,
#                    COLUMN g_c[34],sr.fgc02 CLIPPED,
#                    COLUMN g_c[35],sr.fgc03 CLIPPED,
#                    COLUMN g_c[36],sr.gen02 CLIPPED,
#                    COLUMN g_c[37],str,
#                    COLUMN g_c[38],sr.desc CLIPPED
#                 WHEN l_n =2
#             LET str = sr.fgc05,'-',sr.fge03
#             PRINT  COLUMN g_c[32],sr.fga07 CLIPPED,
#                    COLUMN g_c[33],sr.fga09 CLIPPED,
#                    COLUMN g_c[34],sr.fgc02 CLIPPED,
#                    COLUMN g_c[35],sr.fgc03 CLIPPED,
#                    COLUMN g_c[36],sr.gen02 CLIPPED,
#                    COLUMN g_c[37],str,
#                    COLUMN g_c[38],sr.desc CLIPPED
#                 WHEN l_n >2
#             LET str = sr.fgc05,'-',sr.fge03
#             PRINT  COLUMN g_c[34],sr.fgc02 CLIPPED,
#                    COLUMN g_c[35],sr.fgc03 CLIPPED,
#                    COLUMN g_c[36],sr.gen02 CLIPPED,
#                    COLUMN g_c[37],str,
#                    COLUMN g_c[38],sr.desc CLIPPED
#             OTHERWISE EXIT CASE
#           END CASE
#             LET l_n=l_n+1
#         END FOREACH
#        SELECT COUNT(*) INTO l_n FROM fgc_file,gen_file,OUTER fge_file
#         WHERE fgc01 = sr.fga01
#           AND gen01 = sr.fga12
#           AND fgc_file.fgc05 =fge_file.fge01
#           AND fgc011 != 0
#          IF l_n = 0 THEN          #----fgc沒有data
#             PRINT  COLUMN g_c[32],sr.fga06 CLIPPED,
#                    COLUMN g_c[33],sr.fga08 CLIPPED
#             PRINT  COLUMN g_c[32],sr.fga07 CLIPPED,
#                    COLUMN g_c[33],sr.fga09 CLIPPED
#          END IF
#          IF l_n = 1 THEN          #----fgc只有一筆data
#             PRINT  COLUMN g_c[32],sr.fga07 CLIPPED,
#                    COLUMN g_c[33],sr.fga09 CLIPPED
#          END IF
 
#   ON LAST ROW
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-850015---end---
FUNCTION r252_fga24(l_fga24)
DEFINE
      l_fga24   LIKE fga_file.fga24,
      #l_bn      LIKE type_file.chr4         #No.FUN-680070 VARCHAR(4)  #TQC-AB0316 mark
      l_bn      LIKE ze_file.ze03            #TQC-AB0316 add
 
#－0:未校 1:正常 2:停用 3.退修 4.報廢
     CASE l_fga24
         WHEN '0'
            CALL cl_getmsg('afa-404',g_lang) RETURNING l_bn
         WHEN '1'
            CALL cl_getmsg('afa-405',g_lang) RETURNING l_bn
         WHEN '2'
            CALL cl_getmsg('afa-406',g_lang) RETURNING l_bn
         WHEN '3'
            CALL cl_getmsg('afa-407',g_lang) RETURNING l_bn
         WHEN '4'
            CALL cl_getmsg('afa-408',g_lang) RETURNING l_bn
         OTHERWISE EXIT CASE
      END CASE
      RETURN(l_bn)
END FUNCTION
