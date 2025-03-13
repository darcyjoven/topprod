# Prog. Version..: '5.30.07-13.05.16(00002)'     #
#
# Pattern name...: axmx430.4gl
# Descriptions...: 訂單預計交貨表
# Date & Author..: 95/01/20 By Danny
# Modify.........: No.FUN-4A0017 04/10/04 Echo 訂單單號,人員編號,帳款客戶,產品編號要開窗
# Modify.........: No.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-580004 05/08/03 By wujie 雙單位報表結構修改
# Modify.........: No.FUN-5A0143 05/10/24 By Rosayu 修改報表格式
# Modify.........: NO.FUN-5B0015 05/11/02 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.TQC-5B0128 04/11/14 By Echo 修改「依xxx交貨日」的定位點
# Modify.........: No.MOD-640027 06/04/08 By Echo 選擇單行列印時會跳頁不正常
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680137 06/09/05 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: No.TQC-6C0038 06/12/07 By Judy 報表格式調整 
# Modify.........: No.FUN-7B0026 07/11/12 By baofei 報表輸出至Crystal Reports功能 
# Modify.........: No.FUN-840166 08/05/09 By jamie 調整報表規格
# Modify.........: No.FUN-940063 09/04/10 By Vicky 修改 TempTable 命名錯誤
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B30062 11/03/07 By zhangll l_sql -> STRING
# Modify.........: No.FUN-CB0004 12/11/01 By dongsz CR轉XtraGrid
# Modify.........: No.FUN-D30070 13/03/21 By chenying 去除小計
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580004--begin
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
END GLOBALS
#No.FUN-580004--end
   DEFINE tm  RECORD                # Print condition RECORD
              wc       STRING, #CHAR(500)        # Where condition
              s       LIKE type_file.chr3,        # No.FUN-680137 VARCHAR(03),
              t       LIKE type_file.chr3,        # No.FUN-680137 VARCHAR(03),
             # Prog. Version..: '5.30.07-13.05.16(03),  #FUN-D30070
              o       LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(01),
              more    LIKE type_file.chr1         # No.FUN-680137 VARCHAR(1)    # Input more condition(Y/N)
              END RECORD,
          g_orderA        ARRAY[3] OF LIKE faj_file.faj02      # No.FUN-680137 VARCHAR(10)  #排序名稱
DEFINE    g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE    g_head1         STRING
#FUN-580004--begin
DEFINE g_sma115         LIKE sma_file.sma115
#DEFINE l_sql            LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(1000)
DEFINE l_sql            STRING #Mod No.TQC-B30062
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE i                LIKE type_file.num10        # No.FUN-680137 INTEGER
#FUN-580004--end
#No.FUN-7B0026---Begin                                                                                                              
DEFINE l_table        STRING,                                                                                                       
       g_str          STRING,                                                                                                       
       g_sql          STRING                                                                                                        
#No.FUN-7B0026---End    
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
#No.FUN-7B0026---Begin                                                                                                              
   LET g_sql = "oea01.oea_file.oea01,",                                                                                             
               "oea03.oea_file.oea03,",                                                                                             
               "oea04.oea_file.oea04,",
               "oea032.oea_file.oea032,",                                                                                           
               "oea14.oea_file.oea14,",                                                                                           
               "oea15.oea_file.oea15,",                                                                                             
               "oeb04.oeb_file.oeb04,",                                                                                             
               "oeb05.oeb_file.oeb05,",                                                                                             
               "oeb06.oeb_file.oeb06,",                                                                                             
               "oeb08.oeb_file.oeb08,",                                                                                             
               "oeb09.oeb_file.oeb09,",                                                                                         
               "oeb092.oeb_file.oeb092,",
               "oeb12.oeb_file.oeb12,",                                                                                             
               "oeb15.oeb_file.oeb15,",
               "oeb16.oeb_file.oeb16,",
               "l_str2.type_file.chr1000,",                                                                                              
               "ima021.ima_file.ima021,",                                                                                           
               "gen02.gen_file.gen02,",                                                                                             
               "gem02.gem_file.gem02,",     
               "oeb03.oeb_file.oeb03,",    #FUN-840166 add
               "imd02.imd_file.imd02"      #FUN-CB0004 add
              #"flag1.type_file.chr1,",    #FUN-CB0004 add
              #"flag2.type_file.chr1"      #FUN-CB0004 add
   #LET l_table = cl_prt_temptable('anmx430',g_sql) CLIPPED    #FUN-940063 mark
   LET l_table = cl_prt_temptable('axmx430',g_sql) CLIPPED     #FUN-940063 add                           
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?) " #FUN-840166 add 1?    #FUN-CB0004 add 1?                                                                 
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF   
#No.FUN-7B0026---End   
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s = ARG_VAL(8)
   LET tm.t = ARG_VAL(9)
  #LET tm.u = ARG_VAL(10)  #FUN-D30070
   LET tm.o = ARG_VAL(11)
#-------------No.TQC-610089 modify
  #LET tm.more = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#-------------No.TQC-610089 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axmx430_tm(0,0)             # Input print condition
      ELSE CALL axmx430()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmx430_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 3 LET p_col = 13
 
   OPEN WINDOW axmx430_w AT p_row,p_col WITH FORM "axm/42f/axmx430"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
   LET tm2.s1  = '1'
   LET tm2.s2  = '3'
   LET tm2.s3  = '6'
  #LET tm2.u1  = 'N'  #FUN-D30070
  #LET tm2.u2  = 'N'  #FUN-D30070
  #LET tm2.u3  = 'N'  #FUN-D30070
   LET tm2.t1  = 'N'
   LET tm2.t2  = 'N'
   LET tm2.t3  = 'N'
   LET tm.o    = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oeb15,oeb16,oea01,oea14,oea15,oea03,
                              oea04,oeb04,oeb09
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
         LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT CONSTRUCT
 
       #### No.FUN-4A0017
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(oea01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_oea6"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oea01
                NEXT FIELD oea01
 
              WHEN INFIELD(oea03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_occ"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oea03
                NEXT FIELD oea03
 
              WHEN INFIELD(oea04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_occ"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oea04
                NEXT FIELD oea04
 
              WHEN INFIELD(oea14)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gen"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oea14
                NEXT FIELD oea14
 
              WHEN INFIELD(oea15)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gem"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oea15
                NEXT FIELD oea15
 
              WHEN INFIELD(oeb04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oeb04
                NEXT FIELD oeb04
             #FUN-CB0004--add--str---
              WHEN INFIELD(oeb09)  
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_imd1"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oeb09
                NEXT FIELD oeb09
             #FUN-CB0004--add--end---
                
 
           END CASE
      ### END  No.FUN-4A0017
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axmx430_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                #tm2.u1,tm2.u2,tm2.u3,  #FUN-D30070
                 tm.o,tm.more
       WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD o
         IF cl_null(tm.o) OR tm.o NOT MATCHES '[12]' THEN
            NEXT FIELD o
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
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
        #LET tm.u = tm2.u1,tm2.u2,tm2.u3  #FUN-D30070
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
      LET INT_FLAG = 0 CLOSE WINDOW axmx430_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmx430'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmx430','9031',1)
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
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.s CLIPPED,"'" ,
                         " '",tm.t CLIPPED,"'" ,
                        #" '",tm.u CLIPPED,"'" ,  #FUN-D30070
                         " '",tm.o CLIPPED,"'" ,
                        #" '",tm.more CLIPPED,"'"  ,            #No.TQC-610089 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmx430',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmx430_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmx430()
   ERROR ""
END WHILE
   CLOSE WINDOW axmx430_w
END FUNCTION
 
FUNCTION axmx430()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
         #l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(1000)
          l_sql     STRING,  #Mod No.TQC-B30062
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          #l_order    ARRAY[5] OF VARCHAR(20),
          l_order    ARRAY[5] OF LIKE aaf_file.aaf02,     # No.FUN-680137 VARCHAR(40),  #NO.FUN-5B0015
          sr        RECORD
                      #order1 VARCHAR(20),
                      #order2 VARCHAR(20),
                      #order3 VARCHAR(20),
                      order1 LIKE aaf_file.aaf02,     # No.FUN-680137 VARCHAR(40),      #NO.FUN-5B0015
                      order2 LIKE aaf_file.aaf02,     # No.FUN-680137 VARCHAR(40),      #NO.FUN-5B0015
                      order3 LIKE aaf_file.aaf02,     # No.FUN-680137 VARCHAR(40),      #NO.FUN-5B0015
                      oeb15  LIKE oeb_file.oeb15,
                      oeb16  LIKE oeb_file.oeb16,
                      oea01  LIKE oea_file.oea01,
                      oea14  LIKE oea_file.oea14,
                      gen02  LIKE gen_file.gen02,
                      oea15  LIKE oea_file.oea15,
                      gem02  LIKE gem_file.gem02,
                      oea03  LIKE oea_file.oea03,
                      oea032 LIKE oea_file.oea032,
                      oea04  LIKE oea_file.oea04,
                      occ02  LIKE occ_file.occ02,
                      oeb04  LIKE oeb_file.oeb04,
                      oeb092 LIKE oeb_file.oeb092,
                      oeb06  LIKE oeb_file.oeb06,
                      oeb12  LIKE oeb_file.oeb12,
                      oeb05  LIKE oeb_file.oeb05,
                      oeb08  LIKE oeb_file.oeb08,
                      oeb09  LIKE oeb_file.oeb09,
                      oeb910  LIKE oeb_file.oeb910,   #FUN-580004
                      oeb912  LIKE oeb_file.oeb912,   #FUN-580004
                      oeb913  LIKE oeb_file.oeb913,   #FUN-580004
                      oeb915  LIKE oeb_file.oeb915,  #FUN-580004
                      oeb03   LIKE oeb_file.oeb03,    #FUN-840166 add
                      imd02   LIKE imd_file.imd02    #FUN-CB0004 add
                    END RECORD
#No.FUN-7B0026---Begin                                                                                                              
   DEFINE  l_oeb915    LIKE type_file.chr1000                                                                                       
   DEFINE  l_oeb912    LIKE type_file.chr1000                                                                                       
   DEFINE  l_str2      LIKE type_file.chr1000 
   DEFINE  l_ima021    LIKE ima_file.ima021                                                                                      
   DEFINE  l_ima906    LIKE ima_file.ima906                                                                                         
#No.FUN-7B0026---End 
   DEFINE  l_str       STRING             #FUN-CB0004 add
   DEFINE  l_str1      STRING             #FUN-CB0004 add    
   DEFINE  l_flag1     LIKE type_file.chr1    #FUN-CB0004 add
   DEFINE  l_flag2     LIKE type_file.chr1    #FUN-CB0004 add 
     CALL cl_del_data(l_table)            #No.FUN-7B0026
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05    FROM zz_file WHERE zz01 = g_prog   #No.FUN-7B0026
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
#    SELECT azi03,azi04,azi05                #No.CHI-6A0004
#      INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取 #No.CHI-6A0004
#      FROM azi_file                        #No.CHI-6A0004
#     WHERE azi01=g_aza.aza17               #No.CHI-6A0004 
  
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND oeauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
     #End:FUN-980030
 
     LET l_sql ="SELECT '','','',oeb15,oeb16,oea01,oea14,gen02,oea15,gem02,",
                "       oea03,oea032,oea04,occ02,oeb04,oeb092,oeb06,",
                "       (oeb12-oeb24+oeb25-oeb26),oeb05,oeb08,oeb09, ",
                "       oeb910,oeb912,oeb913,oeb915,oeb03,imd02 ", #FUN-860144 add oeb03  #No.FUN-580004  FUN-CB0004 add imd02
                "  FROM oea_file,oeb_file,",
                "       OUTER occ_file,OUTER gen_file,OUTER gem_file,OUTER imd_file ",    #FUN-CB0004 add OUTER imd_file
                " WHERE oea01=oeb01 ",
                "   AND oea_file.oea04=occ_file.occ01 ",
                "   AND oea_file.oea14=gen_file.gen01 ",
                "   AND oea_file.oea15=gem_file.gem01 ",
                "   AND oeb_file.oeb09=imd_file.imd01 ",      #FUN-CB0004 add
                "   AND oea00<>'0' ",    #合約不計
                "   AND oeaconf='Y' ",                        #已確認
                "   AND oeb70='N' ",
                "   AND (oeahold IS NULL OR oeahold=' ') ",   #未留置
                "   AND (oeb12-oeb24+oeb25-oeb26) > 0 ",      #未交完 BugNo:6586
                "   AND ",tm.wc CLIPPED,
                " ORDER BY oeb15,oeb16,oea01 "
 
     PREPARE axmx430_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
     END IF
     DECLARE axmx430_curs1 CURSOR FOR axmx430_prepare1
 
#     CALL cl_outnam('axmx430') RETURNING l_name      #No.FUN-7B0026
 
#FUN-580004--begin
     SELECT sma115 INTO g_sma115 FROM sma_file
#     IF g_sma115 = "Y"  THEN                  #No.FUN-7B0026 
#             LET l_name='axmx430'             #No.FUN-7B0026
#            LET g_zaa[47].zaa06 = "N"         #No.FUN-7B0026
 
#     ELSE                                     #No.FUN-7B0026 
#             LET l_name='axmx430_1'           #No.FUN-7B0026
#            LET g_zaa[47].zaa06 = "Y"         #No.FUN-7B0026
#     END IF                                   #No.FUN-7B0026 
#      CALL cl_prt_pos_len()                   #No.FUN-7B0026
#No.FUN-580004--end
#     START REPORT axmx430_rep TO l_name       #No.FUN-7B0026
 
#     LET g_pageno = 0                         #No.FUN-7B0026
     FOREACH axmx430_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
      #IF tm.o = '2' THEN LET sr.oeb15=sr.oeb16 END IF     #FUN-CB0004 mark
#No.FUN-7B0026---Begin
 
#       FOR g_i = 1 TO 3
#          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.oeb15 USING 'yyyymmdd'
#                                        LET g_orderA[g_i]= g_x[11]
#               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.oeb16 USING 'yyyymmdd'
#                                        LET g_orderA[g_i]= g_x[12]
#               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.oea01
#                                        LET g_orderA[g_i]= g_x[13]
#               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.oea14
#                                        LET g_orderA[g_i]= g_x[14]
#               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.oea15
#                                        LET g_orderA[g_i]= g_x[15]
#               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.oea032
#                                        LET g_orderA[g_i]= g_x[16]
#               WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.oea04
#                                        LET g_orderA[g_i]= g_x[17]
#               WHEN tm.s[g_i,g_i] = '8' LET l_order[g_i] = sr.oeb04
#                                        LET g_orderA[g_i]= g_x[18]
#               WHEN tm.s[g_i,g_i] = '9' LET l_order[g_i] = sr.oeb08
#                                        LET g_orderA[g_i]= g_x[19]
#               WHEN tm.s[g_i,g_i] = 'a' LET l_order[g_i] = sr.oeb09
#                                        LET g_orderA[g_i]= g_x[20]
#               OTHERWISE LET l_order[g_i] = '-'
#          END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
 
      IF sr.oeb04[1,4] !='MISC' THEN                                                                                                
         SELECT ima021 INTO l_ima021 FROM ima_file                                                                                  
          WHERE ima01 = sr.oeb04                                                                                                    
      ELSE                                                                                                                          
         LET l_ima021 = ''                                                                                                          
      END IF                                                                                                                        
      SELECT ima906 INTO l_ima906 FROM ima_file                                                                                     
                         WHERE ima01=sr.oeb04                                                                                       
      LET l_str2 = ""                                                                                                               
      IF g_sma115 = "Y" THEN                                                                                                        
         CASE l_ima906                                                                                                              
            WHEN "2"                                                                                                                
                CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915                                                                   
                LET l_str2 = l_oeb915 , sr.oeb913 CLIPPED                                                                           
                IF cl_null(sr.oeb915) OR sr.oeb915 = 0 THEN                                                                         
                    CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912                                                               
                    LET l_str2 = l_oeb912, sr.oeb910 CLIPPED                                                                        
                ELSE                                                                                                                
                   IF NOT cl_null(sr.oeb912) AND sr.oeb912 > 0 THEN                                                                 
                      CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912                                                             
                      LET l_str2 = l_str2 CLIPPED,',',l_oeb912, sr.oeb910 CLIPPED                                                   
                   END IF                                                                                                           
                END IF 
            WHEN "3"                                                                                                                
                IF NOT cl_null(sr.oeb915) AND sr.oeb915 > 0 THEN                                                                    
                    CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915                                                               
                    LET l_str2 = l_oeb915 , sr.oeb913 CLIPPED                                                                       
                END IF                                                                                                              
         END CASE                                                                                                                   
      ELSE                                                                                                                          
      END IF                    
     #IF tm.o = '1' THEN LET l_flag1 = 'Y' LET l_flag2 = 'N'               #FUN-CB0004 add
     #ELSE LET l_flag1 = 'N' LET l_flag2 = 'Y' END IF                      #FUN-CB0004 add
#       OUTPUT TO REPORT axmx430_rep(sr.*)
      EXECUTE insert_prep USING sr.oea01,sr.oea03,sr.oea04,sr.oea032,sr.oea14,sr.oea15,sr.oeb04,
                                sr.oeb05,sr.oeb06,sr.oeb08,sr.oeb09,sr.oeb092,
                                sr.oeb12,sr.oeb15,sr.oeb16,l_str2,l_ima021,
                                sr.gen02,sr.gem02,sr.oeb03,sr.imd02 #FUN-840166 add sr.oeb03 #FUN-CB0004 add sr.imd02
 
#No.FUN-7B0026---End
     END FOREACH
#No.FUN-7B0026---Begin 
#     FINISH REPORT axmx430_rep
    IF tm.o = '1' THEN LET g_xgrid.template = 'axmx430'    #FUN-CB0004 add
    ELSE LET g_xgrid.template = 'axmx430_1' END IF         #FUN-CB0004 add
    LET g_xgrid.table = l_table      #FUN-CB0004 add
   IF g_zz05 = 'Y' THEN         
         CALL cl_wcchp(tm.wc,'oeb15,oeb16,oea01,oea14,oea15,oea03,oea04,oeb04,oeb09')       
              RETURNING tm.wc                                                                                                       
      END IF                  
###XtraGrid###      LET g_str=tm.wc ,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t[1,1],";",                                                 
###XtraGrid###                           tm.t[2,2],";",tm.t[3,3],";",tm.u[1,1],";",tm.u[2,2],";",                                                 
###XtraGrid###                           tm.u[3,3],";",tm.o                                                            
###XtraGrid###      LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                                               
###XtraGrid###   CALL cl_prt_cs3('axmx430','axmx430',l_sql,g_str)    
   #LET g_xgrid.table = 'l_table'    ###XtraGrid###    #FUN-CB0004 mark
   #FUN-CB0004 add str---
    LET g_xgrid.order_field = cl_get_order_field(tm.s,"oeb15,oeb16,oea01,oea14,oea15,oea03,oea04,oeb04,oeb08,oeb09")
    LET g_xgrid.grup_field = cl_get_order_field(tm.s,"oeb15,oeb16,oea01,oea14,oea15,oea03,oea04,oeb04,oeb08,oeb09")
   #LET g_xgrid.grup_sum_field = cl_get_sum_field(tm.s,tm.u,"oeb15,oeb16,oea01,oea14,oea15,oea03,oea04,oeb04,oeb08,oeb09")  #FUN-D30070
    LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"oeb15,oeb16,oea01,oea14,oea15,oea03,oea04,oeb04,oeb08,oeb09")
   #FUN-D30070--mark--str--
   #LET l_str = cl_wcchp(g_xgrid.order_field,"oeb15,oeb16,oea01,oea14,oea15,oea03,oea04,oeb04,oeb08,oeb09")
   #LET l_str = cl_replace_str(l_str,',','-')
   #IF tm.o = '1'  THEN
   #    LET l_str1 = cl_getmsg('oeb-001',g_lang)
   #ELSE LET l_str1 = cl_getmsg('oeb-002',g_lang)
   #END IF
   #LET g_xgrid.footerinfo1 = cl_getmsg("lib-626",g_lang),l_str,"|",l_str1
   #FUN-D30070--mark--str--
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
   #FUN-CB0004 add end---
    CALL cl_xg_view()    ###XtraGrid###     #FUN-CB0004 add ()
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-7B0026---End 
END FUNCTION
#No.FUN-7B0026---Begin
  
#REPORT axmx430_rep(sr)
#   DEFINE l_last_sw   LIKE type_file.chr1,        # No.FUN-680137  VARCHAR(1)
#          sr        RECORD
#                      #order1 VARCHAR(20),
#                      #order2 VARCHAR(20),
#                      #order3 VARCHAR(20),
#                      order1 LIKE aaf_file.aaf02,     # No.FUN-680137 VARCHAR(40),      #NO.FUN-5B0015
#                     order2 LIKE aaf_file.aaf02,     # No.FUN-680137 VARCHAR(40),      #NO.FUN-5B0015
#                     order3 LIKE aaf_file.aaf02,     # No.FUN-680137 VARCHAR(40),      #NO.FUN-5B0015
#                     oeb15  LIKE oeb_file.oeb15,
#                     oeb16  LIKE oeb_file.oeb16,
#                     oea01  LIKE oea_file.oea01,
#                     oea14  LIKE oea_file.oea14,
#                     gen02  LIKE gen_file.gen02,
#                     oea15  LIKE oea_file.oea15,
#                     gem02  LIKE gem_file.gem02,
#                     oea03  LIKE oea_file.oea03,
#                     oea032 LIKE oea_file.oea032,
#                     oea04  LIKE oea_file.oea04,
#                     occ02  LIKE occ_file.occ02,
#                     oeb04  LIKE oeb_file.oeb04,
#                     oeb092 LIKE oeb_file.oeb092,
#                     oeb06  LIKE oeb_file.oeb06,
#                     oeb12  LIKE oeb_file.oeb12,
#                     oeb05  LIKE oeb_file.oeb05,
#                     oeb08  LIKE oeb_file.oeb08,
#                     oeb09  LIKE oeb_file.oeb09,
#                     oeb910  LIKE oeb_file.oeb910,   #FUN-580004
#                     oeb912  LIKE oeb_file.oeb912,   #FUN-580004
#                     oeb913  LIKE oeb_file.oeb913,   #FUN-580004
#                     oeb915  LIKE oeb_file.oeb915    #FUN-580004
#                   END RECORD,
#        l_ima021       LIKE ima_file.ima021,  #FUN-4C0096 add
#        l_str          LIKE aaf_file.aaf02,     # No.FUN-680137 VARCHAR(40)              #FUN-4C0096 add
#        l_str3         LIKE aaf_file.aaf02,     # No.FUN-680137 VARCHAR(40)              #FUN-4C0096 add
#        l_flag         LIKE type_file.num5      # No.FUN-680137 SMALLINT
#No.FUN-580004--begin
#  DEFINE  l_oeb915    STRING
#  DEFINE  l_oeb912    STRING
#  DEFINE  l_str2      STRING
#  DEFINE  l_ima906    LIKE ima_file.ima906
#No.FUN-580004--end
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin         
#        PAGE LENGTH g_page_line
# ORDER BY sr.order1,sr.order2,sr.order3,sr.oeb15
 
#FUN-4C0096 modify
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
##      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED    #No.TQC-6A0091  #TQC-6C0038
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<','/pageno'
#     PRINT g_head CLIPPED, pageno_total
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED     #TQC-6C0038
#     IF tm.o ='2' THEN LET g_x[11]=g_x[12] END IF
#     LET g_head1 = g_x[10] CLIPPED,
#                   g_orderA[1] CLIPPED,'-',
#                   g_orderA[2] CLIPPED,'-',
#                   g_orderA[3] CLIPPED
#     LET l_str3= g_x[21] CLIPPED,g_x[11] CLIPPED
#     PRINT g_head1 CLIPPED,
#           #COLUMN g_c[35],l_str3 CLIPPED
#           COLUMN 60,l_str3 CLIPPED       #TQC-5B0128
#
#     PRINT g_dash[1,g_len]
      #FUN-5A0143 mark
##      PRINT g_x[31],
##            g_x[32],
##            g_x[33],
##            g_x[34],
##            g_x[35],
##            g_x[36],
##            g_x[37],
##            g_x[38],
##            g_x[39],
##            g_x[40],
##            g_x[41],
##            g_x[42],
##            g_x[43],
##            g_x[44],
##            g_x[45],
##            g_x[46],
##            g_x[47]  #No.FUN-580004
#      #FUN-5A0143 add
#      PRINTX name = H1 g_x[39],g_x[47]
#      PRINTX name = H2 g_x[40]
#      PRINTX name = H3 g_x[41]
#      PRINTX name = H4 g_x[31],g_x[33],g_x[48],g_x[34],g_x[49],g_x[35],g_x[36],g_x[37],g_x[38]
#      PRINTX name = H5 g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[32]
#      #FUN-5A0143 end
#      PRINT g_dash1
#      LET l_last_sw = 'n'
 
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
#   BEFORE GROUP OF sr.order3
#      IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
#   ON EVERY ROW
#      IF sr.oeb04[1,4] !='MISC' THEN
#         SELECT ima021 INTO l_ima021 FROM ima_file
#          WHERE ima01 = sr.oeb04
#      ELSE
#         LET l_ima021 = ''
#      END IF
 
##FUN-580004--begin
#
#      SELECT ima906 INTO l_ima906 FROM ima_file
#                         WHERE ima01=sr.oeb04
#      LET l_str2 = ""
#      IF g_sma115 = "Y" THEN
#         CASE l_ima906
#            WHEN "2"
#                CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
#                LET l_str2 = l_oeb915 , sr.oeb913 CLIPPED
#                IF cl_null(sr.oeb915) OR sr.oeb915 = 0 THEN
#                    CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
#                    LET l_str2 = l_oeb912, sr.oeb910 CLIPPED
#                ELSE
#                   IF NOT cl_null(sr.oeb912) AND sr.oeb912 > 0 THEN
#                      CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
#                      LET l_str2 = l_str2 CLIPPED,',',l_oeb912, sr.oeb910 CLIPPED
#                   END IF
#                END IF
#            WHEN "3"
#                IF NOT cl_null(sr.oeb915) AND sr.oeb915 > 0 THEN
#                    CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
#                    LET l_str2 = l_oeb915 , sr.oeb913 CLIPPED
#                END IF
#         END CASE
#      ELSE
#      END IF
##FUN-580004--end
#      #FUN-5A0143 mark
##      PRINT COLUMN g_c[31],sr.oeb15,
##            COLUMN g_c[32],sr.oea01,
##            COLUMN g_c[33],sr.oea14,
##            COLUMN g_c[34],sr.gen02,
##            COLUMN g_c[35],sr.oea15,
##            COLUMN g_c[36],sr.gem02[1,10] CLIPPED,   #No.TQC-6A0091
##            COLUMN g_c[37],sr.oea03,
##            COLUMN g_c[38],sr.oea032[1,16] CLIPPED,   #No.TQC-6A0091
##            #COLUMN g_c[39],sr.oeb04[1,20] CLIPPED,   #No.FUN-580004
##            COLUMN g_c[39],sr.oeb04 CLIPPED,   #No.FUN-580004  #NO.FUN-5B0015
##            COLUMN g_c[40],sr.oeb06 CLIPPED,
##            COLUMN g_c[41],l_ima021 CLIPPED,
##            COLUMN g_c[42],sr.oeb092 CLIPPED,
##            COLUMN g_c[43],sr.oeb12 USING '###########&.&&',
##            COLUMN g_c[47],l_str2 CLIPPED,           #No.FUN-580004
##            COLUMN g_c[44],sr.oeb05,
##            COLUMN g_c[45],sr.oeb08,
##            COLUMN g_c[46],sr.oeb09
#      #FUN-5A0143 add
#      PRINTX name = D1 COLUMN g_c[39],sr.oeb04 CLIPPED,
#                       COLUMN g_c[47],l_str2 CLIPPED
#      PRINTX name = D2 COLUMN g_c[40],sr.oeb06 CLIPPED
#      PRINTX name = D3 COLUMN g_c[41],l_ima021 CLIPPED
#      PRINTX name = D4 COLUMN g_c[31],sr.oeb15 CLIPPED,
#                       COLUMN g_c[33],sr.oea14 CLIPPED,
#                       COLUMN g_c[48],'',
#                      COLUMN g_c[34],sr.gen02 CLIPPED,
#                      COLUMN g_c[35],sr.oea15 CLIPPED,
#                       COLUMN g_c[49],'',
#                       COLUMN g_c[36],sr.gem02[1,10] CLIPPED,   #No.TQC-6A0091
#                       COLUMN g_c[37],sr.oea03 CLIPPED,
#                       COLUMN g_c[38],sr.oea032[1,16] CLIPPED   #No.TQC-6A0091
#      PRINTX name = D5 COLUMN g_c[42],sr.oeb092 CLIPPED,
#                       COLUMN g_c[43],sr.oeb12 USING '###########&.&&',
#                       COLUMN g_c[44],sr.oeb05 CLIPPED,
#                       COLUMN g_c[45],sr.oeb08 CLIPPED,
#                       COLUMN g_c[46],sr.oeb09 CLIPPED,
#                       COLUMN g_c[32],sr.oea01 CLIPPED
#      #FUN-5A0143 end
 
#   AFTER GROUP OF sr.order1
#      IF tm.u[1,1] = 'Y' THEN
#         PRINT g_dash2    #TQC-6C0038
#         PRINTX name=S5 COLUMN g_c[42],g_x[22] CLIPPED,    #TQC-6C0038   
#         PRINT COLUMN g_c[42],g_x[22] CLIPPED,   
#               COLUMN g_c[43],GROUP SUM(sr.oeb12) USING '###########&.&&'
#         PRINT ' '        #TQC-6C0038
#      END IF
 
#   AFTER GROUP OF sr.order2
#      IF tm.u[2,2] = 'Y' THEN
#         PRINT g_dash2    #TQC-6C0038
#         PRINTX name=S5 COLUMN g_c[42],g_x[22] CLIPPED,    #TQC-6C0038
##         PRINT COLUMN g_c[42],g_x[22] CLIPPED,   
#               COLUMN g_c[43],GROUP SUM(sr.oeb12) USING '###########&.&&'
#         PRINT ' '         #TQC-6C0038
#      END IF
#
#   AFTER GROUP OF sr.order3
#      IF tm.u[3,3] = 'Y' THEN
#         PRINT g_dash2     #TQC-6C0038
#         PRINTX name=S5 COLUMN g_c[42],g_x[22] CLIPPED,    #TQC-6C0038
##         PRINT COLUMN g_c[42],g_x[22] CLIPPED,   
#               COLUMN g_c[43],GROUP SUM(sr.oeb12) USING '###########&.&&'
#         PRINT ' '         #TQC-6C0038
#      END IF
 
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'cti01,ima06')
#              RETURNING tm.wc
#         PRINT g_dash[1,g_len]
#       #TQC-630166
#       #      IF tm.wc[001,120] > ' ' THEN            # for 132
#       #  PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#       #      IF tm.wc[121,240] > ' ' THEN
#       #  PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#       #      IF tm.wc[241,300] > ' ' THEN
#       #  PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#       CALL cl_prt_pos_wc(tm.wc)
#       #END TQC-630166
 
#      END IF
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED  #No.FUN-580004
 
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED  #No.FUN-580004
#         ELSE SKIP 2 LINE
#      END IF
##
#END REPORT
 
#No.FUN-7B0026---End 


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
