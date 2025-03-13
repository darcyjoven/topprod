# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: aimg512.4gl
# Descriptions...: 調撥單列印
# Input parameter:
# Return code....:
# Date & Author..: 92/05/08 By Wu
# Modify.........: 95/05/11 By Danny (變更畫面)
# Modify.........: 03/02/25 BY Carol modify FOR 養生計劃 (bugno:6810)
# Modify.........: No.FUN-550029 05/05/30 By day   單據編號加大
# Modify.........: No.FUN-550108 05/05/25 By echo 新增報表備註
# Modify.........: No.FUN-580005 05/08/03 By ice 2.0憑證類報表原則修改,並轉XML格式
# Modify.........: No.MOD-590294 05/09/26 By kim 料號長度超過20碼會被截掉
# Modify.........: No.FUN-590110 05/10/11 By day 補上zo02的抓取
# Modify.........: No.FUN-5A0138 05/10/20 By Claire 調整報表格式
# Modify.........: No.MOD-5C0022 05/12/06 By kim 理由碼放大至40
# Modify.........: No.MOD-5C0117 05/12/22 By Claire tm.s 修正為 set_entry
# Modify.........: No.FUN-5C0077 05/12/23 By yoyo 報表單身增加欄位imn29
# Modify.........: No.TQC-5C0005 06/01/11 By kevin 結束位置調整
# Modify.........: NO.FUN-590118 06/01/11 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660078 06/06/14 By rainy aim系統中，用char定義的變數，改為用LIKE
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/07 By baogui 無列印順序
# Modify.........: No.TQC-6B0068 06/11/15 By Ray 報表抬頭部分轉為template型寫法
# Modify.........: No.FUN-710084 07/02/01 By Elva 報表輸出至Crystal Reports功能
# Modify.........: No.CHI-6B0037 07/02/28 By jamie 列印時，不CHECK過帳碼imm03
# Modify.........: No.TQC-730088 07/03/26 By Nicole 新增CR參數
# Modify.........: No.MOD-740265 07/04/23 By Sarah 新增aimt324單據第一次列印,報表表頭卻會出現(已列印過)的訊息
# Modify.........: No.MOD-840210 08/04/20 By rainy aimt325、aimt720列印時，不應卡imm04='Y'。
# Modify.........: No.FUN-860026 08/07/17 By baofei 增加子報表-列印批序號明細
# Modify.........: No.MOD-870271 07/07/23 By claire 參數null時應給空白
# Modify.........: No.MOD-910055 09/01/08 By claire aimt720不能限制已確認的單據
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50018 11/05/12 By xumm CR轉GRW
# Modify.........: No.FUN-B50018 11/08/11 By xumm 程式規範修改
# Modify.........: No.FUN-C10036 12/01/11 By yangtt 程式規範修改
# Modify.........: No.FUN-C20080 12/02/25 By lujh "-"改成" -"
# Modify.........: No.FUN-C40019 12/04/11 By yangtt GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50007 12/05/02 By minpp GR程序優化
# Modify.........: No.FUN-C30085 12/06/19 By chenying gr修改
# Modify.........: No.FUN-C90130 12/09/28 By yangtt 調撥單欄位添加開窗
# Modify.........: No.DEV-D30030 13/03/20 By TSD.JIE 與M-Barcode整合(aza131)='Y',列印單號條碼
# Modify.........: No.TQC-DB0035 13/11/18 By wangrr 修改報表,'申請人'欄位增加開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580005 --start--
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17    #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5    #No.FUN-690026 SMALLINT
END GLOBALS
#No.FUN-580005 --end--
 
DEFINE tm       RECORD                            #Print condition RECORD
                  wc      LIKE type_file.chr1000, #Where condition    #No.FUN-690026 VARCHAR(500)
                  a       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
                  b       LIKE type_file.chr1,    #bugno:6810 add     #No.FUN-690026 VARCHAR(1)
                  c       LIKE type_file.chr1,    #No.FUN-860026
                  s       LIKE type_file.chr3,    #Order by sequence  #No.FUN-690026 VARCHAR(3)
                  more    LIKE type_file.chr1     #Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
                END RECORD,
       g_buf    LIKE azf_file.azf03,            #FUN-660078 
       g_argv1	LIKE imm_file.imm01,            #No.FUN-550029 #No.FUN-690026 VARCHAR(16)
       g_argv2	LIKE type_file.chr1             #No.FUN-690026 VARCHAR(1)
DEFINE g_i      LIKE type_file.num5             #count/index for any purpose  #No.FUN-690026 SMALLINT
#No.FUN-580005 --start--
DEFINE g_sma115 LIKE sma_file.sma115
DEFINE g_sma116 LIKE sma_file.sma116
DEFINE l_orderA      ARRAY[3] OF LIKE imm_file.imm13   #No.TQC-6A0088
#No.FUN-580005 --end--
DEFINE    l_table     STRING,                       ### FUN-710084 ###
          g_sql       STRING                        ### FUN-710084 ###         
DEFINE    g_str       STRING                        ### FUN-710084 ###
DEFINE    l_table1    STRING                 #No.FUN-860026 
 
###GENGRE###START
TYPE sr1_t RECORD
    order1 LIKE type_file.chr100,      #FUN-B50018 add
    order2 LIKE type_file.chr100,      #FUN-B50018 add
    order3 LIKE type_file.chr100,      #FUN-B50018 add
    imm11 LIKE imm_file.imm11,
    imm12 LIKE imm_file.imm12,
    imm13 LIKE imm_file.imm13,
    imm09 LIKE imm_file.imm09,
    imm01 LIKE imm_file.imm01,
    imm02 LIKE imm_file.imm02,
    imm07 LIKE imm_file.imm07,
    imn04 LIKE imn_file.imn04,
    imn05 LIKE imn_file.imn05,
    imn06 LIKE imn_file.imn06,
    imn15 LIKE imn_file.imn15,
    imn16 LIKE imn_file.imn16,
    imn17 LIKE imn_file.imn17,
    imn02 LIKE imn_file.imn02,
    imn09 LIKE imn_file.imn09,
    imn20 LIKE imn_file.imn20,
    imn10 LIKE imn_file.imn10,
    imn29 LIKE imn_file.imn29,
    imn03 LIKE imn_file.imn03,
    ima02 LIKE ima_file.ima02,
    ima021 LIKE ima_file.ima021,
    imn28 LIKE imn_file.imn28,
    azf03 LIKE azf_file.azf03,
    immuser LIKE imm_file.immuser,
    l_str LIKE type_file.chr1000,
    flag LIKE type_file.num5,
    sign_type LIKE type_file.chr1,     #FUN-C40019 add
    sign_img LIKE type_file.blob,      #FUN-C40019 add
    sign_show LIKE type_file.chr1,     #FUN-C40019 add
    sign_str LIKE type_file.chr1000    #FUN-C40019 add
END RECORD

TYPE sr2_t RECORD
    rvbs01 LIKE rvbs_file.rvbs01,
    rvbs02 LIKE rvbs_file.rvbs02,
    rvbs03 LIKE rvbs_file.rvbs03,
    rvbs04 LIKE rvbs_file.rvbs04,
    rvbs06 LIKE rvbs_file.rvbs06,
    rvbs09 LIKE rvbs_file.rvbs09,
    rvbs021 LIKE rvbs_file.rvbs021,
    ima02 LIKE ima_file.ima02,
    ima021 LIKE ima_file.ima021,
    imn09 LIKE imn_file.imn09,
    imn10 LIKE imn_file.imn10,
    imn20 LIKE imn_file.imn20,
    img09_o LIKE img_file.img09,
    img09_i LIKE img_file.img09
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                           # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
   ### FUN-710084 Start ### 
   LET g_sql =   "order1.type_file.chr100,",   #FUN-B50018 add
                 "order2.type_file.chr100,",   #FUN-B50018 add
                 "order3.type_file.chr100,",   #FUN-B50018 add
                 "imm11.imm_file.imm11,imm12.imm_file.imm12,",
                 "imm13.imm_file.imm13,imm09.imm_file.imm09,",
                 "imm01.imm_file.imm01,imm02.imm_file.imm02,",
                 "imm07.imm_file.imm07,imn04.imn_file.imn04,",
                 "imn05.imn_file.imn05,imn06.imn_file.imn06,",
                 "imn15.imn_file.imn15,imn16.imn_file.imn16,",
                 "imn17.imn_file.imn17,imn02.imn_file.imn02,",
                 "imn09.imn_file.imn09,imn20.imn_file.imn20,",
                 "imn10.imn_file.imn10,imn29.imn_file.imn29,",
                 "imn03.imn_file.imn03,ima02.ima_file.ima02,", 
                 "ima021.ima_file.ima021,imn28.imn_file.imn28,", 
                 "azf03.azf_file.azf03,immuser.imm_file.immuser,",
#                 "l_str.type_file.chr1000"      #No.FUN-860026
                 "l_str.type_file.chr1000,flag.type_file.num5,",  #No.FUN-860026 
                 "sign_type.type_file.chr1,   sign_img.type_file.blob,",   #簽核方式, 簽核圖檔  #FUN-C40019 add
                 "sign_show.type_file.chr1,  sign_str.type_file.chr1000"                        #FUN-C40019 add  
 
    LET l_table = cl_prt_temptable('aimg512',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add 
       CALL cl_gre_drop_temptable(l_table||"|"||l_table1)   #FUN-B50018  add
       EXIT PROGRAM
    END IF                  # Temp Table產生
#No.FUN-860026---begin                                                                                                              
   LET g_sql = "rvbs01.rvbs_file.rvbs01,",                                                                                          
               "rvbs02.rvbs_file.rvbs02,",                                                                                          
               "rvbs03.rvbs_file.rvbs03,",                                                                                          
               "rvbs04.rvbs_file.rvbs04,",                                                                                          
               "rvbs06.rvbs_file.rvbs06,",    
               "rvbs09.rvbs_file.rvbs09,",                                                                                         
               "rvbs021.rvbs_file.rvbs021,",                                                                                        
               "ima02.ima_file.ima02,",                                                                                             
               "ima021.ima_file.ima021,",                                                                                           
               "imn09.imn_file.imn09,",                                                                                             
               "imn10.imn_file.imn10,",                                                                                             
               "imn20.imn_file.imn20,",                                                                                             
               "img09_o.img_file.img09,",                                                                                           
               "img09_i.img_file.img09"                                                                                             
   LET l_table1 = cl_prt_temptable('aimg5121',g_sql) CLIPPED                                                                        
   IF  l_table1 = -1 THEN 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add
       CALL cl_gre_drop_temptable(l_table||"|"||l_table1)   #FUN-B50018  add
       EXIT PROGRAM
   END IF      
#    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
#                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
#                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
#                "        ?, ?, ?, ?, ?)"
#    PREPARE insert_prep FROM g_sql
#    IF STATUS THEN
#       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
#    END IF
#No.FUN-860026---end
   ### FUN-710084 End ### 
  #TQC-610072-begin 
   LET g_pdate = ARG_VAL(1)              # Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.a    = ARG_VAL(8)
   LET tm.b    = ARG_VAL(9)
   LET tm.c    = ARG_VAL(14)  #No.FUN-860026
   LET tm.s    = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #LET g_argv1 = ARG_VAL(1)                  # Get arguments from command line
   #LET g_argv2 = ARG_VAL(2)                  # Get arguments from command line
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(3)
   #LET g_rep_clas = ARG_VAL(4)
   #LET g_template = ARG_VAL(5)
   LET g_rpt_name = ARG_VAL(6)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
   #INITIALIZE tm.* TO NULL                   # Default condition
   #LET tm.s    = '123'
   #LET tm.more = 'N'
   #LET g_pdate = g_today
   #LET g_rlang = g_lang
   #LET g_bgjob = 'N'
   #LET g_copies = '1'
   #LET tm2.s1   = '1'
   #LET tm2.s2   = '2'
   #LET tm2.s3   = '3'
   #IF cl_null(g_argv1) THEN
   IF cl_null(g_bgjob) OR g_bgjob = 'N'  THEN  # If background job sw is off
  #TQC-610072-end 
      CALL g512_tm(0,0)            # Input print condition
   ELSE
     #LET tm.wc=" imm01='",g_argv1,"'"  #TQC-610072
      CALL g512()                  # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
END MAIN
 
FUNCTION g512_tm(p_row,p_col)
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col   LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd         LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 18
 
   OPEN WINDOW g512_w AT p_row,p_col WITH FORM "aim/42f/aimg512"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
 
  #TQC-610072-begin 
   INITIALIZE tm.* TO NULL                   # Default condition
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm2.s1   = '1'
   LET tm2.s2   = '2'
   LET tm2.s3   = '3'
  #TQC-610072-end 
   LET tm.a = '1'
   LET tm.b = ' '
   LET tm.c = 'N'  #No.FUN-860026
WHILE TRUE
 
   CONSTRUCT BY NAME tm.wc ON imm01,imm02,immuser
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---

      #FUN-C90130--add--str--
      ON ACTION controlp
         CASE
            WHEN INFIELD(imm01)
               CALL cl_init_qry_var()
               LET g_qryparam.state    = "c"
               LET g_qryparam.form     = "q_imm"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO imm01
               NEXT FIELD imm01
            #TQC-DB0035--add--str--
            WHEN INFIELD(immuser)
               CALL cl_init_qry_var()
               LET g_qryparam.state    = "c"
               LET g_qryparam.form     = "q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO immuser
               NEXT FIELD immuser
            #TQC-DB0035--add--end
         END CASE
      #FUN-C90130--add--str--
 
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
      LET INT_FLAG = 0 CLOSE WINDOW g512_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1) 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
 
   INPUT BY NAME tm.a,tm.b,tm.c,tm2.s1,tm2.s2,tm2.s3,        #No.FUN-860026 add tm.c
                 tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      BEFORE FIELD a                       #MOD-5C0117
       CALL cl_set_comp_entry("b",TRUE)   #MOD-5C0117
 
      AFTER FIELD a
         IF cl_null(tm.a) THEN NEXT FIELD a END IF
         IF tm.a NOT MATCHES'[1234]' THEN
             NEXT FIELD a
         END IF
 
# BugNo.6810
         IF tm.a != '2' THEN
            LET tm.b = ''
            DISPLAY BY NAME tm.b
            CALL cl_set_comp_entry("b",FALSE) #MOD-5C0117
          # NEXT FIELD s                      #MOD-5C0117
         END IF
 
      AFTER FIELD b
         IF cl_null(tm.b) THEN NEXT FIELD b END IF
         IF tm.b NOT MATCHES'[12]' THEN
             NEXT FIELD b
         END IF
 
# BugNo.6810
#No.FUN-860026---BEGIN                                                                                                              
      AFTER FIELD c    #列印批序號明細                                                                                              
         IF tm.c NOT MATCHES "[YN]" OR cl_null(tm.c)                                                                                
            THEN NEXT FIELD c                                                                                                       
         END IF                                                                                                                     
#No.FUN-860026---END  
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
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
 
      ON ACTION CONTROLG
         CALL cl_cmdask()        # Command execution
 
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
 
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
      LET INT_FLAG = 0 CLOSE WINDOW g512_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1) 
      EXIT PROGRAM
         
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='aimg512'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimg512','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",                 #No.FUN-860026
                         " '",tm.s CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimg512',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW g512_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1) 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   LET g_argv2 = tm.b    #bugno:6810 add
   CALL g512()
   ERROR ""
END WHILE
   CLOSE WINDOW g512_w
END FUNCTION
 
FUNCTION g512()
   DEFINE l_name        LIKE type_file.chr20,             # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8            #No.FUN-6A0074
          l_sql         LIKE type_file.chr1000,           # RDSQL STATEMENT  #No.FUN-690026 VARCHAR(1000)
          l_za05        LIKE za_file.za05,                #No.FUN-690026 VARCHAR(40)
         # l_order       ARRAY[3] OF LIKE imm_file.imm01,  #No.FUN-690026 VARCHAR(20)  #FUN-B50018 mark
          sr            RECORD order1  LIKE imm_file.imm01,#No.FUN-690026 VARCHAR(20)
                               order2  LIKE imm_file.imm01,#No.FUN-690026 VARCHAR(20)
                               order3  LIKE imm_file.imm01,#No.FUN-690026 VARCHAR(20)
                               imm01   LIKE imm_file.imm01,
                               imm02   LIKE imm_file.imm02,
                               imm04   LIKE imm_file.imm04,
                               imm07   LIKE imm_file.imm07,
                               imm09   LIKE imm_file.imm09,
                               imm11   LIKE imm_file.imm11,  #bugno:6810 add
                               imm12   LIKE imm_file.imm12,  #bugno:6810 add
                               imm13   LIKE imm_file.imm13,  #bugno:6810 add
                               immuser LIKE imm_file.immuser,
                               gen02   LIKE gen_file.gen02,
                               imn02   LIKE imn_file.imn02,
                               imn03   LIKE imn_file.imn03,
                               ima02   LIKE ima_file.ima02,
                               ima021  like ima_file.ima021,
                               imn04   LIKE imn_file.imn04,
                               imn05   LIKE imn_file.imn05,
                               imn06   LIKE imn_file.imn06,
                               imn07   LIKE imn_file.imn07,
                               imn08   LIKE imn_file.imn08,
                               imn09   LIKE imn_file.imn09,
                               imn10   LIKE imn_file.imn10,
                               imn15   LIKE imn_file.imn15,
                               imn16   LIKE imn_file.imn16,
                               imn17   LIKE imn_file.imn17,
                               imn18   LIKE imn_file.imn18,
                               imn19   LIKE imn_file.imn19,
                               imn20   LIKE imn_file.imn20,
                               imn21   LIKE imn_file.imn21,
                               #No.FUN-580005 --start--
                               imn30   LIKE imn_file.imn30,
                               imn32   LIKE imn_file.imn32,
                               imn33   LIKE imn_file.imn33,
                               imn35   LIKE imn_file.imn35,
                               imn40   LIKE imn_file.imn40,
                               imn42   LIKE imn_file.imn42,
                               imn43   LIKE imn_file.imn43,
                               imn45   LIKE imn_file.imn45,
                               #No.FUN-580005 --end--
                               imn28   LIKE imn_file.imn28,
                               imn29   LIKE imn_file.imn29,   #No.FUN-5C0077
                               imn23   LIKE imn_file.imn23
                        END RECORD
     DEFINE l_order   ARRAY[3] OF LIKE type_file.chr100       #FUN-B50018 add
     DEFINE l_i,l_cnt   LIKE type_file.num5                   #No.FUN-580005  #No.FUN-690026 SMALLINT
     DEFINE l_zaa02     LIKE zaa_file.zaa02                   #No.FUN-580005
#No.FUN-860026---begin                                                                                                              
     DEFINE       l_rvbs         RECORD                                                                                             
                                  rvbs03   LIKE  rvbs_file.rvbs03,                                                                  
                                  rvbs04   LIKE  rvbs_file.rvbs04,                                                                  
                                  rvbs06   LIKE  rvbs_file.rvbs06,      
                                  rvbs09   LIKE  rvbs_file.rvbs09,     
                                  rvbs021  LIKE  rvbs_file.rvbs021                                                                  
                                  END RECORD                                                                                        
     DEFINE        l_img09_o     LIKE img_file.img09                                                                                
     DEFINE        l_img09_i     LIKE img_file.img09 
     DEFINE        l_string        LIKE type_file.chr1000                                                                               
#No.FUN-860026---end  
     #FUN-710084  --begin
     DEFINE l_str1        LIKE type_file.chr1000,#No.FUN-580005  #No.FUN-690026 VARCHAR(100)
            l_imn45       STRING,    #No.FUN-580005
            l_imn42       STRING     #No.FUN-580005
     DEFINE l_str2        LIKE type_file.chr1000,#No.FUN-580005  #No.FUN-690026 VARCHAR(100)
            l_imn35       STRING,    #No.FUN-580005
            l_imn32       STRING     #No.FUN-580005
     DEFINE l_ima906      LIKE ima_file.ima906           #FUN-580005
     #FUN-710084  --end
     DEFINE flag          LIKE  type_file.num5
     DEFINE l_img_blob     LIKE type_file.blob     #FUN-C40019 add

     LOCATE l_img_blob    IN MEMORY                #FUN-C40019 add
#No.FUN-860026---BEGIN
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                          
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",                                                                           
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",                                                                           
#                "        ?, ?, ?, ?, ?)"    #No.FUN-860026
                "        ?, ?, ?, ?, ?,?,?,?,?, ?,?,?,?)"   #No.FUN-860026        #FUN-B50018 add 3?   #FUN-C40019 add 4?                                                                             
    PREPARE insert_prep FROM g_sql                                                                                                 
    IF STATUS THEN                                                                                                                 
       CALL cl_err('insert_prep:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       CALL cl_gre_drop_temptable(l_table||"|"||l_table1)   #FUN-C10036  add
       EXIT PROGRAM                                                                           
    END IF        
     LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"                                                                           
     PREPARE insert_prep1 FROM l_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err("insert_prep1:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1)   #FUN-C10036  add
        EXIT PROGRAM                                                                          
     END IF   
#No.FUN-860026---END
     #FUN-710084  --begin
     CALL cl_del_data(l_table)        
     CALL cl_del_data(l_table1)    #No.FUN-860026
     #FUN-710084  --end
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang  #No.FUN-590110
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND immuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND immgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND immgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('immuser', 'immgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','','',",                           #FUN-B50018 add 3 '',
                 " imm01,imm02,imm04,imm07,imm09,imm11,imm12,imm13,",
                 " immuser,gen02,imn02,",
                 " imn03,ima02, ima021, imn04,imn05,imn06,imn07, ",
                 " imn08,imn09,imn10,imn15,imn16,imn17, ",
                 " imn18,imn19,imn20,imn21, ",
                 " imn30,imn32,imn33,imn35,imn40,imn42,imn43,imn45, ",   #No.FUN-580005
                 " imn28,imn29,imn23 ",    #NO.FUN-5C0077
           #FUN-C50007--MOD--STR
           #     " FROM imm_file, OUTER gen_file,imn_file, OUTER ima_file ",   
           #     " WHERE imm01 = imn_file.imn01 AND imm_file.immuser = gen_file.gen01 ",  
           #     " AND imn_file.imn03 = ima_file.ima01 AND ", tm.wc CLIPPED     
                 "  FROM imm_file LEFT OUTER JOIN gen_file ON immuser=gen01 ,",
                 "       imn_file LEFT OUTER JOIN ima_file ON imn03=ima01 ",
                 "  WHERE imm01 = imn01 AND ",tm.wc CLIPPED
           #FUN-C50007--MOD--END
     IF NOT cl_null(tm.a) THEN
         LET l_sql = l_sql clipped," AND imm10 ='",tm.a,"'"
         CASE tm.a
              WHEN '1' #一階段倉庫調撥aimt324
                 # LET l_sql = l_sql clipped," AND imm03 = 'Y'" #CHI-6B0037 
                 # LET l_sql = l_sql clipped #CHI-6B0037  #MOD-910055 mark
                   LET l_sql = l_sql clipped," AND immconf <> 'X'" #MOD-910055 
              WHEN '2' #二階段倉庫調撥aimt325
                   #LET l_sql = l_sql clipped," AND imm04 = 'Y'"  #MOD-840210
                   #LET l_sql = l_sql clipped                      #MOD-840210  #MOD-910055 mark
                   LET l_sql = l_sql clipped ," AND imm04 <> 'X'"  #MOD-910055
              WHEN '3' #一階段工廠調撥aimt720
                  #LET l_sql = l_sql clipped," AND imm04 = 'Y'"   #MOD-840210
                   LET l_sql = l_sql clipped                      #MOD-840210
              WHEN '4' #二階段工廠調撥aimt700                    
                   LET l_sql = l_sql clipped ," AND immacti = 'Y'"
         END CASE
     END IF
     IF g_argv2 = '2' THEN
        LET l_sql = l_sql clipped, " ORDER BY imm11,imn02 "
     ELSE
        LET l_sql = l_sql clipped, " ORDER BY imm01,imn02 "
     END IF
 
 
     PREPARE g512_prepare FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) RETURN
     END IF
 
     DECLARE g512_cs CURSOR FOR g512_prepare
     IF SQLCA.sqlcode THEN
        CALL cl_err('declare:',SQLCA.sqlcode,1) RETURN
     END IF
 
     #FUN-710084  --begin
    #CALL cl_outnam('aimg512') RETURNING l_name
     #No.FUN-580005 --start--
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file
    #IF g_sma115 = "Y" THEN
    #   LET g_zaa[37].zaa06 = "N"
    #ELSE
    #   LET g_zaa[37].zaa06 = "Y"
    #END IF
    #CALL cl_prt_pos_len()
     #No.FUN-580005 --end--
 
   # START REPORT g512_rep TO l_nameI

    #FUN-C50007--ADD--STR
     DECLARE r920_d  CURSOR  FOR
           SELECT rvbs03,rvbs04,rvbs06,rvbs09,rvbs021  FROM rvbs_file
                  WHERE rvbs01 = ? AND rvbs02 = ?
                  ORDER BY  rvbs04
    #FUN-C50007--ADD--END
     LET g_pageno = 0
 
     FOREACH g512_cs INTO sr.*
       IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF sr.imm02 IS NULL THEN LET sr.imm02 = ' ' END IF
       IF sr.immuser IS NULL THEN LET sr.immuser = ' ' END IF
       IF sr.imn03 IS NULL THEN LET sr.imn03 = ' ' END IF
       IF sr.imm07 IS NULL THEN LET sr.imm07 = 0 END IF   #MOD-740265 add
     # FOR g_i = 1 TO 3
     #    CASE WHEN tm.s[g_i,g_i] = '1'
     #              IF g_argv2 = '2' THEN
     #                 LET l_order[g_i] = sr.imm11
     #                 LET l_orderA[g_i] =g_x[11]    #TQC-6A0088
     #              ELSE
     #                 LET l_order[g_i] = sr.imm01
     #                 LET l_orderA[g_i] =g_x[11]    #TQC-6A0088
     #              END IF
     #         WHEN tm.s[g_i,g_i] = '2'
     #              IF g_argv2 = '2' THEN
     #                 LET l_order[g_i] = sr.imm12 USING 'yyyymmdd'
     #                  LET l_orderA[g_i] =g_x[13]    #TQC-6A0088
     #              ELSE
     #                 LET l_order[g_i] = sr.imm02 USING 'yyyymmdd'
     #                  LET l_orderA[g_i] =g_x[13]    #TQC-6A0088
     #              END IF
     #         WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.immuser
     #                                  LET l_orderA[g_i] =g_x[23]    #TQC-6A0088
     #         OTHERWISE LET l_order[g_i] = '-'
     #                   LET l_orderA[g_i] =''    #TQC-6A0088 
     #    END CASE
     # END FOR
     # LET sr.order1 = l_order[1]
     # LET sr.order2 = l_order[2]
     # LET sr.order3 = l_order[3]
      SELECT azf03 INTO g_buf FROM azf_file WHERE azf01=sr.imn28 AND azf02='2' #6808
     #IF STATUS THEN LET g_buf='' END IF
      SELECT ima906 INTO l_ima906 FROM ima_file
                          WHERE ima01 = sr.imn03
      LET l_str1 = ""
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         IF NOT cl_null(sr.imn45) AND sr.imn45 <> 0 THEN
            CALL cl_remove_zero(sr.imn45) RETURNING l_imn45
            LET l_str1 = l_imn45, sr.imn43 CLIPPED
         END IF
         IF NOT cl_null(sr.imn35) AND sr.imn35 <> 0 THEN
            CALL cl_remove_zero(sr.imn35) RETURNING l_imn35
            LET l_str2 = l_imn35, sr.imn33 CLIPPED
         END IF
         IF l_ima906 = "2" THEN
            IF cl_null(sr.imn45) OR sr.imn45 = 0 THEN
               CALL cl_remove_zero(sr.imn42) RETURNING l_imn42
               LET l_str1 = l_imn42, sr.imn40 CLIPPED
            ELSE
               IF NOT cl_null(sr.imn42) AND sr.imn42 <> 0 THEN
                  CALL cl_remove_zero(sr.imn42) RETURNING l_imn42
                  LET l_str1 = l_str1 CLIPPED,',',l_imn42, sr.imn40 CLIPPED
               END IF
            END IF
            IF cl_null(sr.imn35) OR sr.imn35 = 0 THEN
               CALL cl_remove_zero(sr.imn32) RETURNING l_imn32
               LET l_str2 = l_imn32, sr.imn30 CLIPPED
            ELSE
               IF NOT cl_null(sr.imn32) AND sr.imn32 <> 0 THEN
                  CALL cl_remove_zero(sr.imn32) RETURNING l_imn32
                  LET l_str2 = l_str2 CLIPPED,',',l_imn32, sr.imn30 CLIPPED
               END IF
            END IF
         END IF
      END IF
#No.FUN-860026---begin                                       
    LET flag= 0                                                                       
    SELECT img09 INTO l_img09_o  FROM img_file WHERE img01 = sr.imn03                                                               
               AND img02 = sr.imn04 AND img03 = sr.imn05                                                                            
               AND img04 = sr.imn06                                                                                                 
    SELECT img09 INTO l_img09_i  FROM img_file WHERE img01 = sr.imn03                                                               
               AND img02 = sr.imn15 AND img03 = sr.imn16                                                                            
               AND img04 = sr.imn17                                                                                                 
    #FUN-C50007--MARK--STR
   #DECLARE r920_d  CURSOR  FOR                                                                                                     
   #       SELECT rvbs03,rvbs04,rvbs06,rvbs09,rvbs021  FROM rvbs_file                                                                      
   #              WHERE rvbs01 = sr.imm01 AND rvbs02 = sr.imn02                                                                     
   #              ORDER BY  rvbs04                                                                                                  
   #FOREACH  r920_d INTO l_rvbs.*     
    #FUN-C50007--MARK--END
    FOREACH  r920_d  USING sr.imm01,sr.imn02 INTO l_rvbs.* #FUN-C50007
         LET flag = 1                                                                                              
         EXECUTE insert_prep1 USING  sr.imm01,sr.imn02,l_rvbs.rvbs03,                                                               
                                     l_rvbs.rvbs04,l_rvbs.rvbs06,l_rvbs.rvbs09,l_rvbs.rvbs021,                                                    
                                     sr.ima02,sr.ima021,sr.imn09,sr.imn10,sr.imn20,                                                 
                                     l_img09_o,l_img09_i                                                                            
                                                                                                                                    
    END FOREACH                                                                                                                     
#No.FUN-860026---end      

#FUN-B50018------------add---------str------------
       FOR g_i = 1 TO 3
           CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.imm01
                WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.imm02
                WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.immuser
                OTHERWISE LET l_order[g_i] = '-'
           END CASE
       END FOR
       IF l_order[1] IS NULL THEN LET l_order[1] = ' ' END IF
       IF l_order[2] IS NULL THEN LET l_order[2] = ' ' END IF
       IF l_order[3] IS NULL THEN LET l_order[3] = ' ' END IF

#FUN-B50018------------add---------end----------- 

       EXECUTE insert_prep USING l_order[1],l_order[2],l_order[3],  #FUN-B50018 add
                                 sr.imm11,sr.imm12,sr.imm13,sr.imm09,
                                 sr.imm01,sr.imm02,sr.imm07,sr.imn04,
                                 sr.imn05,sr.imn06,sr.imn15,sr.imn16,
                                 sr.imn17,sr.imn02,sr.imn09,sr.imn20,
                                 sr.imn10,sr.imn29,sr.imn03,sr.ima02, 
                                 sr.ima021,sr.imn28,g_buf,sr.immuser,
#                                 l_str1       #No.FUN-860026
                                 l_str1,flag,   #No.FUN-860026
                                 "",l_img_blob,"N",""    #FUN-C40019 add
     # OUTPUT TO REPORT g512_rep(sr.*)
     END FOREACH
 
    #FINISH REPORT g512_rep
 
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED #TQC-730088
#     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED, l_table CLIPPED   #No.FUN-860026
###GENGRE###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED, l_table CLIPPED,"|",
###GENGRE###                 "SELECT * FROM ",g_cr_db_str CLIPPED, l_table1 CLIPPED   #No.FUN-860026 
     LET g_str = g_sma115
     IF cl_null(g_argv2) THEN LET g_argv2='' END IF    #MOD-870271 add
     LET g_str = g_str ,";",g_argv2,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3]                                              
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #是否列印選擇條件                                                            
     IF g_zz05 = 'Y' THEN                                                         
        CALL cl_wcchp(tm.wc,'imm01,imm02,immuser')                            
             RETURNING tm.wc                                                      
#        LET g_str = g_str,";",tm.wc    #No.FUN-860026
        LET l_string = tm.wc     #No.FUN-860026
     END IF
###GENGRE###     LET g_str = g_str,";",l_string,";",tm.c   #No.FUN-860026
   # CALL cl_prt_cs3('aimg512',l_sql,g_str)    #TQC-730088
###GENGRE###     CALL cl_prt_cs3('aimg512','aimg512',l_sql,g_str) 
    LET g_cr_table = l_table                   #主報表的temp table名稱          #FUN-C40019 add
    LET g_cr_apr_key_f = "imm01"               #報表主鍵欄位名稱，用"|"隔開     #FUN-C40019 add
    CALL aimg512_grdata()    ###GENGRE###
     #FUN-710084  --end
END FUNCTION
 
REPORT g512_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_imn0456     LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(46)
          l_imn1567     LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(46)
          sr            RECORD order1  LIKE imm_file.imm01,#No.FUN-690026 VARCHAR(20)
                               order2  LIKE imm_file.imm01,#No.FUN-690026 VARCHAR(20)
                               order3  LIKE imm_file.imm01,#No.FUN-690026 VARCHAR(20)
                               imm01   LIKE imm_file.imm01,
                               imm02   LIKE imm_file.imm02,
                               imm04   LIKE imm_file.imm04,
                               imm07   LIKE imm_file.imm07,
                               imm09   LIKE imm_file.imm09,
                               imm11   LIKE imm_file.imm11,  #bugno:6810 add
                               imm12   LIKE imm_file.imm12,  #bugno:6810 add
                               imm13   LIKE imm_file.imm13,  #bugno:6810 add
                               immuser LIKE imm_file.immuser,
                               gen02   LIKE gen_file.gen02,
                               imn02   LIKE imn_file.imn02,
                               imn03   LIKE imn_file.imn03,
                               ima02   LIKE ima_file.ima02,
                               ima021  like ima_file.ima021,
                               imn04   LIKE imn_file.imn04,
                               imn05   LIKE imn_file.imn05,
                               imn06   LIKE imn_file.imn06,
                               imn07   LIKE imn_file.imn07,
                               imn08   LIKE imn_file.imn08,
                               imn09   LIKE imn_file.imn09,
                               imn10   LIKE imn_file.imn10,
                               imn15   LIKE imn_file.imn15,
                               imn16   LIKE imn_file.imn16,
                               imn17   LIKE imn_file.imn17,
                               imn18   LIKE imn_file.imn18,
                               imn19   LIKE imn_file.imn19,
                               imn20   LIKE imn_file.imn20,
                               imn21   LIKE imn_file.imn21,
                               #No.FUN-580005 --start--
                               imn30   LIKE imn_file.imn30,
                               imn32   LIKE imn_file.imn32,
                               imn33   LIKE imn_file.imn33,
                               imn35   LIKE imn_file.imn35,
                               imn40   LIKE imn_file.imn40,
                               imn42   LIKE imn_file.imn42,
                               imn43   LIKE imn_file.imn43,
                               imn45   LIKE imn_file.imn45,
                               #No.FUN-580005 --end--
                               imn28   LIKE imn_file.imn28,
                               imn29   LIKE imn_file.imn29,   #No.FUN-5C0077
                               imn23   LIKE imn_file.imn23
                        END RECORD
   DEFINE l_str1        LIKE type_file.chr1000,#No.FUN-580005  #No.FUN-690026 VARCHAR(100)
          l_imn45       STRING,    #No.FUN-580005
          l_imn42       STRING     #No.FUN-580005
   DEFINE l_str2        LIKE type_file.chr1000,#No.FUN-580005  #No.FUN-690026 VARCHAR(100)
          l_imn35       STRING,    #No.FUN-580005
          l_imn32       STRING     #No.FUN-580005
   DEFINE l_ima906      LIKE ima_file.ima906           #FUN-580005
 
  OUTPUT TOP MARGIN 0
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN 6
         PAGE LENGTH g_page_line
  ORDER BY sr.imm01,sr.order1,sr.order2,sr.order3
  FORMAT
   PAGE HEADER
#No.TQC-6B0068 --begin
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED
#     PRINT
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_today,'  ',TIME,' ',
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#No.TQC-6B0068 --end
 
#     PRINT g_dash[1,g_len]
#     PRINT g_x[11] CLIPPED,sr.imm02
#     PRINT g_x[12] CLIPPED,sr.imm01
      PRINT g_x[22] CLIPPED,l_orderA[1] CLIPPED,                      #TQC-6A0088                                                   
                       '-',l_orderA[2] CLIPPED,'-',l_orderA[3] CLIPPED  #TQC-6A0088
      PRINT g_dash[1,g_len]
      IF g_argv2 = '2' THEN
         PRINT g_x[09] CLIPPED,sr.imm11,'   ',
               g_x[10] CLIPPED,sr.imm12,'   ',
               g_x[21] CLIPPED,sr.imm13,'   ',    #print 撥入人員
               COLUMN (g_len-40),g_x[14] CLIPPED,sr.imm09 CLIPPED
      ELSE
         PRINT g_x[11] CLIPPED,sr.imm01,'   ',
               g_x[13] CLIPPED,sr.imm02,'   ',
               COLUMN 45,g_x[14] CLIPPED,sr.imm09 CLIPPED
      END IF
      IF sr.imm07 > 0 THEN
         PRINT g_x[12] CLIPPED
      ELSE
         PRINT
      END IF
      PRINT g_dash[1,g_len]
#No.FUN-560069 --start--
 
     #FUN-5A0138-begin
     #PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
     #PRINTX name=H2 g_x[38],g_x[39]
      PRINTX name=H1 g_x[31],g_x[34],g_x[35],g_x[36],g_x[42]    #No.FUN-5C0077
      PRINTX name=H2 g_x[38],g_x[32]
      PRINTX name=H3 g_x[33],g_x[41]
     #FUN-5A0138-end
      PRINT g_dash1
#No.FUN-560069 ---end--
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.imm01
      SKIP TO TOP OF PAGE
 
#No.FUN-550029-begin
   ON EVERY ROW     #每一項次列印
      LET l_imn0456=sr.imn04 CLIPPED,'/',sr.imn05 CLIPPED,'/',sr.imn06 CLIPPED
      LET l_imn1567=sr.imn15 CLIPPED,'/',sr.imn16 CLIPPED,'/',sr.imn17 CLIPPED
      SELECT azf03 INTO g_buf FROM azf_file WHERE azf01=sr.imn28 AND azf02='2' #6808
      IF STATUS THEN LET g_buf='' END IF
      SELECT ima906 INTO l_ima906 FROM ima_file
                          WHERE ima01 = sr.imn03
      LET l_str1 = ""
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         IF NOT cl_null(sr.imn45) AND sr.imn45 <> 0 THEN
            CALL cl_remove_zero(sr.imn45) RETURNING l_imn45
            LET l_str1 = l_imn45, sr.imn43 CLIPPED
         END IF
         IF NOT cl_null(sr.imn35) AND sr.imn35 <> 0 THEN
            CALL cl_remove_zero(sr.imn35) RETURNING l_imn35
            LET l_str2 = l_imn35, sr.imn33 CLIPPED
         END IF
         IF l_ima906 = "2" THEN
            IF cl_null(sr.imn45) OR sr.imn45 = 0 THEN
               CALL cl_remove_zero(sr.imn42) RETURNING l_imn42
               LET l_str1 = l_imn42, sr.imn40 CLIPPED
            ELSE
               IF NOT cl_null(sr.imn42) AND sr.imn42 <> 0 THEN
                  CALL cl_remove_zero(sr.imn42) RETURNING l_imn42
                  LET l_str1 = l_str1 CLIPPED,',',l_imn42, sr.imn40 CLIPPED
               END IF
            END IF
            IF cl_null(sr.imn35) OR sr.imn35 = 0 THEN
               CALL cl_remove_zero(sr.imn32) RETURNING l_imn32
               LET l_str2 = l_imn32, sr.imn30 CLIPPED
            ELSE
               IF NOT cl_null(sr.imn32) AND sr.imn32 <> 0 THEN
                  CALL cl_remove_zero(sr.imn32) RETURNING l_imn32
                  LET l_str2 = l_str2 CLIPPED,',',l_imn32, sr.imn30 CLIPPED
               END IF
            END IF
         END IF
      END IF
     #FUN-5A0138-begin
      #PRINTX name=D1 COLUMN g_c[31], sr.imn02 USING '##&',
      #               COLUMN g_c[32], sr.imn03 CLIPPED, #MOD-590294
      #               COLUMN g_c[33], g_x[18] CLIPPED,
      #               COLUMN g_c[34], l_imn0456 CLIPPED,
      #               COLUMN g_c[35], sr.imn09 CLIPPED,
      #               COLUMN g_c[36], cl_numfor(sr.imn10,36,3),
      #               COLUMN g_c[37], l_str2 CLIPPED
      #PRINTX name=D1 COLUMN g_c[31], ' ',
      #               COLUMN g_c[32], sr.ima02 CLIPPED,
      #               COLUMN g_c[33], g_x[19] CLIPPED,
      #               COLUMN g_c[34], l_imn1567 CLIPPED,
      #               COLUMN g_c[35], sr.imn20 CLIPPED,
      #               COLUMN g_c[36], ' ',
      #               COLUMN g_c[37], l_str1 CLIPPED
      #PRINTX name=D2 COLUMN g_c[38], ' ',
      #               COLUMN g_c[39], g_x[20] CLIPPED,' ',sr.imn28,g_buf CLIPPED
      PRINTX name=D1 COLUMN g_c[31], sr.imn02 USING '###&', #FUN-590118
                     COLUMN g_c[34], g_x[18] CLIPPED,' ',l_imn0456 CLIPPED,
                     COLUMN g_c[35], sr.imn09 CLIPPED,
                     COLUMN g_c[36], cl_numfor(sr.imn10,36,3),
                     COLUMN g_c[42], sr.imn29 CLIPPED      #No.FUN-5C0077
      PRINTX name=D1 COLUMN g_c[31], ' ',
                     COLUMN g_c[34], g_x[19] CLIPPED,' ',l_imn1567 CLIPPED,
                     COLUMN g_c[35], sr.imn20 CLIPPED,
                     COLUMN g_c[36], ' '
      PRINTX name=D2 COLUMN g_c[32], sr.imn03
      PRINTX name=D3 COLUMN g_c[41], sr.ima02
      IF NOT cl_null(sr.imn28) THEN
         PRINTX name=D3
               COLUMN g_c[41], g_x[20] CLIPPED,' ',sr.imn28,g_buf CLIPPED
      END IF
      IF NOT cl_null(l_str1) THEN
          PRINTX name=D3 COLUMN g_c[41],g_x[37] CLIPPED,l_str1
      END IF
      PRINT ' '
     #FUN-5A0138
#No.FUN-560069 ---end--
   ON LAST ROW
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      PRINT g_dash[1,g_len]
     # PRINT g_x[4],g_x[5] CLIPPED, sr.gen02
     # PRINT g_x[4] CLIPPED #No.TQC-5C0005
      IF l_last_sw = 'n' THEN     #add  TQC-6A0088                                                                                  
          PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED  #TQC-6A0088                                                       
      ELSE                                                                                                                          
          PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED  #TQC-6A0088                                                       
      END IF  #TQC-6A0088
      PRINT ''
      IF l_last_sw = 'n' THEN
         IF g_memo_pagetrailer THEN
             PRINT g_x[5]     
             PRINT g_memo
       #     PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #No.TQC-5C0005    #TQC-6A0088
         ELSE
             PRINT
             PRINT
       #     PRINT
         END IF
      ELSE
             PRINT g_x[5]      
             PRINT g_memo
       #     PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.TQC-5C0005   #TQC-6A0088
      END IF
## END FUN-550108
 
END REPORT
#Patch....NO.TQC-610036 <> #

###GENGRE###START
FUNCTION aimg512_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    LOCATE sr1.sign_img IN MEMORY   #FUN-C40019
    CALL cl_gre_init_apr()          #FUN-C40019
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aimg512")
        IF handler IS NOT NULL THEN
            START REPORT aimg512_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY order1,order2,order3,imn02"                    #FUN-B50018  add 
            DECLARE aimg512_datacur1 CURSOR FROM l_sql
            FOREACH aimg512_datacur1 INTO sr1.*
                OUTPUT TO REPORT aimg512_rep(sr1.*)
            END FOREACH
            FINISH REPORT aimg512_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aimg512_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B50018----add-----str-----------------
    DEFINE  l_flag              LIKE imm_file.imm01
    DEFINE  l_imn04_imn05_imn06 STRING
    DEFINE  l_imn15_imn16_imn17 STRING
    DEFINE  l_imn28_azf03       STRING
    DEFINE  l_order1            STRING
    DEFINE  l_imm02             STRING 
    DEFINE  l_order2            STRING
    DEFINE  l_order3            STRING
    DEFINE  l_group1            STRING
    DEFINE  l_group2            STRING
    DEFINE  l_group3            STRING
    DEFINE  l_display1          LIKE type_file.chr1
    DEFINE  l_display2          LIKE type_file.chr1 
    DEFINE  l_display3          LIKE type_file.chr1
    DEFINE  l_display4          LIKE type_file.chr1 
    DEFINE  l_display5          LIKE type_file.chr1 #DEV-D30030
    DEFINE  l_sql               STRING
    DEFINE  l_flag1             LIKE type_file.num5
    #FUN-B50018----add-----end-----------------
    
#    ORDER EXTERNAL BY sr1.imm01           #FUN-B50018 mark
    ORDER EXTERNAL By sr1.order1,sr1.order2,sr1.order3,sr1.imm01     #FUN-B50018 add
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
            #DEV-D30030--begin
            IF g_aza.aza131 = 'Y' THEN
               LET l_display5 = 'Y'
            ELSE
               LET l_display5 = 'N'
            END IF
            PRINTX l_display5
            #DEV-D30030--end
              
#        BEFORE GROUP OF sr1.imm01         #FUN-B50018 mark
#            LET l_lineno = 0              #FUN-B50018 mark

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-B50018----add-----str-----------------
            LET l_sql = "SELECT MAX(flag) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " WHERE imm01='",sr1.imm01 CLIPPED,"'"
            PREPARE l_prep1 FROM l_sql
            EXECUTE l_prep1 INTO l_flag1
            PRINTX l_flag1
            IF g_sma.sma115 = 'N' OR cl_null(sr1.l_str) THEN
               LET l_display4 = 'N'
            ELSE
               LET l_display4 = 'Y'
            END IF
            PRINTX l_display4
            IF  sr1.flag > sr1.imm01 THEN
                LET  l_flag = sr1.flag
            ELSE
                LET  l_flag = sr1.imm01
            END IF
            PRINTX  l_flag

            LET  l_imn04_imn05_imn06 = '(',sr1.imn04,'/',sr1.imn05,'/',sr1.imn06,')'
            PRINTX  l_imn04_imn05_imn06

            LET  l_imn15_imn16_imn17 = '(',sr1.imn15,'/',sr1.imn16,'/',sr1.imn17,')'
            PRINTX  l_imn15_imn16_imn17

            LET  l_imn28_azf03 = sr1.imn28,' ',sr1.azf03
            PRINTX  l_imn28_azf03

            LET l_imm02 = sr1.imm02 USING 'yyyymmdd'
            IF tm.s[1,1] ='1'THEN
               LET  l_order1 = sr1.imm01
            ELSE
                IF tm.s[1,1] ='2' THEN
                   LET  l_order1 = l_imm02
                ELSE
                   IF  tm.s[1,1] ='3' THEN
                       LET  l_order1 = sr1.immuser
                   ELSE
                       LET  l_order1 = '-'
                   END IF
                END IF
            END IF
            PRINTX  l_order1
            
            IF tm.s[2,2] ='1'THEN
               LET  l_order2 = sr1.imm01
            ELSE
                IF tm.s[2,2] ='2' THEN
                   LET  l_order2 = l_imm02
                ELSE
                    IF  tm.s[2,2] ='2' THEN
                        LET  l_order2 = sr1.immuser
                    ELSE
                        LET  l_order2 = '-'
                    END IF
                END IF
            END IF
            PRINTX  l_order2
                   
            IF tm.s[3,3] ='1'THEN
               LET  l_order3 = sr1.imm01
            ELSE
                IF tm.s[3,3] ='2' THEN
                   LET  l_order3 = l_imm02
                ELSE
                    IF  tm.s[3,3] ='3' THEN
                        LET  l_order3 = sr1.immuser
                    ELSE
                        LET  l_order3 = '-'
                    END IF
                END IF
            END IF
            PRINTX  l_order3

            IF NOT cl_null(tm.s[1,1]) THEN 
               LET l_group1 = cl_gr_getmsg("gre-002",g_lang,tm.s[1,1])
               LET l_group1 = l_group1," -"    #FUN-C20080  "-"  改成 " -"
            ELSE          
               LET l_group1 = ' '
            END IF
            PRINTX  l_group1

            IF NOT cl_null(tm.s[2,2]) THEN 
               LET l_group2 = cl_gr_getmsg("gre-002",g_lang,tm.s[2,2])
               LET l_group2 = l_group2," -"     #FUN-C20080  "-"  改成 " -
            ELSE      
               LET l_group2 = ' '
            END IF
            PRINTX  l_group2

            IF NOT cl_null(tm.s[3,3]) THEN 
               LET l_group3 = cl_gr_getmsg("gre-002",g_lang,tm.s[3,3])
#FUN-C30085--mod---str-
#              LET l_group3 = l_group3," -"      #FUN-C20080  "-"  改成 " -
#           ELSE         
#              LET l_group3 = ' '
#FUN-C30085--mod---end-
            END IF
            PRINTX  l_group3

            IF cl_null(sr1.imn28) AND g_sma115 = 'N' THEN
               LET l_display1 = 'N'
            ELSE
               LET l_display1 = 'Y'
            END IF
            PRINTX l_display1 
            #FUN-B50018----add-----end-----------------
            PRINTX sr1.*

        AFTER GROUP OF sr1.imm01
            #FUN-B50018----add-----str-----------------
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE rvbs01 = '",sr1.imm01 CLIPPED,"' AND rvbs09 = -1 ",
                        " ORDER BY rvbs02"
            START REPORT aimg512_subrep01
            DECLARE aimg512_repcur1 CURSOR FROM l_sql
            FOREACH aimg512_repcur1 INTO sr2.*
                OUTPUT TO REPORT aimg512_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT aimg512_subrep01
            #FUN-B50018----add-----end-----------------
        ON LAST ROW

END REPORT

#FUN-B50018----add-----str-----------------
REPORT aimg512_subrep01(sr2)
    DEFINE sr2 sr2_t
    DEFINE l_display  STRING
    DEFINE l_RTotal0 LIKE rvbs_file.rvbs06

    ORDER EXTERNAL BY sr2.rvbs02


    FORMAT
        ON EVERY ROW
       
            IF sr2.rvbs09= -1 THEN      #FUN-C10036 del ''
               LET l_display ='Y'
            ELSE
               LET l_display ='N'
            END IF
            PRINTX l_display

            PRINTX sr2.*

        AFTER GROUP OF sr2.rvbs02
            LET l_RTotal0 = GROUP SUM(sr2.rvbs06)
            PRINTX l_RTotal0
END REPORT
#FUN-B50018----add-----end-----------------
###GENGRE###END
