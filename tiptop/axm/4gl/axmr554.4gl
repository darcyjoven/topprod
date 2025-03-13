# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmr554.4gl
# Descriptions...: 包裝單列印
# Date & Author..: 06/04/14 by Sarah
# Modify.........: NO.FUN-640172 06/04/14 By Sarah 新增"包裝單列印"
# Modify.........: NO.FUN-640177 06/04/20 By Sarah 若字軌輸入"X",則PACKING LIST印出來後不要把字軌印出
# Modify.........: NO.FUN-640251 06/04/25 BY yiting 針對 oaz67 的設定來改變 欄位說明
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680137 06/09/05 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.TQC-690078 06/09/19 By kim 排序錯誤
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/11/06 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0041 06/12/11 By Ray 報表寬度不符，匯出excel沒分欄
# Modify.........: No.CHI-6A0031 07/03/29 By pengu Invoice No,Ref No,Bill To,Ship To等欄位資料錯誤
# Modify.........: No.MOD-730146 07/04/12 By claire 增加選項,列印公司對內(外)公司全名
# Modify.........: No.MOD-760122 07/06/27 By claire 若選擇carton列印抬頭仍為plt
# Modify.........: No.FUN-740066 08/01/09 By jamie 報表改寫由Crystal Report產出
# Modify.........: No.FUN-810029 08/02/25 By Sarah 對外的憑證，皆需在頁首公司名稱下，增加顯示"公司地址zo041、公司電話zo05、公司傳真zo09"
# Modify.........: No.MOD-840386 08/04/28 By douzh 增加品名規格和額外品名規格打印邏輯
# Modify.........: No.FUN-840230 08/04/30 By douzh 調整列印多行額外品名規格邏輯
# Modify.........: No.FUN-860002 08/06/19 By xiaofeizhu 重新過單
# Modify.........: No.FUN-890099 08/09/25 By Smapmin 修正FUN-840230
# Modify.........: No.MOD-950144 09/05/14 By Smapmin 未依畫面輸入的排序順序呈現
# Modify.........: No.MOD-950259 09/05/25 By Smapmin 出貨地址要依出貨/出通單上的資料為主
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0071 10/01/11 By huangrh 精簡程式
# Modify.........: No:CHI-A50034 10/06/03 By Summer 畫面已增加"列印品名規格額外說明類別",就不再固定抓取imc04
# Modify.........: No:MOD-A70022 10/07/05 By Smapmin 排序條件增加ogd03/ogd04
# Modify.........: No:TQC-B50073 11/05/16 By lixia 開窗全選報錯修改
# Modify.........: No:FUN-B40087 11/06/02 By yangtt \t特殊字段影響CR轉gr的過程中出錯
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改
# Modify.........: No.TQC-C10039 12/01/18 By wangrr 整合單據列印EF簽核 
# Modify.........: No.TQC-C20051 12/02/09 By qirl markTQC-C10039
# Modify.........: No:MOD-C50175 12/05/24 By Vampire 包裝單列印時起迄箱號改抓包裝單最小最大值

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm           RECORD                         # Print condition RECORD
                     #wc     LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(500)         # Where condition
                     wc     STRING,                     #TQC-B50073
                     imc02   LIKE imc_file.imc02,       # 品名規格額外說明類別   #MOD-840386
                     s      LIKE type_file.chr1,        # Prog. Version..: '5.30.06-13.03.12(01) #列印順序
                     a      LIKE type_file.chr1,        # 列印公司對內全名       #MOD-730146  
                     b      LIKE type_file.chr1,        # 列印公司對外全名       #MOD-730146 
                     more   LIKE type_file.chr1         # Prog. Version..: '5.30.06-13.03.12(01)              # Input more condition(Y/N)
                    END RECORD,
       l_oga01      LIKE oga_file.oga01,
       l_oga02      LIKE oga_file.oga02,
       l_oao06      LIKE oao_file.oao06,
       x            LIKE aba_file.aba00,      # No.FUN-680137 VARCHAR(5)
       y,z          LIKE type_file.chr1,      # No.FUN-680137 VARCHAR(1)
       tot_ctn	    LIKE type_file.num10,     # No.FUN-680137 INTEGER
       wk_i         LIKE type_file.num5,      # No.FUN-680137 SMALLINT
       wk_array     DYNAMIC ARRAY OF RECORD
                     ogd11      LIKE ogd_file.ogd11,
                     ogd12b     LIKE ogd_file.ogd12b,
                     ogd12e     LIKE ogd_file.ogd12e
          	    END        RECORD,
       g_po_no,g_ctn_no1,g_ctn_no2  LIKE type_file.chr20,       # No.FUN-680137 VARCHAR(20)
       g_azi02	    LIKE type_file.chr20,      # No.FUN-680137 VARCHAR(20)
       g_zo12	    LIKE type_file.chr1000,    # No.FUN-680137 VARCHAR(60)
       g_zo041      LIKE zo_file.zo041,        #FUN-810029 add
       g_zo05       LIKE zo_file.zo05,         #FUN-810029 add
       g_zo09       LIKE zo_file.zo09          #FUN-810029 add
DEFINE g_cnt        LIKE type_file.num10       #No.FUN-680137 INTEGER
DEFINE g_i          LIKE type_file.num5        #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE i            LIKE type_file.num5        #No.FUN-680137 SMALLINT
DEFINE j            LIKE type_file.num5        #No.FUN-680137 SMALLINT
DEFINE ofa          RECORD LIKE ofa_file.*     #MOD-760122 add
 
DEFINE l_table      STRING
DEFINE l_table1     STRING
DEFINE l_table2     STRING                     #No.FUN-84230
DEFINE g_sql        STRING
DEFINE g_str        STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.imc02 = ARG_VAL(8) #MOD-840386
   LET tm.s    = ARG_VAL(9)
   LET tm.a    = ARG_VAL(10)   #MOD-730146
   LET tm.b    = ARG_VAL(11)  #MOD-730146
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql ="oga27.oga_file.oga27,oga01.oga_file.oga01,",
              "oga02.oga_file.oga02,oga03.oga_file.oga03,",
              "occ18_03.occ_file.occ18,occ19_03.occ_file.occ19,",
              "occ231.occ_file.occ231,occ232.occ_file.occ232,",
              "ocf101.ocf_file.ocf101,ocf102.ocf_file.ocf102,",
              "ocf103.ocf_file.ocf103,ocf104.ocf_file.ocf104,",
              "ocf105.ocf_file.ocf105,ocf106.ocf_file.ocf106,",
              "ocf107.ocf_file.ocf107,ocf108.ocf_file.ocf108,",
              "ocf109.ocf_file.ocf109,ocf110.ocf_file.ocf110,",
              "ocf111.ocf_file.ocf112,ocf112.ocf_file.ocf112,",
              "ocf201.ocf_file.ocf201,ocf202.ocf_file.ocf202,",
              "ocf203.ocf_file.ocf203,ocf204.ocf_file.ocf204,",
              "ocf205.ocf_file.ocf205,ocf206.ocf_file.ocf206,",
              "ocf207.ocf_file.ocf207,ocf208.ocf_file.ocf208,",
              "ocf209.ocf_file.ocf209,ocf210.ocf_file.ocf210,",
              "ocf211.ocf_file.ocf212,ocf212.ocf_file.ocf212,",
              "occ18_04.occ_file.occ18,occ19_04.occ_file.occ19,",
              "occ241.occ_file.occ241,occ242.occ_file.occ242,",
              "occ243.occ_file.occ243,oga49.oga_file.oga49,",
              "oga43.oga_file.oga43,oga47.oga_file.oga47,",
              "oga48.oga_file.oga48,oac02.oac_file.oac02,",
              "oac02_2.oac_file.oac02,imc04.imc_file.imc04,",    #FUN-840230    #FUN-890099取消原本的mark         
              "ogd03.ogd_file.ogd03,ogd04.ogd_file.ogd04,",   #MOD-A70022  
              "ogd11.ogd_file.ogd11,ogd12b.ogd_file.ogd12b,",
              "ogd12e.ogd_file.ogd12e,ogd10.ogd_file.ogd10,",
              "ogb04.ogb_file.ogb04,ogb06.ogb_file.ogb06,",
              "ogb05.ogb_file.ogb05,ogd09.ogd_file.ogd09,",
              "ogd14.ogd_file.ogd14,ogd15.ogd_file.ogd15,",
              "ogd16.ogd_file.ogd16,ogd13.ogd_file.ogd13,",
              "ogd14t.ogd_file.ogd14t,ogd15t.ogd_file.ogd15t,",
              "ogd16t.ogd_file.ogd16t,zo12.zo_file.zo12,",
              "ofa75.ofa_file.ofa75,ogb03.ogb_file.ogb03,",
              "zo041.zo_file.zo041,zo05.zo_file.zo05,zo09.zo_file.zo09"   #FUN-810029 add
             #"sign_type.type_file.chr1,sign_img.type_file.blob,",   #TQC-C10039 簽核方式,簽核圖檔#No.TQC-C20051 MARK TQC-C10039
             #"sign_show.type_file.chr1,sign_str.type_file.chr1000"  #TQC-C10039 是否顯示簽核資料(Y/N),sign_str#No.TQC-C20051 MARK TQC-C10039
   LET l_table = cl_prt_temptable('axmr554',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   #備註
   LET g_sql = 
       "oao01.oao_file.oao01,",
       "oao03.oao_file.oao03,",
       "oao04.oao_file.oao04,",
       "oao05.oao_file.oao05,",
       "oao06.oao_file.oao06"
   LET l_table1 = cl_prt_temptable('axmr5541',g_sql) CLIPPED   # 產生Temp Table
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                   # Temp Table產生
 
   #額外品名規格
   LET g_sql = 
       "oga01.oga_file.oga01,",    #FUN-890099
       "imc01.imc_file.imc01,",
       "imc04.imc_file.imc04," 
   LET l_table2 = cl_prt_temptable('axmr5542',g_sql) CLIPPED   # 產生Temp Table
   IF l_table2 = -1 THEN EXIT PROGRAM END IF                   # Temp Table產生
 
   LET g_zo12 = NULL
   LET g_zo041 = NULL  LET g_zo05 = NULL  LET g_zo09 = NULL   #FUN-810029 add
   SELECT zo12,zo041,zo05,zo09 INTO g_zo12,g_zo041,g_zo05,g_zo09    #FUN-810029 add zo041,zo05,zo09
     FROM zo_file WHERE zo01='1'
   IF cl_null(g_zo12) THEN
      SELECT zo12 INTO g_zo12 FROM zo_file WHERE zo01='0'
   END IF
   IF cl_null(g_zo041) THEN
      SELECT zo041 INTO g_zo041 FROM zo_file WHERE zo01='0'
   END IF
   IF cl_null(g_zo05) THEN
      SELECT zo05 INTO g_zo05 FROM zo_file WHERE zo01='0'
   END IF
   IF cl_null(g_zo09) THEN
      SELECT zo09 INTO g_zo09 FROM zo_file WHERE zo01='0'
   END IF
 
   IF cl_null(tm.wc) THEN
      CALL axmr554_tm(0,0)             # Input print condition
   ELSE 
      CALL axmr554()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION t500_show0()
   DEFINE   ls_msg  LIKE type_file.chr1000     # No.FUN-680137 VARCHAR(50)
 
   IF g_lang='1' THEN RETURN END IF
   CASE g_oaz.oaz67
      WHEN '1'
         SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'axm-705' AND ze02 = g_lang
         CALL cl_set_comp_att_text("oga01",ls_msg CLIPPED || "," || ls_msg CLIPPED)
      WHEN '2'
         SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'axr-501' AND ze02 = g_lang
         CALL cl_set_comp_att_text("oga01",ls_msg CLIPPED || "," || ls_msg CLIPPED)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
   END CASE
END FUNCTION
 
FUNCTION axmr554_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680137 SMALLINT
       l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 8 LET p_col = 17
 
   OPEN WINDOW axmr554_w AT p_row,p_col WITH FORM "axm/42f/axmr554"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   LET tm.s ='1'
   LET tm.a ='Y'   #MOD-730146 add
   LET tm.b ='Y'   #MOD-730146 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   CALL cl_opmsg('p')
   CALL t500_show0()       #NO.FUN-640251
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON oga01,oga02
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT CONSTRUCT
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(oga01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_oga"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oga01
                    NEXT FIELD oga01
            END CASE
 
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
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW axmr554_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
            
      END IF
 
      IF tm.wc=" 1=1" THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.imc02,tm.s,tm.a,tm.b,tm.more WITHOUT DEFAULTS      #MOD-840386
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
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
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW axmr554_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
            
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
                WHERE zz01='axmr554'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('axmr554','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'" ,
                            " '",tm.imc02 CLIPPED,"'" ,            #MOD-840386 add
                            " '",tm.s CLIPPED,"'" ,
                            " '",tm.a CLIPPED,"'" ,                #MOD-730146 add
                            " '",tm.b CLIPPED,"'" ,                #MOD-730146 add
                            " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                            " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                            " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('axmr554',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW axmr554_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL axmr554()
      ERROR ""
   END WHILE
   CLOSE WINDOW axmr554_w
END FUNCTION
 
FUNCTION axmr554()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
          l_sql     STRING,
          l_za05    LIKE type_file.chr1000,        #No.FUN-680137 VARCHAR(40)
          oga       RECORD LIKE oga_file.*,
          ogb       RECORD LIKE ogb_file.*,
          ogd       RECORD LIKE ogd_file.*,
          ocf       RECORD LIKE ocf_file.*,
          sr        RECORD
                    oea10	LIKE oea_file.oea10,
                    oah02	LIKE oah_file.oah02,
                    oag02	LIKE oag_file.oag02,
                    oac02	LIKE oac_file.oac02,
                    oac02_2	LIKE oac_file.oac02, 
                    order2 LIKE ogb_file.ogb04 #TQC-690078 
                    END RECORD
   DEFINE l_occ     RECORD LIKE occ_file.*      #FUN-740066 add
   DEFINE l_imc04   LIKE occ_file.occ02         #FUN-740066 add
   DEFINE l_occ18   LIKE occ_file.occ18         #FUN-740066 add
   DEFINE l_occ19   LIKE occ_file.occ19         #FUN-740066 add
   DEFINE l_cnt     LIKE type_file.num5         #FUN-740066 add
   DEFINE oao       RECORD LIKE oao_file.*      #FUN-740066 add
   DEFINE t_imc04   LIKE imc_file.imc04        
   DEFINE l_oap041 LIKE oap_file.oap041   #MOD-950259
   DEFINE l_oap042 LIKE oap_file.oap042   #MOD-950259
   DEFINE l_oap043 LIKE oap_file.oap043   #MOD-950259
   DEFINE l_oap044 LIKE oap_file.oap044   #MOD-950259
   DEFINE l_oap045 LIKE oap_file.oap045   #MOD-950259
#TQC-C20051-----MARK---STAR-----
#TQC-C10039--add--start---
#   DEFINE l_img_blob     LIKE type_file.blob
#   LOCATE l_img_blob IN MEMORY               
#TQC-C10039--add--end---
#TQC-C20051-----MARK---END----
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
    CALL cl_del_data(l_table1)
    CALL cl_del_data(l_table2)
   #------------------------------ CR (2) ------------------------------#
 
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,             
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                "        ?,?,?,?,?, ?, ?)"  #No.FUN-840230    #FUN-890099取消原先mark   #MOD-A70022 #TQC-C10039 add 4?  #No.TQC-C20051 MARK TQC-C10039
    PREPARE insert_prep FROM g_sql                                              
    IF STATUS THEN                                                               
       CALL cl_err("insert_prep:",STATUS,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
       EXIT PROGRAM                        
    END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,             
               " VALUES(?,?,?,?,?)"
   PREPARE insert_prep1 FROM g_sql                                              
   IF STATUS THEN                                                               
      CALL cl_err("insert_prep1:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM                        
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,             
               " VALUES(?,?,?)"
   PREPARE insert_prep2 FROM g_sql                                              
   IF STATUS THEN                                                               
      CALL cl_err("insert_prep2:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM                        
   END IF
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #FUN-740066 add
 
     CALL g_zaa_dyn.clear()           #MOD-760122
 
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
 
     LET l_sql="SELECT oga_file.*,ogb_file.*,ogd_file.*,ofa_file.*,",      #MOD-760122 modify 
               "       ocf_file.*,oea10,oah02,oag02,a.oac02,b.oac02,'' ",
               "  FROM oga_file,ogb_file,OUTER ogd_file, ",
               "       OUTER ocf_file,   OUTER oea_file,",
               "       OUTER oah_file,   OUTER oag_file,",
               "       OUTER ofa_file,",         #MOD-760122 add
               "       OUTER oac_file a, OUTER oac_file b ",
               " WHERE oga01=ogb01 ",
               "   AND ogb_file.ogb01=ogd_file.ogd01 AND ogb_file.ogb03=ogd_file.ogd03",
               "   AND ",tm.wc CLIPPED,
               "   AND ogaconf !='X' ", #01/08/06 mandy 不可為作廢的資料
               "   AND oga_file.oga04=ocf_file.ocf01 AND oga_file.oga44=ocf_file.ocf02",
               "   AND oga_file.oga27=ofa_file.ofa01 ",   #MOD-760122 add
               "   AND ogb_file.ogb31=oea_file.oea01 AND oga_file.oga31=oah_file.oah01 AND oga_file.oga32=oag_file.oag01",
               "   AND oga_file.oga41=a.oac01 AND oga_file.oga42=b.oac01 "
     IF tm.s = '1' THEN
        LET l_sql = l_sql , " ORDER BY oga01,ogb04"
     ELSE
        LET l_sql = l_sql , " ORDER BY oga01,ogd12b"
     END IF
     PREPARE axmr554_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
     END IF
     DECLARE axmr554_curs1 CURSOR FOR axmr554_prepare1
 
     LET g_pageno = 0
     FOREACH axmr554_curs1 INTO oga.*, ogb.*, ogd.*, ofa.*, ocf.*, sr.*   #MOD-760122 modify
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF tm.s = '1' THEN
           LET sr.order2=ogb.ogb04
        ELSE
           LET sr.order2=ogd.ogd12b           
        END IF
 
       #Bill To：
        INITIALIZE  l_occ.*  TO NULL
        SELECT * INTO l_occ.* FROM occ_file WHERE occ01 = oga.oga03
 
       #Ship To：
        SELECT occ18,occ19 INTO l_occ18,l_occ19 FROM occ_file WHERE occ01 = oga.oga04
       #抓取出貨地址
       LET l_oap041 = ''
       LET l_oap042 = ''
       LET l_oap043 = ''
       LET l_oap044 = ''
       LET l_oap045 = ''
       CASE
          WHEN oga.oga044 = 'MISC'
               CALL s_addr(oga.oga01,oga.oga04,oga.oga044)
                    RETURNING l_oap041,
                              l_oap042,
                              l_oap043,
                              l_oap044,
                              l_oap045
          WHEN cl_null(oga.oga044)
               LET l_oap041 = l_occ.occ241
               LET l_oap042 = l_occ.occ242
               LET l_oap043 = l_occ.occ243
               LET l_oap044 = l_occ.occ244
               LET l_oap045 = l_occ.occ245
          OTHERWISE
               SELECT ocd221,ocd222,ocd223,ocd230,ocd231
                 INTO l_oap041,l_oap042,l_oap043,
                      l_oap044,l_oap045
               FROM ocd_file
                WHERE ocd01=oga.oga04 AND ocd02=oga.oga044
       END CASE
 
       #品名規格額外說明
        LET l_imc04 = NULL
      #CHI-A50034 mark --start--
      # SELECT imc04 INTO l_imc04 FROM imc_file
      #  WHERE imc01=ogb.ogb04 AND imc02='1' AND imc03='1'
      #CHI-A50034 mark --end--
      IF NOT cl_null(tm.imc02) THEN                            #MOD-840388 
         DECLARE imc_c CURSOR FOR
            SELECT imc04   #FUN-890099
              FROM imc_file 
             WHERE imc01=ogb.ogb04 AND imc02=tm.imc02
         FOREACH imc_c INTO t_imc04   #FUN-890099
            EXECUTE insert_prep2 USING 
               oga.oga01,ogb.ogb04,t_imc04   #FUN-890099
         END FOREACH
      END IF
 
       #客戶產品編號
        IF ogb.ogb11 IS NULL THEN
           SELECT obk03 INTO ogb.ogb11 FROM obk_file
            WHERE obk01=ogb.ogb04 AND obk02=oga.oga03
        END IF
 
        IF NOT cl_null(ogd.ogd12b) THEN
           CALL cnt_ogd10(ogd.ogd11,ogd.ogd12b,ogd.ogd12e,ogd.ogd10)
        END IF
 
        #MOD-C50175 mark start -----
        #LET g_po_no=oga.oga10
        #LET g_ctn_no1=oga.oga45
        #LET g_ctn_no2=oga.oga46
        #MOD-C50175 mark end   -----
        #MOD-C50175 add start  -----
        LET g_po_no = ofa.ofa10
        SELECT MIN(ogd12b),MAX(ogd12e) INTO g_ctn_no1,g_ctn_no2 FROM ogd_file WHERE ogd01 = ofa.ofa011
        #MOD-C50175 add end    -----
        LET ocf.ocf101=ocf_c(ocf.ocf101) LET ocf.ocf201=ocf_c(ocf.ocf201)
        LET ocf.ocf102=ocf_c(ocf.ocf102) LET ocf.ocf202=ocf_c(ocf.ocf202)
        LET ocf.ocf103=ocf_c(ocf.ocf103) LET ocf.ocf203=ocf_c(ocf.ocf203)
        LET ocf.ocf104=ocf_c(ocf.ocf104) LET ocf.ocf204=ocf_c(ocf.ocf204)
        LET ocf.ocf105=ocf_c(ocf.ocf105) LET ocf.ocf205=ocf_c(ocf.ocf205)
        LET ocf.ocf106=ocf_c(ocf.ocf106) LET ocf.ocf206=ocf_c(ocf.ocf206)
        LET ocf.ocf107=ocf_c(ocf.ocf107) LET ocf.ocf207=ocf_c(ocf.ocf207)
        LET ocf.ocf108=ocf_c(ocf.ocf108) LET ocf.ocf208=ocf_c(ocf.ocf208)
        LET ocf.ocf109=ocf_c(ocf.ocf109) LET ocf.ocf209=ocf_c(ocf.ocf209)
        LET ocf.ocf110=ocf_c(ocf.ocf110) LET ocf.ocf210=ocf_c(ocf.ocf210)
        LET ocf.ocf111=ocf_c(ocf.ocf111) LET ocf.ocf211=ocf_c(ocf.ocf211)
        LET ocf.ocf112=ocf_c(ocf.ocf112) LET ocf.ocf212=ocf_c(ocf.ocf212)
 
       #列印單身備註
        DECLARE oao_c1 CURSOR FOR                                                 
         SELECT * FROM oao_file,ofa_file,ofb_file                                               
          WHERE oao01=ofa01 
            AND ofa011=oga.oga01
            AND ofa01=ofb01
            AND oao03 =ofb03 AND (oao05='1' OR oao05='2')
          ORDER BY oao04                                                          
        FOREACH oao_c1 INTO oao.*                                               
           IF NOT cl_null(oao.oao06) THEN
              EXECUTE insert_prep1 USING 
                 oga.oga01,oao.oao03,oao.oao04,oao.oao05,oao.oao06                
           END IF                                                                 
        END FOREACH                                                               
 
          EXECUTE insert_prep USING                                                           
             oga.oga27,   oga.oga01,   oga.oga02,   oga.oga03,
             l_occ.occ18, l_occ.occ19, l_occ.occ231,l_occ.occ232,
             ocf.ocf101,  ocf.ocf102,  ocf.ocf103,  ocf.ocf104,
             ocf.ocf105,  ocf.ocf106,  ocf.ocf107,  ocf.ocf108,
             ocf.ocf109,  ocf.ocf110,  ocf.ocf111,  ocf.ocf112,
             ocf.ocf201,  ocf.ocf202,  ocf.ocf203,  ocf.ocf204,
             ocf.ocf205,  ocf.ocf206,  ocf.ocf207,  ocf.ocf208,
             ocf.ocf209,  ocf.ocf210,  ocf.ocf211,  ocf.ocf212,
             l_occ18,     l_occ19,     l_oap041,l_oap042,   #MOD-950259 add
             l_oap043,oga.oga49,   oga.oga43,   oga.oga47,   #MOD-950259 add
             oga.oga48,   sr.oac02,    sr.oac02_2,  l_imc04,               #No.FUN-840230    #FUN-890099取消原本的mark
             ogd.ogd03,   ogd.ogd04,   #MOD-A70022
             ogd.ogd11,   ogd.ogd12b,  ogd.ogd12e,  ogd.ogd10,
             ogb.ogb04,   ogb.ogb06,   ogb.ogb05,   ogd.ogd09,
             ogd.ogd14,   ogd.ogd15,   ogd.ogd16,   ogd.ogd13,
             ogd.ogd14t,  ogd.ogd15t,  ogd.ogd16t,  g_zo12,
             ofa.ofa75,   ogb.ogb03,
             g_zo041,     g_zo05,      g_zo09               #FUN-810029 add
           #  "",          l_img_blob,  "N",         ""       #TQC-C10039 ADD "",l_img_blob,"N",""#No.TQC-C20051 MARK TQC-C10039
     END FOREACH
 
     #列印整張備註                                                          
     LET l_sql = "SELECT oga01 FROM oga_file ",
                 " WHERE ",tm.wc CLIPPED,      
                 "   ORDER BY oga01"           
     PREPARE r554_pre2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN      
        CALL cl_err('pre2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM  
     END IF           
     DECLARE r554_cs2 CURSOR FOR r554_pre2
                                                                                
     FOREACH r554_cs2 INTO oga.oga01
       #整張前備註
        DECLARE oao_c2 CURSOR FOR  
         SELECT * FROM oao_file,ofa_file
          WHERE oao01=ofa01 
            AND ofa011=oga.oga01
            AND oao03=0 AND (oao05='1' OR oao05='2')
          ORDER BY oao04                                
        FOREACH oao_c2 INTO oao.* 
           IF NOT cl_null(oao.oao06) THEN
              EXECUTE insert_prep1 USING
                 oga.oga01,'0',oao.oao04,oao.oao05,oao.oao06
           END IF                                         
        END FOREACH
     END FOREACH    
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " WHERE oao03 =0 AND oao05='1'","|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " WHERE oao03!=0 AND oao05='1'","|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " WHERE oao03!=0 AND oao05='2'","|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " WHERE oao03 =0 AND oao05='2'","|",                       #No.FUN-840230
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED      #No.FUN-840230
 
    #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'oga01,oga02')
             RETURNING tm.wc
     ELSE
        LET tm.wc = ''
     END IF
     LET g_str = tm.wc,";",tm.a,";",tm.b,";",tm.s    #MOD-950144 add
#TQC-C20051-----MARK---STAR-----
#TQC-C10039--add--start---
#     LET g_cr_table = l_table      #主報表的temp table名稱
#     LET g_cr_apr_key_f = "oga01"  #報表主鍵欄位名稱，用"|"隔開
#TQC-C10039--add--end---
#TQC-C20051-----MARK---END----
     CALL cl_prt_cs3('axmr554','axmr554',g_sql,g_str)
     #------------------------------ CR (4) ------------------------------#
END FUNCTION
 
FUNCTION ocf_c(str)
  DEFINE str	LIKE occ_file.occ02      # No.FUN-680137 VARCHAR(30)
        
  # 把麥頭內'PPPPPP'字串改為 P/O NO (oga.oga10)
  # 把麥頭內'CCCCCC'字串改為 CTN NO (oga.oga45)
  # 把麥頭內'DDDDDD'字串改為 CTN NO (oga.oga46)
  LET g_ctn_no1=g_ctn_no1 USING "######"
  LET g_ctn_no2=g_ctn_no2 USING "######"
  FOR i=1 TO 25
    IF str[i,i+5]='PPPPPP' THEN LET str[i,30]=g_po_no     END IF
    IF str[i,i+5]='CCCCCC' THEN LET str[i,i+5]=g_ctn_no1  END IF
    IF str[i,i+5]='DDDDDD' THEN LET str[i,i+5]=g_ctn_no2  END IF
  END FOR
  RETURN str
END FUNCTION
 
FUNCTION cnt_ogd10(wk_ogd11,wk_ogd12b,wk_ogd12e,wk_ogd10)
   DEFINE wk_ogd11   LIKE ogd_file.ogd11,
          wk_ogd12b  LIKE type_file.chr20,       #No.FUN-690126
          wk_ogd12e  LIKE type_file.chr20,       #No.FUN-690126
          wk_ogd10   LIKE ogd_file.ogd10,
          wk_j       LIKE type_file.num5,       # No.FUN-680137 SMALLINT
          sw_esit    LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
          l_ogd12b   LIKE type_file.chr20,       #No.FUN-690126
          l_ogd12e   LIKE type_file.chr20       #No.FUN-690126
   IF wk_ogd11 IS NULL THEN
      LET wk_ogd11 = ' '
   END IF
   IF l_ogd12b[1] NOT MATCHES '[A-z]' AND
      l_ogd12b[2] NOT MATCHES '[A-z]' AND
      l_ogd12b[3] NOT MATCHES '[A-z]' THEN
      LET wk_ogd12b = l_ogd12b USING '&&&'
   END IF
   IF l_ogd12e[1] NOT MATCHES '[A-z]' AND
      l_ogd12e[2] NOT MATCHES '[A-z]' AND
      l_ogd12e[3] NOT MATCHES '[A-z]' THEN
      LET wk_ogd12e = l_ogd12e USING '&&&'
   END IF
   LET sw_esit = 'N'
   IF wk_i = 0 THEN
      LET wk_i = wk_i + 1
      LET wk_array[wk_i].ogd11  = wk_ogd11
      LET wk_array[wk_i].ogd12b = wk_ogd12b  USING '&&&'
      LET wk_array[wk_i].ogd12e = wk_ogd12e  USING '&&&'
      LET tot_ctn = tot_ctn + wk_ogd10
   ELSE
      FOR wk_j = 1 TO wk_i
          IF wk_ogd11 = wk_array[wk_j].ogd11 THEN
             IF (wk_ogd12b >= wk_array[wk_j].ogd12b  AND
                 wk_ogd12b <= wk_array[wk_j].ogd12e) AND
                (wk_ogd12e >= wk_array[wk_j].ogd12b  AND
                 wk_ogd12e <= wk_array[wk_j].ogd12e) THEN
                 LET sw_esit = 'Y'
                 EXIT FOR
              ELSE
                 LET sw_esit = 'N'
              END IF
          END IF
      END FOR
      IF sw_esit = 'N' THEN
         LET wk_i = wk_i + 1
         LET wk_array[wk_i].ogd11  = wk_ogd11
         LET wk_array[wk_i].ogd12b = wk_ogd12b  USING '&&&'
         LET wk_array[wk_i].ogd12e = wk_ogd12e  USING '&&&'
         LET tot_ctn = tot_ctn + wk_ogd10
      END IF
      LET sw_esit = 'N'
   END IF
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
#FUN-B40087
