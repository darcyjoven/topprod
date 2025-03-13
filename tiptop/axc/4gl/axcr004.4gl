# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr004.4gl
# Descriptions...: 合計金額統計表
# Input parameter:
# Return code....:
# Date & Author..: 95/10/10 By Nick
# #+103 modify by Ostrich 010504 工單上階合計移除,另增加雜收及結存調整合計
# Modify.........: No:7310 03/07/16 By Nicola WHERE 數量、金額改為DEC(15,3),增加其他欄位
# Modify.........: No:7996 03/09/02 By Wiky g_azi03 應改為 g_azi04,造成取位錯誤
# Modify.........: No:9330 04/03/11 By Melody 差異調整(c92)顯示成合計金額(c93),並且應該放在合計前一行而非後面
# Modify.........: No:9362 04/03/25 By Melody 庫存總計與在製下階中間原本有一塊資料在製成品的部分,為何要拿掉?且程式段中也沒有清乾淨,還留有"工時投入~期末結存"===>將該留存的先mark掉
# Modify.........: No:9630 04/06/07 By Melody 應加判斷 q1 is null的處理
# Modify.........: No:8741 04/06/07 By Melody 修改列印部份
# Modify.........: No.MOD-530181 05/03/21 By kim Define金額單價位數改為dec(20,6)
# Modify.........: No.MOD-570272 05/07/20 By Sarah 報表抬頭位置錯誤(原"加工 人工 製費"→"人工 製費 加工")
# Modify.........: No.FUN-570190 05/08/05 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.FUN-5B0082 05/11/16 By Sarah 報表少印"其他"欄位
# Modify.........: No.TQC-610051 06/02/23 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-670058 06/07/17 By Sarah 增加列印拆件式工單期初、投入、轉出、結存
# Modify.........: No.FUN-680007 06/08/01 By Sarah 增加列印拆件式工單DL+OH+SUB,差異轉出 
# Modify.........: No.FUN-670106 06/08/24 By douzh voucher型報表轉template1
# Modify.........: No.FUN-680122 06/09/05 By zdyllq 類型轉換 
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.MOD-690038 06/11/17 By Claire c22d->c22e
# Modify.........: No.CHI-690007 06/12/08 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.FUN-660073 06/12/08 By Nicola 訂單樣品修改
# Modify.........: No.MOD-720112 07/03/02 By pengu 修改PRINT的語法
# Modify.........: No.TQC-760141 07/06/15 By Sarah 報表的製表日期與FROM/頁次等..應該在雙線的上一行(標準)
# Modify.........: No.FUN-750112 07/06/26 By Jackho CR報表修改
# Modify.........: No.MOD-7B0113 07/11/13 By Carol  調整DL+OH+SUB的計算邏輯
# Modify.........: No.FUN-7C0101 08/01/22 By Zhangyajun 成本改善增加成本計算類型 
# Modify.........: No.FUN-830135 08/03/27 By Zhangyajun Bug修改 
# Modify.........: No.FUN-840005 08/04/01 By Zhangyajun SQL條件去除類別編號
# Modify.........: No.MOD-880230 08/08/27 By chenl   增加報表小數位數
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-960288 09/06/25 By mike 金額欄位使用azi03取位       
# Modify.........: No.FUN-980069 09/08/21 By mike 將年度欄位default ccz01月份欄位default ccz02
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0073 10/01/12 By chenls 程序精簡
# Modify.........: No.TQC-A40130 10/04/28 By Carrier 追单MOD-880230 / cca06的条件放在 LEFT OUTER JOIN中错误,应该放在WHERE中
# Modify.........: No.MOD-BB0084 11/11/07 By yinhy 增加在制DL+OH+S轉出數量，金額和拆件DL+OH+S轉出數量,金額
# Modify.........: No.CHI-BB0010 11/11/09 By kim 本月入庫應該要扣除銷退入庫成本,而將銷退入庫放再銷售出貨的減項
# Modify.........: No:MOD-C30729 12/03/15 By ck2yuan 若未AFTER FIELD mm 不會是畫面上年度期別,改在AFTER INPUT才CALL s_azm
# Modify.........: No:MOD-C60189 12/06/22 By bart 修正MOD-BB0084錯誤
# Modify.........: No:MOD-C70072 12/07/06 By Sakura 銷退入庫對銷售出貨應是加項
# Modify.........: No:CHI-C30012 12/07/19 By bart 金額取位改抓ccz26
# Modify.........: No.FUN-C80085 12/09/19 By xujing  將本月入庫拆分成各入庫細項:"採購入庫","委外入庫","生產入庫","雜項入庫","調整入庫","銷退入庫"
# Modify.........: No.FUN-C80092 12/12/04 By xujing  根据条件把数量金额插入到ckk_file
# Modify.........: No.FUN-C80092 12/12/04 By xujing 增加寫入日誌功能
# Modify.........: No.TQC-CC0113 12/12/24 By xujing 修改insert臨時表報錯問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(600),      # Where condition
              yy,mm   LIKE type_file.num5,           #No.FUN-680122SMALLINT,
              type    LIKE type_file.chr1,           #No.FUN-7C0101CHAR(1)      
              a       LIKE type_file.chr1,           #FUN-C80092     
              more    LIKE type_file.chr1           #No.FUN-680122CHAR(1)         # Input more condition(Y/N)
              END RECORD,
          g_tot_bal LIKE type_file.num20_6        #No.FUN-680122DECIMAL(20,6)     # User defined variable
   DEFINE last_yy,last_mm	LIKE type_file.num5           #No.FUN-680122SMALLINT
   DEFINE bdate   LIKE type_file.dat            #No.FUN-680122DATE
   DEFINE edate   LIKE type_file.dat            #No.FUN-680122DATE
   DEFINE g_argv1 LIKE type_file.chr20          #No.FUN-680122CHAR(20)
   DEFINE g_argv2 LIKE type_file.num5           #No.FUN-680122SMALLINT
   DEFINE g_argv3 LIKE type_file.num5           #No.FUN-680122SMALLINT
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   l_table    STRING                       ### FUN-750112 ###
DEFINE   g_str      STRING                       ### FUN-750112 ###
DEFINE   g_sql      STRING                       ### FUN-750112 ###
DEFINE   l_msg      STRING #FUN-840005
DEFINE   g_ckk      RECORD  LIKE ckk_file.*      #FUN-C80092 add
DEFINE   g_cka00    LIKE cka_file.cka00          #FUN-C80092
 
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
 
   LET g_pdate  = ARG_VAL(1)        
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)    
   LET tm.yy  = ARG_VAL(8)       
   LET tm.mm  = ARG_VAL(9)        
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET tm.type = ARG_VAL(13)    #No.FUN-7C0101 add
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   LET tm.a = ARG_VAL(15)    #No.FUN-C80092
    LET g_sql = "type.cca_file.cca06,",
                "typeno.cca_file.cca07,",
                "j11.type_file.num20_6,", 
                "j12.type_file.num20_6,", 
                "j12a.type_file.num20_6,", 
                "j12b.type_file.num20_6,", 
                "j12c.type_file.num20_6,", 
                "j12d.type_file.num20_6,", 
                "j12e.type_file.num20_6,",
                "j12f.type_file.num20_6,",     #No.FUN-7C0101
                "j12g.type_file.num20_6,",     #No.FUN-7C0101
                "j12h.type_file.num20_6,",     #No.FUN-7C0101
                "c11.type_file.num20_6,", 
                "c12.type_file.num20_6,", 
                "c12a.type_file.num20_6,", 
                "c12b.type_file.num20_6,", 
                "c12c.type_file.num20_6,", 
                "c12d.type_file.num20_6,", 
                "c12f.type_file.num20_6,",     #No.FUN-7C0101
                "c12g.type_file.num20_6,",     #No.FUN-7C0101
                "c12h.type_file.num20_6,",     #No.FUN-7C0101
                "c21.type_file.num20_6,", 
                "c22.type_file.num20_6,", 
                "c22a.type_file.num20_6,", 
                "c22b.type_file.num20_6,", 
                "c22c.type_file.num20_6,", 
                "c22d.type_file.num20_6,", 
                "c22f.type_file.num20_6,",     #No.FUN-7C0101
                "c22g.type_file.num20_6,",     #No.FUN-7C0101
                "c22h.type_file.num20_6,",     #No.FUN-7C0101
                "c25.type_file.num20_6,", 
                "c26.type_file.num20_6,",
                "c26a.type_file.num20_6,",
                "c26b.type_file.num20_6,",
                "c26c.type_file.num20_6,",
                "c26d.type_file.num20_6,",
                "c26f.type_file.num20_6,",     #No.FUN-7C0101
                "c26g.type_file.num20_6,",     #No.FUN-7C0101
                "c26h.type_file.num20_6,",     #No.FUN-7C0101
                "c27.type_file.num20_6,",
                "c28.type_file.num20_6,",
                "c28a.type_file.num20_6,",
                "c28b.type_file.num20_6,",
                "c28c.type_file.num20_6,",
                "c28d.type_file.num20_6,",
                "c28f.type_file.num20_6,",     #No.FUN-7C0101
                "c28g.type_file.num20_6,",     #No.FUN-7C0101
                "c28h.type_file.num20_6,",     #No.FUN-7C0101
                "c31.type_file.num20_6,",
                "c32.type_file.num20_6,",
                "c32a.type_file.num20_6,",
                "c32b.type_file.num20_6,",
                "c32c.type_file.num20_6,",
                "c32d.type_file.num20_6,",
                "c32f.type_file.num20_6,",     #No.FUN-7C0101
                "c32g.type_file.num20_6,",     #No.FUN-7C0101
                "c32h.type_file.num20_6,",     #No.FUN-7C0101
                "c41.type_file.num20_6,",
                "c42.type_file.num20_6,",
                "c43.type_file.num20_6,",
                "c44.type_file.num20_6,",
                "c51.type_file.num20_6,",
                "c52.type_file.num20_6,",
                "c61.type_file.num20_6,",
                "c62.type_file.num20_6,",
                "c71.type_file.num20_6,",
                "c72.type_file.num20_6,",
                "c81.type_file.num20_6,",
                "c82.type_file.num20_6,",
                "c91.type_file.num20_6,",
                "c92.type_file.num20_6,",
                "c92a.type_file.num20_6,",
                "c92b.type_file.num20_6,",
                "c92c.type_file.num20_6,",
                "c92d.type_file.num20_6,",
                "c92e.type_file.num20_6,",
                "c92f.type_file.num20_6,",     #No.FUN-7C0101
                "c92g.type_file.num20_6,",     #No.FUN-7C0101
                "c92h.type_file.num20_6,",     #No.FUN-7C0101
                "c93.type_file.num20_6,",
                "g11.type_file.num20_6,",
                "g12.type_file.num20_6,",
                "g12a.type_file.num20_6,",
                "g12b.type_file.num20_6,",
                "g12c.type_file.num20_6,",
                "g12d.type_file.num20_6,",
                "g12f.type_file.num20_6,",     #No.FUN-7C0101
                "g12g.type_file.num20_6,",     #No.FUN-7C0101
                "g12h.type_file.num20_6,",     #No.FUN-7C0101
                "g21.type_file.num20_6,",
                "g22.type_file.num20_6,",
                "g22a.type_file.num20_6,",
                "g22b.type_file.num20_6,",
                "g22c.type_file.num20_6,",
                "g22d.type_file.num20_6,",
                "g22f.type_file.num20_6,",     #No.FUN-7C0101
                "g22g.type_file.num20_6,",     #No.FUN-7C0101
                "g22h.type_file.num20_6,",     #No.FUN-7C0101
                "g20.type_file.num20_6,",
                "g23.type_file.num20_6,",
                "g23a.type_file.num20_6,",
                "g23b.type_file.num20_6,",
                "g23c.type_file.num20_6,",
                "g23d.type_file.num20_6,",
                "g23f.type_file.num20_6,",     #No.FUN-7C0101
                "g23g.type_file.num20_6,",     #No.FUN-7C0101
                "g23h.type_file.num20_6,",     #No.FUN-7C0101
                "q1.type_file.num20_6,",
                "q2.type_file.num20_6,",
                "q3.type_file.num20_6,",
                "q4.type_file.num20_6,",       #No.MOD-BB0084
                "g24.type_file.num20_6,",
                "g24a.type_file.num20_6,",
                "g24b.type_file.num20_6,",
                "g24c.type_file.num20_6,",
                "g24d.type_file.num20_6,",
                "g24f.type_file.num20_6,",     #No.FUN-7C0101
                "g24g.type_file.num20_6,",     #No.FUN-7C0101
                "g24h.type_file.num20_6,",     #No.FUN-7C0101
                "g25.type_file.num20_6,",
                "g25a.type_file.num20_6,",
                "g25b.type_file.num20_6,",
                "g25c.type_file.num20_6,",
                "g25d.type_file.num20_6,",
                "g25f.type_file.num20_6,",     #No.FUN-7C0101
                "g25g.type_file.num20_6,",     #No.FUN-7C0101
                "g25h.type_file.num20_6,",     #No.FUN-7C0101
                "g26.type_file.num20_6,",      #No.MOD-BB0084
                "g26a.type_file.num20_6,",     #No.MOD-BB0084
                "g26b.type_file.num20_6,",     #No.MOD-BB0084
                "g26c.type_file.num20_6,",     #No.MOD-BB0084
                "g26d.type_file.num20_6,",     #No.MOD-BB0084
                "g26e.type_file.num20_6,",     #No.MOD-BB0084
                "g26f.type_file.num20_6,",     #No.MOD-BB0084
                "g26g.type_file.num20_6,",     #No.MOD-BB0084
                "g26h.type_file.num20_6,",     #No.MOD-BB0084
                "g31.type_file.num20_6,",
                "g32.type_file.num20_6,",
                "g32a.type_file.num20_6,",
                "g32b.type_file.num20_6,",
                "g32c.type_file.num20_6,",
                "g32d.type_file.num20_6,",
                "g32f.type_file.num20_6,",     #No.FUN-7C0101
                "g32g.type_file.num20_6,",     #No.FUN-7C0101
                "g32h.type_file.num20_6,",     #No.FUN-7C0101
                "g41.type_file.num20_6,",
                "g42.type_file.num20_6,",
                "g42a.type_file.num20_6,",
                "g42b.type_file.num20_6,",
                "g42c.type_file.num20_6,",
                "g42d.type_file.num20_6,",
                "g42e.type_file.num20_6,",
                "g42f.type_file.num20_6,",     #No.FUN-7C0101
                "g42g.type_file.num20_6,",     #No.FUN-7C0101
                "g42h.type_file.num20_6,",     #No.FUN-7C0101
                "g91.type_file.num20_6,",
                "g92.type_file.num20_6,",
                "g92a.type_file.num20_6,",
                "g92b.type_file.num20_6,",
                "g92c.type_file.num20_6,",
                "g92d.type_file.num20_6,",
                "g92f.type_file.num20_6,",     #No.FUN-7C0101
                "g92g.type_file.num20_6,",     #No.FUN-7C0101
                "g92h.type_file.num20_6,",     #No.FUN-7C0101
                "c12e.type_file.num20_6,",
                "c22e.type_file.num20_6,",
                "c26e.type_file.num20_6,",
                "c28e.type_file.num20_6,",
                "c32e.type_file.num20_6,",
                "g12e.type_file.num20_6,",
                "g22e.type_file.num20_6,",
                "g23e.type_file.num20_6,",
                "g24e.type_file.num20_6,",
                "g25e.type_file.num20_6,",
                "g32e.type_file.num20_6,",
                "g92e.type_file.num20_6,",
                "u11.type_file.num20_6,",
                "u12.type_file.num20_6,",
                "u12a.type_file.num20_6,",
                "u12b.type_file.num20_6,",
                "u12c.type_file.num20_6,",
                "u12d.type_file.num20_6,",
                "u12e.type_file.num20_6,",
                "u12f.type_file.num20_6,",     #No.FUN-7C0101
                "u12g.type_file.num20_6,",     #No.FUN-7C0101
                "u12h.type_file.num20_6,",     #No.FUN-7C0101
                "u21.type_file.num20_6,",
                "u22.type_file.num20_6,",
                "u22a.type_file.num20_6,",
                "u22b.type_file.num20_6,",
                "u22c.type_file.num20_6,",
                "u22d.type_file.num20_6,",
                "u22e.type_file.num20_6,",
                "u22f.type_file.num20_6,",     #No.FUN-7C0101
                "u22g.type_file.num20_6,",     #No.FUN-7C0101
                "u22h.type_file.num20_6,",     #No.FUN-7C0101
                "u23.type_file.num20_6,",
                "u24.type_file.num20_6,",
                "u24a.type_file.num20_6,",
                "u24b.type_file.num20_6,",
                "u24c.type_file.num20_6,",
                "u24d.type_file.num20_6,",
                "u24e.type_file.num20_6,",
                "u24f.type_file.num20_6,",     #No.FUN-7C0101
                "u24g.type_file.num20_6,",     #No.FUN-7C0101
                "u24h.type_file.num20_6,",     #No.FUN-7C0101
                "u25.type_file.num20_6,",      #No.MOD-BB0084
                "u26.type_file.num20_6,",      #No.MOD-BB0084
                "u26a.type_file.num20_6,",     #No.MOD-BB0084
                "u26b.type_file.num20_6,",     #No.MOD-BB0084
                "u26c.type_file.num20_6,",     #No.MOD-BB0084
                "u26d.type_file.num20_6,",     #No.MOD-BB0084
                "u26e.type_file.num20_6,",     #No.MOD-BB0084
                "u26f.type_file.num20_6,",     #No.MOD-BB0084
                "u26g.type_file.num20_6,",     #No.MOD-BB0084
                "u26h.type_file.num20_6,",     #No.MOD-BB0084
                "u31.type_file.num20_6,",
                "u32.type_file.num20_6,",
                "u32a.type_file.num20_6,",
                "u32b.type_file.num20_6,",
                "u32c.type_file.num20_6,",
                "u32d.type_file.num20_6,",
                "u32e.type_file.num20_6,",
                "u32f.type_file.num20_6,",     #No.FUN-7C0101
                "u32g.type_file.num20_6,",     #No.FUN-7C0101
                "u32h.type_file.num20_6,",     #No.FUN-7C0101
                "u41.type_file.num20_6,",
                "u42.type_file.num20_6,",
                "u42a.type_file.num20_6,",
                "u42b.type_file.num20_6,",
                "u42c.type_file.num20_6,",
                "u42d.type_file.num20_6,",
                "u42e.type_file.num20_6,",
                "u42f.type_file.num20_6,",     #No.FUN-7C0101
                "u42g.type_file.num20_6,",     #No.FUN-7C0101
                "u42h.type_file.num20_6,",     #No.FUN-7C0101
                "u91.type_file.num20_6,",
                "u92.type_file.num20_6,",
                "u92a.type_file.num20_6,",
                "u92b.type_file.num20_6,",
                "u92c.type_file.num20_6,",
                "u92d.type_file.num20_6,",
                "u92e.type_file.num20_6,",
                "u92f.type_file.num20_6,",     #No.FUN-7C0101
                "u92g.type_file.num20_6,",     #No.FUN-7C0101
                "u92h.type_file.num20_6,",       #No.FUN-7C0101 
                #add by FUN-C80085 xujing 120919 begin------
                " c111.type_file.num20_6,",
                " c11a1.type_file.num20_6,",
                " c11b1.type_file.num20_6,",
                " c11c1.type_file.num20_6,",
                " c11d1.type_file.num20_6,",
                " c11e1.type_file.num20_6,",
                " c11f1.type_file.num20_6,",
                " c11g1.type_file.num20_6,",
                " c11h1.type_file.num20_6,",
                " c112.type_file.num20_6,",
                " c11a2.type_file.num20_6,",
                " c11b2.type_file.num20_6,",
                " c11c2.type_file.num20_6,",
                " c11d2.type_file.num20_6,",
                " c11e2.type_file.num20_6,",
                " c11f2.type_file.num20_6,",
                " c11g2.type_file.num20_6,",
                " c11h2.type_file.num20_6,",
                " c113.type_file.num20_6,",
                " c11a3.type_file.num20_6,",
                " c11b3.type_file.num20_6,",
                " c11c3.type_file.num20_6,",
                " c11d3.type_file.num20_6,",
                " c11e3.type_file.num20_6,",
                " c11f3.type_file.num20_6,",
                " c11g3.type_file.num20_6,",
                " c11h3.type_file.num20_6,",
                " c114.type_file.num20_6,",
                " c11a4.type_file.num20_6,",
                " c11b4.type_file.num20_6,",
                " c11c4.type_file.num20_6,",
                " c11d4.type_file.num20_6,",
                " c11e4.type_file.num20_6,",
                " c11f4.type_file.num20_6,",
                " c11g4.type_file.num20_6,",
                " c11h4.type_file.num20_6, ",
                " c115.type_file.num20_6,",
                " c11a5.type_file.num20_6,",
                " c11b5.type_file.num20_6,",
                " c11c5.type_file.num20_6,",
                " c11d5.type_file.num20_6,",
                " c11e5.type_file.num20_6,",
                " c11f5.type_file.num20_6,",
                " c11g5.type_file.num20_6,",
                " c11h5.type_file.num20_6,",
                " c116.type_file.num20_6,",
                " c11a6.type_file.num20_6,",
                " c11b6.type_file.num20_6,",
                " c11c6.type_file.num20_6,",
                " c11d6.type_file.num20_6,",
                " c11e6.type_file.num20_6,",
                " c11f6.type_file.num20_6,",
                " c11g6.type_file.num20_6,",
                " c11h6.type_file.num20_6,",
                " c221.type_file.num20_6,",
                " c222.type_file.num20_6,",
                " c223.type_file.num20_6,",
                " c224.type_file.num20_6,",
                " c225.type_file.num20_6,",
                " c226.type_file.num20_6"
                #add by FUN-C80085 xujing 120919 end------
    LET l_table = cl_prt_temptable('axcr004',g_sql) CLIPPED 
    IF l_table = -1 THEN EXIT PROGRAM END IF               
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",         #MOD-7B0113-modify
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",                                     #MOD-7B0113-add
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",   #FUN-830135
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",   #FUN-830135
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",   #FUN-830135
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",   #FUN-830135
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",   #MOD-BB0084
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",   #MOD-BB0084
                "        ?, ?, ?, ?, ?, ?,",                #FUN-830135     #TQC-CC0113 del ")"
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                #FUN-C80085  #add by xujing  60 ?
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N'  # If background job sw is off
      THEN CALL axcr004_tm(0,0)          # Input print condition
   ELSE
      CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
      CALL axcr004()                # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr004_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd          LIKE type_file.chr1000,       #No.FUN-680122CHAR(400),
          l_za05         LIKE type_file.chr1000        #No.FUN-680122CHAR(40)
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 38
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW axcr004_w AT p_row,p_col
        WITH FORM "axc/42f/axcr004"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.yy = g_ccz.ccz01 #FUN-980069
   LET tm.mm = g_ccz.ccz02 #FUN-980069
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.type=g_ccz.ccz28     #No.FUN-7C0101 add
   LET tm.a = 'Y'              #FUN-C80092 add
WHILE TRUE
   INPUT BY NAME tm.yy,tm.mm,tm.type,tm.a,tm.more WITHOUT DEFAULTS  #TQC-610051  #No.FUN-7C0101 add tm.type #FUN-C80092 add  tm.a
     ON ACTION locale
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL cl_dynamic_locale()
         CONTINUE WHILE
 
 
      AFTER FIELD yy
         IF tm.yy IS NULL THEN NEXT FIELD yy END IF
         #FUN-C80092---add---str---
         IF tm.yy != g_ccz.ccz01 OR tm.mm != g_ccz.ccz02 THEN
            CALL cl_set_comp_entry('a',FALSE)
            LET tm.a = 'N'
            DISPLAY BY NAME tm.a
         ELSE
            CALL cl_set_comp_entry('a',TRUE)
            LET tm.a = 'Y'
            DISPLAY BY NAME tm.a
         END IF
         #FUN-C80092---add---end
      AFTER FIELD mm
         IF tm.mm IS NULL THEN NEXT FIELD mm END IF
         IF tm.mm <= 0 OR tm.mm > 12 THEN NEXT FIELD mm END IF  #FUN-C80092
         CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
         #FUN-C80092---add---str---
         IF tm.yy != g_ccz.ccz01 OR tm.mm != g_ccz.ccz02 THEN
            CALL cl_set_comp_entry('a',FALSE)
            LET tm.a = 'N'
            DISPLAY BY NAME tm.a
         ELSE
            CALL cl_set_comp_entry('a',TRUE)
            LET tm.a = 'Y'
            DISPLAY BY NAME tm.a
         END IF
         #FUN-C80092---add---end---
      AFTER FIELD type
         IF tm.type IS NULL OR tm.type NOT MATCHES '[12345]' THEN
            NEXT FIELD type
         END IF
      AFTER FIELD more
         IF tm.more = 'Y' THEN 
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies)
                 RETURNING g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies
         END IF
      #TQC-610051-end
      #FUN-C80092---add---str---
      AFTER FIELD a
         IF cl_null(tm.a) THEN
            NEXT FIELD a
         END IF
      #FUN-C80092---add---end---
      AFTER INPUT                                               #MOD-C30729 add
         CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate    #MOD-C30729 add      

################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
         BEFORE INPUT
             CALL cl_qbe_init()
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   #No.MOD-BB0084  --Begin
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   #No.MOD-BB0084  --EnD
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr004_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr004'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr004','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.type CLIPPED,"'",              #No.FUN-7C0101
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axcr004',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr004_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr004()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr004_w
END FUNCTION
 
FUNCTION axcr004()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680122CHAR(20),        # External(Disk) file name
          l_za05    LIKE type_file.chr1000        #No.FUN-680122CHAR(40)
  DEFINE #l_sql    LIKE type_file.chr1000  
         l_sql    STRING     #NO.FUN-910082
  DEFINE l_mm     LIKE type_file.chr2  
  DEFINE type     LIKE cca_file.cca06     #No.FUN-7C0101
  DEFINE typeno   LIKE cca_file.cca07     #No.FUN-7C0101
  DEFINE j11,j12,j12a,j12b,j12c,j12d,j12e,j12f,j12g,j12h LIKE type_file.num20_6      #No.FUN-7C0101 
  DEFINE c11,c12,c12a,c12b,c12c,c12d,c12f,c12g,c12h,             #No.FUN-7C0101
         c21,c22,c22a,c22b,c22c,c22d,c22f,c22g,c22h,             #No.FUN-7C0101
         c25,c26,c26a,c26b,c26c,c26d,c26f,c26g,c26h,             #No.FUN-7C0101
         c27,c28,c28a,c28b,c28c,c28d,c28f,c28g,c28h,             #No.FUN-7C0101
         c31,c32,c32a,c32b,c32c,c32d,c32f,c32g,c32h,             #No.FUN-7C0101
         c41,c42,
         c43,c44,
         c51,c52,
         c61,c62,
         c71,c72,
         c81,c82,   #No.FUN-660073
         c91,c92,c92a,c92b,c92c,c92d,c92e,c92f,c92g,c92h,        #No.FUN-7C0101
         c93 LIKE type_file.num20_6  
  DEFINE g11,g12,g12a,g12b,g12c,g12d,g12f,g12g,g12h,             #No.FUN-7C0101
         g21,g22,g22a,g22b,g22c,g22d,g22f,g22g,g22h,             #No.FUN-7C0101
         g20,g23,g23a,g23b,g23c,g23d,g23f,g23g,g23h,             #No.FUN-7C0101
         q1,q2,q3,q4,                                            #No.MOD-BB0084 add q4
             g24,g24a,g24b,g24c,g24d,g24f,g24g,g24h,             #No.FUN-7C0101
             g25,g25a,g25b,g25c,g25d,g25f,g25g,g25h,             #No.FUN-7C0101
             g26,g26a,g26b,g26c,g26d,g26e,g26f,g26g,g26h,             #No.MOD-BB0084
         g31,g32,g32a,g32b,g32c,g32d,g32f,g32g,g32h,             #No.FUN-7C0101
         g41,g42,g42a,g42b,g42c,g42d,g42e,g42f,g42g,g42h,        #No.FUN-7C0101
         g91,g92,g92a,g92b,g92c,g92d,g92f,g92g,g92h              #No.FUN-7C0101          
         LIKE type_file.num20_6    
  DEFINE c12e,c22e,c26e,c28e,c32e,
         g12e,g22e,g23e,g24e,g25e,g32e,g92e LIKE type_file.num20_6 
  DEFINE u11,u12,u12a,u12b,u12c,u12d,u12e,u12f,u12g,u12h,        #No.FUN-7C0101
         u21,u22,u22a,u22b,u22c,u22d,u22e,u22f,u22g,u22h,             #No.FUN-7C0101
         u23,u24,u24a,u24b,u24c,u24d,u24e,u24f,u24g,u24h,             #No.FUN-7C0101   #MOD-7B0113-add
         u25,u26,u26a,u26b,u26c,u26d,u26e,u26f,u26g,u26h,             #No.MOD-BB0084
         u31,u32,u32a,u32b,u32c,u32d,u32e,u32f,u32g,u32h,             #No.FUN-7C0101
         u41,u42,u42a,u42b,u42c,u42d,u42e,u42f,u42g,u42h,             #No.FUN-7C0101
         u91,u92,u92a,u92b,u92c,u92d,u92e,u92f,u92g,u92h             #No.FUN-7C0101
          LIKE type_file.num20_6
  #add by FUN-C80085 xujing  begin-----
  DEFINE c111,c11a1,c11b1,c11c1,c11d1,c11e1,c11f1,c11g1,c11h1,        
         c112,c11a2,c11b2,c11c2,c11d2,c11e2,c11f2,c11g2,c11h2,            
         c113,c11a3,c11b3,c11c3,c11d3,c11e3,c11f3,c11g3,c11h3,             
         c114,c11a4,c11b4,c11c4,c11d4,c11e4,c11f4,c11g4,c11h4,             
         c115,c11a5,c11b5,c11c5,c11d5,c11e5,c11f5,c11g5,c11h5,             
         c116,c11a6,c11b6,c11c6,c11d6,c11e6,c11f6,c11g6,c11h6,
         c221,c222,c223,c224,c225,c226
          LIKE type_file.num20_6,
         l_pre_yy,l_pre_mm  LIKE type_file.num5  #FUN-C80092
  #add by FUN-C80085 xujing  end-----
DEFINE   l_msg   STRING      #FUN-C80092 

   #FUN-C80092 -------------Begin---------------
     LET l_msg = "tm.yy = '",tm.yy,"'",";","tm.mm = '",tm.mm,"'",";","tm.type = '",tm.type,"'",";",
                 "tm.a = '",tm.a,"'",";","tm.more = '",tm.more,"'"
     CALL s_log_ins(g_prog,tm.yy,tm.mm,1=1,l_msg)
          RETURNING g_cka00
   #FUN-C80092 -------------End---------------- 
     CALL cl_del_data(l_table)  
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang  
     LET last_yy=tm.yy
     LET last_mm=tm.mm-1
     IF last_mm=0 THEN LET last_yy=tm.yy-1 LET last_mm=12 END IF
      SELECT  #FUN-840005
        SUM(cca11) ,SUM(cca12),SUM(cca12a),SUM(cca12b),SUM(cca12c),SUM(cca12d),
        SUM(cca12e),SUM(cca12f),SUM(cca12g),SUM(cca12h),  #No.FUN-7C0101
        SUM(ccc91),SUM(ccc92),SUM(ccc92a),SUM(ccc92b),SUM(ccc92c),SUM(ccc92d),
        SUM(ccc92e),SUM(ccc92f),SUM(ccc92g),SUM(ccc92h)
          INTO j11,j12,j12a,j12b,j12c,j12d,j12e,j12f,j12g,j12h,c91,c92,c92a,c92b,c92c,c92d,
               c92e,c92f,c92g,c92h       #FUN-840005  
         FROM cca_file LEFT OUTER JOIN ccc_file ON cca01=ccc01 AND cca02=ccc02 AND cca03=ccc03 AND cca06=ccc07 AND cca07=ccc08 
     WHERE cca02=last_yy AND cca03=last_mm AND cca06 = tm.type  #No.TQC-A40130
     IF j11 IS NULL THEN
        LET j11=0
        LET j12=0
        LET j12a=0
        LET j12b=0
        LET j12c=0
        LET j12d=0
        LET j12e=0
        LET j12f=0    #No.FUN-7C0101
        LET j12g=0    #No.FUN-7C0101
        LET j12h=0    #No.FUN-7C0101 
     END IF
     IF c91 IS NULL THEN
        LET c91=0 LET c92=0 LET c92a=0 LET c92b=0 LET c92c=0 LET c92d=0
        LET c92e=0 LET c92f=0 LET c92g=0 LET c92h=0  #FUN-5B0082       #No.FUN-7C0101
     END IF
     LET j11=j11-c91
     LET j12=j12-c92
     LET j12a=j12a-c92a
     LET j12b=j12b-c92b
     LET j12c=j12c-c92c
     LET j12d=j12d-c92d
     LET j12e=j12e-c92e
     LET j12f=j12f-c92f   #No.FUN-7C0101
     LET j12g=j12g-c92g   #No.FUN-7C0101
     LET j12h=j12h-c92h   #No.FUN-7C0101
     #FUN-C80092---add---str---
     IF tm.a = 'Y' THEN
        LET g_ckk.ckk17 = "cca02=",last_yy," AND cca03=",last_mm
        CALL s_ckk_fill('','103','axc-401',tm.yy,tm.mm,g_prog,tm.type,j11,j12,j12a,j12b,j12c,j12d,
                     j12e,j12f,j12g,j12h,g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
        IF NOT s_ckk(g_ckk.*,'') THEN END IF
     END IF
     #FUN-C80092---add---end---
     SELECT
          SUM(ccc11),SUM(ccc12),SUM(ccc12a),SUM(ccc12b),SUM(ccc12c),SUM(ccc12d),
          SUM(ccc12e),SUM(ccc12f),SUM(ccc12g),SUM(ccc12h),    #No.FUN-7C0101
         #SUM(ccc21),SUM(ccc22),SUM(ccc22a),SUM(ccc22b),SUM(ccc22c),SUM(ccc22d),  #CHI-BB0010
          SUM(ccc21-ccc216),SUM(ccc22-ccc226),SUM(ccc22a-ccc22a6),SUM(ccc22b-ccc22b6),SUM(ccc22c-ccc22c6),SUM(ccc22d-ccc22d6),   #CHI-BB0010
         #SUM(ccc22e),SUM(ccc22f),SUM(ccc22g),SUM(ccc22h),    #No.FUN-7C0101  #CHI-BB0010
          SUM(ccc22e-ccc22e6),SUM(ccc22f-ccc22f6),SUM(ccc22g-ccc22g6),SUM(ccc22h-ccc22h6),    #No.FUN-7C0101   #CHI-BB0010
          SUM(ccc25),SUM(ccc26),SUM(ccc26a),SUM(ccc26b),SUM(ccc26c),SUM(ccc26d),
          SUM(ccc26e),SUM(ccc26f),SUM(ccc26g),SUM(ccc26h),    #No.FUN-7C0101
          SUM(ccc27),SUM(ccc28),SUM(ccc28a),SUM(ccc28b),SUM(ccc28c),
          SUM(ccc28d),SUM(ccc28e),SUM(ccc28f),SUM(ccc28g),SUM(ccc28h),    #No.FUN-7C0101
          SUM(ccc31),SUM(ccc32),SUM(ccc31*ccc23a),SUM(ccc31*ccc23b),
          SUM(ccc31*ccc23c), SUM(ccc31*ccc23d), SUM(ccc31*ccc23e),SUM(ccc31*ccc23f), SUM(ccc31*ccc23g), SUM(ccc31*ccc23h),SUM(ccc41), #No.FUN-7C0101
          SUM(ccc42),SUM(ccc43),SUM(ccc44),SUM(ccc51),SUM(ccc52),
         #SUM(ccc61),SUM(ccc62),SUM(ccc71),SUM(ccc72),SUM(ccc81),SUM(ccc82),  #No.FUN-660073  #CHI-BB0010
         #SUM(ccc61-ccc216),SUM(ccc62-ccc226),SUM(ccc71),SUM(ccc72),SUM(ccc81),SUM(ccc82),  #No.FUN-660073  #CHI-BB0010 #MOD-C70072 mark
          SUM(ccc61+ccc216),SUM(ccc62+ccc226),SUM(ccc71),SUM(ccc72),SUM(ccc81),SUM(ccc82),  #MOD-C70072 add
          SUM(ccc91),SUM(ccc92),SUM(ccc92a),SUM(ccc92b),SUM(ccc92c),SUM(ccc92d),
          SUM(ccc92e),SUM(ccc92f),SUM(ccc92g),SUM(ccc92h),   #No.FUN-7C0101
          SUM(ccc93)
     INTO c11,c12,c12a,c12b,c12c,c12d,c12e,c12f,c12g,c12h,  #No.FUN-7C0101
          c21,c22,c22a,c22b,c22c,c22d,c22e,c22f,c22g,c22h,  #No.FUN-7C0101
          c25,c26,c26a,c26b,c26c,c26d,c26e,c26f,c26g,c26h,  #No.FUN-7C0101
          c27,c28,c28a,c28b,c28c,c28d,c28e,c28f,c28g,c28h,  #No.FUN-7C0101
          c31,c32,c32a,c32b,c32c,c32d,c32e,c32f,c32g,c32h,  #No.FUN-7C0101
          c41,c42,c43,c44,c51,c52,c61,c62,c71,c72,c81,c82,   #No.FUN-660073
          c91,c92,c92a,c92b,c92c,c92d,c92e,c92f,c92g,c92h,c93 #No.FUN-7C0101
         FROM ccc_file
         WHERE ccc02=tm.yy AND ccc03=tm.mm
            AND ccc07 = tm.type     #FUN-840005
    #FUN-C80085---add---str
    #返工入庫合計到本月入庫中
     LET c21 = c21 + c27  LET c22 = c22 + c28  LET c22a = c22a + c28a
     LET c22b = c22b + c28b  LET c22c = c22c + c28c  LET c22d = c22d + c28d
     LET c22e = c22e + c28e  LET c22f = c22f + c28f  LET c22g = c22g + c28g LET c22h = c22h + c28h   
    #FUN-C80085---add---end   
    #FUN-C80092---add---str---
     IF tm.a = 'Y' THEN
        LET g_ckk.ckk17 = "ccc02=",tm.yy," AND cca03=",tm.mm

        CALL s_ckk_fill('','101','axc-402',tm.yy,tm.mm,g_prog,tm.type,c11,c12,c12a,c12b,c12c,c12d,
                     c12e,c12f,c12g,c12h,g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
        IF NOT s_ckk(g_ckk.*,'') THEN END IF

        CALL s_ckk_fill('','114','axc-414',tm.yy,tm.mm,g_prog,tm.type,c25,c26,c26a,c26b,c26c,c26d,
                     c26e,c26f,c26g,c26h,g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
        IF NOT s_ckk(g_ckk.*,'') THEN END IF

        CALL s_ckk_fill('','115','axc-415',tm.yy,tm.mm,g_prog,tm.type,c27,c28,c28a,c28b,c28c,c28d,
                     c28e,c28f,c28g,c28h,g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
        IF NOT s_ckk(g_ckk.*,'') THEN END IF

        LET g_ckk.ckk07 = c31 + c25     LET g_ckk.ckk08 = c32 + c26    LET g_ckk.ckk09 = c32a + c26a
        LET g_ckk.ckk10 = c32b + c26b   LET g_ckk.ckk11 = c32c + c26c  LET g_ckk.ckk12 = c32d + c26d
        LET g_ckk.ckk13 = c32e + c26e   LET g_ckk.ckk14 = c32f + c26f  LET g_ckk.ckk15 = c32g + c26g  LET g_ckk.ckk16 = c32h + c26h
        CALL s_ckk_fill('','107','axc-407',tm.yy,tm.mm,g_prog,tm.type,g_ckk.ckk07,g_ckk.ckk08,g_ckk.ckk09,g_ckk.ckk10,g_ckk.ckk11,
                        g_ckk.ckk12,g_ckk.ckk13,g_ckk.ckk14,g_ckk.ckk15,g_ckk.ckk16,g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
        IF NOT s_ckk(g_ckk.*,'') THEN END IF

        CALL s_ckk_fill('','108','axc-408',tm.yy,tm.mm,g_prog,tm.type,c41,c42,'','','','','','','','',
                        g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
        IF NOT s_ckk(g_ckk.*,'') THEN END IF

        CALL s_ckk_fill('','110','axc-410',tm.yy,tm.mm,g_prog,tm.type,c61,c62,'','','','','','','','',
                        g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
        IF NOT s_ckk(g_ckk.*,'') THEN END IF

        CALL s_ckk_fill('','109','axc-409',tm.yy,tm.mm,g_prog,tm.type,c71,c72,'','','','','','','','',
                        g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
        IF NOT s_ckk(g_ckk.*,'') THEN END IF
        
        CALL s_ckk_fill('','111','axc-411',tm.yy,tm.mm,g_prog,tm.type,c81,c82,'','','','','','','','',
                        g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
        IF NOT s_ckk(g_ckk.*,'') THEN END IF
        
        CALL s_ckk_fill('','116','axc-416',tm.yy,tm.mm,g_prog,tm.type,c91,c92,c92a,c92b,c92c,c92d,
                     c92e,c92f,c92g,c92h,g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
        IF NOT s_ckk(g_ckk.*,'') THEN END IF
        
        CALL s_ckk_fill('','113','axc-413',tm.yy,tm.mm,g_prog,tm.type,'',c93,'','','','','','','','',
                        g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
        IF NOT s_ckk(g_ckk.*,'') THEN END IF
     
     END IF
     #FUN-C80092---add---end--- 
    #add by FUN-C80085 xujing  begin-----
     SELECT
          SUM(ccc211),SUM(ccc22a1),SUM(ccc22b1),SUM(ccc22c1),SUM(ccc22d1),SUM(ccc22e1),SUM(ccc22f1),SUM(ccc22g1),SUM(ccc22h1),
          SUM(ccc212),SUM(ccc22a2),SUM(ccc22b2),SUM(ccc22c2),SUM(ccc22d2),SUM(ccc22e2),SUM(ccc22f2),SUM(ccc22g2),SUM(ccc22h2),
          SUM(ccc213),SUM(ccc22a3),SUM(ccc22b3),SUM(ccc22c3),SUM(ccc22d3),SUM(ccc22e3),SUM(ccc22f3),SUM(ccc22g3),SUM(ccc22h3),
          SUM(ccc214),SUM(ccc22a4),SUM(ccc22b4),SUM(ccc22c4),SUM(ccc22d4),SUM(ccc22e4),SUM(ccc22f4),SUM(ccc22g4),SUM(ccc22h4),
          SUM(ccc215),SUM(ccc22a5),SUM(ccc22b5),SUM(ccc22c5),SUM(ccc22d5),SUM(ccc22e5),SUM(ccc22f5),SUM(ccc22g5),SUM(ccc22h5),
          SUM(ccc216),SUM(ccc22a6),SUM(ccc22b6),SUM(ccc22c6),SUM(ccc22d6),SUM(ccc22e6),SUM(ccc22f6),SUM(ccc22g6),SUM(ccc22h6),
          SUM(ccc221),SUM(ccc222),SUM(ccc223),SUM(ccc224),SUM(ccc225),SUM(ccc226)
     INTO c111,c11a1,c11b1,c11c1,c11d1,c11e1,c11f1,c11g1,c11h1,        
          c112,c11a2,c11b2,c11c2,c11d2,c11e2,c11f2,c11g2,c11h2,            
          c113,c11a3,c11b3,c11c3,c11d3,c11e3,c11f3,c11g3,c11h3,             
          c114,c11a4,c11b4,c11c4,c11d4,c11e4,c11f4,c11g4,c11h4,             
          c115,c11a5,c11b5,c11c5,c11d5,c11e5,c11f5,c11g5,c11h5,             
          c116,c11a6,c11b6,c11c6,c11d6,c11e6,c11f6,c11g6,c11h6,
          c221,c222,c223,c224,c225,c226
         FROM ccc_file
         WHERE ccc02=tm.yy AND ccc03=tm.mm
            AND ccc07 = tm.type     #FUN-840005
#FUN-C80092---add---str---
     IF tm.a = 'Y' THEN
        LET g_ckk.ckk17 = "ccc02=",tm.yy," AND ccc03=",tm.mm
        CALL s_ckk_fill('','102','axc-403',tm.yy,tm.mm,g_prog,tm.type,c111,c221,c11a1,c11b1,c11c1,c11d1,c11e1,c11f1,c11g1,c11h1,
                       g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
        IF NOT s_ckk(g_ckk.*,'') THEN END IF

        CALL s_ckk_fill('','117','axc-457',tm.yy,tm.mm,g_prog,tm.type,c112,c222,c11a2,c11b2,c11c2,c11d2,c11e2,c11f2,c11g2,c11h2,
                       g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
        IF NOT s_ckk(g_ckk.*,'') THEN END IF
     
        CALL s_ckk_fill('','105','axc-405',tm.yy,tm.mm,g_prog,tm.type,c113,c223,c11a3,c11b3,c11c3,c11d3,c11e3,c11f3,c11g3,c11h3,
                       g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
        IF NOT s_ckk(g_ckk.*,'') THEN END IF
          
        CALL s_ckk_fill('','104','axc-404',tm.yy,tm.mm,g_prog,tm.type,c114,c224,c11a4,c11b4,c11c4,c11d4,c11e4,c11f4,c11g4,c11h4,
                       g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
        IF NOT s_ckk(g_ckk.*,'') THEN END IF
     
        CALL s_ckk_fill('','106','axc-406',tm.yy,tm.mm,g_prog,tm.type,c115,c225,c11a5,c11b5,c11c5,c11d5,c11e5,c11f5,c11g5,c11h5,
                       g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
        IF NOT s_ckk(g_ckk.*,'') THEN END IF

        CALL s_ckk_fill('','112','axc-412',tm.yy,tm.mm,g_prog,tm.type,c116,c226,c11a6,c11b6,c11c6,c11d6,c11e6,c11f6,c11g6,c11h6,
                       g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
        IF NOT s_ckk(g_ckk.*,'') THEN END IF
     END IF
#FUN-C80092---add---end---
    #add by FUN-C80085 xujing  end------ - 
     SELECT
         SUM(cch11),SUM(cch12),SUM(cch12a),SUM(cch12b),SUM(cch12c),SUM(cch12d),
         SUM(cch12e),SUM(cch12f),SUM(cch12g),SUM(cch12h),      #No.FUN-7C0101
         SUM(cch21),SUM(cch22),SUM(cch22a),SUM(cch22b),SUM(cch22c),SUM(cch22d),
         SUM(cch22e),SUM(cch22f),SUM(cch22g),SUM(cch22h),      #No.FUN-7C0101
         SUM(cch31),SUM(cch32),SUM(cch32a),SUM(cch32b),SUM(cch32c),SUM(cch32d),
         SUM(cch32e),SUM(cch32f),SUM(cch32g),SUM(cch32h),      #No.FUN-7C0101
         SUM(cch41),SUM(cch42),SUM(cch42a),SUM(cch42b),SUM(cch42c),SUM(cch42d),
         SUM(cch42e),SUM(cch42f),SUM(cch42g),SUM(cch42h),      #No.FUN-7C0101
         SUM(cch91),SUM(cch92),SUM(cch92a),SUM(cch92b),SUM(cch92c),SUM(cch92d),
         SUM(cch92e),SUM(cch92f),SUM(cch92g),SUM(cch92h)       #No.FUN-7C0101
         INTO g11,g12,g12a,g12b,g12c,g12d,g12e,g12f,g12g,g12h,    #No.FUN-7C0101
              g21,g22,g22a,g22b,g22c,g22d,g22e,g22f,g22g,g22h,    #No.FUN-7C0101
              g31,g32,g32a,g32b,g32c,g32d,g32e,g32f,g32g,g32h,    #No.FUN-7C0101
              g41,g42,g42a,g42b,g42c,g42d,g42e,g42f,g42g,g42h,    #No.FUN-7C0101
              g91,g92,g92a,g92b,g92c,g92d,g92e,g92f,g92g,g92h     #No.FUN-7C0101
         FROM cch_file
         WHERE cch02=tm.yy AND cch03=tm.mm
            AND cch06 = tm.type  #FUN-840005
       #FUN-C80092---add---str---
        IF tm.a = 'Y' THEN
           LET g_ckk.ckk17 = "cch02=",tm.yy," AND cch03=",tm.mm
           CALL s_ckk_fill('','201','axc-418',tm.yy,tm.mm,g_prog,tm.type,g11,g12,g12a,g12b,g12c,g12d,g12e,g12f,g12g,g12h,
                          g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
           IF NOT s_ckk(g_ckk.*,'') THEN END IF

           CALL s_ckk_fill('','211','axc-428',tm.yy,tm.mm,g_prog,tm.type,g31,g32,g32a,g32b,g32c,g32d,g32e,g32f,g32g,g32h,
                          g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
           IF NOT s_ckk(g_ckk.*,'') THEN END IF

           CALL s_ckk_fill('','212','axc-429',tm.yy,tm.mm,g_prog,tm.type,g41,g42,g42a,g42b,g42c,g42d,g42e,g42f,g42g,g42h,
                          g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
           IF NOT s_ckk(g_ckk.*,'') THEN END IF

           CALL s_ckk_fill('','214','axc-431',tm.yy,tm.mm,g_prog,tm.type,g91,g92,g92a,g92b,g92c,g92d,g92e,g92f,g92g,g92h,
                          g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
           IF NOT s_ckk(g_ckk.*,'') THEN END IF
        END IF
      #FUN-C80092---add---end---
     SELECT SUM(cch21),
             SUM(cch22),SUM(cch22a),SUM(cch22b),SUM(cch22c),SUM(cch22d),SUM(cch22e),SUM(cch22f),SUM(cch22g),SUM(cch22h)   #No.FUN-7C0101
        INTO q1,g23,g23a,g23b,g23c,g23d,g23e,g23f,g23g,g23h   #No.FUN-7C0101
 
         FROM cch_file
         WHERE cch02=tm.yy AND cch03=tm.mm AND cch05 IN ('M','R')
            AND cch06 = tm.type   #FUN-840005
     IF q1 IS NULL THEN
        LET q1=0 LET g23=0 LET g23a=0 LET g23b=0 LET g23c=0 LET g23d=0
        LET g23e=0   #FUN-5B0082
        LET g23f = 0 LET g23g = 0 LET g23h = 0   #No.FUN-7C0101
     END IF
 
     SELECT SUM(cch21),
            SUM(cch22),SUM(cch22a),SUM(cch22b),SUM(cch22c),SUM(cch22d),SUM(cch22e),
            SUM(cch22f),SUM(cch22g),SUM(cch22h)  #No.FUN-7C0101
       INTO q2,g24,g24a,g24b,g24c,g24d,g24e,g24f,g24g,g24h #No.FUN-7C0101    
       FROM cch_file
      WHERE cch02=tm.yy AND cch03=tm.mm AND cch04 MATCHES " DL+OH*"
         AND cch06 = tm.type   #FUN-840005
     IF q2 IS NULL THEN
        LET q2=0 LET g24=0 LET g24a=0 LET g24b=0 LET g24c=0 LET g24d=0
        LET g24e=0   #FUN-5B0082
        LET g24f = 0 LET g24g = 0 LET g24h = 0   #No.FUN-7C0101
     END IF
     #No.MOD-BB0084  --Begin
     SELECT SUM(cch31),SUM(cch32),SUM(cch32a),SUM(cch32b),SUM(cch32c),SUM(cch32d),
            SUM(cch32e),SUM(cch32f),SUM(cch32g),SUM(cch32h)
       INTO q4,g26,g26a,g26b,g26c,g26d,g26e,g26f,g26g,g26h 
      FROM cch_fle
     WHERE cch02=tm.yy AND cch03=tm.mm AND cch04 MATCHES  " DL+OH*"
       AND cch06=tm.type
     IF q4 IS NULL THEN
        LET q4=0 LET g26=0 LET g26a=0 LET g26b=0 LET g26c=0 LET g26d=0
        LET g26e=0 LET g26f = 0 LET g26g = 0 LET g26h = 0        
     END IF 
     #No.MOD-BB0084  --End
     SELECT SUM(cch21),
        SUM(cch22),SUM(cch22a),SUM(cch22b),SUM(cch22c),SUM(cch22d),SUM(cch22e),
        SUM(cch22f),SUM(cch22g),SUM(cch22h)                  #No.FUN-7C0101
        INTO q3,g25,g25a,g25b,g25c,g25d,g25e,g25f,g25g,g25h  #No.FUN-7C0101
         FROM cch_file
         WHERE cch02=tm.yy AND cch03=tm.mm AND cch04 MATCHES " ADJUST"
            AND cch06 = tm.type          #FUN-840005 
     IF q3 IS NULL THEN
        LET q3=0 LET g25=0 LET g25a=0 LET g25b=0 LET g25c=0 LET g25d=0
        LET g25e=0   #FUN-5B0082
        LET g25f = 0 LET g25g = 0 LET g25h = 0 #No.FUN-7C0101
     END IF
     LET g21 =g21 -q1  -q2  -q3
     LET g22 =g22 -g23 -g24 -g25
     LET g22a=g22a-g23a-g24a-g25a LET g22b=g22b-g23b-g24b-g25b
     LET g22c=g22c-g23c-g24c-g25c LET g22d=g22d-g23d-g24d-g25d
     LET g22e=g22e-g23e-g24e-g25e LET g22f=g22f-g23f-g24f-g25f    #No.FUN-7C0101
     LET g22g=g22g-g23g-g24g-g25g LET g22h=g22h-g23h-g24h-g25h    #No.FUN-7C0101
    #FUN-C80092---add---str---
     IF tm.a = 'Y' THEN
        LET g_ckk.ckk17 = "cch02=",tm.yy," AND cch03=",tm.mm
        LET g_ckk.ckk07 = g21 + q1
        LET g_ckk.ckk08 = g22 + g23
        LET g_ckk.ckk09 = g22a + g23a
        LET g_ckk.ckk10 = g24b
        LET g_ckk.ckk12 = g24c
        LET g_ckk.ckk11 = g24d
        LET g_ckk.ckk13 = g24e
        LET g_ckk.ckk14 = g24f
        LET g_ckk.ckk15 = g24g
        LET g_ckk.ckk16 = g24h
    
        CALL s_ckk_fill('','202','axc-419',tm.yy,tm.mm,g_prog,tm.type,g_ckk.ckk07,g_ckk.ckk08,g_ckk.ckk09,g_ckk.ckk10,g_ckk.ckk11,g_ckk.ckk12,
                        g_ckk.ckk13,g_ckk.ckk14,g_ckk.ckk15,g_ckk.ckk16,g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
        IF NOT s_ckk(g_ckk.*,'') THEN END IF
        #在制調整
         CALL s_ckk_fill('','210','axc-427',tm.yy,tm.mm,g_prog,tm.type,q3,g25,g25a,g25b,g25c,g25d,g25e,g25f,g25g,g25h,
                        g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
         IF NOT s_ckk(g_ckk.*,'') THEN END IF
     END IF
    #FUN-C80092---add---end
     SELECT
         SUM(ccu11),SUM(ccu12),SUM(ccu12a),SUM(ccu12b),SUM(ccu12c),SUM(ccu12d),
         SUM(ccu12e),SUM(ccu12f),SUM(ccu12g),SUM(ccu12h),   #No.FUN-7C0101
         SUM(ccu21),SUM(ccu22),SUM(ccu22a),SUM(ccu22b),SUM(ccu22c),SUM(ccu22d),
         SUM(ccu22e),SUM(ccu22f),SUM(ccu22g),SUM(ccu22h),   #No.FUN-7C0101
         SUM(ccu31),SUM(ccu32),SUM(ccu32a),SUM(ccu32b),SUM(ccu32c),SUM(ccu32d),
         SUM(ccu32e),SUM(ccu32f),SUM(ccu32g),SUM(ccu32h),   #No.FUN-7C0101
         SUM(ccu41),SUM(ccu42),SUM(ccu42a),SUM(ccu42b),SUM(ccu42c),SUM(ccu42d),
         SUM(ccu42e),SUM(ccu42f),SUM(ccu42g),SUM(ccu42h),   #No.FUN-7C0101
         SUM(ccu91),SUM(ccu92),SUM(ccu92a),SUM(ccu92b),SUM(ccu92c),SUM(ccu92d),
         SUM(ccu92e),SUM(ccu92f),SUM(ccu92g),SUM(ccu92h)    #No.FUN-7C0101
         INTO u11,u12,u12a,u12b,u12c,u12d,u12e,u12f,u12g,u12h,   #No.FUN-7C0101
              u21,u22,u22a,u22b,u22c,u22d,u22e,u22f,u22g,u22h,   #No.FUN-7C0101
              u31,u32,u32a,u32b,u32c,u32d,u32e,u32f,u32g,u32h,   #No.FUN-7C0101
              u41,u42,u42a,u42b,u42c,u42d,u42e,u42f,u42g,u42h,   #No.FUN-7C0101
              u91,u92,u92a,u92b,u92c,u92d,u92e,u92f,u92g,u92h    #No.FUN-7C0101
         FROM ccu_file
         WHERE ccu02=tm.yy AND ccu03=tm.mm
            AND ccu06 = tm.type    #FUN-840005
     LET u23=0 LET u24=0 LET u24a=0 LET u24b=0 LET u24c=0 LET u24d=0 LET u24e=0
     LET u24f = 0 LET u24g = 0 LET u24h = 0  #No.FUN-7C0101
     #FUN-C80092---add---str---
        IF tm.a = 'Y' THEN
           LET g_ckk.ckk17 = "ccu02=",tm.yy," AND ccu03=",tm.mm
           CALL s_ckk_fill('','213','axc-430',tm.yy,tm.mm,g_prog,tm.type,u41,u42,u42a,u42b,u42c,u42d,u42e,u42f,u42g,u42h,
                          g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
           IF NOT s_ckk(g_ckk.*,'') THEN END IF
        END IF
     #FUN-C80092---add---end---
     SELECT 
         SUM(ccu21),SUM(ccu22),SUM(ccu22a),SUM(ccu22b),SUM(ccu22c),SUM(ccu22d),SUM(ccu22e), 
         SUM(ccu22f),SUM(ccu22g),SUM(ccu22h)      #No.FUN-7C0101
         INTO u23,u24,u24a,u24b,u24c,u24d,u24e,    #MOD-7B0113-modify
              u24f,u24g,u24h   #No.FUN-7C0101
         FROM ccu_file
        WHERE ccu02=tm.yy AND ccu03=tm.mm AND ccu04 MATCHES " DL+OH*"
           AND ccu06 = tm.type   #FUN-840005
     IF u23 IS NULL THEN
        LET u23=0 LET u24=0 LET u24a=0 LET u24b=0 LET u24c=0 LET u24d=0 LET u24e=0
        LET u24f = 0 LET u24g = 0 LET u24h = 0  #No.FUN-7C0101
     END IF
     
     #No.MOD-BB0084  --Begin
     SELECT SUM(ccu31),SUM(ccu32),SUM(ccu32a),SUM(ccu32b),SUM(ccu32c),SUM(ccu32d),
            SUM(ccu32e),SUM(ccu32f),SUM(ccu32g),SUM(ccu32h) 
       INTO u25,u26,u26a,u26b,u26c,u26d,u26e,u26f,u26g,u26h 
       FROM ccu_file
      WHERE ccu02=tm.yy AND ccu03=tm.mm AND ccu04 MATCHES " DL+OH*"
       AND ccu06 = tm.type
     IF u25 IS NULL THEN
        LET u25=0 LET u26=0 LET u26a=0 LET u26b=0 LET u26c=0 LET u26d=0 LET u26e=0
        LET u26f = 0 LET u26g = 0 LET u26h = 0
     END IF
     #No.MOD-BB0084  --End

     #FUN-C80092---add---str---
     IF tm.a = 'Y' THEN
        #在制開帳調整
        IF tm.mm = 1 THEN
           LET l_pre_yy = tm.yy - 1
           LET l_pre_mm = 12
        ELSE
           LET l_pre_yy = tm.yy
           LET l_pre_mm = tm.mm - 1
        END IF
        SELECT SUM(ccf11),SUM(ccf12),SUM(ccf12a),SUM(ccf12b),SUM(ccf12c),SUM(ccf12d),
               SUM(ccf12e),SUM(ccf12f),SUM(ccf12g),SUM(ccf12h)
          INTO g_ckk.ckk07,g_ckk.ckk08,g_ckk.ckk09,g_ckk.ckk10,g_ckk.ckk12,g_ckk.ckk11,
               g_ckk.ckk13,g_ckk.ckk14,g_ckk.ckk15,g_ckk.ckk16
          FROM ccf_file
         WHERE ccf02=l_pre_yy AND ccf03=l_pre_mm AND ccf06=tm.type

         LET g_ckk.ckk17 = "ccf02=",l_pre_yy," AND ccf03=",l_pre_mm
         CALL s_ckk_fill('','215','axc-417',l_pre_yy,l_pre_mm,g_prog,tm.type,g_ckk.ckk07,g_ckk.ckk08,g_ckk.ckk09,
                         g_ckk.ckk10,g_ckk.ckk11,g_ckk.ckk12,g_ckk.ckk13,g_ckk.ckk14,g_ckk.ckk15,g_ckk.ckk16,
                        g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
         IF NOT s_ckk(g_ckk.*,'') THEN END IF

     END IF
     #FUN-C80092---add---end---
     EXECUTE insert_prep USING
        tm.type,'',    #FUN-840005
        j11,j12,j12a,j12b,j12c,j12d,j12e,j12f,j12g,j12h,        
        c11,c12,c12a,c12b,c12c,c12d,c12f,c12g,c12h,              
        c21,c22,c22a,c22b,c22c,c22d,c22f,c22g,c22h,              
        c25,c26,c26a,c26b,c26c,c26d,c26f,c26g,c26h,              
        c27,c28,c28a,c28b,c28c,c28d,c28f,c28g,c28h,              
        c31,c32,c32a,c32b,c32c,c32d,c32f,c32g,c32h,              
        c41,c42,c43,c44,c51,c52,c61,c62,c71,
        c72,c81,c82,c91,c92,c92a,c92b,c92c,c92d,c92e,c92f,c92g,c92h,  
        c93,g11,g12,g12a,g12b,g12c,g12d,g12f,g12g,g12h,         
        g21,g22,g22a,g22b,g22c,g22d,g22f,g22g,g22h,             
        g20,g23,g23a,g23b,g23c,g23d,g23f,g23g,g23h,             
        q1,q2,q3,q4,g24,g24a,g24b,g24c,g24d,g24f,g24g,g24h,         #MOD-BB0084 add q4
        #g26,g26a,g26b,g26c,g26d,g26e,g26f,g26g,g26h,                     #MOD-BB0084 #MOD-C60189 
        g25,g25a,g25b,g25c,g25d,g25f,g25g,g25h,
        g26,g26a,g26b,g26c,g26d,g26e,g26f,g26g,g26h,       #MOD-C60189    
        g31,g32,g32a,g32b,g32c,g32d,g32f,g32g,g32h,
        g41,g42,g42a,g42b,g42c,g42d,g42e,g42f,g42g,g42h,
        g91,g92,g92a,g92b,g92c,g92d,g92f,g92g,g92h,
        c12e,c22e,c26e,c28e,c32e,g12e,g22e,g23e,g24e,g25e,g32e,
        g92e,u11,u12,u12a,u12b,u12c,u12d,u12e,u12f,u12g,u12h,      
        u21,u22,u22a,u22b,u22c,u22d,u22e,u22f,u22g,u22h,
        u23,u24,u24a,u24b,u24c,u24d,u24e,u24f,u24g,u24h,         #MOD-7B0113-add
        u25,u26,u26a,u26b,u26c,u26d,u26e,u26f,u26g,u26h,         #MOD-BB0084
        u31,u32,u32a,u32b,u32c,u32d,u32e,u32f,u32g,u32h,
        u41,u42,u42a,u42b,u42c,u42d,u42e,u42f,u42g,u42h,       
        u91,u92,u92a,u92b,u92c,u92d,u92e,u92f,u92g,u92h, 
      #add by FUN-C80085 xujing 120824 begin------
        c111,c11a1,c11b1,c11c1,c11d1,c11e1,c11f1,c11g1,c11h1,        #No.FUN-7C0101
        c112,c11a2,c11b2,c11c2,c11d2,c11e2,c11f2,c11g2,c11h2,            #No.FUN-7C0101
        c113,c11a3,c11b3,c11c3,c11d3,c11e3,c11f3,c11g3,c11h3,             #No.FUN-7C0101   #MOD-7B0113-add
        c114,c11a4,c11b4,c11c4,c11d4,c11e4,c11f4,c11g4,c11h4,             #No.FUN-7C0101
        c115,c11a5,c11b5,c11c5,c11d5,c11e5,c11f5,c11g5,c11h5,             #No.FUN-7C0101
        c116,c11a6,c11b6,c11c6,c11d6,c11e6,c11f6,c11g6,c11h6,
        c221,c222,c223,c224,c225,c226
      #add by FUN-C80085 xujing 120824 end-----
    IF tm.mm<10 THEN
       LET l_mm='0',tm.mm 
    ELSE
       LET l_mm=tm.mm
    END IF
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN
       LET l_msg = "cca02=",tm.yy," AND cca03=",tm.mm," AND cca06=",tm.type
       CALL cl_wcchp(l_msg,"cca02,cca03,cca06") RETURNING g_str
    ELSE
       LET g_str = ' '
    END IF
    #LET g_str=g_ccz.ccz27,";",g_str,";",l_mm,";",tm.yy,";",g_azi04,";",g_azi03   #MOD-960288    #No.TQC-A40130 #CHI-C30012 mark
    LET g_str=g_ccz.ccz27,";",g_str,";",l_mm,";",tm.yy,";",g_ccz.ccz26,";",g_ccz.ccz26 #CHI-C30012
              ,";",g_ccz.ccz31    #FUN-C80085 add
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    IF cl_null(g_bgjob) OR g_bgjob='N' THEN #yemy 20130624  --Begin
       CALL cl_prt_cs3('axcr004','axcr004',l_sql,g_str)
    END IF                                  #yemy 20130624  --End
    CALL s_log_upd(g_cka00,'Y')             #更新日誌  #FUN-C80092
END FUNCTION
#No.FUN-9C0073 --------------------By chenls 10/01/12
