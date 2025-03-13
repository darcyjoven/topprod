# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asfp304.4gl
# Descriptions...: 訂單整批工單產生作業
# Date & Author..: 00/12/20 BY jacky
# Modify.........: 00-12-26 BY ANN CHEN  新增sfb93欄位的Default
# Modify.........: No.MOD-480184 04/08/06 By Wiky LET xxx='  '改=>' '
# Modify.........: No.MOD-480211 04/08/09 By Carol 將 oea01,sfb81,wo_type 設為 not null required 的欄位
# Modify.........: No.MOD-490217 04/09/10 By yiting 料號欄位放大
# Modify.........: No.MOD-530283 05/03/25 By Mandy 第一次未輸入工單單別時,即執行Carray,系統出現單別未輸入,但補入單別不時,執行Carray則無反應
# Modify.........: No.FUN-550112 05/05/27 By ching 特性BOM功能修改
# Modify.........: No.FUN-550067 05/05/31 By Trisy 單據編號加大
# Modify.........: No.MOD-530402 05/06/15 By pengu  1.轉至工單時，工單單頭製造通知單之項次應為 Null，不可為 0
#                                                   2.轉至工單時，工單單頭之成本中心應為Null，不可為 1
#                                                   3.錯誤之訂單編號時，錯誤訊息u(asf-737)無此製造通知單資料」，應改為無此訂單資料
#                                                   4. PROMPT '是否要重算: 預計開工日(Y/N)將改成CALL cl_conf()
# Modify.........: No.MOD-530799 05/06/30 By pengu 1.訂單轉工單應參考 ima562 之生產損耗率
                                                 # 2.生產量控管不能大於訂單量z`
                                                 # 3.在計算開工日時，需考慮非工作日
# Modify.........: No.MOD-580322 05/08/31 By wujie  中文資訊修改進 ze_file
# Modify.........: No.FUN-580178 05/09/08 By Rosayu 計算工單開工日時也應該要判斷行事曆休假日,否則造成與mrp 計算邏輯不一致
# Modify.........: No.MOD-5A0073 05/10/05 By Claire sfb28結案狀態不需給值
# Modify.........: No.FUN-5B0131 05/12/07 By Pengu CALL cl_cmdrun(g_msg) 改用 CALL cl_cmdrun_wait(g_msg)
                                       #           否則會造成CALL s_smyauno()時,發生status=-263問題
# Modify.........: No.TQC-610003 06/01/17 By Nicola INSERT INTO sfb_file 時, 特性代碼欄位(sfb95)應抓取該工單單頭生產料件在料件主檔(ima_file)設定的'主特性代碼'欄位(ima910)
# Modify.........: No.FUN-640083 06/04/09 By kim 訂單轉工單未卡是否為重覆性生產料件
# Modify.........: No.FUN-640148 06/04/17 By Sarah 增加當工單完工日與訂單預定交貨日不同時顯示訊息
# Modify.........: No.FUN-650193 06/06/01 By kim 2.0功能改善-主特性代碼
# Modify.........: No.FUN-570104 06/06/08 By Sarah 訂單若部份備置(ex:訂單量100，備置20)，則仍需可以轉工單(80)
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.MOD-670106 06/07/26 By cl 執行s_schdat函數后，更新sfb24的值.
# Modify.........: No.FUN-670103 06/07/31 By kim GP3.5 利潤中心
# Modify.........: No.FUN-670041 06/08/10 By Pengu 將sma29 [虛擬產品結構展開與否] 改為 no use
# Modify.........: No.TQC-680104 06/08/24 By pengu MOD-670106的修改會照成當訂單設有備置量時無法轉工單
# Modify.........: No.FUN-650054 06/09/11 By kim 工單型態 應置於單身可就不同item 各自選擇
# Modify.........: No.FUN-680121 06/09/18 By huchenghao 類型轉換
# Modify.........: No.FUN-6B0044 06/11/13 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.MOD-6A0138 06/11/15 By Claire 單身選不重計預計開工日會還原為原值
# Modify.........: No.TQC-730022 07/03/12 By rainy 新增背景作業
# Modify.........: No.MOD-790028 07/09/17 By Pengu 生產損耗率ima562應除100
# Modify.........: No.CHI-740001 07/09/27 By rainy bma_file要判斷有效碼
# Modify.........: No.TQC-7A0065 07/10/19 By lumxa "訂單轉工單asfp304作業BUG：
#                                                  已發放工單還原作業(asfp322)中發現某張母工單無法還原，報錯""無符合條件的資料""。
#                                                  發現抓取工單資料時有這樣一個條件："" AND sfb17 IS NULL"" ，
#                                                  據查，是訂單轉工單作業asfp304給sfb17賦值為0：LET l_sfb.sfb17 = 0 ，應改為LET l_sfb.sfb17 = NULL"
# Modify.........: No.TQC-7B0031 07/11/06 By Carrier 單身沒有選中時,不進行后續的邏輯處理
# Modify.........: No.FUN-710073 07/12/03 By jamie 1.UI將 '天' -> '天/生產批量'
#                                                  2.將程式有用到 'XX前置時間'改為乘以('XX前置時間' 除以 '生產單位批量(ima56)')
# Modify.........: No.FUN-7C0021 07/12/06 By Sarah 當新增工單時,若工單型態(sfb02)為11.拆件式工單時,重工(sfb99)預設值給Y
# Modify.........: No.CHI-810015 08/01/17 By jamie 將FUN-710073修改部份還原
# Modify.........: No.FUN-810014 FUN-850079 08/01/17 By arman 修改為服飾版
# Modify.........: No.FUN-7B0018 08/02/26 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-840212 08/04/21 By Pengu FUN-810014單身加入訂單欄位，卻未撈訂單單號顯示
# Modify.........: No.FUN-840194 08/06/25 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No.FUN-870117 08/08/01 BY ve007 增加按作業編號生成工單的功能
# Modify.........: No.MOD-880016
# Modify.........: No.MOD-8C0265 08/12/29 By chenyu 輸完工日期后，點否則不調整開工日期
# Modify.........: No.MOD-920243 09/02/19 By claire 排除 oea61 > (oea62+oea63) 資料 
# Modify.........: No.TQC-920104 09/02/27 By chenyu 部門/廠商欄位后面判斷有問題
# Modify.........: No.FUN-8C0081 09/03/09 By sabrina 原i301sub_firm1拆為i301sub_firm1_chk和i301sub_firm1_upd，所以此程式也一併調整
# Modify.........: No.MOD-940205 09/04/14 By Pengu 若有設生產損耗率, 當轉成工單時,工單生產量的計算會錯誤
# Modify.........: No.MOD-940349 09/04/27 By Pengu 控管境外倉出貨訂單不可轉工單
# Modify.........: No.FUN-950021 09/05/26 By Carrier 呼叫i301sub時，加傳一個是否在transaction的參數
# Modify.........: No.FUN-960083 09/06/30 By mike對單身特性代碼欄位加上開窗功能    
# Modify.........: No.FUN-920088 09/07/10 By jan 一般行業單頭部分欄位調整為QBE      
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-960317 09/09/03 By Carrier transaction 完整性修正
# Modify.........: No.MOD-990224 09/09/29 By Smapmin 沒有單位轉換率時,要default 1
# Modify.........: No:MOD-970045 09/11/03 By Pengu 訂單轉工單時，排除oea61>(oea62+oea63)的限制，且加上oeb70='N'的條件
# Modify.........: No:TQC-9B0181 09/11/23 By lilingyu 產生工單時,工單單頭sfbmksg都給'N'是錯誤的,應該去撈單別性質檔的設定來決定
# Modify.........: No:MOD-950295 09/11/27 By sabrina 若工單單別為不自動編碼時會無法正常轉工單
# Modify.........: No:MOD-950298 09/11/27 By sabrina 調整顯示工單號碼程式段
# Modify.........: No.FUN-9C0072 10/01/11 By vealxu 精簡程式碼
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造
#                                                   成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:MOD-A30177 10/03/30 By Summer 工單型態=8時,ven_no開窗應開供應商基本資料檔
# Modify.........: No:MOD-A40002 10/04/07 By Summer 增加oeb1001訂單原因碼default給sfb51工單理由碼
# Modify.........: No.TQC-A50087 10/05/20 By liuxqa sfb104 赋初值.
# Modify.........: No.TQC-A50129 10/05/21 By lilingyu 增加controlg功能
# Modify.........: No.FUN-A50066 10/06/10 By jan 平行製程
# Modify.........: No:MOD-A70028 10/08/03 By Pengu 程式位使用cl_used()
# Modify.........: No.FUN-A80102 10/08/20 By kim GP5.25號機管理
# Modify.........: No.FUN-A80054 10/08/26 By jan GP5.25工單間合拼
# Modify.........: No:MOD-A90067 10/09/23 By Summer 將手冊編號oeb908也帶入sfb97
# Modify.........: No:FUN-A80060 10/09/28 By jan GP5.25工單間合拼(edg50/edg51算法改寫)
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管
# Modify.........: No:MOD-AB0063 10/11/08 By sabrina 若是重工工單或拆件式工單(工單型態為5、8、11)不應控管須建BOM
# Modify.........: No:MOD-AB0243 10/11/29 By sabrina (1)料件來源碼若為"S"，則工單型態改為"委外工單"
#                                                    (2)工單型態若為"委外工單"則"部門/廠商"欄位default為該料件的主要供應商
# Modify.........: No:TQC-AB0136 10/12/01 By jan ima571為null時,不能產生製程檔
# Modify.........: No:TQC-AC0238 10/12/17 By zhangweib 工單單別排除smy73='Y'的單別
# Modify.........: No.TQC-AC0243 10/12/17 By vealxu 抓預設製程編號應該撈ima94才對
# Modify.........: No:MOD-AC0288 10/12/24 By sabrina 成本中心應依工單單別來抓取 
# Modify.........: No:TQC-B20161 11/02/23 By jan INSERT INTO asfp312_tmp時VALUES個數不符
# Modify.........: No:FUN-B20085 11/03/03 By jan asfp304 控卡複雜操作不方便
# Modify.........: No.MOD-B30028 11/03/04 By zhangll 修正插入sfci_file,系统异常当出问题
# Modify.........: No.FUN-B20075 11/03/07 By kim 計畫批號要可以處理逗號
# Modify.........: No.FUN-B30035 11/03/10 By jan asfp304每次處理資料時，同合拼版號的都產生在同一張PBI單上 
# Modify.........: No.MOD-B30463 11/03/14 By shenyang 
# Modify.........: No.FUN-B20060 11/04/07 By zhangll sfb071改抓oeb72
# Modify.........: No.FUN-940103 11/05/10 By lixiang 增加規格顯示欄位
# Modify.........: No.TQC-B60133 11/06/16 By jan 無工單資料產生時，請給相應的報錯信息
# Modify.........: No.TQC-B60189 11/06/20 By lixh1 當訂單單身有輸入BOM版本時，訂單再轉工單並將訂單指定的BOM版本，default到工單BOM版本欄位中
# Modify.........: No.TQC-B60323 11/06/24 By guoch 轉為工單時進行生產批量和最小生產量的檢查
# Modify.........: No:MOD-B40215 11/07/17 By Summer 若l_max_no及l_min_no為null時，應給一個空白字元 
# Modify.........: No:CHI-B80053 11/10/06 By johung 成本中心是null時，帶入輸入料號的ima34
# Modify.........: NO:CHI-B80044 11/10/17 By johung 訂單轉工單且料有設生產批量時，生產數量應為批量的倍數，若大於訂單數則不可超過批量數
#                                                   生產數量大於訂單數時不控卡，僅提示訊息
# Modify.........: No.FUN-BC0008 11/12/02 By zhangll s_cralc4整合成s_cralc,s_cralc增加傳參
# Modify.........: No:MOD-C30872 12/03/27 By destiny 自动生成单身资料时排出掉misc料件 
# Modify.........: No:MOD-C50030 12/05/07 By suncx 已出貨的訂單轉工單，數量計算錯誤
# Modify.........: No:MOD-C40193 12/05/08 By ck2yuan 由外部傳入g_wc會是null,則給予oea01 = g_argv1(單號)
# Modify.........: No:MOD-C50055 12/05/09 By suncx 預計開工日和預計完工日bug處理
# Modify.........: No:FUN-C50052 12/05/17 By bart 單身增加全選取消全選按鈕
# Modify.........: No:TQC-C50223 12/05/28 By fengrui 預計開工日和預計完工日bug處理
# Modify.........: No:MOD-BA0006 12/06/18 By ck2yuan 做生產批量和最小生產量檢查時應判斷此張訂單是否要轉成工單
# Modify.........: No:TQC-C70002 12/07/02 By fengrui 生成的工單單號提示信息添加子工單單號
# Modify.........: No:TQC-C70031 12/07/04 By fengrui 生成的工單單號提示信息排除未轉工單
# Modify.........: No:TQC-C70104 12/07/19 By fengrui 工單按條件設為必輸欄位,根據轉值設置必輸欄位
# Modify.........: No:MOD-C70255 12/07/25 By ck2yuan 還原 MOD-C50030的修改
# Modify.........: No.FUN-C30114 12/08/07 By bart sfb89值
# Modify.........: No:MOD-C80127 12/08/20 By Lori oeb72有特別輸入值時,訂單轉工單不論什麼方式都要預帶oeb72
# Modify.........: No:CHI-C60023 12/08/20 By bart 新增欄位-資料類別
# Modify.........: No:TQC-C80187 12/08/31 By qiull 不經過單頭的部門欄位時,也需要增加控管
#                                                  不經過單身的部門欄位時，也要增加控管
# Modify.........: No.CHI-C90006 12/11/13 By bart 失效判斷
# Modify.........: No.MOD-CB0115 12/11/23 By Elise 修正SQL撈已開工數量
# Modify.........: No.MOD-C90048 12/11/30 By Elise 將訂單oeb41,oeb42,oeb43,oeb1001帶入工單的sfb27,sfb271,sfb50,sfb51
# Modify.........: No:MOD-CC0162 12/12/26 By Elise 調整因ima56=0使數量不會自動帶出的問題
# Modify.........: No:CHI-C50029 13/03/08 By Alberti 當下階料皆為消耗性料件時，預設扣帳方式為2:事後扣帳
#                                                    一併修改MOD-C80095
# Modify.........: No:FUN-D10127 13/03/15 By Alberti 增加sfduser,sfdgrup,sfdmodu,sfddate,sfdacti
# Modify.........: No.DEV-D30026 13/03/18 By Nina GP5.3 追版:DEV-D10003為GP5.25 的單號
# Modify.........: No.DEV-D30037 13/03/21 By TSD.JIE 有用smyb01="2:條碼單據"的控卡的改為用單身任一筆(MIN(項次)判斷即可)料件是否為包號管理(ima931)='Y'
# Modify.........: No.MOD-D40028 13/04/08 By bart 如果該料已預計停產且生效日期<today，則不產生至單身，且於彙總訊息顯示
# Modify.........: No.FUN-D50098 13/06/03 By lixh1 母工單的產生和子工單的產生包含在一個事物里
# Modify.........: No:TQC-DA0029 13/10/22 By yangxf  BUG修改，事务回滚不继续往下执行

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE
         g_argv1   LIKE   oea_file.oea01,  #TQC-730022
         g_argv2   LIKE   smy_file.smyslip,  #TQC-730022
         g_argv3   LIKE   type_file.chr1,    #TQC-730022
         g_ima     RECORD LIKE ima_file.*,
         g_oea     RECORD LIKE oea_file.*,
         g_sfb     RECORD LIKE sfb_file.*,
         g_flag    LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1)
         sfc_sw    LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1),
         lot       LIKE type_file.num10,   #No.FUN-680121 INTEGER, 
#        lota      LIKE ima_file.ima26,    #No.FUN-680121 DEC(15,3), 
         lota      LIKE type_file.num15_3, ###GP5.2  #NO.FUN-A20044 
         l_mod     LIKE type_file.num10,   #No.FUN-680121 INTEGER, 
         g_cmd,g_sql,g_sql_smy  STRING,  #No.FUN-580092 HCN
         g_t1      LIKE oay_file.oayslip,                     #No.FUN-550067        #No.FUN-680121 VARCHAR(05)
         g_sw      LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(01),
         mm_sfb08  LIKE sfb_file.sfb08,
         l_ima60   LIKE ima_file.ima60,
         l_ima601  LIKE ima_file.ima601,   #No.FUN-840194 
         l_oeb05   LIKE oeb_file.oeb05,
         l_ima55   LIKE ima_file.ima55,
         l_ima562  LIKE ima_file.ima562,
 
         new DYNAMIC ARRAY OF RECORD
                x             LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(01),
                oeb01         LIKE oeb_file.oeb01,    #No.FUN-810014
                oeb03         LIKE oeb_file.oeb03,
                oebud04       LIKE oeb_file.oebud04,  #add by guanyao160730
                oebud11       LIKE oeb_file.oebud11,  #add by guanyao160730 
                new_part      LIKE ima_file.ima01,    #No.MOD-490217
                ima02         LIKE ima_file.ima02,
                ima021        LIKE ima_file.ima021,   #No.FUN-940103
                sfb93         LIKE sfb_file.sfb93,    #FUN-A50066
                sfb06         LIKE sfb_file.sfb06,    #FUN-A50066
                edc01         LIKE edc_file.edc01,    #FUN-A80054
                edc02         LIKE edc_file.edc02,    #FUN-A80054
                ima910        LIKE ima_file.ima910,   #FUN-650193
                new_qty       LIKE sfb_file.sfb08,    #No.FUN-680121 DEC(15,3),
                sfb08_s       LIKE type_file.num15_3, #add by guanyao160729
                sfb08_1       LIKE type_file.num15_3,   #add  by guanyao160806
                #sfb08_f       LIKE type_file.num10,   #add by guanyao160729
                imaud10       LIKE ima_file.imaud10,  #add by guanyao160729
                sfb919        LIKE sfb_file.sfb919,   #FUN-A80102
                b_date        LIKE type_file.dat,     #No.FUN-680121 DATE
                e_date        LIKE type_file.dat,     #No.FUN-680121 DATE
                sfb02         LIKE sfb_file.sfb02,    #FUN-650054
                new_no        LIKE oea_file.oea01,    #No.FUN-680121 VARCHAR(16), #No.FUN-550067  
                ven_no        LIKE pmc_file.pmc01,    #No.FUN-680121 VARCHAR(10),
                a             LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(01),
                costcenter    LIKE gem_file.gem01, #FUN-670103
                gem02c        LIKE gem_file.gem02  #FUN-670103
                END RECORD,
         tm         RECORD
                gen02         LIKE gen_file.gen02,
                desc          LIKE pmc_file.pmc01,  #No.FUN-680121 VARCHAR(10),
                gem01         LIKE gem_file.gem01,  #FUN-670103
                skd01         LIKE skd_file.skd01, #No.FUN-810014
                sfb81         LIKE sfb_file.sfb81, #No.FUN-810014
                sfc01         LIKe sfc_file.sfc01, #No.FUN-810014
                bmb09         LIKE bmb_file.bmb09, #No.FUN-870117
                mac_opt       LIKE type_file.chr1  #FUN-A80102
                END RECORD
#FUN-D50098 ------Begin------
  DEFINE
   mg
      DYNAMIC ARRAY OF RECORD
         orno  LIKE sfb_file.sfb01
      END RECORD
#FUN-D50098 ------End--------
  DEFINE l_slip LIKE sfb_file.sfb01   #00-12-26
 
DEFINE   l_max_no    LIKE sfb_file.sfb01         #No.MOD-960317 add
DEFINE   l_min_no    LIKE sfb_file.sfb01         #No.MOD-960317 add
DEFINE   g_chr           LIKE type_file.chr1     #No.FUN-680121 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680121 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680121 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680121 VARCHAR(72)
DEFINE   g_wc            STRING                  #FUN-920088
DEFINE   l_barcode_yn    LIKE ima_file.ima930    #DEV-D30026 add      #條碼使用否 

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function
 
   LET g_argv1  = ARG_VAL(1)
   LET g_argv2  = ARG_VAL(2)
   LET g_argv3  = ARG_VAL(3)
   IF cl_null(g_argv3) THEN
     LET g_argv3 = 'N'
   END IF
   LET g_bgjob  = ARG_VAL(4)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #No:MOD-A70028 add
   IF g_bgjob = 'N' THEN
      CALL p304_tm()
   ELSE
      LET g_oea.oea01 = g_argv1 CLIPPED
      LET g_sfb.sfb81 = TODAY
      CALL p304_fill_b_data(g_grup)
      LET g_success='Y'
      CALL asfp304()
      
      IF g_success='Y' THEN
         MESSAGE "Success!"
      END IF
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No:MOD-A70028 add
END MAIN
 
FUNCTION p304_tm()
   DEFINE   p_row,p_col,i    LIKE type_file.num5    #No.FUN-680121 SMALLINT
#  DEFINE   mm_qty,mm_qty1   LIKE ima_file.ima26    #No.FUN-680121 DEC(15,3)
   DEFINE   mm_qty,mm_qty1   LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE   l_cnt,s_date     LIKE type_file.num5    #No.FUN-680121 SMALLINT  
   DEFINE   l_time           LIKE ima_file.ima58    #No.FUN-680121 DEC(15,3)
   DEFINE   l_sfb08          LIKE sfb_file.sfb08
   DEFINE   l_flag           LIKE type_file.chr1                  #No.FUN-680121 VARCHAR(1)
   DEFINE   l_cn             LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE   l_ima55_fac      LIKE ima_file.ima55_fac
   DEFINE   l_check          LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE   l_ima59          LIKE ima_file.ima59
   DEFINE   l_ima61          LIKE ima_file.ima61
   DEFINE   l_oea00          LIKE oea_file.oea00    #No.MOD-940349 add
   DEFINE   l_costcenter     LIKE gem_file.gem01   #FUN-670103
   DEFINE   l_gem02c         LIKE gem_file.gem02   #FUN-670103
   DEFINE   l_err            LIKE type_file.chr1   #add by guanyao160608
 
   IF s_shut(0) THEN
      RETURN
   END IF
   LET p_row = 2 
   LET p_col = 4 
 
   IF s_industry('slk') THEN
     OPEN WINDOW p304_w AT p_row,p_col
        WITH FORM "asf/42f/asfp304_a"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
   ELSE
     OPEN WINDOW p304_w AT p_row,p_col
        WITH FORM "asf/42f/asfp304"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   END IF 
    
   CALL cl_ui_init()    
 
   CALL cl_set_comp_visible("ima910",g_sma.sma118='Y')
   IF g_aaz.aaz90='Y' THEN
      CALL cl_set_comp_required("gem01",TRUE)
   END IF
   CALL cl_set_comp_visible("costcenter,gem02c",g_aaz.aaz90='Y')
   CALL cl_set_comp_visible("sfb919,gb3",g_sma.sma1421='Y')  #FUN-A80102
   CALL cl_set_comp_visible("edc01,edc02",g_sma.sma541='Y')  #FUN-A80054
 
   CALL cl_opmsg('z')
 
   WHILE TRUE  #MOD-490189
 
   MESSAGE ''
   CLEAR FORM 
   INITIALIZE g_oea.* TO NULL
   INITIALIZE tm.*    TO NULL
   LET mm_qty=0   
   LET mm_qty1=0   
   LET sfc_sw='Y'
   LET lot=1   
   LET g_sw='N' 
   LET g_sfb.sfb81 = TODAY
   LET l_ima59=0
   LET l_ima60=0
   LET l_ima61=0
   LET tm.gem01=g_grup    #FUN-670103
   LET l_gem02c = ''                                              #FUN-920088
   SELECT gem02 INTO l_gem02c FROM gem_file WHERE gem01=tm.gem01  #FUN-920088
      AND gemacti='Y'                                             #FUN-920088
   IF s_industry('slk') THEN
      LET tm.sfb81 = g_today
      DISPLAY BY NAME tm.sfb81
      INPUT BY NAME tm.skd01,tm.sfb81,tm.sfc01,tm.bmb09  WITHOUT DEFAULTS   #No.FUN-870117 --add bmb09
      
      AFTER FIELD skd01
         IF NOT cl_null(tm.skd01) THEN
          LET l_cnt = 0
          SELECT COUNT(*) INTO l_cnt  FROM skd_file WHERE skd01=tm.skd01 AND skdacti='Y' AND skd04='Y'
            IF l_cnt <=0 THEN 
                   CALL cl_err(tm.skd01,'mfg420',0) 
                  NEXT FIELD skd01
            END IF
         ELSE
                  NEXT FIELD skd01
         END IF
         
      AFTER FIELD bmb09 
         IF NOT cl_null(tm.bmb09) THEN
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt FROM oeb_file,oebi_file,bmb_file
            WHERE oeb01= oebi01 and oeb04 = bmb01
              AND oebislk01 = tm.skd01 and bmb09 = tm.bmb09
              AND oeb03 = oebi03  
               IF l_cnt <=0 THEN 
                 CALL cl_err(tm.bmb09,'asf-402',0) 
                 NEXT FIELD bmb09
               END IF
         END IF 
         
      AFTER FIELD sfc01
         IF NOT cl_null(tm.sfc01) THEN
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt FROM sfc_file,sfci_file WHERE sfc01 = sfci01 AND sfc01=tm.sfc01 AND sfcislk01=tm.skd01 AND sfcislk05='Y' AND sfcacti='Y'
            IF l_cnt <=0 THEN 
                   CALL cl_err(tm.sfc01,'asf-401',0) 
                  NEXT FIELD sfc01
            END IF
         END IF  
      ON ACTION CONTROLP                  
            CASE
                WHEN INFIELD(skd01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_skd01"
                     LET g_qryparam.default1 = ''
                     CALL cl_create_qry() RETURNING tm.skd01 
                     DISPLAY BY NAME tm.skd01 
                     NEXT FIELD skd01
                WHEN INFIELD(sfc01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_sfc01"
                     LET g_qryparam.default1 = ''
                     LET g_qryparam.arg1 = tm.skd01
                     CALL cl_create_qry() RETURNING tm.sfc01 
                     DISPLAY BY NAME tm.sfc01 
                     NEXT FIELD sfc01
                WHEN INFIELD(bmb09)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bmb09"
                     LET g_qryparam.default1 = ''
                     LET g_qryparam.arg1 = tm.skd01
                     CALL cl_create_qry() RETURNING tm.bmb09 
                     DISPLAY BY NAME tm.bmb09 
                     NEXT FIELD bmb09
                OTHERWISE EXIT CASE
            END CASE
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
      
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         EXIT WHILE
      END IF
   ELSE
      IF tm.mac_opt IS NULL THEN LET tm.mac_opt='N' END IF #FUN-A80102
      DISPLAY BY NAME g_sfb.sfb81,tm.gem01 #FUN-670103 #FUN-650054 ,tm.wo_type
      DISPLAY BY NAME tm.mac_opt  #FUN-A80102
      DISPLAY l_gem02c TO gem02   #FUN-920088
 
      INPUT BY NAME g_sfb.sfb81,tm.gem01,tm.mac_opt WITHOUT DEFAULTS  #FUN-670103 #FUN-650054 ,tm.wo_type #FUN-920088  #FUN-A80102
 
        AFTER FIELD gem01
            IF NOT cl_null(tm.gem01) THEN
               IF g_aaz.aaz90='Y' THEN
                  IF NOT s_costcenter_chk(tm.gem01) THEN
                     LET tm.gem01=NULL
                     DISPLAY BY NAME tm.gem01
                     DISPLAY NULL TO FORMONLY.gem02
                     NEXT FIELD gem01
                  ELSE
                     DISPLAY s_costcenter_desc(tm.gem01) TO FORMONLY.gem02
                  END IF               
               ELSE
                  LET l_gem02c = ''
                  SELECT gem02 INTO l_gem02c FROM gem_file WHERE gem01=tm.gem01
                     AND gemacti='Y'
                  IF STATUS THEN
                     CALL cl_err3("sel","gem_file",tm.gem01,"",STATUS,"","select gem",1)
                     NEXT FIELD gem01 
                  END IF
                  DISPLAY l_gem02c TO gem02
               END IF
            END IF
        #TQC-C80187----add----begin
        AFTER INPUT
              IF INT_FLAG THEN
                 EXIT INPUT
              END IF
              IF NOT cl_null(tm.gem01) THEN
                 SELECT gem02 INTO l_gem02c FROM gem_file WHERE gem01=tm.gem01
                     AND gemacti='Y'
                  IF STATUS THEN
                     CALL cl_err3("sel","gem_file",tm.gem01,"",STATUS,"","select gem",1)
                     NEXT FIELD gem01
                  END IF   
              END IF  
        #TQC-C80187----add----end    
            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(gem01)
                      CALL cl_init_qry_var()
                      IF g_aaz.aaz90='Y' THEN
                         LET g_qryparam.form ="q_gem4"
                      ELSE
                         LET g_qryparam.form ="q_gem"
                      END IF
                      LET g_qryparam.default1 = tm.gem01
                      CALL cl_create_qry() RETURNING tm.gem01
                      DISPLAY BY NAME tm.gem01
                      NEXT FIELD gem01
                  OTHERWISE EXIT CASE
              END CASE
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

#TQC-A50129 --begin--         
         ON ACTION controlg
            CALL cl_cmdask()   
#TQC-A50129 --end--  
      
      END INPUT
      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
      CONSTRUCT BY NAME g_wc ON oea01,oea02,oea14,oea03
 
         BEFORE CONSTRUCT 
             CALL cl_qbe_init()
    
         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(oea01)
# HOT CODE....有問題請找saki
                 #CALL q_oea4(TRUE,TRUE,g_oea.oea01,' ')  #modify by guanyao160504
                 CALL cq_oea4(TRUE,TRUE,g_oea.oea01,' ')  #add by guanyao160504  #修改开窗，合约单号能够查询到
                 RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea01
                 NEXT FIELD oea01
              WHEN INFIELD(oea14)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gen" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret 
                 DISPLAY g_qryparam.multiret TO oea14
                 NEXT FIELD oea14
              WHEN INFIELD(oea03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c" 
                 LET g_qryparam.form ="q_occ3" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                          
                 DISPLAY g_qryparam.multiret TO oea03                                                                        
                 NEXT FIELD oea03  
            END CASE
          ON ACTION exit                                                                                                            
             LET INT_FLAG = 1                                                                                                       
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
 
          ON ACTION qbe_select
             CALL cl_qbe_select()
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup') #FUN-980030
      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
   END IF

   #str----add by guanyao160608
   IF g_wc = ' 1=1' THEN 
   ELSE 
      LET l_err = ''
      CALL p304_oea01_check() RETURNING l_err
      IF l_err= 'N' THEN 
         CONTINUE WHILE 
      END IF 
   END IF 
   #end---add by guanyao160608
      #將塞單身這段整個搬出成一個FUNCTION
      CALL p304_fill_b_data(tm.gem01)
            
      LET g_success='Y'
      LET g_flag='Y'
      CALL asfp304()
         CALL cl_confirm('lib-005') RETURNING l_flag
         IF l_flag THEN
            CONTINUE WHILE
         ELSE
            EXIT WHILE
         END IF
      ERROR ""
   END WHILE
 
   CLOSE WINDOW p304_w
 
END FUNCTION
 
FUNCTION p304_fill_b_data(p_gem01)
   DEFINE   p_gem01          LIKE gem_file.gem01
   DEFINE   l_cnt,s_date     LIKE type_file.num5    #No.FUN-680121 SMALLINT  
   DEFINE   l_time           LIKE ima_file.ima58    #No.FUN-680121 DEC(15,3)
   DEFINE   l_sfb08          LIKE sfb_file.sfb08
   DEFINE   l_flag           LIKE type_file.chr1                  #No.FUN-680121 VARCHAR(1)
   DEFINE   l_cn             LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE   l_ima55_fac      LIKE ima_file.ima55_fac
   DEFINE   l_check          LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE   l_ima59          LIKE ima_file.ima59
   DEFINE   l_ima61          LIKE ima_file.ima61
   DEFINE   l_costcenter     LIKE gem_file.gem01    #FUN-670103
   DEFINE   l_gem02c         LIKE gem_file.gem02    #FUN-670103
   DEFINE   li_result        LIKE type_file.num5    #No.TQC-730022
   DEFINE   l_oea00          LIKE oea_file.oea00    #FUN-920088
   DEFINE   l_smy57          LIKE smy_file.smy57    #FUN-A50066
   DEFINE   l_sql            STRING                 #FUN-A80102
   DEFINE   l_tmp            STRING                 #FUN-A80102
   DEFINE   l_snum,l_enum    STRING                 #FUN-A80102
   DEFINE   l_ssn,l_esn      LIKE type_file.num20   #FUN-A80102
   DEFINE   l_avg_oeb12,l_tol_oeb12,l_sum_oeb12  LIKE oeb_file.oeb12    #FUN-A80102
   DEFINE   l_ima54          LIKE ima_file.ima54    #MOD-AB0243 add
   DEFINE   l_ima08          LIKE ima_file.ima08    #MOD-AB0243 add
   DEFINE   tok1             base.StringTokenizer   #FUN-B20075
   DEFINE   l_token_cnt      LIKE type_file.num10   #FUN-B20075
   DEFINE   l_sfb919         LIKE sfb_file.sfb919   #FUN-B20075
   #CHI-B80044 -- begin --
   DEFINE   l_availqty       LIKE sfb_file.sfb08   #訂單可轉工單數量
   DEFINE   l_calc           LIKE type_file.num5   #計算生產批量倍數用
   DEFINE   l_allowqty       LIKE sfb_file.sfb08   #允許生產數量
   #CHI-B80044
   DEFINE l_oeb01            LIKE oeb_file.oeb01   #add by guanyao160730

      CALL new.clear()
      LET l_costcenter=s_costcenter(p_gem01) #FUN-670103
      LET l_gem02c=s_costcenter_desc(l_costcenter) #FUN-670103
     #MOD-C40193 str add------
      IF cl_null(g_wc) THEN
         LET g_wc= 'oeb01=',"'",g_argv1,"'"
      END IF
     #MOD-C40193 end add------
      IF s_industry('slk') THEN 
      LET g_sql = "SELECT 'Y',oeb01,oeb03,oebud04,oebud11,oeb04,ima02,ima021,'Y',ima94,oeb918,'',ima910,oeb12-oeb905,100,oeb12-oeb905,ceil((oeb12-oeb905)/imaud10),oeb919,NULL,oeb15, ",    #FUN-A50066 #FUN-A80102 #FUN-A80054   #No.FUN-940103 add ima021   #MOD-C50030 mark  #MOD-C70255 remark
     #LET g_sql = "SELECT 'Y',oeb01,oeb03,oeb04,ima02,ima021,'N','',oeb918,'',ima910,oeb12-oeb905-oeb24+oeb25,oeb919,NULL,oeb15, ",    #FUN-A50066 #FUN-A80102 #FUN-A80054   #No.FUN-940103 add ima021 #MOD-C50030  #MOD-C70255 mark
                  " '1',ima111,' ','Y',oeb930,'',oeb05,ima55,((100+ima562)/100),ima60,ima601 ",   #No.MOD-940205 add
                  " ,ima54,ima08 ",       #MOD-AB0243 add
                  " FROM oeb_file,ima_file,oebi_file,oea_file ",   #MOD-920243 add oea_file          
                  " WHERE oebislk01='",tm.skd01,"' ",
                  "  AND oeb01 = oebi01 ",
                  "  AND oeb03 = oebi03 ",
                  #"  AND oeb12>(oeb24-oeb25+oeb905) ",    #mark by guanyao160613
                  "   AND oeb12>(nvl(oebud07,0)+oeb905)",  #add by guanyao160613
                  "  AND oeb01 = oea01 ",       #MOD-920243 add
                  "  AND  oeb70 = 'N' ",   
                  "  AND (oeb907 != 'Y' or oeb907 is null)",  #add by zhangzs 201217
                  "  AND oeb04 = ima01 ",
                  #"  AND oea11 !=3",    #add by guanyao160505
              #    "  AND oea00 = '0'",   #add by guanyao160613 mark200908
                  "  AND oeb04 NOT LIKE 'MISC%' AND oeb04 NOT LIKE 'misc%' ",  #MOD-C30872
                  "  AND ima911<>'Y' ",
                  "  AND NOT EXISTS(SELECT * from sfb_file where sfb22= oeb01 and sfb221 =oeb03)"  #No.FUN-870117
      ELSE
      LET g_sql = "SELECT 'Y',oeb01,oeb03,oebud04,oebud11,oeb04,ima02,ima021,'Y',ima94,oeb918,'',ima910,oeb12-oeb905,100,oeb12-oeb905,CASE imaud10 WHEN 0 THEN 0 ELSE ceil((oeb12-oeb905)/imaud10) END,oeb919,NULL,oeb15, ",   #MOD-530799 add  #FUN-650193 add ima910  #FUN-A50066 #FUN-A80102 #FUN-A80054    #No.FUN-940103 add ima021   #MOD-C50030 mark #MOD-C70255 remark
     #LET g_sql = "SELECT 'Y',oeb01,oeb03,oeb04,ima02,ima021,'N','',oeb918,'',ima910,oeb12-oeb905-oeb24+oeb25,oeb919,NULL,oeb15, ",   #MOD-530799 add  #FUN-650193 add ima910  #FUN-A50066 #FUN-A80102 #FUN-A80054    #No.FUN-940103 add ima021 #MOD-C50030  #MOD-C70255 mark
                  #" '1',ima111,' ','Y',oeb930,'',oeb05,ima55,((100+ima562)/100),ima60,ima601 ",   #No.MOD-940205 add  #mark by guanyao160731
                  " '1','MRA',' ','Y',oeb930,'',oeb05,ima55,((100+ima562)/100),ima60,ima601 ",   #No.MOD-940205 add  #mod ima111 to MRA
                  " ,ima54,ima08 ",       #MOD-AB0243 add
                  " FROM oeb_file,ima_file,oea_file ",            #MOD-530799 add oeb05,ima55,ima562  #MOD-920243 add oea_file
                  " WHERE ", g_wc CLIPPED, #FUN-920088
                  #"  AND oeb12>(oeb24-oeb25+oeb905) ",   #FUN-570104 add oeb905
                  "   AND oeb12>(nvl(oebud07,0)+oeb905)",  #add by guanyao160613
                  "  AND oeb04 = ima01 ",
                  "  AND oeb01 = oea01 ",       #MOD-920243 add
                  "  AND  oeb70 = 'N' ",   
                  "  AND (oeb907 != 'Y' or oeb907 is null)",  #add by zhangzs 201217
                  #"  AND oea11 !=3",    #add by guanyao160505
               #   "  AND oea00 = '0'",   #add by guanyao160613 mark200908
                  "  AND oeb04 NOT LIKE 'MISC%' AND oeb04 NOT LIKE 'misc%' ",  #MOD-C30872
                  "  AND ima911<>'Y' "  #FUN-640083
      END IF
 
      #FUN-A80102(S)
      IF tm.mac_opt='Y' THEN  #將計畫批號拆解成號機
         DROP TABLE asfp304_tmp
         CREATE TEMP TABLE asfp304_tmp (
                x             LIKE type_file.chr1 ,
                oeb01         LIKE oeb_file.oeb01 ,
                oeb03         LIKE oeb_file.oeb03 ,
                oebud04       LIKE oeb_file.oebud04,  #add by guanyao160730
                oebud11       LIKE oeb_file.oebud11,  #add by guanyao160730
                new_part      LIKE ima_file.ima01 ,
                ima02         LIKE ima_file.ima02 ,
                ima021        LIKE ima_file.ima021,   #No.FUN-940103
                sfb93         LIKE sfb_file.sfb93 ,
                sfb06         LIKE sfb_file.sfb06 ,
                edc01         LIKE edc_file.edc01 , #FUN-A80054
                edc02         LIKE edc_file.edc02 , #FUN-A80054
                ima910        LIKE ima_file.ima910,
                new_qty       LIKE sfb_file.sfb08 ,
                sfb08_s       LIKE type_file.num15_3,   #add by guanyao160729
                sfb08_1       LIKE type_file.num15_3,   #add  by guanyao160806
                imaud10       LIKE ima_file.imaud10,    #add by guanyao160730
                sfb919        LIKE sfb_file.sfb919,
                b_date        LIKE type_file.dat  , 
                e_date        LIKE type_file.dat  , 
                sfb02         LIKE sfb_file.sfb02 ,
                new_no        LIKE oea_file.oea01 ,
                ven_no        LIKE pmc_file.pmc01 ,
                a             LIKE type_file.chr1 ,
                costcenter    LIKE gem_file.gem01 ,
                gem02c        LIKE gem_file.gem02 ,
                oeb05         LIKE oeb_file.oeb05 ,
                ima55         LIKE ima_file.ima55 ,
                ima562        LIKE ima_file.ima562,
                ima60         LIKE ima_file.ima60 ,
                ima601        LIKE ima_file.ima601,
                ima54         LIKE ima_file.ima54,      #MOD-AB0243 add  
                ima08         LIKE ima_file.ima08);     #MOD-AB0243 add 
         LET l_sql = " INSERT INTO asfp304_tmp " , g_sql
         PREPARE asfp304_tmp_p1 FROM l_sql
         EXECUTE asfp304_tmp_p1
         LET l_sql = "SELECT * FROM asfp304_tmp WHERE sfb919 LIKE '%-%'"
         PREPARE q_oeb_prepare1 FROM l_sql
         DECLARE oeb_curs1 CURSOR FOR q_oeb_prepare1
         LET g_i=1
         FOREACH oeb_curs1 INTO new[g_i].*,l_oeb05,l_ima55,l_ima562,l_ima60,l_ima601,l_ima54,l_ima08     #MOD-AB0243 add ima54,ima08
            IF new[g_i].sfb919 IS NULL THEN CONTINUE FOREACH END IF
            DELETE FROM asfp304_tmp WHERE oeb01 = new[g_i].oeb01 AND oeb03 = new[g_i].oeb03
            LET l_sfb919 = new[g_i].sfb919
            #FUN-B20075(S)
            LET tok1 = base.StringTokenizer.create(l_sfb919,",")
            WHILE tok1.hasMoreTokens()
               LET l_tmp = tok1.nextToken()
               LET l_tmp = l_tmp.trim()
               LET l_cnt = l_tmp.getindexof('-',1)
               IF l_cnt > 0 THEN
                  CALL s_machine_de_code(new[g_i].new_part,l_tmp) RETURNING l_snum,l_enum
                  LET l_ssn = l_snum
                  LET l_esn = l_enum
                  IF l_esn <= l_ssn THEN
                     CONTINUE FOREACH
                  END IF
                  LET l_sum_oeb12 = new[g_i].new_qty
                 #LET l_avg_oeb12 = s_trunc(l_sum_oeb12 / (l_esn - l_ssn + 1),0)  #FUN-B20075
                  LET l_avg_oeb12 = 1  #FUN-B20075
                  LET l_tol_oeb12 = 0
                 #LET new[g_i].new_qty = l_avg_oeb12 #FUN-B20075
                  FOR l_cnt = l_ssn TO l_esn
                     LET new[g_i].sfb919 = s_machine_en_code(new[g_i].new_part,l_cnt)
                     INSERT INTO asfp304_tmp VALUES (new[g_i].*,l_oeb05,l_ima55,l_ima562,l_ima60,l_ima601,l_ima54,l_ima08)  #TQC-B20161
                  END FOR
               #FUN-B20075(S)
               ELSE
                  IF l_tmp IS NOT NULL THEN
                     LET l_cnt = l_tmp
                     LET new[g_i].sfb919 = s_machine_en_code(new[g_i].new_part,l_cnt)
                     INSERT INTO asfp304_tmp VALUES (new[g_i].*,l_oeb05,l_ima55,l_ima562,l_ima60,l_ima601,l_ima54,l_ima08)  #TQC-B20161
                  END IF
               #FUN-B20075(E)
               END IF
            END WHILE
            #重計生產量
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM asfp304_tmp WHERE oeb01 = new[g_i].oeb01 AND oeb03 = new[g_i].oeb03
            IF l_cnt > 0 THEN
               LET l_avg_oeb12 = s_trunc(new[g_i].new_qty / l_cnt,0)
               IF l_avg_oeb12 = 0 THEN LET l_avg_oeb12 = 1 END IF
               UPDATE asfp304_tmp SET new_qty = l_avg_oeb12 WHERE oeb01 = new[g_i].oeb01 AND oeb03 = new[g_i].oeb03
               IF new[g_i].new_qty > (l_avg_oeb12 * l_cnt) THEN  #若有尾差,則攤入最後一筆
                  LET l_cn= 0 
                  SELECT COUNT(*) INTO l_cn  FROM asfp304_tmp 
                                            WHERE oeb01 = new[g_i].oeb01 
                                              AND oeb03 = new[g_i].oeb03
                                              AND sfb919 = new[g_i].sfb919
                  IF l_cn  = 1 THEN
                     LET new[g_i].new_qty = l_avg_oeb12 + new[g_i].new_qty - l_avg_oeb12 * l_cnt
                  ELSE
                     LET new[g_i].new_qty = l_avg_oeb12 + (new[g_i].new_qty - l_avg_oeb12 * l_cnt) / l_cn
                  END IF
                  UPDATE asfp304_tmp SET new_qty = new[g_i].new_qty 
                                   WHERE oeb01  = new[g_i].oeb01 
                                     AND oeb03  = new[g_i].oeb03
                                     AND sfb919 = new[g_i].sfb919
               END IF
            END IF
            #FUN-B20075(E)
            LET g_i=g_i+1
         END FOREACH
         LET g_sql = "SELECT * FROM asfp304_tmp ORDER BY oeb01,oeb03,sfb919" 
      END IF
      #FUN-A80102(E)
      PREPARE q_oeb_prepare FROM g_sql
      DECLARE oeb_curs CURSOR FOR q_oeb_prepare
      LET g_i=1
      CALL s_showmsg_init() #FUN-920088
       FOREACH oeb_curs INTO new[g_i].*,l_oeb05,l_ima55,l_ima562,l_ima60,l_ima601,l_ima54,l_ima08 #No:FUN-840194 add l_ima601  #CHI-810015拿掉,l_ima56  #FUN-710073 add  #MOD-530799 add   #MOD-AB0243 add l_ima54,l_ima08
  #FUN-B30463--add---begin
         IF g_sma.sma541 = 'N' THEN
            IF NOT cl_null(new[g_i].edc01) THEN
               LET new[g_i].edc01=''
            END IF
            IF NOT cl_null(new[g_i].edc02) THEN
               LET new[g_i].edc02=''
            END IF
         END IF
  #FUN-B30463--add--end       
         IF STATUS THEN
            EXIT FOREACH
         END IF
         #str-----add by guanyao160730
         LET l_oeb01 = ''
         SELECT substr(instr(new[g_i].oeb01,1,instr(new[g_i].oeb01,'-')-1)) INTO l_oeb01 FROM dual 
         IF l_oeb01 != 'SMT' THEN 
            LET new[g_i].oebud04 = ''
            LET new[g_i].oebud11 = ''
         END IF  
         #end-----add by guanyao160730
         #CHI-B80044 -- begin --
         SELECT * INTO g_ima.* FROM ima_file WHERE ima01 = new[g_i].new_part
         #CHI-B80044 -- end --
        #MOD-AB0243---modify---start---
        #IF s_industry('std') THEN         #FUN-920088
        #   LET new[g_i].ven_no = tm.gem01 #FUN-920088
        #END IF                            #FUN-920088
        #MOD-D40028---begin
        IF g_ima.ima140 = 'Y' AND g_ima.ima1401 < g_today THEN
           CALL s_errmsg('',new[g_i].new_part,'','aim-045',1)
           CONTINUE FOREACH
        END IF 
        #MOD-D40028---end
         IF l_ima08 = 'S' THEN
            LET new[g_i].sfb02 = '7'
            LET new[g_i].ven_no = l_ima54
         ELSE
            LET new[g_i].sfb02 = '1'
            IF s_industry('std') THEN
               LET new[g_i].ven_no = tm.gem01
            END IF
         END IF
        #MOD-AB0243---modify---end---
         #FUN-A50066--begin--add----------
         IF g_sma.sma54 = 'Y' THEN
            IF NOT cl_null(new[g_i].new_no) THEN
               SELECT smy57 INTO l_smy57 FROM smy_file
                WHERE smyslip = new[g_i].new_no
               LET new[g_i].sfb93 = l_smy57[1,1]
            END IF
         END IF
         IF new[g_i].sfb93 = 'Y' THEN
           #TQC-AC0243 -------------mod start----------------------------
           #SELECT DISTINCT bra011 INTO new[g_i].sfb06 FROM bra_file
           # WHERE bra01 = new[g_i].new_part
           #   AND bra014 = 'Y'
            SELECT ima94 INTO new[g_i].sfb06 FROM ima_file 
             WHERE ima01 = new[g_i].new_part  
           #TQC-AC0243 ------------mod end----------------------------------- 
             IF cl_null(new[g_i].sfb06) THEN
                DECLARE ecu02_c CURSOR FOR 
                   SELECT ecu02 FROM ecu_file
                    WHERE ecu01 = new[g_i].new_part
                      AND ecu10='Y' AND ecuacti = 'Y'
                      AND ecuacti = 'Y'  #CHI-C90006
                FOREACH ecu02_c INTO new[g_i].sfb06
                   EXIT FOREACH
                END FOREACH
             END IF
         END IF
         #FUN-A50066--end--add------------
         #FUN-A80054--begin--add-----------
         IF NOT cl_null(new[g_i].edc01) THEN
            LET new[g_i].edc02=''
            SELECT MIN(edb02) INTO new[g_i].edc02 FROM eda_file,edb_file
             WHERE edb03=new[g_i].new_part
               AND edb01=new[g_i].edc01
               AND edb04=new[g_i].sfb06
               AND edb01=eda01 AND edaconf='Y'
         END IF
         #FUN-A80054--end--add------------
         LET l_sfb08 = 0
       IF s_industry('std') THEN
          LET g_oea.oea01 = new[g_i].oeb01
        LET l_oea00 = NULL
        SELECT oea00 INTO l_oea00 FROM oea_file
         WHERE oea01 = g_oea.oea01
        IF l_oea00 = '4' THEN
           CALL s_errmsg('oea00',g_oea.oea01,'sel oea00','axm-155',1)
           CONTINUE FOREACH
        END IF
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt FROM oea_file
         WHERE oea01 = g_oea.oea01
           AND oeaconf = 'Y'
        IF l_cnt <=0 THEN 
       #   CALL s_errmsg('oea01',g_oea.oea01,'','asf-959',1)   #MOD-B30463
           CONTINUE FOREACH
        ELSE
        #str-----mark by guanyao160505
           #LET l_cnt = 0
           #SELECT COUNT(*) INTO l_cnt
           #  FROM oea_file
           # WHERE  oea00 <> '0' AND oea00 <> '4'  
           #   AND oeaconf = 'Y'
           #   AND oea01 = g_oea.oea01
           #IF l_cnt=0 THEN
           #   CALL s_errmsg('',g_oea.oea01,'','asf-005',1)
           #   CONTINUE FOREACH
           #END IF
        #end-----mark by guanyao160505
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt  FROM oeb_file
            WHERE oeb01 = g_oea.oea01
             # AND oeb12>(oeb24-oeb25+oeb905)   #oeb905:已備置量  #mark by guanyao160613
              AND oeb12>(nvl(oebud07,0)+oeb905)  #add by guanyao160613 
              AND oeb70 = 'N'    #No:MOD-970045 add
           IF l_cnt <=0 THEN   
              CALL s_errmsg('',g_oea.oea01,'','asf-962',1)
              CONTINUE FOREACH
           END IF
        END IF
       END IF
         IF NOT cl_null(g_argv2) THEN
            LET new[g_i].new_no = g_argv2 CLIPPED
            CALL s_check_no("asf",new[g_i].new_no,"","1","","","")  
            RETURNING li_result,new[g_i].new_no                                                  
         END IF
         CALL s_umfchk(new[g_i].new_part,l_oeb05,l_ima55)
                            RETURNING l_check,l_ima55_fac
         IF cl_null(l_ima55_fac) THEN 
            LET l_ima55_fac = 1
         END IF
         LET new[g_i].new_qty = new[g_i].new_qty * l_ima55_fac * l_ima562   #MOD-990224
         
         IF cl_null(new[g_i].sfb919) THEN   #FUN-A80102
            SELECT SUM(sfb08) INTO l_sfb08 FROM sfb_file
             WHERE sfb22  =  g_oea.oea01
               AND sfb221 =  new[g_i].oeb03 
              #AND (sfb04 <> '8' OR (sfb04 = '8' AND sfb08 = sfb09))   #MOD-530799  #MOD-CB0115 mark
               AND (sfb04 <> '8' OR (sfb04 = '8' AND sfb08 <= sfb09))  #MOD-CB0115
               AND sfb87!='X'
         #FUN-A80102(S)
         ELSE
            SELECT SUM(sfb08) INTO l_sfb08 FROM sfb_file
             WHERE sfb22  =  g_oea.oea01
               AND sfb221 =  new[g_i].oeb03 
               AND sfb919 =  new[g_i].sfb919 
              #AND (sfb04 <> '8' OR (sfb04 = '8' AND sfb08 = sfb09))   #MOD-530799  #MOD-CB0115 mark
               AND (sfb04 <> '8' OR (sfb04 = '8' AND sfb08 <= sfb09))  #MOD-CB0115
               AND sfb87!='X'
            END IF
         #FUN-A80102(E)
         IF l_sfb08 IS NULL THEN
            LET l_sfb08 = 0
         END IF
         IF l_sfb08 >= new[g_i].new_qty THEN
            CONTINUE FOREACH
         ELSE
            LET new[g_i].new_qty = new[g_i].new_qty - l_sfb08 
            LET l_allowqty = new[g_i].new_qty   #MOD-CC0162 move
            #CHI-B80044 -- begin --
            IF NOT cl_null(g_ima.ima56) AND g_ima.ima56 > 0 THEN
               LET l_calc = 0
              #LET l_allowqty = new[g_i].new_qty   #MOD-CC0162 mark
               IF new[g_i].new_qty MOD g_ima.ima56 > 0 THEN
                  LET l_calc = new[g_i].new_qty/g_ima.ima56 +1
                  LET l_allowqty = l_calc * g_ima.ima56
               END IF
            END IF
            LET new[g_i].new_qty = l_allowqty
            #CHI-B80044 -- end --
         END IF
##-計算開工日
         LET g_ima.ima62 = 0
          SELECT ima62,ima59,ima61 INTO g_ima.ima62,l_ima59,l_ima61 FROM ima_file #MOD-530799
          WHERE ima01 = new[g_i].new_part
         IF new[g_i].e_date IS NULL THEN
            LET new[g_i].e_date = 0
         END IF
      #mark by plum 010130
      #LET new[g_i].b_date = new[g_i].e_date - g_ima.ima62 units day
         #FUN-710073---mod---str---
         #LET l_time= (new[g_i].new_qty * l_ima60)+ l_ima59 + l_ima61  #No.FUN-840194 #CHI-810015 mark還原#MOD-530799
          LET l_time= (new[g_i].new_qty * l_ima60/l_ima601)+ l_ima59 + l_ima61 #No.FUN-840194  #CHI-810015 mark還原#MOD-530799
         #LET l_time= (new[g_i].new_qty * (l_ima60/l_ima56))+          #CHI-810015 mark 
         #            (l_ima59/l_ima56) + (l_ima61/l_ima56)            #CHI-810015 mark 
         #FUN-710073---mod---end---
 
         IF cl_null(l_time) THEN
            LET l_time=0
         END IF
         LET s_date=l_time+0.5
         IF cl_null(s_date) THEN
            LET s_date=0 
         END IF

        # CALL s_aday(new[g_i].e_date,-1,s_date) RETURNING new[g_i].b_date  #MOD-C50055 add  #mark by guanyao160730
 
      #MOD-C50055 mark begin-----------------------------
      #   LET new[g_i].b_date=new[g_i].e_date - s_date
 
      ##--MOD-530799 計算開工日時須扣掉非工作日
      #   SELECT COUNT(*) INTO l_cn FROM sme_file
      #      WHERE sme01 BETWEEN new[g_i].b_date AND new[g_i].e_date AND sme02 ='N'
      #   IF cl_null(l_cn) THEN
      #      LET l_cn=0
      #   END IF
      #   LET new[g_i].b_date = new[g_i].b_date - l_cn
      #MOD-C50055 mark end-------------------------------
 
         IF new[g_i].b_date < g_sfb.sfb81 THEN
            LET new[g_i].b_date = g_sfb.sfb81
         END IF
         LET new[g_i].b_date = g_today     #add by guanyao160730
         IF new[g_i].b_date > new[g_i].e_date THEN 
            LET new[g_i].e_date = new[g_i].b_date
         END IF
         
         LET new[g_i].gem02c=l_gem02c  #FUN-670103
         LET g_i=g_i+1
      END FOREACH
      CALL s_showmsg()    #FUN-920088
       CALL new.deleteElement(g_i)  #MOD-490189
      LET g_i=g_i-1
END FUNCTION

#TQC-AC0238   --start  
FUNCTION i304_new_no(i)             
   DEFINE i         LIKE type_file.num5
   DEFINE l_slip    LIKE smy_file.smyslip
   DEFINE l_smy73   LIKE smy_file.smy73    
   DEFINe l_cnt     LIKE type_file.num5    #DEV-D30026 add
 
   LET g_errno = ' '
   IF cl_null(new[i].new_no) THEN RETURN END IF
   LET l_slip = s_get_doc_no(new[i].new_no)
 
  #DEV-D30026 add str---------------------
   CALL p304_barcode_chk(new[i].new_part)
   IF l_barcode_yn = 'Y' THEN
      SELECT COUNT(*) INTO l_cnt
      FROM smy_file,smyb_file
      WHERE smy_file.smyslip = smyb_file.smybslip AND
            smy_file.smysys = 'asf' AND
            smy_file.smykind = '1' AND
           #smyb_file.smyb01 = '2' AND #DEV-D30037--mark
            smy_file.smyslip = l_slip
      IF l_cnt = 0 THEN
         CALL cl_err('','aba-134',1)
      END IF
   ELSE
  #DEV-D30026 add end---------------------
      SELECT smy73 INTO l_smy73 FROM smy_file
       WHERE smyslip = l_slip
      IF l_smy73 = 'Y' THEN
         LET g_errno = 'asf-875'
      END IF 
   END IF        #DEV-D30026 add
END FUNCTION
#TQC-AC0238   --end 
 
FUNCTION asfp304()
   DEFINE l_za05        LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(40)
   DEFINE l_sfb         RECORD LIKE sfb_file.*
   DEFINE l_sfc         RECORD LIKE sfc_file.*
   DEFINE l_sfd         RECORD LIKE sfd_file.*
   DEFINE l_minopseq    LIKE ecb_file.ecb03 
   DEFINE new_part      LIKE ima_file.ima01    #No.MOD-490217
   DEFINE i,j           LIKE type_file.num10   #No.FUN-680121 INTEGER
   DEFINE ask           LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE s_date        LIKE type_file.num5    #No.FUN-680121 SMALLINT  
   DEFINE l_time        LIKE ima_file.ima58    #No.FUN-680121 DEC(15,3)
   DEFINE l_item        LIKE ima_file.ima01
   DEFINE l_smy57       LIKE smy_file.smy57
   DEFINE l_smy73       LIKE smy_file.smy73    #TQC-AC0238
   DEFINE l_ima910      LIKE ima_file.ima910   #FUN-550112
   DEFINE   li_result   LIKE type_file.num5          #No.FUN-550067  #No.FUN-680121 SMALLINT
   DEFINE   l_max_no    LIKE sfb_file.sfb01         #No:MOD-950298 add
   DEFINE   l_min_no    LIKE sfb_file.sfb01         #No:MOD-950298 add
   DEFINE l_sfb08       LIKE sfb_file.sfb08
   DEFINE l_qty         LIKE oeb_file.oeb12
   DEFINE l_ima55_fac   LIKE ima_file.ima55_fac
   DEFINE l_check       LIKE type_file.num5     #No.FUN-680121 SMALLINT
   DEFINE l_cn          LIKE type_file.num5     #No.FUN-680121 SMALLINT
   DEFINE l_ima59       LIKE ima_file.ima59
   DEFINE l_ima61       LIKE ima_file.ima61
   DEFINE l_oeb15       LIKE oeb_file.oeb15     #FUN-640148 add
   DEFINE l_btflg       LIKE type_file.chr1     #FUN-650054
   DEFINE l_proc        LIKE type_file.chr1     #No.TQC-7B0031
   DEFINE l_sfbi        RECORD LIKE sfbi_file.* #No.FUN-7B0018
   DEFINE l_formid      LIKE oay_file.oayslip   #TQC-9B0181
   DEFINE l_ima571      LIKE ima_file.ima571    #FUN-A50066
   DEFINE l_cnt         LIKE type_file.num5     #FUN-A50066
   DEFINE l_sfc01       LIKE sfc_file.sfc01     #FUN-A80054
   DEFINE l_t1          LIKE oay_file.oayslip   #FUN-A80054
   DEFINE l_sfci        RECORD LIKE sfci_file.* #FUN-A80054
   DEFINE l_flag        LIKE type_file.chr1     #FUN-A80054
   DEFINE l_new_no1     STRING                  #MOD-AC0288
   DEFINE l_new_no      LIKE smy_file.smyslip   #MOD-AC0288
   DEFINE l_sfd01       LIKE sfd_file.sfd01     #FUN-B30035
   DEFINE l_ima56       LIKE ima_file.ima56     #TQC-B60323
   DEFINE l_ima561      LIKE ima_file.ima561    #TQC-B60323
   DEFINE l_qty1        LIKE sfb_file.sfb08     #TQC-B60323
   DEFINE l_qty2        LIKE ima_file.ima56     #TQC-B60323
   #CHI-B80044 -- begin --
   DEFINE l_availqty        LIKE sfb_file.sfb08   #訂單可轉工單數量
   DEFINE l_allowqty        LIKE sfb_file.sfb08   #允許生產數量
   DEFINE l_calc            LIKE type_file.num5   #計算生產批量倍數用
   #CHI-B80044 -- end --
   DEFINE l_i           LIKE type_file.num5   #FUN-C50052
  #MOD-C90048 add---S   
   DEFINE l_oeb41       LIKE oeb_file.oeb41,
          l_oeb42       LIKE oeb_file.oeb42,
          l_oeb43       LIKE oeb_file.oeb43,
          l_oeb1001     LIKE oeb_file.oeb1001
  #MOD-C90048 add---E
  #str----add by guanyao160504
  DEFINE l_oea00        LIKE oea_file.oea00
  DEFINE l_oebud07      LIKE oeb_file.oebud07
  DEFINE l_oebud09      LIKE oeb_file.oebud09  #add by guanyao160614
  #end----add by guanyao160504
  #str----add by guanyao160612
  DEFINE l_sfb08_1      LIKE sfb_file.sfb08
  DEFINE l_ima55_fac_1  LIKE ima_file.ima55_fac
  DEFINE l_ima562_1     LIKE ima_file.ima562
  #end----add by guanyao160612
  DEFINE l_imaud10      LIKE ima_file.imaud10 #add by guanyao160715
  DEFINE l_sfb18_f      LIKE type_file.num15_3   #add by guanyao160729
  DEFINE l_sfb08_t      LIKE sfb_file.sfb08   #add by guanyao160730
  DEFINE l_sfb08_o      LIKE sfb_file.sfb08   #add by guanyao160730
  DEFINE l_sfb08_s_t  LIKE sfb_file.sfb08   #add by guanyao160730

   WHILE TRUE
       LET g_flag='Y' #MOD-530283
   LET l_ima59=0
   LET l_ima60=0
   LET l_ima61=0
   #TQC-730022 如果是背景作業不再INPUT ARRAY

  #FUN-B30035--begin--add-----
   IF g_sma.sma541 = 'Y' THEN
      DROP TABLE sfd_tmp
      CREATE TEMP TABLE sfd_tmp(
        sfd01   LIKE sfc_file.sfc01)
      CREATE UNIQUE INDEX sfd_tmp_01 on sfd_tmp(sfd01);
   END IF
  #FUN-B30035--end--add-------

    IF g_bgjob = 'N' THEN #TQC-730022
      INPUT ARRAY new WITHOUT DEFAULTS FROM s_new.*
         ATTRIBUTE(COUNT=g_i,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE, APPEND ROW=FALSE)
 
         BEFORE INPUT                                            #TQC-C50223 add
            CALL cl_set_comp_required("b_date,e_date",TRUE)      #TQC-C50223 add

         BEFORE ROW       
            LET i=ARR_CURR()
            LET g_oea.oea01 = new[i].oeb01 #FUN-920088
            #FUN-A50066--begin--add------------
            IF cl_null(new[i].sfb93) THEN LET new[i].sfb93='N' END IF
            IF new[i].sfb93 = 'N' THEN LET new[i].sfb06='' END IF  #TQC-C70104 add 
            #TQC-C70104--mark--str--
            #IF new[i].sfb93 = 'Y' THEN
            #   CALL cl_set_comp_entry("sfb06",TRUE)
            #   CALL cl_set_comp_required("sfb06",TRUE)  
            #ELSE
            #   CALL cl_set_comp_required("sfb06",FALSE)
            #   CALL cl_set_comp_entry("sfb06",FALSE)
            #   LET new[i].sfb06='' 
            #END IF
            #TQC-C70104--mark--end--
            #FUN-A50066--end--add--------------          
            #TQC-C70104--add--str--
            LET l_sfb08_t = new[i].new_qty      #add by guanyao160730
            LET l_sfb08_o = new[i].new_qty      #add by guanyao160730
            LET l_sfb08_s_t = new[i].sfb08_s    #add by guanyao160730
            #str----add by guanyao160730
            LET l_imaud10 = ''
            SELECT imaud10 INTO l_imaud10 FROM ima_file WHERE ima01 = new[i].new_part
            IF cl_null(l_imaud10) OR l_imaud10 = 0 THEN 
               LET l_imaud10 = 1
            END IF 
            #end----add by guanyao160730
            CALL p304_set_entry_b()
            CALL p304_set_no_entry_b(i)
            CALL p304_set_no_required_b()
            CALL p304_set_required_b(i)
            #TQC-C70104--add--end--
               
            
         BEFORE INSERT
            LET new[i].sfb02='1'
            DISPLAY BY NAME new[i].sfb02
            #FUN-A50066--begin--add---------
            IF cl_null(new[i].sfb93) THEN
               LET new[i].sfb93 = 'N'
               DISPLAY BY NAME new[i].sfb93
            END IF
            #FUN-A50066--end--add----------
   
         #TQC-C70104--add--str--
         ON CHANGE x
            CALL p304_set_entry_b()
            CALL p304_set_no_entry_b(i)
            CALL p304_set_no_required_b()
            CALL p304_set_required_b(i)
         #TQC-C70104--add--end-- 

         AFTER FIELD x
            IF NOT cl_null(new_part) THEN
             IF new[i].x IS NULL OR (new[i].x != 'Y' AND new[i].x != 'N') THEN
               NEXT FIELD x
             END IF
            END IF
            IF new[i].x = 'Y' AND NOT cl_null(new[i].new_no[g_no_sp,g_no_sp]) THEN      #No.FUN-550067 
                     CALL cl_err('','asf-371','1')                                                                                 
            END IF

          AFTER FIELD ima910                                                                                                        
             IF NOT cl_null(new[i].ima910) THEN                                                                                     
              SELECT COUNT(*) INTO g_cnt FROM bma_file                                                                              
               WHERE bma06 = new[i].ima910                                                                                          
                 AND bma01 = new[i].new_part                                                                                        
                 AND bma05 IS NOT NULL AND bma05 <= g_sfb.sfb81                                                                     
              IF g_cnt = 0 THEN                                                                                                     
                 CALL cl_err(new[i].ima910,"abm-618",0)                                                                             
                 NEXT FIELD ima910                                                                                                  
              END IF                                                                                                                
           END IF 

         #str-------add by guanyao160729
         AFTER FIELD sfb08_s
            IF NOT cl_null(new[i].sfb08_s) AND ((l_sfb08_s_t!= new[i].sfb08_s)AND NOT cl_null(l_sfb08_s_t))THEN
              #str-----add by guanyao160806
              IF new[i].sfb08_s>100 OR new[i].sfb08_s<= 0 THEN 
                 CALL cl_err('','csf-068',0)
              END IF 
              #end-----add by guanyao160806
              IF NOT cl_null(new[i].new_qty) THEN
                 SELECT ceil((l_sfb08_t/(new[i].sfb08_s/100))/l_imaud10)*l_imaud10 INTO new[i].new_qty FROM dual 
                 DISPLAY BY NAME new[i].new_qty
                 LET new[i].imaud10= new[i].new_qty/l_imaud10
                 DISPLAY BY NAME new[i].imaud10
                 LET l_sfb08_s_t = new[i].sfb08_s
                 LET l_sfb08_t = new[i].new_qty
              END IF   
            END IF 
       # AFTER FIELD sfb08_f
       #    IF NOT cl_null(new[i].sfb08_f) THEN 
       #       IF new[i].sfb08_s<0 THEN 
       #          CALL cl_err('','csf-040',0)
       #          NEXT FIELD sfb08_f
       #       END IF 
       #       LET l_sfb18_f=''
       #       SELECT ceil(new[i].new_qty*(1+new[i].sfb08_s/100)/l_imaud10_1) INTO l_sfb18_f FROM dual 
       #       LET l_sfb18_f =l_sfb18_f*l_imaud10_1
       #       SELECT TRUNC(l_sfb18_f/new[i].sfb08_f) INTO l_y FROM dual 
       #       IF l_y MOD l_imaud10_1 > 0 THEN
       #          CALL cl_err('','csf-041',0) 
       #          NEXT FIELD sfb08_f
       #       ELSE 
       #          IF (l_sfb18_f-(new[i].sfb08_f-1)*l_y) MOD l_imaud10_1 > 0 THEN 
       #             CALL cl_err('','csf-041',0) 
       #             NEXT FIELD sfb08_f 
       #          END IF 
       #       END IF 
       #    END IF 
         #end-------add by guanyao160729         
 
         #FUN-A50066--begin--add------------
         #TQC-C70104--modify--str--
         #BEFORE FIELD sfb93
         #   CALL cl_set_comp_required("sfb06",FALSE)
         #   CALL cl_set_comp_entry("sfb06",TRUE)
         ON CHANGE sfb93
            CALL p304_set_entry_b()
            CALL p304_set_no_entry_b(i)
            CALL p304_set_no_required_b()
            CALL p304_set_required_b(i)              
         #TQC-C70104--modify--end--
            
         AFTER FIELD sfb93
             IF NOT cl_null(new[i].sfb93) THEN
                #TQC-C70104--modify--str--
                #IF new[i].sfb93 = 'Y' THEN
                #   CALL cl_set_comp_required("sfb06",TRUE)
                #ELSE
                #   CALL cl_set_comp_entry("sfb06",FALSE)
                #   LET new[i].sfb06=''
                #   DISPLAY BY NAME new[i].sfb06
                #END IF
                IF new[i].sfb93 <> 'Y' THEN
                   LET new[i].sfb06 = ''
                   DISPLAY BY NAME new[i].sfb06
                END IF   
                #TQC-C70104--modify--end-- 
             END IF
             
         AFTER FIELD sfb06
             IF NOT cl_null(new[i].sfb06) THEN
                SELECT ima571 INTO l_ima571 FROM ima_file WHERE ima01=new[i].new_part
                IF cl_null(l_ima571) THEN LET l_ima571=' ' END IF
                LET l_cnt = 0
                SELECT count(*) INTO l_cnt FROM ecu_file
                 WHERE (ecu01=l_ima571 OR ecu01=new[i].new_part)
                   AND ecu02 = new[i].sfb06
                   AND ecuacti = 'Y'  #CHI-C90006
                IF l_cnt = 0 THEN
                   CALL cl_err('','mfg4030',1)
                   NEXT FIELD sfb06
                END IF
                #FUN-B20085--begin--add-----
                CALL p304_chk_edb(new[i].edc01,new[i].new_part,new[i].sfb06)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('','aec-065',1)
                   NEXT FIELD sfb06
                END IF
                 CALL p304_edc02(new[i].edc01,new[i].edc02,new[i].new_part,new[i].sfb06)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(new[i].edc02,'aec-065',0)
                    NEXT FIELD sfb06
                 END IF
                #FUN-B20085--end--add-----
             END IF
        #FUN-A50066--end--add-----------------
                
        #FUN-A80054--begin--add---------------
        AFTER FIELD edc01
           IF NOT cl_null(new[i].edc01) THEN
             #FUN-B20085--begin--modify---    
             #LET l_cnt=0
             #SELECT COUNT(*) INTO l_cnt FROM eda_file,edb_file
             # WHERE eda01=new[i].edc01
             #   AND edb03=new[i].new_part
             #   AND edb04=new[i].sfb06
             #   AND eda01=edb01 AND edaconf='Y'
             #IF l_cnt = 0 THEN
             #   CALL cl_err('','aec-057',1)
             #   NEXT FIELD edc01
             #END IF
              CALL p304_chk_edb(new[i].edc01,new[i].new_part,new[i].sfb06)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD edc01
              END IF
             #FUN-B20085--end--modify------
              #TQC-B20161--begin--add----
              IF cl_null(new[i].edc02) THEN
                SELECT MIN(edb02) INTO new[i].edc02 FROM eda_file,edb_file
                 WHERE edb03=new[i].new_part
                   AND edb01=new[i].edc01
                   AND edb04=new[i].sfb06
                   AND edb01=eda01 AND edaconf='Y'
              END IF
              #TQC-B20161--end--add-----
              IF NOT cl_null(new[i].edc02) THEN
                 CALL p304_edc02(new[i].edc01,new[i].edc02,new[i].new_part,new[i].sfb06)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(new[i].edc02,'aec-057',0)
                    NEXT FIELD edc02
                 END IF
              END IF
           END IF 
                   
         AFTER FIELD edc02
            IF NOT cl_null(new[i].edc02) THEN
               CALL p304_edc02(new[i].edc01,new[i].edc02,new[i].new_part,new[i].sfb06)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(new[i].edc02,'aec-058',0)
                  NEXT FIELD edc02
               END IF
            END IF
         #FUN-A80054--end--add-----------

         BEFORE FIELD new_qty
            IF new[i].x = 'N' THEN
            END IF
   
         AFTER FIELD new_qty 
            IF new[i].new_qty IS NULL OR new[i].new_qty<0 THEN 
               NEXT FIELD new_qty 
            END IF
             #--MOD-530799 add    判斷工單數量是否大於訂單數量
            IF NOT cl_null(new[i].new_qty) THEN
               SELECT oeb12,oeb05,ima55,((ima562+100)/100) INTO l_qty,    #No.MOD-790028 modify
               l_oeb05,l_ima55,l_ima562
               FROM oeb_file,ima_file
               WHERE oeb01=g_oea.oea01 AND oeb03=new[i].oeb03
               AND oeb04 = ima01  #AND oeb19 != 'Y'   #FUN-570104 mark
              
               CALL s_umfchk(new[i].new_part,l_oeb05,l_ima55)
                    RETURNING l_check,l_ima55_fac
               IF cl_null(l_ima55_fac) THEN 
                  LET l_ima55_fac = 1
               END IF
               LET l_qty = l_qty * l_ima55_fac * l_ima562
               LET l_sfb08 = 0
               SELECT SUM(sfb08) INTO l_sfb08 FROM sfb_file
                WHERE sfb22  =  g_oea.oea01
                  AND sfb221 =  new[i].oeb03
                 #AND (sfb04 <> '8' OR (sfb04 = '8' AND sfb08 = sfb09))   #MOD-CB0115 mark
                  AND (sfb04 <> '8' OR (sfb04 = '8' AND sfb08 <= sfb09))  #MOD-CB0115
                  AND sfb87!='X'
               IF l_sfb08 IS NULL THEN
                  LET l_sfb08 = 0
               END IF
               LET l_qty = l_qty - l_sfb08
              #CHI-B80044 -- mark begin --
              #IF new[i].new_qty > l_qty THEN
              #   CALL cl_err('','asf-939',1)
              #   LET new[i].new_qty = l_qty
              #   NEXT FIELD new_qty
              #END IF
              #CHI-B80044 -- mark end --
               IF new[i].x = 'Y' THEN          #MOD-BA0006 add
                #TQC-B60323  --begin
                  SELECT ima561,ima56 INTO l_ima561,l_ima56 FROM ima_file WHERE ima01=new[i].new_part
                  IF l_ima561 > 0 THEN
                     IF new[i].new_qty < l_ima561 THEN
                        CALL cl_err(l_ima561,'asf-307',0)
                        NEXT FIELD new_qty
                     END IF
                  END IF
                  IF NOT cl_null(l_ima56) AND l_ima56>0  THEN
                     LET l_qty1 = new[i].new_qty * 1000
                     LET l_qty2 = l_ima56 * 1000
                     IF (l_qty1 MOD l_qty2) > 0 THEN
                        CALL cl_err(l_ima56,'asf-308',0)
                        NEXT FIELD new_qty
                     END IF
                     #CHI-B80044 -- begin --
                     LET l_calc = 0
                     LET l_allowqty = new[i].new_qty
                     IF l_qty MOD l_ima56 > 0 THEN
                        LET l_calc = l_qty/l_ima56 + 1
                        LET l_allowqty = l_calc * l_ima56
                     END IF
                     IF new[i].new_qty > l_allowqty THEN
                        CALL cl_err('','asf-358',1)
                        LET new[i].new_qty = l_allowqty
                        NEXT FIELD new_qty
                     END IF
                     #CHI-B80044 -- end --
                  END IF
                #TQC-B60323  --end
               END IF            #MOD-BA0006 add        
            END IF
            #CHI-B80044 -- begin --
            IF new[i].new_qty > l_qty THEN
               CALL cl_err('','asf-939',0)
            END IF
            #CHI-B80044 -- end --
            #str-----add by guanyao160730
            LET new[i].sfb08_1=new[i].new_qty     #add by guanyao160806
            IF new[i].new_qty!=l_sfb08_t THEN 
               IF NOT cl_null(new[i].sfb08_s) AND new[i].sfb08_s!=0 THEN 
                  SELECT ceil(new[i].new_qty/(new[i].sfb08_s/100)/l_imaud10)*l_imaud10 INTO new[i].new_qty FROM dual 
                  DISPLAY BY NAME new[i].new_qty
                  LET new[i].imaud10= new[i].new_qty/l_imaud10
                  DISPLAY BY NAME new[i].imaud10
               END IF 
               LET l_sfb08_t = new[i].new_qty
            END IF 
            #end-----add by guanyao160730
 
         BEFORE FIELD new_no  
            #TQC-C70104--mark--str--
            #IF new[i].x='N' THEN
            #   NEXT FIELD NEXT
            #END IF
            #TQC-C70104--mark--end--
            #增加顯示asf-382:"工單完工日與訂單預定交貨日不同!!"
            SELECT oeb15 INTO l_oeb15 FROM oeb_file
             WHERE oeb01 = g_oea.oea01 AND oeb03 = new[i].oeb03
            IF new[i].e_date != l_oeb15 THEN
               CALL cl_err('','asf-382',0)
            END IF
   
         AFTER FIELD new_no  
            LET i=ARR_CURR()
            #TQC-C70104--mark--str--
            #IF new[i].x='Y' THEN
            #   IF cl_null(new[i].new_no) THEN
            #      NEXT FIELD new_no
            #   END IF 
            #ELSE
            #   IF NOT cl_null(new[i].new_no) THEN
            #      NEXT FIELD new_no
            #   END IF 
            #END IF
            #TQC-C70104--mark--end--
            IF NOT cl_null(new[i].new_no) THEN  #TQC-C70104 add
              #TQC-AC0238   --start        
               CALL i304_new_no(i)          
               IF NOT cl_null(g_errno) THEN
                 CALL cl_err(new[i].new_no,g_errno,0)
                 LET  new[i].new_no = NULL
                 DISPLAY BY NAME new[i].new_no
                 NEXT FIELD new_no
               END IF                                                                  
              #TQC-AC0238   --end            
               CALL s_check_no("asf",new[i].new_no,"","1","","","")  
               RETURNING li_result,new[i].new_no                                                  
               DISPLAY BY NAME new[i].new_no                                                                                             
               IF (NOT li_result) THEN                                                                                                 
                  NEXT FIELD new_no
               END IF
               IF g_smy.smyauno='Y' AND NOT cl_null(new[i].new_no[g_no_sp,g_no_ep]) THEN    #No.FUN-550067    
                  NEXT FIELD new_no
               END IF
               DISPLAY new[i].new_no TO s_new[i].new_no
              #MOD-AC0288---add---start---
               LET l_new_no1=new[i].new_no
               LET l_new_no=l_new_no1.subString(1,g_doc_len)
               SELECT smy60 INTO new[i].costcenter FROM smy_file
                WHERE smyslip = l_new_no 
               DISPLAY new[i].costcenter TO s_new[i].costcenter
              #MOD-AC0288---add---end---
            END IF #TQC-C70104 add
           
         AFTER FIELD ven_no
            LET i=ARR_CURR()
            IF NOT cl_null(new[i].ven_no) THEN    #No.TQC-920104 add
                IF new[i].sfb02=1 THEN #FUN-650054
                  SELECT gem02 FROM gem_file
                   WHERE gem01=new[i].ven_no
                     AND gemacti = 'Y'
                  IF STATUS THEN
                     CALL cl_err3("sel","gem_file",new[i].ven_no,"",STATUS,"","sel gem:",1)    #No.FUN-660128
                     NEXT FIELD ven_no
                  END IF
               END IF
               IF new[i].sfb02=7 THEN #FUN-650054
                  SELECT pmc03 FROM pmc_file
                   WHERE pmc01=new[i].ven_no
                     AND pmcacti = 'Y'
                  IF STATUS THEN
                     CALL cl_err3("sel","pmc_file",new[i].ven_no,"",STATUS,"","sel pmc:",1)    #No.FUN-660128
                     NEXT FIELD ven_no
                  END IF
               END IF
            END IF
   
         AFTER FIELD b_date
            #TQC-C50223--modify--str--
            #IF new[i].b_date IS NULL OR (new[i].b_date < g_sfb.sfb81) THEN  
            #         CALL cl_err('','asf-372','1')                                                                                
#              ERROR '開工日為空白or小於工單日,請檢查!'                                                                             
            IF NOT cl_null(new[i].b_date) THEN          
               IF new[i].b_date < g_sfb.sfb81 THEN      
                  CALL cl_err('','asf-867','1')                                                                               
            #TQC-C50223--modify--end--
                  NEXT FIELD b_date
               END IF
               
               #TQC-C50223--add--str--
               IF NOT cl_null(new[i].e_date) AND new[i].e_date < new[i].b_date THEN
                  CALL cl_err('','asf-310','1')
                  NEXT FIELD b_date 
               END IF 
               #TQC-C50223--add--end-- 
               #MOD-C50055 add begin---------------------
               LET li_result = 0
               CALL s_daywk(new[i].b_date) RETURNING li_result
               IF li_result = 0 THEN      #0:非工作日
                  CALL cl_err(new[i].b_date,'mfg3152',1)
               END IF
               IF li_result = 2 THEN      #2:未設定
                  CALL cl_err(new[i].b_date,'mfg3153',1)
               END IF
               #MOD-C50055 add end-----------------------
            END IF
   
         AFTER FIELD e_date
            #TQC-C50223--modify--str--
            #IF new[i].e_date IS NULL OR (new[i].e_date < g_sfb.sfb81) THEN
            #         CALL cl_err('','asf-373','1')                                                                                 
#              ERROR '完工日為空白or小於工單日,請檢查!'                                                                             
            IF NOT cl_null(new[i].e_date) THEN
               IF new[i].e_date < g_sfb.sfb81 THEN
                  CALL cl_err('','asf-868','1')
            #TQC-C50223--modify--end--
                  NEXT FIELD e_date
               END IF
               IF new[i].e_date < new[i].b_date THEN
                        CALL cl_err('','asf-310','1')                                                                                 
#                 ERROR '完工日不能小於開工日,請檢查!'                                                                                 
                  NEXT FIELD e_date                                                                                                    
                  #NEXT FIELD e_date    #TQC-C50223 mark
               END IF 
               #MOD-C50055 add begin---------------------
               LET li_result = 0
               CALL s_daywk(new[i].e_date) RETURNING li_result
               IF li_result = 0 THEN      #0:非工作日
                  CALL cl_err(new[i].e_date,'mfg3152',1)
               END IF
               IF li_result = 2 THEN      #2:未設定
                  CALL cl_err(new[i].e_date,'mfg3153',1)
               END IF
               #MOD-C50055 add end-----------------------
            #str-------add by guanyao160730
            #   IF cl_confirm('asf-379') THEN
            #      #前置時間(l_time)=生產數量(sfb08)*變動前置時間(ima60)
            #      #if l_time <=7: 以7天計, >7:以照原值計,
            #      #預計開工日(sfb13): 預計完工日-l_time,但不可小於開單日期
            #      SELECT ima60,ima601,ima59,ima61 INTO l_ima60,l_ima601,l_ima59,l_ima61 FROM ima_file #No.FUN-840194 add ima601 #MOD-530799
            #       WHERE ima01 = new[i].new_part
            #      LET l_time=(new[i].new_qty * l_ima60/l_ima601)+l_ima59+l_ima61  #No.FUN-840194 #No.MOD-530799
            #      display "l_time:" ||l_time
            #      display "l_ima60:" ||l_ima60
            #      display "l_ima601:" ||l_ima601  #No.FUN-840194 
            #      display "l_ima59:" ||l_ima59
            #      display "l_ima61:" ||l_ima61
            #      display "new[i].new_qty:" ||new[i].new_qty
            #      IF cl_null(l_time) THEN
            #         LET l_time = 0
            #      END IF
            #      LET s_date=l_time+0.5
            #      IF cl_null(s_date) THEN
            #         LET s_date = 0
            #      END IF

            #     CALL s_aday(new[g_i].e_date,-1,s_date) RETURNING new[g_i].b_date  #MOD-C50055 add
  
            #     #MOD-C50055 mark begin-----------------------------
            #     # LET new[i].b_date=new[i].e_date - s_date
            #     # display "new[i].b_date:" ||new[i].b_date
            #     ##-- 計算開工日時須扣掉非工作日
            #     #  SELECT COUNT(*) INTO l_cn FROM sme_file 
            #     #     WHERE sme01 BETWEEN new[i].b_date AND new[i].e_date 
            #     #       AND sme02 = 'N'
            #     #  IF cl_null(l_cn) THEN
            #     #     LET l_cn=0 
            #     #  END IF
            #     #  LET new[i].b_date = new[i].b_date - l_cn
            #     #MOD-C50055 mark end-------------------------------
            #   END IF
            #end-------add by guanyao160730
 
               IF new[i].b_date IS NULL OR (new[i].b_date < g_sfb.sfb81) OR
                 (new[i].b_date > new[i].e_date) THEN
                  LET new[i].b_date=g_sfb.sfb81
               END IF
    
               DISPLAY new[i].b_date TO s_new[i].b_date 
            END IF
   
         AFTER FIELD a
            IF new[i].a IS NULL OR (new[i].a != 'Y' AND new[i].a != 'N') THEN
               NEXT FIELD a
            END IF
   
         AFTER FIELD costcenter 
            IF NOT s_costcenter_chk(new[i].costcenter) THEN
               NEXT FIELD costcenter
            ELSE
               LET new[i].gem02c=s_costcenter_desc(new[i].costcenter)
               DISPLAY BY NAME new[i].gem02c
            END IF
 
         AFTER ROW 
           #TQC-C70104--add--str--
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              LET g_success = 'N'
              RETURN
           END IF
           #TQC-C70104--add--end--
           #FUN-A50066--begin--add------
           LET i = ARR_CURR() 
           IF new[i].x = 'Y' THEN  #TQC-C70104 add 
              IF new[i].sfb93 = 'Y' THEN
                 IF cl_null(new[i].sfb06) THEN
                    NEXT FIELD sfb06
                 END IF
              END IF
           END IF
           #FUN-A50066--end--add--------
           #FUN-A80054--begin--add-----
           IF NOT cl_null(new[i].edc01) AND cl_null(new[i].edc02) THEN
              NEXT FIELD edc02
           END IF
           IF NOT cl_null(new[i].edc02) AND cl_null(new[i].edc01) THEN
              NEXT FIELD edc01
           END IF
           #FUN-A80054--end--add-------
   
         ON ACTION CONTROLP
            CASE 
               WHEN INFIELD(new_part) 
                  LET i=ARR_CURR()
#FUN-AA0059---------mod------------str-----------------                  
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ima"
#                  LET g_qryparam.default1 = new[i].new_part
#                  CALL cl_create_qry() RETURNING new[i].new_part
                   CALL q_sel_ima(FALSE, "q_ima","",new[i].new_part,"","","","","",'' ) 
                   RETURNING  new[i].new_part
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY new[i].new_part TO s_new[i].new_part 
                  NEXT FIELD new_part
              WHEN INFIELD(ima910)                                                                                                  
                 LET i=ARR_CURR()                                                                                                   
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form = "q_bma7"                                                                                     
                 LET g_qryparam.default1 = new[i].ima910                                                                            
                 LET g_qryparam.arg1 = new[i].new_part                                                                              
                 CALL cl_create_qry() RETURNING new[i].ima910                                                                       
                 DISPLAY new[i].ima910 TO s_new[i].ima910                                                                           
                 NEXT FIELD ima910                                                                                                  
               WHEN INFIELD(new_qty) 
                  LET i=ARR_CURR()
                  LET g_cmd = "aimq102"," '1' "," '",new[i].new_part,"' "
                  CALL cl_cmdrun(g_cmd CLIPPED)
               WHEN INFIELD(new_no)
                 #DEV-D30026 add str-----------------------
                  CALL p304_barcode_chk(new[i].new_part)
                  IF l_barcode_yn = 'Y' THEN
                     LET i=ARR_CURR()
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smyslip2"
                     LET g_qryparam.default1 = new[i].new_no
                     LET g_qryparam.arg1 = 'asf'
                     LET g_qryparam.arg2 = '1'
                     LET g_qryparam.arg3 = '2'
                     CALL cl_create_qry() RETURNING new[i].new_no
                     DISPLAY new[i].new_no TO s_new[i].new_no
                     NEXT FIELD new_no
                  ELSE
                    #DEV-D30026 add end---------------
                     LET i=ARR_CURR()
                     LET g_sql_smy = " (smy73 <> 'Y' OR smy73 is null)"  #TQC-AC0238
                     CALL smy_qry_set_par_where(g_sql_smy)               #TQC-AC0238
                     LET g_t1 = s_get_doc_no(new[i].new_no)              #No.TQC-AC0238
                     CALL q_smy(FALSE,FALSE,new[i].new_no,'ASF','1') RETURNING new[i].new_no  #TQC-670008
                 #   LET new[i].new_no=g_t1                              #No.TQC-AC0238
                     DISPLAY new[i].new_no TO s_new[i].new_no     
                     NEXT FIELD new_no
                  END IF                                              #DEV-D30026 add
               WHEN INFIELD(ven_no)
                  #CASE new[i].sfb02 #FUN-650054        #MOD-A30177 mark
                  #  WHEN '7'                           #MOD-A30177 mark
                   CASE                                 #MOD-A30177
                     WHEN new[i].sfb02 MATCHES '[78]'   #MOD-A30177
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_pmc"
                        LET g_qryparam.default1 = new[i].ven_no
                        CALL cl_create_qry() RETURNING new[i].ven_no
                     OTHERWISE
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_gem"
                        LET g_qryparam.default1 = new[i].ven_no
                        CALL cl_create_qry() RETURNING new[i].ven_no
                   END CASE
                   DISPLAY new[i].ven_no TO s_new[i].ven_no     
                   NEXT FIELD ven_no
               WHEN INFIELD(costcenter)
                    CALL cl_init_qry_var()
                    IF g_aaz.aaz90='Y' THEN
                       LET g_qryparam.form ="q_gem4"
                    ELSE
                       LET g_qryparam.form ="q_gem"
                    END IF
                    LET g_qryparam.default1 = new[i].costcenter
                    CALL cl_create_qry() RETURNING new[i].costcenter
                    DISPLAY BY NAME new[i].costcenter
                    NEXT FIELD costcenter
                #FUN-A50066--begin--add--------------
                WHEN INFIELD(sfb06) 
                  LET i=ARR_CURR()
                  SELECT ima571 INTO l_ima571 FROM ima_file WHERE ima01=new[i].new_part
                  IF cl_null(l_ima571) THEN LET l_ima571=' ' END IF
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ecu_a"
                  LET g_qryparam.default1 = new[i].sfb06
                  LET g_qryparam.arg1 = l_ima571
                  LET g_qryparam.arg1 = new[i].new_part
                  CALL cl_create_qry() RETURNING new[i].sfb06
                  DISPLAY new[i].sfb06 TO sfb06 
                  NEXT FIELD sfb06
                #FUN-A50066--end--add----------------
                #FUN-A80054--begin--add-------------
                WHEN INFIELD(edc01) OR INFIELD(edc02) 
                  LET i=ARR_CURR()
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_edc"
                  LET g_qryparam.default1 = new[i].edc01
                  LET g_qryparam.default2 = new[i].edc02
                  LET g_qryparam.where = " edb03='",new[i].new_part,"' AND edb04='",new[i].sfb06,"' "
                  CALL cl_create_qry() RETURNING new[i].edc01,new[i].edc02
                  DISPLAY new[i].edc01 TO edc01
                  DISPLAY new[i].edc02 TO edc02
                  NEXT FIELD CURRENT
                #FUN-A80054--end--add--------------------
               OTHERWISE EXIT CASE 
             END CASE
   
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
         #FUN-C50052---begin
         ON ACTION ALL
            FOR l_i = 1 TO new.getLength()
               LET new[l_i].x = 'Y'
            END FOR
         ON ACTION no_all
            FOR l_i = 1 TO new.getLength()
               LET new[l_i].x = 'N'
            END FOR
         #FUN-C50052---end
      END INPUT
   
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_success = 'N'
         RETURN
      END IF
   END IF  #TQC-730022 add   
 
      LET l_proc = 'N'
      # 檢查單身
      FOR i = 1 TO new.getLength()
         #TQC-C80187--------begin--------
         IF NOT cl_null(new[i].ven_no) THEN    
            SELECT gem02 FROM gem_file
             WHERE gem01=new[i].ven_no
               AND gemacti = 'Y'
            IF STATUS THEN
               LET g_flag = 'N'
               CALL cl_err3("sel","gem_file",new[i].ven_no,"",STATUS,"","sel gem:",1)    
               EXIT FOR
            END IF
         END IF
         #TQC-C80187-------end---------       
         IF new[i].x = 'Y' AND cl_null(new[i].new_no) THEN
            LET g_flag = 'N'
            CALL cl_err('','asf-380','1')                                                                                           
#           ERROR "尚未完成工單編號"                                                                                                
            EXIT FOR
         END IF
         IF new[i].x = 'Y' THEN
            LET l_proc = 'Y'
         END IF
         IF new[i].x = 'Y' THEN          #MOD-BA0006 add
          #TQC-B60323  --begin
           SELECT ima561,ima56 INTO l_ima561,l_ima56 FROM ima_file 
            WHERE ima01 = new[i].new_part
           IF l_ima561 > 0 THEN
              IF new[i].new_qty < l_ima561 THEN
                 LET g_flag = 'N'
                 CALL cl_err(l_ima561,'asf-307',1)
                 EXIT FOR
              END IF
           END IF
           IF NOT cl_null(l_ima56) AND l_ima56>0  THEN
              LET l_qty1 = new[i].new_qty * 1000
              LET l_qty2 = l_ima56 * 1000
              IF (l_qty1 MOD l_qty2) > 0 THEN
                 LET g_flag = 'N'
                 CALL cl_err(l_ima56,'asf-308',1)
                 EXIT FOR
              END IF
              #CHI-B80044 -- begin --
              IF l_qty > 0 THEN
                 LET l_calc = 0
                 LET l_allowqty = new[i].new_qty
                 IF l_availqty MOD l_ima56 > 0 THEN
                    LET l_calc = l_availqty/l_ima56 + 1
                    LET l_allowqty = l_calc * l_ima56
                 END IF
                 IF g_sfb.sfb08 > l_allowqty THEN
                    CALL cl_err('','asf-358',1)
                    EXIT FOR
                 END IF
              END IF
              #CHI-B80044 -- end --
           END IF
          #TQC-B60323  --end
         END IF            #MOD-BA0006 add
      END FOR 
   
      IF g_flag= 'N' THEN
         CONTINUE WHILE
      END IF
 
      IF l_proc = 'N' THEN
         EXIT WHILE
      END IF
   
      IF g_bgjob = 'N' THEN  #TQC-730022
        IF NOT cl_sure(19,0) THEN
           RETURN
        END IF
      END IF
   
      CALL cl_wait()
    # 陣列列印資料
      CALL s_showmsg_init() #FUN-920088
      BEGIN WORK    #add by guanyao160730
      FOR i=1 TO new.getLength()
         #BEGIN WORK #mark by guanyao160730
         LET g_success = 'Y'   #No.MOD-960317
         IF cl_null(new[i].new_part) THEN
            EXIT FOR
         END IF
         IF cl_null(new[i].new_no) THEN 
            CONTINUE FOR
         END IF
         IF cl_null(new[i].new_qty) THEN
            CONTINUE FOR
         END IF
         IF new[i].x = 'N' THEN
            CONTINUE FOR
         END IF
         IF new[i].new_qty = 0 THEN
            CONTINUE FOR
         END IF
   
         INITIALIZE l_sfb.* TO NULL
  
         IF cl_null(new[i].new_no[g_no_sp,g_no_ep]) THEN
           CALL s_auto_assign_no("asf",new[i].new_no,g_sfb.sfb81,"","","","","","")
                RETURNING li_result,new[i].new_no                                                                                            
           IF (NOT li_result) THEN                                    
              CALL s_errmsg('smyslip',new[i].new_no,'s_auto_assign_no','asf-963',1) 
              LET g_success='N'
            END IF    #有問題
         END IF   
   
         LET l_sfb.sfb01 = new[i].new_no
         LET l_sfb.sfb02 = new[i].sfb02 #FUN-650054
         LET l_sfb.sfb04 = '1'
         LET l_sfb.sfb05 = new[i].new_part
        #先不給"製程編號"(sfb06)，到後面再根據sfb93判斷要不要給值
         SELECT ima35,ima36,ima571
           INTO l_sfb.sfb30,l_sfb.sfb31,l_item
           FROM ima_file
          WHERE ima01=l_sfb.sfb05 AND imaacti= 'Y'
   
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('ima01',l_sfb.sfb05,'select ima35','aom-198',1)
            LET g_success = 'N'
         END IF
         IF cl_null(l_item) THEN LET l_item=l_sfb.sfb05 END IF #TQC-AB0136
 
         LET l_ima910=new[i].ima910
         IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
         #FUN-A50066--begin--add-------------------
         LET l_cnt = 0
         IF NOT cl_null(new[i].sfb06) AND g_sma.sma542 = 'Y' THEN
            SELECT count(*) INTO l_cnt FROM bra_file
             WHERE bra01=l_sfb.sfb05
               AND bra05 IS NOT NULL
               AND bra05 <=g_sfb.sfb81
               AND bra06 = l_ima910 
               AND bra011 = new[i].sfb06
               AND braacti = 'Y'      
        #ELSE  #FUN-B20075
         #FUN-A50066--end--add------------------
         END IF  #FUN-B20075
         IF l_cnt = 0 THEN  #FUN-B20075
            SELECT count(*) INTO l_cnt FROM bma_file  #FUN-A50066
             WHERE bma01=l_sfb.sfb05
               AND bma05 IS NOT NULL
               AND bma05 <=g_sfb.sfb81
               AND bma06 = l_ima910   #FUN-550112
               AND bmaacti = 'Y'      #CHI-740001
         END IF  #FUN-A50066
   
         IF l_cnt = 0 THEN   #FUN-A50066
            IF l_sfb.sfb02!='5' AND l_sfb.sfb02!='8' AND l_sfb.sfb02!='11' THEN    #MOD-AB0063 add
               CALL s_errmsg('bom',l_sfb.sfb05,'select bom','mfg5071',1)
               LET g_success = 'N'
            END IF                     #MOD-AB0063 add
         END IF
   
         #--(1)產生工單檔(sfb_file)---------------------------
        #Mod FUN-B20060
        #LET l_sfb.sfb071= g_sfb.sfb81
         SELECT oeb72 INTO l_sfb.sfb071 FROM oeb_file
          WHERE oeb01 = new[i].oeb01
            AND oeb03 = new[i].oeb03
         IF cl_null(l_sfb.sfb071) THEN
           #LET l_sfb.sfb071= g_sfb.sfb81    #MOD-C80127 mark
            LET l_sfb.sfb071= g_today        #MOD-C80127 add
         END IF
        #End Mod FUN-B20060
         LET l_sfb.sfbud09 = new[i].sfb08_s   #add by huanglf170316
         LET l_sfb.sfbud08 = new[i].sfb08_1   #add by guanyao160806
         LET l_sfb.sfb08 = new[i].new_qty
         LET l_sfb.sfb081= 0
         LET l_sfb.sfb09 = 0
         LET l_sfb.sfb10 = 0
         LET l_sfb.sfb11 = 0
         LET l_sfb.sfb111= 0
         LET l_sfb.sfb121= 0
         LET l_sfb.sfb122= 0 
         LET l_sfb.sfb12 = 0
         LET l_sfb.sfb13 = g_today
         LET l_sfb.sfb15 = g_today
         LET l_sfb.sfb23 = 'Y' #FUN-650054
         LET l_sfb.sfb24 = 'N'
         LET l_sfb.sfb251= g_sfb.sfb81
         LET l_sfb.sfb22 = new[i].oeb01                                                                                           
         LET l_sfb.sfb221= new[i].oeb03 
         LET l_sfb.sfb27 = ' '    #No.MOD-480184
         LET l_sfb.sfb29 = 'Y'
         LET l_sfb.sfb39 = '1'
         LET l_sfb.sfb81 = g_sfb.sfb81
         LET l_sfb.sfb82 = new[i].ven_no
         LET l_sfb.sfb85 = ' '    #No.MOD-480184
         LET l_sfb.sfb86 = ' '    #No.MOD-480184
         LET l_sfb.sfb89 = ' '    #FUN-C30114
         LET l_sfb.sfb87 = 'N'
         LET l_sfb.sfb91 = ' '    #No.MOD-480184
         LET l_sfb.sfb92 = NULL   #MOD-530402
         LET l_sfb.sfb87 = 'N'    #97/08/21 modify
         LET l_sfb.sfb41 = 'N'
         LET l_sfb.sfb44 = g_user #FUN-920088
         LET l_sfb.sfb919=new[i].sfb919   #FUN-A80102<p align="center"></p>
         LET l_formid = s_get_doc_no(new[i].new_no)
        #MOD-C90048---S---
         SELECT oeb41,oeb42,oeb43,oeb1001 INTO l_oeb41,l_oeb42,l_oeb43,l_oeb1001
           FROM oeb_file
          WHERE oeb01 = g_oea.oea01
         LET l_sfb.sfb27 = l_oeb41
         LET l_sfb.sfb271= l_oeb42
         LET l_sfb.sfb50 = l_oeb43
         LET l_sfb.sfb51 = l_oeb1001 
        #MOD-C90048---E--- 
         SELECT smyapr INTO l_sfb.sfbmksg FROM smy_file
          WHERE smyslip=l_formid
         LET l_sfb.sfb43 = '0'    #FUN-920088
         IF l_sfb.sfb02='11' THEN #拆件式工單=>sfb99='Y'
            LET l_sfb.sfb99 = 'Y'
         ELSE
            LET l_sfb.sfb99 = 'N'
         END IF
         LET l_sfb.sfb85= tm.sfc01 #No.FUN-810014
         LET l_sfb.sfb17 = NULL   #TQC-7A0065
         LET l_sfb.sfb95=l_ima910
         LET l_sfb.sfb98 ='B12'   #new[i].costcenter #FUN-670103
         LET l_sfb.sfbacti = 'Y'
         LET l_sfb.sfbuser = g_user
         LET l_sfb.sfbgrup = g_grup
         LET l_sfb.sfbdate = g_today
         LET l_sfb.sfb1002='N' #保稅核銷否 #FUN-6B0044
 
         LET l_sfb.sfbplant = g_plant #FUN-980008 add
         LET l_sfb.sfblegal = g_legal #FUN-980008 add
   
         LET l_slip = s_get_doc_no(l_sfb.sfb01)     #No.FUN-550067     
         SELECT smy57 INTO l_smy57 FROM smy_file WHERE smyslip=l_slip
        #LET l_sfb.sfb93 = l_smy57[1,1]  #FUN-A50066
         LET l_sfb.sfb93 = new[i].sfb93  #FUN-A50066
         LET l_sfb.sfb94 = l_smy57[2,2]
        #IF l_sfb.sfb93='Y' AND (  #FUN-A50066
         IF NOT cl_null(new[i].sfb06) AND ( #FUN-A50066
            l_sfb.sfb02!='7' AND l_sfb.sfb02!='8' AND l_sfb.sfb02!='15') THEN
            #SELECT ima94 INTO l_sfb.sfb06 FROM ima_file  #FUN-A50066
            # WHERE ima01=l_sfb.sfb05 AND imaacti= 'Y'    #FUN-A50066
            LET l_sfb.sfb06 = new[i].sfb06                #FUN-A50066
         END IF
   
#CHI-B80053 -- begin --
         IF cl_null(l_sfb.sfb98) THEN
            SELECT ima34 INTO l_sfb.sfb98 FROM ima_file
             WHERE ima01 = l_sfb.sfb05
         END IF
#CHI-B80053 -- end --

         LET l_sfb.sfboriu = g_user      #No.FUN-980030 10/01/04
         LET l_sfb.sfborig = g_grup      #No.FUN-980030 10/01/04

         #MOD-A40002 start---
         SELECT oeb1001,oeb22 INTO l_sfb.sfb51,l_sfb.sfb07 FROM oeb_file   #TQC-B60189  add oeb22
           WHERE oeb01 = l_sfb.sfb22
             AND oeb03 = l_sfb.sfb221
         #MOD-A40002 end---

         #MOD-A90067 add --start--
         IF l_smy57[5,5] = 'Y' THEN
            SELECT oeb908 INTO l_sfb.sfb97 FROM oeb_file
             WHERE oeb01 = l_sfb.sfb22
               AND oeb03 = l_sfb.sfb221
         END IF
         #MOD-A90067 add --end--

         LET l_sfb.sfb104 = 'N'    #TQC-A50087 add
         #str----add by guanyao160715
         LET l_imaud10 = ''
         SELECT imaud10 INTO l_imaud10 FROM ima_file WHERE ima01 = l_sfb.sfb05
         IF cl_null(l_imaud10) OR l_imaud10 = 0 THEN 
            LET l_sfb.sfbud07 =l_sfb.sfb08
         ELSE 
            LET l_sfb.sfbud07 = l_sfb.sfb08/l_imaud10
         END IF 
         #end----add by guanyao160715
         #str----add by guanyao160929
         LET l_sfb.sfbud10 = l_imaud10  
         IF cl_null(l_sfb.sfbud10) OR l_sfb.sfbud10 = 0 THEN 
            LET l_sfb.sfbud10 = 1
         END IF 
         #end----add by guanyao160929
         
        LET  l_sfb.sfb98='B12'   #成本中心默认为B12 addly170912
         INSERT INTO sfb_file VALUES(l_sfb.*)
         IF SQLCA.SQLCODE THEN
            CALL s_errmsg('sfb05',l_sfb.sfb05,'insert sfb','asf-738',1)
            LET g_success='N'   
            LET new[i].new_no=null
         END IF
         #str---add by guanyao160504合约订单返回已转工单数
         LET l_oea00 = ''
         LET l_oebud07 = 0 
         SELECT oea00 INTO l_oea00 FROM oea_file WHERE oea01 = l_sfb.sfb22
         IF l_oea00 = '0'  OR l_oea00='1' THEN  #mark200908 addoea00=1
            #str----add by guanyao160612
            LET l_ima562_1 = 0
            LET l_ima55_fac_1=0
            SELECT ima55_fac,((ima562+100)/100) INTO l_ima55_fac_1,l_ima562_1 FROM ima_file WHERE ima01 = l_sfb.sfb05
            IF cl_null(l_ima55_fac_1) OR l_ima55_fac_1 = 0 THEN 
               LET l_ima55_fac_1 = 1
            END IF
            IF cl_null(l_ima562_1) THEN 
               LET l_ima562_1 = 1
            END IF 
            LET l_sfb08_1 = new[i].sfb08_1*l_ima55_fac_1/l_ima562_1
            #end----add by guanyao160612
            SELECT oebud07,oebud09 INTO l_oebud07,l_oebud09 FROM oeb_file   #add oebud08 by guanyao160614
             WHERE oeb01 = l_sfb.sfb22
               AND oeb03 = l_sfb.sfb221
            IF cl_null(l_oebud07) THEN 
               LET l_oebud07 = 0
            END IF 
            IF cl_null(l_oebud09) THEN LET l_oebud09 =0 END IF 
            UPDATE oeb_file 
               SET oebud07 = (l_oebud07+l_sfb08_1),
                   oebud09 = l_oebud09-l_sfb08_1  #add by guanyao160614
             WHERE oeb01 = l_sfb.sfb22
               AND oeb03 = l_sfb.sfb221
            IF SQLCA.SQLCODE THEN
               CALL s_errmsg('oebud07',l_oebud07+l_sfb.sfb08,'update oeb','',1)
               LET g_success='N'   
               LET new[i].new_no=NULL
            END IF
         END IF 
         #end---add by guanyao160504
         IF NOT s_industry('std') THEN
            INITIALIZE l_sfbi.* TO NULL
            LET l_sfbi.sfbi01 = l_sfb.sfb01
            IF NOT s_ins_sfbi(l_sfbi.*,'') THEN
               LET g_success='N'
               LET new[i].new_no = NULL
            END IF
         END IF
         IF s_industry('slk') AND cl_null(new[i].edc01) THEN  #FUN-A80054
          #FUN-A80054--begin--add------------
          LET l_sfc.sfc01=tm.sfc01 
          LET l_sfc.sfcuser=g_user
          LET l_sfc.sfcgrup=g_grup
          LET l_sfc.sfcdate=g_today
          LET l_sfc.sfcacti='Y'
          LET l_sfc.sfcoriu=g_user
          LET l_sfc.sfcorig=g_grup
          INSERT INTO sfc_file VALUES(l_sfc.*)
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('sfc01',tm.sfc01,'insert sfc',SQLCA.sqlcode,1)
             LET g_success = 'N'
          END IF
          IF NOT s_industry('std') THEN
             INITIALIZE l_sfci.* TO NULL
             LET l_sfci.sfci01 = l_sfc.sfc01 
            #Mod No.MOD-B30028
            #LET l_flag = s_ins_sfci(l_sfci.*,'')
             SELECT COUNT(*) INTO l_cnt FROM sfci_file
              WHERE sfci01 = l_sfci.sfci01
             IF l_cnt = 0 THEN
                LET l_flag = s_ins_sfci(l_sfci.*,'')
             END IF
            #End Mod No.MOD-B30028
          END IF
          #FUN-A80054--end--add-----------
          SELECT MAX(sfd02)+1 INTO g_i FROM sfd_file WHERE sfd01 = tm.sfc01              #No.FUN-870117
          IF cl_null(g_i) THEN  LET g_i = 1 END IF                                       #No.FUN-870117
          #INSERT INTO sfd_file(sfd01,sfd02,sfd03,sfdconf)  VALUES(tm.sfc01,g_i,new[i].new_no,'N')    #No.FUN-870117 #FUN-A80054 #CHI-C60023
          INSERT INTO sfd_file(sfd01,sfd02,sfd03,sfdconf,sfd09)  VALUES(tm.sfc01,g_i,new[i].new_no,'N','2')  #CHI-C60023
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('sfd01',tm.sfc01,'insert sfb',SQLCA.sqlcode,1)
             LET g_success = 'N'
          ELSE
             MESSAGE 'INSERT O.K'            
          END IF
         END IF
         IF l_sfb.sfb93='Y' THEN
            CALL s_schdat(0,l_sfb.sfb13,l_sfb.sfb15,l_sfb.sfb071,l_sfb.sfb01,
                          l_sfb.sfb06,l_sfb.sfb02,l_item,l_sfb.sfb08,2)
               RETURNING g_cnt,l_sfb.sfb13,l_sfb.sfb15,l_sfb.sfb32,l_sfb.sfb24
         END IF
         LET l_sfb.sfb13=g_today
         LET l_sfb.sfb15=g_today
 
         IF l_sfb.sfb24 IS NOT NULL THEN
            UPDATE sfb_file
               SET sfb24= l_sfb.sfb24 
             WHERE sfb01=l_sfb.sfb01 
            IF SQLCA.sqlcode THEN 
               CALL s_errmsg('sfb05',l_sfb.sfb05,'update sfb',SQLCA.sqlcode,1)
               LET g_success='N' 
            END IF
         END IF
   
         #-->(2)產生備料檔
         LET l_minopseq=0
         
         CALL s_minopseq(l_sfb.sfb05,l_sfb.sfb06,l_sfb.sfb071) RETURNING l_minopseq
         
         CASE
            WHEN l_sfb.sfb02='1' OR l_sfb.sfb02='7' #一般工單 or 委外工單 (保留原本asfp304的處理方式)
               LET l_minopseq = 0
               IF s_industry('slk') AND l_sfb.sfb02='1' AND NOT cl_null(tm.bmb09) THEN   
                 CALL s_cralc5(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,l_btflg,
                              l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,l_sfb.sfb95,tm.bmb09)
                    RETURNING g_cnt
               ELSE
                #CALL s_cralc4(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y',
                 CALL s_cralc(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y',  #FUN-BC0008 mod
                               l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,
                               new[i].a,l_sfb.sfb95)
                 RETURNING g_cnt
               END IF                       #No.FUN-870117
               
            WHEN l_sfb.sfb02='13'     #預測工單展至尾階
               CALL s_cralc2(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y',
                             l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,
                             ' 1=1',l_sfb.sfb95)
               RETURNING g_cnt
            WHEN l_sfb.sfb02='15'     #試產性工單
               CALL s_cralc3(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y',
                             l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,
                             l_sfb.sfb07,g_sma.sma883,l_sfb.sfb95)
               RETURNING g_cnt
            OTHERWISE                 #一般工單展單階
               IF l_sfb.sfb02 = 11 THEN
                  LET l_btflg = 'N'
               ELSE
                  LET l_btflg = 'Y'
               END IF
               CALL s_cralc(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,l_btflg,
                           #l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,l_sfb.sfb95)
                            l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,'',l_sfb.sfb95)  #FUN-BC0008 mod
                  RETURNING g_cnt
         END CASE
         IF g_cnt = 0 THEN
             CALL s_errmsg('sfb05',l_sfb.sfb05,'s_cralc error','asf-385',1)
             LET g_success = 'N' 
             LET new[i].new_no=null
         END IF
         #FUN-A80054--begin--add------------------------------
         IF g_sma.sma541 = 'Y' THEN  #FUN-B30035
            IF NOT cl_null(new[i].edc01) AND NOT cl_null(new[i].edc02) THEN
              #FUN-B30035--begin--add-------
              DECLARE sfd_cs1 CURSOR FOR
               SELECT sfd01 FROM sfd_tmp
              LET l_sfd01=''  LET l_sfd.sfd01=''
              FOREACH sfd_cs1 INTO l_sfd01
                 LET l_cnt = 0
                 SELECT COUNT(*) INTO l_cnt FROM sfd_file WHERE sfd01=l_sfd01 AND sfd08=new[i].edc01 AND sfdconf='N'
                 IF l_cnt > 0 THEN
                    LET l_sfd.sfd01=l_sfd01
                    EXIT FOREACH
                 END IF
              END FOREACH 
              #FUN-B30035--end--add-------
              #FUN-B30035--begin--mark-----
              #DECLARE sfd_cs CURSOR FOR
              # SELECT sfd01 FROM sfd_file WHERE sfd08=new[i].edc01 AND sfdconf='N' ORDER BY sfd01
              #LET l_sfc01=''
              #FOREACH sfd_cs INTO l_sfc01
              #  EXIT FOREACH
              #END FOREACH
              #IF NOT cl_null(l_sfc01) THEN
              #   LET l_sfd.sfd01=l_sfc01
              #ELSE 
              #FUN-B30035--end--mark-----
               IF cl_null(l_sfd.sfd01) THEN  #FUN-B30035
                  LET l_t1=s_get_doc_no(new[i].edc01) 
                  SELECT smy75 INTO l_sfd.sfd01 FROM smy_file
                   WHERE smyslip=l_t1
                  IF cl_null(l_sfd.sfd01) THEN 
                     CALL s_errmsg('smy75',l_t1,'sel smy','aec-060',1)
                     LET g_success='N' 
                     LET new[i].new_no=null
                  END IF
                  CALL s_auto_assign_no("asf",l_sfd.sfd01,g_today,"8","sfd_file","sfd01","","","") 
                  RETURNING li_result,l_sfd.sfd01                                                                                               
                  IF (NOT li_result) THEN                                                                                                     
                     LET g_success='N'
                     LET new[i].new_no=null
                  END IF
                  IF NOT cl_null(l_sfd.sfd01) THEN
                     LET l_sfc.sfc01=l_sfd.sfd01
                     LET l_sfc.sfcuser=g_user
                     LET l_sfc.sfcgrup=g_grup
                     LET l_sfc.sfcdate=g_today
                     LET l_sfc.sfcacti='Y'
                     LET l_sfc.sfcoriu=g_user
                     LET l_sfc.sfcorig=g_grup
                     INSERT INTO sfc_file VALUES(l_sfc.*)
                     IF SQLCA.sqlcode THEN 
                        CALL s_errmsg('sfc01',l_sfc.sfc01,'ins sfc',SQLCA.sqlcode,1)
                        LET g_success='N' 
                        LET new[i].new_no=null
                     END IF
                     IF NOT s_industry('std') THEN
                        INITIALIZE l_sfci.* TO NULL
                        LET l_sfci.sfci01 = l_sfc.sfc01 
                        LET l_flag = s_ins_sfci(l_sfci.*,'')
                       #Mod No.MOD-B30028
                       #LET l_flag = s_ins_sfci(l_sfci.*,'')
                        SELECT COUNT(*) INTO l_cnt FROM sfci_file
                         WHERE sfci01 = l_sfci.sfci01
                        IF l_cnt = 0 THEN
                           LET l_flag = s_ins_sfci(l_sfci.*,'')
                        END IF
                       #End Mod No.MOD-B30028
                     END IF
                     IF g_sma.sma541 = 'Y' THEN #FUN-B30035
                        INSERT INTO sfd_tmp VALUES(l_sfc.sfc01) #FUN-B30035
                     END IF  #FUN-B30035
                  END IF
               END IF  
               IF NOT cl_null(l_sfd.sfd01) THEN
                  SELECT MAX(sfd02)+1 INTO l_sfd.sfd02 FROM sfd_file WHERE sfd01=l_sfd.sfd01
                  IF cl_null(l_sfd.sfd02) THEN LET l_sfd.sfd02 = 1 END IF
                  LET l_sfd.sfd03=new[i].new_no
                  LET l_sfd.sfd08=new[i].edc01
                  LET l_sfd.sfd04=new[i].edc02
                  LET l_sfd.sfd09 = '2'  #CHI-C60023
                  LET l_sfd.sfdconf='N'
                  LET  l_sfd.sfduser = g_user        #FUN-D10127
                  LET  l_sfd.sfdgrup = g_grup        #FUN-D10127
                  LET  l_sfd.sfddate = g_today       #FUN-D10127
                  LET  l_sfd.sfdacti ='Y'            #FUN-D10127
                  LET  l_sfd.sfdoriu = g_user        #FUN-D10127
                  LET  l_sfd.sfdorig = g_grup        #FUN-D10127
                  SELECT edb05,edb07 INTO l_sfd.sfd05,l_sfd.sfd07
                    FROM edb_file
                   WHERE edb01=new[i].edc01
                     AND edb02=new[i].edc02
                  INSERT INTO sfd_file VALUES(l_sfd.*)
                  IF SQLCA.sqlcode THEN 
                     CALL s_errmsg('sfd01',l_sfd.sfd01,'ins sfd',SQLCA.sqlcode,1)
                     LET g_success='N' 
                     LET new[i].new_no=null
                  END IF
                  SELECT sum(sfd05) INTO l_sfd.sfd06 FROM sfd_file WHERE sfd01=l_sfd.sfd01
                  UPDATE sfd_file SET sfd06=l_sfd.sfd06 WHERE sfd01=l_sfd.sfd01
                  UPDATE sfb_file SET sfb85=l_sfd.sfd01 WHERE sfb01=l_sfb.sfb01
                  IF g_success='Y' THEN
                     CALL p304_ins_edg(l_sfd.sfd01,l_sfd.sfd02,l_sfd.sfd03,new[i].edc01,new[i].edc02)
                     IF g_success='N' THEN LET new[i].new_no=null END IF
                     IF g_success = 'Y' THEN
                        CALL p304_ins_edh(l_sfd.sfd01,l_sfd.sfd02,new[i].edc01,new[i].edc02)
                        IF g_success='N' THEN LET new[i].new_no=null END IF
                     END IF
                  END IF
               END IF
            END IF
         END IF  #FUN-B30035
         #FUN-A80054--end--add------------------------------------
       #FUN-D50098 ---------Begin---------
        #IF g_success='Y' THEN
        #   COMMIT WORK
        #ELSE
        #   LET new[i].new_no=null  #TQC-B60133
        #   ROLLBACK WORK
        #END IF
       #FUN-D50098 ---------End-----------
         #判斷sfb02若為'5，11'時不產生子工單
         IF l_sfb.sfb02 != '5' AND l_sfb.sfb02 != '11' THEN
         #FUN-D50098 ------Begin-------
           #LET g_msg="asfp301 '",l_sfb.sfb01,"' '",   # for top40
           #           l_sfb.sfb81,"' '99' 'N'"
           #CALL cl_cmdrun_wait(g_msg)
            IF new[i].a = 'Y' THEN
               CALL p301(l_sfb.sfb01, l_sfb.sfb81, 99, 'N', TRUE)
            END IF
         #FUN-D50098 ------End---------
         END IF

         CALL p304_chk_sfb39(l_sfb.sfb01)       #CHI-C50029 add 
 
      END FOR
      CALL s_showmsg()    #No.MOD-960317

   #FUN-D50098 ---------Begin----------
      IF g_success = 'Y' THEN
         COMMIT WORK
         # 将成功生成的工单号显示出来
         LET g_sql = "SELECT * FROM p304_tmp ORDER BY orno"
         DECLARE p304_orno CURSOR FROM g_sql
         LET i = 1
         FOREACH p304_orno INTO l_max_no
            LET mg[i] = l_max_no
            LET i = i + 1
         END FOREACH
         CALL cl_get_feldname('sfb01', g_lang) RETURNING g_msg
         CALL cl_show_array(base.TypeInfo.CREATE(mg), g_msg, g_msg)
      ELSE
         ROLLBACK WORK
         RETURN           #TQC-DA0029 add
      END IF
      DROP TABLE p304_tmp
   #FUN-D50098 ---------End------------
   
      ERROR ""
      IF g_sma.sma541 = 'Y' THEN  DROP TABLE sfd_bmp END IF  #FUN-B30035
   
      LET l_max_no = ''  #TQC-C70031 add
      LET l_min_no = ''  #TQC-C70031 add
      FOR i=1 TO new.getLength()    #一笔资料可以拆成多笔转订单显示的时候将new换成new1
         #TQC-C70031--modify--str--
         #IF i = 1 THEN
         #   LET l_max_no = new[i].new_no
         #   LET l_min_no = new[i].new_no
         #END IF
         IF new[i].x = 'N' THEN
            CONTINUE FOR
         END IF
         IF cl_null(l_max_no) AND cl_null(l_min_no) THEN
            LET l_max_no = new[i].new_no
            LET l_min_no = new[i].new_no
         END IF
         #TQC-C70031--modify--end--
         IF cl_null(l_max_no) THEN LET l_max_no = ' ' END IF    #MOD-B40215 add
         IF new[i].new_no > l_max_no THEN LET l_max_no = new[i].new_no END IF
         IF cl_null(l_min_no) THEN LET l_min_no = l_max_no END IF    #MOD-B40215 add
         IF new[i].new_no < l_min_no THEN LET l_min_no = new[i].new_no END IF
         #TQC-C70002 add 用子工單更新l_min_no、l_max_no
         IF NOT cl_null(new[i].new_no) THEN                                     
            CALL p304_sub_no(new[i].new_no,l_min_no,l_max_no) RETURNING l_min_no,l_max_no
         END IF 
         #TQC-C70002 add 
         IF cl_null(new[i].new_part) THEN EXIT FOR END IF 
         DISPLAY new[i].new_no TO s_new[i].new_no 
      END FOR
 
       LET i = new.getLength()  
       #TQC-B60133--begin--add-
       IF cl_null(l_max_no) AND cl_null(l_min_no) THEN
          CALL cl_err('','asf-196',1)
       ELSE
       #TQC-B60133--end--add
         #MOD-B40215---modify---start---
         #LET g_msg = l_min_no CLIPPED,"~",l_max_no
          IF cl_null(l_min_no) THEN
             LET g_msg = l_max_no CLIPPED
          ELSE
             IF cl_null(l_max_no) THEN
                LET g_msg = l_min_no CLIPPED
             ELSE
                LET g_msg = l_min_no CLIPPED,"~",l_max_no
             END IF
          END IF
         #MOD-B40215---modify---end---
          CALL cl_err(g_msg,'mfg0101',1) 
       END IF  #TQC-B60133
       #處理自動過帳部份
        IF g_argv3 = 'Y' THEN
          FOR i = 1 TO new.getLength() 
             CALL i301sub_firm1_chk(l_sfb.sfb01,FALSE)  #CALL原確認的check段  #No.FUN-950021
             IF g_success = 'Y' THEN
                CALL i301sub_firm1_upd(l_sfb.sfb01,"confirm",FALSE)  #CALL原確認的update段  #No.FUN-950021
             END IF
          END FOR
        END IF
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION p304_get_head()
   DEFINE p_sfb04      LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE l_str        LIKE type_file.chr20   #No.FUN-680121 VARCHAR(10)
 
   SELECT * INTO g_oea.* FROM oea_file
    WHERE oea01 = g_oea.oea01
      AND oeaconf = 'Y'
 
   SELECT gen02 INTO tm.gen02 FROM gen_file
    WHERE gen01 = g_oea.oea14
 
   DISPLAY BY NAME g_oea.oea01,g_oea.oea02,g_oea.oea14,tm.gen02,
                   g_oea.oea03,g_oea.oea032
END FUNCTION

#FUN-A80054--begin--add---------------------
FUNCTION p304_edc02(p_edc01,p_edc02,p_sfb05,p_sfb06)
DEFINE l_cnt    LIKE type_file.num5
DEFINE p_edc01  LIKE edc_file.edc01
DEFINE p_edc02  LIKE edc_file.edc02
DEFINE p_sfb05  LIKE sfb_file.sfb05
DEFINE p_sfb06  LIKE sfb_file.sfb06

  LET l_cnt=0
  LET g_errno=''
  IF cl_null(p_edc01) OR cl_null(p_edc02) OR cl_null(p_sfb05) OR cl_null(p_sfb06) THEN RETURN END IF  #FUN-B20085
  SELECT COUNT(*) INTO l_cnt FROM eda_file,edb_file 
   WHERE edb01=p_edc01 
     AND edb02=p_edc02
     AND edb03=p_sfb05 
     AND edb04=p_sfb06
     AND eda01=edb01 AND edaconf='Y'
  IF l_cnt=0 THEN LET g_errno='aec-058' END IF

END FUNCTION

FUNCTION p304_ins_edg(p_sfd01,p_sfd02,p_sfd03,p_edc01,p_edc02)
DEFINE p_sfd01    LIKE sfd_file.sfd01
DEFINE p_sfd02    LIKE sfd_file.sfd02
DEFINE p_sfd03    LIKE sfd_file.sfd03
DEFINE p_edc01    LIKE edc_file.edc01
DEFINE p_edc02    LIKE edc_file.edc02
DEFINE l_edg      RECORD LIKE edg_file.*
DEFINE l_edc      RECORD LIKE edc_file.*
#FUN-A80060--begin--add------------------
DEFINE p_strtdat       LIKE type_file.dat,
       p_duedat        LIKE type_file.dat,
       w_bdate,w_edate LIKE type_file.dat,
       w_day           LIKE type_file.num5, 
       w_flag          LIKE type_file.chr1,
       l_sfb13         LIKE sfb_file.sfb13,
       l_sfb15         LIKE sfb_file.sfb15
#FUN-A80060--end--add------------------

    DECLARE edc_cs CURSOR FOR
      SELECT * FROM edc_file WHERE edc01=p_edc01 AND edc02=p_edc02 ORDER BY edc03
    FOREACH edc_cs INTO l_edc.*
      LET l_edg.edg01 =p_sfd01
      LET l_edg.edg02 =p_sfd02
      LET l_edg.edg03 =l_edc.edc03   
      LET l_edg.edg04 =l_edc.edc04  
      LET l_edg.edg05 =l_edc.edc05  
      LET l_edg.edg06 =l_edc.edc06  
      LET l_edg.edg07 =l_edc.edc07  
      LET l_edg.edg08 =l_edc.edc08  
      LET l_edg.edg09 =l_edc.edc09  
      LET l_edg.edg10 =l_edc.edc10    
      LET l_edg.edg12 =l_edc.edc12  
      LET l_edg.edg121=l_edc.edc121 
      LET l_edg.edg13 =l_edc.edc13  
      LET l_edg.edg14 =l_edc.edc14  
      LET l_edg.edg15 =l_edc.edc15  
      LET l_edg.edg16 =l_edc.edc16  
      LET l_edg.edg17 =l_edc.edc17  
      LET l_edg.edg18 =l_edc.edc18  
      LET l_edg.edg19 =l_edc.edc19  
      LET l_edg.edg20 =l_edc.edc20  
      LET l_edg.edg21 =l_edc.edc21  
      LET l_edg.edg22 =l_edc.edc22  
      LET l_edg.edg23 =l_edc.edc23  
      LET l_edg.edg24 =l_edc.edc24  
      LET l_edg.edg25 =l_edc.edc25  
      LET l_edg.edg26 =l_edc.edc26  
      LET l_edg.edg27 =l_edc.edc27  
      LET l_edg.edg28 =l_edc.edc28  
      LET l_edg.edg291=l_edc.edc291 
      LET l_edg.edg292=l_edc.edc292 
      LET l_edg.edg301=l_edc.edc301 
      LET l_edg.edg302=l_edc.edc302 
      LET l_edg.edg303=l_edc.edc303 
      LET l_edg.edg311=l_edc.edc311 
      LET l_edg.edg312=l_edc.edc312 
      LET l_edg.edg313=l_edc.edc313 
      LET l_edg.edg314=l_edc.edc314 
      LET l_edg.edg315=l_edc.edc315 
      LET l_edg.edg316=l_edc.edc316 
      LET l_edg.edg321=l_edc.edc321 
      LET l_edg.edg322=l_edc.edc322 
      LET l_edg.edg34 =l_edc.edc34  
      LET l_edg.edg35 =l_edc.edc35  
      LET l_edg.edg36 =l_edc.edc36  
      LET l_edg.edg37 =l_edc.edc37  
      LET l_edg.edg38 =l_edc.edc38  
      LET l_edg.edg39 =l_edc.edc39  
      LET l_edg.edg40 =l_edc.edc40  
      LET l_edg.edg41 =l_edc.edc41  
      LET l_edg.edg42 =l_edc.edc42  
      LET l_edg.edg43 =l_edc.edc43  
      LET l_edg.edg45 =l_edc.edc45  
      LET l_edg.edg49 =l_edc.edc49  
     #LET l_edg.edg50 =l_edc.edc50  #FUN-A80060
     #LET l_edg.edg51 =l_edc.edc51  #FUN-A80060
      LET l_edg.edg52 =l_edc.edc52  
      LET l_edg.edg53 =l_edc.edc53  
      LET l_edg.edg54 =l_edc.edc54  
      LET l_edg.edg55 =l_edc.edc55  
      LET l_edg.edg56 =l_edc.edc56  
      LET l_edg.edg57 =l_edc.edc57  
      LET l_edg.edg58 =l_edc.edc58  
      LET l_edg.edg59 =l_edc.edc59  
      LET l_edg.edg60 =l_edc.edc60  
      LET l_edg.edg61 =l_edc.edc61  
      LET l_edg.edg62 =l_edc.edc62  
      LET l_edg.edg63 =l_edc.edc63  
      LET l_edg.edg64 =l_edc.edc64  
      LET l_edg.edg65 =l_edc.edc65  
      LET l_edg.edg66 =l_edc.edc66  
      LET l_edg.edg67 =l_edc.edc67  
      LET l_edg.edgslk01=l_edc.edcslk01
      LET l_edg.edgslk02=l_edc.edcslk02
      LET l_edg.edgslk03=l_edc.edcslk03
      LET l_edg.edgslk04=l_edc.edcslk04 
      LET l_edg.edgconf='N'
      LET l_edg.edguser=g_user
      LET l_edg.edgdate=g_today
      LET l_edg.edgacti='Y'
      LET l_edg.edgmodu=null
      LET l_edg.edggrup=g_grup
      LET l_edg.edgorig=g_grup
      LET l_edg.edgoriu=g_user
      
      SELECT sfb05,sfb06,sfb13,sfb15                  #FUN-A80060
        INTO l_edg.edg031,l_edg.edg11,l_sfb13,l_sfb15 #FUN-A80060  
        FROM sfb_file
       WHERE sfb01=p_sfd03
       #FUN-A80060--begin--add----------------
      IF NOT cl_null(l_sfb13) AND cl_null(l_sfb15) THEN
         LET w_day=(l_edg.edg14+l_edg.edg13)/86400 +0.99    # 一天86400秒
         CALL s_wknxt(l_sfb13,w_day) RETURNING w_flag,w_edate
         IF w_day != 0 THEN
            CALL s_wknxt(w_edate,-1) RETURNING w_flag,p_duedat
         ELSE
            CALL s_wknxt(w_edate,0) RETURNING w_flag,p_duedat
         END IF
         LET l_edg.edg50=l_sfb13  LET l_edg.edg51=p_duedat
      ELSE
         LET w_day=((l_edg.edg14+l_edg.edg13)/86400 +0.99)*-1    # 一天86400秒
         CALL s_wknxt(l_sfb15,w_day) RETURNING w_flag,w_bdate
         IF w_day != 0 THEN
            CALL s_wknxt(w_bdate,1) RETURNING w_flag,p_strtdat
         ELSE
            CALL s_wknxt(w_bdate,0) RETURNING w_flag,p_strtdat
         END IF
         LET l_edg.edg50=p_strtdat  LET l_edg.edg51=l_sfb15
      END IF
      #FUN-A80060--end--add--------------------
      INSERT INTO edg_file VALUES l_edg.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('ins edg',SQLCA.sqlcode,1)
         LET g_success='N' EXIT FOREACH
      END IF          
    END FOREACH
END FUNCTION    
                
FUNCTION p304_ins_edh(p_sfd01,p_sfd02,p_edc01,p_edc02)
DEFINE p_sfd01    LIKE sfd_file.sfd01
DEFINE p_sfd02    LIKE sfd_file.sfd02
DEFINE p_edc01    LIKE edc_file.edc01
DEFINE p_edc02    LIKE edc_file.edc02
DEFINE l_edh      RECORD LIKE edh_file.*
DEFINE l_edd      RECORD LIKE edd_file.*

  DECLARE edd_cs CURSOR FOR
     SELECT * FROM edd_file WHERE edd01=p_edc01 AND edd011=p_edc02 ORDER BY edd013,edd02
  FOREACH edd_cs INTO l_edd.*
    LET l_edh.edh01=p_sfd01
    LET l_edh.edh011=p_sfd02
    LET l_edh.edh013=l_edd.edd013
    LET l_edh.edh02 =l_edd.edd02 
    LET l_edh.edh03 =l_edd.edd03 
    LET l_edh.edh04 =l_edd.edd04 
    LET l_edh.edh05 =l_edd.edd05 
    LET l_edh.edh06 =l_edd.edd06 
    LET l_edh.edh07 =l_edd.edd07 
    LET l_edh.edh08 =l_edd.edd08 
    LET l_edh.edh081=l_edd.edd081
    LET l_edh.edh082=l_edd.edd082
    LET l_edh.edh09 =l_edd.edd09 
    LET l_edh.edh10 =l_edd.edd10 
    LET l_edh.edh11 =l_edd.edd11 
    LET l_edh.edh13 =l_edd.edd13 
    LET l_edh.edh14 =l_edd.edd14 
    LET l_edh.edh15 =l_edd.edd15 
    LET l_edh.edh16 =l_edd.edd16 
    LET l_edh.edh17 =l_edd.edd17 
    LET l_edh.edh18 =l_edd.edd18 
    LET l_edh.edh19 =l_edd.edd19 
    LET l_edh.edh20 =l_edd.edd20 
    LET l_edh.edh21 =l_edd.edd21 
    LET l_edh.edh22 =l_edd.edd22 
    LET l_edh.edh23 =l_edd.edd23 
    LET l_edh.edh24 =l_edd.edd24 
    LET l_edh.edh25 =l_edd.edd25 
    LET l_edh.edh26 =l_edd.edd26 
    LET l_edh.edh27 =l_edd.edd27 
    LET l_edh.edh28 =l_edd.edd28 
    LET l_edh.edh29 =l_edd.edd29 
    LET l_edh.edh30 =l_edd.edd30 
    LET l_edh.edh31 =l_edd.edd31 
    LET l_edh.edh33 =l_edd.edd33 
    LET l_edh.edh10_fac=l_edd.edd10_fac
    LET l_edh.edh10_fac2=l_edd.edd10_fac2
    LET l_edh.edhcomm=l_edd.eddcomm
    LET l_edh.edhmodu=NULL
    LET l_edh.edhdate=g_today
    INSERT INTO edh_file VALUES l_edh.*
    IF SQLCA.sqlcode THEN
       CALL cl_err('ins edh',SQLCA.sqlcode,1)
       LET g_success='N' EXIT FOREACH
    END IF 
  END FOREACH
END FUNCTION
#FUN-A80054--end--add------------------------
#No.FUN-9C0072 精簡程式碼
 
FUNCTION p304_chk_edb(p_edc01,p_new_part,p_sfb06)
DEFINE l_cnt      LIKE type_file.num5
DEFINE p_edc01    LIKE edc_file.edc01
DEFINE p_sfb06    LIKE sfb_file.sfb06
DEFINE p_new_part LIKE ima_file.ima01
 
  LET g_errno=''
  LET l_cnt=0
  IF NOT cl_null(p_edc01) AND NOT cl_null(p_new_part) AND
     NOT cl_null(p_sfb06) THEN
     SELECT COUNT(*) INTO l_cnt FROM eda_file,edb_file
      WHERE eda01=p_edc01
        AND edb03=p_new_part
        AND edb04=p_sfb06
        AND eda01=edb01 AND edaconf='Y'
     IF l_cnt = 0 THEN
        LET g_errno='aec-057'
     END IF
  END IF
END FUNCTION

#CHI-C50029 str add-----
FUNCTION p304_chk_sfb39(l_sfb01)
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_cnt2     LIKE type_file.num5
DEFINE l_sfb01    LIKE sfb_file.sfb01
DEFINE l_sfb01_2  LIKE sfb_file.sfb01

  LET l_cnt=0
  SELECT COUNT(*) INTO l_cnt FROM sfa_file
   WHERE sfa01  = l_sfb01
     AND sfa11 != 'E' AND sfa11 !='X'          
  IF l_cnt = 0 THEN
    UPDATE sfb_file SET sfb39='2' WHERE sfb01=l_sfb01
  END IF

  LET l_cnt=0
  SELECT COUNT(*) INTO l_cnt FROM sfb_file
   WHERE sfb86  = l_sfb01

  IF l_cnt>0 THEN
    DECLARE p304_cur1 CURSOR FOR
       SELECT sfb01 FROM sfb_file WHERE sfb86  = l_sfb01

    FOREACH p304_cur1 INTO l_sfb01_2
       LET l_cnt2=0
       SELECT COUNT(*) INTO l_cnt2 FROM sfa_file
        WHERE sfa01  = l_sfb01_2
          AND sfa11 != 'E' 
       IF l_cnt2 = 0 THEN 
         UPDATE sfb_file SET sfb39='2' WHERE sfb01=l_sfb01_2
       END IF
    END FOREACH
  END IF

END FUNCTION
#CHI-C50029 end add-----

#TQC-C70002--add--str--
FUNCTION p304_sub_no(p_no,p_min_no,p_max_no)
   DEFINE   p_no        LIKE sfb_file.sfb01
   DEFINE   p_min_no    LIKE sfb_file.sfb01      
   DEFINE   p_max_no    LIKE sfb_file.sfb01       
   DEFINE   l_sub_no    LIKE sfb_file.sfb01
   DEFINE   l_min_no    LIKE sfb_file.sfb01
   DEFINE   l_max_no    LIKE sfb_file.sfb01        
   DEFINE   l_n         LIKE type_file.num5
   DEFINE   l_sql       STRING

   LET l_min_no = p_min_no
   LET l_max_no = p_max_no
   LET l_n = 0 
   SELECT COUNT(*) INTO l_n FROM sfb_file
    WHERE sfb86 = p_no
   IF l_n = 0 THEN RETURN l_min_no,l_max_no END IF 

   LET l_sql = "SELECT sfb01 FROM sfb_file ",
           " WHERE sfb86 = '", p_no ,"' "
   PREPARE q_sfb_prepare FROM l_sql
   DECLARE sfb_curs CURSOR FOR q_sfb_prepare 
   FOREACH sfb_curs INTO l_sub_no
      IF SQLCA.sqlcode THEN
         RETURN l_min_no,l_max_no
      END IF
      IF cl_null(l_max_no) THEN LET l_max_no = ' ' END IF    
      IF l_sub_no > l_max_no THEN LET l_max_no = l_sub_no END IF
      IF cl_null(l_min_no) THEN LET l_min_no = l_max_no END IF    
      IF l_sub_no < l_min_no THEN LET l_min_no = l_sub_no END IF
      CALL p304_sub_no(l_sub_no,l_min_no,l_max_no) RETURNING l_min_no,l_max_no  #遞歸查詢各級子工單
   END FOREACH
   RETURN l_min_no,l_max_no
END FUNCTION
#TQC-C70002--add--end--

#TQC-C70104--add--str--
FUNCTION p304_set_entry_b()
   CALL cl_set_comp_entry("sfb06",TRUE)
END FUNCTION

FUNCTION p304_set_no_entry_b(p_i)
   DEFINE p_i       LIKE type_file.num5
   DEFINE i         LIKE type_file.num5

   LET i = p_i
   IF new[i].sfb93 <> 'Y' THEN
      CALL cl_set_comp_entry("sfb06",FALSE)
   END IF
END FUNCTION

FUNCTION p304_set_no_required_b()
   CALL cl_set_comp_required("sfb06,new_no",FALSE)
   IF g_aaz.aaz90 = 'Y' THEN
      CALL cl_set_comp_required("costcenter",FALSE)
   END IF
END FUNCTION

FUNCTION p304_set_required_b(p_i)
   DEFINE p_i       LIKE type_file.num5
   DEFINE i         LIKE type_file.num5

   LET i = p_i
   IF new[i].x = 'Y' THEN
      IF new[i].sfb93 = 'Y' THEN
         CALL cl_set_comp_required("sfb06",TRUE)
      END IF
      IF g_aaz.aaz90 = 'Y' THEN
         CALL cl_set_comp_required("costcenter",TRUE)
      END IF
      CALL cl_set_comp_required("new_no",TRUE)
   END IF 
END FUNCTION
#TQC-C70104--add--end--

#DEV-D30026 add str-----------
FUNCTION p304_barcode_chk(p_new_part)
   DEFINE p_new_part LIKE ima_file.ima01

   LET l_barcode_yn = 'N'
   SELECT ima930 INTO l_barcode_yn
   FROM ima_file
   WHERE ima01 = p_new_part
END FUNCTION
#DEV-D30026 add end-----------
#str---add by guanyao160608
FUNCTION p304_oea01_check()
DEFINE l_sql    STRING 
DEFINE l_oeb01  LIKE oeb_file.oeb01
DEFINE l_i      LIKE type_file.num5
DEFINE l_err    LIKE type_file.chr1
DEFINE l_oea11  LIKE oea_file.oea11

      CALL s_showmsg_init()
      IF cl_null(g_wc) THEN
         LET g_wc= 'oeb01=',"'",g_argv1,"'"
      END IF
      LET l_err = 'Y'

      LET l_sql = "SELECT distinct oea01 ",     
                  " FROM oeb_file,oea_file,ima_file ",          
                  " WHERE ", g_wc CLIPPED,
                  #"  AND oeb12>(oeb24-oeb25+oeb905) ",  
                  "   AND oeb12>(nvl(oebud07,0)+oeb905)",  #add by guanyao160613 
                  "  AND oeb01 = oea01 ",
                  "  AND oeb04 = ima01 ",       
                  "  AND  oeb70 = 'N' ",   
                  "  AND oeb04 NOT LIKE 'MISC%' AND oeb04 NOT LIKE 'misc%' ",  
                  "  AND ima911<>'Y' "  
      PREPARE s_oeb_prepare1 FROM l_sql
      DECLARE s_oeb_curs1 CURSOR FOR s_oeb_prepare1
      LET l_i=1
      LET l_oeb01 = ''
      FOREACH s_oeb_curs1 INTO l_oeb01
         LET l_oea11 = ''  #add by guanyao160731
         SELECT oea11 INTO l_oea11 FROM oea_file WHERE oea01 = l_oeb01 AND oea00 = '1'
         IF l_oea11 = '3' THEN 
            CALL s_errmsg('oeb01',l_oeb01,'','csf-014',1)
            LET l_err = 'N'
            CONTINUE FOREACH 
         END IF
         LET l_i = l_i + 1          
      END FOREACH
      CALL s_showmsg()
      RETURN l_err
END FUNCTION 
#end---add by guanyao160608
