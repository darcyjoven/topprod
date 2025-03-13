# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abmr101.4gl
# Descriptions...: 多階材料用量明細表
# Input parameter:
# Return code....:
# Date & Author..: 94/06/07 By Apple
# Modify.........: No.FUN-560030 05/06/14 By kim 測試BOM : bmo_file新增 bmo06 ,相關程式需修改
# Modify.........: No.FUN-560231 05/06/27 By Mandy QPA欄位放大
# Modify.........: No.FUN-570240 05/07/26 By jackie 料件編號欄位加CONTROLP
# Modify.........: No.MOD-590022 05/09/05 By Tracy 報表格式修改
# Modify.........: No.MOD-590110 05/09/29 By yoyo 報表格式修改轉XML
# Modify.........: No.FUN-5B0013 05/11/01 By Rosayu 將料號/品名/規格 欄位設成[1,,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.TQC-5B0107 05/11/12 By Pengu 報表料件、品名、規格之格式調整
# Modify.........: No.FUN-5A0061 05/11/21 By Pengu 報表缺規格
# Modify.........: NO.FUN-5B0105 05/12/14 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-630023 06/03/07 By Pengu 列印時選擇單行順序列印即當機
# Modify.........: NO.TQC-630272 06/03/30 by Yiting 主件編號^P出現應為工程BOM的主件
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.MOD-6B0060 06/12/11 By claire 列印項次前置或料號前置資料有問題
# Modify.........: No.CHI-6C0026 06/12/28 By kim 如果是正式料號的話則展開P-BOM
# Modify.........: No.MOD-710102 07/01/16 By Mandy 產生Out of memory error
# Modify.........: No.MOD-750105 07/05/28 By pengu 列印結果應跟abmr601一樣以樹狀結構呈現
# Modify.........: No.MOD-770146 07/08/06 By pengu 當不勾選"列印說明"時,其報表內容不會顯示
# Modify.........: No.MOD-7C0097 07/12/17 By Pengu 凡like bmu_file.bmu06改為like type_file.chr20
# Modify.........: No.FUN-850044 08/05/16 By mike 報表輸出方式轉為Crystal Reports
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-A40033 10/04/19 By fumk 追单MOD-960109  
# Modify.........: No:MOD-A40094 10/04/19 By Sarah 報表單身增加顯示品名
# Modify.........: No.TQC-AB0246 10/12/01 By vealxu 在FUNCTION r101_ebom()一開始將l_ss變數先清空
# Modify.........: No:MOD-B10223 11/01/26 By sabrina 將l_table3的bmu06型態改為type_file.chr20
# Modify.........: No:MOD-B50164 11/07/17 By Summer r101_pbom()少加了ima021
# Modify.........: No:MOD-B30720 11/07/17 By Summer 修改r101_precur的sql 
# Modify.........: No.FUN-B80100 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No:TQC-C20170 12/02/14 By bart tm.wc型態改為STRING

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD			      # Print condition RECORD
            #wc        LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(500)    3TQC-C20170 mark
            wc        STRING,   #TQC-C20170
            a         LIKE type_file.num10,   #No.FUN-680096 INTEGER
            s         LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
            loc       LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
            b         LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
   	    more      LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
        END RECORD,
        g_bmo01_a       LIKE bmo_file.bmo01,
        g_bmo011_a      LIKE bmo_file.bmo011,
        g_bmo06         LIKE bmo_file.bmo06,   #FUN-560030
    	g_tot           LIKE type_file.num10   #No.FUN-680096 INTEGER 
 
DEFINE   g_chr          LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
DEFINE   g_cnt          LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose   #No.FUN-680096 SMALLINT
DEFINE   g_str          STRING    #No.FUN-590110
DEFINE   g_no           LIKE type_file.num10    #No.CHI-A40033 add  
DEFINE   l_table1       STRING    #No.FUN-850044
DEFINE   l_table2       STRING    #No.FUN-850044  
DEFINE   l_table3       STRING    #No.FUN-850044
DEFINE   g_sql          STRING    #No.FUN-850044   
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690107 #FUN-BB0047 mark
 
   #No.FUN-850044  --begin
   LET g_sql = "order0.type_file.num5, order1.bmp_file.bmp02,",
               "bmo01_a.bmo_file.bmo01,bmo011_a.bmo_file.bmo011,",
               "bmo01.bmo_file.bmo01,  bmo011.bmo_file.bmo011,",
               "bmp01.bmp_file.bmp01,  bmp011.bmp_file.bmp011,",
               "bmp02.bmp_file.bmp02,  bmp03.bmp_file.bmp03,",
               "bmp04.bmp_file.bmp04,  bmp05.bmp_file.bmp05,",
               "bmp06.bmp_file.bmp06,  bmp07.bmp_file.bmp07,",
               "bmp08.bmp_file.bmp08,  bmp10.bmp_file.bmp10,",
               "bmp13.bmp_file.bmp13,  bmp16.bmp_file.bmp16,",
               "bmp28.bmp_file.bmp28,  ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,ima05.ima_file.ima05,",   #MOD-A40094 add ima021
               "ima08.ima_file.ima08,  ima15.ima_file.ima15,",
               "l_ima02.ima_file.ima02,l_ima021.ima_file.ima021,",
               "l_ima05.ima_file.ima05,l_ima08.ima_file.ima08,",
               "l_ima63.ima_file.ima63,l_ima55.ima_file.ima55,",
               "l_total.bmp_file.bmp06,g_bmo06.bmo_file.bmo06,",
               "l_ss.type_file.chr1000,g_no.type_file.num10"  #No:MOD-960109 add g_no
   LET l_table1 = cl_prt_temptable("abmr1011",g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "bec01.bec_file.bec01,",
               "bec02.bec_file.bec02,",
               "bec021.bec_file.bec021,",
               "bec011.bec_file.bec011,",
               "bec03.bec_file.bec03,",
               "bec04.bec_file.bec04,",
               "bec05.bec_file.bec05"
   LET l_table2 = cl_prt_temptable("abmr1012",g_sql) CLIPPED                                                                        
   IF l_table2 = -1 THEN EXIT PROGRAM END IF    
   
   LET g_sql = "bmu01.bmu_file.bmu01,",
               "bmu02.bmu_file.bmu02,",
               "bmu03.bmu_file.bmu03,",
               "bmu011.bmu_file.bmu011,",
              #"bmu06.bmu_file.bmu06"       #MOD-B10223 mark
               "bmu06.type_file.chr20"      #MOD-B10223 add
   LET l_table3 = cl_prt_temptable("abmr1013",g_sql) CLIPPED                                                                        
   IF l_table3 = -1 THEN EXIT PROGRAM END IF   
   #No.FUN-850044  --end
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a       = ARG_VAL(8)
   LET tm.s       = ARG_VAL(9)
   LET tm.loc     = ARG_VAL(10)
   LET tm.b       = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r101_tm(0,0)			# Input print condition
      ELSE CALL r101()			# Read bmota and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION r101_tm(p_row,p_col)
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_flag        LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_one         LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          l_bdate       LIKE bmx_file.bmx07,	
          l_edate       LIKE bmx_file.bmx08,	
          l_bmo01       LIKE bmo_file.bmo01,
          l_bmo011      LIKE bmo_file.bmo011,
          l_bmo06       LIKE bmo_file.bmo06,    #FUN-560030
          l_ima06       LIKE ima_file.ima06,	
          l_cmd		LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 9 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 5 LET p_col = 20
   ELSE
       LET p_row = 4 LET p_col = 9
   END IF
 
   OPEN WINDOW r101_w AT p_row,p_col
        WITH FORM "abm/42f/abmr101"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #FUN-560030................begin
    CALL cl_set_comp_visible("acode",g_sma.sma118='Y')
    #FUN-560030................end
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a  = 1
   LET tm.s  = g_sma.sma65
   LET tm.loc= '1'
   LET tm.b  = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_prtway = NULL
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT tm.wc ON bmo01,bmo011,bmo06 FROM item,ver,acode #FUN-560030
 
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
 
#No.FUN-570240  --start-
      ON ACTION CONTROLP
            IF INFIELD(item) THEN
               CALL cl_init_qry_var()
               #LET g_qryparam.form = "q_ima5"   #NO.TQC-630272 MARK
               LET g_qryparam.form = "q_bmo"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO item
               NEXT FIELD item
            END IF
#No.FUN-570240 --end--
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
      LET INT_FLAG = 0 CLOSE WINDOW r101_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   LET l_one='N'
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   IF tm.wc != ' 1=1' THEN
       LET l_cmd="SELECT bmo01,bmo011,bmo06,ima06 ", #FUN-560030
                 " FROM bmo_file Left Outer Join ima_file on bmo_file.bmo01 = ima_file.ima01 ",
                 " AND ima08 != 'A' WHERE ",
                  tm.wc CLIPPED
       PREPARE r101_precnt FROM l_cmd
       IF SQLCA.sqlcode THEN
          CALL cl_err('Prepare:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
          EXIT PROGRAM
       END IF
       DECLARE r101_cnt
            CURSOR FOR r101_precnt
       MESSAGE " SEARCHING ! "
       CALL ui.Interface.refresh()
       FOREACH r101_cnt INTO l_bmo01,l_bmo011,l_bmo06,l_ima06 #FUN-560030
         IF SQLCA.sqlcode  THEN
            CALL cl_err(SQLCA.sqlcode,'mfg2601',0)
            CONTINUE WHILE
         ELSE
            LET l_one = 'Y'
            EXIT FOREACH
         END IF
       END FOREACH
       MESSAGE " "
       CALL ui.Interface.refresh()
       IF cl_null(l_bmo011) OR cl_null(l_bmo01) THEN
          CALL cl_err(SQLCA.sqlcode,'mfg2601',0)
          CONTINUE WHILE
       END IF
   END IF
 
#UI
   INPUT BY NAME tm.a,tm.s,tm.loc,tm.b,tm.more
                 WITHOUT DEFAULTS
 
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
		 IF tm.a IS NULL OR tm.a < 0 THEN
			 LET tm.a = 1
			 DISPLAY BY NAME tm.a
		 END IF
      AFTER FIELD s
         IF tm.s IS NULL OR tm.s NOT MATCHES'[1-3]' THEN
            NEXT FIELD s
         END IF
      AFTER FIELD loc
         IF tm.loc IS NULL OR tm.loc NOT MATCHES'[1-2]' THEN
            NEXT FIELD loc
         END IF
      AFTER FIELD b
         IF tm.b   IS NULL OR tm.b   NOT MATCHES'[YNyn]' THEN
            NEXT FIELD b
         END IF
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
         IF INT_FLAG THEN EXIT INPUT END IF
 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r101_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmr101'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abmr101','9031',1)
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
                         " '",tm.a CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.loc CLIPPED,"'",
                         " '",tm.b   CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('abmr101',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r101_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r101()
   ERROR ""
END WHILE
   CLOSE WINDOW r101_w
END FUNCTION
 
#-----------☉ 程式處理邏輯 ☉--------------------1991/08/03(Lee)-
FUNCTION r101()
   DEFINE l_name	LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
          #l_sql 	LIKE type_file.chr1000, # RDSQL STATEMENT  #No.FUN-680096 VARCHAR(1000)  #TQC-C20170
          l_sql     STRING,   #TQC-C20170
          l_za05	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
          l_cmd         LIKE type_file.chr1000, #No.CHI-A40033 add
          l_tmp         LIKE type_file.num10,   #No.TQC-630023 add   #No.FUN-680096 INTEGER
          l_bmo01       LIKE bmo_file.bmo01,          #主件料件
          l_bmo011      LIKE bmo_file.bmo011,         #版本
          l_bmo06       LIKE bmo_file.bmo06          #FUN-560030
   #No.FUN-850044  --BEGIN
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)
   CALL cl_del_data(l_table3)
   LET g_no  =1        #No.CHI-A40033 add
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                                
                 " VALUES(?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?,",                                                            
                 "        ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?)"  #No:MOD-960109 modify  #MOD-A40094 add ?
     PREPARE insert_prep FROM g_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM                                                                          
     END IF                                                                                                                         
                                                                                                                                    
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?,?)"                                                                                          
                                                                                                                                    
     PREPARE insert_prep1 FROM g_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM                                                                          
     END IF                                                                                                                         
                                                                                                                                    
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?)"                                                                                               
                                                                                                                                    
     PREPARE insert_prep2 FROM g_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep2:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM                                                                          
     END IF                      
     #No.FUN-850044  --END
                             
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND bmouser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同部門的資料
   #       LET tm.wc = tm.wc clipped," AND bmogrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND bmogrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmouser', 'bmogrup')
   #End:FUN-980030
 
   LET l_sql = "SELECT bmo01,bmo011,bmo06", #FUN-560030
               " FROM bmo_file Left Outer Join ima_file on bmo_file.bmo01 = ima_file.ima01 ",
               " AND ima08 != 'A' WHERE ",
                tm.wc 
   PREPARE r101_prepare1 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   DECLARE r101_c1 CURSOR FOR r101_prepare1
   
   #No.FUN-850044  --BEGIN
   {
   CALL cl_outnam('abmr101') RETURNING l_name  
   #No.FUN-590110--start
   IF tm.b='N' THEN
      LET g_zaa[42].zaa06='Y'
   ELSE                          #No.MOD-770146 add
      LET g_zaa[42].zaa06='N'    #No.MOD-770146 add
   END IF
   IF tm.loc='1' THEN
      LET g_zaa[33].zaa08=g_x[26]
      LET g_zaa[34].zaa08=g_x[25]
     #-------------No.TQC-630023 modify----
     #LET g_zaa[43].zaa07=1
     #LET g_zaa[44].zaa07=2
   ELSE
      LET g_zaa[33].zaa08=g_x[25]
      LET g_zaa[34].zaa08=g_x[26]
      LET l_tmp = g_zaa[44].zaa07
      LET g_zaa[44].zaa07= g_zaa[43].zaa07
      LET g_zaa[43].zaa07= l_tmp
     #-------------No.TQC-630023 end-------
   END IF
 
   CALL cl_prt_pos_len()
   #No.FUN-590110--end
   START REPORT r101_rep TO l_name
 
   #報表示
   CALL r101_cur()   
   LET g_pageno = 0
	 LET g_tot=0
   }                                                                                                                                
   IF tm.b='N' THEN                                                                                                                 
      LET l_name="abmr101"                                                                                                          
   ELSE                                                                                                                             
      LET l_name="abmr101_1"                                                                                                        
   END IF                                                                                                                           
   #No.FUN-850044  --END    
 
   FOREACH r101_c1 INTO l_bmo01,l_bmo011,l_bmo06 #FUN-560030
      IF SQLCA.sqlcode THEN
         CALL cl_err('F1:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET g_bmo01_a=l_bmo01
      LET g_bmo011_a=l_bmo011
      LET g_bmo06=l_bmo06
      CALL r101_ebom(0,l_bmo01,l_bmo011,l_bmo06,tm.a) #FUN-560030
   END FOREACH
 
   #FINISH REPORT r101_rep  #No.FUN-850044
 
   LET INT_FLAG = 0  ######add for prompt bug
   IF INT_FLAG THEN
      LET INT_FLAG = 0
   END IF
   #No.FUN-850044  --BEGIN
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len) 
   LET l_cmd =" ORDER BY g_no"  #No.CHI-A40033 add
   #----------------No.CHI-A40033 add
   IF tm.b ='N' THEN
      LET g_sql ="SELECT * FROM",g_cr_db_str CLIPPED,l_table1 CLIPPED,l_cmd CLIPPED,"|",  #No.CHI-A40033 modify
                 "SELECT * FROM",g_cr_db_str CLIPPED,l_table3 CLIPPED
   ELSE
   #----------------No.CHI-A40033 end  
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,l_cmd CLIPPED,"|",   #No.CHI-A40033 modify                                                      
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",                                                         
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED                                                         
   END IF      #No.CHI-A40033 add
 SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog  
   LET g_str = ''                                                                                                                 
   #是否列印選擇條件                                                                                                              
   IF g_zz05 = 'Y' THEN                                                                                                           
      CALL cl_wcchp(tm.wc,'bmo01,bmo011,bmo06')                                                                       
      RETURNING  tm.wc                                                                                                            
   END IF                                                                                                                         
   LET g_str = tm.wc,';',tm.a,';',tm.loc                                                                                           
   CALL cl_prt_cs3('abmr101',l_name,g_sql,g_str)                                                                               
   #No.FUN-850044  --END           
END FUNCTION
 
FUNCTION r101_ebom(p_level,p_key,p_ver,p_acode,p_total) #FUN-560030
   DEFINE p_level   LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          p_total   LIKE bmp_file.bmp06,    #FUN-560231
          l_total   LIKE bmp_file.bmp06,    #FUN-560231
          l_tot     LIKE type_file.num10,   #No.FUN-680096 INTEGER
          l_times   LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          p_key	    LIKE bmo_file.bmo01,    #主件料件編號
          p_ver     LIKE bmo_file.bmo011,   #版本
          p_acode   LIKE bmo_file.bmo06,    #FUN-560030
          l_ac,i    LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          arrno	    LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          b_seq	    LIKE type_file.num10,   #No.FUN-680096 INTEGER
          l_chr	    LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          l_order2  LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
          sr DYNAMIC ARRAY OF RECORD           #每階存放資料
              order0   LIKE type_file.num5,    #階次 #CHI-6C0026
              order1   LIKE bmp_file.bmp02,    #No.FUN-680096 VARCHAR(40)
              bmo01_a  LIKE bmo_file.bmo01,    #主件料件
              bmo011_a LIKE bmo_file.bmo011,   #版本
              bmo01    LIKE bmo_file.bmo01,    #主件料件
              bmo011   LIKE bmo_file.bmo011,   #版本
              bmp01    LIKE bmp_file.bmp01,    #本階主件
              bmp011   LIKE bmp_file.bmp011,   #版本
              bmp02    LIKE bmp_file.bmp02,    #項次
              bmp03    LIKE bmp_file.bmp03,    #元件料號
              bmp04    LIKE bmp_file.bmp04,    #有效日期
              bmp05    LIKE bmp_file.bmp05,    #失效日期
              bmp06    LIKE bmp_file.bmp06,    #QPA/BASE
              bmp07    LIKE bmp_file.bmp07,    #BASE
              bmp08    LIKE bmp_file.bmp08,    #損耗率%
              bmp10    LIKE bmp_file.bmp10,    #發料單位
              bmp13    LIKE bmp_file.bmp13,    #插件位置
              bmp16    LIKE bmp_file.bmp16,    #替代特性
              bmp28    LIKE bmp_file.bmp28,    #FUN-560030
              ima02    LIKE ima_file.ima02,    #品名
              ima021   LIKE ima_file.ima021,   #規格   #MOD-A40094 add
              ima05    LIKE ima_file.ima05,    #版本
              ima08    LIKE ima_file.ima08,    #來源
              ima15    LIKE ima_file.ima15     #保稅否
          END RECORD,
          l_cmd	    LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(600)
    #No.FUN-850044  --BEGIN
    DEFINE
          l_ima02 LIKE ima_file.ima02,    #品名                                                                                     
          l_ima021 LIKE ima_file.ima021,  #規格                                                                  
          l_ima05 LIKE ima_file.ima05,    #版本                                                                                     
          l_ima06 LIKE ima_file.ima06,    #版本                                                                                     
          l_ima08 LIKE ima_file.ima08,    #來源                                                                                     
          l_ima63 LIKE ima_file.ima63,    #發料單位                                                                                 
          l_ima55 LIKE ima_file.ima55,    #生產單位                                                                                 
          l_bmp03       LIKE bmp_file.bmp03,                                                                 
          l_k,l_now,l_p LIKE type_file.num5,                                                               
          l_point       LIKE cre_file.cre08,                                                           
          l_bec04 LIKE bec_file.bec04,                                                                                              
          l_bec05 ARRAY[200] OF LIKE bec_file.bec05,                                                   
          l_bmu06 ARRAY[200] OF LIKE type_file.chr20,                                                     
          l_bec05_s    LIKE bec_file.bec05,                                                                                         
          l_bmu06_s    LIKE type_file.chr20,                                                         
          l_bmp02      LIKE bmp_file.bmp02,                                                                                         
          l_bmustr     LIKE type_file.chr20,                                                      
          l_becstr     LIKE type_file.chr20,                                                   
          l_no,l_number  LIKE type_file.num5,                                                         
          l_ute_flag   LIKE type_file.chr2,                                                  
          l_now2       LIKE type_file.num5,                                                   
          l_len,l_byte LIKE type_file.num5, 
          l_ss         LIKE type_file.chr1000,                                          
          l_max_n      LIKE type_file.num5         
    #No.FUN-850044  --END
 
    IF p_level > 20 THEN
 	     CALL cl_err('','mfg2733',1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
       EXIT PROGRAM
    END IF
    LET p_level = p_level + 1
    LET l_times=1
    LET arrno = 600
    LET l_ss = NULL   #TQC-AB0246 
    WHILE TRUE
        LET l_cmd=
            "SELECT distinct 0,'','','',bmo01,bmo011,bmp01,bmp011,bmp02,bmp03,", #CHI-6C0026
            " bmp04,bmp05,bmp06,bmp07,bmp08,bmp10,bmp13,bmp16,bmp28, ", #FUN-560030
            "       ima02,ima021,ima05,ima08,ima15 ",   #MOD-A40094 add ima021
            "  FROM bmp_file, OUTER ima_file, OUTER bmo_file",
            " WHERE bmp01='", p_key,"' AND bmp02 >",b_seq,
            " AND bmp011='",p_ver,"'",
            " AND bmo011='",p_ver,"'",     #MOD-B30720 add
            "   AND bmp_file.bmp03 = ima_file.ima01",
           #"   AND bmp_file.bmp03 = bmo_file.bmo01", #MOD-B30720 mark
            "   AND bmp_file.bmp01 = bmo_file.bmo01", #MOD-B30720 add
            "   AND bmp28 = '",p_acode,"'"  #FUN-560030
 
       #------------------No.MOD-750105 add
        #---->排列方式
        LET l_cmd=l_cmd CLIPPED, " ORDER BY "
    	CASE WHEN tm.s = '1'
                  LET l_cmd = l_cmd CLIPPED, ' bmp02'
                 WHEN tm.s = '2'
                  LET l_cmd = l_cmd CLIPPED, ' bmp03'
                 WHEN tm.s = '3'
                  LET l_cmd = l_cmd CLIPPED, ' bmp13'
        END CASE
       #------------------No.MOD-750105 end
 
        #---->排列方式
        PREPARE r101_precur FROM l_cmd
        IF SQLCA.sqlcode THEN CALL cl_err('P1:',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
           EXIT PROGRAM 
        END IF
        DECLARE r101_cur CURSOR FOR r101_precur
        LET l_ac = 1
        FOREACH r101_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
            LET l_ac = l_ac + 1		    	# 但BUFFER不宜太大
            IF l_ac > arrno THEN EXIT FOREACH END IF
        END FOREACH
        LET l_tot = l_ac - 1
        #CHI-6C0026.............begin
        ##No.FUN-590110-begin
        #LET g_str=''
        #IF p_level >1 THEN
        #  FOR i = 2 TO p_level
        #      LET g_str=g_str,' '
        #  END FOR
        #END IF
        ##No.FUN-590110-end
        #CHI-6C0026.............end
        FOR i = 1 TO l_tot    	        	# 讀BUFFER傳給REPORT
           IF sr[i].bmp07 IS NULL OR sr[i].bmp07 = ' ' OR sr[i].bmp07 = 0
           THEN LET sr[i].bmp07 = 1
           END IF
           LET l_total=p_total*sr[i].bmp06/sr[i].bmp07
           CASE tm.s
             WHEN '1' LET sr[i].order1=sr[i].bmp02 using'#####'
             WHEN '2' LET sr[i].order1=sr[i].bmp03
             WHEN '3' LET sr[i].order1=sr[i].bmp13
             OTHERWISE LET sr[i].order1 = ' '
           END CASE
           LET sr[i].bmo01_a  = g_bmo01_a
           LET sr[i].bmo011_a = g_bmo011_a
           LET sr[i].order0 = p_level #CHI-6C0026
           
           #No.FUN-850044  --BEGIN
           #OUTPUT TO REPORT r101_rep(p_level,i,l_total,sr[i].*,g_bmo06) #FUN-560030
           SELECT ima02,ima021,ima05,ima08,ima63,ima55                                                        
             INTO l_ima02,l_ima021,l_ima05,l_ima08,l_ima63,l_ima55                                            
            FROM ima_file                                                                                                               
           WHERE ima01 = sr[i].bmo01_a                                                                                                     
           IF SQLCA.sqlcode THEN                                                                                                         
              SELECT bmq02,bmq021,bmq05,bmq08,bmq63,bmq55                                                                                      
                INTO l_ima02,l_ima021,l_ima05,l_ima08,l_ima63,l_ima55                                                                            
               FROM bmq_file                                                                                                           
              WHERE bmq01 = sr[i].bmo01_a                                                                                                 
              IF SQLCA.sqlcode THEN                                                                                                     
                 LET l_ima02='' LET l_ima05='' LET l_ima08=''                                                                           
                 LET l_ima63='' LET l_ima55='' LET l_ima021=''                                                                                         
              END IF                                                                                                                    
           END IF
           LET l_ute_flag = 'US'
           IF tm.loc='1' THEN                                                                                                            
              LET g_str=''                                                                                                               
              FOR l_p = 1 TO p_level -1                                                                                                  
                 LET g_str = g_str,' '                                                                                                  
              END FOR                                                                                                                    
              LET l_ss=g_str,sr[i].bmp02 USING '<<<<'                                                                                       
           ELSE                                                                                                                          
              LET l_point = ''                                                                                                           
              IF p_level > 1 THEN                                                                                                        
                 FOR l_p = 1 TO p_level - 1                                                                                              
                    LET l_point = l_point clipped,'.'                                                                                   
                 END FOR                                                                                                                 
              END IF                                                                                                                     
              LET l_ss=l_point,g_str,sr[i].bmp03 CLIPPED                                                                   
           END IF                                                                                                                        
           #---->改變替代特性的表示方式                                                                                              
           IF sr[i].bmp16 MATCHES '[12]' THEN                                                                                           
              LET g_cnt=sr[i].bmp16 USING '&'                                                                                          
              LET sr[i].bmp16=l_ute_flag[g_cnt,g_cnt]                                                                                  
           ELSE 
              LET sr[i].bmp16=' '                                                                                                      
           END IF                                                                                                                    
           #-->列印多插件位置                                                                             
           FOR g_cnt = 1 TO 200                                                                                                      
              LET l_bmu06[g_cnt]=NULL                                                                                               
           END FOR                                                                                                                   
           LET l_now2 = 1                                                                                                            
           LET l_len  = 20                                                                                                           
           LET l_bmustr =''                                                                                                          
           DECLARE r100_bmu06 CURSOR FOR                                                                                             
            SELECT bmu06 FROM bmu_file                                                                                               
             WHERE bmu01=sr[i].bmp01 AND bmu02=sr[i].bmp02                                                                                 
              AND bmu03=sr[i].bmp03 AND bmu011=sr[i].bmp011                                                                               
           FOREACH r100_bmu06 INTO l_bmu06_s                                                                                         
              IF STATUS THEN                                                                                                       
                 CALL cl_err('Foreach:',STATUS,0) EXIT FOREACH                                                                     
              END IF                                                                                                               
              IF l_now2 > 200 THEN CALL cl_err('','9036',1)                                                                        
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time                                                      
                 EXIT PROGRAM                                                                                                      
              END IF                                                                                                               
              LET l_byte = length(l_bmu06_s) + 1                                                                                   
              IF l_len >=l_byte THEN                                                                                               
                 LET l_bmustr = l_bmustr clipped,l_bmu06_s clipped,','
                 LET l_len = l_len - l_byte                                                                                        
              ELSE                                                                                                                 
                 LET l_bmu06[l_now2] = l_bmustr                                                                                    
                 LET l_now2 = l_now2 + 1                                                                                           
                 LET l_len = 20                                                                                                    
                 LET l_len = l_len - l_byte                                                                                        
                 LET l_bmustr = ''                                                                                                 
                 LET l_bmustr = l_bmustr clipped,l_bmu06_s clipped,','                                                             
              END IF                                                                                                               
           END FOREACH                                                                                                               
           LET l_bmu06[l_now2]= l_bmustr                                                                                             
                                                                                                                             
           IF tm.b ='Y' THEN                                                                                                         
              FOR g_cnt=1 TO 200                                                                                                     
                 LET l_bec05[g_cnt]=NULL                                                                                            
              END FOR                                                                                                                
              LET l_now = 1
              DECLARE r101_bec CURSOR FOR 
                SELECT bec04,bec05 FROM bec_file 
                 WHERE bec01=sr[i].bmp01 AND bec02=sr[i].bmp02 AND bec021=sr[i].bmp03
                   AND bec011=sr[i].bmp011 AND (bec03 IS NULL OR bec03>=sr[i].bmp04)
               ORDER BY bec04
              FOREACH r101_bec                                                                                                       
              INTO l_bec04,l_bec05_s                                                                                                 
                 IF SQLCA.sqlcode THEN                                                                                                
                    CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH                                                              
                 END IF        
                 LET l_becstr = l_becstr clipped,l_bec05_s                                                                            
                 LET l_no     = l_now MOD 2                                                                                           
                 IF l_no = 0 THEN                                                                                                     
                    LET l_number = l_now / 2                                                                                          
                    LET l_bec05[l_number] = l_becstr                                                                                  
                    LET l_becstr = ' '                                                                                                
                 END IF                                                                                                               
                 IF l_now > 200 THEN                                                                                                  
                    CALL cl_err('','9036',1)                                                                                         
                    CALL cl_used(g_prog,g_time,2) RETURNING g_time                                                     
                    EXIT PROGRAM                                                                                                     
                 END IF                                                                                                               
                 LET l_now=l_now+1                                                                                                    
              END FOREACH                                                                                                            
              IF l_now > 1 THEN                                                                                                      
                 LET l_no = (l_now -1 ) MOD 2                                                                                        
                 IF l_no != 0                                                                                                        
                 THEN LET l_now = (l_now / 2)                                                                                        
                      LET l_bec05[l_now] = l_becstr                                                                                  
                      LET l_becstr = ' '                                                                                             
                 ELSE LET l_now = l_now / 2                                                                                          
                 END IF                                                                                                              
              END IF                                                                                                                 
           END IF
           IF p_level>10 THEN LET p_level=10 END IF                                                                                  
           IF (sr[i].ima02  IS NULL OR sr[i].ima02 = ' ') AND                                                                             
              (sr[i].ima05  IS NULL OR sr[i].ima05 = ' ') AND                                                                             
              (sr[i].ima08  IS NULL OR sr[i].ima08 = ' ') AND                                                                             
              (sr[i].ima15  IS NULL OR sr[i].ima15 = ' ')                                                                                 
           THEN                                                                                                                      
              SELECT bmq02,bmq021,bmq05,bmq08,bmq15  #MOD-A40094 add bmq021
                INTO sr[i].ima02,sr[i].ima021,sr[i].ima05,sr[i].ima08,sr[i].ima15  #MOD-A40094 add ima021
               FROM bmq_file                                                                                                       
              WHERE bmq01 = sr[i].bmp03                                                                                               
           END IF                                                                                                                    
                                                                                                                                    
           #-->底數為'1'不列印                                                                                                       
           IF sr[i].bmp07 = 1 THEN LET sr[i].bmp07 = ' ' END IF                                                                            
                                                                                                                                    
           #列印多插件位置                                                                                                           
           IF NOT cl_null(l_bmu06[1]) AND l_now2 >= 1 THEN                                                                           
              FOR l_max_n = 1 TO l_now2
                 EXECUTE insert_prep2 USING sr[i].bmp01,sr[i].bmp02,sr[i].bmp03,
                                            sr[i].bmp011,l_bmu06[l_max_n]                                                                                              
              END FOR 
           END IF                                                                                                                    
                                                                                                                                    
           #-->列印說明                                                                                                              
           IF NOT cl_null(l_bec05[1]) AND l_now >=1 THEN                                                                                                         
              FOR g_cnt = 1 TO l_now 
                 EXECUTE insert_prep1 USING sr[i].bmp01,sr[i].bmp02,sr[i].bmp03,
                                            sr[i].bmp011,sr[i].bmp04,l_bec04,
                                            l_bec05[g_cnt]                                                                                                
              END FOR                                                                                                                
           END IF               
    
           EXECUTE insert_prep USING
              sr[i].order0,sr[i].order1,sr[i].bmo01_a,sr[i].bmo011_a,
              sr[i].bmo01, sr[i].bmo011,sr[i].bmp01,  sr[i].bmp011,
              sr[i].bmp02, sr[i].bmp03, sr[i].bmp04,  sr[i].bmp05,
              sr[i].bmp06, sr[i].bmp07, sr[i].bmp08,  sr[i].bmp10,
              sr[i].bmp13, sr[i].bmp16, sr[i].bmp28,  sr[i].ima02,
              sr[i].ima021,sr[i].ima05, sr[i].ima08,  sr[i].ima15,  #MOD-A40094 add ima021
              l_ima02,     l_ima021,    l_ima05,      l_ima08,
              l_ima63,     l_ima55,     l_total,      g_bmo06,
              l_ss,        g_no    #No:MOD-960109 add g_no                                                                                                           
           #No.FUN-850044  --END
                             
           #CHI-6C0026..............begin
           LET g_no=g_no + 1    #No.CHI-A40033 add
           LET g_cnt=0
           SELECT COUNT(*) INTO g_cnt FROM ima_file
                                     WHERE ima01=sr[i].bmp03
           IF g_cnt>0 THEN #P-BOM
              CALL r101_pbom(p_level,sr[i].bmp03,sr[i].bmo011,' ',l_total)
           ELSE            #E-MOB
              #--->若為主件
              IF sr[i].bmo01 IS NOT NULL THEN
                 CALL r101_ebom(p_level,sr[i].bmp03,sr[i].bmo011,' ',l_total) #FUN-560030
              END IF            
           END IF
           #CHI-6C0026..............end
        END FOR
        IF l_tot < arrno OR l_tot=0 THEN                 # BOM單身已讀完
            EXIT WHILE
        ELSE
            LET b_seq = sr[l_tot].bmp02
		LET l_times=l_times+1
        END IF
    END WHILE
END FUNCTION
 
#CHI-6C0026
FUNCTION r101_pbom(p_level,p_key,p_ver,p_acode,p_total) #FUN-560030
   DEFINE p_level   LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          p_total   LIKE bmp_file.bmp06,    #FUN-560231
          l_total   LIKE bmp_file.bmp06,    #FUN-560231
          l_tot     LIKE type_file.num10,   #No.FUN-680096 INTEGER
          l_times   LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          p_key	    LIKE bmo_file.bmo01,    #主件料件編號
          p_ver     LIKE bmo_file.bmo011,   #版本
          p_acode   LIKE bmo_file.bmo06,    #FUN-560030
          l_ac,i    LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          arrno	    LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          b_seq	    LIKE type_file.num10,   #No.FUN-680096 INTEGER
          l_chr	    LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          l_order2  LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
          sr DYNAMIC ARRAY OF RECORD           #每階存放資料
              order0  LIKE type_file.num5,  #階次 #CHI-6C0026
              order1  LIKE bmp_file.bmp02,  #No.FUN-680096 VARCHAR(40)
              bmo01_a  LIKE bmo_file.bmo01, #主件料件
              bmo011_a LIKE bmo_file.bmo011,#版本
              bmo01 LIKE bmo_file.bmo01,    #主件料件
              bmo011 LIKE bmo_file.bmo011,  #版本
              bmp01  LIKE bmp_file.bmp01,   #本階主件
              bmp011 LIKE bmp_file.bmp011,  #版本
              bmp02 LIKE bmp_file.bmp02,    #項次
              bmp03 LIKE bmp_file.bmp03,    #元件料號
              bmp04 LIKE bmp_file.bmp04,    #有效日期
              bmp05 LIKE bmp_file.bmp05,    #失效日期
              bmp06 LIKE bmp_file.bmp06,    #QPA/BASE
              bmp07 LIKE bmp_file.bmp07,    #BASE
              bmp08 LIKE bmp_file.bmp08,    #損耗率%
              bmp10 LIKE bmp_file.bmp10,    #發料單位
              bmp13 LIKE bmp_file.bmp13,    #插件位置
              bmp16 LIKE bmp_file.bmp16,    #替代特性
              bmp28 LIKE bmp_file.bmp28,    #FUN-560030
              ima02 LIKE ima_file.ima02,    #品名規格
              ima021 LIKE ima_file.ima021,    #品名規格     #MOD-B50164 add
              ima05 LIKE ima_file.ima05,    #版本
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15     #保稅否
          END RECORD,
          l_cmd	    STRING
    #No.FUN-850044  --BEGIN
     DEFINE                                                                                                                          
          l_ima02 LIKE ima_file.ima02,    #品名                                                                                     
          l_ima021 LIKE ima_file.ima021,  #規格                                                                                     
          l_ima05 LIKE ima_file.ima05,    #版本                                                                                     
          l_ima06 LIKE ima_file.ima06,    #版本                                                                                     
          l_ima08 LIKE ima_file.ima08,    #來源                                                                                     
          l_ima63 LIKE ima_file.ima63,    #發料單位                                                                                 
          l_ima55 LIKE ima_file.ima55,    #生產單位                                                                                 
          l_bmp03       LIKE bmp_file.bmp03,                                                                                        
          l_k,l_now,l_p LIKE type_file.num5,                                                                                        
          l_point       LIKE cre_file.cre08,                                                                                        
          l_bec04 LIKE bec_file.bec04,                                                                                              
          l_bec05 ARRAY[200] OF LIKE bec_file.bec05,                                                                                
          l_bmu06 ARRAY[200] OF LIKE type_file.chr20,                                                                               
          l_bec05_s    LIKE bec_file.bec05,                                                                                         
          l_bmu06_s    LIKE type_file.chr20,                                                                                        
          l_bmp02      LIKE bmp_file.bmp02,                                                                                         
          l_bmustr     LIKE type_file.chr20,                                                                                        
          l_becstr     LIKE type_file.chr20,                                                                                        
          l_no,l_number  LIKE type_file.num5,                                                                                       
          l_ute_flag   LIKE type_file.chr2,                                                                                         
          l_now2       LIKE type_file.num5,                                                                                         
          l_len,l_byte LIKE type_file.num5,                                                                                         
          l_ss         LIKE type_file.chr1000,
          l_max_n      LIKE type_file.num5      
   
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                                 
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",                                                            
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"    #NO.CHI-A40033 modify  #MOD-B50164 add ?                                                                             
                                                                                                                                    
     PREPARE insert_prep3 FROM g_sql                                                                                                 
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep3:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM                                                                           
     END IF                                                                                                                         
                                                                                                                                    
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?,?)"                                                                                          
                                                                                                                                    
     PREPARE insert_prep4 FROM g_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep4:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM                                                                          
     END IF                                                                                                                         
                                                                                                                                    
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?)"                                                                                               
                                                                                                                                    
     PREPARE insert_prep5 FROM g_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep5:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM                                                                          
     END IF                  
    #No.FUN-850044  --END
 
    IF p_level > 20 THEN
 	     CALL cl_err('','mfg2733',1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
       EXIT PROGRAM
    END IF
    LET p_level = p_level + 1
    LET l_times=1
    LET arrno = 600
    WHILE TRUE
        LET l_cmd=
            "SELECT distinct 0,'','','',bma01,'',bmb01,'',bmb02,bmb03,",
            " bmb04,bmb05,bmb06,bmb07,bmb08,bmb10,bmb13,bmb16,bmb29, ",
            "       ima02,ima021,ima05, ima08, ima15 ",                     #MOD-B50164 add ima021
            "  FROM bmb_file, OUTER ima_file, OUTER bma_file",
            " WHERE bmb01='", p_key,"' AND bmb02 >",b_seq,
            "   AND bmb_file.bmb03 = ima_file.ima01",
            "    AND (bmb04 <='",g_today,"'",
            "    OR bmb04 IS NULL) AND (bmb05 >'",g_today,"'",
            "    OR bmb05 IS NULL)",
            "   AND bmb_file.bmb03 = bma_file.bma01",
            "   AND bmb29 = '",p_acode,"'"
 
       #------------------No.MOD-750105 add
        #---->排列方式
        LET l_cmd=l_cmd CLIPPED, " ORDER BY "
    	CASE WHEN tm.s = '1'
                  LET l_cmd = l_cmd CLIPPED, ' bmb02'
                 WHEN tm.s = '2'
                  LET l_cmd = l_cmd CLIPPED, ' bmb03'
                 WHEN tm.s = '3'
                  LET l_cmd = l_cmd CLIPPED, ' bmb13'
        END CASE
       #------------------No.MOD-750105 end
        #---->排列方式
        PREPARE r101_pbom_pre FROM l_cmd
        IF SQLCA.sqlcode THEN CALL cl_err('P1:',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
           EXIT PROGRAM 
        END IF
        DECLARE r101_pcur CURSOR FOR r101_pbom_pre
        LET l_ac = 1
        FOREACH r101_pcur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
           LET l_ac = l_ac + 1		    	# 但BUFFER不宜太大
           IF l_ac > arrno THEN
              EXIT FOREACH
           END IF
        END FOREACH
        LET l_tot = l_ac - 1
        #CHI-6C0026.............begin
        #LET g_str=''
        #IF p_level >1 THEN
        #  FOR i = 2 TO p_level
        #      LET g_str=g_str,' '
        #  END FOR
        #END IF
        #CHI-6C0026.............end
        FOR i = 1 TO l_tot    	        	# 讀BUFFER傳給REPORT
           IF sr[i].bmp07 IS NULL OR sr[i].bmp07 = ' ' OR sr[i].bmp07 = 0 THEN 
              LET sr[i].bmp07 = 1
           END IF
           LET l_total=p_total*sr[i].bmp06/sr[i].bmp07
           CASE tm.s
             WHEN '1' LET sr[i].order1=sr[i].bmp02 USING '#####'
             WHEN '2' LET sr[i].order1=sr[i].bmp03
             WHEN '3' LET sr[i].order1=sr[i].bmp13
             OTHERWISE LET sr[i].order1 = ' '
           END CASE
           LET sr[i].bmo01_a  = g_bmo01_a
           LET sr[i].bmo011_a = g_bmo011_a
           LET sr[i].order0 = p_level #CHI-6C0026
           
           #No.FUN-850044  --BEGIN
           #OUTPUT TO REPORT r101_rep(p_level,i,l_total,sr[i].*,g_bmo06) #FUN-560030
            SELECT ima02,ima021,ima05,ima08,ima63,ima55                                                                              
             INTO l_ima02,l_ima021,l_ima05,l_ima08,l_ima63,l_ima55                                                                  
            FROM ima_file                                                                                                           
           WHERE ima01 = sr[i].bmo01_a                                                                                              
           IF SQLCA.sqlcode THEN                                                                                                    
              SELECT bmq02,bmq021,bmq05,bmq08,bmq63,bmq55                                                                           
                INTO l_ima02,l_ima021,l_ima05,l_ima08,l_ima63,l_ima55                                                               
               FROM bmq_file                                                                                                        
              WHERE bmq01 = sr[i].bmo01_a                                                                                           
              IF SQLCA.sqlcode THEN                                                                                                 
                 LET l_ima02='' LET l_ima05='' LET l_ima08=''                                                                       
                 LET l_ima63='' LET l_ima55='' LET l_ima021=''                                                                      
              END IF                                                                                                                
           END IF                                                                                                                   
           LET l_ute_flag = 'US'                                                                                                    
           IF tm.loc='1' THEN                                                                                                       
              LET g_str=''                                                                                                          
              FOR l_p = 1 TO p_level -1                                                                                             
                 LET g_str = g_str,' '                                                                                              
              END FOR                                                                                                               
              LET l_ss=g_str,sr[i].bmp02 USING '<<<<'                                                                               
           ELSE                                                                                                                     
              LET l_point = ''                                                                                                      
              IF p_level > 1 THEN  
                  FOR l_p = 1 TO p_level - 1                                                                                         
                    LET l_point = l_point clipped,'.'                                                                               
                 END FOR                                                                                                            
              END IF                                                                                                                
              LET l_ss=l_point,g_str,sr[i].bmp03 CLIPPED                                                                            
           END IF                                                                                                                   
           #---->改變替代特性的表示方式                                                                                             
           IF sr[i].bmp16 MATCHES '[12]' THEN                                                                                       
              LET g_cnt=sr[i].bmp16 USING '&'                                                                                       
              LET sr[i].bmp16=l_ute_flag[g_cnt,g_cnt]                                                                               
           ELSE                                                                                                                     
              LET sr[i].bmp16=' '                                                                                                   
           END IF                                                                                                                   
           #-->列印多插件位置                                                                                                       
           FOR g_cnt = 1 TO 200                                                                                                     
              LET l_bmu06[g_cnt]=NULL                                                                                               
           END FOR                                                                                                                  
           LET l_now2 = 1                                                                                                           
           LET l_len  = 20                                                                                                          
           LET l_bmustr =''                                                                                                         
           DECLARE r100_bmu06_1 CURSOR FOR                                                                                            
            SELECT bmu06 FROM bmu_file                                                                                              
             WHERE bmu01=sr[i].bmp01 AND bmu02=sr[i].bmp02                                                                          
              AND bmu03=sr[i].bmp03 AND bmu011=sr[i].bmp011  
           FOREACH r100_bmu06_1 INTO l_bmu06_s                                                                                        
              IF STATUS THEN                                                                                                        
                 CALL cl_err('Foreach:',STATUS,0) EXIT FOREACH                                                                      
              END IF                                                                                                                
              IF l_now2 > 200 THEN CALL cl_err('','9036',1)                                                                         
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time                                                                     
                 EXIT PROGRAM                                                                                                       
              END IF                                                                                                                
              LET l_byte = length(l_bmu06_s) + 1                                                                                    
              IF l_len >=l_byte THEN                                                                                                
                 LET l_bmustr = l_bmustr clipped,l_bmu06_s clipped,','                                                              
                 LET l_len = l_len - l_byte                                                                                         
              ELSE                                                                                                                  
                 LET l_bmu06[l_now2] = l_bmustr                                                                                     
                 LET l_now2 = l_now2 + 1                                                                                            
                 LET l_len = 20                                                                                                     
                 LET l_len = l_len - l_byte                                                                                         
                 LET l_bmustr = ''                                                                                                  
                 LET l_bmustr = l_bmustr clipped,l_bmu06_s clipped,','                                                              
              END IF                                                                                                                
           END FOREACH                                                                                                              
           LET l_bmu06[l_now2]= l_bmustr                                                                                            
                                                                                                                                    
           IF tm.b ='Y' THEN
              FOR g_cnt=1 TO 200                                                                                                    
                 LET l_bec05[g_cnt]=NULL                                                                                            
              END FOR                                                                                                               
              LET l_now = 1
              DECLARE r101_bec_1 CURSOR FOR                                                                                           
                SELECT bec04,bec05 FROM bec_file                                                                                    
                 WHERE bec01=sr[i].bmp01 AND bec02=sr[i].bmp02 AND bec021=sr[i].bmp03                                               
                   AND bec011=sr[i].bmp011 AND (bec03 IS NULL OR bec03>=sr[i].bmp04)                                                
               ORDER BY bec04   
              FOREACH r101_bec_1                                                                                                      
              INTO l_bec04,l_bec05_s                                                                                                
                 IF SQLCA.sqlcode THEN                                                                                              
                    CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH                                                            
                 END IF                                                                                                             
                 LET l_becstr = l_becstr clipped,l_bec05_s                                                                          
                 LET l_no     = l_now MOD 2                                                                                         
                 IF l_no = 0 THEN                                                                                                   
                    LET l_number = l_now / 2                                                                                        
                    LET l_bec05[l_number] = l_becstr                                                                                
                    LET l_becstr = ' '                                                                                              
                 END IF                                                                                                             
                 IF l_now > 200 THEN                                                                                                
                    CALL cl_err('','9036',1)                                                                                        
                    CALL cl_used(g_prog,g_time,2) RETURNING g_time                                                                  
                    EXIT PROGRAM                                                                                                    
                 END IF                                                                                                             
                 LET l_now=l_now+1                                                                                                  
              END FOREACH 
               IF l_now > 1 THEN                                                                                                     
                 LET l_no = (l_now -1 ) MOD 2                                                                                       
                 IF l_no != 0                                                                                                       
                 THEN LET l_now = (l_now / 2)                                                                                       
                      LET l_bec05[l_now] = l_becstr                                                                                 
                      LET l_becstr = ' '                                                                                            
                 ELSE LET l_now = l_now / 2                                                                                         
                 END IF                                                                                                             
              END IF                                                                                                                
           END IF                                                                                                                   
           IF p_level>10 THEN LET p_level=10 END IF                                                                                 
           IF (sr[i].ima02  IS NULL OR sr[i].ima02 = ' ') AND                                                                       
              (sr[i].ima05  IS NULL OR sr[i].ima05 = ' ') AND                                                                       
              (sr[i].ima08  IS NULL OR sr[i].ima08 = ' ') AND                                                                       
              (sr[i].ima15  IS NULL OR sr[i].ima15 = ' ')                                                                           
           THEN                                                                                                                     
              SELECT bmq02,bmq021,bmq05,bmq08,bmq15                                    #MOD-B50164 add bmq021                                                                                    
                INTO sr[i].ima02,sr[i].ima021,sr[i].ima05,sr[i].ima08,sr[i].ima15      #MOD-B50164 add ima021                                                          
               FROM bmq_file                                                                                                        
              WHERE bmq01 = sr[i].bmp03                                                                                             
           END IF                                                                                                                   
                                                                                                                                    
           #-->底數為'1'不列印                                                                                                      
           IF sr[i].bmp07 = 1 THEN LET sr[i].bmp07 = ' ' END IF                             
                                                                                                                                        
           #列印多插件位置                                                                                                          
           IF NOT cl_null(l_bmu06[1]) AND l_now2 >= 1 THEN                                                                          
              FOR l_max_n = 1 TO l_now2                                                                                             
                 EXECUTE insert_prep5 USING sr[i].bmp01,sr[i].bmp02,sr[i].bmp03,                                                    
                                            sr[i].bmp011,l_bmu06[l_max_n]                                                     
              END FOR                                                                                                               
           END IF                                                                                                                   
                                                                                                                                    
           #-->列印說明                                                                                                             
           IF NOT cl_null(l_bec05[1]) AND l_now >=1 THEN                                                                            
              FOR g_cnt = 1 TO l_now                                                                                                
                 EXECUTE insert_prep4 USING sr[i].bmp01,sr[i].bmp02,sr[i].bmp03,                                                    
                                            sr[i].bmp011,sr[i].bmp04,l_bec04,                                                       
                                            l_bec05[g_cnt]                                                                    
              END FOR                                                                                                               
           END IF                                                                                                                   
                                                                                                                                    
           EXECUTE insert_prep3 USING sr[i].order0,sr[i].order1,sr[i].bmo01_a,sr[i].bmo011_a,                                        
                                     sr[i].bmo01, sr[i].bmo011,sr[i].bmp01,  sr[i].bmp011,                                          
                                     sr[i].bmp02, sr[i].bmp03, sr[i].bmp04,  sr[i].bmp05,                                           
                                     sr[i].bmp06, sr[i].bmp07, sr[i].bmp08,  sr[i].bmp10,                                           
                                     sr[i].bmp13, sr[i].bmp16, sr[i].bmp28,  sr[i].ima02,                                           
                                     sr[i].ima021,                                          #MOD-B50164 add
                                     sr[i].ima05, sr[i].ima08, sr[i].ima15,  l_ima02,    
                                     l_ima021,    l_ima05,     l_ima08,      l_ima63,                                               
                                     l_ima55,     l_total,     g_bmo06,      l_ss,g_no                 #No.CHI-A40033 add g_no   
           #No.FUN-850044  --END
   
           #CHI-6C0026..............begin
           LET g_no = g_no + 1  #No.CHI-A40033 add
           LET g_cnt=0
           SELECT COUNT(*) INTO g_cnt FROM ima_file
                                     WHERE ima01=sr[i].bmp03
           IF g_cnt>0 THEN #P-BOM
              CALL r101_pbom(p_level,sr[i].bmp03,sr[i].bmo011,' ',l_total)
           ELSE            #E-MOB
              #--->若為主件
              IF sr[i].bmo01 IS NOT NULL THEN
                 CALL r101_ebom(p_level,sr[i].bmp03,sr[i].bmo011,' ',l_total) #FUN-560030
              END IF            
           END IF
           #CHI-6C0026..............end
        END FOR
        IF l_tot < arrno OR l_tot=0 THEN                 # BOM單身已讀完
           EXIT WHILE
        ELSE
           LET b_seq = sr[l_tot].bmp02
		       LET l_times=l_times+1
        END IF
    END WHILE
END FUNCTION
 
#No.FUN-850044  --BEGIN
{
FUNCTION r101_cur()
  DEFINE  l_cmd    LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(1000)
 
#---->產品結構說明資料
     LET l_cmd  = " SELECT bec04,bec05 FROM bec_file ",
                  " WHERE bec01=?  AND bec02= ? AND ",
                  " bec021=? AND bec011=? AND ",
                  " (bec03 IS NULL OR bec03 >= ?) ",
                  " ORDER BY 1"
     PREPARE r101_prebec    FROM l_cmd
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM           
     END IF
     DECLARE r101_bec CURSOR FOR r101_prebec
END FUNCTION
}
#No.FUN-850044  --END
 
#No.FUN-850044  --BEGIN
{
REPORT r101_rep(p_level,p_i,p_total,sr,p_acode)
   DEFINE l_last_sw	LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
          p_level,p_i	LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          p_total       LIKE bmp_file.bmp06,   #FUN-560231
          p_acode       LIKE bmo_file.bmo06,   #FUN-560030
          sr  RECORD
              order0  LIKE type_file.num5,  #階次 #CHI-6C0026
              order1 LIKE bmp_file.bmp02,    #No.FUN-680096 VARCHAR(40)  
              bmo01_a  LIKE bmo_file.bmo01,  #主件料件
              bmo011_a LIKE bmo_file.bmo011, #版本
              bmo01  LIKE bmo_file.bmo01,    #主件料件
              bmo011 LIKE bmo_file.bmo011,   #版本
              bmp01  LIKE bmp_file.bmp01,    #本階主件
              bmp011 LIKE bmp_file.bmp011,   #版本
              bmp02 LIKE bmp_file.bmp02,     #項次
              bmp03 LIKE bmp_file.bmp03,     #元件料號
              bmp04 LIKE bmp_file.bmp04,     #有效日期
              bmp05 LIKE bmp_file.bmp05,     #失效日期
              bmp06 LIKE bmp_file.bmp06,     #QPA/BASE
              bmp07 LIKE bmp_file.bmp07,     #BASE
              bmp08 LIKE bmp_file.bmp08,     #損耗率%
              bmp10 LIKE bmp_file.bmp10,     #發料單位
              bmp13 LIKE bmp_file.bmp13,     #插件位置
              bmp16 LIKE bmp_file.bmp16,     #替代特性
              bmp28 LIKE bmp_file.bmp28,    #FUN-560030
              ima02 LIKE ima_file.ima02,     #品名規格
              ima05 LIKE ima_file.ima05,     #版本
              ima08 LIKE ima_file.ima08,     #來源
              ima15 LIKE ima_file.ima15      #保稅否
          END RECORD,
          l_ima02 LIKE ima_file.ima02,    #品名
          l_ima021 LIKE ima_file.ima021,  #規格      #No.FUN-5A0061 add
          l_ima05 LIKE ima_file.ima05,    #版本
          l_ima06 LIKE ima_file.ima06,    #版本
          l_ima08 LIKE ima_file.ima08,    #來源
          l_ima63 LIKE ima_file.ima63,    #發料單位
          l_ima55 LIKE ima_file.ima55,    #生產單位
          l_bmp03       LIKE bmp_file.bmp03,         #No.FUN-680096 VARCHAR(33)
          l_k,l_now,l_p LIKE type_file.num5,         #No.FUN-680096 SMALLINT
          l_point       LIKE cre_file.cre08,         #No.FUN-680096 VARCHAR(10)
          l_bec04 LIKE bec_file.bec04,
          l_bec05 ARRAY[200] OF LIKE bec_file.bec05, #No.FUN-680096 VARCHAR(20)
          l_bmu06 ARRAY[200] OF LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
          l_bec05_s    LIKE bec_file.bec05,
          l_bmu06_s    LIKE type_file.chr20,         #No.FUN-680096 VARCHAR(20)
          l_bmp02      LIKE bmp_file.bmp02, 
         #---------------No.MOD-7C0097 modify
          l_bmustr     LIKE type_file.chr20,          #No.FUN-680096 VARCHAR(20)
          l_becstr     LIKE type_file.chr20,          #No.FUN-680096 VARCHAR(20)
         #---------------No.MOD-7C0097 end
          l_no,l_number  LIKE type_file.num5,        #No.FUN-680096 SMALLINT
          l_ute_flag   LIKE type_file.chr2,            #No.FUN-680096 VARCHAR(2) 
          l_now2       LIKE type_file.num5,          #No.FUN-680096 SMALLINT
          l_len,l_byte LIKE type_file.num5,          #No.FUN-680096 SMALLINT
          l_ss         LIKE type_file.chr1000,       #No.FUN-590110 #No.FUN-680096 VARCHAR(30)
          l_chang      LIKE type_file.chr1,          #No.MOD-770146 add
          l_max_n      LIKE type_file.num5           #No.FUN-680096 SMALLINT
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  #ORDER BY sr.bmo01_a,sr.bmo011_a,p_acode,sr.order1 #FUN-560030 #CHI-6C0026
  #-----------No.MOD-750105 modify
  #ORDER BY sr.bmo01_a,p_acode,sr.order0,sr.order1 #FUN-560030 #CHI-6C0026
   ORDER EXTERNAL BY sr.bmo01_a,p_acode,sr.order0,sr.order1 #FUN-560030 #CHI-6C0026
  #-----------No.MOD-750105 end
  FORMAT
   PAGE HEADER
#No.FUN-590110--start
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2+1),g_company CLIPPED
 
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
 
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#No.FUN-590110--end
      SELECT ima02,ima021,ima05,ima08,ima63,ima55        #No.FUN-5A0061 add ima021
        INTO l_ima02,l_ima021,l_ima05,l_ima08,l_ima63,l_ima55    #No.FUN-5A0061 add ima021
        FROM ima_file
       WHERE ima01 = sr.bmo01_a
      IF SQLCA.sqlcode THEN
          SELECT bmq02,bmq05,bmq08,bmq63,bmq55
            INTO l_ima02,l_ima05,l_ima08,l_ima63,l_ima55
            FROM bmq_file
           WHERE bmq01 = sr.bmo01_a
          IF SQLCA.sqlcode THEN
             LET l_ima02='' LET l_ima05='' LET l_ima08=''
             LET l_ima63='' LET l_ima55=''
          END IF
      END IF
#MOD-6B0060-begin-add
##No.FUN-590110--start
#      IF tm.loc='1' THEN
#         LET l_ss=g_str,sr.bmp02 USING '<<<<'
#      ELSE
#         LET l_point = ''
#         IF p_level > 1 THEN
#            FOR l_p = 1 TO p_level - 1
#                LET l_point = l_point clipped,'.'
#            END FOR
#         END IF
#         #LET l_ss=l_point,g_str,sr.bmp03[1,20]  #FUN-5B0013 mark
#         LET l_ss=l_point,g_str,sr.bmp03 CLIPPED   #FUN-5B0013 add
#      END IF
##No.FUN-590110--end
#MOD-6B0060-end-add
      PRINT g_dash[1,g_len]
 
#-------No.TQC-5B0107 modify #&051112
      PRINT COLUMN  1,g_x[15] CLIPPED,sr.bmo01_a CLIPPED,
            COLUMN 65,g_x[21] CLIPPED,l_ima05 CLIPPED,
            COLUMN 77,g_x[22] CLIPPED,l_ima08 CLIPPED,
            COLUMN 84,g_x[16] CLIPPED,l_ima63 CLIPPED,
            COLUMN 98,g_x[18] CLIPPED,l_ima55
      PRINT COLUMN  1,g_x[17] CLIPPED, l_ima02 CLIPPED,
            COLUMN 84,g_x[30] CLIPPED, sr.bmo011_a CLIPPED,
            COLUMN 98,g_x[20] CLIPPED,tm.a USING'<<<<<'
      PRINT COLUMN  1,g_x[10] CLIPPED,l_ima021 CLIPPED      #No.FUN-5A0061 add
      PRINT COLUMN  1,g_x[32] CLIPPED,p_acode #FUN-560030
#------No.TQC-5B0107 end
 
      PRINT ' '
#No.FUN-590110--start
#     PRINT column 35,g_x[11] clipped,column 61,g_x[12] clipped
#No.MOD-590022 --start--
      PRINTX name=H1 g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
                     g_x[38],g_x[39],g_x[40],g_x[41],g_x[42]
      PRINTX name=H2 g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],
                     g_x[48]
      PRINT g_dash1
#No.MOD-590022 --end--
#No.FUN-590110--end
      LET l_ute_flag = 'US'
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF p_acode #FUN-560030
      SKIP TO TOP OF PAGE
 
    ON EVERY ROW
#MOD-6B0060-begin-add
      IF tm.loc='1' THEN
         #CHI-6C0026............begin
         LET g_str=''
         FOR l_p = 1 TO p_level -1
             LET g_str = g_str,' '
         END FOR
         #CHI-6C0026............end
         LET l_ss=g_str,sr.bmp02 USING '<<<<'
      ELSE
         LET l_point = ''
         IF p_level > 1 THEN
            FOR l_p = 1 TO p_level - 1
                LET l_point = l_point clipped,'.'
            END FOR
         END IF
         #LET l_ss=l_point,g_str,sr.bmp03[1,20]  #FUN-5B0013 mark
         LET l_ss=l_point,g_str,sr.bmp03 CLIPPED   #FUN-5B0013 add
      END IF
#MOD-6B0060-end-add
          #---->改變替代特性的表示方式
          IF sr.bmp16 MATCHES '[12]' THEN
              LET g_cnt=sr.bmp16 USING '&'
              LET sr.bmp16=l_ute_flag[g_cnt,g_cnt]
          ELSE
              LET sr.bmp16=' '
          END IF
          #-->列印多插件位置      (add in 99/04/07 NO:3078)
          FOR g_cnt = 1 TO 200
              LET l_bmu06[g_cnt]=NULL
          END FOR
          LET l_now2 = 1
          LET l_len  = 20
          LET l_bmustr =''
          DECLARE r100_bmu06 CURSOR FOR
           SELECT bmu06 FROM bmu_file
            WHERE bmu01=sr.bmp01 AND bmu02=sr.bmp02
              AND bmu03=sr.bmp03 AND bmu011=sr.bmp011
          FOREACH r100_bmu06 INTO l_bmu06_s
               IF STATUS THEN
                  CALL cl_err('Foreach:',STATUS,0) EXIT FOREACH
               END IF
               IF l_now2 > 200 THEN CALL cl_err('','9036',1) 
                  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
                  EXIT PROGRAM 
               END IF
               LET l_byte = length(l_bmu06_s) + 1
               IF l_len >=l_byte THEN
                  LET l_bmustr = l_bmustr clipped,l_bmu06_s clipped,','
                  LET l_len = l_len - l_byte
               ELSE
                  LET l_bmu06[l_now2] = l_bmustr
                  LET l_now2 = l_now2 + 1
                  LET l_len = 20
                  LET l_len = l_len - l_byte
                  LET l_bmustr = ''
                  LET l_bmustr = l_bmustr clipped,l_bmu06_s clipped,','
               END IF
          END FOREACH
          LET l_bmu06[l_now2]= l_bmustr
          ##---
          IF tm.b ='Y' THEN
             FOR g_cnt=1 TO 200
                 LET l_bec05[g_cnt]=NULL
             END FOR
             LET l_now = 1
             FOREACH r101_bec
             USING sr.bmp01,sr.bmp02,sr.bmp03,sr.bmp011,sr.bmp04
             INTO l_bec04,l_bec05_s
               IF SQLCA.sqlcode THEN
                  CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH
               END IF
               LET l_becstr = l_becstr clipped,l_bec05_s
               LET l_no     = l_now MOD 2
               IF l_no = 0 THEN
                  LET l_number = l_now / 2
                  LET l_bec05[l_number] = l_becstr
                  LET l_becstr = ' '
               END IF
               IF l_now > 200 THEN
                   CALL cl_err('','9036',1)
                   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
                   EXIT PROGRAM
               END IF
               LET l_now=l_now+1
             END FOREACH
             IF l_now > 1 THEN
                LET l_no = (l_now -1 ) MOD 2
                IF l_no != 0
                THEN LET l_now = (l_now / 2)
                     LET l_bec05[l_now] = l_becstr
                     LET l_becstr = ' '
                ELSE LET l_now = l_now / 2
                END IF
             END IF
          END IF
          IF p_level>10 THEN LET p_level=10 END IF
          NEED 2 LINE
          #-->資料列印(項次若非以項次排序則只以順序號+1)
          IF tm.s != '1' THEN
             LET l_bmp02 = l_bmp02 + 1
             LET sr.bmp02 = l_bmp02
          END IF
          IF  (sr.ima02  IS NULL OR sr.ima02 = ' ') AND
              (sr.ima05  IS NULL OR sr.ima05 = ' ') AND
              (sr.ima08  IS NULL OR sr.ima08 = ' ') AND
              (sr.ima15  IS NULL OR sr.ima15 = ' ')
          THEN
              SELECT bmq02,bmq05,bmq08,bmq15
                INTO sr.ima02,sr.ima05,sr.ima08,sr.ima15
                FROM bmq_file
               WHERE bmq01 = sr.bmp03
          END IF
#No.FUN-590110--start
          IF tm.loc='1' THEN
             PRINTX name=D1
                   COLUMN g_c[33],l_ss,
                   #COLUMN g_c[34],sr.bmp03[1,20] CLIPPED; #FUN-5B0013 mark
                   COLUMN g_c[34],sr.bmp03 CLIPPED; #FUN-5B0013 add
          ELSE
             PRINTX name=D1
                   COLUMN g_c[33],l_ss,
                   COLUMN g_c[34],sr.bmp02 using '<<<';
          END IF
 
 
          PRINTX name=D1
                COLUMN g_c[35],sr.ima08 CLIPPED,
                COLUMN g_c[36],sr.bmp10 CLIPPED,
                COLUMN g_c[37],sr.ima15 CLIPPED,
                COLUMN g_c[38],p_total USING '#####&.&&&&',
                COLUMN g_c[39],sr.bmp04 CLIPPED,
                COLUMN g_c[40],sr.bmp08 USING '#####&.&&&';
          #-->底數為'1'不列印
          IF sr.bmp07 = 1 THEN LET sr.bmp07 = ' ' END IF
          LET l_chang = 'N'      #No.MOD-770146 add
 
          #列印多插件位置
          IF NOT cl_null(l_bmu06[1]) AND l_now2 >= 1 THEN
             FOR l_max_n = 1 TO l_now2
                #PRINTX name=D1 COLUMN g_c[41],l_bmu06[l_max_n][1,20];#MOD-710102 By Mandy mark 導致產生Out of memory error
                 PRINTX name=D1 COLUMN g_c[41],l_bmu06[l_max_n][1,20] #MOD-710102 By Mandy add
                 LET l_chang = 'Y'      #No.MOD-770146 add
             END FOR
          END IF
 
          #-->列印說明
          IF l_now >=1 THEN
             FOR g_cnt = 1 TO l_now
                 PRINTX name=D1 COLUMN g_c[42],l_bec05[g_cnt][1,20]
                 LET l_chang = 'Y'      #No.MOD-770146 add
             END FOR
          END IF
         #------------No.MOD-770146 add
          IF l_chang = 'N' THEN
             PRINTX name=D1 ' '    
          END IF
         #------------No.MOD-770146  end
          IF tm.loc='1' THEN
             #PRINTX name=D2 column g_c[44],sr.ima02[1,30] CLIPPED, #FUN-5B0013 mark
             PRINTX name=D2 column g_c[44],sr.ima02 CLIPPED, #FUN-5B0013 add
                    column g_c[48],sr.bmp07 USING '#####&.&&&&'
          ELSE
             #PRINTX name=D2 column g_c[43],sr.ima02[1,30] CLIPPED, #FUN-5B0013 mark
             PRINTX name=D2 column g_c[43],sr.ima02 CLIPPED, #FUN-5B0013 add
                    column g_c[48],sr.bmp07 USING '#####&.&&&&'
          END IF
#No.FUN-590110--end
 
   ON LAST ROW
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      PRINT ''
      PRINT g_dash[1,g_len]
      IF g_pageno = 0 OR l_last_sw = 'y'
         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      END IF
END REPORT
}
#No.FUN-850044  --END
#Patch....NO.TQC-610035 <> #
#No.FUN-870144
