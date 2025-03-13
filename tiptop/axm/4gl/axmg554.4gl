# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: axmg554.4gl
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
# Modify.........: No.FUN-B40087 11/06/03 By yangtt  憑證報表轉GRW
# Modify.........: No.FUN-C10036 12/01/11 By qirl FUN-B80089追單
# Modify.........: No:FUN-C50003 12/05/14 By yangtt GR程式優化
# Modify.........: No:FUN-C50140 12/06/11 By chenying 列印報表報錯:字元轉換錯誤
# Modify.........: No:FUN-C30085 12/07/02 By chenying GR修改 
# Modify.........: NO.FUN-CB0058 12/12/12 By yangtt 4rp中的visibility condition在4gl中實現，達到單身無定位點
# Modify.........: No.FUN-CC0087 12/12/24 By yangtt 過單處理
# Modify.........: No.MOD-D10157 13/01/17 By jt_chen 修正GR報表欄位:l_ogd11_ogd12b_ogd12e
 
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
 
###GENGRE###START
TYPE sr1_t RECORD
    oga27 LIKE oga_file.oga27,
    oga01 LIKE oga_file.oga01,
    oga02 LIKE oga_file.oga02,
    oga03 LIKE oga_file.oga03,
    occ18_03 LIKE occ_file.occ18,
    occ19_03 LIKE occ_file.occ19,
    occ231 LIKE occ_file.occ231,
    occ232 LIKE occ_file.occ232,
    ocf101 LIKE ocf_file.ocf101,
    ocf102 LIKE ocf_file.ocf102,
    ocf103 LIKE ocf_file.ocf103,
    ocf104 LIKE ocf_file.ocf104,
    ocf105 LIKE ocf_file.ocf105,
    ocf106 LIKE ocf_file.ocf106,
    ocf107 LIKE ocf_file.ocf107,
    ocf108 LIKE ocf_file.ocf108,
    ocf109 LIKE ocf_file.ocf109,
    ocf110 LIKE ocf_file.ocf110,
    ocf111 LIKE ocf_file.ocf112,
    ocf112 LIKE ocf_file.ocf112,
    ocf201 LIKE ocf_file.ocf201,
    ocf202 LIKE ocf_file.ocf202,
    ocf203 LIKE ocf_file.ocf203,
    ocf204 LIKE ocf_file.ocf204,
    ocf205 LIKE ocf_file.ocf205,
    ocf206 LIKE ocf_file.ocf206,
    ocf207 LIKE ocf_file.ocf207,
    ocf208 LIKE ocf_file.ocf208,
    ocf209 LIKE ocf_file.ocf209,
    ocf210 LIKE ocf_file.ocf210,
    ocf211 LIKE ocf_file.ocf212,
    ocf212 LIKE ocf_file.ocf212,
    occ18_04 LIKE occ_file.occ18,
    occ19_04 LIKE occ_file.occ19,
    occ241 LIKE occ_file.occ241,
    occ242 LIKE occ_file.occ242,
    occ243 LIKE occ_file.occ243,
    oga49 LIKE oga_file.oga49,
    oga43 LIKE oga_file.oga43,
    oga47 LIKE oga_file.oga47,
    oga48 LIKE oga_file.oga48,
    oac02 LIKE oac_file.oac02,
    oac02_2 LIKE oac_file.oac02,
    imc04 LIKE imc_file.imc04,
    ogd03 LIKE ogd_file.ogd03,
    ogd04 LIKE ogd_file.ogd04,
    ogd11 LIKE ogd_file.ogd11,
    ogd12b LIKE ogd_file.ogd12b,
    ogd12e LIKE ogd_file.ogd12e,
    ogd10 LIKE ogd_file.ogd10,
    ogb04 LIKE ogb_file.ogb04,
    ogb06 LIKE ogb_file.ogb06,
    ogb05 LIKE ogb_file.ogb05,
    ogd09 LIKE ogd_file.ogd09,
    ogd14 LIKE ogd_file.ogd14,
    ogd15 LIKE ogd_file.ogd15,
    ogd16 LIKE ogd_file.ogd16,
    ogd13 LIKE ogd_file.ogd13,
    ogd14t LIKE ogd_file.ogd14t,
    ogd15t LIKE ogd_file.ogd15t,
    ogd16t LIKE ogd_file.ogd16t,
    zo12 LIKE zo_file.zo12,
    ofa75 LIKE ofa_file.ofa75,
    ogb03 LIKE ogb_file.ogb03,
    zo041 LIKE zo_file.zo041,
    zo05 LIKE zo_file.zo05,
    zo09 LIKE zo_file.zo09
END RECORD

TYPE sr2_t RECORD
    oao03 LIKE oao_file.oao03,
    oao04 LIKE oao_file.oao04,
    oao05 LIKE oao_file.oao05,
    oao06 LIKE oao_file.oao06
END RECORD

TYPE sr3_t RECORD
    oga01 LIKE oga_file.oga01,
    imc01 LIKE imc_file.imc01,
    imc04 LIKE imc_file.imc04
END RECORD
###GENGRE###END

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
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126   #FUN-C10036  mark
 
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
   LET l_table = cl_prt_temptable('axmg554',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time                        #FUN-B40087  #FUN-C10036  mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)     #FUN-B40087  #FUN-C10036  mark
      EXIT PROGRAM 
   END IF                  # Temp Table產生
 
   #備註
   LET g_sql = 
       "oao01.oao_file.oao01,",
       "oao03.oao_file.oao03,",
       "oao04.oao_file.oao04,",
       "oao05.oao_file.oao05,",
       "oao06.oao_file.oao06"
   LET l_table1 = cl_prt_temptable('axmg5541',g_sql) CLIPPED   # 產生Temp Table
   IF l_table1 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time                        #FUN-B40087  #FUN-C10036  mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)     #FUN-B40087  #FUN-C10036  mark
      EXIT PROGRAM 
   END IF                   # Temp Table產生
 
   #額外品名規格
   LET g_sql = 
       "oga01.oga_file.oga01,",    #FUN-890099
       "imc01.imc_file.imc01,",
       "imc04.imc_file.imc04" 
   LET l_table2 = cl_prt_temptable('axmg5542',g_sql) CLIPPED   # 產生Temp Table
   IF l_table2 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time                        #FUN-B40087  #FUN-C10036  mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)     #FUN-B40087  #FUN-C10036  mark
      EXIT PROGRAM 
   END IF                   # Temp Table產生

   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-C10036  add 

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
      CALL axmg554_tm(0,0)             # Input print condition
   ELSE 
      CALL axmg554()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
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
 
FUNCTION axmg554_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680137 SMALLINT
       l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 8 LET p_col = 17
 
   OPEN WINDOW axmg554_w AT p_row,p_col WITH FORM "axm/42f/axmg554"
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
         LET INT_FLAG = 0 CLOSE WINDOW axmg554_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
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
         LET INT_FLAG = 0 CLOSE WINDOW axmg554_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
         EXIT PROGRAM
            
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
                WHERE zz01='axmg554'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('axmg554','9031',1)
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
            CALL cl_cmdat('axmg554',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW axmg554_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL axmg554()
      ERROR ""
   END WHILE
   CLOSE WINDOW axmg554_w
END FUNCTION
 
FUNCTION axmg554()
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
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
    CALL cl_del_data(l_table1)
    CALL cl_del_data(l_table2)
   #------------------------------ CR (2) ------------------------------#
 
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,             
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                "        ?,?,?,?,?, ?,?)"  #No.FUN-840230    #FUN-890099取消原先mark   #MOD-A70022
    PREPARE insert_prep FROM g_sql                                              
    IF STATUS THEN                                                               
       CALL cl_err("insert_prep:",STATUS,1)        #FUN-C10036    add
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)     #FUN-B40087
       EXIT PROGRAM                        
    END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,             
               " VALUES(?,?,?,?,?)"
   PREPARE insert_prep1 FROM g_sql                                              
   IF STATUS THEN                                                               
      CALL cl_err("insert_prep1:",STATUS,1) #FUN-C10036     add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)     #FUN-B40087
      EXIT PROGRAM                        
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,             
               " VALUES(?,?,?)"
   PREPARE insert_prep2 FROM g_sql                                              
   IF STATUS THEN                                                               
      CALL cl_err("insert_prep2:",STATUS,1) #FUN-C10036      add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)     #FUN-B40087
      EXIT PROGRAM                        
   END IF
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #FUN-740066 add
 
     CALL g_zaa_dyn.clear()           #MOD-760122
 
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
 
     LET l_sql="SELECT oga_file.*,ogb_file.*,ogd_file.*,ofa_file.*,",      #MOD-760122 modify 
               "       ocf_file.*,oea10,oah02,oag02,a.oac02,b.oac02,'' ",
              #FUN-C50003---mod----str---
              #"  FROM oga_file,ogb_file,OUTER ogd_file, ",
              #"       OUTER ocf_file,   OUTER oea_file,",
              #"       OUTER oah_file,   OUTER oag_file,",
              #"       OUTER ofa_file,",         #MOD-760122 add
              #"       OUTER oac_file a, OUTER oac_file b ",
              #" WHERE oga01=ogb01 ",
              #"   AND ogb_file.ogb01=ogd_file.ogd01 AND ogb_file.ogb03=ogd_file.ogd03",
              #"   AND ",tm.wc CLIPPED,
              #"   AND ogaconf !='X' ", #01/08/06 mandy 不可為作廢的資料
              #"   AND oga_file.oga04=ocf_file.ocf01 AND oga_file.oga44=ocf_file.ocf02",
              #"   AND oga_file.oga27=ofa_file.ofa01 ",   #MOD-760122 add
              #"   AND ogb_file.ogb31=oea_file.oea01 AND oga_file.oga31=oah_file.oah01 AND oga_file.oga32=oag_file.oag01",
              #"   AND oga_file.oga41=a.oac01 AND oga_file.oga42=b.oac01 "
               "  FROM ogb_file LEFT OUTER JOIN ogd_file ON ogb01=ogd01 AND ogb03=ogd03",
               "                LEFT OUTER JOIN oea_file ON ogb31=oea01 ,",
               "       oga_file LEFT OUTER JOIN ocf_file ON oga04=ocf01 AND oga44=ocf02 ",
               "                LEFT OUTER JOIN ofa_file ON oga27=ofa01 ",
               "                LEFT OUTER JOIN oah_file ON oga31=oah01 ",
               "                LEFT OUTER JOIN oag_file ON oga32=oag01 ",
               "                LEFT OUTER JOIN oac_file a ON oga41=a.oac01 ",
               "                LEFT OUTER JOIN oac_file b ON oga42=b.oac01 ",
               " WHERE oga01=ogb01 ",
               "   AND ",tm.wc CLIPPED,
               "   AND ogaconf !='X' " 
              #FUN-C50003---mod----end---
     IF tm.s = '1' THEN
        LET l_sql = l_sql , " ORDER BY oga01,ogb04"
     ELSE
        LET l_sql = l_sql , " ORDER BY oga01,ogd12b"
     END IF
     PREPARE axmg554_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
        EXIT PROGRAM
     END IF
     DECLARE axmg554_curs1 CURSOR FOR axmg554_prepare1
    #FUN-C50003-----add----str--
     DECLARE imc_c CURSOR FOR
       SELECT imc04  
        FROM imc_file 
       WHERE imc01=? AND imc02=tm.imc02

     DECLARE oao_c1 CURSOR FOR
       SELECT * FROM oao_file,ofa_file,ofb_file
        WHERE oao01=ofa01
         AND ofa011=?
         AND ofa01=ofb01
         AND oao03 =ofb03 AND (oao05='1' OR oao05='2')
        ORDER BY oao04
    #FUN-C50003-----add----end--
 
     LET g_pageno = 0
    #FOREACH axmg554_curs1 INTO oga.*, ogb.*, ogd.*, ofa.*, ocf.*, sr.*   #MOD-760122 modify   #FUN-C50140 mark
     FOREACH axmg554_curs1 INTO oga.*, ogb.*, ogd.*, ofa.*, ocf.*, sr.oea10,sr.oah02,          #FUN-C50140 add
                                sr.oag02,sr.oac02,sr.oac02_2,sr.order2                         #FUN-C50140 add  

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
        #FUN-C50003-----mark---str--
        #DECLARE imc_c CURSOR FOR
        #   SELECT imc04   #FUN-890099
        #     FROM imc_file 
        #    WHERE imc01=ogb.ogb04 AND imc02=tm.imc02
        #FUN-C50003-----mark---end--
         FOREACH imc_c USING ogb.ogb04 INTO t_imc04   #FUN-890099   #FUN-C50003 add USING ogb.ogb04
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
 
        LET g_po_no=oga.oga10
        LET g_ctn_no1=oga.oga45
        LET g_ctn_no2=oga.oga46
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
       #FUN-C50003-----mark---str--
       #DECLARE oao_c1 CURSOR FOR                                                 
       # SELECT * FROM oao_file,ofa_file,ofb_file                                               
       #  WHERE oao01=ofa01 
       #    AND ofa011=oga.oga01
       #    AND ofa01=ofb01
       #    AND oao03 =ofb03 AND (oao05='1' OR oao05='2')
       #  ORDER BY oao04           
       #FUN-C50003-----mark---end--                                               
        FOREACH oao_c1 USING oga.oga01 INTO oao.*           #FUN-C50003 add USING oga.oga01                                    
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
             g_zo041,     g_zo05,      g_zo09   #FUN-810029 add
 
     END FOREACH
 
     #列印整張備註                                                          
     LET l_sql = "SELECT oga01 FROM oga_file ",
                 " WHERE ",tm.wc CLIPPED,      
                 "   ORDER BY oga01"           
     PREPARE g554_pre2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN      
        CALL cl_err('pre2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
        EXIT PROGRAM  
     END IF           
     DECLARE g554_cs2 CURSOR FOR g554_pre2
 
    #FUN-C50003-----add---str-- 
     DECLARE oao_c2 CURSOR FOR
       SELECT * FROM oao_file,ofa_file
        WHERE oao01=ofa01
          AND ofa011=?
          AND oao03=0 AND (oao05='1' OR oao05='2')
        ORDER BY oao04
    #FUN-C50003-----add---end-- 
                                                                                
     FOREACH g554_cs2 INTO oga.oga01
       #整張前備註
       #FUN-C50003-----mark--str--
       #DECLARE oao_c2 CURSOR FOR  
       # SELECT * FROM oao_file,ofa_file
       #  WHERE oao01=ofa01 
       #    AND ofa011=oga.oga01
       #    AND oao03=0 AND (oao05='1' OR oao05='2')
       #  ORDER BY oao04          
       #FUN-C50003-----mark--end--                      
        FOREACH oao_c2 USING oga.oga01 INTO oao.*    #FUN-C50003 add USING oga.oga01
           IF NOT cl_null(oao.oao06) THEN
              EXECUTE insert_prep1 USING
                 oga.oga01,'0',oao.oao04,oao.oao05,oao.oao06
           END IF                                         
        END FOREACH
     END FOREACH    
 
###GENGRE###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
###GENGRE###                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
###GENGRE###                 " WHERE oao03 =0 AND oao05='1'","|",
###GENGRE###                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
###GENGRE###                 " WHERE oao03!=0 AND oao05='1'","|",
###GENGRE###                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
###GENGRE###                 " WHERE oao03!=0 AND oao05='2'","|",
###GENGRE###                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
###GENGRE###                 " WHERE oao03 =0 AND oao05='2'","|",                       #No.FUN-840230
###GENGRE###                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED      #No.FUN-840230
 
    #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'oga01,oga02')
             RETURNING tm.wc
     ELSE
        LET tm.wc = ''
     END IF
###GENGRE###     LET g_str = tm.wc,";",tm.a,";",tm.b,";",tm.s    #MOD-950144 add
###GENGRE###     CALL cl_prt_cs3('axmg554','axmg554',g_sql,g_str)
    CALL axmg554_grdata()    ###GENGRE###
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

###GENGRE###START
FUNCTION axmg554_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("axmg554")
        IF handler IS NOT NULL THEN
            START REPORT axmg554_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY oga01"
            #MOD-D10157 -- add start --
            IF tm.s = '1' THEN
               LET l_sql = l_sql , " ,ogb04"
            ELSE
               LET l_sql = l_sql , " ,ogd12b"
            END IF
            #MOD-D10157 -- add end --
          
            DECLARE axmg554_datacur1 CURSOR FROM l_sql
            FOREACH axmg554_datacur1 INTO sr1.*
                OUTPUT TO REPORT axmg554_rep(sr1.*)
            END FOREACH
            FINISH REPORT axmg554_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT axmg554_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B40087--------add------str-----
    DEFINE l_oga47_oga48            STRING
    DEFINE l_ogd11_ogd12b_ogd12e    STRING
    DEFINE l_order                  STRING
    DEFINE l_str1                   STRING
    DEFINE l_str3                   STRING
    DEFINE l_sql                    STRING
    DEFINE l_ogd10_sum              LIKE ogd_file.ogd10
    DEFINE l_ogd13_sum              LIKE ogd_file.ogd13
    DEFINE l_ogd14t_sum             LIKE ogd_file.ogd14t
    DEFINE l_ogd15t_sum             LIKE ogd_file.ogd15t
    DEFINE l_ogd16t_sum             LIKE ogd_file.ogd16t
    DEFINE l_display                STRING
    DEFINE l_display1               STRING
    DEFINE l_display2               STRING
    DEFINE l_display3               STRING
    DEFINE l_display4               STRING
    #FUN-B40087--------add------end-----
    DEFINE l_percent1               LIKE type_file.chr1     #FUN-CB0058
    DEFINE l_percent2               LIKE type_file.chr1     #FUN-CB0058
    DEFINE l_percent3               LIKE type_file.chr1     #FUN-CB0058
    DEFINE l_percent4               LIKE type_file.chr1     #FUN-CB0058

    
    ORDER EXTERNAL BY sr1.oga01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.oga01
            LET l_lineno = 0
            #FUN-B40087--------add------str-----
            IF NOT cl_null(sr1.oga47) AND NOT cl_null(sr1.oga48) THEN
               LET l_oga47_oga48 = sr1.oga47,' ',sr1.oga48
            ELSE IF NOT cl_null(sr1.oga47) AND cl_null(sr1.oga48) THEN
                    LET l_oga47_oga48 = sr1.oga47,' '
                 END IF
                 IF cl_null(sr1.oga47) AND NOT cl_null(sr1.oga48) THEN
                    LET l_oga47_oga48 = ' ',sr1.oga48
                 END IF
            END IF
            PRINTX l_oga47_oga48
           #MOD-D10157 -- mark start -- #應於ON EVERY ROW 處理 
           #LET l_ogd11_ogd12b_ogd12e = NULL  
           #IF sr1.ogd11 = "X" OR cl_null(sr1.ogd11) THEN
           #   IF NOT cl_null(sr1.ogd12b) AND NOT cl_null(sr1.ogd12e) THEN
           #      LET l_ogd11_ogd12b_ogd12e = sr1.ogd12b,'-',sr1.ogd12e
           #   ELSE IF cl_null(sr1.ogd12b) AND NOT cl_null(sr1.ogd12e) THEN
           #           LET l_ogd11_ogd12b_ogd12e = sr1.ogd12b,'-'
           #        END IF
           #        IF NOT cl_null(sr1.ogd12b) AND cl_null(sr1.ogd12e) THEN
           #           LET l_ogd11_ogd12b_ogd12e = '-',sr1.ogd12e
           #        END IF
           #   END IF
           #ELSE IF NOT cl_null(sr1.ogd12b) AND NOT cl_null(sr1.ogd12e) THEN
           #        LET l_ogd11_ogd12b_ogd12e = sr1.ogd11,sr1.ogd12b,'-',sr1.ogd11,sr1.ogd12e
           #     ELSE IF cl_null(sr1.ogd12b) AND NOT cl_null(sr1.ogd12e) THEN
           #             LET l_ogd11_ogd12b_ogd12e = sr1.ogd11,sr1.ogd12b,'-'
           #          END IF
           #          IF NOT cl_null(sr1.ogd12b) AND cl_null(sr1.ogd12e) THEN
           #             LET l_ogd11_ogd12b_ogd12e = '-',sr1.ogd11,sr1.ogd12e
           #          END IF
           #     END IF
           #END IF 
           #PRINTX l_ogd11_ogd12b_ogd12e
           #MOD-D10157 -- mark end --
  
           #MOD-D10157 -- mark start --   
           #IF tm.s = '1' THEN
           #   LET l_order = sr1.ogb04
           #ELSE 
           #   LET l_order = l_ogd11_ogd12b_ogd12e
           #END IF
           #PRINTX l_order
           #MOD-D10157 -- mark end --

            IF sr1.ofa75 = '1' THEN
               LET l_str1 = "PALLETS"
            ELSE
               LET l_str1 = "CARTONS"
            END IF
            PRINTX l_str1

            IF sr1.ofa75 = '1' THEN
               LET l_str3 = "PLT NO."
            ELSE
               LET l_str3 = "CTN NO."
            END IF
            PRINTX l_str3 
                    
            LET l_sql = "SELECT A.*,B.* FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED," A LEFT OUTER JOIN ",
                        " ofa_file  B ON A.oao01=B.ofa01 ",
                        " WHERE B.ofa011 = '",sr1.oga01 CLIPPED,"'",
                        " AND A.oao05 = '1' AND A.oao03= 0"
            START REPORT axmg554_subrep01
            DECLARE axmg554_repcur1 CURSOR FROM l_sql
            FOREACH axmg554_repcur1 INTO sr2.*
                OUTPUT TO REPORT axmg554_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT axmg554_subrep01
            #FUN-B40087--------add------end-----

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #MOD-D10157 -- add start --
            LET l_ogd11_ogd12b_ogd12e = NULL
            IF sr1.ogd11 = "X" OR cl_null(sr1.ogd11) THEN
               IF NOT cl_null(sr1.ogd12b) AND NOT cl_null(sr1.ogd12e) THEN
                  LET l_ogd11_ogd12b_ogd12e = sr1.ogd12b,'-',sr1.ogd12e
               ELSE IF cl_null(sr1.ogd12b) AND NOT cl_null(sr1.ogd12e) THEN
                       LET l_ogd11_ogd12b_ogd12e = sr1.ogd12b,'-'
                    END IF
                    IF NOT cl_null(sr1.ogd12b) AND cl_null(sr1.ogd12e) THEN
                       LET l_ogd11_ogd12b_ogd12e = '-',sr1.ogd12e
                    END IF
               END IF
            ELSE IF NOT cl_null(sr1.ogd12b) AND NOT cl_null(sr1.ogd12e) THEN
                    LET l_ogd11_ogd12b_ogd12e = sr1.ogd11,sr1.ogd12b,'-',sr1.ogd11,sr1.ogd12e
                 ELSE IF cl_null(sr1.ogd12b) AND NOT cl_null(sr1.ogd12e) THEN
                         LET l_ogd11_ogd12b_ogd12e = sr1.ogd11,sr1.ogd12b,'-'
                      END IF
                      IF NOT cl_null(sr1.ogd12b) AND cl_null(sr1.ogd12e) THEN
                         LET l_ogd11_ogd12b_ogd12e = '-',sr1.ogd11,sr1.ogd12e
                      END IF
                 END IF
            END IF
            PRINTX l_ogd11_ogd12b_ogd12e
            #MOD-D10157 -- add end --
            #FUN-B40087--------add------str-----
            IF NOT cl_null(sr1.ogd09) THEN
               LET l_display = "Y"
               LET l_percent1 = '@'  #FUN-CB0058
            ELSE 
               LET l_display = "N"
               LET l_percent1 = ' '  #FUN-CB0058
            END IF
            PRINTX l_display
            PRINTX l_percent1        #FUN-CB0058
       
            IF NOT cl_null(sr1.ogd14) THEN
               LET l_display1 = "Y"
               LET l_percent2 = '@'  #FUN-CB0058
            ELSE
               LET l_display1 = "N"
               LET l_percent2 = ' '  #FUN-CB0058
            END IF
            PRINTX l_display1
            PRINTX l_percent2        #FUN-CB0058
  
            IF NOT cl_null(sr1.ogd15) THEN
               LET l_display2 = "Y"
               LET l_percent3 = '@'  #FUN-CB0058
            ELSE
               LET l_display2 = "N"
               LET l_percent3 = ' '  #FUN-CB0058
            END IF
            PRINTX l_display2
            PRINTX l_percent3        #FUN-CB0058
       
            IF NOT cl_null(sr1.ogd16) THEN
               LET l_display3 = "Y"
               LET l_percent4 = '@'  #FUN-CB0058
            ELSE
               LET l_display3 = "N"
               LET l_percent4 = ' '  #FUN-CB0058
            END IF
            PRINTX l_display3         
            PRINTX l_percent4        #FUN-CB0058

            IF sr1.ogd12b = 0 AND sr1.ogd12e = 0 THEN
               LET l_display4 = "N"
            ELSE
               LET l_display4 = "Y"
            END IF
            PRINTX l_display4

             LET l_sql = "SELECT A.*,B.* FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED," A LEFT OUTER JOIN ",
                        " ofa_file  B ON A.oao01=B.ofa01 ",
                        " WHERE B.ofa011 = '",sr1.oga01 CLIPPED,"'",
                        " AND oao05='1' AND oao03= ",sr1.ogd03 CLIPPED
            START REPORT axmg554_subrep02
            DECLARE axmg554_repcur2 CURSOR FROM l_sql
            FOREACH axmg554_repcur2 INTO sr2.*
                OUTPUT TO REPORT axmg554_subrep02(sr2.*)
            END FOREACH
            FINISH REPORT axmg554_subrep02

           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"ofa_file",
                        " WHERE imc01 = '",sr1.ogb04 CLIPPED,"'",
                        " AND imc02= ",tm.imc02 CLIPPED
            START REPORT axmg554_subrep05
            DECLARE axmg554_repcur5 CURSOR FROM l_sql
            FOREACH axmg554_repcur5 INTO sr3.*
                OUTPUT TO REPORT axmg554_subrep05(sr3.*)
            END FOREACH
            FINISH REPORT axmg554_subrep05

             LET l_sql = "SELECT A.*,B.* FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED," A LEFT OUTER JOIN ",
                        " ofa_file  B ON A.oao01=B.ofa01 ",
                        " WHERE B.ofa011 = '",sr1.oga01 CLIPPED,"'",
                        " AND oao05='2' AND oao03= ",sr1.ogd03 CLIPPED
            START REPORT axmg554_subrep03
            DECLARE axmg554_repcur3 CURSOR FROM l_sql
            FOREACH axmg554_repcur3 INTO sr2.*
                OUTPUT TO REPORT axmg554_subrep03(sr2.*)
            END FOREACH
            FINISH REPORT axmg554_subrep03
            #FUN-B40087--------add------end-----

            PRINTX sr1.*

        AFTER GROUP OF sr1.oga01
           #FUN-B40087--------add------str-----
           LET l_ogd10_sum = GROUP SUM(sr1.ogd10)
           PRINTX l_ogd10_sum
           LET l_ogd13_sum = GROUP SUM(sr1.ogd13)
           PRINTX l_ogd13_sum
           LET l_ogd14t_sum = GROUP SUM(sr1.ogd14t)
           PRINTX l_ogd14t_sum
           LET l_ogd15t_sum = GROUP SUM(sr1.ogd15t)
           PRINTX l_ogd15t_sum
           LET l_ogd16t_sum = GROUP SUM(sr1.ogd16t)
           PRINTX l_ogd16t_sum


           LET l_sql = "SELECT A.*,B.* FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED," A LEFT OUTER JOIN ",
                        " ofa_file  B ON A.oao01=B.ofa01 ",
                        " WHERE B.ofa011 = '",sr1.oga01 CLIPPED,"'",
                        " AND oao05='2' AND oao03= 0"
            START REPORT axmg554_subrep04
            DECLARE axmg554_repcur4 CURSOR FROM l_sql
            FOREACH axmg554_repcur4 INTO sr2.*
                OUTPUT TO REPORT axmg554_subrep04(sr2.*)
            END FOREACH
            FINISH REPORT axmg554_subrep04
           #FUN-B40087--------add------end-----            

        
        ON LAST ROW

END REPORT

#FUN-B40087--------add------str-----
REPORT axmg554_subrep01(sr2)
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*
END REPORT

REPORT axmg554_subrep02(sr2)
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*
END REPORT

REPORT axmg554_subrep03(sr2)
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*
END REPORT

REPORT axmg554_subrep04(sr2)
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*
END REPORT

REPORT axmg554_subrep05(sr3)
    DEFINE sr3 sr3_t

    FORMAT
        ON EVERY ROW
            PRINTX sr3.*
END REPORT
#FUN-B40087--------add------end-----
###GENGRE###END
#FUN-C30085
#FUN-CC0087
