# Prog. Version..: '5.30.06-13.03.19(00010)'     #
#
# Pattern name...: axmr170.4gl 
# Desc/riptions..: 銷售預測與實際比較表
# Date & Author..: 00/08/24 By Mandy
# Modify.........: No.FUN-4B0043 04/11/16 By Nicola 加入開窗功能
# Modify.........: No.FUN-610020 06/01/17 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-660167 06/06/23 By douzh cl_err --> cl_err3
# Modify.........: No.FUN-670106 06/08/2424 By bnlent voucher型報表轉template1
# Modify.........: No.FUN-680137 06/09/05 By flowld 欄位型態定義,改為LIKE
#
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: No.MOD-840564 08/04/24 By Sunyanchun 實際接單的統計數量由以訂單單頭的日期
                                                       #為範圍抓取資料改成以訂單的預計交期範圍抓取資料
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: NO.MOD-860078 08/06/06 BY Yiting ON IDLE 處理
# Modify.........: NO.FUN-830054 08/07/28 By zhaijie老報表修改為CR
# Modify.........: NO.CHI-910057 09/02/05 By xiaofeizhu axmr170已轉CR，不需使用zaa 
# Modify.........: No.MOD-950168 09/07/07 By Smapmin 修改合計沒有印出來/資料重複等問題

# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A50050 10/05/10 By Smapmin 時距代號只有在提列方式是時距時才需輸入.
# Modify.........: No:TQC-A50044 10/05/14 By Carrier MOD-990214追单
# Modify.........: No:MOD-AA0071 10/11/09 By sabrina 1.實際接單量與實際出貨量會倍增
#                                                    2.實際接單量未扣除合約訂單已轉實際訂單量
#                                                    3.實際接單量應用月訂交貨日作為歸屬基準
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改	
# Modify.........: No:MOD-B80347 11/09/03 By johung 修正業務人員相同時報表數量錯誤問題
# Modify.........: No:MOD-D20148 13/03/08 By Elise MOD-AA0071導致只會有最後一個料傳到sub report3
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD			# Print condition RECORD
             #    wc   VARCHAR(500),	# Where condition
                 wc  	STRING,    #TQC-630166	# Where condition
                 bdate  LIKE type_file.dat,         # No.FUN-680137 DATE           #計劃日期範圍-起始
                 edate  LIKE type_file.dat,         # No.FUN-680137 DATE           #計劃日期範圍-終止
                 a      LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)        #列印內容(1.計劃數量 2.確認數量 3.金額)
                 b      LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)  #提列方式(1:依時距:[b_co] 2.天 3.週 4.旬 5.月)
                 b_co   LIKE opc_file.opc10,    #時距
                 more	LIKE type_file.chr1         # No.FUN-680137 VARCHAR(1) 		# Input more condition(Y/N)
              END RECORD,
         g_dash1_1        LIKE type_file.chr1000    # No.FUN-680137  VARCHAR(400)                           
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
#NO.FUN-830054--------START------
DEFINE   g_sql          STRING
DEFINE   g_str          STRING
DEFINE   l_table        STRING
DEFINE   l_table1       STRING
DEFINE   l_table2       STRING
DEFINE   l_table3       STRING  
DEFINE   l_table4       STRING  
#NO.FUN-830054--------END-------
DEFINE   g_title        LIKE type_file.chr12   #TQC-A50044 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
#NO.FUN-830054--------START------
   LET g_sql = "opc01.opc_file.opc01,",
               "opc02.opc_file.opc02,",
               "opc03.opc_file.opc03,",
               "opc04.opc_file.opc04,",
               "opc05.opc_file.opc05,",
               "opc06.opc_file.opc06,",
               "l_ima02.ima_file.ima02"
               #"l_ogb_sum.ade_file.ade05,",   #MOD-950168
               #"l_oeb_sum.ade_file.ade05,",   #MOD-950168
               #"l_num.img_file.img30"         #MOD-950168
   LET l_table = cl_prt_temptable('axmr170',g_sql) CLIPPED
   IF  l_table =-1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "gx31.zaa_file.zaa08,",
               "gx32.zaa_file.zaa08,",
               "gx33.zaa_file.zaa08,",
               "gx34.zaa_file.zaa08,",
               "gx35.zaa_file.zaa08,",
               "gx36.zaa_file.zaa08,",
               "gx37.zaa_file.zaa08,",
               "gx38.zaa_file.zaa08,",
               "gx39.zaa_file.zaa08,",
               "gx40.zaa_file.zaa08,",
               "gx41.zaa_file.zaa08,",
               "gx42.zaa_file.zaa08,",
               "gx43.zaa_file.zaa08,",
               "gx44.zaa_file.zaa08,",
               "gx45.zaa_file.zaa08,",
               "gx46.zaa_file.zaa08,",
               "gx47.zaa_file.zaa08,",
               "gx48.zaa_file.zaa08,",
               "gx49.zaa_file.zaa08,",
               "gx50.zaa_file.zaa08,",
               "gx51.zaa_file.zaa08,",
               "gx52.zaa_file.zaa08,",
               "gx53.zaa_file.zaa08,",
               "gx54.zaa_file.zaa08,",
               "gx55.zaa_file.zaa08,",
               "gx56.zaa_file.zaa08,",
               "gx57.zaa_file.zaa08,",
               "gx58.zaa_file.zaa08,",
               "opc01.opc_file.opc01"   #MOD-950168
   LET l_table1 = cl_prt_temptable('axmr1701',g_sql) CLIPPED
   IF  l_table1 =-1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "opc04.opc_file.opc04,",
               "opc03.opc_file.opc03,",   #MOD-950168
               "opc01.opc_file.opc01,",   #MOD-950168
               "l_n.type_file.num5,",
               "l_sum.img_file.img30,",                                         
#              "l_title.type_file.chr12"   #TQC-A50044   #MOD-B80347 mark
               "l_title.type_file.chr12,", #MOD-B80347
               "opc02.opc_file.opc02,",    #MOD-B80347
               "opc05.opc_file.opc05"      #MOD-B80347
   LET l_table2 = cl_prt_temptable('axmr1702',g_sql) CLIPPED
   IF  l_table2 =-1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "gc_32.ade_file.ade05,",
               "gc_33.ade_file.ade05,",
               "gc_34.ade_file.ade05,",
               "gc_35.ade_file.ade05,",
               "gc_36.ade_file.ade05,",
               "gc_37.ade_file.ade05,",
               "gc_38.ade_file.ade05,",
               "gc_39.ade_file.ade05,",
               "gc_40.ade_file.ade05,",
               "gc_41.ade_file.ade05,",
               "gc_42.ade_file.ade05,",
               "gc_43.ade_file.ade05,",
               "opc01.opc_file.opc01,",   #MOD-950168
               "opc04.opc_file.opc04,",   #MOD-950168
               "opc05.opc_file.opc05,",   #MOD-950168
               "l_ogb_sum.ade_file.ade05,",   #MOD-950168                       
               "l_title.type_file.chr12"      #TQC-A50044
   LET l_table3 = cl_prt_temptable('axmr1703',g_sql) CLIPPED
   IF  l_table3 =-1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "gc32.ade_file.ade05,",
               "gc33.ade_file.ade05,",
               "gc34.ade_file.ade05,",
               "gc35.ade_file.ade05,",
               "gc36.ade_file.ade05,",
               "gc37.ade_file.ade05,",
               "gc38.ade_file.ade05,",
               "gc39.ade_file.ade05,",
               "gc40.ade_file.ade05,",
               "gc41.ade_file.ade05,",
               "gc42.ade_file.ade05,",
               "gc43.ade_file.ade05,",
               "opc01.opc_file.opc01,",   #MOD-950168
               "opc04.opc_file.opc04,",   #MOD-950168
               "opc05.opc_file.opc05,",   #MOD-950168
               "l_oeb_sum.ade_file.ade05,",   #MOD-950168                       
               "l_title.type_file.chr12"   #TQC-A50044
   LET l_table4 = cl_prt_temptable('axmr1704',g_sql) CLIPPED
   IF  l_table4 =-1 THEN EXIT PROGRAM END IF
#NO.FUN-830054--------END-------
    LET g_pdate  = ARG_VAL(1)	             # Get arguments from command line
    LET g_towhom = ARG_VAL(2)
    LET g_rlang  = ARG_VAL(3)
    LET g_bgjob  = ARG_VAL(4)
    LET g_prtway = ARG_VAL(5)
    LET g_copies = ARG_VAL(6)
    LET tm.wc    = ARG_VAL(7)
    LET tm.bdate = ARG_VAL(8)
    LET tm.edate = ARG_VAL(9)
    LET tm.a     = ARG_VAL(10)
    LET tm.b     = ARG_VAL(11)
    LET tm.b_co  = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   #No.FUN-570264 ---end---
 
    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN	# If background job sw is off
        CALL r170_tm(0,0)		        # Input print condition
    ELSE
        CALL axmr170()		# Read data and create out-file
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION r170_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
    DEFINE p_row,p_col	LIKE type_file.num5,          #No.FUN-680137 SMALLINT
           l_cmd	LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(1000)
           l_a         LIKE type_file.chr1,          # No.FUN-680137 VARCHAR(1)
           l_n          LIKE type_file.num5           #No.FUN-680137 SMALLINT
 
    LET p_row = 4 LET p_col = 17
 
    OPEN WINDOW r170_w AT p_row,p_col WITH FORM "axm/42f/axmr170"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    CALL cl_opmsg('p')
    INITIALIZE tm.* TO NULL			# Default condition
    LET tm.bdate = g_today
    LET tm.edate = g_today
    LET tm.a     = '1'
    LET tm.b     = '1'
    LET tm.more  = 'N'
    LET g_pdate  = g_today
    LET g_rlang  = g_lang
    LET g_bgjob  = 'N'
    LET g_copies = '1'
WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON opc01,opc04,opc05
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION CONTROLP    #FUN-4B0043
           IF INFIELD(opc01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO opc01
              NEXT FIELD opc01
           END IF
           IF INFIELD(opc04) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO opc04
              NEXT FIELD opc04
           END IF
           IF INFIELD(opc05) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gem"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO opc05
              NEXT FIELD opc05
           END IF
 
       ON ACTION locale
           #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
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
        LET INT_FLAG = 0 CLOSE WINDOW r170_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
           
    END IF
    IF tm.wc = " 1=1 "  THEN
        CALL cl_err(' ','9046',0)
        CONTINUE WHILE
    END IF
    DISPLAY BY NAME tm.bdate,tm.edate,tm.a,tm.b,tm.b_co,tm.more
                    # Condition
    INPUT  BY NAME tm.bdate,tm.edate,tm.a,tm.b,tm.b_co,tm.more
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
            NEXT FIELD edate
        END IF
    AFTER FIELD a
        IF cl_null(tm.a) OR tm.a NOT MATCHES '[123]' THEN
            NEXT FIELD a
        END IF
    AFTER FIELD b
        #-----MOD-A50050---------
        CALL r170_set_entry()
        CALL r170_set_no_entry()
        #-----END MOD-A50050-----
        IF cl_null(tm.b) OR tm.b NOT MATCHES '[12345]' THEN
            NEXT FIELD b
        END IF
        IF tm.b = 1 THEN
            NEXT FIELD b_co
        ELSE
            LET tm.b_co = NULL
            DISPLAY BY NAME tm.b_co
            NEXT FIELD more
        END IF
    AFTER FIELD b_co
        IF cl_null(tm.b_co) THEN NEXT FIELD b_co END IF
        SELECT rpg01 FROM rpg_file
            WHERE rpg01 = tm.b_co
        IF STATUS THEN
#           CALL cl_err('select rpg',STATUS,0)   #No.FUN-660167
            CALL cl_err3("sel","rpg_file",tm.b_co,"",STATUS,"","select rpg",0)   #No.FUN-660167
            NEXT FIELD b_co
        END IF
 
    AFTER FIELD more
        IF tm.more NOT MATCHES "[YN]" OR cl_null(tm.more)
            THEN NEXT FIELD more
        END IF
        IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
        END IF
    ON ACTION CONTROLR
       CALL cl_show_req_fields()
 
#--no.MOD-860078----------start-
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
 
    ON ACTION about
       CALL cl_about()
 
    ON ACTION help
         CALL cl_show_help()
#--no.MOD-860078 --------end----
 
    ON ACTION CONTROLG
       CALL cl_cmdask()	# Command execution
 
    ON ACTION CONTROLP
       CASE
          WHEN INFIELD(b_co)
#            CALL q_rpg(05,03,tm.b_co) RETURNING tm.b_co
             CALL cl_init_qry_var()
             LET g_qryparam.form = 'q_rpg'
             LET g_qryparam.default1 = tm.b_co
             CALL cl_create_qry() RETURNING tm.b_co
             DISPLAY BY NAME tm.b_co
             NEXT FIELD b_co
         OTHERWISE
             EXIT CASE
      END CASE
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
    END INPUT
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0 CLOSE WINDOW r170_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
           
    END IF
    IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
            WHERE zz01='axmr170'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('axmr170','9031',1)   
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
                       #-------------No.TQC-610089 modify
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                       #-------------No.TQC-610089 end
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.b_co CLIPPED,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('axmr170',g_time,l_cmd) # Execute cmd at later time
        END IF
        CLOSE WINDOW r170_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
    END IF
    CALL cl_wait()
    CALL axmr170()
    ERROR ""
END WHILE
    CLOSE WINDOW r170_w
END FUNCTION
 
FUNCTION axmr170()
    DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time           LIKE type_file.chr8	    #No.FUN-6A0094
           l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT        #No.FUN-680137 VARCHAR(1000)
           l_sql1 	LIKE type_file.chr1000,		# RDSQL STATEMENT        #No.FUN-680137 VARCHAR(1000)
           l_chr        LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
           l_za05	LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
           l_i          LIKE type_file.num5,          #No.FUN-680137 SMALLINT
           sr           RECORD
               opc01    LIKE opc_file.opc01, #預測料號範圍
               opc02    LIKE opc_file.opc02, #客戶編號
               opc03    LIKE opc_file.opc03, #計劃日期範圍
               opc04    LIKE opc_file.opc04, #業務員範圍
               opc05    LIKE opc_file.opc05, #部門範圍
               opc06    LIKE opc_file.opc06  #提列方式(1.週 2.月)
                        END RECORD
#NO.FUN-830054----START-----
    DEFINE     l_ima02	LIKE ima_file.ima02
    DEFINE     l_ima01	LIKE ima_file.ima01
    DEFINE     l_opc03	LIKE opc_file.opc03
    DEFINE     l_opc04	LIKE opc_file.opc04
    DEFINE     l_opc05	LIKE opc_file.opc05
    DEFINE     l_ogb_sum    LIKE ade_file.ade05
    DEFINE     l_oeb_sum     LIKE ade_file.ade05
    DEFINE     l_ogb_out    LIKE ade_file.ade05
    DEFINE     l_ogb_out2   LIKE ade_file.ade05
    DEFINE     l_ogb_out1   ARRAY[12] OF  LIKE ade_file.ade05
    DEFINE     l_oeb_ord     LIKE ade_file.ade05
    DEFINE     l_oeb_ord2   LIKE ade_file.ade05
    DEFINE     l_oeb_ord3   LIKE ade_file.ade05    #MOD-AA0071 add
    DEFINE     l_oeb_ord1   ARRAY[12] OF  LIKE ade_file.ade05
    DEFINE   sr1          RECORD
               l_num    LIKE img_file.img30,
               opd06    LIKE opd_file.opd06,
               opd07    LIKE opd_file.opd07 
                        END RECORD
    DEFINE   l_opd        DYNAMIC ARRAY OF RECORD
               l_num    LIKE img_file.img30,
               opd06    LIKE opd_file.opd06, 
               opd07    LIKE opd_file.opd07  
                        END RECORD
    DEFINE   l_opd_t      RECORD
               l_num    LIKE img_file.img30,
               opd06    LIKE opd_file.opd06,
               opd07    LIKE opd_file.opd07 
                        END RECORD
    DEFINE     l_sum        LIKE img_file.img30
    DEFINE     l_n          LIKE type_file.num5
    DEFINE     i            LIKE type_file.num5
    DEFINE     l_msg        LIKE zaa_file.zaa08   #TQC-A50044
#NO.FUN-830054-----END---
#    CALL g_zaa_dyn.clear()    #No.FUN-670106                          #CHI-910057 Mark     
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang                   
#NO.FUN-830054-----start---
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
     CALL cl_del_data(l_table3)
     CALL cl_del_data(l_table4)
 
     LET g_sql ="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                #" VALUES(?,?,?,?,?, ?,?,?,?,?)"   #MOD-950168
                " VALUES(?,?,?,?,?, ?,?)"   #MOD-950168
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
        EXIT PROGRAM
     END IF
     LET g_sql ="INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?,?,",
                "        ?,?,?,?,?, ?,?,?,?,?,",
                #"        ?,?,?,?,?, ?,?,?)"   #MOD-950168
                "        ?,?,?,?,?, ?,?,?,?)"   #MOD-950168
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
        EXIT PROGRAM
     END IF 
     LET g_sql ="INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                #" VALUES(?,?,?)"   #MOD-950168
#               " VALUES(?,?,?,?,?, ?)"   #MOD-950168   #TQC-A50044 add ?    #MOD-B80347 mark
                " VALUES(?,?,?,?,?, ?,?,?)"             #MOD-B80347
     PREPARE insert_prep2 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep2:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
        EXIT PROGRAM
     END IF 
     LET g_sql ="INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?,?,",
                #"        ?,?)"   #MOD-950168
                "        ?,?,?,?,?, ?,?)"   #MOD-950168   #TQC-A50044 add ?
     PREPARE insert_prep3 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep3:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
        EXIT PROGRAM
     END IF 
     LET g_sql ="INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?,?,",
                #"        ?,?)"   #MOD-950168
                "        ?,?,?,?,?, ?,?)"   #MOD-950168   #TQC-A50044 add ?
     PREPARE insert_prep4 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep4:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
        EXIT PROGRAM
     END IF 
   
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='axmr170'
#NO.FUN-830054-----end---
#No.FUN-670106--begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axmr170'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 204 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-670106--end
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND opcuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND opcgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND opcgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('opcuser', 'opcgrup')
     #End:FUN-980030
 
 
    LET l_sql = " SELECT opc01,opc02,opc03,opc04,opc05,opc06 ",
                "   FROM opc_file ",
                "  WHERE opc06 = '",tm.b,"'",
                "    AND opc03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                "    AND ",tm.wc CLIPPED
    IF tm.b = 1 THEN
       LET l_sql = l_sql CLIPPED,"  AND opc10 = '",tm.b_co,"'"
    END IF
    LET l_sql = l_sql CLIPPED," ORDER BY opc01,opc04,opc05 "
    PREPARE r170_prepare1 FROM l_sql
    IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
           
    END IF
    DECLARE r170_cs1 CURSOR FOR r170_prepare1
    IF SQLCA.sqlcode THEN
        CALL cl_err('declare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
           
    END IF
    CASE tm.a
        WHEN '1'
             LET l_sql = "SELECT opd08,opd06,opd07 FROM opd_file",
                         " WHERE opd01 = ? ",
                         "   AND opd02 = ? ",
                         "   AND opd03 = ? ",
                         "   AND opd04 = ? ",
                         " ORDER BY opd06 "
        WHEN '2'
             LET l_sql = "SELECT opd09,opd06,opd07 FROM opd_file",
                         " WHERE opd01 = ? ",
                         "   AND opd02 = ? ",
                         "   AND opd03 = ? ",
                         "   AND opd04 = ? ",
                         " ORDER BY opd06 "
        WHEN '3'
             LET l_sql = "SELECT opd11*opc09,opd06,opd07 ",
                         "  FROM opd_file,opc_file ",
                         " WHERE opc01 = opd01 ",
                         "   AND opc02 = opd02 ",
                         "   AND opc03 = opd03 ",
                         "   AND opc04 = opd04 ",
                         "   AND opd01 = ? ",
                         "   AND opd02 = ? ",
                         "   AND opd03 = ? ",
                         "   AND opd04 = ? ",
                         " ORDER BY opd06 "
    END CASE
 
    PREPARE r170_prepare2 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
       EXIT PROGRAM
          
    END IF
    DECLARE r170_cs2 CURSOR FOR r170_prepare2
    LET l_sql = " SELECT DISTINCT opc04,opc05 ",
                "   FROM opc_file  ",
                "  WHERE ",tm.wc CLIPPED,
                "  ORDER BY opc04,opc05 "
    PREPARE r170_prepare3 FROM l_sql
    IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:3',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
           
    END IF
    DECLARE r170_cs3 CURSOR FOR r170_prepare3
    IF SQLCA.sqlcode THEN
        CALL cl_err('declare:r170_cs3',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
           
    END IF
    LET l_sql = " SELECT opc03,opc04 ",
                "   FROM opc_file ",
                "  WHERE opc06 = '",tm.b,"'",
                "    AND opc03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                "    AND opc01 = ? ",   #MOD-950168
                "    AND ",tm.wc CLIPPED
    IF tm.b = 1 THEN
       LET l_sql = l_sql CLIPPED,"  AND opc10 = '",tm.b_co,"'"
    END IF
    LET l_sql = l_sql CLIPPED," ORDER BY opc03,opc04 "
    PREPARE r170_prepare4 FROM l_sql
    IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:4',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
           
    END IF
    DECLARE r170_cs4 CURSOR FOR r170_prepare4
    IF SQLCA.sqlcode THEN
        CALL cl_err('declare:r170_cs4',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
           
    END IF
 
#   LET l_name = 'axmr170.out'
    CALL g_x.clear()    #No.FUN-670106
#    CALL cl_outnam('axmr170') RETURNING l_name             #NO.FUN-830054
 
#    START REPORT r170_rep TO l_name                        #NO.FUN-830054
#     LET g_pageno = 0                                      #NO.FUN-830054
    FOREACH r170_cs1 INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
#        OUTPUT TO REPORT r170_rep(sr.*)                   #NO.FUN-830054  
#NO.FUN-830054-----start-----
        SELECT ima02 INTO l_ima02 FROM ima_file
            WHERE ima01 = sr.opc01
 
        FOR i = 1 TO 12
             INITIALIZE l_opd[i].* TO NULL
        END FOR
        LET i = 1
        #FOREACH r170_cs4 INTO l_opc03,l_opc04     #MOD-950168  
        FOREACH r170_cs4 USING sr.opc01 INTO l_opc03,l_opc04     #MOD-950168  
                FOREACH r170_cs2
                USING sr.opc01,sr.opc02,l_opc03,l_opc04
                INTO l_opd_t.*
                    IF i > 12 THEN EXIT FOREACH END IF
                    IF i >= 2 THEN
                       IF l_opd_t.opd06 < l_opd[i-1].opd07 THEN
                          CONTINUE FOREACH
                       END IF
                    END IF
                    LET l_opd[i].* = l_opd_t.*
                    LET i = i + 1
                END FOREACH
                IF i > 12 THEN EXIT FOREACH END IF
        END FOREACH
        
#       FOR  i = 1 to 12                                                           #CHI-910057 Mark 
#            LET g_zaa[31+i].zaa08 = l_opd[i].opd06                                #CHI-910057 Mark
#            LET g_zaa[45+i].zaa08 = l_opd[i].opd07                                #CHI-910057 Mark
#       END FOR                                                                    #CHI-910057 Mark
        LET l_msg = cl_getmsg('amr-003',g_lang)   #TQC-A50044
        EXECUTE insert_prep1 USING 
#          g_zaa[31].zaa08,g_zaa[32].zaa08,g_zaa[33].zaa08,g_zaa[34].zaa08,        #CHI-910057 Mark
#          g_zaa[35].zaa08,g_zaa[36].zaa08,g_zaa[37].zaa08,g_zaa[38].zaa08,        #CHI-910057 Mark
#          g_zaa[39].zaa08,g_zaa[40].zaa08,g_zaa[41].zaa08,g_zaa[42].zaa08,        #CHI-910057 Mark
#          g_zaa[43].zaa08,g_zaa[44].zaa08,g_zaa[45].zaa08,g_zaa[46].zaa08,        #CHI-910057 Mark
#          g_zaa[47].zaa08,g_zaa[48].zaa08,g_zaa[49].zaa08,g_zaa[50].zaa08,        #CHI-910057 Mark
#          g_zaa[51].zaa08,g_zaa[52].zaa08,g_zaa[53].zaa08,g_zaa[54].zaa08,        #CHI-910057 Mark
#          g_zaa[55].zaa08,g_zaa[56].zaa08,g_zaa[57].zaa08,g_zaa[58].zaa08         #CHI-910057 Mark
                       '',l_opd[1].opd06,l_opd[2].opd06,l_opd[3].opd06,            #CHI-910057 Add 
           l_opd[4].opd06,l_opd[5].opd06,l_opd[6].opd06,l_opd[7].opd06,            #CHI-910057 Add
           l_opd[8].opd06,l_opd[9].opd06,l_opd[10].opd06,l_opd[11].opd06,          #CHI-910057 Add
           #l_opd[12].opd06,'',      #CHI-910057 Add     #TQC-A50044              
           l_opd[12].opd06,l_msg,    #CHI-910057 Add     #TQC-A50044
                       '',l_opd[1].opd07,l_opd[2].opd07,l_opd[3].opd07,            #CHI-910057 Add
           l_opd[4].opd07,l_opd[5].opd07,l_opd[6].opd07,l_opd[7].opd07,            #CHI-910057 Add
           l_opd[8].opd07,l_opd[9].opd07,l_opd[10].opd07,l_opd[11].opd07,          #CHI-910057 Add
           #l_opd[12].opd07,''   #MOD-950168                                                   #CHI-910057 Add
           l_opd[12].opd07,'',sr.opc01   #MOD-950168                                                   #CHI-910057 Add
#       CALL cl_prt_pos_dyn()                                                      #CHI-910057 Mark        
        #-----TQC-A50044---------                                               
        LET g_title = NULL                                                      
        FOR i = 1 TO 12                                                         
            IF cl_null(l_opd[i].opd06) OR cl_null(l_opd[i].opd07) THEN          
               IF i = 1 THEN                                                    
                  LET g_title = 'N'                                             
               ELSE                                                             
                  LET g_title = g_title,'N'                                     
               END IF                                                           
            ELSE                                                                
               IF i = 1 THEN                                                    
                  LET g_title = 'Y'                                             
               ELSE                                                             
                  LET g_title = g_title,'Y'                                     
               END IF                                                           
            END IF                                                              
        END FOR                                                                 
        #-----END TQC-A50044----- 
 
        DECLARE r170_cs5 CURSOR FOR
         SELECT ima01 FROM ima_file
          WHERE ima133 = sr.opc01
        FOR i = 1 TO 12
            LET l_ogb_out1[i] = 0
            LET l_oeb_ord1[i] = 0
            FOREACH r170_cs3 INTO l_opc04,l_opc05
                LET l_ogb_out = 0
                LET l_oeb_ord = 0
                FOREACH r170_cs5 INTO l_ima01
                    IF tm.a = '1' OR tm.a = '2' THEN
                       LET l_ogb_out2 = 0
                       LET l_oeb_ord2 = 0
                       LET l_oeb_ord3 = 0     #MOD-AA0071 add
                       SELECT SUM(ogb12) INTO l_ogb_out2
                         FROM oga_file,ogb_file
                        WHERE oga02 BETWEEN l_opd[i].opd06 AND l_opd[i].opd07
                         AND ogb04 = l_ima01
                         AND oga01 = ogb01
                         AND oga14 = l_opc04
                         AND oga15 = l_opc05
                         AND ogaconf = 'Y' #01/08/20 mandy
                         AND oga09 != '1' AND  oga09 != '5'  #No:7237
                         AND oga09 != '7' AND  oga09 != '9'  #No.FUN-610020
                         AND oga65='N'     #No.FUN-610020
                       SELECT SUM(oeb12) INTO l_oeb_ord2
                         FROM oea_file,oeb_file
                       #WHERE oea02 BETWEEN l_opd[i].opd06 AND l_opd[i].opd07       #MOD-AA0071 mark  
                        WHERE oeb15 BETWEEN l_opd[i].opd06 AND l_opd[i].opd07       #MOD-AA0071 add 
                         AND oeb04 = l_ima01
                         AND oea00 != '0'     #MOD-AA0071 add
                         AND oea01 = oeb01
                         AND oea14 = l_opc04
                         AND oea15 = l_opc05
                         AND oeaconf = 'Y' #01/08/16 mandy
                      #--------------------No:MOD-AA0071 add
                       SELECT SUM(oeb12-oeb24) INTO l_oeb_ord3
                         FROM oea_file,oeb_file
                        WHERE oeb15 BETWEEN l_opd[i].opd06 AND l_opd[i].opd07    
                         AND oeb04 = l_ima01
                         AND oea00 ='0'             
                         AND oea01 = oeb01
                         AND oea14 = l_opc04  
                         AND oea15 = l_opc05   
                         AND oeaconf = 'Y'
                      #--------------------No:MOD-AA0071 end
                        IF cl_null(l_ogb_out2) THEN LET l_ogb_out2 = 0 END IF
                        IF cl_null(l_oeb_ord2) THEN LET l_oeb_ord2 = 0 END IF
                        IF cl_null(l_oeb_ord3) THEN LET l_oeb_ord3 = 0 END IF      #No:MOD-AA0071 add
                        LET l_ogb_out = l_ogb_out + l_ogb_out2
                        LET l_oeb_ord = l_oeb_ord + l_oeb_ord2
                    END IF
                    IF tm.a = '3' THEN
                        LET l_ogb_out2 = 0
                        LET l_oeb_ord2 = 0
                        SELECT SUM(ogb14) INTO l_ogb_out2
                          FROM oga_file,ogb_file
                         WHERE oga02 BETWEEN l_opd[i].opd06 AND l_opd[i].opd07
                           AND ogb04 = l_ima01
                           AND oga01 = ogb01
                           AND oga14 = l_opc04
                           AND oga15 = l_opc05
                           AND ogaconf = 'Y' #01/08/20 mandy
                           AND oga09 != '1' AND  oga09 != '5'  #No:7237
                           AND oga09 != '7' AND  oga09 != '9'  #No.FUN-610020
                           AND oga65='N'     #No.FUN-610020
                        SELECT SUM(oeb14) INTO l_oeb_ord2
                          FROM oea_file,oeb_file
                        #WHERE oea02 BETWEEN l_opd[i].opd06 AND l_opd[i].opd07          #MOD-AA0071 mark    
                         WHERE oeb15 BETWEEN l_opd[i].opd06 AND l_opd[i].opd07          #MOD-AA0071 add 
                           AND oeb04 = l_ima01
                           AND oea01 = oeb01
                           AND oea14 = l_opc04
                           AND oea15 = l_opc05
                           AND oeaconf = 'Y' #01/08/16 mandy
                        IF cl_null(l_ogb_out2) THEN LET l_ogb_out2 = 0 END IF
                        IF cl_null(l_oeb_ord2) THEN LET l_oeb_ord2 = 0 END IF
                        LET l_ogb_out = l_ogb_out + l_ogb_out2
                        LET l_oeb_ord = l_oeb_ord + l_oeb_ord2
                    END IF
                END FOREACH
                IF cl_null(l_ogb_out) THEN LET l_ogb_out = 0 END IF
                IF cl_null(l_oeb_ord) THEN LET l_oeb_ord = 0 END IF
                LET l_ogb_out1[i] = l_ogb_out1[i] + l_ogb_out
                LET l_oeb_ord1[i] = l_oeb_ord1[i] + l_oeb_ord
            END FOREACH
        END FOR
 
        LET l_n = 1
        LET l_sum = 0
        FOREACH r170_cs2
        USING sr.opc01,sr.opc02,sr.opc03,sr.opc04
        INTO sr1.*
            IF l_n = 1 THEN
                FOR i = 1 TO 12
                    IF sr1.opd06 >= l_opd[i].opd06 AND
                       sr1.opd06 <= l_opd[i].opd07 THEN
                      LET l_n = 0
                      LET l_n = i
                       EXIT FOR
                    END IF
                END FOR
                #EXECUTE insert_prep2 USING sr.opc04,l_n,l_sum   #MOD-950168
#               EXECUTE insert_prep2 USING sr.opc04,sr.opc03,sr.opc01,l_n,sr1.l_num,g_title   #MOD-950168  #No.TQC-A50044   #MOD-B8034
                EXECUTE insert_prep2 USING sr.opc04,sr.opc03,sr.opc01,l_n,sr1.l_num,g_title,  #MOD-B80347
                                           sr.opc02,sr.opc05                                  #MOD-B80347
           ELSE
                LET l_n = l_n + 1
                IF l_n > 12 THEN EXIT FOREACH END IF
                #EXECUTE insert_prep2 USING sr.opc04,l_n,sr1.l_num   #MOD-950168
#               EXECUTE insert_prep2 USING sr.opc04,sr.opc03,sr.opc01,l_n,sr1.l_num,g_title   #MOD-950168  #No.TQC-A50044   #MOD-B8034
                EXECUTE insert_prep2 USING sr.opc04,sr.opc03,sr.opc01,l_n,sr1.l_num,g_title,  #MOD-B80347
                                           sr.opc02,sr.opc05                                  #MOD-B80347
           END IF
            LET l_sum = l_sum + sr1.l_num
        END FOREACH
       #MOD-AA0071---mark---start--- 
       #MOD-D20148 remark start ------
        LET l_ogb_sum = 0
        LET l_oeb_sum = 0
        FOR i = 1 TO 12
           LET l_ogb_sum = l_ogb_sum + l_ogb_out1[i]  
        END FOR
        EXECUTE insert_prep3 USING
           l_ogb_out1[1],l_ogb_out1[2],l_ogb_out1[3],l_ogb_out1[4],
           l_ogb_out1[5],l_ogb_out1[6],l_ogb_out1[7],l_ogb_out1[8],
           l_ogb_out1[9],l_ogb_out1[10],l_ogb_out1[11],l_ogb_out1[12],
           sr.opc01,sr.opc04,sr.opc05,l_ogb_sum,g_title   #MOD-950168  #No.TQC-A50044
        FOR i = 1 TO 12                                                                                                           
           LET l_oeb_sum = l_oeb_sum + l_oeb_ord1[i]                                                                                 
        END FOR                              
        EXECUTE insert_prep4 USING
           l_oeb_ord1[1],l_oeb_ord1[2],l_oeb_ord1[3],l_oeb_ord1[4],
           l_oeb_ord1[5],l_oeb_ord1[6],l_oeb_ord1[7],l_oeb_ord1[8],
           l_oeb_ord1[9],l_oeb_ord1[10],l_oeb_ord1[11],l_oeb_ord1[12],
           sr.opc01,sr.opc04,sr.opc05,l_oeb_sum,g_title   #MOD-950168  #No.TQC-A50044
       #MOD-D20148 remark end   ------
       #MOD-AA0071---mark---end---
      EXECUTE insert_prep USING
         sr.opc01,sr.opc02,sr.opc03,sr.opc04,sr.opc05,sr.opc06,l_ima02
         #l_ogb_sum,l_oeb_sum,sr1.l_num    #MOD-950168
#NO.FUN-830054-----end----
    END FOREACH
 
   #MOD-D20148 mark start -----
   #--------------------No:MOD-AA0071 add
   #LET l_ogb_sum = 0
   #LET l_oeb_sum = 0
   #FOR i = 1 TO 12
   #   LET l_ogb_sum = l_ogb_sum + l_ogb_out1[i]  
   #END FOR
   #EXECUTE insert_prep3 USING
   #   l_ogb_out1[1],l_ogb_out1[2],l_ogb_out1[3],l_ogb_out1[4],
   #   l_ogb_out1[5],l_ogb_out1[6],l_ogb_out1[7],l_ogb_out1[8],
   #   l_ogb_out1[9],l_ogb_out1[10],l_ogb_out1[11],l_ogb_out1[12],
   #   sr.opc01,sr.opc04,sr.opc05,l_ogb_sum,g_title   #MOD-950168   #MOD-990214
   #FOR i = 1 TO 12                                                                                                           
   #   LET l_oeb_sum = l_oeb_sum + l_oeb_ord1[i]                                                                                 
   #END FOR                              
   #EXECUTE insert_prep4 USING
   #   l_oeb_ord1[1],l_oeb_ord1[2],l_oeb_ord1[3],l_oeb_ord1[4],
   #   l_oeb_ord1[5],l_oeb_ord1[6],l_oeb_ord1[7],l_oeb_ord1[8],
   #   l_oeb_ord1[9],l_oeb_ord1[10],l_oeb_ord1[11],l_oeb_ord1[12],
   #   sr.opc01,sr.opc04,sr.opc05,l_oeb_sum,g_title   #MOD-950168   #MOD-990214
   #--------------------No:MOD-AA0071 end
   #MOD-D20148 mark end   -----
#    FINISH REPORT r170_rep                                 #NO.FUN-830054
#NO.FUN-830054-----start---
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
                 "SELECT DISTINCT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,"|",
                 "SELECT DISTINCT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED
     IF g_zz05 ='Y' THEN 
       CALL cl_wcchp(tm.wc,'opc01,opc04,opc05')
            RETURNING tm.wc
     END IF 
     LET  g_str=tm.wc
     CALL cl_prt_cs3('axmr170','axmr170',g_sql,g_str)
#NO.FUN-830054-----end----
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)            #NO.FUN-830054
END FUNCTION
#NO.FUN-830054---start---
#REPORT r170_rep(sr)
#    DEFINE l_last_sw	LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
#           l_ima02	LIKE ima_file.ima02,
#           l_ima01	LIKE ima_file.ima01,
#           l_opc03	LIKE opc_file.opc03,
#           l_opc04	LIKE opc_file.opc04,
#           l_opc05	LIKE opc_file.opc05,
#           l_emplname   LIKE occ_file.occ02,      # No.FUN-680137 VARCHAR(30)         #NO.FUN-670106
#           l_ogb_sum    LIKE ogb_file.ogb16,      # No.FUN-680137 DEC(15,3)        #實際出貨數量合計 #TQC-840066
#           l_ogb_out    LIKE ogb_file.ogb16,      # No.FUN-680137 DEC(15,3)        #實際出貨數量     #TQC-840066
#           l_ogb_out2   LIKE ogb_file.ogb16,      # No.FUN-680137 DEC(15,3)                           #實際出貨數量 #TQC-840066
#           l_ogb_out1   ARRAY[12] OF  LIKE ogb_file.ogb16,      # No.FUN-680137  DEC(15,3)              #實際出貨數量 #TQC-840066
#           l_oeb_sum     LIKE ogb_file.ogb16,      # No.FUN-680137  DEC(15,3)                           #實際接單數量合計 #TQC-840066
#           l_oeb_ord     LIKE ogb_file.ogb16,      # No.FUN-680137  DEC(15,3)                           #實際接單數量 #TQC-840066
#           l_oeb_ord2   LIKE ogb_file.ogb16,       # No.FUN-680137  DEC(15,3)                           #實際接單數量 #TQC-840066
#           l_oeb_ord1   ARRAY[12] OF  LIKE ogb_file.ogb16,      # No.FUN-680137  DEC(15,3)              #實際接單數量 #TQC-840066
#           sr           RECORD
#               opc01    LIKE opc_file.opc01, #預測料號範圍
#               opc02    LIKE opc_file.opc02, #客戶編號
#               opc03    LIKE opc_file.opc03, #計劃日期範圍
#               opc04    LIKE opc_file.opc04, #業務員範圍
#               opc05    LIKE opc_file.opc05, #部門範圍
#               opc06    LIKE opc_file.opc06  #提列方式(1.週 2.月)
#                        END RECORD,
#           sr1          RECORD
#               l_num    LIKE img_file.img30,      # No.FUN-680137  DEC(15,5)           #列印內容
#               opd06    LIKE opd_file.opd06, #起始日期
#               opd07    LIKE opd_file.opd07  #截止日期
#                        END RECORD,
#           l_opd        DYNAMIC ARRAY OF RECORD
#               l_num    LIKE img_file.img30,      # No.FUN-680137  DEC(15,5)           #列印內容
#               opd06    LIKE opd_file.opd06, #起始日期
#               opd07    LIKE opd_file.opd07  #截止日期
#                        END RECORD,
#           l_opd_t      RECORD
#               l_num    LIKE img_file.img30,      # No.FUN-680137  DEC(15,5)           #列印內容
#               opd06    LIKE opd_file.opd06, #起始日期
#               opd07    LIKE opd_file.opd07  #截止日期
#                        END RECORD,
#           l_sum        LIKE img_file.img30,      # No.FUN-680137  DEC(15,5)                           #列印內容合計
#           i            LIKE type_file.num5,       #No.FUN-680137 SMALLINT
#           j            LIKE type_file.num5,       #No.FUN-680137 SMALLINT
#           l_mm         LIKE type_file.num5,      # No.FUN-680137 SMALLINT
#           l_yy         LIKE type_file.num5,      # No.FUN-680137 SMALLINT
#           l_n          LIKE type_file.num5,       #No.FUN-680137 SMALLINT
#           l_point      LIKE type_file.num5       # No.FUN-680137 SMALLINT                      
#    OUTPUT TOP MARGIN g_top_margin
#           LEFT MARGIN g_left_margin
#           BOTTOM MARGIN g_bottom_margin 
#           PAGE LENGTH g_page_line
#    ORDER BY sr.opc01,sr.opc03,sr.opc02,sr.opc04,sr.opc05
#    FORMAT
#    PAGE HEADER
##No.FUN670106------Begin---
##        PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
##        IF g_towhom IS NULL OR g_towhom = ' '
##            THEN PRINT '';
##        ELSE
##            PRINT 'TO:',g_towhom;
##        END IF
#         LET g_pageno = g_pageno + 1 
#         LET pageno_total = PAGENO USING '<<<',"/pageno" 
##          COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'  ,"/pageno" 
#        PRINT g_head CLIPPED,pageno_total 
##       PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1 ,g_x[1] CLIPPED   #No.TQC-6A0091
#        PRINT ' '
##       PRINT g_x[2] CLIPPED,g_today,'  ',TIME,' ',
##           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
##No.FUN670106------End---  
#        PRINT g_dash[1,g_len]
#        LET l_last_sw = 'n'
#
##   BEFORE GROUP OF sr.opc01
#        SELECT ima02 INTO l_ima02 FROM ima_file
#            WHERE ima01 = sr.opc01
#        PRINT COLUMN  1,g_x[11] CLIPPED,sr.opc01,' ',l_ima02
#
#        FOR i = 1 TO 12
#             INITIALIZE l_opd[i].* TO NULL
#        END FOR
#        LET i = 1
#       FOREACH r170_cs4 INTO l_opc03 , l_opc04
#                FOREACH r170_cs2
#                USING sr.opc01,sr.opc02,l_opc03,l_opc04
#                INTO l_opd_t.*
#                    IF i > 12 THEN EXIT FOREACH END IF
#                    IF i >= 2 THEN
#                       IF l_opd_t.opd06 < l_opd[i-1].opd07 THEN
#                          CONTINUE FOREACH
#                       END IF
#                    END IF
#                    LET l_opd[i].* = l_opd_t.*
#                    LET i = i + 1
#                END FOREACH
#                IF i > 12 THEN EXIT FOREACH END IF
#        END FOREACH
##No.FUN670106----Begin---
#        FOR  i = 1 to 12
#             LET g_zaa[31+i].zaa08 = l_opd[i].opd06
#             LET g_zaa[45+i].zaa08 = l_opd[i].opd07 
#        END FOR 
#        CALL cl_prt_pos_dyn()                        #FUN-670106
#        PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]  
#        PRINTX name=H2 g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],g_x[51],g_x[52],g_x[53],g_x[54],g_x[55],g_x[56],g_x[57],g_x[58]
#        PRINT g_dash1
##        LET l_point = 13
##        FOR i = 1 TO 12
##            PRINT COLUMN l_point,l_opd[i].opd06;
##            LET l_point = l_point + 15
##        END FOR
##        PRINT COLUMN l_point,g_x[12]
##        LET l_point = 13
##        FOR i = 1 TO 12
##            PRINT COLUMN l_point,l_opd[i].opd07;
##        PRINT COLUMN l_point,l_opd[i].opd07 USING "---,---,--&.&&";
##            LET l_point = l_point + 15
##        END FOR
##        PRINT ''
##        LET l_point = 10
##        FOR i = 1 TO 12
##             PRINT COLUMN l_point,"--------------";
##             LET l_point = l_point + 15
##        END FOR
##        PRINT COLUMN l_point,"--------------"
##No.FUN670106----End---   
#        DECLARE r170_cs5 CURSOR FOR
#         SELECT ima01 FROM ima_file
#          WHERE ima133 = sr.opc01
#        FOR i = 1 TO 12
#            LET l_ogb_out1[i] = 0
#            LET l_oeb_ord1[i] = 0
#            FOREACH r170_cs3 INTO l_opc04,l_opc05
#                LET l_ogb_out = 0
#                LET l_oeb_ord = 0
#                FOREACH r170_cs5 INTO l_ima01
#                    IF tm.a = '1' OR tm.a = '2' THEN
#                       LET l_ogb_out2 = 0
#                       LET l_oeb_ord2 = 0
#                       SELECT SUM(ogb12) INTO l_ogb_out2
#                         FROM oga_file,ogb_file
#                        WHERE oga02 BETWEEN l_opd[i].opd06 AND l_opd[i].opd07
#                         AND ogb04 = l_ima01
#                         AND oga01 = ogb01
#                         AND oga14 = l_opc04
#                         AND oga15 = l_opc05
#                         AND ogaconf = 'Y' #01/08/20 mandy
#                         AND oga09 != '1' AND  oga09 != '5'  #No:7237
#                         AND oga09 != '7' AND  oga09 != '9'  #No.FUN-610020
#                         AND oga65='N'     #No.FUN-610020
#                       SELECT SUM(oeb12) INTO l_oeb_ord2
#                         FROM oea_file,oeb_file
#                       # WHERE oea02 BETWEEN l_opd[i].opd06 AND l_opd[i].opd07   #NO.MOD-840564
#                        WHERE oeb15 BETWEEN l_opd[i].opd06 AND l_opd[i].opd07    #NO.MOD-840564
#                         AND oeb04 = l_ima01
#                         AND oea01 = oeb01
#                         AND oea14 = l_opc04
#                         AND oea15 = l_opc05
#                         AND oeaconf = 'Y' #01/08/16 mandy
#                        IF cl_null(l_ogb_out2) THEN LET l_ogb_out2 = 0 END IF
#                        IF cl_null(l_oeb_ord2) THEN LET l_oeb_ord2 = 0 END IF
#                        LET l_ogb_out = l_ogb_out + l_ogb_out2
#                        LET l_oeb_ord = l_oeb_ord + l_oeb_ord2
#                    END IF
#                    IF tm.a = '3' THEN
#                        LET l_ogb_out2 = 0
#                        LET l_oeb_ord2 = 0
#                        SELECT SUM(ogb14) INTO l_ogb_out2
#                          FROM oga_file,ogb_file
#                         WHERE oga02 BETWEEN l_opd[i].opd06 AND l_opd[i].opd07
#                           AND ogb04 = l_ima01
#                           AND oga01 = ogb01
#                           AND oga14 = l_opc04
#                           AND oga15 = l_opc05
#                           AND ogaconf = 'Y' #01/08/20 mandy
#                           AND oga09 != '1' AND  oga09 != '5'  #No:7237
#                           AND oga09 != '7' AND  oga09 != '9'  #No.FUN-610020
#                           AND oga65='N'     #No.FUN-610020
#                        SELECT SUM(oeb14) INTO l_oeb_ord2
#                          FROM oea_file,oeb_file
#                         #WHERE oea02 BETWEEN l_opd[i].opd06 AND l_opd[i].opd07     #No.MOD-840564
#                         WHERE oeb15 BETWEEN l_opd[i].opd06 AND l_opd[i].opd07      #No.MOD-840564               
#                           AND oeb04 = l_ima01
#                           AND oea01 = oeb01
#                           AND oea14 = l_opc04
#                           AND oea15 = l_opc05
#                           AND oeaconf = 'Y' #01/08/16 mandy
#                        IF cl_null(l_ogb_out2) THEN LET l_ogb_out2 = 0 END IF
#                        IF cl_null(l_oeb_ord2) THEN LET l_oeb_ord2 = 0 END IF
#                        LET l_ogb_out = l_ogb_out + l_ogb_out2
#                        LET l_oeb_ord = l_oeb_ord + l_oeb_ord2
#                    END IF
#                END FOREACH
#                IF cl_null(l_ogb_out) THEN LET l_ogb_out = 0 END IF
#                IF cl_null(l_oeb_ord) THEN LET l_oeb_ord = 0 END IF
#                LET l_ogb_out1[i] = l_ogb_out1[i] + l_ogb_out
#                LET l_oeb_ord1[i] = l_oeb_ord1[i] + l_oeb_ord
#            END FOREACH
#        END FOR
# 
#    BEFORE GROUP OF sr.opc01     #No.FUN-670106
#       SKIP TO TOP OF PAGE       #No.FUN-670106
#
#    BEFORE GROUP OF sr.opc04
#        LET l_n = 1
#        LET l_sum = 0
#
#    AFTER GROUP OF sr.opc04
#        PRINTX name=D1 COLUMN g_c[31], sr.opc03;           #No.FUN-670106
#        FOREACH r170_cs2
#        USING sr.opc01,sr.opc02,sr.opc03,sr.opc04
#        INTO sr1.*
#            IF l_n = 1 THEN
#                FOR i = 1 TO 12
#                    IF sr1.opd06 >= l_opd[i].opd06 AND
#                       sr1.opd06 <= l_opd[i].opd07 THEN
#                      LET l_point = 10 + ((i-1)*15)                           
#                      LET l_n = 0
#                      LET l_n = i
#                       EXIT FOR
#                    END IF
#                END FOR
#                PRINTX name = D1 COLUMN g_c[31+l_n],cl_numfor(sr1.l_num,31+l_n,2);   #No.FUN-670106
#           ELSE
#                LET l_n = l_n + 1
#                IF l_n > 12 THEN EXIT FOREACH END IF
#                PRINTX name = D1 COLUMN g_c[31+l_n],cl_numfor(sr1.l_num,31+l_n,2);    #No.FUN-670106
#           END IF
#            LET l_sum = l_sum + sr1.l_num
#        END FOREACH
#        PRINTX name = D1 COLUMN g_c[44],cl_numfor(sr1.l_num,44,2)                      #No.FUN-670106
#    AFTER GROUP OF sr.opc01
#        LET l_ogb_sum = 0
#        LET l_oeb_sum = 0
##No.FUN-670106-----begin----- 
##        PRINT g_x[13] CLIPPED,' ';
##        FOR i = 1 TO 12
##             PRINT l_ogb_out1[i] USING "---,---,--&.&&",' ';
##             LET l_ogb_sum = l_ogb_sum + l_ogb_out1[i]
##        END FOR
##        PRINT l_ogb_sum USING "---,---,--&.&&"
#
#          LET l_emplname = g_x[13] CLIPPED                                                                                              
#          PRINTX name=D1 COLUMN g_c[31],l_emplname; 
#          FOR i = 1 TO 12
#             PRINTX name=D1 COLUMN g_c[31+i],cl_numfor(l_ogb_out1[i],31+i,2);
#             LET l_ogb_sum = l_ogb_sum + l_ogb_out1[i]  
#          END FOR
#          PRINTX name=D1 COLUMN g_c[44],cl_numfor(l_ogb_sum,44,2)
##        PRINT g_x[14] CLIPPED,' ';
##        FOR i = 1 TO 12
##             PRINT l_oeb_ord1[i] USING "---,---,--&.&&",' ';
##             LET l_oeb_sum = l_oeb_sum + l_oeb_ord1[i]
##        END FOR
##        PRINT l_oeb_sum USING "---,---,--&.&&"
#       LET l_emplname = g_x[14] CLIPPED                                                                                          
#          PRINTX name=D2 COLUMN g_c[31],l_emplname;                                                                                          
#          FOR i = 1 TO 12                                                                                                           
#             PRINTX name=D2 COLUMN g_c[31+i],cl_numfor(l_oeb_ord1[i],31+i,2);
#             LET l_oeb_sum = l_oeb_sum + l_oeb_ord1[i]                                                                                 
#          END FOR                                                                                                                   
#          PRINTX name=D2 COLUMN g_c[44],cl_numfor(l_oeb_sum,44,2)
#          PRINT g_dash2[1,g_len]
##No.FUN-670106-----End----- 
#    ON LAST ROW
#        IF g_zz05 = 'Y' THEN      # (80)-70,140,210,280   /   (132)-120,240,300
#        #    PRINT g_dash[1,g_len]
#        #   IF tm.wc[001,120] > ' ' THEN                      # for 132
#        #      PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#        #   IF tm.wc[121,240] > ' ' THEN
#        #       PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#        #   IF tm.wc[241,300] > ' ' THEN
#        #       PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#  	  #TQC-630166
#         PRINT g_dash      
#      CALL cl_prt_pos_wc(tm.wc)
#        END IF
#        PRINT g_dash[1,g_len]
#         LET l_last_sw = 'y'   
#        PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#       IF l_last_sw = 'n' THEN
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#       ELSE
#           SKIP 2 LINES
#       END IF
#
#END REPORT
#-----MOD-A50050---------
FUNCTION r170_set_entry()
  CALL cl_set_comp_entry("b_co",TRUE)   
END FUNCTION

FUNCTION r170_set_no_entry()
  IF tm.b <> '1' THEN 
     CALL cl_set_comp_entry("b_co",FALSE)   
  END IF
END FUNCTION
#-----END MOD-A50050-----
##Patch....NO.TQC-610037 <001,002,003> #
#NO.FUN-830054---end-----
