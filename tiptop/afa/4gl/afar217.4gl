# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: afar217.4gl
# Descriptions...: 資產標籤列印
# Date & Author..: 96/06/18 By Sophia
# Modify.........: No.CHI-480001 04/08/11 By Danny  增加資產停用選項
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710083 07/02/01 By Ray Crystal Report修改
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加 CR 參數
# Modify.........: No.MOD-880175 08/08/22 By Sarah CALL cl_prt_cs1()時,前面不需要CALL cl_del_data()
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.MOD-950224 09/05/21 By wujie  正常使用中排除出售和銷帳的
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B20106 11/02/18 By yinhy 增加"附號"栏位
# Modify.........: NO:FUN-B80081 11/11/01 By Sakura faj105相關程式段Mark
# Modify.........: No.TQC-C10039 12/01/20 By wangrr 整合單據列印EF簽核
# Modify.........: No:MOD-C30044 12/03/06 By Polly 1.l_sql/tm.wc 改為 STRING
#                                                  2.需抓取已確認的資產
# Modify.........: No.FUN-C40020 12/07/31 By qirl   MARK CR報表列印簽核圖片

DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD				#Print condition RECORD
          #wc      LIKE type_file.chr1000,      #Where condition #No.FUN-680070 VARCHAR(1000) #MOD-C30044 mark
           wc      STRING,                 	#MOD-C30044 add
           a       LIKE type_file.num5,         #No.FUN-680070 SMALLINT
           c       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
           d       LIKE type_file.chr1,         # No.CHI-480001       #No.FUN-680070 VARCHAR(1)
       	   more    LIKE type_file.chr1   	# Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
              END RECORD,
          l_rec           LIKE type_file.num5,  #No.FUN-680070 SMALLINT
          b               LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          a               LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          i,j             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          l_string        LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(13)
          g_count         LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
#No.FUN-710083 --begin
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  g_str      STRING
#No.FUN-710083 --end
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
#TQC-C10039--add--start---
  LET g_sql="faj01.faj_file.faj01,faj02.faj_file.faj02,",
             "faj022.faj_file.faj022,faj20.faj_file.faj20,",
             "gem02.gem_file.gem02,faj19.faj_file.faj19,",
             "gen02.gen_file.gen02,faj06.faj_file.faj06,",
             "faj07.faj_file.faj07,faj08.faj_file.faj08,",
             "faj17.faj_file.faj17,faj25.faj_file.faj25,",
             "faj47.faj_file.faj47,faj10.faj_file.faj10,",
             "pmc03.pmc_file.pmc03"
#            "sign_type.type_file.chr1"                                # No.FUN-C40020 mark
#            "sign_img.type_file.blob,sign_show.type_file.chr1,",       # No.FUN-C40020 mark
#            "sign_str.type_file.chr1000"                                 # No.FUN-C40020 mark
   LET l_table = cl_prt_temptable('afar217',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
#TQC-C10039--add--end-----
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
 
   LET g_pdate  = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.a     = ARG_VAL(8)
   LET tm.d     = ARG_VAL(9)   #CHI-480001  #TQC-610055  
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#No.FUN-710083 --begin
#  LET g_sql ="faj01.faj_file.faj01,",
#             "faj02.faj_file.faj02,",
#             "faj022.faj_file.faj022,",
#             "faj20.faj_file.faj20,",
#             "gem02.gem_file.gem02,",
#             "faj19.faj_file.faj19,",
#             "gen02.gen_file.gen02,",
#             "faj06.faj_file.faj06,",
#             "faj07.faj_file.faj07,",
#             "faj08.faj_file.faj08,",
#             "faj17.faj_file.faj17,",
#             "faj25.faj_file.faj25,",
#             "faj47.faj_file.faj47,",
#             "faj10.faj_file.faj10,",
#             "pmc03.pmc_file.pmc03"
#  LET l_table = cl_prt_temptable('afar217',g_sql) CLIPPED
#  IF l_table = -1 THEN EXIT PROGRAM END IF
#  LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
#              " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?,",
#              "        ?, ?, ?, ?, ?, ?)"
#  PREPARE insert_prep FROM g_sql
#  IF STATUS THEN
#     CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
#  END IF
#No.FUN-710083 --end
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN    # If background job sw is off
      CALL afar217_tm(0,0)		     # Input print condition
   ELSE
      CALL afar217()		             # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afar217_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_direct      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW afar217_w AT p_row,p_col WITH FORM "afa/42f/afar217"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a    = 11
   LET tm.c    = '1'
   LET tm.d    = '0'                         #No.CHI-480001
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON faj01,faj02,faj022,faj021,faj20,faj19,faj25  #TQC-B20106 add faj022
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
         LET INT_FLAG = 0 CLOSE WINDOW afar217_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME tm.a,tm.c,tm.more        # Condition
 
      INPUT BY NAME tm.a,tm.d,tm.more WITHOUT DEFAULTS     #No.CHI-480001
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD a
            IF tm.a <11 OR  tm.a > 66  OR cl_null(tm.a) THEN
               CALL cl_err('','mfg4054',0)
               NEXT FIELD a
            END IF
 
       { AFTER FIELD c
            IF tm.c NOT MATCHES "[123]" OR cl_null(tm.c) THEN
               NEXT FIELD c
            END IF
        }
 
         #No.CHI-480001
         AFTER FIELD d
            IF cl_null(tm.d) OR tm.d NOT MATCHES "[012]" THEN
               NEXT FIELD FORMONLY.d
            END IF
         #end
 
         AFTER FIELD more
            IF tm.more NOT MATCHES '[YN]' OR tm.more IS NULL THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
            LET l_direct = 'U'
 
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
         LET INT_FLAG = 0 CLOSE WINDOW afar217_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='afar217'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar217','9031',1)
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
                            " '",tm.a CLIPPED,"'",
                            " '",tm.d CLIPPED,"'",   #CHI-480001   
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afar217',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW afar217_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar217()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW afar217_w
END FUNCTION
 
FUNCTION afar217()
   DEFINE l_name   LIKE type_file.chr20,        #External(Disk) file name       #No.FUN-680070 VARCHAR(20)
         #l_time   LIKE type_file.chr8	        #No.FUN-6A0069
         #l_sql    LIKE type_file.chr1000,      #RDSQL STATEMENT  #No.FUN-680070 VARCHAR(1000) #MOD-C30044 mark
          l_sql    STRING,	                #MOD-C30044 add
          l_za05   LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(40)
          l_rec    LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          sr      RECORD
                  faj01   LIKE faj_file.faj01,	 #資產序號
                  faj02   LIKE faj_file.faj02, 	 #財產編號
                  faj022  LIKE faj_file.faj022,	 #財產附號
                  faj20   LIKE faj_file.faj20,	 #部門代號
                  gem02   LIKE gem_file.gem02,   #部門名稱
                  faj19   LIKE faj_file.faj19,   #保管人代號
                  gen02   LIKE gen_file.gen02,   #保管人名稱
                  faj06   LIKE faj_file.faj06,   #中文名稱
                  faj07   LIKE faj_file.faj07,   #英文名稱
                  faj08   LIKE faj_file.faj08,   #型號
                  faj17   LIKE faj_file.faj17,   #數量
                  faj25   LIKE faj_file.faj25,   #購進日期
                  faj47   LIKE faj_file.faj47,   #訂單號碼
                  faj10   LIKE faj_file.faj10,   #廠商
                  pmc03   LIKE pmc_file.pmc03    #廠商名稱
                  END RECORD
#TQC-C10039--add--start---
#  DEFINE l_img_blob     LIKE type_file.blob # No.FUN-C40020 mark 
#  LOCATE l_img_blob IN MEMORY               # No.FUN-C40020 mark
   CALL cl_del_data(l_table)   
#TQC-C10039--add--end-----
    #CALL cl_del_data(l_table)     #No.FUN-710083   #MOD-880175 mark
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-710083 --begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'afar217'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-710083 --end
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fajuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fajgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fajgrup IN ",cl_chk_tgrup_list()
     #     END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')
     #End:FUN-980030
#TQC-C10039--add--start------
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"    #, ?,?,?,?)"No.FUN-C40020 mark
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN  
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM 
   END IF             
#TQC_C10039--add--end--------   
   LET l_sql = "SELECT faj01,faj02,faj022,faj20,gem02,faj19,gen02,faj06,",
               "       faj07,faj08,faj17,faj25,faj47,faj10,pmc03",
               "  FROM faj_file ",
               "       LEFT OUTER JOIN gem_file ON faj20 = gem01 ",
               "       LEFT OUTER JOIN gen_file ON faj19 = gen01 ",
               "       LEFT OUTER JOIN pmc_file ON faj10 = pmc01 ",
               " WHERE ",tm.wc CLIPPED,
               "   AND fajconf = 'Y' "               #MOD-C30044 add
     #No.CHI-480001
     IF tm.d = '1' THEN    #停用
        #LET l_sql = l_sql CLIPPED," AND faj105 = 'Y' " #No.FUN-B80081 mark
         LET l_sql = l_sql CLIPPED," AND faj43 = 'Z' "  #No.FUN-B80081 add 
     END IF
     IF tm.d = '0' THEN    #正常使用
        LET l_sql = l_sql CLIPPED,
                   #" AND (faj105 = 'N' OR faj105 IS NULL OR faj105 = ' ') ", #No.FUN-B80081 mark
                    " AND faj43<>'Z' ", #No.FUN-B80081 add
                    " AND faj43!='5' AND (faj43 !='6' OR faj43 ='6' AND faj17 >faj58)"   #No.MOD-950224
     END IF
     #end
#TQC-C10039--add--start------
   PREPARE afar217_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   DECLARE r217_cs1 CURSOR FOR afar217_prepare1
   FOREACH r217_cs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      EXECUTE insert_prep USING 
         sr.faj01, sr.faj02,  sr.faj022, sr.faj20, sr.gem02 ,
         sr.faj19, sr.gen02,  sr.faj06,  sr.faj07, sr.faj08,
         sr.faj17, sr.faj25,  sr.faj47,  sr.faj10, sr.pmc03
        #""      , l_img_blob,"N"      , ""            # No.FUN-C40020 mark 
   END FOREACH
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = tm.wc,";",tm.d,";"
   LET g_cr_table = l_table                   #主報表的temp table名稱
   LET g_cr_apr_key_f = "faj01|faj02|faj022"  #報表主鍵欄位名稱，用"|"隔開 
#TQC_C10039--add--end--------
#No.FUN-710083 --begin
   # CALL cl_prt_cs1('afar217',l_sql,'')   #TQC-730088
   # CALL cl_prt_cs1('afar217','afar217',l_sql,'')  #TQC_C10039 mark--
   CALL cl_prt_cs3('afar217','afar217',g_sql,g_str)
#    LET l_rec = 0
#    LET i     = 0
#    LET j     = 0
#    PREPARE afar217_prepare1 FROM l_sql
#    IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
#       EXIT PROGRAM
#          
#    END IF
#    DECLARE afar217_curs1 CURSOR FOR afar217_prepare1
#    CALL cl_outnam('afar217') RETURNING l_name
#    START REPORT afar217_rep TO l_name
#    LET g_cnt = 0
#    FOREACH afar217_curs1 INTO sr.*
#      IF SQLCA.sqlcode != 0 THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
#      END IF
#      LET g_cnt = g_cnt + 1
#      OUTPUT TO REPORT afar217_rep(sr.*)
#    END FOREACH
 
#    FINISH REPORT afar217_rep
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-710083 --end
END FUNCTION
 
#No.FUN-710083 --begin
#REPORT afar217_rep(sr)
#   DEFINE
#           l_no            LIKE type_file.num5,         #No.FUN-680070 SMALLINT
#          sr               RECORD
#                  faj01   LIKE faj_file.faj01,	 #資產序號
#                  faj02   LIKE faj_file.faj02, 	 #財產編號
#                  faj022  LIKE faj_file.faj022,	 #財產附號
#                  faj20   LIKE faj_file.faj20,	 #部門代號
#                  gem02   LIKE gem_file.gem02,   #部門名稱
#                  faj19   LIKE faj_file.faj19,   #保管人代號
#                  gen02   LIKE gen_file.gen02,   #保管人名稱
#                  faj06   LIKE faj_file.faj06,   #中文名稱
#                  faj07   LIKE faj_file.faj07,   #英文名稱
#                  faj08   LIKE faj_file.faj08,   #型號
#                  faj17   LIKE faj_file.faj17,   #數量
#                  faj25   LIKE faj_file.faj25,   #購進日期
#                  faj47   LIKE faj_file.faj47,   #訂單號碼
#                  faj10   LIKE faj_file.faj10,   #廠商
#                  pmc03   LIKE pmc_file.pmc03    #廠商名稱
#                  END RECORD,
#          tmp           ARRAY[66,3] OF LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(40)
# 
#  OUTPUT TOP MARGIN 0 LEFT MARGIN g_left_margin BOTTOM MARGIN 0 PAGE LENGTH g_page_line
#  ORDER BY sr.faj02
#FORMAT
# 
# ON EVERY ROW
## 所輸入每個LABEL的長度
#     IF j = 0 THEN
#        FOR a = 1 TO tm.a
#            LET tmp[a,1]=NULL LET tmp[a,2]=NULL LET tmp[a,3]=NULL
#        END FOR
#     END IF
#     LET i = 1 LET j = j + 1
##判斷若序號,編號有任何一行為NULL時,則不列印
#     IF sr.faj01  IS NOT NULL THEN
#        LET tmp[i,j] = sr.faj01
#        LET i = i + 1
#        LET tmp[i,j]= sr.faj02,' ',sr.faj022
#        LET i = i + 1
#        LET tmp[i,j]= sr.faj20,' ',sr.gem02
#        LET i = i + 1
#        LET tmp[i,j]= sr.faj19,' ',sr.gen02
#        LET i = i + 1
#        LET tmp[i,j]= sr.faj06
#        LET i = i + 1
#        LET tmp[i,j]= sr.faj07
#        LET i = i + 1
#        LET tmp[i,j]= sr.faj08
#        LET i = i + 1
#        LET tmp[i,j]= sr.faj17
#        LET i = i + 1
#        LET tmp[i,j]= sr.faj25
#        LET i = i + 1
#        LET tmp[i,j]= sr.faj47
#        LET i = i + 1
#        LET tmp[i,j]= sr.faj10,' ',sr.pmc03
#        LET i = i + 1
#     END IF
#     LET tmp[i,j] = ' '
#     LET i = i + 1
## 當所選擇所需列數為1
#     IF tm.c= 1 THEN
#        FOR a = 1 TO tm.a PRINT g_x[a] CLIPPED, tmp[a,j] END FOR
#        LET j = 0
#     END IF
## 當所選擇所需列數為2
#     IF tm.c= '2' AND j = 2 THEN
#        FOR a = 1 TO tm.a PRINT g_x[a] CLIPPED,tmp[a,1],tmp[a,2] END FOR
#        LET j = 0
#     END IF
## 當所選擇所需列數為3
#     IF tm.c= '3' AND j = 3 THEN
#        FOR a = 1 TO tm.a
#            PRINT g_x[a] CLIPPED,tmp[a,1],tmp[a,2],tmp[a,3]
#        END FOR
#        LET j = 0
#     END IF
#
#   ON LAST ROW
##當陣列中還有尚未列印的資料時
##若列數是貳時，所可能剩餘的只能一筆
#     IF tm.c = '2' AND j < 2 THEN
#        FOR a = 1 TO tm.a PRINT g_x[a] CLIPPED,tmp[a,j] END FOR
#     END IF
##若列數是三時，所可能剩餘的只能一筆或兩筆
#     IF tm.c = '3' AND j < 3 THEN
#        FOR a = 1 TO tm.a PRINT g_x[a] CLIPPED,tmp[a,1],tmp[a,2] END FOR
#     END IF
#END REPORT
#No.FUN-710083 --end
#Patch....NO.TQC-610035 <001> #
