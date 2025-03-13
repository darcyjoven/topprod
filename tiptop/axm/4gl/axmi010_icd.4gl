# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmi010.4gl
# Descriptions...: 銷售系統單據性質維護作業
# Date & Author..: 94/12/13 By Danny
                   # 新增單據自動確認(oayconf),立即列印(oayprnt)兩欄位
                   # By WUPN 96-05-06
#                  1.已用單號欄位取消 2.單號編號欄位 3.銷售分售拿掉
# Modify.........: 99/07/05 By Carol:add 2 fields->oayapr,oaysign 
# Modify.........: No:7725 03/08/06 Carol after field oayapr check 
#                                         是否可輸入oay13,oay14
# Modify.........: No:8749 04/06/20 WIKY FOR GENERO 原bugno:7283不適用
# Modify.........: No:8820 03/12/11 ching oay12 寫回 smy56 (是否影響呆滯日期)
# Modify.........: No.MOD-490306 04/09/20 Melody 單身輸入應該先oayauno再oayconf
# Modify.........: No.MOD-490341 04/09/20 Melody smy53 default 'N' 
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.MOD-490491 04/10/04 By Nicola 拋轉到smy_file時，設定欄位預設值
# Modify.........: No.FUN-4B0038 04/11/15 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.MOD-540182 05/05/05 By saki 增加單據編號方式
# Modify.........: No.FUN-560150 05/06/21 By ice 編碼方法增加4.依年月日,
#                                                輸入的單別按整體定義的參數位數輸入
# Modify.........: No.FUN-570109 05/07/15 By jackie 修正建檔程式key值是否可更改 
# Modify.........: No.MOD-580225 05/08/24 By Nicola 將p_zz"可以修改Key值的選項取消",則新增時key值(單別)無法修改
# Modify.........: No.FUN-580125 05/09/06 By Nicola "自動確認"與"是否簽核"欄位應為互斥的選項, 其中一項為 "Y" 時, 另一項應只能為 "N"
# Modify.........: No.FUN-590033 05/09/08 By Nicola 編號方式預設為"2" 
# Modify.........: No.FUN-5B0078 05/11/17 by Brendan: 當走 EasyFlow 簽核時, 簽核等級等欄位不需輸入
# Modify.........: No.TQC-5B0176 05/11/22 by kim 報表寬度錯誤
# Modify.........: No.TQC-5A0064 05/11/25 BY yiting zz13設y,按單身不會跳到key的>
#                                                   新增一筆資料enter跳到下一行時才會到key的第一個欄位
# Modify.........: No.MOD-5B0122 05/12/06 By Nicola 剔除單據性質'70'~'79' 的RMA單
# Modify.........: No.MOD-5C0116 05/12/23 By Nicola 到單身後,點選 "使用者設限",回到原程式時,單別的資料顯示錯誤
# Modify.........: No.FUN-610020 06/01/04 By Carrier 出貨驗收功能 -- 新增oaytype屬性 57/58/59
# Modify.........: No.FUN-610053 06/01/11 By Nicola oaytype新增屬性21(客戶訂單底稿)
# Modify.........: No.FUN-5C0095 06/01/16 By Rosayu 新增有效碼
# Modify.........: No.FUN-610044 06/01/18 By Sarah 當oaytype='55'時(新增INVOICE單別)不必CALL ins_smy()
# Modify.........: No.FUN-610014 06/01/22 By viven 新增oya15,oay16,oay17,oay18,oay19,oay20欄位
# Modify.........: No.FUN-610060 06/03/24 By pengu 單據性質為'50'出貨單 '60'銷退單,則自動insert至MFG單據性質檔
# Modify.........: No.FUN-640013 06/03/27 By Rayven 新增屬性組欄位oay22
# Modify.........: No.FUN-5C0082 06/04/04 By viven 新增oaytype"00","01","02","03","04"的選項
# Modify.........: No.FUN-640027 06/04/08 By Sarah 新增時,有效碼(oayacti)要預設為'Y'
# Modify.........: No.FUN-640200 06/04/018 By pengu 當asms290 的'單據別屬性群組關聯'不打勾時, 此畫面的屬性群組欄位不應出現
# Modify.........: No.FUN-640250 06/04/25 BY yiting 是否有發票限額(oay13) /發票限額 (oay14),為大陸功能,是否依整體參數(aza26)來決定是否呈現
# Modify.........: No.FUN-650065 06/05/15 By cl 新增oaytype屬性"19,派車單"
# Modify.........: No.FUN-640248 06/05/30 By Echo 單別為:10,20,30,32,33,34,35 取消"立即確認"與"應簽核"欄位為互斥的選項
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-650147 06/06/29 By Sarah smu_file,smv_file相關SQL中,g_sys的部份改成"axm",CALL s_smu與s_smv時原本傳g_sys也改成傳"axm"
# Modify.........: No.TQC-660133 06/07/03 By rainy s_xxxslip(),s_smu(),s_smv()中的參數 g_sys 改寫死系統別(ex:AAP)中的參數 g_sys 改寫死系統別(ex:AAP)
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.FUN-660004 06/07/24 By rainy 刪除時要與asmi300勾稽
# Modify.........: No.TQC-680137 06/08/30 By pengu 修改錯誤代碼
# Modify.........: No.FUN-690003 06/09/01 By Mandy 新增單據性質'09':客戶申請
# Modify.........: No.FUN-680137 06/09/05 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.TQC-690018 06/09/13 By Rayven 不使用流通配銷時也能輸入oay17
# Modify.........: No.FUN-680051 06/09/14 By rainy *->5*, 5*->*應秀訊息並建議手動處理, 系統不自動處理
# Modify.........: No.FUN-660044 06/10/23 By rainy 移除BU間銷售
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0087 06/11/09 By king 改正報表中有關錯誤
# Modify.........: No.TQC-6A0086 06/11/13 By baogui 改正報表中有關錯誤
# Modify.........: No.FUN-6B0065 06/11/21 By Ray atmi217并入aooi313(azf09,10,11,12,13取代tqe03,04,05,11,08)
# Modify.........: No.MOD-710126 07/01/19 By day 新增與修改時判斷當屬性群組為NULL時賦值為空 
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-740016 07/04/13 By Nicola oaytype新增屬性22(借貨申請單)、51(借貨出貨單)
# Modify.........: No.TQC-740137 07/04/19 By Carrier 打印時,加入"有效碼"標識
# Modify.........: No.MOD-750144 07/05/31 By claire 調整 FUN-680051 性質5*,6*修改非性質時仍要更新資料
# Modify.........: No.TQC-770128 07/07/31 By Mandy 當性質為'09'客戶申請時,不能維護oay11/oay12,oay15
# Modify.........: No.FUN-7A0038 07/10/24 By Carrier aza50='N'時,開放oay16/oay17/oay18/oay19 keyin(調貨流程時用到這些字段,但不一定是aza50='Y')
# Modify.........: No.TQC-7B0149 07/11/28 By chenl 增加字段oay24,內部交易單據否。
# Modify.........: No.TQC-7C0056 07/12/06 By Beryl 不會異動庫存的單據性質變為會異動庫存的單據性質，需要將此單別insert到smy_file中
# Modify.........: No.FUN-7C0004 07/12/12 By rainy oay24 移至 oayacti 前一位
#                                                  insert into smy_file時， smy53沒一起寫入
# Modify.........: No.FUN-7C0043 07/12/19 By Sunyanchun    老報表改成p_query
# Modify.........: No.FUN-7B0018 08/01/16 By hellen 單據性質增加一種類型：12-NEW CODE申請單 
# Modify.........: No.FUN-810016 08/01/21 By ve007  單據性質增加兩種類型：61-混合包裝單，62-預包裝單
# Modify.........: No.FUN-820046 08/03/13 By chenyu 單據性質增加一種類型: 57-混裝方式單
# Modify.........: No.MOD-830128 08/03/17 By Claire 性質5*修改年月日會有"更新不成功smy_file'的錯誤
# Modify.........: No.FUN-830076 08/03/21 By hellen 新增相關文件ACTION
# Modify.........: No.MOD-830182 08/03/24 By Claire 刪除性質5*,6*不包含55時,要刪除相對應的製造單據
# Modify.........: No.FUN-830087 08/03/25 By ve007  debug 810016
# Modify.........: No.FUN-920107 09/02/19 By sabrina axmt420與EasyFlow整合，單別22 取消"立即確認"與"應簽核"欄位為互斥的選項   
# Modify.........: No.MOD-920383 09/03/02 By Pengu 調整SQL與法
# Modify.........: No.FUN-930104 09/03/23 By dxfwo   理由碼的分類改善
# Modify.........: No.FUN-960130 08/08/12 By Sunyanchun 增加單據性質
# Modify.........: No.TQC-970302 09/08/12 By lilingyu 發票限額的欄位輸入負數沒有控管
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0016 09/11/08 By Sunyanchun post no
# Modify.........: No.FUN-9B0061 09/11/09 By lilingyu 補齊cl_forupd_sql
# Modify.........: No:FUN-9C0071 10/01/06 By huangrh 精簡程式
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A10109 10/02/10 By TSD.zeak 取消編碼方式，單據性質改成動態combobox
# Modify.........: No:FUN-970017 10/04/01 By Lilan 開放以下單別,同時可以自動確認和簽核=>"40","43","44","50","51","54","58"				 
# Modify.........: No:FUN-A70014 10/07/08 By hongmei r.p2后過單
# Modify.........: No:FUN-A70130 10/08/12 By huangtao 修改開窗q_oay3
# Modify.........: No:MOD-AB0210 10/11/23 By lilingyu 當smy_file已存在一般單別時,插入動作會報錯
# Modify.........: No:CHI-8B0052 10/11/26 By Summer 控管單別不能有'-'字元存在
# Modify.........: No:TQC-AC0094 10/12/09 By huangtao 修改報錯方式
# Modify.........: No:MOD-B20079 11/02/18 By Summer FUN-A80026新增smy74為NOT NULL,但smy74無給值
# Modify.........: No:FUN-A90054 11/04/22 By suncx 於menu段也加上這二個action，設定遊標所在該筆單別的資料 
# Modify.........: No.FUN-B50039 11/07/07 By xianghui 增加自訂欄位
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改	
# Modify.........: NO.FUN-B90103 11/09/23 By xjll 增加裝箱單單別、訂貨會明細單、訂貨會確認單
# Modify.........: No:MOD-BA0124 11/10/19 By suncx 新增oaytype=63的判斷
# Modify.........: No:FUN-BA0014 11/10/14 By Abby 開放單別"60",同時可以自動確認和簽核
# Modify.........: No:TQC-C20292 12/02/21 By lixiang 其他行業不顯示64、65、66
# Modify.........: No:TQC-C20327 12/02/21 By huangrh 顯示64，65,66
# Modify.........: No.FUN-C60033 12/07/18 By minpp ooytype_50在oaz26=2且oaz92=y,才显示
# Modify.........: No.FUN-C50136 12/08/22 By xujing 增加oaytype Item:91  信用額度開帳/調整單
# Modify.........: No:MOD-CA0034 12/10/22 By Nina 因FUN-A10109將單據性質改成動態combobox導致單別顯示異常
# Modify.........: No.MOD-CB0040 12/11/06 By SunLM 單據性質為70的可以維護發票限額
# Modify.........: No.MOD-CC0107 13/01/22 By Carrier 订单单别时开放oay19,oay20的input
# Modify.........: No.CHI-D30015 13/03/14 By Elise 增加出通單同步更新
# Modify.........: No.MOD-D30150 13/03/15 By Elise 改抓aooi800單據別設定代碼為axmi010的資料
# Modify.........: No.DEV-D30026 13/03/20 By Nina GP5.3 追版:DEV-CB0006為GP5.25 的單號
# Modify.........: No:DEV-D30031 13/03/18 By Nina 修正DEV-CB0006 SQL條件oayslip=oaybslip
# Modify.........: No:FUN-D30030 13/03/20 By Nina 修正參數aoos010的是否與M-Barcode整合設定為'N'時有顯示'條碼相關'的功能
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    m_oay           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        oayslip     LIKE oay_file.oayslip,  
        oaydesc     LIKE oay_file.oaydesc, 
        oayauno     LIKE oay_file.oayauno,    #No.MOD-490306
        oayconf     LIKE oay_file.oayconf,    #No.MOD-490306
        oayprnt     LIKE oay_file.oayprnt,
        #oaydmy6     LIKE oay_file.oaydmy6,   #FUN-A10109
        oaytype     LIKE oay_file.oaytype,
        oay11       LIKE oay_file.oay11,  #是否產生AR
        oay12       LIKE oay_file.oay12,    
        oayapr      LIKE oay_file.oayapr,    
        oaysign     LIKE oay_file.oaysign,    
        oay13       LIKE oay_file.oay13,    
        oay14       LIKE oay_file.oay14,  #FUN-5C0095
        oay15       LIKE oay_file.oay15,  #FUN-610014
        oay16       LIKE oay_file.oay16,  #FUN-610014
        oay19       LIKE oay_file.oay19,  #FUN-610014
        oay17       LIKE oay_file.oay17,  #FUN-610014
        oay18       LIKE oay_file.oay18,  #FUN-610014
        oay20       LIKE oay_file.oay20,  #FUN-610014
        oay22       LIKE oay_file.oay22,  #No.FUN-640013
        oay24       LIKE oay_file.oay24,  #內部交易單據否    #FUN-7C0004N
        oayacti     LIKE oay_file.oayacti, #FUN-5C0095 
        #FUN-B50039-add-str--
        oayud01     LIKE oay_file.oayud01,
        oayud02     LIKE oay_file.oayud02,
        oayud03     LIKE oay_file.oayud03,
        oayud04     LIKE oay_file.oayud04,
        oayud05     LIKE oay_file.oayud05,
        oayud06     LIKE oay_file.oayud06,
        oayud07     LIKE oay_file.oayud07,
        oayud08     LIKE oay_file.oayud08,
        oayud09     LIKE oay_file.oayud09,
        oayud10     LIKE oay_file.oayud10,
        oayud11     LIKE oay_file.oayud11,
        oayud12     LIKE oay_file.oayud12,
        oayud13     LIKE oay_file.oayud13,
        oayud14     LIKE oay_file.oayud14,
        oayud15     LIKE oay_file.oayud15
        #FUN-B50039-add-end--
                    END RECORD,
    g_buf           LIKE ima_file.ima01,        #No.FUN-680137  VARCHAR(40)
    m_oay_t         RECORD                 #程式變數 (舊值)
        oayslip     LIKE oay_file.oayslip,  
        oaydesc     LIKE oay_file.oaydesc, 
         oayauno     LIKE oay_file.oayauno,   #No.MOD-490306
         oayconf     LIKE oay_file.oayconf,   #No.MOD-490306
        oayprnt     LIKE oay_file.oayprnt,
        #oaydmy6     LIKE oay_file.oaydmy6, #FUN-A10109
        oaytype     LIKE oay_file.oaytype,
        oay11       LIKE oay_file.oay11,  #是否產生AR
        oay12       LIKE oay_file.oay12,    
        oayapr      LIKE oay_file.oayapr,    
        oaysign     LIKE oay_file.oaysign,    
        oay13       LIKE oay_file.oay13,    
        oay14       LIKE oay_file.oay14, #FUN-5C0095
        oay15       LIKE oay_file.oay15,  #FUN-610014
        oay16       LIKE oay_file.oay16,  #FUN-610014
        oay19       LIKE oay_file.oay19,  #FUN-610014
        oay17       LIKE oay_file.oay17,  #FUN-610014
        oay18       LIKE oay_file.oay18,  #FUN-610014
        oay20       LIKE oay_file.oay20,  #FUN-610014
        oay22       LIKE oay_file.oay22,  #No.FUN-640013
        oay24       LIKE oay_file.oay24,  #內部交易單據否    #No.TQC-7B0149 #FUN-7C0004
        oayacti     LIKE oay_file.oayacti, #FUN-5C0095
        #FUN-B50039-add-str--
        oayud01     LIKE oay_file.oayud01,
        oayud02     LIKE oay_file.oayud02,
        oayud03     LIKE oay_file.oayud03,
        oayud04     LIKE oay_file.oayud04,
        oayud05     LIKE oay_file.oayud05,
        oayud06     LIKE oay_file.oayud06,
        oayud07     LIKE oay_file.oayud07,
        oayud08     LIKE oay_file.oayud08,
        oayud09     LIKE oay_file.oayud09,
        oayud10     LIKE oay_file.oayud10,
        oayud11     LIKE oay_file.oayud11,
        oayud12     LIKE oay_file.oayud12,
        oayud13     LIKE oay_file.oayud13,
        oayud14     LIKE oay_file.oayud14,
        oayud15     LIKE oay_file.oayud15
        #FUN-B50039-add-end--
                    END RECORD,
    g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,            #單身筆數        #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5             #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE g_cnt        LIKE type_file.num10            #No.FUN-680137 INTEGER
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE cb           ui.ComboBox            #No.FUN-7B0018
DEFINE g_comb1      ui.ComboBox            #FUN-C60033
DEFINE g_index_s    LIKE type_file.chr1    #FUN-A90054 add
DEFINE g_t1         LIKE oay_file.oayslip  #No:DEV-D30026--add
DEFINE g_msg        LIKE type_file.chr1000 #No:DEV-D30026--add
 
MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   OPEN WINDOW i010_w WITH FORM "axm/42f/axmi010"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
   
  #LET cb = ui.ComboBox.forName("oaytype")   #MOD-CA0034 mark
   CALL s_getgee('axmi010',g_lang,'oaytype') #MOD-CA0034 add
 
   CALL cb.removeItem('61')
   CALL cb.removeItem('62')
   CALL cb.removeItem('64')  #TQC-C20292
   CALL cb.removeItem('65')  #TQC-C20292
   CALL cb.removeItem('66')  #TQC-C20292

   IF g_aza.aza50 !='Y' THEN
      CALL cl_set_comp_visible("oay15,oay20",FALSE)  #No.TQC-690018
   END IF
 
   IF g_sma.sma907 ='N' THEN
       CALL cl_set_comp_visible("oay22",FALSE)
   END IF
 
   IF g_aza.aza26 != '2' THEN
      CALL cl_set_comp_visible("oay13",FALSE)
      CALL cl_set_comp_visible("oay14",FALSE)
   END IF
 
   IF g_sma.sma120 !='Y' THEN 
      CALL cl_set_comp_visible("oay22",FALSE)
   END IF
 
   SELECT aza131 INTO g_aza.aza131 FROM aza_file   #FUN-D30030 add

   #No:DEV-D30026--add--begin
   IF g_aza.aza131 MATCHES '[Nn]' OR cl_null(g_aza.aza131) THEN
     #CALL cl_set_comp_visible("barcode_related", FALSE)   #FUN-D30030 mark
      CALL cl_set_act_visible("barcode_related", FALSE)    #FUN-D30030 add
   END IF
   #No:DEV-D30026--add--end

   LET g_wc2 = '1=1'
   CALL i010_b_fill(g_wc2)
 
   CALL i010_menu()
 
   CLOSE WINDOW i010_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i010_menu()
   WHILE TRUE
      CALL i010_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i010_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i010_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i010_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
#FUN-A90054  add begin-------------------------------------         
         WHEN "user_authorization"  
            IF NOT cl_null(m_oay[l_ac].oayslip) THEN 
               IF cl_chk_act_auth() THEN
                  CALL s_smu(m_oay[l_ac].oayslip,"AXM")   
               END IF
            ELSE
               CALL cl_err('','anm-217',0)
            END IF
 
         WHEN "dept_authorization" 
            IF NOT cl_null(m_oay[l_ac].oayslip) THEN 
               IF cl_chk_act_auth() THEN
                  CALL s_smv(m_oay[l_ac].oayslip,"AXM")   
               END IF
            ELSE
               CALL cl_err('','anm-217',0)
            END IF
#FUN-A90054  add -end--------------------------------------    
         #No:DEV-D30026--add--begin
         WHEN "barcode_related"     #條碼相關
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(m_oay[l_ac].oayslip) THEN
                 LET g_t1 = s_get_doc_no(m_oay[l_ac].oayslip)
                 LET g_msg="abai160 '",g_t1,"'"
                 CALL cl_cmdrun_wait(g_msg)
              ELSE
                 CALL cl_err('','anm-217',0)
              END IF
           END IF
         #No:DEV-D30026--add--end
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(m_oay),'','')
            END IF
         WHEN "related_document"
            IF cl_chk_act_auth() AND l_ac != 0 THEN
               IF m_oay[l_ac].oayslip IS NOT NULL THEN
                  LET g_doc.column1 = "oayslip"
                  LET g_doc.value1 = m_oay[l_ac].oayslip
                  CALL cl_doc()
               END IF
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i010_q()
 
   CALL s_getgee('axmi010',g_lang,'oaytype') #FUN-A10109
   CALL cb.removeItem('64')  #TQC-C20292
   CALL cb.removeItem('65')  #TQC-C20292
   CALL cb.removeItem('66')  #TQC-C20292

   CALL i010_b_askkey()
 
END FUNCTION
 
FUNCTION i010_b()
   DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680137 SMALLINT
          l_n             LIKE type_file.num5,                #檢查重複用      #No.FUN-680137 SMALLINT
          l_lock_sw       LIKE type_file.chr1,                #單身鎖住否      #No.FUN-680137 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,                #處理狀態        #No.FUN-680137 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
          l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680137 SMALLINT
   DEFINE l_i             LIKE type_file.num5                 #No.FUN-560150   #No.FUN-680137 SMALLINT
   DEFINE l_oaysys        LIKE oay_file.oaysys                #TQC-AC0094   

   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT oayslip,oaydesc,oayauno,oayconf,oayprnt,",   #No.MOD-490306
                      #"       oaydmy6,", #FUN-A10109
                      "       oaytype,oay11,oay12,oayapr,oaysign,",   #FUN-7C0004 oay24 移至 acti 之前
                      "       oay13,oay14,",
                      "       oay15,oay16,oay19,oay17,oay18,oay20,",   #FUN-610014 
                      "       oay22,oay24,oayacti,",           #No.FUN-640013   #FUN-7C0004  
                      "       oayud01,oayud02,oayud03,oayud04,oayud05,",        #FUN-B50039
                      "       oayud06,oayud07,oayud08,oayud09,oayud10,",        #FUN-B50039
                      "       oayud11,oayud12,oayud13,oayud14,oayud15 ",        #FUN-B50039
                      "  FROM oay_file WHERE oayslip=? AND oaysys = 'axm' FOR UPDATE"    #FUN-A70130  add  oaysys = 'axm'
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i010_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY m_oay WITHOUT DEFAULTS FROM s_oay.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
            
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         CALL cl_set_doctype_format("oayslip")
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         LET g_success = 'Y'        #No.FUN-610060 add
 
         IF g_rec_b >= l_ac THEN
            LET m_oay_t.* = m_oay[l_ac].*  #BACKUP
            LET p_cmd='u'
            BEGIN WORK
            OPEN i010_bcl USING m_oay_t.oayslip
            IF STATUS THEN
               CALL cl_err("OPEN i010_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH i010_bcl INTO m_oay[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(m_oay_t.oayslip,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            LET g_before_input_done = FALSE                                   
            CALL i010_set_entry(p_cmd)                                        
            CALL i010_set_no_entry(p_cmd)                                     
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE m_oay[l_ac].* TO NULL      #900423
         LET m_oay_t.* = m_oay[l_ac].*         #新輸入資料
         LET g_before_input_done = FALSE                                   
         CALL i010_set_entry(p_cmd)                                        
         CALL i010_set_no_entry(p_cmd)                                     
         LET g_before_input_done = TRUE
         LET m_oay[l_ac].oay11= 'N'
         LET m_oay[l_ac].oay12= 'N'
         LET m_oay[l_ac].oayauno= 'Y'
         LET m_oay[l_ac].oayconf= 'N'
         LET m_oay[l_ac].oayprnt= 'N'
         LET m_oay[l_ac].oayapr = 'N'
         LET m_oay[l_ac].oaysign= ''
         LET m_oay[l_ac].oay13 = 'N'
         LET m_oay[l_ac].oay14 = 0
         LET m_oay[l_ac].oay15 = 'Y'    #No.FUN-610014
         #LET m_oay[l_ac].oaydmy6 = '2'  #No.FUN-590033 #FUN-A10109
         LET m_oay[l_ac].oayacti= 'Y'   #FUN-640027 add
         LET m_oay[l_ac].oay24 = 'N'    #No.TQC-7B0149 
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD oayslip
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(m_oay[l_ac].oay22) THEN
            LET m_oay[l_ac].oay22 = ' '
         END IF
         INSERT INTO oay_file(oayslip,oaydesc,oayauno,
                              oayconf,oayprnt,
                              #oaydmy6, #FUN-A10109
                              oaytype,oay24,oay11,oay12,    #No.TQC-7B0149 add oay24
                              oayapr,oaysign,oay13,oay14,
                              oay15,oay16,oay19,oay17,oay18,oay20,oay22,oayacti,oaysys,   #FUN-A70130                #No.FUN-640013
                              oayud01,oayud02,oayud03,oayud04,oayud05,oayud06,oayud07,    #FUN-B50039
                              oayud08,oayud09,oayud10,oayud11,oayud12,oayud13,oayud14,oayud15)   #FUN-B50039
              VALUES(m_oay[l_ac].oayslip,m_oay[l_ac].oaydesc,
                     m_oay[l_ac].oayauno,m_oay[l_ac].oayconf,
                     m_oay[l_ac].oayprnt,
                     #m_oay[l_ac].oaydmy6, #FUN-A10109
                     m_oay[l_ac].oaytype,m_oay[l_ac].oay24,m_oay[l_ac].oay11,    #No.TQC-7B0149 add oay24
                     m_oay[l_ac].oay12,
                     m_oay[l_ac].oayapr,m_oay[l_ac].oaysign,
                     m_oay[l_ac].oay13,m_oay[l_ac].oay14,
                     m_oay[l_ac].oay15,m_oay[l_ac].oay16,m_oay[l_ac].oay19, #FUN-610014
                     m_oay[l_ac].oay17,m_oay[l_ac].oay18,m_oay[l_ac].oay20, #FUN-610014
                     m_oay[l_ac].oay22,m_oay[l_ac].oayacti,'axm', #No.FUN-640013  #FUN-A70130
                     #FUN-B50039-add-str--
                     m_oay[l_ac].oayud01,m_oay[l_ac].oayud02,m_oay[l_ac].oayud03,
                     m_oay[l_ac].oayud04,m_oay[l_ac].oayud05,m_oay[l_ac].oayud06,
                     m_oay[l_ac].oayud07,m_oay[l_ac].oayud08,m_oay[l_ac].oayud09,
                     m_oay[l_ac].oayud10,m_oay[l_ac].oayud11,m_oay[l_ac].oayud12,
                     m_oay[l_ac].oayud13,m_oay[l_ac].oayud14,m_oay[l_ac].oayud15)
                     #FUN-B50039-add-end--
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","oay_file",m_oay[l_ac].oayslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CANCEL INSERT
         ELSE
            #單據性質為'50'出貨單 '60'銷退單,或為'70'開票單別，則自動insert至
            #MFG單據性質檔
            IF (m_oay[l_ac].oaytype MATCHES '5*' AND    #FUN-610044
                m_oay[l_ac].oaytype != '55') OR         #FUN-610044
               m_oay[l_ac].oaytype MATCHES '6*' 
               OR m_oay[l_ac].oaytype MATCHES '7*' OR m_oay[l_ac].oaytype MATCHES '4*' THEN  #FUN-C60033 #CHI-D30015 add 4
               CALL i010_ins_smy()
            END IF
            #FUN-A10109  ===S===
            CALL s_access_doc('a',m_oay[l_ac].oayauno,m_oay[l_ac].oaytype,
                              m_oay[l_ac].oayslip,'AXM',m_oay[l_ac].oayacti)
            #FUN-A10109  ===E===
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      AFTER FIELD oayslip                        #check 編號是否重複
         IF m_oay[l_ac].oayslip IS NOT NULL THEN
            IF m_oay[l_ac].oayslip != m_oay_t.oayslip OR
               (NOT cl_null(m_oay[l_ac].oayslip) AND cl_null(m_oay_t.oayslip)) THEN
          #TQC-AC0094 ----------------STA
          #    SELECT count(*) INTO l_n FROM oay_file
          #     WHERE oayslip = m_oay[l_ac].oayslip 
          #    IF l_n > 0 THEN
          #      # CALL cl_err('',-239,0)             #FUN-A70130
          #        CALL cl_err('','axm0000',0)              #FUN-A70130
          #       LET m_oay[l_ac].oayslip = m_oay_t.oayslip
          #       NEXT FIELD oayslip
          #    END IF
               LET l_oaysys = NULL
               SELECT oaysys INTO l_oaysys FROM oay_file
                WHERE oayslip = m_oay[l_ac].oayslip
               IF NOT cl_null(l_oaysys) THEN
                  CALL cl_err_msg(m_oay[l_ac].oayslip,'alm-766',l_oaysys CLIPPED,1)
                  LET m_oay[l_ac].oayslip = m_oay_t.oayslip
                  NEXT FIELD oayslip
               END IF
          #TQC-AC0094 ----------------END
               FOR l_i = 1 TO g_doc_len
                  IF cl_null(m_oay[l_ac].oayslip[l_i,l_i]) THEN
                     CALL cl_err('','sub-146',0)
                     LET m_oay[l_ac].oayslip = m_oay_t.oayslip
                     NEXT FIELD oayslip
                  END IF
                 #----------No:CHI-8B0052 add
                  IF m_oay[l_ac].oayslip[l_i,l_i] = '-' THEN
                      CALL cl_err('','sub-519',0)
                     NEXT FIELD oayslip
                  END IF
                 #----------No:CHI-8B0052 end
               END FOR
            END IF
            IF m_oay[l_ac].oayslip != m_oay_t.oayslip THEN  #NO:6842
               UPDATE smv_file  SET smv01=m_oay[l_ac].oayslip
                WHERE smv01=m_oay_t.oayslip   #NO:單別
                  AND upper(smv03)='AXM'   #g_sys    #NO:系統別   #FUN-650147 g_sys->'axm'    #TQC-670008 'axm'->'AXM'
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","smv_file",m_oay_t.oayslip,"axm",SQLCA.sqlcode,"","UPDATE smv_file",1)  #No.FUN-660167   #FUN-650147
                  EXIT INPUT
               END IF
 
               UPDATE smu_file  SET smu01=m_oay[l_ac].oayslip
                WHERE smu01=m_oay_t.oayslip   #NO:單別
                  AND upper(smu03)='AXM'   #g_sys    #NO:系統別   #FUN-650147 g_sys->'axm'  #TQC-670008 'axm'->'AXM'
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","smu_file",m_oay_t.oayslip,"axm",SQLCA.sqlcode,"","UPDATE smu_file",1)  #No.FUN-660167   #FUN-650147
                  EXIT INPUT
               END IF
            END IF
         END IF
 
      BEFORE FIELD oaytype
         CALL s_getgee('axmi010',g_lang,'oaytype') #FUN-A10109
         CALL cb.removeItem('64')  #TQC-C20292
         CALL cb.removeItem('65')  #TQC-C20292
         CALL cb.removeItem('66')  #TQC-C20292
         #FUN-C60033--ADD---STR
            SELECT oaz92 INTO g_oaz.oaz92 FROM oaz_file WHERE oaz00='0'
            IF g_aza.aza26 <>'2' or g_oaz.oaz92!='Y' THEN
               LET g_comb1 = ui.ComboBox.forName("oaytype")
               CALL g_comb1.removeItem('70')
            END IF
           #FUN-C60033--ADD--end
         CALL i010_set_entry(p_cmd)                                        
 
      AFTER FIELD oaytype
         IF NOT cl_null(m_oay[l_ac].oaytype) THEN            
           #MOD-D30150---mark---S
           #IF m_oay[l_ac].oaytype NOT MATCHES "[123456789]0" AND        #FUN-C60033--ADD--7
           #   m_oay[l_ac].oaytype NOT MATCHES "0[012349]" AND  #No.FUN-5C0082 #FUN-690003 add '09':客戶申請
           #   m_oay[l_ac].oaytype != '19' AND   #派車單   #No.FUN-650065 
           #   m_oay[l_ac].oaytype != '21' AND   #No.FUN-610053
           #   m_oay[l_ac].oaytype != '22' AND   #No.FUN-740016
           #   m_oay[l_ac].oaytype != '32' AND 
           #   m_oay[l_ac].oaytype != '33' AND 
           #   m_oay[l_ac].oaytype != '34' AND 
           #   m_oay[l_ac].oaytype != '43' AND   #出至境外倉
           #   m_oay[l_ac].oaytype != '44' AND   #境外倉出貨
           #   m_oay[l_ac].oaytype != '46' AND   #BU 間銷售通知 
           #   m_oay[l_ac].oaytype != '51' AND   #No.FUN-740016
           #   m_oay[l_ac].oaytype != '53' AND 
           #   m_oay[l_ac].oaytype != '54' AND 
           #   m_oay[l_ac].oaytype != '55' AND 
           #   m_oay[l_ac].oaytype != '57' AND
           #   m_oay[l_ac].oaytype != '58' AND 
           #   m_oay[l_ac].oaytype != '59' AND 
           #   m_oay[l_ac].oaytype != '61' AND
           #   m_oay[l_ac].oaytype != '62' AND
           #   m_oay[l_ac].oaytype != '64' AND   #FUN-B90103
           #   m_oay[l_ac].oaytype != '65' AND   #FUN-B90103
           #   m_oay[l_ac].oaytype != '66' AND   #FUN-B90103
           #   m_oay[l_ac].oaytype != '12' AND
           #   m_oay[l_ac].oaytype NOT MATCHES "A[1-9]" AND
           #   m_oay[l_ac].oaytype NOT MATCHES "B[1-9]" AND
           #   m_oay[l_ac].oaytype != '63' AND        #MOD-BA0124
           #   m_oay[l_ac].oaytype != "C1" AND
           ##  m_oay[l_ac].oaytype != '91' AND     #FUN-C50136 add
           #   m_oay[l_ac].oaytype != '56' THEN  #BU 間銷售出貨 
           #   NEXT FIELD oaytype
           #END IF
           #MOD-D30150---mark---E
           #MOD-D30150---add---S
            CALL i010_chk_oaytype(p_cmd,l_ac)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD CURRENT
            END IF
           #MOD-D30150---add---E 
            IF g_aza.aza26!='2' OR 
               (m_oay[l_ac].oaytype!='50' AND m_oay[l_ac].oaytype!='60' AND m_oay[l_ac].oaytype!='70') THEN ##MOD-CB0040 add '70'
               LET m_oay[l_ac].oay13='N'
               LET m_oay[l_ac].oay14='0'
            END IF
            IF m_oay[l_ac].oaytype!='30' AND m_oay[l_ac].oaytype!='60' THEN
               LET m_oay[l_ac].oay16=''
            END IF
            IF m_oay[l_ac].oaytype!='50' THEN
               LET m_oay[l_ac].oay17=''
               LET m_oay[l_ac].oay18=''
            END IF
            IF m_oay[l_ac].oaytype!='60' THEN
               LET m_oay[l_ac].oay19=''
            END IF
            IF m_oay[l_ac].oaytype!='50' AND m_oay[l_ac].oaytype!='60' THEN
               LET m_oay[l_ac].oay20=''
            END IF
            IF m_oay[l_ac].oaytype = '09' THEN
               LET m_oay[l_ac].oay11='N'
               LET m_oay[l_ac].oay12='N'
               LET m_oay[l_ac].oay15='N'
            END IF
         END IF
         CALL i010_set_no_entry(p_cmd)                                     
 
      ON CHANGE oayconf
         #單據性質為:10,20,30,32,33,34,35時，可以同時選擇"是否簽核"與"自動確認"(取消互斥)。
         #若使用配銷系統，性質為:30,32 還是維持互斥。
         #新增單據性質22，可以同時選擇〝是否簽核〞與〝自動確認〞   #FUN-920107   
         #新增單據性質60，可以同時選擇〝是否簽核〞與〝自動確認〞   #FUN-BA0014
         IF  m_oay[l_ac].oaytype != "10" AND m_oay[l_ac].oaytype != "20" AND
             m_oay[l_ac].oaytype != "33" AND m_oay[l_ac].oaytype != "34" 
         AND m_oay[l_ac].oaytype != "22"      #FUN-920107
         AND m_oay[l_ac].oaytype != "40"      #FUN-970017 add
         AND m_oay[l_ac].oaytype != "43"      #FUN-970017 add
         AND m_oay[l_ac].oaytype != "44"      #FUN-970017 add
         AND m_oay[l_ac].oaytype != "50"      #FUN-970017 add
         AND m_oay[l_ac].oaytype != "51"      #FUN-970017 add
         AND m_oay[l_ac].oaytype != "54"      #FUN-970017 add
         AND m_oay[l_ac].oaytype != "58"      #FUN-970017 add
         AND m_oay[l_ac].oaytype != "60"      #FUN-BA0014 add
         THEN
            IF NOT ((m_oay[l_ac].oaytype = "30" AND g_aza.aza50 = 'N') OR
               (m_oay[l_ac].oaytype = "32" AND g_aza.aza50 = 'N'))
            THEN
                IF m_oay[l_ac].oayconf = "Y" THEN
                   IF m_oay[l_ac].oayapr = "Y" THEN
                      CALL cl_err('','axm-066',0)
                      LET m_oay[l_ac].oayconf = "N"
                      NEXT FIELD oayconf
                   END IF
                END IF
            END IF
         END IF
      ON CHANGE oayapr
         #單據性質為:10,20,30,32,33,34,35時，可以同時選擇"是否簽核"與"自動確認"(取消互斥)。
         #若使用配銷系統，性質為:30,32 還是維持互斥。
         #新增單據性質22，可以同時選擇〝是否簽核〞與〝自動確認〞   #FUN-920107
         #新增單據性質60，可以同時選擇〝是否簽核〞與〝自動確認〞   #FUN-BA0014
         IF  m_oay[l_ac].oaytype != "10" AND m_oay[l_ac].oaytype != "20" AND
             m_oay[l_ac].oaytype != "33" AND m_oay[l_ac].oaytype != "34" 
         AND m_oay[l_ac].oaytype != "22"      #FUN-920107
         AND m_oay[l_ac].oaytype != "40"      #FUN-970017 add
         AND m_oay[l_ac].oaytype != "43"      #FUN-970017 add
         AND m_oay[l_ac].oaytype != "44"      #FUN-970017 add
         AND m_oay[l_ac].oaytype != "50"      #FUN-970017 add
         AND m_oay[l_ac].oaytype != "51"      #FUN-970017 add
         AND m_oay[l_ac].oaytype != "54"      #FUN-970017 add
         AND m_oay[l_ac].oaytype != "58"      #FUN-970017 add
         AND m_oay[l_ac].oaytype != "60"      #FUN-BA0014 add
         THEN
            IF NOT ((m_oay[l_ac].oaytype = "30" AND g_aza.aza50 = 'N') OR
               (m_oay[l_ac].oaytype = "32" AND g_aza.aza50 = 'N'))
            THEN
               IF m_oay[l_ac].oayapr = "Y" THEN
                  IF m_oay[l_ac].oayconf = "Y" THEN
                     CALL cl_err('','axm-066',0)
                     LET m_oay[l_ac].oayapr = "N"
                     NEXT FIELD oayapr
                  END IF
               END IF
            END IF
         END IF
         CALL i010_set_entry(p_cmd)      #FUN-5B0078
         CALL i010_set_no_entry(p_cmd)   #FUN-5B0078
 
      AFTER FIELD oayapr   
         IF m_oay[l_ac].oayapr MATCHES '[YN]' THEN
            IF m_oay[l_ac].oayapr ='N'  THEN 
               LET m_oay[l_ac].oaysign = ''
            END IF 
         END IF
 
      AFTER FIELD oaysign   
         SELECT COUNT(*) INTO g_cnt FROM aze_file 
          WHERE aze01 = m_oay[l_ac].oaysign 
         IF g_cnt=0 THEN 
            CALL cl_err('sel aze','aoo-013',0) 
            NEXT FIELD oaysign
         END IF
 
      BEFORE FIELD oay13
         CALL i010_set_entry(p_cmd)                                        
 
      AFTER FIELD oay13
         IF m_oay[l_ac].oay13 MATCHES '[YN]' THEN
            IF m_oay[l_ac].oay13 = 'N' THEN
               LET m_oay[l_ac].oay14 = 0
            END IF
         END IF
         CALL i010_set_no_entry(p_cmd)                                     
 
      AFTER FIELD oay14 
        IF NOT cl_null(m_oay[l_ac].oay14) THEN
           IF m_oay[l_ac].oay14 < 0 THEN
              CALL cl_err('','aim-223',0)
              NEXT FIELD oay14
           END IF 
        END IF 
      AFTER FIELD oay16     
         IF not cl_null(m_oay[l_ac].oay16) THEN
            SELECT COUNT(*) INTO g_cnt FROM oay_file 
             WHERE oayslip=m_oay[l_ac].oay16 AND oaytype = '50' AND oaysys = 'axm'   #FUN-A70130
            IF g_cnt=0 THEN 
               CALL cl_err('sel oay','atm-350',0) 
               NEXT FIELD oay16
            END IF
         END IF
 
      AFTER FIELD oay17     
         IF not cl_null(m_oay[l_ac].oay17) THEN
            SELECT COUNT(*) INTO g_cnt FROM oay_file 
             WHERE oayslip=m_oay[l_ac].oay17 AND oaytype = '60' AND oaysys = 'axm'  #FUN-A70130
            IF g_cnt=0 THEN 
               CALL cl_err('sel oay','atm-351',0) 
               NEXT FIELD oay17
            END IF
         END IF
 
      AFTER FIELD oay18     
         IF not cl_null(m_oay[l_ac].oay18) THEN
            SELECT COUNT(*) INTO g_cnt FROM azf_file 
             WHERE azf01=m_oay[l_ac].oay18 AND azf09= '2'     
               AND azfacti='Y'
               AND azf02 = '2'   #No.FUN-930104
            IF g_cnt=0 THEN 
               CALL cl_err('sel azf','atm-352',0)      #No.FUN-6B0065
               NEXT FIELD oay18
            END IF
         END IF
 
      AFTER FIELD oay19     
         IF not cl_null(m_oay[l_ac].oay19) THEN
            SELECT COUNT(*) INTO g_cnt FROM azf_file 
             WHERE azf01=m_oay[l_ac].oay19 AND azf09= '1'     
               AND azfacti='Y'
               AND azf02 = '2'   #No.FUN-930104
            IF g_cnt=0 THEN 
               CALL cl_err('sel azf','atm-353',0)      #No.FUN-6B0065
               NEXT FIELD oay19
            END IF
         END IF
 
      AFTER FIELD oay20     
         IF not cl_null(m_oay[l_ac].oay20) THEN
            SELECT COUNT(*) INTO g_cnt FROM tqa_file 
             WHERE tqa01=m_oay[l_ac].oay20 AND tqa03= '20'     
               AND tqaacti='Y'
            IF g_cnt=0 THEN 
               CALL cl_err('sel tqa','atm-354',0) 
               NEXT FIELD oay18
            END IF
         END IF
 
      AFTER FIELD oay22
         IF NOT cl_null(m_oay[l_ac].oay22) THEN
            SELECT count(*) INTO g_cnt FROM aga_file  
             WHERE aga01 = m_oay[l_ac].oay22 AND agaacti='Y'    
            IF g_cnt <= 0 THEN  
               CALL cl_err(m_oay[l_ac].oay22,'aim-910',0)     
               DISPLAY BY NAME m_oay[l_ac].oay22     
               NEXT FIELD oay22  
            END IF
         END IF
 
      #FUN-B50039-add-str--
      AFTER FIELD oayud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oayud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oayud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oayud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oayud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oayud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oayud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oayud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oayud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oayud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oayud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oayud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oayud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oayud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oayud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
      #FUN-B50039-add-end--

      BEFORE DELETE                            #是否取消單身 
         IF m_oay_t.oayslip IS NOT NULL THEN
            SELECT COUNT(*) INTO g_cnt FROM smy_file WHERE smyslip = m_oay_t.oayslip
            IF g_cnt > 0 THEN
               CALL cl_err(m_oay_t.oayslip,'axm-047',1)
            END IF
 
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL                  #No.FUN-9B0098 10/02/24
            LET g_doc.column1 = "oayslip"               #No.FUN-9B0098 10/02/24
            LET g_doc.value1 = m_oay[l_ac].oayslip      #No.FUN-9B0098 10/02/24
            CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
          
            DELETE FROM oay_file WHERE oayslip = m_oay_t.oayslip AND oaysys = 'axm'  #FUN-A70130
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","oay_file",m_oay_t.oayslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            DELETE FROM smy_file WHERE smyslip = m_oay_t.oayslip             
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","smy_file",m_oay_t.oayslip,"axm",SQLCA.sqlcode,"","smy_file",1)  
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            DELETE FROM smv_file WHERE smv01 = m_oay_t.oayslip AND upper(smv03)='AXM'                   #TQC-670008 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","smv_file",m_oay_t.oayslip,"axm",SQLCA.sqlcode,"","smv_file",1)  #No.FUN-660167   #FUN-650147
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            DELETE FROM smu_file WHERE smu01 = m_oay_t.oayslip AND upper(smu03)='AXM'    #NO:6842   #FUN-650147  #TQC-670008
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","smu_file",m_oay_t.oayslip,"axm",SQLCA.sqlcode,"","smu_file",1)  #No.FUN-660167   #FUN-650147
               ROLLBACK WORK
               CANCEL DELETE 
            END IF

           #No:DEV-D30026--add--begin
           #DELETE FROM oayb_file WHERE oaybslip = m_oayb_t.oaybslip    #DEV-D30031 mark
            DELETE FROM oayb_file WHERE oaybslip = m_oay_t.oayslip     #DEV-D30031 add
            IF SQLCA.sqlcode THEN
              #CALL cl_err3("del","oayb_file",m_oayb_t.oaybslip,"",SQLCA.sqlcode,"","",1)   #DEV-D30031 mark
               CALL cl_err3("del","oayb_file",m_oay_t.oayslip,"",SQLCA.sqlcode,"","",1)    #DEV-D30031 add
               ROLLBACK WORK
               CANCEL DELETE
            END IF
           #No:DEV-D30026--add--end

            #FUN-A10109  ===S===
            CALL s_access_doc('r','','',m_oay_t.oayslip,'AXM','')
            #FUN-A10109  ===E===

            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            MESSAGE "Delete OK"
            CLOSE i010_bcl
            COMMIT WORK 
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET m_oay[l_ac].* = m_oay_t.*
            CLOSE i010_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(m_oay[l_ac].oayslip,-263,1)
            LET m_oay[l_ac].* = m_oay_t.*
         ELSE
            IF cl_null(m_oay[l_ac].oay22) THEN
               LET m_oay[l_ac].oay22 = ' '
            END IF
            UPDATE oay_file SET
                   oayslip=m_oay[l_ac].oayslip,oaydesc=m_oay[l_ac].oaydesc,
                   oayauno=m_oay[l_ac].oayauno,oayconf=m_oay[l_ac].oayconf,
                   oayprnt=m_oay[l_ac].oayprnt,
                   #oaydmy6=m_oay[l_ac].oaydmy6, #FUN-A10109
                   oaytype=m_oay[l_ac].oaytype,oay24 =m_oay[l_ac].oay24,    #No.TQC-7B0149 add oay24
                   oay11  =m_oay[l_ac].oay11, oay12  =m_oay[l_ac].oay12,
                   oayapr =m_oay[l_ac].oayapr,oaysign =m_oay[l_ac].oaysign,
                   oay13  =m_oay[l_ac].oay13,oay14 = m_oay[l_ac].oay14, #FUN-5C0095
                   oay15  =m_oay[l_ac].oay15,oay16 = m_oay[l_ac].oay16, #FUN-610014
                   oay17  =m_oay[l_ac].oay17,oay19 = m_oay[l_ac].oay19, #FUN-610014
                   oay18  =m_oay[l_ac].oay18,oay20 = m_oay[l_ac].oay20, #FUN-610014
                   oay22 = m_oay[l_ac].oay22,oayacti=m_oay[l_ac].oayacti, #No.FUN-640013
                   #FUN-B50039-add-str--
                   oayud01 = m_oay[l_ac].oayud01,
                   oayud02 = m_oay[l_ac].oayud02,
                   oayud03 = m_oay[l_ac].oayud03,
                   oayud04 = m_oay[l_ac].oayud04,
                   oayud05 = m_oay[l_ac].oayud05,
                   oayud06 = m_oay[l_ac].oayud06,
                   oayud07 = m_oay[l_ac].oayud07,
                   oayud08 = m_oay[l_ac].oayud08,
                   oayud09 = m_oay[l_ac].oayud09,
                   oayud10 = m_oay[l_ac].oayud10,
                   oayud11 = m_oay[l_ac].oayud11,
                   oayud12 = m_oay[l_ac].oayud12,
                   oayud13 = m_oay[l_ac].oayud13,
                   oayud14 = m_oay[l_ac].oayud14,
                   oayud15 = m_oay[l_ac].oayud15
                   #FUN-B50039-add-end--
             WHERE oayslip = m_oay_t.oayslip  AND oaysys = 'axm'  #FUN-A70130
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","oay_file",m_oay_t.oayslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
               LET m_oay[l_ac].* = m_oay_t.*
            ELSE
               #FUN-C60033 --begin
                   #单据性质为70.开票单，则自动insert至smy_file
                   IF m_oay[l_ac].oaytype='70' THEN
                      CALL i010_ins_smy()
                   END IF
                   #FUN-C60033 --end
               #FUN-A10109  ===S===
               CALL s_access_doc('r','','',m_oay_t.oayslip,'AXM','')
               CALL s_access_doc('a',m_oay[l_ac].oayauno,m_oay[l_ac].oaytype,
                                 m_oay[l_ac].oayslip,'AXM',m_oay[l_ac].oayacti)
               #FUN-A10109 ===E===

               #修改后單據性質為'50'出貨單 '60'銷退單,
               #修改前單據性質不為'50'出貨單 '60'銷退單,則自動insert至MFG單據性質檔                                                                                                          
               #CHI-D30015 增加單據性質為'40' 出貨通知單
               IF ((m_oay[l_ac].oaytype MATCHES '5*' AND m_oay[l_ac].oaytype != '55') OR m_oay[l_ac].oaytype MATCHES '6*' 
                    OR m_oay[l_ac].oaytype MATCHES '4*' )  #CHI-D30015 add 
                  AND (m_oay_t.oaytype NOT MATCHES '5*' AND m_oay_t.oaytype NOT MATCHES '6*' 
                       AND m_oay_t.oaytype NOT MATCHES '4*' ) THEN  #CHI-D30015 add                                                                               
                  CALL i010_ins_smy()                                                                                                  
               END IF                    

              IF (m_oay_t.oaytype MATCHES '5*' AND    
                  m_oay_t.oaytype != '55') OR       
                 m_oay_t.oaytype MATCHES '6*' OR m_oay_t.oaytype MATCHES '4*'  THEN   #MOD-750144 add #CHI-D30015 add 4
               IF (m_oay[l_ac].oaytype MATCHES '5*'               #MOD-830128 modify "("
                  AND NOT m_oay_t.oaytype MATCHES '5*')           #MOD-830128 modify ")"
               OR (m_oay[l_ac].oaytype MATCHES '6*'               #MOD-830128 modify "("
                  AND NOT m_oay_t.oaytype MATCHES '6*')           #MOD-830128 modify ")"
               OR (m_oay[l_ac].oaytype MATCHES '4*'               #CHI-D30015 add
                  AND NOT m_oay_t.oaytype MATCHES '4*')           #CHI-D30015 add
               OR (m_oay_t.oaytype MATCHES '5*'                   #MOD-830128 modify "("
                  AND NOT m_oay[l_ac].oaytype MATCHES '5*')       #MOD-830128 modify ")"
               OR (m_oay_t.oaytype MATCHES '6*'                   #MOD-830128 modify "("
                  AND NOT m_oay[l_ac].oaytype MATCHES '6*')       #MOD-830128 modify ")"
               OR (m_oay_t.oaytype MATCHES '4*'                   #CHI-D30015 add
                  AND NOT m_oay[l_ac].oaytype MATCHES '4*') THEN  #CHI-D30015 add
                 CALL cl_err('','axm-061',1)
              ELSE
                IF m_oay[l_ac].oaytype != '55' THEN               #MOD-830128 add
                    CALL i010_upd_smy()
                 IF g_success = 'N' THEN
                    LET m_oay[l_ac].* = m_oay_t.*
                    ROLLBACK WORK
                 ELSE
                    MESSAGE 'UPDATE O.K'
                    CLOSE i010_bcl
                    COMMIT WORK
                 END IF
                ELSE                                             #MOD-830128 
                   CALL cl_err('','axm-061',1)                   #MOD-830128 
                END IF                                           #MOD-830128   
              END IF
            END IF    #MOD-750144 add
 
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET m_oay[l_ac].* = m_oay_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL m_oay.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE i010_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30034 add
         CLOSE i010_bcl
         COMMIT WORK
 
      ON ACTION user_authorization  #NO:6842
         IF NOT cl_null(m_oay[l_ac].oayslip) THEN
            LET g_action_choice="user_authorization"  #MOD-4B0300
            IF cl_chk_act_auth() THEN
               CALL s_smu(m_oay[l_ac].oayslip,"AXM")   #TQC-660133
            END IF
         ELSE
            CALL cl_err('','anm-217',0)
         END IF
 
      ON ACTION dept_authorization  #NO:6842
         IF NOT cl_null(m_oay[l_ac].oayslip) THEN
             LET g_action_choice="dept_authorization"   #MOD-4B0300
            IF cl_chk_act_auth() THEN
               CALL s_smv(m_oay[l_ac].oayslip,"AXM")   #TQC-660133
            END IF
         ELSE
            CALL cl_err('','anm-217',0)
         END IF
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(oayslip) AND l_ac > 1 THEN
            LET m_oay[l_ac].* = m_oay[l_ac-1].*
            NEXT FIELD oayslip
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLP
         IF INFIELD(oaysign) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_aze"
            LET g_qryparam.default1 = m_oay[l_ac].oaysign
            CALL cl_create_qry() RETURNING m_oay[l_ac].oaysign
            DISPLAY BY NAME m_oay[l_ac].oaysign          #No.MOD-490371
            NEXT FIELD oaysign
         END IF 
         IF INFIELD(oay16) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_oay3"
            LET g_qryparam.arg1 ='50'
            LET g_qryparam.arg2 = 'axm'      #FUN-A70130
            LET g_qryparam.default1 = m_oay[l_ac].oay16
            CALL cl_create_qry() RETURNING m_oay[l_ac].oay16
            DISPLAY BY NAME m_oay[l_ac].oay16
            NEXT FIELD oay16  
         END IF 
         IF INFIELD(oay17) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_oay3"
            LET g_qryparam.arg1 ='60'
            LET g_qryparam.arg2 = 'axm'     #FUN-A70130
            LET g_qryparam.default1 = m_oay[l_ac].oay17
            CALL cl_create_qry() RETURNING m_oay[l_ac].oay17
            DISPLAY BY NAME m_oay[l_ac].oay17
            NEXT FIELD oay17  
         END IF 
         IF INFIELD(oay18) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_azf01a"    #No.FUN-930104
            LET g_qryparam.arg1 ='2'
            LET g_qryparam.default1 = m_oay[l_ac].oay18
            CALL cl_create_qry() RETURNING m_oay[l_ac].oay18
            DISPLAY BY NAME m_oay[l_ac].oay18
            NEXT FIELD oay18  
         END IF 
         IF INFIELD(oay19) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_azf01a"    #No.FUN-930104
            LET g_qryparam.arg1 ='1'
            LET g_qryparam.default1 = m_oay[l_ac].oay19
            CALL cl_create_qry() RETURNING m_oay[l_ac].oay19
            DISPLAY BY NAME m_oay[l_ac].oay19
            NEXT FIELD oay19  
         END IF 
         IF INFIELD(oay20) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_tqa1"
            LET g_qryparam.arg1 ='20'
            LET g_qryparam.default1 = m_oay[l_ac].oay20
            CALL cl_create_qry() RETURNING m_oay[l_ac].oay20
            DISPLAY BY NAME m_oay[l_ac].oay20
            NEXT FIELD oay20  
         END IF 
         IF INFIELD(oay22) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_aga"
            LET g_qryparam.default1= m_oay[l_ac].oay22
            CALL cl_create_qry() RETURNING m_oay[l_ac].oay22
            DISPLAY BY NAME m_oay[l_ac].oay22
            NEXT FIELD oay22
         END IF
 
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
 
   CLOSE i010_bcl
   COMMIT WORK
 
END FUNCTION

#MOD-D30150---add---S
FUNCTION i010_chk_oaytype(p_cmd,p_ac)
DEFINE p_cmd                     LIKE type_file.chr1,
       p_ac                      LIKE type_file.num5
DEFINE l_gee01                   LIKE gee_file.gee01,
       l_gee02                   LIKE gee_file.gee02,
       l_geeacti                 LIKE gee_file.geeacti

   SELECT geeacti INTO l_geeacti FROM gee_file
    WHERE gee01 = 'AXM'  AND gee02 = m_oay[p_ac].oaytype
      AND gee03 = g_lang AND gee04 = 'axmi010'

   CASE
      WHEN l_geeacti = 'N'
         LET g_errno = 'aap991'
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
END FUNCTION
#MOD-D30150---add---E
 
FUNCTION i010_ins_smy()
   DEFINE l_smy   RECORD LIKE smy_file.*
   DEFINE l_cnt   LIKE type_file.num5    #MOD-AB0210
 
   INITIALIZE l_smy.* TO NULL
   LET l_smy.smyslip = m_oay[l_ac].oayslip       
   LET l_smy.smydesc = m_oay[l_ac].oaydesc
   LET l_smy.smyauno = m_oay[l_ac].oayauno
   LET l_smy.smysys  = 'aim'                     #系統別
   LET l_smy.smykind = '8'                       #單據性質(mfg出貨單)
   LET l_smy.smyatsg = 'N'                       #自動簽核
   LET l_smy.smyprint= m_oay[l_ac].oayprnt       #立即列印
 
   LET l_smy.smydmy1 = 'Y'                       #成本入項
   LET l_smy.smydmy2 = '2'                       #成會分類(銷)
   LET l_smy.smydmy4 = m_oay[l_ac].oayconf       #立即確認
  # LET l_smy.smydmy5 = m_oay[l_ac].oaydmy6       #編號方式 #FUN-A10109
   LET l_smy.smyware = '0'                       #倉庫設限方式
   LET l_smy.smy53   = m_oay[l_ac].oay24         #FUN-7C0004
   LET l_smy.smy56   =  m_oay[l_ac].oay12     #No.8820
   LET l_smy.smyacti = 'Y'
   LET l_smy.smyuser = g_user
   LET l_smy.smygrup = g_grup
   LET l_smy.smydate = g_today
   LET l_smy.smymxno = '0'                       #倉庫設限方式
   LET l_smy.smyapr  = m_oay[l_ac].oayapr        #簽核處理
   LET l_smy.smysign = m_oay[l_ac].oaysign       #簽核處理
   LET l_smy.smydays = '0'
   LET l_smy.smyprit = '0'
   LET l_smy.smy57   = 'NNNNN1'
   LET l_smy.smy58   = 'N'
   LET l_smy.smy59   = 'N'
 
   LET l_smy.smyoriu = g_user      #No.FUN-980030 10/01/04
   LET l_smy.smyorig = g_grup      #No.FUN-980030 10/01/04
   LET l_smy.smy74   ='N'          #MOD-B20079 add
#MOD-AB0210 --begin--
   SELECT count(*) INTO l_cnt FROM smy_file
    WHERE smyslip = l_smy.smyslip
 IF l_cnt = 0 THEN
#MOD-AB0210 --end--
   INSERT INTO smy_file VALUES(l_smy.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("ins","smy_file",l_smy.smyslip,"","axm-278","","ins smy",1)  #No.FUN-660167
   END IF
   #FUN-A10109  ===S===
   CALL s_access_doc('a',l_smy.smyauno,l_smy.smykind,l_smy.smyslip,UPSHIFT(l_smy.smysys),l_smy.smyacti)
   #FUN-A10109  ===E===
 END IF   #MOD-AB0210
END FUNCTION
 
FUNCTION i010_upd_smy()
DEFINE l_sql      STRING
DEFINE l_smy   RECORD LIKE smy_file.*
 
     LET l_sql = "SELECT * FROM smy_file WHERE smyslip=? FOR UPDATE"
     LET l_sql=cl_forupd_sql(l_sql)
 
     DECLARE i010_smy_bcl CURSOR FROM l_sql      # LOCK CURSOR
 
     OPEN i010_smy_bcl USING m_oay[l_ac].oayslip
     IF STATUS THEN
        CALL cl_err("OPEN i010_smy_bcl:", STATUS, 1)
        CLOSE i010_smy_bcl
        LET g_success = 'N'
        RETURN
     END IF
     UPDATE smy_file SET
            smy53    = m_oay[l_ac].oay24,        #內部交易單據否  #No.TQC-7B0149 
            smydesc  = m_oay[l_ac].oaydesc,
            smyauno  = m_oay[l_ac].oayauno,
            smyprint = m_oay[l_ac].oayprnt,      #立即列印
            smydmy4  = m_oay[l_ac].oayconf,      #立即確認
            #smydmy5  = m_oay[l_ac].oaydmy6,      #編號方式 #FUN-A10109
            smy56    = m_oay[l_ac].oay12,        #呆滯日期
            smyapr   = m_oay[l_ac].oayapr,       #簽核處理
            smysign  = m_oay[l_ac].oaysign       #簽核處理
            WHERE smyslip = m_oay[l_ac].oayslip
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("upd","smy_file",m_oay[l_ac].oayslip,"","axm-820","","upd smy",1)  #No.FUN-660167  #No.TQC-680137 modify
        LET g_success = 'N'
     ELSE
        CALL cl_err('','axm-820',1)   #MOD-750144 add
     END IF
     #FUN-A10109  ===S===
     SELECT * INTO l_smy.* FROM smy_file
      WHERE smyslip = m_oay[l_ac].oayslip
     CALL s_access_doc('u',l_smy.smyauno,l_smy.smykind,l_smy.smyslip,UPSHIFT(l_smy.smysys),l_smy.smyacti)
     #FUN-A10109  ===E===

     CLOSE i010_smy_bcl
END FUNCTION
 
FUNCTION i010_b_askkey()
 
   CLEAR FORM
   CALL m_oay.clear()
 
   CONSTRUCT g_wc2 ON oayslip,oaydesc,oayauno,oayconf,oayprnt,        #No.MOD-490306
                      #oaydmy6, #FUN-A10109
                      oaytype,oay11,oay12,oay13,oay14,  #No.TQC-7B0149 add oay24        #FUN-7C0004 oay24 移至oayacti前
                      oay15,oay16,oay19,oay17,oay18,oay20,oay22,oay24,oayacti,   #No.FUN-640013  #FUN-7C0004 oay24 移至 oayacti前
                      oayud01,oayud02,oayud03,oayud04,oayud05,        #FUN-B50039
                      oayud06,oayud07,oayud08,oayud09,oayud10,        #FUN-B50039
                      oayud11,oayud12,oayud13,oayud14,oayud15         #FUN-B50039
           FROM s_oay[1].oayslip,s_oay[1].oaydesc,s_oay[1].oayauno,   #No.MOD-490306
                s_oay[1].oayconf,s_oay[1].oayprnt,                    #No.MOD-490306
                #s_oay[1].oaydmy6, #FUN-A10109 
                s_oay[1].oaytype,  #s_oay[1].oay24,     #No.TQC-7B0149 add oay24   #FUN-7C0004 
                s_oay[1].oay11,
                s_oay[1].oay12,s_oay[1].oay13,s_oay[1].oay14,
                s_oay[1].oay15,s_oay[1].oay16,s_oay[1].oay19,         #FUN-610014
                s_oay[1].oay17,s_oay[1].oay18,s_oay[1].oay20,         #FUN-610014
                s_oay[1].oay22,s_oay[1].oay24,s_oay[1].oayacti,  #No.FUN-640013  #FUN-7C0004 add oay24
                s_oay[1].oayud01,s_oay[1].oayud02,s_oay[1].oayud03,s_oay[1].oayud04,s_oay[1].oayud05,  #FUN-B50039
                s_oay[1].oayud06,s_oay[1].oayud07,s_oay[1].oayud08,s_oay[1].oayud09,s_oay[1].oayud10,  #FUN-B50039
                s_oay[1].oayud11,s_oay[1].oayud12,s_oay[1].oayud13,s_oay[1].oayud14,s_oay[1].oayud15  #FUN-B50039
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
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
 
   CALL i010_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i010_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2   LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(200)
 
   LET g_sql = "SELECT oayslip,oaydesc,oayauno,oayconf,oayprnt,",     #No.MOD-490306
               #"       oaydmy6,", #FUN-A10109
               "       oaytype,oay11,oay12,oayapr,oaysign,oay13,oay14,",     #No.TQC-7B0149 add oay24      #FUN-7C0004
               "       oay15,oay16,oay19,oay17,oay18,oay20,oay22,oay24,oayacti",  #No.FUN-640013                   #FUN-7C0004
               "  FROM oay_file",
               " WHERE ", p_wc2 CLIPPED,                     #單身
             # "   AND oaytype NOT LIKE '7%'",  #No.MOD-5B0122    #FUN-C60033 MARK
               "   AND oaytype!='05' ",  #No.FUN-610014  #FUN-5C0082    #No.MOD-920383 modify
               "   AND oaytype!='06' " , #No.FUN-610014  #FUN-5C0082     #No.MOD-920383 modify
               "   AND oaysys = 'axm' "         #FUN-A70130
   	  LET g_sql = g_sql," ORDER BY oaytype,oayslip"
#  END IF

   PREPARE i010_pb FROM g_sql
   DECLARE oay_curs CURSOR FOR i010_pb
 
   CALL m_oay.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
 
   FOREACH oay_curs INTO m_oay[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   CALL m_oay.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i010_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY m_oay TO s_oay.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         IF g_index_s <> 'Y' OR g_index_s IS NULL THEN  #FUN-A90054 add
            LET l_ac = ARR_CURR()
         ELSE
         	  LET g_index_s = 'N'    #FUN-A90054 add
         END IF
         CALL fgl_set_arr_curr(l_ac)
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
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

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
         
#FUN-A90054  add begin-------------------------------------         
      ON ACTION user_authorization  
         LET g_action_choice="user_authorization" 
         LET g_index_s = 'Y'
         EXIT DISPLAY 
 
      ON ACTION dept_authorization  
         LET g_action_choice="dept_authorization" 
         LET g_index_s = 'Y'
         EXIT DISPLAY  
#FUN-A90054  add -end--------------------------------------

      #No:DEV-D30026--add--begin
      ON ACTION barcode_related  #條碼相關
         LET g_action_choice="barcode_related"
         EXIT DISPLAY
      #No:DEV-D30026--add--end
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
   
      ON ACTION cancel
             LET INT_FLAG=FALSE                 #MOD-570244 mars
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
 
      ON ACTION related_document    #相關文件
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i010_out()
    DEFINE l_cmd  LIKE type_file.chr1000
    IF g_wc2 IS NULL THEN CALL cl_err('',9057,0) RETURN END IF                  
    LET l_cmd = 'p_query "axmi010" "',g_wc2 CLIPPED,'"'                         
    CALL cl_cmdrun(l_cmd)
 
END FUNCTION
 
FUNCTION i010_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF INFIELD(oayapr) OR ( NOT g_before_input_done ) THEN
       IF m_oay[l_ac].oayapr = 'Y' AND g_aza.aza23 = 'N' THEN
          CALL cl_set_comp_entry("oaysign",TRUE)
       END IF
    END IF  
 
    IF INFIELD(oaytype) OR ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("oay11,oay12,oay13,oay15,oay16,oay17,oay18,oay19,oay20",TRUE)    #FUN-610014 #TQC-770128 add oay11,oay12
    END IF  
    IF INFIELD(oay13) OR ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("oay14",TRUE)
    END IF  
    IF (p_cmd = 'a' AND  ( NOT g_before_input_done )
       OR p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey = 'Y' ) THEN
       CALL cl_set_comp_entry("oayslip",TRUE)
    END IF
END FUNCTION  
               
FUNCTION i010_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1                     #No.FUN-680137 VARCHAR(1)
                                                                                
    IF INFIELD(oayapr) OR ( NOT g_before_input_done ) THEN
       IF m_oay[l_ac].oayapr ='N' OR ( m_oay[l_ac].oayapr = 'Y' AND g_aza.aza23 = 'Y' ) THEN   #FUN-5B0078
          CALL cl_set_comp_entry("oaysign",FALSE) 
       END IF
    END IF
    IF INFIELD(oaytype) OR ( NOT g_before_input_done ) THEN
       IF g_aza.aza26 != '2' OR (m_oay[l_ac].oaytype != '50' AND
          m_oay[l_ac].oaytype != '60' AND m_oay[l_ac].oaytype != '70') THEN  #MOD-CB0040 add '70'
          CALL cl_set_comp_entry("oay13,oay14",FALSE)  #No.FUN-610014
       END IF  
    END IF  
    IF INFIELD(oay13) OR ( NOT g_before_input_done ) THEN
       IF g_aza.aza26 != '2' OR cl_null(m_oay[l_ac].oay13) OR
          m_oay[l_ac].oay13 = 'N' THEN
          CALL cl_set_comp_entry("oay14",FALSE)
       END IF  
    END IF  
    IF INFIELD(oaytype) OR ( NOT g_before_input_done ) THEN
       IF m_oay[l_ac].oaytype!='30' AND m_oay[l_ac].oaytype!='60' THEN
          CALL cl_set_comp_entry("oay16",FALSE)
       END IF  
    END IF  
    IF INFIELD(oaytype) OR ( NOT g_before_input_done ) THEN
       IF m_oay[l_ac].oaytype!='50' THEN
          CALL cl_set_comp_entry("oay17,oay18",FALSE)
       END IF  
    END IF  
    IF INFIELD(oaytype) OR ( NOT g_before_input_done ) THEN
       #No.MOD-CC0107  --Begin
       #IF m_oay[l_ac].oaytype!='60' THEN
       IF m_oay[l_ac].oaytype!='60' AND m_oay[l_ac].oaytype!='30'THEN
       #No.MOD-CC0107  --End  
          CALL cl_set_comp_entry("oay19",FALSE)
       END IF  
    END IF  
    IF INFIELD(oaytype) OR ( NOT g_before_input_done ) THEN
       #No.MOD-CC0107  --Begin
       #IF m_oay[l_ac].oaytype!='50' AND m_oay[l_ac].oaytype!='60' THEN
       IF m_oay[l_ac].oaytype!='50' AND m_oay[l_ac].oaytype!='60' AND m_oay[l_ac].oaytype!='30' THEN
       #No.MOD-CC0107  --End  
          CALL cl_set_comp_entry("oay20",FALSE)
       END IF  
    END IF  
    IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                             
      CALL cl_set_comp_entry("oayslip",FALSE)                                                                                       
    END IF                                                                                                                          
    IF INFIELD(oaytype) OR ( NOT g_before_input_done ) THEN    #FUN-9B0061
       IF m_oay[l_ac].oaytype = '09' THEN
          CALL cl_set_comp_entry("oay11,oay12,oay15",FALSE)  
       END IF  
    END IF  
 
END FUNCTION            
#No:FUN-9C0071--------精簡程式-----
#NO.FUN-B80089
