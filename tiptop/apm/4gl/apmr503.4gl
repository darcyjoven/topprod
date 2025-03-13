# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmr503.4gl
# Descriptions...: 採購單跟催表
# Input parameter:
# Return code....:
# Date & Author..: 91/09/30 By Nora
# Modify.........: 92/11/11 By Apple
#                  1.資料讀取有問題
#                  增加列印交期確認資料
# Modify.........:No.MOD-490148 04/09/09 By Smapmin 調整報表表頭列印出來的"排列順序"字眼
# Modify.........:No.MOD-490150 04/09/22 By Wiky view時show一半資料
# Modify.........: No.FUN-4A0010 04/10/05 By Yuna 料件編號.廠商.採購員要開窗
# Modify.........: No.FUN-4C0095 05/02/21 By Mandy 報表轉XML
# Modify         : No.MOD-530885 05/03/31 by alexlin VAR CHAR->CHAR
# Modify         : No.MOD-570114 05/08/04 By NIcola 1.已交量應減去驗退量
#                                                   2.應僅考慮pmm25為'2' 的資料
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610085 06/04/04 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.MOD-670130 06/08/02 By Claire 報表超過二頁時表頭列印的"排列順序"會重複列印
# Modify.........: No.FUN-680136 06/09/13 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-750098 07/06/27 By hongmei Crystal Report修改
# Modify.........: No.TQC-780054 07/08/17 By zhoufeng 修改INSERT INTO temptable語法
# Modify.........: No.FUN-940083 09/05/14 By dxfwo   原可收量計算(pmn20-pmn50+pmn55)全部改為(pmn20-pmn50+pmn55+pmn58)
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9A0068 09/10/23 by dxfwo VMI测试结果反馈及相关调整
# Modify.........: No:MOD-B10019 11/01/05 By Summer 將l_sql定義為STRING
# Modify.........: No:FUN-C30059 12/04/09 By Sakura 程式中加ON ACTION help
# Modify.........: No.TQC-D20016 13/02/19 By xuxz 添加備註二
# Modify.........: No.TQC-D20017 13/02/19 By xuxz 添加採購單號開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
         #     wc   VARCHAR(700),                  # Where Condition
              wc   STRING,                      #TQC-630166  # Where Condition
              s    LIKE type_file.chr3,         # Prog. Version..: '5.30.06-13.03.12(03) # 排列項目
              t    LIKE type_file.chr3,         # Prog. Version..: '5.30.06-13.03.12(03) # 同項目是否跳頁
              c    LIKE type_file.chr1,         # Prog. Version..: '5.30.06-13.03.12(01) # 是否列印交期確認資料
              more LIKE type_file.chr1          # Prog. Version..: '5.30.06-13.03.12(01) # 特殊列印條件
              END RECORD
   #       g_dash1    VARCHAR(200),
 
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680136 INTEGER
#DEFINE   g_dash          VARCHAR(400)   #Dash line
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680136 SMALLINT
#DEFINE   g_len          LIKE type_file.num5,    #No.FUN-680136 SMALLINT #Report width(79/132/136)
#DEFINE   g_pageno       LIKE type_file.num5,    #No.FUN-680136 SMALLINT #Report page no
#DEFINE   g_zz05         LIKE zz_file.zz05,      #No.FUN-680136  VARCHAR(1)   #Print tm.wc ?(Y/N)
DEFINE   g_head1         STRING   #Print seqence
DEFINE   l_table         STRING      #NO.FUN-750098                                                                                 
DEFINE   g_str           STRING      #NO.FUN-750098                                                                                 
DEFINE   g_sql           STRING      #NO.FUN-750098
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
#NO.FUN-750098-----Begin 
   LET g_sql ="pmn33.pmn_file.pmn33,", 
              "pmn04.pmn_file.pmn04,",
              "pmn20_n.pmn_file.pmn20,",
              "pmn041.pmn_file.pmn041,",
              "pmn20.pmn_file.pmn20,",
              "pmm09.pmm_file.pmm09,",
              "l_pmd02.pmd_file.pmd02,",
              "pmm12.pmm_file.pmm12,",
              "pmn01.pmn_file.pmn01,",
              "pmn02.pmn_file.pmn02,",
              "pmn14.pmn_file.pmn14,",
              "pmn36.pmn_file.pmn36,",
              "pmn34.pmn_file.pmn34,",
              "pmn06.pmn_file.pmn06,",
              "l_ima021.ima_file.ima021,",
              "pmn50.pmn_file.pmn50,",
              "pmc03.pmc_file.pmc03,",
              "pmc10.pmc_file.pmc10,",
              "gen02.gen_file.gen02,",
              "l_gen02.gen_file.gen02,",
              "pmm04.pmm_file.pmm04,",
              "pmn15.pmn_file.pmn15,",
              "pmz03.pma_file.pma03,",
              "pmz05.pmz_file.pmz05,",
              "pmz06.pmz_file.pmz06,",
              "pmz07.pmz_file.pmz07,",
              "pmz08.pmz_file.pmz08,",
              "pmz09.pmz_file.pmz09,",
              "pmz10.pmz_file.pmz10,",
              "pmz11.pmz_file.pmz11,",
              "pmz12.pmz_file.pmz12,",#TQC-D20016 add備註二
              "g_cnt1.type_file.num5,",
              "g_cnt.type_file.num5"
      
   LET l_table = cl_prt_temptable('apmr503',g_sql) CLIPPED        # 產生Temp Table                                                       
   IF l_table = -1 THEN EXIT PROGRAM END IF                       # Temp Table產生                                                       
#   LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,         #TQC-780054
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,#TQC-780054                                                            
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",                                                                                     
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,", #TQC-D20016 add 備註二
               "        ?,?,?,?,?, ?,?,?,?,?,?,?)"                                                                                   
                                                                                                                                    
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
   #------------------------------ CR (1) ------------------------------#                                                           
#No.FUN-750098--------End  
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
#---------------No.TQC-610085 modify
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#---------------No.TQC-610085 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r503_tm(0,0)		# Input print condition
      ELSE CALL r503()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r503_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-680136 SMALLINT
       l_cmd	      LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r503_w AT p_row,p_col WITH FORM "apm/42f/apmr503"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s      = '123'
   LET tm.c      = 'N'
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
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
   CONSTRUCT BY NAME  tm.wc ON pmn33,pmn36,pmn34,pmn04,pmm09,pmm12,pmm01 #TQC-D20017 add pmm01
     #--No.FUN-4A0010--------
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION CONTROLP
       CASE WHEN INFIELD(pmn04) #料件編號
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
     	      LET g_qryparam.form = "q_ima"
     	      CALL cl_create_qry() RETURNING g_qryparam.multiret
     	      DISPLAY g_qryparam.multiret TO pmn04
     	      NEXT FIELD pmn04
            WHEN INFIELD(pmm09) #廠商編號
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_pmc"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmm09
              NEXT FIELD pmm09
           WHEN INFIELD(pmm12) #採購員
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_gen"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmm12
              NEXT FIELD pmm12
          #TQC-D20017--add--str
          #添加採購單號的開窗代碼段
           WHEN INFIELD(pmm01) #採購員
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_pmm12"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmm01
              NEXT FIELD pmm01
          #TQC-D20017--add--end
        OTHERWISE EXIT CASE
        END CASE
     #--END---------------
 
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
 #     ON ACTION about         #MOD-4C0121
 #        CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121 #FUN-C30059 remark
         CALL cl_show_help()  #MOD-4C0121 #FUN-C30059 remark
 
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
 
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r503_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM 
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.s,tm.c,tm.more
   INPUT BY NAME
         #UI
         tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3,
         tm.c,tm.more
         WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD c
         IF tm.c NOT MATCHES'[YN]' OR CL_NULL(tm.c) THEN
            NEXT FIELD c
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
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
 #     ON ACTION about         #MOD-4C0121
 #        CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121 #FUN-C30059 remark
         CALL cl_show_help()  #MOD-4C0121 #FUN-C30059 remark
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r503_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr503'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr503','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'" ,
                     #--------------No.TQC-610085 add
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.s  CLIPPED,"'" ,
                         " '",tm.t  CLIPPED,"'" ,
                         " '",tm.c  CLIPPED,"'" ,
                     #--------------No.TQC-610085 end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr503',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r503_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r503()
   ERROR ""
END WHILE
   CLOSE WINDOW r503_w
END FUNCTION
 
FUNCTION r503()
   DEFINE l_name     LIKE type_file.chr20, 	   # External(Disk) file name  #No.FUN-680136 VARCHAR(20)
          l_time     LIKE type_file.chr8,  	   # Used time for running the job  #No.FUN-680136 VARCHAR(8)
          l_i        LIKE type_file.num5,  	   # Used time for running the job  #No.FUN-680136 SMALLINT
         #l_sql      LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-680136 VARCHAR(1000) #MOD-B10019 mark
          l_sql      STRING,                       #MOD-B10019 
          l_flag     LIKE type_file.num5,          #NO.FUN-750098
          l_pmd02    LIKE pmd_file.pmd02,          #NO.FUN-750098
          l_pmd05    LIKE pmd_file.pmd05,          #NO.FUN-750098
          l_ima021   LIKE ima_file.ima021,         #NO.FUN-750098
          l_gen02    LIKE gen_file.gen02,          #NO.FUN-750098
          g_cnt1     LIKE type_file.num5,          #NO.FUN-750098
          l_za05     LIKE za_file.za05,            #No.FUN-680136 VARCHAR(40)
          l_order    ARRAY[3] of LIKE pmn_file.pmn04,    #No.FUN-680136 VARCHAR(40) #FUN-5B0105 20->40
          sr         RECORD
                     order1    LIKE    pmn_file.pmn04,   #No.FUN-680136 VARCHAR(40) #FUN-5B0105 20->40
                     order2    LIKE    pmn_file.pmn04,   #No.FUN-680136 VARCHAR(40) #FUN-5B0105 20->40
                     order3    LIKE    pmn_file.pmn04,   #No.FUN-680136 VARCHAR(40) #FUN-5B0105 20->40
                     pmn33     LIKE    pmn_file.pmn33,   #交貨日
                     pmn04     LIKE    pmn_file.pmn04,   #料件編號
                     pmn20     LIKE    pmn_file.pmn20,   #訂購量
                     pmn20_n   LIKE    pmn_file.pmn20,   #未交量
                     pmm09     LIKE    pmm_file.pmm09,   #廠商編號
                     pmc03     LIKE    pmc_file.pmc03,   #簡稱
                     pmn16     LIKE    pmn_file.pmn16,   #狀況
                     pmm12     LIKE    pmm_file.pmm12,   #採購員
                     gen02     LIKE    gen_file.gen02,   #採購員簡稱
                     pmn01     LIKE    pmn_file.pmn01,   #採購單號
                     pmn02     LIKE    pmn_file.pmn02,   #項次
                     pmn14     LIKE    pmn_file.pmn14,   #部份交貨
                     pmn36     LIKE    pmn_file.pmn36,   #最近確認日
                     pmn34     LIKE    pmn_file.pmn34,   #到廠日
                     pmn06     LIKE    pmn_file.pmn06,   #廠商料件編號
                     pmn50     LIKE    pmn_file.pmn50,   #收貨量
                     pmc10     LIKE    pmc_file.pmc10,   #電話
                     pmm04     LIKE    pmm_file.pmm04,   #採購日期
                     pmn15     LIKE    pmn_file.pmn15,   #提前交貨
                     pmn041    LIKE    pmn_file.pmn041,  #品名規格
                     pmz03     LIKE    pmz_file.pmz03,   #次數
                     pmz05     LIKE    pmz_file.pmz05,   #答應日期
                     pmz06     LIKE    pmz_file.pmz06,   #交期確認日期
                     pmz07     LIKE    pmz_file.pmz07,   #預計到廠日
                     pmz08     LIKE    pmz_file.pmz08,   #預計到庫日
                     pmz09     LIKE    pmz_file.pmz09,   #確認交貨數量
                     pmz10     LIKE    pmz_file.pmz10,   #確認人
                     pmz11     LIKE    pmz_file.pmz11    #備註一
                     ,pmz12     LIKE    pmz_file.pmz12   #TQC-D20016 add 備註二
                     END RECORD
      CALL cl_del_data(l_table)   #No.FUN-750098
      SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
      SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    #No.FUN-750098
#     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'apmr503'
#     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
#     FOR  l_i = 1 TO g_len LET g_dash[l_i,l_i] = '=' END FOR
#     FOR  l_i = 1 TO g_len LET g_dash1[l_i,l_i] = '-' END FOR
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc = tm.wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
     #End:FUN-980030
 
 
     IF tm.c='N' THEN
        LET l_sql = " SELECT '','','',",
#                   " pmn33,pmn04,pmn20,(pmn20-pmn50+pmn55),pmm09,pmc03,",       #No.FUN-940083
                    " pmn33,pmn04,pmn20,(pmn20-pmn50+pmn55+pmn58),pmm09,pmc03,", #No.FUN-940083
                    " pmn16,pmm12,gen02,pmn01,pmn02,pmn14,pmn36,pmn34,pmn06,",
                     " pmn50-pmn55,pmc10,pmm04,pmn15,pmn041,",   #No.MOD-570114
                    " 0,' ',' ',' ',' ',0,' ',' ',' '",#TQC-D20016 add ,' '
                    " FROM pmm_file,pmn_file, OUTER pmc_file, OUTER gen_file,",
                    " OUTER ima_file ",
                    " WHERE pmm01 = pmn01 AND pmc_file.pmc01 = pmm_file.pmm09 ",
#                   " AND pmm_file.pmm12 = gen_file.gen01 AND pmn20 > pmn50-pmn55 ",       #No.FUN-9A0068 mark
                    " AND pmm_file.pmm12 = gen_file.gen01 AND pmn20 > pmn50-pmn55-pmn58 ", #No.FUN-9A0068 
                    " AND ima_file.ima01 = pmn_file.pmn04 ",
                     " AND pmm25 = '2' ",   #No.MOD-570114
                    " AND pmn16 = '2' AND ",tm.wc
     ELSE
        LET l_sql = " SELECT '','','',",
#                   " pmn33,pmn04,pmn20,(pmn20-pmn50+pmn55),pmm09,pmc03,",       #No.FUN-940083
                    " pmn33,pmn04,pmn20,(pmn20-pmn50+pmn55+pmn58),pmm09,pmc03,", #No.FUN-940083
                    " pmn16,pmm12,gen02,pmn01,pmn02,pmn14,pmn36,pmn34,pmn06,",
                     " pmn50-pmn55,pmc10,pmm04,pmn15,pmn041, ",   #No.MOD-570114
                    " pmz03,pmz05,pmz06,pmz07,pmz08,pmz09,pmz10,pmz11,pmz12 ",#TQC-D20016 add pmz12 
                    " FROM pmm_file,pmn_file, OUTER pmc_file, OUTER gen_file,",
                    " OUTER ima_file, OUTER pmz_file ",
                    " WHERE pmm01 = pmn01 AND pmc_file.pmc01 = pmm_file.pmm09 ",
#                   " AND pmm_file.pmm12 = gen_file.gen01 AND pmn20 > pmn50-pmn55 ",#BugNo:6098  #No.FUN-9A0068 mark
                    " AND pmm_file.pmm12 = gen_file.gen01 AND pmn20 > pmn50-pmn55-pmn58 ",#BugNo:6098   #No.FUN-9A0068
                    " AND ima_file.ima01 = pmn_file.pmn04 AND pmn_file.pmn01=pmz_file.pmz01 AND pmn_file.pmn02=pmz_file.pmz02 ",
                     " AND pmm25 = '2' ",   #No.MOD-570114
                    " AND pmn16 = '2' AND ",tm.wc
     END IF
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET l_sql = l_sql clipped," AND pmmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET l_sql = l_sql clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET l_sql = l_sql clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     #End:FUN-980030
 
     PREPARE r503_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
           
     END IF
     DECLARE r503_c1 CURSOR FOR r503_p1
 
     LET l_sql = " SELECT pmd02,pmd05 FROM pmd_file ",
                 " WHERE pmd01 = ? " ,
                 " ORDER BY 2 "
     PREPARE r503_p2 FROM  l_sql
     DECLARE r503_c2 SCROLL CURSOR FOR r503_p2
 
#    CALL cl_outnam('apmr503') RETURNING l_name    #No.FUN-750098
#    START REPORT r503_rep TO l_name               #No.FUN-750098 
 
     LET g_pageno = 0
     FOREACH r503_c1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
# NO.FUN-750098---Begin
#     LET g_head1=g_x[9]  CLIPPED    #MOD-670130 add
#      FOR l_i = 1 TO 3
#         CASE WHEN tm.s[l_i,l_i] = '1' LET l_order[l_i] = sr.pmn33 USING 'YYYYMMDD'
#                                       LET g_head1=g_head1,' ',g_x[10] CLIPPED    #MOD-670130 add
#              WHEN tm.s[l_i,l_i] = '2' LET l_order[l_i] = sr.pmn34 USING 'YYYYMMDD'
#                                       LET g_head1=g_head1,' ',g_x[11] CLIPPED    #MOD-670130 add
#              WHEN tm.s[l_i,l_i] = '3' LET l_order[l_i] = sr.pmn36 USING 'YYYYMMDD'
#                                       LET g_head1=g_head1,' ',g_x[12] CLIPPED  #MOD-670130 add
#              WHEN tm.s[l_i,l_i] = '4' LET l_order[l_i] = sr.pmn04
#                                       LET g_head1=g_head1,' ',g_x[14] CLIPPED  #MOD-670130 add
#              WHEN tm.s[l_i,l_i] = '5' LET l_order[l_i] = sr.pmm09
#                                       LET g_head1=g_head1,' ',g_x[15] CLIPPED  #MOD-670130 add
#              WHEN tm.s[l_i,l_i] = '6' LET l_order[l_i] = sr.pmm12
#                                       LET g_head1=g_head1,' ',g_x[16] CLIPPED  #MOD-670130 add
#              OTHERWISE LET l_order[l_i] = '-'
#                        LET g_head1=g_head1,' ','-' CLIPPED  #MOD-670130 add
#         END CASE
#      END FOR
#      LET sr.order1 = l_order[1]
#      LET sr.order2 = l_order[2]
#      LET sr.order3 = l_order[3]
#      OUTPUT TO REPORT r503_rep(sr.*)
       IF tm.c='Y' THEN LET l_flag=1 END IF
       LET l_pmd02=' '
       LET l_pmd05=' '
       OPEN r503_c2 USING sr.pmm09
       FETCH LAST r503_c2 INTO l_pmd02,l_pmd05
       CLOSE r503_c2
 
       SELECT ima021 INTO l_ima021 FROM ima_file
        WHERE ima01=sr.pmn04
       IF tm.c='Y' THEN
          SELECT COUNT(*) INTO g_cnt FROM pmz_file
          WHERE pmz01=sr.pmn01 AND pmz02=sr.pmn02
          IF l_flag=1 AND g_cnt>0 THEN
          LET l_flag=0
          LET g_cnt1=0
          END IF
          IF g_cnt>0 THEN
          SELECT gen02 INTO l_gen02 FROM gen_file
           WHERE gen01=sr.pmz10 
             EXECUTE insert_prep USING                                                                                              
                     sr.pmn33,sr.pmn04,sr.pmn20_n,sr.pmn041,sr.pmn20,                                                               
                     sr.pmm09,l_pmd02,sr.pmm12,sr.pmn01,sr.pmn02,                                                                   
                     sr.pmn14,sr.pmn36,sr.pmn34,sr.pmn06,l_ima021,                                                                  
                     sr.pmn50,sr.pmc03,sr.pmc10,sr.gen02,l_gen02,                                                                   
                     sr.pmm04,sr.pmn15,sr.pmz03,sr.pmz05,sr.pmz06,sr.pmz07,                                                                  
                     sr.pmz08,sr.pmz09,sr.pmz10,sr.pmz11,sr.pmz12,g_cnt1,g_cnt#TQC-D20016 add pmz12
           LET g_cnt1=g_cnt1+1   
          ELSE  
              EXECUTE insert_prep USING                                                                                              
                     sr.pmn33,sr.pmn04,sr.pmn20_n,sr.pmn041,sr.pmn20,                                                               
                     sr.pmm09,l_pmd02,sr.pmm12,sr.pmn01,sr.pmn02,                                                                   
                     sr.pmn14,sr.pmn36,sr.pmn34,sr.pmn06,l_ima021,                                                                  
                     sr.pmn50,sr.pmc03,sr.pmc10,sr.gen02,l_gen02,                                                                   
                     sr.pmm04,sr.pmn15,sr.pmz03,sr.pmz05,sr.pmz06,sr.pmz07,                                                                  
                     sr.pmz08,sr.pmz09,sr.pmz10,sr.pmz11,sr.pmz12,g_cnt1,g_cnt#TQC-D20016 add pmz12
          END IF
       ELSE
           EXECUTE insert_prep USING                                                                                             
                     sr.pmn33,sr.pmn04,sr.pmn20_n,sr.pmn041,sr.pmn20,                                                               
                     sr.pmm09,l_pmd02,sr.pmm12,sr.pmn01,sr.pmn02,                                                                   
                     sr.pmn14,sr.pmn36,sr.pmn34,sr.pmn06,l_ima021,                                                                  
                     sr.pmn50,sr.pmc03,sr.pmc10,sr.gen02,l_gen02,                                                                   
                     sr.pmm04,sr.pmn15,sr.pmz03,sr.pmz05,sr.pmz06,sr.pmz07,                                                                  
                     sr.pmz08,sr.pmz09,sr.pmz10,sr.pmz11,sr.pmz12,g_cnt1,g_cnt#TQC-D20016 add pmz12
       END IF
     END FOREACH
 
#    FINISH REPORT r503_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                               
     #是否列印選擇條件                                                                                                              
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'pmn33,pmn36,pmn34,pmn04,pmm09,pmm12,pmm01') RETURNING tm.wc
        LET g_str = tm.wc                                                                                                           
     END IF
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.c
     CALL  cl_prt_cs3('apmr503','apmr503',l_sql,g_str) 
#NO.FUN-750098-------End  
END FUNCTION
 
#NO.FUN-750098-------Begin
{
REPORT r503_rep(sr)
   DEFINE l_last_sw  LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
          l_flag     LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          g_cnt1     LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          sr         RECORD
                     order1    LIKE    pmn_file.pmn04,   #No.FUN-680136 VARCHAR(40) #FUN-5B0105 20->40
                     order2    LIKE    pmn_file.pmn04,   #No.FUN-680136 VARCHAR(40) #FUN-5B0105 20->40
                     order3    LIKE    pmn_file.pmn04,   #No.FUN-680136 VARCHAR(40) #FUN-5B0105 20->40
                     pmn33     LIKE    pmn_file.pmn33,   #交貨日
                     pmn04     LIKE    pmn_file.pmn04,   #料件編號
                     pmn20     LIKE    pmn_file.pmn20,   #訂購量
                     pmn20_n   LIKE    pmn_file.pmn20,   #未交量
                     pmm09     LIKE    pmm_file.pmm09,   #廠商編號
                     pmc03     LIKE    pmc_file.pmc03,   #簡稱
                     pmn16     LIKE    pmn_file.pmn16,   #狀況
                     pmm12     LIKE    pmm_file.pmm12,   #採購員
                     gen02     LIKE    gen_file.gen02,   #採購員簡稱
                     pmn01     LIKE    pmn_file.pmn01,   #採購單號
                     pmn02     LIKE    pmn_file.pmn02,   #項次
                     pmn14     LIKE    pmn_file.pmn14,   #部份交貨
                     pmn36     LIKE    pmn_file.pmn36,   #最近確認日
                     pmn34     LIKE    pmn_file.pmn34,   #到廠日
                     pmn06     LIKE    pmn_file.pmn06,   #廠商料件編號
                     pmn50     LIKE    pmn_file.pmn50,   #收貨量
                     pmc10     LIKE    pmc_file.pmc10,   #電話
                     pmm04     LIKE    pmm_file.pmm04,   #採購日期
                     pmn15     LIKE    pmn_file.pmn15,   #提前交貨
                     pmn041    LIKE    pmn_file.pmn041,  #品名規格
                     pmz03     LIKE    pmz_file.pmz03,   #次數
                     pmz05     LIKE    pmz_file.pmz05,   #答應日期
                     pmz06     LIKE    pmz_file.pmz06,   #交期確認日期
                     pmz07     LIKE    pmz_file.pmz07,   #預計到廠日
                     pmz08     LIKE    pmz_file.pmz08,   #預計到庫日
                     pmz09     LIKE    pmz_file.pmz09,   #確認交貨數量
                     pmz10     LIKE    pmz_file.pmz10,   #確認人
                     pmz11     LIKE    pmz_file.pmz11    #備註一
                     END RECORD ,
            l_pmd02  LIKE pmd_file.pmd02,
            l_pmd05  LIKE pmd_file.pmd05,
            l_ima021 LIKE ima_file.ima021, #FUN-4C0095
            l_gen02  LIKE gen_file.gen02   #FUN-4C0095
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
      ORDER BY sr.order1,sr.order2,sr.order3,sr.pmn01,sr.pmn02,sr.pmz03
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      #MOD-670130-begin-mark
      #FOR g_i = 1 TO 3
      ##MOD-490148調整報表表頭列印出來的"排列順序"字眼
      #   CASE   
      #      WHEN tm.s[g_i,g_i]='1'  
      #           LET g_head1=g_x[9] CLIPPED,' ',g_x[10] CLIPPED 
      #      WHEN tm.s[g_i,g_i]='2'  
      #           LET g_head1=g_head1,' ',g_x[11] CLIPPED
      #      WHEN tm.s[g_i,g_i]='3'  
      #           LET g_head1=g_head1,' ',g_x[12] CLIPPED
      #      WHEN tm.s[g_i,g_i]='4'  
      #           LET g_head1=g_head1,' ',g_x[14] CLIPPED
      #      WHEN tm.s[g_i,g_i]='5'  
      #           LET g_head1=g_head1,' ',g_x[15] CLIPPED
      #      WHEN tm.s[g_i,g_i]='6'  
      #           LET g_head1=g_head1,' ',g_x[16] CLIPPED
      #   END CASE
      #END FOR
      #MOD-670130-end-mark
      PRINT g_head1
      PRINT g_dash
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[50],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
      PRINTX name=H2 g_x[41],g_x[42],g_x[43],g_x[51],g_x[44],g_x[45],
            g_x[46],g_x[47],g_x[48],g_x[49]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' THEN
         SKIP TO TOP OF PAGE
      END IF
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' THEN
         SKIP TO TOP OF PAGE
      END IF
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' THEN
         SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.pmn02
      IF tm.c='Y' THEN LET l_flag=1 END IF
      #聯絡人
      LET l_pmd02=' '
      LET l_pmd05=' '
      OPEN r503_c2 USING sr.pmm09
      FETCH LAST r503_c2 INTO l_pmd02,l_pmd05
      CLOSE r503_c2
 
     SELECT ima021 INTO l_ima021 FROM ima_file
      WHERE ima01=sr.pmn04
 
     PRINTX name=D1 COLUMN g_c[31],sr.pmn33,
           COLUMN g_c[32],sr.pmn04,
           COLUMN g_c[33],cl_numfor(sr.pmn20_n,33,2), #料號/訂購量
           COLUMN g_c[50],sr.pmn041,
           COLUMN g_c[34],cl_numfor(sr.pmn20,34,2),
           COLUMN g_c[35],sr.pmm09,    #未交量/廠商編號
           COLUMN g_c[36],l_pmd02,
           COLUMN g_c[37],sr.pmm12,    #聯絡人/採購員
           COLUMN g_c[38],sr.pmn01,
           COLUMN g_c[39],sr.pmn02 USING '####',
           COLUMN g_c[40],sr.pmn14    #採購單號/項次/部份交貨
 
    PRINTX name=D2 COLUMN g_c[41],sr.pmn36,
          COLUMN g_c[42],sr.pmn34,
          COLUMN g_c[43],sr.pmn06,   #最近確認日/原始到廠日/廠商料號
          COLUMN g_c[51],l_ima021,
          COLUMN g_c[44],cl_numfor(sr.pmn50,44,2),
          COLUMN g_c[45],sr.pmc03,    #交貨量/廠商簡稱
          COLUMN g_c[46],sr.pmc10,
          COLUMN g_c[47],sr.gen02,
          COLUMN g_c[48],sr.pmm04,
          COLUMN g_c[49],sr.pmn15    #電話 /採購員姓名/採購日期/提前交貨
 
 
 
   AFTER GROUP OF sr.pmz03
     #PRINTX name=S1 COLUMN g_c[33],sr.pmn20_n USING '#####&.&&', #料號/訂購量
     #       COLUMN g_c[34],sr.pmn20 USING '#####&.&&'
 
      IF tm.c='Y' THEN         #列印交期確認明細資料
         SELECT COUNT(*) INTO g_cnt FROM pmz_file
          WHERE pmz01=sr.pmn01 AND pmz02=sr.pmn02
         IF l_flag=1 AND g_cnt>0 THEN      #列印表頭
            PRINT COLUMN 10,g_x[17] CLIPPED,COLUMN 21,g_x[18] CLIPPED,
                  COLUMN 37,g_x[19] CLIPPED,COLUMN 51,g_x[20] CLIPPED,
                  COLUMN 65,g_x[21] CLIPPED,COLUMN 81,g_x[22] CLIPPED,
                  COLUMN 92,g_x[23] CLIPPED
            LET l_flag=0
            LET g_cnt1=0
         END IF
         #列印資料
         IF g_cnt>0 THEN
            SELECT gen02 INTO l_gen02 FROM gen_file
             WHERE gen01=sr.pmz10
            PRINT COLUMN 10,sr.pmz05,COLUMN 21,sr.pmz06,COLUMN 37,sr.pmz07,
                  COLUMN 51,sr.pmz08,COLUMN 65,sr.pmz09 USING '#########.###',COLUMN 81,sr.pmz10,
                  COLUMN 92,sr.pmz11[1,40]
            PRINT COLUMN 81,l_gen02
            LET g_cnt1=g_cnt1+1
            IF g_cnt=g_cnt1 THEN
               PRINT g_dash2
            END IF
         ELSE
            PRINT g_dash2
         END IF
      ELSE
         PRINT g_dash2
      END IF
 
   ON LAST ROW
 
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash
           #   IF tm.wc[001,120] > ' ' THEN			# for 132
 	   #     	 PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
           #   IF tm.wc[121,240] > ' ' THEN
 	   #	         PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
           #   IF tm.wc[241,300] > ' ' THEN
 	   #	 PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
		#TQC-630166
		CALL cl_prt_pos_wc(tm.wc)
      END IF
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
#NO.FUN-750098-------End 
