# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aimr851.4gl
# Descriptions...: 初�複盤差異分析表－在製工單
# Date & Author..: 93/06/22 By Apple
# Modify.........: No.FUN-550029 05/05/30 By day   單據編號加大
# Modify.........: No.FUN-580014 05/08/16 By jackie 轉XML
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: NO.TQC-5B0112 05/11/12 BY Nicola 使用者位置修改
# Modify.........: No.FUN-5C0002 05/12/02 By Sarah 補印ima021
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: NO.FUN-590118 06/01/04 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/07 By baogui 無列印順序
# Modify.........: No.MOD-720046 07/03/15 BY TSD.Sora 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/04/03 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# MOdify.........: No:MOD-9A0156 09/10/22 By Smapmin wip應盤量直接抓取pie153
# Modify.........: No.FUN-A60080 10/07/08 By destiny 报表显示增加制程段号字段
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD			  # Print condition RECORD
           wc   STRING,                   # Where Condition  #TQC-630166
           c    LIKE type_file.chr1,      # 資料選擇  #No.FUN-690026 VARCHAR(1)
           b    LIKE type_file.chr1,      # 資料選擇  #No.FUN-690026 VARCHAR(1)
           d    LIKE type_file.chr1,      # 資料選擇  #No.FUN-690026 VARCHAR(1)
           s    LIKE type_file.chr3,      #No.FUN-690026 VARCHAR(03)
           t    LIKE type_file.chr3,      #No.FUN-690026 VARCHAR(03)
           more LIKE type_file.chr1       #No.FUN-690026 VARCHAR(1)
           END RECORD,
       g_userdes LIKE zaa_file.zaa08      #No.FUN-690026 VARCHAR(20)
DEFINE g_i       LIKE type_file.num5,     #count/index for any purpose  #No.FUN-690026 SMALLINT
       l_orderA      ARRAY[3] OF LIKE imm_file.imm13  #No.TQC-6A0088
#MOD-720046 BY TSD.Sora---start---
 DEFINE l_table     STRING
 DEFINE g_sql       STRING
 DEFINE g_str       STRING
#MOD-720046 BY TSD.Sora---end---
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
   #MOD-720046 BY TSD.Sora---start---
   LET g_sql = "pid01.pid_file.pid01,", 
               "pid02.pid_file.pid02,",
               "pid03.pid_file.pid03,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ima08.ima_file.ima08,",
               "pie02.pie_file.pie02,", 
               "pie03.pie_file.pie03,", 
               "pie04.pie_file.pie04,", 
               "pie05.pie_file.pie05,", 
               "pie07.pie_file.pie07,", 
               "pie12.pie_file.pie12,",
               "pie13.pie_file.pie13,",
               "pie14.pie_file.pie14,",
               "pie15.pie_file.pie15,",
               "pie151.pie_file.pie151,",
               "pie30.pie_file.pie30,", 
               "pie40.pie_file.pie40,", 
               "pie50.pie_file.pie50,", 
               "pie60.pie_file.pie60,", 
               "wip.pie_file.pie60,", 
               "wip1.pie_file.pie60,",
               "wip2.pie_file.pie60,",
               "pie012.pie_file.pie012,",  #NO.FUN-A60080 
               "pie013.pie_file.pie013"    #NO.FUN-A60080 
               
   LET l_table = cl_prt_temptable('aimr851',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?)"  #NO.FUN-A60080 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #MOD-720046 BY TSD.Sora---end---
   
   LET g_pdate  = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.c     = ARG_VAL(8)
   LET tm.b     = ARG_VAL(9)
   LET tm.d     = ARG_VAL(10)
   LET tm.s     = ARG_VAL(11)
   LET tm.t     = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
   THEN CALL r851_tm(0,0)    	       	# Input print condition
   ELSE CALL r851()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r851_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd	      LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(1000)
       l_direct       LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 10 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 4 LET p_col = 18
   ELSE
       LET p_row = 3 LET p_col = 10
   END IF
 
   OPEN WINDOW r851_w AT p_row,p_col
        WITH FORM "aim/42f/aimr851"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.c      = '1'
   LET tm.b      = 'N'
   LET tm.d      = 'N'
   LET tm.s      = '123'
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
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
   CONSTRUCT BY NAME tm.wc ON pid01, pid02, pid03, pie02,
                              ima08, pie05, pie03
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
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r851_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
#UI
   INPUT BY NAME tm.c,tm.b,tm.d,
                 #UI
                 tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3,
                 tm.more
                 WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
     AFTER FIELD c     #資料選擇
         IF tm.c IS NULL OR tm.c = ' ' OR tm.c NOT MATCHES'[12]'
			THEN NEXT FIELD c
		 END IF
     AFTER FIELD b
         IF tm.b IS NULL OR tm.b NOT MATCHES'[YN]'
         THEN NEXT FIELD b
         END IF
     AFTER FIELD d
         IF tm.d IS NULL OR tm.d NOT MATCHES'[YN]'
         THEN NEXT FIELD d
         END IF
 
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
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      #UI
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
      LET INT_FLAG = 0 CLOSE WINDOW r851_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr851'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr851','9031',1)
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
                         " '",tm.c CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr851',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r851_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r851()
   ERROR ""
END WHILE
CLOSE WINDOW r851_w
END FUNCTION
 
FUNCTION r851()
   DEFINE l_name     LIKE type_file.chr20,            # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0074
          l_sql      STRING,                          # RDSQL STATEMENT     #TQC-630166
          l_za05     LIKE za_file.za05,               #No.FUN-690026 VARCHAR(40)
          l_order    ARRAY[3] OF LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
          l_actuse   LIKE sfa_file.sfa06,
          l_t        STRING, #NO.FUN-A60080
          sr         RECORD
                     order1   LIKE  ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     order2   LIKE  ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     order3   LIKE  ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     pid01    LIKE  pid_file.pid01, #標籤號碼
                     pid02    LIKE  pid_file.pid02, #工單編號
                     pid03    LIKE  pid_file.pid03, #生產料件
                     pid13    LIKE  pid_file.pid13, #入庫量
                     pid17    LIKE  pid_file.pid17, #報廢量
                     ima02    LIKE  ima_file.ima02, #品名
                     ima021   LIKE  ima_file.ima021,#規格   #FUN-5C0002
                     ima08    LIKE  ima_file.ima08, #來源碼
                     pie02    LIKE  pie_file.pie02, #盤料料件
                     pie03    LIKE  pie_file.pie03, #作業序號
                     pie04    LIKE  pie_file.pie04, #發料單位
                     pie05    LIKE  pie_file.pie05, #發料單位
                     pie07    LIKE  pie_file.pie07, #項次
                     pie12    LIKE  pie_file.pie12,
                     pie13    LIKE  pie_file.pie13,
                     pie14    LIKE  pie_file.pie14,
                     pie15    LIKE  pie_file.pie15,
                     pie151   LIKE  pie_file.pie151,
                     pie30    LIKE  pie_file.pie30, #初盤(一)
                     pie40    LIKE  pie_file.pie40, #初盤(二)
                     pie50    LIKE  pie_file.pie50, #複盤(一)
                     pie60    LIKE  pie_file.pie60, #複盤(二)
                     wip      LIKE  pie_file.pie60, #應盤數量
                     wip1     LIKE  pie_file.pie60,
                     wip2     LIKE  pie_file.pie60,
                     pie012   LIKE  pie_file.pie012,  #NO.FUN-A60080
                     pie013   LIKE  pie_file.pie013   #NO.FUN-A60080
                     END RECORD
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    #MOD-720046 BY TSD.Sora---start---
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aimr851'
    #MOD-720046 BY TSD.Sora---end---
 
     LET l_sql = " SELECT  '','','',",
                #" pid01, pid02, pid03, pid13, pid17,ima02, ima08,",          #FUN-5C0002 mark
                 " pid01, pid02, pid03, pid13, pid17,ima02, ima021,ima08,",   #FUN-5C0002
                 " pie02, pie03, pie04, pie05, pie07, pie12,",
                 " pie13, pie14, pie15, pie151,pie30, ",
                 #" pie40, pie50, pie60,'','','' ",   #MOD-9A0156
                 " pie40, pie50, pie60, pie153,'','' ",   #MOD-9A0156
                 " ,pie012,pie013 ", #NO.FUN-A60080
                 " FROM pid_file,pie_file,ima_file",
                 " WHERE pid01 = pie01 AND pid03 = ima01 ",
                 "   AND (pie02 IS NOT NULL) AND (pie02 != ' ' )",
                 "   AND ",tm.wc CLIPPED
 
     #--->不包含初/複相同者
     IF tm.d = 'N'
     THEN  IF tm.c = '1'
           THEN LET l_sql = l_sql CLIPPED,
                            " AND ((pie30 != pie50)",
                            "  OR pie30 IS NULL OR pie50 IS NULL)"
           ELSE LET l_sql = l_sql CLIPPED,
                            " AND ((pie40 != pie60)",
                            "  OR pie40 IS NULL OR pie60 IS NULL)"
           END IF
     END IF
     #--->不包含未做盤點者
     IF tm.b = 'N'
     THEN  IF tm.c = '1'
           THEN LET l_sql = l_sql CLIPPED,
                            " AND (pie30 IS NOT NULL OR pie50 IS NOT NULL) "
           ELSE LET l_sql = l_sql CLIPPED,
                            " AND (pie40 IS NOT NULL OR pie60 IS NOT NULL) "
           END IF
     END IF
     LET l_sql = l_sql CLIPPED, "  ORDER BY pid02 "
     PREPARE r851_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE r851_c2 CURSOR FOR r851_prepare2
     #CALL cl_outnam('aimr851') RETURNING l_name #070316 BY TSD.Sora
     FOR  g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     #START REPORT r851_rep TO l_name #070316 BY TSD.Sora
     IF tm.c = '1'
     THEN LET g_userdes = g_x[16] CLIPPED
     ELSE LET g_userdes = g_x[17] CLIPPED
     END IF
     LET g_pageno = 0
     FOREACH r851_c2 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       FOR g_i = 1 TO 3
		CASE
			WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.pid01
                                                 LET l_orderA[g_i] =g_x[21]    #TQC-6A0088
			WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.pid02
                                                 LET l_orderA[g_i] =g_x[22]    #TQC-6A0088
			WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.pid03
                                                 LET l_orderA[g_i] =g_x[23]    #TQC-6A0088
			WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.pie02
                                                 LET l_orderA[g_i] =g_x[24]    #TQC-6A0088
			WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.ima08
                                                 LET l_orderA[g_i] =g_x[25]    #TQC-6A0088
			WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.pie05
                                                 LET l_orderA[g_i] =g_x[26]    #TQC-6A0088
			WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.pie03
                                                 LET l_orderA[g_i] =g_x[27]    #TQC-6A0088
		OTHERWISE LET l_order[g_i] = '-'
                                                 LET l_orderA[g_i] =''    #TQC-6A0088
    	END CASE
     END FOR
     LET sr.order1 = l_order[1]
     LET sr.order2 = l_order[2]
     LET sr.order3 = l_order[3]
      #--->計算未入庫數量(應盤數量)
      #    實際已用量=((完工入庫量 + 報廢數量) * qpa ) + 下階報廢
      #    應盤數量  = 已發數量 + 超領數量 - 實際已用量
      LET l_actuse = ((sr.pid13 - sr.pid17) * sr.pie14) + sr.pie15
      #LET sr.wip   = sr.pie12 + sr.pie13 - l_actuse   #MOD-9A0156
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
     IF tm.c = '1'
     THEN LET sr.wip1 = sr.pie30
          LET sr.wip2 = sr.pie50
     ELSE LET sr.wip1 = sr.pie40
          LET sr.wip2 = sr.pie60
     END IF
    #MOD-720046 BY TSD.Sora---start---
     #OUTPUT TO REPORT r851_rep(sr.*)
      EXECUTE insert_prep USING
            sr.pid01,sr.pid02,sr.pid03,
            sr.ima02,sr.ima021,sr.ima08,sr.pie02,sr.pie03,sr.pie04,
            sr.pie05,sr.pie07,sr.pie12,sr.pie13,sr.pie14,sr.pie15,
            sr.pie151,sr.pie30,sr.pie40,sr.pie50,sr.pie60,sr.wip,
            sr.wip1,sr.wip2,sr.pie012,sr.pie013 #NO.FUN-A60080
    #MOD-720046 BY TSD.Sora---end---
    END FOREACH
 
    #MOD-720046 BY TSD.Sora---start---
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'pid01,pid02,pid03,pie02,ima08,pie05,pie03')
          RETURNING tm.wc
        LET g_str = tm.wc
     ELSE
        LET g_str = " "
     END IF
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.c
     #NO.FUN-A60080--begin
     IF g_sma.sma541='N' THEN 
        LET l_t='aimr851'
     ELSE 
        LET l_t='aimr851_1'
     END IF 	
     #CALL cl_prt_cs3('aimr851','aimr851',l_sql,g_str)   #FUN-710080 modify
     CALL cl_prt_cs3('aimr851',l_t,l_sql,g_str)   
     #NO.FUN-A60080--end
 
     #FINISH REPORT r851_rep
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    #MOD-720046 BY TSD.Sora---end---
END FUNCTION
 
REPORT r851_rep(sr)
   DEFINE l_last_sw  LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
	  l_diff1    LIKE pie_file.pie30,
	  l_diff2    LIKE pie_file.pie30,
          sr         RECORD
                     order1   LIKE  ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     order2   LIKE  ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     order3   LIKE  ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     pid01    LIKE  pid_file.pid01, #標籤號碼
                     pid02    LIKE  pid_file.pid02, #工單編號
                     pid03    LIKE  pid_file.pid03, #生產料件
                     pid13    LIKE  pid_file.pid13,
                     pid17    LIKE  pid_file.pid17,
                     ima02    LIKE  ima_file.ima02, #品名
                     ima021   LIKE  ima_file.ima021,#規格   #FUN-5C0002
                     ima08    LIKE  ima_file.ima08, #來源碼
                     pie02    LIKE  pie_file.pie02, #盤料料件
                     pie03    LIKE  pie_file.pie03, #作業序號
                     pie04    LIKE  pie_file.pie04, #發料單位
                     pie05    LIKE  pie_file.pie05, #盤料料件
                     pie07    LIKE  pie_file.pie07, #項次
                     pie12    LIKE  pie_file.pie12,
                     pie13    LIKE  pie_file.pie13,
                     pie14    LIKE  pie_file.pie14,
                     pie15    LIKE  pie_file.pie15,
                     pie151   LIKE  pie_file.pie151,
                     pie30    LIKE  pie_file.pie30, #初盤(一)
                     pie40    LIKE  pie_file.pie40, #初盤(二)
                     pie50    LIKE  pie_file.pie50, #複盤(一)
                     pie60    LIKE  pie_file.pie60, #複盤(二)
                     wip      LIKE  pie_file.pie60, #應盤數量
                     wip1     LIKE  pie_file.pie60,
                     wip2     LIKE  pie_file.pie60
                     END RECORD,
          l_cnt      LIKE type_file.num5    #No.FUN-690026 SMALLINT
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
      ORDER BY sr.order1,sr.order2,sr.order3,sr.pid01,sr.pie07
  FORMAT
   PAGE HEADER
#No.FUN-580014 --start--
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2+1),g_x[1]
     #PRINT COLUMN 56,g_userdes CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_userdes))/2+1),g_userdes CLIPPED   #No.TQC-5B0112 &051112
       PRINT g_x[9] CLIPPED,l_orderA[1] CLIPPED,                      #TQC-6A0088                                                    
                       '-',l_orderA[2] CLIPPED,'-',l_orderA[3] CLIPPED
      PRINT g_dash[1,g_len]
#No.FUN-550029-begin
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39]
      PRINTX name=H2 g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]
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
 
   BEFORE GROUP OF sr.pid01
      PRINTX name=D1
            COLUMN g_c[31],sr.pid01 CLIPPED,
            COLUMN g_c[32],sr.pid02 CLIPPED,
            COLUMN g_c[33],sr.pid03 CLIPPED; #FUN-5B0014 [1,20] CLIPPED;
      LET l_cnt = 0
 
   ON EVERY ROW
      #---->初/複盤差異量
      LET l_diff1 = sr.wip1 - sr.wip2
 
      #---->應盤差異量
      IF sr.wip2 IS NOT NULL AND sr.wip2 !=' ' THEN
         LET l_diff2 = sr.wip2 - sr.wip
      ELSE
         LET l_diff2 = sr.wip1 - sr.wip
      END IF
      PRINTX name=D1
            COLUMN g_c[34],sr.pie07 using'###&', #FUN-590118
            COLUMN g_c[35],sr.pie02 CLIPPED,  #FUN-5B0014 [1,20] CLIPPED,
            COLUMN g_c[36],sr.pie04 CLIPPED,
            COLUMN g_c[37],sr.wip using '----------&.&&&',
            COLUMN g_c[38],sr.wip2  using '----------&.&&&',
            COLUMN g_c[39],l_diff1  using '----------&.&&&'
      IF l_cnt = 0 THEN
            PRINTX name=D2 COLUMN g_c[41],sr.ima02 CLIPPED;
            PRINTX name=D2 COLUMN g_c[42],sr.ima021 CLIPPED;   #FUN-5C0002
      END IF
      PRINTX name=D2 COLUMN g_c[43],sr.wip1 using '----------&.&&&',
                     COLUMN g_c[44],l_diff2 using '----------&.&&&'
      LET l_cnt = l_cnt + 1
#No.FUN-550029-end
#No.FUN-580014 ---end--
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
        CALL cl_wcchp(tm.wc,'pid01,pid02,pid03,pie02,ima08,pie05,pie03')
             RETURNING tm.wc
        PRINT g_dash[1,g_len]
#TQC-630166
#       IF tm.wc[001,080] > ' ' THEN
#       	       PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#       IF tm.wc[071,140] > ' ' THEN
#       	       PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#       IF tm.wc[141,210] > ' ' THEN
#       	       PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
         CALL cl_prt_pos_wc(tm.wc)
      END IF
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
#Patch....NO.TQC-610036 <> #
