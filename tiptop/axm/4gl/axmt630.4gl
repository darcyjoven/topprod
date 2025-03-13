# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmt630.4gl
# Descriptions...: 包裝單維護作業
# Date & Author..: 95/02/15 By Danny
# Modify.........: 95/05/09 By Danny (顯示料件編號)
                   # 1.增加自動確認&立即列印功能
                   # 2.update出貨單出貨數量when oaz22='Y'
                   # 1.增加M.maintain_mark作業
# Modify.........: 99/04/21 By Carol:default毛重=(外包裝裝數*內包裝重量)
#                                                 +外包裝重量
# Modify.........: 99/05/10 By Carol:add oaz67:包裝單之出貨單來源控制
# Modify.........: No:7065 03/08/15 Carol axmt620 取消單據時會update
#                                         出貨通知單單頭的出貨單號為NULL
#                                         但如果畫面仍在axmt630單身時
#                                         update 會不成功,需判斷update的sqlca.sqlcode
#                                         -->在單身時不lock oga_file
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4A0018 04/10/05 By Yuna 帳款客戶,業務人員,通知單號,訂單單號要開窗
# Modify.........: No.FUN-4B0038 04/11/15 By pengu ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-550070 05/05/26 By Will 單據編號放大
# Modify.........: No.MOD-570240 05/07/27 By Nicola 確認時,先開窗詢問是否更新INVOICE上的起迄箱號
# Modify.........: No.MOD-5C0005 05/12/07 By Nicola 包裝方式自動帶每箱裝數
# Modify.........: No.FUN-610020 06/01/17 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.FUN-640172 06/04/13 By Sarah 增加Action"包裝單列印"
# Modify.........: NO.FUN-640251 06/04/25 BY yiting 針對 oaz67 的設定來改變 欄位說明
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.TQC-660011 06/06/07 By Pengu axms100 參數oaz67='2'時，直接按Packing List 列印時無法列印
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........: No.MOD-690014 06/09/05 By wujie 修改單身每箱數不能大于出貨單數錯誤
# Modify.........: No.FUN-680137 06/09/05 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-680134 06/10/13 By rainy 箱號(ogd12b,ogd12e 由 chr(3)改成 num(10)
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6A0020 06/11/17 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0117 06/11/21 By day 欄位加控管 
# Modify.........: No.FUN-6A0092 06/11/23 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.MOD-6C0026 06/12/06 By kim 客戶簽收='Y'時查不到出貨單資料
# Modify.........: No.FUN-710046 07/01/30 By bnlent 錯誤訊息匯整
# Modify.........: No.CHI-710033 07/02/05 By rainy 單身開窗t630_w1字軌不一定要輸入
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-730117 07/03/23 By claire 若遇單身無包裝資料時應仍可產生有資料的單身
# Modify.........: No.FUN-730018 07/03/26 By kim 行業別架構
# Modify.........: No.CHI-6A0031 07/03/29 By pengu Packing List列印改串axmr554
# Modify.........: NO.MOD-740419 07/05/08 BY yiting 1.單位淨重/總淨重/單位毛重/總毛重 計算公式有誤
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# MOdify.........: No.CHI-790001 07/09/02 By Nicole 修正Insert Into ogd_file Error
# MOdify.........: No.MOD-7A0002 07/10/04 By Claire (1) 自動產生單身時,未算出單位毛重及總毛重
#                                                   (2) 自動產生單身時,算出的總淨重是錯的
#                                                   (3) 重新定義單位淨重,總淨重,單位毛重,總毛重的算法 
#                                                   (4) 畫面上單位淨重及單位毛重再加上包裝二字的說明 
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/14 By kim 移除GP5.0行業別功能的所有程式段
# MOdify.........: No.TQC-7B0137 07/11/27 By wujie  包裝單審核，更新出貨單數量時，未控管到“出貨數量不可大于訂單未交量，或已大于允超交量。”
#                                                   出貨單已扣帳，則包裝單不可取消審核．
#                                                   出貨單已審核并扣帳，則包裝單審核時，不可以再更新出貨單的數量。
# Modify.........: No.TQC-7C0110 07/12/08 By Beryl  自動生成包裝單資料輸入字首后，在錄單身的時候應自動帶出字首欄位
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-810016 08/01/21 By ve007 包裝方式字段增加混合單號的邏輯
# Modify.........: No.FUN-7B0018 08/01/31 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-810114 08/02/21 By claire 包裝單若單身空白,用滑鼠雙擊單身程式會跳掉,但若點單身按鈕就不會
# Modify.........: No.FUN-820046 08/02/28 By wuad   行業別字段ogdislk01改為非行業字段ogd17
# Modify.........: No.MOD-830107 08/03/13 By claire (1)散箱的單位淨重(ogb14)計算錯誤,影響總淨重,總毛重
#                                                   (2)ogd14t應為總淨重,ogd15為包裝單位毛重,目前做法相反了
#                                                   (3)ogd15t的公式調整,應為 ogd15t = ogd15 * ogd10
# Modify.........: No.FUN-840042 08/04/11 by TSD.zeak 自訂欄位功能修改 
# Modify.........: No.CHI-840011 08/04/14 By claire 取消確認時,若有勾選參數"包裝單數量需回寫出貨單數量"及"出貨來源為出通單",不允許取消確認,需控卡不可取消確認,應先刪除出貨單
# Modify.........: No.CHI-840010 08/04/14 By Carol 包裝數量及金額回寫ogb,oga相關欄位
# Modify.........: No.MOD-840113 08/04/15 By claire 第二筆項次後,修改字軌後,資料重查仍未更新
# Modify.........: No.MOD-840378 08/04/21 By claire 修改箱號時,當箱數為0, 箱號為截止箱號
# Modify.........: No.MOD-840578 08/04/23 By sherry 1、修改箱數后截止包裝箱號沒有重新推算
#                                                   2、修改箱數后再經過數量的欄位后，會將包裝單位凈重、總凈重、包裝單位毛重、總毛重清空
# Modify.........: No.MOD-870068 08/07/08 By Smapmin 列印時要印出公司對內/外全名
# Modify.........: No.FUN-870124 08/08/20 By 服飾版功能完善
# Modify.........: No.FUN-890099 08/09/25 By Smapmin 按下列印時,增加品名規格額外說明類別的輸入
# Modify.........: No.FUN-870124 08/10/08 By hongmei 服飾版修改   
# Modify.........: No.FUN-8A0086 08/10/17 By lutingting 如果是沒有let g_success == 'Y' 就寫給g_success 賦初始值，
#                                                       不然如果一次失敗，以后都無法成功
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-940006 09/04/01 By Dido 截止箱號須重新顯示
# Modify.........: No.MOD-930239 09/04/02 By Smapmin 查詢時,單身包裝方式開窗就當掉
# Modify.........: No.MOD-940005 09/04/02 By Smapmin 輸入箱數後,重算ogd14t/ogd15t時出錯
# Modify.........: No.MOD-950059 09/05/07 By Dido 單身排序改為 項次+序號
# Modify.........: No.TQC-950079 09/05/13 By Dido 單頭無法查詢
# Modify.........: No.TQC-960182 09/06/24 By lilingyu 單身多個欄位未進行負數控管
# Modify.........: No.TQC-960308 09/06/24 By sherry 單身數量欄位未作大于控管
# Modify.........: No.FUN-980010 09/08/24 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-980017 09/09/10 By mike 若出貨單原項次 30 筆 (未確認)，於 axmt630 產生出貨包裝單后，出貨單又新增項次20筆，
# Modify.........: No:MOD-A10004 10/01/05 By Smapmin _b()一開頭就將array的空間開出來,導致無法run到after inser段
# Modify.........: No:FUN-9C0071 10/01/12 By huangrh 精簡程式
# Modify.........: No:TQC-A20056 10/02/24 By sherry 修正出貨單號的開窗
# Modify.........: No:FUN-A50103 10/06/03 By Nicola 訂單多帳期 1.取消訂單/尾款分期立帳欄位 2.增加訂單多帳期維護
# Modify.........: No:FUN-9B0121 11/05/04 By suncx 單身顯示品名和規格
# Modify.........: No.FUN-B80089 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No:TQC-B80196 11/08/26 By lixia 查詢欄位
# Modify.........: No:MOD-B90167 11/09/22 By Vampire 在AFTER FIELD ogd09 新增重新計算,單位淨重(ogd14) = 每箱裝數(ogd09) * 料件淨重 (ima18)
# Modify.........: No:TQC-BA0130 11/10/24 By destiny 单身删除时报错信息不对
# Modify.........: No:TQC-C10009 12/01/04 By lilingyu 在axmt632查詢時,開窗出來的都不是與多角相關的單號
# Modify.........: No:MOD-C10029 12/01/06 By Vampire 包在Transaction中的RETURN前增加ROLLBACK WORK
# Modify.........: No:MOD-BB0011 12/01/17 By Vampire 判斷單頭oga16(訂單單號)欄位，其欄位是NULL值，造成包裝單無法確認
# Modify.........: No:MOD-C30381 12/03/13 By zhuhao 第二筆資料未輸入時應該可以按確定              
# Modify.........: No:MOD-C40036 12/04/05 By Summer 單身新增時,序號不為1的每箱裝數錯誤,修改包裝方式後每箱裝數應重帶
# Modify.........: No:MOD-C40059 12/04/09 By ck2yuan 對ogd08、ogd17給值起來那段搬到BEFORE FIELD ogd04
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.MOD-C60208 12/06/27 By Vampire 原在BEFORE FIELD ogd04取得產品編號,請增加抓取品名規格顯示
# Modify.........: NO.MOD-C60148 12/06/12 By SunLM 审核时更新出货单ogb16（依库存明细单位）数量字段
# Modify.........: No:FUN-C30085 12/07/03 By nanbing CR改串GR
# Modify.........: No:FUN-C80033 12/08/09 By Lori 修改無法於axmt630產生包裝單問題
# Modify.........: No:FUN-CB0014 12/11/07 By xianghui 增加資料清單
# Modify.........: No:FUN-C90076 12/09/27 By xujing  增加ACTION"PACKING LIST列印(大陸)",串axmr559,此按鈕在aza2='2'時顯示,否則隱藏
# Modify.........: No:CHI-CC0034 13/01/17 By Summer 修正毛重淨重計算
# Modify.........: No.TQC-D10084 13/01/28 By xianghui 資料清單頁簽下隱藏一部分ACTION
# Modify.........: No.MOD-D20091 13/03/07 By jt_chen 由維護程式串axmg554用箱號排序
# Modify.........: No:FUN-D30034 13/04/16 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_oga           RECORD LIKE oga_file.*,
    g_oga_t         RECORD LIKE oga_file.*,
    g_ogd           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    ogd03     LIKE ogd_file.ogd03,
                    #ogb04     LIKE ogb_file.ogb04,#mark by guanyao160711
                    ogdud02 LIKE ogd_file.ogdud02, #add by guanyao160711
                    ogb06     LIKE ogb_file.ogb06,      #FUN-9B0121
                    ima021    LIKE ima_file.ima021,     #FUN-9B0121
                    ogd04     LIKE ogd_file.ogd04,                    
                    ogd17     LIKE ogd_file.ogd17,                    #No.FUN-820046               
                    ogd08     LIKE ogd_file.ogd08,
                    ogd09     LIKE ogd_file.ogd09,
                    ogd10     LIKE ogd_file.ogd10,
                    ogd11     LIKE ogd_file.ogd11,
                    ogd12b    LIKE ogd_file.ogd12b,
                    ogd12e    LIKE ogd_file.ogd12e,
                    ogd13     LIKE ogd_file.ogd13,
                    ogd14     LIKE ogd_file.ogd14,
                    ogd14t    LIKE ogd_file.ogd14t,
                    ogd15     LIKE ogd_file.ogd15,
                    ogd15t    LIKE ogd_file.ogd15t,
                    ogd16     LIKE ogd_file.ogd16,
                    ogd16t    LIKE ogd_file.ogd16t,
                    ogdud01 LIKE ogd_file.ogdud01,
                    ogdud03 LIKE ogd_file.ogdud03,
                    ogdud04 LIKE ogd_file.ogdud04,
                    ogdud05 LIKE ogd_file.ogdud05,
                    ogdud06 LIKE ogd_file.ogdud06,
                    ogdud07 LIKE ogd_file.ogdud07,
                    ogdud08 LIKE ogd_file.ogdud08,
                    ogdud09 LIKE ogd_file.ogdud09,
                    ogdud10 LIKE ogd_file.ogdud10,
                    ogdud11 LIKE ogd_file.ogdud11,
                    ogdud12 LIKE ogd_file.ogdud12,
                    ogdud13 LIKE ogd_file.ogdud13,
                    ogdud14 LIKE ogd_file.ogdud14,
                    ogdud15 LIKE ogd_file.ogdud15
                    END RECORD,
    g_ogd_t         RECORD
                    ogd03     LIKE ogd_file.ogd03,
                    #ogb04     LIKE ogb_file.ogb04,#mark by guanyao160711
                    ogdud02 LIKE ogd_file.ogdud02, #add by guanyao160711
                    ogb06     LIKE ogb_file.ogb06,      #FUN-9B0121
                    ima021    LIKE ima_file.ima021,     #FUN-9B0121
                    ogd04     LIKE ogd_file.ogd04,                    
                    ogd17     LIKE ogd_file.ogd17,                   #No.FUN-820046
                    ogd08     LIKE ogd_file.ogd08,
                    ogd09     LIKE ogd_file.ogd09,
                    ogd10     LIKE ogd_file.ogd10,
                    ogd11     LIKE ogd_file.ogd11,
                    ogd12b    LIKE ogd_file.ogd12b,
                    ogd12e    LIKE ogd_file.ogd12e,
                    ogd13     LIKE ogd_file.ogd13,
                    ogd14     LIKE ogd_file.ogd14,
                    ogd14t    LIKE ogd_file.ogd14t,
                    ogd15     LIKE ogd_file.ogd15,
                    ogd15t    LIKE ogd_file.ogd15t,
                    ogd16     LIKE ogd_file.ogd16,
                    ogd16t    LIKE ogd_file.ogd16t, 
                    ogdud01 LIKE ogd_file.ogdud01,
                    #ogdud02 LIKE ogd_file.ogdud02,
                    ogdud03 LIKE ogd_file.ogdud03,
                    ogdud04 LIKE ogd_file.ogdud04,
                    ogdud05 LIKE ogd_file.ogdud05,
                    ogdud06 LIKE ogd_file.ogdud06,
                    ogdud07 LIKE ogd_file.ogdud07,
                    ogdud08 LIKE ogd_file.ogdud08,
                    ogdud09 LIKE ogd_file.ogdud09,
                    ogdud10 LIKE ogd_file.ogdud10,
                    ogdud11 LIKE ogd_file.ogdud11,
                    ogdud12 LIKE ogd_file.ogdud12,
                    ogdud13 LIKE ogd_file.ogdud13,
                    ogdud14 LIKE ogd_file.ogdud14,
                    ogdud15 LIKE ogd_file.ogdud15
                    END RECORD,      
    g_argv2         LIKE oga_file.oga01,
    g_argv1         LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1),    #1. for 一般 2. for 三角貿易
    g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680137 SMALLINT
    g_buf           LIKE ima_file.ima01,        #No.FUN-680137 VARCHAR(40)
    l_ac            LIKE type_file.num5,        #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_cmd           LIKE type_file.chr1000,     #No.FUN-680137  VARCHAR(200)
    g_t1            LIKE oay_file.oayslip,      #No.FUN-550070        #No.FUN-680137  VARCHAR(5)
    g_oga09         LIKE type_file.chr1         # No.FUN-680137  VARCHAR(1)                #包裝單之出貨單號來源 2.出貨單
                                           #                     1.出貨通知單
DEFINE g_ogd11      LIKE ogd_file.ogd11                 #TQC-7C0110
#FUN-CB0014--add--str--
DEFINE g_oga_l     DYNAMIC ARRAY OF RECORD   
                    oga01_l     LIKE oga_file.oga01,
                    oaydesc_l   LIKE oay_file.oaydesc,
                    oga02_l     LIKE oga_file.oga02,
                    oga16_l     LIKE oga_file.oga16,                    
                    oga03_l     LIKE oga_file.oga03,
                    oga032_l    LIKE oga_file.oga032,
                    oga14_l     LIKE oga_file.oga14,
                    gen02_l     LIKE gen_file.gen02,
                    oga15_l     LIKE oga_file.oga15,
                    gem02_l     LIKE gem_file.gem02,
                    oga30_l     LIKE oga_file.oga30
                    END RECORD,
       l_ac1         LIKE type_file.num5,
       g_rec_b1      LIKE type_file.num5, 
       g_action_flag STRING            
DEFINE w        ui.Window
DEFINE f        ui.Form
DEFINE page     om.DomNode
#FUN-CB0014--add--end--
 
#主程式開始
DEFINE g_forupd_sql  STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
 
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   b_ogd RECORD LIKE ogd_file.*  #FUN-730018
#&ifndef STD                               #No.FUN-820046 mark
#&endif                                    #No.FUN-820046 mark

MAIN
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730018
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET g_argv2      = ARG_VAL(2)          #參數值(1) Part#
    IF g_argv1 = '1' THEN
       LET g_prog = 'axmt630'
    ELSE
       LET g_prog = 'axmt632'
    END IF
   
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AXM")) THEN
       EXIT PROGRAM
    END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time      #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
 
    LET p_row = 2 LET p_col = 8
 
    OPEN WINDOW t630_w AT p_row,p_col WITH FORM "axm/42f/axmt630"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    # 2004/06/02 共用程式時呼叫
    CALL cl_set_locale_frm_name("axmt630")
    CALL cl_ui_init()
 
    IF g_sma.sma128 !='Y' THEN
       CALL cl_set_comp_visible("ogd17",FALSE)
    END IF

    #str----add by guanyao160711
    CALL cl_set_comp_entry('ogd04,ogd09,ogd10,ogd13',FALSE)
    #end----add by guanyao160711

    #FUN-C90076---add---str---
    CALL cl_set_act_visible("print_packing_list",g_aza.aza02='1' OR g_aza.aza02='0')
    CALL cl_set_act_visible("packing_list_mainland",g_aza.aza02='2')
    #FUN-C90076---add---end--- 
    LET g_forupd_sql = "SELECT * FROM oga_file WHERE oga01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t630_cl CURSOR FROM g_forupd_sql
 
    CALL t630_show0()       #NO.FUN-640251
     IF NOT cl_null(g_argv2) THEN CALL t630_q() END IF
 
    WHILE TRUE
       LET g_action_choice = ''
       CALL t630_menu()
       IF g_action_choice = 'exit' THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW t630_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
#QBE 查詢資料
FUNCTION t630_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE  l_ogb31        LIKE  ogb_file.ogb31,      #No.FUN-810016 --begin--
        l_ogb32        LIKE  ogb_file.ogb32       #No.FUN-810016 --end--
DEFINE  l_ogd03        LIKE ogd_file.ogd03   #MOD-930239
DEFINE  l_ogd04        LIKE ogd_file.ogd04   #MOD-930239
DEFINE  l_ogd17        LIKE ogd_file.ogd17   #MOD-930239
 
    IF NOT cl_null(g_argv2) THEN
       LET g_wc = "oga01 = '",g_argv2,"'"
       LET g_wc2=" 1=1 "
    ELSE
       CLEAR FORM #清除畫面
       CALL g_ogd.clear()
       INITIALIZE g_oga.* TO NULL
       CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_oga.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON
            oga01,oga02,oga021,oga16,
            oga03,oga032,oga04,
            oga14,oga15,
            oga99,oga30,
            ogauser,ogagrup,ogamodu,ogadate, 
            ogaoriu,ogaorig,  #TQC-B80196
            ogaud01,ogaud02,ogaud03,ogaud04,ogaud05,
            ogaud06,ogaud07,ogaud08,ogaud09,ogaud10,
            ogaud11,ogaud12,ogaud13,ogaud14,ogaud15
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
          ON ACTION CONTROLP
             CASE WHEN INFIELD(oga03) #帳款客戶
                       CALL cl_init_qry_var()
                       LET g_qryparam.state= "c"
                       LET g_qryparam.form = "q_occ"
          	       CALL cl_create_qry() RETURNING g_qryparam.multiret
          	       DISPLAY g_qryparam.multiret TO oga03
          	       NEXT FIELD oga03
                   WHEN INFIELD(oga14) #業務人員
                       CALL cl_init_qry_var()
                       LET g_qryparam.state= "c"
                       LET g_qryparam.form = "q_gen"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO oga14
                       NEXT FIELD oga14
                   WHEN INFIELD(oga01) #通知單號
                       CALL cl_init_qry_var()
                       LET g_qryparam.state= "c"
                       #LET g_qryparam.form = "q_oga5"
#TQC-C10009 --begin--
                       IF g_prog = 'axmt632' THEN
                          LET g_qryparam.form = "q_oga52"
                       ELSE
#TQC-C10009 --end--
                          LET g_qryparam.form = "q_oga51"       #TQC-A20056
                       END IF                     #TQC-C10009
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO oga01
                       NEXT FIELD oga01
                    WHEN INFIELD(oga16) #訂單單號
                       CALL cl_init_qry_var()
                       LET g_qryparam.state= "c"
                       LET g_qryparam.form = "q_oea6"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO oga16
                       NEXT FIELD oga16
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup') #FUN-980030
       IF INT_FLAG THEN RETURN END IF
 
       CONSTRUCT g_wc2 ON ogd03,ogd04,ogd08,
                          ogd17,                                  #No.FUN-820046
                          ogd09,ogd10,ogd11,ogd12b,ogd12e,
                          ogd13,ogd14,ogd14t,ogd15,ogd15t,ogd16,ogd16t, 
                          ogdud01,ogdud02,ogdud03,ogdud04,ogdud05,
                          ogdud06,ogdud07,ogdud08,ogdud09,ogdud10,
                          ogdud11,ogdud12,ogdud13,ogdud14,ogdud15
                     FROM s_ogd[1].ogd03, s_ogd[1].ogd04,s_ogd[1].ogd08,
                          s_ogd[1].ogd17,                         #No.FUN-820046
                          s_ogd[1].ogd09, s_ogd[1].ogd10, s_ogd[1].ogd11,
                          s_ogd[1].ogd12b,s_ogd[1].ogd12e,s_ogd[1].ogd13,
                          s_ogd[1].ogd14, s_ogd[1].ogd14t,s_ogd[1].ogd15,
                          s_ogd[1].ogd15t,s_ogd[1].ogd16, s_ogd[1].ogd16t,
                          s_ogd[1].ogdud01,s_ogd[1].ogdud02,s_ogd[1].ogdud03,s_ogd[1].ogdud04,s_ogd[1].ogdud05,
                          s_ogd[1].ogdud06,s_ogd[1].ogdud07,s_ogd[1].ogdud08,s_ogd[1].ogdud09,s_ogd[1].ogdud10,
                          s_ogd[1].ogdud11,s_ogd[1].ogdud12,s_ogd[1].ogdud13,s_ogd[1].ogdud14,s_ogd[1].ogdud15
	  BEFORE CONSTRUCT
	     CALL cl_qbe_display_condition(lc_qbe_sn)
 
          AFTER FIELD ogd03
            CALL FGL_DIALOG_GETBUFFER() RETURNING l_ogd03
          
          AFTER FIELD ogd04
            CALL FGL_DIALOG_GETBUFFER() RETURNING l_ogd04
          
          AFTER FIELD ogd17
            CALL FGL_DIALOG_GETBUFFER() RETURNING l_ogd17
 
          ON ACTION controlp
             CASE
                WHEN INFIELD(ogd08)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
 
                   IF l_ogd17='2' THEN                #No.FUN-820046   #MOD-930239
                    SELECT ogb31,ogb32 INTO l_ogb31,l_ogb32
                      FROM ogb_file WHERE ogb_file.ogb01=g_oga.oga01 
                      AND ogb_file.ogb03=l_ogd03   #MOD-930239
                   IF l_ogb31 IS NULL THEN
                      LET g_qryparam.arg1=l_ogd04    #MOD-930239
                      LET g_qryparam.form ="q_ogd08a"   #MOD-930239  q_ogb08a-->q_ogd08a
                   ELSE 
                   	  LET g_qryparam.arg1=l_ogb31
                   	  LET g_qryparam.arg2=l_ogb32
                   	  LET g_qryparam.form="q_ogd08b"    #MOD-930239  q_ogb08b-->q_ogd08b
                   END IF 
                   ELSE  	       
                   LET g_qryparam.form ="q_obe"
                   END IF 
                   
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ogd08
                   NEXT FIELD ogd08
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
 
	  #No.FUN-580031 --start--     HCN
              ON ACTION qbe_save
	         CALL cl_qbe_save()
	  #No.FUN-580031 --end--       HCN
       END CONSTRUCT
 
       IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    END IF
    IF g_argv1='1' THEN
       IF g_oaz.oaz67 = '1'  THEN
          LET g_wc = g_wc CLIPPED, " AND oga09 ='1'"
       ELSE
         #LET g_wc = g_wc CLIPPED ," AND oga09 IN ('2','8') "  #No.FUN-610020     #FUN-C80033 mark
          LET g_wc = g_wc CLIPPED ," AND oga09 IN ('2','8','3') "                 #FUN-C80033 add
       END IF
    END IF
    IF g_argv1='2' THEN   #for 三角貿易
       IF g_oaz.oaz67 = '1'  THEN
          LET g_wc = g_wc CLIPPED, " AND oga09 ='5'"
       ELSE
          LET g_wc = g_wc CLIPPED ," AND (oga09 = '4' OR oga09 ='6')  "
       END IF
    END IF
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT oga01 FROM oga_file",
                   " WHERE ", g_wc CLIPPED,
                   "   AND ogaconf != 'X' ", #01/08/20 mandy
                   " ORDER BY 1"
    ELSE  #若單身有輸入條件 modify 1999/05/10 --單據別由oaz67(g_oga09)控制
       LET g_sql = "SELECT UNIQUE oga01 ",
                   "  FROM oga_file, ogd_file",
                   " WHERE oga01 = ogd01 ",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   "   AND ogaconf != 'X' ", #01/08/20 mandy
                   " ORDER BY 1"
    END IF
 
    PREPARE t630_prepare FROM g_sql
    DECLARE t630_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t630_prepare
    DECLARE t630_fill_cs CURSOR  FOR t630_prepare   #FUN-CB0014
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM oga_file ",
                  " WHERE ",g_wc CLIPPED,
                  "   AND ogaconf != 'X' " #01/08/20 mandy
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT oga01) FROM oga_file,ogd_file",
                  " WHERE ogd01=oga01 ",
                  "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                  "   AND ogaconf != 'X' " #01/08/20 mandy
    END IF
    PREPARE t630_precount FROM g_sql
    DECLARE t630_count CURSOR FOR t630_precount
END FUNCTION
 
FUNCTION t630_menu()
   DEFINE   l_no   LIKE   ofa_file.ofa01
   DEFINE   l_wc   LIKE type_file.chr1000     #No.TQC-610089 ADD        #No.FUN-680137 VARCHAR(200)
   DEFINE   l_imc02 LIKE imc_file.imc02        #FUN-890099
 
   WHILE TRUE
      #CALL t630_bp("G")  #FUN-CB0014
      #FUN-CB0014---add-str--- 
      CASE
         WHEN (g_action_flag IS NULL) OR (g_action_flag = "main")
            CALL t630_bp("G")
         WHEN (g_action_flag = "info_list")
            CALL t630_list_fill()
            CALL t630_bp1("G")
            IF NOT cl_null(g_action_choice) AND l_ac1>0 THEN #將清單的資料回傳到主畫面
               SELECT oga_file.*
                 INTO g_oga.*
                 FROM oga_file
                WHERE oga01=g_oga_l[l_ac1].oga01_l
            END IF
            IF g_action_choice!= "" THEN
               LET g_action_flag = 'main'
               LET l_ac1 = ARR_CURR()
               LET g_jump = l_ac1
               LET mi_no_ask = TRUE
               IF g_rec_b1 >0 THEN
                   CALL t630_fetch('/')
               END IF
               CALL cl_set_comp_visible("page_in", FALSE)
               CALL cl_set_comp_visible("info", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page_in", TRUE)
               CALL cl_set_comp_visible("info", TRUE)
             END IF               
      END CASE
      #FUN-CB0014---add---str--      
      CASE g_action_choice
           WHEN "query"
              IF cl_chk_act_auth() THEN
                 CALL t630_q()
              END IF
           WHEN "detail"
              IF cl_chk_act_auth() THEN
                 CALL t630_b()
              ELSE
                 LET g_action_choice = NULL
              END IF
           WHEN "help"
              CALL cl_show_help()
           WHEN "exit"
              EXIT WHILE
           WHEN "controlg"
              CALL cl_cmdask()
           WHEN "confirm"
              IF cl_chk_act_auth() THEN
                 CALL t630_y()
              END IF
           WHEN "undo_confirm"
              IF cl_chk_act_auth() THEN
                 CALL t630_z()
              END IF
           WHEN "print_packing_list"
              IF cl_chk_act_auth() THEN
                 LET l_no=''
                    SELECT ofa01 INTO l_no FROM ofa_file
                    WHERE ofa011=g_oga.oga01
                 WHILE TRUE
                   CALL cl_getmsg('axm-505',g_lang) RETURNING g_msg
                   LET INT_FLAG = 0  
                   PROMPT g_msg CLIPPED FOR l_imc02
 
                      ON IDLE g_idle_seconds
                         CALL cl_on_idle()
                      ON ACTION about         
                         CALL cl_about()      
                      ON ACTION help          
                         CALL cl_show_help()  
                      ON ACTION controlg      
                         CALL cl_cmdask()     
 
                   END PROMPT
                   EXIT WHILE
                 END WHILE
                 LET l_wc='oga01="',g_oga.oga01,'"'
                 #LET g_msg = "axmr554", #FUN-C30085 mark 
                 LET g_msg = "axmg554", #FUN-C30085 add
                              " '",g_today CLIPPED,"' ''",
                              " '",g_lang CLIPPED,"' 'Y' '' '1'",
                              " '",l_wc CLIPPED,"' ",
                              " '",l_imc02 CLIPPED,"' '2' 'Y' 'Y' "   #MOD-870068   #FUN-890099   #MOD-D20091 modify '1' -> '2' 箱號
                 CALL cl_cmdrun(g_msg)
              END IF
           #FUN-C90076---add---str---
           WHEN "packing_list_mainland"
              IF cl_chk_act_auth() THEN
                 LET g_msg = "axmr559 '' '' '' '' '' '' ",
                             "'",g_oga.oga01 CLIPPED,"'",
                             " '' '' '' '' "
                 CALL cl_cmdrun(g_msg)
              END IF
           #FUN-C90076---add---end---

           WHEN "exporttoexcel"     #FUN-4B0038
             #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ogd),'','')   #FUN-CB0014
              #FUN-CB0014---add---str---
              LET w = ui.Window.getCurrent()
              LET f = w.getForm()
              IF cl_null(g_action_flag) OR g_action_flag = "main" THEN
                 LET page = f.FindNode("Page","page_m")
                 CALL cl_export_to_excel(page,base.TypeInfo.create(g_ogd),'','')
              END IF
              IF g_action_flag = "info_list" THEN
                 LET page = f.FindNode("Page","page_in")
                    CALL cl_export_to_excel(page,base.TypeInfo.create(g_oga_l),'','')
              END IF
              #FUN-CB0014---add---end---
 
           WHEN "related_document"  #相關文件
                IF cl_chk_act_auth() THEN
                   IF g_oga.oga01 IS NOT NULL THEN
                   LET g_doc.column1 = "oga01"
                   LET g_doc.value1 = g_oga.oga01
                   CALL cl_doc()
                 END IF
           END IF
      END CASE
   END WHILE
END FUNCTION
 
 
#Query 查詢
FUNCTION t630_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_oga.* TO NULL               #No.FUN-6A0020
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t630_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_oga.* TO NULL
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t630_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_oga.* TO NULL
    ELSE
       OPEN t630_count
       FETCH t630_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL t630_fetch('F')                  # 讀出TEMP第一筆並顯示
       CALL t630_list_fill()        #FUN-CB0014
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION t630_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
  CASE p_flag
     WHEN 'N' FETCH NEXT     t630_cs INTO g_oga.oga01
     WHEN 'P' FETCH PREVIOUS t630_cs INTO g_oga.oga01
     WHEN 'F' FETCH FIRST    t630_cs INTO g_oga.oga01
     WHEN 'L' FETCH LAST     t630_cs INTO g_oga.oga01
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
          LET mi_no_ask = FALSE
          FETCH ABSOLUTE g_jump t630_cs INTO g_oga.oga01
  END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oga.oga01,SQLCA.sqlcode,0)
        INITIALIZE g_oga.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_oga.* FROM oga_file WHERE oga01 = g_oga.oga01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","oga_file",g_oga.oga01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
        INITIALIZE g_oga.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_oga.ogauser      #FUN-4C0057 add
    LET g_data_group = g_oga.ogagrup      #FUN-4C0057 add
    LET g_data_plant = g_oga.ogaplant #FUN-980030
    CALL t630_show0()      #NO.FUN-640251
    CALL t630_show()
END FUNCTION
 
FUNCTION t630_show0()
   DEFINE   ls_msg   LIKE type_file.chr1000     # No.FUN-680137 VARCHAR(50)
 
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
#將資料顯示在畫面上
FUNCTION t630_show()
  DEFINE l_slip   LIKE aba_file.aba00      # No.FUN-680137 VARCHAR(05)
    LET g_oga_t.*=g_oga.*
    LET l_slip=s_get_doc_no(g_oga.oga01)  #No.FUN-550070
    SELECT oaydesc INTO g_buf FROM oay_file WHERE oayslip=l_slip
    IF STATUS THEN LET g_buf='' END IF
    DISPLAY g_buf TO oaydesc
    SELECT occ02 INTO g_buf FROM occ_file WHERE occ01=g_oga.oga04
    IF STATUS THEN LET g_buf='' END IF
    DISPLAY g_buf TO occ02
    SELECT gen02 INTO g_buf FROM gen_file WHERE gen01=g_oga.oga14
    IF STATUS THEN LET g_buf='' END IF
    DISPLAY g_buf TO gen02
    SELECT gem02 INTO g_buf FROM gem_file WHERE gem01=g_oga.oga15
    IF STATUS THEN LET g_buf='' END IF
    DISPLAY g_buf TO gem02
    DISPLAY BY NAME g_oga.oga01,g_oga.oga02,g_oga.oga021,g_oga.oga99,
                    g_oga.oga03,
                    g_oga.oga032,g_oga.oga04,g_oga.oga14,g_oga.oga15,
                    g_oga.oga16,g_oga.oga30,g_oga.ogauser,
                    g_oga.ogagrup,g_oga.ogamodu,g_oga.ogadate,
                    g_oga.ogaoriu,g_oga.ogaorig,  #TQC-B80196
                    g_oga.ogaud01,g_oga.ogaud02,g_oga.ogaud03,g_oga.ogaud04,
                    g_oga.ogaud05,g_oga.ogaud06,g_oga.ogaud07,g_oga.ogaud08,
                    g_oga.ogaud09,g_oga.ogaud10,g_oga.ogaud11,g_oga.ogaud12,
                    g_oga.ogaud13,g_oga.ogaud14,g_oga.ogaud15 
 
    #CKP
    CALL cl_set_field_pic(g_oga.oga30,"","","","","")
    CALL t630_list_fill()   #FUN-CB0014
 
    CALL t630_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t630_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON ogd02,occ02,ogd03,ogd04,ogd05,ogd07,ogd08,ogd09
                  FROM s_ogd[1].ogd02,s_ogd[1].occ02,s_ogd[1].ogd03,
                       s_ogd[1].ogd04,s_ogd[1].ogd05,s_ogd[1].ogd07,
                       s_ogd[1].ogd08,s_ogd[1].ogd09
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
    CALL t630_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t630_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680137 VARCHAR(1)
    l_mod           LIKE type_file.num10,       # No.FUN-680137 INTEGER,
    l_ogd09         LIKE ogd_file.ogd09,
    l_ogd08         LIKE ogd_file.ogd08,
    l_ogd14         LIKE ogd_file.ogd14,
    l_ogd15         LIKE ogd_file.ogd15,
    l_ogb12         LIKE ogb_file.ogb12,
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680137 SMALLINT
DEFINE l_obe12      LIKE obe_file.obe12,                #NO.MOD-740419
       l_obe13      LIKE obe_file.obe13,                #MOD-740419
       l_obe22      LIKE obe_file.obe22,                #MOD-740419
       l_obe23      LIKE obe_file.obe23,                #MOD-740419
       l_cnt1       LIKE type_file.num20_6,             #NO.MOD-740419
       l_cnt2       LIKE type_file.num10,               #MOD-740419
       l_cnt3       LIKE type_file.num20_6,             #MOD-740419
       l_cnt4       LIKE type_file.num10,               #MOD-740419
       l_cnt1_1     LIKE type_file.num20_6,             #MOD-740419
       l_cnt2_1     LIKE type_file.num20_6              #MOD-740419
       
DEFINE l_ogb31      LIKE ogb_file.ogb31,                #FUN-810016
       l_ogb32      LIKE ogb_file.ogb32                 #FUN-810016
DEFINE p_row,p_col  LIKE type_file.num5                 #FUN-870124
DEFINE l_chr        LIKE type_file.chr1                 #FUN-870124        
DEFINE l_ogd13      LIKE ogd_file.ogd13                 #TQC-960308 add
 
DEFINE l_sma128     LIKE sma_file.sma128                #No.FUN-820046
#CHI-CC0034 add --start--
DEFINE l_ima18      LIKE ima_file.ima18
DEFINE l_ima31      LIKE ima_file.ima31
DEFINE l_flag       LIKE type_file.num5
DEFINE l_factor     LIKE ima_file.ima31_fac
DEFINE l_ogb05      LIKE ogb_file.ogb05
DEFINE l_x          LIKE type_file.num5   #add by guanyao160711
#CHI-CC0034 add --end--
 
    LET g_action_choice = ""
    SELECT * INTO g_oga.* FROM oga_file WHERE oga01 = g_oga.oga01
    IF g_oga.oga30 = 'Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    IF s_shut(0) THEN RETURN END IF
 
    SELECT sma128 INTO l_sma128 FROM sma_file         
    IF l_sma128!='Y' THEN
       CALL cl_set_comp_visible("ogd17",FALSE)
    END IF
 
    CALL cl_opmsg('b')
 
   # 修改目的:新輸入的項次無法自動產生至包裝單身.因此於進入單身再判斷是否有新項次，若有需自動產生至包裝單身                         
   # 找是否出貨單有新增項次                                                                                                         
       SELECT count(*) INTO l_n FROM ogb_file                                                                                       
        WHERE ogb_file.ogb01 = g_oga.oga01                                                                                          
          AND ogb03 NOT IN ( SELECT ogd03 FROM ogd_file WHERE ogd_file.ogd01 = g_oga.oga01 )                                        
   # 若有新增的出貨項次                                                                                                             
    IF l_n > 0 THEN                                                                                                                 
       IF cl_confirm('axm-229') THEN
          CALL t630_g_b()
          CALL t630_b_fill(" 1=1")                 #單身
       END IF
    END IF
 
    LET g_forupd_sql =
        "SELECT * FROM ogd_file",
        " WHERE ogd01= ?  AND ogd03= ? AND ogd04= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t630_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ogd WITHOUT DEFAULTS FROM s_ogd.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
    
            BEGIN WORK 
            
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_ogd_t.* = g_ogd[l_ac].*  #BACKUP
               OPEN t630_bcl USING g_oga.oga01, g_ogd_t.ogd03, g_ogd_t.ogd04
               IF STATUS THEN
                  CALL cl_err("OPEN t630_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                    FETCH t630_bcl INTO b_ogd.*     #FUN-730018
                    IF SQLCA.sqlcode THEN
                       CALL cl_err(g_ogd_t.ogd03,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                    ELSE
                       CALL t630_b_move_to() #FUN-730018
                       #str-------mark by guanyao160711
                       #SELECT ogb04 INTO g_ogd[l_ac].ogb04 FROM ogb_file
                       #  WHERE ogb01=g_oga.oga01
                       #    AND ogb03=g_ogd[l_ac].ogd03
                       #end-------mark by guanyao160711
                       SELECT ima02,ima021 INTO g_ogd[l_ac].ogb06,g_ogd[l_ac].ima021 FROM ima_file WHERE ima01 =g_ogd[l_ac].ogdud02  
                    END IF
                  END IF
                 #-->取得產品編號，數量                                                                                              
                 #SELECT ogb04,ogb12 INTO g_ogd[l_ac].ogb04,l_ogb12 FROM ogb_file                                                    
                 # WHERE ogb01=g_oga.oga01 AND ogb03=g_ogd[l_ac].ogd03                                                               
                 IF NOT cl_null(g_ogd[l_ac].ogd17) THEN
                    IF g_ogd[l_ac].ogd17 = '3' THEN
                       CALL cl_chg_comp_att("ogd08","NOT NULL|REQUIRED|SCROLL","0|0|0")
                    ELSE
                     	 CALL cl_chg_comp_att("ogd08","NOT NULL|REQUIRED|SCROLL","1|1|1")
                    END IF
                 END IF 
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ogd[l_ac].* TO NULL      #900423
            LET g_ogd_t.* = g_ogd[l_ac].*         #新輸入資料
            SELECT sma128 INTO l_sma128 FROM sma_file         
            IF l_sma128!='Y' THEN
               LET g_ogd[l_ac].ogd17='1'  
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ogd03
 
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            CALL t630_b_move_back() #FUN-730018
            INSERT INTO ogd_file VALUES (b_ogd.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","ogd_file",g_oga.oga01,g_ogd[l_ac].ogd03,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               CANCEL INSERT  
               ELSE      #No.FUN-870124 hm add
                  MESSAGE 'INSERT O.K'
                  LET g_rec_b=g_rec_b+1
                  COMMIT WORK
                  DISPLAY g_rec_b TO FORMONLY.cn2
             END IF                #No.FUN-7B0018
 
        BEFORE FIELD ogd03                            #default 項次
            IF g_ogd[l_ac].ogd03 IS NULL OR g_ogd[l_ac].ogd03 = 0 THEN
                SELECT max(ogd03)+1 INTO g_ogd[l_ac].ogd03 FROM ogd_file
                 WHERE ogd01 = g_oga.oga01
                IF g_ogd[l_ac].ogd03 IS NULL THEN
                   LET g_ogd[l_ac].ogd03 = 1
                END IF
            END IF
 
       AFTER FIELD ogd03
         IF NOT cl_null(g_ogd[l_ac].ogd03) THEN                                 #No.FUN-870124
            IF g_ogd[l_ac].ogd03 <= 0 THEN 
               NEXT FIELD ogd03 
            END IF 
           #MOD-C40059 str mark-------
           #IF cl_null(g_ogd_t.ogd03) OR g_ogd[l_ac].ogd03!=g_ogd_t.ogd03 THEN  #No.FUN-870124
           #   SELECT ogb931 INTO l_ogd08 FROM ogb_file
           #    WHERE ogb01=g_oga.oga01 AND ogb03=g_ogd[l_ac].ogd03
           #   IF l_sma128='Y' AND l_ogd08 IS NOT NULL THEN
           #      LET g_ogd[l_ac].ogd08=l_ogd08
           #      LET g_ogd[l_ac].ogd17='2'   
           #   ELSE
           #      SELECT obl03 INTO g_ogd[l_ac].ogd08 FROM obl_file
           #       WHERE obl01 = (SELECT ogb04 FROM ogb_file WHERE ogb01=g_oga.oga01 AND ogb03=g_ogd[l_ac].ogd03) 
           #         AND   obl02 = g_oga.oga04
           #     #-->包裝方式,單位淨重
           #     SELECT ima134 INTO l_ogd08
           #       FROM ima_file    
           #      WHERE ima01= (SELECT ogb04 FROM ogb_file WHERE ogb01=g_oga.oga01 AND ogb03=g_ogd[l_ac].ogd03)   
           #    IF l_ac > 1 AND cl_null(g_ogd[l_ac].ogd08)  THEN  
           #       LET g_ogd[l_ac].ogd08 = l_ogd08
           #    END IF
           #    IF l_ac > 1 AND cl_null(g_ogd[l_ac].ogd08) THEN
           #       LET g_ogd[l_ac].ogd08=g_ogd[l_ac-1].ogd08
           #    END IF
           #    LET g_ogd[l_ac].ogd17='1'
           #  END IF             
           ## DISPLAY BY NAME g_ogd[l_ac].ogd08     #MOD-C30381 mark  
           ## DISPLAY BY NAME g_ogd[l_ac].ogd17     #MOD-C30381 mark
           #END IF                        #No.FUN-870124
           #MOD-C40059 end mark-------
         END IF                          #No.FUN-870124
 
        BEFORE FIELD ogd04                            #default 序號
          #MOD-C40059 str add -------
           IF cl_null(g_ogd_t.ogd03) OR g_ogd[l_ac].ogd03!=g_ogd_t.ogd03 THEN
              SELECT ogb931 INTO l_ogd08 FROM ogb_file
               WHERE ogb01=g_oga.oga01 AND ogb03=g_ogd[l_ac].ogd03
              IF l_sma128='Y' AND l_ogd08 IS NOT NULL THEN
                 LET g_ogd[l_ac].ogd08=l_ogd08
                 LET g_ogd[l_ac].ogd17='2'
              ELSE
                 SELECT obl03 INTO g_ogd[l_ac].ogd08 FROM obl_file
                  WHERE obl01 = (SELECT ogb04 FROM ogb_file WHERE ogb01=g_oga.oga01 AND ogb03=g_ogd[l_ac].ogd03)
                    AND   obl02 = g_oga.oga04
                #-->包裝方式,單位淨重
                SELECT ima134 INTO l_ogd08
                  FROM ima_file
                 WHERE ima01= (SELECT ogb04 FROM ogb_file WHERE ogb01=g_oga.oga01 AND ogb03=g_ogd[l_ac].ogd03)
               IF l_ac > 1 AND cl_null(g_ogd[l_ac].ogd08)  THEN
                  LET g_ogd[l_ac].ogd08 = l_ogd08
               END IF
               IF l_ac > 1 AND cl_null(g_ogd[l_ac].ogd08) THEN
                  LET g_ogd[l_ac].ogd08=g_ogd[l_ac-1].ogd08
               END IF
               LET g_ogd[l_ac].ogd17='1'
             END IF
           END IF
          #MOD-C40059 end add -------
           #-->取得產品編號,數量
           #SELECT ogb04,ogb12 INTO g_ogd[l_ac].ogb04,l_ogb12 FROM ogb_file #MOD-C60208 mark
          #SELECT ogb04,ogb12,ogb06 INTO g_ogd[l_ac].ogb04,l_ogb12,g_ogd[l_ac].ogb06 FROM ogb_file  #MOD-C60208 add #CHI-CC0034 mark
          #CHI-CC0034 add --start--
         #  SELECT ogb04,ogb05,ogb06,ogb12 
         #    INTO g_ogd[l_ac].ogb04,l_ogb05,g_ogd[l_ac].ogb06,l_ogb12 
          SELECT ogb05,ogb06,ogb12 
             INTO l_ogb05,g_ogd[l_ac].ogb06,l_ogb12 
             FROM ogb_file 
          #CHI-CC0034 add --end--
            WHERE ogb01=g_oga.oga01 AND ogb03=g_ogd[l_ac].ogd03
            #IF STATUS THEN LET g_ogd[l_ac].ogb04=''  LET l_ogb12=0 END IF  #mark by guanyao160711
 
           #SELECT ima18 INTO l_ogd14 FROM ima_file #MOD-C60208 mark
          #SELECT ima18,ima021 INTO l_ogd14,g_ogd[l_ac].ima021 FROM ima_file #MOD-C60208 add #CHI-CC0034 mark
          #CHI-CC0034 add --start--
           SELECT ima18,ima021,ima31 
             INTO l_ima18,g_ogd[l_ac].ima021,l_ima31 
             FROM ima_file 
             WHERE ima01 = g_ogd[l_ac].ogdud02   #add by guanyao160711
          #CHI-CC0034 add --end--
            #WHERE ima01=g_ogd[l_ac].ogb04#mark by guanyao160711
          #IF STATUS THEN LET l_ogd14=0 END IF  #-->單位淨重 #CHI-CC0034 mark
           IF STATUS THEN LET l_ima18=0 END IF  #單位淨重    #CHI-CC0034
          #CHI-CC0034 add --start--
         # CALL s_umfchk(g_ogd[l_ac].ogb04,l_ogb05,l_ima31)#mark by guanyao160711
         CALL s_umfchk(g_ogd[l_ac].ogdud02,l_ogb05,l_ima31)#add by guanyao160711
               RETURNING l_flag,l_factor
          IF l_flag = '1' THEN LET l_factor = 1 END IF
          LET l_ogd14 = l_ima18 * l_factor
          #CHI-CC0034 add --end--
 
           IF g_ogd[l_ac].ogd04 IS NULL OR g_ogd[l_ac].ogd04 = 0 THEN
              SELECT max(ogd04)+1 INTO g_ogd[l_ac].ogd04 FROM ogd_file
               WHERE ogd01 = g_oga.oga01
                 AND ogd03 = g_ogd[l_ac].ogd03
              IF g_ogd[l_ac].ogd04 IS NULL THEN
                 LET g_ogd[l_ac].ogd04 = 1
              END IF
           END IF
 
        AFTER FIELD ogd04                              #check 編號是否重複
           IF NOT cl_null(g_ogd[l_ac].ogd04) THEN
             IF g_ogd[l_ac].ogd04 <= 0 THEN 
                NEXT FIELD ogd04
             END IF 
              IF cl_null(g_ogd_t.ogd04) OR g_ogd[l_ac].ogd04!=g_ogd_t.ogd04 THEN
                 SELECT COUNT(*) INTO l_n FROM ogd_file
                  WHERE ogd01 = g_oga.oga01
                    AND ogd03 = g_ogd[l_ac].ogd03
                    AND ogd04 = g_ogd[l_ac].ogd04
                     IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET g_ogd[l_ac].ogd04 = g_ogd_t.ogd04
                        DISPLAY BY NAME g_ogd[l_ac].ogd04
                        NEXT FIELD ogd04
                     END IF
              END IF
           END IF
        
        AFTER FIELD ogd17                                #No.FUN-820046
          IF NOT cl_null(g_ogd[l_ac].ogd17) THEN         #No.FUN-820046
             IF (g_ogd[l_ac].ogd17!=g_ogd_t.ogd17) THEN  #No.FUN-820046
                LET g_ogd[l_ac].ogd08 = ''
                NEXT FIELD ogd08
             END IF 
          ELSE       
              NEXT FIELD ogd17
          END IF
              
        BEFORE FIELD ogd08
 
        AFTER FIELD ogd08
            IF NOT cl_null(g_ogd[l_ac].ogd08) THEN
            
             IF g_ogd[l_ac].ogd17='2' THEN          #No.FUN-820046
                SELECT ogb31,ogb32 INTO l_ogb31,l_ogb32
                  FROM ogb_file WHERE ogb_file.ogb01=g_oga.oga01 
                   AND ogb_file.ogb03=g_ogd[l_ac].ogd03
                IF l_ogb31 IS NULL THEN
                   SELECT COUNT(*)INTO l_n FROM obj_file,obi_file 
                     WHERE obj_file.obj01=obi_file.obi01 
                     #AND obj_file.obj05=g_ogd[l_ac].ogb04#mark by guanyao1600711
                     AND obj_file.obj05=g_ogd[l_ac].ogdud02 #add by guanyao160711
                     AND obi_file.obi01=g_ogd[l_ac].ogd08
                   IF l_n=0 THEN
                      CALL cl_err('','ask-008',0)
                      NEXT FIELD ogd08
                   END IF     
                ELSE
                     SELECT COUNT(*) INTO l_n FROM obj_file,oeb_file
                      WHERE obj02 = oeb04
                        AND obj01 = g_ogd[l_ac].ogd08
                        AND oeb01 = l_ogb31
                        AND oeb03 = g_ogd[l_ac].ogd03  #No.FUN-870124 hm add
                      IF l_n=0 THEN
                         CALL cl_err('','ask-008',0)
                         NEXT FIELD ogd08 
                      END IF   
                END IF 
             ELSE 
                	 	         
             SELECT * FROM obe_file WHERE obe01=g_ogd[l_ac].ogd08
             IF SQLCA.sqlcode THEN CALL cl_err(g_ogd[l_ac].ogd08,SQLCA.sqlcode,0) NEXT FIELD ogd08 END IF
             
             END IF           #No.FUN-810016
              
               SELECT obe24,obe26 INTO l_ogd09,g_ogd[l_ac].ogd16 FROM obe_file
                WHERE obe01=g_ogd[l_ac].ogd08
              #IF g_ogd[l_ac].ogd04 = 1 THEN #MOD-C40036 mark
              #   IF cl_null(g_ogd[l_ac].ogd09) THEN   #No.MOD-5C0005                 #MOD-C40036 mark
                  IF cl_null(g_ogd_t.ogd09) OR g_ogd[l_ac].ogd08!=g_ogd_t.ogd08 THEN  #MOD-C40036
                     LET g_ogd[l_ac].ogd09 = l_ogd09
                  END IF
              #MOD-C40036 mark --start--
              #ELSE
              #   IF p_cmd='a' THEN
              #      LET g_ogd[l_ac].ogd09 = l_ogb12 mod l_ogd09
              #      LET g_ogd[l_ac].ogd10 = 1
              #   END IF
              #END IF
              #MOD-C40036 mark --end--
	       DISPLAY BY NAME g_ogd[l_ac].ogd16
	       DISPLAY BY NAME g_ogd[l_ac].ogd09
            END IF
 
        AFTER FIELD ogd09
            IF NOT cl_null(g_ogd[l_ac].ogd09) THEN
               IF g_ogd[l_ac].ogd09 <=0 THEN
                  NEXT FIELD ogd09
               #MOD-B90167 --- start ---
               ELSE

                  #CHI-CC0034 add --start--
                  SELECT ogb05 INTO l_ogb05 FROM ogb_file 
                   WHERE ogb01=g_oga.oga01 AND ogb03=g_ogd[l_ac].ogd03
                  #CHI-CC0034 add --end--

                 #SELECT ima18 INTO l_ogd14 FROM ima_file             #CHI-CC0034 mark
                  SELECT ima18,ima31 INTO l_ima18,l_ima31 FROM ima_file #CHI-CC0034
                   #WHERE ima01=g_ogd[l_ac].ogb04   #mark by guanyao160711
                   WHERE ima01 = g_ogd[l_ac].ogdud02 #add by guanyao160711

                 #IF STATUS THEN LET l_ogd14=0 END IF #CHI-CC0034 mark
                  IF STATUS THEN LET l_ima18=0 END IF #CHI-CC0034
                  #CHI-CC0034 add --start--
                  #CALL s_umfchk(g_ogd[l_ac].ogb04,l_ogb05,l_ima31)#mark by guanyao160711
                  CALL s_umfchk(g_ogd[l_ac].ogdud02,l_ogb05,l_ima31) #add by guanyao160711
                       RETURNING l_flag,l_factor
                  IF l_flag = '1' THEN LET l_factor = 1 END IF
                  LET l_ogd14 = l_ima18 * l_factor
                  #CHI-CC0034 add --end--
                  LET g_ogd[l_ac].ogd14=l_ogd14*g_ogd[l_ac].ogd09
                  LET l_obe12 = 0
                  LET l_obe13 = 0
                  LET l_obe23 = 0

                  SELECT obe12,obe13,obe23
                    INTO l_obe12,l_obe13,l_obe23
                    FROM obe_file WHERE obe01=g_ogd[l_ac].ogd08

                  IF STATUS THEN
                     LET l_ogd15=0
                  ELSE
                      IF cl_null(l_obe12) THEN LET l_obe12 = 0 END IF
                      IF cl_null(l_obe13) THEN LET l_obe13 = 0 END IF
                      IF cl_null(l_obe23) THEN LET l_obe23 = 0 END IF
                     #CHI-CC0034 mark --start--
                     #LET l_cnt1 = g_ogd[l_ac].ogd09/l_obe12
                     #CALL cl_digcut(l_cnt1,1) RETURNING l_cnt2
                     #CALL cl_digcut(l_cnt1,0) RETURNING l_cnt1
                     #LET l_cnt1_1 = l_cnt1 + (l_cnt1 - l_cnt2)
                     #IF l_cnt1_1 > 0 THEN LET l_cnt2 = l_cnt2 +1 END IF
                     #CHI-CC0034 mark --end--
                     CALL cnt_box(g_ogd[l_ac].ogd09,l_obe12) RETURNING l_cnt2 #CHI-CC0034 add
                  END IF

                  LET g_ogd[l_ac].ogd14t= g_ogd[l_ac].ogd14 * g_ogd[l_ac].ogd10
                 #LET g_ogd[l_ac].ogd15 = g_ogd[l_ac].ogd14 + l_obe23 + (l_cnt1_1*l_obe13) #CHI-CC0034 mark
                  #CHI-CC0034 add --start--
                  #淨重=外包裝重量+內包裝箱數*內包裝重量+總淨重
                  LET g_ogd[l_ac].ogd15 = l_obe23+(l_cnt2*l_obe13)+g_ogd[l_ac].ogd14
                  #CHI-CC0034 add --end--
                  LET g_ogd[l_ac].ogd15t = g_ogd[l_ac].ogd15 * g_ogd[l_ac].ogd10

                  DISPLAY BY NAME g_ogd[l_ac].ogd14t
                  DISPLAY BY NAME g_ogd[l_ac].ogd15t
                  DISPLAY BY NAME g_ogd[l_ac].ogd14
                  DISPLAY BY NAME g_ogd[l_ac].ogd15
               #MOD-B90167 ---  end  ---
               END IF
            END IF
 
        BEFORE FIELD ogd10
            IF g_ogd[l_ac].ogd04=1 THEN
               IF p_cmd = 'a' THEN     #MOD-840578                              
                  LET g_ogd[l_ac].ogd10=l_ogb12/g_ogd[l_ac].ogd09               
               END IF                  #MOD-840578   
               IF g_ogd[l_ac].ogd10 <= 0 THEN
                  LET g_ogd[l_ac].ogd10=1
                  LET g_ogd[l_ac].ogd09=l_ogb12
	          DISPLAY BY NAME g_ogd[l_ac].ogd10
	          DISPLAY BY NAME g_ogd[l_ac].ogd09
               END IF
            END IF
 
        AFTER FIELD ogd10
            IF NOT cl_null(g_ogd[l_ac].ogd10) THEN
                IF g_ogd[l_ac].ogd10 < 0 THEN 
                   NEXT FIELD ogd10                   
                END IF 
               IF cl_null(g_ogd[l_ac].ogd12b) THEN
                  #-->default 起始/截止箱號
                  SELECT MAX(ogd12e)+1 INTO g_ogd[l_ac].ogd12b FROM ogd_file
                   WHERE ogd01=g_oga.oga01
                  IF cl_null(g_ogd[l_ac].ogd12b) THEN
                     LET g_ogd[l_ac].ogd12b='1'
                  END IF
               END IF       #MOD-840578
                  LET g_ogd[l_ac].ogd12e=g_ogd[l_ac].ogd12b+g_ogd[l_ac].ogd10-1  
                 
	       DISPLAY BY NAME g_ogd[l_ac].ogd12e
	       DISPLAY BY NAME g_ogd[l_ac].ogd12b
	       DISPLAY BY NAME g_ogd[l_ac].ogd12e
               LET g_ogd[l_ac].ogd13=g_ogd[l_ac].ogd09*g_ogd[l_ac].ogd10  #計算數量
               LET g_ogd[l_ac].ogd14t=g_ogd[l_ac].ogd14*g_ogd[l_ac].ogd10   #MOD-940005 取消mark
               LET g_ogd[l_ac].ogd15t=g_ogd[l_ac].ogd15*g_ogd[l_ac].ogd10   #MOD-940005 取消mark
               LET g_ogd[l_ac].ogd16t=g_ogd[l_ac].ogd16*g_ogd[l_ac].ogd10
	       DISPLAY BY NAME g_ogd[l_ac].ogd13
	       DISPLAY BY NAME g_ogd[l_ac].ogd14t
	       DISPLAY BY NAME g_ogd[l_ac].ogd15t
	       DISPLAY BY NAME g_ogd[l_ac].ogd16t
            END IF
 
        BEFORE FIELD ogd11
           IF l_ac = 1 THEN
              IF NOT cl_null(g_ogd11) THEN
                 LET g_ogd[l_ac].ogd11 = g_ogd11
              END IF
           END IF
           IF p_cmd = 'a' THEN    #No.FUN-870124
              IF l_ac > 1 THEN
                 LET g_ogd[l_ac].ogd11=g_ogd[l_ac-1].ogd11
              END IF
	            DISPLAY BY NAME g_ogd[l_ac].ogd11   #MOD-840113 add
           END IF                 #No.FUN-870124
 
        AFTER FIELD ogd12b
           IF NOT cl_null(g_ogd[l_ac].ogd12b) THEN
              IF g_ogd[l_ac].ogd12b < 0 THEN 
                 NEXT FIELD ogd12b
              END IF        
              LET g_ogd[l_ac].ogd12e=g_ogd[l_ac].ogd12b+g_ogd[l_ac].ogd10-1
              #箱數為0,截止箱號等於起始箱號
              IF g_ogd[l_ac].ogd10=0 THEN LET g_ogd[l_ac].ogd12e=g_ogd[l_ac].ogd12b END IF #MOD-840378 add
           END IF
	   DISPLAY BY NAME g_ogd[l_ac].ogd12e  #MOD-940006 Add
 
        AFTER FIELD ogd12e
            IF NOT cl_null(g_ogd[l_ac].ogd12e) THEN 
               IF g_ogd[l_ac].ogd12e < 0 THEN 
                  NEXT FIELD ogd12e
               END IF 
            END IF 
 
        AFTER FIELD ogd13
           IF NOT cl_null(g_ogd[l_ac].ogd13) THEN 
              IF g_ogd[l_ac].ogd13 < 0 THEN 
                 NEXT FIELD ogd13
              END IF 
           END IF         
           IF NOT cl_null(g_ogd[l_ac].ogd13) THEN 
              LET l_ogd13 = g_ogd[l_ac].ogd09 * g_ogd[l_ac].ogd10
              IF g_ogd[l_ac].ogd13>l_ogd13 THEN 
                 CALL cl_err(g_ogd[l_ac].ogd13,'axm-979',0)
                 NEXT FIELD ogd13
              END IF
           END IF      
#.....................................................................................
#    單位淨重(ogd14) = 每箱裝數(ogd09) * 料件淨重 (ima18)
#    總淨重  (ogd14t) = 單位淨重(ogd14) * 箱數(ogd10)
#    包裝單位毛重(ogd15) = 包裝單位淨重 (ogd14) + 外包裝重量 (obe23) 
#                         + 內包裝重量 ((每箱裝數(ogd09) / 內包裝含產品數 (obe12)) * 內包裝重量 (obe13))
#    總毛重  (ogd15t)     = 包裝單位毛重(ogd15) * 箱數 (ogd10)
#.....................................................................................
               #CHI-CC0034 add --start--
               SELECT ogb05 INTO l_ogb05 FROM ogb_file 
                WHERE ogb01=g_oga.oga01 AND ogb03=g_ogd[l_ac].ogd03
               #CHI-CC0034 add --end--
              #SELECT ima18 INTO l_ogd14 FROM ima_file             #CHI-CC0034 mark
               SELECT ima18,ima31 INTO l_ima18,l_ima31 FROM ima_file #CHI-CC0034
                #WHERE ima01=g_ogd[l_ac].ogb04   #mark by guanyao160711
                 WHERE ima01=g_ogd[l_ac].ogdud02   #add by guanyao160711               
              #IF STATUS THEN LET l_ogd14=0 END IF #-->單位凈重 #CHI-CC0034 mark
               IF STATUS THEN LET l_ima18=0 END IF #單位凈重    #CHI-CC0034
               #CHI-CC0034 add --start--
               #CALL s_umfchk(g_ogd[l_ac].ogb04,l_ogb05,l_ima31)   #mark by guanyao160711
               CALL s_umfchk(g_ogd[l_ac].ogdud02,l_ogb05,l_ima31)    #add by guanyao160711
                    RETURNING l_flag,l_factor
               IF l_flag = '1' THEN LET l_factor = 1 END IF
               LET l_ogd14 = l_ima18 * l_factor
               #CHI-CC0034 add --end--
                LET g_ogd[l_ac].ogd14=l_ogd14*g_ogd[l_ac].ogd09  #-->每箱淨重
                LET l_obe12 = 0 
                LET l_obe13 = 0 
                LET l_obe23 = 0 
               SELECT obe12,obe13,obe23  
                 INTO l_obe12,l_obe13,l_obe23
                 FROM obe_file WHERE obe01=g_ogd[l_ac].ogd08
               IF STATUS THEN
                  LET l_ogd15=0
               ELSE
                   IF cl_null(l_obe12) THEN LET l_obe12 = 0 END IF
                   IF cl_null(l_obe13) THEN LET l_obe13 = 0 END IF
                   IF cl_null(l_obe23) THEN LET l_obe23 = 0 END IF
                 #CHI-CC0034 mark --start--
                 #LET l_cnt1 = g_ogd[l_ac].ogd09/l_obe12
                 #CALL cl_digcut(l_cnt1,1) RETURNING l_cnt2
                 #CALL cl_digcut(l_cnt1,0) RETURNING l_cnt1
                 #LET l_cnt1_1 = l_cnt1 + (l_cnt1 - l_cnt2) 
                 #IF l_cnt1_1 > 0 THEN LET l_cnt2 = l_cnt2 +1 END IF
                 #CHI-CC0034 mark --end--
                  CALL cnt_box(g_ogd[l_ac].ogd09,l_obe12) RETURNING l_cnt2 #CHI-CC0034 add
               END IF
               LET g_ogd[l_ac].ogd14t= g_ogd[l_ac].ogd14 * g_ogd[l_ac].ogd10  
              #CHI-CC0034 mark --start--
              #LET g_ogd[l_ac].ogd15 = g_ogd[l_ac].ogd14 + l_obe23
              #                         + (l_cnt1_1*l_obe13)    
              #CHI-CC0034 mark --end--
               #CHI-CC0034 add --start--
               #淨重=外包裝重量+內包裝箱數*內包裝重量+總淨重
               LET g_ogd[l_ac].ogd15 = l_obe23+(l_cnt2*l_obe13)+g_ogd[l_ac].ogd14
               #CHI-CC0034 add --end--
               LET g_ogd[l_ac].ogd15t = g_ogd[l_ac].ogd15 * g_ogd[l_ac].ogd10 
               DISPLAY BY NAME g_ogd[l_ac].ogd14t
               DISPLAY BY NAME g_ogd[l_ac].ogd15t
	       DISPLAY BY NAME g_ogd[l_ac].ogd14
	       DISPLAY BY NAME g_ogd[l_ac].ogd15
        AFTER FIELD ogd14
           IF NOT cl_null(g_ogd[l_ac].ogd14) THEN 
              IF g_ogd[l_ac].ogd14 < 0 THEN 
                 NEXT FIELD ogd14
              END IF 
           END IF         
            LET l_obe12 = 0 
            LET l_obe13 = 0 
            LET l_obe23 = 0 
           SELECT obe12,obe13,obe23  
             INTO l_obe12,l_obe13,l_obe23
             FROM obe_file WHERE obe01=g_ogd[l_ac].ogd08
           IF STATUS THEN
              LET l_ogd15=0
           ELSE
               IF cl_null(l_obe12) THEN LET l_obe12 = 0 END IF
               IF cl_null(l_obe13) THEN LET l_obe13 = 0 END IF
               IF cl_null(l_obe23) THEN LET l_obe23 = 0 END IF
             #CHI-CC0034 mark --start--
             #LET l_cnt1 = g_ogd[l_ac].ogd09/l_obe12
             #CALL cl_digcut(l_cnt1,1) RETURNING l_cnt2
             #CALL cl_digcut(l_cnt1,0) RETURNING l_cnt1
             #LET l_cnt1_1 = l_cnt1 + (l_cnt1 - l_cnt2) 
             #IF l_cnt1_1 > 0 THEN LET l_cnt2 = l_cnt2 +1 END IF
             #CHI-CC0034 mark --end--
              CALL cnt_box(g_ogd[l_ac].ogd09,l_obe12) RETURNING l_cnt2 #CHI-CC0034 add
           END IF
          #CHI-CC0034 mark --start--
          #LET g_ogd[l_ac].ogd15  = g_ogd[l_ac].ogd14 + l_obe23
          #                         + (l_cnt1_1*l_obe13)    
          #CHI-CC0034 mark --end--
           #CHI-CC0034 add --start--
           #淨重=外包裝重量+內包裝箱數*內包裝重量+總淨重
           LET g_ogd[l_ac].ogd15 = l_obe23+(l_cnt2*l_obe13)+g_ogd[l_ac].ogd14
           #CHI-CC0034 add --end--
           LET g_ogd[l_ac].ogd14t = g_ogd[l_ac].ogd14 * g_ogd[l_ac].ogd10  
           LET g_ogd[l_ac].ogd15t = g_ogd[l_ac].ogd15 * g_ogd[l_ac].ogd10 
           DISPLAY BY NAME g_ogd[l_ac].ogd15
           DISPLAY BY NAME g_ogd[l_ac].ogd15t
           DISPLAY BY NAME g_ogd[l_ac].ogd14t
 
        AFTER FIELD ogd14t     #總淨重不可小於淨重
           IF NOT cl_null(g_ogd[l_ac].ogd14t) THEN 
              IF g_ogd[l_ac].ogd14t < 0 THEN 
                 NEXT FIELD ogd14t
              END IF 
           END IF         
           IF NOT cl_null(g_ogd[l_ac].ogd14t) THEN
              IF g_ogd[l_ac].ogd14t < g_ogd[l_ac].ogd14 THEN
                 CALL cl_err('','axm-312',1)
                 NEXT FIELD ogd14
              END IF
           END IF
           LET g_ogd[l_ac].ogd15t = g_ogd[l_ac].ogd15  * g_ogd[l_ac].ogd10  #MOD-830107
           DISPLAY BY NAME g_ogd[l_ac].ogd15t
 
        AFTER FIELD ogd15    #毛重不可小於淨重
           IF NOT cl_null(g_ogd[l_ac].ogd15) THEN 
              IF g_ogd[l_ac].ogd15 < 0 THEN 
                 NEXT FIELD ogd15
              END IF 
           END IF         
           IF g_ogd[l_ac].ogd15 < g_ogd[l_ac].ogd14 THEN
              CALL cl_err('','axm-313',1)
              NEXT FIELD ogd14
           END IF
           LET g_ogd[l_ac].ogd15t = g_ogd[l_ac].ogd15 * g_ogd[l_ac].ogd10  #MOD-7A0002  #MOD-830107
 
        AFTER FIELD ogd15t
           IF NOT cl_null(g_ogd[l_ac].ogd15t) THEN 
              IF g_ogd[l_ac].ogd15t < 0 THEN 
                 NEXT FIELD ogd15t
              END IF 
           END IF         
 
        AFTER FIELD ogd16
           IF NOT cl_null(g_ogd[l_ac].ogd16) THEN 
              IF g_ogd[l_ac].ogd16 < 0 THEN 
                 NEXT FIELD ogd16
              END IF 
           END IF         
           LET g_ogd[l_ac].ogd16t = g_ogd[l_ac].ogd16 * g_ogd[l_ac].ogd10
           DISPLAY BY NAME g_ogd[l_ac].ogd16t
    
        AFTER FIELD ogd16t
           IF NOT cl_null(g_ogd[l_ac].ogd16t) THEN 
              IF g_ogd[l_ac].ogd16t < 0 THEN 
                 NEXT FIELD ogd16t
              END IF 
           END IF         
    
        AFTER FIELD ogdud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogdud02
           #IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
           #str-----add by guanyao160711
           IF NOT cl_null(g_ogd[l_ac].ogdud02) THEN
              IF cl_null(g_ogd_t.ogdud02) OR g_ogd[l_ac].ogdud02!=g_ogd_t.ogdud02 THEN
                 LET l_x = 0
                 SELECT COUNT(*) INTO l_x FROM ogb_file WHERE ogb04 = g_ogd[l_ac].ogdud02 AND ogb01 = g_oga.oga01
                 IF cl_null(l_x) OR l_x = 0 THEN 
                    CALL cl_err(g_oga.oga01,'cxm-012',0)
                    NEXT FIELD ogdud02
                 END IF 
                 LET l_x = 0
                 SELECT COUNT(*) INTO l_x FROM ogd_file WHERE ogd01 = g_oga.oga01 AND ogdud02=g_ogd[l_ac].ogdud02
                 IF cl_null(l_x) OR l_x = 0 THEN 
                    CALL cl_err(g_oga.oga01,'cxm-013',0)
                    NEXT FIELD ogdud02
                 END IF 
                 LET l_x = 0
                 SELECT COUNT(*) INTO l_x FROM obl_file WHERE obl01 = g_ogd[l_ac].ogdud02 AND (obl02 = g_oga.oga04 OR obl02 = 'ALL')
                 IF cl_null(l_x) OR l_x = 0 THEN 
                    CALL cl_err(g_ogd[l_ac].ogdud02,'cxm-011',0)
                    NEXT FIELD ogdud02
                 END IF 
                 SELECT obl03 INTO g_ogd[l_ac].ogd09 FROM obl_file WHERE obl01 = g_ogd[l_ac].ogdud02 AND obl02 = g_oga.oga04
                 IF cl_null(g_ogd[l_ac].ogd09) THEN 
                    SELECT obl03 INTO g_ogd[l_ac].ogd09 FROM obl_file WHERE obl01 = g_ogd[l_ac].ogdud02 AND obl02 ='ALL'
                 END IF 
                 SELECT SUM(ogb12) INTO g_ogd[l_ac].ogd13 FROM ogb_file WHERE ogb01= g_oga.oga01 AND ogb04 = g_ogd[l_ac].ogdud02

                            
              END IF 
           END IF 
           #end-----add by guanyao160711
        AFTER FIELD ogdud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogdud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogdud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogdud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogdud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogdud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogdud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogdud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogdud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogdud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogdud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogdud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogdud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_ogd_t.ogd03 IS NOT NULL THEN
               #IF NOT cl_delete() THEN #TQC-BA0126
                IF NOT cl_delb(0,0) THEN #TQC-BA0130
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF

                DELETE FROM ogd_file
                 WHERE ogd01 = g_oga.oga01
                   AND ogd03 = g_ogd_t.ogd03
                   AND ogd04 = g_ogd_t.ogd04
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","ogd_file",g_oga.oga01,g_ogd_t.ogd03,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   ROLLBACK WORK
                   CANCEL DELETE
                ELSE 
                   #str---add by guanyao160709
                   DELETE FROM tc_ogd_file 
                    WHERE tc_ogd01 = g_oga.oga01
                      AND tc_ogd02 = g_ogd_t.ogd03
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("del","tc_ogd_file",g_oga.oga01,'',SQLCA.sqlcode,"","",1)  #No.FUN-660167
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF
                   #str---add by guanyao160709
                END IF
                
 
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
 
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ogd[l_ac].* = g_ogd_t.*
               CLOSE t630_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ogd[l_ac].ogd03,-263,1)
               LET g_ogd[l_ac].* = g_ogd_t.*
            ELSE
               CALL t630_b_move_back() #FUN-730018
               UPDATE ogd_file SET * = b_ogd.*
                WHERE ogd01=g_oga.oga01
                  AND ogd03=g_ogd_t.ogd03
                  AND ogd04=g_ogd_t.ogd04
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","ogd_file",g_oga.oga01,g_ogd_t.ogd03,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_ogd[l_ac].* = g_ogd_t.*
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D30034 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_ogd[l_ac].* = g_ogd_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_ogd.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF
               CLOSE t630_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D30034 Add
            CLOSE t630_bcl
            COMMIT WORK
 
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(ogd03) AND l_ac > 1 THEN
               LET g_ogd[l_ac].* = g_ogd[l_ac-1].*
               NEXT FIELD ogd03
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ogd08)
                   CALL cl_init_qry_var()
                   LET g_qryparam.default1 = g_ogd[l_ac].ogd08
                   
                   IF g_ogd[l_ac].ogd17='2' THEN             #No.FUN-820046
                      #IF NOT cl_null(g_ogd[l_ac].ogb04) THEN   #mark by guanyao160711
                      IF NOT cl_null(g_ogd[l_ac].ogdud02) THEN   #mark by guanyao160711
                       LET g_qryparam.form = "q_skb08_a" 
                       #LET g_qryparam.arg1=g_ogd[l_ac].ogb04  #mark by guanyao160711
                       LET g_qryparam.arg1=g_ogd[l_ac].ogdud02 #add by guanyao160711
                      ELSE
                       LET g_qryparam.form = "q_skb08_b"
                      END IF 
                   ELSE  	       
 
                   LET g_qryparam.form ="q_obe"              
 
                   END IF                       #FUN-810016
                                      
                   CALL cl_create_qry() RETURNING g_ogd[l_ac].ogd08
                    DISPLAY BY NAME g_ogd[l_ac].ogd08      #No.MOD-490371
                   NEXT FIELD ogd08
           END CASE
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
 
    UPDATE oga_file SET ogamodu = g_user,ogadate = g_today
     WHERE oga01 = g_oga.oga01
 
    CLOSE t630_bcl
     COMMIT WORK
 
# 新增自動確認功能 Modify by WUPN 96-05-06 ----------
     LET g_t1=s_get_doc_no(g_oga.oga01)        #No.FUN-550070
     SELECT * INTO g_oay.* FROM oay_file WHERE oayslip=g_t1
     IF STATUS THEN CALL cl_err('sel oay_file',STATUS,0) RETURN END IF
     IF g_oay.oayconf='N' THEN #單據不需自動確認
       RETURN
     ELSE
       CALL t630_y()
     END IF
END FUNCTION
 
FUNCTION t630_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(200)
   
    	LET g_sql =
        #"SELECT ogd03,ogb04,ogd04,ogd17,ogd08,ogd09,ogd10,ogd11,ogd12b,ogd12e,",       #No.FUN-820046
        "SELECT ogd03,ogdud02,ima02,ima021,ogd04,ogd17,ogd08,ogd09,ogd10,ogd11,ogd12b,ogd12e,",       #No.FUN-820046   #FUN-9B0121 add ogb06,''  #modify ogb06by guanyao160711
        "       ogd13,ogd14,ogd14t,ogd15,ogd15t,ogd16,ogd16t, ",
        #"       ogdud01,ogdud02,ogdud03,ogdud04,ogdud05,",     #mark by guanyao160711
        "       ogdud01,ogdud03,ogdud04,ogdud05,",              #add by guanyao160711
        "       ogdud06,ogdud07,ogdud08,ogdud09,ogdud10,",
        "       ogdud11,ogdud12,ogdud13,ogdud14,ogdud15", 
        #" FROM ogd_file LEFT OUTER JOIN ogb_file ON ogd_file.ogd01=ogb_file.ogb01 AND ogd_file.ogd03=ogb_file.ogb03",          #No.FUN-820046 #mark by guanyao160711
        "  FROM ogd_file LEFT JOIN ima_file ON ima01 = ogdud02",  #add by guanyao160711
        " WHERE ogd01 ='",g_oga.oga01,"'",  #單頭
        " ORDER BY 1,3"             #MOD-950059 add
    
    PREPARE t630_pb FROM g_sql
    DECLARE ogd_curs  CURSOR FOR t630_pb    #CURSOR
 
    CALL g_ogd.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH ogd_curs INTO g_ogd[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF

        #SELECT ima021 INTO g_ogd[g_cnt].ima021 FROM ima_file   #FUN-9B0121 add
        # WHERE ima01 = g_ogd[g_cnt].ogb04
 
        LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
 
    CALL g_ogd.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t630_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ogd TO s_ogd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################

      ON ACTION info_list                 #FUN-CB0014
         LET g_action_flag="info_list"    #FUN-CB0014
         EXIT DISPLAY                     #FUN-CB0014
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t630_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t630_feTch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL t630_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t630_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL t630_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #CKP
         CALL cl_set_field_pic(g_oga.oga30,"","","","","")
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
#@    ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
#@    ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
 
#@    ON ACTION "Packing List列印"
      ON ACTION print_packing_list
         LET g_action_choice="print_packing_list"
         EXIT DISPLAY
    #FUN-C90076---add---str---
      ON ACTION packing_list_mainland
         LET g_action_choice="packing_list_mainland"
         EXIT DISPLAY
    #FUN-C90076---add---end---
 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         IF l_ac=0 THEN LET l_ac=1 END IF #MOD-810114 add
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0020  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#-->自動產生包裝單身資料
FUNCTION t630_g_b()
  DEFINE l_ogd      RECORD LIKE ogd_file.*,
         l_ogb      RECORD LIKE ogb_file.*,
         l_ogd08    LIKE ogd_file.ogd08,
         l_ogd14    LIKE ogd_file.ogd14,
         l_ogd15    LIKE ogd_file.ogd15,
         l_success  LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(01),
         l_ogd10    LIKE type_file.num10,       # No.FUN-680137 INTEGER,
         l_mod      LIKE type_file.num10,       # No.FUN-680137 INTEGER,
         l_i        LIKE type_file.num5,          #No.FUN-680137 SMALLINT
 
         l_m        LIKE type_file.num5,        #No.FUN-810016 
 
         l_ogd12e_t LIKE ogd_file.ogd12e,
         tm         RECORD
                    a    LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(01),
                    b    LIKE ogd_file.ogd12b        # No.FUN-680134
                  ,ogd17 LIKE ogd_file.ogd17,        # No.FUN-820046
                   ogd08a      LIKE ogd_file.ogd08        #No.FUN-810016
                    
                    END RECORD
DEFINE l_obe12      LIKE obe_file.obe12,                #NO.MOD-740419
       l_obe13      LIKE obe_file.obe13,                #MOD-740419
       l_obe22      LIKE obe_file.obe22,                #MOD-740419
       l_obe23      LIKE obe_file.obe23,                #MOD-740419
       l_cnt1       LIKE type_file.num20_6,             #MOD-7A0002
       l_cnt2       LIKE type_file.num10,               #MOD-7A0002
       l_cnt1_1     LIKE type_file.num20_6              #MOD-7A0002
DEFINE l_sma128     LIKE sma_file.sma128                #No.FUN-820046 
#CHI-CC0034 add --start--
DEFINE l_ima18      LIKE ima_file.ima18         
DEFINE l_ima31      LIKE ima_file.ima31         
DEFINE l_flag       LIKE type_file.num5        
DEFINE l_factor     LIKE ima_file.ima31_fac    
#CHI-CC0034 add --end--
#str-----add by guanyao160708
DEFINE l_ogb12      LIKE ogb_file.ogb12
DEFINE l_ogb04      LIKE ogb_file.ogb04
DEFINE l_ogb11      LIKE ogb_file.ogb11
DEFINE l_ogb05      LIKE ogb_file.ogb05
DEFINE l_x          LIKE type_file.chr1
DEFINE l_b          LIKE type_file.num5
DEFINE l_imaud02    LIKE ima_file.imaud02
DEFINE l_imaud08    LIKE ima_file.imaud08
DEFINE l_ima25      LIKE ima_file.ima25
DEFINE l_imaud08_1  LIKE ima_file.imaud08
DEFINE l_flag1      LIKE type_file.num5
DEFINE l_factor1    LIKE ima_file.ima31_fac
#end-----add by guanyao160708
 
  OPEN WINDOW t630_w1 AT 10,20 WITH FORM "axm/42f/axmt6301"
       ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_set_locale_frm_name("axmt6301")       #No.FUN-810016
    CALL cl_ui_locale("axmt6301")
 
  INITIALIZE tm.* TO NULL
 
  SELECT sma128 INTO l_sma128 FROM sma_file
  IF l_sma128!='Y' THEN
     CALL cl_set_comp_visible("ogd17,ogd08a",FALSE)
     LET tm.ogd17=1
     LET tm.ogd08a=1
  END IF
 
  INPUT BY NAME tm.a,tm.b,tm.ogd17,tm.ogd08a       #No.FUN-820046
 
  WITHOUT DEFAULTS        
 
     BEFORE INPUT              #No.FUN-820046
        LET tm.ogd17='1'       #No.FUN-820046
 
     AFTER FIELD b
        IF cl_null(tm.b)  THEN NEXT FIELD b END IF
     
     AFTER FIELD ogd17
        NEXT FIELD ogd08a
           
     AFTER FIELD ogd08a
        IF tm.ogd08a IS NOT NULL THEN 
           IF tm.ogd17='1' THEN           #No.FUN-820046
              SELECT COUNT(*) INTO l_m FROM obe_file
                WHERE obe01=tm.ogd08a
           ELSE
              SELECT COUNT(*) INTO l_m FROM obj_file,obi_file
                 WHERE obi_file.obi01=obj_file.obj01
                   AND obi_file.obi01=tm.ogd08a
                   AND obi_file.obiacti='Y'
                   AND obi12 IS NOT NULL   #No.FUN-870124 hm add
                   AND obi14 IS NOT NULL   #No.FUN-870124 hm add
           END IF
           IF l_m=0 THEN 
              CALL cl_err(tm.ogd08a,'ask-008',0)
              NEXT FIELD ogd08a
           END IF 
        END IF    
              
       ON ACTION controlp
       CASE 
         WHEN INFIELD (ogd08a)
           CALL cl_init_qry_var()
           IF tm.ogd17='1' THEN         #No.FUN-820046
              LET g_qryparam.form="q_obe"
           ELSE
              LET g_qryparam.form="q_ogd08"
              LET g_qryparam.where=" obi_file.obi01=obj_file.obj01 and obi_file.obiacti='Y'"
           END IF
           CALL cl_create_qry() RETURNING tm.ogd08a
           DISPLAY tm.ogd08a TO FORMONLY.ogd08a
           NEXT FIELD ogd08a
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
  IF INT_FLAG THEN
     LET INT_FLAG = 0
     CLOSE WINDOW t630_w1
     RETURN
  END IF
 
  CLOSE WINDOW t630_w1
 
  MESSAGE 'WORKING!'
  #-->取得產品編號

  #str-----add by guanyao160708  #必须是为未
  DECLARE ogb_curs CURSOR WITH HOLD FOR 
   SELECT SUM(ogb12),ogb04,ogb05 FROM ogb_file,oga_file WHERE ogb01 =g_oga.oga01
       AND ogb04 NOT IN (SELECT tc_ogd04 FROM tc_ogd_file WHERE tc_ogd01 = g_oga.oga01) #CHI-980017   
       AND substr(ogb04,1,4) !='MISC'
       AND oga01 = ogb01 
       #AND ogaconf = 'Y'
       #AND ogapost = 'N'
   GROUP BY ogb04,ogb05
   ORDER BY ogb04
  #end-----add by guanyao160708
 
 # DECLARE ogb_curs CURSOR WITH HOLD FOR
 #   SELECT * FROM ogb_file
 #    WHERE ogb01=g_oga.oga01
 #      AND ogb03 NOT IN (SELECT ogd03 FROM ogd_file WHERE ogd01 = g_oga.oga01) #CHI-980017   
 #      AND ogb04[1,4] != 'MISC'
 #    ORDER BY ogb03
 
  BEGIN WORK
  
  LET l_success='Y'
  LET l_i=1
  LET l_b = 1              #add by guanyao160709
  LET g_success = 'Y'      #No.FUN-8A0086
  CALL s_showmsg_init()    #No.FUN-710046
  
  IF l_sma128!='Y' THEN
  #str-----add by guanyao160708
  LET l_ogb12 = ''
  LET l_ogb04 = ''
  LET l_ogb05 = ''
  #end----add by guanyao160708
  # FOREACH ogb_curs INTO l_ogb.*
   FOREACH ogb_curs INTO l_ogb12,l_ogb04,l_ogb05
      IF STATUS THEN
         CALL s_errmsg('','','ogb_curs',STATUS,1) 
         LET g_success = 'N'           #No.FUN-8A0086
         LET l_success='N' EXIT FOREACH
      END IF
       IF g_success='N' THEN
          LET g_totsuccess='N' 
          LET g_success="Y"
       END IF 
 
      INITIALIZE l_ogd.* TO NULL
      LET l_ogd.ogd01=g_oga.oga01
      #LET l_ogd.ogd03=l_ogb.ogb03  #mark by guanyao160708
      LET l_ogd.ogd03 = l_b         #add by guanyao160709
      LET l_ogd.ogd04=1
      LET l_ogd.ogd11= tm.a
      LET g_ogd11 = ''                #TQC-7C0110  該值帶回到t630_b()函數中
      LET g_ogd11 = l_ogd.ogd11       #TQC-7C0110
      
      #no.7193 包裝方式先抓obl_file(axmi160)再抓ima_file
      SELECT obl03 INTO l_ogd.ogd08 FROM obl_file
      # WHERE obl01 = l_ogb.ogb04 AND obl02 = g_oga.oga04  #mark by guanyao160708
        WHERE obl01 = l_ogb04 AND obl02 = g_oga.oga04      #add by guanyao160708
      #str----add by guanyao160709
      IF cl_null(l_ogd.ogd08) THEN 
         SELECT obl03 INTO l_ogd.ogd08 FROM obl_file
          WHERE obl01 = l_ogb04 AND obl02 = 'ALL'
      END IF 
      #end----add by guanyao160709
 
      #-->包裝方式,單位淨重
     #SELECT ima134,ima18 INTO l_ogd08,l_ogd14  #CHI-CC0034 mark
      SELECT ima134,ima18,ima31,imaud02,imaud08,ima25 
        INTO l_ogd08,l_ima18,l_ima31,l_imaud02,l_imaud08,l_ima25   #CHI-CC0034   #add imaud02,imaud08,ima25 by guanyao160709
        #FROM ima_file    WHERE ima01=l_ogb.ogb04  #mark by guanyao160708
        FROM ima_file    WHERE ima01=l_ogb04  #mark by guanyao160708
     #IF STATUS THEN LET l_ogd08='' LET l_ogd14=0 END IF #CHI-CC0034 mark
      IF STATUS THEN 
         LET l_ogd08='' 
         LET l_ima18=0 
      END IF #CHI-CC0034
      IF cl_null(l_ogd.ogd08) THEN LET l_ogd.ogd08 = l_ogd08 END IF #no.7193
      IF cl_null(l_ogd.ogd08) THEN
         CONTINUE FOREACH
      END IF
      #str-----add by guanyao160709#包装单位和库存单位是有转化关系的，在将报装单位转换成销售单位
      IF cl_null(l_imaud02) THEN 
         CONTINUE FOREACH 
      END IF 
      IF l_imaud02 !=l_ima25 THEN 
         LET l_flag1 = ''
         LET l_factor1 = ''
         CALL s_umfchk(l_ogb04,l_imaud02,l_ima25)   #add by guanyao160708
           RETURNING l_flag1,l_factor1
         IF l_flag1 = '1' THEN LET l_factor1 = 1 END IF 
         LET l_imaud08 = l_imaud08*l_factor1
      END IF
      IF  l_ima25 !=l_ogb05 THEN 
         LET l_flag1 = ''
         LET l_factor1 = ''
         CALL s_umfchk(l_ogb04,l_ima25,l_ogb05)   #add by guanyao160708
           RETURNING l_flag1,l_factor1
         IF l_flag1 = '1' THEN LET l_factor1 = 1 END IF 
         LET l_imaud08 = l_imaud08*l_factor1
      END IF 
      LET l_imaud08_1 = l_imaud08
      #end-----add by guanyao160709
      #CHI-CC0034 add --start--
      #CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_ima31)  #mark by guanyao160708
      CALL s_umfchk(l_ogb04,l_ogb05,l_ima31)   #add by guanyao160708
           RETURNING l_flag,l_factor
      IF l_flag = '1' THEN LET l_factor = 1 END IF
      LET l_ogd14 = l_ima18 * l_factor
      #CHI-CC0034 add --end--
 
      #-->外包裝重量,每箱裝數,材積
      LET l_obe12 = 0                 #MOD-7A0002
      LET l_obe13 = 0                 #MOD-7A0002
      LET l_obe23 = 0                 #MOD-7A0002
      SELECT obe12,obe13,obe22,obe23  #NO.MOD-740419 
        INTO l_obe12,l_obe13,l_obe22,l_obe23    #NO.MOD-740419
        FROM obe_file WHERE obe01=l_ogd.ogd08
 
      IF cl_null(l_obe12) THEN LET l_obe12 = 0 END IF
      IF cl_null(l_obe13) THEN LET l_obe13 = 0 END IF
      IF cl_null(l_obe22) THEN LET l_obe22 = 0 END IF
      IF cl_null(l_obe23) THEN LET l_obe23 = 0 END IF
      LET l_ogd15 = (((g_ogd[l_ac].ogd13/l_obe12)*l_obe13)+
                    (((g_ogd[l_ac].ogd13/l_obe12)/l_obe22)*l_obe23))
      SELECT obe24,obe26 INTO l_ogd.ogd09,l_ogd.ogd16
        FROM obe_file         WHERE obe01=l_ogd.ogd08
      IF STATUS THEN
         LET l_ogd15=0 LET l_ogd.ogd09=0 LET l_ogd.ogd16=0
      END IF
      
      #-->計算箱數
      #LET l_ogd10 = l_ogb.ogb12 / l_ogd.ogd09  #mark by guanyao160708
      #LET l_ogd10 = l_ogb12 / l_ogd.ogd09  #add by guanyao160708
      #str----add by guanyao160709
      SELECT ceil(l_ogb12/(l_imaud08*l_obe12*l_obe22)) INTO l_ogd10 FROM dual #总销售数量除以（包装销售数量*内包装*外包装）
      LET l_ogd.ogd09 = l_imaud08*l_obe12*l_obe22
      #end---add by guanyao160709
      LET l_ogd.ogd10=l_ogd10
      #IF l_ogd10 = 0 THEN
      IF l_ogd10 = 1 THEN
         LET l_ogd.ogd10=1
         #LET l_ogd.ogd09=l_ogb.ogb12   #mark by guanyao160708
         LET l_ogd.ogd09=l_ogb12       #add by guanyao160708
         LET l_ogd.ogdud10=0            #add by guanyao160708尾数箱
      END IF
 
      LET l_ogd.ogd14 = l_ogd14 * l_ogd.ogd09   #-->每箱淨重 #MOD-7A0002 
      LET l_ogd.ogd14t= l_ogd.ogd14 * l_ogd.ogd10            #MOD-830107 
 
      #-->起始/截止箱號
      IF l_i = 1 THEN
         LET l_ogd.ogd12b=tm.b               #FUN-680134
      ELSE
         LET l_ogd.ogd12b=l_ogd12e_t+1               #FUN-680134
      END IF
 
      LET l_ogd.ogd12e=l_ogd.ogd12b+l_ogd.ogd10-1                #FUN-680134
      #-->計算數量
      #LET l_ogd.ogd13=l_ogd.ogd09*l_ogd.ogd10#mark by guanyao160709
      #LET l_mod=l_ogb.ogb12-l_ogd.ogd13   #mark by guanyao160708
      #LET l_mod=l_ogb12-l_ogd.ogd13   #add by guanyao160708
      #str---add by guanyao160709#尾数箱
      LET l_ogd.ogd13 = l_ogb12
      LET l_mod = l_ogb12-(l_ogd.ogd09*l_ogd.ogd10)
      IF l_mod!= 0 THEN 
         LET l_ogd.ogdud10 = l_mod
      ELSE 
         LET l_ogd.ogdud10 = 0
      END IF 
      #end---add by guanyao160709#尾数箱
      #-->計算總淨重,毛重,材積
 
     #CHI-CC0034 mark --start--
     #LET l_cnt1 = l_ogd.ogd09/l_obe12
     #CALL cl_digcut(l_cnt1,1) RETURNING l_cnt2
     #CALL cl_digcut(l_cnt1,0) RETURNING l_cnt1
     #LET l_cnt1_1 = l_cnt1 + (l_cnt1 - l_cnt2) 
     #IF l_cnt1_1 > 0 THEN LET l_cnt2 = l_cnt2 +1 END IF
     #LET l_ogd.ogd15 =l_ogd.ogd14+l_obe23+(l_cnt1_1*l_obe13)  #MOD-830107
     #CHI-CC0034 mark --end--
     #CHI-CC0034 add --start--
      CALL cnt_box(l_ogd.ogd09,l_obe12) RETURNING l_cnt2
      #淨重=外包裝重量+內包裝箱數*內包裝重量+總淨重
      LET l_ogd.ogd15 =l_obe23+(l_cnt2*l_obe13)+l_ogd.ogd14
     #CHI-CC0034 add --end--
      LET l_ogd.ogd15t=l_ogd.ogd15*l_ogd.ogd10                 #MOD-830107 
 
      LET l_ogd.ogd16t=l_ogd.ogd16*l_ogd.ogd10
      LET l_i=l_i+1
      LET l_ogd12e_t=l_ogd.ogd12e            #-->保存截止箱號
      LET l_ogd.ogd17='1'             #No.FUN-820046
      LET l_ogd.ogdud02 = l_ogb04     #add by guanyao160711
 
      IF NOT cl_null(l_ogd.ogd01) THEN    #No.FUN-820046
         LET l_ogd.ogdplant = g_plant 
         LET l_ogd.ogdlegal = g_legal 
         LET l_b = l_b+1                 #add by guanyao160709
         INSERT INTO ogd_file VALUES(l_ogd.*)
         IF SQLCA.SQLCODE THEN
           CALL s_errmsg('','','INS-ogd #1',SQLCA.SQLCODE,1)
           LET l_success='N'
           CONTINUE FOREACH
         END IF
         LET l_x = ''
         CALL t630_ins(l_ogd.ogd01,l_ogd.ogd03,l_ogb04) RETURNING l_x   #add by guanyao160708
      END IF   #No.FUN-820046
 #str-----add by guanyao160709#汇总资料不考虑小数
      --IF l_mod !=0 THEN
         --LET l_ogd.ogd04=2                                 #序號
         --LET l_ogd.ogd09=l_mod                             #每箱裝數
         --LET l_ogd.ogd10=1                                 #箱數
         --LET l_ogd.ogd12b=l_ogd.ogd12e+1                   #起始箱號 #FUN-680134
         --LET l_ogd.ogd12e=l_ogd.ogd12b                     #截止箱號 #FUN-680134
         --LET l_ogd.ogd13=l_mod                             #數量
         --LET l_ogd.ogd14 =l_ogd14*l_ogd.ogd09               #-->每箱淨重  #MOD-830107  
         --LET l_ogd.ogd14t=l_ogd.ogd14*l_ogd.ogd10           #MOD-830107 
         #-->計算總淨重,毛重,材積
        #CHI-CC0034 mark --start--
        #LET l_cnt1 = l_ogd.ogd09/l_obe12
        #CALL cl_digcut(l_cnt1,1) RETURNING l_cnt2
        #CALL cl_digcut(l_cnt1,0) RETURNING l_cnt1
        #LET l_cnt1_1 = l_cnt1 + (l_cnt1 - l_cnt2) 
        #IF l_cnt1_1 > 0 THEN LET l_cnt2 = l_cnt2 +1 END IF
        #LET l_ogd.ogd15 =l_ogd.ogd14+l_obe23+(l_cnt1_1*l_obe13)  #MOD-830107
        #CHI-CC0034 mark --end--
        #CHI-CC0034 add --start--
         --CALL cnt_box(l_ogd.ogd09,l_obe12) RETURNING l_cnt2
         #淨重=外包裝重量+內包裝箱數*內包裝重量+總淨重
         --LET l_ogd.ogd15 =l_obe23+(l_cnt2*l_obe13)+l_ogd.ogd14
        #CHI-CC0034 add --end--
         --LET l_ogd.ogd15t=l_ogd.ogd15*l_ogd.ogd10                 #MOD-830107
         --LET l_ogd.ogd16t=l_ogd.ogd16*l_ogd.ogd10
         --LET l_ogd12e_t=l_ogd.ogd12e
 --
         --LET l_ogd.ogd17='1'          #No.FUN-820046
 --
         --IF NOT cl_null(l_ogd.ogd01) THEN    #No.FUN-820046
 --
            --LET l_ogd.ogdplant = g_plant 
            --LET l_ogd.ogdlegal = g_legal 
         --INSERT INTO ogd_file VALUES(l_ogd.*)
         --IF SQLCA.SQLCODE THEN
            --CALL s_errmsg('','','INS-ogd #2',SQLCA.SQLCODE,1)
            --LET l_success='N'
            --CONTINUE FOREACH
         --END IF
        --END IF    #No.FUN-820046
      --END IF
#end-----add by guanyao160709
  END FOREACH
  ELSE        #No.FUN-820046  l_sma128='Y'
         CALL t630_g_b2(tm.*) RETURNING l_success            #No.FUN-820046 
  END IF      #No.FUN-820046
  IF g_totsuccess="N" THEN                                                                                                         
     LET g_success="N"                                                                                                             
  END IF                                                                                                                           
  CALL s_showmsg()
 
  IF l_success = 'Y' THEN
     COMMIT WORK
  ELSE
     ROLLBACK WORK
  END IF
  MESSAGE ''
 
END FUNCTION
 
FUNCTION t630_g_b2(tm)           #No.FUN-820046
DEFINE tm         RECORD
                  a    LIKE type_file.chr1,      
                  b    LIKE ogd_file.ogd12b,        
                  ogd17       LIKE ogd_file.ogd17,
                  ogd08a      LIKE ogd_file.ogd08        
                  END RECORD,
       l_ogd      RECORD LIKE ogd_file.*,
       l_ogb      RECORD LIKE ogb_file.*,
       l_obj      RECORD LIKE obj_file.*,  
       l_obi      RECORD LIKE obi_file.*,     #No.FUN-820046
       l_ogd08    LIKE ogd_file.ogd08,
       l_ogd14    LIKE ogd_file.ogd14,
       l_ogd15    LIKE ogd_file.ogd15, 
       l_success  LIKE type_file.chr1,       
       l_ogd10    LIKE type_file.num10,     
       l_mod      LIKE type_file.num10,     
       l_i        LIKE type_file.num5,         
       l_ogd12e_t LIKE ogd_file.ogd12e
DEFINE L_obe12    LIKE obe_file.obe12,                #NO.MOD-740419
       l_obe13    LIKE obe_file.obe13,                #MOD-740419
       l_obe22    LIKE obe_file.obe22,                #MOD-740419
       l_obe23    LIKE obe_file.obe23,                #MOD-740419
       l_cnt1     LIKE type_file.num20_6,             #MOD-7A0002
       l_cnt2     LIKE type_file.num10,               #MOD-7A0002
       l_cnt1_1   LIKE type_file.num20_6              #MOD-7A0002
DEFINE l_ogdi     RECORD LIKE ogdi_file.*             #No.FUN-7B0018
DEFINE b_ogdi     RECORD LIKE ogdi_file.*             #No.FUN-7B0018
DEFINE k_ogdi     RECORD LIKE ogdi_file.*             #No.FUN-7B0018
DEFINE h_ogdi     RECORD LIKE ogdi_file.*             #No.FUN-7B0018
DEFINE l_sum      LIKE type_file.num20_6              #No.FUN-820046
#CHI-CC0034 add --start--
DEFINE l_ima18      LIKE ima_file.ima18         
DEFINE l_ima31      LIKE ima_file.ima31         
DEFINE l_flag       LIKE type_file.num5        
DEFINE l_factor     LIKE ima_file.ima31_fac    
#CHI-CC0034 add --end--
                    
    LET l_success='Y'                   #No.FUN-820046
    LET l_i=1                           #No.FUN-820046
    IF tm.ogd17 = '1' THEN              #No.FUN-820046     
      FOREACH ogb_curs INTO l_ogb.*
      IF STATUS THEN
         CALL s_errmsg('','','ogb_curs',STATUS,1) 
         LET l_success='N' EXIT FOREACH
      END IF           
      IF g_success='N' THEN
         LET g_totsuccess='N' 
         LET g_success="Y"
      END IF 
 
      INITIALIZE l_ogd.* TO NULL
      LET l_ogd.ogd01=g_oga.oga01
      LET l_ogd.ogd03=l_ogb.ogb03
      LET l_ogd.ogd04=1
      LET l_ogd.ogd11= tm.a
      LET g_ogd11 = ''
      LET g_ogd11 = l_ogd.ogd11      
      LET l_ogd.ogd08 = tm.ogd08a
     #SELECT ima18 INTO l_ogd14 FROM ima_file WHERE ima01=l_ogb.ogb04 #CHI-CC0034 mark
      #CHI-CC0034 add --start--
      SELECT ima18,ima31 INTO l_ima18,l_ima31 FROM ima_file WHERE ima01=l_ogb.ogb04 
      IF STATUS THEN LET l_ima18=0 END IF 
      CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_ima31)
           RETURNING l_flag,l_factor
      IF l_flag = '1' THEN LET l_factor = 1 END IF
      LET l_ogd14 = l_ima18 * l_factor
      #CHI-CC0034 add --end--
 
      #-->外包裝重量,每箱裝數,材積
      LET l_obe12 = 0                 
      LET l_obe13 = 0                 
      LET l_obe23 = 0                
      SELECT obe12,obe13,obe22,obe23  
      #-->外包裝重量,每箱裝數,材積
        INTO l_obe12,l_obe13,l_obe22,l_obe23    
        FROM obe_file WHERE obe01=l_ogd.ogd08
 
      IF cl_null(l_obe12) THEN LET l_obe12 = 0 END IF
      IF cl_null(l_obe13) THEN LET l_obe13 = 0 END IF
      IF cl_null(l_obe22) THEN LET l_obe22 = 0 END IF
      IF cl_null(l_obe23) THEN LET l_obe23 = 0 END IF
      LET l_ogd15 = (((g_ogd[l_ac].ogd13/l_obe12)*l_obe13)+
                    (((g_ogd[l_ac].ogd13/l_obe12)/l_obe22)*l_obe23))
      SELECT obe24,obe26 INTO l_ogd.ogd09,l_ogd.ogd16
        FROM obe_file         WHERE obe01=l_ogd.ogd08
      IF STATUS THEN
         LET l_ogd15=0 LET l_ogd.ogd09=0 LET l_ogd.ogd16=0
      END IF
 
      LET l_ogd10 = l_ogb.ogb12 / l_ogd.ogd09
      LET l_ogd.ogd10=l_ogd10
      IF l_ogd10 = 0 THEN
         LET l_ogd.ogd10=1
         LET l_ogd.ogd09=l_ogb.ogb12
      END IF
 
      LET l_ogd.ogd14 = l_ogd14 * l_ogd.ogd09   #-->每箱淨重 
      LET l_ogd.ogd15 = l_ogd.ogd14 * l_ogd.ogd10            
 
      #-->起始/截止箱號
      IF l_i = 1 THEN
         LET l_ogd.ogd12b=tm.b               
      ELSE
         LET l_ogd.ogd12b=l_ogd12e_t+1               
      END IF
 
      LET l_ogd.ogd12e=l_ogd.ogd12b+l_ogd.ogd10-1                #
      #-->計算數量
      LET l_ogd.ogd13=l_ogd.ogd09*l_ogd.ogd10
      LET l_mod=l_ogb.ogb12-l_ogd.ogd13
      #-->計算總淨重,毛重,材積
    
      LET l_cnt1 = l_ogd.ogd09/l_obe12
      CALL cl_digcut(l_cnt1,1) RETURNING l_cnt2
      CALL cl_digcut(l_cnt1,0) RETURNING l_cnt1
      LET l_cnt1_1 = l_cnt1 + (l_cnt1 - l_cnt2) 
      IF l_cnt1_1 > 0 THEN LET l_cnt2 = l_cnt2 +1 END IF
      LET l_ogd.ogd14t=l_ogd.ogd14+l_obe23+(l_cnt1_1*l_obe13) 
      LET l_ogd.ogd15t=l_ogd.ogd14t*l_ogd.ogd10         
 
      LET l_ogd.ogd16t=l_ogd.ogd16*l_ogd.ogd10
      LET l_i=l_i+1
      LET l_ogd12e_t=l_ogd.ogd12e            #-->保存截止箱號
 
      LET l_ogd.ogd17='1'    #No.FUN-820046
 
      IF NOT cl_null(l_ogd.ogd01) THEN    #No.FUN-820046
         LET l_ogd.ogdplant = g_plant 
         LET l_ogd.ogdlegal = g_legal 
      INSERT INTO ogd_file VALUES(l_ogd.*)
      IF SQLCA.SQLCODE THEN
         CALL s_errmsg('','','INS-ogd #1',SQLCA.SQLCODE,1)
         LET l_success='N'
         CONTINUE FOREACH
      END IF
      END IF   #No.FUN-820046
      
      IF l_mod !=0 THEN
         LET l_ogd.ogd04=2                                 #序號
         LET l_ogd.ogd09=l_mod                             #每箱裝數
         LET l_ogd.ogd10=1                                 #箱數
         LET l_ogd.ogd12b=l_ogd.ogd12e+1                   #起始箱號 
         LET l_ogd.ogd12e=l_ogd.ogd12b                     #截止箱號 
         LET l_ogd.ogd13=l_mod                             #數量
         LET g_ogd[l_ac].ogd14=l_ogd14*g_ogd[l_ac].ogd09  #-->每箱淨重  
         LET l_ogd.ogd15=l_ogd.ogd14*l_ogd.ogd10          
         LET l_cnt1 = l_ogd.ogd09/l_obe12
         CALL cl_digcut(l_cnt1,1) RETURNING l_cnt2
         CALL cl_digcut(l_cnt1,0) RETURNING l_cnt1
         LET l_cnt1_1 = l_cnt1 + (l_cnt1 - l_cnt2) 
         IF l_cnt1_1 > 0 THEN LET l_cnt2 = l_cnt2 +1 END IF
         LET l_ogd.ogd14t=l_ogd.ogd14+l_obe23+(l_cnt1_1*l_obe13) 
         LET l_ogd.ogd15t=l_ogd.ogd14t*l_ogd.ogd10         
         LET l_ogd.ogd16t=l_ogd.ogd16*l_ogd.ogd10
         LET l_ogd12e_t=l_ogd.ogd12e
         LET l_ogd.ogd17= '1'                   #No.FUN-820046
 
         IF NOT cl_null(l_ogd.ogd01) THEN   #No.FUN-820046 mark
            LET l_ogd.ogdplant = g_plant 
            LET l_ogd.ogdlegal = g_legal 
         INSERT INTO ogd_file VALUES(l_ogd.*)
         IF SQLCA.SQLCODE THEN       
            CALL s_errmsg('','','INS-ogd #2',SQLCA.SQLCODE,1)
            LET l_success='N'
            CONTINUE FOREACH
         END IF
         END IF  #No.FUN-820046
      END IF
      END FOREACH 
    ELSE 
    	DECLARE ogb_curs_1 CURSOR WITH HOLD FOR
    	  SELECT * FROM ogb_file WHERE ogb_file.ogb01 = g_oga.oga01
    	    ORDER BY ogb_file.ogb03
        SELECT SUM(obj11*obj04) INTO l_sum FROM obj_file #No.FUN-820046
           WHERE obj01=tm.ogd08a                       #No.FUN-820046
      FOREACH ogb_curs_1 INTO l_ogb.*
      IF (l_ogb.ogb31 IS NOT NULL AND l_ogb.ogb31!=' ' AND l_ogb.ogb32 IS NOT NULL AND l_ogb.ogb32!=' ') THEN #No.FUN-820046 
        IF l_ogb.ogb931=tm.ogd08a OR l_ogb.ogb931 IS NULL THEN       #No.FUN-820046
          SELECT UNIQUE obi09,obi11,obj_file.* INTO l_obi.obi09,l_obi.obi11,l_obj.*
             FROM obj_file,obi_file
             WHERE obj_file.obj01=obi_file.obi01
             AND   obj_file.obj02=l_ogb.ogb04
             AND   obj_file.obj01=tm.ogd08a
       
         IF l_obj.obj01 IS NOT NULL THEN
            LET l_ogd.ogd01 = g_oga.oga01
            LET l_ogd.ogd03 = l_ogb.ogb03
            LET l_ogd.ogd04 = 1
            LET l_ogd.ogd08 = tm.ogd08a
            LET l_ogd.ogd09 = l_obj.obj06
            LET l_ogd10 = l_ogb.ogb12 / l_ogd.ogd09
            LET l_ogd.ogd10=l_ogd10
            IF l_ogd10 = 0 THEN
               LET l_ogd.ogd10=1
            END IF
            LET l_ogd.ogd11 = tm.a
            LET l_ogd.ogd14 = l_obj.obj06*l_obj.obj13
            LET l_ogd.ogd16 = (l_obj.obj11*l_obj.obj04/l_sum)*l_obi.obi09
            LET l_ogd.ogd15 = l_ogd.ogd14+l_obj.obj12*l_obj.obj04+l_obi.obi11*l_ogd.ogd16/l_obi.obi09
            LET l_ogd.ogd14t = l_ogd.ogd10*l_ogd.ogd14
            LET l_ogd.ogd15t = l_ogd.ogd10*l_ogd.ogd15
            LET l_ogd.ogd16t = l_ogd.ogd10*l_ogd.ogd16
            LET l_ogd.ogd17 = tm.ogd17
         END IF    
        END IF
       ELSE
           SELECT UNIQUE obi09,obi11,obj_file.* INTO l_obi.obi09,l_obi.obi11,l_obj.*
              FROM obj_file,obi_file
              WHERE obj_file.obj01=obi_file.obi01
              AND   obj_file.obj02=l_ogb.ogb04
              AND   obj_file.obj01=tm.ogd08a
 
   	     IF NOT cl_null(l_obj.obj01) THEN 
               LET l_ogd.ogd01=g_oga.oga01
               LET l_ogd.ogd03 = l_ogb.ogb03
               LET l_ogd.ogd04 = 1
               LET l_ogd.ogd08 = tm.ogd08a    
               LET l_ogd.ogd09 = l_obj.obj06  
               LET l_ogd10 = l_ogb.ogb12 / l_ogd.ogd09
               LET l_ogd.ogd10=l_ogd10
               IF l_ogd10 = 0 THEN
                  LET l_ogd.ogd10=1
               END IF
               LET l_ogd.ogd11 = tm.a
               LET l_ogd.ogd14 = l_obj.obj06*l_obj.obj13   
               LET l_ogd.ogd16 = (l_obj.obj11*l_obj.obj04/l_sum)*l_obi.obi09
               LET l_ogd.ogd15 = l_ogd.ogd14+l_obj.obj12*l_obj.obj04+l_obi.obi11*l_ogd.ogd16/l_obi.obi09
               LET l_ogd.ogd14t = l_ogd.ogd10*l_ogd.ogd14
               LET l_ogd.ogd15t = l_ogd.ogd10*l_ogd.ogd15
               LET l_ogd.ogd16t = l_ogd.ogd10*l_ogd.ogd16
               LET l_ogd.ogd17 = tm.ogd17
      	     END IF
       END IF  
 
      #-->起始/截止箱號
      IF l_i = 1 THEN
         LET l_ogd.ogd12b=tm.b               
      ELSE
         LET l_ogd.ogd12b=l_ogd12e_t+1               
      END IF
 
      LET l_ogd.ogd12e=l_ogd.ogd12b+l_ogd.ogd10-1                #
      #-->計算數量
      LET l_ogd.ogd13=l_ogd.ogd09*l_ogd.ogd10
      LET l_mod=l_ogb.ogb12-l_ogd.ogd13
      #-->計算總淨重,毛重,材積
    
      LET l_cnt1 = l_ogd.ogd09/l_obe12
      CALL cl_digcut(l_cnt1,1) RETURNING l_cnt2
      CALL cl_digcut(l_cnt1,0) RETURNING l_cnt1
      LET l_cnt1_1 = l_cnt1 + (l_cnt1 - l_cnt2) 
      IF l_cnt1_1 > 0 THEN LET l_cnt2 = l_cnt2 +1 END IF
      LET l_i=l_i+1
      LET l_ogd12e_t=l_ogd.ogd12e            #-->保存截止箱號
 
      IF NOT cl_null(l_ogd.ogd01) THEN #No.FUN-820046
         LET l_ogd.ogdplant = g_plant 
         LET l_ogd.ogdlegal = g_legal 
      INSERT INTO ogd_file VALUES(l_ogd.*)
      IF SQLCA.SQLCODE THEN
         CALL s_errmsg('','','INS-ogd #1',SQLCA.SQLCODE,1)
         LET l_success='N'
         CONTINUE FOREACH
      END IF
      END IF #No.FUN-820046
      
      IF l_mod !=0 THEN
         LET l_ogd.ogd04=2                                 #序號
         LET l_ogd.ogd09=l_mod                             #每箱裝數
         LET l_ogd.ogd10=1                                 #箱數
         LET l_ogd.ogd12b=l_ogd.ogd12e+1                   #起始箱號 
         LET l_ogd.ogd12e=l_ogd.ogd12b                     #截止箱號 
         LET l_ogd.ogd13=l_mod                             #數量
         LET g_ogd[l_ac].ogd14=l_ogd14*g_ogd[l_ac].ogd09  #-->每箱淨重  
         LET l_ogd.ogd15=l_ogd.ogd14*l_ogd.ogd10          
         LET l_cnt1 = l_ogd.ogd09/l_obe12
         CALL cl_digcut(l_cnt1,1) RETURNING l_cnt2
         CALL cl_digcut(l_cnt1,0) RETURNING l_cnt1
         LET l_cnt1_1 = l_cnt1 + (l_cnt1 - l_cnt2) 
         IF l_cnt1_1 > 0 THEN LET l_cnt2 = l_cnt2 +1 END IF
         LET l_ogd.ogd14t=l_ogd.ogd14+l_obe23+(l_cnt1_1*l_obe13) 
         LET l_ogd.ogd15t=l_ogd.ogd14t*l_ogd.ogd10         
         LET l_ogd.ogd16t=l_ogd.ogd16*l_ogd.ogd10
         LET l_ogd12e_t=l_ogd.ogd12e
 
         IF NOT cl_null(l_ogd.ogd01) THEN  #No.FUN-820046
            LET l_ogd.ogdplant = g_plant 
            LET l_ogd.ogdlegal = g_legal 
         INSERT INTO ogd_file VALUES(l_ogd.*)
         IF SQLCA.SQLCODE THEN       
            CALL s_errmsg('','','INS-ogd #2',SQLCA.SQLCODE,1)
            LET l_success='N'
            CONTINUE FOREACH
         END IF
         END IF  #No.FUN-820046
      END IF
      END FOREACH 
    END IF
    RETURN l_success  
    
END FUNCTION                   
 
 
FUNCTION t630_y() 			# when g_oga.oga30='N' (Turn to 'Y')
   DEFINE l_ogb    RECORD LIKE ogb_file.*,
          l_ogd13  LIKE ogd_file.ogd13,
          l_ogd12b LIKE ogd_file.ogd12b,   #No.MOD-570240
          l_ogd12e LIKE ogd_file.ogd12e,   #No.MOD-570240
          l_cnt    LIKE type_file.num5          #No.FUN-680137 SMALLINT
   DEFINE l_ogb12  LIKE ogb_file.ogb12     #No.TQC-7B0137
   DEFINE l_oeb12  LIKE oeb_file.oeb12     #No.TQC-7B0137
   DEFINE l_oea61   LIKE oea_file.oea61    #No:FUN-A50103
   DEFINE l_oea1008 LIKE oea_file.oea1008  #No:FUN-A50103
   DEFINE l_oea261  LIKE oea_file.oea261   #No:FUN-A50103
   DEFINE l_oea262  LIKE oea_file.oea262   #No:FUN-A50103
   DEFINE l_oea263  LIKE oea_file.oea263   #No:FUN-A50103
   DEFINE l_ogb14   LIKE ogb_file.ogb14    #MOD-BB0011 add
   DEFINE l_ogb31   LIKE ogb_file.ogb31    #MOD-BB0011 add
   DEFINE l_oga52   LIKE oga_file.oga52    #MOD-BB0011 add
   DEFINE l_oga53   LIKE oga_file.oga53    #MOD-BB0011 add
   DEFINE l_ogb16   LIKE ogb_file.ogb16    #MOD-C60148
 
#---BUGNO:7379---無單身資料不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM ogd_file
    WHERE ogd01=g_oga.oga01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
#CHI-C30107 ---------------- add --------------- begin
   IF g_oga.oga30='Y' THEN RETURN END IF
   IF NOT cl_confirm('axm-108') THEN
      RETURN
   END IF
#CHI-C30107 ---------------- add --------------- end
 
   SELECT * INTO g_oga.* FROM oga_file WHERE oga01 = g_oga.oga01
   IF g_oga.oga30='Y' THEN RETURN END IF
 
   BEGIN WORK
 
   OPEN t630_cl USING g_oga.oga01
   


   IF STATUS THEN
      CALL cl_err("OPEN t630_cl:", STATUS, 1)
      CLOSE t630_cl
      ROLLBACK WORK
      RETURN
   END IF
 
  

  FETCH t630_cl INTO g_oga.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_oga.oga01,SQLCA.sqlcode,1)     # 資料被他人LOCK
      CLOSE t630_cl 
      ROLLBACK WORK 
      RETURN
   END IF
 
 


#CHI-C30107 ---------------- mark -------------------- begin
# IF NOT cl_confirm('axm-108') THEN
#    ROLLBACK WORK 
#    RETURN 
# END IF
#CHI-C30107 ---------------- mark -------------------- end
 
   LET g_success = 'Y'
   UPDATE oga_file SET oga30 = 'Y' WHERE oga01 = g_oga.oga01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","oga_file",g_oga.oga01,"",SQLCA.SQLCODE,"","upd oga30",1)  #No.FUN-660167
      LET g_success = 'N'
      ROLLBACK WORK #MOD-C10029 
      RETURN
   ELSE
      IF cl_confirm('axm-915') THEN
         SELECT MIN(ogd12b),MAX(ogd12e) INTO l_ogd12b,l_ogd12e FROM ogd_file
          WHERE ogd01 = g_oga.oga01
 
         UPDATE ofa_file
            SET ofa45= l_ogd12b,
                ofa46= l_ogd12e
          WHERE ofa011=g_oga.oga01
      END IF
   END IF
   IF g_success = 'Y' AND g_oaz.oaz22 = 'Y' THEN   #-->更新出貨數量
      IF g_oga.ogapost ='Y' THEN
         CALL cl_err('','axm-798',1)
         ROLLBACK WORK #MOD-C10029 
         RETURN
      END IF
      DECLARE ogb12_curs CURSOR FOR SELECT * FROM ogb_file
                                     WHERE ogb01=g_oga.oga01 ORDER BY ogb03
      CALL s_showmsg_init()   #No.FUN-710046
      FOREACH ogb12_curs INTO l_ogb.*
          LET l_ogd13=0
 
# if 出貨單exist then update ogb12=ogd13 Modify by WUPN 96-05-14
          IF STATUS THEN CALL s_errmsg('','','foreach',STATUS,1) EXIT FOREACH END IF
          IF g_success='N' THEN                                                                                                        
             LET g_totsuccess='N'                                                                                                      
             LET g_success="Y"                                                                                                         
          END IF                    
          SELECT SUM(ogd13) INTO l_ogd13 FROM ogd_file # 包裝單產品數量
           WHERE ogd01=l_ogb.ogb01 AND ogd03=l_ogb.ogb03
             AND ogd13 IS NOT NULL
          IF STATUS OR l_ogd13 is null
             THEN CONTINUE FOREACH
          ELSE   #
 
#重計金額
             LET l_ogb.ogb917 = l_ogd13
             IF g_oga.oga213 = 'N' THEN
                LET l_ogb.ogb14 =l_ogb.ogb917*l_ogb.ogb13
                LET l_ogb.ogb14t=l_ogb.ogb14*(1+g_oga.oga211/100)
             ELSE
                LET l_ogb.ogb14t=l_ogb.ogb917*l_ogb.ogb13 
                LET l_ogb.ogb14 =l_ogb.ogb14t/(1+g_oga.oga211/100)
             END IF
   
             SELECT azi04 INTO t_azi04 FROM azi_file
              WHERE azi01=g_oga.oga23
             IF cl_null(t_azi04) THEN
                LET t_azi04 = 1
             END IF 
             CALL cl_digcut(l_ogb.ogb14,t_azi04) RETURNING l_ogb.ogb14
             CALL cl_digcut(l_ogb.ogb14t,t_azi04)RETURNING l_ogb.ogb14t
 
             IF l_ogb.ogb12 <l_ogd13 THEN
                CALL cl_err(l_ogd13,'axm-797',1)
                LET g_success ='N'
                EXIT FOREACH
             END IF   
             #MOD-C60148 add ---begin---
             IF l_ogb.ogb05 = l_ogb.ogb15 THEN   #抓取销售单位与库存单位的转换率
                LET l_ogb.ogb15_fac =1
             ELSE
                #檢查該發料單位與主檔之單位是否可以轉換
                CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_ogb.ogb15)
                          RETURNING g_cnt,l_ogb.ogb15_fac
                IF g_cnt = 1 THEN
                   CALL cl_err('','mfg3075',1)
                END IF
             END IF
             LET l_ogb16 = l_ogd13*l_ogb.ogb15_fac 
             #MOD-C60148 add ---end---
             UPDATE ogb_file SET ogb12=l_ogd13,          #CHI-840010-modify
                                 ogb917=l_ogb.ogb917,    #CHI-840010-add
                                 ogb14=l_ogb.ogb14,      #CHI-840010-add
                                 ogb14t=l_ogb.ogb14t,     #CHI-840010-add
                                 ogb16=l_ogb16          #MOD-C60148 add
              WHERE ogb01=l_ogb.ogb01 
                AND ogb03=l_ogb.ogb03
             IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
                LET g_showmsg = l_ogb.ogb01,"/",l_ogb.ogb03
                CALL s_errmsg('ogb01,ogb03',g_showmsg,'upd ogb12',SQLCA.SQLCODE,1)
                LET g_success = 'N'
                CONTINUE FOREACH
             END IF
          END IF
      END FOREACH
 
#重新計算單頭金額
      SELECT SUM(ogb14),SUM(ogb14t) INTO g_oga.oga50,g_oga.oga51 FROM ogb_file 
       WHERE ogb01 = g_oga.oga01
      IF cl_null(g_oga.oga50) THEN LET g_oga.oga50 = 0 END IF
      IF cl_null(g_oga.oga51) THEN LET g_oga.oga51 = 0 END IF

      IF g_oga.oga09 <> '3' THEN    #FUN-C80033 add
         IF NOT cl_null(g_oga.oga16) THEN   #MOD-BB0011 add   
            #-----No:FUN-A50103-----
            SELECT oea61,oea1008,oea261,oea262,oea263
              INTO l_oea61,l_oea1008,l_oea261,l_oea262,l_oea263
              FROM oea_file
             WHERE oea01 = g_oga.oga16
            IF g_oga.oga213 = 'Y' THEN
               LET g_oga.oga52 = g_oga.oga50 * l_oea261 / l_oea1008
               LET g_oga.oga53 = g_oga.oga50 * (l_oea262+l_oea263) / l_oea1008
            ELSE
               LET g_oga.oga52 = g_oga.oga50 * l_oea261 / l_oea61
               LET g_oga.oga53 = g_oga.oga50 * (l_oea262+l_oea263) / l_oea61
            END IF
           #LET g_oga.oga52 = g_oga.oga50 * g_oga.oga161/100
           #LET g_oga.oga53 = g_oga.oga50 * (g_oga.oga162+g_oga.oga163)/100
           #-----No:FUN-A50103 END-----
         #MOD-BB0011 ----- start -----
         ELSE
            LET l_oga52 = 0
            LET l_oga53 = 0
            DECLARE oga_upd CURSOR FOR SELECT ogb14,ogb31 FROM ogb_file WHERE ogb01=g_oga.oga01 ORDER BY ogb03
            FOREACH oga_upd INTO l_ogb14,l_ogb31
               IF NOT cl_null(l_ogb31) THEN
                  SELECT oea61,oea1008,oea261,oea262,oea263
                    INTO l_oea61,l_oea1008,l_oea261,l_oea262,l_oea263
                    FROM oea_file
                   WHERE oea01 = l_ogb31
                  IF g_oga.oga213 = 'Y' THEN
                     LET l_oga52 = l_oga52 + l_ogb14 * l_oea261 / l_oea1008
                     LET l_oga53 = l_oga53 + l_ogb14 * (l_oea262+l_oea263) / l_oea1008
                  ELSE
                     LET l_oga52 = l_oga52 + l_ogb14 * l_oea261 / l_oea61
                     LET l_oga53 = l_oga53 + l_ogb14 * (l_oea262+l_oea263) / l_oea61
                  END IF
               END IF
            END FOREACH
            LET g_oga.oga52 = l_oga52
            LET g_oga.oga53 = l_oga53
         END IF
         #MOD-BB0011 -----  end  -----
         UPDATE oga_file SET oga50=g_oga.oga50,
                             oga51=g_oga.oga51,
                             oga52=g_oga.oga52,
                             oga53=g_oga.oga53
          WHERE oga01 = g_oga.oga01
      #FUN-C80033 add begin---
      ELSE                                      
         UPDATE oga_file SET oga50=g_oga.oga50, 
                             oga51=g_oga.oga51  
          WHERE oga01 = g_oga.oga01             
      END IF  
      #FUN-C80033 add end-----

      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","oga_file",g_oga.oga01,"",SQLCA.SQLCODE,"","upd oga30",1)  #No.FUN-660167
         LET g_success = 'N'
      END IF 
 
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
 
   END IF
   CLOSE t630_cl
   CALL s_showmsg()      #No.FUN-710046
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_oga.oga30='Y'
      DISPLAY BY NAME g_oga.oga30
   ELSE
      LET g_oga.oga30='N' 
      ROLLBACK WORK
   END IF
   #CKP
   CALL cl_set_field_pic(g_oga.oga30,"","","","","")
END FUNCTION
 
FUNCTION t630_z() 			# when g_oga.oga30='Y' (Turn to 'N')
   SELECT * INTO g_oga.* FROM oga_file WHERE oga01 = g_oga.oga01
   IF g_oga.oga30='N' THEN RETURN END IF
   IF g_oga.ogapost ='Y' THEN
      CALL cl_err('','axm-799',1)
      RETURN
   END IF
 
   IF g_oaz.oaz67='1'  AND g_oaz.oaz22='Y'  THEN 
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM oga_file 
       WHERE oga011 = g_oga.oga01      
      IF g_cnt > 0 THEN 
         CALL cl_err('','axm-228',1)
         RETURN
      END IF 
   END IF 

 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
   BEGIN WORK
 
   OPEN t630_cl USING g_oga.oga01
   IF STATUS THEN
      CALL cl_err("OPEN t630_cl:", STATUS, 1)
      CLOSE t630_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t630_cl INTO g_oga.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_oga.oga01,SQLCA.sqlcode,1)     # 資料被他人LOCK
      CLOSE t630_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   LET g_success = 'Y'
   UPDATE oga_file SET oga30 = 'N' WHERE oga01 = g_oga.oga01
  


   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err3("upd","oga_file",g_oga.oga01,"",SQLCA.SQLCODE,"","upd oga",1)  #No.FUN-660167
      LET g_success = 'N'
   END IF
   CLOSE t630_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_oga.oga30='N'
      DISPLAY BY NAME g_oga.oga30
   ELSE
      LET g_oga.oga30='Y'
      ROLLBACK WORK
   END IF
   #CKP
   CALL cl_set_field_pic(g_oga.oga30,"","","","","")
END FUNCTION
 
FUNCTION t630_b_move_to()
   LET g_ogd[l_ac].ogd03  = b_ogd.ogd03
   LET g_ogd[l_ac].ogd04  = b_ogd.ogd04
   LET g_ogd[l_ac].ogd08  = b_ogd.ogd08
   LET g_ogd[l_ac].ogd09  = b_ogd.ogd09
   LET g_ogd[l_ac].ogd10  = b_ogd.ogd10
   LET g_ogd[l_ac].ogd11  = b_ogd.ogd11
   LET g_ogd[l_ac].ogd12b = b_ogd.ogd12b
   LET g_ogd[l_ac].ogd12e = b_ogd.ogd12e
   LET g_ogd[l_ac].ogd13  = b_ogd.ogd13
   LET g_ogd[l_ac].ogd14  = b_ogd.ogd14
   LET g_ogd[l_ac].ogd14t = b_ogd.ogd14t
   LET g_ogd[l_ac].ogd15  = b_ogd.ogd15
   LET g_ogd[l_ac].ogd15t = b_ogd.ogd15t
   LET g_ogd[l_ac].ogd16  = b_ogd.ogd16
   LET g_ogd[l_ac].ogd16t = b_ogd.ogd16t
   LET b_ogd.ogd17  = g_ogd[l_ac].ogd17
   LET g_ogd[l_ac].ogdud01 = b_ogd.ogdud01
   LET g_ogd[l_ac].ogdud02 = b_ogd.ogdud02
   LET g_ogd[l_ac].ogdud03 = b_ogd.ogdud03
   LET g_ogd[l_ac].ogdud04 = b_ogd.ogdud04
   LET g_ogd[l_ac].ogdud05 = b_ogd.ogdud05
   LET g_ogd[l_ac].ogdud06 = b_ogd.ogdud06
   LET g_ogd[l_ac].ogdud07 = b_ogd.ogdud07
   LET g_ogd[l_ac].ogdud08 = b_ogd.ogdud08
   LET g_ogd[l_ac].ogdud09 = b_ogd.ogdud09
   LET g_ogd[l_ac].ogdud10 = b_ogd.ogdud10
   LET g_ogd[l_ac].ogdud11 = b_ogd.ogdud11
   LET g_ogd[l_ac].ogdud12 = b_ogd.ogdud12
   LET g_ogd[l_ac].ogdud13 = b_ogd.ogdud13
   LET g_ogd[l_ac].ogdud14 = b_ogd.ogdud14
   LET g_ogd[l_ac].ogdud15 = b_ogd.ogdud15
END FUNCTION
 
FUNCTION t630_b_move_back()
   LET b_ogd.ogd01  = g_oga.oga01
   LET b_ogd.ogd03  = g_ogd[l_ac].ogd03  
   LET b_ogd.ogd04  = g_ogd[l_ac].ogd04  
   LET b_ogd.ogd08  = g_ogd[l_ac].ogd08  
   LET b_ogd.ogd09  = g_ogd[l_ac].ogd09  
   LET b_ogd.ogd10  = g_ogd[l_ac].ogd10  
   LET b_ogd.ogd11  = g_ogd[l_ac].ogd11  
   LET b_ogd.ogd12b = g_ogd[l_ac].ogd12b 
   LET b_ogd.ogd12e = g_ogd[l_ac].ogd12e 
   LET b_ogd.ogd13  = g_ogd[l_ac].ogd13  
   LET b_ogd.ogd14  = g_ogd[l_ac].ogd14  
   LET b_ogd.ogd14t = g_ogd[l_ac].ogd14t 
   LET b_ogd.ogd15  = g_ogd[l_ac].ogd15  
   LET b_ogd.ogd15t = g_ogd[l_ac].ogd15t 
   LET b_ogd.ogd16  = g_ogd[l_ac].ogd16  
   LET b_ogd.ogd16t = g_ogd[l_ac].ogd16t
   LET b_ogd.ogd17  = g_ogd[l_ac].ogd17
   LET b_ogd.ogdud01 = g_ogd[l_ac].ogdud01
   LET b_ogd.ogdud02 = g_ogd[l_ac].ogdud02
   LET b_ogd.ogdud03 = g_ogd[l_ac].ogdud03
   LET b_ogd.ogdud04 = g_ogd[l_ac].ogdud04
   LET b_ogd.ogdud05 = g_ogd[l_ac].ogdud05
   LET b_ogd.ogdud06 = g_ogd[l_ac].ogdud06
   LET b_ogd.ogdud07 = g_ogd[l_ac].ogdud07
   LET b_ogd.ogdud08 = g_ogd[l_ac].ogdud08
   LET b_ogd.ogdud09 = g_ogd[l_ac].ogdud09
   LET b_ogd.ogdud10 = g_ogd[l_ac].ogdud10
   LET b_ogd.ogdud11 = g_ogd[l_ac].ogdud11
   LET b_ogd.ogdud12 = g_ogd[l_ac].ogdud12
   LET b_ogd.ogdud13 = g_ogd[l_ac].ogdud13
   LET b_ogd.ogdud14 = g_ogd[l_ac].ogdud14
   LET b_ogd.ogdud15 = g_ogd[l_ac].ogdud15
 
   LET b_ogd.ogdplant = g_plant 
   LET b_ogd.ogdlegal = g_legal 
 
END FUNCTION

#FUN-CB0014---add---str---
FUNCTION t630_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oga_l TO s_oga_l.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL fgl_set_arr_curr(g_curs_index)
 
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         LET g_curs_index = l_ac1
         CALL cl_show_fld_cont() 
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION main
         LET g_action_flag = 'main'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET mi_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             CALL t630_fetch('/')
         END IF
         CALL cl_set_comp_visible("page_in", FALSE)
         CALL cl_set_comp_visible("info", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page_in", TRUE)
         CALL cl_set_comp_visible("info", TRUE)
         EXIT DISPLAY

      ON ACTION ACCEPT
         LET g_action_flag = 'main'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET mi_no_ask = TRUE
         CALL t630_fetch('/')
         CALL cl_set_comp_visible("info", FALSE)
         CALL cl_set_comp_visible("info", TRUE)
         CALL cl_set_comp_visible("page_in", FALSE) 
         CALL ui.interface.refresh()                 
         CALL cl_set_comp_visible("page_in", TRUE)    
         EXIT DISPLAY
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t630_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)    
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)  
         END IF
         CONTINUE DISPLAY                    
 
      ON ACTION previous
         CALL t630_feTch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)  
         END IF
	     CONTINUE DISPLAY                   
 
      ON ACTION jump
         CALL t630_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)  
         END IF
	     CONTINUE DISPLAY                  
 
      ON ACTION next
         CALL t630_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)  
         END IF
	     CONTINUE DISPLAY                  
 
      ON ACTION last
         CALL t630_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)  
         END IF
	     CONTINUE DISPLAY                
         
      #TQC-D10084--mark--str-- 
      #ON ACTION detail
      #   LET g_action_choice="detail"
      #   LET l_ac = 1
      #   EXIT DISPLAY
      #TQC-D10084--mark--end--
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                  
         CALL cl_set_field_pic(g_oga.oga30,"","","","","")
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
#@    ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
#@    ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
 
#@    ON ACTION "Packing List列印"
      ON ACTION print_packing_list
         LET g_action_choice="print_packing_list"
         EXIT DISPLAY
 
      ON ACTION controls                             
         CALL cl_set_head_visible("","AUTO")         

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
 
      ON ACTION related_document                #相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t630_list_fill()
  DEFINE l_oga01         LIKE oga_file.oga01
  DEFINE l_i             LIKE type_file.num10
  DEFINE l_slip          LIKE aba_file.aba00 

    CALL g_oga_l.clear()
    LET l_i = 1
    FOREACH t630_fill_cs INTO l_oga01
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT oga01,'',oga02,oga16,oga03,oga032,oga14,gen02,
              oga15,gem02,oga30
         INTO g_oga_l[l_i].*
         FROM oga_file
              LEFT OUTER JOIN gen_file ON oga14 = gen01
              LEFT OUTER JOIN gem_file ON oga15 = gem01
        WHERE oga01=l_oga01
       LET l_slip=s_get_doc_no(g_oga_l[l_i].oga01_l) 
       SELECT oaydesc INTO g_oga_l[l_i].oaydesc_l FROM oay_file WHERE oayslip=l_slip        
       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          IF g_action_choice ="query"  THEN  
            CALL cl_err( '', 9035, 0 )
          END IF                             
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_rec_b1 = l_i - 1
    DISPLAY ARRAY g_oga_l TO s_oga_l.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY

END FUNCTION
#FUN-CB0014---add---end---

#CHI-CC0034 add --start--
FUNCTION cnt_box(p_ogd09,p_obe12)
DEFINE p_ogd09    LIKE ogd_file.ogd09 
DEFINE p_obe12    LIKE obe_file.obe12 
DEFINE l_cnt1     LIKE type_file.num20_6
DEFINE l_cnt2     LIKE type_file.num10

  LET l_cnt1 = 0
  LET l_cnt2 = 0

  LET l_cnt1 = p_ogd09/p_obe12   #整數的箱數
  LET l_cnt2=p_ogd09/p_obe12     #算到小數位的箱數
  IF l_cnt1-l_cnt2 >0 THEN LET l_cnt2=l_cnt2+1 END IF

  RETURN l_cnt2
END FUNCTION
#CHI-CC0034 add --end--

#str----add by guanyao160708
FUNCTION t630_ins(p_ogd01,p_ogd03,p_ogb04)
DEFINE p_ogd01       LIKE ogd_file.ogd01
DEFINE p_ogd03       LIKE ogd_file.ogd03
DEFINE p_ogb04       LIKE ogb_file.ogb04
DEFINE p_imaud08     LIKE ima_file.imaud08
DEFINE l_ogd         RECORD LIKE ogd_file.*
DEFINE l_tc_ogd      RECORD LIKE tc_ogd_file.*
DEFINE l_i           LIKE type_file.num5 
DEFINE l_sql         STRING 
DEFINE l_sql1        STRING
DEFINE l_x           LIKE type_file.num5
DEFINE  l_tmp      RECORD
        ogb03       LIKE ogb_file.ogb03,
        ogb12       LIKE ogb_file.ogb12,
        ogb092      LIKE ogb_file.ogb092,
        ogb12_1     LIKE ogb_file.ogb12,
        l_a         LIKE type_file.chr1,
        ogb01       LIKE ogb_file.ogb01,
        ogb03_1     LIKE ogb_file.ogb03,
        ogb03_2     LIKE ogb_file.ogb03,
        ogd12b      LIKE ogd_file.ogd12b
        END RECORD 

    CALL t630_table()
    INITIALIZE l_ogd.* TO NULL
    INITIALIZE l_tc_ogd.* TO NULL
    DELETE FROM t630_tmp
    SELECT * INTO l_ogd.* FROM ogd_file WHERE ogd01 = p_ogd01 AND ogd03 = p_ogd03 AND ogd04 = '1'
    LET l_sql1 = " SELECT ogb03,ogb12,ogb092,0,'N','','',0,'' FROM ogb_file WHERE ogb01='",p_ogd01,"'",
                "    AND ogb04 ='",p_ogb04,"'",
                "  ORDER BY ogb03"
    LET l_sql = "INSERT INTO t630_tmp ",l_sql1 CLIPPED 
    PREPARE q001_ins FROM l_sql
    EXECUTE q001_ins
    LET l_x  = 0
    SELECT COUNT(*) INTO l_x FROM t630_tmp
    IF cl_null(l_x) OR l_x = 0 THEN 
       CALL cl_err('','cxm-010',0)
       RETURN 'N'
    END IF 
    FOR l_i = 1 TO l_ogd.ogd10 
       LET l_tc_ogd.tc_ogd01 = l_ogd.ogd01
       LET l_tc_ogd.tc_ogd02 = l_ogd.ogd03
       LET l_tc_ogd.tc_ogd03 = l_i
       LET l_tc_ogd.tc_ogd04 = p_ogb04
       SELECT ogb11,ogbud03 INTO l_tc_ogd.tc_ogd05,l_tc_ogd.tc_ogd06 FROM ogb_file WHERE ogb01 =p_ogd01 AND ogb04 =p_ogb04
       LET l_tc_ogd.tc_ogd07 = l_ogd.ogd10
       LET l_tc_ogd.tc_ogd08 = l_ogd.ogd12b+l_i-1
       IF l_ogd.ogd10 = l_i THEN 
          IF l_ogd.ogdud10!=0 THEN 
             LET l_tc_ogd.tc_ogd09 = l_ogd.ogdud10
          ELSE 
             LET l_tc_ogd.tc_ogd09 = l_ogd.ogd09
          END IF 
       ELSE 
          LET l_tc_ogd.tc_ogd09 = l_ogd.ogd09
       END IF 
       SELECT oga02 INTO l_tc_ogd.tc_ogd11 FROM oga_file WHERE oga01 = p_ogd01 
       DECLARE t630_tmp CURSOR FOR SELECT * FROM t630_tmp WHERE l_a = 'N'
       INITIALIZE l_tmp.* TO NULL
       FOREACH t630_tmp INTO l_tmp.*
          LET l_tmp.ogb12 = l_tmp.ogb12-l_tmp.ogb12_1       
          IF l_tmp.ogb12<l_ogd.ogd09 THEN 
             UPDATE t630_tmp SET l_a = 'Y',ogb01= l_ogd.ogd01,ogb03_1=l_ogd.ogd03,ogb03_2= l_i,ogb12_1= l_tmp.ogb12,
                                ogd12b = l_tc_ogd.tc_ogd08
                           WHERE ogb03 = l_tmp.ogb03
             IF SQLCA.SQLCODE THEN
                CALL s_errmsg('','','UPD-t630_tmp #1',SQLCA.SQLCODE,1)
                RETURN 'N'
             END IF
             CONTINUE FOREACH 
          ELSE 
             IF l_tmp.ogb12=l_ogd.ogd09 THEN
                UPDATE t630_tmp SET l_a = 'Y',ogb01= l_ogd.ogd01,ogb03_1=l_ogd.ogd03,ogb03_2= l_i,ogb12_1= l_tmp.ogb12,
                                    ogd12b = l_tc_ogd.tc_ogd08
                           WHERE ogb03 = l_tmp.ogb03
                IF SQLCA.SQLCODE THEN
                   CALL s_errmsg('','','UPD-t630_tmp #1',SQLCA.SQLCODE,1)
                   RETURN 'N'
                END IF
             ELSE 
                UPDATE t630_tmp SET ogb01= l_ogd.ogd01,ogb03_1=l_ogd.ogd03,ogb03_2= l_i,ogb12_1= (l_ogd.ogd09+ogb12_1),
                                    ogd12b = l_tc_ogd.tc_ogd08
                           WHERE ogb03 = l_tmp.ogb03
                IF SQLCA.SQLCODE THEN
                   CALL s_errmsg('','','UPD-t630_tmp #1',SQLCA.SQLCODE,1)
                   RETURN 'N'
                END IF  
             END IF 
             EXIT FOREACH 
          END IF 
       END FOREACH 
       SELECT MAX(ogb092) INTO l_tc_ogd.tc_ogd10 FROM t630_tmp
        WHERE ogb01= l_ogd.ogd01 
          AND ogb03_1=l_ogd.ogd03 
          AND ogb03_2= l_i
          AND ogd12b = l_tc_ogd.tc_ogd08
          AND ogb12_1 = 
          (SELECT MAX(ogb12_1) FROM  t630_tmp WHERE ogb01= l_ogd.ogd01 AND ogb03_1=l_ogd.ogd03 AND ogb03_2= l_i AND ogd12b = l_tc_ogd.tc_ogd08)
       LET l_tc_ogd.tc_ogdplant= g_plant
       LET l_tc_ogd.tc_ogdlegal= g_legal
       INSERT INTO tc_ogd_file VALUES(l_tc_ogd.*)
       IF SQLCA.SQLCODE THEN
          CALL s_errmsg('','','INS-tc_ogd #1',SQLCA.SQLCODE,1)
          RETURN 'N'
       END IF     
    END FOR 

    RETURN 'Y'
    
END FUNCTION 

FUNCTION t630_table()
   DROP TABLE t630_tmp;
   CREATE TEMP TABLE t630_tmp(
                ogb03       LIKE ogb_file.ogb03,
                ogb12       LIKE ogb_file.ogb12,
                ogb092      LIKE ogb_file.ogb092,
                ogb12_1     LIKE ogb_file.ogb12,
                l_a         LIKE type_file.chr1,
                ogb01       LIKE ogb_file.ogb01,
                ogb03_1     LIKE ogb_file.ogb03,
                ogb03_2     LIKE ogb_file.ogb03,
                ogd12b      LIKE ogd_file.ogd12b)
END FUNCTION 
#end----add by guanyao160708
