# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: almt670.4gl
# Descriptions...: 券登記/領用/退回/作廢作業
# Date & Author..: 08/11/10 By Carrier
# Modify.........: 08/12/18 By lilingyu 修改禮券面額
# Modify.........: 09/02/09 By Zhangyajun 程序客制
# Modify.........: No.FUN-960134 09/11/09 By shiwuying 移植
# Modify.........: No.FUN-9B0136 09/11/24 By shiwuying
# Modify.........: No:FUN-A10060 10/01/14 By shiwuying 權限處理
# Modify.........: No:TQC-A10173 10/02/02 By shiwuying 訂單與發售機構之間加控管
# Modify.........: No:TQC-A10165 10/02/03 By shiwuying 一個訂單+項次只能發售一次
# Modify.........: No:FUN-A30030 10/03/11 By Cockroach almt700 管控POS?關于刪除
# Modify.........: No:FUN-A30116 10/04/06 By Cockroach PASS NO.
# Modify.........: No.TQC-A60132 10/07/06 By chenmoyan 1.去掉DELETE表時使用的別名
# Modify.........: No.TQC-A70103 10/07/23 By chenmoyan 2.MSSQL語法中不能使用CONNECT BY
# Modify.........: No.FUN-A50102 10/07/24 By lutingting 跨庫語法修改
# Modify.........: No:FUN-A70130 10/08/09 By wangxin 修正取號時及check編號所傳入的模組代碼及單據性質代碼
# Modify.........: No.FUN-A70130 10/08/10 By huangtao 取消lrk_file所有相關資料
# Modify.........: No:FUN-A80008 10/08/02 By shiwuying SQL中的to_char改成BDL語法
# Modify.........: No:FUN-A80148 10/09/03 By lixh1 因為 lma_file 表已不再使用,所以將lma_file改為rtz_file的相應欄位 
# Modify.........: No.FUN-A80022 10/09/15 BY suncx add lqepos已傳POS否
# Modify.........: No:TQC-B10186 11/01/19 By shiwuying Bug修改
# Modify.........: No:TQC-B20102 11/02/18 By lilingyu 資料建立者、資料建立部門的值沒有顯示
# Modify.........: No:TQC-B30101 11/03/11 By baogc 隱藏簽核欄位,簽核狀態欄位
# Modify.........: No:FUN-B50042 11/04/28 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80060 11/08/05 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No.FUN-BA0097 11/12/12 By xumm 添加一些邏輯
# Modify.........: No.FUN-BC0048 11/12/19 By nanbing 新增共享程序 almt671
# Modify.........: No.FUN-BC0061 11/12/26 By nanbing 新增共享程序 almt672,更改almt700 
# Modify.........: No.FUN-BC0082 12/01/20 By chenwei p_ze 维护 将错误代码 clm-332  改为 alm1562  clm-333 改为 alm1563 clm-334 改为 alm1576 clm-335 改为 alm1577 
# Modify.........: No.FUN-BA0097 12/02/20 By xumm almt670BUG修改
# Modify.........: No.TQC-C30233 12/03/16 by pauline 不啟用在途判斷撥入倉是否屬於撥入營運中心時,營運中心傳入錯誤
# Modify.........: No.FUN-C30247 12/03/20 by pauline 不走在途時, t670_in_yes() 會再次產生調撥單, 導致調撥單重複.
# Modify.........: No.FUN-C30258 12/03/23 by pauline 不走在途時,未回寫調撥(撥入)單號到 lpy18
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C60079 12/06/26 by pauline 券作廢時抓取的預設單別應抓取aooi410 
# Modify.........: No.FUN-C70074 12/07/18 by pauline 券狀態訊息查詢的action當起/迄券號為null時,預設查詢全部的券資料 
# Modify.........: No.FUN-C70077 12/07/19 By baogc 由券種帶出生效截止日期
# Modify.........: No.FUN-C90070 12/09/24 By xumm 添加GR打印功能
# Modify.........: No.MOD-CA0064 12/10/18 By Vampire almi660沒有固定代號時,lpx23的長度會是null,直接用固定代號位數lpx22判斷即可,lph34的長度也直接抓lph33即可
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No:FUN-CB0110 12/11/30 By Lori 新增lqe22,lqe23,Insert lqe_file調整SQL
# Modify.........: No:FUN-CC0057 12/12/17 By xumm INSERT INTO rup_file時rup22給撥入營運中心
# Modify.........: No.FUN-CB0087 12/12/20 By xujing 倉庫單據理由碼改善
# Modify.........: No.FUN-CC0158 12/12/31 By xumm 更改拨出仓库rup09,拨入仓库rup13的取值逻辑
# Modify.........: No:CHI-C80030 13/01/18 By Lori 在almi660時未設定固定代號,所以在計算券料號的流水號位數時會發生錯誤,擷取單號資料時若lpx23為null則略過其長度
# Modify.........: No.FUN-D10040 13/01/18 By xumm 如果券类型为折扣券,券面额栏位则不能录入 
# Modify.........: No:CHI-C80041 13/01/30 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:CHI-D20015 13/03/28 By lixh1 整批修改update[確認]/[取消確認]動作時,要一併異動確認異動人員與確認異動日期
# Modify.........: No:FUN-D30033 13/04/10 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D70073 13/07/22 By SunLM 临时表p801_file，且都链接了sapmp801，应该在临时表创建时同步新增一个栏位so_price2


DATABASE ds

#TQC-B10186 Begin---
GLOBALS "../../config/top.global"
#TQC-B10186 End-----
#FUN-BC0061 add sta----
GLOBALS
DEFINE g_ina02             LIKE ina_file.ina02        
END GLOBALS
#FUN-BC0061 add end---
DEFINE g_lpy               RECORD LIKE lpy_file.*        #簽核等級 (單頭)
DEFINE g_lpy_t             RECORD LIKE lpy_file.*        #簽核等級 (舊值)
DEFINE g_lpy_o             RECORD LIKE lpy_file.*        #簽核等級 (舊值)
DEFINE g_lpy02_t           LIKE lpy_file.lpy02           #簽核等級 (舊值)
DEFINE g_lpy01             LIKE lpy_file.lpy01           #單據類型0/1/2/3
#DEFINE g_t1                LIKE lrk_file.lrkslip        #FUN-A70130    mark
#DEFINE g_sheet             LIKE lrk_file.lrkslip        #FUN-A70130    mark
DEFINE g_t1                LIKE oay_file.oayslip         #FUN-A70130
DEFINE g_sheet             LIKE oay_file.oayslip         #FUN-A70130
DEFINE g_lpz               DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
                           lpz05   LIKE lpz_file.lpz05,   #项次
                           lpz15   LIKE lpz_file.lpz15,
                           lpz15_desc   LIKE rtz_file.rtz13,
                           lpz16   LIKE lpz_file.lpz16,
                           lpz17   LIKE lpz_file.lpz17,
                           lpz02   LIKE lpz_file.lpz02,
                           lpz02_desc   LIKE lpx_file.lpx02,
                           lpz07   LIKE lpz_file.lpz07,
                           lpz07_desc LIKE lrz_file.lrz02,
                           lpz03   LIKE lpz_file.lpz03,   #券編號
                           lpz04   LIKE lpz_file.lpz04,   #券編號
                           lpz08   LIKE lpz_file.lpz08,
                           lpz09   LIKE lpz_file.lpz09,
                           lpz10   LIKE lpz_file.lpz10,
                           lpz11   LIKE lpz_file.lpz11,
                           lpz12   LIKE lpz_file.lpz12,
                           lpz13   LIKE lpz_file.lpz13,
                           lpz14   LIKE lpz_file.lpz14,
                           lpzacti LIKE lpz_file.lpzacti, 
                           lpzpos     LIKE lpz_file.lpzpos   
                           END RECORD
DEFINE g_lpz_t             RECORD                        #程式變數 (舊值)
                           lpz05   LIKE lpz_file.lpz05,   #项次
                           lpz15   LIKE lpz_file.lpz15,
                           lpz15_desc   LIKE rtz_file.rtz13,
                           lpz16   LIKE lpz_file.lpz16,
                           lpz17   LIKE lpz_file.lpz17,
                           lpz02   LIKE lpz_file.lpz02,
                           lpz02_desc   LIKE lpx_file.lpx02,
                           lpz07   LIKE lpz_file.lpz07,
                           lpz07_desc LIKE lrz_file.lrz02,
                           lpz03   LIKE lpz_file.lpz03,   #券編號
                           lpz04   LIKE lpz_file.lpz04,   #券編號
                           lpz08   LIKE lpz_file.lpz08,
                           lpz09   LIKE lpz_file.lpz09,
                           lpz10   LIKE lpz_file.lpz10,
                           lpz11   LIKE lpz_file.lpz11,
                           lpz12   LIKE lpz_file.lpz12,
                           lpz13   LIKE lpz_file.lpz13,
                           lpz14   LIKE lpz_file.lpz14,
                           lpzacti LIKE lpz_file.lpzacti, 
                           lpzpos     LIKE lpz_file.lpzpos   
                           END RECORD
DEFINE g_lpz_o             RECORD                        #程式變數 (舊值)
                           lpz05   LIKE lpz_file.lpz05,   #项次
                           lpz15   LIKE lpz_file.lpz15,
                           lpz15_desc   LIKE rtz_file.rtz13,
                           lpz16   LIKE lpz_file.lpz16,
                           lpz17   LIKE lpz_file.lpz17,
                           lpz02   LIKE lpz_file.lpz02,
                           lpz02_desc   LIKE lpx_file.lpx02,
                           lpz07   LIKE lpz_file.lpz07,
                           lpz07_desc LIKE lrz_file.lrz02,
                           lpz03   LIKE lpz_file.lpz03,   #券編號
                           lpz04   LIKE lpz_file.lpz04,   #券編號
                           lpz08   LIKE lpz_file.lpz08,
                           lpz09   LIKE lpz_file.lpz09,
                           lpz10   LIKE lpz_file.lpz10,
                           lpz11   LIKE lpz_file.lpz11,
                           lpz12   LIKE lpz_file.lpz12,
                           lpz13   LIKE lpz_file.lpz13,
                           lpz14   LIKE lpz_file.lpz14,
                           lpzacti LIKE lpz_file.lpzacti, 
                           lpzpos     LIKE lpz_file.lpzpos   
                           END RECORD
DEFINE g_sql               STRING                        #CURSOR暫存
DEFINE g_wc                STRING                        #單頭CONSTRUCT結果
DEFINE g_wc2               STRING                        #單身CONSTRUCT結果
DEFINE g_rec_b             LIKE type_file.num10          #單身筆數
DEFINE l_ac                LIKE type_file.num10          #目前處理的ARRAY CNT
DEFINE g_forupd_sql        STRING                        #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num10          #count/index for any purpose
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10          #總筆數
DEFINE g_jump              LIKE type_file.num10          #查詢指定的筆數
DEFINE g_no_ask            LIKE type_file.num10          #是否開啟指定筆視窗
DEFINE g_argv1             LIKE lpy_file.lpy01           #單據類型
DEFINE g_argv2             LIKE lpy_file.lpy02           #單據類型
#DEFINE g_kindtype          LIKE lrk_file.lrkkind     #FUN-A70130  mark
DEFINE g_kindtype          LIKE oay_file.oaytype      #FUN-A70130
DEFINE g_lpz0              LIKE type_file.chr4        #FUN-BA0097 add
DEFINE g_lpy19             LIKE type_file.chr20       #FUN-BC0048 add
DEFINE g_ruo01             LIKE ruo_file.ruo01        #FUN-BC0048 add 
DEFINE li_result           LIKE type_file.num5        #FUN-BC0048 add 
DEFINE g_dd                LIKE lpy_file.lpy17        #FUN-BC0048 add 
DEFINE g_ruo14             LIKE ruo_file.ruo14        #FUN-BC0048 add  
DEFINE g_ruo901            LIKE ruo_file.ruo901       #FUN-BC0048 add  
DEFINE g_ruo011            LIKE ruo_file.ruo011       #FUN-BC0048 add 
DEFINE g_ruo05             LIKE ruo_file.ruo05        #FUN-BC0048 add 
DEFINE g_ruo04             LIKE ruo_file.ruo04        #FUN-BC0048 add 
DEFINE g_ruoplant          LIKE ruo_file.ruo04        #FUN-BC0048 add  
DEFINE g_ruo904            LIKE ruo_file.ruo904       #FUN-BC0048 add 
DEFINE g_ina01             LIKE ina_file.ina01        #FUN-BC0048 add 
DEFINE g_yy,g_mm           LIKE type_file.num5
#FUN-C90070----add---str
DEFINE g_wc1             STRING
DEFINE g_wc3             STRING
DEFINE g_wc4             STRING
DEFINE l_table           STRING
TYPE sr1_t RECORD
    lpy01     LIKE lpy_file.lpy01, 
    lpy02     LIKE lpy_file.lpy02,
    lpy17     LIKE lpy_file.lpy17,
    lpyplant  LIKE lpy_file.lpyplant,
    lpy13     LIKE lpy_file.lpy13,
    lpy14     LIKE lpy_file.lpy14,
    lpy15     LIKE lpy_file.lpy15,
    lpy16     LIKE lpy_file.lpy16,
    lpz02     LIKE lpz_file.lpz02,
    lpz07     LIKE lpz_file.lpz07,
    lpz03     LIKE lpz_file.lpz03,
    lpz04     LIKE lpz_file.lpz04,
    lpz08     LIKE lpz_file.lpz08,
    lpz09     LIKE lpz_file.lpz09,
    lpz13     LIKE lpz_file.lpz13,
    lpz14     LIKE lpz_file.lpz14,
    rtz13     LIKE rtz_file.rtz13,
    lpx02     LIKE lpx_file.lpx02,
    lrz02     LIKE lrz_file.lrz02
END RECORD

TYPE sr2_t RECORD
    lpy01     LIKE lpy_file.lpy01, 
    lpy02     LIKE lpy_file.lpy02,
    lpy17     LIKE lpy_file.lpy17,
    lpy19     LIKE lpy_file.lpy19,
    lpy18     LIKE lpy_file.lpy18,
    lpyplant  LIKE lpy_file.lpyplant,
    lpy13     LIKE lpy_file.lpy13,
    lpy14     LIKE lpy_file.lpy14,
    lpy15     LIKE lpy_file.lpy15,
    lpy16     LIKE lpy_file.lpy16,
    lpz05     LIKE lpz_file.lpz05,
    lpz02     LIKE lpz_file.lpz02,
    lpz07     LIKE lpz_file.lpz07,
    lpz03     LIKE lpz_file.lpz03,
    lpz04     LIKE lpz_file.lpz04,
    lpz08     LIKE lpz_file.lpz08,
    rtz13     LIKE rtz_file.rtz13,
    rtz13_1   LIKE rtz_file.rtz13,
    lpx02     LIKE lpx_file.lpx02,
    lrz02     LIKE lrz_file.lrz02
END RECORD

TYPE sr3_t RECORD
    lpy01     LIKE lpy_file.lpy01, 
    lpy02     LIKE lpy_file.lpy02,
    lpy17     LIKE lpy_file.lpy17,
    lpy18     LIKE lpy_file.lpy18,
    lpyplant  LIKE lpy_file.lpyplant,
    lpy13     LIKE lpy_file.lpy13,
    lpy14     LIKE lpy_file.lpy14,
    lpy15     LIKE lpy_file.lpy15,
    lpy16     LIKE lpy_file.lpy16,
    lpz05     LIKE lpz_file.lpz05,
    lpz02     LIKE lpz_file.lpz02,
    lpz07     LIKE lpz_file.lpz07,
    lpz03     LIKE lpz_file.lpz03,
    lpz04     LIKE lpz_file.lpz04,
    lpz08     LIKE lpz_file.lpz08,
    lpz09     LIKE lpz_file.lpz09,
    rtz13     LIKE rtz_file.rtz13,
    lpx02     LIKE lpx_file.lpx02,
    lrz02     LIKE lrz_file.lrz02
END RECORD
#FUN-C90070----add---end
DEFINE g_void      LIKE type_file.chr1  #CHI-C80041

MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理

   LET g_argv1=ARG_VAL(1)                #單據類型
   LET g_argv2=ARG_VAL(2)                #單據編號

   IF cl_null(g_argv1) THEN LET g_argv1 = '0' END IF
   CASE g_argv1
        WHEN '0' LET g_prog = "almt670"
                 LET g_lpy01= "0"
                 #LET g_kindtype = '07'   #券登記 #FUN-A70130
                 LET g_kindtype = 'K5'   #券登記 #FUN-A70130
        WHEN '1' LET g_prog = "almt680"
                 LET g_lpy01= "1"
                 #LET g_kindtype = '08'   #券發售 #FUN-A70130
                 LET g_kindtype = 'K6'   #券發售 #FUN-A70130
        WHEN '2' LET g_prog = "almt690"
                 LET g_lpy01= "2"
                 #LET g_kindtype = '09'   #券退回 #FUN-A70130
                 LET g_kindtype = 'K7'   #券退回 #FUN-A70130
        WHEN '3' LET g_prog = "almt700"
                 LET g_lpy01= "3"
                 #LET g_kindtype = '10'   #券作廢 #FUN-A70130
                 LET g_kindtype = 'K8'   #券作廢 #FUN-A70130
       #FUN-BC0048 add---          
        WHEN '4' LET g_prog = "almt671"
                 LET g_lpy01= "5"   #券發放 
                 LET g_kindtype = 'N1'   #券發放 
       #FUN-BC0048 end--- 
       #FUN-BC0061 add---          
        WHEN '5' LET g_prog = "almt672"
                 LET g_lpy01= "6"   #券回收 
                 LET g_kindtype = 'N2'   #券回收 
       #FUN-BC0061 end---        
   END CASE

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   #FUN-C90070----add---str
   LET g_pdate = g_today
   IF g_argv1 = '0' THEN
      LET g_sql ="lpy01.lpy_file.lpy01,", 
                 "lpy02.lpy_file.lpy02,",
                 "lpy17.lpy_file.lpy17,",
                 "lpyplant.lpy_file.lpyplant,",
                 "lpy13.lpy_file.lpy13,",
                 "lpy14.lpy_file.lpy14,",
                 "lpy15.lpy_file.lpy15,",
                 "lpy16.lpy_file.lpy16,",
                 "lpz02.lpz_file.lpz02,",
                 "lpz07.lpz_file.lpz07,",
                 "lpz03.lpz_file.lpz03,",
                 "lpz04.lpz_file.lpz04,",
                 "lpz08.lpz_file.lpz08,",
                 "lpz09.lpz_file.lpz09,",
                 "lpz13.lpz_file.lpz13,",
                 "lpz14.lpz_file.lpz14,",
                 "rtz13.rtz_file.rtz13,",
                 "lpx02.lpx_file.lpx02,",
                 "lrz02.lrz_file.lrz02"
      LET l_table = cl_prt_temptable('almt670',g_sql) CLIPPED
      IF l_table = -1 THEN
         CALL cl_used(g_prog, g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
      LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
      PREPARE insert_prep FROM g_sql
      IF STATUS THEN
         CALL cl_err('insert_prep:',status,1)
         CALL cl_used(g_prog, g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
   END IF


   IF g_argv1 = '4' OR g_argv1 = '5' THEN
      LET g_sql ="lpy01.lpy_file.lpy01,", 
                 "lpy02.lpy_file.lpy02,",
                 "lpy17.lpy_file.lpy17,",
                 "lpy19.lpy_file.lpy19,",
                 "lpy18.lpy_file.lpy18,",
                 "lpyplant.lpy_file.lpyplant,",
                 "lpy13.lpy_file.lpy13,",
                 "lpy14.lpy_file.lpy14,",
                 "lpy15.lpy_file.lpy15,",
                 "lpy16.lpy_file.lpy16,",
                 "lpz05.lpz_file.lpz05,",
                 "lpz02.lpz_file.lpz02,",
                 "lpz07.lpz_file.lpz07,",
                 "lpz03.lpz_file.lpz03,",
                 "lpz04.lpz_file.lpz04,",
                 "lpz08.lpz_file.lpz08,",
                 "rtz13.rtz_file.rtz13,",
                 "rtz13_1.rtz_file.rtz13,",
                 "lpx02.lpx_file.lpx02,",
                 "lrz02.lrz_file.lrz02"
      LET l_table = cl_prt_temptable('almt671',g_sql) CLIPPED
      IF l_table = -1 THEN
         CALL cl_used(g_prog, g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
      LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? )"
      PREPARE insert_prep1 FROM g_sql
      IF STATUS THEN
         CALL cl_err('insert_prep1:',status,1)
         CALL cl_used(g_prog, g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
   END IF

   IF g_argv1 = '3' THEN
      LET g_sql ="lpy01.lpy_file.lpy01,",
                 "lpy02.lpy_file.lpy02,",
                 "lpy17.lpy_file.lpy17,",
                 "lpy18.lpy_file.lpy18,",
                 "lpyplant.lpy_file.lpyplant,",
                 "lpy13.lpy_file.lpy13,",
                 "lpy14.lpy_file.lpy14,",
                 "lpy15.lpy_file.lpy15,",
                 "lpy16.lpy_file.lpy16,",
                 "lpz05.lpz_file.lpz05,",
                 "lpz02.lpz_file.lpz02,",
                 "lpz07.lpz_file.lpz07,",
                 "lpz03.lpz_file.lpz03,",
                 "lpz04.lpz_file.lpz04,",
                 "lpz08.lpz_file.lpz08,",
                 "lpz09.lpz_file.lpz09,",
                 "rtz13.rtz_file.rtz13,",
                 "lpx02.lpx_file.lpx02,",
                 "lrz02.lrz_file.lrz02"
      LET l_table = cl_prt_temptable('almt700',g_sql) CLIPPED
      IF l_table = -1 THEN
         CALL cl_used(g_prog, g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
      LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,? )"
      PREPARE insert_prep2 FROM g_sql
      IF STATUS THEN
         CALL cl_err('insert_prep2:',status,1)
         CALL cl_used(g_prog, g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
   END IF
   #FUN-C90070------add-----end
   LET g_forupd_sql = "SELECT * FROM lpy_file WHERE lpy02 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t670_cl CURSOR FROM g_forupd_sql

   OPEN WINDOW t670_w WITH FORM "alm/42f/almt670"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_set_locale_frm_name("almt670")
   CALL cl_ui_init()
  
   CALL cl_set_comp_visible("lpzacti",FALSE)  #有效碼   #FUN-BA0097 add
##-TQC-B30101 ADD-BEGIN------
   CALL cl_set_comp_visible("lpy11,lpy12",FALSE)
##-TQC-B30101 ADD--END-------

   IF g_argv1 = '0' THEN  #登記
      CALL cl_set_comp_visible("lpz05",FALSE)  #單身折扣
      CALL cl_set_comp_visible("lpy08",FALSE)  #單頭折扣率
      CALL cl_set_comp_visible("lpy18",FALSE)  #來源單號  #FUN-BA0097 add
      CALL cl_set_comp_visible("lpy19",FALSE)    #FUN-BC0048 add
      CALL cl_set_comp_visible("rtz13_2",FALSE)    #FUN-BC0048 add
   END IF
   IF g_argv1 = '1' THEN  #發售
      CALL cl_set_comp_visible("lpz05",FALSE)  #單身折扣
      CALL cl_set_comp_visible("lpy19",FALSE)    #FUN-BC0048 add
      CALL cl_set_comp_visible("rtz13_2",FALSE)    #FUN-BC0048 add
   END IF
   IF g_argv1 = '2' OR g_argv1 = '3' THEN      #退回/作廢
      CALL cl_set_comp_visible("lpy08",FALSE)  #單頭折扣率
      
      CALL cl_set_comp_visible("lpy19",FALSE)    #FUN-BC0048 add
      CALL cl_set_comp_visible("rtz13_2",FALSE)    #FUN-BC0048 add
   END IF
   #FUN-BC0048 add
   IF g_argv1 = '4' OR g_argv1 = '5' THEN        
      CALL cl_set_comp_visible("lpy08",FALSE)
   END IF 
   CALL t670_field_disp()
   #FUN-BC0048 end  
   CALL t670_set_visible()

   IF NOT cl_null(g_argv2) THEN
      IF cl_chk_act_auth() THEN
         CALL t670_q()
      END IF
   ELSE
      CALL t670_menu()
   END IF

   CLOSE WINDOW t670_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)    #FUN-C90070 add
END MAIN

FUNCTION t670_set_visible()
    
    IF g_argv1 = '0' THEN 
       CALL cl_set_comp_visible('lpz13,lpz14',TRUE)
    ELSE
       CALL cl_set_comp_visible('lpz13,lpz14',FALSE)
    END IF
    IF g_argv1 = '1' OR g_argv1 = '2' THEN
          CALL cl_set_comp_visible('lpz15,lpz15_desc,lpz16,lpz17,
                                    lpz10,lpz11,lpz12',TRUE)
    ELSE
          CALL cl_set_comp_visible('lpz15,lpz15_desc,lpz16,lpz17,
                                    lpz10,lpz11,lpz12',FALSE)
    END IF
    IF g_argv1 = '3' THEN
       CALL cl_set_comp_visible('lpzpos',TRUE)
    ELSE
       CALL cl_set_comp_visible('lpzpos',FALSE)
    END IF 
    #FUN-BC0048 start---
    IF g_argv1 = '4' OR g_argv1 = '5' THEN 
       CALL cl_set_comp_visible('lpz09,lpz13,lpz13,lpzacti',FALSE)
    END IF    
    #FUN-BC0048 end---
    CALL cl_set_comp_visible('lpzpos',FALSE) #FUN-B50042
    CALL cl_set_comp_entry("lpyplant",FALSE)
END FUNCTION

#QBE 查詢資料
FUNCTION t670_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01

   CLEAR FORM
   CALL g_lpz.clear()

   IF NOT cl_null(g_argv2) THEN
      LET g_wc = " lpy02 = '",g_argv2,"'"
   ELSE
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_lpy.* TO NULL
        #FUN-BC0048 start  
    #  CONSTRUCT BY NAME g_wc ON lpyplant,lpylegal,lpy02,lpy17,lpy11,lpy12,lpy13,
    #                            lpy14,lpy15,lpy16,lpyuser,lpygrup,lpyoriu,lpyorig,
      CONSTRUCT BY NAME g_wc ON lpy02,lpy17,lpy19,lpy18,lpyplant,lpylegal,lpy11,lpy12,lpy13,
                                lpy14,lpy15,lpy16,lpyuser,lpygrup,lpyoriu,lpyorig,
                                lpycrat,lpymodu,lpyacti,lpydate
        #FUN-BC0048 end                            
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION controlp
            CASE
               WHEN INFIELD(lpy02)               #單據編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lpy02"
                  LET g_qryparam.arg1 =g_lpy01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpy02
                  NEXT FIELD lpy02
               WHEN INFIELD(lpyplant)               #門店
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lpyplant"
                  LET g_qryparam.arg1 =g_lpy01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpyplant
                  NEXT FIELD lpyplant
               WHEN INFIELD(lpylegal)               #法人
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lpylegal"
                  LET g_qryparam.arg1 =g_lpy01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpylegal
                  NEXT FIELD lpylegal
               WHEN INFIELD(lpy14)               #審核人
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lpy14"
                  LET g_qryparam.arg1 =g_lpy01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpy14
                  NEXT FIELD lpy14
               #FUN-BC0048 start
               WHEN INFIELD(lpy19)               #審核人
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lpy19"
                  LET g_qryparam.arg1 =g_lpy01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpy19
                  NEXT FIELD lpy19
               #FUN-BC0048 end   
               OTHERWISE EXIT CASE
            END CASE

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT

      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
   #FUN-C90070---add---str
   IF g_wc = " 1=1" THEN
      LET g_wc = "lpy01 = '",g_lpy01,"'"
   ELSE
      LET g_wc = g_wc CLIPPED," AND lpy01 = '",g_lpy01,"'"
   END IF
   #FUN-C90070---add---end
   #LET g_wc = g_wc CLIPPED," AND lpy01 = '",g_lpy01,"'"   #FUN-C90070 mark
   #資料權限的檢查
   IF g_priv2='4' THEN                           #只能使用自己的資料
      LET g_wc = g_wc clipped," AND lpyuser = '",g_user,"'"
   END IF

   IF g_priv3='4' THEN                           #只能使用相同群的資料
      LET g_wc = g_wc clipped," AND lpygrup MATCHES '",g_grup CLIPPED,"*'"
   END IF

   IF g_priv3 MATCHES "[5678]" THEN    #
      LET g_wc = g_wc clipped," AND lpygrup IN ",cl_chk_tgrup_list()
   END IF

   IF NOT cl_null(g_argv2) THEN
      LET g_wc2 = ' 1=1'
   ELSE
      CONSTRUCT g_wc2 ON lpz05,lpz15,lpz16,
                         lpz17,lpz02,lpz07,
                         lpz03,lpz04,lpz08,
                         lpz09,lpz10,lpz11,
                         lpz12,lpz13,lpz14,
                         lpzacti
                FROM s_lpz[1].lpz05,s_lpz[1].lpz15,s_lpz[1].lpz16,
                     s_lpz[1].lpz17,s_lpz[1].lpz02,s_lpz[1].lpz07,
                     s_lpz[1].lpz03,s_lpz[1].lpz04,s_lpz[1].lpz08,
                     s_lpz[1].lpz09,s_lpz[1].lpz10,s_lpz[1].lpz11,
                     s_lpz[1].lpz12,s_lpz[1].lpz13,s_lpz[1].lpz14,
                     s_lpz[1].lpzacti                               #FUN-B50042 remove POS

         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         ON ACTION controlp
            CASE
              WHEN INFIELD(lpz15)               #发售机构
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lpz15"
                  LET g_qryparam.arg1 =g_lpy01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpz15
                  NEXT FIELD lpz15
              WHEN INFIELD(lpz16)               #订单号
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lpz16"
                  LET g_qryparam.arg1 =g_lpy01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpz16
                  NEXT FIELD lpz16
              WHEN INFIELD(lpz17)               #订单项次
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lpz17"
                  LET g_qryparam.arg1 =g_lpy01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpz17
                  NEXT FIELD lpz17
              WHEN INFIELD(lpz02)               #券類型編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lpz02"
                  LET g_qryparam.arg1 =g_lpy01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpz02
                  NEXT FIELD lpz02
               WHEN INFIELD(lpz07)               #券面額編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lpz07"
                  LET g_qryparam.arg1 =g_lpy01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpz07
                  NEXT FIELD lpz07
            END CASE
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION qbe_save
            CALL cl_qbe_save()

      END CONSTRUCT
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF

   #LET g_wc2 = g_wc2 CLIPPED," AND lpz01 ='",g_lpy01,"'"

   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT lpy02 FROM lpy_file ",
                  " WHERE ", g_wc CLIPPED,
                # "   AND lpyplant IN ",g_auth,
                  " ORDER BY lpy02"
   ELSE                                    # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE lpy02 ",
                  "  FROM lpy_file, lpz_file ",
                  " WHERE lpy02 = lpz01 ",
                  "   AND lpy01 = lpz06 ",
                  "   AND lpz06 ='",g_lpy01,"'",
                # "   AND lpyplant IN ",g_auth,
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY lpy02"
   END IF

   PREPARE t670_prepare FROM g_sql
   DECLARE t670_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t670_prepare

   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM lpy_file WHERE ",g_wc CLIPPED
               #"   AND lpyplant IN ",g_auth
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT lpy02) FROM lpy_file,lpz_file",
                " WHERE lpy02 = lpz01 ",
                "   AND lpy01 = lpz06 ",
                "   AND lpz06 ='",g_lpy01,"'",
               #"   AND lpyplant IN ",g_auth,
                "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
   END IF

   PREPARE t670_precount FROM g_sql
   DECLARE t670_count CURSOR FOR t670_precount

END FUNCTION

FUNCTION t670_menu()

   WHILE TRUE
      CALL t670_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t670_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t670_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t670_r()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t670_u()
            END IF

#FUN-C90070------add------str
        WHEN "output"
           IF cl_chk_act_auth() THEN
              IF g_argv1 = '0' THEN
                 CALL t670_out()
              END IF
              IF g_argv1 = '4' OR g_argv1 = '5' THEN
                 CALL t671_out()
              END IF
              IF g_argv1 = '3' THEN
                 CALL t700_out()
              END IF
           END IF
#FUN-C90070------add------end

         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t670_x()
            END IF

        #WHEN "reproduce"
        #   IF cl_chk_act_auth() THEN
        #      CALL t670_copy()
        #   END IF

        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL t670_b()
           ELSE
              LET g_action_choice = NULL
           END IF

        #WHEN "output"
        #   IF cl_chk_act_auth() THEN
        #      CALL t670_out()
        #   END IF

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t670_y()
            END IF

         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t670_z()
            END IF
        #FUN-BC0048 start
         WHEN "coupon_state"
            IF cl_chk_act_auth() THEN
               CALL t670_coupon_state()
            END IF
         WHEN "dial_out"
            IF cl_chk_act_auth() THEN
               CALL t670_dial_out()
            END IF  
         WHEN "dial_in"
            IF cl_chk_act_auth() THEN 
               CALL t670_dial_out()
            END IF    
        #FUN-BC0048 end
        #FUN-BC0061 start
         WHEN "scrap_note"
            IF cl_chk_act_auth() THEN
               CALL t670_scrap_note()
            END IF
        #FUN-BC0061 end
         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lpz),'','')
            END IF

         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_lpy.lpy02 IS NOT NULL THEN
             # LET g_doc.column1 = "lpy02"
             # LET g_doc.value1 = g_lpy.lpy02
             # CALL cl_doc()
            END IF
         END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t670_c()
               IF g_lpy.lpy13 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF 
               CALL cl_set_field_pic(g_lpy.lpy13,g_lpy.lpy12,'','',g_void,g_lpy.lpyacti)
            END IF
         #CHI-C80041---end
      END CASE
   END WHILE
END FUNCTION

FUNCTION t670_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lpz TO s_lpz.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
       #  IF g_lpy01 MATCHES '[123]' THEN    #FUN-BC0048 mark
         IF g_lpy01 MATCHES '[12]' THEN #FUN-BC0048 add
            CALL cl_set_act_visible("undo_confirm", FALSE)
            CALL cl_set_act_visible("coupon_state,dial_out,dial_in,scrap_note",FALSE) #FUN-BC0048 add
         END IF
         #FUN-BC0048 start
         IF g_lpy01 MATCHES '[0]' THEN 
            CALL cl_set_act_visible("coupon_state,dial_out,dial_in,scrap_note",FALSE)
         END IF    
         IF g_lpy01 MATCHES '[5]' THEN 
            CALL cl_set_act_visible("undo_confirm,scrap_note,dial_in", FALSE)
            CALL cl_set_act_visible("coupon_state,dial_out",TRUE)
         END IF
         #FUN-BC0048 end 
         #FUN-BC0061 start
         IF g_lpy01 MATCHES '[6]' THEN 
            CALL cl_set_act_visible("undo_confirm,scrap_note,dial_out", FALSE)
            CALL cl_set_act_visible("coupon_state,dial_in",TRUE)
         END IF
         
         IF g_lpy01 MATCHES '[3]' THEN 
            CALL cl_set_act_visible("undo_confirm,dial_out,dial_in", FALSE)
            CALL cl_set_act_visible("coupon_state,scrap_note",TRUE)
         END IF
         #FUN-BC0061 end
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY

      #FUN-C90070---add---str
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      #FUN-C90070---add---end

      ON ACTION first
         CALL t670_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION previous
         CALL t670_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION jump
         CALL t670_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION next
         CALL t670_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION last
         CALL t670_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY

     #ON ACTION reproduce
     #   LET g_action_choice="reproduce"
     #   EXIT DISPLAY

     ON ACTION detail
        LET g_action_choice="detail"
        LET l_ac = 1
        EXIT DISPLAY

     #ON ACTION output
     #   LET g_action_choice="output"
     #   EXIT DISPLAY

      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY

      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      #FUN-BC0048 start
      ON ACTION coupon_state
         LET g_action_choice="coupon_state"
         EXIT DISPLAY 
      ON ACTION dial_out
         LET g_action_choice="dial_out"
         EXIT DISPLAY    
      #FUN-BC0048 end   
      #FUN-BC0061 start
      ON ACTION dial_in
         LET g_action_choice="dial_in"
         EXIT DISPLAY
      ON ACTION scrap_note
         LET g_action_choice="scrap_note"
         EXIT DISPLAY
      #FUN-BC0061 end
#      ON ACTION gen_body
#         LET g_action_choice="gen_body"
#         EXIT DISPLAY

#      ON ACTION delete_body
#         LET g_action_choice="delete_body"
#         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL t670_field_disp()
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

      &include "qry_string.4gl"

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t670_bp_refresh()
  DISPLAY ARRAY g_lpz TO s_lpz.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY

     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY

END FUNCTION

#TQC-A70103 --Begin
FUNCTION t670_create_sql()
DEFINE l_sql STRING
      LET l_sql="drop procedure t670_proc2"
      EXECUTE IMMEDIATE l_sql
      LET l_sql=" create procedure t670_proc2 @v1 integer,@v2 integer,"
          ||" @v3 integer,@v4 nvarchar(20),@v5 nvarchar(1),"
          ||" @v9 nvarchar(20),@v10 nvarchar(10),"
          ||" @v11 decimal(5,2),@v12 nvarchar(10),"
          ||" @v7 nvarchar(20),@v8 integer,@v6 integer output"
          ||" as begin"
          ||" declare @i integer"
          ||" set @i = 0"
          ||" set @v6 = 0"
          ||" while @i < @v3"
          ||" begin "
          ||" INSERT INTO t670_tmp9(lpz01,lpz04,lpz06,lpz02,lpz07,lpz10,lpz15) "
          ||" SELECT @v4 as lpz01,(ltrim(@v7) +"
          ||" substring(cast(cast(power(10,@v8-len(@v1+@i)) as varchar) + cast((@i+@v1) as varchar) as varchar),2,@v8))"
          ||" as lpz041,@v5 as lpz06,@v9 as lpz02,@v10 as lpz07,@v11 as lpz10,@v12 as lpz15"
          ||" set @v6=@v6+1"
          ||" set @i = @i+1"
          ||" end"
          ||" end"
      EXECUTE IMMEDIATE l_sql
      PREPARE stmt FROM "{ CALL t670_proc2(?,?,?,?,?,?,?,?,?,?,?,?) }"
END FUNCTION
FUNCTION t670_create_sql1()
DEFINE l_sql STRING
      LET l_sql="drop procedure t670_proc1"
      EXECUTE IMMEDIATE l_sql
      LET l_sql=" create procedure t670_proc1 @v1 integer,@v2 integer,"
          ||" @v3 integer,@v7 nvarchar(20),@v8 integer"
          ||" as begin"
          ||" declare @i integer"
          ||" set @i = 0"
          ||" while @i < @v3"
          ||" begin "
          ||" INSERT INTO t670_tmp5 "
          ||" SELECT (ltrim(@v7) +"
          ||" substring(cast(cast(power(10,@v8-len(@v1+@i)) as varchar) + cast((@i+@v1) as varchar) as varchar),2,@v8))"
          ||" set @i = @i+1"
          ||" end"
          ||" end"
      EXECUTE IMMEDIATE l_sql
      PREPARE stmt1 FROM "{ CALL t670_proc1(?,?,?,?,?) }"
END FUNCTION
#TQC-A70103 --End

FUNCTION t670_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10

   MESSAGE ""
   CLEAR FORM
   CALL g_lpz.clear()
   LET g_wc = NULL
   LET g_wc2= NULL

   IF s_shut(0) THEN
      RETURN
   END IF

   INITIALIZE g_lpy.* LIKE lpy_file.*             #DEFAULT 設定
   LET g_lpy02_t = NULL

   #預設值及將數值類變數清成零
   LET g_lpy_t.* = g_lpy.*
   LET g_lpy_o.* = g_lpy.*
   CALL cl_opmsg('a')

   WHILE TRUE
      LET g_lpy.lpy01 = g_lpy01
      LET g_lpy.lpy17 = g_today
      LET g_lpy.lpyplant = g_plant
      LET g_lpy.lpylegal = g_legal
      LET g_lpy.lpy06 = 0        #券張數
      LET g_lpy.lpy07 = 0        #總金額
      LET g_lpy.lpy08 = 0        #折扣率
      LET g_lpy.lpy09 = 0        #折扣金額
      LET g_lpy.lpy10 = 0        #實際金額
      LET g_lpy.lpy11 = 'N'      #簽核否
      LET g_lpy.lpy12 = '0'      #簽核狀態
      LET g_lpy.lpy13 = 'N'      #審核狀態
      LET g_lpy.lpyuser=g_user
      LET g_lpy.lpygrup=g_grup
      LET g_lpy.lpyoriu=g_user     #TQC-B20102
      LET g_lpy.lpyorig=g_grup     #TQC-B20102 
      LET g_lpy.lpycrat=g_today
      LET g_lpy.lpyacti='Y'      #資料有效
      LET g_data_plant = g_plant #No.FUN-A10060

      CALL t670_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_lpy.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      IF cl_null(g_lpy.lpy02) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF

      #輸入後, 若該單據需自動編號, 並且其單號為空白, 則自動賦予單號
      BEGIN WORK
      CALL s_auto_assign_no("alm",g_lpy.lpy02,g_lpy.lpy17,g_kindtype,"lpy_file","lpy02",g_lpy.lpyplant,"","")
           RETURNING li_result,g_lpy.lpy02
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_lpy.lpy02

      LET g_lpy.lpyoriu = g_user      #No.FUN-980030 10/01/04
      LET g_lpy.lpyorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO lpy_file VALUES (g_lpy.*)

      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
      #   ROLLBACK WORK                   # FUN-B80060 下移兩行
         CALL cl_err3("ins","lpy_file",g_lpy.lpy02,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK                   # FUN-B80060
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_lpy.lpy02,'I')
      END IF

      LET g_lpy02_t = g_lpy.lpy02        #保留舊值
      LET g_lpy_t.* = g_lpy.*
      LET g_lpy_o.* = g_lpy.*
      CALL g_lpz.clear()

      LET g_rec_b = 0
#     CALL t670_gen_body()
      CALL t670_b()
      EXIT WHILE
   END WHILE

END FUNCTION

FUNCTION t670_u()
   DEFINE l_lrz02       LIKE lrz_file.lrz02
   DEFINE l_lpz05       LIKE lpz_file.lpz05

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lpy.lpy02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_lpy.* FROM lpy_file
    WHERE lpy02=g_lpy.lpy02
   #不可跨門店改動資料
   IF g_lpy.lpyplant <> g_plant THEN
      CALL cl_err(g_lpy.lpyplant,'alm-399',0)
      RETURN
   END IF

   IF g_lpy.lpyacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_lpy.lpy02,'mfg1000',0)
      RETURN
   END IF
   IF g_lpy.lpy13 = 'Y' THEN
      CALL cl_err(g_lpy.lpy02,'mfg1005',0)
      RETURN
   END IF
   IF g_lpy.lpy13 = 'X' THEN RETURN END IF  #CHI-C80041

   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lpy02_t = g_lpy.lpy02
   BEGIN WORK

   OPEN t670_cl USING g_lpy.lpy02
   IF STATUS THEN
      CALL cl_err("OPEN t670_cl:", STATUS, 1)
      CLOSE t670_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t670_cl INTO g_lpy.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_lpy.lpy02,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE t670_cl
       ROLLBACK WORK
       RETURN
   END IF

   CALL t670_show()

   WHILE TRUE
      LET g_lpy02_t = g_lpy.lpy02
      LET g_lpy_o.* = g_lpy.*
      LET g_lpy.lpymodu=g_user
      LET g_lpy.lpydate=g_today

      CALL t670_i("u")                      #欄位更改

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lpy.*=g_lpy_t.*
         CALL t670_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF

      IF g_lpy_t.lpy04 <> g_lpy.lpy04 OR         # 券類型編號
         g_lpy_t.lpy05 <> g_lpy.lpy05 AND g_lpy01 <> '0' THEN
         DELETE FROM lpz_file WHERE lpz02 = g_lpy02_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","lpz_file",g_lpy02_t,"",SQLCA.sqlcode,"","lpz",1)
            CONTINUE WHILE
         END IF
         CALL t670_upd_head()
      END IF
      IF g_lpy.lpy02 != g_lpy02_t THEN            # 更改單號
         UPDATE lpz_file SET lpz02 = g_lpy.lpy02
          WHERE lpz02 = g_lpy02_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lpz_file",g_lpy02_t,"",SQLCA.sqlcode,"","lpz",1)
            CONTINUE WHILE
         END IF
      END IF

      IF g_lpy_t.lpy05 <> g_lpy.lpy05 AND g_lpy01 = '0' THEN
         CALL t670_upd_head()
      END IF

      IF g_lpy_t.lpy08 <> g_lpy.lpy08 THEN          # 券折扣率
         IF g_lpy01 = '1' THEN
            SELECT lrz02 INTO l_lrz02 FROM lrz_file  # 面額
             WHERE lrz01 = g_lpy.lpy05
            IF cl_null(l_lrz02) THEN
               LET l_lrz02 = 0
            END IF
            LET l_lpz05 = l_lrz02 * (100-g_lpy.lpy08) / 100
            IF cl_null(l_lpz05) THEN LET l_lpz05 = 0 END IF
            UPDATE lpz_file SET lpz05 = l_lpz05
             WHERE lpz02 = g_lpy.lpy02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","lpz_file",g_lpy02_t,"",SQLCA.sqlcode,"","lpz",1)
               CONTINUE WHILE
            END IF
         END IF
         CALL t670_upd_head()
      END IF

      UPDATE lpy_file SET lpy_file.* = g_lpy.*
       WHERE lpy02 = g_lpy02_t
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lpy_file",g_lpy02_t,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE

   CLOSE t670_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lpy.lpy02,'U')

   CALL t670_show()
   CALL t670_b_fill("1=1")
   CALL t670_bp_refresh()

END FUNCTION

FUNCTION t670_i(p_cmd)
   DEFINE l_n         LIKE type_file.num10
   DEFINE p_cmd       LIKE type_file.chr1     #a:輸入 u:更改
   DEFINE li_result   LIKE type_file.num5
   DEFINE l_lpx28     LIKE lpx_file.lpx28
   DEFINE l_lrz02     LIKE lrz_file.lrz02
   DEFINE l_rtz13     LIKE rtz_file.rtz13  #FUN-BC0048 add
   IF s_shut(0) THEN
      RETURN
   END IF

   DISPLAY BY NAME g_lpy.lpy01,g_lpy.lpyplant,g_lpy.lpylegal,g_lpy.lpy11,
                   g_lpy.lpy12,g_lpy.lpy13,g_lpy.lpy17,
                   g_lpy.lpy18,g_lpy.lpy19, #FUN-BC0048 add
                   g_lpy.lpyoriu,g_lpy.lpyorig,            #TQC-B20102
                   g_lpy.lpyuser,g_lpy.lpymodu,g_lpy.lpycrat,
                   g_lpy.lpygrup,g_lpy.lpydate,g_lpy.lpyacti
   CALL t670_lpyplant('d')
   
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_lpy.lpy02,g_lpy.lpy17, g_lpy.lpy18,g_lpy.lpy19,g_lpy.lpyplant,g_lpy.lpy16   #FUN-BC0048 add lpy18,lpy19
         WITHOUT DEFAULTS

      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t670_set_entry(p_cmd)
         CALL t670_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("lpy02")
         CALL t670_act_disp()
      AFTER FIELD lpy02
         #單號處理方式:
         #在輸入單別後, 至單據性質檔中讀取該單別資料;
         #若該單別不需自動編號, 則讓使用者自行輸入單號, 並檢查其是否重複
         #若要自動編號, 則單號不用輸入, 直到單頭輸入完成後, 再行自動指定單號
         IF NOT cl_null(g_lpy.lpy02) THEN
            IF (p_cmd='a') OR (p_cmd='u' AND g_lpy.lpy02!=g_lpy_t.lpy02) THEN    #FUN-BA0097 add
               CALL s_check_no("alm",g_lpy.lpy02,g_lpy02_t,g_kindtype,"lpy_file","lpy02","")
                    RETURNING li_result,g_lpy.lpy02
               IF (NOT li_result) THEN
                  LET g_lpy.lpy02=g_lpy_o.lpy02
                  NEXT FIELD lpy02
               END IF
               DISPLAY BY NAME g_lpy.lpy02
               IF cl_null(g_lpy_o.lpy02) OR (g_lpy.lpy02 <> g_lpy_o.lpy02) THEN
              #    LET g_lpy.lpy11 = g_lrk.lrkapr  #簽核否    #FUN-A70130 mark  
                   LET g_lpy.lpy11 = g_oay.oayapr            #FUN-A70130
               END IF
            END IF    #FUN-BA0097 add
         END IF

     #AFTER FIELD lpyplant                  #門店編號
     #   IF NOT cl_null(g_lpy.lpyplant) THEN
     #      IF g_lpy_o.lpyplant IS NULL OR g_lpy_o.lpyplant != g_lpy.lpyplant THEN
     #         CALL t670_lpyplant(p_cmd)
     #         IF NOT cl_null(g_errno) THEN
     #            CALL cl_err(g_lpy.lpyplant,g_errno,0)
     #            LET g_lpy.lpyplant = g_lpy_o.lpyplant
     #            DISPLAY BY NAME g_lpy.lpyplant
     #            NEXT FIELD lpyplant
     #         END IF
     #      END IF
     #      LET g_lpy_o.lpyplant = g_lpy.lpyplant
     #   END IF
     #FUN-BC0048 start---
      AFTER FIELD lpy19
         IF NOT cl_null(g_lpy.lpy19) THEN 
            CALL t670_lpy19(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_lpy.lpy19,g_errno,0)
               LET g_lpy.lpy19 = g_lpy_o.lpy19
               DISPLAY BY NAME g_lpy.lpy19
               NEXT FIELD lpy19
            END IF
         END IF
    
      ON ACTION coupon_state
         CALL t670_coupon_state()
      ON ACTION dial_out
         CALL t670_dial_out() 
      ON ACTION scrap_note
         CALL t670_scrap_note()
      ON ACTION dial_in
         CALL t670_dial_out() 
      #FUN-BC0048 end --- 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

      ON ACTION controlp
         CASE
            WHEN INFIELD(lpy02)     #單據編號
               LET g_t1=s_get_doc_no(g_lpy.lpy02)
              # CALL q_lrk(FALSE,FALSE,g_t1,g_kindtype,'ALM') RETURNING g_t1      #FUN-A70130  mark
               CALL q_oay(FALSE,FALSE,g_t1,g_kindtype,'ALM') RETURNING g_t1      #FUN-A70130  add
               LET g_lpy.lpy02 = g_t1
               DISPLAY BY NAME g_lpy.lpy02
               NEXT FIELD lpy02
      #     WHEN INFIELD(lpyplant)     #門店編號
      #        CALL cl_init_qry_var()
      #        LET g_qryparam.form ="q_lma_x"
      #        LET g_qryparam.default1 = g_lpy.lpyplant
      #        CALL cl_create_qry() RETURNING g_lpy.lpyplant
      #        DISPLAY BY NAME g_lpy.lpyplant
      #        CALL t670_lpyplant('d')
      #        NEXT FIELD lpyplant
           #FUN-BC0048 start ---
           WHEN INFIELD(lpy19)     
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_lpy19_i"
              LET g_qryparam.default1 = g_lpy.lpy19
              CALL cl_create_qry() RETURNING g_lpy.lpy19,l_rtz13
              DISPLAY BY NAME g_lpy.lpy19
              DISPLAY l_rtz13 TO rtz13_2
              CALL t670_lpy19('d')
              NEXT FIELD lpy19
           #FUN-BC0048 end ---
            OTHERWISE EXIT CASE
          END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

   END INPUT
   
END FUNCTION

FUNCTION t670_lpyplant(p_cmd)  #門店編號
 DEFINE l_rtz13      LIKE rtz_file.rtz13    #FUN-A80148
 DEFINE l_rtz28      LIKE rtz_file.rtz28
#DEFINE l_rtzacti    LIKE rtz_file.rtzacti    #FUN-A80148 mark by vealxu
 DEFINE l_azwacti    LIKE azw_file.azwacti    #FUN-A80148 add by vealxu   
 DEFINE p_cmd        LIKE type_file.chr1
 DEFINE l_azt02      LIKE azt_file.azt02
 
    LET g_errno = " "
 
    SELECT rtz13,rtz28,azwacti                          #FUN-A80148 rtzacti -> azwacti by vealxu
      INTO l_rtz13,l_rtz28,l_azwacti                    #FUN-A80148 l_rtzacti ->l_azwacti  by vealxu  
      FROM rtz_file INNER JOIN azw_file                 #FUN-A80148 add azw_file by vealxu
        ON rtz01 = azw01                                #FUN-A80148 add by vealxu
     WHERE rtz01 = g_lpy.lpyplant
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm-001'  #該門店編號不存在
                                   LET l_rtz13 = NULL
         WHEN l_rtz28 = 'N'        LET g_errno = 'alm-002'  #該筆門店資料未審核
       # WHEN l_rtzacti = 'N'      LET g_errno = 'aap-223'  #該門店編號無效!              #FUN-A80148 mark by vealxu
         WHEN l_azwacti = 'N'      LET g_errno = 'aap-223'  #該門店編號無效!              #FUN-A80148 add by vealxu
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
   #IF cl_null(g_errno) THEN
   #   LET g_sql = "SELECT * FROM aza_file WHERE '",g_lpy.lpyplant,"' IN ",g_auth
   #   PREPARE lpyplant_p1 FROM g_sql
   #   EXECUTE lpyplant_p1
   #   IF SQLCA.sqlcode THEN
   #      LET g_errno = 'alm-391'   #當前用戶不可存取此門店!
   #   END IF
   #END IF
 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       SELECT azt02 INTO l_azt02 FROM azt_file
        WHERE azt01 = g_lpy.lpylegal
       DISPLAY l_azt02 TO FORMONLY. azt02
       DISPLAY l_rtz13 TO FORMONLY.rtz13
    END IF
 
END FUNCTION

FUNCTION t670_lpz02(p_cmd)  #券類型編號
 DEFINE l_lpx02      LIKE lpx_file.lpx02
 DEFINE l_lpx15      LIKE lpx_file.lpx15
 DEFINE l_lpxacti    LIKE lpx_file.lpxacti
 DEFINE p_cmd        LIKE type_file.chr1
 DEFINE l_cnt     LIKE type_file.num5

   LET g_errno = " "

   SELECT lpx02,lpx15,lpxacti
     INTO l_lpx02,l_lpx15,l_lpxacti
     FROM lpx_file
    WHERE lpx01 = g_lpz[l_ac].lpz02

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm-960'  #無此券類型編號
                                  LET l_lpx02 = NULL
        WHEN l_lpx15 = 'N'        LET g_errno = '9029'     #此筆資料尚未審核, 不可使用
        WHEN l_lpxacti = 'N'      LET g_errno = 'mfg0301'  #本筆資料無效
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) THEN
       SELECT COUNT(*) INTO l_cnt FROM lnk_file
        WHERE lnk01 = g_lpz[l_ac].lpz02
          AND lnk02 = '2'
          AND lnk03 = g_lpy.lpyplant
          AND lnk05 = 'Y'
       IF l_cnt < 1 THEN   #該券在當前門店中無生效資料,請檢查almi660的券使用範圍!
          LET g_errno = 'alm-395'
       END IF
   END IF

#FUN-BA0097----mark---str----
#  IF cl_null(g_errno) OR p_cmd = 'd' THEN
#     DISPLAY l_lpx02 TO FORMONLY.lpx02
#  END IF
#FUN-BA0097----mark---end----
END FUNCTION

#FUN-BA0097--------add------str-------
FUNCTION t670_lpz02_1()
DEFINE l_lpx02     LIKE lpx_file.lpx02,
       l_lpx28     LIKE lpx_file.lpx28,
       l_lrz02     LIKE lrz_file.lrz02,
       l_lpx32     LIKE lpx_file.lpx32
DEFINE l_lpx03     LIKE lpx_file.lpx03 #FUN-C70077 Add
DEFINE l_lpx04     LIKE lpx_file.lpx04 #FUN-C70077 Add
DEFINE l_lpx26     LIKE lpx_file.lpx25 #FUN-D10040 add


  #FUN-C70077 Mark&Add Begin ---
  #SELECT lpx02,lpx28,lrz02,lpx32 
  #  INTO l_lpx02,l_lpx28,l_lrz02,l_lpx32
  #SELECT lpx02,lpx28,lrz02,lpx32,lpx03,lpx04             #FUN-D10040 mark
  #  INTO l_lpx02,l_lpx28,l_lrz02,l_lpx32,l_lpx03,l_lpx04 #FUN-D10040 mark
  #FUN-C70077 Mark&Add End -----
   SELECT lpx02,lpx28,lrz02,lpx32,lpx03,lpx04,lpx26       #FUN-D10040 add
     INTO l_lpx02,l_lpx28,l_lrz02,l_lpx32,l_lpx03,l_lpx04,l_lpx26   #FUN-D10040 add
     FROM lpx_file
LEFT JOIN lrz_file
       ON lpx28 = lrz01
    WHERE lpx15 = 'Y'
      AND lpx01 = g_lpz[l_ac].lpz02

    #IF NOT cl_null(l_lpx28) THEN           #FUN-D10040 mark
    IF l_lpx26 = '2' THEN                   #FUN-D10040 add
       CALL cl_set_comp_entry("lpz07",FALSE) 
       LET g_lpz[l_ac].lpz07 = ''           #FUN-D10040 add
       LET g_lpz[l_ac].lpz07_desc = ''      #FUN-D10040 add
    ELSE
       CALL cl_set_comp_entry("lpz07",TRUE)
       LET g_lpz[l_ac].lpz07 = l_lpx28      #FUN-D10040 add
       LET g_lpz[l_ac].lpz07_desc = l_lrz02 #FUN-D10040 add
    END IF
    LET g_lpz[l_ac].lpz02_desc = l_lpx02
   #LET g_lpz[l_ac].lpz07 = l_lpx28         #FUN-D10040 mark
   #LET g_lpz[l_ac].lpz07_desc = l_lrz02    #FUN-D10040 mark

   #FUN-C70077 Add Begin ---
    LET g_lpz[l_ac].lpz13 = l_lpx03
    LET g_lpz[l_ac].lpz14 = l_lpx04
    DISPLAY BY NAME g_lpz[l_ac].lpz13,g_lpz[l_ac].lpz14
   #FUN-C70077 Add End -----
 
    DISPLAY BY NAME g_lpz[l_ac].lpz02_desc,g_lpz[l_ac].lpz07,g_lpz[l_ac].lpz07_desc         
END FUNCTION
#FUN-BA0097--------add------end-------

#FUN-BC0048 start
FUNCTION t670_lpy19(p_cmd)  #門店編號
 DEFINE l_rtz13      LIKE rtz_file.rtz13    
 DEFINE l_rtz28      LIKE rtz_file.rtz28
 DEFINE l_azwacti    LIKE azw_file.azwacti  
 DEFINE p_cmd        LIKE type_file.chr1

    LET g_errno = " "
 
    SELECT rtz13,rtz28,azwacti                         
      INTO l_rtz13,l_rtz28,l_azwacti                    
      FROM rtz_file INNER JOIN azw_file                
        ON rtz01 = azw01                               
     WHERE rtz01 = g_lpy.lpy19
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm-001'  #該門店編號不存在
                                   LET l_rtz13 = NULL
         WHEN l_rtz28 = 'N'        LET g_errno = 'alm-002'  #該筆門店資料未審核
         WHEN l_azwacti = 'N'      LET g_errno = 'aap-223'  #該門店編號無效!              
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE

    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_rtz13 TO FORMONLY.rtz13_2
    END IF 
END FUNCTION
#FUN-BC0048 end
FUNCTION t670_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_lpz.clear()
   DISPLAY ' ' TO FORMONLY.cnt

   CALL t670_cs()

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lpy.* TO NULL
      RETURN
   END IF

   OPEN t670_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lpy.* TO NULL
   ELSE
      OPEN t670_count
      FETCH t670_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt

      CALL t670_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF

END FUNCTION

FUNCTION t670_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式

   CASE p_flag
      WHEN 'N' FETCH NEXT     t670_cs INTO g_lpy.lpy02
      WHEN 'P' FETCH PREVIOUS t670_cs INTO g_lpy.lpy02
      WHEN 'F' FETCH FIRST    t670_cs INTO g_lpy.lpy02
      WHEN 'L' FETCH LAST     t670_cs INTO g_lpy.lpy02
      WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()

                   ON ACTION about
                      CALL cl_about()

                   ON ACTION help
                      CALL cl_show_help()

                   ON ACTION controlg
                      CALL cl_cmdask()
                END PROMPT
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t670_cs INTO g_lpy.lpy02
            LET g_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lpy.lpy02,SQLCA.sqlcode,0)
      INITIALIZE g_lpy.* TO NULL
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      DISPLAY g_curs_index TO FORMONLY.idx
   END IF

   SELECT * INTO g_lpy.* FROM lpy_file WHERE lpy02 = g_lpy.lpy02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lpy_file",g_lpy.lpy02,"",SQLCA.sqlcode,"","",1)
      INITIALIZE g_lpy.* TO NULL
      RETURN
   END IF

   LET g_data_owner = g_lpy.lpyuser
   LET g_data_group = g_lpy.lpygrup
   LET g_data_plant = g_lpy.lpyplant

   CALL t670_show()

END FUNCTION

#將資料顯示在畫面上
FUNCTION t670_show()
DEFINE l_lrz02   LIKE lrz_file.lrz02

   LET g_lpy_t.* = g_lpy.*                #保存單頭舊值
   LET g_lpy_o.* = g_lpy.*                #保存單頭舊值
   DISPLAY BY NAME g_lpy.lpy01,g_lpy.lpy02,g_lpy.lpyplant,g_lpy.lpylegal,
                   g_lpy.lpy11,g_lpy.lpy12,
                   g_lpy.lpy13,g_lpy.lpy14,g_lpy.lpy15,g_lpy.lpy16,
                   g_lpy.lpy17,
                   g_lpy.lpy18,g_lpy.lpy19, #FUN-BC0048 add 
                   g_lpy.lpyoriu,g_lpy.lpyorig,    #TQC-B20102
                   g_lpy.lpyuser,g_lpy.lpygrup,g_lpy.lpymodu,
                   g_lpy.lpydate,g_lpy.lpyacti,g_lpy.lpycrat

   CALL t670_lpyplant('d')
   CALL t670_lpy19('d') #FUN-BC0048 add
   #CALL cl_set_field_pic(g_lpy.lpy13,g_lpy.lpy12,'','','',g_lpy.lpyacti)  #CHI-C80041
   IF g_lpy.lpy13 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_lpy.lpy13,g_lpy.lpy12,'','',g_void,g_lpy.lpyacti)  #CHI-C80041

   CALL t670_b_fill(g_wc2)                 #單身
#  CALL cl_show_fld_cont()

END FUNCTION

FUNCTION t670_x()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lpy.lpy02 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   #不可跨門店改動資料
   IF g_lpy.lpyplant <> g_plant THEN
      CALL cl_err(g_lpy.lpyplant,'alm-399',0)
      RETURN
   END IF
   IF g_lpy.lpy13 = 'Y' THEN
      CALL cl_err(g_lpy.lpy02,'aap-019',0)
      RETURN
   END IF

  #No.TQC-A10165 -BEGIN-----
   LET g_cnt = 0
   IF g_lpy01 = '1' AND g_lpy.lpyacti = 'N' THEN
      SELECT COUNT(*) INTO g_cnt FROM lpz_file a,lpz_file b,lpy_file c
       WHERE a.lpz16 = b.lpz16
         AND a.lpz17 = b.lpz17
         AND a.lpz06 = '1'
         AND a.lpz01 = g_lpy.lpy02
         AND b.lpz01 != g_lpy.lpy02
         AND b.lpz06 = '1'
         AND b.lpz01 = c.lpy02
         AND c.lpyacti = 'Y'
      IF g_cnt > 0 THEN       
         LET g_errno = 'alm-711'
      END IF
   END IF
  #No.TQC-A10165 -END-------

   BEGIN WORK

   OPEN t670_cl USING g_lpy.lpy02
   IF STATUS THEN
      CALL cl_err("OPEN t670_cl:", STATUS, 1)
      CLOSE t670_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t670_cl INTO g_lpy.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lpy.lpy02,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF

   LET g_success = 'Y'

   CALL t670_show()

   IF cl_exp(0,0,g_lpy.lpyacti) THEN                   #確認一下
      LET g_chr=g_lpy.lpyacti
      IF g_lpy.lpyacti='Y' THEN
         LET g_lpy.lpyacti='N'
      ELSE
         LET g_lpy.lpyacti='Y'
      END IF

      UPDATE lpy_file SET lpyacti=g_lpy.lpyacti,
                          lpymodu=g_user,
                          lpydate=g_today
       WHERE lpy02=g_lpy.lpy02
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lpy_file",g_lpy.lpy02,"",SQLCA.sqlcode,"","",1)
         LET g_lpy.lpyacti=g_chr
      END IF
   END IF

   CLOSE t670_cl

   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_lpy.lpy02,'V')
   ELSE
      ROLLBACK WORK
   END IF

   SELECT lpyacti,lpymodu,lpydate
     INTO g_lpy.lpyacti,g_lpy.lpymodu,g_lpy.lpydate FROM lpy_file
    WHERE lpy02=g_lpy.lpy02
   DISPLAY BY NAME g_lpy.lpyacti,g_lpy.lpymodu,g_lpy.lpydate
   CALL cl_set_field_pic(g_lpy.lpy13,g_lpy.lpy12,'','','',g_lpy.lpyacti)

END FUNCTION

FUNCTION t670_r()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lpy.lpy02 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   SELECT * INTO g_lpy.* FROM lpy_file
    WHERE lpy02=g_lpy.lpy02
   #不可跨門店改動資料
   IF g_lpy.lpyplant <> g_plant THEN
      CALL cl_err(g_lpy.lpyplant,'alm-399',0)
      RETURN
   END IF
   IF g_lpy.lpyacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_lpy.lpy02,'alm-147',0)
      RETURN
   END IF
   IF g_lpy.lpy13 = 'Y' THEN
      CALL cl_err(g_lpy.lpy02,'alm-028',0)
      RETURN
   END IF
   IF g_lpy.lpy13 = 'X' THEN RETURN END IF  #CHI-C80041

   BEGIN WORK

   OPEN t670_cl USING g_lpy.lpy02
   IF STATUS THEN
      CALL cl_err("OPEN t670_cl:", STATUS, 1)
      CLOSE t670_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t670_cl INTO g_lpy.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lpy.lpy02,SQLCA.sqlcode,0)     # 資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF

   CALL t670_show()

   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM lpy_file WHERE lpy02 = g_lpy.lpy02
      DELETE FROM lpz_file WHERE lpz01 = g_lpy.lpy02
      CLEAR FORM
      CALL g_lpz.clear()
      OPEN t670_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE t670_cs
         CLOSE t670_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH t670_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t670_cs
         CLOSE t670_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t670_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t670_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL t670_fetch('/')
      END IF
   END IF

   CLOSE t670_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lpy.lpy02,'D')
END FUNCTION

FUNCTION t670_b_fill(p_wc2)
   DEFINE p_wc2   STRING

  #FUN-BA0097-----mark----str----
  #LET g_sql = "SELECT lpz05,lpz03,lpz04,lpz15,'',",
  #            "       lpz16,lpz17,lpz02,'',lpz07,",
  #            "       '',lpz08,lpz09,lpz10,lpz11,",
  #            "       lpz12,lpz13,lpz14,lpzacti,lpzpos ",
  #FUN-BA0097-----mark----end----
  #FUN-BA0097-----add-----str----
   LET g_sql = "SELECT lpz05,lpz15,'',lpz16,",
               "       lpz17,lpz02,'',lpz07,",
               "       '',lpz03,lpz04,lpz08,lpz09,",
               "       lpz10,lpz11,lpz12,lpz13,",
               "       lpz14,lpzacti,lpzpos ",
  #FUN-BA0097-----add-----end----
               "  FROM lpz_file ",
               " WHERE lpz01 ='",g_lpy.lpy02,"' ",   #單頭
               "   AND lpz06 ='",g_lpy.lpy01,"' "
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY lpz05 "

   PREPARE t670_pb FROM g_sql
   DECLARE lpz_cs CURSOR FOR t670_pb

   CALL g_lpz.clear()
   LET g_cnt = 1

   FOREACH lpz_cs INTO g_lpz[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CALL t670_b_init(g_cnt)
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_lpz.deleteElement(g_cnt)

   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0

END FUNCTION

FUNCTION t670_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lpy02,lpy17",TRUE)
      CALL cl_set_comp_entry("lpy05",FALSE)             #add by lilingyu
    END IF
END FUNCTION

FUNCTION t670_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("lpy02,lpy17",FALSE)
       CALL cl_set_comp_entry("lpy05",FALSE)           #add by lilingyu
    END IF

END FUNCTION
#检查录入的起始编号和结束编号是否在当前单据范围中
FUNCTION t670_check_no(p_lpx23,p_no,p_format)
DEFINE p_no        LIKE lpz_file.lpz03
DEFINE p_format    LIKE type_file.chr20
DEFINE p_lpx23     LIKE lpx_file.lpx23
DEFINE l_n         LIKE type_file.num20

   LET g_errno = ''
   LET p_no = p_lpx23 CLIPPED,p_no USING p_format    
   LET g_sql = "SELECT COUNT(*) ",
               "  FROM lpz_file ",
               " WHERE lpz01 = '",g_lpy.lpy02,"' ",
               "   AND lpz06 = '",g_lpy.lpy01,"' ",
               "   AND '",p_no,"' BETWEEN lpz03 AND lpz04 "
   PREPARE pre_sel_lpz1 FROM g_sql
   EXECUTE pre_sel_lpz1 INTO l_n

   IF l_n IS NULL THEN LET l_n = 0 END IF
   IF l_n != 0 THEN
#      LET g_errno = 'clm-329'   #FUN-BC0082 mark
   END IF
END FUNCTION 

#分解券起始号和结束号，把其插入t670_temp9中
FUNCTION t670_create_paper()
DEFINE l_start       LIKE type_file.num20
DEFINE l_end         LIKE type_file.num20
DEFINE l_lpz01       LIKE lpz_file.lpz01
DEFINE l_lpz04       LIKE lpz_file.lpz04
DEFINE l_lpz03       LIKE lpz_file.lpz03
DEFINE l_lpz06       LIKE lpz_file.lpz06
DEFINE l_lpz07       LIKE lpz_file.lpz07
DEFINE l_lpz10       LIKE lpz_file.lpz10
DEFINE l_lpz02       LIKE lpz_file.lpz02
DEFINE l_lpz13       LIKE lpz_file.lpz13
DEFINE l_lpz14       LIKE lpz_file.lpz14
DEFINE l_lpx21       LIKE lpx_file.lpx21
DEFINE l_lpx22       LIKE lpx_file.lpx22
DEFINE l_lpx23       LIKE lpx_file.lpx23
DEFINE l_lpx24       LIKE lpx_file.lpx24
DEFINE l_min         LIKE type_file.num20
DEFINE l_rows        LIKE type_file.num20
DEFINE l_lpz15       LIKE lpz_file.lpz15
DEFINE l_db_type     LIKE type_file.chr4 #TQC-A70103
#DEFINE l_lpz04_sql   STRING              #CHI-C80030 add

   CREATE TEMP TABLE t670_tmp9    
   (lpz01 LIKE lpz_file.lpz01,
    lpz04 LIKE lpz_file.lpz04,
    lpz06 LIKE lpz_file.lpz06,
    lpz02 LIKE lpz_file.lpz02,
    lpz07 LIKE lpz_file.lpz07,
    lpz10 LIKE lpz_file.lpz10,
    lpz13 LIKE lpz_file.lpz13,
    lpz14 LIKE lpz_file.lpz14,
    lpz15 LIKE lpz_file.lpz15);

   CREATE UNIQUE INDEX t670_tmp9_01 ON t670_tmp9(lpz04);

   LET g_sql = "SELECT lpz01,lpz03,lpz04,lpz06,",
               "       lpz02,lpz07,lpz10,lpz13,lpz14,lpz15 ",
               " FROM lpz_file ",
               " WHERE lpz01 = '",g_lpy.lpy02,"' AND lpzacti = 'Y'" #FUN-870007
   PREPARE pre_sel_lpz FROM g_sql
   DECLARE curs_lpz CURSOR FOR pre_sel_lpz
   FOREACH curs_lpz INTO l_lpz01,l_lpz03,l_lpz04,l_lpz06,
                         l_lpz02,l_lpz07,l_lpz10,l_lpz13,l_lpz14,l_lpz15
      IF l_lpz03 IS NULL OR l_lpz04 IS NULL THEN CONTINUE FOREACH END IF
      SELECT lpx21,lpx22,lpx23,lpx24 INTO l_lpx21,l_lpx22,l_lpx23,l_lpx24
           FROM lpx_file WHERE lpx01 = l_lpz02
      IF l_lpx22 IS NULL OR l_lpx22 = 0 THEN            #OR cl_null(l_lpx23) THEN   #没有固定编号     #CHI-C80030 add  cl_null(l_lpx23)
         LET l_start = l_lpz03
         LET l_end = l_lpz04
        ##CHI-C80030 add begin---
        #LET l_lpz04_sql =" ( ",
        #                 " substr(power(10,",l_lpx24,"-length(id+",l_start-1,")) || ",
        #                 " (id+",l_start-1,"),2)) AS lpz04 , "
        ##CHI-C80030 add end-----
      ELSE
         LET l_start = l_lpz03[l_lPX22+1,LENGTH(l_lpz03)]  #截取券起始流水号
         LET l_end = l_lpz04[l_lPX22+1,LENGTH(l_lpz04)]    #截取券结束流水号
        ##CHI-C80030 add begin---
        #LET l_lpz04_sql =" ('",l_lpx23,"' || ",
        #                 " substr(power(10,",l_lpx24,"-length(id+",l_start-1,")) || ",
        #                 " (id+",l_start-1,"),2)) AS lpz04 , "
        ##CHI-C80030 add end-----
      END IF
      LET l_min = l_end - l_start + 1 
#TQC-A70103 --Begin
      LET l_db_type=cl_db_get_database_type()
      IF l_db_type='MSV' THEN
         CALL t670_create_sql()
         EXECUTE stmt USING l_start IN,l_end IN,l_min IN,l_lpz01 IN,l_lpz06 IN,
                    l_lpz02 IN,l_lpz07 IN,l_lpz10 IN,l_lpz15 IN,l_lpx23 IN,l_lpx24 IN,l_rows OUT
      ELSE
#TQC-A70103 --End

      LET g_sql = "INSERT INTO t670_tmp9(lpz01,lpz04,lpz06,lpz02,lpz07,lpz10,lpz15) ",
                  "SELECT '",l_lpz01,"' AS lpz01,", 
                # "CONCAT('",l_lpx23,"',LPAD(to_char(id) + '",
                # l_start-1,"','",l_lpx24,"','0')) AS lpz04 ,'",l_lpz06,"' AS lpz06",
                  " ('",l_lpx23,"' || ",                                                        #CHI-C80030 mark
                 #No.FUN-A80008 -BEGIN-----
                 #" substr(power(10,",l_lpx24,"-length(to_char(id+",l_start-1,"))) || ",
                 #" to_char(id+",l_start-1,"),2)) AS lpz04 ,'",l_lpz06,"' AS lpz06",
                  " substr(power(10,",l_lpx24,"-length(id+",l_start-1,")) || ",                 #CHI-C80030 mark
                  " (id+",l_start-1,"),2)) AS lpz04 ,'",l_lpz06,"' AS lpz06",                   #CHI-C80030 mark
                 #No.FUN-A80008 -END-------
                 #l_lpz04_sql," '",l_lpz06,"' AS lpz06",                                        #CHI-C80030 add
                  ",'",l_lpz02,"' AS lpz02,'",l_lpz07,"' AS lpz07,
                  ",l_lpz10," AS lpz10, '",l_lpz15,"' AS lpz15 ",
                  " FROM (SELECT level AS id FROM dual ",
                  " CONNECT BY level <= '",l_min,"')"
      PREPARE pre_ins_tmp9 FROM g_sql
      EXECUTE pre_ins_tmp9            
      END IF #TQC-A70103
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL s_errmsg('','','insert temp t670_tmp9',SQLCA.sqlcode,1)
         RETURN
      END IF
      LET l_rows = SQLCA.sqlerrd[3]
      IF g_lpy01 = '0' THEN
         UPDATE t670_tmp9 SET lpz13 = l_lpz13,
                              lpz14 = l_lpz14
      END IF
   END FOREACH
#   CREATE UNIQUE INDEX t670_tmp9_01 ON t670_tmp9(lpz04);
END FUNCTION

#券發售/退回/作廢時，單身的券面額和類型要和單頭的券類型及面額一致
FUNCTION t670_coupon_type(p_lpz04)
   DEFINE p_lpz04         LIKE lpz_file.lpz04
   DEFINE l_lpy04         LIKE lpy_file.lpy04
   DEFINE l_lpy05         LIKE lpy_file.lpy05

   SELECT lpy04,lpy05 INTO l_lpy04,l_lpy05 FROM lpy_file,lpz_file
    WHERE lpy02 = lpz02
      AND lpz04 = p_lpz04
      AND lpy01 = '0'
      AND lpy13 = 'Y'
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      #LET g_showmsg = p_lpz04,'/0/Y'
      #CALL s_errmsg('lpz04,lpy01,lpy13',g_showmsg,'sel lpz','alm-472',1)
   END IF

   #券的類型編號或是面額編號,與當前單身的類型編號或面額編號不一致!
   IF l_lpy04 <> g_lpy.lpy04 OR l_lpy05 <> g_lpy.lpy05 THEN
      LET g_success = 'N'
      LET g_showmsg = p_lpz04,'/',l_lpy04,'/',l_lpy05
      CALL s_errmsg('lpz04,lpy04,lpy05',g_showmsg,'sel lpz','alm-488',1)
   END IF
END FUNCTION

FUNCTION t670_upd_head()
   DEFINE l_cnt        LIKE type_file.num10
   DEFINE l_lrz02      LIKE lrz_file.lrz02
   DEFINE l_lpz05      LIKE lpz_file.lpz05
   
   SELECT lrz02 INTO l_lrz02 FROM lrz_file  # 面額
    WHERE lrz01 = g_lpy.lpy05
   IF cl_null(l_lrz02) THEN
      LET l_lrz02 = 0
   END IF

   SELECT COUNT(*),SUM(lpz05) INTO l_cnt,l_lpz05 FROM lpz_file
    WHERE lpz02 = g_lpy.lpy02
   IF cl_null(l_cnt)   THEN LET l_cnt = 0   END IF  #券張數
   IF cl_null(l_lpz05) THEN LET l_lpz05 = 0 END IF  #券金額

   LET g_lpy.lpy06 = l_cnt
   LET g_lpy.lpy07 = l_lrz02 * l_cnt
   LET g_lpy.lpy09 = l_lpz05
   IF g_lpy01 <> '1' THEN
      LET g_lpy.lpy09 = 0 
   END IF
   LET g_lpy.lpy10 = g_lpy.lpy07 - g_lpy.lpy09

END FUNCTION

FUNCTION t670_y()
DEFINE l_lpz    RECORD LIKE lpz_file.* 
DEFINE l_lqe    RECORD LIKE lqe_file.* 
DEFINE l_n      LIKE type_file.num5 #FUN-BC0048 add
DEFINE l_azw02_1   LIKE azw_file.azw02
DEFINE l_azw02_2   LIKE azw_file.azw02
DEFINE l_lpy14     LIKE lpy_file.lpy14   #CHI-D20015
DEFINE l_lpy15     LIKE lpy_file.lpy15   #CHI-D20015

   IF g_lpy.lpy02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#CHI-C30107 ----------------- add ----------------------- begin
   IF g_lpy.lpyplant <> g_plant THEN
      CALL cl_err(g_lpy.lpyplant,'alm-399',0)
      RETURN
   END IF
   IF g_lpy.lpyacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_lpy.lpy02,'mfg1000',0)
      RETURN
   END IF
   IF g_lpy.lpy13 = 'Y' THEN
      CALL cl_err(g_lpy.lpy02,'mfg1005',0)
      RETURN
   END IF
   IF g_lpy.lpy13 = 'X' THEN RETURN END IF  #CHI-C80041

   IF NOT cl_confirm('aap-017') THEN
      RETURN
   END IF
#CHI-C30107 ----------------- add ----------------------- end
   SELECT * INTO g_lpy.* FROM lpy_file
    WHERE lpy02=g_lpy.lpy02
   LET l_lpy14 = g_lpy.lpy14    #CHI-D20015
   LET l_lpy15 = g_lpy.lpy15    #CHI-D20015

   #不可跨門店改動資料
   IF g_lpy.lpyplant <> g_plant THEN
      CALL cl_err(g_lpy.lpyplant,'alm-399',0)
      RETURN
   END IF
   IF g_lpy.lpyacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_lpy.lpy02,'mfg1000',0)
      RETURN
   END IF
   IF g_lpy.lpy13 = 'Y' THEN
      CALL cl_err(g_lpy.lpy02,'mfg1005',0)
      RETURN
   END IF
   IF g_lpy.lpy13 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_rec_b <= 0 THEN
      CALL cl_err(g_lpy.lpy02,'atm-228',0)
      RETURN
   END IF
   #FUN-BC0048 add--
   IF g_lpy01 MATCHES '[356]' THEN 
      CALL s_showmsg_init()
      CALL t670_check_b()
      IF g_success = 'N' THEN 
         CALL s_showmsg()
         RETURN 
      END IF
   END IF    
   #FUN-BC0048 end-- 
#CHI-C30107 ------------ mark ------------- begin
#  IF NOT cl_confirm('aap-017') THEN
#     RETURN
#  END IF
#CHI-C30107 ------------ mark ------------- end   
   #FUN-BA0097-----add-----str-----
   CALL s_showmsg_init()
   CALL t670_lpz03_lpz04()
   IF g_lpz0 = 'N' THEN
      CALL s_showmsg()
      RETURN
   END IF    
   #FUN-BA0097-----add-----end------

   DROP TABLE t670_tmp4;
   DROP TABLE t670_tmp5;
   CREATE TEMP TABLE t670_tmp4(
          lpz041 LIKE lpz_file.lpz04,
          lpz05  LIKE lpz_file.lpz05);
   CREATE UNIQUE INDEX t670_tmp4_01 ON t670_tmp4(lpz041);
   CREATE TEMP TABLE t670_tmp5(
          lpz041 LIKE lpz_file.lpz04);
   CREATE UNIQUE INDEX t670_tmp5_01 ON t670_tmp5(lpz041);
   #FUN-BC0048 start ---
   IF NOT cl_null(g_lpy.lpy19) THEN
      SELECT * FROM ruo_file WHERE 1=0 INTO TEMP ruo_temp
      SELECT * FROM rup_file WHERE 1=0 INTO TEMP rup_temp
      SELECT azw02 INTO l_azw02_1
        FROM azw_file WHERE azw01 = g_lpy.lpyplant
      SELECT azw02 INTO l_azw02_2
        FROM azw_file WHERE azw01 = g_lpy.lpy19
      IF l_azw02_1 <> l_azw02_2 THEN   
         CALL t670_temp('1') 
      END IF    
   END IF  
   #FUN-BC0048 end ---
   BEGIN WORK
   OPEN t670_cl USING g_lpy.lpy02
   IF STATUS THEN
      CALL cl_err("OPEN t670_cl:", STATUS, 1)
      CLOSE t670_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t670_cl INTO g_lpy.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lpy.lpy02,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF

   DECLARE t670_y_cs CURSOR FOR
    SELECT * FROM lpz_file
     WHERE lpz02 = g_lpy.lpy02

   LET g_success = 'Y'
   CALL s_showmsg_init()

###add by lilingyu##
   IF g_argv1 = '3' THEN
#     CALL t700_insert()                    #FOREACH 單身資料,分段插入lpz_file
   END IF 
###add by lilingyu   
  INITIALIZE l_lqe.* TO NULL
   CALL t670_y_new() #券數量會很大，故審核時使用_y_new function
   IF g_lpy01 = '3' OR g_lpy01 = '5' OR g_lpy01 = '6' THEN  #FUN-BC0061 add
      INITIALIZE g_ina01 TO NULL 
      INITIALIZE g_ruo01 TO NULL 
      INITIALIZE g_ruo011 TO NULL 
      CALL t670_y_new2()
   END IF 
   IF g_success = 'Y' THEN #FUN-BC0048 add
      #FUN-BC0061 start
      IF g_lpy01 = '3' THEN 
         LET g_lpy.lpy18 = g_ina01
      END IF 
      IF g_lpy01 = '5' THEN 
         LET g_lpy.lpy18 = g_ruo01
      END IF 
      IF g_lpy01 = '6' THEN 
         LET g_lpy.lpy18 = g_ruo011
      END IF 
      #FUN-BC0061 end   
      UPDATE lpy_file SET lpy13 = 'Y',lpy14 = g_user,lpy15 = g_today,lpy18 = g_lpy.lpy18 #FUN-BC0048 add lpy18
       WHERE lpy02=g_lpy.lpy02
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('lpy02',g_lpy.lpy02,'update lpy',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      #FUN-BC0048 start 
      IF g_lpy01 = '5' OR g_lpy01 = '6' OR g_lpy01 = '3' THEN #FUN-BC0061
         LET g_sql = "SELECT lpz03,lpz04 FROM lpz_file ",
                     " WHERE lpz01 = '",g_lpy.lpy02,"' ",
                     "   AND lpz06 = '",g_lpy01,"' "
                
         PREPARE t670_lpz01 FROM g_sql
         DECLARE t670_lpz01_cs CURSOR FOR t670_lpz01
         LET l_n = 1
         FOREACH t670_lpz01_cs INTO l_lpz.lpz03,l_lpz.lpz04
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               CALL s_errmsg('','','t670_lpz011_cs',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF 
            IF g_lpy01 = '5' THEN 
               LET l_lqe.lqe13 = g_lpy.lpy19
               LET l_lqe.lqe14 = g_lpy.lpy17
               LET l_lqe.lqe17 = '5'
               LET l_lqe.lqe15 = ''
               LET l_lqe.lqe16 = ''
               LET l_lqe.lqe11 = ''
               LET l_lqe.lqe12 = ''
            END IF 
            #FUN-BC0061 start
            IF g_lpy01 = '6' THEN
               LET l_lqe.lqe15 = g_lpy.lpy19
               LET l_lqe.lqe16 = g_lpy.lpy17
               LET l_lqe.lqe17 = '6'
               LET l_lqe.lqe13 = ''
               LET l_lqe.lqe14 = ''
               LET l_lqe.lqe11 = ''
               LET l_lqe.lqe12 = ''
            END IF 
            IF g_lpy01 = '3' THEN 
               LET l_lqe.lqe11 = g_lpy.lpyplant
               LET l_lqe.lqe12 = g_lpy.lpy17
               LET l_lqe.lqe17 = '3' 
            END IF    
            #FUN-BC0061 end   
            
            UPDATE lqe_file SET lqe06 = '',lqe07 = '',lqe09 = '',lqe10 = '',
                                lqe11 = l_lqe.lqe11,
                                lqe12 = l_lqe.lqe12,
                                lqe13 = l_lqe.lqe13,
                                lqe14 = l_lqe.lqe14,
                                lqe15 = l_lqe.lqe15,
                                lqe16 = l_lqe.lqe16,
                                lqe17 = l_lqe.lqe17 
             WHERE lqe01 BETWEEN l_lpz.lpz03 AND l_lpz.lpz04
             
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               LET g_showmsg = l_lpz.lpz03,'~',l_lpz.lpz04
               CALL s_errmsg('lqe01',g_showmsg,'update lqe',SQLCA.sqlcode,1)
               LET g_success = 'N'
            END IF                      
            LET l_n = l_n+1
         END FOREACH 
      END IF
   END IF     
   #FUN-BC0048 end   
   DISPLAY "Finish:",TIME

# IF g_argv1 = '3' THEN
#   CALL t700_insert()                    #FOREACH 單身資料,分段插入lpz_file   #add by lilingyu
#END IF 
   CALL s_showmsg()
   CLOSE t670_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      SELECT lpy13,lpy14,lpy15,lpy18 INTO g_lpy.lpy13,g_lpy.lpy14,g_lpy.lpy15,g_lpy.lpy18 #FUN-BC0048 add lpy18
        FROM lpy_file
       WHERE lpy02=g_lpy.lpy02
      DISPLAY BY NAME g_lpy.lpy13,g_lpy.lpy14,g_lpy.lpy15,g_lpy.lpy18  #FUN-BC0048 add lpy18
   ELSE
   #  LET g_lpy.lpy15 = '' #FUN-BC0061 add    #CHI-D20015
      LET g_lpy.lpy14 = l_lpy14     #CHI-D20015
      LET g_lpy.lpy15 = l_lpy15     #CHI-D20015
      LET g_lpy.lpy18 = '' #FUN-BC0061 add
      ROLLBACK WORK
   END IF
   CALL cl_set_field_pic(g_lpy.lpy13,g_lpy.lpy12,'','','',g_lpy.lpyacti)
   #FUN-BC0048 start ---
   IF NOT cl_null(g_lpy.lpy19) THEN
      DROP TABLE ruo_temp
      DROP TABLE rup_temp
      IF l_azw02_1 <> l_azw02_2 THEN   
         CALL t670_temp('2') 
      END IF   
   END IF  
   #FUN-BC0048 end ---
END FUNCTION

FUNCTION t670_z()
   DEFINE l_lpz         RECORD LIKE lpz_file.*
   DEFINE l_lqe17       LIKE lqe_file.lqe17
   DEFINE l_cnt         LIKE type_file.num20

   IF g_lpy.lpy02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_lpy.* FROM lpy_file
    WHERE lpy02=g_lpy.lpy02

   #不可跨門店改動資料
   IF g_lpy.lpyplant <> g_plant THEN
      CALL cl_err(g_lpy.lpyplant,'alm-399',0)
      RETURN
   END IF
   IF g_lpy.lpy13 = 'N' THEN  #未審核
      CALL cl_err(g_lpy.lpy02,'9025',0)
      RETURN
   END IF
   IF g_lpy.lpy13 = 'X' THEN RETURN END IF  #CHI-C80041

   #已發售/退回/作廢單據 不可取消審核!
   IF g_lpy.lpy01 <> '0' THEN
      CALL cl_err(g_lpy.lpy02,'alm-478',0)
      RETURN
   END IF

   IF NOT cl_confirm('aim-302') THEN RETURN END IF
   #carrier new 08/12/02
   DROP TABLE t670_tmp1;
   DROP TABLE t670_tmp2;
   DROP TABLE t670_tmp3;
   CREATE TEMP TABLE t670_tmp1(
          lpz04 LIKE lpz_file.lpz04);
   CREATE UNIQUE INDEX t670_tmp1_01 ON t670_tmp1(lpz04);
   CREATE TEMP TABLE t670_tmp2(
          lpz041 LIKE lpz_file.lpz04);
   CREATE UNIQUE INDEX t670_tmp2_01 ON t670_tmp2(lpz041);
   CREATE TEMP TABLE t670_tmp3(
          lpz041 LIKE lpz_file.lpz04);
   CREATE UNIQUE INDEX t670_tmp3_01 ON t670_tmp3(lpz041);
   #carrier new 08/12/02

   BEGIN WORK
   OPEN t670_cl USING g_lpy.lpy02
   IF STATUS THEN
      CALL cl_err("OPEN t670_cl:", STATUS, 1)
      CLOSE t670_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t670_cl INTO g_lpy.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lpy.lpy02,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF

   LET g_success = 'Y'
   DECLARE t670_z_cs CURSOR FOR
    SELECT * FROM lpz_file
     WHERE lpz02 = g_lpy.lpy02

   CALL s_showmsg_init()

#   IF g_rec_b > 50 THEN
      CALL t670_z_new()
#   ELSE
#      DISPLAY "Undo Confirm Begin Time:",TIME
#      DISPLAY "Undo Confirm Error Collection Begin Time:",TIME
#     FOREACH t670_z_cs INTO l_lpz.*
#         IF SQLCA.sqlcode THEN
#            CALL s_errmsg('','','foreach t670_z_cs',SQLCA.sqlcode,1)
#            LET g_success = 'N'
#            EXIT FOREACH
#         END IF
#         SELECT lqe17 INTO l_lqe17 FROM lqe_file
#          WHERE lqe01 = l_lpz.lpz04
#         IF cl_null(l_lqe17) OR l_lqe17 <> '0' THEN
#            LET g_success = 'N'
#            LET g_showmsg = l_lpz.lpz04,'/',l_lqe17
#            #此券已經有使用資料,不得做取消登記
#            CALL s_errmsg('lpz04,lqe17',g_showmsg,'sel lqe17','alm-562',1)
#         END IF
#         LET l_cnt = 0
#         SELECT COUNT(*) FROM lpy_file,lpz_file
#          WHERE lpy02 = lpz02
#            AND lpyacti = 'Y'
#            AND lpy13 = 'N'
#            AND lpy02 <> g_lpy.lpy02
#         IF l_cnt > 0 THEN
#            LET g_success = 'N'
#            #此券已經有使用資料,不得做取消登記
#            CALL s_errmsg('lpz04',l_lpz.lpz04,'sel lpy,lpz','alm-479',1)
#         END IF
#      END FOREACH
#      DISPLAY "Undo Confirm Error Collection End Time:",TIME
#   END IF

   IF g_success = 'Y' THEN   
      #1.刪除lqe_file的登記信息
      DISPLAY "Undo Confirm Delete From lqe_file Begin Time:",TIME
      #DELETE FROM lqe_file WHERE lqe01 IN (SELECT lpz04 FROM lpz_file
      #                                      WHERE lpz02 = g_lpy.lpy02)
      DELETE FROM lqe_file WHERE EXISTS (SELECT 'X' FROM t670_tmp9     
                                          WHERE lpz01 = g_lpy.lpy02
                                            AND lqe01 = t670_tmp9.lpz04)    
      IF SQLCA.sqlcode THEN     #lori test      OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('lpy02',g_lpy.lpy02,'delete lqe',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      DISPLAY "Undo Confirm Delete From lqe_file End Time:",TIME
  
    # UPDATE lpy_file SET lpy13 = 'N',lpy14 = '',lpy15 = ''              #CHI-D20015 mark
      UPDATE lpy_file SET lpy13 = 'N',lpy14 = g_user, lpy15 = g_today    #CHI-D20015 
       WHERE lpy02=g_lpy.lpy02
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('lpy02',g_lpy.lpy02,'update lqy',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF
   CALL s_showmsg()
      
   CLOSE t670_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      SELECT lpy13,lpy14,lpy15 INTO g_lpy.lpy13,g_lpy.lpy14,g_lpy.lpy15
        FROM lpy_file
       WHERE lpy02=g_lpy.lpy02
      DISPLAY BY NAME g_lpy.lpy13,g_lpy.lpy14,g_lpy.lpy15
   ELSE
      ROLLBACK WORK
   END IF
   DISPLAY "Undo Confirm End Time:",TIME
   CALL cl_set_field_pic(g_lpy.lpy13,g_lpy.lpy12,'','','',g_lpy.lpyacti)

END FUNCTION

#取得發售時的 券折扣金額
FUNCTION t670_get_lpz05(p_lpz04)
   DEFINE p_lpz04       LIKE lpz_file.lpz04
   DEFINE l_lpz05       LIKE lpz_file.lpz05


   SELECT lqe08 INTO l_lpz05 FROM lqe_file
    WHERE lqe01 = p_lpz04
   IF cl_null(l_lpz05) THEN LET l_lpz05 = 0 END IF
   RETURN l_lpz05

END FUNCTION

#錯誤訊息記錄array
FUNCTION t670_error(p_table,p_step,p_errno)
   DEFINE p_table        LIKE gat_file.gat01
   DEFINE p_step         LIKE type_file.num5
   DEFINE p_errno        LIKE ze_file.ze01
   DEFINE l_lpz041       LIKE lpz_file.lpz04
   DEFINE l_i            LIKE type_file.num10

   ERROR 'Begin Step ',p_step USING '&<','(報錯信息匯總',p_table CLIPPED,')'
   CALL ui.Interface.refresh()
   DISPLAY "報錯",p_table CLIPPED,'開始:',TIME
   LET g_sql = "SELECT lpz041 FROM ",p_table
   DECLARE t670_tmp5_cs CURSOR FROM g_sql
   LET l_i = 1
   FOREACH t670_tmp5_cs INTO l_lpz041
      IF l_i > 10000 THEN
         EXIT FOREACH
      END IF
      CALL s_errmsg('lpz04',l_lpz041,'foreach t670_tmp5_cs',p_errno,1)
      LET l_i = l_i + 1
   END FOREACH
   DISPLAY "報錯",p_table CLIPPED,'結束:',TIME
   ERROR 'Finish Step ',p_step USING '&<','(報錯信息匯總',p_table CLIPPED,')'
   CALL ui.Interface.refresh()

END FUNCTION

#FUN-870007-start-
FUNCTION t670_y_chk()
DEFINE l_cnt LIKE type_file.num5
      
      CASE g_lpy01
       WHEN '0'
#        LET g_sql = "DELETE FROM t670_tmp5 a",  #TQC-A60132
         LET g_sql = "DELETE FROM t670_tmp5",    #TQC-A60132
                     " WHERE NOT EXISTS (SELECT 1 FROM lqe_file ",
#                    "                    WHERE a.lpz041 = lqe01)" #TQC-A60132
                     "                    WHERE lpz041 = lqe01)"   #TQC-A60132
       WHEN '1'
#        LET g_sql = "DELETE FROM t670_tmp5 a",  #TQC-A60132
         LET g_sql = "DELETE FROM t670_tmp5",    #TQC-A60132
                     " WHERE EXISTS (SELECT 1 FROM lqe_file ",
#                    "                WHERE a.lpz041 = lqe01 ",#TQC-A60132
                     "                WHERE lpz041 = lqe01 ",  #TQC-A60132
                     "                  AND (lqe17 = '0' ",
                     "                   OR lqe17 = '2')) "
       WHEN '2'
#        LET g_sql = "DELETE FROM t670_tmp5 a",#TQC-A60132
         LET g_sql = "DELETE FROM t670_tmp5",  #TQC-A60132
                     " WHERE EXISTS (SELECT 1 FROM lqe_file ",
#                    "                WHERE a.lpz041 = lqe01 ",#TQC-A60132
                     "                WHERE lpz041 = lqe01 ",  #TQC-A60132
                     "                  AND lqe17 = '1') "
       WHEN '3'
#        LET g_sql = "DELETE FROM t670_tmp5 a",#TQC-A60132
         LET g_sql = "DELETE FROM t670_tmp5",  #TQC-A60132
                     " WHERE NOT EXISTS (SELECT 1 FROM lqe_file ",
#                    "                    WHERE a.lpz041 = lqe01 ",#TQC-A60132
                     "                    WHERE lpz041 = lqe01 ",  #TQC-A60132
                     "                      AND lqe17 = '3') "
    #FUN-BC0048 start ---
       WHEN '5'
         LET g_sql = "DELETE FROM t670_tmp5", 
                     " WHERE NOT EXISTS (SELECT 1 FROM lqe_file ",
                     "                    WHERE lpz041 = lqe01 ",  
                     "                      AND lqe17 = '5') "
    #FUN-BC0048 end --- 
    #FUN-BC0061 start---
       WHEN '6' 
           LET g_sql = "DELETE FROM t670_tmp5", 
                     " WHERE NOT EXISTS (SELECT 1 FROM lqe_file ",
                     "                    WHERE lpz041 = lqe01 ",  
                     "                      AND lqe17 = '6') "   
   #FUN-BC0061 end ---                  
    END CASE
    EXECUTE IMMEDIATE g_sql
    IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','delete from t670_tmp5',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
    END IF 
    SELECT COUNT(*) INTO l_cnt FROM t670_tmp5
    IF l_cnt > 0 THEN
       CASE g_lpy01
         WHEN '0'
           CALL t670_error('t670_tmp5',6,'alm-470')
         WHEN '1'
           CALL t670_error('t670_tmp5',6,'alm-473')
         WHEN '2'
           CALL t670_error('t670_tmp5',6,'alm-475')
         WHEN '3'
           CALL t670_error('t670_tmp5',6,'alm-476')
       END CASE
       LET g_success = 'N'
       RETURN
    END IF   
END FUNCTION
#FUN-870007--end--

FUNCTION t670_y_new()
   DEFINE l_lqe         RECORD LIKE lqe_file.*
   DEFINE l_cnt         LIKE type_file.num20
   DEFINE l_cnt1        LIKE type_file.num20
   DEFINE l_lrz02       LIKE lrz_file.lrz02
   DEFINE l_lpz05       LIKE lpz_file.lpz05

   DISPLAY "Confirm Begin:",TIME

#FUN-870007-start-
#  LET g_sql = "INSERT INTO t670_tmp4 ",
#               "SELECT lpz04,lpz05 FROM lpz_file ",
#               " WHERE lpz02 = '",g_lpy.lpy02,"'"
#   PREPARE t670_ry1 FROM g_sql
#   EXECUTE t670_ry1
#   IF SQLCA.sqlcode THEN
#      CALL s_errmsg('','','insert temp t670_tmp4',SQLCA.sqlcode,1)
#      LET g_success = 'N'
#      RETURN
#   END IF
  #DROP TABLE t670_tmp9    #lori test
   CALL t670_create_paper()
#FUN-870007--end--
   DISPLAY "After Insert into t670_tmp9:",TIME,SQLCA.sqlerrd[3]

   IF g_lpy01 MATCHES '[123]' THEN  #檢查有沒有未登記的券在做出售/退回/作廢
      LET g_sql = "INSERT INTO t670_tmp5 SELECT lpz04 FROM t670_tmp9"
      PREPARE t670_ry8 FROM g_sql
      EXECUTE t670_ry8
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','insert temp t670_tmp5',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
      DISPLAY "After Insert into t670_tmp5:",TIME,SQLCA.sqlerrd[3]

      LET g_sql = "DELETE FROM t670_tmp5 ",
                  " WHERE EXISTS (SELECT 'X' FROM lqe_file ",
                  "                WHERE lqe_file.lqe01 = t670_tmp5.lpz041 )"
      PREPARE t670_ry2 FROM g_sql
      EXECUTE t670_ry2
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','delete from t670_tmp5',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
      DISPLAY "After Insert into t670_tmp5:",TIME,SQLCA.sqlerrd[3]

      LET l_cnt = 0
      LET g_sql = "SELECT COUNT(lpz041) FROM t670_tmp5 "
      PREPARE t670_ry3 FROM g_sql
      EXECUTE t670_ry3 INTO l_cnt
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','select count t670_tmp5',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
      DISPLAY "After Select from t670_tmp5:",TIME,l_cnt
      
      IF l_cnt > 0 THEN  #t670_tmp5中存在后台沒有登記的券
         CALL t670_error('t670_tmp5',5,'alm-477')
         LET g_success = 'N'
         RETURN
      END IF
   END IF

#FUN-870007-start-
   DELETE FROM t670_tmp5
   LET g_sql = "INSERT INTO t670_tmp5 SELECT lpz04 FROM t670_tmp9"
   EXECUTE IMMEDIATE g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','insert temp t670_tmp5',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   CALL t670_y_chk()
   IF g_success = 'N' THEN
      RETURN
   END IF
#FUN-870007--end--
   CASE g_lpy01
        WHEN '0' 
             LET g_sql = " INSERT INTO lqe_file(lqe01,lqe02,lqe03,",
                         #"                      lqe04,lqe05,lqe17,lqe20,lqe21)",                     #NO.FUN-A80022 mark
                         "                      lqe04,lqe05,lqe17,lqe20,lqe21,lqepos,lqe22,lqe23)",   #NO.FUN-A80022 add lqepos     #FUN-CB0110 add lqe22,lqe23
                         " SELECT lpz04,lpz02,lpz07,",
                                        "'",g_lpy.lpyplant,"',",
                         #               "'",g_lpy.lpy17,"',0,lpz13,lpz14",                           #NO.FUN-A80022 mark
                                        "'",g_lpy.lpy17,"',0,lpz13,lpz14,'N','0',0",                  #NO.FUN-A80022 add lqepos='N'  #FUN-CB0110 add lqe22='0' and lqe23=0
                         "   FROM t670_tmp9 "
             PREPARE t670_ry4 FROM g_sql
             EXECUTE t670_ry4
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('','','insert lqe_file',SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
             DISPLAY "After Insert lqe_file:",TIME,SQLCA.sqlerrd[3]
        WHEN '1' 
             LET g_sql = " UPDATE lqe_file SET lqe07 = ?,",
                         "                     lqe06 = (SELECT lpz15 FROM t670_tmp9 WHERE lpz04 = lqe01),",
                         "                     lqe08 = (SELECT lpz10 FROM t670_tmp9 WHERE lpz04 = lqe01),",
                         "                     lqe17 = ? ",
                         "  WHERE EXISTS (SELECT 'X' FROM t670_tmp9 ",
                         "                 WHERE lpz04 = lqe01) "
             PREPARE t670_ry5 FROM g_sql
             EXECUTE t670_ry5 USING g_lpy.lpy17,'1'
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('','','insert lqe_file',SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
             DISPLAY "Update lqe_file:",TIME,SQLCA.sqlerrd[3]
        WHEN '2' 
             LET g_sql = " UPDATE lqe_file SET lqe09 = ?,lqe10 = ?,",
                         "                     lqe17 = ? ",
                         "  WHERE EXISTS (SELECT 'X' FROM t670_tmp9 ",
                         "                 WHERE lpz04 = lqe01) "
             PREPARE t670_ry6 FROM g_sql
             EXECUTE t670_ry6 USING g_lpy.lpyplant,g_lpy.lpy17,'2'
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('','','insert lqe_file',SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
             DISPLAY "Update lqe_file:",TIME,SQLCA.sqlerrd[3]
        WHEN '3' 
             LET g_sql = " UPDATE lqe_file SET lqe11 = ?,lqe12 = ?,",
                         "                     lqe17 = ? ",
                         "  WHERE EXISTS (SELECT 'X' FROM t670_tmp9 ",
                         "                 WHERE lpz04 = lqe01) "
             PREPARE t670_ry7 FROM g_sql
             EXECUTE t670_ry7 USING g_lpy.lpyplant,g_lpy.lpy17,'3'
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('','','insert lqe_file',SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
             DISPLAY "Update lqe_file:",TIME,SQLCA.sqlerrd[3]
   END CASE

END FUNCTION

FUNCTION t670_z_new()
   DEFINE l_cnt         LIKE type_file.num20
   DEFINE l_cnt1        LIKE type_file.num20

   DISPLAY "取消审核开始:",TIME

   DISPLAY "单身券插入临时表t670_tmp1开始:",TIME
#FUN-870007-start-
#   LET g_sql = "INSERT INTO t670_tmp1 ",
#               "SELECT lpz04 FROM lpz_file ",
#               " WHERE lpz02 = '",g_lpy.lpy02,"'"
#   PREPARE t670_rz1 FROM g_sql
#   EXECUTE t670_rz1
   DROP TABLE t670_tmp9
   CALL t670_create_paper()
   LET g_sql = "INSERT INTO t670_tmp1 ",
               "SELECT lpz04 FROM t670_tmp9 "
   EXECUTE IMMEDIATE g_sql
#FUN-870007--end--
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','insert temp t670_tmp1',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   DISPLAY "单身券插入临时表t670_tmp1结束:",TIME,SQLCA.sqlerrd[3]

   DISPLAY "產生已在使用的券資料(lqe_file)開始:",TIME
   LET l_cnt = 0
   #LET g_sql = "INSERT INTO t670_tmp2 ",
   #            "SELECT UNIQUE lqe01,lqe17 FROM lqe_file"
   LET g_sql = "INSERT INTO t670_tmp2(lpz041) ",
               "SELECT lqe01 FROM lqe_file ",
               " WHERE lqe17 <> '0' ",
               "   AND EXISTS (SELECT 'X' FROM t670_tmp1 ",
               "                WHERE lpz04 = lqe01 )"
   PREPARE t670_rz2 FROM g_sql
   EXECUTE t670_rz2
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL s_errmsg('','','insert temp t670_tmp2',SQLCA.sqlcode,1)
      RETURN
   END IF
   LET l_cnt = SQLCA.sqlerrd[3]
   DISPLAY "產生已在使用的券資料(lqe_file)结束:",TIME,l_cnt
   IF l_cnt > 0 THEN  
      CALL t670_error('t670_tmp2',3,'alm-562')
      LET g_success = 'N'
      RETURN
   END IF

   DISPLAY "產生已在使用的券資料(lpz_file)開始:",TIME
   LET l_cnt1 = 0
   #LET g_sql = "INSERT INTO t670_tmp3 ",
   #            "SELECT UNIQUE lpz04 FROM lpy_file,lpz_file",
   #            " WHERE lpy02 = lpz02 ",
   #            "   AND lpyacti = 'Y' ",
   #            "   AND lpy13 = 'N'   "
   LET g_sql = "INSERT INTO t670_tmp3(lpz041) ",
#              "SELECT lpz04 FROM lpz_file,lpy_file ",
               "SELECT lpz04 FROM t670_tmp9,lpy_file ",  #FUN-870007
               " WHERE lpz01 = lpy02 ",
               "   AND lpyacti = 'Y' ",
               "   AND lpy13 = 'N'   ",
               "   AND lpz01 <> '",g_lpy.lpy02,"'",
               "   AND EXISTS (SELECT 'X' FROM t670_tmp1 ",
               "                WHERE t670_tmp1.lpz04 = t670_tmp9.lpz04 )"
   PREPARE t670_rz3 FROM g_sql
   EXECUTE t670_rz3
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL s_errmsg('','','insert temp t670_tmp3',SQLCA.sqlcode,1)
      RETURN
   END IF
   LET l_cnt1 = SQLCA.sqlerrd[3]
   DISPLAY "產生已在使用的券資料(lpz_file)结束:",l_cnt1
   IF l_cnt1 > 0 THEN  
      CALL t670_error('t670_tmp3',5,'alm-479')
      LET g_success = 'N'
      RETURN
   END IF

END FUNCTION

FUNCTION t670_b()
DEFINE l_ac_t  LIKE type_file.num5,
       l_n     LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd   LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.num5,
       l_allow_delete  LIKE type_file.num5
DEFINE l_dbs LIKE azp_file.azp02
DEFINE l_start LIKE lpz_file.lpz03
DEFINE l_end LIKE lpz_file.lpz03
DEFINE l_lpx22  LIKE lpx_file.lpx22
DEFINE l_lpx23  LIKE lpx_file.lpx23
DEFINE l_lpx28  LIKE lpx_file.lpx28
DEFINE l_lpx32  LIKE lpx_file.lpx32 #FUN-BC0048
DEFINE l_lpx26  LIKE lpx_file.lpx26 #FUN-D10040 add

        LET g_action_choice=""
        IF s_shut(0) THEN 
                RETURN
        END IF
        
        IF cl_null(g_lpy.lpy02) THEN
           RETURN 
        END IF
        
        SELECT * INTO g_lpy.* FROM lpy_file
         WHERE lpy02=g_lpy.lpy02
        
        #不可跨門店改動資料
        IF g_lpy.lpyplant <> g_plant THEN
           CALL cl_err(g_lpy.lpyplant,'alm-399',0)
           RETURN
        END IF

        IF g_lpy.lpyacti ='N' THEN    #檢查資料是否為無效
           CALL cl_err(g_lpy.lpy02,'mfg1000',0)
           RETURN
        END IF
        IF g_lpy.lpy13 = 'Y' THEN
           CALL cl_err(g_lpy.lpy02,'mfg1005',0)
           RETURN
        END IF
        IF g_lpy.lpy13 = 'X' THEN RETURN END IF  #CHI-C80041
        DROP TABLE t670_tmp5
        CREATE TEMP TABLE t670_tmp5(
          lpz041 LIKE lpz_file.lpz04);
        CREATE UNIQUE INDEX t670_tmp5_01 ON t670_tmp5(lpz041);
        CALL cl_opmsg('b')
       
       #FUN-BA0097----mark----str------ 
       #LET g_forupd_sql= "SELECT lpz05,lpz03,lpz04,lpz15,'',",
       #                  "       lpz16,lpz17,lpz02,'',lpz07,",
       #                  "       '',lpz08,lpz09,lpz10,lpz11,",
       #                  "       lpz12,lpz13,lpz14,lpzacti,lpzpos ",
       #FUN-BA0097----mark----end------
       #FUN-BA0097----add-----str------
        LET g_forupd_sql= "SELECT lpz05,lpz15,'',lpz16,lpz17,",
                          "       lpz02,'',lpz07,'',lpz03,",
                          "       lpz04,lpz08,lpz09,lpz10,lpz11,",
                          "       lpz12,lpz13,lpz14,lpzacti,lpzpos ", 
       #FUN-BA0097----add-----end------
                          "  FROM lpz_file ",
                          " WHERE lpz01 = ? ",
                          "   AND lpz06 = ? ",
                          "   AND lpz05 = ? ",
                          " FOR UPDATE "
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE t670_bcl CURSOR FROM g_forupd_sql
        
        LET l_allow_insert=cl_detail_input_auth("insert")
        LET l_allow_delete=cl_detail_input_auth("delete")
        
        INPUT ARRAY g_lpz WITHOUT DEFAULTS FROM s_lpz.*
                ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
           IF g_rec_b !=0 THEN 
              CALL fgl_set_arr_curr(l_ac)
           END IF
           CALL t670_act_disp()
        BEFORE ROW
           LET p_cmd =''
           LET l_ac =ARR_CURR()
           LET l_lock_sw ='N'
           LET l_n =ARR_COUNT()
                
           BEGIN WORK 
           OPEN t670_cl USING g_lpy.lpy02
           IF STATUS THEN
              CALL cl_err("OPEN t670_cl:",STATUS,1)
              CLOSE t670_cl
              ROLLBACK WORK
           END IF
                
           FETCH t670_cl INTO g_lpy.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lpy.lpy02,SQLCA.sqlcode,0)
              CLOSE t670_cl
              ROLLBACK WORK 
              RETURN
           END IF
           IF g_rec_b>=l_ac THEN 
              LET p_cmd ='u'
              LET g_lpz_t.*=g_lpz[l_ac].*
              LET g_lpz_o.*=g_lpz[l_ac].*
              OPEN t670_bcl USING g_lpy.lpy02,g_lpy.lpy01,g_lpz_t.lpz05
              IF STATUS THEN
                 CALL cl_err("OPEN t670_bcl:",STATUS,1)
                 LET l_lock_sw='Y'
              ELSE
                 FETCH t670_bcl INTO g_lpz[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_lpz_t.lpz05,SQLCA.sqlcode,1)
                    LET l_lock_sw="Y"
                 END IF
                 CALL t670_b_init(l_ac)
                 CALL cl_set_comp_entry("lpz02",FALSE)
                 CALL cl_set_comp_required("lpz03",TRUE)
                #FUN-D10040-----mark---str
                #IF g_lpy01 = '0' THEN
                #   SELECT lpx28 INTO l_lpx28 FROM lpx_file
                #    WHERE lpx01 = g_lpz[l_ac].lpz02
                #   IF cl_null(l_lpx28) THEN
                #      CALL cl_set_comp_entry("lpz07",TRUE)
                #      CALL cl_set_comp_required("lpz07",TRUE)
                #   ELSE
                #      CALL cl_set_comp_entry("lpz07",FALSE)
                #      CALL cl_set_comp_required("lpz07",FALSE)
                #   END IF
                #END IF
                #FUN-D10040-----mark---end
                 #FUN-D10040----add----str
                 SELECT lpx26 INTO l_lpx26 FROM lpx_file
                  WHERE lpx01 = g_lpz[l_ac].lpz02
                 IF l_lpx26 = '2' THEN
                    CALL cl_set_comp_entry("lpz07",FALSE)
                 ELSE
                    CALL cl_set_comp_entry("lpz07",TRUE)
                 END IF
                 #FUN-D10040----add----end
                          #IF g_argv1 = '3' AND g_aza.aza88 = 'Y' THEN          #FUN-B50042 mark
                          #  #LET g_lpz[l_ac].lpzpos = 'Y'     #FUN-A30116 MARK #FUN-B50042 mark
                          #   LET g_lpz[l_ac].lpzpos = 'N'     #ADD             #FUN-B50042 mark
                          #ELSE                                                 #FUN-B50042 mark
                          #  #LET g_lpz[l_ac].lpzpos = 'N'     #FUN-A30116 MARK #FUN-B50042 mark
                          #   LET g_lpz[l_ac].lpzpos = ' '     #ADD             #FUN-B50042 mark
                          #END IF                                               #FUN-B50042 mark
              END IF
           END IF
        BEFORE INSERT
           LET l_n=ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_lpz[l_ac].* TO NULL
           LET g_lpz[l_ac].lpzacti = 'Y'
                #IF g_argv1 = '3' AND g_aza.aza88 = 'Y' THEN                     #FUN-B50042 mark
                #  #LET g_lpz[l_ac].lpzpos = 'Y'               #FUN-A30116 MARK  #FUN-B50042 mark
                #   LET g_lpz[l_ac].lpzpos = 'N'               #ADD              #FUN-B50042 mark
                #ELSE                                                            #FUN-B50042 mark
                #  #LET g_lpz[l_ac].lpzpos = 'N'               #FUN-A30116 MARK  #FUN-B50042 mark
                #   LET g_lpz[l_ac].lpzpos = ' '               #ADD              #FUN-B50042 mark
                #END IF                                                          #FUN-B50042 mark
           LET g_lpz[l_ac].lpz15 = g_lpy.lpyplant
           LET g_lpz[l_ac].lpz10 = 100
           IF g_lpy01 = '0' THEN
              LET g_lpz[l_ac].lpz13 = g_today
              CALL cl_set_comp_entry("lpz02",TRUE)
           ELSE
              CALL cl_set_comp_entry("lpz02",FALSE)
           END IF
           CALL cl_set_comp_entry("lpz07",FALSE)
           CALL cl_set_comp_required("lpz07",FALSE)
           CALL cl_set_comp_required("lpz03",TRUE)
           LET g_lpz_t.*=g_lpz[l_ac].*
           CALL cl_show_fld_cont()
           NEXT FIELD lpz05
                
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG=0
              CANCEL INSERT
           END IF
           INSERT INTO lpz_file(lpz01,lpz02,lpz03,lpz04,lpz05,
                                lpz06,lpz07,lpz08,lpz09,lpz10,
                                lpz11,lpz12,lpz13,lpz14,lpz15,
                                lpz16,lpz17,lpzacti,
                                lpzplant,lpzlegal)
                 VALUES(g_lpy.lpy02,g_lpz[l_ac].lpz02,g_lpz[l_ac].lpz03,g_lpz[l_ac].lpz04,
                        g_lpz[l_ac].lpz05,g_lpy.lpy01,g_lpz[l_ac].lpz07,g_lpz[l_ac].lpz08,
                        g_lpz[l_ac].lpz09,g_lpz[l_ac].lpz10,g_lpz[l_ac].lpz11,g_lpz[l_ac].lpz12,
                        g_lpz[l_ac].lpz13,g_lpz[l_ac].lpz14,g_lpz[l_ac].lpz15,g_lpz[l_ac].lpz16,
                        g_lpz[l_ac].lpz17,g_lpz[l_ac].lpzacti,                                   #FUN-B50042 remove POS
                        g_lpy.lpyplant,g_lpy.lpylegal)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","lpz_file",g_lpy.lpy02,g_lpz[l_ac].lpz05,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K.'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
                
        BEFORE FIELD lpz05
           IF cl_null(g_lpz[l_ac].lpz05) OR g_lpz[l_ac].lpz05 = 0 THEN 
              SELECT max(lpz05)+1 INTO g_lpz[l_ac].lpz05
                FROM lpz_file
               WHERE lpz01 = g_lpy.lpy02
                 AND lpz06 = g_lpy.lpy01
                  IF g_lpz[l_ac].lpz05 IS NULL THEN
                     LET g_lpz[l_ac].lpz05=1
                  END IF
           END IF
         
        AFTER FIELD lpz05 #项次
           IF NOT cl_null(g_lpz[l_ac].lpz05) THEN 
              IF p_cmd = 'a' OR (p_cmd = 'u' AND 
                              g_lpz[l_ac].lpz05 <> g_lpz_t.lpz05) THEN
                 SELECT COUNT(*) INTO l_n FROM lpz_file
                  WHERE lpz01 = g_lpy.lpy02 
                    AND lpz06 = g_lpy.lpy01
                    AND lpz05 = g_lpz[l_ac].lpz05
                 IF l_n>0 THEN
                    CALL cl_err('',-239,0)
                    LET g_lpz[l_ac].lpz05=g_lpz_t.lpz05
                    NEXT FIELD lpz05
                 END IF
              END IF
           END IF

        AFTER FIELD lpz02
           IF NOT cl_null(g_lpz[l_ac].lpz02) THEN
              CALL t670_lpz02(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD lpz02
              END IF
              CALL t670_lpz02_1()  #FUN-BA0097 add
           END IF

        BEFORE FIELD lpz03,lpz04
           IF cl_null(g_lpz[l_ac].lpz02) AND g_lpy01 = '0' THEN
              NEXT FIELD lpz02
           END IF

        AFTER FIELD lpz03 #起始编号
           IF NOT cl_null(g_lpz[l_ac].lpz03) THEN 
              IF p_cmd = 'a' OR (p_cmd = 'u' AND 
                              g_lpz[l_ac].lpz03 <> g_lpz_t.lpz03) THEN
              CALL t670_lpz03(g_lpz[l_ac].lpz03,p_cmd)
                 RETURNING l_lpx22,l_lpx23
                 IF NOT cl_null(g_lpz[l_ac].lpz04) AND cl_null(g_errno) THEN
                    IF g_lpy01 MATCHES '[0]' THEN   #FUN-BC0048 add
                       #FUN-BA0097------add----str----
                    
                       CALL t670_lpz03_lpz04_1()
                       IF NOT cl_null(g_errno) THEN
                          CALL cl_err('',g_errno,0)
                          LET g_lpz[l_ac].lpz03 = g_lpz_t.lpz03
                          NEXT FIELD lpz03
                       END IF
                    #FUN-BA0097------add----end----
                    END IF   #FUN-BC0048 add
                    #FUN-BC0048 start
                    SELECT DISTINCT lqe02,lpx02,lqe03,lrz02,lpx32
                         INTO g_lpz[l_ac].lpz02,g_lpz[l_ac].lpz02_desc,g_lpz[l_ac].lpz07,
                              g_lpz[l_ac].lpz07_desc,l_lpx32
                         FROM lqe_file											
                    LEFT JOIN lpx_file											
                           ON lqe02 = lpx01											
                    LEFT JOIN lrz_file											
                           ON lqe03 = lrz01	
                        WHERE lqe01 BETWEEN g_lpz[l_ac].lpz03 AND g_lpz[l_ac].lpz04 
                    CALL  t670_lpz03_lpz04_chk(g_lpz[l_ac].lpz02,g_lpz[l_ac].lpz03,
                           g_lpz[l_ac].lpz04,g_lpz[l_ac].lpz05)  
                    IF g_success = 'N' THEN
                       NEXT FIELD lpz03 
                    END IF
                    IF g_lpz[l_ac].lpz03 > g_lpz[l_ac].lpz04 THEN
                       LET g_errno = 'aim-919'
                    END IF
                    #FUN-BC0048 end
                   ##CHI-C80030 add begin---
                   #IF cl_null(l_lpx23) THEN
                   #   LET l_start = g_lpz[l_ac].lpz03
                   #   LET l_end   = g_lpz[l_ac].lpz04
                   #ELSE
                   ##CHI-C80030 add end-----
                       LET l_start = g_lpz[l_ac].lpz03[l_lpx22+1,LENGTH(g_lpz[l_ac].lpz03)]
                       LET l_end   = g_lpz[l_ac].lpz04[l_lpx22+1,LENGTH(g_lpz[l_ac].lpz04)]
                   #END IF    #CHI-C80030 add
                    IF l_end < l_start THEN
                       CALL cl_err('','aim-919',0)
                       NEXT FIELD lpz03
                    END IF
                     
                    LET g_lpz[l_ac].lpz08 = l_end - l_start + 1
                    LET g_lpz[l_ac].lpz09 = g_lpz[l_ac].lpz07_desc * g_lpz[l_ac].lpz08
                    DISPLAY BY NAME g_lpz[l_ac].lpz08,g_lpz[l_ac].lpz09
                    
                    CALL t670_lpz10()
                    IF g_lpz[l_ac].lpz08 < 0 THEN
                       LET g_errno = 'aim-919'
                    END IF
                    IF cl_null(g_errno) THEN
                       CALL s_showmsg_init()
                       LET g_success = 'Y'
                       CALL t670_diss(g_lpz[l_ac].lpz03,l_start,l_end,l_lpx22)
                       CALL t670_y_chk()
                       #FUN-BC0048 add---
                       IF g_lpy01 MATCHES '[356]' THEN 
                          CALL t670_lpz03_lpz04_check(g_lpz[l_ac].lpz03,g_lpz[l_ac].lpz04)  #FUN-BC0048 add
                       END IF    
                       IF g_success = 'N' THEN
                          CALL s_showmsg()
                          NEXT FIELD lpz03 
                       END IF
                       #FUN-BC0048 end ---
                    END IF
                 END IF
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_lpz[l_ac].lpz03,g_errno,0)
                    LET g_lpz[l_ac].lpz03 = g_lpz_t.lpz03
                    DISPLAY BY NAME g_lpz[l_ac].lpz03
                    NEXT FIELD lpz03
                 END IF
              END IF
           END IF
       
        AFTER FIELD lpz04 #结束编号
           IF NOT cl_null(g_lpz[l_ac].lpz04) THEN 
              IF p_cmd = 'a' OR (p_cmd = 'u' AND 
                                 g_lpz[l_ac].lpz04 <> g_lpz_t.lpz04) THEN
                 CALL t670_lpz03(g_lpz[l_ac].lpz04,p_cmd)             
                    RETURNING l_lpx22,l_lpx23
                 IF NOT cl_null(g_lpz[l_ac].lpz03) AND cl_null(g_errno) THEN
                    IF g_lpy01 MATCHES '[0]' THEN  #FUN-BC0048 add
                       #FUN-BA0097------add----str----
                       CALL t670_lpz03_lpz04_1()   
                       IF NOT cl_null(g_errno) THEN
                          CALL cl_err('',g_errno,0)
                          LET g_lpz[l_ac].lpz04 = g_lpz_t.lpz04
                          NEXT FIELD lpz04
                       END IF
                       #FUN-BA0097------add----end----
                    END IF    #FUN-BC0048 add
                    #FUN-BC0048 add
                    SELECT DISTINCT lqe02,lpx02,lqe03,lrz02,lpx32
                         INTO g_lpz[l_ac].lpz02,g_lpz[l_ac].lpz02_desc,g_lpz[l_ac].lpz07,
                              g_lpz[l_ac].lpz07_desc,l_lpx32
                         FROM lqe_file											
                    LEFT JOIN lpx_file											
                           ON lqe02 = lpx01											
                    LEFT JOIN lrz_file											
                           ON lqe03 = lrz01	
                        WHERE lqe01 BETWEEN g_lpz[l_ac].lpz03 AND g_lpz[l_ac].lpz04 
                    CALL t670_lpz03_lpz04_chk(g_lpz[l_ac].lpz02,g_lpz[l_ac].lpz03,
                                 g_lpz[l_ac].lpz04,g_lpz[l_ac].lpz05)  
                    IF g_success = 'N' THEN
                       NEXT FIELD lpz04 
                    END IF
                    #FUN-BC0048 end
                   ##CHI-C80030 add begin---
                   #IF cl_null(l_lpx23) THEN
                   #   LET l_start = g_lpz[l_ac].lpz03
                   #   LET l_end  = g_lpz[l_ac].lpz04
                   #ELSE
                   ##CHI-C80030 add end-----
                       LET l_start = g_lpz[l_ac].lpz03[l_lpx22+1,LENGTH(g_lpz[l_ac].lpz03)]
                       LET l_end  = g_lpz[l_ac].lpz04[l_lpx22+1,LENGTH(g_lpz[l_ac].lpz04)]
                   #END IF   #CHI-C80030 add
                    IF l_end < l_start THEN
                       CALL cl_err('','aim-919',0)
                       NEXT FIELD lpz04
                    END IF
                    LET g_lpz[l_ac].lpz08 = l_end - l_start + 1
                    LET g_lpz[l_ac].lpz09 = g_lpz[l_ac].lpz07_desc * g_lpz[l_ac].lpz08
                    DISPLAY BY NAME g_lpz[l_ac].lpz08,g_lpz[l_ac].lpz09
                  
                    CALL t670_lpz10()
                    IF g_lpz[l_ac].lpz08 < 0 THEN
                       LET g_errno = 'aim-919'
                    END IF
                    IF cl_null(g_errno) THEN
                       CALL s_showmsg_init()
                       LET g_success = 'Y'
                       CALL t670_diss(g_lpz[l_ac].lpz04,l_start,l_end,l_lpx22)
                       CALL t670_y_chk()
                       #FUN-BC0048 add ---
                       IF g_lpy01 MATCHES '[356]' THEN 
                          CALL t670_lpz03_lpz04_check(g_lpz[l_ac].lpz03,g_lpz[l_ac].lpz04)  #FUN-BC0048 add
                       END IF  
                       IF g_success = 'N' THEN
                          CALL s_showmsg()
                          NEXT FIELD lpz04
                       END IF
                       #FUN-BC0048 end ---
                    END IF
                 END IF
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_lpz[l_ac].lpz04,g_errno,0)
                    LET g_lpz[l_ac].lpz04 = g_lpz_t.lpz04
                    DISPLAY BY NAME g_lpz[l_ac].lpz04
                    NEXT FIELD lpz04
                 END IF
              END IF
           END IF
           
       AFTER FIELD lpz15 #发售机构
         IF NOT cl_null(g_lpz[l_ac].lpz15) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND 
                              g_lpz[l_ac].lpz15 <> g_lpz_t.lpz15) THEN
               CALL t670_lpz15(p_cmd)
               IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_lpz[l_ac].lpz15,g_errno,0)
                 LET g_lpz[l_ac].lpz15 = g_lpz_t.lpz15
                 DISPLAY BY NAME g_lpz[l_ac].lpz15
                 NEXT FIELD lpz15
               END IF
            END IF
         END IF
               
       AFTER FIELD lpz16 #订单号
         IF NOT cl_null(g_lpz[l_ac].lpz16) THEN
               IF NOT cl_null(g_lpz[l_ac].lpz15) THEN
                  LET g_errno = ''
               #No.TQC-A10173 -BEGIN-----
               #  SELECT azp03 INTO l_dbs FROM azp_file
               #   WHERE azp01 = g_lpz[l_ac].lpz15
                  LET g_plant_new = g_lpz[l_ac].lpz15
                  CALL s_gettrandbs()
                  LET l_dbs = g_dbs_tra
               #No.TQC-A10173 -END-------
                 #FUN-A50102--mod--str--
                 #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"oeb_file ",
                 #            " WHERE oeb01 = ?"
                  LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_lpz[l_ac].lpz15,'oeb_file'),
                              " WHERE oeb01 = ?"
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                  CALL cl_parse_qry_sql(g_sql,g_lpz[l_ac].lpz15) RETURNING g_sql
                 #FUN-A50102--mod--end
                  PREPARE oeb01_cs FROM g_sql
                  EXECUTE oeb01_cs INTO g_cnt USING g_lpz[l_ac].lpz16
                  IF g_cnt = 0 THEN
                     LET g_errno = 'art-258'                     
                  END IF
                  IF NOT cl_null(g_lpz[l_ac].lpz17) AND cl_null(g_errno) THEN
                    #CALL t670_lpz17(l_dbs)   #FUN-A50102
                     CALL t670_lpz17(g_lpz[l_ac].lpz15)    #FUN-A50102
                     IF cl_null(g_errno) THEN
                       #CALL t670_chk_lpz16(l_dbs,p_cmd)   #FUN-A50102
                        CALL t670_chk_lpz16(g_lpz[l_ac].lpz15,p_cmd)   #FUN-A50102
                     END IF
                  END IF 
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_lpz[l_ac].lpz16,g_errno,0)
                     LET g_lpz[l_ac].lpz16 = g_lpz_t.lpz16
                     LET g_lpz[l_ac].lpz17 = g_lpz_t.lpz17
                     DISPLAY BY NAME g_lpz[l_ac].lpz16,g_lpz[l_ac].lpz17
                     NEXT FIELD lpz16
                  END IF
               END IF
         END IF
         
       AFTER FIELD lpz17 #项次
         IF NOT cl_null(g_lpz[l_ac].lpz17) THEN
               IF NOT cl_null(g_lpz[l_ac].lpz15) THEN
                  IF NOT cl_null(g_lpz[l_ac].lpz16) THEN
                  #No.TQC-A10173 -BEGIN-----
                  #  SELECT azp03 INTO l_dbs FROM azp_file
                  #   WHERE azp01 = g_lpz[l_ac].lpz15
                     LET g_plant_new = g_lpz[l_ac].lpz15
                     CALL s_gettrandbs()
                     LET l_dbs = g_dbs_tra
                  #No.TQC-A10173 -END-------
                    #CALL t670_lpz17(l_dbs)   #FUN-A50102
                     CALL t670_lpz17(g_lpz[l_ac].lpz15)    #FUN-A50102
                     IF cl_null(g_errno) THEN
                       #CALL t670_chk_lpz16(l_dbs,p_cmd)   #FUN-A50102
                        CALL t670_chk_lpz16(g_lpz[l_ac].lpz15,p_cmd)   #FUN-A50102
                     END IF
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_lpz[l_ac].lpz17,g_errno,0)
                        LET g_lpz[l_ac].lpz17 = g_lpz_t.lpz17
                        LET g_lpz[l_ac].lpz16 = g_lpz_t.lpz16
                        DISPLAY BY NAME g_lpz[l_ac].lpz16,g_lpz[l_ac].lpz17
                        NEXT FIELD lpz17
                     END IF
                  END IF
               END IF
         END IF

       AFTER FIELD lpz07
          IF NOT cl_null(g_lpz[l_ac].lpz07) THEN
             CALL t670_lpz07(p_cmd)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_lpz[l_ac].lpz07,g_errno,0)
                LET g_lpz[l_ac].lpz07 = g_lpz_t.lpz07
                DISPLAY BY NAME g_lpz[l_ac].lpz07
                NEXT FIELD lpz07
             ELSE
                LET g_lpz[l_ac].lpz09 = g_lpz[l_ac].lpz07_desc * g_lpz[l_ac].lpz08
                DISPLAY BY NAME g_lpz[l_ac].lpz09
             END IF
          END IF

       AFTER FIELD lpz10 #折扣率
         IF NOT cl_null(g_lpz[l_ac].lpz10) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND 
                              g_lpz[l_ac].lpz10 <> g_lpz_t.lpz10) THEN
               CALL t670_lpz10()
               IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_lpz[l_ac].lpz10,g_errno,0)
                 LET g_lpz[l_ac].lpz10 = g_lpz_t.lpz10
                 DISPLAY BY NAME g_lpz[l_ac].lpz10
                 NEXT FIELD lpz10
               END IF
            END IF
         END IF
       
       AFTER FIELD lpz13,lpz14 #起始/结束日期
         IF NOT cl_null(g_lpz[l_ac].lpz13) AND
            NOT cl_null(g_lpz[l_ac].lpz14) THEN
            IF g_lpz[l_ac].lpz13 > g_lpz[l_ac].lpz14 THEN
               CALL cl_err('','alm-237',0)
               NEXT FIELD CURRENT
            END IF
         END IF
         
       BEFORE DELETE                      
           IF g_lpz_t.lpz05 > 0 AND NOT cl_null(g_lpz_t.lpz05) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
             #FUN-A30030 ADD-----------------------
             #No:FUN-B50042 --START--             
              #IF g_aza.aza88='Y' THEN
              #   IF g_lpz[l_ac].lpzacti='Y' OR g_lpz[l_ac].lpzpos='N' THEN
              #      CALL cl_err('','apc-139',0)
              #      CANCEL DELETE
              #   END IF
              #END IF
             #No:FUN-B50042 --END--
             #FUN-A30030 END-----------------------
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM lpz_file
               WHERE lpz01 = g_lpy.lpy02
                 AND lpz06 = g_lpy.lpy01
                 AND lpz05 = g_lpz_t.lpz05
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","lpz_file",g_lpy.lpy01,g_lpz_t.lpz05,SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_lpz[l_ac].* = g_lpz_t.*
              CLOSE t670_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           #FUN-A30030 ADDD--------------------
           #IF g_aza.aza88 ='Y' THEN              #FUN-B50042 mark
           #   LET g_lpz[l_ac].lpzpos='N'         #FUN-B50042 mark
           #   DISPLAY BY NAME g_lpz[l_ac].lpzpos #FUN-B50042 mark
           #END IF                                #FUN-B50042 mark
           #FUN-A30030 END--------------------
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lpz[l_ac].lpz05,-263,1)
              LET g_lpz[l_ac].* = g_lpz_t.*
           ELSE
             
              UPDATE lpz_file SET lpz02 = g_lpz[l_ac].lpz02,
                                     lpz03 = g_lpz[l_ac].lpz03,
                                     lpz04 = g_lpz[l_ac].lpz04,
                                     lpz05 = g_lpz[l_ac].lpz05,
                                     lpz07 = g_lpz[l_ac].lpz07,
                                     lpz08 = g_lpz[l_ac].lpz08,
                                     lpz09 = g_lpz[l_ac].lpz09,
                                     lpz10 = g_lpz[l_ac].lpz10,
                                     lpz11 = g_lpz[l_ac].lpz11,
                                     lpz12 = g_lpz[l_ac].lpz12,
                                     lpz13 = g_lpz[l_ac].lpz13,
                                     lpz14 = g_lpz[l_ac].lpz14,
                                     lpz15 = g_lpz[l_ac].lpz15,
                                     lpz16 = g_lpz[l_ac].lpz16,
                                     lpz17 = g_lpz[l_ac].lpz17,
                                     lpzacti = g_lpz[l_ac].lpzacti
                                     #lpzpos = g_lpz[l_ac].lpzpos    #FUN-B50042 mark
                 WHERE lpz01 = g_lpy.lpy02
                   AND lpz06 = g_lpy.lpy01
                   AND lpz05 = g_lpz_t.lpz05
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","lpz_file",g_lpy.lpy02,g_lpz_t.lpz05,SQLCA.sqlcode,"","",1) 
                 LET g_lpz[l_ac].* = g_lpz_t.*
              ELSE                
                 MESSAGE 'UPDATE O.K.'
                 COMMIT WORK
              END IF
           END IF

        AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac       #FUN-D30033 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_lpz[l_ac].* = g_lpz_t.*
              #FUN-D30033--add--str--
              ELSE
                 CALL g_lpz.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end--
              END IF
              CLOSE t670_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac       #FUN-D30033 Add
           CLOSE t670_bcl
           COMMIT WORK
        #FUN-BC0048 start
        ON ACTION coupon_state
           CALL t670_coupon_state()
        ON ACTION dial_out
           CALL t670_dial_out() 
        ON ACTION scrap_note
           CALL t670_scrap_note()
        ON ACTION dial_in
           CALL t670_dial_out() 
        #FUN-BC0048 end     
        ON ACTION CONTROLO                        
           IF INFIELD(lpz05) AND l_ac > 1 THEN
              LET g_lpz[l_ac].* = g_lpz[l_ac-1].*
              LET g_lpz[l_ac].lpz05 = g_rec_b + 1
              NEXT FIELD lpz05
           END IF

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION controlp                         
          CASE
            WHEN INFIELD(lpz02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lpx_02"
               LET g_qryparam.default1 = g_lpz[l_ac].lpz02
               CALL cl_create_qry() RETURNING g_lpz[l_ac].lpz02
               DISPLAY BY NAME g_lpz[l_ac].lpz02
               CALL t670_lpz02('d')
               NEXT FIELD lpz02
            WHEN INFIELD(lpz07)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lrz"
               LET g_qryparam.default1 = g_lpz[l_ac].lpz07
               CALL cl_create_qry() RETURNING g_lpz[l_ac].lpz07
               DISPLAY BY NAME g_lpz[l_ac].lpz07
               CALL t670_lpz07('d')
               NEXT FIELD lpz07
            WHEN INFIELD(lpz15)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azp" 
               LET g_qryparam.where = " azp01 IN ",g_auth," "
               LET g_qryparam.default1 = g_lpz[l_ac].lpz15
               CALL cl_create_qry() RETURNING g_lpz[l_ac].lpz15
               DISPLAY BY NAME g_lpz[l_ac].lpz15
               CALL t670_lpz15('d')
               NEXT FIELD lpz15
            WHEN INFIELD(lpz16)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_oeb01" 
               LET g_qryparam.default1 = g_lpz[l_ac].lpz16
              #No.TQC-A10173 -BEGIN-----
              #SELECT azp03 INTO l_dbs FROM azp_file
              #    WHERE azp01 = g_lpz[l_ac].lpz15
              #LET g_qryparam.arg1 = l_dbs
               LET g_qryparam.where = " oebplant IN ",g_auth," "
              #No.TQC-A10173 -END-------
               CALL cl_create_qry() RETURNING g_lpz[l_ac].lpz16,g_lpz[l_ac].lpz17
               DISPLAY BY NAME g_lpz[l_ac].lpz16,g_lpz[l_ac].lpz17
               NEXT FIELD lpz16
            WHEN INFIELD(lpz17)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_oeb01" 
               LET g_qryparam.default1 = g_lpz[l_ac].lpz17
              #No.TQC-A10173 -BEGIN-----
              #SELECT azp03 INTO l_dbs FROM azp_file
              #    WHERE azp01 = g_lpz[l_ac].lpz15
              #LET g_qryparam.arg1 = l_dbs
               LET g_qryparam.where = " oebplant IN ",g_auth," "
              #No.TQC-A10173 -END-------
               CALL cl_create_qry() RETURNING g_lpz[l_ac].lpz16,g_lpz[l_ac].lpz17
               DISPLAY BY NAME g_lpz[l_ac].lpz16,g_lpz[l_ac].lpz17
               NEXT FIELD lpz17
            OTHERWISE EXIT CASE
          END CASE
     
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about       
           CALL cl_about()     
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
    END INPUT
    LET g_lpy.lpymodu = g_user
    LET g_lpy.lpydate = g_today
    UPDATE lpy_file SET lpymodu = g_lpy.lpymodu,
                        lpydate = g_lpy.lpydate
     WHERE lpy01 = g_lpy.lpy01
       AND lpy02 = g_lpy.lpy02
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       CALL cl_err3("upd","lpy_file",g_lpy.lpymodu,g_lpy.lpydate,SQLCA.sqlcode,"","",1)
    END IF
    DISPLAY BY NAME g_lpy.lpymodu,g_lpy.lpydate
    CLOSE t670_bcl
    COMMIT WORK
#   CALL t670_delall() #CHI-C30002 mark
    CALL t670_delHeader()     #CHI-C30002 add
    CALL t670_show()
END FUNCTION 

#CHI-C30002 -------- add -------- begin
FUNCTION t670_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_lpy.lpy02) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM lpy_file ",
                  "  WHERE lpy02 LIKE '",l_slip,"%' ",
                  "    AND lpy02 > '",g_lpy.lpy02,"'"
      PREPARE t670_pb1 FROM l_sql 
      EXECUTE t670_pb1 INTO l_cnt      
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         CALL t670_c()
         IF g_lpy.lpy13 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF 
         CALL cl_set_field_pic(g_lpy.lpy13,g_lpy.lpy12,'','',g_void,g_lpy.lpyacti)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM lpy_file
          WHERE lpy01 = g_lpy.lpy01
            AND lpy02 = g_lpy.lpy02
         INITIALIZE g_lpy.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t670_delall()
#删除单头资料
#  SELECT COUNT(*) INTO g_cnt FROM lpz_file
#   WHERE lpz01 = g_lpy.lpy02
#     AND lpz06 = g_lpy.lpy01
#  IF g_cnt = 0 THEN
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED

#     DELETE FROM lpy_file
#      WHERE lpy01 = g_lpy.lpy01
#        AND lpy02 = g_lpy.lpy02
#     CLEAR FORM 
#     INITIALIZE g_lpy.* TO NULL
#  END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end

FUNCTION t670_b_init(p_cnt)
DEFINE p_cnt LIKE type_file.num5
    
    SELECT rtz13 INTO g_lpz[p_cnt].lpz15_desc
      FROM rtz_file
     WHERE rtz01 = g_lpz[p_cnt].lpz15
       AND rtz28 = 'Y'
    
    SELECT lpx02 INTO g_lpz[p_cnt].lpz02_desc
      FROM lpx_file
     WHERE lpx01 = g_lpz[p_cnt].lpz02
       AND lpx15 = 'Y'
    SELECT lrz02 INTO g_lpz[p_cnt].lpz07_desc
      FROM lrz_file
     WHERE lrz01 = g_lpz[p_cnt].lpz07
       AND lrz03 = 'Y' 
END FUNCTION

#FUN-BA0097------add----str-------
#檢查券號不可在同一張券登記單重複
FUNCTION t670_lpz03_lpz04_1()
DEFINE l_cnt       LIKE type_file.num10

    LET g_errno = ''
    SELECT COUNT(*) INTO l_cnt
      FROM lqe_file
     WHERE lqe01 BETWEEN g_lpz[l_ac].lpz03 AND g_lpz[l_ac].lpz04
    IF l_cnt > 0 THEN
       LET g_errno = 'alm1586'
    END IF
END FUNCTION

FUNCTION t670_lpz03_lpz04()
 DEFINE l_lpx32        LIKE lpx_file.lpx32,
        l_sql          STRING,
        l_lpz02        LIKE lpz_file.lpz01,
        l_sum_lpz08    LIKE lpz_file.lpz08,
        l_lpx32_1      LIKE lpx_file.lpx32,
        l_ima25        LIKE ima_file.ima25,
        l_rcj03        LIKE rcj_file.rcj03,
        l_rtz07        LIKE rtz_file.rtz07,
        l_rtz08        LIKE rtz_file.rtz08,
        l_warehouse    LIKE rtz_file.rtz08,
        l_img10        LIKE img_file.img10,
        l_lqe_cnt      LIKE type_file.num5
  
    LET g_lpz0 = 'Y'
    CALL s_showmsg_init() 
    LET l_sql = " SELECT lpz02,lpx32,SUM(lpz08) ",
                "   FROM lpz_file ",
                "  INNER JOIN lpx_file ",
                "     ON lpz02 = lpx01 ",
                "  WHERE lpz06 = '0' ",
                "    AND lpz01 = '",g_lpy.lpy02,"' ",
                "    AND lpx32 IS NOT NULL",
                "  GROUP BY lpz02,lpx32 "
    PREPARE pre_sel_lpz02 FROM l_sql
    DECLARE curs_lpz02 CURSOR FOR pre_sel_lpz02
    FOREACH curs_lpz02 INTO l_lpz02,l_lpx32,l_sum_lpz08
       LET l_lpx32_1 = l_lpx32[1,4]
       IF NOT cl_null(l_lpx32) AND l_lpx32_1 <> 'MISC' THEN
          SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = l_lpx32      
          SELECT rcj03 INTO l_rcj03 FROM rcj_file
             IF cl_null(l_rcj03) THEN
                LET g_lpz0 = 'N'
                CALL cl_err('','alm1442',0)
                RETURN
             END IF  
         #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08 FROM rtz_file WHERE rtz01 = g_lpy.lpyplant    #FUN-C90049 mark
          CALL s_get_defstore(g_lpy.lpyplant,l_lpx32 ) RETURNING l_rtz07,l_rtz08                #FUN-C90049 add
             IF l_rcj03 = '1' AND cl_null(l_rtz07) THEN
                LET g_lpz0 = 'N'
                CALL cl_err(g_lpy.lpyplant,'alm1443',0)
                RETURN
             END IF 
             IF l_rcj03 = '2' AND cl_null(l_rtz08) THEN
                LET g_lpz0 = 'N'
                CALL cl_err(g_lpy.lpyplant,'alm1444',0)
                RETURN
             END IF
             IF l_rcj03 = '1' THEN
                LET l_warehouse = l_rtz07
             ELSE
                LET l_warehouse = l_rtz08
             END IF
          SELECT img10 INTO l_img10
            FROM img_file
           WHERE img01 = l_lpx32
             AND img02 = l_warehouse
             AND img03 = ' '
             AND img04 = ' '
             AND img09 = l_ima25
          SELECT COUNT(*) INTO l_lqe_cnt
            FROM lqe_file
           WHERE lqe02 = l_lpz02
             AND ((lqe04 = g_lpy.lpyplant AND lqe17 = '0')
              OR (lqe09 = g_lpy.lpyplant AND lqe17 = '2')
              OR (lqe13 = g_lpy.lpyplant AND lqe17 = '5')
              OR (lqe15 = g_lpy.lpyplant AND lqe17 = '6'))
          IF cl_null(l_img10) THEN
             LET l_img10 = 0
          END IF
          IF l_sum_lpz08 > (l_img10 - l_lqe_cnt) THEN
             LET g_lpz0 = 'N' 
             CALL s_errmsg("lpz02",l_lpz02,"",'alm1445',2)
          END IF
       END IF
    END FOREACH
END FUNCTION
#FUN-BA0097------add----end-------

FUNCTION t670_lpz03(p_no,p_cmd)
 DEFINE p_cmd       LIKE type_file.chr1
 DEFINE p_no        LIKE lpz_file.lpz03
# DEFINE l_no        LIKE type_file.chr10   #FUN-BA0097 mark
 DEFINE l_lqe02     LIKE lqe_file.lqe02
 DEFINE l_lqe03     LIKE lqe_file.lqe03
 DEFINE l_lpx01     LIKE lpx_file.lpx01  
# DEFINE l_lpx02     LIKE lpx_file.lpx02    #FUN-BA0097 mark
 DEFINE l_lpx22     LIKE lpx_file.lpx22
 DEFINE l_lpx23     LIKE lpx_file.lpx23
 DEFINE l_lpx24     LIKE lpx_file.lpx24
 DEFINE l_lpz07     LIKE lpx_file.lpx28   
 DEFINE l_lpx15     LIKE lpx_file.lpx15
 DEFINE l_lpxacti   LIKE lpx_file.lpxacti
 DEFINE l_lrz03     LIKE lrz_file.lrz03
 DEFINE l_lrz02     LIKE lrz_file.lrz02 
 DEFINE l_length    LIKE type_file.num5
 DEFINE l_cnt       LIKE type_file.num5
#DEFINE l_slip_length LIKE type_file.num20   #CHI-C80030 add

    LET g_errno = ''

    IF g_lpy01 = '0' THEN
       LET l_lqe02 = g_lpz[l_ac].lpz02
    ELSE
       SELECT lqe02,lqe03 INTO l_lqe02,l_lqe03 FROM lqe_file
        WHERE lqe01 = p_no
       IF SQLCA.sqlcode = 100 THEN
          LET g_errno = 'alm-477'
          RETURN '',''
       END IF
    END IF
    #LET l_no = p_no[1,2]    #FUN-BA0097 mark
    LET l_length = LENGTH(p_no)
    SELECT lpx01,lpx22,lpx23,lpx24,lpx28,lpx15,lpxacti                        #FUN-BA0097 add
      INTO l_lpx01,l_lpx22,l_lpx23,l_lpx24,l_lpz07,l_lpx15,l_lpxacti          #FUN-BA0097 add
    #SELECT lpx01,lpx02,lpx22,lpx23,lpx24,lpx28,lpx15,lpxacti                 #FUN-BA0097 mark
    #  INTO l_lpx01,l_lpx02,l_lpx22,l_lpx23,l_lpx24,l_lpz07,l_lpx15,l_lpxacti #FUN-BA0097 mark
      FROM lpx_file
     WHERE lpx01 = l_lqe02  #lpx23 = l_no
   # CASE WHEN SQLCA.sqlcode = 100 LET g_errno = 'clm-332'  #FUN-BC0082 mark
     CASE WHEN SQLCA.sqlcode = 100 LET g_errno = 'alm1562'  #FUN-BC0082 add
         WHEN l_lpxacti = 'N'     LET g_errno = '9028'
         WHEN l_lpx15 <> 'Y'      LET g_errno = 'aap-084'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) THEN
      ##CHI-C80030 add begin---
      #IF cl_null(l_lpx23) THEN
      #   LET l_slip_length = LENGTH(p_no)
      #ELSE
      #   LET l_slip_length = LENGTH(p_no) - l_lpx22
      #END IF
      ##CHI-C80030 add end-----
       #IF LENGTH(p_no) - LENGTH(l_lpx23) <> l_lpx24 OR l_lpx23 <> p_no[1,l_lpx22] THEN #MOD-CA0064 mark
       IF LENGTH(p_no) - l_lpx22 <> l_lpx24 OR l_lpx23 <> p_no[1,l_lpx22] THEN          #MOD-CA0064 add     #CHI-C80030 mark
      #IF l_slip_length <> l_lpx24 OR l_lpx23 <> p_no[1,l_lpx22] THEN                   #CHI-C80030 add
          LET g_errno = 'alm-388'
       ELSE
          IF NOT cl_null(l_lpz07) THEN
             SELECT lrz02,lrz03 INTO l_lrz02,l_lrz03   
               FROM lrz_file
              WHERE lrz01 = l_lpz07
             CASE WHEN SQLCA.sqlcode = 100 LET g_errno = 'alm-392'
                  WHEN l_lrz03 = 'N'       LET g_errno = '9028'
                  OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
             END CASE
             CALL cl_set_comp_entry("lpz07",FALSE)
             CALL cl_set_comp_required("lpz07",FALSE)
         #FUN-D10040----mark---str
         #ELSE
         #   IF g_lpy01 = '0' THEN
         #      CALL cl_set_comp_entry("lpz07",TRUE)
         #      CALL cl_set_comp_required("lpz07",TRUE)
         #   ELSE
         #      LET l_lpz07 = l_lqe03
         #      SELECT lrz02 INTO l_lrz02 FROM lrz_file
         #       WHERE lrz01 = l_lpz07
         #   END IF
         #FUN-D10040----mark---end
          END IF
       END IF
       SELECT COUNT(*) INTO l_cnt FROM lnk_file
        WHERE lnk01 = l_lpx01
          AND lnk02 = '2'
          AND lnk03 = g_lpy.lpyplant
          AND lnk05 = 'Y'
       IF l_cnt < 1 THEN
          LET g_errno = 'alm-395'
       END IF
    END IF
    IF cl_null(g_errno) THEN
       #FUN-BA0097----add----str----
       IF p_cmd ='a' THEN
          SELECT COUNT(*) INTO l_cnt
            FROM lpz_file
           WHERE lpz01 = g_lpy.lpy02
             AND ((g_lpz[l_ac].lpz03 BETWEEN lpz03 AND lpz04)
              OR (g_lpz[l_ac].lpz04 BETWEEN lpz03 AND lpz04))
          IF l_cnt > 0 THEN
             LET g_errno = 'alm1585'
          END IF
       END IF
       IF p_cmd ='u' THEN
          SELECT COUNT(*) INTO l_cnt
            FROM lpz_file
           WHERE lpz01 = g_lpy.lpy02
             AND lpz05 <> l_ac
             AND ((g_lpz[l_ac].lpz03 BETWEEN lpz03 AND lpz04)
              OR (g_lpz[l_ac].lpz04 BETWEEN lpz03 AND lpz04))
          IF l_cnt > 0 THEN
             LET g_errno = 'alm1585'
          END IF
       END IF
       #FUN-BA0097----add----end----
       #FUN-BA0097----mark---str----
       #SELECT COUNT(*) INTO g_cnt FROM lpz_file
       # WHERE lpz01 = g_lpy.lpy02
       #   AND lpz06 = g_lpy.lpy01
       #   AND lpz05 <> l_ac           #FUN-BC0048 add
       ##  AND substr(lpz03,l_lpx22,l_length) <= substr(p_no,l_lpx22,l_length)
       ##  AND substr(lpz04,l_lpx22,l_length) >= substr(p_no,l_lpx22,l_length)
       ##  AND substr(lpz03,1,l_lpx22) = l_lpx23
       #   AND lpz03 <= p_no
       #   AND lpz04 >= p_no
       ##  AND lpz02 = l_lpx01   #FUN-BA0097 mark
       #IF g_cnt > 0 THEN
       #   LET g_errno = '-239'
       #END IF
       #FUN-BA0097----mark---end----
       #FUN-BC0048 MARK start---
       #IF NOT cl_null(g_lpz[l_ac].lpz03) AND NOT cl_null(g_lpz[l_ac].lpz04) THEN
       #   IF g_lpz[l_ac].lpz03 > g_lpz[l_ac].lpz04 THEN
       #     LET g_errno = 'aim-919'
       #   END IF
          #No.FUN-9B0136 BEGIN -------
          #FUN-BA0097-----mark----str-------
         #IF cl_null(g_errno) THEN
         #   SELECT COUNT(*) INTO g_cnt FROM lqe_file
         #    WHERE lqe01 >= g_lpz[l_ac].lpz03
         #      AND lqe01 <= g_lpz[l_ac].lpz04
         #      AND lqe02 = l_lpx01
         #      AND lqe03 <> l_lpz07
         #   IF g_cnt > 1 THEN
         #      LET g_errno = 'alm-698'
         #   END IF
          #No.FUN-9B0136 END ------
         # END IF
          #FUN-BA0097-----mark----end-------
       #END IF
       #FUN-BC0048 MARK end---
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_lpz[l_ac].lpz02 = l_lpx01
#FUN-BA0097---mark-----str--------
#      LET g_lpz[l_ac].lpz02_desc = l_lpx02
#      LET g_lpz[l_ac].lpz07 = l_lpz07
#      LET g_lpz[l_ac].lpz07_desc = l_lrz02
#      DISPLAY BY NAME g_lpz[l_ac].lpz02,g_lpz[l_ac].lpz02_desc,
#                      g_lpz[l_ac].lpz07,g_lpz[l_ac].lpz07_desc
#FUN-BA0097---mark----end---------
      DISPLAY BY NAME g_lpz[l_ac].lpz02   #FUN-BA0097 add
    END IF
   RETURN l_lpx22,l_lpx23
END FUNCTION

FUNCTION t670_lpz07(p_cmd)
 DEFINE p_cmd    LIKE type_file.chr1
 DEFINE l_lrz02  LIKE lrz_file.lrz02
 DEFINE l_lrz03  LIKE lrz_file.lrz03

   LET g_errno = ''

   SELECT lrz02,lrz03 INTO l_lrz02,l_lrz03
     FROM lrz_file 
    WHERE lrz01 = g_lpz[l_ac].lpz07
   CASE WHEN SQLCA.sqlcode = 100 LET g_errno = 'alm-392'
        WHEN l_lrz03 = 'N'       LET g_errno = '9028'
        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      LET g_lpz[l_ac].lpz07_desc = l_lrz02
      DISPLAY BY NAME g_lpz[l_ac].lpz07_desc
   END IF
END FUNCTION

FUNCTION t670_lpz10()
   
   LET g_errno = ''
   IF g_lpz[l_ac].lpz10 >=0 AND g_lpz[l_ac].lpz10 <=100 THEN
      LET g_lpz[l_ac].lpz11 = g_lpz[l_ac].lpz09 * (1 - g_lpz[l_ac].lpz10/100)
      LET g_lpz[l_ac].lpz12 = g_lpz[l_ac].lpz09 - g_lpz[l_ac].lpz11
      DISPLAY BY NAME g_lpz[l_ac].lpz11,g_lpz[l_ac].lpz12
   ELSE
      LET g_errno = 'atm-070'
   END IF
END FUNCTION

FUNCTION t670_lpz15(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
DEFINE l_rtz13 LIKE rtz_file.rtz13
DEFINE l_rtz28 LIKE rtz_file.rtz13
DEFINE l_azp02 LIKE azp_file.azp02

    LET g_errno = ''
   #SELECT rtz13,rtz28
   #  INTO l_rtz13,l_rtz28
   #  FROM rtz_file     
   # WHERE rtz01 = g_lpz[l_ac].lpz15
   #   AND rtz01 IN (SELECT azw01 FROM azw_file
   #                  WHERE azw07=g_lpy.lpyplant OR azw01=g_lpy.lpyplant)
   #CASE WHEN SQLCA.sqlcode = 100 LET g_errno = 'art-044'
   #     WHEN l_rtz28 = 'N'       LET g_errno = 'alm-002'
   #     OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   #END CASE
   #IF cl_null(g_errno) OR p_cmd = 'd' THEN
   #   LET g_lpz[l_ac].lpz15_desc = l_rtz13
   #   DISPLAY BY NAME g_lpz[l_ac].lpz15_desc
   #END IF
   #No.FUN-A10060 -BEGIN-------
   #SELECT azp02
   #  INTO l_azp02
   #  FROM azp_file     
   # WHERE azp01 = g_lpz[l_ac].lpz15
   #   AND azp01 IN (SELECT azw01 FROM azw_file
   #                  WHERE azw07=g_lpy.lpyplant OR azw01=g_lpy.lpyplant)
    LET g_sql = " SELECT azp02 FROM azp_file ",
                "  WHERE azp01 = '",g_lpz[l_ac].lpz15,"'",
                "    AND azp01 IN ",g_auth," "
    PREPARE sel_azp_pre01 FROM g_sql
    EXECUTE sel_azp_pre01 INTO l_azp02
   #No.FUN-A10060 -END-------
    CASE WHEN SQLCA.sqlcode = 100 LET g_errno = 'art-500'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_lpz[l_ac].lpz15_desc = l_azp02
       DISPLAY BY NAME g_lpz[l_ac].lpz15_desc 
    END IF
END FUNCTION

#FUNCTION t670_lpz17(l_dbs)   #FUN-A50102
FUNCTION t670_lpz17(l_plant)    #FUN-A50102
#DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_plant LIKE azp_file.azp01    #FUN-A50102
    
    LET g_errno = ''
   #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"oeb_file ",
    LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'oeb_file'),
                " WHERE oeb01 = ? AND oeb03 = ?"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
    CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql   #FUN-A50102
    PREPARE oeb03_cs FROM g_sql
    EXECUTE oeb03_cs USING g_lpz[l_ac].lpz16,g_lpz[l_ac].lpz17
                      INTO g_cnt
    IF g_cnt = 0 THEN
       LET g_errno = 'art-362'
    END IF
END FUNCTION

#FUNCTION t670_chk_lpz16(l_dbs,p_cmd)   #FUN-A50102
FUNCTION t670_chk_lpz16(l_plant,p_cmd)  #FUN-A50102
#DEFINE l_dbs      LIKE azp_file.azp03  #FUN-A50102
DEFINE l_plant    LIKE azp_file.azp01   #FUN-A50102
DEFINE p_cmd      LIKE type_file.chr1
DEFINE l_oeb04    LIKE oeb_file.oeb04
DEFINE l_oeb12    LIKE oeb_file.oeb12  #bnl
DEFINE l_ima154   LIKE ima_file.ima154
DEFINE l_lpx32    LIKE lpx_file.lpx32
DEFINE l_oebplant LIKE oeb_file.oebplant #No.TQC-A10173
DEFINE l_cnt      LIKE type_file.num5    #No.TQC-A10165

    LET g_errno = ''
   #LET g_sql = "SELECT oebplant,oeb04,oeb12 FROM ",l_dbs CLIPPED,"oeb_file ",   #FUN-A50102
    LET g_sql = "SELECT oebplant,oeb04,oeb12 FROM ",cl_get_target_table(l_plant,'oeb_file'),   #FUN-A50102
                " WHERE oeb01 = ? AND oeb03 = ?"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-A50102
    CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql  #FUN-A50102
    PREPARE oeb04_cs FROM g_sql
    EXECUTE oeb04_cs USING g_lpz[l_ac].lpz16,g_lpz[l_ac].lpz17
                      INTO l_oebplant,l_oeb04,l_oeb12
    CASE WHEN SQLCA.sqlcode = 100 LET g_errno = 'aco-012'
         WHEN l_oebplant != g_lpz[l_ac].lpz15
                                  LET g_errno = 'alm-709' #No.TQC-A10173 Add
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) THEN
      #LET g_sql = "SELECT ima154 FROM ",l_dbs CLIPPED,"ima_file ",   #FUN-A50102
       LET g_sql = "SELECT ima154 FROM ",cl_get_target_table(l_plant,'ima_file'),   #FUN-A50102
                   " WHERE ima01 = ?"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
       CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql   #FUN-A50102
       PREPARE ima154_cs FROM g_sql
       EXECUTE ima154_cs USING l_oeb04 INTO l_ima154
       IF l_ima154 = 'N' THEN
       #   LET g_errno = 'clm-333'  
           LET g_errno = 'alm1563' # FUN-BC0082 
       ELSE
          SELECT lpx32 INTO l_lpx32 FROM lpx_file
           WHERE lpx01 = g_lpz[l_ac].lpz02
          IF l_lpx32 = l_oeb04 THEN
             IF g_lpz[l_ac].lpz08 <> l_oeb12 THEN
       #         LET g_errno = 'clm-334'       #FUN-BC0082 mark
                 LET g_errno = 'alm1576'       #FUN-BC0082 add   
             END IF
          ELSE
       #      LET g_errno = 'clm-335'          #FUN-BC0082 mark
              LET g_errno = 'alm1577'          #FUN-BC0082 add
          END IF
       END IF
    END IF
   #No.TQC-A10165 -BEGIN-----
    IF cl_null(g_errno) AND g_lpy01 = '1' THEN
       IF p_cmd = 'a' OR (p_cmd = 'u' AND (g_lpz[l_ac].lpz16 != g_lpz_t.lpz16 OR
                                       g_lpz[l_ac].lpz17 != g_lpz_t.lpz17)) THEN
          LET l_cnt = 0
          SELECT COUNT(*) INTO l_cnt FROM lpz_file,lpy_file
           WHERE lpz16 = g_lpz[l_ac].lpz16
             AND lpz17 = g_lpz[l_ac].lpz17
             AND lpy02 = lpz01
             AND lpyacti = 'Y'
             AND lpy13 <> 'X'  #CHI-C80041
             AND lpz06 = '1'
          IF l_cnt > 0 THEN
             LET g_errno = 'alm-710'
          END IF
       END IF
    END IF
   #No.TQC-A10165 -END-------
END FUNCTION

FUNCTION t670_diss(p_no,l_start,l_end,l_lpx22)
DEFINE p_no LIKE lpz_file.lpz03
DEFINE l_start LIKE type_file.num20
DEFINE l_end LIKE type_file.num20
DEFINE l_min         LIKE type_file.num20
DEFINE l_lpx22       LIKE lpx_file.lpx22
DEFINE l_db_type     LIKE type_file.chr4  #TQC-A70103
DEFINE l_no          LIKE type_file.chr20 #TQC-A70103
DEFINE l_length      LIKE type_file.num5  #TQC-A70103

      DELETE FROM t670_tmp5
      LET l_min = l_end - l_start + 1 
#TQC-A70103--Begin
      LET l_no = p_no[1,l_lpx22]
      LET l_db_type=cl_db_get_database_type()
      IF l_db_type='MSV' THEN
         LET l_length = LENGTH(p_no)-l_lpx22
         CALL t670_create_sql1()
         EXECUTE stmt1 USING l_start IN,l_end IN,l_min IN,l_no IN,l_length IN
      ELSE
#TQC-A70103--End
      LET g_sql = "INSERT INTO t670_tmp5 ",
                # "SELECT CONCAT('",p_no[1,l_lpx22],"',LPAD(to_char(id) + '",
                # l_start-1,"','",LENGTH(p_no)-l_lpx22,"','0')) AS lpz041",
                  "SELECT ('",p_no[1,l_lpx22],"'|| ",
                #No.FUN-A80008 -BEGIN-----
                # " substr(power(10,",LENGTH(p_no)-l_lpx22,"-length(to_char(id+",l_start-1,"))) || to_char(id+",l_start-1,"),2)) AS lpz041",
                  " substr(power(10,",LENGTH(p_no)-l_lpx22,"-length(id+",l_start-1,")) || (id+",l_start-1,"),2)) AS lpz041",
                #No.FUN-A80008 -END-------
                  " FROM (SELECT level AS id FROM dual ",
                  " CONNECT BY level <= '",l_min,"')"
      PREPARE pre_ins_tmp5 FROM g_sql
      EXECUTE pre_ins_tmp5            
      END IF #TQC-A70103
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL s_errmsg('','','insert temp t670_tmp5',SQLCA.sqlcode,1)
         RETURN
      END IF
END FUNCTION
#FUN-BC0048 start ---
#IF g_argv1 = '4' 檢查券起訖編號範圍內是否有包含非 0.登記 或 6.回收 狀態的券
#IF g_argv1 = '5' 檢查券起訖編號範圍內是否有包含非 2.退回 或 5.發放 狀態的券
#IF g_argv1 = '3' 檢查券起訖編號範圍內的狀態是否符合
FUNCTION t670_lpz03_lpz04_check(l_lpz03,l_lpz04) #栏位检查和确认的时候都要用到

DEFINE l_lqe01   LIKE lqe_file.lqe01
DEFINE l_lpz03   LIKE lpz_file.lpz03
DEFINE l_lpz04   LIKE lpz_file.lpz04 

   LET g_sql = "SELECT lqe01 FROM lqe_file ",
               " WHERE lqe01 BETWEEN '",l_lpz03,"' AND '",l_lpz04,"'"
               
   IF g_lpy01 = '5' THEN 
      LET g_sql = g_sql CLIPPED ,
                 "   AND lqe01 NOT IN ( SELECT lqe01 ", 
                            "  FROM lqe_file ",
                            " WHERE lqe01 BETWEEN '",l_lpz03,"' AND '",l_lpz04,"'",
                            "   AND lqe17 = '0' ",
                            "   AND lqe04 = '",g_lpy.lpyplant,"')",
                 "   AND lqe01 NOT IN ( SELECT lqe01 ", 
                            "  FROM lqe_file ",
                            " WHERE lqe01 BETWEEN '",l_lpz03,"' AND '",l_lpz04,"'",
                            "   AND lqe17 = '6' ",
                            "   AND lqe04 = '",g_lpy.lpyplant,"')"     
   END IF 

   IF g_lpy01 = '6' THEN 
      LET g_sql = g_sql CLIPPED ,
                "   AND lqe01 NOT IN ( SELECT lqe01 ", 
                            "  FROM lqe_file ",
                            " WHERE lqe01 BETWEEN '",l_lpz03,"' AND '",l_lpz04,"'",
                            "   AND lqe17 = '2' ",
                            "   AND lqe04 = '",g_lpy.lpyplant,"'",
                            "   AND lqe09 = '",g_lpy.lpy19,"')",
                "   AND lqe01 NOT IN ( SELECT lqe01 ", 
                            "  FROM lqe_file ",
                            " WHERE lqe01 BETWEEN '",l_lpz03,"' AND '",l_lpz04,"' ",
                            "   AND lqe17 = '5' ",
                            "   AND lqe04 = '",g_lpy.lpyplant,"'" ,
                            "   AND lqe13 = '",g_lpy.lpy19,"')"    
   END IF 
   IF g_lpy01 = '3' THEN 
      LET g_sql = g_sql CLIPPED ,
                 "   AND lqe01 NOT IN ( SELECT lqe01 ", 
                            "  FROM lqe_file ",
                            " WHERE lqe01 BETWEEN '",l_lpz03,"' AND '",l_lpz04,"'",
                            "   AND lqe17 = '0' ",
                            "   AND lqe04 = '",g_lpy.lpyplant,"')",
                 "   AND lqe01 NOT IN ( SELECT lqe01 ", 
                            "  FROM lqe_file ",
                            " WHERE lqe01 BETWEEN '",l_lpz03,"' AND '",l_lpz04,"'",
                            "   AND lqe17 = '6' ",
                            "   AND lqe04 = '",g_lpy.lpyplant,"')",     
                "   AND lqe01 NOT IN ( SELECT lqe01 ", 
                            "  FROM lqe_file ",
                            " WHERE lqe01 BETWEEN '",l_lpz03,"' AND '",l_lpz04,"'",
                            "   AND lqe17 = '2' ",
                            "   AND lqe04 = '",g_lpy.lpyplant,"'",
                            "   AND lqe09 = '",g_lpy.lpyplant,"')",
                "   AND lqe01 NOT IN ( SELECT lqe01 ", 
                            "  FROM lqe_file ",
                            " WHERE lqe01 BETWEEN '",l_lpz03,"' AND '",l_lpz04,"' ",
                            "   AND lqe17 = '5' ",
                            "   AND lqe04 = '",g_lpy.lpyplant,"'" ,
                            "   AND lqe13 = '",g_lpy.lpyplant,"')"    
   END IF   
   PREPARE t670_lqe01 FROM g_sql
   DECLARE lqe01_cs CURSOR FOR t670_lqe01

   FOREACH lqe01_cs INTO l_lqe01 
       IF SQLCA.sqlcode THEN
          LET g_success = 'N'
          CALL s_errmsg('','','lqe01_cs',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_success = 'N'
       IF g_lpy01 = '5' THEN 
          LET g_errno = 'alm1460'
       END IF 
       #FUN-BC0061 start 
       IF g_lpy01 = '6' THEN 
          LET g_errno = 'alm1461'   
       END IF  
       IF g_lpy01 = '3' THEN 
          LET g_errno = 'alm1502'   
       END IF  
       #FUN-BC0061 end       
       CALL s_errmsg('lqe01',l_lqe01,'',g_errno,1) 

   END FOREACH     
END FUNCTION
FUNCTION  t670_lpz03_lpz04_chk(l_lpz02,l_lpz03,l_lpz04,l_lpz05)  
DEFINE l_lpz02   LIKE lpz_file.lpz02
DEFINE l_lpz03   LIKE lpz_file.lpz03
DEFINE l_lpz04   LIKE lpz_file.lpz04
DEFINE l_lpz05   LIKE lpz_file.lpz05 
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_lqe02_1 LIKE lqe_file.lqe02
DEFINE l_lqe02_2 LIKE lqe_file.lqe02
DEFINE l_n1      LIKE type_file.num5 
DEFINE l_n2      LIKE type_file.num5 
DEFINE l_lpx32_1 LIKE lpx_file.lpx32 
DEFINE l_lpx32   LIKE lpx_file.lpx32  
   LET g_success = 'Y' 
   #檢查券起訖編號範圍內是否有不同的券種
   IF g_lpy01 = '3' OR g_lpy01 = '5' OR g_lpy01 = '6' THEN 
      SELECT lqe02 INTO l_lqe02_1
        FROM lqe_file
       WHERE lqe01 = l_lpz03 
      SELECT lqe02 INTO l_lqe02_2
        FROM lqe_file
       WHERE lqe01 = l_lpz04 
      IF l_lqe02_1 <> l_lqe02_2 THEN 
         CALL cl_err_msg("","alm1481",l_lpz03 CLIPPED|| "|" || l_lpz04 CLIPPED,10) 
         LET g_success = 'N'
         RETURN 
      END IF     
      SELECT COUNT(DISTINCT lqe02) INTO l_cnt
        FROM lqe_file
       WHERE lqe01 BETWEEN l_lpz03 AND l_lpz04
      IF l_cnt > 1 THEN 
        #lpz03值 + "~" + lpz04值 + " 有多種券種，請分開發放！
         CALL cl_err_msg("","alm1481",l_lpz03 CLIPPED|| "|" || l_lpz04 CLIPPED,10) 
         LET g_success = 'N'
         RETURN 
      END IF    
   END IF
   #檢查券起訖編號範圍內是否有面額不同的券
   IF g_lpy01 = '3' OR g_lpy01 = '5' OR g_lpy01 = '6' THEN  
      SELECT COUNT(DISTINCT lqe03) INTO l_cnt
        FROM lqe_file
       WHERE lqe01 BETWEEN l_lpz03 AND l_lpz04
      IF l_cnt > 1 THEN 
         CALL cl_err_msg("","alm1480",l_lpz03 CLIPPED|| "|" || l_lpz04 CLIPPED,10) 
         #lpz03值 + "~" + lpz04值 + " 有多種券面額，請分開發放！
         LET g_success = 'N'
         RETURN 
      END IF    
   END IF 

   # 檢查發放營運中心是否符合券種是生效範圍
   IF g_lpy01 = '5' THEN 
     # IF NOT cl_null(g_lpy.lpy19) THEN  
         SELECT COUNT(*) INTO l_cnt
           FROM lnk_file
          WHERE lnk01 = l_lpz02 
            AND lnk02 = '2' 
            AND lnk03 = g_lpy.lpy19
            AND lnk05 = 'Y'
         IF l_cnt = 0 THEN 
            #l_lpz02 + "券種在發放營運中心無生效資料，
            #請檢查 almi660(券類型維護作業) 券的使用範圍！'
            CALL cl_err_msg("","alm1482",l_lpz02,10) 
            LET g_success = 'N'
            RETURN 
         END IF  
     # END IF          
   END IF
   IF g_lpy01 = '5' OR g_lpy01 = '6' OR g_lpy01 = '3' THEN  #FUN-BC0061 
   # 檢查同一張單據單身中, 所有券種對應產品不可同時包含 'MISC' 開頭
   #及非 'MISC' 開頭的料號
      SELECT lpx32 INTO l_lpx32 FROM lpx_file
       WHERE lpx01 = l_lpz02      
      LET l_n1 = 0 
      LET l_n2 = 0
      IF NOT cl_null(g_lpz_t.lpz05) THEN 
         LET l_lpz05 = g_lpz_t.lpz05
      END IF    
      LET l_lpx32_1 = l_lpx32[1,4]
      IF l_lpx32_1 = 'MISC' THEN 
         SELECT COUNT(lpx32) INTO l_n1 
           FROM lpz_file,lpx_file
          WHERE lpz01 = g_lpy.lpy02
            AND lpz02 = lpx01
            AND lpz05 <> l_lpz05
            AND lpx32 NOT LIKE 'MISC%'   
      ELSE
         SELECT COUNT(lpx32) INTO l_n1 
           FROM lpz_file,lpx_file
          WHERE lpz01 = g_lpy.lpy02
            AND lpz02 = lpx01
            AND lpz05 <> l_lpz05
            AND lpx32 LIKE 'MISC%' 
      END IF       
      IF l_n1 > 0 THEN 
         CASE  g_lpy01
            WHEN '3' 
               LET g_errno = 'alm1537'
            WHEN '5' 
               LET g_errno = 'alm1458'
            WHEN '6'
               LET g_errno = 'alm1459'
         END CASE
         LET g_success = 'N'
         CALL cl_err('',g_errno,0)
         
         RETURN  
      END IF 
   END IF 
END FUNCTION 
FUNCTION t670_y_new2() 
DEFINE l_lpx32    LIKE lpx_file.lpx32
DEFINE l_lpx32_1  LIKE lpx_file.lpx32
DEFINE l_lpz      DYNAMIC ARRAY OF RECORD LIKE lpz_file.*
DEFINE l_sql      STRING   #FUN-C30258 add
   SELECT lpx32 INTO l_lpx32
     FROM lqe_file
LEFT JOIN lpx_file 
       ON lqe02 = lpx01
    WHERE lqe01 = g_lpz[1].lpz03
   LET l_lpx32_1 = l_lpx32[1,4] 
   
   IF (NOT cl_null(l_lpx32) AND (l_lpx32_1 <> 'MISC' ))
      AND (g_lpy.lpy19 <> g_lpy.lpyplant) THEN
      IF g_lpy01 = '5' OR g_lpy01 = '6' THEN 
         CALL t670_out_insert_ruo()
         IF g_success = 'N' THEN 
            RETURN 
         END IF    
         CALL t670_out_insert_rup() 
         IF g_success = 'N' THEN 
            RETURN 
         END IF 

        #對產生的撥出單做撥出確認. 請參考 artt256.4gl 中的 t256_out_yes() 
         CALL t670_out_yes()
         IF g_success = 'N' THEN 
            RETURN 
         END IF 
        #. 對撥入單做撥入確認. 請參考 artt256.4gl 中的 t256_in_yes()
         IF g_sma.sma142 = 'Y' THEN    #啟用在途  #FUN-C30247 add 
            CALL t670_in_yes()
            IF g_success = 'N' THEN 
               RETURN 
            END IF  
        #FUN-C30258 add START
         ELSE
            LET l_sql = "SELECT ruo011  FROM ",cl_get_target_table(g_ruo04,'ruo_file'),
                        " WHERE ruo01 = '", g_ruo01,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,g_ruo04) RETURNING l_sql
            PREPARE t670_ruo_4 FROM l_sql
            EXECUTE t670_ruo_4 INTO g_ruo011 
        #FUN-C30258 add END
         END IF  #FUN-C30247 add 
      END IF 
   END IF    
   #FUN-BC0061 start
   IF (NOT cl_null(l_lpx32) AND (l_lpx32_1 <> 'MISC' )) THEN
      IF g_lpy01 = '3' THEN
         LET g_lpy.lpy15 = g_today 
         IF NOT t670_chk_ina02() THEN 
            LET g_success = 'N' 
            RETURN 
         END IF 
         CALL t670_insert_ina()  
         IF g_success = 'N' THEN 
            RETURN 
         END IF  
         CALL t670_insert_inb()  
         IF g_success = 'N' THEN 
            RETURN 
         END IF 
         CALL t370sub_y_upd(g_ina01,'N',TRUE)  
         IF g_success = 'N' THEN 
            RETURN 
         END IF       
         CALL t370sub_s_upd(g_ina01,'5',TRUE)
         IF g_success = 'N' THEN
            RETURN
         END IF 
      END IF 
   END IF    
   #FUN-BC0061 end   
END FUNCTION 
 
FUNCTION t670_getruo14()
DEFINE l_azw08     LIKE azw_file.azw08 
DEFINE l_plant1    LIKE azp_file.azp01 
   LET g_errno = " "
   IF g_sma.sma142 = 'Y' THEN   #在途管理
      IF g_sma.sma143 = '1' THEN
         LET l_plant1 = g_ruo04
      ELSE
         LET l_plant1 = g_ruo05
      END IF
      SELECT imd01 INTO g_ruo14 FROM imd_file 
       WHERE imd10 = 'W' AND imd20 = l_plant1 AND imd22 = "Y"
      CASE WHEN SQLCA.SQLCODE = 100  
                              LET g_errno = 'art-965' #未維護默認倉資料
                              #CALL s_errmsg('ru014','','sel ruo14','art-965',1)
                              RETURN
           OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
      END CASE
   END IF   
END FUNCTION    
FUNCTION t670_getruo901()
   DEFINE l_azw02_1   LIKE azw_file.azw02
   DEFINE l_azw02_2   LIKE azw_file.azw02
   SELECT azw02 INTO l_azw02_1
     FROM azw_file WHERE azw01 = g_ruo04
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 100
                           #CALL s_errmsg('azw01','','sel azw01','100',1)
                           RETURN
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   SELECT azw02 INTO l_azw02_2
     FROM azw_file WHERE azw01 = g_ruo05
   CASE WHEN SQLCA.SQLCODE = 100  
                           #LET g_errno = 100
                           CALL s_errmsg('azw01','','sel azw01','100',1)
                           RETURN
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
  
   IF l_azw02_1 <> l_azw02_2 THEN
      LET g_ruo901 = "Y"
   ELSE
      LET g_ruo901 = "N"
   END IF
   
END FUNCTION 
FUNCTION t670_v()     #多角貿易
DEFINE l_poz02   LIKE poz_file.poz02
DEFINE l_poy03   LIKE poy_file.poy03
DEFINE l_poy31   LIKE poy_file.poy03
DEFINE l_poy32   LIKE poy_file.poy03
DEFINE l_poy33   LIKE poy_file.poy03
DEFINE l_poy34   LIKE poy_file.poy03
DEFINE l_poy35   LIKE poy_file.poy03
DEFINE l_poy36   LIKE poy_file.poy03
DEFINE i         LIKE type_file.num5
DEFINE l_ruo     RECORD LIKE ruo_file.*
SELECT * INTO l_ruo.* FROM ruo_file 
 WHERE ruo01 = g_ruo01 
   OPEN WINDOW t670_vw WITH FORM "alm/42f/almt670_2"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("almt670_2")
      
   LET l_poz02 = NULL
   LET l_poy31 = NULL  LET l_poy32 = NULL
   LET l_poy33 = NULL  LET l_poy34 = NULL
   LET l_poy35 = NULL  LET l_poy36 = NULL
         
   CALL t670_v_1()
   CLOSE WINDOW t670_vw

END FUNCTION

FUNCTION t670_v_1()
DEFINE      l_poz02   LIKE poz_file.poz02
DEFINE      l_poy03   LIKE poy_file.poy03
DEFINE      l_poy3    LIKE poy_file.poy03
DEFINE      l_poy31   LIKE poy_file.poy03
DEFINE      l_poy32   LIKE poy_file.poy03
DEFINE      l_poy33   LIKE poy_file.poy03
DEFINE      l_poy34   LIKE poy_file.poy03
DEFINE      l_poy35   LIKE poy_file.poy03
DEFINE      l_poy36   LIKE poy_file.poy03
DEFINE      i         LIKE type_file.num5
DEFINE l_poz          RECORD LIKE poz_file.*
DEFINE l_ruo          RECORD LIKE ruo_file.*
#SELECT * INTO l_ruo.* FROM ruo_file 
# WHERE ruo01 = g_ruo01 
   LET l_ruo.ruo904 = NULL
   INPUT BY NAME l_ruo.ruo904 WITHOUT DEFAULTS
      ON CHANGE  ruo904
         IF NOT cl_null(l_ruo.ruo904)  THEN
            CALL t670_ruo904(l_ruo.ruo904)
            IF NOT cl_null(g_errno)  THEN
               CALL cl_err(l_ruo.ruo904,g_errno,1)
               #CALL s_errmsg('ruo904',l_ruo.ruo904,'sel poy_file',g_errno,1)
               
             #  LET g_ruo904 = g_ruo_t.ruo904
               NEXT FIELD ruo904
            ELSE  
               LET g_ruo904 = l_ruo.ruo904   
            END IF
            FOR i = 0 TO 6
                SELECT poy03 INTO l_poy03 FROM poy_file
                 WHERE poy01 = l_ruo.ruo904 AND poy02 = i
                IF SQLCA.sqlcode = 100 THEN
                   LET l_poy03 = NULL
                END IF
                CASE i
                   WHEN 0 LET l_poy31 = l_poy03
                   WHEN 1 LET l_poy32 = l_poy03
                   WHEN 2 LET l_poy33 = l_poy03
                   WHEN 3 LET l_poy34 = l_poy03
                   WHEN 4 LET l_poy35 = l_poy03
                   WHEN 5 LET l_poy36 = l_poy03
                END CASE
            END FOR
            SELECT poz02 INTO l_poz02 FROM poz_file WHERE poz01 = l_ruo.ruo904
            DISPLAY l_poz02 TO FORMONLY.poz02
            DISPLAY l_poy31 TO FORMONLY.poy31
            DISPLAY l_poy32 TO FORMONLY.poy32
            DISPLAY l_poy33 TO FORMONLY.poy33
            DISPLAY l_poy34 TO FORMONLY.poy34
            DISPLAY l_poy35 TO FORMONLY.poy35
            DISPLAY l_poy36 TO FORMONLY.poy36               
        
         END IF

         ON ACTION CONTROLP
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_poz1"
            LET g_qryparam.arg1 = '2'
            LET g_qryparam.default1 = l_ruo.ruo904
            CALL cl_create_qry() RETURNING l_ruo.ruo904
            DISPLAY BY NAME l_ruo.ruo904
            NEXT FIELD ruo904

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION exit
            EXIT INPUT

      END INPUT
      IF INT_FLAG THEN
         LET g_success = 'N'
         LET INT_FLAG = 0
         #LET g_ruo904 = g_ruo_t.ruo904
      END IF
END FUNCTION

FUNCTION t670_ruo904(l_ruo904)
DEFINE p_cmd               LIKE type_file.chr1
DEFINE l_poz               RECORD LIKE poz_file.*
DEFINE l_poy04_min         LIKE poy_file.poy04
DEFINE l_poy04_max         LIKE poy_file.poy04
DEFINE l_ruo904            LIKE ruo_file.ruo904
   LET g_errno = NULL
   
   SELECT * INTO l_poz.* FROM poz_file
    WHERE poz01 = l_ruo904
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'tri-006'
       WHEN l_poz.pozacti='N'    LET g_errno = '9028'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) AND (l_poz.poz00 = '1' OR l_poz.poz011 = '1') THEN #類別必須為代採購
     LET g_errno= 'art-969'
     RETURN
  END IF
  IF cl_null(g_errno) THEN
     SELECT poy04 INTO l_poy04_min
       FROM poy_file
      WHERE poy01 = l_ruo904
        AND poy02 = (SELECT MIN(poy02) FROM poy_file WHERE poy01 = l_ruo904)
        
     SELECT poy04 INTO l_poy04_max
       FROM poy_file
      WHERE poy01 = l_ruo904
        AND poy02 = (SELECT MAX(poy02) FROM poy_file WHERE poy01 = l_ruo904)
       
     IF l_poy04_min <> g_ruo05 THEN
        LET g_errno = 'art-970'
        RETURN
     END IF
     IF l_poy04_max <> g_ruo04 THEN
        LET g_errno = 'art-971'
        RETURN
     END IF     
  END IF
END FUNCTION
FUNCTION t670_out_yes()                    
DEFINE l_ruo      RECORD LIKE ruo_file.* 
DEFINE l_rup      RECORD LIKE rup_file.*
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_img10    LIKE img_file.img10
DEFINE l_sql      STRING
   LET l_sql = "SELECT *  FROM ",cl_get_target_table(g_ruo04,'ruo_file'),
               " WHERE ruo01 = '", g_ruo01,"' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
   CALL cl_parse_qry_sql(l_sql,g_ruo04) RETURNING l_sql             
   PREPARE t670_ruo_1 FROM l_sql
   EXECUTE t670_ruo_1 INTO l_ruo.*
   LET l_cnt=0
   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_ruo04,'rup_file'),
               " WHERE rup01= '",g_ruo01,"' "," AND rupplant = '",g_ruo04,"' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
   CALL cl_parse_qry_sql(l_sql,g_ruo04) RETURNING l_sql             
   PREPARE t670_rup_1 FROM l_sql
   EXECUTE t670_rup_1 INTO l_cnt          
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL s_errmsg('','','sel rup',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   LET l_sql = "SELECT * FROM ",cl_get_target_table(g_ruo04,'rup_file'),
               " WHERE rup01= '",g_ruo01,"' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
   CALL cl_parse_qry_sql(l_sql,g_ruo04) RETURNING l_sql                   
   PREPARE t670_rup1 FROM l_sql
   DECLARE rup_cs1 CURSOR FOR t670_rup1
   FOREACH rup_cs1 INTO l_rup.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF      
      #撥出倉庫是否屬於撥出營運中心
      IF NOT s_chk_ware1(l_rup.rup09,g_ruo04) THEN
         LET g_showmsg = l_rup.rup09,'/',g_ruo04
         CALL s_errmsg('rup09,ruo04',g_showmsg,'','art1005',1)
         LET g_success = 'N'
         RETURN
      END IF
      IF g_sma.sma142 = 'N' THEN   #不啟用在途倉
        #撥入倉庫是否屬於撥入營運中心
        #IF NOT s_chk_ware1(l_rup.rup13,g_ruo04) THEN   #TQC-C30233 mark
        #   LET g_showmsg = l_rup.rup13,'/',g_ruo04     #TQC-C30233 mark
         IF NOT s_chk_ware1(l_rup.rup13,g_ruo05) THEN   #TQC-C30233 add
            LET g_showmsg = l_rup.rup13,'/',g_ruo05     #TQC-C30233 add      
            CALL s_errmsg('rup13,ruo04',g_showmsg,'','art1006',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      ####check_img10檢查庫存數量
       IF cl_null(l_rup.rup10) THEN
          LET l_rup.rup10 = ' ' 
       END IF 
       IF cl_null(l_rup.rup11) THEN
          LET l_rup.rup11 = ' ' 
       END IF
       LET l_sql = "SELECT img10 FROM ",cl_get_target_table(g_ruo04,'img_file'),
               " WHERE img01 = '", l_rup.rup03,"' ",
               "   AND img02 = '",l_rup.rup09,"' ",
               "   AND img03 = '",l_rup.rup10,"' ",
               "   AND img04 = '",l_rup.rup11,"' "  
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
       CALL cl_parse_qry_sql(l_sql,g_ruo04) RETURNING l_sql                   
       PREPARE t670_img FROM l_sql
       EXECUTE t670_img INTO l_img10      
       IF l_img10 IS NULL THEN LET l_img10 = 0 END IF
    
       IF l_img10 < l_rup.rup12 THEN
          #IF g_act = 'out_yes'THEN
             LET g_errno = 'art-475'
             CALL s_errmsg('rup12',l_rup.rup12,'','art-475',1)
             LET g_success = 'N'
             RETURN
          #END IF
          #IF g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN
          #     CALL cl_err(l_img10,'mfg3471',0)
          #ELSE
          #   IF NOT cl_confirm('mfg3469') THEN
          #      LET g_errno = 'art-475'  
          #   END IF
          #END IF      
       END IF
      IF NOT cl_null(g_errno) THEN 
         LET g_showmsg = l_rup.rup03,'/',l_rup.rup09,'/',l_rup.rup12
         CALL s_errmsg('rup03,rup09,rup12',g_showmsg,'','art1005',1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH    
   IF g_sma.sma142 = 'Y' THEN   #啟用在途倉
      CALL t670_ruo14()           #在途倉是否屬於歸屬營運中心
      IF NOT cl_null(g_errno) THEN
         IF g_sma.sma143 = '1' THEN   #調撥在途歸屬撥出方
            #CALL cl_err('','art1007',0)
            CALL s_errmsg('ruo14',l_ruo.ruo14,'','art1007',1)
            LET g_success = 'N'
            RETURN
         END IF
         IF g_sma.sma143 = '2' THEN   #調撥在途歸屬撥入方
            #CALL cl_err('','art1008',0)
            CALL s_errmsg('ruo14',l_ruo.ruo14,'','art1008',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF

  # CALL t670_temp('1')   

   CALL t256_sub(l_ruo.*,'1','N')
  # CALL t670_temp('2')   
END FUNCTION
FUNCTION t670_in_yes()
DEFINE l_sql           STRING
DEFINE l_cnt           LIKE type_file.num5                        
DEFINE l_ruo1          RECORD LIKE ruo_file.*
DEFINE l_ruo2          RECORD LIKE ruo_file.*
DEFINE l_rup           RECORD LIKE rup_file.*
   LET l_sql = "SELECT *  FROM ",cl_get_target_table(g_ruo04,'ruo_file'),
               " WHERE ruo01 = '", g_ruo01,"' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
   CALL cl_parse_qry_sql(l_sql,g_ruo04) RETURNING l_sql                   
   PREPARE t670_ruo_3 FROM l_sql
   EXECUTE t670_ruo_3 INTO l_ruo1.*
   LET l_sql = "SELECT rup13 FROM ", cl_get_target_table(g_ruo04,'rup_file'),
               " WHERE rup01 = '",g_ruo01 ,"' AND rupplant = '",g_ruo04 ,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
   CALL cl_parse_qry_sql(l_sql,g_ruo04) RETURNING l_sql                   
   PREPARE t670_rup2 FROM l_sql
   DECLARE rup_cs2 CURSOR FOR t670_rup2
   FOREACH rup_cs2 INTO l_rup.rup13
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF      
        #撥入倉庫是否屬於撥入營運中心
      IF NOT s_chk_ware1(l_rup.rup13,g_ruo05) THEN
         LET g_showmsg = l_rup.rup13,'/',g_ruo05
         CALL s_errmsg('rup13,ruo04',g_showmsg,'','art1006',1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH     
   LET l_cnt=0
   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_ruo04,'rup_file'),
               " WHERE rup01= '",g_ruo01,"' "," AND rupplant = '",g_ruo04,"' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
   CALL cl_parse_qry_sql(l_sql,g_ruo04) RETURNING l_sql                   
   PREPARE t670_rup_2 FROM l_sql
   EXECUTE t670_rup_2 INTO l_cnt          
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL s_errmsg('','','sel rup',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   #檢查商品是否有撥入數量和撥入倉庫
   LET l_sql = "SELECT rup03,rup12,rup13,rup16 FROM ",cl_get_target_table(g_ruo04,'rup_file'),
               " WHERE rup01 = '", g_ruo01 ,"' AND rupplant = '",g_ruo04 ,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
   CALL cl_parse_qry_sql(l_sql,g_ruo04) RETURNING l_sql                   
   PREPARE t670_rupx FROM l_sql
   DECLARE rup_csx CURSOR FOR t670_rupx
   FOREACH rup_csx INTO l_rup.rup03,l_rup.rup12,l_rup.rup13,l_rup.rup16
      IF SQLCA.sqlcode THEN
         #CALL cl_err('foreach:',SQLCA.sqlcode,1)
         CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      #判斷是否有撥出數量
      IF l_rup.rup12 IS NULL OR l_rup.rup12 <= 0 THEN 
         #CALL cl_err(l_rup03,'art-317',1)
         CALL s_errmsg('',l_rup.rup12,'sel rup12','art-317',1)
         LET g_success = 'N'
         RETURN
      END IF
      #判斷是否有撥入倉庫     
      IF l_rup.rup13 IS NULL THEN
         #CALL cl_err(l_rup03,'art-318',1)
         CALL s_errmsg('',l_rup.rup13,'sel rup13','art-318',1)
         LET g_success = 'N'
         RETURN
      END IF
      #判斷是否有撥入數量
      IF l_rup.rup16 IS NULL OR l_rup.rup16 <= 0 THEN
         #CALL cl_err(l_rup03,'art-319',1)
         CALL s_errmsg('',l_rup.rup16,'sel rup16','art-319',1)
         LET g_success = 'N'
         RETURN
      END IF
      #判斷撥入數量是否大于撥出數量
      IF l_rup.rup16 > l_rup.rup12 THEN
        # CALL cl_err(l_rup03,'art-320',1)
         CALL s_errmsg('',l_rup.rup13,'sel rup13,rup16','art-320',1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH
  
  # CALL t670_temp('1')  
   LET l_sql = "SELECT rup02,rup13,rup14,rup15,rup16 FROM ",cl_get_target_table(g_ruo04,'rup_file'),
               " WHERE rup01 = '", g_ruo01,"' AND rupplant = '",l_ruo1.ruoplant,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
   CALL cl_parse_qry_sql(l_sql,g_ruo04) RETURNING l_sql                   
   PREPARE t670_rupx1 FROM l_sql
   DECLARE rup_csx1 CURSOR FOR t670_rupx1
   FOREACH rup_csx1 INTO l_rup.rup02,l_rup.rup13,l_rup.rup14,l_rup.rup15,l_rup.rup16
      IF SQLCA.sqlcode THEN
        # CALL cl_err('foreach:',SQLCA.sqlcode,1)
         CALL s_errmsg('','','foreach',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      LET l_sql = "UPDATE ",cl_get_target_table(l_ruo1.ruo05,'rup_file'),
                  "   SET rup13 = '",l_rup.rup13,"',",
                  "       rup14 = '",l_rup.rup14,"',",
                  "       rup15 = '",l_rup.rup15,"',",
                  "       rup16 = '",l_rup.rup16,"'",
                  " WHERE rup01 = '",l_ruo1.ruo011,"'",  
                  "   AND rup02 = '",l_rup.rup02,"'",
                  "   AND rupplant = '",l_ruo1.ruo05,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
      CALL cl_parse_qry_sql(l_sql,l_ruo1.ruo05) RETURNING l_sql 
      PREPARE rup_uprup FROM l_sql
      EXECUTE rup_uprup  
      IF SQLCA.sqlerrd[3]=0 OR SQLCA.sqlcode THEN
        # CALL cl_err('',SQLCA.sqlcode,1)
         CALL s_errmsg('','','update rup_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
   END FOREACH
      
   LET l_sql = "SELECT *  FROM ",cl_get_target_table(g_ruo05,'ruo_file'),
               " WHERE ruo01 = '", l_ruo1.ruo011,"' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
   CALL cl_parse_qry_sql(l_sql,g_ruo05) RETURNING l_sql                   
   PREPARE t670_ruo2 FROM l_sql
   EXECUTE t670_ruo2  INTO l_ruo2.*
   LET g_ruo011 = l_ruo1.ruo011
   CALL t256_sub(l_ruo2.*,'2','N')
  # CALL t670_temp('2')     
END FUNCTION
FUNCTION t670_check_rup03(l_rup03)
DEFINE  l_rup03                     LIKE rup_file.rup03   #產品編號
DEFINE  l_rtz05_1                   LIKE rtz_file.rtz05   #拨出营运中心價格策略
DEFINE  l_rtz05_2                   LIKE rtz_file.rtz05   #拨入营运中心價格策略 　
DEFINE  l_sql                       STRING
DEFINE  l_cnt1,l_cnt2               LIKE type_file.num5
DEFINE  l_aza88                     LIKE aza_file.aza88
DEFINE l_ruo                        RECORD LIKE ruo_file.*

   LET g_errno = "" 
   LET l_sql = " SELECT aza88 FROM ",cl_get_target_table(g_ruo04,'aza_file'),
               "  WHERE aza01 = '0'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql            
   CALL cl_parse_qry_sql(l_sql, g_ruo04) RETURNING l_sql 
   PREPARE pre_aza  FROM l_sql
   EXECUTE pre_aza  INTO l_aza88
                
  IF g_aza.aza88 = "Y" THEN
     SELECT rtz05 INTO l_rtz05_1 FROM rtz_file  #獲取拨出营运中心價格策略代碼                                
      WHERE rtz01 = g_ruo04
     IF NOT cl_null(l_rtz05_1) THEN 
        LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_ruo04, 'rtg_file'),",",
                                            cl_get_target_table(g_ruo04, 'rtf_file'),
                    " WHERE rtg01=rtf01 AND rtfacti='Y' AND rtg09='Y' ",
                    "   AND rtg03= '",l_rup03,"'",
                    "   AND rtg01= '",l_rtz05_1,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
        CALL cl_parse_qry_sql(l_sql, g_lpy.lpy19) RETURNING l_sql
        PREPARE pre2 FROM l_sql
        EXECUTE pre2 INTO l_cnt1
        IF l_cnt1<=0 THEN
           LET g_errno = 'alm1474' 
           CALL s_errmsg('','','',g_errno,1) 
        END IF 
     END IF
   END IF
   IF l_aza88 = 'Y' THEN
      SELECT rtz05 INTO l_rtz05_2 FROM rtz_file  #獲取拨入营运中心價格策略代碼
       WHERE rtz01 = g_ruo05
      IF NOT cl_null(l_rtz05_2) THEN
        LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_ruo05, 'rtg_file'),",",
                                            cl_get_target_table(g_ruo05, 'rtf_file'),
                    " WHERE rtg01=rtf01 AND rtfacti='Y' AND rtg09='Y' ",
                    "   AND rtg03= '",l_rup03,"'",
                    "   AND rtg01= '",l_rtz05_2,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
        CALL cl_parse_qry_sql(l_sql, g_ruo05) RETURNING l_sql
        PREPARE pre3 FROM l_sql
        EXECUTE pre3 INTO l_cnt2  
        IF l_cnt2<=0 THEN
           LET g_errno = 'alm1475'
           CALL s_errmsg('','','',g_errno,1)  
        END IF   
     END IF
  END IF     
    
END FUNCTION

FUNCTION t670_check_rup03_1(l_rup03)    #經營方式
DEFINE l_rup03       LIKE rup_file.rup03   #產品編號
DEFINE l_rtyacti     LIKE rty_file.rtyacti
DEFINE l_rty06_1     LIKE rty_file.rty06
DEFINE l_rty06_2     LIKE rty_file.rty06
DEFINE l_cnt         LIKE type_file.num5
   LET g_errno = ''
    #查詢該商品在撥出營運中心的經營方式
    SELECT rty06,rtyacti INTO l_rty06_1,l_rtyacti
       FROM rty_file WHERE rty01 = g_ruo04
        AND rty02 = l_rup03
    IF l_rtyacti='N' THEN
       LET g_errno = 'alm1476' 
       CALL s_errmsg('','','','alm1476',1)  
       RETURN
    END IF
    #查詢該商品在撥入營運中心的經營方式
    LET l_rtyacti = ''
    SELECT rty06,rtyacti INTO l_rty06_2,l_rtyacti
       FROM rty_file WHERE rty01 = g_ruo05
        AND rty02 = l_rup03
    IF l_rtyacti='N' THEN
       LET g_errno = 'alm1477' 
       CALL s_errmsg('','','',g_errno,1)  
       RETURN
    END IF
    IF l_rty06_1 IS NULL THEN LET l_rty06_1 = '1' END IF
    IF l_rty06_2 IS NULL THEN LET l_rty06_2 = '1' END IF    
    
     SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = g_ruo04 AND azw02 IN
    (SELECT azw02 FROM  azw_file WHERE azw01 = g_ruo05)    
     IF l_cnt > 0 THEN
     #如果該商品在撥出營運中心和撥入營運中心的經營方式不相同，報錯
        IF l_rty06_1 <> l_rty06_2 THEN
            LET g_errno = 'alm1478'
            CALL s_errmsg('','','',g_errno,1) 
            RETURN
        END IF
     ELSE
        IF l_rty06_1 <> '1' OR l_rty06_2 <> '1' THEN
            LET g_errno = 'alm1479'
            CALL s_errmsg('','','',g_errno,1) 
            RETURN
        END IF        
     END IF   　　
END FUNCTION
FUNCTION t670_ruo14()
DEFINE l_imd20   LIKE imd_file.imd20
DEFINE l_imd01   LIKE imd_file.imd01
DEFINE l_cnt     LIKE type_file.num5   

   LET g_errno = " "
   
   IF g_sma.sma142 = "Y" AND g_sma.sma143 = '1' THEN #調撥在途歸屬撥出方
      LET l_imd20 = g_ruo04
   ELSE
      IF g_sma.sma142 = "Y" AND g_sma.sma143 = '2' THEN #調撥在途歸屬撥入方
         LET l_imd20 = g_ruo05
      END IF
   END IF

   SELECT COUNT(*) INTO l_cnt FROM imd_file
     WHERE imd10 = 'W' AND imd20 = l_imd20 AND imd01 = g_ruo14
   IF l_cnt <= 0  THEN
      IF g_sma.sma143 = '1' THEN
         LET g_errno = 'art1007'
      ELSE
         LET g_errno = 'art1008'
      END IF
   END IF
  
END FUNCTION

FUNCTION t670_temp(l_flag)
   DEFINE l_flag  LIKE type_file.num5
   IF l_flag = '1' THEN


      CREATE TEMP TABLE p801_file(
        p_no     LIKE type_file.num5,
        so_no    LIKE pmm_file.pmm01,   #採購單號
        so_item  LIKE type_file.num5,
        so_price LIKE oeb_file.oeb13,   #單價
        so_price2 LIKE pmn_file.pmn31t, #TQC-D70073
        so_curr  LIKE pmm_file.pmm22)   #幣種

      CREATE TEMP TABLE p900_file(
       p_no        LIKE type_file.num5,
       pab_no      LIKE oea_file.oea01, #訂單單號
       pab_item    LIKE type_file.num5,
       pab_price   LIKE type_file.num20_6)
   ELSE
      DROP TABLE p801_file
      DROP TABLE p900_file


   END IF
END FUNCTION

FUNCTION t670_check_b()
DEFINE l_lpz      DYNAMIC ARRAY OF RECORD LIKE lpz_file.*
DEFINE l_n        LIKE type_file.num5   
   LET g_success = 'Y' 
   LET g_sql = "SELECT lpz03,lpz04 FROM lpz_file ",
               " WHERE lpz01 = '",g_lpy.lpy02,"' ",
               "   AND lpz06 = '",g_lpy01,"' "
                
   PREPARE t670_lpz011 FROM g_sql
   DECLARE t670_lpz011_cs CURSOR FOR t670_lpz011
   LET l_n = 1
   FOREACH t670_lpz011_cs INTO l_lpz[l_n].lpz03,l_lpz[l_n].lpz04
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL s_errmsg('','','t670_lpz011_cs',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF 
      CALL t670_lpz03_lpz04_check(l_lpz[l_n].lpz03,l_lpz[l_n].lpz04)
      LET l_n = l_n+1
   END FOREACH
 
END FUNCTION 

FUNCTION t670_out_insert_ruo()
DEFINE l_rye03    LIKE rye_file.rye03
DEFINE l_lpz      DYNAMIC ARRAY OF RECORD LIKE lpz_file.*
DEFINE l_ruo      RECORD LIKE ruo_file.*
   INITIALIZE l_ruo.* TO NULL
   IF g_lpy01 = '5' THEN 
      LET g_ruo04 = g_lpy.lpyplant
      LET g_ruo05 = g_lpy.lpy19
      LET g_ruoplant = g_lpy.lpyplant      
   END IF 
   IF g_lpy01 = '6' THEN 
      LET g_ruo04 = g_lpy.lpy19
      LET g_ruo05 = g_lpy.lpyplant
      LET g_ruoplant = g_lpy.lpy19
   END IF 

   #先取 aooi040 作業所設定營運中心調撥單的預設單號
   #FUN-C90050 mark beign---
   #LET g_sql = "SELECT rye03 FROM ",cl_get_target_table(g_ruo04,'rye_file'),
   #               " WHERE rye01 = 'art' AND rye02 = 'J1'" 
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   #CALL cl_parse_qry_sql(g_sql,g_ruo04) RETURNING g_sql
   #PREPARE pre_sel_rye1 FROM g_sql
   #EXECUTE pre_sel_rye1 INTO l_rye03
   #FUN-C90050 mark end----
   CALL s_get_defslip('art','J1',g_ruo04,'N') RETURNING l_rye03    #FUN-C90050 add  

   IF cl_null(l_rye03) THEN 
      #營運中心調撥單的預設單號未設定，
      #請先執行 預設單別維護作業(aooi410)！
      CALL s_errmsg('rye03',l_rye03,'','alm1463',1) 
      LET g_success = 'N'
      RETURN 
   END IF  
   #參考 artt256.4gl 中的 t256_ruo05(), 取得 g_ruo14
   CALL t670_getruo14()
   IF NOT cl_null(g_errno) THEN 
      CALL s_errmsg('ruo14','','',g_errno,1) 
      LET g_success = 'N'
      RETURN 
   END IF 
   #參考 artt256.4gl 中的 t256_chk_azw02(), 取得 g_ruo901
   CALL t670_getruo901()
   IF cl_null(g_ruo901) THEN 
      CALL s_errmsg('ruo901','','',g_errno,1) 
      LET g_success = 'N'
      RETURN 
   END IF
   #當 g_ruo901 = 'Y' 時, 彈出多角貿易流程代碼選擇窗,
   #參考 artt256.4gl 中的 t256_v() 方式處理.   
   IF g_ruo901 = 'Y' THEN 
      CALL t670_v() 
      IF g_success = 'N' THEN 
         RETURN 
      END IF    
   END IF    
      
   LET g_dd = g_today

   CALL s_check_no("art",l_rye03,"",'',"ruo_file","ruo01","")
      RETURNING li_result,g_ruo01
     
   LET g_t1=s_get_doc_no(g_ruo01)
   CALL s_auto_assign_no("art",l_rye03,g_dd,'',"ruo_file","ruo01",g_ruo04,"","")
   RETURNING li_result,g_ruo01
   IF (NOT li_result) THEN
      LET g_success="N"
      CALL s_errmsg('','','','asf-377',1)
      RETURN
   END IF
   LET l_ruo.ruo01 = g_ruo01 
   LET l_ruo.ruo02 = '6'
   LET l_ruo.ruo03 = g_lpy.lpy02
   LET l_ruo.ruo04 = g_ruo04
   LET l_ruo.ruo05 = g_ruo05
   LET l_ruo.ruoplant = g_ruoplant
   SELECT azw02 INTO l_ruo.ruolegal
     FROM azw_file WHERE azw01 = l_ruo.ruoplant
   LET l_ruo.ruo07 = g_lpy.lpy17
   LET l_ruo.ruo08 = g_user
   LET l_ruo.ruo09 = g_lpy.lpy16
   LET l_ruo.ruo14 = g_ruo14
   LET l_ruo.ruo15 = 'N'
   LET l_ruo.ruo901 = g_ruo901
   LET l_ruo.ruo904 = g_ruo904
   LET l_ruo.ruoacti = 'Y'
  #LET l_ruo.ruoconf = 'N'  #FUN-C30247 mark
   LET l_ruo.ruoconf = '0'  #FUN-C30247 add
   LET l_ruo.ruocrat = g_today
   LET l_ruo.ruogrup = g_grup
   LET l_ruo.ruoorig = g_grup
   LET l_ruo.ruooriu = g_user
   LET l_ruo.ruopos = '1'
   LET l_ruo.ruouser = g_user
   LET l_ruo.ruo10 = ''
   LET l_ruo.ruo12 = ''
   LET l_ruo.ruodate = ''
   #INSERT INTO ruo_file VALUES l_ruo.*
   LET g_sql = "INSERT INTO ",cl_get_target_table(g_ruo04,'ruo_file'),"(",
               "         ruo01,ruo011,ruo02,ruo03,ruo04,ruo05,ruo07,ruo08,ruo09, ",
               "         ruo10,ruo10t,ruo11,ruo12,ruo12t,ruo13,ruo14,ruo15,ruo901,",
               "         ruo904,ruo99,ruoacti,ruoconf,ruocrat,ruodate,ruogrup,",
               "         ruolegal,ruomodu,ruoorig,ruooriu,ruoplant,ruopos,ruouser )",
               "  VALUES(?,?,?,?,?,?,?,?,?,",
               "         ?,?,?,?,?,?,?,?,?,",
               "         ?,?,?,?,?,?,?, ",
               "         ?,?,?,?,?,?,?  )"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql    
   CALL cl_parse_qry_sql(g_sql,g_ruo04) RETURNING g_sql 
   PREPARE ruo_ins FROM g_sql
   EXECUTE ruo_ins USING l_ruo.ruo01,l_ruo.ruo11,l_ruo.ruo02,l_ruo.ruo03,l_ruo.ruo04,
                         l_ruo.ruo05,l_ruo.ruo07,l_ruo.ruo08,l_ruo.ruo09,
                         l_ruo.ruo10,l_ruo.ruo10t,l_ruo.ruo11,l_ruo.ruo12,l_ruo.ruo12t,
                         l_ruo.ruo13,l_ruo.ruo14,l_ruo.ruo15,l_ruo.ruo901,
                         l_ruo.ruo904,l_ruo.ruo99,l_ruo.ruoacti,l_ruo.ruoconf,
                         l_ruo.ruocrat,l_ruo.ruodate,l_ruo.ruogrup,
                         l_ruo.ruolegal,l_ruo.ruomodu,l_ruo.ruoorig,l_ruo.ruooriu,
                         l_ruo.ruoplant,l_ruo.ruopos,l_ruo.ruouser      
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('','','ins ruo',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF 
END FUNCTION 

FUNCTION t670_out_insert_rup()      #依券回收的單身資料, 寫入到調撥單(撥出)單身. 
DEFINE l_lpz      DYNAMIC ARRAY OF RECORD LIKE lpz_file.*
DEFINE l_rcj03    LIKE rcj_file.rcj03
DEFINE l_rup09    LIKE rup_file.rup09
DEFINE l_n        LIKE type_file.num5 
DEFINE l_rup      RECORD LIKE rup_file.*
DEFINE l_ruo      RECORD LIKE ruo_file.*
DEFINE l_ima151   LIKE ima_file.ima151
DEFINE l_imaacti  LIKE ima_file.imaacti
DEFINE l_flag     LIKE type_file.num5  
DEFINE l_fac      LIKE rup_file.rup08
DEFINE l_cnt      LIKE type_file.num5 
DEFINE l_lpx32    LIKE lpx_file.lpx32
   INITIALIZE l_rup.* TO NULL
   SELECT * INTO l_ruo.* FROM ruo_file
    WHERE ruo01 = g_ruo01
   #取 arts100 作業中的 rcj03(券庫存管理倉庫)

   SELECT rcj03 INTO l_rcj03 FROM rcj_file
   IF cl_null(l_rcj03) THEN 
      #券庫存管理倉庫未設定，請先執行 系統參數設定作業-流通零售參數(arts100)！
      CALL s_errmsg('rcj03',l_rcj03,'','alm1464',1) 
      LET g_success = 'N'
      RETURN 
   END IF
   #依 l_rcj03 取撥出及撥入的倉庫. 
   IF l_rcj03 = '1' THEN 
     #SELECT rtz07 INTO l_rup.rup09 FROM rtz_file WHERE rtz01 = g_ruo04    #FUN-C90049 mark
      CALL s_get_coststore(g_ruo04,'') RETURNING l_rup.rup09   #FUN-C90049 add
      IF cl_null(l_rup.rup09) THEN 
         #撥出營運中心未設定預設成本庫，請先執行 門店基本資料維護作業(arti200)！
         CALL s_errmsg('rtz07',l_rup.rup09,'','alm1465',1) 
         LET g_success = 'N'
         RETURN 
      END IF 
   ELSE 
      IF l_rcj03 = '2' THEN 
        #SELECT rtz08 INTO l_rup.rup09 FROM rtz_file WHERE rtz01 = g_ruo04    #FUN-C90049 mark
         CALL s_get_noncoststore(g_ruo04,'') RETURNING l_rup.rup09    #FUN-C90049 add 
         IF cl_null(l_rup.rup09) THEN 
            #撥出營運中心未設定預設非成本庫，請先執行 門店基本資料維護作業(arti200)！
            CALL s_errmsg('rtz08',l_rup.rup09,'','alm1466',1) 
            LET g_success = 'N'
            RETURN 
         END IF
      END IF 
   END IF 
   IF l_rcj03 = '1' THEN 
     #SELECT rtz07 INTO l_rup.rup13 FROM rtz_file WHERE rtz01 = g_ruo05    #FUN-C90049 mark
     CALL s_get_coststore(g_ruo05,'') RETURNING l_rup.rup13   #FUN-C90049 add
      IF cl_null(l_rup.rup13) THEN 
         #撥入營運中心未設定預設成本庫，請先執行 門店基本資料維護作業(arti200)！
         CALL s_errmsg('rtz07',l_rup.rup13,'','alm1467',1) 
         LET g_success = 'N'
         RETURN 
      END IF 
   ELSE 
      IF l_rcj03 = '2' THEN 
        #SELECT rtz08 INTO l_rup.rup13 FROM rtz_file WHERE rtz01 = g_ruo05   #FUN-C90049 mark
         CALL s_get_noncoststore(g_ruo05,'' ) RETURNING l_rup.rup13          #FUN-C90049 add
         IF cl_null(l_rup.rup13) THEN 
            #撥入營運中心未設定預設非成本庫，請先執行 門店基本資料維護作業(arti200)！
            CALL s_errmsg('rtz08',l_rup.rup13,'','alm1468',1) 
            LET g_success = 'N'
            RETURN 
         END IF
      END IF 
   END IF   
   LET g_sql = " SELECT *  FROM lpz_file ",
               " WHERE lpz01 = '",g_lpy.lpy02,"'", 
               "   AND lpzplant ='", g_lpy.lpyplant ,"'"  
   PREPARE t670_lpz01_pre FROM g_sql
   DECLARE t670_lpz01pre_cs CURSOR FOR t670_lpz01_pre
   LET l_n = 1
   FOREACH t670_lpz01pre_cs INTO  l_lpz[l_n].*
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL s_errmsg('','','t670_lpz01pre_cs',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF 
      #先取得券對應料號
      SELECT lpx32 INTO l_lpx32
        FROM lqe_file
   LEFT JOIN lpx_file 
          ON lqe02 = lpx01
       WHERE lqe01 = l_lpz[l_n].lpz03
       #取得庫存單位及判斷券對應料號不可為母料件
      SELECT ima25, ima151, imaacti 
        INTO l_rup.rup04, l_ima151, l_imaacti
        FROM ima_file
       WHERE ima01 = l_lpx32 
      IF cl_null(l_rup.rup04) THEN 
        #l_lpz.lpz02 + '對應的產品未設定庫存單位！'
         LET g_showmsg = l_lpz[l_n].lpz02,"/",l_lpx32
         CALL s_errmsg('lpz02',g_showmsg,'','alm1469',1) 
         LET g_success = 'N'
         RETURN
      END IF 
      IF l_imaacti = 'N' THEN 
         #l_lpz.lpz03 + '對應的產品已無效，不可進行調撥！
         LET g_showmsg = l_lpz[l_n].lpz02,"/",l_lpx32
         CALL s_errmsg('lpz02',g_showmsg,'','alm1470',1) 
         LET g_success = 'N'
         RETURN
      END IF 
      IF l_ima151 = 'Y' THEN 
         #l_lpz.lpz03 + '對應的產品為母料件，不可進行調撥！'
         LET g_showmsg = l_lpz[l_n].lpz02,"/",l_lpx32
         CALL s_errmsg('lpz02',g_showmsg,'','alm1471',1) 
         LET g_success = 'N'
         RETURN
      END IF    
      #取商品的經營方式
      SELECT rty06 INTO l_rup.rup05 
        FROM rty_file 
       WHERE rty01= g_lpy.lpyplant
         AND rty02 = l_lpx32
      IF cl_null(l_rup.rup05) THEN
         LET l_rup.rup05 = '1'
      END IF 
      #取單位換算率
      CALL s_umfchk(l_lpx32, l_rup.rup04, l_rup.rup04)
         RETURNING l_flag,l_fac  
      IF l_flag = 1 THEN 
         #l_lpx32 + 'aqc-500' 
         CALL s_errmsg('lpx32',l_lpx32,'','aqc-500',1) 
         LET g_success = 'N'
         RETURN
      ELSE
         LET l_rup.rup08 = l_fac
      END IF 
      #判斷券對應的產品編號是否存在於aimi100或arti120中, 邏輯如下 :
      IF NOT s_chk_item_no(l_lpx32, g_ruo04) THEN
         #l_lpz.lpz02 + '對應的產品不存在於料件基本資料(aimi100)中，
         #或撥出營運中心的產品策略(arti120)中，不可進行調撥！' 
         LET g_showmsg = l_lpz[l_n].lpz02,"/",l_lpx32
         CALL s_errmsg('lpz02/lpx32',g_showmsg,'','alm1472',1) 
         LET g_success = 'N'
         RETURN
      END IF
      IF NOT s_chk_item_no(l_lpx32, g_ruo05) THEN
         #l_lpz.lpz02 + '對應的產品不存在於料件基本資料(aimi100)中，
         #或撥入營運中心的產品策略(arti120)中，不可進行調撥！'
         LET g_showmsg = l_lpz[l_n].lpz02,"/",l_lpx32
         CALL s_errmsg('lpz02',g_showmsg,'','alm1473',1) 
         LET g_success = 'N'
         RETURN
      END IF    
         #檢查券對應的產品, 是否存在於撥出及撥入營運中心的價格策略中, 
         #參考 artt256.4gl 中的 t256_check_rup03(...) 處理方法
         #t256_check_rup03(l_lpx32)
      CALL t670_check_rup03(l_lpx32)
      IF NOT cl_null(g_errno) THEN
          LET g_success = 'N'
         RETURN
      END IF
      CALL t670_check_rup03_1(l_lpx32)
      IF NOT cl_null(g_errno) THEN
         LET g_success = 'N'
         RETURN
      END IF
      LET l_rup.rup01 = g_ruo01
      LET l_rup.rup02 = l_lpz[l_n].lpz05
      LET l_rup.rup03 = l_lpx32
      LET l_rup.rup07 = l_rup.rup04
      LET l_rup.rup08 = l_rup.rup08
      LET l_rup.rup10 = ' '
      #FUN-C90049 add begin---
      IF l_rcj03 = '1' THEN
         LET l_rup.rup09 = s_get_coststore(g_ruo04,l_lpx32)
         #LET l_rup.rup13 = s_get_coststore(g_ruo04,l_lpx32)         #FUN-CC0158 mark
         LET l_rup.rup13 = s_get_coststore(g_ruo05,l_lpx32)          #FUN-CC0158 add
      ELSE
         IF l_rcj03 = '2' THEN
            #LET l_rup.rup09 = s_get_noncoststore(g_ruo05,l_lpx32)   #FUN-CC0158 mark
            LET l_rup.rup09 = s_get_noncoststore(g_ruo04,l_lpx32)    #FUN-CC0158 add
            LET l_rup.rup13 = s_get_noncoststore(g_ruo05,l_lpx32)
         END IF
      END IF
      #FUN-C90049 add end-----
      LET l_rup.rup11 = ' '
      LET l_rup.rup12 = l_lpz[l_n].lpz08
      LET l_rup.rup14 = ' '
      LET l_rup.rup15 = ' '
      LET l_rup.rup16 = l_lpz[l_n].lpz08
      LET l_rup.rup17 = l_lpz[l_n].lpz05
      LET l_rup.rup18 = 'N'
      LET l_rup.rup19 = l_lpz[l_n].lpz08
      LET l_rup.rup22 = l_ruo.ruo05            #FUN-CC0057 add
      SELECT azw02 INTO l_rup.ruplegal
        FROM azw_file WHERE azw01 = g_ruoplant
      LET l_rup.rupplant = g_ruoplant
      #INSERT INTO rup_file VALUES l_rup.*
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_ruo04,'rup_file'),"(",
               "         rup01,rup02,rup03,rup04,rup05,rup06,rup07,rup08,rup09, ",
               "         rup10,rup11,rup12,rup13,rup14,rup15,rup16,rup17,",
               "         rup18,rup19,rup22,ruplegal,rupplant )",    #FUN-CC0057 add rup22
               "  VALUES(?,?,?,?,?,?,?,?,?,",
               "         ?,?,?,?,?,?,?,?,",
               "         ?,?,?,?,?  )"                              #FUN-CC0057 add 1?
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql    
      CALL cl_parse_qry_sql(g_sql,g_ruo04) RETURNING g_sql 
      PREPARE rup_ins FROM g_sql
      EXECUTE rup_ins USING l_rup.rup01,l_rup.rup02,l_rup.rup03,l_rup.rup04,
                         l_rup.rup05,l_rup.rup06,l_rup.rup07,l_rup.rup08,l_rup.rup09,
                         l_rup.rup10,l_rup.rup11,l_rup.rup12,l_rup.rup13,
                         l_rup.rup14,l_rup.rup15,l_rup.rup16,l_rup.rup17,
                         l_rup.rup18,l_rup.rup19,l_rup.rup22,l_rup.ruplegal,l_rup.rupplant       #FUN-CC0057 add rup22
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('','','ins rup',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF 
      LET l_cnt = 0  
      LET g_sql = " SELECT COUNT(*)  FROM ",cl_get_target_table(l_rup.rupplant, 'img_file'),								
                  "  WHERE img01 = '",l_lpx32,"' AND ",								
                  "        img02 = '",l_rup.rup09,"' AND ",								
                  "        img03 = '",l_rup.rup10,"' AND ",								
                  "        img04 = '",l_rup.rup11,"'"
      PREPARE t670_img_pre FROM g_sql
      DECLARE t670_imgpre_cs CURSOR FOR t670_img_pre
      FOREACH t670_imgpre_cs INTO l_cnt  
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL s_errmsg('','','t670_imgpre_cs',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF    
         IF l_cnt = 0 THEN 
            CALL s_madd_img0000(l_rup.rup03, l_rup.rup09, l_rup.rup10, 
            l_rup.rup11, g_ruo01, l_rup.rup02, g_today, g_ruoplant)
         END IF 
      END FOREACH               
          
   END FOREACH          
END FUNCTION 

FUNCTION t670_insert_ina() 
DEFINE l_ina   RECORD LIKE ina_file.*
#DEFINE l_smyslip  LIKE smy_file.smyslip   #FUN-C60079 mark
DEFINE l_rye03    LIKE rye_file.rye03
  
  #FUN-C60079 add START
   #FUN-C90050 mark begin---
   #LET g_sql = "SELECT rye03 FROM ",cl_get_target_table(g_ruo04,'rye_file'),
   #               " WHERE rye01 = 'aim' AND rye02 = '3' AND ryeacti = 'Y' " 
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   #CALL cl_parse_qry_sql(g_sql,g_ruo04) RETURNING g_sql
   #PREPARE pre_sel_rye2 FROM g_sql
   #EXECUTE pre_sel_rye2 INTO l_rye03
   #FUN-C90050 mark end-----
   CALL s_get_defslip('aim','3',g_ruo04,'N') RETURNING l_rye03   #UFN-C90050 add

   IF cl_null(l_rye03) THEN
      #庫存異動單的預設單號未設定，
      #請先執行 預設單別維護作業(aooi410)！
      CALL s_errmsg('rye03',l_rye03,'','alm-h62',1)
      LET g_success = 'N'
      RETURN
   END IF
  #FUN-C60079 add END
   INITIALIZE l_ina.* TO NULL
   LET l_ina.ina00 = '5'
   LET l_ina.ina02 = g_lpy.lpy15
   LET g_ina02 = l_ina.ina02
   LET l_ina.ina03 = g_lpy.lpy17
   LET l_ina.ina04 = g_grup
   LET l_ina.ina08 = '0'
   LET l_ina.ina10 = g_lpy.lpy02
   LET l_ina.inapost = 'N'
   LET l_ina.inauser = g_user
   LET l_ina.inagrup = g_grup
   LET l_ina.inadate = ''
   LET l_ina.inamksg = 'N'
   LET l_ina.ina11 = g_user
   LET l_ina.inaconf = 'N'
   LET l_ina.inaspc = '0'
   LET l_ina.ina12 = 'N'
   LET l_ina.inacont = ''
   LET l_ina.inaconu = ''
   LET l_ina.inapos = '1'
   LET l_ina.inaplant = g_lpy.lpyplant
   LET l_ina.inalegal = g_lpy.lpylegal
   LET l_ina.inaoriu = g_user
   LET l_ina.inaorig = g_grup
   LET l_ina.inadate = ''
  #FUN-C60079 mark START
  #SELECT smyslip INTO l_smyslip FROM smy_file 
  # WHERE smysys = 'aim' AND smykind = '3' AND smyacti = 'Y'
  #CALL s_check_no("aim",l_smyslip,"","3","ina_file","ina01","")
  #   RETURNING li_result,g_ina01
  #  
  #CALL s_auto_assign_no("aim",g_ina01,l_ina.ina03,"3","ina_file","ina01","","","")
  #  RETURNING li_result,g_ina01
  #FUN-C60079 MARK END
  #FUN-C60079 add START
   CALL s_check_no("aim",l_rye03,"","3","ina_file","ina01","")
      RETURNING li_result,g_ina01
   
   CALL s_auto_assign_no("aim",g_ina01,l_ina.ina03,"3","ina_file","ina01","","","")
     RETURNING li_result,g_ina01
  #FUN-C60079 add END
   IF (NOT li_result) THEN
      RETURN FALSE
   END IF 
   LET l_ina.ina01 = g_ina01
   INSERT INTO ina_file VALUES l_ina.*
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('','','ins ina',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF 
END FUNCTION 

FUNCTION  t670_insert_inb() 
DEFINE l_lpz      DYNAMIC ARRAY OF RECORD LIKE lpz_file.*
DEFINE l_rcj02    LIKE rcj_file.rcj02
DEFINE l_rcj03    LIKE rcj_file.rcj03
DEFINE l_n        LIKE type_file.num5 
DEFINE l_inb      RECORD LIKE inb_file.*
DEFINE l_ima151   LIKE ima_file.ima151
DEFINE l_imaacti  LIKE ima_file.imaacti
DEFINE l_flag     LIKE type_file.num5  
DEFINE l_fac      LIKE rup_file.rup08
DEFINE l_cnt      LIKE type_file.num5 
DEFINE l_lpx32    LIKE lpx_file.lpx32
DEFINE l_ina04    LIKE ina_file.ina04          #FUN-CB0087 xj
DEFINE l_ina10    LIKE ina_file.ina10          #FUN-CB0087 xj
DEFINE l_ina11    LIKE ina_file.ina11          #FUN-CB0087 xj
   INITIALIZE l_inb.* TO NULL
   SELECT rcj02,rcj03 INTO l_rcj02,l_rcj03 FROM rcj_file   
   IF cl_null(l_rcj02) THEN 
      #券庫存雜項報廢理由碼未設定，請先執行 系統參數設定作業-流通零售參數(arts100)！
      LET g_errno = ''
      CALL s_errmsg('rcj03',l_rcj03,'',g_errno,1) 
      LET g_success = 'N'
      RETURN 
   END IF
   IF cl_null(l_rcj03) THEN 
      #券庫存管理倉庫未設定，請先執行 系統參數設定作業-流通零售參數(arts100)！
      CALL s_errmsg('rcj03',l_rcj03,'','alm1464',1) 
      LET g_success = 'N'
      RETURN 
   END IF  
   IF l_rcj03 = '1' THEN 
     #SELECT rtz07 INTO l_inb.inb05 FROM rtz_file WHERE rtz01 = g_lpy.lpyplant    #FUN-C90049 mark 
      CALL s_get_coststore(g_lpy.lpyplant,'') RETURNING l_inb.inb05               #FUN-C90049 dd
      IF cl_null(l_inb.inb05) THEN 
         #營運中心未設定預設成本庫，請先執行 門店基本資料維護作業(arti200)！
         CALL s_errmsg('rtz07',l_inb.inb05,'','',1) 
         LET g_success = 'N'
         RETURN 
      END IF 
   ELSE 
      IF l_rcj03 = '2' THEN 
        #SELECT rtz08 INTO l_inb.inb05 FROM rtz_file WHERE rtz01 = g_lpy.lpyplant    #FUN-C90049 mark
         CALL s_get_noncoststore(g_lpy.lpyplant,'') RETURNING  l_inb.inb05           #FUN-C90049 add
         IF cl_null(l_inb.inb05) THEN 
            #營運中心未設定預設非成本庫，請先執行 門店基本資料維護作業(arti200)！
            CALL s_errmsg('rtz08',l_inb.inb05,'','alm1466',1) 
            LET g_success = 'N'
            RETURN 
         END IF
      END IF 
   END IF 
   LET g_sql = " SELECT *  FROM lpz_file ",
               " WHERE lpz01 = '",g_lpy.lpy02,"'", 
               "   AND lpzplant ='", g_lpy.lpyplant ,"'"  
   PREPARE t670_inb_pre FROM g_sql
   DECLARE t670_inbpre_cs CURSOR FOR t670_inb_pre
   LET l_n = 1
   FOREACH t670_inbpre_cs INTO  l_lpz[l_n].*
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL s_errmsg('','','t670_inbpre_cs',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF 
      #先取得券對應料號
      SELECT lpx32 INTO l_lpx32
        FROM lqe_file
   LEFT JOIN lpx_file 
          ON lqe02 = lpx01
       WHERE lqe01 = l_lpz[l_n].lpz03
       #取得庫存單位及判斷券對應料號不可為母料件
      SELECT ima25, ima151, imaacti 
        INTO l_inb.inb08, l_ima151, l_imaacti
        FROM ima_file
       WHERE ima01 = l_lpx32 
      IF cl_null(l_inb.inb08) THEN 
        #l_lpz.lpz03 + '對應的產品未設定庫存單位！'
         CALL s_errmsg('lpz02',l_lpz[l_n].lpz02,'','alm1469',1) 
         LET g_success = 'N'
         RETURN
      END IF 
      IF l_imaacti = 'N' THEN 
         #l_lpz.lpz03 + '對應的產品已無效，不可進行調撥！
         CALL s_errmsg('lpz02',l_lpz[l_n].lpz02,'','alm1470',1) 
         LET g_success = 'N'
         RETURN
      END IF 
      IF l_ima151 = 'Y' THEN 
         #l_lpz.lpz03 + '對應的產品為母料件，不可進行調撥！'
         CALL s_errmsg('lpz02',l_lpz[l_n].lpz02,'','alm1471',1) 
         LET g_success = 'N'
         RETURN
      END IF    

      #取單位換算率
      CALL s_umfchk(l_lpx32, l_inb.inb08, l_inb.inb08)
         RETURNING l_flag,l_fac  
      IF l_flag = 1 THEN 
         #l_lpx32 + 'aqc-500' 
         CALL s_errmsg('lpx32',l_lpx32,'','aqc-500',1) 
         LET g_success = 'N'
         RETURN
      ELSE
         LET l_inb.inb08_fac = l_fac
      END IF 

      LET l_inb.inb01 = g_ina01
      LET l_inb.inb03 = l_lpz[l_n].lpz05
      LET l_inb.inb04 = l_lpx32
     #LET l_inb.inb05 = l_inb.inb05    #FUN-C90049 mark
     #FUN-C90049 add begin---         
      IF l_rcj03 = '1' THEN
         LET l_inb.inb05 = s_get_coststore(g_lpy.lpyplant,l_lpx32)
      ELSE
         IF l_rcj03 = '2' THEN
            LET l_inb.inb05 = s_get_noncoststore(g_lpy.lpyplant,l_lpx32)
         END IF
      END IF
     #FUN-C90049 add end-----
      LET l_inb.inb06 = ' '
      LET l_inb.inb07 = ' '
      LET l_inb.inb09 = l_lpz[l_n].lpz08
      LET l_inb.inb10 = 'N'
      LET l_inb.inb11 = ' '
      LET l_inb.inb12 = ' '
      LET l_inb.inb15 = l_rcj02
      LET l_inb.inb930 = s_costcenter(g_grup)
      LET l_inb.inb16 = l_lpz[l_n].lpz08
      LET l_inb.inbplant = g_lpy.lpyplant
      LET l_inb.inblegal = g_lpy.lpylegal
     
      #FUN-CB0087-xj---add---str
      IF g_aza.aza115 = 'Y' THEN
        SELECT ina04,ina10,ina11 INTO l_ina04,l_ina10,l_ina11 FROM ina_file WHERE ina01 = l_inb.inb01
        CALL s_reason_code(l_inb.inb01,l_ina10,'',l_inb.inb04,l_inb.inb05,l_ina04,l_ina11) RETURNING l_inb.inb15
        IF cl_null(l_inb.inb15) THEN
           CALL cl_err('','aim-425',1)
           LET g_success = 'N'
           RETURN 
        END IF
      END IF
      #FUN-CB0087-xj---add---end
 
      INSERT INTO inb_file VALUES l_inb.*
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('','','ins inb',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF 
      
      LET l_cnt = 0  
      LET g_sql = " SELECT COUNT(*)  FROM ",cl_get_target_table(l_inb.inbplant, 'img_file'),								
                  "  WHERE img01 = '",l_lpx32,"' AND ",								
                  "        img02 = '",l_inb.inb05,"' AND ",								
                  "        img03 = '",l_inb.inb06,"' AND ",								
                  "        img04 = '",l_inb.inb07,"'"
      PREPARE t670_img_pre1 FROM g_sql
      DECLARE t670_imgpre1_cs CURSOR FOR t670_img_pre1
      FOREACH t670_imgpre1_cs INTO l_cnt  
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL s_errmsg('','','t670_imgpre1_cs',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF    
         IF l_cnt = 0 THEN 
            CALL s_madd_img0000(l_inb.inb04, l_inb.inb05, l_inb.inb06, 
            l_inb.inb07, l_inb.inb01, l_inb.inb03 , g_today, l_inb.inbplant)
         END IF 
      END FOREACH  
   END FOREACH      
END FUNCTION 

FUNCTION t670_chk_ina02()
   IF NOT cl_null(g_lpy.lpy15) THEN
	  IF NOT cl_null(g_sma.sma53) AND g_lpy.lpy15 <= g_sma.sma53 THEN
	  #     CALL cl_err('','mfg9999',0)
         CALL s_errmsg('lpy15',g_lpy.lpy15,'','mfg9999',1) 
	     RETURN FALSE
	  END IF
      CALL s_yp(g_lpy.lpy15) RETURNING g_yy,g_mm
      IF g_yy*12+g_mm > g_sma.sma51*12+g_sma.sma52 THEN #不可大於現行年月
         #CALL cl_err('','mfg6091',0)
         CALL s_errmsg('lpy15',g_lpy.lpy15,'','mfg6091',1) 
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION


   
FUNCTION t670_coupon_state()
DEFINE l_msg  STRING 
   IF NOT cl_null(l_ac) AND l_ac > 0 THEN 
     #FUN-C70074 mark START
     #IF NOT cl_null(g_lpz[l_ac].lpz03) AND NOT cl_null(g_lpz[l_ac].lpz04) THEN 
     #   LET l_msg = "almq677 '",g_lpz[l_ac].lpz03,"' '",g_lpz[l_ac].lpz04,"'"
     #   CALL cl_cmdrun_wait(l_msg) 
     #ELSE 
     #   CALL cl_err('lpz03,lpz04','alm1539',0)   
     #END IF  
     #FUN-C70074 mark END
     #FUN-C70074 add START
     #增加ARG_VAL參數,判斷是否是由外部程式傳查進入almq677
      LET l_msg = "almq677 '",g_lpz[l_ac].lpz03,"' '",g_lpz[l_ac].lpz04,"' 'Y' "  
      CALL cl_cmdrun_wait(l_msg)                                                                      
     #FUN-C70074 add END
   ELSE 
      CALL cl_err('','-400',0)   
   END IF    
END FUNCTION 
FUNCTION t670_dial_out()
DEFINE l_msg  STRING 
   IF NOT cl_null(g_lpy.lpy18) THEN 
      LET l_msg = "artt256 '",g_lpy.lpy18,"'"
      CALL cl_cmdrun_wait(l_msg) 
   ELSE 
      CALL cl_err('lpy18','alm1538',0)   
   END IF 
END FUNCTION
FUNCTION t670_scrap_note()
DEFINE l_msg  STRING 
   IF NOT cl_null(g_lpy.lpy18) THEN 
      LET l_msg = "aimt303 '",g_lpy.lpy18,"'"
      CALL cl_cmdrun_wait(l_msg) 
   ELSE 
      CALL cl_err('lpy18','alm1538',0)   
   END IF 
END FUNCTION
FUNCTION t670_field_disp()
   IF g_argv1 = '1' OR g_argv1 = '2' THEN
      CALL cl_getmsg('alm1515',g_lang) RETURNING g_msg  
      CALL cl_set_comp_att_text("lpy18",g_msg CLIPPED) 
   END IF  
   IF g_argv1 = 3 OR g_argv1 = '4' OR g_argv1 = '5' THEN
      CALL cl_getmsg('alm1514',g_lang) RETURNING g_msg 
      CALL cl_set_comp_att_text("lpy18",g_msg CLIPPED) 
   END IF  
   IF g_argv1 = '4' THEN        
      CALL cl_getmsg('alm1450',g_lang) RETURNING g_msg 
      CALL cl_set_comp_att_text("lpy19",g_msg CLIPPED)
   END IF 
   IF g_argv1 = '5' THEN        
      CALL cl_getmsg('alm1451',g_lang) RETURNING g_msg 
      CALL cl_set_comp_att_text("lpy19",g_msg CLIPPED)
   END IF  
END FUNCTION   
FUNCTION t670_act_disp()
   #FUN-BC0048 start
   IF g_lpy01 MATCHES '[12]' THEN 
      CALL cl_set_act_visible("coupon_state,dial_out,dial_in,scrap_note",FALSE) 
   END IF
   
   IF g_lpy01 MATCHES '[0]' THEN 
      CALL cl_set_act_visible("coupon_state,dial_out,dial_in,scrap_note",FALSE)
   END IF    
   IF g_lpy01 MATCHES '[5]' THEN 
      CALL cl_set_act_visible("scrap_note,dial_in", FALSE)
      CALL cl_set_act_visible("coupon_state,dial_out",TRUE)
   END IF
   #FUN-BC0048 end 
   #FUN-BC0061 start
   IF g_lpy01 MATCHES '[6]' THEN 
      CALL cl_set_act_visible("scrap_note,dial_out", FALSE)
      CALL cl_set_act_visible("coupon_state,dial_in",TRUE)
   END IF
         
   IF g_lpy01 MATCHES '[3]' THEN 
      CALL cl_set_act_visible("dial_out,dial_in", FALSE)
      CALL cl_set_act_visible("coupon_state,scrap_note",TRUE)
   END IF
   #FUN-BC0061 end
END FUNCTION    
#FUN-BC0048 end ---

#No.FUN-960134
#FUN-A30116 PASS 


#FUN-C90070-------add------str
FUNCTION t670_out()
DEFINE l_sql     LIKE type_file.chr1000, 
       l_rtz13   LIKE rtz_file.rtz13,
       l_lpx02   LIKE lpx_file.lpx02,
       l_lrz02   LIKE lrz_file.lrz02,        
       sr        RECORD
                 lpy01     LIKE lpy_file.lpy01, 
                 lpy02     LIKE lpy_file.lpy02,
                 lpy17     LIKE lpy_file.lpy17,
                 lpyplant  LIKE lpy_file.lpyplant,
                 lpy13     LIKE lpy_file.lpy13,
                 lpy14     LIKE lpy_file.lpy14,
                 lpy15     LIKE lpy_file.lpy15,
                 lpy16     LIKE lpy_file.lpy16,
                 lpz02     LIKE lpz_file.lpz02,
                 lpz07     LIKE lpz_file.lpz07,
                 lpz03     LIKE lpz_file.lpz03,
                 lpz04     LIKE lpz_file.lpz04,
                 lpz08     LIKE lpz_file.lpz08,
                 lpz09     LIKE lpz_file.lpz09,
                 lpz13     LIKE lpz_file.lpz13,
                 lpz14     LIKE lpz_file.lpz14
                 END RECORD
 
     CALL cl_del_data(l_table) 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lpyuser', 'lpygrup') 
     IF cl_null(g_wc) THEN LET g_wc = " lpy02 = '",g_lpy.lpy02,"'" END IF
     IF cl_null(g_wc2) THEN LET g_wc2 = " lpz01 = '",g_lpy.lpy02,"'" END IF
     LET l_sql = "SELECT lpy01,lpy02,lpy17,lpyplant,lpy13,lpy14,lpy15,lpy16,",
                 "       lpz02,lpz07,lpz03,lpz04,lpz08,lpz09,lpz13,lpz14",
                 "  FROM lpy_file,lpz_file",
                 " WHERE lpy02 = lpz01",
                 "   AND lpy01 = '0'",
                 "   AND lpz06 = '0'",
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED
     PREPARE t670_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table)   
        EXIT PROGRAM
     END IF
     DECLARE t670_cs1 CURSOR FOR t670_prepare1

     DISPLAY l_table
     FOREACH t670_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

       LET l_rtz13 = ' '
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = sr.lpyplant
       LET l_lpx02 = ' '
       SELECT lpx02 INTO l_lpx02 FROM lpx_file WHERE lpx01 = sr.lpz02
       LET l_lrz02 = ' '
       SELECT lrz02 INTO l_lrz02 FROM lrz_file WHERE lrz01 = sr.lpz07
       EXECUTE insert_prep USING sr.*,l_rtz13,l_lpx02,l_lrz02
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(g_wc,'lpy01,lpy02,lpy17,lpyplant,lpy13,lpy14,lpy15,lpy16')
          RETURNING g_wc1
     CALL cl_wcchp(g_wc2,'lpz01,lpz02,lpz07,lpz03,lpz04,lpz08,lpz09,lpz13,lpz14')
          RETURNING g_wc3
     IF g_wc = " 1=1" THEN
        LET g_wc1='' 
     END IF
     IF g_wc2 = " 1=1" THEN
        LET g_wc3='' 
     END IF            
     IF g_wc <> " 1=1" AND g_wc2 <> " 1=1" THEN 
        LET g_wc4 = g_wc1," AND ",g_wc3
     ELSE              
        IF g_wc = " 1=1" AND g_wc2 = " 1=1" THEN
           LET g_wc4 = "1=1"
        ELSE 
           LET g_wc4 = g_wc1,g_wc3
        END IF 
     END IF
     CALL t670_grdata()
END FUNCTION

FUNCTION t670_grdata()
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE sr1      sr1_t
   DEFINE l_cnt    LIKE type_file.num10

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN 
      RETURN 
   END IF

   
   WHILE TRUE
       CALL cl_gre_init_pageheader()            
       LET handler = cl_gre_outnam("almt670")
       IF handler IS NOT NULL THEN
           START REPORT t670_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY lpy02,lpz02"
           DECLARE t670_datacur1 CURSOR FROM l_sql
           FOREACH t670_datacur1 INTO sr1.*
               OUTPUT TO REPORT t670_rep(sr1.*)
           END FOREACH
           FINISH REPORT t670_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT t670_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_lpy01  STRING
    DEFINE l_lpy13  STRING
    
    ORDER EXTERNAL BY sr1.lpy02,sr1.lpz02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
            PRINTX g_wc1,g_wc3,g_wc4
              
        BEFORE GROUP OF sr1.lpy02
            LET l_lineno = 0
        BEFORE GROUP OF sr1.lpz02
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_lpy01 = cl_gr_getmsg("gre-300",g_lang,sr1.lpy01)
            LET l_lpy13 = cl_gr_getmsg("gre-302",g_lang,sr1.lpy13)
            PRINTX sr1.*
            PRINTX l_lpy01
            PRINTX l_lpy13

        AFTER GROUP OF sr1.lpy02
        AFTER GROUP OF sr1.lpz02

        
        ON LAST ROW

END REPORT


FUNCTION t671_out()
DEFINE l_sql     LIKE type_file.chr1000, 
       l_rtz13   LIKE rtz_file.rtz13,
       l_rtz13_1 LIKE rtz_file.rtz13,
       l_lpx02   LIKE lpx_file.lpx02,
       l_lrz02   LIKE lrz_file.lrz02,        
       sr        RECORD
                lpy01     LIKE lpy_file.lpy01, 
                lpy02     LIKE lpy_file.lpy02,
                lpy17     LIKE lpy_file.lpy17,
                lpy19     LIKE lpy_file.lpy19,
                lpy18     LIKE lpy_file.lpy18,
                lpyplant  LIKE lpy_file.lpyplant,
                lpy13     LIKE lpy_file.lpy13,
                lpy14     LIKE lpy_file.lpy14,
                lpy15     LIKE lpy_file.lpy15,
                lpy16     LIKE lpy_file.lpy16,
                lpz05     LIKE lpz_file.lpz05,
                lpz02     LIKE lpz_file.lpz02,
                lpz07     LIKE lpz_file.lpz07,
                lpz03     LIKE lpz_file.lpz03,
                lpz04     LIKE lpz_file.lpz04,
                lpz08     LIKE lpz_file.lpz08
                 END RECORD
 
     CALL cl_del_data(l_table) 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lpyuser', 'lpygrup') 
     IF cl_null(g_wc) THEN LET g_wc = " lpy02 = '",g_lpy.lpy02,"'" END IF
     IF cl_null(g_wc2) THEN LET g_wc2 = " lpz01 = '",g_lpy.lpy02,"'" END IF
     IF g_argv1 = '4' THEN
        LET l_sql = "SELECT lpy01,lpy02,lpy17,lpy19,lpy18,lpyplant,lpy13,lpy14,lpy15,lpy16,",
                    "       lpz05,lpz02,lpz07,lpz03,lpz04,lpz08 ",
                    "  FROM lpy_file,lpz_file",
                    " WHERE lpy02 = lpz01",
                    "   AND lpy01 = '5'",
                    "   AND lpz06 = '5'",
                    "   AND ",g_wc CLIPPED,
                    "   AND ",g_wc2 CLIPPED
     END IF
     IF g_argv1 = '5' THEN
        LET l_sql = "SELECT lpy01,lpy02,lpy17,lpy19,lpy18,lpyplant,lpy13,lpy14,lpy15,lpy16,",
                    "       lpz05,lpz02,lpz07,lpz03,lpz04,lpz08 ",
                    "  FROM lpy_file,lpz_file",
                    " WHERE lpy02 = lpz01",
                    "   AND lpy01 = '6'",
                    "   AND lpz06 = '6'",
                    "   AND ",g_wc CLIPPED,
                    "   AND ",g_wc2 CLIPPED
     END IF
     PREPARE t671_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table)   
        EXIT PROGRAM
     END IF
     DECLARE t671_cs1 CURSOR FOR t671_prepare1

     DISPLAY l_table
     FOREACH t671_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

       LET l_rtz13 = ' '
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = sr.lpyplant
       LET l_rtz13_1 = ' '
       SELECT rtz13 INTO l_rtz13_1 FROM rtz_file WHERE rtz01 = sr.lpy19
       LET l_lpx02 = ' '
       SELECT lpx02 INTO l_lpx02 FROM lpx_file WHERE lpx01 = sr.lpz02
       LET l_lrz02 = ' '
       SELECT lrz02 INTO l_lrz02 FROM lrz_file WHERE lrz01 = sr.lpz07
       EXECUTE insert_prep1 USING sr.*,l_rtz13,l_rtz13_1,l_lpx02,l_lrz02
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(g_wc,'lpy01,lpy02,lpy17,lpy18,lpy19,lpyplant,lpy13,lpy14,lpy15,lpy16')
          RETURNING g_wc1
     CALL cl_wcchp(g_wc2,'lpz01,lpz05,lpz02,lpz07,lpz03,lpz04,lpz08')
          RETURNING g_wc3
     IF g_wc = " 1=1" THEN
        LET g_wc1='' 
     END IF
     IF g_wc2 = " 1=1" THEN
        LET g_wc3='' 
     END IF            
     IF g_wc <> " 1=1" AND g_wc2 <> " 1=1" THEN 
        LET g_wc4 = g_wc1," AND ",g_wc3
     ELSE              
        IF g_wc = " 1=1" AND g_wc2 = " 1=1" THEN
           LET g_wc4 = "1=1"
        ELSE 
           LET g_wc4 = g_wc1,g_wc3
        END IF 
     END IF
     CALL t671_grdata()
END FUNCTION

FUNCTION t671_grdata()
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE sr2      sr2_t
   DEFINE l_cnt    LIKE type_file.num10

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN 
      RETURN 
   END IF

   
   WHILE TRUE
       CALL cl_gre_init_pageheader()
       IF g_argv1 = '4' THEN LET handler = cl_gre_outnam("almt671") END IF
       IF g_argv1 = '5' THEN LET handler = cl_gre_outnam("almt672") END IF
       IF handler IS NOT NULL THEN
           START REPORT t671_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY lpy02,lpz02"
           DECLARE t671_datacur1 CURSOR FROM l_sql
           FOREACH t671_datacur1 INTO sr2.*
               OUTPUT TO REPORT t671_rep(sr2.*)
           END FOREACH
           FINISH REPORT t671_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT t671_rep(sr2)
    DEFINE sr2 sr2_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_lpy01  STRING
    DEFINE l_lpy13  STRING
    
    ORDER EXTERNAL BY sr2.lpy02,sr2.lpz02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
            PRINTX g_wc1,g_wc3,g_wc4
              
        BEFORE GROUP OF sr2.lpy02
            LET l_lineno = 0
        BEFORE GROUP OF sr2.lpz02
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_lpy01 = cl_gr_getmsg("gre-300",g_lang,sr2.lpy01)
            LET l_lpy13 = cl_gr_getmsg("gre-302",g_lang,sr2.lpy13)
            PRINTX sr2.*
            PRINTX l_lpy01
            PRINTX l_lpy13

        AFTER GROUP OF sr2.lpy02
        AFTER GROUP OF sr2.lpz02

        
        ON LAST ROW

END REPORT

FUNCTION t700_out()
DEFINE l_sql     LIKE type_file.chr1000, 
       l_rtz13   LIKE rtz_file.rtz13,
       l_lpx02   LIKE lpx_file.lpx02,
       l_lrz02   LIKE lrz_file.lrz02,        
       sr        RECORD
                 lpy01     LIKE lpy_file.lpy01, 
                 lpy02     LIKE lpy_file.lpy02,
                 lpy17     LIKE lpy_file.lpy17,
                 lpy18     LIKE lpy_file.lpy18,
                 lpyplant  LIKE lpy_file.lpyplant,
                 lpy13     LIKE lpy_file.lpy13,
                 lpy14     LIKE lpy_file.lpy14,
                 lpy15     LIKE lpy_file.lpy15,
                 lpy16     LIKE lpy_file.lpy16,
                 lpz05     LIKE lpz_file.lpz05,
                 lpz02     LIKE lpz_file.lpz02,
                 lpz07     LIKE lpz_file.lpz07,
                 lpz03     LIKE lpz_file.lpz03,
                 lpz04     LIKE lpz_file.lpz04,
                 lpz08     LIKE lpz_file.lpz08,
                 lpz09     LIKE lpz_file.lpz09
                 END RECORD
 
     CALL cl_del_data(l_table) 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lpyuser', 'lpygrup') 
     IF cl_null(g_wc) THEN LET g_wc = " lpy02 = '",g_lpy.lpy02,"'" END IF
     IF cl_null(g_wc2) THEN LET g_wc2 = " lpz01 = '",g_lpy.lpy02,"'" END IF
     LET l_sql = "SELECT lpy01,lpy02,lpy17,lpy18,lpyplant,lpy13,lpy14,lpy15,lpy16,",
                 "       lpz05,lpz02,lpz07,lpz03,lpz04,lpz08,lpz09 ",
                 "  FROM lpy_file,lpz_file",
                 " WHERE lpy02 = lpz01",
                 "   AND lpy01 = '3'",
                 "   AND lpz06 = '3'",
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED
     PREPARE t700_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table)   
        EXIT PROGRAM
     END IF
     DECLARE t700_cs1 CURSOR FOR t700_prepare1

     DISPLAY l_table
     FOREACH t700_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

       LET l_rtz13 = ' '
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = sr.lpyplant
       LET l_lpx02 = ' '
       SELECT lpx02 INTO l_lpx02 FROM lpx_file WHERE lpx01 = sr.lpz02
       LET l_lrz02 = ' '
       SELECT lrz02 INTO l_lrz02 FROM lrz_file WHERE lrz01 = sr.lpz07
       EXECUTE insert_prep2 USING sr.*,l_rtz13,l_lpx02,l_lrz02
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(g_wc,'lpy01,lpy02,lpy17,lpy18,lpyplant,lpy13,lpy14,lpy15,lpy16')
          RETURNING g_wc1
     CALL cl_wcchp(g_wc2,'lpz01,lpz05,lpz02,lpz07,lpz03,lpz04,lpz08,lpz09')
          RETURNING g_wc3
     IF g_wc = " 1=1" THEN
        LET g_wc1='' 
     END IF
     IF g_wc2 = " 1=1" THEN
        LET g_wc3='' 
     END IF            
     IF g_wc <> " 1=1" AND g_wc2 <> " 1=1" THEN 
        LET g_wc4 = g_wc1," AND ",g_wc3
     ELSE              
        IF g_wc = " 1=1" AND g_wc2 = " 1=1" THEN
           LET g_wc4 = "1=1"
        ELSE 
           LET g_wc4 = g_wc1,g_wc3
        END IF 
     END IF  
     CALL t700_grdata()
END FUNCTION

FUNCTION t700_grdata()
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE sr3      sr3_t
   DEFINE l_cnt    LIKE type_file.num10

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN 
      RETURN 
   END IF

   
   WHILE TRUE
       CALL cl_gre_init_pageheader()            
       LET handler = cl_gre_outnam("almt700")
       IF handler IS NOT NULL THEN
           START REPORT t700_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY lpy02,lpz02"
           DECLARE t700_datacur1 CURSOR FROM l_sql
           FOREACH t700_datacur1 INTO sr3.*
               OUTPUT TO REPORT t700_rep(sr3.*)
           END FOREACH
           FINISH REPORT t700_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT t700_rep(sr3)
    DEFINE sr3 sr3_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_lpy01  STRING
    DEFINE l_lpy13  STRING
    
    ORDER EXTERNAL BY sr3.lpy02,sr3.lpz02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
            PRINTX g_wc1,g_wc3,g_wc4
              
        BEFORE GROUP OF sr3.lpy02
            LET l_lineno = 0
        BEFORE GROUP OF sr3.lpz02
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_lpy01 = cl_gr_getmsg("gre-300",g_lang,sr3.lpy01)
            LET l_lpy13 = cl_gr_getmsg("gre-302",g_lang,sr3.lpy13)
            PRINTX sr3.*
            PRINTX l_lpy01
            PRINTX l_lpy13


        AFTER GROUP OF sr3.lpy02
        AFTER GROUP OF sr3.lpz02

        
        ON LAST ROW

END REPORT
#FUN-C90070-------add------end
#CHI-C80041---begin
FUNCTION t670_c()
DEFINE l_chr LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_lpy.lpy02) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t670_cl USING g_lpy.lpy02
   IF STATUS THEN
      CALL cl_err("OPEN t670_cl:", STATUS, 1)
      CLOSE t670_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t670_cl INTO g_lpy.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lpy.lpy02,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t670_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_lpy.lpy13 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_lpy.lpy13)   THEN 
        LET l_chr=g_lpy.lpy13
        IF g_lpy.lpy13='N' THEN 
            LET g_lpy.lpy13='X' 
        ELSE
            LET g_lpy.lpy13='N'
        END IF
        UPDATE lpy_file
            SET lpy13=g_lpy.lpy13,  
                lpymodu=g_user,
                lpydate=g_today
            WHERE lpy02=g_lpy.lpy02
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","lpy_file",g_lpy.lpy02,"",SQLCA.sqlcode,"","",1)  
            LET g_lpy.lpy13=l_chr 
        END IF
        DISPLAY BY NAME g_lpy.lpy13
   END IF
 
   CLOSE t670_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lpy.lpy02,'V')
 
END FUNCTION
#CHI-C80041---end
