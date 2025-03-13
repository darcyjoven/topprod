# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: axmr762.4gl
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
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改
# Modify.........: No.TQC-C10039 12/01/17 By JinJJ  CR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.TQC-C20049 12/02/09 By JinJJ  CR報表列印TIPTOP與EasyFlow簽核圖片删除i 

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

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
   LET g_sql = "ohc01.ohc_file.ohc01,",
               "ohc02.ohc_file.ohc02,",
               "ohc13.ohc_file.ohc13,",
               "ohc04.ohc_file.ohc04,",
               "ohc041.ohc_file.ohc041,",
               "gen02_2.gen_file.gen02,",
               "ohc05.ohc_file.ohc05,",
               "ohc08.ohc_file.ohc08,",
               "ohc18.ohc_file.ohc18,",
               "ohc081.ohc_file.ohc081,",
               "ima021.ima_file.ima021"
#              "sign_type.type_file.chr1, sign_img.type_file.blob,",    #簽核方式, 簽核圖檔     #TQC-C10039  #TQC-C20049 Mark TQC-C10039
#              "sign_show.type_file.chr1,sign_str.type_file.chr1000"    #是否顯示簽核資料(Y/N)  #TQC-C10039  #TQC-C20049 Mark TQC-C10039
 
   LET l_table = cl_prt_temptable('axmr762',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "col1.ohc_file.ohc01,",        #單號
               "col2.ohf_file.ohf02,",        #類別
               "col3.ohd_file.ohd02,",        #行序
               "col4.ohd_file.ohd03,",        #內容
               "col5.gen_file.gen02,",        #主辦
               "col6.gen_file.gen02"          #審核
 
   LET l_table1 = cl_prt_temptable('axmr762_1',g_sql) CLIPPED   # 產生Temp Table
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                    # Temp Table產生
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r762_tm(0,0)	
      ELSE CALL r762()		
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION r762_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680137 SMALLINT
       l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   OPEN WINDOW r762_w WITH FORM "axm/42f/axmr762"
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
       CLOSE WINDOW r762_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
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
      CLOSE WINDOW r762_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='axmr762'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr762','9031',1)
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
         CALL cl_cmdat('axmr762',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r762_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r762()
   ERROR ""
END WHILE
   CLOSE WINDOW r762_w
END FUNCTION
 
FUNCTION r762()
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
#DEFINE    l_img_blob     LIKE type_file.blob    #TQC-C10039  #TQC-C20049 Mark TQC-C10039
 
   #str FUN-710080 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)                #FUN-790029 add
   #------------------------------ CR (2) ------------------------------#
   #end FUN-710080 add
#   LOCATE l_img_blob IN MEMORY    #TQC-C10039  #TQC-C20049 Mark TQC-C10039
 
  #CHI-7A0014 add str
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
#               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)" #TQC-C10039 add 4?   #TQC-C20049 Mark TQC-C10039
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"                
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?)"                   
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF
            
   LET g_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               "   SET col5=?,col6=?",
               " WHERE col1=? AND col2='0'"
   PREPARE update_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('update_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF
  #CHI-7A0014 add end
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axmr762'
 
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
               "        ohc10,'',ohc11,'',ohc05,ohc08,ohc18,ohc13,ohc081,ima021 ",
               "   FROM ohc_file,OUTER ima_file ",
               "  WHERE ",tm.wc CLIPPED,
               "    AND ima_file.ima01 = ohc_file.ohc08 ",
               "    AND ohcconf != 'X' "
   IF tm.type MATCHES'[012]' THEN
      LET l_sql = l_sql CLIPPED," AND ohc03 ='",tm.type,"'"
   END IF
 
   DISPLAY l_sql
   PREPARE r762_p FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:r762_p',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   DECLARE r762_c CURSOR FOR r762_p
 
   FOREACH r762_c INTO sr.*
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
      SELECT gen02 INTO sr.gen02_1 FROM gen_file WHERE gen01 = sr.ohc10
 
      #處理人員
      SELECT gen02 INTO sr.gen02_2 FROM gen_file WHERE gen01 = sr.ohc11
 
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
      DECLARE r762_cur1 CURSOR FOR
     #CHI-7A0022 mod
     #SELECT ohf01,ohf02,ohd02,ohd03,ohf03,ohf04  
     #  FROM ohf_file,ohd_file
     # WHERE ohf01 = sr.ohc01
     #   AND ohd01 = sr.ohc01
     #   AND ohf02 = '0'
     #FOREACH r762_cur1 INTO l_col1,l_col2,l_col3,l_col4,l_col5,l_col6   
     #   SELECT gen02 INTO l_gen02a FROM gen_file WHERE gen01 = l_col5
     #   SELECT gen02 INTO l_gen02b FROM gen_file WHERE gen01 = l_col6
     #   EXECUTE insert_prep1 USING 
     #      l_col1,l_col2,l_col3,l_col4,l_gen02a,l_gen02b   
     #END FOREACH 
 
      SELECT ohc01,'0',ohd02,ohd03  
        FROM ohc_file,ohd_file
       WHERE ohc01 = sr.ohc01
         AND ohc01 = ohd01
 
      FOREACH r762_cur1 INTO l_col1,l_col2,l_col3,l_col4   
         EXECUTE insert_prep1 USING 
            l_col1,l_col2,l_col3,l_col4,'',''   
         DECLARE r762_cur1_1 CURSOR FOR
            SELECT ohf03,ohf04 
              FROM ohf_file
             WHERE ohf01=l_col1
               AND ohf02='0'
         FOREACH r762_cur1_1 INTO l_col5,l_col6   
            SELECT gen02 INTO l_gen02a FROM gen_file WHERE gen01 = l_col5
            SELECT gen02 INTO l_gen02b FROM gen_file WHERE gen01 = l_col6
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
      DECLARE r762_cur2 CURSOR FOR
     #CHI-7A0022 mod
     #SELECT ohf01,ohf02,ohg03,ohg04,ohf03,ohf04  
     #  FROM ohf_file,ohg_file
     # WHERE ohf01 = sr.ohc01
     #   AND ohf01 = ohg01
     #   AND ohf02 = ohg02
     #   AND ohf02 = '1'
      SELECT ohc01,ohf02,ohg03,ohg04,ohf03,ohf04  
        FROM ohc_file,ohg_file,ohf_file  
       WHERE ohc01 = sr.ohc01
         AND ohc01 = ohg01
         AND ohc01 = ohf01
         AND ohf02 = ohg02
         AND ohf02 = '1'
     #CHI-7A0022 mod
     
      FOREACH r762_cur2  INTO l_col1,l_col2,l_col3,l_col4,l_col5,l_col6   
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
      DECLARE r762_cur3 CURSOR FOR
     #CHI-7A0022 mod
     #SELECT ohf01,ohf02,ohg03,ohg04,ohf03,ohf04  
     #  FROM ohf_file,ohg_file
     # WHERE ohf01 = sr.ohc01
     #   AND ohf01 = ohg01
     #   AND ohf02 = ohg02
     #   AND ohf02 = '2'
      SELECT ohc01,ohf02,ohg03,ohg04,ohf03,ohf04  
        FROM ohc_file,ohg_file,ohf_file
       WHERE ohc01 = sr.ohc01
         AND ohc01 = ohg01
         AND ohc01 = ohf01
         AND ohf02 = ohg02
         AND ohf02 = '2'
     #CHI-7A0022 mod
      FOREACH r762_cur3 INTO l_col1,l_col2,l_col3,l_col4,l_col5,l_col6   
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
      DECLARE r762_cur4 CURSOR FOR
     #CHI-7A0022 mod
     #SELECT ohf01,ohf02,ohg03,ohg04,ohf03,ohf04  
     #  FROM ohf_file,ohg_file
     # WHERE ohf01 = sr.ohc01
     #   AND ohf01 = ohg01
     #   AND ohf02 = ohg02
     #   AND ohf02 = '3'
      SELECT ohc01,ohf02,ohg03,ohg04,ohf03,ohf04  
        FROM ohc_file,ohg_file,ohf_file
       WHERE ohc01 = sr.ohc01
         AND ohc01 = ohg01
         AND ohc01 = ohf01
         AND ohf02 = ohg02
         AND ohf02 = '3'
     #CHI-7A0022 mod
      FOREACH r762_cur4 INTO l_col1,l_col2,l_col3,l_col4,l_col5,l_col6   
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
      DECLARE r762_cur5 CURSOR FOR
     #CHI-7A0022 mod
     #SELECT ohf01,ohf02,ohg03,ohg04,ohf03,ohf04  
     #  FROM ohf_file,ohg_file
     # WHERE ohf01 = sr.ohc01
     #   AND ohf01 = ohg01
     #   AND ohf02 = ohg02
     #   AND ohf02 = '4'
      SELECT ohc01,ohf02,ohg03,ohg04,ohf03,ohf04  
        FROM ohc_file,ohg_file,ohf_file
       WHERE ohc01 = sr.ohc01
         AND ohc01 = ohg01
         AND ohc01 = ohf01
         AND ohf02 = ohg02
         AND ohf02 = '4'
     #CHI-7A0022 mod
      FOREACH r762_cur5 INTO l_col1,l_col2,l_col3,l_col4,l_col5,l_col6   
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
      DECLARE r762_cur6 CURSOR FOR
     #CHI-7A0022 mod
     #SELECT ohf01,ohf02,ohg03,ohg04,ohf03,ohf04  
     #  FROM ohf_file,ohg_file
     # WHERE ohf01 = sr.ohc01
     #   AND ohf01 = ohg01
     #   AND ohf02 = ohg02
     #   AND ohf02 = '5'
      SELECT ohc01,ohf02,ohg03,ohg04,ohf03,ohf04  
        FROM ohc_file,ohg_file,ohf_file
       WHERE ohc01 = sr.ohc01
         AND ohc01 = ohg01
         AND ohc01 = ohf01
         AND ohf02 = ohg02
         AND ohf02 = '5'
     #CHI-7A0022 mod
      FOREACH r762_cur6 INTO l_col1,l_col2,l_col3,l_col4,l_col5,l_col6   
         SELECT gen02 INTO l_gen02a FROM gen_file WHERE gen01 = l_col5
         SELECT gen02 INTO l_gen02b FROM gen_file WHERE gen01 = l_col6
         EXECUTE insert_prep1 USING 
            l_col1,l_col2,l_col3,l_col4,l_gen02a,l_gen02b   
      END FOREACH 
 
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
      EXECUTE insert_prep USING
         sr.ohc01  ,sr.ohc02,sr.ohc13,sr.ohc04,sr.ohc041,
         sr.gen02_2,sr.ohc05,sr.ohc08,sr.ohc18,sr.ohc081,sr.ima021
#         "",l_img_blob,"N",""    #TQC-C10039 add "",l_img_blob,"N",""  #TQC-C20049 Mark TQC-C10039 
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
      #------------------------------ CR (3) ------------------------------#
     #end FUN-710080 add
   END FOREACH
 
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|", 
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " WHERE col2='0'","|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " WHERE col2='1'","|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " WHERE col2='2'","|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " WHERE col2='3'","|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " WHERE col2='4'","|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " WHERE col2='5'"
 
   #str FUN-710080 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
  #LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED    #CHI-7A0014 mark
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'ohc01,ohc02,ohc06,ohc13')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
#   LET g_cr_table = l_table                 #主報表的temp table名稱   #TQC-C100399  #TQC-C20049 Mark TQC-C10039 
#   LET g_cr_apr_key_f = "ohc01"             #報表主鍵欄位名稱  #TQC-C10039  #TQC-C20049 Mark TQC-C10039 
   CALL cl_prt_cs3('axmr762','axmr762',l_sql,g_str)
   #------------------------------ CR (4) ------------------------------#
   #end FUN-710080 add
 
END FUNCTION
 
{
REPORT r762_rep(sr)
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
