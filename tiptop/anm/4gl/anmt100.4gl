# Prog. Version..: '5.30.06-13.04.19(00010)'     #
#
# Pattern name...: anmt100.4gl
# Descriptions...: 應付票據開票作業
# Date & Author..: 92/05/01 BY MAY
# Modify.........: 96/06/17 By Lynn MENU BAR 增加一選項 T.異動記錄查詢(anmq102)
#                : 96/06/26 By Lynn call anmq102 傳參數(開票單號 nmd01)
#                : By Lynn 如票況(nmd12)不為開立,則不可取消確認
# Modify.........: 97/05/21 By Danny  確認時判斷,若不為套印支票,票號不可空白
# Modify.........: 99/07/20 By Carol  非支存不可輸入
# Modify.........: 01/06/27 By Thomas 新增支票作廢功能
# Modify.........: No:8449 03/11/14 Kitty nmd04,nmd26 per的format拿掉,程式中再取位
# Modify.........: No:9042 04/01/09 Kammy Returning nmd26 應改為 nmd04
# Modify.........: No.MOD-480246 04/08/11 Kammy 調整功能的欄位無 CONTROLP
# Modify.........: No.MOD-4A0252 04/10/20 By Smapmin 開票單號開窗功能
# Modify.........: No.FUN-4B0052 04/11/24 By Nicola 加入"匯率計算"功能
# Modify.........: No.MOD-4B0281 04/12/07 By Nicola 新增應付票據資料,存入資料後會出現是列印支票畫面,當回'Y'時,印出來的資料是空白的
# Modify.........: No.FUN-4C0063 04/12/09 By Nicola 權限控管修改
# Modify.........: No.FUN-4C0098 05/01/11 By pengu 報表轉XML
# Modify.........: No.MOD-510041 05/03/09 By kitty 付款銀行種類放到簿號之後判斷
# Modify.........: No.MOD-510076 05/03/21 By kitty 配合anmt710之應付票據維護點了出不來資料,接收參數增加一個
# Modify.........: No.MOD-530818 05/04/04 By Nicola 開票資料刪除後，需將aapt711開票單資料欄位清除
# Modify.........: No.FUN-550057 05/05/27 By jackie 單據編號加大
# Modify.........: No.MOD-560250 05/08/02 By Dido 票況='X'自動產生時, 幣別/匯率/原幣金額/本幣金額/廠商/付款單號/營運中心 不可修改
# Modify.........: No.FUN-590125 05/09/29 By Smapmin 廠商收件者開窗僅秀出該廠商對應的聯絡人
# Modify.........: No.MOD-5A0201 05/10/20 By Smapmin 組成sql邏輯有問題
# Modify.........: No.MOD-5A0390 05/10/27 By Smapmin 銀行簡稱顯示有誤
# Modify.........: No.MOD-5B0249 05/11/22 By Nicola 付款銀行只能為支存
# Modify.........: No.FUN-5B0109 05/11/23 By kim 報表調整
# Modify.........: No.MOD-5B0335 05/12/01 By Smapmin 簿號為空時,支票號碼不可輸入
# Modify.........: No.TQC-5B0200 06/01/05 BY yiting Q出資料後,按"工廠切換"-->"放棄"--->列印  會發生無法列印的現象
# Modify.........: No.FUN-630020 06/03/07 By pengu 流程訊息通知功能
# Modify.........: No.FUN-630010 06/03/08 By saki aapt330因流程訊息更動參數位置
# Modify.........: No.MOD-640311 06/04/10 By Smapmin 確認時判斷,重要欄位不可空白
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-570146 06/06/26 By rainy 新增Action"修改寄領方式"
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.MOD-660086 06/07/05 By Sarah 查詢一筆未確認的單號後按新增再放棄,再按作廢,之前查詢的那筆會被作廢掉
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-680034 06/08/17 By flowld 兩套帳修改及alter table -- ANM模塊,前端基礎數據,融資
# Modify.........: No.FUN-680107 06/09/08 By Hellen 欄位類型修改
# Modify.........: No.FUN-690024 06/09/19 By jamie 判斷pmcacti
# Modify.........: No.FUN-6A0011 06/10/04 By jamie 1.FUNCTION t100_fetch() 一開始應清空g_nmd.*值
#                                                  2.新增action"相關文件"
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6A0110 06/11/09 By johnray 報表修改
# Modify.........: No.FUN-6B0070 06/11/22 By Smapmin 顯示票別說明
# Modify.........: No.MOD-680106 06/11/30 By Smapmin 修正票號是否空白等判斷
# Modify.........: No.TQC-6C0037 06/12/12 By chenl   1、將原先支票打印從輸入完成詢問打印否搬至審核后詢問是否打印。
# Modify.........:                                   2、若打印程序為anmr185，則抓取參數npx01。
# Modify.........: No.FUN-710024 07/01/25 By Jackho 增加批處理錯誤統整功能
# Modify.........: No.FUN-6C0051 07/02/14 By rainy 新增傳tm.wc參數
# Modify.........: No.FUN-740028 07/04/10 By arman    會計科目加帳套
# Modify.........: No.TQC-740058 07/04/12 By Judy 1.資料作廢仍可點選"修改寄領方式"修改資料
#                                                 2.資料已審核,仍可以審核
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770062 07/07/11 By wujie   點擊打印按鈕,報表中顯示的打印條件在"合計"的上一行
# Modify.........: No.TQC-7B0104 07/11/16 By chenl   修正廠商編號欄位關閉后再新增資料無法開啟的問題。
# Modify.........: No.MOD-7C0037 07/12/05 By Smapmin 將營運中心切換納入權限控管
# Modify.........: No.MOD-810002 08/01/08 By Smapmin 修改以anmr185列印時傳遞的參數
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-820172 08/02/27 By Smapmin 由預購單產生的開票資料,支票作廢時要回寫預購單的支票號碼
# Modify.........: No.FUN-830149 08/03/31 By zhaijie 報表輸出改為CR
# Modify.........: No.MOD-840176 08/04/20 By Sarah CALL t100_lock_cur()的位置放錯，導致按U修改時會出現t100_cl的錯誤訊息
# Modify.........: No.FUN-850038 08/05/13 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.CHI-850007 08/05/19 By Sarah 1.當付款單+項次(nmd10+nmd101)新增或更改時SET aph09='Y'
#                                                  2.當支票作廢時需SET aph09='N'
#                                                  3.輸入付款單+項次(nmd10+nmd101)需檢查存不存在付款單中
# Modify.........: No.CHI-850010 08/05/21 By Sarah 當apf00='16'時,串t110_w()去開啟直接付款的畫面,若apf00!='16',則還是串aapt330
# Modify.........: No.MOD-870008 08/07/08 By Sarah 新增時需檢查輸入單號是否正確
# Modify.........: No.TQC-890020 08/10/20 By Sarah 付款單號(nmd10,nmd101)的來源有aapt330,anmt710,anmt720,檢查資料存在否應三個來源都要檢查,回寫aph09前需先檢查來源是否為aapt330才回寫
# Modify.........: No.MOD-910110 09/01/14 By Sarah 當支票作廢時不需SET aph09='N',因為此開票資料還是維持有效的,改成'N'反而造成anmp500還可以再重複產生的問題
# Modify.........: No.MOD-920116 09/02/07 By Smapmin 存在電腦開立支票,不可取消確認,必須先將支票作廢.
# Modify.........: No.MOD-930167 09/03/16 By lilingyu 輸入幣別時,應檢查是否存在于azi_file中
# Modify.........: No.FUN-930104 09/03/23 By dxfwo   理由碼的分類改善
# Modify.........: No.MOD-940221 09/04/16 By lilingyu 新增/修改完資料時，未檢查付款單號nmd10+項次nmd101是否已重復
# Modify.........: No.MOD-940357 09/04/28 By lilingyu 判斷g_nna06值前,重抓一次nna06的值
# Modify.........: No.MOD-950220 09/05/21 By lilingyu 未排除自己本身的單據
# Modify.........: No.TQC-960177 09/06/16 By xiaofeizhu 為"一般資料"頁簽中的“付款單號”及"付款單營運中心"欄位增加開窗
# Modify.........: No.FUN-960141 09/06/23 By dongbg GP5.2修改:增加nmd40欄位
# Modify.........: No.MOD-960327 09/06/26 By mike 目前回抓付款單號有沒有存在aapt330時，條件要放大 
# Modify.........: No.MOD-970138 09/07/16 By mike 應跨DB檢核付款單是否存在     
# Modify.........: No.TQC-970332 09/07/29 By Carrier 支票簿號nmd31開窗
# Modify.........: No.FUN-980005 09/08/19 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-980101 09/08/24 By mike 輸入完nmd10+nmd101后,會檢查來源是否來自aapt330,先判斷nmz05(付款單要拋轉傳票才可產>
#                                                 當nmz05='Y'時,需增加判斷該付款單是否已拋傳票,                                     
#                                                 當nmz05!='Y'時,維持原先的檢查方法,只看資料有沒有存在aph_file即可                  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-970294 09/09/03 By sabrina 打完付款單號時需檢查〝幣別/原幣金額/本幣金額/付款對象/匯率〞這幾個欄位
#                                                    如果這些欄位與付款單不同時，要提示是否"更新成付款單號的值"
# Modify.........: No.FUN-990069 09/09/23 By baofei GP集團架構修改,sub相關參數
# Modify.........: No.FUN-980025 09/09/23 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.FUN-990031 09/10/21 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下
# Modify.........: No.MOD-9C0242 09/12/21 By sabrina 串anmr185時要多傳八個參數，否則無法列印 
# Modify.........: No:MOD-A10047 10/01/08 By Sarah 列印時傳遞參數的修正
# Modify.........: No.FUN-9C0073 10/01/15 By chenls 程序精簡
# Modify.........: No:MOD-A10111 10/01/18 By Sarah nmd04應改用t_azi04取位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A40054 10/04/23 By shiwuying 移除nmd34
# Modify.........: No:FUN-A40076 10/07/02 By xiaofeizhu 更改ooa37的默認值，如果是Y改為2，N改為1 
# Modify.........: No:TQC-A60109 10/07/06 By Carrier oriu/orig construct
# Modify.........: No:MOD-A70045 10/07/06 By Dido 傳遞 anmr185 參數有誤 
# Modify.........: No.FUN-A50102 10/07/12 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.CHI-A80036 10/08/30 By wuxj  整批确认时应对所有资料做检查
# Modify.........: No:MOD-A20063 10/10/05 By sabrina 會計科目不會自動帶出
# Modify.........: No:MOD-A20121 10/10/05 By sabrina 在登打付款單號及確認時應判斷該付款單是否已確認 
# Modify.........: No.CHI-A90007 10/10/06 By Summer 增加取票日期
# Modify.........: No.TQC-AB0382 10/12/02 By lixh1 增加“廠商收件人”欄位(nmd22)欄位控管
# Modify.........: No.MOD-AC0073 10/12/09 By Dido 立即確認時,確認圖示調整
# Modify.........: No.MOD-AC0122 10/12/16 By Dido 付款單檢核廠商需一致 
# Modify.........: No.MOD-AC0326 10/12/25 By Dido show 函式少了 nmd54
# Modify.........: No.MOD-B10032 11/01/05 By Dido 若簿號為'98','99' 則不檢核取票日期  
# Modify.........: No.TQC-B10069 11/01/14 By lixh1 整批確認時,使用彙總訊息方式呈現批次確認範圍內的所有錯誤訊息
# Modify.........: No.FUN-B10030 11/01/19 By vealxu 拿掉"營運中心切換"ACTION
# Modify.........: No.MOD-B10165 11/01/21 By Dido 串異動檔時須排除作廢單據 
# Modify.........: No.MOD-B20043 11/02/15 By Dido 若已存在簿號為 '98' 時,nmd03 應可選擇非支存的銀行資料  
# Modify.........: No:FUN-B20073 11/02/24 By lilingyu 科目查詢自動過濾-hcode
# Modify.........: No:MOD-B30084 11/03/14 By Sarah 1.作廢時,需要set aph09='N'
#                                                  2.取消作廢時,需檢查對應的付款單+項次是否已有另外開票,若有則不可取消作廢
# Modify.........: No:TQC-B30123 11/03/15 By yinhy 支票薄號開窗可以帶出未勾選了“支票套印”的資資料，未勾選“支票套印”"可以输入支票號碼
# Modify.........: No:TQC-B30122 11/03/15 By yinhy 未勾選支票套印的開放“支票號碼”欄位 
# Modify.........: No.FUN-B50090 11/05/16 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50066 11/05/23 By yinhy 回写aapt711中的ala12
# Modify.........: No.FUN-B50065 11/06/08 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-B60202 11/06/24 By Dido 異動付款單號後,舊單未更新aph09為'N' 
# Modify.........: No.MOD-B70095 11/07/12 By Dido 付款單號如有新舊值不同時才需要更新 
# Modify.........: No.MOD-B70288 11/07/29 By lixia 支票簿號開窗為空時，程序會卡死
# Modify.........: No.MOD-B90087 11/09/14 By Polly 調整錯誤訊息顯示
# Modify.........: No.MOD-BB0297 11/11/28 By Dido anm-109 檢核支票號碼增加簿號條件 
# Modify.........: No.MOD-BC0103 11/12/12 By Polly 調整nmd04欄位的檢核
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C30021 12/03/02 By yinhy 審核時，最後檢查若支票號碼是空則報錯
# Modify.........: No:TQC-C40211 12/04/23 By lujh 幣種與本國幣種相同時,本幣金額不等於原幣金額時，增加控管
# Modify.........: No:FUN-C30085 12/06/20 By lixiang 串CR報表改GR報表
# Modify.........: No:FUN-C80018 12/08/06 By minpp 大陸版時如果anmi030沒有維護單身時，anmt100單頭的簿號和支票號碼可以手動輸入
# Modify.........: No:MOD-C80098 12/08/14 By Polly 調整檢查若支票號碼控卡
# Modify.........: No:FUN-C90122 12/10/09 By wangrr 畫面增加nmd55已沖金額欄位,新增時如果付款/退款單號不為空時nmd55=nmd44,否則nmd55=0
# Modify.........: No:FUN-CB0049 12/11/12 By wangrr 增加"產生分錄底稿"和"分錄底稿"
# Modify.........: No:FUN-CB0117 13/01/09 By minpp 修改FUN-C80018搬程序BUG
# Modify.........: No.MOD-D10290 13/02/01 By Polly 增加新舊值判斷不同或新增時，才需清空支票號碼
# Modify.........: No:FUN-D20035 13/02/22 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.MOD-CC0103 13/03/06 By apo 調整型式為「退款」時，nmd08改開q_occ窗
# Modify.........: No.FUN-D10065 13/03/07 By wangrr 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                   判断若npq04 为空.则依原给值方式给值
# Modify.........: No.FUN-D40118 13/05/22 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
# Modify.........: No:FUN-D80075 13/08/20 By wangrr 大陸版本下付款銀行nmd03開窗抓取所有資料,簿號nmd31取消必輸,支票nmd02設為必輸,取消三者之前的關係
# Modify.........: No.FUN-D40120 13/08/22 By yangtt 增加复制的功能
# Modify.........: No.MOD-D90006 13/09/02 By yinhy 大陸版薄號欄位可以為空
# Modify.........: No.yinhy130923 13/09/23 By yinhy 大陸版支票號碼不可為空
# Modify.........: No.MOD-D90111 13/09/23 By SunLM 1.delete后取得sqlca.sqlcode 2.插入azo_file字段錯誤
# Modify.........: No.FUN-DA0047 13/10/11 By yangtt 增加【拋轉憑證】和【還原拋轉憑證】功能
# Modify.........: No.FUN-DA0047 13/11/26 By wangrr 產生分錄時設置npp011=10,用以區分anmt100與anmt150產生的分錄底稿

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_nmd               RECORD LIKE nmd_file.*,
    g_nmd_t             RECORD LIKE nmd_file.*,
    g_nmd_o             RECORD LIKE nmd_file.*,
    g_nmd01_t           LIKE nmd_file.nmd01,
    g_nmd03_t           LIKE nmd_file.nmd03,
    g_nmd04_t           LIKE nmd_file.nmd04,
    g_nms               RECORD LIKE nms_file.*,
    g_nnz               RECORD LIKE nnz_file.*,
    g_dept              LIKE nmd_file.nmd18,   #No.FUN-680107 VARCHAR(6)
    g_wc,g_sql          STRING,                #TQC-630166
    g_nna06             LIKE nna_file.nna06,
    g_nna03             LIKE nna_file.nna03,
    g_dbs_gl            LIKE type_file.chr21,  #No.FUN-680107 VARCHAR(21)
    g_plant_gl          LIKE type_file.chr10,  #No.FUN-980025 VARCHAR(10)
    l_ans               LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(01)
    l_cmd               LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(100)
    l_wc,l_wc2          LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(50)
    l_wc3,l_wc4         LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(50)
    l_wc5               LIKE type_file.chr1000,#No.TQC-6C0037
    l_prtway            LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
    g_t1                LIKE nmy_file.nmyslip, #No.FUN-680107 VARCHAR(5)
    g_nmydmy1           LIKE nmy_file.nmydmy1, #No.FUN-680107 VARCHAR(1)
    g_argv1             LIKE nmd_file.nmd01,   #FUN-5B0109 10->LIKE
    g_argv3             LIKE nmd_file.nmd10    #No.MOD-510076 #FUN-5B0109 10->LIKE  #FUN-630020 modify
DEFINE g_argv4          STRING                 #FUN-6C0051 add
DEFINE g_argv2             STRING              #No.FUN-630020 add
DEFINE g_forupd_sql        STRING              #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done STRING
 
DEFINE   g_chr          LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
DEFINE   g_cnt          LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_i            LIKE type_file.num5    #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE   g_void         LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
DEFINE   g_str          STRING                 #NO.FUN-830149
DEFINE   l_table        STRING                 #NO.FUN-830149
#FUN-CB0049--add--str--
DEFINE g_npp      RECORD LIKE npp_file.*
DEFINE g_npq      RECORD LIKE npq_file.*
DEFINE g_npq25    LIKE npq_file.npq25
#FUN-CB0049--add--end
 
MAIN
DEFINE   p_row,p_col    LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET g_argv1=ARG_VAL(1)
    LET g_argv2=ARG_VAL(2)          #No.MOD-510076
    LET g_argv3=ARG_VAL(3)          #No.FUN-630020 add
    LET g_argv4=ARG_VAL(4)          #No.FUN-6C0051 add
    LET g_plant_new = g_nmz.nmz02p
    LET g_plant_gl = g_nmz.nmz02p   #No.FUN-980025 add
    CALL s_getdbs()
    LET g_dbs_gl = g_dbs_new
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
    INITIALIZE g_nmd.* TO NULL
    INITIALIZE g_nmd_t.* TO NULL
    INITIALIZE g_nmd_o.* TO NULL
    LET p_row = 3 LET p_col = 2
   LET g_sql = "nmd01.nmd_file.nmd01,",
               "nmd30.nmd_file.nmd30,",
               "nmd03.nmd_file.nmd03,",
               "l_nma02.nma_file.nma02,",
               "nmd02.nmd_file.nmd02,",
               "nmd04.nmd_file.nmd04,",
               "l_nmo02_1.nmo_file.nmo02,",
               "l_nmo02_2.nmo_file.nmo02,",
               "nmd08.nmd_file.nmd08,",
               "nmd24.nmd_file.nmd24,",
               "l_sta.ze_file.ze03,",
               "nmd14.nmd_file.nmd14,",
               "nmd07.nmd_file.nmd07,",
               "nmd05.nmd_file.nmd05,",
               "t_azi04.azi_file.azi04"
   LET l_table = cl_prt_temptable('anmt100',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",status,1) EXIT PROGRAM
   END IF         
    OPEN WINDOW t100_w AT p_row,p_col
         WITH FORM "anm/42f/anmt100"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("nmd231",g_aza.aza63 = 'Y')  # No.FUN-680034 
    CALL cl_set_comp_visible("nmd34",FALSE) #No.FUN-A40054
    #FUN-D80075--add--str-- 
    IF g_aza.aza26='2' THEN
       CALL cl_set_comp_required('nmd31,nmd54',FALSE)
       CALL cl_set_comp_required('nmd02',TRUE)
    END IF
    #FUN-D80075--add--end

    CALL t100_lock_cur()     #MOD-840176 mod
   # 先以g_argv2判斷直接執行哪種功能，
   # 執行I時，g_argv1是單號
   IF NOT cl_null(g_argv1) OR NOT cl_null(g_argv3) OR NOT cl_null(g_argv4) THEN  #FUN-6C0051
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t100_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t100_a()
            END IF
         OTHERWISE
                CALL t100_q()
      END CASE
   END IF
 
       LET g_action_choice = ""
       CALL t100_menu()
    CLOSE WINDOW t100_w
 
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
FUNCTION t100_lock_cur()
 
    LET g_forupd_sql = "SELECT * FROM nmd_file WHERE nmd01 = ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t100_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
END FUNCTION
 
FUNCTION t100_cs()
    CLEAR FORM
    IF NOT cl_null(g_argv1) OR NOT cl_null(g_argv3) OR NOT cl_null(g_argv4) THEN     #No.FUN-630020 add
      IF NOT cl_null(g_argv4) THEN        #FUN-6C0051
           LET g_wc = g_argv4 CLIPPED     #FUN-6C0051
      ELSE                                #FUN-6C0051
        IF NOT cl_null(g_argv1) THEN
           LET g_wc=" nmd01='",g_argv1,"'"
           IF NOT cl_null(g_argv3) THEN          #No.FUN-630020 modify
              LET g_wc=g_wc CLIPPED,"AND nmd10='",g_argv3,"'"      ##No.FUN-630020 modify
           END IF
        ELSE
           IF NOT cl_null(g_argv3) THEN               #No.FUN-630020 modify
              LET g_wc=" nmd10='",g_argv3,"'"         #No.FUN-630020 modify
           END IF
        END IF
      END IF                               #FUN-6C0051
    ELSE
   INITIALIZE g_nmd.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        nmd01,nmd07,nmd03,nmd31,nmd54,nmd02,nmd21,nmd19,nmd04,nmd26,nmd05, #CHI-A90007 add nmd54
       #nmd06,nmd20,nmd25,nmd18,nmd08,nmd24,nmd09,nmd40,nmd10,nmd101,nmd34,  #MOD-CC0103 mark   #FUN-960141 add nmd40
        nmd06,nmd20,nmd25,nmd18,nmd40,nmd08,nmd24,nmd09,nmd10,nmd101,nmd34,  #MOD-CC0103 add
        nmd17,nmd11,nmd12,nmd27,nmd13,nmd29,nmd55,nmd30,nmd32,  #FUN-C90122 add nmd55
        nmd14,nmd22,nmd15,nmd16,
        nmd23,nmd231,   # No.FUN-680034
        nmduser,nmdgrup,nmdoriu,nmdorig,nmdmodu,nmddate,         #無有效碼  #No.TQC-A60109
        nmdud01,nmdud02,nmdud03,nmdud04,nmdud05,
        nmdud06,nmdud07,nmdud08,nmdud09,nmdud10,  
        nmdud11,nmdud12,nmdud13,nmdud14,nmdud15
      
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
        ON ACTION controlp
           CASE
               WHEN INFIELD(nmd01) #開票單號  #MOD-4A0252
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_nmd3"
                 LET g_qryparam.default1 = g_nmd.nmd01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO nmd01
                 NEXT FIELD nmd01
 
              WHEN INFIELD(nmd03) #銀行代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_nma2"
                 LET g_qryparam.default1 = g_nmd.nmd03
                 #FUN-D80075--add--str--
                 IF g_aza.aza26='2' THEN
                    LET g_qryparam.arg1 =123
                 ELSE
                 #FUN-D80075--add--end
                 LET g_qryparam.arg1 = 1
                 END IF   #FUN-D80075
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO nmd03
                 NEXT FIELD nmd03
              WHEN INFIELD(nmd31) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_nmd31"
                 LET g_qryparam.default1 = g_nmd.nmd31
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO nmd31
                 NEXT FIELD nmd31
              WHEN INFIELD(nmd18) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_nmd.nmd18
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO nmd18
                 NEXT FIELD nmd18
              WHEN INFIELD(nmd08) #廠商編號
               #-------------MOD-CC0103--------------------------(S)
                #--MOD-CC0103--mark
                #CALL cl_init_qry_var()
                #LET g_qryparam.state = "c"
                #LET g_qryparam.form = "q_pmc"
                #LET g_qryparam.default1 = g_nmd.nmd08
                #CALL cl_create_qry() RETURNING g_qryparam.multiret
                #--MOD-CC0103--mark
                 CALL q_occ_pmc(TRUE,TRUE,g_plant) RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO nmd08
                 NEXT FIELD nmd08
               #-------------MOD-CC0103--------------------------(E)
              WHEN INFIELD(nmd21) #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = g_nmd.nmd21
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO nmd21
                 NEXT FIELD nmd21
              WHEN INFIELD(nmd22) #廠商聯絡資料
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_pmd"
                 LET g_qryparam.default1 = g_nmd.nmd08
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO nmd22
                 NEXT FIELD nmd22
              WHEN INFIELD(nmd23)
                 CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nmd.nmd23,'23',g_aza.aza81)              #No.FUN-980025
                      RETURNING g_qryparam.multiret   
                 DISPLAY g_qryparam.multiret TO nmd23
                 NEXT FIELD nmd23
              WHEN INFIELD(nmd231)
                CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nmd.nmd231,'23',g_aza.aza82)              #No.FUN-980025 
                     RETURNING g_qryparam.multiret   
                DISPLAY g_qryparam.multiret TO nmd231
                NEXT FIELD nmd231
              WHEN INFIELD(nmd06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_nmo01"
                 LET g_qryparam.default1 = g_nmd.nmd06
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO nmd06
                 NEXT FIELD nmd06
              WHEN INFIELD(nmd20)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_nmo01"
                 LET g_qryparam.default1 = g_nmd.nmd20
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO nmd20
                 NEXT FIELD nmd20
              WHEN INFIELD(nmd17)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azf01a"  #No.FUN-930104
                 LET g_qryparam.state = "c"       
                 LET g_qryparam.default1 = g_nmd.nmd17
                 LET g_qryparam.arg1 = '8'        #No.FUN-930104
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO nmd17
                 NEXT FIELD nmd17
              WHEN INFIELD(nmd25) #變動碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_nml"
                 LET g_qryparam.default1 = g_nmd.nmd25
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO nmd25
                 NEXT FIELD nmd25
              WHEN INFIELD(nmd10)                                                                                           
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"  
                   LET g_qryparam.form ="q_apf3"                    #MOD-AC0122 mod
                   LET g_qryparam.default1 = g_nmd.nmd10                                         
                   CALL cl_create_qry() RETURNING g_nmd.nmd10                                                                  
                   DISPLAY BY NAME g_nmd.nmd10
                   NEXT FIELD nmd10
             #No.FUN-A40054 -BEGIN-----
             #WHEN INFIELD(nmd34)                                                                                           
             #     CALL cl_init_qry_var()
             #     LET g_qryparam.state = "c"                                                                                         
             #     LET g_qryparam.form = "q_azw"     #FUN-990031 add
             #     LET g_qryparam.where = "azw02 = '",g_legal,"' "    #FUN-990031 add
             #     LET g_qryparam.default1 = g_nmd.nmd34                                         
             #     CALL cl_create_qry() RETURNING g_nmd.nmd34                                                                  
             #     DISPLAY BY NAME g_nmd.nmd34
             #     NEXT FIELD nmd34                   
             #No.FUN-A40054 -END-------
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
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
 
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nmduser', 'nmdgrup')
 
    END IF
    LET g_sql="SELECT nmd01 FROM nmd_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY nmd01"
    PREPARE t100_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t100_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t100_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM nmd_file WHERE ",g_wc CLIPPED
    PREPARE t100_precount FROM g_sql
    DECLARE t100_count CURSOR FOR t100_precount
END FUNCTION
 
FUNCTION t100_menu()
    DEFINE l_apf00   LIKE apf_file.apf00   #CHI-850010 add
 
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t100_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t100_q()
            END IF
       #No.FUN-D40120 ---Add--- Start
        ON ACTION reproduce
           LET g_action_choice="reproduce"
           IF cl_chk_act_auth() THEN
              CALL t100_copy()
           END IF
       #No.FUN-D40120 ---Add--- End
        ON ACTION next
            CALL t100_fetch('N')
        ON ACTION previous
            CALL t100_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                  CALL t100_u()
            END IF
        #@ON ACTION 工廠切換
      # ON ACTION switch_plant                                       #FUN-B10030
      #    LET g_action_choice="switch_plant"   #MOD-7C0037          #FUN-B10030   
      #    IF cl_chk_act_auth() THEN   #MOD-7C0037                   #FUN-B10030
      #       CALL t100_chgdbs()                                     #FUN-B10030
      #    END IF   #MOD-7C0037                                      #FUN-B10030 
        #@ON ACTION 作廢
        ON ACTION void
            LET g_action_choice="void"
            IF cl_chk_act_auth() THEN
               #CALL t100_x()                #FUN-D20035
                CALL t100_x(1)               #FUN-D20035
                IF g_nmd.nmd30 = 'X' THEN
                   LET g_void = 'Y'
                ELSE
                   LET g_void = 'N'
                END IF
                CALL cl_set_field_pic(g_nmd.nmd30,"","","",g_void,"")
            END IF
        #FUN-D20035----add---str
         #@ON ACTION 取消作廢
         ON ACTION undo_void
            LET g_action_choice="void"
            IF cl_chk_act_auth() THEN
                CALL t100_x(2)             
                IF g_nmd.nmd30 = 'X' THEN
                   LET g_void = 'Y'
                ELSE
                   LET g_void = 'N'
                END IF
                CALL cl_set_field_pic(g_nmd.nmd30,"","","",g_void,"")
            END IF
        #FUN-D20035----add---end
        #@ON ACTION 確認
        ON ACTION confirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
                CALL s_showmsg_init()   #TQC-B10069
                CALL t100_firm1()
                CALL s_showmsg()        #TQC-B10069
                IF g_nmd.nmd30 = 'X' THEN
                   LET g_void = 'Y'
                ELSE
                   LET g_void = 'N'
                END IF
                CALL cl_set_field_pic(g_nmd.nmd30,"","","",g_void,"")
            END IF
        #@ON ACTION 取消確認
        ON ACTION undo_confirm
            LET g_action_choice="undo_confirm"
            IF cl_chk_act_auth() THEN
                CALL t100_firm2()
                IF g_nmd.nmd30 = 'X' THEN
                   LET g_void = 'Y'
                ELSE
                   LET g_void = 'N'
                END IF
                CALL cl_set_field_pic(g_nmd.nmd30,"","","",g_void,"")
            END IF
       #FUN-CB0049--add--str--
       #@ON ACTION 產生分錄底稿
       ON ACTION gen_entry
          LET g_action_choice="gen_entry"
          IF cl_chk_act_auth() THEN
             CALL t100_v()
          END IF
       #@ON ACTION 分錄底稿
       ON ACTION entry_sheet
          LET g_action_choice="entry_sheet"
          IF cl_chk_act_auth() AND not cl_null(g_nmd.nmd01) THEN
             #系統別、類別、單號、票面金額
             CALL s_showmsg_init()
             #CALL s_fsgl('NM',1,g_nmd.nmd01,g_nmd.nmd04,g_nmz.nmz02b,g_nmd.nmd12,
             #CALL s_fsgl('NM',1,g_nmd.nmd01,g_nmd.nmd04,g_nmz.nmz02b,'1',    #yinhy131011 #FUN-DA0047 mark
             CALL s_fsgl('NM',1,g_nmd.nmd01,g_nmd.nmd04,g_nmz.nmz02b,'10',         #FUN-DA0047
                              g_nmd.nmd30,'0',g_nmz.nmz02p)
             CALL s_showmsg()
          END IF
       #FUN-CB0049--add--end

       #FUN-DA0047----add---str---
#@    ON ACTION 傳票拋轉
      ON ACTION carry_voucher
         LET g_action_choice="carry_voucher"
         IF cl_chk_act_auth() THEN
            IF g_nmd.nmd30 ='Y' THEN
               CALL t100_carry_voucher()
            ELSE
               CALL cl_err('','atm-402',1)
            END IF
         END IF

#@    ON ACTION 傳票拋轉還原
      ON ACTION undo_carry_voucher
         LET g_action_choice="undo_carry_voucher"
         IF cl_chk_act_auth() THEN
            IF g_nmd.nmd30 ='Y' THEN
               CALL t100_undo_carry_voucher()
            ELSE
               CALL cl_err('','atm-403',1)
            END IF
         END IF
       #FUN-DA0047----add---end---

        #@ON ACTION 調整
        ON ACTION adjust
            LET g_action_choice="adjust"
            IF cl_chk_act_auth() THEN
                 CALL t100_m()
            END IF
        #@ON ACTION 支票作廢
        ON ACTION void_check
            LET g_action_choice="void_check"
            IF cl_chk_act_auth() THEN
                    CALL t100_c()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                    CALL t100_r()
            END IF
       #@ON ACTION 異動查詢
       ON ACTION qry_transaction
            LET g_action_choice="qry_transaction"
            IF cl_chk_act_auth() THEN
               LET l_cmd = "anmq102 '",g_nmd.nmd01,"'"
               CALL cl_cmdrun(l_cmd CLIPPED)
            END IF
       #@ON ACTION 查付款單
       ON ACTION qry_payment_slip
            LET g_action_choice="qry_payment_slip"
            IF cl_chk_act_auth() THEN
              #先判斷付款單號對應之apf00='16'的話,就CALL t110_w(g_nmd.nmd10)
              #若apf00!='16',則還是串aapt330
              SELECT apf00 INTO l_apf00 FROM apf_file
               WHERE apf01=g_nmd.nmd10
              IF l_apf00='16' THEN
                 CALL t110_w(g_nmd.nmd10)
              ELSE
                #LET l_cmd = "aapt330 '",g_nmd.nmd10,"' ' ' '",g_nmd.nmd34,"'"  #No.FUN-630010 #No.FUN-A40054
                 LET l_cmd = "aapt330 '",g_nmd.nmd10,"' ' ' '",g_plant,"'"      #No.FUN-A40054
                 CALL cl_cmdrun_wait(l_cmd CLIPPED)   #FUN-660216 add
              END IF    #CHI-850010 add
            END IF
 
       ON ACTION qry_return_slip
          LET g_action_choice="qry_return_slip"
          IF cl_chk_act_auth() THEN
             LET l_cmd = "axrt410 '",g_nmd.nmd10,"'"
             CALL cl_cmdrun_wait(l_cmd CLIPPED)
          END IF    
      
       #修改寄領方式
       ON ACTION modify_sent_taken
           LET g_action_choice="modify_sent_taken"
           IF cl_chk_act_auth()
              THEN CALL t100_ms()
           END IF
                 
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL t100_out()
            END IF
         ON ACTION help
            CALL cl_show_help()
         ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
         ON ACTION locale
            CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            IF g_nmd.nmd30 = 'X' THEN
               LET g_void = 'Y'
            ELSE
               LET g_void = 'N'
            END IF
            CALL cl_set_field_pic(g_nmd.nmd30,"","","",g_void,"")
         ON ACTION jump
            CALL t100_fetch('/')
         ON ACTION first
            CALL t100_fetch('F')
         ON ACTION last
            CALL t100_fetch('L')
         ON ACTION CONTROLG
            CALL cl_cmdask()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
            LET g_action_choice = "exit"
          CONTINUE MENU
         ON ACTION related_document       #相關文件
            LET g_action_choice="related_document"
            IF cl_chk_act_auth() THEN
                IF g_nmd.nmd01 IS NOT NULL THEN
                   LET g_doc.column1 = "nmd01"
                   LET g_doc.value1 = g_nmd.nmd01
                   CALL cl_doc()
                END IF
            END IF
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      &include "qry_string.4gl"
    END MENU
    CLOSE t100_cs
END FUNCTION
 
FUNCTION t100_a()
DEFINE l_sta      LIKE ze_file.ze03,       #No.FUN-680107 VARCHAR(04)
       l_nma12    LIKE nma_file.nma12
DEFINE li_result  LIKE type_file.num5      #No.FUN-550057  #No.FUN-680107 SMALLINT
DEFINE l_cnt      LIKe type_file.num5      #TQC-890020 add
DEFINE l_dbs      LIKE type_file.chr21     #MOD-980101 
DEFINE l_plant    LIKE type_file.chr21     #FUN-A50102
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                             # 清螢墓欄位內容
    INITIALIZE g_nmd.* TO NULL
    INITIALIZE g_nmd_t.* TO NULL
    LET g_nmd_t.* = g_nmd.*
    LET g_nmd.nmd04 = 0
    LET g_nmd.nmd03 = g_nmd_t.nmd03
    LET g_nmd.nmd05 = g_nmd_t.nmd05
    IF g_nmd.nmd05 IS NULL THEN LET g_nmd.nmd05 = TODAY END IF
    LET g_nmd.nmd07 = g_nmd_t.nmd07
    IF g_nmd.nmd07 IS NULL THEN LET g_nmd.nmd07 = TODAY END IF
    LET g_nmd.nmd06 = g_nmd_t.nmd06
    LET g_nmd.nmd20 = g_nmd_t.nmd20
    LET g_nmd.nmd12 =  '1'  #開立
    LET g_nmd.nmd13 =  g_today
    LET g_nmd.nmd14 =  '1'
    LET g_nmd.nmd18 =  g_nmd_t.nmd18
    LET g_nmd.nmd25 =  g_nmd_t.nmd25
    LET g_nmd.nmd19 =  1
    LET g_nmd.nmd40 = '1'    #FUN-960141
    LET g_nmd.nmd30 = 'N'
    LET g_nmd.nmd32 = 'N'
    LET g_nmd.nmd55 = 0  #FUN-C90122
   #LET g_nmd.nmd34 = g_plant #No.FUN-A40054
    LET g_nmd01_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_nmd.nmduser = g_user
        LET g_nmd.nmdoriu = g_user #FUN-980030
        LET g_nmd.nmdorig = g_grup #FUN-980030
        LET g_nmd.nmdgrup = g_grup               #使用者所屬群
        LET g_nmd.nmddate = g_today
        CALL t100_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_nmd.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        BEGIN WORK
        CALL s_auto_assign_no("anm",g_nmd.nmd01,g_nmd.nmd07,"1","nmd_file","nmd01","","","")
             RETURNING li_result,g_nmd.nmd01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_nmd.nmd01
 
        IF g_nmd.nmd01 IS NULL THEN                # KEY 不可空白
           CONTINUE WHILE
        END IF
        LET g_nmd.nmd33=g_nmd.nmd19 #No.A049
        LET g_nmd.nmdlegal=g_azw.azw02 #FUN-960141
        LET g_success = 'Y'
        LET g_nmd.nmdlegal = g_legal   #FUN-980005 add legal 
        INSERT INTO nmd_file VALUES(g_nmd.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","nmd_file",g_nmd.nmd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            ROLLBACK WORK
            CONTINUE WHILE
        ELSE
            LET g_nmd_t.* = g_nmd.*                # 保存上筆資料
            SELECT nmd01 INTO g_nmd.nmd01 FROM nmd_file
                WHERE nmd01 = g_nmd.nmd01
            CALL t100_hu(0,1)
               IF g_success = 'Y'
                  THEN CALL cl_cmmsg(1) COMMIT WORK
                       CALL cl_flow_notify(g_nmd.nmd01,'I')
                  ELSE CALL cl_rbmsg(1) ROLLBACK WORK
                          EXIT WHILE
               END IF
            #---判斷是否立即確認-----
            LET g_t1 = s_get_doc_no(g_nmd.nmd01)       #No.FUN-550057
            SELECT nmydmy1 INTO g_nmydmy1 FROM nmy_file
                   WHERE nmyslip = g_t1 AND nmyacti = 'Y'
#TQC-B10069 ---------------------Begin--------------------------
           #IF g_nmydmy1 = 'Y' THEN CALL t100_firm1() END IF
            CALL s_showmsg_init()      
            IF g_nmydmy1 = 'Y' THEN
               CALL t100_firm1()
            END IF
            CALL s_showmsg()            
#TQC-B10069 ---------------------End----------------------------
           #當付款單+項次(nmd10+nmd101)新增時SET aph09='Y'
            IF g_nmd.nmd40 = '1' THEN #FUN-960141 add
               IF NOT cl_null(g_nmd.nmd10) AND NOT cl_null(g_nmd.nmd101) THEN
                 #檢查一下來源是不是aapt330,是的話才回寫
              #No.FUN-A40054 -BEGIN
              #IF NOT cl_null(g_nmd.nmd34) THEN                                                                                     
              #   LET g_plant_new = g_nmd.nmd34                                                                                     
              #   CALL s_getdbs()                                                                                                   
              #   LET l_dbs = g_dbs_new                                                                                             
              #ELSE                                                                                                                 
              #   LET l_dbs = ''                                                                                                    
              #END IF
               LET l_dbs = ''
               LET l_plant = '' #FUN-A50102
              #No.FUN-A40054 -END-------
               LET l_cnt = 0                                                                                                        
               IF g_nmz.nmz05='Y' THEN                                                                                              
                  #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs,"aph_file,",l_dbs,"apf_file ",
                  LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'aph_file'),",", #FUN-A50102
                                                      cl_get_target_table(l_plant,'apf_file'),     #FUN-A50102                   
                              " WHERE aph01 = ? ",                                                                                  
                              "   AND aph02 = ? ",                                                                                  
                              "   AND (aph03 = '1' OR aph03 ='C') ",                                                                
                              "   AND apf41= 'Y' ",          #MOD-A20121 add
                              "   AND aph01 = apf01 AND apf44 IS NOT NULL AND apf44 != ' ' "                                        
               ELSE                                                                                                                 
                  #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs,"aph_file ",
                  LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'aph_file'),",", #FUN-A50102                   
                                                      cl_get_target_table(l_plant,'apf_file'),     #MOD-A20121 add
                              " WHERE aph01 = ? ",                                                                                  
                              "   AND aph02 = ? ",                                                                                  
                              "   AND (aph03 = '1' OR aph03 ='C') ",                                                                 
                              "   AND apf41= 'Y' ",          #MOD-A20121 add
                              "   AND aph01 = apf01 "        #MOD-A20121 add
               END IF                                                                                                               
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
               CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102               
               PREPARE t100_nmd101_chk_p_1 FROM g_sql                                                                               
               EXECUTE t100_nmd101_chk_p_1 INTO l_cnt USING g_nmd.nmd10,g_nmd.nmd101 
               IF l_cnt>0 THEN                                                                                                      
                  #LET g_sql = "UPDATE ",l_dbs,"aph_file ", 
                  LET g_sql = "UPDATE ",cl_get_target_table(l_plant,'aph_file'), #FUN-A50102                 
                              "   SET aph09 = 'Y'",                                                                                    
                              " WHERE aph01=?",                                                                                     
                              "   AND aph02=?",                                                                                     
                              "   AND (aph03='1' OR aph03='C')"                                                                     
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
                  CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102                   
                  PREPARE t100_nmd101_chk_p_2 FROM g_sql                                                                            
                  EXECUTE t100_nmd101_chk_p_2 USING g_nmd.nmd10,g_nmd.nmd101                                                        
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN                                                                       
                     LET g_success = 'N'                                                                                            
                     CALL cl_err3("upd","aph_file",g_nmd.nmd10,g_nmd.nmd101,SQLCA.sqlcode,"","upd aph_file",1)                      
                  END IF                                                                                                            
               END IF                   
               END IF
            END IF    #FUN-960141 add
            IF g_nmd.nmd40 = '2' THEN
               IF NOT cl_null(g_nmd.nmd10) AND NOT cl_null(g_nmd.nmd101) THEN
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM oob_file,ooa_file
                   WHERE oob01 = g_nmd.nmd10
                     AND oob02 = g_nmd.nmd101 
                     AND ooa01 = oob01
                     #AND ooa37 = 'Y'   #FUN-A40076 mark
                     AND ooa37 = '2'    #FUN-A40076 add
                  IF l_cnt > 0 THEN
                     UPDATE oob_file SET oob20 = 'Y'
                      WHERE oob01 = g_nmd.nmd10
                        AND oob02 = g_nmd.nmd101
                     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                        LET g_success = 'N'
                        CALL cl_err3("upd","oob_file",g_nmd.nmd10,g_nmd.nmd101,SQLCA.sqlcode,"","upd aph_file",1)  #No.FUN-660148
                     END IF
                  END IF
               END IF
            END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t100_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
        l_cmd           LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(50)
        l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入  #No.FUN-680107 VARCHAR(1)
        l_direct        LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
        l_ans           LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(01)
        l_nmo02         LIKE nmo_file.nmo02,    #票別說明
        l_nma28         LIKE nma_file.nma28,    #No.MOD-510041
        l_n             LIKE type_file.num5,    #No.FUN-680107 SMALLINT
        l_cnt           LIKE type_file.num5,    #No.FUN-680107 SMALLINT
        g_t1            LIKE nmy_file.nmyslip   #No.FUN-550058  #No.FUN-680107 VARCHAR(5)
DEFINE li_result        LIKE type_file.num5     #No.FUN-550057  #No.FUN-680107 SMALLINT
DEFINE l_count          LIKE type_file.num5     #MOD-930167 
DEFINE l_count1         LIKE type_file.num5     #MOD-940221
DEFINE l_dbs            LIKE type_file.chr21    #MOD-970138
DEFINE l_plant          LIKE type_file.chr21    #FUN-A50102   
DEFINE l_apf03          LIKE apf_file.apf03,
       l_aph13          LIKE aph_file.aph13,
       l_aph14          LIKE aph_file.aph14,
       l_aph05f         LIKE aph_file.aph05f,
       l_aph05          LIKE aph_file.aph05,
       l_nne16          LIKE nne_file.nne16,
       l_nne12          LIKE nne_file.nne12,
       l_nne19          LIKE nne_file.nne19,
       l_nng48          LIKE nng_file.nng48,
       l_nng18          LIKE nng_file.nng18,
       l_nng19          LIKE nng_file.nng19,
       l_nnh04f         LIKE nnh_file.nnh04f,
       l_nnh04          LIKE nnh_file.nnh04
DEFINE l_arg1           LIKE type_file.num5     #MOD-B20043
 
    INPUT BY NAME g_nmd.nmdoriu,g_nmd.nmdorig,
        g_nmd.nmd01,g_nmd.nmd07, g_nmd.nmd03, g_nmd.nmd31,g_nmd.nmd54,g_nmd.nmd02,#CHI-A90007 add nmd54
        g_nmd.nmd21,g_nmd.nmd19, g_nmd.nmd04,g_nmd.nmd26,
        g_nmd.nmd05,g_nmd.nmd06,g_nmd.nmd20,g_nmd.nmd25,
       #g_nmd.nmd18,g_nmd.nmd08, g_nmd.nmd24,g_nmd.nmd09,               #MOD-CC0103 mark
        g_nmd.nmd18,g_nmd.nmd40,g_nmd.nmd08, g_nmd.nmd24,g_nmd.nmd09,   #MOD-CC0103 
       #g_nmd.nmd40,     #MOD-CC0103 mark   #FUN-960141
      g_nmd.nmd10,g_nmd.nmd101,g_nmd.nmd34,
        g_nmd.nmd17,
        g_nmd.nmd11,g_nmd.nmd12,g_nmd.nmd27,g_nmd.nmd13,g_nmd.nmd29,g_nmd.nmd55, #FUN-C90122 add nmd55
        g_nmd.nmd30,g_nmd.nmd32,
      g_nmd.nmd14,g_nmd.nmd22,g_nmd.nmd15,g_nmd.nmd16,
      g_nmd.nmd23,g_nmd.nmd231,   # No.FUN-680034 
        g_nmd.nmduser,g_nmd.nmdgrup,g_nmd.nmdmodu,g_nmd.nmddate,
        g_nmd.nmdud01,g_nmd.nmdud02,g_nmd.nmdud03,g_nmd.nmdud04,
        g_nmd.nmdud05,g_nmd.nmdud06,g_nmd.nmdud07,g_nmd.nmdud08,
        g_nmd.nmdud09,g_nmd.nmdud10,g_nmd.nmdud11,g_nmd.nmdud12,
        g_nmd.nmdud13,g_nmd.nmdud14,g_nmd.nmdud15
        WITHOUT DEFAULTS
 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t100_set_entry(p_cmd)
            CALL t100_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
         CALL cl_set_docno_format("nmd01")
         CALL cl_set_docno_format("nmd10")
 
        AFTER FIELD nmd01
           IF (p_cmd='a' AND g_nmd.nmd01 IS NOT NULL) OR                  #MOD-870008
              (p_cmd='u' AND g_nmd.nmd01 != g_nmd_t.nmd01) THEN           #MOD-870008
           CALL s_check_no("anm",g_nmd.nmd01,g_nmd01_t,"1","nmd_file","nmd01","")
               RETURNING li_result,g_nmd.nmd01
           DISPLAY BY NAME g_nmd.nmd01
           IF (NOT li_result) THEN
             NEXT FIELD nmd01
           END IF
 
           END IF
 
        AFTER FIELD nmd21
            IF NOT cl_null(g_nmd.nmd21) THEN 
               LET l_count = 0 
               SELECT COUNT(*) INTO l_count FROM azi_file
                WHERE azi01 = g_nmd.nmd21
               IF l_count < 1 THEN 
                  CALL cl_err('','anm-007',0)
                  NEXT FIELD nmd21
               END IF  
            END IF  
 
       AFTER FIELD nmd07
            IF NOT cl_null(g_nmd.nmd07) THEN
            IF g_nmd.nmd13 IS NULL THEN
               LET g_nmd.nmd13 = g_nmd.nmd07 #預設異動日期
               DISPLAY BY NAME g_nmd.nmd13
            END IF
            IF g_nmd.nmd07 <= g_nmz.nmz10 THEN  #no.5261
               CALL cl_err('','aap-176',1) NEXT FIELD nmd07
            END IF
            LET g_nmd_o.nmd07 =  g_nmd.nmd07
            END IF
 
        AFTER FIELD nmd03
           IF NOT cl_null(g_nmd.nmd03)  THEN
           IF p_cmd='a' OR g_nmd.nmd03 != g_nmd_t.nmd03 THEN
              CALL t100_nmd03('a')
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_nmd.nmd03,g_errno,0)
                   LET g_nmd.nmd03 = g_nmd_o.nmd03
                   DISPLAY BY NAME g_nmd.nmd03
                   NEXT FIELD nmd03
               ELSE IF p_cmd = 'a' THEN   #新增時DEFAULT 幣別
                       SELECT nma10 INTO g_nmd.nmd21 FROM nma_file
                              WHERE nma01 = g_nmd.nmd03
                       IF SQLCA.sqlcode THEN LET g_nmd.nmd21 = ' ' END IF
                       DISPLAY BY NAME g_nmd.nmd21
                    END IF
                    IF g_nmd.nmd21 != g_aza.aza17 AND
                         (p_cmd = 'a' OR g_nmd.nmd21 != g_nmd_t.nmd21) THEN
                         CALL s_curr3(g_nmd.nmd21,g_nmd.nmd07,'S')
                              RETURNING g_nmd.nmd19
                         DISPLAY BY NAME g_nmd.nmd19
                    END IF
               END IF
            END IF
            LET g_nmd_o.nmd03 = g_nmd.nmd03
           END IF
 
        BEFORE FIELD nmd31
         IF cl_null(g_nmd.nmd03) THEN
            NEXT FIELD nmd03
         END IF
         CALL t100_set_entry(p_cmd)
 
        AFTER FIELD nmd31
          IF NOT cl_null(g_nmd.nmd31) THEN
             IF g_nmd.nmd31 <> '98' THEN
                SELECT nma28 INTO l_nma28 FROM nma_file
                 WHERE nma01= g_nmd.nmd03                                           #FUN-CB0117
                  SELECT COUNT(*) INTO l_cnt FROM nna_file WHERE nna01=g_nmd.nmd03  #FUN-C80018
           #      IF l_nma28 !='1'  THEN                                            #FUN-C80018
                  IF l_nma28 !='1' AND g_aza.aza26!='2' THEN                        #FUN-C80018
                      CALL cl_err('','anm-251',0)
                      NEXT FIELD nmd31
                  END IF
               END IF
               SELECT COUNT(*) INTO l_cnt FROM nna_file WHERE nna01=g_nmd.nmd03  #FUN-C80018
               #No.+120 簿號=99 表示可自行輸入票號不check(因為可能key別人之CP)
               #IF g_nmd.nmd31 <> '99' AND g_nmd.nmd31 <> '98' THEN  #No.5058   #FUN-C80018
                IF g_nmd.nmd31 <> '99' AND g_nmd.nmd31 <> '98' AND (g_aza.aza26!='2' OR l_cnt>0) THEN    #FUN-C80018
                 #IF p_cmd = 'u' THEN                                                        #MOD-D10290 mark
                  IF p_cmd = 'a' OR (p_cmd = 'u' AND g_nmd.nmd31 <> g_nmd_t.nmd31) THEN      #MOD-D10290 add
                     LET g_nmd.nmd02 = NULL 
                     DISPLAY BY NAME g_nmd.nmd02
                  END IF    
                SELECT COUNT(*) INTO l_n FROM nna_file,nma_file
                 WHERE nna01 = nma01
                   AND nna01 = g_nmd.nmd03
                   AND nna02 = g_nmd.nmd31
                #   AND nna06 = 'Y'            #MOD-AC0326 #TQC-B30123 mark
                IF l_n = 0 THEN                 
                   CALL cl_err('','anm-954',0) NEXT FIELD nmd31
#CHI-A90007 mark --start--
               #-MOD-AC0326-add- 
                ELSE
#                   SELECT nna06,nna03 INTO g_nna06,g_nna03 FROM nna_file
#                    WHERE nna01 = g_nmd.nmd03
#                      AND nna02 = g_nmd.nmd31
#                      AND nna021= (SELECT MAX(nna021) FROM nna_file
#                           WHERE nna01 = g_nmd.nmd03 AND nna02 = g_nmd.nmd31)
#CHI-A90007 mark --end--
                 #No.TQC-B30122  --Begin
                 #  IF cl_null(g_nmd.nmd54) THEN
                 #     SELECT MAX(nna021) INTO g_nmd.nmd54
                 #       #FROM nna_file
                 #       FROM nna_file,nmw_file
                 #      WHERE nna01 = g_nmd.nmd03 
                 #        AND nna02 = g_nmd.nmd31
                 #        AND nna01 = nmw01 
                 #        AND nna06 = 'Y'
                 SELECT MAX(nmw03) INTO g_nmd.nmd54
                   FROM nmw_file
                  WHERE nmw01 = g_nmd.nmd03
                    AND nmw06 = g_nmd.nmd31
                 #No.TQC-B30122  --End
                      DISPLAY BY NAME g_nmd.nmd54
                 #  END IF
               #-MOD-AC0326-end- 
                END IF
             ELSE                            #MOD-B10032
                LET g_nmd.nmd54 = g_today    #MOD-B10032
                DISPLAY BY NAME g_nmd.nmd54  #MOD-B10032
             END IF    #No.+120 010515 by linda add

#CHI-A90007 mark --start--
#           IF p_cmd='u' AND g_nmd.nmd31 != g_nmd_t.nmd31 AND
#              g_nna06 MATCHES '[Yy]' AND
#              NOT cl_null(g_nmd.nmd02) THEN
#                NEXT FIELD nmd31
#           END IF
#CHI-A90007 mark --end--
         END IF
#CHI-A90007 mark --start--
#          IF p_cmd = 'a' AND
#             (g_nna06 MATCHES '[Yy]' OR cl_null(g_nmd.nmd31)) THEN
#             LET g_nmd.nmd02 = ' '
#             DISPLAY BY NAME g_nmd.nmd02
#          END IF
#           LET g_nna06 = NULL 
#           SELECT nna06 INTO g_nna06 FROM nna_file
#            WHERE nna01 = g_nmd.nmd03
#              AND nna02 = g_nmd.nmd31
#              AND nna021 IN(SELECT MAX(nna021) FROM nna_file
#                            WHERE nna01 = g_nmd.nmd03 AND nna02 = g_nmd.nmd31)
#CHI-A90007 mark --end--
           
         CALL t100_set_no_entry(p_cmd)

        #CHI-A90007 add --start--
        #No.TQC-B30123  --Begin
        BEFORE FIELD nmd54
         #MOD-B70288--add--str--
          #IF cl_null(g_nmd.nmd31) THEN #FUN-D80075 mark
          IF cl_null(g_nmd.nmd31) AND g_aza.aza26<>'2' THEN #FUN-D80075
            NEXT FIELD nmd31
          END IF
          #MOD-B70288--add--end--
         #IF cl_null(g_nmd.nmd54) THEN #FUN-D80075 mark
         IF cl_null(g_nmd.nmd54) AND NOT cl_null(g_nmd.nmd31) THEN #FUN-D80075
            NEXT FIELD nmd54
         END IF
         CALL t100_set_entry(p_cmd)
        #No.TQC-B30123  --End
        AFTER FIELD nmd54 
           SELECT COUNT(*) INTO l_cnt FROM nna_file WHERE nna01=g_nmd.nmd03
          #IF g_nmd.nmd31 <> '99' AND g_nmd.nmd31 <> '98' THEN  #MOD-B10032  #FUN-C80018
          #IF g_nmd.nmd31 <> '99' AND g_nmd.nmd31 <> '98' AND (g_aza.aza26!='2' OR l_cnt>0) THEN #FUN-C80018 #FUN-D80075 mark
           IF g_nmd.nmd31 <> '99' AND g_nmd.nmd31 <> '98'                         #FUN-D80075
              AND (g_aza.aza26!='2' OR l_cnt>0) AND NOT cl_null(g_nmd.nmd31) THEN #FUN-D80075
              IF g_nmd.nmd54 IS NULL OR g_nmd.nmd54 = ' ' THEN
                 CALL cl_err(g_nmd.nmd54,'anm-003',0)
                 NEXT FIELD nmd54
              END IF
                 
              SELECT nna03,nna06
                INTO g_nna03,g_nna06
               FROM nna_file
               WHERE nna01 = g_nmd.nmd03
                 AND nna02 = g_nmd.nmd31
                 AND nna021 = g_nmd.nmd54 
              IF STATUS THEN
                 CALL cl_err3("sel","nna_file",g_nmd.nmd03,g_nmd.nmd31,"anm-954","","",0)
                 LET g_nna03 = ' '
                 NEXT FIELD nmd03
              ELSE
                 IF p_cmd='u' AND g_nmd.nmd31 != g_nmd_t.nmd31 AND
                    g_nna06 MATCHES '[Yy]' AND
                    NOT cl_null(g_nmd.nmd02) THEN
                      NEXT FIELD nmd31
                 END IF
                 IF p_cmd = 'a' AND
                    (g_nna06 MATCHES '[Yy]' OR cl_null(g_nmd.nmd31)) THEN
                    LET g_nmd.nmd02 = ' '
                    DISPLAY BY NAME g_nmd.nmd02                
                 END IF
              END IF
           END IF                                               #MOD-B10032
        #CHI-A90007 add --end--
           CALL t100_set_no_entry(p_cmd)      #TQC-B30122
           
        AFTER FIELD nmd02   #票號
          #若簿號=99 必須自行key票號
          IF g_nmd.nmd31 =99 AND cl_null(g_nmd.nmd02) THEN
             CALL cl_err(g_nmd.nmd02,'anm-003',0)
             LET g_nmd.nmd02 = g_nmd_o.nmd02
             DISPLAY BY NAME g_nmd.nmd02
             NEXT FIELD nmd02
          END IF
 
          #-->若銀行不使用套印支票則本欄位不可空白
          IF g_nna06 MATCHES '[Nn]' THEN
             IF g_nmd.nmd02 IS NULL  OR g_nmd.nmd02 = ' ' THEN
                CALL cl_err(g_nmd.nmd02,'anm-003',0)
                LET  g_nmd.nmd02 = g_nmd_o.nmd02
                DISPLAY BY NAME g_nmd.nmd02
                NEXT FIELD nmd02
             END IF
          END IF
 
          IF NOT cl_null(g_nmd.nmd02) THEN
            IF p_cmd = 'a' AND g_nna06 MATCHES '[Yy]' THEN
               LET g_nmd.nmd02 = ' '
               DISPLAY BY NAME g_nmd.nmd02
            END IF
            #-->若銀行不使用套印支票則本欄位不可空白
            IF p_cmd = 'a' OR g_nmd.nmd02 != g_nmd_t.nmd02
               OR g_nmd_t.nmd02 IS NULL
            THEN #-->票號不能重複
               IF g_nna06 MATCHES '[Nn]' THEN
                  SELECT count(*) INTO l_cnt FROM nmd_file
                   WHERE nmd02 = g_nmd.nmd02
                     AND nmd01 != g_nmd.nmd01
                     AND nmd31 = g_nmd.nmd31   #MOD-BB0297
                  IF l_cnt > 0 THEN
                     CALL cl_err(g_nmd.nmd02,'anm-109',0)
                     LET g_nmd.nmd02 = g_nmd_t.nmd02
                     DISPLAY BY NAME g_nmd.nmd02
                     NEXT FIELD nmd02
                  END IF
                  CALL t100_chkbook()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_nmd.nmd02,g_errno,0)
                     LET g_nmd.nmd02 = g_nmd_t.nmd02
                     DISPLAY BY NAME g_nmd.nmd02
                     NEXT FIELD nmd02
                  END IF
               END IF
            END IF
               SELECT COUNT(*) INTO l_cnt FROM nnz_file
                WHERE nnz01=g_nmd.nmd03 AND nnz02=g_nmd.nmd02
               IF l_cnt > 0 THEN
                  CALL cl_err('','aar-107',0) NEXT FIELD nmd02
               END IF
 
            IF p_cmd='u' AND (g_nmd.nmd02 != g_nmd_t.nmd02 OR g_nmd_t.nmd02 IS NULL) AND     #No:9466
                #g_nna06 MATCHES '[Yy]' AND NOT cl_null(g_nmd.nmd02) THEN   #MOD-680106
                g_nna06 MATCHES '[Yy]' THEN   #MOD-680106
                  NEXT FIELD nmd02
            END IF
            LET g_nmd_o.nmd02 = g_nmd.nmd02
          END IF
 
        AFTER FIELD nmd19  #匯率
            IF NOT cl_null(g_nmd.nmd19) THEN
               IF g_nmd.nmd19 <=0 THEN NEXT FIELD nmd19 END IF
               IF g_nmd.nmd21 = g_aza.aza17 AND g_nmd.nmd19 != 1
               THEN NEXT FIELD nmd19
               END IF
            END IF
 
        AFTER FIELD nmd04  #票面金額
            IF NOT cl_null(g_nmd.nmd04) THEN
               IF g_nmd.nmd04 <= 0 THEN
                  CALL cl_err(g_nmd.nmd04,'anm-041',0)
                  NEXT FIELD nmd04
               END IF
               LET g_nmd_o.nmd04 = g_nmd.nmd04
            SELECT azi04 INTO t_azi04 FROM azi_file #NO.CHI-6A0004
             WHERE azi01=g_nmd.nmd21
            CALL cl_digcut(g_nmd.nmd04,t_azi04) RETURNING g_nmd.nmd04 #No.9042  #MOD-A10111 mod g_azi04->t_azi04  
            DISPLAY BY NAME g_nmd.nmd04
               LET g_nmd.nmd26 = g_nmd.nmd04 * g_nmd.nmd19
               IF cl_null(g_nmd.nmd26) THEN LET g_nmd.nmd26 = 0 END IF
               CALL cl_digcut(g_nmd.nmd26,g_azi04) RETURNING g_nmd.nmd26    
               DISPLAY BY NAME g_nmd.nmd26
            END IF
 
        AFTER FIELD nmd26  #本幣金額
            #TQC-C40211--add--str--
            IF g_nmd.nmd21 = g_aza.aza17 THEN
              IF g_nmd.nmd04 <> g_nmd.nmd26 THEN
                CALL cl_err(g_nmd.nmd26,'anm-020',1)
                 LET g_nmd.nmd04 = g_nmd.nmd26 
                 DISPLAY BY NAME g_nmd.nmd04  
              END IF
            END IF
            #TQC-C40211--add--end--
            IF NOT cl_null(g_nmd.nmd26) THEN
               IF g_nmd.nmd26 <=0 THEN NEXT FIELD nmd26 END IF
               CALL cl_digcut(g_nmd.nmd26,g_azi04) RETURNING g_nmd.nmd26     
               DISPLAY BY NAME g_nmd.nmd26
            END IF
 
        AFTER FIELD nmd05   #到期日
            LET g_nmd_o.nmd05 = g_nmd.nmd05
#TQC-AB0382 --------------------------------Begin-----------------------------
        AFTER FIELD nmd22   #廠商收件人
            IF NOT cl_null(g_nmd.nmd22) THEN
               SELECT COUNT(*) INTO l_cnt FROM  pmd_file
                WHERE pmd01 = g_nmd.nmd08
                  AND pmd02 = g_nmd.nmd22
               IF l_cnt = 0 THEN
                  CALL cl_err(g_nmd.nmd22,'anmt001',0)
                  LET g_nmd.nmd22 =g_nmd_o.nmd22
                  NEXT FIELD nmd06
               END IF
               LET g_nmd_o.nmd22 = g_nmd.nmd22
            END  IF
#TQC-AB0382 --------------------------------End-------------------------------
 
       AFTER FIELD nmd06   #票別
           IF NOT cl_null(g_nmd.nmd06) THEN
              CALL t100_nmo(p_cmd,g_nmd.nmd06,'1')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nmd.nmd06,g_errno,0)
                 LET g_nmd.nmd06 =g_nmd_o.nmd06
                 NEXT FIELD nmd06
              END IF
              LET g_nmd_o.nmd06 =  g_nmd.nmd06
           END  IF
 
       AFTER FIELD nmd20   #票別
           IF NOT cl_null(g_nmd.nmd20) THEN
                 CALL t100_nmo(p_cmd,g_nmd.nmd20,'2')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nmd.nmd06,g_errno,0)
                    LET g_nmd.nmd20 =g_nmd_o.nmd20
                    NEXT FIELD nmd20
                 END IF
            END IF
            LET g_nmd_o.nmd20 =  g_nmd.nmd20
 
       AFTER FIELD nmd18
            IF g_nmz.nmz07 = 'N' AND cl_null(g_nmd.nmd18)
            THEN CALL cl_err(g_nmd.nmd18,'anm-152',0)
                 NEXT FIELD nmd18
            END IF
            IF not cl_null(g_nmd.nmd18) THEN
               CALL t100_nmd18(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nmd.nmd18,g_errno,0)
                  LET g_nmd.nmd18 = g_nmd_o.nmd18
                  DISPLAY BY NAME g_nmd.nmd18
                  NEXT FIELD nmd18
                END IF
            END IF
 
       AFTER FIELD nmd08
            IF NOT cl_null(g_nmd.nmd08) THEN
              #-MOD-AC0122-add-
               IF g_nmd.nmd08 <> g_nmd_o.nmd08 AND NOT cl_null(g_nmd_o.nmd08) 
                  AND NOT cl_null(g_nmd.nmd10) THEN
                  CALL cl_err(g_nmd.nmd08,'aap-040',0)
                  NEXT FIELD nmd08
               END IF
              #-MOD-AC0122-end-
               CALL t100_nmd08('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nmd.nmd08,g_errno,0)
                  LET g_nmd.nmd08 = g_nmd_o.nmd08
                  DISPLAY BY NAME g_nmd.nmd08
                  NEXT FIELD nmd08
               END IF
               LET g_nmd_o.nmd08 =  g_nmd.nmd08
            END IF
 
        AFTER FIELD nmd24
           IF g_nmd.nmd24 IS NOT NULL THEN
              IF g_nmd.nmd24[1,1]='.' THEN
                 LET g_msg = g_nmd.nmd24[2,9]
                 SELECT gen02 INTO g_nmd.nmd24 FROM gen_file WHERE gen01=g_msg
                 DISPLAY BY NAME g_nmd.nmd24
                 IF STATUS THEN NEXT FIELD nmd24 END IF
              END IF
              IF g_nmd.nmd09 IS NULL THEN LET g_nmd.nmd09 = g_nmd.nmd24 END IF
              IF g_nmd.nmd08 != 'MISC' AND g_nmd.nmd08 != 'EMPL' THEN
                 LET g_nmd.nmd24 = g_nmd_o.nmd24
                 DISPLAY BY NAME g_nmd.nmd24
              END IF
           END IF
 
        AFTER FIELD nmd17
            IF g_nmd.nmd17 IS NOT NULL THEN
               CALL t100_nmd17('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD nmd17
               END IF
            END IF
        AFTER FIELD nmd25
            IF g_nmd.nmd25 IS NOT NULL THEN
               CALL t100_nmd25('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD nmd25
               END IF
            END IF
 
        BEFORE FIELD nmd10
          IF cl_null(g_nmd.nmd40) THEN
            NEXT FIELD nmd40
          END IF
        BEFORE FIELD nmd101
          IF cl_null(g_nmd.nmd40) THEN
            NEXT FIELD nmd40
          END IF
        AFTER FIELD nmd40
          IF NOT cl_null(g_nmd.nmd40) THEN
             IF g_nmd.nmd40 = '2' THEN
                LET g_nmd.nmd17 = NULL
                DISPLAY g_nmd.nmd17 TO nmd17
                DISPLAY NULL TO azf03
             END IF
             CALL  t100_set_entry(p_cmd)
             CALL  t100_set_no_entry(p_cmd)
          END IF   

      #No.FUN-A40054 -BEGIN----- 
      #AFTER FIELD nmd34
      #   IF NOT cl_null(g_nmd.nmd34) THEN
      #      SELECT COUNT(*) INTO l_n FROM azw_file WHERE azw01 = g_nmd.nmd34
      #         AND azw02 = g_legal
      #      IF l_n = 0  THEN
      #         CALL cl_err('sel_azw','agl-171',0) 
      #         NEXT FIELD nmd34
      #      END IF 
      #   END IF
      #No.FUN-A40054 -END-------

        AFTER FIELD nmd101
          #-MOD-AC0122-add-
           IF NOT cl_null(g_nmd.nmd10) AND cl_null(g_nmd.nmd101) THEN
              NEXT FIELD nmd101
           END IF
          #-MOD-AC0122-end-
           IF NOT cl_null(g_nmd.nmd10) AND NOT cl_null(g_nmd.nmd101) THEN
              IF p_cmd='a' OR g_nmd.nmd10!=g_nmd_t.nmd10 OR
                 g_nmd.nmd101!=g_nmd_t.nmd101 OR g_nmd_t.nmd101 IS NULL THEN
                #No.FUN-A40054 -BEGIN-----
                #IF NOT cl_null(g_nmd.nmd34) THEN
                #   LET g_plant_new = g_nmd.nmd34                                                                                   
                #   CALL s_getdbs()                                                                                                 
                #   LET l_dbs = g_dbs_new                                                                                           
                #ELSE                                                                                                               
                #   LET l_dbs = ''                                                                                                  
                #END IF
                 LET l_dbs = ''
                 LET  l_plant = '' #FUN-A50102
                #No.FUN-A40054 -END-------
                 LET l_cnt = 0                                                                                                      
                 IF g_nmd.nmd40 = '1' THEN
                    IF g_nmz.nmz05='Y' THEN                                                                                            
                       #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs,"aph_file,",l_dbs,"apf_file ",
                       LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'aph_file'),",", #FUN-A50102
                                                           cl_get_target_table(l_plant,'apf_file'),     #FUN-A50102                     
                       " WHERE aph01 = ? ",                                                                                            
                       "   AND aph02 = ? ",                                                                                            
                       "   AND apf03 = ? ",               #MOD-AC0122
                       "   AND (aph03 = '1' OR aph03 ='C') ",                                                                          
                       "   AND aph09 = 'N' ",             #MOD-AC0122
                       "   AND apf41 = 'Y' ",             #MOD-A20121 add
                       "   AND aph01 = apf01 AND apf44 IS NOT NULL AND apf44 != ' ' "                                                  
                    ELSE                                                                                                               
                       #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs,"aph_file ",
                       LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'aph_file'),",", #FUN-A50102                     
                                                           cl_get_target_table(l_plant,'apf_file'),     #MOD-A20121 add
                                   " WHERE aph01 = ? ",                                                                                   
                                   "   AND aph02 = ? ",                                                                                   
                                   "   AND apf03 = ? ",               #MOD-AC0122
                                   "   AND (aph03 = '1' OR aph03 = 'C') ",   
                                   "   AND aph09 = 'N' ",             #MOD-AC0122
                                   "   AND apf41 = 'Y' ",             #MOD-A20121 add
                                   "   AND aph01 = apf01 "            #MOD-A20121 add
                    END IF #MOD-980101                                                                                 
                    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                    CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102                    
                    PREPARE t100_nmd101_chk_p FROM g_sql                                                                               
                    EXECUTE t100_nmd101_chk_p INTO l_cnt USING g_nmd.nmd10,g_nmd.nmd101,g_nmd.nmd08  #MOD-AC0122 add nmd08                                                
                   #來源有aapt330,anmt710,anmt720,三個都要檢查                                                                        
                    IF l_cnt = 0 THEN                                                                                                  
                   #檢查資料是否存在anmt710                                                                                        
                       #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs,"nne_file ",
                       LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'nne_file'), #FUN-A50102                       
                                   " WHERE nne01 = ? ",             
                                   "   AND nneconf = 'Y' "        #MOD-A20121 add
                       CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
                       CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
                       PREPARE t100_nmd101_chk2_p FROM g_sql                                                                           
                       EXECUTE t100_nmd101_chk2_p INTO l_cnt USING g_nmd.nmd10                                                         
                       IF l_cnt = 0 THEN                                                                                               
                      #檢查資料是否存在anmt720                                                                                     
                          #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs,"nnh_file ",
                          LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'nnh_file'),",", #FUN-A50102                                                  
                                                              cl_get_target_table(l_plant,'nng_file'),     #MOD-A20121 add
                                      " WHERE nnh01 = ? ",                                                                             
                                      "   AND nnh02 = ? ",                                                                             
                                      "   AND nnh01 = nng01 AND nngconf = 'Y' "       #MOD-A20121 add
                          CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                          CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102                          
                          PREPARE t100_nmd101_chk3_p FROM g_sql                                                                        
                          EXECUTE t100_nmd101_chk3_p INTO l_cnt USING g_nmd.nmd10,g_nmd.nmd101                                         
                          IF l_cnt > 0 THEN                  #MOD-A20121 add
                             SELECT nng48,nng18,nng19,nnh04f,nnh04
                               INTO l_nng48,l_nng18,l_nng19,l_nnh04f,l_nnh04
                               FROM nng_file,nnh_file
                              WHERE nng01=nnh01
                                AND nnh01=g_nmd.nmd10 AND nnh02=g_nmd.nmd101
                             IF (l_nng48 != g_nmd.nmd08) OR (l_nng18 != g_nmd.nmd21) OR
                                (l_nng19 != g_nmd.nmd19) OR
                                (l_nnh04f != g_nmd.nmd04) OR (l_nnh04 != g_nmd.nmd26) THEN
                                IF cl_confirm('anm-824') THEN
                                   LET g_nmd.nmd08 = l_nng48
                                   LET g_nmd.nmd21 = l_nng18
                                   LET g_nmd.nmd19 = l_nng19
                                   LET g_nmd.nmd04 = l_nnh04f
                                   LET g_nmd.nmd26 = l_nnh04
                                   DISPLAY BY NAME g_nmd.nmd08,g_nmd.nmd21,g_nmd.nmd19,
                                                   g_nmd.nmd04,g_nmd.nmd26
                                END IF
                             END IF   
                          END IF       #MOD-A20121 add 
                       ELSE
                          SELECT nne12,nne16,nne19 INTO l_nne12,l_nne16,l_nne19
                            FROM nne_file
                           WHERE nne01=g_nmd.nmd10
                          IF (g_nmd.nmd08 != 'MISC') OR (l_nne16 != g_nmd.nmd21) OR 
                             (g_nmd.nmd19 != 1) OR
                             (l_nne12 != g_nmd.nmd04) OR (l_nne19 != g_nmd.nmd26) THEN
                             IF cl_confirm('anm-824') THEN
                                LET g_nmd.nmd08 = 'MISC'
                                LET g_nmd.nmd21 = l_nne16
                                LET g_nmd.nmd19 = 1
                                LET g_nmd.nmd04 = l_nne12
                                LET g_nmd.nmd26 = l_nne19
                                DISPLAY BY NAME g_nmd.nmd08,g_nmd.nmd21,g_nmd.nmd19,
                                                g_nmd.nmd04,g_nmd.nmd26
                             END IF
                          END IF   
                       END IF
                    ELSE
                       SELECT apf03,aph13,aph14,aph05f,aph05
                         INTO l_apf03,l_aph13,l_aph14,l_aph05f,l_aph05
                         FROM apf_file,aph_file
                        WHERE apf01=aph01
                          AND aph01=g_nmd.nmd10 AND aph02=g_nmd.nmd101
                          AND apf03=g_nmd.nmd08                                        #MOD-AC0122
                          AND (aph03 = '1' OR aph03 = 'C')
                          AND aph09 = 'N'                                              #MOD-AC0122
                       IF (l_apf03 != g_nmd.nmd08) OR (l_aph13 != g_nmd.nmd21) OR
                          (l_aph14 != g_nmd.nmd19) OR
                          (l_aph05f != g_nmd.nmd04) OR (l_aph05 != g_nmd.nmd26) THEN
                          IF cl_confirm('anm-824') THEN
                             LET g_nmd.nmd08 = l_apf03
                             LET g_nmd.nmd21 = l_aph13
                             LET g_nmd.nmd19 = l_aph14
                             LET g_nmd.nmd04 = l_aph05f
                             LET g_nmd.nmd26 = l_aph05
                             DISPLAY BY NAME g_nmd.nmd08,g_nmd.nmd21,g_nmd.nmd19,
                                             g_nmd.nmd04,g_nmd.nmd26
                          END IF
                       END IF   
                    END IF    
                    IF g_nmd.nmd08 != 'MISC' AND g_nmd.nmd08 != 'EMPL' THEN
                       SELECT pmc03,pmc081 INTO g_nmd.nmd24,g_nmd.nmd09
                         FROM pmc_file
                        WHERE pmc01=g_nmd.nmd08 AND pmc30 MATCHES "[23]"
                       IF g_nmd.nmd09 IS NULL THEN
                          LET g_nmd.nmd09 = g_nmd.nmd24
                       END IF
                       DISPLAY BY NAME g_nmd.nmd24,g_nmd.nmd09
                    END IF
                    IF l_cnt = 0 THEN    #表示輸入的付款單不存在
                       CALL cl_err('','agl-118',0)   #無符合條件的資料,請重新輸入!
                       NEXT FIELD nmd101
                    END IF
                 ELSE
                    #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs,"oob_file,",l_dbs,"ooa_file ",
                    LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'oob_file'),",", #FUN-A50102
                                                        cl_get_target_table(l_plant,'ooa_file'),     #FUN-A50102                     
                                " WHERE oob01 = ? ",                                                                                      
                                "   AND oob02 = ? ",                                                                                     
                                "   AND ooa01 = oob01 ",                                                                                           
                                #"   AND ooa37 = 'Y' "   #FUN-A40076 mark
                                "   AND ooa37 = '2' "    #FUN-A40076 add
                               ,"   AND oob04 = 'D' ",   #MOD-CC0103 add 
                                "   AND oob20 = 'N' "    #MOD-CC0103 add 
                    CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
                    CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102                     
                    PREPARE t100_nmd101_chk7_p FROM g_sql                                                                     
                    EXECUTE t100_nmd101_chk7_p INTO l_cnt USING g_nmd.nmd10,g_nmd.nmd101       
                    IF l_cnt = 0 THEN  #表示輸入的退款單不存在
                      CALL cl_err('','agl-118',0)
                      NEXT FIELD nmd101
                    END IF
                 END IF
              END IF
           END IF
           #FUN-C90122--add--str--
           IF NOT cl_null(g_nmd.nmd10) AND NOT cl_null(g_nmd.nmd101) THEN
              LET g_nmd.nmd55=g_nmd.nmd04
              DISPLAY BY NAME g_nmd.nmd55
           END IF
           #FUN-C90122--add--end
 
        AFTER FIELD nmd13
           LET g_nmd_o.nmd13 = g_nmd.nmd13
 
        AFTER FIELD nmd14  #寄領方式
            IF NOT cl_null(g_nmd.nmd14) THEN
               IF g_nmd.nmd14 NOT MATCHES '[123]' THEN
                  CALL cl_err(g_nmd.nmd14,'anm-008',0)
                  LET g_nmd.nmd14 = g_nmd_o.nmd14
                  DISPLAY BY NAME g_nmd.nmd14
                  NEXT FIELD nmd14
                END IF
               IF g_nmd.nmd14 = '1' AND p_cmd = 'a' THEN
                  #新增時預設主要廠商聯絡人
                  SELECT pmd02 INTO g_nmd.nmd22 FROM pmd_file
                   WHERE pmd01 = g_nmd.nmd08 AND pmd05 IN ('Y','y')
                   IF SQLCA.sqlcode THEN LET g_nmd.nmd22 = ' '
                                        LET g_nmd_o.nmd22 = ' '
                   END IF
                   DISPLAY BY NAME g_nmd.nmd22
                 END IF
               LET g_nmd_o.nmd14 = g_nmd.nmd14
               LET l_direct = 'U'
            END IF
 
        BEFORE FIELD nmd23
            IF cl_null(g_nmd.nmd23) THEN
                  IF g_nmz.nmz11 = 'Y'
                  THEN LET g_dept = g_nmd.nmd18
                  ELSE LET g_dept = ' '
                  END IF
                  SELECT * INTO g_nms.* FROM nms_file WHERE nms01 = g_dept
                  IF STATUS THEN INITIALIZE g_nms.* TO NULL END IF
                  LET g_nmd.nmd23 = g_nms.nms15
               DISPLAY BY NAME g_nmd.nmd23
            END IF
 
        AFTER FIELD nmd23
           IF g_nmz.nmz02 = 'Y' AND NOT cl_null(g_nmd.nmd23) THEN
              CALL s_m_aag(g_nmz.nmz02p,g_nmd.nmd23,g_aza.aza81) RETURNING g_msg   #NO.FUN-730028   #FUN-990069 
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
#FUN-B20073 --begin--
                  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmd.nmd23,'23',g_aza.aza81)  
                       RETURNING g_nmd.nmd23   
                  DISPLAY BY NAME g_nmd.nmd23
#FUN-B20073 --end--                                         
                 NEXT FIELD nmd23
              END IF
           END IF
 
       BEFORE FIELD nmd231
              IF cl_null(g_nmd.nmd231) THEN
                 IF g_nmz.nmz11 = 'Y'
                 THEN LET g_dept = g_nmd.nmd18
                 ELSE LET g_dept = ' '
                 END IF
                 SELECT * INTO g_nms.* FROM nms_file WHERE nms01 = g_dept
                 IF STATUS THEN INITIALIZE g_nms.* TO NULL END IF
                 LET g_nmd.nmd231 = g_nms.nms15
              DISPLAY BY NAME g_nmd.nmd231
           END IF
 
       AFTER FIELD nmd231
          IF g_nmz.nmz02 = 'Y' AND NOT cl_null(g_nmd.nmd231) THEN
              CALL s_m_aag(g_nmz.nmz02p,g_nmd.nmd231,g_aza.aza82) RETURNING g_msg   #NO.FUN-740028   #FUN-990069
              IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
#FUN-B20073 --begin--
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmd.nmd231,'23',g_aza.aza82)
                      RETURNING g_nmd.nmd231   
                DISPLAY BY NAME g_nmd.nmd231
#FUN-B20073 --end--                                
                NEXT FIELD nmd231
             END IF
          END IF
 
        AFTER FIELD nmdud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmdud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmdud03 
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmdud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmdud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmdud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmdud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmdud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmdud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmdud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmdud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmdud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmdud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmdud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmdud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_nmd.nmduser = s_get_data_owner("nmd_file") #FUN-C10039
           LET g_nmd.nmdgrup = s_get_data_group("nmd_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF g_nmd.nmd02 IS NULL AND g_nna06 MATCHES '[nN]' THEN
               DISPLAY BY NAME g_nmd.nmd02
               NEXT FIELD nmd02
            END IF
            #IF g_nmd.nmd04 <= 0 THEN                           #MOD-BC0103 mark
             IF g_nmd.nmd04 <= 0 AND  g_nmd.nmd12 <> 'X' THEN   #MOD-BC0103 add
               DISPLAY BY NAME g_nmd.nmd04
               NEXT FIELD nmd04
            END IF
            IF g_nmd.nmd14 = '1' AND cl_null(g_nmd.nmd22) THEN
               DISPLAY BY NAME g_nmd.nmd22
               NEXT FIELD nmd22
            END IF
            IF g_nmd.nmd19 <=0 THEN
               DISPLAY BY NAME g_nmd.nmd19
               NEXT FIELD nmd19
            END IF
            IF g_nmz.nmz07 = 'N' AND cl_null(g_nmd.nmd18) THEN
               DISPLAY BY NAME g_nmd.nmd18
               NEXT FIELD nmd18
            END IF
           #MOD-A20063---add---start---
               IF g_nmz.nmz11 = 'Y'
                  THEN LET g_dept = g_nmd.nmd18
                  ELSE LET g_dept = ' '
               END IF
               SELECT * INTO g_nms.* FROM nms_file WHERE nms01 = g_dept
               IF STATUS THEN INITIALIZE g_nms.* TO NULL END IF
            IF cl_null(g_nmd.nmd23) THEN
               LET g_nmd.nmd23 = g_nms.nms15
            END IF
            IF cl_null(g_nmd.nmd231) THEN
               LET g_nmd.nmd231 = g_nms.nms151
            END IF
            DISPLAY BY NAME g_nmd.nmd23,g_nmd.nmd231
           #MOD-A20063---add---end---
            IF g_nmd.nmd31=99 AND cl_null(g_nmd.nmd02) THEN
               DISPLAY BY NAME g_nmd.nmd02
               NEXT FIELD nmd02
            END IF
            #應付電匯款沒有票號，預設單號
            IF g_nmd.nmd31 = '98' THEN
               LET g_nmd.nmd02 = g_nmd.nmd01
               DISPLAY BY NAME g_nmd.nmd02
            END IF
            IF NOT cl_null(g_nmd.nmd10) AND NOT cl_null(g_nmd.nmd101) THEN
              #No.FUN-A40054 -BEGIN-----
              #IF NOT cl_null(g_nmd.nmd34) THEN                                                                                     
              #   LET g_plant_new = g_nmd.nmd34                                                                                     
              #   CALL s_getdbs()                                                                                                   
              #   LET l_dbs = g_dbs_new                                                                                             
              #ELSE                                                                                                                 
              #   LET l_dbs = ''                                                                                                    
              #END IF
               LET l_dbs = ''
               LET l_plant = '' #FUN-A50102
              #No.FUN-A40054 -END-------
               LET l_cnt = 0                                                                                                        
               IF g_nmd.nmd40 = '1' THEN 
                  IF g_nmz.nmz05='Y' THEN                                                                                              
                     #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs,"aph_file,",l_dbs,"apf_file ",  
                     LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'aph_file'),",", #FUN-A50102
                                                         cl_get_target_table(l_plant,'apf_file'),     #FUN-A50102 
                                 " WHERE aph01 = ? ",                                                                                           
                                 "   AND aph02 = ? ",                                                                                           
                                 "   AND (aph03 = '1' OR aph03 ='C') ",                                                                         
                                 "   AND apf41 = 'Y' ",                  #MOD-A20121 add
                                 "   AND aph01 = apf01 AND apf44 IS NOT NULL AND apf44 != ' ' "                                                 
                  ELSE                                                                                                                 
                     #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs,"aph_file ", 
                     LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'aph_file'),",", #FUN-A50102   
                                                         cl_get_target_table(l_plant,'apf_file'),     #MOD-A20121 add
                                 " WHERE aph01 = ? ",                                                                                     
                                 "   AND aph02 = ? ",                                                                                     
                                 "   AND (aph03 = '1' OR aph03 = 'C') ",                                                                                    
                                 "   AND apf41 = 'Y' ",                    #MOD-A20121 add
                                 "   AND aph01 = apf01 "                   #MOD-A20121 add
                  END IF  #MOD-980101   
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
                  CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102                  
                  PREPARE t100_nmd101_chk4_p FROM g_sql                                                                                
                  EXECUTE t100_nmd101_chk4_p INTO l_cnt USING g_nmd.nmd10,g_nmd.nmd101                                                 
                 #來源有aapt330,anmt710,anmt720,三個都要檢查                                                                           
                  IF l_cnt = 0 THEN                                                                                                    
                 #檢查資料是否存在anmt710                                                                                           
                     #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs,"nne_file ",
                     LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'nne_file'), #FUN-A50102   
                                 " WHERE nne01 = ? ",            
                                 "   AND nneconf = 'Y' "           #MOD-A20121 add
                     CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
                     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
                     PREPARE t100_nmd101_chk5_p FROM g_sql                                                                             
                     EXECUTE t100_nmd101_chk5_p INTO l_cnt USING g_nmd.nmd10                                                           
                     IF l_cnt = 0 THEN                                                                                                 
                    #檢查資料是否存在anmt720                                                                                        
                        #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs,"nnh_file ", 
                        LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'nnh_file'),",", #FUN-A50102   
                                                            cl_get_target_table(l_plant,'nng_file'),     #MOD-A20121 add
                                    " WHERE nnh01 = ? ",                                                                               
                                    "   AND nnh02 = ? ",                                                                                
                                    "   AND nnh01 = nng01 AND nngconf = 'Y' "         #MOD-A20121 add
                        CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                        CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
                        PREPARE t100_nmd101_chk6_p FROM g_sql                                                                          
                        EXECUTE t100_nmd101_chk6_p INTO l_cnt USING g_nmd.nmd10,g_nmd.nmd101                                           
                     END IF                                                                                                            
                  END IF    
               ELSE
                  #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs,"oob_file,",l_dbs,"ooa_file ", 
                  LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'oob_file'),",", #FUN-A50102
                                                      cl_get_target_table(l_plant,'ooa_file'),     #FUN-A50102 
                                " WHERE oob01 = ? ",                                                                                
                                "   AND oob02 = ? ",                                                                                
                                "   AND ooa01 = oob01 ",                                                                            
                                #"   AND ooa37 = 'Y' "    #FUN-A40076 mark                                                                            
                                "   AND ooa37 = '2' "     #FUN-A40076 add                                                                          
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                  CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
                  PREPARE t100_nmd101_chk8_p FROM g_sql                                                                           
                  EXECUTE t100_nmd101_chk8_p INTO l_cnt USING g_nmd.nmd10,g_nmd.nmd101   
               END IF                           
  
               IF l_cnt = 0 THEN    #表示輸入的付款單不存在
                  CALL cl_err('','agl-118',0)   #無符合條件的資料,請重新輸入!
                  NEXT FIELD nmd101
               END IF
            END IF
       IF NOT cl_null(g_nmd.nmd10) AND NOT cl_null(g_nmd.nmd101) THEN
          SELECT COUNT(*) INTO l_count1 FROM nmd_file
           WHERE nmd10  = g_nmd.nmd10 
             AND nmd101 = g_nmd.nmd101
             AND nmd30 != 'X'
             AND nmd01 != g_nmd.nmd01       #MOD-950220
          IF l_count1 > 0 THEN 
             CALL cl_err('','anm-052',0)
             NEXT FIELD nmd10
          END IF    
       END IF 
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(nmd01)
                 LET g_t1 = s_get_doc_no(g_nmd.nmd01)       #No.FUN-550057
                 CALL q_nmy(FALSE,TRUE,g_t1,'1','ANM')  #TQC-670008 
                      RETURNING g_t1 #票據性質:應付票據
                 LET g_nmd.nmd01 = g_t1     #No.FUN-550057
                 DISPLAY BY NAME g_nmd.nmd01
                 NEXT FIELD nmd01
               WHEN INFIELD(nmd03) #銀行代號
                 #-MOD-B20043-add-
                  LET l_arg1 = 1 
                  IF NOT cl_null(g_nmd.nmd31) THEN
                     IF g_nmd.nmd31 = '98' THEN
                        LET l_arg1 = 23
                     END IF
                  END IF
                 #-MOD-B20043-end-
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma2"
                  LET g_qryparam.default1 = g_nmd.nmd03
                 #LET g_qryparam.arg1 = 1                #MOD-B20043 mark
                  #FUN-D80075--add--str--
                  IF g_aza.aza26='2' THEN
                     LET l_arg1=123
                  END IF
                  #FUN-D80075--add--end
                  LET g_qryparam.arg1 = l_arg1           #MOD-B20043
                  CALL cl_create_qry() RETURNING g_nmd.nmd03
                  DISPLAY BY NAME g_nmd.nmd03
                  CALL t100_nmd03('d')
                  NEXT FIELD nmd03
               WHEN INFIELD(nmd31) #發票簿號
                  #CHI-A90007 mark --start--
                  #CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_nna02"
                  #LET g_qryparam.default1 = g_nmd.nmd31
                  #LET g_qryparam.arg1 = g_nmd.nmd03
                  #CALL cl_create_qry() RETURNING g_nmd.nmd31
                  #CHI-A90007 mark --end--
                  #FUN-D80075--add--str--
                  IF g_aza.aza26='2' THEN
                     CALL q_nmw(FALSE,TRUE,'','') RETURNING g_nmd.nmd31,g_nmd.nmd54,g_nna03
                  ELSE
                  #FUN-D80075--add--end
                  CALL q_nmw(FALSE,TRUE,'',g_nmd.nmd03) RETURNING g_nmd.nmd31,g_nmd.nmd54,g_nna03 #CHI-A90007 add
                  END IF  #FUN-D80075
                  DISPLAY BY NAME g_nmd.nmd31
                  DISPLAY BY NAME g_nmd.nmd54 #CHI-A90007 add
                  NEXT FIELD nmd31
               WHEN INFIELD(nmd18) #
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = g_nmd.nmd18
                  CALL cl_create_qry() RETURNING g_nmd.nmd18
                  DISPLAY BY NAME g_nmd.nmd18
                  NEXT FIELD nmd18
               WHEN INFIELD(nmd08) #廠商編號
                  CALL cl_init_qry_var()
                  IF g_nmd.nmd40 = '1' THEN                    #MOD-CC0103 add
                     LET g_qryparam.form = "q_pmc"
                  ELSE                                         #MOD-CC0103 add
                     LET g_qryparam.form = "q_occ"             #MOD-CC0103 add
                  END IF                                       #MOD-CC0103 add
                  LET g_qryparam.default1 = g_nmd.nmd08
                  CALL cl_create_qry() RETURNING g_nmd.nmd08
                  DISPLAY BY NAME g_nmd.nmd08
                  CALL t100_nmd08('a')
                  NEXT FIELD nmd08
               WHEN INFIELD(nmd21) #幣別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi"
                  LET g_qryparam.default1 = g_nmd.nmd21
                  CALL cl_create_qry() RETURNING g_nmd.nmd21
                  DISPLAY BY NAME g_nmd.nmd21
                  NEXT FIELD nmd21
               WHEN INFIELD(nmd22) #廠商聯絡資料
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmd"
                  LET g_qryparam.default1 = g_nmd.nmd08
                  LET g_qryparam.arg1 = g_nmd.nmd08   #FUN-590125
                  CALL cl_create_qry() RETURNING g_nmd.nmd22
                  DISPLAY BY NAME g_nmd.nmd22
                  NEXT FIELD nmd22
               WHEN INFIELD(nmd23)
                  CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmd.nmd23,'23',g_aza.aza81)  #No.FUN-980025
                       RETURNING g_nmd.nmd23   
                  DISPLAY BY NAME g_nmd.nmd23
                  NEXT FIELD nmd23
               WHEN INFIELD(nmd231)
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmd.nmd231,'23',g_aza.aza82)  #No.FUN-980025
                      RETURNING g_nmd.nmd231   
                 DISPLAY BY NAME g_nmd.nmd231
                 NEXT FIELD nmd231
 
               WHEN INFIELD(nmd06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nmo01"
                  LET g_qryparam.default1 = g_nmd.nmd06
                  CALL cl_create_qry() RETURNING g_nmd.nmd06
                  DISPLAY BY NAME g_nmd.nmd06
                  NEXT FIELD nmd06
               WHEN INFIELD(nmd20)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nmo01"
                  LET g_qryparam.default1 = g_nmd.nmd20
                  CALL cl_create_qry() RETURNING g_nmd.nmd20
                  DISPLAY BY NAME g_nmd.nmd20
                  NEXT FIELD nmd20
               WHEN INFIELD(nmd17)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azf01a"    #No.FUN-930104
                  LET g_qryparam.default1 = g_nmd.nmd17
                  LET g_qryparam.arg1 = '8'          #No.FUN-930104
                  CALL cl_create_qry() RETURNING g_nmd.nmd17
                  DISPLAY BY NAME g_nmd.nmd17
                  CALL t100_nmd17('d')
                  NEXT FIELD nmd17
               WHEN INFIELD(nmd25) #變動碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nml"
                  LET g_qryparam.default1 = g_nmd.nmd25
                  CALL cl_create_qry() RETURNING g_nmd.nmd25
                  DISPLAY BY NAME g_nmd.nmd25
                  CALL t100_nmd25('d')
                  NEXT FIELD nmd25
              WHEN INFIELD(nmd19)
                   CALL s_rate(g_nmd.nmd21,g_nmd.nmd19) RETURNING g_nmd.nmd19
                   DISPLAY BY NAME g_nmd.nmd19
                   NEXT FIELD nmd19
              WHEN INFIELD(nmd10)                                                                                           
                   CALL cl_init_qry_var()                                                                                         
                   IF g_nmd.nmd40 = '1' THEN
                      LET g_qryparam.arg1 = g_nmd.nmd08   #MOD-AC0122
                      LET g_qryparam.form ="q_apf3"       #MOD-AC0122 mod
                   ELSE
                      LET g_qryparam.form ="q_ooa2"
                   END IF
                   LET g_qryparam.default1 = g_nmd.nmd10                                         
                   CALL cl_create_qry() RETURNING g_nmd.nmd10                                                                  
                   DISPLAY BY NAME g_nmd.nmd10
                   NEXT FIELD nmd10
             #No.FUN-A40054 -BEGIN-----
             #WHEN INFIELD(nmd34)                                                                                           
             #     CALL cl_init_qry_var()                                                                                         
             #     LET g_qryparam.form = "q_azw"     #FUN-990031 add
             #     LET g_qryparam.where = "azw02 = '",g_legal,"' "    #FUN-990031 add
             #     LET g_qryparam.default1 = g_nmd.nmd34                                         
             #     CALL cl_create_qry() RETURNING g_nmd.nmd34                                                                  
             #     DISPLAY BY NAME g_nmd.nmd34
             #     NEXT FIELD nmd34                   
             #No.FUN-A40054 -END-------
            END CASE
 
        ON ACTION draw_notes_payable
                 CALL cl_cmdrun_wait('anmt100'  CLIPPED)            #FUN-660216 add
 
        ON ACTION maintain_currency_data
                 CALL cl_cmdrun('aooi050'  CLIPPED) #No.MOD-480306
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
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
END FUNCTION
 
FUNCTION t100_chkbook()
  DEFINE l_sql        LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(300)
         l_len        LIKE type_file.num5,    #No.FUN-680107 SMALLINT
         l_point      LIKE type_file.num5,    #No.FUN-680107 SMALLINT
         l_no1,l_no2  LIKE nmd_file.nmd02,    #No.FUN-680107 VARCHAR(16) #No.FUN-550057
         l_nna04      LIKE nna_file.nna04,
         l_nna05      LIKE nna_file.nna05,
         l_nmw04      LIKE nmw_file.nmw04,
         l_nmw05      LIKE nmw_file.nmw05
 
    LET g_errno=' '
    IF cl_null(g_nmd.nmd31) THEN RETURN END IF #FUN-D80075
    #簿號=099 之支票號碼不check
    IF g_nmd.nmd31=99 THEN RETURN END IF
    #-->票號位數正確否
     SELECT nna04,nna05,nna06 INTO l_nna04,l_nna05,g_nna06
       FROM nna_file
      WHERE nna01 = g_nmd.nmd03
        AND nna02 = g_nmd.nmd31
        AND nna021= g_nmd.nmd54 #CHI-A90007 add 
       #CHI-A90007 mark --start--
       # AND nna021= (SELECT MAX(nna021) FROM nna_file
       #               WHERE nna01 = g_nmd.nmd03 AND
       #                     nna02 = g_nmd.nmd31)
       #CHI-A90007 mark --end--
     IF SQLCA.sqlcode THEN LET l_nna04 = 0 LET l_nna05 = 0 END IF
     IF l_nna04 IS NOT NULL AND l_nna04 > 0 AND      l_nna04 < 10
     THEN LET l_len = LENGTH(g_nmd.nmd02)
          #原判斷票號位數>設定位數 reject
          #修改為位數不合則reject
          IF l_len != l_nna04
          THEN LET g_errno = 'anm-135'
               RETURN
          END IF
     END IF
    #-->號碼檢查
    LET g_errno = 'anm-134'
    DECLARE t100_book_cur CURSOR FOR
            SELECT nmw04,nmw05 FROM nmw_file
             WHERE nmw01 = g_nmd.nmd03
               AND nmw06 = g_nmd.nmd31
    FOREACH t100_book_cur INTO l_nmw04,l_nmw05
        IF SQLCA.sqlcode THEN
           CALL cl_err('t100_book_cur',SQLCA.sqlcode,0) 
           EXIT FOREACH
        END IF
        IF g_nmd.nmd02 < l_nmw04 OR g_nmd.nmd02 >l_nmw05
        THEN LET g_errno = 'anm-134'
        ELSE LET g_errno = ''
             #-->票號前幾碼檢查
              IF l_nna05 < l_nna04
              THEN LET l_point = l_nna04 - l_nna05
                   LET l_no1   = g_nmd.nmd02[1,l_point] clipped
                   LET l_no2   = l_nmw04[1,l_point] clipped
                   IF l_no1 != l_no2 THEN
                      LET g_errno = 'anm-138'
                      CONTINUE FOREACH
                   ELSE EXIT FOREACH
                   END IF
              ELSE EXIT FOREACH
              END IF
        END IF
    END FOREACH
END FUNCTION
 
FUNCTION t100_nmd03(p_cmd)  #銀行代號
    DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           l_nma02    LIKE nma_file.nma02,
           l_nma10    LIKE nma_file.nma10,
           l_nma28    LIKE nma_file.nma28,
           l_nmaacti  LIKE nma_file.nmaacti,
           l_cnt      LIKE type_file.num5       #FUN-C80018
    LET g_errno = ' '
    SELECT nma02,nma10,nmaacti,nma28
           INTO l_nma02,l_nma10,l_nmaacti,l_nma28
           FROM nma_file
     WHERE nma01 = g_nmd.nmd03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-013'
                            LET l_nma02 = NULL
                            LET l_nma28 = NULL
         WHEN l_nmaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
   
   IF g_aza.aza26<>'2' THEN #FUN-D80075 add
   SELECT COUNT(*) INTO l_cnt FROM nna_file WHERE nna01=g_nmd.nmd03        #FUN-C80018
   #IF l_nma28 !='1'  THEN                                                  #MOD-B20043 mark
   #IF l_nma28 !='1' AND (g_nmd.nmd31 <> '98' OR cl_null(g_nmd.nmd31)) THEN #MOD-B20043      #FUN-C80018
    IF l_nma28 !='1' AND (g_nmd.nmd31 <> '98' OR cl_null(g_nmd.nmd31)) AND (g_aza.aza26!='2' OR l_cnt>0) THEN   #FUN-C80018
       LET g_errno = 'anm-251'
       LET l_nma02 = NULL
       LET l_nma28 = NULL
    END IF     #No.MOD-510041
   END IF #FUN-D80075 add

    IF NOT cl_null(g_errno) THEN RETURN END IF   #MOD-5A0390
 
    IF p_cmd = 'a' THEN
       LET g_nmd.nmd21 = l_nma10
       DISPLAY BY NAME g_nmd.nmd21
    END IF
    DISPLAY l_nma02 TO FORMONLY.nma02
END FUNCTION
 
FUNCTION t100_nmd18(p_cmd)  #部門代號
    DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           l_gem02    LIKE gem_file.gem02,
           l_gemacti  LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gem02,gemacti INTO l_gem02,l_gemacti
           FROM gem_file WHERE gem01 = g_nmd.nmd18
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-071'
                            LET l_gem02 = NULL
         WHEN l_gemacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gem02 TO FORMONLY.gem02
    END IF
    IF p_cmd = 'a' THEN
       IF g_nmz.nmz11 = 'Y'
       THEN LET g_dept = g_nmd.nmd18
       ELSE LET g_dept = ' '
       END IF
       SELECT * INTO g_nms.* FROM nms_file WHERE nms01 = g_dept
       IF STATUS THEN INITIALIZE g_nms.* TO NULL END IF
       LET g_nmd.nmd23 = g_nms.nms15
       IF g_aza.aza63 = 'Y' THEN 
       LET g_nmd.nmd231= g_nms.nms15
       END IF 
       DISPLAY BY NAME g_nmd.nmd23,g_nmd.nmd231
    END IF
END FUNCTION
 
FUNCTION t100_nmo(p_cmd,p_key,p_seq)  #票別
    DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           p_key      LIKE nmo_file.nmo01,
           p_seq      LIKE type_file.num5,    #No.FUN-680107 SMALLINT
           l_nmo02    LIKE nmo_file.nmo02,
           l_nmoacti  LIKE nmo_file.nmoacti
 
    LET g_errno = ' '
    SELECT nmo02,nmoacti INTO l_nmo02,l_nmoacti FROM nmo_file
           WHERE nmo01 = p_key
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-086'
                            LET l_nmo02 = NULL
         WHEN l_nmoacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
      IF p_seq = '1' THEN DISPLAY l_nmo02 TO nmo02  END IF
      IF p_seq = '2' THEN DISPLAY l_nmo02 TO nmo02_1  END IF
    END IF
END FUNCTION
 
FUNCTION t100_nmd08(p_cmd)  #廠商代號
    DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           l_pmc03    LIKE pmc_file.pmc03,
           l_pmc27    LIKE pmc_file.pmc27,
           l_pmc081   LIKE pmc_file.pmc081,
           l_pmcacti  LIKE pmc_file.pmcacti
    DEFINE l_occ02    LIKE occ_file.occ02       #MOD-CC0103 add
    DEFINE l_occ18    LIKE occ_file.occ18       #MOD-CC0103 add
    DEFINE l_occacti  LIKE occ_file.occacti     #MOD-CC0103 add
 
    LET g_errno = ' '
    IF g_nmd.nmd08 = 'MISC' THEN RETURN END IF
    IF g_nmd.nmd08 = 'EMPL' THEN RETURN END IF
    IF g_nmd.nmd40 = '1' THEN   #MOD-CC0103 add
       SELECT pmc03,pmc27,pmc081,pmcacti INTO l_pmc03,l_pmc27,l_pmc081,l_pmcacti
               FROM pmc_file
              WHERE pmc01 = g_nmd.nmd08 AND pmc30 IN ('2','3')
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-014'
                               LET l_pmc03 = NULL
            WHEN l_pmcacti='N' LET g_errno = '9028'
            WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
   #-------------------------------MOD-CC0103-----------------------(S)
    ELSE
       SELECT occ02,occ18,occacti INTO l_occ02,l_occ18,l_occacti  FROM occ_file
        WHERE occ01=g_nmd.nmd08 AND occacti IN ('Y','y')
        CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-045'
                                LET l_pmc03 = NULL
             WHEN l_occacti='N' LET g_errno = '9028'
             WHEN l_occacti MATCHES '[PH]'       LET g_errno = '9038'
             OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
        END CASE
    END IF
   #-------------------------------MOD-CC0103-----------------------(E)
    IF cl_null(g_errno) THEN
       IF g_nmd.nmd40 = '1' THEN   #MOD-CC0103 add
          LET g_nmd.nmd24 = l_pmc03
          LET g_nmd_o.nmd24 = g_nmd.nmd24
          LET g_nmd.nmd09 = l_pmc081
          LET g_nmd.nmd14 = l_pmc27
      #-----------------MOD-CC0103--------------------(S)
       ELSE
          LET g_nmd.nmd24 = l_occ02
          LET g_nmd_o.nmd24 = g_nmd.nmd24
          LET g_nmd.nmd09 = l_occ18
          LET g_nmd.nmd14 = '2'
       END IF
      #-----------------MOD-CC0103--------------------(E)
       IF g_nmd.nmd14 = '1' THEN
         SELECT pmd02 INTO g_nmd.nmd22
            FROM pmd_file
           WHERE pmd01 = g_nmd.nmd08 AND pmd05 = 'Y'
       END IF
       DISPLAY BY NAME g_nmd.nmd24,g_nmd.nmd09,g_nmd.nmd14,g_nmd.nmd22
    END IF
END FUNCTION
 
FUNCTION t100_nmd17(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
    DEFINE l_azfacti LIKE azf_file.azfacti
    DEFINE l_azf03   LIKE azf_file.azf03
    DEFINE l_azf09   LIKE azf_file.azf09    #No.FUN-930104
    SELECT azfacti,azf03,azf09 INTO l_azfacti,l_azf03,l_azf09 FROM azf_file  #No.FUN-930104
           WHERE azf01 = g_nmd.nmd17 AND azf02 = '2'                 
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = '100'
         WHEN l_azfacti = 'N'     LET g_errno = '9028'
         WHEN l_azf09 != '8'      LET g_errno = 'aoo-407'  #No.FUN-930104
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    DISPLAY l_azf03 TO azf03
END FUNCTION
 
FUNCTION t100_nmd25(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
    DEFINE l_nmlacti LIKE nml_file.nmlacti
    DEFINE l_nml02   LIKE nml_file.nml02
    SELECT nmlacti,nml02 INTO l_nmlacti,l_nml02 FROM nml_file
           WHERE nml01 = g_nmd.nmd25
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = '100'
         WHEN l_nmlacti = 'N'     LET g_errno = '9028'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    DISPLAY l_nml02 TO nml02
END FUNCTION
 
FUNCTION t100_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t100_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_nmd.nmd01 = NULL   #MOD-660086 add
       CLEAR FORM
       RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t100_count
    FETCH t100_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t100_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmd.nmd01,SQLCA.sqlcode,0)
        INITIALIZE g_nmd.* TO NULL
    ELSE
        CALL t100_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t100_fetch(p_flnmd)
    DEFINE
        p_flnmd         LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
        l_abso          LIKE type_file.num10   #No.FUN-680107 INTEGER
 
    CASE p_flnmd
        WHEN 'N' FETCH NEXT     t100_cs INTO g_nmd.nmd01
        WHEN 'P' FETCH PREVIOUS t100_cs INTO g_nmd.nmd01
        WHEN 'F' FETCH FIRST    t100_cs INTO g_nmd.nmd01
        WHEN 'L' FETCH LAST     t100_cs INTO g_nmd.nmd01
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
            FETCH ABSOLUTE g_jump t100_cs INTO g_nmd.nmd01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmd.nmd01,SQLCA.sqlcode,0)
        INITIALIZE g_nmd.* TO NULL             #No.FUN-6A0011
        RETURN
    ELSE
       CASE p_flnmd
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_nmd.* FROM nmd_file            # 重讀DB,因TEMP有不被更新特性
     WHERE nmd01 = g_nmd.nmd01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","nmd_file",g_nmd.nmd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
       INITIALIZE g_nmd.* TO NULL             #No.FUN-6A0011
    ELSE
       LET g_data_owner = g_nmd.nmduser     #No.FUN-4C0063
       LET g_data_group = g_nmd.nmdgrup     #No.FUN-4C0063
       CALL t100_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t100_show()
DEFINE  l_nmd12    LIKE nmd_file.nmd12   #No.FUN-680107 VARCHAR(04)
DEFINE  l_nmo02    LIKE nmo_file.nmo02   #No.FUN-680107 VARCHAR(24)
    LET g_nmd_t.* = g_nmd.*
            IF g_nmd.nmd40 = '1' THEN
               CALL cl_set_act_visible("qry_return_slip",FALSE)
               CALL cl_set_act_visible("qry_payment_slip",TRUE)
            END IF
            IF g_nmd.nmd40 = '2' THEN
               CALL cl_set_act_visible("qry_return_slip",TRUE)
               CALL cl_set_act_visible("qry_payment_slip",FALSE)
            END IF
    DISPLAY BY NAME g_nmd.nmdoriu,g_nmd.nmdorig,
        g_nmd.nmd01,g_nmd.nmd07,g_nmd.nmd03,g_nmd.nmd31,
        g_nmd.nmd02,g_nmd.nmd04,g_nmd.nmd21,
        g_nmd.nmd05,g_nmd.nmd06,g_nmd.nmd20,g_nmd.nmd25,
       #g_nmd.nmd18,g_nmd.nmd08,g_nmd.nmd24,g_nmd.nmd09,               #MOD-CC0103 mark	 
        g_nmd.nmd18,g_nmd.nmd40,g_nmd.nmd08,g_nmd.nmd24,g_nmd.nmd09,   #MOD-CC0103 
       #g_nmd.nmd40,    #MOD-CC0103 mark   #FUN-960141 add
        g_nmd.nmd10,g_nmd.nmd101,g_nmd.nmd34,
        g_nmd.nmd17,g_nmd.nmd27,
        g_nmd.nmd11,g_nmd.nmd12,g_nmd.nmd13,g_nmd.nmd19,
        g_nmd.nmd14,g_nmd.nmd22,g_nmd.nmd15,g_nmd.nmd16,g_nmd.nmd32,g_nmd.nmd30,
        g_nmd.nmd26,g_nmd.nmd29,g_nmd.nmd55, #FUN-C90122 add nmd55
        g_nmd.nmd23,g_nmd.nmd231,g_nmd.nmd54,  # No:FUN-680034    #MOD-AC0326 add nmd54
        g_nmd.nmduser,g_nmd.nmdgrup,g_nmd.nmdmodu,g_nmd.nmddate,
        g_nmd.nmdud01,g_nmd.nmdud02,g_nmd.nmdud03,g_nmd.nmdud04,
        g_nmd.nmdud05,g_nmd.nmdud06,g_nmd.nmdud07,g_nmd.nmdud08,
        g_nmd.nmdud09,g_nmd.nmdud10,g_nmd.nmdud11,g_nmd.nmdud12,
        g_nmd.nmdud13,g_nmd.nmdud14,g_nmd.nmdud15
 
    CALL t100_nmo('d',g_nmd.nmd06,'1')
    CALL t100_nmo('d',g_nmd.nmd20,'2')
    CALL t100_nmd03('d')
    CALL t100_nmd18('d')
    CALL t100_nmd17('d')
    CALL t100_nmd25('d')
    IF g_nmd.nmd30 = 'X' THEN
       LET g_void = 'Y'
    ELSE
       LET g_void = 'N'
    END IF
    CALL cl_set_field_pic(g_nmd.nmd30,"","","",g_void,"")
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t100_u()
DEFINE l_cnt      LIKe type_file.num5      #TQC-890020 add
DEFINE l_dbs      LIKE type_file.chr21     #MOD-980101
DEFINE l_plant    LIKE type_file.chr21     #FUN-A50102   
    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_nmd.* FROM nmd_file WHERE nmd01 = g_nmd.nmd01
    IF g_nmd.nmd30='Y' THEN CALL cl_err('','anm-137',1) RETURN END IF
    IF g_nmd.nmd30='X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_nmd.nmd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_nmd.nmd12 not matches '[X1]'
    THEN CALL cl_err('','anm-012',0) RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_nmd01_t = g_nmd.nmd01
    LET g_nmd03_t = g_nmd.nmd03
    LET g_nmd04_t = g_nmd.nmd04
    LET g_nmd_o.*=g_nmd.*
    LET g_success = 'Y'
    BEGIN WORK
 
    OPEN t100_cl USING g_nmd.nmd01
    #--Add exception check during OPEN CURSOR
    IF STATUS THEN
       CALL cl_err("OPEN t100_cl:", STATUS, 1)
       CLOSE t100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t100_cl INTO g_nmd.*               # 對DB鎖定
    IF STATUS THEN CALL cl_err(g_nmd.nmd01,STATUS,0) RETURN END IF
    LET g_nmd.nmdmodu=g_user                     #修改者
    LET g_nmd.nmddate = g_today                  #修改日期
    CALL t100_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t100_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_success = 'N'
            LET g_nmd.*=g_nmd_t.*
            CALL t100_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
           LET g_nmd.nmd33=g_nmd.nmd19
        UPDATE nmd_file SET nmd_file.* = g_nmd.*    # 更新DB
            WHERE nmd01 = g_nmd.nmd01             # COLAUTH?
        IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL cl_err3("upd","nmd_file",g_nmd01_t,"",SQLCA.sqlcode,"","t100_u:nmd",1)  #No.FUN-660148
            CONTINUE WHILE
        ELSE 
           CALL t100_hu(1,1)
          #當付款單+項次(nmd10+nmd101)修改時SET aph09='Y'
           IF NOT cl_null(g_nmd.nmd10) AND NOT cl_null(g_nmd.nmd101) THEN
             #檢查一下來源是不是aapt330,是的話才回寫
              IF g_nmd.nmd40 = '1' THEN   
              #No.FUN-A40054 -BEGIN-----
              #IF NOT cl_null(g_nmd.nmd34) THEN                                                                                     
              #   LET g_plant_new = g_nmd.nmd34                                                                                     
              #   CALL s_getdbs()                                                                                                   
              #   LET l_dbs = g_dbs_new                                                                                             
              #ELSE                                                                                                                 
                  LET l_dbs = ''
                  LET l_plant = '' #FUN-A50102                  
              #END IF
              #No.FUN-A40054 -END-------
                 LET l_cnt = 0                                                                                                        
                 IF g_nmz.nmz05='Y' THEN                                                                                              
                    #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs,"aph_file,",l_dbs,"apf_file ",
                    LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'aph_file'),",", #FUN-A50102
                                                        cl_get_target_table(l_plant,'apf_file'),     #FUN-A50102
                                " WHERE aph01 = ? ",                                                                                  
                                "   AND aph02 = ? ",                                                                                  
                                "   AND (aph03 = '1' OR aph03 ='C') ",                                                                
                                "   AND apf41 = 'Y' ",               #MOD-A20121 add
                                "   AND aph01 = apf01 AND apf44 IS NOT NULL AND apf44 != ' ' "                                        
                 ELSE                                                                                                                 
                    #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs,"aph_file ", 
                    LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'aph_file'),",", #FUN-A50102
                                                        cl_get_target_table(l_plant,'apf_file'),     #MOD-A20121 add
                                " WHERE aph01 = ? ",                                                                                  
                                "   AND aph02 = ? ",                                                                                  
                                "   AND (aph03 = '1' OR aph03 ='C') ",                                                                
                                "   AND apf41 = 'Y' ",               #MOD-A20121 add
                                "   AND aph01 = apf01 "              #MOD-A20121 add  
                 END IF                                                                                                               
                 CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                 CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
                 PREPARE t100_nmd101_chk_p_3 FROM g_sql                                                                               
                 EXECUTE t100_nmd101_chk_p_3 INTO l_cnt USING g_nmd.nmd10,g_nmd.nmd101     
                 IF l_cnt>0 THEN                                                                                                      
                    #LET g_sql = "UPDATE ",l_dbs,"aph_file ", 
                    LET g_sql = "UPDATE ",cl_get_target_table(l_plant,'aph_file'), #FUN-A50102
                                "   SET aph09 = 'Y'",                                                                                    
                                " WHERE aph01=?",                                                                                     
                                "   AND aph02=?",                                                                                     
                                "   AND (aph03='1' OR aph03='C')"                                                                     
                    CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
                    CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
                    PREPARE t100_nmd101_chk_p_4 FROM g_sql                                                                            
                    EXECUTE t100_nmd101_chk_p_4 USING g_nmd.nmd10,g_nmd.nmd101                                                        
                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN                                                                       
                       LET g_success = 'N'                                                                                            
                       CALL cl_err3("upd","aph_file",g_nmd.nmd10,g_nmd.nmd101,SQLCA.sqlcode,"","upd aph_file",1)                      
                    END IF                                                                                                            
                 END IF                      
              ELSE
                 UPDATE oob_file SET oob20 = 'Y'
                  WHERE oob01 = g_nmd.nmd10
                    AND oob02 = g_nmd.nmd101
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                    LET g_success = 'N'
                    CALL cl_err3("upd","aph_file",g_nmd.nmd10,g_nmd.nmd101,SQLCA.sqlcode,"","upd aph_file",1)  #No.FUN-660148
                 END IF
              END IF 
           END IF
          #-MOD-B60202-add-
          #舊付款單+項次更新aph09='N'
          #IF NOT cl_null(g_nmd_o.nmd10) AND NOT cl_null(g_nmd_o.nmd101) THEN       #MOD-B70095 mark
           IF NOT cl_null(g_nmd_o.nmd10) AND NOT cl_null(g_nmd_o.nmd101) AND        #MOD-B70095
              (g_nmd_o.nmd10 <> g_nmd.nmd10 OR g_nmd_o.nmd101 <> g_nmd.nmd101) THEN #MOD-B70095
              IF g_nmd.nmd40 = '1' THEN   
                 LET l_cnt = 0                                                                                                        
                 LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'aph_file'),",", #FUN-A50102
                                                     cl_get_target_table(l_plant,'apf_file'),     #MOD-A20121 add
                             " WHERE aph01 = ? ",                                                                                  
                             "   AND aph02 = ? ",                                                                                  
                             "   AND (aph03 = '1' OR aph03 ='C') ",                                                                
                             "   AND apf41 = 'Y' ",            
                             "   AND aph01 = apf01 "       
                 IF g_nmz.nmz05='Y' THEN                                                                                              
                    LET g_sql = g_sql CLIPPED," AND apf44 IS NOT NULL AND apf44 != ' ' "
                 END IF                                                                                                               
                 CALL cl_replace_sqldb(g_sql) RETURNING g_sql                                                                         
                 PREPARE t100_nmd101_chk_p_7 FROM g_sql                                                                               
                 EXECUTE t100_nmd101_chk_p_7 INTO l_cnt USING g_nmd_o.nmd10,g_nmd_o.nmd101  
                 IF l_cnt>0 THEN                                                                                                      
                    LET g_sql = "UPDATE ",cl_get_target_table(l_plant,'aph_file'), 
                                " SET aph09 = 'N'",                                                                                    
                                " WHERE aph01=?",                                                                                     
                                "   AND aph02=?",                                                                                     
                                "   AND (aph03='1' OR aph03='C')"                                                                     
                    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                                                                      
                    PREPARE t100_nmd101_chk_p_8 FROM g_sql                                                                            
                    EXECUTE t100_nmd101_chk_p_8 USING g_nmd_o.nmd10,g_nmd_o.nmd101                                                        
                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN                                                                       
                       LET g_success = 'N'                                                                                            
                       CALL cl_err3("upd","aph_file",g_nmd_o.nmd10,g_nmd_o.nmd101,SQLCA.sqlcode,"","upd aph_file",1) 
                    END IF                                                                                                            
                 END IF               
              ELSE
                 UPDATE oob_file SET oob20 = 'N'
                  WHERE oob01 = g_nmd_o.nmd10
                    AND oob02 = g_nmd_o.nmd101
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                    LET g_success = 'N'
                    CALL cl_err3("upd","aph_file",g_nmd_o.nmd10,g_nmd_o.nmd101,SQLCA.sqlcode,"","upd aph_file",1) 
                 END IF
              END IF 
           END IF
          #-MOD-B60202-end-
        END IF
        UPDATE nmf_file SET nmf01=g_nmd.nmd01 WHERE nmf01=g_nmd_t.nmd01
        EXIT WHILE
    END WHILE
    CLOSE t100_cl
       IF g_success = 'Y'
          THEN CALL cl_cmmsg(1) COMMIT WORK
               CALL cl_flow_notify(g_nmd.nmd01,'U')
          ELSE CALL cl_rbmsg(1) ROLLBACK WORK
       END IF
END FUNCTION
 
FUNCTION t100_m()
   DEFINE l_nmo02 LIKE nmo_file.nmo02
    IF s_shut(0) THEN RETURN END IF
    IF g_nmd.nmd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_nmd.* FROM nmd_file WHERE nmd01 = g_nmd.nmd01
    IF g_nmd.nmd30='X' THEN CALL cl_err('','9024',0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_success = 'Y'
    BEGIN WORK
    OPEN t100_cl USING g_nmd.nmd01
 
    IF STATUS THEN
       CALL cl_err("OPEN t100_cl:", STATUS, 1)
       CLOSE t100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t100_cl INTO g_nmd.*               # 對DB鎖定
    IF STATUS THEN CALL cl_err(g_nmd.nmd01,STATUS,0) RETURN END IF
    LET g_nmd.nmdmodu=g_user                     #修改者
    LET g_nmd.nmddate = g_today                  #修改日期
    CALL t100_show()                          # 顯示最新資料
    WHILE TRUE
        INPUT BY NAME g_nmd.nmd05,
                      g_nmd.nmd06,g_nmd.nmd20,g_nmd.nmd25,g_nmd.nmd18,
                      g_nmd.nmd17,g_nmd.nmd11,
                      g_nmd.nmd27,g_nmd.nmd14,
                      g_nmd.nmd22,g_nmd.nmd15,g_nmd.nmd16,
                      g_nmd.nmd32,g_nmd.nmd30,
                      g_nmd.nmd23,g_nmd.nmd231 # No.FUN-680034   
                   WITHOUT DEFAULTS
 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t100_set_entry('m')
            CALL t100_set_no_entry('m')
            LET g_before_input_done = TRUE
 
       AFTER FIELD nmd05   #到期日
           IF cl_null(g_nmd.nmd05) THEN
               CALL cl_err('','anm-003',0)
               NEXT  FIELD nmd05
           END  IF
           LET g_nmd_o.nmd05 = g_nmd.nmd05
 
       AFTER FIELD nmd06   #票別
           IF NOT cl_null(g_nmd.nmd06) THEN
              CALL t100_nmo('u',g_nmd.nmd06,'1')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nmd.nmd06,g_errno,0)
                 LET g_nmd.nmd06 =g_nmd_o.nmd06
                 NEXT FIELD nmd06
              END IF
              LET g_nmd_o.nmd06 =  g_nmd.nmd06
              #01/08/23 mandy 控管在票況為"1"(開立)時才讓User進入開票日(nmd05)
           END  IF
 
       AFTER FIELD nmd20   #票別
           IF NOT cl_null(g_nmd.nmd20) THEN
                 CALL t100_nmo('u',g_nmd.nmd20,'2')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nmd.nmd06,g_errno,0)
                    LET g_nmd.nmd20 =g_nmd_o.nmd20
                    NEXT FIELD nmd20
                 END IF
            END IF
            LET g_nmd_o.nmd20 =  g_nmd.nmd20
 
        BEFORE FIELD nmd27
            CALL t100_set_entry('u')
 
        AFTER FIELD nmd27
            CALL t100_set_no_entry('u')
 
        AFTER FIELD nmd25
            IF g_nmd.nmd25 IS NOT NULL THEN
               CALL t100_nmd25('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD nmd25
               END IF
            END IF
        AFTER FIELD nmd18
            IF g_nmz.nmz07 = 'N' AND cl_null(g_nmd.nmd18)
            THEN CALL cl_err(g_nmd.nmd18,'anm-152',0)
                 NEXT FIELD nmd18
            END IF
            IF not cl_null(g_nmd.nmd18) THEN
               CALL t100_nmd18('u')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nmd.nmd18,g_errno,0)
                  LET g_nmd.nmd18 = g_nmd_o.nmd18
                  DISPLAY BY NAME g_nmd.nmd18
                  NEXT FIELD nmd18
                END IF
            END IF
        AFTER FIELD nmd17
            IF g_nmd.nmd17 IS NOT NULL THEN
               CALL t100_nmd17('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD nmd17
               END IF
            END IF
        BEFORE FIELD nmd23
            IF cl_null(g_nmd.nmd23) THEN
                  IF g_nmz.nmz11 = 'Y'
                  THEN LET g_dept = g_nmd.nmd18
                  ELSE LET g_dept = ' '
                  END IF
                  SELECT * INTO g_nms.* FROM nms_file WHERE nms01 = g_dept
                  IF STATUS THEN INITIALIZE g_nms.* TO NULL END IF
                  LET g_nmd.nmd23 = g_nms.nms15
               DISPLAY BY NAME g_nmd.nmd23
            END IF

        AFTER FIELD nmd23
           IF g_nmz.nmz02 = 'Y' AND NOT cl_null(g_nmd.nmd23) THEN
              CALL s_m_aag(g_nmz.nmz02p,g_nmd.nmd23,g_aza.aza81) RETURNING g_msg      #NO.FUN-740028     #FUN-990069
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
#FUN-B20073 --begin--
                  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmd.nmd23,'23',g_aza.aza81)  
                       RETURNING g_nmd.nmd23   
                  DISPLAY BY NAME g_nmd.nmd23
#FUN-B20073 --end--                 
                 NEXT FIELD nmd23
              END IF
           END IF
      BEFORE FIELD nmd231
           IF cl_null(g_nmd.nmd231) THEN
                 IF g_nmz.nmz11 = 'Y'
                 THEN LET g_dept = g_nmd.nmd18
                 ELSE LET g_dept = ' '
                 END IF
                 SELECT * INTO g_nms.* FROM nms_file WHERE nms01 = g_dept
                 IF STATUS THEN INITIALIZE g_nms.* TO NULL END IF
                 LET g_nmd.nmd231 = g_nms.nms15
              DISPLAY BY NAME g_nmd.nmd231
           END IF
 
       AFTER FIELD nmd231
          IF g_nmz.nmz02 = 'Y' AND NOT cl_null(g_nmd.nmd231) THEN
             CALL s_m_aag(g_nmz.nmz02,g_nmd.nmd231,g_aza.aza82) RETURNING g_msg        #NO.FUN-740028        #FUN-990069
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
#FUN-B20073 --begin--
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmd.nmd231,'23',g_aza.aza82)
                      RETURNING g_nmd.nmd231   
                DISPLAY BY NAME g_nmd.nmd231
#FUN-B20073 --end--                
                NEXT FIELD nmd231
             END IF
          END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(nmd06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nmo01"
                 LET g_qryparam.default1 = g_nmd.nmd06
                 CALL cl_create_qry() RETURNING g_nmd.nmd06
                 DISPLAY BY NAME g_nmd.nmd06
                 NEXT FIELD nmd06
              WHEN INFIELD(nmd20)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nmo01"
                 LET g_qryparam.default1 = g_nmd.nmd20
                 CALL cl_create_qry() RETURNING g_nmd.nmd20
                 DISPLAY BY NAME g_nmd.nmd20
                 NEXT FIELD nmd20
               WHEN INFIELD(nmd25) #變動碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nml"
                  LET g_qryparam.default1 = g_nmd.nmd25
                  CALL cl_create_qry() RETURNING g_nmd.nmd25
                  DISPLAY BY NAME g_nmd.nmd25
                  NEXT FIELD nmd25
               WHEN INFIELD(nmd18) #
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = g_nmd.nmd18
                  CALL cl_create_qry() RETURNING g_nmd.nmd18
                  DISPLAY BY NAME g_nmd.nmd18
                  NEXT FIELD nmd18
               WHEN INFIELD(nmd17)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azf01a"      #No.FUN-930104
                  LET g_qryparam.default1 = g_nmd.nmd17
                  LET g_qryparam.arg1 = '8'            #No.FUN-930104      
                  CALL cl_create_qry() RETURNING g_nmd.nmd17
                  DISPLAY BY NAME g_nmd.nmd17
                  CALL t100_nmd17('d')
                  NEXT FIELD nmd17
               WHEN INFIELD(nmd23)
                  CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmd.nmd23,'23',g_aza.aza81)                  #No.FUN-980025
                       RETURNING g_nmd.nmd23   
                  DISPLAY BY NAME g_nmd.nmd23
                  NEXT FIELD nmd23
               WHEN INFIELD(nmd231)
                  CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmd.nmd231,'23',g_aza.aza82)                 #No.FUN-980025
                      RETURNING g_nmd.nmd231   
                 DISPLAY BY NAME g_nmd.nmd231
                 NEXT FIELD nmd231
 
               WHEN INFIELD(nmd22) #廠商聯絡資料
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmd"
                  LET g_qryparam.default1 = g_nmd.nmd08
                  LET g_qryparam.arg1 = g_nmd.nmd08   #FUN-590125
                  CALL cl_create_qry() RETURNING g_nmd.nmd22
                  DISPLAY BY NAME g_nmd.nmd22
                  NEXT FIELD nmd22
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
            LET g_success = 'N'
            LET g_nmd.*=g_nmd_t.*
            CALL t100_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE nmd_file SET nmd_file.* = g_nmd.*    # 更新DB
            WHERE nmd01 = g_nmd.nmd01             # COLAUTH?
        IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL cl_err3("upd","nmd_file",g_nmd.nmd01,"",SQLCA.sqlcode,"","t100_u:nmd",1)  #No.FUN-660148
            CONTINUE WHILE
        END IF
        UPDATE nme_file SET nme14 = g_nmd.nmd25 WHERE nme12 = g_nmd.nmd01
        IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL cl_err3("upd","nme_file",g_nmd.nmd01,"",SQLCA.sqlcode,"","t100_u:nme",1)  #No.FUN-660148
            CONTINUE WHILE
        END IF
        #--->更新
        UPDATE nmf_file SET nmf11 = g_nmd.nmd27,  #傳票編號
                            nmf13 = g_nmd.nmd07   #傳票日期
                            WHERE nmf01 = g_nmd.nmd01 AND nmf05 = '0'
         IF SQLCA.sqlcode THEN  #No.MOD-480246
            LET g_success = 'N'
            CALL cl_err3("upd","nmf_file",g_nmd.nmd01,"",SQLCA.sqlcode,"","t100_u:nmf",1)  #No.FUN-660148
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t100_cl
       IF g_success = 'Y'
          THEN CALL cl_cmmsg(1) COMMIT WORK
          ELSE CALL cl_rbmsg(1) ROLLBACK WORK
       END IF
END FUNCTION
 
FUNCTION t100_c()
    DEFINE
        l_chr   LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
    DEFINE l_cnt LIKE type_file.num5   #MOD-820172
 
    INITIALIZE g_nnz.* TO NULL
    IF s_shut(0) THEN RETURN END IF
    IF g_nmd.nmd01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_nmd.* FROM nmd_file WHERE nmd01 = g_nmd.nmd01
    IF g_nmd.nmd02 IS NULL THEN
       RETURN
    END IF
    IF g_nmd.nmd30='X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF NOT cl_confirm('axr-152') THEN RETURN END IF
    SELECT * INTO g_nmd.* FROM nmd_file WHERE nmd01 = g_nmd.nmd01
    IF g_nmd.nmd12 != '1' AND g_nmd.nmd12 != 'X' THEN
       CALL cl_err('','anm-012',0) RETURN
    END IF
    LET g_success = 'Y'
    BEGIN WORK
    UPDATE nmd_file SET nmd02 = '' WHERE nmd01 = g_nmd.nmd01
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       LET g_success = 'N'
       CALL cl_err3("upd","nmd_file",g_nmd.nmd01,"",SQLCA.sqlcode,"","t100_u:nmf",1)  #No.FUN-660148
    END IF
    LET l_cnt = 0 
    SELECT COUNT(*) INTO l_cnt FROM ala_file
      WHERE ala931= g_nmd.nmd01
    IF l_cnt > 0 THEN
       UPDATE ala_file SET ala932=''
         WHERE ala931=g_nmd.nmd01
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]= 0  THEN
          LET g_success = 'N' 
          CALL cl_err3("upd","ala_file",g_nmd.nmd01,"",STATUS,"","upd ala:",1) 
       END IF
    END IF
 
    LET g_nnz.nnz01 = g_nmd.nmd03
    LET g_nnz.nnz02 = g_nmd.nmd02
    LET g_nnz.nnz03 = 'Delete From ',g_nmd.nmd01
    LET g_nnz.nnzuser = g_user
    LET g_nnz.nnzgrup = g_grup
    LET g_nnz.nnzmodu = ' '
    LET g_nnz.nnzdate = g_today
    LET g_nnz.nnzoriu = g_user      #No.FUN-980030 10/01/04
    LET g_nnz.nnzorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO nnz_file VALUES(g_nnz.*)
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","nnz_file",g_nnz.nnz01,g_nnz.nnz02,SQLCA.sqlcode,"","t150_ins_nnz",1)  #No.FUN-660148
        LET g_success = 'N'
    END IF
    LET g_nmd.nmd02 = ''
    CALL t100_show()
    IF g_success = 'Y'
       THEN CALL cl_cmmsg(1) COMMIT WORK
    ELSE CALL cl_rbmsg(1) ROLLBACK WORK
    END IF
END FUNCTION
 
#作廢功能 add 01/08/14
#FUNCTION t100_x()                        #FUN-D20035
FUNCTION t100_x(p_type)                   #FUN-D20035
    DEFINE p_type    LIKE type_file.chr1  #FUN-D20035
    DEFINE l_flag    LIKE type_file.chr1  #FUN-D20035
    DEFINE l_begin    LIKE nmw_file.nmw04
    DEFINE l_end      LIKE nmw_file.nmw05
    DEFINE max_nmd02  LIKE nmd_file.nmd02
    DEFINE l_chr      LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
    DEFINE l_cnt      LIKE type_file.num5     #MOD-820172
    DEFINE l_msg      STRING                  #MOD-B30084 add
    DEFINE l_dbs      LIKE type_file.chr21    #MOD-B30084 add
 
    IF s_shut(0) THEN RETURN END IF
    IF g_nmd.nmd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_nmd.* FROM nmd_file WHERE nmd01 = g_nmd.nmd01
    IF g_nmd.nmd30='Y' THEN CALL cl_err('','anm-139',1)  RETURN END IF
    IF g_nmd.nmd12 != '1' THEN CALL cl_err('','anm-012',0) RETURN END IF

    #FUN-D20035---begin
   IF p_type = 1 THEN
      IF g_nmd.nmd30 ='X' THEN RETURN END IF
   ELSE
      IF g_nmd.nmd30 <>'X' THEN RETURN END IF
   END IF
   #FUN-D20035---end

    LET g_success = 'Y'
    BEGIN WORK
 
    OPEN t100_cl USING g_nmd.nmd01
    IF STATUS THEN
       CALL cl_err("OPEN t100_cl:", STATUS, 1)
       CLOSE t100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t100_cl INTO g_nmd.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmd.nmd01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t100_show()
   #IF cl_void(0,0,g_nmd.nmd30) THEN                                    #FUN-D20035
    IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF    #FUN-D20035
    IF cl_void(0,0,l_flag) THEN                                         #FUN-D20035
      #IF g_nmd.nmd30='N' THEN    #切換為作廢                           #FUN-D20035
       IF p_type = 1 THEN                                               #FUN-D20035
          IF NOT cl_null(g_nmd.nmd02) THEN
             SELECT nmw04,nmw05 INTO l_begin,l_end FROM nmw_file
              WHERE nmw01 = g_nmd.nmd03 AND nmw06 = g_nmd.nmd31
             SELECT MAX(nmd02) INTO max_nmd02 FROM nmd_file
              WHERE nmd03 = g_nmd.nmd03 AND nmd31= g_nmd.nmd31
                AND nmd02 BETWEEN l_begin AND l_end
             IF max_nmd02 >= g_nmd.nmd02 THEN
                #已有大於或等於本張票號的單據...
                CALL cl_err(g_nmd.nmd02,'anm-963',1)
                UPDATE nmd_File SET nmd02 = null
                 WHERE nmd01 = g_nmd.nmd01
                IF STATUS THEN
                   CALL cl_err3("upd","nmd_File",g_nmd.nmd01,"","upd nmd","","",1)  #No.FUN-660148
                   LET g_success='N'
                END IF
                LET l_cnt = 0 
                SELECT COUNT(*) INTO l_cnt FROM ala_file
                  WHERE ala931= g_nmd.nmd01
                IF l_cnt > 0 THEN
                   UPDATE ala_file SET ala932=''
                     WHERE ala931=g_nmd.nmd01
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]= 0  THEN
                      CALL cl_err3("upd","ala_file",g_nmd.nmd01,"",STATUS,"","upd ala:",1) 
                      LET g_success = 'N' 
                   END IF
                END IF
             END IF
          END IF
          LET g_nmd.nmd30='X'
          CALL t100_hu(1,0)
         #str MOD-B30084 add
         #當作廢時需SET aph09='N'
          IF NOT cl_null(g_nmd.nmd10) AND NOT cl_null(g_nmd.nmd101) THEN
            #檢查一下來源是不是aapt330,是的話才回寫
             LET l_cnt = 0
             SELECT COUNT(*) INTO l_cnt FROM aph_file
              WHERE aph01 = g_nmd.nmd10
                AND aph02 = g_nmd.nmd101
                AND aph03 = '1'
             IF l_cnt > 0 THEN
                UPDATE aph_file SET aph09 = 'N'
                 WHERE aph01 = g_nmd.nmd10
                   AND aph02 = g_nmd.nmd101
                   AND aph03 = '1'
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                   LET g_success = 'N'
                   CALL cl_err3("upd","aph_file",g_nmd.nmd10,g_nmd.nmd101,SQLCA.sqlcode,"","upd aph_file",1)  #No.FUN-660148
                   LET g_success='N'
                END IF
             END IF
          END IF
         #end MOD-B30084 add
       ELSE                       #取消作廢
         #LET g_nmd.nmd30='N'   #MOD-B30084 mark
         #CALL t100_hu(0,1)     #MOD-B30084 mark
         #str MOD-B30084 add
         #取消作廢時,需檢查對應的付款單+項次是否已有另外開票,若有則不可取消作廢
          IF NOT cl_null(g_nmd.nmd10) AND NOT cl_null(g_nmd.nmd101) THEN
             LET l_cnt = 0
             SELECT COUNT(*) INTO l_cnt FROM nmd_file
              WHERE nmd10 = g_nmd.nmd10
                AND nmd101= g_nmd.nmd101
                AND nmd01 !=g_nmd.nmd01
                AND nmd30 !='X'
             IF l_cnt > 0 THEN
                LET l_msg=''
                LET l_msg=g_nmd.nmd10 CLIPPED,"+",g_nmd.nmd101 CLIPPED
                CALL cl_err(l_msg,'anm-168',1) 
                RETURN
             ELSE
                #檢查一下來源是不是aapt330,是的話才回寫
                IF NOT cl_null(g_nmd.nmd34) THEN                                                                                     
                   LET g_plant_new = g_nmd.nmd34                                                                                     
                   CALL s_getdbs()                                                                                                   
                   LET l_dbs = g_dbs_new                                                                                             
                ELSE                                                                                                                 
                   LET l_dbs = ''                                                                                                    
                END IF                                                                                                               
                LET l_cnt = 0                                                                                                        
                IF g_nmz.nmz05='Y' THEN                                                                                              
                   LET g_sql = "SELECT COUNT(*) FROM ",l_dbs,"aph_file,",l_dbs,"apf_file ",                                          
                               " WHERE aph01 = ? ",
                               "   AND aph02 = ? ",
                               "   AND (aph03 = '1' OR aph03 ='C') ",
                               "   AND apf41= 'Y' ",
                               "   AND aph01 = apf01 AND apf44 IS NOt NULL AND apf44 != ' ' "
                ELSE
                   LET g_sql = "SELECT COUNT(*) FROM ",l_dbs,"aph_file,",l_dbs,"apf_file ",
                               " WHERE aph01 = ? ",
                               "   AND aph02 = ? ",
                               "   AND (aph03 = '1' OR aph03 ='C') ",
                               "   AND apf41= 'Y' ",
                               "   AND aph01 = apf01 "
                END IF                                                                                                               
                CALL cl_replace_sqldb(g_sql) RETURNING g_sql                                                                         
                PREPARE t100_nmd101_chk_p_5 FROM g_sql                                                                               
                EXECUTE t100_nmd101_chk_p_5 INTO l_cnt USING g_nmd.nmd10,g_nmd.nmd101
                IF l_cnt>0 THEN
                   LET g_sql = "UPDATE ",l_dbs,"aph_file ",
                               "SET aph09 = 'Y'",
                               " WHERE aph01=?",
                               "   AND aph02=?",
                               "   AND (aph03='1' OR aph03='C')"
                   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                   PREPARE t100_nmd101_chk_p_6 FROM g_sql
                   EXECUTE t100_nmd101_chk_p_6 USING g_nmd.nmd10,g_nmd.nmd101
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                      LET g_success = 'N'
                      CALL cl_err3("upd","aph_file",g_nmd.nmd10,g_nmd.nmd101,SQLCA.sqlcode,"","upd aph_file",1)
                   END IF
                END IF
                LET g_nmd.nmd30='N'
                CALL t100_hu(0,1)
             END IF
          ELSE
             LET g_nmd.nmd30='N'
             CALL t100_hu(0,1)
          END IF
         #end MOD-B30084 add
       END IF
       UPDATE nmd_file SET nmd30 = g_nmd.nmd30
        WHERE nmd01 = g_nmd.nmd01
       IF STATUS THEN 
          CALL cl_err3("upd","nmd_File",g_nmd.nmd01,"",STATUS,"","",1)  #No.FUN-660148
          LET g_success='N' 
       END IF
       IF SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","nmd_File",g_nmd.nmd01,"","aap-061","","",1)  #No.FUN-660148
          LET g_success='N'
       END IF
    END IF
    SELECT nmd02,nmd30 INTO g_nmd.nmd02,g_nmd.nmd30 FROM nmd_file
     WHERE nmd01 = g_nmd.nmd01
    DISPLAY BY NAME g_nmd.nmd30
    DISPLAY BY NAME g_nmd.nmd02
    CLOSE t100_cl
    IF g_success = 'Y'
       THEN CALL cl_cmmsg(1) COMMIT WORK
            CALL cl_flow_notify(g_nmd.nmd01,'V')
       ELSE CALL cl_rbmsg(1) ROLLBACK WORK
    END IF
END FUNCTION
 
FUNCTION t100_r()
    DEFINE l_chr    LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           g_ala01  LIKE ala_file.ala01,    #No.MOD-530818
           l_ala931 LIKE ala_file.ala931,    #No.MOD-530818
           l_ala12  LIKE ala_file.ala12     #No.FUN-B50066
 
    IF s_shut(0) THEN RETURN END IF
    IF g_nmd.nmd01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    SELECT * INTO g_nmd.* FROM nmd_file WHERE nmd01 = g_nmd.nmd01
    IF g_nmd.nmd30='Y' THEN CALL cl_err('','anm-139',1)  RETURN END IF
    IF g_nmd.nmd30='X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_nmd.nmd12 != '1' THEN CALL cl_err('','anm-012',0) RETURN END IF
    LET g_success = 'Y'
    BEGIN WORK
    OPEN t100_cl USING g_nmd.nmd01
    IF STATUS THEN
       CALL cl_err("OPEN t100_cl:", STATUS, 1)
       CLOSE t100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t100_cl INTO g_nmd.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmd.nmd01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t100_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "nmd01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_nmd.nmd01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
         DELETE FROM nmd_file WHERE nmd01 = g_nmd.nmd01 #PHYSICAL DELETE
           IF SQLCA.sqlcode THEN
              LET g_success = 'N'
              CALL cl_err3("del","nmd_file",g_nmd.nmd01,"",SQLCA.sqlcode,"","(t100_r:delete nmd)",1)  #No.FUN-660148
           END IF
           SELECT COUNT(*) INTO g_cnt FROM nnf_file
            WHERE nnf06 = g_nmd.nmd01
           IF g_cnt > 0 THEN
              UPDATE nnf_file SET nnf06 = NULL
               WHERE nnf06 = g_nmd.nmd01
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                 LET g_success = 'N'
                 CALL cl_err3("upd","nnf_file",g_nmd.nmd01,"",SQLCA.sqlcode,"","upd nnf_file",1)  #No.FUN-660148
              END IF
           END IF
           DELETE FROM nmf_file WHERE nmf01=g_nmd_t.nmd01
           #MOD-D90111 add begin-------------
           IF SQLCA.sqlcode THEN
              LET g_success = 'N'
              CALL cl_err3("del","nmf_file",g_nmd_t.nmd01,"",SQLCA.sqlcode,"","(t100_r:delete nmf)",1) 
           END IF
           #MOD-D90111 add end--------------
           SELECT COUNT(*) INTO g_cnt FROM nnh_file
            WHERE nnh01 = g_nmd.nmd10
              AND nnh02 = g_nmd.nmd101
           IF g_cnt > 0 THEN
              UPDATE nnh_file SET nnh06=NULL
               WHERE nnh01 = g_nmd.nmd10
                 AND nnh02 = g_nmd.nmd101
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                 LET g_success = 'N'
                 CALL cl_err3("upd","nnh_file",g_nmd.nmd10,g_nmd.nmd101,SQLCA.sqlcode,"","upd nnh_file",1)  #No.FUN-660148
              END IF
           END IF
           SELECT COUNT(*) INTO g_cnt FROM nnk_file
            WHERE nnk21 = g_nmd.nmd01
           IF g_cnt > 0 THEN
              UPDATE nnk_file SET nnk21=NULL
               WHERE nnk21 = g_nmd.nmd01
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                 LET g_success = 'N'
                 CALL cl_err3("upd","nnk_file",g_nmd.nmd01,"",SQLCA.sqlcode,"","upd nnh_file",1)  #No.FUN-660148
              END IF
           END IF
           ##1999/08/04 modify by sophia若已沖帳且aph09為'Y'
           IF g_nmd.nmd40 = '1' THEN
              SELECT COUNT(*) INTO g_cnt FROM aph_file
               WHERE aph01 = g_nmd.nmd10
                 AND aph02 = g_nmd.nmd101
              IF g_cnt > 0 THEN
                 UPDATE aph_file SET aph09 = 'N'
                  WHERE aph01 = g_nmd.nmd10
                    AND aph02 = g_nmd.nmd101
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                    LET g_success = 'N'
                    CALL cl_err3("upd","aph_file",g_nmd.nmd10,g_nmd.nmd101,SQLCA.sqlcode,"","upd aph_file",1)  #No.FUN-660148
                 END IF
              END IF
            END IF
            IF g_nmd.nmd40 = '2' THEN
               LEt g_cnt = 0 
               SELECT COUNT(*) INTO g_cnt FROM oob_file,ooa_file
                WHERE oob01 = g_nmd.nmd10
                  AND oob02 = g_nmd.nmd101 
                  AND ooa01 = oob01
                  #AND ooa37 = 'Y'  #FUN-A40076 mark
                  AND ooa37 = '2'   #FUN-A40076 add
               IF g_cnt > 0 THEN
                  UPDATE oob_file SET oob20 = 'N'
                   WHERE oob01 = g_nmd.nmd10
                     AND oob02 = g_nmd.nmd101
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                     LET g_success = 'N'
                     CALL cl_err3("upd","oob_file",g_nmd.nmd10,g_nmd.nmd101,SQLCA.sqlcode,"","upd aph_file",1)  #No.FUN-660148
                  END IF
               END IF
            END IF
         SELECT ala01 INTO g_ala01 FROM ala_file
          WHERE ala931 = g_nmd.nmd01
         IF NOT cl_null(g_ala01) THEN
            LET l_ala931 = s_get_doc_no(g_nmd.nmd01)       #No.FUN-550057
            UPDATE ala_file SET ala931 = l_ala931
             WHERE ala01 = g_ala01
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               LET g_success = 'N'
               CALL cl_err3("upd","ala_file", g_ala01,"",SQLCA.sqlcode,"","upd ala_file",1)  #No.FUN-660148
            END IF
         END IF
         #No.FUN-B50066  --Begin
         LET g_ala01 = ''
         SELECT ala01 INTO g_ala01 FROM ala_file
          WHERE ala12 = g_nmd.nmd01
         IF NOT cl_null(g_ala01) THEN
            LET l_ala12 = s_get_doc_no(g_nmd.nmd01)
            UPDATE ala_file SET ala12 = l_ala12
             WHERE ala01 = g_ala01
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               LET g_success = 'N'
               CALL cl_err3("upd","ala_file", g_ala01,"",SQLCA.sqlcode,"","upd ala_file",1)
            END IF
         END IF
         #No.FUN-B50066  --End
         CLEAR FORM
         CALL t100_hu(1,0)
            LET g_msg=TIME #MOD-D90111 add
            INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azplegal)  #FUN-980005 add plant & legal 
           # VALUES ('anmt110',g_user,g_today,g_msg,g_nmd.nmd01,'Delete',g_palnt,g_legal) #MOD-D90111 mark
           VALUES ('anmt110',g_user,g_today,g_msg,g_nmd.nmd01,'Delete',g_plant,g_legal) #MOD-D90111 add
    END IF
    CLOSE t100_cl
    IF g_success = 'Y' THEN
       CALL cl_cmmsg(1)
       COMMIT WORK
       CALL cl_flow_notify(g_nmd.nmd01,'D')
       OPEN t100_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE t100_cl
          CLOSE t100_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end-- 
       FETCH t100_count INTO g_row_count
       #FUN-B50065-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t100_cl
          CLOSE t100_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t100_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t100_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t100_fetch('/')
       END IF
    ELSE
       CALL cl_rbmsg(1)
       ROLLBACK WORK
    END IF
END FUNCTION
 
FUNCTION t100_out()
    DEFINE
        l_i             LIKE type_file.num5,    #No.FUN-680107 SMALLINT
        l_name          LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
        l_nmd           RECORD LIKE nmd_file.*,
        l_za05          LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(40)
        l_chr           LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
    DEFINE l_nma02               LIKE nma_file.nma02  #NO.FUN-830149
    DEFINE l_nmo02_1,l_nmo02_2   LIKE nmo_file.nmo02  #NO.FUN-830149
    DEFINE l_sta                 LIKE ze_file.ze03    #NO.FUN-830149
    CALL cl_del_data(l_table)                         #NO.FUN-830149
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM nmd_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE t100_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t100_co CURSOR FOR t100_p1
 
 
    FOREACH t100_co INTO l_nmd.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
            END IF
         SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=l_nmd.nmd21  
         SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=l_nmd.nmd03
         LET l_nmo02_1 = ''
         LET l_nmo02_2 = ''
         SELECT nmo02 INTO l_nmo02_1 FROM nmo_file WHERE nmo01 = l_nmd.nmd06
         SELECT nmo02 INTO l_nmo02_2 FROM nmo_file WHERE nmo01 = l_nmd.nmd20
         LET l_sta = ' '
            CALL s_nmdsta(l_nmd.nmd12) RETURNING l_sta
         EXECUTE insert_prep USING
            l_nmd.nmd01,l_nmd.nmd30,l_nmd.nmd03,l_nma02,l_nmd.nmd02,l_nmd.nmd04,
            l_nmo02_1,l_nmo02_2,l_nmd.nmd08,l_nmd.nmd24,l_sta,l_nmd.nmd14,
            l_nmd.nmd07,l_nmd.nmd05,t_azi04
    END FOREACH
 
     LET g_sql = " SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(g_wc,'nmd01,nmd07,nmd03,nmd31,nmd02,nmd21,nmd19,nmd04,nmd26,nmd05,
                             nmd06,nmd20,nmd25,nmd18,nmd08,nmd24,nmd09,nmd10,nmd101,nmd34,
                             nmd17,nmd11,nmd12,nmd27,nmd13,nmd29,nmd30,nmd32,nmd14,nmd22,
                             nmd15,nmd16,nmd23,nmd231,nmduser,nmdgrup,nmdmodu,nmddate ')
             RETURNING g_wc
     END IF
     LET g_str = g_wc,";",g_azi05
     CALL cl_prt_cs3('anmt100','anmt100',g_sql,g_str)
    CLOSE t100_co
    ERROR ""
END FUNCTION
FUNCTION t100_hu(r_sw,u_sw)
DEFINE   r_sw      LIKE type_file.num5,    #No.FUN-680107 SMALLINT
         u_sw      LIKE type_file.num5     #No.FUN-680107 SMALLINT
      CALL t100_hu_nmf(r_sw,u_sw)
        IF g_success = 'N' THEN RETURN END IF
      CALL t100_hu_nma(r_sw,u_sw)
        IF g_success = 'N' THEN RETURN END IF
END FUNCTION
 
FUNCTION t100_hu_nmf(r_sw,u_sw)
DEFINE   r_sw      LIKE type_file.num5,    #No.FUN-680107 SMALLINT  #舊資料還原
         u_sw      LIKE type_file.num5     #No.FUN-680107 SMALLINT  #新資料更新
 
    IF r_sw AND u_sw THEN
       UPDATE nmf_file
          SET nmf04 = g_user,
              nmf07 = g_nmd.nmd08,
              nmf08 = 0,
              nmf09 = g_nmd.nmd19,
              nmf11 = g_nmd.nmd27,
              nmf13 = g_nmd.nmd07
       WHERE nmf01 = g_nmd.nmd01
       IF SQLCA.sqlcode THEN
          LET g_success = 'N'
          CALL cl_err3("upd","nmf_file",g_nmd.nmd01,"",SQLCA.sqlcode,"","(t100_hu_nmf:update nmf)",1)  #No.FUN-660148
       END IF
       RETURN
    END IF
    IF r_sw THEN
         DELETE FROM nmf_file WHERE nmf01 = g_nmd.nmd01
       IF SQLCA.sqlcode THEN
          LET g_success = 'N'
          CALL cl_err3("del","nmf_file",g_nmd.nmd01,"",SQLCA.sqlcode,"","(t100_hu_nmf:delete nmf)",1)  #No.FUN-660148
       END IF
    END IF
    IF u_sw THEN
       INSERT INTO nmf_file(nmf01,nmf02,nmf03,nmf04,
                            nmf05,nmf06,nmf07,nmf08,nmf09,nmf11,nmf13,nmflegal)  #FUN-980005 add legal 
                   VALUES(g_nmd.nmd01,g_nmd.nmd07,'1',g_user,
 
                   '0','1',g_nmd.nmd08,0,g_nmd.nmd19,g_nmd.nmd27,g_nmd.nmd07,g_legal)  #FUN-980005 add legal
       IF SQLCA.sqlcode THEN
          LET g_success = 'N'
          CALL cl_err3("ins","nmf_file",g_nmd.nmd01,"",SQLCA.sqlcode,"","(t100_hu_nmf:insert nmf)",1)  #No.FUN-660148
       END IF
    END IF
END FUNCTION
 
FUNCTION t100_hu_nma(r_sw,u_sw)
DEFINE   r_sw      LIKE type_file.num5,    #No.FUN-680107 SMALLINT  #舊資料還原
         u_sw      LIKE type_file.num5     #No.FUN-680107 SMALLINT  #新資料更新
    IF r_sw  THEN
{ckp#1}    UPDATE nma_file SET nma25 = nma25 - g_nmd_t.nmd04
                 WHERE nma01= g_nmd_t.nmd03
           IF SQLCA.sqlcode THEN
              LET g_success = 'N'
              CALL    cl_err('(t100_hu_nma:ckp#1)',SQLCA.sqlcode,1)
              RETURN
           END IF
    END IF
    IF u_sw  THEN
{ckp#2}    UPDATE nma_file SET nma25 = nma25 + g_nmd.nmd04
                 WHERE nma01= g_nmd.nmd03
           IF SQLCA.sqlcode THEN
              LET g_success = 'N'
              CALL cl_err3("upd","nma_file",g_nmd.nmd03,"",SQLCA.sqlcode,"","(t100_hu_nma:ckp#2)",1)  #No.FUN-660148
              RETURN
           END IF
    END IF
END FUNCTION
 
FUNCTION t100_hu_pmc(r_sw,u_sw)
DEFINE   r_sw      LIKE type_file.num5,    #No.FUN-680107 SMALLINT  #舊資料還原
         u_sw      LIKE type_file.num5     #No.FUN-680107 SMALLINT  #新資料更新
 
    IF r_sw  THEN
{ckp#1}    UPDATE pmc_file SET pmc46 = pmc46 - g_nmd_t.nmd04
                 WHERE pmc01= g_nmd_t.nmd08
           IF SQLCA.sqlcode THEN
              LET g_success = 'N'
              CALL cl_err3("upd","pmc_file",g_nmd_t.nmd08,"",SQLCA.sqlcode,"","(t100_hu_pmc:ckp#1)",1)  #No.FUN-660148
              RETURN
           END IF
    END IF
    IF u_sw  THEN
{ckp#2}    UPDATE pmc_file SET pmc46 = pmc46 + g_nmd.nmd04
                 WHERE pmc01= g_nmd.nmd08
           IF SQLCA.sqlcode THEN
              LET g_success = 'N'
              CALL cl_err3("upd","pmc_file",g_nmd.nmd08,"",SQLCA.sqlcode,"","(t100_hu_pmc:ckp#2)",1)  #No.FUN-660148
              RETURN
           END IF
    END IF
END FUNCTION
 
FUNCTION t100_firm1()
   DEFINE l_nmd01   LIKE nmd_file.nmd01,
          l_nmd02   LIKE nmd_file.nmd02,
          l_nmd03   LIKE nmd_file.nmd03,   #MOD-5A0201
          l_nmd07   LIKE nmd_file.nmd07,
          l_nmd31   LIKE nmd_file.nmd31,   #MOD-5A0201
          l_nmd54   LIKE nmd_file.nmd54,   #TQC-B10069
          l_nmd30   LIKE nmd_file.nmd30,   #TQC-B10069
          l_nna06   LIKE nna_file.nna06
   DEFINE only_one  LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_nma12   LIKE nma_file.nma12    #No.TQC-6C0037                                                                             
   DEFINE l_npx01   LIKE npx_file.npx01    #No.TQC-6C0037
   DEFINE l_n       LIKE type_file.num5    #No.TQC-6C0037
   DEFINE l_nna021  LIKE nna_file.nna021   #MOD-A70045 
#FUN-CB0049--add--str--
   DEFINE l_flag    LIKE type_file.chr1,
          l_bookno1 LIKE aza_file.aza82,
          l_bookno2 LIKE aza_file.aza82
#FUN-CB0049--add--end
 
   LET g_success = 'Y'
  #IF cl_null(g_nmd.nmd03) OR cl_null(g_nmd.nmd31) THEN  #MOD-B90087 mark
   IF cl_null(g_nmd.nmd03) THEN                 #MOD-B90087 add
   #  CALL cl_err('','mfg6138',1)               #TQC-B10069
   #  CALL s_errmsg("nmd01","","",'mfg6138',1)  #TQC-B10069 #MOD-B90087 mark
      CALL s_errmsg("nmd03","","",'mfg6138',1)  #MOD-B90087 add
      LET g_success = 'N'                       #TQC-B10069
   #  RETURN        #TQC-B10069
   END IF
   IF g_aza.aza26 <> '2' THEN    #MOD-D90006 
   IF cl_null(g_nmd.nmd31) THEN                 #MOD-B90087 add
      CALL s_errmsg("nmd31","","",'mfg6138',1)  #MOD-B90087 add
      LET g_success = 'N'                       #MOD-B90087 add
   #  RETURN                                    #MOD-B90087 add   #TQC-B10069
   END IF                                       #MOD-B90087 add
   END IF   #MOD-D90006
   IF g_nmd.nmd30 = 'Y' THEN                                                    
   #  CALL cl_err('','9023',0)     #TQC-B10069 
      CALL s_errmsg("nmd01",g_nmd.nmd01,g_nmd.nmd30,'9023',1)  #TQC-B10069              
      LET g_success = 'N'                                      #TQC-B10069                                 
   #  RETURN       #TQC-B10069                                                             
   END IF                                                                       
 
  IF g_aza.aza26 = '2' THEN  #yinhy130923
  #----------------MOD-C80098----------------mark
  ##No.MOD-C30021  --Begin
  IF cl_null(g_nmd.nmd02) THEN     
     CALL s_errmsg("nmd02","","",'mfg6138',1) 
     LET g_success = 'N'     
     RETURN   #yinhy130923
  END IF     
  ##No.MOD-C30021  --End
  #----------------MOD-C80098----------------mark
  END IF     #yinhy130923
   
   OPEN WINDOW t100_w3 AT 10,11 WITH FORM "anm/42f/anmt1001"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("anmt1001")
 
 
   LET only_one = '1'
   INPUT BY NAME only_one WITHOUT DEFAULTS
     AFTER FIELD only_one
      IF only_one IS NULL THEN NEXT FIELD only_one END IF
      IF only_one NOT MATCHES "[12]" THEN NEXT FIELD only_one END IF
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
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t100_w3 RETURN END IF
   IF only_one = '1' THEN
      IF cl_null(g_nmd.nmd01) THEN
         CLOSE WINDOW t100_w3
         RETURN
      END IF
      SELECT * INTO g_nmd.* FROM nmd_file WHERE nmd01 = g_nmd.nmd01
      IF g_nmd.nmd30 = 'Y' THEN
         CLOSE WINDOW t100_w3
         RETURN
      END IF
      IF g_nmd.nmd30 = 'X' THEN
      #  CALL cl_err('','9024',0)                                 #TQC-B10069
         CALL s_errmsg("nmd01",g_nmd.nmd01,g_nmd.nmd30,'9024',1)  #TQC-B10069
         LET g_success = 'N'                                      #TQC-B10069
         CLOSE WINDOW t100_w3
         RETURN
      END IF
      LET g_wc = " nmd01 = '",g_nmd.nmd01,"' "
      ELSE
         CONSTRUCT BY NAME g_wc ON nmd01,nmd07
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
            ON ACTION controlp
               CASE
                  WHEN INFIELD(nmd01)
                     LET g_t1 = s_get_doc_no(g_nmd.nmd01)       #No.FUN-550057
                     CALL q_nmy(TRUE,TRUE,g_t1,'1','ANM')  #TQC-670008
                        RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO nmd01
                     NEXT FIELD nmd01
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
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
         END CONSTRUCT
         IF INT_FLAG THEN
            LET INT_FLAG=0
            CLOSE WINDOW t100_w3
            RETURN
         END IF
         IF NOT cl_sure(20,20) THEN
            CLOSE WINDOW t100_w3
            RETURN
         END IF
   END IF
   #資料權限的檢查
 
   MESSAGE "WORKING !"
   LET g_sql = "SELECT nmd01,nmd02,nmd03,nmd07,nmd31 FROM nmd_file ",   #MOD-5A0201
               " WHERE nmd30 = 'N' AND ",g_wc CLIPPED
   PREPARE t100_firm1_p1 FROM g_sql
#TQC-B10069 ---------------------Begin----------------------------
  #IF STATUS THEN CALL cl_err('t100_firm1_p1',STATUS,1) END IF   
   IF STATUS THEN
      CALL s_errmsg("","",'t100_firm1_p1','STATUS',1)   
      LET g_success = 'N'                       
   END IF
#TQC-B10069 ---------------------End -----------------------------
   DECLARE t100_firm1_curs CURSOR FOR t100_firm1_p1
 
   LET g_success = 'Y'
   BEGIN WORK
 
   OPEN t100_cl USING g_nmd.nmd01
   IF STATUS THEN
   #  CALL cl_err("OPEN t100_cl:", STATUS, 1)          #TQC-B10069 
      CALL s_errmsg("","","OPEN t100_cl:",'STATUS',1)  #TQC-B10069
      LET g_success = 'N'                              #TQC-B10069
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t100_cl INTO g_nmd.*
   IF SQLCA.sqlcode THEN
   #  CALL cl_err(g_nmd.nmd01,SQLCA.sqlcode,0)          #TQC-B10069
      CALL s_errmsg("",g_nmd.nmd01,"FETCH t100_cl:",'SQLCA.sqlcode',1)  #TQC-B10069
      LET g_success = 'N'                               #TQC-B10069
      ROLLBACK WORK
      RETURN
   END IF
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p FROM g_sql
   EXECUTE nmz10_p INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
#  CALL s_showmsg_init()   #No.FUN-710024     #TQC-B10069
   FOREACH t100_firm1_curs INTO l_nmd01,l_nmd02,l_nmd03,l_nmd07,l_nmd31,l_nmd54   #MOD-5A0201 #TQC-B10069 add nmd54
      IF STATUS THEN
         CALL s_errmsg('','','foreach',STATUS,1)
         LET g_success='N' EXIT FOREACH
      END IF

#No.CHI-A80036   ---begin---
    IF g_aza.aza26 <> '2' THEN                          #MOD-D90006
      IF cl_null(l_nmd03) OR cl_null(l_nmd31) THEN
         CALL s_errmsg('','',l_nmd01,'aap999',1)
         LET g_success='N'
         CONTINUE FOREACH 
      END IF
#No.CHI-A80036   ---end---
#No.MOD-D90006 --Begin
    ELSE
      IF cl_null(l_nmd03) THEN
         LET g_success='N'
         CONTINUE FOREACH
      END IF
    END IF
#No.MOD-D90006 --End
      IF l_nmd07 <= g_nmz.nmz10 THEN #no.5261
         CALL s_errmsg('','',l_nmd01,'aap-176',1)    
         LET g_success='N' 
         CONTINUE FOREACH
      END IF
      SELECT nna06 INTO l_nna06 FROM nna_file
       WHERE nna01 = l_nmd03   #MOD-5A0201
         AND nna02 = l_nmd31   #MOD-5A0201
         AND nna021= g_nmd.nmd54 #CHI-A90007 add
        #CHI-A90007 mark --start--
        # AND nna021= (SELECT MAX(nna021) FROM nna_file
        #              WHERE nna01 = g_nmd.nmd03 AND
        #                    nna02 = g_nmd.nmd31)
        #CHI-A90007 mark --end--
      IF cl_null(l_nmd02) AND l_nna06 = 'N' THEN
         CALL s_errmsg('nna01',l_nmd03,l_nmd01,'anm-011',1)
         LET g_success = 'N'                       #TQC-B10069
         CONTINUE FOREACH
      END IF

   #FUN-CB0049--add--str--
      CALL s_get_doc_no(l_nmd01) RETURNING g_t1
      SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
      #若單別須拋轉總帳, 檢查分錄底稿平衡正確否
      IF cl_null(g_nmy.nmyglcr) THEN LET g_nmy.nmyglcr = 'N' END IF
      CALL s_get_bookno(YEAR(g_nmd.nmd07)) RETURNING l_flag,l_bookno1,l_bookno2
      IF l_flag = '1' THEN
         CALL s_errmsg('','',YEAR(g_nmd.nmd07),'aoo-081',1)
         LET g_success='N'
         CONTINUE FOREACH
      END IF
      #CALL s_chknpq(g_nmd.nmd01,'NM',g_nmd.nmd12,'0',l_bookno1) #FUN-DA0047 mark
      CALL s_chknpq(g_nmd.nmd01,'NM',10,'0',l_bookno1) #FUN-DA0047
      IF g_aza.aza63 = 'Y' THEN
         #CALL s_chknpq(g_nmd.nmd01,'NM',g_nmd.nmd12,'1',l_bookno2) #FUN-DA0047 mark
         CALL s_chknpq(g_nmd.nmd01,'NM',10,'1',l_bookno2) #FUN-DA0047
      END IF
  #FUN-CB0049--add--end

      UPDATE nmd_file SET nmd30 = 'Y' WHERE nmd01 = l_nmd01
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('nna01',l_nmd03,l_nmd01,'anm-011',0)
         LET g_success = 'N'                       #TQC-B10069
      END IF
   END FOREACH  
   CLOSE WINDOW t100_w3 
   #SELECT nmd30 INTO g_nmd.nmd30 FROM nmd_file WHERE nmd01 = g_nmd.nmd01 #FUN-CB0049 mark
   #DISPLAY g_nmd.nmd30 TO nmd30    #FUN-CB0049 mark                                      
  #CALL s_showmsg()          #No.FUN-710024      #TQC-B10069
      IF g_success='Y' THEN
         COMMIT WORK 
         CALL cl_flow_notify(g_nmd.nmd01,'Y')
         IF g_nmd.nmd31 <> '99' AND g_nmd.nmd31 <> '98' THEN  #No.5058  
            SELECT COUNT(*) INTO l_n FROM nna_file,nma_file                                                                            
             WHERE nna01 = nma01                                                                                                       
               AND nna01 = g_nmd.nmd03 
               AND nna02 = g_nmd.nmd31
            IF l_n = 0 THEN                                                                                                            
            #  CALL cl_err('','anm-954',0)          #TQC-B10069 
               CALL s_errmsg("nmd01",l_nmd01,l_nmd03,'anm-954',0) #TQC-B10069 
               LET g_success = 'N'                                #TQC-B10069                                                                                  
            ELSE                                                                                                                       
               SELECT nna06,nna03 INTO g_nna06,g_nna03 FROM nna_file                                                                   
                WHERE nna01 = g_nmd.nmd03                                                                                              
                  AND nna02 = g_nmd.nmd31                                                                                              
                  AND nna021= g_nmd.nmd54 #CHI-A90007 add          
                 #CHI-A90007 mark --start--
                 # AND nna021= (SELECT MAX(nna021) FROM nna_file                                                                        
                 #      WHERE nna01 = g_nmd.nmd03 AND nna02 = g_nmd.nmd31)                                                              
                 #CHI-A90007 mark --end--
            END IF                                                                                                                     
         END IF                                                                                                                        
         IF (g_nmd.nmd02 IS NULL OR g_nmd.nmd02 = ' ' )
         AND g_nna06 MATCHES '[yY]' THEN                                                                                               
             IF cl_confirm('anm-016') THEN                                                                                             
                SELECT nma12 INTO l_nma12 FROM nma_file  #取套印程式代號  #No.TQC-6                                                    
                 WHERE nma01 = g_nmd.nmd03 
                IF cl_null(l_nma12) THEN                                                                                               
                #  CALL cl_err('','anm-049',1)                           #TQC-B10069
                   CALL s_errmsg("nmd01",l_nmd01,l_nmd03,'anm-049',1)    #TQC-B10069
                   LET g_success = 'N'                                   #TQC-B10069       
                ELSE                                                                                                                   
                 #CHI-A90007 mark --start--
                 ##-MOD-A70045-add-
                 # SELECT MAX(nna021) INTO l_nna021 
                 #   FROM nna_file                                                                        
                 #  WHERE nna01 = g_nmd.nmd03 AND nna02 = g_nmd.nmd31
                 ##-MOD-A70045-end-
                 #CHI-A90007 mark --end--
                   LET l_wc = 'nmd01="',g_nmd.nmd01,'"'
                   LET l_wc2= '',g_nmd.nmd03,''       
                   LET l_wc3= '',g_nna03,''          
                   LET l_wc4= '',g_nmd.nmd31,''      
                   LET l_cmd = l_nma12 CLIPPED,                                                                                        
                               " '",g_today CLIPPED,"' ''",
                               " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",   #No.MOD-4B0281
                               " '",l_wc CLIPPED,"' ",
                               " '",l_wc2 CLIPPED,"'",
                               " '",l_wc4 CLIPPED,"'",                        #MOD-A70045
                              #" '",l_nna021 CLIPPED,"'",                     #MOD-A70045 #CHI-A90007 mark
                               " '",g_nmd.nmd54 CLIPPED,"'",                  #CHI-A90007
                               " '",l_wc3 CLIPPED,"'"                         #MOD-A70045
                              #" '','','','','','','','2'"   #MOD-9C0242 add  #MOD-A10047 mark
                  #IF l_nma12='anmr185' THEN   #FUN-C30085 mark                                                                                         
                   IF l_nma12='anmg185' THEN   #FUN-C30085 add
                      DECLARE t100_npx_cs CURSOR FOR                                                                                   
                      SELECT npx01 FROM npx_file WHERE npx02=g_nmd.nmd03 
                      OPEN t100_npx_cs                                                                                                 
                      FETCH t100_npx_cs INTO l_npx01                                                                                   
                      CLOSE t100_npx_cs                                                                                                
                      LET l_wc5='',l_npx01,''                                                                                          
                      LET l_cmd = l_cmd CLIPPED ," '",l_wc5 CLIPPED,"'"," 'Y' 'Y' '2'"   #MOD-810002  #MOD-A10047 add '2'
                   END IF                                                                                                              
                    display l_cmd                                                                                                      
                    CALL cl_cmdrun_wait(l_cmd)       
                   SELECT nmd02 INTO g_nmd.nmd02 FROM nmd_file 
                          WHERE nmd01 = g_nmd.nmd01           
                   DISPLAY BY NAME g_nmd.nmd02               
                END IF                                                                                                                 
             END IF                                                                                                                    
         END IF                                                                                                                        
      ELSE
         ROLLBACK WORK
      END IF
   SELECT nmd30 INTO g_nmd.nmd30 FROM nmd_file WHERE nmd01 = g_nmd.nmd01 #FUN-CB0049 add
   DISPLAY g_nmd.nmd30 TO nmd30 #FUN-CB0049 add
   CALL cl_set_field_pic(g_nmd.nmd30,"","","","N","")  #MOD-AC0073 
END FUNCTION
 
FUNCTION t100_firm2()
   DEFINE only_one      LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_cnt         LIKE type_file.num10   #No.FUN-680107 INTEGER
 
   IF cl_null(g_nmd.nmd01) THEN RETURN END IF
   SELECT * INTO g_nmd.* FROM nmd_file WHERE nmd01 = g_nmd.nmd01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","nmd_file",g_nmd.nmd01,"",SQLCA.sqlcode,"","sel nmd",1)  #No.FUN-660148
      RETURN
   END IF
   IF g_nmd.nmd30 = 'N' THEN RETURN END IF
   IF g_nmd.nmd30 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   #-->有異動資料不可刪除
  #SELECT COUNT(*) INTO l_cnt FROM npm_file WHERE npm03=g_nmd.nmd01 #MOD-B10165 mark
  #-MOD-B10165-add-
   SELECT COUNT(*) INTO l_cnt 
     FROM npl_file,npm_file
    WHERE npl01 = npm01 
      AND nplconf <> 'X'
      AND npm03 = g_nmd.nmd01
  #-MOD-B10165-end-
   IF l_cnt>0 THEN
      CALL cl_err('','anm-242',0) RETURN
   END IF
   #-->目前票況為'X'或'1' 才可取消確認
   IF g_nmd.nmd12 != 'X' AND g_nmd.nmd12 != '1' THEN
      CALL cl_err('','anm-141',0) RETURN
   END IF
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p1 FROM g_sql
   EXECUTE nmz10_p1 INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_nmd.nmd07 <= g_nmz.nmz10 THEN #no.5261
      CALL cl_err(g_nmd.nmd01,'aap-176',1) RETURN
   END IF
   SELECT nna06 INTO g_nna06 FROM nna_file
    WHERE nna01 = g_nmd.nmd03
      AND nna02 = g_nmd.nmd31
      AND nna021= g_nmd.nmd54 #CHI-A90007 add 
     #CHI-A90007 mark --start--
     # AND nna021= (SELECT MAX(nna021) FROM nna_file
     #      WHERE nna01 = g_nmd.nmd03 AND nna02 = g_nmd.nmd31)
     #CHI-A90007 mark --end--
   IF g_nna06 = 'Y' AND NOT cl_null(g_nmd.nmd02) THEN
      CALL cl_err('','anm1015',1)
      RETURN
   END IF 
 
   #-->確認
   IF cl_confirm('aap-224') THEN
      LET g_success = 'Y'
      BEGIN WORK
      OPEN t100_cl USING g_nmd.nmd01
      IF STATUS THEN
         CALL cl_err("OPEN t100_cl:", STATUS, 1)
         CLOSE t100_cl
         ROLLBACK WORK
         RETURN
      END IF
      FETCH t100_cl INTO g_nmd.*
      IF SQLCA.sqlcode THEN
          CALL cl_err(g_nmd.nmd01,SQLCA.sqlcode,0)
          ROLLBACK WORK RETURN
      END IF
        MESSAGE "WORKING !"
        UPDATE nmd_file SET nmd30 = 'N' WHERE nmd01 = g_nmd.nmd01
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","nmd_file",g_nmd.nmd01,"",SQLCA.sqlcode,"","upd nmd_file",1)  #No.FUN-660148
             LET g_success ='N'
        END IF
      IF g_success = 'Y'
      THEN CALL cl_cmmsg(1) COMMIT WORK
      ELSE CALL cl_rbmsg(1) ROLLBACK WORK
      END IF
      SELECT nmd30 INTO g_nmd.nmd30 FROM nmd_file WHERE nmd01=g_nmd.nmd01
      DISPLAY BY NAME g_nmd.nmd30
   END IF
END FUNCTION
 
FUNCTION t100_chgdbs()
  DEFINE l_dbs  LIKE type_file.chr21   #No.FUN-680107 VARCHAR(21)
 
   COMMIT WORK
            LET INT_FLAG = 0  ######add for prompt bug
   PROMPT 'PLANT CODE:' FOR g_plant
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
   END IF
   IF g_plant IS NULL THEN RETURN END IF
   SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_plant
   IF STATUS THEN ERROR 'WRONG database!' RETURN END IF
   DATABASE l_dbs
   CALL cl_ins_del_sid(1,g_plant) #FUN-980030  #FUN-990069
   IF STATUS THEN ERROR 'open database error!' RETURN END IF
   LET g_plant = g_plant
   LET g_dbs   = l_dbs
   CURRENT WINDOW IS SCREEN
   CALL cl_dsmark(0)
   CURRENT WINDOW IS t100_w
   CLEAR FORM
   CALL t100_lock_cur()
END FUNCTION
 
FUNCTION t100_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
DEFINE   l_cnt   LIKE type_file.num5    #FUN-C80018  
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("nmd04",TRUE)
      CALL cl_set_comp_entry("nmd08",TRUE)
      CALL cl_set_comp_entry("nmd10",TRUE)
      CALL cl_set_comp_entry("nmd101",TRUE)
      CALL cl_set_comp_entry("nmd19",TRUE)
      CALL cl_set_comp_entry("nmd21",TRUE)
      CALL cl_set_comp_entry("nmd26",TRUE)
     #CALL cl_set_comp_entry("nmd34",TRUE)    #No.FUN-A40054
      CALL cl_set_comp_entry("nmd01",TRUE)
      CALL cl_set_comp_entry("nmd40",TRUE)    #FUN-960141 add
   END IF
   #IF INFIELD (nmd31) OR NOT g_before_input_done THEN   #No.TQC-B30122
   IF INFIELD (nmd54) OR NOT g_before_input_done THEN    #No.TQC-B30122
      CALL cl_set_comp_entry("nmd02",TRUE)
   END IF
   IF NOT g_before_input_done THEN
      CALL cl_set_comp_entry("nmd05",TRUE)
   END IF
   IF NOT g_before_input_done THEN
      CALL cl_set_comp_entry("nmd23",TRUE)
   END IF
  IF g_aza.aza63 = 'Y' THEN
     IF NOT g_before_input_done THEN
       CALL cl_set_comp_entry("nmd231",TRUE)
     END IF
  END IF
  CALL cl_set_comp_entry("nmd17",TRUE)  #FUN-960141
END FUNCTION
 
FUNCTION t100_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
DEFINE   l_cnt   LIKE type_file.num5    #FUN-C80018
   IF( p_cmd = 'u' OR p_cmd = 'm')
      AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("nmd01",FALSE)
      CALL cl_set_comp_entry("nmd40",FALSE)    #FUN-960141 add
      IF g_nmd.nmd12 = 'X' THEN
         CALL cl_set_comp_entry("nmd04",FALSE)
         CALL cl_set_comp_entry("nmd08",FALSE)
         CALL cl_set_comp_entry("nmd10",FALSE)
         CALL cl_set_comp_entry("nmd101",FALSE)
         CALL cl_set_comp_entry("nmd19",FALSE)
         CALL cl_set_comp_entry("nmd21",FALSE)
         CALL cl_set_comp_entry("nmd26",FALSE)
        #CALL cl_set_comp_entry("nmd34",FALSE) #No.FUN-A40054
      END IF
   END IF

   IF g_aza.aza26<>'2' THEN #FUN-D80075 
   SELECT COUNT(*) INTO l_cnt  FROM nna_file WHERE nna01=g_nmd.nmd03         #FUN-C80018
   #IF INFIELD (nmd31) AND g_before_input_done THEN  #No.TQC-B30122
   IF INFIELD (nmd54) AND g_before_input_done THEN   #No.TQC-B30122
   #  IF g_nna06 MATCHES '[Yy]' OR cl_null(g_nmd.nmd31)  THEN #套印 No.3485   #MOD-5B0335  #FUN-C80018
      IF (g_nna06 MATCHES '[Yy]' OR cl_null(g_nmd.nmd31)) AND (g_aza.aza26!='2' OR l_cnt>0)  THEN #FUN-C80018
         CALL cl_set_comp_entry("nmd02",FALSE)
      END IF
   END IF
   END IF #FUN-D80075
 
   IF p_cmd = 'm' AND NOT g_before_input_done THEN
      IF g_nmd.nmd12 != '1' THEN #開立
         CALL cl_set_comp_entry("nmd05",FALSE)
      END IF
   END IF
 
   IF g_nmd.nmd40 = '2' THEN
      CALL cl_set_comp_entry("nmd17",FALSE)
   END IF 
 
END FUNCTION
 
#修改寄領方式
FUNCTION t100_ms()
 IF s_shut(0) THEN RETURN END IF
 IF g_nmd.nmd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 IF g_nmd.nmd30 = 'X' THEN                                                      
    CALL cl_err('','atm-127',0)                                                 
    RETURN                                                                      
 END IF                                                                         
 
 CALL t100_show()
 IF NOT cl_null(g_nmd.nmd15) THEN
    RETURN
 END IF
 
 BEGIN WORK
 OPEN t100_cl USING g_nmd.nmd01
 IF STATUS THEN
    CALL cl_err("OPEN t100_cl:", STATUS, 1)
    CLOSE t100_cl
    ROLLBACK WORK
    RETURN
 END IF
 
 FETCH t100_cl INTO g_nmd.*               # 對DB鎖定
 IF STATUS THEN CALL cl_err(g_nmd.nmd01,STATUS,0) RETURN END IF
 LET g_nmd.nmdmodu=g_user                     #修改者
 LET g_nmd.nmddate = g_today                  #修改日期
 
 INPUT BY NAME g_nmd.nmd14 WITHOUT DEFAULTS
 
 UPDATE nmd_file SET nmd14 = g_nmd.nmd14,
                     nmdmodu=g_nmd.nmdmodu,
                     nmddate=g_nmd.nmddate
            WHERE nmd01 = g_nmd.nmd01        
 IF SQLCA.sqlcode THEN
    #ROLLBACK WORK
    LET g_success = 'N'
    CALL cl_err3("upd","nmd_file",g_nmd01_t,"",SQLCA.sqlcode,"","t100_u:nmd",1)  #No.FUN-660148
    ROLLBACK WORK
    LET g_nmd.* = g_nmd_t.*
 ELSE 
    COMMIT WORK
 END IF
 CALL t100_show() 
END FUNCTION 
#No.FUN-9C0073 -----------------By chenls 10/01/15 
#FUN-CB0049--add--str--
FUNCTION t100_v()
   DEFINE l_t1      LIKE nmy_file.nmyslip
   DEFINE l_nmydmy3 LIKE nmy_file.nmydmy3
   DEFINE l_wc      STRING
   DEFINE l_nmd     RECORD LIKE nmd_file.*
   DEFINE only_one  LIKE type_file.chr1
   DEFINE l_cnt     LIKE type_file.num5

   IF g_nmd.nmd30='Y' THEN
      RETURN
   END IF

   BEGIN WORK
   OPEN t100_cl USING g_nmd.nmd01
   IF STATUS THEN
      CALL cl_err("OPEN t100_cl:", STATUS, 1)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t100_cl INTO g_nmd.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nmd.nmd01,SQLCA.sqlcode,0)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF

   OPEN WINDOW t100_3 AT 5,11 WITH FORM "anm/42f/anmt1003"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("anmt1003")

   LET only_one = '1'

   INPUT BY NAME only_one WITHOUT DEFAULTS
      AFTER FIELD only_one
         IF only_one IS NULL THEN NEXT FIELD only_one END IF
         IF only_one NOT MATCHES "[12]" THEN NEXT FIELD only_one END IF

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()
   END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t100_3
      RETURN
   END IF

   IF only_one = '1' THEN
      IF g_nmd.nmd30='Y' THEN
         CALL cl_err(g_nmd.nmd01,'anm-232',1)
         CLOSE WINDOW t100_3
         RETURN
      END IF
      IF g_nmd.nmd30='X' THEN
         CALL cl_err(g_nmd.nmd01,'9024',1)
         CLOSE WINDOW t100_3
         RETURN
      END IF
      IF g_nmd.nmd12<>'1' THEN
         CALL cl_err(g_nmd.nmd01,'atm-046',1)
         CLOSE WINDOW t100_3
         RETURN
      END IF
      IF g_nmd.nmd07 <= g_nmz.nmz10 THEN   #立帳日期小於關帳日期
         CALL cl_err(g_nmd.nmd01,'aap-176',1)
         CLOSE WINDOW t100_3
         RETURN
      END IF
      LET l_wc = " nmd01 = '",g_nmd.nmd01,"' "
   ELSE
      CONSTRUCT BY NAME l_wc ON nmd01,nmd07
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION about
            CALL cl_about()

         ON ACTION HELP
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
                    CALL cl_qbe_save()
      END CONSTRUCT
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW t100_3
         RETURN
      END IF
   END IF
   CLOSE WINDOW t100_3

   LET l_nmd.* = g_nmd.*   # backup old value
   MESSAGE "WORKING !"
   LET g_sql = "SELECT * FROM nmd_file WHERE nmd30 <> 'X' AND ",l_wc CLIPPED,
               " ORDER BY nmd01"
   PREPARE t100_v_p FROM g_sql
   DECLARE t100_v_c CURSOR WITH HOLD FOR t100_v_p
   LET g_success='Y'
   BEGIN WORK
   CALL s_showmsg_init()
   FOREACH t100_v_c INTO g_nmd.*
      IF STATUS THEN
         CALL s_errmsg('','','FOREACH',STATUS,1)
         EXIT FOREACH
      END IF
      IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success="Y"
      END IF
      IF g_nmd.nmd07 <= g_nmz.nmz10 THEN   #立帳日期小於關帳日期
         CALL s_errmsg('','',g_nmd.nmd01,'aap-176',0)
         CONTINUE FOREACH
      END IF
      LET l_t1 = s_get_doc_no(g_nmd.nmd01)
      LET l_nmydmy3 = ''
      SELECT nmydmy3 INTO l_nmydmy3 FROM nmy_file WHERE nmyslip = l_t1
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('nmyslip',l_t1,'sel nmy',STATUS,1)
         LET g_success='N'
         CONTINUE FOREACH
      END IF
      IF l_nmydmy3 = 'Y' THEN   #是否拋轉傳票
         IF NOT cl_null(g_nmd.nmd27) THEN
            CALL s_errmsg('','',g_nmd.nmd01,'aap-122',1)
            LET g_success='N'
            CONTINUE FOREACH
         END IF
         IF g_nmd.nmd30='Y' THEN
            CALL s_errmsg('','',g_nmd.nmd01,'anm-232',1)
            LET g_success='N'
            CONTINUE FOREACH
         END IF
         CALL t100_gl(g_nmd.nmd01,'0')
         IF g_aza.aza63 = 'Y'AND g_success = 'Y' THEN
            CALL t100_gl(g_nmd.nmd01,'1')
         END IF
      END IF
   END FOREACH
   IF g_totsuccess='N' THEN
      LET g_success='N'
   END IF
   CALL s_showmsg()
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_err('','aap-055',0)
   ELSE
      ROLLBACK WORK
      MESSAGE " "
   END IF
   LET g_nmd.*=l_nmd.*
END FUNCTION

FUNCTION t100_gl(p_trno,p_npptype)
   DEFINE p_trno        LIKE nmd_file.nmd01
   DEFINE l_buf         LIKE type_file.chr1000
   DEFINE l_n           LIKE type_file.num5
   DEFINE p_npptype     LIKE npp_file.npptype
   DEFINE p_npqtype     LIKE npq_file.npqtype
   WHENEVER ERROR CALL cl_err_msg_log

   IF p_trno IS NULL THEN RETURN END IF
   IF STATUS THEN
      CALL s_errmsg('nmd01',p_trno,'sel nmd',STATUS,0)
      LET g_success='N'
   END IF
   #若已拋轉總帳, 不可重新產生分錄底稿
   SELECT COUNT(*) INTO l_n FROM npp_file
    WHERE nppsys= 'NM' AND npp00=1 AND npp01 = p_trno 
     #AND npp011=g_nmd.nmd12 #FUN-DA0047 mark
      AND npp011=10          #FUN-DA0047 add
      AND nppglno != '' AND nppglno IS NOT NULL
   IF l_n > 0 THEN
      #LET g_showmsg=p_trno,"/",g_nmd.nmd12 #FUN-DA0047 mark
      LET g_showmsg=p_trno,"/",'10'         #FUN-DA0047 add
      CALL s_errmsg('npp01,npp011',g_showmsg,p_trno,'aap-122',1)
      LET g_success = 'N'
   END IF
   SELECT * INTO g_nms.* FROM nms_file WHERE nms01 = ' ' OR nms01 IS NULL
   DELETE FROM npp_file
    WHERE nppsys= 'NM' AND npp00=1 AND npp01 = p_trno 
     #AND npp011=g_nmd.nmd12  #FUN-DA0047 mark
      AND npp011=10           #FUN-DA0047 add
      AND npptype=p_npptype
   DELETE FROM npq_file
    WHERE npqsys= 'NM' AND npq00=1 AND npq01 = p_trno 
     #AND npq011=g_nmd.nmd12  #FUN-DA0047 mark
      AND npq011=10           #FUN-DA0047 add
      AND npqtype=p_npptype

   DELETE FROM tic_file WHERE tic04 = p_trno
   CALL t100_ins_npp(p_npptype)
   CALL t100_diff()
   CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)
END FUNCTION

FUNCTION t100_ins_npp(p_npptype)
   DEFINE  p_npptype    LIKE npp_file.npptype
   DEFINE  p_npqtype    LIKE npq_file.npqtype

   LET g_npp.npptype = p_npptype
   LET g_npq.npqtype = p_npptype
   LET g_npp.nppsys = 'NM'
   LET g_npp.npp00 = 1
   LET g_npp.npp01 = g_nmd.nmd01
  #LET g_npp.npp011= g_nmd.nmd12 #FUN-DA0047 mark
   LET g_npp.npp011= 10          #FUN-DA0047 add
   LET g_npp.npp02 = g_nmd.nmd07
   LET g_npp.npp03 = NULL
   LET g_npp.npplegal= g_legal
   INSERT INTO npp_file VALUES(g_npp.*)
   IF STATUS THEN
      LET g_showmsg=g_npp.npp01,"/",g_npp.npp011,"/",g_npp.nppsys,"/",g_npp.npp00
      CALL s_errmsg('npp01,npp011,nppsys,npp00',g_showmsg,'ins npp',STATUS,1)
      LET g_success='N'
   END IF
   CALL t100_ins_npq(p_npptype)
END FUNCTION
FUNCTION t100_ins_npq(p_npptype)
   DEFINE l_aag05    LIKE aag_file.aag05
   DEFINE p_npptype  LIKE npp_file.npptype
   DEFINE p_npqtype  LIKE npq_file.npqtype
   DEFINE l_aaa03    LIKE aaa_file.aaa03
   DEFINE l_flag     LIKE type_file.chr1
   DEFINE l_bookno1  LIKE aza_file.aza82,
          l_bookno2  LIKE aza_file.aza82,
          l_bookno3  LIKE aza_file.aza82
DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   LET g_npq.npqsys = 'NM'
   LET g_npq.npq00 = 1
   LET g_npq.npq01 = g_nmd.nmd01
  #LET g_npq.npq011= g_nmd.nmd12 #FUN-DA0047 mark
   LET g_npq.npq011= 10          #FUN-DA0047 add
   LET g_npq.npq02 = 0
   LET g_npq.npq24 = g_nmd.nmd21
   LET g_npq.npq25 = g_nmd.nmd19
   LET g_npq25     = g_npq.npq25
   LET g_npq.npq02 = g_npq.npq02 + 1
   LET g_npq.npq21 = g_nmd.nmd08
   LET g_npq.npq22 = g_nmd.nmd24
   #借方科目產生
   LET g_t1 = s_get_doc_no(g_nmd.nmd01)
   LET g_npq.npq06 = '1'
   IF p_npptype = '0' THEN
      LET g_npq.npq03 = g_nms.nms14
   ELSE
      LET g_npq.npq03 = g_nms.nms141
   END IF
   LET g_npq.npq07f = g_nmd.nmd04
   LET g_npq.npq24 = g_nmd.nmd21
   LET g_npq.npq25 = g_nmd.nmd19
   LET g_npq.npq07 = g_nmd.nmd26
   LET g_npq25     = g_npq.npq25                                                                                              
   CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING l_flag,l_bookno1,l_bookno2
   IF l_flag = '1' THEN
      CALL s_errmsg('','',YEAR(g_npp.npp02),'aoo-081',1)
      LET g_success = 'N'
   END IF
   SELECT aag05 INTO l_aag05 FROM aag_file   #是否做部門管理
    WHERE aag01=g_npq.npq03
      AND aag00=l_bookno1
   IF l_aag05 = 'Y' THEN
      LET g_npq.npq05 = g_nmd.nmd18
   ELSE
      LET g_npq.npq05 = ' '
   END IF
   #LET g_npq.npq04 = g_nmd.nmd11  #FUN-D10065 mark
   LET g_npq.npq04 = NULL          #FUN-D10065
   IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
   CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING l_flag,l_bookno1,l_bookno2
   IF l_flag = '1' THEN
      CALL s_errmsg('','',YEAR(g_npp.npp02),'aoo-081',1)
      LET g_success = 'N'
   END IF
   IF g_npp.npptype = '0' THEN
      LET l_bookno3 = l_bookno1
   ELSE
      LET l_bookno3 = l_bookno2
   END IF
   CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',l_bookno3)
   RETURNING  g_npq.*
   #FUN-D10065--add--str--
   IF cl_null(g_npq.npq04) THEN
      LET g_npq.npq04 = g_nmd.nmd11
   END IF
   #FUN-D10065--add--end
   CALL s_def_npq31_npq34(g_npq.*,l_bookno3)
   RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34
   LET g_npq.npqlegal= g_legal

   IF p_npptype = '1' THEN
      SELECT aaa03 INTO l_aaa03 FROM aaa_file
       WHERE aaa01 = l_bookno2
      SELECT azi04 INTO t_azi04 FROM azi_file
       WHERE azi01 = l_aaa03

      CALL s_newrate(l_bookno1,l_bookno2,g_npq.npq24,g_npq25,g_npp.npp02)
      RETURNING g_npq.npq25
      LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
      LET g_npq.npq07 = cl_digcut(g_npq.npq07,t_azi04)
   ELSE
      LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)
   END IF
   #FUN-D40118 ---Add--- Start
   SELECT aag44 INTO l_aag44 FROM aag_file
    WHERE aag00 = l_bookno3
      AND aag01 = g_npq.npq03
   IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
      CALL s_chk_ahk(g_npq.npq03,l_bookno3) RETURNING l_flag
      IF l_flag = 'N'   THEN
         LET g_npq.npq03 = ''
      END IF
   END IF
  #FUN-D40118 ---Add--- End
   INSERT INTO npq_file VALUES (g_npq.*)
   IF STATUS THEN
      LET g_showmsg=g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq03
      CALL s_errmsg('npq01,npq011,npq03',g_showmsg,'ins npq#9',STATUS,1)
      LET g_success='N'
   END IF

   #貸方科目產生
   LET g_npq.npq02 = g_npq.npq02 + 1
   LET g_npq.npq06 = '2'
   IF p_npptype = '0'  THEN
      LET g_npq.npq03 = g_nmd.nmd23
   ELSE
      LET g_npq.npq03 = g_nmd.nmd231
   END IF
   LET g_npq.npq07f = g_nmd.nmd04
   LET g_npq.npq07 = g_nmd.nmd26
   LET g_npq.npq25 = g_nmd.nmd19
   LET g_npq25     = g_npq.npq25
   LET g_npq.npq24 = g_nmd.nmd21                                                                                              
   CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING l_flag,l_bookno1,l_bookno2
   IF l_flag = '1' THEN
      CALL s_errmsg('','',YEAR(g_npp.npp02),'aoo-081',1)
      LET g_success='N'
   END IF
   SELECT aag05 INTO l_aag05 FROM aag_file   #是否做部門管理
    WHERE aag01=g_npq.npq03
      AND aag00=l_bookno1
   IF l_aag05 = 'Y' THEN
      LET g_npq.npq05 = g_nmd.nmd18
   ELSE
      LET g_npq.npq05 = ' '
   END IF
   #LET g_npq.npq04 = g_nmd.nmd11  #FUN-D10065 mark
   LET g_npq.npq04 = NULL          #FUN-D10065
   IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
   CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',l_bookno3)
   RETURNING  g_npq.*
   #FUN-D10065--add--str--
   IF cl_null(g_npq.npq04) THEN
      LET g_npq.npq04 = g_nmd.nmd11
   END IF
   #FUN-D10065--add--end
   CALL s_def_npq31_npq34(g_npq.*,l_bookno3)
   RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34
   LET g_npq.npqlegal= g_legal
   IF p_npptype = '1' THEN
      SELECT aaa03 INTO l_aaa03 FROM aaa_file
       WHERE aaa01 = l_bookno2
      SELECT azi04 INTO t_azi04 FROM azi_file
       WHERE azi01 = l_aaa03
      CALL s_newrate(l_bookno1,l_bookno2,g_npq.npq24,g_npq25,g_npp.npp02)
      RETURNING g_npq.npq25
      LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
      LET g_npq.npq07 = cl_digcut(g_npq.npq07,t_azi04)
   ELSE
      LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)
   END IF
   #FUN-D40118 ---Add--- Start
   SELECT aag44 INTO l_aag44 FROM aag_file
    WHERE aag00 = l_bookno3
      AND aag01 = g_npq.npq03
   IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
      CALL s_chk_ahk(g_npq.npq03,l_bookno3) RETURNING l_flag
      IF l_flag = 'N'   THEN
         LET g_npq.npq03 = ''
      END IF
   END IF
  #FUN-D40118 ---Add--- End
   INSERT INTO npq_file VALUES (g_npq.*)
   IF STATUS THEN
      LET g_showmsg=g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq03
      CALL s_errmsg('npq01,npq011,npq03',g_showmsg,'ins npq#9',STATUS,1)
      LET g_success='N'
   END IF
END FUNCTION

FUNCTION t100_diff()
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
DEFINE l_flag     LIKE type_file.chr1
DEFINE l_bookno1  LIKE aza_file.aza82,
       l_bookno2  LIKE aza_file.aza82,
       l_bookno3  LIKE aza_file.aza82
DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   IF g_npp.npptype = '1' THEN
      CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING l_flag,l_bookno1,l_bookno2
      IF l_flag = '1' THEN
         CALL s_errmsg('','',YEAR(g_npp.npp02),'aoo-081',1)
         LET g_success='N'
         RETURN
      END IF
      LET l_bookno3 = l_bookno2
      SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = l_bookno3
      LET l_sum_cr = 0
      LET l_sum_dr = 0
      SELECT SUM(npq07) INTO l_sum_dr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = g_npp.npp00
         AND npq01 = g_npp.npp01
         AND npq011= g_npp.npp011
         AND npqsys= g_npp.nppsys
         AND npq06 = '1'
      SELECT SUM(npq07) INTO l_sum_cr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = g_npp.npp00
         AND npq01 = g_npp.npp01
         AND npq011= g_npp.npp011
         AND npqsys= g_npp.nppsys
         AND npq06 = '2'
      IF l_sum_dr <> l_sum_cr THEN
         SELECT MAX(npq02)+1 INTO l_npq1.npq02
           FROM npq_file
          WHERE npqtype = '1'
            AND npq00 = g_npp.npp00
            AND npq01 = g_npp.npp01
            AND npq011= g_npp.npp011
            AND npqsys= g_npp.nppsys
         LET l_npq1.npqtype = g_npp.npptype
         LET l_npq1.npq00 = g_npp.npp00
         LET l_npq1.npq01 = g_npp.npp01
         LET l_npq1.npq011= g_npp.npp011
         LET l_npq1.npqsys= g_npp.nppsys
         LET l_npq1.npq07 = l_sum_dr-l_sum_cr
         LET l_npq1.npq24 = l_aaa.aaa03
         LET l_npq1.npq25 = 1
         IF l_npq1.npq07 < 0 THEN
            LET l_npq1.npq03 = l_aaa.aaa11
            LET l_npq1.npq07 = l_npq1.npq07 * -1
            LET l_npq1.npq06 = '1'
         ELSE
            LET l_npq1.npq03 = l_aaa.aaa12
            LET l_npq1.npq06 = '2'
         END IF
         LET l_npq1.npq07f = l_npq1.npq07
         LET l_npq1.npqlegal=g_legal
         #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = l_bookno3
            AND aag01 = l_npq1.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq1.npq03,l_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq1.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES(l_npq1.*)
         IF STATUS THEN
            LET g_showmsg=l_npq1.npq01,"/",l_npq1.npq011,"/",l_npq1.npq03
            CALL s_errmsg('npq01,npq011,npq03',g_showmsg,'ins npq#9',STATUS,1)
            LET g_success='N'
         END IF
      END IF
   END IF
END FUNCTION
#FUN-CB0049--add--end

#No.FUN-D40120 ---Add--- Start
FUNCTION t100_copy()
   DEFINE l_newno      LIKE nmd_file.nmd01,
          l_oldno      LIKE nmd_file.nmd01
   DEFINE l_i          LIKE type_file.num5
   DEFINE li_result    LIKE type_file.num5

   IF s_shut(0) THEN RETURN END IF
   IF  g_nmd.nmd01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   LET g_before_input_done = FALSE
   CALL t100_set_entry('a')
   CALL t100_set_no_entry('a')
   LET g_before_input_done = TRUE

   INPUT l_newno FROM nmd01

      AFTER FIELD nmd01
         IF l_newno IS NULL THEN
            NEXT FIELD nmd01
         END IF
         CALL s_check_no("anm",l_newno,g_nmd01_t,"1","nmd_file","nmd01","")
            RETURNING li_result,l_newno
         DISPLAY BY NAME l_newno
         IF (NOT li_result) THEN
            NEXT FIELD nmd01
         END IF

      ON ACTION controlp
         CASE
            WHEN INFIELD(nmd01)
               LET g_t1 = s_get_doc_no(l_newno)
               CALL q_nmy(FALSE,TRUE,g_t1,'1','ANM')
                  RETURNING g_t1 #票據性質:應付票據
               LET l_newno = g_t1
               DISPLAY BY NAME l_newno
               NEXT FIELD nmd01
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_nmd.nmd01
      RETURN
   END IF
   DROP TABLE x
   SELECT * FROM nmd_file
    WHERE nmd01 = g_nmd.nmd01
     INTO TEMP x

   CALL s_auto_assign_no("anm",l_newno,g_today,"1","nmd_file","nmd01","","","")
      RETURNING li_result,l_newno
   IF (NOT li_result) THEN
      RETURN
   END IF

   UPDATE x
      SET nmd01  =l_newno,  #資料鍵值
          nmduser=g_user,   #資料所有者
          nmdgrup=g_grup,   #資料所有者所屬群
          nmdmodu=NULL,     #資料修改日期
          nmddate=g_today,  #資料建立日期
          nmdoriu= g_user,
          nmdorig= g_grup,
          nmd07 = g_today,
          nmd05 = g_today,
          nmd13 = g_today,
          nmd12 = '1',
          nmd55 = 0,
          nmd29 = '',
          nmd30 ='N'        #審核碼
   INSERT INTO nmd_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nmd.nmd01,SQLCA.sqlcode,0)
   ELSE
      MESSAGE 'ROW(',l_newno,') O.K'
      LET l_oldno= g_nmd.nmd01
      SELECT nmd_file.* INTO g_nmd.* FROM nmd_file
       WHERE nmd01 =  l_newno
      CALL t100_u()
   END IF
   DISPLAY BY NAME g_nmd.nmd01
END FUNCTION
#No.FUN-D40120 ---Add--- End
#FUN-DA0047---add---str--
FUNCTION t100_carry_voucher()
   DEFINE l_nmygslp    LIKE nmy_file.nmygslp
   DEFINE l_nmygslp1   LIKE nmy_file.nmygslp1
   DEFINE li_result    LIKE type_file.num5
   DEFINE l_dbs        STRING
   DEFINE l_sql        STRING
   DEFINE l_n          LIKE type_file.num5
   DEFINE l_wc_gl      STRING
   DEFINE l_flag       LIKE type_file.chr1
   DEFINE l_bookno1    LIKE aza_file.aza82
   DEFINE l_bookno2    LIKE aza_file.aza82

    IF NOT cl_null(g_nmd.nmd27) OR g_nmd.nmd27 IS NOT NULL THEN
       CALL cl_err(g_nmd.nmd27,'aap-618',1)
       RETURN
    END IF
   IF NOT cl_confirm('aap-989') THEN RETURN END IF

   CALL s_get_doc_no(g_nmd.nmd01) RETURNING g_t1
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   IF g_nmy.nmydmy3 = 'N' THEN RETURN END IF
   CALL s_get_bookno(YEAR(g_nmd.nmd07)) RETURNING l_flag,l_bookno1,l_bookno2
   IF l_flag = '1' THEN
      CALL s_errmsg('','',YEAR(g_nmd.nmd07),'aoo-081',1)
      LET g_success='N'
   END IF
   #CALL s_chknpq(g_nmd.nmd01,'NM','1','0',l_bookno1) #FUN-DA0047 mark
   CALL s_chknpq(g_nmd.nmd01,'NM','10','0',l_bookno1) #FUN-DA0047
   IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
      #CALL s_chknpq(g_nmd.nmd01,'NM','1','1',l_bookno2) #FUN-DA0047 mark
      CALL s_chknpq(g_nmd.nmd01,'NM','10','1',l_bookno2) #FUN-DA0047
   END IF
   IF g_success='N' THEN RETURN END IF
   IF g_nmy.nmyglcr = 'Y' OR (g_nmy.nmyglcr = 'N' AND NOT cl_null(g_nmy.nmygslp)) THEN
      LET l_nmygslp = g_nmy.nmygslp
      LET l_nmygslp1= g_nmy.nmygslp1
      LET g_plant_new=g_nmz.nmz02p
      LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_plant_new,'aba_file'),
                  "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                  "    AND aba01 = '",g_nmd.nmd27,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
      PREPARE aba_pre2 FROM l_sql
      DECLARE aba_cs2 CURSOR FOR aba_pre2
      OPEN aba_cs2
      FETCH aba_cs2 INTO l_n
      IF l_n > 0 THEN
         CALL cl_err(g_nmd.nmd27,'aap-991',1)
         RETURN
      END IF
   ELSE
      CALL cl_err('','aap-936',1)
      RETURN
   END IF
   IF cl_null(l_nmygslp) THEN
      CALL cl_err(g_nmd.nmd01,'axr-070',1)
      RETURN
   END IF
   IF cl_null(l_nmygslp1) AND g_aza.aza63 = 'Y' THEN
      CALL cl_err(g_nmd.nmd01,'axr-070',1)
      RETURN
   END IF
  #LET l_wc_gl = 'npp01 = "',g_nmd.nmd01,'" AND npp011 = 1'  #FUN-DA0047 mark
   LET l_wc_gl = 'npp01 = "',g_nmd.nmd01,'" AND npp011 = 10' #FUN-DA0047 add
  #LET g_str="anmp400 '",l_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02p,"' ",  #MOD-DA0204 mark
   LET g_str="anmp400 '",l_wc_gl CLIPPED,"' '",g_nmd.nmduser,"' '",g_nmd.nmduser,"' '",g_nmz.nmz02p,"' ",  #MOD-DA0204 add
             " '",g_nmz.nmz02b,"' '",l_nmygslp,"' ",
             " '",g_nmz.nmz02c,"' '",l_nmygslp1,"' '",g_nmd.nmd07,"' 'Y' '1' 'Y'"
   CALL cl_cmdrun_wait(g_str)
   SELECT nmd27 INTO g_nmd.nmd27 FROM nmd_file
    WHERE nmd01 = g_nmd.nmd01
   DISPLAY BY NAME g_nmd.nmd27

END FUNCTION

FUNCTION t100_undo_carry_voucher()
   DEFINE l_aba19    LIKE aba_file.aba19
   DEFINE l_sql      STRING
   DEFINE l_flag       LIKE type_file.chr1
   DEFINE l_bookno1    LIKE aza_file.aza82
   DEFINE l_bookno2    LIKE aza_file.aza82

    IF cl_null(g_nmd.nmd27) OR g_nmd.nmd27 IS NULL THEN
       CALL cl_err(g_nmd.nmd27,'aap-619',1)
       RETURN
    END IF
   IF NOT cl_confirm('aap-988') THEN RETURN END IF

   CALL s_get_doc_no(g_nmd.nmd01) RETURNING g_t1
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   IF g_nmy.nmydmy3 = 'N' THEN RETURN END IF
   IF g_nmy.nmyglcr = 'N' AND cl_null(g_nmy.nmygslp) THEN
      CALL cl_err('','aap-936',1)
      RETURN
   END IF
   CALL s_get_bookno(YEAR(g_nmd.nmd07)) RETURNING l_flag,l_bookno1,l_bookno2
   IF l_flag = '1' THEN
      CALL s_errmsg('','',YEAR(g_nmd.nmd07),'aoo-081',1)
      LET g_success='N'
   END IF
   #CALL s_chknpq(g_nmd.nmd01,'NM','1','0',l_bookno1) #FUN-DA0047 mark
   CALL s_chknpq(g_nmd.nmd01,'NM','10','0',l_bookno1) #FUN-DA0047
   IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
      #CALL s_chknpq(g_nmd.nmd01,'NM','1','1',l_bookno2) #FUN-DA0047 mark
      CALL s_chknpq(g_nmd.nmd01,'NM','10','1',l_bookno2) #FUN-DA0047
   END IF
   IF g_success='N' THEN RETURN END IF
   LET g_plant_new = g_nmz.nmz02p
   LET l_sql = "SELECT aba19 ",
               "  FROM ",cl_get_target_table(g_plant_new,'aba_file'),
               " WHERE aba00 = '",g_nmz.nmz02b,"' ",
               "   AND aba01 = '",g_nmd.nmd27,"' "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
   PREPARE aba_pre1 FROM l_sql
   DECLARE aba_cs1 CURSOR FOR aba_pre1
   OPEN aba_cs1
   IF SQLCA.sqlcode THEN RETURN END IF
   FETCH aba_cs1 INTO l_aba19
   IF l_aba19 = 'Y' THEN
      CALL cl_err(g_nmd.nmd27,'axr-071',1)
      RETURN
   END IF
   LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nmd.nmd27,"' 'Y'"
   CALL cl_cmdrun_wait(g_str)
   SELECT nmd27 INTO g_nmd.nmd27 FROM nmd_file
    WHERE nmd01 = g_nmd.nmd01
   DISPLAY BY NAME g_nmd.nmd27
END FUNCTION
#FUN-DA0047---add---end--
