# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aimr501.4gl
# Descriptions...: 料件庫存資料查詢
# Return code....:
# Date & Author..: 92/02/13 By Nora
# Modify.........: No.FUN-510017 05/01/11 By Mandy 報表轉XML
# Modify.........: No.FUN-570240 05/07/26 By day   料件編號欄位加CONTROLP
# Modify.........: No.TQC-5B0067 05/11/08 By Pengu 1.051103點測修改報表格式
# Modify.........: No.TQC-5C0005 05/12/05 By kevin 結束位置調整
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/07 By baogui 無列印順序
# Modify.........: No.CHI-710051 07/06/07 By jamie 將ima21欄位放大至11
# Modify.........: No.FUN-830152 08/04/03 By baofei  報表打印改為CR輸出
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/24 By vealxu ima26x 調整
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#CHI-710051
 
DEFINE tm  RECORD			# Print condition RECORD
	   wc  	STRING,   		# Where condition  #TQC-630166
           s  	LIKE type_file.chr3,  	# Order Sequence   #No.FUN-690026 VARCHAR(3)
   	   more	LIKE type_file.chr1   	# Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD
 
DEFINE g_i LIKE type_file.num5,          # count/index for any purpose  #No.FUN-690026 SMALLINT
       l_orderA      ARRAY[3] OF LIKE imm_file.imm13   #No.TQC-6A0088 
DEFINE   g_str           STRING                  #No.FUN-830152 
DEFINE   g_sql          STRING                  #No.FUN-A20044
DEFINE   l_table        STRING                  #No.FUN-A20044

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
#No.FUN-A20044 --start---
   LET g_sql = "order1.ima_file.ima01,",
               "order2.ima_file.ima01,",
               "order3.ima_file.ima01,",
               "ima01.ima_file.ima01,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ima05.ima_file.ima05,",
               "ima06.ima_file.ima06,",
               "ima08.ima_file.ima08,",
               "ima25.ima_file.ima25,",
               "avl_stk.type_file.num15_3,",
               "unavl_stk.type_file.num15_3,",
               "img02.img_file.img02,",
               "img03.img_file.img03,",
               "img04.img_file.img04,",
               "img23.img_file.img23,",
               "img10.img_file.img10,",
               "img09.img_file.img09 "
   LET l_table  = cl_prt_temptable('aimr501',g_sql) CLIPPED
   LET g_sql = " INSERT INTO ",g_cr_db_str CLIPPED, l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,? )" 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM
   END IF
  #No.FUN-A20044 ---end ---

 
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r501_tm()	        	# Input print condition
      ELSE CALL aimr501()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r501_tm()
   DEFINE l_cmd		LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(1000)
          p_row,p_col   LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
   LET p_row = 5 LET p_col = 18
 
   OPEN WINDOW r501_w AT p_row,p_col WITH FORM "aim/42f/aimr501"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET g_pdate = g_today
#  LET g_prtway = 'Q'
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
WHILE TRUE
   #若為單倉,無法執行本作業
   IF g_sma.sma12 = 'N' THEN
      OPEN WINDOW r501_w3 AT 16,21 WITH 3 ROWS, 40 COLUMNS
 
      CALL cl_err('','mfg1330',1)
      CLOSE WINDOW r310_w3
      EXIT WHILE
   END IF
   CONSTRUCT BY NAME tm.wc ON
      img01,ima05,ima06,ima08,img02
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
	     IF INFIELD(img01) THEN
		CALL cl_init_qry_var()
		LET g_qryparam.form = "q_ima"
		LET g_qryparam.state = "c"
		CALL cl_create_qry() RETURNING g_qryparam.multiret
		DISPLAY g_qryparam.multiret TO img01
		NEXT FIELD img01
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
      LET INT_FLAG = 0 CLOSE WINDOW r501_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
 # DISPLAY BY NAME tm.s,tm.more 		# Condition
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm.more WITHOUT DEFAULTS
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()	# Command execution
 
      ON ACTION CONTROLP
         CALL r501_wc()
 
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
       AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r501_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr501'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr501','9031',1)
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
                         " '",tm.s CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr501',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r501_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr501()
   ERROR ""
END WHILE
   CLOSE WINDOW r501_w
END FUNCTION
 
FUNCTION r501_wc()
   DEFINE l_wc LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(300)
 
   OPEN WINDOW r502_w2 AT 2,2 WITH FORM "aim/42f/aimi100"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aimi100")
 
   CALL cl_opmsg('q')
   CONSTRUCT BY NAME l_wc ON                    # 螢幕上取條件
        ima02, ima03,
        ima13, ima14, ima24, ima70, ima57, ima15,
        ima09, ima10, ima11, ima12, ima07,
        ima16, ima37, ima38, ima51, ima52,
        ima04, ima18, ima19, ima20,
        ima21, ima22, ima34, ima42,
        ima29, imauser, imagrup,
        imamodu, imadate, imaacti
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
     # IF g_action_choice = "locale" THEN
     #    LET g_action_choice = ""
     #    CALL cl_dynamic_locale()
     #    CONTINUE WHILE
     # END IF
 
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
   IF INT_FLAG THEN
      LET INT_FLAG = 0
   END IF
   CLOSE WINDOW r502_w2
END FUNCTION
 
FUNCTION aimr501()
   DEFINE l_name	LIKE type_file.chr20, 		   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0074
          l_sql 	STRING,    		           # RDSQL STATEMENT #TQC-630166
          l_chr		LIKE type_file.chr1,               #No.FUN-690026 VARCHAR(1)
          l_za05	LIKE za_file.za05,                 #No.FUN-690026 VARCHAR(40)
          l_order	ARRAY[3] OF LIKE ima_file.ima01,   #No.FUN-690026 VARCHAR(15)
          sr            RECORD order1 LIKE ima_file.ima01, #No.FUN-690026 VARCHAR(20)
                               order2 LIKE ima_file.ima01, #No.FUN-690026 VARCHAR(20)
                               order3 LIKE ima_file.ima01, #No.FUN-690026 VARCHAR(20)
                               ima01  LIKE ima_file.ima01, #料件編號
                               ima02  LIKE ima_file.ima02, #品名規格
                               ima021 LIKE ima_file.ima021,#品名規格 #FUN-510017
                               ima05  LIKE ima_file.ima05, #版本
                               ima06  LIKE ima_file.ima06, #分群碼
                               ima08  LIKE ima_file.ima08, #來源
                               ima25  LIKE ima_file.ima25, #庫存單位
#                              ima262 LIKE ima_file.ima262,#可用庫存數量       #FUN-A20044
#                              ima261 LIKE ima_file.ima261,#不可用庫存數量     #FUN-A20044
                               avl_stk LIKE type_file.num15_3,                 #FUN-A20044
                               unavl_stk LIKE type_file.num15_3,               #FUN-A20044 
                               img02  LIKE img_file.img02, #倉庫編號
                               img03  LIKE img_file.img03, #存放位置
                               img04  LIKE img_file.img04, #批號
                               img23  LIKE img_file.img23, #可用否
                               img10  LIKE img_file.img10, #庫存數量
                               img09  LIKE img_file.img09  #庫存單位
                        END RECORD
         ,l_unavl_stk   LIKE type_file.num15_3,      #FUN-A20044
          l_avl_stk_mpsmrp LIKE type_file.num15_3,   #FUN-A20044
          l_avl_stk     LIKE type_file.num15_3       #FUN-A20044 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-830152
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND imagrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','','',",
#                " ima01,ima02,ima021,ima05,ima06,ima08,ima25,ima262,",     #FUN-A20044
#                " ima261,img02,img03,img04,img23,img10,img09",             #FUN-A20044
                 " ima01,ima02,ima021,ima05,ima06,ima08,ima25,' ',",        #FUN-A20044
                 " ' ',img02,img03,img04,img23,img10,img09",                #FUN-A20044
                 " FROM ima_file,img_file",
                 " WHERE ima01 = img01 AND ",tm.wc CLIPPED,
                 " AND imaacti = 'Y'"
#No.FUN-830152---Begin 
      IF g_zz05 = 'Y' THEN                                                      
         CALL cl_wcchp(tm.wc,'img01,ima05,ima06,ima08,img02')                         
              RETURNING tm.wc                                                   
      END IF                                                                    
#No.FUN-A20044 ---start---
    PREPARE r501_prepare1 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1)  END IF
    DECLARE r501_cs1 CURSOR FOR r501_prepare1
    FOREACH r501_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
       CALL s_getstock(sr.ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk
       LET sr.unavl_stk = l_unavl_stk
       LET sr.avl_stk = l_avl_stk
       EXECUTE insert_prep USING sr.*
    END FOREACH
#No.FUN-A20044 ---end----
     
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  #No.FUN-A20044

    LET g_str=tm.wc ,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3]
#   CALL cl_prt_cs1('aimr501','aimr501',l_sql,g_str)
    CALL cl_prt_cs3('aimr501','aimr501',g_sql,g_str)  
#     PREPARE r501_p1 FROM l_sql
#     IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
#       EXIT PROGRAM
#          
#    END IF
#    DECLARE r501_c1 CURSOR FOR r501_p1
 
#    CALL cl_outnam('aimr501') RETURNING l_name
 
#    START REPORT r501_rep TO l_name
 
#    FOREACH r501_c1 INTO sr.*
#      IF SQLCA.sqlcode != 0 THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1)
#          EXIT FOREACH
#      END IF
#      FOR g_i = 1 TO 3
#          CASE tm.s[g_i,g_i]
#               WHEN '1'  LET l_order[g_i] = sr.img02
#                         LET l_orderA[g_i] =g_x[21]    #TQC-6A0088
#               WHEN '2'  LET l_order[g_i] = sr.img03
#                         LET l_orderA[g_i] =g_x[22]    #TQC-6A0088
#               WHEN '3'  LET l_order[g_i] = sr.img10
#                         LET l_orderA[g_i] =g_x[25]    #TQC-6A0088
#               OTHERWISE LET l_order[g_i] = '-'
#                         LET l_orderA[g_i] =''    #TQC-6A0088
#          END CASE
#     END FOR
#     LET sr.order1 = l_order[1]
#     LET sr.order2 = l_order[2]
#     LET sr.order3 = l_order[3]
 
#      OUTPUT TO REPORT r501_rep(sr.*)
 
#    END FOREACH
 
#    FINISH REPORT r501_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-830152---End
END FUNCTION
#No.FUN-830152---Begin
#REPORT r501_rep(sr)
#  DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#         sr            RECORD order1 LIKE ima_file.ima01, #No.FUN-690026 VARCHAR(20)
#                              order2 LIKE ima_file.ima01, #No.FUN-690026 VARCHAR(20)
#                              order3 LIKE ima_file.ima01, #No.FUN-690026 VARCHAR(20)
#                              ima01  LIKE ima_file.ima01, #料件編號
#                              ima02  LIKE ima_file.ima02, #品名規格
#                              ima021 LIKE ima_file.ima021,#品名規格 #FUN-510017
#                              ima05  LIKE ima_file.ima05, #版本
#                              ima06  LIKE ima_file.ima06, #分群碼
#                              ima08  LIKE ima_file.ima08, #來源
#                              ima25  LIKE ima_file.ima25, #庫存單位
#                              ima262 LIKE ima_file.ima262,#可用庫存數量
#                              ima261 LIKE ima_file.ima261,#不可用庫存數量
#                              img02  LIKE img_file.img02, #倉庫編號
#                              img03  LIKE img_file.img03, #存放位置
#                              img04  LIKE img_file.img04, #批號
#                              img23  LIKE img_file.img23, #可用否
#                              img10  LIKE img_file.img10, #數量
#                              img09  LIKE img_file.img09  #單位
#                       END RECORD,
#     l_chr		LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.ima01,sr.order1,sr.order2,sr.order3
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1] CLIPPED     #TQC-6A0088  加CLIPPED
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
##     PRINT     #TQC-6A0088
#     PRINT g_x[9] CLIPPED,l_orderA[1] CLIPPED,                      #TQC-6A0088                                                    
#                      '-',l_orderA[2] CLIPPED,'-',l_orderA[3] CLIPPED   #TQC-6A0088
#     PRINT g_dash
####TQC-6A0090--begin--加CLIPPED
#     PRINT COLUMN  2,g_x[11] CLIPPED,sr.ima01 CLIPPED, 
#           COLUMN 42,g_x[12] CLIPPED,sr.ima05 CLIPPED, 
#           COLUMN 54,g_x[13] CLIPPED,sr.ima08 CLIPPED, 
#           COLUMN 67,g_x[14] CLIPPED,sr.ima06 CLIPPED  
#     PRINT COLUMN  2,g_x[15] CLIPPED,sr.ima02 CLIPPED, 
#           COLUMN 67,g_x[18] CLIPPED,sr.ima25 CLIPPED
#     PRINT COLUMN  2,g_x[19] CLIPPED,sr.ima021 CLIPPED
#     PRINT COLUMN  2,g_x[16] CLIPPED,cl_numfor(sr.ima262,15,3) CLIPPED,
#           COLUMN 37,g_x[17] CLIPPED,cl_numfor(sr.ima261,15,3) CLIPPED
####TQC-6A0090--end--加CLIPPED
#     PRINT g_dash2
#     PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,g_x[35] CLIPPED,g_x[36] CLIPPED    #TQC-6A0088 加CLIPPED
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.ima01
#     IF (PAGENO > 1 OR LINENO > 9) THEN
#        SKIP TO TOP OF PAGE
#     END IF
 
#  ON EVERY ROW
###TQC-6A0088--begin   加CLIPPED
#     PRINT COLUMN g_c[31],sr.img02 CLIPPED,
#           COLUMN g_c[32],sr.img03 CLIPPED,
#           COLUMN g_c[33],sr.img04 CLIPPED,
#           COLUMN g_c[34],sr.img23 CLIPPED,
#           COLUMN g_c[35],cl_numfor(sr.img10,35,3) CLIPPED,
#           COLUMN g_c[36],sr.img09 CLIPPED
###TQC-6A0088--end  加CLIPPED
 
#  ON LAST ROW
#     IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#        THEN PRINT g_dash
#      #TQC-630166
#      #       IF tm.wc[001,070] > ' ' THEN			# for 80
##		 PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
##              IF tm.wc[071,140] > ' ' THEN
##	 	 PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
##              IF tm.wc[141,210] > ' ' THEN
##	 	 PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
##               IF tm.wc[211,280] > ' ' THEN
##	 	 PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#      CALL cl_prt_pos_wc(tm.wc)
#      #END TQC-630166
 
#     END IF
#     PRINT g_dash #No.TQC-5C0005
#     PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED    #No.TQC-5B0067 modify
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash #No.TQC-5C0005
#             PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-10), g_x[6] CLIPPED   #No.TQC-5B0067 modify
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-830152---End
