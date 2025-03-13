# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: axmg762.4gl
# Descriptions...: 客訴處理單列印
# Date & Author..: 02/03/27 By Mandy
# Modify.........: No:8945 03/12/22 By Ching
# Modify.........: No.FUN-550070 05/05/26 By day  單據編號加大
# Modify.........: No.MOD-550149 05/08/10  By Rosayu 列印的格線沒有對齊修改p_zaa
# Modify.........: No.TQC-5A0047 05/10/14 By Carrier 報表格式修改
# Modify.........: No.MOD-5B0124 05/11/15 By Rosayu 料件編號,品名,規格欄位太小無法透過調整p_zaa來修改列印內容
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/11/06 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710080 07/02/07 By Sarah 報表改寫由Crystal Report產出
# Modify.........: No.CHI-7A0014 07/10/05 By jamie 改用新寫法調整子報表
# Modify.........: No.CHI-7A0022 07/10/12 By jamie 抱怨內容沒有印出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B40092 11/05/18 By xujing 憑證報表轉GRW
# Modify.........: No.FUN-B40092 11/08/17 By xujing 程式規範修改
# Modify.........: No.FUN-C10036 12/01/11 By qirl FUN-B80089追單
# Modify.........: No.FUN-C40020 12/04/10 By qirl  GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50008 12/05/05 By wangrr GR程式優化
# Modify.........: No.FUN-C30085 12/06/29 By nanbing GR 修改 
# Modify.........: No.FUN-C40020 12/07/31 By qirl   MARK  GR報表列印TIPTOP與EasyFlow簽核圖片

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD		              # Print condition RECORD
            wc        LIKE type_file.chr1000, # No.FUN-680137  VARCHAR(500)  # Where Condition
            type      LIKE type_file.chr1,    # No.FUN-680137 VARCHAR(1)
            more      LIKE type_file.chr1     # No.FUN-680137 VARCHAR(1)    # 特殊列印條件
           END RECORD
DEFINE g_cnt          LIKE type_file.num10    #No.FUN-680137 INTEGER
DEFINE g_i            LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE l_table        STRING                  #FUN-710080 add
DEFINE g_sql          STRING                  #FUN-710080 add
DEFINE g_str          STRING                  #FUN-710080 add 
DEFINE l_table1       STRING                  #CHI-7A0014 add 
 
###GENGRE###START
TYPE sr1_t RECORD
    ohc01 LIKE ohc_file.ohc01,
    ohc02 LIKE ohc_file.ohc02,
    ohc13 LIKE ohc_file.ohc13,
    ohc04 LIKE ohc_file.ohc04,
    ohc041 LIKE ohc_file.ohc041,
#    l_ohc041 LIKE ohc_file.ohc041,    #FUN-B40092 add
    gen02_2 LIKE gen_file.gen02,
    ohc05 LIKE ohc_file.ohc05,
    ohc08 LIKE ohc_file.ohc08,
    ohc18 LIKE ohc_file.ohc18,
    ohc081 LIKE ohc_file.ohc081,
    ima021 LIKE ima_file.ima021
#   sign_type LIKE type_file.chr1,   # No.FUN-C40020 add      # No.FUN-C40020 mark
#   sign_img  LIKE type_file.blob,   # No.FUN-C40020 add      # No.FUN-C40020 mark
#   sign_show LIKE type_file.chr1,   # No.FUN-C40020 add      # No.FUN-C40020 mark
#   sign_str  LIKE type_file.chr1000 # No.FUN-C40020 add      # No.FUN-C40020 mark
END RECORD

TYPE sr2_t RECORD
    col1 LIKE ohc_file.ohc01,
    col2 LIKE ohf_file.ohf02,
    col3 LIKE ohd_file.ohd02,
    col4 LIKE ohd_file.ohd03,
    col5 LIKE gen_file.gen01,
    col6 LIKE gen_file.gen02
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.type  = ARG_VAL(8)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF

   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126 #FUN-C10036  mark

   LET g_sql = "ohc01.ohc_file.ohc01,",
               "ohc02.ohc_file.ohc02,",
               "ohc13.ohc_file.ohc13,",
               "ohc04.ohc_file.ohc04,",
               "ohc041.ohc_file.ohc041,",
#               "l_ohc041.ohc_file.ohc041,",    #FUN-B40092 add
               "gen02_2.gen_file.gen02,",
               "ohc05.ohc_file.ohc05,",
               "ohc08.ohc_file.ohc08,",
               "ohc18.ohc_file.ohc18,",
               "ohc081.ohc_file.ohc081,",
               "ima021.ima_file.ima021"
            #  "sign_type.type_file.chr1,sign_img.type_file.blob,",  # No.FUN-C40020 add    # No.FUN-C40020 mark
            #  "sign_show.type_file.chr1,sign_str.type_file.chr1000" # No.FUN-C40020 add    # No.FUN-C40020 mark
 
   LET l_table = cl_prt_temptable('axmg762',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN 
      #CALL cl_used(g_prog, g_time,2) RETURNING g_time #FUN-B40092   #FUN-C10036  mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1) #FUN-B40092  #FUN-C10036  mark
      EXIT PROGRAM 
   END IF                  # Temp Table產生
 
   LET g_sql = "col1.ohc_file.ohc01,",        #單號
               "col2.ohf_file.ohf02,",        #類別
               "col3.ohd_file.ohd02,",        #行序
               "col4.ohd_file.ohd03,",        #內容
               "col5.gen_file.gen01,",        #主辦
               "col6.gen_file.gen02"          #審核
 
   LET l_table1 = cl_prt_temptable('axmg762_1',g_sql) CLIPPED   # 產生Temp Table
   IF l_table1 = -1 THEN 
      #CALL cl_used(g_prog, g_time,2) RETURNING g_time #FUN-B40092   #FUN-C10036  mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1) #FUN-B40092  #FUN-C10036  mark
      EXIT PROGRAM 
   END IF                    # Temp Table產生
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-C10036  add
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL g762_tm(0,0)	
      ELSE CALL g762()		
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
END MAIN
 
FUNCTION g762_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680137 SMALLINT
       l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   OPEN WINDOW g762_w WITH FORM "axm/42f/axmg762"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.type   = '3'
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
WHILE TRUE
   CONSTRUCT BY NAME  tm.wc ON ohc01,ohc02,ohc06,ohc13
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
       LET INT_FLAG = 0
       CLOSE WINDOW g762_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
       CALL cl_gre_drop_temptable(l_table||"|"||l_table1)   
    EXIT PROGRAM
   END IF
 
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
 
   INPUT BY NAME tm.type,tm.more WITHOUT DEFAULTS
      #No.FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD type
         IF tm.type NOT MATCHES'[0123]' THEN
             NEXT FIELD type
         END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES'[YN]' THEN
             NEXT FIELD more
         END IF
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
      LET INT_FLAG = 0
      CLOSE WINDOW g762_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)   
   EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='axmg762'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmg762','9031',1)
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
                         " '",tm.type,"'",
                        #" '",tm.more,"'",                      #No.TQC-610089 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmg762',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW g762_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g762()
   ERROR ""
END WHILE
   CLOSE WINDOW g762_w
END FUNCTION
 
FUNCTION g762()
#  DEFINE l_img_blob        LIKE type_file.blob  # No.FUN-C40020 add     # No.FUN-C40020 mark
  # LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add     # No.FUN-C40020 mark
   DEFINE l_name     LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680137 VARCHAR(20)
        #  l_time     LIKE type_file.chr8,  		# Used time for running the job        #No.FUN-680137 VARCHAR(8) #NO.FUN-6A0094
          l_sql      LIKE type_file.chr1000,		# RDSQL STATEMENT        #No.FUN-680137 VARCHAR(1000)
          l_za05     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_order    ARRAY[3] of LIKE faj_file.faj02,      # No.FUN-680137  VARCHAR(10)
          sr         RECORD
                       ohc02    LIKE ohc_file.ohc02,
                       ohc01    LIKE ohc_file.ohc01,
                       ohc06    LIKE ohc_file.ohc06,
                       ohc061   LIKE ohc_file.ohc061,
                       ohc09    LIKE ohc_file.ohc09,
                       ohc04    LIKE ohc_file.ohc04,
                       ohc041   LIKE ohc_file.ohc041,
                       ohc10    LIKE ohc_file.ohc10,
                       gen02_1  LIKE gen_file.gen02,
                       ohc11    LIKE ohc_file.ohc11,
                       gen02_2  LIKE gen_file.gen02,
                       ohc05    LIKE ohc_file.ohc05,
                       ohc08    LIKE ohc_file.ohc08,
                       ohc18    LIKE ohc_file.ohc18,
                       ohc13    LIKE ohc_file.ohc13,
                       ohc081   LIKE ohc_file.ohc081,
                       ima021   LIKE ima_file.ima021
                     END RECORD,
          #str FUN-710080 add
          l_ohf03_0  LIKE ohf_file.ohf03,
          l_ohf04_0  LIKE ohf_file.ohf04,
          l_ohf03_1  LIKE ohf_file.ohf03,
          l_ohf04_1  LIKE ohf_file.ohf04,
          l_ohf03_2  LIKE ohf_file.ohf03,
          l_ohf04_2  LIKE ohf_file.ohf04,
          l_ohf04_3  LIKE ohf_file.ohf04,
          l_ohf04_4  LIKE ohf_file.ohf04,
          l_ohf03_5  LIKE ohf_file.ohf03,
          l_ohf04_5  LIKE ohf_file.ohf04,
          l_gen02_a  LIKE gen_file.gen02,
          l_gen02_b  LIKE gen_file.gen02,
          l_gen02_1  LIKE gen_file.gen02,
          l_gen02_2  LIKE gen_file.gen02,
          l_gen02_3  LIKE gen_file.gen02,
          l_gen02_4  LIKE gen_file.gen02,
          l_gen02_5  LIKE gen_file.gen02,
          l_gen02_6  LIKE gen_file.gen02,
          l_gen02_7  LIKE gen_file.gen02,
          l_gen02_8  LIKE gen_file.gen02,
          l_text     DYNAMIC ARRAY OF RECORD
                      ohd03    LIKE ohd_file.ohd03,
                      ohg04_1  LIKE ohg_file.ohg04,
                      ohg04_2  LIKE ohg_file.ohg04,
                      ohg04_3  LIKE ohg_file.ohg04,
                      ohg04_4  LIKE ohg_file.ohg04,
                      ohg04_5  LIKE ohg_file.ohg04
                     END RECORD
          #end FUN-710080 add
 
DEFINE    l_col1  LIKE ohf_file.ohf01,   #CHI-7A0014 add
          l_col2  LIKE ohf_file.ohf02,   #CHI-7A0014 add
          l_col3  LIKE ohd_file.ohd02,   #CHI-7A0014 add
          l_col4  LIKE ohd_file.ohd03,   #CHI-7A0014 add
          l_col5  LIKE ohf_file.ohf03,   #CHI-7A0014 add
          l_col6  LIKE ohf_file.ohf04,   #CHI-7A0014 add
          l_gen02a  LIKE gen_file.gen02,   #CHI-7A0014 add
          l_gen02b  LIKE gen_file.gen02    #CHI-7A0014 add
 
 
   #str FUN-710080 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)                #FUN-790029 add
   #------------------------------ CR (2) ------------------------------#
   #end FUN-710080 add
#  LOCATE l_img_blob        IN MEMORY   #FUN-C50008 add    # No.FUN-C40020 mark 
  #CHI-7A0014 add str
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"  #?,?,?,?)"             # No.FUN-C40020 add4?      # No.FUN-C40020 mark4? 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time                  #FUN-C10036 ADD
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1) #FUN-B40092
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?)"                   
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-C10036 ADD
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1) #FUN-B40092
      EXIT PROGRAM
   END IF
            
   LET g_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               "   SET col5=?,col6=?",
               " WHERE col1=? AND col2='0'"
   PREPARE update_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('update_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-C10036 ADD
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1) #FUN-B40092
      EXIT PROGRAM
   END IF
  #CHI-7A0014 add end
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axmg762'
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET l_sql = l_sql clipped," AND ohcuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET l_sql = l_sql clipped," AND ohcgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET l_sql = l_sql clipped," AND ohcgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET l_sql = l_sql CLIPPED,cl_get_extra_cond('ohcuser', 'ohcgrup')
   #End:FUN-980030
 
   LET l_sql = " SELECT ohc02,ohc01,ohc06,ohc061,ohc09,ohc04,ohc041, ",
              # "        ohc10,'',ohc11,'',ohc05,ohc08,ohc18,ohc13,ohc081,ima021 ",  #FUN-C50008 mark--
               "        ohc10,A.gen02,ohc11,B.gen02,ohc05,ohc08,ohc18,ohc13,ohc081,ima021 ",  #FUN-C50008 add A.gen02,B.gen02   
              #"   FROM ohc_file,OUTER ima_file ",          #FUN-C50008 mark--
           #FUN-C50008--add--str  LEFT OUTER
               "   FROM ohc_file LEFT OUTER JOIN ima_file ON (ohc08=ima01) ",
               "                 LEFT OUTER JOIN gen_file A ON (A.gen01=ohc10) ",
               "                 LEFT OUTER JOIN gen_file B ON (B.gen01=ohc11) ", 
            #FUN-C50008--add--end   
               "  WHERE ",tm.wc CLIPPED,
              #"    AND ima_file.ima01 = ohc_file.ohc08 ",  #FUN-C50008 mark--
               "    AND ohcconf != 'X' "
   IF tm.type MATCHES'[012]' THEN
      LET l_sql = l_sql CLIPPED," AND ohc03 ='",tm.type,"'"
   END IF
 
   DISPLAY l_sql
   PREPARE g762_p FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:g762_p',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM
   END IF
   DECLARE g762_c CURSOR FOR g762_p
  
#FUN-C50008--add--str
   DECLARE g762_cur1 CURSOR FOR
      SELECT ohc01,'0',ohd02,ohd03
        FROM ohc_file,ohd_file 
       WHERE ohc01 = ?  AND  ohc01=ohd01

   DECLARE g762_cur1_1 CURSOR FOR
      SELECT ohf03,ohf04,A.gen02,B.gen02 
        FROM ohf_file LEFT OUTER JOIN gen_file A ON (A.gen01=ohf03) 
                      LEFT OUTER JOIN gen_file B ON (B.gen01=ohf04)
       WHERE ohf01=? AND ohf02='0'

   DECLARE g762_cur2 CURSOR FOR
      SELECT ohc01,ohf02,ohg03,ohg04,ohf03,ohf04
        FROM ohc_file,ohg_file,ohf_file
       WHERE ohc01 = ?
         AND ohc01 = ohg01
         AND ohc01 = ohf01
         AND ohf02 = ohg02
         AND ohf02 = '1'

   DECLARE g762_cur3 CURSOR FOR
      SELECT ohc01,ohf02,ohg03,ohg04,ohf03,ohf04
        FROM ohc_file,ohg_file,ohf_file
       WHERE ohc01 = ?
         AND ohc01 = ohg01
         AND ohc01 = ohf01
         AND ohf02 = ohg02
         AND ohf02 = '2' 

   DECLARE g762_cur4 CURSOR FOR
      SELECT ohc01,ohf02,ohg03,ohg04,ohf03,ohf04
        FROM ohc_file,ohg_file,ohf_file
       WHERE ohc01 = ?
         AND ohc01 = ohg01
         AND ohc01 = ohf01
         AND ohf02 = ohg02
         AND ohf02 = '3'

   DECLARE g762_cur5 CURSOR FOR
      SELECT ohc01,ohf02,ohg03,ohg04,ohf03,ohf04
        FROM ohc_file,ohg_file,ohf_file
       WHERE ohc01 = ?
         AND ohc01 = ohg01
         AND ohc01 = ohf01
         AND ohf02 = ohg02
         AND ohf02 = '4'

   DECLARE g762_cur6 CURSOR FOR
      SELECT ohc01,ohf02,ohg03,ohg04,ohf03,ohf04
        FROM ohc_file,ohg_file,ohf_file
       WHERE ohc01 =?
         AND ohc01 = ohg01
         AND ohc01 = ohf01
         AND ohf02 = ohg02
         AND ohf02 = '5'
#FUN-C50008--add--end
   FOREACH g762_c INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
 
     #str FUN-710080 add
      LET l_ohf03_0 = ''
      LET l_ohf04_0 = ''
      LET l_ohf03_1 = ''
      LET l_ohf04_1 = ''
      LET l_ohf03_2 = ''
      LET l_ohf04_2 = ''
      LET l_ohf04_3 = ''
      LET l_ohf04_4 = ''
      LET l_ohf03_5 = ''
      LET l_ohf04_5 = ''
 
      LET l_gen02_a = ''
      LET l_gen02_b = ''
      LET l_gen02_1 = ''
      LET l_gen02_2 = ''
      LET l_gen02_3 = ''
      LET l_gen02_4 = ''
      LET l_gen02_5 = ''
      LET l_gen02_6 = ''
      LET l_gen02_7 = ''
      LET l_gen02_8 = ''
 
      #CHI-7A0014 add 
      LET l_col1    = ''
      LET l_col2    = ''
      LET l_col3    = ''
      LET l_col4    = ''
      LET l_col5    = ''
      LET l_col6    = ''
      LET l_gen02a  = ''
      LET l_gen02b  = ''
      #CHI-7A0014 add 
                         
      #負責業務 
      #SELECT gen02 INTO sr.gen02_1 FROM gen_file WHERE gen01 = sr.ohc10  #FUN-C50008 mark--
 
      #處理人員
      #SELECT gen02 INTO sr.gen02_2 FROM gen_file WHERE gen01 = sr.ohc11  #FUN-C50008 mark--
 
     #CHI-7A0014 mark---str---
     ##"客訴原因"主辦人員、審核人員
     #SELECT ohf03,ohf04 INTO l_ohf03_0,l_ohf04_0
     #  FROM ohf_file
     # WHERE ohf01 = sr.ohc01 AND ohf02 = '0'
     #SELECT gen02 INTO l_gen02_a FROM gen_file WHERE gen01 = l_ohf03_0
     #SELECT gen02 INTO l_gen02_b FROM gen_file WHERE gen01 = l_ohf04_0
     ##No:8945(END)
 
     ##"調查結果"主辦人員、審核人員
     #SELECT ohf03,ohf04 INTO l_ohf03_1,l_ohf04_1
     #  FROM ohf_file
     # WHERE ohf01 = sr.ohc01 AND ohf02 = '1'
     #SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01 = l_ohf03_1
     #SELECT gen02 INTO l_gen02_2 FROM gen_file WHERE gen01 = l_ohf04_1
 
     ##"處理對策及改善對策"主辦人員、審核人員
     #SELECT ohf03,ohf04 INTO l_ohf03_2,l_ohf04_2
     #  FROM ohf_file
     # WHERE ohf01 = sr.ohc01 AND ohf02 = '2'
     #SELECT gen02 INTO l_gen02_3 FROM gen_file WHERE gen01 = l_ohf03_2
     #SELECT gen02 INTO l_gen02_4 FROM gen_file WHERE gen01 = l_ohf04_2
 
     ##"審核"審核人員
     #SELECT ohf04 INTO l_ohf04_3
     #  FROM ohf_file
     # WHERE ohf01 = sr.ohc01 AND ohf02 = '3'
     #SELECT gen02 INTO l_gen02_5 FROM gen_file WHERE gen01 = l_ohf04_3
 
     ##"核決"審核人員
     #SELECT ohf04 INTO l_ohf04_4
     #  FROM ohf_file
     # WHERE ohf01 = sr.ohc01 AND ohf02 = '4'
     #SELECT gen02 INTO l_gen02_6 FROM gen_file WHERE gen01 = l_ohf04_4
 
     ##"結案註記"主辦人員、審核人員
     #SELECT ohf03,ohf04 INTO l_ohf03_5,l_ohf04_5
     #  FROM ohf_file
     # WHERE ohf01 = sr.ohc01 AND ohf02 = '5'
     #SELECT gen02 INTO l_gen02_7 FROM gen_file WHERE gen01 = l_ohf03_5
     #SELECT gen02 INTO l_gen02_8 FROM gen_file WHERE gen01 = l_ohf04_5
 
     #DECLARE ohd03_cur CURSOR FOR
     #   SELECT ohd03 FROM ohd_file WHERE ohd01 = sr.ohc01
     #DECLARE ohg04_cur1 CURSOR FOR
     #   SELECT ohg04 FROM ohg_file WHERE ohg01 = sr.ohc01 AND ohg02 = '1'
     #DECLARE ohg04_cur2 CURSOR FOR
     #   SELECT ohg04 FROM ohg_file WHERE ohg01 = sr.ohc01 AND ohg02 = '2'
     #DECLARE ohg04_cur3 CURSOR FOR
     #   SELECT ohg04 FROM ohg_file WHERE ohg01 = sr.ohc01 AND ohg02 = '3'
     #DECLARE ohg04_cur4 CURSOR FOR
     #   SELECT ohg04 FROM ohg_file WHERE ohg01 = sr.ohc01 AND ohg02 = '4'
     #DECLARE ohg04_cur5 CURSOR FOR
     #   SELECT ohg04 FROM ohg_file WHERE ohg01 = sr.ohc01 AND ohg02 = '5'
 
     #FOR g_cnt = 1 TO 16           #ARRAY 乾洗
     #   INITIALIZE l_text[g_cnt].* TO NULL
     #END FOR
     #LET g_cnt = 1
     #FOREACH ohd03_cur INTO l_text[g_cnt].ohd03
     #   IF SQLCA.sqlcode THEN
     #      CALL cl_err('foreach:ohd03_cur',SQLCA.sqlcode,1) EXIT FOREACH
     #   END IF
     #   LET g_cnt = g_cnt + 1
     #   IF g_cnt > 16 THEN
     #      EXIT FOREACH
     #   END IF
     #END FOREACH
     #LET g_cnt = 1
     #FOREACH ohg04_cur1 INTO l_text[g_cnt].ohg04_1
     #   IF SQLCA.sqlcode THEN
     #      CALL cl_err('foreach:ohg04_cur1',SQLCA.sqlcode,1) EXIT FOREACH
     #   END IF
     #   LET g_cnt = g_cnt + 1
     #   IF g_cnt > 16 THEN
     #      EXIT FOREACH
     #   END IF
     #END FOREACH
     #LET g_cnt = 1
     #FOREACH ohg04_cur2 INTO l_text[g_cnt].ohg04_2
     #   IF SQLCA.sqlcode THEN
     #      CALL cl_err('foreach:ohg04_cur2',SQLCA.sqlcode,1) EXIT FOREACH
     #   END IF
     #   LET g_cnt = g_cnt + 1
     #   IF g_cnt > 16 THEN
     #      EXIT FOREACH
     #   END IF
     #END FOREACH
     #LET g_cnt = 1
     #FOREACH ohg04_cur3 INTO l_text[g_cnt].ohg04_3
     #   IF SQLCA.sqlcode THEN
     #      CALL cl_err('foreach:ohg04_cur3',SQLCA.sqlcode,1) EXIT FOREACH
     #   END IF
     #   LET g_cnt = g_cnt + 1
     #   IF g_cnt > 16 THEN
     #      EXIT FOREACH
     #   END IF
     #END FOREACH
     #LET g_cnt = 1
     #FOREACH ohg04_cur4 INTO l_text[g_cnt].ohg04_4
     #   IF SQLCA.sqlcode THEN
     #      CALL cl_err('foreach:ohg04_cur4',SQLCA.sqlcode,1) EXIT FOREACH
     #   END IF
     #   LET g_cnt = g_cnt + 1
     #   IF g_cnt > 16 THEN
     #      EXIT FOREACH
     #   END IF
     #END FOREACH
     #LET g_cnt = 1
     #FOREACH ohg04_cur5 INTO l_text[g_cnt].ohg04_5
     #   IF SQLCA.sqlcode THEN
     #      CALL cl_err('foreach:ohg04_cur5',SQLCA.sqlcode,1) EXIT FOREACH
     #   END IF
     #   LET g_cnt = g_cnt + 1
     #   IF g_cnt > 16 THEN
     #      EXIT FOREACH
     #   END IF
     #END FOREACH
     #CHI-7A0014 mark---end---
 
     #CHI-7A0014 add
     #"客訴原因"主辦人員、審核人員
     # DECLARE g762_cur1 CURSOR FOR  #FUN-C50008 mark--
     #CHI-7A0022 mod
     #SELECT ohf01,ohf02,ohd02,ohd03,ohf03,ohf04  
     #  FROM ohf_file,ohd_file
     # WHERE ohf01 = sr.ohc01
     #   AND ohd01 = sr.ohc01
     #   AND ohf02 = '0'
     #FOREACH g762_cur1 INTO l_col1,l_col2,l_col3,l_col4,l_col5,l_col6   
     #   SELECT gen02 INTO l_gen02a FROM gen_file WHERE gen01 = l_col5
     #   SELECT gen02 INTO l_gen02b FROM gen_file WHERE gen01 = l_col6
     #   EXECUTE insert_prep1 USING 
     #      l_col1,l_col2,l_col3,l_col4,l_gen02a,l_gen02b   
     #END FOREACH 
     #FUN-C50008--mark--str
     # SELECT ohc01,'0',ohd02,ohd03  
     #   FROM ohc_file,ohd_file
     #  WHERE ohc01 = sr.ohc01
     #    AND ohc01 = ohd01
     #FOREACH g762_cur1 INTO l_col1,l_col2,l_col3,l_col4 
     #FUN-C50008--mark--end
      FOREACH g762_cur1 USING sr.ohc01 INTO l_col1,l_col2,l_col3,l_col4  #FUN-C50008 add  
         EXECUTE insert_prep1 USING 
            l_col1,l_col2,l_col3,l_col4,'','' 
     #FUN-C50008--mark--str  
     #    DECLARE g762_cur1_1 CURSOR FOR
     #       SELECT ohf03,ohf04 
     #         FROM ohf_file
     #        WHERE ohf01=l_col1
     #          AND ohf02='0'
     #    FOREACH g762_cur1_1 INTO l_col5,l_col6   
     #FUN-C50008--mark--end
         FOREACH g762_cur1_1 USING l_col1 INTO l_col5,l_col6,l_gen02a,l_gen02b  #FUN-C50008 add 
            #SELECT gen02 INTO l_gen02a FROM gen_file WHERE gen01 = l_col5
            #SELECT gen02 INTO l_gen02b FROM gen_file WHERE gen01 = l_col6
            EXECUTE update_prep1 USING 
               l_gen02a,l_gen02b,l_col1   
         END FOREACH 
      END FOREACH 
 
      #CHI-7A0014 add 
      LET l_col1    = ''
      LET l_col2    = ''
      LET l_col3    = ''
      LET l_col4    = ''
      LET l_col5    = ''
      LET l_col6    = ''
      LET l_gen02a  = ''
      LET l_gen02b  = ''
      #CHI-7A0014 add 
 
     #"調查結果"主辦人員、審核人員
     # DECLARE g762_cur2 CURSOR FOR  #FUN-C50008 mark--
     #CHI-7A0022 mod
     #SELECT ohf01,ohf02,ohg03,ohg04,ohf03,ohf04  
     #  FROM ohf_file,ohg_file
     # WHERE ohf01 = sr.ohc01
     #   AND ohf01 = ohg01
     #   AND ohf02 = ohg02
     #   AND ohf02 = '1'
     #FUN-C50008--mark--str
     # SELECT ohc01,ohf02,ohg03,ohg04,ohf03,ohf04  
     #   FROM ohc_file,ohg_file,ohf_file  
     #  WHERE ohc01 = sr.ohc01
     #    AND ohc01 = ohg01
     #    AND ohc01 = ohf01
     #    AND ohf02 = ohg02
     #    AND ohf02 = '1'
     #FUN-C50008--mark--end
     #CHI-7A0022 mod
     
     #FOREACH g762_cur2  INTO l_col1,l_col2,l_col3,l_col4,l_col5,l_col6 #FUN-C50008 mark--
      FOREACH g762_cur2 USING sr.ohc01 INTO l_col1,l_col2,l_col3,l_col4,l_col5,l_col6 #FUN-C50008 add   
         SELECT gen02 INTO l_gen02a FROM gen_file WHERE gen01 = l_col5
         SELECT gen02 INTO l_gen02b FROM gen_file WHERE gen01 = l_col6
         EXECUTE insert_prep1 USING 
            l_col1,l_col2,l_col3,l_col4,l_gen02a,l_gen02b   
      END FOREACH 
 
      #CHI-7A0014 add 
      LET l_col1    = ''
      LET l_col2    = ''
      LET l_col3    = ''
      LET l_col4    = ''
      LET l_col5    = ''
      LET l_col6    = ''
      LET l_gen02a  = ''
      LET l_gen02b  = ''
      #CHI-7A0014 add 
 
      #"處理對策及改善對策"主辦人員、審核人員
     # DECLARE g762_cur3 CURSOR FOR   #FUN-C50008 mark--
     #CHI-7A0022 mod
     #SELECT ohf01,ohf02,ohg03,ohg04,ohf03,ohf04  
     #  FROM ohf_file,ohg_file
     # WHERE ohf01 = sr.ohc01
     #   AND ohf01 = ohg01
     #   AND ohf02 = ohg02
     #   AND ohf02 = '2'
    #FUN-C50008--mark--str
    #  SELECT ohc01,ohf02,ohg03,ohg04,ohf03,ohf04  
    #    FROM ohc_file,ohg_file,ohf_file
    #   WHERE ohc01 = sr.ohc01
    #     AND ohc01 = ohg01
    #     AND ohc01 = ohf01
    #     AND ohf02 = ohg02
    #     AND ohf02 = '2'
    #FUN-C50008--mark--end
     #CHI-7A0022 mod
    # FOREACH g762_cur3 INTO l_col1,l_col2,l_col3,l_col4,l_col5,l_col6  #FUN-C50008 mark--
      FOREACH g762_cur3 USING sr.ohc01 INTO l_col1,l_col2,l_col3,l_col4,l_col5,l_col6  #FUN-C50008 add 
         SELECT gen02 INTO l_gen02a FROM gen_file WHERE gen01 = l_col5
         SELECT gen02 INTO l_gen02b FROM gen_file WHERE gen01 = l_col6
         EXECUTE insert_prep1 USING 
            l_col1,l_col2,l_col3,l_col4,l_gen02a,l_gen02b   
      END FOREACH 
 
      #CHI-7A0014 add 
      LET l_col1    = ''
      LET l_col2    = ''
      LET l_col3    = ''
      LET l_col4    = ''
      LET l_col5    = ''
      LET l_col6    = ''
      LET l_gen02a  = ''
      LET l_gen02b  = ''
      #CHI-7A0014 add 
 
      #"審核"審核人員
     # DECLARE g762_cur4 CURSOR FOR  #FUN-C50008 mark--
     #CHI-7A0022 mod
     #SELECT ohf01,ohf02,ohg03,ohg04,ohf03,ohf04  
     #  FROM ohf_file,ohg_file
     # WHERE ohf01 = sr.ohc01
     #   AND ohf01 = ohg01
     #   AND ohf02 = ohg02
     #   AND ohf02 = '3'
     #FUN-C50008--mark--str
     # SELECT ohc01,ohf02,ohg03,ohg04,ohf03,ohf04  
     #   FROM ohc_file,ohg_file,ohf_file
     #  WHERE ohc01 = sr.ohc01
     #    AND ohc01 = ohg01
     #    AND ohc01 = ohf01
     #    AND ohf02 = ohg02
     #    AND ohf02 = '3'
     #FUN-C50008--mark--end
     #CHI-7A0022 mod
     #FOREACH g762_cur4 INTO l_col1,l_col2,l_col3,l_col4,l_col5,l_col6 #FUN-C50008 mark--
      FOREACH g762_cur4 USING sr.ohc01 INTO l_col1,l_col2,l_col3,l_col4,l_col5,l_col6 #FUN-C50008 add   
         SELECT gen02 INTO l_gen02a FROM gen_file WHERE gen01 = l_col5
         SELECT gen02 INTO l_gen02b FROM gen_file WHERE gen01 = l_col6
         EXECUTE insert_prep1 USING 
            l_col1,l_col2,l_col3,l_col4,l_gen02a,l_gen02b   
      END FOREACH 
 
      #CHI-7A0014 add 
      LET l_col1    = ''
      LET l_col2    = ''
      LET l_col3    = ''
      LET l_col4    = ''
      LET l_col5    = ''
      LET l_col6    = ''
      LET l_gen02a  = ''
      LET l_gen02b  = ''
      #CHI-7A0014 add 
 
      #"核決"審核人員
     # DECLARE g762_cur5 CURSOR FOR  #FUN-C50008 mark--
     #CHI-7A0022 mod
     #SELECT ohf01,ohf02,ohg03,ohg04,ohf03,ohf04  
     #  FROM ohf_file,ohg_file
     # WHERE ohf01 = sr.ohc01
     #   AND ohf01 = ohg01
     #   AND ohf02 = ohg02
     #   AND ohf02 = '4'
     #FUN-C50008--mark--str
     # SELECT ohc01,ohf02,ohg03,ohg04,ohf03,ohf04  
     #   FROM ohc_file,ohg_file,ohf_file
     #  WHERE ohc01 = sr.ohc01
     #    AND ohc01 = ohg01
     #    AND ohc01 = ohf01
     #    AND ohf02 = ohg02
     #    AND ohf02 = '4'
     #FUN-C50008--mark--end
     #CHI-7A0022 mod
     # FOREACH g762_cur5 INTO l_col1,l_col2,l_col3,l_col4,l_col5,l_col6  #FUN-C50008 mark--
      FOREACH g762_cur5 USING sr.ohc01 INTO l_col1,l_col2,l_col3,l_col4,l_col5,l_col6  #FUN-C50008 add   
         SELECT gen02 INTO l_gen02a FROM gen_file WHERE gen01 = l_col5
         SELECT gen02 INTO l_gen02b FROM gen_file WHERE gen01 = l_col6
         EXECUTE insert_prep1 USING 
            l_col1,l_col2,l_col3,l_col4,l_gen02a,l_gen02b   
      END FOREACH 
 
      #CHI-7A0014 add 
      LET l_col1    = ''
      LET l_col2    = ''
      LET l_col3    = ''
      LET l_col4    = ''
      LET l_col5    = ''
      LET l_col6    = ''
      LET l_gen02a  = ''
      LET l_gen02b  = ''
      #CHI-7A0014 add 
 
      #"結案註記"主辦人員、審核人員
     # DECLARE g762_cur6 CURSOR FOR  #FUN-C50008 mark--
     #CHI-7A0022 mod
     #SELECT ohf01,ohf02,ohg03,ohg04,ohf03,ohf04  
     #  FROM ohf_file,ohg_file
     # WHERE ohf01 = sr.ohc01
     #   AND ohf01 = ohg01
     #   AND ohf02 = ohg02
     #   AND ohf02 = '5'
     #FUN-C50008--mark--str
     # SELECT ohc01,ohf02,ohg03,ohg04,ohf03,ohf04  
     #   FROM ohc_file,ohg_file,ohf_file
     #  WHERE ohc01 = sr.ohc01
     #    AND ohc01 = ohg01
     #    AND ohc01 = ohf01
     #    AND ohf02 = ohg02
     #    AND ohf02 = '5'
     #FUN-C50008--mark--end
     #CHI-7A0022 mod
     # FOREACH g762_cur6 INTO l_col1,l_col2,l_col3,l_col4,l_col5,l_col6 #FUN-C50008 mark--
      FOREACH g762_cur6 USING sr.ohc01 INTO l_col1,l_col2,l_col3,l_col4,l_col5,l_col6  #FUN-C50008 add    
         SELECT gen02 INTO l_gen02a FROM gen_file WHERE gen01 = l_col5
         SELECT gen02 INTO l_gen02b FROM gen_file WHERE gen01 = l_col6
         EXECUTE insert_prep1 USING 
            l_col1,l_col2,l_col3,l_col4,l_gen02a,l_gen02b   
      END FOREACH 
 
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
      EXECUTE insert_prep USING
         sr.ohc01  ,sr.ohc02,sr.ohc13,sr.ohc04,sr.ohc041,
         sr.gen02_2,sr.ohc05,sr.ohc08,sr.ohc18,sr.ohc081,sr.ima021
        #sr.gen02_2,sr.ohc05,sr.ohc08,sr.ohc18,sr.ohc081,sr.ima021,
        #l_text[1].ohd03  ,l_text[2].ohd03  ,l_text[3].ohd03  ,
        #l_text[4].ohd03  ,l_text[5].ohd03  ,l_text[6].ohd03  ,
        #l_text[1].ohg04_1,l_text[2].ohg04_1,l_text[3].ohg04_1,
        #l_text[4].ohg04_1,l_text[5].ohg04_1,l_text[6].ohg04_1,
        #l_text[1].ohg04_2,l_text[2].ohg04_2,l_text[3].ohg04_2,
        #l_text[4].ohg04_2,l_text[5].ohg04_2,
        #l_text[1].ohg04_3,l_text[2].ohg04_3,
        #l_text[1].ohg04_4,l_text[2].ohg04_4,
        #l_text[1].ohg04_5,l_text[2].ohg04_5,l_text[3].ohg04_5,
        #l_gen02_a,l_gen02_b,l_gen02_1,l_gen02_2,l_gen02_3,        
        #l_gen02_4,l_gen02_5,l_gen02_6,l_gen02_7,l_gen02_8        
#	,"",  l_img_blob,"N",""  # No.FUN-C40020 add      # No.FUN-C40020 mark
      #------------------------------ CR (3) ------------------------------#
     #end FUN-710080 add
   END FOREACH
 
###GENGRE###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|", 
###GENGRE###                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
###GENGRE###                 " WHERE col2='0'","|",
###GENGRE###                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
###GENGRE###                 " WHERE col2='1'","|",
###GENGRE###                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
###GENGRE###                 " WHERE col2='2'","|",
###GENGRE###                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
###GENGRE###                 " WHERE col2='3'","|",
###GENGRE###                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
###GENGRE###                 " WHERE col2='4'","|",
###GENGRE###                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
###GENGRE###                 " WHERE col2='5'"
 
   #str FUN-710080 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
  #LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED    #CHI-7A0014 mark
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'ohc01,ohc02,ohc06,ohc13')
           RETURNING tm.wc
###GENGRE###      LET g_str = tm.wc
   END IF
###GENGRE###   CALL cl_prt_cs3('axmg762','axmg762',l_sql,g_str)
   #LET g_cr_table = l_table                    # No.FUN-C40020 add   # No.FUN-C40020 mark
   #LET g_cr_apr_key_f = "ofc01"                # No.FUN-C40020 add  #FUN-C50008 mark--
    LET g_cr_apr_key_f = "ohc01"    #FUN-C50008 add
    CALL axmg762_grdata()    ###GENGRE###
   #------------------------------ CR (4) ------------------------------#
   #end FUN-710080 add
 
END FUNCTION
 
{
REPORT g762_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,        # No.FUN-680137  VARCHAR(1)
          sr         RECORD
                       ohc02    LIKE ohc_file.ohc02,
                       ohc01    LIKE ohc_file.ohc01,
                       ohc06    LIKE ohc_file.ohc06,
                       ohc061   LIKE ohc_file.ohc061,
                       ohc09    LIKE ohc_file.ohc09,
                       ohc04    LIKE ohc_file.ohc04,
                       ohc041   LIKE ohc_file.ohc041,
                       ohc10    LIKE ohc_file.ohc10,
                       gen02_1  LIKE gen_file.gen02,
                       ohc11    LIKE ohc_file.ohc11,
                       gen02_2  LIKE gen_file.gen02,
                       ohc05    LIKE ohc_file.ohc05,
                       ohc08    LIKE ohc_file.ohc08,
                       ohc18    LIKE ohc_file.ohc18,
                       ohc13    LIKE ohc_file.ohc13,
                       ohc081   LIKE ohc_file.ohc081,
                       ima021    LIKE ima_file.ima021
                     END RECORD,
          l_text    DYNAMIC ARRAY OF RECORD
                        ohd03    LIKE ohd_file.ohd03,
                        ohg04_1  LIKE ohg_file.ohg04,
                        ohg04_2  LIKE ohg_file.ohg04,
                        ohg04_3  LIKE ohg_file.ohg04,
                        ohg04_4  LIKE ohg_file.ohg04,
                        ohg04_5  LIKE ohg_file.ohg04
                    END RECORD,
          l_ohf03_0 LIKE ohf_file.ohf03, #No.8945
          l_ohf04_0 LIKE ohf_file.ohf04, #No.8945
          l_ohf03_1 LIKE ohf_file.ohf03,
          l_ohf04_1 LIKE ohf_file.ohf04,
          l_ohf03_2 LIKE ohf_file.ohf03,
          l_ohf04_2 LIKE ohf_file.ohf04,
          l_ohf04_3 LIKE ohf_file.ohf04,
          l_ohf04_4 LIKE ohf_file.ohf04,
          l_ohf03_5 LIKE ohf_file.ohf03,
          l_ohf04_5 LIKE ohf_file.ohf04,
 
          l_gen02_a LIKE gen_file.gen02, #NO.8945
          l_gen02_b LIKE gen_file.gen02,
          l_gen02_1 LIKE gen_file.gen02,
          l_gen02_2 LIKE gen_file.gen02,
          l_gen02_3 LIKE gen_file.gen02,
          l_gen02_4 LIKE gen_file.gen02,
          l_gen02_5 LIKE gen_file.gen02,
          l_gen02_6 LIKE gen_file.gen02,
          l_gen02_7 LIKE gen_file.gen02,
          l_gen02_8 LIKE gen_file.gen02
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
      ORDER BY sr.ohc01
  FORMAT
 
   BEFORE GROUP OF sr.ohc01 #客訴單號
       LET l_ohf03_1 = ''
       LET l_ohf04_1 = ''
       LET l_ohf03_2 = ''
       LET l_ohf04_2 = ''
       LET l_ohf04_3 = ''
       LET l_ohf04_4 = ''
       LET l_ohf03_5 = ''
       LET l_ohf04_5 = ''
 
       LET l_gen02_a = ''  #No.8945
       LET l_gen02_b = ''
       LET l_gen02_1 = ''
       LET l_gen02_2 = ''
       LET l_gen02_3 = ''
       LET l_gen02_4 = ''
       LET l_gen02_5 = ''
       LET l_gen02_6 = ''
       LET l_gen02_7 = ''
       LET l_gen02_8 = ''
 
#No.FUN-550070-begin
       PRINT g_x[11] CLIPPED,sr.ohc02,
             COLUMN (g_len-FGL_WIDTH(g_x[01]))/2,g_x[01] CLIPPED,
             COLUMN 60,g_x[12] CLIPPED,sr.ohc01 CLIPPED
       PRINT g_x[23] CLIPPED,g_x[24] CLIPPED
       #No.TQC-5A0047  --begin
       PRINT g_x[13] CLIPPED,sr.ohc06 CLIPPED,' ',sr.ohc061 CLIPPED,
             COLUMN  53,g_x[14] CLIPPED,sr.gen02_1 CLIPPED,
             COLUMN  73,g_x[15] CLIPPED,sr.ohc09 CLIPPED,
             COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[25] CLIPPED,g_x[26] CLIPPED
       PRINT g_x[16] CLIPPED,sr.ohc04 CLIPPED,'-',sr.ohc041,
             COLUMN  53,g_x[17] CLIPPED,sr.gen02_2 CLIPPED,
             COLUMN  73,g_x[18] CLIPPED,sr.ohc05,
             COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[25] CLIPPED,g_x[26] CLIPPED
       PRINT g_x[19] CLIPPED,sr.ohc08 CLIPPED,
             COLUMN  53,g_x[20] CLIPPED,sr.ohc18 USING '#####.#&',
             COLUMN  73,g_x[21] CLIPPED,sr.ohc13,
             COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[27] CLIPPED,g_x[28] CLIPPED
       PRINT g_x[22] CLIPPED,sr.ohc081 CLIPPED, #mandy
             #COLUMN  44,sr.ima021 CLIPPED, #MOD-5B0124 mark
             COLUMN 101,g_x[61] CLIPPED
       #No.TQC-5A0047  --end
       #MOD-5B0124 add
       PRINT g_x[65] CLIPPED,g_x[36] CLIPPED
       PRINT g_x[64] CLIPPED, sr.ima021 CLIPPED,COLUMN 101,g_x[61] CLIPPED
       #MOD-5B0124 end
       PRINT g_x[29] CLIPPED,g_x[30] CLIPPED
 
       #No:8945
       SELECT ohf03,ohf04 INTO l_ohf03_0,l_ohf04_0
         FROM ohf_file
        WHERE ohf01 = sr.ohc01
          AND ohf02 = '0'
       SELECT gen02 INTO l_gen02_a
         FROM gen_file
        WHERE gen01 = l_ohf03_0
       SELECT gen02 INTO l_gen02_b
         FROM gen_file
        WHERE gen01 = l_ohf04_0
       #No:8945(END)
 
       SELECT ohf03,ohf04 INTO l_ohf03_1,l_ohf04_1
         FROM ohf_file
        WHERE ohf01 = sr.ohc01
          AND ohf02 = '1'
       SELECT gen02 INTO l_gen02_1
         FROM gen_file
        WHERE gen01 = l_ohf03_1
       SELECT gen02 INTO l_gen02_2
         FROM gen_file
        WHERE gen01 = l_ohf04_1
 
       SELECT ohf03,ohf04 INTO l_ohf03_2,l_ohf04_2
         FROM ohf_file
        WHERE ohf01 = sr.ohc01
          AND ohf02 = '2'
       SELECT gen02 INTO l_gen02_3
         FROM gen_file
        WHERE gen01 = l_ohf03_2
       SELECT gen02 INTO l_gen02_4
         FROM gen_file
        WHERE gen01 = l_ohf04_2
 
       SELECT ohf04 INTO l_ohf04_3
         FROM ohf_file
        WHERE ohf01 = sr.ohc01
          AND ohf02 = '3'
       SELECT gen02 INTO l_gen02_5
         FROM gen_file
        WHERE gen01 = l_ohf04_3
 
       SELECT ohf04 INTO l_ohf04_4
         FROM ohf_file
        WHERE ohf01 = sr.ohc01
          AND ohf02 = '4'
       SELECT gen02 INTO l_gen02_6
         FROM gen_file
        WHERE gen01 = l_ohf04_4
 
       SELECT ohf03,ohf04 INTO l_ohf03_5,l_ohf04_5
         FROM ohf_file
        WHERE ohf01 = sr.ohc01
          AND ohf02 = '5'
       SELECT gen02 INTO l_gen02_7
         FROM gen_file
        WHERE gen01 = l_ohf03_5
       SELECT gen02 INTO l_gen02_8
         FROM gen_file
        WHERE gen01 = l_ohf04_5
 
       DECLARE ohd03_cur CURSOR FOR
           SELECT ohd03 FROM ohd_file
            WHERE ohd01 = sr.ohc01
       DECLARE ohg04_cur1 CURSOR FOR
           SELECT ohg04 FROM ohg_file
            WHERE ohg01 = sr.ohc01
              AND ohg02 = '1'
       DECLARE ohg04_cur2 CURSOR FOR
           SELECT ohg04 FROM ohg_file
            WHERE ohg01 = sr.ohc01
              AND ohg02 = '2'
       DECLARE ohg04_cur3 CURSOR FOR
           SELECT ohg04 FROM ohg_file
            WHERE ohg01 = sr.ohc01
              AND ohg02 = '3'
       DECLARE ohg04_cur4 CURSOR FOR
           SELECT ohg04 FROM ohg_file
            WHERE ohg01 = sr.ohc01
              AND ohg02 = '4'
       DECLARE ohg04_cur5 CURSOR FOR
           SELECT ohg04 FROM ohg_file
            WHERE ohg01 = sr.ohc01
              AND ohg02 = '5'
 
       FOR g_cnt = 1 TO 16           #ARRAY 乾洗
            INITIALIZE l_text[g_cnt].* TO NULL
       END FOR
       LET g_cnt = 1
       FOREACH ohd03_cur INTO l_text[g_cnt].ohd03
           IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:ohd03_cur',SQLCA.sqlcode,1) EXIT FOREACH
           END IF
           LET g_cnt = g_cnt + 1
           IF g_cnt > 16 THEN
               EXIT FOREACH
           END IF
       END FOREACH
       LET g_cnt = 1
       FOREACH ohg04_cur1 INTO l_text[g_cnt].ohg04_1
           IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:ohg04_cur1',SQLCA.sqlcode,1) EXIT FOREACH
           END IF
           LET g_cnt = g_cnt + 1
           IF g_cnt > 16 THEN
               EXIT FOREACH
           END IF
       END FOREACH
       LET g_cnt = 1
       FOREACH ohg04_cur2 INTO l_text[g_cnt].ohg04_2
           IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:ohg04_cur2',SQLCA.sqlcode,1) EXIT FOREACH
           END IF
           LET g_cnt = g_cnt + 1
           IF g_cnt > 16 THEN
               EXIT FOREACH
           END IF
       END FOREACH
       LET g_cnt = 1
       FOREACH ohg04_cur3 INTO l_text[g_cnt].ohg04_3
           IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:ohg04_cur3',SQLCA.sqlcode,1) EXIT FOREACH
           END IF
           LET g_cnt = g_cnt + 1
           IF g_cnt > 16 THEN
               EXIT FOREACH
           END IF
       END FOREACH
       LET g_cnt = 1
       FOREACH ohg04_cur4 INTO l_text[g_cnt].ohg04_4
           IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:ohg04_cur4',SQLCA.sqlcode,1) EXIT FOREACH
           END IF
           LET g_cnt = g_cnt + 1
           IF g_cnt > 16 THEN
               EXIT FOREACH
           END IF
       END FOREACH
       LET g_cnt = 1
       FOREACH ohg04_cur5 INTO l_text[g_cnt].ohg04_5
           IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:ohg04_cur5',SQLCA.sqlcode,1) EXIT FOREACH
           END IF
           LET g_cnt = g_cnt + 1
           IF g_cnt > 16 THEN
               EXIT FOREACH
           END IF
       END FOREACH
       #抱怨內容
       #No.TQC-5A0047  --begin
       PRINT g_x[31] CLIPPED,COLUMN  7,l_text[1].ohd03 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[58] CLIPPED,COLUMN  7,l_text[2].ohd03 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[58] CLIPPED,COLUMN  7,l_text[3].ohd03 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[32] CLIPPED,COLUMN  7,l_text[4].ohd03 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[58] CLIPPED,COLUMN  7,l_text[5].ohd03 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[58] CLIPPED,COLUMN  7,l_text[6].ohd03 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[33] CLIPPED,COLUMN  7,l_text[7].ohd03 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[58] CLIPPED,COLUMN  7,l_text[8].ohd03 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[58] CLIPPED,COLUMN  7,l_text[9].ohd03 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[34] CLIPPED,COLUMN  7,l_text[10].ohd03 CLIPPED,COLUMN 101,g_x[61] CLIPPED
       #No.8945
       PRINT g_x[58] CLIPPED,
             COLUMN  36,g_x[55] CLIPPED,l_gen02_a CLIPPED,
             COLUMN  59,g_x[56] CLIPPED,l_gen02_b CLIPPED,
             COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[62] CLIPPED,g_x[63] CLIPPED
       #調查結果
       PRINT g_x[37] CLIPPED,COLUMN  7,l_text[1].ohg04_1 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[58] CLIPPED,COLUMN  7,l_text[2].ohg04_1 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[58] CLIPPED,COLUMN  7,l_text[3].ohg04_1 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[38] CLIPPED,COLUMN  7,l_text[4].ohg04_1 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[58] CLIPPED,COLUMN  7,l_text[5].ohg04_1 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[58] CLIPPED,COLUMN  7,l_text[6].ohg04_1 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[39] CLIPPED,COLUMN  7,l_text[7].ohg04_1 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[58] CLIPPED,COLUMN  7,l_text[8].ohg04_1 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[58] CLIPPED,COLUMN  7,l_text[9].ohg04_1 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[40] CLIPPED,COLUMN  7,l_text[10].ohg04_1 CLIPPED,COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[58] CLIPPED,
             COLUMN  36,g_x[55] CLIPPED,l_gen02_1 CLIPPED,
             COLUMN  59,g_x[56] CLIPPED,l_gen02_2 CLIPPED,
             COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[62] CLIPPED,g_x[63] CLIPPED
       #處理對策及改善對策
       PRINT g_x[41] CLIPPED,COLUMN  7,l_text[1].ohg04_2 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[58] CLIPPED,COLUMN  7,l_text[2].ohg04_2 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[42] CLIPPED,COLUMN  7,l_text[3].ohg04_2 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[58] CLIPPED,COLUMN  7,l_text[4].ohg04_2 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[43] CLIPPED,COLUMN  7,l_text[5].ohg04_2 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[58] CLIPPED,COLUMN  7,l_text[6].ohg04_2 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[44] CLIPPED,COLUMN  7,l_text[7].ohg04_2 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[58] CLIPPED,COLUMN  7,l_text[8].ohg04_2 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[45] CLIPPED,COLUMN  7,l_text[9].ohg04_2 CLIPPED, COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[58] CLIPPED,COLUMN  7,l_text[10].ohg04_2 CLIPPED,COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[46] CLIPPED,COLUMN  7,l_text[11].ohg04_2 CLIPPED,COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[58] CLIPPED,COLUMN  7,l_text[12].ohg04_2 CLIPPED,COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[47] CLIPPED,COLUMN  7,l_text[13].ohg04_2 CLIPPED,COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[58] CLIPPED,COLUMN  7,l_text[14].ohg04_2 CLIPPED,COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[43] CLIPPED,COLUMN  7,l_text[15].ohg04_2 CLIPPED,COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[58] CLIPPED,COLUMN  7,l_text[16].ohg04_2 CLIPPED,COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[44] CLIPPED,
             COLUMN  36,g_x[55] CLIPPED,l_gen02_3 CLIPPED,
             COLUMN  59,g_x[56] CLIPPED,l_gen02_4 CLIPPED,
             COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[62] CLIPPED,g_x[63] CLIPPED
       #審核
       PRINT g_x[48] CLIPPED,COLUMN  7,l_text[1].ohg04_3 CLIPPED,COLUMN 101,g_x[61] CLIPPED
       #PRINT g_x[58] CLIPPED,COLUMN  7,l_text[2].ohg04_3 CLIPPED,COLUMN 101,g_x[61] CLIPPED #MOD-5B0124 mark
       PRINT g_x[49] CLIPPED,
          #  COLUMN 36,g_x[55] CLIPPED,
             COLUMN 59,g_x[56] CLIPPED,l_gen02_5 CLIPPED,
             COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[62] CLIPPED,g_x[63] CLIPPED
       #核決
       PRINT g_x[49] CLIPPED,COLUMN  7,l_text[1].ohg04_4 CLIPPED,COLUMN 101,g_x[61] CLIPPED
       #PRINT g_x[58] CLIPPED,COLUMN  7,l_text[2].ohg04_4 CLIPPED,COLUMN 101,g_x[61] CLIPPED #MOD-5B0124 mark
       PRINT g_x[50] CLIPPED,
          #  COLUMN 36,g_x[55] CLIPPED,
             COLUMN 59,g_x[56] CLIPPED,l_gen02_6 CLIPPED,
             COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[62] CLIPPED,g_x[63] CLIPPED
       #結案註記
       PRINT g_x[51] CLIPPED,COLUMN  7,l_text[1].ohg04_5 CLIPPED,COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[52] CLIPPED,COLUMN  7,l_text[2].ohg04_5 CLIPPED,COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[53] CLIPPED,COLUMN  7,l_text[3].ohg04_5 CLIPPED,COLUMN 101,g_x[61] CLIPPED
       PRINT g_x[54] CLIPPED,
             COLUMN 36,g_x[55] CLIPPED,l_gen02_7 CLIPPED,
             COLUMN 59,g_x[56] CLIPPED,l_gen02_8 CLIPPED,
             COLUMN 101,g_x[61] CLIPPED
       #No.TQC-5A0047  --end
       PRINT g_x[59] CLIPPED,g_x[60] CLIPPED
    AFTER GROUP OF sr.ohc01
       SKIP TO TOP OF PAGE
#No.FUN-550070-end
 
END REPORT
#Patch....NO.TQC-610037 <001> #
}

###GENGRE###START
FUNCTION axmg762_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

#   LOCATE sr1.sign_img IN MEMORY      # No.FUN-C40020 add     # No.FUN-C40020 mark
#   CALL cl_gre_init_apr()             # No.FUN-C40020 add     # No.FUN-C40020 mark
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("axmg762")
        IF handler IS NOT NULL THEN
            START REPORT axmg762_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY ohc01"      
            DECLARE axmg762_datacur1 CURSOR FROM l_sql
            FOREACH axmg762_datacur1 INTO sr1.*
                OUTPUT TO REPORT axmg762_rep(sr1.*)
            END FOREACH
            FINISH REPORT axmg762_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT axmg762_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2_1 sr2_t
    DEFINE sr2_2 sr2_t
    DEFINE sr2_3 sr2_t
    DEFINE sr2_4 sr2_t
    DEFINE sr2_5 sr2_t
    DEFINE sr2_6 sr2_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_ohc041 STRING
    DEFINE l_ohc04_ohc041 STRING
    DEFINE l_sql STRING
    DEFINE l_flag1   LIKE type_file.num5
    DEFINE l_flag2   LIKE type_file.num5
    DEFINE l_flag3   LIKE type_file.num5
    DEFINE l_flag4   LIKE type_file.num5
    DEFINE l_flag5   LIKE type_file.num5
    DEFINE l_flag6   LIKE type_file.num5
    
    ORDER EXTERNAL BY sr1.ohc01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.ohc01
            LET l_ohc041 = sr1.ohc041
            LET l_ohc04_ohc041 = NULL #FUN-C30085 add
            IF NOT cl_null(sr1.ohc04) AND NOT cl_null(l_ohc041) THEN 
               LET l_ohc04_ohc041 = sr1.ohc04,'-',l_ohc041
            ELSE 
               IF NOT cl_null(sr1.ohc04) AND cl_null(l_ohc041) THEN
                  LET l_ohc04_ohc041 = sr1.ohc04
               END IF
               IF cl_null(sr1.ohc04) AND NOT cl_null(l_ohc041) THEN
                  LET l_ohc04_ohc041 = l_ohc041
               END IF
            END IF
            LET l_lineno = 0
            PRINTX l_ohc04_ohc041
            PRINTX l_ohc041
        
        ON EVERY ROW
            LET l_flag2 = 0
            LET l_flag1 = 0 
            LET l_flag3 = 0
            LET l_flag4 = 0
            LET l_flag5 = 0
            LET l_flag6 = 0
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE col2 = '0'",
                        " AND col1 = '",sr1.ohc01 CLIPPED,"'"
            START REPORT axmg762_subrep01
            DECLARE axmg762_repcur1 CURSOR FROM l_sql
            FOREACH axmg762_repcur1 INTO sr2_1.*
               LET l_flag1 = 1
               OUTPUT TO REPORT axmg762_subrep01(sr2_1.*)
            END FOREACH
            FINISH REPORT axmg762_subrep01

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE col2 = '1'",
                        " AND col1 = '",sr1.ohc01 CLIPPED,"'"
            START REPORT axmg762_subrep02
            DECLARE axmg762_repcur2 CURSOR FROM l_sql
            FOREACH axmg762_repcur2 INTO sr2_2.*
               LET l_flag2 = 1
               OUTPUT TO REPORT axmg762_subrep02(sr2_2.*)
            END FOREACH
            FINISH REPORT axmg762_subrep02

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE col2 = '2'",
                        " AND col1 = '",sr1.ohc01 CLIPPED,"'"
            START REPORT axmg762_subrep03
            DECLARE axmg762_repcur3 CURSOR FROM l_sql
            FOREACH axmg762_repcur3 INTO sr2_3.*
               LET l_flag3 = 1
               OUTPUT TO REPORT axmg762_subrep03(sr2_3.*)

            END FOREACH
            FINISH REPORT axmg762_subrep03

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE col2 = '3'",
                        " AND col1 = '",sr1.ohc01 CLIPPED,"'"
            START REPORT axmg762_subrep04
            DECLARE axmg762_repcur4 CURSOR FROM l_sql
            FOREACH axmg762_repcur4 INTO sr2_4.*
               LET l_flag4 = 1
               OUTPUT TO REPORT axmg762_subrep04(sr2_4.*)
            END FOREACH
            FINISH REPORT axmg762_subrep04

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE col2 = '4'",
                        " AND col1 = '",sr1.ohc01 CLIPPED,"'"
            START REPORT axmg762_subrep05
            DECLARE axmg762_repcur5 CURSOR FROM l_sql
            FOREACH axmg762_repcur5 INTO sr2_5.*
               LET l_flag5 = 1
               OUTPUT TO REPORT axmg762_subrep05(sr2_5.*)
            END FOREACH
            FINISH REPORT axmg762_subrep05

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE col2 = '5'",
                        " AND col1 = '",sr1.ohc01 CLIPPED,"'"
            START REPORT axmg762_subrep06
            DECLARE axmg762_repcur6 CURSOR FROM l_sql
            FOREACH axmg762_repcur6 INTO sr2_6.*
               LET l_flag6 = 1
               OUTPUT TO REPORT axmg762_subrep06(sr2_6.*)
            END FOREACH
            FINISH REPORT axmg762_subrep06

            PRINTX l_flag1
            PRINTX l_flag2
            PRINTX l_flag3
            PRINTX l_flag4 
            PRINTX l_flag5
            PRINTX l_flag6
          
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.ohc01

        
        ON LAST ROW

END REPORT

REPORT axmg762_subrep01(sr2_1)
   DEFINE sr2_1 sr2_t
   DEFINE l_display  STRING 
   ORDER EXTERNAL BY sr2_1.col1
   FORMAT
      ON EVERY ROW
          IF cl_null(sr2_1.col4) THEN
             LET l_display = "N"
          ELSE
             LET l_display = "Y"
          END IF
          PRINTX l_display
          PRINTX sr2_1.*
END REPORT

REPORT axmg762_subrep02(sr2_2)
   DEFINE sr2_2 sr2_t
   DEFINE l_display LIKE type_file.chr1

   ORDER EXTERNAL BY sr2_2.col1
   FORMAT
      ON EVERY ROW
          IF cl_null(sr2_2.col4) THEN
             LET l_display = 'N'
          ELSE
             LET l_display = 'Y'
          END IF
          PRINTX l_display
          PRINTX sr2_2.*
END REPORT

REPORT axmg762_subrep03(sr2_3)
   DEFINE sr2_3 sr2_t
   DEFINE l_display LIKE type_file.chr1
 
   ORDER EXTERNAL BY sr2_3.col1
   FORMAT
      ON EVERY ROW
          IF cl_null(sr2_3.col4) THEN
             LET l_display = 'N'
          ELSE
             LET l_display = 'Y'
          END IF
          PRINTX l_display
          PRINTX sr2_3.*
END REPORT

REPORT axmg762_subrep04(sr2_4)
   DEFINE sr2_4 sr2_t
   DEFINE l_display LIKE type_file.chr1

   ORDER EXTERNAL BY sr2_4.col1
   FORMAT
      ON EVERY ROW
          IF cl_null(sr2_4.col4) THEN
             LET l_display = 'N'
          ELSE
             LET l_display = 'Y'
          END IF
          PRINTX l_display
          PRINTX sr2_4.*
END REPORT

REPORT axmg762_subrep05(sr2_5)
   DEFINE sr2_5 sr2_t
   DEFINE l_display LIKE type_file.chr1

   ORDER EXTERNAL BY sr2_5.col1
   FORMAT
      ON EVERY ROW
          IF cl_null(sr2_5.col4) THEN
             LET l_display = 'N'
          ELSE
             LET l_display = 'Y'
          END IF
          PRINTX l_display
          PRINTX sr2_5.*
END REPORT

REPORT axmg762_subrep06(sr2_6)
   DEFINE sr2_6 sr2_t
   DEFINE l_display LIKE type_file.chr1

   ORDER EXTERNAL BY sr2_6.col1
   FORMAT
      ON EVERY ROW
          IF cl_null(sr2_6.col4) THEN
             LET l_display = 'N'
          ELSE
             LET l_display = 'Y'
          END IF
          PRINTX l_display
          PRINTX sr2_6.*
END REPORT

###GENGRE###END
