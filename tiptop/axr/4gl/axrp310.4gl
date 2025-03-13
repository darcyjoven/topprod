# Prog. Version..: '5.30.06-13.03.29(00010)'     #
#
# Pattern name...: axrp310.4gl
# Descriptions...: 應收帳款自動產生作業
# Date & Author..: 96/05/07 By Roger
# Remark ........: 本程式 Copy from axrp302
# Modify.........: 97-04-17 modify by joanne 1.不產生檢查表, 因原方式產生錯誤
#                                            2.call s_g_ar 時加傳一參數
#                                              (配合 s_g_ar 修改)
# Modify.........: 97/08/01 By Sophia 已產生訂金不可重複產生
# Modify.........: 97/09/04 By Sophia 當出貨比率為0時無法產生帳款
# Modify.........: No:7837 03/08/19 By Wiky 呼叫自動取單號時應在 Transction中
# Modify.........: No:8897 03/12/16 By ching open_sw='Y' 發票日期,發票別不可空白
# Modify.........: No:9734 04/07/13 By ching 針對 選2.出貨 加上order by oga01
# Modify.........: No:9166 04/07/27 By ching call axrr300搬到commit之後
# Modify.........: No:9165 04/07/27 By ching sel oom_file 加上發票年月條件
# Modify.........: No.MOD-4A0264 04/10/20 By ching set_entry錯誤修改
# Modify.........: No.MOD-510095 05/01/13 By kitty 由axmt620串過來的沒有串到axrr300
# Modify.........: No.MOD-520011 05/02/02 By kitty 出貨單取消拋AR後,若AR只作廢未刪除,出貨單不能重拋
# Modify.........: No.FUN-550071 05/05/25 By vivien 單據編號格式放大
# Modify.........: No.MOD-570266 05/08/03 By Nicola 重新oga10時，同時重新oga05
# Modify.........: No.FUN-610020 06/01/09 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.FUN-610064 06/03/01 By wujie   增加代送出貨，oga00='6'
# Modify.........: No.FUN-570156 06/03/10 By saki 批次背景執行
# Modify.........: No.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.........: No.FUN-610064 06/03/31 By wujie  s_g_ar判斷訂單出貨單的參數傳錯
# Modify.........: No.TQC-630091 06/04/07 By pengu axmt620轉應收發票串axrp310時會出現小視窗
# Modify.........: No.TQC-640133 06/04/11 By saki 因為批次背景功能將commit移出p310_p()，所以只要單獨呼叫此function就需額外commit
# Modify.........: No.FUN-640191 06/04/18 By kim GP3.0 匯率參數功能改善
# Modify.........: No.FUN-570188 06/05/04 By Sarah 當ooz13='2'時,需詢問是否自動確認
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.TQC-610059 06/06/26 By Smapmin 修改列印參數傳遞
# Modify.........: No.FUN-660210 06/06/30 By Sarah 當是從axmt620 CALL過來的時候,才需要跳出"轉應收帳款後是否自動確認"詢問視窗
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670047 06/08/09 By Ray 增加兩帳套功能
# Modify.........: No.FUN-680022 06/08/23 By cl  多帳期處理
# Modify.........: No.FUN-680123 06/09/07 By hongmei 欄位類型轉換
# Modify.........: No.FUN-660073 06/09/08 By Niocla 訂單樣品處理
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.FUN-710050 07/01/22 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-740009 07/04/03 By Elva   會計科目加帳套
# Modify.........: No.MOD-710085 07/04/13 By Smapmin 選擇自動確認後才可選擇自動確認後開立發票
# Modify.........: No.FUN-740016 07/05/08 By Nicola 借貨管理
# Modify.........: No.MOD-760035 07/06/13 By Smapmin 修改update oga54
# Modify.........: No.MOD-760080 07/06/20 By Smapmin 依oaz67參數決定檢查INVOICE條件
# Modify.........: No.MOD-760078 07/06/20 By Smapmin g_azi<->t_azi
# Modify.........: No.MOD-760086 07/06/21 By Smapmin oga07='Y'可以在出貨單日期的隔月後立應收
# Modify.........: No.TQC-770021 07/07/03 By Rayven 帳款單別無效未控管
# Modify.........: No.CHI-7B0041 07/12/09 By claire 中斷點的多角出貨單應可產生應收帳款
# Modify.........: No.MOD-7C0206 07/12/27 By Smapmin 補缺號時,要符合序時序號原則
# Modify.........: No.MOD-820059 08/02/18 By Smapmin 使用cl_replace_str做字串的取代
# Modify.........: No.MOD-850010 08/05/05 By Smapmin 當發票日為空時,應default立帳日
# Modify.........: No.MOD-860078 08/06/09 BY Yiting ON IDLE處理 
# Modify.........: No.TQC-870010 08/07/14 By Sarah FUN-630043在p310()增加的程式段,g_aza.aza52需判斷='Y'
# Modify.........: No.MOD-870179 08/07/15 By Sarah 合併開發票時,發票檔的帳款編號要清空,發票檔的金額要累加
# Modify.........: No.CHI-880036 08/09/02 By Sarah 出貨單拋AR後,將AR作廢,要重拋AR會失敗,axrp310a的帳單編號欄位增加開窗功能,讓重拋的帳款編號能重編
# Modify.........: No.MOD-890256 08/10/01 By Sarah 將BEFORE FIELD conf_sw這行mark掉
# Modify.........: No.MOD-8A0247 08/10/29 By Sarah p310_p()段到poy_file抓不到資料時,不需LET g_success='N'
# Modify.........: NO.FUN-8C0078 08/12/22 BY yiting 訂金多帳期
# Modify.........: No.TQC-930046 09/03/11 By mike 去除字符串尾部空格
# Modify.........: No.MOD-940332 09/04/24 By Sarah 抓INVOICE有沒有資料段,需判斷當輸入的oga01是否為出貨簽收單號,若是且oaz67='1'時,需再串回出貨單抓取出通單號
# Modify.........: No.MOD-940408 09/04/30 By lilingyu 產生應收賬款,有指定立即確認者,則應該要執行確認處理動作
# Modify.........: No.FUN-860006 09/03/25 By jamie 新增"單價為0立帳"選項 
# Modify.........: No.MOD-960168 09/06/15 By baofei 在CALL p310_p()后都要加CALL s_showmsg() 
# Modify.........: No.MOD-960173 09/06/15 By baofei 修正MOD-940332,IF l_oga09 IS NOT NULL OR l_oga09='8' THEN 
# Modify.........: No.FUN-960140 09/06/23 By lutingting GP5.2
#                                            按照交款產生AR的直接收款
# Modify.........: No.TQC-8C0091 09/08/18 By hongmei 同FUN-8C0078
# Modify.........: No.MOD-960045 09/08/22 By Smapmin 若有不折讓不換貨的銷退單已過帳時,必須將帳款編號回寫到銷退單上
# Modify.........: No.MOD-980184 09/08/25 By mike FUNCTION p310_p(),CALL s_auto_assign_no()編號若失敗,應顯示mfg3326訊息             
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.FUN-970108 09/08/24 By hongmei 將oom13的值賦給oma71
# Modify.........: No.MOD-990166 09/09/30 By mike 當"單價為0立帳"='N' 時,不應該產生 oma_file 資料,與 update oga10                   
# Modify.........: No.FUN-990031 09/10/21 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下
# Modify.........: No:MOD-9A0205 09/11/02 By Sarah 判斷出貨單是不是三角貿易的判斷式寫法有誤
# Modify.........: No:FUN-9B0076 09/11/10 By wujie 5.2SQL转标准语法
# Modify.........: No:FUN-9C0014 09/12/03 By shiwuying QBE門店編號改為來源營運中心,實現可由當前法人下DB得訂單出貨單生成應收
# Modify.........: No:TQC-9C0185 09/12/30 By sherry 修正FUN-9C0014的問題
# Modify.........: No.FUN-9C0072 10/01/06 By vealxu 精簡程式碼
# Modify.........: No:FUN-A10104 10/01/19 By shiwuying 函數傳參部份修改
# Modify.........: No:CHI-A40009 10/04/08 By Summer 若 ar_type='1' 時,不執行 p310_chkdate FUNCTION
# Modify.........: No:TQC-A40114 10/04/22 By xiaofeizhu ­q/¥X³f³渹½d³òn¥i¥H¶}µ¡¬d¸ß
# Modify.........: No:MOD-A50077 10/05/12 By sabrina 大陸帳務待客戶驗收後才開立發票，且大陸在發票開立上並未控管一定要序時序號
# Modify.........: No:CHI-A50040 10/06/01 By Dido 尾款立帳改用訂單資料 
# Modify.........: No:FUN-A50103 10/06/03 By Nicola 訂單多帳期
# Modify.........: No.FUN-A50102 10/07/01 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A80169 10/08/24 By Dido 開立發票應帳款確認時才可開立 
# Modify.........: No:CHI-A70028 10/08/26 By Summer 寫入ome_file時需同步增加寫入到發票與帳款對照檔(omee_file)
# Modify.........: No:MOD-A80242 10/09/01 By Dido 由 axmt620 拋轉時,g_date2不需預設  
# Modify.........: No:MOD-AA0013 10/10/05 By Dido 開立發票前用變數方式檢核是否確認 
# Modify.........: No:MOD-AA0063 10/10/12 By Dido 還原原8個參數 
# Modify.........: No:MOD-AA0133 10/10/21 By Dido oma02 需檢核 ooz09 
# Modify.........: No:MOD-AA0144 10/10/25 By Dido oga50 > 0 才可立帳 
# Modify.........: No:FUN-AC0027 10/12/16 By lilingyu 流通整合之財務
# Modify.........: No:TQC-AC0272 10/12/17 By Dido 背景呼叫應可執行發票開立段;非背景須再檢核帳款是否確認 
# Modify.........: No:MOD-AC0348 10/12/28 By Dido 重複執行取發票號碼動作 
# Modify.........: No:MOD-B10033 11/01/05 By Dido 發票自動取號有誤時需離開迴圈 
# Modify.........: No:FUN-AB0034 11/01/05 By wujie 流通整合之財務
# Modify.........: No:FUN-B10004 11/01/12 By Mandy For CRM 產生無訂單出貨單之調整
# Modify.........: No.FUN-AB0110 11/01/24 By chenmoyan 自動產生應收且自動確認時,先判斷是否產生遞延收入檔再做確認
# Modify.........: No:MOD-B10150 11/01/20 By Dido 若有 g_errno 時,需顯示實際問題訊息 
# Modify.........: No.FUN-B10058 11/01/25 By lutingting 流通财务改善
# Modify.........: No.CHI-B30044 11/01/25 By huangrh   來源營運中心應預設目前營運中心,不用每次都要挑
# Modify.........: No.MOD-B30185 11/03/14 By lutingting 出貨單應收自動確認功能修改
# Modify.........: No.MOD-B30536 11/03/17 By lixia oga09的條件修改
# Modify.........: No:MOD-B30627 11/03/21 By Dido 取消 omeprsw 更新段 
# Modify.........: No:TQC-B30206 11/03/29 By yinhy 更改g_oma05栏位大小为oma05
# Modify.........: No:CHI-B30024 11/04/27 By Sarah 增加選項"出貨金額為0立帳",預設值為N,
#                                                  當不勾選時,SQL增加oga50>0條件;反之則不加此條件
# Modify.........: No:MOD-B50245 11/05/30 By wujie 抛转时不同月份的资料不用卡 
# Modify.........: No:TQC-B60089 11/06/15 By Dido 訂金分期時,g_start應維持第一張帳款單號 
# Modify.........: No:TQC-B60103 11/06/15 By belle 將程式段移入IF g_ooy.ooydmy1 = 'Y' AND g_success = 'Y' THEN 判斷式內
# Modify.........: No:MOD-B60168 11/06/21 By Dido 若單別空白時ar_slip變數須再給予預設值  
# Modify.........: No:TQC-B60286 11/06/22 By wujie MOD-B50245改错
# Modify.........: No:MOD-B80056 11/08/05 By Polly 將g_sql/g_wc/g_wc1/l_sql型態改為STRING
# Modify.........: No:TQC-B80126 11/08/15 By yinhy ar_type為1且azw04為2時，去掉oea261>0的條件
# Modify.........: No.MOD-B90170 11/09/22 By polly 當訂金與尾款時 s_date/e_date 取消預設值
# Modify.........: No:FUN-B90112 11/09/27 By zhangweib 自動編號時需要參照aoos010中但據編號格式設置
# Modify.........: No:TQC-B90233 11/10/31 By destiny 从出货单调用时不应把出货单号带到账款单号上
# Modify.........: No.MOD-BB0081 11/11/08/By Polly 調整出貨單號為不連續時，拋轉後單號會變連續，不是原單號
# Modify.........: No.MOD-BB0230 11/11/24/By Dido 帳款分錄產生段調整 
# Modify.........: No:FUN-B90130 11/10/31 By wujie 大陆发票改善
# Modify.........: No:MOD-BC0167 11/12/15 By Dido 增加 ooz0 回寫機制 
# Modify.........: No:MOD-BC0101 11/12/28 By Summer 為多角單據時沒有訊息提示,故增加錯誤訊息提示 
# Modify.........: NO:MOD-BC0229 11/12/23 By Polly 增加條件，如大陸版才多判斷oom15、oom16
# Modify.........: NO:MOD-C10224 12/02/03 By Dido 若為 axmt620 直接開啟時,則發票金額需判斷 > 0 才需往下處理 
# Modify.........: NO:MOD-C30425 12/03/12 By zhangweib 根據出貨單單頭的發票性質在開窗/欄位檢查時使用不同的單別
# Modify.........: No.MOD-C30842 12/03/23 By Polly ooz10/ooz16 都需要回寫至出貨單
# Modify.........: No:MOD-C40031 12/04/05 By Polly 增加判斷，若oom06為 '1'時,open_sw = 'Y
# Modify.........: No.MOD-C40153 12/04/19 By Elise 發票整批開立也排除外銷單
# Modify.........: No.MOD-C60094 12/06/12 By Elise 單價為 0 立帳(g_enter_account)變數並未給值
# Modify.........: No:FUN-C60036 12/06/14 By xuxz oaz92 = 'Y' and aza26 = '2'
# Modify.........: No:FUN-C60036 12/06/29 By minpp  增加omf00查询条件
# Modify.........: No.FUN-C30085 12/07/06 By lixiang 改CR報表串GR報表
# Modify.........: No:MOD-C70289 12/07/30 By yinhy 流通版本若有收款金額，oob09收款金額不應為0
# Modify.........: No:TQC-BC0099 12/08/08 By yinhy 還原TQC-B90233
# Modify.........: No:TQC-C80083 12/08/22 By lujh 單價為0時，零售行業可以立賬
# Modify.........: No:FUN-CB0057 12/11/14 By xuxz 合併立賬
# Modify.........: No:TQC-CC0107 12/12/21 By yinhy 流通版本並且occ73為Y，立賬時oma65不應被更新為1.轉應收賬款
# Modify.........: No:MOD-CC0210 13/01/30 By Elise 沒有判斷到g_errno為NULL的情況,故訊息沒有出來aap-129
# Modify.........: No:TQC-D20046 13/02/28 By qiull 修改發出商品問題
# Modify.........: No.MOD-D60125 13/06/15 By yinhy oaz92欄位值為Y時，axrp330中QBE條件二中的信息隱藏
# Modify.........: No.yinhy130722  13/07/16 By yinhy 对oma02日期校验调整

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../sub/4gl/s_g_ar.global"      #No.FUN-860006  add 
 
#DEFINE g_wc,g_sql      LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(1000)  #No.MOD-B80056 mark
DEFINE g_wc,g_sql       STRING                       #No.MOD-B80056 add
#DEFINE g_wc1           LIKE type_file.chr1000       #No.FUN-9C0014 Add #No.MOD-B80056 mark
DEFINE g_wc1            STRING                       #No.MOD-B80056 Add
DEFINE l_dbs            LIKE type_file.chr21         #No.FUN-9C0014 Add
DEFINE g_start1         LIKE oma_file.oma01          #No.FUN-9C0014 Add
DEFINE source           LIKE azp_file.azp01          #No.FUN-680123 VARCHAR(10)  #FUN-630043
DEFINE ar_type          LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)   # 1.訂單 2.出貨 3.尾款
DEFINE s_date           LIKE type_file.dat           #No:FUN-A50103 
DEFINE e_date           LIKE type_file.dat           #No:FUN-A50103    
DEFINE ar_slip          LIKE oay_file.oayslip        #No.FUN-680123 VARCHAR(5)   #單別      #No.FUN-550071
DEFINE ar_slip1         LIKE oay_file.oayslip        #No.FUN-B10058
DEFINE g_date           LIKE type_file.dat           #No.FUN-680123 DATE         # 應收立帳日
DEFINE conf_sw          LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)   # 是否自動確認
DEFINE open_sw          LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)   # 是否自動開立發票
DEFINE g_date2          LIKE type_file.dat           #No.FUN-680123 DATE         # 開立發票日期
DEFINE t_date2          LIKE type_file.dat           #No.FUN-680123 DATE         # 開立發票日期
DEFINE t_date           LIKE type_file.dat           #No.FUN-680123 DATE         # 應收立帳日
#DEFINE g_oma05          LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)  # 發票別
DEFINE g_oma05          LIKE oma_file.oma05          #No.TQC-B30206  VARCHAR(5)  # 發票別
DEFINE g_oma212         LIKE oma_file.oma212         #發票聯數
DEFINE noin_sw          LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)   # 無INVOICE可否產生應收帳款
DEFINE amt0_sw          LIKE type_file.chr1          #CHI-B30024 add             # 出貨金額為0立帳
DEFINE p_row,p_col      LIKE type_file.num5          #No.FUN-680123 SMALLINT
DEFINE g_oma00          LIKE oma_file.oma00          #No.FUN-680123 VARCHAR(2)
DEFINE g_flag           LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
DEFINE g_oga01          like oga_file.oga01          # 出貨單號 #No.FUN-550071
DEFINE g_oga02          LIKE oga_file.oga02          #No.FUN-680123 DATE 
DEFINE g_oga021         LIKE oga_file.oga021         #No.FUN-680123 DATE
DEFINE g_oga08          like oga_file.oga08          # 1.內銷 2.外銷
DEFINE g_oma            RECORD LIKE oma_file.*
DEFINE g_n_oma01        LIKE oma_file.oma01
DEFINE g_t1             LIKE oay_file.oayslip        #No.FUN-680123 VARCHAR(5)     #No.FUN-550071
DEFINE g_quick          LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)     #FUN-570188 add
DEFINE
    g_oar               RECORD LIKE oar_file.*,
    g_gec               RECORD LIKE gec_file.*,
    g_unikey            LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(1)
    l_flag              LIKE type_file.chr1           #No.FUN-680123 VARCHAR(1)
DEFINE begin_no         LIKE oma_file.oma01     #No.FUN-680123 VARCHAR(16)        #FUN-560070
DEFINE g_start,g_end    LIKE oma_file.oma01     #No.FUN-680123 VARCHAR(16)        #FUN-560070
DEFINE g_argv1          LIKE oma_file.oma01     #No.FUN-680123 VARCHAR(16)   #No.FUN-550071
DEFINE l_oga162         LIKE oga_file.oga162
DEFINE g_cnt            LIKE type_file.num10    #No.FUN-680123 INTEGER
DEFINE g_i              LIKE type_file.num5     #No.FUN-680123 SMALLINT   #count/index for any purpose
DEFINE g_msg            LIKE type_file.chr1000  #No.FUN-680123 VARCHAR(72)
DEFINE i                LIKE type_file.num5     #No.FUN-680123 SMALLINT
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680123 SMALLINT
DEFINE g_change_lang        LIKE type_file.chr1          #No.FUN-680123 VARCHAR(01)   #是否有做語言切換 No.FUN-570156
DEFINE g_bookno1            LIKE aza_file.aza81      #No.FUN-740009
DEFINE g_bookno2            LIKE aza_file.aza82      #No.FUN-740009
DEFINE g_oob                RECORD  LIKE oob_file.*          #No.FUN-960140
DEFINE g_ooa                RECORD  LIKE ooa_file.*          #No.FUN-960140
DEFINE g_dept               LIKE    nmh_file.nmh15           #No.FUN-960140
DEFINE g_nmh                RECORD   LIKE nmh_file.*         #No.FUN-960140
DEFINE g_nms                RECORD   LIKE nms_file.*         #No.FUN-960140
DEFINE g_oga57              LIKE oga_file.oga57              #No.FUN-B10058 
DEFINE g_wc3            STRING                       #FUN-C60036 add
#FUN-C60036 add--str
DEFINE g_oaz92    LIKE oaz_file.oaz92      
DEFINE g_oaz93    LIKE oaz_file.oaz93
DEFINE g_omf00    LIKE omf_file.omf00  #minpp add   
DEFINE g_omf01    LIKE omf_file.omf01
DEFINE g_omf02    LIKE omf_file.omf02
#FUN-C60036 add--end
DEFINE g_occ73        LIKE occ_file.occ73      #TQC-CC0107
MAIN
   DEFINE l_oom01   LIKE oom_file.oom01
   DEFINE l_oom02   LIKE oom_file.oom02
   DEFINE l_oom06   LIKE oom_file.oom06          #MOD-C40031 add
   DEFINE l_cnt     LIKE type_file.num5          #No.FUN-680123 SMALLINT
   DEFINE ls_date   STRING                       #No.FUN-570156 
   DEFINE l_flag    LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1) #No.FUN-570156 
   DEFINE l_open_axrp310a LIKE type_file.chr1    #No.FUN-B10004 add
   DEFINE l_oga57   LIKE oga_file.oga57          #No.MOD-C30425   Add
   DEFINE l_ooyacti LIKE ooy_file.ooyacti        #No.MOD-C30425   Add
   DEFINE li_result LIKE type_file.chr1          #No.MOD-C30425   Add
 
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_argv1  = ARG_VAL(1)             #參數一
   LET g_wc     = ARG_VAL(2)             #QBE條件
   LET ar_type  = ARG_VAL(3)             #選擇帳款種類
   LET ar_slip  = ARG_VAL(4)             #帳款單別
   LET ls_date  = ARG_VAL(5)             #應收立帳日期
   LET g_date   = cl_batch_bg_date_convert(ls_date)
   LET conf_sw  = ARG_VAL(6)             #應收帳款產生後應立刻自動確認
   LET open_sw  = ARG_VAL(7)             #應收帳款確認後應自動開立發票
   LET ls_date  = ARG_VAL(8)             #開立發票日期
   LET g_date2  = cl_batch_bg_date_convert(ls_date)
   LET g_oma05  = ARG_VAL(9)             #發票別
   LET noin_sw  = ARG_VAL(10)            #無invoice者應產生應收帳款
   LET g_bgjob  = ARG_VAL(11)            #背景作業
   LET g_enter_account = ARG_VAL(12)     #單價為0立帳否   #FUN-860006 add
   LET l_open_axrp310a = ARG_VAL(13)     #FUN-B10004 add 是否開出axrp310a的畫面
   LET ar_slip1 = ARG_VAL(14)            #FUN-B10058
   LET amt0_sw  = ARG_VAL(15)            #出貨金額為0立帳 #CHI-B30024 add
   LET s_date   = cl_batch_bg_date_convert(ls_date)     #No:FUN-A50103
   LET e_date   = cl_batch_bg_date_convert(ls_date)     #No:FUN-A50103
   LET g_wc3    = ARG_VAL(16)  #FUN-C60036 add
   LET g_wc3    = cl_replace_str(g_wc3, "\\\"", "'") #FUN-C60036 add

   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   #FUN-C60036--add--str
   SELECT oaz92,oaz93 INTO g_oaz92,g_oaz93 FROM oaz_file
   #FUN-C60036--add--end
   LET g_wc1 = " azp01 IN ('",g_plant,"')" #No.FUN-9C0014 Add  #TQC-9C0185 mod
   IF NOT cl_null(g_argv1) THEN
     #LET g_wc   =" oga01 MATCHES '",g_argv1,"'"   #TQC-AC0272 mark
      LET g_wc   =" oga01 = '",g_argv1,"'"         #TQC-AC0272
      #FUN-C60036-add--str
      SELECT oaz92 INTO g_oaz.oaz92 FROM oaz_file
      IF g_oaz.oaz92 = 'Y' AND g_aza.aza26 = '2' THEN 
         LET g_wc = "1=1"
      END IF
      #FUN-C60036--add--end
      LET ar_type='2'
      LET g_oma00='12'                             #TQC-AC0272
      LET ar_slip=NULL
      LET ar_slip1=NULL          #FUN-B10058
      LET g_date =ARG_VAL(2)     #發票日期
      LET conf_sw='Y'
      LET open_sw='Y'
     #LET g_date2=g_date         #MOD-A80242 mark
      LET g_date2=NULL           #MOD-A80242
      LET g_oma05=ARG_VAL(3)     #發票別
      LET g_oma212=ARG_VAL(4)    #發票聯數
      LET noin_sw='Y'
      LET amt0_sw='N'            #CHI-B30024 add
      LET g_enter_account = 'N'  #MOD-C60094
      IF g_oma212='X' THEN LET open_sw='N' END IF   #NO:6965
      #判斷開立方式='1'且聯數<> 'X' 才可自動開立
      IF g_oma212 IS NOT NULL AND g_oma212 <> 'X' THEN
          LET l_oom01 =YEAR(g_date)
          LET l_oom02 = MONTH(g_date) USING "&&"
         #判斷是否有電腦開立之發票
#No.FUN-B90130 --begin 
         IF g_aza.aza26 ='2' THEN 
            SELECT COUNT(*) INTO l_cnt
              FROM oom_file
             WHERE oom01 = l_oom01
               AND l_oom02 BETWEEN oom02 AND oom021
                AND oom03=g_oma05
                AND oom15 = g_oma212
                AND (oom08>oom09 OR oom09 IS NULL)
                AND oom06='1' 
         ELSE
            SELECT COUNT(*) INTO l_cnt
              FROM oom_file
             WHERE oom01 = l_oom01
               AND l_oom02 BETWEEN oom02 AND oom021
                AND oom03=g_oma05
                AND oom04 = g_oma212
                AND (oom08>oom09 OR oom09 IS NULL)
                AND oom06='1'
         END IF  
#No.FUN-B90130 --end 
          IF l_cnt > 0 THEN
             LET open_sw='Y'
          ELSE
             LET open_sw='N'
          END IF
      END IF
 
      LET INT_FLAG = 0 
 
  #FUN-B10004--add----str---
  IF NOT cl_null(l_open_axrp310a) AND (l_open_axrp310a = 'N') THEN
      #CRM時,產生應收帳款是否自動確認,決定於單別(axri010)的設定
      CALL s_get_doc_no(g_argv1) RETURNING g_t1     
      SELECT ooyconf INTO g_quick
        FROM ooy_file 
       WHERE ooyslip=g_t1  
      IF cl_null(g_quick) THEN
          LET g_quick='Y'
      END IF
  ELSE
     #No.MOD-C30425   ---start---   Add
      SELECT oga57 INTO l_oga57 FROM oga_file WHERE oga01 = g_argv1
      IF l_oga57 = '1' THEN
         LET g_oma00 = '12'
      ELSE
         LET g_oma00 = '19'
      END IF
      #FUN-C60036--add--str
      IF g_oaz.oaz92 = 'Y' AND g_aza.aza26 = '2' THEN
         LET g_oma00 = '12'
      END IF
      #FUN-C60036--ad--end
     #No.MOD-C30425   ---end---     Add
  #FUN-B10004--add----end---
      OPEN WINDOW p310_wa WITH FORM "axr/42f/axrp310a"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
      CALL cl_ui_init()     #No.TQC-630091 add
      CALL cl_ui_locale("axrp310a")
      CALL cl_load_act_sys("axrp310a")
      CALL cl_load_act_list("axrp310a")
 
      CALL cl_used(g_prog,g_time,1) RETURNING g_time 
      CALL cl_set_comp_visible("group03", FALSE)   #FUN-990031 
      #FUN-C60036--add--str
      IF g_oaz.oaz92 = 'Y' AND g_aza.aza26 = '2' THEN
         CALL cl_set_comp_visible("oma05,oma10",FALSE)
      END IF
      #FUN-C60036--ad--end
      
      #LET g_argv1=NULL #TQC-B90233  #TQC-BC0099 mark
      INPUT g_argv1,g_oma05 WITHOUT DEFAULTS FROM oma01,oma05
         AFTER FIELD oma05
            IF g_oaz.oaz92 != 'Y' OR g_aza.aza26 !='2' THEN #FUN-C60036--add
               IF g_oma05 IS NULL THEN NEXT FIELD oma05 END IF
            END IF #FUN-C60036--add
          #---------MOD-C40031----------(S)
           IF g_aza.aza26 = '2' THEN
              SELECT oom06 INTO l_oom06
                FROM oom_file
               WHERE oom01 = l_oom01
                 AND l_oom02 BETWEEN oom02 AND oom021
                  AND oom03 = g_oma05
                  AND oom15 = g_oma212
                  AND (oom08 > oom09 OR oom09 IS NULL)
           ELSE
              SELECT oom06 INTO l_oom06
                FROM oom_file
               WHERE oom01 = l_oom01
                 AND l_oom02 BETWEEN oom02 AND oom021
                  AND oom03 = g_oma05
                  AND oom04 = g_oma212
                  AND (oom08 > oom09 OR oom09 IS NULL)
           END IF

           IF l_oom06 = '1' THEN
              LET open_sw = 'Y'
           ELSE
              LET open_sw = 'N'
           END IF
          #---------MOD-C40031----------(E)
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
    
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
    
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(oma01)
                 #LET g_oma00 = '12'  #出貨    #No.MOD-C30425   Mark
                  CALL q_ooy(FALSE,FALSE,g_argv1,g_oma00,'AXR') RETURNING g_argv1
                  LET ar_slip = g_argv1
                  DISPLAY g_argv1 TO oma01
            END CASE
 
         AFTER FIELD oma01
            IF NOT cl_null(g_argv1) THEN
               LET l_cnt = 0
               #檢查單號是否已存在
               SELECT COUNT(*) INTO l_cnt FROM oma_file WHERE oma01=g_argv1
               IF l_cnt > 0 THEN
                  CALL cl_err('','sub-144',0)
                  NEXT FIELD oma01
               END IF
              #No.MOD-C30425   ---start---   Add
               LET l_ooyacti = NULL
               SELECT ooyacti INTO l_ooyacti FROM ooy_file
                WHERE ooyslip = g_argv1
               IF l_ooyacti <> 'Y' THEN
                  CALL cl_err(g_t1,'axr-956',1)
                  NEXT FIELD oma01
               END IF
               CALL  s_check_no("axr",g_argv1,"",g_oma00,"","","")
                     RETURNING li_result,g_argv1
               DISPLAY g_argv1 TO oma01
               IF (NOT li_result) THEN
                  NEXT FIELD oma01
               ELSE
                  IF l_oga57 = '1' THEN
                     LET ar_slip = g_argv1
                  ELSE
                     LET ar_slip1 = g_argv1
                  END IF
               END IF 
              #No.MOD-C30425   ---end---   Add
            END IF

      END INPUT
 
      IF INT_FLAG THEN
         CLOSE WINDOW p310_wa
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
 
      IF g_oaz92 !='Y' OR g_aza.aza26 != '2'  THEN#FUN-C60036 add
         IF g_ooz.ooz13 = '2' THEN
            IF cl_confirm('axr-241') THEN   #轉應收帳款後是否自動確認(Y/N) ?
               LET g_quick='Y'
            ELSE
               LET g_quick='N'
            END IF
         END IF
      END IF #FUN-C60036 add
  END IF #FUN-B10004--add
      CALL p310_p()
      CALL s_showmsg()           #NO.FUN-710050
      IF g_success = "Y" THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
 
     #DROP TABLE p310_tmp   #No.FUN-960140 #MOD-AA0133 mark
      CLOSE WINDOW p310_wa
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
 
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p310()
         IF cl_sure(18,20) THEN 
            LET g_success = 'Y'
            CALL p310_1()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p310_w 
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         CALL p310_1()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p310()
   DEFINE li_result LIKE type_file.num5          #No.FUN-680123 SMALLINT #No.FUN-550071
   DEFINE lc_cmd    LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(500)      #No.FUN-570156
   DEFINE l_azp02   LIKE azp_file.azp02          #FUN-630043
   DEFINE l_azp03   LIKE azp_file.azp03          #FUN-630043
   DEFINE l_ooyacti LIKE ooy_file.ooyacti        #No.TQC-770021
 
   LET p_row = 2 LET p_col = 8
   OPEN WINDOW p310_w AT p_row,p_col WITH FORM "axr/42f/axrp310"
        ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()
   CALL cl_set_comp_visible("group03", FALSE)   #FUN-990031
   CALL cl_set_comp_visible("ogaplant",FALSE)   #No.FUN-9C0014
   #FUN-B10058--add--str--
   IF g_azw.azw04 <> '2' THEN
      CALL cl_set_comp_visible("ar_slip1",FALSE)
   END IF 
   #FUN-B10058--add--end

   ##FUN-C60036--add--str
   #   IF g_oaz92 !='Y' OR g_aza.aza26 != '2'  THEN
   #      CALL cl_set_comp_visible("group04", FALSE)
   #   END IF 
   ##FUN-C60036--add--end
   
   #No.MOD-D60125  --Begin
  # IF g_oaz92='Y' AND g_aza.aza26='2' THEN
  #   CALL cl_set_comp_visible("group01",FALSE)
  # ELSE
  #    CALL cl_set_comp_visible("group04",FALSE)
  # END IF
   #No.MOD-D60125  --End
 
   CLEAR FORM

   WHILE TRUE
      CALL cl_opmsg('w')
      MESSAGE ""
      CONSTRUCT BY NAME g_wc1 ON azp01
         BEFORE CONSTRUCT                 #CHI-B30044
            DISPLAY g_plant TO azp01      #CHI-B30044

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT CONSTRUCT

         ON ACTION exit              #加離開功能genero
              LET INT_FLAG = 1
              EXIT CONSTRUCT

         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(azp01)  #機構別
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azw"
                   LET g_qryparam.where = "azw02 = '",g_legal,"' "
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO azp01
                   NEXT FIELD azp01
            END CASE
      END CONSTRUCT

      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p310_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      IF g_wc1 = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE

   WHILE TRUE
      CALL cl_opmsg('w')
      MESSAGE "" 
     # IF g_oaz92 = 'N' OR cl_null(g_oaz92) THEN     #MOD-D60125
      CONSTRUCT BY NAME g_wc ON oga01,oga02,oga21,oga05,oga15,ogaplant   #FUN-960140 add ogaplant
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
         
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
         
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION locale            #genero
            LET g_change_lang = TRUE
            EXIT CONSTRUCT
 
         ON ACTION exit              #加離開功能genero
            LET INT_FLAG = 1
            EXIT CONSTRUCT
      
         ON ACTION CONTROLP
            CASE
               #TQC-A40114--Add--Begin                                                                                                     
               WHEN INFIELD(oga01)                                                                                                    
                  CALL q_oea30(TRUE,TRUE) RETURNING g_qryparam.multiret                                                                                   
                  DISPLAY g_qryparam.multiret TO oga01                                                                                 
                  NEXT FIELD oga01                                                                                                     
               #TQC-A40114--Add--End
               WHEN INFIELD(ogaplant)  #機構別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azw"
                  LET g_qryparam.where = "azw02 = '",g_legal,"' "
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ogaplant
                  NEXT FIELD ogaplant
            END CASE 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup') #FUN-980030

      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW p310_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF

      IF g_wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
#    END IF  #MOD-D60125
      #FUN-C60036--add--str
   IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN 
#      LET g_wc = ' 1=1'   #MOD-D60125   
      CONSTRUCT BY NAME g_wc3 ON omf00,omf01,omf02  #FUN-C60036  minpp  add--omf00 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION about         
            CALL cl_about()     

         ON ACTION help         
            CALL cl_show_help()  

         ON ACTION controlg      
            CALL cl_cmdask()    


         ON ACTION locale         
            LET g_change_lang = TRUE
            EXIT CONSTRUCT

         ON ACTION exit              
              LET INT_FLAG = 1
              EXIT CONSTRUCT
         ON ACTION controlp
            CASE
              #FUN-C60036--minpp---ADD--str
               WHEN INFIELD(omf00)
                  #No.CHI-D50042  --Begin
                  #CALL cl_init_qry_var()
                  #LET g_qryparam.state = "c"
                  #LET g_qryparam.form ="q_omf"
                  #CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_omf1(TRUE,TRUE,'','1') RETURNING g_qryparam.multiret
                  #No.CHI-D50042  --End
                  DISPLAY g_qryparam.multiret TO omf00
                  NEXT FIELD omf00
              #FUN-C60036--minpp---add--end
               WHEN INFIELD(omf01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_omf01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO omf01
                  NEXT FIELD omf01
               WHEN INFIELD(omf02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_omf02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO omf02
                  NEXT FIELD omf02
            END CASE
      END CONSTRUCT
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()              
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW gisp101_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
   END IF
   #FUN-C60036--add--end
      LET g_date=g_today
      LET conf_sw='N'
      LET open_sw='N'
      LET noin_sw='N'
      LET g_date=NULL
      LET g_date2=NULL
      LET ar_type='2'
      LET g_bgjob = "N"            #No.FUN-570156
      LET g_enter_account = 'N'    #FUN-860006 add 
      LET amt0_sw='N'              #CHI-B30024 add
      CALL cl_opmsg('a')
 
      INPUT BY NAME ar_type,s_date,e_date,ar_slip,ar_slip1,g_date,conf_sw,open_sw,     #No:FUN-A50103 #FUN-B10058 add ar_slip1
                    g_date2,g_oma05,noin_sw,g_enter_account,amt0_sw,g_bgjob  #No.FUN-570156 #FUN-860006 add  #CHI-B30024 add amt0_sw
                    WITHOUT DEFAULTS
      
         BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL p310_set_entry('')
            CALL p310_set_no_entry('')
            LET g_before_input_done = TRUE
      
         AFTER FIELD ar_type
            IF ar_type IS NULL THEN
               NEXT FIELD ar_type
            END IF
            IF ar_type NOT MATCHES "[123]" THEN
               NEXT FIELD ar_type
            END IF
            CASE
               WHEN ar_type = '1'
                  LET g_oma00 = '11'  #訂金
                  #-----No:FUN-A50103-----
                  CALL cl_set_comp_entry("s_date,e_date",TRUE)
                 #LET s_date=g_today                            #MOD-B90170 mark
                 #LET e_date=g_today                            #MOD-B90170 mark
                  DISPLAY BY NAME s_date,e_date
                  #-----No:FUN-A50103 END-----
               WHEN ar_type = '2'
                  LET g_oma00 = '12'  #出貨
                  #-----No:FUN-A50103-----
                  CALL cl_set_comp_entry("s_date,e_date",FALSE)
                  LET s_date= NULL
                  LET e_date= NULL
                  DISPLAY BY NAME s_date,e_date
                  #-----No:FUN-A50103 END-----
               WHEN ar_type = '3'
                  LET g_oma00 = '13'  #尾款
                  #-----No:FUN-A50103-----
                  CALL cl_set_comp_entry("s_date,e_date",TRUE)
                 #LET s_date=g_today        #MOD-B90170 mark
                 #LET e_date=g_today        #MOD-B90170 mark
                  DISPLAY BY NAME s_date,e_date
                  #-----No:FUN-A50103 END-----
            END CASE
      
         #-----No:FUN-A50103-----
         AFTER FIELD e_date
            IF e_date < s_date THEN
               CALL cl_err(e_date,'aap-100',1)
               NEXT FIELD e_date
            END IF
         #-----No:FUN-A50103 END-----
      
         AFTER FIELD ar_slip
            IF NOT cl_null(ar_slip) THEN
               LET l_ooyacti = NULL
               SELECT ooyacti INTO l_ooyacti FROM ooy_file
                WHERE ooyslip = ar_slip
               IF l_ooyacti <> 'Y' THEN
                  CALL cl_err(ar_slip,'axr-956',1)
                  NEXT FIELD ar_slip
               END IF
               CALL s_check_no("axr",ar_slip,"",g_oma00,"","","")
                     RETURNING li_result,ar_slip
               IF (NOT li_result) THEN
                 LET g_success='N'
                 NEXT FIELD ar_slip
               END IF
               DISPLAY BY NAME ar_slip
            END IF
         #FUN-B10058--add--str--
         AFTER FIELD ar_slip1
            IF NOT cl_null(ar_slip1) THEN
               LET l_ooyacti = NULL
               SELECT ooyacti INTO l_ooyacti FROM ooy_file
                WHERE ooyslip = ar_slip1
               IF l_ooyacti <> 'Y' THEN
                  CALL cl_err(ar_slip1,'axr-956',1)
                  NEXT FIELD ar_slip1
               END IF
               CALL s_check_no("axr",ar_slip1,"",19,"","","")
                     RETURNING li_result,ar_slip1
               IF (NOT li_result) THEN
                 LET g_success='N'
                 NEXT FIELD ar_slip1
               END IF
               DISPLAY BY NAME ar_slip1
            END IF
         #FUN-B10058--add--end
      
         ON CHANGE conf_sw
            CALL p310_set_entry('')
            CALL p310_set_no_entry('')
      
           #No.+227 010626 by plum ooz13 for 出貨/尾款
            IF g_ooz.ooz13 = '3' AND ar_type !='1' THEN
               NEXT FIELD noin_sw
            END IF
      
         BEFORE FIELD open_sw
            CALL p310_set_entry('')
      
         AFTER FIELD open_sw
            IF open_sw = 'N'  THEN
               LET g_date2=NULL
               LET g_oma05=' '
               DISPLAY BY NAME g_date2
               DISPLAY BY NAME g_oma05
            END IF
            CALL p310_set_no_entry('')
      
         AFTER FIELD g_enter_account 
            IF g_enter_account NOT MATCHES "[YN]" THEN
               NEXT FIELD g_enter_account
            END IF
      
        #str CHI-B30024 add
         AFTER FIELD amt0_sw
            IF amt0_sw NOT MATCHES "[YN]" THEN 
               NEXT FIELD amt0_sw
            END IF
        #end CHI-B30024 add

         AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF    #No.FUN-570156
            IF open_sw='Y' THEN                 #g_date2不為空白
               IF cl_null(g_date2) THEN
                  NEXT FIELD g_date2
               END IF
               IF cl_null(g_oma05) THEN         #g_oma05不為空白
                  NEXT FIELD g_oma05
               END IF
            END IF
      
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
      
         ON ACTION CONTROLG
            call cl_cmdask()
      
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ar_slip) # Class
                  CALL q_ooy(FALSE,FALSE,ar_slip,g_oma00,'AXR') RETURNING ar_slip   #NO:6842   #TQC-670008
                  DISPLAY BY NAME ar_slip
               #FUN-B10058--add--str--
               WHEN INFIELD(ar_slip1) # Class
                  CALL q_ooy(FALSE,FALSE,ar_slip1,'19','AXR') RETURNING ar_slip1
                  DISPLAY BY NAME ar_slip1
               #FUN-B10058--add--end
            END CASE
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
      
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
      
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
      
         ON ACTION exit      #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
      END INPUT
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW p310_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "axrp310"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('axrp310','9031',1)
         ELSE
            LET g_wc=cl_replace_str(g_wc, "'", "\"")
            LET lc_cmd = lc_cmd CLIPPED,
                         " ''",
                         " '",g_wc    CLIPPED,"'",
                         " '",ar_type CLIPPED,"'",
                         " '",ar_slip CLIPPED,"'",
                         " '",g_date  CLIPPED,"'",
                         " '",conf_sw CLIPPED,"'",
                         " '",open_sw CLIPPED,"'",
                         " '",g_date2 CLIPPED,"'",
                         " '",g_oma05 CLIPPED,"'",
                         " '",noin_sw CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_enter_account CLIPPED,"'",  #No:FUN-A50103     #FUN-860006
                         " '",s_date  CLIPPED,"'",          #No:FUN-A50103
                         " '",e_date  CLIPPED,"'",          #No:FUN-A50103
                         " '",ar_slip1 CLIPPED,"'",         #FUN-B10058
                         " '",amt0_sw CLIPPED,"'"           #CHI-B30024 add 
            CALL cl_cmdat('axrp310',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p310_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      EXIT WHILE
 
   END WHILE

END FUNCTION
 
FUNCTION p310_1()

  #IF ar_type='1' THEN                     #CHI-A50040 mark
   IF ar_type='1' OR ar_type = '3' THEN    #CHI-A50040
      LET g_wc= cl_replace_str(g_wc,'oga','oea')
   END IF

   IF ar_type='4' THEN
      LET g_wc= cl_replace_str(g_wc,'oga','oha')
   END IF

   IF g_ooz.ooz13='2' THEN
     IF conf_sw = 'Y' THEN LET g_quick='Y' END IF
   END IF

   CALL p310_p()

   CALL s_showmsg()  #MOD-960168 

END FUNCTION
 
FUNCTION p310_p()
   DEFINE l_oga909   LIKE oga_file.oga909    #三角貿易否
   DEFINE l_oga09    LIKE oga_file.oga09     #單據別   #MOD-940332 add
   DEFINE l_oga16    LIKE oga_file.oga16     #訂單單號
   DEFINE l_oea904   LIKE oea_file.oea904    #流程代碼
   DEFINE l_oga00    LIKE oga_file.oga00     #流程代碼
   DEFINE l_n        LIKE type_file.num5     #No.FUN-680123 SMALLINT
   DEFINE li_result  LIKE type_file.num5     #No.FUN-680123 SMALLINT                #No.FUN-550071
   DEFINE l_ofa01    LIKE ofa_file.ofa01     #FUN-640191
   DEFINE l_oaz67    LIKE oaz_file.oaz67     #MOD-760080
   DEFINE l_poz18    LIKE poz_file.poz18,
          l_poz19    LIKE poz_file.poz19,
          l_poz01    LIKE poz_file.poz01,
          l_c        LIKE type_file.num5
  #DEFINE l_oea918   LIKE oea_file.oea918       #FUN-8C0078 #MOD-AA0063 mark
  #DEFINE l_oea919   LIKE oea_file.oea919       #FUN-8C0078 #MOD-AA0063 mark
   DEFINE l_rxx04    LIKE rxx_file.rxx04       #No.FUN-960140
   DEFINE l_cnt      LIKE type_file.num5   #MOD-960045
   DEFINE l_azp01    LIKE azp_file.azp01   #No.FUN-9C0014
   DEFINE l_oeaa03   LIKE oeaa_file.oeaa03    #No:FUN-A50103
   DEFINE l_oeaan    LIKE type_file.num5      #No:FUN-A50103
   DEFINE l_omaconfchk  LIKE type_file.chr1   #MOD-AA0013
   DEFINE g_forupd_sql   STRING                 #SELECT ... FOR UPDATE SQL #MOD-B10033
   DEFINE l_yy,l_mm	 LIKE type_file.num10   #MOD-B10033
   DEFINE l_oom	  	 RECORD LIKE oom_file.* #MOD-B10033
   DEFINE l_lock_sw      LIKE type_file.chr1    #MOD-B10033
   DEFINE ar_slipx   LIKE oay_file.oayslip      #MOD-BB0081 add
   DEFINE ar_slip1x  LIKE oay_file.oayslip      #MOD-BB0081 add 
   DEFINE l_omb31    LIKE omb_file.omb31        #MOD-BC0167
   DEFINE l_omb44    LIKE omb_file.omb44        #MOD-BC0167
   DEFINE l_oga23    LIKE oga_file.oga23        #MOD-BC0167
   DEFINE l_oga24    LIKE oga_file.oga24        #MOD-BC0167
   DEFINE l_oga011   LIKE oga_file.oga011       #MOD-C30842 add
   DEFINE l_oga232   LIKE oga_file.oga23        #MOD-C30842 add
   DEFINE l_oga242   LIKE oga_file.oga24        #MOD-C30842 add
   DEFINE   ls_n,ls_n2     LIKE type_file.num10 #FUN-C60036 add xuxz
   DEFINE l_omf00           LIKE omf_file.omf00    #FUN-CB0057 add
   DEFINE l_oay11    LIKE oay_file.oay11        #TQC-D20046 add
   DEFINE l_slip     LIKE oay_file.oayslip      #TQC-D20046 add

   #No.yinhy130722 ---begin---
   DROP TABLE y
   SELECT oga01 FROM oga_file WHERE 1=2 INTO TEMP y
   #No.yinhy130722 ---end---
   
   #FUN-C60036--add--str--
   LET ls_n = 0
   LET g_sql = " SELECT COUNT(*) FROM omf_file ",
               "  WHERE omf10 = '9' ",
               "    AND ",g_wc3
   PREPARE omf10_per FROM g_sql
   EXECUTE omf10_per INTO ls_n
   LET ls_n2 = 0
   LET g_sql = " SELECT COUNT(*) FROM omf_file ",
               "  WHERE omf10! = '9' ",
               "    AND ",g_wc3
   PREPARE omf10_per2 FROM g_sql
   EXECUTE omf10_per2 INTO ls_n2
   #FUN-C60036--add--end
 
   DROP TABLE x    #此臨時表是為s_t300_rgl建      #MOD-AA0133
   SELECT * FROM npq_file WHERE 1=2 INTO TEMP x   #MOD-AA0133

   LET ar_slipx = ar_slip                       #MOD-BB0081 add
   LET ar_slip1x = ar_slip1                     #MOD-BB0081 add
  #-MOD-B10033-add-
#No.FUN-B90130 --begin
   LET g_forupd_sql = "SELECT * FROM oom_file ", 
                      " WHERE oom01 = ? AND ? BETWEEN oom02 AND oom021 ",
                      "   AND oom03 = ?  AND oom06 = '1' ",
                      "   AND (oom08>oom09 OR oom09 IS NULL)  "
   IF g_aza.aza26 ='2' THEN  
      LET g_forupd_sql = g_forupd_sql," AND oom15 = ?  FOR UPDATE "
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   ELSE
      LET g_forupd_sql = g_forupd_sql," AND oom04 = ?  FOR UPDATE "
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   END IF  
#   LET g_forupd_sql = "SELECT * FROM oom_file ", 
#                      " WHERE oom01 = ? AND ? BETWEEN oom02 AND oom021 ",
#                      "   AND oom03 = ? AND oom04 = ? AND oom06 = '1' ",
#                      "   AND (oom08>oom09 OR oom09 IS NULL) FOR UPDATE "
#No.FUN-B90130 --end   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE oom_lock_cl CURSOR FROM g_forupd_sql  
  #-MOD-B10033-end-

   BEGIN WORK
   LET g_success='Y'
   LET g_start1 = ''
   CALL s_showmsg_init()

   LET g_sql = "SELECT azp01,azp03 FROM azp_file,azw_file ",
               " WHERE ",g_wc1 CLIPPED,
               "   AND azw01 = azp01 AND azw02 = '",g_legal,"'"

   PREPARE sel_azp03_pre FROM g_sql
   DECLARE sel_azp03_cs CURSOR FOR sel_azp03_pre

   FOREACH sel_azp03_cs INTO l_azp01,l_dbs
      IF STATUS THEN
         CALL cl_err('p310(ckp#1):',SQLCA.sqlcode,1)
         RETURN
      END IF

      LET g_plant_new = l_azp01
      CALL s_gettrandbs()
      LET l_dbs = g_dbs_tra
      LET source = l_azp01
 
      #No.B369 010423 by plum add 若立帳日期不為空白時check單據日期及立帳日要同年月
      LET l_flag='N'
      IF NOT cl_null(g_date) THEN
        #IF ar_type <> '1' THEN #CHI-A40009 add   #CHI-A50040 mark
         IF ar_type = '2'  THEN #CHI-A40009 add   #CHI-A50040
            CALL p310_chkdate()
         END IF                 #CHI-A40009 add
         IF l_flag='X' THEN
            LET g_success = 'N'   #No.FUN-570156
            RETURN
         END IF
         IF l_flag='Y' THEN
            CALL cl_err('','axr-065',1)
            LET g_success = 'N'   #No.FUN-570156
            RETURN
         END IF
      END IF
      
      CASE
         WHEN ar_type='1'
            IF g_azw.azw04 <> '2' THEN     #TQC-B80126 add
               LET g_sql=
               #"SELECT oea01,oea02,'',azi03,azi04,azi05,' ',oea00,oea918,oea919",  #FUN-8C0078 add oea918,oea919 #MOD-AA0063 mark
                "SELECT '','','',oea01,oea02,'',azi03,azi04,azi05,' ',oea00,''",                #MOD-AA0063  #FUN-BA0058 add ''  #FUN-C60036 '','',#minpp add ''             
                #"   FROM ",l_dbs CLIPPED,"oea_file LEFT OUTER JOIN ",l_dbs CLIPPED,"azi_file ON oea_file.oea23=azi_file.azi01,",l_dbs CLIPPED,"oay_file",#No.FUN-9C0014
                "   FROM ",cl_get_target_table(l_azp01,'oea_file'),                           #FUN-A50102
                " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'azi_file'),                  #FUN-A50102
                " ON oea_file.oea23=azi_file.azi01,",cl_get_target_table(l_azp01,'oay_file'), #FUN-A50102
                "  WHERE ",g_wc CLIPPED,
                "    AND oeaplant = '",l_azp01,"'",  #No.FUN-9C0014 Add
               #"    AND oea00='1' AND oea161>0 AND oeaconf='Y' ",
                "    AND oea00='1' AND oea261>0 AND oeaconf='Y' ",    #No:FUN-A50103
                "  AND  oea01 like ltrim(rtrim(oayslip)) || '-%' AND oay11='Y'"   #No.FUN-550071
            #No.TQC-B80126  --Begin #ar_type為1且azw04為2時，去掉oea261>0的條件
            ELSE
                 LET g_sql=
                "SELECT '','','',oea01,oea02,'',azi03,azi04,azi05,' ',oea00,''",#FUN-C60036 '','', #minpp add ''
                "   FROM ",cl_get_target_table(l_azp01,'oea_file'),
                " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'azi_file'),
                " ON oea_file.oea23=azi_file.azi01,",cl_get_target_table(l_azp01,'oay_file'),
                "  WHERE ",g_wc CLIPPED,
                "    AND oeaplant = '",l_azp01,"'",
                "    AND oea00='1'  AND oeaconf='Y' ",
                "  AND  oea01 like ltrim(rtrim(oayslip)) || '-%' AND oay11='Y'"
            END IF
            #No.TQC-B80126  --End
         WHEN ar_type='2'
            #FUN-C60036--ad--str
            IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN 
               IF ls_n > 0 THEN 
                  LET g_sql =" SELECT UNIQUE omf00,omf01,omf02,oga01,oga02,oga021,azi03,azi04,azi05,oga08,oga00,oga57",
                             "   FROM omf_file LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'oga_file'),
                             "     ON omf11 = oga01 AND ",g_wc," AND ogaplant = '",l_azp01,"'",
                             "    AND oga162>=0 AND ogaconf='Y' ",
                             "    AND oga09 IN ('2','3','8','A','4','6') AND ogapost='Y' ", #MOD-B30536
                             "    AND oga65 ='N' ",
                             "    AND oga00 IN ('1','4','5','6','B')" 
                  IF amt0_sw!='Y' THEN
                     LET g_sql = g_sql CLIPPED,"    AND oga50>0"
                  END IF
                   LET g_sql = g_sql CLIPPED , "   AND oga01 IN (SELECT DISTINCT omf11 FROM omf_File ",
                               " WHERE omf08 = 'Y' AND omf10 = '1' ",
                               "   AND omf04 IS NULL ",
                               "   AND omf09 = '",l_azp01,"'",
                               "   AND ",g_wc3
                   IF g_oaz93 = 'Y' AND ls_n2 > 0 THEN LET g_sql = g_sql CLIPPED," AND omfpost = 'Y' "END IF
                   LET g_sql = g_sql CLIPPED," ) ",
                             "  LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'azi_file'),
                             "    ON omf07 = azi01 LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'oay_file'),
                             #"    ON  oga01 like ltrim(rtrim(oayslip)) || '-%' AND oay11='Y'",    #TQC-D20046---mark---
                             "    ON  oga01 like ltrim(rtrim(oayslip)) || '-%' ",                  #TQC-D20046---add---
                             " WHERE omf08 = 'Y' AND  omf09 = '",l_azp01,"'", 
                             "   AND omf04 IS NULL ",
                             "   AND ",g_wc3,
                             " ORDER BY omf00,omf01,omf02 "
               ELSE
               LET g_sql=
            #"SELECT omf01,omf02,oga01,oga02,oga021,azi03,azi04,azi05,oga08,oga00,oga57",    #FUN-C60036--minpp--mark
             "SELECT UNIQUE omf00,omf01,omf02,oga01,oga02,oga021,azi03,azi04,azi05,oga08,oga00,oga57",    #FUN-C60036--minpp--add
             "   FROM ",cl_get_target_table(l_azp01,'oga_file'),                           
             " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'azi_file'),                  
             " ON oga_file.oga23=azi_file.azi01,",cl_get_target_table(l_azp01,'oay_file'),
             " ,omf_file ", 
             "  WHERE ",g_wc CLIPPED,
             "    AND ogaplant = '",l_azp01,"'",  
             "    AND oga162>=0 AND ogaconf='Y' ",
             "    AND oga09 IN ('2','3','8','A','4','6') AND ogapost='Y' ", #MOD-B30536
             "    AND oga65 ='N' ",  
             "    AND oga00 IN ('1','4','5','6','B')",  #換貨出貨不應重複產生AR
             #"  AND  oga01 like ltrim(rtrim(oayslip)) || '-%' AND oay11='Y'",   #TQC-D20046---mark---
             "  AND  oga01 like ltrim(rtrim(oayslip)) || '-%' ",                 #TQC-D20046---add---
             "   AND oga01 = omf11 ",
             "   AND ",g_wc3
             IF amt0_sw!='Y' THEN
               LET g_sql = g_sql CLIPPED,"    AND oga50>0"
            END IF
             LET g_sql = g_sql CLIPPED , "   AND oga01 IN (SELECT DISTINCT omf11 FROM omf_File ",
                               " WHERE omf08 = 'Y' AND omf10 = '1' ",
                               "   AND omf04 IS NULL ",
                               "   AND omf09 = '",l_azp01,"'",
                               "   AND ",g_wc3
                               
            IF g_oaz93 = 'Y' THEN LET g_sql = g_sql CLIPPED," AND omfpost = 'Y' "END IF 
            LET g_sql = g_sql CLIPPED," ) 
            ORDER BY omf00,omf01,omf02"          ##FUN-C60036--minpp--add--omf00
            END IF 
            ELSE 
            #FUN-C60036--add--end
            LET g_sql=
             "SELECT '','','',oga01,oga02,oga021,azi03,azi04,azi05,oga08,oga00,oga57",  #FUN-BA0058 add oga57#FUN-C60036 '','',#minpp add ''
             #"   FROM ",l_dbs CLIPPED,"oga_file LEFT OUTER JOIN ",l_dbs CLIPPED,"azi_file ON oga_file.oga23=azi_file.azi01,",l_dbs CLIPPED,"oay_file",#No.FUN-9C0014
             "   FROM ",cl_get_target_table(l_azp01,'oga_file'),                           #FUN-A50102
             " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'azi_file'),                  #FUN-A50102
             " ON oga_file.oga23=azi_file.azi01,",cl_get_target_table(l_azp01,'oay_file'), #FUN-A50102
             "  WHERE  (oga10 IS NULL OR oga10 = ' ')",
             "    AND ",g_wc CLIPPED,
             "    AND ogaplant = '",l_azp01,"'",  #No.FUN-9C0014 Add
             "    AND oga162>=0 AND ogaconf='Y' ",
             #"    AND oga09 IN ('2','3','8','A','4') AND ogapost='Y' ",  #No.FUN-610020   #No.FUN-740016  #CHI-7B0041 modify '4'
             "    AND oga09 IN ('2','3','8','A','4','6') AND ogapost='Y' ", #MOD-B30536
             "    AND oga65 ='N' ",  #No.FUN-610020
            #"    AND oga50>0",                   #MOD-AA0144  #CHI-B30024 mark
             "    AND oga00 IN ('1','4','5','6','B')",  #換貨出貨不應重複產生AR99/05/13 #No.FUN-610064   #No.FUN-740016
             #"  AND  oga01 like ltrim(rtrim(oayslip)) || '-%' AND oay11='Y'"    #No.FUN-550071  #TQC-D20046---mark---
             "  AND  oga01 like ltrim(rtrim(oayslip)) || '-%' "                 #TQC-D20046---add---
            #"   ORDER BY oga01  "  #No.9734   #CHI-B30024 mark
             #判斷若為外銷則裝船日不可null
           #str CHI-B30024 add
            IF amt0_sw!='Y' THEN
               LET g_sql = g_sql CLIPPED,"    AND oga50>0",
                           "   ORDER BY oga01  "  #No.9734
            ELSE
               LET g_sql = g_sql CLIPPED,
                           "   ORDER BY oga01  "  #No.9734
            END IF
           #end CHI-B30024 add
           END IF #FUN-C60036 add
         WHEN ar_type='3'
            LET g_sql=
            #-CHI-A50040-add-
            #"SELECT oga01,oga02,oga021,azi03,azi04,azi05,' ',oga00",
            #"   FROM ",l_dbs CLIPPED,"oga_file LEFT OUTER JOIN ",l_dbs CLIPPED,"azi_file ON oga_file.oga23=azi_file.azi01,",l_dbs CLIPPED,"oay_file", #No.FUN-9C0014
            #"  WHERE  ",g_wc CLIPPED,
            #"    AND ogaplant = '",l_azp01,"'",  #No.FUN-9C0014 Add
            #"    AND oga00 IN('1','6') AND oga163>0 AND ogaconf='Y' ",    #No.FUN-610064
            #"    AND oga09 IN ('2','3','8') AND ogapost='Y' ",  #No.FUN-610020
            #"    AND oga65 ='N' ",  #No.FUN-610020
            #"  AND  oga01 like ltrim(rtrim(oayslip)) || '-%' AND oay11='Y'"   #No.FUN-550071
            #"SELECT oea01,oea02,'',azi03,azi04,azi05,' ',oea00,oea918,oea919",  #MOD-AA0063 mark
             "SELECT '','','',oea01,oea02,'',azi03,azi04,azi05,' ',oea00,''",                #MOD-AA0063 #FUN-B10058 add ''#FUN-C60036 '','',#minpp add ''
             #"   FROM ",l_dbs CLIPPED,"oea_file LEFT OUTER JOIN ",l_dbs CLIPPED,"azi_file ON oea_file.oea23=azi_file.azi01,",l_dbs CLIPPED,"oay_file",
             "   FROM ",cl_get_target_table(l_azp01,'oea_file'),                           #FUN-A50102
             " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'azi_file'),                  #FUN-A50102
             " ON oea_file.oea23=azi_file.azi01,",cl_get_target_table(l_azp01,'oay_file'), #FUN-A50102
             "  WHERE ",g_wc CLIPPED,
             "    AND oeaplant = '",l_azp01,"'",  
            #"    AND oea00='1' AND oea163>0 AND oeaconf='Y' ",
             "    AND oea00='1' AND oea263>0 AND oeaconf='Y' ",    #No:FUN-A50103
             "  AND  oea01 like ltrim(rtrim(oayslip)) || '-%' AND oay11='Y'"   
            #-CHI-A50040-end-
         WHEN ar_type='4'
            LET g_sql=
             "SELECT '','','',oha01,oha02,'',azi03,azi04,azi05,' ',' ',oha57",   #FUN-B10058 add oha57#FUN-C60036 '','',#minpp add ''
             #"   FROM ",l_dbs CLIPPED,"oha_file LEFT OUTER JOIN ",l_dbs CLIPPED,"azi_file ON oha_file.oha23=azi_file.azi01,",l_dbs CLIPPED,"oay_file", #No.FUN-9C0014
             "   FROM ",cl_get_target_table(l_azp01,'oha_file'),                           #FUN-A50102
             " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'azi_file'),                  #FUN-A50102
             " ON oha_file.oha23=azi_file.azi01,",cl_get_target_table(l_azp01,'oay_file'), #FUN-A50102 
             "  WHERE ",g_wc CLIPPED,
             "    AND ohaplant = '",l_azp01,"'",  #No.FUN-9C0014 Add
             "    AND ohaconf='Y' AND ohapost='Y'",
             "  AND  oha01 like ltrim(rtrim(oayslip)) || '-%' AND oay11='Y'"   #No.FUN-550071
      END CASE
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102
      PREPARE p310_prepare FROM g_sql
      DECLARE p310_cs CURSOR WITH HOLD FOR p310_prepare
      LET g_start = NULL     #FUN-960140 add
      LET begin_no  = NULL
     #-MOD-AA0133-mark- 
     #DROP TABLE p310_tmp
     #CREATE TEMP TABLE p310_tmp(
     #  ogb31   LIKE type_file.chr18) 
     #IF STATUS THEN
     #   CALL cl_err('creat p310_tmp:',status,1)
     #END IF
     #DROP TABLE x    #此臨時表是為s_t300_rgl建
     #SELECT * FROM npq_file WHERE 1=2 INTO TEMP x
     #-MOD-AA0133-end- 
      
      FOREACH p310_cs INTO g_omf00,g_omf01,g_omf02,g_oga01, g_oga02,g_oga021,t_azi03,   #MOD-760078#FUN-C60036 add g_omf01,g_omf02,#minpp add-g_omf00
                           t_azi04,t_azi05,g_oga08,l_oga00      #MOD-760078
                           ,g_oga57                             #FUN-B10058 add
                          #l_oea918,l_oea919                    #FUN-8C0078  #MOD-AA0063 mark
         LET ar_slip = ar_slipx                                 #MOD-BB0081 add
         LET ar_slip1 = ar_slip1x                               #MOD-BB0081 add
         IF STATUS THEN
            CALL s_errmsg('','','p310(foreach):',STATUS,1)          #NO.FUN-710050
            LET g_success='N'
            EXIT FOREACH
         END IF
         #TQC-D20046---add---str---
         IF NOT cl_null(g_oga01) THEN
            LET l_slip = s_get_doc_no(g_oga01)
            LET g_sql = "SELECT oay11 ",
                        "  FROM ",cl_get_target_table(l_azp01,'oay_file'),
                        " WHERE oayslip= '",l_slip,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
            PREPARE sel_oay11_pre FROM g_sql
            EXECUTE sel_oay11_pre INTO l_oay11
            IF l_oay11 != 'Y' THEN
               CALL s_errmsg('','',l_slip,'axr-422',1)
               LET g_success='N'
               EXIT FOREACH
            END IF
         END IF
         #TQC-D20046---add---end---
         
         IF g_success='N' THEN                                                                                                          
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF                    
      
         #FUN-B10058--add--str--
         IF g_oga57 = '2' AND cl_null(ar_slip1) THEN
            CALL s_errmsg('','','oga57','axr-375',1) 
            LET g_success = 'N'
            EXIT FOREACH
         END IF 
         #FUN-B10058--add--end
         
         
         INSERT INTO y VALUES (g_oga01)  #No.yinhy130722
         
         LET l_poz01=''

         LET g_sql = "SELECT poz01,poz18,poz19 ",
                     #"  FROM ",l_dbs CLIPPED,"ogb_file,",l_dbs CLIPPED,"oea_file,",l_dbs CLIPPED,"poz_file",
                     "  FROM ",cl_get_target_table(l_azp01,'ogb_file'),",", #FUN-A50102
                               cl_get_target_table(l_azp01,'oea_file'),",", #FUN-A50102
                               cl_get_target_table(l_azp01,'poz_file'),     #FUN-A50102
                     " WHERE oea904 = poz01",
                     "   AND ogb01  = '",g_oga01,"'",
                     "   AND ogb31 = oea01"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102            
         PREPARE sel_poz01_pre FROM g_sql
         EXECUTE sel_poz01_pre INTO l_poz01,l_poz18,l_poz19
       
         IF NOT cl_null(l_poz01) THEN
            LET l_c = 0
            IF l_poz19 = 'Y'  AND g_plant=l_poz18 THEN    #已設立中斷點
               #LET g_sql = " SELECT COUNT(*) FROM ",l_dbs CLIPPED,"poy_file",
               LET g_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_azp01,'poy_file'), #FUN-A50102
                           "  WHERE poy01 = '",l_poz01,"' ",
                           "    AND poy04 = '",l_poz18,"' "
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	           CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102            
               PREPARE sel_poz18_pre FROM g_sql
               EXECUTE sel_poz18_pre INTO l_c
            END IF 
            IF l_c = 0 THEN
               CALL s_errmsg('oga01',g_oga01,'','axr-162',1) #MOD-BC0101 add
               CONTINUE FOREACH   #表示出貨單為多角單據不可由此程式處理
            END IF 
         END IF
      
         CALL s_get_doc_no(g_oga01) RETURNING g_t1      #No.FUN-550071
         #LET g_sql = " SELECT * FROM ",l_dbs CLIPPED,"oay_file WHERE oayslip = '",g_t1,"'"
         LET g_sql = " SELECT * FROM ",cl_get_target_table(l_azp01,'oay_file'), #FUN-A50102
                     " WHERE oayslip = '",g_t1,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102
         PREPARE sel_oay_pre FROM g_sql
         EXECUTE sel_oay_pre INTO g_oay.*
         IF l_oga00 = '5' AND g_oay.oay11 = 'N' THEN
            CONTINUE FOREACH
         END IF
         IF cl_null(g_argv1) THEN
            MESSAGE   '單號:',g_oga01
            CALL ui.Interface.refresh() #CKP
         END IF
         IF g_date IS NULL THEN
            LET t_date=g_oga02
         ELSE
            LET t_date=g_date
         END IF
         IF g_date2 IS NULL THEN
            LET t_date2 = g_oga021
         ELSE
            LET t_date2=g_date2
         END IF
         #FUN-C60036--add--str
         IF cl_null(t_date) THEN 
            SELECT DISTINCT omf03 INTO t_date FROM omf_file WHERE omf00 = g_omf00
         END IF 
         #FUN-C60036--add--end
         IF cl_null(t_date2) THEN
            LET t_date2 = t_date
         END IF 
      
         #FUN-B10058--add--str--
         IF g_oga57 = '2' THEN    #商户开票
            IF ar_slip1 IS NOT NULL THEN 
               CALL s_auto_assign_no("axr",ar_slip1,t_date,'19',"","","","","")
                    RETURNING li_result,g_n_oma01
               IF (NOT li_result) THEN
                   CALL cl_err('','mfg3326',1)
                   LET g_success = 'N'
                   RETURN
               END IF 
               DISPLAY g_n_oma01 TO ar_slip1
            END IF 
         ELSE 
         #FUN-B10058--add--end
            #--- 97-07-25 增加輸入單別並自動編號
            IF ar_slip IS NOT NULL THEN
               CALL s_auto_assign_no("axr",ar_slip,t_date,g_oma00,"","","","","")
               RETURNING li_result,g_n_oma01
               IF (NOT li_result) THEN
                  CALL cl_err('','mfg3326',1) #MOD-980184     
                  LET g_success = 'N'
                  RETURN
               END IF
               DISPLAY g_n_oma01 TO ar_slip
            ELSE
               CALL s_check_no("axr",g_t1,"",g_oma00,"","","")
                   RETURNING li_result,g_n_oma01
                  IF (NOT li_result) THEN
                     CALL s_errmsg('',g_t1,'',g_errno,1)     #MOD-B10150  
                     LET g_success='N'
                     EXIT FOREACH
                  END IF
               DISPLAY  g_n_oma01 TO ar_slip
               IF g_aza.aza97 != 'Y' AND g_aza.aza99 != 'Y' THEN   #FUN-B90112   Add
                  LET g_n_oma01 = g_oga01
                  LET ar_slip = g_oga01       #MOD-B60168
              #FUN-B90112   ---start   Add
               ELSE
                  CALL s_auto_assign_no("axr",g_t1,t_date,g_oma00,"oma_file","oma01","","","")
                  RETURNING li_result,g_n_oma01
                  LET ar_slip = g_t1
               END IF
              #FUN-B90112   ---start   End
            END IF
         END IF   #FUN-B10058

         #---------------------------------------------------------- 產生應收
         CASE
            WHEN ar_type='1'
               #-----No:FUN-A50103-----
               LET l_oeaan = 0
               LET g_sql= "SELECT oeaa03 ",
                          #"  FROM ",l_dbs CLIPPED,"oeaa_file",
                          "  FROM ",cl_get_target_table(l_azp01,'oeaa_file'), #FUN-A50102
                          "  WHERE oeaa01 = '",g_oga01,"' ",
                          "    AND oeaa02 = '1' " 
               IF NOT cl_null(s_date) AND NOT cl_null(e_date) THEN
                  LET g_sql = g_sql," AND oeaa05 BETWEEN '",s_date,"' AND '",e_date,"'"
               END IF
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
               CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102
               PREPARE p310_oeaa1p FROM g_sql
               DECLARE p310_oeaa1 CURSOR WITH HOLD FOR p310_oeaa1p

               IF g_enter_account='N' AND g_azw.azw04 <> '2'THEN     #TQC-C80083  add g_azw.azw04 <> '2'
                  #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"oeb_file",
                  LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_azp01,'oeb_file'), #FUN-A50102
                              " WHERE oeb01 = '",g_oga01,"' AND oeb13<>0"
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
                  CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102            
                  PREPARE sel_oeb_pre FROM g_sql
                  EXECUTE sel_oeb_pre INTO g_cnt
                  IF g_cnt=0 THEN                                                                                                      
                     CONTINUE FOREACH                                                                                                  
                  ELSE                                                                                                                 
                     LET l_cnt = 0   #TQC-B60089
                     FOREACH p310_oeaa1 INTO l_oeaa03
                        #訂單期別已產生訂金不可重複產生
                        SELECT COUNT(*) INTO g_cnt FROM oma_file
                         WHERE oma16 = g_oga01 AND omavoid='N'
                           AND oma165 = l_oeaa03
                           AND oma00 = '11'
                        IF g_cnt = 0 THEN
                           LET l_cnt = l_cnt + 1   #TQC-B60089
                           CALL s_auto_assign_no("axr",ar_slip,t_date,g_oma00,"","","","","")
                                       RETURNING li_result,g_n_oma01
                           IF (NOT li_result) THEN
                              CALL cl_err('','mfg3326',1)
                              LET g_success = 'N'
                              RETURN
                           END IF
                           CALL s_g_ar(g_oga01,l_oeaa03,'11',t_date,t_date2,g_oma05,g_n_oma01,'',source,l_azp01,g_omf00,g_omf01,g_omf02) #No.FUN-A10104#FUN-C60036 add omf01.omf02,#minpp add omf00
                             RETURNING g_start,g_end
                          #-TQC-B60089-add-
                           IF l_cnt = 1 THEN
                              LET g_start1 = g_start
                           END IF
                          #-TQC-B60089-end-
                           LET l_oeaan=1
                        ELSE
                           LET g_showmsg=g_oga01,"/",l_oeaa03,"/",'N' 
                           CALL s_errmsg('oma16,oma165,omavoid',g_showmsg,'','axr-513',0)
                           CONTINUE FOREACH
                        END IF
                     END FOREACH 
                  END IF
               ELSE
                  LET l_cnt = 0   #TQC-B60089
                  FOREACH p310_oeaa1 INTO l_oeaa03
                     #訂單期別已產生訂金不可重複產生
                     SELECT COUNT(*) INTO g_cnt FROM oma_file
                      WHERE oma16 = g_oga01 AND omavoid='N'
                        AND oma165 = l_oeaa03
                        AND oma00 = '11'
                     IF g_cnt = 0 THEN
                        LET l_cnt = l_cnt + 1   #TQC-B60089
                        CALL s_auto_assign_no("axr",ar_slip,t_date,g_oma00,"","","","","")
                                    RETURNING li_result,g_n_oma01
                        IF (NOT li_result) THEN
                           CALL cl_err('','mfg3326',1)
                           LET g_success = 'N'
                           RETURN
                        END IF
                        CALL s_g_ar(g_oga01,l_oeaa03,'11',t_date,t_date2,g_oma05,g_n_oma01,'',source,l_azp01,g_omf00,g_omf01,g_omf02) #No.FUN-A10104 #FUN-C60036 add omf01,omf02 #minpp add--omf00
                          RETURNING g_start,g_end
                       #-TQC-B60089-add-
                        IF l_cnt = 1 THEN
                           LET g_start1 = g_start
                        END IF
                       #-TQC-B60089-end-
                        LET l_oeaan=1
                     ELSE
                        LET g_showmsg=g_oga01,"/",l_oeaa03,"/",'N' 
                        CALL s_errmsg('oma16,oma165,omavoid',g_showmsg,'','axr-513',0)
                        CONTINUE FOREACH
                     END IF
                  END FOREACH  
               END IF
               IF l_oeaan = 0 THEN
                  CONTINUE FOREACH
               END IF
               #-----No:FUN-A50103 END-----
              ##-----No:FUN-A50103 Mark-----
              ##-----97/08/01 modify 已產生訂金不可重複產生
              #SELECT COUNT(*) INTO g_cnt FROM oma_file
              # WHERE oma16 = g_oga01 AND omavoid='N'    #No.MOD-520011
              #IF g_cnt = 0 THEN
              #   IF g_enter_account='N' THEN
              #      LET g_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"oeb_file",
              #                  " WHERE oeb01 = '",g_oga01,"' AND oeb13<>0"
              #      PREPARE sel_oeb_pre FROM g_sql
              #      EXECUTE sel_oeb_pre INTO g_cnt
              #      IF g_cnt=0 THEN                                                                                                      
              #         CONTINUE FOREACH                                                                                                  
              #      ELSE                                                                                                                 
              #      #  CALL s_g_ar(g_oga01,'11',t_date,t_date2,g_oma05,g_n_oma01,'',source,l_dbs)   #No.FUN-9C0014 #No.FUN-A10104
              #         CALL s_g_ar(g_oga01,'11',t_date,t_date2,g_oma05,g_n_oma01,'',source,l_azp01) #No.FUN-A10104
              #         RETURNING g_start,g_end
              #      END IF                                                                                                               
              #   ELSE                                                                                                                    
              #   #  CALL s_g_ar(g_oga01,'11',t_date,t_date2,g_oma05,g_n_oma01,'',source,l_dbs)   #No.FUN-9C0014 #No.FUN-A10104
              #      CALL s_g_ar(g_oga01,'11',t_date,t_date2,g_oma05,g_n_oma01,'',source,l_azp01) #No.FUN-A10104
              #      RETURNING g_start,g_end
              #   END IF #MOD-990166         
              #ELSE
              #   LET g_showmsg=g_oga01,"/",'N'        #NO.FUN-710050   
              #   CALL s_errmsg('oma16,omavoid',g_showmsg,'','axr-315',0)    #NO.FUN-710050  
              #   CONTINUE FOREACH
              #END IF
              ##-----No:FUN-A50103 Mark END-----
            WHEN ar_type='2'
               #檢查是否有INVOICE資料
               IF g_oga08='2' THEN #外銷
                  #LET g_sql = "SELECT oga909,oga09 FROM ",l_dbs CLIPPED,"oga_file",
                  LET g_sql = "SELECT oga909,oga09 FROM ",cl_get_target_table(l_azp01,'oga_file'), #FUN-A50102
                              " WHERE oga01='",g_oga01,"' AND oga09 NOT IN ('1','9','A')"
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
                  CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102 
                  PREPARE sel_oeb_pre1 FROM g_sql
                  EXECUTE sel_oeb_pre1 INTO l_oga909,l_oga09
                  IF l_oga909 IS NOT NULL AND l_oga909='Y' THEN  #MOD-9A0205
                     #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"oga_file,",l_dbs CLIPPED,"ofa_file",
                     LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_azp01,'oga_file'),",", #FUN-A50102
                                                         cl_get_target_table(l_azp01,'ofa_file'),     #FUN-A50102
                                 " WHERE oga01='",g_oga01,"'",
                                 "   AND oga27=ofa01 AND ofaconf = 'Y'"
                     CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
                     CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102             
                     PREPARE sel_oga_pre FROM g_sql
                     EXECUTE sel_oga_pre INTO l_n
                  ELSE
                     LET l_oaz67 = ''
                     SELECT oaz67 INTO l_oaz67 FROM oaz_file
                     IF l_oaz67='1' THEN
                       #l_oga09='8'-->出貨簽收單
                       #要抓到出通單號的話,得串回出貨單頭的oga011
                        IF l_oga09 IS NOT NULL AND l_oga09='8' THEN    #MOD-960173 
                           LET g_sql = "SELECT COUNT(*)",
                                       #"  FROM ",l_dbs CLIPPED,"oga_file a,",l_dbs CLIPPED,"oga_file b,",l_dbs CLIPPED,"ofa_file",
                                       "  FROM ",cl_get_target_table(l_azp01,'oga_file a'),",", #FUN-A50102
                                                 cl_get_target_table(l_azp01,'oga_file b'),",", #FUN-A50102
                                                 cl_get_target_table(l_azp01,'ofa_file'),       #FUN-A50102
                                       " WHERE a.oga01 ='",g_oga01,"'",
                                       "   AND a.oga011=b.oga01 AND b.oga011=ofa011 ",
                                       "   AND ofaconf = 'Y'"
                           CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
                           CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102              
                           PREPARE sel_oga1_pre FROM g_sql
                           EXECUTE sel_oga1_pre INTO l_n
                        ELSE
                           LET g_sql = "SELECT COUNT(*)",
                                       #"  FROM ",l_dbs CLIPPED,"oga_file,",l_dbs CLIPPED,"ofa_file",
                                       "  FROM ",cl_get_target_table(l_azp01,'oga_file'),",", #FUN-A50102
                                                 cl_get_target_table(l_azp01,'ofa_file'),     #FUN-A50102
                                       " WHERE oga01='",g_oga01,"'",
                                       "   AND oga011=ofa011",
                                       "   AND ofaconf = 'Y'" 
                           CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
                           CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102              
                           PREPARE sel_oga2_pre FROM g_sql
                           EXECUTE sel_oga2_pre INTO l_n
                        END IF   #MOD-940332 add
                     ELSE
                        LET g_sql = "SELECT COUNT(*)",
                                    #"  FROM ",l_dbs CLIPPED,"oga_file,",l_dbs CLIPPED,"ofa_file",
                                    "  FROM ",cl_get_target_table(l_azp01,'oga_file'),",", #FUN-A50102
                                              cl_get_target_table(l_azp01,'ofa_file'),     #FUN-A50102
                                    " WHERE oga01='",g_oga01,"'",
                                    "   AND oga01=ofa011",
                                    "   AND ofaconf = 'Y'"
                        CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
                        CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102              
                        PREPARE sel_oga3_pre FROM g_sql
                        EXECUTE sel_oga3_pre INTO l_n
                     END IF
                  END IF
                  IF l_n=0 AND noin_sw='N' THEN
                     CONTINUE FOREACH
                  END IF  #no:6806/6807 add l_n=0 判斷
               END IF
               IF NOT (g_aza.aza26 = '2' AND g_oaz92 = 'Y' AND g_omf00 = l_omf00) OR cl_null(l_omf00) THEN #FUN-CB0057 add
                  IF g_enter_account='N' AND g_azw.azw04 <> '2' THEN   #TQC-C80083  add g_azw.azw04 <> '2'
                     #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"ogb_file",
                     LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_azp01,'ogb_file'), #FUN-A50102
                                 " WHERE ogb01='",g_oga01,"' AND ogb13<>0"
                     CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
                     CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102              
                     PREPARE sel_ogb_pre FROM g_sql
                     EXECUTE sel_ogb_pre INTO g_cnt
                     IF g_cnt=0 AND NOT cl_null(g_oga01) THEN                                                                                                         
                        CONTINUE FOREACH                                                                                                     
                     ELSE                                                                                                                    
                     #  CALL s_g_ar(g_oga01,'12',t_date,t_date2,g_oma05,g_n_oma01,'',source,l_dbs)   #No.FUN-9C0014 #No.FUN-A10104
                       #FUN-B10058--add--str--
                         IF g_oga57 = '2' THEN
                           CALL s_g_ar(g_oga01,0,'19',t_date,t_date2,g_oma05,g_n_oma01,'',source,l_azp01,g_omf00,g_omf01,g_omf02)#FUN-C60036 add omf01,omf02 #minpp add--omf00
                                RETURNING g_start,g_end
                        ELSE
                        #FUN-B10058--add--end
                           CALL s_g_ar(g_oga01,0,'12',t_date,t_date2,g_oma05,g_n_oma01,'',source,l_azp01,g_omf00,g_omf01,g_omf02) #No.FUN-A10104 #FUN-C60036 add omf01,omf02#minpp-add--omf00
   
                                RETURNING g_start,g_end
                        END IF #FUN-B10058
                     END IF
                  ELSE
                  #  CALL s_g_ar(g_oga01,'12',t_date,t_date2,g_oma05,g_n_oma01,'',source,l_dbs)   #No.FUN-9C0014 #No.FUN-A10104
                     #FUN-B10058--add--str--
                     IF g_oga57 = '2' THEN
                        CALL s_g_ar(g_oga01,0,'19',t_date,t_date2,g_oma05,g_n_oma01,'',source,l_azp01,g_omf00,g_omf01,g_omf02)#FUN-C60036 add omf01,omf02#minpp add--omf00
                             RETURNING g_start,g_end
                     ELSE
                     #FUN-B10058--add--end
                        CALL s_g_ar(g_oga01,0,'12',t_date,t_date2,g_oma05,g_n_oma01,'',source,l_azp01,g_omf00,g_omf01,g_omf02) #No.FUN-A10104 #FUN-C60036 add omf01.omf02#minpp--add--omf00
                              RETURNING g_start,g_end
                     END IF #FUN-B10058
                  END IF #MOD-990166    
                  LET l_omf00 = g_omf00#FUN-CB0057 add
               END IF #FUN-CB0057 add
      

            WHEN ar_type='3'
               #-----No:FUN-A50103-----
               LET l_oeaan = 0
               LET g_sql= "SELECT oeaa03 ",
                          #"  FROM ",l_dbs CLIPPED,"oeaa_file",
                          "  FROM ",cl_get_target_table(l_azp01,'oeaa_file'), #FUN-A50102
                          "  WHERE oeaa01 = '",g_oga01,"' ",
                          "    AND oeaa02 = '2' " 
               IF NOT cl_null(s_date) AND NOT cl_null(e_date) THEN
                  LET g_sql = g_sql," AND oeaa05 BETWEEN '",s_date,"' AND '",e_date,"'"
               END IF
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
               CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102  
               PREPARE p310_oeaa2p FROM g_sql
               DECLARE p310_oeaa2 CURSOR WITH HOLD FOR p310_oeaa2p

               IF g_enter_account='N' AND g_azw.azw04 <> '2' THEN  #TQC-C80083  add g_azw.azw04 <> '2'
                  #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"oeb_file",
                  LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_azp01,'oeb_file'), #FUN-A50102
                              " WHERE oeb01 = '",g_oga01,"' AND oeb13<>0"
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
                  CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102              
                  PREPARE sel_oeb1_pre FROM g_sql
                  EXECUTE sel_oeb1_pre INTO g_cnt
                  IF g_cnt=0 THEN                                                                                                      
                     CONTINUE FOREACH                                                                                                  
                  ELSE                                                                                                                 
                     LET l_cnt = 0   #TQC-B60089
                     FOREACH p310_oeaa2 INTO l_oeaa03
                        #訂單期別已產生訂金不可重複產生
                        SELECT COUNT(*) INTO g_cnt FROM oma_file
                         WHERE oma16 = g_oga01 AND omavoid='N'
                           AND oma165 = l_oeaa03
                           AND oma00 = '13'
                        IF g_cnt = 0 THEN
                           LET l_cnt = l_cnt + 1   #TQC-B60089
                           CALL s_auto_assign_no("axr",ar_slip,t_date,g_oma00,"","","","","")
                                       RETURNING li_result,g_n_oma01
                           IF (NOT li_result) THEN
                              CALL cl_err('','mfg3326',1)
                              LET g_success = 'N'
                              RETURN
                           END IF
                           CALL s_g_ar(g_oga01,l_oeaa03,'13',t_date,t_date2,g_oma05,g_n_oma01,'',source,l_azp01,'','','') #No.FUN-A10104#FUN-C60036 add ,'','' #minpp add ''
                             RETURNING g_start,g_end                                                                                             
                          #-TQC-B60089-add-
                           IF l_cnt = 1 THEN
                              LET g_start1 = g_start
                           END IF
                          #-TQC-B60089-end-
                           LET l_oeaan=1
                        ELSE
                           LET g_showmsg=g_oga01,"/",l_oeaa03,"/",'N' 
                           CALL s_errmsg('oma16,oma165,omavoid',g_showmsg,'','axr-513',0)
                           CONTINUE FOREACH
                        END IF
                     END FOREACH 
                  END IF
               ELSE
                  LET l_cnt = 0   #TQC-B60089
                  FOREACH p310_oeaa2 INTO l_oeaa03
                     #訂單期別已產生訂金不可重複產生
                     SELECT COUNT(*) INTO g_cnt FROM oma_file
                      WHERE oma16 = g_oga01 AND omavoid='N'
                        AND oma165 = l_oeaa03
                        AND oma00 = '13'
                     IF g_cnt = 0 THEN
                        LET l_cnt = l_cnt + 1   #TQC-B60089
                        CALL s_auto_assign_no("axr",ar_slip,t_date,g_oma00,"","","","","")
                                    RETURNING li_result,g_n_oma01
                        IF (NOT li_result) THEN
                           CALL cl_err('','mfg3326',1)
                           LET g_success = 'N'
                           RETURN
                        END IF
                        CALL s_g_ar(g_oga01,l_oeaa03,'13',t_date,t_date2,g_oma05,g_n_oma01,'',source,l_azp01,'','','') #No.FUN-A10104#FUN-C60036 add ,'','' #minpp add ''
                          RETURNING g_start,g_end                                                                                             
                       #-TQC-B60089-add-
                        IF l_cnt = 1 THEN
                           LET g_start1 = g_start
                        END IF
                       #-TQC-B60089-end-
                        LET l_oeaan=1
                     ELSE
                        LET g_showmsg=g_oga01,"/",l_oeaa03,"/",'N' 
                        CALL s_errmsg('oma16,oma165,omavoid',g_showmsg,'','axr-513',0)
                        CONTINUE FOREACH
                     END IF
                  END FOREACH 
               END IF
               IF l_oeaan = 0 THEN
                  CONTINUE FOREACH
               END IF
               #-----No:FUN-A50103 END-----
              ##-----No:FUN-A50103 Mark-----
              #IF g_enter_account='N' THEN
              #  #-CHI-A50040-add-
              #  #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"ogb_file",
              #  #            " WHERE ogb01='",g_oga01,"' AND ogb13<>0"
              #   LET g_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"oeb_file",
              #               " WHERE oeb01 = '",g_oga01,"' AND oeb13<>0"
              #  #-CHI-A50040-end-
              #   PREPARE sel_ogb1_pre FROM g_sql
              #   EXECUTE sel_ogb1_pre INTO g_cnt
              #   IF g_cnt=0 THEN                                                                                                        
              #      CONTINUE FOREACH                                                                                                    
              #   ELSE                                                                                                                   
              #   #  CALL s_g_ar(g_oga01,'13',t_date,t_date2,g_oma05,g_n_oma01,'',source,l_dbs)   #No.FUN-9C0014 #No.FUN-A10104
              #      CALL s_g_ar(g_oga01,'13',t_date,t_date2,g_oma05,g_n_oma01,'',source,l_azp01) #No.FUN-A10104
              #      RETURNING g_start,g_end                                                                                             
              #   END IF                                                                                                                 
              #ELSE                                                                                                                      
              ##  CALL s_g_ar(g_oga01,'13',t_date,t_date2,g_oma05,g_n_oma01,'',source,l_dbs)   #No.FUN-9C0014 #No.FUN-A10104
              #   CALL s_g_ar(g_oga01,'13',t_date,t_date2,g_oma05,g_n_oma01,'',source,l_azp01) #No.FUN-A10104
              #   RETURNING g_start,g_end
              #END IF #MOD-990166      
              ##-----No:FUN-A50103 Mark END-----
            WHEN ar_type='4'
            #  CALL s_g_ar(g_oga01,'21',t_date,t_date2,g_oma05,g_n_oma01,'',source,l_dbs)   #No.FUN-9C0014 #No.FUN-A10104
               #FUN-B10058--add--str--
               IF g_oga57 = '2' THEN
                  CALL s_g_ar(g_oga01,0,'28',t_date,t_date2,g_oma05,g_n_oma01,'',source,l_azp01,'','','')#FUN-C60036 add ,'',''#minpp add ''
                       RETURNING g_start,g_end
               ELSE
               #FUN-B10058--add--end
                  CALL s_g_ar(g_oga01,0,'21',t_date,t_date2,g_oma05,g_n_oma01,'',source,l_azp01,'','','') #No.FUN-A10104#FUN-C60036 add ,'',''#minpp add ''
                       RETURNING g_start,g_end
               END IF #FUN-B10058
         END CASE
      
         IF NOT cl_null(g_start1) THEN LET g_start = g_start1 END IF  #TQC-B60089
         IF cl_null(g_start1) AND NOT cl_null(g_start) THEN
            LET g_start1 = g_start
         END IF
      END FOREACH   #MOD-BB0230

         #No.+227 for 訂金/尾款,ooz13 for 出貨
         #IF g_ooz.ooz13 MATCHES '[12]' AND conf_sw='Y' THEN
         DECLARE p310_c CURSOR FOR
           SELECT * FROM oma_file WHERE oma01 BETWEEN g_start AND g_end
              AND oma01 IN (SELECT omb01 FROM omb_file WHERE omb31 IN (SELECT oga01 FROM y)) #No.yinhy130722
                

         FOREACH p310_c INTO g_oma.*
            IF STATUS THEN
               EXIT FOREACH
            END IF
           #-MOD-AA0133-add-
            IF g_oma.oma02 < g_ooz.ooz09 THEN
               CALL cl_err(g_oma.oma02,'axr-164',1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF 
           #-MOD-AA0133-end- 
            #FUN-960140 add GP5.2修改 axmt410/axmt620若有交款,s_ins_w中oma65='2'
            #但是若不需要審核,oob09,oob10=0,所以需要update為'1'
           #IF ar_type ='1' THEN #訂金                          #CHI-A50040 mark
            #No.TQC-CC0107  --Begin
            LET g_sql = "SELECT occ73 FROM ",g_dbs_tra CLIPPED,"occ_file",
                        " WHERE occ01 = '",g_oma.oma68,"'"
            PREPARE sel_occ8 FROM g_sql
            EXECUTE sel_occ8 INTO g_occ73
            IF cl_null(g_occ73) THEN LET g_occ73 = 'N' END IF
            IF g_azw.azw04 = '2' AND g_occ73 = 'Y' THEN 
            ELSE
            #No.TQC-CC0107  --End  
               IF ar_type ='1' OR ar_type = '3' THEN #訂金/尾款    #CHI-A50040
                  IF g_ooy.ooyconf='Y' AND conf_sw='Y' THEN
                     IF NOT (g_ooz.ooz13='1' OR g_quick='Y') THEN
                        LET g_oma.oma65 = 1
                     END IF
                  ELSE
                     LET g_oma.oma65 = 1
                  END IF
               ELSE                #出貨
                  IF g_ooz.ooz13 MATCHES '[12]' OR conf_sw='Y' THEN  #No.FUN-AB0034 AND --> OR
                     IF NOT (g_ooz.ooz13='1' OR g_quick='Y') THEN
                        LET g_oma.oma65 = 1
                     END IF
                  ELSE
                     LET g_oma.oma65 = 1
                  END IF
               END IF
               UPDATE oma_file SET oma65 = g_oma.oma65 WHERE oma01 = g_oma.oma01
            END IF #No.TQC-CC0107
            IF g_ooy.ooydmy1='Y' THEN    #訂金/出貨/尾款 依單別判斷是否產生分錄
               IF g_oma.oma65 != '2' THEN    #FUN-960140 add 根據收款方式產生分錄
                  CALL s_t300_gl(g_oma.oma01,'0')
                  IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
                     CALL s_t300_gl(g_oma.oma01,'1')
                  END IF
               ELSE
                  CALL s_t300_rgl(g_oma.oma01,'0')
                  IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
                     CALL s_t300_rgl(g_oma.oma01,'1')
                  END IF
               END IF
            END IF
            CALL s_get_bookno(YEAR(g_oma.oma02)) RETURNING g_flag,g_bookno1,g_bookno2
            IF g_flag =  '1' THEN  #抓不到帳別
               CALL cl_err(g_oma.oma02,'aoo-081',1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
            LET l_omaconfchk = 'N'     #MOD-AA0013 
           #IF ar_type ='1' THEN #訂金for單別及此次是否要立即確認(conf_sw='Y')                        #CHI-A50040 mark
            IF ar_type ='1' OR ar_type = '3' THEN #訂金/尾款for單別及此次是否要立即確認(conf_sw='Y')  #CHI-A50040
               IF g_ooy.ooyconf='Y' AND conf_sw='Y' THEN
                  IF g_ooz.ooz13='1' OR g_quick='Y' THEN   #FUN-570188 add
                     IF g_ooy.ooydmy1='Y' THEN
                        CALL s_chknpq(g_oma.oma01,'AR',1,'0',g_bookno1) #FUN-740009
                        IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
                           CALL s_chknpq(g_oma.oma01,'AR',1,'1',g_bookno2) #FUN-740009
                        END IF
                        IF g_success='N' THEN
                           EXIT FOREACH
                        END IF
                     END IF
                     LET l_n = 0
                     SELECT COUNT(*) INTO l_n  FROM oob_file
                       WHERE oob01 = g_oma.oma01
                     IF l_n>0 THEN
                     #  CALL s_t300_confirm(g_oma.oma01,l_dbs) #No.FUN-9C0014 Add l_dbs #No.FUN-A10104
                        CALL s_t300_confirm(g_oma.oma01,l_azp01) #No.FUN-A10104
                     END IF
                   # CALL s_ar_conf('y',g_oma.oma01,l_dbs) RETURNING i #No.FUN-9C0014 #No.FUN-A10104
                     CALL s_ar_conf('y',g_oma.oma01,l_azp01) RETURNING i #No.FUN-A10104
                     IF i THEN
                        LET g_success='N'
                        EXIT FOREACH
                     ELSE                         #MOD-AA0013 
                        LET l_omaconfchk = 'Y'    #MOD-AA0013
                        CALL s_t300_w1('+',g_oma.oma01)         #FUN-AC0027
                     END IF
                  END IF                                   #FUN-570188 add
               END IF
            ELSE  #出貨 for 參數及此次是否要立即確認(conf_sw='Y')
               #IF g_ooz.ooz13 MATCHES '[12]' OR conf_sw='Y' THEN    #MOD-940408    #MOD-B30185
               IF g_ooz.ooz13='1' OR (g_ooz.ooz13='2' AND conf_sw='Y') THEN  #MOD-B30185 
                  IF g_ooz.ooz13='1' OR g_quick='Y' THEN   #FUN-570188 add
                    #直接確認前先確定是否要check分錄底稿
                     IF g_ooy.ooydmy1='Y' THEN
                        CALL s_chknpq(g_oma.oma01,'AR',1,'0',g_bookno1)  #FUN-740009
                        IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
                           CALL s_chknpq(g_oma.oma01,'AR',1,'1',g_bookno2)  #FUN-740009
                        END IF
                        IF g_success='N' THEN
                           EXIT FOREACH
                        END IF
                     END IF
#---FUN-AB0110 start--
                     IF g_ooy.ooydmy1 = 'Y' AND g_success = 'Y' THEN
                        CALL s_t300_ins_oct(g_oma.oma01,g_oma.oma00,'0') RETURNING i
                        IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
                           CALL s_t300_ins_oct(g_oma.oma01,g_oma.oma00,'1') RETURNING i
			   IF i = 0 THEN LET g_success = 'N' END IF         #No.TQC-B60103 mod
                           IF g_success = 'N' THEN EXIT FOREACH END IF      #No.TQC-B60103 mod
                        END IF
                       #IF i = 0 THEN LET g_success = 'N' END IF         #No.TQC-B60103 mark
                       #IF g_success = 'N' THEN EXIT FOREACH END IF      #No.TQC-B60103 mark
                    #END IF   #CHI-B30024 mark
                     END IF   #CHI-B30024 add
#---FUN-AB0110 end---
                     LET l_n = 0
                     SELECT COUNT(*) INTO l_n  FROM oob_file
                       WHERE oob01 = g_oma.oma01
                     IF l_n>0 THEN
                     #  CALL s_t300_confirm(g_oma.oma01,l_dbs) #No.FUN-9C0014 Add l_dbs #No.FUN-A10104
                        CALL s_t300_confirm(g_oma.oma01,l_azp01) #No.FUN-A10104
                     END IF
                   # CALL s_ar_conf('y',g_oma.oma01,l_dbs) RETURNING i #No.FUN-9C0014 #No.FUN-A10104
                     CALL s_ar_conf('y',g_oma.oma01,l_azp01) RETURNING i #No.FUN-A10104
                     IF i THEN
                        LET g_success='N'
                        EXIT FOREACH
                     ELSE                         #MOD-AA0013 
                        LET l_omaconfchk = 'Y'    #MOD-AA0013
                       #-MOD-BC0167-add-
                        IF g_ooz.ooz10 = 'Y' THEN 
                           DECLARE p310_oga CURSOR FOR 
                            SELECT omb44,omb31 
                              FROM omb_file    
                             WHERE omb01 = g_oma.oma01  
                    
                           FOREACH p310_oga INTO l_omb44,l_omb31   
                              IF SQLCA.SQLCODE THEN
                                 CALL s_errmsg("omb01",g_oma.oma01,"",SQLCA.sqlcode,0)
                                 LET g_success='N'
                                 EXIT FOREACH
                              END IF
                    
                             #LET g_sql = "SELECT oga23,oga24 FROM ",cl_get_target_table(l_omb44,'oga_file'), #MOD-C30842 mark
                              LET g_sql = "SELECT oga23,oga24,oga09,oga011",                   #MOD-C30842 add
                                          "  FROM ",cl_get_target_table(l_omb44,'oga_file'),   #MOD-C30842 add
                                          " WHERE oga01 = '",l_omb31,"' "
                              CALL cl_replace_sqldb(g_sql) RETURNING g_sql         
                              CALL cl_parse_qry_sql(g_sql,l_omb44) RETURNING g_sql              
                              PREPARE sel_oga23_pre FROM g_sql
                             #EXECUTE sel_oga23_pre INTO l_oga23,l_oga24                       #MOD-C30842 mark
                              EXECUTE sel_oga23_pre INTO l_oga23,l_oga24,l_oga09,l_oga011      #MOD-C30842 add
                    
                              IF l_oga23 = g_aza.aza17 THEN
                                 CONTINUE FOREACH       #同為本國幣別不UPDATE
                              END IF
                              
                              IF l_oga23 = g_oma.oma23 THEN  
                                 LET g_sql = "UPDATE ",cl_get_target_table(l_omb44,'oga_file'), 
                                             "   SET oga24 = '",g_oma.oma24,"' ",
                                             " WHERE oga01 = '",l_omb31,"' " 
                                 CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
                                 CALL cl_parse_qry_sql(g_sql,l_omb44) RETURNING g_sql 
                                 PREPARE upd_oga_pre7 FROM g_sql
                                 EXECUTE upd_oga_pre7
                              ELSE                      #不同幣別不UPDATE
                                 CONTINUE FOREACH
                              END IF
                             #-----------------------------MOD-C30842------------------------start
                              IF l_oga09 = '8' THEN
                                 LET g_sql = "SELECT oga23,oga24",
                                             "  FROM ",cl_get_target_table(l_omb44,'oga_file'),
                                             " WHERE oga01 = '",l_oga011,"' "
                                 CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                                 CALL cl_parse_qry_sql(g_sql,l_omb44) RETURNING g_sql
                                 PREPARE sel_oga232_pre FROM g_sql
                                 EXECUTE sel_oga232_pre INTO l_oga232,l_oga242

                                 IF l_oga232 = g_aza.aza17 THEN
                                    CONTINUE FOREACH                       #同為本國幣別不UPDATE
                                 END IF

                                 IF l_oga232 = g_oma.oma23 THEN
                                    LET g_sql = "UPDATE ",cl_get_target_table(l_omb44,'oga_file'),
                                                "   SET oga24 = '",g_oma.oma24,"' ",
                                                " WHERE oga01 = '",l_oga011,"' "
                                    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                                    CALL cl_parse_qry_sql(g_sql,l_omb44) RETURNING g_sql
                                    PREPARE upd_oga2_pre7 FROM g_sql
                                    EXECUTE upd_oga2_pre7
                                 ELSE                                      #不同幣別不UPDATE
                                    CONTINUE FOREACH
                                 END IF
                              END IF
                             #-----------------------------MOD-C30842--------------------------end
                           END FOREACH
                        END IF
                       #-MOD-BC0167-end-
                        CALL s_t300_w1('+',g_oma.oma01)         #FUN-AC0027
                     END IF
                  END IF                                   #FUN-570188 add
               END IF
            END IF
            SELECT omaconf INTO g_oma.omaconf FROM oma_file WHERE oma01 = g_oma.oma01
            #IF g_oma.omaconf = 'N' THEN                        #MOD-C70289 mark 
            IF g_oma.omaconf = 'N' AND g_azw.azw04 <> '2' THEN  #MOD-C70289
               UPDATE oob_file SET oob09 = 0,oob10=0 
                WHERE oob01 = g_oma.oma01
               UPDATE ooa_file SET ooa31d = 0, ooa31c = 0,
                                   ooa32d = 0, ooa32c = 0
                WHERE ooa01 = g_oma.oma01
            END IF
           #-TQC-AC0272-add-
            IF l_omaconfchk = 'N' AND cl_null(g_argv1) THEN
               LET open_sw = 'N'
            END IF
           #-TQC-AC0272-end-
            #---------------------------------------------------- 開立發票
           #IF open_sw='Y' THEN                               #MOD-A80169 mark    #TQC-AC0272 remark #MOD-C10224 mark
           #MOD-C40153---s---
            IF g_ooz.ooz64 = 'N' AND g_oma.oma08 = '2' AND g_aza.aza26 = '0' THEN
               LET open_sw = 'N'
            END IF
           #MOD-C40153---e---
            IF open_sw='Y' AND g_oma.oma59 > 0 THEN           #MOD-C10224 
           #IF open_sw='Y' AND g_oma.omaconf = 'Y' THEN       #MOD-A80169       #MOD-AA0013 mark
           #IF open_sw='Y' AND l_omaconfchk = 'Y' THEN                          #MOD-AA0013      #TQC-AC0272 mark
             #99.05.25 add for 三角貿易
               LET l_oga909='N'
               IF g_oma.oma00='12' THEN
                  #LET g_sql = "SELECT oga16,oga909 FROM ",l_dbs CLIPPED,"oga_file",
                  LET g_sql = "SELECT oga16,oga909 FROM ",cl_get_target_table(l_azp01,'oga_file'), #FUN-A50102
                              " WHERE oga01='",g_oma.oma16,"'"
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
                  CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102             
                  PREPARE sel_oga4_pre FROM g_sql
                  EXECUTE sel_oga4_pre INTO l_oga16,l_oga909
                  IF SQLCA.SQLCODE <>0 OR l_oga909 IS NULL THEN
                     LET l_oga909='N'
                  END IF
               END IF
               IF cl_null(l_oga909) THEN
                  LET l_oga909='N'
               END IF
               IF l_oga909='Y' THEN
                  #LET g_sql = "SELECT oea904 FROM ",l_dbs CLIPPED,"oea_file WHERE oea01='",l_oga16,"'"
                  LET g_sql = "SELECT oea904 FROM ",cl_get_target_table(l_azp01,'oea_file'), #FUN-A50102
                              " WHERE oea01='",l_oga16,"'"
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
                  CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102              
                  PREPARE sel_oea_pre FROM g_sql
                  EXECUTE sel_oea_pre INTO l_oea904
                  #LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"oar_file",
                  LET g_sql = "SELECT * FROM ",cl_get_target_table(l_azp01,'oar_file'), #FUN-A50102
                              " WHERE oar01='",l_oea904,"' AND oar02='",l_azp01,"'"
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
                  CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102                 
                  PREPARE sel_oar_pre FROM g_sql
                  EXECUTE sel_oar_pre INTO g_oar.*
                  IF SQLCA.SQLCODE <>0 THEN
                     LET g_unikey='N'
                  ELSE
                     LET g_unikey='Y'
                     IF cl_null(g_oar.oar04) THEN
                        LET g_unikey='N'
                     ELSE
                        #LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"gec_file",
                        LET g_sql = "SELECT * FROM ",cl_get_target_table(l_azp01,'gec_file'), #FUN-A50102
                                    " WHERE gec01='",g_oar.oar04,"' AND gec011='2'"
                        CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
                        CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102             
                        PREPARE sel_gec_pre FROM g_sql
                        EXECUTE sel_gec_pre INTO g_gec.*
                     END IF
                  END IF
               ELSE
                  LET g_unikey='N'
               END IF
              #---------------------------------------
              #---取得發票號碼
              #-MOD-B10033-add-
               LET l_yy=YEAR(t_date2) LET l_mm=MONTH(t_date2)
               OPEN oom_lock_cl USING l_yy,l_mm,g_oma.oma05,g_oma.oma212
               IF STATUS THEN
                  LET l_lock_sw = 'Y'
                  CALL s_errmsg('','','OPEN oom_lock_cl:',STATUS,1) 
                  LET g_success='N'
                  CONTINUE FOREACH   
               ELSE
                  FETCH oom_lock_cl INTO l_oom.*
                  IF SQLCA.sqlcode THEN
                     LET l_lock_sw = 'Y'
                     CALL s_errmsg('oma10',g_oma.oma10,'oma10:',SQLCA.sqlcode,1) 
                     LET g_success='N'
                     CONTINUE FOREACH   
                  END IF
               END IF
               IF l_lock_sw = 'Y' THEN
                  CALL cl_err(g_oma.oma10,-263,1)
                  LET g_oma.oma10 = '' 
                  CALL s_errmsg('oma10',g_oma.oma10,'oma10:',-263,1) 
                  LET g_success='N'
                  CONTINUE FOREACH   
               ELSE
              #-MOD-B10033-end-
                 #99.01.25 三角貿易
                  IF g_unikey='N' THEN
                  #  CALL s_guiauno1(g_oma.oma10,t_date2,g_oma.oma05,g_oma.oma212,l_dbs) #No.FUN-9C0014 #No.FUN-A10104
                     CALL s_guiauno1(g_oma.oma10,g_oma.oma75,t_date2,g_oma.oma05,g_oma.oma212,l_azp01) #No.FUN-A10104 #No.FUN-B90130 add oma75 
                     RETURNING g_i,g_oma.oma10,g_oma.oma75    #No.FUN-B90130 add oma75
                  ELSE
                  #  CALL s_guiauno1(g_oma.oma10,t_date2,g_oma.oma05,g_gec.gec05,l_dbs)  #No.FUN-9C0014 #No.FUN-A10104
                     CALL s_guiauno1(g_oma.oma10,g_oma.oma75,t_date2,g_oma.oma05,g_gec.gec05,l_azp01) #No.FUN-A10104  #No.FUN-B90130 add oma75
                     RETURNING g_i,g_oma.oma10,g_oma.oma75  #No.FUN-B90130 add oma75
                  END IF
                  IF NOT cl_null(g_argv1) THEN
                
                     INPUT BY NAME g_oma.oma10 WITHOUT DEFAULTS
                
                        AFTER FIELD oma10
                           CALL oma10_chk()
                           IF g_errno<>' ' THEN
                              NEXT FIELD oma10
                           END IF
                
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
                        LET g_success='N'
                        EXIT FOREACH
                     END IF
                  END IF
                  SELECT oom13 INTO g_oma.oma71 FROM oom_file
                   WHERE oom07 <= g_oma.oma10
                     AND oom08 >= g_oma.oma10
                     AND oom03  = g_oma.oma05   
                     AND (oom16 = g_oma.oma75 OR oom16 IS NULL )                 #No.FUN-B90130 
                  UPDATE oma_file SET oma10=g_oma.oma10, 
                                      oma71 = g_oma.oma71,   #FUN-970108
                                      oma75 = g_oma.oma75     #No.FUN-B90130 add oma75                  
                   WHERE oma01=g_oma.oma01 AND omavoid='N'     #No.MOD-520011
                  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN  #051004 by Ken
                     LET g_showmsg=g_oma.oma01,"/",'N'                                                    #NO.FUN-710050
                     CALL s_errmsg('oma01,omavoid',g_showmsg,'update oga_file','',0)                      #NO.FUN-710050
                  ELSE
                     UPDATE omc_file SET omc12=g_oma.oma10 
                      WHERE omc01 IN (SELECT oma01 FROM oma_file WHERE oma01=g_oma.oma01 AND omavoid='N' )
                     IF SQLCA.sqlcode THEN
                        CALL s_errmsg('','','update omc_file',SQLCA.sqlcode,1)                                  #NO.FUN-710050
                     END IF
                  END IF
                  IF g_unikey='N' THEN
                     IF cl_null(g_oma.oma10) THEN     #MOD-AC0348
                     #  CALL s_guiauno1(g_oma.oma10,t_date2,g_oma.oma05,g_oma.oma212,l_dbs) #No.FUN-9C0014 #No.FUN-A10104
                        CALL s_guiauno1(g_oma.oma10,g_oma.oma75,t_date2,g_oma.oma05,g_oma.oma212,l_azp01) #No.FUN-A10104 #No.FUN-B90130 add oma75
                        RETURNING g_i,g_oma.oma10,g_oma.oma75    #No.FUN-B90130 add oma75
                        IF g_i THEN
                           LET g_success='N'
                           EXIT FOREACH
                        END IF
                     END IF                           #MOD-AC0348
                    #---開立發票
                    #CALL s_insome(g_oma.oma01,g_oma.oma21,l_dbs)#No.FUN-9C0014 #No.FUN-A10104
                     CALL s_insome(g_oma.oma01,g_oma.oma21,l_azp01) #No.FUN-A10104
                  ELSE
                     IF cl_null(g_oma.oma10) THEN     #MOD-AC0348
                     #  CALL s_guiauno1(g_oma.oma10,t_date2,g_oma.oma05,g_gec.gec05,l_dbs) #No.FUN-9C0014 #No.FUN-A10104
                        CALL s_guiauno1(g_oma.oma10,g_oma.oma75,t_date2,g_oma.oma05,g_gec.gec05,l_azp01) #No.FUN-A10104 #No.FUN-B90130 add oma75
                        RETURNING g_i,g_oma.oma10,g_oma.oma75   #No.FUN-B90130 add oma75
                        IF g_i THEN
                           LET g_success='N'
                           EXIT FOREACH
                        END IF
                     END IF                           #MOD-AC0348
                    #---開立發票
                    #CALL s_insome(g_oma.oma01,g_gec.gec01,l_dbs)#No.FUN-9C0014 #No.FUN-A10104
                     CALL s_insome(g_oma.oma01,g_gec.gec01,l_azp01) #No.FUN-A10104
                  END IF
                 #-MOD-AC0348-add-
                  UPDATE oom_file SET oom09=g_oma.oma10,
                                      oom10=t_date2
                    WHERE oom07 <= g_oma.oma10 
                      AND oom08 >= g_oma.oma10 
                      AND (g_oma.oma10 > oom09 OR oom09 IS NULL)
                      AND (oom16 = g_oma.oma75 OR oom16 IS NULL )  #No.FUN-B90130 
#                 IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                  IF STATUS  THEN   #No.FUN-B90130                     
                     CALL s_errmsg('','','update oom_file',SQLCA.sqlcode,1)                                  #NO.FUN-710050
                     LET g_success='N'
                     CONTINUE FOREACH   
                  END IF
                 #-MOD-AC0348-end-
                  CLOSE oom_lock_cl #MOD-B10033 
               END IF               #MOD-B10033
            END IF
         END FOREACH

         IF STATUS THEN
            CALL s_errmsg('','','forA:',STATUS,1)                        #NO.FUN-710050
            LET g_success='N'
         END IF
 
         DECLARE p310_upd_oga CURSOR FOR
          SELECT * FROM oma_file WHERE oma01 BETWEEN g_start AND g_end
             AND oma01 IN (SELECT omb01 FROM omb_file WHERE omb31 IN (SELECT oga01 FROM y)) #No.yinhy130722
         FOREACH p310_upd_oga INTO g_oma.*
            IF STATUS THEN
               LET g_success='N'
               EXIT FOREACH
            END IF
         
           #IF ar_type = '2' OR (ar_type='3' AND g_oma.oma162=0) THEN  #出貨/尾款   #CHI-A50040 mark
            IF ar_type = '2' THEN  #出貨                                            #CHI-A50040
               #LET g_sql = "UPDATE ",l_dbs CLIPPED,"oga_file SET oga10 = '",g_oma.oma01,"',",
               LET g_sql = "UPDATE ",cl_get_target_table(l_azp01,'oga_file'), #FUN-A50102
                           " SET oga10 = '",g_oma.oma01,"',",
                           "                                     oga05 = '",g_oma.oma05,"'",
                          #" WHERE oga01 = '",g_oma.oma16,"'"#FUN-CB0057 mark
                           " WHERE oga01 IN (SELECT omb31 FROM omb_file where omb01 = '",g_oma.oma01,"')"#FUN-CB0057 add
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
               CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102                   
               PREPARE upd_oga_pre FROM g_sql
               EXECUTE upd_oga_pre
              #IF STATUS OR SQLCA.sqlerrd[3]=0 AND NOT cl_null(g_oma.oma16) THEN#FUN-CB0057 mark
               IF (STATUS OR SQLCA.sqlerrd[3]=0) AND NOT (g_aza.aza26 = '2' AND g_oaz92 = 'Y') THEN #FUN-CB0057 add
                  CALL s_errmsg('oga01',g_oma.oma16,'upd oga10',SQLCA.SQLCODE,0)                 #NO.FUN-710050
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
              #FUN-CB0057add--str
               IF SQLCA.sqlerrd[3] > 1 THEN  
                  UPDATE oma_file SET oma16 = '' WHERE oma01 = g_oma.oma01
               END IF  
              #FUN-CB0057 add--end
               LET l_cnt = 0 
               #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"oha_file",
               LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_azp01,'oha_file'), #FUN-A50102
                           #" WHERE oha01 IN (SELECT oha01 FROM ",l_dbs CLIPPED,"oha_file,",l_dbs CLIPPED,"ohb_file",
                           " WHERE oha01 IN (SELECT oha01 FROM ",cl_get_target_table(l_azp01,'oha_file'),",", #FUN-A50102
                                                                 cl_get_target_table(l_azp01,'ohb_file'),     #FUN-A50102
                           "                  WHERE oha01 = ohb01",
                           "                    AND ohaconf = 'Y'",
                           "                    AND ohapost = 'Y'",
                           "                    AND oha09 = '3'",
                           "                    AND ohb31 = '",g_oma.oma16,"')"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
               CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102       
               PREPARE sel_oha_pre FROM g_sql
               EXECUTE sel_oha_pre INTO l_cnt
               IF l_cnt > 0 THEN 
                  #LET g_sql = "UPDATE ",l_dbs CLIPPED,"oha_file SET oha10 = '",g_oma.oma01,"'",
                  LET g_sql = "UPDATE ",cl_get_target_table(l_azp01,'oha_file'), #FUN-A50102
                              " SET oha10 = '",g_oma.oma01,"'",
                              #" WHERE oha01 IN (SELECT oha01 FROM ",l_dbs CLIPPED,"oha_file,",l_dbs CLIPPED,"ohb_file",
                              " WHERE oha01 IN (SELECT oha01 FROM ",cl_get_target_table(l_azp01,'oha_file'),",", #FUN-A50102
                                                                    cl_get_target_table(l_azp01,'ohb_file'),     #FUN-A50102
                              "                  WHERE oha01 = ohb01 ",
                              "                    AND ohaconf = 'Y'",
                              "                    AND ohapost = 'Y'",
                              "                    AND oha09 = '3'",
                              "                    AND ohb31 = '",g_oma.oma16,"')"
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
                  CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102                   
                  PREPARE upd_oha_pre FROM g_sql
                  EXECUTE upd_oha_pre
                  IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                     CALL s_errmsg('ohb31',g_oma.oma16,'upd oha10',SQLCA.SQLCODE,0)                 #NO.FUN-710050
                     LET g_success = 'N'
                     EXIT FOREACH
                  END IF
               END IF
            END IF
         END FOREACH
     #END FOREACH   #No.FUN-9C0014 Add #MOD-BB0230 mark 
     
      IF begin_no IS NULL THEN
         LET begin_no = g_start1 #No.FUN-9C0014
      END IF
      IF cl_null(g_argv1) THEN
         MESSAGE  g_start1,'-',g_end #No.FUN-9C0014
         CALL ui.Interface.refresh() #CKP
      END IF
      MESSAGE 'AR NO. from ',begin_no,' to ',g_end
      CALL ui.Interface.refresh() #CKP
   END FOREACH
  
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF 
 
   MESSAGE  'AR NO. from ',begin_no,' to ',g_end
   CALL ui.Interface.refresh() #CKP

   IF NOT cl_null(g_argv1) THEN   # 外部程式串過來
      IF cl_null(g_start1) THEN  #No.FUN-9C0014
        #IF g_errno = '' THEN                        #MOD-B10150  #MOD-CC0210 mark
         IF g_errno = '' OR g_errno IS NULL THEN     #MOD-CC0210 add
            CALL s_errmsg('','','','aap-129',1)      #NO.FUN-710050
         END IF                                      #MOD-B10150
         LET g_success = 'N'  #No.FUN-570156
         RETURN
      END IF
      IF open_sw='Y' AND  NOT cl_null(g_argv1) THEN
         #LET g_msg = "axrr300 '' '' '",g_lang,"' 'Y' '' '' ",  #FUN-C30085
          LET g_msg = "axrg300 '' '' '",g_lang,"' 'Y' '' '' ",  #FUN-C30085
                      "'ome01 =\"",g_oma.oma10,"\"'"
         CALL cl_cmdrun(g_msg)
        #-MOD-B30627-mark-
        #UPDATE ome_file SET omeprsw = omeprsw + 1
        # WHERE ome01 = g_oma.oma10
        # IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN  #051004 by Ken
        #    CALL s_errmsg('ome01',g_oma.oma10,'update oga_file','',0)                            #NO.FUN-710050
        # END IF
        #-MOD-B30627-end-
      END IF
   END IF

   IF cl_null(g_start1) THEN                     #No.FUN-9C0014
      CALL s_errmsg('','','','aap-129',1)        #NO.FUN-710050
      LET g_success = 'N'
   END IF

END FUNCTION
 
FUNCTION p310_out1()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680123 SMALLINT,
    sr              RECORD
        oma00       LIKE oma_file.oma00,   #
        oma01       LIKE oma_file.oma01,   #
        oma21       LIKE oma_file.oma21,   #
        oma05       LIKE oma_file.oma05,   #
        oma032      LIKE oma_file.oma032,   #
        oma16       LIKE oma_file.oma16,   #
        oma53       LIKE oma_file.oma53,   #
        oma56       LIKE oma_file.oma56,
        oma56x      LIKE oma_file.oma56x,
        oma56t      LIKE oma_file.oma56t
                    END RECORD,
    l_name          LIKE type_file.chr20,         #No.FUN-680123 VARCHAR(20),              #External(Disk) file name
    l_za05          LIKE type_file.chr1000        #No.FUN-680123 VARCHAR(40)               #
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0)
    RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('axrp310') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axrp310'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT oma00,oma01,oma21,oma05,oma032,oma16,",
              "       oma53,oma56,oma56x,oma56t",
              " FROM oma_file",
              " WHERE ",g_wc CLIPPED,
              " ORDER BY 1"
    PREPARE p310_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE p310_co                         # SCROLL CURSOR
        CURSOR FOR p310_p1
 
    START REPORT p310_rep TO l_name
 
    FOREACH p310_co INTO sr.*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        OUTPUT TO REPORT p310_rep(sr.*)
    END FOREACH
 
    FINISH REPORT p310_rep
 
    CLOSE p310_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT p310_rep(sr)
 DEFINE
    l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(1),
    l_i             LIKE type_file.chr1,          #No.FUN-680123 SMALLINT,
    sr              RECORD
        oma00       LIKE oma_file.oma00,   #
        oma01       LIKE oma_file.oma01,   #
        oma21       LIKE oma_file.oma21,   #
        oma05       LIKE oma_file.oma05,   #
        oma032      LIKE oma_file.oma032,  #
        oma16       LIKE oma_file.oma16,   #
        oma53       LIKE oma_file.oma53,   #
        oma56       LIKE oma_file.oma56,
        oma56x      LIKE oma_file.oma56x,
        oma56t      LIKE oma_file.oma56t
                    END RECORD
   OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 
    ORDER BY sr.oma01
 
    FORMAT
        PAGE HEADER
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
            PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
            PRINT ' '
            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
                COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
            PRINT g_dash[1,g_len]
            PRINT g_x[11],g_x[12]
            PRINT '-- ---------- ---- - -------- ----------',
                  ' --------- --------- ------- ---------'
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
           PRINT sr.oma00,' ', sr.oma01,' ', sr.oma21,' ',sr.oma05,' ',
                 sr.oma032,' ', sr.oma16,
                 sr.oma53 USING '##########',
                 sr.oma56 USING '##########',
                 sr.oma56x USING '########',
                 sr.oma56t USING '##########'
 
        ON LAST ROW
            PRINT
            PRINT COLUMN 30,g_x[13] CLIPPED,
                 COUNT(*) USING '###',g_x[14] CLIPPED, COLUMN 41,
                 SUM(sr.oma53) USING '##########',
                 SUM(sr.oma56) USING '##########',
                 SUM(sr.oma56x) USING '########',
                 SUM(sr.oma56t) USING '##########'
            LET l_trailer_sw = 'n'
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
        PAGE TRAILER
            IF l_trailer_sw = 'y'
             THEN PRINT g_dash[1,g_len]
                  PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
             ELSE SKIP 2 LINE
            END IF
END REPORT
 
FUNCTION oma10_chk()
         DEFINE l_oom           RECORD LIKE oom_file.*
         DEFINE l_ome           RECORD LIKE ome_file.*
         DEFINE l_yy            LIKE type_file.num5          #No.FUN-680123 SMALLINT
         DEFINE l_mm            LIKE type_file.num5          #No.FUN-680123 SMALLINT
         DEFINE l_ome02_1,l_ome02_2  LIKE ome_file.ome02   #MOD-7C0206
         DEFINE l_omee          RECORD LIKE omee_file.*  #CHI-A70028 add
 
         LET g_errno=' '
         IF g_oma.oma10 IS NULL THEN
            CALL cl_err('','aap-226',0) LET g_errno='E'
         END IF
         LET l_yy= YEAR (g_oma.oma09)
         LET l_mm= MONTH(g_oma.oma09)

         IF g_aza.aza26 = '2' THEN                                      #MOD-BC0229
            SELECT * INTO l_oom.* FROM oom_file
             WHERE oom07 <= g_oma.oma10 AND g_oma.oma10 <= oom08
               AND oom04 = g_oma.oma212
               AND oom01   = l_yy
               AND oom02  <= l_mm
               AND oom021 >= l_mm    #No:8415 加上發票日期及聯數
               AND (oom16 = g_oma.oma75 OR oom16 IS NULL )   #No.FUN-B90130 
        #---------------------------MOD-BC0229------------------------------start
         ELSE
            SELECT * INTO l_oom.* FROM oom_file
             WHERE oom07 <= g_oma.oma10 AND g_oma.oma10 <= oom08
               AND oom04 = g_oma.oma212
               AND oom01   = l_yy
               AND oom02  <= l_mm
               AND oom021 >= l_mm    # 加上發票日期及聯數
         END IF
        #---------------------------MOD-BC0229--------------------------------end

         IF STATUS THEN
            CALL cl_err3("sel","oom_file",g_oma.oma10,"","axr-128","","",0)   #No.FUN-660116
            LET g_errno='E' RETURN
         END IF
         IF g_oma.oma10 > l_oom.oom09 AND g_oma.oma09 < l_oom.oom10 THEN
            CALL cl_err(g_oma.oma10,'axr-208',0) LET g_errno='E' RETURN
         END IF
         IF g_oma.oma10 <= l_oom.oom09 THEN 
            DECLARE ome_c_1 SCROLL CURSOR FOR
              SELECT ome02 FROM ome_file
                WHERE ome01 BETWEEN l_oom.oom07 AND l_oom.oom08
                  AND ome01 <= g_oma.oma10
                ORDER BY ome01
            OPEN ome_c_1
            FETCH LAST ome_c_1 INTO l_ome02_1
            DECLARE ome_c_2 SCROLL CURSOR FOR
              SELECT ome02 FROM ome_file
                WHERE ome01 BETWEEN l_oom.oom07 AND l_oom.oom08
                  AND ome01 >= g_oma.oma10
                ORDER BY ome01
            OPEN ome_c_2
            FETCH FIRST ome_c_2 INTO l_ome02_2
            IF NOT (g_oma.oma09 >= l_ome02_1 AND 
                    g_oma.oma09 <= l_ome02_2) 
               AND g_aza.aza26 = '0' THEN        #MOD-A50077 add
               CALL cl_err(g_oma.oma10,'axr-046',0)
               LET g_errno = 'E'
               RETURN
            END IF  
         END IF
         IF l_oom.oom01!=YEAR(g_oma.oma09) OR
            NOT l_oom.oom02 <= l_mm <= l_oom.oom021
            THEN CALL cl_err(g_oma.oma10,'axr-314',0) LET g_errno='E' RETURN
         END IF
         SELECT * INTO l_ome.* FROM ome_file WHERE ome01=g_oma.oma10
         IF STATUS=0 THEN
            IF g_ooz.ooz11='Y' AND l_ome.omevoid='N' AND
               l_ome.ome04=g_oma.oma03 AND l_ome.ome21=g_oma.oma21 THEN
               IF NOT cl_confirm('axr-322') THEN
                  LET g_errno='E'
              #合併開發票時,發票檔的帳款編號要清空,發票檔的金額要累加
               ELSE
                  UPDATE ome_file SET ome59 = l_ome.ome59 + g_oma.oma59,
                                      ome59x= l_ome.ome59x+ g_oma.oma59x,
                                      ome59t= l_ome.ome59t+ g_oma.oma59t,
                                      ome16 = ''
                   WHERE ome01 = g_oma.oma10
                  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                     CALL cl_err('upd ome',SQLCA.SQLCODE,1)
                     LET g_errno='E'
                  END IF
                  #CHI-A70028 add --start--
                  INITIALIZE l_omee.* TO NULL
                  LET l_omee.omee01 = l_ome.ome01 
                  LET l_omee.omee02 = l_ome.ome16
                  LET l_omee.omeedate = TODAY
                  LET l_omee.omeegrup = g_grup
                  LET l_omee.omeelegal = g_legal
                  LET l_omee.omeeorig = g_grup
                  LET l_omee.omeeoriu = g_user
                  LET l_omee.omeeuser = g_user

                  INSERT INTO omee_file VALUES(l_omee.*)
                  IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN
                     CALL cl_err3("ins","omee_file",l_omee.omee01,l_omee.omee02,SQLCA.SQLCODE,"","ins omee",1)
                     LET g_errno='E'
                  END IF
                  #CHI-A70028 add --end--
               END IF
            ELSE
               CALL cl_err('sel ome','-239',1)
               LET g_errno='E'
            END IF
         END IF
END FUNCTION
 
FUNCTION p310_chkdate()
   #DEFINE l_sql      LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(1000)  #No.MOD-B80056 mark
    DEFINE l_sql      STRING                       #No.MOD-B80056 add
    DEFINE l_yy,l_mm  LIKE type_file.num5          #No.FUN-680123 SMALLINT
    DEFINE l_where1,l_where2   STRING   #MOD-760086
 
    CASE WHEN ar_type='1'
            IF g_azw.azw04 <> '2' THEN  #TQC-B80126
               LET l_sql=
                "SELECT UNIQUE YEAR(oea02),MONTH(oea02) ",
                #"   FROM ",l_dbs CLIPPED,"oea_file LEFT OUTER JOIN ",l_dbs CLIPPED,"azi_file ON oea_file.oea23=azi_file.azi01,",l_dbs CLIPPED,"oay_file", #No.FUN-9C0014
                "   FROM ",cl_get_target_table(g_plant_new,'oea_file'),                           #FUN-A50102
                " LEFT OUTER JOIN ",cl_get_target_table(g_plant_new,'azi_file'),                  #FUN-A50102
                " ON oea_file.oea23=azi_file.azi01,",cl_get_target_table(g_plant_new,'oay_file'), #FUN-A50102
                "  WHERE ",g_wc CLIPPED,
                "  AND ( YEAR(oea02) != YEAR('",g_date,"') ",
                "   OR  (YEAR(oea02)  = YEAR('",g_date,"') ",
                "  AND   MONTH(oea02)!= MONTH('",g_date,"'))) ",
               #"    AND oea00='1' AND oea161>0 AND oeaconf='Y' ",
                "    AND oea00='1' AND oea261>0 AND oeaconf='Y' ",    #No:FUN-A50103
                " AND oea01 MATCHES ltrim(rtrim(oayslip)) || '-*' AND oay11='Y'"
            #No.TQC-B80126  --Begin #ar_type為1且azw04為2時，去掉oea261>0的條件
            ELSE
                    LET l_sql=
                "SELECT UNIQUE YEAR(oea02),MONTH(oea02) ",
                "   FROM ",cl_get_target_table(g_plant_new,'oea_file'),
                " LEFT OUTER JOIN ",cl_get_target_table(g_plant_new,'azi_file'),
                " ON oea_file.oea23=azi_file.azi01,",cl_get_target_table(g_plant_new,'oay_file'),
                "  WHERE ",g_wc CLIPPED,
                "  AND ( YEAR(oea02) != YEAR('",g_date,"') ",
                "   OR  (YEAR(oea02)  = YEAR('",g_date,"') ",
                "  AND   MONTH(oea02)!= MONTH('",g_date,"'))) ",
                "    AND oea00='1' AND oeaconf='Y' ",
                " AND oea01 MATCHES ltrim(rtrim(oayslip)) || '-*' AND oay11='Y'"
            END IF
            #No.TQC-B80126  --End
         WHEN ar_type='2'
#No.TQC-B60286 --begin
#No.MOD-B50245 --begin
            LET l_where1="(oga07<>'Y' AND ",
                         "( YEAR(oga02) != YEAR('",g_date,"') ",
                         "   OR  (YEAR(oga02)  = YEAR('",g_date,"') ",
                         "  AND   MONTH(oga02)!= MONTH('",g_date,"')))) "
#No.MOD-B50245 --end
#No.TQC-B60286 --end
            LET l_where2="(oga07='Y' AND ",
                         "( YEAR(oga02) > YEAR('",g_date,"') ",
                         "   OR  (YEAR(oga02)  = YEAR('",g_date,"') ",
                         "  AND   MONTH(oga02)> MONTH('",g_date,"')))) "
            LET l_sql=
             "SELECT UNIQUE YEAR(oga02),MONTH(oga02) ",
             #"   FROM ",l_dbs CLIPPED,"oga_file LEFT OUTER JOIN ",l_dbs CLIPPED,"azi_file ON oga_file.oga23=azi_file.azi01,",l_dbs CLIPPED,"oay_file", #No.FUN-9C0014
             "   FROM ",cl_get_target_table(g_plant_new,'oga_file'),                           #FUN-A50102
             " LEFT OUTER JOIN ",cl_get_target_table(g_plant_new,'azi_file'),                  #FUN-A50102
             " ON oga_file.oga23=azi_file.azi01,",cl_get_target_table(g_plant_new,'oay_file'), #FUN-A50102
             "  WHERE  (oga10 IS NULL OR oga10 = ' ')",
             "    AND ",g_wc CLIPPED,
             "   AND (",l_where1," OR ",l_where2,") ", 
#            "   AND (",l_where2,") ",    #No.MOD-B50245 TQC-B60286
             "    AND oga162>=0 AND ogaconf='Y' ",
             #"    AND oga09 IN ('2','3','8','A') AND ogapost='Y' ",  #No.FUN-610020   #No.FUN-740016 #MOD-B30536 mark
             "    AND oga09 IN ('2','3','8','A','4','6') AND ogapost='Y' ",            #MOD-B30536 add
             "    AND oga65 ='N' ",  #No.FUN-610020
            #"    AND oga50>0",      #CHI-B30024 mark
             "    AND oga00 IN ('1','4','5','6','B')",  #換貨出貨不應重複產生AR99/05/13   #No.FUN-610064   #No.FUN-740016
             "    AND oga01 like ltrim(rtrim(oayslip)) || '-%' AND oay11='Y'"   #No.FUN-550071
           #FUN-C60013--add--str--
           IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN
              LET l_sql = l_sql CLIPPED," AND oga01 IN(SELECT omf11 FROM omf_file
                                          WHERE ",g_wc3 CLIPPED,")"
           END IF  
           #FUN-C60013--add--end 
           #str CHI-B30024 add
            IF amt0_sw!='Y' THEN
               LET l_sql = l_sql CLIPPED,"    AND oga50>0"
            END IF
           #end CHI-B30024 add
         WHEN ar_type='3'
           #-CHI-A50040-add-
           #LET l_where1="(oga07<>'Y' AND ",
           #             "( YEAR(oga02) != YEAR('",g_date,"') ",
           #             "   OR  (YEAR(oga02)  = YEAR('",g_date,"') ",
           #             "  AND   MONTH(oga02)!= MONTH('",g_date,"')))) "
           #LET l_where2="(oga07='Y' AND ",
           #             "( YEAR(oga02) > YEAR('",g_date,"') ",
           #             "   OR  (YEAR(oga02)  = YEAR('",g_date,"') ",
           #             "  AND   MONTH(oga02)> MONTH('",g_date,"')))) "
           #LET l_sql=
           # "SELECT UNIQUE YEAR(oga02),MONTH(oga02) ",
           # "   FROM ",l_dbs CLIPPED,"oga_file LEFT OUTER JOIN ",l_dbs CLIPPED,"azi_file ON oga_file.oga23=azi_file.azi01,",l_dbs CLIPPED,"oay_file", #No.FUN-9C0014
           # "  WHERE  ",g_wc CLIPPED,
           # "   AND (",l_where1," OR ",l_where2,") ", 
           # "    AND oga00 IN('1','6') AND oga163>0 AND ogaconf='Y' ",   #No.FUN-610064
           # "    AND oga09 IN ('2','3','8') AND ogapost='Y' ",  #No.FUN-610020
           # "    AND oga65 ='N' ",  #No.FUN-610020
           # "  AND  oga01 like ltrim(rtrim(oayslip)) || '-%' AND oay11='Y'"   #No.FUN-550071
            LET l_sql=
             "SELECT UNIQUE YEAR(oea02),MONTH(oea02) ",
             #"   FROM ",l_dbs CLIPPED,"oea_file LEFT OUTER JOIN ",l_dbs CLIPPED,"azi_file ON oea_file.oea23=azi_file.azi01,",l_dbs CLIPPED,"oay_file", #No.FUN-9C0014
             "   FROM ",cl_get_target_table(g_plant_new,'oea_file'),                           #FUN-A50102
             " LEFT OUTER JOIN ",cl_get_target_table(g_plant_new,'azi_file'),                  #FUN-A50102
             " ON oea_file.oea23=azi_file.azi01,",cl_get_target_table(g_plant_new,'oay_file'), #FUN-A50102
             "  WHERE ",g_wc CLIPPED,
             "  AND ( YEAR(oea02) != YEAR('",g_date,"') ",
             "   OR  (YEAR(oea02)  = YEAR('",g_date,"') ",
             "  AND   MONTH(oea02)!= MONTH('",g_date,"'))) ",
            #"    AND oea00='1' AND oea163>0 AND oeaconf='Y' ",
             "    AND oea00='1' AND oea263>0 AND oeaconf='Y' ",    #No:FUN-A50103
             " AND oea01 MATCHES ltrim(rtrim(oayslip)) || '-*' AND oay11='Y'"
           #-CHI-A50040-end-
         WHEN ar_type='4'
            LET l_sql=
             "SELECT UNIQUE YEAR(oha02),MONTH(oha02) ",
             #"   FROM ",l_dbs CLIPPED,"oha_file LEFT OUTER JOIN ",l_dbs CLIPPED,"azi_file ON oha_file.oha23=azi_file.azi01,",l_dbs CLIPPED,"oay_file", #No.FUN-9C0014
             "   FROM ",cl_get_target_table(g_plant_new,'oha_file'),                           #FUN-A50102
             " LEFT OUTER JOIN ",cl_get_target_table(g_plant_new,'azi_file'),                  #FUN-A50102
             " ON oha_file.oha23=azi_file.azi01,",cl_get_target_table(g_plant_new,'oay_file'), #FUN-A50102
             "  WHERE ",g_wc CLIPPED,
             "  AND ( YEAR(oha02) != YEAR('",g_date,"') ",
             "   OR  (YEAR(oha02)  = YEAR('",g_date,"') ",
             "  AND   MONTH(oha02)!= MONTH('",g_date,"'))) ",
             "    AND ohaconf='Y' AND ohapost='Y'",
             "  AND  oha01 like ltrim(rtrim(oayslip)) || '-%' AND oay11='Y'"   #No.FUN-550071
    END CASE
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE p310_prechk FROM l_sql
    IF STATUS THEN CALL cl_err('p310_prechk',STATUS,1)
       LET g_success = 'N'   #No.FUN-570156
       LET l_flag='X' RETURN
    END IF
    DECLARE p310_chkdate CURSOR WITH HOLD FOR p310_prechk

    FOREACH p310_chkdate INTO l_yy,l_mm
      LET g_success = 'N'    #No.FUN-570156
      LET l_flag='Y' EXIT FOREACH
    END FOREACH
 
END FUNCTION
 
FUNCTION p310_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
 
   CALL cl_set_comp_entry("g_date2,g_oma05",TRUE)
   CALL cl_set_comp_entry("open_sw",TRUE)   #MOD-710085
 
END FUNCTION
 
FUNCTION p310_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
 
   IF open_sw = 'N' OR NOT g_before_input_done THEN
      CALL cl_set_comp_entry("g_date2,g_oma05",FALSE)
      MESSAGE ""
   END IF
 
   IF conf_sw <> 'Y' THEN 
      LET open_sw = 'N'
      DISPLAY BY NAME open_sw
      CALL cl_set_comp_entry("open_sw",FALSE)   
   END IF
 
END FUNCTION
#No.FUN-9C0072 精簡程式碼
