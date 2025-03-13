# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: amrr601.4gl
# Descriptions...: 料需求－獨立性需求列印
# Input parameter:
# Return code....:
# Date & Author..: 92/04/22 By Jones
# Modify.........: 93/03/11 BY Apple
# Modify.........: No:8531 03/11/25 By Apple rpc10不印了,rpc14 改為no use
# Modify.........: No.FUN-510046 05/02/15 By pengu 報表轉XML
# Modify.........: No.FUN-570240 05/07/22 By vivien 料件編號欄位增加controlp
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-850078 08/05/15 By sherry 報表改由CR輸出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD			
     	    	wc  	STRING,                  # Where condition   
                opunit  LIKE type_file.chr1,     # Prog. Version..: '5.30.06-13.03.12(01)     # 單位選擇
                bdate   LIKE type_file.dat,      # 始起日期         #NO.FUN-680082 DATE                
                edate   LIKE type_file.dat,      # 截止日期         #NO.FUN-680082 DATE              
                s       LIKE type_file.chr3,     #NO.FUN-680082 VARCHAR(03)       
                t       LIKE type_file.chr3,     #NO.FUN-680082 VARCHAR(03) 
                more    LIKE type_file.chr1      # Input more condition(Y/N)  #NO.FUN-680082 VARCHAR(01)
              END RECORD,
          p_wc          LIKE type_file.chr1000,  #NO.FUN-680082 VARCHAR(200)
          g_unit        LIKE type_file.chr8      #NO.FUN-680082 VARCHAR(08)
 
DEFINE   g_i            LIKE type_file.num5      #count/index for any purpose #NO.FUN-680082 SMALLINT
DEFINE   g_head1        STRING
#No.FUN-850078---Begin                                                          
DEFINE   g_str           STRING                                                 
DEFINE   g_sql           STRING                                                 
DEFINE   l_table         STRING                                                 
#No.FUN-850078---End  
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				    # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116
 
   #No.FUN-850078---Begin
   LET g_sql = "rpc01.rpc_file.rpc01,",
               "ima06.ima_file.ima06,",
               "ima16.ima_file.ima16,",
               "ima08.ima_file.ima08,",
               "ima05.ima_file.ima05,",
               "ima67.ima_file.ima67,",
               "rpc02.rpc_file.rpc02,",
               "rpc03.rpc_file.rpc03,",
               "rpc12.rpc_file.rpc12,",
               "rpc13.rpc_file.rpc13,",
               "rpc131.rpc_file.rpc131,",
               "diff.rpc_file.rpc13,",
               "rpc16.rpc_file.rpc16,",
               "ima25.ima_file.ima25,",
               "ima31.ima_file.ima31,",
               "factor.rpc_file.rpc16_fac,",
               "ima02.ima_file.ima02,",
               "gen02.gen_file.gen02,",
               "rpc17.rpc_file.rpc17,",
               "rpc04.rpc_file.rpc04,",
               "rpc14.rpc_file.rpc14"
 
   LET l_table = cl_prt_temptable('amrr601',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",          
               "        ? ) "                         
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF            
   #No.FUN-850078---End
 
                
   LET g_pdate  = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.opunit  = ARG_VAL(8)
   LET tm.bdate = ARG_VAL(9)
   LET tm.edate = ARG_VAL(10)
   LET tm.s     = ARG_VAL(11)
   LET tm.t     = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob='N'		# If background job sw is off
      THEN CALL amrr601_tm()	        	# Input print condition
      ELSE CALL amrr601()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amrr601_tm()
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	 LIKE type_file.num5,   #NO.FUN-680082 SMALLINT
          l_sw           LIKE type_file.num5,   #NO.FUN-680082 SMALLINT
          l_cmd		 LIKE type_file.chr1000 #NO.FUN-680082 VARCHAR(400)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 14
   ELSE LET p_row = 4 LET p_col = 8
   END IF
 
   OPEN WINDOW amrr601_w AT p_row,p_col
        WITH FORM "amr/42f/amrr601"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.opunit = '1'
   LET tm.s      = '123'
   LET tm.bdate  = g_today
   LET tm.edate  = g_today
   LET tm.more = 'N'
   LET g_pdate = g_today
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
    CONSTRUCT tm.wc ON ima16,ima08,rpc01,ima06,ima67,rpc02
                  FROM ima16,ima08,rpc01,ima06,ima67,rpc02
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION controlp
         IF INFIELD(rpc01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO rpc01
            NEXT FIELD rpc01
         END IF
#No.FUN-570240 --end
 
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
      LET INT_FLAG = 0 CLOSE WINDOW amrr601_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
    END IF
    IF tm.wc = " 1=1" THEN
       CALL cl_err('','9046',0)
       CONTINUE WHILE
    END IF
 
    INPUT BY NAME tm.opunit,tm.bdate,tm.edate,
                   tm2.s1,tm2.s2,tm2.s3,
                   tm2.t1,tm2.t2,tm2.t3,
                   tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD opunit
         IF cl_null(tm.opunit) OR tm.opunit NOT MATCHES'[12]'
         THEN NEXT FIELD opunit
         END IF
 
      AFTER FIELD edate
         IF NOT cl_null(tm.bdate) AND tm.edate IS NOT NULL
         THEN IF tm.edate  < tm.bdate  THEN
                 CALL cl_err('','mfg002',0)
                 NEXT FIELD bdate
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
 
      AFTER INPUT
         IF cl_null(tm.opunit) THEN LET tm.opunit = '1' END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW amrr601_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='amrr601'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amrr601','9031',1)
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
                         " '",tm.opunit CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('amrr601',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW amrr601_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL amrr601()
   ERROR ""
END WHILE
   CLOSE WINDOW amrr601_w
END FUNCTION
 
FUNCTION amrr601()
   DEFINE l_name	LIKE type_file.chr20,   # External(Disk) file name      #NO.FUN-680082 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0076
          l_sql 	LIKE type_file.chr1000, # RDSQL STATEMENT               #NO.FUN-680082 VARCHAR(1000)
          l_chr		LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(1)
          l_za05	LIKE type_file.chr1000, #NO.FUN-680082 VARCHAR(40) 
          l_sw          LIKE type_file.num5,    #NO.FUN-680082 SMALLINT
          l_order	ARRAY[5] OF  LIKE rpc_file.rpc01,  #FUN-5B0105 20->40  #NO.FUN-680082 VARCHAR(40) 
          sr       RECORD order1 LIKE rpc_file.rpc01,      #FUN-5B0105 20->40  #NO.FUN-680082 VARCHAR(40)
                          order2 LIKE rpc_file.rpc01,      #FUN-5B0105 20->40  #NO.FUN-680082 VARCHAR(40)
                          order3 LIKE rpc_file.rpc01,      #FUN-5B0105 20->40  #NO.FUN-680082 VARCHAR(40)
                          rpc01 LIKE rpc_file.rpc01,   #料件編號	
                          rpc02 LIKE rpc_file.rpc02,   #銷售單號
                          rpc03 LIKE rpc_file.rpc03,   #項次
                          rpc04 LIKE rpc_file.rpc04,   #批次
                       #  rpc10 LIKE rpc_file.rpc10,   #需求類別   #No:8531
                          rpc11 LIKE rpc_file.rpc11,   #需求特性
                          rpc12 LIKE rpc_file.rpc12,   #需求日期
                          rpc13 LIKE rpc_file.rpc13,   #需求數量
                          rpc131 LIKE rpc_file.rpc131, #出貨數量
                          rpc14 LIKE rpc_file.rpc14,   #FAS
                          rpc16 LIKE rpc_file.rpc16,   #單位
                          rpc16_fac LIKE rpc_file.rpc16_fac,   #轉換率
                          rpc17 LIKE rpc_file.rpc17,   #專案號碼
                          ima02 LIKE ima_file.ima02,   #品名規格
                          ima05 LIKE ima_file.ima05,   #版本
                          ima06 LIKE ima_file.ima06,   #分群碼
                          ima08 LIKE ima_file.ima08,   #來源碼
                          ima16 LIKE ima_file.ima16,   #低階碼
                          ima25 LIKE ima_file.ima25,   #庫存單位
                          ima31 LIKE ima_file.ima31,   #銷售單位
                          ima67 LIKE ima_file.ima67,   #計劃員
                          gen02 LIKE gen_file.gen02,   #計劃員姓名
                          factor LIKE rpc_file.rpc16_fac,
                          diff  LIKE rpc_file.rpc13    #需求數量
                        END RECORD
 
     CALL cl_del_data(l_table)                   #No.FUN-850078                 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog #No.FUN-850078
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    
     #No.FUN-850078---Begin
     #IF tm.opunit ='1' THEN
     #     LET g_unit = g_x[21] CLIPPED
     #ELSE LET g_unit = g_x[22] CLIPPED
     #END IF
     #No.FUN-850078---Begin
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc CLIPPED," AND rpcuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc CLIPPED," AND rpcgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc CLIPPED," AND rpcgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rpcuser', 'rpcgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','','', ",
                 " rpc01, rpc02, rpc03, rpc04,", #rpc10,",   #No:8531
                 " rpc11, rpc12, rpc13, rpc131, rpc14,",
                 " rpc16, rpc16_fac, rpc17, ima02,",
                 " ima05, ima06, ima08, ima16, ima25, ima31,",
                 " ima67, gen02,'' ",
                 "  FROM rpc_file,ima_file LEFT OUTER JOIN gen_file ON ima67=gen01 ",
                 " WHERE rpc01 = ima01 AND ima37 IN ('0','2') ",
#                "   AND ima67 = gen01 AND rpc11 > 2",
                 "   AND rpcacti IN ('Y','y') ",
                 "   AND ",tm.wc CLIPPED
 
     IF NOT cl_null(tm.bdate) THEN
        LET l_sql = l_sql CLIPPED," AND rpc12 >='",tm.bdate,"'"
     END IF
 
     IF NOT cl_null(tm.edate) THEN
        LET l_sql = l_sql CLIPPED," AND rpc12 <='",tm.edate,"'"
     END IF
 
     PREPARE amrr601_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM
           
     END IF
     DECLARE amrr601_curs1 CURSOR FOR amrr601_prepare1
 
     #No.FUN-850078---Begin
     #CALL cl_outnam('amrr601') RETURNING l_name
     #START REPORT amrr601_rep TO l_name
 
     #LET g_pageno = 0
     #No.FUN-850078---End
     FOREACH amrr601_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF cl_null(sr.rpc13)  THEN LET sr.rpc13 = 0 END IF
       IF cl_null(sr.rpc131) THEN LET sr.rpc131 = 0 END IF
       IF cl_null(sr.rpc14)  THEN LET sr.rpc14 = 0 END IF
       #單位基準轉換('1':庫存 '2':銷售)
	   IF tm.opunit = '1' THEN
           LET sr.factor = sr.rpc16_fac
       ELSE
           IF sr.rpc16 != sr.ima31 THEN
              CALL s_umfchk(sr.rpc01,sr.rpc16,sr.ima31)
                      RETURNING l_sw,sr.factor
                IF l_sw THEN
                   CALL cl_err(sr.rpc01,'amr-074',0)
                   ###Modify:98/11/13----單位換算率----
                   EXIT FOREACH
                   ### LET sr.factor = 1
                END IF
           ELSE LET sr.factor = 1
           END IF
       END IF
       LET sr.rpc13  = sr.rpc13  * sr.factor
       LET sr.rpc131 = sr.rpc131 * sr.factor
       LET sr.rpc14  = sr.rpc14  * sr.factor
       #-->MRP需求量 = 需求數量 - 出貨數量 - FAS 量
       LET sr.diff = sr.rpc13 - sr.rpc131 - sr.rpc14
       #No.FUN-850078---Begin
       #FOR g_i = 1 TO 3
       #   CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ima16
       #        WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima06
       #        WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.ima67
       #        WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.rpc01
       #        WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.rpc02
#      #        WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.rpc10  No:8531
       #        WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.rpc12
       #        OTHERWISE LET l_order[g_i] = '-'
       #   END CASE
       #END FOR
       #LET sr.order1 = l_order[1]
       #LET sr.order2 = l_order[2]
       #LET sr.order3 = l_order[3]
       #OUTPUT TO REPORT amrr601_rep(sr.*)
       EXECUTE insert_prep USING sr.rpc01,sr.ima06,sr.ima16,sr.ima08,sr.ima05,
                                 sr.ima67,sr.rpc02,sr.rpc03,sr.rpc12,sr.rpc13,
                                 sr.rpc131,sr.diff,sr.rpc16,sr.ima25,sr.ima31,
                                 sr.factor,sr.ima02,sr.gen02,sr.rpc17,sr.rpc04,
                                 sr.rpc14     
       #No.FUN-850078---End
     END FOREACH
 
     #No.FUN-850078---Begin
     #FINISH REPORT amrr601_rep
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #是否列印選擇條件                                                       
     IF g_zz05 = 'Y' THEN                                                    
        CALL cl_wcchp(tm.wc,'ima16,ima08,rpc01,ima06,ima67,rpc02')                                        
             RETURNING g_str                                                 
     END IF      
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t[1,1]  
                 ,";",tm.t[2,2],";",tm.t[3,3],";",tm.opunit,";",tm.bdate,";",
                 tm.edate
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED         
     CALL cl_prt_cs3('amrr601','amrr601',l_sql,g_str)
     #No.FUN-850078---End 
END FUNCTION
 
#No.FUN-850078---Begin
#REPORT amrr601_rep(sr)
#  DEFINE l_last_sw	  LIKE type_file.chr1,         #NO.FUN-680082 VARCHAR(1)        
#         sr       RECORD order1 LIKE rpc_file.rpc01,#FUN-5B0105 20->40     #NO.FUN-680082 VARCHAR(40)
#                         order2 LIKE rpc_file.rpc01,#FUN-5B0105 20->40     #NO.FUN-680082 VARCHAR(40)
#                         order3 LIKE rpc_file.rpc01,#FUN-5B0105 20->40     #NO.FUN-680082 VARCHAR(40)
#                         rpc01 LIKE rpc_file.rpc01,   #料件編號	
#                         rpc02 LIKE rpc_file.rpc02,   #銷售單號
#                         rpc03 LIKE rpc_file.rpc03,   #項次
#                         rpc04 LIKE rpc_file.rpc04,   #批次
##                         rpc10 LIKE rpc_file.rpc10,   #需求類別  No:8531
#                         rpc11 LIKE rpc_file.rpc11,   #需求特性
#                         rpc12 LIKE rpc_file.rpc12,   #需求日期
#                         rpc13 LIKE rpc_file.rpc13,   #需求數量
#                         rpc131 LIKE rpc_file.rpc131, #出貨數量
#                         rpc14 LIKE rpc_file.rpc14,   #FAS
#                         rpc16 LIKE rpc_file.rpc16,   #單位
#                         rpc16_fac LIKE rpc_file.rpc16_fac,   #轉換率
#                         rpc17 LIKE rpc_file.rpc17,   #專案號碼
#                         ima02 LIKE ima_file.ima02,   #品名規格
#                         ima05 LIKE ima_file.ima05,   #版本
#                         ima06 LIKE ima_file.ima06,   #分群碼
#                         ima08 LIKE ima_file.ima08,   #來源碼
#                         ima16 LIKE ima_file.ima16,   #低階碼
#                         ima25 LIKE ima_file.ima25,   #庫存單位
#                         ima31 LIKE ima_file.ima31,   #銷售單位
#                         ima67 LIKE ima_file.ima67,   #計劃員
#                         gen02 LIKE gen_file.gen02,   #計劃員姓名
#                         factor LIKE rpc_file.rpc16_fac,
#                         diff  LIKE rpc_file.rpc13
#                       END RECORD,
#     l_chr		 LIKE type_file.chr1          #NO.FUN-680082 VARCHAR(1)
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line   #No.MOD-580242
 
# ORDER BY sr.order1,sr.order2,sr.order3,sr.rpc01
# FORMAT
#  PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
#           IF tm.opunit ='1' THEN
#                 LET g_head1=g_x[19] CLIPPED,g_x[21],'     ', g_x[20] CLIPPED,tm.bdate,'-',tm.edate
#                 PRINT g_head1
#           ELSE
#                 LET g_head1=g_x[19] CLIPPED,g_x[22],'     ', g_x[20] CLIPPED,tm.bdate,'-',tm.edate
#                 PRINT g_head1
#           END IF
#     PRINT g_dash[1,g_len]
#     PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
#                    g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],
#                    g_x[43],g_x[44],g_x[45],g_x[46]
#     PRINTX name=H2 g_x[47],g_x[48],g_x[49],g_x[50],g_x[51],g_x[52],
#                    g_x[53],g_x[54],g_x[55],g_x[56],g_x[57],g_x[58],
#                    g_x[59],g_x[60],g_x[61],g_x[62]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.order1
#     IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 10)
#        THEN SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF sr.order2
#     IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 10)
#        THEN SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF sr.order3
#     IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 10)
#        THEN SKIP TO TOP OF PAGE
#     END IF
 
#  ON EVERY ROW
#     PRINTX name=D1 COLUMN g_c[31],sr.rpc01,
#           COLUMN g_c[32],sr.ima06,
#           COLUMN g_c[33],sr.ima16 USING '#&',
#           COLUMN g_c[34],sr.ima08,
#           COLUMN g_c[35],sr.ima05,
#           COLUMN g_c[36],sr.ima67,
#           COLUMN g_c[37],sr.rpc02,
#           COLUMN g_c[38],sr.rpc03 USING '####',
#           COLUMN g_c[39],sr.rpc12,
#           COLUMN g_c[40],cl_numfor(sr.rpc13,40,3),
#           COLUMN g_c[41],cl_numfor(sr.rpc131,41,3),
#           COLUMN g_c[42],cl_numfor(sr.diff,42,3),
#           COLUMN g_c[43],sr.rpc16,
#           COLUMN g_c[44],sr.ima25,
#           COLUMN g_c[45],sr.ima31,
#           COLUMN g_c[46],cl_numfor(sr.factor,46,3)
 
#    PRINTX name=D2  COLUMN g_c[47],sr.ima02,
#           #COLUMN g_c[48],' ',
#           #COLUMN g_c[49],' ',
#           #COLUMN g_c[50],' ',
#           #COLUMN g_c[51],' ',
#           COLUMN g_c[52],sr.gen02,
#           COLUMN g_c[53],sr.rpc17,
#           COLUMN g_c[54],sr.rpc04 USING'####',
#          # COLUMN g_c[55],' ',
#           #COLUMN g_c[56],' ',
#           COLUMN g_c[57],cl_numfor(sr.rpc14,57,3)
#           #COLUMN g_c[58],' ',
#           #3COLUMN g_c[59],' ',
#           #COLUMN g_c[60],' ',
#           #COLUMN g_c[61],' ',
#           #COLUMN g_c[62],' '
 
#  ON LAST ROW
#     IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#        THEN PRINT g_dash[1,g_len]
#             #TQC-630166 Start
#            # IF tm.wc[001,070] > ' ' THEN			# for 80
#            #	 PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#            # IF tm.wc[071,140] > ' ' THEN
#            #	 PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#            # IF tm.wc[141,210] > ' ' THEN
#            # 	 PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#            # IF tm.wc[211,280] > ' ' THEN
#            #	 PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#             
#             CALL cl_prt_pos_wc(tm.wc)
#            #TQC-630166 End
 
#     END IF
#     PRINT g_dash[1,g_len]
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-850078---End
