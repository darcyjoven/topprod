# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: afat102.4gl
# Descriptions...: 資產部門移轉作業
# Date & Author..: 96/06/04 By Sophia
# Modify.........: No:7837 03/08/19 By Wiky 呼叫自動取單號時應在 Transction中
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No:9773 04/07/20 By Nicola 過帳還原時update faj22給錯值
# Modify.........: No.MOD-470515 04/07/30 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-490133 04/09/09 By Yuna fat12已為no use,update部份請拿掉
# Modify.........: No.MOD-490235 04/09/13 By Yuna
#                         1.在自動產生的input條件tm.d請default N
#                         2.移轉原因代號沒有帶出原因說明
#                         3.申請人員輸入後,應將申請部門一併帶出
#                         4.自動生成改成用confirm的方式
# Modify.........: No.MOD-490296 04/09/17 By Kitty check財編部份修改
# Modify.........: No.MOD-490344 04/09/20 By Kitty controlp 少display補入
# Modify.........: No.MOD-4A0248 04/10/25 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0019 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0059 04/12/10 By Smapmin 加入權限控管
# Modify.........: No.MOD-530062 05/03/10 By Kitty 輸入時未檢查其它單據已有移轉資料，而是等到拋轉時才會 show ins fap:重覆的 error message
# Modify.........: No.MOD-530434 05/03/26 By Smapmin B單身自動產生輸入新保管人自動帶出新保管部門
# Modify.........: No.MOD-530430 05/03/29 By Smapmin 無法過帳
# Modify.........: No.FUN-550034 05/05/16 By jackie 單據編號加大
# Modify.........: No.FUN-580109 05/10/20 By Sarah 以EF為backend engine,由TIPTOP處理前端簽核動作
# Modify.........: No.MOD-590470 05/10/20 By Sarah 判斷筆數之條件應排除已作廢之單據(找afa-309)
# Modify.........: No.FUN-5B0018 05/11/04 By Sarah 移轉日期沒有判斷關帳日
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.TQC-620120 06/03/02 By Smapmin 當附號為NULL時,LET 附號為空白
# Modify.........: No.TQC-630073 06/03/07 By Mandy 流程訊息通知功能
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-640243 06/05/10 By Echo 自動執行確認功能
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改報表列印所傳遞的參數
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670060 06/08/07 By Rayven 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-680028 06/08/22 By Ray 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0001 06/10/02 By jamie FUNCTION t102_q() 一開始應清空g_fas.*值
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.MOD-690003 06/11/30 By Smapmin 自動產生功能按放棄後,要回到前一畫面
# Modify.........: No.MOD-690081 06/12/06 By Smapmin 已確認的單子不可再重新產生分錄
# Modify.........: No.FUN-710028 07/02/01 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-720073 07/02/09 By Smapmin l_fat19-->l_fat.fat06
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740033 07/04/11 By Carrier 會計科目加帳套-財務
# Modify.........: No.TQC-740156 07/04/22 By claire 拋轉傳票,傳票還原拋轉串EF時,action要隱藏
# Modify.........: No.MOD-740300 07/04/23 By rainy 無檢查單別
# Modify.........: No.MOD-740316 07/04/26 By kim 無法自動產生單身
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760182 07/06/27 By chenl   自動產生QBE,條件不可為空。
# Modify.........: No.TQC-770108 07/07/24 By Rayven 單身輸入新保管人其部門不自動帶出
# Modify.........: No.TQC-7B0056 07/11/12 By Rayven 當移轉日期小于會計年度該期之起始日期時，報錯信息有誤
# Modify.........: No.TQC-7B0128 07/11/22 By chenl  修正，此條件導致單別設定只設定拋轉憑証，未設定系統自動拋轉總帳時不能審核。
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-840111 08/04/23 By lilingyu 預設申請人員登入帳號
# Modify.........: No.FUN-850068 08/05/13 By TSD.odyliao 自定欄位功能修改
# Modify.........: No.MOD-860284 08/07/04 By Sarah 使用afap302拋轉程式,原先傳g_user改為fasuser
# Modify.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值 
# Modify.........: No.FUN-960092 09/07/16 By hongmei 將faj09 = '5',fat07,fat08不設為required
# Modify.........: No.FUN-980003 09/08/10 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9B0178 09/11/26 By Sarah t102_s()段SQL裡用到l_fas02請改成g_fas.fas02
# Modify.........: No:CHI-9B0032 09/11/30 By Sarah 寫入fap_file時,也應寫入fap77=faj43
# Modify.........: No:MOD-9C0001 09/12/01 By Sarah 過帳還原時,應以fap19(存放位置)抓取營運中心值再回寫faj_file
# Modify.........: No:FUN-9C0077 10/01/06 By baofei 程序精簡
# Modify.........: No.MOD-A10194 10/01/29 By Sarah 過帳與過帳還原段會回寫faj_file,也需同步回寫fga_file
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A60168 10/06/25 by Dido 取消第二段 afap302,增加檢核第二套帳總帳單別設定  
# Modify.........: No:CHI-A60036 10/07/12 By Summer 過帳檢查改用s_azmm,增加aza63判斷
# Modify.........: No.MOD-A80068 10/08/10 By Dido 確認時檢核科目允許與拒絕部門設定
# Modify.........: No:MOD-A80137 10/08/19 By Dido 過帳與取消過帳應檢核關帳日 
# Modify.........: No:TQC-AB0144 10/11/28 By suncx 新增fat03欄位的控管 
# Modify.........: No.FUN-B10049 11/01/26 By destiny 科目查詢自動過濾
# Modify.........: No.TQC-B20061 11/02/16 By zhangll 增加afa-309错误控管
# Modify.........: No.MOD-B30117 11/03/12 By Dido 預設 fap56 為 0 
# Modify.........: No.FUN-AB0088 11/04/02 By chenying 因固資拆出財二功能，原本寫入fap亦有新增欄位，增加對應處理
# Modify.........: No.TQC-B10200 11/04/27 By Dido 拋轉 afap302 取消 'S' 判斷 
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.TQC-B50158 11/05/31 By zhangweib 在afa-308相關程式段利用s_azmm時傳入參數改為g_bookno1
# Modify.........: No.FUN-B50090 11/06/01 By suncx 財務關帳日期加嚴控管修正 
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50118 11/06/13 By belle 自動產生鍵,增加QBE條件-族群編號
# Modify.........: No.FUN-B80054 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No.MOD-B90006 11/09/05 By Polly 修正aft10傳遞的參數
# Modify.........: No:FUN-B60140 11/09/07 By zhangweib "財簽二二次改善"追
# Modify.........: NO:FUN-B90004 11/09/20 By Belle 自動拋轉傳票單別一欄有值，即可進行傳票拋轉/傳票拋轉還原
# Modify.........: No:MOD-BA0201 11/10/28 By Sarah 過帳段檢查axr-070的判斷式,應該加上單別的fahdmy3='Y'
# Modify.........: NO:FUN-B90096 11/11/03 By Sakura 將UPDATE faj_file拆分出財一、財二
# Modify.........: No:FUN-BA0112 11/11/07 By Sakura 財簽二5.25與5.1程式比對不一致修改
# Modify.........: No:MOD-BB0112 11/11/12 By johung AFTER FIELD fat031判斷若不提折舊，累折科目/折舊科目非必填
# Modify.........: No:CHI-B80007 11/11/12 By johung 將過帳段的afa-309改到確認段
# Modify.........: No:FUN-BC0004 11/12/01 By xuxz 處理相關財簽二無法存檔問題
# Modify.........: No:MOD-BC0130 12/01/12 By Sakura t102_s的錯誤訊息axr-070判斷式調整
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C20012 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No:MOD-C20030 12/02/04 By Polly 手動輸入單身需自動帶財會二預設值
# Modify.........: No:FUN-C30140 12/03/13 By Mandy (1)送簽中,應不可執行ACTION"自動產生","財簽二資料","分錄底稿","分錄底稿二","產生分錄底稿"
#                                                  (2)TIPTOP端簽核時,"分錄底稿二","財簽二資料"ACTION應隱藏
# Modify.........: No:FUN-C30313 12/04/18 By Sakura 原使用fahdmy3判斷的程式，將財二部份拆分出來使用fahdmy32處理
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.MOD-C50255 12/06/05 By Polly 增加控卡維護拋轉總帳單別
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: no.MOD-C60079 12/06/12 By Polly 修正自動產生完後，重新顯示單身資料
# Modify.........: No:CHI-C60010 12/06/14 By jinjj 財簽二欄位需依財簽二幣別做取位
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No.MOD-C70265 12/07/27 By Polly 資產不存在時,將 afa-093 改用訊息 afa-134
# Modify.........: No:CHI-C90051 12/09/08 By Polly 將拋轉還原程式移至更新確認碼/過帳碼前處理，並判斷傳票編號如不為null時，則RETURN
# Modify.........: No.CHI-C80041 12/11/26 By bart 取消單頭資料控制
# Modify.........: No.FUN-D10098 13/02/04 By lujh 大陸版本用gfag102
# Modify.........: No:FUN-D20035 13/02/21 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D30032 13/04/08 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-E80012 18/11/29 By lixwz 修改付款日期之後,tic現金流量明細重複

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_fas   RECORD LIKE fas_file.*,
    g_fas_t RECORD LIKE fas_file.*,
    g_fas_o RECORD LIKE fas_file.*,
    g_fahprt        LIKE fah_file.fahprt,
    g_fahconf       LIKE fah_file.fahconf,
    g_fahpost       LIKE fah_file.fahpost,
    g_fahapr        LIKE fah_file.fahapr,             #FUN-640243
    g_fat           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    fat02     LIKE fat_file.fat02,
                    fat03     LIKE fat_file.fat03,
                    fat031    LIKE fat_file.fat031,
                    faj06     LIKE faj_file.faj06,
                    fat04     LIKE fat_file.fat04,
                    fat05     LIKE fat_file.fat05,
                    gem02_1   like gem_file.gem02,       #darcy:2024/11/06 add
                    fat06     LIKE fat_file.fat06,
                    faf02     like faf_file.faf02,       #darcy:2024/11/06 add
                    fat07     LIKE fat_file.fat07,
                   #fat071    LIKE fat_file.fat071,     #No.FUN-680028  #FUN-AB0088 mark
                    fat08     LIKE fat_file.fat08, 
                   #fat081    LIKE fat_file.fat081,     #No.FUN-680028  #FUN-AB0088 mark
                    fat09     LIKE fat_file.fat09,
                    fat10     LIKE fat_file.fat10,
                    fat11     LIKE fat_file.fat11,
                   #fat111    LIKE fat_file.fat111     #No.FUN-680028   #FUN-AB0088 mark
                    fatud01   LIKE fat_file.fatud01,
                    fatud02   LIKE fat_file.fatud02,
                    fatud03   LIKE fat_file.fatud03,
                    fatud04   LIKE fat_file.fatud04,
                    fatud05   LIKE fat_file.fatud05,
                    fatud06   LIKE fat_file.fatud06,
                    fatud07   LIKE fat_file.fatud07,
                    fatud08   LIKE fat_file.fatud08,
                    fatud09   LIKE fat_file.fatud09,
                    fatud10   LIKE fat_file.fatud10,
                    fatud11   LIKE fat_file.fatud11,
                    fatud12   LIKE fat_file.fatud12,
                    fatud13   LIKE fat_file.fatud13,
                    fatud14   LIKE fat_file.fatud14,
                    fatud15   LIKE fat_file.fatud15
                    END RECORD,
    g_fat_t         RECORD
                    fat02     LIKE fat_file.fat02,
                    fat03     LIKE fat_file.fat03,
                    fat031    LIKE fat_file.fat031,
                    faj06     LIKE faj_file.faj06,
                    fat04     LIKE fat_file.fat04,
                    fat05     LIKE fat_file.fat05,
                    gem02_1   like gem_file.gem02,       #darcy:2024/11/06 add
                    fat06     LIKE fat_file.fat06,
                    faf02     like faf_file.faf02,       #darcy:2024/11/06 add
                    fat07     LIKE fat_file.fat07,
                   #fat071    LIKE fat_file.fat071,     #No.FUN-680028   #FUN-AB0088 mark
                    fat08     LIKE fat_file.fat08,
                   #fat081    LIKE fat_file.fat081,     #No.FUN-680028   #FUN-AB0088 mark
                    fat09     LIKE fat_file.fat09,
                    fat10     LIKE fat_file.fat10,
                    fat11     LIKE fat_file.fat11,
                   #fat111    LIKE fat_file.fat111     #No.FUN-680028   #FUN-AB0088 mark
                    fatud01   LIKE fat_file.fatud01,
                    fatud02   LIKE fat_file.fatud02,
                    fatud03   LIKE fat_file.fatud03,
                    fatud04   LIKE fat_file.fatud04,
                    fatud05   LIKE fat_file.fatud05,
                    fatud06   LIKE fat_file.fatud06,
                    fatud07   LIKE fat_file.fatud07,
                    fatud08   LIKE fat_file.fatud08,
                    fatud09   LIKE fat_file.fatud09,
                    fatud10   LIKE fat_file.fatud10,
                    fatud11   LIKE fat_file.fatud11,
                    fatud12   LIKE fat_file.fatud12,
                    fatud13   LIKE fat_file.fatud13,
                    fatud14   LIKE fat_file.fatud14,
                    fatud15   LIKE fat_file.fatud15
                    END RECORD,
    g_fah           RECORD LIKE fah_file.*,
    g_faj40         LIKE faj_file.faj40,
    g_fas01_t       LIKE fas_file.fas01,
    g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    l_modify_flag       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    l_flag              LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    g_t1                LIKE type_file.chr5,     #No.FUN-550034          #No.FUN-680070 VARCHAR(5)
    g_buf               LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
    g_rec_b             LIKE type_file.num5,                #單身筆數       #No.FUN-680070 SMALLINT
    l_ac                LIKE type_file.num5                 #目前處理的ARRAY CNT       #No.FUN-680070 SMALLINT
DEFINE   g_argv1        LIKE fas_file.fas01    #移轉單號   #FUN-580109
DEFINE   g_argv2        STRING                 # 指定執行功能:query or inser  #TQC-630073
DEFINE   g_laststage    LIKE type_file.chr1                              #FUN-580109       #No.FUN-680070 VARCHAR(1)
DEFINE   g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_chr          LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
DEFINE   g_chr2         LIKE type_file.chr1      #FUN-580109       #No.FUN-680070 VARCHAR(1)
DEFINE   g_cnt          LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE   g_str          STRING            #No.FUN-670060
DEFINE   g_wc_gl        STRING            #No.FUN-670060
DEFINE   g_dbs_gl       LIKE type_file.chr21           #No.FUN-670060       #No.FUN-680070 VARCHAR(21)
DEFINE   g_before_input_done LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_jump         LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE   g_bookno1      LIKE aza_file.aza81         #No.FUN-740033
DEFINE   g_bookno2      LIKE aza_file.aza82         #No.FUN-740033
DEFINE   g_flag         LIKE type_file.chr1         #No.FUN-740033
#FUN-AB0088---add---str---
DEFINE   g_fat2     DYNAMIC ARRAY OF RECORD    #祘Α跑计(Program Variables)
                    fat02     LIKE fat_file.fat02,
                    fat03     LIKE fat_file.fat03,
                    fat031    LIKE fat_file.fat031,
                    faj06     LIKE faj_file.faj06,
                    fat04     LIKE fat_file.fat04,
                    fat05     LIKE fat_file.fat05,
                    fat06     LIKE fat_file.fat06,
                    fat071    LIKE fat_file.fat071,   
                    fat081    LIKE fat_file.fat081,  
                    fat092    LIKE fat_file.fat09,
                    fat102    LIKE fat_file.fat10,
                    fat111    LIKE fat_file.fat111  
                    END RECORD,
    g_fat2_t         RECORD
                    fat02     LIKE fat_file.fat02,
                    fat03     LIKE fat_file.fat03,
                    fat031    LIKE fat_file.fat031,
                    faj06     LIKE faj_file.faj06,
                    fat04     LIKE fat_file.fat04,
                    fat05     LIKE fat_file.fat05,
                    fat06     LIKE fat_file.fat06,
                    fat071    LIKE fat_file.fat071,   
                    fat081    LIKE fat_file.fat081,  
                    fat092    LIKE fat_file.fat09,
                    fat102    LIKE fat_file.fat10,
                    fat111    LIKE fat_file.fat111  
                    END RECORD
#FUN-AB0088---add---end---
DEFINE g_faj531 LIKE faj_file.faj531     #MOD-C20030 add
DEFINE g_faj541 LIKE faj_file.faj541     #MOD-C20030 add
DEFINE g_faj551 LIKE faj_file.faj551     #MOD-C20030 add
#CHI-C60010---str---
DEFINE g_azi04_1  LIKE azi_file.azi04,
       g_faj143   LIKE faj_file.faj143
#CHI-C60010---end---
 
MAIN
DEFINE
    l_sql           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
DEFINE p_row,p_col  LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    IF FGL_GETENV("FGLGUI") <> "0" THEN
       OPTIONS                                #改變一些系統預設值
           INPUT NO WRAP
    END IF
 
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
    LET g_forupd_sql = "SELECT * FROM fas_file WHERE fas01 =? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t102_cl CURSOR FROM g_forupd_sql
 
    LET g_wc2 = ' 1=1'
      CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #NO.FUN-6A0069
        RETURNING g_time                                                        #NO.FUN-6A0069
 
    LET g_argv1=ARG_VAL(1)  #TQC-630073
    LET g_argv2=ARG_VAL(2)  #TQC-630073
 
    IF g_bgjob='N' OR cl_null(g_bgjob) THEN
 
       LET p_row = 3 LET p_col = 7
       OPEN WINDOW t102_w AT p_row,p_col              #顯示畫面
             WITH FORM "afa/42f/afat102"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
       CALL cl_ui_init()
      #FUN-AB0088---mark---str---
      #IF g_aza.aza63 = 'Y' THEN
      #   CALL cl_set_comp_visible("fat071,fat081,fat111",TRUE)
      #ELSE
      #   CALL cl_set_comp_visible("fat071,fat081,fat111",FALSE)
      #END IF
      #FUN-AB0088---mark---end--- 
      
      #FUN-AB0088---add---str---
       IF g_faa.faa31 = 'Y' THEN  
          CALL cl_set_act_visible("fin_audit2,entry_sheet2",TRUE)
          CALL cl_set_comp_visible("fas072,fas082",TRUE)    #FUN-B60140   Add
       ELSE
          CALL cl_set_act_visible("fin_audit2,entry_sheet2",FALSE)
          CALL cl_set_comp_visible("fas072,fas082",FALSE)   #FUN-B60140   Add
       END IF
      #FUN-AB0088---add---end---
 
    END IF
 
    IF fgl_getenv('EASYFLOW') = "1" THEN
       LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
    END IF
 
    #建立簽核模式時的 toolbar icon
    CALL aws_efapp_toolbar()

   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t102_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t102_a()
            END IF
         WHEN "efconfirm"
            CALL t102_q()
            CALL t102_y_chk()          #CALL 原確認的 check 段
            IF g_success = "Y" THEN
               LET l_ac = 1
               CALL t102_y_upd()       #CALL 原確認的 update 段
            END IF
            EXIT PROGRAM
         OTHERWISE
            CALL t102_q()
      END CASE
   END IF
 
    #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
    CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void,  #FUN-D20035 add--undo_void
                               confirm, undo_confirm, easyflow_approval, auto_generate, entry_sheet, gen_entry, 
                               post, undo_post, account_post,carry_voucher,undo_carry_voucher,fin_audit2,entry_sheet2")   #TQC-740156 modify  #FUN-C30140 mod
         RETURNING g_laststage
 
 
    CALL t102_menu()
    CLOSE WINDOW t102_w                    #結束畫面
    CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
         RETURNING g_time                                                   #NO.FUN-6A0069
END MAIN
 
FUNCTION t102_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_fat.clear()
 
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = " fas01 = '",g_argv1,"'"
       LET g_wc2 = " 1=1"
    ELSE
      CALL cl_set_head_visible("","YES")            #No.FUN-6B0029
   INITIALIZE g_fas.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
         fas01,fas02,fas03,fas04,fas05,fas06,fasconf,faspost,fasmksg,fas09,fas07,fas08,   #FUN-580109
         fas072,fas082,fasuser,fasgrup,fasmodu,fasdate     #FUN-B60140   Add fas072 fas082
         ,fasud01,fasud02,fasud03,fasud04,fasud05,
         fasud06,fasud07,fasud08,fasud09,fasud10,
         fasud11,fasud12,fasud13,fasud14,fasud15
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
         ON ACTION controlp                 #ok
            CASE
               WHEN INFIELD(fas01)    #查詢單據性質
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_fas"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fas01
                  NEXT FIELD fas01
               WHEN INFIELD(fas03)    #申請人員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fas03
                  NEXT FIELD fas03
               WHEN INFIELD(fas04)    #申請部門
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fas04
                  NEXT FIELD fas04
               WHEN INFIELD(fas06)    #異動原因
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_fag"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = "3"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fas06
                  NEXT FIELD fas06
               OTHERWISE EXIT CASE
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
 
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT
      IF INT_FLAG THEN RETURN END IF
 
     #CONSTRUCT g_wc2 ON fat02,fat03,fat031,faj06,fat04,fat05,fat06,fat07,fat071,fat08,     #No.FUN-680028   #FUN-AB0088 mark
      CONSTRUCT g_wc2 ON fat02,fat03,fat031,faj06,fat04,fat05,fat06,fat07,fat08,            #No.FUN-680028   #FUN-AB0088 add
                        #fat081,fat09,fat10,fat11,fat111     #No.FUN-680028  #FUN-AB0088 mark
                         fat09,fat10,fat11                   #No.FUN-680028  #FUN-AB0088 add
                        ,fatud01,fatud02,fatud03,fatud04,fatud05
                        ,fatud06,fatud07,fatud08,fatud09,fatud10
                        ,fatud11,fatud12,fatud13,fatud14,fatud15
              FROM s_fat[1].fat02, s_fat[1].fat03, s_fat[1].fat031, s_fat[1].faj06,
                   s_fat[1].fat04, s_fat[1].fat05, s_fat[1].fat06,
                  #s_fat[1].fat07, s_fat[1].fat071,s_fat[1].fat08, s_fat[1].fat081,   #No.FUN-680028  #FUN-AB0088 mark
                   s_fat[1].fat07, s_fat[1].fat08,                                    #FUN-AB0088 add      
                  #s_fat[1].fat09,s_fat[1].fat10, s_fat[1].fat11, s_fat[1].fat111     #No.FUN-680028  #FUN-AB0088 mark
                   s_fat[1].fat09,s_fat[1].fat10, s_fat[1].fat11                      #FUN-AB0088 add 
                  ,s_fat[1].fatud01,s_fat[1].fatud02,s_fat[1].fatud03
                  ,s_fat[1].fatud04,s_fat[1].fatud05,s_fat[1].fatud06
                  ,s_fat[1].fatud07,s_fat[1].fatud08,s_fat[1].fatud09
                  ,s_fat[1].fatud10,s_fat[1].fatud11,s_fat[1].fatud12
                  ,s_fat[1].fatud13,s_fat[1].fatud14,s_fat[1].fatud15
 
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
         ON ACTION controlp   #ok
            CASE
               WHEN INFIELD(fat03)  #財產編號,財產附號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_faj"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fat03
                  NEXT FIELD fat03
               WHEN INFIELD(fat04)  #保管人員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fat04
                  NEXT FIELD fat04
               WHEN INFIELD(fat05)  #保管部門
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fat05
                  NEXT FIELD fat05
               WHEN INFIELD(fat06)  #存放位置
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_faf"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fat06
                  NEXT FIELD fat06
               WHEN INFIELD(fat07)  #資產科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' "
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fat07
                  NEXT FIELD fat07
             #FUN-AB0088---mark---str----------------
             # WHEN INFIELD(fat071)  #資產科目
             #    CALL cl_init_qry_var()
             #    LET g_qryparam.form = "q_aag"
             #    LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' "
             #    LET g_qryparam.state = "c"
             #    CALL cl_create_qry() RETURNING g_qryparam.multiret
             #    DISPLAY g_qryparam.multiret TO fat071
             #    NEXT FIELD fat071
             #FUN-AB0088---mark---end--------------
               WHEN INFIELD(fat08)  #累折科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' "
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fat08
                  NEXT FIELD fat08
             #FUN-AB0088---mark---str----------------
             # WHEN INFIELD(fat081)  #累折科目
             #    CALL cl_init_qry_var()
             #    LET g_qryparam.form = "q_aag"
             #    LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' "
             #    LET g_qryparam.state = "c"
             #    CALL cl_create_qry() RETURNING g_qryparam.multiret
             #    DISPLAY g_qryparam.multiret TO fat081
             #    NEXT FIELD fat081
             #FUN-AB0088---mark---end----------------
               WHEN INFIELD(fat10)  #分攤部門
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fat10
                  NEXT FIELD fat10
               WHEN INFIELD(fat11)  #折舊科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' "
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fat11
                  NEXT FIELD fat11
              #FUN-AB0088---mark---str----------------
              #WHEN INFIELD(fat111)  #折舊科目
              #   CALL cl_init_qry_var()
              #   LET g_qryparam.form = "q_aag"
              #   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' "
              #   LET g_qryparam.state = "c"
              #   CALL cl_create_qry() RETURNING g_qryparam.multiret
              #   DISPLAY g_qryparam.multiret TO fat111
              #   NEXT FIELD fat111
              #FUN-AB0088---mark---end----------------
               OTHERWISE
                  EXIT CASE
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
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
      END CONSTRUCT
      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
   END IF   #FUN-58010

   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fasuser', 'fasgrup')
 
 
   IF g_wc2 = " 1=1" THEN        # 若單身未輸入條件
      LET g_sql = "SELECT fas01 FROM fas_file",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY 1"
   ELSE                          # 若單身有輸入條件
      LET g_sql = "SELECT DISTINCT fas01 ",
                  "  FROM fas_file, fat_file",
                  " WHERE fas01 = fat01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY 1"
   END IF
 
   PREPARE t102_prepare FROM g_sql
   DECLARE t102_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t102_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
       LET g_sql="SELECT COUNT(*) FROM fas_file WHERE ",g_wc CLIPPED
   ELSE
       LET g_sql="SELECT COUNT(DISTINCT fas01) FROM fas_file,fat_file",
                 " WHERE fat01 = fas01 ",
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED
   END IF
   PREPARE t102_count_pre FROM g_sql
   DECLARE t102_count CURSOR FOR t102_count_pre
END FUNCTION
 
FUNCTION t102_menu()
   DEFINE l_creator    LIKE type_file.chr1           #「不准」時是否退回填表人 #FUN-580109       #No.FUN-680070 VARCHAR(1)
   DEFINe l_flowuser   LIKE type_file.chr1           # 是否有指定加簽人員      #FUN-580109       #No.FUN-680070 VARCHAR(1)
 
   LET l_flowuser = "N"   #FUN-580109
 
   WHILE TRUE
      CALL t102_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t102_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t102_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t102_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t102_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t102_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t102_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "auto_generate"
            IF cl_chk_act_auth() THEN
               CALL t102_g()
            END IF
         #FUN-AB0088---add---str---
         WHEN "fin_audit2"
            IF cl_chk_act_auth() THEN
               CALL t102_fin_audit2()
            END IF
         #FUN-AB0088---add---end---
         WHEN "entry_sheet"
            IF cl_chk_act_auth() AND not cl_null(g_fas.fas01) THEN
              #FUN-C30140---mark--str---
              #CALL s_fsgl('FA',2,g_fas.fas01,0,g_faa.faa02b,1,g_fas.fasconf,'0',g_faa.faa02p)     #No.FUN-680028
              #CALL t102_npp02('0')  #No.+087 010502 by plum     #No.FUN-680028
              #FUN-C30140---mark--end---
              #FUN-C30140---add---str---
              IF NOT cl_null(g_fas.fas09) AND g_fas.fas09 matches '[Ss]' THEN     
                  CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
              ELSE
                  CALL s_fsgl('FA',2,g_fas.fas01,0,g_faa.faa02b,1,g_fas.fasconf,'0',g_faa.faa02p)     #No.FUN-680028
                  CALL t102_npp02('0')  #No.+087 010502 by plum     #No.FUN-680028
              END IF
              #FUN-C30140---add---end---
            END IF
         WHEN "entry_sheet2"
            IF cl_chk_act_auth() AND not cl_null(g_fas.fas01) THEN
              #FUN-C30140---mark--str---
              #CALL s_fsgl('FA',2,g_fas.fas01,0,g_faa.faa02c,1,g_fas.fasconf,'1',g_faa.faa02p)     #No.FUN-680028
              #CALL t102_npp02('1')  #No.+087 010502 by plum     #No.FUN-680028
              #FUN-C30140---mark--end---
              #FUN-C30140---add---str---
              IF NOT cl_null(g_fas.fas09) AND g_fas.fas09 matches '[Ss]' THEN     
                  CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
              ELSE
                  CALL s_fsgl('FA',2,g_fas.fas01,0,g_faa.faa02c,1,g_fas.fasconf,'1',g_faa.faa02p)     #No.FUN-680028
                  CALL t102_npp02('1')  #No.+087 010502 by plum     #No.FUN-680028
              END IF
              #FUN-C30140---add---end---
            END IF
         WHEN "gen_entry"
            IF cl_chk_act_auth() AND g_fas.fasconf <> 'X' THEN
              #FUN-C30140---add---str---
              IF NOT cl_null(g_fas.fas09) AND g_fas.fas09 matches '[Ss]' THEN     
                  CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
              ELSE
              #FUN-C30140---add---end---
                  SELECT faspost INTO g_fas.faspost FROM fas_file
                  WHERE fas01 = g_fas.fas01
                  IF g_fas.fasconf = 'N' THEN   #MOD-690081
                     LET g_success='Y' #no.5573
                     BEGIN WORK #no.5573
                     CALL s_showmsg_init()    #No.FUN-710028
                     CALL t102_gl(g_fas.fas01,g_fas.fas02,'0')
                    #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN    #FUN-AB0088  mark
                     IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN    #FUN-AB0088  add
                        CALL t102_gl(g_fas.fas01,g_fas.fas02,'1')
                     END IF
                     CALL s_showmsg() #No.FUN-710028
                     IF g_success='Y' THEN
                        COMMIT WORK
                     ELSE
                        ROLLBACK WORK
                     END IF #no.5573
                   ELSE    #MOD-690081
                     CALL cl_err(g_fas.fas01,'afa-350',0)   #MOD-690081
                   END IF
              END IF #FUN-C30140 add
            END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t102_x()     #FUN-D20035
               CALL t102_x(1)     #FUN-D20035
            END IF
 
        #FUN-D20035---add--str
         #取消作废
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t102_x(2)
            END IF
         #FUN-D20035---add---end

         WHEN "carry_voucher" 
            IF cl_chk_act_auth() THEN
               IF g_fas.faspost = 'Y' THEN    #No.FUN-680028
                  CALL t102_carry_voucher()
               ELSE 
                  CALL cl_err('','atm-557',1) #No.FUN-680028
               END IF 
            END IF
 
         WHEN "undo_carry_voucher" 
            IF cl_chk_act_auth() THEN
               IF g_fas.faspost = 'Y' THEN    #No.FUN-680028
                  CALL t102_undo_carry_voucher()
               ELSE 
                  CALL cl_err('','atm-558',1) #No.FUN-680028
               END IF 
            END IF
 
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t102_y_chk()          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                  CALL t102_y_upd()       #CALL 原確認的 update 段
               END IF
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t102_z()
            END IF
         WHEN "post"
            IF cl_chk_act_auth() THEN
               CALL t102_s('S')
            END IF
         WHEN "account_post"
            IF cl_chk_act_auth() THEN
               CALL t102_s('T')
            END IF
         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
               CALL t102_w()
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_fas.fas01 IS NOT NULL THEN
                  LET g_doc.column1 = "fas01"
                  LET g_doc.value1 = g_fas.fas01
                  CALL cl_doc()
               END IF
            END IF
 
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fat),'','')
            END IF
 
         #@WHEN "簽核狀況"
         WHEN "approval_status"
              IF cl_chk_act_auth() THEN  #DISPLAY ONLY
                 IF aws_condition2() THEN
                    CALL aws_efstat2()
                 END IF
              END IF
         ##EasyFlow送簽
         WHEN "easyflow_approval"
              IF cl_chk_act_auth() THEN
                #FUN-C20012 add str---
                 SELECT * INTO g_fas.* FROM fas_file
                  WHERE fas01 = g_fas.fas01
                 CALL t102_show()
                 CALL t102_b_fill(' 1=1')
                #FUN-C20012 add end---
                 CALL t102_ef()
                 CALL t102_show()  #FUN-C20012 add
              END IF
         #@WHEN "准"
         WHEN "agree"
              IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有加簽人員
                 CALL t102_y_upd()      #CALL 原確認的 update 段
              ELSE
                 LET g_success = "Y"
                 IF NOT aws_efapp_formapproval() THEN
                    LET g_success = "N"
                 END IF
              END IF
              IF g_success = 'Y' THEN
                 IF cl_confirm('aws-081') THEN
                    IF aws_efapp_getnextforminfo() THEN
                       LET l_flowuser = 'N'
                       LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                       IF NOT cl_null(g_argv1) THEN
                          CALL t102_q()
                          #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                          CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void,  #FUN-D20035 add--undo_void
                                                     confirm, undo_confirm, easyflow_approval, auto_generate, entry_sheet, gen_entry, 
                                                     post, undo_post, account_post,carry_voucher,undo_carry_voucher,fin_audit2,entry_sheet2")   #TQC-740156 modify  #FUN-C30140 mod
                               RETURNING g_laststage
                       ELSE
                          EXIT WHILE
                       END IF
                    ELSE
                       EXIT WHILE
                    END IF
                 ELSE
                    EXIT WHILE
                 END IF
              END IF
 
         #@WHEN "不准"
         WHEN "deny"
             IF ( l_creator := aws_efapp_backflow()) IS NOT NULL THEN
                IF aws_efapp_formapproval() THEN
                   IF l_creator = "Y" THEN
                      LET g_fas.fas09 = 'R'
                      DISPLAY BY NAME g_fas.fas09
                   END IF
                   IF cl_confirm('aws-081') THEN
                      IF aws_efapp_getnextforminfo() THEN
                         LET l_flowuser = 'N'
                         LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                         IF NOT cl_null(g_argv1) THEN
                            CALL t102_q()
                            #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                            CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void,     #FUN-D20035 add--undo_void
                                                       confirm, undo_confirm, easyflow_approval, auto_generate, entry_sheet, gen_entry, 
                                                       post, undo_post, account_post,carry_voucher,undo_carry_voucher,fin_audit2,entry_sheet2")   #TQC-740156 modify  #FUN-C30140 mod
                                 RETURNING g_laststage
                         ELSE
                            EXIT WHILE
                         END IF
                      ELSE
                         EXIT WHILE
                      END IF
                   ELSE
                      EXIT WHILE
                   END IF
                END IF
              END IF
 
         #@WHEN "加簽"
         WHEN "modify_flow"
              IF aws_efapp_flowuser() THEN   #選擇欲加簽人員
                 LET l_flowuser = 'Y'
              ELSE
                 LET l_flowuser = 'N'
              END IF
 
         #@WHEN "撤簽"
         WHEN "withdraw"
              IF cl_confirm("aws-080") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT WHILE
                 END IF
              END IF
 
         #@WHEN "抽單"
         WHEN "org_withdraw"
              IF cl_confirm("aws-079") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT WHILE
                 END IF
              END IF
 
         #@WHEN "簽核意見"
         WHEN "phrase"
              CALL aws_efapp_phrase()
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t102_a()
DEFINE li_result LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_fat.clear()
    INITIALIZE g_fas.* TO NULL
    LET g_fas01_t = NULL
    LET g_fas_o.* = g_fas.*
    LET g_fas_t.* = g_fas.*
 
    LET g_fas.fas03 = g_user 
    CALL t102_fas03('d')
   
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fas.fas02  =g_today
        LET g_fas.fas05  =g_today
        LET g_fas.fasconf='N'
        LET g_fas.faspost='N'
        LET g_fas.fasprsw=0
        LET g_fas.fasuser=g_user
        LET g_fas.fasoriu = g_user #FUN-980030
        LET g_fas.fasorig = g_grup #FUN-980030
        LET g_fas.fasgrup=g_grup
        LET g_fas.fasdate=g_today
        LET g_fas.fasmksg = "N"   #FUN-580109
        LET g_fas.fas09 = "0"     #FUN-580109
        LET g_fas.faslegal= g_legal    #FUN-980003 add
 
        CALL t102_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0
           INITIALIZE g_fas.* TO NULL
           CALL cl_err('',9001,0)
           ROLLBACK WORK
           EXIT WHILE
        END IF
        IF g_fas.fas01 IS NULL THEN       #KEY不可空白
           CONTINUE WHILE
        END IF
        BEGIN WORK  #No:7837
        CALL s_auto_assign_no("afa",g_fas.fas01,g_fas.fas02,"3","fas_file","fas01","","","") RETURNING li_result,g_fas.fas01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_fas.fas01

        INSERT INTO fas_file VALUES (g_fas.*)
        IF SQLCA.SQLCODE THEN
           CALL cl_err3("ins","fas_file",g_fas.fas01,g_fas.fas02,SQLCA.sqlcode,"","Ins:",1)  #No.FUN-660136 #No.FUN-B80054---調整至回滾事務前---
           ROLLBACK WORK  #No:7837
           CONTINUE WHILE
        ELSE
           COMMIT WORK   #No:7837
           CALL cl_flow_notify(g_fas.fas01,'I')
        END IF
        CALL g_fat.clear()
        LET g_rec_b=0
        LET g_fas_t.* = g_fas.*
        LET g_fas01_t = g_fas.fas01
        SELECT fas01 INTO g_fas.fas01
          FROM fas_file
         WHERE fas01 = g_fas.fas01
 
        CALL t102_g()
        CALL t102_b()       #自動產生單身
        #---判斷是否直接列印,確認,過帳---------
        LET g_t1 = s_get_doc_no(g_fas.fas01) #No.FUN-550034
 
        SELECT fahprt,fahconf,fahpost,fahapr
              INTO g_fahprt,g_fahconf,g_fahpost,g_fahapr
          FROM fah_file
         WHERE fahslip = g_t1
        IF g_fahprt = 'Y' THEN
           IF NOT cl_confirm('afa-128') THEN RETURN END IF
           CALL t102_out()
        END IF
 
        IF g_fahconf = 'Y' AND g_fahapr <> 'Y' THEN
           LET g_action_choice = "insert"
 
           CALL t102_y_chk()          #CALL 原確認的 check 段
           IF g_success = "Y" THEN
              CALL t102_y_upd()       #CALL 原確認的 update 段
           END IF
        END IF
        IF g_fahpost = 'Y' THEN
           CALL t102_s('S')
        END IF
        EXIT WHILE
        END WHILE
END FUNCTION
 
FUNCTION t102_u()
   DEFINE l_tic01     LIKE tic_file.tic01       #FUN-E80012 add
   DEFINE l_tic02     LIKE tic_file.tic02       #FUN-E80012 add
   IF s_shut(0) THEN RETURN END IF
 
    IF g_fas.fas01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    SELECT * INTO g_fas.* FROM fas_file WHERE fas01 = g_fas.fas01
    IF g_fas.fasconf = 'Y' THEN
       CALL cl_err(' ','afa-096',0)
       RETURN
    END IF
    IF g_fas.fasconf = 'X' THEN
       CALL cl_err(' ','9024',0)
       RETURN
    END IF
    IF g_fas.faspost = 'Y' THEN
       CALL cl_err(' ','afa-101',0)
       RETURN
    END IF
    IF g_fas.fas09 matches '[Ss]' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fas01_t = g_fas.fas01
    LET g_fas_o.* = g_fas.*
    BEGIN WORK
 
    OPEN t102_cl USING g_fas.fas01
    IF STATUS THEN
       CALL cl_err("OPEN t102_cl:", STATUS, 1)
       CLOSE t102_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t102_cl INTO g_fas.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fas.fas01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t102_cl ROLLBACK WORK RETURN
    END IF
    CALL t102_show()
    WHILE TRUE
        LET g_fas01_t = g_fas.fas01
        LET g_fas.fasmodu=g_user
        LET g_fas.fasdate=g_today
        CALL t102_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fas.*=g_fas_t.*
            CALL t102_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        LET g_fas.fas09 = '0'   #FUN-580109
        IF g_fas.fas01 != g_fas_t.fas01 THEN
           UPDATE fat_file SET fat01=g_fas.fas01 WHERE fat01=g_fas_t.fas01
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
              CALL cl_err3("upd","fat_file",g_fas_t.fas01,"",SQLCA.sqlcode,"","upd fat01",1)  #No.FUN-660136
              LET g_fas.*=g_fas_t.*
              CALL t102_show()
              CONTINUE WHILE
           END IF
        END IF
        UPDATE fas_file SET * = g_fas.*
         WHERE fas01 = g_fas.fas01
        IF SQLCA.SQLERRD[3] = 0 OR SQLCA.SQLCODE THEN
           CALL cl_err3("upd","fas_file",g_fas01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_fas.fas09
        IF g_fas.fasconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        IF g_fas.fas09 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
        CALL cl_set_field_pic(g_fas.fasconf,g_chr2,g_fas.faspost,"",g_chr,"")
        IF g_fas.fas02 != g_fas_t.fas02 THEN            # 更改單號
           UPDATE npp_file SET npp02=g_fas.fas02
            WHERE npp01=g_fas.fas01 AND npp00=2 AND npp011=1
              AND nppsys = 'FA'
           IF STATUS THEN 
              CALL cl_err3("upd","npp_file",g_fas.fas01,"",STATUS,"","upd npp02:",1)  #No.FUN-660136
           END IF
           #FUN-E80012---add---str---
           SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
           IF g_nmz.nmz70 = '3' THEN
              LET l_tic01=s_get_aznn(g_plant,g_bookno1,g_fas.fas02,1)
              LET l_tic02=s_get_aznn(g_plant,g_bookno1,g_fas.fas02,3)
              UPDATE tic_file SET tic01=l_tic01,
                                  tic02=l_tic02
              WHERE tic04=g_fas.fas01
              IF STATUS THEN
                 CALL cl_err3("upd","tic_file",g_fas.fas01,"",STATUS,"","upd tic01,tic02:",1)
              END IF
           END IF
           #FUN-E80012---add---end---
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t102_cl
    COMMIT WORK
    CALL cl_flow_notify(g_fas.fas01,'U')
END FUNCTION
 
FUNCTION t102_npp02(p_npptype)     #No.FUN-680028
   DEFINE p_npptype   LIKE npp_file.npptype     #No.FUN-680028
   DEFINE l_tic01     LIKE tic_file.tic01       #FUN-E80012 add
   DEFINE l_tic02     LIKE tic_file.tic02       #FUN-E80012 add
 
   IF p_npptype = "0" THEN    #FUN-B60140   Add
      IF g_fas.fas07 IS NULL OR g_fas.fas07=' ' THEN
         UPDATE npp_file SET npp02=g_fas.fas02
          WHERE npp01=g_fas.fas01 AND npp00=2 AND npp011=1
            AND nppsys = 'FA'
            AND npptype = p_npptype     #No.FUN-680028
         IF STATUS THEN 
            CALL cl_err3("upd","npp_file",g_fas.fas01,"",STATUS,"","upd npp02:",1)  #No.FUN-660136
         END IF
         #FUN-E80012---add---str---
         SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
         IF g_nmz.nmz70 = '3' THEN
            LET l_tic01=s_get_aznn(g_plant,g_bookno1,g_fas.fas02,1)
            LET l_tic02=s_get_aznn(g_plant,g_bookno1,g_fas.fas02,3)
            UPDATE tic_file SET tic01=l_tic01,
                                tic02=l_tic02
            WHERE tic04=g_fas.fas01
            IF STATUS THEN
               CALL cl_err3("upd","tic_file",g_fas.fas01,"",STATUS,"","upd tic01,tic02:",1)
            END IF
         END IF
         #FUN-E80012---add---end---
      END IF
  #FUN-B60140   ---start   Add
   ELSE
      IF g_fas.fas072 IS NULL OR g_fas.fas072=' ' THEN
         UPDATE npp_file SET npp02=g_fas.fas02
          WHERE npp01=g_fas.fas01 AND npp00=2 AND npp011=1
            AND nppsys = 'FA'
            AND npptype = p_npptype
         IF STATUS THEN
            CALL cl_err3("upd","npp_file",g_fas.fas01,"",STATUS,"","upd npp02:",1)
         END IF
         #FUN-E80012---add---str---
         SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
         IF g_nmz.nmz70 = '3' THEN
            LET l_tic01=s_get_aznn(g_plant,g_bookno1,g_fas.fas02,1)
            LET l_tic02=s_get_aznn(g_plant,g_bookno1,g_fas.fas02,3)
            UPDATE tic_file SET tic01=l_tic01,
                                tic02=l_tic02
            WHERE tic04=g_fas.fas01
            IF STATUS THEN
               CALL cl_err3("upd","tic_file",g_fas.fas01,"",STATUS,"","upd tic01,tic02:",1)
            END IF
         END IF
         #FUN-E80012---add---end---
      END IF
   END IF
  #FUN-B60140   ---end     Add
END FUNCTION
 
#處理INPUT
FUNCTION t102_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改       #No.FUN-680070 VARCHAR(1)
         l_flag          LIKE type_file.chr1,                #判斷必要欄位是否有輸入       #No.FUN-680070 VARCHAR(1)
         l_bdate,l_edate LIKE type_file.dat,          #No.FUN-680070 DATE
         l_n1            LIKE type_file.num5         #No.FUN-680070 SMALLINT
  DEFINE li_result       LIKE type_file.num5         #No.FUN-680070 SMALLINT
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
    INPUT BY NAME g_fas.fasoriu,g_fas.fasorig,
        g_fas.fas01,g_fas.fas02,g_fas.fas03,g_fas.fas04,g_fas.fas05,
        g_fas.fas06,g_fas.fas07,g_fas.fas08,g_fas.fas072,g_fas.fas082,   #FUN-B60140   Add fas072 fas082
        g_fas.fasconf,g_fas.faspost,
        g_fas.fasmksg,g_fas.fas09,   #FUN-580109
        g_fas.fasuser,g_fas.fasgrup,g_fas.fasmodu,g_fas.fasdate
       ,g_fas.fasud01,g_fas.fasud02,g_fas.fasud03,g_fas.fasud04,
        g_fas.fasud05,g_fas.fasud06,g_fas.fasud07,g_fas.fasud08,
        g_fas.fasud09,g_fas.fasud10,g_fas.fasud11,g_fas.fasud12,
        g_fas.fasud13,g_fas.fasud14,g_fas.fasud15 
           WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t102_set_entry(p_cmd)
           CALL t102_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
           CALL cl_set_docno_format("fas01")
 
        AFTER FIELD fas01
            IF NOT cl_null(g_fas.fas01) AND (cl_null(g_fas01_t) OR g_fas.fas01!=g_fas01_t) THEN    #MOD-740300
            CALL s_check_no("afa",g_fas.fas01,g_fas01_t,"3","fas_file","fas01","")  returning li_result,g_fas.fas01
            DISPLAY BY NAME g_fas.fas01
            IF (NOT li_result) THEN
               NEXT FIELD fas01
            END IF

               SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1

            END IF
           #start FUN-580109 帶出單據別設定的"簽核否"值,狀況碼預設為0
            SELECT fahapr,'0' INTO g_fas.fasmksg,g_fas.fas09
              FROM fah_file
             WHERE fahslip = g_t1
            IF cl_null(g_fas.fasmksg) THEN            #FUN-640243
                 LET g_fas.fasmksg = 'N'            
            END IF
            DISPLAY BY NAME g_fas.fasmksg,g_fas.fas09
            CALL s_get_bookno(YEAR(g_fas.fas02))
                    RETURNING g_flag,g_bookno1,g_bookno2
            LET g_fas_o.fas01 = g_fas.fas01
 
        AFTER FIELD fas02
            IF NOT cl_null(g_fas.fas02) THEN
               CALL s_azn01(g_faa.faa07,g_faa.faa08) RETURNING l_bdate,l_edate
               IF g_fas.fas02 < l_bdate
               THEN CALL cl_err(g_fas.fas02,'afa-994',0) #No.TQC-7B0056
                    NEXT FIELD fas02
               END IF
              #FUN-B60140   ---start   Add
               IF g_faa.faa31 = "Y" THEN
                  CALL s_azn01(g_faa.faa072,g_faa.faa082) RETURNING l_bdate,l_edate
                  IF g_fas.fas02 < l_bdate THEN
                     CALL cl_err(g_fas.fas02,'afa-994',0)
                     NEXT FIELD fas02
                  END IF
               END IF
              #FUN-B60140   ---end     Add
            END IF
            IF NOT cl_null(g_fas.fas02) THEN
               IF g_fas.fas02 <= g_faa.faa09 THEN
                  CALL cl_err('','mfg9999',1)
                  NEXT FIELD fas02
               END IF
              #FUN-B60140   ---start   Add
               IF g_faa.faa31 = "Y" THEN
                  IF g_fas.fas02 <= g_faa.faa092 THEN
                     CALL cl_err('','mfg9999',1)
                     NEXT FIELD fas02
                  END IF
               END IF
              #FUN-B60140   ---end     Add
               CALL s_get_bookno(YEAR(g_fas.fas02))
                    RETURNING g_flag,g_bookno1,g_bookno2
               IF g_flag =  '1' THEN  #抓不到帳別
                  CALL cl_err(g_fas.fas02,'aoo-081',1)
                  NEXT FIELD fas02
               END IF
               #FUN-AB0088---add---str---
               #固資已不和二套掛鉤，所以原本利用s_get_bookno取到賬別一及賬別二是用是否使用二套賬來判斷
               #此處取賬別二要重新處理，應取固資參數欄位財二賬套faa02c作為賬別二的賬套
               IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF
               #FUN-AB0088---add---end---
            END IF
 
        AFTER FIELD fas03
            IF NOT cl_null(g_fas.fas03) THEN
               CALL t102_fas03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fas.fas03,g_errno,0)
                  LET g_fas.fas03 = g_fas_t.fas03
                  DISPLAY BY NAME g_fas.fas03
                  NEXT FIELD fas03
               END IF
            END IF
            LET g_fas_o.fas03 = g_fas.fas03
 
        AFTER FIELD fas04
            IF NOT cl_null(g_fas.fas04) THEN
               CALL t102_fas04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fas.fas04,g_errno,0)
                  LET g_fas.fas04 = g_fas_t.fas04
                  DISPLAY BY NAME g_fas.fas04
                  NEXT FIELD fas04
               END IF
            END IF
            LET g_fas_o.fas04 = g_fas.fas04
 
        AFTER FIELD fas06
            IF NOT cl_null(g_fas.fas06) THEN
               CALL t102_fas06('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fas.fas06,g_errno,0)
                    LET g_fas_t.fas06 = g_fas.fas06
                    DISPLAY BY NAME g_fas.fas06
                    NEXT FIELD fas06
                 END IF
            END IF
 
        AFTER FIELD fasud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fasud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fasud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fasud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fasud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fasud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fasud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fasud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fasud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fasud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fasud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fasud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fasud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fasud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fasud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
       AFTER INPUT   #97/05/22 modify
          LET g_fas.fasuser = s_get_data_owner("fas_file") #FUN-C10039
          LET g_fas.fasgrup = s_get_data_group("fas_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION controlp                 #ok
           CASE
              WHEN INFIELD(fas01)    #查詢單據性質
                 LET g_t1 = s_get_doc_no(g_fas.fas01)  #No.FUN-550034
                 CALL q_fah( FALSE, TRUE,g_t1,'3','AFA') RETURNING g_t1  #TQC-670008
                 LET g_fas.fas01=g_t1   #No.FUN-550034
                 DISPLAY BY NAME g_fas.fas01
                 NEXT FIELD fas01
              WHEN INFIELD(fas03)    #申請人員
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_fas.fas03
                 CALL cl_create_qry() RETURNING g_fas.fas03
                 DISPLAY BY NAME g_fas.fas03
                 NEXT FIELD fas03
              WHEN INFIELD(fas04)    #申請部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_fas.fas04
                 CALL cl_create_qry() RETURNING g_fas.fas04
                 DISPLAY BY NAME g_fas.fas04
                 NEXT FIELD fas04
              WHEN INFIELD(fas06)    #異動原因
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_fag"
                 LET g_qryparam.arg1 = "3"
                 LET g_qryparam.default1 = g_fas.fas06
                 CALL cl_create_qry() RETURNING g_fas.fas06
                 DISPLAY BY NAME g_fas.fas06
                 NEXT FIELD fas06
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
FUNCTION t102_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("fas01",TRUE)
   END IF
 
END FUNCTION
FUNCTION t102_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("fas01",FALSE)
    END IF
END FUNCTION
 
FUNCTION t102_fas03(p_cmd)
 DEFINE   p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_gen02    LIKE gen_file.gen02,
          l_genacti  LIKE gen_file.genacti,
          l_gen03    LIKE gen_file.gen03
 
    LET g_errno = ' '
    SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti
      FROM gen_file
     WHERE gen01 = g_fas.fas03
    CASE
        WHEN SQLCA.SQLCODE = 100 LET g_errno ='afa-034'
                                 LET l_gen02 = NULL
                                 LET l_genacti = NULL
                                 LET l_gen03 = NULL
        WHEN l_genacti = 'N' LET g_errno = '9028'
        OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF p_cmd = 'a' THEN
      LET g_fas.fas04 = l_gen03
      DISPLAY BY NAME g_fas.fas04
   END IF
   IF cl_null(g_errno) OR p_cmd = 'd'
   THEN DISPLAY l_gen02 TO FORMONLY.gen02
   END IF
END FUNCTION
 
FUNCTION t102_fas04(p_cmd)
 DEFINE   p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_gem02    LIKE gem_file.gem02,
          l_gemacti  LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gem02,gemacti INTO l_gem02,l_gemacti
      FROM gem_file
     WHERE gem01 = g_fas.fas04
    CASE
        WHEN SQLCA.SQLCODE = 100 LET g_errno ='afa-038'
                                 LET l_gem02 = NULL
                                 LET l_gemacti = NULL
        WHEN l_gemacti = 'N' LET g_errno = '9028'
        OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd'
   THEN DISPLAY l_gem02 TO FORMONLY.gem02
   END IF
END FUNCTION
 
FUNCTION t102_fas06(p_cmd)
 DEFINE   p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_fag01    LIKE fag_file.fag01,
          l_fagacti  LIKE fag_file.fagacti,
          l_fag03    LIKE fag_file.fag03
 
    LET g_errno = ' '
    SELECT fag01,fagacti,fag03 INTO l_fag01,l_fagacti,l_fag03
      FROM fag_file
     WHERE fag01 = g_fas.fas06
       AND fag02 = '3'
    CASE
        WHEN SQLCA.SQLCODE = 100 LET g_errno ='afa-099'
                                 LET l_fag01 = NULL
                                 LET l_fagacti = NULL
                                 LET l_fag03 = NULL
        WHEN l_fagacti = 'N' LET g_errno = '9028'
        OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd'
      THEN DISPLAY l_fag03 TO FORMONLY.fag03
   END IF
END FUNCTION
 
FUNCTION t102_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fas.* TO NULL             #No.FUN-6A0001   
    CALL cl_msg("")                              #FUN-640243
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t102_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_fas.* TO NULL
       RETURN
    END IF
    CALL cl_msg(" SEARCHING ! ")                 #FUN-640243
    OPEN t102_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_fas.* TO NULL
    ELSE
        OPEN t102_count
        FETCH t102_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t102_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    CALL cl_msg("")                              #FUN-640243
END FUNCTION
 
FUNCTION t102_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t102_cs INTO g_fas.fas01
        WHEN 'P' FETCH PREVIOUS t102_cs INTO g_fas.fas01
        WHEN 'F' FETCH FIRST    t102_cs INTO g_fas.fas01
        WHEN 'L' FETCH LAST     t102_cs INTO g_fas.fas01
        WHEN '/'
             IF (NOT mi_no_ask) THEN
                 CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                 LET INT_FLAG = 0  ######add for prompt bug
                 PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                 END PROMPT
                 IF INT_FLAG THEN
                     LET INT_FLAG = 0
                     EXIT CASE
                 END IF
            END IF
            FETCH ABSOLUTE g_jump t102_cs INTO g_fas.fas01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fas.fas01,SQLCA.sqlcode,0)
        INITIALIZE g_fas.* TO NULL  #TQC-6B0105
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
    END IF
    SELECT * INTO g_fas.* FROM fas_file WHERE fas01 = g_fas.fas01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","fas_file",g_fas.fas01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
        INITIALIZE g_fas.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_fas.fasuser   #FUN-4C0059
    LET g_data_group = g_fas.fasgrup   #FUN-4C0059
    CALL s_get_bookno(YEAR(g_fas.fas02)) #TQC-740042
         RETURNING g_flag,g_bookno1,g_bookno2
    #FUN-AB0088---add---str---
    #固資已不和二套掛鉤，所以原本利用s_get_bookno取到賬別一及賬別二是用是否使用二套賬來判斷
    #此處取賬別二要重新處理，應取固資參數欄位財二賬套faa02c作為賬別二的賬套
    IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF
    #FUN-AB0088---add---end---
    IF g_flag =  '1' THEN  #抓不到帳別
       CALL cl_err(g_fas.fas02,'aoo-081',1)
    END IF
    CALL t102_show()
END FUNCTION
 
FUNCTION t102_show()
    LET g_fas_t.* = g_fas.*                #保存單頭舊值
    DISPLAY BY NAME g_fas.fasoriu,g_fas.fasorig,
 
 
        g_fas.fas01,g_fas.fas02,g_fas.fas03,g_fas.fas04,g_fas.fas05,
        g_fas.fas06,g_fas.fas07,g_fas.fas08,g_fas.fas072,g_fas.fas082,    #FUN-B60140   Add
        g_fas.fasconf,g_fas.faspost,
        g_fas.fasmksg,g_fas.fas09,   #FUN-580109 增加簽核,狀況碼
        g_fas.fasuser,g_fas.fasgrup,g_fas.fasmodu,g_fas.fasdate
       ,g_fas.fasud01,g_fas.fasud02,g_fas.fasud03,g_fas.fasud04,
        g_fas.fasud05,g_fas.fasud06,g_fas.fasud07,g_fas.fasud08,
        g_fas.fasud09,g_fas.fasud10,g_fas.fasud11,g_fas.fasud12,
        g_fas.fasud13,g_fas.fasud14,g_fas.fasud15 
    IF g_fas.fasconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_fas.fas09 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_fas.fasconf,g_chr2,g_fas.faspost,"",g_chr,"")
    CALL t102_fas03('d')
    CALL t102_fas04('d')
    CALL t102_fas06('d')  #No.MOD-490235(2)
    CALL t102_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t102_r()
 DEFINE l_chr,l_sure LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fas.fas01 IS NULL THEN
       CALL cl_err('',-400,0) RETURN
    END IF
    SELECT * INTO g_fas.* FROM fas_file WHERE fas01 = g_fas.fas01
    IF g_fas.fasconf = 'Y' THEN
       CALL cl_err('','afa-096',0) RETURN
    END IF
    IF g_fas.fasconf = 'X' THEN
       CALL cl_err(' ','9024',0)
       RETURN
    END IF
    IF g_fas.faspost = 'Y' THEN
       CALL cl_err(' ','afa-101',0) RETURN
    END IF
    IF g_fas.fas09 matches '[Ss1]' THEN
       CALL cl_err('','mfg3557',0)
       RETURN
    END IF
 
    BEGIN WORK
 
    OPEN t102_cl USING g_fas.fas01
    IF STATUS THEN
       CALL cl_err("OPEN t102_cl:", STATUS, 1)
       CLOSE t102_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t102_cl INTO g_fas.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_fas.fas01,SQLCA.sqlcode,0) RETURN
    END IF
    CALL t102_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fas01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fas.fas01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        MESSAGE "Delete fas,fat!"
        DELETE FROM fas_file WHERE fas01 = g_fas.fas01
        IF SQLCA.SQLCODE=100 THEN
           CALL cl_err3("del","fas_file",g_fas.fas01,"",SQLCA.sqlcode,"","No fas deleted",1)  #No.FUN-660136
        ELSE
           DELETE FROM fat_file WHERE fat01 = g_fas.fas01
           DELETE FROM npp_file WHERE nppsys = 'FA' AND npp00 = 2
                                  AND npp01 = g_fas.fas01
                                  AND npp011= 1
           DELETE FROM npq_file WHERE npqsys = 'FA' AND npq00 = 2
                                  AND npq01 = g_fas.fas01
                                  AND npq011= 1
           #FUN-B40056--add--str--
           DELETE FROM tic_file WHERE tic04 = g_fas.fas01
           #FUN-B40056--add--end--
           CLEAR FORM
           CALL g_fat.clear()
           CALL g_fat.clear()
        END IF
        INITIALIZE g_fas.* LIKE fas_file.*
        OPEN t102_count
        #FUN-B50062-add-start--
        IF STATUS THEN
           CLOSE t102_cl
           CLOSE t102_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end-- 
        FETCH t102_count INTO g_row_count
        #FUN-B50062-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE t102_cl
           CLOSE t102_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end-- 
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t102_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t102_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL t102_fetch('/')
        END IF
 
    END IF
    CLOSE t102_cl
    COMMIT WORK
    CALL cl_flow_notify(g_fas.fas01,'D')
END FUNCTION
 
FUNCTION t102_b()
DEFINE l_ac_t          LIKE type_file.num5,         #未取消的ARRAY CNT  #No.FUN-680070 SMALLINT
       l_row,l_col     LIKE type_file.num5,         #分段輸入之行,列數  #No.FUN-680070 SMALLINT
       l_n,l_cnt       LIKE type_file.num5,         #檢查重複用         #No.FUN-680070 SMALLINT
       l_lock_sw       LIKE type_file.chr1,         #單身鎖住否         #No.FUN-680070 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,         #處理狀態           #No.FUN-680070 VARCHAR(1)
       l_faj28         LIKE faj_file.faj28,
       l_b2            LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
       l_faj06         LIKE faj_file.faj06,
       l_faj100        LIKE faj_file.faj100,
       l_qty           LIKE type_file.num20_6,      #No.FUN-680070 DECIMAL(15,3),
       l_allow_insert  LIKE type_file.num5,         #可新增否           #No.FUN-680070 SMALLINT
       l_allow_delete  LIKE type_file.num5          #可刪除否           #No.FUN-680070 SMALLINT
DEFINE l_fas09         LIKE fas_file.fas09          #FUN-580109
DEFINE l_faj04         LIKE faj_file.faj04          #No.FUN-680028
DEFINE l_faj20         LIKE faj_file.faj20          #No.FUN-680028
DEFINE l_fbi02         LIKE fbi_file.fbi02          #No.FUN-680028
DEFINE l_fbi021        LIKE fbi_file.fbi021         #No.FUN-680028
DEFINE l_faj09         LIKE faj_file.faj09          #No.FUN-960092 add
 
    LET l_fas09 = g_fas.fas09   #FUN-580109
    LET g_action_choice = ""
    IF g_fas.fas01 IS NULL THEN RETURN END IF
    IF g_fas.fasconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
    IF g_fas.fasconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_fas.faspost = 'Y' THEN CALL cl_err('','afa-101',0) RETURN END IF
    IF g_fas.fas09 matches '[Ss]' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
   #LET g_forupd_sql = " SELECT fat02,fat03,fat031,' ',fat04,fat05,fat06,fat07,fat071,fat08,fat081,fat09, ",     #No.FUN-680028   #FUN-AB0088 mark
    LET g_forupd_sql = " SELECT fat02,fat03,fat031,' ',fat04,fat05,'',fat06,'',fat07,fat08,fat09, ",                   #FUN-AB0088 add
                       # darcy:2024/11/06 add 2 ''
                      #"  fat10,fat11,fat111 ",     #No.FUN-680028   #FUN-AB0088 mark
                       "  fat10,fat11 ",            #FUN-AB0088 add 
                       ",fatud01,fatud02,fatud03,fatud04,fatud05,",
                       "fatud06,fatud07,fatud08,fatud09,fatud10,",
                       "fatud11,fatud12,fatud13,fatud14,fatud15",
                       "  FROM fat_file ",
                       "  WHERE fat01 = ? ",
                       "  AND fat02 = ? ",
                       "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t102_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
 
   IF g_rec_b=0 THEN CALL g_fat.clear() END IF
 
 
      INPUT ARRAY g_fat WITHOUT DEFAULTS FROM s_fat.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN t102_cl USING g_fas.fas01
            IF STATUS THEN
               CALL cl_err("OPEN t102_cl:", STATUS, 1)
               CLOSE t102_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t102_cl INTO g_fas.*   # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_fas.fas01,SQLCA.sqlcode,0)  # 資料被他人LOCK
               CLOSE t102_cl ROLLBACK WORK RETURN
            END IF
             IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_fat_t.* = g_fat[l_ac].*  #BACKUP
                LET l_flag = 'Y'
 
                OPEN t102_bcl USING g_fas.fas01,g_fat_t.fat02
                IF STATUS THEN
                   CALL cl_err("OPEN t102_bcl:", STATUS, 1)
                   CLOSE t102_bcl
                   LET l_lock_sw = "Y"
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t102_bcl INTO g_fat[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err('lock fat',SQLCA.sqlcode,0)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
             ELSE
               LET l_flag='N'
               CALL cl_show_fld_cont()     #FUN-550037(smin)
             END IF
            IF l_ac <= l_n then                   #DISPLAY NEWEST
               SELECT faj06 INTO g_fat[l_ac].faj06
                 FROM faj_file
                WHERE faj02=g_fat[l_ac].fat03
                LET g_fat_t.faj06 =g_fat[l_ac].faj06
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
 
              INITIALIZE g_fat[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_fat[l_ac].* TO s_fat.*
              CALL g_fat.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
            END IF
            IF g_fat[l_ac].fat03 IS NOT NULL AND g_fat[l_ac].fat03 != ' ' THEN
               CALL t102_fat031('d')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fat[l_ac].fat031,g_errno,0)
                  NEXT FIELD fat02
               END IF
            END IF
            IF cl_null(g_fat[l_ac].fat04) THEN
               LET g_fat[l_ac].fat04 = ' '
            END IF
            IF cl_null(g_fat[l_ac].fat05) THEN
               LET g_fat[l_ac].fat05 = ' '
            END IF
            IF cl_null(g_fat[l_ac].fat06) THEN
               LET g_fat[l_ac].fat06 = ' '
            END IF
            IF cl_null(g_fat[l_ac].fat07) THEN
               LET g_fat[l_ac].fat07 = ' '
            END IF
           #FUN-AB0088---mark---str---
           #IF g_aza.aza63 = 'Y' THEN   
           #   IF cl_null(g_fat[l_ac].fat071) THEN
           #      LET g_fat[l_ac].fat071 = ' '
           #   END IF
           #END IF
           #FUN-AB0088---mark---end---
            IF cl_null(g_fat[l_ac].fat08) THEN
               LET g_fat[l_ac].fat08 = ' '
            END IF
           #FUN-AB0088---mark---str---
           #IF g_aza.aza63 = 'Y' THEN  
           #   IF cl_null(g_fat[l_ac].fat081) THEN
           #      LET g_fat[l_ac].fat081 = ' '
           #   END IF
           #END IF
           #FUN-AB0088---mark---end----
            IF cl_null(g_fat[l_ac].fat09) THEN
               LET g_fat[l_ac].fat09 = ' '
            END IF
            IF cl_null(g_fat[l_ac].fat10) THEN
               LET g_fat[l_ac].fat10 = ' '
            END IF
            IF cl_null(g_fat[l_ac].fat11) THEN
               LET g_fat[l_ac].fat11 = ' '
            END IF
           #FUN-AB0088---mark---str------------- 
           #IF g_aza.aza63 = 'Y' THEN  
           #   IF cl_null(g_fat[l_ac].fat111) THEN
           #      LET g_fat[l_ac].fat111 = ' '
           #   END IF
           #END IF
           #FUN-AB0088---mark---end--------
            IF cl_null(g_fat[l_ac].fat031) THEN
               LET g_fat[l_ac].fat031 = ' '
            END IF
             INSERT INTO fat_file (fat01,fat02,fat03,fat031,fat04,fat05,  #No.MOD-470041
                                  fat06,fat07,fat071,fat08,fat081,fat09,fat10,fat11,fat111 
                                 ,fat092,fat102    #FUN-AB0088 add
                                 ,fatud01,fatud02,fatud03, fatud04,fatud05,fatud06,
                                  fatud07,fatud08,fatud09, fatud10,fatud11,fatud12,
                                  fatud13,fatud14,fatud15,
                                  fatlegal)
                 VALUES(g_fas.fas01,g_fat[l_ac].fat02,g_fat[l_ac].fat03,
                        g_fat[l_ac].fat031,g_fat[l_ac].fat04,g_fat[l_ac].fat05,
                       #g_fat[l_ac].fat06,g_fat[l_ac].fat07,g_fat[l_ac].fat071,     #No.FUN-680028  #FUN-AB0088 mark
                       #g_fat[l_ac].fat06,g_fat[l_ac].fat07,'',                     #FUN-AB0088 add #MOD-C20030 mark
                        g_fat[l_ac].fat06,g_fat[l_ac].fat07,g_faj531,               #MOD-C20030 add
                       #g_fat[l_ac].fat08,g_fat[l_ac].fat081,g_fat[l_ac].fat09,     #No.FUN-680028  #FUN-AB0088 mark
                       #g_fat[l_ac].fat08,'',g_fat[l_ac].fat09,                     #FUN-AB0088 add #MOD-C20030 mark
                        g_fat[l_ac].fat08,g_faj541,g_fat[l_ac].fat09,               #MOD-C20030 add
                       #g_fat[l_ac].fat10,g_fat[l_ac].fat11,g_fat[l_ac].fat111      #No.FUN-680028  #FUN-AB0088 mark
                       #g_fat[l_ac].fat10,g_fat[l_ac].fat11,'',                     #FUN-AB0088 add #MOD-C20030 mark
                        g_fat[l_ac].fat10,g_fat[l_ac].fat11,g_faj551,               #MOD-C20030 add
                        1,''                                                        #FUN-AB0088 add                       
                       ,g_fat[l_ac].fatud01, g_fat[l_ac].fatud02,
                        g_fat[l_ac].fatud03, g_fat[l_ac].fatud04,
                        g_fat[l_ac].fatud05, g_fat[l_ac].fatud06,
                        g_fat[l_ac].fatud07, g_fat[l_ac].fatud08,
                        g_fat[l_ac].fatud09, g_fat[l_ac].fatud10,
                        g_fat[l_ac].fatud11, g_fat[l_ac].fatud12,
                        g_fat[l_ac].fatud13, g_fat[l_ac].fatud14,
                        g_fat[l_ac].fatud15,
                        g_legal) #FUN-980003 add
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0  THEN
               CALL cl_err3("ins","fat_file",g_fas.fas01,g_fat[l_ac].fat02,SQLCA.sqlcode,"","ins fat",1)  #No.FUN-660136
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET l_fas09 = '0'   #FUN-580109
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd = 'a'
            INITIALIZE g_fat[l_ac].* TO NULL      #900423
            LET g_fat_t.* = g_fat[l_ac].*             #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fat02
 
        BEFORE FIELD fat02                            #defaslt 序號
            IF p_cmd = 'a' OR p_cmd = 'u' THEN
               IF g_fat[l_ac].fat02 IS NULL OR g_fat[l_ac].fat02 = 0 THEN
                   SELECT max(fat02)+1 INTO g_fat[l_ac].fat02
                      FROM fat_file WHERE fat01 = g_fas.fas01
                   IF g_fat[l_ac].fat02 IS NULL THEN
                       LET g_fat[l_ac].fat02 = 1
                   END IF
               END IF
            END IF
 
        AFTER FIELD fat02                        #check 序號是否重複
            IF g_fat[l_ac].fat02 != g_fat_t.fat02 OR
               g_fat_t.fat02 IS NULL THEN
                SELECT count(*) INTO l_n FROM fat_file
                 WHERE fat01 = g_fas.fas01
                   AND fat02 = g_fat[l_ac].fat02
                IF l_n > 0 THEN
                    LET g_fat[l_ac].fat02 = g_fat_t.fat02
                    CALL cl_err('',-239,0)
                    NEXT FIELD fat02
                END IF
            END IF

       #FUN-BC0004--mark--str
       ##modify TQC-AB0144----begin-------------------
       #AFTER FIELD fat03
       #   IF g_fat[l_ac].fat03 != g_fat_t.fat03 OR
       #      g_fat_t.fat03 IS NULL THEN
       #      SELECT COUNT(*) INTO l_n FROM faj_file
       #       WHERE fajconf='Y'
       #         AND faj02 = g_fat[l_ac].fat03
       #      IF l_n <= 0 THEN
       #         LET g_fat[l_ac].fat03 = g_fat_t.fat03
       #         CALL cl_err('','afa-911',0)
       #         NEXT FIELD fat03
       #      END IF
       #   END IF
       ##modify TQC-AB0144-----end--------------------
       #FUN-BC0004--mark--end
        #FUN-BC0004--add--str
        AFTER FIELD fat03
           IF g_fat[l_ac].fat031 IS NULL THEN
              LET g_fat[l_ac].fat031 = ' '
           END IF
           IF NOT cl_null(g_fat[l_ac].fat03) AND g_fat[l_ac].fat031 IS NOT NULL THEN
              SELECT COUNT(*) INTO g_cnt FROM fca_file
               WHERE fca03  = g_fat[l_ac].fat03
                 AND fca031 = g_fat[l_ac].fat031
                 AND fca15  = 'N'
              IF g_cnt > 0 THEN
                 CALL cl_err(g_fat[l_ac].fat03,'afa-097',0)
                 NEXT FIELD fat03
              END IF
              SELECT faj100 INTO l_faj100 FROM faj_file
               WHERE faj02  = g_fat[l_ac].fat03
                 AND faj022 = g_fat[l_ac].fat031
              IF l_faj100 > g_fas.fas02 THEN
                 CALL cl_err(g_fas.fas02,'afa-113',0)
                 NEXT FIELD fat03
              END IF
              SELECT count(*) INTO l_n FROM faj_file
               WHERE faj02 =g_fat[l_ac].fat03
              IF l_n > 0 THEN 
                 CALL t102_fat031('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fat[l_ac].fat031,g_errno,0)
                    NEXT FIELD fat031
                 END IF
              ELSE 
                #CALL cl_err(g_fat[l_ac].fat03,'afa-093',0)    #MOD-C70265 mark
                 CALL cl_err(g_fat[l_ac].fat03,'afa-134',0)    #MOD-C70265 add
                 LET g_fat[l_ac].fat03 = g_fat_t.fat03
                 NEXT FIELD fat03
                 #-->免稅資料
                 IF g_faj40 = '3' THEN
                    LET g_errno = 'afa-305'
                    CALL cl_err(g_fat[l_ac].fat03,g_errno,1)
                 END IF
              END IF
           END IF 
        #FUN-BC0004--add--end
 
        AFTER FIELD fat031
           IF g_fat[l_ac].fat031 IS NULL THEN
              LET g_fat[l_ac].fat031 = ' '
           END IF
           IF NOT cl_null(g_fat[l_ac].fat03) THEN
              SELECT COUNT(*) INTO g_cnt FROM fca_file
               WHERE fca03  = g_fat[l_ac].fat03
                 AND fca031 = g_fat[l_ac].fat031
                 AND fca15  = 'N'
               IF g_cnt > 0 THEN
                  CALL cl_err(g_fat[l_ac].fat03,'afa-097',0)
                  NEXT FIELD fat03
               END IF
              SELECT faj100 INTO l_faj100 FROM faj_file
               WHERE faj02  = g_fat[l_ac].fat03
                 AND faj022 = g_fat[l_ac].fat031
              IF l_faj100 > g_fas.fas02 THEN
                 CALL cl_err(g_fas.fas02,'afa-113',0)
                 NEXT FIELD fat03
              END IF
              CALL t102_fat031('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_fat[l_ac].fat031,g_errno,0)
                   LET g_fat[l_ac].fat031 = g_fat_t.fat031 #FUN-BC0004--add
                   NEXT FIELD fat03
                END IF
               #-->免稅資料
               IF g_faj40 = '3' THEN
                  LET g_errno = 'afa-305'
                  CALL cl_err(g_fat[l_ac].fat03,g_errno,1)
               END IF
           END IF
           #LET g_fat_t.fat03  = g_fat[l_ac].fat03 #FUN-BC0004 mark
           #LET g_fat_t.fat031 = g_fat[l_ac].fat031#FUN-BC0004 mark
          #SELECT faj09 INTO l_faj09 FROM faj_file                 #MOD-BB0112 mark
           SELECT faj09,faj28 INTO l_faj09,l_faj28 FROM faj_file   #MOD-BB0112
            WHERE faj02  = g_fat[l_ac].fat03                                    
              AND faj022 = g_fat[l_ac].fat031                                   
          #IF l_faj09 = '5' THEN                    #MOD-BB0122 mark
           IF l_faj09 = '5' OR l_faj28 = '0' THEN   #MOD-BB0112
             #CALL cl_set_comp_required("fat07,fat08",FALSE)         #MOD-BB0112 mark
              CALL cl_set_comp_required("fat07,fat08,fat11",FALSE)   #MOD-BB0112
           ELSE                                                                 
             #CALL cl_set_comp_required("fat07,fat08",TRUE)          #MOD-BB0112 mark
              CALL cl_set_comp_required("fat07,fat08,fat11",TRUE)    #MOD-BB0112
           END IF                                                               
        AFTER FIELD fat04
           IF NOT cl_null(g_fat[l_ac].fat04) THEN
              CALL t102_fat04('a')
              IF NOT cl_null(g_errno) THEN
                 LET g_fat[l_ac].fat04 = g_fat_t.fat04
                 DISPLAY BY NAME g_fat[l_ac].fat04
                 CALL cl_err(g_fat[l_ac].fat04,g_errno,0)
                 NEXT FIELD fat04
              END IF
          END IF
 
        AFTER FIELD fat05
           IF NOT cl_null(g_fat[l_ac].fat05) THEN
              CALL t102_fat05('a')
              IF NOT cl_null(g_errno) THEN
                 LET g_fat[l_ac].fat05 = g_fat_t.fat05
                 CALL cl_err(g_fat[l_ac].fat05,g_errno,0)
                 DISPLAY BY NAME g_fat[l_ac].fat05
                 NEXT FIELD fat05
              END IF
              SELECT faj04
                INTO l_faj04
                FROM faj_file
               WHERE faj02 = g_fat[l_ac].fat03
                 AND faj022= g_fat[l_ac].fat031
              LET l_faj20 = g_fat[l_ac].fat05 
              IF g_faa.faa20 = '2' THEN
                  DECLARE t102_fbi2
                      CURSOR FOR SELECT fbi02,fbi021 FROM fbi_file
                                             WHERE fbi01 = l_faj20
                                               AND fbi03 = l_faj04
                  FOREACH t102_fbi2 INTO l_fbi02,l_fbi021
                    IF SQLCA.sqlcode THEN EXIT FOREACH END IF
                    IF not cl_null(l_fbi02) THEN ROLLBACK WORK EXIT FOREACH END IF
                  END FOREACH
                  LET g_fat[l_ac].fat11 = l_fbi02
                  DISPLAY BY NAME g_fat[l_ac].fat11
                 #FUN-AB0088---mark---str--- 
                 #IF g_aza.aza63 = 'Y' THEN  
                 #   LET g_fat[l_ac].fat111 = l_fbi021
                 #   DISPLAY BY NAME g_fat[l_ac].fat111
                 #END IF
                 #FUN-AB0088---mark---end---
              END IF
           END IF
 
        AFTER FIELD fat06
           IF NOT cl_null(g_fat[l_ac].fat06) THEN
              CALL t102_fat06('a')
              IF NOT cl_null(g_errno) THEN
                 LET g_fat[l_ac].fat06 = g_fat_t.fat06
                 DISPLAY BY NAME g_fat[l_ac].fat06
                 CALL cl_err(g_fat[l_ac].fat06,g_errno,0)
                 NEXT FIELD fat06
              END IF
           END IF
 
        AFTER FIELD fat07
           IF NOT cl_null(g_fat[l_ac].fat07) THEN
              CALL t102_fat07('a')
              IF NOT cl_null(g_errno) THEN
                 #LET g_fat[l_ac].fat07 = g_fat_t.fat07  #FUN-B10049
                 #DISPLAY BY NAME g_fat[l_ac].fat07      #FUN-B10049
                 CALL cl_err(g_fat[l_ac].fat07,g_errno,0)
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fat[l_ac].fat07 
                 LET g_qryparam.construct = 'N'                
                 LET g_qryparam.arg1 = g_bookno1  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aagacti='Y' AND aag01 LIKE '",g_fat[l_ac].fat07 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fat[l_ac].fat07
                 DISPLAY BY NAME g_fat[l_ac].fat07
                 #FUN-B10049--end                    
                 NEXT FIELD fat07
              END IF
           END IF
 
       #FUN-AB0088---mark---str--- 
       #AFTER FIELD fat071
       #   IF NOT cl_null(g_fat[l_ac].fat071) THEN
       #      CALL t102_fat071('a')
       #      IF NOT cl_null(g_errno) THEN
       #         #LET g_fat[l_ac].fat071 = g_fat_t.fat071
       #         #DISPLAY BY NAME g_fat[l_ac].fat071
       #         CALL cl_err(g_fat[l_ac].fat071,g_errno,0)
       #         #FUN-B10049--begin
       #         CALL cl_init_qry_var()                                         
       #         LET g_qryparam.form ="q_aag"                                   
       #         LET g_qryparam.default1 = g_fat[l_ac].fat071 
       #         LET g_qryparam.construct = 'N'                
       #         LET g_qryparam.arg1 = g_bookno2  
       #         LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aagacti='Y' AND aag01 LIKE '",g_fat[l_ac].fat071 CLIPPED,"%' "                                                                        
       #         CALL cl_create_qry() RETURNING g_fat[l_ac].fat071
       #         DISPLAY BY NAME g_fat[l_ac].fat071
       #         #FUN-B10049--end                     
       #         NEXT FIELD fat071
       #      END IF
       #   END IF
       #FUN-AB0088---mark---end---
 
        AFTER FIELD fat08
           LET l_faj28 = ''
           SELECT faj28 INTO l_faj28 FROM faj_file
            WHERE faj02 = g_fat[l_ac].fat03
              AND faj022= g_fat[l_ac].fat031
           IF cl_null(g_fat[l_ac].fat08) AND l_faj28 != '0' THEN
              NEXT FIELD fat08
           END IF
           IF NOT cl_null(g_fat[l_ac].fat08) THEN
              CALL t102_fat08('a')
              IF NOT cl_null(g_errno) THEN
                 #LET g_fat[l_ac].fat08 = g_fat_t.fat08
                 #DISPLAY BY NAME g_fat[l_ac].fat08
                 CALL cl_err(g_fat[l_ac].fat08,g_errno,0)
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fat[l_ac].fat08 
                 LET g_qryparam.construct = 'N'                
                 LET g_qryparam.arg1 = g_bookno1  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aagacti='Y' AND aag01 LIKE '",g_fat[l_ac].fat08 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fat[l_ac].fat08
                 DISPLAY BY NAME g_fat[l_ac].fat08
                 #FUN-B10049--end  
                 NEXT FIELD fat08
              END IF
           END IF
       #FUN-AB0088---add---str---  
       #AFTER FIELD fat081
       #   LET l_faj28 = ''
       #   SELECT faj28 INTO l_faj28 FROM faj_file
       #    WHERE faj02 = g_fat[l_ac].fat03
       #      AND faj022= g_fat[l_ac].fat031
       #   IF cl_null(g_fat[l_ac].fat081) AND l_faj28 != '0' THEN
       #      NEXT FIELD fat081
       #   END IF
       #   IF NOT cl_null(g_fat[l_ac].fat081) THEN
       #      CALL t102_fat081('a')
       #      IF NOT cl_null(g_errno) THEN
       #         #LET g_fat[l_ac].fat081 = g_fat_t.fat081
       #         #DISPLAY BY NAME g_fat[l_ac].fat081
       #         CALL cl_err(g_fat[l_ac].fat081,g_errno,0)
       #         #FUN-B10049--begin
       #         CALL cl_init_qry_var()                                         
       #         LET g_qryparam.form ="q_aag"                                   
       #         LET g_qryparam.default1 = g_fat[l_ac].fat081 
       #         LET g_qryparam.construct = 'N'                
       #         LET g_qryparam.arg1 = g_bookno2  
       #         LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aagacti='Y' AND aag01 LIKE '",g_fat[l_ac].fat081 CLIPPED,"%' "                                                                        
       #         CALL cl_create_qry() RETURNING g_fat[l_ac].fat081
       #         DISPLAY BY NAME g_fat[l_ac].fat081
       #         #FUN-B10049--end                       
       #         NEXT FIELD fat081
       #      END IF
       #   END IF
       #FUN-AB0088---add---end---
 
        AFTER FIELD fat09
           IF NOT cl_null(g_fat[l_ac].fat09) THEN
              IF g_fat[l_ac].fat09 NOT MATCHES '[12]' THEN
                 NEXT FIELD fat09
              END IF
           END IF
 
        BEFORE FIELD fat10
           IF g_fat[l_ac].fat09 = '1' THEN
              IF cl_null(g_fat[l_ac].fat10) THEN
                 LET g_fat[l_ac].fat10 = g_fat[l_ac].fat05
                 DISPLAY BY NAME g_fat[l_ac].fat10
              END IF
           END IF
 
        AFTER FIELD fat10
           IF NOT cl_null(g_fat[l_ac].fat10) THEN
              IF g_fat[l_ac].fat09 = '1' THEN
                #CALL t102_fat101('a')              #No.MOD-B90006 mark
                 CALL t102_fat101('1')              #No.MOD-B90006 add
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_fat[l_ac].fat10,g_errno,0)
                      LET g_fat[l_ac].fat10 = g_fat_t.fat10
                      DISPLAY BY NAME g_fat[l_ac].fat10
                      NEXT FIELD fat10
                   END IF
              ELSE
                 CALL t102_fat102('a')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_fat[l_ac].fat10,g_errno,0)
                      LET g_fat[l_ac].fat10 = g_fat_t.fat10
 
                      NEXT FIELD fat10
                   END IF
                   SELECT faj55 INTO g_fat[l_ac].fat11 FROM faj_file
                        WHERE faj02=g_fat[l_ac].fat03 AND
                              faj022=g_fat[l_ac].fat031
                   IF SQLCA.sqlcode THEN LET g_fat[l_ac].fat11 = ' ' END IF
              END IF
           END IF
 
        AFTER FIELD fat11
            LET l_faj28 = ''
           SELECT faj28 INTO l_faj28 FROM faj_file
            WHERE faj02 = g_fat[l_ac].fat03
              AND faj022= g_fat[l_ac].fat031
           IF cl_null(g_fat[l_ac].fat11) AND l_faj28 != '0' THEN
              NEXT FIELD fat11
           END IF
           IF NOT cl_null(g_fat[l_ac].fat11) THEN
              CALL t102_fat11('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_fat[l_ac].fat11,g_errno,0)
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fat[l_ac].fat11
                 LET g_qryparam.construct = 'N'                
                 LET g_qryparam.arg1 = g_bookno1  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aagacti='Y' AND aag01 LIKE '",g_fat[l_ac].fat11 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fat[l_ac].fat11
                 DISPLAY BY NAME g_fat[l_ac].fat11
                 #FUN-B10049--end                     
                 NEXT FIELD fat11
              END IF
           END IF
         
       #FUN-AB0088---mark---str---
       #AFTER FIELD fat111
       #    LET l_faj28 = ''
       #   SELECT faj28 INTO l_faj28 FROM faj_file
       #    WHERE faj02 = g_fat[l_ac].fat03
       #      AND faj022= g_fat[l_ac].fat031
       #   IF cl_null(g_fat[l_ac].fat111) AND l_faj28 != '0' THEN
       #      NEXT FIELD fat111
       #   END IF
       #   IF NOT cl_null(g_fat[l_ac].fat111) THEN
       #      CALL t102_fat111('a')
       #      IF NOT cl_null(g_errno) THEN
       #         CALL cl_err(g_fat[l_ac].fat111,g_errno,0)
       #         #FUN-B10049--begin
       #         CALL cl_init_qry_var()                                         
       #         LET g_qryparam.form ="q_aag"                                   
       #         LET g_qryparam.default1 = g_fat[l_ac].fat111
       #         LET g_qryparam.construct = 'N'                
       #         LET g_qryparam.arg1 = g_bookno2  
       #         LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aagacti='Y' AND aag01 LIKE '",g_fat[l_ac].fat111 CLIPPED,"%' "                                                                        
       #         CALL cl_create_qry() RETURNING g_fat[l_ac].fat111
       #         DISPLAY BY NAME g_fat[l_ac].fat111
       #         #FUN-B10049--end                         
       #         NEXT FIELD fat111
       #      END IF
       #   END IF
       #FUN-AB0088---mark---end---
 
        AFTER FIELD fatud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fatud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fatud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fatud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fatud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fatud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fatud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fatud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fatud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fatud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fatud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fatud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fatud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fatud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fatud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_fat_t.fat02 > 0 AND g_fat_t.fat02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM fat_file
                 WHERE fat01 = g_fas.fas01
                   AND fat02 = g_fat_t.fat02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","fat_file",g_fas.fas01,g_fat_t.fat02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET l_fas09 = '0'   #FUN-580109
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fat[l_ac].* = g_fat_t.*
               CLOSE t102_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF g_fat[l_ac].fat03 IS NOT NULL AND g_fat[l_ac].fat03 != ' ' THEN
               CALL t102_fat031('d')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fat[l_ac].fat031,g_errno,0)
                  NEXT FIELD fat02
               END IF
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fat[l_ac].fat02,-263,1)
               LET g_fat[l_ac].* = g_fat_t.*
            ELSE
               IF cl_null(g_fat[l_ac].fat04) THEN
                  LET g_fat[l_ac].fat04 = ' '
               END IF
               IF cl_null(g_fat[l_ac].fat05) THEN
                  LET g_fat[l_ac].fat05 = ' '
               END IF
               IF cl_null(g_fat[l_ac].fat06) THEN
                  LET g_fat[l_ac].fat06 = ' '
               END IF
               IF cl_null(g_fat[l_ac].fat07) THEN
                  LET g_fat[l_ac].fat07 = ' '
               END IF
              #FUN-AB0088---mark---str---
              #IF g_aza.aza63 = 'Y' THEN 
              #   IF cl_null(g_fat[l_ac].fat071) THEN
              #      LET g_fat[l_ac].fat071 = ' '
              #   END IF
              #END IF
              #FUN-AB0088---mark---end---
               IF cl_null(g_fat[l_ac].fat08) THEN
                  LET g_fat[l_ac].fat08 = ' '
               END IF
              #FUN-AB0088---mark---str---
              #IF g_aza.aza63 = 'Y' THEN 
              #   IF cl_null(g_fat[l_ac].fat081) THEN
              #      LET g_fat[l_ac].fat081 = ' '
              #   END IF
              #END IF
              #FUN-AB0088---mark---end---
               IF cl_null(g_fat[l_ac].fat09) THEN
                  LET g_fat[l_ac].fat09 = ' '
               END IF
               IF cl_null(g_fat[l_ac].fat10) THEN
                  LET g_fat[l_ac].fat10 = ' '
               END IF
               IF cl_null(g_fat[l_ac].fat11) THEN
                  LET g_fat[l_ac].fat11 = ' '
               END IF
              #FUN-AB0088---mark---str---
              #IF g_aza.aza63 = 'Y' THEN 
              #   IF cl_null(g_fat[l_ac].fat111) THEN
              #      LET g_fat[l_ac].fat111 = ' '
              #   END IF
              #END IF
              #FUN-AB0088---mark---end---
               UPDATE fat_file SET
                      fat01=g_fas.fas01,fat02=g_fat[l_ac].fat02,
                      fat03=g_fat[l_ac].fat03,fat031=g_fat[l_ac].fat031,
                      fat04=g_fat[l_ac].fat04,fat05=g_fat[l_ac].fat05,
                      fat06=g_fat[l_ac].fat06,fat07=g_fat[l_ac].fat07,
                     #fat071=g_fat[l_ac].fat071,fat08=g_fat[l_ac].fat08,     #No.FUN-680028  #FUN-AB0088 mark
                     #fat081=g_fat[l_ac].fat081,fat09=g_fat[l_ac].fat09,     #No.FUN-680028  #FUN-AB0088 mark
                      fat08=g_fat[l_ac].fat08,                               #FUN-AB0088 add  
                      fat09=g_fat[l_ac].fat09,                               #FUN-AB0088 add
                      fat10=g_fat[l_ac].fat10,fat11=g_fat[l_ac].fat11,
                     #fat111=g_fat[l_ac].fat111     #No.FUN-680028           #FUN-AB0088 mark
                      fatud01 = g_fat[l_ac].fatud01,
                      fatud02 = g_fat[l_ac].fatud02,
                      fatud03 = g_fat[l_ac].fatud03,
                      fatud04 = g_fat[l_ac].fatud04,
                      fatud05 = g_fat[l_ac].fatud05,
                      fatud06 = g_fat[l_ac].fatud06,
                      fatud07 = g_fat[l_ac].fatud07,
                      fatud08 = g_fat[l_ac].fatud08,
                      fatud09 = g_fat[l_ac].fatud09,
                      fatud10 = g_fat[l_ac].fatud10,
                      fatud11 = g_fat[l_ac].fatud11,
                      fatud12 = g_fat[l_ac].fatud12,
                      fatud13 = g_fat[l_ac].fatud13,
                      fatud14 = g_fat[l_ac].fatud14,
                      fatud15 = g_fat[l_ac].fatud15
                      WHERE fat01=g_fas.fas01 AND fat02=g_fat_t.fat02
 
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                  CALL cl_err3("upd","fat_file",g_fas.fas01,g_fat_t.fat02,SQLCA.sqlcode,"","upd fat",1)  #No.FUN-660136
                  LET g_fat[l_ac].* = g_fat_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  LET l_fas09 = '0'   #FUN-580109
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30032 mark
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_fat[l_ac].* = g_fat_t.*
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_fat.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF
               CLOSE t102_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032 add
            CLOSE t102_bcl
            COMMIT WORK
 
             CALL g_fat.deleteElement(g_rec_b+1)
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fat02) AND l_ac > 1 THEN
                LET g_fat[l_ac].* = g_fat[l_ac-1].*
                LET g_fat[l_ac].fat02 = NULL
                NEXT FIELD fat02
            END IF
        ON ACTION controlp   #ok
           CASE
              WHEN INFIELD(fat03)  #財產編號,財產附號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.default1 = g_fat[l_ac].fat03
                 LET g_qryparam.default2 = g_fat[l_ac].fat031
                 CALL cl_create_qry() RETURNING g_fat[l_ac].fat03,g_fat[l_ac].fat031
                 DISPLAY g_fat[l_ac].fat03 TO fat03
                 DISPLAY g_fat[l_ac].fat031 TO fat031
                 CALL t102_fat031('d')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(' ',g_errno,0)
                    NEXT FIELD fat03
                 END IF
                 NEXT FIELD fat03
              WHEN INFIELD(fat04)  #保管人員
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_fat[l_ac].fat04
                 CALL cl_create_qry() RETURNING g_fat[l_ac].fat04
                  DISPLAY g_fat[l_ac].fat04 TO fat04              #No.MOD-490344
                 NEXT FIELD fat04
              WHEN INFIELD(fat05)  #保管部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_fat[l_ac].fat05
                 CALL cl_create_qry() RETURNING g_fat[l_ac].fat05
                  DISPLAY g_fat[l_ac].fat05 TO fat05              #No.MOD-490344
                 NEXT FIELD fat05
              WHEN INFIELD(fat06)  #存放位置
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faf"
                 LET g_qryparam.default1 = g_fat[l_ac].fat06
                 CALL cl_create_qry() RETURNING g_fat[l_ac].fat06
                  DISPLAY g_fat[l_ac].fat06 TO fat06              #No.MOD-490344
                 NEXT FIELD fat06
              WHEN INFIELD(fat07)  #資產科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' "
                 LET g_qryparam.default1 = g_fat[l_ac].fat07
                 LET g_qryparam.arg1 = g_bookno1  #No.FUN-740033
                 CALL cl_create_qry() RETURNING g_fat[l_ac].fat07
                  DISPLAY g_fat[l_ac].fat07 TO fat07              #No.MOD-490344
                 NEXT FIELD fat07
             #FUN-AB0088---mark---str---
             #WHEN INFIELD(fat071)  #資產科目
             #   CALL cl_init_qry_var()
             #   LET g_qryparam.form = "q_aag"
             #   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' "
             #   LET g_qryparam.default1 = g_fat[l_ac].fat071
             #   LET g_qryparam.arg1 = g_bookno2  #No.FUN-740033
             #   CALL cl_create_qry() RETURNING g_fat[l_ac].fat071
             #    DISPLAY g_fat[l_ac].fat071 TO fat071
             #   NEXT FIELD fat071
             #FUN-AB0088---mark---end---

              WHEN INFIELD(fat08)  #累折科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' "
                 LET g_qryparam.default1 = g_fat[l_ac].fat08
                 LET g_qryparam.arg1 = g_bookno1  #No.FUN-740033
                 CALL cl_create_qry() RETURNING g_fat[l_ac].fat08
                  DISPLAY g_fat[l_ac].fat08 TO fat08              #No.MOD-490344
                 NEXT FIELD fat08
             
             #FUN-AB0088---mark---str---
             #WHEN INFIELD(fat081)  #累折科目
             #   CALL cl_init_qry_var()
             #   LET g_qryparam.form = "q_aag"
             #   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' "
             #   LET g_qryparam.default1 = g_fat[l_ac].fat081
             #   LET g_qryparam.arg1 = g_bookno2  #No.FUN-740033
             #   CALL cl_create_qry() RETURNING g_fat[l_ac].fat081
             #    DISPLAY g_fat[l_ac].fat081 TO fat081
             #   NEXT FIELD fat081
             #FUN-AB0088---mark---end---
              WHEN INFIELD(fat10)  #分攤部門
                IF g_fat[l_ac].fat09='1' THEN
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_fat[l_ac].fat10
                 CALL cl_create_qry() RETURNING g_fat[l_ac].fat10
                  DISPLAY g_fat[l_ac].fat10 TO fat10              #No.MOD-490344
                 NEXT FIELD fat10
                ELSE
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ='q_fad'
                  LET g_qryparam.default1 =g_fat[l_ac].fat10
                  CALL cl_create_qry() RETURNING
                       g_fat[l_ac].fat07,g_fat[l_ac].fat10
                  DISPLAY g_fat[l_ac].fat10 TO fat10
                  DISPLAY g_fat[l_ac].fat07 TO fat07
                  NEXT FIELD fat10
                END IF
              WHEN INFIELD(fat11)  #折舊科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' "
                 LET g_qryparam.default1 = g_fat[l_ac].fat11
                 LET g_qryparam.arg1 = g_bookno1  #No.FUN-740033
                 CALL cl_create_qry() RETURNING g_fat[l_ac].fat11
                  DISPLAY g_fat[l_ac].fat11 TO fat11              #No.MOD-490344
                 NEXT FIELD fat11
             #FUN-AB0088---mark---str---
             #WHEN INFIELD(fat111)  #折舊科目
             #   CALL cl_init_qry_var()
             #   LET g_qryparam.form = "q_aag"
             #   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' "
             #   LET g_qryparam.default1 = g_fat[l_ac].fat111
             #   LET g_qryparam.arg1 = g_bookno2  #No.FUN-740033
             #   CALL cl_create_qry() RETURNING g_fat[l_ac].fat111
             #    DISPLAY g_fat[l_ac].fat111 TO fat111  
             #   NEXT FIELD fat111
             #FUN-AB0088---mark---end---
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON ACTION multi_dept_depr  #分攤部門
                  CALL cl_cmdrun('afai030' CLIPPED)
 
        ON ACTION multi_dept_depr_q  #分攤部門
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ='q_fad'
                  LET g_qryparam.default1 =g_fat[l_ac].fat10
                  CALL cl_create_qry() RETURNING
                       g_fat[l_ac].fat07,g_fat[l_ac].fat10
                  DISPLAY g_fat[l_ac].fat10 TO fat10
                  DISPLAY g_fat[l_ac].fat07 TO fat07
                  NEXT FIELD fat10
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
      END INPUT
 
      LET g_fas.fasmodu = g_user
      LET g_fas.fasdate = g_today
      UPDATE fas_file SET fasmodu = g_fas.fasmodu,fasdate = g_fas.fasdate
       WHERE fas01 = g_fas.fas01
      DISPLAY BY NAME g_fas.fasmodu,g_fas.fasdate
 
      UPDATE fas_file SET fas09=l_fas09 WHERE fas01 = g_fas.fas01
      LET g_fas.fas09 = l_fas09
      DISPLAY BY NAME g_fas.fas09
      IF g_fas.fasconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
      IF g_fas.fas09 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
      CALL cl_set_field_pic(g_fas.fasconf,g_chr2,g_fas.faspost,"",g_chr,"")
 
      CLOSE t102_bcl
      COMMIT WORK
      CALL t102_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t102_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_fas.fas01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM fas_file ",
                  "  WHERE fas01 LIKE '",l_slip,"%' ",
                  "    AND fas01 > '",g_fas.fas01,"'"
      PREPARE t102_pb1 FROM l_sql 
      EXECUTE t102_pb1 INTO l_cnt  
      
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
        #CALL t102_x()           #FUN-D20035
         CALL t102_x(1)          #FUN-D20035
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM npp_file WHERE nppsys = 'FA' AND npp00 = 2
                                AND npp01 = g_fas.fas01
                                AND npp011= 1
         DELETE FROM npq_file WHERE npqsys = 'FA' AND npq00 = 2
                                AND npq01 = g_fas.fas01
                                AND npq011= 1
         DELETE FROM tic_file WHERE tic04 = g_fas.fas01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM fas_file WHERE fas01 = g_fas.fas01
         INITIALIZE g_fas.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t102_fat031(p_cmd)
DEFINE   p_cmd       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
         l_n         LIKE type_file.num5,         #No.FUN-680070 SMALLINT
         l_faj06     LIKE faj_file.faj06,
         l_faj19     LIKE faj_file.faj19,
         l_faj20     LIKE faj_file.faj20,
         l_faj21     LIKE faj_file.faj21,
         l_faj53     LIKE faj_file.faj53,
         l_faj54     LIKE faj_file.faj54,
         l_faj55     LIKE faj_file.faj55,
         l_faj531    LIKE faj_file.faj531,     #No.FUN-680028
         l_faj541    LIKE faj_file.faj541,     #No.FUN-680028
         l_faj551    LIKE faj_file.faj551,     #No.FUN-680028
         l_faj23     LIKE faj_file.faj23,
         l_faj24     LIKE faj_file.faj24
 
    LET g_errno = ' '
    LET g_faj531 = ' '                         #MOD-C20030 add
    LET g_faj541 = ' '                         #MOD-C20030 add
    LET g_faj551 = ' '                         #MOD-C20030 add
    IF ((g_fat[l_ac].fat03 != g_fat_t.fat03 OR g_fat_t.fat03 IS NULL) OR
        (g_fat[l_ac].fat031 != g_fat_t.fat031 OR g_fat_t.fat031 IS NULL)) THEN
      SELECT count(*) INTO l_n FROM fat_file
       WHERE fat01  = g_fas.fas01
         AND fat03  = g_fat[l_ac].fat03
         AND fat031 = g_fat[l_ac].fat031
       IF l_n > 0 THEN
          LET g_errno = 'afa-105'
          RETURN
       END IF
      SELECT count(*) INTO l_n FROM fat_file,fas_file
        WHERE fat01 = fas01
         AND fat03  = g_fat[l_ac].fat03
         AND fat031 = g_fat[l_ac].fat031
         AND fas02 <= g_fas.fas02
         AND faspost = 'N'
         AND fas01 != g_fas.fas01
         AND fasconf <> 'X'   #MOD-590470
      IF l_n  > 0 THEN
          LET g_errno = 'afa-309'
          RETURN
       END IF
      SELECT faj06,faj19,faj20,faj21,faj23,faj24,faj53,faj54,faj55,faj40,faj531,faj541,faj551     #No.FUN-680028
        INTO l_faj06,l_faj19,l_faj20,l_faj21,l_faj23,l_faj24,l_faj53,
             l_faj54,l_faj55,g_faj40,
            #l_faj531,l_faj541,l_faj551     #No.FUN-680028 #MOD-C20030 mark
             g_faj531,g_faj541,g_faj551     #MOD-C20030 add
        FrOM faj_file
       WHERE faj02  = g_fat[l_ac].fat03
         AND faj022 = g_fat[l_ac].fat031
         AND faj43  NOT IN ('0','5','6','X')
         AND fajconf = 'Y'
     CASE
        #WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-093'    #MOD-C70265 mark
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-134'    #MOD-C70265 add
         OTHERWISE LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     IF p_cmd = 'a' THEN
        LET g_fat[l_ac].fat04 = l_faj19
        LET g_fat[l_ac].fat05 = l_faj20
        LET g_fat[l_ac].fat06 = l_faj21
        LET g_fat[l_ac].fat07 = l_faj53
        LET g_fat[l_ac].fat08 = l_faj54
        LET g_fat[l_ac].fat09 = l_faj23
        LET g_fat[l_ac].fat10 = l_faj24
        LET g_fat[l_ac].fat11 = l_faj55
        LET g_fat[l_ac].faj06 = l_faj06
       #FUN-AB0088---mark---str---
       #IF g_aza.aza63 = 'Y' THEN 
       #   LET g_fat[l_ac].fat071= l_faj531
       #   LET g_fat[l_ac].fat081= l_faj541
       #   LET g_fat[l_ac].fat111= l_faj551
       #END IF
       #FUN-AB0088---mark---end---
        DISPLAY BY NAME g_fat[l_ac].fat04
        DISPLAY BY NAME g_fat[l_ac].fat04
        DISPLAY BY NAME g_fat[l_ac].fat06
        DISPLAY BY NAME g_fat[l_ac].fat07
        DISPLAY BY NAME g_fat[l_ac].fat08
        DISPLAY BY NAME g_fat[l_ac].fat09
        DISPLAY BY NAME g_fat[l_ac].fat09
        DISPLAY BY NAME g_fat[l_ac].fat11
        DISPLAY BY NAME g_fat[l_ac].faj06
       #FUN-AB0088---mark---str--- 
       #IF g_aza.aza63 = 'Y' THEN 
       #   DISPLAY BY NAME g_fat[l_ac].fat071
       #   DISPLAY BY NAME g_fat[l_ac].fat081
       #   DISPLAY BY NAME g_fat[l_ac].fat111
       #END IF
       #FUN-AB0088---mark---end---
     END IF
    END IF
END FUNCTION
 
FUNCTION t102_fat04(p_cmd)
DEFINE
      p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_gen01    LIKE gen_file.gen01,
      l_gen03    LIKE gen_file.gen03,         #No.TQC-770108
      l_genacti  LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen01,gen03,genacti INTO l_gen01,l_gen03,l_genacti  #No.TQC-770108 add gen03
      FROM gen_file
     WHERE gen01 = g_fat[l_ac].fat04
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-038'
                                LET l_gen01 = NULL
                                LET l_genacti = NULL
       WHEN l_genacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    #darcy:2023/01/11 mark s---
    # 财务需求，保管人不带出保管部门
    #LET g_fat[l_ac].fat05 = l_gen03
    #DISPLAY BY NAME g_fat[l_ac].fat05
    #darcy:2023/01/11 mark e---
END FUNCTION
 
FUNCTION t102_fat05(p_cmd)
DEFINE
      p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_gem01    LIKE gem_file.gem01,
      l_gemacti  LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gem01,gem02,gemacti INTO l_gem01,g_fat[l_ac].gem02_1,l_gemacti #darcy:2024/11/06 add gem02
      FROM gem_file
     WHERE gem01 = g_fat[l_ac].fat05
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-038'
                                LET l_gem01 = NULL
                                LET l_gemacti = NULL
       WHEN l_gemacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t102_fat06(p_cmd)
DEFINE
      p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_faf01    LIKE faf_file.faf01,
      l_faf03    LIKE faf_file.faf03,
      l_fafacti  LIKE faf_file.fafacti
 
     LET g_errno = ' '
     SELECT faf01,faf02,faf03,fafacti INTO l_faf01,g_fat[l_ac].faf02,l_faf03,l_fafacti #darcy:2024/11/06 add faf02
       FROM faf_file
      WHERE faf01 = g_fat[l_ac].fat06
     CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-039'
                                LET l_faf01 = NULL
                                LET l_faf03 = NULL
                                LET l_fafacti = NULL
       WHEN l_fafacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION  t102_fat07(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    l_aag02         LIKE aag_file.aag02,
    l_aagacti       LIKE aag_file.aagacti
 
    LET g_errno = ' '
    SELECT aag02,aagacti
      INTO l_aag02,l_aagacti
      FROM aag_file
     WHERE aag01 = g_fat[l_ac].fat07
       AND aag00 = g_bookno1  #No.FUN-740033
    CASE WHEN STATUS=100          LET g_errno = 'afa-085'  #No.7926
                                  LET l_aag02   = NULL
         WHEN l_aagacti = 'N' LET g_errno = '9028'
         OTHERWISE LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
END FUNCTION
 
FUNCTION  t102_fat08(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    l_aag02         LIKE aag_file.aag02,
    l_aagacti       LIKE aag_file.aagacti
 
    LET g_errno = ' '
    SELECT aag02,aagacti
      INTO l_aag02,l_aagacti
      FROM aag_file
     WHERE aag01 = g_fat[l_ac].fat08
       AND aag00 = g_bookno1  #No.FUN-740033
    CASE WHEN STATUS=100          LET g_errno = 'afa-085'  #No.7926
                                  LET l_aag02   = NULL
          WHEN l_aagacti = 'N' LET g_errno = '9028'
          OTHERWISE LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
END FUNCTION
 
#FUNCTION t102_fat101(p_cmd)    #FUN-AB0088 mark
FUNCTION t102_fat101(p_type)    #FUN-AB0088 add
DEFINE
      p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_gem01    LIKE gem_file.gem01,
      l_gemacti  LIKE gem_file.gemacti
DEFINE p_type    LIKE type_file.chr1     #FUN-AB0088 
     LET g_errno = ' '
     IF p_type = '1' THEN   #FUN-AB0088
        SELECT gem01,gemacti INTO l_gem01,l_gemacti
          FROM gem_file
         WHERE gem01 = g_fat[l_ac].fat10
     #FUN-AB0088---add---str---
     ELSE
        SELECT gem01,gemacti INTO l_gem01,l_gemacti
          FROM gem_file
         WHERE gem01 = g_fat2[l_ac].fat102
     END IF
     #FUN-AB0088---add---end---
     CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-038'
                                LET l_gem01 = NULL
                                LET l_gemacti = NULL
       WHEN l_gemacti = 'N' LET g_errno = '9028'
       OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
END FUNCTION
 
FUNCTION t102_fat102(p_cmd)
DEFINE
      p_cmd        LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_fad03      LIKE fad_file.fad03,
      l_fad031     LIKE fad_file.fad031,     #No.FUN-680028
      l_fad04      LIKE fad_file.fad04,
      l_fadacti    LIKE fad_file.fadacti
 
      LET g_errno = ' '
      SELECT fad03,fad04,fad031,fadacti INTO l_fad03,l_fad04,l_fad031,l_fadacti     #No.FUN-680028
        FROM fad_file
       WHERE fad04 = g_fat[l_ac].fat10
         AND fad03 = g_fat[l_ac].fat07
         AND fad02 = MONTH(g_fas.fas02)
         AND fad01 = YEAR(g_fas.fas02)
         AND fad07 = '1'   #FUN-AB0088
      CASE
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-049'
                                  LET l_fad04 = NULL
                                  LET l_fadacti = NULL
        WHEN l_fadacti = 'N' LET g_errno = '9028'
        OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     LET g_fat[l_ac].fat07 = l_fad03 
    #FUN-AB0088---mark---str--- 
    #IF g_aza.aza63 = 'Y' THEN  
    #   LET g_fat[l_ac].fat071= l_fad031
    #END IF
    #FUN-AB0088---mark---end---
END FUNCTION

#FUN-AB0088---add---str---
FUNCTION t102_fat102_1(p_cmd)
DEFINE
      p_cmd        LIKE type_file.chr1,         #No.FUN-680070 CHAR(1)
      l_fad03      LIKE fad_file.fad03,
      l_fad031     LIKE fad_file.fad031,        #No.FUN-680028
      l_fad04      LIKE fad_file.fad04,
      l_fadacti    LIKE fad_file.fadacti

      LET g_errno = ' '
      SELECT fad03,fad04,fad031,fadacti INTO l_fad03,l_fad04,l_fad031,l_fadacti     #No.FUN-680028
        FROM fad_file
       WHERE fad04 = g_fat2[l_ac].fat102
         AND fad03 = g_fat2[l_ac].fat071
         AND fad02 = MONTH(g_fas.fas02)
         AND fad01 = YEAR(g_fas.fas02)
         AND fad07 = '2'  
      CASE
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-049'
                                  LET l_fad04 = NULL
                                  LET l_fadacti = NULL
        WHEN l_fadacti = 'N' LET g_errno = '9028'
        OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     LET g_fat2[l_ac].fat071= l_fad03    
     DISPLAY BY NAME g_fat2[l_ac].fat071
END FUNCTION 
#FUN-AB0088---add---end---
 
FUNCTION  t102_fat11(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    l_aag02         LIKE aag_file.aag02,
    l_aagacti       LIKE aag_file.aagacti
 
    LET g_errno = ' '
    SELECT aag02,aagacti
      INTO l_aag02,l_aagacti
      FROM aag_file
     WHERE aag01 = g_fat[l_ac].fat11
       AND aag00 = g_bookno1  #No.FUN-740033
    CASE WHEN STATUS=100          LET g_errno = 'afa-085'  #No.7926
                                  LET l_aag02   = NULL
          WHEN l_aagacti = 'N' LET g_errno = '9028'
          OTHERWISE LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
END FUNCTION
 
FUNCTION  t102_fat071(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    l_aag02         LIKE aag_file.aag02,
    l_aagacti       LIKE aag_file.aagacti
 
    LET g_errno = ' '
    SELECT aag02,aagacti
      INTO l_aag02,l_aagacti
      FROM aag_file
    #WHERE aag01 = g_fat[l_ac].fat071   #FUN-AB0088 mark
     WHERE aag01 = g_fat2[l_ac].fat071  #FUN-AB0088 add  
       AND aag00 = g_bookno2  #No.FUN-740033
    CASE WHEN STATUS=100          LET g_errno = 'afa-085'  #No.7926
                                  LET l_aag02   = NULL
         WHEN l_aagacti = 'N' LET g_errno = '9028'
         OTHERWISE LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
END FUNCTION
 
FUNCTION  t102_fat081(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    l_aag02         LIKE aag_file.aag02,
    l_aagacti       LIKE aag_file.aagacti
 
    LET g_errno = ' '
    SELECT aag02,aagacti
      INTO l_aag02,l_aagacti
      FROM aag_file
    #WHERE aag01 = g_fat[l_ac].fat081   #FUN-AB0088 mark
     WHERE aag01 = g_fat2[l_ac].fat081  #FUN-AB0088 add
       AND aag00 = g_bookno2  #No.FUN-740033
    CASE WHEN STATUS=100          LET g_errno = 'afa-085'  #No.7926
                                  LET l_aag02   = NULL
          WHEN l_aagacti = 'N' LET g_errno = '9028'
          OTHERWISE LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
END FUNCTION
 
FUNCTION  t102_fat111(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    l_aag02         LIKE aag_file.aag02,
    l_aagacti       LIKE aag_file.aagacti
 
    LET g_errno = ' '
    SELECT aag02,aagacti
      INTO l_aag02,l_aagacti
      FROM aag_file
    #WHERE aag01 = g_fat[l_ac].fat111  #FUN-AB0088  mark
     WHERE aag01 = g_fat2[l_ac].fat111 #FUN-AB0088 add 
       AND aag00 = g_bookno2  #No.FUN-740033
    CASE WHEN STATUS=100          LET g_errno = 'afa-085'  #No.7926
                                  LET l_aag02   = NULL
          WHEN l_aagacti = 'N' LET g_errno = '9028'
          OTHERWISE LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
END FUNCTION
 
FUNCTION t102_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
   #CONSTRUCT l_wc2 ON fat02,fat03,faj06,fat031,fat04,fat05,fat06,fat07,fat071,fat08,     #No.FUN-680028  #FUN-AB0088
    CONSTRUCT l_wc2 ON fat02,fat03,faj06,fat031,fat04,fat05,fat06,fat07,fat08,            #FUN-AB0088 
                      #fat081,fat09,fat10,fat11,fat111     #No.FUN-680028   #FUN-AB008 mark
                       fat09,fat10,fat11                   #FUN-AB0088 add   
         FROM s_fat[1].fat02, s_fat[1].fat03,s_fat[1].faj06,s_fat[1].fat031,s_fat[1].fat04,
             #s_fat[1].fat05,s_fat[1].fat06,s_fat[1].fat07,s_fat[1].fat071,s_fat[1].fat08,   #FUN-AB0088 mark
              s_fat[1].fat05,s_fat[1].fat06,s_fat[1].fat07,s_fat[1].fat08,                   #FUN-AB0088 add
             #s_fat[1].fat081,s_fat[1].fat09,s_fat[1].fat10,s_fat[1].fat11,s_fat[1].fat111   #No.FUN-680028  #FUN-AB0088 mark
              s_fat[1].fat09,s_fat[1].fat10,s_fat[1].fat11                                   #FUN-AB0088 add 
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
         ON ACTION qbe_save
         CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    CALL t102_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t102_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    LET g_sql =
       #"SELECT fat02,fat03,fat031,faj06,fat04,fat05,fat06,fat07,fat071,fat08,fat081,fat09,",     #No.FUN-680028  #FUN-AB0088 add
        "SELECT fat02,fat03,fat031,faj06,fat04,fat05,gem02,fat06,faf02,fat07,fat08,fat09,",                   #FUN-AB0088 add     
        #darcy:2024/11/06 add gem02,faf02
       #"fat10,fat11,fat111 ",     #No.FUN-680028  #FUN-AB0088 mark
        "fat10,fat11        ",     #No.FUN-680028  #FUN-AB0088 add
        ",fatud01,fatud02,fatud03,fatud04,fatud05,",
        "fatud06,fatud07,fatud08,fatud09,fatud10,",
        "fatud11,fatud12,fatud13,fatud14,fatud15", 
        "  FROM fat_file LEFT OUTER JOIN faj_file ON fat03 = faj02 AND fat031 = faj022 ",
        #darcy:2024/11/06 add s---
        "   left join gem_file on gem01 = fat05 ",
        "   left join faf_file on faf01 = fat06 ",
        #darcy:2024/11/06 add e---
        " WHERE fat01  ='",g_fas.fas01,"'",  #單頭
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
 
    PREPARE t102_pb FROM g_sql
    DECLARE fat_curs                       #SCROLL CURSOR
        CURSOR FOR t102_pb
 
    CALL g_fat.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH fat_curs INTO g_fat[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,0) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
    END FOREACH
    CALL g_fat.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t102_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_fat TO s_fat.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
       #FUN-C30140---mark---str---
       ##IF g_aza.aza63 = 'Y' THEN   #FUN-AB0088 mark
       # IF g_faa.faa31 = 'Y' THEN   #FUN-AB0088 add
       #    CALL cl_set_act_visible("entry_sheet2",TRUE)
       # ELSE
       #    CALL cl_set_act_visible("entry_sheet2",FALSE)
       # END IF
       #FUN-C30140---mark---end---
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
      ON ACTION first
         CALL t102_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t102_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t102_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t102_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
            END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t102_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
         IF g_fas.fasconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         IF g_fas.fas09 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
         CALL cl_set_field_pic(g_fas.fasconf,g_chr2,g_fas.faspost,"",g_chr,"")
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 自動產生
      ON ACTION auto_generate
         LET g_action_choice="auto_generate"
         EXIT DISPLAY
      #FUN-AB0088---add---str---
      ON ACTION fin_audit2   #財簽二
         LET g_action_choice="fin_audit2"
         EXIT DISPLAY  
      #FUN-AB0088---add---end---

      #@ON ACTION 分錄底稿
      ON ACTION entry_sheet
         LET g_action_choice="entry_sheet"
         EXIT DISPLAY
      #@ON ACTION 分錄底稿2
      ON ACTION entry_sheet2
         LET g_action_choice="entry_sheet2"
         EXIT DISPLAY
      #@ON ACTION 會計分錄產生
      ON ACTION gen_entry
         LET g_action_choice="gen_entry"
         EXIT DISPLAY
      #@ON ACTION 作廢
 
      ON ACTION carry_voucher #傳票拋轉 
         LET g_action_choice="carry_voucher" 
         EXIT DISPLAY 
 
      ON ACTION undo_carry_voucher #傳票拋轉還原 
         LET g_action_choice="undo_carry_voucher"
         EXIT DISPLAY 
 
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY

      #FUN-D20035---add--str
      #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20035---add--end

      #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #@ON ACTION 過帳
      ON ACTION post
         LET g_action_choice="post"
         EXIT DISPLAY
      #@ON ACTION 會計過帳
      ON ACTION account_post
         LET g_action_choice="account_post"
         EXIT DISPLAY
      #@ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DISPLAY
#@    ON ACTION 相關文件
      ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
                LET INT_FLAG=FALSE #MOD-570244  mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel   #No.FUN-4B0019
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION easyflow_approval
         LET g_action_choice = 'easyflow_approval'
         EXIT DISPLAY
 
      ON ACTION approval_status
         LET g_action_choice="approval_status"
         EXIT DISPLAY
 
      ON ACTION agree
         LET g_action_choice = 'agree'
         EXIT DISPLAY
 
      ON ACTION deny
         LET g_action_choice = 'deny'
         EXIT DISPLAY
 
      ON ACTION modify_flow
         LET g_action_choice = 'modify_flow'
         EXIT DISPLAY
 
      ON ACTION withdraw
         LET g_action_choice = 'withdraw'
         EXIT DISPLAY
 
      ON ACTION org_withdraw
         LET g_action_choice = 'org_withdraw'
         EXIT DISPLAY
 
      ON ACTION phrase
         LET g_action_choice = 'phrase'
         EXIT DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t102_out()
   DEFINE l_cmd        LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(200)
          l_wc,l_wc2    LIKE type_file.chr50,        #No.FUN-680070 VARCHAR(50)
          l_prtway    LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
      CALL cl_wait()
      LET l_wc='fas01="',g_fas.fas01,'"'
     # SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'afar102'
      #FUN-D10098--add--str--
      IF g_aza.aza26 = '2' THEN
         SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'gfag102'
      ELSE
      #FUN-D10098--add--end--
         SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'afag102'
      END IF   #FUN-D10098 add
      IF SQLCA.sqlcode OR l_wc2 IS NULL THEN
         LET l_wc2 = " '3' '3' "   #TQC-610055
      END IF
     # LET l_cmd = "afar102", #FUN-C30085 mark
      #FUN-D10098--add--str--
      IF g_aza.aza26 = '2' THEN
         LET l_cmd = "gfag102", #FUN-C30085 add
                     " '",g_today CLIPPED,"' ''",
                     " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
                     " '",l_wc CLIPPED,"' ",l_wc2
      ELSE
      #FUN-D10098--add--end--
         LET l_cmd = "afag102", #FUN-C30085 add
                     " '",g_today CLIPPED,"' ''",
                     " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
                     " '",l_wc CLIPPED,"' ",l_wc2
      END IF   #FUN-D10098 add
      CALL cl_cmdrun(l_cmd)
   ERROR ' '
END FUNCTION
 
#---自動產生-------
FUNCTION t102_g()
 DEFINE  l_wc        LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(300)
         l_sql       LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(800)
         tm          RECORD
               a         LIKE faj_file.faj19,
               b         LIKE faj_file.faj20,
               c         LIKE faj_file.faj21,
               d         LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
               END RECORD,
         l_faj       RECORD
               faj02     LIKE faj_file.faj02,
               faj022    LIKE faj_file.faj022,
               faj04     LIKE faj_file.faj04,
               faj06     LIKE faj_file.faj06,
               faj19     LIKE faj_file.faj19,
               faj20     LIKE faj_file.faj20,
               faj21     LIKE faj_file.faj21,
               faj53     LIKE faj_file.faj53,
               faj531    LIKE faj_file.faj531,     #No.FUN-680028
               faj54     LIKE faj_file.faj54,
               faj541    LIKE faj_file.faj541,     #No.FUN-680028
               faj55     LIKE faj_file.faj55,
               faj551    LIKE faj_file.faj551,     #No.FUN-680028
               faj23     LIKE faj_file.faj23,
               faj24     LIKE faj_file.faj24
               END RECORD,
         ans         LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
         l_gen02     LIKE gen_file.gen02,
          l_gem01     LIKE gem_file.gem01,    #MOD-530434
         l_gem02     LIKE gem_file.gem02,
         l_faf02     LIKE faf_file.faf02,
         l_fbi02     LIKE fbi_file.fbi02,
         l_fbi021    LIKE fbi_file.fbi021,     #No.FUN-680028
         i           LIKE type_file.num5         #No.FUN-680070 SMALLINT
 DEFINE ls_tmp STRING
 DEFINE l_cnt                  LIKE type_file.num5         #Add No.TQC-B20061
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fas.fas01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fas.fasconf='Y' THEN CALL cl_err(g_fas.fas01,'afa-107',0) RETURN END IF
   IF g_fas.fasconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   #FUN-C30140---add---str---
   IF NOT cl_null(g_fas.fas09) AND g_fas.fas09 matches '[Ss]' THEN     
       CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
       RETURN
   END IF
   #FUN-C30140---add---end---
    IF NOT cl_confirm('afa-103') THEN RETURN END IF     #No.MOD-490235(4)
   LET INT_FLAG = 0

   #---------詢問是否自動新增單身--------------
      OPEN WINDOW t102_w2 AT 4,10 WITH FORM "afa/42f/afat1022"
            ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
      CALL cl_ui_locale("afat1022")
 
       LET tm.d='N'          #No.MOD-490235(1)
 
     #CONSTRUCT l_wc ON faj01,faj02,faj022,faj19,faj20,faj21,faj53   #No.FUN-B50118 mark
     #             FROM faj01,faj02,faj022,faj19,faj20,faj21,faj53   #No.FUN-B50118 mark
      CONSTRUCT l_wc ON faj01,faj93,faj02,faj022,faj19,faj20,faj21,faj53   #No.FUN-B50118 add
                   FROM faj01,faj93,faj02,faj022,faj19,faj20,faj21,faj53   #No.FUN-B50118 add
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      END CONSTRUCT
      IF l_wc = " 1=1" THEN
         CALL cl_err('','abm-997',1)
         LET INT_FLAG = 1
      END IF 
      IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t102_w2 RETURN END IF
      INPUT BY NAME tm.a,tm.b,tm.d,tm.c
            WITHOUT DEFAULTS
         AFTER FIELD a    #-->保管人
            IF NOT cl_null(tm.a) THEN
               SELECT gen02 INTO l_gen02 FROM gen_file
                           WHERE gen01 = tm.a AND genacti = 'Y'
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","gen_file",tm.a,"","afa-034","","",1)  #No.FUN-660136
                  DISPLAY l_gen02 TO FORMONLY.gen02
                  NEXT FIELD a
               END IF
                  DISPLAY l_gen02 TO FORMONLY.gen02
            END IF
            SELECT gen03 INTO l_gem01 FROM gen_file
                        WHERE gen01 = tm.a
            LET tm.b = l_gem01
         BEFORE FIELD b
            CALL t1022_set_entry()
         AFTER FIELD b    #-->保管部門
            IF NOT cl_null(tm.b) THEN
               SELECT gem02 INTO l_gem02 FROM gem_file
                WHERE gem01 = tm.b AND gemacti = 'Y'
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","gem_file",tm.b,"","afa-038","","",1)  #No.FUN-660136
                  LET l_gem02 = ' '
                  DISPLAY l_gem02 TO FORMONLY.gem02
                  NEXT FIELD b
               END IF
               DISPLAY l_gem02 TO FORMONLY.gem02
            END IF
            CALL t1022_set_no_entry(tm.b)
 
         AFTER FIELD c    #-->存放位置
            IF NOT cl_null(tm.c) THEN
               SELECT faf02 INTO l_faf02  FROM faf_file
                           WHERE faf01 = tm.c AND fafacti = 'Y'
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","faf_file",tm.c,"","afa-039","","",1)  #No.FUN-660136
                  LET l_faf02 = ' '
                  DISPLAY l_faf02 TO FORMONLY.faf02
                  NEXT FIELD c
               END IF
               DISPLAY l_faf02 TO FORMONLY.faf02
            END IF
         ON ACTION controlp     #ok
           CASE
              WHEN INFIELD(a)   #保管人
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = tm.a
                 CALL cl_create_qry() RETURNING tm.a
                 DISPLAY tm.a TO FORMONLY.a
                 NEXT FIELD a
              WHEN INFIELD(b)   #保管部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = tm.b
                 CALL cl_create_qry() RETURNING tm.b
                 DISPLAY tm.b TO FORMONLY.b
                 NEXT FIELD b
              WHEN INFIELD(c)   #保管部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faf"
                 LET g_qryparam.default1 = tm.c
                 CALL cl_create_qry() RETURNING tm.c
                 DISPLAY tm.c TO FORMONLY.c
                 NEXT FIELD c
           END CASE
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
     END INPUT
     IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t102_w2 RETURN END IF   #MOD-690003
     #------自動產生------
      BEGIN WORK
      LET l_sql ="SELECT faj02,faj022,faj04,faj06,faj19,faj20,faj21,faj53,faj531,",
                 "faj54,faj541,faj55,faj551,faj23,faj24",     #No.FUN-680028
                 "  FROM faj_file",
                 " WHERE faj43 NOT IN ('0','5','6','X')",
                 "   AND fajconf = 'Y' ",
                 "   AND ",l_wc CLIPPED,
                 " ORDER BY 1"
     PREPARE t102_prepare_g FROM l_sql
     IF SQLCA.SQLCODE != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,0)
        ROLLBACK WORK RETURN
     END IF
     DECLARE t102_curs2 CURSOR WITH HOLD FOR t102_prepare_g
 
     SELECT MAX(fat02)+1 INTO i FROM fat_file WHERE fat01 = g_fas.fas01
     IF cl_null(i) THEN LET i = 1 END IF
     LET g_success='Y'  #MOD-740316
     CALL s_showmsg_init()  #No.FUN-710028
     FOREACH t102_curs2 INTO l_faj.*
       IF g_success='N' THEN                                                                                                         
          LET g_totsuccess='N'                                                                                                       
          LET g_success="Y"                                                                                                          
       END IF                                                                                                                        
 
       IF SQLCA.sqlcode != 0 THEN
          CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1) #No.FUN-710028
          LET g_success = 'N'                             #No.FUN-710028
          ROLLBACK WORK EXIT FOREACH
       END IF
 
       IF NOT cl_null(tm.a) THEN LET l_faj.faj19 = tm.a END IF
       IF NOT cl_null(tm.b) THEN LET l_faj.faj20 = tm.b END IF
       IF NOT cl_null(tm.c) THEN LET l_faj.faj21 = tm.c END IF
       #--->預設部門會計科目
       IF g_faa.faa20 = '2' THEN
           DECLARE t102_fbi
               CURSOR FOR SELECT fbi02,fbi021 FROM fbi_file     #No.FUN-680028
                                      WHERE fbi01 = l_faj.faj20
                                        AND fbi03 = l_faj.faj04
           FOREACH t102_fbi INTO l_fbi02,l_fbi021     #No.FUN-680028
             IF SQLCA.sqlcode THEN EXIT FOREACH END IF
             IF not cl_null(l_fbi02) THEN ROLLBACK WORK EXIT FOREACH END IF
           END FOREACH
           LET l_faj.faj55 = l_fbi02
          #IF g_aza.aza63 = 'Y' THEN   #FUN-AB0088 mark
           IF g_faa.faa31 = 'Y' THEN   #FUN-AB0088 add
              LET l_faj.faj551 = l_fbi021
           END IF
       END IF
       #no:4532檢查資產盤點期間應不可做異動
       SELECT COUNT(*) INTO g_cnt FROM fca_file
        WHERE fca03  = l_faj.faj02
          AND fca031 = l_faj.faj022
          AND fca15  = 'N'
       IF g_cnt > 0 THEN
          CONTINUE FOREACH
       END IF
       #Add No.TQC-B20061
       #afa-309 本张单据资料因有日期小於本张单据且未过账,请检查
       SELECT count(*) INTO l_cnt FROM fat_file,fas_file
        WHERE fat01 = fas01
          AND fat03 = l_faj.faj02
          AND fat031= l_faj.faj022
          AND fas02 <= g_fas.fas02
          AND faspost = 'N'
          AND fas01 != g_fas.fas01
          AND fasconf <> 'X' 
       IF l_cnt  > 0 THEN
          CONTINUE FOREACH
       END IF
       #End Add No.TQC-B20061
       IF l_faj.faj23 = '1' AND tm.d = 'Y' THEN LET l_faj.faj24 = tm.b END IF
        IF cl_null(l_faj.faj022) THEN
           LET l_faj.faj022 = ' '
        END IF
        INSERT INTO fat_file (fat01,fat02,fat03,fat031,fat04,fat05,  #No.MOD-470041
                             fat06,fat07,fat071,fat08,fat081,fat09,fat10,fat11,fat111,
                             fat092,fat102,   #FUN-AB0088 add
                             fatlegal)     #No.FUN-680028 #FUN-980003 add
            VALUES (g_fas.fas01,i,l_faj.faj02,l_faj.faj022,l_faj.faj19,
                    l_faj.faj20,l_faj.faj21,l_faj.faj53,l_faj.faj531,l_faj.faj54,
                    l_faj.faj541,l_faj.faj23,l_faj.faj24,l_faj.faj55,l_faj.faj551,
                    '1','',      #FUN-AB0088 
                    g_legal)     #No.FUN-680028 #FUN-980003 add
              IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
                 LET g_showmsg = g_fas.fas01,"/",i   #No.FUN-710028
                 CALL s_errmsg('fat01,fat02',g_showmsg,'ins fat',STATUS,1)   #No.FUN-710028
                 LET g_success = 'N' CONTINUE FOREACH  #No.FUN-710028
              END IF
              LET i = i + 1
     END FOREACH
     IF g_totsuccess="N" THEN                                                                                                        
        LET g_success="N"                                                                                                            
     END IF                                                                                                                          
 
     CLOSE WINDOW t102_w2
     IF g_success = 'Y' THEN  #No.FUN-710028
        COMMIT WORK
     ELSE                     #No.FUN-710028  
        ROLLBACK WORK         #No.FUN-710028
     END IF                   #No.FUN-710028
    #CALL t102_b_fill(l_wc)   #MOD-C60079 mark
     CALL t102_b_fill('1=1')    #MOD-C60079 add
END FUNCTION
 
FUNCTION t1022_set_entry()
 
    IF INFIELD(b) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("d",TRUE)
    END IF
END FUNCTION
 
FUNCTION t1022_set_no_entry(tm_b)
DEFINE tm_b LIKE faj_file.faj20
 
    IF INFIELD(b) OR (NOT g_before_input_done) THEN
        IF cl_null(tm_b) THEN
           CALL cl_set_comp_entry("d",FALSE)
        END IF
    END IF
END FUNCTION
 
FUNCTION t102_y()
  DEFINE l_bdate,l_edate        LIKE type_file.dat          #No.FUN-680070 DATE
  DEFINE l_flag                 LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
  DEFINE l_cnt                  LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
   SELECT * INTO g_fas.* FROM fas_file WHERE fas01 = g_fas.fas01
   IF g_fas.fasconf='Y' THEN RETURN END IF
   IF g_fas.fasconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   SELECT COUNT(*) INTO l_cnt FROM fat_file
    WHERE fat01= g_fas.fas01
   IF l_cnt = 0 THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   #-->折舊年月判斷
   #CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate #CHI-A60036 mark
   #CHI-A60036 add --start--
   CALL s_get_bookno(g_faa.faa07)
       RETURNING g_flag,g_bookno1,g_bookno2
   #FUN-AB0088---add---str---
   #固資已不和二套掛鉤，所以原本利用s_get_bookno取到賬別一及賬別二是用是否使用二套賬來判斷
   #此處取賬別二要重新處理，應取固資參數欄位財二賬套faa02c作為賬別二的賬套
   IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF
   #FUN-AB0088---add---end---
   #FUN-B60140   ---start   Mark
 ##IF g_aza.aza63 = 'Y' THEN   #FUN-AB0088 mark
 # IF g_faa.faa31 = 'Y' THEN   #FUN-AB0088 add
 #   #CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate   #FUN-AB0088 mark
 #   #CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno2) RETURNING l_flag,l_bdate,l_edate   #FUN-AB0088 add   #TQC-B50158   Mark
 #    CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate                     #TQC-B50158   Add
 # ELSE
 #    CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
 # END IF
 # #CHI-A60036 add --end--
   CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate   #FUN-B60140   Add
   IF g_fas.fas02 < l_bdate THEN
      CALL cl_err(g_fas.fas02,'afa-308',0)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   #-->立帳日期小於關帳日期
   IF g_fas.fas02 < g_faa.faa09 THEN
      CALL cl_err(g_fas.fas01,'aap-176',1) RETURN
   END IF
  #FUN-B60140   ---start   Add
   IF g_faa.faa31 = "Y" THEN
      CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate                 #TQC-B50158 Add
      IF g_fas.fas02 < l_bdate THEN
         CALL cl_err(g_fas.fas02,'afa-308',0)
         RETURN
      END IF

      #-->立帳日期小於關帳日期
      IF g_fas.fas02 < g_faa.faa092 THEN
         CALL cl_err(g_fas.fas01,'aap-176',1) RETURN
      END IF
   END IF
  #FUN-B60140   ---end     Add
#FUN-C30313---mark---START
#   IF g_fah.fahdmy3 = 'Y' THEN  
#      CALL s_chknpq(g_fas.fas01,'FA',1,'0',g_bookno1)  #--->NO:0151  #No.FUN-740033
#     #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN   #FUN-AB0088 mark
#      IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   #FUN-AB0088 add
#         CALL s_chknpq(g_fas.fas01,'FA',1,'1',g_bookno2)  #--->NO:0151  #No.FUN-740033
#      END IF
#   END IF
#FUN-C30313---mark---END

#FUN-C30313---add---START-----
    IF g_fah.fahdmy3 = 'Y' THEN
       CALL s_chknpq(g_fas.fas01,'FA',1,'0',g_bookno1)  #--->NO:0151  #No.FUN-740033
    END IF
    IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   #FUN-AB0088 add
       IF g_fah.fahdmy32 = 'Y' THEN
          CALL s_chknpq(g_fas.fas01,'FA',1,'1',g_bookno2)  #--->NO:0151  #No.FUN-740033
       END IF
    END IF
#FUN-C30313---add---END-------
   IF g_success = 'N' THEN RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
   BEGIN WORK
 
   LET g_success = 'Y'
   UPDATE fas_file SET fasconf = 'Y' WHERE fas01 = g_fas.fas01
       IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","fas_file",g_fas.fas01,"",STATUS,"","upd fasconf",1)  #No.FUN-660136
          LET g_success = 'N'
       END IF
       IF g_success = 'Y' THEN
          LET g_fas.fasconf='Y'
          COMMIT WORK
          DISPLAY BY NAME g_fas.fasconf
          CALL cl_flow_notify(g_fas.fas01,'Y')
       ELSE
          LET g_fas.fasconf='N'
          ROLLBACK WORK
       END IF
 
    IF g_fas.fasconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_fas.fas09 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_fas.fasconf,g_chr2,g_fas.faspost,"",g_chr,"")
END FUNCTION
 
FUNCTION t102_y_chk()
   DEFINE l_bdate,l_edate        LIKE type_file.dat          #No.FUN-680070 DATE
   DEFINE l_flag                 LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
   DEFINE l_cnt                  LIKE type_file.num5         #No.FUN-680070 SMALLINT
   DEFINE l_fat09                LIKE fat_file.fat09         #MOD-A80068
   DEFINE l_fat10                LIKE fat_file.fat10         #MOD-A80068
   DEFINE l_fat03                LIKE fat_file.fat03         #MOD-A80068
   DEFINE l_fat031               LIKE fat_file.fat031        #MOD-A80068
   DEFINE l_fat07                LIKE fat_file.fat07         #MOD-A80068
   DEFINE l_fat071               LIKE fat_file.fat071        #MOD-A80068
   DEFINE l_fat08                LIKE fat_file.fat08         #MOD-A80068
   DEFINE l_fat081               LIKE fat_file.fat081        #MOD-A80068
   DEFINE l_fat11                LIKE fat_file.fat11         #MOD-A80068
   DEFINE l_fat111               LIKE fat_file.fat111        #MOD-A80068
 
   LET g_success = 'Y'              #FUN-580109
#CHI-C30107 ------------- add -------------- begin
   IF g_fas.fasconf='Y' THEN
      LET g_success = 'N'           
      CALL cl_err('','9023',0) 
      RETURN
   END IF

   IF g_fas.fasconf = 'X' THEN
      LET g_success = 'N'   
      CALL cl_err(' ','9024',0)
      RETURN
   END IF
   IF g_action_choice CLIPPED = "confirm"    #按「確認」時
   OR g_action_choice CLIPPED = "insert"     #FUN-640243
   THEN
      IF NOT cl_confirm('axm-108') THEN  LET g_success = 'N' RETURN END IF 
   END IF
#CHI-C30107 ------------- add -------------- end
   SELECT * INTO g_fas.* FROM fas_file WHERE fas01 = g_fas.fas01
   IF g_fas.fasconf='Y' THEN
      LET g_success = 'N'           #FUN-580109
      CALL cl_err('','9023',0)      #FUN-580109
      RETURN
   END IF
 
   IF g_fas.fasconf = 'X' THEN
      LET g_success = 'N'   #FUN-580109
      CALL cl_err(' ','9024',0)
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM fat_file
    WHERE fat01= g_fas.fas01
   IF l_cnt = 0 THEN
      LET g_success = 'N'   #FUN-580109
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
 
   #-->折舊年月判斷
   #CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate #CHI-A60036 mark
   #CHI-A60036 add --start--
   CALL s_get_bookno(g_faa.faa07)
       RETURNING g_flag,g_bookno1,g_bookno2
   #FUN-AB0088---add---str---
   #固資已不和二套掛鉤，所以原本利用s_get_bookno取到賬別一及賬別二是用是否使用二套賬來判斷
   #此處取賬別二要重新處理，應取固資參數欄位財二賬套faa02c作為賬別二的賬套
   IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF
   #FUN-AB0088---add---end--
  #FUN-B60140   ---start   Mark
 ##IF g_aza.aza63 = 'Y' THEN   #FUN-AB0088 mark
 # IF g_faa.faa31 = 'Y' THEN   #FUN-AB0088 add
 #   #CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate   #FUN-AB0088 mark
 #   #CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno2) RETURNING l_flag,l_bdate,l_edate   #FUN-AB0088 add   #TQC-B50158   Mark
 #    CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate                     #TQC-B50158   Add
 # ELSE
 #    CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
 # END IF
   #CHI-A60036 add --end--
  #FUN-B60140   ---end     Mark
   IF g_fas.fas02 < l_bdate THEN
      LET g_success = 'N'   #FUN-580109
      CALL cl_err(g_fas.fas02,'afa-308',0)
      RETURN
   END IF
 
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   #-->立帳日期小於關帳日期
   IF g_fas.fas02 < g_faa.faa09 THEN
      LET g_success = 'N'   #FUN-580109
      CALL cl_err(g_fas.fas01,'aap-176',1)
      RETURN
   END IF
  #FUN-B60140   ---start   Add
   IF g_faa.faa31 = "Y" THEN
      CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate                 #TQC-B50158  Add
      IF g_fas.fas02 < l_bdate THEN
         LET g_success = 'N'   #FUN-580109
         CALL cl_err(g_fas.fas02,'afa-308',0)
         RETURN
      END IF

      #-->立帳日期小於關帳日期
      IF g_fas.fas02 < g_faa.faa092 THEN
         LET g_success = 'N'   #FUN-580109
         CALL cl_err(g_fas.fas01,'aap-176',1)
         RETURN
      END IF
   END IF
  #FUN-B60140   ---end     Add
 
  #-MOD-A80068-add-
   DECLARE t102_fat CURSOR FOR
       SELECT fat09,fat10,fat03,fat031,fat07,fat071,fat08,fat081,fat11,fat111
         FROM fat_file
        WHERE fat01 = g_fas.fas01
   FOREACH t102_fat INTO l_fat09,l_fat10,l_fat03,l_fat031,l_fat07,l_fat071,l_fat08,l_fat081,l_fat11,l_fat111 
     IF SQLCA.sqlcode THEN EXIT FOREACH END IF
     IF l_fat09 = '1' THEN
        CALL t102_chkdept(l_fat07,g_aza.aza81,l_fat10) RETURNING g_errno 
        IF NOT cl_null(g_errno) THEN
           CALL cl_err3(" "," ",l_fat07,l_fat07,g_errno,"","",1)  
           LET g_success = 'N'    
           EXIT FOREACH 
        END IF
        #IF g_faa.faa31 = 'Y' THEN   #FUN-AB0088 #No:FUN-BA0112 mark 
           CALL t102_chkdept(l_fat08,g_aza.aza81,l_fat10) RETURNING g_errno 
           IF NOT cl_null(g_errno) THEN
              CALL cl_err3(" "," ",l_fat08,l_fat08,g_errno,"","",1)  
              LET g_success = 'N'    
              EXIT FOREACH 
           END IF
           CALL t102_chkdept(l_fat11,g_aza.aza81,l_fat10) RETURNING g_errno 
           IF NOT cl_null(g_errno) THEN
              CALL cl_err3(" "," ",l_fat11,l_fat11,g_errno,"","",1)  
              LET g_success = 'N'    
              EXIT FOREACH 
           END IF
         IF g_faa.faa31 = 'Y' THEN #No:FUN-BA0112 add  
           CALL t102_chkdept(l_fat071,g_aza.aza82,l_fat10) RETURNING g_errno 
           IF NOT cl_null(g_errno) THEN
              CALL cl_err3(" "," ",l_fat071,l_fat071,g_errno,"","",1)  
              LET g_success = 'N'    
              EXIT FOREACH 
           END IF
           CALL t102_chkdept(l_fat081,g_aza.aza82,l_fat10) RETURNING g_errno 
           IF NOT cl_null(g_errno) THEN
              CALL cl_err3(" "," ",l_fat081,l_fat081,g_errno,"","",1)  
              LET g_success = 'N'    
              EXIT FOREACH 
           END IF
           CALL t102_chkdept(l_fat111,g_aza.aza82,l_fat10) RETURNING g_errno 
           IF NOT cl_null(g_errno) THEN
              CALL cl_err3(" "," ",l_fat111,l_fat111,g_errno,"","",1)  
              LET g_success = 'N'    
              EXIT FOREACH 
           END IF
       END IF  #FUN-AB0088 add
     END IF
   END FOREACH
  #-MOD-A80068-end-

   LET g_t1 = s_get_doc_no(g_fas.fas01)  #No.FUN-670060                                                                           
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1  #No.FUN-670060
#FUN-C30313---mark---START
#  IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'N' THEN  #No.FUN-670060
#     CALL s_chknpq(g_fas.fas01,'FA',1,'0',g_bookno1)  #--->NO:0151  #No.FUN-740033
#    #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN   #FUN-AB0088 mark
#     IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   #FUN-AB0088 add
#        CALL s_chknpq(g_fas.fas01,'FA',1,'1',g_bookno2)  #--->NO:0151  #No.FUN-740033
#     END IF
#  END IF
#FUN-C30313---mark---END

#FUN-C30313---add---START-----
   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'N' THEN  
      CALL s_chknpq(g_fas.fas01,'FA',1,'0',g_bookno1)  
   END IF
   IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   
      IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'N' THEN
         CALL s_chknpq(g_fas.fas01,'FA',1,'1',g_bookno2)
      END IF
   END IF
#FUN-C30313---add---END-------
 
   IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
#-MOD-A80068-add- 
FUNCTION t102_chkdept(p_accno,p_bookno,p_depno)
   DEFINE  p_accno      LIKE aag_file.aag01     
   DEFINE  p_bookno     LIKE aza_file.aza81      
   DEFINE  p_depno      LIKE fat_file.fat10      
   DEFINE  p_errno      LIKE zaa_file.zaa01  
   DEFINE  l_aag05      LIKE aag_file.aag05    
   
   LET p_errno = ' '
   LET l_aag05 = ''   
   SELECT aag05 INTO l_aag05 
     FROM aag_file
    WHERE aag01 = p_accno AND aag00 = p_bookno 
   IF l_aag05 = 'Y' THEN  
      CALL s_chkdept(g_aaz.aaz72,p_accno,p_depno,p_bookno) RETURNING p_errno
   END IF
   RETURN p_errno
END FUNCTION
#-MOD-A80068-end- 

FUNCTION t102_y_upd()
   DEFINE l_cnt     LIKE type_file.num5         #No.FUN-680070 SMALLINT
   #CHI-B80007 -- begin --
   DEFINE l_fat     RECORD LIKE fat_file.*
   DEFINE l_msg     LIKE type_file.chr1000
   #CHI-B80007 -- begin --
 
   LET g_success = 'Y'
   IF g_action_choice CLIPPED = "confirm"    #按「確認」時
   OR g_action_choice CLIPPED = "insert"     #FUN-640243
   THEN
 
      IF g_fas.fasmksg='Y'   THEN
          IF g_fas.fas09 != '1' THEN
             CALL cl_err('','aws-078',1)
             LET g_success = 'N'
             RETURN
          END IF
      END IF
#     IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107 mark
   END IF
 
   BEGIN WORK
 
   #CHI-B80007 -- begin --
   DECLARE t102_fat_cur CURSOR FOR
      SELECT * FROM fat_file WHERE fat01=g_fas.fas01
   FOREACH t102_fat_cur INTO l_fat.*
      SELECT count(*) INTO l_cnt FROM fat_file,fas_file
       WHERE fat01 = fas01
         AND fat03 = l_fat.fat03
         AND fat031= l_fat.fat031 AND fas02 <= g_fas.fas02
         AND faspost = 'N'
         AND fas01 != g_fas.fas01
         AND fasconf <> 'X'
      IF l_cnt  > 0 THEN
         LET l_msg = l_fat.fat01,' ',l_fat.fat02,' ',
                     l_fat.fat03,' ',l_fat.fat031
         CALL s_errmsg('','',l_msg,'afa-309',1)
         LET g_success = 'N'
      END IF
   END FOREACH
   IF g_success = 'N' THEN
      CALL s_showmsg()
      RETURN
   END IF
   #CHI-B80007 -- end --

#FUN-C30313---mark---START
#  IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
#     SELECT COUNT(*) INTO l_cnt FROM npq_file 
#      WHERE npq01= g_fas.fas01
#        AND npq00= 2  
#        AND npqsys= 'FA'  
#        AND npq011= 1
#     IF l_cnt = 0 THEN
#        CALL t102_gen_glcr(g_fas.*,g_fah.*)
#     END IF
#     IF g_success = 'Y' THEN 
#        CALL s_chknpq(g_fas.fas01,'FA',1,'0',g_bookno1)  #--->NO:0151  #No.FUN-740033
#      # IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN   #FUN-AB0088 mark
#        IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   #FUN-AB0088 add
#           CALL s_chknpq(g_fas.fas01,'FA',1,'1',g_bookno2)  #--->NO:0151  #No.FUN-740033
#        END IF
#     END IF
#     IF g_success = 'N' THEN RETURN END IF  #No.FUN-680028
#  END IF
#FUN-C30313---mark---END

#FUN-C30313---add---START-----
      SELECT COUNT(*) INTO l_cnt FROM npq_file
       WHERE npq01= g_fas.fas01
         AND npq00= 2
         AND npqsys= 'FA'
         AND npq011= 1
     #IF l_cnt = 0 THEN                                                                   #MOD-C50255 mark
      IF l_cnt = 0 AND                                                                    #MOD-C50255 add
         ((g_fah.fahdmy3 = 'Y') OR (g_faa.faa31 = 'Y' AND g_fah.fahdmy32 = 'Y' )) THEN    #MOD-C50255 add
         CALL t102_gen_glcr(g_fas.*,g_fah.*)
      END IF
      IF g_success = 'Y' THEN
         IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
            CALL s_chknpq(g_fas.fas01,'FA',1,'0',g_bookno1)  
         END IF
         IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   
            IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' THEN
               CALL s_chknpq(g_fas.fas01,'FA',1,'1',g_bookno2)  
            END IF
         END IF
      END IF
      IF g_success = 'N' THEN RETURN END IF  
#FUN-C30313---add---END-------
 
   LET g_success = 'Y'
 
   UPDATE fas_file SET fasconf = 'Y' WHERE fas01 = g_fas.fas01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('fas01',g_fas.fas01,'upd fasconf',STATUS,1)   #No.FUN-710028
      LET g_success = 'N'
   END IF
 
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'Y' THEN
      IF g_fas.fasmksg = 'Y' THEN #簽核模式
         CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
             WHEN 0  #呼叫 EasyFlow 簽核失敗
                  LET g_fas.fasconf="N"
                  LET g_success = "N"
                  ROLLBACK WORK
                  RETURN
             WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                  LET g_fas.fasconf="N"
                  ROLLBACK WORK
                  RETURN
         END CASE
      END IF
      IF g_success = 'Y' THEN
         LET g_fas.fas09='1'             #執行成功, 狀態值顯示為 '1' 已核准
         UPDATE fas_file SET fas09 = g_fas.fas09 WHERE fas01=g_fas.fas01
         IF SQLCA.sqlerrd[3]=0 THEN
            LET g_success='N'
         END IF
         LET g_fas.fasconf='Y'           #執行成功, 確認碼顯示為 'Y' 已確認
         COMMIT WORK
         DISPLAY BY NAME g_fas.fasconf
         DISPLAY BY NAME g_fas.fas09   #FUN-580109
         CALL cl_flow_notify(g_fas.fas01,'Y')
      ELSE
         LET g_fas.fasconf='N'
         LET g_success = 'N'   #FUN-580109
         ROLLBACK WORK
      END IF
   ELSE
      LET g_fas.fasconf='N'
      LET g_success = 'N'
      ROLLBACK WORK
   END IF
   
   IF g_fas.fasconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fas.fas09 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fas.fasconf,g_chr2,g_fas.faspost,"",g_chr,"")
 
END FUNCTION
 
FUNCTION t102_ef()
 
   CALL t102_y_chk()      #CALL 原確認的 check 段
   IF g_success = "N" THEN
      RETURN
   END IF
 
   CALL aws_condition()   #判斷送簽資料
   IF g_success = 'N' THEN
      RETURN
   END IF
 
######################################
# CALL aws_efcli2()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
######################################
 
   IF aws_efcli2(base.TypeInfo.create(g_fas),base.TypeInfo.create(g_fat),'','','','')
   THEN
      LET g_success='Y'
      LET g_fas.fas09='S'
      DISPLAY BY NAME g_fas.fas09
   ELSE
      LET g_success='N'
   END IF
END FUNCTION
 
FUNCTION t102_z()
 DEFINE l_bdate,l_edate   LIKE type_file.dat        #No.FUN-680070 DATE
 
   SELECT * INTO g_fas.* FROM fas_file WHERE fas01 = g_fas.fas01
   IF g_fas.fas09  ='S' THEN CALL cl_err("","mfg3557",0) RETURN END IF   #FUN-580109
   IF g_fas.fasconf='N' THEN RETURN END IF
   IF g_fas.fasconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   IF g_fas.faspost='Y' THEN
      CALL cl_err('faspost=Y:','afa-101',0)
      RETURN
   END IF
   #-->折舊年月判斷
   #CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate #CHI-A60036 mark
   #CHI-A60036 add --start--
   CALL s_get_bookno(g_faa.faa07)
       RETURNING g_flag,g_bookno1,g_bookno2
   #FUN-AB0088---add---str---
   #固資已不和二套掛鉤，所以原本利用s_get_bookno取到賬別一及賬別二是用是否使用二套賬來判斷
   #此處取賬別二要重新處理，應取固資參數欄位財二賬套faa02c作為賬別二的賬套
   IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF
  #FUN-B60140   --start   Mark
 # #FUN-AB0088---add---end--
 ##IF g_aza.aza63 = 'Y' THEN   #FUN-AB0088 mark
 # IF g_faa.faa31 = 'Y' THEN   #FUN-AB0088 add
 #   #CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate   #FUN-AB0088 mark
 #   #CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno2) RETURNING l_flag,l_bdate,l_edate   #FUN-AB0088 add   #TQC-B50158   Mark
 #    CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate                     #TQC-B50158   Add
 # ELSE
 #    CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
 # END IF
  #FUN-B60140   --end     Mark
   CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate   #FUN-B60140   Add
   #CHI-A60036 add --end--
   IF g_fas.fas02 < l_bdate THEN
      CALL cl_err(g_fas.fas02,'afa-308',0)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_fas.fas02 < g_faa.faa09 THEN
      CALL cl_err(g_fas.fas01,'aap-176',1) RETURN
   END IF
 
  #FUN-B60140   ---start   Add
   IF g_faa.faa31 = "Y" THEN
      CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate                 #TQC-B50158   Add
      IF g_fas.fas02 < l_bdate THEN
         CALL cl_err(g_fas.fas02,'afa-308',0)
         RETURN
      END IF
      #-->立帳日期不可小於關帳日期
      IF g_fas.fas02 < g_faa.faa092 THEN
         CALL cl_err(g_fas.fas01,'aap-176',1) RETURN
      END IF
   END IF
  #FUN-B60140   ---end     Add
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
 
    OPEN t102_cl USING g_fas.fas01
    IF STATUS THEN
       CALL cl_err("OPEN t102_cl:", STATUS, 1)
       CLOSE t102_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t102_cl INTO g_fas.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fas.fas01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t102_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
   UPDATE fas_file SET fasconf = 'N',fas09 ='0' WHERE fas01 = g_fas.fas01   #FUN-580109
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN LET g_success = 'N' END IF
   IF g_success = 'Y' THEN
      LET g_fas.fasconf='N'
      LET g_fas.fas09='0'   #FUN-580109
      COMMIT WORK
      DISPLAY BY NAME g_fas.fasconf
      DISPLAY BY NAME g_fas.fas09   #FUN-580109
   ELSE
      LET g_fas.fasconf='Y'
      ROLLBACK WORK
   END IF
 
 
   IF g_fas.fasconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fas.fas09 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fas.fasconf,g_chr2,g_fas.faspost,"",g_chr,"")
END FUNCTION
 
#----過帳--------
FUNCTION t102_s(p_cmd)
   DEFINE p_cmd       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
          l_fat       RECORD LIKE fat_file.*,
          l_faj       RECORD LIKE faj_file.*,
          l_yy        LIKE type_file.chr4,            #No.FUN-680070 VARCHAR(4)
          l_mm        LIKE type_file.chr2,            #No.FUN-680070 VARCHAR(2)
          l_cnt       LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          l_bdate,l_edate     LIKE type_file.dat,          #No.FUN-680070 DATE
          l_flag      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
          l_faf03     LIKE faf_file.faf03,
          l_msg       LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(40)
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fas.fas01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_fas.* FROM fas_file WHERE fas01 = g_fas.fas01
   IF g_fas.fasconf != 'Y' OR g_fas.faspost != 'N' THEN
      CALL cl_err(g_fas.fas01,'afa-100',0)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add-
   #-->立帳日期小於關帳日期
   IF g_fas.fas02 < g_faa.faa09 THEN
      CALL cl_err(g_fas.fas01,'aap-176',1) RETURN
   END IF
  #-MOD-A80137-end-

  #FUN-B60140   ---start   Add
   IF g_faa.faa31 = "Y" THEN
      #-->立帳日期小於關帳日期
      IF g_fas.fas02 < g_faa.faa092 THEN
         CALL cl_err(g_fas.fas01,'aap-176',1) RETURN
      END IF
   END IF
  #FUN-B60140   ---end     Add

   LET g_t1 = s_get_doc_no(g_fas.fas01)     #No.FUN-680028
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1     #No.FUN-680028
   #--->折舊年月判斷
   #CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate #CHI-A60036 mark
   #CHI-A60036 add --start--
   CALL s_get_bookno(g_faa.faa07)
       RETURNING g_flag,g_bookno1,g_bookno2
   #FUN-AB0088---add---str---
   #固資已不和二套掛鉤，所以原本利用s_get_bookno取到賬別一及賬別二是用是否使用二套賬來判斷
   #此處取賬別二要重新處理，應取固資參數欄位財二賬套faa02c作為賬別二的賬套
   IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF
   #FUN-AB0088---add---end---
  #FUN-B60140   ---start    Add
 ##IF g_aza.aza63 = 'Y' THEN   #FUN-AB0088 mark
 # IF g_faa.faa31 = 'Y' THEN   #FUN-AB0088 add
 #   #CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate   #FUN-AB0088 mark
 #   #CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno2) RETURNING l_flag,l_bdate,l_edate   #FUN-AB0088 add   #TQC-B50158   Mark
 #    CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate                     #TQC-B50158   Add
 # ELSE
 #    CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
 # END IF
  #FUN-B60140   ---end      Add
   #CHI-A60036 add --end--
   CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate    #FUN-B60140   Add
   IF g_fas.fas02 < l_bdate OR g_fas.fas02 > l_edate THEN
      CALL cl_err(g_fas.fas02,'afa-308',0)
      RETURN
   END IF

  #FUN-B60140   ---start   Add
   IF g_faa.faa31 = "Y" THEN
      CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate     
      IF g_fas.fas02 < l_bdate OR g_fas.fas02 > l_edate THEN
         CALL cl_err(g_fas.fas02,'afa-308',0)
         RETURN
      END IF
   END IF
  #FUN-B60140   ---end     Add

   IF NOT cl_sure(18,20) THEN RETURN END IF
   BEGIN WORK
 
    OPEN t102_cl USING g_fas.fas01
    IF STATUS THEN
       CALL cl_err("OPEN t102_cl:", STATUS, 1)
       CLOSE t102_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t102_cl INTO g_fas.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fas.fas01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t102_cl ROLLBACK WORK RETURN
    END IF
   LET g_success = 'Y'
   #--------- 過帳(2)insert fap_file
   DECLARE t102_cur2 CURSOR FOR
      SELECT * FROM fat_file WHERE fat01=g_fas.fas01
   CALL s_showmsg_init()    #No.FUN-710028
   FOREACH t102_cur2 INTO l_fat.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF SQLCA.sqlcode != 0 THEN
         CALL s_errmsg('fat01',g_fas.fas01,'foreach:',SQLCA.sqlcode,1)   #No.FUN-710028
         EXIT FOREACH
         LET g_success='N'   #FUN-580109
      END IF
      #------- 先找出對應之 faj_file 資料
    SELECT * INTO l_faj.* FROM faj_file WHERE faj02=l_fat.fat03
                                            AND faj022=l_fat.fat031
      IF STATUS THEN
         CALL cl_err('sel faj',STATUS,0)
         LET g_showmsg = l_fat.fat03,"/",l_fat.fat031                 #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'
      END IF
      #-->免稅資料
      IF l_faj.faj40 = '3' AND p_cmd = 'S' THEN
         LET l_msg = l_faj.faj02,' ',l_faj.faj022 CLIPPED
         CALL s_errmsg('','',l_msg,'afa-305',1)  #No.FUN-710028 
         LET g_success = 'N'
         CONTINUE FOREACH  #No.FUN-710028
      END IF
      #-->判斷輸入日期之前是否有未過帳
      SELECT count(*) INTO l_cnt FROM fat_file,fas_file
       WHERE fat01 = fas01
         AND fat03 = l_fat.fat03
         AND fat031= l_fat.fat031 AND fas02 <= g_fas.fas02   #MOD-9B0178 mod
         AND faspost = 'N'
         AND fas01 != g_fas.fas01
         AND fasconf <> 'X'   #MOD-590470
      IF l_cnt  > 0 THEN
         LET l_msg = l_fat.fat01,' ',l_fat.fat02,' ',
                     l_fat.fat03,' ',l_fat.fat031
         CALL s_errmsg('','',l_msg,'afa-309',1)  #No.FUN-710028 
         LET g_success = 'N'
         CONTINUE FOREACH  #No.FUN-710028
      END IF
      IF cl_null(l_fat.fat031) THEN
         LET l_fat.fat031 = ' '
      END IF
      #FUN-AB0088---add---str---
      IF cl_null(l_faj.faj432) THEN LET l_faj.faj432 = ' ' END IF
      IF cl_null(l_faj.faj282) THEN LET l_faj.faj282 = ' ' END IF
      IF cl_null(l_faj.faj312) THEN LET l_faj.faj312 = 0 END IF
      IF cl_null(l_faj.faj142) THEN LET l_faj.faj142 = 0 END IF
      IF cl_null(l_faj.faj1412) THEN LET l_faj.faj1412 = 0 END IF
      IF cl_null(l_faj.faj332) THEN LET l_faj.faj332 = 0 END IF
      IF cl_null(l_faj.faj322) THEN LET l_faj.faj322 = 0 END IF
      IF cl_null(l_faj.faj232) THEN LET l_faj.faj232 = ' ' END IF
      IF cl_null(l_faj.faj592) THEN LET l_faj.faj592 = 0 END IF
      IF cl_null(l_faj.faj602) THEN LET l_faj.faj602 = 0 END IF
      IF cl_null(l_faj.faj342) THEN LET l_faj.faj342 =' ' END IF
      IF cl_null(l_faj.faj352) THEN LET l_faj.faj352 = 0 END IF
      IF cl_null(l_faj.faj312) THEN LET l_faj.faj312 = 0 END IF
      #FUN-AB0088---add---end---
     #CHI-C60010---str---
      SELECT aaa03 INTO g_faj143 FROM aaa_file
        WHERE aaa01 = g_faa.faa02c
      IF NOT cl_null(g_faj143) THEN
         SELECT azi04 INTO g_azi04_1 FROM azi_file
          WHERE azi01 = g_faj143
      END IF
      CALL cl_digcut(l_faj.faj142,g_azi04_1) RETURNING l_faj.faj142
      CALL cl_digcut(l_faj.faj312,g_azi04_1) RETURNING l_faj.faj312
      CALL cl_digcut(l_faj.faj332,g_azi04_1) RETURNING l_faj.faj332
      CALL cl_digcut(l_faj.faj1412,g_azi04_1) RETURNING l_faj.faj1412
      CALL cl_digcut(l_faj.faj322,g_azi04_1) RETURNING l_faj.faj322
      CALL cl_digcut(l_faj.faj592,g_azi04_1) RETURNING l_faj.faj592
      CALL cl_digcut(l_faj.faj602,g_azi04_1) RETURNING l_faj.faj602
      CALL cl_digcut(l_faj.faj352,g_azi04_1) RETURNING l_faj.faj352
     #CHI-C60010---end---
      INSERT INTO fap_file (fap01,fap02,fap021,fap03,fap04,fap05,fap06,fap07,
                            fap08,fap09,fap10,fap101,fap11,fap12,fap13,fap14,
                            fap15,fap16,fap17,fap18,fap19,fap20,fap201,fap21,
                            fap22,fap23,fap24,fap25,fap26,fap30,fap31,fap32,
                            fap33,fap34,fap341,fap35,fap36,fap37,fap38,fap39,
                            fap40,fap41,fap50,fap501,fap58,fap59,fap60,fap61,
                            fap62,fap63,fap64,fap65,
                            fap121,fap131,fap141,fap581,fap591,fap601,fap77,  #CHI-9B0032 add fap77
                            faplegal,fap56,     #No.FUN-680028 #FUN-980003 add #MOD-B30117 add fap56
                            #FUN-AB0088---add---str---
                            fap052,fap062,fap072,fap082,
                            fap092,fap103,fap1012,fap112,
                            fap152,fap162,fap212,fap222,
                            fap232,fap242,fap252,fap262,fap612,fap622) 
                            #FUN-AB0088---add---end---
           VALUES (l_faj.faj01,l_fat.fat03,l_fat.fat031,'3',
                   g_fas.fas02,l_faj.faj43,l_faj.faj28,l_faj.faj30,
                   l_faj.faj31,l_faj.faj14,l_faj.faj141,l_faj.faj33,
                   l_faj.faj32,l_faj.faj53,l_faj.faj54,l_faj.faj55,
                   l_faj.faj23,l_faj.faj24,l_faj.faj20,l_faj.faj19,
                   l_faj.faj21,l_faj.faj17,l_faj.faj171,l_faj.faj58,
                   l_faj.faj59,l_faj.faj60,l_faj.faj34,l_faj.faj35,
                   l_faj.faj36,l_faj.faj61,l_faj.faj65,l_faj.faj66,
                   l_faj.faj62,l_faj.faj63,l_faj.faj68,l_faj.faj67,
                   l_faj.faj69,l_faj.faj70,l_faj.faj71,l_faj.faj72,
                   l_faj.faj73,l_faj.faj100,l_fat.fat01,l_fat.fat02,
                   l_fat.fat07,l_fat.fat08,l_fat.fat11,l_fat.fat09,
                   l_fat.fat10,l_fat.fat05,l_fat.fat04,l_fat.fat06,
                   l_faj.faj531,l_faj.faj541,l_faj.faj551,l_fat.fat071,     #No.FUN-680028
                   l_fat.fat081,l_fat.fat111,l_faj.faj43,   #CHI-9B0032 add faj43
                   g_legal,0,     #No.FUN-680028 #FUN-980003 add #MOD-B30117 add 0
                   #FUN-AB0088---add---str--- 
                   l_faj.faj432,l_faj.faj282,l_faj.faj302,l_faj.faj312,
                   l_faj.faj142,l_faj.faj1412,l_faj.faj332,l_faj.faj322,
                   l_faj.faj232,l_faj.faj242,l_faj.faj582,l_faj.faj592,
                   l_faj.faj602,l_faj.faj342,l_faj.faj352,l_faj.faj362, 
                   l_fat.fat092,l_fat.fat102)
                   #FUN-AB0088---add---end--- 
       IF STATUS {OR SQLCA.sqlerrd[3]= 0} THEN  #MOD-530430
         LET g_showmsg = l_fat.fat03,"/",l_fat.fat031,"/",'3',"/",g_fas.fas02    #No.FUN-710028
         CALL s_errmsg('fap02,fap021,fap03,fap04',g_showmsg,'ins fap',STATUS,1)  #No.FUN-710028
         LET g_success = 'N'
      END IF
      SELECT faf03 INTO l_faf03 FROM faf_file WHERE faf01 = l_fat.fat06   #No:9773   #MOD-720073
      IF SQLCA.sqlcode THEN LET l_faf03 = ' ' END IF
      #--------- 過帳(3)update faj_file
      UPDATE faj_file set faj19  = l_fat.fat04, #保管人
                          faj20  = l_fat.fat05, #保管部門
                          faj21  = l_fat.fat06, #存放位置
                          faj22  = l_faf03,     #存放工廠
                          faj53  = l_fat.fat07, #資產科目
                          faj54  = l_fat.fat08, #累折科目
                          faj55  = l_fat.fat11, #折舊科目
                          faj23  = l_fat.fat09, #分攤方式
                          faj24  = l_fat.fat10, #分攤部門
                          faj100 = g_fas.fas02, #最近異動日
                          #No.FUN-680028 --begin
                          faj531 = l_fat.fat071,
                          faj541 = l_fat.fat081,
                          faj551 = l_fat.fat111
                          #No.FUN-680028 --end
                          #FUN-AB0088---add---str---
                         #,faj232 = l_fat.fat092, #FUN-B90096 mark
                          #faj242 = l_fat.fat102 #FUN-B90096 mark
                          #FUN-AB0088---add---end---
       WHERE faj02=l_fat.fat03 AND faj022=l_fat.fat031
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fat.fat03,"/",l_fat.fat031                 #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'
      END IF
      #FUN-B90096----------add-------str
      IF g_faa.faa31 = 'Y' THEN
         UPDATE faj_file SET faj232 = l_fat.fat092,
                             faj242 = l_fat.fat102
            WHERE faj02=l_fat.fat03 AND faj022=l_fat.fat031
         IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
            LET g_showmsg = l_fat.fat03,"/",l_fat.fat031
            CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF 
      #FUN-B90096----------add-------end
     #str MOD-A10194 add
      #--------- 過帳(4)update fga_file
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM fga_file
       WHERE fga03=l_fat.fat03 AND fga031=l_fat.fat031
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
      IF l_cnt > 0 THEN
         UPDATE fga_file SET fga12  = l_fat.fat04, #保管人
                             fga13  = l_fat.fat05, #保管部門
                             fga14  = l_fat.fat06, #存放位置
                             fga15  = l_faf03      #存放工廠
          WHERE fga03=l_fat.fat03 AND fga031=l_fat.fat031
         IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
            LET g_showmsg = l_fat.fat03,"/",l_fat.fat031
            CALL s_errmsg('fga03,fga031',g_showmsg,'upd fga',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF
     #end MOD-A10194 add
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   IF g_success = 'Y' THEN
      #--------- 過帳(1)update faspost
      UPDATE fas_file SET faspost = 'Y' WHERE fas01 = g_fas.fas01
          IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
             CALL s_errmsg('fas01',g_fas.fas01,'upd faspost',STATUS,1)                #No.FUN-710028
             LET g_fas.faspost='N'
             LET g_success = 'N'
          ELSE
             LET g_fas.faspost='Y'
             LET g_success = 'Y'
          END IF
   END IF
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'N' THEN
      ROLLBACK WORK
      CALL cl_flow_notify(g_fas.fas01,'S')
   ELSE
      COMMIT WORK
   END IF
   DISPLAY BY NAME g_fas.faspost
 
  #-MOD-A60168-add-
  #IF g_aza.aza63 = 'Y' THEN   #FUN-AB0088 mark
  #IF g_faa.faa31 = 'Y' THEN   #FUN-AB0088 add                          #MOD-BA0201 mark
   #IF g_faa.faa31 = 'Y' AND g_fah.fahdmy3 = 'Y' THEN   #FUN-AB0088 add  #MOD-BA0201 #MOD-BC0130 mark 
   IF g_faa.faa31 = 'Y' AND g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN #MOD-BC0130 add
      IF cl_null(g_fah.fahgslp1) THEN
         CALL cl_err(g_fas.fas01,'axr-070',1)
         RETURN
      END IF
   END IF
  #-MOD-A60168-end-

  #IF p_cmd = 'S' AND g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN #TQC-B10200 mark
   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN                 #TQC-B10200
      LET g_wc_gl = 'npp01 = "',g_fas.fas01,'" AND npp011 = 1'
      LET g_str="afap302 '",g_wc_gl CLIPPED,"' '",g_fas.fasuser,"' '",g_fas.fasuser,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fah.fahgslp,"' '",g_fas.fas02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"   #No.FUN-680028   #MOD-860284#FUN-860040
      CALL cl_cmdrun_wait(g_str)
#FUN-C30313---mark---START
#    #FUN-B60140   ---start   Add
#     IF g_faa.faa31 = "Y" THEN
#        LET g_str="afap202 '",g_wc_gl CLIPPED,"' '",g_fas.fasuser,"' '",g_fas.fasuser,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fah.fahgslp,"' '",g_fas.fas02,"' '",g_fah.fahgslp1,"'"
#        CALL cl_cmdrun_wait(g_str)
#     END IF
#    #FUN-B60140   ---end     Add
#     SELECT fas07,fas08,fas072,fas082    #FUN-B60140    Add fas072  fas082
#       INTO g_fas.fas07,g_fas.fas08,g_fas.fas072,g_fas.fas082  #FUN-B60140   fa072 fas082
#FUN-C30313---mark---END
      SELECT fas07,fas08             #FUN-C30313 add
        INTO g_fas.fas07,g_fas.fas08 #FUN-C30313 add
        FROM fas_file
       WHERE fas01 = g_fas.fas01
      DISPLAY BY NAME g_fas.fas07
      DISPLAY BY NAME g_fas.fas08
      #DISPLAY BY NAME g_fas.fas072   #FUN-B60140   Add #FUN-C30313 mark
      #DISPLAY BY NAME g_fas.fas082   #FUN-B60140   Add #FUN-C30313 mark
   END IF
#FUN-C30313---add---START-----
   IF g_faa.faa31 = "Y" THEN
      IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN
         LET g_str="afap202 '",g_wc_gl CLIPPED,"' '",g_fas.fasuser,"' '",g_fas.fasuser,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fah.fahgslp,"' '",g_fas.fas02,"' '",g_fah.fahgslp1,"'"
         CALL cl_cmdrun_wait(g_str)
         SELECT fas072,fas082
           INTO g_fas.fas072,g_fas.fas082
           FROM fas_file
          WHERE fas01 = g_fas.fas01
         DISPLAY BY NAME g_fas.fas072
         DISPLAY BY NAME g_fas.fas082
      END IF
   END IF
#FUN-C30313---add---END-------
 
   IF g_fas.fasconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fas.fas09 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
  #-MOD-A60168-mark-
  #IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN
  #   LET g_wc_gl = 'npp01 = "',g_fas.fas01,'" AND npp011 = 1'
  #   LET g_str="afap302 '",g_wc_gl CLIPPED,"' '",g_fas.fasuser,"' '",g_fas.fasuser,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fah.fahgslp,"' '",g_fas.fas02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"   #No.FUN-680028   #MOD-860284#FUN-860040
  #   CALL cl_cmdrun_wait(g_str)
  #   SELECT fas07,fas08 INTO g_fas.fas07,g_fas.fas08 FROM fas_file
  #    WHERE fas01 = g_fas.fas01
  #   DISPLAY BY NAME g_fas.fas07
  #   DISPLAY BY NAME g_fas.fas08
  #END IF
  #-MOD-A60168-end-
   CALL cl_set_field_pic(g_fas.fasconf,g_chr2,g_fas.faspost,"",g_chr,"")
END FUNCTION
 
FUNCTION t102_w()
   DEFINE l_aba19  LIKE aba_file.aba19        #No.FUN-680028
   DEFINE l_dbs    STRING                     #No.FUN-680028
   DEFINE l_sql    STRING                     #No.FUN-680028
   DEFINE l_fat    RECORD LIKE fat_file.*,
          l_faj    RECORD LIKE faj_file.*,
          l_fap13  LIKE fap_file.fap13,
          l_fap12  LIKE fap_file.fap12,
          l_fap14  LIKE fap_file.fap14,
          l_fap15  LIKE fap_file.fap15,
          l_fap16  LIKE fap_file.fap16,
          l_fap17  LIKE fap_file.fap17,
          l_fap18  LIKE fap_file.fap18,
          l_fap19  LIKE fap_file.fap19,
          l_fap41  LIKE fap_file.fap41,
         #MOD-BB0112 -- begin --
          l_fap581 LIKE fap_file.fap581,
          l_fap591 LIKE fap_file.fap591,
          l_fap601 LIKE fap_file.fap601,
         #MOD-BB0112 -- end --
          l_fas02  LIKE fas_file.fas02,
          l_faf03  LIKE faf_file.faf03,
          l_cnt             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          l_msg             LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(70)
          l_bdate,l_edate   LIKE type_file.dat          #No.FUN-680070 DATE

   DEFINE l_fap152   LIKE fap_file.fap152     #FUN-AB0088
   DEFINE l_fap162   LIKE fap_file.fap162     #FUN-AB0088
   DEFINE l_fas02_1  LIKE fas_file.fas02
   IF s_shut(0) THEN RETURN END IF
   IF g_fas.fas01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add-
   #-->立帳日期小於關帳日期
   IF g_fas.fas02 < g_faa.faa09 THEN
      CALL cl_err(g_fas.fas01,'aap-176',1) RETURN
   END IF
  #-MOD-A80137-end-
#FUN-C30313---add---START-----
   IF g_faa.faa31 = "Y" THEN
      #-->立帳日期小於關帳日期
      IF g_fas.fas02 < g_faa.faa092 THEN
         CALL cl_err(g_fas.fas01,'aap-176',1) RETURN
      END IF
   END IF
#FUN-C30313---add---END-------

    SELECT * INTO g_fas.* FROM fas_file WHERE fas01 = g_fas.fas01
   #--->折舊年月判斷必須為當月
   SELECT fas02 INTO l_fas02 FROM fas_file WHERE fas01 = g_fas.fas01
   IF SQLCA.sqlcode THEN LET l_fas02 = ' '  RETURN END IF
   #CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate #CHI-A60036 mark
   #CHI-A60036 add --start--
   CALL s_get_bookno(g_faa.faa07)
       RETURNING g_flag,g_bookno1,g_bookno2
   #FUN-AB0088---add---str---
   #固資已不和二套掛鉤，所以原本利用s_get_bookno取到賬別一及賬別二是用是否使用二套賬來判斷
   #此處取賬別二要重新處理，應取固資參數欄位財二賬套faa02c作為賬別二的賬套
   IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF
   #FUN-AB0088---add---end---

#FUN-C30313---mark---START 
# #IF g_aza.aza63 = 'Y' THEN   #FUN-AB0088 mark
#  IF g_faa.faa31 = 'Y' THEN   #FUN-AB0088 add
#    #CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate   #FUN-AB0088 mark
#    #CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno2) RETURNING l_flag,l_bdate,l_edate   #FUN-AB0088 add   #TQC-B50158   Mark 
#     CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate                     #TQC-B50158   Add
#  ELSE
#     CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
#  END IF
#  #CHI-A60036 add --end--
#FUN-C30313---mark---END
   CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate #FUN-C30313 add
   IF g_fas.fas02 < l_bdate OR g_fas.fas02 > l_edate THEN
      CALL cl_err(g_fas.fas02,'afa-339',0)
      RETURN
   END IF
#FUN-C30313---add---START-----   
   IF g_faa.faa31 = "Y" THEN
      CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate                  #TQC-B50158   Add
      IF g_fas.fas02 < l_bdate OR g_fas.fas02 > l_edate THEN
         CALL cl_err(g_fas.fas02,'afa-339',0)
         RETURN
      END IF
   END IF
#FUN-C30313---add---END-------

   IF NOT cl_null(g_fas.fas07) AND g_fah.fahglcr = 'N' THEN       #FUN-670060     #No.FUN-680028
      CALL cl_err(g_fas.fas07,'afa-311',0) RETURN
   END IF
   
#FUN-C30313---add---START-----
   IF g_faa.faa31 = "Y" THEN
      IF NOT cl_null(g_fas.fas072) AND g_fah.fahglcr = 'N' THEN
         CALL cl_err(g_fas.fas072,'afa-311',0) RETURN
      END IF
   END IF
#FUN-C30313---add---END-------

   IF g_fas.faspost != 'Y' THEN
      CALL cl_err(g_fas.fas01,'afa-108',0)
      RETURN
   END IF
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_fas.fas01) RETURNING g_t1     #No.FUN-550071
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
   IF NOT cl_null(g_fas.fas07) OR NOT cl_null(g_fas.fas08) THEN
      IF NOT (g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y') THEN
         CALL cl_err(g_fas.fas01,'axr-370',0) RETURN
      END IF
   END IF
   
#FUN-C30313---add---START-----
   IF g_faa.faa31 = "Y" THEN
      IF NOT cl_null(g_fas.fas072) OR NOT cl_null(g_fas.fas082) THEN
         IF NOT (g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y') THEN #FUN-C30313 fahdmy3-->fahdmy32
            CALL cl_err(g_fas.fas01,'axr-370',0) RETURN
         END IF
      END IF
   END IF
#FUN-C30313---add---END-------
  
   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
      LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
     #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",  #FUN-A50102
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
                  "  WHERE aba00 = '",g_faa.faa02b,"'",
                  "    AND aba01 = '",g_fas.fas07,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql   #FUN-A50102
      PREPARE aba_pre FROM l_sql
      DECLARE aba_cs CURSOR FOR aba_pre
      OPEN aba_cs
      FETCH aba_cs INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_fas.fas07,'axr-071',1)
         RETURN
      END IF
   END IF
#FUN-C30313---add---START-----
   IF g_faa.faa31 = "Y" THEN
      IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' THEN
         LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
                     "  WHERE aba00 = '",g_faa.faa02c,"'",
                     "    AND aba01 = '",g_fas.fas072,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         PREPARE aba_pre3 FROM l_sql
         DECLARE aba_cs3 CURSOR FOR aba_pre3
         OPEN aba_cs3
         FETCH aba_cs3 INTO l_aba19
         IF l_aba19 = 'Y' THEN
            CALL cl_err(g_fas.fas072,'axr-071',1)
            RETURN
         END IF
      END IF
   END IF
#FUN-C30313---add---END-------
 
   IF NOT cl_sure(18,20) THEN RETURN END IF
  #---------------------------------CHI-C90051------------------------(S)
   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
      LET g_str="afap303 '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fas.fas07,"' '2' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT fas07,fas08
        INTO g_fas.fas07,g_fas.fas08
        FROM fas_file
       WHERE fas01 = g_fas.fas01
      DISPLAY BY NAME g_fas.fas07
      DISPLAY BY NAME g_fas.fas08
      IF NOT cl_null(g_fas.fas07) THEN
         CALL cl_err('','aap-929',0)
         RETURN
      END IF
      IF g_faa.faa31 = "Y" THEN
         LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_fas.fas072,"' '2' 'Y'"
         CALL cl_cmdrun_wait(g_str)
         SELECT fas072,fas082
           INTO g_fas.fas072,g_fas.fas082
           FROM fas_file
          WHERE fas01 = g_fas.fas01
         DISPLAY BY NAME g_fas.fas072
         DISPLAY BY NAME g_fas.fas082
         IF NOT cl_null(g_fas.fas072) THEN
            CALL cl_err('','aap-929',0)
            RETURN
         END IF
      END IF
   END IF
  #---------------------------------CHI-C90051------------------------(E)
   BEGIN WORK
 
    OPEN t102_cl USING g_fas.fas01
    IF STATUS THEN
       CALL cl_err("OPEN t102_cl:", STATUS, 1)
       CLOSE t102_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t102_cl INTO g_fas.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fas.fas01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t102_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
   #--------- 還原過帳(2)update faj_file
   DECLARE t102_cur3 CURSOR FOR
      SELECT * FROM fat_file WHERE fat01=g_fas.fas01
   CALL s_showmsg_init()    #No.FUN-710028
   FOREACH t102_cur3 INTO l_fat.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF SQLCA.sqlcode != 0 THEN
         CALL s_errmsg('fat01',g_fas.fas01,'foreach:',SQLCA.sqlcode,0)   #No.FUN-710028 
         EXIT FOREACH
      END IF
      #-->判斷輸入日期之前是否有已過帳
      SELECT count(*) INTO l_cnt FROM fat_file,fas_file
                      WHERE fat01  = fas01
                        AND fat03  = l_fat.fat03
                        AND fat031 = l_fat.fat031
                        AND fas02 >= l_fas02
                        AND faspost= 'Y'
                        AND fas01 != g_fas.fas01
      IF l_cnt  > 0 THEN
         #add by lixwz210322 s---
         SELECT count( unique fas02) INTO l_cnt FROM fat_file,fas_file
          WHERE fat01  = fas01
            AND fat03  = l_fat.fat03
            AND fat031 = l_fat.fat031
            AND fas02 >= l_fas02
            AND faspost= 'Y'
            AND fas01 != g_fas.fas01
         IF l_cnt = 1 THEN
            SELECT  unique fas02 INTO l_fas02_1 FROM fat_file,fas_file
             WHERE fat01  = fas01
               AND fat03  = l_fat.fat03
               AND fat031 = l_fat.fat031
               AND fas02 >= l_fas02
               AND faspost= 'Y'
               AND fas01 != g_fas.fas01
            IF l_fas02_1 <> l_fas02 THEN
            
               LET l_msg = l_fat.fat01,' ',l_fat.fat02,' ',
                           l_fat.fat03,' ',l_fat.fat031
               CALL s_errmsg('','',l_msg,'afa-310',1)  #No.FUN-710028
               LET g_success = 'N'
               CONTINUE FOREACH  #No.FUN-710028 
         
            END IF
         ELSE
         #add by lixwz210322 e--- 
            LET l_msg = l_fat.fat01,' ',l_fat.fat02,' ',
                        l_fat.fat03,' ',l_fat.fat031
            CALL s_errmsg('','',l_msg,'afa-310',1)  #No.FUN-710028
            LET g_success = 'N'
            CONTINUE FOREACH  #No.FUN-710028
         END IF #add by lixwz210322  
      END IF
      #--> 找出 faj_file 中對應之財產編號+附號
    SELECT * INTO l_faj.* FROM faj_file WHERE faj02=l_fat.fat03
                                            AND faj022=l_fat.fat031
      IF STATUS THEN
         CALL cl_err('sel faj',STATUS,0)
         LET g_showmsg = l_fat.fat03,"/",l_fat.fat031                 #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,0)   #No.FUN-710028
         CONTINUE FOREACH  #No.FUN-710028 
      END IF
      #----- 找出 fap_file 之 fap05 以便 update faj_file.faj43
     #MOD-BB0112 -- mark begin --
     #SELECT fap13,fap12,fap14,fap15,fap16,fap17,fap18,fap19,fap41
     #  INTO l_fap13,l_fap12,l_fap14,l_fap15,l_fap16,l_fap17,
     #       l_fap18,l_fap19,l_fap41
     #MOD-BB0112 -- mark end --
     #MOD-BB0112 -- begin --
      SELECT fap13,fap12,fap14,fap15,fap16,fap17,fap18,fap19,fap41,
             fap581,fap591,fap601
        INTO l_fap13,l_fap12,l_fap14,l_fap15,l_fap16,l_fap17,
             l_fap18,l_fap19,l_fap41,
             l_fap581,l_fap591,l_fap601
     #MOD-BB0112 -- end --
        FROM fap_file
       WHERE fap50=l_fat.fat01 AND fap501=l_fat.fat02 AND fap03='3'
          IF STATUS THEN #No.7926
             LET g_showmsg = l_fat.fat01,"/",l_fat.fat02,"/",'3'                #No.FUN-710028 
             CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'sel fap',STATUS,1)   #No.FUN-710028
             LET g_success = 'N'
          END IF
      SELECT faf03 INTO l_faf03 FROM faf_file WHERE faf01=l_fap19      #MOD-9C0001
      IF SQLCA.sqlcode THEN LET l_faf03 = ' ' END IF
      UPDATE faj_file set faj19  = l_fap18,  #保管人員
                          faj20  = l_fap17,  #保管部門
                          faj21  = l_fap19,  #存放位置
                          faj22  = l_faf03,  #存放工廠
                          faj53  = l_fap12,  #資產科目
                          faj54  = l_fap13,  #累折科目
                          faj55  = l_fap14,  #折舊科目
                          faj23  = l_fap15,  #分攤方式
                          faj24  = l_fap16,  #分攤部門
                          faj100 = l_fap41,  #異動日期   #MOD-BB0112 add ,
                         #MOD-BB0112 -- begin --
                          faj531 = l_fap581,
                          faj541 = l_fap591,
                          faj551 = l_fap601
                         #MOD-BB0112 -- end --
       WHERE faj02=l_fat.fat03 AND faj022=l_fat.fat031
      IF STATUS  THEN
         LET g_showmsg = l_fat.fat03,"/",l_fat.fat031                 #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'
      END IF
      #FUN-AB0088---add---str---
      IF g_faa.faa31 = 'Y' THEN
          SELECT fap152,fap162
            INTO l_fap152,l_fap162
            FROM fap_file
           WHERE fap50=l_fat.fat01 AND fap501=l_fat.fat02 AND fap03='3'
          IF STATUS THEN #No.7926
             LET g_showmsg = l_fat.fat01,"/",l_fat.fat02,"/",'3'              
             CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'sel fap',STATUS,1) 
             LET g_success = 'N'
          END IF
          UPDATE faj_file SET faj232 = l_fap152,
                              faj242 = l_fap162  
           WHERE faj02=l_fat.fat03 AND faj022=l_fat.fat031
          IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
             LET g_showmsg = l_fat.fat03,"/",l_fat.fat031               
             CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1) 
             LET g_success = 'N'
          END IF
      END IF
      #FUN-AB0088---add---end---   
     #str MOD-A10194 add
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM fga_file
       WHERE fga03=l_fat.fat03 AND fga031=l_fat.fat031
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
      IF l_cnt > 0 THEN
         UPDATE fga_file SET fga12  = l_fap18,  #保管人
                             fga13  = l_fap17,  #保管部門
                             fga14  = l_fap19,  #存放位置
                             fga15  = l_faf03   #存放工廠
          WHERE fga03=l_fat.fat03 AND fga031=l_fat.fat031
         IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
            LET g_showmsg = l_fat.fat03,"/",l_fat.fat031
            CALL s_errmsg('fga03,fga031',g_showmsg,'upd fga',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF
     #end MOD-A10194 add
      #--------- 還原過帳(3)delete fap_file
      DELETE FROM fap_file WHERE fap50=l_fat.fat01 AND fap501= l_fat.fat02
                             AND fap03 = '3'
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fat.fat01,"/",l_fat.fat02,"/",'3'                #No.FUN-710028
         CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'del fap',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'
      END IF
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   #--------- 還原過帳(1)update fas_file
   IF g_success = 'Y' THEN
      UPDATE fas_file SET faspost = 'N' WHERE fas01 = g_fas.fas01
         IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
            CALL s_errmsg('fas01',g_fas.fas01,'upd faspost',STATUS,1)                #No.FUN-710028
            LET g_fas.faspost='Y'
            LET g_success = 'N'
         ELSE
            LET g_fas.faspost='N'
            LET g_success = 'Y'
         END IF
   END IF
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'N' THEN ROLLBACK WORK ELSE COMMIT WORK END IF
   DISPLAY BY NAME g_fas.faspost
   IF g_fas.fasconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fas.fas09 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
 #---------------------------------CHI-C90051------------------------mark
 # IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN
 #    LET g_str="afap303 '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fas.fas07,"' '2' 'Y'"
 #    CALL cl_cmdrun_wait(g_str)
 #    SELECT fas07,fas08 INTO g_fas.fas07,g_fas.fas08 FROM fas_file
 #     WHERE fas01 = g_fas.fas01
 #    DISPLAY BY NAME g_fas.fas07
 #    DISPLAY BY NAME g_fas.fas08
 # END IF
 ##FUN-C30313---add---START-----
 # IF g_faa.faa31 = "Y" THEN
 #    IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN
 #       LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_fas.fas072,"' '2' 'Y'"
 #       CALL cl_cmdrun_wait(g_str)
 #       SELECT fas072,fas082
 #         INTO g_fas.fas072,g_fas.fas082
 #         FROM fas_file
 #        WHERE fas01 = g_fas.fas01
 #       DISPLAY BY NAME g_fas.fas072
 #       DISPLAY BY NAME g_fas.fas082
 #    END IF
 # END IF
 ##FUN-C30313---add---END-------
 #---------------------------------CHI-C90051------------------------mark
   CALL cl_set_field_pic(g_fas.fasconf,g_chr2,g_fas.faspost,"",g_chr,"")
END FUNCTION
 
#1.作废、2.取消作废
#FUNCTION t102_x()                       #FUN-D20035
FUNCTION t102_x(p_type)                  #FUN-D20035
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035
   DEFINE l_flag    LIKE type_file.chr1  #FUN-D20035
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_fas.* FROM fas_file WHERE fas01=g_fas.fas01
   IF g_fas.fas09 MATCHES '[Ss1]' THEN
      CALL cl_err("","mfg3557",0) RETURN
   END IF
   IF g_fas.fas01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fas.fasconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF

   #FUN-D20035---begin
   IF p_type = 1 THEN
      IF g_fas.fasconf='X' THEN RETURN END IF
   ELSE
      IF g_fas.fasconf<>'X' THEN RETURN END IF
   END IF
   #FUN-D20035---end

   BEGIN WORK
   LET g_success='Y'
 
   OPEN t102_cl USING g_fas.fas01
   IF STATUS THEN
      CALL cl_err("OPEN t102_cl:", STATUS, 1)
      CLOSE t102_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t102_cl INTO g_fas.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fas.fas01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t102_cl ROLLBACK WORK RETURN
   END IF
   #IF cl_void(0,0,g_fas.fasconf)   THEN                               #FUN-D20035
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF    #FUN-D20035
   IF cl_void(0,0,l_flag) THEN                                         #FUN-D20035
      LET g_chr=g_fas.fasconf
     #IF g_fas.fasconf ='N' THEN                                       #FUN-D20035
      IF p_type = 1 THEN                                               #FUN-D20035
         LET g_fas.fasconf='X'
         LET g_fas.fas09 = '9'   #FUN-580109
      ELSE
          LET g_fas.fasconf='N'
        LET g_fas.fas09 = '0'   #FUN-580109
      END IF
      UPDATE fas_file SET fasconf = g_fas.fasconf,
                          fas09   = g_fas.fas09,   #FUN-580109
                          fasmodu = g_user,
                          fasdate = TODAY
                    WHERE fas01 = g_fas.fas01
      IF STATUS THEN 
         CALL cl_err3("upd","fas_file",g_fas.fas01,"",STATUS,"","upd fasconf:",1)  #No.FUN-660136
         LET g_success='N' 
      END IF
      IF g_success='Y' THEN
          COMMIT WORK
          IF g_fas.fasconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
          IF g_fas.fas09 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
          CALL cl_set_field_pic(g_fas.fasconf,g_chr2,g_fas.faspost,"",g_chr,"")
          CALL cl_flow_notify(g_fas.fas01,'V')
      ELSE
          ROLLBACK WORK
      END IF
 
      SELECT fasconf,fas09 INTO g_fas.fasconf,g_fas.fas09   #FUN-580109
        FROM fas_file
       WHERE fas01 = g_fas.fas01
      DISPLAY BY NAME g_fas.fasconf
        DISPLAY BY NAME g_fas.fas09    #FUN-580109
   END IF
END FUNCTION
 
FUNCTION t102_gen_glcr(p_fas,p_fah)
  DEFINE p_fas     RECORD LIKE fas_file.*
  DEFINE p_fah     RECORD LIKE fah_file.*
 
    IF cl_null(p_fah.fahgslp) THEN
       CALL cl_err(p_fas.fas01,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    CALL s_showmsg_init()    #No.FUN-710028
    IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN #FUN-C30313 add
       CALL t102_gl(g_fas.fas01,g_fas.fas02,'0')
    END IF  #FUN-C30313 add
   #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN  #FUN-AB0088 mark
    IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN  #FUN-AB0088 add
       IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' THEN #FUN-C30313 add
          CALL t102_gl(g_fas.fas01,g_fas.fas02,'1')
       END IF #FUN-C30313 add
    END IF
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t102_carry_voucher()
  DEFINE l_fahgslp    LIKE fah_file.fahgslp
  DEFINE li_result    LIKE type_file.num5          #No.FUN-680070 SMALLINT
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
  #FUN-B90004--Begin--
   IF NOT cl_null(g_fas.fas07) THEN
      CALL cl_err(g_fas.fas07,'aap-618',1)
      RETURN
   END IF
   IF g_faa.faa31 = "Y" THEN
      IF g_fah.fahdmy32 = "Y" THEN #FUN-C30313 add
         IF NOT cl_null(g_fas.fas072) THEN
            CALL cl_err(g_fas.fas072,'aap-618',1)
            RETURN
         END IF
      END IF #FUN-C30313 add
   END IF
  #FUN-B90004---End---

    CALL s_get_doc_no(g_fas.fas01) RETURNING g_t1
    SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
    IF g_fah.fahdmy3 = 'N' THEN RETURN END IF
   #IF g_fah.fahglcr = 'Y' THEN               #FUN-B90004
    IF g_fah.fahglcr = 'Y' OR ( g_fah.fahglcr = 'N' AND NOT cl_null(g_fah.fahgslp)) THEN   #FUN-B90004
       LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
      #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",  #FUN-A50102
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_plant_new,'aba_file'),  #FUN-A50102 
                   "  WHERE aba00 = '",g_faa.faa02b,"'",
                   "    AND aba01 = '",g_fas.fas07,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
       PREPARE aba_pre2 FROM l_sql
       DECLARE aba_cs2 CURSOR FOR aba_pre2
       OPEN aba_cs2
       FETCH aba_cs2 INTO l_n
       IF l_n > 0 THEN
          CALL cl_err(g_fas.fas07,'aap-991',1)
          RETURN
       END IF

#FUN-C30313---mark---START
##FUN-B60140   ---start   Add
#      IF g_faa.faa31 = "Y" THEN
#         LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
#                     "  WHERE aba00 = '",g_faa.faa02c,"'",
#                     "    AND aba01 = '",g_fas.fas072,"'"
#          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#         PREPARE aba_pre22 FROM l_sql
#         DECLARE aba_cs22 CURSOR FOR aba_pre22
#         OPEN aba_cs22
#         FETCH aba_cs22 INTO l_n
#         IF l_n > 0 THEN
#            CALL cl_err(g_fas.fas072,'aap-991',1)
#            RETURN
#         END IF
#      END IF
##FUN-B60140   ---end     Add
#FUN-C30313---mark---END
 
       LET l_fahgslp = g_fah.fahgslp
    ELSE
      #CALL cl_err('','aap-992',1)   #FUN-B90004 mark
       CALL cl_err('','aap-936',1)   #FUN-B90004
       RETURN

    END IF
   #FUN-B90004--Begin--
    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahdmy32 = "Y" THEN #FUN-C30313 add
          IF g_fah.fahglcr = 'Y' OR ( g_fah.fahglcr = 'N' AND NOT cl_null(g_fah.fahgslp1)) THEN
             LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
                         "  WHERE aba00 = '",g_faa.faa02c,"'",
                         "    AND aba01 = '",g_fas.fas072,"'"
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
             PREPARE aba_pre23 FROM l_sql
             DECLARE aba_cs23 CURSOR FOR aba_pre23
             OPEN aba_cs23
             FETCH aba_cs23 INTO l_n
             IF l_n > 0 THEN
                CALL cl_err(g_fas.fas072,'aap-991',1)
                RETURN
             END IF
          ELSE
             CALL cl_err('','aap-936',1) 
             RETURN
          END IF
       END IF #FUN-C30313 add
    END IF
   #FUN-B90004---End---
    IF cl_null(l_fahgslp) THEN
       CALL cl_err(g_fas.fas01,'axr-070',1)
       RETURN
    END IF
   #IF g_aza.aza63 = 'Y' THEN   #FUN-AB0088 mark
    IF g_faa.faa31 = 'Y' THEN   #FUN-AB0088 add
       IF cl_null(g_fah.fahgslp1) THEN
          CALL cl_err(g_fas.fas01,'axr-070',1)
          RETURN
       END IF
    END IF
    LET g_wc_gl = 'npp01 = "',g_fas.fas01,'" AND npp011 = 1'
    LET g_str="afap302 '",g_wc_gl CLIPPED,"' '",g_fas.fasuser,"' '",g_fas.fasuser,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",l_fahgslp,"' '",g_fas.fas02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"  #No.FUN-680028   #MOD-860284#FUN-860040
    CALL cl_cmdrun_wait(g_str)

    #-----No:FUN-B60140-----
    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahdmy32 = "Y" THEN #FUN-C30313 add
          LET g_str="afap202 '",g_wc_gl CLIPPED,"' '",g_fas.fasuser,"' '",g_fas.fasuser,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",l_fahgslp,"' '",g_fas.fas02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"
          CALL cl_cmdrun_wait(g_str)
       END IF #FUN-C30313 add
    END IF
    #-----No:FUN-B60140 END-----

    SELECT fas07,fas08,fas072,fas082  #No:FUN-B60140
      INTO g_fas.fas07,g_fas.fas08,g_fas.fas072,g_fas.fas082  #No:FUN-B60140
      FROM fas_file
     WHERE fas01 = g_fas.fas01
    DISPLAY BY NAME g_fas.fas07
    DISPLAY BY NAME g_fas.fas08
    DISPLAY BY NAME g_fas.fas072  #No:FUN-B60140
    DISPLAY BY NAME g_fas.fas082  #No:FUN-B60140
    
END FUNCTION
 
FUNCTION t102_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_dbs      STRING 
  DEFINE l_sql      STRING
 
    IF NOT cl_confirm('aap-988') THEN RETURN END IF

  #FUN-B90004--Begin--
   IF cl_null(g_fas.fas07)  THEN
      CALL cl_err(g_fas.fas07,'aap-619',1)
      RETURN
   END IF
   IF g_faa.faa31 = "Y" THEN
      IF g_fah.fahdmy32 = "Y" THEN #FUN-C30313 add
         IF cl_null(g_fas.fas072)  THEN
            CALL cl_err(g_fas.fas072,'aap-619',1)
            RETURN
         END IF
      END IF #FUN-C30313 add
   END IF
  #FUN-B90004---End---
 
    CALL s_get_doc_no(g_fas.fas01) RETURNING g_t1
    SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
   #IF g_fah.fahglcr = 'N' THEN    #FUN-B90004
   #   CALL cl_err('','aap-990',1) #FUN-B90004
    IF g_fah.fahglcr = 'N' AND cl_null(g_fah.fahgslp) THEN   #FUN-B90004
       CALL cl_err('','aap-936',1)                           #FUN-B90004
       RETURN
    END IF
    #FUN-B90004--Begin--
    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahglcr = 'N' AND cl_null(g_fah.fahgslp1) THEN
          CALL cl_err('','aap-936',1)
          RETURN
       END IF
    END IF
   #FUN-B90004---End---
    LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
   #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",   #FUN-A50102
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
                "  WHERE aba00 = '",g_faa.faa02b,"'",
                "    AND aba01 = '",g_fas.fas07,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
    PREPARE aba_pre1 FROM l_sql
    DECLARE aba_cs1 CURSOR FOR aba_pre1
    OPEN aba_cs1
    FETCH aba_cs1 INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_fas.fas07,'axr-071',1)
       RETURN
    END IF

   #FUN-B60140   ---start   Add
    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahdmy32 = "Y" THEN #FUN-C30313 add
          LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
                      "  WHERE aba00 = '",g_faa.faa02c,"'",
                      "    AND aba01 = '",g_fas.fas072,"'"
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          PREPARE aba_pre12 FROM l_sql
          DECLARE aba_cs12 CURSOR FOR aba_pre1
          OPEN aba_cs12
          FETCH aba_cs12 INTO l_aba19
          IF l_aba19 = 'Y' THEN
             CALL cl_err(g_fas.fas072,'axr-071',1)
             RETURN
          END IF
       END IF #FUN-C30313 add
    END IF
   #FUN-B60140   ---end     Add
    LET g_str="afap303 '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fas.fas07,"' '2' 'Y'"
    CALL cl_cmdrun_wait(g_str)
   #FUN-B60140   ---start   Add
    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahdmy32 = "Y" THEN #FUN-C30313 add
          LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_fas.fas072,"' '2' 'Y'"
          CALL cl_cmdrun_wait(g_str)
       END IF #FUN-C30313 add
    END IF
   #FUN-B60140   ---end     Add
    SELECT fas07,fas08,fas072,fas082         #FUN-B60140   Add
      INTO g_fas.fas07,g_fas.fas08,g_fas.fas072,g_fas.fas082    #FUN-B60140    Add
      FROM fas_file
     WHERE fas01 = g_fas.fas01
    DISPLAY BY NAME g_fas.fas07
    DISPLAY BY NAME g_fas.fas08
    DISPLAY BY NAME g_fas.fas072    #FUN-B60140   Add
    DISPLAY BY NAME g_fas.fas082    #FUN-B60140   Add
END FUNCTION

#FUN-AB0088---add---str---
FUNCTION t102_fin_audit2()
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_rec_b2   LIKE type_file.num5
   DEFINE l_faj28    LIKE faj_file.faj28 
   DEFINE l_fat102   LIKE fat_file.fat102,
         l_faj23     LIKE faj_file.faj23,
         l_faj24     LIKE faj_file.faj24
   #MOD-BB0112 -- begin --
   DEFINE l_faj09    LIKE faj_file.faj09,
          l_faj282   LIKE faj_file.faj282
   #MOD-BB0112 -- end --

   #FUN-C30140---add---str---
   IF g_fas.fas01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fas.fasconf='Y' THEN CALL cl_err(g_fas.fas01,'afa-107',0) RETURN END IF
   IF g_fas.fasconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   IF g_fas.fas09 matches '[Ss]' THEN     
       CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
       RETURN
   END IF
   #FUN-C30140---add---end---

   OPEN WINDOW t1029_w2 WITH FORM "afa/42f/afat1029"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("afat1029")

   #FUN-BC0004--mark--str
   #LET g_sql =
   #    "SELECT fat02,fat03,fat031,faj06,fat04,fat05,fat06,fat071,fat081,fat092,",     #No.FUN-680028
   #    "fat102,fat111 ",  
   #    "  FROM fat_file,OUTER faj_file ",
   #    " WHERE fat01  ='",g_fas.fas01,"'",  #虫繷
   #    "   AND fat03  = faj02",
   #    "   AND fat031 = faj022",
   #    " ORDER BY 1"
   #FUN-BC0004--mark--end
   #FUN-BC0004--add--str
   LET g_sql = "SELECT fat02,fat03,fat031,'',fat04,fat05,fat06,fat071,fat081,fat092,",
               "fat102,fat111 ",
               "  FROM fat_file ",
               " WHERE fat01  ='",g_fas.fas01,"'",  #單頭
               " ORDER BY 1"
   #FUN-BC0004--add--end

   PREPARE afat102_2_pre FROM g_sql

   DECLARE afat102_2_c CURSOR FOR afat102_2_pre

   CALL g_fat2.clear()

   LET l_cnt = 1

   FOREACH afat102_2_c INTO g_fat2[l_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach fat2',STATUS,0)
         EXIT FOREACH
      END IF
      #FUN-BC0004--add--str
      SELECT faj06 INTO g_fat2[l_cnt].faj06 
        FROM faj_file
       WHERE faj02 = g_fat2[l_cnt].fat03
         AND faj022 = g_fat2[l_cnt].fat031
      #FUN-BC0004--add--end
      LET l_cnt = l_cnt + 1

   END FOREACH

   CALL g_fat2.deleteElement(l_cnt)

   LET l_rec_b2 = l_cnt - 1

   LET l_ac = 1

   CALL cl_set_act_visible("cancel", FALSE)

   IF g_fas.fasconf !="N" THEN   #已確認或作廢單據只能查詢 
      DISPLAY ARRAY g_fat2 TO s_fat2.* ATTRIBUTE(COUNT=l_rec_b2,UNBUFFERED)

         ON ACTION CONTROLG
            CALL cl_cmdask()
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
         
         ON ACTION about
            CALL cl_about()
         
         ON ACTION help
            CALL cl_show_help()

      END DISPLAY
   ELSE
    LET g_forupd_sql = " SELECT fat02,fat03,fat031,' ',fat04,fat05,fat06,fat071,fat081,fat092, ",  
                       "  fat102,fat111 ",   
                       "  FROM fat_file ",
                       "  WHERE fat01 = ? ",
                       "  AND fat02 = ? ",
                       "  FOR UPDATE "
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)    #FUN-AB0088 add
      DECLARE t102_2_bcl CURSOR FROM g_forupd_sql 
       
      INPUT ARRAY g_fat2 WITHOUT DEFAULTS FROM s_fat2.*
            ATTRIBUTE(COUNT=l_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
      
         BEFORE INPUT     
            IF l_rec_b2 != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            
         BEFORE ROW            
            LET l_ac = ARR_CURR()
            BEGIN WORK
            IF l_rec_b2 >= l_ac THEN 
               LET g_fat2_t.* = g_fat2[l_ac].* 
               OPEN t102_2_bcl USING g_fas.fas01,g_fat2_t.fat02
               IF STATUS THEN
                  CALL cl_err("OPEN t102_2_bcl:", STATUS, 1)
               ELSE
                  FETCH t102_2_bcl INTO g_fat2[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_fat2_t.fat02,SQLCA.sqlcode,1)
                  ELSE
                     SELECT faj06,faj23,faj24
                       INTO g_fat2[l_ac].faj06,l_faj23,l_faj24
                       FROM faj_file
                      WHERE faj02  = g_fat2[l_ac].fat03
                        AND faj022 = g_fat2[l_ac].fat031
                        AND faj43  NOT MATCHES '[056X]'
                        AND fajconf = 'Y'
                     IF cl_null(g_fat2[l_ac].fat092) THEN LET g_fat2[l_ac].fat092 = l_faj23 END IF
                     IF cl_null(g_fat2[l_ac].fat102) THEN LET g_fat2[l_ac].fat102 = l_faj24 END IF
                     DISPLAY BY NAME g_fat2[l_ac].fat092
                     DISPLAY BY NAME g_fat2[l_ac].fat102
                     #MOD-BB0112 -- begin --
                     SELECT faj09,faj282 INTO l_faj09,l_faj282 FROM faj_file
                      WHERE faj02 = g_fat2[l_ac].fat03
                        AND faj022 = g_fat2[l_ac].fat031
                     IF l_faj09 = '5' OR l_faj282 = '0' THEN
                        CALL cl_set_comp_required("fat071,fat081,fat111",FALSE)
                     ELSE
                        CALL cl_set_comp_required("fat071,fat081,fat111",TRUE)
                     END IF
                     #MOD-BB0112 -- end --
                  END IF
               END IF
            END IF
         
         
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fat2[l_ac].* = g_fat2_t.*
               CLOSE t102_2_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
        
           UPDATE fat_file SET fat071 = g_fat2[l_ac].fat071,
                               fat081 = g_fat2[l_ac].fat081,
                               fat092 = g_fat2[l_ac].fat092,
                               fat102 = g_fat2[l_ac].fat102,
                               fat111 = g_fat2[l_ac].fat111
             WHERE fat01 = g_fas.fas01
               AND fat02 = g_fat2_t.fat02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","fat_file",g_fas.fas01,g_fat2_t.fat02,SQLCA.sqlcode,"","",1)  
               LET g_fat2[l_ac].* = g_fat2_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
        #FUN-BC0004--add-str
        BEFORE FIELD fat071
           SELECT faj06,faj23,faj24
             INTO g_fat2[l_ac].faj06,l_faj23,l_faj24
             FROM faj_file
            WHERE faj02  = g_fat2[l_ac].fat03
              AND faj022 = g_fat2[l_ac].fat031
              AND faj43  NOT MATCHES '[056X]'
              AND fajconf = 'Y'
           IF cl_null(g_fat2[l_ac].fat092) THEN LET g_fat2[l_ac].fat092 = l_faj23 END IF
           IF cl_null(g_fat2[l_ac].fat102) THEN LET g_fat2[l_ac].fat102 = l_faj24 END IF
           DISPLAY BY NAME g_fat2[l_ac].fat092
           DISPLAY BY NAME g_fat2[l_ac].fat102
        #FUN-BC0004--add-end
        AFTER FIELD fat071
           IF NOT cl_null(g_fat2[l_ac].fat071) THEN
              CALL t102_fat071('a')
              IF NOT cl_null(g_errno) THEN
                 LET g_fat2[l_ac].fat071 = g_fat2_t.fat071
                 DISPLAY BY NAME g_fat2[l_ac].fat071
                 CALL cl_err(g_fat2[l_ac].fat071,g_errno,0)
                 NEXT FIELD fat071
              END IF
           END IF

        AFTER FIELD fat081
           LET l_faj28 = ''
           SELECT faj28 INTO l_faj28 FROM faj_file
            WHERE faj02 = g_fat2[l_ac].fat03
              AND faj022= g_fat2[l_ac].fat031
           IF cl_null(g_fat2[l_ac].fat081) AND l_faj28 != '0' THEN
              NEXT FIELD fat081
           END IF
           IF NOT cl_null(g_fat2[l_ac].fat081) THEN
              CALL t102_fat081('a')
              IF NOT cl_null(g_errno) THEN
                 LET g_fat2[l_ac].fat081 = g_fat2_t.fat081
                 DISPLAY BY NAME g_fat2[l_ac].fat081
                 CALL cl_err(g_fat2[l_ac].fat081,g_errno,0)
                 NEXT FIELD fat081
              END IF
           END IF

        AFTER FIELD fat092
           IF NOT cl_null(g_fat2[l_ac].fat092) THEN
              IF g_fat2[l_ac].fat092 NOT MATCHES '[12]' THEN
                 NEXT FIELD fat092
              END IF
           END IF

        BEFORE FIELD fat102
           IF g_fat2[l_ac].fat092 = '1' THEN
              IF cl_null(g_fat2[l_ac].fat102) THEN
                 LET g_fat2[l_ac].fat102 = g_fat2[l_ac].fat05
                 DISPLAY BY NAME g_fat2[l_ac].fat102
              END IF
           END IF

        AFTER FIELD fat102
           IF NOT cl_null(g_fat2[l_ac].fat102) THEN
              IF g_fat2[l_ac].fat092 = '1' THEN
                 CALL t102_fat101('2')  
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_fat2[l_ac].fat102,g_errno,0)
                      LET g_fat2[l_ac].fat102 = g_fat2_t.fat102
                      DISPLAY BY NAME g_fat2[l_ac].fat102
                      NEXT FIELD fat102
                   END IF
              ELSE
                 CALL t102_fat102_1('a')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_fat2[l_ac].fat102,g_errno,0)
                      LET g_fat2[l_ac].fat102 = g_fat2_t.fat102
                      NEXT FIELD fat102
                   END IF
                   SELECT faj55 INTO g_fat2[l_ac].fat111 FROM faj_file
                        WHERE faj02=g_fat2[l_ac].fat03 AND
                              faj022=g_fat2[l_ac].fat031
                   IF SQLCA.sqlcode THEN LET g_fat2[l_ac].fat111 = ' ' END IF
              END IF
           END IF

        AFTER FIELD fat111
            LET l_faj28 = ''
           SELECT faj28 INTO l_faj28 FROM faj_file
            WHERE faj02 = g_fat2[l_ac].fat03
              AND faj022= g_fat2[l_ac].fat031
           IF cl_null(g_fat2[l_ac].fat111) AND l_faj28 != '0' THEN
              NEXT FIELD fat111
           END IF
           IF NOT cl_null(g_fat2[l_ac].fat111) THEN
              CALL t102_fat111('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_fat2[l_ac].fat111,g_errno,0)
                 NEXT FIELD fat111
              END IF
           END IF
      
         AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN 
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fat2[l_ac].* = g_fat2_t.*
               CLOSE t102_2_bcl 
               ROLLBACK WORK 
               EXIT INPUT
            END IF
            CLOSE t102_2_bcl 
            COMMIT WORK

        ON ACTION controlp  
           CASE
              WHEN INFIELD(fat071)  #資產科目 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag03 MATCHES '[2]' "
                 LET g_qryparam.default1 = g_fat2[l_ac].fat071
                 LET g_qryparam.arg1 = g_bookno2 
                 CALL cl_create_qry() RETURNING g_fat2[l_ac].fat071
                 DISPLAY g_fat2[l_ac].fat071 TO fat071
                 NEXT FIELD fat071
              WHEN INFIELD(fat081)  #累折科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag03 MATCHES '[2]' "
                 LET g_qryparam.default1 = g_fat2[l_ac].fat081
                 LET g_qryparam.arg1 = g_bookno2 
                 CALL cl_create_qry() RETURNING g_fat2[l_ac].fat081
                 DISPLAY g_fat2[l_ac].fat081 TO fat081
                 NEXT FIELD fat081
              WHEN INFIELD(fat102)  #分攤部門
                IF g_fat2[l_ac].fat092='1' THEN
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_fat2[l_ac].fat102
                 CALL cl_create_qry() RETURNING g_fat2[l_ac].fat102
                  NEXT FIELD fa102
                 NEXT FIELD fat102
                ELSE
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ='q_fad'
                  LET g_qryparam.default1 =g_fat2[l_ac].fat102
                  CALL cl_create_qry() RETURNING
                       g_fat2[l_ac].fat071,g_fat2[l_ac].fat102
                  DISPLAY g_fat2[l_ac].fat102 TO fat102
                  DISPLAY g_fat2[l_ac].fat071 TO fat071
                  NEXT FIELD fat102
                END IF
              WHEN INFIELD(fat111)  #折舊科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag03 MATCHES '[2]' "
                 LET g_qryparam.default1 = g_fat2[l_ac].fat111
                 LET g_qryparam.arg1 = g_bookno2  
                 CALL cl_create_qry() RETURNING g_fat2[l_ac].fat111
                 DISPLAY g_fat2[l_ac].fat111 TO fat111  
                 NEXT FIELD fat111
              OTHERWISE
                 EXIT CASE
           END CASE

         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()    
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
      
         ON ACTION controlg 
            CALL cl_cmdask()
      
         ON ACTION about 
            CALL cl_about()
      
         ON ACTION help
            CALL cl_show_help()
      
         ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
      
         ON ACTION CONTROLR 
            CALL cl_show_req_fields() 
      
         ON ACTION exit
            EXIT INPUT
      
      END INPUT
      
   END IF
 
   CLOSE WINDOW t1029_w2

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF

END FUNCTION
#FUN-AB0088---add---end---
#No.FUN-9C0077 程式精簡 

