# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: asfr100.4gl
# Descriptions...: 工單用料可用數量列印
# Date & Author..: 92/07/08 By Lin
# Modify.........: 92/11/18 By Keith
# Modify.........: No.FUN-550112 05/05/27 By ching 特性BOM功能修改
# Modify.........: No.FUN-590110 05/09/27 By yoyo  報表修改
# Modfy..........: NO.FUN-5B0015 05/11/01 by Yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modfy..........: NO.TQC-5B0023 05/11/08 by kim 報表表頭品名往下移
# Modify.........: No.TQC-5B0053 05/11/09 By Pengu 1.TEMP TABLE ttp_file 中的單據編號只有10碼，應改成16碼否則
                             #                       當單據好超過10碼時程式會當掉
# Modify.........: No.TQC-5B0106 05/11/12 By Dido 表頭料件編號後面欄位調整
# Modify.........: No.FUN-5A0061 05/11/21 By Pengu 報表缺規格
# Modify.........: No.MOD-620074 06/02/24 By Claire 列印第二次不結束程式,資料會重複
# Modify.........: No.TQC-650066 06/05/16 By Claire ima79 mark
# Modify.........: No.FUN-660128 06/06/28 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-670041 06/08/10 By Pengu 將sma29 [虛擬產品結構展開與否] 改為 no use
# Modify.........: No.FUN-680121 06/09/04 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/10/30 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: NO.FUN-710081 07/02/02 By yoyo   crystal report
# Modify.........: NO.TQC-730113 07/04/05 By Nicole 增加CR參數
# Modify.........: NO.TQC-7B0071 07/11/13 By Rayven 下階個數太大,不能打印
# Modify.........: NO.TQC-7B0143 07/11/27 By Mandy FUNCTION cralc_bom名在$SUB/s_cralc.4gl內也有相同的FUNCTION 名,所以更名為r100_cralc_bom,否則r.l2不會過
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910  
# Modify.........: No.FUN-940008 09/05/09 By hongmei 發料改善
# Modify.........: No.FUN-940083 09/05/15 By mike 原可收量計算(pmn20-pmn50+pmn55)全部改為(pmn20-pmn50+pmn55+pmn58)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9A0068 09/10/23 by dxfwo VMI测试结果反馈及相关调整
# Modify.........: No:TQC-A30071 10/03/15 By lilingyu 勾選"僅列印不足的料件"時,仍是所有的工單都列印出來 
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:MOD-A30009 10/03/30 By Summer 抓取有欠料的工單時應抓取類別是7.入庫的工單,否則會漏掉部份入庫但是有欠料的工單
# Modify.........: No:TQC-A60097 10/05/27 By Carrier 取消原程序行尾的control-m & CR报表数据库来源改写标准
# Modify.........: No.FUN-A60027 10/06/09 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.TQC-A60097 10/06/22 By liuxqa  TQC-A60097拆单过来，不做修改，过单用
# Modify.........: No:FUN-A70034 10/07/19 By Carrier 平行工艺-分量损耗运用
# Modify.........: No:MOD-AC0291 10/12/24 By sabrina 在外量、在撿量、欠料量型態給錯
# Modify.........: No:TQC-BA0039 11/10/10 By houlia l_edate取值調整
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.CHI-D30014 13/04/02 By bart 增加工單QBE
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc    STRING,  #CHI-D30014
              a     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)# 是否包含需求資料
              b     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)# 是否包含確認生產工單
              c     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)# 是否包含在製工單
              d     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)#是否列印大宗料件
              e     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)# 是否僅列印不足的料件
              f     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)# 是否考慮損耗
              e_date LIKE type_file.dat,          # 截止日期        #No.FUN-680121 DATE
                 more    LIKE type_file.chr1      #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
              END RECORD,
          g_count   LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          g_sql      string,                      #No.FUN-580092 HCN
          g_utime   LIKE type_file.chr8,          #No.FUN-680121 VARCHAR(08)# user run time # TQC-6A0079
          g_sfb01   LIKE  sfb_file.sfb01,   #工單號碼
          g_sfb08   LIKE  sfb_file.sfb08,   #工單數量
          g_sfb13   LIKE  sfb_file.sfb13,   #預計開工日期
          g_ima781,g_ima782 LIKE qdb_file.qdb07       #No.FUN-680121 DEC(12,2)
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680121 SMALLINT
#No.FUN-710081--start
DEFINE   l_table         STRING
DEFINE   l_str           STRING
#No.FUN-710081--end
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
 
 
   LET g_count = 1
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)  #CHI-D30014
   LET tm.a = ARG_VAL(8)
   LET tm.b = ARG_VAL(9)
   LET tm.c = ARG_VAL(10)
   LET tm.d = ARG_VAL(11)
   LET tm.e = ARG_VAL(12)
   LET tm.f = ARG_VAL(13)
   LET tm.e_date = ARG_VAL(14)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   LET g_utime=TIME 
   
#NO.FUN-71081--start
   LET g_sql = "sfb01.sfb_file.sfb01,",
               "  bdate.type_file.chr20,",
               "  sfb05.sfb_file.sfb05,",
               "  ima05.ima_file.ima05,",
               "  ima08.ima_file.ima08,",
               "  sfb04.sfb_file.sfb04,",
               "  edate.type_file.chr20,",
               "  ima02.ima_file.ima02,",
               "  ima021.ima_file.ima02,",
               "  ndate.type_file.chr20,",
               "  ima55.ima_file.ima55,",
               "  sfb083.sfb_file.sfb08,",
               "  sfb051.sfb_file.sfb05,",
               "  ima25.ima_file.ima25,",
               "  sfb08.sfb_file.sfb08,",
               "  ima84.ima_file.ima84,",
               "  sfb081.sfb_file.sfb08,",
               "  sfb082.sfb_file.sfb08,",
#              "  ima262.ima_file.ima262,",
#              "  ima261.ima_file.ima261,",
               "  avl_stk.type_file.num15_3,",
               "  unavl_stk.type_file.num15_3,",
              #MOD-AC0291---modify---start---
              #"  sfa03.sfa_file.sfa03,",
              #"  sfa031.sfa_file.sfa03,",
              #"  sfa032.sfa_file.sfa03,",
               "  qty1.sfa_file.sfa07,",
               "  qty2.sfa_file.sfa07,",
               "  qty3.sfa_file.sfa07,",
              #MOD-AC0291---modify---end---
               "  ima02t.ima_file.ima02,",
               "  ima021t.ima_file.ima021,",
               "  min.sfb_file.sfb08,",
               "  ttp04.sfb_file.sfb08"
   LET l_table = cl_prt_temptable('asfr100',g_sql) CLIPPED
   IF l_table = -1 THEN
      EXIT PROGRAM 
   END IF
   #No.TQC-A60097  --Begin
  #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED," VALUES(?,?,?,?,?,?,?,?,?,?,",
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED," VALUES(?,?,?,?,?,?,?,?,?,?,",
               " ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
   #No.TQC-A60097  --End  
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1)
      EXIT PROGRAM
   END IF
#No.FUN-710081--end
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r100_tm()                # Input print condition
      ELSE
           CALL asfr100()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r100_tm()
   DEFINE p_row,p_col  LIKE type_file.num5           #No.FUN-680121 SMALLINT
   DEFINE l_cmd        LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(400)
          l_flag    LIKE type_file.chr1              #No.FUN-680121 VARCHAR(1)
 
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW r100_w AT p_row,p_col
        WITH FORM "asf/42f/asfr100"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.a='N'
   LET tm.b='Y'
   LET tm.c='Y'
   LET tm.d='N'
   LET tm.e='N'
   LET tm.f='Y'
   LET tm.e_date=g_today
   WHILE TRUE
      DISPLAY BY NAME tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,
              tm.e_date,tm.more   # Condition
      #CHI-D30014---begin
      CONSTRUCT BY NAME tm.wc ON sfb01
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION locale
            CALL cl_show_fld_cont()     
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         
            CALL cl_about()     
 
         ON ACTION help          
            CALL cl_show_help()  
 
         ON ACTION controlg      
            CALL cl_cmdask()    
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(sfb01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form    = "q_sfb902"
                  LET g_qryparam.state   = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb01
                  NEXT FIELD sfb01

            END CASE
 
         ON ACTION EXIT
            LET INT_FLAG = 1
            EXIT CONSTRUCT

         ON ACTION qbe_select
            CALL cl_qbe_select()
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
      #CHI-D30014---end
      INPUT BY NAME tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.e_date,tm.more
                      WITHOUT DEFAULTS
           ON ACTION locale
               LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
               EXIT INPUT
 
           AFTER FIELD a
              IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
                 NEXT FIELD a
              END IF
 
           AFTER FIELD b
              IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
                 NEXT FIELD b
              END IF
 
           AFTER FIELD c
              IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN
                 NEXT FIELD c
              END IF
 
           AFTER FIELD d
              IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN
                 NEXT FIELD d
              END IF
 
           AFTER FIELD e
              IF cl_null(tm.e) OR tm.e NOT MATCHES '[YN]' THEN
                 NEXT FIELD e
              END IF
 
           AFTER FIELD f
              IF cl_null(tm.f) OR tm.f NOT MATCHES '[YN]' THEN
                 NEXT FIELD f
              END IF
 
           AFTER FIELD e_date
              IF cl_null(tm.e_date) THEN
                 NEXT FIELD e_date
              END IF
 
           AFTER FIELD more
              IF cl_null(tm.more) OR tm.more NOT MATCHES '[YN]' THEN
                NEXT FIELD more
              END IF
              IF tm.more = 'Y' THEN
                 CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                 RETURNING g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies
              END IF
           AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
              LET l_flag='N'
              IF INT_FLAG THEN
                  EXIT INPUT
              END IF
              IF tm.a IS NULL THEN
                 LET l_flag='Y'
                 DISPLAY BY NAME tm.a
              END IF
              IF tm.b IS NULL THEN
                 LET l_flag='Y'
                 DISPLAY BY NAME tm.b
              END IF
              IF tm.c IS NULL THEN
                 LET l_flag='Y'
                 DISPLAY BY NAME tm.c
              END IF
              IF tm.d IS NULL THEN
                 LET l_flag='Y'
                 DISPLAY BY NAME tm.d
              END IF
              IF tm.e IS NULL THEN
                 LET l_flag='Y'
                 DISPLAY BY NAME tm.e
              END IF
              IF tm.f IS NULL THEN
                 LET l_flag='Y'
                 DISPLAY BY NAME tm.f
              END IF
              IF tm.e_date IS NULL THEN
                 LET l_flag='Y'
                 DISPLAY BY NAME tm.e_date
              END IF
              IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD a
              END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='asfr100'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('asfr100','9031',1)   
         ELSE
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,  #CHI-D30014
                         " '",tm.a CLIPPED,"'" ,
                         " '",tm.b CLIPPED,"'" ,
                         " '",tm.c CLIPPED,"'" ,
                         " '",tm.d CLIPPED,"'" ,
                         " '",tm.e CLIPPED,"'" ,
                         " '",tm.f CLIPPED,"'" ,
                         " '",tm.e_date CLIPPED,"'"  ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('asfr100',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW r100_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL asfr100()
      ERROR ""
   END WHILE
   CLOSE WINDOW r100_w
END FUNCTION
 
FUNCTION asfr100()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
         #l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1100)   #CHI-D30014 mark
          l_sql     STRING,                       #CHI-D30014 add
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_cnt     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_n       LIKE type_file.num5,          #No.FUN-680121 SMALLINT
#         l_sw1     LIKE ima_file.ima26,          #No.FUN-680121 DECIMAL(12,3)# 判斷資料是工單或需求檔而來
          l_sw1     LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044 
          l_qty     LIKE sfb_file.sfb08,
          l_rpc01   LIKE rpc_file.rpc01,  #料件編號
          l_rpc12   LIKE rpc_file.rpc12,  #需求日期
          l_rpc13   LIKE rpc_file.rpc13,  #需求數量
          sr1       RECORD
                    sfb01 LIKE sfb_file.sfb01,  #工單編號
                    sfb02 LIKE sfb_file.sfb02,  #工單型態
                    sfb04 LIKE sfb_file.sfb04,  #工單狀態
                    sfb05 LIKE sfb_file.sfb05,  #料件編號
                    sfb08 LIKE sfb_file.sfb08,  #生產數量
                    sfb09 LIKE sfb_file.sfb09,  #完工數量
                    sfb10 LIKE sfb_file.sfb10,  #再加工數量
                    sfb11 LIKE sfb_file.sfb11,  #F.Q.C數量
                    sfb12 LIKE sfb_file.sfb12,  #報廢數量
                    sfb13 LIKE sfb_file.sfb13,  #開始生產日期
                    sfb23 LIKE sfb_file.sfb23   #備料檔產生否
                    END RECORD ,
          sr        RECORD
                    ttp01     LIKE sfb_file.sfb05,   #料件編號
                    ttp02     LIKE sfb_file.sfb01,   #工單編號
                    ttp03     LIKE sfb_file.sfb13,   #預計工單日
                    ttp04     LIKE sfb_file.sfb08,   #工單數量
                    ttp05     LIKE sfb_file.sfb08,   #需求數量
                    ttp06     LIKE sfb_file.sfb08,   #未供給需求數量前之可用
                    ttp07     LIKE sfb_file.sfb08,   #預期缺料量
                    ima25     LIKE ima_file.ima25,   #庫存單位
                    ima84     LIKE oeb_file.oeb12,   #No.FUN-680121 DEC(9,2)#OM備置量
#                   ima261    LIKE ima_file.ima261,  #庫存不可用量
#                   ima262    LIKE ima_file.ima262,  #庫存可用量
                    unavl_stk LIKE type_file.num15_3,###GP5.2  #NO.FUN-A20044
                    avl_stk   LIKE type_file.num15_3,###GP5.2  #NO.FUN-A20044 
                   #MOD-AC0291---modify---start---
                   #qty1      LIKE sfa_file.sfa03,   #在外量
                   #qty2      LIKE sfa_file.sfa03,   #在驗量
                   #qty3      LIKE sfa_file.sfa03    #缺料量
                    qty1      LIKE sfa_file.sfa07,   #在外量
                    qty2      LIKE sfa_file.sfa07,   #在驗量
                    qty3      LIKE sfa_file.sfa07    #缺料量
                   #MOD-AC0291---modify---end---
                    END RECORD ,
         #MOD-AC0291---modify---start---
         #l_qty11  LIKE sfa_file.sfa03,
         #l_qty21  LIKE sfa_file.sfa03,
         #l_qty22  LIKE sfa_file.sfa03,
          l_qty11  LIKE sfa_file.sfa07,
          l_qty21  LIKE sfa_file.sfa07,
          l_qty22  LIKE sfa_file.sfa07,
         #MOD-AC0291---modify---end---
#         up_qty   LIKE ima_file.ima262,      #上筆可用數量
#         up_need  LIKE ima_file.ima262,      #上筆缺料數量
          up_qty   LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
          up_need  LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
          l_ima01  LIKE ima_file.ima01        #上筆料件編號
   DEFINE l_ima910   LIKE ima_file.ima910   #FUN-550112
#NO.FUN-710081--start
   DEFINE l_bdate    LIKE type_file.chr20
   DEFINE l_edate    LIKE type_file.chr20
   DEFINE l_ndate    LIKE type_file.chr20
   DEFINE l_ima02t   LIKE ima_file.ima02
   DEFINE l_ima021t  LIKE ima_file.ima021
   DEFINE i          LIKE type_file.num5
   DEFINE l_num      LIKE sfb_file.sfb08         
   DEFINE l_min      LIKE sfb_file.sfb08 
   DEFINE l_sfb14    LIKE sfb_file.sfb14
   DEFINE l_sfb15    LIKE sfb_file.sfb15
   DEFINE l_sfb16    LIKE sfb_file.sfb16  
   DEFINE l_sfb20    LIKE sfb_file.sfb20   
   DEFINE l_sfb21    LIKE sfb_file.sfb21 
   DEFINE l_sfb04    LIKE sfb_file.sfb04
   DEFINE l_sfb05    LIKE sfb_file.sfb05
   DEFINE l_ima02    LIKE ima_file.ima02
   DEFINE l_ima021   LIKE ima_file.ima021
   DEFINE l_ima05    LIKE ima_file.ima05
   DEFINE l_ima08    LIKE ima_file.ima08 
   DEFINE l_ima55    LIKE ima_file.ima55   
   DEFINE l_sfb08    LIKE sfb_file.sfb08   
#No.FUN-710081--end
#No.FUN-940008--Begin add
   DEFINE lr_sfa RECORD LIKE sfa_file.*
   DEFINE l_short_qty   LIKE sfa_file.sfa07
#No.FUN-940008--End
   DEFINE  l_n1         LIKE type_file.num15_3              ###GP5.2  #NO.FUN-A20044
   DEFINE  l_n2         LIKE type_file.num15_3              ###GP5.2  #NO.FUN-A20044
   DEFINE  l_n3         LIKE type_file.num15_3              ###GP5.2  #NO.FUN-A20044 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
      DROP TABLE ttp_file           #MOD-620074
 #No.FUN-680121-BEGIN  
   CREATE TEMP TABLE ttp_file(
      ttp01 LIKE sfb_file.sfb05,
      ttp02 LIKE sfb_file.sfb01,
      ttp03 LIKE sfb_file.sfb13,
      ttp04 LIKE sfb_file.sfb08,
      ttp05 LIKE sfb_file.sfb08,
      ttp06 LIKE sfb_file.sfb08,
      ttp07 LIKE sfb_file.sfb08);
 #No.FUN-680121-END     
     CREATE  index ttp_01 ON ttp_file(ttp02,ttp01);
 
 
     LET l_sql = "SELECT sfb01,sfb02,sfb04,sfb05,sfb08,",
                 "  sfb09,sfb10,sfb11,sfb12,sfb13,sfb23 ",
                 "  FROM sfb_file ",
                 " WHERE sfb13 <='",tm.e_date,"' ",
                 "   AND sfbacti='Y' AND sfb04 !='8' ",
                 "   AND sfb08 > sfb09+sfb10+sfb11+sfb12 ",
                 "   AND " ,tm.wc CLIPPED  #CHI-D30014
     IF tm.b='Y' THEN    #包含 1.確認生產工單
        IF tm.c='Y' THEN    #包含 4/5.在製工單
            LET l_sql=l_sql CLIPPED," AND sfb04 IN ('1','2','3','4','5','7') "  #MOD-A30009 add 7
        ELSE
            LET l_sql=l_sql CLIPPED," AND sfb04 IN ('1','2','3','7') "          #MOD-A30009 add 7
        END IF
     ELSE
        IF tm.c='Y' THEN    #包含 4/5.在製工單
            LET l_sql=l_sql CLIPPED," AND sfb04 IN ('2','3','4','5','7') "      #MOD-A30009 add 7
        ELSE
            LET l_sql=l_sql CLIPPED," AND sfb04 IN ('2','3','7') "              #MOD-A30009 add 7
        END IF
     END IF
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET l_sql= l_sql clipped," AND sfbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET l_sql= l_sql clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET l_sql= l_sql clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET l_sql = l_sql CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
    #End:FUN-980030
 
 
     LET l_sql=l_sql CLIPPED," ORDER BY sfb08 "
     PREPARE r100_prepare1 FROM l_sql
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('prepare1:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
          EXIT PROGRAM
        END IF
     DECLARE r100_curs1 CURSOR FOR r100_prepare1
 
 
     LET g_cnt=0
     FOREACH r100_curs1 INTO sr1.*
       IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       LET g_sfb01=sr1.sfb01
       #若為在製工單,則工單數量=生產數量-已完工數量-再加工數量-F.Q.C數量
       #                        -報廢數量
       IF sr1.sfb04 MATCHES '[457]' THEN  #MOD-A30009 add 7
          LET g_sfb08=sr1.sfb08-sr1.sfb09-sr1.sfb10-sr1.sfb11-sr1.sfb12
       ELSE
          LET g_sfb08=sr1.sfb08
       END IF
       #生產數量<=0時,不考慮
       IF g_sfb08 <=0 THEN CONTINUE FOREACH END IF
       LET g_cnt=1
       LET g_sfb13=sr1.sfb13
       #工單性質為'5'再加工及'11'拆件式工的工單,無須至備料檔或產品結構
       #檔中去找其用料,只需將該工單的品號及其工單數量寫入暫存檔中即可.
       IF sr1.sfb02=5 OR sr1.sfb02=11 THEN
          #需求數量 <=0 時不考慮
          LET l_qty=sr1.sfb08-sr1.sfb09-sr1.sfb10-sr1.sfb11-sr1.sfb12
          IF l_qty > 0 THEN
             #insert 可用數量暫時代表資料來源 0:工單檔 -1:獨立需求檔
             INSERT INTO ttp_file
              VALUES(sr1.sfb05,sr1.sfb01,sr1.sfb13,g_sfb08,l_qty,0,0)
             IF SQLCA.sqlcode THEN
#               CALL cl_err(sr1.sfb01,SQLCA.sqlcode,1)   #No.FUN-660128
                CALL cl_err3("ins","ttp_file",sr1.sfb05,"",SQLCA.sqlcode,"","",1)   #No.FUN-660128
                CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
                EXIT PROGRAM
             END IF
          END IF
          CONTINUE FOREACH
       END IF
       #若已產生備料檔,則去抓取[備料檔]資料,否則從產品結構中取得用料資料
       IF sr1.sfb23='Y' THEN
          CALL r100_sfa(sr1.sfb01)
       ELSE
          #FUN-550112
          LET l_ima910=''
          SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=sr1.sfb05
          IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
          #--
          CALL r100_cralc_bom(0,sr1.sfb05,l_ima910,g_sfb08)  #FUN-550112 #TQC-7B0143
       END IF
     END FOREACH
     #若無合乎條件之工單,則列印 "無合乎條件的工單" 之訊息
     IF g_cnt=0 THEN
        CALL cl_err('','asf-318',3)
        CLOSE WINDOW r100_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
 
     #包含需求資料 -----------------
     IF tm.a='Y' THEN
        LET l_sql="SELECT rpc01,rpc12,(rpc13-rpc131)  ",
                  " FROM rpc_file ",
                  " WHERE rpc11 > 2 AND rpc12 <='",tm.e_date,"' ",
                  " AND rpc13>rpc131  AND rpcacti='Y' "
 
 
        PREPARE r100_prepare2 FROM l_sql
        IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare2:',SQLCA.sqlcode,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
                            EXIT PROGRAM END IF
        DECLARE r100_curs2 CURSOR FOR r100_prepare2
 
        FOREACH r100_curs2 INTO l_rpc01,l_rpc12,l_rpc13
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           #insert 可用數量暫時代表資料來源 0:工單檔 -1:獨立需求檔
           INSERT INTO ttp_file
                   VALUES(l_rpc01,' ',l_rpc12,0,l_rpc13,-1,0)
           IF SQLCA.sqlcode THEN
#             CALL cl_err(l_rpc01,SQLCA.sqlcode,1)   #No.FUN-660128
              CALL cl_err3("ins","ttp_file",l_rpc01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660128
              CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
              EXIT PROGRAM
           END IF
        END FOREACH
     END IF
 
     # order by 料件編號+預計開工日+工單編號
     LET l_sql=" SELECT ttp01,ttp02,ttp03,ttp04,ttp05,ttp06,ttp07,",
#              " ima25,0,ima261,ima262,0,0,0 ",   #NO.FUN-A20044
               " ima25,0,0,0,0,0,0 ",             #NO.FUN-A20044
               " FROM ttp_file,ima_file ",
               " WHERE ttp01=ima01 ",
               " ORDER BY ttp01,ttp04,ttp02,ttp03 "
 
     PREPARE r100_prepare3 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare3:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
     DECLARE r100_curs3 CURSOR FOR r100_prepare3
 
#No.FUN-710081--start
#     CALL cl_outnam('asfr100') RETURNING l_name
#     START REPORT r100_rep TO l_name
       CALL cl_del_data(l_table)
       LET l_n=0
#No.FUN-710081--end
 
 
     LET g_pageno = 0
     LET up_qty=0        #上筆可用數量
     LET up_need=0       #上筆缺料數量
     LET l_ima01=' '
     LET l_n=1
 
     FOREACH r100_curs3 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CALL s_getstock(sr.ttp01,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044 
       LET sr.unavl_stk = l_n2
       LET sr.avl_stk = l_n3 
       #----------------------------------- 00/10/24
       #--- 訂單備置量
      #SELECT SUM((oeb12-oeb24)*oeb05_fac) INTO sr.ima84
       SELECT SUM(oeb905*oeb05_fac) INTO sr.ima84         #no.7182
         FROM oeb_file, oea_file
        WHERE oeb04 = sr.ttp01
          AND oeb01 = oea01 AND oea00<>'0'
          AND oeb70 = 'N' AND oeb12 > oeb24 AND oeb19='Y'
          AND oeaconf != 'X' #01/08/08 mandy
       IF STATUS OR sr.ima84 IS NULL THEN LET sr.ima84=0 END IF
 
      #--- 在外量
      #SELECT SUM((pmn20-pmn50+pmn55)*pmn09) INTO sr.ima76
      #SELECT SUM((pmn20-pmn50+pmn55)*pmn09) INTO sr.qty1 #FUN-940083
       SELECT SUM((pmn20-pmn50+pmn55+pmn58)*pmn09) INTO sr.qty1 #FUN-940083       
         FROM pmn_file, pmm_file
        WHERE pmn04 = sr.ttp01 AND pmn01 = pmm01
#         AND pmn20 > (pmn50 -pmm55)         #No.FUN-9A0068 mark
          AND pmn20 > (pmn50 -pmn55-pmn58)   #No.FUN-9A0068
          AND pmn16 <= '2' AND pmn011!='SUB'
       IF STATUS OR sr.qty1 IS NULL THEN LET sr.qty1=0 END IF
 
      #No.B044 010326 by plum 需再減掉己收貨但未製入庫單且尚未確認,應算在IQC量
      # SELECT SUM((rvb07-rvb29-rvb30)*pmn09) INTO l_qty11
      #   FROM rvb_file, rva_file, pmn_file
      #  WHERE rvb05 = sr.ttp01 AND rvb01=rva01
      #    AND rvb04 = pmn01 AND rvb03 = pmn02
      #    AND rvb07 > (rvb29+rvb30) AND pmn011 !='SUB'
      #    AND rvaconf='N'
      # IF STATUS OR l_qty11 IS NULL THEN LET l_qty11=0 END IF
      # LET sr.qty1=sr.qty1 - l_qty11
 
       #--- 在驗量 : IQC+FQC
       #IQC
       SELECT SUM((rvb07-rvb29-rvb30)*pmn09) INTO l_qty21
         FROM rvb_file, rva_file, pmn_file
        WHERE rvb05 = sr.ttp01
          AND rvb01 = rva01
          AND rvaconf !='X'
          AND rvb04 = pmn01 AND rvb03 = pmn02
          AND rvb07 > (rvb29+rvb30)
       IF STATUS OR l_qty21 IS NULL THEN LET l_qty21=0 END IF
 
      #FQC
       SELECT SUM(sfb11) INTO l_qty22 FROM sfb_file
        WHERE sfb05 = sr.ttp01
          AND sfb02 <> '7'
          AND sfb04 <'8' AND sfb87!='X'
       IF STATUS OR l_qty22 IS NULL THEN LET l_qty22=0 END IF
       LET sr.qty2=l_qty21+l_qty22
      
      #FUN-940008---Begin
      #--- 欠料量
      #SELECT SUM(sfa07*sfa13) INTO sr.qty3 FROM sfa_file,sfb_file
      # WHERE sfa03 = sr.ttp01
      #   AND sfb01 = sfa01
      #   AND sfb04 !='8' AND sfa07 > 0 AND sfb87!='X'
      #IF cl_null(sr.qty3) THEN LET sr.qty3=0 END IF
      ##-----------------------------------
       IF cl_null(sr.qty3) THEN LET sr.qty3=0 END IF
       LET l_sql = "SELECT sfa_file.*",
                   "  FROM sfb_file,sfa_file",
                   " WHERE sfa03 = '",sr.ttp01,"'",
                   "   AND sfb01 = sfa01 ",
                   "   AND sfb04 !='8'",
                   "   AND sfb87 !='X'"        
       PREPARE r100_sum_pre FROM l_sql
       DECLARE r100_sum CURSOR FOR r100_sum_pre
       FOREACH r100_sum INTO lr_sfa.*
          CALL s_shortqty(lr_sfa.sfa01,lr_sfa.sfa03,lr_sfa.sfa08,
                          lr_sfa.sfa12,lr_sfa.sfa27,lr_sfa.sfa012,lr_sfa.sfa013)             #FUN-A60027 add afa012,sfa013
               RETURNING l_short_qty
       IF cl_null(l_short_qty) THEN LET l_short_qty = 0 END IF
       IF l_short_qty > 0 THEN
          LET sr.qty3 = sr.qty3 + (l_short_qty * lr_sfa.sfa13)
       END IF
       END FOREACH
      #FUN-940008---End 

#TQC-A30071 --begin--
       IF tm.e = 'Y' AND sr.qty3 <= 0 THEN 
          CONTINUE FOREACH 
       END IF 
#TQC-A30071 --end--
      
#      IF sr.ima262 IS NULL THEN LET sr.ima262=0 END IF
#      IF sr.ttp05  IS NULL THEN LET sr.ttp05 =0 END IF
       IF sr.unavl_stk IS NULL THEN LET sr.unavl_stk = 0 END IF   #NO.FUN-A20044
       IF sr.avl_stk IS NULL THEN LET sr.avl_stk = 0 END IF       #NO.FUN-A20044  
       LET l_sw1=sr.ttp06     # 判斷資料是工單(0)或需求檔(-1)而來
       IF l_ima01 != sr.ttp01 THEN     #料件編號不同時
          #最初之上筆可用數量=可用庫存量, 最初之上筆缺料量=料件主檔之缺料量
          #第一筆之可用數量=上筆可用數量-上筆缺料量
#         LET sr.ttp06=sr.ima262-sr.qty3
          LET sr.ttp06 = sr.avl_stk -sr.qty3
          IF sr.ttp06 < 0 THEN
             LET sr.ttp06=0
          END IF
          LET l_ima01=sr.ttp01
       ELSE
          #第二筆之可用數量＝第一筆之可用數量－第一筆需求數量,以此類推
          LET sr.ttp06=up_qty-up_need
          IF sr.ttp06 < 0 THEN LET sr.ttp06=0 END IF
       END IF
       #預期缺料量=需求數量-可用數量 (小於0,以0計)
       LET sr.ttp07=sr.ttp05-sr.ttp06
       IF sr.ttp07 < 0 THEN LET sr.ttp07=0 END IF
       LET up_qty=sr.ttp06
       LET up_need=sr.ttp05
       IF l_sw1=0 THEN
#No.FUN-710081--start
 
#No.TQC-7B0071 --start-- mark
#老寫法是用來控制行數的，新寫法用CR沒有這個必要
#          IF l_n >100 THEN 
#             CALL cl_err(sr.ttp01,'asf-319',1)
#             CLOSE WINDOW r100_w  
#             EXIT PROGRAM 
#          END IF
#No.TQC-7B0071 --end--
 
           LET l_num=(sr.ttp06/sr.ttp05)*sr.ttp04
           IF l_n=1 THEN
              LET l_min=l_num
           ELSE
              IF l_min > l_num THEN
                 LET l_min=l_num     
              END IF
           END IF 
           LET l_n = l_n+1
#TQC-BA0039  --mark
        #  LET l_bdate = sr.ttp03 CLIPPED,' ',l_sfb14 CLIPPED
        #  LET l_edate = l_sfb15 CLIPPED,' ',l_sfb16 CLIPPED
        #  LET l_ndate = l_sfb20 CLIPPED,' ',l_sfb21 CLIPPED
#TQC-BA0039  --end
           SELECT sfb04,sfb20,sfb21,sfb14,sfb15,sfb16,sfb05,
                  ima02,ima021,ima05,ima08,ima55,sfb08              #No.FUN-5A0061 add
             INTO l_sfb04,l_sfb20,l_sfb21,l_sfb14,l_sfb15,l_sfb16,
                  l_sfb05,l_ima02,l_ima021,l_ima05,l_ima08,l_ima55,l_sfb08    #No.FUN-5A0061 add
             FROM sfb_file,OUTER ima_file
            WHERE sfb05=ima_file.ima01 AND sfb01=sr.ttp02 AND sfb87!='X'  
           SELECT ima02,ima021 INTO l_ima02t,l_ima021t FROM     #No.FUN-5A0061 add
                  ima_file WHERE ima01 = sr.ttp01
#TQC-BA0039  --begin
           LET l_bdate = sr.ttp03 CLIPPED,' ',l_sfb14 CLIPPED
           LET l_edate = l_sfb15 CLIPPED,' ',l_sfb16 CLIPPED
           LET l_ndate = l_sfb20 CLIPPED,' ',l_sfb21 CLIPPED
#TQC-BA0039  --end
                                     
           EXECUTE insert_prep USING sr.ttp02,l_bdate,l_sfb05,l_ima05,l_ima08,
                                     l_sfb04,l_edate,l_ima02,l_ima021,l_ndate,
                                     l_ima55,l_sfb08,sr.ttp01,sr.ima25,sr.ttp05,
                                     sr.ima84,sr.ttp06,sr.ttp07,sr.avl_stk,sr.unavl_stk,
                                     sr.qty1,sr.qty2,sr.qty3,l_ima02t,l_ima021t,l_min,sr.ttp04
#          OUTPUT TO REPORT r100_rep(sr.*)
#NO.FUN-710081--end
       END IF
     END FOREACH
     
#NO.FUN-710081--start
 
   ## LET l_sql = " SELECT * FROM " ,l_table CLIPPED  #TQC-730113
      LET l_sql = " SELECT * FROM " ,g_cr_db_str CLIPPED,l_table CLIPPED
   ## CALL cl_prt_cs3('asfr100',l_sql,l_str)          #TQC-730113
      CALL cl_prt_cs3('asfr100','asfr100',l_sql,l_str)
    
#     FINISH REPORT r100_rep
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-710081--end 
END FUNCTION
 
#NO.FUN-710081--start
 
#REPORT r100_rep(sr)
#   DEFINE
#      l_last_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#      sr           RECORD
#                   ttp01     LIKE sfb_file.sfb05,   #料件編號
#                   ttp02     LIKE sfb_file.sfb01,   #工單編號
#                   ttp03     LIKE sfb_file.sfb13,   #預計工單日
#                   ttp04     LIKE sfb_file.sfb08,   #工單數量
#                   ttp05     LIKE sfb_file.sfb08,   #需求數量
#                   ttp06     LIKE sfb_file.sfb08,   #未供給需求數量前之可用
#                   ttp07     LIKE sfb_file.sfb08,   #預期缺料量
#                   ima25     LIKE ima_file.ima25,   #庫存單位
#                   ima84     LIKE oeb_file.oeb12,   #No.FUN-680121 DEC(9,2)#OM備置量
#                   ima261    LIKE ima_file.ima261,  #庫存不可用量
#                   ima262    LIKE ima_file.ima262,  #庫存可用量
#                   }
#                   {
#                   ima76     DEC(9,2),             #在外量
#                   ima78     DEC(9,2),             #在驗量
#                  #ima79     DEC(9,2)              #缺料量   #TQC-650066 mark
#                   }
#                   {
#                   qty1       LIKE sfa_file.sfa03,       #在外量
#                   qty2       LIKE sfa_file.sfa03,       #在驗量
#                   qty3       LIKE sfa_file.sfa03        #缺料量
#                   END RECORD ,
#      sfa DYNAMIC ARRAY OF RECORD
#                   ttp01     LIKE sfb_file.sfb05,   #料件編號
#                   ttp02     LIKE sfb_file.sfb01,   #工單編號
#                   ttp03     LIKE sfb_file.sfb13,   #預計工單日
#                   ttp04     LIKE sfb_file.sfb08,   #工單數量
#                   ttp05     LIKE sfb_file.sfb08,   #需求數量
#                   ttp06     LIKE sfb_file.sfb08,   #未供給需求數量前之可用
#                   ttp07     LIKE sfb_file.sfb08,   #預期缺料量
#                   ima25     LIKE ima_file.ima25,   #庫存單位
#                   ima84     LIKE oeb_file.oeb12,   #No.FUN-680121 DEC(9,2)#OM備置量
#                   ima261    LIKE ima_file.ima261,  #庫存不可用量
#                   ima262    LIKE ima_file.ima262,  #庫存可用量
#                   }
#                 {
#                   ima76     DEC(9,2),             #在外量
#                   ima78     DEC(9,2),             #在驗量
#                  #ima79     DEC(9,2)              #缺料量  #TQC-650066 mark
#                 }
#                 {
#                   qty1       LIKE sfa_file.sfa03,       #在外量
#                   qty2       LIKE sfa_file.sfa03,       #在驗量
#                   qty3       LIKE sfa_file.sfa03        #缺料量
#                   END RECORD ,
#      t_ttp05      LIKE sfb_file.sfb08,   #No.FUN-680121 DEC(9,2)
#      t_ima84      LIKE oeb_file.oeb12,   #No.FUN-680121 DEC(9,2)
#      t_ttp06      LIKE sfb_file.sfb08,   #No.FUN-680121 DEC(9,2)
#      t_ttp07      LIKE sfb_file.sfb08,   #No.FUN-680121 DEC(9,2)
#      t_ima262     LIKE ima_file.ima262,  #No.FUN-680121 DEC(9,2)
#      t_ima261     LIKE ima_file.ima261,  #No.FUN-680121 DEC(9,2)
#    }
#     {
#      t_ima76      DECIMAL(9,2),
#      t_ima78      DECIMAL(9,2),
#    # t_ima79      DECIMAL(9,2), #TQC-650066 mark
#      }
#      {
#      t_qty1       LIKE sfa_file.sfa03,   #No.FUN-680121 DEC(9,2)
#      t_qty2       LIKE sfa_file.sfa03,   #No.FUN-680121 DEC(9,2)
#      t_qty3       LIKE sfa_file.sfa03,   #No.FUN-680121 DEC(9,2)
#      l_sfb05      LIKE sfb_file.sfb05,  #料件編號
#      l_sfb04      LIKE sfb_file.sfb04,  #工單狀態
#      l_sfb20      LIKE sfb_file.sfb20,  #MRP/MPS需求日期
#      l_sfb21      LIKE sfb_file.sfb21,  #MRP/MPS需求日期
#      l_sfb14      LIKE sfb_file.sfb14,  #開始生產日期
#      l_sfb15      LIKE sfb_file.sfb15,  #結束生產日期
#      l_sfb16      LIKE sfb_file.sfb16,  #結束生產日期
#      l_sfb08      LIKE sfb_file.sfb08,  #生產數量
#      l_ima02      LIKE ima_file.ima02,  #料件編號
#      l_ima021     LIKE ima_file.ima021, #規格          #No.FUN-5A0061 add
#      l_ima05      LIKE ima_file.ima05,  #版本
#      l_ima08      LIKE ima_file.ima08,  #來源碼
#      l_ima55      LIKE ima_file.ima55,  #生產單位
#      l_sql        LIKE type_file.chr1000,#No.FUN-680121 VARCHAR(300)
#      l_num        LIKE sfa_file.sfa08,   #No.FUN-680121 DECIMAL(12,3)#可完成套數
#      l_min        LIKE sfa_file.sfa08,   #No.FUN-680121 DECIMAL(12,3)#最多可完成套數
#      l_n,i        LIKE type_file.num5,   #No.FUN-680121 SMALLINT
#      l_sw         LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.ttp01,sr.ttp04,sr.ttp02
#  FORMAT
#   PAGE HEADER
##No.FUN-590110--start
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2+1),g_x[1]
##No.FUN-590110--end
#      PRINT g_dash[1,g_len]
#      #抓取[工單檔]、[料件主檔] 相關資料
#      SELECT sfb04,sfb20,sfb21,sfb14,sfb15,sfb16,sfb05,
#             ima02,ima021,ima05,ima08,ima55,sfb08              #No.FUN-5A0061 add
#        INTO l_sfb04,l_sfb20,l_sfb21,l_sfb14,l_sfb15,l_sfb16,
#             l_sfb05,l_ima02,l_ima021,l_ima05,l_ima08,l_ima55,l_sfb08    #No.FUN-5A0061 add
#        FROM sfb_file,OUTER ima_file
#       WHERE sfb05=ima_file.ima01 AND sfb01=sr.ttp02 AND sfb87!='X'
#      PRINT g_x[11] CLIPPED,sr.ttp02 CLIPPED,
##TQC-5B0106
#            COLUMN 33,g_x[12] CLIPPED,sr.ttp03 CLIPPED,' ',l_sfb14 CLIPPED,
##           COLUMN 52,g_x[12] CLIPPED,sr.ttp03 CLIPPED,' ',l_sfb14 CLIPPED,
#            COLUMN 56,g_x[13] CLIPPED,l_sfb05 CLIPPED,
#            COLUMN 107,g_x[20] CLIPPED,l_ima05 CLIPPED,
#            COLUMN 124,g_x[21] CLIPPED,l_ima08
##           COLUMN 91,g_x[13] CLIPPED,l_sfb05 CLIPPED,' ',l_ima05 CLIPPED,' ',l_ima08
#      PRINT g_x[14] CLIPPED,l_sfb04 CLIPPED,
#            COLUMN 33,g_x[15] CLIPPED,l_sfb15 CLIPPED,' ',l_sfb16 CLIPPED,
#            COLUMN 56,g_x[16] CLIPPED,l_ima02
##           COLUMN 52,g_x[15] CLIPPED,l_sfb15 CLIPPED,' ',l_sfb16 CLIPPED,
#      PRINT COLUMN 56,g_x[30] CLIPPED,l_ima021 CLIPPED                #No.FUN-5A0061 ADD
#      PRINT g_x[17] CLIPPED,l_sfb20 CLIPPED,' ',l_sfb21 CLIPPED,
#            COLUMN 33,g_x[18] CLIPPED,l_ima55 CLIPPED,
#            COLUMN 56,g_x[19] CLIPPED,l_sfb08
##TQC-5B0106 End
#      PRINT g_dash[1,g_len]
#      LET l_sw='N'
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.ttp02   #工單編號
#      IF (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#      IF l_sw='Y' THEN
#         #單身表頭
##No.FUN-590110--start
#         PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#                        g_x[38],g_x[39],g_x[40],g_x[41]
#         PRINTX name=H2 g_x[42],g_x[43]       #No.FUN-5A0061 add
#         PRINT g_dash1
##No.FUN-590110--end
#      END IF
#      LET l_sw='N'
#      LET l_n=0
#      FOR i=1 TO 100
#          INITIALIZE sfa[i].* TO NULL
#      END FOR
#
#   ON EVERY ROW
#      LET l_n=l_n+1
#      #若有料件之下階超過100個料件時,請將 ARRAY 個數加大
#      IF l_n > 100 THEN
#         CALL cl_err(sr.ttp01,'asf-319',1)
#         CLOSE WINDOW r100_w
#         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
#         EXIT PROGRAM
#      END IF
#      LET sfa[l_n].*=sr.*      #先存在 ARRAY ,並計算其套數
#      #計算可完成套數, 最多可完成套數:Min(可用數量/需求數量)*工單數量
#      LET l_num=(sr.ttp06/sr.ttp05)*sr.ttp04
#      IF l_n=1 THEN
#         LET l_min=l_num
#      ELSE
#         IF l_min > l_num THEN
#            LET l_min=l_num     #最多可完成套數
#         END IF
#      END IF
#
#   AFTER GROUP OF sr.ttp02      #工單號碼
#      # 若最多可完成套數>工單數量則列印
#      #   1.只列印該工單的資料(單頭部份)
#      #   2.單身的資料不列印(表頭亦不列印)
#      #   3.列印 "最多可完成套數:        ***  工單有充足的可用數量  ***"
# 
# 
#      IF l_min > sr.ttp04 THEN
#         PRINT COLUMN 1,g_x[27] CLIPPED,l_min,
#               COLUMN 52,g_x[28] CLIPPED
#      ELSE
#         #否則
#         #  1.列印該工單的資料(單頭部份)
#         #  2.列印該工單的用料資料(單身部份)
#         #  3.列印 "最多可完成套數:           " 字樣
#         #單身表頭
##No.FUN-590110--start
#         PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#                        g_x[38],g_x[39],g_x[40],g_x[41]
#         PRINTX name=H2 g_x[42],g_x[43]       #No.FUN-5A0061 add
#         PRINT g_dash1
##No.FUN-590110--end
#         FOR i=1 TO l_n
#             #是否僅印缺料料件
#             IF tm.e='N'  OR (tm.e='Y' AND sfa[i].ttp07 > 0) THEN
#                IF LINENO > 50 THEN  #換頁時,必須列印單身表頭
#                   LET l_sw='Y'
#                   SKIP TO TOP OF PAGE
#                END IF
#                LET t_ttp05=sfa[i].ttp05
#                LET t_ima84=sfa[i].ima84
#                LET t_ttp06=sfa[i].ttp06
#                LET t_ttp07=sfa[i].ttp07
#                LET t_ima262=sfa[i].ima262
#                LET t_ima261=sfa[i].ima261
#              # LET t_ima76=sfa[i].ima76
#              # LET t_ima78=sfa[i].ima78
#              # LET t_ima79=sfa[i].ima79
#                LET t_qty1 =sfa[i].qty1
#                LET t_qty2 =sfa[i].qty2
#                LET t_qty3 =sfa[i].qty3
#                SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM     #No.FUN-5A0061 add
#                 ima_file WHERE ima01 = sfa[i].ttp01
##No.FUN-590110--start
#                PRINTX name=D1
#                      #COLUMN g_c[31],sfa[i].ttp01[1,30],
#                      COLUMN g_c[31],sfa[i].ttp01 CLIPPED,  #NO.FUN-5B0015
#                      COLUMN g_c[32],sfa[i].ima25,
#                      COLUMN g_c[33],t_ttp05,
#                      COLUMN g_c[34],t_ima84,
#                      COLUMN g_c[35],t_ttp06,
#                      COLUMN g_c[36],t_ttp07,
#                      COLUMN g_c[37],t_ima262,
#                      COLUMN g_c[38],t_ima261,
#                      COLUMN g_c[39],t_qty1,
#                      COLUMN g_c[40],t_qty2,
#                      COLUMN g_c[41],t_qty3
#                PRINTX name=D2
#                      COLUMN g_c[42],l_ima02  CLIPPED,
#                      COLUMN g_c[43],l_ima021 CLIPPED     #No.FUN-5A0061 add
#             END IF
#         END FOR
##No.FUN-590110--end
#         PRINT ' '
#         PRINT COLUMN 1,g_x[27] CLIPPED,l_min
#      END IF
# 
#   ON LAST ROW
#      PRINT g_dash[1,g_len]
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      LET l_last_sw = 'y'
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#NO.FUN-710081--end
 
#抓取用料檔資料 -----------------------------------------
FUNCTION r100_sfa(p_sfb01)
DEFINE
     p_sfb01   LIKE sfb_file.sfb01,     #工單編號
     l_sfa03   LIKE sfa_file.sfa03,     #料件編號
     l_sfa09   LIKE sfa_file.sfa09,     #前置時間調整天
     l_sfa13   LIKE sfa_file.sfa13,     #發料單位/庫存單位轉換率
     l_sfa05   LIKE sfa_file.sfa05,     #應發數量-已發數量
     l_qty     LIKE sfa_file.sfa05,     #(應發數量-已發數量)*轉換率
     l_cnt     LIKE type_file.num5,         #No.FUN-680121 SMALLINT
     l_sql     LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(1000)
 
     LET l_sql = "SELECT  sfa03,(sfa05-sfa06),sfa13,sfa09 ",
                 "  FROM sfa_file,sfb_file ",
                 " WHERE sfa01='",p_sfb01,"' ",
                 " AND (sfa05-sfa06) > 0 AND sfaacti='Y' ",
                 " AND sfa04 > 0 AND sfa01 = sfb01 AND sfb87 !='X'"
     IF tm.d='N' THEN      #是否列印大宗料件
        LET l_sql=l_sql CLIPPED,
           " AND (sfa11 NOT IN ('U','V') OR sfa11 IS NULL ) "
     END IF
     LET l_sql=l_sql CLIPPED," ORDER BY sfa03 "
     PREPARE r100_sfap1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare4:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
     DECLARE r100_sfa1 CURSOR FOR r100_sfap1
     FOREACH r100_sfa1 INTO l_sfa03,l_sfa05,l_sfa13,l_sfa09
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
       #料件之投料時間(為工單的預計開工日+前置時間調整sfa09)若大於截止
       #日期,則該用料不予考慮。
       IF l_sfa09 IS NULL THEN LET l_sfa09=0 END IF
       IF (g_sfb13 + l_sfa09) > tm.e_date THEN
          CONTINUE FOREACH
       END IF
       MESSAGE 'Waiting ...'
       #乘以單位換算率
       IF l_sfa13 IS NULL THEN LET l_sfa13=1 END IF
       LET l_qty=l_sfa05*l_sfa13   #需求數量
       #需求數量>0時才考慮
       IF l_qty > 0 THEN
           #insert 可用數量暫時代表資料來源 0:工單檔 -1:獨立需求檔
          INSERT INTO ttp_file
            VALUES(l_sfa03,p_sfb01,g_sfb13,g_sfb08,l_qty,0,0)
       END IF
     END FOREACH
END FUNCTION

#TQC-TQC-7B0143---mod---str---
#FUNCTION cralc_bom名在$SUB/s_cralc.4gl內也有相同的FUNCTION 名,所以更名為r100_cralc_bom
#FUNCTION cralc_bom(p_level,p_key,p_key2,p_total)  #FUN-550112
FUNCTION r100_cralc_bom(p_level,p_key,p_key2,p_total)  #FUN-550112
#TQC-TQC-7B0143---mod---end---
#No.FUN-A70034  --Begin
   DEFINE l_total_1    LIKE sfa_file.sfa05     #总用量
   DEFINE l_QPA        LIKE bmb_file.bmb06     #标准QPA
   DEFINE l_ActualQPA  LIKE bmb_file.bmb06     #实际QPA
   DEFINE l_sma71_o    LIKE sma_file.sma71
#No.FUN-A70034  --End  

DEFINE
    p_level   LIKE type_file.num5,        #No.FUN-680121 SMALLINT#level code
    p_total   LIKE bmb_file.bmb06,        #No.FUN-680121 DECIMAL(13,5)#
    l_total   LIKE bmb_file.bmb06,        #No.FUN-680121 DECIMAL(13,5)#
    p_key     LIKE bma_file.bma01,        #assembly part number
    p_key2    LIKE ima_file.ima910,       #FUN-550112
    l_ac,l_i  LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    arrno     LIKE type_file.num5,          #No.FUN-680121 SMALLINT#BUFFER SIZE
    b_seq     LIKE type_file.num5,          #No.FUN-680121 SMALLINT#restart sequence (line number)
    sr DYNAMIC ARRAY OF RECORD  #array for storage
        bmb02 LIKE bmb_file.bmb02, #line item
        bmb03 LIKE bmb_file.bmb03, #component part number
        bmb10 LIKE bmb_file.bmb10, #Issuing UOM
        bmb10_fac LIKE bmb_file.bmb10_fac,#Issuing UOM to stock transfer rate
        bmb06 LIKE bmb_file.bmb06, #QPA
        bmb08 LIKE bmb_file.bmb08, #yield
        bmb18 LIKE bmb_file.bmb18, #days offset
        ima02 LIKE ima_file.ima02,  #品名規格
        ima08 LIKE ima_file.ima08, #source code
        ima25 LIKE ima_file.ima25,  #庫存單位
#       ima262 LIKE ima_file.ima262,  #庫存不可用量
        avl_stk LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044 
        bma01 LIKE type_file.chr1000, #No.FUN-680121 VARCHAR(1000)
        #No.FUN-A70034  --Begin
        bmb081 LIKE bmb_file.bmb081,
        bmb082 LIKE bmb_file.bmb082
        #No.FUN-A70034  --End  
        END RECORD,
    l_chr LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    l_sfa07 LIKE sfa_file.sfa07, #quantity owed
    l_sfa11 LIKE sfa_file.sfa11, #consumable flag
#   l_qty LIKE ima_file.ima26,   #issuing to stock qty
    l_qty LIKE type_file.num15_3,###GP5.2  #NO.FUN-A20044
    l_cnt LIKE type_file.num5,         #No.FUN-680121 SMALLINT
    l_sql LIKE type_file.chr1000,      #No.FUN-680121 VARCHAR(1000)
    l_n1  LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
    l_n2  LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
    l_n3  LIKE type_file.num15_3       ###GP5.2  #NO.FUN-A20044 
    DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
    LET p_level = p_level + 1
    LET arrno = 100
    IF p_level > 20 THEN
        CALL cl_err(p_level,'mfg2644',1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
    END IF
    IF b_seq IS NULL THEN LET b_seq=0 END IF
    WHILE TRUE
        #有效日期為工單檔預計開工日期為BOM有效日期
        LET l_sql=
            "SELECT bmb02,bmb03,bmb10,bmb10_fac,",
            "bmb06/bmb07,bmb08,bmb18,",
            "ima02,ima08,ima25,0,bma01,",
            "bmb081,bmb082 ",    #No.FUN-A70034
            " FROM bmb_file,OUTER ima_file,OUTER bma_file",
            " WHERE bmb01='", p_key,"' ",
            "   AND bmb29 ='",p_key2,"' ",  #FUN-550112
            "   AND bmb02 >",b_seq,
            "   AND  bmb_file.bmb03 = bma_file.bma01 ",
            "   AND  bmb_file.bmb03 = ima_file.ima01 ",
            "   AND (bmb04 <='",g_sfb13,"' OR bmb04 IS NULL) ",
            "   AND (bmb05 >'",g_sfb13,"' OR bmb05 IS NULL)" ,
            "   AND bmaacti='Y' "
        IF tm.d='N' THEN      #是否列印大宗料件
            LET l_sql=l_sql CLIPPED," AND ima08 NOT IN ('U','V') "
        END IF
        LET l_sql=l_sql CLIPPED, " ORDER BY 2"
        PREPARE cralc_ppp FROM l_sql
        IF SQLCA.sqlcode THEN CALL cl_err('P1:',SQLCA.sqlcode,1) RETURN 0 END IF
        DECLARE cralc_cur CURSOR FOR cralc_ppp
 
        #put BOM data into buffer
        LET l_ac = 1
        FOREACH cralc_cur INTO sr[l_ac].*
            #料件之投料時間(為工單的預計開工日+元件投料時距bmb18)若大於截止
            #日期,則該用料不予考慮。
            IF sr[l_ac].bmb18+ g_sfb13 > tm.e_date THEN
               CONTINUE FOREACH
            END IF
            #FUN-8B0035--BEGIN--                                                                                                    
            LET l_ima910[l_ac]=''
            CALL s_getstock(sr[l_ac].bmb03,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
            LET sr[l_ac].avl_stk = l_n3
            SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
            IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
            #FUN-8B0035--END-- 
            LET l_ac = l_ac + 1    #check limitation
            IF l_ac >= arrno THEN EXIT FOREACH END IF
        END FOREACH
 
        #insert into allocation file
        FOR l_i = 1 TO l_ac-1
            IF sr[l_i].bmb08 IS NULL THEN LET sr[l_i].bmb08=0 END IF
            #No.FUN-A70034  --Begin
            #IF tm.f='Y' THEN   #考慮損耗率
            #    LET l_total=sr[l_i].bmb06*p_total*((100+sr[l_i].bmb08))/100
            #ELSE
            #    LET l_total=sr[l_i].bmb06*p_total
            #END IF

            LET l_sma71_o = g_sma.sma71
            LET g_sma.sma71 = tm.f
            CALL cralc_rate(p_key,sr[l_i].bmb03,p_total,sr[l_i].bmb081,sr[l_i].bmb08,sr[l_i].bmb082,sr[l_i].bmb06,0)
                 RETURNING l_total_1,l_QPA,l_ActualQPA
            LET l_total=l_total_1
            LET g_sma.sma71 = l_sma71_o
            #No.FUN-A70034  --End  

            IF sr[l_i].bmb10_fac IS NULL THEN
               LET sr[l_i].bmb10_fac=1
            END IF
            #乘以單位換算率
            LET l_qty=l_total*sr[l_i].bmb10_fac #convert to stocking qty
 
            #料件為(X,K)虛擬料件時,若Blow through(sma29)='Y' ,則往下展之,
            #否則不往下展,只至該階。
           #-------------No.FUN-670041 modify
           #IF sr[l_i].ima08 MATCHES '[XK]' AND g_sma.sma29='Y' THEN
            IF sr[l_i].ima08 MATCHES '[XK]' THEN
           #-------------No.FUN-670041 end
                IF sr[l_i].bma01 IS NOT NULL THEN
                   #CALL r100_cralc_bom(p_level,sr[l_i].bmb03,' ',p_total*sr[l_i].bmb06)  #FUN-550112 #TQC-7B0143#FUN-8B0035
                    #No.FUN-A70034  --Begin
                    #CALL r100_cralc_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],p_total*sr[l_i].bmb06)  #FUN-8B0035
                    CALL r100_cralc_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],l_total)
                    #No.FUN-A70034  --End  
                END IF
            ELSE
              #需求數量>0時才考慮
              IF l_qty > 0 THEN
                 #insert 可用數量暫時代表資料來源 0:工單檔 -1:獨立需求檔
                 #insert 至暫存檔
                    INSERT INTO ttp_file
                     VALUES(sr[l_i].bmb03,g_sfb01,g_sfb13,g_sfb08,
                       #    l_qty,0,0,g_utime)
                            l_qty,0,0)
                 LET g_count = g_count + 1
              END IF
           END IF
        END FOR
        IF l_ac < arrno OR l_ac=1 THEN #nothing left
            EXIT WHILE
        ELSE
            LET b_seq = sr[arrno].bmb02
        END IF
    END WHILE
END FUNCTION
 
#Patch....NO.TQC-610037 <> #
#TQC-A60097
