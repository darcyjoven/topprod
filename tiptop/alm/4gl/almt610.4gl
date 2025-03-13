# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: almt610.4gl
# Descriptions...: 發卡作業
# Date & Author..: NO.FUN-960058 09/06/12 By destiny  
# Modify.........: No:FUN-960141 09/07/17 By dongbg 添加審核段邏輯
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-960134 09/10/16 By shiwuying 改为 發卡作業
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No.FUN-9C0084 09/12/16 By lutingting 重新過單到正式區,程序并沒有修改
# Modify.........: No:FUN-A10060 10/01/14 By shiwuying 權限處理
# Modify.........: No:TQC-A30075 10/03/15 By shiwuying 在SQL后加上SQLCA.sqlcode判斷
# Modify.........: No:MOD-A30214 10/03/26 By Smapmin 單身預設上筆的功能不做卡號自動累加1的動作.
# Modify.........: No:FUN-A70064 10/07/12 By shaoyong 發卡原因抓取代碼類別='2.理由碼'且理由碼用途類別='G.卡異動原因'
# Modify.........: No.TQC-A70103 10/07/23 By chenmoyan MSV版本卡號的編號
#                                                      INSERT INTO 零時表不規範
# Modify.........: No:FUN-A70118 10/07/28 By shiwuying 增加lsn08交易門店字段
# Modify.........: No:FUN-A80008 10/08/02 By shiwuying SQL中的to_char改成BDL語法
# Modify.........: No:FUN-A70130 10/08/09 By wangxin 修正取號時及check編號所傳入的模組代碼及單據性質代碼
# Modify.........: No.FUN-A70130 10/08/10 By huangtao 取消lrk_file所有相關資料
# Modify.........: No:FUN-A80148 10/09/02 By lixh1 因為 lma_file 表已不再使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: No:FUN-A90040 10/10/12 By shenyang  取消 defray(支付明細) Action
# Modify.........: No:FUN-AA0072 10/10/25 By huangtao 修改清空lps08，而azf03不清空的bug
# Modify.........: No:TQC-B20065 11/02/16 By elva 增加传参
# Modify.........: No:MOD-B50027 11/05/05 By lilingyu 審核端,事務裡有CREATE語句,導致審核失敗時,rollback錯誤 
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60231 11/06/21 By baogc 交款時，現金欄位給默認值為交款應收餘額
# Modify.........: No.FUN-B80060 11/08/05 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No.FUN-BC0112 12/01/05 By zhuhao 增加欄位加值金額及一些邏輯
# Modify.........: No.FUN-B90118 12/01/30 By pauline 新增會員資料ACTION
# Modify.........: No.FUN-BA0068 12/01/30 By pauline mark lsn08 增加lsnlegal,lsnplant
# Modify.........: No.FUN-C10001 12/01/30 By pauline mark 有關 CALL t610_lpn02() 及 FUNCTION t610_lpn02()
# Modify.........: No.FUN-C10005 12/01/30 By pauline 發卡時可選擇自動產生會員資料, 或選取現有的會員資料 
# Modify.........: No.FUN-C10051 12/02/02 By nanbing 確認時產生出貨單
# Modify.........: No.TQC-C30009 12/03/01 By nanbing 確認產生出貨單，售卡金額為0時邏輯處理
# Modify.........: No.TQC-C20565 12/03/01 By zhangweib 出貨應收比率本賦值為0,導致產生應收帳款科目錯誤,現將oga162出貨應收比率的賦值修改為100
# Modify.........: No.TQC-C30060 12/03/02 By johnson 總卡內金額計算錯誤修正
# Modify.........: No.TQC-C30112 12/03/07 By pauline 取加值設定資料時應判斷生失效日期
# Modify.........: No:CHI-C30021 12/03/10 By nanbing 新增會員資料功能更改
# Modify.........: No:FUN-C30046 12/03/12 By nanbing lpt11不可編輯
# Modify.........: No:FUN-C30048 12/03/13 By nanbing lpt14有預設值時不可錄入
# Modify.........: No:FUN-C30049 12/03/13 By nanbing 將lpt16隱藏，并MARK相關邏輯
# Modify.........: No.TQC-C30223 12/03/15 By pauline 不論客戶稅率為含稅/未稅,儲值金額皆已含稅價計算
# Modify.........: No:FUN-C30042 12/03/21 By pauline lph09調整 0.無效期限制  1.指定日期  2.指定長度
# Modify.........: No:CHI-C30118 12/04/06 By Sakura 參考來源單號CHI-C30106,批序號維護修改,新增t600sub_y_chk參數
# Modify.........: No:FUN-C40109 12/05/08 By baogc lrq_file添加lrqacti='Y'過濾條件
# Modify.........: No:FUN-C50040 12/05/11 By pauline lps03 單據日期開放可輸入
# Modify.........: No.FUN-C50058 12/05/15 By pauline 增加每次儲值最高金額以及總儲值金額判斷
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52
# Modify.........: No:MOD-C70005 12/07/04 By Elise FUNCTION t610_reconfirm()加入刪除ogi_file動作
# Modify.........: No:FUN-C60057 12/07/05 By Lori 卡管理-卡積分、折扣、儲值加值規則功能優化
# Modify.........: No:FUN-C70045 12/07/11 By yangxf 单据类型调整
# Modify.........: No:TQC-C90016 12/09/05 By yangxf 發卡作業產生出貨單的資料時,oga1014賦值='N'
# Modify.........: No:FUN-C90007 12/09/07 By nanbing 加入取消確認action
# Modify.........: No:TQC-C90075 12/09/19 By dongsz FOREACH抓取rxy的資料，可新增多筆付款明細資料
# Modify.........: No:FUN-C90085 12/09/19 By xumm 付款方式改为CALL s_pay()
# Modify.........: No:CHI-C90026 12/09/21 By pauline 寫入到卡明細檔時,金額抓取錯誤 
# Modify.........: No.FUN-C90070 12/09/26 By xumm 添加GR打印功能
# Modify.........: No.TQC-C90124 12/09/29 By baogc 新增出貨單單頭單身先清空臨時變量
# Modify.........: No.MOD-CA0064 12/10/18 By Vampire almi660沒有固定代號時,lpx23的長度會是null,直接用固定代號位數lpx22判斷即可,lph34的長度也直接抓lph33即可
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No:FUN-C90102 12/10/29 By pauline 將lsn_file檔案類別改為B.基本資料,將lsnplant用lsnstore取代
# Modify.........: No:FUN-CA0103 12/10/31 By xumm 添加设置密码,重置密码按钮
# Modify.........: No:FUN-CA0160 12/11/08 By baogc 添加POS單號
# Modify.........: No:FUN-CB0011 12/12/14 By Lori 確認前需確認aooi150是否有銷項0%稅別設定才可以確認
# Modify.........: No.FUN-CB0087 12/12/20 By xianghui 庫存理由碼改善
# Modify.........: No.FUN-D10021 13/01/10 By dongsz 1.檢查開始卡號和結束卡號之間每張卡的卡種是否相同 2.檢查是否卡號已存在時按照固定编号抓取并关联卡种表
# Modify.........: No:CHI-C80041 13/01/21 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:FUN-D20039 13/01/19 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No.TQC-D20062 13/02/26 By xianghui 理由碼調整
# Modify.........: No.TQC-D20067 13/02/26 By xianghui 信用管控部分被複製到此程式，導致r.l2報錯 
# Modify.........: No:FUN-D30007 13/03/04 By pauline 異動lpj_file時同步異動lpjpos欄位
# Modify.........: No:FUN-D30019 13/03/14 By dongsz 審核時加如果单头卡内金额或者购卡金额大于0才产生销售单的判斷
# Modify.........: No:FUN-D30050 13/03/19 By dongsz 取消審核時添加单头卡内金额或者购卡金额大于0的判斷
# Modify.........: No:CHI-D20015 13/03/28 By lixh1 整批修改update[確認]/[取消確認]動作時,要一併異動確認異動人員與確認異動日期
# Modify.........: No:FUN-C30177 13/04/02 By Sakura 修改:sum(單身的儲值金額) 儲值金額 = 0時才可以進行取消確認動作,否則跳出錯誤訊息return
# Modify.........: No:FUN-D30033 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D70070 13/07/09 By SunLM 对oga53赋值

DATABASE ds  #No.FUN-980082  
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_lps         RECORD LIKE lps_file.*,
       g_lps_t       RECORD LIKE lps_file.*,
       g_lps01_t     LIKE lps_file.lps01,
       g_lpt         DYNAMIC ARRAY OF RECORD
          lpt02      LIKE lpt_file.lpt02,
          lpt021     LIKE lpt_file.lpt021,
          lpj26      LIKE lpj_file.lpj26,    #FUN-CA0103 add
          lpt15      LIKE lpt_file.lpt15,
          lpt03      LIKE lpt_file.lpt03,
          lpt04      LIKE lpt_file.lpt04,
          lpt05      LIKE lpt_file.lpt05,
          lpt06      LIKE lpt_file.lpt06,
          lpt07      LIKE lpt_file.lpt07,
          lpt08      LIKE lpt_file.lpt08,
          lpt09      LIKE lpt_file.lpt09,
          lpt10      LIKE lpt_file.lpt10,
          lpt11      LIKE lpt_file.lpt11,
          lpt12      LIKE lpt_file.lpt12,
          lpt17      LIKE lpt_file.lpt17, #No.FUN-BC0112
          lpt13      LIKE lpt_file.lpt13,
          lpt14      LIKE lpt_file.lpt14,
          lpt16      LIKE lpt_file.lpt16
                     END RECORD,
       g_lpt_t       RECORD
          lpt02      LIKE lpt_file.lpt02,
          lpt021     LIKE lpt_file.lpt021,
          lpj26      LIKE lpj_file.lpj26,    #FUN-CA0103 add
          lpt15      LIKE lpt_file.lpt15,
          lpt03      LIKE lpt_file.lpt03,
          lpt04      LIKE lpt_file.lpt04,
          lpt05      LIKE lpt_file.lpt05,
          lpt06      LIKE lpt_file.lpt06,
          lpt07      LIKE lpt_file.lpt07,
          lpt08      LIKE lpt_file.lpt08,
          lpt09      LIKE lpt_file.lpt09,
          lpt10      LIKE lpt_file.lpt10,
          lpt11      LIKE lpt_file.lpt11,
          lpt12      LIKE lpt_file.lpt12,
          lpt17      LIKE lpt_file.lpt17, #No.FUN-BC0112
          lpt13      LIKE lpt_file.lpt13,
          lpt14      LIKE lpt_file.lpt14,
          lpt16      LIKE lpt_file.lpt16
                     END RECORD,
     g_lpn           DYNAMIC ARRAY OF RECORD
         lpn02       LIKE lpn_file.lpn02,
         lpn03       LIKE lpn_file.lpn03,
         rxy03       LIKE rxy_file.rxy03,
         lpn04       LIKE lpn_file.lpn04,
         rxy06       LIKE rxy_file.rxy06,
         rxy20       LIKE rxy_file.rxy20,
         rxy07       LIKE rxy_file.rxy07,
         rxy08       LIKE rxy_file.rxy08,
         rxy09       LIKE rxy_file.rxy09,
         rxy10       LIKE rxy_file.rxy10,
         rxy11       LIKE rxy_file.rxy11,
         rxy12       LIKE rxy_file.rxy12,
         rxy13       LIKE rxy_file.rxy13,
         rxy14       LIKE rxy_file.rxy14,
         rxy15       LIKE rxy_file.rxy15,
         rxy16       LIKE rxy_file.rxy16,
         rxy17       LIKE rxy_file.rxy17
                     END RECORD,
     g_lpn_t         RECORD
         lpn02       LIKE lpn_file.lpn02,
         lpn03       LIKE lpn_file.lpn03,
         rxy03       LIKE rxy_file.rxy03,
         lpn04       LIKE lpn_file.lpn04,
         rxy06       LIKE rxy_file.rxy06,
         rxy20       LIKE rxy_file.rxy20,
         rxy07       LIKE rxy_file.rxy07,
         rxy08       LIKE rxy_file.rxy08,
         rxy09       LIKE rxy_file.rxy09,
         rxy10       LIKE rxy_file.rxy10,
         rxy11       LIKE rxy_file.rxy11,
         rxy12       LIKE rxy_file.rxy12,
         rxy13       LIKE rxy_file.rxy13,
         rxy14       LIKE rxy_file.rxy14,
         rxy15       LIKE rxy_file.rxy15,
         rxy16       LIKE rxy_file.rxy16,
         rxy17       LIKE rxy_file.rxy17
                     END RECORD,
       g_sql         STRING,
       g_wc          STRING,
       g_wc2         STRING,
       g_rec_b       LIKE type_file.num5,
       g_rec_b2      LIKE type_file.num5,
       g_oma         RECORD LIKE oma_file.*,
       g_str         LIKE type_file.chr1000,
       l_ac          LIKE type_file.num5,
       l_ac2         LIKE type_file.num5
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask           LIKE type_file.num5
DEFINE g_void              LIKE type_file.chr1
DEFINE g_confirm           LIKE type_file.chr1
DEFINE g_argv1             LIKE lps_file.lps01  #TQC-B20065 add
#DEFINE g_kindtype            LIKE lrk_file.lrkkind        #FUN-A70130  mark
#DEFINE g_t1                  LIKE lrk_file.lrkslip        #FUN-A70130   mark
DEFINE g_kindtype            LIKE oay_file.oaytype        #FUN-A70130
DEFINE g_t1                  LIKE oay_file.oayslip        #FUN-A70130
DEFINE g_act               LIKE type_file.chr1           #FUN-B90118 add
DEFINE g_flag2             LIKE type_file.chr1            #FUN-B90118 add
DEFINE g_f2                LIKE type_file.chr1           #FUN-B90118 add
DEFINE g_oga01             LIKE oga_file.oga01        #FUN-C10051 add
DEFINE g_n                 LIKE type_file.num10        #TQC-C30009 add
DEFINE g_oga               RECORD LIKE oga_file.*      #FUN-C90007 add  
DEFINE g_argv0             LIKE type_file.chr1        #FUN-C90007 add   
#FUN-C90070----add---str
DEFINE g_wc1             STRING
DEFINE g_wc3             STRING
DEFINE g_wc4             STRING
DEFINE l_table           STRING
TYPE sr1_t RECORD
    lps01     LIKE lps_file.lps01, 
    lps03     LIKE lps_file.lps03,
    lps08     LIKE lps_file.lps08,
    lps17     LIKE lps_file.lps17,
    lpsplant  LIKE lps_file.lpsplant,
    lps04     LIKE lps_file.lps04,
    lps16     LIKE lps_file.lps16,
    lps05     LIKE lps_file.lps05,
    lps07     LIKE lps_file.lps07,
    lps13     LIKE lps_file.lps13,
    lps09     LIKE lps_file.lps09,
    lps10     LIKE lps_file.lps10,
    lps11     LIKE lps_file.lps11,
    lps12     LIKE lps_file.lps12,
    lpt02     LIKE lpt_file.lpt02,
    lpt15     LIKE lpt_file.lpt15,
    lpt04     LIKE lpt_file.lpt04,
    lpt05     LIKE lpt_file.lpt05,
    lpt06     LIKE lpt_file.lpt06,
    lpt09     LIKE lpt_file.lpt09,
    lpt11     LIKE lpt_file.lpt11,
    lpt17     LIKE lpt_file.lpt17,
    lpt021    LIKE lpt_file.lpt021,
    lpt03     LIKE lpt_file.lpt03,
    lpt14     LIKE lpt_file.lpt14,
    lpt07     LIKE lpt_file.lpt07,
    lpt08     LIKE lpt_file.lpt08,
    lpt10     LIKE lpt_file.lpt10,
    lpt12     LIKE lpt_file.lpt12,
    lpt13     LIKE lpt_file.lpt13,
    azf03     LIKE azf_file.azf03,
    rtz13     LIKE rtz_file.rtz13
END RECORD
#FUN-C90070----add---end

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
   
   LET g_argv1 = ARG_VAL(1)  #TQC-B20065

   #LET g_kindtype = '20' #FUN-A70130
   LET g_kindtype = 'L8' #FUN-A70130

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   #FUN-C90070----add---str
   LET g_pdate = g_today
   LET g_sql ="lps01.lps_file.lps01,",
              "lps03.lps_file.lps03,",
              "lps08.lps_file.lps08,",
              "lps17.lps_file.lps17,",
              "lpsplant.lps_file.lpsplant,",
              "lps04.lps_file.lps04,",
              "lps16.lps_file.lps16,",
              "lps05.lps_file.lps05,",
              "lps07.lps_file.lps07,",
              "lps13.lps_file.lps13,",
              "lps09.lps_file.lps09,",
              "lps10.lps_file.lps10,",
              "lps11.lps_file.lps11,",
              "lps12.lps_file.lps12,",
              "lpt02.lpt_file.lpt02,",
              "lpt15.lpt_file.lpt15,",
              "lpt04.lpt_file.lpt04,",
              "lpt05.lpt_file.lpt05,",
              "lpt06.lpt_file.lpt06,",
              "lpt09.lpt_file.lpt09,",
              "lpt11.lpt_file.lpt11,",
              "lpt17.lpt_file.lpt17,",
              "lpt021.lpt_file.lpt021,",
              "lpt03.lpt_file.lpt03,",
              "lpt14.lpt_file.lpt14,",
              "lpt07.lpt_file.lpt07,",
              "lpt08.lpt_file.lpt08,",
              "lpt10.lpt_file.lpt10,",
              "lpt12.lpt_file.lpt12,",
              "lpt13.lpt_file.lpt13,",
              "azf03.azf_file.azf03,",
              "rtz13.rtz_file.rtz13"
   LET l_table = cl_prt_temptable('almt610',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                      ?,?,?,?,?, ?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   #FUN-C90070----add---end
   LET g_forupd_sql = "SELECT * FROM lps_file WHERE lps01 = ? FOR UPDATE "
   LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)

   DECLARE t610_cl CURSOR FROM g_forupd_sql

   OPEN WINDOW t610_w WITH FORM "alm/42f/almt610"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_set_comp_visible("lps14",FALSE)  #FUN-C10051 add 
   CALL cl_set_comp_visible("lpt16",FALSE)  #FUN-C30049 add
   CALL cl_ui_init()

   #TQC-B20065 --begin
   IF NOT cl_null(g_argv1) THEN 
      LET g_action_choice="query"
      IF cl_chk_act_auth() THEN
         CALL t610_q()
      END IF
   END IF
   CALL t610_menu()
   #TQC-B20065 --end
   CLOSE WINDOW t610_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION t610_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01

      CLEAR FORM
      CALL g_lpt.clear()

      CALL cl_set_head_visible("","YES")
      INITIALIZE g_lps.* TO NULL
      #TQC-B20065 --begin
      IF NOT cl_null(g_argv1) THEN
         LET g_wc = " lps01='",g_argv1,"' AND lps09='Y' "
         LET g_wc2 = ' 1=1'
      ELSE
      #TQC-B20065 --end
        #FUN-CA0160 Mark&Add Begin ---
        #CONSTRUCT BY NAME g_wc ON lpsplant,lpslegal,lps01,lps04,lps16,lps05,
        #                          lps07,lps13,lps03,lps08,lps14,lps17,lps09,lps10, #FUN-C10051 add
        #                          lps11,lps12,lpsuser,lpsgrup,lpsoriu,lpsorig,
        #                          lpsmodu,lpsdate,lpsacti,lpscrat
         CONSTRUCT BY NAME g_wc ON lpsplant,lpslegal,lps01,lps03,lps04,lps16,lps05,
                                   lps07,lps13,lps08,lps14,lps17,lps18,lps09,lps10,
                                   lps11,lps12,lpsuser,lpsgrup,lpsoriu,lpsorig,
                                   lpsmodu,lpsdate,lpsacti,lpscrat
        #FUN-CA0160 Mark&Add End -----
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
   
            ON ACTION controlp
               CASE
                  WHEN INFIELD(lps01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lps01"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lps01
                     NEXT FIELD lps01
   
                   WHEN INFIELD(lpsplant)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = 'c'
                      LET g_qryparam.form ="q_lpsplant"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO lpsplant
                      NEXT FIELD lpsplant
   
                   WHEN INFIELD(lpslegal)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = 'c'
                      LET g_qryparam.form ="q_lpslegal"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO lpslegal
                      NEXT FIELD lpslegal
                      
                  WHEN INFIELD(lps08)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lps08_1"                      #FUN-A70064 mod
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lps08
                     NEXT FIELD lps08
   
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
   
      #Begin:FUN-980030
      #   IF g_priv2='4' THEN
      #      LET g_wc = g_wc clipped," AND lpsuser = '",g_user,"'"
      #   END IF
   
      #   IF g_priv3='4' THEN
      #      LET g_wc = g_wc clipped," AND lpsgrup MATCHES '",g_grup CLIPPED,"*'"
      #   END IF
   
      #   IF g_priv3 MATCHES "[5678]" THEN
      #      LET g_wc = g_wc clipped," AND lpsgrup IN ",cl_chk_tgrup_list()
      #   END IF
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lpsuser', 'lpsgrup')
      #End:FUN-980030
   
  
                      
         CONSTRUCT g_wc2 ON lpt02,lpt021,lpj26,lpt15,lpt03,lpt04,lpt05,lpt06,lpt07,   #FUN-CA0103 add lpj26
                            lpt08,lpt09, lpt10,lpt11,lpt12,lpt17,lpt13,lpt14 ,lpt16   #No.FUN-BC0112 add lpt17  
                       FROM s_lpt[1].lpt02,s_lpt[1].lpt021,s_lpt[1].lpj26,s_lpt[1].lpt15, #FUN-CA0103 add lpj26
                            s_lpt[1].lpt03,s_lpt[1].lpt04, s_lpt[1].lpt05,
                            s_lpt[1].lpt06,s_lpt[1].lpt07, s_lpt[1].lpt08,
                            s_lpt[1].lpt09,s_lpt[1].lpt10, s_lpt[1].lpt11,
                            s_lpt[1].lpt12,s_lpt[1].lpt17, s_lpt[1].lpt13, #No.FUN-BC0112 add lpt17
                            s_lpt[1].lpt14,s_lpt[1].lpt16
   
            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
   
            ON ACTION controlp
               CASE
                  WHEN INFIELD(lpt02)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lpt02"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lpt02
                     NEXT FIELD lpt02
                  WHEN INFIELD(lpt03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lpt03"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lpt03
                     NEXT FIELD lpt03
                  WHEN INFIELD(lpt15)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lpt15"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lpt15
                     NEXT FIELD lpt15
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
   
            ON ACTION qbe_save
               CALL cl_qbe_save()
         END CONSTRUCT
         IF INT_FLAG THEN
            RETURN
         END IF
      END IF  #TQC-B20065
   
  #LET g_wc2 = g_wc2 CLIPPED #TQC-B20065
   #TQC-B20065 --begin
   IF NOT cl_null(g_wc2) THEN
      LET g_wc2 = g_wc2 CLIPPED
   ELSE
      LET g_wc2 = " 1=1"
   END IF
   #TQC-B20065 --end

   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT lps01 FROM lps_file ",
                  " WHERE ", g_wc CLIPPED,
#                  " AND lpsplant in ",g_auth,               #No.FUN-960058
                  " ORDER BY lps01"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE lps01 ",
                  "  FROM lps_file, lpt_file ",
                  " WHERE lps01 = lpt01",
#                  " AND lpsplant in ",g_auth,               #No.FUN-960058
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY lps01"
   END IF
   PREPARE t610_prepare FROM g_sql
   DECLARE t610_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t610_prepare

   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM lps_file WHERE ",g_wc CLIPPED
#      " AND lpsplant in ",g_auth                            #No.FUN-960058
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT lps01) FROM lps_file,lpt_file WHERE ",
                "lps01 = lpt01 and ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
#                " AND lpsplant in ",g_auth                  #No.FUN-960058
   END IF
   PREPARE t610_precount FROM g_sql
   DECLARE t610_count CURSOR FOR t610_precount
END FUNCTION

FUNCTION t610_menu()
DEFINE l_msg        LIKE type_file.chr1000
#DEFINE l_lrkdmy2    LIKE lrk_file.lrkdmy2       #FUN-A70130  mark
DEFINE l_oayconf    LIKE oay_file.oayconf        #FUN-A70130 
DEFINE l_lph46      LIKE lph_file.lph46          #FUN-CA0103 add
   WHILE TRUE
      CALL t610_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t610_a()
               LET g_t1=s_get_doc_no(g_lps.lps01)
               IF NOT cl_null(g_t1) THEN
        #FUN-A70130  -------------------------start---------------------------
        #          SELECT lrkdmy2
        #            INTO l_lrkdmy2
        #            FROM lrk_file
        #           WHERE lrkslip = g_t1  
        #          IF l_lrkdmy2 = 'Y' THEN
                  SELECT oayconf INTO l_oayconf  FROM oay_file
                  WHERE oayslip = g_t1
                   IF l_oayconf = 'Y' THEN
        #FUN-A70130 -------------------------end-------------------------------
                     CALL t610_confirm()
                  END IF    
               END IF                       
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t610_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
#               IF cl_chk_mach_auth(g_lps.lpsplant,g_plant) THEN
                  CALL t610_r()
#               END IF 
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
#               IF cl_chk_mach_auth(g_lps.lpsplant,g_plant) THEN
                  CALL t610_u('u')
#               END IF 
            END IF
#FUN-C90070------add------str
        WHEN "output"
           IF cl_chk_act_auth() THEN
              CALL t610_out()
           END IF
#FUN-C90070------add------end

         WHEN "invalid"
            IF cl_chk_act_auth() THEN
#               IF cl_chk_mach_auth(g_lps.lpsplant,g_plant) THEN
                  CALL t610_x()
#               END IF 
            END IF

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
#               IF cl_chk_mach_auth(g_lps.lpsplant,g_plant) THEN
                  CALL t610_confirm()
#               END IF 
            END IF
             CALL t610_pic()
    #FUN-C90007 add sta
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t610_undo_confirm()
            END IF   
    #FUN-C90007 add end 

#FUN-C90085-----mark----str
#        WHEN "cash"
#           IF cl_chk_act_auth() THEN
#              IF cl_chk_mach_auth(g_lps.lpsplant,g_plant) THEN  
#                 IF NOT cl_null(g_lps.lps01) THEN
#                    IF g_lps.lpsacti='N' THEN
#                       CALL cl_err('','9028',1)
#                    ELSE
#                      CALL t610_cash()
#                      CALL t610_lps13()
#                    END IF
#                 ELSE
#                  CALL cl_err('',-400,1)
#                 END IF
#               END IF                                            
#           END IF

#        WHEN "card"
#           IF cl_chk_act_auth() THEN
#               IF cl_chk_mach_auth(g_lps.lpsplant,g_plant) THEN
#                 IF NOT cl_null(g_lps.lps01) THEN
#                    IF g_lps.lpsacti='N' THEN
#                       CALL cl_err('','9028',1)
#                    ELSE
#                       LET l_msg = "almt6102  '",g_lps.lps01 CLIPPED,"' "
#                       CALL cl_cmdrun_wait(l_msg)
#                       CALL t610_lps13()
#                    END IF
#                 ELSE
#                    CALL cl_err('',-400,1)
#                 END IF
#               END IF 
#           END IF

#        WHEN "check"
#           IF cl_chk_act_auth() THEN
#               IF cl_chk_mach_auth(g_lps.lpsplant,g_plant) THEN
#                 IF NOT cl_null(g_lps.lps01) THEN
#                    IF g_lps.lpsacti='N' THEN
#                       CALL cl_err('','9028',1)
#                    ELSE
#                       LET l_msg = "almt6103  '",g_lps.lps01 CLIPPED,"' "
#                       CALL cl_cmdrun_wait(l_msg)
#                       CALL t610_lps13()
#                    END IF
#                 ELSE
#                    CALL cl_err('',-400,1)
#                 END IF 
#               END IF 
#           END IF
#FUN-C90085-----mark----end

#FUN-C90085-----add-----str
         WHEN "pay"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_lps.lps01) THEN
                  CALL cl_err('','-400',1)
               ELSE
                  CALL s_pay('20',g_lps.lps01,g_lps.lpsplant,g_lps.lps07,g_lps.lps09)
                  SELECT SUM(rxy05) INTO g_lps.lps13
                    FROM rxy_file
                   WHERE rxy00 = '20'
                     AND rxy01 = g_lps.lps01
                     AND rxyplant = g_lps.lpsplant
                  IF cl_null(g_lps.lps13) THEN LET g_lps.lps13 = 0 END IF
                  DISPLAY BY NAME g_lps.lps13
                  UPDATE lps_file SET lps13 = g_lps.lps13
                   WHERE lps01 = g_lps.lps01
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","lps_file",g_lps.lps01,"",SQLCA.sqlcode,"","",1)
                  END IF 
               END IF
            END IF

         WHEN "money_detail"
            IF cl_chk_act_auth() THEN
               CALL s_pay_detail('20',g_lps.lps01,g_lps.lpsplant,g_lps.lps09)
            END IF
#FUN-C90085-----add-----end
#NO.FUN-A90040  ---begin -- mark 
   #      WHEN "defray"
    #        IF cl_chk_act_auth() THEN
            #  IF cl_chk_mach_auth(g_lps.lpsplant,g_plant) THEN
     #             CALL t610_rxy()
            #  END IF
     #       END IF
 #NO.FUN-A90040  ---end -- mark 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
#               IF cl_chk_mach_auth(g_lps.lpsplant,g_plant) THEN
                  IF g_lps.lpsacti='N' THEN
                     CALL cl_err('','9028',1)
                  END IF
                  IF g_lps.lps09='Y' THEN
                     CALL cl_err('','mfg1005',0)
                  END IF
                  CALL t610_b('d')
#               END IF 
            ELSE
               LET g_action_choice = NULL
            END IF

    #FUN-B90118 add START-----------------------------------------
         WHEN "member_data"
            IF cl_chk_act_auth() THEN
               LET g_f2 = 'Y'
               CALL t610_i560()
            END IF
    #FUN-B90118 add END-------------------------------------------

#FUN-CA0103----------add------str
         WHEN "passwd"
            IF cl_chk_act_auth() THEN
               IF g_rec_b > 0 THEN
                  IF g_lps.lps09 = 'Y' THEN
                     CALL cl_err('','alm1388',0)
                  ELSE
                     SELECT lph46 INTO l_lph46
                       FROM lph_file
                      WHERE lph01 = g_lpt[l_ac].lpt03
                     IF l_lph46 <> 'Y' THEN
                        CALL cl_err('','alm1385',0)
                     ELSE
                        CALL si621_set('1','1',g_lpt[l_ac].lpt02,g_lpt[l_ac].lpt021,'2',TRUE)
                        CALL t610_b_fill(" 1=1")
                     END IF
                  END IF
               END IF
            END IF
         WHEN "resetpasswd"
            IF cl_chk_act_auth() THEN
               IF g_rec_b > 0 THEN
                  IF g_lps.lps09 = 'Y' THEN
                     CALL cl_err('','alm1388',0)
                  ELSE
                     SELECT lph46 INTO l_lph46
                       FROM lph_file
                      WHERE lph01 = g_lpt[l_ac].lpt03
                     IF l_lph46 <> 'Y' THEN
                        CALL cl_err('','alm1385',0)
                     ELSE
                        CALL si621_set('2','1',g_lpt[l_ac].lpt02,g_lpt[l_ac].lpt021,'2',TRUE)
                        CALL t610_b_fill(" 1=1")
                     END IF
                  END IF
               END IF
            END IF
#FUN-CA0103----------add------end
         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lpt),'','')
            END IF

         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_lps.lps01 IS NOT NULL THEN
                 LET g_doc.column1 = "lps01"
                 LET g_doc.value1 = g_lps.lps01
                 CALL cl_doc()
               END IF
         END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t610_v(1)
               CALL t610_pic()
            END IF
         #CHI-C80041---end 
         #FUN-D20039 ---------sta
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t610_v(2)
               CALL t610_pic()
            END IF
         #FUN-D20039 ---------end

      END CASE
   END WHILE
END FUNCTION

FUNCTION t610_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lpt TO s_lpt.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

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

      ON ACTION confirm
         LET g_action_choice = "confirm"
         EXIT DISPLAY
#FUN-C90007 add sta
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY 
#FUN-C90007 add end
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      #FUN-D20039 ------sta
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20039 ------end
#      ON ACTION unconfirm
#         LET g_action_choice = "unconfirm"
#         EXIT DISPLAY

#FUN-C90085---mark--str
#     ON ACTION cash
#        LET g_action_choice = "cash"
#        EXIT DISPLAY

#     ON ACTION card
#        LET g_action_choice = "card"
#        EXIT DISPLAY

#     ON ACTION check
#        LET g_action_choice = "check"
#        EXIT DISPLAY
#FUN-C90085---mark--end
#FUN-C90085---add---str
      ON ACTION pay
         LET g_action_choice = "pay"
         EXIT DISPLAY

      ON ACTION money_detail
         LET g_action_choice = "money_detail"
         EXIT DISPLAY
#FUN-C90085---add---end
 #NO.FUN-A90040  ---begin -- mark 
   #   ON ACTION defray
   #        LET g_action_choice = "defray"
   #        EXIT DISPLAY
 #NO.FUN-A90040  ---end -- mark 
      ON ACTION first
         CALL t610_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION previous
         CALL t610_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION jump
         CALL t610_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION next
         CALL t610_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION last
         CALL t610_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

#FUN-B90118 add START--------------------------------
      ON ACTION member_data
         LET g_action_choice="member_data"
         EXIT DISPLAY
#FUN-B90118 add END-----------------------------------

#FUN-CA0103-----add-----str
      ON ACTION passwd
         LET g_action_choice="passwd"
         EXIT DISPLAY 
      ON ACTION resetpasswd
         LET g_action_choice="resetpasswd"
         EXIT DISPLAY
#FUN-CA0103-----add-----end

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

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

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t610_bp_refresh()
  DISPLAY ARRAY g_lpt TO s_lpt.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY

END FUNCTION

FUNCTION t610_a()
   DEFINE l_count     LIKE type_file.num5
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10 
#   DEFINE l_tqa06     LIKE tqa_file.tqa06
   DEFINE l_rtz13     LIKE rtz_file.rtz13    #FUN-A80148
   DEFINE l_azt02     LIKE azt_file.azt02
   
#No.FUN-960058   
#   SELECT tqa06 INTO l_tqa06 FROM tqa_file
#    WHERE tqa03 = '14'       	 
#      AND tqaacti = 'Y'
#      AND tqa01 IN(SELECT tqb03 FROM tqb_file
#     	              WHERE tqbacti = 'Y'
#     	                AND tqb09 = '2'
#     	                AND tqb01 = g_plant) 
#   IF cl_null(l_tqa06) OR l_tqa06 = 'N' THEN 
#      CALL cl_err('','alm-600',1)
#      RETURN 
#   END IF 
#No.FUN-960058   

   SELECT COUNT(*) INTO l_count FROM rtz_file
    WHERE rtz01 = g_plant
      AND rtz28 = 'Y'
    IF l_count < 1 THEN 
       CALL cl_err('','alm-606',1)
       RETURN 
    END IF       

   MESSAGE ""
   CLEAR FORM
   LET g_success = 'Y'

   CALL g_lpt.clear()
   LET g_wc = NULL
   LET g_wc2= NULL

   IF s_shut(0) THEN
      RETURN
   END IF

   INITIALIZE g_lps.* LIKE lps_file.*
   LET g_lps01_t = NULL

   LET g_lps_t.* = g_lps.*
   CALL cl_opmsg('a')

   WHILE TRUE
      LET g_lps.lpsuser=g_user
      LET g_lps.lpsoriu = g_user #FUN-980030
      LET g_lps.lpsorig = g_grup #FUN-980030
      LET g_lps.lpscrat=g_today
      LET g_lps.lpsgrup=g_grup
      LET g_lps.lpsplant=g_plant
      LET g_lps.lpslegal=g_legal
      LET g_lps.lpsacti='Y'              #資料有效
      LET g_lps.lps03 = g_today
      LET g_lps.lps09 = 'N'
      LET g_lps.lps04 = 0
      LET g_lps.lps16 = 0
      LET g_lps.lps05 = 0
      LET g_lps.lps07 = 0
      LET g_lps.lps13 = 0
      LET g_data_plant = g_plant #No.FUN-A10060
      DISPLAY BY NAME g_lps.lpsplant      
      DISPLAY BY NAME g_lps.lpslegal
      SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01=g_lps.lpsplant
      DISPLAY l_rtz13 TO rtz13    
      SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01=g_lps.lpslegal
      DISPLAY l_azt02 TO azt02   

      CALL t610_i("a")                   #輸入單頭

      IF INT_FLAG THEN
         INITIALIZE g_lps.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF

      IF cl_null(g_lps.lps01) THEN
         CONTINUE WHILE
      END IF
      BEGIN WORK
      
        CALL s_auto_assign_no("alm",g_lps.lps01,g_lps.lpscrat,g_kindtype,"lps_file","lps01",g_lps.lpsplant,"","")
           RETURNING li_result,g_lps.lps01
        IF (NOT li_result) THEN               
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_lps.lps01
        
      INSERT INTO lps_file VALUES (g_lps.*)

      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
      #   ROLLBACK WORK             # FUN-B80060 下移兩行
         CALL cl_err3("ins","lps_file",g_lps.lps01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK             # FUN-B80060
         CONTINUE WHILE
      ELSE
         COMMIT WORK
      END IF

      SELECT lps01 INTO g_lps.lps01 FROM lps_file
       WHERE lps01 = g_lps.lps01
      LET g_lps01_t = g_lps.lps01        #保留舊值
      LET g_lps_t.* = g_lps.*
      CALL g_lpt.clear()

      LET g_rec_b = 0
      CALL t610_b('a')                   #輸入單身
      EXIT WHILE
   END WHILE

END FUNCTION

FUNCTION t610_u(p_w)
DEFINE p_w        LIKE type_file.chr1
DEFINE l_lps13    LIKE lps_file.lps13
   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lps.lps01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_lps.lps09 = 'Y' THEN
      CALL cl_err(g_lps.lps01,'alm-027',1)
      RETURN
   END IF
   IF g_lps.lps09 = 'X' THEN RETURN END IF  #CHI-C80041
   SELECT lps13 INTO l_lps13 FROM lps_file WHERE lps01=g_lps.lps01
   IF l_lps13 >0 THEN
      CALL cl_err('','alm-204',1)
      RETURN
   END IF
   SELECT * INTO g_lps.* FROM lps_file
    WHERE lps01=g_lps.lps01

   IF g_lps.lpsacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_lps.lps01,'alm-069',0)
      RETURN
   END IF

   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lps01_t = g_lps.lps01
   BEGIN WORK

   OPEN t610_cl USING g_lps01_t
   IF STATUS THEN
      CALL cl_err("OPEN t610_cl:", STATUS, 1)
      CLOSE t610_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t610_cl INTO g_lps.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_lps.lps01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE t610_cl
       ROLLBACK WORK
       RETURN
   END IF

   CALL t610_show()

   WHILE TRUE
      LET g_lps01_t = g_lps.lps01
      IF p_w !='c' THEN
         LET g_lps.lpsmodu=g_user
         LET g_lps.lpsdate=g_today
      END IF

      CALL t610_i("u")                      #欄位更改

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lps.*=g_lps_t.*
         CALL t610_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF

      IF g_lps.lps01 != g_lps01_t THEN            # 更改單號
         UPDATE lpt_file SET lpt01 = g_lps.lps01
          WHERE lpt01 = g_lps01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lpt_file",g_lps01_t,"",SQLCA.sqlcode,"","pmx",1)
            CONTINUE WHILE
         END IF
      END IF

      UPDATE lps_file SET lps_file.* = g_lps.*
       WHERE lps01 = g_lps01_t

      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lps_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE

   CLOSE t610_cl
   COMMIT WORK

   CALL t610_b_fill("1=1")
   CALL t610_bp_refresh()

END FUNCTION

FUNCTION t610_i(p_cmd)
DEFINE    l_n         LIKE type_file.num5
DEFINE    l_n1        LIKE type_file.num5
DEFINE    p_cmd       LIKE type_file.chr1
DEFINE    li_result   LIKE type_file.num5
DEFINE    l_rtz13     LIKE rtz_file.rtz13
DEFINE    l_rtz28     LIKE rtz_file.rtz28
DEFINE    l_lph24     LIKE lph_file.lph24
DEFINE    l_lph03     LIKE lph_file.lph03
DEFINE    l_lmf03     LIKE lmf_file.lmf03
DEFINE    l_lmf04     LIKE lmf_file.lmf04
DEFINE    l_lni10     LIKE lni_file.lni10

   IF s_shut(0) THEN
      RETURN
   END IF

   DISPLAY BY NAME g_lps.lpsoriu,g_lps.lpsorig,g_lps.lps09,g_lps.lpsuser,g_lps.lpsmodu,
                   g_lps.lpsgrup,g_lps.lpsdate,g_lps.lpsacti,g_lps.lpscrat,
                   g_lps.lps04,g_lps.lps16,g_lps.lps05,g_lps.lps07,g_lps.lps13,g_lps.lps03

   INPUT BY NAME g_lps.lps01,g_lps.lps03,g_lps.lps08,g_lps.lps12   #FUN-C50040 add lps03
            WITHOUT DEFAULTS

      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t610_set_entry(p_cmd)
         CALL t610_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("lps01")
         CALL cl_set_comp_required("lps03",TRUE)  #FUN-C50040 add

      AFTER FIELD lps01
       IF NOT cl_null(g_lps.lps01) THEN   
            CALL s_check_no("alm",g_lps.lps01,g_lps01_t,g_kindtype,"lps_file","lps01","")
                 RETURNING li_result,g_lps.lps01
            IF (NOT li_result) THEN
               LET g_lps.lps01=g_lps_t.lps01
               NEXT FIELD lps01
            END IF
            DISPLAY BY NAME g_lps.lps01             
        END IF

        AFTER FIELD lps08
         IF NOT cl_null(g_lps.lps08) THEN
            IF g_lps.lps08 != g_lps_t.lps08 OR
               g_lps_t.lps08 IS NULL THEN 
               CALL t610_lps08(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  IF g_errno = 'anm-027' THEN
                     CALL cl_err("",'alm-31',1)
                  ELSE
                     CALL cl_err(g_lps.lps08,g_errno,1)
                  END IF
                  LET g_lps.lps08 = g_lps_t.lps08
                  NEXT FIELD lps08
               END IF
             END IF  
         ELSE                                          #FUN-AA0072
            DISPLAY '' TO FORMONLY.azf03               #FUN-AA0072
         END IF    
                 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)


      ON ACTION controlp
         CASE
            WHEN INFIELD(lps01)     #單據編號
               LET g_t1=s_get_doc_no(g_lps.lps01)
              # CALL q_lrk(FALSE,FALSE,g_t1,g_kindtype,'ALM') RETURNING g_t1   #FUN-A70130 mark
               CALL q_oay(FALSE,FALSE,g_t1,g_kindtype,'ALM') RETURNING g_t1   #FUN-A70130  add
               LET g_lps.lps01 = g_t1
               DISPLAY BY NAME g_lps.lps01
               NEXT FIELD lps01
                        
            WHEN INFIELD(lps08)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azf03"
               LET g_qryparam.arg1='2'                            #FUN-A70064
               LET g_qryparam.arg2 = 'G'                          #FUN-A70064
               LET g_qryparam.default1 = g_lps.lps08
               CALL cl_create_qry() RETURNING g_lps.lps08
               DISPLAY BY NAME g_lps.lps08
               CALL t610_lps08('d')
               NEXT FIELD lps08

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

FUNCTION t610_lps08(p_cmd)
 DEFINE  p_cmd       LIKE type_file.chr1
 DEFINE  l_azf03     LIKE azf_file.azf03
 DEFINE  l_azfacti   LIKE azf_file.azfacti

   LET g_errno=''
   SELECT azf03,azfacti INTO l_azf03,l_azfacti
     FROM azf_file
    WHERE azf01 = g_lps.lps08
      AND azf02 = '2'                                    #FUN-A70064
      AND azf09 = 'G'                                    #FUN-A70064
   CASE WHEN SQLCA.sqlcode=100 LET g_errno = 'anm-027' 
                               LET l_azf03 = NULL
        WHEN l_azfacti = 'N'   LET g_errno = '9028'
        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE
     
   IF cl_null(g_errno) OR p_cmd= 'd' THEN
      DISPLAY l_azf03 TO FORMONLY.azf03
   END IF 
END FUNCTION

FUNCTION t610_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_lpt.clear()
   DISPLAY ' ' TO FORMONLY.cnt

   CALL t610_cs()

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lps.* TO NULL
      RETURN
   END IF

   OPEN t610_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lps.* TO NULL
   ELSE
      OPEN t610_count
      FETCH t610_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt

      CALL t610_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF

END FUNCTION

FUNCTION t610_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式

   CASE p_flag
      WHEN 'N' FETCH NEXT     t610_cs INTO g_lps.lps01
      WHEN 'P' FETCH PREVIOUS t610_cs INTO g_lps.lps01
      WHEN 'F' FETCH FIRST    t610_cs INTO g_lps.lps01
      WHEN 'L' FETCH LAST     t610_cs INTO g_lps.lps01
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
            FETCH ABSOLUTE g_jump t610_cs INTO g_lps.lps01
            LET g_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lps.lps01,SQLCA.sqlcode,0)
      INITIALIZE g_lps.* TO NULL
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

   SELECT * INTO g_lps.* FROM lps_file WHERE lps01 = g_lps.lps01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lps_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_lps.* TO NULL
      RETURN
   END IF

   LET g_data_owner = g_lps.lpsuser
   LET g_data_group = g_lps.lpsgrup
   LET g_data_plant = g_lps.lpsplant #No.FUN-A10060
   CALL t610_show()

END FUNCTION

FUNCTION t610_show()
DEFINE l_rtz13     LIKE rtz_file.rtz13
DEFINE l_lmb03     LIKE lmb_file.lmb03
DEFINE l_lmc04     LIKE lmc_file.lmc04
DEFINE l_lps06     LIKE lps_file.lps06
DEFINE l_lps07     LIKE lps_file.lps07
DEFINE l_azt02     LIKE azt_file.azt02

   LET g_lps_t.* = g_lps.*
   DISPLAY BY NAME g_lps.lpsplant,g_lps.lpslegal,g_lps.lps01,g_lps.lps04,
                   g_lps.lps16,g_lps.lps05,g_lps.lps07,g_lps.lps13,
                   g_lps.lps03,g_lps.lps08,g_lps.lps14,g_lps.lps09,g_lps.lps17,g_lps.lps18, #FUN-C10051 add #FUN-CA0160 Add lps18
                   g_lps.lps09,g_lps.lps10,g_lps.lps11,g_lps.lps12,
                   g_lps.lpsuser,g_lps.lpsgrup,g_lps.lpsmodu,g_lps.lpsdate,
                   g_lps.lpsacti,g_lps.lpscrat,g_lps.lpsoriu,g_lps.lpsorig
   SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01=g_lps.lpsplant
   DISPLAY l_rtz13 TO rtz13    
   SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01=g_lps.lpslegal
   DISPLAY l_azt02 TO azt02 
   CALL t610_lps08('d')
   CALL t610_pic()
   CALL t610_b_fill(g_wc2)                 #單身
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION t610_x()
DEFINE l_lps13   LIKE lps_file.lps13
   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lps.lps01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_lps.lps09 = 'Y' THEN
      CALL cl_err(g_lps.lps01,'alm-027',1)
      RETURN
   END IF
   SELECT lps13 INTO l_lps13 FROM lps_file WHERE lps01=g_lps.lps01
   IF l_lps13 >0 THEN
      CALL cl_err('','alm-204',1)
      RETURN
   END IF

   BEGIN WORK

   OPEN t610_cl USING g_lps.lps01
   IF STATUS THEN
      CALL cl_err("OPEN t610_cl:", STATUS, 1)
      CLOSE t610_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t610_cl INTO g_lps.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lps.lps01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF

   LET g_success = 'Y'

   CALL t610_show()

   IF cl_exp(0,0,g_lps.lpsacti) THEN                   #確認一下
      LET g_chr=g_lps.lpsacti
      IF g_lps.lpsacti='Y' THEN
         LET g_lps.lpsacti='N'
         LET g_lps.lpsmodu = g_user
      ELSE
         LET g_lps.lpsacti='Y'
         LET g_lps.lpsmodu = g_user
      END IF

      UPDATE lps_file SET lpsacti=g_lps.lpsacti,
                          lpsmodu=g_lps.lpsmodu,
                          lpsdate=g_today
       WHERE lps01=g_lps.lps01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lps_file",g_lps.lps01,"",SQLCA.sqlcode,"","",1)
         LET g_lps.lpsacti=g_chr
      END IF
   END IF

   CLOSE t610_cl

   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF

   SELECT lpsacti,lpsmodu,lpsdate
     INTO g_lps.lpsacti,g_lps.lpsmodu,g_lps.lpsdate FROM lps_file
    WHERE lps01=g_lps.lps01
   DISPLAY BY NAME g_lps.lpsmodu,g_lps.lpsdate,g_lps.lpsacti
   CALL t610_pic()

END FUNCTION

FUNCTION t610_r()
DEFINE l_lps13   LIKE lps_file.lps13
DEFINE l_sql     STRING               #FUN-CA0103 add
DEFINE l_lpt02   LIKE lpt_file.lpt02  #FUN-CA0103 add
DEFINE l_lpt021  LIKE lpt_file.lpt021 #FUN-CA0103 add
DEFINE l_lpt03   LIKE lpt_file.lpt03  #FUN-CA0103 add
   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lps.lps01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   IF g_lps.lps09 = 'Y' THEN
      CALL cl_err(g_lps.lps01,'alm-028',1)
      RETURN
   END IF
   IF g_lps.lps09 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lps.lpsacti = 'N' THEN
      CALL cl_err(g_lps.lps01,'alm-147',1)
      RETURN
   END IF

   SELECT lps13 INTO l_lps13 FROM lps_file WHERE lps01=g_lps.lps01
   IF l_lps13 >0 THEN
      CALL cl_err('','alm-204',1)
      RETURN
   END IF

   SELECT * INTO g_lps.* FROM lps_file
    WHERE lps01=g_lps.lps01
   LET g_lps01_t=g_lps.lps01 
    BEGIN WORK

   OPEN t610_cl USING g_lps01_t
   IF STATUS THEN
      CALL cl_err("OPEN t610_cl:", STATUS, 1)
      CLOSE t610_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t610_cl INTO g_lps.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lps.lps01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF

   CALL t610_show()

   IF cl_delh(0,0) THEN                   #確認一下
      #FUN-CA0103--------add-----str
      UPDATE lpj_file SET lpj26 = '',
                          lpjpos = '2'   #FUN-D30007 add
       WHERE lpj03 IN (SELECT lpj03 FROM lpj_file,lpt_file
                        WHERE lpt01 = g_lps01_t
                          AND lpj03 BETWEEN lpt02 AND lpt021)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","lpj_file",g_lps01_t,'',SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF
      #FUN-CA0103--------add-----end
      DELETE FROM lps_file WHERE lps01 = g_lps01_t
      DELETE FROM lpt_file WHERE lpt01 = g_lps01_t
      #FUN-C90085----add----str
      CALL undo_pay( '20',g_lps.lps01,g_lps.lpsplant,g_lps.lps07,g_lps.lps09)
      IF g_success = 'N' THEN
         ROLLBACK WORK
         RETURN
      END IF    
      #FUN-C90085----add----end

      CLEAR FORM
      CALL g_lpt.clear()
      OPEN t610_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE t610_cs
         CLOSE t610_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH t610_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t610_cs
         CLOSE t610_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t610_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t610_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE      #No:FUN-6A0067
         CALL t610_fetch('/')
      END IF
   END IF

   CLOSE t610_cl
   COMMIT WORK
END FUNCTION

#單身
FUNCTION t610_b(p_w)
 DEFINE  l_ac_t          LIKE type_file.num5                #未取消的ARRAY CNT
 DEFINE  l_n             LIKE type_file.num5                #檢查重複用
 DEFINE  l_cnt           LIKE type_file.num5                #檢查重複用
 DEFINE  l_lock_sw       LIKE type_file.chr1                #單身鎖住否
 DEFINE  p_cmd           LIKE type_file.chr1                #處理狀態
 DEFINE  l_allow_insert  LIKE type_file.num5
 DEFINE  l_allow_delete  LIKE type_file.num5
 DEFINE  l_lps05         LIKE lps_file.lps05
 DEFINE  l_lmd06         LIKE lmd_file.lmd06
 DEFINE  l_count         LIKE type_file.num5
 DEFINE  l_count1        LIKE type_file.num5
 DEFINE  l_lps06         LIKE lps_file.lps06
 DEFINE  l_lps07         LIKE lps_file.lps07
 DEFINE  l_lph07         LIKE lph_file.lph07
 DEFINE  l_lph09         LIKE lph_file.lph09
 DEFINE  l_lph10         LIKE lph_file.lph10
 DEFINE  l_lph11         LIKE lph_file.lph11
 DEFINE  l_lpt14         LIKE lpt_file.lpt14
 DEFINE  p_w             LIKE type_file.chr1
 DEFINE  l_amt           LIKE lps_file.lps07
 DEFINE  l_cnt2          LIKE type_file.num5   #FUN-B90118 add
 DEFINE  l_lph43         LIKE lph_file.lph43    #FUN-C50058 add
 DEFINE  l_lph44         LIKE lph_file.lph44    #FUN-C50058 add
 DEFINE  l_num           LIKE type_file.num5    #FUN-C50058 add
 DEFINE  l_length        LIKE type_file.num5    #FUN-C50058 add
 DEFINE  l_lph33         LIKE lph_file.lph33    #FUN-C50058 add
 DEFINE  l_lph34         LIKE lph_file.lph34    #FUN-C50058 add
 DEFINE  l_lph46         LIKE lph_file.lph46    #FUN-CA0103 add
 DEFINE  l_lpj26         LIKE lpj_file.lpj26    #FUN-CA0103 add
    LET g_action_choice = ""

    IF s_shut(0) THEN
       RETURN
    END IF

    IF g_lps.lps01 IS NULL THEN
       RETURN
    END IF

    SELECT * INTO g_lps.* FROM lps_file WHERE lps01=g_lps.lps01
    IF g_lps.lps09 = 'Y' THEN
       CALL cl_err('','alm-097',1)
       RETURN
    END IF
    IF g_lps.lps09 = 'X' THEN RETURN END IF  #CHI-C80041
    IF g_lps.lpsacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_lps.lps01,'alm-004',0)
       RETURN
    END IF

    IF g_lps.lps13>0 THEN 
       CALL cl_err('','alm-595',1)
       RETURN 
    END IF 

    DROP TABLE t610_tmp1;
    DROP TABLE t610_tmp2;
    DROP TABLE t610_tmp5;
    DROP TABLE t610_tmp6;
    CREATE TEMP TABLE t610_tmp1(
           lrt021 LIKE lpj_file.lpj03);
    CREATE TEMP TABLE t610_tmp2(
           lpj03  LIKE lpj_file.lpj03,
           lpj09  LIKE lpj_file.lpj09);
    CREATE UNIQUE INDEX t610_tmp2_01 ON t610_tmp2(lrt021);
    CREATE TEMP TABLE t610_tmp5(
           lrt021 LIKE lpj_file.lpj03);
    CREATE UNIQUE INDEX t610_tmp5_01 ON t610_tmp5(lrt021);
    CREATE TEMP TABLE t610_tmp6(
           lrt021 LIKE lpj_file.lpj03);
    CREATE UNIQUE INDEX t610_tmp6_01 ON t610_tmp6(lrt021);

    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT lpt02,lpt021,lpj26,lpt15,lpt03,lpt04,lpt05,lpt06,",  #FUN-CA0103 add lpj26
                       "       lpt07,lpt08, lpt09,lpt10,lpt11,lpt12,lpt17,lpt13,",  #No.FUN-BC0112 add lpt17
                       "       lpt14,lpt16 FROM lpt_file,lpj_file",                 #FUN-CA0103 add
                       " WHERE lpj03 = lpt02 and lpt01 =? and lpt02 =? ",           #FUN-CA0103 add
                       "  FOR UPDATE  "
    LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)

    DECLARE t610_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_lpt WITHOUT DEFAULTS FROM s_lpt.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)

        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF

        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()

           BEGIN WORK

           OPEN t610_cl USING g_lps.lps01
           IF STATUS THEN
              CALL cl_err("OPEN t610_cl:", STATUS, 1)
              CLOSE t610_cl
              ROLLBACK WORK
              RETURN
           END IF

           FETCH t610_cl INTO g_lps.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lps.lps01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t610_cl
              ROLLBACK WORK
              RETURN
           END IF

           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_lpt_t.* = g_lpt[l_ac].*  #BACKUP
              OPEN t610_bcl USING g_lps.lps01,g_lpt_t.lpt02
              IF STATUS THEN
                 CALL cl_err("OPEN t610_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t610_bcl INTO g_lpt[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_lpt_t.lpt02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()
              CALL t610_set_entry_b(p_cmd)
              CALL t610_set_no_entry_b(p_cmd,0)
           END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_lpt[l_ac].* TO NULL
           LET g_lpt_t.* = g_lpt[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()
           LET g_before_input_done = FALSE
           CALL t610_set_entry_b(p_cmd)
           LET g_before_input_done = TRUE
           CALL t610_set_no_entry_b(p_cmd,g_lps.lps13)
           NEXT FIELD lpt02

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF cl_null(g_lpt[l_ac].lpt02) THEN
              CALL cl_err(g_lpt[l_ac].lpt02,'alm-062',1)
              NEXT FIELD lpt02
           END IF

          INSERT INTO lpt_file(lpt01,lpt02,lpt021,lpt03,lpt04,lpt05,lpt06,lpt07,
                               lpt08,lpt09,lpt10,lpt11,lpt12,lpt17,lpt13,lpt14,lpt15,     #No.FUN-BC0112 add lpt17
                               lptplant,lptlegal,lpt16)
          VALUES(g_lps.lps01,g_lpt[l_ac].lpt02,g_lpt[l_ac].lpt021,g_lpt[l_ac].lpt03,
                 g_lpt[l_ac].lpt04,g_lpt[l_ac].lpt05,g_lpt[l_ac].lpt06,
                 g_lpt[l_ac].lpt07,g_lpt[l_ac].lpt08,g_lpt[l_ac].lpt09,
                 g_lpt[l_ac].lpt10,g_lpt[l_ac].lpt11,g_lpt[l_ac].lpt12,
                 g_lpt[l_ac].lpt17, #No.FUN-BC0112
                 g_lpt[l_ac].lpt13,g_lpt[l_ac].lpt14,g_lpt[l_ac].lpt15,
                 g_lps.lpsplant,g_lps.lpslegal,g_lpt[l_ac].lpt16)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lpt_file",g_lps.lps01,g_lpt[l_ac].lpt02,SQLCA.sqlcode,"","",1)
             CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF

        AFTER FIELD lpt02
           IF NOT cl_null(g_lpt[l_ac].lpt02) THEN
              IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lpt[l_ac].lpt02 != g_lpt_t.lpt02) THEN
                 CALL t610_lpt02(p_cmd,g_lpt[l_ac].lpt02)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_lpt[l_ac].lpt02,g_errno,0)
                    LET g_lpt[l_ac].lpt02=g_lpt_t.lpt02
                    NEXT FIELD lpt02
                 END IF
                 IF g_success = 'N' THEN
                    LET g_lpt[l_ac].lpt02=g_lpt_t.lpt02
                    NEXT FIELD lpt02
                 END IF
                 CALL t610_amt()
              END IF
           END IF
     #FUN-B90118 add START------------------
           IF cl_null(g_lpt[l_ac].lpt021) THEN
              LET g_lpt[l_ac].lpt021 = g_lpt[l_ac].lpt02
          #   LET g_lpt[l_ac].lpt03 = ''           #FUN-D10021 mark
              DISPLAY BY NAME g_lpt[l_ac].lpt021
           END IF
     #FUN-B90118 add END--------------------

        BEFORE FIELD lpt021
           IF cl_null(g_lpt[l_ac].lpt02) THEN
     #FUN-B90118 add START------------------
              LET g_lpt[l_ac].lpt021 = g_lpt[l_ac].lpt02
              DISPLAY BY NAME g_lpt[l_ac].lpt021
           IF cl_null(g_lpt[l_ac].lpt02) AND cl_null(g_lpt[l_ac].lpt021) THEN
              LET g_lpt[l_ac].lpt03 = ''
              LET g_lpt[l_ac].lpt04 = ''
           END IF
     #FUN-B90118 add END--------------------
              NEXT FIELD lpt02
           ELSE
              IF cl_null(g_lpt[l_ac].lpt021) THEN
                 LET g_lpt[l_ac].lpt021 = g_lpt[l_ac].lpt02
                 DISPLAY BY NAME g_lpt[l_ac].lpt021
              END IF
           END IF

        AFTER FIELD lpt021
           IF NOT cl_null(g_lpt[l_ac].lpt021) THEN
              IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lpt[l_ac].lpt021 != g_lpt_t.lpt021) THEN
                 CALL t610_lpt02(p_cmd,g_lpt[l_ac].lpt021)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_lpt[l_ac].lpt021,g_errno,0)
                    LET g_lpt[l_ac].lpt021 = g_lpt_t.lpt021
                    NEXT FIELD lpt021
                 END IF
                 IF g_success = 'N' THEN
                    LET g_lpt[l_ac].lpt021=g_lpt_t.lpt021
                    NEXT FIELD lpt021
                 END IF
                 CALL t610_amt()
              END IF
           END IF
     #FUN-B90118 add START------------------
           IF cl_null(g_lpt[l_ac].lpt021) THEN
              LET g_lpt[l_ac].lpt021 = g_lpt[l_ac].lpt02
              DISPLAY BY NAME g_lpt[l_ac].lpt021
           END IF
     #FUN-B90118 add END--------------------
 
        AFTER FIELD lpt09
           IF NOT cl_null(g_lpt[l_ac].lpt09) THEN
              IF g_lpt[l_ac].lpt09 < 0 THEN
                 CALL cl_err('','alm-061',0)
                 NEXT FIELD lpt09
              END IF
             #FUN-C50058 add START
              SELECT lph43,lph44 INTO l_lph43,l_lph44
                FROM lph_file
               WHERE lph01 = g_lpt[l_ac].lpt03
              IF NOT cl_null(l_lph43) AND g_lpt[l_ac].lpt09 > l_lph43 THEN
                 CALL cl_err('','alm-h30',0)
                 NEXT FIELD lpt09 
              END IF              
             #FUN-C50058 add END
              CALL t610_amt()
             #FUN-C50058 add START
              SELECT lph33,lph34 INTO l_lph33,l_lph34
                FROM lph_file
               WHERE lph01 = g_lpt[l_ac].lpt03 
              LET l_length = LENGTH(g_lpt[l_ac].lpt02)
              LET l_num = g_lpt[l_ac].lpt021[l_lph33+1,l_length] - g_lpt[l_ac].lpt02[l_lph33+1,l_length]+1
              IF NOT cl_null(l_lph44) AND ((g_lpt[l_ac].lpt10/l_num) > l_lph44) THEN
                 CALL cl_err('','alm-h31',0)
                 NEXT FIELD lpt09
              END IF 
             #FUN-C50058 add END
              #FUN-C30049 MARK STA
              #IF g_lpt[l_ac].lpt09 > 0 THEN
              #   CALL cl_set_comp_entry("lpt16",TRUE)
              #ELSE
              #   CALL cl_set_comp_entry("lpt16",FALSE)
              #END IF
              #FUN-C30049 MARK END
           END IF

        AFTER FIELD lpt11
           IF NOT cl_null(g_lpt[l_ac].lpt11) THEN
              IF g_lpt[l_ac].lpt11 < 0 OR g_lpt[l_ac].lpt11 > 100 THEN
                 CALL cl_err('','alm-257',0)
                 NEXT FIELD lpt11
              END IF
              CALL t610_amt()
           END IF
        #FUN-C30048 STA
        BEFORE FIELD lpt14
           IF NOT cl_null(g_lpt[l_ac].lpt14) THEN
              CALL cl_set_comp_entry("lpt14",FALSE) 
           ELSE
              CALL cl_set_comp_entry("lpt14",TRUE)
           END IF
        #FUN-C30048 END 
        AFTER FIELD lpt14
           IF NOT cl_null(g_lpt[l_ac].lpt14) THEN
              IF g_lpt[l_ac].lpt14 < g_today THEN
                 CALL cl_err('','alm-531',0)
                 NEXT FIELD lpt14
              END IF
              SELECT lph09,lph10,lph11 INTO l_lph09,l_lph10,l_lph11
                FROM lph_file
               WHERE lph01 = g_lpt[l_ac].lpt03
             #IF l_lph09 = '0' THEN  #FUN-C30042 mark
              IF l_lph09 = '1' THEN  #FUN-C30042 add  #指定日期 
                 LET l_lpt14 = l_lph10
              END IF
             #IF l_lph09 = '1' AND NOT cl_null(l_lph11) THEN  #FUN-C30042 mark
              IF l_lph09 = '2' AND NOT cl_null(l_lph11) THEN  #FUN-C30042 add  #指定長度
              #  SELECT add_months(g_today,l_lph11) INTO l_lpt14 FROM dual
                 CALL t610_add_month(g_today,l_lph11) RETURNING l_lpt14
              END IF
             #IF NOT cl_null(l_lpt14) AND
             # ((NOT cl_null(g_lpt[l_ac].lpt14 AND g_lpt[l_ac].lpt14 > l_lpt14)
             #   OR cl_null(g_lpt[l_ac].lpt14) THEN
             #   CALL cl_err('','alm-564',0)
             #   LET g_lpt[l_ac].lpt14=g_lpt_t.lpt14
             #   NEXT FIELD lpt14
             #END IF
           END IF

#FUN-B90118 add
        BEFORE FIELD lpt15
           IF NOT cl_null(g_lpt[l_ac].lpt02) AND cl_null(g_lpt[l_ac].lpt15)  THEN
            #  BEGIN WORK  #CHI-C30021 MARK
              IF cl_confirm('alm1601') THEN #CHI-C30021 add
                 IF cl_confirm('alm-h10') THEN
                    LET g_lpt[l_ac].lpt15 = g_lpt[l_ac].lpt02
                 END IF  #CHI-C30021 add 
                 CALL t610_i560() 
        #         SELECT COUNT(*) INTO l_cnt2 FROM lpk_file WHERE lpk01 = g_lpt[l_ac].lpt02  #CHI-C30021 MARK
                 SELECT COUNT(*) INTO l_cnt2 FROM lpk_file WHERE lpk01 = g_lpt[l_ac].lpt15  #CHI-C30021 add 
                 IF l_cnt2 = 0 THEN
                    LET g_lpt[l_ac].lpt15 = ''
                    DISPLAY BY NAME g_lpt[l_ac].lpt15
                 END IF
              ELSE
                #CALL t610_i560()  #FUN-C10005 mark
                #FUN-C10005 add START
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lpk"      
                 LET g_qryparam.default1 = g_lpt[l_ac].lpt15
                 CALL cl_create_qry() RETURNING g_lpt[l_ac].lpt15
                 DISPLAY BY NAME g_lpt[l_ac].lpt15
                # NEXT FIELD lpt15  #CHI-C30021 add
                #FUN-C10005 add END
              END IF
           END IF
#FUN-B90118 add

        AFTER FIELD lpt15
           IF NOT cl_null(g_lpt[l_ac].lpt15) THEN
              CALL t610_lpt15(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_lpt[l_ac].lpt15,g_errno,0)
                 LET g_lpt[l_ac].lpt15=g_lpt_t.lpt15
                 NEXT FIELD lpt15
              END IF
           END IF

        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF g_lpt_t.lpt02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM lpt_file
               WHERE lpt01 = g_lps.lps01
                 AND lpt02 = g_lpt_t.lpt02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","lpt_file",g_lps.lps01,g_lpt_t.lpt02,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              #FUN-CA0103-----add-----str
              UPDATE lpj_file SET lpj26 = '',
                                  lpjpos = '2'   #FUN-D30007 add 
               WHERE lpj02 = g_lpt_t.lpt03
                 AND lpj03 BETWEEN g_lpt_t.lpt02 AND g_lpt_t.lpt021
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","lpj_file",g_lpt_t.lpt02,g_lpt_t.lpt021,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              #FUN-CA0103-----add-----end
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK

        ON ROW CHANGE

           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_lpt[l_ac].* = g_lpt_t.*
              CLOSE t610_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lpt[l_ac].lpt02,-263,1)
              LET g_lpt[l_ac].* = g_lpt_t.*
           ELSE
              UPDATE lpt_file SET lpt02 = g_lpt[l_ac].lpt02,
                                  lpt021= g_lpt[l_ac].lpt021,
                                  lpt03 = g_lpt[l_ac].lpt03,
                                  lpt04 = g_lpt[l_ac].lpt04,
                                  lpt05 = g_lpt[l_ac].lpt05,
                                  lpt06 = g_lpt[l_ac].lpt06,
                                  lpt07 = g_lpt[l_ac].lpt07,
                                  lpt08 = g_lpt[l_ac].lpt08,
                                  lpt09 = g_lpt[l_ac].lpt09,
                                  lpt10 = g_lpt[l_ac].lpt10,
                                  lpt11 = g_lpt[l_ac].lpt11,
                                  lpt12 = g_lpt[l_ac].lpt12,
                                  lpt17 = g_lpt[l_ac].lpt17,   #No.FUN-BC0112
                                  lpt13 = g_lpt[l_ac].lpt13,
                                  lpt14 = g_lpt[l_ac].lpt14,
                                  lpt15 = g_lpt[l_ac].lpt15,
                                  lpt16 = g_lpt[l_ac].lpt16
               WHERE lpt01 = g_lps.lps01
                 AND lpt02 = g_lpt_t.lpt02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","lpt_file",g_lps.lps01,g_lpt_t.lpt02,SQLCA.sqlcode,"","",1)
                 LET g_lpt[l_ac].* = g_lpt_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF

        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           CALL t610_amt1()
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac       #FUN-D30033 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_lpt[l_ac].* = g_lpt_t.*
              #FUN-D30033--add--str--
              ELSE
                 CALL g_lpt.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end--
              END IF
              CLOSE t610_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac       #FUN-D30033 Add
           CLOSE t610_bcl
           COMMIT WORK

        ON ACTION controlp
           CASE
              WHEN INFIELD(lpt02)
                 CALL cl_init_qry_var()
                #LET g_qryparam.form ="q_lpj1"
                 LET g_qryparam.form ="q_lpj6"       #FUN-B90118 add
                 LET g_qryparam.arg1 = '1'
                 LET g_qryparam.arg2 = g_plant       #FUN-B90118 add 
                 LET g_qryparam.default1 = g_lpt[l_ac].lpt02
                 CALL cl_create_qry() RETURNING g_lpt[l_ac].lpt02
                 DISPLAY BY NAME g_lpt[l_ac].lpt02
                 NEXT FIELD lpt02
              WHEN INFIELD(lpt15)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lpk"
                 LET g_qryparam.default1 = g_lpt[l_ac].lpt15
                 CALL cl_create_qry() RETURNING g_lpt[l_ac].lpt15
                 DISPLAY BY NAME g_lpt[l_ac].lpt15
                 NEXT FIELD lpt15
              OTHERWISE EXIT CASE
           END CASE

        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(lpt02) AND l_ac > 1 THEN
              LET g_lpt[l_ac].* = g_lpt[l_ac-1].*
              #LET g_lpt[l_ac].lpt02 = g_rec_b + 1   #MOD-A30214
              NEXT FIELD lpt02
           END IF

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

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
#FUN-CA0103----------add------str
        ON ACTION passwd
           IF NOT cl_null(g_lpt[l_ac].lpt02) AND NOT cl_null(g_lpt[l_ac].lpt021) THEN
              IF g_lps.lps09 = 'Y' THEN
                 CALL cl_err('','alm1388',0)
              ELSE
                 SELECT lph46 INTO l_lph46
                   FROM lph_file
                  WHERE lph01 = g_lpt[l_ac].lpt03
                 IF l_lph46 <> 'Y' THEN
                    CALL cl_err('','alm1385',0)
                 ELSE
                    CALL si621_set('1','1',g_lpt[l_ac].lpt02,g_lpt[l_ac].lpt021,'2',TRUE)
                    SELECT lpj26 INTO l_lpj26 
                      FROM lpj_file
                     WHERE lpj03 = g_lpt[l_ac].lpt02
                    LET g_lpt[l_ac].lpj26 = l_lpj26
                    DISPLAY BY NAME g_lpt[l_ac].lpj26
                 END IF
              END IF
           END IF
        ON ACTION resetpasswd
           IF NOT cl_null(g_lpt[l_ac].lpt02) AND NOT cl_null(g_lpt[l_ac].lpt021) THEN
              IF g_lps.lps09 = 'Y' THEN
                 CALL cl_err('','alm1388',0)
              ELSE
                 SELECT lph46 INTO l_lph46
                   FROM lph_file
                  WHERE lph01 = g_lpt[l_ac].lpt03
                 IF l_lph46 <> 'Y' THEN
                    CALL cl_err('','alm1385',0)
                 ELSE
                    CALL si621_set('2','1',g_lpt[l_ac].lpt02,g_lpt[l_ac].lpt021,'2',TRUE)
                    SELECT lpj26 INTO l_lpj26 
                      FROM lpj_file
                     WHERE lpj03 = g_lpt[l_ac].lpt02
                    LET g_lpt[l_ac].lpj26 = l_lpj26
                    DISPLAY BY NAME g_lpt[l_ac].lpj26
                 END IF
              END IF
           END IF
#FUN-CA0103----------add------end
    END INPUT

   IF p_cmd = 'u' AND p_w !='c' THEN
      LET g_lps.lpsmodu = g_user
      LET g_lps.lpsdate = g_today
      UPDATE lps_file SET lpsmodu = g_lps.lpsmodu,
                          lpsdate = g_lps.lpsdate
       WHERE lps01 = g_lps.lps01
   END IF

    DISPLAY BY NAME g_lps.lpsmodu,g_lps.lpsdate

    CLOSE t610_bcl
    COMMIT WORK
#   CALL t610_delall() #CHI-C30002 mark
    CALL t610_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t610_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_lps.lps01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM lps_file ",
                  "  WHERE lps01 LIKE '",l_slip,"%' ",
                  "    AND lps01 > '",g_lps.lps01,"'"
      PREPARE t610_pb1 FROM l_sql 
      EXECUTE t610_pb1 INTO l_cnt      
      
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
         CALL t610_v(1)
         CALL t610_pic()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM lps_file WHERE lps01 = g_lps.lps01
         INITIALIZE g_lps.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t610_delall()

#  SELECT COUNT(*) INTO g_cnt FROM lpt_file
#   WHERE lpt01 = g_lps.lps01
#     AND lpt02 IS NOT NULL

#  IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM lps_file
#           WHERE lps01 = g_lps.lps01
#  END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end

FUNCTION t610_lpt02(p_cmd,p_no)
 DEFINE p_no            LIKE lpt_file.lpt02
 DEFINE p_cmd           LIKE type_file.chr1
 DEFINE l_no            LIKE lrt_file.lrt04
 DEFINE l_length        LIKE type_file.num5
 DEFINE l_cnt           LIKE type_file.num5
 DEFINE l_lpj02         LIKE lpj_file.lpj02
 DEFINE l_lpj09         LIKE lpj_file.lpj09
 DEFINE l_lph03         LIKE lph_file.lph03
 DEFINE l_lph05         LIKE lph_file.lph05
 DEFINE l_lph08         LIKE lph_file.lph08
 DEFINE l_lph09         LIKE lph_file.lph09
 DEFINE l_lph10         LIKE lph_file.lph10
 DEFINE l_lph11         LIKE lph_file.lph11
 DEFINE l_lph21         LIKE lph_file.lph21
 DEFINE l_lph22         LIKE lph_file.lph22
 DEFINE l_lph23         LIKE lph_file.lph23
 DEFINE l_lph32         LIKE lph_file.lph32
 DEFINE l_lph33         LIKE lph_file.lph33
 DEFINE l_lph34         LIKE lph_file.lph34
 DEFINE l_lph35         LIKE lph_file.lph35

   LET g_errno = ''
   SELECT lpj02,lpj09 INTO l_lpj02,l_lpj09
     FROM lpj_file
    WHERE lpj03 = p_no
   CASE WHEN SQLCA.sqlcode=100 LET g_errno = 'alm-218'
        WHEN l_lpj09 <> '1'    LET g_errno = 'alm-683'
        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) THEN
      SELECT COUNT(*) INTO l_cnt FROM lnk_file
       WHERE lnk01 = l_lpj02
         AND lnk02 = '1'
         AND lnk03 = g_lps.lpsplant
         AND lnk05 = 'Y'
      IF l_cnt = 0 THEN
         LET g_errno = 'alm-694'
      END IF
   END IF

   IF cl_null(g_errno) THEN
      SELECT lph03,lph05,lph08,lph09,lph10,lph11,lph21,lph22,lph23,lph32,lph33,lph34,lph35
        INTO l_lph03,l_lph05,l_lph08,l_lph09,l_lph10,l_lph11,l_lph21,
             l_lph22,l_lph23,l_lph32,l_lph33,l_lph34,l_lph35
        FROM lph_file
       WHERE lph01 = l_lpj02
      IF cl_null(g_lpt[l_ac].lpt03) THEN
         IF l_lph03 = 'Y' THEN
           # CALL cl_set_comp_entry("lpt09,lpt11",TRUE)  #FUN-C30046 MARK
            CALL cl_set_comp_entry("lpt09",TRUE) #FUN-C30046 add 
         ELSE
            CALL cl_set_comp_entry("lpt09",FALSE) #FUN-C30046 add
           # CALL cl_set_comp_entry("lpt09,lpt11",FALSE)  #FUN-C30046 MARK
         END IF
         IF l_lph05 = 'Y' THEN
            LET g_lpt[l_ac].lpt11 = l_lph08
           # CALL cl_set_comp_entry("lpt11",TRUE)  #FUN-C30046 MARK
         ELSE
            LET g_lpt[l_ac].lpt11 = 100
           # CALL cl_set_comp_entry("lpt11",FALSE)  #FUN-C30046 MARK
         END IF
         LET g_lpt[l_ac].lpt03 = l_lpj02
         LET g_lpt[l_ac].lpt04 = l_lph21
         LET g_lpt[l_ac].lpt05 = l_lph22
         LET g_lpt[l_ac].lpt06 = l_lph23
        #IF l_lph09 = '0' THEN  #FUN-C30042 mark
         IF l_lph09 = '1' THEN  #FUN-C30042 add  #指定日期
            LET g_lpt[l_ac].lpt14 = l_lph10
         END IF
        #IF l_lph09 = '1' AND NOT cl_null(l_lph11) THEN  #FUN-C30042 mark
         IF l_lph09 = '2' AND NOT cl_null(l_lph11) THEN  #FUN-C30042 add  #指定長度
         #  SELECT add_months(g_today,l_lph11) INTO g_lpt[l_ac].lpt14 FROM dual
            CALL t610_add_month(g_today,l_lph11) RETURNING g_lpt[l_ac].lpt14
         END IF
         DISPLAY BY NAME g_lpt[l_ac].lpt03,g_lpt[l_ac].lpt04,g_lpt[l_ac].lpt05,
                         g_lpt[l_ac].lpt06,g_lpt[l_ac].lpt14,g_lpt[l_ac].lpt11
      ELSE
         IF g_lpt[l_ac].lpt03 <> l_lpj02 THEN
            LET g_errno = 'alm-684'
            RETURN
        #FUN-D10021--add--str---
         ELSE
            SELECT COUNT(DISTINCT lpj02) INTO l_cnt FROM lpj_file,lph_file
             WHERE lpj02 = lph01 AND lph34 = l_lph34 
               AND LENGTH(lpj03) = l_lph32
               AND (lpj03 BETWEEN g_lpt[l_ac].lpt02 AND g_lpt[l_ac].lpt021)
            IF l_cnt > 1 THEN
               LET g_errno = 'alm-990'
               RETURN
            END IF 
        #FUN-D10021--add--end---
         END IF
      END IF
      LET l_length = LENGTH(p_no)
      LET l_no = p_no[1,l_lph33]
      SELECT COUNT(*) INTO l_cnt FROM lps_file,lpt_file,lph_file      #FUN-D10021 add lph_file
        WHERE lps09 = 'N' AND lpt01 = lps01
      #   AND substr(lpt02,l_lph33+1,l_length)<= substr(p_no,l_lph33+1,l_length)
      #   AND substr(lpt021,l_lph33+1,l_length)>= substr(p_no,l_lph33+1,l_length)
      #   AND substr(lpt02,1,l_lph33) = l_no
          AND lpt02 <= p_no
          AND lpt021 >= p_no
      #   AND lpt03 = g_lpt[l_ac].lpt03    #指定卡種,卡種的固定編碼不同      #FUN-D10021 mark
          AND lpt02 <> g_lpt[l_ac].lpt02
          AND lpt03 = lph01 AND lph34 = l_lph34 AND LENGTH(lpt021) = l_lph32    #FUN-D10021 add
      IF l_cnt > 0 THEN          #檢查重複,卡號不存在于未審核的單據中
         LET g_errno = 'alm-579'
         RETURN
      END IF
      IF NOT cl_null(g_lpt[l_ac].lpt02) AND NOT cl_null(g_lpt[l_ac].lpt021) THEN
         IF g_lpt[l_ac].lpt02[l_lph33+1,l_length] > g_lpt[l_ac].lpt021[l_lph33+1,l_length] THEN
            LET g_errno = 'aim-919'
            RETURN
         END IF
         SELECT COUNT(*) INTO l_cnt FROM lps_file,lpt_file,lph_file      #FUN-D10021 add lph_file
          WHERE lps09 = 'N' AND lpt01 = lps01
         #  AND substr(lpt02,l_lph33+1,l_length)<= substr(g_lpt[l_ac].lpt02,l_lph33+1,l_length)
         #  AND substr(lpt021,l_lph33+1,l_length)>= substr(g_lpt[l_ac].lpt021,l_lph33+1,l_length)
         #  AND substr(lpt02,1,l_lph33) = l_no
            AND lpt02 >= g_lpt[l_ac].lpt02
            AND lpt021 <= g_lpt[l_ac].lpt021
         #  AND lpt03 = g_lpt[l_ac].lpt03    #FUN-D10021 mark
            AND lpt02 <> g_lpt[l_ac].lpt02 
            AND lpt03 = lph01 AND lph34 = l_lph34 AND LENGTH(lpt021) = l_lph32    #FUN-D10021 add 
         IF l_cnt > 0 THEN      #檢查重複,卡號不存在于未審核的單據中
            LET g_errno = 'alm-579'
            RETURN
         END IF
         CALL t610_check_no(l_lph33,l_lph34,g_lpt[l_ac].lpt02,g_lpt[l_ac].lpt021)
      END IF
   END IF
END FUNCTION

FUNCTION t610_add_month(p_date,p_mm)
 DEFINE p_mm          LIKE type_file.num5
 DEFINE p_date        LIKE type_file.dat
 DEFINE l_yy          LIKE type_file.num5 #No.FUN-9B0136
 DEFINE l_mm          LIKE type_file.num5 #No.FUN-9B0136

   LET l_mm = MONTH(p_date)
   LET l_yy = YEAR(p_date)
   IF p_mm > 12 THEN
      LET l_yy = l_yy + p_mm/12
      LET l_mm = l_mm + (p_mm MOD 12)
   ELSE
      LET l_mm = l_mm + p_mm
   END IF
   IF l_mm > 12 THEN
      LET l_yy = l_yy + 1
      LET l_mm = l_mm - 12
   END IF
   LET p_date = MDY(l_mm,DAY(p_date),l_yy)
   RETURN p_date
END FUNCTION

FUNCTION t610_check_no(p_lph33,p_lph34,p_no1,p_no2)
 DEFINE p_no1             LIKE lrt_file.lrt04
 DEFINE p_no2             LIKE lrt_file.lrt05
 DEFINE p_lph33           LIKE lph_file.lph33
 DEFINE p_lph34           LIKE lph_file.lph34
 DEFINE l_cnt             LIKE type_file.num5

   LET g_success = 'Y'
   CALL s_showmsg_init()
   DELETE FROM t610_tmp1
   DELETE FROM t610_tmp2
   DELETE FROM t610_tmp5
   DELETE FROM t610_tmp6

   CALL t610_gen_coupon_no(p_lph33,p_lph34,p_no1,p_no2,1)
   CALL t610_ins_lpj_tmp(2)
   CALL t610_lpj_check1(3)
   CALL t610_lpj_check2(4)

   SELECT COUNT(*) INTO l_cnt FROM t610_tmp5
   IF l_cnt > 0 THEN 
      CALL t610_error('t610_tmp5',5,'alm-685')
      LET g_success = 'N'
   END IF
   SELECT COUNT(*) INTO l_cnt FROM t610_tmp6
   IF l_cnt > 0 THEN
      CALL t610_error('t610_tmp6',6,'alm-218')
      LET g_success = 'N'
   END IF
   CALL s_showmsg()
END FUNCTION

#TQC-A70103--Begin
FUNCTION t610_create_sql()
DEFINE l_sql STRING
      LET l_sql="drop procedure t610_proc1"
      EXECUTE IMMEDIATE l_sql
      LET l_sql=" create procedure t610_proc1 @v1 integer,@v2 integer,@v3 integer,@v7 nvarchar(20),@v8 integer,@v6 integer output"
                      ||" as begin"
                      ||" declare @i integer"
                      ||" set @i = 0"
                      ||" set @v6 = 0"
                      ||" while @i < @v3"
                      ||" begin "
                      ||" INSERT INTO t610_tmp1 "
                      ||" SELECT (ltrim(@v7) +"
                      ||" substring(cast(cast(power(10,@v8-len(@v1+@i)) as varchar) + cast((@i+@v1) as varchar) as varchar),2,@v8))"
                      ||" as lrt021"
                      ||" set @v6=@v6+1"
                      ||" set @i = @i+1"
                      ||" end"
                      ||" end"                      
      EXECUTE IMMEDIATE l_sql
      PREPARE stmt FROM "{ CALL t610_proc1(?,?,?,?,?,?) }"
END FUNCTION
#TQC-A70103--End

FUNCTION t610_gen_coupon_no(p_lph33,p_lph34,p_no1,p_no2,p_step)
 DEFINE p_step            LIKE type_file.num5
 DEFINE l_rows            LIKE type_file.num20
 DEFINE p_no1             LIKE lrt_file.lrt04
 DEFINE p_no2             LIKE lrt_file.lrt05
 DEFINE l_start_no        LIKE type_file.num20
 DEFINE l_end_no          LIKE type_file.num20
 DEFINE l_start_no1       LIKE type_file.num20
 DEFINE l_length          LIKE type_file.num5
 DEFINE l_length1         LIKE type_file.num5
 DEFINE l_no              LIKE lrt_file.lrt04
 DEFINE p_lph33           LIKE lph_file.lph33
 DEFINE p_lph34           LIKE lph_file.lph34
 DEFINE l_nums            LIKE type_file.num20
 DEFINE l_db_type         LIKE type_file.chr4    #TQC-A70103

   DISPLAY 'begin_time:',TIME

 #  ERROR 'Begin Step ',p_step USING "&<",'(產生卡號)' #CHI-C30021 MARK
   CALL ui.Interface.refresh()
   DISPLAY '產生卡號開始:',TIME

   LET l_no = p_no1[1,p_lph33]
   LET l_length  = LENGTH(p_no1)
   #LET l_length1 = LENGTH(p_no1)-LENGTH(p_lph34) #MOD-CA0064 mark
   LET l_length1 = LENGTH(p_no1)-p_lph33          #MOD-CA0064 add
   LET l_start_no = p_no1[p_lph33+1,l_length]
   LET l_end_no = p_no2[p_lph33+1,l_length]
   LET l_nums = l_end_no - l_start_no + 1
   IF cl_null(l_nums) THEN LET l_nums = 0 END IF
   LET l_start_no1 = l_start_no - 1
#TQC-A70103 --Begin
   LET l_db_type=cl_db_get_database_type()
   IF l_db_type='MSV' THEN
      CALL t610_create_sql()
      EXECUTE stmt USING l_start_no IN,l_end_no IN,l_nums IN,p_lph34 IN,l_length1 IN,l_rows OUT
   ELSE
#TQC-A70103--End
  #LET g_sql = "SELECT CONCAT('",p_lph34 CLIPPED,"',",
  #            "  LPAD(to_char(id+",l_start_no1,"),",l_length1,",'0')) as lrt021  ",
   LET g_sql = "SELECT ('",p_lph34 CLIPPED,"'||",
               " substr(power(10,",l_length1,"-length(id+",l_start_no1,")) || (id+",l_start_no1,"),2)) as lrt021 ",
               "  FROM (SELECT level AS id FROM dual ",
               "         CONNECT BY level <=",l_nums,")",
               "  INTO TEMP t610_tmp1"
   PREPARE t610_reg_p1 FROM g_sql
   EXECUTE t610_reg_p1    
   IF SQLCA.sqlcode THEN  
      LET g_success = 'N' 
      CALL s_errmsg('','','insert temp t610_tmp1',SQLCA.sqlcode,1)
      RETURN
   END IF
   LET l_rows = SQLCA.sqlerrd[3]
   END IF          #TQC-A70103
   DISPLAY '產生卡號結束:',TIME,l_rows
  # ERROR 'Finish Step ',p_step USING "&<",'(產生卡號):',l_rows,'rows'   #CHI-C30021 MARK
   CALL ui.Interface.refresh() 
#  CREATE UNIQUE INDEX t610_tmp1_01 ON t610_tmp1(lrt021);     #MOD-B50027
END FUNCTION

FUNCTION t610_ins_lpj_tmp(p_step)
   DEFINE l_rows         LIKE type_file.num20
   DEFINE p_step         LIKE type_file.num5

  # ERROR 'Begin Step ',p_step USING '&<','(檢查表1)'   #CHI-C30021 MARK
   CALL ui.Interface.refresh()
   DISPLAY "產生臨時表lpj_file資料開始:",TIME
#TQC-A70103 --Begin
#  LET g_sql = "SELECT UNIQUE lpj03,lpj09 FROM lpj_file",
#              " WHERE lpj03 IN (SELECT lrt021 FROM t610_tmp1)",
#              "  INTO TEMP t610_tmp2 "
   LET g_sql = " INSERT INTO t610_tmp2 ",
               " SELECT DISTINCT lpj03,lpj09 FROM lpj_file",
               "  WHERE lpj03 IN (SELECT lrt021 FROM t610_tmp1)"
#TQC-A70103 --End
   PREPARE t610_reg_p9 FROM g_sql
   EXECUTE t610_reg_p9
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL s_errmsg('','','insert temp t610_tmp2',SQLCA.sqlcode,1)
      RETURN
   END IF
   LET l_rows = SQLCA.sqlerrd[3]
   DISPLAY '產生臨時表lpj_file資料結束:',TIME,l_rows
  # ERROR 'Finish Step ',p_step USING "&<",'(檢查1):',l_rows,'rows'  #CHI-C30021 MARK
   CALL ui.Interface.refresh()
   CREATE UNIQUE INDEX t610_tmp2_01 ON t610_tmp2(lpj03);
END FUNCTION

#卡狀態非'1-開卡',則收集至t610_tmp5中
FUNCTION t610_lpj_check1(p_step)
   DEFINE p_step         LIKE type_file.num5
   DEFINE l_rows         LIKE type_file.num20

  # ERROR 'Begin Step ',p_step USING "&<",'(收集卡狀態非 1-開卡 的資料):'   #CHI-C30021 MARK
   CALL ui.Interface.refresh()
   DISPLAY "收集卡狀態非'1-開卡'的資料:",TIME
#TQC-A70103 --Begin
#  LET g_sql = "SELECT lrt021 FROM t610_tmp1",
#              " WHERE lrt021 IN (SELECT lpj03 FROM t610_tmp2 WHERE lpj09 <> '1') ",
#              "  INTO TEMP t610_tmp5"
   LET g_sql = " INSERT INTO t610_tmp5",
               " SELECT lrt021 FROM t610_tmp1",
               " WHERE lrt021 IN (SELECT lpj03 FROM t610_tmp2 WHERE lpj09 <> '1') "
#TQC-A70103 --End
               
   PREPARE t610_reg_p22 FROM g_sql
   EXECUTE t610_reg_p22
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL s_errmsg('','','insert temp t610_tmp5',SQLCA.sqlcode,1)
      RETURN
   END IF
   LET l_rows = SQLCA.sqlerrd[3]
   DISPLAY "收集卡狀態非'1-開卡'的資料結束:",TIME,l_rows
 #  ERROR 'Finish Step ',p_step USING "&<",'(收集卡狀態非 1-開卡 的資料):',l_rows,'rows'   #CHI-C30021 MARK
   CALL ui.Interface.refresh()
   CREATE UNIQUE INDEX t610_tmp5_01 ON t610_tmp5(lrt021);
END FUNCTION

#不存在于lpj_file中，則收集至t610_tmp6中
FUNCTION t610_lpj_check2(p_step)
   DEFINE p_step         LIKE type_file.num5
   DEFINE l_rows         LIKE type_file.num20

  #ERROR 'Begin Step ',p_step USING "&<",'(收集不存在于lpj_file中卡號):'  #FUN-B90118 mark
  # ERROR 'Begin Step ',p_step USING "&<",'(收集不存在於lpj_file中卡號):'    #FUN-B90118 add  #CHI-C30021 MARK
   CALL ui.Interface.refresh()
  #DISPLAY "收集不存在于lpj_file中卡號:",TIME  #FUN-B90118 mark
   DISPLAY "收集不存在於lpj_file中卡號:",TIME  #FUN-B90118 add
#TQC-A70103 --Begin
#  LET g_sql = "SELECT lrt021 FROM t610_tmp1",
#              " WHERE lrt021 NOT IN (SELECT lpj03 FROM t610_tmp2 ) ",
#              "  INTO TEMP t610_tmp6"
   LET g_sql = " INSERT INTO t610_tmp6", 
               " SELECT lrt021 FROM t610_tmp1",
               " WHERE lrt021 NOT IN (SELECT lpj03 FROM t610_tmp2 ) "
#TQC-A70103 --End

   PREPARE t610_reg_p26 FROM g_sql
   EXECUTE t610_reg_p26
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL s_errmsg('','','insert temp t610_tmp6',SQLCA.sqlcode,1)
      RETURN
   END IF
   LET l_rows = SQLCA.sqlerrd[3]
   DISPLAY "收集不存在于lpj_file中卡號結束:",TIME,l_rows
  # ERROR 'Finish Step ',p_step USING "&<",'(收集不存在于lpj_file中卡號):',l_rows,'rows'  #CHI-C30021 MARK
   CALL ui.Interface.refresh()
   CREATE UNIQUE INDEX t610_tmp6_01 ON t610_tmp6(lrt021);
END FUNCTION

#錯誤訊息記錄array
FUNCTION t610_error(p_table,p_step,p_errno)
   DEFINE p_table        LIKE gat_file.gat01
   DEFINE p_step         LIKE type_file.num5
   DEFINE p_errno        LIKE ze_file.ze01
   DEFINE l_lrt021       LIKE lrt_file.lrt04
   DEFINE l_i            LIKE type_file.num10

  # ERROR 'Begin Step ',p_step USING '&<','(報錯信息匯總',p_table CLIPPED,')'   #CHI-C30021 MARK
   CALL ui.Interface.refresh()
   DISPLAY "報錯",p_table CLIPPED,'開始:',TIME
   LET g_sql = "SELECT lrt021 FROM ",p_table
   DECLARE t610_tmp5_cs CURSOR FROM g_sql
   LET l_i = 1
   FOREACH t610_tmp5_cs INTO l_lrt021
      IF l_i > 10000 THEN
         EXIT FOREACH
      END IF
      CALL s_errmsg('lrt04',l_lrt021,'foreach t610_tmp5_cs',p_errno,1)
      LET l_i = l_i + 1
   END FOREACH
   DISPLAY "報錯",p_table CLIPPED,'結束:',TIME
  # ERROR 'Finish Step ',p_step USING '&<','(報錯信息匯總',p_table CLIPPED,')'   #CHI-C30021 MARK
   CALL ui.Interface.refresh()
END FUNCTION

FUNCTION t610_amt()
 DEFINE l_length       LIKE type_file.num20
#DEFINE l_num          LIKE type_file.num5       #FUN-C70045 mark
 DEFINE l_num          LIKE type_file.num20      #FUN-C70045 add
 DEFINE l_lph33        LIKE lph_file.lph33
#No.FUN-BC0112---add---begin----
 DEFINE l_lph40        LIKE lph_file.lph40 
 DEFINE l_lph41        LIKE lph_file.lph41 
 DEFINE l_lph42        LIKE lph_file.lph42
 DEFINE l_lrp02        LIKE lrp_file.lrp02 
 DEFINE l_lrp06        LIKE lrp_file.lrp06   #FUN-C60057 add
 DEFINE l_lrp07        LIKE lrp_file.lrp07   #FUN-C60056 add
 DEFINE l_lpk10        LIKE lpk_file.lpk10
 DEFINE l_lpk13        LIKE lpk_file.lpk13
 DEFINE l_lrq02        LIKE lrq_file.lrq02
 DEFINE l_lrq06        LIKE lrq_file.lrq06
 DEFINE l_lrq07        LIKE lrq_file.lrq07
 DEFINE l_lrq08        LIKE lrq_file.lrq08
 DEFINE l_lrq09        LIKE lrq_file.lrq09
 DEFINE l_multiple_1   LIKE type_file.num5
 DEFINE l_multiple     LIKE lrq_file.lrq07
 DEFINE l_value        LIKE lrq_file.lrq07
   SELECT lph40,lph41,lph42 INTO l_lph40,l_lph41,l_lph42
     FROM lph_file
    WHERE lph01 = g_lpt[l_ac].lpt03
   IF l_lph40='Y' THEN
      SELECT lrp02,lrp06,lrp07 INTO l_lrp02,l_lrp06,l_lrp07   #FUN-C60057 add lrp06,lrp07
        FROM lrp_file
       WHERE lrp00= '3'
         AND lrp01= g_lpt[l_ac].lpt03
         AND g_lps.lps03 BETWEEN lrp04 AND lrp05    
         AND lrpplant = g_plant                       #FUN-C60057 add
         AND lrpacti = 'Y'                            #FUN-C60057 add
         AND lrp09 = 'Y'                              #FUN-C60057 add
      IF NOT cl_null(l_lrp02) THEN
         SELECT lpk10,lpk13 INTO l_lpk10,l_lpk13
           FROM lpk_file
          WHERE lpk01= g_lpt[l_ac].lpt15
         IF l_lrp02='1' THEN
            LET l_lrq02= l_lpk10
         END IF
         IF l_lrp02='2' THEN
            LET l_lrq02= l_lpk13
         END IF
         SELECT lrq06,lrq07,lrq08,lrq09 INTO l_lrq06,l_lrq07,l_lrq08,l_lrq09
           FROM lrq_file
          WHERE lrq00= '3'
            AND lrq01= g_lpt[l_ac].lpt03
            AND lrq02= l_lrq02
           #AND (lrq10 <= g_today AND lrq11 >= g_today)  #TQC-C30112 add   #FUN-C60057 mark
            AND lrq12 = l_lrp06       #FUN-C60057 add
            AND lrq13 = l_lrp07       #FUN-C60057 add
            AND lrqplant = g_plant    #FUN-C60057 add
            AND lrqacti = 'Y'         #FUN-C40109 Add
      ELSE
         LET l_lrq06= l_lph41
         LET l_lrq07= l_lph42
         LET l_lrq08= 100
         LET l_lrq09= 'N'
      END IF
   END IF
#No.FUN-BC0112----add------end-----------
   LET l_length = LENGTH(g_lpt[l_ac].lpt02)
   SELECT lph33 INTO l_lph33 FROM lph_file
    WHERE lph01 = g_lpt[l_ac].lpt03
   LET l_num = g_lpt[l_ac].lpt021[l_lph33+1,l_length] - g_lpt[l_ac].lpt02[l_lph33+1,l_length]+1
   IF cl_null(g_lpt[l_ac].lpt05) THEN LET g_lpt[l_ac].lpt05 = 0 END IF
   IF cl_null(g_lpt[l_ac].lpt06) THEN LET g_lpt[l_ac].lpt06 = 0 END IF
   IF cl_null(g_lpt[l_ac].lpt07) THEN LET g_lpt[l_ac].lpt07 = 0 END IF
   IF cl_null(g_lpt[l_ac].lpt08) THEN LET g_lpt[l_ac].lpt08 = 0 END IF
   IF cl_null(g_lpt[l_ac].lpt09) THEN LET g_lpt[l_ac].lpt09 = 0 END IF
   IF cl_null(g_lpt[l_ac].lpt10) THEN LET g_lpt[l_ac].lpt10 = 0 END IF
   IF cl_null(g_lpt[l_ac].lpt11) THEN LET g_lpt[l_ac].lpt11 = 100 END IF
   IF cl_null(g_lpt[l_ac].lpt12) THEN LET g_lpt[l_ac].lpt12 = 0 END IF
   IF cl_null(g_lpt[l_ac].lpt13) THEN LET g_lpt[l_ac].lpt13 = 0 END IF
#No.FUN-BC0112----add------begin--------
   IF cl_null(g_lpt[l_ac].lpt17) THEN LET g_lpt[l_ac].lpt17 = 0 END IF

   IF (l_lph40 = 'Y') AND (g_lpt[l_ac].lpt09 >= l_lrq06) THEN
      LET g_lpt[l_ac].lpt07 = g_lpt[l_ac].lpt05 * l_num
      LET g_lpt[l_ac].lpt08 = g_lpt[l_ac].lpt06 * l_num
      LET g_lpt[l_ac].lpt10 = g_lpt[l_ac].lpt09 * l_num
      LET l_multiple = g_lpt[l_ac].lpt09 / l_lrq06
      IF l_lrq09 = 'Y' THEN
         LET l_multiple_1 = l_multiple
         LET l_multiple = l_multiple_1
      END IF
      LET l_value = l_multiple * l_lrq07
      LET g_lpt[l_ac].lpt17 = l_value * ( l_lrq08 / 100 ) * l_num
      LET g_lpt[l_ac].lpt12 = g_lpt[l_ac].lpt10 * (100 - g_lpt[l_ac].lpt11)/100
      LET g_lpt[l_ac].lpt12 = g_lpt[l_ac].lpt12 + g_lpt[l_ac].lpt17
      #LET g_lpt[l_ac].lpt10 = g_lpt[l_ac].lpt10 + g_lpt[l_ac].lpt12     #No.TQC-C30060
      LET g_lpt[l_ac].lpt10 = g_lpt[l_ac].lpt10 + g_lpt[l_ac].lpt17      #No.TQC-C30060
      LET g_lpt[l_ac].lpt13 = g_lpt[l_ac].lpt10 - g_lpt[l_ac].lpt12 + g_lpt[l_ac].lpt08
   ELSE
#No.FUN-BC0112----add------end----------
      LET g_lpt[l_ac].lpt07 = g_lpt[l_ac].lpt05 * l_num
      LET g_lpt[l_ac].lpt08 = g_lpt[l_ac].lpt06 * l_num
      LET g_lpt[l_ac].lpt10 = g_lpt[l_ac].lpt09 * l_num
      LET g_lpt[l_ac].lpt12 = g_lpt[l_ac].lpt10 * (100 - g_lpt[l_ac].lpt11)/100
      LET g_lpt[l_ac].lpt13 = g_lpt[l_ac].lpt10 - g_lpt[l_ac].lpt12 + g_lpt[l_ac].lpt08
   END IF            #No.FUN-BC0112
   DISPLAY BY NAME g_lpt[l_ac].lpt07,g_lpt[l_ac].lpt08,
                   g_lpt[l_ac].lpt09,g_lpt[l_ac].lpt10,
                   g_lpt[l_ac].lpt11,g_lpt[l_ac].lpt12,
                   g_lpt[l_ac].lpt13
END FUNCTION

FUNCTION t610_amt1()

   SELECT SUM(lpt07),SUM(lpt08),SUM(lpt10),SUM(lpt13)
     INTO g_lps.lps04,g_lps.lps16,g_lps.lps05,g_lps.lps07
     FROM lpt_file
    WHERE lpt01 = g_lps.lps01
   #FUN-CA0103----add----str
   IF cl_null(g_lps.lps04) THEN
      LET g_lps.lps04 = 0
   END IF
   IF cl_null(g_lps.lps05) THEN
      LET g_lps.lps05 = 0
   END IF
   IF cl_null(g_lps.lps07) THEN
      LET g_lps.lps07 = 0
   END IF
   IF cl_null(g_lps.lps16) THEN
      LET g_lps.lps16 = 0
   END IF
   UPDATE lps_file SET lps04 = g_lps.lps04,
                       lps16 = g_lps.lps16,
                       lps05 = g_lps.lps05,
                       lps07 = g_lps.lps07
    WHERE lps01 = g_lps.lps01
  #No.TQC-A30075 -BEGIN-----
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err('upd_lps',SQLCA.SQLCODE,0)
   END IF
  #No.TQC-A30075 -END-------
   DISPLAY BY NAME g_lps.lps04,g_lps.lps16,g_lps.lps05,g_lps.lps07

END FUNCTION

FUNCTION t610_lpt15(p_cmd)
 DEFINE  p_cmd       LIKE type_file.chr1
 DEFINE  l_cnt       LIKE type_file.num5

   LET g_errno=''
   SELECT COUNT(*) INTO l_cnt
     FROM lpk_file
    WHERE lpk01 = g_lpt[l_ac].lpt15
   IF l_cnt < 1 THEN
      LET g_errno = 'alm-682'
   END IF
END FUNCTION

FUNCTION t610_b_fill(p_wc2)
DEFINE p_wc2   STRING
DEFINE  l_s      LIKE type_file.chr1000
DEFINE  l_m      LIKE type_file.chr1000
DEFINE  i        LIKE type_file.num5
DEFINE  l_n      LIKE type_file.num5

   LET g_sql = "SELECT lpt02,lpt021,lpj26,lpt15,lpt03,lpt04,lpt05,lpt06,lpt07,",  #FUN-CA0103 add lpj26
               "       lpt08,lpt09,lpt10,lpt11,lpt12,lpt17,lpt13,lpt14,lpt16 ",   #No.FUN-BC0112 add lpt17
               "  FROM lpt_file,lpj_file",                                        #FUN-CA0103 add lpj_file
               " WHERE lpt01 ='",g_lps.lps01,"' ",
               "   AND lpj03 = lpt02"                                             #FUN-CA0103 add

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY lpt02 "

   DISPLAY g_sql

   PREPARE t610_pb FROM g_sql
   DECLARE lpt_cs CURSOR FOR t610_pb

   CALL g_lpt.clear()
   LET g_cnt = 1

   FOREACH lpt_cs INTO g_lpt[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_lpt.deleteElement(g_cnt)

   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0

END FUNCTION

FUNCTION t610_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lps01",TRUE)
    END IF
END FUNCTION

FUNCTION t610_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("lps01",FALSE)
    END IF
END FUNCTION

FUNCTION t610_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

     IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("lpt02",TRUE)
     END IF
END FUNCTION

FUNCTION t610_set_no_entry_b(p_cmd,p_w)
  DEFINE p_cmd   LIKE type_file.chr1
  DEFINE p_w     LIKE lps_file.lps13
  DEFINE l_lpj16 LIKE lpj_file.lpj16
  DEFINE l_lph05 LIKE lph_file.lph05

    IF p_cmd = 'u' AND g_chkey = 'N' AND p_w!=0 THEN
      CALL cl_set_comp_entry("lpt02",FALSE)
    END IF
    #FUN-C30049 MARK SRA
    #IF g_lpt[l_ac].lpt09 > 0 THEN
    #   CALL cl_set_comp_entry("lpt16",TRUE)
    #ELSE
    #   CALL cl_set_comp_entry("lpt16",FALSE)
    #END IF
    #FUN-C30049 MARK END
    #FUN-C30048 STA
    IF NOT cl_null(g_lpt[l_ac].lpt14) THEN
       CALL cl_set_comp_entry("lpt14",FALSE)
    ELSE
       CALL cl_set_comp_entry("lpt14",TRUE)
    END IF
    #FUN-C30048 END
    IF p_cmd = 'u' THEN
       SELECT lph05,lpj16 INTO l_lph05,l_lpj16 FROM lph_file,lpj_file
        WHERE lpj03 = g_lpt[l_ac].lpt02
          AND lph01 = lpj02
       IF l_lpj16 = 'Y' THEN
        #  CALL cl_set_comp_entry("lpt09,lpt11",TRUE) #FUN-C30046 MARK
          CALL cl_set_comp_entry("lpt09",TRUE) ##FUN-C30046 add
       ELSE
       #   CALL cl_set_comp_entry("lpt09,lpt11",FALSE)  #FUN-C30046 MARK
          CALL cl_set_comp_entry("lpt09",FALSE)  #FUN-C30046 add
       END IF
     ##FUN-C30046 MARK STA 
     #  IF l_lph05 = 'Y' THEN
     #     CALL cl_set_comp_entry("lpt11",TRUE)
     #  ELSE
     #     CALL cl_set_comp_entry("lpt11",FALSE)
     #  END IF
     ##FUN-C30046 MARK END
    END IF
END FUNCTION

FUNCTION t610_confirm()
  DEFINE l_lps10         LIKE lps_file.lps10
  DEFINE l_lps11         LIKE lps_file.lps11
  DEFINE amt             LIKE lps_file.lps05
  DEFINE l_lps13         LIKE lps_file.lps13
  DEFINE l_rxy05a        LIKE rxy_file.rxy05
  DEFINE l_rxy05b        LIKE rxy_file.rxy05
  DEFINE l_rxy05c        LIKE rxy_file.rxy05
  DEFINE l_flag          LIKE type_file.chr1     
  DEFINE l_wc_gl         LIKE type_file.chr1000  
  DEFINE l_oma01         LIKE oma_file.oma01     
  DEFINE l_lpn04         LIKE lpn_file.lpn04
  DEFINE l_ogaconf       LIKE oga_file.ogaconf #FUN-C10051 add
  DEFINE l_ogapost       LIKE oga_file.ogapost #FUN-C10051 add
  DEFINE l_rcj05         LIKE rcj_file.rcj05   #FUN-C10051 add
  DEFINE l_rcj06         LIKE rcj_file.rcj06   #FUN-C10051 add  
  DEFINE l_cnt           LIKE type_file.num5   #FUN-CB0011 add

   IF cl_null(g_lps.lps01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#CHI-C30107 ------------ add ------------- begin
   IF g_lps.lps09 = 'Y' THEN
      CALL cl_err(g_lps.lps01,'alm-005',1)
      RETURN
   END IF
   IF g_lps.lps09 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lps.lpsacti ='N' THEN
     CALL cl_err(g_lps.lps01,'alm-004',1)
     RETURN
   END IF

   #FUN-CB0011 add begin---
   SELECT COUNT(*) INTO l_cnt
     FROM gec_file
    WHERE gec011 = '2'
      And gec06 = '3'
      AND gecacti = 'Y'

   IF l_cnt = 0 THEN
      CALL cl_err('','alm2004',1)
      RETURN
   END IF
   #FUN-CB0011 add end-----

   IF NOT cl_confirm("alm-006") THEN
       RETURN
   END IF
#CHI-C30107 ------------ add ------------- end
   SELECT * INTO g_lps.* FROM lps_file WHERE lps01 = g_lps.lps01
   IF g_lps.lps09 = 'Y' THEN
      CALL cl_err(g_lps.lps01,'alm-005',1)
      RETURN
   END IF
   IF g_lps.lps09 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lps.lpsacti ='N' THEN
     CALL cl_err(g_lps.lps01,'alm-004',1)
     RETURN
   END IF

   SELECT lps13 INTO l_lps13 FROM lps_file
    WHERE lps01=g_lps.lps01
   IF l_lps13 != g_lps.lps07 THEN
      CALL cl_err(g_lps.lps01,'alm-191',1)
      RETURN
   END IF
#NO.FUN-A90040  ---begin -- mark   
#   IF g_lps.lps04 > 0 THEN
#      SELECT SUM(lpn04) INTO l_lpn04
#        FROM lpn_file
#       WHERE lpn01 = g_lps.lps01
 #     IF cl_null(l_lpn04) THEN LET l_lpn04 = 0 END IF
 #     IF l_lpn04 < g_lps.lps04 THEN
 #        CALL cl_err('','alm-686',1)
 #        RETURN
 #     END IF
#   END IF
 #NO.FUN-A90040  ---end -- mark 
    LET l_lps10 = g_lps.lps10
    LET l_lps11 = g_lps.lps11

    DROP TABLE t610_tmp1;
    CREATE TEMP TABLE t610_tmp1(
           lrt021  LIKE lpj_file.lpj03);
    CREATE UNIQUE INDEX t610_tmp1_01 ON t610_tmp1(lrt021);

#CHI-C30107 ----------- mark ----------- begin
#  IF NOT cl_confirm("alm-006") THEN
#      RETURN
#  END IF
#CHI-C30107 ----------- mark ----------- end
   #FUN-C10051 MARK sta---
   ##FUN-960141 Add
   #DROP TABLE x
   #SELECT * FROM npq_file WHERE 1=2 INTO TEMP x
   ##FUN-960141 End
   #FUN-C10051 MARK end---
   BEGIN WORK
   OPEN t610_cl USING g_lps.lps01
     
   IF STATUS THEN
      CALL cl_err("open t610_cl:",STATUS,1)
      CLOSE t610_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t610_cl INTO g_lps.*
   IF SQLCA.sqlcode  THEN
      CALL cl_err(g_lps.lps01,SQLCA.sqlcode,0)
      CLOSE t610_cl
      ROLLBACK WORK
      RETURN
   END IF

   LET g_success = 'Y'

   CALL t610_y_chk()
#FUN-C90085-----mark----str
#  IF g_success = 'Y' THEN 
#     LET l_rxy05a=NULL
#     LET l_rxy05b=NULL
#     LET l_rxy05c=NULL
#     SELECT SUM(rxy05) INTO l_rxy05a FROM rxy_file
#      WHERE rxy00='20' AND rxy01=g_lps.lps01
#        AND rxy03='01' AND rxy04='1'

#     SELECT SUM(rxy05) INTO l_rxy05b FROM rxy_file
#      WHERE rxy00='20' AND rxy01=g_lps.lps01
#        AND rxy03='02' AND rxy04='1'

#     SELECT SUM(rxy05) INTO l_rxy05c FROM rxy_file
#      WHERE rxy00='20' AND rxy01=g_lps.lps01
#        AND rxy03='03' AND rxy04='1'
#     IF cl_null(l_rxy05a) THEN
#        LET l_rxy05a=0
#     END IF
#     IF cl_null(l_rxy05b) THEN
#        LET l_rxy05b=0
#     END IF
#     IF cl_null(l_rxy05c) THEN
#        LET l_rxy05c=0
#     END IF
#     IF l_rxy05a !=0 THEN
#        INSERT INTO rxx_file(rxx00,rxx01,rxx02,rxx03,rxx04,rxx05,rxx11,rxxlegal,rxxplant)
#        VALUES ('20',g_lps.lps01,'01','1',l_rxy05a,'','',g_lps.lpslegal,g_lps.lpsplant)
#        IF SQLCA.sqlcode THEN                     #置入資料庫不成功
#           CALL cl_err3("ins","rxx_file",g_lps.lps01,"",SQLCA.sqlcode,"","",1)
#           LET g_success = 'N'
#        END IF
#     END IF
#     IF l_rxy05b !=0 THEN
#        INSERT INTO rxx_file(rxx00,rxx01,rxx02,rxx03,rxx04,rxx05,rxx11,rxxlegal,rxxplant) 
#        VALUES ('20',g_lps.lps01,'02','1',l_rxy05b,'','',g_lps.lpslegal,g_lps.lpsplant)
#        IF SQLCA.sqlcode THEN                     #置入資料庫不成功
#           CALL cl_err3("ins","rxx_file",g_lps.lps01,"",SQLCA.sqlcode,"","",1)
#           LET g_success = 'N'
#        END IF
#     END IF
#     IF l_rxy05c !=0 THEN
#        INSERT INTO rxx_file(rxx00,rxx01,rxx02,rxx03,rxx04,rxx05,rxx11,rxxlegal,rxxplant) 
#        VALUES ('20',g_lps.lps01,'03','1',l_rxy05c,'','',g_lps.lpslegal,g_lps.lpsplant)
#        IF SQLCA.sqlcode THEN                     #置入資料庫不成功
#           CALL cl_err3("ins","rxx_file",g_lps.lps01,"",SQLCA.sqlcode,"","",1)
#           LET g_success = 'N'
#        END IF
#     END IF
#  END IF    
#FUN-C90085-----mark----end
  #FUN-C10051 MARK sta---
  # #FUN-960141 add 
  # IF g_success = 'Y' THEN
  #    CALL s_card_in(g_lps.lps01,'1') RETURNING l_flag,l_oma01 
  #    IF NOT l_flag THEN
  #       LET g_success = 'N'
  #    END IF
  # END IF
  # #FUN-960141 end 
  #FUN-C10051 MARK end---     
  
  # IF g_success = 'Y' THEN
  #    CALL t610_y_chk()
  # END IF

   IF g_success = 'Y' THEN
#      LET g_lps.lps14 = l_oma01 #FUN-C10051 MARK
      LET g_lps.lps09 = 'Y'                                                                                                    
      LET g_lps.lps10 = g_user                                                                                                 
      LET g_lps.lps11 = g_today                                                                                                
      UPDATE lps_file                                                                                                          
         SET lps09 = g_lps.lps09,                                                                                              
             lps10 = g_lps.lps10,                                                                                              
             lps11 = g_lps.lps11 
#             lps14 = g_lps.lps14 #FUN-C10051 MARK
       WHERE lps01 = g_lps.lps01                                                                                                
                                                                                                                                    
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN                                                                            
         LET g_success = 'N'
         CALL cl_err('upd lps:',SQLCA.SQLCODE,0)                                                                               
         LET g_lps.lps09 = "N"                                                                                                 
         LET g_lps.lps10 = l_lps10                                                                                             
         LET g_lps.lps11 = l_lps11                                                                                             
         DISPLAY BY NAME g_lps.lps09,g_lps.lps10,g_lps.lps11 #,g_lps.lps14 #FUN-C10051 MARK
      ELSE                                                                                                                     
         DISPLAY BY NAME g_lps.lps09,g_lps.lps10,g_lps.lps11 #,g_lps.lps14 #FUN-C10051 MARK                                                                 
      END IF                                                                                                                   
   END IF
 #FUN-C10051 MARK   
 #  IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' AND g_success = 'Y' THEN
 #     SELECT * INTO g_oma.* FROM oma_file WHERE oma01=l_oma01
 #     LET l_wc_gl = 'npp01 = "',g_oma.oma01,'" AND npp011 = 1'
 #     LET g_str="axrp590 '",l_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' '",
 #               g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",
 #               g_oma.oma02,"' 'Y' '0' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"
         
 #     CALL cl_cmdrun_wait(g_str)
 #  END IF
 #FUN-C10051 MARK  
   #FUN-C10051 sta----
   SELECT rcj05,rcj06 INTO l_rcj05,l_rcj06 FROM rcj_file
   IF cl_null(l_rcj05) THEN 
      CALL cl_err('','alm1590',0)
      LET g_success = 'N'
   ELSE   
      IF cl_null(l_rcj06) THEN 
         CALL cl_err('','alm1591',0)
         LET g_success = 'N'
      END IF 
   END IF       
   INITIALIZE g_oga01 TO NULL
   IF g_success = 'Y' THEN
      IF g_lps.lps16 > 0 OR g_lps.lps05 > 0 THEN      #FUN-D30019 add
         CALL t610_ins_oga()
      ELSE                                            #FUN-D30019 add
         LET g_n = 0                                  #FUN-D30019 add
      END IF                                          #FUN-D30019 add
   END IF
   #FUN-C10051 end----
   IF g_success = 'Y' THEN 
      COMMIT WORK 
   ELSE
      ROLLBACK WORK 
      #FUN-C10051 sta---
      LET g_lps.lps09 = "N"                                                                                                 
      LET g_lps.lps10 = l_lps10                                                                                             
      LET g_lps.lps11 = l_lps11                                                                                             
      DISPLAY BY NAME g_lps.lps09,g_lps.lps10,g_lps.lps11
      #FUN-C10051 end---
     # RETURN 
   END IF 
   #FUN-C10051 STA---
   IF g_success = 'Y' AND g_n <> 0 THEN 
      SELECT * INTO g_oaz.* FROM oaz_file WHERE oaz00='0'
      CALL t600sub_y_chk(g_oga01, NULL) #CHI-C30118---add NULL				
      IF g_success = "Y" THEN				
         CALL t600sub_y_upd(g_oga01, NULL)
         SELECT ogaconf INTO l_ogaconf FROM oga_file WHERE oga01 = g_oga01
         IF l_ogaconf = 'Y' THEN     
            CALL t600sub_s('1', FALSE, g_oga01, FALSE)	
            SELECT ogapost INTO l_ogapost FROM oga_file WHERE oga01 = g_oga01
            IF l_ogapost = 'N' THEN 
               LET g_success = 'N'  
            END IF 
         ELSE
            LET g_success = 'N'
         END IF 
      END IF
      CALL t610_reconfirm()
   END IF    
   
   #FUN-C10051 END ---
   CLOSE t610_cl
END FUNCTION

FUNCTION t610_pic()
   CASE g_lps.lps09
      WHEN 'Y'  LET g_confirm = 'Y'
                LET g_void = ''
      WHEN 'N'  LET g_confirm = 'N'
                LET g_void = ''
      WHEN 'X'  LET g_confirm = 'N'  #CHI-C80041
                LET g_void = 'Y'     #CHI-C80041    
      OTHERWISE LET g_confirm = ''
                LET g_void = ''
   END CASE

   #圖形顯示
   CALL cl_set_field_pic(g_confirm,"","","",g_void,g_lps.lpsacti)
END FUNCTION

FUNCTION t610_y_chk()
 DEFINE l_lph33       LIKE lph_file.lph33 
 DEFINE l_lph34       LIKE lph_file.lph34
 DEFINE l_lpt         RECORD
          lpt02       LIKE lpt_file.lpt02,
          lpt021      LIKE lpt_file.lpt021,
          lpt03       LIKE lpt_file.lpt03,
          lpt15       LIKE lpt_file.lpt15,
          lpt09       LIKE lpt_file.lpt09,
          lpt10       LIKE lpt_file.lpt10,  #TQC-C30223 add
          lpt11       LIKE lpt_file.lpt11,
          lpt17       LIKE lpt_file.lpt17,  #TQC-C30223 add
          lpt14       LIKE lpt_file.lpt14
         # lpt16       LIKE lpt_file.lpt16  #FUN-C30049 MARK
                      END RECORD 

   CALL s_showmsg_init()
   DELETE FROM t610_tmp4

   DECLARE lpt_cs_y CURSOR FOR 
    #SELECT lpt02,lpt021,lpt03,lpt15,lpt09,lpt11,lpt14,lpt16 #FUN-C30049 MARK  
    SELECT lpt02,lpt021,lpt03,lpt15,lpt09,lpt10,lpt11,lpt17,lpt14 #FUN-C30049  add  #TQC-C30223 add lpt10 lpt12
      FROM lpt_file
     WHERE lpt01 = g_lps.lps01
     ORDER BY lpt02
   
   LET g_cnt = 1
   
   FOREACH lpt_cs_y INTO l_lpt.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       DELETE FROM t610_tmp1 
       SELECT lph33,lph34 INTO l_lph33,l_lph34
         FROM lph_file
        WHERE lph01 = l_lpt.lpt03
       CALL t610_gen_coupon_no(l_lph33,l_lph34,l_lpt.lpt02,l_lpt.lpt021,1)

       LET g_sql = " UPDATE lpj_file SET lpj09 = '2',lpj01 = ? , ",
                   "                     lpj06 = ? ,lpj11 = ? ,lpj05 = ?, ",
                   "                     lpj17 = ? ,lpj04 = ? , ",
                   "                     lpjpos = '2' ",       #FUN-D30007 add
                   "  WHERE EXISTS (SELECT 'X' FROM t610_tmp1 ",
                   "                 WHERE lrt021 = lpj03) "
       PREPARE t610_ry1 FROM g_sql
      #EXECUTE t610_ry1 USING l_lpt.lpt15,l_lpt.lpt09,l_lpt.lpt11,l_lpt.lpt14,  #TQC-C30223 mark
      #EXECUTE t610_ry1 USING l_lpt.lpt15,l_lpt.lpt10,l_lpt.lpt11,l_lpt.lpt14,  #TQC-C30223 add   #CHI-C90026 mark 
       EXECUTE t610_ry1 USING l_lpt.lpt15,l_lpt.lpt09,l_lpt.lpt11,l_lpt.lpt14,  #CHI-C90026 add
                              g_lps.lpsplant,g_today
       IF SQLCA.sqlcode THEN
          CALL s_errmsg('','','UPDATE lpj_file',SQLCA.sqlcode,1)
          LET g_success = 'N'
       END IF

       IF l_lpt.lpt09 > 0 THEN
         #FUN-BA0068 mark START
         #LET g_sql = " INSERT INTO lsn_file (lsn01,lsn02,lsn03,lsn04,lsn05,lsn06,lsn07,lsn08)",#No.FUN-A70118
         #            " SELECT lrt021,'3','",g_lps.lps01,"',",l_lpt.lpt09,
         #            " ,'",g_today,"',?,",l_lpt.lpt11,",'",g_lps.lpsplant,"'", #No.FUN-A70118
         #            "   FROM t610_tmp1 "
         #FUN-BA0068 mark END
      #FUN-BA0068 add START
         #LET g_sql = " INSERT INTO lsn_file (lsn01,lsn02,lsn03,lsn04,lsn05,lsn06,lsn07,lsn09,lsnlegal,lsnplant,lsn10)",#No.FUN-A70118  #TQC-C30223 add lsn09 #FUN-C70045 ADD lsn10   #FUN-C90102 mark 
          LET g_sql = " INSERT INTO lsn_file (lsn01,lsn02,lsn03,lsn04,lsn05,lsn06,lsn07,lsn09,lsnlegal,lsnstore,lsn10)", #FUN-C90102 add
                     #" SELECT lrt021,'3','",g_lps.lps01,"',",l_lpt.lpt09,  #TQC-C30223 mark 
                     #" SELECT lrt021,'3','",g_lps.lps01,"',",l_lpt.lpt10,  #TQC-C30223 add  #FUN-C70045 mark 
                     #" SELECT lrt021,'2','",g_lps.lps01,"',",l_lpt.lpt10,  #FUN-C70045 add  #CHI-C90026 mark 
                      " SELECT lrt021,'2','",g_lps.lps01,"',",l_lpt.lpt09,  #CHI-C90026  add
          #           " ,'",g_today,"',?,",l_lpt.lpt11,",'",g_lps.lpslegal,"','",g_lps.lpsplant,"'", #No.FUN-A70118 #FUN-C30049 MARK
                      " ,'",g_today,"','',",l_lpt.lpt11,",",l_lpt.lpt17,",'",g_lps.lpslegal,"','",g_lps.lpsplant,"','1'", #FUN-C30049 add  #TQC-C30223 add lpt17  #FUN-C70045 add '1'
                      "   FROM t610_tmp1 "
      #FUN-BA0068 add END
          PREPARE t610_ry2 FROM g_sql
          #EXECUTE t610_ry2 USING l_lpt.lpt16  #FUN-C30049 MARK
          EXECUTE t610_ry2 #FUN-C30049 add
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('','','ins lsn_file',SQLCA.sqlcode,1)
             LET g_success = 'N'
          END IF
       END IF

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL s_showmsg()
END FUNCTION

#FUN-C90085------mark-----str
#FUNCTION t610_cash()
# DEFINE p_cmd         LIKE type_file.chr1,
#        l_amt         LIKE lps_file.lps05
# DEFINE l_rxy05       LIKE rxy_file.rxy05
# DEFINE l_rxy01       LIKE rxy_file.rxy01
# DEFINE l_rxy02       LIKE rxy_file.rxy02
## DEFINE l_lma04       LIKE rtz_file.lma04    #FUN-A80148
# DEFINE l_azw07       LIKE azw_file.azw07     #FUN-A80148 
# DEFINE l_lps13       LIKE lps_file.lps13
# DEFINE l_time        LIKE rxy_file.rxy22 #No.FUN-A80008
#
#    IF g_lps.lps01 IS NULL THEN
#        CALL cl_err('',-400,0)
#        RETURN
#    END IF
#    
#   IF g_lps.lps09 = 'Y' THEN
#      CALL cl_err(g_lps.lps01,'alm-005',1)
#      RETURN
#   END IF
#       
#   OPEN WINDOW t6101_w WITH FORM "alm/42f/almt6101"
#       ATTRIBUTE (STYLE = g_win_style CLIPPED)
#   CALL cl_ui_locale("almt6101")
#   LET l_rxy05 = NULL
#   LET l_rxy01 = NULL
#   LET l_rxy02 = NULL
#   LET l_rxy01 = g_lps.lps01
#
#   IF g_lps.lps08='Y' THEN
#        CALL cl_err('','9023',1)
#        RETURN
#        close WINDOW t6101_w
#   END IF
#
#   SELECT lps13 INTO l_lps13 FROM lps_file WHERE lps01=g_lps.lps01
#   IF cl_null(l_lps13) THEN
#      LET l_lps13=0
#   END IF
#   LET l_amt=g_lps.lps07-l_lps13
#   IF l_amt<0 THEN 
#      LET l_amt=0
#   END IF 
#
##TQC-B60231 - ADD - BEGIN -------------------------------
#   LET l_rxy05 = l_amt
#   DISPLAY l_rxy05 TO rxy05
##TQC-B60231 - ADD -  END  -------------------------------
#
#   DISPLAY l_amt TO FORMONLY.amt
##  INPUT l_rxy05 FROM rxy05                  #TQC-B60231 MARK
#   INPUT l_rxy05 WITHOUT DEFAULTS FROM rxy05 #TQC-B60231 ADD
#
#   AFTER FIELD rxy05
#     IF NOT cl_null(l_rxy05) THEN
#        IF l_rxy05<=0 THEN
#           CALL cl_err('rxy05','alm-192',1)
#           NEXT FIELD rxy05
#        END IF
#        IF l_rxy05+l_lps13>g_lps.lps07 THEN
#           CALL cl_err('','alm-199',1)
#           NEXT FIELD rxy05
#        END IF
#     END IF
#
#   AFTER INPUT
#     IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         LET l_rxy05=NULL
#         EXIT INPUT
#     END IF
#
#      ON ACTION CONTROLR
#      CALL cl_show_req_fields()
#
#      ON ACTION CONTROLG
#         CALL cl_cmdask()
#
#      ON ACTION CONTROLF                        # 欄位說明
#         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
#         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
#
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
#
#   END INPUT
#
#   IF cl_null(l_rxy05) THEN  #放棄
#      CLOSE WINDOW t6101_w
#      RETURN
#   END IF
#
#   SELECT MAX(rxy02) INTO l_rxy02 FROM rxy_file WHERE rxy00='20' AND rxy01= l_rxy01
#   IF l_rxy02 IS NULL THEN
#      LET l_rxy02=0
#   END IF
#   LET l_rxy02=l_rxy02+1
#   LET l_time = TIME #No.FUN-A80008
#   INSERT INTO rxy_file(rxy00,rxy01,rxy02,rxy03,rxy04,rxy05,rxylegal,rxyplant,rxy21,rxy22)
#  #VALUES('20',l_rxy01,l_rxy02,'01','1',l_rxy05,g_lps.lpslegal,g_lps.lpsplant,g_today,to_char(sysdate,'HH24:MI'))
#   VALUES('20',l_rxy01,l_rxy02,'01','1',l_rxy05,g_lps.lpslegal,g_lps.lpsplant,g_today,l_time) #No.FUN-A80008
#   IF SQLCA.sqlcode THEN
#       CALL cl_err3("ins","rxy_file",l_rxy01,"",SQLCA.sqlcode,"","",0)
#    END IF
#
#    IF cl_null(l_rxy05) THEN
#      LET l_rxy05=0
#    END IF
#    LET l_lps13=l_lps13+l_rxy05
#    UPDATE lps_file SET lps13=l_lps13
#                    WHERE lps01=g_lps.lps01
#    IF SQLCA.sqlcode THEN
#       CALL cl_err3("upd","lps_file",g_lps_t.lps01,"",SQLCA.sqlcode,"","",1)
#    END IF
#   CLOSE WINDOW t6101_w
#END FUNCTION
#FUN-C90085------mark-----end

FUNCTION t610_lps13()

   SELECT * INTO g_lps.* FROM lps_file WHERE lps01 = g_lps.lps01
   CALL t610_show()
END FUNCTION

FUNCTION t610_rxy()

   IF cl_null(g_lps.lps01) THEN
      CALL cl_err('',-400,1)
   END IF

   SELECT * INTO g_lps.* FROM lps_file WHERE lps01=g_lps.lps01

   IF g_lps.lps04 <= 0 OR cl_null(g_lps.lps04) THEN
      CALL cl_err('','alm-726',0)
      RETURN
   END IF

   OPEN WINDOW t5701_w WITH FORM "alm/42f/almt5701"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_locale("almt5701")
   CALL t610_b_fill2()
   
   WHILE TRUE
      CALL t610_bp2("G")
      CASE g_action_choice

         WHEN "detail"
             IF cl_chk_act_auth() THEN
                CALL t610_b2()
             ELSE
                LET g_action_choice = NULL
             END IF
             
         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

          WHEN "related_document"
            IF cl_chk_act_auth() AND l_ac2 != 0 THEN
               IF g_lpn[l_ac2].lpn02 IS NOT NULL THEN
                  LET g_doc.column1 = "lpn02"
                  LET g_doc.value1 = g_lpn[l_ac2].lpn02
                  CALL cl_doc()
               END IF
            END IF

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lpn),'','')
            END IF
      END CASE
   END WHILE
   CLOSE WINDOW t5701_w
END FUNCTION

FUNCTION t610_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lpn TO s_lpn.* ATTRIBUTE(COUNT=g_rec_b2)

   BEFORE ROW
       LET l_ac2 = ARR_CURR()
       CALL cl_show_fld_cont()

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac2=1
         EXIT DISPLAY
         
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac2 = ARR_CURR()
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

       ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t610_b2()
DEFINE
   l_ac2_t          LIKE type_file.num5,
   l_n             LIKE type_file.num5,
   l_n1            LIKE type_file.num5,
   l_lock_sw       LIKE type_file.chr1,
   p_cmd           LIKE type_file.chr1,
   l_allow_insert  LIKE type_file.chr1,
   l_allow_delete  LIKE type_file.chr1
   
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
   
   IF cl_null(g_lps.lps01) THEN 
      CALL cl_err('','alm-344',1)
      RETURN
   END IF 
   
   IF g_lps.lpsacti='N' THEN 
      CALL cl_err('','alm-345',1)
      RETURN
   END IF 
   
   IF g_lps.lps09 = 'Y' THEN 
      CALL cl_err('','alm-346',1)
      RETURN
   END IF
   IF g_lps.lps09 = 'X' THEN RETURN END IF  #CHI-C80041
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')

   LET g_forupd_sql = "SELECT lpn02,lpn03,'',lpn04,'','','','','','','','','','','','','' ",
                      "  FROM lpn_file WHERE lpn01='",g_lps.lps01,"' ",
                      "   and lpn02 = ? and lpn03= ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t610_bcl2 CURSOR FROM g_forupd_sql      # LOCK CURSOR

   INPUT ARRAY g_lpn WITHOUT DEFAULTS FROM s_lpn.*
     ATTRIBUTE (COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,
                APPEND ROW=l_allow_insert)

       BEFORE INPUT
          IF g_rec_b2 != 0 THEN
             CALL fgl_set_arr_curr(l_ac2)
          END IF

       BEFORE ROW
          LET p_cmd=''
          LET l_ac2 = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()

          IF g_rec_b2>=l_ac2 THEN
             BEGIN WORK
             LET p_cmd='u'
             LET g_before_input_done = FALSE
             LET g_before_input_done = TRUE
             LET g_lpn_t.* = g_lpn[l_ac2].*  #BACKUP
             OPEN t610_bcl2 USING g_lpn_t.lpn02,g_lpn_t.lpn03
             IF STATUS THEN
                CALL cl_err("OPEN t610_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH t610_bcl2 INTO g_lpn[l_ac2].* 
                CALL t610_lpn03()
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_lpn_t.lpn02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont()     
          END IF
       
       BEFORE INSERT 
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          LET g_before_input_done = FALSE
          LET g_before_input_done = TRUE
          INITIALIZE g_lpn[l_ac2].* TO NULL
          LET g_lpn_t.* = g_lpn[l_ac2].*         #新輸入資料
          CALL cl_show_fld_cont()        
          NEXT FIELD lpn02

       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE t610_bcl2
             CANCEL INSERT
          END IF
          INSERT INTO lpn_file(lpn01,lpn02,lpn03,lpnlegal,lpnplant,lpn04)
          VALUES(g_lps.lps01,g_lpn[l_ac2].lpn02,g_lpn[l_ac2].lpn03,
                 g_lps.lpslegal,g_lps.lpsplant,g_lpn[l_ac2].lpn04)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lpn_file",g_lpn[l_ac2].lpn02,"",SQLCA.sqlcode,"","",1)
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b2=g_rec_b2+1
             DISPLAY g_rec_b2 TO FORMONLY.cn2
             COMMIT WORK
          END IF

       AFTER FIELD lpn02
          IF NOT cl_null(g_lpn[l_ac2].lpn02) THEN
             IF p_cmd='a' OR
                (p_cmd='u' AND g_lpn[l_ac2].lpn02 !=g_lpn_t.lpn02) THEN
               #CALL t610_lpn02()  #FUN-C10001 mark
                SELECT COUNT(*) INTO l_n FROM lpn_file
                 WHERE lpn01=g_lps.lps01
                   AND lpn02=g_lpn[l_ac2].lpn02
                   AND lpn03=g_lpn[l_ac2].lpn03
                IF l_n>0 AND cl_null(g_errno) THEN
                   LET g_errno='alm-348'
                END IF
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,1)
                   LET g_lpn[l_ac2].lpn02 = g_lpn_t.lpn02
                   NEXT FIELD lpn02
                END IF
             END IF  
          END IF
             
       AFTER FIELD lpn03
          IF NOT cl_null(g_lpn[l_ac2].lpn03) THEN 
             IF cl_null(g_lpn[l_ac2].lpn02) THEN
                CALL cl_err('','alm-349',1)
                NEXT FIELD lpn03
             END IF 
             IF p_cmd='a' OR 
                (p_cmd='u' AND g_lpn[l_ac2].lpn03 !=g_lpn_t.lpn03) THEN
                CALL t610_lpn03()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,1)
                   LET g_lpn[l_ac2].lpn03 = g_lpn_t.lpn03
                   NEXT FIELD lpn03
                END IF 
                SELECT COUNT(*) INTO l_n1 FROM lpn_file 
                 WHERE lpn01=g_lps.lps01
                   AND lpn02=g_lpn[l_ac2].lpn02
                   AND lpn03=g_lpn[l_ac2].lpn03
                IF l_n1>0 THEN 
                   CALL cl_err('','alm-348',1)
                   LET g_lpn[l_ac2].lpn03 = g_lpn_t.lpn03
                   NEXT FIELD lpn03
                END IF
             END IF 
          END IF        
                                
       BEFORE DELETE                            #是否取消單身
          IF g_lpn_t.lpn02 IS NOT NULL AND g_lpn_t.lpn03 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM lpn_file WHERE lpn01 = g_lps.lps01
                                    AND lpn02=g_lpn_t.lpn02
                                    AND lpn03=g_lpn_t.lpn03
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lpn_file",g_lpn_t.lpn02,"",SQLCA.sqlcode,"","",1)
                EXIT INPUT
             END IF
             LET g_rec_b2=g_rec_b2-1
             DISPLAY g_rec_b2 TO FORMONLY.cn2
             COMMIT WORK
          END IF

       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_lpn[l_ac2].* = g_lpn_t.*
             CLOSE t610_bcl2
             ROLLBACK WORK
             EXIT INPUT
          END IF

          IF l_lock_sw="Y" THEN
             CALL cl_err(g_lpn[l_ac2].lpn02,-263,0)
             LET g_lpn[l_ac2].* = g_lpn_t.*
          ELSE  
             UPDATE lpn_file SET lpn02=g_lpn[l_ac2].lpn02,
                                 lpn03=g_lpn[l_ac2].lpn03,
                                 lpn04=g_lpn[l_ac2].lpn04
              WHERE lpn01 = g_lps.lps01
                AND lpn02 = g_lpn_t.lpn02
                AND lpn03 = g_lpn_t.lpn03
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","lpn_file",g_lpn_t.lpn02,"",SQLCA.sqlcode,"","",1)
                LET g_lpn[l_ac2].* = g_lpn_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF 
             
       AFTER ROW
          LET l_ac2 = ARR_CURR()
         #LET l_ac2_t = l_ac2     #FUN-D30033 Mark
       
          IF INT_FLAG THEN                 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN 
                LET g_lpn[l_ac2].* = g_lpn_t.*
             #FUN-D30033--add--str--
             ELSE
                CALL g_lpn.deleteElement(l_ac2)
                IF g_rec_b2 != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac2 = l_ac2_t
                END IF
             #FUN-D30033--add--end--
             END IF
             CLOSE t610_bcl2
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac2_t = l_ac2     #FUN-D30033 Add
          CLOSE t610_bcl2
          COMMIT WORK

      ON ACTION controlp
         CASE
            WHEN INFIELD(lpn02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_rxy"
               LET g_qryparam.default1 = g_lpn[l_ac2].lpn02
               CALL cl_create_qry() RETURNING g_lpn[l_ac2].lpn02
               DISPLAY BY NAME g_lpn[l_ac2].lpn02
               NEXT FIELD lpn02
          END CASE

       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(lpn02) AND l_ac2 > 1 THEN
             LET g_lpn[l_ac2].* = g_lpn[l_ac2-1].*
             NEXT FIELD lpn02
          END IF
          
       ON ACTION CONTROLR
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
         
      ON ACTION about
         CALL cl_about()
               
      ON ACTION help
         CALL cl_show_help()
   END INPUT
   CLOSE t610_bcl2
   COMMIT WORK
END FUNCTION 
#FUN-C10001 mark START
#FUNCTION t610_lpn02()
#DEFINE l_n    LIKE type_file.num5
#DEFINE l_lra05 LIKE lra_file.lra05
#      
#  LET g_errno=''
#  SELECT COUNT(*)
#    INTO l_n
#    FROM rxy_file
#   WHERE rxy00 = '23'
#     AND rxy01 =g_lpn[l_ac2].lpn02

#  IF l_n =0 THEN 
#     LET g_errno='alm-353'
#  END IF
#  SELECT lra05 INTO l_lra05 FROM lra_file,rxy_file
#   WHERE rxy31 = lra01
#     AND rxy00 = '23'
#     AND rxy01 = g_lpn[l_ac2].lpn02
#  IF NOT cl_null(l_lra05) THEN
#     LET g_errno = 'alm-702'
#  END IF
#END FUNCTION
#FUN-C10001 mark END

FUNCTION t610_lpn03()
   DEFINE l_rxy05   LIKE rxy_file.rxy05
   DEFINE l_rxy03   LIKE rxy_file.rxy03
   DEFINE l_rxy06   LIKE rxy_file.rxy06
   DEFINE l_rxy07   LIKE rxy_file.rxy07
   DEFINE l_rxy08   LIKE rxy_file.rxy08
   DEFINE l_rxy09   LIKE rxy_file.rxy09
   DEFINE l_rxy10   LIKE rxy_file.rxy10
   DEFINE l_rxy11   LIKE rxy_file.rxy11
   DEFINE l_rxy12   LIKE rxy_file.rxy12
   DEFINE l_rxy13   LIKE rxy_file.rxy13
   DEFINE l_rxy14   LIKE rxy_file.rxy14
   DEFINE l_rxy15   LIKE rxy_file.rxy15
   DEFINE l_rxy16   LIKE rxy_file.rxy16
   DEFINE l_rxy17   LIKE rxy_file.rxy17
   DEFINE l_rxy20   LIKE rxy_file.rxy20
   DEFINE p_cmd     LIKE type_file.chr1

   LET g_errno=''

   SELECT rxy03,rxy05,rxy06,rxy07,rxy08,rxy09,rxy10,rxy11,rxy12,rxy13,
          rxy14,rxy15,rxy16,rxy17,rxy20
     INTO l_rxy03,l_rxy05,l_rxy06,l_rxy07,l_rxy08,l_rxy09,l_rxy10,l_rxy11,
          l_rxy12,l_rxy13,l_rxy14,l_rxy15,l_rxy16,l_rxy17,l_rxy20
     FROM rxy_file
    WHERE rxy00 = '23'
      AND rxy01 =g_lpn[l_ac2].lpn02
      AND rxy02 =g_lpn[l_ac2].lpn03
    CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-350'
        OTHERWISE               LET g_errno=SQLCA.SQLCODE USING '-------'
    END CASE 
      LET g_lpn[l_ac2].rxy03=l_rxy03
      LET g_lpn[l_ac2].lpn04=l_rxy05
      LET g_lpn[l_ac2].rxy06=l_rxy06
      LET g_lpn[l_ac2].rxy07=l_rxy07
      LET g_lpn[l_ac2].rxy08=l_rxy08
      LET g_lpn[l_ac2].rxy09=l_rxy09
      LET g_lpn[l_ac2].rxy10=l_rxy10
      LET g_lpn[l_ac2].rxy11=l_rxy11
      LET g_lpn[l_ac2].rxy12=l_rxy12
      LET g_lpn[l_ac2].rxy13=l_rxy13
      LET g_lpn[l_ac2].rxy14=l_rxy14
      LET g_lpn[l_ac2].rxy15=l_rxy15
      LET g_lpn[l_ac2].rxy16=l_rxy16
      LET g_lpn[l_ac2].rxy17=l_rxy17 
      LET g_lpn[l_ac2].rxy20=l_rxy20 
      DISPLAY BY NAME g_lpn[l_ac2].rxy03,g_lpn[l_ac2].lpn04,g_lpn[l_ac2].rxy06,g_lpn[l_ac2].rxy07,
      g_lpn[l_ac2].rxy08,g_lpn[l_ac2].rxy09,g_lpn[l_ac2].rxy10,
      g_lpn[l_ac2].rxy11,g_lpn[l_ac2].rxy12,g_lpn[l_ac2].rxy13,
      g_lpn[l_ac2].rxy14,g_lpn[l_ac2].rxy15,g_lpn[l_ac2].rxy16,
      g_lpn[l_ac2].rxy17,g_lpn[l_ac2].rxy20
END FUNCTION

FUNCTION t610_b_fill2()
    LET g_sql = 
        "SELECT lpn02,lpn03,'',lpn04,'','','','','','','','','','','','',''",
        " FROM lpn_file ",
        " WHERE ", g_wc2 CLIPPED,        #單身
        " and lpn01= '",g_lps.lps01,"' ",
        " ORDER BY lpn02,lpn03"
    PREPARE t610_pb2 FROM g_sql 
    DECLARE lpn_curs2 CURSOR FOR t610_pb2
    
    CALL g_lpn.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"  
    FOREACH lpn_curs2 INTO g_lpn[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT rxy03,rxy06,rxy20,rxy07,rxy08,rxy09,rxy10,rxy11,rxy12,rxy13,rxy14,
               rxy15,rxy16,rxy17
          INTO g_lpn[g_cnt].rxy03,g_lpn[g_cnt].rxy06,g_lpn[g_cnt].rxy20,
               g_lpn[g_cnt].rxy07,g_lpn[g_cnt].rxy08,g_lpn[g_cnt].rxy09,g_lpn[g_cnt].rxy10,
               g_lpn[g_cnt].rxy11,g_lpn[g_cnt].rxy12,g_lpn[g_cnt].rxy13,g_lpn[g_cnt].rxy14,
               g_lpn[g_cnt].rxy15,g_lpn[g_cnt].rxy16,g_lpn[g_cnt].rxy17
          FROM rxy_file
         WHERE rxy00='23'
           AND rxy01=g_lpn[g_cnt].lpn02
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN 
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_lpn.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
#FUN-B90118 add START----------------------------------------------
FUNCTION t610_i560()
   DEFINE l_cmd           LIKE type_file.chr1000
   DEFINE l_wc            STRING
   IF l_ac IS NULL OR l_ac < 1 THEN
      RETURN
   END IF
   IF l_ac > 0 AND cl_null(g_lpt[l_ac].lpt15) AND g_action_choice = "member_data" THEN  #FUN-B90118 add ' AND g_action_choice = "member_data" '
      RETURN
   END IF
   IF cl_null(g_f2) OR g_f2 <> 'Y' THEN  #CHI-C30021 add
      IF cl_null(g_lpt[l_ac].lpt15) THEN
         LET l_wc = 'N'
         #LET l_cmd = ' almi560 "',g_lpt[l_ac].lpt15,'" "',l_wc,'" ' #CHI-C30021 MARK 
         CALL i560(g_lpt[l_ac].lpt15,'N',TRUE) RETURNING g_lpt[l_ac].lpt15  #CHI-C30021 add
      ELSE
         #LET l_cmd = ' almi560 "',g_lpt[l_ac].lpt15,'"' #CHI-C30021 MARK 
         CALL i560(g_lpt[l_ac].lpt15,'',TRUE) #CHI-C30021 add
      END IF
   END IF    #CHI-C30021 add
   IF g_f2 = 'Y' THEN
      LET l_cmd = ' almi560 "',g_lpt[l_ac].lpt15,'" "',g_f2,'" ' 
      CALL cl_cmdrun(l_cmd CLIPPED)  #CHI-C30021 add 
   END IF
   #CALL cl_cmdrun(l_cmd CLIPPED) #CHI-C30021 MARK 
   LET g_f2 = ''
END FUNCTION
#FUN-B90118 add END------------------------------------------------
#No.FUN-960134

#FUN-C10051 sta --------
FUNCTION t610_ins_oga()
DEFINE l_oga       RECORD LIKE oga_file.*
DEFINE li_result   LIKE type_file.num10
DEFINE l_tmoga01   LIKE oga_file.oga01 #TQC-C90124 Add

   INITIALIZE l_oga.* TO NULL #TQC-C90124 Add

   #insert into oga_file-----
   LET l_oga.oga00 = '1'                 #出貨別
   LET l_oga.oga02 = g_lps.lps03         #出貨日期 
   LET l_oga.oga06 = '0'                 #修改版本
   LET l_oga.oga07 = 'N'                 #出貨是否計入未開發票的銷貨待驗收入
   LET l_oga.oga08 = '1'                 #1.內銷 2.外銷  3.視同外銷
   LET l_oga.oga09 = '2'                 #單據別
  #TQC-C90124 Add Begin ---
   LET l_oga.oga14 = g_user              #業務人員
   LET l_oga.oga15 = g_grup              #業務部門
  #TQC-C90124 Add End -----
   LET l_oga.oga161 = 0                  #訂金應收比率
  #LET l_oga.oga162 = 0                  #出貨應收比率    #No.TQC-C20565   Mark
   LET l_oga.oga162 = 100                #出貨應收比率    #No.TQC-C20565   Add
   LET l_oga.oga163 = 0                  #尾款應收比率   
   LET l_oga.oga30 = 'N'                 #包裝單確認碼 
   LET l_oga.oga52 = 0                   #原幣預收訂金轉銷貨收入金額
   LET l_oga.oga53 = 0                   #原幣應開發票未稅金額 
   LET l_oga.oga54 = 0                   #原幣已開發票未稅金額
   LET l_oga.oga55 = '1'                 #狀況碼
   LET l_oga.oga57 = '1'                 #發票性質
   LET l_oga.oga65 = 'N'                 #客戶出貨簽收否
   LET l_oga.oga69 = g_today             #輸入日期
   LET l_oga.oga83 = g_lps.lpsplant      #銷貨營運中心 
   LET l_oga.oga84 = g_lps.lpsplant      #取貨營運中心
   LET l_oga.oga85 = '1'                 #結算方式
   LET l_oga.oga903 = 'N'                #信用查核放行否
   LET l_oga.oga94 = 'N'                 #POS銷售否 Y-是,N-否
   LET l_oga.oga95 = '0'                 #本次積分 
   LET l_oga.ogacond = g_today           #審核日期
   LET l_oga.ogaconf = 'N'               #確認否/作廢碼
   LET l_oga.ogagrup = g_user            #資料所有部門 
   LET l_oga.ogalegal = g_lps.lpslegal   #所屬法人
   LET l_oga.ogaorig = g_grup            #資料建立部門
   LET l_oga.ogaoriu = g_user            #資料建立者
   LET l_oga.ogaplant = g_lps.lpsplant   #所屬營運中心
   LET l_oga.ogapost = 'N'               #出貨扣帳否
   LET l_oga.ogaprsw = 0                 #列印次數
   LET l_oga.ogauser = g_user            #資料所有者
   LET l_oga.ogaslk02 = '1'
   LET l_oga.oga1014 = 'N'               #调货销退单所自动产生否   #TQC-C90016 add

   #出貨單號	自動產生出貨單號, 預設單號抓取 aooi410 的設定
   #FUN-C90050 mark begin---
   #SELECT rye03 INTO l_oga.oga01 FROM rye_file
   # WHERE rye01 = 'axm' AND rye02 = '50'
   #FUN-C90050 mark end-----

   CALL s_get_defslip('axm','50',g_plant,'N') RETURNING l_oga.oga01   #FUN-C90050 add

   CALL s_auto_assign_no("axm",l_oga.oga01,g_today,"","oga_file","oga01","","","") 
     RETURNING li_result,l_oga.oga01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN
   END IF
   IF cl_null(l_oga.oga01) THEN
      LET g_success='N'
      RETURN
   END IF

  #TQC-C90124 Add Begin ---
   LET l_tmoga01 = l_oga.oga01
   LET l_tmoga01 = l_tmoga01[1,g_doc_len]
   SELECT oayapr INTO l_oga.ogamksg FROM oay_file
    WHERE oayslip = l_tmoga01
  #TQC-C90124 Add End -----

   #帳款客戶編號,arti200 門店對應散客代號
   SELECT rtz06 INTO l_oga.oga03 FROM rtz_file
    WHERE rtz01 = g_plant
   IF cl_null(l_oga.oga03) THEN 
      CALL cl_err('','alm1594',0)
      LET g_success = 'N'
      RETURN 
   END IF     
   #帳款客戶簡稱	散客代號對應客戶基本資料檔簡稱
   SELECT occ02 INTO l_oga.oga032 FROM occ_file 
    WHERE occ01 = l_oga.oga03 
   LET l_oga.oga04 = l_oga.oga03         #送貨客戶編號  
   LET l_oga.oga18 = l_oga.oga03         #收款客戶編號
   #取帳款客戶對應客戶主檔預設稅別,幣別,銷售分類一,價格條件,收款條件
   SELECT occ41,occ42,occ43,occ44,occ45 INTO 
     l_oga.oga21,l_oga.oga23,l_oga.oga25,l_oga.oga31,l_oga.oga32
     FROM occ_file
    WHERE occ01 = l_oga.oga03
   #取稅別對應稅率,聯數,含稅否
   SELECT gec04,gec05,gec07 INTO l_oga.oga211,l_oga.oga212,l_oga.oga213
     FROM gec_file
    WHERE gec01 = l_oga.oga21
      AND gec011 = '2'
   #匯率
   CALL s_currm(l_oga.oga23,l_oga.oga02,g_oaz.oaz52,g_plant)
     RETURNING l_oga.oga24
   #insert into ogb---
   LET g_n = 0
   CALL t610_insert_ogb(l_oga.oga01,l_oga.oga211,l_oga.oga213,l_oga.oga23,l_oga.oga21)  #TQC-C30223 add oga21
   IF g_n = 0 THEN 
      RETURN 
   END IF    
   IF g_success = 'N' THEN 
      RETURN
   END IF
   #----
   SELECT SUM(ogb14) INTO l_oga.oga50 FROM ogb_file
    WHERE ogb01 = l_oga.oga01
   SELECT SUM(ogb14t) INTO l_oga.oga51 FROM ogb_file
    WHERE ogb01 = l_oga.oga01 
    #MOD-D70070 add begin-------
    IF g_azw.azw04 = '2' THEN 
       LET l_oga.oga53=l_oga.oga50 * (l_oga.oga162 + l_oga.oga163) / 100
    END IF   
    #MOD-D70070 add end---------    
   INSERT INTO oga_file VALUES l_oga.*
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("ins","oga_file",l_oga.oga01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   ELSE
      LET g_oga01 = l_oga.oga01   
   END IF 
   CALL t610_insert_rx(l_oga.oga01) 

END FUNCTION 
FUNCTION t610_insert_ogb(l_oga01,l_gec04,l_gec07,l_azi01,l_oga21)  #TQC-C30223 add oga21
DEFINE l_lpt08   LIKE lpt_file.lpt08
DEFINE l_lpt10   LIKE lpt_file.lpt10
DEFINE l_lpt12   LIKE lpt_file.lpt12
DEFINE l_lpt15   LIKE lpt_file.lpt15
DEFINE l_oga01   LIKE oga_file.oga01
DEFINE l_gec04   LIKE gec_file.gec04
DEFINE l_gec07   LIKE gec_file.gec07
DEFINE l_azi01   LIKE azi_file.azi01
DEFINE t_azi04   LIKE azi_file.azi04
DEFINE l_oga21   LIKE oga_file.oga21  #TQC-C30223 add
DEFINE l_ogb   RECORD LIKE ogb_file.*
DEFINE l_rxc   RECORD LIKE rxc_file.*
DEFINE l_oga14   LIKE oga_file.oga14  #FUN-CB0087
DEFINE l_oga15   LIKE oga_file.oga15  #FUN-CB0087


   INITIALIZE l_ogb.* TO NULL #TQC-C90124 Add

   SELECT azi04 INTO t_azi04 FROM azi_file
    WHERE azi01= l_azi01
   LET g_sql = "SELECT lpt08,lpt10,lpt12,lpt15 from lpt_file",
               " WHERE lpt01 = '",g_lps.lps01,"'"

   PREPARE t610_ogb_pb FROM g_sql
   DECLARE t610_ogb_cl CURSOR FOR t610_ogb_pb               
   FOREACH t610_ogb_cl INTO l_lpt08,l_lpt10,l_lpt12,l_lpt15
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

      LET l_ogb.ogb01 = l_oga01            #出貨單號
      LET l_ogb.ogb04 = 'MISCCARD'         #產品編號
      LET l_ogb.ogb05 = 'PCS'              #銷售單位
      LET l_ogb.ogb05_fac = 1              #銷售/庫存彙總單位換算率 
      LET l_ogb.ogb08 = g_lps.lpsplant     #出貨營運中心編號
      LET l_ogb.ogb091 = ' '               #出貨儲位編號
      LET l_ogb.ogb092 = ' '               #出貨批號 
      LET l_ogb.ogb1005 = '1'              #作業方式
      LET l_ogb.ogb1006 = '100'            #折扣率
      LET l_ogb.ogb1012 = 'N'              #搭贈
      LET l_ogb.ogb1014 = 'N'              #保稅已放行否
      LET l_ogb.ogb12 = '1'                #實際出貨數量 
      LET l_ogb.ogb15_fac = 1              #銷售/庫存明細單位換算率
      LET l_ogb.ogb16 = 1                  #數量
      LET l_ogb.ogb17 = 'N'                #多倉儲批出貨否
      LET l_ogb.ogb18 = '0'                #預計出貨數量 
      LET l_ogb.ogb19 = 'N'                #檢驗否
      LET l_ogb.ogb44 = '1'                #經營方式
      LET l_ogb.ogb60 = 0                  #已開發票數量
      LET l_ogb.ogb63 = 0                  #銷退數量
      LET l_ogb.ogb64 = 0                  #銷退數量
      LET l_ogb.ogb916 = 'PCS'             #計價單位
      LET l_ogb.ogb917 = 1                 #計價單位 
      LET l_ogb.ogb930 = s_costcenter(g_grup) #成本中心 #TQC-C90124 Add
      LET l_ogb.ogblegal = g_lps.lpslegal  #所屬法人
      LET l_ogb.ogbplant = g_lps.lpsplant  #所屬法人
      #FUN-C90049 mark begin---
      #SELECT rtz07 INTO l_ogb.ogb09 FROM rtz_file
      # WHERE rtz01 = g_plant 
      #FUN-C90049 mark end-----
      CALL s_get_coststore(g_plant,l_ogb.ogb04) RETURNING l_ogb.ogb09   #FUN-C90049 add
      
     # IF l_lpt08 > 0 THEN #TQC-C30009 MARK
       IF l_lpt08 >= 0 THEN #TQC-C30009 ad 
         SELECT MAX(ogb03)+1 INTO l_ogb.ogb03 FROM ogb_file 
          WHERE ogb01 = l_oga01
         IF l_ogb.ogb03 IS NULL THEN 
            LET l_ogb.ogb03 = 1       #項次
         END IF
         #原因碼
         SELECT rcj05 INTO l_ogb.ogb1001 FROM rcj_file
         LET l_ogb.ogb13 = l_lpt08    #原幣單價
         IF l_gec07 = 'Y' THEN
            LET l_ogb.ogb14 = l_lpt08 / (1 + l_gec04/100)  #原幣未稅金額
            LET l_ogb.ogb14t = l_lpt08                 #原幣含稅金額
            CALL cl_digcut(l_ogb.ogb14,t_azi04) RETURNING l_ogb.ogb14
         ELSE
            LET l_ogb.ogb14 = l_lpt08
            LET l_ogb.ogb14t = l_lpt08 * (1 + l_gec04/100)
            CALL cl_digcut(l_ogb.ogb14t,t_azi04) RETURNING l_ogb.ogb14t
         END IF 
         LET l_ogb.ogb37 = l_lpt08   #基礎單价  
         LET l_ogb.ogb47 = 0         #分攤折價=全部折價欄位值的合計
         #FUN-C50097 ADD BEGIN-----
         IF cl_null(l_ogb.ogb50) THEN 
           LET l_ogb.ogb50 = 0
         END IF 
         IF cl_null(l_ogb.ogb51) THEN 
           LET l_ogb.ogb51 = 0
         END IF 
         IF cl_null(l_ogb.ogb52) THEN 
           LET l_ogb.ogb52 = 0
         END IF                                      
         IF cl_null(l_ogb.ogb53) THEN 
           LET l_ogb.ogb53 = 0
         END IF 
         IF cl_null(l_ogb.ogb54) THEN 
           LET l_ogb.ogb54 = 0
         END IF 
         IF cl_null(l_ogb.ogb55) THEN 
           LET l_ogb.ogb55 = 0
         END IF
         #FUN-C50097 ADD END-------
         #FUN-CB0087--add--str--
         IF g_aza.aza115 = 'Y' THEN
            SELECT oga14,oga15 INTO l_oga14,l_oga15 FROM oga_file WHERE oga01 = l_ogb.ogb01
            CALL s_reason_code(l_ogb.ogb01,l_ogb.ogb31,'',l_ogb.ogb04,l_ogb.ogb09,l_oga14,l_oga15) RETURNING l_ogb.ogb1001
            IF cl_null(l_ogb.ogb1001) THEN
               CALL cl_err(l_ogb.ogb1001,'aim-425',1)
               LET g_success="N"
               RETURN
            END IF
         END IF
         #FUN-CB0087--add--end--
         INSERT INTO ogb_file VALUES l_ogb.*
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err3("ins","ogb_file",l_oga01,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            RETURN 
         ELSE 
            LET g_n = g_n + 1   
         END IF  
         CALL t610_ins_ogi('1',l_ogb.ogb01,l_ogb.ogb03,l_oga21,l_gec04,l_gec07,l_ogb.ogb12,l_ogb.ogb13)  #TQC-C30223 add  新增單身稅別明細
      END IF  
     # IF l_lpt10 > 0 THEN #TQC-C30009 MARK
      IF l_lpt10 >=0 THEN #TQC-C30009 add
         SELECT MAX(ogb03)+1 INTO l_ogb.ogb03 FROM ogb_file 
          WHERE ogb01 = l_oga01
         IF l_ogb.ogb03 IS NULL THEN 
            LET l_ogb.ogb03 = 1       #項次
         END IF
         IF l_lpt12 > 0 THEN 
            LET l_rxc.rxc00 = '02'             #單據別
            LET l_rxc.rxc01 = l_oga01          #單號 
            LET l_rxc.rxc02 = l_ogb.ogb03      #項次 
            LET l_rxc.rxc03 = '20'             #折價方式
            LET l_rxc.rxc04 = g_lps.lps01      #來源單號
            LET l_rxc.rxc06 = l_lpt12          #折價金額
            LET l_rxc.rxc07 = 0                #廠商促銷分攤比例
            LET l_rxc.rxc09 = 0                #返券金額
            LET l_rxc.rxc10 = 0                #廠商返券分攤比例
            LET l_rxc.rxclegal = g_legal       #所屬法人
            LET l_rxc.rxcplant = g_plant       #所屬營運中心 
            LET l_rxc.rxc15 = 0                #數量-參加促銷的數量
            IF NOT cl_null(l_lpt15) THEN  
               LET l_rxc.rxc11 = 'Y'           #是否會員
            ELSE
               LET l_rxc.rxc11 = 'N'
            END IF 
            INSERT INTO rxc_file VALUES l_rxc.*
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN 
               CALL cl_err3("ins","rxc_file",l_oga01,"",SQLCA.sqlcode,"","",1)
               LET g_success = 'N'
               RETURN 
            END IF     
         END IF
         #原因碼
         SELECT rcj06 INTO l_ogb.ogb1001 FROM rcj_file
         LET l_ogb.ogb13 = l_lpt10 - l_lpt12    #原幣單價
        #TQC-C30223 mark START
        #不論客戶是含稅或未稅,皆已含稅價計算
        #IF l_gec07 = 'Y' THEN
        #   LET l_ogb.ogb14 = l_ogb.ogb13 / (1 + l_gec04/100)  #原幣未稅金額
        #   LET l_ogb.ogb14t = l_ogb.ogb13                 #原幣含稅金額
        #   CALL cl_digcut(l_ogb.ogb14,t_azi04) RETURNING l_ogb.ogb14
        #ELSE
        #   LET l_ogb.ogb14 = l_ogb.ogb13
        #   LET l_ogb.ogb14t = l_ogb.ogb13 * (1 + l_gec04/100)
        #   CALL cl_digcut(l_ogb.ogb14t,t_azi04) RETURNING l_ogb.ogb14t
        #END IF 
        #TQC-C30223 mark END     
         LET l_ogb.ogb14t = l_ogb.ogb13  #TQC-C30223 add
         LET l_ogb.ogb14 = l_ogb.ogb13   #TQC-C30223 add
         LET l_ogb.ogb37 = l_lpt10   #基礎單价  
         LET l_ogb.ogb47 = l_lpt12         #分攤折價=全部折價欄位值的合計
         #FUN-C50097 ADD BEGIN-----
         IF cl_null(l_ogb.ogb50) THEN 
           LET l_ogb.ogb50 = 0
         END IF 
         IF cl_null(l_ogb.ogb51) THEN 
           LET l_ogb.ogb51 = 0
         END IF 
         IF cl_null(l_ogb.ogb52) THEN 
           LET l_ogb.ogb52 = 0
         END IF                                      
         IF cl_null(l_ogb.ogb53) THEN 
           LET l_ogb.ogb53 = 0
         END IF 
         IF cl_null(l_ogb.ogb54) THEN 
           LET l_ogb.ogb54 = 0
         END IF 
         IF cl_null(l_ogb.ogb55) THEN 
           LET l_ogb.ogb55 = 0
         END IF
         #FUN-C50097 ADD END-------
         #FUN-CB0087--add--str--
         IF g_aza.aza115 = 'Y' THEN
            SELECT oga14,oga15 INTO l_oga14,l_oga15 FROM oga_file WHERE oga01 = l_ogb.ogb01
            #TQC-D20062--mod--str--
            #CALL s_reason_code(l_ogb.ogb01,l_ogb.ogb31,'',l_ogb.ogb04,l_ogb.ogb09,l_oga14,l_oga15) RETURNING l_ogb.ogb65
            #IF cl_null(l_ogb.ogb65) THEN
            #   CALL cl_err(l_ogb.ogb65,'aim-425',1)
            CALL s_reason_code(l_ogb.ogb01,l_ogb.ogb31,'',l_ogb.ogb04,l_ogb.ogb09,l_oga14,l_oga15) RETURNING l_ogb.ogb1001
            IF cl_null(l_ogb.ogb1001) THEN
               CALL cl_err(l_ogb.ogb1001,'aim-425',1)
            #TQC-D20062--mod--end--
               LET g_success="N"
               RETURN
            END IF
         END IF
         #FUN-CB0087--add--end--
         INSERT INTO ogb_file VALUES l_ogb.*
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err3("ins","ogb_file",l_oga01,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            RETURN 
         ELSE 
            LET g_n = g_n + 1   
         END IF  
         CALL t610_ins_ogi('2',l_ogb.ogb01,l_ogb.ogb03,l_oga21,l_gec04,l_gec07,l_ogb.ogb12,l_ogb.ogb13)  #TQC-C30223 add  新增單身稅別明細
      END IF 
      INITIALIZE l_ogb.* TO NULL #TQC-C90124 Add
   END FOREACH    
END FUNCTION 

FUNCTION t610_insert_rx(l_oga01)
DEFINE l_oga01     LIKE oga_file.oga01
DEFINE l_rxy03_01  RECORD LIKE rxy_file.*
DEFINE l_rxy03_02  RECORD LIKE rxy_file.*
DEFINE l_rxy03_03  RECORD LIKE rxy_file.*
DEFINE l_rxx03_01  RECORD LIKE rxx_file.*
DEFINE l_rxx03_02  RECORD LIKE rxx_file.*
DEFINE l_rxx03_03  RECORD LIKE rxx_file.*
DEFINE l_rxz       RECORD LIKE rxz_file.*
DEFINE l_sql       STRING                 #TQC-C90075 add
  #TQC-C90075 mark str---
  #SELECT * INTO l_rxy03_01.*
  #  FROM rxy_file
  # WHERE rxy00 = '20'
  #   AND rxy01 = g_lps.lps01
  #   AND rxy03 = '01'
  #   AND rxy04 = '1'
  #TQC-C90075 mark end---
  #TQC-C90075 add str---
   LET l_sql =" SELECT * FROM rxy_file ",
              "  WHERE rxy00 = '20' ",
              "    AND rxy01 = '",g_lps.lps01,"' ",
              "    AND rxy03 = '01' ",
              "    AND rxy04 = '1'  "
   PREPARE rxy_pre1 FROM l_sql
   DECLARE rxy_cs1 CURSOR FOR rxy_pre1
   FOREACH rxy_cs1 INTO l_rxy03_01.*
  #TQC-C90075 add end---
  #IF NOT cl_null(l_rxy03_01.rxy00) THEN  #TQC-C90075 mark 
      LET l_rxy03_01.rxy00 = '02'
      LET l_rxy03_01.rxy01 = l_oga01
      INSERT INTO rxy_file VALUES l_rxy03_01.*
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN 
         CALL cl_err3("ins","rxy_file",l_oga01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN 
      END IF
   END FOREACH                            #TQC-C90075 add  
      SELECT * INTO l_rxx03_01.*
        FROM rxx_file
       WHERE rxx00 = '20'
         AND rxx01 = g_lps.lps01
         AND rxx02 = '01'
         AND rxx03 = '1'
      IF NOT cl_null(l_rxx03_01.rxx00) THEN 
         LET l_rxx03_01.rxx00 = '02'
         LET l_rxx03_01.rxx01 = l_oga01 
         INSERT INTO rxx_file VALUES l_rxx03_01.*
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN 
            CALL cl_err3("ins","rxx_file",l_oga01,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            RETURN 
         END IF 
      END IF 
  #END IF                                    #TQC-C90075 mark

  # ---------
  #TQC-C90075 mark str---
  #SELECT * INTO l_rxy03_02.*
  #  FROM rxy_file
  # WHERE rxy00 = '20'
  #   AND rxy01 = g_lps.lps01
  #   AND rxy03 = '02'
  #   AND rxy04 = '1'
  #TQC-C90075 mark end---
  #TQC-C90075 add str---
   LET l_sql = " SELECT * FROM rxy_file ",
               "  WHERE rxy00 = '20' ",
               "    AND rxy01 = '",g_lps.lps01,"' ",
               "    AND rxy03 = '02' ",
               "    AND rxy04 = '1' "
   PREPARE rxy_pre2 FROM l_sql
   DECLARE rxy_cs2 CURSOR FOR rxy_pre2
   FOREACH rxy_cs2 INTO l_rxy03_02.*
  #TQC-C90075 add end---
  #IF NOT cl_null(l_rxy03_02.rxy00) THEN         #TQC-C90075 mark 
      LET l_rxy03_02.rxy00 = '02'
      LET l_rxy03_02.rxy01 = l_oga01
      INSERT INTO rxy_file VALUES l_rxy03_02.*
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN 
         CALL cl_err3("ins","rxy_file",l_oga01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN 
      END IF
   END FOREACH                               #TQC-C90075 add
      SELECT * INTO l_rxx03_02.*
        FROM rxx_file
       WHERE rxx00 = '20'
         AND rxx01 = g_lps.lps01
         AND rxx02 = '02'
         AND rxx03 = '1'
      IF NOT cl_null(l_rxx03_02.rxx00) THEN 
         LET l_rxx03_02.rxx00 = '02'
         LET l_rxx03_02.rxx01 = l_oga01 
         INSERT INTO rxx_file VALUES l_rxx03_02.* 
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN 
            CALL cl_err3("ins","rxx_file",l_oga01,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            RETURN 
         END IF 
      END IF
     #TQC-C90075 mark str---
     #SELECT * INTO l_rxz.*
     #  FROM rxz_file
     # WHERE rxz00 = '20'
     #   AND rxz01 = g_lps.lps01
     #TQC-C90075 mark end---
     #TQC-C90075 add str---
      LET l_sql = "SELECT * FROM rxz_file ",
                  " WHERE rxz00 = '20' ",
                  "   AND rxz01 = '",g_lps.lps01,"' "
      PREPARE rxz_pre FROM l_sql
      DECLARE rxz_cs CURSOR FOR rxz_pre
      FOREACH rxz_cs INTO l_rxz.*
     #TQC-C90075 add end---
      IF NOT cl_null(l_rxz.rxz00) THEN 
         LET l_rxz.rxz00 = '02'
         LET l_rxz.rxz01 = l_oga01 
         INSERT INTO rxz_file VALUES l_rxz.*
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN 
            CALL cl_err3("ins","rxz_file",l_oga01,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            RETURN 
         END IF 
      END IF 
      END FOREACH                           #TQC-C90075 add 
  #END IF                             #TQC-C90075 mark

   #------------
  #TQC-C90075 mark str--- 
  #SELECT * INTO l_rxy03_03.*
  #  FROM rxy_file
  # WHERE rxy00 = '20'
  #   AND rxy01 = g_lps.lps01
  #   AND rxy03 = '03'
  #   AND rxy04 = '1'
  #TQC-C90075 mark end---
  #TQC-C90075 add str---
   LET l_sql = " SELECT * FROM rxy_file ",
               "  WHERE rxy00 = '20' ",
               "    AND rxy01 = '",g_lps.lps01,"' ",
               "    AND rxy03 = '03' ",
               "    AND rxy04 = '1' "
   PREPARE rxy_pre3 FROM l_sql
   DECLARE rxy_cs3 CURSOR FOR rxy_pre3
   FOREACH rxy_cs3 INTO l_rxy03_03.*
  #TQC-C90075 add end---
  #IF NOT cl_null(l_rxy03_03.rxy00) THEN          #TQC-C90075 mark 
      LET l_rxy03_03.rxy00 = '02'
      LET l_rxy03_03.rxy01 = l_oga01
      INSERT INTO rxy_file VALUES l_rxy03_03.*
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN 
         CALL cl_err3("ins","rxy_file",l_oga01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN 
      END IF    
   END FOREACH                              #TQC-C90075 add
      SELECT * INTO l_rxx03_03.*
        FROM rxx_file
       WHERE rxx00 = '20'
         AND rxx01 = g_lps.lps01
         AND rxx02 = '03'
         AND rxx03 = '1'
      IF NOT cl_null(l_rxx03_03.rxx00) THEN 
         LET l_rxx03_03.rxx00 = '02'
         LET l_rxx03_03.rxx01 = l_oga01 
         INSERT INTO rxx_file VALUES l_rxx03_03.*
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN 
            CALL cl_err3("ins","rxx_file",l_oga01,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            RETURN 
         END IF 
      END IF 
  #END IF                        #TQC-C90075 mark
END FUNCTION
 
FUNCTION t610_reconfirm()
DEFINE l_lpj03   LIKE lpj_file.lpj03
DEFINE l_lpj09   LIKE lpj_file.lpj09
DEFINE l_lph33       LIKE lph_file.lph33 
DEFINE l_lph34       LIKE lph_file.lph34
DEFINE l_lpt         RECORD
          lpt02       LIKE lpt_file.lpt02,
          lpt021      LIKE lpt_file.lpt021,
          lpt03       LIKE lpt_file.lpt03,
          lpt15       LIKE lpt_file.lpt15,
          lpt09       LIKE lpt_file.lpt09,
          lpt10       LIKE lpt_file.lpt10,
          lpt11       LIKE lpt_file.lpt11,
          lpt17       LIKE lpt_file.lpt17,  
          lpt14       LIKE lpt_file.lpt14
                      END RECORD

      DECLARE lpt_cs_y_2 CURSOR FOR 
       SELECT lpt02,lpt021,lpt03,lpt15,lpt09,lpt10,lpt11,lpt17,lpt14 
         FROM lpt_file
        WHERE lpt01 = g_lps.lps01
        ORDER BY lpt02
   
      LET g_cnt = 1
      DELETE FROM t610_tmp1
      FOREACH lpt_cs_y_2 INTO l_lpt.*
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF

          
          SELECT lph33,lph34 INTO l_lph33,l_lph34
            FROM lph_file
           WHERE lph01 = l_lpt.lpt03
          CALL t610_gen_coupon_no(l_lph33,l_lph34,l_lpt.lpt02,l_lpt.lpt021,1)                

          LET g_cnt = g_cnt + 1
          IF g_cnt > g_max_rec THEN
             CALL cl_err( '', 9035, 0 )
             EXIT FOREACH
          END IF
      END FOREACH

                      
   BEGIN WORK 
   IF g_success = 'Y' THEN 
      UPDATE lps_file SET lps17 = g_oga01 WHERE lps01 = g_lps.lps01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN 
         LET g_success = 'N'
         CALL cl_err('upd lps:',SQLCA.SQLCODE,0) 
         LET g_lps.lps17 = NULL 
         DISPLAY BY NAME g_lps.lps17
      ELSE
         LET g_lps.lps17 = g_oga01
         DISPLAY BY NAME g_lps.lps17    #FUN-CA0160 Add lps18
      END IF  
   END IF    
      
   IF g_success = 'N' THEN 
      IF NOT cl_null(g_lps.lps17) AND g_lps.lps09 = 'Y' THEN 
         CALL cl_err('','alm1582',0)
         RETURN 
      END IF 
      DELETE FROM oga_file WHERE oga01 = g_oga01
      DELETE FROM ogb_file WHERE ogb01 = g_oga01
      DELETE FROM rxc_file WHERE rxc00 = '02' AND rxc01 = g_oga01
                                              AND rxc03 = '20'
      DELETE FROM rxy_file WHERE rxy00 = '02' AND rxy01 = g_oga01
                                              AND rxy03 IN ('01','02','03')
                                              AND rxy04 = '1'  
      DELETE FROM rxx_file WHERE rxx00 = '02' AND rxx01 = g_oga01
                                              AND rxx02 IN ('01','02','03')
                                              AND rxx03 = '1'
      DELETE FROM rxz_file WHERE rxz00 = '02' AND rxz01 = g_oga01

     #FUN-C0085---mark---str
     #DELETE FROM rxx_file WHERE rxx00 = '20' AND rxx01 = g_lps.lps01
     #                                        AND rxx02 IN ('01','02','03')
     #                                        AND rxx03 = '1'   
     #FUN-C0085---mark---end
      DELETE FROM ogi_file WHERE ogi01 = g_oga01  #MOD-C70005 add 
      DELETE FROM ogh_file WHERE ogh01 = g_oga01 #FUN-C90007 add
      
      LET g_sql = 'SELECT lpj03,lpj09 FROM t610_tmp1'
      DECLARE t610_temp2 CURSOR FROM g_sql
      FOREACH t610_temp2 INTO l_lpj03,l_lpj09
         IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         UPDATE lpj_file
            SET lpj09 = l_lpj09,
                lpj01 = '',
                lpj06 = 0,
                lpj11 = 0,
                lpj05 = '',
                lpj17 = '',
                lpj04 = '',
                lpjpos = '2'    #FUN-D30007 add 
          WHERE lpj03 = l_lpj03
      END FOREACH       
#     DELETE FROM lsn_file WHERE lsn02 = '3' AND lsn03 = g_lps.lps01                   #FUN-C70045 mark
      DELETE FROM lsn_file WHERE lsn02 = '2' AND lsn10 = '1' AND lsn03 = g_lps.lps01   #FUN-C70045 add
      UPDATE lps_file 
         SET lps09 = 'N',
             lps10 = '',
             lps11 = ''
       WHERE lps01 = g_lps.lps01   
      LET g_lps.lps09 = 'N'
      LET g_lps.lps10 = ''
      LET g_lps.lps11 = ''
      DISPLAY BY NAME g_lps.lps09,g_lps.lps10,g_lps.lps11   
   END IF
   COMMIT WORK 
END FUNCTION  
#FUN-C10051 end --------
#FUN-9C0084
#TQC-C30223 add START
#新增單身稅別明細
FUNCTION t610_ins_ogi(p_type,p_ogi01,p_ogi02,p_ogi04,p_ogi05,p_ogi07,p_ogb12,p_ogb13)
DEFINE p_type              LIKE type_file.chr1  #1.售卡  2.儲值
DEFINE p_ogi01             LIKE ogi_file.ogi01  #單號
DEFINE p_ogi02             LIKE ogi_file.ogi02  #項次
DEFINE p_ogi04             LIKE ogi_file.ogi04  #稅別
DEFINE p_ogi05             LIKE ogi_file.ogi05  #稅率
DEFINE p_ogi07             LIKE ogi_file.ogi07  #含稅否
DEFINE p_ogb12             LIKE ogb_file.ogb12  #數量
DEFINE p_ogb13             LIKE ogb_file.ogb13  #原幣單價
DEFINE l_ogi    RECORD     LIKE ogi_file.*
DEFINE l_sql               STRING
DEFINE l_rte08             LIKE rte_file.rte08
DEFINE l_rtz04             LIKE rtz_file.rtz04
DEFINE l_rvy05             LIKE rvy_file.rvy05

   SELECT MAX(ogi03) INTO l_ogi.ogi03 FROM ogi_file
      WHERE ogi01 = l_ogi.ogi01
   IF cl_null(l_ogi.ogi03) OR l_ogi.ogi03 = 0 THEN
      LET l_ogi.ogi03 = 1
   ELSE
      LET l_ogi.ogi03 = l_ogi.ogi03 + 1
   END IF

   LET l_ogi.ogi01 = p_ogi01
   LET l_ogi.ogi02 = p_ogi02
   IF p_type = '1' THEN
      LET l_ogi.ogi04 = p_ogi04
      LET l_ogi.ogi05 = p_ogi05
   ELSE 
      SELECT MAX(gec01) INTO l_ogi.ogi04 
        FROM gec_file
          WHERE gec06 = '3'
            AND gec011 = '2'
            AND gecacti = 'Y'
      LET l_ogi.ogi05 = 0   
   END IF

   LET l_ogi.ogi06 = 0
   LET l_ogi.ogi08 = 0
   LET l_ogi.ogi07 = p_ogi07

   IF p_type = '1' THEN 
      IF l_ogi.ogi07 = 'Y' THEN
         LET l_ogi.ogi08t = p_ogb12 * p_ogb13 
         LET l_ogi.ogi08 = l_ogi.ogi08t / (1 + l_ogi.ogi05/100)  #原幣未稅金額
         CALL cl_digcut(l_ogi.ogi08,t_azi04) RETURNING l_ogi.ogi08 
      ELSE
         LET l_ogi.ogi08  = p_ogb12 * p_ogb13
         LET l_ogi.ogi08t = l_ogi.ogi08 * (1 + l_ogi.ogi05/100)
         CALL cl_digcut(l_ogi.ogi08t,t_azi04) RETURNING l_ogi.ogi08t
      END IF
   ELSE 
      LET l_ogi.ogi08t = p_ogb12 * p_ogb13
      LET l_ogi.ogi08  = p_ogb12 * p_ogb13
   END IF

   LET l_ogi.ogi09 = l_ogi.ogi08t - l_ogi.ogi08 
   LET l_ogi.ogidate = g_today
   LET l_ogi.ogigrup = g_grup
   LET l_ogi.ogimodu = g_user
   LET l_ogi.ogiuser = g_user
   LET l_ogi.ogioriu = g_user
   LET l_ogi.ogiorig = g_grup
   LET l_ogi.ogiplant = g_plant
   LET l_ogi.ogilegal = g_legal
   INSERT INTO ogi_file VALUES(l_ogi.*)
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','',l_ogi.ogi01,SQLCA.sqlcode,1)
      LET g_success="N"
   END IF
END FUNCTION

#TQC-C30223 add END


#FUN-C90007 add sta

FUNCTION t610_undo_confirm()
  DEFINE l_lps10         LIKE lps_file.lps10
  DEFINE l_lps11         LIKE lps_file.lps11
  DEFINE amt             LIKE lps_file.lps05
  DEFINE l_lps13         LIKE lps_file.lps13
  DEFINE l_rxy05a        LIKE rxy_file.rxy05
  DEFINE l_rxy05b        LIKE rxy_file.rxy05
  DEFINE l_rxy05c        LIKE rxy_file.rxy05
  DEFINE l_flag          LIKE type_file.chr1     
  DEFINE l_wc_gl         LIKE type_file.chr1000  
  DEFINE l_oma01         LIKE oma_file.oma01     
  DEFINE l_lpn04         LIKE lpn_file.lpn04
  DEFINE l_cnt           LIKE type_file.num5
  DEFINE l_forupd_sql    STRING
  DEFINE l_lpt09         LIKE lpt_file.lpt09 #FUN-C30177 add

   IF cl_null(g_lps.lps01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_lps.* FROM lps_file WHERE lps01 = g_lps.lps01
   IF g_lps.lps09 = 'N' THEN
      CALL cl_err(g_lps.lps01,'alm-007',1)
      RETURN
   END IF
   IF g_lps.lps09 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lps.lpsacti ='N' THEN
     CALL cl_err(g_lps.lps01,'alm-004',1)
     RETURN
   END IF

  #FUN-CA0160 Add Begin ---
   IF NOT cl_null(g_lps.lps18) THEN
      CALL cl_err(g_lps.lps18,'alm1638',1) #POS單據不可取消確認
      RETURN
   END IF
  #FUN-CA0160 Add End -----

#FUN-C30177---add---START
#儲值金額 = 0時才可以進行取消確認動作
   SELECT SUM(lpt09) INTO l_lpt09  FROM lpt_file WHERE lpt01 = g_lps.lps01  
   IF l_lpt09 <> 0  THEN
      CALL cl_err('','alm1646',1) 
      RETURN      
   END IF
#FUN-C30177---add-----END

   SELECT * INTO g_oaz.* FROM oaz_file WHERE oaz00='0' 
   LET l_lps10 = g_lps.lps10
   LET l_lps11 = g_lps.lps11

   DROP TABLE t610_tmp1;
   CREATE TEMP TABLE t610_tmp1(
          lrt021  LIKE lpj_file.lpj03);
   CREATE UNIQUE INDEX t610_tmp1_01 ON t610_tmp1(lrt021);
   LET l_forupd_sql = "SELECT * FROM oga_file WHERE oga01 = ? FOR UPDATE "
   LET l_forupd_sql=cl_forupd_sql(l_forupd_sql)

   DECLARE t610_cl1 CURSOR FROM l_forupd_sql
   LET g_success = 'Y' 
   #檢查單身卡有沒有消費記錄（check lpj_file，lsm_file，lsn_file），
   #對應出貨單有沒有產生應收，否則不能取消審核   
   CALL t610_undo_chk()    
   IF g_success = 'N' THEN 
      RETURN
   END IF   
   IF NOT cl_confirm("alm-008") THEN
      RETURN
   END IF   

   IF g_lps.lps16 > 0 OR g_lps.lps05 > 0 THEN   #FUN-D30050 add
      CALL t610_z()
   END IF                                       #FUN-D30050 add
   IF g_success = 'N' THEN
      CALL t610_lps13()
      RETURN
   END IF 
   CALL s_showmsg_init()
   BEGIN WORK
   OPEN t610_cl USING g_lps.lps01
     
   IF STATUS THEN
      CALL cl_err("open t610_cl:",STATUS,1)
      CLOSE t610_cl
      LET g_success = 'N'
   END IF
   FETCH t610_cl INTO g_lps.*
   IF SQLCA.sqlcode  THEN
      CALL cl_err(g_lps.lps01,SQLCA.sqlcode,0)
      CLOSE t610_cl
      LET g_success = 'N'
   END IF

   IF g_success = 'Y' THEN 
      
      UPDATE lpj_file SET lpj09 = '1',lpj01 = '' ,
                          lpj06 = 0 ,lpj11 = 0 ,lpj05 = '',
                          lpj17 = '' ,lpj04 = '' ,
                          lpjpos = '2'            #FUN-D30007 add
       WHERE EXISTS (SELECT 'X' FROM t610_tmp1 
                      WHERE lrt021 = lpj03) 

      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('','','UPDATE lpj_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      DELETE FROM lsn_file 
       WHERE EXISTS (SELECT 'X' FROM t610_tmp1 
                      WHERE lrt021 = lsn01)   
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','del lsn_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      DELETE FROM oga_file WHERE oga01 = g_lps.lps17
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','del oga_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      DELETE FROM ogb_file WHERE ogb01 = g_lps.lps17
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','del ogb_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      DELETE FROM ogh_file WHERE ogh01 = g_lps.lps17
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','del ogh_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF        
      DELETE FROM ogi_file WHERE ogi01 = g_lps.lps17
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','del ogi_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF      
      DELETE FROM rxc_file WHERE rxc00 = '02' AND rxc01 = g_lps.lps17
                                              AND rxc03 = '20'
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','del rxc_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF                                               
      DELETE FROM rxy_file WHERE rxy00 = '02' AND rxy01 = g_lps.lps17
                                              AND rxy03 IN ('01','02','03')
                                              AND rxy04 = '1'  
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','del rxy_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF                                               
      DELETE FROM rxx_file WHERE rxx00 = '02' AND rxx01 = g_lps.lps17
                                              AND rxx02 IN ('01','02','03')
                                              AND rxx03 = '1'
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','del rxx_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF                                               
      DELETE FROM rxz_file WHERE rxz00 = '02' AND rxz01 = g_lps.lps17
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','del rxz_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF 
     #FUN-C90085---mark---str
     #DELETE FROM rxx_file WHERE rxx00 = '20' AND rxx01 = g_lps.lps01
     #                                        AND rxx02 IN ('01','02','03')
     #                                        AND rxx03 = '1'
     #IF SQLCA.sqlcode THEN
     #   CALL s_errmsg('','','del rxx_file',SQLCA.sqlcode,1)
     #   LET g_success = 'N'
     #END IF                 
     #FUN-C90085---mark---end                              
   END IF 
   IF g_success = 'Y' THEN 
      UPDATE lps_file 
         SET lps09 = 'N',
      #      lps10 = '',      #CHI-D20015 mark
      #      lps11 = '',      #CHI-D20015 mark
             lps10 = g_user,  #CHI-D20015
             lps11 = g_today, #CHI-D20015
             lps17 = ''
       WHERE lps01 = g_lps.lps01   
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('','','UPDATE lps_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      ELSE 
         LET g_lps.lps09 = 'N'
      #  LET g_lps.lps10 = ''
      #  LET g_lps.lps11 = ''
         LET g_lps.lps10 = g_user 
         LET g_lps.lps11 = g_today 
         LET g_lps.lps17 = ''
         DISPLAY BY NAME g_lps.lps09,g_lps.lps10,g_lps.lps11,g_lps.lps17    
         CALL t610_pic()
      END IF    
   END IF 

   IF g_success = 'Y'THEN 
      COMMIT WORK
   ELSE 
      ROLLBACK WORK
      CALL s_showmsg()
   END IF    
   IF g_success = 'N' THEN 
      CALL t600sub_s('1', FALSE, g_lps.lps17, FALSE)	
      CALL t610_lps13()
   END IF 
   
END FUNCTION 


FUNCTION t610_undo_chk()
 DEFINE l_lph33       LIKE lph_file.lph33 
 DEFINE l_lph34       LIKE lph_file.lph34
 DEFINE l_lpt         RECORD
          lpt02       LIKE lpt_file.lpt02,
          lpt021      LIKE lpt_file.lpt021,
          lpt03       LIKE lpt_file.lpt03,
          lpt15       LIKE lpt_file.lpt15,
          lpt09       LIKE lpt_file.lpt09,
          lpt10       LIKE lpt_file.lpt10,
          lpt11       LIKE lpt_file.lpt11,
          lpt17       LIKE lpt_file.lpt17,  
          lpt14       LIKE lpt_file.lpt14
                      END RECORD 
 DEFINE l_oga10       LIKE oga_file.oga10 
 DEFINE l_cnt         LIKE type_file.num5 

   DECLARE lpt_cs_y_1 CURSOR FOR 
     SELECT lpt02,lpt021,lpt03,lpt15,lpt09,lpt10,lpt11,lpt17,lpt14 
      FROM lpt_file
     WHERE lpt01 = g_lps.lps01
     ORDER BY lpt02
   
   LET g_cnt = 1
   DELETE FROM t610_tmp1
   FOREACH lpt_cs_y_1 INTO l_lpt.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       SELECT lph33,lph34 INTO l_lph33,l_lph34
         FROM lph_file
        WHERE lph01 = l_lpt.lpt03
       CALL t610_gen_coupon_no(l_lph33,l_lph34,l_lpt.lpt02,l_lpt.lpt021,1)                

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH

   SELECT COUNT(*) INTO l_cnt FROM lpj_file 
    WHERE EXISTS (SELECT 'X' FROM t610_tmp1 
                   WHERE lrt021 = lpj03)     
      AND (lpj07 > 0 OR lpj09 <> '2' )
   IF l_cnt > 0 THEN 
      CALL cl_err('','alm1991',0)
      LET g_success = 'N'
      RETURN 
   END IF 
   SELECT COUNT(*) INTO l_cnt FROM lsm_file 
    WHERE EXISTS (SELECT 'X' FROM t610_tmp1
                   WHERE lrt021 = lsm01)
   IF l_cnt > 0 THEN 
      CALL cl_err('','alm1992',0)
      LET g_success = 'N'
      RETURN 
   END IF                       
   SELECT COUNT(*) INTO l_cnt FROM lsn_file
    WHERE EXISTS ( SELECT 'X' FROM t610_tmp1
                    WHERE lrt021 = lsn01)
      AND lsn02 <> '2'
   IF l_cnt > 0 THEN 
      CALL cl_err('','alm1993',0)
      LET g_success = 'N'
      RETURN 
   END IF      
   SELECT oga10 INTO l_oga10 FROM oga_file WHERE oga01 = g_lps.lps17
   IF NOT cl_null(l_oga10) THEN 
      CALL cl_err('','alm1994',0)
      LET g_success = 'N'
      RETURN 
   END IF  
END FUNCTION   


FUNCTION t610_z()  
 
#DEFINE l_oia07   LIKE oia_file.oia07    #TQC-D20067
DEFINE l_ogapost       LIKE oga_file.ogapost 
   INITIALIZE g_oga.* TO NULL
   SELECT * INTO g_oga.* FROM oga_file WHERE oga01 = g_lps.lps17
   LET g_argv0 = '2'   
     
   LET g_success = 'Y'
   LET g_msg="axmp650 '",g_oga.oga01,"' ' '  "  CLIPPED  
   CALL cl_cmdrun_wait(g_msg)
   SELECT ogapost INTO l_ogapost FROM oga_file WHERE oga01 = g_oga.oga01
   IF cl_null(l_ogapost) OR l_ogapost = 'Y' THEN 
      LET g_success = 'N' 
      RETURN  
   END IF

   UPDATE oga_file
      SET oga1013='N'  #扣賬還原時將[是否已打印提單]狀態改為N
        WHERE oga01=g_oga.oga01
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("upd","oga_file","","",SQLCA.sqlcode,"","",0)
      LET g_success = 'N'
      RETURN
   END IF
   ###此部分為信用管控的部分，因信用管控的功能能為未完成故此處需mark###
   #TQC-D20067--mark--str--
   #IF g_oaz.oaz96 ='Y' THEN
   #   CASE g_argv0
   #      WHEN '2'
   #         CALL s_ccc_oia07('D',g_oga.oga03) RETURNING l_oia07
   #         IF l_oia07 ='1' THEN
   #            CALL s_ccc_rback(g_oga.oga03,'D',g_oga.oga01,0,'')
   #         END IF
   #   END CASE
   #END IF
   #TQC-D20067--mark--end--
END FUNCTION   

#FUN-C90007 add end
#FUN-C90070-------add------str
FUNCTION t610_out()
DEFINE l_sql     LIKE type_file.chr1000, 
       l_azf03   LIKE azf_file.azf03,
       l_rtz13   LIKE rtz_file.rtz13,       
       sr        RECORD
                 lps01     LIKE lps_file.lps01, 
                 lps03     LIKE lps_file.lps03,
                 lps08     LIKE lps_file.lps08,
                 lps17     LIKE lps_file.lps17,
                 lpsplant  LIKE lps_file.lpsplant,
                 lps04     LIKE lps_file.lps04,
                 lps16     LIKE lps_file.lps16,
                 lps05     LIKE lps_file.lps05,
                 lps07     LIKE lps_file.lps07,
                 lps13     LIKE lps_file.lps13,
                 lps09     LIKE lps_file.lps09,
                 lps10     LIKE lps_file.lps10,
                 lps11     LIKE lps_file.lps11,
                 lps12     LIKE lps_file.lps12,
                 lpt02     LIKE lpt_file.lpt02,
                 lpt15     LIKE lpt_file.lpt15,
                 lpt04     LIKE lpt_file.lpt04,
                 lpt05     LIKE lpt_file.lpt05,
                 lpt06     LIKE lpt_file.lpt06,
                 lpt09     LIKE lpt_file.lpt09,
                 lpt11     LIKE lpt_file.lpt11,
                 lpt17     LIKE lpt_file.lpt17,
                 lpt021    LIKE lpt_file.lpt021,
                 lpt03     LIKE lpt_file.lpt03,
                 lpt14     LIKE lpt_file.lpt14,
                 lpt07     LIKE lpt_file.lpt07,
                 lpt08     LIKE lpt_file.lpt08,
                 lpt10     LIKE lpt_file.lpt10,
                 lpt12     LIKE lpt_file.lpt12,
                 lpt13     LIKE lpt_file.lpt13
                 END RECORD
 
     CALL cl_del_data(l_table) 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lpsuser', 'lpsgrup') 
     IF cl_null(g_wc) THEN LET g_wc = " lps01 = '",g_lps.lps01,"'" END IF
     IF cl_null(g_wc2) THEN LET g_wc2 = " lpt01 = '",g_lps.lps01,"'" END IF
     LET l_sql = "SELECT lps01,lps03,lps08,lps17,lpsplant,lps04,lps16,lps05,",
                 "       lps07,lps13,lps09,lps10,lps11,lps12,lpt02,lpt15,lpt04,",
                 "       lpt05,lpt06,lpt09,lpt11,lpt17,lpt021,lpt03,lpt14,lpt07,",
                 "       lpt08,lpt10,lpt12,lpt13",
                 "  FROM lps_file,lpt_file",
                 " WHERE lps01 = lpt01",
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED
     PREPARE t610_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table)   
        EXIT PROGRAM
     END IF
     DECLARE t610_cs1 CURSOR FOR t610_prepare1

     DISPLAY l_table
     FOREACH t610_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

       LET l_rtz13 = ' '
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = sr.lpsplant
       LET l_azf03 = ' '
       SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01 = sr.lps08 AND azf02 = '2' AND azf09 = 'G'
       EXECUTE insert_prep USING sr.*,l_azf03,l_rtz13
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(g_wc,'lps01,lps03,lps08,lps17,lpsplant,lps04,lps16,lps05,
                         lps07,lps13,lps09,lps10,lps11,lps12')
          RETURNING g_wc1
     CALL cl_wcchp(g_wc2,'lpt01,lpt02,lpt15,lpt04,lpt05,lpt06,lpt09,lpt11,lpt17,lpt021,
                          lpt03,lpt14,lpt07,lpt08,lpt10,lpt12,lpt13')
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
     CALL t610_grdata()
END FUNCTION

FUNCTION t610_grdata()
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
       LET handler = cl_gre_outnam("almt610")
       IF handler IS NOT NULL THEN
           START REPORT t610_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY lps01,lpt02"
           DECLARE t610_datacur1 CURSOR FROM l_sql
           FOREACH t610_datacur1 INTO sr1.*
               OUTPUT TO REPORT t610_rep(sr1.*)
           END FOREACH
           FINISH REPORT t610_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT t610_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_lps09  STRING
    DEFINE l_lpt04  STRING
    
    ORDER EXTERNAL BY sr1.lps01,sr1.lpt02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
            PRINTX g_wc1,g_wc3,g_wc4
              
        BEFORE GROUP OF sr1.lps01
            LET l_lineno = 0
        BEFORE GROUP OF sr1.lpt02
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_lps09 = cl_gr_getmsg("gre-302",g_lang,sr1.lps09)
            LET l_lpt04 = cl_gr_getmsg("gre-306",g_lang,sr1.lpt04)
            PRINTX sr1.*
            PRINTX l_lps09
            PRINTX l_lpt04

        AFTER GROUP OF sr1.lps01
        AFTER GROUP OF sr1.lpt02

        
        ON LAST ROW

END REPORT
#FUN-C90070-------add------end
#CHI-C80041---begin
FUNCTION t610_v(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废
DEFINE l_chr LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_lps.lps01) THEN CALL cl_err('',-400,0) RETURN END IF  
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_lps.lps09 ='X' THEN RETURN END IF
    ELSE
       IF g_lps.lps09<>'X' THEN RETURN END IF
    END IF
   #FUN-D20039 ----------end   

   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t610_cl USING g_lps.lps01
   IF STATUS THEN
      CALL cl_err("OPEN t610_cl:", STATUS, 1)
      CLOSE t610_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t610_cl INTO g_lps.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lps.lps01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t610_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_lps.lps09 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_lps.lps09)   THEN 
        LET l_chr=g_lps.lps09
        IF g_lps.lps09='N' THEN 
            LET g_lps.lps09='X' 
        ELSE
            LET g_lps.lps09='N'
        END IF
        UPDATE lps_file
            SET lps09=g_lps.lps09,  
                lpsmodu=g_user,
                lpsdate=g_today
            WHERE lps01=g_lps.lps01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","lps_file",g_lps.lps01,"",SQLCA.sqlcode,"","",1)  
            LET g_lps.lps09=l_chr 
        END IF
        DISPLAY BY NAME g_lps.lps09
   END IF
 
   CLOSE t610_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lps.lps01,'V')
 
END FUNCTION
#CHI-C80041---end
