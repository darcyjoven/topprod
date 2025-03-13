# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: aimr302.4gl
# Descriptions...: 週期盤點表
# Input parameter:
# Return code....:
# Date & Author..: 91/10/29 By Carol
# Modify.........: 92/05/21 By Lin
#                  報表格式修改
# Modify.........: No:7643 03/08/25 By Mandy aimr302應加per選項,可選擇庫存=0的要不要印出來
# Modify ........: No.MOD-480133 04/08/12 By Nicola 輸入順序錯誤
# Modify.........: No.FUN-550108 05/05/25 By echo 新增報表備註
# Modify.........: No.FUN-570240 05/07/26 By day   料件編號欄位加CONTROLP
# Modify.........: NO.MOD-580222 05/08/25 By rosayu cl_used只可以在main的進入點跟退出點呼叫兩次
# Modify.........: No.FUN-590110 05/10/09 By Tracy 修改報表,轉XML格式
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-670041 06/08/10 By Pengu 將sma29 [虛擬產品結構展開與否] 改為 no use
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6C0222 06/12/29 By Ray 第一頁跳頁錯誤
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/24 By vealxu ima26x 調整
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm        RECORD                          #Print condition RECORD
                 wc      STRING,                 #TQC-630166
                 q       LIKE type_file.chr1,    #分群碼排列順序選擇  #No.FUN-690026 VARCHAR(1)
                 s       LIKE type_file.chr3,    #Order by sequence   #No.FUN-690026 VARCHAR(3)
                 t       LIKE type_file.chr3,    #Eject sw            #No.FUN-690026 VARCHAR(3)
                 f       LIKE type_file.chr1,    #No:7643 列印庫存數量為零的料件?  #No.FUN-690026 VARCHAR(1)
                 b       LIKE type_file.chr1,    #print gkf_file detail(Y/N)  #No.FUN-690026 VARCHAR(1)
                 c       LIKE type_file.chr1,    #倉庫別(1)S (2)W (3)全部     #No.FUN-690026 VARCHAR(1)
                 d       LIKE type_file.chr1,    #Print free stock(Y/N)       #No.FUN-690026 VARCHAR(1)
                 e       LIKE type_file.chr1,    #Print routable parts(Y/N)   #No.FUN-690026 VARCHAR(1)
                 b_date  LIKE type_file.dat,     #基準日期 #BugNo:4707        #No.FUN-690026 DATE
                 xxx     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
                 more    LIKE type_file.chr1     #Input more condition(Y/N)   #No.FUN-690026 VARCHAR(1)
                 END RECORD,
       xxx_count LIKE type_file.num5             #No.FUN-690026 SMALLINT
 
DEFINE g_i       LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg     LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_head1   STRING                 #No.FUN-590110
MAIN
#     DEFINE    l_time   LIKE type_file.chr8       #No.FUN-6A0074
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT       	    #Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.q  = ARG_VAL(8)
   LET tm.s  = ARG_VAL(9)
   LET tm.t  = ARG_VAL(10)
  #LET tm.f  = ARG_VAL(11) #No:7643  #TQC-610072
   LET tm.b  = ARG_VAL(11)
   LET tm.c  = ARG_VAL(12)
   LET tm.d  = ARG_VAL(13)
   LET tm.e  = ARG_VAL(14)
   LET tm.xxx = ARG_VAL(15)       #TQC-610072
   LET tm.b_date = ARG_VAL(16)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(17)
   LET g_rep_clas = ARG_VAL(18)
   LET g_template = ARG_VAL(19)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r302_tm()
      ELSE CALL r302_y()                        #No.FUN-590110
   END IF
 
 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r302_tm()
   DEFINE l_cmd		LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(400)
          p_row,p_col   LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 1 LET p_col = 12
   ELSE
       LET p_row = 3 LET p_col = 5
   END IF
 
   OPEN WINDOW r302_w AT p_row,p_col
        WITH FORM "aim/42f/aimr302"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   IF g_sma.sma12='Y' THEN
      LET tm.s    = '123'
   ELSE
      LET tm.s    = '156'
   END IF
   LET tm.q    = '0'
   LET tm.f    = 'Y'
   LET tm.b    = 'Y'
   LET tm.c    = '3'
   LET tm.d    = 'Y'
   LET tm.e    = 'Y'
   LET tm.b_date = g_today
   LET tm.more = 'N'
   LET g_pdate = g_today
 # LET g_pdate = '02/04/02'
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
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
   IF g_sma.sma12 = 'Y' THEN
        CONSTRUCT BY NAME tm.wc ON ima23, img02, img03, ima07, ima01, ima06,
                      ima09,ima10,ima11,ima12
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
 
#No.FUN-570240  --start-
      ON ACTION controlp
            IF INFIELD(ima01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            END IF
#No.FUN-570240 --end--
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
   END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
      IF INT_FLAG THEN
        LET INT_FLAG = 0 CLOSE WINDOW r302_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
      END IF
      IF tm.wc = " 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
   ELSE
        CONSTRUCT BY NAME tm.wc ON ima23, ima07, ima01, ima06,
                      ima09,ima10,ima11,ima12
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
        END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
    IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r302_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
    END IF
    IF tm.wc = " 1=1" THEN
       CALL cl_err('','9046',0)
       CONTINUE WHILE
    END IF
   END IF
   LET tm.xxx=''
   DISPLAY BY NAME tm.xxx,tm.q,tm.s,tm.f,tm.b,tm.c,tm.d,tm.e,tm.b_date,tm.more #No:7643 add tm.f
						# Condition
#UI
    INPUT BY NAME tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3,tm.q,  #No.MOD-480133
                 tm.c,tm.b,tm.d,tm.e,tm.xxx,tm.b_date,tm.more WITHOUT DEFAULTS
      AFTER FIELD q
	     IF tm.q IS NULL OR tm.q NOT MATCHES '[01234]' THEN
	        NEXT FIELD q
	     END IF
      AFTER FIELD b
         IF tm.b IS NULL OR tm.b NOT MATCHES "[YN]"
            THEN NEXT FIELD b
         END IF
      AFTER FIELD c
	     IF tm.c IS NULL OR tm.c NOT MATCHES '[123]' THEN
	        NEXT FIELD c
	     END IF
      AFTER FIELD d
         IF tm.d IS NULL OR tm.d NOT MATCHES "[YN]"
            THEN NEXT FIELD d
         END IF
      AFTER FIELD e
         IF tm.e IS NULL OR tm.e NOT MATCHES "[YN]"
            THEN NEXT FIELD e
         END IF
      AFTER FIELD xxx
          IF NOT cl_null(tm.xxx) THEN
             IF tm.xxx <=0
                THEN NEXT FIELD xxx
             END IF
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
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r302_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr302'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr302','9031',1)
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
                         " '",tm.q CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                        #" '",tm.f CLIPPED,"'", #No:7643 #TQC-610072
                         " '",tm.b CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",
                         " '",tm.xxx CLIPPED,"'",       #TQC-610072
                         " '",tm.b_date CLIPPED,"'",    #TQC-610072
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aimr302',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r302_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r302_y()
 
   ERROR ""
END WHILE
   CLOSE WINDOW r302_w
END FUNCTION
 
FUNCTION r302_y()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0074
          l_sql 	STRING,                         #TQC-630166
          l_chr		LIKE type_file.chr1,            #No.FUN-690026 VARCHAR(1)
          l_order	ARRAY[3] OF LIKE ima_file.ima01,   #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
          sr            RECORD order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                               order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                               order3 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                               order4 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                               ima01  LIKE ima_file.ima01, # 料件編號
                               ima02  LIKE ima_file.ima02, # 品名規格
                               img02  LIKE img_file.img02, # 倉庫代號
                               img03  LIKE img_file.img03, # 存放位置
                               img04  LIKE img_file.img04, # 批號
                               ima05  LIKE ima_file.ima05, # 版本
                               ima08  LIKE ima_file.ima08, # 來源
                               ima07  LIKE ima_file.ima07, # ABC碼
                               img09  LIKE img_file.img09, # 庫存單位
                               ima23  LIKE ima_file.ima23, # 倉管員
                               ima25  LIKE ima_file.ima25, # 庫存單位     #No.FUN-590110
                               ima30  LIKE ima_file.ima30, # 最近盤點日期 #No.FUN-590110
                               ima29  LIKE ima_file.ima29, # 最近異動日期 #No.FUN-590110
#                              ima262 LIKE ima_file.ima262,# 庫存數量     #No.FUN-590110   #FUN-A20044
                               avl_stk LIKE type_file.num15_3,            #No.FUN-A20044
                               img22  LIKE img_file.img22, # 倉儲類別
                               img14  LIKE img_file.img14, # 最近盤點日期
                               img15  LIKE img_file.img15, # 最近異動日期
                               img16  LIKE img_file.img16, # 最近異動日期
                               img17  LIKE img_file.img17, # 最近異動日期
                               img10  LIKE img_file.img10, # 庫存數量
                               ima06  LIKE ima_file.ima06, # 分群碼
                               img23  LIKE img_file.img23, # 可不可用
                               ima09  LIKE ima_file.ima09, #其他分群碼
                               ima10  LIKE ima_file.ima10, #其他分群碼
                               ima11  LIKE ima_file.ima11, #其他分群碼
                               ima12  LIKE ima_file.ima12  #其他分群碼
                        END RECORD
    DEFINE l_avl_stk_mpsmrp LIKE type_file.num15_3,     #FUN-A20044
           l_unavl_stk      LIKE type_file.num15_3,     #FUN-A20044
           l_avl_stk        LIKE type_file.num15_3      #FUN-A20044  

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aimr302'
     #END FUN-550108
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','','','',",               #No.FUN-590110
                 "       ima01, ima02, img02, img03, img04, ima05,",
                 "       ima08, ima07, img09, ima23, ima25, ima30,",
#                "       ima29, ima262+ima261,img22, img14, img15,",    #FUN-A20044
                 "       ima29, ' ',img22, img14, img15,",              #FUN-A20044
                 "       img16, img17, img10, ima06, img23, ",
		 "       ima09, ima10, ima11, ima12 ",
                 "  FROM ima_file, img_file",
                 " WHERE ima01 = img01 ",
                 "   AND ima08 NOT IN ('C','D','A') ",
	   	         " AND ",tm.wc CLIPPED," AND imaacti='Y' "
    #IF g_sma.sma29 = 'Y' THEN       #判斷 Blow through flag   #No.FUN-670041 mark
		LET l_sql=l_sql CLIPPED," AND ima08 !='X' "
    #END IF             #No.FUN-670041 mark
     #No:7643 列印庫存數量為零的料件 = 'N'
     IF tm.f = 'N' THEN
#No.FUN-590110 --start--
        IF g_sma.sma12='Y' THEN
#         LET l_sql = l_sql CLIPPED ," AND ima262 IS NOT NULL AND ima262 <> 0 "   #FUN-A20044 
          LET l_sql = l_sql CLIPPED                                               #FUN-A20044
        ELSE
           LET l_sql = l_sql CLIPPED ," AND img10 IS NOT NULL AND img10 <> 0 "
        END IF
#No.FUN-590110 --end--
     END IF
     #No:7643(end)
     IF  tm.d = 'N' THEN    #大宗料件
	     LET l_sql=l_sql CLIPPED," AND ima08 NOT IN ('U','V') "
     END IF
     IF  tm.e = 'N' THEN    #在途料件
	     LET l_sql=l_sql CLIPPED," AND ima08 != 'R' "
     END IF
     IF g_sma.sma12='Y' THEN   #多倉時, 判斷倉儲類別
        CASE
        	WHEN tm.c = '1'
	          LET l_sql=l_sql CLIPPED, " AND img22 = 'S' "
        	WHEN tm.c = '2'
	          LET l_sql=l_sql CLIPPED, " AND img22 = 'W' "
        END CASE
     END IF
     PREPARE r302_prepare FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE r302_curs CURSOR FOR r302_prepare
 
     CALL cl_outnam('aimr302') RETURNING l_name
#No.FUN-590110 --start--
     IF g_sma.sma12='N' THEN
       LET g_zaa[44].zaa06='Y'
       LET g_zaa[45].zaa06='Y'
       LET g_zaa[46].zaa06='Y'
       LET g_zaa[47].zaa06='Y'
       LET g_zaa[48].zaa06='Y'
       LET g_zaa[49].zaa06='Y'
     END IF
     CALL cl_prt_pos_len()
#No.FUN-590110 --end--
     START REPORT r302_rep TO l_name
 
     LET g_pageno = 0
     LET xxx_count=0
     FOREACH r302_curs INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
#No.FUN-A20044 ---start---
       CALL s_getstock(sr.ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk
       LET sr.avl_stk = l_avl_stk + l_unavl_stk
       IF g_sma.sma12='Y' THEN
          IF cl_null(l_avl_stk) OR l_avl_stk = 0 THEN
             CONTINUE FOREACH
          END IF 
       END IF 
#No.FUN-A20044 ---end---
   
       IF sr.ima01 IS NULL THEN LET sr.ima01 = ' ' END IF
       IF sr.ima07 IS NULL THEN LET sr.ima07 = ' ' END IF
       IF sr.ima23 IS NULL THEN LET sr.ima23 = ' ' END IF
       IF sr.ima06 IS NULL THEN LET sr.ima06 = ' ' END IF
       IF sr.ima09 IS NULL THEN LET sr.ima09 = ' ' END IF
       IF sr.ima10 IS NULL THEN LET sr.ima10 = ' ' END IF
       IF sr.ima11 IS NULL THEN LET sr.ima11 = ' ' END IF
       IF sr.ima12 IS NULL THEN LET sr.ima12 = ' ' END IF
       LET xxx_count=xxx_count+1
       IF xxx_count>tm.xxx THEN EXIT FOREACH END IF
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ima23
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.img02
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.img03
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.ima07
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.ima01
               WHEN tm.s[g_i,g_i] = '6'
           	    CASE tm.q
		      WHEN '0' LET l_order[g_i] = sr.ima06
		      WHEN '1' LET l_order[g_i] = sr.ima09
		      WHEN '2' LET l_order[g_i] = sr.ima10
		      WHEN '3' LET l_order[g_i] = sr.ima11
		      WHEN '4' LET l_order[g_i] = sr.ima12
		      OTHERWISE EXIT CASE
                    END CASE
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
#No.FUN-590110 --start--
       IF g_sma.sma12='Y' THEN
          LET sr.order4 = sr.ima01
       END IF
#No.FUN-590110 --end--
	   #最近盤點日不可為空
#No.FUN-590110 --start--
       IF g_sma.sma12='Y' THEN
          LET g_msg = sr.ima01 CLIPPED,'(img_file.img14)'
       ELSE
          LET g_msg = sr.ima01 CLIPPED,'(ima_file.ima30)'
          IF sr.ima30 IS NULL THEN CALL cl_err(g_msg,'mfg1018',1)
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
             EXIT PROGRAM
          END IF
       END IF
#No.FUN-590110 --end--
       CASE
	   WHEN sr.ima07 = 'A'
		IF tm.b_date - sr.img14 > g_sma.sma15 THEN
		   OUTPUT TO REPORT r302_rep(sr.*)
		END IF
	   WHEN sr.ima07 = 'B'
		IF tm.b_date - sr.img14 > g_sma.sma16 THEN
		   OUTPUT TO REPORT r302_rep(sr.*)
		END IF
	   WHEN sr.ima07 = 'C'
		IF tm.b_date - sr.img14 > g_sma.sma17 THEN
		   OUTPUT TO REPORT r302_rep(sr.*)
		END IF
       END CASE
     END FOREACH
 
     FINISH REPORT r302_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r302_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          sr            RECORD order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                               order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                               order3 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                               order4 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                               ima01  LIKE ima_file.ima01, #料件編號
                               ima02  LIKE ima_file.ima02, #品名規格
                               img02  LIKE img_file.img02, #倉庫代號
                               img03  LIKE img_file.img03, #存放位置
                               img04  LIKE img_file.img04, #批號
                               ima05  LIKE ima_file.ima05, #版本
                               ima08  LIKE ima_file.ima08, #來源
                               ima07  LIKE ima_file.ima07, #ABC碼
                               img09  LIKE img_file.img09, #庫存單位
                               ima23  LIKE ima_file.ima23, #倉管員
                               ima25  LIKE ima_file.ima25, #庫存單位     #No.FUN-590110
                               ima30  LIKE ima_file.ima30, #最近盤點日期 #No.FUN-590110
                               ima29  LIKE ima_file.ima29, #最近異動日期 #No.FUN-590110
#                              ima262 LIKE ima_file.ima262,#庫存數量     #No.FUN-590110   #FUN-A20044
                               avl_stk LIKE type_file.num15_3,                            #FUN-A20044     
                               img22  LIKE img_file.img22, #倉儲類別
                               img14  LIKE img_file.img14, #最近盤點日期
                               img15  LIKE img_file.img15, #最近異動日期
                               img16  LIKE img_file.img16, #最近異動日期
                               img17  LIKE img_file.img17, #最近異動日期
                               img10  LIKE img_file.img10, #庫存數量
                               ima06  LIKE ima_file.ima06, #分群碼
                               img23  LIKE img_file.img23, #可不可用
                               ima09  LIKE ima_file.ima09, #其他分群碼
                               ima10  LIKE ima_file.ima10, #其他分群碼
                               ima11  LIKE ima_file.ima11, #其他分群碼
                               ima12  LIKE ima_file.ima12  #其他分群碼
                        END RECORD,
          l_gen02   LIKE gen_file.gen02,
          l_chr	    LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,sr.ima01
  FORMAT
   PAGE HEADER
#No.FUN-590110 --start--
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      LET   g_head1 = g_x[9] CLIPPED,' ',tm.b_date
      PRINT g_head1
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[44],g_x[38],
            g_x[45],g_x[46],g_x[47],g_x[48],g_x[37],g_x[49],g_x[39],g_x[40],
            g_x[41],g_x[42],g_x[43]
      PRINT g_dash1
#No.FUN-590110 --end--
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
#     IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)     #No.TQC-6C0222
      IF tm.t[1,1] = 'Y' AND (PAGENO > 0 OR LINENO > 9)     #No.TQC-6C0222
         THEN SKIP TO TOP OF PAGE
      END IF
   BEFORE GROUP OF sr.order2
#     IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)     #No.TQC-6C0222
      IF tm.t[2,2] = 'Y' AND (PAGENO > 0 OR LINENO > 9)     #No.TQC-6C0222
         THEN SKIP TO TOP OF PAGE
      END IF
   BEFORE GROUP OF sr.order3
#     IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9)     #No.TQC-6C0222
      IF tm.t[3,3] = 'Y' AND (PAGENO > 0 OR LINENO > 9)     #No.TQC-6C0222
         THEN SKIP TO TOP OF PAGE
      END IF
#No.FUN-590110 --start--
   BEFORE GROUP OF sr.order4
      IF g_sma.sma12='Y' THEN
         IF sr.ima08 MATCHES '[TZUVX]' THEN
	    PRINT COLUMN g_c[31],g_x[10];
         END IF
	 LET l_gen02=''
	 SELECT gen02 INTO l_gen02
		FROM gen_file
		WHERE gen01=sr.ima23
         PRINT COLUMN g_c[32],sr.ima01 CLIPPED,  #FUN-5B0014 [1,20],
               COLUMN g_c[33],sr.ima02,
               COLUMN g_c[34],sr.ima05,
               COLUMN g_c[35],sr.ima08,
               COLUMN g_c[36],sr.ima07,
               COLUMN g_c[44],sr.ima06;
      END IF
#No.FUN-590110 --end--
   ON EVERY ROW
#No.FUN-590110 --start--
      IF g_sma.sma12='N' THEN
         IF sr.ima08 MATCHES '[TZUVX]' THEN
            PRINT COLUMN g_c[31],g_x[10];
         END IF
         PRINT COLUMN g_c[32],sr.ima01 CLIPPED, #FUN-5B0014 [1,20],
               COLUMN g_c[33],sr.ima02,
               COLUMN g_c[34],sr.ima05,
               COLUMN g_c[35],sr.ima08,
               COLUMN g_c[36],sr.ima07,
               COLUMN g_c[38],sr.ima23[1,6],
               COLUMN g_c[37],sr.ima25,
               COLUMN g_c[39],sr.ima29,
               COLUMN g_c[40],sr.ima30;
         IF tm.b = 'Y' THEN
#           PRINT COLUMN g_c[41],sr.ima262 USING '-,---,---,---,--&.&&&';   #FUN-A20044
            PRINT COLUMN g_c[41],sr.avl_stk USING '-,---,---,---,--&.&&&';  #FUN-A20044
         END IF
         PRINT COLUMN g_c[42],'_______________',
               COLUMN g_c[43],'________'
      ELSE
         PRINT COLUMN g_c[38],sr.ima23[1,6],l_gen02;
         IF sr.img23 = 'N' THEN
            PRINT COLUMN g_c[45],g_x[10];
         END IF
         PRINT COLUMN g_c[46],sr.img02,
               COLUMN g_c[47],sr.img03,
               COLUMN g_c[48],sr.img04,
               COLUMN g_c[37],sr.img09,
               COLUMN g_c[49],sr.img22,
               COLUMN g_c[39],sr.img14,
               COLUMN g_c[40],sr.img17;
         IF tm.b = 'Y' THEN
            PRINT COLUMN g_c[41],sr.img10 USING '-,---,---,---,--&.&&&';
         END IF
         PRINT COLUMN g_c[42],'_______________',
               COLUMN g_c[43],'________'
      END IF
   AFTER GROUP OF sr.order4
      IF g_sma.sma12='Y' THEN
         SKIP 1 LINE
      END IF
#No.FUN-590110 --end--
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         IF g_sma.sma12='Y' THEN       #No.FUN-590110
            CALL cl_wcchp(tm.wc,'ima23,ima01,ima07,ima06,ima09,
                 ima10,ima11,img02,img03')
            RETURNING tm.wc
         END IF
      PRINT g_dash[1,g_len]
       #TQC-630166
#      IF tm.wc[001,120] > ' ' THEN			# for 132
#	 PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#      IF tm.wc[121,240] > ' ' THEN
# 	 PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#      IF tm.wc[241,300] > ' ' THEN
# 	 PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
       CALL cl_prt_pos_wc(tm.wc)
       #END TQC-630166
 
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
   ## FUN-550108
      PRINT ''
      IF l_last_sw = 'n' THEN
         IF g_memo_pagetrailer THEN
             PRINT g_x[21]
             PRINT g_memo
         ELSE
             PRINT
             PRINT
         END IF
      ELSE
             PRINT g_x[21]
             PRINT g_memo
      END IF
      ## END FUN-550108
 
END REPORT
#Patch....NO.TQC-610036 <> #
