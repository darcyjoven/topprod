# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: axcr301.4gl
# Descriptions...: 兩月成本差異比較明細表
# Input parameter: 
# Return code....: 
# Date & Author..: 98/08/15 By apple
# Modify.........: No.FUN-4C0099 04/12/30 By kim 報表轉XML功能
# Modify.........: No.MOD-530122 05/03/16 By Carol QBE欄位順序調整
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/05 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.TQC-610051 06/02/23 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680122 06/09/01 By zdyllq 類型轉換  
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-7C0101 08/01/30 By douzh 成本改善功能增加成本計算類型(type)
# Modify.........: No.FUN-7B0048 08/04/10 By Sarah Input增加"人工","製費一","加工","製費二","製費三","製費四","製費五"的差異百分比,報表亦拆開顯示
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A40154 10/04/26 By Sarah 過濾差異百分比時不分正負號
# Modify.........: No:CHI-C30012 12/07/27 By bart 金額取位改抓ccz26
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                            #Print condition RECORD
           wc      LIKE type_file.chr1000,   #No.FUN-680122  VARCHAR(301)    # Where condition
           yy1,mm1 LIKE type_file.num5,      #No.FUN-680122SMALLINT,
           yy2,mm2 LIKE type_file.num5,      #No.FUN-680122SMALLINT,
           type    LIKE type_file.chr1,      #No.FUN-7C0101
           diff1   LIKE ccc_file.ccc23,      #No.FUN-680122DECIMAL(8,4),
           diff2   LIKE ccc_file.ccc23,      #No.FUN-680122DECIMAL(8,4),
           diff3   LIKE ccc_file.ccc23,      #No.FUN-680122DECIMAL(8,4),
           diff4   LIKE ccc_file.ccc23,      #FUN-7B0048 add
           diff5   LIKE ccc_file.ccc23,      #FUN-7B0048 add
           diff6   LIKE ccc_file.ccc23,      #FUN-7B0048 add
           diff7   LIKE ccc_file.ccc23,      #FUN-7B0048 add
           diff8   LIKE ccc_file.ccc23,      #FUN-7B0048 add
           diff9   LIKE ccc_file.ccc23,      #FUN-7B0048 add
           more    LIKE type_file.chr1       #No.FUN-680122 VARCHAR(1)       # Input more condition(Y/N)
           END RECORD,
       g_tot_bal LIKE nma_file.nma31         #No.FUN-680122DECIMAL(13,2)     # User defined variable
DEFINE bdate     LIKE type_file.dat          #No.FUN-680122DATE
DEFINE edate     LIKE type_file.dat          #No.FUN-680122DATE
DEFINE g_sql	 STRING                      #No.FUN-580092 HCN
DEFINE g_argv1   LIKE type_file.chr20        #No.FUN-680122CHAR(20)
DEFINE g_argv2   LIKE type_file.num5         #No.FUN-680122SMALLINT
DEFINE g_argv3   LIKE type_file.num5         #No.FUN-680122SMALLINT
DEFINE g_argv4   LIKE type_file.num5         #No.FUN-680122SMALLINT
DEFINE g_argv5   LIKE type_file.num5         #No.FUN-680122SMALLINT
DEFINE l_table   STRING                      #FUN-7B0048 add
DEFINE g_str     STRING                      #FUN-7B0048 add
 
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
  #str FUN-7B0048 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "ccc01.ccc_file.ccc01,",
               "ima02.ima_file.ima02,     ima021.ima_file.ima021,",
               "sr1_ccc08.ccc_file.ccc08, sr2_ccc08.ccc_file.ccc08,",
               "sr1_ccc23.ccc_file.ccc23, sr2_ccc23.ccc_file.ccc23,",
               "diff1.ccc_file.ccc23,     diffper1.ccc_file.ccc23,",
               "sr1_ccc23a.ccc_file.ccc23,sr2_ccc23a.ccc_file.ccc23,",
               "diff2.ccc_file.ccc23,     diffper2.ccc_file.ccc23,",
               "sr1_ccc23b.ccc_file.ccc23,sr2_ccc23b.ccc_file.ccc23,",
               "diff3.ccc_file.ccc23,     diffper3.ccc_file.ccc23,",
               "sr1_ccc23c.ccc_file.ccc23,sr2_ccc23c.ccc_file.ccc23,",
               "diff4.ccc_file.ccc23,     diffper4.ccc_file.ccc23,",
               "sr1_ccc23d.ccc_file.ccc23,sr2_ccc23d.ccc_file.ccc23,",
               "diff5.ccc_file.ccc23,     diffper5.ccc_file.ccc23,",
               "sr1_ccc23e.ccc_file.ccc23,sr2_ccc23e.ccc_file.ccc23,",
               "diff6.ccc_file.ccc23,     diffper6.ccc_file.ccc23,",
               "sr1_ccc23f.ccc_file.ccc23,sr2_ccc23f.ccc_file.ccc23,",
               "diff7.ccc_file.ccc23,     diffper7.ccc_file.ccc23,",
               "sr1_ccc23g.ccc_file.ccc23,sr2_ccc23g.ccc_file.ccc23,",
               "diff8.ccc_file.ccc23,     diffper8.ccc_file.ccc23,",
               "sr1_ccc23h.ccc_file.ccc23,sr2_ccc23h.ccc_file.ccc23,",
               "diff9.ccc_file.ccc23,     diffper9.ccc_file.ccc23"
 
   LET l_table = cl_prt_temptable('axcr301',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
  #end FUN-7B0048 add
 
   #TQC-610051-begin
   #INITIALIZE tm.* TO NULL            # Default condition
   #LET tm.more = 'N'
   #LET g_pdate = g_today
   #LET g_rlang = g_lang
   #LET g_bgjob = 'N'
   #LET g_copies = '1'
   #LET g_argv1 = ARG_VAL(1)        # Get arguments from command line
   #LET g_argv2 = ARG_VAL(2)        # Get arguments from command line
   #LET g_argv3 = ARG_VAL(3)        # Get arguments from command line
   #LET g_argv4 = ARG_VAL(4)        # Get arguments from command line
   #LET g_argv5 = ARG_VAL(5)        # Get arguments from command line
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(6)
   #LET g_rep_clas = ARG_VAL(7)
   #LET g_template = ARG_VAL(8)
   ##No.FUN-570264 ---end---
   LET g_pdate  = ARG_VAL(1)       # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)       # Get arguments from command line
   LET tm.yy1   = ARG_VAL(8)       # Get arguments from command line
   LET tm.mm1   = ARG_VAL(9)       # Get arguments from command line
   LET tm.yy2   = ARG_VAL(10)      # Get arguments from command line
   LET tm.mm2   = ARG_VAL(11)      # Get arguments from command line
   LET tm.type  = ARG_VAL(12)      #No.FUN-7C0101
   LET tm.diff1 = ARG_VAL(13)
   LET tm.diff2 = ARG_VAL(14)
   LET tm.diff3 = ARG_VAL(15)
   LET tm.diff4 = ARG_VAL(16)      #FUN-7B0048 add
   LET tm.diff5 = ARG_VAL(17)      #FUN-7B0048 add
   LET tm.diff6 = ARG_VAL(18)      #FUN-7B0048 add
   LET tm.diff7 = ARG_VAL(19)      #FUN-7B0048 add
   LET tm.diff8 = ARG_VAL(20)      #FUN-7B0048 add
   LET tm.diff9 = ARG_VAL(21)      #FUN-7B0048 add
   LET g_rep_user = ARG_VAL(22)
   LET g_rep_clas = ARG_VAL(23)
   LET g_template = ARG_VAL(24)
   LET g_rpt_name = ARG_VAL(25)  #No.FUN-7C0078
   #IF cl_null(g_argv1)
   # Prog. Version..: '5.30.06-13.03.12(0,0)        # Input print condition
   #   ELSE LET tm.wc=" ima01='",g_argv1,"'"
   #        LET tm.yy1=g_argv2
   #        LET tm.mm1=g_argv3
   #        LET tm.yy2=g_argv4
   #        LET tm.mm2=g_argv5
   #        CALL axcr301()            # Read data and create out-file
   #END IF
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL axcr301_tm(0,0)
      ELSE CALL axcr301()
   END IF
   #TQC-610051-end
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr301_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01        #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5        #No.FUN-680122 SMALLINT
   DEFINE l_cmd          LIKE type_file.chr1000     #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE 
      LET p_row = 4 LET p_col = 15
   END IF
   OPEN WINDOW axcr301_w AT p_row,p_col WITH FORM "axc/42f/axcr301"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   #TQC-610051-begin
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #TQC-610051-end
 
   WHILE TRUE
 #MOD-530122
      CONSTRUCT BY NAME tm.wc ON ima01,ima12,ima06,ima10,
                              ima57,ima08,ima09,ima11                             
##
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
 
        #No.FUN-570240 --start                                                          
         ON ACTION CONTROLP                                                      
            IF INFIELD(ima01) THEN                                              
               CALL cl_init_qry_var()                                           
               LET g_qryparam.form = "q_ima"                                    
               LET g_qryparam.state = "c"                                       
               CALL cl_create_qry() RETURNING g_qryparam.multiret               
               DISPLAY g_qryparam.multiret TO ima01                             
               NEXT FIELD ima01                                                 
            END IF                                                              
        #No.FUN-570240 --end     
 
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW axcr301_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
      END IF
 
      LET tm.diff1=0  LET tm.diff2=0  LET tm.diff3=0
      LET tm.diff4=0  LET tm.diff5=0  LET tm.diff6=0   #FUN-7B0048 add
      LET tm.diff7=0  LET tm.diff8=0  LET tm.diff9=0   #FUN-7B0048 add
      LET tm.type = g_ccz.ccz28
      INPUT BY NAME tm.yy1,tm.mm1,tm.yy2,tm.mm2,tm.type,
                    tm.diff1,tm.diff2,tm.diff3,
                    tm.diff4,tm.diff5,tm.diff6,        #FUN-7B0048 add
                    tm.diff7,tm.diff8,tm.diff9,        #FUN-7B0048 add
                    tm.more
            WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
         AFTER FIELD yy1
            IF tm.yy1 IS NULL THEN NEXT FIELD yy1 END IF
         AFTER FIELD mm1
            IF tm.mm1 IS NULL THEN NEXT FIELD mm1 END IF
         AFTER FIELD yy2
            IF tm.yy2 IS NULL THEN NEXT FIELD yy2 END IF
         AFTER FIELD mm2
            IF tm.mm2 IS NULL THEN NEXT FIELD mm2 END IF
         AFTER FIELD type                                                            #No.FUN-7C0101
            IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF             #No.FUN-7C0101
         AFTER FIELD diff1
            IF tm.diff1 < 0 OR tm.diff1 IS NULL THEN NEXT FIELD diff1 END IF
         AFTER FIELD diff2
            IF tm.diff2 < 0 OR tm.diff2 IS NULL THEN NEXT FIELD diff2 END IF
         AFTER FIELD diff3
            IF tm.diff3 < 0 OR tm.diff3 IS NULL THEN NEXT FIELD diff3 END IF
        #str FUN-7B0048 add
         AFTER FIELD diff4
            IF tm.diff4 < 0 OR tm.diff4 IS NULL THEN NEXT FIELD diff4 END IF
         AFTER FIELD diff5
            IF tm.diff5 < 0 OR tm.diff5 IS NULL THEN NEXT FIELD diff5 END IF
         AFTER FIELD diff6
            IF tm.diff6 < 0 OR tm.diff6 IS NULL THEN NEXT FIELD diff6 END IF
         AFTER FIELD diff7
            IF tm.diff7 < 0 OR tm.diff7 IS NULL THEN NEXT FIELD diff7 END IF
         AFTER FIELD diff8
            IF tm.diff8 < 0 OR tm.diff8 IS NULL THEN NEXT FIELD diff8 END IF
         AFTER FIELD diff9
            IF tm.diff9 < 0 OR tm.diff9 IS NULL THEN NEXT FIELD diff9 END IF
        #end FUN-7B0048 add
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
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
         LET INT_FLAG = 0 CLOSE WINDOW axcr301_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
                WHERE zz01='axcr301'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('axcr301','9031',1)   
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
                       #TQC-610051-begin
                        " '", tm.yy1 CLIPPED,"'",
                        " '", tm.mm1 CLIPPED,"'",
                        " '", tm.yy2 CLIPPED,"'",
                        " '", tm.mm2 CLIPPED,"'",
                        " '", tm.type CLIPPED,"'",        #No.FUN-7C0101
                        " '", tm.diff1 CLIPPED,"'",
                        " '", tm.diff2 CLIPPED,"'",
                        " '", tm.diff3 CLIPPED,"'",
                       #TQC-610051-end
                        " '", tm.diff4 CLIPPED,"'",       #FUN-7B0048 add
                        " '", tm.diff5 CLIPPED,"'",       #FUN-7B0048 add
                        " '", tm.diff6 CLIPPED,"'",       #FUN-7B0048 add
                        " '", tm.diff7 CLIPPED,"'",       #FUN-7B0048 add
                        " '", tm.diff8 CLIPPED,"'",       #FUN-7B0048 add
                        " '", tm.diff9 CLIPPED,"'",       #FUN-7B0048 add
                        " '",g_rep_user CLIPPED,"'",      #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",      #No.FUN-570264
                        " '",g_template CLIPPED,"'",      #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('axcr301',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW axcr301_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL axcr301()
      ERROR ""
   END WHILE
   CLOSE WINDOW axcr301_w
END FUNCTION
 
FUNCTION axcr301()
   DEFINE l_name     LIKE type_file.chr20,       #No.FUN-680122CHAR(20)      # External(Disk) file name
#         l_time     LIKE type_file.chr8         #No.FUN-6A0146
          l_sql      LIKE type_file.chr1000,     #RDSQL STATEMENT        #No.FUN-680122CHAR(600)
          l_chr      LIKE type_file.chr1,        #No.FUN-680122 VARCHAR(1)
          u_sign     LIKE type_file.num5,        #No.FUN-680122SMALLINT,
          l_diffper1 LIKE ccc_file.ccc23,        #No.FUN-680122DECIMAL(8,4)
          l_diffper2 LIKE ccc_file.ccc23,        #No.FUN-680122DECIMAL(8,4)
          l_diffper3 LIKE ccc_file.ccc23,        #No.FUN-680122DECIMAL(8,4)
          l_diffper4 LIKE ccc_file.ccc23,        #FUN-7B0048 add
          l_diffper5 LIKE ccc_file.ccc23,        #FUN-7B0048 add
          l_diffper6 LIKE ccc_file.ccc23,        #FUN-7B0048 add
          l_diffper7 LIKE ccc_file.ccc23,        #FUN-7B0048 add
          l_diffper8 LIKE ccc_file.ccc23,        #FUN-7B0048 add
          l_diffper9 LIKE ccc_file.ccc23,        #FUN-7B0048 add
          t_diffper1 LIKE ccc_file.ccc23,        #MOD-A40154 add
          t_diffper2 LIKE ccc_file.ccc23,        #MOD-A40154 add
          t_diffper3 LIKE ccc_file.ccc23,        #MOD-A40154 add
          t_diffper4 LIKE ccc_file.ccc23,        #MOD-A40154 add
          t_diffper5 LIKE ccc_file.ccc23,        #MOD-A40154 add
          t_diffper6 LIKE ccc_file.ccc23,        #MOD-A40154 add
          t_diffper7 LIKE ccc_file.ccc23,        #MOD-A40154 add
          t_diffper8 LIKE ccc_file.ccc23,        #MOD-A40154 add
          t_diffper9 LIKE ccc_file.ccc23,        #MOD-A40154 add
          l_sfb99    LIKE sfb_file.sfb99,        #No.FUN-680122CHAR(1)
          l_za05     LIKE type_file.chr1000,     #No.FUN-680122 VARCHAR(40)
          l_order    ARRAY[5] OF LIKE type_file.chr20,          #No.FUN-680122CHAR(20)
          l_diff1    LIKE ccc_file.ccc23,
          l_diff2    LIKE ccc_file.ccc23,
          l_diff3    LIKE ccc_file.ccc23,
          l_diff4    LIKE ccc_file.ccc23,        #FUN-7B0048 add
          l_diff5    LIKE ccc_file.ccc23,        #FUN-7B0048 add
          l_diff6    LIKE ccc_file.ccc23,        #FUN-7B0048 add
          l_diff7    LIKE ccc_file.ccc23,        #FUN-7B0048 add
          l_diff8    LIKE ccc_file.ccc23,        #FUN-7B0048 add
          l_diff9    LIKE ccc_file.ccc23,        #FUN-7B0048 add
          l_ima01    LIKE ima_file.ima01,
          l_ima02    LIKE ima_file.ima02,        #FUN-7B0048 add
          l_ima021   LIKE ima_file.ima021,       #FUN-7B0048 add
          sr1        RECORD 
                      ccc01   LIKE ccc_file.ccc01,
                      ccc02   LIKE ccc_file.ccc02,
                      ccc03   LIKE ccc_file.ccc03,
                      ccc08   LIKE ccc_file.ccc08,           #No.FUN-7C0101         
                      ccc23   LIKE ccc_file.ccc23,
                      ccc23a  LIKE ccc_file.ccc23a,
                      ccc23b  LIKE ccc_file.ccc23b,
                      ccc23c  LIKE ccc_file.ccc23c,
                      ccc23d  LIKE ccc_file.ccc23d,
                      ccc23e  LIKE ccc_file.ccc23e,
                      ccc23f  LIKE ccc_file.ccc23f,          #No.FUN-7C0101
                      ccc23g  LIKE ccc_file.ccc23g,          #No.FUN-7C0101
                      ccc23h  LIKE ccc_file.ccc23h,          #No.FUN-7C0101
                      expcost LIKE ccc_file.ccc23  
                     END RECORD,
          sr2        RECORD 
                      ccc01   LIKE ccc_file.ccc01,
                      ccc02   LIKE ccc_file.ccc02,
                      ccc03   LIKE ccc_file.ccc03,
                      ccc08   LIKE ccc_file.ccc08,           #No.FUN-7C0101         
                      ccc23   LIKE ccc_file.ccc23,
                      ccc23a  LIKE ccc_file.ccc23a,
                      ccc23b  LIKE ccc_file.ccc23b,
                      ccc23c  LIKE ccc_file.ccc23c,
                      ccc23d  LIKE ccc_file.ccc23d,
                      ccc23e  LIKE ccc_file.ccc23e,
                      ccc23f  LIKE ccc_file.ccc23f,          #No.FUN-7C0101
                      ccc23g  LIKE ccc_file.ccc23g,          #No.FUN-7C0101
                      ccc23h  LIKE ccc_file.ccc23h,          #No.FUN-7C0101
                      expcost LIKE ccc_file.ccc23  
                     END RECORD
 
  #str FUN-7B0048 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
  #end FUN-7B0048 add
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #FUN-7B0048 add
 
  #str FUN-7B0048 mark
  #CALL cl_outnam('axcr301') RETURNING l_name
  #
  ##No.FUN-7C0101--begin
  # IF tm.type MATCHES '[12]' THEN
  #    LET g_zaa[34].zaa06 = "Y" 
  # ELSE
  #    LET g_zaa[34].zaa06 = "N"
  # END IF
  # CALL cl_prt_pos_len()
  ##No.FUN-7C0101--end
  #
  #START REPORT axcr301_rep TO l_name
  #LET g_pageno = 0
  #end FUN-7B0048 mark
 
   LET l_sql = "SELECT ima01 FROM ima_file ", 
               " WHERE ",tm.wc CLIPPED
   PREPARE axcr301_prepare1 FROM l_sql
   DECLARE axcr301_curs1 CURSOR WITH HOLD FOR axcr301_prepare1
   FOREACH axcr301_curs1 INTO l_ima01
      IF STATUS THEN CALL cl_err('foreach1:',STATUS,1) EXIT FOREACH END IF
     #str FUN-7B0048 add
      #品名、規格
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
       WHERE ima01 = l_ima01
      IF SQLCA.sqlcode THEN
         LET l_ima02 = ' '
         LET l_ima021= ' '
      END IF
     #end FUN-7B0048 add
 
      #----->取基準月份
      SELECT ccc08,ccc23,ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,ccc23f,ccc23g,ccc23h            #No.FUN-7C0101
        INTO sr1.ccc08,sr1.ccc23,sr1.ccc23a,sr1.ccc23b,sr1.ccc23c,sr1.ccc23d,sr1.ccc23e,    #No.FUN-7C0101
             sr1.ccc23f,sr1.ccc23g,sr1.ccc23h                                               #No.FUN-7C0101  
        FROM ccc_file 
        WHERE ccc01 = l_ima01 AND ccc02 = tm.yy1  AND ccc03 = tm.mm1 
          AND ccc07 = tm.type                                                               #No.FUN-7C0101
      IF SQLCA.sqlcode THEN 
         LET sr1.ccc23  = 0  
         LET sr1.ccc23a = 0  LET sr1.ccc23b = 0
         LET sr1.ccc23c = 0  LET sr1.ccc23d = 0 
         LET sr1.ccc23e = 0  LET sr1.ccc23f = 0 
         LET sr1.ccc23g = 0  LET sr1.ccc23h = 0                                             #No.FUN-7C0101  
      ELSE 
         LET sr1.ccc01   = l_ima01
         LET sr1.ccc02   = tm.yy1
         LET sr1.ccc03   = tm.mm1
        #LET sr1.expcost = sr1.ccc23b + sr1.ccc23c + sr1.ccc23d + sr1.ccc23e                #No.FUN-7C0101   #FUN-7B0048 mark
        #                + sr1.ccc23f + sr1.ccc23g + sr1.ccc23h                             #No.FUN-7C0101   #FUN-7B0048 mark
      END IF
      #----->取比較月份
      SELECT ccc08,ccc23,ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,ccc23f,ccc23g,ccc23h            #No.FUN-7C0101
        INTO sr2.ccc08,sr2.ccc23,sr2.ccc23a,sr2.ccc23b,sr2.ccc23c,sr2.ccc23d,sr2.ccc23e,    #No.FUN-7C0101
             sr2.ccc23f,sr2.ccc23g,sr2.ccc23h                                               #No.FUN-7C0101  
        FROM ccc_file 
        WHERE ccc01 = l_ima01 AND ccc02 = tm.yy2  AND ccc03 = tm.mm2 
          AND ccc07 = tm.type                                                               #No.FUN-7C0101
      IF SQLCA.sqlcode THEN 
         LET sr2.ccc23  = 0  
         LET sr2.ccc23a = 0  LET sr2.ccc23b = 0
         LET sr2.ccc23c = 0  LET sr2.ccc23d = 0 
         LET sr2.ccc23e = 0  LET sr2.ccc23f = 0                                             #No.FUN-7C0101 
         LET sr2.ccc23g = 0  LET sr2.ccc23h = 0                                             #No.FUN-7C0101  
      ELSE 
         LET sr2.ccc01   = l_ima01
         LET sr2.ccc02   = tm.yy2
         LET sr2.ccc03   = tm.mm2
        #LET sr2.expcost = sr2.ccc23b + sr2.ccc23c + sr2.ccc23d + sr2.ccc23e                #No.FUN-7C0101   #FUN-7B0048 mark 
        #                + sr2.ccc23f + sr2.ccc23g + sr2.ccc23h                             #No.FUN-7C0101   #FUN-7B0048 mark
      END IF
      #--->單位成本
     #IF not cl_null(tm.diff1) THEN                  #FUN-7B0048 mark
     #   IF sr1.ccc23 != 0 AND sr2.ccc23 != 0 THEN   #FUN-7B0048 mark 
            LET l_diff1 = sr2.ccc23 - sr1.ccc23      #FUN-7B0048 add
            LET l_diffper1= ((sr2.ccc23 - sr1.ccc23)/sr1.ccc23) * 100
     #str FUN-7B0048 mark
     #      IF l_diffper1 < 0 THEN LET l_diff1 = l_diff1 * -1 END IF
     #      IF l_diffper1 >= tm.diff1 THEN 
     #         OUTPUT TO REPORT axcr301_rep(sr1.*,sr2.*)
     #         CONTINUE FOREACH 
     #      END IF
     #   END IF
     #END IF
     #end FUN-7B0048 mark
      #--->材料成本
     #IF not cl_null(tm.diff2) THEN                    #FUN-7B0048 mark
     #   IF sr1.ccc23a != 0 AND sr2.ccc23a != 0 THEN   #FUN-7B0048 mark 
            LET l_diff2 = sr2.ccc23a - sr1.ccc23a      #FUN-7B0048 add
            LET l_diffper2= ((sr2.ccc23a - sr1.ccc23a)/sr1.ccc23a) * 100
     #str FUN-7B0048 mark
     #      IF l_diffper2 < 0 THEN LET l_diff2 = l_diff2 * -1 END IF
     #      IF l_diffper2 >= tm.diff2 THEN 
     #         OUTPUT TO REPORT axcr301_rep(sr1.*,sr2.*)
     #         CONTINUE FOREACH 
     #      END IF
     #   END IF
     #END IF
     ##--->非材料成本
     #IF sr1.expcost != 0 AND sr2.expcost != 0 THEN 
     #   LET l_diffper3= ((sr2.expcost - sr1.expcost)/sr1.expcost) * 100
     #   IF l_diffper3 < 0 THEN LET l_diff3 = l_diff3 * -1 END IF
     #   IF l_diffper3 >= tm.diff3 THEN 
     #      OUTPUT TO REPORT axcr301_rep(sr1.*,sr2.*)
     #      CONTINUE FOREACH 
     #   END IF
     #END IF
     #end FUN-7B0048 mark
     #str FUN-7B0048 add
      #--->人工成本
      LET l_diff3 = sr2.ccc23b - sr1.ccc23b
      LET l_diffper3= ((sr2.ccc23b - sr1.ccc23b)/sr1.ccc23b) * 100
      #--->製費一成本
      LET l_diff4 = sr2.ccc23c - sr1.ccc23c
      LET l_diffper4= ((sr2.ccc23c - sr1.ccc23c)/sr1.ccc23c) * 100
      #--->加工成本
      LET l_diff5 = sr2.ccc23d - sr1.ccc23d
      LET l_diffper5= ((sr2.ccc23d - sr1.ccc23d)/sr1.ccc23d) * 100
      #--->製費二成本
      LET l_diff6 = sr2.ccc23e - sr1.ccc23e
      LET l_diffper6= ((sr2.ccc23e - sr1.ccc23e)/sr1.ccc23e) * 100
      #--->製費三成本
      LET l_diff7 = sr2.ccc23f - sr1.ccc23f
      LET l_diffper7= ((sr2.ccc23f - sr1.ccc23f)/sr1.ccc23f) * 100
      #--->製費四成本
      LET l_diff8 = sr2.ccc23g - sr1.ccc23g
      LET l_diffper8= ((sr2.ccc23g - sr1.ccc23g)/sr1.ccc23g) * 100
      #--->製費五成本
      LET l_diff9 = sr2.ccc23h - sr1.ccc23h
      LET l_diffper9= ((sr2.ccc23h - sr1.ccc23h)/sr1.ccc23h) * 100
      IF cl_null(l_diff1) THEN LET l_diff1 = 0 END IF
      IF cl_null(l_diff2) THEN LET l_diff2 = 0 END IF
      IF cl_null(l_diff3) THEN LET l_diff3 = 0 END IF
      IF cl_null(l_diff4) THEN LET l_diff4 = 0 END IF
      IF cl_null(l_diff5) THEN LET l_diff5 = 0 END IF
      IF cl_null(l_diff6) THEN LET l_diff6 = 0 END IF
      IF cl_null(l_diff7) THEN LET l_diff7 = 0 END IF
      IF cl_null(l_diff8) THEN LET l_diff8 = 0 END IF
      IF cl_null(l_diff9) THEN LET l_diff9 = 0 END IF
      IF cl_null(l_diffper1) THEN LET l_diffper1 = 0 END IF
      IF cl_null(l_diffper2) THEN LET l_diffper2 = 0 END IF
      IF cl_null(l_diffper3) THEN LET l_diffper3 = 0 END IF
      IF cl_null(l_diffper4) THEN LET l_diffper4 = 0 END IF
      IF cl_null(l_diffper5) THEN LET l_diffper5 = 0 END IF
      IF cl_null(l_diffper6) THEN LET l_diffper6 = 0 END IF
      IF cl_null(l_diffper7) THEN LET l_diffper7 = 0 END IF
      IF cl_null(l_diffper8) THEN LET l_diffper8 = 0 END IF
      IF cl_null(l_diffper9) THEN LET l_diffper9 = 0 END IF
     #str MOD-A40154 add
      LET t_diffper1 = l_diffper1
      LET t_diffper2 = l_diffper2
      LET t_diffper3 = l_diffper3
      LET t_diffper4 = l_diffper4
      LET t_diffper5 = l_diffper5
      LET t_diffper6 = l_diffper6
      LET t_diffper7 = l_diffper7
      LET t_diffper8 = l_diffper8
      LET t_diffper9 = l_diffper9
      IF t_diffper1<0 THEN LET t_diffper1=t_diffper1*-1 END IF
      IF t_diffper2<0 THEN LET t_diffper2=t_diffper2*-1 END IF
      IF t_diffper3<0 THEN LET t_diffper3=t_diffper3*-1 END IF
      IF t_diffper4<0 THEN LET t_diffper4=t_diffper4*-1 END IF
      IF t_diffper5<0 THEN LET t_diffper5=t_diffper5*-1 END IF
      IF t_diffper6<0 THEN LET t_diffper6=t_diffper6*-1 END IF
      IF t_diffper7<0 THEN LET t_diffper7=t_diffper7*-1 END IF
      IF t_diffper8<0 THEN LET t_diffper8=t_diffper8*-1 END IF
      IF t_diffper9<0 THEN LET t_diffper9=t_diffper9*-1 END IF
     #end MOD-A40154 add
      IF sr1.ccc23 != 0 OR sr2.ccc23 != 0 OR
         sr1.ccc23a!= 0 OR sr2.ccc23a!= 0 OR
         sr1.ccc23b!= 0 OR sr2.ccc23b!= 0 OR
         sr1.ccc23c!= 0 OR sr2.ccc23c!= 0 OR
         sr1.ccc23d!= 0 OR sr2.ccc23d!= 0 OR
         sr1.ccc23e!= 0 OR sr2.ccc23e!= 0 OR
         sr1.ccc23f!= 0 OR sr2.ccc23f!= 0 OR
         sr1.ccc23g!= 0 OR sr2.ccc23g!= 0 OR
         sr1.ccc23h!= 0 OR sr2.ccc23h!= 0 THEN   #排除單價都是0的資料
         IF (tm.diff1=0 AND tm.diff2=0 AND tm.diff3=0 AND
             tm.diff4=0 AND tm.diff5=0 AND tm.diff6=0 AND
             tm.diff7=0 AND tm.diff8=0 AND tm.diff9=0) OR
            (tm.diff1!= 0 AND t_diffper1>= tm.diff1) OR    #MOD-A40154 mod l_diffper1->t_diffper1
            (tm.diff2!= 0 AND t_diffper2>= tm.diff2) OR    #MOD-A40154 mod l_diffper2->t_diffper2
            (tm.diff3!= 0 AND t_diffper3>= tm.diff3) OR    #MOD-A40154 mod l_diffper3->t_diffper3
            (tm.diff4!= 0 AND t_diffper4>= tm.diff4) OR    #MOD-A40154 mod l_diffper4->t_diffper4
            (tm.diff5!= 0 AND t_diffper5>= tm.diff5) OR    #MOD-A40154 mod l_diffper5->t_diffper5
            (tm.diff6!= 0 AND t_diffper6>= tm.diff6) OR    #MOD-A40154 mod l_diffper6->t_diffper6
            (tm.diff7!= 0 AND t_diffper7>= tm.diff7) OR    #MOD-A40154 mod l_diffper7->t_diffper7
            (tm.diff8!= 0 AND t_diffper8>= tm.diff8) OR    #MOD-A40154 mod l_diffper8->t_diffper8
            (tm.diff9!= 0 AND t_diffper9>= tm.diff9) THEN  #MOD-A40154 mod l_diffper9->t_diffper9
            EXECUTE insert_prep USING
               l_ima01,l_ima02,l_ima021,sr1.ccc08,sr2.ccc08,
               sr1.ccc23 ,sr2.ccc23, l_diff1,l_diffper1,
               sr1.ccc23a,sr2.ccc23a,l_diff2,l_diffper2,
               sr1.ccc23b,sr2.ccc23b,l_diff3,l_diffper3,
               sr1.ccc23c,sr2.ccc23c,l_diff4,l_diffper4,
               sr1.ccc23d,sr2.ccc23d,l_diff5,l_diffper5,
               sr1.ccc23e,sr2.ccc23e,l_diff6,l_diffper6,
               sr1.ccc23f,sr2.ccc23f,l_diff7,l_diffper7,
               sr1.ccc23g,sr2.ccc23g,l_diff8,l_diffper8,
               sr1.ccc23h,sr2.ccc23h,l_diff9,l_diffper9
         END IF
      END IF
     #end FUN-7B0048 add
   END FOREACH
 
  #str FUN-7B0048 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'ima01,ima12,ima06,ima10,ima57,ima08,ima09,ima11')
           RETURNING tm.wc
   ELSE
      LET tm.wc=' '
   END IF
   #           p1        p2         p3         p4         p5
   LET g_str=tm.wc,";",tm.yy1,";",tm.mm1,";",tm.yy2,";",tm.mm2,";",
   #            p6          p7           p8          p9          p10
             tm.type,";",tm.diff1,";",tm.diff2,";",tm.diff3,";",tm.diff4,";",
   #            p11          p12          p13          p14          p15
             tm.diff5,";",tm.diff6,";",tm.diff7,";",tm.diff8,";",tm.diff9,";",
   #           p16
             #g_azi03     #CHI-C30012
             g_ccz.ccz26  #CHI-C30012
   CALL cl_prt_cs3('axcr301','axcr301',g_sql,g_str)
  #end FUN-7B0048 add
 
  #FINISH REPORT axcr301_rep   #FUN-7B0048 mark
 
  #CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #FUN-7B0048 mark
END FUNCTION
 
#str FUN-7B0048 mark
#REPORT axcr301_rep(sr1,sr2)
#   DEFINE l_last_sw     LIKE type_file.chr1,         #No.FUN-680122CHAR(1)
#          l_diff1       LIKE ccc_file.ccc23,
#          l_diff2       LIKE ccc_file.ccc23,
#          l_diff3       LIKE ccc_file.ccc23,
#          l_diffper1    LIKE ccc_file.ccc23,         #No.FUN-680122DECIMAL(8,4)
#          l_diffper2    LIKE ccc_file.ccc23,         #No.FUN-680122DECIMAL(8,4)
#          l_diffper3    LIKE ccc_file.ccc23,         #No.FUN-680122DECIMAL(8,4)
#          l_ima02       LIKE ima_file.ima02,
#          l_ima021      LIKE ima_file.ima021,
#          sr1           RECORD 
#                         ccc01   LIKE ccc_file.ccc01,
#                         ccc02   LIKE ccc_file.ccc02,
#                         ccc03   LIKE ccc_file.ccc03,
#                         ccc08   LIKE ccc_file.ccc08,           #No.FUN-7C0101         
#                         ccc23   LIKE ccc_file.ccc23,
#                         ccc23a  LIKE ccc_file.ccc23a,
#                         ccc23b  LIKE ccc_file.ccc23b,
#                         ccc23c  LIKE ccc_file.ccc23c,
#                         ccc23d  LIKE ccc_file.ccc23d,
#                         ccc23e  LIKE ccc_file.ccc23e,
#                         ccc23f  LIKE ccc_file.ccc23f,          #No.FUN-7C0101
#                         ccc23g  LIKE ccc_file.ccc23g,          #No.FUN-7C0101
#                         ccc23h  LIKE ccc_file.ccc23h,          #No.FUN-7C0101
#                         expcost LIKE ccc_file.ccc23
#                        END RECORD,
#          sr2           RECORD 
#                         ccc01   LIKE ccc_file.ccc01,
#                         ccc02   LIKE ccc_file.ccc02,
#                         ccc03   LIKE ccc_file.ccc03,
#                         ccc08   LIKE ccc_file.ccc08,           #No.FUN-7C0101         
#                         ccc23   LIKE ccc_file.ccc23,
#                         ccc23a  LIKE ccc_file.ccc23a,
#                         ccc23b  LIKE ccc_file.ccc23b,
#                         ccc23c  LIKE ccc_file.ccc23c,
#                         ccc23d  LIKE ccc_file.ccc23d,
#                         ccc23e  LIKE ccc_file.ccc23e,
#                         ccc23f  LIKE ccc_file.ccc23f,          #No.FUN-7C0101
#                         ccc23g  LIKE ccc_file.ccc23g,          #No.FUN-7C0101
#                         ccc23h  LIKE ccc_file.ccc23h,          #No.FUN-7C0101
#                         expcost LIKE ccc_file.ccc23
#                        END RECORD,
#          l_chr         LIKE type_file.chr1000        #No.FUN-680122 VARCHAR(100)   #MOD-470427
# 
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY sr1.ccc01 
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED,pageno_total
#       #MOD-470427
#      LET l_chr=g_x[9],tm.yy1 USING '&&&&','/',tm.mm1 USING '&&','  ',
#                g_x[10],tm.yy2 USING '&&&&','/',tm.mm2 USING '&&'
#      #--
#      PRINT COLUMN (g_len-FGL_WIDTH(l_chr))/2,l_chr CLIPPED
#      PRINT g_dash
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#            g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46]                  #No.FUN-7C0101
#      PRINT g_dash1
#      LET l_last_sw = 'n'
# 
#   AFTER GROUP OF sr1.ccc01
#      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file 
#         WHERE ima01 = sr1.ccc01
#      IF SQLCA.sqlcode THEN 
#         LET l_ima02 = ' ' 
#         LET l_ima021= ' '
#      END IF
#      LET l_diff1 = sr2.ccc23 - sr1.ccc23
#      LET l_diffper1= ((sr2.ccc23 - sr1.ccc23)/sr1.ccc23) * 100
# 
#      LET l_diff2 = sr2.ccc23a - sr1.ccc23a
#      IF sr1.ccc23a!=0 THEN
#         LET l_diffper2= ((sr2.ccc23a - sr1.ccc23a)/sr1.ccc23a) * 100
#      ELSE
#         LET l_diffper2=0
#      END IF
# 
#      LET l_diff3 = sr2.expcost - sr1.expcost
#      IF sr1.expcost!=0 THEN
#         LET l_diffper3= ((sr2.expcost - sr1.expcost)/sr1.expcost) * 100
#      ELSE
#         LET l_diffper3=0 
#      END IF
#  #No.FUN-7C0101--modify -begin
#      PRINT COLUMN g_c[31],sr1.ccc01,
#            COLUMN g_c[32],l_ima02,
#            COLUMN g_c[33],l_ima021,
#            COLUMN g_c[34],sr1.ccc08,
#            COLUMN g_c[35],cl_numfor(sr1.ccc23,35,g_azi03),    #FUN-570190
#            COLUMN g_c[36],cl_numfor(sr2.ccc23,36,g_azi03),    #FUN-570190
#            COLUMN g_c[37],cl_numfor(l_diff1,37,g_azi03),    #FUN-570190
#            COLUMN g_c[38],l_diffper1  USING '--&.&&&',
#            COLUMN g_c[39],cl_numfor(sr1.ccc23a,39,g_azi03),    #FUN-570190
#            COLUMN g_c[40],cl_numfor(sr2.ccc23a,40,g_azi03),    #FUN-570190
#            COLUMN g_c[41],cl_numfor(l_diff2,41,g_azi03),    #FUN-570190
#            COLUMN g_c[42],l_diffper2  USING '--&.&&&',
#            COLUMN g_c[43],cl_numfor(sr1.expcost,43,g_azi03),    #FUN-570190
#            COLUMN g_c[44],cl_numfor(sr2.expcost,44,g_azi03),    #FUN-570190
#            COLUMN g_c[45],cl_numfor(l_diff3,45,g_azi03),    #FUN-570190
#            COLUMN g_c[46],l_diffper3  USING '----&.&&&'
#  #No.FUN-7C0101--modify-end
# 
#   PAGE TRAILER
#      PRINT g_dash
#      IF l_last_sw = 'n'
#         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      END IF
#END REPORT
#end FUN-7B0048 mark
