# Prog. Version..: '5.30.06-13.03.12(00010)'     #
# Pattern name...: apsp500.4gl
# Descriptions...: TIPTOP 基礎資料匯出至APS
# Date & Author..: 2008/04/14 By Mandy #FUN-840008
# Modify.........: No:FUN-840194 08/06/24 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No:TQC-860041 08/06/24 By Mandy APS整合二次開發問題
# Modify.........: No.TQC-870007 08/07/02 By Mandy vbc_file,vbd_file,vbe_file,vbf_file,vbg_file拋轉時,請參考計畫檔,若有預設值欄位,需作判斷(若欄位值為null,需塞預設值進去)
# Modify.........: No.MOD-870103 08/07/09 By Mandy(1)不需要去更新vla_file
#                                                 (2)add vad10~vad14,van20~van24 
# Modify.........: No:FUN-870071 08/07/14 By Mandy (1)鎖定執行規劃時僅可一人操作
#                                                  (2)vai56 預設值0
#                                                  (3)p500_upd_config()內會更新vlz03,但不需再多加條件IF tm.vlb21 = 'Y' OR tm.vlb27 = 'Y' THEN
#                                                  (4)vzz03改成tm.vlb04
# Modify.........: No.TQC-870032 08/07/21 By Mandy 因新增維護欄位vmj10,故vbi05=vmj10,如果vmj_file沒有記錄,請帶預設值999
# Modify.........: No:TQC-870043 08/07/30 By Mandy (1)元件序號(vax03)不抓BOM表了,改為同張製令直接依序給值1.2.3.4
#                                                  (2)vai58 調整
#                                                  (3)vai63 調整 
#                                                  (4)vam增加拋轉ima_file的資料
# Modify.........: No:TQC-880005 08/08/04 By Mandy van10,van11 判斷抓機器產能或人工產能,改直接依據aeci600 工作站類型(eca06) 
# Modify.........: No:TQC-880053 08/08/27 BY DUKE p500_vai() 增加提取vmj10資料,p50_vay()移除vay17資料存取
# Modify.........: No.FUN-890058 08/09/11 By Mandy 將品項途程檔(vam_file),於轉至中介檔時加上最後異動日的比較(ecudate & vla02),僅轉出ecudate>=vla02的資料
# Modify.........: No:FUN-890059 08/09/11 By Mandy (1)多拋van25外包商編號
#                                                  (2)當van14 = 1(外包)時,van07值為van25
#                                                  (3)apsi326 拋van_file時,以下欄位抓取邏輯有變van10,van11,van14,van25
# Modify.........: No:FUN-890086 08/09/17 By Mandy 當vnc03為空 or NULL時,此筆資料不需要拋轉
# Modify.........: No:FUN-890087 08/09/17 By Mandy 程式調整成可背景排程執行
# Modify.........: No.FUN-890105 08/09/23 By Mandy INSERT INTO vlh_file多add vlh06(背景執行否) #TQC-890046
# Modify.........: No.TQC-890063 08/09/30 By Mandy vnc_file轉檔至vbc_file時,當vnc03 ='0' and vnc04='0'時,此筆資料不需拋轉
# Modify.........: No:TQC-8A0002 08/10/01 By Mandy (1)apsi326抓van07的值應為vms07 or vms08
#                                                  (2) p500_van_2()內 SELECT eca06 SQL條件有誤
#                                                  (3) van25先抓取pmm09,應判斷到 pmn43(本製程序號),vbg_file也需同步調整
#                                                  (4) pmm_file撈取時,要排除pmm18='X'(作廢)的資料,(van及vaw.vbf.vbg撈取需同步調整)
# Modify.........: No:FUN-8A0003 08/10/01 By Mandy 工模具檔案拋轉
# Modify.........: 2008/10/06 By Mandy #FUN-8A0011 限定版本功能
# Modify.........: 2008/10/08 By Mandy #TQC-8A0019 限定版本加強: (1)採購.請購增加單別控管 (2)倉庫可以判斷到*
#                                                  基本資料拋轉. (1)將途程製程檔(van_file),於轉至中介檔時加上最後異動日的比較(ecudate & vla02),僅轉出ecudate>=vla02的資料
#                                                                (2)vax_file不用有(sfa05 > (sfa06 + sfa065)條件
# Modify.........: 2008/10/14 By Mandy #FUN-8A0062 出現 p500_vaz1_c 跟 p500_vaz2_c 語法錯誤
# Modify.........: 2008/10/15 By Mandy #TQC-8A0021 #TQC-8A0019 限定版本加強: (1)採購.請購增加單別控管 沒改好的調整
# Modify.......... 2008/10/15 By Mandy #TQC-8A0053 (1)vnn_file拋轉至vbn_file時,要把日期跟時間組合後放至vbn02.vbn03 (若vnn03為空,則vbn03帶空值)
#                                                  (2)vmi_file拋轉至vai_file時,vai49的預設值為5,vai50的預設值為10
#                                                  (3-1)輸入vlz03(拆成輸入"規劃開始日期","規劃開始時間"),規劃開始日期帶原vlz03的值,若vlz03的值小於今天改default 今天.
#                                                  (3-2)用"規劃開始日期","規劃開始時間"的值去UPDATE vlz03
# Modify.......... 2008/11/13 By Mandy #TQC-8B0029 (1)apsp500執行時,需增加check APS版本及儲存版本在vzy_file的vzy10是否等於Y or L,等於Y or 'L' 情況下才允許執行
#                                                  (2)check 存在MDS沖銷記錄檔(原本就有的判斷)
#                                                  (3)需檢查vzv_file,若vzv_file有存在相同的APS版本,當vzv04='30',vzv06='Y',vzv07='Y'時,
#                                                     且vzv04找不到40的資料時,則需跳出警示訊息告知使用者"尚有APS版本:?? 儲存版本:?? 
#                                                     還未進行規劃確認,是否確定覆蓋此版本資料?" 
# Modify.......... 2008/11/19 By Mandy #TQC-8B0036 工單轉至暫存檔vaw_file時，vaw08原用標準的品號＋製程編號,請改成用"標準的品號+工單號碼"
# Modify.......... 2008/11/19 By Mandy #TQC-8B0037 vay_file.vay06未完成量為0，有問題,調整計算公式
# Modify.......... 2008/11/19 By Mandy #TQC-8B0040 vaz_file(採購令)拋轉時,ERP預計抵達日期改拋到廠日(pmn34/pml34)
# Modify.........: 2008/11/20 By Mandy #TQC-8B0041 vai16/vai17/vai57 default值調整
# Modify.........: 2008/11/20 By Mandy #TQC-8B0042 vzz58/vzz59/vzz71 值給錯,修正
# Modify.........: 2008/11/20 By Mandy #TQC-8B0044 apsp500畫面加show vla02(最後異動日)(ReadOnly)
# Modify.........: 2008/11/20 By Mandy #TQC-8C0014 (1)apsp500增加vlz73~vlz75拋轉至vzz73~vzz75
#                                                  (2)apsp500增加vmn19拋轉至van26
#                                                  (3)apsp500進行vao_file拋轉時,bmb08應除以100後再拋轉至vao12
# Modify.........: 2008/12/17 By Mandy #TQC-8C0034 拋轉van11時,ecm16及ecm14需在除以sfb08
# Modify.........: 2008/12/18 By Mandy #TQC-8C0034 若無拋轉記錄時,最後異動日為99/12/31,應清為NULL
# Modify.........: 2008/12/31 By Duke  #FUN-8C0140 run apsp702時加顯示aps版本及儲存版本
# Modify.........: 2009/01/05 By Duke  #FUN-910005 add 供給法則相關參數欄位
# Modify.......... 2009/01/15 By Duke  #FUN-8C0140 mark 掉 apsp500 之 p500_vzt ;因目前資料拋轉已於主資料庫建立時直接由 vzt_file 拋出，不透過 vlx_file亦不需再拋一次
#                                                  apsp500調整 vaz_file拋轉, 當pml16拋轉至vaz14時,當pml16='2'時,拋轉至vaz14='3' 
# Modify.........: 2009/01/21 By Duke  #TQC-910049 修正 p500_van_2() 原sfb08=l_ecm.ecm01 改為 sfb01=l_ecm.ecm01
# Modify.........: 2009/01/22 By Duke  #TQC-910057 修正 apsp500 拋轉時,van11(加工時間)的值,不因van10為NULL,而影響,各看各的值
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No:FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No:TQC-920084 09/02/25 by duke 規劃時間應為目前時間,並加入顯示最近規劃時間
# Modify.........: No:FUN-930029 09/03/06 by duke 加拋vao21 BOM表工單開立選項
# Modify.........: No.FUN-930078 09/03/13 By Duke vak_file資料拋轉改以pmh_file 	為主要table ,且vak18改拋入pmh11
# Modify.........: No:FUN-930087 09/03/16 By Duke 新增拋轉維護欄位 vai65 供應商比例最低量限制
# Modify.........: No:FUN-930086 09/03/16 By Duke 新增拋轉欄位 vaz26 TP到庫日(pml35, pmn35)
# Modify.........: No.TQC-930117 09/03/17 By Duke 修正vao_file拋轉資料vao21
# Modify.........: No:FUN-930149 09/03/25 By Duke vmk加拋vmk19=vak19 供應商型態
# Modify.........: No:FUN-930127 09/03/25 By Duke 新增相關欄位(vai,van,vao,vaw,vax,vob,vod,voe,vzz,vak)
# Modify.........: No:FUN-930161 09/03/31 By Duke 加入APS保留欄位
# Modify.........: No.TQC-940012 09/04/02 BY DUKE 單品取替代改不卡bmb_file
# Modify.........: No:FUN-940030 09/04/10 BY Duke 傳遞參數執行apsp450 TIPTOP匯出至APS前置稽核作業
#                                                 將原out() 報表顯示改成call apsq450 以畫面顯示方式
# Modify.........: No:CHI-940025 09/04/10 BY DUKE 抓取料件供商段vak要考量同一廠商/料件會有不同幣別的情況,
#                  現不考慮,會同一料+廠商捉出多筆,在insert vak時,會key值重覆建議用核價日(pmh06)最後一筆為主
# Modify.........: No:MOD-940144 09/04/14 by duke 修正bom表工單是否展開選項
# Modify.........: No:FUN-940090 09/04/17 By Duke 加拋欄位 vaw25 工單已發套數
# Modify.........: No.FUN-930161 09/04/21 By Duke 調整vzz_file的INSERT INTO的方式,不用PUT 因為有欄位順序對應問題
# Modify.........: No:TQC-940166 09/04/27 By Duke apsp500  vbd03, vbe03 格式轉換參考 van03 (如1轉換為0001)
# Modify.........: No:TQC-940156 09/04/29 By Duke 調整採購單撈取條件
#                                                 vaz05修改為 pmn20,(pmn50-pmn55)取其大
#                                                 vaz11修改為 pmn53
#                                                 p500_vaz_1()拋轉條件 pmk02<>'SUB'要拿掉
# Modify.........: No:TQC-940167 09/05/07 By Duke 調整 vaz02,vaz26,vax12,vax13,vax07 之計算公式
# Modify.........: No:TQC-950064 09/05/12 By Duke apsp702執行時增加顯示 廠別
# Modify.........: No:FUN-960039 09/06/04 By Duke FOR APS整合 CP規格調整
# Modify.........: No:FUN-960167 09/07/17 By Duke apsp450加入流程檢核
# Modify.........: No:FUN-960073 09/09/01 By Mandy vai58,vai59 公式調整
# Modify.........: No:FUN-990012 09/09/07 By Mandy (1)10階段執行前就先起apsp702
#                                                  (2)調整p500_chk_vlh()段
# Modify.........: No.TQC-990040 09/09/10 By Mandy vnd_file (鎖定製程時間)拋轉到vbd_file時,時:分沒有拋轉成功
# Modify.........: No:TQC-990068 09/09/16 By Mandy 啟動apsp702加log
# Modify.........: No:TQC-990134 09/09/24 By Mandy SQL語法調整,因為5.0此種寫法r.c2 會err
# Modify.........: No.FUN-990090 09/09/30 By Mandy (1)vaw15調整 (2)vao_file BOM拋轉邏輯改成不判斷生效日
# Modify.........: No.FUN-9A0038 09/10/13 By Mandy vao_file(abmi600)拋轉時,產出量(bmb07)及元件投入量(bmb06)需由發料單位量轉換成庫存單位量後再拋給APS
# Modify.........: No.FUN-9A0029 09/10/20 By Mandy apsp500製令外包檔vbf_file拋轉時調整: vbf04=sfb13+sfb14(需轉為日期格式) ; vbf05=sfb15+sfb16(需轉為日期格式) ; vbf06=vbf05-vbf04(需轉換成秒)
# Modify.........: No.FUN-9A0047 09/10/20 By Mandy vbg_file的外包商編號(vbg05)拋轉邏輯,先抓pmm09 --> vmn18 --> vlz72
# Modify.........: No.TQC-9A0143 09/10/27 By Mandy (1)var_file: bmb08需除以100後,再轉給var08 (2)vaq_file: bmb08需除以100後,再轉給vaq09
# Modify.........: No:FUN-9B0003 09/11/02 By Mandy 異動單據拋轉順序調整
# Modify.........: No:FUN-A40017 10/04/07 By Mandy 特性料件處理
# Modify.........: No.FUN-A60036 10/06/09 By Mandy vai_file料件主檔匯檔時,若ima08為'X'及'K'時,vai12都需給1,ima08非'X'及'K'時,vai12則給0
# Modify.........: No:CHI-A70049 10/07/28 By Pengu 將多餘的DISPLAY程式mark 
# Modify.........: No:FUN-A70035 10/08/10 By Mandy [取替代key值重覆問題]
#                                                  拋轉至vaq_file時,若生效日(bmd05)為NULL時，則填入1970/1/1;若失效日(bmd06)為NULL時，則填入2049/12/31
# Modify.........: No:FUN-A80047 10/08/10 By Mandy [展元件需求設定(vao14),是否為客供料(vao15)需給予設定]
#                                                  vao14: IF bmb14='1'(不需發料) THEN vao14='1'(不展元件需求) ELSE vao14='0'(視為一般需求)
#                                                  vao15: IF bmb14='3'(客供料) THEN vao15='1'(是客供料) ELSE vao15='0' (非客供料)
# Modify.........: No:FUN-A80075 10/08/19 By Mandy vai72 應調整成 0:需跑MRP,  1:不跑MRP
# Modify.........: No.FUN-AA0009 10/10/05 By Mandy vaq_file的vaq05(投入量) and var_file的var04(投入量) 調整
# Modify.........: No:FUN-AA0011 10/10/06 By Mandy 所有CALL s_umfchk 轉換率的地方,當無設定轉換關係時,需擋住並出現錯誤提示訊息
# Modify.........: No:MOD-B10140 11/01/19 By Mandy vao04=bmb07 * 單位換算率，單位換算率應是主件(bmb01)的生產單位(ima55)轉成庫存單位(ima25)
# Modify.........: No:FUN-B10015 11/01/19 By Mandy (1)單品取替代,替代料的"發料單位"改用其在料件主檔所設定的發料單位(ima63)
#                                                  (2)當已有版本在執行時,若執行下一個版本會出現"還未進行規劃確認,是否確定覆蓋此版本資料?(aps-031)"的訊息要擋掉
#                                                  (3)vai30/vai32/vai34 不透過料件主檔的轉換率而是要即時算出轉換率給APS
# Modify.........: No:FUN-B10068 11/01/28 By Mandy Apsp500在塞資料前，應該把全部的中介檔資料砍掉才對,不需控卡有勾選的才砍
# Modify.........: No:MOD-B20124 11/02/23 By Mandy 若vax13若不考慮損耗率的情況下應固定給 0,
#                                                  因此公式應修正為 IF asms270之sma71(工單備料時下階料件是否考慮損耗率) ='Y' THEN((sfa05*bmb08*0.01)/sfa28)*sfa13   ELSE  0
# Modify.........: No.FUN-B30200 11/03/29 By Mandy (1)拋轉vax_file時,增加拋轉vax14 (vax14=sfa27)
#                                                  (2)拋轉vaq_file時,p500_vaq() 增加 bmd08 <> 'ALL' 判斷條件
# Modify.........: No.FUN-B50022 11/05/11 By Mandy---GP5.25 追版:以上為GP5.1 的單號---
# Modify.........: No.FUN-B50101 11/05/20 By Mandy GP5.25 平行製程 影響APS程式調整
# Modify.........: No.FUN-B50161 11/05/24 By Mandy 依營運中心(g_plant)+日期 產生log檔
# Modify.........: No.FUN-B60062 11/06/10 By Mandy CALL cl_set_num_value() 時,需先將值算出,再丟給cl_set_num_value()做計算
# Modify.........: No.FUN-B60084 11/06/15 By Mandy 拋至vzz_file時vzzlegal,vzzplant,vzz92,vzz93的值並未給予
# Modify.........: No.FUN-B60152 11/06/29 By Mandy 抓取途程製程--標準(aeci100)的程式段p500_van_1(),在判斷最後異動日上是用單身的ecbdate,應改用單頭ecudate來判斷
# Modify.........: No.TQC-B70094 11/07/15 By Abby  調整顯示在apsq450的錯誤訊息碼(vlc08)和錯誤訊息內容(vlc07)
# Modify.........: No.FUN-B40073 11/07/19 By Abby  抓取bmd_file時，需考慮失效日
# Modify.........: No.FUN-B70024 11/07/19 By Abby  (1)抓取p500_van_3() #替代作業維護檔(apsi326)的資料也需加上最後異動日(ecudate)的判斷
# Modify.........: No.FUN-B80084 11/08/12 By Abby  在apsq450呈現拋轉各TABLE的起始時間,截止時間,差異秒數
# Modify.........: No.FUN-B80124 11/08/19 By Abby  外包商(vbh_file)資料拋轉,過濾只抓 資料性質(pmc14)為 1.採購廠商
# Modify.........: No.FUN-B80002 11/08/19 By Abby  未完成量(vay06)調整
# Modify.........: No.FUN-B80055 11/08/19 By Abby  抓vak_file的最後異動日調整
# Modify.........: No.FUN-B80173 11/08/25 By Abby  apsp500拋轉vax05(元件已領用量)公式異動調整
# MOdify.........: No.FUN-B90040 11/09/07 By Abby  (1)vak_file 開新欄位加拋供應商(vak02)的名稱,請抓(pmc03)
#                                                  (2)vay_file開新欄位加拋二個欄位aeci700的工作站(ecm06)/工作站名稱(eca02)
#                                                  (3)FUNCTION p500_vaz_2()#採購單拋採購單時:
#                                                     vaz02改直接拋pmn34
#                                                     vaz26改直接拋pmn35
# Modify.........: No.FUN-BA0086 11/10/21 By Mandy (1)for gp5.25 axmt410右邊的"備置"，已改串axmi611,所以拋至中介檔的vba_file資料也應改抓axmi611的資料
#                                                  (2)FUNCTION p500_vba_2() 當PUT有錯時,產生至log檔的Key值無呈現
# Modify.........: No.FUN-BA0020 11/10/17 By Abby  p500_van_2()#途程製程--工單(aeci700)  van11 改抓vmn20 or vmn21
# Modify.........: No.FUN-BA0035 11/11/03 By Abby  FUNCTION p500_vak() 新增欄位加拋[vmk20]最少採購數量/[vmk21]採購單位批量 
#                                                  FUNCTION p500_vzz() 新增欄位加拋[vlz84]安全庫存模式
# Modify.........: No.FUN-B90021 11/11/28 By Mandy GP5.25以上 vam_file 的Key應是 料號(vam01)+途程編號(vam02) 不是 料號(vam01)+途程編號(vam02)+製程段號(vam16)
# Modify.........: No.FUN-BB0137 11/12/12 By Mandy 抓取BOM時,應考慮BOM是否已發放;發放的才抓取至APS
# Modify.........: No.FUN-BC0040 11/12/12 By Mandy 異常資料重拋
# Modify.........: No.FUN-BB0085 11/12/19 By xianghui 增加數量欄位小樹取位
# Modify.........: No.FUN-C30309 12/04/03 By Abby  vai_file料件主檔匯檔時,若ima08為'X'及'K','C','D'時,vai12給1;ima08非'X'及'K','C','D'時,vai12給0
# Modify.........: No.FUN-C30283 12/04/03 By Abby  移除FUN-9B0129調整的程式段
# Modify.........: No.FUN-C50056 12/07/03 By Mandy vax05,vax12,vax13 公式調整
# Modify.........: No.FUN-BB0143 12/10/12 By Nina  領料倍量(vai14)的值是抓發料單位批量(ima64),但其單位是發料單位,所以應將ima64的值轉換成庫存單位
# MOidfy.........: No.FUN-C20017 12/10/12 By Nina  因為pmh06會有NULL值，因此在join時條件 pmh06 = mpmh06 會自動過濾掉NULL的資料，修正需保留pmh06 = null 的資料
# MOidfy.........: No.FUN-CA0018 12/10/25 By Nina  psp500 拋vbm_file需加拋由標準aeci100==>串 APS替代作業(apsi326)==>再串 途程製程指定工具(apsi331) 的資料
# Modify.........: No.FUN-CA0159 12/11/02 By Abby  抓取BOM時,應考慮BOM發放日(bma05)大於基本資料最後異動日(vla02);發放的才抓取至APS
# Modify.........: No.FUN-C20113 12/11/30 By Nina  增加APS版本目前已有人使用之錯誤訊息相關資訊
#                                                  執行apsp500至最後show出執行結果後，改顯示訊息aps-812，使用者按下「確定」後即關閉apsp500
# Modify.........: No.FUN-CB0131 12/12/03 By Nina  將工單相關控管條件改成 sfb08(生產數量)>sfb09(已完工數量)+sfb12(報廢量)
# Modify.........: No.FUN-C40017 12/12/14 By Nina 若l_bmb08是NULL則將l_bmb08給0,避免導致vax12,vax13的值不正確
# Modify.........: No.FUN-D10051 13/01/15 By Mandy vlhplant,vlhlegal未塞值
# Modify.........: No:FUN-D40103 13/05/08 By lixh1 增加儲位有效性檢查

DATABASE ds

GLOBALS "../../config/top.global"
 DEFINE g_nor_data      STRING #FUN-890087 add #TQC-890046
 DEFINE g_req_data      STRING #FUN-890087 add 
 DEFINE g_sup_data      STRING #FUN-890087 add 
 DEFINE g_cap_data      STRING #FUN-890087 add 
 DEFINE tm              RECORD LIKE vlb_file.* #FUN-840008
 DEFINE g_vap           RECORD LIKE vap_file.*
 DEFINE g_var           RECORD LIKE var_file.*
 DEFINE g_vaq           RECORD LIKE vaq_file.*
 DEFINE g_vao           RECORD LIKE vao_file.*
 DEFINE g_vas           RECORD LIKE vas_file.*
 DEFINE g_vab           RECORD LIKE vab_file.*
 DEFINE g_vav           RECORD LIKE vav_file.*
 DEFINE g_vau           RECORD LIKE vau_file.*
 DEFINE g_vau1          RECORD LIKE vau_file.*
 DEFINE g_vau2          RECORD LIKE vau_file.*
 DEFINE g_val           RECORD LIKE val_file.*
 DEFINE g_vai           RECORD LIKE vai_file.*
 DEFINE g_vam           RECORD LIKE vam_file.*
 DEFINE g_vax           RECORD LIKE vax_file.*  
 DEFINE g_vat           RECORD LIKE vat_file.*
 DEFINE g_vad           RECORD LIKE vad_file.*
 DEFINE g_vae           RECORD LIKE vae_file.*
 DEFINE g_van           RECORD LIKE van_file.*
 DEFINE g_vag           RECORD LIKE vag_file.*
 DEFINE g_vaw           RECORD LIKE vaw_file.*
 DEFINE g_vaz1          RECORD LIKE vaz_file.*
 DEFINE g_vaz2          RECORD LIKE vaz_file.*
 DEFINE g_vak           RECORD LIKE vak_file.*
 DEFINE g_vah           RECORD LIKE vah_file.*
 DEFINE g_vaj           RECORD LIKE vaj_file.*
 DEFINE g_vaf           RECORD LIKE vaf_file.*
 DEFINE g_vac           RECORD LIKE vac_file.*
 DEFINE g_vaa           RECORD LIKE vaa_file.*
 DEFINE g_vbh           RECORD LIKE vbh_file.*
 DEFINE g_vbi           RECORD LIKE vbi_file.*
 DEFINE g_vzz           RECORD LIKE vzz_file.*
 DEFINE g_vzy           RECORD LIKE vzy_file.*
 #DEFINE g_vzt           RECORD LIKE vzt_file.*   #FUN-8C0140  MARK
 DEFINE g_vob           RECORD LIKE vob_file.*
 DEFINE g_vod           RECORD LIKE vod_file.*
 DEFINE g_voe           RECORD LIKE voe_file.*
 DEFINE g_vba           RECORD LIKE vba_file.*
 DEFINE g_vba1          RECORD LIKE vba_file.*
 DEFINE g_vba2          RECORD LIKE vba_file.*
 DEFINE g_vbb           RECORD LIKE vbb_file.*
 DEFINE g_vbc           RECORD LIKE vbc_file.*
 DEFINE g_vbd           RECORD LIKE vbd_file.*
 DEFINE g_vbe           RECORD LIKE vbe_file.*
 #FUN-960039 MOD --STR------------------------------
 #DEFINE g_vbf           RECORD LIKE vbf_file.*
 #DEFINE g_vbg           RECORD LIKE vbg_file.*  
  DEFINE g_vbf           RECORD
         vbf01	         LIKE vbf_file.vbf01,
         vbf02	         LIKE vbf_file.vbf02,
         vbf03	         LIKE vbf_file.vbf03,
         vbf04	         DATETIME YEAR TO SECOND,
         vbf05	         DATETIME YEAR TO SECOND,
         vbf06	         LIKE vbf_file.vbf06,
         vbf07	         LIKE vbf_file.vbf07,
         vbfplant        LIKE vbf_file.vbfplant,  #FUN-B50022 add
         vbflegal        LIKE vbf_file.vbflegal,  #FUN-B50022 add
         vbf08	         LIKE vbf_file.vbf08,
         vbf09	         LIKE vbf_file.vbf09,
         vbf10	         LIKE vbf_file.vbf10,
         vbf11	         LIKE vbf_file.vbf11,
         vbf12	         LIKE vbf_file.vbf12,
         vbf13	         LIKE vbf_file.vbf13,
         vbf14	         LIKE vbf_file.vbf14,
         vbf15	         LIKE vbf_file.vbf15
                         END RECORD
  DEFINE g_vbg          RECORD
         vbg01		LIKE vbg_file.vbg01,
         vbg02		LIKE vbg_file.vbg02,
         vbg03		LIKE vbg_file.vbg03,
         vbg04		LIKE vbg_file.vbg04,
         vbg05		LIKE vbg_file.vbg05,
         vbg06		LIKE vbg_file.vbg06,
         vbg07		DATETIME YEAR TO SECOND,
         vbg08		DATETIME YEAR TO SECOND,
         vbg09		LIKE vbg_file.vbg09,
         vbg10		LIKE vbg_file.vbg10,
         vbg11		LIKE vbg_file.vbg11,
         vbg12		LIKE vbg_file.vbg12,
         vbgplant       LIKE vbg_file.vbgplant, #FUN-B50022 add
         vbglegal       LIKE vbg_file.vbglegal, #FUN-B50022 add
         vbg13		LIKE vbg_file.vbg13,
         vbg14		LIKE vbg_file.vbg14,
         vbg15		LIKE vbg_file.vbg15,
         vbg16		LIKE vbg_file.vbg16,
         vbg17		LIKE vbg_file.vbg17,
         vbg18		LIKE vbg_file.vbg18,
         vbg19		LIKE vbg_file.vbg19,
         vbg20		LIKE vbg_file.vbg20,
         vbg012     	LIKE vbg_file.vbg012    #FUN-B50101 add
                       END RECORD
 #FUN-960039 MOD --END-----------------------------
 DEFINE g_vbj           RECORD LIKE vbj_file.* #FUN-8A0003 add
 DEFINE g_vbk           RECORD LIKE vbk_file.* #FUN-8A0003 add
 DEFINE g_vbl           RECORD LIKE vbl_file.* #FUN-8A0003 add
 DEFINE g_vbm           RECORD LIKE vbm_file.* #FUN-8A0003 add
 DEFINE g_vbn           RECORD LIKE vbn_file.* #FUN-8A0003 add
 DEFINE g_vbo           RECORD LIKE vbo_file.* #FUN-8A0003 add
 DEFINE g_vay           RECORD LIKE vay_file.*
 DEFINE g_vlz           RECORD LIKE vlz_file.*
 DEFINE g_vla           RECORD LIKE vla_file.*
 DEFINE g_change_lang   LIKE type_file.chr1 
 DEFINE ls_date         STRING
 DEFINE l_flag          LIKE type_file.chr1

 DEFINE   g_cnt         LIKE type_file.num10 
 DEFINE   g_i           LIKE type_file.num5   
 DEFINE   g_chk         LIKE type_file.chr1
 DEFINE   g_msg         LIKE ze_file.ze03 
 DEFINE   g_start_time  DATETIME YEAR TO SECOND
 DEFINE   g_end_time    DATETIME YEAR TO SECOND      #FUN-990012 add
 DEFINE   g_vlz70             LIKE vlz_file.vlz70    #FUN-8A0011 add
 DEFINE   g_sql_limited       STRING                 #FUN-8A0011 add
 DEFINE   g_sql_limited2      STRING                 #TQC-8A0019 add
 DEFINE   g_vlz03_dd          LIKE type_file.dat     #TQC-8A0053 add
 DEFINE   g_vlz03_tt          LIKE type_file.chr5    #TQC-8A0053 add
 DEFINE   g_preddtt           LIKE type_file.chr50   #TQC-920084 ADD
 DEFINE   g_vla02             LIKE vla_file.vla02    #FUN-940030 ADD
 DEFINE   g_wrows             LIKE type_file.num20   #FUN-940030 ADD
 DEFINE   g_erows             LIKE type_file.num20   #FUN-940030 ADD
 DEFINE   g_crows             LIKE type_file.num20   #FUN-940030 ADD
 DEFINE   g_wrows_vav         LIKE type_file.num20   #FUN-B50022 add
 DEFINE   g_erows_vav         LIKE type_file.num20   #FUN-B50022 add
 DEFINE   g_crows_vav         LIKE type_file.num20   #FUN-B50022 add
 DEFINE   g_vlb00             LIKE vlb_file.vlb00    #FUN-940030 ADD
 DEFINE   g_funname           LIKE type_file.chr20
#DEFINE   g_planned_start     DATETIME YEAR TO SECOND #FUN-9B0129 add  #FUN-C30283 mark
#DEFINE   g_db_type           LIKE type_file.chr3     #FUN-9B0129 add  #FUN-C30283 mark
 DEFINE   g_status            LIKE type_file.num5     #TQC-B70094 add
#FUN-B80084 add str-----------
 DEFINE   g_run_str           DATETIME YEAR TO SECOND
 DEFINE   g_run_end           DATETIME YEAR TO SECOND
 DEFINE   g_run_sec           INTERVAL SECOND(5) TO SECOND
#FUN-B80084 add end-----------

 #FUN-960167 ADD --STR---------------------------------------------
  DEFINE  tm1                 RECORD
          flow_datachk        VARCHAR(1)
                              END RECORD
 #FUN-960167 ADD --END--------------------------------------------- 

MAIN
  #DEFINE   l_time       LIKE type_file.chr8 #FUN-890087 mark
   DEFINE   p_row,p_col  LIKE type_file.num5

   #FUN-B50022---mod---str----
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				
   #FUN-B50022---mod---end----

   INITIALIZE g_bgjob_msgfile TO NULL
   INITIALIZE tm.* TO NULL   

   LET g_start_time = CURRENT YEAR TO SECOND

  #LET g_db_type = DB_GET_DATABASE_TYPE() #FUN-9B0129 add  #FUN-C30283 mark

   #FUN-940030 MARK --STR--
   ##FUN-890087 add----str---
   #LET tm.vlb01 = ARG_VAL(1)
   #LET tm.vlb02 = ARG_VAL(2)
   #LET tm.vlb03 = ARG_VAL(3)
   #LET ls_date  = ARG_VAL(4)
   #LET tm.vlb04 = cl_batch_bg_date_convert(ls_date) #執行日期
   #LET ls_date  = ARG_VAL(5)
   #LET tm.vlb07 = cl_batch_bg_date_convert(ls_date) #資料起始日
   #LET ls_date  = ARG_VAL(6)
   #LET tm.vlb08 = cl_batch_bg_date_convert(ls_date) #資料截止日
   ##普通資料
   #LET g_nor_data = ARG_VAL(7)
   ##需求資料             
   #LET g_req_data = ARG_VAL(8)
   ##供給資料             
   #LET g_sup_data = ARG_VAL(9)
   ##產能資料             
   #LET g_cap_data = ARG_VAL(10)     
   ##背景作業             
   #LET g_bgjob    = ARG_VAL(11)
   ##TQC-8A0053---add---str---
   #LET g_vlz70  = ARG_VAL(12)
   #LET g_vlz03_dd = ARG_VAL(13)
   #LET g_vlz03_tt = ARG_VAL(14)
   #FUN-940030  MARK  --END--

   #FUN-940030  ADD  --STR--
    LET tm.vlb00 = ARG_VAL(1)
    LET tm.vlb01 = ARG_VAL(2)
    LET tm.vlb02 = ARG_VAL(3)
    LET tm.vlb03 = ARG_VAL(4)
    LET ls_date  = ARG_VAL(5)
    LET tm.vlb04 = cl_batch_bg_date_convert(ls_date) #執行日期
    LET ls_date  = ARG_VAL(6)
    LET tm.vlb07 = cl_batch_bg_date_convert(ls_date) #資料起始日
    LET ls_date  = ARG_VAL(7)
    LET tm.vlb08 = cl_batch_bg_date_convert(ls_date) #資料截止日
    #普通資料
    LET g_nor_data = ARG_VAL(8)
    #需求資料
    LET g_req_data = ARG_VAL(9)
    #供給資料
    LET g_sup_data = ARG_VAL(10)
    #產能資料
    LET g_cap_data = ARG_VAL(11)
    #背景作業
    LET g_bgjob    = ARG_VAL(12)
    LET g_vlz70  = ARG_VAL(13)
    LET g_vlz03_dd = ARG_VAL(14)
    LET g_vlz03_tt = ARG_VAL(15)

    IF tm.vlb00 = "1" THEN
       LET g_prog="apsp450"
       LET g_vlb00 = '1'
    ELSE
       LET g_prog="apsp500" 
       LET g_vlb00 = '2'  
    END IF
   #FUN-940030   ADD   --END--

   #TQC-8A0053---add---end---
   IF g_bgjob = 'Y' THEN
       #普通資料
       LET tm.vlb11 = g_nor_data.substring(1,1)
       LET tm.vlb12 = g_nor_data.substring(2,2) 
       LET tm.vlb13 = g_nor_data.substring(3,3)
       LET tm.vlb14 = g_nor_data.substring(4,4)
       LET tm.vlb15 = g_nor_data.substring(5,5)
       LET tm.vlb16 = g_nor_data.substring(6,6)
       LET tm.vlb17 = g_nor_data.substring(7,7)
       LET tm.vlb18 = g_nor_data.substring(8,8)
       LET tm.vlb19 = g_nor_data.substring(9,9)
       LET tm.vlb20 = g_nor_data.substring(10,10)
       LET tm.vlb21 = g_nor_data.substring(11,11)
       LET tm.vlb23 = g_nor_data.substring(12,12)
       LET tm.vlb24 = g_nor_data.substring(13,13)
       LET tm.vlb25 = g_nor_data.substring(14,14)
       LET tm.vlb26 = g_nor_data.substring(15,15)
       LET tm.vlb27 = g_nor_data.substring(16,16)
       LET tm.vlb28 = g_nor_data.substring(17,17)
       LET tm.vlb29 = g_nor_data.substring(18,18)
       LET tm.vlb30 = g_nor_data.substring(19,19)
       LET tm.vlb31 = g_nor_data.substring(20,20)
       LET tm.vlb32 = g_nor_data.substring(21,21)
       LET tm.vlb37 = g_nor_data.substring(22,22)
       LET tm.vlb40 = g_nor_data.substring(23,23)
       LET tm.vlb41 = g_nor_data.substring(24,24)
       LET tm.vlb09 = g_nor_data.substring(25,25)
       LET tm.vlb10 = g_nor_data.substring(26,26)
       LET tm.vlb47 = g_nor_data.substring(27,27) #FUN-8A0003 add
       #需求資料             
       LET tm.vlb33 = g_req_data.substring(1,1)
       LET tm.vlb34 = g_req_data.substring(2,2)
       LET tm.vlb36 = g_req_data.substring(3,3)    
       #供給資料             
       LET tm.vlb22 = g_sup_data.substring(1,1)     
       LET tm.vlb35 = g_sup_data.substring(2,2)     
       LET tm.vlb38 = g_sup_data.substring(3,3)     
       LET tm.vlb39 = g_sup_data.substring(4,4)     
       #產能資料             
       LET tm.vlb42 = g_cap_data.substring(1,1)     
       LET tm.vlb43 = g_cap_data.substring(2,2)     
       LET tm.vlb44 = g_cap_data.substring(3,3)     
       LET tm.vlb45 = g_cap_data.substring(4,4)     
       LET tm.vlb46 = g_cap_data.substring(5,5)     
   END IF
   #FUN-890087 add----end---

   IF cl_null(g_bgjob) THEN
       LET g_bgjob = "N"
   END IF

   

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF


   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-890087 mod

   WHILE TRUE
      IF NOT cl_null(g_chk) AND g_chk = 'Y' THEN
          SELECT vld03,vld04 
            INTO tm.vlb07,tm.vlb08
            FROM vld_file
           WHERE vld01 = tm.vlb01
             AND vld02 = tm.vlb02
      ELSE
          LET g_chk = "N" #FUN-890087
      END IF
      IF g_bgjob = "N" OR cl_null(g_bgjob) THEN
         #FUN-890087---mod---str---
         INITIALIZE tm.* TO NULL   
         LET tm.vlb03 = g_user
         LET tm.vlb04 = NULL
         #FUN-890087---mod---end---
         CALL p500_ask()
         IF cl_sure(20,20) THEN
            CALL p500_chk_vlh() #FUN-870071 add
            LET tm.vlb05 = TIME   #起始時間
            LET tm.vlb06 = NULL   #結束時間
            LET tm.vlb48 = g_vlz03_dd      #FUN-940030 ADD
            LET tm.vlb49 = g_vlz03_tt      #FUN-940030 ADD
            LET tm.vlb50 = g_vla02         #FUN-940030 ADD
            LET g_success = 'Y'   
            IF g_prog='apsp500' THEN  #FUN-940030 ADD
               CALL p500_upd_vzy()
               CALL p500_run_apsp702() #FUN-990012 add==>10階段執行前就先起apsp702
               CALL p500_ins_vzv('R')
               CALL p500_ins_vzu()
            END IF                    #FUN-940030 ADD
            CALL p500_get_vlz()  #抓參數
            CALL p500_del()      #刪除 log檔
            CALL p500_get()
            CALL p500_ins_vlb()  #APS資料產生記錄檔
           #CALL p500_out()      #FUN-940030  MARK
           #FUN-940030  ADD  --STR--
            LET g_msg = " apsq450 '", g_vlb00,"' '", tm.vlb01,"' '",tm.vlb02,"'"
            CALL cl_cmdrun_wait(g_msg CLIPPED)
           #FUN-940030  ADD  --END--            

            IF g_prog='apsp500' THEN   #FUN-940030 ADD
               IF g_success = 'Y' THEN
                  CALL p500_upd_config()#更新vla02基本資料最後異動日,vlz03
                  CALL p500_ins_vzv('Y')
                 #CALL p500_run_apsp702() #FUN-870071 add #FUN-990012 mark
                #---FUN-C20113 mark str-----
                #  IF g_chk = 'N' THEN
                #     CALL cl_end2(1) RETURNING l_flag
                # END IF
                #---FUN-C20113 mark end-----
                #FUN-C20113 add str-----
                 CALL cl_err('','aps-812',1)
                 CLOSE WINDOW p500
                 EXIT WHILE
                #FUN-C20113 add end----- 
               ELSE
                  IF g_chk = 'N' THEN
                      CALL cl_end2(2) RETURNING l_flag
                  END IF
               END IF
               IF g_chk = 'N' THEN
                   IF l_flag THEN
                      CONTINUE WHILE
                   ELSE
                      CLOSE WINDOW p500
                      EXIT WHILE
                   END IF
               ELSE
                   IF g_success = 'Y' THEN
                       CALL cl_err('','abm-019',1)
                   END IF
                   CLOSE WINDOW p500
                   EXIT WHILE
               END IF
            END IF   #FUN-940030 ADD
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         CALL p500_chk_vlh() #FUN-870071 add
         LET tm.vlb05 = TIME   #起始時間
         LET tm.vlb06 = NULL   #結束時間
        #FUN-890087---mark----str----
        #SELECT vld03,vld04 
        #  INTO tm.vlb07,tm.vlb08
        #  FROM vld_file
        # WHERE vld01 = tm.vlb01
        #   AND vld02 = tm.vlb02
        #FUN-890087---mark----end----
        IF g_prog='apsp500' THEN  #FUN-940030 ADD
           CALL p500_upd_vzy()
           CALL p500_run_apsp702() #FUN-990012 add==>10階段執行前就先起apsp702
           CALL p500_ins_vzv('R')
           CALL p500_ins_vzu()
        END IF                    #FUN-940030 ADD
         CALL p500_get_vlz()  #抓參數
         CALL p500_del()  #刪除 log檔
         CALL p500_get()
         CALL p500_ins_vlb()
        #CALL p500_out()    #FUN-940030  MARK

         IF g_prog='apsp500' THEN   #FUN-940030 ADD
            CALL p500_upd_config()#更新vla02基本資料最後異動日
            CALL p500_ins_vzv('Y')
           #CALL p500_run_apsp702() #FUN-870071 add #FUN-990012 mark
            CALL cl_batch_bg_javamail(g_success)
            EXIT WHILE
         END IF  #FUN-940030  ADD
      END IF

     #FUN-940030  ADD  --STR--
     #APSP450執行完畢後，立即清除vlh_file，以避免其他user無法進行排程
      IF g_prog='apsp450'  THEN
         DELETE FROM  vlh_file
          WHERE vlh01 = g_plant
      END IF
     #FUN-940030  ADD   --END--

  END WHILE
  CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-890087 mod
END MAIN
#TQC-8A0053---add----str---
FUNCTION p500_def_vlz03()
DEFINE l_date_tmp1      DATETIME YEAR TO MINUTE
DEFINE l_vlz03          LIKE vlz_file.vlz03
DEFINE l_to_char_vlz03  LIKE type_file.chr20
     LET g_vlz03_dd = g_today
     LET g_vlz03_tt = TIME   #TQC-920084 ADD
     LET l_to_char_vlz03 = NULL
     LET l_vlz03 = NULL
     SELECT vlz03 INTO l_to_char_vlz03
       FROM vlz_file
      WHERE vlz01 = tm.vlb01 
        AND vlz02 = tm.vlb02
     IF NOT cl_null(l_to_char_vlz03) THEN
         IF l_to_char_vlz03[1,10] > g_vlz03_dd THEN
             LET g_vlz03_dd = l_to_char_vlz03[1,10]
         END IF
         LET g_preddtt = l_to_char_vlz03           #TQC-920084 ADD
         DISPLAY g_preddtt TO FORMONLY.preddtt
     #    LET g_vlz03_tt = l_to_char_vlz03[12,16]  #TQC-920084 MARK
     #ELSE                                         #TQC-920084 MARK
     #    LET g_vlz03_tt = TIME                    #TQC-920084 MARK
     END IF
END FUNCTION
#TQC-8A0053---add----end---

FUNCTION p500_wc_default()
     CALL p500_def_vlz03() #TQC-8A0053 add
     #---------------------
     #普通資料
     LET tm.vlb11 = 'Y' 
     LET tm.vlb12 = 'Y'
     LET tm.vlb13 = 'Y'
     LET tm.vlb14 = 'Y'
     LET tm.vlb15 = 'Y'
     LET tm.vlb16 = 'Y'
     LET tm.vlb17 = 'Y'
     LET tm.vlb18 = 'Y'
     LET tm.vlb19 = 'Y' 
     LET tm.vlb20 = 'Y'
     LET tm.vlb21 = 'Y'
     LET tm.vlb23 = 'Y'  
     LET tm.vlb24 = 'Y'  
     LET tm.vlb25 = 'Y'  
     LET tm.vlb26 = 'Y'  
     LET tm.vlb27 = 'Y'
     LET tm.vlb28 = 'Y'
     LET tm.vlb29 = 'Y'
     LET tm.vlb30 = 'Y'
     LET tm.vlb31 = 'Y' 
     LET tm.vlb32 = 'Y'
     LET tm.vlb37 = 'Y'
     LET tm.vlb40 = 'Y'
     LET tm.vlb41 = 'Y' 
     LET tm.vlb09 = 'N'
     LET tm.vlb10 = 'Y'
     LET tm.vlb47 = 'Y'
     #需求資料
     LET tm.vlb33 = 'Y'
     LET tm.vlb34 = 'Y' 
     LET tm.vlb36 = 'Y'
     #供給資料   
     LET tm.vlb22 = 'Y'
     LET tm.vlb35 = 'Y'
     LET tm.vlb38 = 'Y' 
     LET tm.vlb39 = 'Y'
     #產能資料
     LET tm.vlb42 = 'Y'
     LET tm.vlb43 = 'Y' 
     LET tm.vlb44 = 'Y'
     LET tm.vlb45 = 'Y'
     LET tm.vlb46 = 'Y' 
     #背景作業   
     LET g_bgjob = 'N'
END FUNCTION
 
FUNCTION p500_ask()
   DEFINE   lc_cmd       LIKE type_file.chr1000
   DEFINE   p_row,p_col  LIKE type_file.num5   
   DEFINE   l_cnt        LIKE type_file.num5   
   DEFINE   l_message    LIKE type_file.chr100     #TQC-8B0029 add
   DEFINE   l_message1   LIKE type_file.chr100     #TQC-8B0029 add
   DEFINE   l_message2   LIKE type_file.chr100     #TQC-8B0029 add
   DEFINE   l_message3   LIKE type_file.chr100     #TQC-8B0029 add
   DEFINE   l_vzv01      LIKE vzv_file.vzv01       #TQC-8B0029 add
   DEFINE   l_vzv02      LIKE vzv_file.vzv02       #TQC-8B0029 add
   #DEFINE   g_vla02      LIKE vla_file.vla02      #TQC-8B0044 add  #FUN-940030 MARK

   LET p_row = 2 LET p_col = 23
   OPEN WINDOW p500 AT p_row,p_col WITH FORM "aps/42f/apsp500"
        ATTRIBUTE (STYLE = g_win_style)

   CALL cl_ui_init()
   CALL cl_opmsg('z')
   #-----拿掉多廠區設定----不拋-----------
   CALL cl_set_comp_visible("vlb09",FALSE)    
   #-----拿掉多廠區設定----不拋-----------

   #FUN-960167 ADD --STR-----------
    IF g_prog='apsp500' THEN
       CALL cl_set_comp_visible("flow_datachk",FALSE)
    END IF
   #FUN-960167 ADD --END-----------


   IF g_chk = 'Y' THEN
       CALL cl_set_comp_entry("vlb01,vlb02",FALSE)
   END IF

WHILE TRUE
   CALL p500_first()

   LET g_vlz70 = NULL                #FUN-8A0011 add
   LET tm1.flow_datachk='N'              #FUN-960167 ADD                
   DISPLAY g_vlz70 TO FORMONLY.vlz70 #FUN-8A0011 add
   INPUT BY NAME 
     tm.vlb01, tm.vlb02, tm.vlb07, tm.vlb08, tm.vlb04,
     g_vlz03_dd,g_vlz03_tt, #TQC-8A0053 add
     tm1.flow_datachk,          #FUN-960167 ADD
     #普通資料
     tm.vlb11, tm.vlb12, tm.vlb13, tm.vlb14, tm.vlb15, 
     tm.vlb16, tm.vlb17, tm.vlb18, tm.vlb19, tm.vlb20,
     tm.vlb21, tm.vlb23, tm.vlb24, tm.vlb25, tm.vlb26, 
     tm.vlb27, tm.vlb28, tm.vlb29, tm.vlb30, tm.vlb31, 
     tm.vlb32, tm.vlb37, tm.vlb40, tm.vlb41, tm.vlb09,
     tm.vlb10, tm.vlb47, #FUN-8A0003 add vlb47
     #需求資料
     tm.vlb33, tm.vlb34, tm.vlb36,
     #供給資料
     tm.vlb22, tm.vlb35, tm.vlb38,tm.vlb39,
     #產能資料
     tm.vlb42, tm.vlb43, tm.vlb44,tm.vlb45,tm.vlb46,
     #FUN-890087 add---str--
     #背景作業
     g_bgjob    
     #FUN-890087 add---end--
     WITHOUT DEFAULTS

      ON ACTION locale
         LET g_change_lang = TRUE        
         EXIT INPUT

      AFTER FIELD vlb01
         IF NOT cl_null(tm.vlb01) THEN
             #TQC-8B0029--mod---str--
             #(1)apsp500執行時,需增加check APS版本及儲存版本在vzy_file的vzy10是否等於Y or L,等於Y or 'L' 情況下才允許執行
             SELECT COUNT(*) INTO l_cnt
               FROM vzy_file
              WHERE vzy00 = g_plant
                AND vzy01 = tm.vlb01
                AND (vzy10 = 'Y' OR vzy10 = 'L') #Y:建立完成 L:刪除失敗
             IF l_cnt =0 THEN
                 #此版本資料庫未建立,或已資料庫已刪除,不可使用!
                 CALL cl_err(tm.vlb01,'aps-030',1)
                 NEXT FIELD vlb01
             END IF
             #(2) check 存在MDS沖銷記錄檔
             SELECT count(*) INTO l_cnt 
               FROM vld_file
              WHERE vld01 = tm.vlb01
             IF l_cnt <=0 THEN
                #無此筆MDS沖銷記錄檔,請重新輸入!
                #CALL cl_err('','aic-004',1)
                 CALL cl_err('','aps-032',1)
                 NEXT FIELD vlb01
             END IF
            #FUN-B10015(2)----mark---str---
            #不需要做此段控管
            ##(3)需檢查vzv_file,若vzv_file有存在相同的APS版本,當vzv04='30',vzv06='Y',vzv07='Y'時,
            ##   且vzv04找不到40的資料時,則需跳出警示訊息告知使用者"尚有APS版本:?? 儲存版本:?? 
            ##   還未進行規劃確認,是否確定覆蓋此版本資料?" 
            #DECLARE p500_sel_vzv CURSOR FOR
            # SELECT vzv01,vzv02 
            #   FROM vzv_file
            #  WHERE vzv04 = '30'
            #    AND vzv06 = 'Y'
            #    AND vzv07 = 'Y'
            #    AND vzv01 = tm.vlb01
            # ORDER BY vzv02

            # FOREACH p500_sel_vzv INTO l_vzv01,l_vzv02
            #    SELECT COUNT(*) INTO l_cnt
            #      FROM vzv_file
            #     WHERE vzv04 = '40'
            #       AND vzv01 = l_vzv01
            #       AND vzv02 = l_vzv02
            #    IF l_cnt <=0 THEN
            #        #APS版本:l_vzv01 儲存版本:l_vzv02 還未進行規劃確認,是否確定覆蓋此版本資料?
            #        CALL cl_get_feldname('vzv01',g_lang) RETURNING l_message1
            #        CALL cl_get_feldname('vzv02',g_lang) RETURNING l_message2
            #        CALL cl_getmsg('aps-031',g_lang) RETURNING l_message3
            #        LET l_message = l_message1 CLIPPED,':',l_vzv01,' ',l_message2 CLIPPED,':',l_vzv02,' ',l_message3
            #        IF NOT cl_confirm(l_message) THEN
            #            NEXT FIELD vlb01
            #        END IF
            #    END IF

            # END FOREACH
            ##TQC-8B0029--add---str--
            #FUN-B10015(2)----mark---end---
             #TQC-8B0044--add---str--
              SELECT vla02 INTO g_vla02
                FROM vla_file
               WHERE vla01 = tm.vlb01
              IF SQLCA.sqlcode = 100 THEN
                  LET g_vla02 = NULL
              END IF
              DISPLAY g_vla02 TO FORMONLY.vla02
             #TQC-8B0044--add---end--
         END IF
      AFTER FIELD vlb02
         IF NOT cl_null(tm.vlb02) THEN
             IF NOT cl_null(tm.vlb01) THEN
                 CALL p500_first()
                 SELECT count(*) INTO l_cnt 
                   FROM vld_file
                  WHERE vld01 = tm.vlb01
                    AND vld02 = tm.vlb02
                 IF l_cnt <=0 THEN
                    #無此筆MDS沖銷記錄檔,請重新輸入!
                    #CALL cl_err('','aic-004',1) #TQC-8B0029 mark
                     CALL cl_err('','aps-032',1) #TQC-8B0029 mod
                     NEXT FIELD vlb02
                 END IF
                 SELECT vld03,vld04       
                   INTO tm.vlb07,tm.vlb08 
                   FROM vld_file
                  WHERE vld01 = tm.vlb01
                    AND vld02 = tm.vlb02
                 DISPLAY BY NAME tm.vlb07,tm.vlb08 
                 #FUN-8A0011---add---str---
                 SELECT vlz70 INTO g_vlz70
                   FROM vlz_file
                  WHERE vlz01 = tm.vlb01
                    AND vlz02 = tm.vlb02
                 DISPLAY g_vlz70 TO FORMONLY.vlz70
                 #FUN-8A0011---add---end---
              END IF
         END IF

      BEFORE FIELD vlb04
         IF cl_null(tm.vlb04) THEN
             LET tm.vlb04 = g_today
             DISPLAY BY NAME tm.vlb04
         END IF

      AFTER FIELD vlb07
         IF cl_null(tm.vlb07) THEN
            NEXT FIELD vlb07
         END IF
      AFTER FIELD vlb08
         IF NOT cl_null(tm.vlb08) THEN
             IF NOT cl_null(tm.vlb07) THEN
                 IF tm.vlb08 < tm.vlb07 THEN
                     CALL cl_err('','agl-031',1)
                     LET tm.vlb08 = NULL
                     DISPLAY BY NAME tm.vlb08
                     NEXT FIELD vlb07
                 END IF
             END IF
         END IF
     #TQC-8A0053----add----str---
     AFTER FIELD g_vlz03_dd
         IF g_vlz03_dd < g_today THEN
             #規劃開始時間小於今天,是否繼續執行?
             IF NOT cl_confirm('aps-029') THEN
                 NEXT FIELD g_vlz03_dd
             END IF
         END IF
     AFTER FIELD g_vlz03_tt
         #時間允許輸入00:00~23:59
         IF g_vlz03_tt[1,2] <  '00' OR
            g_vlz03_tt[1,2] >= '24' OR
            g_vlz03_tt[4,5] <  '00' OR
            g_vlz03_tt[4,5] >= '60' THEN
            CALL cl_err(g_vlz03_tt,'asf-807',1)
            NEXT FIELD g_vlz03_tt
         END IF
     #TQC-8A0053----add----end---
     AFTER INPUT 
         #FUN-8A0011---add---str---
         SELECT vlz70 INTO g_vlz70
           FROM vlz_file
          WHERE vlz01 = tm.vlb01
            AND vlz02 = tm.vlb02
         DISPLAY g_vlz70 TO FORMONLY.vlz70
         #FUN-8A0011---add---end---

      ON ACTION controlp
         CASE
            WHEN INFIELD(vlb01)
               CALL cl_init_qry_var()
              #display 'g_plant =',g_plant  #CHI-A70049 mark
              #LET g_qryparam.form = "q_vld01" #TQC-8B0029 mark
               LET g_qryparam.form = "q_vld03" #TQC-8B0029 mod
               LET g_qryparam.default1 = tm.vlb01
               LET g_qryparam.arg1 = g_plant   #TQC-8B0029 add
               CALL cl_create_qry() RETURNING tm.vlb01,tm.vlb02
               DISPLAY BY NAME tm.vlb01,tm.vlb02
               SELECT vld03,vld04       
                 INTO tm.vlb07,tm.vlb08 
                 FROM vld_file
                WHERE vld01 = tm.vlb01
                  AND vld02 = tm.vlb02
               DISPLAY BY NAME tm.vlb07,tm.vlb08 
               CALL p500_first()
              #NEXT FIELD vlb02 #TQC-8B0029 mark
               NEXT FIELD vlb01 #TQC-8B0029 mod
            OTHERWISE
               EXIT CASE
         END CASE
      ON ACTION select_all
         CALL p500_select_all()
      ON ACTION un_select_all
         CALL p500_un_select_all()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      BEFORE INPUT
         CALL cl_qbe_init()

      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION qbe_save
         CALL cl_qbe_save()

   END INPUT
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      IF g_chk = 'N' THEN
          LET INT_FLAG = 0
      END IF
      CLOSE WINDOW p500
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
      
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "apsp500"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('apsp500','9031',1)
      ELSE
           #FUN-890087---mod----str----
           #普通資料
           LET g_nor_data = tm.vlb11,tm.vlb12,tm.vlb13,tm.vlb14,tm.vlb15,
                            tm.vlb16,tm.vlb17,tm.vlb18,tm.vlb19,tm.vlb20,
                            tm.vlb21,         tm.vlb23,tm.vlb24,tm.vlb25,
                            tm.vlb26,tm.vlb27,tm.vlb28,tm.vlb29,tm.vlb30,
                            tm.vlb31,tm.vlb32,tm.vlb37,tm.vlb40,tm.vlb41,
                            tm.vlb09,tm.vlb10,tm.vlb47 #FUN-8A0003 add vlb47
           #需求資料             
           LET g_req_data = tm.vlb33,tm.vlb34,tm.vlb36
           #供給資料             
           LET g_sup_data = tm.vlb22,tm.vlb35,tm.vlb38,tm.vlb39
           #產能資料             
           LET g_cap_data = tm.vlb42,tm.vlb43,tm.vlb44,tm.vlb45,tm.vlb46

           LET lc_cmd=lc_cmd CLIPPED,
                    " '",g_vlb00 CLIPPED,"'",  #FUN-940030 ADD 
                    " '",tm.vlb01 CLIPPED,"'",
                    " '",tm.vlb02 CLIPPED,"'",
                    " '",tm.vlb03 CLIPPED,"'",
                    " '",tm.vlb04 CLIPPED,"'",
                    " '",tm.vlb07 CLIPPED,"'",
                    " '",tm.vlb08 CLIPPED,"'",
                    #普通資料
                    " '",g_nor_data CLIPPED,"'",
                    #需求資料
                    " '",g_req_data CLIPPED,"'",
                    #供給資料
                    " '",g_sup_data CLIPPED,"'",
                    #產能資料
                    " '",g_cap_data CLIPPED,"'",
                    #背景作業
                    " '",g_bgjob CLIPPED,"'",
                    #FUN-890087---mod----end----
                    #TQC-8A0053---add---str---
                    " '",g_vlz70 CLIPPED,"'",
                    " '",g_vlz03_dd CLIPPED,"'",
                    " '",g_vlz03_tt CLIPPED,"'"
                    #TQC-8A0053---add---end---
         CALL cl_cmdat('apsp500',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p500
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE

END FUNCTION

FUNCTION p500_declare()		
   DEFINE l_sql		STRING    

   #-->系統參數(92)個      #TQC-860041 mod #TQC-8C0014 mod  #FUN-930127 mod  #FUN-930161 MOD
   LET l_sql="INSERT INTO vzz_file VALUES (?,?,?,?,?,?,?,?,?,?,", 
                                          "?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?,?,?,?,?,?,?,", #TQC-860041 mod
                                          "?,?,?,?,?,?,?,?,?,?,?,?,",  #TQC-860041 mod #TQC-8C0014 mod #FUN-910005 ADD 1 ?  #FUN-930127 mod
                                          "?,?,?,?,?,?,?,?,?,?) " #FUN-930161 ADD 
   PREPARE p500_p_ins_vzz FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vzz',STATUS,1) END IF
   DECLARE p500_c_ins_vzz CURSOR WITH HOLD FOR p500_p_ins_vzz
   IF STATUS THEN CALL cl_err('dec ins_vzz',STATUS,1) END IF

   #-->多廠區設定檔(22)個   #FUN-940030 MOD
   LET l_sql="INSERT INTO vzy_file VALUES (?,?,?,?,?,?,?,?,?,?",
                                          "?,?,?,?,?,?,?,?,?,?",
                                          "?,? ) "                            
    
   PREPARE p500_p_ins_vzy FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vzy',STATUS,1) END IF
   DECLARE p500_c_ins_vzy CURSOR WITH HOLD FOR p500_p_ins_vzy
   IF STATUS THEN CALL cl_err('dec ins_vzy',STATUS,1) END IF

   #FUN-8C0140  MARK  --STR--
   ##-->資料庫參數設定(6)個 
   #LET l_sql="INSERT INTO vzt_file VALUES (?,?,?,?,?,?)"  
   #
   #PREPARE p500_p_ins_vzt FROM l_sql
   #IF STATUS THEN CALL cl_err('pre ins_vzt',STATUS,1) END IF
   #DECLARE p500_c_ins_vzt CURSOR WITH HOLD FOR p500_p_ins_vzt
   #IF STATUS THEN CALL cl_err('dec ins_vzt',STATUS,1) END IF
   #FUN-8C0140  MARK  --END--

   #-->工作模式(16)個 #FUN-B50022
   LET l_sql="INSERT INTO vaa_file VALUES (?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?)" #FUN-B50022 mod
   PREPARE p500_p_ins_vaa FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vaa',STATUS,1) END IF
   DECLARE p500_c_ins_vaa CURSOR WITH HOLD FOR p500_p_ins_vaa
   IF STATUS THEN CALL cl_err('dec ins_vaa',STATUS,1) END IF

   #-->日行事曆(13)個 #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vab_file VALUES (?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?) " #FUN-B50022 mod
   PREPARE p500_p_ins_vab FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vab',STATUS,1) END IF
   DECLARE p500_c_ins_vab CURSOR WITH HOLD FOR p500_p_ins_vab
   IF STATUS THEN CALL cl_err('dec ins_vab',STATUS,1) END IF

   #-->週行事曆(18)個  #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vac_file VALUES (?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?) " #FUN-B50022 mod
   PREPARE p500_p_ins_vac FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vac',STATUS,1) END IF
   DECLARE p500_c_ins_vac CURSOR WITH HOLD FOR p500_p_ins_vac
   IF STATUS THEN CALL cl_err('dec ins_vac',STATUS,1) END IF

   #-->外包商資料(13)個  #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vbh_file VALUES (?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?) " #FUN-930161 ADD #FUN-B50022 mod
   PREPARE p500_p_ins_vbh FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vbh',STATUS,1) END IF
   DECLARE p500_c_ins_vbh CURSOR WITH HOLD FOR p500_p_ins_vbh
   IF STATUS THEN CALL cl_err('dec ins_vbh',STATUS,1) END IF

   #-->工作站(15)個  #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vbi_file VALUES (?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?,?) " #FUN-930161 ADD #FUN-B50022 mod
   PREPARE p500_p_ins_vbi  FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vbi',STATUS,1) END IF
   DECLARE p500_c_ins_vbi CURSOR WITH HOLD FOR p500_p_ins_vbi
   IF STATUS THEN CALL cl_err('dec ins_vbi',STATUS,1) END IF

   #-->設備(24)個   #MOD-870103 mod  #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vad_file VALUES (?,?,?,?,?,", #MOD-870103 mod
                                          "?,?,?,?,?,", #MOD-870103 mod
                                          "?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?) " #FUN-930161 ADD #FUN-B50022 mod
   PREPARE p500_p_ins_vad  FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vad',STATUS,1) END IF
   DECLARE p500_c_ins_vad  CURSOR WITH HOLD FOR p500_p_ins_vad
   IF STATUS THEN CALL cl_err('dec ins_vad',STATUS,1) END IF

   #-->設備群組(12)個  #FUN-930181 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vae_file VALUES (?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?) " #FUN-930161 ADD #FUN-B50022 mod
   PREPARE p500_p_ins_vae FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vae',STATUS,1) END IF
   DECLARE p500_c_ins_vae CURSOR WITH HOLD FOR p500_p_ins_vae
   IF STATUS THEN CALL cl_err('dec ins_vae',STATUS,1) END IF

   #-->倉庫(17)個     #TQC-860041 mod  #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vaf_file VALUES (?,?,?,?,?,", #TQC-860041 mod  #FUN-910005 ADD 1 ?
                                          "?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?) " #FUN-930161 ADD  #FUN-B50022 mod

   PREPARE p500_p_ins_vaf FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vaf',STATUS,1) END IF
   DECLARE p500_c_ins_vaf CURSOR WITH HOLD FOR p500_p_ins_vaf
   IF STATUS THEN CALL cl_err('dec ins_vaf',STATUS,1) END IF

   #-->儲位(16)個  #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vag_file VALUES (?,?,?,?,?,", #FUN-910005 ADD 1 ?
                                          "?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?) " #FUN-930161 ADD #FUN-B50022 mod

   PREPARE p500_p_ins_vag FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vag',STATUS,1) END IF
   DECLARE p500_c_ins_vag CURSOR WITH HOLD FOR p500_p_ins_vag
   IF STATUS THEN CALL cl_err('dec ins_vag',STATUS,1) END IF

   #-->供給法則(15)個  #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vah_file VALUES (?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?,?) " #FUN-930161 ADD  #FUN-B50022 mod

   PREPARE p500_p_ins_vah FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vah',STATUS,1) END IF
   DECLARE p500_c_ins_vah CURSOR WITH HOLD FOR p500_p_ins_vah
   IF STATUS THEN CALL cl_err('dec ins_vah',STATUS,1) END IF

   #-->料件主檔(78)個  #FUN-930127 MOD   #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vai_file VALUES (?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?,?,?,?,?,?,?,", 
                                          "?,?,?,?,?,?,?,?,?,?,", 
                                          "?,?,?,?,?,?,?,?,?,?,", 
                                          "?,?,?,?,?,?,?,?) " #FUN-930161 ADD #FUN-B50022 mod

   PREPARE p500_p_ins_vai FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vai',STATUS,1) END IF
   DECLARE p500_c_ins_vai CURSOR WITH HOLD FOR p500_p_ins_vai
   IF STATUS THEN CALL cl_err('dec ins_vai',STATUS,1) END IF

   #-->實體庫存(15)個  #FUN-930161 MOD  #FUN-B50022 mod
   LET l_sql="INSERT INTO vaj_file VALUES (?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?,?) " #FUN-930161 ADD   #FUN-B50022 mod

   PREPARE p500_p_ins_vaj FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vaj',STATUS,1) END IF
   DECLARE p500_c_ins_vaj CURSOR WITH HOLD FOR p500_p_ins_vaj
   IF STATUS THEN CALL cl_err('dec ins_vaj',STATUS,1) END IF

   #-->料件供應商(30)個  #FUN-930149 ADD   #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vak_file VALUES (?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?,?,?,?,?,?,?,",   #FUN-930149 ADD 
                                          "?,?,?,?,?,?,?,?,?,?,?,?) " #FUN-930161 ADD #FUN-B50022 mod #FUN-B90040 #FUN-BA0035 add
   PREPARE p500_p_ins_vak FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vak',STATUS,1) END IF
   DECLARE p500_c_ins_vak CURSOR WITH HOLD FOR p500_p_ins_vak
   IF STATUS THEN CALL cl_err('dec ins_vak',STATUS,1) END IF

   #-->品項分配法則(15)個  #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO val_file VALUES (?,?,?,?,?,",   #FUN-910005 ADD 1 ?
                                          "?,?,?,?,?,",
                                          "?,?,?,?,?) " #FUN-930161 ADD #FUN-B50022 mod
   PREPARE p500_p_ins_val FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_val',STATUS,1) END IF
   DECLARE p500_c_ins_val CURSOR WITH HOLD FOR p500_p_ins_val
   IF STATUS THEN CALL cl_err('dec ins_val',STATUS,1) END IF

   #-->料件途程(19)個  #FUN-930161  MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vam_file VALUES (?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?) " #FUN-930161 ADD #FUN-B50022 mod
   PREPARE p500_p_ins_vam FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vam',STATUS,1) END IF
   DECLARE p500_c_ins_vam CURSOR WITH HOLD FOR p500_p_ins_vam
   IF STATUS THEN CALL cl_err('dec ins_vam',STATUS,1) END IF

   #-->途程制程(41)個 #FUN-B50022 mod
   LET l_sql="INSERT INTO van_file VALUES (?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?,?,?,?,?,?,?,",
                                          "?) " #FUN-930161 ADD #FUN-B50022 mod

   PREPARE p500_p_ins_van FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_van',STATUS,1) END IF
   DECLARE p500_c_ins_van CURSOR WITH HOLD FOR p500_p_ins_van
   IF STATUS THEN CALL cl_err('dec ins_van',STATUS,1) END IF

   #-->物料清單(31)個  #TQC-930117   #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vao_file VALUES (?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?,?,?,?,?,?,?,",  #TQC-930117
                                          "?,?,?,?,?,?,?,?,?,?,",
                                          "?) " #FUN-930161 ADD #FUN-B50022 mod

   PREPARE p500_p_ins_vao FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vao',STATUS,1) END IF
   DECLARE p500_c_ins_vao CURSOR WITH HOLD FOR p500_p_ins_vao
   IF STATUS THEN CALL cl_err('dec ins_vao',STATUS,1) END IF

   #-->投料點(15)個  #FUN-930161  MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vap_file VALUES (?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?,?) " #FUN-930161 ADD #FUN-B50022 mod

   PREPARE p500_p_ins_vap FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vap',STATUS,1) END IF
   DECLARE p500_c_ins_vap CURSOR WITH HOLD FOR p500_p_ins_vap
   IF STATUS THEN CALL cl_err('dec ins_vap',STATUS,1) END IF

   #-->單品取替代(21)個  #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vaq_file VALUES (?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?) " #FUN-930161 ADD #FUN-B50022 mod

   PREPARE p500_p_ins_vaq FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vaq',STATUS,1) END IF
   DECLARE p500_c_ins_vaq CURSOR WITH HOLD FOR p500_p_ins_vaq
   IF STATUS THEN CALL cl_err('dec ins_vaq',STATUS,1) END IF

   #-->萬用取替代(20)個   #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO var_file VALUES (?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?,?)" #FUN-B50022 mod

   PREPARE p500_p_ins_var FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_var',STATUS,1) END IF
   DECLARE p500_c_ins_var CURSOR WITH HOLD FOR p500_p_ins_var
   IF STATUS THEN CALL cl_err('dec ins_var',STATUS,1) END IF

   #-->顧客(14)個  #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vas_file VALUES (?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?) " #FUN-930161 ADD #FUN-B50022 mod

   PREPARE p500_p_ins_vas FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vas',STATUS,1) END IF
   DECLARE p500_c_ins_vas CURSOR WITH HOLD FOR p500_p_ins_vas
   IF STATUS THEN CALL cl_err('dec ins_vas',STATUS,1) END IF

   #-->預測群組沖銷(12)個  #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vat_file VALUES (?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?) " #FUN-930161 ADD #FUN-B50022 mod

   PREPARE p500_p_ins_vat FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vat',STATUS,1) END IF
   DECLARE p500_c_ins_vat CURSOR WITH HOLD FOR p500_p_ins_vat
   IF STATUS THEN CALL cl_err('dec ins_vat',STATUS,1) END IF

   #-->需求訂單(34)個  #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vau_file VALUES (?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?) " #FUN-B50022 mod

   PREPARE p500_p_ins_vau FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vau',STATUS,1) END IF
   DECLARE p500_c_ins_vau CURSOR WITH HOLD FOR p500_p_ins_vau
   IF STATUS THEN CALL cl_err('dec ins_vau',STATUS,1) END IF

   #-->需求訂單選配(14)個  #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vav_file VALUES (?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?) " #FUN-B50022 mod

   PREPARE p500_p_ins_vav FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vav',STATUS,1) END IF
   DECLARE p500_c_ins_vav CURSOR WITH HOLD FOR p500_p_ins_vav
   IF STATUS THEN CALL cl_err('dec ins_vav',STATUS,1) END IF

   #-->工單檔(37)個   #FUN-930127 mod   #FUN-930161 MOD  #FUN-940090 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vaw_file VALUES (?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?,?,?,?)" #FUN-B50022 mod

   PREPARE p500_p_ins_vaw FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vaw',STATUS,1) END IF
   DECLARE p500_c_ins_vaw CURSOR WITH HOLD FOR p500_p_ins_vaw
   IF STATUS THEN CALL cl_err('dec ins_vaw',STATUS,1) END IF

   #-->工單備料(25)個  #FUN-930127 mod  #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vax_file VALUES (?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?,? ) " #FUN-930161 ADD  #FUN-B50022 mod

   PREPARE p500_p_ins_vax FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vax',STATUS,1) END IF
   DECLARE p500_c_ins_vax CURSOR WITH HOLD FOR p500_p_ins_vax
   IF STATUS THEN CALL cl_err('dec ins_vax',STATUS,1) END IF

   #-->現場報工(30)個   #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vay_file VALUES (?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?,?,?,?,?,?,?) " #FUN-930161 ADD #FUN-B50022 #FUN-B90040

   PREPARE p500_p_ins_vay FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vay',STATUS,1) END IF
   DECLARE p500_c_ins_vay CURSOR WITH HOLD FOR p500_p_ins_vay
   IF STATUS THEN CALL cl_err('dec ins_vay',STATUS,1) END IF

   #-->採購令檔(36)個  #FUN-930086 ADD   #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vaz_file VALUES (?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?,?,?)" #FUN-B50022 mod

   PREPARE p500_p_ins_vaz FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vaz',STATUS,1) END IF
   DECLARE p500_c_ins_vaz CURSOR WITH HOLD FOR p500_p_ins_vaz
   IF STATUS THEN CALL cl_err('dec ins_vaz',STATUS,1) END IF

   #-->存貨預配記錄(20)個  #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vba_file VALUES (?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?,?) " #FUN-B50022 mod

   PREPARE p500_p_ins_vba FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vba',STATUS,1) END IF
   DECLARE p500_c_ins_vba CURSOR WITH HOLD FOR p500_p_ins_vba
   IF STATUS THEN CALL cl_err('dec ins_vba',STATUS,1) END IF

   #-->單據追溯(19)個   #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vbb_file VALUES (?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?) " #FUN-930161 ADD #FUN-B50022 mod
  
   PREPARE p500_p_ins_vbb FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vbb',STATUS,1) END IF
   DECLARE p500_c_ins_vbb CURSOR WITH HOLD FOR p500_p_ins_vbb
   IF STATUS THEN CALL cl_err('dec ins_vbb',STATUS,1) END IF

   #-->加班資訊(20)個      #TQC-860041  #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vbc_file VALUES (?,?,?,?,?,?,?,?,?,?,", #TQC-860041     
                                          "?,?,?,?,?,?,?,?,?,?) " #FUN-930161 ADD #FUN-B50022 mod

   PREPARE p500_p_ins_vbc FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vbc',STATUS,1) END IF
   DECLARE p500_c_ins_vbc CURSOR WITH HOLD FOR p500_p_ins_vbc
   IF STATUS THEN CALL cl_err('dec ins_vbc',STATUS,1) END IF

   #-->鎖定製程時間(21)個  #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vbd_file VALUES (?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?,?,?,?,?,?,?,",
                                          "?) " #FUN-930161 ADD #FUN-B50022 mod

   PREPARE p500_p_ins_vbd FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vbd',STATUS,1) END IF
   DECLARE p500_c_ins_vbd CURSOR WITH HOLD FOR p500_p_ins_vbd
   IF STATUS THEN CALL cl_err('dec ins_vbd',STATUS,1) END IF

   #-->鎖定使用設備(18)個  #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vbe_file VALUES (?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?) " #FUN-930161 ADD #FUN-B50022 mod
   PREPARE p500_p_ins_vbe FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vbe',STATUS,1) END IF
   DECLARE p500_c_ins_vbe CURSOR WITH HOLD FOR p500_p_ins_vbe
   IF STATUS THEN CALL cl_err('dec ins_vbe',STATUS,1) END IF

   #-->製令外包(17)個  #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vbf_file VALUES (?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?) " #FUN-930161 ADD #FUN-B50022 
   PREPARE p500_p_ins_vbf FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vbf',STATUS,1) END IF
   DECLARE p500_c_ins_vbf CURSOR WITH HOLD FOR p500_p_ins_vbf
   IF STATUS THEN CALL cl_err('dec ins_vbf',STATUS,1) END IF

   #-->製程外包(23)個  #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vbg_file VALUES (?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?) " #FUN-930161 ADD #FUN-B50022 mod

   PREPARE p500_p_ins_vbg FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vbg',STATUS,1) END IF
   DECLARE p500_c_ins_vbg CURSOR WITH HOLD FOR p500_p_ins_vbg
   IF STATUS THEN CALL cl_err('dec ins_vbg',STATUS,1) END IF

   #FUN-8A0003---add----str---
   #-->工模具主檔(24)個  #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vbj_file VALUES (?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?,?,?,?,?,?,?,",
                                          "?,?,?,?) " #FUN-930161 ADD  #FUN-B50022 mod

   PREPARE p500_p_ins_vbj FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vbj',STATUS,1) END IF
   DECLARE p500_c_ins_vbj CURSOR WITH HOLD FOR p500_p_ins_vbj
   IF STATUS THEN CALL cl_err('dec ins_vbj',STATUS,1) END IF

   #-->工模具群組主檔(13)個   #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vbk_file VALUES (?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?) " #FUN-930161 ADD #FUN-B50022 mod

   PREPARE p500_p_ins_vbk FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vbk',STATUS,1) END IF
   DECLARE p500_c_ins_vbk CURSOR WITH HOLD FOR p500_p_ins_vbk
   IF STATUS THEN CALL cl_err('dec ins_vbk',STATUS,1) END IF

   #-->工模具群組明細檔(12)個  #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vbl_file VALUES (?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?) " #FUN-930161 ADD #FUN-B50022 mod
   PREPARE p500_p_ins_vbl FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vbl',STATUS,1) END IF
   DECLARE p500_c_ins_vbl CURSOR WITH HOLD FOR p500_p_ins_vbl
   IF STATUS THEN CALL cl_err('dec ins_vbl',STATUS,1) END IF

   #-->途程製程指定工具(16)個 #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vbm_file VALUES (?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?) " #FUN-930161 ADD #FUN-B50022 mod

   PREPARE p500_p_ins_vbm FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vbm',STATUS,1) END IF
   DECLARE p500_c_ins_vbm CURSOR WITH HOLD FOR p500_p_ins_vbm
   IF STATUS THEN CALL cl_err('dec ins_vbm',STATUS,1) END IF

   #-->工模具保修明細檔(13)個  #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vbn_file VALUES (?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?) " #FUN-930161 ADD #FUN-B50022 mod

   PREPARE p500_p_ins_vbn FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vbn',STATUS,1) END IF
   DECLARE p500_c_ins_vbn CURSOR WITH HOLD FOR p500_p_ins_vbn
   IF STATUS THEN CALL cl_err('dec ins_vbn',STATUS,1) END IF

   #-->工模具大類主檔(14)個  #FUN-930161 MOD #FUN-B50022 mod
   LET l_sql="INSERT INTO vbo_file VALUES (?,?,?,?,?,",
                                          "?,?,?,?,?,",
                                          "?,?,?,?) " #FUN-930161 ADD #FUN-B50022 mod
   PREPARE p500_p_ins_vbo FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_vbo',STATUS,1) END IF
   DECLARE p500_c_ins_vbo CURSOR WITH HOLD FOR p500_p_ins_vbo
   IF STATUS THEN CALL cl_err('dec ins_vbo',STATUS,1) END IF
   #FUN-8A0003---add----end---

END FUNCTION
 
FUNCTION p500_get()
 #FUN-C30283 mark str---
 ##FUN-9B0129 ---add----str----
 #DEFINE l_tmp1           LIKE type_file.chr20    
 #DEFINE l_tmp2           LIKE type_file.chr20   
 #   LET l_tmp1 = NULL
 #   LET l_tmp2 = NULL
 #   LET l_tmp1 = g_vlz03_dd USING 'YYYY-MM-DD'
 #   LET l_tmp2 = l_tmp1 CLIPPED,' ',g_vlz03_tt CLIPPED,':00'
 #   LET g_planned_start = l_tmp2 CLIPPED 
 # #FUN-9B0129 ---add----end----
 #FUN-C30283 mark end---
   CALL p500_declare()	       #DECLARE Insert Cursor
   #==>OPEN Cursor
   OPEN p500_c_ins_vzz 
   OPEN p500_c_ins_vzy
   #OPEN p500_c_ins_vzt   #FUN-8C0140  MARK
   OPEN p500_c_ins_vaa
   OPEN p500_c_ins_vab
   OPEN p500_c_ins_vac
   OPEN p500_c_ins_vbh
   OPEN p500_c_ins_vbi
   OPEN p500_c_ins_vad
   OPEN p500_c_ins_vae
   OPEN p500_c_ins_vaf
   OPEN p500_c_ins_vag
   OPEN p500_c_ins_vah
   OPEN p500_c_ins_vai
   OPEN p500_c_ins_vaj
   OPEN p500_c_ins_vak
   OPEN p500_c_ins_val
   OPEN p500_c_ins_vam
   OPEN p500_c_ins_van
   OPEN p500_c_ins_vao
   OPEN p500_c_ins_vap
   OPEN p500_c_ins_vaq
   OPEN p500_c_ins_var
   OPEN p500_c_ins_vas
   OPEN p500_c_ins_vat
   OPEN p500_c_ins_vau
   OPEN p500_c_ins_vav
   OPEN p500_c_ins_vaw
   OPEN p500_c_ins_vax
   OPEN p500_c_ins_vay
   OPEN p500_c_ins_vaz
   OPEN p500_c_ins_vba
   OPEN p500_c_ins_vbb
   OPEN p500_c_ins_vbc
   OPEN p500_c_ins_vbd
   OPEN p500_c_ins_vbe
   OPEN p500_c_ins_vbf
   OPEN p500_c_ins_vbg
   #FUN-8A0003---add---str---
   OPEN p500_c_ins_vbj
   OPEN p500_c_ins_vbk
   OPEN p500_c_ins_vbl
   OPEN p500_c_ins_vbm
   OPEN p500_c_ins_vbn
   OPEN p500_c_ins_vbo
   #FUN-8A0003---add---end---

   #FUN-9B0003---add----str---
   #(1)實體庫存
   LET g_funname = '' 
   LET g_wrows =0    
   LET g_erows =0   
   IF g_bgjob = 'N' THEN 
        MESSAGE 'Process vaj ...'
        CALL ui.interface.refresh()
   END IF
   CALL p500_vaj() #--ok
   
   #(2)採購令
   LET g_wrows =0   
   LET g_erows =0  
   IF g_bgjob = 'N' THEN 
        MESSAGE 'Process vaz_1 ...'
        CALL ui.interface.refresh()
   END IF
   LET g_funname = 'p500_vaz_1' #FUN-940030 ADD
   CALL p500_vaz_1() #採購令--請購
   
   LET g_wrows =0    
   LET g_erows =0   
   IF g_bgjob = 'N' THEN 
        MESSAGE 'Process vaz_2 ...'
        CALL ui.interface.refresh()
   END IF
   LET g_funname = 'p500_vaz_2' 
   CALL p500_vaz_2() #採購令--採購
   
   #(3)工單
   LET g_funname = '' 
   LET g_wrows =0    
   LET g_erows =0   
   IF g_bgjob = 'N' THEN 
        MESSAGE 'Process vaw ...'
        CALL ui.interface.refresh()
   END IF
   CALL p500_vaw() 
   
   #(4)製令領料
   LET g_funname = ''
   LET g_wrows =0    
   LET g_erows =0    
   IF g_bgjob = 'N' THEN 
        MESSAGE 'Process vax ...'
        CALL ui.interface.refresh()
   END IF
   CALL p500_vax() 
   
   #(5)途程製程
   LET g_wrows =0    
   LET g_erows =0   
   IF g_bgjob = 'N' THEN 
        MESSAGE 'Process van_1 ...'
        CALL ui.interface.refresh()
   END IF
   LET g_funname = 'p500_van_1' 
   CALL p500_van_1() #途程製程--標準(aeci100)
   
   LET g_wrows =0    
   LET g_erows =0   
   IF g_bgjob = 'N' THEN 
        MESSAGE 'Process van_2 ...'
        CALL ui.interface.refresh()
   END IF
   LET g_funname = 'p500_van_2' 
   CALL p500_van_2() #途程製程--工單(aeci700)
   
   LET g_wrows =0   
   LET g_erows =0  
   IF g_bgjob = 'N' THEN 
        MESSAGE 'Process van_3 ...'
        CALL ui.interface.refresh()
   END IF
   LET g_funname = 'p500_van_3' 
   CALL p500_van_3() #替代作業維護檔(apsi326)
   
   #(6)現場報工
   LET g_funname = '' 
   LET g_wrows =0    
   LET g_erows =0   
   IF g_bgjob = 'N' THEN 
        MESSAGE 'Process vay ...'
        CALL ui.interface.refresh()
   END IF
   CALL p500_vay() #現場報工
   
   #(7)鎖定製程時間
   LET g_funname = '' 
   LET g_wrows =0    
   LET g_erows =0    
   IF g_bgjob = 'N' THEN 
        MESSAGE 'Process vbd ...'
        CALL ui.interface.refresh()
   END IF
   CALL p500_vbd() 
   
   #(8)鎖定使用設備
   LET g_funname = '' 
   LET g_wrows =0    
   LET g_erows =0   
   IF g_bgjob = 'N' THEN 
        MESSAGE 'Process vbe ...'
        CALL ui.interface.refresh()
   END IF
   CALL p500_vbe() 
   
   #(9)製令外包
   LET g_funname = '' 
   LET g_wrows =0    
   LET g_erows =0   
   IF g_bgjob = 'N' THEN 
        MESSAGE 'Process vbf ...'
        CALL ui.interface.refresh()
   END IF
   CALL p500_vbf() #製令外包
   
   #(10)製程外包
   LET g_funname = ''
   LET g_wrows =0    
   LET g_erows =0    
   IF g_bgjob = 'N' THEN 
        MESSAGE 'Process vbg ...'
        CALL ui.interface.refresh()
   END IF
   CALL p500_vbg() #製程外包
   
   #(11)需求訂單
   LET g_funname = ''
   LET g_wrows =0    
   LET g_erows =0    
   LET g_wrows_vav =0 #FUN-B50022 add
   LET g_erows_vav =0 #FUN-B50022 add
   LET g_crows_vav =0 #FUN-B50022 add
   IF g_bgjob = 'N' THEN 
        MESSAGE 'Process vau ...'
        CALL ui.interface.refresh()
   END IF
   CALL p500_vau() 
   #FUN-9B0003---add----end---

   LET g_funname = '' #FUN-940030 ADD
   LET g_wrows = 0   #FUN-940030 ADD
   LET g_erows = 0   #FUN-940030 ADD
   IF g_bgjob = 'N' THEN  
       MESSAGE 'Process vzz ...'
       CALL ui.interface.refresh()
   END IF
   CALL p500_vzz() #--ok

   LET g_funname = '' #FUN-940030 ADD
   LET g_wrows =0    #FUN-940030 ADD
   LET g_erows =0    #FUN-940030 ADD
   IF g_bgjob = 'N' THEN  
       MESSAGE 'Process vzy ...'
       CALL ui.interface.refresh()
   END IF
   CALL p500_vzy() 

   #FUN-8C0140  MARK  --STR--
   #IF g_bgjob = 'N' THEN  
   #    MESSAGE 'Process vzt ...'
   #    CALL ui.interface.refresh()
   #END IF
   #CALL p500_vzt() 
   #FUN-8C0140  MARK  --END--   
 
  LET g_funname = '' #FUN-940030 ADD
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process vaa ...'
       CALL ui.interface.refresh()
   END IF
   CALL p500_vaa() #--ok

  LET g_funname = '' #FUN-940030 ADD
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process vab ...'
       CALL ui.interface.refresh()
   END IF
   CALL p500_vab() #--ok

  LET g_funname = '' #FUN-940030 ADD
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process vac ...'
       CALL ui.interface.refresh()
   END IF
   CALL p500_vac() #--ok

  LET g_funname = '' #FUN-940030 ADD
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process vbh ...'
       CALL ui.interface.refresh()
   END IF
   CALL p500_vbh() #外包商資料,pmc_file全抓

  LET g_funname = '' #FUN-940030 ADD
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process vbi ...'
       CALL ui.interface.refresh()
   END IF
   CALL p500_vbi() #--ok

  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process vad ...'
       CALL ui.interface.refresh()
   END IF
   IF g_vlz.vlz60 = 1 THEN 
       #1:機器編號
       LET g_funname = 'p500_vad_1' #FUN-940030 ADD
       CALL p500_vad_1() 
   ELSE
       #0:工作站
       LET g_funname = 'p500_vad_2' #FUN-940030 ADD
       CALL p500_vad_2() 
   END IF

  
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process vae ...'
       CALL ui.interface.refresh()
   END IF
   IF g_vlz.vlz60 = 1 THEN 
       #1:機器編號
       LET g_funname = 'p500_vae_1' #FUN-940030 ADD
       CALL p500_vae_1() 
   ELSE
       #0:工作站
       LET g_funname = 'p500_vae_2' #FUN-940030 ADD
       CALL p500_vae_2() 
   END IF

  LET g_funname = '' #FUN-940030 ADD
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process vaf ...'
       CALL ui.interface.refresh()
   END IF
   CALL p500_vaf() #--ok

  LET g_funname = '' #FUN-940030 ADD
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process vag ...'
       CALL ui.interface.refresh()
   END IF
   CALL p500_vag() #--ok

  LET g_funname = '' #FUN-940030 ADD
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process vah ...'
       CALL ui.interface.refresh()
   END IF
   CALL p500_vah() #--ok
  
  LET g_funname = '' #FUN-940030 ADD
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process vai ...'
       CALL ui.interface.refresh()
   END IF
   CALL p500_vai() #--ok
 #FUN-9B0003---mark---str---
 #LET g_funname = '' #FUN-940030 ADD
 #LET g_wrows =0    #FUN-940030 ADD
 #LET g_erows =0    #FUN-940030 ADD
 #IF g_bgjob = 'N' THEN 
 #     MESSAGE 'Process vaj ...'
 #     CALL ui.interface.refresh()
 # END IF
 # CALL p500_vaj() #--ok
 #FUN-9B0003---mark---end---

  LET g_funname = '' #FUN-940030 ADD
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process vak ...'
       CALL ui.interface.refresh()
   END IF
   CALL p500_vak() #--ok

  LET g_funname = '' #FUN-940030 ADD
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process val ...'
       CALL ui.interface.refresh()
   END IF
   CALL p500_val() #--ok

  
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process vam_1 ...'
       CALL ui.interface.refresh()
   END IF
   LET g_funname = 'p500_vam_1' #FUN-940030 ADD
   CALL p500_vam_1() #料件途程---標準--aeci100

  
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process vam_2 ...'
       CALL ui.interface.refresh()
   END IF
   LET g_funname = 'p500_vam_2' #FUN-940030 ADD
   CALL p500_vam_2() #料件途程---工單--aeci700

   #TQC-870043---add---str---
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process vam_3 ...'
       CALL ui.interface.refresh()
   END IF
   LET g_funname = 'p500_vam_3' #FUN-940030 ADD
   CALL p500_vam_3() #料件途程---標準--aimi100
   #TQC-870043---add---end---

  
 #FUN-9B0003---mark---str---
 #LET g_wrows =0    #FUN-940030 ADD
 #LET g_erows =0    #FUN-940030 ADD
 #IF g_bgjob = 'N' THEN 
 #     MESSAGE 'Process van_1 ...'
 #     CALL ui.interface.refresh()
 # END IF
 # LET g_funname = 'p500_van_1' #FUN-940030 ADD
 # CALL p500_van_1() #途程製程--標準(aeci100)

 #
 #LET g_wrows =0    #FUN-940030 ADD
 #LET g_erows =0    #FUN-940030 ADD
 #IF g_bgjob = 'N' THEN 
 #     MESSAGE 'Process van_2 ...'
 #     CALL ui.interface.refresh()
 # END IF
 # LET g_funname = 'p500_van_2' #FUN-940030 ADD
 # CALL p500_van_2() #途程製程--工單(aeci700)
  
 #LET g_wrows =0    #FUN-940030 ADD
 #LET g_erows =0    #FUN-940030 ADD
 #IF g_bgjob = 'N' THEN 
 #     MESSAGE 'Process van_3 ...'
 #     CALL ui.interface.refresh()
 # END IF
 # LET g_funname = 'p500_van_3' #FUN-940030 ADD
 # CALL p500_van_3() #替代作業維護檔(apsi326)
 #FUN-9B0003---mark---end---

  LET g_funname = '' #FUN-940030 ADD
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process vao ...'
       CALL ui.interface.refresh()
   END IF
   CALL p500_vao() #--ok

  LET g_funname = '' #FUN-940030 ADD
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process vap ...'
       CALL ui.interface.refresh()
   END IF
   CALL p500_vap() #投料點

  LET g_funname = '' #FUN-940030 ADD
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process var ...'
       CALL ui.interface.refresh()
   END IF
   CALL p500_var() #--ok

  LET g_funname = '' #FUN-940030 ADD
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process vas ...'
       CALL ui.interface.refresh()
   END IF
   CALL p500_vas() #--ok

  #TQC-940012  ADD  --STR--
  LET g_funname = '' #FUN-940030 ADD
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN
       MESSAGE 'Process vas ...'
       CALL ui.interface.refresh()
  END IF
  CALL p500_vaq() #--ok
  #TQC-940012  ADD  --END--


  LET g_funname = '' #FUN-940030 ADD
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process vat ...'
       CALL ui.interface.refresh()
   END IF
   CALL p500_vat() #--ok

 #FUN-9B0003---mark---str---
 #LET g_funname = '' #FUN-940030 ADD
 #LET g_wrows =0    #FUN-940030 ADD
 #LET g_erows =0    #FUN-940030 ADD
 #IF g_bgjob = 'N' THEN 
 #     MESSAGE 'Process vau ...'
 #     CALL ui.interface.refresh()
 # END IF
 # CALL p500_vau() #--ok
 #FUN-9B0003---mark---end---

  LET g_funname = '' #FUN-940030 ADD
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process vav ...'
       CALL ui.interface.refresh()
   END IF

 #FUN-9B0003---mark---str---
 #LET g_funname = '' #FUN-940030 ADD
 #LET g_wrows =0    #FUN-940030 ADD
 #LET g_erows =0    #FUN-940030 ADD
 #IF g_bgjob = 'N' THEN 
 #     MESSAGE 'Process vaw ...'
 #     CALL ui.interface.refresh()
 # END IF
 # CALL p500_vaw() #--ok

 #LET g_funname = '' #FUN-940030 ADD
 #LET g_wrows =0    #FUN-940030 ADD
 #LET g_erows =0    #FUN-940030 ADD
 #IF g_bgjob = 'N' THEN 
 #     MESSAGE 'Process vax ...'
 #     CALL ui.interface.refresh()
 # END IF
 # CALL p500_vax() #--ok

 #LET g_funname = '' #FUN-940030 ADD
 #LET g_wrows =0    #FUN-940030 ADD
 #LET g_erows =0    #FUN-940030 ADD
 #IF g_bgjob = 'N' THEN 
 #     MESSAGE 'Process vay ...'
 #     CALL ui.interface.refresh()
 # END IF
 # CALL p500_vay() #現場報工
  
 #LET g_wrows =0    #FUN-940030 ADD
 #LET g_erows =0    #FUN-940030 ADD
 #IF g_bgjob = 'N' THEN 
 #     MESSAGE 'Process vaz_1 ...'
 #     CALL ui.interface.refresh()
 # END IF
 # LET g_funname = 'p500_vaz_1' #FUN-940030 ADD
 # CALL p500_vaz_1() #採購令--請購

 #
 #LET g_wrows =0    #FUN-940030 ADD
 #LET g_erows =0    #FUN-940030 ADD
 #IF g_bgjob = 'N' THEN 
 #     MESSAGE 'Process vaz_2 ...'
 #     CALL ui.interface.refresh()
 # END IF
 # LET g_funname = 'p500_vaz_2' #FUN-940030 ADD
 # CALL p500_vaz_2() #採購令--採購
 #FUN-9B0003---mark---end---

  
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process vba_1 ...'
       CALL ui.interface.refresh()
   END IF
   LET g_funname = 'p500_vba_1' #FUN-940030 ADD
   CALL p500_vba_1() #存貨預配紀錄--工單 

  
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process vba_2 ...'
       CALL ui.interface.refresh()
   END IF
   LET g_funname = 'p500_vba_2' #FUN-940030 ADD
   CALL p500_vba_2() #存貨預配紀錄--訂單 

  LET g_funname = '' #FUN-940030 ADD
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process vbb ...'
       CALL ui.interface.refresh()
   END IF
   CALL p500_vbb() #--ok

  LET g_funname = '' #FUN-940030 ADD
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process vbc ...'
       CALL ui.interface.refresh()
   END IF
   CALL p500_vbc() #--ok
  
 #FUN-9B0003---mark---str---
 #LET g_funname = '' #FUN-940030 ADD
 #LET g_wrows =0    #FUN-940030 ADD
 #LET g_erows =0    #FUN-940030 ADD
 #IF g_bgjob = 'N' THEN 
 #     MESSAGE 'Process vbd ...'
 #     CALL ui.interface.refresh()
 # END IF
 # CALL p500_vbd() #--ok

 #LET g_funname = '' #FUN-940030 ADD
 #LET g_wrows =0    #FUN-940030 ADD
 #LET g_erows =0    #FUN-940030 ADD
 #IF g_bgjob = 'N' THEN 
 #     MESSAGE 'Process vbe ...'
 #     CALL ui.interface.refresh()
 # END IF
 # CALL p500_vbe() #--ok

 #LET g_funname = '' #FUN-940030 ADD
 #LET g_wrows =0    #FUN-940030 ADD
 #LET g_erows =0    #FUN-940030 ADD
 #IF g_bgjob = 'N' THEN 
 #     MESSAGE 'Process vbf ...'
 #     CALL ui.interface.refresh()
 # END IF
 # CALL p500_vbf() #--ok製令外包

 #LET g_funname = '' #FUN-940030 ADD
 #LET g_wrows =0    #FUN-940030 ADD
 #LET g_erows =0    #FUN-940030 ADD
 #IF g_bgjob = 'N' THEN 
 #     MESSAGE 'Process vbg ...'
 #     CALL ui.interface.refresh()
 # END IF
 # CALL p500_vbg() #製程外包
 #FUN-9B0003---mark---end---

   #FUN-8A0003----add---str---
  LET g_funname = '' #FUN-940030 ADD
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN        
       MESSAGE 'Process vbj...'
       CALL ui.interface.refresh()
   END IF
   CALL p500_vbj() #工模具主檔

  LET g_funname = '' #FUN-940030 ADD
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN        
       MESSAGE 'Process vbk...'
       CALL ui.interface.refresh()
   END IF
   CALL p500_vbk() #工模具群組主檔

  LET g_funname = '' #FUN-940030 ADD
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN        
       MESSAGE 'Process vbl...'
       CALL ui.interface.refresh()
   END IF
   CALL p500_vbl() #工模具群組明細檔

  
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN        
       MESSAGE 'Process vbm_1...'
       CALL ui.interface.refresh()
   END IF
   LET g_funname = 'p500_vbm_1' #FUN-940030 ADD
   CALL p500_vbm_1() #途程製程指定工具--標準aeci100

  
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN        
       MESSAGE 'Process vbm_2...'
       CALL ui.interface.refresh()
   END IF
   LET g_funname = 'p500_vbm_2' #FUN-940030 ADD
   CALL p500_vbm_2() #途程製程指定工具--工單aeci700

#FUN-CA0018 ADD---str   
  LET g_wrows =0        
  LET g_erows =0        
  IF g_bgjob = 'N' THEN 
       MESSAGE 'Process vbm_3...'
       CALL ui.interface.refresh()
   END IF
   LET g_funname = 'p500_vbm_3'
   CALL p500_vbm_3() #抓vms_file,vnm_file
#FUN-CA0018 ADD---end   

  LET g_funname = '' #FUN-940030 ADD
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN        
       MESSAGE 'Process vbn...'
       CALL ui.interface.refresh()
   END IF
   CALL p500_vbn() #途程製程指定工具

  LET g_funname = '' #FUN-940030 ADD
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN        
       MESSAGE 'Process vbo...'
       CALL ui.interface.refresh()
   END IF
   CALL p500_vbo() #工模具大類主檔

  LET g_funname = '' #FUN-940030 ADD
  LET g_wrows =0    #FUN-940030 ADD
  LET g_erows =0    #FUN-940030 ADD
  IF g_bgjob = 'N' THEN        
       MESSAGE 'Process ending...'
       CALL ui.interface.refresh()
   END IF
   #FUN-8A0003----add---end---

   #==>CLOSE Cursor
   CLOSE p500_c_ins_vzz 
   CLOSE p500_c_ins_vzy
   #CLOSE p500_c_ins_vzt   #FUN-8C0140 MARK
   CLOSE p500_c_ins_vaa
   CLOSE p500_c_ins_vab
   CLOSE p500_c_ins_vac
   CLOSE p500_c_ins_vad
   CLOSE p500_c_ins_vae
   CLOSE p500_c_ins_vaf
   CLOSE p500_c_ins_vag
   CLOSE p500_c_ins_vah
   CLOSE p500_c_ins_vai
   CLOSE p500_c_ins_vaj
   CLOSE p500_c_ins_vak
   CLOSE p500_c_ins_val
   CLOSE p500_c_ins_vam
   CLOSE p500_c_ins_van
   CLOSE p500_c_ins_vao
   CLOSE p500_c_ins_vap
   CLOSE p500_c_ins_vaq
   CLOSE p500_c_ins_var
   CLOSE p500_c_ins_vas
   CLOSE p500_c_ins_vat
   CLOSE p500_c_ins_vau
   CLOSE p500_c_ins_vav
   CLOSE p500_c_ins_vaw
   CLOSE p500_c_ins_vax
   CLOSE p500_c_ins_vay
   CLOSE p500_c_ins_vaz
   #FUN-8A0003---add---str---
   CLOSE p500_c_ins_vbj
   CLOSE p500_c_ins_vbk
   CLOSE p500_c_ins_vbl
   CLOSE p500_c_ins_vbm
   CLOSE p500_c_ins_vbn
   CLOSE p500_c_ins_vbo
   #FUN-8A0003---add---end---

END FUNCTION

#工作站
FUNCTION p500_vbi()
  DEFINE l_sql          STRING
  DEFINE l_eca01        LIKE eca_file.eca01
  DEFINE l_eca02        LIKE eca_file.eca02
  DEFINE l_eca05        LIKE eca_file.eca05
  DEFINE l_vmj10        LIKE vmj_file.vmj10 #TQC-870032 add

  IF tm.vlb15  = 'N' THEN RETURN END IF

  #TQC-880053 add l_vmj10 
  DECLARE p500_vbi_c CURSOR FOR
     SELECT eca01,eca02,eca05,vmj10  
       FROM eca_file,
       OUTER vmj_file       #TQC-870032--add--
      WHERE eca01 = vmj_file.vmj01   #TQC-870032--add--

  INITIALIZE g_vbi.* TO NULL   
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vbi_c INTO l_eca01,l_eca02,l_eca05,l_vmj10
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vbi_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_vbi.* TO NULL    
     IF cl_null(l_eca05) THEN LET l_eca05 = ' ' END IF
     LET g_vbi.vbi01 = l_eca01
     LET g_vbi.vbi02 = l_eca05
     LET g_vbi.vbi03 = l_eca02
     LET g_vbi.vbi04 = l_eca02
     #TQC-870032--mod---str---
     IF NOT cl_null(l_vmj10) THEN
         LET g_vbi.vbi05 = l_vmj10
     ELSE
         LET g_vbi.vbi05 = 999
     END IF
     #TQC-870032--mod---end---
     LET g_vbi.vbilegal = g_legal #FUN-B50022 add
     LET g_vbi.vbiplant = g_plant #FUN-B50022 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD   
     PUT p500_c_ins_vbi  FROM g_vbi.*
     IF STATUS THEN
        #LET g_msg = 'Key:',g_vbi.vbi01   #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vbi01',g_vbi.vbi01,'','','','','','','','','','')   #FUN-940030 ADD
       #CALL err('vbi_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vbi_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD  
     END IF
     INITIALIZE g_vbi.* TO NULL   
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

  #FUN-940030  ADD 記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
  #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
   LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
   CALL  err('vbi_file','',g_msg,'0')
   LET   g_crows = g_wrows - g_erows
  #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
   LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
   CALL  err('vbi_file','',g_msg,'1')
  #FUN-940030  ADD  --END-----------------------------------------------------
  IF SQLCA.sqlcode THEN CALL cl_err('p500_vbi_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p500_vaa()      #工作模式
DEFINE l_sql            STRING                 
DEFINE l_vma       	RECORD LIKE vma_file.* 

  IF tm.vlb11 = 'N' THEN RETURN END IF

  DECLARE p500_vma_c CURSOR FOR 
   SELECT * FROM vma_file

  INITIALIZE g_vaa.* TO NULL   
  INITIALIZE l_vma.* TO NULL   
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vma_c INTO l_vma.*  
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vma_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vaa.vaa01 = l_vma.vma01
     IF NOT cl_null(l_vma.vma02) THEN 
         LET g_vaa.vaa02 = l_vma.vma02
     ELSE
         LET g_vaa.vaa02 = 0
     END IF
     IF NOT cl_null(l_vma.vma03) THEN 
         LET g_vaa.vaa03 = l_vma.vma03
     ELSE
         LET g_vaa.vaa03 = 0
     END IF
     IF NOT cl_null(l_vma.vma04) THEN 
         LET g_vaa.vaa04 = l_vma.vma04
     ELSE
         LET g_vaa.vaa04 = 0
     END IF
     LET g_vaa.vaa05 = l_vma.vma05
     LET g_vaa.vaa06 = l_vma.vma06
     LET g_vaa.vaalegal = g_legal #FUN-B50022 add
     LET g_vaa.vaaplant = g_plant #FUN-B50022 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vaa  FROM g_vaa.*
     IF STATUS THEN
        #LET g_msg = 'Key:',g_vaa.vaa01 CLIPPED,' + ',g_vaa.vaa02 CLIPPED  #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vaa01',g_vaa.vaa01,'vaa02',g_vaa.vaa02,'','','','','','','','')  #FUN-940030 ADD
       #CALL err('vaa_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vaa_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

  #FUN-940030 ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
   #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
    LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
    CALL  err('vaa_file','',g_msg,'0')
    LET   g_crows = g_wrows - g_erows
   #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
    LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
    CALL  err('vaa_file','',g_msg,'1')
  #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN
     CALL cl_err('p500_vma_c:',STATUS,1) RETURN
  END IF
END FUNCTION
 
FUNCTION p500_vac() 
DEFINE l_sql    STRING                 
DEFINE l_vmc   	RECORD LIKE vmc_file.* 

  IF tm.vlb13  = 'N' THEN RETURN END IF

  DECLARE p500_vmc_c CURSOR FOR 
   SELECT * FROM vmc_file

  INITIALIZE g_vac.* TO NULL   
  INITIALIZE l_vmc.* TO NULL   
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vmc_c INTO l_vmc.*  
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vmc_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vac.vac01 = l_vmc.vmc01
     LET g_vac.vac02 = l_vmc.vmc02
     LET g_vac.vac03 = l_vmc.vmc03
     LET g_vac.vac04 = l_vmc.vmc04
     LET g_vac.vac05 = l_vmc.vmc05
     LET g_vac.vac06 = l_vmc.vmc06
     LET g_vac.vac07 = l_vmc.vmc07
     LET g_vac.vac08 = l_vmc.vmc08
     LET g_vac.vaclegal = g_legal #FUN-B50022 add
     LET g_vac.vacplant = g_plant #FUN-B50022 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vac  FROM g_vac.*
     IF STATUS THEN
        #LET g_msg = 'Key:',g_vac.vac01 CLIPPED  #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vac01',g_vac.vac01,'','','','','','','','','','')   #FUN-940030 ADD
       #CALL err('vac_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vac_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vac.* TO NULL   
     INITIALIZE l_vmc.* TO NULL   
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

  #FUN-940030 ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
   #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
    LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
    CALL  err('vac_file','',g_msg,'0')
    LET   g_crows = g_wrows - g_erows
   #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
    LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
    CALL  err('vac_file','',g_msg,'1')
  #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN
     CALL cl_err('p500_vmc_c:',STATUS,1) RETURN
  END IF
END FUNCTION

FUNCTION p500_vav(p_oeo01,p_oeo03,p_oeb04,p_vau03) 
DEFINE l_sql       STRING                
DEFINE p_oeo01     LIKE oeo_file.oeo01
DEFINE p_oeo03     LIKE oeo_file.oeo03
DEFINE l_oeo04     LIKE oeo_file.oeo04
DEFINE p_oeb04     LIKE oeb_file.oeb04
DEFINE p_vau03     LIKE vau_file.vau03
DEFINE l_seq       LIKE type_file.num10 

  IF tm.vlb34= 'N' THEN RETURN END IF

  DECLARE p500_vav_c CURSOR FOR 
     SELECT oeo01,oeo04
       FROM oeo_file
      WHERE oeo01 = p_oeo01
        AND oeo03 = p_oeo03
  LET l_seq = 0
  FOREACH p500_vav_c INTO p_oeo01,l_oeo04
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vav_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_vav.* TO NULL
     LET l_seq = l_seq + 1
     LET g_vav.vav01 = l_oeo04
     LET g_vav.vav02 = p_oeb04
     LET g_vav.vav03 = p_vau03
     LET g_vav.vav04 = l_seq USING '&&&&'
     LET g_vav.vavlegal = g_legal #FUN-B50022 add
     LET g_vav.vavplant = g_plant #FUN-B50022 add

    #LET g_wrows = g_wrows + 1   #FUN-940030  ADD         #FUN-B50022 mark
     LET g_wrows_vav = g_wrows_vav + 1   #FUN-940030  ADD #FUN-B50022 add
     PUT p500_c_ins_vav FROM g_vav.*
     IF STATUS THEN
        #FUN-940030  MARK   --STR--
        #LET g_msg = 'Key:',g_vav.vav01 CLIPPED,' + ',
        #                   g_vav.vav02 CLIPPED,' + ',
        #                   g_vav.vav03 CLIPPED,' + ',
        #                   g_vav.vav04 CLIPPED,' + '
        #FUN-940030  MARK   --END--
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vav01',g_vav.vav01,'vav02',g_vav.vav02,'vav03',g_vav.vav03,'vav04',g_vav.vav04,'','','','')   #FUN-940030 ADD
       #CALL err('vav_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vav_file',g_msg,g_status,'2')  #TQC-B70094 add
       #LET g_erows = g_erows + 1   #FUN-940030  ADD #FUN-B50022 mark
        LET g_erows_vav = g_erows_vav + 1   #FUN-940030  ADD #FUN-B50022 add
     END IF
  END FOREACH

#FUN-B50022 mark---str--
##FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
# LET   g_msg = g_wrows ,' ROWS'
# CALL  err('vav_file','',g_msg,'0')
# LET   g_crows = g_wrows - g_erows
# LET   g_msg = g_crows ,' ROWS'
# CALL  err('vav_file','',g_msg,'1')
##FUN-940030  ADD  --END-----------------------------------------------------
#FUN-B50022 mark---end--

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vav_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p500_var()      
DEFINE l_sql            STRING                
DEFINE l_bmd            RECORD LIKE bmd_file.*
DEFINE l_bmb            RECORD LIKE bmb_file.*
#DEFINE l_bmb_rowid      LIKE type_file.chr18   #FUN-B50022 mark
DEFINE l_bmb01      LIKE bmb_file.bmb01         #FUN-B50022 add
DEFINE l_bmb02      LIKE bmb_file.bmb02         #FUN-B50022 add
DEFINE l_bmb03      LIKE bmb_file.bmb03         #FUN-B50022 add
DEFINE l_bmb04      LIKE bmb_file.bmb04         #FUN-B50022 add
DEFINE l_bmb29      LIKE bmb_file.bmb29         #FUN-B50022 add
DEFINE l_vmq11      LIKE vmq_file.vmq11  #TQC-860041 add
DEFINE l_bmb10      LIKE bmb_file.bmb10     #FUN-AA0009 add
DEFINE l_ori_ima25  LIKE ima_file.ima25     #FUN-AA0009 add
DEFINE l_ori_factor LIKE type_file.num26_10 #FUN-AA0009 add
DEFINE l_sub_ima25  LIKE ima_file.ima25     #FUN-AA0009 add
DEFINE l_sub_ima63  LIKE ima_file.ima63     #FUN-AA0009 add
DEFINE l_ori_ima63  LIKE ima_file.ima63     #FUN-AA0009 add
DEFINE l_sub_factor LIKE type_file.num26_10 #FUN-AA0009 add
DEFINE l_ori_flag   LIKE type_file.chr1     #FUN-AA0011 add
DEFINE l_sub_flag   LIKE type_file.chr1     #FUN-AA0011 add
DEFINE l_qty        LIKE type_file.num26_10 #FUN-B60062

  IF tm.vlb30  = 'N' THEN RETURN END IF

  #TQC-860041---mod---str---
  DECLARE p500_var_c CURSOR FOR 
     SELECT bmd_file.*,vmq11 
       FROM bmd_file,OUTER vmq_file
      WHERE bmd08 = 'ALL'
        AND bmdacti = 'Y'
        AND bmd08 = vmq_file.vmq01 #主件品號
        AND bmd01 = vmq_file.vmq02 #元件品號
        AND bmd04 = vmq_file.vmq03 #取替代料品號(元件)
        AND bmdacti = 'Y'                               #CHI-910021
        AND (bmd06 > g_today OR bmd06 IS NULL)          #FUN-B40073 add 失效日
  #TQC-860041---mod---str---

  INITIALIZE g_var.* TO NULL
  INITIALIZE l_bmd.* TO NULL
  INITIALIZE l_bmb.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_var_c INTO l_bmd.*,l_vmq11 #TQC-860041 add vmq11
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_var_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_var.* TO NULL
     LET g_var.var01 = l_bmd.bmd01
     LET g_var.var02 = l_bmd.bmd04
     LET g_var.var03 = (l_bmd.bmd02*10 + l_bmd.bmd03)
    #LET g_var.var04 = l_bmd.bmd07 #FUN-AA0009 mark
    #FUN-AA0009---add---str--
    #原始料件編號 l_bmd.bmd01
    #原=>發料單位 l_ori_ima63
    #原=>庫存單位 l_ori_ima25
     SELECT ima25,ima63 INTO l_ori_ima25,l_ori_ima63
       FROM ima_file
      WHERE ima01 = l_bmd.bmd01

     #發料/庫存單位換算率
     CALL s_umfchk(l_bmd.bmd01,l_ori_ima63,l_ori_ima25) 
          RETURNING l_ori_flag,l_ori_factor #FUN-AA0011 mod 
     IF l_ori_flag = 1 THEN                 #FUN-AA0011 mod
        LET l_ori_factor = 1
     END IF

    #替代料件編號 l_bmd.bmd04
    #替=>發料單位 l_sub_ima63
    #替=>庫存單位 l_sub_ima25
     SELECT ima25,ima63 INTO l_sub_ima25,l_sub_ima63
       FROM ima_file
      WHERE ima01 = l_bmd.bmd04
     #發料/庫存單位換算率
     CALL s_umfchk(l_bmd.bmd04,l_sub_ima63,l_sub_ima25) 
          RETURNING l_sub_flag,l_sub_factor #FUN-AA0011 mod
     IF l_sub_flag = 1 THEN                 #FUN-AA0011 mod
        LET l_sub_factor = 1
     END IF
    #FUN-B60062---mod---str---
    #CALL cl_set_num_value(l_bmd.bmd07 * (l_sub_factor/l_ori_factor),3) RETURNING g_var.var04
     LET l_qty = l_bmd.bmd07 * (l_sub_factor/l_ori_factor)
     CALL cl_set_num_value(l_qty,3) RETURNING g_var.var04
    #FUN-B60062---mod---end---
    #FUN-AA0009---add---end--
     LET g_var.var05 = l_bmd.bmd05
     LET g_var.var06 = l_bmd.bmd06
     #只為了找到bmb_file相對應中的任何一筆就OK-------str--
    #FUN-B50022--mod---str---
    #LET l_bmb_rowid = NULL
    #SELECT MIN(ROWID) INTO l_bmb_rowid FROM bmb_file
    # WHERE bmb03 = l_bmd.bmd01
    #SELECT * INTO l_bmb.* 
    #  FROM bmb_file
    # WHERE ROWID = l_bmb_rowid
     SELECT MAX(bmb01),MAX(bmb02),MAX(bmb03),MAX(bmb04),MAX(bmb29)
       INTO l_bmb01,l_bmb02,l_bmb03,l_bmb04,l_bmb29
       FROM bmb_file
      WHERE bmb03 = l_bmd.bmd01
     
     SELECT * INTO l_bmb.* 
       FROM bmb_file
      WHERE bmb01 = l_bmb01
        AND bmb02 = l_bmb02
        AND bmb03 = l_bmb03
        AND bmb04 = l_bmb04
        AND bmb29 = l_bmb29
    #FUN-B50022--mod---end---
     #-----------------------------------------------end--
     LET g_var.var07 = 1
    #LET g_var.var08 = l_bmb.bmb08 #TQC-9A0143 mark
     #TQC-9A0143--add---str---
     IF NOT cl_null(l_bmb.bmb08) THEN
         LET g_var.var08 = l_bmb.bmb08/100
     ELSE
         LET g_var.var08 = 0
     END IF
     #TQC-9A0143--add---end---
     LET g_var.var09 = l_bmd.bmd02
     #TQC-860041---add---str---
     IF NOT cl_null(l_vmq11) THEN
         LET g_var.var10 = l_vmq11
     ELSE
         LET g_var.var10 = 0
     END IF
     #TQC-860041---add---end---
     LET g_var.varlegal = g_legal #FUN-B50022 add
     LET g_var.varplant = g_plant #FUN-B50022 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     #FUN-AA0011--add---str---
     IF l_ori_flag=1 OR l_sub_flag=1 THEN
         IF l_ori_flag THEN
             CALL p500_getmsg('var01',g_var.var01,'var02',g_var.var02,'bmd01',l_bmd.bmd01,'ima63',l_ori_ima63,'ima25',l_ori_ima25,'','')   
             CALL err('var_file',g_msg,'mfg2721','2')
         END IF
         IF l_sub_flag THEN
             CALL p500_getmsg('var01',g_var.var01,'var02',g_var.var02,'bmd04',l_bmd.bmd04,'ima63',l_sub_ima63,'ima25',l_sub_ima25,'','')   
             CALL err('var_file',g_msg,'mfg2721','2')
         END IF
         LET g_erows = g_erows + 1   
     ELSE
     #FUN-AA0011--add---end---
         PUT p500_c_ins_var FROM g_var.*
         IF STATUS THEN
            #LET g_msg = 'Key:',g_var.var01 CLIPPED,' + ',g_var.var02  #FUN-940030 MARK
            LET g_status = STATUS                    #TQC-B70094 add
            CALL p500_getmsg('var01',g_var.var01,'var02',g_var.var02,'','','','','','','','')   #FUN-940030 ADD
           #CALL err('var_file',g_msg,STATUS,'2')    #TQC-B70094 mark
            CALL err('var_file',g_msg,g_status,'2')  #TQC-B70094 add
            LET g_erows = g_erows + 1   #FUN-940030  ADD
         END IF
     END IF #FUN-AA0011 add
     INITIALIZE g_var.* TO NULL
     INITIALIZE l_bmd.* TO NULL
     INITIALIZE l_bmb.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('var_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('var_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------
  IF SQLCA.sqlcode THEN CALL cl_err('p500_var_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p500_vas()      
DEFINE l_sql            STRING                
DEFINE l_occ            RECORD LIKE occ_file.*

  IF tm.vlb31  = 'N' THEN RETURN END IF

  DECLARE p500_vas_c CURSOR FOR 
    SELECT * FROM occ_file
     WHERE occacti = 'Y'

  INITIALIZE g_vas.* TO NULL
  INITIALIZE l_occ.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vas_c INTO l_occ.*
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vas_c:',STATUS,1) EXIT FOREACH
     END IF
     IF NOT cl_null(l_occ.occ01) AND NOT cl_null(l_occ.occ02) THEN  
        LET g_vas.vas01 = l_occ.occ01
        LET g_vas.vas02 = l_occ.occ34
        LET g_vas.vas03 = l_occ.occ02
        LET g_vas.vas04 = l_occ.occ34
        LET g_vas.vaslegal = g_legal #FUN-B50022 add
        LET g_vas.vasplant = g_plant #FUN-B50022 add

        LET g_wrows = g_wrows + 1   #FUN-940030  ADD
        PUT p500_c_ins_vas FROM g_vas.*
        IF STATUS THEN
           #LET g_msg = 'Key:',g_vas.vas01 CLIPPED,' + ',  #FUN-940030 MARK
           #                   g_vas.vas02 CLIPPED         #FUN-940030 MARK
           LET g_status = STATUS                    #TQC-B70094 add
           CALL p500_getmsg('vas01',g_vas.vas01,'vas02',g_vas.vas02,'','','','','','','','')   #FUN-940030 ADD
          #CALL err('vas_file',g_msg,STATUS,'2')    #TQC-B70094 mark
           CALL err('vas_file',g_msg,g_status,'2')  #TQC-B70094 add
           LET g_erows = g_erows + 1   #FUN-940030  ADD
        END IF
     END IF 
     INITIALIZE g_vas.* TO NULL
     INITIALIZE l_occ.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vas_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vas_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vas_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p500_vba_1()    ##存貨預配紀錄(工單) 
DEFINE l_ima08          LIKE ima_file.ima08
DEFINE l_sql            STRING                
DEFINE l_vna            RECORD LIKE vna_file.* 

  IF tm.vlb40 = 'N' THEN RETURN END IF

  DECLARE p500_vba_c CURSOR FOR 
   SELECT * FROM vna_file

  INITIALIZE g_vba.* TO NULL
  INITIALIZE l_vna.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vba_c INTO l_vna.*   
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vba_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vba.vba01 = l_vna.vna01
     LET g_vba.vba02 = l_vna.vna02
     LET g_vba.vba03 = l_vna.vna03
     LET g_vba.vba04 = l_vna.vna04
     LET g_vba.vba05 = l_vna.vna05
     LET g_vba.vba06 = l_vna.vna06
     SELECT ima08 
       INTO l_ima08
       FROM ima_file 
      WHERE ima01 = g_vba.vba01
     IF l_ima08 MATCHES '[PZV]' THEN
         LET g_vba.vba07 = 0
     ELSE
         LET g_vba.vba07 = 1
     END IF
     LET g_vba.vba08 = NULL
     LET g_vba.vba09 = l_vna.vna09
     LET g_vba.vba10 = 0 #工單
     LET g_vba.vbalegal = g_legal #FUN-B50022 add
     LET g_vba.vbaplant = g_plant #FUN-B50022 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vba FROM g_vba.*
     IF STATUS THEN
        #FUN-940030 MARK   --STR--
        #LET g_msg = 'Key:',g_vba.vba01 CLIPPED,' + ',
        #                   g_vba.vba02 CLIPPED,' + ',
        #                   g_vba.vba03 CLIPPED,' + ',
        #                   g_vba.vba04 CLIPPED
        #FUN-940030  MARK    --END--
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vba01',g_vba.vba01,'vba02',g_vba.vba02,'vba03',g_vba.vba03,'vba04',g_vba.vba04,'','','','')   #FUN-940030 ADD
       #CALL err('vba_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vba_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vba.* TO NULL
     INITIALIZE l_vna.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vba_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vba_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vba_c:',STATUS,1) RETURN END IF
END FUNCTION
FUNCTION p500_vba_2()     ##存貨預配紀錄(訂單)
DEFINE l_sql            STRING                
DEFINE l_oeb       	RECORD LIKE oeb_file.*
DEFINE l_sic       	RECORD LIKE sic_file.* #FUN-BA0086 add
DEFINE l_sum_sic06      LIKE sic_file.sic06    #FUN-BA0086 add
DEFINE l_ima08          LIKE ima_file.ima08

  IF tm.vlb40 = 'N' THEN RETURN END IF

 #FUN-BA0086---mark---str----
 #DECLARE p500_vba2_c CURSOR FOR 
 # SELECT oeb04,oeb01,oeb09,oeb091,SUM(oeb905*oeb05_fac),SUM(oeb12*oeb05_fac) 
 #   FROM oeb_file,vau_file
 #  WHERE oeb19 = 'Y'
 #    AND vau01 = tm.vlb01
 #    AND vau02 = tm.vlb02
 #    AND vau11 = oeb01
 #  GROUP BY oeb04,oeb01,oeb09,oeb091
 #FUN-BA0086---mark---end----
 #FUN-BA0086---add----str----
  LET l_sql = "SELECT sic04,sic03,sic15,sic08,sic09,SUM(sic06*sic07_fac) ",
              "  FROM sic_file,sia_file ",
              " WHERE (sic03,sic15) IN (SELECT vau11,CAST(SUBSTR(vau03,LENGTH(vau03)-3,4) AS INT) ",
              "                           FROM vau_file ",
              "                          WHERE vau01 = '",tm.vlb01,"'",
              "                            AND vau02 = '",tm.vlb02,"')",
              "   AND sic01 = sia01 ",
              "   AND siaconf = 'Y' ",
              " GROUP BY sic04,sic03,sic15,sic08,sic09 ",
              " ORDER BY sic04,sic03,sic15,sic08,sic09 "
  PREPARE p500_vba2_p FROM l_sql
  IF STATUS THEN CALL cl_err('pre p500_vba2_p',STATUS,1) END IF
  DECLARE p500_vba2_c CURSOR FOR p500_vba2_p
  IF STATUS THEN CALL cl_err('dec p500_vai_c',STATUS,1) END IF
 #FUN-BA0086---add----end----

  INITIALIZE g_vba2.* TO NULL
  INITIALIZE l_oeb.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
 #FOREACH p500_vba2_c INTO l_oeb.oeb04,l_oeb.oeb01,l_oeb.oeb09,l_oeb.oeb091,l_oeb.oeb905,l_oeb.oeb12   #FUN-BA0086 mark
  FOREACH p500_vba2_c INTO l_sic.sic04,l_sic.sic03,l_sic.sic15,l_sic.sic08,l_sic.sic09,l_sum_sic06     #FUN-BA0086 add
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vba2_c:',STATUS,1) EXIT FOREACH
     END IF
    #FUN-BA0086---mark----str-----
    #LET g_vba2.vba01 = l_oeb.oeb04     #料號
    #LET g_vba2.vba02 = l_oeb.oeb01     #配給對象   
    #LET g_vba2.vba03 = l_oeb.oeb09     #倉庫編號     
    #LET g_vba2.vba04 = l_oeb.oeb091    #儲位編號   
    #LET g_vba2.vba05 = l_oeb.oeb905
    #LET g_vba2.vba06 = l_oeb.oeb12
    #FUN-BA0086---mark----end-----
    #FUN-BA0086---add-----str-----
     LET g_vba2.vba01 = l_sic.sic04     #料號
     LET g_vba2.vba02 = l_sic.sic03 CLIPPED,'-',l_sic.sic15 USING '&&&&' #配給對象   
     LET g_vba2.vba03 = l_sic.sic08     #倉庫編號     
     LET g_vba2.vba04 = l_sic.sic09     #儲位編號   
     LET g_vba2.vba05 = l_sum_sic06     #分配量
     SELECT oeb12*oeb05_fac INTO l_oeb.oeb12
       FROM oeb_file
      WHERE oeb01 = l_sic.sic03
        AND oeb03 = l_sic.sic15
     LET g_vba2.vba06 = l_oeb.oeb12     #需求數量
    #FUN-BA0086---add-----end-----
     SELECT ima08 INTO l_ima08
       FROM ima_file
     #WHERE ima01 = l_oeb.oeb04 #FUN-BA0086 mark
      WHERE ima01 = l_sic.sic04 #FUN-BA0086 add
     IF l_ima08 MATCHES '[PVZ]' THEN
         LET g_vba2.vba07 = 0
     ELSE
         LET g_vba2.vba07 = 1
     END IF
     LET g_vba2.vba08 = NULL
     LET g_vba2.vba09 = 1
     LET g_vba2.vba10 = 1 #訂單
     LET g_vba2.vbalegal = g_legal #FUN-B50022 add
     LET g_vba2.vbaplant = g_plant #FUN-B50022 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vba FROM g_vba2.*
     IF STATUS THEN
        #FUN-940030  MARK   --STR--
        #LET g_msg = 'Key:',g_vba2.vba01 CLIPPED,' + ',
        #                   g_vba2.vba02 CLIPPED,' + ',
        #                   g_vba2.vba03 CLIPPED,' + ',
        #                   g_vba2.vba04 CLIPPED   
        #FUN-940030  MARK   --END--
        LET g_status = STATUS                    #TQC-B70094 add
       #CALL p500_getmsg('vba01',g_vba.vba01,'vba02',g_vba.vba02,'vba03',g_vba.vba03,'vba04',g_vba.vba04,'','','','')   #FUN-940030 ADD       #FUN-BA0086 mark
        CALL p500_getmsg('vba01',g_vba2.vba01,'vba02',g_vba2.vba02,'vba03',g_vba2.vba03,'vba04',g_vba2.vba04,'','','','')   #FUN-940030 ADD   #FUN-BA0086 add
       #CALL err('vba_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vba_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vba2.* TO NULL
     INITIALIZE l_oeb.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vba_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vba_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vba2_c:',STATUS,1) RETURN END IF
END FUNCTION
 

FUNCTION p500_vzz()      
DEFINE l_sql        STRING                
DEFINE l_vlz        RECORD LIKE vlz_file.*
DEFINE l_vzz        RECORD LIKE vzz_file.*   #FUN-930127  ADD
DEFINE l_date_tmp1      DATETIME YEAR TO MINUTE #TQC-8A0053 add
DEFINE l_to_char_vlz03  LIKE type_file.chr20    #TQC-8A0053 add
DEFINE l_tmp            LIKE type_file.chr20    #TQC-8A0053 add

  IF tm.vlb10 = 'N' THEN RETURN END IF

  DECLARE p500_vlz_c CURSOR FOR 
   SELECT * FROM vlz_file     
    WHERE vlz01 = tm.vlb01
      AND vlz02 = tm.vlb02

  INITIALIZE g_vzz.* TO NULL
  INITIALIZE l_vlz.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vlz_c INTO l_vlz.*   
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vlz_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vzz.vzz00 = g_plant
     LET g_vzz.vzz01 = l_vlz.vlz01
     LET g_vzz.vzz02 = l_vlz.vlz02
    #TQC-8A0053--mod---str---
    #LET g_vzz.vzz03 = tm.vlb04
     LET l_tmp = NULL
     LET l_to_char_vlz03 = g_vlz03_dd USING 'YYYY-MM-DD'
     LET l_tmp = l_to_char_vlz03 CLIPPED,' ',g_vlz03_tt CLIPPED
     LET l_date_tmp1 = l_tmp CLIPPED 
     LET g_vzz.vzz03 = l_date_tmp1
     #TQC-8A0053--mod---end---
     LET g_vzz.vzz04 = l_vlz.vlz04
     LET g_vzz.vzz05 = l_vlz.vlz05
     LET g_vzz.vzz06 = l_vlz.vlz06
     LET g_vzz.vzz07 = l_vlz.vlz07
     LET g_vzz.vzz08 = l_vlz.vlz08
     LET g_vzz.vzz09 = l_vlz.vlz09
     LET g_vzz.vzz10 = l_vlz.vlz10
     LET g_vzz.vzz11 = l_vlz.vlz11
     LET g_vzz.vzz12 = l_vlz.vlz12
     LET g_vzz.vzz13 = l_vlz.vlz13
     LET g_vzz.vzz14 = l_vlz.vlz14
     LET g_vzz.vzz15 = l_vlz.vlz15
     LET g_vzz.vzz16 = l_vlz.vlz16
     LET g_vzz.vzz17 = l_vlz.vlz17
     LET g_vzz.vzz18 = l_vlz.vlz18
     LET g_vzz.vzz19 = l_vlz.vlz19
     LET g_vzz.vzz20 = l_vlz.vlz20
     LET g_vzz.vzz21 = l_vlz.vlz21
     LET g_vzz.vzz22 = l_vlz.vlz22
     LET g_vzz.vzz23 = l_vlz.vlz23
     LET g_vzz.vzz24 = l_vlz.vlz24
     LET g_vzz.vzz25 = l_vlz.vlz25
     LET g_vzz.vzz26 = l_vlz.vlz26
     LET g_vzz.vzz27 = l_vlz.vlz27
     LET g_vzz.vzz28 = l_vlz.vlz28
     LET g_vzz.vzz29 = l_vlz.vlz29
     LET g_vzz.vzz30 = l_vlz.vlz30
     LET g_vzz.vzz31 = l_vlz.vlz31
     LET g_vzz.vzz32 = l_vlz.vlz32
     LET g_vzz.vzz33 = l_vlz.vlz33
     LET g_vzz.vzz34 = l_vlz.vlz34
     LET g_vzz.vzz35 = l_vlz.vlz35
     LET g_vzz.vzz36 = l_vlz.vlz36
     LET g_vzz.vzz37 = l_vlz.vlz37
     LET g_vzz.vzz38 = l_vlz.vlz38
     LET g_vzz.vzz39 = l_vlz.vlz39
     LET g_vzz.vzz40 = l_vlz.vlz40
     LET g_vzz.vzz41 = l_vlz.vlz41
     LET g_vzz.vzz42 = l_vlz.vlz42
     LET g_vzz.vzz43 = l_vlz.vlz43
     LET g_vzz.vzz44 = l_vlz.vlz44
     LET g_vzz.vzz45 = l_vlz.vlz45
     LET g_vzz.vzz46 = l_vlz.vlz46
     LET g_vzz.vzz47 = l_vlz.vlz47
     LET g_vzz.vzz48 = l_vlz.vlz48
     LET g_vzz.vzz49 = l_vlz.vlz49
     LET g_vzz.vzz50 = l_vlz.vlz50
     LET g_vzz.vzz51 = l_vlz.vlz51
     LET g_vzz.vzz52 = l_vlz.vlz52
     LET g_vzz.vzz53 = l_vlz.vlz53
     LET g_vzz.vzz54 = l_vlz.vlz54
     LET g_vzz.vzz55 = l_vlz.vlz55
     LET g_vzz.vzz56 = l_vlz.vlz56
     LET g_vzz.vzz57 = l_vlz.vlz57
    #TQC-8B0042--mod---str---
    #LET g_vzz.vzz58 = l_vlz.vlz58
    #LET g_vzz.vzz59 = l_vlz.vlz59
     IF cl_null(l_vlz.vlz58) THEN LET l_vlz.vlz58 = '1,2' END IF
     CASE 
          WHEN l_vlz.vlz58 = '1'     LET g_vzz.vzz58 = 'starttime'
          WHEN l_vlz.vlz58 = '2'     LET g_vzz.vzz58 = 'endtime'
          WHEN l_vlz.vlz58 = '1,2'   LET g_vzz.vzz58 = 'starttime,endtime'
          WHEN l_vlz.vlz58 = '2,1'   LET g_vzz.vzz58 = 'endtime,starttime'
          OTHERWISE                  LET g_vzz.vzz58 = 'starttime,endtime'
     END CASE
     IF cl_null(l_vlz.vlz59) THEN LET l_vlz.vlz59 = '1,2' END IF
     CASE 
          WHEN l_vlz.vlz59 = '1'     LET g_vzz.vzz59 = 'duedate'
          WHEN l_vlz.vlz59 = '2'     LET g_vzz.vzz59 = 'priority'
          WHEN l_vlz.vlz59 = '1,2'   LET g_vzz.vzz59 = 'duedate,priority'
          WHEN l_vlz.vlz59 = '2,1'   LET g_vzz.vzz59 = 'priority,duedate'
          OTHERWISE                  LET g_vzz.vzz59 = 'duedate,priority'
     END CASE
    #TQC-8B0042--mod---end---
     LET g_vzz.vzz60 = l_vlz.vlz60
     LET g_vzz.vzz61 = l_vlz.vlz61
     IF NOT cl_null(l_vlz.vlz62) THEN #TQC-860041 mod
         LET g_vzz.vzz62 = l_vlz.vlz62
     ELSE
         LET g_vzz.vzz62 = 'VTOP'
     END IF
     IF NOT cl_null(l_vlz.vlz63) THEN #TQC-860041 mod
         LET g_vzz.vzz63 = l_vlz.vlz63
     ELSE
         LET g_vzz.vzz63 = 'VTEQ'
     END IF
     LET g_vzz.vzz64 = l_vlz.vlz64
     LET g_vzz.vzz65 = l_vlz.vlz65
     LET g_vzz.vzz66 = l_vlz.vlz66
     LET g_vzz.vzz67 = l_vlz.vlz67
     IF NOT cl_null(l_vlz.vlz68) THEN #TQC-860041 mod
         LET g_vzz.vzz68 = l_vlz.vlz68
     ELSE
         LET g_vzz.vzz68 = 'VTR1'
     END IF
     IF NOT cl_null(l_vlz.vlz69) THEN #TQC-860041 mod
         LET g_vzz.vzz69 = l_vlz.vlz69
     ELSE
         LET g_vzz.vzz69 = 0
     END IF
     LET g_vzz.vzz70 = l_vlz.vlz70
    #TQC-8B0042--mod---str---
    #LET g_vzz.vzz71 = l_vlz.vlz71 #TQC-860041 add
     IF cl_null(l_vlz.vlz71) THEN LET l_vlz.vlz71 = '0,1' END IF
     CASE 
          WHEN l_vlz.vlz71 = '0'     LET g_vzz.vzz71 = 'OrderPriority'
          WHEN l_vlz.vlz71 = '1'     LET g_vzz.vzz71 = 'DemandDate'
          WHEN l_vlz.vlz71 = '0,1'   LET g_vzz.vzz71 = 'OrderPriority,DemandDate'
          WHEN l_vlz.vlz71 = '1,0'   LET g_vzz.vzz71 = 'DemandDate,OrderPriority'
          OTHERWISE                  LET g_vzz.vzz71 = 'OrderPriority,DemandDate'
     END CASE
    #TQC-8B0042--mod---end---
     LET g_vzz.vzz72 = l_vlz.vlz72 #TQC-860041 add
     LET g_vzz.vzz73 = l_vlz.vlz73 #TQC-8C0014 add
     LET g_vzz.vzz74 = l_vlz.vlz74 #TQC-8C0014 add
     LET g_vzz.vzz75 = l_vlz.vlz75 #TQC-8C0014 add
     LET g_vzz.vzz76 = l_vlz.vlz76 #FUN-910005 add

     #FUN-930127 ADD  --STR--
       IF  NOT cl_null(l_vlz.vlz77) THEN
           LET g_vzz.vzz77 = l_vlz.vlz77 
       ELSE
           LET g_vzz.vzz77 = 0
       END IF
       IF  NOT cl_null(l_vlz.vlz78) THEN
           LET g_vzz.vzz78 = l_vlz.vlz78
       ELSE
           LET g_vzz.vzz78 = 'MOD-'
       END IF

       CASE
         WHEN  l_vlz.vlz79 = 1   LET  g_vzz.vzz79 = 'SupplyTime'
         WHEN  l_vlz.vlz79 = 2   LET  g_vzz.vzz79 = 'AltPriority'
         WHEN  l_vlz.vlz79 = 3   LET  g_vzz.vzz79 = 'State'
         WHEN  l_vlz.vlz79 = 4   LET  g_vzz.vzz79 = 'AltPriority,State'
         WHEN  l_vlz.vlz79 = 5   LET  g_vzz.vzz79 = 'State,AltPriority'
         OTHERWISE               LET  g_vzz.vzz79 = 'SupplyTime'
       END CASE
        

       IF NOT cl_null(l_vlz.vlz80) THEN
          LET g_vzz.vzz80 = l_vlz.vlz80
       ELSE
          LET g_vzz.vzz80 = 0
       END IF
       IF NOT cl_null(l_vlz.vlz81) THEN
          LET g_vzz.vzz81 = l_vlz.vlz81
       ELSE
          LET g_vzz.vzz81 = 30
       END IF
 
       #FUN-940030  ADD  --STR----------------------
       IF NOT cl_null(l_vlz.vlz82) THEN
          LET g_vzz.vzz82 = l_vlz.vlz82
       ELSE
          LET g_vzz.vzz82 = 0
       END IF
       IF NOT cl_null(l_vlz.vlz83) THEN
          LET g_vzz.vzz83 = l_vlz.vlz83
       ELSE
          LET g_vzz.vzz83 = 0
       END IF
       #FUN-940030  ADD  --END---------------------

    #FUN-930127  ADD  --END--
      #FUN-B60084 mod---str---
       LET g_vzz.vzzlegal = g_legal
       LET g_vzz.vzzplant = g_plant
       #FUN-B50022 add---str---
       IF NOT cl_null(g_sma.sma541) AND (g_sma.sma541 MATCHES '[Yy]') THEN
           LET g_vzz.vzz92 = 1
       ELSE
           LET g_vzz.vzz92 = 0
       END IF
       IF NOT cl_null(g_sma.sma542) AND (g_sma.sma542 MATCHES '[Yy]') THEN
           LET g_vzz.vzz93 = 1
       ELSE
           LET g_vzz.vzz93 = 0
       END IF
       #FUN-B50022 add---end---
      #FUN-B60084 mod---end---
       LET g_vzz.vzz94 = l_vlz.vlz84  #FUN-BA0035 add  

    #TQC-8A0053---mod---str--
    #PUT p500_c_ins_vzz FROM g_vzz.*
     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
    #FUN-930161---mod---str---
    #PUT p500_c_ins_vzz FROM g_vzz.vzz00,
    #                        g_vzz.vzz01,g_vzz.vzz02,l_date_tmp1,g_vzz.vzz04,g_vzz.vzz05,g_vzz.vzz06,g_vzz.vzz07,g_vzz.vzz08,g_vzz.vzz09,g_vzz.vzz10,
    #                        g_vzz.vzz11,g_vzz.vzz12,g_vzz.vzz13,g_vzz.vzz14,g_vzz.vzz15,g_vzz.vzz16,g_vzz.vzz17,g_vzz.vzz18,g_vzz.vzz19,g_vzz.vzz20,
    #                        g_vzz.vzz21,g_vzz.vzz22,g_vzz.vzz23,g_vzz.vzz24,g_vzz.vzz25,g_vzz.vzz26,g_vzz.vzz27,g_vzz.vzz28,g_vzz.vzz29,g_vzz.vzz30,
    #                        g_vzz.vzz31,g_vzz.vzz32,g_vzz.vzz33,g_vzz.vzz34,g_vzz.vzz35,g_vzz.vzz36,g_vzz.vzz37,g_vzz.vzz38,g_vzz.vzz39,g_vzz.vzz40,
    #                        g_vzz.vzz41,g_vzz.vzz42,g_vzz.vzz43,g_vzz.vzz44,g_vzz.vzz45,g_vzz.vzz46,g_vzz.vzz47,g_vzz.vzz48,g_vzz.vzz49,g_vzz.vzz50,
    #                        g_vzz.vzz51,g_vzz.vzz52,g_vzz.vzz53,g_vzz.vzz54,g_vzz.vzz55,g_vzz.vzz56,g_vzz.vzz57,g_vzz.vzz58,g_vzz.vzz59,g_vzz.vzz60,
    #                        g_vzz.vzz61,g_vzz.vzz62,g_vzz.vzz63,g_vzz.vzz64,g_vzz.vzz65,g_vzz.vzz66,g_vzz.vzz67,g_vzz.vzz68,g_vzz.vzz69,g_vzz.vzz70,
    #                        g_vzz.vzz71,g_vzz.vzz72,g_vzz.vzz73,g_vzz.vzz74,g_vzz.vzz75, #TQC-8C0014 add vzz73,vzz74,vzz75
    #                        g_vzz.vzz76,  #FUN-910005  ADD
    #                        g_vzz.vzz77,g_vzz.vzz78,g_vzz.vzz79,g_vzz.vzz80,g_vzz.vzz81,  #FUN-930127 ADD
    #                        g_vzz.vzz84,g_vzz.vzz85,g_vzz.vzz86,g_vzz.vzz87,   #FUN-940030 ADD
    #                        g_vzz.vzz88,g_vzz.vzz89,g_vzz.vzz90,g_vzz.vzz91,   #FUN-940030 ADD
    #                        g_vzz.vzz82,g_vzz.vzz83  #FUN-940030 ADD 
     INSERT INTO vzz_file   (vzz00,vzz01,vzz02,vzz03,vzz04,
                             vzz05,vzz06,vzz07,vzz08,vzz09,
                             vzz10,vzz11,vzz12,vzz13,vzz14,
                             vzz15,vzz16,vzz17,vzz18,vzz19,
                             vzz20,vzz21,vzz22,vzz23,vzz24,
                             vzz25,vzz26,vzz27,vzz28,vzz29,
                             vzz30,vzz31,vzz32,vzz33,vzz34,
                             vzz35,vzz36,vzz37,vzz38,vzz39,
                             vzz40,vzz41,vzz42,vzz43,vzz44,
                             vzz45,vzz46,vzz47,vzz48,vzz49,
                             vzz50,vzz51,vzz52,vzz53,vzz54,
                             vzz55,vzz56,vzz57,vzz58,vzz59,
                             vzz60,vzz61,vzz62,vzz63,vzz64,
                             vzz65,vzz66,vzz67,vzz68,vzz69,
                             vzz70,vzz71,vzz72,vzz73,vzz74,
                             vzz75,vzz76,vzz77,vzz78,vzz79,
                             vzz80,vzz81,vzz82,vzz83,vzz84,
                             vzz85,vzz86,vzz87,vzz88,vzz89,
                             vzz90,vzz91,
                             vzzlegal,vzzplant,vzz92,vzz93,vzz94) #FUN-B60084 add #FUN-BA0035 add
     VALUES                 (g_vzz.vzz00,g_vzz.vzz01,g_vzz.vzz02,l_date_tmp1,g_vzz.vzz04,
                             g_vzz.vzz05,g_vzz.vzz06,g_vzz.vzz07,g_vzz.vzz08,g_vzz.vzz09,
                             g_vzz.vzz10,g_vzz.vzz11,g_vzz.vzz12,g_vzz.vzz13,g_vzz.vzz14,
                             g_vzz.vzz15,g_vzz.vzz16,g_vzz.vzz17,g_vzz.vzz18,g_vzz.vzz19,
                             g_vzz.vzz20,g_vzz.vzz21,g_vzz.vzz22,g_vzz.vzz23,g_vzz.vzz24,
                             g_vzz.vzz25,g_vzz.vzz26,g_vzz.vzz27,g_vzz.vzz28,g_vzz.vzz29,
                             g_vzz.vzz30,g_vzz.vzz31,g_vzz.vzz32,g_vzz.vzz33,g_vzz.vzz34,
                             g_vzz.vzz35,g_vzz.vzz36,g_vzz.vzz37,g_vzz.vzz38,g_vzz.vzz39,
                             g_vzz.vzz40,g_vzz.vzz41,g_vzz.vzz42,g_vzz.vzz43,g_vzz.vzz44,
                             g_vzz.vzz45,g_vzz.vzz46,g_vzz.vzz47,g_vzz.vzz48,g_vzz.vzz49,
                             g_vzz.vzz50,g_vzz.vzz51,g_vzz.vzz52,g_vzz.vzz53,g_vzz.vzz54,
                             g_vzz.vzz55,g_vzz.vzz56,g_vzz.vzz57,g_vzz.vzz58,g_vzz.vzz59,
                             g_vzz.vzz60,g_vzz.vzz61,g_vzz.vzz62,g_vzz.vzz63,g_vzz.vzz64,
                             g_vzz.vzz65,g_vzz.vzz66,g_vzz.vzz67,g_vzz.vzz68,g_vzz.vzz69,
                             g_vzz.vzz70,g_vzz.vzz71,g_vzz.vzz72,g_vzz.vzz73,g_vzz.vzz74,
                             g_vzz.vzz75,g_vzz.vzz76,g_vzz.vzz77,g_vzz.vzz78,g_vzz.vzz79,
                             g_vzz.vzz80,g_vzz.vzz81,g_vzz.vzz82,g_vzz.vzz83,g_vzz.vzz84,
                             g_vzz.vzz85,g_vzz.vzz86,g_vzz.vzz87,g_vzz.vzz88,g_vzz.vzz89,
                             g_vzz.vzz90,g_vzz.vzz91,
                             g_vzz.vzzlegal,g_vzz.vzzplant,g_vzz.vzz92,g_vzz.vzz93,g_vzz.vzz94) #FUN-B60084 add #FUN-BA0035 add
    #FUN-930161---mod---end---
 
    #TQC-8A0053---mod---end--
     IF STATUS THEN
        #LET g_msg = 'Key:',g_vzz.vzz00 CLIPPED,' + ',g_vzz.vzz01 CLIPPED,' + ',g_vzz.vzz02 CLIPPED  #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vzz00',g_vzz.vzz00,'vzz01',g_vzz.vzz01,'vzz02',g_vzz.vzz02,'','','','','','')   #FUN-940030 ADD
       #CALL err('vzz_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vzz_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD 
     END IF
     INITIALIZE g_vzz.* TO NULL
     INITIALIZE l_vlz.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vzz_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vzz_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vlz_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p500_vat()      
DEFINE l_sql            STRING                
DEFINE l_vmt            RECORD LIKE vmt_file.* 

  IF tm.vlb32  = 'N' THEN RETURN END IF

  DECLARE p500_vat_c CURSOR FOR 
   SELECT * FROM vmt_file

  INITIALIZE g_vat.* TO NULL
  INITIALIZE l_vmt.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vat_c INTO l_vmt.*   
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vat_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vat.vat01 = l_vmt.vmt01
     LET g_vat.vat02 = l_vmt.vmt02

     LET g_vat.vatplant = g_plant #FUN-B50022 add
     LET g_vat.vatlegal = g_legal #FUN-B50022 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vat FROM g_vat.*
     IF STATUS THEN
        #LET g_msg = 'Key:',g_vat.vat01 CLIPPED,' + ',  #FUN-940030 MARK
        #                   g_vat.vat02 CLIPPED         #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vat01',g_vat.vat01,'vat02',g_vat.vat02,'','','','','','','','')   #FUN-940030 ADD
       #CALL err('vat_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vat_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vat.* TO NULL
     INITIALIZE l_vmt.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add 
  CALL  err('vat_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vat_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vat_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p500_vah()   #APS供給法則
DEFINE l_sql            STRING                
DEFINE l_vmh            RECORD LIKE vmh_file.*

  IF tm.vlb20  = 'N' THEN RETURN END IF

  DECLARE p500_vah_c CURSOR FOR 
   SELECT * FROM vmh_file

  INITIALIZE g_vah.* TO NULL
  INITIALIZE l_vmh.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vah_c INTO l_vmh.*
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vah_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vah.vah01 = l_vmh.vmh01
     LET g_vah.vah02 = l_vmh.vmh02
     LET g_vah.vah03 = l_vmh.vmh03
     LET g_vah.vah04 = l_vmh.vmh04
     LET g_vah.vah05 = l_vmh.vmh05
     IF cl_null(g_vah.vah02) THEN
         LET g_vah.vah02 = 0
     END IF
     IF cl_null(g_vah.vah05) THEN
         LET g_vah.vah05 = 0
     END IF
     LET g_vah.vahlegal = g_legal #FUN-B50022 add
     LET g_vah.vahplant = g_plant #FUN-B50022 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vah FROM g_vah.*
     IF STATUS THEN
        #FUN-940030 MARK  --STR--
        #LET g_msg = 'Key:',g_vah.vah01 CLIPPED,' + ',
        #                   g_vah.vah02 CLIPPED,' + ',
        #                   g_vah.vah03 CLIPPED,' + ',
        #                   g_vah.vah04 CLIPPED
        #FUN-940030  MARK  --END--
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vah01',g_vah.vah01,'vah02',g_vah.vah02,'vah03',g_vah.vah03,'vah04',g_vah.vah04,'','','','')   #FUN-940030 ADD
       #CALL err('vah_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vah_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vah_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows 
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vah_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vah_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p500_val()      
DEFINE l_sql            STRING                
DEFINE l_vml            RECORD LIKE vml_file.* 

  IF tm.vlb24  = 'N' THEN RETURN END IF

  DECLARE p500_val_c CURSOR FOR 
   SELECT * FROM vml_file

  INITIALIZE g_val.* TO NULL
  INITIALIZE l_vml.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_val_c INTO l_vml.*   
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_val_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_val.val01 = l_vml.vml01
     LET g_val.val02 = l_vml.vml02
     LET g_val.val03 = l_vml.vml03
     LET g_val.val04 = l_vml.vml04
     LET g_val.val05 = l_vml.vml05  #FUN-910005 ADD
     LET g_val.vallegal = g_legal #FUN-B50022 add
     LET g_val.valplant = g_plant #FUN-B50022 add
     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_val FROM g_val.*
     IF STATUS THEN
        #FUN-940030  MARK   --STR--
        #LET g_msg = 'Key:',g_val.val01 CLIPPED,' + ',
        #                   g_val.val02 CLIPPED,' + ',
        #                   g_val.val03 CLIPPED,' + ',
        #                   g_val.val04 CLIPPED,' + ',
        #                   g_val.val05 CLIPPED    #FUN-910005 ADD
        #FUN-940030  MARK   --END--
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('val01',g_val.val01,'val02',g_val.val02,'val03',g_val.val03,'val04',g_val.val04,'val05',g_val.val05,'','')   #FUN-940030 ADD
       #CALL err('val_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('val_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_val.* TO NULL
     INITIALIZE l_vml.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('val_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('val_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_val_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p500_vbb()      
DEFINE l_sql            STRING                
DEFINE l_vnb            RECORD LIKE vnb_file.* 

  IF tm.vlb41  = 'N' THEN RETURN END IF

  DECLARE p500_vbb_c CURSOR FOR 
   SELECT * FROM vnb_file

  INITIALIZE g_vbb.* TO NULL
  INITIALIZE l_vnb.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vbb_c INTO l_vnb.*   
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vbb_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vbb.vbb01 = l_vnb.vnb01
     LET g_vbb.vbb02 = l_vnb.vnb02
     LET g_vbb.vbb03 = l_vnb.vnb03
     LET g_vbb.vbb04 = l_vnb.vnb04
     LET g_vbb.vbb05 = l_vnb.vnb05
     LET g_vbb.vbb06 = l_vnb.vnb06
     LET g_vbb.vbb07 = l_vnb.vnb07
     LET g_vbb.vbb08 = l_vnb.vnb08
     LET g_vbb.vbb09 = l_vnb.vnb09
     LET g_vbb.vbblegal = g_legal #FUN-B50022 add
     LET g_vbb.vbbplant = g_plant #FUN-B50022 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vbb FROM g_vbb.*
     IF STATUS THEN
        #LET g_msg = 'Key:',g_vbb.vbb01 CLIPPED, ' + ',  #FUN-940030 MARK
        #                   g_vbb.vbb03 CLIPPED          #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vbb01',g_vbb.vbb01,'vbb03',g_vbb.vbb03,'','','','','','','','')   #FUN-940030 ADD
       #CALL err('vbb_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vbb_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vbb.* TO NULL
     INITIALIZE l_vnb.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vbb_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vbb_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vbb_c:',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p500_vab()      #日行事曆
DEFINE l_sql            STRING                
DEFINE l_vmb            RECORD LIKE vmb_file.*

  IF tm.vlb12  = 'N' THEN RETURN END IF

  DECLARE p500_vmb_c CURSOR FOR 
    SELECT * FROM vmb_file

  INITIALIZE g_vab.* TO NULL
  INITIALIZE l_vmb.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vmb_c INTO l_vmb.*   
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vmb_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vab.vab01 = l_vmb.vmb01
     IF NOT cl_null(l_vmb.vmb02) THEN
        LET g_vab.vab02 = l_vmb.vmb02
     END IF
     LET g_vab.vab03 = l_vmb.vmb03
     LET g_vab.vablegal = g_legal #FUN-B50022 add
     LET g_vab.vabplant = g_plant #FUN-B50022 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vab FROM g_vab.*
     IF STATUS THEN
        #LET g_msg = 'Key:',g_vab.vab01 CLIPPED,' + ',g_vab.vab02  #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vab01',g_vab.vab01,'vab02',g_vab.vab02,'','','','','','','','')   #FUN-940030 ADD
       #CALL err('vab_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vab_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vab.* TO NULL
     INITIALIZE l_vmb.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vab_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vab_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vmb_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p500_vad_2()    #資源--工作站(aeci600)

  IF tm.vlb16  = 'N' THEN RETURN END IF
 
  DECLARE p500_vad_2_c CURSOR FOR
     SELECT eca01,vmj02,vmj03,vmj04,eca02,eca02,vmj07,eca12/100,eca01
       FROM eca_file,OUTER vmj_file
      WHERE eca01 = vmj_file.vmj01

  INITIALIZE g_vad.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vad_2_c INTO g_vad.*
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vad_2_c:',STATUS,1) EXIT FOREACH
     END IF
     IF cl_null(g_vad.vad04) THEN
         LET g_vad.vad04 = 0
     END IF
     IF cl_null(g_vad.vad07) THEN
         LET g_vad.vad07 = 0
     END IF
     IF cl_null(g_vad.vad08) THEN
         LET g_vad.vad08 = 1 
     END IF
     LET g_vad.vadlegal = g_legal #FUN-B50022 add
     LET g_vad.vadplant = g_plant #FUN-B50022 add
     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vad  FROM g_vad.*
     IF STATUS THEN
        #LET g_msg='Key:',g_vad.vad01  #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vad01',g_vad.vad01,'','','','','','','','','','')   #FUN-940030 ADD
       #CALL err('vad_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vad_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vad.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vad_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vad_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vad_2_c:',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p500_vad_1()    #資源--機器(aeci670)

  IF tm.vlb16  = 'N' THEN RETURN END IF
 
  DECLARE p500_vad_1_c CURSOR FOR
     SELECT eci01,vmd02,vmd03,vmd04,eci06,eci06,vmd07,vmd08/100,eci03
       FROM eci_file,OUTER vmd_file
      WHERE eci01 = vmd_file.vmd01

  INITIALIZE g_vad.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vad_1_c INTO g_vad.*
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vad_1_c:',STATUS,1) EXIT FOREACH
     END IF
     IF cl_null(g_vad.vad04) THEN
         LET g_vad.vad04 = 0
     END IF
     IF cl_null(g_vad.vad07) THEN
         LET g_vad.vad07 = 0
     END IF
     IF cl_null(g_vad.vad08) THEN
         LET g_vad.vad08 = 1 
     END IF
     LET g_vad.vadlegal = g_legal #FUN-B50022 add
     LET g_vad.vadplant = g_plant #FUN-B50022 add
     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vad  FROM g_vad.*
     IF STATUS THEN
        #LET g_msg='Key:',g_vad.vad01  #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vad01',g_vad.vad01,'','','','','','','','','','')   #FUN-940030 ADD
       #CALL err('vad_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vad_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vad.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vad_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vad_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vad:',STATUS,1) RETURN END IF
END FUNCTION

 
FUNCTION p500_vae_1()      #資源群組--機器
DEFINE l_sql            STRING
DEFINE l_vme            RECORD LIKE vme_file.*

  IF tm.vlb17   = 'N' THEN RETURN END IF

  DECLARE p500_vae_1_c CURSOR FOR
     SELECT *  FROM vme_file WHERE 1=1

  INITIALIZE g_vae.* TO NULL
  INITIALIZE l_vme.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vae_1_c INTO l_vme.*
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vae_1_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vae.vae01 = l_vme.vme01
     LET g_vae.vae02 = l_vme.vme02
     LET g_vae.vaelegal = g_legal #FUN-B50022 add
     LET g_vae.vaeplant = g_plant #FUN-B50022 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vae  FROM g_vae.*
     IF STATUS THEN
        #LET g_msg='Key:',g_vae.vae01 CLIPPED,' + ',g_vae.vae02 CLIPPED  #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vae01',g_vae.vae01,'vae02',g_vae.vae02,'','','','','','','','')   #FUN-940030 ADD
       #CALL err('vae_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vae_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vae.* TO NULL
     INITIALIZE l_vme.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vae_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vae_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vae_1_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p500_vae_2()      #資源群組--工作站
DEFINE l_sql            STRING
DEFINE l_vmp            RECORD LIKE vmp_file.*

  IF tm.vlb17   = 'N' THEN RETURN END IF

  DECLARE p500_vae_2_c CURSOR FOR
     SELECT *  FROM vmp_file WHERE 1=1

  INITIALIZE g_vae.* TO NULL
  INITIALIZE l_vmp.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vae_2_c INTO l_vmp.*
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vae_2_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vae.vae01 = l_vmp.vmp01
     LET g_vae.vae02 = l_vmp.vmp02
     LET g_vae.vaelegal = g_legal #FUN-B50022 add
     LET g_vae.vaeplant = g_plant #FUN-B50022 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vae  FROM g_vae.*
     IF STATUS THEN
        #LET g_msg='Key:',g_vae.vae01 CLIPPED,' + ',g_vae.vae02 CLIPPED  #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vae01',g_vae.vae01,'vae02',g_vae.vae02,'','','','','','','','')   #FUN-940030 ADD
       #CALL err('vae_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vae_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vae.* TO NULL
     INITIALIZE l_vmp.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vae_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vae_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vae_2_c:',STATUS,1) RETURN END IF
END FUNCTION

 
FUNCTION p500_vai()      #料件主檔
DEFINE l_sql            STRING
DEFINE l_vmi            RECORD LIKE vmi_file.*
DEFINE l_ima   	        RECORD LIKE ima_file.*
DEFINE l_pmc03          LIKE pmc_file.pmc03
DEFINE l_pmh04          LIKE pmh_file.pmh04
DEFINE l_pmh07          LIKE pmh_file.pmh07
#DEFINE l_pmh_rowid      LIKE type_file.chr18  #FUN-B50022 mark
DEFINE l_pmh01          LIKE pmh_file.pmh01    #FUN-B50022 add
DEFINE l_pmh02          LIKE pmh_file.pmh02    #FUN-B50022 add
DEFINE l_pmh13          LIKE pmh_file.pmh13    #FUN-B50022 add
DEFINE l_pmh21          LIKE pmh_file.pmh21    #FUN-B50022 add
DEFINE l_pmh22          LIKE pmh_file.pmh22    #FUN-B50022 add
DEFINE l_pmh23          LIKE pmh_file.pmh23    #FUN-B50022 add
#DEFINE g_vla02          LIKE vla_file.vla02   #FUN-940030 MARK
DEFINE l_sw1            LIKE type_file.num5    #FUN-B10015(3) add
DEFINE l_sw2            LIKE type_file.num5    #FUN-B10015(3) add
DEFINE l_sw3            LIKE type_file.num5    #FUN-B10015(3) add
DEFINE l_vlq_vai        LIKE type_file.num5    #FUN-BC0040 add

  IF tm.vlb21   = 'N' THEN RETURN END IF
  
  LET l_sql = "SELECT ima_file.*,vmi_file.* ",
              "  FROM ima_file,OUTER vmi_file",
              " WHERE ima01 = vmi_file.vmi01 ",
              "   AND imaacti = 'Y' "
  IF NOT cl_null(g_vla.vla02) THEN
     #LET l_sql = l_sql CLIPPED," AND imadate >= '",g_vla.vla02,"'" #基本資料最後異動日 #FUN-BC0040 mark
      #FUN-BC0040---add-----str---
      SELECT COUNT(*) INTO l_vlq_vai
        FROM vlq_file
       WHERE vlq01 = tm.vlb01 
         AND vlq02 = g_vla.vla02
         AND vlq03 = '1' #p500_vai()
      IF l_vlq_vai >=1 THEN
          LET l_sql = l_sql CLIPPED," AND (imadate >= '",g_vla.vla02,"'" ,#基本資料最後異動日 
                                    " OR ima01 IN (SELECT vlq04 FROM vlq_file ",
                                    "               WHERE vlq01 = '",tm.vlb01,"'",
                                    "                 AND vlq02 = '",g_vla.vla02,"'",
                                    "                 AND vlq03 = '1' ))" #p500_vai()
      ELSE
          LET l_sql = l_sql CLIPPED," AND imadate >= '",g_vla.vla02,"'" #基本資料最後異動日 
      END IF
      #FUN-BC0040---add-----end---
  END IF

  PREPARE p500_vai_p FROM l_sql
  IF STATUS THEN CALL cl_err('pre p500_vai_p',STATUS,1) END IF
  DECLARE p500_vai_c CURSOR FOR p500_vai_p
  IF STATUS THEN CALL cl_err('dec p500_vai_c',STATUS,1) END IF

  INITIALIZE g_vai.* TO NULL
  INITIALIZE l_ima.* TO NULL
  INITIALIZE l_vmi.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vai_c INTO l_ima.*,l_vmi.*   
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vai_c:',STATUS,1) EXIT FOREACH
     END IF
     #vai01
     LET g_vai.vai01      = l_ima.ima01
     #vai02
     IF NOT cl_null(l_ima.ima27) THEN
        LET g_vai.vai02   = l_ima.ima27
     ELSE
        LET g_vai.vai02   = 0
     END IF
     #vai03
     IF NOT cl_null(l_vmi.vmi03) THEN
        LET g_vai.vai03   = l_vmi.vmi03
     ELSE
        LET g_vai.vai03   = 0
     END IF
     #vai04
     IF NOT cl_null(l_vmi.vmi04) THEN
        LET g_vai.vai04   = l_vmi.vmi04
     ELSE
        LET g_vai.vai04   = 0
     END IF
     #vai05
     IF NOT cl_null(l_vmi.vmi05) THEN
        LET g_vai.vai05   = l_vmi.vmi05
     ELSE
        LET g_vai.vai05   = 0
     END IF
     #vai06
     IF NOT cl_null(l_ima.ima08) AND l_ima.ima08 MATCHES '[PVZ]' THEN
         LET g_vai.vai06 = 2
     ELSE
         LET g_vai.vai06 = 1
     END IF
     #vai07
     IF NOT cl_null(l_ima.ima25) THEN
         LET g_vai.vai07 = l_ima.ima25
     ELSE
         LET g_vai.vai07 = 'PCS'  #mandy?
     END IF
     LET g_vai.vai02 = s_digqty(g_vai.vai02,g_vai.vai07)  #FUN-BB0085
     #vai08
     IF NOT cl_null(l_vmi.vmi08) THEN
        LET g_vai.vai08 = l_vmi.vmi08
     ELSE
        LET g_vai.vai08 = 999999
     END IF
     #vai09/vai10/vai20
     IF l_ima.ima08 MATCHES '[PVZ]' THEN
         LET g_vai.vai09 = l_ima.ima46
         LET g_vai.vai10 = l_ima.ima45
         LET g_vai.vai20 = l_ima.ima48+l_ima.ima49+l_ima.ima491+l_ima.ima50  #(天)   #FUN-930127 MARK
         LET g_vai.vai20 = l_ima.ima48+l_ima.ima49+l_ima.ima50  #FUN-930127 ADD
     ELSE 
         LET g_vai.vai09 = l_ima.ima561
         LET g_vai.vai10 = l_ima.ima56
         LET g_vai.vai20 = l_ima.ima59 + l_ima.ima61    #(天) 
     END IF
     IF cl_null(g_vai.vai09) THEN
         LET g_vai.vai09 = 0
     END IF
     IF cl_null(g_vai.vai10) THEN
         LET g_vai.vai10 = 1
     END IF
     IF cl_null(g_vai.vai20) THEN
         LET g_vai.vai10 = 0
     END IF
     #vai11
     IF NOT cl_null(l_vmi.vmi11) THEN
         LET g_vai.vai11 = l_vmi.vmi11
     ELSE
         LET g_vai.vai11 = 0
     END IF
     #vai12
    #IF l_ima.ima08 = 'X' THEN           #FUN-A60036 mark
    #IF l_ima.ima08 MATCHES '[XK]' THEN  #FUN-A60036 add  #FUN-C30309 mark
     IF l_ima.ima08 MATCHES '[XKCD]' THEN  #FUN-A60036 add  #FUN-C30309 add
        LET g_vai.vai12 = 1
     ELSE
        LET g_vai.vai12 = 0
     END IF
     #vai13
     LET g_vai.vai13 = l_ima.ima021 CLIPPED
     #vai14
#    LET g_vai.vai14 = l_ima.ima64                    #FUN-BB0143 mark
     LET g_vai.vai14 = l_ima.ima64 * l_ima.ima63_fac  #FUN-BB0143 add
     IF cl_null(g_vai.vai14) THEN
         LET g_vai.vai14 = 1
     END IF
     LET g_vai.vai14 = s_digqty(g_vai.vai14,g_vai.vai07)    #FUN-BB0085
     #vai15
     IF NOT cl_null(l_vmi.vmi15) THEN
         LET g_vai.vai15 = l_vmi.vmi15
     ELSE
         LET g_vai.vai15 = 0
     END IF
     #vai16
     IF NOT cl_null(l_vmi.vmi16) THEN
         LET g_vai.vai16 = l_vmi.vmi16
     ELSE
        #LET g_vai.vai16 = 0   #TQC-8B0041
         LET g_vai.vai16 = 999 #TQC-8B0041
     END IF
     #vai17
     IF NOT cl_null(l_vmi.vmi17) THEN
         LET g_vai.vai17 = l_vmi.vmi17
     ELSE
        #LET g_vai.vai17 = 0    #TQC-8B0041
         LET g_vai.vai17 = 999  #TQC-8B0041
     END IF
     #vai18
     LET g_vai.vai18 = l_ima.ima02
     #vai19
     IF NOT cl_null(l_vmi.vmi19) THEN
         LET g_vai.vai19 = l_vmi.vmi19
     ELSE
         LET g_vai.vai19 = 0
     END IF
     #vai21
     IF NOT cl_null(l_vmi.vmi21) THEN
         LET g_vai.vai21 = l_vmi.vmi21
     ELSE
         LET g_vai.vai21 = 0
     END IF
     #vai22
     IF NOT cl_null(l_vmi.vmi22) THEN
         LET g_vai.vai22 = l_vmi.vmi22
     ELSE
         LET g_vai.vai22 = 0
     END IF
     #vai23
     IF NOT cl_null(l_vmi.vmi23) THEN
         LET g_vai.vai23 = l_vmi.vmi23
     ELSE
         LET g_vai.vai23 = 0
     END IF
     #vai24
     IF NOT cl_null(l_vmi.vmi24) THEN
         LET g_vai.vai24 = l_vmi.vmi24
     ELSE
         LET g_vai.vai24 = 1
     END IF
     LET g_vai.vai25 = l_vmi.vmi25
     #vai26~vai34
     LET g_vai.vai26 = l_ima.ima67
     LET g_vai.vai27 = l_ima.ima43
     LET g_vai.vai28 = l_vmi.vmi28
     LET g_vai.vai29 = l_ima.ima44
     LET g_vai.vai09 = s_digqty(g_vai.vai09,g_vai.vai29)    #FUN-BB0085
     LET g_vai.vai10 = s_digqty(g_vai.vai10,g_vai.vai29)    #FUN-BB0085
    #LET g_vai.vai30 = l_ima.ima44_fac #FUN-B10015(3) mark
     LET g_vai.vai31 = l_ima.ima55
    #LET g_vai.vai32 = l_ima.ima55_fac #FUN-B10015(3) mark
     LET g_vai.vai33 = l_ima.ima31
    #LET g_vai.vai34 = l_ima.ima31_fac #FUN-B10015(3) mark
     #FUN-B10015(3) add---str---
     LET l_sw1 = 0
     LET l_sw2 = 0
     LET l_sw3 = 0
     #vai30
     IF l_ima.ima44 = l_ima.ima25 THEN
         LET g_vai.vai30 = 1
     ELSE
         CALL s_umfchk(l_ima.ima01,l_ima.ima44,l_ima.ima25)
              RETURNING l_sw1,g_vai.vai30
         IF l_sw1 = 1 THEN
             LET g_vai.vai30 = 1
         END IF
     END IF

     #vai32
     IF l_ima.ima55 = l_ima.ima25 THEN
         LET g_vai.vai32 = 1
     ELSE
         CALL s_umfchk(l_ima.ima01,l_ima.ima55,l_ima.ima25)
              RETURNING l_sw2,g_vai.vai32
         IF l_sw2 = 1 THEN
             LET g_vai.vai32 = 1
         END IF
     END IF

     #vai34
     IF l_ima.ima31 = l_ima.ima25 THEN
         LET g_vai.vai34 = 1
     ELSE
         CALL s_umfchk(l_ima.ima01,l_ima.ima31,l_ima.ima25)
              RETURNING l_sw3,g_vai.vai34
         IF l_sw3 = 1 THEN
             LET g_vai.vai34 = 1
         END IF
     END IF
     #FUN-B10015(3) add---end---

     #vai35
     IF NOT cl_null(l_vmi.vmi35) THEN
         LET g_vai.vai35 = l_vmi.vmi35
     ELSE
         LET g_vai.vai35 = 0
     END IF
     #vai36
     LET g_vai.vai36 = l_vmi.vmi36
     #vai37
     IF NOT cl_null(l_vmi.vmi37) THEN
         LET g_vai.vai37 = l_vmi.vmi37
     ELSE
         LET g_vai.vai37 = 7
     END IF
     #vai38
     IF NOT cl_null(l_vmi.vmi38) THEN
         LET g_vai.vai38 = l_vmi.vmi38
     ELSE
         LET g_vai.vai38 = 0
     END IF
     #vai39/vai40
     LET g_vai.vai39 = l_ima.ima67                  
     LET g_vai.vai40 = l_vmi.vmi40
     #只為了找到pmh_file相對應中的任何一筆就OK-------str--
     LET l_pmh04 = NULL
     LET l_pmh07 = NULL
    #FUN-B50022---mod---str---
    #LET l_pmh_rowid = NULL
    #SELECT MIN(ROWID) INTO l_pmh_rowid FROM pmh_file
    # WHERE pmh01 = l_ima.ima01
    #   AND pmh02 = l_ima.ima54
    #   AND pmhacti = 'Y'                                           #CHI-910021
    #SELECT pmh04,pmh07 INTO l_pmh04,l_pmh07
    #  FROM pmh_file
    # WHERE ROWID = l_pmh_rowid
    #   AND pmhacti = 'Y'                                           #CHI-910021

     SELECT MAX(pmh01),MAX(pmh02),MAX(pmh13),MAX(pmh21),MAX(pmh22),MAX(pmh23) 
       INTO l_pmh01,l_pmh02,l_pmh13,l_pmh21,l_pmh22,l_pmh23
       FROM pmh_file
      WHERE pmh01 = l_ima.ima01
        AND pmh02 = l_ima.ima54
        AND pmhacti = 'Y'                                           #CHI-910021
     SELECT pmh04,pmh07 INTO l_pmh04,l_pmh07
       FROM pmh_file
      WHERE pmh01 = l_pmh01
        AND pmh02 = l_pmh02
        AND pmh13 = l_pmh13
        AND pmh21 = l_pmh21
        AND pmh22 = l_pmh22
        AND pmh23 = l_pmh23
        AND pmhacti = 'Y'                                           #CHI-910021
    #FUN-B50022---mod---end---
     #vai41/vai42/vai43
     LET g_vai.vai41 = l_pmh07   
     LET g_vai.vai42 = l_ima.ima07                       
     LET g_vai.vai43 = l_pmh04    
     #-----------------------------------------------end--
     #vai44/vai45
     LET g_vai.vai44 = l_vmi.vmi44
     LET g_vai.vai45 = l_vmi.vmi45
     #vai46
     LET l_pmc03 = NULL    
     SELECT pmc03 INTO l_pmc03 
       FROM pmc_file
      WHERE pmc01 = l_ima.ima54
     LET g_vai.vai46 = l_pmc03                        
     #vai47
     LET g_vai.vai47 = l_vmi.vmi47
     IF cl_null(g_vai.vai47) THEN LET g_vai.vai47 = 0 END IF
     #vai48
     LET g_vai.vai48 = l_ima.ima53
     IF cl_null(g_vai.vai48) THEN LET g_vai.vai48 = 0 END IF
     #vai49
     LET g_vai.vai49 = l_vmi.vmi49
     IF cl_null(g_vai.vai49) THEN LET g_vai.vai49 = 5 END IF  #TQC-8A0053 mod
     #vai50
     LET g_vai.vai50 = l_vmi.vmi50
     IF cl_null(g_vai.vai50) THEN LET g_vai.vai50 = 10 END IF #TQC-8A0053 mod
     #vai51~vai57
     LET g_vai.vai51 = l_vmi.vmi51
     LET g_vai.vai52 = l_vmi.vmi52
     LET g_vai.vai53 = l_vmi.vmi53
     LET g_vai.vai54 = l_vmi.vmi54
     LET g_vai.vai55 = l_vmi.vmi55
     #FUN-870071---add---str--
     IF NOT cl_null(l_vmi.vmi56) THEN
         LET g_vai.vai56 = l_vmi.vmi56
     ELSE
         LET g_vai.vai56 = 0
     END IF
     #FUN-870071---add---end--

     LET g_vai.vai57 = 1  #TQC-8B0041
    #FUN-960073---mod---str---
    #IF NOT cl_null(l_ima.ima56) AND l_ima.ima56 > 0 THEN
    #    #vai58
    #   #LET g_vai.vai58 = ((l_ima.ima59 + l_ima.ima61)/l_ima.ima56)*24*60*60 #TQC-870043 mark
    #    LET g_vai.vai58 = ((l_ima.ima59 + l_ima.ima61))*24*60*60             #TQC-870043 mod 不需再除生產單位批量(ima56),因為此值為一固定時間，不因加工批量大小而不同
    #    #vai59
    #    #LET g_vai.vai59 = (l_ima.ima60/l_ima.ima56)*24*60*60              #No:FUN-840194
    #    LET g_vai.vai59 = (l_ima.ima60/l_ima.ima601/l_ima.ima56)*24*60*60  #No:FUN-840194
    #ELSE
    #    LET g_vai.vai58 = 0
    #    LET g_vai.vai59 = 0
    #END IF
     LET g_vai.vai58 = ((l_ima.ima59 + l_ima.ima61))*24*60*60            

     IF NOT cl_null(l_ima.ima601) AND l_ima.ima601 > 0 THEN
         LET g_vai.vai59 = (l_ima.ima60/l_ima.ima601)*24*60*60  
     ELSE
         LET g_vai.vai59 = 0
     END IF
    #FUN-960073---mod---end---
     IF cl_null(g_vai.vai58) THEN LET g_vai.vai58 = 0 END IF
     IF cl_null(g_vai.vai59) THEN LET g_vai.vai59 = 0 END IF
     #vai60
     LET g_vai.vai60 = l_vmi.vmi60
     IF cl_null(g_vai.vai60) THEN LET g_vai.vai60 = 0 END IF
     #vai61
     LET g_vai.vai61 = 1
     #vai62
     LET g_vai.vai62 = l_ima.ima56
     IF cl_null(g_vai.vai62) THEN LET g_vai.vai62 = 9999 END IF
     #vai63
     #TQC-870043---mod---str--
     IF NOT cl_null(l_ima.ima571) THEN
         IF NOT cl_null(l_ima.ima94) THEN
             LET g_vai.vai63 = l_ima.ima571 CLIPPED,'-',l_ima.ima94 CLIPPED 
         ELSE
             #抓產品製程內第一筆(任何一筆)資料
             SELECT MIN(ecu02) 
               INTO l_ima.ima94
               FROM ecu_file
              WHERE ecu01 = l_ima.ima571
             LET g_vai.vai63 = l_ima.ima571 CLIPPED,'-',l_ima.ima94 CLIPPED
         END IF
     ELSE
         IF NOT cl_null(l_ima.ima94) THEN
             LET g_vai.vai63 = l_ima.ima01 CLIPPED,'-',l_ima.ima94 CLIPPED
         ELSE
             #抓產品製程內第一筆(任何一筆)資料
             SELECT MIN(ecu02) 
               INTO l_ima.ima94
               FROM ecu_file
              WHERE ecu01 = l_ima.ima01
             LET g_vai.vai63 = l_ima.ima01 CLIPPED,'-',l_ima.ima94 CLIPPED 
         END IF
     END IF
     #TQC-870043---mod---end--
     #vai64
     IF NOT cl_null(l_vmi.vmi64) THEN
         LET g_vai.vai64 = l_vmi.vmi64
     ELSE
         LET g_vai.vai64 = 0
     END IF

     #FUN-930087  ADD  --STR-------------------------------
      IF NOT cl_null(l_vmi.vmi65) THEN
         LET g_vai.vai65 = l_vmi.vmi65
      ELSE
         LET g_vai.vai65 = 0
      END IF
     #FUN-930087  ADD  --END-------------------------------
 
     #FUN-930127  ADD  --STR--
       LET g_vai.vai66 = l_ima.ima54  
       IF NOT cl_null(l_ima.ima491) THEN
          LET g_vai.vai67 = l_ima.ima491
       ELSE
          LET g_vai.vai67 = 0
       END IF
       IF l_ima.ima08='S' THEN
          LET g_vai.vai68 = 1
       ELSE 
           LET g_vai.vai68 = 0
       END IF
     #FUN-930127   ADD  --END-- 
     #FUN-A40017---add----str---
     #FUN-A80075--mod--str--
     #0:需跑MRP,  1:不跑MRP
     IF NOT cl_null(l_ima.ima37) AND l_ima.ima37 = '2' THEN
        #LET g_vai.vai72 = 1 #需跑MRP
         LET g_vai.vai72 = 0 #需跑MRP
     ELSE
        #LET g_vai.vai72 = 0 #不需跑MRP
         LET g_vai.vai72 = 1 #不需跑MRP
     END IF
     IF NOT cl_null(l_ima.ima08) AND l_ima.ima08 = 'D' THEN
        #LET g_vai.vai72 = 0 #不需跑MRP
         LET g_vai.vai72 = 1 #不需跑MRP
     END IF
     #FUN-A80075--mod--end--
     #FUN-A40017---add----end---
     LET g_vai.vailegal = g_legal #FUN-B50022 add
     LET g_vai.vaiplant = g_plant #FUN-B50022 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     #FUN-B10015(3)--add---str---
     IF l_sw1=1 OR l_sw2=1 OR l_sw3=1 THEN
         #FUN-BC0040----add-----str----
         INSERT INTO vlq_file(vlq01,vlq02,vlq03,vlq04,vlq05,vlqlegal,vlqplant)
              VALUES(tm.vlb01,'1999/12/31','1',g_vai.vai01,' ',g_legal,g_plant)
         IF SQLCA.SQLCODE !=0 AND NOT cl_sql_dup_value(SQLCA.SQLCODE) THEN 
             CALL cl_err3("ins","vlq_file",g_vai.vai01,'1:p500_vai()',SQLCA.SQLCODE,"","ins vlq_file fail:1",1)  
         END IF
         #FUN-BC0040----add-----end----
         IF l_sw1=1 THEN
             CALL p500_getmsg('vai01',g_vai.vai01,'ima44',l_ima.ima44,'ima25',l_ima.ima25,'','','','','','')  
             CALL err('vai_file',g_msg,'aps-533','2') #採購單位對庫存單位無換算率
         END IF
         IF l_sw2=1 THEN
             CALL p500_getmsg('vai01',g_vai.vai01,'ima55',l_ima.ima55,'ima25',l_ima.ima25,'','','','','','')  
             CALL err('vai_file',g_msg,'aps-534','2') #生產單位對庫存單位無換算率
         END IF
         IF l_sw3=1 THEN
             CALL p500_getmsg('vai01',g_vai.vai01,'ima31',l_ima.ima31,'ima25',l_ima.ima25,'','','','','','')  
             CALL err('vai_file',g_msg,'aps-535','2') #銷售單位對庫存單位無換算率
         END IF
         LET g_erows = g_erows + 1   
     ELSE
     #FUN-B10015(3)--add---end---
         PUT p500_c_ins_vai  FROM g_vai.*
         IF STATUS THEN
            #LET g_msg='Key:',g_vai.vai01  #FUN-940030 MARK
            LET g_status = STATUS                    #TQC-B70094 add
            CALL p500_getmsg('vai01',g_vai.vai01,'','','','','','','','','','')   #FUN-940030 ADD
           #CALL err('vai_file',g_msg,STATUS,'2')    #TQC-B70094 mark
            CALL err('vai_file',g_msg,g_status,'2')  #TQC-B70094 add
            LET g_erows = g_erows + 1   #FUN-940030  ADD
            #FUN-BC0040----add-----str----
            INSERT INTO vlq_file(vlq01,vlq02,vlq03,vlq04,vlq05,vlqlegal,vlqplant)
                 VALUES(tm.vlb01,'1999/12/31','1',g_vai.vai01,' ',g_legal,g_plant)
            IF SQLCA.SQLCODE !=0 AND NOT cl_sql_dup_value(SQLCA.SQLCODE) THEN 
                CALL cl_err3("ins","vlq_file",g_vai.vai01,'1:p500_vai()',SQLCA.SQLCODE,"","ins vlq_file fail:1",1)  
            END IF
            #FUN-BC0040----add-----end----
         END IF
     END IF #FUN-B10015 add
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vai_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vai_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vai_c:',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p500_vao()      #BOM
DEFINE l_sql            STRING       
DEFINE l_ecb03          LIKE ecb_file.ecb03
DEFINE l_vmo   	        RECORD LIKE vmo_file.*  
DEFINE l_bmb   	        RECORD LIKE bmb_file.*  
DEFINE l_flag           LIKE type_file.num5       #FUN-9A0038 add
DEFINE l_factor         LIKE type_file.num26_10   #FUN-9A0038 add
DEFINE l_ima25          LIKE ima_file.ima25       #FUN-9A0038 add
DEFINE l_bmb01_ima25    LIKE ima_file.ima25       #MOD-B10140 add
DEFINE l_bmb01_ima55    LIKE ima_file.ima55       #MOD-B10140 add
DEFINE l_factor_2       LIKE type_file.num26_10   #MOD-B10140 add
DEFINE l_flag2          LIKE type_file.num5       #MOD-B10140 add
DEFINE l_vlq_vao        LIKE type_file.num5    #FUN-BC0040 add

  IF tm.vlb27  = 'N' THEN RETURN END IF
#FUN-B50022----mod----str----
#  LET l_sql = 
# "SELECT bmb_file.*,vmo_file.* ",
# #"  FROM bmb_file,bma_file, OUTER vmo_file ",  #CHI-940025 MARK
#  "  FROM bmb_file,bma_file, vmo_file ",  #CHI-940025 ADD
# "  ,(SELECT bmb01 mbmb01,bmb02 mbmb02,max(bmb04) mbmb04 FROM bmb_file GROUP BY bmb01,bmb02) bmb2_file ", #TQC-930117 ADD
# " WHERE bmb01 = vmo_file.vmo01(+) ",
# "   AND bmb03 = vmo_file.vmo02(+) ",
# "   AND bmb02 = vmo_file.vmo03(+) ",
# "   AND bmb01 = mbmb01 AND bmb02=mbmb02 AND bmb04=mbmb04 ",  #TQC-930117 ADD
##"   AND (bmb04 <= '",g_today,"'"," OR bmb04 IS NULL) ",      #FUN-990090 mark 不判斷生效日
# "   AND (bmb05 >  '",g_today,"'"," OR bmb05 IS NULL) ",
# "   AND bmb01 = bma01 ",
# "   AND bmb29 = bma06 ",
# "   AND bmb29 = ' '   ", #無特性BOM功能
# "   AND bmaacti = 'Y' "
   LET l_sql = 
  "SELECT bmb_file.*,vmo_file.* ",
  "  FROM bma_file,bmb_file ",  #CHI-940025 ADD
  "  LEFT OUTER JOIN vmo_file ON bmb01 = vmo01 AND bmb03 = vmo02 AND bmb02 = vmo03 ",
  "  ,(SELECT bmb01 mbmb01,bmb02 mbmb02,max(bmb04) mbmb04 FROM bmb_file GROUP BY bmb01,bmb02) bmb2_file ", #TQC-930117 ADD
  " WHERE bmb01 = mbmb01 AND bmb02=mbmb02 AND bmb04=mbmb04 ",  #TQC-930117 ADD
  "   AND (bmb05 >  '",g_today,"'"," OR bmb05 IS NULL) ",
  "   AND bma05 IS NOT NULL ", # FUN-BB0137 add 應考慮BOM是否已發放;發放的才抓取至APS
  "   AND bmb01 = bma01 ",
  "   AND bmb29 = bma06 ",
  "   AND bmb29 = ' '   ", #無特性BOM功能
  "   AND bmaacti = 'Y' "
#FUN-B50022----mod----end----

  IF NOT cl_null(g_vla.vla02) THEN
     #LET l_sql = l_sql CLIPPED," AND bmadate >= '",g_vla.vla02,"'" #基本資料最後異動日 #FUN-BC0040 mark
      #FUN-BC0040---add-----str---
      SELECT COUNT(*) INTO l_vlq_vao
        FROM vlq_file
       WHERE vlq01 = tm.vlb01 
         AND vlq02 = g_vla.vla02
         AND vlq03 = '2' #p500_vao()
      IF l_vlq_vao >=1 THEN
          LET l_sql = l_sql CLIPPED," AND (bmadate >= '",g_vla.vla02,"'" ,#基本資料最後異動日 
                                    " OR bma05 > '",g_vla.vla02,"'",      #FUN-CA0159 add
                                    " OR bma01 IN (SELECT vlq04 FROM vlq_file ",
                                    "               WHERE vlq01 = '",tm.vlb01,"'",
                                    "                 AND vlq02 = '",g_vla.vla02,"'",
                                    "                 AND vlq03 = '2' ))" #p500_vao()
      ELSE
         #FUN-CA0159 mod str---
         #LET l_sql = l_sql CLIPPED," AND bmadate >= '",g_vla.vla02,"'"  #基本資料最後異動日
          LET l_sql = l_sql CLIPPED," AND (bmadate >= '",g_vla.vla02,"'", #基本資料最後異動日
                                    " OR bma05 > '",g_vla.vla02,"')"
         #FUN-CA0159 mod end---
      END IF
      #FUN-BC0040---add-----end---
  END IF
  PREPARE p500_vao_p FROM l_sql
  IF STATUS THEN CALL cl_err('pre p500_vao_p',STATUS,1) END IF
  DECLARE p500_vao_c CURSOR FOR p500_vao_p
  IF STATUS THEN CALL cl_err('dec p500_vao_c',STATUS,1) END IF

  INITIALIZE g_vao.* TO NULL
  INITIALIZE l_bmb.* TO NULL
  INITIALIZE l_vmo.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vao_c INTO l_bmb.*,l_vmo.*
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vao_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vao.vao01 = l_bmb.bmb01
     LET g_vao.vao02 = l_bmb.bmb03
     LET g_vao.vao03 = l_bmb.bmb02               
    #FUN-9A0038----mod----str----
    #LET g_vao.vao04 = l_bmb.bmb07
    #LET g_vao.vao05 = l_bmb.bmb06
     SELECT ima25 INTO l_ima25
       FROM ima_file
      WHERE ima01 = l_bmb.bmb03
     LET l_factor = 1
     #發料/庫存單位換算率
     CALL s_umfchk(l_bmb.bmb03,l_bmb.bmb10,l_ima25) 
          RETURNING l_flag,l_factor
     IF l_flag = 1 THEN
        LET l_factor = 1
     END IF
    #MOD-B10140------add---str---
     SELECT ima55,ima25 INTO l_bmb01_ima55,l_bmb01_ima25
       FROM ima_file
      WHERE ima01 = l_bmb.bmb01
     #主件的生產單位/庫存單位換算率
     CALL s_umfchk(l_bmb.bmb01,l_bmb01_ima55,l_bmb01_ima25) 
          RETURNING l_flag2,l_factor_2
     IF l_flag2 = 1 THEN
        LET l_factor_2 = 1
     END IF
    #MOD-B10140------add---end---
    #MOD-B10140------mod---str---
    #LET g_vao.vao04 = l_bmb.bmb07 * l_factor
     LET g_vao.vao04 = l_bmb.bmb07 * l_factor_2
    #MOD-B10140------mod---end---
     LET g_vao.vao05 = l_bmb.bmb06 * l_factor
    #FUN-9A0038----mod----end----
     LET g_vao.vao06 = l_bmb.bmb04
     LET g_vao.vao07 = l_bmb.bmb05
     LET g_vao.vao08 = NULL
     LET g_vao.vao09 = NULL
     LET g_vao.vao10 = 0
     IF NOT cl_null(l_vmo.vmo11) THEN
        LET g_vao.vao11  = l_vmo.vmo11
     ELSE
        LET g_vao.vao11  = 0
     END IF
     #TQC-8C0014--mod---str---
     IF NOT cl_null(l_bmb.bmb08) THEN
         LET g_vao.vao12 = l_bmb.bmb08/100
     ELSE
         LET g_vao.vao12 = 0
     END IF
     #TQC-8C0014--mod---end---
     IF NOT cl_null(l_vmo.vmo13) THEN
        LET g_vao.vao13 = l_vmo.vmo13
     ELSE
        LET g_vao.vao13 = 0
     END IF
    #FUN-A80047---mark---str---
    #IF NOT cl_null(l_vmo.vmo14) THEN
    #   LET g_vao.vao14 = l_vmo.vmo14
    #ELSE
    #   LET g_vao.vao14 = 0
    #END IF
    #IF NOT cl_null(l_vmo.vmo15) THEN
    #   LET g_vao.vao15  = l_vmo.vmo15
    #ELSE
    #   LET g_vao.vao15  = 0
    #END IF
    #FUN-A80047---mark---end---
    #FUN-A80047---add----str---
     IF l_bmb.bmb14 = '1' THEN
         LET g_vao.vao14 = '1'
     ELSE
         LET g_vao.vao14 = '0'
     END IF
     IF l_bmb.bmb14 = '3' THEN
         LET g_vao.vao15 = '1'
     ELSE
         LET g_vao.vao15 = '0'
     END IF
    #FUN-A80047---add----end---
     IF NOT cl_null(l_vmo.vmo16) THEN
        LET g_vao.vao16  = l_vmo.vmo16
     ELSE
        LET g_vao.vao16 = 0
     END IF
     IF NOT cl_null(l_vmo.vmo17) THEN
        LET g_vao.vao17 = l_vmo.vmo17
     ELSE
        LET g_vao.vao17 = 0
     END IF
     IF NOT cl_null(l_vmo.vmo18) THEN
        LET g_vao.vao18 = l_vmo.vmo18
     ELSE
        LET g_vao.vao18 = 0
     END IF
     #vao19
     LET l_ecb03 = NULL  
     SELECT ecb03 INTO l_ecb03 FROM ecb_file 
      WHERE ecb01 = l_bmb.bmb01 
        AND ecb09 = l_bmb.bmb06
     LET g_vao.vao19 = l_ecb03
     #vao20
     LET g_vao.vao20 = l_bmb.bmb09
     #LET g_vao.vao21 = l_bmb.bmb19  #FUN-930029 ADD  #MOD-940144 MARK
     #MOD-940144 ADD  --STR--
      CASE l_bmb.bmb19
           WHEN '1' LET g_vao.vao21 = 0   #開工單      不展開
           WHEN '2' LET g_vao.vao21 = 0   #開工單      不展開但自動開立工單
           WHEN '3' LET g_vao.vao21 = 1   #不開工單    展開
           WHEN '4' LET g_vao.vao21 = 1   #不開工單      詢問是否開立工單
       END CASE
     #MOD-940144 ADD  --END--
     LET g_vao.vaolegal = g_legal #FUN-B50022 add
     LET g_vao.vaoplant = g_plant #FUN-B50022 add
     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     #FUN-AA0011--add---str---
    #IF l_flag THEN                #MOD-B10140--mark
     IF l_flag=1 OR l_flag2=1 THEN #MOD-B10140--add
         #FUN-BC0040----add-----str----
         INSERT INTO vlq_file(vlq01,vlq02,vlq03,vlq04,vlq05,vlqlegal,vlqplant)
              VALUES(tm.vlb01,'1999/12/31','2',g_vao.vao01,' ',g_legal,g_plant)
         IF SQLCA.SQLCODE !=0 AND NOT cl_sql_dup_value(SQLCA.SQLCODE) THEN 
             CALL cl_err3("ins","vlq_file",g_vao.vao01,'2:p500_vao()',SQLCA.SQLCODE,"","ins vlq_file fail:2",1)  
         END IF
         #FUN-BC0040----add-----end----
         IF l_flag=1 THEN          #MOD-B10140--add if 判斷
             CALL p500_getmsg('vao01',g_vao.vao01,'vao02',g_vao.vao02,'vao03',g_vao.vao03,'bmb03',l_bmb.bmb03,'bmb10',l_bmb.bmb10,'ima25',l_ima25)
             CALL err('vao_file',g_msg,'mfg2721','2')
         END IF #MOD-B10140--add
         #MOD-B10140---add----str---
         IF l_flag2=1 THEN          
             CALL p500_getmsg('vao01',g_vao.vao01,'vao02',g_vao.vao02,'vao03',g_vao.vao03,'bmb01',l_bmb.bmb01,'ima55',l_bmb01_ima55,'ima25',l_bmb01_ima25)
             CALL err('vao_file',g_msg,'aps-534','2')
         END IF
         #MOD-B10140---add----end---
         LET g_erows = g_erows + 1   
     ELSE
     #FUN-AA0011--add---end---
         PUT p500_c_ins_vao  FROM g_vao.*
         IF STATUS THEN
            #FUN-940030  MARK  --STR--
            #LET g_msg = 'Key:',g_vao.vao01 CLIPPED,' + ',
            #                   g_vao.vao02 CLIPPED,' + ',
            #                   g_vao.vao03 CLIPPED
            #FUN-940030  MARK   --END--
            LET g_status = STATUS                    #TQC-B70094 add
            CALL p500_getmsg('vao01',g_vao.vao01,'vao02',g_vao.vao02,'vao03',g_vao.vao03,'','','','','','')   #FUN-940030 ADD
           #CALL err('vao_file',g_msg,STATUS,'2')    #TQC-B70094 mark
            CALL err('vao_file',g_msg,g_status,'2')  #TQC-B70094 add
            LET g_erows = g_erows + 1   #FUN-940030  ADD
            #FUN-BC0040----add-----str----
            INSERT INTO vlq_file(vlq01,vlq02,vlq03,vlq04,vlq05,vlqlegal,vlqplant)
                 VALUES(tm.vlb01,'1999/12/31','2',g_vao.vao01,' ',g_legal,g_plant)
            IF SQLCA.SQLCODE !=0 AND NOT cl_sql_dup_value(SQLCA.SQLCODE) THEN 
                CALL cl_err3("ins","vlq_file",g_vao.vao01,'2:p500_vao()',SQLCA.SQLCODE,"","ins vlq_file fail:2",1)  
            END IF
            #FUN-BC0040----add-----end----
         END IF
     END IF #FUN-AA0011 add
     #TQC-940012  MARK  --STR--
     #IF tm.vlb29 = 'Y' THEN
     #    CALL p500_vaq(l_bmb.bmb01,l_bmb.bmb02,l_bmb.bmb03,l_bmb.bmb07,l_bmb.bmb08) #單品取替代料由BOM表串出
     #END IF
     #TQC-940012  MARK  --END--
     INITIALIZE g_vao.* TO NULL
     INITIALIZE l_bmb.* TO NULL
     INITIALIZE l_vmo.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vao_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vao_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vao_c:',STATUS,1) RETURN END IF
END FUNCTION
 
#FUNCTION p500_vaq(p_bmb01,p_bmb02,p_bmb03,p_bmb07,p_bmb08)  #單品取替代   #TQC-940012 MARK
FUNCTION p500_vaq()   #TQC-940012 ADD
DEFINE l_sql        STRING
DEFINE p_bmb01      LIKE bmb_file.bmb01,
       p_bmb02      LIKE bmb_file.bmb02, 
       p_bmb03      LIKE bmb_file.bmb03,
       p_bmb07      LIKE bmb_file.bmb07,
       p_bmb08      LIKE bmb_file.bmb08,   
       l_bmd        RECORD LIKE bmd_file.*,
       l_vmq11      LIKE vmq_file.vmq11  #TQC-860041 add
DEFINE l_bmb10      LIKE bmb_file.bmb10     #FUN-AA0009 add
DEFINE l_ori_ima25  LIKE ima_file.ima25     #FUN-AA0009 add
DEFINE l_ori_factor LIKE type_file.num26_10 #FUN-AA0009 add
DEFINE l_sub_ima25  LIKE ima_file.ima25     #FUN-AA0009 add
DEFINE l_sub_factor LIKE type_file.num26_10 #FUN-AA0009 add
DEFINE l_ori_flag   LIKE type_file.chr1     #FUN-AA0011 add
DEFINE l_sub_flag   LIKE type_file.chr1     #FUN-AA0011 add
DEFINE l_sub_ima63  LIKE ima_file.ima63     #FUN-B10015(1) add
DEFINE l_qty        LIKE type_file.num26_10 #FUN-B60062

  IF tm.vlb29  = 'N' THEN RETURN END IF
  #TQC-860041---mod---str--
  DECLARE p500_vaq CURSOR FOR
     SELECT bmd_file.*,vmq11 FROM bmd_file,OUTER vmq_file
      #WHERE bmd08 = p_bmb01   #TQC-940012 MARK
      #  AND bmd01 = p_bmb03   #TQC-940012 MARK
        WHERE  bmdacti = 'Y'
        AND bmd08 = vmq_file.vmq01
        AND bmd01 = vmq_file.vmq02
        AND bmd04 = vmq_file.vmq03
        AND bmd08 <> 'ALL' #FUN-B30200 add #避免單品取替代抓到萬用取替代資料
        AND (bmd06 > g_today OR bmd06 IS NULL)  #FUN-B40073 add 失效日
      ORDER BY bmd08,bmd01

  #TQC-860041---mod---end--

  INITIALIZE g_vaq.* TO NULL
  INITIALIZE l_bmd.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vaq INTO l_bmd.*,l_vmq11 #TQC-860041 add vmq11
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vaq_c:',STATUS,1) EXIT FOREACH
     END IF

     LET g_vaq.vaq01 = l_bmd.bmd08
     LET g_vaq.vaq02 = l_bmd.bmd01
     LET g_vaq.vaq03 = l_bmd.bmd04
     LET g_vaq.vaq04 = (l_bmd.bmd02*10)+l_bmd.bmd03
    #LET g_vaq.vaq05 = l_bmd.bmd07 #FUN-AA0009 mark
    
     IF cl_null(l_bmd.bmd05) THEN LET l_bmd.bmd05 = '1970/01/01' END IF #FUN-A70035 add
     IF cl_null(l_bmd.bmd06) THEN LET l_bmd.bmd06 = '2049/12/31' END IF #FUN-A70035 add
     LET g_vaq.vaq06 = l_bmd.bmd05
     LET g_vaq.vaq07 = l_bmd.bmd06
     LET g_vaq.vaq08 = 1           #mandy?
     #TQC-940012  ADD  --STR--
     #SELECT bmb08 INTO p_bmb08                  #FUN-AA0009 mark
      SELECT bmb08,bmb10 INTO p_bmb08,l_bmb10    #FUN-AA0009 add
        FROM bmb_file,bma_file
           #TQC-990134 mod---str---------------------
           #,(SELECT max(bmb04) mbmb04 FROM bmb_file 
           #   WHERE bmb01=l_bmd.bmd08
           #     AND bmb03=l_bmd.bmd01
           # ) 
        WHERE bmb01 = l_bmd.bmd08 
          AND bmb03 = l_bmd.bmd01 
         #AND bmb04 = mbmb04 
          AND bmb04 = (SELECT max(bmb04) FROM bmb_file
                        WHERE bmb01=l_bmd.bmd08
                          AND bmb03=l_bmd.bmd01)
           #TQC-990134 mod---end---------------------
          AND bmb01 = bma01 
          AND bmb29 = bma06 
          AND bmaacti = 'Y' 
     #TQC-940012  ADD  --END--
    #FUN-AA0009---add---str--
    #原始料件編號 l_bmd.bmd01
    #原=>發料單位 l_bmb10
    #原=>庫存單位 l_ori_ima25
     SELECT ima25 INTO l_ori_ima25
       FROM ima_file
      WHERE ima01 = l_bmd.bmd01

     #發料/庫存單位換算率
     CALL s_umfchk(l_bmd.bmd01,l_bmb10,l_ori_ima25) 
          RETURNING l_ori_flag,l_ori_factor #FUN-AA0011 mod
     IF l_ori_flag = 1 THEN                 #FUN-AA0011 mod
        LET l_ori_factor = 1
     END IF

    #替代料件編號 l_bmd.bmd04
    #替=>發料單位 l_bmb10
    #替=>庫存單位 l_sub_ima25
    #FUN-B10015(1) mod=>替代料的"發料單位"改用其在料件主檔所設定的發料單位(ima63)
    #SELECT ima25 INTO l_sub_ima25                   #FUN-B10015(1) mark
     SELECT ima25,ima63 INTO l_sub_ima25,l_sub_ima63 #FUN-B10015(1) add 
       FROM ima_file
      WHERE ima01 = l_bmd.bmd04
     #發料/庫存單位換算率
    #CALL s_umfchk(l_bmd.bmd04,l_bmb10,l_sub_ima25)      #FUN-B10015(1) mark
     CALL s_umfchk(l_bmd.bmd04,l_sub_ima63,l_sub_ima25)  #FUN-B10015(1) add
          RETURNING l_sub_flag,l_sub_factor #FUN-AA0011 mod
     IF l_sub_flag = 1 THEN                 #FUN-AA0011 mod
        LET l_sub_factor = 1
     END IF
    #FUN-B60062---mod---str---
    #CALL cl_set_num_value(l_bmd.bmd07 * (l_sub_factor/l_ori_factor),3) RETURNING g_vaq.vaq05
     LET l_qty = l_bmd.bmd07 * (l_sub_factor/l_ori_factor)
     CALL cl_set_num_value(l_qty,3) RETURNING g_vaq.vaq05
    #FUN-B60062---mod---str---
    #FUN-AA0009---add---end--

    #LET g_vaq.vaq09 = p_bmb08     #TQC-9A0143 mark
     #TQC-9A0143--add---str---
     IF NOT cl_null(p_bmb08) THEN
         LET g_vaq.vaq09 = p_bmb08/100
     ELSE
         LET g_vaq.vaq09 = 0
     END IF
     #TQC-9A0143--add---end---
     LET g_vaq.vaq10 = l_bmd.bmd02
     #TQC-860041---add---str---
     IF NOT cl_null(l_vmq11) THEN
         LET g_vaq.vaq11 = l_vmq11
     ELSE
         LET g_vaq.vaq11 = 0
     END IF
     #TQC-860041---add---end---
     LET g_vaq.vaqlegal = g_legal #FUN-B50022 add
     LET g_vaq.vaqplant = g_plant #FUN-B50022 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     #FUN-AA0011--add---str---
     IF l_ori_flag=1 OR l_sub_flag=1 THEN
         IF l_ori_flag THEN
             CALL p500_getmsg('vaq01',g_vaq.vaq01,'vaq02',g_vaq.vaq02,'vaq03',g_vaq.vaq03,'bmd01',l_bmd.bmd01,'bmb10',l_bmb10,'ima25',l_ori_ima25)  
             CALL err('vaq_file',g_msg,'mfg2721','2')
         END IF
         IF l_sub_flag THEN
             CALL p500_getmsg('vaq01',g_vaq.vaq01,'vaq02',g_vaq.vaq02,'vaq03',g_vaq.vaq03,'bmd04',l_bmd.bmd04,'bmb10',l_bmb10,'ima25',l_sub_ima25)  
             CALL err('vaq_file',g_msg,'mfg2721','2')
         END IF
         LET g_erows = g_erows + 1   
     ELSE
     #FUN-AA0011--add---end---
         PUT p500_c_ins_vaq  FROM g_vaq.*
         IF STATUS THEN
            #FUN-940030  MARK   --STR--
            #LET g_msg = 'Key:',g_vaq.vaq01 CLIPPED,' + ',
            #                   g_vaq.vaq02 CLIPPED,' + ',
            #                   g_vaq.vaq03 CLIPPED
            #FUN-940030  MARK   --END--
            LET g_status = STATUS                    #TQC-B70094 add
            CALL p500_getmsg('vaq01',g_vaq.vaq01,'vaq02',g_vaq.vaq02,'vaq03',g_vaq.vaq03,'','','','','','')   #FUN-940030 ADD
           #CALL err('vaq_file',g_msg,STATUS,'2')    #TQC-B70094 mark
            CALL err('vaq_file',g_msg,g_status,'2')  #TQC-B70094 add
            LET g_erows = g_erows + 1   #FUN-940030  ADD
         END IF
     END IF #FUN-AA0011 add
     INITIALIZE g_vaq.* TO NULL
     INITIALIZE l_bmd.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vaq_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vaq_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vaq_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p500_vam_1() #料件途程---標準--aeci100
DEFINE l_sql        STRING               #FUN-890058 add
DEFINE l_ima94      LIKE ima_file.ima94                  
DEFINE l_vai49      LIKE vai_file.vai49
DEFINE l_ecu01      LIKE ecu_file.ecu01                  
DEFINE l_ecu02      LIKE ecu_file.ecu02                  
DEFINE l_ecu012     LIKE ecu_file.ecu012 #FUN-B50101 add
DEFINE l_ecu015     LIKE ecu_file.ecu012 #FUN-B50101 add
DEFINE l_ecu01_t    LIKE ecu_file.ecu01  #TQC-870043 add
DEFINE l_cnt        LIKE type_file.num5  #TQC-870043 add
DEFINE l_vlq_vam_1  LIKE type_file.num5  #FUN-BC0040 add
 
  IF tm.vlb25 = 'N' THEN RETURN END IF
  #FUN-890058 ---mod----str---
 #LET l_sql = "SELECT ecu01,ecu02,ecu012,ecu015 ", #FUN-B50101 add ecu012,ecu015 #FUN-B90021 mark
  LET l_sql = "SELECT UNIQUE ecu01,ecu02 ",        #FUN-B50101 add ecu012,ecu015 #FUN-B90021 add
              "  FROM ecu_file",
              " WHERE ecuacti = 'Y' "
  IF NOT cl_null(g_vla.vla02) THEN
     #LET l_sql = l_sql CLIPPED," AND ecudate >= '",g_vla.vla02,"'" #基本資料最後異動日 #FUN-BC0040 mark
      #FUN-BC0040---add-----str---
      SELECT COUNT(*) INTO l_vlq_vam_1
        FROM vlq_file
       WHERE vlq01 = tm.vlb01 
         AND vlq02 = g_vla.vla02
         AND vlq03 = '3' #p500_vam_1()
      IF l_vlq_vam_1 >=1 THEN
          LET l_sql = l_sql CLIPPED," AND (ecudate >= '",g_vla.vla02,"'" ,#基本資料最後異動日
                                    " OR (ecu01,ecu02) IN (SELECT vlq04,vlq05 FROM vlq_file ",
                                    "                       WHERE vlq01 = '",tm.vlb01,"'",
                                    "                         AND vlq02 = '",g_vla.vla02,"'",
                                    "                         AND vlq03 = '3' ))" #p500_vam_1()
      ELSE
          LET l_sql = l_sql CLIPPED," AND ecudate >= '",g_vla.vla02,"'" #基本資料最後異動日 
      END IF
      #FUN-BC0040---add-----end---
  END IF
 #LET l_sql = l_sql CLIPPED," ORDER BY ecu01,ecu02,ecu012,ecu015 " #FUN-B50101 add ecu012,ecu015 #FUN-B90021 mark
  LET l_sql = l_sql CLIPPED," ORDER BY ecu01,ecu02 "               #FUN-B50101 add ecu012,ecu015 #FUN-B90021 add

  PREPARE p500_vam_1_p FROM l_sql
  IF STATUS THEN CALL cl_err('pre p500_vam_1_p',STATUS,1) END IF
  DECLARE p500_vam_1_c CURSOR FOR p500_vam_1_p
  IF STATUS THEN CALL cl_err('dec p500_vam_1_c',STATUS,1) END IF
  #FUN-890058 ---mod----end---

  LET l_ecu01_t = NULL #TQC-870043 add
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
 #FOREACH p500_vam_1_c INTO l_ecu01,l_ecu02,l_ecu012 #FUN-B50101 add ecu012 #FUN-B90021 mark
  FOREACH p500_vam_1_c INTO l_ecu01,l_ecu02          #FUN-B50101 add ecu012 #FUN-B90021 add
     IF SQLCA.sqlcode THEN
        CALL cl_err('p500_vam_1_c:',STATUS,1) EXIT FOREACH
     END IF
     IF cl_null(l_ecu01_t) THEN
         LET l_cnt = 1 
     ELSE
         IF l_ecu01_t <> l_ecu01 THEN
             LET l_cnt = 1 
         END IF
     END IF
     INITIALIZE g_vam.* TO NULL
     LET g_vam.vam01 = l_ecu01
     LET g_vam.vam02 = l_ecu01 CLIPPED,'-',l_ecu02 CLIPPED #TQC-860041
     #TQC-870043 mod---str---
     #vam03
     #判斷料件製程是否為料件基本資料中(ima94)預設製程編號,
     #若是途程序號給0,否則由100開始往後加
     SELECT ima94 
       INTO l_ima94 
       FROM ima_file 
      WHERE ima01  = l_ecu01 
        AND ima571 = l_ecu01
     IF NOT cl_null(l_ima94) AND (l_ima94 = l_ecu02) THEN
         LET g_vam.vam03 = 0
     ELSE
         LET g_vam.vam03 = l_cnt
         LET l_cnt = l_cnt + 1
     END IF
     #TQC-870043 mod---end---
     #vam04
     SELECT vai49 INTO l_vai49
       FROM vai_file
      WHERE vai01 = l_ecu01
     IF cl_null(l_vai49) THEN
       #LET l_vai49 = 1 #TQC-8A0053
        LET l_vai49 = 5 #TQC-8A0053
     END IF
     LET g_vam.vam04 = l_vai49 
     LET g_vam.vam05 = NULL
     LET g_vam.vam06 = NULL
     LET g_vam.vam07 = 1      #標準
     LET g_vam.vamlegal = g_legal #FUN-B50022 add
     LET g_vam.vamplant = g_plant #FUN-B50022 add
    #FUN-B90021-----mod---str----
    ##FUN-B50101 ---add---str---
    #LET g_vam.vam16 = l_ecu012 #製程段號   #FUN-B50101 add
    #LET g_vam.vam17 = l_ecu015 #下製程段號 #FUN-B50101 add
    ##FUN-B50101 ---add---end---
     LET g_vam.vam16 = ' ' #製程段號   
     LET g_vam.vam17 = ''  #下製程段號 
    #FUN-B90021-----mod---end----

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vam FROM g_vam.*
     IF STATUS THEN
        #LET g_msg = 'Key:',g_vam.vam01 CLIPPED,' + ',g_vam.vam02 CLIPPED  #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vam01',g_vam.vam01,'vam02',g_vam.vam02,'','','','','','','','')   #FUN-940030 ADD
       #CALL err('vam_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vam_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
        #FUN-BC0040----add-----str----
        INSERT INTO vlq_file(vlq01,vlq02,vlq03,vlq04,vlq05,vlqlegal,vlqplant)
             VALUES(tm.vlb01,'1999/12/31','3',l_ecu01,l_ecu02,g_legal,g_plant)
        IF SQLCA.SQLCODE !=0 AND NOT cl_sql_dup_value(SQLCA.SQLCODE) THEN 
            CALL cl_err3("ins","vlq_file",l_ecu01,l_ecu02,SQLCA.SQLCODE,"","ins vlq_file fail:3",1)  
        END IF
        #FUN-BC0040----add-----end----
     END IF
     LET l_ecu01_t = l_ecu01 #TQC-870043 add
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vam_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vam_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vam_1_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p500_vam_2() #料件途程---工單--aeci700
DEFINE l_sql        STRING               #FUN-8A0011 add
DEFINE l_ecm        RECORD LIKE ecm_file.*
DEFINE l_ima94      LIKE ima_file.ima94                  
DEFINE l_vai49      LIKE vai_file.vai49
 
  IF tm.vlb25 = 'N' THEN RETURN END IF

 #FUN-8A0011 ---mod----str---
 #DECLARE p500_vam_2_c CURSOR FOR 
 #  SELECT UNIQUE ecm01,ecm03_par
 #    FROM ecm_file
 #   WHERE ecmacti = 'Y'
 #   ORDER BY ecm01,ecm03_par
 IF NOT cl_null(g_vlz70) THEN 
     CALL s_get_sql_msp04(g_vlz70,'ecm01') RETURNING g_sql_limited 
 ELSE
     LET g_sql_limited = ' 1=1 '
 END IF

 #LET l_sql = "SELECT UNIQUE ecm01,ecm03_par,ecm012 ", #FUN-B50101 add ecm012 #FUN-B90021 mark
  LET l_sql = "SELECT UNIQUE ecm01,ecm03_par ",        #FUN-B50101 add ecm012 #FUN-B90021 add
              "  FROM ecm_file,sfb_file",
              " WHERE ecmacti = 'Y' ",
              "   AND ",g_sql_limited CLIPPED,
              #工單條件------str---
              "   AND sfb01 = ecm01 ",
             #"   AND sfb08 > sfb09 ",              #FUN-CB0131 mark
              "   AND sfb08 > sfb09 + sfb12 ",      #FUN-CB0131 add
              "   AND sfb04 <  '8' ",
              "   AND sfb13 <= '",tm.vlb08,"'",       #預計開工日小於資料截止日期
              "   AND sfb87 != 'X' ",
              "   AND sfb01 IS NOT NULL ",
              "   AND sfb01 != ' ' ",
              #工單條件------end---
             #" ORDER BY ecm01,ecm03_par,ecm012 " #FUN-B50101 add ecm012 #FUN-B90021 mark
              " ORDER BY ecm01,ecm03_par        " #FUN-B50101 add ecm012 #FUN-B90021 add

  PREPARE p500_vam_2_p FROM l_sql
  IF STATUS THEN CALL cl_err('pre p500_vam_2_p',STATUS,1) END IF
  DECLARE p500_vam_2_c CURSOR FOR p500_vam_2_p
  IF STATUS THEN CALL cl_err('dec p500_vam_2_c',STATUS,1) END IF
  #FUN-8A0011 ---mod----end---

  INITIALIZE g_vam.* TO NULL
  INITIALIZE l_ecm.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vam_2_c INTO l_ecm.ecm01,l_ecm.ecm03_par,l_ecm.ecm012 #FUN-B50101 add ecm012
     IF SQLCA.sqlcode THEN
        CALL cl_err('p500_vam_2_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vam.vam01 = l_ecm.ecm03_par
     LET g_vam.vam02 = l_ecm.ecm03_par CLIPPED,'-',l_ecm.ecm01 CLIPPED #TQC-860041
     #vam03
     LET g_vam.vam03 = 9999 #固定給9999 #TQC-870043 mod
     #vam04
     SELECT vai49 INTO l_vai49
       FROM vai_file
      WHERE vai01 = l_ecm.ecm03_par
     IF cl_null(l_vai49) THEN
       #LET l_vai49 = 1 #TQC-8A0053
        LET l_vai49 = 5 #TQC-8A0053
     END IF
     LET g_vam.vam04 = l_vai49 
     LET g_vam.vam05 = NULL
     LET g_vam.vam06 = NULL
     LET g_vam.vam07 = 0      #工單
     LET g_vam.vamlegal = g_legal #FUN-B50022 add
     LET g_vam.vamplant = g_plant #FUN-B50022 add
     #FUN-B50101 ---add---str---
     SELECT * INTO l_ecm.*
       FROM ecm_file
      WHERE ecm01 = l_ecm.ecm01
        AND ecm03 = l_ecm.ecm03
        AND ecm012= l_ecm.ecm012
    #FUN-B90021-----mod---str----
    #LET g_vam.vam16 = l_ecm.ecm012 #製程段號   #FUN-B50101 add 
    #LET g_vam.vam17 = l_ecm.ecm015 #下製程段號 #FUN-B50101 add 
     #FUN-B50101 ---add---end---
     LET g_vam.vam16 = ' ' #製程段號   
     LET g_vam.vam17 = ''  #下製程段號 
    #FUN-B90021-----mod---end----

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vam FROM g_vam.*
     IF STATUS THEN
        #LET g_msg = 'Key:',g_vam.vam01 CLIPPED,' + ',g_vam.vam02 CLIPPED  #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vam01',g_vam.vam01,'vam02',g_vam.vam02,'','','','','','','','')   #FUN-940030 ADD
       #CALL err('vam_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vam_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vam.* TO NULL
     INITIALIZE l_ecm.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vam_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vam_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vam_2_c:',STATUS,1) RETURN END IF
END FUNCTION

#TQC-870043---add---str--
FUNCTION p500_vam_3() #料件途程---ima_file-aimi100
DEFINE l_ima01      LIKE ima_file.ima01
DEFINE l_ima571     LIKE ima_file.ima571
DEFINE l_ima94      LIKE ima_file.ima94                  
DEFINE l_vai49      LIKE vai_file.vai49
DEFINE l_ecu01      LIKE ecu_file.ecu01                  
DEFINE l_ecu02      LIKE ecu_file.ecu02                  
DEFINE l_cnt        LIKE type_file.num5  #TQC-870043 add
DEFINE l_sql        STRING               #TQC-870043 add
 
  IF tm.vlb25 = 'N' THEN RETURN END IF

  DECLARE p500_vam_3_c CURSOR FOR 
    SELECT ima01,ima571,ima94
      FROM ima_file
     WHERE imaacti = 'Y'
       AND ima571 IS NOT NULL 
       AND ima571 <> ' '
       AND ima571 <> ima01
     ORDER BY ima571,ima94

  LET l_sql = "SELECT ecu02 ",
              "  FROM ecu_file ",
              " WHERE ecuacti = 'Y' ",
              "   AND ecu01 = ? ",
              " ORDER BY ecu02 "
  PREPARE p500_vam_4_p FROM l_sql
  IF STATUS THEN CALL cl_err('pre p500_vam_4_p',STATUS,1) END IF
  DECLARE p500_vam_4_c CURSOR FOR p500_vam_4_p
  IF STATUS THEN CALL cl_err('dec p500_vam_4_c',STATUS,1) END IF

  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vam_3_c INTO l_ima01,l_ima571,l_ima94
     IF SQLCA.sqlcode THEN
        CALL cl_err('p500_vam_3_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_vam.* TO NULL
     #vam01
     LET g_vam.vam01 = l_ima01
     #vam04
     SELECT vai49 INTO l_vai49
       FROM vai_file
      WHERE vai01 = l_ima01
     IF cl_null(l_vai49) THEN
       #LET l_vai49 = 1 #TQC-8A0053
        LET l_vai49 = 5 #TQC-8A0053
     END IF
     LET g_vam.vam04 = l_vai49 
     LET g_vam.vam05 = NULL
     LET g_vam.vam06 = NULL
     LET g_vam.vam07 = 1      #標準
     LET g_vam.vamlegal = g_legal #FUN-B50022 add
     LET g_vam.vamplant = g_plant #FUN-B50022 add
     #FUN-B50101 ---add---str---
     LET g_vam.vam16 = ' ' #製程段號   #FUN-B50101 add
     LET g_vam.vam17 = ''  #下製程段號 #FUN-B50101 add
     #FUN-B50101 ---add---end---
     IF NOT cl_null(l_ima94) THEN #預設製程編號 
         LET g_vam.vam02 = l_ima571 CLIPPED ,'-',l_ima94 CLIPPED  
         LET g_vam.vam03 = 0 #序號為0
         LET g_wrows = g_wrows + 1   #FUN-940030  ADD
         PUT p500_c_ins_vam FROM g_vam.*
         IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN
            #LET g_msg = 'Key:',g_vam.vam01 CLIPPED,' + ',g_vam.vam02 CLIPPED  #FUN-940030 MARK
            LET g_status = SQLCA.sqlcode             #TQC-B70094 add
            CALL p500_getmsg('vam01',g_vam.vam01,'vam02',g_vam.vam02,'','','','','','','','')   #FUN-940030 ADD
           #CALL err('vam_file',g_msg,STATUS,'2')    #TQC-B70094 mark
            CALL err('vam_file',g_msg,g_status,'2')  #TQC-B70094 add
            LET g_erows = g_erows + 1   #FUN-940030  ADD
         END IF
     ELSE
         #預設製程編號為空時,需要再抓同料的產品製程資料(aeci100)
         LET l_cnt = 1
         FOREACH p500_vam_4_c USING l_ima571 INTO l_ecu02
             LET g_vam.vam02 = l_ima571 CLIPPED ,'-',l_ecu02 CLIPPED  
             LET g_vam.vam03 =  l_cnt   #序號由1開始,往後加
             LET g_wrows = g_wrows + 1   #FUN-940030  ADD
             PUT p500_c_ins_vam FROM g_vam.*
             IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN
                #LET g_msg = 'Key:',g_vam.vam01 CLIPPED,' + ',g_vam.vam02 CLIPPED  #FUN-940030 MARK
                LET g_status = SQLCA.sqlcode             #TQC-B70094 add
                CALL p500_getmsg('vam01',g_vam.vam01,'vam02',g_vam.vam02,'','','','','','','','')   #FUN-940030 ADD
               #CALL err('vam_file',g_msg,STATUS,'2')    #TQC-B70094 mark
                CALL err('vam_file',g_msg,g_status,'2')  #TQC-B70094 add
                LET g_erows = g_erows + 1   #FUN-940030  ADD
             END IF
             LET l_cnt = l_cnt + 1
         END FOREACH
         IF SQLCA.sqlcode THEN CALL cl_err('p500_vam_4_c:',STATUS,1) RETURN END IF
     END IF
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vam_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vam_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vam_3_c:',STATUS,1) RETURN END IF
END FUNCTION
#TQC-870043---add---end--

FUNCTION p500_vax()      #工單備料
DEFINE l_sql       STRING
DEFINE l_seq       LIKE type_file.num10 
DEFINE l_sfa01     LIKE sfa_file.sfa01,
       l_sfa06     LIKE sfa_file.sfa06,
       l_sfa03     LIKE sfa_file.sfa03,
       l_sfa30     LIKE sfa_file.sfa30,
       l_sfa31     LIKE sfa_file.sfa31,
       l_sfa05     LIKE sfa_file.sfa05,
       l_sfa065    LIKE sfa_file.sfa065,
       l_sfa28     LIKE sfa_file.sfa28,
       l_sfa13     LIKE sfa_file.sfa13,
       l_sfa08     LIKE sfa_file.sfa08,  
       l_sfa12     LIKE sfa_file.sfa12,  
       l_ecm03     LIKE ecm_file.ecm03,  
       l_sfb05     LIKE sfb_file.sfb05,
       l_bmb02     LIKE bmb_file.bmb02,
       l_sfa11     LIKE sfa_file.sfa11,  #FUN-930127 ADD
       l_sfa27     LIKE sfa_file.sfa27,  #FUN-930127 ADD
       l_sfa012    LIKE sfa_file.sfa012, #FUN-B50101 add
       l_sfa013    LIKE sfa_file.sfa013, #FUN-B50101 add
       l_sfa062    LIKE sfa_file.sfa062, #FUN-B80173 add
       l_sfa063    LIKE sfa_file.sfa063, #FUN-B80173 add
       l_ima08     LIKE ima_file.ima08,  #FUN-930127 ADD
       l_ima562    LIKE ima_file.ima562, #FUN-930127 ADD
       l_ima47     LIKE ima_file.ima47,  #FUN-930127 ADD
       l_bmb08     LIKE bmb_file.bmb08,  #FUN-930127 ADD
       l_bmb01     LIKE bmb_file.bmb01,  #FUN-930127 ADD
       l_bmb03     LIKE bmb_file.bmb03,  #FUN-930127 ADD
       l_bmb04     LIKE bmb_file.bmb04,  #FUN-930127 ADD
       l_loseqty   LIKE sfa_file.sfa05,  #FUN-930127 ADD
       l_str       LIKE type_file.chr20 
DEFINE l_chr5      LIKE type_file.chr5 #TQC-860041 add
DEFINE l_cnt       LIKE type_file.num5 #TQC-870043 add
DEFINE l_sfa01_t   LIKE sfa_file.sfa01 #TQC-870043 add

  IF tm.vlb36   = 'N' THEN RETURN END IF

 #FUN-8A0011 ---mod----str---
 #DECLARE p500_vax_c CURSOR FOR
 #    SELECT sfa01,sfa06,sfa03,sfa30,sfa31,
 #           sfa05,sfa065,sfa28,sfa13,sfa08,sfa12,sfb05
 #        FROM sfa_file,sfb_file
 #       WHERE sfb01 =  sfa01
 #         AND sfb08 > sfb09
 #         AND sfb04 < '8' 
 #         AND sfb13 <= tm.vlb08
 #         AND sfb23 =  'Y' 
 #         AND sfb87 != 'X'
 #         AND sfb01 IS NOT NULL
 #         AND sfb01 != ' '
 #         AND (sfa05 > (sfa06 + sfa065))
 #       ORDER BY sfa01,sfa03,sfa08
 IF NOT cl_null(g_vlz70) THEN 
     CALL s_get_sql_msp04(g_vlz70,'sfb01') RETURNING g_sql_limited 
 ELSE
     LET g_sql_limited = ' 1=1 '
 END IF
 LET l_sql = "SELECT sfa01,sfa06,sfa03,sfa30,sfa31, ",
             "       sfa05,sfa065,sfa28,sfa13,sfa08,sfa12,sfb05, ",
             "       sfa11,sfa27  ",  #FUN-930127 ADD
             "      ,sfa012,sfa013 ", #FUN-B50101 add
             "      ,sfa062,sfa063 ", #FUN-B80173 add
             "  FROM sfa_file,sfb_file ",
             " WHERE sfb01 =  sfa01 ",
            #"   AND sfb08 > sfb09 ",              #FUN-CB0131 mark
             "   AND sfb08 > sfb09 + sfb12 ",      #FUN-CB0131 add
             "   AND sfb04 < '8' ",
             "   AND sfb13 <= '",tm.vlb08,"'",
             "   AND sfb23 =  'Y' ",
             "   AND sfb87 != 'X' ",
             "   AND sfb01 IS NOT NULL ",
             "   AND sfb01 != ' ' ",
            #"   AND (sfa05 > (sfa06 + sfa065)) ", #TQC-8A0019 mark 不需此條件
             "   AND ",g_sql_limited CLIPPED,
             " ORDER BY sfa01,sfa03,sfa08,sfa012,sfa013" #FUN-B50101 add sfa012,sfa013

  PREPARE p500_vax_p FROM l_sql
  IF STATUS THEN CALL cl_err('pre p500_vax_p',STATUS,1) END IF
  DECLARE p500_vax_c CURSOR FOR p500_vax_p
  IF STATUS THEN CALL cl_err('dec p500_vax_c',STATUS,1) END IF
  #FUN-8A0011 ---mod----end---

  INITIALIZE g_vax.* TO NULL
  LET l_sfa01_t = NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vax_c INTO l_sfa01,l_sfa06,l_sfa03,l_sfa30,l_sfa31,
                          l_sfa05,l_sfa065,l_sfa28,l_sfa13,l_sfa08,l_sfa12,l_sfb05,
                          l_sfa11,l_sfa27   #FUN-930127 ADD
                         ,l_sfa012,l_sfa013 #FUN-B50101 add
                         ,l_sfa062,l_sfa063 #FUN-B80173 add
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vax_c:',STATUS,1) EXIT FOREACH
     END IF
     #-->替代率不正確
     IF cl_null(l_sfa28) OR l_sfa28 = 0 THEN
        LET l_str = l_sfa01 ,'-',l_sfa03
        CALL cl_getmsg('aps-100',g_lang) RETURNING g_msg
       #CALL err(l_str,g_msg,'aps-100')            #FUN-940030 MARK
        LET g_msg = g_msg ,':',l_str
        CALL err('vax_file',g_msg,'aps-100','2')   #FUN-940030 ADD
        LET g_erows = g_erows + 1                  #FUN-940030 ADD
        CONTINUE FOREACH
     END IF
     

     LET g_vax.vax01 = l_sfa01                              #製令編號
     LET g_vax.vax02 = l_sfa03                              #元件編號
     #TQC-870043 mod---str---
     #元件序號(vax03)不抓BOM表了,改為同張製令直接依序給值1.2.3.4
     IF cl_null(l_sfa01_t) THEN
         LET l_cnt = 1 
     ELSE
         IF l_sfa01_t <> l_sfa01 THEN
             LET l_cnt = 1 
         END IF
     END IF
     LET g_vax.vax03 = l_cnt                             #元件序號(在此指元件於製程中投料序號) 
     #TQC-870043 mod---end---

     #TQC-860041---mod----str---
     LET l_ecm03 = NULL
     SELECT ecm03 INTO l_ecm03 
       FROM ecm_file 
      WHERE ecm01=l_sfa01
        AND ecm04=l_sfa08
     IF cl_null(l_ecm03) THEN
         LET l_ecm03 = 1
     END IF
     LET l_chr5      = l_ecm03 USING '&&&&&' #TQC-860041
     LET g_vax.vax04 = l_chr5  #加工序號     #TQC-860041
     #TQC-860041---mod----end---
    #LET g_vax.vax05 = (l_sfa06 + l_sfa065)/l_sfa28*l_sfa13 #元件已領用量                           #FUN-B80173 mark
    #FUN-C50056---mod---str---
    #不需再除以替代率(sfa28)
    #LET g_vax.vax05 = (l_sfa06 + l_sfa065 - l_sfa063 + l_sfa062) / l_sfa28 * l_sfa13 #元件已領用量 #FUN-B80173 add
     LET g_vax.vax05 = (l_sfa06 + l_sfa065 - l_sfa063 + l_sfa062)           * l_sfa13 #元件已領用量  #FUN-B80173 add
    #FUN-C50056---mod---end---
     LET g_vax.vax06 = l_sfa30
     #LET g_vax.vax07 = (l_sfa05/l_sfa28)*l_sfa13  #元件需求量  #TQC-940167 MARK
     LET g_vax.vax08 = l_sfa31                      
     LET g_vax.vax09 = 0
     LET g_vax.vax10 = l_sfa08   #作業編號 

     #FUN-930127  ADD  --STR--------------------------------------------------------- 
       IF l_sfa11 ='E' THEN
          LET g_vax.vax11 = 1
       ELSE
          LET g_vax.vax11 = 0
       END IF
  
       #先取出BOM表之最大有效日期
       SELECT bmb01,bmb03,max(bmb04) INTO l_bmb01,l_bmb03,l_bmb04 
       FROM bmb_file,bma_file
       WHERE bmb01 = bma01 
         AND bmb29 = bma06 
         AND bmb29 = ' '   
         AND bmb01 = l_sfb05
         AND bmb03 = l_sfa27
         AND bmaacti = 'Y' 
         GROUP BY bmb01,bmb03
 
       #依最大有效日期取出其損耗率
       SELECT bmb08 INTO l_bmb08
       FROM bmb_file,bma_file
       WHERE bmb01 = bma01
         AND bmb29 = bma06
         AND bmb29 = ' '
         AND bmb01 = l_sfb05
         AND bmb03 = l_sfa27 
         AND bmaacti = 'Y'
         AND bmb04 = l_bmb04

       IF cl_null(l_bmb08) THEN LET l_bmb08 = 0 END IF   #FUN-C40017 add

       #取出主件在料件基本資料之來源碼,生產損耗率,採購損耗率
       SELECT  ima08,ima562,ima47  INTO  l_ima08, l_ima562, l_ima47
       FROM ima_file
       WHERE ima01 = l_sfa27

       #損耗數量計算
       LET l_loseqty = 0
       IF l_bmb08 != 0  THEN LET l_loseqty = l_sfa05 * l_bmb08  * 0.01
       ELSE
         IF (l_bmb08 = 0 OR l_bmb08 is NULL) AND l_ima08='M' THEN LET l_loseqty = l_sfa05 * l_ima562  * 0.01
         ELSE
           IF (l_bmb08 = 0 OR l_bmb08 is NULL) AND l_ima08='P' THEN LET l_loseqty = l_sfa05 * l_ima47  * 0.01
           END IF
         END IF
       END IF
       
       #計算元件真實需求量及損耗需求量(依asms270 之 sma71 工單備料時下階料件是否考慮損耗率來決定值)
       #TQC-940167 MOD --STR----------------------------------------------------
        #IF g_sma.sma71 = 'Y' THEN LET g_vax.vax12 = l_sfa05 + l_loseqty
        #ELSE  
        #   LET g_vax.vax12 = l_sfa05   
        #END IF
        #IF g_sma.sma71 = 'Y' THEN LET g_vax.vax13 = 0
        #ELSE
        #   LET g_vax.vax13 = l_loseqty
        #END IF
         IF g_sma.sma71='Y' THEN  #工單產生下階備料時是否考慮損耗率
           #FUN-C50056---mod---str---
           #不需再除以替代率(sfa28)
           #LET g_vax.vax12 = ((l_sfa05-(l_sfa05 * l_bmb08 * 0.01)) / l_sfa28) * l_sfa13
            LET g_vax.vax12 =  (l_sfa05-(l_sfa05 * l_bmb08 * 0.01))            * l_sfa13
           #LET g_vax.vax13 = ((l_sfa05 * l_bmb08 * 0.01) / l_sfa28) * l_sfa13  #MOD-B20124 add
            LET g_vax.vax13 = ((l_sfa05 * l_bmb08 * 0.01))           * l_sfa13  #MOD-B20124 add
           #FUN-C50056---mod---end---
         ELSE
           #FUN-C50056---mod---str---
           #不需再除以替代率(sfa28)
           #LET g_vax.vax12 = (l_sfa05 / l_sfa28) * l_sfa13 
            LET g_vax.vax12 = (l_sfa05)           * l_sfa13 
           #FUN-C50056---mod---end---
            LET g_vax.vax13 = 0                                                 #MOD-B20124 add
         END IF
        #LET g_vax.vax13 = ((l_sfa05 * l_bmb08 * 0.01) / l_sfa28) * l_sfa13     #MOD-B20124 mark
         LET g_vax.vax07 = g_vax.vax12 + g_vax.vax13
       #TQC-940167 MOD --END---------------------------------------------------
     #FUN-930127  ADD  --END---------------------------------------------------  
     LET g_vax.vax14 = l_sfa27 #FUN-B30200 add
     LET g_vax.vaxlegal = g_legal #FUN-B50022 add
     LET g_vax.vaxplant = g_plant #FUN-B50022 add
     LET g_vax.vax22    = l_sfa012 #製程段號 #FUN-B50101 add
     LET l_chr5  = l_sfa013 USING '&&&&&'    #FUN-B50101 add
     LET g_vax.vax23 = l_chr5                #FUN-B50101 add 製程序

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vax FROM g_vax.*
     IF STATUS THEN
         #FUN-940030  MARK  --STR-- 
         #LET g_msg = 'Key:',g_vax.vax01 CLIPPED,' + ',
         #                   g_vax.vax02 CLIPPED,' + ',
         #                   g_vax.vax03 CLIPPED,' + ',
         #                   g_vax.vax04
         #FUN-940030  MARK   --END--
         LET g_status = STATUS                    #TQC-B70094 add
         CALL p500_getmsg('vax01',g_vax.vax01,'vax02',g_vax.vax02,'vax03',g_vax.vax03,'vax04',g_vax.vax04,'','','','')   #FUN-940030 ADD
        #CALL err('vax_file',g_msg,STATUS,'2')    #TQC-B70094 mark
         CALL err('vax_file',g_msg,g_status,'2')  #TQC-B70094 add
         LET g_erows = g_erows + 1   #FUN-940030  ADD
     ELSE                         #TQC-870043 add
         LET l_cnt = l_cnt + 1    #TQC-870043 add
     END IF
     LET l_sfa01_t = l_sfa01 #TQC-870043 add
     INITIALIZE g_vax.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vax_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vax_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vax_c:',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p500_vaj()      #庫存數量
DEFINE #l_sql       LIKE type_file.chr1000
       l_sql        STRING       #NO.FUN-910082  
DEFINE l_img01     LIKE img_file.img01,
       l_img02     LIKE img_file.img02,
       l_img03     LIKE img_file.img03,
       l_img10     LIKE img_file.img10,
       l_name      LIKE type_file.chr1000 

  IF tm.vlb22  = 'N' THEN RETURN END IF

 #FUN-8A0011 ---mod----str---
 #DECLARE p500_vaj_c CURSOR FOR
 #    SELECT img01, img02, img03,SUM(img10*img21)
 #      FROM img_file
 #     WHERE img24='Y'  #僅抓取MRP可用倉庫儲位
 #    GROUP BY  img01,img02,img03
 IF NOT cl_null(g_vlz70) THEN 
     CALL s_get_sql_msp03(g_vlz70,'img02') RETURNING g_sql_limited #TQC-8A0019 mod
 ELSE
     LET g_sql_limited = ' 1=1 '
 END IF
#FUN-C30283 mod str---
#FUN-9B0129--mark---str---
#LET l_sql = "SELECT img01, img02, img03,SUM(img10*img21) ",
#            "  FROM img_file ",
#            " WHERE img24='Y' ", #僅抓取MRP可用倉庫儲位
#            "   AND ",g_sql_limited CLIPPED,
#            " GROUP BY  img01,img02,img03 "
#FUN-9B0129--mark---end---
#FUN-9B0129--add----str---
#LET l_sql = "SELECT img01, img02, img03,SUM(img10*img21) "
#IF g_db_type = 'ORA' THEN
#    LET l_sql = l_sql CLIPPED,"  FROM img_file AS OF TIMESTAMP TO_TIMESTAMP('",g_planned_start,"','yyyy-mm-dd hh24:mi:ss') "
#ELSE
#    LET l_sql = l_sql CLIPPED,"  FROM img_file "
#END IF
#LET l_sql = l_sql CLIPPED,
#            " WHERE img24='Y' ", #僅抓取MRP可用倉庫儲位
#            "   AND ",g_sql_limited CLIPPED,
#            " GROUP BY  img01,img02,img03 "
#FUN-9B0129--add----end---
 LET l_sql = "SELECT img01, img02, img03,SUM(img10*img21) ",
             "  FROM img_file ",
             " WHERE img24='Y' ", #僅抓取MRP可用倉庫儲位
             "   AND ",g_sql_limited CLIPPED,
             " GROUP BY  img01,img02,img03 "
#FUN-C30283 mod end---

  PREPARE p500_vaj_p FROM l_sql
  IF STATUS THEN CALL cl_err('pre p500_vaj_p',STATUS,1) END IF
  DECLARE p500_vaj_c CURSOR FOR p500_vaj_p
  IF STATUS THEN CALL cl_err('dec p500_vaj_c',STATUS,1) END IF
  #FUN-8A0011 ---mod----end---

  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vaj_c INTO l_img01,l_img02,l_img03,l_img10
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vaj_c:',STATUS,1) EXIT FOREACH
     END IF
     IF l_img10 <=0 THEN CONTINUE FOREACH END IF
     LET g_vaj.vaj01 = l_img01          #料件編號
     LET g_vaj.vaj02 = l_img02          #倉庫編號
     LET g_vaj.vaj03 = l_img03          #庫房儲位
     LET g_vaj.vaj04 = l_img10          #可用量
     LET g_vaj.vaj05 = NULL             #庫房位置 
     LET g_vaj.vajlegal = g_legal #FUN-B50022 add
     LET g_vaj.vajplant = g_plant #FUN-B50022 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vaj FROM g_vaj.*
     IF STATUS THEN
        #LET g_msg = 'Key:',g_vaj.vaj01 CLIPPED,' + ',g_vaj.vaj02 CLIPPED,' + ',g_vaj.vaj03 CLIPPED  #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vaj01',g_vaj.vaj01,'vaj02',g_vaj.vaj02,'vaj03',g_vaj.vaj03,'','','','','','')   #FUN-940030 ADD
       #CALL err('vaj_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vaj_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vbj_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vbj_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vaj_c:',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p500_vaw()      #工單資料
DEFINE l_sql        STRING
DEFINE l_vmw        RECORD LIKE vmw_file.*
DEFINE l_sfb01      LIKE sfb_file.sfb01,
       l_sfb08      LIKE sfb_file.sfb08,
       l_sfb15      LIKE sfb_file.sfb15,
       l_sfb13      LIKE sfb_file.sfb13,
       l_sfb05      LIKE sfb_file.sfb05,
       l_sfb40      LIKE sfb_file.sfb40,
       l_sfb09      LIKE sfb_file.sfb09,
       l_sfb06      LIKE sfb_file.sfb06,
       l_sfb04      LIKE sfb_file.sfb04,
       l_sfb22      LIKE sfb_file.sfb22,
       l_sfb221     LIKE sfb_file.sfb221,
       l_sfb12      LIKE sfb_file.sfb12 ,  
       l_sfbuser    LIKE sfb_file.sfbuser,
       l_ima08      LIKE ima_file.ima08,
       l_ima55      LIKE ima_file.ima55, 
       l_ima16      LIKE ima_file.ima16,
       l_ima55_fac  LIKE ima_file.ima55_fac, 
       l_sfb41      LIKE sfb_file.sfb41,    
       l_sfb02      LIKE sfb_file.sfb02,
       l_sfb93      LIKE sfb_file.sfb93,
       l_sfb081     LIKE sfb_file.sfb081   #FUN-940090 ADD
DEFINE l_ima12      LIKE ima_file.ima12    
DEFINE l_pmm09      LIKE pmm_file.pmm09

  IF tm.vlb35   = 'N' THEN RETURN END IF

 #FUN-8A0011 ---mod----str---
 #DECLARE p500_vaw_c CURSOR FOR
 #    SELECT sfb01,sfb08,sfb15,sfb13,sfb05,sfb40,sfb08,sfb09,sfb06,sfb04,
 #           sfb22,sfb221,sfb12,sfbuser,ima08,ima55,ima16,ima55_fac,sfb41,ima12,sfb02,sfb93
 #      FROM sfb_file,ima_file
 #     WHERE sfb08 >  sfb09         
 #       AND sfb04 <  '8'            
 #       AND sfb13 <= tm.vlb08       #預計開工日小於資料截止日期
 #       AND ima01 =  sfb05
 #       AND sfb87 != 'X'
 #       AND sfb01 IS NOT NULL 
 #       AND sfb01 != ' '
 IF NOT cl_null(g_vlz70) THEN 
     CALL s_get_sql_msp04(g_vlz70,'sfb01') RETURNING g_sql_limited 
 ELSE
     LET g_sql_limited = ' 1=1 '
 END IF
 LET l_sql = "SELECT sfb01,sfb08,sfb15,sfb13,sfb05,sfb40,sfb08,sfb09,sfb06,sfb04,",
             "       sfb22,sfb221,sfb12,sfbuser,ima08,ima55,ima16,ima55_fac,sfb41,ima12,sfb02,sfb93, ",
             "       sfb081   ",    #FUN-940090 ADD
             "  FROM sfb_file,ima_file ",
            #" WHERE sfb08 >  sfb09 ",                  #FUN-CB0131 mark
             " WHERE sfb08 >  sfb09 + sfb12 ",          #FUN-CB0131 add
             "   AND sfb04 <  '8' ",
             "   AND sfb13 <= '",tm.vlb08,"'",       #預計開工日小於資料截止日期
             "   AND ima01 =  sfb05 ",
             "   AND sfb87 != 'X' ",
             "   AND sfb01 IS NOT NULL  ",
             "   AND sfb01 != ' ' ",
             "   AND ",g_sql_limited CLIPPED


  PREPARE p500_vaw_p FROM l_sql
  IF STATUS THEN CALL cl_err('pre p500_vaw_p',STATUS,1) END IF
  DECLARE p500_vaw_c CURSOR FOR p500_vaw_p
  IF STATUS THEN CALL cl_err('dec p500_vaw_c',STATUS,1) END IF
  #FUN-8A0011 ---mod----end---

  INITIALIZE g_vaw.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vaw_c INTO l_sfb01, l_sfb08 ,l_sfb15,l_sfb13    ,l_sfb05,
                          l_sfb40, l_sfb08 ,l_sfb09,l_sfb06    ,l_sfb04,
                          l_sfb22, l_sfb221,l_sfb12,l_sfbuser  ,
                          l_ima08, l_ima55 ,l_ima16,l_ima55_fac,l_sfb41,l_ima12,l_sfb02,l_sfb93,
                          l_sfb081   #FUN-940090 ADD
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vaw_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vaw.vaw01    = l_sfb01          #製令編號
     LET g_vaw.vaw02    = l_sfb08          #需求數量
     LET g_vaw.vaw03    = l_sfb01          #EPR中對應的製令單號
     IF NOT cl_null(l_sfb15) THEN
         #ERP預計完工日期
         LET g_vaw.vaw04 = l_sfb15                               
     END IF
     IF NOT cl_null(l_sfb13) THEN
         #ERP預計開立日期
         LET g_vaw.vaw05 = l_sfb13 
     END IF
     LET g_vaw.vaw06 = l_sfb05            #製令品號
     LET g_vaw.vaw07 = l_sfb40            #優先順序
    #TQC-8B0036---mod---str--
    #LET g_vaw.vaw08 = l_sfb05 CLIPPED,'-',l_sfb06 CLIPPED #途程編號  #TQC-860041
                     #"標準的品號"    ,'-',"工單號碼"
     LET g_vaw.vaw08 = l_sfb05 CLIPPED,'-',l_sfb01 CLIPPED #工單號碼  
    #TQC-8B0036---mod---end--
     LET g_vaw.vaw09 = l_ima55            #生產單位      
     LET g_vaw.vaw10 = 0                  #製令是否已發料
     LET g_vaw.vaw11 = NULL               #計畫批號
     LET g_vaw.vaw12 = l_sfb09            #已生產量
     LET g_vaw.vaw13 = l_sfb12            
     LET g_vaw.vaw14 = l_sfbuser          
     CASE 
          WHEN l_sfb04 = '1'           LET g_vaw.vaw15 = '1'
          WHEN l_sfb04 MATCHES '[23]'  LET g_vaw.vaw15 = '3'
         #FUN-990090----mod---str----
         #WHEN l_sfb04 MATCHES '[456]' LET g_vaw.vaw15 = '5'
          WHEN l_sfb04 = '4'           LET g_vaw.vaw15 = '4'
          WHEN l_sfb04 MATCHES '[56]'  LET g_vaw.vaw15 = '5'
         #FUN-990090----mod---end----
          WHEN l_sfb04 = '7'           LET g_vaw.vaw15 = '7'
          OTHERWISE                    LET g_vaw.vaw15 = '1'
     END CASE
     LET g_vaw.vaw16 = l_ima55_fac 
     INITIALIZE l_vmw.* TO NULL    #FUN-910005 ADD   
     SELECT * INTO l_vmw.*
       FROM vmw_file
      WHERE vmw01 = g_vaw.vaw01
     
     LET g_vaw.vaw17 = l_vmw.vmw02  

     #FUN-940090  ADD  --STR----------------------------------
     IF NOT cl_null(l_vmw.vmw25) THEN
        LET g_vaw.vaw25 = l_vmw.vmw25  
     ELSE
        LET g_vaw.vaw25 = 0
     END IF
     #FUN-940090  ADD  --END----------------------------------
     IF NOT cl_null(l_sfb41) AND (l_sfb41 MATCHES '[Yy]') THEN
        LET g_vaw.vaw18 = 1
     ELSE
        LET g_vaw.vaw18 = 0
     END IF
     LET g_vaw.vaw19 = l_sfbuser
     LET g_vaw.vaw20 = NULL
     LET g_vaw.vaw21 = 0
     IF NOT cl_null(l_sfb93) AND (l_sfb93 MATCHES '[Yy]') THEN
         LET g_vaw.vaw22 = 1
     ELSE
         LET g_vaw.vaw22 = 0
     END IF
     #TQC-860041---mod---str---
     IF l_sfb02 = '7' THEN
         LET g_vaw.vaw23 = 1
         #vaw24
         LET l_pmm09 = NULL
         SELECT MAX(pmm09)
           INTO l_pmm09
           FROM pmm_file,pmn_file
          WHERE pmn01 = pmm01
            AND pmn41 = l_sfb01
            AND pmm18 <> 'X'                  #TQC-8A0002 add
          
         IF NOT cl_null(l_pmm09) THEN
             LET g_vaw.vaw24 = l_pmm09
         ELSE
             LET g_vaw.vaw24 = g_vlz.vlz72 #參數檔中虛擬外包商
         END IF
     ELSE
         LET g_vaw.vaw23 = 0
         LET g_vaw.vaw24 = NULL 
     END IF
     #TQC-860041---mod---end---
     #FUN-930127  ADD   --STR---------------------
      IF NOT cl_null(l_vmw.vmw26) THEN
         LET g_vaw.vaw26 = l_vmw.vmw26  
      ELSE
         LET g_vaw.vaw26 = 0
      END IF
     #FUN-930127  ADD   --END---------------------
     LET g_vaw.vaw35 = l_sfb081     #FUN-940090 ADD 
     LET g_vaw.vawlegal = g_legal #FUN-B50022 add
     LET g_vaw.vawplant = g_plant #FUN-B50022 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     LET g_vaw.vaw02 = s_digqty(g_vaw.vaw02,g_vaw.vaw09)   #FUN-BB0085
     LET g_vaw.vaw12 = s_digqty(g_vaw.vaw12,g_vaw.vaw09)   #FUN-BB0085
     LET g_vaw.vaw13 = s_digqty(g_vaw.vaw13,g_vaw.vaw09)   #FUN-BB0085
     LET g_vaw.vaw35 = s_digqty(g_vaw.vaw35,g_vaw.vaw09)   #FUN-BB0085
     PUT p500_c_ins_vaw FROM g_vaw.*
     IF STATUS THEN
        #LET g_msg = 'Key:',g_vaw.vaw01 CLIPPED   #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vaw01',g_vaw.vaw01,'','','','','','','','','','')   #FUN-940030 ADD
       #CALL err('vaw_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vaw_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     #FUN-960167 ADD --STR----------------------------------------
     ##流程資料檢核
     ELSE
        IF tm1.flow_datachk = 'Y' THEN
           CALL p450_flowchk(l_sfb01)   
        END IF 
     END IF
     INITIALIZE g_vaw.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vaw_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vaw_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vaw_c:',STATUS,1) RETURN END IF

END FUNCTION
 
FUNCTION p500_vaz_1()      #請購單
DEFINE l_sql       STRING
DEFINE l_vmz   RECORD LIKE vmz_file.*
DEFINE l_pmk04     LIKE pmk_file.pmk04,
       l_pmk09     LIKE pmk_file.pmk09,
       l_pmkuser   LIKE pmk_file.pmkuser,
       l_pmk12     LIKE pmk_file.pmk12,
       l_pml35     LIKE pml_file.pml35,  #TQC-8B0040 mark #FUN-930086 unmark 
       l_pml34     LIKE pml_file.pml34,  #TQC-8B0040 add
       l_pml04     LIKE pml_file.pml04,
       l_pml01     LIKE pml_file.pml01,
       l_pml02     LIKE pml_file.pml02,
       l_pml20     LIKE pml_file.pml20,
       l_pml21     LIKE pml_file.pml21,
       l_pml07     LIKE pml_file.pml07,
       l_pml16     LIKE pml_file.pml16,
       l_pml09     LIKE pml_file.pml09,
       l_pml11     LIKE pml_file.pml11

  IF tm.vlb38  = 'N' THEN RETURN END IF

 #FUN-8A0011 ---mod----str---
 #DECLARE p500_vaz1_c CURSOR FOR
 #    SELECT pmk04,pmk09,pmkuser,pmk12,
 #           pml35,pml04,pml01,pml02,pml20,pml21,pml07,pml16,pml09,pml11
 #      FROM pmk_file,pml_file
 #     WHERE  pml20 > pml21 
 #       AND pml16 <= '2'      
 #       AND pml33 <= tm.vlb08
 #       AND pml01 =  pmk01 
 #       AND pmk02 <>'SUB' 
 #       AND pmk18 != 'X'
 #       AND pml38 =  'Y' 
 IF NOT cl_null(g_vlz70) THEN 
     CALL s_get_sql_msp05(g_vlz70,'pmk10') RETURNING g_sql_limited 
 ELSE
     LET g_sql_limited = ' 1=1 '
 END IF
 #TQC-8A0019---add---str--
 IF NOT cl_null(g_vlz70) THEN 
     CALL s_get_sql_msp04(g_vlz70,'pmk01') RETURNING g_sql_limited2 #TQC-8A0021
 ELSE
     LET g_sql_limited2 = ' 1=1 ' #FUN-8A0062
 END IF
 #TQC-8A0019---add---end--
 LET l_sql = "SELECT pmk04,pmk09,pmkuser,pmk12, ",
            #"       pml35,pml04,pml01,pml02,pml20,pml21,pml07,pml16,pml09,pml11 ", #TQC-8B0040 mark
             "       pml34,pml04,pml01,pml02,pml20,pml21,pml07,pml16,pml09,pml11, ", #TQC-8B0040 mod
             "       pml35  ",  #FUN-930086 ADD
             "  FROM pmk_file,pml_file ",
             " WHERE  pml20 > pml21 ",
            #"   AND pml16 <= '2' ",                                         #FUN-A40017---mark
             "   AND (pml16<='2' OR pml16='S' OR pml16='R' OR pml16='W') ",  #FUN-A40017---add
             "   AND pml33 <= '",tm.vlb08,"'",
             "   AND pml01 =  pmk01 ",
             #"   AND pmk02 <>'SUB' ",  #TQC-940156 MARK
             "   AND pmk18 != 'X' ",
             "   AND pml38 =  'Y' ",
             "   AND ",g_sql_limited  CLIPPED,
             "   AND ",g_sql_limited2 CLIPPED  #TQC-8A0019 add

  PREPARE p500_vaz1_p FROM l_sql
  IF STATUS THEN CALL cl_err('pre p500_vaz1_p',STATUS,1) END IF
  DECLARE p500_vaz1_c CURSOR FOR p500_vaz1_p
  IF STATUS THEN CALL cl_err('dec p500_vaz1_c',STATUS,1) END IF
  #FUN-8A0011 ---mod----end---

  INITIALIZE g_vaz1.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vaz1_c INTO l_pmk04,l_pmk09,l_pmkuser,l_pmk12,
                          #l_pml35,l_pml04,l_pml01,l_pml02,l_pml20,l_pml21,l_pml07, #TQC-8B0040 mark
                           l_pml34,l_pml04,l_pml01,l_pml02,l_pml20,l_pml21,l_pml07, #TQC-8B0040 add
                           l_pml16,l_pml09,l_pml11,
                           l_pml35  #FUN-930086 ADD                                 
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vaz_c:',STATUS,1) EXIT FOREACH
     END IF
     #vaz01
     LET g_vaz1.vaz01    = l_pml01,'-',l_pml02 using '&&&&' #採購單編號
    #TQC-8B0040 mod---str---
    #IF NOT cl_null(l_pml35) THEN
    #   #ERP預計抵達日期
    #   LET g_vaz1.vaz02 = l_pml35   
    #END IF
     IF NOT cl_null(l_pml34) THEN
        #ERP預計抵達日期
        LET g_vaz1.vaz02 = l_pml34   
     END IF
    #TQC-8B0040 mod---end---
     LET g_vaz1.vaz03 = NULL             #供應商位置
     LET g_vaz1.vaz04 = l_pml04          #訂購品項之品號
     LET g_vaz1.vaz05 = l_pml20          #預計請購數量  
     IF NOT cl_null(l_pmk04) THEN
        #ERP預計開立日期
        LET g_vaz1.vaz06 = l_pmk04       
     END IF
     LET g_vaz1.vaz07 = l_pmk09          #供應商編號
     LET g_vaz1.vaz08 = l_pml07          #採購單位
     LET g_vaz1.vaz09 = NULL             #計畫批號
     LET g_vaz1.vaz10 = l_pml01          #採購單編號 
     LET g_vaz1.vaz11 = l_pml21          #已轉採購單  
     INITIALIZE l_vmz.* TO NULL   #FUN-910005ADD
     SELECT * INTO l_vmz.*
       FROM vmz_file
      WHERE vmz01 = g_vaz1.vaz01
     LET g_vaz1.vaz12 = l_vmz.vmz12
     LET g_vaz1.vaz13 = l_pmkuser #擁有者
     LET g_vaz1.vaz25 = l_vmz.vmz25   #FUN-910005 ADD
     LET g_vaz1.vaz26 = l_pml35       #FUN-930086 ADD
     CASE
         WHEN l_pml16 MATCHES '[X0]'
              LET g_vaz1.vaz14 = 1
         WHEN l_pml16 = '1' 
              LET g_vaz1.vaz14 = 3
         #FUN-8C0140  ADD  --STR--
         WHEN l_pml16 = '2'
              LET g_vaz1.vaz14 = 3
         #FUN-8C0140  ADD  --END--
      
     END CASE
     LET g_vaz1.vaz15 = l_pml09
     LET g_vaz1.vaz16 = l_vmz.vmz16
     IF NOT cl_null(l_pml11) AND (l_pml11 MATCHES '[Yy]') THEN
        LET g_vaz1.vaz17 = 1
     ELSE
        LET g_vaz1.vaz17 = 0
     END IF
     LET g_vaz1.vaz18 = 0
     LET g_vaz1.vaz19 = 0
     LET g_vaz1.vaz20 = 0
     LET g_vaz1.vaz21 = l_pmk12   #請購員
     LET g_vaz1.vaz22 = 0
     LET g_vaz1.vaz23 = l_pml02
     LET g_vaz1.vaz24  = '0'
     LET g_vaz1.vazlegal = g_legal #FUN-B50022 add
     LET g_vaz1.vazplant = g_plant #FUN-B50022 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vaz FROM g_vaz1.*
     IF STATUS THEN
        #LET g_msg = 'Key:',g_vaz1.vaz01 CLIPPED  #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vaz01',g_vaz1.vaz01,'','','','','','','','','','')   #FUN-940030 ADD 
       #CALL err('vaz_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vaz_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vaz1.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vaz_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vaz_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vaz1_c:',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p500_vaz_2()      #採購單
DEFINE l_sql       STRING
DEFINE l_vmz       RECORD LIKE vmz_file.*
DEFINE l_ima50     LIKE ima_file.ima50  #TQC-940167 ADD
DEFINE l_ima48     LIKE ima_file.ima48  #TQC-940167 ADD
DEFINE l_ima49     LIKE ima_file.ima49  #TQC-940167 ADD
DEFINE l_ima491    LIKE ima_file.ima491 #TQC-940167 ADD
DEFINE l_pmm04     LIKE pmm_file.pmm04,
       l_pmm09     LIKE pmm_file.pmm09,
       l_pmm12     LIKE pmm_file.pmm12,
       l_pmmuser   LIKE pmm_file.pmmuser,
       l_pmn35     LIKE pmn_file.pmn35, #TQC-8B0040 mark   #FUN-930086 unmark
       l_pmn34     LIKE pmn_file.pmn34, #TQC-8B0040 add
       l_pmn04     LIKE pmn_file.pmn04,
       l_pmn01     LIKE pmn_file.pmn01,
       l_pmn02     LIKE pmn_file.pmn02,
       l_pmn20     LIKE pmn_file.pmn20,
       l_pmn51     LIKE pmn_file.pmn51,
       l_pmn55     LIKE pmn_file.pmn55,
       l_pmn07     LIKE pmn_file.pmn07,
       l_pmn16     LIKE pmn_file.pmn16,
       l_pmn09     LIKE pmn_file.pmn09,
       l_pmn11     LIKE pmn_file.pmn11,
       l_pmn53     LIKE pmn_file.pmn53,
       l_pmn58     LIKE pmn_file.pmn58, #TQC-860041 add
       l_pmn50     LIKE pmn_file.pmn50  #TQC-940156 ADD

  IF tm.vlb39 = 'N' THEN RETURN END IF
 #FUN-8A0011 ---mod----str---
 #DECLARE p500_vaz2_c CURSOR FOR
 #    SELECT pmm04,pmm09,pmm12,pmmuser,
 #           pmn35,pmn04,pmn01,pmn02,pmn20,pmn51,pmn55,pmn07,pmn16,pmn09,pmn11,pmn53,pmn58 #TQC-860041 add pmn58
 #      FROM pmm_file,pmn_file
 #      WHERE pmn20 > (pmn50-pmn55) 
 #        AND pmn16 <= '2' 
 #        AND pmn33 <= tm.vlb08
 #        AND pmn01 =  pmm01 
 #        AND pmm02 <> 'SUB' 
 #        AND pmm18 != 'X'
 #        AND pmn38 =  'Y'   
 IF NOT cl_null(g_vlz70) THEN 
     CALL s_get_sql_msp05(g_vlz70,'pmm10') RETURNING g_sql_limited 
 ELSE
     LET g_sql_limited = ' 1=1 '
 END IF
 #TQC-8A0019---add---str--
 IF NOT cl_null(g_vlz70) THEN 
     CALL s_get_sql_msp04(g_vlz70,'pmm01') RETURNING g_sql_limited2  #TQC-8A0021
 ELSE
     LET g_sql_limited2 = ' 1=1 ' #FUN-8A0062
 END IF
 #TQC-8A0019---add---end--

 #TQC-940156 MOD --STR-------------------------------------------------------
 #LET l_sql = "SELECT pmm04,pmm09,pmm12,pmmuser, ",
 #           #"       pmn35,pmn04,pmn01,pmn02,pmn20,pmn51,pmn55,pmn07,pmn16,pmn09,pmn11,pmn53,pmn58 ", #TQC-860041 add pmn58 #TQC-8B0040 mark
 #            "       pmn34,pmn04,pmn01,pmn02,pmn20,pmn51,pmn55,pmn07,pmn16,pmn09,pmn11,pmn53,pmn58, ", #TQC-860041 add pmn58 #TQC-8B0040 add
 #            "       pmn35  ",   #FUN-930086 ADD
 #            "  FROM pmm_file,pmn_file ",
 #            " WHERE pmn20 > (pmn50-pmn55) ",
 #            "   AND pmn16 <= '2' ",
 #            "   AND pmn33 <= '",tm.vlb08,"'",
 #            "   AND pmn01 =  pmm01 ",
 #            "   AND pmm02 <> 'SUB' ",
 #            "   AND pmm18 != 'X' ",
 #            "   AND pmn38 =  'Y' ",
 #            "   AND ",g_sql_limited  CLIPPED,
 #            "   AND ",g_sql_limited2 CLIPPED  #TQC-8A0019 add
  LET l_sql = "SELECT pmm04,pmm09,pmm12,pmmuser, ",
             "       pmn34,pmn04,pmn01,pmn02,pmn20,pmn51,pmn55,pmn07,pmn16,pmn09,pmn11,pmn53,pmn58, ",
             "       pmn35,pmn50  ",   
             "  FROM pmm_file,pmn_file ",
             " WHERE  ",
             "  CASE  ",
             "     WHEN  pmn20 >= (pmn50-pmn55)  THEN pmn20         ",
             "     WHEN  pmn20 < (pmn50-pmn55)   THEN (pmn50-pmn55) ",
             "     END   > pmn53  ",
            #"   AND pmn16 <= '2' ",                                        #FUN-A40017 ---mark
             "   AND (pmn16<='2' OR pmn16='S' OR pmn16='R' OR pmn16='W') ", #FUN-A40017 ---add
             "   AND pmn33 <= '",tm.vlb08,"'",
             "   AND pmn01 =  pmm01 ",
             "   AND pmm02 <> 'SUB' ",
             "   AND pmm18 != 'X' ",
             "   AND pmn38 =  'Y' ",
             "   AND ",g_sql_limited  CLIPPED,
             "   AND ",g_sql_limited2 CLIPPED  
  #TQC-940156 MOD --STR-------------------------------------------------------

  PREPARE p500_vaz2_p FROM l_sql
  IF STATUS THEN CALL cl_err('pre p500_vaz2_p',STATUS,1) END IF
  DECLARE p500_vaz2_c CURSOR FOR p500_vaz2_p
  IF STATUS THEN CALL cl_err('dec p500_vaz2_c',STATUS,1) END IF
  #FUN-8A0011 ---mod----end---

  INITIALIZE g_vaz2.* TO NULL
  INITIALIZE l_vmz.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vaz2_c INTO l_pmm04,l_pmm09,l_pmm12,l_pmmuser,
                          #l_pmn35,l_pmn04,l_pmn01,l_pmn02,l_pmn20,l_pmn51,l_pmn55,l_pmn07, #TQC-8B0040 mark
                           l_pmn34,l_pmn04,l_pmn01,l_pmn02,l_pmn20,l_pmn51,l_pmn55,l_pmn07, #TQC-8B0040 add
                           l_pmn16,l_pmn09,l_pmn11,l_pmn53,l_pmn58, #TQC-860041 add pmn58
                           l_pmn35,   #FUN-930086 ADD
                           l_pmn50    #TQC-940156 ADD
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vaz_c:',STATUS,1) EXIT FOREACH
     END IF

    #TQC-940176 ADD  --STR-------------------------------------------
     SELECT ima50,ima48,ima49,ima491 INTO l_ima50,l_ima48,l_ima49,l_ima491
       FROM ima_file
      WHERE ima01 = l_pmn04
      IF cl_null(l_ima50) THEN LET l_ima50 = 0  END IF
      IF cl_null(l_ima48) THEN LET l_ima48 = 0  END IF
      IF cl_null(l_ima49) THEN LET l_ima49 = 0  END IF
      IF cl_null(l_ima491) THEN LET l_ima491 = 0  END IF
    #TQC-940167 ADD  --END-------------------------------------------

     LET g_vaz2.vaz01 = l_pmn01,'-',l_pmn02 using '&&&&' #採購單編號
    #TQC-8B0040 mod---str---
    #IF NOT cl_null(l_pmn35) THEN
    #   #ERP預計抵達日期
    #   LET g_vaz2.vaz02 = l_pmn35
    #END IF
     IF NOT cl_null(l_pmn34) THEN
       #FUN-B90040 mod str---
       ##ERP預計抵達日期
       ##TQC-940167 MOD --STR------------------------------------------
       ##LET g_vaz2.vaz02 = l_pmn34
       # IF (g_today + (l_ima50 + l_ima48 + l_ima49)) <= l_pmn34 THEN
       #    LET g_vaz2.vaz02 = (g_today + (l_ima50 + l_ima48 + l_ima49))
       # ELSE
       #    LET g_vaz2.vaz02 = l_pmn34
       # END IF
       ##TQC-940167 MOD --END------------------------------------------
        LET g_vaz2.vaz02 = l_pmn34
       #FUN-B90040 mod end---
     END IF
    #TQC-8B0040 mod---end---
     LET g_vaz2.vaz03 = NULL         #供應商位置
     LET g_vaz2.vaz04 = l_pmn04      #訂購品項之品號

    #TQC-940156 MOD --STR----------------------------
    #LET g_vaz2.vaz05 = l_pmn20      #預計採購數量  
     IF l_pmn20 >= (l_pmn50 - l_pmn55) THEN 
        LET g_vaz2.vaz05 = l_pmn20
     ELSE
        LET g_vaz2.vaz05 = (l_pmn50 - l_pmn55)
     END IF
    #TQC-940156 MOD --END----------------------------

     IF NOT cl_null(l_pmm04) THEN
        #ERP預計開立日期
        LET g_vaz2.vaz06 = l_pmm04     
     END IF
     LET g_vaz2.vaz07 = l_pmm09      #供應商編號
     LET g_vaz2.vaz08 = l_pmn07      #採購單位
     LET g_vaz2.vaz09 = NULL         #計畫批號
     LET g_vaz2.vaz10 = l_pmn01      #EPR中對應的採購令單號
     LET g_vaz2.vaz11 = l_pmn53 #已入庫數量 #TQC-860041--mark  #TQC-940156 unmark
     #LET g_vaz2.vaz11 = l_pmn53 - l_pmn58      #已入庫數量  #TQC-860041--mod

     SELECT * 
       INTO l_vmz.*
       FROM vmz_file
      WHERE vmz01 = g_vaz2.vaz01
     LET g_vaz2.vaz12  = l_vmz.vmz12
     LET g_vaz2.vaz13  = l_pmmuser
     LET g_vaz2.vaz25  = l_vmz.vmz25  #FUN-910005 ADD

   #FUN-B90040 mod str---
   ##TQC-940167 MOD --STR---------------------------
   # #LET g_vaz2.vaz26  = l_pmn35   #FUN-930086 ADD
   #  IF g_vaz2.vaz02 + l_ima491 <= l_pmn35 THEN
   #     LET g_vaz2.vaz26 = g_vaz2.vaz02 + l_ima491
   #  ELSE
   #     LET g_vaz2.vaz26 = l_pmn35
   #  END IF
   ##TQC-940167 MOD --END---------------------------
    LET g_vaz2.vaz26 = l_pmn35
   #FUN-B90040 mod end---

     CASE 
        WHEN l_pmn16 MATCHES '[X0SRW]'
             LET g_vaz2.vaz14 = 5
        WHEN l_pmn16 = '1' 
             LET g_vaz2.vaz14 = 7
        WHEN l_pmn16 = '2'
             LET g_vaz2.vaz14 = 9
     END CASE
     LET g_vaz2.vaz15  = l_pmn09
     LET g_vaz2.vaz16  = l_vmz.vmz16
     IF NOT cl_null(l_pmn11) AND (l_pmn11 MATCHES '[Yy]') THEN
        LET g_vaz2.vaz17 = 1
     ELSE
        LET g_vaz2.vaz17 = 0
     END IF
     LET g_vaz2.vaz18  = l_pmn51
     LET g_vaz2.vaz19  = 0 
     LET g_vaz2.vaz20  = l_pmn55
     LET g_vaz2.vaz21  = l_pmm12
     LET g_vaz2.vaz22  = l_pmn51
     LET g_vaz2.vaz23  = l_pmn02
     LET g_vaz2.vaz24  = '1'
     LET g_vaz2.vazlegal = g_legal #FUN-B50022 add
     LET g_vaz2.vazplant = g_plant #FUN-B50022 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vaz FROM g_vaz2.*
     IF STATUS THEN
        #LET g_msg = 'Key:',g_vaz2.vaz01 CLIPPED  #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vaz01',g_vaz2.vaz01,'','','','','','','','','','')   #FUN-940030 ADD
       #CALL err('vaz_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vaz_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vaz2.* TO NULL
     INITIALIZE l_vmz.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vaz_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vaz_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vaz2_c:',STATUS,1) RETURN END IF
END FUNCTION


FUNCTION p500_vaf() 
DEFINE l_sql            STRING               #FUN-8A0011 add

  IF tm.vlb18  = 'N' THEN RETURN END IF

 #FUN-8A0011 ---mod----str---
 # DECLARE p500_vaf_c CURSOR FOR
 #    SELECT imd01,imd02,imd14,vmf04,vmf05,vmf06  #TQC-860041 add vmf06
 #      FROM imd_file,OUTER vmf_file
 #     WHERE imd01 = vmf_file.vmf01
 #       AND imd12 = 'Y' #MRP可用才要拋轉         #TQC-860041 add
 IF NOT cl_null(g_vlz70) THEN 
     CALL s_get_sql_msp03(g_vlz70,'imd01') RETURNING g_sql_limited 
 ELSE
     LET g_sql_limited = ' 1=1 '
 END IF

  LET l_sql = "SELECT imd01,imd02,imd14,vmf04,vmf05,vmf06,vmf07 ",  #TQC-860041 add vmf06  #FUN-910005 ADD vmf07
              "  FROM imd_file,OUTER vmf_file ",
              " WHERE imd01 = vmf_file.vmf01 ",
              "   AND imd12 = 'Y' ", #MRP可用才要拋轉         #TQC-860041 add
              "   AND ",g_sql_limited CLIPPED

  PREPARE p500_vaf_p FROM l_sql
  IF STATUS THEN CALL cl_err('pre p500_vaf_p',STATUS,1) END IF
  DECLARE p500_vaf_c CURSOR FOR p500_vaf_p
  IF STATUS THEN CALL cl_err('dec p500_vaf_c',STATUS,1) END IF
  #FUN-8A0011 ---mod----end---
        
   
   INITIALIZE g_vaf.* TO NULL
   LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
   FOREACH  p500_vaf_c INTO g_vaf.*
     IF STATUS THEN CALL cl_err('p500_vaf_c',STATUS,1) RETURN END IF
     IF cl_null(g_vaf.vaf03) THEN
        LET g_vaf.vaf03 = 0
     END IF
     IF cl_null(g_vaf.vaf04) THEN
        LET g_vaf.vaf04 = 0
     END IF
     IF cl_null(g_vaf.vaf05) THEN
        LET g_vaf.vaf05 = 0
     END IF
     #TQC-860041 ---add---str--
     IF cl_null(g_vaf.vaf06) THEN
        LET g_vaf.vaf06 = 0
     END IF
     #TQC-860041 ---add---end--
     LET g_vaf.vaflegal = g_legal #FUN-B50022 add
     LET g_vaf.vafplant = g_plant #FUN-B50022 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vaf  FROM g_vaf.*
     IF STATUS THEN
        #LET g_msg = 'Key:',g_vaf.vaf01 CLIPPED  #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vaf01',g_vaf.vaf01,'','','','','','','','','','')   #FUN-940030 ADD
       #CALL err('vaf_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vaf_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
   END FOREACH
   LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
   LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vaf_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vaf_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vaf_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p500_vag()
DEFINE l_sql         STRING

  IF tm.vlb19  = 'N' THEN RETURN END IF

 #FUN-8A0011 ---mod----str---
 # DECLARE p500_vag_c CURSOR FOR
 #    SELECT ime01,ime02,ime03,ime10,vmg05
 #      FROM ime_file,OUTER vmg_file
 #     WHERE ime01 = vmg_file.vmg01
 #       AND ime02 = vmg_file.vmg02
 #       AND ime06='Y' #MRP可用 #TQC-860041 add
 IF NOT cl_null(g_vlz70) THEN 
     CALL s_get_sql_msp03(g_vlz70,'ime01') RETURNING g_sql_limited 
 ELSE
     LET g_sql_limited = ' 1=1 '
 END IF
 LET l_sql = "SELECT ime01,ime02,ime03,ime10,vmg05,vmg06 ",  #FUN-910005  ADD vmg06
             "  FROM ime_file,OUTER vmg_file ",
             " WHERE ime01 = vmg_file.vmg01 ",
             "   AND ime02 = vmg_file.vmg02 ",
             "   AND ime06='Y' ",#MRP可用 #TQC-860041 add
             "   AND imeacti = 'Y' ",   #FUN-D40103 
             "   AND ",g_sql_limited CLIPPED

  PREPARE p500_vag_p FROM l_sql
  IF STATUS THEN CALL cl_err('pre p500_vag_p',STATUS,1) END IF
  DECLARE p500_vag_c CURSOR FOR p500_vag_p
  IF STATUS THEN CALL cl_err('dec p500_vag_c',STATUS,1) END IF
  #FUN-8A0011 ---mod----end---
   
   INITIALIZE g_vag.* TO NULL
   LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
   FOREACH  p500_vag_c INTO g_vag.*
     IF STATUS THEN CALL cl_err('p500_vag_c',STATUS,1) RETURN END IF
     IF cl_null(g_vag.vag04) THEN
         LET g_vag.vag04 = 0
     END IF
     IF cl_null(g_vag.vag05) THEN
         LET g_vag.vag05 = 0
     END IF
     LET g_vag.vaglegal = g_legal #FUN-B50022 add
     LET g_vag.vagplant = g_plant #FUN-B50022 add
     
     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vag  FROM g_vag.*
     IF STATUS THEN
        #LET g_msg = 'Key:',g_vag.vag01 CLIPPED,' + ',  #FUN-940030 MARK
        #                   g_vag.vag02 CLIPPED         #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vag01',g_vag.vag01,'vag02',g_vag.vag02,'','','','','','','','')   #FUN-940030 ADD
       #CALL err('vag_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vag_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vag.* TO NULL
   END FOREACH
   LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
   LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vag_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vag_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vag_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p500_ins_vlb() #APS 資料產生記錄檔

  SELECT COUNT(*) INTO g_cnt FROM vlb_file
   WHERE vlb01 = tm.vlb01           #/*限定版本*/
     AND vlb02 = tm.vlb02           #/*儲存版本*/
     AND vlb03 = tm.vlb03           #/*產生人員*/
     AND vlb00 = g_vlb00           #/*型態 1前置 2正式 FUN-940030 ADD*/
  IF g_cnt >=1 THEN
      DELETE FROM vlb_file
      WHERE vlb01 = tm.vlb01        #/*限定版本*/
        AND vlb02 = tm.vlb02        #/*儲存版本*/
        AND vlb03 = tm.vlb03        #/*產生人員*/
        AND vlb00 = g_vlb00        #/*型態 1前置 2正式 FUN-940030 ADD*/
     IF STATUS THEN
         CALL cl_err3("del","vlb_file",tm.vlb01,tm.vlb02,STATUS,"","del vlb_file fail:",1)  
     END IF
  END IF
  LET tm.vlb06 = TIME            #/*結束時間*/
  
  INSERT INTO vlb_file
         #FUN-940030  ADD  --STR--
         (vlb00,
          vlb01, vlb02, vlb03, vlb04, vlb05,
          vlb06, vlb07, vlb08, vlb09, vlb10,
          vlb11, vlb12, vlb13, vlb14, vlb15,
          vlb16, vlb17, vlb18, vlb19, vlb20,
          vlb21, vlb22, vlb23, vlb24, vlb25,
          vlb26, vlb27, vlb28, vlb29, vlb30,
          vlb31, vlb32, vlb33, vlb34, vlb35,
          vlb36, vlb37, vlb38, vlb39, vlb40,
          vlb41, vlb42, vlb43, vlb44, vlb45,
          vlb46, vlb47,  
          vlb48, vlb49, vlb50, vlbplant,vlblegal ) #FUN-B50022 add vlbplant,vlblegal
         #FUN-940030  ADD  --END--
     VALUES(
     g_vlb00,  #FUN-940030 ADD vlb00
     tm.vlb01, tm.vlb02, tm.vlb03, tm.vlb04, tm.vlb05,
     tm.vlb06, tm.vlb07, tm.vlb08, tm.vlb09, tm.vlb10,
     tm.vlb11, tm.vlb12, tm.vlb13, tm.vlb14, tm.vlb15,
     tm.vlb16, tm.vlb17, tm.vlb18, tm.vlb19, tm.vlb20,
     tm.vlb21, tm.vlb22, tm.vlb23, tm.vlb24, tm.vlb25,
     tm.vlb26, tm.vlb27, tm.vlb28, tm.vlb29, tm.vlb30,
     tm.vlb31, tm.vlb32, tm.vlb33, tm.vlb34, tm.vlb35,
     tm.vlb36, tm.vlb37, tm.vlb38, tm.vlb39, tm.vlb40,
     tm.vlb41, tm.vlb42, tm.vlb43, tm.vlb44, tm.vlb45,
     tm.vlb46, tm.vlb47,  #FUN-8A0003 add vlb47
     tm.vlb48, tm.vlb49, tm.vlb50,g_plant,g_legal ) #FUN-940030 ADD vlb48,49,50 #FUN-B50022 add vlbplant,vlblegal
  IF STATUS THEN
     CALL cl_err3("ins","vlb_file",tm.vlb01,tm.vlb02,STATUS,"","ins vlb_file fail:",1)  

  END IF
END FUNCTION

FUNCTION p500_del()
DEFINE l_sql            STRING

  #DELETE FROM vlc_file  WHERE  1=1   #FUN-940030 MARK
  #FUN-940030 ADD--STR--
    DELETE FROM vlc_file  
     WHERE  vlc00=g_vlb00 
       AND vlc01=tm.vlb01 
       AND vlc02=tm.vlb02  
       AND vlc11=tm.vlb03  
  #FUN-940030 ADD  --END--

  IF STATUS THEN CALL cl_err('del_vlc',STATUS,1) END IF
  #FUN-BC0040 add-----str---
    DELETE FROM vlq_file  
     WHERE vlq01=tm.vlb01 
       AND vlq02='1999/12/31'
  IF STATUS THEN CALL cl_err('del_vlq:str',STATUS,1) END IF
  #FUN-BC0040 add-----end---
 #FUN-B10068 mark---str
 #vzy_file:aps 多廠區設定檔
 #vzt_file:資料庫參數設定檔
 #這二個檔案不可刪除
 #IF tm.vlb09  = 'Y' THEN 
 #   DELETE FROM vzy_file WHERE 1=1 
 #   IF STATUS THEN CALL cl_err('del_vzy',STATUS,1) END IF
 #   DELETE FROM vzt_file WHERE 1=1 
 #   IF STATUS THEN CALL cl_err('del_vzt',STATUS,1) END IF
 #END IF                  
 #FUN-B10068 mark---end
 #IF tm.vlb10  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vzz_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_vzz',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb11  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vaa_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_vaa',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb12  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vab_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_vab',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb13  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vac_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_vac',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb14  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vbh_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_vbh',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb15  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vbi_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_vbi',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb16  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vad_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_vad',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb17  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vae_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_vae',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb18  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vaf_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_vaf',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb19  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vag_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_vag',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb20  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vah_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_vah',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb21  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vai_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_vai',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb22  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vaj_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_vaj',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb23  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vak_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_vak',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb24  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM val_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_val',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb25  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vam_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_vam',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb26  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM van_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_van',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb27  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vao_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_vao',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb28  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vap_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_vap',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb29  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vaq_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_vaq',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb30  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM var_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_var',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb31  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vas_file WHERE 1=1
     IF STATUS THEN CALL cl_err('del_vas',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb32  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vat_file WHERE 1=1
     IF STATUS THEN CALL cl_err('del_vat',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb33  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vau_file WHERE 1=1
     IF STATUS THEN CALL cl_err('del_vau',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb34  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vav_file WHERE 1=1
     IF STATUS THEN CALL cl_err('del_vav',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb35  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vaw_file WHERE 1=1
     IF STATUS THEN CALL cl_err('del_vaw',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb36  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vax_file WHERE 1=1
     IF STATUS THEN CALL cl_err('del_vax',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb37  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vay_file WHERE 1=1
     IF STATUS THEN CALL cl_err('del_vay',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb38  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vaz_file WHERE 1=1
     IF STATUS THEN CALL cl_err('del_vaz',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #FUN-B10068 mark---str---
 #IF tm.vlb39  = 'Y' THEN 
 #   DELETE FROM vaz_file WHERE 1=1
 #   IF STATUS THEN CALL cl_err('del_vaz',STATUS,1) END IF
 #END IF                 
 #FUN-B10068 mark---end---
 #IF tm.vlb40  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vba_file WHERE 1=1
     IF STATUS THEN CALL cl_err('del_vba',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb41  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vbb_file WHERE 1=1
     IF STATUS THEN CALL cl_err('del_vbb',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb42  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vbc_file WHERE 1=1
     IF STATUS THEN CALL cl_err('del_vbc',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb43  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vbd_file WHERE 1=1
     IF STATUS THEN CALL cl_err('del_vbd',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb44  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vbe_file WHERE 1=1
     IF STATUS THEN CALL cl_err('del_vbe',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb45  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vbf_file WHERE 1=1
     IF STATUS THEN CALL cl_err('del_vbf',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
 #IF tm.vlb46  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vbg_file WHERE 1=1
     IF STATUS THEN CALL cl_err('del_vbg',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
  #FUN-8A0003 ---add---str---
 #IF tm.vlb47  = 'Y' THEN #FUN-B10068 mark
     DELETE FROM vbj_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_vbj',STATUS,1) END IF
     DELETE FROM vbk_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_vbk',STATUS,1) END IF
     DELETE FROM vbl_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_vbl',STATUS,1) END IF
     DELETE FROM vbm_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_vbm',STATUS,1) END IF
     DELETE FROM vbn_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_vbn',STATUS,1) END IF
     DELETE FROM vbo_file WHERE 1=1 
     IF STATUS THEN CALL cl_err('del_vbo',STATUS,1) END IF
 #END IF                  #FUN-B10068 mark
  #FUN-8A0003 ---add---end---

END FUNCTION

#FUNCTION err(p_vlc05,err_code1,err_code2)   #FUN-940030 MARK
FUNCTION err(p_vlc05,err_code1,err_code2,p_vlc09)   #FUN-940030 ADD
 DEFINE p_vlc05    LIKE vlc_file.vlc05
 DEFINE p_vlc09    LIKE vlc_file.vlc09
 DEFINE err_code2  LIKE vlc_file.vlc07    
 DEFINE err_code1  LIKE vlc_file.vlc06    
 DEFINE l_vlc      RECORD LIKE vlc_file.*

  LET l_vlc.vlc00 = g_vlb00  #FUN-940030 ADD
  LET l_vlc.vlc01 = tm.vlb01
  LET l_vlc.vlc02 = tm.vlb02
  LET l_vlc.vlc03 = g_today
  LET l_vlc.vlc04 = TIME

  #LET l_vlc.vlc05 = p_vlc05   #FUN-940030  MARK
  LET l_vlc.vlc06 = err_code1

  #FUN-940030 ADD --STR--
  IF p_vlc09 = '2' THEN
    #取出訊息名稱，若無則直接以 err_get 取出訊息代碼
      LET l_vlc.vlc07 = NULL
      SELECT  ze03 INTO l_vlc.vlc07
        FROM  ze_file
        WHERE ze01 = err_code2 
          AND ze02 = g_lang

      IF cl_null(l_vlc.vlc07) THEN 
         LET l_vlc.vlc07 = err_get(err_code2)
      END IF
  ELSE
    LET  l_vlc.vlc07 = err_code2
  END IF
  #FUN-940030  ADD  --END-- 
  #LET l_vlc.vlc07 = err_get(err_code2)   #FUN-940030 MARK

   #FUN-940030   ADD  --STR--
     IF p_vlc09 = '2' THEN
        LET l_vlc.vlc08 = err_code2   
     ELSE
        LET l_vlc.vlc08 = ''
     END IF
     LET l_vlc.vlc09 = p_vlc09      
     CASE
      WHEN p_vlc05 = 'vzy_file'     LET l_vlc.vlc10 = 'apss300'
      WHEN p_vlc05 = 'vzz_file'     LET l_vlc.vlc10 = 'apss301'
      WHEN p_vlc05 = 'vaa_file'     LET l_vlc.vlc10 = 'apsi300'
      WHEN p_vlc05 = 'vab_file'     LET l_vlc.vlc10 = 'apsi301'
      WHEN p_vlc05 = 'vac_file'     LET l_vlc.vlc10 = 'apsi302'
      WHEN p_vlc05 = 'vbh_file'     LET l_vlc.vlc10 = 'apmi600'
      WHEN p_vlc05 = 'vbi_file'     LET l_vlc.vlc10 = 'aeci600'
      WHEN p_vlc05 = 'vbg_file'     LET l_vlc.vlc10 = 'apsi311'  #FUN-960039 ADD
      WHEN p_vlc05 = 'vad_file' AND g_funname='p500_vad_1'   LET l_vlc.vlc10 = 'aeci670'  
      WHEN p_vlc05 = 'vad_file' AND g_funname='p500_vad_2'   LET l_vlc.vlc10 = 'aeci600'
      WHEN p_vlc05 = 'vae_file' AND g_funname='p500_vae_1'   LET l_vlc.vlc10 = 'apsi304'
      WHEN p_vlc05 = 'vae_file' AND g_funname='p500_vae_2'   LET l_vlc.vlc10 = 'apsi322'
      WHEN p_vlc05 = 'vaf_file'     LET l_vlc.vlc10 = 'aimi200'
      WHEN p_vlc05 = 'vag_file'     LET l_vlc.vlc10 = 'aimi201'
      WHEN p_vlc05 = 'vah_file'     LET l_vlc.vlc10 = 'apsi307'
      WHEN p_vlc05 = 'vai_file'     LET l_vlc.vlc10 = 'aimi100'
      WHEN p_vlc05 = 'vaj_file'     LET l_vlc.vlc10 = 'aimq102'
      WHEN p_vlc05 = 'vak_file'     LET l_vlc.vlc10 = 'apmi254'
      WHEN p_vlc05 = 'val_file'     LET l_vlc.vlc10 = 'apsi310'
      WHEN p_vlc05 = 'vam_file' AND g_funname='p500_vam_1'   LET l_vlc.vlc10 = 'aeci100'
      WHEN p_vlc05 = 'vam_file' AND g_funname='p500_vam_2'   LET l_vlc.vlc10 = 'aeci700'
      WHEN p_vlc05 = 'vam_file' AND g_funname='p500_vam_3'   LET l_vlc.vlc10 = 'aimi100'
      WHEN p_vlc05 = 'van_file' AND g_funname='p500_van_1'   LET l_vlc.vlc10 = 'aeci100'
      WHEN p_vlc05 = 'van_file' AND g_funname='p500_van_2'   LET l_vlc.vlc10 = 'aeci700'
      WHEN p_vlc05 = 'van_file' AND g_funname='p500_van_3'   LET l_vlc.vlc10 = 'apsi326'
      WHEN p_vlc05 = 'vao_file'     LET l_vlc.vlc10 = 'abmi600'
      WHEN p_vlc05 = 'vap_file'     LET l_vlc.vlc10 = 'aeci100'
      WHEN p_vlc05 = 'var_file'     LET l_vlc.vlc10 = 'abmi604'
      WHEN p_vlc05 = 'vaq_file'     LET l_vlc.vlc10 = 'abmi604'
      WHEN p_vlc05 = 'vas_file'     LET l_vlc.vlc10 = 'axmi221'
      WHEN p_vlc05 = 'vat_file'     LET l_vlc.vlc10 = 'apsi314'
      WHEN p_vlc05 = 'vau_file'     LET l_vlc.vlc10 = 'apsi400'
      WHEN p_vlc05 = 'vav_file'     LET l_vlc.vlc10 = 'axmt406'
      WHEN p_vlc05 = 'vaw_file'     LET l_vlc.vlc10 = 'asfi301'
      WHEN p_vlc05 = 'vax_file'     LET l_vlc.vlc10 = 'asfi301'
      WHEN p_vlc05 = 'vay_file'     LET l_vlc.vlc10 = 'aeci700'
      WHEN p_vlc05 = 'vaz_file' AND g_funname='p500_vaz_1'    LET l_vlc.vlc10 = 'apmt420'
      WHEN p_vlc05 = 'vaz_file' AND g_funname='p500_vaz_2'    LET l_vlc.vlc10 = 'apmt540'
      WHEN p_vlc05 = 'vba_file' AND g_funname='p500_vba_1'    LET l_vlc.vlc10 = 'apsi318'
     #WHEN p_vlc05 = 'vba_file' AND g_funname='p500_vba_2'    LET l_vlc.vlc10 = 'axmp450' #FUN-BA0086 mark
      WHEN p_vlc05 = 'vba_file' AND g_funname='p500_vba_2'    LET l_vlc.vlc10 = 'axmi661' #FUN-BA0086 add
      WHEN p_vlc05 = 'vbb_file'     LET l_vlc.vlc10 = 'apsi319'
      WHEN p_vlc05 = 'vbc_file'     LET l_vlc.vlc10 = 'apsi328'
      WHEN p_vlc05 = 'vbd_file'     LET l_vlc.vlc10 = 'apsi311'
      WHEN p_vlc05 = 'vbe_file'     LET l_vlc.vlc10 = 'apsi315'
      WHEN p_vlc05 = 'vbf_file'     LET l_vlc.vlc10 = 'apsi323'
      WHEN p_vlc05 = 'vbg_file'     LET l_vlc.vlc10 = 'apsi324'
      WHEN p_vlc05 = 'vbj_file'     LET l_vlc.vlc10 = 'afai300'
      WHEN p_vlc05 = 'vbk_file'     LET l_vlc.vlc10 = 'apsi330'
      WHEN p_vlc05 = 'vbl_file'     LET l_vlc.vlc10 = 'apsi330'
      WHEN p_vlc05 = 'vbm_file'     LET l_vlc.vlc10 = 'apsi331'
      WHEN p_vlc05 = 'vbn_file'     LET l_vlc.vlc10 = 'apsi332'
      WHEN p_vlc05 = 'vbo_file'     LET l_vlc.vlc10 = 'apsi333'
      OTHERWISE
        LET  l_vlc.vlc10 = ''
    END CASE
    LET l_vlc.vlc11 = tm.vlb03  
    LET l_vlc.vlc05 = p_vlc05  
   #FUN-940030   ADD  --END-- 

   #FUN-B50022---add----str--
    LET l_vlc.vlcplant = g_plant
    LET l_vlc.vlclegal = g_legal
   #FUN-B50022---add----end--
   INSERT INTO vlc_file VALUES(l_vlc.*)   #FUN-940030 MARK

  #FUN-940030 ADD  --STR--
  #INSERT INTO vlc_file(vlc00,vlc01,vlc02,vlc03,vlc04,vlc05,vlc06,vlc07,vlc08,vlc09,vlc10,vlc11)
  #  VALUES(l_vlc.vlc00,l_vlc.vlc01,l_vlc.vlc02,l_vlc.vlc03,l_vlc.vlc04,p_vlc05,l_vlc.vlc06,l_vlc.vlc07,l_vlc.vlc08,l_vlc.vlc09,l_vlc.vlc10,l_vlc.vlc11)
  #FUN-940030 ADD  --END--

END FUNCTION

FUNCTION p500_out()
 DEFINE l_i           LIKE type_file.num5,    
        l_name        LIKE type_file.chr20,   
        sr            RECORD LIKE vlc_file.*,
        l_za05        LIKE type_file.chr1000 

    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang

    DECLARE p500_cs CURSOR FOR 
     SELECT * FROM vlc_file
      WHERE vlc01 = tm.vlb01
        AND vlc02 = tm.vlb02
    CALL cl_outnam('apsp500') RETURNING l_name
    SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'aoop500'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 100 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    START REPORT p500_rep TO l_name
    FOREACH p500_cs INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        OUTPUT TO REPORT p500_rep(sr.*)
    END FOREACH

    FINISH REPORT p500_rep

    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION

REPORT p500_rep(sr)
    DEFINE
        l_trailer_sw   LIKE type_file.chr1,    
        sr RECORD LIKE vlc_file.*

   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line

    ORDER BY sr.vlc05,sr.vlc03,sr.vlc04

    FORMAT
        PAGE HEADER
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
            PRINT ' '
            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
            PRINT ' '
            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
                COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
            PRINT g_dash[1,g_len]  
            LET l_trailer_sw = 'y'

        BEFORE GROUP OF sr.vlc05
            PRINT sr.vlc05 CLIPPED
           #CASE sr.vlc05
           #  WHEN 'vbi'  LET g_msg = g_x[11] CLIPPED #zaa資料為中文檔案名稱+產生
           #  WHEN 'var'  LET g_msg = g_x[12] CLIPPED
           #  WHEN 'vaa'  LET g_msg = g_x[13] CLIPPED
           #  WHEN 'vac'  LET g_msg = g_x[14] CLIPPED
           #  WHEN 'vab'  LET g_msg = g_x[15] CLIPPED
           #  WHEN 'vad'  LET g_msg = g_x[16] CLIPPED
           #  WHEN 'vae'  LET g_msg = g_x[17] CLIPPED
           #  WHEN 'vai'  LET g_msg = g_x[18] CLIPPED
           #  WHEN 'vak'  LET g_msg = g_x[19] CLIPPED
           #  WHEN 'vao'  LET g_msg = g_x[20] CLIPPED
           #  WHEN 'vaq'  LET g_msg = g_x[21] CLIPPED
           #  WHEN 'vas'  LET g_msg = g_x[22] CLIPPED
           #  WHEN 'vam'  LET g_msg = g_x[23] CLIPPED
           #  WHEN 'van'  LET g_msg = g_x[24] CLIPPED
           #  WHEN 'vav'  LET g_msg = g_x[25] CLIPPED
           #  WHEN 'vau1' LET g_msg = g_x[26] CLIPPED
           #  WHEN 'vau2' LET g_msg = g_x[27] CLIPPED
           #  WHEN 'vba1' LET g_msg = g_x[28] CLIPPED
           #  WHEN 'vax'  LET g_msg = g_x[29] CLIPPED
           #  WHEN 'vaj'  LET g_msg = g_x[30] CLIPPED
           #  WHEN 'vaw'  LET g_msg = g_x[31] CLIPPED
           #  WHEN 'vaz1' LET g_msg = g_x[32] CLIPPED
           #  WHEN 'vaz2' LET g_msg = g_x[33] CLIPPED
           #  WHEN 'vba2' LET g_msg = g_x[34] CLIPPED
           #  WHEN 'val'  LET g_msg = g_x[35] CLIPPED
           #  WHEN 'vbb'  LET g_msg = g_x[36] CLIPPED
           #  WHEN 'vat'  LET g_msg = g_x[37] CLIPPED
           #  WHEN 'vag'  LET g_msg = g_x[38] CLIPPED
           #  WHEN 'vah'  LET g_msg = g_x[39] CLIPPED
           #  WHEN 'vaf'  LET g_msg = g_x[40] CLIPPED
           #  WHEN 'vzz'  LET g_msg = g_x[41] CLIPPED
           #END CASE
           #PRINT sr.vlc05,':',g_msg CLIPPED

        ON EVERY ROW
            PRINT COLUMN 1, sr.vlc03 CLIPPED,
                  COLUMN 10,sr.vlc04 CLIPPED,
                  COLUMN 19,sr.vlc06 CLIPPED
            PRINT COLUMN 19,sr.vlc07 CLIPPED

        ON LAST ROW
            PRINT g_dash[1,g_len]  
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),
                  g_x[7] CLIPPED
            LET l_trailer_sw = 'n'

        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]   
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),
                      g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT

FUNCTION p500_vak()
  DEFINE l_ima      RECORD LIKE ima_file.*
  DEFINE l_pmh      RECORD LIKE pmh_file.*
  DEFINE l_vmk      RECORD LIKE vmk_file.*
  DEFINE l_cnt      LIKE type_file.num10   
  DEFINE l_sql      STRING                
  DEFINE l_vlq_vak  LIKE type_file.num5    #FUN-BC0040 add

  IF tm.vlb23  = 'N' THEN RETURN END IF  

  #TQC-860041---mod---str---
  #FUN-930078  MARK  --STR--
  #LET l_sql = "SELECT ima_file.*,vmk_file.* ",
  #            "  FROM ima_file,OUTER vmk_file ",
  #            "  WHERE ima01 = vmk_file.vmk01 ",
  #            "    AND ima54 = vmk_file.vmk02 ",
  #            "    AND ima54 IS NOT NULL ",
  #            "    AND imaacti = 'Y' "
  #IF NOT cl_null(g_vla.vla02) THEN
  #    LET l_sql = l_sql CLIPPED," AND imadate >= '",g_vla.vla02,"'" #基本資料最後異動日
  #END IF
  #FUN-930078  MAKR  --END--

  #FUN-930078  ADD --STR--
  #FUN-B50022---mod---str---
  #LET l_sql = "SELECT pmh_file.*,ima_file.*,vmk_file.* ",
  #            "  FROM pmh_file, ima_file, vmk_file, ",
  #            "       (SELECT pmh01 mpmh01, pmh02 mpmh02, pmh22 mpmh22, max(pmh06) mpmh06 ", #CHI-940025 ADD
  #            "          FROM pmh_file  ",   #CHI-940025 ADD
  #            "         WHERE pmhacti = 'Y'  ",   #CHI-940025 ADD
  #            "         GROUP BY pmh01,pmh02,pmh22) mpmh_file ",  #CHI-940025 ADD
  #            "  WHERE pmh01 = ima_file.ima01(+) ",
  #            "    AND pmh01 = vmk_file.vmk01(+) ",
  #            "    AND pmhacti = 'Y' ",
  #            "    AND pmh02 = vmk_file.vmk02(+) ",
  #            "    AND pmh01 = mpmh01  ",  #CHI-940025 ADD
  #            "    AND pmh02 = mpmh02  ",  #CHI-940025 ADD
  #            "    AND pmh06 = mpmh06  ",   #CHI-940025 ADD
  #            "    AND pmh22 = mpmh22  ",   #CHI-940025 ADD
  #            "    AND pmh22 = vmk_file.vmk19(+)  "  #CHI-940025 ADD
   LET l_sql = "SELECT pmh_file.*,ima_file.*,vmk_file.* ",
               "  FROM pmh_file ",
               "  LEFT OUTER JOIN ima_file ON pmh01 = ima01",
               "  LEFT OUTER JOIN vmk_file ON pmh01 = vmk01 AND pmh02 = vmk02 AND pmh22 = vmk19 ,",
               "       (SELECT pmh01 mpmh01, pmh02 mpmh02, pmh22 mpmh22, max(pmh06) mpmh06 ", #CHI-940025 ADD
               "          FROM pmh_file  ",   #CHI-940025 ADD
               "         WHERE pmhacti = 'Y'  ",   #CHI-940025 ADD
               "         GROUP BY pmh01,pmh02,pmh22) mpmh_file ",  #CHI-940025 ADD
               "  WHERE pmhacti = 'Y' ",
               "    AND pmh01 = mpmh01  ",  #CHI-940025 ADD
               "    AND pmh02 = mpmh02  ",  #CHI-940025 ADD
#              "    AND pmh06 = mpmh06  ",   #CHI-940025 ADD                 #FUN-C20017 mark
               "    AND NVL(pmh06,'9999/12/31') = NVL(mpmh06,'9999/12/31')",  #FUN-C20017 add
               "    AND pmh22 = mpmh22  "    #CHI-940025 ADD
  #FUN-B50022---mod---end---
   IF NOT cl_null(g_vla.vla02) THEN
     #FUN-BC0040---mark----str---
     ##FUN-B80055---mod---str---
     ##LET l_sql = l_sql CLIPPED," AND pmhdate >= '",g_vla.vla02,"'"   #基本資料最後異動日
     # LET l_sql = l_sql CLIPPED," AND (pmhdate >= '",g_vla.vla02,"'", #基本資料最後異動日
     #                           "  OR  imadate >= '",g_vla.vla02,"')" #基本資料最後異動日
     ##FUN-B80055---mod---end---
     #FUN-BC0040---mark----end---

      #FUN-BC0040---add-----str---
      SELECT COUNT(*) INTO l_vlq_vak
        FROM vlq_file
       WHERE vlq01 = tm.vlb01 
         AND vlq02 = g_vla.vla02
         AND vlq03 = '4' #p500_vak()
      IF l_vlq_vak >=1 THEN
          LET l_sql = l_sql CLIPPED," AND (pmhdate >= '",g_vla.vla02,"'" ,#基本資料最後異動日
                                    "  OR  imadate >= '",g_vla.vla02,"'" ,#基本資料最後異動日
                                    "  OR  pmh01 IN (SELECT vlq04 FROM vlq_file ",
                                    "                 WHERE vlq01 = '",tm.vlb01,"'",
                                    "                   AND vlq02 = '",g_vla.vla02,"'",
                                    "                   AND vlq03 = '4' ))" #p500_vak()
      ELSE
          LET l_sql = l_sql CLIPPED," AND (pmhdate >= '",g_vla.vla02,"'", #基本資料最後異動日
                                    "  OR  imadate >= '",g_vla.vla02,"')" #基本資料最後異動日
      END IF
      #FUN-BC0040---add-----end---
   END IF
  #FUN-930078  ADD  --END--

  PREPARE p500_vak_p FROM l_sql
  IF STATUS THEN CALL cl_err('pre p500_vak_p',STATUS,1) END IF
  DECLARE p500_vak_c CURSOR FOR p500_vak_p
  IF STATUS THEN CALL cl_err('dec p500_vak_c',STATUS,1) END IF
  #TQC-860041---mod---end---

  INITIALIZE g_vak.* TO NULL
  INITIALIZE l_vmk.* TO NULL
  INITIALIZE l_ima.* TO NULL
  INITIALIZE l_pmh.* TO NULL  #FUN-930078 ADD
  
  #FUN-930078  MOD  --STR--  
    #FOREACH p500_vak_c INTO l_ima.*,l_vmk.* #TQC-860041 mod
    LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
    FOREACH p500_vak_c INTO l_pmh.*,l_ima.*,l_vmk.*
  #FUN-930078  MOD  --END--

     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vak_c:',STATUS,1) EXIT FOREACH
     END IF
    
     #TQC-860041---mod---str--
     #vak01
     #LET g_vak.vak01 = l_ima.ima01   #FUN-930078 MARK
     LET g_vak.vak01 = l_pmh.pmh01   #FUN-930078 ADD
     #vak02
     #LET g_vak.vak02 = l_ima.ima54   #FUN-930078 MARK
     LET g_vak.vak02 = l_pmh.pmh02   #FUN-930078 ADD
     #vak03
     IF cl_null(l_ima.ima45) THEN 
         LET g_vak.vak03 = 1 
     ELSE
         LET g_vak.vak03 = l_ima.ima45
     END IF
     #vak04
     LET g_vak.vak04 = NULL 
     #vak05
     IF NOT cl_null(l_vmk.vmk05) THEN
         LET g_vak.vak05 = l_vmk.vmk05
     ELSE
         LET g_vak.vak05 = 999999
     END IF
     #vak06
     IF NOT cl_null(l_ima.ima46) THEN 
         LET g_vak.vak06 = l_ima.ima46
     ELSE
         LET g_vak.vak06 = 0 
     END IF
     #vak07
     LET g_vak.vak07 = l_ima.ima44
     #vak08
     IF NOT cl_null(l_ima.ima491) THEN 
         LET g_vak.vak08 = l_ima.ima491
     ELSE
         LET g_vak.vak08 = 0 
     END IF
     #vak09
     IF cl_null(l_ima.ima50) THEN LET l_ima.ima50 = 0 END IF
     IF cl_null(l_ima.ima48) THEN LET l_ima.ima48 = 0 END IF
     IF cl_null(l_ima.ima49) THEN LET l_ima.ima49 = 0 END IF
     LET g_vak.vak09 = l_ima.ima50 + l_ima.ima48 + l_ima.ima49
     #vak10
     IF NOT cl_null(l_vmk.vmk10) THEN
         LET g_vak.vak10 = l_vmk.vmk10
     ELSE
         LET g_vak.vak10 = 0
     END IF
     #vak11
     IF NOT cl_null(l_vmk.vmk11) THEN
         LET g_vak.vak11 = l_vmk.vmk11
     ELSE
         LET g_vak.vak11 = 1
     END IF
     #vak12
     IF NOT cl_null(l_vmk.vmk12) THEN
         LET g_vak.vak12 = l_vmk.vmk12
     ELSE
         LET g_vak.vak12 = 0
     END IF
     #vak13
     IF NOT cl_null(l_vmk.vmk13) THEN
         LET g_vak.vak13 = l_vmk.vmk13
     ELSE
         LET g_vak.vak13 = 1
     END IF
     #vak14
     IF NOT cl_null(l_ima.ima44_fac) THEN
         LET g_vak.vak14 = l_ima.ima44_fac
     ELSE
         LET g_vak.vak14 = 1
     END IF
     #vak15
     IF NOT cl_null(l_vmk.vmk15) THEN
         LET g_vak.vak15 = l_vmk.vmk15
     ELSE
         LET g_vak.vak15 = 0
     END IF
     #vak16
     IF NOT cl_null(l_vmk.vmk16) THEN
         LET g_vak.vak16 = l_vmk.vmk16
     ELSE
         LET g_vak.vak16 = 0
     END IF
     #vak17
     IF NOT cl_null(l_vmk.vmk17) THEN
         LET g_vak.vak17 = l_vmk.vmk17
     ELSE
         LET g_vak.vak17 = 0
     END IF
     #vak18
     #LET g_vak.vak18 = 100   #FUN-930078 MARK
     LET g_vak.vak18 = l_pmh.pmh11   #FUN-930078 MARK
     LET g_vak.vak19 = l_pmh.pmh22   #FUN-930149 ADD
     LET g_vak.vaklegal = g_legal #FUN-B50022 add
     LET g_vak.vakplant = g_plant #FUN-B50022 add
     #FUN-B90040 add str---
     #vak28
     SELECT pmc03 INTO g_vak.vak28
       FROM pmc_file
      WHERE pmc01 = l_pmh.pmh02
     #FUN-B90040 add end---

     #FUN-BA0035 add str---
     #vak29
     LET g_vak.vak29 = l_vmk.vmk20
     #vak30
     LET g_vak.vak30 = l_vmk.vmk21
     #FUN-BA0035 add end---

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vak  FROM g_vak.*
     IF STATUS THEN
        #LET g_msg='Key:',g_vak.vak01 CLIPPED,' + ',g_vak.vak02 CLIPPED  #FUN-940030 MARK
       #CALL p500_getmsg('vak01',g_vak.vak01,'vak02',g_vak.vak02,'','','','','','','','')   #FUN-940030 ADD  #FUN-930149 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vak01',g_vak.vak01,'vak02',g_vak.vak02,'vak19',g_vak.vak19,'','','','','','')   #FUN-930149 ADD
       #CALL err('vak_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vak_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
        #FUN-BC0040----add-----str----
        INSERT INTO vlq_file(vlq01,vlq02,vlq03,vlq04,vlq05,vlqlegal,vlqplant)
             VALUES(tm.vlb01,'1999/12/31','4',g_vak.vak01,' ',g_legal,g_plant)
        IF SQLCA.SQLCODE !=0 AND NOT cl_sql_dup_value(SQLCA.SQLCODE) THEN 
            CALL cl_err3("ins","vlq_file",g_vak.vak01,'4:p500_vak()',SQLCA.SQLCODE,"","ins vlq_file fail:4",1)  
        END IF
        #FUN-BC0040----add-----end----
     END IF
     #TQC-860041---mod---end--
     INITIALIZE g_vak.* TO NULL
     INITIALIZE l_vmk.* TO NULL
     INITIALIZE l_ima.* TO NULL
     INITIALIZE l_pmh.* TO NULL   #FUN-930078 ADD
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vak_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vak_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vak_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p500_van_1()  #途程製程--標準(aeci100)
DEFINE l_ecb        RECORD LIKE ecb_file.*
DEFINE l_vmn        RECORD LIKE vmn_file.*
DEFINE l_cnt        LIKE type_file.num10   
DEFINE l_eca06      LIKE eca_file.eca06
DEFINE l_sql        STRING                
DEFINE l_chr5       LIKE type_file.chr5 #TQC-860041 add
DEFINE l_vlq_van_1  LIKE type_file.num5    #FUN-BC0040 add

  IF tm.vlb26  = 'N' THEN RETURN END IF  

 #TQC-8A0019 ---mod----str---
 #
 #DECLARE p500_van_1_c CURSOR FOR
 #  SELECT ecb_file.*,vmn_file.*
 #    FROM ecb_file,OUTER vmn_file
 #   WHERE ecb01 = vmn_file.vmn01 #料件編號
 #     AND ecb02 = vmn_file.vmn02 #製程編號 
 #     AND ecb03 = vmn_file.vmn03 #製程序號 
 #     AND ecb06 = vmn_file.vmn04 #作業編號
 #     AND ecb_file.ecbacti = 'Y'
  LET l_sql = "SELECT ecb_file.*,vmn_file.* ",
             #"  FROM ecb_file,OUTER vmn_file ",           #FUN-B60152 mark
              "  FROM ecu_file,ecb_file,OUTER vmn_file ",  #FUN-B60152 add ecu_file
              " WHERE ecb01 = vmn_file.vmn01 ", #料件編號
              "   AND ecb02 = vmn_file.vmn02 ", #製程編號 
              "   AND ecb03 = vmn_file.vmn03 ", #製程序號 
              "   AND ecb06 = vmn_file.vmn04 ", #作業編號
              "   AND ecb012 = vmn_file.vmn012 ", #製程段號 #FUN-B50101 add
              "   AND ecb_file.ecbacti = 'Y' ",
              "   AND ecu01 = ecb01 ", #料件編號           #FUN-B60152 add
              "   AND ecu02 = ecb02 ", #製程編號           #FUN-B60152 add
              "   AND ecuacti = 'Y' "                      #FUN-B60152 add
  IF NOT cl_null(g_vla.vla02) THEN
     #LET l_sql = l_sql CLIPPED," AND ecbdate >= '",g_vla.vla02,"'" #基本資料最後異動日 #FUN-B60152 mark
     #LET l_sql = l_sql CLIPPED," AND ecudate >= '",g_vla.vla02,"'" #基本資料最後異動日 #FUN-B60152 add #FUN-BC0040 mark
      #FUN-BC0040---add-----str---
      SELECT COUNT(*) INTO l_vlq_van_1
        FROM vlq_file
       WHERE vlq01 = tm.vlb01 
         AND vlq02 = g_vla.vla02
         AND vlq03 = '5' #p500_van_1()
      IF l_vlq_van_1 >=1 THEN
          LET l_sql = l_sql CLIPPED," AND (ecudate >= '",g_vla.vla02,"'" ,#基本資料最後異動日 
                                    " OR  (ecu01,ecu02) IN (SELECT vlq04,vlq05 FROM vlq_file ",
                                    "                        WHERE vlq01 = '",tm.vlb01,"'",
                                    "                          AND vlq02 = '",g_vla.vla02,"'",
                                    "                          AND vlq03 = '5' ))" #p500_vai()
      ELSE
          LET l_sql = l_sql CLIPPED," AND ecudate >= '",g_vla.vla02,"'" #基本資料最後異動日 
      END IF
      #FUN-BC0040---add-----end---
  END IF

  PREPARE p500_van_1_p FROM l_sql
  IF STATUS THEN CALL cl_err('pre p500_van_1_p',STATUS,1) END IF
  DECLARE p500_van_1_c CURSOR FOR p500_van_1_p
  IF STATUS THEN CALL cl_err('dec p500_van_1_c',STATUS,1) END IF
  #TQC-8A0019 ---mod----end---

  INITIALIZE g_van.* TO NULL
  INITIALIZE l_vmn.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_van_1_c INTO l_ecb.*,l_vmn.*
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_van_1_c:',STATUS,1) EXIT FOREACH
     END IF

     LET g_van.van01 = l_ecb.ecb01
     LET g_van.van02 = l_ecb.ecb01 CLIPPED,'-',l_ecb.ecb02 CLIPPED #TQC-860041
     LET l_chr5  = l_ecb.ecb03 USING '&&&&&' #TQC-860041
     LET g_van.van03 = l_chr5                #TQC-860041
     LET g_van.van04 = l_ecb.ecb06
     IF cl_null(g_van.van04) THEN
         LET g_van.van04 = ' '
     END IF
     LET g_van.van05 = NULL
     LET g_van.van06 = NULL
     IF g_vlz.vlz60 = 1 THEN 
         #1:機器編號
         LET g_van.van07 = l_ecb.ecb07
         LET g_van.van08 = l_vmn.vmn08
     ELSE
         #0:工作站
         LET g_van.van07 = l_ecb.ecb08
         LET g_van.van08 = l_vmn.vmn081
     END IF
     #van09
     IF NOT cl_null(l_vmn.vmn09) THEN
        LET g_van.van09 = l_vmn.vmn09
     ELSE
        LET g_van.van09 = 0
     END IF
     #van10
    #TQC-880005 mark
    #IF g_vlz.vlz60 = 1 THEN 
    #    #1:機器編號
    #    LET g_van.van10 = l_ecb.ecb20
    #    LET g_van.van11 = l_ecb.ecb21
    #ELSE
         #0:工作站
         SELECT eca06 INTO l_eca06
           FROM eca_file
          WHERE eca01 = l_ecb.ecb08 #TQC-870005 mod
         IF l_eca06 = '1' THEN
             #'1':機器產能
             LET g_van.van10 = l_ecb.ecb20
             LET g_van.van11 = l_ecb.ecb21
         ELSE
             #'2':人工產能 
             LET g_van.van10 = l_ecb.ecb18
             LET g_van.van11 = l_ecb.ecb19
         END IF
    #END IF #TQC-880005 mark

    #TQC-910057  MARK  --STR--
    # IF cl_null(g_van.van10) THEN
    #     LET g_van.van10 = 0
    #     LET g_van.van11 = 0
    # END IF
     IF cl_null(g_van.van10) THEN
         LET g_van.van10 = 0
     END IF
     IF cl_null(g_van.van11) THEN
         LET g_van.van11 = 0 
     END IF
    #TQC-910057  MARK  --END--


     #van12
     IF NOT cl_null(l_vmn.vmn12) THEN
        LET g_van.van12 = l_vmn.vmn12
     ELSE
        LET g_van.van12 = 0
     END IF
     #van13
     IF NOT cl_null(l_vmn.vmn13) THEN
        LET g_van.van13 = l_vmn.vmn13
     ELSE
        LET g_van.van13 = 1
     END IF
     #van14
     IF NOT cl_null(l_ecb.ecb39) AND (l_ecb.ecb39 MATCHES '[Yy]') THEN
        LET g_van.van14 = 1
     ELSE
        LET g_van.van14 = 0
     END IF
     #van15
     IF NOT cl_null(l_vmn.vmn15) THEN
        LET g_van.van15 = l_vmn.vmn15
     ELSE
        LET g_van.van15 = 0
     END IF
     #van16
     IF NOT cl_null(l_vmn.vmn16) THEN
        LET g_van.van16 = l_vmn.vmn16
     ELSE
        LET g_van.van16 = 9999
     END IF
     #van17
     IF NOT cl_null(l_vmn.vmn17) THEN
        LET g_van.van17 = l_vmn.vmn17
     ELSE
        LET g_van.van17 = 1
     END IF
     LET g_van.van18 = l_ecb.ecb01 #TQC-860041 add
     LET g_van.van19 = l_ecb.ecb02 #TQC-860041 add
     #FUN-890059----add---str
     #van25外包商編號
     IF NOT cl_null(l_vmn.vmn18) THEN
        LET g_van.van25 = l_vmn.vmn18
     ELSE
        LET g_van.van25 = g_vlz.vlz72
     END IF
     #當van14 = 1(外包)時,van07值為van25
     IF g_van.van14 = 1 THEN 
         LET g_van.van07 = g_van.van25
     END IF
     #FUN-890059----add---end

     #TQC-8C0014--add---str--
     #van26批量後置時間
     IF NOT cl_null(l_vmn.vmn19) THEN
        LET g_van.van26 = l_vmn.vmn19
     ELSE
        LET g_van.van26 = 0
     END IF
     LET g_van.van27 = l_ecb.ecb17  #FUN-930127 ADD
     LET g_van.vanlegal = g_legal #FUN-B50022 add
     LET g_van.vanplant = g_plant #FUN-B50022 add
     #TQC-8C0014--add---end--
  
     #FUN-B50101---add----str----
     LET g_van.van36 = l_ecb.ecb012  #製程段號  
     LET g_van.van37 = ''            #下製程段號 
     LET g_van.van38 = l_ecb.ecb46   #組成用量
     LET g_van.van39 = l_ecb.ecb51   #底數
     #FUN-B50101---add----end----
     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_van  FROM g_van.*
     IF STATUS THEN
        #FUN-940030  MARK  --STR--
        #LET g_msg = 'Key:',g_van.van01 CLIPPED,' + ',
        #                   g_van.van02 CLIPPED,' + ',
        #                   g_van.van03 CLIPPED,' + ',
        #                   g_van.van04 CLIPPED
        #FUN-940030  MARK   --END--
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('van01',g_van.van01,'van02',g_van.van02,'van03',g_van.van03,'van04',g_van.van04,'','','','')   #FUN-940030 ADD
       #CALL err('van_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('van_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
        #FUN-BC0040----add-----str----
        INSERT INTO vlq_file(vlq01,vlq02,vlq03,vlq04,vlq05,vlqlegal,vlqplant)
             VALUES(tm.vlb01,'1999/12/31','5',l_ecb.ecb01,l_ecb.ecb02,g_legal,g_plant)
        IF SQLCA.SQLCODE !=0 AND NOT cl_sql_dup_value(SQLCA.SQLCODE) THEN 
            CALL cl_err3("ins","vlq_file",l_ecb.ecb01,l_ecb.ecb02,SQLCA.SQLCODE,"","ins vlq_file fail:5",1)  
        END IF
        #FUN-BC0040----add-----end----
     END IF
     INITIALIZE g_van.* TO NULL
     INITIALIZE l_vmn.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('van_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('van_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_van_1_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p500_van_2()  #途程製程--工單(aeci700)
DEFINE l_vmn        RECORD LIKE vmn_file.*
DEFINE l_ecm        RECORD LIKE ecm_file.*
DEFINE l_cnt        LIKE type_file.num10   
DEFINE l_eca06      LIKE eca_file.eca06
DEFINE l_sfb06      LIKE sfb_file.sfb06
DEFINE l_sql        STRING                
DEFINE l_chr5       LIKE type_file.chr5
DEFINE l_pmm09      LIKE pmm_file.pmm09 #FUN-890059 add
DEFINE l_vmn18      LIKE vmn_file.vmn18 #FUN-890059 add
DEFINE l_sfb08      LIKE sfb_file.sfb08 #TQC-8C0034 add

  IF tm.vlb26  = 'N' THEN RETURN END IF  

 #FUN-8A0011 ---mod----str---
 #DECLARE p500_van_2_c CURSOR FOR
 #  SELECT *
 #    FROM ecm_file
 #   WHERE ecmacti = 'Y'
 #   ORDER BY ecm01,ecm03
 IF NOT cl_null(g_vlz70) THEN 
     CALL s_get_sql_msp04(g_vlz70,'ecm01') RETURNING g_sql_limited 
 ELSE
     LET g_sql_limited = ' 1=1 '
 END IF

  LET l_sql = "SELECT ecm_file.* ", 
              "  FROM ecm_file,sfb_file",
              " WHERE ecmacti = 'Y' ",
              "   AND ",g_sql_limited CLIPPED,
              #工單條件------str---
              "   AND sfb01 = ecm01 ",
             #"   AND sfb08 > sfb09 ",              #FUN-CB0131 mark
              "   AND sfb08 > sfb09 + sfb12 ",      #FUN-CB0131 add
              "   AND sfb04 <  '8' ",
              "   AND sfb13 <= '",tm.vlb08,"'",       #預計開工日小於資料截止日期
              "   AND sfb87 != 'X' ",
              "   AND sfb01 IS NOT NULL ",
              "   AND sfb01 != ' ' ",
              #工單條件------end---
              " ORDER BY ecm01,ecm03,ecm012 " #FUN-B50101 add ecm012

  PREPARE p500_van_2_p FROM l_sql
  IF STATUS THEN CALL cl_err('pre p500_van_2_p',STATUS,1) END IF
  DECLARE p500_van_2_c CURSOR FOR p500_van_2_p
  IF STATUS THEN CALL cl_err('dec p500_van_2_c',STATUS,1) END IF
  #FUN-8A0011 ---mod----end---

  INITIALIZE g_van.* TO NULL
  INITIALIZE l_vmn.* TO NULL
  INITIALIZE l_ecm.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_van_2_c INTO l_ecm.*
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_van_2_c:',STATUS,1) EXIT FOREACH
     END IF
    
     SELECT * INTO l_vmn.*
       FROM vmn_file
      WHERE vmn01 = l_ecm.ecm03_par #料號
        AND vmn02 = l_ecm.ecm01     #工單編號
        AND vmn03 = l_ecm.ecm03     #加工序號
        AND vmn04 = l_ecm.ecm04     #作業編號
       
     LET g_van.van01 = l_ecm.ecm03_par
     LET g_van.van02 = l_ecm.ecm03_par CLIPPED,'-',l_ecm.ecm01 CLIPPED #TQC-860041
     LET l_chr5  = l_ecm.ecm03 USING '&&&&&' #TQC-860041
     LET g_van.van03 = l_chr5                #TQC-860041
     LET g_van.van04 = l_ecm.ecm04
     IF cl_null(g_van.van04) THEN
         LET g_van.van04 = ' '
     END IF
     LET g_van.van05 = NULL
     LET g_van.van06 = NULL
     IF g_vlz.vlz60 = 1 THEN 
         #1:機器編號
         LET g_van.van07 = l_ecm.ecm05
         LET g_van.van08 = l_vmn.vmn08
     ELSE
         #0:工作站
         LET g_van.van07 = l_ecm.ecm06
         LET g_van.van08 = l_vmn.vmn081
     END IF
     #van09
     IF NOT cl_null(l_vmn.vmn09) THEN
        LET g_van.van09 = l_vmn.vmn09
     ELSE
        LET g_van.van09 = 0
     END IF
     #van10
    #TQC-880005 mark
    #IF g_vlz.vlz60 = 1 THEN 
    #    #1:機器編號
    #    LET g_van.van10 = l_ecm.ecm15
    #    LET g_van.van11 = l_ecm.ecm16
    #ELSE
         #0:工作站
         SELECT eca06 INTO l_eca06
           FROM eca_file
         #WHERE eca01 = l_ecm.ecm08 #TQC-880005 mod #TQC-8A0002
          WHERE eca01 = l_ecm.ecm06                 #TQC-8A0002 
         #TQC-8C0034--add---str--

         #TQC-910049  MOD  --STR--
          #SELECT sfb08 INTO l_sfb08
          #  FROM sfb_file
          # WHERE sfb08 = l_ecm.ecm01
          SELECT sfb08 INTO l_sfb08
            FROM sfb_file
           WHERE sfb01 = l_ecm.ecm01
         #TQC-910049  MOD  --END--


         IF cl_null(l_sfb08) OR l_sfb08 = 0 THEN
             LET l_sfb08 = 1
         END IF
         #TQC-8C0034--add---end--
         IF l_eca06 = '1' THEN
             #'1':機器產能
             LET g_van.van10 = l_ecm.ecm15
            #LET g_van.van11 = l_ecm.ecm16/l_sfb08 #TQC-8C0034--mod #FUN-BA0020 mark
             LET g_van.van11 = l_vmn.vmn21 #單一標準機器工時  #FUN-BA0020
         ELSE
             #'2':人工產能 
             LET g_van.van10 = l_ecm.ecm13
            #LET g_van.van11 = l_ecm.ecm14/l_sfb08 #TQC-8C0034--mod #FUN-BA0020 mark
             LET g_van.van11 = l_vmn.vmn20 #單一標準人工工時  #FUN-BA0020
         END IF
    #END IF #TQC-880005 mark
    #TQC-910057  MARK  --STR--
    # IF cl_null(g_van.van10) THEN
    #     LET g_van.van10 = 0
    #     LET g_van.van11 = 0
    # END IF
     IF cl_null(g_van.van10) THEN
         LET g_van.van10 = 0
     END IF
     IF cl_null(g_van.van11) THEN
         LET g_van.van11 = 0 
     END IF
    #TQC-910057  MARK  --END--


     #van12
     IF NOT cl_null(l_vmn.vmn12) THEN
        LET g_van.van12 = l_vmn.vmn12
     ELSE
        LET g_van.van12 = 0
     END IF
     #van13
     IF NOT cl_null(l_vmn.vmn13) THEN
        LET g_van.van13 = l_vmn.vmn13
     ELSE
        LET g_van.van13 = 1
     END IF
     #van14
     IF NOT cl_null(l_ecm.ecm52) AND (l_ecm.ecm52 MATCHES '[Yy]') THEN
        LET g_van.van14 = 1
     ELSE
        LET g_van.van14 = 0
     END IF
     #van15
     IF NOT cl_null(l_vmn.vmn15) THEN
        LET g_van.van15 = l_vmn.vmn15
     ELSE
        LET g_van.van15 = 0
     END IF
     #van16
     IF NOT cl_null(l_vmn.vmn16) THEN
        LET g_van.van16 = l_vmn.vmn16
     ELSE
        LET g_van.van16 = 9999
     END IF
     #van17
     IF NOT cl_null(l_vmn.vmn17) THEN
        LET g_van.van17 = l_vmn.vmn17
     ELSE
        LET g_van.van17 = 1
     END IF
     LET g_van.van18 = l_ecm.ecm03_par #TQC-860041 add
     LET g_van.van19 = l_ecm.ecm01     #TQC-860041 add
     #FUN-890059----add---str
     #van25外包商編號
     #先抓取pmm09給van25,若join不到則抓取aeci700的apsi326的vmn18,
     #若vmn18為空值則抓取標準製程aeci100的vmn18,若vmn18為空值,則抓取vlz72
     LET l_pmm09 = NULL
     SELECT MAX(pmm09)
       INTO l_pmm09
       FROM pmm_file,pmn_file
      WHERE pmn01 = pmm01
        AND pmn41 = l_ecm.ecm01
        AND pmn43 = l_ecm.ecm03 #本製程序 #TQC-8A0002 add
        AND pmm18 <> 'X'                  #TQC-8A0002 add
     IF NOT cl_null(l_pmm09) THEN
         LET g_van.van25 = l_pmm09
     ELSE
         IF NOT cl_null(l_vmn.vmn18) THEN
             LET g_van.van25 = l_vmn.vmn18
         ELSE
             LET l_vmn18 = NULL
             SELECT vmn18 INTO l_vmn18
               FROM vmn_file
              WHERE vmn01 = l_ecm.ecm03_par #料號
                AND vmn02 IN (
                              SELECT sfb06
                                FROM sfb_file
                               WHERE sfb01 = l_ecm.ecm01
                             )
                AND vmn03 = l_ecm.ecm03     #加工序號
                AND vmn04 = l_ecm.ecm04     #作業編號
              IF NOT cl_null(l_vmn18) THEN
                  LET g_van.van25 = l_vmn18
              ELSE
                  LET g_van.van25 = g_vlz.vlz72
              END IF
         END IF
     END IF
     #當van14 = 1(外包)時,van07值為van25
     IF g_van.van14 = 1 THEN 
         LET g_van.van07 = g_van.van25
     END IF
     #FUN-890059----add---end
     #TQC-8C0014--add---str--
     #van26批量後置時間
     IF NOT cl_null(l_vmn.vmn19) THEN
        LET g_van.van26 = l_vmn.vmn19
     ELSE
        LET g_van.van26 = 0
     END IF
     LET g_van.van27 = l_ecm.ecm45   #FUN-930127 ADD
     #TQC-8C0014--add---end--
     LET g_van.vanlegal = g_legal #FUN-B50022 add
     LET g_van.vanplant = g_plant #FUN-B50022 add
     #FUN-B50101---add----str----
     LET g_van.van36 = l_ecm.ecm012  #製程段號  
     LET g_van.van37 = l_ecm.ecm015 #下製程段號 
     LET g_van.van38 = l_ecm.ecm62   #組成用量
     LET g_van.van39 = l_ecm.ecm63   #底數
     #FUN-B50101---add----end----
     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_van  FROM g_van.*
     IF STATUS THEN
        #FUN-940030  MARK   --STR--
        #LET g_msg = 'Key:',g_van.van01 CLIPPED,' + ',
        #                   g_van.van02 CLIPPED,' + ',
        #                   g_van.van03 CLIPPED,' + ',
        #                   g_van.van04 CLIPPED
        #FUN-940030  MARK   --END--
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('van01',g_van.van01,'van02',g_van.van02,'van03',g_van.van03,'van04',g_van.van04,'','','','')   #FUN-940030 ADD
       #CALL err('van_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('van_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_van.* TO NULL
     INITIALIZE l_vmn.* TO NULL
     INITIALIZE l_ecm.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('van_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('van_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_van_2_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p500_van_3()  #替代作業維護檔(apsi326)
DEFINE l_ecb        RECORD LIKE ecb_file.*
DEFINE l_vmn        RECORD LIKE vmn_file.*
DEFINE l_vms        RECORD LIKE vms_file.*
DEFINE l_cnt        LIKE type_file.num10   
DEFINE l_eca06      LIKE eca_file.eca06
DEFINE l_sql        STRING                
DEFINE l_chr5       LIKE type_file.chr5 #TQC-860041 add
DEFINE l_vlq_van_3  LIKE type_file.num5    #FUN-BC0040 add

  IF tm.vlb26  = 'N' THEN RETURN END IF  

 #FUN-B70024 ---mod----str---
 #DECLARE p500_van_3_c CURSOR FOR
 #  SELECT vms_file.*,ecb_file.*,vmn_file.*
 #    FROM vms_file,OUTER ecb_file,OUTER vmn_file
 #   WHERE vms01 = ecb01 #料件編號
 #     AND vms02 = ecb02 #製程編號
 #     AND vms03 = ecb03 #製程序號
 #     AND ecbacti = 'Y'
 #     AND vms01 = vmn01
 #     AND vms02 = vmn02
 #     AND vms03 = vmn03
 #     AND vms04 = vmn04
  LET l_sql = "SELECT vms_file.*,ecb_file.*,vmn_file.* ",
              "  FROM ecu_file,vms_file,OUTER ecb_file,OUTER vmn_file ",
              " WHERE vms01 = ecb_file.ecb01 ",#料件編號
              "   AND vms02 = ecb_file.ecb02 ",#製程編號
              "   AND vms03 = ecb_file.ecb03 ",#製程序號
              "   AND ecb_file.ecbacti = 'Y' ",
              "   AND vms01 = vmn_file.vmn01 ",
              "   AND vms02 = vmn_file.vmn02 ",
              "   AND vms03 = vmn_file.vmn03 ",
              "   AND vms04 = vmn_file.vmn04 ",
              "   AND ecu01 = vms01 ", #料件編號
              "   AND ecu02 = vms02 ", #製程編號
              "   AND ecuacti = 'Y' "
  IF NOT cl_null(g_vla.vla02) THEN
     #LET l_sql = l_sql CLIPPED," AND ecudate >= '",g_vla.vla02,"'" #基本資料最後異動日 #FUN-BC0040 mark
      #FUN-BC0040---add-----str---
      SELECT COUNT(*) INTO l_vlq_van_3
        FROM vlq_file
       WHERE vlq01 = tm.vlb01 
         AND vlq02 = g_vla.vla02
         AND vlq03 = '6' #p500_van_3()
      IF l_vlq_van_3 >=1 THEN
          LET l_sql = l_sql CLIPPED," AND (ecudate >= '",g_vla.vla02,"'" ,#基本資料最後異動日
                                    " OR  (ecu01,ecu02) IN (SELECT vlq04,vlq05 FROM vlq_file ",
                                    "                        WHERE vlq01 = '",tm.vlb01,"'",
                                    "                          AND vlq02 = '",g_vla.vla02,"'",
                                    "                          AND vlq03 = '6' ))" #p500_van_3()
      ELSE
          LET l_sql = l_sql CLIPPED," AND ecudate >= '",g_vla.vla02,"'" #基本資料最後異動日
      END IF
      #FUN-BC0040---add-----end---
  END IF

  PREPARE p500_van_3_p FROM l_sql
  IF STATUS THEN CALL cl_err('pre p500_van_3_p',STATUS,1) END IF
  DECLARE p500_van_3_c CURSOR FOR p500_van_3_p
  IF STATUS THEN CALL cl_err('dec p500_van_3_c',STATUS,1) END IF
 #FUN-B70024 ---mod----end---

  INITIALIZE g_van.* TO NULL
  INITIALIZE l_vmn.* TO NULL
  INITIALIZE l_vms.* TO NULL
  INITIALIZE l_ecb.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_van_3_c INTO l_vms.*,l_ecb.*,l_vmn.*
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_van_3_c:',STATUS,1) EXIT FOREACH
     END IF

     LET g_van.van01 = l_vms.vms01
     LET g_van.van02 = l_ecb.ecb01 CLIPPED,'-',l_ecb.ecb02 CLIPPED #TQC-860041
     LET l_chr5  = l_vms.vms03 USING '&&&&&' #TQC-860041
     LET g_van.van03 = l_chr5                #TQC-860041
     #TQC-860041---mod---str---
     IF NOT cl_null(l_vms.vms04) THEN        
         LET g_van.van04 = l_vms.vms04
     ELSE
         LET g_van.van04 = ' '
     END IF
     #TQC-860041---mod---end---
     LET g_van.van05 = NULL
     LET g_van.van06 = NULL
     IF g_vlz.vlz60 = 1 THEN 
         #1:機器編號
        #LET g_van.van07 = l_ecb.ecb07 #TQC-8A0002
         LET g_van.van07 = l_vms.vms08 #TQC-8A0002
         LET g_van.van08 = l_vmn.vmn08
     ELSE
         #0:工作站
        #LET g_van.van07 = l_ecb.ecb08 #TQC-8A0002
         LET g_van.van07 = l_vms.vms07 #TQC-8A0002
         LET g_van.van08 = l_vmn.vmn081
     END IF
     #van09
     IF NOT cl_null(l_vmn.vmn09) THEN
        LET g_van.van09 = l_vmn.vmn09
     ELSE
        LET g_van.van09 = 0
     END IF
     #van10
    #TQC-880005 mark
    #IF g_vlz.vlz60 = 1 THEN 
    #    #1:機器編號
    #    LET g_van.van10 = l_ecb.ecb20
    #    LET g_van.van11 = l_ecb.ecb21
    #ELSE
         #0:工作站
         SELECT eca06 INTO l_eca06
           FROM eca_file
          WHERE eca01 = l_vms.vms07        #FUN-890059 mod
         IF l_eca06 = '1' THEN
             #'1':機器產能
             LET g_van.van10 = l_vms.vms11 #FUN-890059 mod
             LET g_van.van11 = l_vms.vms12 #FUN-890059 mod
         ELSE
             #'2':人工產能 
             LET g_van.van10 = l_vms.vms09 #FUN-890059 mod
             LET g_van.van11 = l_vms.vms10 #FUN-890059 mod
         END IF
    #END IF #TQC-880005 mark

    #TQC-910057  MARK  --STR--
    # IF cl_null(g_van.van10) THEN
    #     LET g_van.van10 = 0
    #     LET g_van.van11 = 0
    # END IF
     IF cl_null(g_van.van10) THEN
         LET g_van.van10 = 0
     END IF
     IF cl_null(g_van.van11) THEN
         LET g_van.van11 = 0 
     END IF
    #TQC-910057  MARK  --END--

     #van12
     IF NOT cl_null(l_vmn.vmn12) THEN
        LET g_van.van12 = l_vmn.vmn12
     ELSE
        LET g_van.van12 = 0
     END IF
     #van13
     IF NOT cl_null(l_vmn.vmn13) THEN
        LET g_van.van13 = l_vmn.vmn13
     ELSE
        LET g_van.van13 = 1
     END IF
     #van14
    #IF NOT cl_null(l_ecb.ecb39) AND (l_ecb.ecb39 MATCHES '[Yy]') THEN #FUN-890059 mark
     IF NOT cl_null(l_vms.vms13) AND (l_vms.vms13 MATCHES '[Yy]') THEN #FUN-890059 mod
        LET g_van.van14 = 1
     ELSE
        LET g_van.van14 = 0
     END IF
     #van15
     IF NOT cl_null(l_vms.vms06) THEN
        LET g_van.van15 = l_vms.vms06
     ELSE
        LET g_van.van15 = 0
     END IF
     #van16
     IF NOT cl_null(l_vmn.vmn16) THEN
        LET g_van.van16 = l_vmn.vmn16
     ELSE
        LET g_van.van16 = 9999
     END IF
     #van17
     IF NOT cl_null(l_vmn.vmn17) THEN
        LET g_van.van17 = l_vmn.vmn17
     ELSE
        LET g_van.van17 = 1
     END IF
     LET g_van.van18 = l_ecb.ecb01 #TQC-860041 add
     LET g_van.van19 = l_ecb.ecb02 #TQC-860041 add
     #FUN-890059----add---str
     #van25外包商編號
     IF NOT cl_null(l_vmn.vmn18) THEN
        LET g_van.van25 = l_vmn.vmn18
     ELSE
        LET g_van.van25 = g_vlz.vlz72
     END IF
     #當van14 = 1(外包)時,van07值為van25
     IF g_van.van14 = 1 THEN 
         LET g_van.van07 = g_van.van25
     END IF
     #FUN-890059----add---end
     #TQC-8C0014--add---str--
     #van26批量後置時間
     IF NOT cl_null(l_vmn.vmn19) THEN
        LET g_van.van26 = l_vmn.vmn19
     ELSE
        LET g_van.van26 = 0
     END IF

    #FUN-930127  ADD  --STR--
     SELECT ecd02 INTO g_van.van27
       FROM ecd_file
      WHERE ecd01 = l_vms.vms04
    #FUN-930127 ADD  --END--

     #TQC-8C0014--add---end--
     LET g_van.vanlegal = g_legal #FUN-B50022 add
     LET g_van.vanplant = g_plant #FUN-B50022 add
     #FUN-B50101---add----str----
     LET g_van.van36 = l_vms.vms012  #製程段號  
     LET g_van.van37 = ''            #下製程段號 
     LET g_van.van38 = 1             #組成用量
     LET g_van.van39 = 1             #底數
     #FUN-B50101---add----end----
     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_van  FROM g_van.*
     IF STATUS THEN
        #FUN-940030  MARK   --STR--
        #LET g_msg = 'Key:',g_van.van01 CLIPPED,' + ',
        #                   g_van.van02 CLIPPED,' + ',
        #                   g_van.van03 CLIPPED,' + ',
        #                   g_van.van04 CLIPPED
        #FUN-940030   MARK   --END--
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('van01',g_van.van01,'van02',g_van.van02,'van03',g_van.van03,'van04',g_van.van04,'','','','')   #FUN-940030 ADD
       #CALL err('van_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('van_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
        #FUN-BC0040----add-----str----
        INSERT INTO vlq_file(vlq01,vlq02,vlq03,vlq04,vlq05,vlqlegal,vlqplant)
             VALUES(tm.vlb01,'1999/12/31','6',l_ecb.ecb01,l_ecb.ecb02,g_legal,g_plant)
        IF SQLCA.SQLCODE !=0 AND NOT cl_sql_dup_value(SQLCA.SQLCODE) THEN 
            CALL cl_err3("ins","vlq_file",g_van.van01,g_van.van02,SQLCA.SQLCODE,"","ins vlq_file fail:6",1)  
        END IF
        #FUN-BC0040----add-----end----
     END IF
     INITIALIZE g_van.* TO NULL
     INITIALIZE l_vmn.* TO NULL
     INITIALIZE l_vms.* TO NULL
     INITIALIZE l_ecb.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('van_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('van_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_van_3_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p500_vau()      #需求訂單
DEFINE l_sql      STRING                
DEFINE l_vmu      RECORD LIKE vmu_file.*
DEFINE l_cnt      LIKE type_file.num10   

  IF tm.vlb33  = 'N' THEN RETURN END IF

  DECLARE p500_vmu_c CURSOR FOR 
   SELECT * FROM vmu_file     
    WHERE vmu01 = tm.vlb01
      AND vmu02 = tm.vlb02

  INITIALIZE g_vau.* TO NULL
  INITIALIZE l_vmu.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vmu_c INTO l_vmu.*   
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vmu_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vau.vau01 = l_vmu.vmu01
     LET g_vau.vau02 = l_vmu.vmu02
     LET g_vau.vau03 = l_vmu.vmu03
     LET g_vau.vau04 = l_vmu.vmu04
     LET g_vau.vau05 = l_vmu.vmu05
     LET g_vau.vau06 = l_vmu.vmu06
     LET g_vau.vau07 = l_vmu.vmu07
     LET g_vau.vau08 = l_vmu.vmu08
     LET g_vau.vau09 = l_vmu.vmu09
     LET g_vau.vau10 = l_vmu.vmu10
     LET g_vau.vau11 = l_vmu.vmu11
     LET g_vau.vau12 = l_vmu.vmu12
     LET g_vau.vau13 = l_vmu.vmu13
     LET g_vau.vau14 = l_vmu.vmu14
     LET g_vau.vau15 = l_vmu.vmu15
     LET g_vau.vau16 = l_vmu.vmu16
     LET g_vau.vau17 = l_vmu.vmu17
     LET g_vau.vau18 = l_vmu.vmu18
     LET g_vau.vau19 = l_vmu.vmu19
     LET g_vau.vau20 = l_vmu.vmu20
     LET g_vau.vau21 = l_vmu.vmu21
     LET g_vau.vau22 = l_vmu.vmu22
     LET g_vau.vau23 = l_vmu.vmu23
     LET g_vau.vau24 = l_vmu.vmu24
     LET g_vau.vaulegal = g_legal #FUN-B50022 add
     LET g_vau.vauplant = g_plant #FUN-B50022 add
     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vau FROM g_vau.*
     IF STATUS THEN
        #LET g_msg = 'Key:',g_vau.vau01 CLIPPED,' + ',g_vau.vau02 CLIPPED  #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vau01',g_vau.vau01,'vau02',g_vau.vau02,'','','','','','','','')   #FUN-940030 ADD
       #CALL err('vau_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vau_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     #==>需求訂單選配
     IF tm.vlb34 = 'Y' THEN
         IF l_vmu.vmu25 MATCHES '[01]' THEN
             SELECT COUNT(*) INTO l_cnt FROM oeo_file
              WHERE oeo01 = l_vmu.vmu11
                AND oeo03 = l_vmu.vmu26
             IF l_cnt >= 1 THEN
                 CALL p500_vav(l_vmu.vmu11,l_vmu.vmu26,l_vmu.vmu23,l_vmu.vmu03) 
             END IF
         END IF
     END IF
     INITIALIZE g_vau.* TO NULL
     INITIALIZE l_vmu.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vau_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vau_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

#FUN-B50022 add----str--
 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows_vav ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows_vav ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vav_file','',g_msg,'0')
  LET   g_crows_vav = g_wrows_vav - g_erows_vav
 #LET   g_msg = g_crows_vav ,' ROWS'                                                         #FUN-B80084 add
  LET   g_msg = g_crows_vav ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vav_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------
#FUN-B50022 add----end--

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vmu_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p500_vbc()      
DEFINE l_sql            STRING                
DEFINE l_vnc            RECORD LIKE vnc_file.* 

  IF tm.vlb42  = 'N' THEN RETURN END IF

  DECLARE p500_vbc_c CURSOR FOR 
   SELECT * FROM vnc_file
    ORDER BY vnc01,vnc02,vnc03

  INITIALIZE g_vbc.* TO NULL
  INITIALIZE l_vnc.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vbc_c INTO l_vnc.*   
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vbc_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vbc.vbc01  = l_vnc.vnc01
     LET g_vbc.vbc02  = l_vnc.vnc02
     IF NOT cl_null(l_vnc.vnc03) THEN
         LET g_vbc.vbc03  = l_vnc.vnc03
     ELSE
         LET g_vbc.vbc03  = 0
        #CONTINUE FOREACH  #FUN-890086 add #TQC-890063 mark
     END IF
     IF NOT cl_null(l_vnc.vnc04) THEN
         LET g_vbc.vbc04  = l_vnc.vnc04
     ELSE
         LET g_vbc.vbc04  = 0
     END IF
     IF NOT cl_null(l_vnc.vnc05) THEN
         LET g_vbc.vbc05  = l_vnc.vnc05
     ELSE
         LET g_vbc.vbc05  = 0
     END IF
     LET g_vbc.vbc031 = l_vnc.vnc031
     LET g_vbc.vbc041 = l_vnc.vnc041
     #TQC-870007----add---str---
     LET g_vbc.vbc06  = l_vnc.vnc06 
     LET g_vbc.vbc07  = l_vnc.vnc07
     IF g_vbc.vbc07 = '2' THEN
         LET g_vbc.vbc07  = '0' 
     END IF
     LET g_vbc.vbc08  = l_vnc.vnc08 
     #TQC-870007----add---end---
     LET g_vbc.vbclegal = g_legal #FUN-B50022 add
     LET g_vbc.vbcplant = g_plant #FUN-B50022 add

     #TQC-890063---mod---str---
     IF g_vbc.vbc03 = 0 AND g_vbc.vbc04 = 0 THEN
         INITIALIZE g_vbc.* TO NULL
         INITIALIZE l_vnc.* TO NULL
     ELSE
         LET g_wrows = g_wrows + 1   #FUN-940030  ADD
         PUT p500_c_ins_vbc FROM g_vbc.*
         IF STATUS THEN
            #FUN-940030 MARK  --STR--
            #LET g_msg = 'Key:',g_vbc.vbc01 CLIPPED, ' + ',
            #                   g_vbc.vbc02 CLIPPED, ' + ',
            #                   g_vbc.vbc03 CLIPPED 
            #FUN-940030  MARK  --END--
            LET g_status = STATUS                    #TQC-B70094 add
            CALL p500_getmsg('vbc01',g_vbc.vbc01,'vbc02',g_vbc.vbc02,'vbc03',g_vbc.vbc03,'','','','','','')   #FUN-940030 ADD
           #CALL err('vbc_file',g_msg,STATUS,'2')    #TQC-B70094 mark
            CALL err('vbc_file',g_msg,g_status,'2')  #TQC-B70094 add
            LET g_erows = g_erows + 1   #FUN-940030  ADD
         END IF
         INITIALIZE g_vbc.* TO NULL
         INITIALIZE l_vnc.* TO NULL
     END IF
     #TQC-890063---mod---end---
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vbc_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vbc_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vbc_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p500_vbd()      
DEFINE l_sql            STRING                
DEFINE l_vnd            RECORD LIKE vnd_file.* 
DEFINE l_sfb05          LIKE sfb_file.sfb05        #TQC-860041
DEFINE l_chr5           LIKE type_file.chr5        #TQC-940166 add
DEFINE l_vnd07          DATETIME YEAR TO MINUTE    #TQC-990040 add
DEFINE l_vnd08          DATETIME YEAR TO MINUTE    #TQC-990040 add

  IF tm.vlb43  = 'N' THEN RETURN END IF

 #FUN-8A0011 ---mod----str---
 #DECLARE p500_vbd_c CURSOR FOR 
 # SELECT * FROM vnd_file
 IF NOT cl_null(g_vlz70) THEN 
     CALL s_get_sql_msp04(g_vlz70,'vnd01') RETURNING g_sql_limited 
 ELSE
     LET g_sql_limited = ' 1=1 '
 END IF

 #FUN-960039 MOD --STR------------------------------------------
 #LET l_sql = "SELECT vnd_file.* FROM vnd_file,sfb_file ",
 #            " WHERE ",g_sql_limited CLIPPED,
 #            #工單條件------str---
 #            "   AND sfb01 = vnd01 ",
 #            "   AND sfb08 >  sfb09 ",
 #            "   AND sfb04 <  '8' ",
 #            "   AND sfb13 <= '",tm.vlb08,"'",       #預計開工日小於資料截止日期
 #            "   AND sfb87 != 'X' ",
 #            "   AND sfb01 IS NOT NULL ",
 #            "   AND sfb01 != ' ' "
 #            #工單條件------end---
 #TQC-990040--mod---str---
  LET l_sql = "SELECT vnd01,vnd02,vnd03,vnd04,vnd05, ",
              "       vnd06,vnd07,vnd08,vnd09,vnd10, ",
              "       vnd11,vnd07,vnd08,vnd012 ", #FUN-B50101 add vnd012
 #TQC-990040--mod---end---
              "  FROM vnd_file,sfb_file,ecm_file ",
              " WHERE ",g_sql_limited CLIPPED,
              "   AND sfb01 = vnd01 ",
             #"   AND sfb08 > sfb09 ",              #FUN-CB0131 mark
              "   AND sfb08 > sfb09 + sfb12 ",      #FUN-CB0131 add
              "   AND sfb04 <  '8' ",
              "   AND sfb13 <= '",tm.vlb08,"'",       
              "   AND sfb87 != 'X' ",
              "   AND sfb01 IS NOT NULL ",
              "   AND sfb01 != ' ' ",
              "   AND vnd01 = ecm01 ",
              "   AND vnd02 = ecm01 ",
              "   AND vnd03 = ecm03 ",
              "   AND vnd04 = ecm04 ",
              "   AND vnd012= ecm012 ", #FUN-B50101 add
              "   AND ecm52 = 'N' " 
 #FUN-960039 MOD --STR--------------------------------------------------


  PREPARE p500_vbd_p FROM l_sql
  IF STATUS THEN CALL cl_err('pre p500_vbd_p',STATUS,1) END IF
  DECLARE p500_vbd_c CURSOR FOR p500_vbd_p
  IF STATUS THEN CALL cl_err('dec p500_vbd_c',STATUS,1) END IF
  #FUN-8A0011 ---mod----end---

  INITIALIZE g_vbd.* TO NULL
  INITIALIZE l_vnd.* TO NULL
  #TQC-990040 mod-----str---
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vbd_c INTO l_vnd.vnd01,l_vnd.vnd02,l_vnd.vnd03,l_vnd.vnd04,l_vnd.vnd05,
                          l_vnd.vnd06,l_vnd.vnd07,l_vnd.vnd08,l_vnd.vnd09,l_vnd.vnd10,
                          l_vnd.vnd11,l_vnd07    ,l_vnd08    ,l_vnd.vnd012 #FUN-B50101 add vnd012
  #TQC-990040 mod-----end---
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vbd_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vbd.vbd01 = l_vnd.vnd01
     #TQC-860041---mod---str--
     SELECT sfb05 INTO l_sfb05
       FROM sfb_file
      WHERe sfb01 = l_vnd.vnd01
     LET g_vbd.vbd02 = l_sfb05 CLIPPED,'-',l_vnd.vnd02 #料號,'-',途程編號
     #TQC-860041---mod---end--
     LET l_chr5  = l_vnd.vnd03 USING '&&&&&' #TQC-940166 ADD
    #LET g_vbd.vbd03 = l_vnd.vnd03           #TQC-940166 MARK
     LET g_vbd.vbd03 = l_chr5                #TQC-940166 ADD
     LET g_vbd.vbd04 = l_vnd.vnd04
     LET g_vbd.vbd05 = l_vnd.vnd05
     IF NOT cl_null(l_vnd.vnd06) THEN #TQC-870007
         LET g_vbd.vbd06 = l_vnd.vnd06
     ELSE
         LET g_vbd.vbd06 = 0
     END IF
     LET g_vbd.vbd07 = l_vnd.vnd07
     LET g_vbd.vbd08 = l_vnd.vnd08
     LET g_vbd.vbd09 = 0
     LET g_vbd.vbd10 = 0
     LET g_vbd.vbdlegal = g_legal #FUN-B50022 add
     LET g_vbd.vbdplant = g_plant #FUN-B50022 add
     LET g_vbd.vbd19    = l_vnd.vnd012 #製程段號 #FUN-B50101 add
 
     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
    #TQC-990040 mod-----str---
    #PUT p500_c_ins_vbd FROM g_vbd.*
     PUT p500_c_ins_vbd FROM g_vbd.vbd01,g_vbd.vbd02,g_vbd.vbd03,g_vbd.vbd04,g_vbd.vbd05,
                             g_vbd.vbd06,l_vnd07    ,l_vnd08    ,g_vbd.vbd09,g_vbd.vbd10,
                             #FUN-B50101 ---mod---str---
                             g_vbd.vbdplant,g_vbd.vbdlegal,
                             '','','','','','','','',g_vbd.vbd19
                             #FUN-B50101 ---mod---end---
    #TQC-990040 mod-----end---
     IF STATUS THEN
        #FUN-940030  MARK  --STR--
        #LET g_msg = 'Key:',g_vbd.vbd01 CLIPPED ,' + ',
        #                   g_vbd.vbd02 CLIPPED ,' + ',
        #                   g_vbd.vbd03 CLIPPED ,' + ',
        #                   g_vbd.vbd04 CLIPPED ,' + ',
        #                   g_vbd.vbd05 CLIPPED 
        #FUN-940030  MARK  --END--
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vbd01',g_vbd.vbd01,'vbd02',g_vbd.vbd02,'vbd03',g_vbd.vbd03,'vbd04',g_vbd.vbd04,'','','','')   #FUN-940030 ADD 
       #CALL err('vbd_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vbd_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vbd.* TO NULL
     INITIALIZE l_vnd.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vbd_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vbd_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vbd_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p500_vbe()      
DEFINE l_sql            STRING                
DEFINE l_vne            RECORD LIKE vne_file.* 
DEFINE l_sfb05          LIKE sfb_file.sfb05 #TQC-860041
DEFINE l_chr5           LIKE type_file.chr5 #TQC-940166 add

  IF tm.vlb44  = 'N' THEN RETURN END IF

 #FUN-8A0011 ---mod----str---
 #DECLARE p500_vbe_c CURSOR FOR 
 # SELECT * FROM vne_file
 IF NOT cl_null(g_vlz70) THEN 
     CALL s_get_sql_msp04(g_vlz70,'vne01') RETURNING g_sql_limited 
 ELSE
     LET g_sql_limited = ' 1=1 '
 END IF

  LET l_sql = "SELECT vne_file.* FROM vne_file,sfb_file ",
              " WHERE ",g_sql_limited CLIPPED,
              #工單條件------str---
              "   AND sfb01 = vne01 ",
             #"   AND sfb08 > sfb09 ",              #FUN-CB0131 mark
              "   AND sfb08 > sfb09 + sfb12 ",      #FUN-CB0131 add
              "   AND sfb04 <  '8' ",
              "   AND sfb13 <= '",tm.vlb08,"'",       #預計開工日小於資料截止日期
              "   AND sfb87 != 'X' ",
              "   AND sfb01 IS NOT NULL ",
              "   AND sfb01 != ' ' "
              #工單條件------end---

  PREPARE p500_vbe_p FROM l_sql
  IF STATUS THEN CALL cl_err('pre p500_vbe_p',STATUS,1) END IF
  DECLARE p500_vbe_c CURSOR FOR p500_vbe_p
  IF STATUS THEN CALL cl_err('dec p500_vbe_c',STATUS,1) END IF
  #FUN-8A0011 ---mod----end---

  INITIALIZE g_vbe.* TO NULL
  INITIALIZE l_vne.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vbe_c INTO l_vne.*   
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vbe_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vbe.vbe01 = l_vne.vne01
     #TQC-860041--mod----str--
     SELECT sfb05 INTO l_sfb05
       FROM sfb_file
      WHERE sfb01 = l_vne.vne01
     LET g_vbe.vbe02 = l_sfb05 CLIPPED,'-',l_vne.vne02 CLIPPED 
     #TQC-860041--mod----end--
     LET l_chr5  = l_vne.vne03 USING '&&&&&' #TQC-940166 ADD
    #LET g_vbe.vbe03 = l_vne.vne03           #TQC-940166 MARK
     LET g_vbe.vbe03 = l_chr5                #TQC-940166 ADD
     LET g_vbe.vbe04 = l_vne.vne04
     LET g_vbe.vbe05 = l_vne.vne05
     IF NOT cl_null(l_vne.vne06) THEN #TQC-870007
         LET g_vbe.vbe06 = l_vne.vne06
     ELSE
         LET g_vbe.vbe06 = 0
     END IF
     LET g_vbe.vbe07 = 0
     LET g_vbe.vbelegal = g_legal #FUN-B50022 add
     LET g_vbe.vbeplant = g_plant #FUN-B50022 add
     LET g_vbe.vbe16 = l_vne.vne012 #FUN-B50101 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vbe FROM g_vbe.*
     IF STATUS THEN
        #FUN-940030  MARK   --STR--
        #LET g_msg = 'Key:',g_vbe.vbe01 CLIPPED ,' + ',
        #                   g_vbe.vbe02 CLIPPED ,' + ',
        #                   g_vbe.vbe03 CLIPPED ,' + ',
        #                   g_vbe.vbe04 CLIPPED ,' + ',
        #                   g_vbe.vbe05 CLIPPED 
        #FUN-940030  MARK   --END--
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vbe01',g_vbe.vbe01,'vbe02',g_vbe.vbe02,'vbe03',g_vbe.vbe03,'vbe04',g_vbe.vbe04,'vbe05',g_vbe.vbe05,'','')   #FUN-940030 ADD
       #CALL err('vbe_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vbe_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vbe.* TO NULL
     INITIALIZE l_vne.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vbe_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vbe_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

 IF SQLCA.sqlcode THEN CALL cl_err('p500_vbe_c:',STATUS,1) RETURN END IF
END FUNCTION

#外包商資料
#抓所有外包商
FUNCTION p500_vbh() 
DEFINE l_sql            STRING                
DEFINE l_pmc            RECORD LIKE pmc_file.* 
DEFINE l_cnt            LIKE type_file.num5   #TQC-860041 add

  IF tm.vlb14  = 'N' THEN RETURN END IF

  DECLARE p500_vbh_c CURSOR FOR 
   SELECT * FROM pmc_file
    WHERE pmcacti = 'Y' 
      AND pmc14 = '1'   #FUN-B80124

  INITIALIZE g_vbh.* TO NULL
  INITIALIZE l_pmc.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vbh_c INTO l_pmc.*   
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vbh_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vbh.vbh01 = l_pmc.pmc01
     IF cl_null(l_pmc.pmc03) THEN 
         LET l_pmc.pmc03 = l_pmc.pmc01 
     END IF
     LET g_vbh.vbh02 = l_pmc.pmc03
     LET g_vbh.vbh03 = l_pmc.pmc03
     LET g_vbh.vbhlegal = g_legal #FUN-B50022 add
     LET g_vbh.vbhplant = g_plant #FUN-B50022 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vbh FROM g_vbh.*
     IF STATUS THEN
        #LET g_msg = 'Key:',g_vbh.vbh01 CLIPPED   #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vbh01',g_vbh.vbh01,'','','','','','','','','','')   #FUN-940030 ADD
       #CALL err('vbh_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vbh_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vbh.* TO NULL
     INITIALIZE l_pmc.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vbh_c:',STATUS,1) RETURN END IF

  #TQC-860041---add---str--
  #多拋虛擬外包商資料
  SELECT COUNT(*) INTO l_cnt
    FROM pmc_file
   WHERE pmc01 = g_vlz.vlz72
  IF l_cnt <=0 THEN
      LET g_vbh.vbh01 = g_vlz.vlz72
      LET g_vbh.vbh02 = g_vlz.vlz72
      LET g_vbh.vbh03 = g_vlz.vlz72
      LET g_vbh.vbhlegal = g_legal #FUN-B50022 add
      LET g_vbh.vbhplant = g_plant #FUN-B50022 add
      LET g_wrows = g_wrows + 1   #FUN-940030  ADD
      PUT p500_c_ins_vbh FROM g_vbh.*
      IF STATUS THEN
         #LET g_msg = 'Key:',g_vbh.vbh01 CLIPPED  #FUN-940030 MARK
         LET g_status = STATUS                    #TQC-B70094 add
         CALL p500_getmsg('vbh01',g_vbh.vbh01,'','','','','','','','','','')   #FUN-940030 ADD
        #CALL err('vbh_file',g_msg,STATUS,'2')    #TQC-B70094 mark
         CALL err('vbh_file',g_msg,g_status,'2')  #TQC-B70094 add
         LET g_erows = g_erows + 1   #FUN-940030  ADD
      END IF
  END IF

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vbh_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vbh_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  #TQC-860041---add---end--
END FUNCTION

FUNCTION p500_upd_config()
  DEFINE l_cnt            LIKE type_file.num10   
  DEFINE l_date_tmp1      DATETIME YEAR TO MINUTE #TQC-8A0053 add
  DEFINE l_to_char_vlz03  LIKE type_file.chr20    #TQC-8A0053 add
  DEFINE l_tmp            LIKE type_file.chr20    #TQC-8A0053 add

     #MOD-870103 mark---str--
     #SELECT COUNT(*) INTO l_cnt
     #  FROM vla_file
     # WHERE vla01 = tm.vlb01 
     #IF l_cnt >= 1 THEN
     #    UPDATE vla_file 
     #       SET vla02 = tm.vlb04
     #       WHERE vla01 = tm.vlb01 
     #    IF SQLCA.sqlcode THEN
     #        CALL cl_err3("upd","vla_file",tm.vlb01,"",SQLCA.sqlcode,"","upd vla_file",1) 
     #    END IF
     #ELSE
     #    INSERT INTO vla_file VALUES(tm.vlb01,tm.vlb04)
     #    IF SQLCA.sqlcode THEN
     #        CALL cl_err3("ins","vla_file",tm.vlb01,"",SQLCA.sqlcode,"","ins vla_file",1) 
     #    END IF
     #END IF
     #MOD-870103 mark---end--
     #IF tm.vlb21 = 'Y' OR tm.vlb27 = 'Y' THEN #FUN-870071 mark
     #TQC-8A0053--mod---str---
     LET l_tmp = NULL
     LET l_to_char_vlz03 = g_vlz03_dd USING 'YYYY-MM-DD'
     LET l_tmp = l_to_char_vlz03 CLIPPED,' ',g_vlz03_tt CLIPPED
     LET l_date_tmp1 = l_tmp CLIPPED 
          UPDATE vlz_file 
            #SET vlz03 = tm.vlb04
             SET vlz03 = l_date_tmp1
     #TQC-8A0053--mod---end---
           WHERE vlz01 = tm.vlb01 
             AND vlz02 = tm.vlb02
          IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","vlz_file",tm.vlb01,tm.vlb02,SQLCA.sqlcode,"","upd vlz_file",1)  
          END IF
     #END IF
END FUNCTION

#投料點
#(1)以產品途程檔(ecu_file=>aeci100)為主,串BOM表,條件ecu01 = bmb01,
#   先抓出ecu01/ecu02/bmb03/bmb09資料
#(2)FOREACH內再跟據抓到的ecu01/ecu02/bmb09反串回途程檔(ecb_file)抓出製程序號(ecb03)
FUNCTION p500_vap()      
DEFINE l_sql            STRING                
DEFINE l_ecu01          LIKE ecu_file.ecu01
DEFINE l_ecu02          LIKE ecu_file.ecu02
DEFINE l_bmb03          LIKE bmb_file.bmb03
DEFINE l_bmb09          LIKE bmb_file.bmb09
DEFINE l_vap04          LIKE vap_file.vap04
DEFINE l_vap05          LIKE vap_file.vap05
DEFINE l_bmb02          LIKE bmb_file.bmb02
DEFINE l_chr5           LIKE type_file.chr5 #TQC-860041 add

  IF tm.vlb28  = 'N' THEN RETURN END IF

  DECLARE p500_vap_c CURSOR FOR 
   SELECT ecu01,ecu02,bmb03,bmb09,bmb02
     FROM ecu_file,bmb_file,bma_file
    WHERE (bmb04 <= g_today OR bmb04 IS NULL) #生效日期
      AND (bmb05 >  g_today OR bmb05 IS NULL) #失效日期
      AND ecu01 = bmb01 
      AND bmb01 = bma01
      AND bmb29 = bma06
      AND bmb29 = ' '    #無特性BOM功能
      AND bmaacti = 'Y'
    ORDER BY ecu01,ecu02,bmb02 #ORDER BY bmb02原因:若單身料號有相同時,PUT vap時,只會塞優先抓到的那一筆

  INITIALIZE g_vap.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vap_c INTO l_ecu01,l_ecu02,l_bmb03,l_bmb09,l_bmb02
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vap_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vap.vap01 = l_ecu01 #主件品號
     LET g_vap.vap02 = l_bmb03 #元件品號
     LET g_vap.vap03 = l_ecu01 CLIPPED,'-',l_ecu02 CLIPPED #TQC-860041
     #vap04                    #加工序號
     LET l_vap04 = NULL
     LET l_vap05 = NULL
     IF NOT cl_null(l_bmb09) THEN
          SELECT ecb03,ecb06      #製程序號ecb03,作業編號ecb06
            INTO l_vap04,l_vap05
            FROM ecb_file
           WHERE ecb01 = l_ecu01  #料件編號
             AND ecb02 = l_ecu02  #途程編號
             AND ecb06 = l_bmb09  #作業編號
             AND ecb03 IN(
                          SELECT MIN(ecb03)
                            FROM ecb_file
                           WHERE ecb01 = l_ecu01  #料件編號
                             AND ecb02 = l_ecu02  #途程編號
                             AND ecb06 = l_bmb09  #作業編號
                          )
     END IF
     #TQC-860041---mod----str---
     IF cl_null(l_vap04) THEN
         LET l_vap04 = 1
     END IF
     LET l_chr5 = l_vap04 USING '&&&&&'
     LET g_vap.vap04 = l_chr5
     #TQC-860041---mod----end---
     IF cl_null(l_vap05) THEN
         LET g_vap.vap05 = ' '
     ELSE
         LET g_vap.vap05 = l_vap05 #作業編號
     END IF
     #mandy?? why vap04的資料型態varchar2(60) <> ecb03的資料型態number(5)
     LET g_vap.vaplegal = g_legal #FUN-B50022 add
     LET g_vap.vapplant = g_plant #FUN-B50022 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vap FROM g_vap.*
     IF STATUS THEN
        LET g_status = STATUS                    #TQC-B70094 add
        IF NOT cl_sql_dup_value(SQLCA.SQLCODE) THEN #不是重複的err,就塞入錯誤訊息檔
           #FUN-940030 MARK  --STR--
           #LET g_msg = 'Key:',g_vap.vap01 CLIPPED, ' + ',
           #                   g_vap.vap02 CLIPPED, ' + ',
           #                   g_vap.vap03 CLIPPED 
           #FUN-940030  MARK  --END--
           CALL p500_getmsg('vap01',g_vap.vap01,'vap02',g_vap.vap02,'vap03',g_vap.vap03,'','','','','','')   #FUN-940030 ADD
          #CALL err('vap_file',g_msg,STATUS,'2')    #TQC-B70094 mark
           CALL err('vap_file',g_msg,g_status,'2')  #TQC-B70094 add
           LET g_erows = g_erows + 1   #FUN-940030  ADD 
        END IF
     END IF
     INITIALIZE g_vap.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vap_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vap_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vap_c:',STATUS,1) RETURN END IF
END FUNCTION


FUNCTION p500_vay()  #現場報工
DEFINE l_sql            STRING                
DEFINE l_ecm            RECORD LIKE ecm_file.* 
DEFINE l_van            RECORD LIKE van_file.* 
DEFINE l_pmm09          LIKE pmm_file.pmm09
DEFINE l_chr5           LIKE type_file.chr5 #TQC-860041 add
DEFINE l_sfb08          LIKE sfb_file.sfb08 #TQC-8B0039 add
DEFINE l_tmp            LIKE vay_file.vay06  #FUN-B80002 add
DEFINE l_wipqty         LIKE ecm_file.ecm315 #FUN-B80002 add
DEFINE l_ecm01_t        LIKE ecm_file.ecm01  #FUN-B80002 add

  IF tm.vlb37  = 'N' THEN RETURN END IF

 #FUN-8A0011 ---mod----str---
 #DECLARE p500_vay_c CURSOR FOR 
 # SELECT ecm_file.* FROM ecm_file,vaw_file
 #  WHERE ecm01 = vaw01
 #  ORDER BY ecm01,ecm03,ecm04
 IF NOT cl_null(g_vlz70) THEN 
     CALL s_get_sql_msp04(g_vlz70,'ecm01') RETURNING g_sql_limited 
 ELSE
     LET g_sql_limited = ' 1=1 '
 END IF

  LET l_sql = " SELECT ecm_file.*,sfb08 FROM ecm_file,sfb_file ", #TQC-8B0037 add sfb08
              "  WHERE ecm01 = sfb01 ",
              "   AND ",g_sql_limited CLIPPED,
              #工單條件----str---
             #"   AND sfb08 > sfb09 ",              #FUN-CB0131 mark
              "   AND sfb08 > sfb09 + sfb12 ",      #FUN-CB0131 add
              "   AND sfb04 <  '8' ",
              "   AND sfb13 <= '",tm.vlb08,"'",       #預計開工日小於資料截止日期
              "   AND sfb87 != 'X' ",
              "   AND sfb01 IS NOT NULL ",
              "   AND sfb01 != ' ' ",
              #工單條件----end---
              "  ORDER BY ecm01,ecm03,ecm04 "

  PREPARE p500_vay_p FROM l_sql
  IF STATUS THEN CALL cl_err('pre p500_vay_p',STATUS,1) END IF
  DECLARE p500_vay_c CURSOR FOR p500_vay_p
  IF STATUS THEN CALL cl_err('dec p500_vay_c',STATUS,1) END IF
  #FUN-8A0011 ---mod----end---

  LET l_ecm01_t = NULL #FUN-B80002 add
  INITIALIZE g_vay.* TO NULL
  INITIALIZE l_ecm.* TO NULL
  INITIALIZE l_van.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vay_c INTO l_ecm.*,l_sfb08  #TQC-8B0037 add sfb08
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vay_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vay.vay01 = l_ecm.ecm01
     LET l_chr5      = l_ecm.ecm03 USING '&&&&&'  #TQC-860041
     LET g_vay.vay02 = l_chr5                     #TQC-860041
     LET g_vay.vay03 = l_ecm.ecm04
     #TQC-860041---mod---str--
     LET l_van.van02 = l_ecm.ecm03_par CLIPPED,'-',l_ecm.ecm01 CLIPPED
     SELECT * INTO l_van.* 
       FROM van_file
      WHERE van01 = l_ecm.ecm03_par
        AND van02 = l_van.van02
        AND van03 = l_chr5
        AND van04 = l_ecm.ecm04 
     #TQC-860041---mod---end--
     LET g_vay.vay04 = l_van.van07
     LET g_vay.vay05 = l_van.van08
     #TQC-860041---mod---str---
     #vay06
     IF cl_null(l_ecm.ecm59)  THEN LET l_ecm.ecm59  = 0 END IF
     IF cl_null(l_ecm.ecm291) THEN LET l_ecm.ecm291 = 0 END IF
     IF cl_null(l_ecm.ecm311) THEN LET l_ecm.ecm311 = 0 END IF
     IF cl_null(l_ecm.ecm312) THEN LET l_ecm.ecm312 = 0 END IF
     IF cl_null(l_ecm.ecm313) THEN LET l_ecm.ecm313 = 0 END IF
     IF cl_null(l_ecm.ecm314) THEN LET l_ecm.ecm314 = 0 END IF
     IF cl_null(l_ecm.ecm315) THEN LET l_ecm.ecm315 = 0 END IF #TQC-8B0037 add
     IF cl_null(l_ecm.ecm316) THEN LET l_ecm.ecm316 = 0 END IF
     IF cl_null(l_sfb08) THEN LET l_sfb08 = 0 END IF           #TQC-8B0037 add
    #TQC-8B0037---mod---str---
    #LET g_vay.vay06 =   l_ecm.ecm291               #check in
    #                  - l_ecm.ecm311 * l_ecm.ecm59 #良品轉出
    #                  - l_ecm.ecm312 * l_ecm.ecm59 #重工轉出
    #                  - l_ecm.ecm313 * l_ecm.ecm59 #當站報廢
    #                  - l_ecm.ecm314 * l_ecm.ecm59 #當站下線
    #                  - l_ecm.ecm316 * l_ecm.ecm59 #工單轉出量   
    #FUN-B80002---mark--str---
    #LET g_vay.vay06 =   l_sfb08                    #生產數量
    #                  - l_ecm.ecm311 * l_ecm.ecm59 #良品轉出
    #                  - l_ecm.ecm312 * l_ecm.ecm59 #重工轉出
    #                  - l_ecm.ecm313 * l_ecm.ecm59 #當站報廢
    #                  - l_ecm.ecm314 * l_ecm.ecm59 #當站下線
    #                  - l_ecm.ecm315 * l_ecm.ecm59 #Bonus Qty
    #                  - l_ecm.ecm316 * l_ecm.ecm59 #工單轉出量   
    #IF g_vay.vay06 < 0 THEN
    #    LET g_vay.vay06 = 0
    #END IF
    #FUN-B80002---mark--end---
    #TQC-8B0037---mod---end---
    #FUN-B80002---add---str---
    #未完成量(vay06)調整:
    #第一站給:待投入量  
    #    公式:IF(預計產量-(良品轉入+重工轉入+工單轉入)>0,預計產量-(良品轉入+重工轉入+工單轉入),0)+WIP量
    #後續站給:WIP量
    #APS 則會再計算當站的未完成量,算法:累加該製程之前所有製程的WIP數量

    #WIP量的算法同aecq700
     LET l_wipqty =    l_ecm.ecm301                  #良品轉入量
                     + l_ecm.ecm302                  #重工轉入量
                     + l_ecm.ecm303                  #工單轉入量
                     - l_ecm.ecm311*l_ecm.ecm59      #良品轉出
                     - l_ecm.ecm312*l_ecm.ecm59      #重工轉出
                     - l_ecm.ecm313*l_ecm.ecm59      #當站報廢
                     - l_ecm.ecm314*l_ecm.ecm59      #當站下線
                     - l_ecm.ecm316*l_ecm.ecm59      #工單轉出量

     IF cl_null(l_wipqty) THEN LET l_wipqty=0 END IF
     IF cl_null(l_ecm01_t) OR (l_ecm01_t <> l_ecm.ecm01) THEN
         #第一站
         LET l_tmp = l_sfb08 - ( l_ecm.ecm301 + l_ecm.ecm302 + l_ecm.ecm303)
         IF l_tmp < 0 THEN
             LET l_tmp = 0
         END IF 
         LET g_vay.vay06 = l_tmp + l_wipqty
     ELSE
         #後續站
         LET g_vay.vay06 = l_wipqty
     END IF
    #FUN-B80002---add---end---
     #TQC-860041---mod---end---
     LET g_vay.vay07 = l_ecm.ecm50
     LET g_vay.vay08 = l_ecm.ecm51
     LET g_vay.vay09 = NULL        #實際開工日
     LET g_vay.vay10 = l_van.van09
     LET g_vay.vay11 = l_van.van10 
     LET g_vay.vay12 = l_van.van11
     LET g_vay.vay13 = l_van.van12
     LET g_vay.vay14 = l_van.van13
     IF NOT cl_null(l_ecm.ecm52) AND (l_ecm.ecm52 MATCHES '[Yy]') THEN
        LET g_vay.vay15 = 1
     ELSE
        LET g_vay.vay15 = 0
     END IF
     LET g_vay.vay16 = l_van.van16 #TQC-860041 mod
     #TQC-880053 MARK vay17
     #LET l_pmm09 = NULL
     #SELECT MAX(pmm09)
     #  INTO l_pmm09
     #  FROM pmm_file,pmn_file
     # WHERE pmn01 = pmm01
     #   AND pmn41 = l_ecm.l_ecm01
     #   AND pmn43 = l_ecm.l_ecm03
     #LET g_vay.vay17 = l_pmm09
      LET g_vay.vay17 = ' '
     LET g_vay.vaylegal = g_legal #FUN-B50022 add
     LET g_vay.vayplant = g_plant #FUN-B50022 add
     LET g_vay.vay26 = l_ecm.ecm012 #FUN-B50101 add
     #FUN-B90040 add str---
      LET g_vay.vay27 = l_ecm.ecm06
      SELECT eca02 INTO g_vay.vay28
        FROM eca_file
       WHERE eca01 = l_ecm.ecm06
     #FUN-B90040 add end---

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vay FROM g_vay.*
     IF STATUS THEN
        #FUN-940030  MARK   --STR--
        #LET g_msg = 'Key:',g_vay.vay01 CLIPPED, ' + ',
        #                   g_vay.vay02 CLIPPED, ' + ',
        #                   g_vay.vay03 CLIPPED 
        #FUN-940030  MARK  --END--
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vay01',g_vay.vay01,'vay02',g_vay.vay02,'vay03',g_vay.vay03,'','','','','','')   #FUN-940030 ADD
       #CALL err('vay_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vay_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     LET l_ecm01_t = l_ecm.ecm01 #FUN-B80002 add
     INITIALIZE g_vay.* TO NULL
     INITIALIZE l_ecm.* TO NULL
     INITIALIZE l_van.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vay_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vay_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vay_c:',STATUS,1) RETURN END IF
END FUNCTION


FUNCTION p500_vbf()  #製令外包
DEFINE l_sql            STRING                
DEFINE l_vnf            RECORD LIKE vnf_file.* 
DEFINE l_sfb            RECORD LIKE sfb_file.* 
DEFINE l_pmm09          LIKE pmm_file.pmm09
DEFINE l_to_char_sfb13  LIKE type_file.chr10
DEFINE l_to_char_sfb15  LIKE type_file.chr10
DEFINE l_sfb13          LIKE sfb_file.sfb13
DEFINE l_sfb14          LIKE sfb_file.sfb14
DEFINE l_sfb15          LIKE sfb_file.sfb15
DEFINE l_sfb16          LIKE sfb_file.sfb16
DEFINE l_tmp            LIKE type_file.chr20
DEFINE l_date_tmp1      DATETIME YEAR TO MINUTE
DEFINE l_date_tmp2      DATETIME YEAR TO MINUTE
DEFINE l_date           LIKE type_file.dat
DEFINE l_hh_sfb14       LIKE type_file.num5
DEFINE l_mm_sfb14       LIKE type_file.num5
DEFINE l_hh_sfb16       LIKE type_file.num5
DEFINE l_mm_sfb16       LIKE type_file.num5
DEFINE l_hhmm1          LIKE type_file.num20
DEFINE l_hhmm2          LIKE type_file.num20
DEFINE l_vbf04,l_vbf05  DATETIME YEAR TO SECOND     #FUN-960039 ADD
DEFINE l_vbf04s,l_vbf05s  string                       #FUN-960039 ADD
DEFINE l_sfb13s,l_sfb15s  LIKE type_file.chr10      #FUN-960039 ADD
DEFINE l_sfb14s, l_sfb16s LIKE type_file.chr8       #FUN-960039 ADD
DEFINE l_sql1           STRING                      #FUN-B50022 add
DEFINE l_sql2           STRING                      #FUN-B50022 add

  IF tm.vlb45  = 'N' THEN RETURN END IF

 #FUN-8A0011 ---mod----str---
 ##TQC-860041---mod---str--
 #DECLARE p500_vbf_c CURSOR FOR 
 # SELECT sfb_file.*,vnf_file.* FROM sfb_file,OUTER vnf_file
 #  WHERE sfb01 = vnf_file.vnf01
 #    AND sfb02 = '7' #委外工單
 #    AND sfb08 > sfb09
 #    AND sfb04 < '8' 
 #    AND sfb13 <= tm.vlb08
 #    AND sfb23 =  'Y' 
 #    AND sfb87 != 'X'
 #    AND sfb01 IS NOT NULL
 #    AND sfb01 != ' '
 ##TQC-860041---mod---end--
 IF NOT cl_null(g_vlz70) THEN 
     CALL s_get_sql_msp04(g_vlz70,'sfb01') RETURNING g_sql_limited 
 ELSE
     LET g_sql_limited = ' 1=1 '
 END IF
 LET l_sql = "SELECT sfb_file.*,vnf_file.* FROM sfb_file,OUTER vnf_file ",
             " WHERE sfb01 = vnf_file.vnf01 ",
             "   AND sfb02 = '7' ", #委外工單
            #"   AND sfb08 > sfb09 ",              #FUN-CB0131 mark
             "   AND sfb08 > sfb09 + sfb12 ",      #FUN-CB0131 add
             "   AND sfb04 < '8' ",
             "   AND sfb13 <= ' ",tm.vlb08,"'",
             "   AND sfb23 =  'Y' ",
             "   AND sfb87 != 'X' ",
             "   AND sfb01 IS NOT NULL ",
             "   AND sfb01 != ' ' ",
             "   AND ",g_sql_limited CLIPPED

  PREPARE p500_vbf_p FROM l_sql
  IF STATUS THEN CALL cl_err('pre p500_vbf_p',STATUS,1) END IF
  DECLARE p500_vbf_c CURSOR FOR p500_vbf_p
  IF STATUS THEN CALL cl_err('dec p500_vbf_c',STATUS,1) END IF
  #FUN-8A0011 ---mod----end---
  #FUN-B50022 ---add----str---
  LET l_sql1 = cl_tp_tochar('sfb13','YYYY-MM-DD')
  LET l_sql2 = cl_tp_tochar('sfb15','YYYY-MM-DD')
  LET l_sql = "SELECT ",l_sql1 CLIPPED,",  sfb13,  sfb14,",
                        l_sql2 CLIPPED,",  sfb15,  sfb16 ",
              "  FROM sfb_file ",
              " WHERE sfb01 = ? "
  PREPARE p500_vbf_p2 FROM l_sql
  IF STATUS THEN CALL cl_err('pre p500_vbf_p2',STATUS,1) END IF
  DECLARE p500_vbf_c2 CURSOR FOR p500_vbf_p2
  IF STATUS THEN CALL cl_err('dec p500_vbf_c2',STATUS,1) END IF
  #FUN-B50022 ---add----end---

  INITIALIZE g_vbf.* TO NULL
  INITIALIZE l_sfb.* TO NULL                #TQC-860041 add
  INITIALIZE l_vnf.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vbf_c INTO l_sfb.*,l_vnf.*   #TQC-860041 mod
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vbf_c:',STATUS,1) EXIT FOREACH
     END IF
     #vbf01
     LET g_vbf.vbf01 = l_sfb.sfb01 #TQC-860041 mod
     #vbf02
     LET l_pmm09 = NULL
     SELECT MAX(pmm09)
       INTO l_pmm09
       FROM pmm_file,pmn_file
      WHERE pmn01 = pmm01
        AND pmn41 = l_vnf.vnf01
        AND pmm18 <> 'X'                  #TQC-8A0002 add
     #TQC-870007---mod---str---
     IF NOT cl_null(l_pmm09) THEN
         LET g_vbf.vbf02 = l_pmm09     #外包商編號
     ELSE
         LET g_vbf.vbf02 = g_vlz.vlz72 #參數檔中虛擬外包商
     END IF
     #TQC-870007---mod---end---
     #vbf03
     IF NOT cl_null(l_vnf.vnf03) THEN #TQC-870007
         LET g_vbf.vbf03 = l_vnf.vnf03
     #ELSE                     #FUN-960039 MARK   
     #    LET g_vbf.vbf03 = 1  #FUN-960039 MARK
     END IF
    #vbf04/vfb05/vfb06
   #FUN-9A0029---unmark---str----
    #FUN-960039 MOD --STR----------------------------------------
    #FUN-B50022---mod---str---
    #SELECT TO_CHAR(sfb13,'YYYY-MM-DD'),  sfb13,  sfb14,TO_CHAR(sfb15,'YYYY-MM-DD'),  sfb15,  sfb16
    #  INTO l_to_char_sfb13            ,l_sfb13,l_sfb14,l_to_char_sfb15            ,l_sfb15,l_sfb16
    #  FROM sfb_file
    ##WHERE sfb01 = l_vnf.vnf01 #FUN-9A0029 mark
    # WHERE sfb01 = l_sfb.sfb01 #FUN-9A0029 add
     OPEN p500_vbf_c2 USING l_sfb.sfb01
     FETCH p500_vbf_c2 INTO l_to_char_sfb13 ,l_sfb13,l_sfb14,l_to_char_sfb15 ,l_sfb15,l_sfb16
    #FUN-B50022---mod---end---
     IF cl_null(l_sfb14) THEN
         LET l_sfb14 = '00:00'
     END IF
     IF cl_null(l_sfb16) THEN
         LET l_sfb16 = '00:00'
     END IF
     LET l_tmp = NULL
     LET l_tmp = l_to_char_sfb13,' ',l_sfb14  
     LET l_date_tmp1 = l_tmp CLIPPED #vbf04
     LET l_tmp = NULL
     LET l_tmp = l_to_char_sfb15,' ',l_sfb16
     LET l_date_tmp2 = l_tmp CLIPPED #vbf05
   #FUN-9A0029---unmark---end----

   #FUN-9A0029---mark---str----
   # SELECT TO_CHAR(sfb13,'YYYY-MM-DD'),sfb13,
   #        TO_CHAR(sfb14,'hh24:mi:ss'),sfb14,
   #        TO_CHAR(sfb15,'YYYY-MM-DD'),sfb15,
   #        TO_CHAR(sfb16,'hh24:mi:ss'),sfb16
   #   INTO l_sfb13s,l_sfb13,l_sfb14s, l_sfb14,
   #        l_sfb15s,l_sfb15,l_sfb16s, l_sfb16
   #  FROM sfb_file
   # WHERE sfb01 = l_sfb.sfb01

   # IF cl_null(l_sfb14) THEN
   #     LET l_sfb14 = '00:00:00'
   #     LET l_sfb14s = '00:00:00'
   # END IF
   # IF cl_null(l_sfb16) THEN
   #     LET l_sfb16 = '00:00:00'
   #     LET l_sfb16s = '00:00:00'
   # END IF
   # LET l_tmp = NULL

   # LET l_vbf04s = l_sfb13s,' ',l_sfb14s
   # LET l_vbf04 = l_vbf04s 
   # LET l_vbf05s = l_sfb15s,' ',l_sfb16s
   # LET l_vbf05 = l_vbf05s
   # LET g_vbf.vbf04 = l_vbf04
   # LET g_vbf.vbf05 = l_vbf05
   ##FUN-960039 MOD --END---------------------------------------
   #FUN-9A0029---mark---end----

     LET l_date = DATE('1899/12/31') 
    #FUN-960039 ADD --STR-----------------
     IF cl_null(l_sfb.sfb14) THEN
        LET l_sfb.sfb14 = '00:00:00'
     END IF
     IF cl_null(l_sfb.sfb16) THEN
        LET l_sfb.sfb16 = '00:00:00'
     END IF
    #FUN-960039 ADD --END-----------------
     LET l_hh_sfb14 = l_sfb.sfb14[1,2]
     LET l_mm_sfb14 = l_sfb.sfb14[4,5]
     LET l_hh_sfb16 = l_sfb.sfb16[1,2]
     LET l_mm_sfb16 = l_sfb.sfb16[4,5]
     IF NOT cl_null(l_sfb.sfb15) AND NOT cl_null(l_sfb.sfb13) THEN
       #LET l_hhmm1=(l_sfb15    -l_date)*1440+l_hh_sfb16*60+l_mm_sfb16 #FUN-960039 MARK
       #LET l_hhmm2=(l_sfb13    -l_date)*1440+l_hh_sfb14*60+l_mm_sfb14 #FUN-960039 MARK
        LET l_hhmm1=(l_sfb.sfb15-l_date)*1440+l_hh_sfb16*60+l_mm_sfb16 #FUN-960039 ADD
        LET l_hhmm2=(l_sfb.sfb13-l_date)*1440+l_hh_sfb14*60+l_mm_sfb14 #FUN-960039 ADD
        LET g_vbf.vbf06 = (l_hhmm1-l_hhmm2)*60 #公式(sfb15:sfb16 - sfb13:sfb14)*60(秒)
     ELSE
         LET g_vbf.vbf06 = 0
     END IF
     IF NOT cl_null(l_vnf.vnf07) THEN
         LET g_vbf.vbf07 = l_vnf.vnf07
     #ELSE                     #FUN-960039 MARK          
     #   LET g_vbf.vbf07 = 0   #FUN-960039 MARK
     END IF

    #FUN-960039 ADD --STR------------------------------------------
     IF l_sfb.sfb02='7' AND l_sfb.sfb41='Y' AND l_vnf.vnf01 IS NULL THEN
        LET g_vbf.vbf03 = '2'
        LET g_vbf.vbf07 = 0
     END IF
     IF l_sfb.sfb02='7' AND (l_sfb.sfb41='N' OR l_sfb.sfb41 IS NULL) 
        AND l_vnf.vnf01 IS NULL THEN
        LET g_vbf.vbf03 = '1'
        LET g_vbf.vbf07 = 0
     END IF
    #FUN-960039 ADD --END------------------------------------------
     LET g_vbf.vbflegal = g_legal #FUN-B50022 add
     LET g_vbf.vbfplant = g_plant #FUN-B50022 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
    #FUN-960039 MOD --STR-----------------------------------------------
     PUT p500_c_ins_vbf FROM g_vbf.vbf01,g_vbf.vbf02,g_vbf.vbf03,l_date_tmp1,l_date_tmp2,g_vbf.vbf06,g_vbf.vbf07,g_vbf.vbfplant,g_vbf.vbflegal, #FUN-9A0029 unmark #FUN-B50022 add plant,legal
    #PUT p500_c_ins_vbf FROM g_vbf.vbf01,g_vbf.vbf02,g_vbf.vbf03,g_vbf.vbf04,g_vbf.vbf05,g_vbf.vbf06,g_vbf.vbf07, #FUN-9A0029 mark
    #FUN-960039 MOD --END-----------------------------------------------
                             g_vbf.vbf08,g_vbf.vbf09,g_vbf.vbf10,g_vbf.vbf11,g_vbf.vbf12,   #FUN-940030  ADD
                             g_vbf.vbf13,g_vbf.vbf14,g_vbf.vbf15  #FUN-940030  ADD
     IF STATUS THEN
        #LET g_msg = 'Key:',g_vbf.vbf01 CLIPPED  #FUN-940030  MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vbf01',g_vbf.vbf01,'','','','','','','','','','')   #FUN-940030 ADD
       #CALL err('vbf_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vbf_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vbf.* TO NULL
     INITIALIZE l_sfb.* TO NULL #TQC-860041 add
     INITIALIZE l_vnf.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vbf_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vbf_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vbf_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p500_vbg()  #製程外包
DEFINE l_sql            STRING                
DEFINE l_vng            RECORD LIKE vng_file.* 
#FUN-960039 ADD --STR----------------------
 DEFINE l_vnd            RECORD 
        vnd01             LIKE vnd_file.vnd01,
        vnd02             LIKE vnd_file.vnd02,
        vnd03             LIKE vnd_file.vnd03,
        vnd04             LIKE vnd_file.vnd04,
        vnd05             LIKE vnd_file.vnd05,
        vnd06             LIKE vnd_file.vnd06, 
        vnd07             DATETIME YEAR TO SECOND,
        vnd08             DATETIME YEAR TO SECOND,
        vnd09             LIKE vnd_file.vnd09,
        vnd10             LIKE vnd_file.vnd10,
        vnd11             LIKE vnd_file.vnd11
                         END RECORD
DEFINE l_ecm            RECORD LIKE ecm_file.* 
DEFINE l_sfb08          LIKE sfb_file.sfb08
DEFINE l_sfb01          LIKE sfb_file.sfb01
DEFINE l_sfb05          LIKE sfb_file.sfb05 #TQC-860041 add
DEFINE l_pmm09          LIKE pmm_file.pmm09
DEFINE l_to_char_ecm50  LIKE type_file.chr10
DEFINE l_to_char_ecm51  LIKE type_file.chr10
DEFINE l_date_tmp1      DATETIME YEAR TO SECOND
DEFINE l_date_tmp2      DATETIME YEAR TO SECOND
DEFINE l_tmp            LIKE type_file.chr20
DEFINE l_date           LIKE type_file.dat
DEFINE l_hh_ecm25       LIKE type_file.num5
DEFINE l_mm_ecm25       LIKE type_file.num5
DEFINE l_hh_ecm26       LIKE type_file.num5
DEFINE l_mm_ecm26       LIKE type_file.num5
DEFINE l_hhmm1          LIKE type_file.num20
DEFINE l_hhmm2          LIKE type_file.num20
DEFINE l_ecm50          LIKE ecm_file.ecm50
DEFINE l_ecm51          LIKE ecm_file.ecm51
DEFINE l_ecm25          LIKE ecm_file.ecm25
DEFINE l_ecm26          LIKE ecm_file.ecm26
DEFINE l_ecm01          LIKE ecm_file.ecm01     #TQC-860041 add
DEFINE l_ecm03          LIKE ecm_file.ecm03     #TQC-860041 add
DEFINE l_ecm03_par      LIKE ecm_file.ecm03_par #TQC-860041 add
DEFINE l_ecm04          LIKE ecm_file.ecm04     #TQC-860041 add
DEFINE l_chr5           LIKE type_file.chr5     #TQC-860041 add
#FUN-960039 ADD --STR---------------------------------------------
DEFINE l_ecm52          LIKE ecm_file.ecm52     
DEFINE l_eca06          LIKE eca_file.eca06     
DEFINE l_fixwh          LIKE ecm_file.ecm15     #固定工時  
DEFINE l_stdwh          LIKE ecm_file.ecm15     #標準工時
DEFINE l_ecm15          LIKE ecm_file.ecm15     
DEFINE l_ecm16          LIKE ecm_file.ecm16      
DEFINE l_ecm13          LIKE ecm_file.ecm13      
DEFINE l_ecm14          LIKE ecm_file.ecm14      
DEFINE l_ecm311         LIKE ecm_file.ecm311     
DEFINE l_ecm312         LIKE ecm_file.ecm312     
DEFINE l_ecm313         LIKE ecm_file.ecm313     
DEFINE l_ecm314         LIKE ecm_file.ecm314     
DEFINE l_ecm315         LIKE ecm_file.ecm315     
DEFINE l_ecm316         LIKE ecm_file.ecm316     
DEFINE l_vmn09          LIKE vmn_file.vmn09      
DEFINE l_vmn16          LIKE vmn_file.vmn16      
DEFINE l_vmn13          LIKE vmn_file.vmn13      
DEFINE l_unprodqty      LIKE sfb_file.sfb08   #未生產數量
DEFINE l_lotqty         LIKE type_file.num20  #批量數
DEFINE l_wkovtime       LIKE vbg_file.vbg09
DEFINE g_vzz60          LIKE vzz_file.vzz60
DEFINE l_ecm59          LIKE ecm_file.ecm59
DEFINE l_ecm06          LIKE ecm_file.ecm06
DEFINE l_ecm012         LIKE ecm_file.ecm012 #FUN-B50101 add
DEFINE l_vmn18          LIKE vmn_file.vmn18  #FUN-9A0047 add
#FUN-960039 ADD --END-----------------------------------------------
DEFINE l_sql1           STRING                      #FUN-B50022 add
DEFINE l_sql2           STRING                      #FUN-B50022 add
DEFINE l_sql3           STRING                      #FUN-B50022 add

  IF tm.vlb46  = 'N' THEN RETURN END IF


 #FUN-8A0011 ---mod----str---
 ##TQC-860041---mod---str--
 #DECLARE p500_vbg_c CURSOR FOR 
 # SELECT TO_CHAR(ecm50,'YYYY-MM-DD'),ecm50,TO_CHAR(ecm51,'YYYY-MM-DD'),ecm51,ecm25,ecm26,
 #        vng_file.*,sfb08,sfb01,sfb05,ecm01,ecm03,ecm03_par,ecm04 
 #   FROM ecm_file,sfb_file,OUTER vng_file
 #  WHERE ecm01 = sfb01
 #    AND ecm52 = 'Y' #委外否
 #    AND ecm01 = vng_file.vng01
 #    AND ecm03 = vng_file.vng03
 #    AND ecm04 = vng_file.vng04
 #    AND sfb08 >  sfb09          #工單條件
 #    AND sfb04 <  '8'            
 #    AND sfb13 <= tm.vlb08       #預計開工日小於資料截止日期
 #    AND sfb87 != 'X'
 #    AND sfb01 IS NOT NULL 
 #    AND sfb01 != ' '
 ##TQC-860041---mod---end--
 IF NOT cl_null(g_vlz70) THEN 
     CALL s_get_sql_msp04(g_vlz70,'sfb01') RETURNING g_sql_limited 
 ELSE
     LET g_sql_limited = ' 1=1 '
 END IF

  #FUN-960039 MOD --STR--------------------------------------------------
  #LET l_sql = "SELECT TO_CHAR(ecm50,'YYYY-MM-DD'),ecm50,TO_CHAR(ecm51,'YYYY-MM-DD'),ecm51,ecm25,ecm26, ",
  #            "       vng_file.*,sfb08,sfb01,sfb05,ecm01,ecm03,ecm03_par,ecm04 ",
  #            "  FROM ecm_file,sfb_file,OUTER vng_file ",
  #            " WHERE ecm01 = sfb01 ",
  #            "   AND ecm52 = 'Y' ", #委外否
  #            "   AND ecm01 = vng_file.vng01 ",
  #            "   AND ecm03 = vng_file.vng03 ",
  #            "   AND ecm04 = vng_file.vng04 ",
  #            "   AND sfb08 > sfb09 ",#工單條件
  #            "   AND sfb04 <  '8'  ",   
  #            "   AND sfb13 <= '",tm.vlb08,"'",#預計開工日小於資料截止日期
  #            "   AND sfb87 != 'X' ",
  #            "   AND sfb01 IS NOT NULL ",
  #            "   AND sfb01 != ' ' ",
  #            "   AND ",g_sql_limited CLIPPED

   LET l_sql1 = cl_tp_tochar('ecm50','YYYY/MM/DD') #FUN-B50022 add
   LET l_sql2 = cl_tp_tochar('ecm51','YYYY/MM/DD') #FUN-B50022 add
   LET l_sql3 = cl_tp_tochar('sfb13','YYYY/MM/DD') #FUN-B50022 add
  #FUN-B50022--mod---str---
  #LET l_sql = "SELECT to_char(ecm50,'YYYY/MM/DD') l_char_ecm50,ecm50,to_char(ecm51,'YYYY/MM/DD') l_char_ecm52,ecm51,ecm25,ecm26, ",
   LET l_sql = "SELECT ",l_sql1 CLIPPED," l_char_ecm50,ecm50,",
                         l_sql2 CLIPPED," l_char_ecm52,ecm51,ecm25,ecm26, ",
  #FUN-B50022--mod---end---
               "       vnd_file.*,sfb08,sfb01,sfb05,ecm01,ecm03,ecm03_par,ecm04,ecm52, ", 
               "       ecm15,ecm16,ecm13,ecm14,ecm311,ecm312,ecm313,ecm314,ecm315,ecm316,ecm59,ecm06,ecm012 ",  #FUN-B50101 add ecm012
               "  FROM ecm_file,sfb_file,OUTER vnd_file ",
               " WHERE ecm01 = sfb01 ",
               "   AND ecm52 = 'Y' ", #委外否
               "   AND ecm01 = vnd_file.vnd01 ",
               "   AND ecm01 = vnd_file.vnd02 ",             
               "   AND ecm03 = vnd_file.vnd03 ",
               "   AND ecm04 = vnd_file.vnd04 ",
               "   AND ecm012 = vnd_file.vnd012 ", #FUN-B50101 add
              #"   AND sfb08 > sfb09 ",#工單條件           #FUN-CB0131 mark
               "   AND sfb08 > sfb09 + sfb12 ",#工單條件   #FUN-CB0131 add
               "   AND sfb04 <  '8'  ",   
              #FUN-B50022--mod---str---
              #"   AND TO_CHAR(sfb13,'YY/MM/DD') <= '",tm.vlb08,"'",#預計開工日小於資料截止日期
               "   AND ",l_sql3 CLIPPED       ," <= '",tm.vlb08,"'",#預計開工日小於資料截止日期
              #FUN-B50022--mod---end---
               "   AND sfb87 <> 'X' ",
               "   AND sfb01 IS NOT NULL ",
               "   AND sfb01 <> ' ' ",
               "   AND ",g_sql_limited CLIPPED

  #SELECT vzz60 into g_vzz60  from vzz_file
  #IF g_vzz60 = 0 THEN
  #   LET l_sql = l_sql , " AND ecm06 = vnd_file.vnd05 "
  #ELSE
  #   LET l_sql = l_sql , " AND ecm05 = vnd_file.vnd05 "   
  #END IF
  #FUN-960039 MOD --END----------------------------------------

  PREPARE p500_vbg_p FROM l_sql
  IF STATUS THEN CALL cl_err('pre p500_vbg_p',STATUS,1) END IF
  DECLARE p500_vbg_c CURSOR FOR p500_vbg_p
  IF STATUS THEN CALL cl_err('dec p500_vbg_c',STATUS,1) END IF
  #FUN-8A0011 ---mod----end---

  INITIALIZE g_vbg.* TO NULL
 #INITIALIZE l_vng.* TO NULL  #FUN-960039 MARK
  INITIALIZE l_vnd.* TO NULL  #FUN-960039 ADD
  INITIALIZE l_ecm.* TO NULL
  LET l_sfb08 = NULL
 #FUN-960039 MOD --STR---------------------------------------------------
 #FOREACH p500_vbg_c INTO l_to_char_ecm50,l_ecm50,l_to_char_ecm51,l_ecm51,l_ecm25,l_ecm26,
 #                        l_vng.*,l_sfb08,l_sfb01,l_sfb05,l_ecm01,l_ecm03,l_ecm03_par,l_ecm04
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vbg_c INTO l_to_char_ecm50,l_ecm50,l_to_char_ecm51,l_ecm51,l_ecm25,l_ecm26,
                          l_vnd.*,l_sfb08,l_sfb01,l_sfb05,l_ecm01,l_ecm03,l_ecm03_par,l_ecm04,l_ecm52,
                          l_ecm15,l_ecm16,l_ecm13,l_ecm14,l_ecm311,l_ecm312,l_ecm313,l_ecm314,l_ecm315,l_ecm316,l_ecm59,l_ecm06,l_ecm012 #FUN-B50101 add ecm012
 #FUN-960039 MOD --END---------------------------------------------------

     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vbg_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vbg.vbg01 = l_ecm01 #TQC-860041
     LET g_vbg.vbg02 = l_ecm03_par CLIPPED,'-',l_ecm01 CLIPPED #TQC-860041
     LET l_chr5      = l_ecm03 USING '&&&&&'               #TQC-860041
     LET g_vbg.vbg03 = l_chr5                              #TQC-860041
     LET g_vbg.vbg04 = l_ecm04                             #TQC-860041
     #TQC-860041---mod---str---
     #vbg05
     #vbg_file的外包商編號(vbg05)拋轉邏輯,先抓pmm09 --> vmn18 --> vlz72 #FUN-9A0047 add
     LET l_pmm09 = NULL
     SELECT MAX(pmm09)
       INTO l_pmm09
       FROM pmm_file,pmn_file
      WHERE pmn01 = pmm01
        AND pmn41 = l_sfb01
        AND pmn43 = l_ecm03               #TQC-8A0002 add
        AND pmm18 <> 'X'                  #TQC-8A0002 add
       
     IF NOT cl_null(l_pmm09) THEN 
         LET g_vbg.vbg05 = l_pmm09     #外包商編號
     ELSE
         #FUN-9A0047---add----str----
         SELECT vmn18 INTO l_vmn18
           FROM vmn_file
          WHERE vmn01 = l_ecm03_par       #料號
            AND vmn02 = l_ecm01           #途程編號
            AND vmn03 = l_ecm03           #加工序號
            AND vmn04 = l_ecm04           #作業編號
            AND vmn012 = l_ecm012         #製程段號 #FUN-B50101 add
         IF NOT cl_null(l_vmn18) THEN
             LET g_vbg.vbg05 = l_vmn18
         ELSE
             LET g_vbg.vbg05 = g_vlz.vlz72 #參數檔中虛擬外包商
         END IF
         #FUN-9A0047---add----str----
        #LET g_vbg.vbg05 = g_vlz.vlz72 #參數檔中虛擬外包商 #FUN-9A0047 mark
     END IF

    #FUN-960039 MARK --STR----------------------------------
    #IF NOT cl_null(l_vng.vng06) THEN #TQC-870007
    #    LET g_vbg.vbg06 = l_vng.vng06
    #ELSE
    #    LET g_vbg.vbg06 = 1
    #END IF
    #FUN-960039 MARK --END---------------------------------

     #vbg07
     IF cl_null(l_ecm25) THEN LET l_ecm25 = '00:00' END IF
     LET l_tmp = NULL
     LET l_tmp = l_to_char_ecm50,' ',l_ecm25,':00'
     LET l_date_tmp1 = l_tmp CLIPPED 
     #vbg08
     IF cl_null(l_ecm26) THEN LET l_ecm26 = '00:00' END IF
     LET l_tmp = NULL
     LET l_tmp = l_to_char_ecm51,' ',l_ecm26,':00'
     LET l_date_tmp2 = l_tmp CLIPPED 
     #vbg09
     LET l_hh_ecm25 = l_ecm25[1,2]
     LET l_mm_ecm25 = l_ecm25[4,5]
     LET l_hh_ecm26 = l_ecm26[1,2]
     LET l_mm_ecm26 = l_ecm26[4,5]
     IF NOT cl_null(l_ecm50) AND NOT  cl_null(l_ecm51) THEN #TQC-870007
         LET l_hhmm1=(l_ecm51-l_date)*1440+l_hh_ecm26*60+l_mm_ecm26
         LET l_hhmm2=(l_ecm50-l_date)*1440+l_hh_ecm25*60+l_mm_ecm25
         LET g_vbg.vbg09 = (l_hhmm1-l_hhmm2)*60 #公式(ecm51:ecm26 - ecm50:ecm25)*60(秒)
     ELSE
         LET g_vbg.vbg09 = 0
     END IF
     
     IF NOT cl_null(l_vng.vng10) THEN
         LET g_vbg.vbg10 = l_vng.vng10
     ELSE
         LET g_vbg.vbg10 = 0
     END IF

    #FUN-960039 ADD --STR----------------------------------
     IF cl_null(l_vnd.vnd01) THEN
         LET g_vbg.vbg06 = '1'
         LET g_vbg.vbg10 = '0'
         LET g_vbg.vbg07 = ' '
         LET g_vbg.vbg08 = ' '
         SELECT eca06 INTO l_eca06 
           FROM eca_file
          WHERE eca01 = l_ecm06
         IF l_eca06 = '1' THEN
            LET l_fixwh = l_ecm15
            LET l_stdwh = l_ecm16 / l_sfb08
         ELSE
            LET l_fixwh = l_ecm13
            LET l_stdwh = l_ecm14 / l_sfb08
         END IF
         LET l_unprodqty = l_sfb08 - (l_ecm311 * l_ecm59) - (l_ecm312 * l_ecm59) -
                                     (l_ecm313 * l_ecm59) - (l_ecm314 * l_ecm59) -
                                     (l_ecm315 * l_ecm59) - (l_ecm316 * l_ecm59) 
         IF l_unprodqty < 0 THEN LET l_unprodqty = 0 END IF

         SELECT vmn09,vmn16,vmn13 INTO l_vmn09,l_vmn16,l_vmn13
          FROM vmn_file
         WHERE vmn01 = l_sfb05
           AND vmn02 = l_sfb01
           AND vmn03 = l_ecm03
           AND vmn04 = l_ecm04
           AND vmn012 = l_ecm012         #製程段號 #FUN-B50101 add
         IF l_vmn09 = '1' THEN 
            IF l_vmn16 = 0 THEN
               LET l_lotqty = 0
            ELSE
               LET l_lotqty = cl_digcut((l_unprodqty / l_vmn16) + 0.5,0)  #批量數=未生產數量/批次加工上限
            END IF 
            LET l_wkovtime = l_fixwh + (l_lotqty * l_stdwh) / (1)  #製程加工時間=固定工時 + (批量數 * 標準工時) / 設備效率[固定1]
         ELSE
            IF l_vmn13 = 0 OR cl_null(l_vmn13) THEN
               LET l_wkovtime = l_fixwh 
            ELSE  
               LET l_wkovtime = l_fixwh + (l_unprodqty * (l_stdwh / l_vmn13) ) / (1) #製程加工時間=固定工時+(未生產數量/基準數量))/設備效率[固定1]   
            END IF
         END IF 
         LET g_vbg.vbg09 = l_wkovtime
     ELSE
         CASE l_vnd.vnd06 #鎖定碼
              WHEN 0  #0:不鎖定時間
                   LET g_vbg.vbg06 = 1  #外包類型
              WHEN 3 #3:鎖定開始時間和結束時間
                   LET g_vbg.vbg06 = 2
         END CASE
         LET g_vbg.vbg07 = l_vnd.vnd07
         LET g_vbg.vbg08 = l_vnd.vnd08
         LET g_vbg.vbg09 = l_vnd.vnd11 #外包時間長度(秒)
         LET g_vbg.vbg10 = l_vnd.vnd09 #是否排程
     END IF
    #FUN-960039 MOD --END--------------------

     IF NOT cl_null(l_vng.vng11) THEN
         LET g_vbg.vbg11 = l_vng.vng11
     ELSE
         LET g_vbg.vbg11 = 1
     END IF
     IF NOT cl_null(l_sfb08) THEN
         LET g_vbg.vbg12 = l_sfb08
     ELSE
         LET g_vbg.vbg12 = 0
     END IF
     LET g_vbg.vbglegal = g_legal  #FUN-B50022 add
     LET g_vbg.vbgplant = g_plant  #FUN-B50022 add
     LET g_vbg.vbg012   = l_ecm012 #FUN-B50101 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vbg FROM g_vbg.vbg01,g_vbg.vbg02,g_vbg.vbg03,g_vbg.vbg04,g_vbg.vbg05,
                            #g_vbg.vbg06,l_date_tmp1,l_date_tmp2,g_vbg.vbg09,g_vbg.vbg10, #FUN-960039 MARK
                             g_vbg.vbg06,g_vbg.vbg07,g_vbg.vbg08,g_vbg.vbg09,g_vbg.vbg10, #FUN-960039 ADD
                             g_vbg.vbg11,g_vbg.vbg12,g_vbg.vbgplant,g_vbg.vbglegal, #FUN-B50022 add plant,legal
                             g_vbg.vbg13,g_vbg.vbg14,g_vbg.vbg15,g_vbg.vbg16,g_vbg.vbg17,  #FUN-940030 ADD
                             g_vbg.vbg18,g_vbg.vbg19,g_vbg.vbg20,g_vbg.vbg012    #FUN-940030 ADD #FUN-B50101 add vbg012
     #TQC-860041---mod---end---
     IF STATUS THEN
        #FUN-940030  MARK  --STR--
        #LET g_msg = 'Key:',g_vbg.vbg01 CLIPPED,' + ',
        #                   g_vbg.vbg02 CLIPPED,' + ',
        #                   g_vbg.vbg03 CLIPPED,' + ',
        #                   g_vbg.vbg04 CLIPPED
        #FUN-940030  MARK  --END--
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vbg01',g_vbg.vbg01,'vbg02',g_vbg.vbg02,'vbg03',g_vbg.vbg03,'vbg04',g_vbg.vbg04,'','','','')   #FUN-940030 ADD
       #CALL err('vbg_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vbg_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vbg.* TO NULL
     INITIALIZE l_vng.* TO NULL
     LET l_pmm09 = NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vbg_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vbg_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vbg_c:',STATUS,1) RETURN END IF
END FUNCTION

#FUN-8A0003---add---str---
FUNCTION p500_vbj()      #工模具主檔
DEFINE l_sql            STRING                
DEFINE l_vnj            RECORD LIKE vnj_file.* 
DEFINE l_feb            RECORD LIKE feb_file.*

  IF tm.vlb47  = 'N' THEN RETURN END IF

  DECLARE p500_vbj_c CURSOR FOR 
   SELECT feb_file.*,vnj_file.* FROM feb_file,OUTER vnj_file
    WHERE feb02 = vnj_file.vnj01 

  INITIALIZE g_vbj.* TO NULL
  INITIALIZE l_vnj.* TO NULL
  INITIALIZE l_feb.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vbj_c INTO l_feb.*,l_vnj.*
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vbj_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vbj.vbj01 = l_feb.feb02
     LET g_vbj.vbj02 = l_feb.feb02
     LET g_vbj.vbj03 = l_feb.feb02
     LET g_vbj.vbj04 = NULL
     LET g_vbj.vbj05 = NULL
     LET g_vbj.vbj06 = NULL
     LET g_vbj.vbj07 = NULL
     LET g_vbj.vbj08 = NULL
     LET g_vbj.vbj09 = NULL
     LET g_vbj.vbj10 = NULL
     LET g_vbj.vbj11 = NULL
     LET g_vbj.vbj12 = l_vnj.vnj02
     LET g_vbj.vbj13 = l_vnj.vnj03
     LET g_vbj.vbj14 = l_feb.feb01
     LET g_vbj.vbjlegal = g_legal #FUN-B50022 add
     LET g_vbj.vbjplant = g_plant #FUN-B50022 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vbj FROM g_vbj.*
     IF STATUS THEN
        #LET g_msg = 'Key:',g_vbj.vbj01 CLIPPED   #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vbj01',g_vbj.vbj01,'','','','','','','','','','')   #FUN-940030 ADD
       #CALL err('vbj_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vbj_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vbj.* TO NULL
     INITIALIZE l_vnj.* TO NULL
     INITIALIZE l_feb.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vbj_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vbj_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vbj_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p500_vbk()      #工模具群組主檔
DEFINE l_sql            STRING                
DEFINE l_vnk            RECORD LIKE vnk_file.* 

  IF tm.vlb47  = 'N' THEN RETURN END IF

  DECLARE p500_vbk_c CURSOR FOR 
   SELECT * FROM vnk_file

  INITIALIZE g_vbk.* TO NULL
  INITIALIZE l_vnk.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vbk_c INTO l_vnk.*
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vbk_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vbk.vbk01 = l_vnk.vnk01
     LET g_vbk.vbk02 = l_vnk.vnk02
     LET g_vbk.vbk03 = l_vnk.vnk03
     LET g_vbk.vbklegal = g_legal #FUN-B50022 add
     LET g_vbk.vbkplant = g_plant #FUN-B50022 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vbk FROM g_vbk.*
     IF STATUS THEN
        #LET g_msg = 'Key:',g_vbk.vbk01 CLIPPED   #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vbk01',g_vbk.vbk01,'','','','','','','','','','')   #FUN-940030 ADD
       #CALL err('vbk_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vbk_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vbk.* TO NULL
     INITIALIZE l_vnk.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vbk_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vbk_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vbk_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p500_vbl()      #工模具群組明細檔
DEFINE l_sql            STRING                
DEFINE l_vnl            RECORD LIKE vnl_file.* 

  IF tm.vlb47  = 'N' THEN RETURN END IF

  DECLARE p500_vbl_c CURSOR FOR 
   SELECT * FROM vnl_file

  INITIALIZE g_vbl.* TO NULL
  INITIALIZE l_vnl.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vbl_c INTO l_vnl.*
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vbl_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vbl.vbl01 = l_vnl.vnl01
     LET g_vbl.vbl02 = l_vnl.vnl02
     LET g_vbl.vbllegal = g_legal #FUN-B50022 add
     LET g_vbl.vblplant = g_plant #FUN-B50022 add
 
     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vbl FROM g_vbl.*
     IF STATUS THEN
        #LET g_msg = 'Key:',g_vbl.vbl01 CLIPPED ,' + ',  #FUN-940030 MARK
        #                   g_vbl.vbl02 CLIPPED          #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vbl01',g_vbl.vbl01,'vbl02',g_vbl.vbl02,'','','','','','','','')   #FUN-940030 ADD
       #CALL err('vbl_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vbl_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vbl.* TO NULL
     INITIALIZE l_vnl.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vbl_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vbl_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vbl_c:',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p500_vbm_1()      #途程製程指定工具--標準aeci100
DEFINE l_sql            STRING                
DEFINE l_vnm            RECORD LIKE vnm_file.* 
DEFINE l_ecb            RECORD LIKE ecb_file.* 
DEFINE l_chr5           LIKE type_file.chr5 

  IF tm.vlb47  = 'N' THEN RETURN END IF

  DECLARE p500_vbm_1_c CURSOR FOR 
   SELECT ecb_file.*,vnm_file.* FROM ecb_file,vnm_file
    WHERE ecb01 = vnm00
      AND ecb02 = vnm01
      AND ecb03 = vnm02
      AND ecb06 = vnm03
      AND ecb012= vnm012 #FUN-B50101 add

  INITIALIZE g_vbm.* TO NULL
  INITIALIZE l_vnm.* TO NULL
  INITIALIZE l_ecb.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vbm_1_c INTO l_ecb.*,l_vnm.*
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vbm_1_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vbm.vbm01 = l_ecb.ecb01 CLIPPED,'-',l_ecb.ecb02 CLIPPED
     LET l_chr5  = l_ecb.ecb03 USING '&&&&&' 
     LET g_vbm.vbm02 = l_chr5               
     LET g_vbm.vbm03 = l_ecb.ecb06
     LET g_vbm.vbm04 = l_vnm.vnm04
     IF NOT cl_null(l_vnm.vnm06) THEN
         LET g_vbm.vbm05 = l_vnm.vnm06
     ELSE
         LET g_vbm.vbm05 = 1
     END IF
     LET g_vbm.vbmplant = g_plant #FUN-B50022
     LET g_vbm.vbmlegal = g_legal #FUN-B50022
     LET g_vbm.vbm14 = l_vnm.vnm012 #FUN-B50101

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vbm FROM g_vbm.*
     IF STATUS THEN
        #FUN-940030  MARK  --STR--
        #LET g_msg = 'Key:',g_vbm.vbm01 CLIPPED ,' + ',
        #                   g_vbm.vbm02 CLIPPED ,' + ',
        #                   g_vbm.vbm03 CLIPPED ,' + ',
        #                   g_vbm.vbm04 CLIPPED 
        #FUN-940030  MARK  --END--
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vbm01',g_vbm.vbm01,'vbm02',g_vbm.vbm02,'vbm03',g_vbm.vbm03,'vbm04',g_vbm.vbm04,'','','','')   #FUN-940030 ADD
       #CALL err('vbm_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vbm_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vbm.* TO NULL
     INITIALIZE l_vnm.* TO NULL
     INITIALIZE l_ecb.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add
 
 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vbm_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vbm_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vbm_1_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p500_vbm_2()      #途程製程指定工具--工單aeci700
DEFINE l_sql            STRING                
DEFINE l_vnm            RECORD LIKE vnm_file.* 
DEFINE l_ecm            RECORD LIKE ecm_file.* 
DEFINE l_chr5           LIKE type_file.chr5 

  IF tm.vlb47  = 'N' THEN RETURN END IF

 #FUN-8A0011 ---mod----str---
 IF NOT cl_null(g_vlz70) THEN 
     CALL s_get_sql_msp04(g_vlz70,'ecm01') RETURNING g_sql_limited 
 ELSE
     LET g_sql_limited = ' 1=1 '
 END IF
 LET l_sql = "SELECT ecm_file.*,vnm_file.* FROM ecm_file,vnm_file,sfb_file ",
             " WHERE ecm03_par = vnm00 ", #品號            
             "   AND ecm01     = vnm01 ", #途程編號        
             "   AND ecm03     = vnm02 ", #途程中的加工序號
             "   AND ecm04     = vnm03 ", #作業編號        
             #工單條件----str---
             "   AND ecm01     = sfb01 ",
            #"   AND sfb08 > sfb09 ",              #FUN-CB0131 mark
             "   AND sfb08 > sfb09 + sfb12 ",      #FUN-CB0131 add
             "   AND sfb04 <  '8' ",
             "   AND sfb13 <= '",tm.vlb08,"'",       #預計開工日小於資料截止日期
             "   AND sfb87 != 'X' ",
             "   AND sfb01 IS NOT NULL ",
             "   AND sfb01 != ' ' ",
             #工單條件----end---
             "   AND ",g_sql_limited CLIPPED

  PREPARE p500_vbm_2_p FROM l_sql
  IF STATUS THEN CALL cl_err('pre p500_vbm_2_p',STATUS,1) END IF
  DECLARE p500_vbm_2_c CURSOR FOR p500_vbm_2_p
  IF STATUS THEN CALL cl_err('dec p500_vbm_2_c',STATUS,1) END IF
  #FUN-8A0011 ---mod----end---

  INITIALIZE g_vbm.* TO NULL
  INITIALIZE l_vnm.* TO NULL
  INITIALIZE l_ecm.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vbm_2_c INTO l_ecm.*,l_vnm.*
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vbm_2_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vbm.vbm01 = l_ecm.ecm03_par CLIPPED,'-',l_ecm.ecm01 CLIPPED
     LET l_chr5  = l_ecm.ecm03 USING '&&&&&' 
     LET g_vbm.vbm02 = l_chr5               
     LET g_vbm.vbm03 = l_ecm.ecm04
     LET g_vbm.vbm04 = l_vnm.vnm04
     IF NOT cl_null(l_vnm.vnm06) THEN
         LET g_vbm.vbm05 = l_vnm.vnm06
     ELSE
         LET g_vbm.vbm05 = 1
     END IF

     LET g_vbm.vbmplant = g_plant   #FUN-B50022
     LET g_vbm.vbmlegal = g_legal   #FUN-B50022
     LET g_vbm.vbm14 = l_vnm.vnm012 #FUN-B50101

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD 
     PUT p500_c_ins_vbm FROM g_vbm.*
     IF STATUS THEN
        #FUN-940030  MARK   --STR-- 
        #LET g_msg = 'Key:',g_vbm.vbm01 CLIPPED ,' + ',
        #                   g_vbm.vbm02 CLIPPED ,' + ',
        #                   g_vbm.vbm03 CLIPPED ,' + ',
        #                   g_vbm.vbm04 CLIPPED 
        #FUN-940030  MARK   --END--
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vbm01',g_vbm.vbm01,'vbm02',g_vbm.vbm02,'vbm03',g_vbm.vbm03,'vbm04',g_vbm.vbm04,'','','','')   #FUN-940030 ADD
       #CALL err('vbm_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vbm_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vbm.* TO NULL
     INITIALIZE l_vnm.* TO NULL
     INITIALIZE l_ecm.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vbm_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vbm_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vbm_2_c:',STATUS,1) RETURN END IF
END FUNCTION

#FUN-CA0018 ADD ------str
FUNCTION p500_vbm_3()
DEFINE l_sql            STRING
DEFINE l_vnm            RECORD LIKE vnm_file.*
DEFINE l_vms            RECORD LIKE vms_file.*
DEFINE l_str            LIKE vbm_file.vbm01

  IF tm.vlb47  = 'N' THEN RETURN END IF

  DECLARE p500_vbm_3_c CURSOR FOR
   SELECT * FROM vnm_file,vms_file 
    WHERE vms01 = vnm00   
      AND vms02 = vnm01  
      AND vms03 = vnm02 
      AND vms04 = vnm03  
      AND vms012= vnm012

  INITIALIZE g_vbm.* TO NULL
  INITIALIZE l_vnm.* TO NULL
  INITIALIZE l_vms.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vbm_3_c INTO l_vnm.*,l_vms.*
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vbm_3_c:',STATUS,1) EXIT FOREACH
     END IF

     LET l_str=''
     LET l_str=l_vms.vms01 CLIPPED,'-',l_vms.vms02 CLIPPED  #vnm01 途程編號 = vms01-vms02

     LET g_vbm.vbm01 = l_str
     LET g_vbm.vbm02 = l_vms.vms03 USING '&&&&&' 
     LET g_vbm.vbm03 = l_vms.vms04 
     LET g_vbm.vbm04 = l_vnm.vnm04
     IF NOT cl_null(l_vnm.vnm06) THEN
         LET g_vbm.vbm05 = l_vnm.vnm06
     ELSE
         LET g_vbm.vbm05 = 1
     END IF
     LET g_vbm.vbmplant = g_plant 
     LET g_vbm.vbmlegal = g_legal 
     LET g_vbm.vbm14 = l_vnm.vnm012

     LET g_wrows = g_wrows + 1  
     PUT p500_c_ins_vbm FROM g_vbm.*
     IF STATUS THEN
        LET g_status = STATUS        
        CALL p500_getmsg('vbm01',g_vbm.vbm01,'vbm02',g_vbm.vbm02,'vbm03',g_vbm.vbm03,'vbm04',g_vbm.vbm04,'','','','') 
        CALL err('vbm_file',g_msg,g_status,'2') 
        LET g_erows = g_erows + 1   
     END IF
     INITIALIZE g_vbm.* TO NULL
     INITIALIZE l_vnm.* TO NULL
     INITIALIZE l_vms.* TO NULL
  
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND 
  LET g_run_sec = g_run_end - g_run_str  

  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str 
  CALL  err('vbm_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND" 
  CALL  err('vbm_file','',g_msg,'1')
  IF SQLCA.sqlcode THEN CALL cl_err('p500_vbm_3_c:',STATUS,1) RETURN END IF
END FUNCTION
#FUN-CA0018 ADD ------end

FUNCTION p500_vbn()      #工模具保修明細檔
DEFINE l_sql            STRING                
DEFINE l_vnn            RECORD LIKE vnn_file.* 
DEFINE l_date_tmp1      DATETIME YEAR TO MINUTE #TQC-8A0053 add
DEFINE l_date_tmp2      DATETIME YEAR TO MINUTE #TQC-8A0053 add
DEFINE l_tmp            LIKE type_file.chr20    #TQC-8A0053 add
DEFINE l_to_char_vnn02  LIKE type_file.chr10    #TQC-8A0053 add
DEFINE l_to_char_vnn03  LIKE type_file.chr10    #TQC-8A0053 add
DEFINE l_sql1           STRING                  #FUN-B50022 add
DEFINE l_sql2           STRING                  #FUN-B50022 add

  IF tm.vlb47  = 'N' THEN RETURN END IF
 #FUN-B50022----mod---str---
 #DECLARE p500_vbn_c CURSOR FOR 
 # SELECT vnn_file.*,TO_CHAR(vnn02,'YYYY-MM-DD'),TO_CHAR(vnn03,'YYYY-MM-DD') FROM vnn_file #TQC-8A0053 mod
  LET l_sql1 = cl_tp_tochar('vnn02','YYYY-MM-DD')
  LET l_sql2 = cl_tp_tochar('vnn03','YYYY-MM-DD')
  LET l_sql = "SELECT vnn_file.*,",l_sql1 CLIPPED,",",l_sql2 CLIPPED," FROM vnn_file "
  PREPARE p500_vbn_p FROM l_sql
  IF STATUS THEN CALL cl_err('pre p500_vbn_p',STATUS,1) END IF
  DECLARE p500_vbn_c CURSOR FOR p500_vbn_p
  IF STATUS THEN CALL cl_err('dec p500_vbn_c',STATUS,1) END IF
 #FUN-B50022----mod---end---

  INITIALIZE g_vbn.* TO NULL
  INITIALIZE l_vnn.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vbn_c INTO l_vnn.*,l_to_char_vnn02,l_to_char_vnn03
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vbn_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vbn.vbn01 = l_vnn.vnn01
     #TQC-8A0053 mod---str--
     #==>vbn02
     IF NOT cl_null(l_vnn.vnn02) THEN
         LET l_tmp = NULL
         LET l_tmp = l_to_char_vnn02,' ',l_vnn.vnn021
         LET l_date_tmp1 = l_tmp CLIPPED  
     ELSE
         LET l_date_tmp1 = NULL
     END IF

     #==>vbn03
     IF NOT cl_null(l_vnn.vnn03) THEN
         LET l_tmp = NULL
         LET l_tmp = l_to_char_vnn03,' ',l_vnn.vnn031
         LET l_date_tmp2 = l_tmp CLIPPED  
     ELSE
         LET l_date_tmp2 = NULL
     END IF
     LET g_vbn.vbnlegal = g_legal #FUN-B50022 add
     LET g_vbn.vbnplant = g_plant #FUN-B50022 add

    #PUT p500_c_ins_vbn FROM g_vbn.*
     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vbn FROM g_vbn.vbn01,l_date_tmp1,l_date_tmp2,
                             g_vbn.vbn04,g_vbn.vbn05,g_vbn.vbn06,g_vbn.vbn07,g_vbn.vbn08,g_vbn.vbn09,  #FUN-940030 ADD
                             g_vbn.vbn10,g_vbn.vbn11,g_vbn.vbnlegal,g_vbn.vbnplant    #FUN-940030 ADD #FUN-B50022 add legal,plant
     #TQC-8A0053 mod---end--
     IF STATUS THEN
        #FUN-940030  MARK   --STR--
        #LET g_msg = 'Key:',g_vbn.vbn01 CLIPPED ,' + ',
        #                   l_date_tmp1 CLIPPED #TQC-8A0053 mod
        #                  #g_vbn.vbn02 CLIPPED #TQC-8A0053 mod
        #FUN-940030  MARK   --END--
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vbn01',g_vbn.vbn01,'vbn02',l_date_tmp1,'','','','','','','','')   #FUN-940030 ADD
       #CALL err('vbn_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vbn_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vbn.* TO NULL
     INITIALIZE l_vnn.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vbn_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vbn_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vbn_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p500_vbo()      #工模具大類主檔
DEFINE l_sql            STRING                
DEFINE l_vno            RECORD LIKE vno_file.* 
DEFINE l_fea            RECORD LIKE fea_file.* 

  IF tm.vlb47  = 'N' THEN RETURN END IF

  DECLARE p500_vbo_c CURSOR FOR 
   SELECT fea_file.*,vno_file.* FROM fea_file,OUTER vno_file
    WHERE fea01 = vno_file.vno01

  INITIALIZE g_vbo.* TO NULL
  INITIALIZE l_vno.* TO NULL
  INITIALIZE l_fea.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vbo_c INTO l_fea.*,l_vno.*
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vbo_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vbo.vbo01 = l_fea.fea01
     LET g_vbo.vbo02 = l_fea.fea02
     LET g_vbo.vbo03 = l_fea.fea031
     IF NOT cl_null(l_vno.vno02) THEN
         LET g_vbo.vbo04 = l_vno.vno02
     ELSE
         LET g_vbo.vbo04 = 0
     END IF
     LET g_vbo.vbolegal = g_legal #FUN-B50022 add
     LET g_vbo.vboplant = g_plant #FUN-B50022 add

     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vbo FROM g_vbo.*
     IF STATUS THEN
        #LET g_msg = 'Key:',g_vbo.vbo01 CLIPPED   #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vbo01',g_vbo.vbo01,'','','','','','','','','','')   #FUN-940030 ADD
       #CALL err('vbo_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vbo_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vbo.* TO NULL
     INITIALIZE l_vno.* TO NULL
     INITIALIZE l_fea.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vbo_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vbo_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vbo_c:',STATUS,1) RETURN END IF
END FUNCTION
#FUN-8A0003---add---end---

FUNCTION p500_get_vlz()
    SELECT * INTO g_vlz.*
      FROM vlz_file
     WHERE vlz01 = tm.vlb01
       AND vlz02 = tm.vlb02

    SELECT * INTO g_vla.*
      FROM vla_file
     WHERE vla01 = tm.vlb01
    #TQC-8C0034---add---str--
    IF STATUS = 100 THEN
        LET g_vla.vla02 = NULL
    END IF
    #TQC-8C0034---add---end--
     
END FUNCTION

FUNCTION p500_select_all()
     #普通資料
     LET tm.vlb11 = 'Y' 
     LET tm.vlb12 = 'Y'
     LET tm.vlb13 = 'Y'
     LET tm.vlb14 = 'Y'
     LET tm.vlb15 = 'Y'
     LET tm.vlb16 = 'Y'
     LET tm.vlb17 = 'Y'
     LET tm.vlb18 = 'Y'
     LET tm.vlb19 = 'Y' 
     LET tm.vlb20 = 'Y'
     LET tm.vlb21 = 'Y'
     LET tm.vlb23 = 'Y'  
     LET tm.vlb24 = 'Y'  
     LET tm.vlb25 = 'Y'  
     LET tm.vlb26 = 'Y'  
     LET tm.vlb27 = 'Y'
     LET tm.vlb28 = 'Y'
     LET tm.vlb29 = 'Y'
     LET tm.vlb30 = 'Y'
     LET tm.vlb31 = 'Y' 
     LET tm.vlb32 = 'Y'
     LET tm.vlb37 = 'Y'
     LET tm.vlb40 = 'Y'
     LET tm.vlb41 = 'Y' 
     LET tm.vlb09 = 'N'
     LET tm.vlb10 = 'Y'
     LET tm.vlb47 = 'Y' #FUN-8A0003 add
     #需求資料
     LET tm.vlb33 = 'Y'
     LET tm.vlb34 = 'Y' 
     LET tm.vlb36 = 'Y'
     #供給資料   
     LET tm.vlb22 = 'Y'
     LET tm.vlb35 = 'Y'
     LET tm.vlb38 = 'Y' 
     LET tm.vlb39 = 'Y'
     #產能資料
     LET tm.vlb42 = 'Y'
     LET tm.vlb43 = 'Y' 
     LET tm.vlb44 = 'Y'
     LET tm.vlb45 = 'Y'
     LET tm.vlb46 = 'Y' 
     DISPLAY BY NAME 
       #普通資料
       tm.vlb11, tm.vlb12, tm.vlb13, tm.vlb14, tm.vlb15, 
       tm.vlb16, tm.vlb17, tm.vlb18, tm.vlb19, tm.vlb20,
       tm.vlb21, tm.vlb23, tm.vlb24, tm.vlb25, tm.vlb26, 
       tm.vlb27, tm.vlb28, tm.vlb29, tm.vlb30, tm.vlb31, 
       tm.vlb32, tm.vlb37, tm.vlb40, tm.vlb41, tm.vlb09,
       tm.vlb10, tm.vlb47, #FUN-8A0003 add vlb47
       #需求資料
       tm.vlb33, tm.vlb34, tm.vlb36,
       #供給資料
       tm.vlb22, tm.vlb35, tm.vlb38,tm.vlb39,
       #產能資料
       tm.vlb42, tm.vlb43, tm.vlb44,tm.vlb45,tm.vlb46
END FUNCTION

FUNCTION p500_un_select_all()
     #普通資料
     LET tm.vlb11 = 'N' 
     LET tm.vlb12 = 'N'
     LET tm.vlb13 = 'N'
     LET tm.vlb14 = 'N'
     LET tm.vlb15 = 'N'
     LET tm.vlb16 = 'N'
     LET tm.vlb17 = 'N'
     LET tm.vlb18 = 'N'
     LET tm.vlb19 = 'N' 
     LET tm.vlb20 = 'N'
     LET tm.vlb21 = 'N'
     LET tm.vlb23 = 'N'  
     LET tm.vlb24 = 'N'  
     LET tm.vlb25 = 'N'  
     LET tm.vlb26 = 'N'  
     LET tm.vlb27 = 'N'
     LET tm.vlb28 = 'N'
     LET tm.vlb29 = 'N'
     LET tm.vlb30 = 'N'
     LET tm.vlb31 = 'N' 
     LET tm.vlb32 = 'N'
     LET tm.vlb37 = 'N'
     LET tm.vlb40 = 'N'
     LET tm.vlb41 = 'N' 
     LET tm.vlb09 = 'N'
     LET tm.vlb10 = 'Y'
     LET tm.vlb47 = 'N' #FUN-8A0003 add 
     #需求資料
     LET tm.vlb33 = 'N'
     LET tm.vlb34 = 'N' 
     LET tm.vlb36 = 'N'
     #供給資料   
     LET tm.vlb22 = 'N'
     LET tm.vlb35 = 'N'
     LET tm.vlb38 = 'N' 
     LET tm.vlb39 = 'N'
     #產能資料
     LET tm.vlb42 = 'N'
     LET tm.vlb43 = 'N' 
     LET tm.vlb44 = 'N'
     LET tm.vlb45 = 'N'
     LET tm.vlb46 = 'N' 
     DISPLAY BY NAME 
       #普通資料
       tm.vlb11, tm.vlb12, tm.vlb13, tm.vlb14, tm.vlb15, 
       tm.vlb16, tm.vlb17, tm.vlb18, tm.vlb19, tm.vlb20,
       tm.vlb21, tm.vlb23, tm.vlb24, tm.vlb25, tm.vlb26, 
       tm.vlb27, tm.vlb28, tm.vlb29, tm.vlb30, tm.vlb31, 
       tm.vlb32, tm.vlb37, tm.vlb40, tm.vlb41, tm.vlb09,
       tm.vlb10, tm.vlb47, #FUN-8A0003 add vlb47
       #需求資料
       tm.vlb33, tm.vlb34, tm.vlb36,
       #供給資料
       tm.vlb22, tm.vlb35, tm.vlb38,tm.vlb39,
       #產能資料
       tm.vlb42, tm.vlb43, tm.vlb44,tm.vlb45,tm.vlb46
END FUNCTION

FUNCTION p500_vzy()      
DEFINE l_sql        STRING                
DEFINE l_vly        RECORD LIKE vly_file.*

  IF tm.vlb09 = 'N' THEN RETURN END IF

  DECLARE p500_vly_c CURSOR FOR 
   SELECT * FROM vly_file     

  INITIALIZE g_vzy.* TO NULL
  INITIALIZE l_vly.* TO NULL
  LET g_run_str = CURRENT YEAR TO SECOND  #FUN-B80084 add
  FOREACH p500_vly_c INTO l_vly.*   
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vly_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vzy.vzy00 = g_plant
     LET g_vzy.vzy01 = l_vly.vly01
     LET g_vzy.vzy02 = l_vly.vly02
     LET g_vzy.vzy03 = l_vly.vly03
     LET g_vzy.vzy04 = l_vly.vly04
     LET g_vzy.vzy05 = l_vly.vly05
     LET g_vzy.vzy06 = l_vly.vly06
     LET g_vzy.vzy07 = l_vly.vly07
     LET g_vzy.vzy08 = l_vly.vly08
     LET g_vzy.vzy09 = l_vly.vly09
     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vzy FROM g_vzy.*
     IF STATUS THEN
        #LET g_msg = 'Key:',g_vzy.vzy00 CLIPPED,' + ',g_vzy.vzy01 CLIPPED,' + ',g_vzy.vzy02 CLIPPED  #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vzy01',g_vzy.vzy01,'vzy01',g_vzy.vzy01,'vzy02',g_vzy.vzy02,'','','','','','')   #FUN-940030 ADD
       #CALL err('vzy_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vzy_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD
     END IF
     INITIALIZE g_vzy.* TO NULL
     INITIALIZE l_vly.* TO NULL
  END FOREACH
  LET g_run_end = CURRENT YEAR TO SECOND  #FUN-B80084 add
  LET g_run_sec = g_run_end - g_run_str   #FUN-B80084 add

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
 #LET   g_msg = g_wrows ,' ROWS'                          #FUN-B80084 mark
  LET   g_msg = g_wrows ,' ROWS','  Str Time:',g_run_str  #FUN-B80084 add
  CALL  err('vzy_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
 #LET   g_msg = g_crows ,' ROWS'                                                         #FUN-B80084 mark
  LET   g_msg = g_crows ,' ROWS','  End Time:',g_run_end,"  TOTAL:",g_run_sec," SECOND"  #FUN-B80084 add
  CALL  err('vzy_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vly_c:',STATUS,1) RETURN END IF
END FUNCTION


#FUN-8C0140  MARK  --STR--
{
FUNCTION p500_vzt()      
DEFINE l_sql        STRING                
DEFINE l_vlx        RECORD LIKE vlx_file.*

  IF tm.vlb09 = 'N' THEN RETURN END IF

  DECLARE p500_vlx_c CURSOR FOR 
   SELECT * FROM vlx_file     

  INITIALIZE g_vzt.* TO NULL
  INITIALIZE l_vlx.* TO NULL
  FOREACH p500_vlx_c INTO l_vlx.*   
     IF SQLCA.sqlcode THEN
         CALL cl_err('p500_vlx_c:',STATUS,1) EXIT FOREACH
     END IF
     LET g_vzt.vzt01 = l_vlx.vlx01
     LET g_vzt.vzt02 = l_vlx.vlx02
     LET g_vzt.vzt03 = l_vlx.vlx03
     LET g_vzt.vzt04 = l_vlx.vlx04
     LET g_vzt.vzt05 = l_vlx.vlx05
     LET g_vzt.vzt06 = l_vlx.vlx06
     LET g_wrows = g_wrows + 1   #FUN-940030  ADD
     PUT p500_c_ins_vzt FROM g_vzt.*
     IF STATUS THEN
        #LET g_msg = 'Key:',g_vzt.vzt01 CLIPPED  #FUN-940030 MARK
        LET g_status = STATUS                    #TQC-B70094 add
        CALL p500_getmsg('vzt01',g_vzt.vzt01,'','','','','','','','','','')   #FUN-940030 ADD
       #CALL err('vzt_file',g_msg,STATUS,'2')    #TQC-B70094 mark
        CALL err('vzt_file',g_msg,g_status,'2')  #TQC-B70094 add
        LET g_erows = g_erows + 1   #FUN-940030  ADD 
     END IF
     INITIALIZE g_vzt.* TO NULL
     INITIALIZE l_vlx.* TO NULL
  END FOREACH

 #FUN-940030  ADD記錄每個中介檔應拋及實拋筆數記錄 --STR---------------------
  LET   g_msg = g_wrows ,' ROWS'
  CALL  err('vzt_file','',g_msg,'0')
  LET   g_crows = g_wrows - g_erows
  LET   g_msg = g_crows ,' ROWS'
  CALL  err('vzt_file','',g_msg,'1')
 #FUN-940030  ADD  --END-----------------------------------------------------

  IF SQLCA.sqlcode THEN CALL cl_err('p500_vlx_c:',STATUS,1) RETURN END IF
END FUNCTION
}
#FUN-8C0140   MARK  --END--

FUNCTION p500_first()
   DEFINE   l_cnt        LIKE type_file.num5   


   SELECT COUNT(*) 
     INTO l_cnt
     FROM vlb_file
     WHERE vlb01 = tm.vlb01        #/*限定版本*/
       AND vlb02 = tm.vlb02        #/*儲存版本*/
       AND vlb03 = tm.vlb03        #/*產生人員*/
   IF l_cnt <=0 THEN
       CALL p500_wc_default()
   ELSE
       SELECT    vlb11,   vlb12,   vlb13,   vlb14,   vlb15,   vlb16,  vlb17,    vlb18,   vlb19,   vlb20,
                 vlb21,   vlb22,   vlb23,   vlb24,   vlb25,   vlb26,  vlb27,    vlb28,   vlb29,   vlb30,
                 vlb31,   vlb32,   vlb33,   vlb34,   vlb35,   vlb36,  vlb37,    vlb38,   vlb39,   vlb40,
                 vlb41,   vlb42,   vlb43,   vlb44,   vlb45,   vlb46,  
                 vlb47   #FUN-940030 ADD                             
         INTO tm.vlb11,tm.vlb12,tm.vlb13,tm.vlb14,tm.vlb15,tm.vlb16,tm.vlb17,tm.vlb18,tm.vlb19,tm.vlb20,
              tm.vlb21,tm.vlb22,tm.vlb23,tm.vlb24,tm.vlb25,tm.vlb26,tm.vlb27,tm.vlb28,tm.vlb29,tm.vlb30,
              tm.vlb31,tm.vlb32,tm.vlb33,tm.vlb34,tm.vlb35,tm.vlb36,tm.vlb37,tm.vlb38,tm.vlb39,tm.vlb40,
              tm.vlb41,tm.vlb42,tm.vlb43,tm.vlb44,tm.vlb45,tm.vlb46,
              tm.vlb47  #FUN-940030 ADD
         FROM vlb_file
         WHERE vlb01 = tm.vlb01        #/*限定版本*/
           AND vlb02 = tm.vlb02        #/*儲存版本*/
           AND vlb03 = tm.vlb03        #/*產生人員*/
       
       SELECT vld03,vld04 
         INTO tm.vlb07,tm.vlb08
         FROM vld_file
        WHERE vld01 = tm.vlb01
          AND vld02 = tm.vlb02
       LET tm.vlb09 = 'N'
       LET tm.vlb10 = 'Y'
   END IF
   IF cl_null(tm.vlb04) THEN
       LET tm.vlb04 = g_today
   END IF
   CALL p500_def_vlz03() #TQC-8A0053 add
   DISPLAY BY NAME 
     tm.vlb01, tm.vlb02, tm.vlb07, tm.vlb08, tm.vlb04,tm.vlb03,
     g_vlz03_dd,g_vlz03_tt, #TQC-8A0053 add
     #普通資料
     tm.vlb11, tm.vlb12, tm.vlb13, tm.vlb14, tm.vlb15, 
     tm.vlb16, tm.vlb17, tm.vlb18, tm.vlb19, tm.vlb20,
     tm.vlb21, tm.vlb23, tm.vlb24, tm.vlb25, tm.vlb26, 
     tm.vlb27, tm.vlb28, tm.vlb29, tm.vlb30, tm.vlb31, 
     tm.vlb32, tm.vlb37, tm.vlb40, tm.vlb41, tm.vlb09,
     tm.vlb10, tm.vlb47, #FUN-8A0003 add vlb47
     #需求資料
     tm.vlb33, tm.vlb34, tm.vlb36,
     #供給資料
     tm.vlb22, tm.vlb35, tm.vlb38,tm.vlb39,
     #產能資料
     tm.vlb42, tm.vlb43, tm.vlb44,tm.vlb45,tm.vlb46,
     tm.vlb47  #FUN-940030 ADD
     ##背景作業
     #g_bgjob
END FUNCTION

FUNCTION p500_ins_vzv(p_code) #APS各類訊息檔
 DEFINE   l_cnt         LIKE type_file.num5   
 DEFINE l_vzv           RECORD LIKE vzv_file.*
 DEFINE l_ze03          LIKE ze_file.ze03
 DEFINE l_vzv03         DATETIME YEAR TO SECOND
 DEFINE p_code          LIKE vzv_file.vzv06
   IF p_code = 'R' THEN
       SELECT COUNT(*) INTO l_cnt FROM vzv_file
        WHERE vzv00 = g_plant
          AND vzv01 = tm.vlb01
          AND vzv02 = tm.vlb02
       IF l_cnt >=1 THEN
           DELETE FROM vzv_file
            WHERE vzv00 = g_plant
              AND vzv01 = tm.vlb01
              AND vzv02 = tm.vlb02
           IF STATUS THEN
               CALL cl_err3("del","vzv_file",tm.vlb01,tm.vlb02,STATUS,"","del vzv_file fail:",1) 
           END IF
       END IF
   END IF
   CALL cl_getmsg('aps-504',g_lang) RETURNING l_ze03
   INITIALIZE l_vzv.* TO NULL   
   LET l_vzv.vzv00 = g_plant     #營運中心
   LET l_vzv.vzv01 = tm.vlb01    #APS版本
   LET l_vzv.vzv02 = tm.vlb02    #儲存版本
  #LET l_vzv03     = CURRENT YEAR TO SECOND #訊息接收時間
  #LET g_start_time = l_vzv03
   LET l_vzv.vzv04 = '10'        #訊息代號       
   LET l_vzv.vzv05 = l_ze03      #訊息說明==>TP資料轉至中介檔
   LET l_vzv.vzv06 = p_code      #訊息狀態       
   LET l_vzv.vzv07 = 'N'         #tiptop執行結果 
   LET l_vzv.vzv08 = g_user      #操作人員代號   
   LET l_vzv.vzvplant = g_plant  #FUN-B50022 add
   LET l_vzv.vzvlegal = g_legal  #FUN-B50022 add

   INSERT INTO vzv_file(vzv00,vzv01,vzv02,vzv04,
                        vzv05,vzv06,vzv07,vzv08,vzvplant,vzvlegal) #FUN-B50022 add vzvplant,vzvlegal
    VALUES(l_vzv.vzv00,l_vzv.vzv01,l_vzv.vzv02,l_vzv.vzv04,
           l_vzv.vzv05,l_vzv.vzv06,l_vzv.vzv07,l_vzv.vzv08,l_vzv.vzvplant,l_vzv.vzvlegal) #FUN-B50022 add vzvplant,vzvlegal
   IF STATUS THEN
       CALL cl_err3("ins","vzv_file",l_vzv.vzv01,l_vzv.vzv02,STATUS,"","ins vlb_file fail:",1)  
   ELSE
       IF p_code = 'R' THEN
           SELECT vzv03 INTO g_start_time 
             FROM vzv_file
            WHERE vzv00 = g_plant
              AND vzv01 = tm.vlb01
              AND vzv02 = tm.vlb02
              AND vzv06 = 'R'
       END IF
   END IF
END FUNCTION

FUNCTION p500_ins_vzu() #APS規劃狀態檔
 DEFINE l_i             LIKE type_file.num5   
 DEFINE l_cnt           LIKE type_file.num5   
 DEFINE l_vzu           RECORD LIKE vzu_file.*
 DEFINE l_ze03          LIKE ze_file.ze03
 DEFINE l_vzu03         DATETIME YEAR TO SECOND
 DEFINE p_code          LIKE vzu_file.vzu06
 DEFINE l_vzu04 ARRAY[6] OF LIKE vzu_file.vzu04

   INITIALIZE l_vzu.* TO NULL   
   CALL cl_getmsg('aps-505',g_lang) RETURNING l_vzu04[1] # '1.ERP檔到中介檔'
   CALL cl_getmsg('aps-506',g_lang) RETURNING l_vzu04[2] # '2.ETL(中介檔到APS檔)'
   CALL cl_getmsg('aps-507',g_lang) RETURNING l_vzu04[3] # '3.APS排程規劃'
   CALL cl_getmsg('aps-508',g_lang) RETURNING l_vzu04[4] # '4.等待規劃&確認'
   CALL cl_getmsg('aps-509',g_lang) RETURNING l_vzu04[5] # '5.ETL(APS檔到中介檔)'
   CALL cl_getmsg('aps-510',g_lang) RETURNING l_vzu04[6] # '6.ERP排程調整'
   SELECT COUNT(*) INTO l_cnt FROM vzu_file
    WHERE vzu00 = g_plant
      AND vzu01 = tm.vlb01
      AND vzu02 = tm.vlb02
   IF l_cnt >=1 THEN
       DELETE FROM vzu_file
        WHERE vzu00 = g_plant
          AND vzu01 = tm.vlb01
          AND vzu02 = tm.vlb02
       IF STATUS THEN
           CALL cl_err3("del","vzu_file",tm.vlb01,tm.vlb02,STATUS,"","del vzu_file fail:",1)  
       END IF
   END IF
  FOR l_i = 1 TO 6
       LET l_vzu.vzu00 = g_plant            #營運中心
       LET l_vzu.vzu01 = tm.vlb01           #APS版本
       LET l_vzu.vzu02 = tm.vlb02           #儲存版本
       LET l_vzu.vzu03 = l_i * 10           #程序編號
       LET l_vzu.vzu04 = l_vzu04[l_i]       #程序名稱       
       LET l_vzu.vzu05 = NULL               #開始時間(日期) 
       LET l_vzu.vzu06 = NULL               #結束時間(日期) 
       LET l_vzu.vzu07 = 'N'                #執行狀態       
       LET l_vzu.vzu08 = '2'                #APS整合類型    
       LET l_vzu.vzuplant = g_plant         #FUN-B50022 add
       LET l_vzu.vzulegal = g_legal         #FUN-B50022 add
       IF l_i = 1 THEN
           INSERT INTO vzu_file VALUES(l_vzu.vzu00,l_vzu.vzu01,l_vzu.vzu02,l_vzu.vzu03,l_vzu.vzu04,
                                      g_start_time,l_vzu.vzu06,l_vzu.vzu07,l_vzu.vzu08,l_vzu.vzuplant,l_vzu.vzulegal) #FUN-B50022 add plant,legal
           IF STATUS THEN
               CALL cl_err3("ins","vzu_file",l_vzu.vzu01,l_vzu.vzu02,STATUS,"","ins vlb_file fail:",1)  
           END IF
      ELSE
           INSERT INTO vzu_file VALUES(l_vzu.vzu00,l_vzu.vzu01,l_vzu.vzu02,l_vzu.vzu03,l_vzu.vzu04,
                                       l_vzu.vzu05,l_vzu.vzu06,l_vzu.vzu07,l_vzu.vzu08,l_vzu.vzuplant,l_vzu.vzulegal) #FUN-B50022 add plant,legal
           IF STATUS THEN
               CALL cl_err3("ins","vzu_file",l_vzu.vzu01,l_vzu.vzu02,STATUS,"","ins vlb_file fail:",1) 
           END IF
      END IF
  END FOR
END FUNCTION

FUNCTION p500_upd_vzy()
  DEFINE l_cnt      LIKE type_file.num10   

  UPDATE vzy_file 
     SET vzy11 = tm.vlb02
   WHERE vzy00 = g_plant
     AND vzy01 = tm.vlb01 
     AND vzy02 = '0'
  IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","vzy_file",tm.vlb01,tm.vlb02,SQLCA.sqlcode,"","upd vzy_file",1) 
  END IF
END FUNCTION

#FUN-870071---add---str--
FUNCTION p500_chk_vlh()
  DEFINE l_cnt      LIKE type_file.num10   
  DEFINE l_vzv01    LIKE vzv_file.vzv01 #FUN-990012 add
  DEFINE l_vzv02    LIKE vzv_file.vzv02 #FUN-990012 add
 #FUN-C20113 add str--------
  DEFINE l_vlh      RECORD  LIKE  vlh_file.*
  DEFINE l_msg      LIKE type_file.chr1000
  DEFINE l_zx02     LIKE zx_file.zx02
  DEFINE l_vlh_f1,l_vlh_f2,l_vlh_f3,l_vlh_f4   LIKE type_file.chr30

  SELECT * INTO l_vlh.*
    FROM vlh_file
   WHERE vlh01 = g_plant
  SELECT zx02 INTO l_zx02
    FROM zx_file
   WHERE zx01=l_vlh.vlh05
 #FUN-C20113 add end--------

  SELECT COUNT(*) INTO l_cnt
    FROM vlh_file
   WHERE vlh01 = g_plant
  IF l_cnt >= 1 THEN
     #CALL cl_err('','aps-512',1)       #FUN-C20113 mark
     #FUN-C20113 add str--------------
      CALL cl_getmsg('aps-811',g_lang) RETURNING g_msg
      CALL cl_get_feldname('vlb01',g_lang) RETURNING l_vlh_f1
      CALL cl_get_feldname('vlb02',g_lang) RETURNING l_vlh_f2
      CALL cl_get_feldname('vlh05',g_lang) RETURNING l_vlh_f3
      CALL cl_get_feldname('cpf02',g_lang) RETURNING l_vlh_f4
      LET l_msg = g_msg CLIPPED,l_vlh_f1 CLIPPED,':',l_vlh.vlh03,' ',l_vlh_f2 CLIPPED,':',l_vlh.vlh04,' ',
                                l_vlh_f3 CLIPPED,':',l_vlh.vlh05,' ',l_vlh_f4 CLIPPED,':',l_zx02 CLIPPED
      CALL cl_err(l_msg,'abm-020',1)
     #FUN-C20113 add end--------------
      CLOSE WINDOW p500
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
  ELSE
      #FUN-990012---add----str---
      #需檢查vzv_file,若vzv_file有存在相同的APS版本,當vzv04='30',vzv06='Y',vzv07='Y'時,
      #且vzv04找不到40的資料時,則先把apsq200上一個執行的APS版本及儲存版本的30階段改成(Y C)後,再開始執行apsp500
      DECLARE p500_sel_vzv2 CURSOR FOR
      SELECT vzv01,vzv02 
        FROM vzv_file
       WHERE vzv04 = '30'
         AND vzv06 = 'Y'
         AND vzv07 = 'Y'
         AND vzv01 = tm.vlb01
      ORDER BY vzv02

      FOREACH p500_sel_vzv2 INTO l_vzv01,l_vzv02
         SELECT COUNT(*) INTO l_cnt
           FROM vzv_file
          WHERE vzv04 = '40'
            AND vzv01 = l_vzv01
            AND vzv02 = l_vzv02
         IF l_cnt <=0 THEN
             UPDATE vzv_file
                SET vzv06 = 'C',
                    vzv07 = 'Y'
              WHERE vzv04 = '30'
                AND vzv06 = 'Y'
                AND vzv07 = 'Y'
                AND vzv01 = l_vzv01
                AND vzv02 = l_vzv02
             IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","vzv_file",l_vzv01,l_vzv02,STATUS,"","upd vzv_file fail:",1)   
                 CLOSE WINDOW p500
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time
                 EXIT PROGRAM
             END IF
             LET g_end_time = CURRENT YEAR TO SECOND
             UPDATE vzu_file
                SET vzu07 = 'C',
                    vzu06 = g_end_time
              WHERE vzu00 = g_plant
                AND vzu01 = l_vzv01
                AND vzu02 = l_vzv02
                AND vzu03 = '30'
             IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","vzu_file",l_vzv01,l_vzv02,STATUS,"","upd vzu_file fail:",1)   
                 CLOSE WINDOW p500
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time
                 EXIT PROGRAM
             END IF
         END IF
      END FOREACH
      #FUN-990012---add----end---
     #INSERT INTO vlh_file(vlh01,vlh02,vlh03,vlh04,vlh05,vlh06) VALUES (g_plant,'Y',tm.vlb01,tm.vlb02,tm.vlb03,g_bgjob) #FUN-890105 add vlh06             #FUN-D10051 mark
      INSERT INTO vlh_file(vlh01,vlh02,vlh03,vlh04,vlh05,vlh06,vlhlegal,vlhplant) VALUES (g_plant,'Y',tm.vlb01,tm.vlb02,tm.vlb03,g_bgjob,g_legal,g_plant) #FUN-D10051 add legal,plant
      IF STATUS THEN
          CALL cl_err3("ins","vlh_file",g_plant,"",STATUS,"","ins vlh_file fail:",1)   
          CLOSE WINDOW p500
          CALL cl_used(g_prog,g_time,2) RETURNING g_time
          EXIT PROGRAM
      END IF
  END IF
END FUNCTION

FUNCTION p500_run_apsp702()
   #TQC-990068 add----str---
   DEFINE     l_str     STRING   
   LET l_str = "Start PROGRAM:apsp500==> vzv01:",tm.vlb01 CLIPPED," vzv02:",tm.vlb02 CLIPPED
   CALL p500_scan_log(l_str) 
   #TQC-990068 add----end---
   #LET g_msg = " apsp702 '",g_bgjob CLIPPED,"'" #FUN-890087 mod  #FUN-8C0140 MARK
   #LET g_msg = " apsp702 '",g_bgjob CLIPPED,"' '",tm.vlb01 CLIPPED,"' '",tm.vlb02 CLIPPED,"'"  ##FUN-8C0140  ADD #TQC-950064 MARK
    LET g_msg = " apsp702 '",g_plant CLIPPED,"' '",g_bgjob CLIPPED,"' '",tm.vlb01 CLIPPED,"' '",tm.vlb02 CLIPPED,"'"  #TQC-950064 ADD
    CALL cl_cmdrun(g_msg CLIPPED)
END FUNCTION
#FUN-870071---add---end--


#FUN-940030  ADD  --STR--
FUNCTION  p500_getmsg(p_feld1,p_feld2,p_feld3,p_feld4,p_feld5,p_feld6,p_feld7,p_feld8,p_feld9,p_feld10,p_feld11,p_feld12)
  DEFINE p_feld1,p_feld3,p_feld5,p_feld7,p_feld9,p_feld11   LIKE  gaq_file.gaq01
  DEFINE p_feld2,p_feld4,p_feld6,p_feld8,p_feld10,p_feld12  LIKE  gaq_file.gaq03
  DEFINE l_feld1,l_feld3,l_feld5,l_feld7,l_feld9,l_feld11   LIKE  gaq_file.gaq03
  LET  l_feld1=NULL   LET  l_feld3=NULL  LET  l_feld5=NULL  
  LET  l_feld7=NULL   LET  l_feld9=NULL  LET  l_feld11=NULL
  CALL cl_get_feldname(p_feld1,g_lang) RETURNING l_feld1
  CALL cl_get_feldname(p_feld3,g_lang) RETURNING l_feld3
  CALL cl_get_feldname(p_feld5,g_lang) RETURNING l_feld5
  CALL cl_get_feldname(p_feld7,g_lang) RETURNING l_feld7
  CALL cl_get_feldname(p_feld9,g_lang) RETURNING l_feld9
  CALL cl_get_feldname(p_feld11,g_lang) RETURNING l_feld11
  LET g_msg = l_feld1 CLIPPED,':',p_feld2 CLIPPED
  IF NOT cl_null(l_feld3)  THEN
     LET g_msg = g_msg,' + ',l_feld3 CLIPPED,':',p_feld4  CLIPPED
  END IF
  IF NOT cl_null(l_feld5)  THEN
     LET g_msg = g_msg,' + ',l_feld5 CLIPPED,':',p_feld6  CLIPPED
  END IF
  IF NOT cl_null(l_feld7)  THEN
     LET g_msg = g_msg,' + ',l_feld7 CLIPPED,':',p_feld8  CLIPPED
  END IF
  IF NOT cl_null(l_feld9)  THEN
     LET g_msg = g_msg,' + ',l_feld9 CLIPPED,':',p_feld10  CLIPPED
  END IF
  IF NOT cl_null(l_feld11) THEN
     LET g_msg = g_msg,' + ',l_feld11 CLIPPED,':',p_feld12  CLIPPED
  END IF

END FUNCTION
#FUN-940030  ADD   --END--


#FUN-960167 ADD --STR-----------------------------------------------
##流程檢核--製令工單
FUNCTION p450_flowchk(p_sfb01)
DEFINE p_sfb01   LIKE  sfb_file.sfb01
DEFINE l_ecm     RECORD  LIKE  ecm_file.*
DEFINE l_cnt     SMALLINT
DEFINE l_vmn     RECORD  LIKE  vmn_file.*
DEFINE l_str     LIKE    ze_file.ze03
DEFINE l_vlc     RECORD  LIKE  vlc_file.*
DEFINE l_eca     RECORD  LIKE  eca_file.*
DEFINE l_vnd     RECORD  LIKE  vnd_file.*
DEFINE l_sql     STRING

  ##設備資料################################################################
  IF g_sma.sma917 = 1 THEN 
     #1:機器編號
     LET l_sql = "SELECT *    ",
                 "  FROM ecm_file ",
                 " WHERE ecm01 = '",p_sfb01,"'",
                 "   AND (ecm05 IS NULL OR ecm05 = '') ", #機器編號
                 " ORDER BY ecm01,ecm03 "
  ELSE
     #0:工作站
     LET l_sql = "SELECT *    ",
                 "  FROM ecm_file ",
                 " WHERE ecm01 = '",p_sfb01,"'",
                 "   AND (ecm06 IS NULL OR ecm06='')", #工作站編號
                 " ORDER BY ecm01,ecm03 "
  END IF

  PREPARE p450_flow_p FROM l_sql
  DECLARE p450_flow_c CURSOR FOR p450_flow_p
  INITIALIZE l_ecm.* TO NULL 
  FOREACH p450_flow_c INTO l_ecm.*
    IF SQLCA.sqlcode THEN EXIT FOREACH  END IF
       LET l_vmn.vmn08 = NULL
       LET l_vmn.vmn081 = NULL
       SELECT vmn08,vmn081 INTO l_vmn.vmn08, l_vmn.vmn081 
         FROM vmn_file 
        WHERE vmn01 = l_ecm.ecm03_par
          AND vmn02 = l_ecm.ecm01
          AND vmn03 = l_ecm.ecm03
          AND vmn04 = l_ecm.ecm04

       LET l_vlc.vlc00 = g_vlb00
       LET l_vlc.vlc01 = tm.vlb01
       LET l_vlc.vlc02 = tm.vlb02
       LET l_vlc.vlc03 = g_today
       LET l_vlc.vlc04 = TIME
       LET l_vlc.vlc05 = 'van_file'
       CALL cl_getmsg('aps-797',g_lang) RETURNING l_str
       LET l_vlc.vlc06 = l_str,':',l_ecm.ecm01 CLIPPED
       CALL cl_getmsg('aps-791',g_lang) RETURNING l_str
       LET l_vlc.vlc06 = l_vlc.vlc06,' + ',l_str,':',l_ecm.ecm03 USING '<<<<'
       CALL cl_getmsg('aps-792',g_lang) RETURNING l_str
       LET l_vlc.vlc06 = l_vlc.vlc06,' + ',l_str,':',l_ecm.ecm04 CLIPPED
       LET l_vlc.vlc09 = '3'
       LET l_vlc.vlc10 = 'aeci700'
       LET l_vlc.vlc11 = tm.vlb03

       IF g_sma.sma917 = 1 THEN
          #1:機器編號
          IF cl_null(l_vmn.vmn08) THEN #資源群組編號(機器)
              CALL cl_getmsg('aps-033',g_lang) RETURNING l_vlc.vlc07
              LET  l_vlc.vlc08 = 'aps-033'  
              INSERT INTO vlc_file(vlc00,vlc01,vlc02,vlc03,vlc04,vlc05,vlc06,vlc07,vlc08,vlc09,vlc10,vlc11)
                VALUES(l_vlc.vlc00,l_vlc.vlc01,l_vlc.vlc02,l_vlc.vlc03,l_vlc.vlc04,l_vlc.vlc05,l_vlc.vlc06,
                       l_vlc.vlc07,l_vlc.vlc08,l_vlc.vlc09,l_vlc.vlc10,l_vlc.vlc11)
          END IF
       ELSE
          #0:工作站
          IF cl_null(l_vmn.vmn081) THEN #資源群組編號(工作站)
             CALL cl_getmsg('aps-775',g_lang) RETURNING l_vlc.vlc07
             LET  l_vlc.vlc08='aps-775'
             INSERT INTO vlc_file(vlc00,vlc01,vlc02,vlc03,vlc04,vlc05,vlc06,vlc07,vlc08,vlc09,vlc10,vlc11)
               VALUES(l_vlc.vlc00,l_vlc.vlc01,l_vlc.vlc02,l_vlc.vlc03,l_vlc.vlc04,l_vlc.vlc05,l_vlc.vlc06,
                      l_vlc.vlc07,l_vlc.vlc08,l_vlc.vlc09,l_vlc.vlc10,l_vlc.vlc11)
          END IF        
       END IF   
       INITIALIZE l_ecm.* TO NULL 
  END FOREACH
  ###########################################################################

  #檢核二依工作站資料判斷工單製程工時
  ##一般製程#################################################################
  LET l_sql = "SELECT *    ",
              "  FROM ecm_file,eca_file ",
              " WHERE ecm01 = '",p_sfb01,"'",
              "   AND ecm06 = eca01  ",
              "   AND (ecm52 IS NULL OR ecm52 = 'N') ", #委外否
              " ORDER BY ecm01,ecm03 "

  PREPARE p450_flow_p2 FROM l_sql
  DECLARE p450_flow_c2 CURSOR FOR p450_flow_p2
  INITIALIZE l_ecm.* TO NULL 
  INITIALIZE l_eca.* TO NULL 
  FOREACH p450_flow_c2 INTO l_ecm.*, l_eca.*
    IF SQLCA.sqlcode THEN EXIT FOREACH  END IF

       LET l_vlc.vlc00 = g_vlb00
       LET l_vlc.vlc01 = tm.vlb01
       LET l_vlc.vlc02 = tm.vlb02
       LET l_vlc.vlc03 = g_today
       LET l_vlc.vlc04 = TIME
       LET l_vlc.vlc05 = 'van_file'
       CALL cl_getmsg('aps-797',g_lang) RETURNING l_str
       LET l_vlc.vlc06 = l_str,':',l_ecm.ecm01 CLIPPED
       CALL cl_getmsg('aps-791',g_lang) RETURNING l_str
       LET l_vlc.vlc06 = l_vlc.vlc06,' + ',l_str,':',l_ecm.ecm03 USING '<<<<'
       CALL cl_getmsg('aps-792',g_lang) RETURNING l_str
       LET l_vlc.vlc06 = l_vlc.vlc06,' + ',l_str,':',l_ecm.ecm04 CLIPPED
       LET l_vlc.vlc09 = '3'
       LET l_vlc.vlc10 = 'aeci700'
       LET l_vlc.vlc11 = tm.vlb03

       IF l_eca.eca06='1' AND l_ecm.ecm15=0 AND l_ecm.ecm16=0 THEN
          CALL cl_getmsg('aps-776',g_lang) RETURNING l_vlc.vlc07
          LET  l_vlc.vlc08 = 'aps-776'  
          INSERT INTO vlc_file(vlc00,vlc01,vlc02,vlc03,vlc04,vlc05,vlc06,vlc07,vlc08,vlc09,vlc10,vlc11)
            VALUES(l_vlc.vlc00,l_vlc.vlc01,l_vlc.vlc02,l_vlc.vlc03,l_vlc.vlc04,l_vlc.vlc05,l_vlc.vlc06,
                   l_vlc.vlc07,l_vlc.vlc08,l_vlc.vlc09,l_vlc.vlc10,l_vlc.vlc11)
       ELSE
          IF l_eca.eca06='2' AND l_ecm.ecm13=0 AND l_ecm.ecm14=0 THEN
             CALL cl_getmsg('aps-777',g_lang) RETURNING l_vlc.vlc07
             LET  l_vlc.vlc08='aps-777'
          INSERT INTO vlc_file(vlc01,vlc02,vlc03,vlc04,vlc05,vlc06,vlc07,vlc08,vlc09,vlc10,vlc11)
            VALUES(l_vlc.vlc01,l_vlc.vlc02,l_vlc.vlc03,l_vlc.vlc04,l_vlc.vlc05,l_vlc.vlc06,
                   l_vlc.vlc07,l_vlc.vlc08,l_vlc.vlc09,l_vlc.vlc10,l_vlc.vlc11)
          END IF        
       END IF   
       INITIALIZE l_ecm.* TO NULL 
       INITIALIZE l_eca.* TO NULL 
  END FOREACH  
  ###########################################################################

  ##委外製程#################################################################
  LET l_sql = "SELECT *    ",
              "  FROM ecm_file,vnd_file ",
              " WHERE ecm01 = '",p_sfb01,"'",
              "   AND ecm01=vnd01  ",
              "   AND ecm01=vnd02  ",
              "   AND ecm03=vnd03  ",
              "   AND ecm04=vnd04  ",
              "   AND vnd10='0'    ",
              "   AND ecm52 = 'Y' ",
              " ORDER BY ecm01,ecm03 "

  PREPARE p450_flow_p3 FROM l_sql
  DECLARE p450_flow_c3 CURSOR FOR p450_flow_p3
  INITIALIZE l_ecm.* TO NULL 
  INITIALIZE l_vnd.* TO NULL 
  FOREACH p450_flow_c3 INTO l_ecm.*, l_vnd.*
    IF SQLCA.sqlcode THEN EXIT FOREACH  END IF

       LET l_vlc.vlc00 = g_vlb00
       LET l_vlc.vlc01 = tm.vlb01
       LET l_vlc.vlc02 = tm.vlb02
       LET l_vlc.vlc03 = g_today
       LET l_vlc.vlc04 = TIME
       LET l_vlc.vlc05 = 'vbg_file'
       CALL cl_getmsg('aps-797',g_lang) RETURNING l_str
       LET l_vlc.vlc06 = l_str,':',l_ecm.ecm01 CLIPPED
       CALL cl_getmsg('aps-791',g_lang) RETURNING l_str
       LET l_vlc.vlc06 = l_vlc.vlc06,' + ',l_str,':',l_ecm.ecm03 USING '<<<<'
       CALL cl_getmsg('aps-792',g_lang) RETURNING l_str
       LET l_vlc.vlc06 = l_vlc.vlc06,' + ',l_str,':',l_ecm.ecm04 CLIPPED
       LET l_vlc.vlc09 = '3'
       LET l_vlc.vlc10 = 'apsi311'
       LET l_vlc.vlc11 = tm.vlb03

       IF l_vnd.vnd06=0 AND l_vnd.vnd11=0 THEN
          CALL cl_getmsg('aps-778',g_lang) RETURNING l_vlc.vlc07
          LET  l_vlc.vlc08 = 'aps-778'  
          INSERT INTO vlc_file(vlc00,vlc01,vlc02,vlc03,vlc04,vlc05,vlc06,vlc07,vlc08,vlc09,vlc10,vlc11)
            VALUES(l_vlc.vlc00,l_vlc.vlc01,l_vlc.vlc02,l_vlc.vlc03,l_vlc.vlc04,l_vlc.vlc05,l_vlc.vlc06,
                   l_vlc.vlc07,l_vlc.vlc08,l_vlc.vlc09,l_vlc.vlc10,l_vlc.vlc11)
       ELSE
          IF l_vnd.vnd06=3 AND (l_vnd.vnd08-l_vnd.vnd07) = 0 THEN
             CALL cl_getmsg('aps-779',g_lang) RETURNING l_vlc.vlc07
             LET  l_vlc.vlc08='aps-779'
          INSERT INTO vlc_file(vlc00,vlc01,vlc02,vlc03,vlc04,vlc05,vlc06,vlc07,vlc08,vlc09,vlc10,vlc11)
            VALUES(l_vlc.vlc00,l_vlc.vlc01,l_vlc.vlc02,l_vlc.vlc03,l_vlc.vlc04,l_vlc.vlc05,l_vlc.vlc06,
                   l_vlc.vlc07,l_vlc.vlc08,l_vlc.vlc09,l_vlc.vlc10,l_vlc.vlc11)
          END IF        
       END IF   
       INITIALIZE l_ecm.* TO NULL 
       INITIALIZE l_vnd.* TO NULL 
  END FOREACH
  ###########################################################################

END FUNCTION
#FUN-960167 ADD --END-----------------------------------------------

#TQC-990068 ---add----str----
FUNCTION p500_scan_log(p_result)    
   DEFINE p_result     STRING
   DEFINE l_file       STRING,              
          l_str        STRING,
          l_request    STRING
   DEFINE l_i          LIKE type_file.num10
   DEFINE channel      base.Channel

   LET channel = base.Channel.create()
  #FUN-B50161---mod---str---
  #LET l_file = fgl_getenv("TEMPDIR"), "/",
   LET l_file = fgl_getenv("TEMPDIR"), "/",g_plant CLIPPED,"-",
  #FUN-B50161---mod---end---
                 "apsp702-", TODAY USING 'YYYYMMDD', ".log"

   CALL channel.openFile(l_file, "a")  
   LET p_result = g_plant CLIPPED,":",p_result CLIPPED 
   
   IF STATUS = 0 THEN
       CALL channel.setDelimiter("")
       LET l_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
       CALL channel.write(l_str)
       CALL channel.write(p_result)        #090917
       CALL channel.write("")              #090917
   ELSE            
      #CHI-A70049 ---mod---str---
      #DISPLAY "Can't open log file."   
       IF g_bgjob = "N" OR cl_null(g_bgjob) THEN
           CALL cl_err("Can't open log file.",STATUS,1)
       END IF
      #CHI-A70049 ---mod---end---
   END IF
   CALL channel.close()
   RUN "chmod 666 " || l_file || " >/dev/null 2>&1"   
END FUNCTION
#TQC-990068 ---add----end----
