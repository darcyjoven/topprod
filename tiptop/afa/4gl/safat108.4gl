# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: safat108.4gl
# Descriptions...: 資產報廢/銷帳作業
# Date & Author..: 96/05/28 By Melody
# Modify.........: No:7645 03/07/24 By Wiky 設定抵押的資產應不可出售或報廢或銷帳
# Modify.........: No:A099 04/06/29 By Danny 大陸折舊方式/減值準備/資產停用
# Modify.........: No.MOD-480036 04/08/04 By Kitty g_chr改為l_fbg00
# Modify.........: No.MOD-480038 04/08/04 By Kitty 過帳還原有問題
# Modify.........: No.MOD-480073 04/08/24 By Nicola t108_w5中文名稱欄位顯示錯誤
# Modify.........: No:9891 04/09/03 By Nicola 刪除時，單身分錄末delete
# Modify.........: No.MOD-490344 04/09/20 By Kitty Controlp 未加display
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-4A0248 04/10/25 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0019 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0059 04/12/10 By Smapmin 加入權限控管
# Modify.........: No.MOD-530814 05/03/30 By Smapmin 確認過帳後afaq100查詢銷帳數量及成本仍然是0
# Modify.........: No.MOD-530223 05/04/19 By Smapmin 若取消確認時應加判斷是否此
#                                              張單據之後日期其資產有做減值作業
# Modify.........: NO.FUN-550034 05/05/17 By jackie 單據編號加大
# Modify.........: NO.FUN-560002 05/06/06 By day    單據編號修改
# Modify.........: No.FUN-580109 05/09/21 By Sarah 以EF為backend engine,由TIPTOP處理前端簽核動作
# Modify.........: No.FUN-5B0018 05/11/04 By Sarah 報廢/銷帳日期沒有判斷關帳日
# Modify.........: NO.TQC-5B0076 05/11/09 By Claire excel 匯出失效
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# MOdify.........: No.MOD-5C0136 05/12/23 By Smapmin 重選財編,附號.中文沒有重帶
# Modify.........: No.TQC-620120 06/03/02 By Smapmin 當附號為NULL時,LET 附號為空白
# Modify.........: No.FUN-630010 06/03/07 By saki 流程訊息通知功能
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-640243 06/05/15 By Echo 自動執行確認功能
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改報表列印所傳遞的參數
# Modify.........: No.TQC-670005 06/07/04 By Smapmin 盤點尚未過帳的資料不可新增至單身
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670060 06/08/07 By Ray 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-680028 06/08/22 By Ray 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0001 06/10/02 By jamie FUNCTION t108_q() 一開始應清空g_fbg.*值
# Modify.........: No.CHI-690083 06/10/13 By rainy 報廢/銷帳/出售作業只要是有主件資料的, 狀態更改時,一律update其相關附件的資產狀態
# Modify.........: No.MOD-6A0019 06/11/07 By Smapmin 恢復MOD-530814修改的部份
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.MOD-690095 06/12/05 By Smapmin 修改"判斷是否此張單據之後日期其資產有做銷帳.報廢作業"的寫法
# Modify.........: No.MOD-690081 06/12/06 By Smapmin 已確認的單子不可再重新產生分錄
# Modify.........: No.FUN-710028 07/02/03 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-720074 07/03/01 By Smapmin 檢查資產盤點期間應不可做異動
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740020 07/04/13 By atsea 會計科目加帳套
# Modify.........: No.TQC-740222 07/04/24 By Echo 從ERP簽核時，「拋轉傳票」、「傳票拋轉還原」action應隱藏
# Modify.........: No.MOD-740292 07/04/26 By kim afat109自動產生，QBE條件為財編，則產生不出來，手動輸入可
# Modify.........: No.TQC-740055 07/04/29 By xufeng 成本欄位可錄入負數                      
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760182 07/06/27 By chenl   自動生成QBE不可為空。
# Modify.........: No.MOD-780231 07/08/22 By jamie自動產生單身時，單身【累折】、【未折減額】未依幣別取位.
# Modify.........: No.TQC-780089 07/08/30 By Smapmin 自動產生或單身輸入資產編號時,當月有折舊不可輸入
#                                                    已有折舊資料不可過帳還原或確認
#                                                    判斷是否執行重新計算帳值/產生分錄
# Modify.........: No.FUN-810046 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-810261 08/01/31 By Smapmin 修正TQC-670005
# Modify.........: No.MOD-840014 08/04/19 By Pengu 若屬於附件報廢時,不可把主件一起報廢
# Modify.........: No.MOD-840379 08/04/21 By Sarah 單據日期應與afat105固定資產改良作業相同,當日期不在現行期別範圍內時,show警告『日期應在該年度期別之起始截止日期範圍內』
# Modify.........: No.FUN-840111 08/04/23 By lilingyu 申請人員未預設登入帳號
# Modify.........: No.FUN-850068 08/05/14 By TSD.Wind 自定欄位功能修改
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.MOD-860284 08/07/04 By Sarah 使用afap302拋轉程式,原先傳g_user改為fbguser
# Modify.........: No.CHI-860025 08/07/23 By Smapmin 根據TQC-780089的修改,需區分財簽與稅簽
# Modify.........: No.MOD-880229 08/08/28 By Sarah CALL s_chknpq()前增加CALL s_get_bookno(g_fbg.fbg02) RETURNING g_flag,g_bookno1,g_bookno2
# Modify.........: No.FUN-8A0086 08/10/22 By chenmoyan 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值
# Modify.........: No.MOD-950166 09/05/18 By xiaofeizhu 增加對單身的管控
# Modify.........: No.FUN-980003 09/08/10 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-970004 09/08/18 By destiny update時數值欄位不能給空  
# Modify.........: No.MOD-970231 09/07/24 By Sarah 計算未折減額時,應抓faj33+faj331
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9C0335 09/12/21 By sabrina afat109按"自動產生"單身時，只有下財產序號單身才會自動帶出資料
#                                                    下其他條件(如財編、保管人…等)單身會看不到資料
# Modify.........: No.FUN-9C0072 10/01/05 By vealxu 精簡程式碼
# Modify.........: No:MOD-A10130 10/01/21 By Sarah 當出現afa-097訊息時,請將單身財產編號、附號清空
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A40011 10/04/07 By Summer afat108/afat109 於同一作業中不允許有相同的財產編號+附號存在此作業中 
# Modify.........: No:MOD-A40104 10/04/20 By sabrina 從afat109列印與從afar109列印時累折金額顯示的數字不一樣 
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:CHI-A60036 10/07/12 By Summer 過帳檢查改用s_azmm,增加aza63判斷
# ModIFy.........: No:MOD-A80137 10/08/19 By Dido 過帳與取消過帳應檢核關帳日 
# Modify.........: No:MOD-AA0001 10/10/01 By Dido 確認檢核當月處分應折舊問題 
# Modify.........: No:MOD-AA0012 10/10/05 By Dido 自動產生單身後,抓取 faj_file 再增加附號條件 
# Modify.........: No:CHI-9C0008 10/10/13 By Summer 若已提至異動單據月份且單身累折/未折減額/減值準備均與折舊後月份相等
#                                                   則不需重新計算帳值即可確認 
# Modify.........: No:TQC-AB0174 10/11/28 By suncx 自動帶出稅簽資料的sql的where條件有錯誤
# Modify.........: No:TQC-AB0206 10/11/28 By suncx 新增對fav03的管控
# Modify.........: No:TQC-AC0381 10/12/29 By chenying 己重新計算過帳值,但確認時一直出現錯誤訊息提供需重新計算帳值
# Modify.........: No.MOD-B30014 11/03/01 by Dido 相關數量金額欄位不可為空 
# Modify.........: No:MOD-B30593 11/03/17 By Dido 增加抵押資產檢核 
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-AB0088 11/04/07 By chenying 因固資拆出財二功能，原本寫入fap亦有新增欄位，增加對應處理
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50090 11/06/07 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50062 11/06/08 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50118 11/06/13 By belle 自動產生鍵增加QBE條件-族群編號
# Modify.........: No.TQC-B50093 11/06/16 By yinhy 自動產生時，無法產生單身，手動錄入卻可以
# Modify.........: NO:MOD-B60173 11/06/22 By Dido 檢核未折減額需考量數量問題
# Modify.........: No.TQC-B60363 11/06/29 By yinhy 錯誤代碼'aoo-801'應改為'aoo-081'
# Modify.........: No.TQC-B70211 11/07/29 By Dido 更新 faj204/faj2042 的變數 l_c/l_c2 須先取位 
# Modify.........: No.MOD-B80195 11/08/23 By Polly 修正不走財簽二faj528為空值，造成update faj_file時錯誤
# Modify.........: No:FUN-B60140 11/09/07 By minpp "財簽二二次改善" 追單
# Modify.........: No:FUN-BA0112 11/11/08 By Sakura 財簽二5.25與5.1程式比對不一致修改
# Modify.........: NO:FUN-B90096 11/11/08 By Sakura 將UPDATE faj_file拆分出財一、財二
# Modify.........: No:CHI-B80007 11/11/12 By johung 增加afa-309控卡 
# Modify.........: NO:FUN-B90004 11/11/17 By Belle 自動拋轉傳票單別一欄有值，即可進行傳票拋轉/傳票拋轉還原
# Modify.........: No:MOD-BB0223 11/11/26 By johung 將BEFORE ROW中計算fbh062/fbh072/fbh082/fbh122移至BEFORE FIELD fbh062處理
# Modify.........: No:MOD-BC0010 11/12/10 By johung 財簽二應用產生底稿時應用財簽二帳別
# Modify.........: No:MOD-BC0025 11/12/10 By johung 調整afa-092控卡的判斷
# Modify.........: NO:FUN-BB0122 12/01/13 By Sakura 財二預設修改
# Modify.........: No:TQC-C10070 12/01/18 By Sarah l_fbh082與l_fbh122的計算需考慮資產數量
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C20012 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No.MOD-C20003 12/02/01 By Polly 增加判斷，如果已財簽過帳，則稅簽資料狀態=faj43
# Modify.........: No:TQC-C20156 12/02/20 By wujie 查询增加oriu,orig
# Modify.........: No:MOD-C20198 12/03/01 By Polly 稅簽還原過帳時需還原fap73,fap74的值
# Modify.........: No:FUN-C30140 12/03/12 By Mandy (1)TIPTOP端簽核時,以下ACTION應隱藏[分錄底稿二],[財簽二資料]
# Modify.........:                                 (2)送簽中,應不可執行ACTION[自動產生,分錄底稿,分錄底稿二,產生分錄底稿,重新計算帳值,財簽二資料,稅簽修改]
# Modify.........: No:TQC-C30315 12/03/28 By Carrier update fbh_file时,报-391的错误
# Modify.........: No:FUN-C30313 12/04/18 By Sakura 原使用fahdmy3判斷的程式，將財二部份拆分出來使用fahdmy32處理
# Modify.........: No:MOD-C50044 12/05/09 By Elise 按下確認時，會出現afai900內當月份有做調整的單被當成是已提列折舊的單
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.MOD-C50255 12/06/05 By Polly 增加控卡維護拋轉總帳單別
# Modify.........: No.CHI-C30107 12/06/08 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:CHI-C60010 12/06/14 By jinjj 財簽二欄位需依財簽二幣別做取位
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No.MOD-C70265 12/07/27 By Polly 資產不存在時,將 afa-093 改用訊息 afa-134
# Modify.........: No.MOD-C70313 12/08/03 By Polly 銷帳或是作廢只更新財產編號+附號的那筆資產資料
# Modify.........: No:CHI-C90051 12/09/08 By Polly 將拋轉還原程式移至更新確認碼/過帳碼前處理，並判斷傳票編號如不為null時，則RETURN
# Modify.........: No.MOD-C80254 12/09/03 By Polly 同一張異動單據不可有相同之財產編號資料!
# Modify.........: No:MOD-C80118 12/09/21 By Polly 當月取得折舊要按日計算，需依比例提列折舊
# Modify.........: No:MOD-C80200 12/10/31 By Polly 調整afa-154控卡，需再扣除已提列減值準備金額
# Modify.........: No:MOD-CA0239 12/11/01 By Polly 1.增加控卡，出售數量不能為零 2.調整數量控卡，資產數量-銷帳數量不為零，即可異動
# Modify.........: No.CHI-C80041 12/11/26 By bart 取消單頭資料控制
# Modify.........: No.FUN-D10098 13/02/04 By lujh 大陸版本用gfag109
# Modify.........: No:FUN-D20035 13/02/21 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D30032 13/04/08 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-CB0108 13/04/10 By apo 增加控卡，同一個財產編號不可有多張異動單據資料！
# Modify.........: No:FUN-D80046 13/08/15 By wangrr 審核檢查時,當參數勾選"當月處置應提列折舊",無需檢查無形資產和費用(faj09=2/5)
# Modify.........: No:FUN-E80012 18/11/29 By lixwz 修改付款日期之後,tic現金流量明細重複

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_fbg   RECORD LIKE fbg_file.*,
       g_fbg_t RECORD LIKE fbg_file.*,
       g_fbg_o RECORD LIKE fbg_file.*,
       g_fahprt       LIKE fah_file.fahprt,
       g_fbg00        LIKE fbg_file.fbg00,       #MOD-480036
       g_fahconf      LIKE fah_file.fahconf,
       g_fahpost      LIKE fah_file.fahpost,
       g_fahapr       LIKE fah_file.fahapr,             #FUN-640243
       g_fbh          DYNAMIC ARRAY OF RECORD   #程式變數(Prinram Variables)
                      fbh02     LIKE fbh_file.fbh02,
                      fbh03     LIKE fbh_file.fbh03,
                      fbh031    LIKE fbh_file.fbh031,
                      faj06     LIKE faj_file.faj06,
                      faj18     LIKE faj_file.faj18,
                      fbh04     LIKE fbh_file.fbh04,
                      fbh05     LIKE fbh_file.fbh05,
                      fbh06     LIKE fbh_file.fbh06,
                      fbh07     LIKE fbh_file.fbh07,
                      fbh08     LIKE fbh_file.fbh08,
                      fbh12     LIKE fbh_file.fbh12,       #No:A099
                      fbhud01   LIKE fbh_file.fbhud01,
                      fbhud02   LIKE fbh_file.fbhud02,
                      fbhud03   LIKE fbh_file.fbhud03,
                      fbhud04   LIKE fbh_file.fbhud04,
                      fbhud05   LIKE fbh_file.fbhud05,
                      fbhud06   LIKE fbh_file.fbhud06,
                      fbhud07   LIKE fbh_file.fbhud07,
                      fbhud08   LIKE fbh_file.fbhud08,
                      fbhud09   LIKE fbh_file.fbhud09,
                      fbhud10   LIKE fbh_file.fbhud10,
                      fbhud11   LIKE fbh_file.fbhud11,
                      fbhud12   LIKE fbh_file.fbhud12,
                      fbhud13   LIKE fbh_file.fbhud13,
                      fbhud14   LIKE fbh_file.fbhud14,
                      fbhud15   LIKE fbh_file.fbhud15
                      END RECORD,
       g_fbh_e        DYNAMIC ARRAY OF RECORD    # ^E 功能用的變數
                      fbh09     LIKE fbh_file.fbh09,
                      fbh10     LIKE fbh_file.fbh10,
                      fbh11     LIKE fbh_file.fbh11,
                      fbh13     LIKE fbh_file.fbh13        #No:A099
                      END RECORD,
       g_fbh_t        RECORD
                      fbh02     LIKE fbh_file.fbh02,
                      fbh03     LIKE fbh_file.fbh03,
                      fbh031    LIKE fbh_file.fbh031,
                      faj06     LIKE faj_file.faj06,
                      faj18     LIKE faj_file.faj18,
                      fbh04     LIKE fbh_file.fbh04,
                      fbh05     LIKE fbh_file.fbh05,
                      fbh06     LIKE fbh_file.fbh06,
                      fbh07     LIKE fbh_file.fbh07,
                      fbh08     LIKE fbh_file.fbh08,
                      fbh12     LIKE fbh_file.fbh12,       #No:A099
                      fbhud01   LIKE fbh_file.fbhud01,
                      fbhud02   LIKE fbh_file.fbhud02,
                      fbhud03   LIKE fbh_file.fbhud03,
                      fbhud04   LIKE fbh_file.fbhud04,
                      fbhud05   LIKE fbh_file.fbhud05,
                      fbhud06   LIKE fbh_file.fbhud06,
                      fbhud07   LIKE fbh_file.fbhud07,
                      fbhud08   LIKE fbh_file.fbhud08,
                      fbhud09   LIKE fbh_file.fbhud09,
                      fbhud10   LIKE fbh_file.fbhud10,
                      fbhud11   LIKE fbh_file.fbhud11,
                      fbhud12   LIKE fbh_file.fbhud12,
                      fbhud13   LIKE fbh_file.fbhud13,
                      fbhud14   LIKE fbh_file.fbhud14,
                      fbhud15   LIKE fbh_file.fbhud15
                      END RECORD,
       g_fah          RECORD LIKE fah_file.*,
       g_faj40        LIKE faj_file.faj40,
       g_faj42        LIKE faj_file.faj42,
       g_faj26        LIKE faj_file.faj26,
       g_faj262       LIKE faj_file.faj262,   #FUN-AB0088  add
       g_fbh04        LIKE fbh_file.fbh04,
       g_fbh06        LIKE fbh_file.fbh06,
       g_fbh07        LIKE fbh_file.fbh07,
       g_fbh08        LIKE fbh_file.fbh08,
       g_fbh09        LIKE fbh_file.fbh09,
       g_fbh10        LIKE fbh_file.fbh10,
       g_fbh11        LIKE fbh_file.fbh11,
       g_fbh12        LIKE fbh_file.fbh12,          #No:A099
       g_fbh13        LIKE fbh_file.fbh13,          #No:A099
       g_wc,g_wc2,g_sql    STRING,                  #No.FUN-580092 HCN
       g_t1                LIKE type_file.chr5,     #No.FUN-550034          #No.FUN-680070 VARCHAR(5)
       g_rec_b             LIKE type_file.num5,     #單身筆數       #No.FUN-680070 SMALLINT
       l_ac                LIKE type_file.num5,     #目前處理的ARRAY CNT       #No.FUN-680070 SMALLINT
       g_argv1             LIKE type_file.chr1,     #No.FUN-680070 VARCHAR(1)
       g_argv2             LIKE type_file.chr20,    #No.FUN-560002          #No.FUN-680070 VARCHAR(16)
       g_argv3             STRING                   #No.FUN-630010
DEFINE g_laststage         LIKE type_file.chr1      #FUN-580109       #No.FUN-680070 VARCHAR(1)
DEFINE p_row,p_col         LIKE type_file.num5      #No.FUN-680070 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5      #No.FUN-680070 SMALLINT
DEFINE g_forupd_sql        STRING                   #SELECT ... FOR UPDATE SQL
DEFINE g_chr               LIKE type_file.chr1      #No.FUN-680070 VARCHAR(1)
DEFINE g_chr2              LIKE type_file.chr1      #FUN-580109       #No.FUN-680070 VARCHAR(1)
DEFINE g_void              LIKE type_file.chr1      #No.FUN-680070 VARCHAR(1)
DEFINE g_cnt               LIKE type_file.num10     #No.FUN-680070 INTEGER
DEFINE g_cnt1              LIKE type_file.num10     #FUN-AB0088 add 
DEFINE g_i                 LIKE type_file.num5      #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE g_msg               LIKE type_file.chr1000   #No.FUN-680070 VARCHAR(72)
DEFINE g_str               STRING                   #No.FUN-670060
DEFINE g_wc_gl             STRING                   #No.FUN-670060
DEFINE g_dbs_gl            LIKE type_file.chr21     #No.FUN-670060       #No.FUN-680070 VARCHAR(21)
DEFINE g_row_count         LIKE type_file.num10     #No.FUN-680070 INTEGER
DEFINE g_curs_index        LIKE type_file.num10     #No.FUN-680070 INTEGER
DEFINE g_jump              LIKE type_file.num10     #No.FUN-680070 INTEGER
DEFINE mi_no_ask           LIKE type_file.num5      #No.FUN-680070 SMALLINT
DEFINE g_bookno1           LIKE aza_file.aza81      #No.FUN-740020 
DEFINE g_bookno2           LIKE aza_file.aza82      #No.FUN-740020 
DEFINE g_flag              LIKE type_file.chr1      #No.FUN-740020 
#FUN-AB0088---add---str---
DEFINE g_fbh2         DYNAMIC ARRAY OF RECORD   #祘Α跑计(Prinram Variables)
                      fbh02     LIKE fbh_file.fbh02,
                      fbh03     LIKE fbh_file.fbh03,
                      fbh031    LIKE fbh_file.fbh031,
                      faj06     LIKE faj_file.faj06,
                      faj18     LIKE faj_file.faj18,
                      fbh04     LIKE fbh_file.fbh04,
                      fbh062    LIKE fbh_file.fbh062,
                      fbh072    LIKE fbh_file.fbh072,
                      fbh082    LIKE fbh_file.fbh082,
                      fbh122    LIKE fbh_file.fbh122
                      END RECORD,
       g_fbh2_t       RECORD
                      fbh02     LIKE fbh_file.fbh02,
                      fbh03     LIKE fbh_file.fbh03,
                      fbh031    LIKE fbh_file.fbh031,
                      faj06     LIKE faj_file.faj06,
                      faj18     LIKE faj_file.faj18,
                      fbh04     LIKE fbh_file.fbh04,
                      fbh062    LIKE fbh_file.fbh062,
                      fbh072    LIKE fbh_file.fbh072,
                      fbh082    LIKE fbh_file.fbh082,
                      fbh122    LIKE fbh_file.fbh122
                      END RECORD
#FUN-AB0088---add---end---
#CHI-C60010---str---
DEFINE g_azi04_1  LIKE azi_file.azi04,
       g_faj143   LIKE faj_file.faj143
#CHI-C60010---end---
 
FUNCTION t108(p_argv1,p_argv2,p_argv3)   #No.FUN-630010
DEFINE p_argv1       LIKE type_file.chr1  		       #No.FUN-680070 VARCHAR(1)
DEFINE p_argv2       LIKE type_file.chr20 		 #No.FUN-560002          #No.FUN-680070 VARCHAR(16)
DEFINE p_argv3       STRING              #No.FUN-630010
 
    WHENEVER ERROR CALL cl_err_msg_log      #忽略一切錯誤
    LET g_wc2=' 1=1'
 
    LET g_forupd_sql = " SELECT * FROM fbg_file WHERE fbg01 = ?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t108_cl CURSOR FROM g_forupd_sql
 
    LET g_argv1=p_argv1
    LET g_argv2=p_argv2
    LET g_argv3=p_argv3       #No.FUN-630010
    IF p_argv1='1' THEN LET g_fbg00='5' END IF ### 報廢單性質碼MOD-480036
    IF p_argv1='2' THEN LET g_fbg00='6' END IF ### 銷帳單性質碼MOD-480036
 
    IF fgl_getenv('EASYFLOW') = "1" THEN
       LET g_argv2 = aws_efapp_wsk(1)   #參數:key-1
    END IF

   #CHI-C60010--add--str--
    SELECT aaa03 INTO g_faj143 FROM aaa_file
     WHERE aaa01 = g_faa.faa02c
    IF NOT cl_null(g_faj143) THEN
       SELECT azi04 INTO g_azi04_1 FROM azi_file
        WHERE azi01 = g_faj143
    END IF
   #CHI-C60010--add—end---

#FUN-AB0088---add---str---
    IF g_faa.faa31 = 'Y' THEN  
       CALL cl_set_act_visible("fin_audit2,entry_sheet2",TRUE)
       CALL cl_set_comp_visible("fbg082,fbg092",TRUE)    #FUN-B60140   Add
    ELSE
       CALL cl_set_act_visible("fin_audit2,entry_sheet2",FALSE)
       CALL cl_set_comp_visible("fbg082,fbg092",FALSE)   #FUN-B60140   Add 
    END IF
#FUN-AB0088---add---end---

 
    #建立簽核模式時的 toolbar icon
    CALL aws_efapp_toolbar()
 
    IF NOT cl_null(g_argv2) THEN
       CASE g_argv3
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t108_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL t108_a()
             END IF
         WHEN "efconfirm"
            CALL t108_q()
            CALL t108_y_chk()          #CALL 原確認的 check 段
            IF g_success = "Y" THEN
               LET l_ac = 1
               CALL t108_y_upd()       #CALL 原確認的 update 段
            END IF
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
          OTHERWISE
             CALL t108_q()
       END CASE
    END IF
 
    #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
    CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void,confirm, undo_confirm,  #FUN-D20035 add--undo_void
                               easyflow_approval, auto_generate, recount, entry_sheet, gen_entry, post, undo_post, 
                               entry_sheet2,fin_audit2, 
                               amend_depr_tax, post_depr_tax, undo_post_depr_tax, account_post, carry_voucher, undo_carry_voucher") #TQC-740222 #FUN-C30140
         RETURNING g_laststage
 
    CALL t108_menu()
END FUNCTION
 
FUNCTION t108_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                                    #清除畫面
    CALL g_fbh.clear()
    IF NOT cl_null(g_argv2) THEN
       LET g_wc = " fbg01='",g_argv2,"'"
       LET g_wc2 = " 1=1"
    ELSE
       CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
   INITIALIZE g_fbg.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
           fbg01,fbg02,fbg03,fbg04,fbg05,fbg08,fbg09,fbg082,fbg092,   #FUN-B60140
           fbgconf,fbgpost,
           fbgmksg,fbg10,   #FUN-580109
           fbguser,fbggrup,fbgoriu,fbgorig,fbgmodu,fbgdate,     #No.TQC-C20156 add oriu,orig
           fbgud01,fbgud02,fbgud03,fbgud04,fbgud05,
           fbgud06,fbgud07,fbgud08,fbgud09,fbgud10,
           fbgud11,fbgud12,fbgud13,fbgud14,fbgud15
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
           ON ACTION controlp
              CASE
               WHEN INFIELD(fbg01) #查詢單据
                    CALL cl_init_qry_var()
                    LET g_qryparam.state= "c"
                    LET g_qryparam.form = "q_fbg"
                    LET g_qryparam.arg1 = g_argv1
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fbg01
                    NEXT FIELD fbg01
               WHEN INFIELD(fbg03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fbg03
                    NEXT FIELD fbg03
               WHEN INFIELD(fbg04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fbg04
                    NEXT FIELD fbg04
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
       CONSTRUCT g_wc2 ON fbh02,fbh03,fbh031,fbh04,fbh05,fbh06,fbh07,fbh08,fbh12
                          ,fbhud01,fbhud02,fbhud03,fbhud04,fbhud05
                          ,fbhud06,fbhud07,fbhud08,fbhud09,fbhud10
                          ,fbhud11,fbhud12,fbhud13,fbhud14,fbhud15
                  FROM s_fbh[1].fbh02, s_fbh[1].fbh03, s_fbh[1].fbh031,
                       s_fbh[1].fbh04, s_fbh[1].fbh05, s_fbh[1].fbh06,
                       s_fbh[1].fbh07, s_fbh[1].fbh08, s_fbh[1].fbh12
                       ,s_fbh[1].fbhud01,s_fbh[1].fbhud02,s_fbh[1].fbhud03
                       ,s_fbh[1].fbhud04,s_fbh[1].fbhud05,s_fbh[1].fbhud06
                       ,s_fbh[1].fbhud07,s_fbh[1].fbhud08,s_fbh[1].fbhud09
                       ,s_fbh[1].fbhud10,s_fbh[1].fbhud11,s_fbh[1].fbhud12
                       ,s_fbh[1].fbhud13,s_fbh[1].fbhud14,s_fbh[1].fbhud15
 
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
           ON ACTION controlp
              CASE
               WHEN INFIELD(fbh03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_faj"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO abh03
                    NEXT FIELD fbh03
               WHEN INFIELD(fbh031)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_faj"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO abh031
                    NEXT FIELD fbh031
               WHEN INFIELD(fbh05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_fag"
                    LET g_qryparam.state = "c"
                     LET g_qryparam.arg1 = g_fbg00 CLIPPED   #MOD-480036
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO abh05
                    NEXT FIELD fbh05
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
    END IF
 
    #只查詢該性質資料
    LET g_wc = g_wc CLIPPED," AND fbg00 = '",g_argv1,"'"
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fbguser', 'fbggrup')
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT fbg01 FROM fbg_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT DISTINCT fbg01 ",
                   "  FROM fbg_file, fbh_file",
                   " WHERE fbg01 = fbh01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
 
    END IF
    PREPARE t108_prepare FROM g_sql
    DECLARE t108_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t108_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM fbg_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT fbg01) FROM fbg_file,fbh_file WHERE ",
                  "fbh01=fbg01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t108_prcount FROM g_sql
    DECLARE t108_count CURSOR WITH HOLD FOR t108_prcount
END FUNCTION
 
FUNCTION t108_menu()
   DEFINE l_creator    LIKE type_file.chr1           #「不准」時是否退回填表人 #FUN-580109       #No.FUN-680070 VARCHAR(1)
   DEFINe l_flowuser   LIKE type_file.chr1           # 是否有指定加簽人員      #FUN-580109       #No.FUN-680070 VARCHAR(1)
 
   LET l_flowuser = "N"   #FUN-580109
 
   WHILE TRUE
      CALL t108_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t108_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t108_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t108_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t108_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t108_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t108_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "auto_generate"
            IF cl_chk_act_auth() THEN
                #FUN-C30140---add---str---
                IF NOT cl_null(g_fbg.fbg10) AND g_fbg.fbg10 matches '[Ss]' THEN     
                    CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
                ELSE
                #FUN-C30140---add---end---
                   CALL t108_g()
                   CALL t108_b()
                END IF #FUN-C30140 add
            END IF
         WHEN "recount"
            IF cl_chk_act_auth() THEN
                #FUN-C30140---add---str---
                IF NOT cl_null(g_fbg.fbg10) AND g_fbg.fbg10 matches '[Ss]' THEN     
                    CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
                ELSE
                #FUN-C30140---add---end---
                   CALL t108_m()
                   CALL t108_show()
                END IF #FUN-C30140 add
            END IF
         WHEN "entry_sheet"
            IF cl_chk_act_auth() AND not cl_null(g_fbg.fbg01) THEN
                #FUN-C30140---add---str---
                IF NOT cl_null(g_fbg.fbg10) AND g_fbg.fbg10 matches '[Ss]' THEN     
                    CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
                ELSE
                #FUN-C30140---add---end---
                    IF g_argv1 = '1' THEN
                       CALL s_fsgl('FA',5,g_fbg.fbg01,0,g_faa.faa02b,1,g_fbg.fbgconf,'0',g_faa.faa02p)     #No.FUN-680028
                       CALL t108_npp02('0')  #No.+087 010503 by plum     #No.FUN-680028
                    ELSE
                       CALL s_fsgl('FA',6,g_fbg.fbg01,0,g_faa.faa02b,1,g_fbg.fbgconf,'0',g_faa.faa02p)
                       CALL t108_npp02('0')  #No.+087 010503 by plum     #No.FUN-680028
                    END IF
                END IF #FUN-C30140 add
            END IF
         WHEN "entry_sheet2"
            IF cl_chk_act_auth() AND not cl_null(g_fbg.fbg01) THEN
                #FUN-C30140---add---str---
                IF NOT cl_null(g_fbg.fbg10) AND g_fbg.fbg10 matches '[Ss]' THEN     
                    CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
                ELSE
                #FUN-C30140---add---end---
                    IF g_argv1 = '1' THEN
                       CALL s_fsgl('FA',5,g_fbg.fbg01,0,g_faa.faa02c,1,g_fbg.fbgconf,'1',g_faa.faa02p)     #No.FUN-680028
                       CALL t108_npp02('1')  #No.+087 010503 by plum     #No.FUN-680028
                    ELSE
                       CALL s_fsgl('FA',6,g_fbg.fbg01,0,g_faa.faa02c,1,g_fbg.fbgconf,'1',g_faa.faa02p)
                       CALL t108_npp02('1')  #No.+087 010503 by plum     #No.FUN-680028
                    END IF
                END IF #FUN-C30140 add
            END IF
         WHEN "gen_entry"
            IF cl_chk_act_auth() AND g_fbg.fbgconf <> 'X' THEN
                #FUN-C30140---add---str---
                IF NOT cl_null(g_fbg.fbg10) AND g_fbg.fbg10 matches '[Ss]' THEN     
                    CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
                ELSE
                #FUN-C30140---add---end---
                    IF g_fbg.fbgconf = 'N' THEN   #MOD-690081
                       LET g_success='Y' #no.5573
                       BEGIN WORK #no.5573
                       CALL s_showmsg_init()    #No.FUN-710028
                    
                    CALL s_get_bookno(g_fbg.fbg02)
                        RETURNING g_flag,g_bookno1,g_bookno2    
                    IF g_flag= '1' THEN  #
                       #CALL cl_err(g_fbg.fbg02,'aoo-801',1) #No.TQC-B60363
                       CALL cl_err(g_fbg.fbg02,'aoo-081',1)  #No.TQC-B60363
                    END IF 
                    
                       CALL t108_gl(g_argv1,g_fbg.fbg01,g_fbg.fbg02,'0',g_bookno1)      #No.FUN-740020
                      #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN    #FUN-AB0088 mark
                       IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN    #FUN-AB0088    
                          LET g_bookno2 = g_faa.faa02c   #MOD-BC0010 add
                          CALL t108_gl(g_argv1,g_fbg.fbg01,g_fbg.fbg02,'1',g_bookno2)   #No.FUN-740020
                       END IF
                       CALL s_showmsg() #No.FUN-710028
                       IF g_success='Y' THEN
                          COMMIT WORK
                       ELSE
                          ROLLBACK WORK
                       END IF #no.5573
                    ELSE   #MOD-690081
                       CALL cl_err(g_fbg.fbg01,'afa-350',0)   #MOD-690081
                    END IF #MOD-690081
                END IF #FUN-C30140 add
            END IF

#FUN-AB0088---add---str---
         WHEN "fin_audit2"
            IF cl_chk_act_auth() THEN
               CALL t108_fin_audit2()
            END IF  
#FUN-AB0088---add---end---

         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t108_x()              #FUN-D20035
               CALL t108_x(1)           #FUN-D20035
            END IF

         #FUN-D20035---add--str
         #取消作废
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t108_x(2)
            END IF
         #FUN-D20035---add---end

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t108_y_chk()          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                  CALL t108_y_upd()       #CALL 原確認的 update 段
               END IF
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t108_z()
            END IF
         WHEN "carry_voucher"
            IF cl_chk_act_auth() THEN
               IF g_fbg.fbgpost = 'Y' THEN     #No.FUN-680028
                  CALL t108_carry_voucher()
               ELSE 
                  CALL cl_err('','atm-557',1)     #No.FUN-680028
               END IF
            END IF
         WHEN "undo_carry_voucher"
            IF cl_chk_act_auth() THEN
               IF g_fbg.fbgpost = 'Y' THEN     #No.FUN-680028
                  CALL t108_undo_carry_voucher() 
               ELSE 
                  CALL cl_err('','atm-558',1)     #No.FUN-680028
               END IF
            END IF
         WHEN "post"
            IF cl_chk_act_auth() THEN
               CALL t108_s('S')
            END IF
         WHEN "account_post"
            IF cl_chk_act_auth() THEN
               CALL t108_s('T')
            END IF
         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
               CALL t108_w()
            END IF
         WHEN "amend_depr_tax"
            IF cl_chk_act_auth() THEN
               CALL t108_k()
            END IF
         WHEN "post_depr_tax"
            IF cl_chk_act_auth() THEN
               CALL t108_6()
            END IF
         WHEN "undo_post_depr_tax"
            IF cl_chk_act_auth() THEN
               CALL t108_7()
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_fbg.fbg01 IS NOT NULL THEN
                  LET g_doc.column1 = "fbg01"
                  LET g_doc.value1 = g_fbg.fbg01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fbh),'','')
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
                SELECT * INTO g_fbg.* FROM fbg_file
                 WHERE fbg01 = g_fbg.fbg01
                CALL t108_show()
                CALL t108_b_fill(' 1=1')
               #FUN-C20012 add end---
                CALL t108_ef()
                CALL t108_show()  #FUN-C20012 add
             END IF
 
        #@WHEN "准"
        WHEN "agree"
             IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有>
                CALL t108_y_upd()      #CALL 原確認的 update 段
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
                      LET g_argv2 = aws_efapp_wsk(1)   #參數:key-1
                      IF NOT cl_null(g_argv1) THEN
                         CALL t108_q()
                         #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                         CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void,confirm, undo_confirm,  #FUN-D20035 add--undo_void
                                                    easyflow_approval,auto_generate, recount, entry_sheet, gen_entry, post, undo_post, amend_depr_tax, post_depr_tax, 
                                                    entry_sheet2,fin_audit2, 
                                                    undo_post_depr_tax, account_post, carry_voucher, undo_carry_voucher") #TQC-740222 #FUN-C30140
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
                     LET g_fbg.fbg10 = 'R'
                     DISPLAY BY NAME g_fbg.fbg10
                  END IF
                  IF cl_confirm('aws-081') THEN
                     IF aws_efapp_getnextforminfo() THEN
                        LET l_flowuser = 'N'
                        LET g_argv2 = aws_efapp_wsk(1)   #參數:key-1
                        IF NOT cl_null(g_argv1) THEN
                           CALL t108_q()
                           #設定簽核功能及哪些 action 在簽核狀態時是不可被執行>
                           CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void,confirm, undo_confirm,  #FUN-D20035 add--undo_void
                                                      easyflow_approval,auto_generate, recount, entry_sheet, gen_entry, post, undo_post, amend_depr_tax, post_depr_tax, 
                                                      entry_sheet2,fin_audit2, 
                                                      undo_post_depr_tax, account_post, carry_voucher, undo_carry_voucher") #TQC-740222 #FUN-C30140 
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
 
FUNCTION t108_a()
 
  DEFINE li_result   LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
   CALL g_fbh.clear()
    INITIALIZE g_fbg.* TO NULL
    LET g_fbg_o.* = g_fbg.*
    LET g_fbg_t.* = g_fbg.*
 
    LET g_fbg.fbg03=g_user 
    CALL t108_fbg03('d')
 
    WHILE TRUE
        LET g_fbg.fbg00  =g_argv1
        LET g_fbg.fbg02  =g_today
        LET g_fbg.fbg05  =g_today
        LET g_fbg.fbgpost='N'
        LET g_fbg.fbgpost2='N'
        LET g_fbg.fbgconf='N'
        LET g_fbg.fbguser=g_user
        LET g_fbg.fbgoriu = g_user #FUN-980030
        LET g_fbg.fbgorig = g_grup #FUN-980030
        LET g_fbg.fbggrup=g_grup
        LET g_fbg.fbgdate=g_today
        LET g_fbg.fbgmksg = "N"   #FUN-580109
        LET g_fbg.fbg10 = "0"     #FUN-580109
        LET g_fbg.fbglegal= g_legal    #FUN-980003 add
 
        BEGIN WORK
        CALL t108_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0 CALL cl_err('',9001,0)
           INITIALIZE g_fbg.* TO NULL
           ROLLBACK WORK EXIT WHILE
        END IF
        IF g_fbg.fbg01 IS NULL THEN CONTINUE WHILE END IF
        CALL s_auto_assign_no("afa",g_fbg.fbg01,g_fbg.fbg02,g_fbg00,"fbg_file","fbg01","","","")
             RETURNING li_result,g_fbg.fbg01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_fbg.fbg01
 
        INSERT INTO fbg_file VALUES (g_fbg.*)
        IF STATUS THEN 
           CALL cl_err3("ins","fbg_file",g_fbg.fbg01,"",STATUS,"","",1)  #No.FUN-660136
           CONTINUE WHILE 
        END IF
        COMMIT WORK
        CALL cl_flow_notify(g_fbg.fbg01,'I')
 
        SELECT fbg01 INTO g_fbg.fbg01 FROM fbg_file WHERE fbg01 = g_fbg.fbg01
        LET g_fbg_t.* = g_fbg.*
        CALL g_fbh.clear()
        LET g_rec_b=0
        CALL t108_g()                   #輸入單身
        CALL t108_b()                   #輸入單身
        #---判斷是否直接列印,confirm,過帳---------
 
         LET g_t1 = s_get_doc_no(g_fbg.fbg01)       #No.FUN-550034
        SELECT fahprt,fahconf,fahpost,fahapr
               INTO g_fahprt,g_fahconf,g_fahpost,g_fahapr
          FROM fah_file
         WHERE fahslip = g_t1
        IF g_fahprt  = 'Y' THEN
           IF NOT cl_confirm('afa-128') THEN RETURN END IF
           CALL t108_out()
        END IF
        IF g_fahconf = 'Y' AND g_fahapr <> 'Y' THEN
           LET g_action_choice = "insert"
 
           CALL t108_y_chk()          #CALL 原確認的 check 段
           IF g_success = "Y" THEN
              CALL t108_y_upd()       #CALL 原確認的 update 段
           END IF
        END IF
        IF g_fahpost = 'Y' THEN
           CALL t108_s('S')
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t108_u()
  DEFINE l_tic01     LIKE tic_file.tic01       #FUN-E80012 add
  DEFINE l_tic02     LIKE tic_file.tic02       #FUN-E80012 add
    IF s_shut(0) THEN RETURN END IF
    IF g_fbg.fbg01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_fbg.* FROM fbg_file WHERE fbg01 = g_fbg.fbg01
    IF g_fbg.fbgconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_fbg.fbgconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_fbg.fbgpost = 'Y' THEN CALL cl_err('','afa-101',0) RETURN END IF
    IF g_fbg.fbg10 matches '[Ss]' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fbg_o.* = g_fbg.*
 
    BEGIN WORK
 
    OPEN t108_cl USING g_fbg.fbg01
    IF STATUS THEN
       CALL cl_err("OPEN t108_cl:", STATUS, 1)
       CLOSE t108_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t108_cl INTO g_fbg.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbg.fbg01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t108_cl ROLLBACK WORK RETURN
    END IF
    CALL t108_show()
    WHILE TRUE
        LET g_fbg.fbgmodu=g_user
        LET g_fbg.fbgdate=g_today
        CALL t108_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fbg.*=g_fbg_t.*
            CALL t108_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        LET g_fbg.fbg10 = '0'   #FUN-580109
        UPDATE fbg_file SET * = g_fbg.* WHERE fbg01 = g_fbg.fbg01
        IF STATUS THEN 
           CALL cl_err3("upd","fbg_file",g_fbg_t.fbg01,"",STATUS,"","",1)  #No.FUN-660136
           CONTINUE WHILE 
        END IF
        IF g_fbg.fbg02 != g_fbg_t.fbg02 THEN            # 更改單號
           UPDATE npp_file SET npp02=g_fbg.fbg02
             WHERE npp01=g_fbg.fbg01 AND npp00=g_fbg00 AND npp011=1    #No.MOD-480036
              AND nppsys = 'FA'
           IF STATUS THEN 
              CALL cl_err3("upd","npp_file",g_fbg.fbg01,g_fbg00,STATUS,"","upd npp02:",1)  #No.FUN-660136
           END IF
           #FUN-E80012---add---str---
           SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
           IF g_nmz.nmz70 = '3' THEN
              LET l_tic01=s_get_aznn(g_plant,g_bookno1,g_fbg.fbg02,1)
              LET l_tic02=s_get_aznn(g_plant,g_bookno1,g_fbg.fbg02,3)
              UPDATE tic_file SET tic01=l_tic01,
                                  tic02=l_tic02
              WHERE tic04=g_fbg.fbg01
              IF STATUS THEN
                 CALL cl_err3("upd","tic_file",g_fbg.fbg01,"",STATUS,"","upd tic01,tic02:",1)
              END IF
           END IF
           #FUN-E80012---add---end---
        END IF
        DISPLAY BY NAME g_fbg.fbg10
        IF g_fbg.fbgconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        IF g_fbg.fbg10 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
        CALL cl_set_field_pic(g_fbg.fbgconf,g_chr2,g_fbg.fbgpost,"",g_chr,"")
        EXIT WHILE
    END WHILE
    CLOSE t108_cl
    COMMIT WORK
    CALL cl_flow_notify(g_fbg.fbg01,'U')
END FUNCTION
 
FUNCTION t108_npp02(p_npptype)
  DEFINE p_npptype   LIKE npp_file.npptype     #No.FUN-680028
  DEFINE l_tic01     LIKE tic_file.tic01       #FUN-E80012 add
  DEFINE l_tic02     LIKE tic_file.tic02       #FUN-E80012 add
 
  IF p_npptype = "0" THEN   #FUN-B60140   Add
     IF g_fbg.fbg08 IS NULL OR g_fbg.fbg08=' ' THEN
        UPDATE npp_file SET npp02=g_fbg.fbg02
         WHERE npp01=g_fbg.fbg01 AND npp00=g_fbg00 AND npp011=1    #No.MOD-480036
           AND nppsys = 'FA'
           AND npptype = p_npptype     #No.FUN-680028
         IF STATUS THEN 
            CALL cl_err3("upd","npp_file",g_fbg.fbg01,g_fbg00,STATUS,"","upd npp02:",1)  #No.FUN-660136
         END IF
         #FUN-E80012---add---str---
         SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
         IF g_nmz.nmz70 = '3' THEN
            LET l_tic01=s_get_aznn(g_plant,g_bookno1,g_fbg.fbg02,1)
            LET l_tic02=s_get_aznn(g_plant,g_bookno1,g_fbg.fbg02,3)
            UPDATE tic_file SET tic01=l_tic01,
                                tic02=l_tic02
            WHERE tic04=g_fbg.fbg01
            IF STATUS THEN
               CALL cl_err3("upd","tic_file",g_fbg.fbg01,"",STATUS,"","upd tic01,tic02:",1)
            END IF
         END IF
         #FUN-E80012---add---end---
      END IF
  #FUN-B60140   ---start   Add
     ELSE
        IF g_fbg.fbg082 IS NULL OR g_fbg.fbg082=' ' THEN
           UPDATE npp_file SET npp02=g_fbg.fbg02
            WHERE npp01=g_fbg.fbg01 AND npp00=g_fbg00 AND npp011=1    #No:MOD-480036
              AND nppsys = 'FA'
              AND npptype = p_npptype     #No.FUN-680028
           IF STATUS THEN
             CALL cl_err3("upd","npp_file",g_fbg.fbg01,g_fbg00,STATUS,"","upd npp02:",1)  #No.FUN-660136
           END IF
           #FUN-E80012---add---str---
           SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
           IF g_nmz.nmz70 = '3' THEN
              LET l_tic01=s_get_aznn(g_plant,g_bookno1,g_fbg.fbg02,1)
              LET l_tic02=s_get_aznn(g_plant,g_bookno1,g_fbg.fbg02,3)
              UPDATE tic_file SET tic01=l_tic01,
                                  tic02=l_tic02
              WHERE tic04=g_fbg.fbg01
              IF STATUS THEN
                 CALL cl_err3("upd","tic_file",g_fbg.fbg01,"",STATUS,"","upd tic01,tic02:",1)
              END IF
           END IF
           #FUN-E80012---add---end---
        END IF
     END IF
    #FUN-B60140   ---end     Add
END FUNCTION
 
FUNCTION t108_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1     #a:輸入 u:更改       #No.FUN-680070 VARCHAR(1)
  DEFINE l_flag          LIKE type_file.chr1     #判斷必要欄位是否有輸入       #No.FUN-680070 VARCHAR(1)
  DEFINE l_bdate,l_edate LIKE type_file.dat      #No.FUN-680070 DATE
  DEFINE li_result   LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
   CALL cl_set_head_visible("","YES")            #No.FUN-6B0029 
 
   INPUT BY NAME g_fbg.fbgoriu,g_fbg.fbgorig,
        g_fbg.fbg01,g_fbg.fbg02,g_fbg.fbg03,
        g_fbg.fbg04,g_fbg.fbg05,g_fbg.fbg08,g_fbg.fbg09,g_fbg.fbg082,g_fbg.fbg092, #FUN-B60140   Add fbg082 fbg092
        g_fbg.fbgconf,g_fbg.fbgpost,g_fbg.fbgpost2,
        g_fbg.fbgmksg,g_fbg.fbg10,   #FUN-580109
        g_fbg.fbguser,g_fbg.fbggrup,g_fbg.fbgmodu,g_fbg.fbgdate,
        g_fbg.fbgud01,g_fbg.fbgud02,g_fbg.fbgud03,g_fbg.fbgud04,
        g_fbg.fbgud05,g_fbg.fbgud06,g_fbg.fbgud07,g_fbg.fbgud08,
        g_fbg.fbgud09,g_fbg.fbgud10,g_fbg.fbgud11,g_fbg.fbgud12,
        g_fbg.fbgud13,g_fbg.fbgud14,g_fbg.fbgud15 
           WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t108_set_entry(p_cmd)
            CALL t108_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
         CALL cl_set_docno_format("fbg01")
             
        AFTER FIELD fbg01
           IF p_cmd = 'a' OR
              (p_cmd = 'u' AND g_fbg.fbg01 != g_fbg_t.fbg01) THEN #No.MOD-470541
            IF NOT cl_null(g_fbg.fbg01) THEN
    CALL s_check_no("afa",g_fbg.fbg01,g_fbg_t.fbg01,g_fbg00,"fbg_file","fbg01","")
         RETURNING li_result,g_fbg.fbg01
    DISPLAY BY NAME g_fbg.fbg01
       IF (NOT li_result) THEN
          NEXT FIELD fbg01
       END IF
               SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
            END IF
          END IF
         #start FUN-580109 帶出單據別設定的"簽核否"值,狀況碼預設為0
          SELECT fahapr,'0' INTO g_fbg.fbgmksg,g_fbg.fbg10
            FROM fah_file
           WHERE fahslip = g_t1
          IF cl_null(g_fbg.fbgmksg) THEN            #FUN-640243
               LET g_fbg.fbgmksg = 'N'
          END IF
 
          DISPLAY BY NAME g_fbg.fbgmksg,g_fbg.fbg10
          LET g_fbg_o.fbg01 = g_fbg.fbg01
 
        AFTER FIELD fbg02
           IF NOT cl_null(g_fbg.fbg02) THEN
              CALL s_azn01(g_faa.faa07,g_faa.faa08) RETURNING l_bdate,l_edate
              IF g_fbg.fbg02 < l_bdate THEN
                 CALL cl_err(g_fbg.fbg02,'afa-130',0)
                 NEXT FIELD fbg02
              END IF
              IF g_fbg.fbg02 <= g_faa.faa09 THEN
                 CALL cl_err('','mfg9999',1)
                 NEXT FIELD fbg02
              END IF
              #FUN-B60140   ---start   Add
                IF g_faa.faa31 = "Y" THEN
                   CALL s_azn01(g_faa.faa072,g_faa.faa082) RETURNING l_bdate,l_edate
                  IF g_fbg.fbg02 < l_bdate THEN
                     CALL cl_err(g_fbg.fbg02,'afa-130',0)
                     NEXT FIELD fbg02
                  END IF
                  IF g_fbg.fbg02 <= g_faa.faa092 THEN
                     CALL cl_err('','mfg9999',1)
                     NEXT FIELD fbg02
                  END IF
               END IF
              #FUN-B60140   ---end     Add
           END IF
 
        AFTER FIELD fbg03
            IF NOT cl_null(g_fbg.fbg03) THEN
               CALL t108_fbg03('a')
               IF NOT cl_null(g_errno) THEN
                  LET g_fbg.fbg03 = g_fbg_t.fbg03
                  CALL cl_err(g_fbg.fbg03,g_errno,0)
                  DISPLAY BY NAME g_fbg.fbg03 #
                  NEXT FIELD fbg03
               END IF
            END IF
 
        AFTER FIELD fbg04
            IF NOT cl_null(g_fbg.fbg04) THEN
               CALL t108_fbg04('a')
               IF NOT cl_null(g_errno) THEN
                  LET g_fbg.fbg04 = g_fbg_t.fbg04
                  CALL cl_err(g_fbg.fbg04,g_errno,0)
                  DISPLAY BY NAME g_fbg.fbg04 #
                  NEXT FIELD fbg04
               END IF
            END IF
 
        AFTER FIELD fbgud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbgud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbgud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbgud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbgud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbgud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbgud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbgud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbgud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbgud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbgud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbgud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbgud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbgud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbgud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT  #97/05/22 modify
           LET g_fbg.fbguser = s_get_data_owner("fbg_file") #FUN-C10039
           LET g_fbg.fbggrup = s_get_data_group("fbg_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION controlp
           CASE
            WHEN INFIELD(fbg01) #查詢單据
                 LET g_t1 = s_get_doc_no(g_fbg.fbg01)       #No.FUN-550034
                  CALL q_fah(FALSE,TRUE,g_t1,g_fbg00,'AFA') RETURNING g_t1                     #TQC-670008
                 LET g_fbg.fbg01 = g_t1       #No.FUN-550034
                 DISPLAY BY NAME g_fbg.fbg01 #
                 NEXT FIELD fbg01
            WHEN INFIELD(fbg03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_fbg.fbg03
                 CALL cl_create_qry() RETURNING g_fbg.fbg03
                 DISPLAY BY NAME g_fbg.fbg03
                 NEXT FIELD fbg03
            WHEN INFIELD(fbg04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_fbg.fbg04
                 CALL cl_create_qry() RETURNING g_fbg.fbg04
                 DISPLAY BY NAME g_fbg.fbg04
                 NEXT FIELD fbg04
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
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
    END INPUT
END FUNCTION
 
FUNCTION t108_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("fbg01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t108_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("fbg01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t108_fbg03(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_gen02    LIKE gen_file.gen02,
       l_gen03    LIKE gen_file.gen03,             #No:7381
       l_genacti  LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti    #No:7381
      FROM gen_file
     WHERE gen01 = g_fbg.fbg03
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-110'
                                LET l_gen02 = NULL
                                LET l_genacti = NULL
       WHEN l_genacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd'
    THEN DISPLAY l_gen02 TO FORMONLY.gen02
    END IF
    IF cl_null(g_errno) AND p_cmd = 'a' AND cl_null(g_fbg.fbg04) THEN
       LET g_fbg.fbg04=l_gen03
       DISPLAY BY NAME g_fbg.fbg04   #No:9373
    END IF
END FUNCTION
 
FUNCTION t108_fbg04(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_gem02    LIKE gem_file.gem02,
       l_gemacti  LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gem02,gemacti INTO l_gem02,l_gemacti
      FROM gem_file
     WHERE gem01 = g_fbg.fbg04
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-083'
                                LET l_gem02 = NULL
                                LET l_gemacti = NULL
       WHEN l_gemacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd'
    THEN DISPLAY l_gem02 TO FORMONLY.gem02
    END IF
END FUNCTION
 
FUNCTION t108_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fbg.* TO NULL             #No.FUN-6A0001
    CALL cl_msg("")                              #FUN-640243
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t108_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 INITIALIZE g_fbg.* TO NULL RETURN END IF
    CALL cl_msg(" SEARCHING ! ")                 #FUN-640243
    OPEN t108_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_fbg.* TO NULL
    ELSE
        OPEN t108_count
        FETCH t108_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t108_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    CALL cl_msg("")                              #FUN-640243
 
END FUNCTION
 
FUNCTION t108_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t108_cs INTO g_fbg.fbg01
        WHEN 'P' FETCH PREVIOUS t108_cs INTO g_fbg.fbg01
        WHEN 'F' FETCH FIRST    t108_cs INTO g_fbg.fbg01
        WHEN 'L' FETCH LAST     t108_cs INTO g_fbg.fbg01
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
            FETCH ABSOLUTE g_jump t108_cs INTO g_fbg.fbg01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbg.fbg01,SQLCA.sqlcode,0)
        INITIALIZE g_fbg.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_fbg.* FROM fbg_file WHERE fbg01 = g_fbg.fbg01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","fbg_file",g_fbg.fbg01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
        INITIALIZE g_fbg.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_fbg.fbguser   #FUN-4C0059
    LET g_data_group = g_fbg.fbggrup   #FUN-4C0059
    CALL t108_show()
END FUNCTION
 
FUNCTION t108_show()
    LET g_fbg_t.* = g_fbg.*                #保存單頭舊值
    DISPLAY BY NAME g_fbg.fbgoriu,g_fbg.fbgorig,
        g_fbg.fbg01,g_fbg.fbg02,g_fbg.fbg03,g_fbg.fbg04,
        g_fbg.fbg05,g_fbg.fbg08,g_fbg.fbg09,g_fbg.fbg082,g_fbg.fbg092,   #FUN-B60140   add fbg082 fbg092
        g_fbg.fbgconf,g_fbg.fbgpost,g_fbg.fbgpost2,
        g_fbg.fbgmksg,g_fbg.fbg10,   #FUN-580109 增加簽核,狀況碼
        g_fbg.fbguser,g_fbg.fbggrup,g_fbg.fbgmodu,g_fbg.fbgdate,
        g_fbg.fbgud01,g_fbg.fbgud02,g_fbg.fbgud03,g_fbg.fbgud04,
        g_fbg.fbgud05,g_fbg.fbgud06,g_fbg.fbgud07,g_fbg.fbgud08,
        g_fbg.fbgud09,g_fbg.fbgud10,g_fbg.fbgud11,g_fbg.fbgud12,
        g_fbg.fbgud13,g_fbg.fbgud14,g_fbg.fbgud15 
    IF g_fbg.fbgconf='X' THEN
        LET g_void='Y' ELSE LET g_void='N'  #No.MOD-470541
    END IF
    IF g_fbg.fbg10 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_fbg.fbgconf,g_chr2,g_fbg.fbgpost,"",g_void,"")
    LET g_t1 = s_get_doc_no(g_fbg.fbg01)       #No.FUN-550034
    SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
    CALL t108_fbg03('d')
    CALL t108_fbg04('d')
    CALL t108_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t108_r()
DEFINE  l_seq   LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fbg.fbg01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_fbg.* FROM fbg_file WHERE fbg01 = g_fbg.fbg01
    IF g_fbg.fbgconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_fbg.fbgpost = 'Y' THEN CALL cl_err('','afa-101',0) RETURN END IF
    IF g_fbg.fbgconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    #-->已拋轉票不可刪除
    IF not cl_null(g_fbg.fbg08) THEN
       CALL cl_err('','afa-311',0)
       RETURN
    END IF
    #FUN-B60140   ---start   Add
     IF g_faa.faa31 = "Y" THEN
       #-->已拋轉票不可刪除
        IF NOT cl_null(g_fbg.fbg082) THEN
           CALL cl_err('','afa-311',0)
           RETURN
        END IF
     END IF
    #FUN-B60140   ---end     Add
    IF g_fbg.fbg10 matches '[Ss1]' THEN
       CALL cl_err('','mfg3557',0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN t108_cl USING g_fbg.fbg01
    IF STATUS THEN
       CALL cl_err("OPEN t108_cl:", STATUS, 1)
       CLOSE t108_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t108_cl INTO g_fbg.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_fbg.fbg01,SQLCA.sqlcode,0)
       CLOSE t108_cl ROLLBACK WORK RETURN
    END IF
    CALL t108_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fbg01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fbg.fbg01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        MESSAGE "Delete fbg,fbh!"
        DELETE FROM fbg_file WHERE fbg01 = g_fbg.fbg01
        IF SQLCA.SQLERRD[3]=0 THEN
             CALL cl_err3("del","fbg_file",g_fbg.fbg01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
           ELSE CLEAR FORM
           CALL g_fbh.clear()
        END IF
        DELETE FROM fbh_file WHERE fbh01 = g_fbg.fbg01
         IF g_fbg00='5' THEN LET l_seq = 5 ELSE LET l_seq =6  END IF    #No.MOD-480036
        DELETE FROM npp_file WHERE nppsys = 'FA' AND npp00 = l_seq
                               AND npp01 = g_fbg.fbg01
                               AND npp011= 1
        DELETE FROM npq_file WHERE npqsys = 'FA' AND npq00 = l_seq
                               AND npq01 = g_fbg.fbg01
                               AND npq011= 1    #No:9891
        #FUN-B40056--add--str--
        DELETE FROM tic_file WHERE tic04 = g_fbg.fbg01
        #FUN-B40056--add--end--
        LET g_msg=TIME
        CLEAR FORM
        CALL g_fbh.clear()
    	INITIALIZE g_fbg.* TO NULL
        MESSAGE ""
        OPEN t108_count
        #FUN-B50062-add-start--
        IF STATUS THEN
           CLOSE t108_cl
           CLOSE t108_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        FETCH t108_count INTO g_row_count
        #FUN-B50062-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE t108_cl
           CLOSE t108_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end-- 
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t108_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t108_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL t108_fetch('/')
        END IF
 
    END IF
    CLOSE t108_cl
    COMMIT WORK
    CALL cl_flow_notify(g_fbg.fbg01,'D')
END FUNCTION
 
FUNCTION t108_b()
DEFINE l_fbh06         LIKE fbh_file.fbh06,
       l_fbh07         LIKE fbh_file.fbh07,
       l_fbh08         LIKE fbh_file.fbh08,
       l_fbh09         LIKE fbh_file.fbh09,
       l_fbh10         LIKE fbh_file.fbh10,
       l_fbh11         LIKE fbh_file.fbh11,
       l_fbh12         LIKE fbh_file.fbh12,   #No:A099
       l_fbh13         LIKE fbh_file.fbh13,   #No:A099
       l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
       l_row,l_col     LIKE type_file.num5,  	           #分段輸入之行,列數       #No.FUN-680070 SMALLINT
       l_n,l_cnt       LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
       l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
       l_edate         LIKE type_file.dat,          #No.FUN-680070 DATE
       l_flag          LIKE type_file.num10,        #No.FUN-680070 INTEGER
       l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
       l_allow_delete  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT
DEFINE l_fbg10         LIKE fbg_file.fbg10    #FUN-580109
#DEFINE l_fca15         LIKE fca_file.fca15    #TQC-670005   #MOD-810261
DEFINE l_cnt1          LIKE type_file.num5    #FUN-AB0088
  DEFINE l_fbh04     LIKE fbh_file.fbh04    #No:FUN-BB0122
  DEFINE l_fbh062    LIKE fbh_file.fbh062   #No:FUN-BB0122
  DEFINE l_fbh072    LIKE fbh_file.fbh072   #No:FUN-BB0122
  DEFINE l_fbh082    LIKE fbh_file.fbh082   #No:FUN-BB0122
  DEFINE l_fbh122    LIKE fbh_file.fbh122   #No:FUN-BB0122
  DEFINE l_faj17       LIKE faj_file.faj17    #MOD-CA0239 add
  DEFINE l_faj58       LIKE faj_file.faj58    #MOD-CA0239 add


    LET g_action_choice = ""
    LET l_fbg10 = g_fbg.fbg10   #FUN-580109
    IF g_fbg.fbg01 IS NULL THEN RETURN END IF
    IF g_fbg.fbgconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_fbg.fbgconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_fbg.fbgpost = 'Y' THEN CALL cl_err('','afa-101',0) RETURN END IF
    IF g_fbg.fbg10 matches '[Ss]' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT fbh02,fbh03,fbh031,'','',fbh04,fbh05,",
                       "        fbh06,fbh07,fbh08,fbh12, ",  #end No:A099
                       "        fbhud01,fbhud02,fbhud03,fbhud04,fbhud05,",
                       "        fbhud06,fbhud07,fbhud08,fbhud09,fbhud10,",
                       "        fbhud11,fbhud12,fbhud13,fbhud14,fbhud15 ", 
                       " FROM fbh_file ",
                       " WHERE fbh01= ? AND fbh02= ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t108_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
      LET l_ac_t = 0
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
   IF g_rec_b=0 THEN CALL g_fbh.clear() END IF
 
 
      INPUT ARRAY g_fbh WITHOUT DEFAULTS FROM s_fbh.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN t108_cl USING g_fbg.fbg01
            IF STATUS THEN
               CALL cl_err("OPEN t108_cl:", STATUS, 1)
               CLOSE t108_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t108_cl INTO g_fbg.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_fbg.fbg01,SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE t108_cl ROLLBACK WORK RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_fbh_t.* = g_fbh[l_ac].*         #BACKUP
 
                OPEN t108_bcl USING g_fbg.fbg01,g_fbh_t.fbh02
                IF STATUS THEN
                   CALL cl_err("OPEN t108_bcl:", STATUS, 1)
                   CLOSE t108_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t108_bcl INTO g_fbh[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err('lock fbh',SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                IF l_ac <= l_n then                   #DISPLAY NEWEST
                   SELECT faj06,faj18 INTO g_fbh[l_ac].faj06,g_fbh[l_ac].faj18
                     FROM faj_file
                    WHERE faj02=g_fbh[l_ac].fbh03
                      AND faj022=g_fbh[l_ac].fbh031             #MOD-AA0012
                    LET g_fbh_t.faj06 =g_fbh[l_ac].faj06
                    LET g_fbh_t.faj18 =g_fbh[l_ac].faj18
                    DISPLAY g_fbh[l_ac].faj06 TO faj06
                    DISPLAY g_fbh[l_ac].faj18 TO faj18
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              INITIALIZE g_fbh[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_fbh[l_ac].* TO s_fbh.*
              CALL g_fbh.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
            END IF
         IF cl_null(g_fbh[l_ac].fbh031) THEN
            LET g_fbh[l_ac].fbh031 = ' '
         END IF
            #-----No:FUN-BB0122-----
            SELECT (faj17-faj582),(faj142+faj1412-faj592),
                   (faj322-faj602),(faj1012-faj1022)
              INTO l_fbh04,l_fbh062,l_fbh072,l_fbh122
              FROM faj_file
             WHERE faj02 = g_fbh[l_ac].fbh03
               AND faj022= g_fbh[l_ac].fbh031
            IF cl_null(l_fbh04) OR l_fbh04 = 0 THEN
               LET l_fbh04 = g_fbh[l_ac].fbh04
            END IF

            IF g_fbh[l_ac].fbh04 > 0 THEN
                LET l_fbh072 =l_fbh072*(g_fbh[l_ac].fbh04/l_fbh04)
                #LET l_fbh072 =cl_digcut(l_fbh072,g_azi04)          #C60010 mark
                LET l_fbh062 =l_fbh062*(g_fbh[l_ac].fbh04/l_fbh04)
                #LET l_fbh062 =cl_digcut(l_fbh062,g_azi04)          #C60010 mark
                LET l_fbh122 = l_fbh122*(g_fbh[l_ac].fbh04/l_fbh04)
                #LET l_fbh122 =cl_digcut(l_fbh122,g_azi04)          #C60010 mark
            END IF
            IF cl_null(l_fbh062) THEN LET l_fbh062=0 END IF
            IF cl_null(l_fbh072) THEN LET l_fbh072=0 END IF
            IF cl_null(l_fbh122) THEN LET l_fbh122=0 END IF
            #-----No:FUN-BB0122 End-----
           #CHI-C60010---str---
            CALL cl_digcut(l_fbh072,g_azi04_1) RETURNING l_fbh072
            CALL cl_digcut(l_fbh062,g_azi04_1) RETURNING l_fbh062
            CALL cl_digcut(l_fbh122,g_azi04_1) RETURNING l_fbh122
           #CHI-C60010---end---
            INSERT INTO fbh_file(fbh01,fbh02,fbh03,fbh031,fbh04,fbh05,
                                 fbh06,fbh07,fbh08,fbh09,fbh10,fbh11,
                                 fbh12,fbh13,
                                 fbhud01,fbhud02,fbhud03,
                                 fbhud04,fbhud05,fbhud06,
                                 fbhud07,fbhud08,fbhud09,
                                 fbhud10,fbhud11,fbhud12,
                                 fbhud13,fbhud14,fbhud15,
                                 fbh062,fbh072,fbh082,fbh122,   #FUN-AB0088
                                 fbhlegal) #FUN-980003 add
                          VALUES(g_fbg.fbg01,g_fbh[l_ac].fbh02,
                                 g_fbh[l_ac].fbh03,g_fbh[l_ac].fbh031,
                                 g_fbh[l_ac].fbh04,g_fbh[l_ac].fbh05,
                                 g_fbh[l_ac].fbh06,g_fbh[l_ac].fbh07,
                                 g_fbh[l_ac].fbh08,g_fbh_e[l_ac].fbh09,
                                 g_fbh_e[l_ac].fbh10,g_fbh_e[l_ac].fbh11,
                                 g_fbh[l_ac].fbh12,g_fbh_e[l_ac].fbh13,
                                 g_fbh[l_ac].fbhud01,g_fbh[l_ac].fbhud02,
                                 g_fbh[l_ac].fbhud03,g_fbh[l_ac].fbhud04,
                                 g_fbh[l_ac].fbhud05,g_fbh[l_ac].fbhud06,
                                 g_fbh[l_ac].fbhud07,g_fbh[l_ac].fbhud08,
                                 g_fbh[l_ac].fbhud09,g_fbh[l_ac].fbhud10,
                                 g_fbh[l_ac].fbhud11,g_fbh[l_ac].fbhud12,
                                 g_fbh[l_ac].fbhud13,g_fbh[l_ac].fbhud14,
                                 g_fbh[l_ac].fbhud15,
                                 #0,0,0,0,    #FUN-AB0088 #No:FUN-BB0122 mark
                                 l_fbh062,l_fbh072,(l_fbh062-l_fbh072),l_fbh122, #No:FUN-BB0122 add
                                 g_legal) #FUN-980003 add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","fbh_file",g_fbg.fbg01,g_fbh[l_ac].fbh02,SQLCA.sqlcode,"","ins fbh",1)  #No.FUN-660136
              CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET l_fbg10 = '0'   #FUN-580109
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_fbh[l_ac].* TO NULL
            LET g_fbh_t.*=g_fbh[l_ac].*
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fbh02                  #跳下一ROW
 
        BEFORE FIELD fbh02                            #default 序號
            IF g_fbh[l_ac].fbh02 IS NULL OR g_fbh[l_ac].fbh02 = 0 THEN
                SELECT max(fbh02)+1 INTO g_fbh[l_ac].fbh02
                   FROM fbh_file WHERE fbh01 = g_fbg.fbg01
                IF g_fbh[l_ac].fbh02 IS NULL THEN
                    LET g_fbh[l_ac].fbh02 = 1
                END IF
            END IF
 
        AFTER FIELD fbh02                        #check 序號是否重複
            IF NOT cl_null(g_fbh[l_ac].fbh02) THEN
               IF g_fbh[l_ac].fbh02 != g_fbh_t.fbh02 OR g_fbh_t.fbh02 IS NULL THEN
                  SELECT count(*) INTO l_n FROM fbh_file
                     WHERE fbh01 = g_fbg.fbg01 AND fbh02 = g_fbh[l_ac].fbh02
                  IF l_n > 0 THEN
                     LET g_fbh[l_ac].fbh02 = g_fbh_t.fbh02
                     CALL cl_err('',-239,1)
                     NEXT FIELD fbh02
                  END IF
               END IF
            END IF

        #modify TQC-AB0206----begin-------------------
        AFTER FIELD fbh03
           IF g_fbh[l_ac].fbh03 != g_fbh_t.fbh03 OR
              g_fbh_t.fbh03 IS NULL THEN
              SELECT COUNT(*) INTO l_n FROM faj_file
               WHERE fajconf='Y'
                 AND faj02 = g_fbh[l_ac].fbh03
              IF l_n <= 0 THEN
                 LET g_fbh[l_ac].fbh03 = g_fbh_t.fbh03
                 CALL cl_err('','afa-911',0)
                 NEXT FIELD fbh03
              END IF
           END IF
        #modify TQC-AB0206-----end--------------------
    
        AFTER FIELD fbh031
            IF cl_null(g_fbh[l_ac].fbh031) THEN
               LET g_fbh[l_ac].fbh031=' '
            END IF

            #MOD-A40011 start---
           #----------------MOD-CA0239------------------(S)
           #--MOD-CA0239--mark
           #LET l_cnt = 0
           #SELECT COUNT(*) INTO l_cnt FROM fbg_file,fbh_file
           #  WHERE  fbg01=fbh01 AND fbh03=g_fbh[l_ac].fbh03 AND fbh031=g_fbh[l_ac].fbh031
           #     AND fbgconf<>'X'
           #     AND fbg01<>g_fbg.fbg01
           #IF l_cnt > 0 THEN
           #--MOD-CA0239--mark
            SELECT faj17,faj58 INTO l_faj17,l_faj58
              FROM faj_file
             WHERE faj02 = g_fbh[l_ac].fbh03
               AND faj022 = g_fbh[l_ac].fbh031
            IF l_faj17 - l_faj58 = 0 THEN
           #----------------MOD-CA0239------------------(E)
               CALL cl_err(g_fbh[l_ac].fbh03,'aec-010',0)
               LET g_fbh[l_ac].fbh03 =g_fbh_t.fbh03
               LET g_fbh[l_ac].fbh031=g_fbh_t.fbh031
               NEXT FIELD fbh03
            END IF
            #MOD-A40011 end---
           #--------------------MOD-CB0108--------------------(S)
            IF l_faj17 = 1 THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt
                 FROM fbe_file,fbf_file
                WHERE fbe01 = fbf01
                  AND fbf03 = g_fbh[l_ac].fbh03 
                  AND fbf031 = g_fbh[l_ac].fbh031 
                  AND fbeconf<>'X'
               IF l_cnt > 0 THEN
                  CALL cl_err(g_fbh[l_ac].fbh03,'afa-207',0)
                  LET g_fbh[l_ac].fbh03 = g_fbh_t.fbh03
                  LET g_fbh[l_ac].fbh031= g_fbh_t.fbh031
                  NEXT FIELD fbh03
               END IF
            END IF
           #--------------------MOD-CB0108--------------------(E)

            CALL t108_fbh03(p_cmd)                                #MOD-950166
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_fbh[l_ac].fbh031,g_errno,0)
               LET g_fbh[l_ac].fbh03 = g_fbh_t.fbh03              #MOD-950166
               LET g_fbh[l_ac].fbh031 = g_fbh_t.fbh031            #MOD-950166               
               NEXT FIELD fbh03
            END IF
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM fca_file 
              WHERE fca03=g_fbh[l_ac].fbh03 AND
                    fca031=g_fbh[l_ac].fbh031 AND
                    fca15='N' 
            IF l_cnt > 0 THEN
               CALL cl_err(g_fbh[l_ac].fbh03,'afa-097',0)
               LET g_fbh[l_ac].fbh03 =g_fbh_t.fbh03    #MOD-A10130 add
               LET g_fbh[l_ac].fbh031=g_fbh_t.fbh031   #MOD-A10130 add
               NEXT FIELD fbh03
            END IF
           #--------------------MOD-C80254--------------------(S)
            IF l_ac > 1 THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM fbh_file
                WHERE fbh01 = g_fbg.fbg01
                  AND fbh03 = g_fbh[l_ac].fbh03
                  AND fbh031 = g_fbh[l_ac].fbh031
               IF l_cnt > 0 THEN
                  CALL cl_err(g_fbh[l_ac].fbh03,'afa-053',0)
                  LET g_fbh[l_ac].fbh03 = g_fbh_t.fbh03
                  LET g_fbh[l_ac].fbh031 = g_fbh_t.fbh031
                  NEXT FIELD fbh03
               END IF
            END IF
           #--------------------MOD-C80254--------------------(E)
            IF g_faa.faa23 = 'N' THEN
               SELECT COUNT(*) INTO l_cnt FROM fan_file
                WHERE fan01 = g_fbh[l_ac].fbh03
                  AND fan02 = g_fbh[l_ac].fbh031
                  AND ((fan03 = YEAR(g_fbg.fbg02) AND fan04 >= MONTH(g_fbg.fbg02))
                   OR fan03 > YEAR(g_fbg.fbg02))
                  AND fan041 = '1'   #MOD-BC0025 add
              #FUN-B60140   ---start   Mark 
              #FUN-AB0088---add---str---
              #LET l_cnt1 = 0 
              #IF g_faa.faa31 = 'Y' THEN
              #    SELECT COUNT(*) INTO l_cnt1 FROM fbn_file
              #     WHERE fbn01 = g_fbh[l_ac].fbh03
              #       AND fbn02 = g_fbh[l_ac].fbh031
              #       AND ((fbn03 = YEAR(g_fbg.fbg02) AND fbn04 >= MONTH(g_fbg.fbg02))
              #        OR fbn03 > YEAR(g_fbg.fbg02))
              #END IF
              #LET l_cnt = l_cnt + l_cnt1
              ##FUN-AB0088---add---end---
               #FUN-B60140   ---end     Mark
               IF l_cnt > 0 THEN
                  CALL cl_err(g_fbh[l_ac].fbh03,'afa-092',0)
                  NEXT FIELD fbh03
               END IF

            END IF
           
            #FUN-B60140   ---start   Add
             IF g_faa.faa31 = "Y" THEN
                IF g_faa.faa232 = 'N' THEN
                   LET l_cnt1 = 0
                   SELECT COUNT(*) INTO l_cnt1 FROM fbn_file
                   WHERE fbn01 = g_fbh[l_ac].fbh03
                     AND fbn02 = g_fbh[l_ac].fbh031
                      AND ((fbn03 = YEAR(g_fbg.fbg02) AND fbn04 >= MONTH(g_fbg.fbg02))
                       OR fbn03 > YEAR(g_fbg.fbg02))
                     AND fbn041 = '1'   #MOD-BC0025 add
                   IF l_cnt1> 0 THEN
                      CALL cl_err(g_fbh[l_ac].fbh03,'afa-092',0)
                      NEXT FIELD fbh03
                   END IF
                END IF
             END IF
            #FUN-B60140   ---end     Add
  
            #-->免稅資料
            IF g_faj40 = '3' THEN
               LET g_errno = 'afa-305'
               CALL cl_err(g_fbh[l_ac].fbh03,g_errno,1)
            END IF
            #-->投減三年內不可出售
            IF g_faj42 = '3' THEN
               LET l_edate = MDY(MONTH(g_faj26),DAY(g_faj26),YEAR(g_faj26)+3)
               IF g_fbg.fbg02 < l_edate
               THEN LET g_errno = 'afa-306'
                    CALL cl_err(g_fbh[l_ac].fbh03,g_errno,1)
               END IF
            END IF
          SELECT faj06 INTO g_fbh[l_ac].faj06 FROM faj_file
            WHERE faj02  = g_fbh[l_ac].fbh03 AND
                  (faj022 = g_fbh[l_ac].fbh031 OR faj022 IS NULL)
          DISPLAY BY NAME g_fbh[l_ac].faj06
 
        AFTER FIELD fbh04
            IF NOT cl_null(g_fbh[l_ac].fbh04) THEN
              #IF g_fbh[l_ac].fbh04 < 0 THEN                     #MOD-CA0239 mark
               IF g_fbh[l_ac].fbh04 <= 0 THEN                    #MOD-CA0239 add
                  CALL cl_err(g_fbh[l_ac].fbh03,'asf-230',0)     #MOD-CA0239 add
                  NEXT FIELD fbh04
               END IF
               IF p_cmd = 'u' THEN
                  CALL t108_fbh03('d')
               END IF
               IF g_fbh[l_ac].fbh04 > g_fbh04 THEN
                  CALL cl_err(g_fbh[l_ac].fbh04,'afa-109',0)
                  NEXT FIELD fbh04
               END IF
               IF g_fbh[l_ac].fbh04 > 0 THEN
                  IF p_cmd = 'a' OR
                     (p_cmd = 'u' AND g_fbh[l_ac].fbh04 !=g_fbh_t.fbh04) THEN
                      LET l_fbh06=g_fbh06*(g_fbh[l_ac].fbh04/g_fbh04)
                      LET l_fbh06 = cl_digcut(l_fbh06,g_azi04)   #TQC-780089
                      LET l_fbh07=g_fbh07*(g_fbh[l_ac].fbh04/g_fbh04)
                      LET l_fbh07 = cl_digcut(l_fbh07,g_azi04)   #TQC-780089
                      LET l_fbh08=l_fbh06 - l_fbh07
                      LET l_fbh08 = cl_digcut(l_fbh08,g_azi04)   #TQC-780089
                      LET g_fbh[l_ac].fbh06=l_fbh06
                      LET g_fbh[l_ac].fbh07=l_fbh07
                      LET g_fbh[l_ac].fbh08=l_fbh08
                      LET l_fbh12=g_fbh12*(g_fbh[l_ac].fbh04/g_fbh04)
                      LET l_fbh12 = cl_digcut(l_fbh12,g_azi04)
                      LET g_fbh[l_ac].fbh12=l_fbh12
                  END IF
               END IF
               #--->稅簽資料
               IF g_fbh[l_ac].fbh04 > 0 THEN
                   LET l_fbh09=g_fbh09 *(g_fbh[l_ac].fbh04/g_fbh04)
                   LET l_fbh10=g_fbh10 *(g_fbh[l_ac].fbh04/g_fbh04)
                   LET l_fbh11=l_fbh09 - l_fbh10
                   LET g_fbh_e[l_ac].fbh09=l_fbh09
                   LET g_fbh_e[l_ac].fbh10=l_fbh10
                   LET g_fbh_e[l_ac].fbh11=l_fbh11
                   LET l_fbh13=g_fbh13 *(g_fbh[l_ac].fbh04/g_fbh04)
                   LET g_fbh_e[l_ac].fbh13=l_fbh13
               END IF
           ELSE                                          #MOD-B30014 
              CALL cl_err(g_fbh[l_ac].fbh04,'aim-927',0) #MOD-B30014
              NEXT FIELD fbh04                           #MOD-B30014
            END IF
 
        BEFORE FIELD fbh05
            IF p_cmd = 'a' AND l_ac >1 THEN
               LET g_fbh[l_ac].fbh05 = g_fbh[l_ac-1].fbh05
               DISPLAY BY NAME g_fbh[l_ac].fbh05
            END IF
 
        AFTER FIELD fbh05
            IF NOT cl_null(g_fbh[l_ac].fbh05) THEN
               SELECT * FROM fag_file WHERE fag01=g_fbh[l_ac].fbh05
                                         AND fag02=g_fbg00            #No.MOD-480036
               IF STATUS=100 THEN
                  CALL cl_err3("sel","fag_file",g_fbh[l_ac].fbh05,g_fbg00,"afa-099","","",1)  #No.FUN-660136
                  NEXT FIELD fbh05
               END IF
            END IF
 
        AFTER FIELD fbh06
           IF NOT cl_null(g_fbh[l_ac].fbh06) THEN        #MOD-B30014 
              IF g_fbh[l_ac].fbh06<0 THEN
                 CALL cl_err('','mfg4012',0)
                 NEXT FIELD fbh06
              END IF
          #-MOD-B30014-add-
           ELSE                                          
              CALL cl_err(g_fbh[l_ac].fbh06,'aim-927',0) 
              NEXT FIELD fbh06                         
           END IF
          #-MOD-B30014-end-
 
        AFTER FIELD fbh07
           IF NOT cl_null(g_fbh[l_ac].fbh07) THEN        #MOD-B30014 
              IF g_fbh[l_ac].fbh07<0 THEN
                 CALL cl_err('','mfg4012',0)
                 NEXT FIELD fbh07
              END IF
          #-MOD-B30014-add-
           ELSE                                          
              CALL cl_err(g_fbh[l_ac].fbh07,'aim-927',0) 
              NEXT FIELD fbh07
           END IF
          #-MOD-B30014-end-
 
        AFTER FIELD fbh08
           IF NOT cl_null(g_fbh[l_ac].fbh08) THEN        #MOD-B30014 
              IF g_fbh[l_ac].fbh08<0 THEN
                 CALL cl_err('','mfg4012',0)
                 NEXT FIELD fbh08
              END IF
          #-MOD-B30014-add-
           ELSE                                          
              CALL cl_err(g_fbh[l_ac].fbh08,'aim-927',0) 
              NEXT FIELD fbh08
           END IF
          #-MOD-B30014-end-
       
        AFTER FIELD fbh12
           IF NOT cl_null(g_fbh[l_ac].fbh12) THEN        #MOD-B30014 
              IF g_fbh[l_ac].fbh12<0 THEN
                 CALL cl_err('','mfg4012',0)
                 NEXT FIELD fbh12
              END IF
          #-MOD-B30014-add-
           ELSE                                          
              CALL cl_err(g_fbh[l_ac].fbh12,'aim-927',0) 
              NEXT FIELD fbh12
           END IF
          #-MOD-B30014-end-
 
        AFTER FIELD fbhud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbhud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbhud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbhud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbhud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbhud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbhud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbhud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbhud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbhud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbhud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbhud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbhud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbhud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbhud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_fbh_t.fbh02 > 0 AND g_fbh_t.fbh02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM fbh_file
                   WHERE fbh01 = g_fbg.fbg01 AND fbh02 = g_fbh_t.fbh02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","fbh_file",g_fbg.fbg01,g_fbh_t.fbh02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
		COMMIT WORK
                LET l_fbg10 = '0'   #FUN-580109
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fbh[l_ac].* = g_fbh_t.*
               CLOSE t108_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fbh[l_ac].fbh02,-263,1)
               LET g_fbh[l_ac].* = g_fbh_t.*
            ELSE
               UPDATE fbh_file SET
                  fbh02=g_fbh[l_ac].fbh02,   fbh03=g_fbh[l_ac].fbh03,
                  fbh031=g_fbh[l_ac].fbh031, fbh04=g_fbh[l_ac].fbh04,
                  fbh05=g_fbh[l_ac].fbh05,   fbh06=g_fbh[l_ac].fbh06,
                  fbh07=g_fbh[l_ac].fbh07,   fbh08=g_fbh[l_ac].fbh08,
                  fbh09=g_fbh_e[l_ac].fbh09, fbh10=g_fbh_e[l_ac].fbh10,
                  fbh11=g_fbh_e[l_ac].fbh11, fbh12=g_fbh[l_ac].fbh12,  #No:A099
                  fbhud01 = g_fbh[l_ac].fbhud01,fbhud02 = g_fbh[l_ac].fbhud02,
                  fbhud03 = g_fbh[l_ac].fbhud03,fbhud04 = g_fbh[l_ac].fbhud04,
                  fbhud05 = g_fbh[l_ac].fbhud05,fbhud06 = g_fbh[l_ac].fbhud06,
                  fbhud07 = g_fbh[l_ac].fbhud07,fbhud08 = g_fbh[l_ac].fbhud08,
                  fbhud09 = g_fbh[l_ac].fbhud09,fbhud10 = g_fbh[l_ac].fbhud10,
                  fbhud11 = g_fbh[l_ac].fbhud11,fbhud12 = g_fbh[l_ac].fbhud12,
                  fbhud13 = g_fbh[l_ac].fbhud13,fbhud14 = g_fbh[l_ac].fbhud14,
                  fbhud15 = g_fbh[l_ac].fbhud15
                  WHERE fbh01=g_fbg.fbg01 AND fbh02=g_fbh_t.fbh02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","fbh_file",g_fbg.fbg01,g_fbh_t.fbh02,SQLCA.sqlcode,"","upd fbh",1)  #No.FUN-660136
                  LET g_fbh[l_ac].* = g_fbh_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  LET l_fbg10 = '0'   #FUN-580109
	          COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_fbh[l_ac].* = g_fbh_t.*
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_fbh.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF
               CLOSE t108_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032 add
            CLOSE t108_bcl
            COMMIT WORK
           #CALL g_fbh.deleteElement(g_rec_b+1) #FUN-D30032 mark
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fbh02) AND l_ac > 1 THEN
                LET g_fbh[l_ac].* = g_fbh[l_ac-1].*
                LET g_fbh[l_ac].fbh02 = NULL
                NEXT FIELD fbh02
            END IF
 
        ON ACTION mntn_depr_tax
           CALL t108_e(p_cmd)
 
        ON ACTION controlp
           CASE
            WHEN INFIELD(fbh03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.default1 = g_fbh[l_ac].fbh03
                 LET g_qryparam.default2 = g_fbh[l_ac].fbh031
                 CALL cl_create_qry() RETURNING
                                      g_fbh[l_ac].fbh03,g_fbh[l_ac].fbh031
                  DISPLAY g_fbh[l_ac].fbh03 TO fbh03    #No.MOD-490344
                 NEXT FIELD fbh03
            WHEN INFIELD(fbh031)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.default1 = g_fbh[l_ac].fbh03
                 LET g_qryparam.default2 = g_fbh[l_ac].fbh031
                 CALL cl_create_qry() RETURNING
                                      g_fbh[l_ac].fbh03,g_fbh[l_ac].fbh031
                  DISPLAY g_fbh[l_ac].fbh031 TO fbh031    #No.MOD-490344
                 NEXT FIELD fbh031
            WHEN INFIELD(fbh05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_fag"
                  LET g_qryparam.arg1 = g_fbg00 CLIPPED    #No.MOD-480036
                 LET g_qryparam.default1 = g_fbh[l_ac].fbh05
                 CALL cl_create_qry() RETURNING g_fbh[l_ac].fbh05
                 DISPLAY g_fbh[l_ac].fbh05 TO fbh05
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
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      END INPUT
 
      LET g_fbg.fbgmodu = g_user
      LET g_fbg.fbgdate = g_today
      UPDATE fbg_file SET fbgmodu = g_fbg.fbgmodu,fbgdate = g_fbg.fbgdate
       WHERE fbg01 = g_fbg.fbg01
      DISPLAY BY NAME g_fbg.fbgmodu,g_fbg.fbgdate
 
      SELECT COUNT(*) INTO g_cnt FROM fbh_file WHERE fbh01=g_fbg.fbg01
      UPDATE fbg_file SET fbg10=l_fbg10 WHERE fbg01 = g_fbg.fbg01
      LET g_fbg.fbg10 = l_fbg10
      DISPLAY BY NAME g_fbg.fbg10
      IF g_fbg.fbgconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
      IF g_fbg.fbg10 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
      CALL cl_set_field_pic(g_fbg.fbgconf,g_chr2,g_fbg.fbgpost,"",g_chr,"")
      CLOSE t108_bcl
      COMMIT WORK
      CALL t108_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t108_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_seq              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_fbg.fbg01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM fbg_file ",
                  "  WHERE fbg01 LIKE '",l_slip,"%' ",
                  "    AND fbg01 > '",g_fbg.fbg01,"'"
      PREPARE t108_pb1 FROM l_sql 
      EXECUTE t108_pb1 INTO l_cnt 
      
      
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
        #CALL t108_x()        #FUN-D20035
         CALL t108_x(1)           #FUN-D20035
      END IF 
      
      IF l_cho = 3 THEN 
         IF g_fbg00='5' THEN LET l_seq = 5 ELSE LET l_seq =6  END IF
         DELETE FROM npp_file WHERE nppsys = 'FA' AND npp00 = l_seq
                                AND npp01 = g_fbg.fbg01
                                AND npp011= 1
         DELETE FROM npq_file WHERE npqsys = 'FA' AND npq00 = l_seq
                                AND npq01 = g_fbg.fbg01
                                AND npq011= 1    
         DELETE FROM tic_file WHERE tic04 = g_fbg.fbg01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM fbg_file WHERE fbg01 = g_fbg.fbg01
         INITIALIZE g_fbg.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t108_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON fbh02,fbh03,fbh031,fbh04,fbh05,fbh06,fbh07,fbh08,fbh12,
                       faj06,faj18
                       ,fbhud01,fbhud02,fbhud03,fbhud04,fbhud05
                       ,fbhud06,fbhud07,fbhud08,fbhud09,fbhud10
                       ,fbhud11,fbhud12,fbhud13,fbhud14,fbhud15
                  FROM s_fbh[1].fbh02, s_fbh[1].fbh03, s_fbh[1].fbh031,
                       s_fbh[1].fbh04, s_fbh[1].fbh05, s_fbh[1].fbh06,
                       s_fbh[1].fbh07, s_fbh[1].fbh08, s_fbh[1].fbh12,
                       s_fbh[1].faj06, s_fbh[1].faj18
                       ,s_fbh[1].fbhud01,s_fbh[1].fbhud02,s_fbh[1].fbhud03
                       ,s_fbh[1].fbhud04,s_fbh[1].fbhud05,s_fbh[1].fbhud06
                       ,s_fbh[1].fbhud07,s_fbh[1].fbhud08,s_fbh[1].fbhud09
                       ,s_fbh[1].fbhud10,s_fbh[1].fbhud11,s_fbh[1].fbhud12
                       ,s_fbh[1].fbhud13,s_fbh[1].fbhud14,s_fbh[1].fbhud15
 
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t108_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t108_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    LET g_sql =
        " SELECT fbh02,fbh03,fbh031,faj06,faj18,fbh04,fbh05,fbh06,",
        "        fbh07,fbh08,fbh12, ",      #end No:A099
        "        fbhud01,fbhud02,fbhud03,fbhud04,fbhud05,",
        "        fbhud06,fbhud07,fbhud08,fbhud09,fbhud10,",
        "        fbhud11,fbhud12,fbhud13,fbhud14,fbhud15 ", 
        " FROM fbh_file LEFT OUTER JOIN faj_file ON  fbh03=faj02 AND fbh031=faj022",
        "  WHERE fbh01 ='",g_fbg.fbg01,"'",  #單頭
        "   AND ",p_wc2 CLIPPED,            #單身
        " ORDER BY 1"
 
    PREPARE t108_pb FROM g_sql
    DECLARE fbh_curs CURSOR FOR t108_pb
 
    CALL g_fbh.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH fbh_curs INTO g_fbh[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_fbh.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION t108_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fbh TO s_fbh.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
#        IF g_aza.aza63 = 'Y' THEN    #FUN-AB0088 mark
        #FUN-C30140--mark---str---
        #IF g_faa.faa31 = 'Y' THEN    #FUN-AB0088 add
        #   CALL cl_set_act_visible("entry_sheet2",TRUE)
        #ELSE
        #   CALL cl_set_act_visible("entry_sheet2",FALSE)
        #END IF
        #FUN-C30140--mark---end---
 
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
         CALL t108_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t108_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t108_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t108_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t108_fetch('L')
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
         IF g_fbg.fbgconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         IF g_fbg.fbg10 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
         CALL cl_set_field_pic(g_fbg.fbgconf,g_chr2,g_fbg.fbgpost,"",g_chr,"")
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION auto_generate
      ON ACTION auto_generate
         LET g_action_choice="auto_generate"
         EXIT DISPLAY
      #@ON ACTION recount
      ON ACTION recount
         LET g_action_choice="recount"
         EXIT DISPLAY
      #@ON ACTION entry_sheet
      ON ACTION entry_sheet
         LET g_action_choice="entry_sheet"
         EXIT DISPLAY
      #@ON ACTION entry_sheet2
      ON ACTION entry_sheet2
         LET g_action_choice="entry_sheet2"
         EXIT DISPLAY
      #@ON ACTION gen_entry
      ON ACTION gen_entry
         LET g_action_choice="gen_entry"
         EXIT DISPLAY
#FUN-AB0088---add---str---
      ON ACTION fin_audit2  
         LET g_action_choice="fin_audit2"
         EXIT DISPLAY
#FUN-AB0088---add---end---

      #@ON ACTION void
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY

      #FUN-D20035---add--str
      #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20035---add--end

      #@ON ACTION confirm
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ON ACTION undo_confirm
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      ON ACTION carry_voucher
         LET g_action_choice="carry_voucher"
         EXIT DISPLAY
      ON ACTION undo_carry_voucher
         LET g_action_choice="undo_carry_voucher"
         EXIT DISPLAY
      #@ON ACTION 過帳
      ON ACTION post
         LET g_action_choice="post"
         EXIT DISPLAY
      #@ON ACTION 會計過帳
      ON ACTION account_post
         LET g_action_choice="account_post"
         EXIT DISPLAY
      #@ON ACTION undo_post
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DISPLAY
      #@ON ACTION 稅簽修改
      ON ACTION amend_depr_tax
         LET g_action_choice="amend_depr_tax"
         EXIT DISPLAY
      #@ON ACTION 稅簽過帳
      ON ACTION post_depr_tax
         LET g_action_choice="post_depr_tax"
         EXIT DISPLAY
      #@ON ACTION 稅簽還原
      ON ACTION undo_post_depr_tax
         LET g_action_choice="undo_post_depr_tax"
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
             LET INT_FLAG=FALSE 		#MOD-570244	mars
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
 
FUNCTION t108_k()
   DEFINE g_fbh     DYNAMIC ARRAY OF RECORD
                    fbh02	LIKE fbh_file.fbh02,
                    fbh03	LIKE fbh_file.fbh03,
                     fbh031	LIKE fbh_file.fbh031,    #No.MOD-480073
                     faj06	LIKE faj_file.faj06,     #No.MOD-480073
                    faj18	LIKE faj_file.faj18,
                    fbh04	LIKE fbh_file.fbh04,
                    fbh06	LIKE fbh_file.fbh06,
                    fbh07	LIKE fbh_file.fbh07,
                    fbh12	LIKE fbh_file.fbh12,     #No:A099
                    fbh08	LIKE fbh_file.fbh08,
                    fbh09	LIKE fbh_file.fbh09,
                    fbh10	LIKE fbh_file.fbh10,
                    fbh13	LIKE fbh_file.fbh13,     #No:A099
                    fbh11	LIKE fbh_file.fbh11
                    END RECORD
   DEFINE g_fbh_t   RECORD
                    fbh02	LIKE fbh_file.fbh02,
                    fbh03	LIKE fbh_file.fbh03,
                     fbh031	LIKE fbh_file.fbh031,    #No.MOD-480073
                     faj06	LIKE faj_file.faj06,     #No.MOD-480073
                    faj18	LIKE faj_file.faj18,
                    fbh04	LIKE fbh_file.fbh04,
                    fbh06	LIKE fbh_file.fbh06,
                    fbh07	LIKE fbh_file.fbh07,
                    fbh12	LIKE fbh_file.fbh12,     #No:A099
                    fbh08	LIKE fbh_file.fbh08,
                    fbh09	LIKE fbh_file.fbh09,
                    fbh10	LIKE fbh_file.fbh10,
                    fbh13	LIKE fbh_file.fbh13,     #No:A099
                    fbh11	LIKE fbh_file.fbh11
                    END RECORD
   DEFINE l_lock_sw       LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
   DEFINE p_cmd           LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
   DEFINE i,j,k           LIKE type_file.num5         #No.FUN-680070 SMALLINT
   DEFINE ls_tmp          STRING
   DEFINE l_allow_insert  LIKE type_file.num5                #可新增否       #No.FUN-680070 SMALLINT
   DEFINE l_allow_delete  LIKE type_file.num5                #可刪除否       #No.FUN-680070 SMALLINT
   DEFINE l_cnt           LIKE type_file.num5   #CHI-860025
 
 
   IF g_fbg.fbg01 IS NULL THEN RETURN END IF
   IF g_fbg.fbgconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   #FUN-C30140---add---str---
   IF NOT cl_null(g_fbg.fbg10) AND g_fbg.fbg10 matches '[Ss]' THEN     
       CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
       RETURN
   END IF
   #FUN-C30140---add---end---
   LET p_row = 11 LET p_col = 17
   OPEN WINDOW t108_w5 AT p_row,p_col WITH FORM "afa/42f/afat1082"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("afat1082")
 
   DECLARE t108_kkk_c CURSOR FOR
          SELECT fbh02, fbh03,fbh031, faj06,faj18,fbh04, fbh06, fbh07, fbh12,     #No.MOD-480073
                fbh08, fbh09, fbh10, fbh13, fbh11     #end No:A099
           FROM fbh_file LEFT OUTER JOIN faj_file ON fbh03=faj02 AND fbh031=faj022
           # AND fbh01 = g_fbg.fbg01    #TQC-AB0174 mark
           WHERE fbh01 = g_fbg.fbg01    #TQC-AB0174 add
          ORDER BY 1
   CALL g_fbh.clear()
   LET k = 1
   FOREACH t108_kkk_c INTO g_fbh[k].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('t108_kkk_c',SQLCA.sqlcode,0) 
         EXIT FOREACH
      END IF
      IF g_faa.faa23 = 'N' THEN
         SELECT COUNT(*) INTO l_cnt FROM fao_file
          WHERE fao01 = g_fbh[k].fbh03
            AND fao02 = g_fbh[k].fbh031
            AND ((fao03 = YEAR(g_fbg.fbg02) AND fao04 >= MONTH(g_fbg.fbg02))
             OR fao03 > YEAR(g_fbg.fbg02))
            AND fao041 = '1'   #MOD-BC0025 add
         IF l_cnt > 0 THEN
            CALL cl_err(g_fbh[k].fbh03,'afa-092',0)
            CONTINUE FOREACH
         END IF
      END IF
      LET k = k + 1
      IF k > g_max_rec THEN EXIT FOREACH END IF
   END FOREACH
   CALL g_fbh.deleteElement(k)
   Let k = k - 1   #CHI-860025
   CALL SET_COUNT(k)   #CHI-860025
 
   IF g_fbg.fbgpost2= 'Y' THEN
      DISPLAY ARRAY g_fbh TO s_fbh.* ATTRIBUTE(COUNT=k-1,UNBUFFERED)
      CLOSE WINDOW t108_w5
      RETURN
   END IF
 
   SELECT * FROM fbg_file WHERE fbg01 = g_fbg.fbg01
   DISPLAY BY NAME g_fbg.fbgconf, g_fbg.fbgpost, g_fbg.fbgpost2,
                   g_fbg.fbguser, g_fbg.fbggrup, g_fbg.fbgmodu,g_fbg.fbgdate
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_fbh WITHOUT DEFAULTS FROM s_fbh.*
         ATTRIBUTE(COUNT=k,MAXCOUNT=g_max_rec,UNBUFFERED,   #CHI-860025
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INSERT
         LET i = ARR_CURR() LET j = SCR_LINE()
         LET p_cmd='a'
         INITIALIZE g_fbh[i].* TO NULL
         LET g_fbh_t.* = g_fbh[i].*
 
 
      BEFORE INPUT
          CALL fgl_set_arr_curr(l_ac)
 
      BEFORE ROW
         LET i = ARR_CURR() LET j = SCR_LINE()
         LET g_fbh_t.* = g_fbh[i].*
         LET l_lock_sw = 'N'
         IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_success = 'Y'
              CALL cl_show_fld_cont()     #FUN-550037(smin)
         ELSE
              LET g_success = 'Y'
              LET p_cmd='a'
              INITIALIZE g_fbh[i].* TO NULL
         END IF
 
     #-MOD-B30014-add
      AFTER FIELD fbh09
         IF NOT cl_null(g_fbh[i].fbh09) THEN      
            IF g_fbh[i].fbh09<0 THEN
               CALL cl_err('','mfg4012',0)
               NEXT FIELD fbh09
            END IF
         ELSE                                          
            CALL cl_err(g_fbh[i].fbh09,'aim-927',0) 
            NEXT FIELD fbh09
         END IF

      AFTER FIELD fbh10
         IF NOT cl_null(g_fbh[i].fbh10) THEN      
            IF g_fbh[i].fbh10<0 THEN
               CALL cl_err('','mfg4012',0)
               NEXT FIELD fbh10
            END IF
         ELSE                                          
            CALL cl_err(g_fbh[i].fbh10,'aim-927',0) 
            NEXT FIELD fbh10
         END IF

      AFTER FIELD fbh13
         IF NOT cl_null(g_fbh[i].fbh13) THEN      
            IF g_fbh[i].fbh13<0 THEN
               CALL cl_err('','mfg4012',0)
               NEXT FIELD fbh13
            END IF
         ELSE                                          
            CALL cl_err(g_fbh[i].fbh13,'aim-927',0) 
            NEXT FIELD fbh13
         END IF

      AFTER FIELD fbh11
         IF NOT cl_null(g_fbh[i].fbh11) THEN      
            IF g_fbh[i].fbh11<0 THEN
               CALL cl_err('','mfg4012',0)
               NEXT FIELD fbh11
            END IF
         ELSE                                          
            CALL cl_err(g_fbh[i].fbh11,'aim-927',0) 
            NEXT FIELD fbh11
         END IF
     #-MOD-B30014-add

      ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_fbh[i].* = g_fbh_t.*
             CLOSE t108_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_fbh[i].fbh02,-263,1)
             LET g_fbh[i].* = g_fbh_t.*
          ELSE
             IF g_fbh[i].fbh03 IS NULL THEN
                INITIALIZE g_fbh[i].* TO NULL
             END IF
             UPDATE fbh_file SET fbh09 = g_fbh[i].fbh09,
                                 fbh10 = g_fbh[i].fbh10,
                                 fbh11 = g_fbh[i].fbh11,
                                 fbh13 = g_fbh[i].fbh13      #No:A099
                      WHERE fbh01 = g_fbg.fbg01 AND fbh02 = g_fbh_t.fbh02
             IF STATUS THEN
                  CALL cl_err3("upd","fbh_file",g_fbg.fbg01,g_fbh_t.fbh02,SQLCA.sqlcode,"","upd fbh:",1)  #No.FUN-660136
                  LET g_success = 'N'
                  LET g_fbh[i].* = g_fbh_t.*
                  DISPLAY g_fbh[i].* TO s_fbh[j].*
             ELSE MESSAGE "update ok"
             END IF
          END IF
 
      AFTER ROW
         IF INT_FLAG THEN
            LET INT_FLAG=0
            LET g_fbh[i].* = g_fbh_t.*
            ROLLBACK WORK
            EXIT INPUT
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
   IF INT_FLAG THEN LET g_success='N' LET INT_FLAG = 0 END IF
   CLOSE WINDOW t108_w5
END FUNCTION
 
FUNCTION t108_y()
DEFINE l_cnt LIKE type_file.num5         #No.FUN-680070 SMALLINT
   IF s_shut(0) THEN RETURN END IF
   IF g_fbg.fbg01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_fbg.* FROM fbg_file WHERE fbg01 = g_fbg.fbg01
   IF g_fbg.fbgconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   SELECT COUNT(*) INTO l_cnt FROM fbh_file
    WHERE fbh01= g_fbg.fbg01
   IF l_cnt = 0 THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   IF g_fbg.fbgconf='Y' THEN RETURN END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   #-->立帳日期小於關帳日期
   IF g_fbg.fbg02 < g_faa.faa09 THEN
      CALL cl_err(g_fbg.fbg01,'aap-176',1) RETURN
   END IF
   #FUN-B60140   ---start   Add
    IF g_faa.faa31 = "Y" THEN
       #-->立帳日期小於關帳日期
       IF g_fbg.fbg02 < g_faa.faa092 THEN
          CALL cl_err(g_fbg.fbg01,'aap-176',1) RETURN
       END IF
    END IF
    #FUN-B60140   ---end     Add
   #----------------------------------- 檢查entry_sheet平衡正確否
   CALL s_get_bookno(g_fbg.fbg02) RETURNING g_flag,g_bookno1,g_bookno2   #MOD-880229 add
   #FUN-AB0088---add---str---
   #固資已不和二套掛鉤，所以原本利用s_get_bookno取到賬別一及賬別二是用是否使用二套賬來判斷
   #此處取賬別二要重新處理，應取固資參數欄位財二賬套faa02c作為賬別二的賬套
   IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF
   #FUN-AB0088---add---end---
 
#FUN-C30313---mark---START
#  IF g_fah.fahdmy3 = 'Y' THEN
#     CALL s_chknpq(g_fbg.fbg01,'FA',1,'0',g_bookno1)     #No.FUN-680028      #No.FUN-740026   add g_bookno
##     IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN   #FUN-AB0088 mark
#     IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   #FUN-AB0088 add
#        CALL s_chknpq(g_fbg.fbg01,'FA',1,'1',g_bookno2)     #No.FUN-680028  #No.FUN-740026   add g_bookno
#     END IF
#  END IF
#FUN-C30313---mark---END

#FUN-C30313---add---START-----
   IF g_fah.fahdmy3 = 'Y' THEN
      CALL s_chknpq(g_fbg.fbg01,'FA',1,'0',g_bookno1)     #No.FUN-680028      #No.FUN-740026   add g_bookno
   END IF
   IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   #FUN-AB0088 add
      IF g_fah.fahdmy32 = 'Y' THEN
         CALL s_chknpq(g_fbg.fbg01,'FA',1,'1',g_bookno2)     #No.FUN-680028  #No.FUN-740026   add g_bookno
      END IF
   END IF
#FUN-C30313---add---END-------
   IF g_success = 'N' THEN RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
   BEGIN WORK
 
    OPEN t108_cl USING g_fbg.fbg01
    IF STATUS THEN
       CALL cl_err("OPEN t108_cl:", STATUS, 1)
       CLOSE t108_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t108_cl INTO g_fbg.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbg.fbg01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t108_cl ROLLBACK WORK RETURN
    END IF
   UPDATE fbg_file SET fbgconf = 'Y' WHERE fbg01 = g_fbg.fbg01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","fbg_file",g_fbg.fbg01,"",STATUS,"","upd fbgconf",1)  #No.FUN-660136
      LET g_fbg.fbgconf='N'
      CLOSE t108_cl ROLLBACK WORK
      RETURN
   ELSE
      LET g_fbg.fbgconf='Y'
      CLOSE t108_cl
      COMMIT WORK
      CALL cl_flow_notify(g_fbg.fbg01,'Y')
      DISPLAY BY NAME g_fbg.fbgconf #
   END IF
   IF g_fbg.fbgconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fbg.fbg10 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fbg.fbgconf,g_chr2,g_fbg.fbgpost,"",g_chr,"")
END FUNCTION
 
FUNCTION t108_y_chk()
  DEFINE l_cnt LIKE type_file.num5         #No.FUN-680070 SMALLINT
  DEFINE l_cnt2 LIKE type_file.num5,
         l_fan07 LIKE fan_file.fan07,
         l_yy,l_mm   LIKE type_file.num5,
         l_last      LIKE type_file.num5,
         l_rate      LIKE azx_file.azx04,
         l_amt       LIKE fan_file.fan07,
         l_cost      LIKE fbh_file.fbh06,  #MOD-B60173
         l_cost2     LIKE fbh_file.fbh06,  #MOD-C80118 add
         l_accd      LIKE fbh_file.fbh06,
         l_qty       LIKE fbh_file.fbh04,
         l_fbh07     LIKE fbh_file.fbh07,
         l_fbh08     LIKE fbh_file.fbh08, #CHI-9C0008 add
         l_fbh12     LIKE fbh_file.fbh12, #CHI-9C0008 add
         l_npq07f_d,l_npq07f_c    LIKE npq_file.npq07f,
         l_npq07_d,l_npq07_c     LIKE npq_file.npq07,
         l_fbh06     LIKE fbh_file.fbh06,
         l_fbh       RECORD LIKE fbh_file.*,
         l_t1        LIKE fah_file.fahslip,
         l_fahdmy3   LIKE fah_file.fahdmy3,
         l_fahdmy32  LIKE fah_file.fahdmy32 #FUN-C30313 add
  DEFINE l_faj28     LIKE faj_file.faj28   #MOD-AA0001 
  DEFINE l_faj43     LIKE faj_file.faj43   #MOD-AA0001
  DEFINE l_flag1     LIKE type_file.chr1   #MOD-AA0001 
#FUN-AB0088---add---str---
  DEFINE l_fbh062    LIKE fbh_file.fbh062  
  DEFINE l_fbh072    LIKE fbh_file.fbh072  
  DEFINE l_fbh082    LIKE fbh_file.fbh082  
  DEFINE l_fbh122    LIKE fbh_file.fbh122,  
         l_accd2     LIKE fbh_file.fbh06,
         l_qty2      LIKE fbh_file.fbh04
  DEFINE l_faj282    LIKE faj_file.faj282
  DEFINE l_faj432    LIKE faj_file.faj432  
  DEFINE l_amt2      LIKE fan_file.fan07
  DEFINE l_fbn07     LIKE fbn_file.fbn07
  DEFINE l_cnt1      LIKE type_file.num5
#FUN-AB0088---add---end---
  DEFINE l_faj09     LIKE faj_file.faj09 #FUN-D80046
 
  LET g_success = 'Y'              #FUN-580109
 
  IF s_shut(0) THEN
     LET g_success = 'N'           #FUN-580109
     RETURN
  END IF
#CHI-C30107 ------------ add ------------- begin
  IF g_fbg.fbg01 IS NULL THEN
     LET g_success = 'N'           
     CALL cl_err('',-400,0)
     RETURN
  END IF
  IF g_fbg.fbgconf = 'X' THEN
     LET g_success = 'N'         
     CALL cl_err('','9024',0)
     RETURN
  END IF
  IF g_fbg.fbgconf='Y' THEN
     LET g_success = 'N'
     CALL cl_err('','9023',0)     
     RETURN
  END IF
   IF g_action_choice CLIPPED = "confirm" OR   #按「確認」時
      g_action_choice CLIPPED = "insert"     
   THEN
      IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF
   END IF
#CHI-C30107 ------------ add ------------- end
  IF g_fbg.fbg01 IS NULL THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err('',-400,0)
     RETURN
  END IF
  SELECT * INTO g_fbg.* FROM fbg_file WHERE fbg01 = g_fbg.fbg01
  IF g_fbg.fbgconf = 'X' THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err('','9024',0)
     RETURN
  END IF
  IF g_fbg.fbgconf='Y' THEN
     LET g_success = 'N'
     CALL cl_err('','9023',0)      #FUN-580109
     RETURN
  END IF
 
  SELECT COUNT(*) INTO l_cnt FROM fbh_file
   WHERE fbh01= g_fbg.fbg01
  IF l_cnt = 0 THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err('','mfg-009',0)
     RETURN
  END IF
  IF g_fbg.fbgconf='Y' THEN RETURN END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-->立帳日期小於關帳日期
  IF g_fbg.fbg02 < g_faa.faa09 THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err(g_fbg.fbg01,'aap-176',1)
     RETURN
  END IF

  #FUN-B60140   ---start   Add
   IF g_faa.faa31="Y" THEN
      #-->立帳日期小於關帳日期
      IF g_fbg.fbg02 < g_faa.faa092 THEN
         LET g_success = 'N'
         CALL cl_err(g_fbg.fbg01,'aap-176',1)
         RETURN
      END IF
   END IF
   #FUN-B60140   ---end     Add
 
  #判斷是否有做過重新計算帳值
  IF g_faa.faa23 = 'Y' THEN
     LET l_cnt2 = 1
     DECLARE fbh_curs2 CURSOR FOR 
        SELECT fbh02,fbh03,fbh031,faj06,faj18,fbh04,fbh05,fbh06,
               fbh07,fbh08,fbh12 
        FROM fbh_file LEFT OUTER JOIN faj_file ON fbh03=faj02 AND fbh031=faj022 
        WHERE fbh03=faj_file.faj02 AND fbh031=faj_file.faj022 
           AND fbh01 =g_fbg.fbg01
        ORDER BY 1
     FOREACH fbh_curs2 INTO g_fbh[l_cnt2].* 
       #SELECT faj32-faj60,faj17-faj58 INTO l_accd,l_qty FROM faj_file                              #MOD-AA0001 mark
       #SELECT faj32-faj60,faj17-faj58,faj26,faj28,faj43 INTO l_accd,l_qty,g_faj26,l_faj28,l_faj43  #MOD-AA0001 #CHI-9C0008 mark 
       #SELECT faj32-faj60,faj17-faj58,faj26,faj28,faj43,(faj33+faj331),(faj101-faj102) #CHI-9C0008  #TQC-AC0381 mark 
       #SELECT faj32-faj60,faj17-faj58,faj26,faj28,faj43,(faj33+faj331)/faj17*g_fbh[l_cnt2].fbh04,(faj101-faj102) #TQC-AC0381 add #MOD-B60173 mark 
        SELECT faj32-faj60,faj17-faj58,faj26,faj28,faj43,(faj33+faj331),(faj101-faj102),faj14+faj141-faj59  #CHI-9C0008  #MOD-B60173 
          INTO l_accd,l_qty,g_faj26,l_faj28,l_faj43,l_fbh08,l_fbh12,l_cost  #CHI-9C0008  #MOD-B60173 add l_cost
          FROM faj_file                                                                             #MOD-AA0001
          WHERE faj02= g_fbh[l_cnt2].fbh03 AND faj022 = g_fbh[l_cnt2].fbh031
       #-MOD-AA0001-add- 
        LET l_flag1 = 'N' 
        #FUN-D80046--add--str---
        SELECT faj09 INTO l_faj09 FROM faj_file
        WHERE faj02=g_fbh[l_cnt2].fbh03 AND faj022 = g_fbh[l_cnt2].fbh031
        IF l_faj09!='2' AND l_faj09!='5' THEN
        #FUN-D80046--add--end
        #當參數勾選當月處份應提列折舊,應卡當月份是否有提列折舊,若沒有則不可確認
        IF (YEAR(g_faj26) = YEAR(g_fbg.fbg02)) AND (MONTH(g_faj26) = MONTH(g_fbg.fbg02)) THEN
           IF g_faa.faa15 = '3' AND DAY(g_fbg.fbg02) <= 15 AND l_faj43 <> '4' THEN
              LET l_flag1 = 'Y'
           END IF
           IF (g_faa.faa15 = '2' OR g_faa.faa15 = '4') AND l_faj43 <> '4' THEN
              LET l_flag1 = 'Y'
           END IF
        ELSE
           IF l_faj43 <> '4' THEN
              LET l_flag1 = 'Y'
           END IF
        END IF
        IF l_flag1 = 'Y' THEN  
           SELECT fan07 INTO l_fan07 FROM fan_file
            WHERE fan01 = g_fbh[l_cnt2].fbh03
              AND fan02 = g_fbh[l_cnt2].fbh031
              AND fan03 = YEAR(g_fbg.fbg02)
              AND fan04 = MONTH(g_fbg.fbg02)
              AND fan041= '1'
           IF cl_null(l_fan07) THEN
              IF l_faj28<>'0' THEN  
                 CALL cl_err('','afa-526',0)   
                 LET g_success='N'
                 RETURN
              END IF 
           END IF
        END IF   
       #-MOD-AA0001-end- 
     END IF  #FUN-D80046
        IF g_faa.faa15='4' THEN
           SELECT fan07 INTO l_fan07 FROM fan_file
            WHERE fan01 = g_fbh[l_cnt2].fbh03  AND fan02 = g_fbh[l_cnt2].fbh031
              AND fan03 = YEAR(g_fbg.fbg02)
              AND fan04 = MONTH(g_fbg.fbg02)
              AND fan041 = '1'
           IF cl_null(l_fan07) THEN
              CALL cl_err(g_fbh[l_cnt2].fbh03,'afa-376',0)
              LET g_success='N'
              RETURN
           END IF
           LET l_yy = YEAR(g_fbg.fbg02)
           LET l_mm = MONTH(g_fbg.fbg02)
           IF l_mm = 12 THEN
              LET l_mm = 1 LET l_yy = l_yy + 1
           ELSE
              LET l_mm = l_mm + 1
           END IF
           LET l_last = DAY(MDY(l_mm,1,l_yy)-1)
           LET l_rate = DAY(g_fbg.fbg02) / l_last
           LET l_amt = l_fan07 * l_rate
           LET l_accd = l_accd -l_fan07 + l_amt
       END IF
       IF l_qty = 0 OR cl_null(l_qty) THEN
          LET l_fbh06=l_cost             #MOD-B60173
          LET l_fbh07=l_accd
          LET l_fbh08=l_fbh06 - l_fbh07  #MOD-B60173
       ELSE 
          LET l_fbh06=l_cost * (g_fbh[l_cnt2].fbh04/l_qty) #MOD-B60173
          LET l_fbh07=l_accd * (g_fbh[l_cnt2].fbh04/l_qty)
          LET l_fbh08=l_fbh06 - l_fbh07                    #MOD-B60173
          LET l_fbh12=l_fbh12* (g_fbh[l_cnt2].fbh04/l_qty) #MOD-B60173
       END IF
       
       IF l_faj43 <> '4' THEN #CHI-9C0008 add
          LET l_fbh07=cl_digcut(l_fbh07,g_azi04)
          IF l_fbh07 <> g_fbh[l_cnt2].fbh07 THEN
             LET g_success = 'N'
             CALL cl_err(g_fbh[l_cnt2].fbh03,'afa-153',1)
             RETURN
          END IF
          #CHI-9C0008 add --start--
          LET l_fbh08=cl_digcut(l_fbh08,g_azi04)
          IF l_fbh08 <> g_fbh[l_cnt2].fbh08 THEN
             LET g_success = 'N'
             CALL cl_err(g_fbh[l_cnt2].fbh03,'afa-153',1)
             RETURN
          END IF
          LET l_fbh12=cl_digcut(l_fbh12,g_azi04)
          IF l_fbh12 <> g_fbh[l_cnt2].fbh12 THEN
             LET g_success = 'N'
             CALL cl_err(g_fbh[l_cnt2].fbh03,'afa-153',1)
             RETURN
          END IF
          #CHI-9C0008 add --end--
       END IF #CHI-9C0008 add
       LET l_cnt2 = l_cnt2 + 1
     END FOREACH

     #FUN-AB0088---add---str--勾選財二參數時，要一併檢查財二資料-----
     IF g_faa.faa31 = 'Y' THEN
        #判斷是否有做過重新計算帳值
         IF g_faa.faa232 = 'Y' THEN      #FUN-B60140   Add
         LET l_cnt2 = 1
         DECLARE fbh_curs22 CURSOR FOR 
            SELECT fbh02,fbh03,fbh031,faj06,faj18,fbh04,fbh062,
                   fbh072,fbh082,fbh122
            FROM fbh_file, OUTER faj_file 
            WHERE fbh03=faj02 AND fbh031=faj022 
               AND fbh01 =g_fbg.fbg01
            ORDER BY 1
         FOREACH fbh_curs22 INTO g_fbh2[l_cnt2].* 
            SELECT faj322-faj602,faj17-faj582,faj262,faj282,faj432,(faj332+faj3312),(faj1012-faj1022),
                   (faj142+faj1412-faj592)                                                                 #MOD-C80118 add
              INTO l_accd2,l_qty2,g_faj262,l_faj282,l_faj432,l_fbh082,l_fbh122,l_cost2                     #MOD-C80118 add l_cost2
              FROM faj_file                                             
              WHERE faj02= g_fbh2[l_cnt2].fbh03 AND faj022 = g_fbh2[l_cnt2].fbh031
             #當參數勾選當月處分應提列折舊,應卡當月份是否有提列折舊，若沒有則不可確認
             IF (YEAR(g_faj262) = YEAR(g_fbg.fbg02)) AND (MONTH(g_faj262) = MONTH(g_fbg.fbg02)) THEN
                IF g_faa.faa152 = '3' AND DAY(g_fbg.fbg02) <= 15 AND l_faj432 <> '4' THEN  #FUN-B60140 Mod faa15--> faa152
                   LET l_flag1 = 'Y'
                END IF
              # IF (g_faa.faa152 = '2' OR g_faa.faa15 = '4') AND l_faj432 <> '4' THEN        #FUN-B60140   Mod   faa15  --> faa152 #No:FUN-BA0112 mark
                IF (g_faa.faa152 = '2' OR g_faa.faa152 = '4') AND l_faj432 <> '4' THEN #No:FUN-BA0112 add
                   LET l_flag1 = 'Y'
                END IF
             ELSE
                IF l_faj432 <> '4' THEN
                   LET l_flag1 = 'Y'
                END IF
             END IF
             IF l_flag1 = 'Y' THEN  
                SELECT fbn07 INTO l_fbn07 FROM fbn_file
                 WHERE fbn01 = g_fbh2[l_cnt2].fbh03
                   AND fbn02 = g_fbh2[l_cnt2].fbh031
                   AND fbn03 = YEAR(g_fbg.fbg02)
                   AND fbn04 = MONTH(g_fbg.fbg02)
                   AND fbn041= '1'
                IF cl_null(l_fbn07) THEN
                   IF l_faj282<>'0' THEN  
                      CALL cl_err('','afa-526',0)   
                      LET g_success='N'
                      RETURN
                   END IF 
                END IF
             END IF   

             IF g_faa.faa152='4' THEN   #FUN-B60140   Mod   faa15  --> faa152
                 SELECT fbn07 INTO l_fbn07 FROM fbn_file
                  WHERE fbn01 = g_fbh2[l_cnt2].fbh03  
                    AND fbn02 = g_fbh2[l_cnt2].fbh031
                    AND fbn03 = YEAR(g_fbg.fbg02)
                    AND fbn04 = MONTH(g_fbg.fbg02)
                    AND fbn041 = '1'
                 IF cl_null(l_fbn07) THEN
                    CALL cl_err(g_fbh2[l_cnt2].fbh03,'afa-376',0)
                    LET g_success='N'
                    RETURN
                 END IF
                 LET l_yy = YEAR(g_fbg.fbg02)
                 LET l_mm = MONTH(g_fbg.fbg02)
                 IF l_mm = 12 THEN
                    LET l_mm = 1 LET l_yy = l_yy + 1
                 ELSE
                    LET l_mm = l_mm + 1
                 END IF
                 LET l_last = DAY(MDY(l_mm,1,l_yy)-1)
                 LET l_rate = DAY(g_fbg.fbg02) / l_last
                 LET l_amt2 = l_fbn07 * l_rate
                 LET l_accd2 = l_accd2 -l_fbn07 + l_amt
             END IF
             IF l_qty = 0 OR cl_null(l_qty2) THEN
                LET l_fbh062 = l_cost2                                   #MOD-C80118 add
                LET l_fbh072=l_accd2
                LET l_fbh082 = l_fbh062 - l_fbh072                       #MOD-C80118 add
             ELSE 
                LET l_fbh062 = l_cost2 * (g_fbh[l_cnt2].fbh04/l_qty2)    #MOD-C80118 add
                LET l_fbh072=l_accd2 * (g_fbh[l_cnt2].fbh04/l_qty2)
                LET l_fbh082 = l_fbh062 - l_fbh072                       #MOD-C80118 add
                LET l_fbh122 = l_fbh122 * (g_fbh[l_cnt2].fbh04/l_qty2)   #MOD-C80118 add
             END IF
             
             IF l_faj432 <> '4' THEN
                #LET l_fbh072=cl_digcut(l_fbh072,g_azi04)   #CHI-C60010 mark
                 LET l_fbh072=cl_digcut(l_fbh072,g_azi04_1)   #CHI-C60010
                IF l_fbh072 <> g_fbh2[l_cnt2].fbh072 THEN
                   LET g_success = 'N'
                   CALL cl_err(g_fbh2[l_cnt2].fbh03,'afa-153',1)
                   RETURN
                END IF
              #-----------------------MOD-C80118----------------------mark
              ##str TQC-C10070 add
              # IF NOT (l_qty = 0 OR cl_null(l_qty2)) THEN
              #    LET l_fbh082=l_fbh082 * (g_fbh[l_cnt2].fbh04/l_qty2)
              # END IF
              ##end TQC-C10070 add
              #-----------------------MOD-C80118----------------------mark
                #LET l_fbh082=cl_digcut(l_fbh082,g_azi04)   #CHI-C60010 mark
                 LET l_fbh082=cl_digcut(l_fbh082,g_azi04_1)   #CHI-C60010
                IF l_fbh082 <> g_fbh2[l_cnt2].fbh082 THEN
                   LET g_success = 'N'
                   CALL cl_err(g_fbh2[l_cnt2].fbh03,'afa-153',1)
                   RETURN
                END IF
              #-----------------------MOD-C80118----------------------mark
              ##str TQC-C10070 add
              # IF NOT (l_qty = 0 OR cl_null(l_qty2)) THEN
              #    LET l_fbh122=l_fbh122 * (g_fbh[l_cnt2].fbh04/l_qty2)
              # END IF
              ##end TQC-C10070 add
              #-----------------------MOD-C80118----------------------mark
                #LET l_fbh122=cl_digcut(l_fbh122,g_azi04)   #CHI-C60010 mark
                 LET l_fbh122=cl_digcut(l_fbh122,g_azi04_1)   #CHI-C60010
                IF l_fbh122<> g_fbh2[l_cnt2].fbh122 THEN
                   LET g_success = 'N'
                   CALL cl_err(g_fbh2[l_cnt2].fbh03,'afa-153',1)
                   RETURN
                END IF
             END IF
             LET l_cnt2 = l_cnt2 + 1
         END FOREACH
        END IF    #FUN-B60140   Add
     END IF
     #FUN-AB0088---add---end--- 
     CALL g_fbh.deleteElement(l_cnt2)
     CALL g_fbh2.deleteElement(l_cnt2)   #FUN-AB0088
  END IF
 
  #判斷分錄是否有重新產生
  LET l_t1 = s_get_doc_no(g_fbg.fbg01)      
  LET l_fahdmy3 = ''
  SELECT fahdmy3 INTO l_fahdmy3 FROM fah_file WHERE fahslip = l_t1
  IF l_fahdmy3 = 'Y' THEN
     LET l_npq07f_d = 0
     LET l_npq07_d = 0
     LET l_npq07f_c = 0
     LET l_npq07_c = 0
     LET l_fbh06 = 0
     LET l_fbh062 = 0    #FUN-AB0088
     IF g_argv1 = '1' THEN 
        SELECT SUM(npq07f),SUM(npq07) INTO l_npq07f_d,l_npq07_d FROM npq_file
          WHERE npq01 = g_fbg.fbg01
            AND npq011 = 1
            AND npqsys = 'FA'
            AND npq00 = 5
            AND npq06 = '1'
            AND npqtype = '0'
        SELECT SUM(npq07f),SUM(npq07) INTO l_npq07f_c,l_npq07_c FROM npq_file
          WHERE npq01 = g_fbg.fbg01
            AND npq011 = 1
            AND npqsys = 'FA'
            AND npq00 = 5
            AND npq06 = '2'
            AND npqtype = '0'
     ELSE
        SELECT SUM(npq07f),SUM(npq07) INTO l_npq07f_d,l_npq07_d FROM npq_file
          WHERE npq01 = g_fbg.fbg01
            AND npq011 = 1
            AND npqsys = 'FA'
            AND npq00 = 6
            AND npq06 = '1'
            AND npqtype = '0'
        SELECT SUM(npq07f),SUM(npq07) INTO l_npq07f_c,l_npq07_c FROM npq_file
          WHERE npq01 = g_fbg.fbg01
            AND npq011 = 1
            AND npqsys = 'FA'
            AND npq00 = 6
            AND npq06 = '2'
            AND npqtype = '0'
     END IF
     IF cl_null(l_npq07f_d) THEN LET l_npq07f_d = 0 END IF
     IF cl_null(l_npq07_d) THEN LET l_npq07_d = 0 END IF
     IF cl_null(l_npq07f_c) THEN LET l_npq07f_c = 0 END IF
     IF cl_null(l_npq07_c) THEN LET l_npq07_c = 0 END IF
    #SELECT SUM(fbh06) INTO l_fbh06 FROM fbh_file,fbg_file      #MOD-C80200 mark
     SELECT SUM(fbh06 - fbh12) INTO l_fbh06                     #MOD-C80200 add
       FROM fbh_file,fbg_file                                   #MOD-C80200 add
       WHERE fbh01 = fbg01 AND fbg01 = g_fbg.fbg01 
     IF cl_null(l_fbh06) THEN LET l_fbh06 = 0 END IF
     IF l_fbh06 <> l_npq07_d OR l_fbh06 <> l_npq07_c THEN 
         LET g_success = 'N'
         CALL cl_err('','afa-154',1)
         RETURN
     END IF
#FUN-C30313---mark---START
##    IF g_aza.aza63='Y' THEN    #FUN-AB0088 mark
#    IF g_faa.faa31='Y' THEN    #FUN-AB0088
#       LET l_npq07f_d = 0
#       LET l_npq07_d = 0
#       LET l_npq07f_c = 0
#       LET l_npq07_c = 0
#       LET l_fbh06 = 0
#       IF g_argv1 = '1' THEN 
#          SELECT SUM(npq07f),SUM(npq07) INTO l_npq07f_d,l_npq07_d FROM npq_file
#            WHERE npq01 = g_fbg.fbg01
#              AND npq011 = 1
#              AND npqsys = 'FA'
#              AND npq00 = 5
#              AND npq06 = '1'
#              AND npqtype = '1'
#          SELECT SUM(npq07f),SUM(npq07) INTO l_npq07f_c,l_npq07_c FROM npq_file
#            WHERE npq01 = g_fbg.fbg01
#              AND npq011 = 1
#              AND npqsys = 'FA'
#              AND npq00 = 5
#              AND npq06 = '2'
#              AND npqtype = '1'
#       ELSE
#          SELECT SUM(npq07f),SUM(npq07) INTO l_npq07f_d,l_npq07_d FROM npq_file
#            WHERE npq01 = g_fbg.fbg01
#              AND npq011 = 1
#              AND npqsys = 'FA'
#              AND npq00 = 6
#              AND npq06 = '1'
#              AND npqtype = '1'
#          SELECT SUM(npq07f),SUM(npq07) INTO l_npq07f_c,l_npq07_c FROM npq_file
#            WHERE npq01 = g_fbg.fbg01
#              AND npq011 = 1
#              AND npqsys = 'FA'
#              AND npq00 = 6
#              AND npq06 = '2'
#              AND npqtype = '1'
#       END IF
#       IF cl_null(l_npq07f_d) THEN LET l_npq07f_d = 0 END IF
#       IF cl_null(l_npq07_d) THEN LET l_npq07_d = 0 END IF
#       IF cl_null(l_npq07f_c) THEN LET l_npq07f_c = 0 END IF
#       IF cl_null(l_npq07_c) THEN LET l_npq07_c = 0 END IF
#      #SELECT SUM(fbh06) INTO l_fbh06 FROM fbh_file,fbg_file      #FUN-AB0088 mark
#       SELECT SUM(fbh062) INTO l_fbh062 FROM fbh_file,fbg_file   #FUN-AB0088 add
#         WHERE fbh01 = fbg01 AND fbg01 = g_fbg.fbg01 
#      #IF cl_null(l_fbh06) THEN LET l_fbh06 = 0 END IF      ##FUN-AB0088 mark
#       IF cl_null(l_fbh062) THEN LET l_fbh062 = 0 END IF    #FUN-AB0088 add
#      #IF l_fbh06 <> l_npq07_d OR l_fbh06 <> l_npq07_c THEN      #FUN-AB0088 mark
#       IF l_fbh062 <> l_npq07_d OR l_fbh062 <> l_npq07_c THEN    #FUN-AB0088 add
#           LET g_success = 'N'
#           CALL cl_err('','afa-154',1)
#           RETURN
#       END IF
#    END IF
#FUN-C30313---mark---END
  END IF
#FUN-C30313---add---START-----
  IF g_faa.faa31='Y' THEN    #FUN-AB0088
     LET l_fahdmy32 = ''
     SELECT fahdmy32 INTO l_fahdmy32 FROM fah_file WHERE fahslip = l_t1
     IF l_fahdmy32 = 'Y' THEN     
        LET l_npq07f_d = 0
        LET l_npq07_d = 0
        LET l_npq07f_c = 0
        LET l_npq07_c = 0
        LET l_fbh06 = 0
        IF g_argv1 = '1' THEN 
           SELECT SUM(npq07f),SUM(npq07) INTO l_npq07f_d,l_npq07_d FROM npq_file
             WHERE npq01 = g_fbg.fbg01
               AND npq011 = 1
               AND npqsys = 'FA'
               AND npq00 = 5
               AND npq06 = '1'
               AND npqtype = '1'
           SELECT SUM(npq07f),SUM(npq07) INTO l_npq07f_c,l_npq07_c FROM npq_file
             WHERE npq01 = g_fbg.fbg01
               AND npq011 = 1
               AND npqsys = 'FA'
               AND npq00 = 5
               AND npq06 = '2'
               AND npqtype = '1'
        ELSE
           SELECT SUM(npq07f),SUM(npq07) INTO l_npq07f_d,l_npq07_d FROM npq_file
             WHERE npq01 = g_fbg.fbg01
               AND npq011 = 1
               AND npqsys = 'FA'
               AND npq00 = 6
               AND npq06 = '1'
               AND npqtype = '1'
           SELECT SUM(npq07f),SUM(npq07) INTO l_npq07f_c,l_npq07_c FROM npq_file
             WHERE npq01 = g_fbg.fbg01
               AND npq011 = 1
               AND npqsys = 'FA'
               AND npq00 = 6
               AND npq06 = '2'
               AND npqtype = '1'
        END IF
        IF cl_null(l_npq07f_d) THEN LET l_npq07f_d = 0 END IF
        IF cl_null(l_npq07_d) THEN LET l_npq07_d = 0 END IF
        IF cl_null(l_npq07f_c) THEN LET l_npq07f_c = 0 END IF
        IF cl_null(l_npq07_c) THEN LET l_npq07_c = 0 END IF
       #SELECT SUM(fbh062) INTO l_fbh062 FROM fbh_file,fbg_file     #FUN-AB0088 add #MOD-C80200 mark
        SELECT SUM(fbh062 - fbh122) INTO l_fbh062                   #MOD-C80200 add
          FROM fbh_file,fbg_file                                    #MOD-C80200 add
          WHERE fbh01 = fbg01 AND fbg01 = g_fbg.fbg01 
        IF cl_null(l_fbh062) THEN LET l_fbh062 = 0 END IF    #FUN-AB0088 add
        IF l_fbh062 <> l_npq07_d OR l_fbh062 <> l_npq07_c THEN    #FUN-AB0088 add
            LET g_success = 'N'
            CALL cl_err('','afa-154',1)
            RETURN
        END IF
    END IF
  END IF
#FUN-C30313---add---END-------
 
  DECLARE t108_cur6 CURSOR FOR
     SELECT * FROM fbh_file WHERE fbh01=g_fbg.fbg01
  FOREACH t108_cur6 INTO l_fbh.*
     LET l_cnt = 0
     LET l_cnt1= 0   #FUN-AB0088 add
     IF g_faa.faa23='Y' THEN
        SELECT COUNT(*) INTO l_cnt FROM fan_file
         WHERE fan01 = l_fbh.fbh03
           AND fan02 = l_fbh.fbh031
           AND ((fan03 = YEAR(g_fbg.fbg02) AND fan04 > MONTH(g_fbg.fbg02))
            OR fan03 > YEAR(g_fbg.fbg02)) 
           AND fan041 = '1'   #MOD-C50044 add
      #FUN_B60140   ---start   Mark
      ##FUN-AB0088---add---str---
      # IF g_faa.faa31 = 'Y' THEN
      #      SELECT COUNT(*) INTO l_cnt1 FROM fbn_file
      #       WHERE fbn01 = l_fbh.fbh03
      #         AND fbn02 = l_fbh.fbh031
      #         AND ((fbn03 = YEAR(g_fbg.fbg02) AND fbn04 > MONTH(g_fbg.fbg02))
      #          OR fbn03 > YEAR(g_fbg.fbg02)) 
      #  END IF
      ##FUN-AB0088---add---end---
      #FUN_B60140   ---end     Mark
     ELSE
        SELECT COUNT(*) INTO l_cnt FROM fan_file
         WHERE fan01 = l_fbh.fbh03
           AND fan02 = l_fbh.fbh031
           AND ((fan03 = YEAR(g_fbg.fbg02) AND fan04 >= MONTH(g_fbg.fbg02))
            OR fan03 > YEAR(g_fbg.fbg02))
           AND fan041 = '1'   #MOD-C50044 add
     #FUN_B60140   ---start   Mark
     #FUN-AB0088---add---str---
     #  IF g_faa.faa31 = 'Y' THEN
     #      SELECT COUNT(*) INTO l_cnt1 FROM fbn_file
     #       WHERE fbn01 = l_fbh.fbh03
     #         AND fbn02 = l_fbh.fbh031
     #         AND ((fbn03 = YEAR(g_fbg.fbg02) AND fbn04 >= MONTH(g_fbg.fbg02))
     #          OR fbn03 > YEAR(g_fbg.fbg02)) 
     #  END IF
     #FUN-AB0088---add---end---
     #FUN-B60140   ---end     Mark
     END IF
     #FUN-B60140   ---start   Add
     IF g_faa.faa31 = "Y" THEN
       IF g_faa.faa232='Y' THEN
          SELECT COUNT(*) INTO l_cnt1 FROM fbn_file
           WHERE fbn01 = l_fbh.fbh03
             AND fbn02 = l_fbh.fbh031
             AND ((fbn03 = YEAR(g_fbg.fbg02) AND fbn04 > MONTH(g_fbg.fbg02))
                 OR fbn03 > YEAR(g_fbg.fbg02))
             AND fbn041 = '1'   #MOD-C50044 add
       ELSE
          SELECT COUNT(*) INTO l_cnt1 FROM fbn_file
           WHERE fbn01 = l_fbh.fbh03
             AND fbn02 = l_fbh.fbh031
             AND ((fbn03 = YEAR(g_fbg.fbg02) AND fbn04 >= MONTH(g_fbg.fbg02))
              OR fbn03 > YEAR(g_fbg.fbg02))
             AND fbn041 = '1'   #MOD-C50044 add
       END IF
    END IF
   #FUN-B60140   ---end     Add
     LET l_cnt = l_cnt + l_cnt1   #FUN-AB0088
     IF l_cnt > 0 THEN
        LET g_success = 'N'
        CALL cl_err(l_fbh.fbh03,'afa-348',0)
        RETURN
     END IF
     LET l_cnt = 0
     IF g_faa.faa23='Y' THEN
        SELECT COUNT(*) INTO l_cnt FROM fao_file
         WHERE fao01 = l_fbh.fbh03
           AND fao02 = l_fbh.fbh031
           AND ((fao03 = YEAR(g_fbg.fbg02) AND fao04 > MONTH(g_fbg.fbg02))
            OR fao03 > YEAR(g_fbg.fbg02)) 
           AND fao041 = '1'   #MOD-C50044 add
     ELSE
        SELECT COUNT(*) INTO l_cnt FROM fao_file
         WHERE fao01 = l_fbh.fbh03
           AND fao02 = l_fbh.fbh031
           AND ((fao03 = YEAR(g_fbg.fbg02) AND fao04 >= MONTH(g_fbg.fbg02))
            OR fao03 > YEAR(g_fbg.fbg02)) 
           AND fao041 = '1'   #MOD-C50044 add
     END IF
     IF l_cnt > 0 THEN
        LET g_success = 'N'
        CALL cl_err(l_fbh.fbh03,'afa-348',0)
        RETURN
     END IF
  END FOREACH
 
  #----------------------------------- 檢查entry_sheet平衡正確否
  LET g_t1 = s_get_doc_no(g_fbg.fbg01)  #No.FUN-670060                                                                           
  SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1  #No.FUN-670060
  CALL s_get_bookno(g_fbg.fbg02) RETURNING g_flag,g_bookno1,g_bookno2   #MOD-880229 add
  #FUN-AB0088---add---str---
  #固資已不和二套掛鉤，所以原本利用s_get_bookno取到賬別一及賬別二是用是否使用二套賬來判斷
  #此處取賬別二要重新處理，應取固資參數欄位財二賬套faa02c作為賬別二的賬套
  IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF
  #FUN-AB0088---add---end--- 

#FUN-C30313---mark---START
# IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'N' THEN  #No.FUN-670060
#    CALL s_chknpq(g_fbg.fbg01,'FA',1,'0',g_bookno1)   #-->NO:0151     #No.FUN-680028    #No.FUN-740026   add g_bookno
##    IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN     #FUN-AB0088 mark
#    IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN     #FUN-AB0088 add
#       CALL s_chknpq(g_fbg.fbg01,'FA',1,'1',g_bookno2)   #-->NO:0151     #No.FUN-680028 #No.FUN-740026   add g_bookno
#    END IF
# END IF
#FUN-C30313---mark---END

#FUN-C30313---add---START-----
  IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'N' THEN  #No.FUN-670060
     CALL s_chknpq(g_fbg.fbg01,'FA',1,'0',g_bookno1)   #-->NO:0151     #No.FUN-680028    #No.FUN-740026   add g_bookno
  END IF
  IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN     #FUN-AB0088 add
     IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'N' THEN
        CALL s_chknpq(g_fbg.fbg01,'FA',1,'1',g_bookno2)   #-->NO:0151     #No.FUN-680028 #No.FUN-740026   add g_bookno
     END IF
  END IF
#FUN-C30313---add---END-------
 
  IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t108_y_upd()
   DEFINE l_n    LIKE type_file.num10      #No.FUN-670060       #No.FUN-680070 INTEGER
   #CHI-B80007 -- begin --
   DEFINE l_fbh     RECORD LIKE fbh_file.*
   DEFINE l_msg     LIKE type_file.chr1000
   DEFINE l_cnt     LIKE type_file.num5
   #CHI-B80007 -- begin --
  
   LET g_success = 'Y'
   IF g_action_choice CLIPPED = "confirm" OR   #按「確認」時
      g_action_choice CLIPPED = "insert"     #FUN-640243
   THEN
      IF g_fbg.fbgmksg='Y'   THEN
          IF g_fbg.fbg10 != '1' THEN
             CALL cl_err('','aws-078',1)
             LET g_success = 'N'
             RETURN
          END IF
      END IF
#     IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
   END IF
  
   BEGIN WORK
  
   OPEN t108_cl USING g_fbg.fbg01
   IF STATUS THEN
      CALL cl_err("OPEN t108_cl:", STATUS, 1)
      CLOSE t108_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t108_cl INTO g_fbg.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_fbg.fbg01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t108_cl ROLLBACK WORK RETURN
   END IF

   #CHI-B80007 -- begin --
   DECLARE t108_fbh_cur CURSOR FOR
      SELECT * FROM fbh_file WHERE fbh01=g_fbg.fbg01
   FOREACH t108_fbh_cur INTO l_fbh.*
      SELECT count(*) INTO l_cnt FROM fbh_file,fbg_file
       WHERE fbh01 = fbg01
         AND fbh03 = l_fbh.fbh03
         AND fbh031= l_fbh.fbh031 AND fbg02 <= g_fbg.fbg02
         AND fbgpost = 'N'
         AND fbg01 != g_fbg.fbg01
         AND fbgconf <> 'X'
      IF l_cnt  > 0 THEN
         LET l_msg = l_fbh.fbh01,' ',l_fbh.fbh02,' ',
                     l_fbh.fbh03,' ',l_fbh.fbh031
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
#     SELECT count(*) INTO l_n FROM npq_file
#      WHERE npq01 = g_fbg.fbg01
#        AND npq011 = 1
#        AND npqsys = 'FA'
#        AND npq00 = g_fbg00
#     IF l_n = 0 THEN
#        CALL t108_gen_glcr(g_fbg.*,g_fah.*)
#     END IF
#     CALL s_get_bookno(g_fbg.fbg02) RETURNING g_flag,g_bookno1,g_bookno2   #MOD-880229 add
#     #FUN-AB0088---add---str---
#     #固資已不和二套掛鉤，所以原本利用s_get_bookno取到賬別一及賬別二是用是否使用二套賬來判斷
#     #此處取賬別二要重新處理，應取固資參數欄位財二賬套faa02c作為賬別二的賬套
#     IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF
#     #FUN-AB0088---add---end--- 
#     IF g_success = 'Y' THEN 
#        CALL s_chknpq(g_fbg.fbg01,'FA',1,'0',g_bookno1)     #No.FUN-680028
##        IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN    #FUN-AB0088 mark
#        IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN    #FUN-AB0088 add
#           CALL s_chknpq(g_fbg.fbg01,'FA',1,'1',g_bookno2)     #No.FUN-680028
#        END IF
#     END IF
#     IF g_success = 'N' THEN RETURN END IF   #No.FUN-680028
#  END IF
#FUN-C30313---mark---END

#FUN-C30313---add---START-----
      SELECT count(*) INTO l_n FROM npq_file
       WHERE npq01 = g_fbg.fbg01
         AND npq011 = 1
         AND npqsys = 'FA'
         AND npq00 = g_fbg00
     #IF l_n = 0 THEN                                                                     #MOD-C50255 mark
      IF l_n = 0 AND                                                                      #MOD-C50255 add
         ((g_fah.fahdmy3 = 'Y') OR (g_faa.faa31 = 'Y' AND g_fah.fahdmy32 = 'Y' )) THEN    #MOD-C50255 add
         CALL t108_gen_glcr(g_fbg.*,g_fah.*)
      END IF
      CALL s_get_bookno(g_fbg.fbg02) RETURNING g_flag,g_bookno1,g_bookno2   #MOD-880229 add
      #FUN-AB0088---add---str---
      #固資已不和二套掛鉤，所以原本利用s_get_bookno取到賬別一及賬別二是用是否使用二套賬來判斷
      #此處取賬別二要重新處理，應取固資參數欄位財二賬套faa02c作為賬別二的賬套
      IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF
      #FUN-AB0088---add---end---
      IF g_success = 'Y' THEN
         IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
            CALL s_chknpq(g_fbg.fbg01,'FA',1,'0',g_bookno1)     #No.FUN-680028
         END IF
         IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN    #FUN-AB0088 add
            IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' THEN
               CALL s_chknpq(g_fbg.fbg01,'FA',1,'1',g_bookno2)     #No.FUN-680028
            END IF
         END IF
      END IF
      IF g_success = 'N' THEN RETURN END IF   #No.FUN-680028
#FUN-C30313---add---END-------
   UPDATE fbg_file SET fbgconf = 'Y' WHERE fbg01 = g_fbg.fbg01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('fbg01',g_fbg.fbg01,'upd fbgconf',STATUS,1)   #No.FUN-710028
      LET g_success = 'N'     #FUN-580109
   END IF
   CLOSE t108_cl
  
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'Y' THEN
      IF g_fbg.fbgmksg = 'Y' THEN #簽核模式
         CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
             WHEN 0  #呼叫 EasyFlow 簽核失敗
                  LET g_fbg.fbgconf="N"
                  LET g_success = "N"
                  ROLLBACK WORK
                  RETURN
             WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                  LET g_fbg.fbgconf="N"
                  ROLLBACK WORK
                  RETURN
         END CASE
      END IF
      IF g_success = 'Y' THEN
         LET g_fbg.fbg10='1'             #執行成功, 狀態值顯示為 '1' 已核准
         UPDATE fbg_file SET fbg10 = g_fbg.fbg10 WHERE fbg01=g_fbg.fbg01
         IF SQLCA.sqlerrd[3]=0 THEN
            LET g_success='N'
         END IF
         LET g_fbg.fbgconf='Y'           #執行成功, 確認碼顯示為 'Y' 已確認
         DISPLAY BY NAME g_fbg.fbgconf
         DISPLAY BY NAME g_fbg.fbg10
         COMMIT WORK
      ELSE
         LET g_fbg.fbgconf='N'
         LET g_success = 'N'
         ROLLBACK WORK
      END IF
   ELSE
      LET g_fbg.fbgconf='N'
      LET g_success = 'N'
      ROLLBACK WORK
   END IF
   IF g_fbg.fbgconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fbg.fbg10 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fbg.fbgconf,g_chr2,g_fbg.fbgpost,"",g_chr,"")
  
END FUNCTION
 
FUNCTION t108_ef()
 
  CALL t108_y_chk()      #CALL 原確認的 check 段
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
 
  IF aws_efcli2(base.TypeInfo.create(g_fbg),base.TypeInfo.create(g_fbh),'','','','')
  THEN
     LET g_success='Y'
     LET g_fbg.fbg10='S'
     DISPLAY BY NAME g_fbg.fbg10
  ELSE
     LET g_success='N'
  END IF
END FUNCTION
 
 
FUNCTION t108_z()
    DEFINE l_fbh03    LIKE fbh_file.fbh03,    #MOD-530223
           l_fbh031   LIKE fbh_file.fbh031,   #MOD-530223
           l_cnt      LIKE type_file.num5     #MOD-530223       #No.FUN-680070 SMALLINT
 
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fbg.fbg01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_fbg.* FROM fbg_file WHERE fbg01 = g_fbg.fbg01
   IF g_fbg.fbg10  ='S' THEN CALL cl_err("","mfg3557",0) RETURN END IF   #FUN-580109
   IF g_fbg.fbgconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_fbg.fbgconf='N' THEN RETURN END IF
   IF g_fbg.fbgpost='Y' THEN
      CALL cl_err(g_fbg.fbgpost,'afa-106',0)
      RETURN
   END IF
   IF g_fbg.fbgpost2='Y' THEN
      CALL cl_err(g_fbg.fbgpost2,'afa-106',0)
      RETURN
   END IF
   #-->判斷是否此張單據之後日期其資產有做銷帳.報廢作業
   DECLARE t108_c CURSOR FOR
      SELECT fbh03,fbh031 FROM fbh_file,fbg_file
             WHERE fbh01=fbg01 AND fbg01 = g_fbg.fbg01
   FOREACH t108_c INTO l_fbh03,l_fbh031
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM fbg_file,fbh_file
             WHERE fbg01=fbh01 AND fbh03 = l_fbh03 AND fbh031 = l_fbh031
                   AND fbg02 > g_fbg.fbg02 AND fbgconf = 'Y'
      IF l_cnt > 0 THEN
         CALL cl_err('','gfa-001',1) RETURN
      END IF
   END FOREACH   #MOD-690095
 
   #-->已拋轉總帳, 不可undo_confirm
   IF NOT cl_null(g_fbg.fbg08) THEN
      CALL cl_err(g_fbg.fbg08,'aap-145',1)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_fbg.fbg02 < g_faa.faa09 THEN
      CALL cl_err(g_fbg.fbg01,'aap-176',1) RETURN
   END IF

 #FUN-B60140   ---start   Add
  IF g_faa.faa31 = "Y" THEN
    #-->已拋轉總帳, 不可undo_confirm
     IF NOT cl_null(g_fbg.fbg082) THEN
        CALL cl_err(g_fbg.fbg082,'aap-145',1)
        RETURN
     END IF
     #-->立帳日期不可小於關帳日期
     IF g_fbg.fbg02 < g_faa.faa092 THEN
        CALL cl_err(g_fbg.fbg01,'aap-176',1) RETURN
     END IF
  END IF
 #FUN-B60140   ---end     Add 
  IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
 
    OPEN t108_cl USING g_fbg.fbg01
    IF STATUS THEN
       CALL cl_err("OPEN t108_cl:", STATUS, 1)
       CLOSE t108_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t108_cl INTO g_fbg.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbg.fbg01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t108_cl ROLLBACK WORK RETURN
    END IF
 
   UPDATE fbg_file SET fbgconf = 'N',fbg10 = '0'   #FUN-580109
    WHERE fbg01 = g_fbg.fbg01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","fbg_file",g_fbg.fbg01,"",STATUS,"","upd fbgconf",1)  #No.FUN-660136
      LET g_fbg.fbgconf='Y'
      CLOSE t108_cl ROLLBACK WORK
      RETURN
   ELSE
      LET g_fbg.fbgconf='N'
      LET g_fbg.fbg10='0'   #FUN-580109
      CLOSE t108_cl
      COMMIT WORK
      DISPLAY BY NAME g_fbg.fbgconf #
      DISPLAY BY NAME g_fbg.fbg10   #FUN-580109
   END IF
   IF g_fbg.fbgconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fbg.fbg10 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fbg.fbgconf,g_chr2,g_fbg.fbgpost,"",g_chr,"")
END FUNCTION
 
FUNCTION t108_fbh03(p_cmd)
    DEFINE l_cnt    LIKE type_file.num5,         #No.FUN-680070 SMALLINT
           l_faj06  LIKE faj_file.faj06,
           l_faj18  LIKE faj_file.faj18,
           l_faj100 LIKE faj_file.faj100,
           l_faj43   LIKE faj_file.faj43,
           l_fajconf LIKE faj_file.fajconf,
           p_cmd    LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
    DEFINE l_faj41  LIKE faj_file.faj41         #MOD-B30593
    DEFINE   l_n         LIKE type_file.num5    #CHI-B80007 add
 
    LET g_errno=' '
    LET l_fajconf=' ' LET l_faj43=' '         #No.MOD-4A0150
    IF cl_null(g_fbh[l_ac].fbh031) THEN LET g_fbh[l_ac].fbh031=' ' END IF
    #CHI-B80007 -- begin --
    SELECT count(*) INTO l_n FROM fbh_file,fbg_file
      WHERE fbh01 = fbg01
       AND fbh03  = g_fbh[l_ac].fbh03
       AND fbh031 = g_fbh[l_ac].fbh031
       AND fbg02 <= g_fbg.fbg02
       AND fbgpost = 'N'
       AND fbg01 != g_fbg.fbg01
       AND fbgconf <> 'X'
    IF l_n  > 0 THEN
       LET g_errno = 'afa-309'
       RETURN
    END IF
    #CHI-B80007 -- end --
    SELECT faj06,faj18,(faj17-faj58),(faj14+faj141-faj59),
           (faj32-faj60),(faj33+faj331),(faj62+faj63-faj69),  #MOD-970231
           (faj67-faj70),faj68,faj100,faj43,fajconf,
           faj40,faj42,faj26,(faj101-faj102),(faj103-faj104),faj41  #No:A099 #MOD-B30593 add faj41
      INTO l_faj06,l_faj18,g_fbh04,g_fbh06,
           g_fbh07,g_fbh08,g_fbh09,
           g_fbh10,g_fbh11,l_faj100,l_faj43,l_fajconf,
           g_faj40,g_faj42,g_faj26,g_fbh12,g_fbh13,l_faj41    #No:A099 #MOD-B30593 add faj4
      FROM faj_file WHERE faj02=g_fbh[l_ac].fbh03
       AND faj022=g_fbh[l_ac].fbh031
      CASE
         #WHEN SQLCA.SQLCODE = 100        LET g_errno = 'afa-093'    #MOD-C70265 mark
          WHEN SQLCA.SQLCODE = 100        LET g_errno = 'afa-134'    #MOD-C70265 add
          WHEN l_faj100 > g_fbg.fbg02     LET g_errno = 'afa-113'
          WHEN l_fajconf  = 'N'           LET g_errno = 'afa-312'
          WHEN l_faj41  matches '[234]'   LET g_errno = 'afa-951'  #MOD-B30593
          WHEN l_faj43  matches '[056X]'  LET g_errno = 'afa-313'
          OTHERWISE LET g_errno = SQLCA.SQLCODE USING '-------'
      END CASE
      IF p_cmd='a' AND cl_null(g_errno) THEN             #MOD-950166         
         LET g_fbh[l_ac].fbh04  =g_fbh04
         LET g_fbh[l_ac].fbh06  =g_fbh06
         LET g_fbh[l_ac].fbh07  =g_fbh07
         LET g_fbh[l_ac].fbh08  =g_fbh06 - g_fbh07
         LET g_fbh[l_ac].fbh12  =g_fbh12                 #No:A099
         LET g_fbh_e[l_ac].fbh09=g_fbh09
         LET g_fbh_e[l_ac].fbh10=g_fbh10
         LET g_fbh_e[l_ac].fbh11=g_fbh09 - g_fbh10
         LET g_fbh_e[l_ac].fbh13=g_fbh13                 #No:A099
         DISPLAY BY NAME g_fbh[l_ac].fbh04
         DISPLAY BY NAME g_fbh[l_ac].fbh06
         DISPLAY BY NAME g_fbh[l_ac].fbh07
         DISPLAY BY NAME g_fbh[l_ac].fbh08
         DISPLAY BY NAME g_fbh[l_ac].fbh12
         DISPLAY BY NAME g_fbh_e[l_ac].fbh09
         DISPLAY BY NAME g_fbh_e[l_ac].fbh10
         DISPLAY BY NAME g_fbh_e[l_ac].fbh11
         DISPLAY BY NAME g_fbh_e[l_ac].fbh13
      END IF
     IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_fbh[l_ac].faj06=l_faj06
       LET g_fbh[l_ac].faj18=l_faj18
       DISPLAY BY NAME g_fbh[l_ac].faj06
       DISPLAY BY NAME g_fbh[l_ac].faj18
     END IF
END FUNCTION
 
FUNCTION t108_e(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
          l_fbh09   LIKE fbh_file.fbh09,
          l_fbh10   LIKE fbh_file.fbh10,
          l_fbh11   LIKE fbh_file.fbh11,
          l_fbh13   LIKE fbh_file.fbh13         #No:A099
   DEFINE ls_tmp STRING
 
   LET p_row = 7  LET p_col = 16
   OPEN WINDOW t108_w1 AT p_row,p_col WITH FORM "afa/42f/afat1081"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("afat1081")
 
   IF p_cmd = 'u' THEN
      SELECT fbh09,fbh10,fbh11,fbh13
        INTO l_fbh09,l_fbh10,l_fbh11,l_fbh13
        FROM fbh_file
       WHERE fbh01=g_fbg.fbg01 AND fbh02=g_fbh[l_ac].fbh02
      IF SQLCA.sqlcode THEN
         LET l_fbh09=0 LET l_fbh10=0
         LET l_fbh11=0 LET l_fbh13=0
      END IF
      LET  g_fbh_e[l_ac].fbh09 = l_fbh09
      LET  g_fbh_e[l_ac].fbh10 = l_fbh10
      LET  g_fbh_e[l_ac].fbh11 = l_fbh11
      LET  g_fbh_e[l_ac].fbh13 = l_fbh13       #No:A099
   END IF
   INPUT g_fbh_e[l_ac].fbh09,g_fbh_e[l_ac].fbh10,
         g_fbh_e[l_ac].fbh13,g_fbh_e[l_ac].fbh11
         WITHOUT DEFAULTS FROM fbh09,fbh10,fbh13,fbh11     #end No:A099

     #-MOD-B30014-add
      AFTER FIELD fbh09
         IF NOT cl_null(g_fbh_e[l_ac].fbh09) THEN      
            IF g_fbh_e[l_ac].fbh09<0 THEN
               CALL cl_err('','mfg4012',0)
               NEXT FIELD fbh09
            END IF
         ELSE                                          
            CALL cl_err(g_fbh_e[l_ac].fbh09,'aim-927',0) 
            NEXT FIELD fbh09
         END IF

      AFTER FIELD fbh10
         IF NOT cl_null(g_fbh_e[l_ac].fbh10) THEN      
            IF g_fbh_e[l_ac].fbh10<0 THEN
               CALL cl_err('','mfg4012',0)
               NEXT FIELD fbh10
            END IF
         ELSE                                          
            CALL cl_err(g_fbh_e[l_ac].fbh10,'aim-927',0) 
            NEXT FIELD fbh10
         END IF

      AFTER FIELD fbh13
         IF NOT cl_null(g_fbh_e[l_ac].fbh13) THEN      
            IF g_fbh_e[l_ac].fbh13<0 THEN
               CALL cl_err('','mfg4012',0)
               NEXT FIELD fbh13
            END IF
         ELSE                                          
            CALL cl_err(g_fbh_e[l_ac].fbh13,'aim-927',0) 
            NEXT FIELD fbh13
         END IF

      AFTER FIELD fbh11
         IF NOT cl_null(g_fbh_e[l_ac].fbh11) THEN      
            IF g_fbh_e[l_ac].fbh11<0 THEN
               CALL cl_err('','mfg4012',0)
               NEXT FIELD fbh11
            END IF
         ELSE                                          
            CALL cl_err(g_fbh_e[l_ac].fbh11,'aim-927',0) 
            NEXT FIELD fbh11
         END IF
     #-MOD-B30014-end

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
     CLOSE WINDOW t108_w1
     RETURN
  END IF
  UPDATE fbh_file SET
         fbh09=g_fbh_e[l_ac].fbh09,fbh10=g_fbh_e[l_ac].fbh10,
         fbh11=g_fbh_e[l_ac].fbh11,fbh13=g_fbh_e[l_ac].fbh13  #No:A099
  WHERE fbh01=g_fbg.fbg01 AND fbh02=g_fbh[l_ac].fbh02
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
     CALL cl_err3("upd","fbh_file",g_fbg.fbg01,g_fbh[l_ac].fbh02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
   END IF
   CLOSE WINDOW t108_w1
END FUNCTION
 
FUNCTION t108_g()
   DEFINE  l_wc        LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(600)
           l_wc2       LIKE type_file.chr1000,      #No.MOD-9C0334
           l_sql       LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(600)
           chr         LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
           l_i         LIKE type_file.num5,         #No.FUN-680070 SMALLINT
           l_fbh       RECORD
                       faj02     LIKE faj_file.faj02,
                       faj022    LIKE faj_file.faj022,
                       faj06     LIKE faj_file.faj06,
                       faj18     LIKE faj_file.faj18,
                       fbh04     LIKE fbh_file.fbh04,
                       fbh06     LIKE fbh_file.fbh06,
                       fbh07     LIKE fbh_file.fbh07,
                       fbh08     LIKE fbh_file.fbh08,
                       fbh09     LIKE fbh_file.fbh09,
                       fbh10     LIKE fbh_file.fbh10,
                       fbh11     LIKE fbh_file.fbh11,
                       fbh12     LIKE fbh_file.fbh12,    #No:A099
                       fbh13     LIKE fbh_file.fbh13,    #No:A099
                       faj15     LIKE faj_file.faj15,    #MOD-780231 add
                       faj17     LIKE faj_file.faj17     #MOD-CB0108 add
                       END RECORD
   DEFINE ls_tmp STRING
   DEFINE t_azi04      LIKE    azi_file.azi04            #MOD-780231 add
   DEFINE l_cnt        LIKE    type_file.num5            #CHI-B80007 add
  DEFINE l_fbh04     LIKE fbh_file.fbh04    #No:FUN-BB0122
  DEFINE l_fbh062    LIKE fbh_file.fbh062   #No:FUN-BB0122
  DEFINE l_fbh072    LIKE fbh_file.fbh072   #No:FUN-BB0122
  DEFINE l_fbh082    LIKE fbh_file.fbh082   #No:FUN-BB0122
  DEFINE l_fbh122    LIKE fbh_file.fbh122   #No:FUN-BB0122
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fbg.fbg01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fbg.fbgconf='Y' THEN CALL cl_err(g_fbg.fbg01,'afa-107',0) RETURN END IF
   IF g_fbg.fbgconf='X' THEN CALL cl_err(g_fbg.fbg01,'9024',0) RETURN END IF
    IF NOT cl_confirm('afa-103') THEN RETURN END IF     #No.MOD-470541
 
    LET p_row = 6 LET p_col =  15
    OPEN WINDOW t108_w2 AT p_row,p_col WITH FORM "afa/42f/afat1032"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("afat1032")
 
    ## per 與 afat1032 同
   #CONSTRUCT l_wc ON faj01,faj02,faj022,faj53,faj19,faj20,faj21,faj33          #No.FUN-B50118 mark
   #             FROM faj01,faj02,faj022,faj53,faj19,faj20,faj21,faj33          #No.FUN-B50118 mark
    CONSTRUCT l_wc ON faj01,faj93,faj02,faj022,faj53,faj19,faj20,faj21,faj33    #No.FUN-B50118 add
                 FROM faj01,faj93,faj02,faj022,faj53,faj19,faj20,faj21,faj33    #No.FUN-B50118 add
 
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
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW t108_w2
       RETURN
    END IF
    BEGIN WORK
    LET l_sql =" SELECT faj02,faj022,faj06,faj18,(faj17-faj58), ",
               "       (faj14+faj141-faj59),(faj32-faj60),(faj33+faj331),",  #MOD-970231
               "       (faj62+faj63-faj69),(faj67-faj70),faj68,",
               "       (faj101-faj102),(faj103-faj104),faj15,faj17 ",        #MOD-780231 add faj15 #No:A099 #MOD-CB0108 add faj17
               "  FROM faj_file ",
               " WHERE faj43 NOT IN ('0','5','6','X') AND fajconf='Y' ",
               #"   AND faj100< '",g_fbg.fbg02,"'",   #TQC-B50093
               "   AND ",l_wc CLIPPED,
               "   ORDER BY 1"
   PREPARE t108_pre1 FROM l_sql
   IF SQLCA.SQLCODE != 0 THEN
      CALL cl_err('pre1:',SQLCA.sqlcode,0)
      ROLLBACK WORK RETURN
   END IF
   DECLARE t108_cur1 CURSOR FOR t108_pre1
                                                                
   SELECT MAX(fbh02)+1 INTO l_i FROM fbh_file WHERE fbh01=g_fbg.fbg01
   IF cl_null(l_i) THEN LET l_i =1 END IF
   LET g_success='Y'        #MOD-740292
   CALL s_showmsg_init()    #No.FUN-710028
   FOREACH t108_cur1 INTO l_fbh.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
     IF SQLCA.sqlcode != 0 THEN
        CALL s_errmsg('','','foreach:',SQLCA.sqlcode,0)  #No.FUN-710028
        EXIT FOREACH
     END IF
     #no:4532檢查資產盤點期間應不可做異動
     SELECT COUNT(*) INTO g_cnt FROM fca_file
      WHERE fca03  = l_fbh.faj02
        AND fca031 = l_fbh.faj022
        AND fca15  = 'N'
         IF g_cnt > 0 THEN
            CONTINUE FOREACH
         END IF
     IF cl_null(l_fbh.fbh12) THEN LET l_fbh.fbh12 = 0 END IF
     IF cl_null(l_fbh.fbh13) THEN LET l_fbh.fbh13 = 0 END IF
     IF cl_null(l_fbh.faj022) THEN
        LET  l_fbh.faj022 = ' '
     END IF
     IF g_faa.faa23 = 'N' THEN
        SELECT COUNT(*) INTO g_cnt FROM fan_file
         WHERE fan01 = l_fbh.faj02
           AND fan02 = l_fbh.faj022
           AND ((fan03 = YEAR(g_fbg.fbg02) AND fan04 >= MONTH(g_fbg.fbg02))
            OR fan03 > YEAR(g_fbg.fbg02))
           AND fan041 = '1'   #MOD-BC0025 add
       #FUN-B60140   ---start   Mark
       ##FUN-AB0088---add---str---
       #LET g_cnt1 = 0
       #IF g_faa.faa31 = 'Y' THEN
       #    SELECT COUNT(*) INTO g_cnt1 FROM fbn_file
       #     WHERE fbn01 = l_fbh.faj02
       #       AND fbn02 = l_fbh.faj022
       #       AND ((fbn03 = YEAR(g_fbg.fbg02) AND fbn04 >= MONTH(g_fbg.fbg02))
       #        OR fbn03 > YEAR(g_fbg.fbg02))
       #END IF
       #LET g_cnt = g_cnt + g_cnt1
       ##FUN-AB0088---add---end---
       #FUN-B60140   ---end     Mark
        IF g_cnt > 0 THEN
           CALL cl_err(l_fbh.faj02,'afa-092',0)
           CONTINUE FOREACH
        END IF
     END IF
     #FUN-B60140   ---start   Add
     IF g_faa.faa31 = "Y" THEN
         IF g_faa.faa232= 'N' THEN
            LET g_cnt1 = 0
            SELECT COUNT(*) INTO g_cnt1 FROM fbn_file
             WHERE fbn01 = l_fbh.faj02
               AND fbn02 = l_fbh.faj022
               AND ((fbn03 = YEAR(g_fbg.fbg02) AND fbn04 >= MONTH(g_fbg.fbg02))
                OR fbn03 > YEAR(g_fbg.fbg02))
               AND fbn041 = '1'   #MOD-BC0025 add
            IF g_cnt1> 0 THEN
               CALL cl_err(l_fbh.faj02,'afa-092',0)
               CONTINUE FOREACH
            END IF
         END IF
      END IF
     #FUN-B60140   ---end     Add
     #CHI-B80007 -- begin --
     SELECT count(*) INTO l_cnt FROM fbh_file,fbg_file
       WHERE fbh01 = fbg01
        AND fbh03  = l_fbh.faj02
        AND fbh031 = l_fbh.faj022
        AND fbg02 <= g_fbg.fbg02
        AND fbgpost = 'N'
        AND fbg01 != g_fbg.fbg01
        AND fbgconf <> 'X'
     IF l_cnt > 0 THEN
        CONTINUE FOREACH
     END IF
     #CHI-B80007 -- end -- 
    #--------------------MOD-CB0108--------------------(S)
     IF l_fbh.faj17 = 1 THEN
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt
          FROM fbe_file,fbf_file
         WHERE fbe01 = fbf01
           AND fbf03 = l_fbh.faj02 
           AND fbf031 = l_fbh.faj022 
           AND fbeconf <> 'X'
        IF l_cnt > 0 THEN
           CONTINUE FOREACH
        END IF
     END IF
    #--------------------MOD-CB0108--------------------(E)

     SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01= l_fbh.faj15   #MOD-780231 add
     LET l_fbh.fbh07 = cl_digcut(l_fbh.fbh07,t_azi04)  #MOD-780231 add
     LET l_fbh.fbh08 = cl_digcut(l_fbh.fbh08,t_azi04)  #MOD-780231 add
 
     #-----No:FUN-BB0122-----
     SELECT (faj17-faj582),(faj142+faj1412-faj592),
            (faj322-faj602),(faj1012-faj1022)
       INTO l_fbh04,l_fbh062,l_fbh072,l_fbh122
       FROM faj_file
      WHERE faj02 = l_fbh.faj02
        AND faj022= l_fbh.faj022
     IF cl_null(l_fbh04) OR l_fbh04 = 0 THEN
        LET l_fbh04 = l_fbh.fbh04
     END IF

     IF l_fbh.fbh04 > 0 THEN
         LET l_fbh072 =l_fbh072*(l_fbh.fbh04/l_fbh04)
         #LET l_fbh072 =cl_digcut(l_fbh072,g_azi04)          #C60010 mark
         LET l_fbh062 =l_fbh062*(l_fbh.fbh04/l_fbh04)
         #LET l_fbh062 =cl_digcut(l_fbh062,g_azi04)          #C60010 mark
         LET l_fbh122 = l_fbh122*(l_fbh.fbh04/l_fbh04)
         #LET l_fbh122 =cl_digcut(l_fbh122,g_azi04)          #C60010 mark
     END IF
     IF cl_null(l_fbh062) THEN LET l_fbh062=0 END IF
     IF cl_null(l_fbh072) THEN LET l_fbh072=0 END IF
     IF cl_null(l_fbh122) THEN LET l_fbh122=0 END IF
     #-----No:FUN-BB0122 End-----
     #CHI-C60010---str---
      CALL cl_digcut(l_fbh072,g_azi04_1) RETURNING l_fbh072
      CALL cl_digcut(l_fbh062,g_azi04_1) RETURNING l_fbh062
      CALL cl_digcut(l_fbh122,g_azi04_1) RETURNING l_fbh122
     #CHI-C60010---end---

     INSERT INTO fbh_file(fbh01,fbh02,fbh03,fbh031,fbh04,fbh05,fbh06,
                          fbh07,fbh08,fbh09,fbh10,fbh11,fbh12,fbh13,
                          fbh062,fbh072,fbh082,fbh122,   #No:FUN-BB0122
                          fbhlegal) #FUN-980003 add
                   VALUES(g_fbg.fbg01,l_i,l_fbh.faj02,l_fbh.faj022,
                          l_fbh.fbh04,'',l_fbh.fbh06,l_fbh.fbh07,
                          l_fbh.fbh08,l_fbh.fbh09,l_fbh.fbh10,
                          l_fbh.fbh11,l_fbh.fbh12,l_fbh.fbh13,
                          l_fbh062,l_fbh072,(l_fbh062-l_fbh072),l_fbh122,   #No:FUN-BB0122
                          g_legal) #FUN-980003 add
     IF STATUS  THEN
        LET g_showmsg = g_fbg.fbg01,"/",l_i                         #No.FUN-710028
        CALL s_errmsg('fbh01,fbh02',g_showmsg,'ins fbh',STATUS,1)   #No.FUN-710028
        LET g_success = 'N' #No.FUN-710028
        CONTINUE FOREACH    #No.FUN-710028
     END IF
     LET l_i = l_i + 1
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
   IF g_success = 'Y' THEN   #No.FUN-710028
      COMMIT WORK
   ELSE                      #No.FUN-710028
      ROLLBACK WORK          #No.FUN-710028
   END IF                    #No.FUN-710028
   CLOSE WINDOW t108_w2
   LET l_wc2=" fbh01='",g_fbg.fbg01,"'"      #MOD-9C0335 add
   CALL t108_b_fill(l_wc2)                   #MOD-9C0335 l_wc modify l_wc2
  
END FUNCTION
 
FUNCTION t108_m()
 DEFINE  l_sql       LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(400)
         l_fbh02     LIKE fbh_file.fbh02, # saki 20070821 rowid chr18 -> num10 
         l_fbh03     LIKE fbh_file.fbh03,
         l_fbh031    LIKE fbh_file.fbh031,
         l_fbh04     LIKE fbh_file.fbh04,
         l_fbh06     LIKE fbh_file.fbh06,
         l_fbh07     LIKE fbh_file.fbh07,
         l_fbh08     LIKE fbh_file.fbh08,
         l_qty       LIKE fbh_file.fbh04,
         l_fan07     LIKE fan_file.fan07,
         l_yy,l_mm   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
         l_last      LIKE type_file.num5,         #No.FUN-680070 SMALLINT
         l_rate      LIKE azx_file.azx04,       #No.FUN-680070 DEC(5,3)
         l_amt       LIKE fan_file.fan07,
         l_cost,l_accd,l_curr LIKE fbh_file.fbh06
#FUN-AB0088---add---str---
DEFINE l_fbh062     LIKE fbh_file.fbh062,
       l_fbh072     LIKE fbh_file.fbh072,
       l_fbh082     LIKE fbh_file.fbh082,
       l_qty2       LIKE fbh_file.fbh04,
       l_fbn07      LIKE fbn_file.fbn07,
       l_amt2       LIKE fan_file.fan07,
       l_cost2,l_accd2,l_curr2 LIKE fbh_file.fbh062
#FUN-AB0088---add---end---
 
    IF cl_null(g_fbg.fbg01) THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_faa.faa23 !='Y' THEN CALL cl_err('','afa-344',0) RETURN END IF
    IF g_fbg.fbgconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_fbg.fbgconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_fbg.fbgpost = 'Y' THEN CALL cl_err('','afa-101',0) RETURN END IF
    LET l_sql = "SELECT fbh02,fbh03,fbh031,fbh04 FROM fbh_file",
                " WHERE fbh01 = '",g_fbg.fbg01,"'"
    PREPARE t108_prcm FROM l_sql
    DECLARE t108_cm CURSOR WITH HOLD FOR t108_prcm
 
    LET g_success = 'Y'
    BEGIN WORK
    CALL s_showmsg_init()   #No.FUN-710028
    FOREACH t108_cm  INTO l_fbh02,l_fbh03,l_fbh031,l_fbh04
       IF g_success='N' THEN                                                                                                         
          LET g_totsuccess='N'                                                                                                       
          LET g_success="Y"                                                                                                          
       END IF                                                                                                                        
 
       IF SQLCA.sqlcode THEN
          CALL s_errmsg('fbh01',g_fbg.fbg01,'foreach:',STATUS,0) EXIT FOREACH   #No.FUN-710028
       END IF
      #message l_fbh03,' ',l_fbh031          #MOD-B60173 mark
       SELECT (faj17-faj58),(faj14+faj141-faj59),(faj32-faj60),faj33
         INTO l_qty,l_cost,l_accd,l_curr
         FROM faj_file WHERE faj02=l_fbh03 AND faj022=l_fbh031
         IF SQLCA.sqlcode=100 THEN
            LET g_showmsg = l_fbh03,"/",l_fbh031     #No.FUN-710028
            CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj_file:',STATUS,1)    #No.FUN-710028
            LET g_success = 'N'
            CONTINUE FOREACH     #No.FUN-710028
         END IF
##No.2825 modify 1998/11/20 for泰國法律用當月處分其折舊*DAY(處分日期)/當月總天數
         IF g_faa.faa23 = 'Y' AND g_faa.faa15 = '4' THEN
            SELECT fan07 INTO l_fan07 FROM fan_file
             WHERE fan01 = l_fbh03  AND fan02 = l_fbh031
               AND fan03 = YEAR(g_fbg.fbg02)
               AND fan04 = MONTH(g_fbg.fbg02)
               AND fan041 = '1'
            IF cl_null(l_fan07) THEN
               LET g_showmsg = l_fbh03,"/",l_fbh031,"/",'1'     #No.FUN-710028
               CALL s_errmsg('fan01,fan02,fan041',g_showmsg,'','afa-376',0)    #No.FUN-710028
               CONTINUE FOREACH   #No.FUN-710028
            END IF
            LET l_yy = YEAR(g_fbg.fbg02)
            LET l_mm = MONTH(g_fbg.fbg02)
            IF l_mm = 12 THEN
               LET l_mm = 1 LET l_yy = l_yy + 1
            ELSE
               LET l_mm = l_mm + 1
            END IF
            LET l_last = DAY(MDY(l_mm,1,l_yy)-1)
            LET l_rate = DAY(g_fbg.fbg02) / l_last
            LET l_amt = l_fan07 * l_rate
            LET l_accd = l_accd -l_fan07 + l_amt    #未折減額
         END IF
         IF l_qty = 0 OR cl_null(l_qty)
         THEN LET l_fbh06=l_cost
              LET l_fbh07=l_accd
              LET l_fbh08=l_fbh06 - l_fbh07
         ELSE LET l_fbh06=l_cost * (l_fbh04/l_qty)
              LET l_fbh07=l_accd * (l_fbh04/l_qty)
              LET l_fbh08=l_fbh06 - l_fbh07
         END IF
         LET l_fbh06 = cl_digcut(l_fbh06,g_azi04)   #TQC-780089
         LET l_fbh07 = cl_digcut(l_fbh07,g_azi04)   #TQC-780089
         LET l_fbh08 = cl_digcut(l_fbh08,g_azi04)   #TQC-780089
         UPDATE fbh_file SET fbh06 = l_fbh06,     #本幣成本
                             fbh07 = l_fbh07,     #累積折舊
                             fbh08 = l_fbh08      #未折減額
                         WHERE fbh01 = g_fbg.fbg01 AND fbh02 = l_fbh02
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('fbh02',l_fbh02,'upd fbh_file:',STATUS,1)    #No.FUN-710028
            LET g_success = 'N'
            CONTINUE FOREACH     #No.FUN-710028
         END IF

         #FUN-AB0088---add---str---
         IF g_faa.faa31 = 'Y' THEN
          SELECT (faj17-faj582),(faj142+faj1412-faj592),(faj322-faj602),faj332
            INTO l_qty2,l_cost2,l_accd2,l_curr2
            FROM faj_file WHERE faj02=l_fbh03 AND faj022=l_fbh031
          IF SQLCA.sqlcode THEN
             LET g_showmsg = l_fbh03,"/",l_fbh031  
             CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj_file:',STATUS,1)    
             LET g_success = 'N'
             CONTINUE FOREACH     
          END IF
          #No.TQC-C30315  --Begin
          IF cl_null(l_qty2)  THEN LET l_qty2 = 0  END IF
          IF cl_null(l_cost2) THEN LET l_cost2 = 0 END IF
          IF cl_null(l_accd2) THEN LET l_accd2 = 0 END IF
          IF cl_null(l_curr2) THEN LET l_curr2 = 0 END IF
          #No.TQC-C30315  --End  
          IF g_faa.faa232 = 'Y' AND g_faa.faa152 = '4' THEN #FUN-B60140   Mod faa23 --> faa232   faa15 -->faa152
             SELECT fbn07 INTO l_fbn07 FROM fbn_file
              WHERE fbn01 = l_fbh03  AND fbn02 = l_fbh031
                AND fbn03 = YEAR(g_fbg.fbg02)
                AND fbn04 = MONTH(g_fbg.fbg02)
                AND fbn041 = '1'
             IF cl_null(l_fbn07) THEN
                LET g_showmsg = l_fbh03,"/",l_fbh031,"/",'1'    
                CALL s_errmsg('fbn01,fbn02,fbn041',g_showmsg,'','afa-376',0) 
                CONTINUE FOREACH  
             END IF
             LET l_amt2 = l_fan07 * l_rate
             LET l_accd2 = l_accd2 -l_fan07 + l_amt2   
          END IF

          IF l_qty = 0 OR cl_null(l_qty) THEN
             LET l_fbh062=l_cost2
             LET l_fbh072=l_accd2
             LET l_fbh082=l_fbh062 - l_fbh072
          ELSE
             LET l_fbh062=l_cost2 * (l_fbh04/l_qty2)
             LET l_fbh072=l_accd2 * (l_fbh04/l_qty2)
             LET l_fbh082=l_fbh062 - l_fbh072
          END IF
         #CHI-C60010---str---
          #LET l_fbh062 = cl_digcut(l_fbh062,g_azi04)
          #LET l_fbh072 = cl_digcut(l_fbh072,g_azi04)
          #LET l_fbh082 = cl_digcut(l_fbh082,g_azi04) 
          LET l_fbh062 = cl_digcut(l_fbh062,g_azi04_1)
          LET l_fbh072 = cl_digcut(l_fbh072,g_azi04_1)
          LET l_fbh082 = cl_digcut(l_fbh082,g_azi04_1)
         #CHI-C60010---end---
          UPDATE fbh_file SET fbh062 = l_fbh062,    
                              fbh072 = l_fbh072,   
                              fbh082 = l_fbh082   
                      #   WHERE ROWID = l_rowid     #FUN-AB0088 mark
                          WHERE fbh01 = g_fbg.fbg01 AND fbh02 = l_fbh02   #FUN-AB0088 add 
          IF SQLCA.sqlcode THEN
            #CALL s_errmsg('ROWID',l_rowid,'upd fbh_file:',STATUS,1) #FUN-AB0088 mark 
             CALL s_errmsg('fbh02',l_fbh02,'upd fbh_file:',STATUS,1) #FUN-AB0088 add  
             LET g_success = 'N'
             CONTINUE FOREACH    
          END IF
        END IF 
         #FUN-AB0088---add---end---
    END FOREACH
    IF g_totsuccess="N" THEN                                                                                                        
       LET g_success="N"                                                                                                            
    END IF                                                                                                                          
    CALL s_showmsg()   #No.FUN-710028
    IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION
 
 
FUNCTION t108_s(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
   DEFINE l_msg   LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(40)
   DEFINE l_bdate,l_edate LIKE type_file.dat          #No.FUN-680070 DATE
   DEFINE l_flag,m_chr LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
   DEFINE l_fbh   RECORD LIKE fbh_file.*
   DEFINE l_faj   RECORD LIKE faj_file.*
   DEFINE l_mm,l_yy      LIKE type_file.num10        #No.FUN-680070 INTEGER
   DEFINE l_c            LIKE fbh_file.fbh06
   DEFINE l_qty   LIKE   fbh_file.fbh04
   DEFINE l_chr   LIKE type_file.chr8,         #No.FUN-680070 VARCHAR(08)
          l_fbh06 LIKE fbh_file.fbh06,
          l_fbh07 LIKE fbh_file.fbh07,
          l_fbh08 LIKE fbh_file.fbh08
   DEFINE sql     LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(400)
   DEFINE l_mm1   LIKE type_file.num5         #No.FUN-680070 SMALLINT
#FUN-AB0088---add---str---
   DEFINE m_chr2  LIKE type_file.chr1 
   DEFINE l_c2    LIKE fbh_file.fbh062 
   DEFINE l_qty2  LIKE fbh_file.fbh04  
   DEFINE l_fbh062 LIKE fbh_file.fbh062 
   DEFINE l_fbh072 LIKE fbh_file.fbh072 
   DEFINE l_fbh082 LIKE fbh_file.fbh082 
   DEFINE l_edate2 LIKE type_file.dat
#FUN-AB0088---add---end---
   DEFINE l_faj582 LIKE faj_file.faj582        #No.MOD-B80195 add
   DEFINE l_faj17  LIKE faj_file.faj17         #No.MOD-B80195 add
   DEFINE l_faj312 LIKE faj_file.faj312        #No.MOD-B80195 add
   DEFINE l_cnt    LIKE type_file.num5   #FUN-B60140   Add
   DEFINE l_last     LIKE type_file.num5      #MOD-C80118 add
   DEFINE l_rate     LIKE azx_file.azx04      #MOD-C80118 add
   DEFINE l_fan07    LIKE fan_file.fan07      #MOD-C80118 add
   DEFINE l_fbn07    LIKE fan_file.fan07      #MOD-C80118 add
   DEFINE l_diffamt  LIKE fan_file.fan07      #MOD-C80118 add
   DEFINE l_diffamt2 LIKE fan_file.fan07      #MOD-C80118 add
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fbg.fbg01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_fbg.* FROM fbg_file WHERE fbg01 = g_fbg.fbg01
   IF g_fbg.fbgconf != 'Y' OR g_fbg.fbgpost != 'N' THEN
      CALL cl_err(g_fbg.fbg01,'afa-100',0)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add- 
   #-->立帳日期小於關帳日期
   IF g_fbg.fbg02 < g_faa.faa09 THEN
      CALL cl_err(g_fbg.fbg01,'aap-176',1) RETURN
   END IF
  #-MOD-A80137-end- 
      #CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate #CHI-A60036 mark
      #CHI-A60036 add --start--
      CALL s_get_bookno(g_faa.faa07)   
          RETURNING g_flag,g_bookno1,g_bookno2
#     IF g_aza.aza63 = 'Y' THEN     #FUN-AB0088 mark
##-----No:FUN-BA0112 Mark-----
#      IF g_faa.faa31 = 'Y' THEN     #FUN-AB0088
#         CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
#      ELSE
         CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
#      END IF
##-----No:FUN-BA0112 Mark END-----
      #CHI-A60036 add --end--
      IF g_fbg.fbg02 < l_bdate OR g_fbg.fbg02 > l_edate THEN
         CALL cl_err(g_fbg.fbg02,'afa-308',0)
         RETURN
      END IF
  #END IF

   #FUN-B60140   ---start   Add
      IF g_faa.faa31 = "Y" THEN
         LET g_bookno2 = g_faa.faa02c   #MOD-BC0010 add
          CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno2) RETURNING l_flag,l_bdate,l_edate
          IF g_fbg.fbg02 < l_bdate OR g_fbg.fbg02 > l_edate THEN
             CALL cl_err(g_fbg.fbg02,'afa-308',0)
             RETURN
          END IF
       END IF
   #FUN-B60140   ---end     Add 

   IF NOT cl_sure(18,20) THEN RETURN END IF
   BEGIN WORK
 
   OPEN t108_cl USING g_fbg.fbg01
   IF STATUS THEN
      CALL cl_err("OPEN t108_cl:", STATUS, 1)
      CLOSE t108_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t108_cl INTO g_fbg.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbg.fbg01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t108_cl ROLLBACK WORK RETURN
    END IF
   LET g_success ='Y'
   DECLARE t108_cur2 CURSOR FOR
      SELECT * FROM fbh_file WHERE fbh01=g_fbg.fbg01
   CALL s_showmsg_init()    #No.FUN-710028
   FOREACH t108_cur2 INTO l_fbh.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF SQLCA.sqlcode != 0 THEN
         CALL s_errmsg('fbh01',g_fbg.fbg01,'foreach:',SQLCA.sqlcode,0)   #No.FUN-710028
         EXIT FOREACH
      END IF
 
 
      #------- 先找出對應之 faj_file 資料
      SELECT * INTO l_faj.* FROM faj_file WHERE faj02=l_fbh.fbh03
                                            AND faj022=l_fbh.fbh031
 
      IF STATUS THEN
         CALL cl_err('sel faj',STATUS,1)
         LET g_showmsg = l_fbh.fbh03,"/",l_fbh.fbh031                 #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'    #No.FUN-710028
         CONTINUE FOREACH       #No.FUN-710028
      END IF
      #-->免稅資料
      IF l_faj.faj40 = '3' AND p_cmd = 'S' THEN
         LET l_msg = l_faj.faj02,' ',l_faj.faj022 clipped
         CALL s_errmsg('','',l_msg,'afa-305',1)    #No.FUN-710028
         LET g_success = 'N'
         CONTINUE FOREACH     #No.FUN-710028
      END IF
      #-->抵押資料No:7645
      IF l_faj.faj41 MATCHES '[234]' AND p_cmd = 'S' THEN
         LET l_msg = l_faj.faj02,' ',l_faj.faj022 clipped
         CALL s_errmsg('','',l_msg,'afa-951',1)    #No.FUN-710028
         LET g_success = 'N'
         CONTINUE FOREACH     #No.FUN-710028
      END IF
      #-->投減三年內不可出售
## Modify:2597  ------faj42='5'國稅局核準
      IF (l_faj.faj42 = '3' OR l_faj.faj42 = '5') AND p_cmd = 'S' THEN
         LET l_edate = l_faj.faj26 + (365 * 3)
         LET l_msg = l_faj.faj02,' ',l_faj.faj022 clipped
         IF g_fbg.fbg02 < l_edate THEN
            CALL s_errmsg('','',l_msg,'afa-306',1)    #No.FUN-710028
            LET g_success = 'N'
            CONTINUE FOREACH     #No.FUN-710028
            LET g_success = 'N'
         END IF
         #FUN-AB0088---add---str---
         IF g_faa.faa31 = 'Y' THEN
            LET l_edate2 = l_faj.faj262 + (365 * 3)
            LET l_msg = l_faj.faj02,' ',l_faj.faj022 clipped
            IF g_fbg.fbg02 < l_edate2 THEN
               CALL s_errmsg('','',l_msg,'afa-306',1)  
               LET g_success = 'N'
               CONTINUE FOREACH    
               LET g_success = 'N'
            END IF
         END IF
         #FUN-AB0088---add---end---
      END IF

      #--------- 過帳(2)update faj_file
      IF l_fbh.fbh04=l_faj.faj17-l_faj.faj58 THEN
         LET m_chr='6'           ## 已全數銷帳
      ELSE
         LET m_chr=l_faj.faj43   ## 保持原資產狀態
      END IF
      #FUN-AB0088---add---str---
      IF g_faa.faa31 = 'Y' THEN
         IF l_fbh.fbh04=l_faj.faj17-l_faj.faj582 THEN
            LET m_chr2='6'          
         ELSE
            LET m_chr2=l_faj.faj432  
         END IF
      ELSE
         LET m_chr2 = m_chr
      END IF
      #FUN-AB0088---add---end---
 
     #-----------------------MOD-C80118---------------------(S)
      LET l_rate = 1
      LET l_diffamt = 0
      LET l_diffamt2 = 0
      LET l_fan07 = 0
      LET l_fbn07 = 0
      IF g_faa.faa15 = '4' THEN
         LET l_yy = YEAR(g_fbg.fbg02) USING '&&&&'
         LET l_mm = MONTH(g_fbg.fbg02)
         SELECT fan07 INTO l_fan07
           FROM fan_file
          WHERE fan01 = l_fbh.fbh03
            AND fan02 = l_fbh.fbh031
            AND fan03 = l_yy
            AND fan04 = l_mm
         IF cl_null(l_fan07) THEN LET l_fan07 = 0 END IF
         IF g_faa.faa31 = 'Y' THEN
            SELECT fbn07 INTO l_fbn07
              FROM fbn_file
             WHERE fbn01 = l_fbh.fbh03
               AND fbn02 = l_fbh.fbh031
               AND fbn03 = l_yy
               AND fbn04 = l_mm
            IF cl_null(l_fbn07) THEN LET l_fbn07 = 0 END IF
         END IF
         IF l_mm = 12 THEN
            LET l_mm = 1 LET l_yy = l_yy + 1
         ELSE
            LET l_mm = l_mm + 1
         END IF
         LET l_last = DAY(MDY(l_mm,1,l_yy)-1)
         LET l_rate = DAY(g_fbg.fbg02) / l_last
         LET l_diffamt = l_fan07 * l_rate
         LET l_diffamt2 = l_fbn07 * l_rate
         CALL cl_digcut(l_diffamt,g_azi04) RETURNING l_diffamt
         CALL cl_digcut(l_diffamt2,g_azi04_1) RETURNING l_diffamt2
         LET l_diffamt = l_fan07 - l_diffamt
         LET l_diffamt2 = l_fbn07 - l_diffamt2
      END IF
      LET l_faj.faj141 = l_faj.faj203
     #-----------------------MOD-C80118---------------------(E)
      #--->本期銷帳折舊=(本期累折-本期銷帳折舊)/(數量-銷帳數量)*處份量
       LET l_qty = l_faj.faj17 - l_faj.faj58
       IF l_qty > 0 THEN
          LET l_c = (l_faj.faj203 - l_faj.faj204) / l_qty * l_fbh.fbh04
          LET l_c = l_c - l_diffamt                                      #MOD-C80118 add
       ELSE  LET l_c = 0
       END IF
      IF l_c IS NULL THEN LET l_c=0 END IF #No.8851
      LET l_c = cl_digcut(l_c,g_azi04)     #TQC-B70211
      #FUN-AB0088---add---str---
      IF g_faa.faa31 = 'Y' THEN            #No.MOD-B80195 add
         LET l_faj.faj1412 = l_faj.faj2032          #MOD-C80118
         LET l_qty2 = l_faj.faj17 - l_faj.faj582
         IF l_qty2 > 0 THEN
            LET l_c2 = (l_faj.faj2032 - l_faj.faj2042) / l_qty2 * l_fbh.fbh04
            LET l_c2 = l_c2 - l_diffamt2                                       #MOD-C80118 add
         ELSE  
             LET l_c2 = 0
         END IF
      END IF                                #No.MOD-B80195 add
      IF l_c2 IS NULL THEN LET l_c2=0 END IF
      LET l_c2 = cl_digcut(l_c2,g_azi04)     #TQC-B70211
      #FUN-AB0088---add---end---

 
      #--------- 新增歷史資料
      IF cl_null(l_fbh.fbh031) THEN
         LET  l_fbh.fbh031 = ' '
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
      CALL cl_digcut(l_faj.faj1012,g_azi04_1) RETURNING l_faj.faj1012
      CALL cl_digcut(l_faj.faj142,g_azi04_1) RETURNING l_faj.faj142
      CALL cl_digcut(l_faj.faj1412,g_azi04_1) RETURNING l_faj.faj1412
      CALL cl_digcut(l_faj.faj312,g_azi04_1) RETURNING l_faj.faj312
      CALL cl_digcut(l_faj.faj322,g_azi04_1) RETURNING l_faj.faj322
      CALL cl_digcut(l_faj.faj3312,g_azi04_1) RETURNING l_faj.faj3312
      CALL cl_digcut(l_faj.faj332,g_azi04_1) RETURNING l_faj.faj332
      CALL cl_digcut(l_faj.faj352,g_azi04_1) RETURNING l_faj.faj352
      CALL cl_digcut(l_faj.faj592,g_azi04_1) RETURNING l_faj.faj592
      CALL cl_digcut(l_faj.faj602,g_azi04_1) RETURNING l_faj.faj602
      CALL cl_digcut(l_fbh.fbh062,g_azi04_1) RETURNING l_fbh.fbh062
      CALL cl_digcut(l_fbh.fbh072,g_azi04_1) RETURNING l_fbh.fbh072
      CALL cl_digcut(l_c2,g_azi04_1) RETURNING l_c2
     #CHI-C60010---end---
      #FUN-B60140   ---start   Add
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt FROM fap_file
        WHERE fap50 = l_fbh.fbh01
         AND fap501= l_fbh.fbh02
          AND fap03 = g_fbg00
       IF l_cnt = 0 THEN   #無fap_file資料
      #FUN-B60140   ---end     Add
      
      INSERT INTO fap_file (fap01,fap02,fap021,fap03,
                            fap04,fap05,fap06,fap07,
                            fap08,fap09,fap10,fap101,
                            fap11,fap12,fap13,fap14,
                            fap15,fap16,fap17,fap18,
                            fap19,fap20,fap201,fap21,
                            fap22,fap23,fap24,fap25,
                            fap26,fap30,fap31,fap32,
                            fap33,fap34,fap341,fap35,
                            fap36,fap37,fap38,fap39,
                            fap40,fap41,fap42,fap55,      #MOD-C80118 add fap55
                            fap50,fap501,
                            fap54,fap56,fap57,fap67,fap73,
                            fap74,fap77,fap45,      #No:A099
                            fap121,fap131,fap141,
                            #FUN-AB0088---add---str---
                            fap052,fap062,fap072,fap082,
                            fap092,fap103,fap1012,fap112, 
                            fap152,fap162,fap212,fap222,
                            fap232,fap242,fap252,fap262,
                            fap542,fap552,                #MOD-C80118 add fap552
                            fap562,fap572,fap672,fap772,
                            #FUN-AB0088---add---end---
                            faplegal)     #No.FUN-680028 #FUN-980003 add
      VALUES (l_faj.faj01,l_fbh.fbh03,l_fbh.fbh031,g_fbg00,      #No.MOD-480036
              g_fbg.fbg02,l_faj.faj43,l_faj.faj28,l_faj.faj30,
              l_faj.faj31,l_faj.faj14,l_faj.faj141,l_faj.faj33+l_faj.faj331,  #MOD-970231
              l_faj.faj32,l_faj.faj53,l_faj.faj54,l_faj.faj55,
              l_faj.faj23,l_faj.faj24,l_faj.faj20,l_faj.faj19,
              l_faj.faj21,l_faj.faj17,l_faj.faj171,l_faj.faj58,
              l_faj.faj59,l_faj.faj60,l_faj.faj34,l_faj.faj35,   
              l_faj.faj36,l_faj.faj61,l_faj.faj65,l_faj.faj66,
              l_faj.faj62,l_faj.faj63,l_faj.faj68,l_faj.faj67,
              l_faj.faj69,l_faj.faj70,l_faj.faj71,l_faj.faj72,
              l_faj.faj73,l_faj.faj100,l_faj.faj201,l_faj.faj32-l_diffamt, #MOD-C80118 add for fap55
              l_fbh.fbh01,l_fbh.fbh02,
              l_c,l_fbh.fbh06,l_fbh.fbh07,l_fbh.fbh04,l_fbh.fbh09,  
              l_fbh.fbh10,m_chr,                     #No.8851
              l_fbh.fbh12,l_faj.faj531,l_faj.faj541,l_faj.faj551,
              #FUN-AB0088---add---str---
              l_faj.faj432,l_faj.faj282,l_faj.faj302,l_faj.faj312,
              l_faj.faj142,l_faj.faj1412,l_faj.faj332+l_faj.faj3312,l_faj.faj322,
              l_faj.faj232,l_faj.faj242,l_faj.faj582,l_faj.faj592,
              l_faj.faj602,l_faj.faj342,l_faj.faj352,l_faj.faj362,
              l_c2,l_faj.faj322-l_diffamt2,                 #MOD-C80118 add fap552
              l_fbh.fbh062,l_fbh.fbh072,l_fbh.fbh04,m_chr2,
              #FUN-AB0088---add---end---
              g_legal)        #No:A099     #No.FUN-680028 #FUN-980003 add
    #FUN-B60140   ---start   Add
       ELSE
          UPDATE fap_file SET fap05 = l_faj.faj43,
                              fap06 = l_faj.faj28,
                              fap07 = l_faj.faj30,
                              fap08 = l_faj.faj31,
                              fap09 = l_faj.faj14,
                              fap10 = l_faj.faj141,
                              fap101= l_faj.faj33+l_faj.faj331,
                              fap11 = l_faj.faj32,
                              fap15 = l_faj.faj23,
                              fap16 = l_faj.faj24,
                              fap21 = l_faj.faj58,
                              fap22 = l_faj.faj59,
                              fap23 = l_faj.faj60,
                              fap24 = l_faj.faj34,
                              fap25 = l_faj.faj35,
                              fap26 = l_faj.faj36,
                              fap77 = m_chr,
                              fap54 = l_c,
                              fap55 = l_faj.faj32-l_diffamt,   #MOD-C80118 add
                              fap57 = l_fbh.fbh07,
                              fap67 = l_fbh.fbh04,
                              fap56 = l_fbh.fbh06,
                              fap052 = l_faj.faj432,
                              fap062 = l_faj.faj282,
                              fap072 = l_faj.faj302,
                              fap082 = l_faj.faj312,
                              fap092 = l_faj.faj142,
                              fap103 = l_faj.faj1412,
                              fap1012= l_faj.faj332+l_faj.faj3312,
                              fap112 = l_faj.faj322,
                              fap152 = l_faj.faj232,
                              fap162 = l_faj.faj242,
                              fap212 = l_faj.faj582,
                              fap222 = l_faj.faj592,
                              fap232 = l_faj.faj602,
                              fap242 = l_faj.faj342,
                              fap252 = l_faj.faj352,
                              fap262 = l_faj.faj362,
                              fap772 = m_chr2,
                              fap542 = l_c2,
                              fap552 = l_faj.faj322-l_diffamt2, #MOD-C80118 add
                              fap572 = l_fbh.fbh072,
                              fap672 = l_fbh.fbh04,
                              fap562 = l_fbh.fbh062
           WHERE fap50 = l_fbh.fbh01
             AND fap501= l_fbh.fbh02
             AND fap03 = g_fbg00
       END IF
       #FUN-B60140   ---end     Add 
      IF STATUS  THEN
         LET g_showmsg = l_fbh.fbh03,"/",l_fbh.fbh031,"/",g_fbg00,"/",g_fbg.fbg02       #No.FUN-710028
         CALL s_errmsg('fap02,fap021,fap03,fap04',g_showmsg,'ins fap',STATUS,1)         #No.FUN-710028
         LET g_success ='N'  #Modify:2598
         CONTINUE FOREACH    #No.FUN-710028
      END IF
 
      LET l_fbh06 = l_fbh.fbh06
      LET l_fbh07 = l_fbh.fbh07
      LET l_fbh08 = l_fbh.fbh08
      #FUN-AB0088---add---str---
      LET l_fbh062 = l_fbh.fbh062
      LET l_fbh072 = l_fbh.fbh072
      LET l_fbh082 = l_fbh.fbh082
      #FUN-AB0088---add---end---

     #------------------------MOD-C80118-------------------(S)
     #當月處置應提列折舊且提列方式為4:本月(入帳日至月底比率)
      IF g_faa.faa15 = '4' THEN
         LET l_yy = YEAR(g_fbg.fbg02) USING '&&&&'
         LET l_mm = MONTH(g_fbg.fbg02)
         UPDATE faj_file
            SET faj32 = faj32 - l_diffamt,
                faj203 = faj203 - l_diffamt
          WHERE faj02  = l_fbh.fbh03
            AND faj022 = l_fbh.fbh031
         UPDATE fan_file
            SET fan07 = fan07 - l_diffamt,
                fan08 = fan08 - l_diffamt,
                fan15 = fan15 - l_diffamt
          WHERE fan01 = l_fbh.fbh03
            AND fan02 = l_fbh.fbh031
            AND fan03 = l_yy
            AND fan04 = l_mm
         IF g_faa.faa31 = 'Y' THEN
            UPDATE fbn_file
               SET fbn07 = fbn07 - l_diffamt2,
                   fbn08 = fbn08 - l_diffamt2,
                   fbn15 = fbn15 - l_diffamt2
             WHERE fbn01 = l_fbh.fbh03
               AND fbn02 = l_fbh.fbh031
               AND fbn03 = l_yy
               AND fbn04 = l_mm
         END IF
      END IF
      LET l_fbh08  = l_faj.faj33 + l_faj.faj331 - l_fbh08 + l_diffamt
      LET l_fbh082 = l_faj.faj332 + l_faj.faj3312 - l_fbh082 + l_diffamt
     #------------------------MOD-C80118-------------------(E)
      #-----------------------------No.#No.MOD-B80195------------------------------start
      SELECT faj582,faj312,faj17 INTO l_faj582,l_faj312,l_faj17 FROM faj_file
       WHERE faj02=l_fbh.fbh03 AND faj022=l_fbh.fbh031
      IF cl_null(l_faj582) THEN
         LET l_faj582 = 0
      END IF
      LET l_faj582 = l_faj582 +l_fbh.fbh04
      LET l_faj312 = (l_faj312/(l_faj17-l_faj582)) *
                     (l_faj17-(l_faj582+l_fbh.fbh04))
      #-----------------------------No.#No.MOD-B80195------------------------------end

      UPDATE faj_file set faj43 =m_chr,
                          faj58 =faj58+l_fbh.fbh04,  #銷帳數量
                          faj59 =faj59+l_fbh06,  #銷帳成本
                          faj60 =faj60+l_fbh07,  #銷帳累折
                          faj102=faj102+l_fbh.fbh12, #銷帳減值   #No:A099
                          faj204=faj204+l_c,         #本期銷帳累折
                         #faj33 =faj33-l_fbh08,                   #未折減額 #MOD-C80118 mark
                          faj33 = l_fbh08,                        #未折減額 #MOD-C80118 add
                          faj100=g_fbg.fbg02,
                          faj31=(faj31/(faj17-faj58)) *   #預留殘值  #NO:7250
                                 (faj17-(faj58+l_fbh.fbh04))
                        ##FUN-B90096----------mark-------str                                 
                        #  #FUN-AB0088---add---str---
                        #  faj432 =m_chr2,
                        # #faj582 =faj582+l_fbh.fbh04,             #No.MOD-B80195 mark
                        #  faj582 =l_faj582,                       #No.MOD-B80195 add
                        #  faj592 =faj592+l_fbh062,
                        #  faj602 =faj602+l_fbh072,
                        #  faj1022=faj1022+l_fbh.fbh122,
                        #  faj2042=faj2042+l_c2,
                        #  faj332 =faj332-l_fbh082,
                        #  faj312 =l_faj312                        #No.MOD-B80195 add
                        # #faj312 =(faj312/(faj17-faj582)) *       #No.MOD-B80195 mark
                        # #        (faj17-(faj582+l_fbh.fbh04))    #No.MOD-B80195 mark
                        #  #FUN-AB0088---add---end---
                        ##FUN-B90096----------mark-------end
         WHERE faj02=l_fbh.fbh03 AND faj022=l_fbh.fbh031
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fbh.fbh03,"/",l_fbh.fbh031                 #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)   #No.FUN-710028
         LET g_success ='N'   #Modify:2598
         CONTINUE FOREACH     #No.FUN-710028
      END IF
     #FUN-B90096----------add-------str
      IF g_faa.faa31 = 'Y' THEN
        #CHI-C60010---str---
         CALL cl_digcut(l_fbh.fbh122,g_azi04_1) RETURNING l_fbh.fbh122
         CALL cl_digcut(l_fbh072,g_azi04_1) RETURNING l_fbh072
         CALL cl_digcut(l_fbh062,g_azi04_1) RETURNING l_fbh062
         CALL cl_digcut(l_fbh082,g_azi04_1) RETURNING l_fbh082
         CALL cl_digcut(l_c2,g_azi04_1) RETURNING l_c2
         CALL cl_digcut(l_faj312,g_azi04_1) RETURNING l_faj312
        #CHI-C60010---end---
         UPDATE faj_file SET faj432 =m_chr2,
                             faj582 =l_faj582,
                             faj592 =faj592+l_fbh062,
                             faj602 =faj602+l_fbh072,
                             faj1022=faj1022+l_fbh.fbh122,
                             faj2042=faj2042+l_c2,
                             faj322 = faj322 - l_diffamt2,             #MOD-C80118 add
                             faj2032= faj2032 - l_diffamt2,            #MOD-C80118 add
                            #faj332 = faj332 - l_fbh082,               #MOD-C80118 mark
                             faj332 = l_fbh082,                        #未折減額 #MOD-C80118 add
                             faj312 =l_faj312
            WHERE faj02=l_fbh.fbh03 AND faj022=l_fbh.fbh031
         IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
            LET g_showmsg = l_fbh.fbh03,"/",l_fbh.fbh031
            CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)
            LET g_success ='N'
            CONTINUE FOREACH
         END IF         
      END IF 
     #FUN-B90096----------add-------end      
 
     #------------------------------MOD-C70313----------------------------mark
     #IF cl_null(l_fbh.fbh031) THEN      #No.MOD-840014 add
     #   UPDATE faj_file SET faj43 =m_chr 
     #                      #faj432=m_chr2   #FUN-AB0088 #FUN-B90096 mark
     #    WHERE faj02=l_fbh.fbh03 AND faj022<>l_fbh.fbh031
     #   IF STATUS OR SQLCA.sqlcode THEN
     #      LET g_showmsg = l_fbh.fbh03   #No.FUN-710028
     #      CALL s_errmsg('faj02',g_showmsg,'upd faj',STATUS,0)   #No.FUN-710028
     #   END IF
     #  #FUN-B90096----------add-------str
     #   IF g_faa.faa31 = 'Y' THEN
     #      UPDATE faj_file SET faj432=m_chr2
     #         WHERE faj02=l_fbh.fbh03 AND faj022<>l_fbh.fbh031
     #      IF STATUS OR SQLCA.sqlcode THEN
     #         LET g_showmsg = l_fbh.fbh03
     #         CALL s_errmsg('faj02',g_showmsg,'upd faj',STATUS,0)
     #      END IF            
     #   END IF 
     #  #FUN-B90096----------add-------end          
     #END IF             #No.MOD-840014 add
     #------------------------------MOD-C70313----------------------------mark
  END FOREACH
  IF g_totsuccess="N" THEN                                                                                                        
     LET g_success="N"                                                                                                            
  END IF                                                                                                                          
 
 
   #--------- 過帳(5)update fbgpost
   IF g_success ='Y' THEN
      UPDATE fbg_file SET fbgpost = 'Y' WHERE fbg01 = g_fbg.fbg01
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
        CALL s_errmsg('fbg01',g_fbg.fbg01,'upd fbgpost',STATUS,1)   #No.FUN-710028
        LET g_fbg.fbgpost='N'
        LET g_success ='N'
      END IF
   END IF
   CLOSE t108_cl
   CALL s_showmsg()  #No.FUN-710028
   IF g_success ='N' THEN
      ROLLBACK WORK
      RETURN
   ELSE
      LET g_fbg.fbgpost='Y'
      COMMIT WORK
      CALL cl_flow_notify(g_fbg.fbg01,'S')
      DISPLAY BY NAME g_fbg.fbgpost #
   END IF
   IF g_fbg.fbgconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fbg.fbg10 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fbg.fbgconf,g_chr2,g_fbg.fbgpost,"",g_chr,"")
   LET g_t1 = s_get_doc_no(g_fbg.fbg01)  #No.FUN-670060                                                                           
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1  #No.FUN-670060
   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN
      LET g_wc_gl = 'npp01 = "',g_fbg.fbg01,'" AND npp011 = 1'
      LET g_str="afap302 '",g_wc_gl CLIPPED,"' '",g_fbg.fbguser,"' '",g_fbg.fbguser,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fah.fahgslp,"' '",g_fbg.fbg02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"  #No.FUN-680028   #MOD-860284#FUN-860040
      CALL cl_cmdrun_wait(g_str)
#FUN-C30313---mark---START
#     #FUN-B60140   ---start   Add
#     IF g_faa.faa31 = "Y" THEN
#        LET g_str="afap202 '",g_wc_gl CLIPPED,"' '",g_fbg.fbguser,"' '",g_fbg.fbguser,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"'
#                  '",g_fah.fahgslp,"' '",g_fbg.fbg02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'" 
#        CALL cl_cmdrun_wait(g_str)
#      END IF
#     #FUN-B60140   ---end     Add
#     SELECT fbg08,fbg09,fbg082,fbg092     #FUN-B60140   Add fbg082,fbg092
#       INTO g_fbg.fbg08,g_fbg.fbg09,g_fbg.fbg082,g_fbg.fbg092    #FUN-B60140   Add fbg082,fbg092 
#FUN-C30313---mark---END
      SELECT fbg08,fbg09             #FUN-C30313 add
        INTO g_fbg.fbg08,g_fbg.fbg09 #FUN-C30313 add
        FROM fbg_file
       WHERE fbg01 = g_fbg.fbg01
      DISPLAY BY NAME g_fbg.fbg08
      DISPLAY BY NAME g_fbg.fbg09
      #DISPLAY BY NAME g_fbg.fbg082   #FUN-B60140   Add #FUN-C30313 mark
      #DISPLAY BY NAME g_fbg.fbg092   #FUN-B60140   Add #FUN-C30313 mark
   END IF
#FUN-C30313---add---START-----
   IF g_faa.faa31 = "Y" THEN
      IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN
         LET g_str="afap202 '",g_wc_gl CLIPPED,"' '",g_fbg.fbguser,"' '",g_fbg.fbguser,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"'
                   '",g_fah.fahgslp,"' '",g_fbg.fbg02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"
         CALL cl_cmdrun_wait(g_str)
         SELECT fbg082,fbg092
           INTO g_fbg.fbg082,g_fbg.fbg092
           FROM fbg_file
          WHERE fbg01 = g_fbg.fbg01
         DISPLAY BY NAME g_fbg.fbg082
         DISPLAY BY NAME g_fbg.fbg092
      END IF
   END IF
#FUN-C30313---add---END-------
END FUNCTION
 
FUNCTION t108_6()
   DEFINE l_msg   LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(40)
   DEFINE l_fbh   RECORD LIKE fbh_file.*
   DEFINE l_faj   RECORD LIKE faj_file.*
   DEFINE l_mm,l_yy      LIKE type_file.num5         #No.FUN-680070 SMALLINT
   DEFINE l_mm1          LIKE type_file.num5         #No.FUN-680070 SMALLINT
   DEFINE l_bdate,l_edate LIKE type_file.dat          #No.FUN-680070 DATE
   DEFINE l_flag          LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
   DEFINE l_fap20 LIKE fap_file.fap20
   DEFINE l_fap21 LIKE fap_file.fap21
   DEFINE l_qty   LIKE fap_file.fap20
#   DEFINE l_qty2  LIKE fap_file.fap20             #FUN-B60140   Add #No:FUN-BA0112 mark
#   DEFINE m_chr2  LIKE type_file.chr1             #FUN-B60140   Add #No:FUN-BA0112 mark
#   DEFINE l_c2    LIKE fbh_file.fbh062            #FUN-B60140   Add #No:FUN-BA0112 mark
   DEFINE l_c             LIKE fbh_file.fbh06,
          l_fbh09         LIKE fbh_file.fbh09,
          l_fbh10         LIKE fbh_file.fbh10,
          l_fbh11         LIKE fbh_file.fbh11
   DEFINE m_chr           LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
   DEFINE l_chr           LIKE type_file.chr8         #No.FUN-680070 VARCHAR(08)
   DEFINE l_cnt    LIKE type_file.num5                #FUN-B60140   Add
   DEFINE l_last            LIKE type_file.num5          #MOD-C80118 add
   DEFINE l_rate            LIKE azx_file.azx04          #MOD-C80118 add
   DEFINE l_faj68           LIKE faj_file.faj68          #MOD-C80118 add
   DEFINE l_fao07           LIKE fao_file.fao07          #MOD-C80118 add
   DEFINE l_diffamt         LIKE fao_file.fao07          #MOD-C80118 add
   DEFINE l_faj66           LIKE faj_file.faj66          #MOD-C80118 add
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fbg.fbg01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_fbg.* FROM fbg_file WHERE fbg01 = g_fbg.fbg01
  # IF g_fbg.fbgconf != 'Y' OR g_fbg.fbgpost != 'Y'  #FUN-B60140   Mark
   IF g_fbg.fbgconf != 'Y'   #FUN-B60140   Add   
   THEN CALL cl_err(g_fbg.fbg01,'afa-320',0)
        RETURN
   END IF
 # IF g_fbg.fbgconf = 'Y' AND g_fbg.fbgpost = 'Y' AND g_fbg.fbgpost2 = 'Y' THEN   #FUN-B60140   Mark
   IF g_fbg.fbgconf = 'Y' AND g_fbg.fbgpost2 = 'Y' THEN                           #FUN-B60140   Add
      CALL cl_err(g_fbg.fbg01,'afa-100',0)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa13 INTO g_faa.faa13 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add- 
   #-->立帳日期小於關帳日期
   IF g_fbg.fbg02 < g_faa.faa13 THEN
      CALL cl_err(g_fbg.fbg01,'afa-308',0) 
      RETURN
   END IF
  #-MOD-A80137-end- 
      #CALL s_azm(g_faa.faa11,g_faa.faa12) RETURNING l_flag,l_bdate,l_edate #CHI-A60036 mark
      #CHI-A60036 add --start--
      CALL s_get_bookno(g_faa.faa11)   
          RETURNING g_flag,g_bookno1,g_bookno2
#     IF g_aza.aza63 = 'Y' THEN   #FUN-AB0088 mark
      IF g_faa.faa31 = 'Y' THEN   #FUN-AB0088 
         LET g_bookno2 = g_faa.faa02c   #MOD-BC0010 add
         CALL s_azmm(g_faa.faa11,g_faa.faa12,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
      ELSE
         CALL s_azm(g_faa.faa11,g_faa.faa12) RETURNING l_flag,l_bdate,l_edate
      END IF
      #CHI-A60036 add --end--
      IF g_fbg.fbg02 < l_bdate OR g_fbg.fbg02 > l_edate THEN
         CALL cl_err(g_fbg.fbg02,'afa-308',0)
         RETURN
      END IF
   IF NOT cl_sure(18,20) THEN RETURN END IF
   BEGIN WORK
 
    OPEN t108_cl USING g_fbg.fbg01
    IF STATUS THEN
       CALL cl_err("OPEN t108_cl:", STATUS, 1)
       CLOSE t108_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t108_cl INTO g_fbg.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbg.fbg01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t108_cl ROLLBACK WORK RETURN
    END IF
 
   DECLARE t108_cur21 CURSOR FOR
      SELECT * FROM fbh_file WHERE fbh01=g_fbg.fbg01
   LET g_success = 'Y'      #No.FUN-8A0086
   CALL s_showmsg_init()    #No.FUN-710028
   FOREACH t108_cur21 INTO l_fbh.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF SQLCA.sqlcode != 0 THEN
         CALL s_errmsg('fbh01',g_fbg.fbg01,'foreach:',SQLCA.sqlcode,0)  #No.FUN-710028
         EXIT FOREACH
      END IF
      SELECT * INTO l_faj.* FROM faj_file WHERE faj02=l_fbh.fbh03
                                            AND faj022=l_fbh.fbh031
      IF STATUS THEN
         CALL cl_err('sel faj',STATUS,1)
         LET g_showmsg = l_fbh.fbh03,"/",l_fbh.fbh031                 #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,0)   #No.FUN-710028
         CONTINUE FOREACH  #No.FUN-710028
      END IF
      #-----------------------MOD-C80118---------------------(S)
       LET l_rate = 1
       LET l_diffamt = 0
       IF g_faa.faa15 = '4' THEN
          LET l_yy = YEAR(g_fbg.fbg02) USING '&&&&'
          LET l_mm = MONTH(g_fbg.fbg02)
          LET l_fao07 = 0
          SELECT fao07 INTO l_fao07
            FROM fao_file
           WHERE fao01 = l_fbh.fbh03
             AND fao02 = l_fbh.fbh031
             AND fao03 = l_yy
             AND fao04 = l_mm
          IF cl_null(l_fao07) THEN LET l_fao07 = 0 END IF
          IF l_mm = 12 THEN
             LET l_mm = 1 LET l_yy = l_yy + 1
          ELSE
             LET l_mm = l_mm + 1
          END IF
          LET l_last = DAY(MDY(l_mm,1,l_yy)-1)
          LET l_rate = DAY(g_fbg.fbg02) / l_last
          LET l_diffamt = l_fao07 * l_rate
          CALL cl_digcut(l_diffamt,g_azi04) RETURNING l_diffamt
          LET l_diffamt = l_fao07 - l_diffamt
       END IF
       LET l_faj.faj63 =  l_faj.faj205
      #-----------------------MOD-C80118---------------------(E)
      #--->本期銷帳折舊=(本期累折-本期銷帳折舊)/(數量-銷帳數量)*處份量
       SELECT fap20,fap21 INTO l_fap20,l_fap21 FROM fap_file
                          WHERE fap50 = l_fbh.fbh01
                            AND fap501= l_fbh.fbh02
                             AND fap03 = g_fbg00      #No.8851 #No.MOD-480036
       IF STATUS  THEN  #No.7926
         #FUN-B60140   ---start   Mark
         LET g_showmsg = l_fbh.fbh01,"/",l_fbh.fbh02,"/",g_fbg00            #No.FUN-710028 #No:FUN-BA0112 remark
         CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'sel faj',STATUS,1)   #No.FUN-710028 #No:FUN-BA0112 remark
         LET g_success = 'N'    #No.FUN-710028 #No:FUN-BA0112 remark
         CONTINUE FOREACH       #No.FUN-710028 #No:FUN-BA0112 remark
         #FUN-B60140   ---end     Mark
      #    LET l_fap20 = l_faj.faj17    #FUN-B60140   Add #No:FUN-BA0112 mark
      #    LET l_fap21 = l_faj.faj58    #FUN-B60140   Add #No:FUN-BA0112 mark
       END IF
       LET l_qty = l_fap20 - l_fap21
       IF l_qty > 0 THEN                                       #NO:4980
          LET l_c = (l_faj.faj205 - l_faj.faj206) / l_qty * l_fbh.fbh04
          LET l_c = l_c - l_diffamt                                       #MOD-C80118 add
       ELSE  LET l_c = 0
       END IF
       IF l_c IS NULL THEN LET l_c=0 END IF #No.8851
      #--------- 過帳(2)update faj_file
     #----------------------MOD-C20003------------------start
      IF g_fbg.fbgpost = 'Y' THEN
         LET m_chr = l_faj.faj43
      ELSE
     #----------------------MOD-C20003--------------------end
         IF l_fbh.fbh04=l_faj.faj17-l_faj.faj58 THEN
            LET m_chr='6'           ## 已全數銷帳
         ELSE
            LET m_chr=l_faj.faj201   ## 保持原資產狀態
         END IF
      END IF                                           #MOD-C20003 add
      #--->(1.1)更新稅簽異動檔
      LET l_fbh09 = l_fbh.fbh09
      LET l_fbh10 = l_fbh.fbh10
      LET l_fbh11 = l_fbh.fbh11

      #FUN-B60140   ---start   Add
##-----No:FUN-BA0112 Mark-----
#      IF g_faa.faa31 = 'Y' THEN
#         IF l_fbh.fbh04=l_faj.faj17-l_faj.faj582 THEN
#            LET m_chr2='6'
#         ELSE
#            LET m_chr2=l_faj.faj432
#         END IF
#      ELSE
#         LET m_chr2 = m_chr
#      END IF
#
#      IF g_faa.faa31 = 'Y' THEN
#         LET l_qty2 = l_faj.faj17 - l_faj.faj582
#         IF l_qty2 > 0 THEN
#            LET l_c2 = (l_faj.faj2032 - l_faj.faj2042) / l_qty2 * l_fbh.fbh04
#         ELSE
#            LET l_c2 = 0
#         END IF
#      END IF
#      IF l_c2 IS NULL THEN LET l_c2=0 END IF
#      LET l_c2 = cl_digcut(l_c2,g_azi04)
##-----No:FUN-BA0112 Mark END-----
     #CHI-C60010---str---
      CALL cl_digcut(l_faj.faj1012,g_azi04_1) RETURNING l_faj.faj1012
      CALL cl_digcut(l_faj.faj142,g_azi04_1) RETURNING l_faj.faj142
      CALL cl_digcut(l_faj.faj1412,g_azi04_1) RETURNING l_faj.faj1412
      CALL cl_digcut(l_faj.faj312,g_azi04_1) RETURNING l_faj.faj312
      CALL cl_digcut(l_faj.faj322,g_azi04_1) RETURNING l_faj.faj322
      CALL cl_digcut(l_faj.faj3312,g_azi04_1) RETURNING l_faj.faj3312
      CALL cl_digcut(l_faj.faj332,g_azi04_1) RETURNING l_faj.faj332
      CALL cl_digcut(l_faj.faj352,g_azi04_1) RETURNING l_faj.faj352
      CALL cl_digcut(l_faj.faj592,g_azi04_1) RETURNING l_faj.faj592
      CALL cl_digcut(l_faj.faj602,g_azi04_1) RETURNING l_faj.faj602
      CALL cl_digcut(l_fbh.fbh062,g_azi04_1) RETURNING l_fbh.fbh062
      CALL cl_digcut(l_fbh.fbh072,g_azi04_1) RETURNING l_fbh.fbh072
     #CHI-C60010---end---

       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt FROM fap_file
        WHERE fap50 = l_fbh.fbh01
          AND fap501= l_fbh.fbh02
          AND fap03 = g_fbg00
       IF l_cnt = 0 THEN   #無fap_file資料
          INSERT INTO fap_file (fap01,fap02,fap021,fap03,
                                fap04,fap05,fap06,fap07,
                                fap08,fap09,fap10,fap101,
                                fap11,fap12,fap13,fap14,
                                fap15,fap16,fap17,fap18,
                                fap19,fap20,fap201,fap21,
                               fap22,fap23,fap24,fap25,
                                fap26,fap30,fap31,fap32,
                                fap33,fap34,fap341,fap35,
                                fap36,fap37,fap38,fap39,
                                fap40,fap41,fap42,fap72,               #MOD-C80118 add fap72
                                fap50,fap501,
                                fap54,fap56,fap57,fap67,fap73,
                                fap74,fap77,fap45,
                                fap121,fap131,fap141,
                                fap052,fap062,fap072,fap082,
                                fap092,fap103,fap1012,fap112,
                                fap152,fap162,fap212,fap222,
                                fap232,fap242,fap252,fap262,
                                fap542,
                                fap562,fap572,fap672,fap772,
                              #fap71,fap79,faplegal) #No:FUN-BA0112 mark
                               fap71,fap73,fap79,faplegal)            #MOD-C80118 de fap74
          VALUES (l_faj.faj01,l_fbh.fbh03,l_fbh.fbh031,g_fbg00,
                  g_fbg.fbg02,l_faj.faj43,l_faj.faj28,l_faj.faj30,
                  l_faj.faj31,l_faj.faj14,l_faj.faj141,l_faj.faj33+l_faj.faj331,
                  l_faj.faj32,l_faj.faj53,l_faj.faj54,l_faj.faj55,
                  l_faj.faj23,l_faj.faj24,l_faj.faj20,l_faj.faj19,
                  l_faj.faj21,l_faj.faj17,l_faj.faj171,l_faj.faj58,
                  l_faj.faj59,l_faj.faj60,l_faj.faj34,l_faj.faj35,
                  l_faj.faj36,l_faj.faj61,l_faj.faj65,l_faj.faj66,
                 #l_faj.faj62,l_faj.faj63,l_faj.faj68,l_faj.faj67,                 #MOD-C80118 mark
                  l_faj.faj62,l_faj.faj63,l_faj.faj68+l_faj.faj681,l_faj.faj67,    #MOD-C80118 add
                  l_faj.faj69,l_faj.faj70,l_faj.faj71,l_faj.faj72,
                  l_faj.faj73,l_faj.faj100,l_faj.faj201,l_faj.faj67-l_diffamt,   #MOD-C80118 add fap72
                  l_fbh.fbh01,l_fbh.fbh02,
                  l_c,l_fbh.fbh06,l_fbh.fbh07,l_fbh.fbh04,l_fbh.fbh09,
                  l_fbh.fbh10,m_chr,l_fbh.fbh12,
                  l_faj.faj531,l_faj.faj541,l_faj.faj551,
                  l_faj.faj432,l_faj.faj282,l_faj.faj302,l_faj.faj312,
                  l_faj.faj142,l_faj.faj1412,l_faj.faj332+l_faj.faj3312,l_faj.faj322,
                  l_faj.faj232,l_faj.faj242,l_faj.faj582,l_faj.faj592,
                  l_faj.faj602,l_faj.faj342,l_faj.faj352,l_faj.faj362,
                  l_c2,
                  l_fbh.fbh062,l_fbh.fbh072,l_fbh.fbh04,m_chr2,
                #l_c,l_fbh.fbh13,g_legal) #No:FUN-BA0112 mark
                 l_c,l_fbh09,l_fbh.fbh13,g_legal)                    #MOD-C80118 de fbh10
       ELSE
      #FUN-B60140   ---end     Add
      UPDATE fap_file 
        #SET fap341 = l_faj.faj68,                  #異動前未折減額  #MOD-C80118 mark
         SET fap341 = l_faj.faj68 + l_faj.faj681,   #未折減額        #MOD-C80118 add
             fap35 = l_faj.faj67,                   #累計折舊(前) #MOD-C80118 add
             fap72 = l_faj.faj67 - l_diffamt,       #累計折舊(後) #MOD-C80118 add
             fap34 = l_faj.faj63,                   #調整成本(前) #MOD-C80118 add
             fap42 =l_faj.faj201,
             fap36 =l_faj.faj69,       #稅簽銷帳成本
             fap37 =l_faj.faj70,       #    銷帳累折
             fap71 =l_c,               #處份本期折舊
             fap73 =l_fbh09,       #稅簽銷帳成本
             fap74 =l_fbh10,       #    銷帳累折
             fap79 =l_fbh.fbh13    #    銷帳減值 #No:A099
       WHERE fap50 = l_fbh.fbh01
         AND fap501= l_fbh.fbh02
         AND fap03 = g_fbg00   #No.8851 #No.MOD-480036
       END IF     #FUN-B60140   Add
      IF STATUS  THEN
         LET g_showmsg = l_fbh.fbh01,"/",l_fbh.fbh02,"/",g_fbg00            #No.FUN-710028
         CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'upd fap',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'    #No.FUN-710028
         CONTINUE FOREACH       #No.FUN-710028
      END IF
     #------------------------MOD-C80118-------------------(S)
     #當月處置應提列折舊且提列方式為4:本月(入帳日至月底比率)
      IF g_faa.faa15 = '4' THEN
         LET l_yy = YEAR(g_fbg.fbg02) USING '&&&&'
         LET l_mm = MONTH(g_fbg.fbg02)
         UPDATE faj_file SET faj67 = faj67 - l_diffamt,
                             faj205 = faj205 - l_diffamt
          WHERE faj02 = l_fbh.fbh03
            AND faj022 = l_fbh.fbh031
         UPDATE fao_file SET fao07 = fao07 - l_diffamt,
                             fao08 = fao08 - l_diffamt,
                             fao15 = fao15 - l_diffamt
          WHERE fao01 = l_fbh.fbh03
            AND fao02 = l_fbh.fbh031
            AND fao03 = l_yy
            AND fao04 = l_mm
      END IF
      LET l_fbh11 = l_faj.faj68 - l_fbh11 + l_diffamt      #稅簽未折減額
      LET l_faj66 =0
      IF (l_faj.faj17-l_faj.faj58)=0 THEN
         LET l_faj66 =0
      ELSE
         LET l_faj66 = (l_faj.faj66/(l_faj.faj17-l_faj.faj58))*(l_faj.faj17-(l_faj.faj58+l_fbh.fbh04))
      END IF
     #------------------------MOD-C80118-------------------(E)
      #--->(1.2)更新資產主檔
      UPDATE faj_file SET faj69 =faj69 +l_fbh09,  #稅簽銷帳成本
                          faj70 =faj70 +l_fbh10,  #    銷帳累折
                          faj104=faj104+l_fbh.fbh13,  #    銷帳減值  #No:A099
                          faj206=faj206+l_c,          #本期銷帳累折
                          faj201=m_chr,
                         #faj68 = faj68 -l_fbh11          #未折減額 #MOD-C80118 mark
                          faj68 = l_fbh11,                #MOD-C80118 add
                          faj66 = l_faj66                 #MOD-C80118 add
         WHERE faj02=l_fbh.fbh03 AND faj022=l_fbh.fbh031
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fbh.fbh03,"/",l_fbh.fbh031                 #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'    #No.FUN-710028
         CONTINUE FOREACH       #No.FUN-710028
      END IF
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   #--->(1.2)更新資產主檔過帳碼
   UPDATE fbg_file SET fbgpost2 = 'Y' WHERE fbg01 = g_fbg.fbg01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('fbg01',g_fbg.fbg01,'upd fbgpost2',STATUS,1)   #No.FUN-710028
      LET g_fbg.fbgpost2='N'
      CLOSE t108_cl
      LET g_success = 'N'  #No.FUN-710028
   ELSE
      LET g_fbg.fbgpost2='Y'
      CLOSE t108_cl
      LET g_success = 'Y'  #No.FUN-710028
      DISPLAY BY NAME g_fbg.fbgpost2 #
   END IF
   CALL s_showmsg()
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF  
END FUNCTION
 
FUNCTION t108_w()
   DEFINE l_fbh    RECORD LIKE fbh_file.*
   DEFINE l_faj    RECORD LIKE faj_file.*
   DEFINE l_fap    RECORD LIKE fap_file.*
   DEFINE m_fap05  LIKE fap_file.fap05
   DEFINE m_fap10  LIKE fap_file.fap10      #MOD-C80118 add
   DEFINE m_fap103 LIKE fap_file.fap103     #MOD-C80118 add
   DEFINE m_fap41  LIKE fap_file.fap41
   DEFINE m_fap54  LIKE fap_file.fap54
   DEFINE m_fap542 LIKE fap_file.fap542   #FUN-AB0088
    DEFINE m_fap08  LIKE fap_file.fap08           #No.MOD-480038
   DEFINE l_flag   LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
          l_fbh06  LIKE fbh_file.fbh06,
          l_fbh07  LIKE fbh_file.fbh07,
          l_fbh08  LIKE fbh_file.fbh08
   DEFINE l_yy,l_mm        LIKE type_file.num10        #No.FUN-680070 INTEGER
   DEFINE l_bdate,l_edate  LIKE type_file.dat          #No.FUN-680070 DATE
   DEFINE l_msg            LIKE type_file.chr8         #No.FUN-680070 VARCHAR(08)
   DEFINE l_count          LIKE type_file.num5         #No.FUN-680070 SMALLINT
   DEFINE l_aba19    LIKE aba_file.aba19     #No.FUN-680028
   DEFINE l_sql      LIKE type_file.chr1000             #No.FUN-680028       #No.FUN-680070 VARCHAR(1000)
   DEFINE l_dbs      STRING                  #No.FUN-680028
   DEFINE l_cnt      LIKE type_file.num5   #TQC-780089
#FUN-AB0088---add---str---
   DEFINE l_cnt1     LIKE type_file.num5  
   DEFINE m_fap052   LIKE fap_file.fap052 
   DEFINE m_fap082   LIKE fap_file.fap082 
   DEFINE l_fbh062   LIKE fbh_file.fbh062 
   DEFINE l_fbh072   LIKE fbh_file.fbh072 
   DEFINE l_fbh082   LIKE fbh_file.fbh082 
#FUN-AB0088---add---end---
   DEFINE l_faj582   LIKE faj_file.faj582        #No.MOD-B80195 add
   DEFINE l_diffamt  LIKE fan_file.fan07      #MOD-C80118 add
   DEFINE l_diffamt2 LIKE fan_file.fan07      #MOD-C80118 add
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fbg.fbg01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_fbg.* FROM fbg_file WHERE fbg01 = g_fbg.fbg01
   IF g_fbg.fbgpost != 'Y' THEN
      CALL cl_err(g_fbg.fbg01,'afa-108',0)
      RETURN
   END IF
   #-->已拋轉票不可還原
   IF not cl_null(g_fbg.fbg08) AND g_fah.fahglcr = 'N' THEN     #No.FUN-680028
      CALL cl_err('','afa-311',0)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add- 
   #-->立帳日期小於關帳日期
   IF g_fbg.fbg02 < g_faa.faa09 THEN
      CALL cl_err(g_fbg.fbg01,'aap-176',1) RETURN
   END IF
   #FUN-B60140   ---start   Add
    IF g_faa.faa31 = "Y" THEN
       #-->已拋轉票不可還原
       IF not cl_null(g_fbg.fbg082) AND g_fah.fahglcr = 'N' THEN     #No.FUN-680028
          CALL cl_err('','afa-311',0)
          RETURN
       END IF
      #-->立帳日期小於關帳日期
       IF g_fbg.fbg02 < g_faa.faa092 THEN
          CALL cl_err(g_fbg.fbg01,'aap-176',1) RETURN
       END IF
    END IF
   #FUN-B60140   ---end     Add
   #-MOD-A80137-end- 
   #--->當月處份提折舊
      #CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate #CHI-A60036 mark
      #CHI-A60036 add --start--
      CALL s_get_bookno(g_faa.faa07)   
          RETURNING g_flag,g_bookno1,g_bookno2
#     IF g_aza.aza63 = 'Y' THEN
     #FUN-B60140   ---start   Mark
     # IF g_faa.faa31 = 'Y' THEN   #FUN-AB0088 
     #    CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
     # ELSE
         CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
     # END IF
     #FUN-B60140   ---end     Mark 
     #CHI-A60036 add --end--
      IF g_fbg.fbg02 < l_bdate OR g_fbg.fbg02 > l_edate THEN
         CALL cl_err(g_fbg.fbg02,'afa-308',0)
         RETURN
      END IF
   #FUN-B60140   ---start   Add
       IF g_faa.faa31 = "Y" THEN
          CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno2) RETURNING l_flag,l_bdate,l_edate
          IF g_fbg.fbg02 < l_bdate OR g_fbg.fbg02 > l_edate THEN
             CALL cl_err(g_fbg.fbg02,'afa-308',0)
             RETURN
          END IF
       END IF
      #FUN-B60140   ---end     Add
   IF g_faa.faa23 = 'N' THEN
      DECLARE t108_cur4 CURSOR FOR
         SELECT * FROM fbh_file WHERE fbh01=g_fbg.fbg01
      FOREACH t108_cur4 INTO l_fbh.*
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM fan_file
          WHERE fan01 = l_fbh.fbh03
            AND fan02 = l_fbh.fbh031
            AND ((fan03 = YEAR(g_fbg.fbg02) AND fan04 >= MONTH(g_fbg.fbg02))
             OR fan03 > YEAR(g_fbg.fbg02))
            AND fan041 = '1'   #MOD-C50044 add
        #FUN-B60140   ---start   Mark
        ##FUN-AB0088---add---str---
        #LET l_cnt1 = 0 
        #IF g_faa.faa31 = 'Y' THEN
        #    SELECT COUNT(*) INTO l_cnt1 FROM fbn_file
        #     WHERE fbn01 = l_fbh.fbh03
        #       AND fbn02 = l_fbh.fbh031
        #       AND ((fbn03 = YEAR(g_fbg.fbg02) AND fbn04 >= MONTH(g_fbg.fbg02))
        #        OR fbn03 > YEAR(g_fbg.fbg02))
        #END IF
        #LET l_cnt = l_cnt + l_cnt1
        ##FUN-AB0088---add---end---
        #FUN-B60140   ---end     Mark
         IF l_cnt > 0 THEN
            CALL cl_err(l_fbh.fbh03,'afa-348',0)
            RETURN
         END IF
      END FOREACH
   END IF
 
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_fbg.fbg01) RETURNING g_t1     #No.FUN-550071
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
   IF NOT cl_null(g_fbg.fbg08) THEN
      IF NOT (g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y') THEN
         CALL cl_err(g_fbg.fbg01,'axr-370',0) RETURN
      END IF
   END IF
   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
      LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
     #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",  #FUN-A50102
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
                  "  WHERE aba00 = '",g_faa.faa02b,"'",
                  "    AND aba01 = '",g_fbg.fbg08,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
      PREPARE aba_pre1 FROM l_sql
      DECLARE aba_cs1 CURSOR FOR aba_pre1
      OPEN aba_cs1
      FETCH aba_cs1 INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_fbg.fbg08,'axr-071',1)
         RETURN
      END IF
 
   END IF
   
  #FUN-B60140   ---start   Add
      IF g_faa.faa31 = "Y" THEN
         IF g_faa.faa232 = 'N' THEN
            DECLARE t108_cur42 CURSOR FOR
               SELECT * FROM fbh_file WHERE fbh01=g_fbg.fbg01
            FOREACH t108_cur42 INTO l_fbh.*
               SELECT COUNT(*) INTO l_cnt1 FROM fbn_file
                WHERE fbn01 = l_fbh.fbh03
                  AND fbn02 = l_fbh.fbh031
                  AND ((fbn03 = YEAR(g_fbg.fbg02) AND fbn04 >= MONTH(g_fbg.fbg02))
                   OR fbn03 > YEAR(g_fbg.fbg02))
                  AND fbn041 = '1'   #MOD-C50044 add
               IF l_cnt1> 0 THEN
                  CALL cl_err(l_fbh.fbh03,'afa-348',0)
                  RETURN
               END IF
            END FOREACH
         END IF
         #No.FUN-680028 --begin
         #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
         CALL s_get_doc_no(g_fbg.fbg01) RETURNING g_t1     #No.FUN-550071
         SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
         IF NOT cl_null(g_fbg.fbg082) THEN
            #IF NOT (g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y') THEN #FUN-C30313 mark
            IF NOT (g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y') THEN #FUN-C30313 add
               CALL cl_err(g_fbg.fbg01,'axr-370',0) RETURN
            END IF
         END IF
         #IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN #FUN-C30313 mark
         IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' THEN #FUN-C30313 add
            LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
            LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
                        "  WHERE aba00 = '",g_faa.faa02c,"'",
                        "    AND aba01 = '",g_fbg.fbg082,"'"
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-920032
            PREPARE aba_pre12 FROM l_sql
            DECLARE aba_cs12 CURSOR FOR aba_pre12
            OPEN aba_cs12
            FETCH aba_cs12 INTO l_aba19
            IF l_aba19 = 'Y' THEN
               CALL cl_err(g_fbg.fbg082,'axr-071',1)
              RETURN
           END IF
  
       END IF
    END IF
     
       #FUN-B60140   ---end     Add
   IF NOT cl_sure(18,20) THEN RETURN END IF
 #------------------------------------CHI-C90051----------------------------mark
   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
      LET g_str="afap303 '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fbg.fbg08,"' '",g_fbg00,"' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT fbg08,fbg09
        INTO g_fbg.fbg08,g_fbg.fbg09
        FROM fbg_file
       WHERE fbg01 = g_fbg.fbg01
      IF NOT cl_null(g_fbg.fbg08) THEN
         CALL cl_err('','aap-929',0)
         RETURN
      END IF
      DISPLAY BY NAME g_fbg.fbg08
      DISPLAY BY NAME g_fbg.fbg09
      IF g_faa.faa31 = "Y" THEN
         LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_fbg.fbg082,"' '",g_fbg00,"' 'Y'"
         CALL cl_cmdrun_wait(g_str)
         SELECT fbg082,fbg092
           INTO g_fbg.fbg082,g_fbg.fbg092
           FROM fbg_file
          WHERE fbg01 = g_fbg.fbg01
         DISPLAY BY NAME g_fbg.fbg082
         DISPLAY BY NAME g_fbg.fbg092
         IF NOT cl_null(g_fbg.fbg082) THEN
            CALL cl_err('','aap-929',0)
            RETURN
         END IF
      END IF
   END IF
 #------------------------------------CHI-C90051----------------------------mark
   BEGIN WORK
 
    OPEN t108_cl USING g_fbg.fbg01
    IF STATUS THEN
       CALL cl_err("OPEN t108_cl:", STATUS, 1)
       CLOSE t108_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t108_cl INTO g_fbg.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbg.fbg01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t108_cl ROLLBACK WORK RETURN
    END IF
   LET g_success = 'Y'
   #--------- 還原過帳(1)update faj_file
   DECLARE t108_cur3 CURSOR FOR
      SELECT * FROM fbh_file WHERE fbh01=g_fbg.fbg01
   CALL s_showmsg_init()    #No.FUN-710028
   FOREACH t108_cur3 INTO l_fbh.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF SQLCA.sqlcode != 0 THEN
         CALL s_errmsg('fbh01',g_fbg.fbg01,'foreach:',SQLCA.sqlcode,0) #No.FUN-710028
         EXIT FOREACH
      END IF
      #----- 找出 fap_file 之 fap05 以便 update faj_file.faj43
      #SELECT fap05,fap41,fap54,fap08 INTO m_fap05,m_fap41,m_fap54,m_fap08 FROM fap_file   #No.MOD-480038 add fap08  #FUN-AB0088 mark
      #SELECT fap05,fap052,fap41,fap54,fap542,fap08,fap082                                 #FUN-AB0088 add #MOD-C80118 mark
       SELECT fap05,fap052,fap41,fap54,fap542,                                             #MOD-C80118 add
              fap08,fap082,fap10,fap103                                                    #MOD-C80118 add fap10,fap103
        #INTO m_fap05,m_fap052,m_fap41,m_fap54,m_fap542,m_fap08,m_fap082 FROM fap_file     #FUN-AB0088 add #MOD-C80118 mark
         INTO m_fap05,m_fap052,m_fap41,m_fap54,m_fap542,                                   #MOD-C80118 add
              m_fap08,m_fap082,m_fap10,m_fap103                                            #MOD-C80118 add fap10,fap103
         FROM fap_file                                                                     #MOD-C80118 add
        WHERE fap02=l_fbh.fbh03 
          AND fap021=l_fbh.fbh031
          AND fap03=g_fbg00  ## 異動代號  #No.MOD-480036
          AND fap04=g_fbg.fbg02
      IF STATUS  THEN  #No.7926
         LET g_showmsg = l_fbh.fbh03,"/",l_fbh.fbh031,"/",g_fbg00,"/",g_fbg.fbg02       #No.FUN-710028
         CALL s_errmsg('fap02,fap021,fap03,fap04',g_showmsg,'sel fap',STATUS,1)         #No.FUN-710028
         LET g_success = 'N'    #No.FUN-710028
         CONTINUE FOREACH       #No.FUN-710028
      END IF
      #--->本期銷帳折舊=(本期累折-本期銷帳折舊)/(數量-銷帳數量)*處份量
      LET l_fbh06 = l_fbh.fbh06
      LET l_fbh07 = l_fbh.fbh07
      LET l_fbh08 = l_fbh.fbh08
      #FUN-AB0088---add---str---
      LET l_fbh062 = l_fbh.fbh062
      LET l_fbh072 = l_fbh.fbh072
      LET l_fbh082 = l_fbh.fbh082
      #FUN-AB0088---add---end---

      #-----------------------------No.#No.MOD-B80195------------------------------start
      SELECT faj582 INTO l_faj582 FROM faj_file
       WHERE faj02=l_fbh.fbh03 AND faj022=l_fbh.fbh031
      IF cl_null(l_faj582) THEN
         LET l_faj582 = 0
      END IF
      LET l_faj582 = l_faj582-l_fbh.fbh04
      #-----------------------------No.#No.MOD-B80195------------------------------end

     #-----------------------------MOD-C80118------------------------(S)
      SELECT * INTO l_faj.*
        FROM faj_file
       WHERE faj02=l_fbh.fbh03
         AND faj022=l_fbh.fbh031
      LET l_diffamt = 0
      LET l_diffamt2 = 0
     #當月處置應提列折舊且提列方式為4:本月(入帳日至月底比率)
      IF g_faa.faa15 = '4' THEN
         LET l_diffamt = m_fap10 - m_fap54
         LET l_diffamt2 = m_fap103 - m_fap542
         LET l_yy = YEAR(g_fbg.fbg02) USING '&&&&'
         LET l_mm = MONTH(g_fbg.fbg02)
         UPDATE fan_file SET fan07 = fan07 + l_diffamt,
                             fan08 = fan08 + l_diffamt,
                             fan15 = fan15 + l_diffamt
          WHERE fan01 = l_fbh.fbh03
            AND fan02 = l_fbh.fbh031
            AND fan03 = l_yy
            AND fan04 = l_mm
         IF g_faa.faa31 = 'Y' THEN
           UPDATE fbn_file SET fbn07 = fbn07 + l_diffamt2,
                               fbn08 = fbn08 + l_diffamt2,
                               fbn15 = fbn15 + l_diffamt2
            WHERE fbn01 = l_fbh.fbh03
              AND fbn02 = l_fbh.fbh031
              AND fbn03 = l_yy
              AND fbn04 = l_mm
         END IF
      END IF
      LET l_fbh08 = l_faj.faj33 + l_faj.faj331 + l_fbh08 - l_diffamt
      LET l_fbh082 = l_faj.faj332 + l_faj.faj3312 + l_fbh082 - l_diffamt2
     #-----------------------------MOD-C80118------------------------(E)
      UPDATE faj_file SET faj43=m_fap05,
                          faj58=faj58-l_fbh.fbh04,   #銷帳數量
                          faj59=faj59-l_fbh06,   #銷帳成本
                          faj60=faj60-l_fbh07,   #銷帳累折
                          faj102=faj102-l_fbh.fbh12,   #銷帳減值  #No:A099
                          faj204=faj204-m_fap54,     #本期銷帳累折
                          faj32 = faj32 + l_diffamt,            #累計折舊 #MOD-C80118 add
                          faj203= faj203 + l_diffamt,           #本期累折 #MOD-C80118 add
                         #faj33 = faj33 + l_fbh08,              #未折減額 #MOD-C80118 mark
                          faj33 = l_fbh08,                      #MOD-C80118 add
                          faj100=m_fap41,
                          faj31 =m_fap08        #No.8851
                    ##FUN-B90096----------mark-------str                          
                    #      #FUN-AB0088---add---str---
                    #      faj432=m_fap052,              
                    #     #faj582=faj582-l_fbh.fbh04,             #No.MOD-B80195 mark
                    #      faj582=l_faj582,                       #No.MOD-B80195 add
                    #      faj592=faj592-l_fbh062,      
                    #      faj602=faj602-l_fbh072,      
                    #      faj1022=faj1022-l_fbh.fbh122,
                    #      faj2042=faj2042-m_fap542,     
                    #      faj332=faj332+l_fbh082,      
                    #      faj312=m_fap082
                    #      #FUN-AB0088---add---end---
                    ##FUN-B90096----------mark-------end                          
         WHERE faj02=l_fbh.fbh03 AND faj022=l_fbh.fbh031
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fbh.fbh03,"/",l_fbh.fbh031                 #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'
         CONTINUE FOREACH   #No.FUN-710028
      END IF
    #FUN-B90096----------add-------str
      IF g_faa.faa31 = 'Y' THEN
        #CHI-C60010---str---
         CALL cl_digcut(l_fbh072,g_azi04_1) RETURNING l_fbh072
         CALL cl_digcut(l_fbh062,g_azi04_1) RETURNING l_fbh062
         CALL cl_digcut(l_fbh082,g_azi04_1) RETURNING l_fbh082
         CALL cl_digcut(l_fbh.fbh122,g_azi04_1) RETURNING l_fbh.fbh122
         CALL cl_digcut(m_fap542,g_azi04_1) RETURNING m_fap542
         CALL cl_digcut(m_fap082,g_azi04_1) RETURNING m_fap082
        #CHI-C60010---end---
         UPDATE faj_file SET faj432=m_fap052,              
                             faj582=l_faj582,
                             faj592=faj592-l_fbh062,      
                             faj602=faj602-l_fbh072,      
                             faj1022=faj1022-l_fbh.fbh122,
                             faj2042=faj2042-m_fap542,     
                             faj322 = faj322 + l_diffamt2,       #累計折舊 #MOD-C80118 add
                             faj2032 = faj2032 + l_diffamt2,     #本期累折 #MOD-C80118 add
                            #faj332 = faj332 + l_fbh082,         #MOD-C80118 mark
                             faj332 = l_fbh082,                  #MOD-C80118 add
                             faj312=m_fap082
            WHERE faj02=l_fbh.fbh03 AND faj022=l_fbh.fbh031
         IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
            LET g_showmsg = l_fbh.fbh03,"/",l_fbh.fbh031
            CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF
      END IF 
    #FUN-B90096----------add-------end      
 
     #------------------------------MOD-C70313----------------------------mark
     #IF cl_null(l_fbh.fbh031) THEN      #No.MOD-840014 add
     #   UPDATE faj_file SET faj43=m_fap05
     #                      #faj432=m_fap052    #FUN-AB0088 #FUN-B90096 mark
     #    WHERE faj02=l_fbh.fbh03 AND faj022<>l_fbh.fbh031
     #   IF STATUS OR SQLCA.sqlcode THEN
     #      CALL s_errmsg('faj02',l_fbh.fbh03,'upd faj:',SQLCA.sqlcode,0)   #No.FUN-710028
     #   END IF
     #  #FUN-B90096----------add-------str
     #   IF g_faa.faa31 = 'Y' THEN
     #      UPDATE faj_file SET faj432=m_fap052
     #         WHERE faj02=l_fbh.fbh03 AND faj022<>l_fbh.fbh031
     #      IF STATUS OR SQLCA.sqlcode THEN
     #         CALL s_errmsg('faj02',l_fbh.fbh03,'upd faj:',SQLCA.sqlcode,0)
     #      END IF            
     #   END IF 
     #  #FUN-B90096----------add-------end          
     #END IF                         #No.MOD-840014 add
     #------------------------------MOD-C70313----------------------------mark
 
      #--------- 還原過帳(2)delete fap_file
      #稅簽皆未過帳時，才可刪fap_file
      IF g_fbg.fbgpost2<>'Y' THEN     #FUN-B60140   Add
      DELETE FROM fap_file WHERE fap02=l_fbh.fbh03 AND fap021=l_fbh.fbh031
                              AND fap03=g_fbg00 AND fap04=g_fbg.fbg02  #No.MOD-480036
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fbh.fbh03,"/",l_fbh.fbh031,"/",g_fbg00,"/",g_fbg.fbg02       #No.FUN-710028    
         CALL s_errmsg('fap02,fap021,fap03,fap04',g_showmsg,'del fap',STATUS,1)         #No.FUN-710028
         LET g_success = 'N'
         CONTINUE FOREACH   #No.FUN-710028
      END IF
     END IF    #FUN-B60140   Add
   END FOREACH
    IF g_totsuccess="N" THEN                                                                                                        
       LET g_success="N"                                                                                                            
    END IF                                                                                                                          
 
   #--------- 還原過帳(3)update fbg_file
   UPDATE fbg_file SET fbgpost = 'N' WHERE fbg01 = g_fbg.fbg01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('fbg01',g_fbg.fbg01,'upd fbgpost',STATUS,1)   #No.FUN-710028
      LET g_success = 'N'
   END IF
   CLOSE t108_cl
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'Y' THEN
      LET g_fbg.fbgpost = 'N'
      COMMIT WORK
   ELSE
      LET g_fbg.fbgpost='Y'
      ROLLBACK WORK
   END IF
   DISPLAY BY NAME g_fbg.fbgpost #
 #------------------------------------CHI-C90051----------------------------mark
 # IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN
 #    LET g_str="afap303 '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fbg.fbg08,"' '",g_fbg00,"' 'Y'"
 #    CALL cl_cmdrun_wait(g_str)
 #   #FUN-C30313---mark---START
 #   ##FUN-B60140   ---start   Add
 #   # IF g_faa.faa31 = "Y" THEN
 #   #    LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_fbg.fbg082,"' '",g_fbg00,"' 'Y'"
 #   #    CALL cl_cmdrun_wait(g_str)
 #   # END IF
 #   ##FUN-B60140   ---end     Add
 #   #SELECT fbg08,fbg09,fbg082,fbg092    #FUN-B60140   Add fbg082 fbg092
 #   #  INTO g_fbg.fbg08,g_fbg.fbg09,g_fbg.fbg082,g_fbg.fbg092     #FUN-B60140   Add fbg082 fbg092 
 #   #FUN-C30313---mark---END
 #    SELECT fbg08,fbg09             #FUN-C30313 add
 #      INTO g_fbg.fbg08,g_fbg.fbg09 #FUN-C30313 add
 #      FROM fbg_file
 #     WHERE fbg01 = g_fbg.fbg01
 #    DISPLAY BY NAME g_fbg.fbg08
 #    DISPLAY BY NAME g_fbg.fbg09
 #    #DISPLAY BY NAME g_fbg.fbg082    #FUN-B60140   Add #FUN-C30313 mark
 #    #DISPLAY BY NAME g_fbg.fbg092    #FUN-B60140   Add #FUN-C30313 mark
 # END IF
 ##FUN-C30313---add---START-----
 # IF g_faa.faa31 = "Y" THEN
 #    IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN
 #        LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_fbg.fbg082,"' '",g_fbg00,"' 'Y'"
 #        CALL cl_cmdrun_wait(g_str)
 #       SELECT fbg082,fbg092
 #         INTO g_fbg.fbg082,g_fbg.fbg092
 #         FROM fbg_file
 #        WHERE fbg01 = g_fbg.fbg01
 #       DISPLAY BY NAME g_fbg.fbg082
 #       DISPLAY BY NAME g_fbg.fbg092
 #    END IF
 # END IF
 ##FUN-C30313---add---END-------
 #------------------------------------CHI-C90051----------------------------mark
    IF g_fbg.fbgconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_fbg.fbgconf,"",g_fbg.fbgpost,"",g_chr,"")
END FUNCTION
 
#-----------------稅簽還原------------------------------
FUNCTION t108_7()
   DEFINE l_fbh    RECORD LIKE fbh_file.*,
          l_bdate,l_edate  LIKE type_file.dat,          #No.FUN-680070 DATE
          l_c              LIKE fbh_file.fbh06,
          l_flag           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
          l_faj17          LIKE faj_file.faj17,
          l_fbh09          LIKE fbh_file.fbh09,
          l_fbh10          LIKE fbh_file.fbh10,
          l_fbh11          LIKE fbh_file.fbh11,
          m_fap34          LIKE fap_file.fap34,         #MOD-C80118 add
          m_fap32          LIKE fap_file.fap32,         #MOD-C80118 add
          m_fap71          LIKE fap_file.fap71,
          m_fap42          LIKE fap_file.fap42,
          m_fap341         LIKE fap_file.fap341,    #No.MOD-480038
          l_msg            LIKE type_file.chr8,         #No.FUN-680070 VARCHAR(08)
          l_mm,l_yy        LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          l_mm1            LIKE type_file.num5         #No.FUN-680070 SMALLINT
   DEFINE l_chr            LIKE type_file.chr8         #No.FUN-680070 VARCHAR(08)
   DEFINE l_cnt            LIKE type_file.num5   #TQC-780089
   DEFINE l_faj    RECORD  LIKE faj_file.*            #MOD-C80118 add
   DEFINE l_diffamt        LIKE fan_file.fan07        #MOD-C80118 add
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fbg.fbg01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fbg.fbgconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    SELECT * INTO g_fbg.* FROM fbg_file WHERE fbg01 = g_fbg.fbg01
   IF g_fbg.fbgpost2 != 'Y' THEN
      CALL cl_err(g_fbg.fbg01,'afa-108',0)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa13 INTO g_faa.faa13 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add- 
   #-->立帳日期小於關帳日期
   IF g_fbg.fbg02 < g_faa.faa13 THEN
      CALL cl_err(g_fbg.fbg01,'afa-308',0) 
      RETURN
   END IF
  #-MOD-A80137-end- 
   #--->當月處份提折舊
      #CALL s_azm(g_faa.faa11,g_faa.faa12) RETURNING l_flag,l_bdate,l_edate #CHI-A60036 mark
      #CHI-A60036 add --start--
      CALL s_get_bookno(g_faa.faa11)   
          RETURNING g_flag,g_bookno1,g_bookno2
#     IF g_aza.aza63 = 'Y' THEN
      #FUN-B60140  --start  Mark
      #IF g_faa.faa31 = 'Y' THEN   #FUN-AB0088 
      #   CALL s_azmm(g_faa.faa11,g_faa.faa12,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
      #ELSE
      #   CALL s_azm(g_faa.faa11,g_faa.faa12) RETURNING l_flag,l_bdate,l_edate
      #END IF
      #CHI-A60036 add --end--
      #FUN-B60140  --end    Mark
      CALL s_azm(g_faa.faa11,g_faa.faa12) RETURNING l_flag,l_bdate,l_edate    #FUN-B60140   Add
      IF g_fbg.fbg02 < l_bdate OR g_fbg.fbg02 > l_edate THEN
         CALL cl_err(g_fbg.fbg02,'afa-308',0)
         RETURN
      END IF
 
   IF g_faa.faa23 = 'N' THEN
      DECLARE t108_cur5 CURSOR FOR
         SELECT * FROM fbh_file WHERE fbh01=g_fbg.fbg01
      FOREACH t108_cur5 INTO l_fbh.*
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM fao_file
          WHERE fao01 = l_fbh.fbh03
            AND fao02 = l_fbh.fbh031
            AND ((fao03 = YEAR(g_fbg.fbg02) AND fao04 >= MONTH(g_fbg.fbg02))
             OR fao03 > YEAR(g_fbg.fbg02))
            AND fao041 = '1'   #MOD-C50044 add
         IF l_cnt > 0 THEN
            CALL cl_err(l_fbh.fbh03,'afa-348',0)
            RETURN
         END IF
      END FOREACH
   END IF
   IF NOT cl_sure(18,20) THEN RETURN END IF
   BEGIN WORK
 
    OPEN t108_cl USING g_fbg.fbg01
    IF STATUS THEN
       CALL cl_err("OPEN t108_cl:", STATUS, 1)
       CLOSE t108_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t108_cl INTO g_fbg.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbg.fbg01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t108_cl ROLLBACK WORK RETURN
    END IF
 
   DECLARE t108_cur31 CURSOR FOR
      SELECT * FROM fbh_file WHERE fbh01=g_fbg.fbg01
   LET g_success = 'Y'      #No.FUN-8A0086
   CALL s_showmsg_init()    #No.FUN-710028
   FOREACH t108_cur31 INTO l_fbh.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF SQLCA.sqlcode != 0 THEN
         CALL s_errmsg('fbh01',g_fbg.fbg01,'foreach:',SQLCA.sqlcode,0) #No.FUN-710028
         EXIT FOREACH
      END IF
      #----- 找出 fap_file 之 fap71(本期銷帳累折)
       SELECT fap71,fap42,fap341,fap34,fap32                            #MOD-C80118 add fap34 fap32
         INTO m_fap71,m_fap42,m_fap341,m_fap34,m_fap32                  #No.MOD-480038 add fap341
         FROM fap_file    #No.MOD-480038 add fap341
        WHERE fap02=l_fbh.fbh03 AND fap021=l_fbh.fbh031
          AND fap03=g_fbg00       ## 異動代號  #No.MOD-480036
          AND fap04=g_fbg.fbg02
      IF STATUS  THEN  #No.7926
         LET g_showmsg = l_fbh.fbh03,"/",l_fbh.fbh031,"/",g_fbg00,"/",g_fbg.fbg02     #No.FUN-710028
         CALL s_errmsg('fap02,fap021,fap03,fap04',g_showmsg,'sel fap',STATUS,1)       #No.FUN-710028
         LET g_success = 'N'    #No.FUN-710028
         CONTINUE FOREACH       #No.FUN-710028
      END IF
 
      #No.8851 更新稅簽異動檔
    #--------------------MOD-C80118--------------------------mark
    # #FUN-B60140   ---start   Add
    #  #財簽皆未過帳時，才可刪fap_file
    #  IF g_fbg.fbgpost <>'Y' THEN
    #     DELETE FROM fap_file WHERE fap02=l_fbh.fbh03 AND fap021=l_fbh.fbh031
    #                             AND fap03=g_fbg00 AND fap04=g_fbg.fbg02
    #  ELSE
    # #FUN-B60140   ---end     Add 
    # UPDATE fap_file SET fap71 = 0,                     #處份本期折舊               #No.TQC-970004
    #                     fap79 = 0,                     #銷帳減值    #No:A099       #No.TQC-970004
    #                     fap73 = fap73 - l_fbh.fbh09,   #MOD-C20198 add
    #                     fap74 = fap74 - l_fbh.fbh10    #MOD-C20198 add
    #                 WHERE fap50 = l_fbh.fbh01
    #                   AND fap501= l_fbh.fbh02
    #                   AND fap03 = g_fbg00   #No.8851 MOD-480036
    # END IF   #FUN-B60140  Add
    # IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
    #    LET g_showmsg = l_fbh.fbh01,"/",l_fbh.fbh02,"/",g_fbg00            #No.FUN-710028
    #    CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'upd fap',STATUS,1)   #No.FUN-710028
    #    LET g_success = 'N'    #No.FUN-710028
    #    CONTINUE FOREACH       #No.FUN-710028
    # END IF
    #--------------------MOD-C80118--------------------------mark
 
      #--->(1.1)更新資產主檔
      LET l_fbh09 = l_fbh.fbh09
      LET l_fbh10 = l_fbh.fbh10
      LET l_fbh11 = l_fbh.fbh11
     #-----------------------------MOD-C80118------------------------(S)
      SELECT * INTO l_faj.*
        FROM faj_file
       WHERE faj02 = l_fbh.fbh03
         AND faj022 = l_fbh.fbh031
      LET l_diffamt = 0
     #當月處置應提列折舊且提列方式為4:本月(入帳日至月底比率)
      IF g_faa.faa15 = '4' THEN
         LET l_diffamt = m_fap34 - m_fap71
         LET l_yy = YEAR(g_fbg.fbg02) USING '&&&&'
         LET l_mm = MONTH(g_fbg.fbg02)
         UPDATE fao_file SET fao07 = fao07 + l_diffamt,
                             fao08 = fao08 + l_diffamt,
                             fao15 = fao15 + l_diffamt
          WHERE fao01 = l_fbh.fbh03
            AND fao02 = l_fbh.fbh031
            AND fao03 = l_yy
            AND fao04 = l_mm
      END IF
      LET l_fbh11 = l_faj.faj68 + l_faj.faj681 + l_fbh11 - l_diffamt
     #-----------------------------MOD-C80118------------------------(E)
      UPDATE faj_file 
         SET faj69 =faj69-l_fbh09,  #稅簽銷帳成本
             faj70 =faj70-l_fbh10,  #    銷帳累折
             faj104=faj104-l_fbh.fbh13, #    銷帳減值 #No:A099
             faj206=faj206-m_fap71,     #本期銷帳累折
             faj201=m_fap42,
             faj67 = faj67 + l_diffamt,    #累計折舊 #MOD-C80118 add
             faj205 = faj205 + l_diffamt,  #本期累折 #MOD-C80118 add
            #faj68 = m_fap341        #No.8851 #MOD-C80118 mark
             faj68 = l_fbh11         #MOD-C80118 add
         WHERE faj02=l_fbh.fbh03 AND faj022=l_fbh.fbh031
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fbh.fbh03,"/",l_fbh.fbh031                 #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'    #No.FUN-710028
         CONTINUE FOREACH       #No.FUN-710028
      END IF
    #--------------------MOD-C80118--------------------------(S)
     #財簽皆未過帳時，才可刪fap_file
      IF g_fbg.fbgpost <>'Y' THEN
         DELETE FROM fap_file
          WHERE fap02 = l_fbh.fbh03
            AND fap021 = l_fbh.fbh031
            AND fap03 = g_fbg00
            AND fap04 = g_fbg.fbg02
      ELSE
         UPDATE fap_file
            SET fap71 = 0,                     #處份本期折舊
                fap79 = 0,                     #銷帳減值
                fap73 = fap73 - l_fbh.fbh09,
                fap74 = fap74 - l_fbh.fbh10
          WHERE fap50 = l_fbh.fbh01
            AND fap501= l_fbh.fbh02
            AND fap03 = g_fbg00
      END IF
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fbh.fbh01,"/",l_fbh.fbh02,"/",g_fbg00
         CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'upd fap',STATUS,1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
    #--------------------MOD-C80118--------------------------(E)
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   #--------- 還原過帳(3)update fbg_file
   UPDATE fbg_file SET fbgpost2 = 'N' WHERE fbg01 = g_fbg.fbg01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('fbg01',g_fbg.fbg01,'upd fbgpost2',STATUS,1)   #No.FUN-710028
      LET g_fbg.fbgpost2='Y'
      CALL s_showmsg()   #No.FUN-710028
      ROLLBACK WORK
      CLOSE t108_cl   #No.+424 010716 by plum
      RETURN
   ELSE
      LET g_fbg.fbgpost2='N'
      CALL s_showmsg()   #No.FUN-710028
      COMMIT WORK
      DISPLAY BY NAME g_fbg.fbgpost2 #
   END IF
END FUNCTION
 
FUNCTION t108_out()
   DEFINE l_cmd        LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(200)
          l_wc,l_wc2    LIKE type_file.chr50,        #No.FUN-680070 VARCHAR(50)
          l_prtway    LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
      CALL cl_wait()
      LET l_wc='fbg01="',g_fbg.fbg01,'"'
      IF g_fbg.fbg00='1' THEN
        #SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'afar108' #FUN-C30085 mark
         #FUN-D10098--add--str--
         IF g_aza.aza26 = '2' THEN
            SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'gfag108'
         ELSE
         #FUN-D10098--add--end--
            SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'afag108' #FUN-C30085 add
         END IF   #FUN-D10098 add
      ELSE
        #SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'afar109' #FUN-C30085 mark
         #FUN-D10098--add--str--
         IF g_aza.aza26 = '2' THEN
            SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'gfag109'
         ELSE
         #FUN-D10098--add--end--
            SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'afag109' #FUN-C30085 add
         END IF   #FUN-D10098 add
      END IF
      IF SQLCA.sqlcode OR cl_null(l_wc2) THEN
        #LET l_wc2 = " '3' '3' "   #TQC-610055    #MOD-A40104 mark
         LET l_wc2 = " '3' '1' "   #MOD-A40104 add    #列印"財簽"
      END IF
      IF g_fbg.fbg00='1' THEN
        # LET l_cmd = "afar108",  #FUN-C30085 mark
         #FUN-D10098--add--str--
         IF g_aza.aza26 = '2' THEN
            LET l_cmd = "gfag108",  
                        " '",g_today CLIPPED,"' ''",
                        " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
                        " '",l_wc CLIPPED,"' ",l_wc2
         ELSE
         #FUN-D10098--add--end--
            LET l_cmd = "afag108",  #FUN-C30085 add
                        " '",g_today CLIPPED,"' ''",
                        " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
                        " '",l_wc CLIPPED,"' ",l_wc2
         END IF   #FUN-D10098 add 
      ELSE
        # LET l_cmd = "afar109", #FUN-C30085 mark
         #FUN-D10098--add--str--
         IF g_aza.aza26 = '2' THEN
            LET l_cmd = "gfag109", 
                        " '",g_today CLIPPED,"' ''",
                        " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
                        " '",l_wc CLIPPED,"' ",l_wc2
         ELSE
         #FUN-D10098--add--end--
            LET l_cmd = "afag109", #FUN-C30085 add
                        " '",g_today CLIPPED,"' ''",
                        " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
                        " '",l_wc CLIPPED,"' ",l_wc2 
         END IF   #FUN-D10098 add  
      END IF
      CALL cl_cmdrun(l_cmd)
   ERROR ' '
END FUNCTION
 
#FUNCTION t108_x()                     #FUN-D20035
FUNCTION t108_x(p_type)                  #FUN-D20035
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035
   DEFINE l_flag    LIKE type_file.chr1  #FUN-D20035
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_fbg.* FROM fbg_file WHERE fbg01=g_fbg.fbg01
   IF g_fbg.fbg10 MATCHES '[Ss1]' THEN
      CALL cl_err("","mfg3557",0) RETURN
   END IF
   IF g_fbg.fbg01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fbg.fbgconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
  
   #FUN-D20035---begin
   #作废操作
   IF p_type = 1 THEN
      IF g_fbg.fbgconf='X' THEN RETURN END IF
   ELSE
   #取消作废操作
      IF g_fbg.fbgconf<>'X' THEN RETURN END IF
   END IF
   #FUN-D20035---end

   BEGIN WORK
   LET g_success='Y'
 
   OPEN t108_cl USING g_fbg.fbg01
   IF STATUS THEN
      CALL cl_err("OPEN t108_cl:", STATUS, 1)
      CLOSE t108_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t108_cl INTO g_fbg.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fbg.fbg01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t108_cl ROLLBACK WORK RETURN
   END IF
   #-->void轉換01/08/01
  #IF cl_void(0,0,g_fbg.fbgconf)   THEN     #FUN-D20035
    IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF     #FUN-D20035
    IF cl_void(0,0,l_flag) THEN                                          #FUN-D20035
        LET g_chr=g_fbg.fbgconf
       #IF g_fbg.fbgconf ='N' THEN                           #FUN-D20035
        IF p_type = 1 THEN                                              #FUN-D20035
            LET g_fbg.fbgconf='X'
            LET g_fbg.fbg10='9'   #FUN-580109
        ELSE
            LET g_fbg.fbgconf='N'
            LET g_fbg.fbg10='0'   #FUN-580109
        END IF
 
    UPDATE fbg_file SET fbgconf =g_fbg.fbgconf,
                        fbg10   =g_fbg.fbg10,   #FUN-580109
                        fbgmodu =g_user,
                        fbgdate =TODAY
           WHERE fbg01 = g_fbg.fbg01
    IF STATUS THEN 
       CALL cl_err3("upd","fbg_file",g_fbg.fbg01,"",STATUS,"","upd fbgconf:",1)  #No.FUN-660136
       LET g_success='N' 
    END IF
    IF g_success='Y' THEN
       COMMIT WORK
       IF g_fbg.fbgconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
       IF g_fbg.fbg10 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
       CALL cl_set_field_pic(g_fbg.fbgconf,g_chr2,g_fbg.fbgpost,"",g_chr,"")
       CALL cl_flow_notify(g_fbg.fbg01,'V')
    ELSE
       ROLLBACK WORK
    END IF
    SELECT fbgconf,fbg10 INTO g_fbg.fbgconf,g_fbg.fbg10   #FUN-580109
      FROM fbg_file
     WHERE fbg01 = g_fbg.fbg01
    DISPLAY BY NAME g_fbg.fbgconf
    DISPLAY BY NAME g_fbg.fbg10   #FUN-580109
  END IF
END FUNCTION
 
FUNCTION t108_gen_glcr(p_fbg,p_fah)
  DEFINE p_fbg     RECORD LIKE fbg_file.*
  DEFINE p_fah     RECORD LIKE fah_file.*
 
    IF cl_null(p_fah.fahgslp) THEN
       CALL cl_err(p_fbg.fbg01,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    CALL s_showmsg_init()    #No.FUN-710028
 
    CALL s_get_bookno(g_fbg.fbg02)
         RETURNING g_flag,g_bookno1,g_bookno2    
    IF g_flag= '1' THEN  #
         #CALL cl_err(g_fbg.fbg02,'aoo-801',1)   #No.TQC-B60363
         CALL cl_err(g_fbg.fbg02,'aoo-081',1)    #No.TQC-B60363
    END IF 
 
    IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN #FUN-C30313 add
       CALL t108_gl(g_argv1,g_fbg.fbg01,g_fbg.fbg02,'0',g_bookno1)        #No.FUN-740020-
    END IF #FUN-C30313 add
#   IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN    #FUN-AB0088 mark
    IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN    #FUN-AB0088 add
       IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' THEN #FUN-C30313 add
          LET g_bookno2 = g_faa.faa02c   #MOD-BC0010 add
          CALL t108_gl(g_argv1,g_fbg.fbg01,g_fbg.fbg02,'1',g_bookno2)    #No.FUN-740020-
       END IF #FUN-C30313 add
    END IF
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t108_carry_voucher()
  DEFINE l_fahgslp    LIKE fah_file.fahgslp
  DEFINE li_result    LIKE type_file.num5          #No.FUN-680070 SMALLINT
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF

   #FUN-B90004--Begin--
    IF NOT cl_null(g_fbg.fbg08)  THEN
       CALL cl_err(g_fbg.fbg08,'aap-618',1)
       RETURN
    END IF
    IF g_faa.faa31 = "Y" THEN 
       IF g_fah.fahdmy32 = "Y" THEN #FUN-C30313 add
          IF NOT cl_null(g_fbg.fbg082)  THEN      #FUN-C30313 08-->082
             CALL cl_err(g_fbg.fbg082,'aap-618',1) #FUN-C30313 08-->082
             RETURN
          END IF
       END IF #FUN-C30313 add
    END IF
   #FUN-B90004---End---
 
    CALL s_get_doc_no(g_fbg.fbg01) RETURNING g_t1
    SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
    IF g_fah.fahdmy3 = 'N' THEN RETURN END IF
   #IF g_fah.fahglcr = 'Y' THEN          #FUN-B90004
    IF g_fah.fahglcr = 'Y' OR ( g_fah.fahglcr = 'N' AND NOT cl_null(g_fah.fahgslp)) THEN   #FUN-B90004
       LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
      #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",  #FUN-A50102
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_plant_new,'aba_file'),  #FUN-A50102 
                   "  WHERE aba00 = '",g_faa.faa02b,"'",
                   "    AND aba01 = '",g_fbg.fbg08,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
       PREPARE aba_pre2 FROM l_sql
       DECLARE aba_cs2 CURSOR FOR aba_pre2
       OPEN aba_cs2
       FETCH aba_cs2 INTO l_n
       IF l_n > 0 THEN
          CALL cl_err(g_fbg.fbg08,'aap-991',1)
          RETURN
       END IF
      #FUN-B90004--Begin--
      ##FUN-B60140   ---start   Add
      #IF g_faa.faa31 = "Y" THEN
      #   LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
      #               "  WHERE aba00 = '",g_faa.faa02c,"'",
      #               "    AND aba01 = '",g_fbg.fbg082,"'"
      #   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      #   PREPARE aba_pre22 FROM l_sql
      #   DECLARE aba_cs22 CURSOR FOR aba_pre22
      #   OPEN aba_cs22
      #   FETCH aba_cs22 INTO l_n
      #   IF l_n > 0 THEN
      #      CALL cl_err(g_fbg.fbg082,'aap-991',1)
      #      RETURN
      #   END IF
      #END IF
      ##FUN-B60140   ---end     Add 
      #FUN-B90004---End---
       LET l_fahgslp = g_fah.fahgslp
    ELSE
      #CALL cl_err('','aap-992',1)   #FUN-B90004 mark
       CALL cl_err('','aap-936',1)   #FUN-B90004
       RETURN
    END IF
   #FUN-B90004--Begin--
    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahglcr = 'Y' OR ( g_fah.fahglcr = 'N' AND NOT cl_null(g_fah.fahgslp1)) THEN
          LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
                      "  WHERE aba00 = '",g_faa.faa02c,"'",
                      "    AND aba01 = '",g_fbg.fbg082,"'"
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          PREPARE aba_pre22 FROM l_sql
          DECLARE aba_cs22 CURSOR FOR aba_pre22
          OPEN aba_cs22
          FETCH aba_cs22 INTO l_n
          IF l_n > 0 THEN
             CALL cl_err(g_fbg.fbg082,'aap-991',1) 
             RETURN
          END IF
       ELSE
          CALL cl_err('','aap-936',1)
          RETURN
       END IF
    END IF
   #FUN-B90004---End---
    IF cl_null(l_fahgslp) THEN
       CALL cl_err(g_fbg.fbg01,'axr-070',1)
       RETURN
    END IF
#   IF g_aza.aza63 = 'Y' THEN   #FUN-AB0088 mark
    IF g_faa.faa31 = 'Y' THEN   #FUN-AB0088
       IF cl_null(g_fah.fahgslp1) THEN
          CALL cl_err(g_fbg.fbg01,'axr-070',1)
          RETURN
       END IF
    END IF
    LET g_wc_gl = 'npp01 = "',g_fbg.fbg01,'" AND npp011 = 1'
    LET g_str="afap302 '",g_wc_gl CLIPPED,"' '",g_fbg.fbguser,"' '",g_fbg.fbguser,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",l_fahgslp,"' '",g_fbg.fbg02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"   #No.FUN-680028   #MOD-860284#FUN-860040
    CALL cl_cmdrun_wait(g_str)
    #FUN-B60140   ---start   Add
     IF g_faa.faa31 = "Y" THEN
        IF g_fah.fahdmy32 = 'Y' THEN #FUN-C30313 add
           LET g_str="afap202 '",g_wc_gl CLIPPED,"' '",g_fbg.fbguser,"' '",g_fbg.fbguser,"' 
                    '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",l_fahgslp,"' '",g_fbg.fbg02,"' 
                   'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"
           CALL cl_cmdrun_wait(g_str)
        END IF #FUN-C30313 add
     END IF
    #FUN-B60140   ---end     Add
    SELECT fbg08,fbg09,fbg082,fbg092     #FUN-B60140   Add fbg082 fbg092 
      INTO g_fbg.fbg08,g_fbg.fbg09,g_fbg.fbg082,g_fbg.fbg092    #FUN-B60140   Add fbg082 fbg092 
      FROM fbg_file
     WHERE fbg01 = g_fbg.fbg01
    DISPLAY BY NAME g_fbg.fbg08
    DISPLAY BY NAME g_fbg.fbg09
    DISPLAY BY NAME g_fbg.fbg082     #FUN-B60140   Add
    DISPLAY BY NAME g_fbg.fbg092     #FUN-B60140   Add

END FUNCTION
 
FUNCTION t108_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
  DEFINE l_dbs      STRING
 
    IF NOT cl_confirm('aap-988') THEN RETURN END IF

   #FUN-B90004--Begin--
    IF cl_null(g_fbg.fbg08)  THEN
       CALL cl_err(g_fbg.fbg08,'aap-619',1)
       RETURN
    END IF
    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahdmy32 = "Y" THEN #FUN-C30313 add
       IF cl_null(g_fbg.fbg082)  THEN
          CALL cl_err(g_fbg.fbg082,'aap-619',1)
          RETURN
       END IF
       END IF #FUN-C30313 add
    END IF
   #FUN-B90004---End---

    CALL s_get_doc_no(g_fbg.fbg01) RETURNING g_t1
    SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
   #IF g_fah.fahglcr = 'N' THEN     #FUN-B90004
   #   CALL cl_err('','aap-990',1)  #FUN-B90004
    IF g_fah.fahglcr = 'N' AND cl_null(g_fah.fahgslp) THEN    #FUN-B90004
       CALL cl_err('','aap-936',1)  #FUN-B90004
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
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),  #FUN-A50102
                "  WHERE aba00 = '",g_faa.faa02b,"'",
                "    AND aba01 = '",g_fbg.fbg08,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
    PREPARE aba_pre FROM l_sql
    DECLARE aba_cs CURSOR FOR aba_pre
    OPEN aba_cs
    FETCH aba_cs INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_fbg.fbg08,'axr-071',1)
       RETURN
    END IF
 
    #FUN-B60140   ---start   Add
     IF g_faa.faa31 = "Y" THEN
        IF g_fah.fahdmy32 = "Y" THEN #FUN-C30313 add
           LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
                       "  WHERE aba00 = '",g_faa.faa02c,"'",
                       "    AND aba01 = '",g_fbg.fbg082,"'"
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
           PREPARE aba_pre21 FROM l_sql
           DECLARE aba_cs21 CURSOR FOR aba_pre21
           OPEN aba_cs21
           FETCH aba_cs21 INTO l_aba19
           IF l_aba19 = 'Y' THEN
              CALL cl_err(g_fbg.fbg082,'axr-071',1)
              RETURN
           END IF
        END IF #FUN-C30313 add
     END IF
    #FUN-B60140   ---end     Add
    LET g_str="afap303 '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fbg.fbg08,"' '",g_fbg00,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    #FUN-B60140   ---start   Add
     IF g_faa.faa31 = "Y" THEN
        IF g_fah.fahdmy32 = "Y" THEN #FUN-C30313 add
           LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_fbg.fbg082,"' '",g_fbg00,"' 'Y'"
           CALL cl_cmdrun_wait(g_str)
        END IF #FUN-C30313 add
     END IF
    #FUN-B60140   ---end     Add
    SELECT fbg08,fbg09,fbg082,fbg092    #FUN-B60140   Add  fbg082 fbg092 
      INTO g_fbg.fbg08,g_fbg.fbg09,g_fbg.fbg082,g_fbg.fbg092     #FUN-B60140   Add  fbg082 fbg092 
      FROM fbg_file
     WHERE fbg01 = g_fbg.fbg01
    DISPLAY BY NAME g_fbg.fbg08
    DISPLAY BY NAME g_fbg.fbg09
    DISPLAY BY NAME g_fbg.fbg082    #FUN-B60140   Add
    DISPLAY BY NAME g_fbg.fbg092    #FUN-B60140   Add
END FUNCTION

#FUN-AB0088---add---str---
FUNCTION t108_fin_audit2()
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_rec_b2   LIKE type_file.num5
   DEFINE l_faj28    LIKE faj_file.faj28 
   DEFINE l_fbh04    LIKE fbh_file.fbh04
   DEFINE l_fbh062   LIKE fbh_file.fbh062
   DEFINE l_fbh072   LIKE fbh_file.fbh072
   DEFINE l_fbh122   LIKE fbh_file.fbh122

   #FUN-C30140---add---str---
    IF g_fbg.fbg01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_fbg.* FROM fbg_file WHERE fbg01 = g_fbg.fbg01
    IF g_fbg.fbgconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_fbg.fbgconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_fbg.fbgpost = 'Y' THEN CALL cl_err('','afa-101',0) RETURN END IF
    IF NOT cl_null(g_fbg.fbg10) AND g_fbg.fbg10 matches '[Ss]' THEN     
        CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
        RETURN
    END IF
   #FUN-C30140---add---end---
   OPEN WINDOW t1089_w2 WITH FORM "afa/42f/afat1089"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("afat1089")

    LET g_sql =
        " SELECT fbh02,fbh03,fbh031,faj06,faj18,fbh04,fbh062,",
        "        fbh072,fbh082,fbh122 ",   
        " FROM fbh_file, OUTER faj_file ",
        " WHERE fbh03=faj02 AND fbh031=faj022 ",
        "    AND fbh01 ='",g_fbg.fbg01,"'", 
        " ORDER BY fbh02"

   PREPARE afat108_2_pre FROM g_sql

   DECLARE afat108_2_c CURSOR FOR afat108_2_pre

   CALL g_fbh2.clear()

   LET l_cnt = 1

   FOREACH afat108_2_c INTO g_fbh2[l_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach fbh2',STATUS,0)
         EXIT FOREACH
      END IF

      SELECT faj06,faj18,(faj17-faj582),(faj142+faj1412-faj592),
             (faj322-faj602),(faj1012-faj1022)
        INTO g_fbh2[l_cnt].faj06,g_fbh2[l_cnt].faj18,
             l_fbh04,l_fbh062,l_fbh072,l_fbh122
        FROM faj_file
       WHERE faj02 = g_fbh2[l_cnt].fbh03
         AND faj022= g_fbh2[l_cnt].fbh031  
      LET l_cnt = l_cnt + 1

   END FOREACH

   CALL g_fbh2.deleteElement(l_cnt)

   LET l_rec_b2 = l_cnt - 1
   DISPLAY l_rec_b2 TO FORMONLY.cn2   

   LET l_ac = 1

   CALL cl_set_act_visible("cancel", FALSE)

   IF g_fbg.fbgconf !="N" THEN    
      DISPLAY ARRAY g_fbh2 TO s_fbh2.* ATTRIBUTE(COUNT=l_rec_b2,UNBUFFERED)

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
    LET g_forupd_sql = " SELECT fbh02,fbh03,fbh031,'','',fbh04,",
                       "        fbh062,fbh072,fbh082,fbh122 ",
                       " FROM fbh_file ",
                       " WHERE fbh01 ='",g_fbg.fbg01,"'",
                       "   AND fbh02= ? ",
                       " FOR UPDATE "
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      
      DECLARE t108_2_bcl CURSOR FROM g_forupd_sql 
       
      INPUT ARRAY g_fbh2 WITHOUT DEFAULTS FROM s_fbh2.*
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
               LET g_fbh2_t.* = g_fbh2[l_ac].* 
               OPEN t108_2_bcl USING g_fbh2_t.fbh02
               IF STATUS THEN
                  CALL cl_err("OPEN t108_2_bcl:", STATUS, 1)
               ELSE
                  FETCH t108_2_bcl INTO g_fbh2[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_fbh2_t.fbh02,SQLCA.sqlcode,1)
                  END IF
                 #MOD-BB0223 -- mark begin --
                 #SELECT faj06,faj18 INTO g_fbh2[l_ac].faj06,g_fbh2[l_ac].faj18
                 #  FROM faj_file
                 # WHERE faj02 = g_fbh2[l_ac].fbh03
                 #   AND faj022= g_fbh2[l_ac].fbh031  
                 #IF g_fbh2[l_ac].fbh04 = 0 THEN
                 #    LET g_fbh2[l_ac].fbh062  =l_fbh062
                 #    LET g_fbh2[l_ac].fbh072  =l_fbh072
                 #    LET g_fbh2[l_ac].fbh082  =l_fbh062 - l_fbh072
                 #    LET g_fbh2[l_ac].fbh122  =l_fbh122          
                 #ELSE
                 #    IF cl_null(g_fbh2[l_ac].fbh072) OR g_fbh2[l_ac].fbh072 = 0 THEN
                 #        LET g_fbh2[l_ac].fbh072 =l_fbh072*(g_fbh2[l_ac].fbh04/l_fbh04)
                 #        LET g_fbh2[l_ac].fbh072 =cl_digcut(g_fbh2[l_ac].fbh072,g_azi04) 
                 #    END IF
                 #    IF cl_null(g_fbh2[l_ac].fbh062) OR g_fbh2[l_ac].fbh062 = 0 THEN
                 #        LET g_fbh2[l_ac].fbh062 =l_fbh062*(g_fbh2[l_ac].fbh04/l_fbh04)
                 #        LET g_fbh2[l_ac].fbh062 = cl_digcut(g_fbh2[l_ac].fbh062,g_azi04) 
                 #    END IF
                 #    IF cl_null(g_fbh2[l_ac].fbh082) OR g_fbh2[l_ac].fbh082 = 0 THEN
                 #        LET g_fbh2[l_ac].fbh082 =g_fbh2[l_ac].fbh062 - g_fbh2[l_ac].fbh072
                 #        LET g_fbh2[l_ac].fbh082 = cl_digcut(g_fbh2[l_ac].fbh082,g_azi04)          
                 #    END IF
                 #    IF g_fbh2[l_ac].fbh122 = 0 THEN
                 #        LET g_fbh2[l_ac].fbh122 = l_fbh122*(g_fbh[l_ac].fbh04/l_fbh04)
                 #        LET g_fbh2[l_ac].fbh122 = cl_digcut(g_fbh2[l_ac].fbh122,g_azi04)
                 #    END IF
                 #END IF
                 #MOD-BB0223 -- mark end --
               END IF
            END IF
         
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fbh2[l_ac].* = g_fbh2_t.*
               CLOSE t108_2_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
       
           #CHI-C60010---str---
            CALL cl_digcut(g_fbh2[l_ac].fbh062,g_azi04_1) RETURNING g_fbh2[l_ac].fbh062
            CALL cl_digcut(g_fbh2[l_ac].fbh072,g_azi04_1) RETURNING g_fbh2[l_ac].fbh072
            CALL cl_digcut(g_fbh2[l_ac].fbh082,g_azi04_1) RETURNING g_fbh2[l_ac].fbh082
            CALL cl_digcut(g_fbh2[l_ac].fbh122,g_azi04_1) RETURNING g_fbh2[l_ac].fbh122
           #CHI-C60010---end--- 
            UPDATE fbh_file SET fbh062 = g_fbh2[l_ac].fbh062,
                                fbh072 = g_fbh2[l_ac].fbh072, 
                                fbh082 = g_fbh2[l_ac].fbh082, 
                                fbh122 = g_fbh2[l_ac].fbh122 
             WHERE fbh01 = g_fbg.fbg01
               AND fbh02 = g_fbh2_t.fbh02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","fbh_file",g_fbg.fbg01,g_fbh2_t.fbh02,SQLCA.sqlcode,"","",1)  
               LET g_fbh2[l_ac].* = g_fbh2_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
      
         AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN 
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fbh2[l_ac].* = g_fbh2_t.*
               CLOSE t108_2_bcl 
               ROLLBACK WORK 
               EXIT INPUT
            END IF
            CLOSE t108_2_bcl 
            COMMIT WORK

       #MOD-BB0223 -- begin --
        BEFORE FIELD fbh062
           SELECT faj06,faj18 INTO g_fbh2[l_ac].faj06,g_fbh2[l_ac].faj18
             FROM faj_file
            WHERE faj02 = g_fbh2[l_ac].fbh03
              AND faj022= g_fbh2[l_ac].fbh031
           IF g_fbh2[l_ac].fbh04 = 0 THEN
               LET g_fbh2[l_ac].fbh062  =l_fbh062
               LET g_fbh2[l_ac].fbh072  =l_fbh072
               LET g_fbh2[l_ac].fbh082  =l_fbh062 - l_fbh072
               LET g_fbh2[l_ac].fbh122  =l_fbh122
           ELSE
               IF cl_null(g_fbh2[l_ac].fbh072) OR g_fbh2[l_ac].fbh072 = 0 THEN
                   LET g_fbh2[l_ac].fbh072 =l_fbh072*(g_fbh2[l_ac].fbh04/l_fbh04)
                   #LET g_fbh2[l_ac].fbh072 =cl_digcut(g_fbh2[l_ac].fbh072,g_azi04)   #CHI-C60010 mark
               END IF
               IF cl_null(g_fbh2[l_ac].fbh062) OR g_fbh2[l_ac].fbh062 = 0 THEN
                   LET g_fbh2[l_ac].fbh062 =l_fbh062*(g_fbh2[l_ac].fbh04/l_fbh04)
                   #LET g_fbh2[l_ac].fbh062 = cl_digcut(g_fbh2[l_ac].fbh062,g_azi04)  #CHI-C60010 mark
               END IF
               IF cl_null(g_fbh2[l_ac].fbh082) OR g_fbh2[l_ac].fbh082 = 0 THEN
                   LET g_fbh2[l_ac].fbh082 =g_fbh2[l_ac].fbh062 - g_fbh2[l_ac].fbh072
                   #LET g_fbh2[l_ac].fbh082 = cl_digcut(g_fbh2[l_ac].fbh082,g_azi04)  #CHI-C60010 mark
               END IF
               IF g_fbh2[l_ac].fbh122 = 0 THEN
                   LET g_fbh2[l_ac].fbh122 = l_fbh122*(g_fbh[l_ac].fbh04/l_fbh04)
                   #LET g_fbh2[l_ac].fbh122 = cl_digcut(g_fbh2[l_ac].fbh122,g_azi04)  #CHI-C60010 mark
               END IF
           END IF
           #CHI-C60010---str---
            CALL cl_digcut(g_fbh2[l_ac].fbh062,g_azi04_1) RETURNING g_fbh2[l_ac].fbh062
            CALL cl_digcut(g_fbh2[l_ac].fbh072,g_azi04_1) RETURNING g_fbh2[l_ac].fbh072
            CALL cl_digcut(g_fbh2[l_ac].fbh082,g_azi04_1) RETURNING g_fbh2[l_ac].fbh082
            CALL cl_digcut(g_fbh2[l_ac].fbh122,g_azi04_1) RETURNING g_fbh2[l_ac].fbh122
           #CHI-C60010---end---
           DISPLAY BY NAME g_fbh2[l_ac].fbh062
           DISPLAY BY NAME g_fbh2[l_ac].fbh072
           DISPLAY BY NAME g_fbh2[l_ac].fbh082
           DISPLAY BY NAME g_fbh2[l_ac].fbh122
       #MOD-BB0223 -- end --

        AFTER FIELD fbh062
           IF g_fbh2[l_ac].fbh062<0 THEN
              CALL cl_err('','mfg4012',0)
              NEXT FIELD fbh062
           END IF
            CALL cl_digcut(g_fbh2[l_ac].fbh062,g_azi04_1) RETURNING g_fbh2[l_ac].fbh062  #CHI-C60010

        AFTER FIELD fbh072
           IF g_fbh2[l_ac].fbh072<0 THEN
              CALL cl_err('','mfg4012',0)
              NEXT FIELD fbh072
           END IF
            CALL cl_digcut(g_fbh2[l_ac].fbh072,g_azi04_1) RETURNING g_fbh2[l_ac].fbh072  #CHI-C60010

        AFTER FIELD fbh082
           IF g_fbh2[l_ac].fbh082<0 THEN
              CALL cl_err('','mfg4012',0)
              NEXT FIELD fbh082
           END IF
            CALL cl_digcut(g_fbh2[l_ac].fbh082,g_azi04_1) RETURNING g_fbh2[l_ac].fbh082  #CHI-C60010
       
        AFTER FIELD fbh122
           IF g_fbh2[l_ac].fbh122<0 THEN
              CALL cl_err('','mfg4012',0)
              NEXT FIELD fbh122
           END IF
            CALL cl_digcut(g_fbh2[l_ac].fbh122,g_azi04_1) RETURNING g_fbh2[l_ac].fbh122  #CHI-C60010

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
 
   CLOSE WINDOW t1089_w2

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF

END FUNCTION
#FUN-AB0088---add---end---
#No.FUN-9C0072 精簡程式碼

