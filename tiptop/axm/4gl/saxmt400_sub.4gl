# Prog. Version..: '5.30.06-13.04.19(00010)'     #
#
# Program name...: saxmt400_sub.4gl
# Description....: 提供saxmt400.4gl使用的sub routine
# Date & Author..: 07/03/05 by kim (FUN-730002)
# Modify.........: No.FUN-730012 07/03/16 By kim 將確認段和過帳段移到saxmt400_sub.4gl
# Modify.........: No.TQC-730022 07/03/19 By rainy 整批確認調整
# Modify.........: No.FUN-730018 07/03/27 By kim 行業別架構
# Modify.........: No.FUN-740046 07/04/12 By rainy pmn94/95->pmn24/25
# Modify.........: NO.TQC-740111 07/04/19 BY yiting 參數設定(axms070) 設定確認不自動拋轉,不應再出現報表資訊，不用再印報表
# Modify.........: NO.TQC-740245 07/04/23 BY rainy 詢問"確認否"若按否則應g_success='N'
# Modify.........: No.MOD-740232 07/04/22 By claire 拋PO也要確認PR是否存在,拋PR也要確認PO是否存在
# Modify.........: No.MOD-740385 07/04/23 By Pengu 確認時Insert obk_file但資料有效否欄位卻為Null值
# Modify.........: No.MOD-740282 07/04/23 By rainy blanket po Ln#= null
# Modify.........: No.FUN-740016 07/05/07 By Nicola 借出管理
# Modify.........: No.TQC-740351 07/05/08 By Ray 拋轉請購單時單位應default采購單位
# Modify.........: No.FUN-740034 07/05/14 By kim 確認過帳不使用rowid,改用單號
# Modify.........: No.TQC-750152 07/05/30 By rainy 拋轉採購單，如單身的單位有更改，拋到採購單的數量計算錯誤
# Modify.........: No.TQC-720023 07/06/05 By Echo 若此單別勾選自動確認時，新增單據完成時應詢問使用者「是否確認」而不該直接執行確認段。 
# Modify.........: No.MOD-770033 07/08/08 By claire 拋請購單時ima913先default='N',避免料號為MISC沒有值
# Modify.........: No.MOD-780014 07/08/09 By claire EasyFlow執行時遇到axm-802會造成執行結果與原據狀況不符
#                                                                     axm-104 修改同上
# Modify.........: No.TQC-790002 07/09/03 By Sarah Primary Key：複合key在INSERT INTO table前需增加判斷，如果是NULL就給值blank(字串型態) or 0(數值型態)
# Modify.........: No.MOD-730044 07/09/27 By claire 交易單位(pmn86)與採購單位(ima44)或計價單位(ima908)的轉換
# Modify.........: No.MOD-7A0155 07/10/29 By claire 合約訂單的單身的已交數量應改為已訂數量, 並應由轉訂單後確認時回寫至合約訂單
# Modify.........: No.MOD-790148 07/10/30 By Pengu 若不使用計價單位當拋轉請購單時，其請購單上的計價位應與請購單位相同
# Modify.........: No.TQC-7C0103 07/12/08 By Unicorn 單身筆數超過參數設置的最大筆數，則不允許審核
# Modify.........: No.MOD-810181 08/01/24 By ve007 s_defprice 增加一個參數
# Modify.........: No.MOD-810063 08/01/25 By claire 拋轉的採購單,不可將多角序號帶入
# Modify.........: No.FUN-810045 08/02/15 By rainy 項目管理，拋請購/採購時應將項目相關欄位一併帶入
# Modify.........: No.FUN-7B0018 08/03/06 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-820033 08/03/14 By wujie  返利改善
# Modify.........: No.MOD-830126 08/03/17 By claire 拋轉的請購單,同一項次不會有分批狀況
# Modify.........: No.FUN-830132 08/03/27 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-840011 08/04/02 By saki 新增單身自定義欄位
# Modify.........: No.CHI-840016 08/04/16 By claire 拋轉的請購單,應調整可有項次拋轉,延續FUN-670007功能
# Modify.........: No.MOD-840197 08/04/20 By claire 業務員信用額度控管的功能,應調為在借出訂單控管
# Modify.........: No.MOD-840499 08/04/21 By claire 業務員信用額度控管的功能,應調為在借出訂單控管
# Modify.........: No.MOD-840644 08/04/24 By claire 回寫aqci150(obk11)應以訂單資料為主,不可再取ima24
# Modify.........: No.FUN-840128 08/04/28 By Carrier 拋轉"采購單"后,將采購單號及采購數量回寫oeb27/oeb28 & 插入pmn問題排除
# Modify.........: No.FUN-870033 08/07/08 By xiaofeizhu "拋轉請購單"項次欄位加入開窗,"拋轉采購單"加入項次欄位讓使用者用QBE的方式輸入條件
# Modify.........: No.MOD-860042 08/07/15 By Pengu 判斷p_oeb28若等NULL時則須default等於0
# Modify.........: No.MOD-870269 08/07/23 By Smapmin 未依照所選擇的訂單項次拋採購單
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.MOD-880038 08/08/06 By Smapmin 回寫合約單的已訂數量時,應考慮單位換算的問題
# Modify.........: No.MOD-880207 08/08/26 By chenl   拋轉采購單時，多角貿易欄位應不予賦值。
# Modify.........: No.MOD-890022 08/09/02 By Smapmin MOD-780014追單
# Modify.........: No.FUN-890128 08/10/07 By Vicky 確認段_chk()與異動資料_upd()若只需顯示提示訊息不可用cl_err()寫法,應改為cl_getmsg()
# Modify.........: No.MOD-8A0086 08/10/09 By Smapmin 拋轉請/採購單時,因為畫面上項次開窗q_oeb11有使用transaction,故將該段的transaction往後移
# Modify.........: No.MOD-8B0265 08/11/25 By wujie   拋轉請購單時，若對應的訂單和項次已在請購單中存在，則報錯
# Modify.........: No.MOD-8B0273 08/11/28 By chenyu 拋轉采購單時，單價和金額算法邏輯修改
# Modify.........: No.MOD-910210 09/01/17 By Smapmin 訂單轉請購單,請購單號項次錯誤
# Modify.........: No.CHI-910021 09/01/15 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.TQC-920112 09/02/27 By chenyu 審核的時候自動產生采購單不成功
# Modify.........: No.TQC-930021 09/03/03 By chenyu 多項次訂單拋轉采購單的時候，先拋轉幾個項次，剩下的項次無法再拋轉
# Modify.........: No.FUN-930148 09/03/26 By ve007 采購取價和定價
# Modify.........: No.MOD-920385 09/04/03 By Smapmin 拋轉採購時計價單位/數量有誤
# Modify.........: No.MOD-950006 09/05/05 By Smapmin 確認段UPDATE occ_file之前,要做lock的檢查,以避免資料被lock造成hold住無法確認
# Modfiy.........: No.TQC-950014 09/05/06 By chenyu 分項次拋轉采購單時，回寫單身以拋轉采購量錯誤，用采購單的項次作為了訂單項次，拋轉請購單也有同樣的問題
# Modify.........: No.TQC-960011 09/06/03 By lilingyu 當單別設為立即打印時,審核后才可以打印報表
# Modify.........: No.MOD-960013 09/06/08 By mike 於INSERT INTO pmn_file時,才LET l_pmn.pmn90 = l_pmn.pmn31
# Modify.........: No.MOD-960117 09/06/09 By mike 將tm.wc的長度調整成string 
# Modify.........: No.TQC-960155 09/06/23 By lilingyu axmt410在拋轉請購單時,出現-217的錯誤
# Modify.........: No.MOD-960202 09/07/08 By Smapmin 判斷是否有產生請購/採購單時,要過濾已作廢的請購/採購單
# Modify.........: No.MOD-970228 09/07/27 By Dido 確認段檢核多單位及數量不可為空 
# Modify.........: No.FUN-870007 09/07/27 By Zhangyajun 流通零售功能修改
# Modify.........: No.MOD-980177 09/08/22 By Smapmin 針對obk_file的異動,新增時檢驗否相關欄位來自於ima_file,修改時不異動
# Modify.........: No.TQC-980183 09/08/26 By xiaofeizhu 還原MOD-8B0273修改的內容
# Modify.........: No.FUN-980010 09/08/31 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No:MOD-9A0146 09/10/22 By Dido 若為簽核時給予 gi_ccc_logerr初始值  
# Modify.........: No:FUN-9B0023 09/11/02 By baofei 寫入請購單身時，也要一併寫入"電子採購否(pml92)"='N'
# Modify.........: NO.FUN-9B0039 09/11/05 By liuxqa substr 修改。
# Modify.........: No.TQC-9B0203 09/11/24 By douzh pmn58為NULL時賦初始值0
# Modify.........: No:TQC-9B0214 09/11/25 By Sunyanchun  s_defprice --> s_defprice_new
# Modify.........: No:FUN-960130 09/12/09 By Cockroach PASS NO.
# Modify.........: No:MOD-9C0377 09/12/23 By Pengu 修改業務信用額度超限錯誤訊息
# Modify.........: No:CHI-9C0060 10/01/04 By Smapmin INSERT INTO obk_file時,obk11 default 為'N'
# Modify.........: No:FUN-9C0073 10/01/07 By chenls 程序精簡
# Modify.........: No:MOD-A20119 10/03/01 By Smapmin 訂單要做拋轉採購單時，其訂單單號無法寫到採購單
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No:CHI-A50045 10/06/02 By Summer SO轉PO時,幣別pmm22應依供應商抓取
# Modify.........: No:FUN-A50103 10/06/03 By Nicola 訂單多帳期 1.取消訂單/尾款分期立帳欄位 2.增加訂單多帳期維護
# Modify.........: No:CHI-A50004 10/06/24 By Summer 在確認/取消確認時,將lock資料的動作往前移至FUNCTION的一開始
# Modify.........: No.FUN-A60076 10/07/02 By vealxu 製造功能優化-平行製程
# Modify.........: No:MOD-A50169 10/07/30 By Smapmin 於確認段再次判斷數量是否<=0或NULL
# Modify.........: No:FUN-A80012 10/08/02 By houlia "拋轉請購單"Action增加一個欄位“依BOM展開請購”
# Modify.........: No:CHI-A80006 10/08/13 By Summer 同一項次可分批拋轉請/採購
# Modify.........: No:FUN-A90059 10/09/27 By sabrina 拋轉請購單及採購時，計劃批號也要一併拋過去
# Modify.........: No.TQC-AA0099 10/10/22 By lilingyu 1.確認 action 時加入判別,若occ1028慣用折扣率<>空白或 Null或0時則需加入判斷折扣率不能低於慣用訂價折扣率
#                                                     2.折扣放行 action調整為"不判斷"折扣率不能低於慣用訂價折扣率,此功能主要提供有權限的人做放行使用.
# Modify.........: No:FUN-AA0048 10/10/28 By Carrier GP5.2架构下仓库权限修改
# Modify.........: No.FUN-AB0061 10/11/19 By vealxu 分攤折價計算方法調整
# Modify.........: No:TQC-AB0132 10/11/28 By wangxin BUG修改
# Modify.........: No:MOD-AB0249 10/12/03 By shiwuying 折扣輸入完畢確認時, 數量不可小於等於零.但折扣是不會輸入數量資料的.不應顯示此 error message
# Modify.........: No:TQC-AC0257 10/12/22 By suncx s_defprice_new.4gl返回值新增兩個參數
# Modify.........: No:TQC-AC0163 11/01/10 By shiwuying 現金折扣bug
# Modify.........: No:FUN-B10047 11/01/19 By wangxin 拋轉請購單中新增‘依BOM展開' 
# Modify.........: No:TQC-B30096 11/03/09 By zhangll pml91赋初值'N'
# Modify.........: No:MOD-B30439 11/03/17 By jan 修正sql語句
# Modify.........: No:MOD-B30116 11/03/18 By suncx 增加尾款金額的判斷
# Modify.........: No:MOD-B50152 11/05/25 By Summer 採購單由訂單拋轉過來,依據手動登打採購單時給預設值
# Modify.........: No:CHI-B70039 11/08/04 By joHung 金額 = 計價數量 x 單價
# Modify.........: No:CHI-B80050 11/09/09 By johung t400sub_y_upd增加參數p_inTransaction
# Modify.........: No:MOD-B90127 11/09/16 By suncx 將sapmp500中涉及創建臨時表的動作提至本程序創建
# Modify.........: No:FUN-910088 11/11/18 By fengrui 增加數量欄位小數取位
# Modify.........: No:FUN-B90101 11/11/23 By lixiang 轉採購和請購單時，增加服飾二維的處理（同步母料件的資料）
# Modify.........: No:FUN-BB0086 12/01/18 By tanxc 增加數量欄位小數取位
# Modify.........: No:TQC-BB0265 12/01/18 By Carrier default pmn89='N'
# Modify.........: No:FUN-BC0071 12/01/29 By huangtao 確認時check禮券或抵現積分
# Modify.........: No:FUN-C20006 12/02/03 By lixiang 服飾二維BUG修改
# Modify.........: No:MOD-C10218 12/02/08 By jt_chen 訂單轉請購單或訂單轉採購單,在作廢、作廢還原應更新訂單上的請購單號/採購單號、已轉請購量/採購量.
# Modify.........: No:MOD-BB0160 12/02/08 By Vampire 訂單拋轉採購單時,如果挑選到的單據帶出來的採購性質是SUB、TRI的話,改成給REG
# Modify.........: No:MOD-B90240 12/02/08 By Summer art-265需增加控卡結算方式為1現付客戶
# Modify.........: No:FUN-C10002 12/02/09 By bart 作業編號pmn78帶預設值
# Modify.........: No:TQC-BC0172 11/12/29 By destiny 抛转不存在的请采购单时，如果订单项次不存在要报错
# Modify.........: No:MOD-C30604 12/03/12 By dongsz 取消時不顯示成功信息
# Modify.........: No:MOD-C30368 12/03/12 By yuhuabao 取消拋轉時將訂單的原因碼賦值給請購或採購單的費用原因碼
# Modify.........: No:MOD-C30219 12/03/12 By yangxf  在合約編號不為空的情況下訂單確認時添加判斷合約編號是否是確認狀態
# Modify.........: No:TQC-C20362 12/03/12 By yuhuabao bug修改
# Modify.........: No.FUN-C40089 12/05/02 By bart 判斷銷售價格條件(axmi060)的oah08,若oah08為Y則單價欄位可輸入0;若oah08為N則單價欄位不可輸入0
# Modify.........: No.FUN-C50074 12/05/18 By bart 更改錯誤訊息代碼
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C50136 12/07/04 By xujing    根據oaz96判斷信用餘額管控處理方式
# Modify.........: No:FUN-C70045 12/07/12 By yangxf 单据类型调整
# Modify.........: No.FUN-C70098 12/07/25 By xjll  服飾流通二維，不可審核數量為零的母單身資料
# Modify.........: No.TQC-C60211 12/08/08 By zhuhao 審核時部門編號重新控管
# Modify.........: No:TQC-C80019 12/09/18 By SunLM 對訂單(含有備品)轉請購單的時候,提示是否生成備品資料axm-803
# Modify.........: No:FUN-C90102 12/10/31 By pauline 將lsn_file檔案類別改為B.基本資料,將lsnplant用lsnstore取代
# Modify.........: No:MOD-C90187 12/11/08 By jt_chen 調整單據編碼,顯示lock單別錯誤訊息
# Modify.........: No:MOD-CB0280 12/11/30 By jt_chen INSERT INTO obk_file處增加寫入錯誤訊息
# Modify.........: No:CHI-C90032 12/12/13 By pauline 單據確認時,若類別為借貨償價,並且來源為借貨出貨訂單,則不可再重複計算業務額度
# Modify.........: No:FUN-CC0082 12/12/28 By baogc 添加生產門店
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today
# Modify.........: No:FUN-D30007 13/03/04 By pauline 異動lpj_file時同步異動lpjpos欄位
# Modify.........: No:MOD-D30032 13/03/11 By Elise 代採逆拋尾站走一般流程,拋轉採購單axm-582的錯誤控卡請參考拋轉請購單axm-002的控卡,增加判斷項次
# Modify.........: No:MOD-C80218 13/03/12 By jt_chen FUNCTION t400sub_hu2中t400sub_cl2 cursor只有在有錯時才CLOSE
# Modify.........: No:CHI-C10037 13/03/22 By Elise s_sizechk.4gl目前只有判斷採購單位，應該要考慮單據單位
# Modify.........: No:MOD-D40031 13/04/09 By Vampire 調整將 MOD-D30032 的判斷移至 FOREACH ima_cur 裡
# Modify.........: No:160614 16/06/14 By guanyao 合约订单转工单的时候增加未转订单数

DATABASE ds
 
GLOBALS "../../config/top.global"

 
DEFINE g_pml RECORD LIKE pml_file.*      #No.TQC-740351
DEFINE g_pmn RECORD LIKE pmn_file.*      #MOD-920385
DEFINE g_oeb03 LIKE oeb_file.oeb03   #MOD-910210
DEFINE a LIKE type_file.chr1     #FUN-A80012
DEFINE g_oah08      LIKE oah_file.oah08  #FUN-C40089 
#{
#作用:訂單確認前的檢查
#p_oea01:本筆訂單的單號
#p_flag:最大折扣率判斷
#回傳值:無
#注意:以g_success的值來判斷檢查結果是否成功,IF g_success='Y' THEN 檢查成功 ; IF g_success='N' THEN 檢查有錯誤
#}
#start FUN-580155 #FUN-740034
FUNCTION t400sub_y_chk(p_flag,p_oea01)
  DEFINE p_oea01 LIKE oea_file.oea01
  DEFINE l_cnt      LIKE type_file.num5
  DEFINE p_flag     LIKE type_file.chr1
  DEFINE l_oea      RECORD LIKE oea_file.*
  DEFINE o_oea RECORD LIKE oea_file.*
  DEFINE l_oeb RECORD LIKE oeb_file.*,
         l_gift_amt LIKE oeb_file.oeb13,
         l_amt_sum  LIKE oea_file.oea1006,
         l_occ1028  LIKE occ_file.occ1028,
         l_rate     LIKE oea_file.oea1006,
         l_oeb1007  LIKE oeb_file.oeb1007,
         l_oeb1010  LIKE oeb_file.oeb1010,
         l_oeb14t   LIKE oeb_file.oeb14t,
         l_oeb14    LIKE oeb_file.oeb14,
         l_tqw07    LIKE tqw_file.tqw07,  
         l_tqw08    LIKE tqw_file.tqw08,  
         l_max      LIKE tqw_file.tqw07,  
         l_n        LIKE type_file.num5
   DEFINE l_oea61   LIKE oea_file.oea61   #No.FUN-740016
   DEFINE l_oea14   LIKE oea_file.oea14   #No.FUN-740016
   DEFINE l_ocn04   LIKE ocn_file.ocn04   #No.FUN-740016
   DEFINE l_oeb14t_1  LIKE oeb_file.oeb14t  #No.FUN-870007
   DEFINE l_occ72   LIKE occ_file.occ72   #No.FUN-870007
   DEFINE l_price   LIKE oeb_file.oeb14t  #No.FUN-870007
   DEFINE l_rxx04   LIKE rxx_file.rxx04   #No.FUN-870007
#  DEFINE l_oeb47   LIKE oeb_file.oeb47   #No.FUN-870007  #FUN-AB0061 
   DEFINE l_x1,l_x2 LIKE type_file.chr1   #MOD-970228                
   DEFINE l_oeb910  LIKE oeb_file.oeb910  #MOD-970228                
   DEFINE l_oeb912  LIKE oeb_file.oeb912  #MOD-970228                
   DEFINE l_msg,l_msg1,l_msg2  STRING	  #MOD-970228    
   DEFINE l_sql    STRING 		  #MOD-970228
   DEFINE l_oeaa08  LIKE oeaa_file.oeaa08    #No:FUN-A50103
   DEFINE l_oeb09   LIKE oeb_file.oeb09   #No.FUN-AA0048
   DEFINE l_oeb04_1 LIKE oeb_file.oeb04   #FUN-BC0071 add
   DEFINE l_tqp04   LIKE tqp_file.tqp04   #MOD-C30219 add
   DEFINE l_oebslk03     LIKE oebslk_file.oebslk03   #FUN-C70098
   DEFINE l_oebslk04     LIKE oebslk_file.oebslk04   #FUN-C70098
   DEFINE l_oebslk12     LIKE oebslk_file.oebslk12   #FUN-C70098
   DEFINE l_gemacti      LIKE gem_file.gemacti       #TQC-C60211 
   define l_imaud27     like ima_file.imaud27  #darcy:2023/11/06
   define l_imaud28     like ima_file.imaud28  #darcy:2024/02/19 add
   define l_zhuanjieban boolean   #darcy:2024/07/18 add 
 
   WHENEVER ERROR CONTINUE                #忽略一切錯誤  #FUN-730012

   LET g_success = 'Y'
   let l_zhuanjieban = false #darcy:2024/07/18 add

   IF cl_null(p_oea01) THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF
#CHI-C30107 -------------------- add --------------------- begin
   SELECT * INTO l_oea.* FROM oea_file WHERE oea01 = p_oea01
   IF l_oea.oeaconf = 'Y' THEN
      CALL cl_err('',9023,0)
      LET g_success = 'N'   #FUN-580155
      RETURN
   END IF

   IF l_oea.oeaconf = 'X' THEN
      CALL cl_err('',9024,0)
      LET g_success = 'N'   #FUN-580155
      RETURN
   END IF
   IF g_action_choice CLIPPED = "confirm" OR   #按「確認」時
      g_action_choice CLIPPED = "insert"  OR      
      g_action_choice CLIPPED = "discount_allowed" THEN
      IF NOT cl_confirm('axm-108') THEN
         LET g_success = 'N'   
         RETURN
      END IF
   END IF
#CHI-C30107 -------------------- add --------------------- end
   SELECT * INTO l_oea.* FROM oea_file WHERE oea01 = p_oea01
   IF l_oea.oeaconf = 'Y' THEN
      CALL cl_err('',9023,0)
      LET g_success = 'N'   #FUN-580155
      RETURN
   END IF

   IF l_oea.oeaconf = 'X' THEN
      CALL cl_err('',9024,0)
      LET g_success = 'N'   #FUN-580155
      RETURN
   END IF
#TQC-C60211 -- add -- begin
   SELECT gemacti INTO l_gemacti FROM gem_file
    WHERE gem01 = l_oea.oea15
   IF l_gemacti = 'N' THEN
      CALL cl_err(l_oea.oea15,'asf-472',0)
      LET g_success = 'N'
      RETURN
   END IF
#TQC-C60211 -- add -- end

#MOD-C30219 add begin ----
   IF l_oea.oea11 = '3' AND NOT cl_null(l_oea.oea12) THEN
      SELECT tqp04 INTO l_tqp04 
        FROM tqp_file 
       WHERE tqp01 = l_oea.oea12
      IF l_tqp04 <> '3' THEN
         CALL cl_err('','axm1140',0)
         LET g_success = 'N' 
         RETURN
      END IF  
   END IF 
#MOD-C30219 add end ------

   IF l_oea.oea00 != "2" AND cl_null(l_oea.oea32)  THEN
      CALL cl_err ('Receive Term Is Null','axm-317',0)
      LET g_success = 'N'   #FUN-580155
      RETURN
   END IF

   #MOD-B30116 add begin-------------------------
   IF l_oea.oea263 < 0 THEN
      CALL cl_err ('','axm1019',1)
      LET g_success = 'N'  
      RETURN
   END IF
   #MOD-B30116 add end---------------------------
  
   #No.FUN-AA0048  --Begin
   IF NOT s_chk_ware(l_oea.oea57) THEN
      LET g_success = 'N'
      RETURN
   END IF
   DECLARE t400sub_ware_cs1 CURSOR FOR
    SELECT oeb09 FROM oeb_file
     WHERE oeb01 = l_oea.oea01
   FOREACH t400sub_ware_cs1 INTO l_oeb09
       IF NOT s_chk_ware(l_oeb09) THEN
          LET g_success = 'N'
          RETURN
       END IF
   END FOREACH
   #No.FUN-AA0048  --End  

   #darcy:2023/04/19 add s---
   # 更新上次下单日期
   let l_sql = "MERGE INTO oeb_file a USING (
                SELECT a.oeb01,
                     a.oeb03,
                     a.oeb04,
                     (SELECT MAX(oea02)
                        FROM oea_file, oeb_file b
                        WHERE oea01 = b.oeb01
                        AND b.oeb04 = a.oeb04
                        AND oeaconf = 'Y'
                        AND b.oeb01 != a.oeb01 AND oea00='0') oebud13
               FROM oeb_file a
               WHERE a.oeb01 = ? ) b
               ON (a.oeb01=b.oeb01 AND a.oeb03=b.oeb03   )
               WHEN MATCHED THEN UPDATE SET a.oebud13 =b.oebud13"
   prepare t400_oebud13 from l_sql
   execute t400_oebud13 using p_oea01
   if status then
      call cl_err('exe t400_oebud13',status,1)
      let g_success = 'N'
      return
   end if
   # 判断是否含模切料

   let l_sql = " select count(1) from ( select bmb09 from bmb_file ",
               "  where bmb04 <= ? and (bmb05 is null or bmb05 > ?) ",
               "   start with bmb01 in  (select oeb04 from oeb_file where oeb01 = ? )",
               " connect by prior bmb03=bmb01) where bmb09 like 'M%'"
   prepare t400sub_moqie from l_sql
   let l_cnt = 0
   execute t400sub_moqie using g_today,g_today,p_oea01 into l_cnt

   if l_cnt > 0 then
      update oea_file set oeaud03 = 'Y'
       where oea01 = p_oea01
      if sqlca.sqlcode then
         call cl_err('upd oea_file',sqlca.sqlcode,1)
         let g_success = 'N'
         return
      end if
   end if

   #darcy:2023/04/19 add e---
   

   IF g_azw.azw04='2' THEN
      IF l_oea.oea85='1' THEN #MOD-B90240 add
         SELECT SUM(oeb14t) INTO l_oeb14t_1 FROM oeb_file 
          WHERE oeb01=l_oea.oea01 AND oeb70='N'  
         IF SQLCA.sqlcode=100 THEN LET l_oeb14t_1=NULL END IF
         IF cl_null(l_oeb14t_1) THEN LET l_oeb14t_1=0 END IF
   
   #FUN-AB0061 ----------------mark start----------------
   #     SELECT SUM(oeb47) INTO l_oeb47 FROM oeb_file
   #      WHERE oeb01=l_oea.oea01 AND oeb70='N' 
   #     IF cl_null(l_oeb47) THEN 
   #        LET l_oeb47=0 
   #     END IF
   #FUN-AB0061 ----------------mark end----------------
         SELECT azi04 INTO t_azi04 FROM azi_file 
          WHERE azi01=l_oea.oea23 
   #FUN-AB0061 ----------------mod start----------------
   #     IF l_oea.oea213 ='N' THEN
   #        LET l_oeb47=l_oeb47*(1+l_oea.oea211/100)
   #        CALL cl_digcut(l_oeb47,t_azi04) RETURNING l_oeb47
   #     END IF  
   #     LET l_price=(l_oeb14t_1-l_oeb47)*l_oea.oea161/100
         LET l_price=(l_oeb14t_1)*l_oea.oea161/100
   #FUN-AB0061 ---------------mod end----------------- 
         CALL cl_digcut(l_price,t_azi04) RETURNING l_price
   
         SELECT SUM(rxx04) INTO l_rxx04 FROM rxx_file
          WHERE rxx00='01' AND rxx01=l_oea.oea01 
            AND rxx03='1' AND rxxplant=l_oea.oeaplant
         IF SQLCA.sqlcode THEN 
            CALL cl_err('sel sum(rxx04)',status,0)
            LET l_rxx04=NULL 
         END IF
         IF cl_null(l_rxx04) THEN LET l_rxx04=0 END IF         
         IF l_rxx04<l_price THEN 
            CALL cl_err('','art-265',0)
            LET g_success='N'
            RETURN
         END IF 
      END IF #MOD-B90240 add
   END IF
    
   #無單身資料不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM oeb_file
    WHERE oeb01=l_oea.oea01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err(l_oea.oea01,'mfg-009',0)  #TQC-730022
      LET g_success = 'N'   #FUN-580155
      RETURN
   END IF

   #FUN-C70098----add----begin--------------
   IF s_industry("slk") AND g_azw.azw04 = '2' THEN
       DECLARE oebslk04_curs CURSOR FOR
          SELECT oebslk03,oebslk04,oebslk12 FROM oebslk_file WHERE oebslk01 = l_oea.oea01   
       CALL s_showmsg_init()
       FOREACH oebslk04_curs INTO l_oebslk03,l_oebslk04,l_oebslk12
           IF cl_null(l_oebslk12) OR l_oebslk12 = 0 THEN
              CALL s_errmsg('',l_oea.oea01 ,l_oebslk04 ,'asf-230',1)
              LET g_success = 'N'
           END IF
       END FOREACH
       CALL s_showmsg()
       IF g_success = 'N' THEN
          RETURN
       END IF
   END IF
   #FUN-C70098----add----end----------------
   #FUN-C40089---begin
   SELECT oah08 INTO g_oah08 FROM oah_file WHERE oah01=l_oea.oea31
   IF cl_null(g_oah08) THEN
      LET g_oah08 = 'Y'
   END IF 
   IF g_oah08= 'N' THEN
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM oeb_file
         WHERE oeb01=l_oea.oea01 AND oeb13=0
      IF l_cnt > 0 THEN
         CALL cl_err('','axm-627',1)  #FUN-C50074
         LET g_success = 'N'
         RETURN
      END IF
   END IF

   #FUN-C40089---end
   IF (l_oea.oea08='1' AND l_cnt > g_oaz.oaz681) OR
      (l_oea.oea08 MATCHES '[23]' AND l_cnt > g_oaz.oaz682) THEN
      CALL cl_err('','axm-158',0)
      LET g_success = 'N'   
      RETURN
   END IF
  
   IF l_oea.oea00 = '8' OR l_oea.oea00 = '9' THEN  #MOD-840197
      SELECT oea61*oea24,oea14 INTO l_oea61,l_oea14 FROM oea_file
       WHERE oea01=l_oea.oea01
      
      SELECT ocn04 INTO l_ocn04 FROM ocn_file
       WHERE ocn01 = l_oea14
      IF l_oea61 > l_ocn04 THEN
         CALL cl_err(l_oea14,'axm-112',1)
         LET g_success = "N"
         RETURN
      END IF
   END IF   #MOD-840197 add

#FUN-BC0071 -----------STA
    SELECT COUNT(*) INTO l_n  FROM oeb_file 
     WHERE oeb01 = l_oea.oea01
       AND oeb1001 = g_oaz.oaz88
     IF l_n > 0 THEN
       DECLARE l_oeb04_cur CURSOR FOR
        SELECT oeb04 FROM oeb_file
         WHERE oeb01= l_oea.oea01
           AND oeb1001 = g_oaz.oaz88
       FOREACH  l_oeb04_cur INTO l_oeb04_1 
          SELECT COUNT(*) INTO l_n FROM lpx_file,lqe_file,lqw_file
           WHERE lpx32 = l_oeb04_1 AND lpx01 = lqe02
             AND lqw08 = lqe02 AND lqw00 = '01'
              AND lqw01= p_oea01
              AND lqe01 BETWEEN lqw09 AND lqw10
              AND ((lqe17 NOT IN ('5','2') AND lqe13 = l_oea.oeaplant)
                 OR (lqe17 IN ('5','2') AND lqe13  <> l_oea.oeaplant))
           IF l_n > 0 THEN
              CALL s_errmsg("oeb04",l_oeb04_1,"",'alm1567',1)
              LET g_success = "N"
              CONTINUE FOREACH
           END IF
       END FOREACH
       IF g_success = "N" THEN
          RETURN
       END IF
     END IF
  

#FUN-BC0071 -----------END  
  
   IF g_aza.aza50 = 'Y' THEN
      DECLARE l_oeb1007_conf CURSOR FOR
       SELECT oeb1007,oeb14,oeb14t,oeb1010     
         FROM oeb_file
        WHERE oeb01=l_oea.oea01
          AND oeb1003='2'
          AND oeb1007 IS NOT NULL  #TQC-AC0163 Add
    
      FOREACH l_oeb1007_conf INTO l_oeb1007,l_oeb14,l_oeb14t,l_oeb1010
         SELECT COUNT(*) INTO l_n
           FROM tqw_file
          WHERE tqw01 = l_oeb1007
            AND tqw10 = '3'
            AND (abs(tqw07)-abs(tqw08)>=0)
            AND tqw17 = l_oea.oea23
            AND tqw05 = l_oea.oea03  
         IF l_n = 0 THEN
            CALL cl_err('','atm-028',0)
            LET g_success = 'N'  
            RETURN
         END IF

         SELECT tqw07,tqw08 INTO l_tqw07,l_tqw08 FROM tqw_file
          WHERE tqw01 =l_oeb1007
    
         LET l_max =l_tqw07 -l_tqw08
    
         IF l_oeb1010 ='Y' THEN
            IF l_max >= 0 THEN
               IF l_oeb14t >l_max OR l_oeb14t <= 0 THEN
                  CALL cl_err(l_oeb14t,'atm-031',1)
                  RETURN
               END IF
            ELSE
               IF l_oeb14t <l_max OR l_oeb14t <= 0 THEN
                  CALL cl_err(l_oeb14t,'atm-032',1)
                  RETURN
               END IF
            END IF
         ELSE
            IF l_max >= 0 THEN
               IF l_oeb14 >l_max OR l_oeb14 <= 0 THEN
                  CALL cl_err(l_oeb14,'atm-031',1)
                  RETURN
               END IF
            ELSE
               IF l_oeb14 <l_max OR l_oeb14 <= 0 THEN
                  CALL cl_err(l_oeb14,'atm-032',1)
                  RETURN
               END IF
            END IF
         END IF
      END FOREACH

      ##--最大折扣率判斷
      IF p_flag = '1' THEN
         LET l_gift_amt = 0
         
         DECLARE b_amt_conf CURSOR FOR
          SELECT * FROM oeb_file
           WHERE oeb01 = l_oea.oea01
             AND oeb1012 = 'Y'
             AND oeb1003!='2'

         OPEN b_amt_conf

         FOREACH b_amt_conf INTO l_oeb.*
            IF STATUS THEN
               CALL cl_err('foreach oeb',STATUS,0)   
               RETURN 
            END IF 
            IF l_oea.oea213='Y' THEN
                LET l_oeb.oeb13=l_oeb.oeb13*(1-l_oea.oea211/100)
            END IF
            IF g_sma.sma116 MATCHES '[23]' THEN   
               LET l_oeb.oeb12=l_oeb.oeb917
            END IF
            LET l_gift_amt = l_gift_amt+l_oeb.oeb13*l_oeb.oeb12
         END FOREACH

         LET l_amt_sum = l_gift_amt + l_oea.oea1006

         IF l_oea.oea61 = 0 THEN
            CALL cl_err('','atm-035',0)
            LET g_success = 'N'  
            RETURN
         END IF

         LET l_rate= l_amt_sum / l_oea.oea61*100
         SELECT occ1028 INTO l_occ1028 FROM occ_file
          WHERE occ01 = l_oea.oea03  
         IF NOT cl_null(l_occ1028) THEN
            IF l_rate>l_occ1028 THEN
               CALL cl_err('','atm-033',0)
               LET g_success = 'N'  
               RETURN
            END IF
         END IF
      END IF
   END IF

   IF g_sma.sma115= 'Y' THEN                                       
      LET l_x1 = "Y"                                                             
      LET l_x2 = "Y"                                                             

      LET l_sql="SELECT oeb910,oeb912 FROM oeb_file ",             
                " WHERE oeb01='",l_oea.oea01,"'",
                "   AND oeb1003='1' "                                 

      PREPARE pre_oeb FROM l_sql

      DECLARE oeb_curs CURSOR FOR pre_oeb                                       

      FOREACH oeb_curs INTO l_oeb910,l_oeb912                   
         IF cl_null(l_oeb910) THEN LET l_x1 = "N" END IF                         
         IF cl_null(l_oeb912) THEN LET l_x2 = "N" END IF                         
      END FOREACH                                                                

      IF l_x1 = "N" THEN                                                   
         #出貨單位欄位不可空白
         CALL cl_getmsg('asm-303',g_lang) RETURNING l_msg1                       
         CALL cl_getmsg('mfg0037',g_lang) RETURNING l_msg2                       
         LET l_msg = l_msg1 CLIPPED,l_msg2                                       
      END IF                                                                     

      IF l_x2 = "N" THEN                                                         
         #出貨數量欄位不可空白
         CALL cl_getmsg('asm-307',g_lang) RETURNING l_msg1                       
         CALL cl_getmsg('mfg0037',g_lang) RETURNING l_msg2                       
         LET l_msg = l_msg CLIPPED,l_msg1 CLIPPED,l_msg2                         
      END IF                                                                     

      IF NOT cl_null(l_msg) THEN                                                 
         CALL cl_msgany(10,20,l_msg)                                             
         LET g_success = 'N'                                                     
         RETURN                                                                  
      END IF                                                                     
   END IF       

   call s_showmsg_init()  #darcy:2024/02/19 add

   #-----MOD-A50169---------
   DECLARE b_amt_conf2 CURSOR FOR
    SELECT * FROM oeb_file
     WHERE oeb01 = l_oea.oea01
   OPEN b_amt_conf2
   FOREACH b_amt_conf2 INTO l_oeb.*
     #IF l_oeb.oeb12 <=0 OR cl_null(l_oeb.oeb12) THEN                              #MOD-AB0249
      IF (l_oeb.oeb12 <=0 OR cl_null(l_oeb.oeb12)) AND cl_null(l_oeb.oeb1007) THEN #MOD-AB0249
         CALL cl_err(l_oeb.oeb03,'mfg3348',0) 
         LET g_success = 'N'
         RETURN
      END IF
      #darcy:2023/05/31 add s---
      if l_oeb.oeb04 not matches "*.*" and l_oea.oea01 matches "MAP*" then
         let l_cnt = 0
         select count(1) into l_cnt from bma_file where bma01 = l_oeb.oeb04 and bma05 <= g_today and bma10 ='2'
         if l_cnt = 0 then
            CALL cl_err(l_oeb.oeb04,'amr-001',1) 
            LET g_success = 'N'
            RETURN
         end if
      end if
      #darcy:2023/11/06 add s---
      if g_prog  = "axmt400" then
         select imaud27 into l_imaud27 from ima_file
         where ima01 = l_oeb.oeb04
         if l_imaud27 = 'Y' then
            call cl_msgany(1,1,"cxm-041")
         end if
      end if
      #darcy:2023/11/06 add e---
      #darcy:2024/07/18 add s---
      if g_prog = "axmt410" then
         # axmt410 正式和约旦，无论单价是否为0，都需要核价信息
         if l_oeb.oeb13 = 0 or cl_null(l_oeb.oeb13) then
            let l_cnt = 0
            select count(*) into l_cnt from xme_file,xmf_file
            where xme01 = xmf01
               and xme02 = xmf02
               and ta_xme01 = ta_xmf02
               and xmf01 = l_oea.oea31
               and xmf02 = l_oea.oea23
               and xmf05 <= l_oea.oea02
               and xmf04 = l_oeb.oeb05
               and ta_xmf02 = l_oea.oea21
               and xmf03 = l_oeb.oeb04
               and xme00 = '1'
            if l_cnt = 0 then
               call s_errmsg("oea01,oeb03,oeb04,oeb13",sfmt("%1|%2|%3|%4",l_oea.oea01,l_oeb.oeb03,l_oeb.oeb04,l_oeb.oeb13),"",'cxm-043',1)
               let g_success = 'N'
            end if
         end if
      end if
      #darcy:2024/07/18 add e---
      if cl_null(l_oeb.oebud05) and l_oea.oea01 matches "MAP*" then
         CALL cl_err(l_oeb.oeb04,'cpm-030',1) 
         LET g_success = 'N'
         RETURN
      end if
      #darcy:2023/05/31 add e---
      #darcy:2024/02/19 add s---
      # 转接板提醒
      let l_imaud28 = ''
      select imaud28 into l_imaud28 from ima_file
       where ima01 = l_oeb.oeb04
      if not cl_null(l_imaud28) then
         let l_n = 0
         select count(*) into l_n from oeb_file
          where oeb01 = l_oea.oea01 and oeb04 = l_imaud28
         if l_n = 0 then
            let l_zhuanjieban = true #darcy:2024/07/18 add
            call s_errmsg("ima01,imaud28",l_oeb.oeb04||"|"||l_imaud28,"",'cxm-042',1)
         end if
      end if
      #darcy:2024/02/19 add e---
   END FOREACH
   #-----END MOD-A50169-----

   #darcy:2024/02/20 add s---
   call s_showmsg()  
   if l_zhuanjieban then
      if not cl_confirm('cxm-042') then
         let g_success = 'N'
         return
      end if
   end if
   #darcy:2024/02/20 add e---
   #-----No:FUN-A50103-----
   #訂金/出貨/尾款金額是否與訂單同
   IF l_oea.oea213 = 'Y' THEN
      IF (l_oea.oea261+l_oea.oea262+l_oea.oea263) <> l_oea.oea1008 THEN
         CALL cl_err(l_oea.oea01,'axm-967',1)
         LET g_success = 'N'                                                     
         RETURN                                                                  
      END IF
   ELSE
      IF (l_oea.oea261+l_oea.oea262+l_oea.oea263) <> l_oea.oea61 THEN
         CALL cl_err(l_oea.oea01,'axm-967',1)
         LET g_success = 'N'                                                     
         RETURN                                                                  
      END IF
   END IF
   
   #檢查訂金多帳期金額是否與訂金應收金額相同
   SELECT SUM(oeaa08) INTO l_oeaa08
     FROM oeaa_file
    WHERE oeaa01 = l_oea.oea01
      AND oeaa02 = '1'

   IF l_oeaa08 <> l_oea.oea261 THEN
      CALL cl_err(l_oea.oea261,'axm-961',1)
      LET g_success = 'N'                                                     
      RETURN                                                                  
   END IF

   #檢查訂金多帳期金額是否與訂金應收金額相同
   SELECT SUM(oeaa08) INTO l_oeaa08
     FROM oeaa_file
    WHERE oeaa01 = l_oea.oea01
      AND oeaa02 = '2'

   IF l_oeaa08 <> l_oea.oea263 THEN
      CALL cl_err(l_oea.oea263,'axm-961',1)
      LET g_success = 'N'                                                     
      RETURN                                                                  
   END IF
   #-----No:FUN-A50103 END-----

END FUNCTION
 
#{
#作用:lock cursor
#回傳值:無
#}
FUNCTION t400sub_lock_cl()
   DEFINE l_forupd_sql STRING
 
   LET l_forupd_sql = "SELECT * FROM oea_file WHERE oea01 = ? FOR UPDATE"
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)

   DECLARE t400sub_cl CURSOR FROM l_forupd_sql
   LET l_forupd_sql = "SELECT * FROM occ_file WHERE occ01 = ? FOR UPDATE"
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)

   DECLARE t400sub_cl2 CURSOR FROM l_forupd_sql

END FUNCTION
 
#{
#作用:訂單確認
#p_oea01:本筆訂單的單號
#p_action_choice:執行本函數時的Action Name(沒有的話傳NULL),不可直接使用全域變數g_action_chioce來做處理
#p_inTransaction : IF p_inTransaction=FALSE 會在程式中呼叫BEGIN WORK   #CHI-B80050
#l_oea:單頭
#回傳值:無
#注意:以g_success的值來判斷檢查結果是否成功,IF g_success='Y' THEN 執行成功 ; IF g_success='N' THEN 執行不成功
#     做完確認,要自行重新讀取oea_file(CALL t400sub_refresh()),本FUN不做refresh oea_file的動作
#}
#FUNCTION t400sub_y_upd(p_oea01,p_action_choice)                  #CHI-B80050 mark
FUNCTION t400sub_y_upd(p_oea01,p_action_choice,p_inTransaction)   #CHI-B80050
   DEFINE p_oea01         LIKE oea_file.oea01
   DEFINE l_oea           RECORD LIKE oea_file.*
   DEFINE p_action_choice STRING
   DEFINE l_cnt           LIKE type_file.num5
   DEFINE l_cmd           LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(60)
   DEFINE l_wc            LIKE type_file.chr1000 #No.FUN-650108  #No.FUN-680137 VARCHAR(200)
   DEFINE l_msg           LIKE type_file.chr1000
   DEFINE l_oeamksg       LIKE oea_file.oeamksg
   DEFINE l_oea49         LIKE oea_file.oea49
   DEFINE l_oea61         LIKE oea_file.oea61   #No.FUN-740016
   DEFINE l_oea14         LIKE oea_file.oea14   #No.FUN-740016
   DEFINE l_ocn03         LIKE ocn_file.ocn03   #No.FUN-740016
   DEFINE l_ocn04         LIKE ocn_file.ocn04   #No.FUN-740016
   DEFINE l_oayslip       LIKE oay_file.oayslip
   DEFINE l_oayprnt       LIKE oay_file.oayprnt
   DEFINE l_count         LIKE type_file.num5  
   DEFINE p_inTransaction LIKE type_file.num5   #CHI-B80050 add
 
   WHENEVER ERROR CONTINUE                #忽略一切錯誤  #FUN-730012

  #CHI-A50004 程式搬移 --start-- 
   IF NOT p_inTransaction THEN   #CHI-B80050 add
      BEGIN WORK
   END IF                        #CHI-B80050
   CALL t400sub_lock_cl()
   OPEN t400sub_cl USING p_oea01
   IF STATUS THEN
      CALL cl_err("OPEN t400sub_cl:", STATUS, 1)
      CLOSE t400sub_cl
     #ROLLBACK WORK                                      #CHI-B80050 mark
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF   #CHI-B80050
      LET g_success = 'N'                                #CHI-B80050
      RETURN
   END IF
  
   FETCH t400sub_cl INTO l_oea.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_oea.oea01,SQLCA.sqlcode,0)     # 資料被他人LOCK
     #CLOSE t400sub_cl ROLLBACK WORK RETURN   #CHI-B80050 mark
#CHI-B80050 -- begin --
      CLOSE t400sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET g_success = 'N'
      RETURN
#CHI-B80050 -- end --
   END IF
  #CHI-A50004 程式搬移 --end--
  
   LET g_success = 'Y'
   
   IF p_action_choice CLIPPED = "confirm" OR   #按「確認」時
      p_action_choice CLIPPED = "insert"  OR              #No.TQC-720023
      p_action_choice CLIPPED = "discount_allowed" THEN
      SELECT oeamksg,oea49 
        INTO l_oeamksg,l_oea49
        FROM oea_file
       WHERE oea01=p_oea01
      IF l_oeamksg='Y'   THEN #MOD-4A0299
         IF l_oea49 != '1' THEN
            CALL cl_err('','aws-078',1)
            LET g_success = 'N'
           #ROLLBACK WORK #CHI-A50004 add                      #CHI-B80050 mark
            IF NOT p_inTransaction THEN ROLLBACK WORK END IF   #CHI-B80050
            RETURN
         END IF
      END IF
#CHI-C30107 ----------------- mark --------------- begin
#     IF NOT cl_confirm('axm-108') THEN 
#        LET g_success = 'N'    #TQC-740245
#       #ROLLBACK WORK #CHI-A50004 add                      #CHI-B80050 mark
#        IF NOT p_inTransaction THEN ROLLBACK WORK END IF   #CHI-B80050
#        RETURN 
#     END IF
#CHI-C30107 ----------------- mark --------------- end
   END IF
  
   IF g_aza.aza41 = '1' THEN                                                                                                
      LET l_count = '3'                                                                                                     
   ELSE                                                                                                                     
      IF g_aza.aza41 = '2' THEN                                                                                         
         LET l_count = '4'                                                                                              
      ELSE                                                                                                              
         LET l_count = '5'                                                                                          
      END IF                                                                                                            
   END IF        
   LET  l_oayslip= p_oea01[1,l_count]                      #FUN-9B0039 mod
   SELECT oayprnt INTO l_oayprnt FROM oay_file
    WHERE oayslip = l_oayslip    
  
  #CHI-A50004 程式搬移至FUNCTION一開始 mark --start--
  #BEGIN WORK
  #CALL t400sub_lock_cl()
  #OPEN t400sub_cl USING p_oea01
  #IF STATUS THEN
  #   CALL cl_err("OPEN t400sub_cl:", STATUS, 1)
  #   CLOSE t400sub_cl
  #   ROLLBACK WORK
  #   RETURN
  #END IF
  # 
  #FETCH t400sub_cl INTO l_oea.*          # 鎖住將被更改或取消的資料
  #IF SQLCA.sqlcode THEN
  #   CALL cl_err(l_oea.oea01,SQLCA.sqlcode,0)     # 資料被他人LOCK
  #   CLOSE t400sub_cl ROLLBACK WORK RETURN
  #END IF
  #CHI-A50004 程式搬移至FUNCTION一開始 mark --end--


 
   LET g_success = 'Y'
#FUN-BC0071 -----------------STA
   CALL t400_upd_lqe(l_oea.*)
   IF g_success = 'Y' THEN
     CALL t400_ins_lsn(l_oea.*)
     IF g_success = 'Y' THEN
#FUN-BC0071 -----------------END
        CALL t400sub_y1(l_oea.*)
     END IF                           #FUN-BC0071 add
   END IF                             #FUN-BC0071 add
   IF g_success = 'Y' THEN
      IF g_aza.aza50 = 'Y' AND g_prog != 'axmt410' THEN #No.FUN-820033 by hellen
         CALL t400sub_tqw08_update(1,l_oea.*)   #FUN-610055
      END IF  #No.FUN-650108
      IF l_oea.oeamksg = 'Y' THEN #簽核模式
         CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
            WHEN 0  #呼叫 EasyFlow 簽核失敗
               LET l_oea.oeaconf="N"
               LET g_success = "N"
              #ROLLBACK WORK                                      #CHI-B80050 mark
               IF NOT p_inTransaction THEN ROLLBACK WORK END IF   #CHI-B80050
               RETURN
            WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
               LET l_oea.oeaconf="N"
              #ROLLBACK WORK                                      #CHI-B80050 mark
               LET g_success = 'N'                                #CHI-B80050 add
               IF NOT p_inTransaction THEN ROLLBACK WORK END IF   #CHI-B80050
               RETURN
         END CASE
      END IF
  
      SELECT COUNT(*) INTO l_cnt FROM oeb_file
       WHERE oeb01 = l_oea.oea01
      IF l_cnt = 0 AND l_oea.oeamksg = 'Y' THEN
         CALL cl_err(' ','aws-065',0)
         LET g_success = 'N'
  
      END IF
      IF g_success = 'Y' THEN
         SELECT oea61*oea24,oea14 INTO l_oea61,l_oea14 FROM oea_file
          WHERE oea01=l_oea.oea01
         CALL cl_digcut(l_oea61,g_azi04) RETURNING l_oea61     #CHI-C90032 add
         
        #在借貨出貨訂單確認時要扣除業務額度,
        #業務額度在借貨償價時,來源為借貨出貨單時不可再重複扣除
        #其他項目,像是一般訂單出貨單不會異動業務額度
         IF l_oea.oea00 = '8' OR (l_oea.oea00 = '9' AND l_oea.oea11 <> '8') THEN    #CHI-C90032 add
            SELECT ocn03,ocn04 INTO l_ocn03,l_ocn04 FROM ocn_file
             WHERE ocn01 = l_oea14
          
            LET l_ocn03 = l_ocn03+l_oea61
            LET l_ocn04 = l_ocn04-l_oea61
          
            IF l_ocn04 < 0 THEN
               CALL cl_err(l_oea14,'axm-112',1)   #No:MOD-9C0377 modify
               LET g_success="N"
            END IF
          
            UPDATE ocn_file SET ocn03 = l_ocn03,
                                ocn04 = l_ocn04
             WHERE ocn01 = l_oea14
         END IF     #CHI-C90032 add

         LET l_oea.oea49='1'             #執行成功, 狀態值顯示為 '1' 已核准  #FUN
         UPDATE oea_file SET oea49 = l_oea.oea49 WHERE oea01=l_oea.oea01
         IF SQLCA.sqlerrd[3]=0 THEN
            LET g_success='N'
         END IF
         LET l_oea.oeaconf='Y'           #執行成功, 確認碼顯示為 'Y' 已確認
         DISPLAY BY NAME l_oea.oeaconf   #FUN-580155
         DISPLAY BY NAME l_oea.oea49     #FUN-580155
         IF g_azw.azw04='2' THEN
            LET l_oea.oeaconu=g_user
            DISPLAY BY NAME l_oea.oeaconu
         END IF
        #COMMIT WORK                                      #CHI-B80050 mark
         IF NOT p_inTransaction THEN COMMIT WORK END IF   #CHI-B80050
         CALL cl_flow_notify(l_oea.oea01,'Y')
         DISPLAY BY NAME l_oea.oeaconf
      ELSE
         LET l_oea.oeaconf = 'N'
        #ROLLBACK WORK                                      #CHI-B80050 mark
         LET g_success = 'N'                                #CHI-B80050
         IF NOT p_inTransaction THEN ROLLBACK WORK END IF   #CHI-B80050
         RETURN                                             #CHI-B80050
      END IF
   ELSE
     #LET l_oea.oeaconf='N' ROLLBACK WORK   #CHI-B80050 mark
#CHI-B80050 -- begin --
     LET l_oea.oeaconf='N'
     LET g_success = 'N'
     IF NOT p_inTransaction THEN ROLLBACK WORK END IF
     RETURN
#CHI-B80050 -- end --
   END IF
  #因有可能尚未確認則先印表(印表即會先拋轉)
  IF l_oea.oea901 = 'Y' AND g_success = 'Y' THEN
#判斷參數是否於確認時自動拋轉，是才拋，不是就不拋
       IF g_oax.oax07 = 'Y' THEN
           #拋轉至各廠
           LET l_cmd="axmp800 '",l_oea.oea01,"' '",l_oea.oea905,"' "
           CALL cl_cmdrun_wait(l_cmd)
           LET l_oea.oea905='Y'    
 
           #若是背景執行，則不產生報表(Ex: EasyFlow簽核，自動跑確認段)
           IF g_bgjob='N' OR cl_null(g_bgjob) THEN  #No.FUN-640248
              #列印三角貿易S/O
                   LET l_wc='oea01="',l_oea.oea01,'"'                                                                                           
                   LET l_msg = "axmr830",                                                                                                       
                       " '",g_today CLIPPED,"' ''",                                                                                             
                       " '",g_lang CLIPPED,"' 'Y' '' '1'",                                                                                      
                       " '",l_wc CLIPPED,"' "
               IF l_oayprnt = 'Y' THEN                 #TQC-960011                  
                  CALL cl_cmdrun_wait(l_msg)
               END IF                                  #TQC-960011   
               #列印三角貿易P/O
                   LET l_wc='oea01="',l_oea.oea01,'"'                                                                                           
                   LET l_msg = "axmr820",                                                                                                       
                       " '",g_today CLIPPED,"' ''",                                                                                             
                       " '",g_lang CLIPPED,"' 'Y' '' '1'",                                                                                      
                       " '",l_wc CLIPPED,"' " 
               IF l_oayprnt = 'Y' THEN                 #TQC-960011                  
                  CALL cl_cmdrun_wait(l_msg)
               END IF                                  #TQC-960011   
               END IF  #No.FUN-640248
       END IF   #NO.TQC-740111
  END IF
END FUNCTION
 
#{
#作用:訂單確認
#l_oea:本筆訂單的data
#回傳值:無
#注意:以g_success的值來判斷檢查結果是否成功,IF g_success='Y' THEN 執行成功 ; IF g_success='N' THEN 執行不成功
#}
FUNCTION t400sub_y1(l_oea)
 DEFINE l_oea   RECORD LIKE oea_file.*
 DEFINE l_oeb17 LIKE oeb_file.oeb17
 DEFINE l_msg   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(100)
 DEFINE l_oeb   RECORD LIKE oeb_file.*
 
   LET l_oea.oea72=TODAY 
   IF l_oea.oeamksg = 'N' AND
      l_oea.oeaconf = 'N' AND l_oea.oea49 = '0'  THEN
      LET l_oea.oea49 = '1'     #已核淮
   END IF
   LET l_oea.oeaconu = g_user  #No.FUN-870007
   LET l_oea.oeacont = TIME    #No.FUN-870007
   UPDATE oea_file SET oeaconf='Y',
                       oeaconu=l_oea.oeaconu,   #No.FUN-870007
                       oeacont=l_oea.oeacont,   #No.FUN-870007
                       oea72=l_oea.oea72,
                       oea49=l_oea.oea49
    WHERE oea01 = l_oea.oea01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","oea_file",l_oea.oea01,"",SQLCA.sqlcode,"","upd oeaconf",1)  #No.FUN-650108
      LET g_success = 'N'
      RETURN
   END IF
 
   CALL t400sub_hu1(l_oea.*) IF g_success = 'N' THEN RETURN END IF  #客戶信用查核    
   CALL t400sub_hu2(l_oea.*) IF g_success = 'N' THEN RETURN END IF  #最近交易更新
 
   DECLARE t400sub_y1_c CURSOR FOR
      SELECT * FROM oeb_file WHERE oeb01 = l_oea.oea01 ORDER BY oeb03
 
   FOREACH t400sub_y1_c INTO l_oeb.*
      IF STATUS THEN
         CALL cl_err('y1 foreach',STATUS,1)  
         LET g_success='N'
         RETURN
      END IF
      # 檢查訂單單價是否低於取出單價(合約訂單不卡)
      IF l_oea.oea00 != '0' THEN
         LET l_oeb17 = l_oeb.oeb17 * (100-g_oaz.oaz185) / 100
         LET l_oeb17 = cl_digcut(l_oeb17,t_azi03)      #No.CHI-6A0004
         IF l_oeb.oeb13 < l_oeb17 THEN
            LET l_msg = 'Seq.:',l_oeb.oeb03 USING '&&&',' Item:',l_oeb.oeb04
            CASE g_oaz.oaz184
               WHEN 'R'
                  CALL cl_err(l_msg CLIPPED,'axm-802',1)
                  LET g_success ='N'
                  EXIT FOREACH
               WHEN 'W'
                  LET l_msg = cl_getmsg('axm-802',g_lang)
                  LET l_msg=l_msg CLIPPED,'Seq.:',l_oeb.oeb03 USING '&&&',' Item:',l_oeb.oeb04
                  CALL cl_msgany(10,20,l_msg)
               WHEN 'N'
                  EXIT CASE
            END CASE
         END IF
      END IF
      CALL t400sub_bu1(l_oea.*,l_oeb.*) IF g_success = 'N' THEN RETURN END IF #更新合約已轉訂單量
      CALL t400sub_bu2() IF g_success = 'N' THEN RETURN END IF #更新?
      CALL t400sub_bu3(l_oea.*,l_oeb.*) IF g_success = 'N' THEN RETURN END IF #更新產品客戶
      CALL t400sub_bu4() IF g_success = 'N' THEN RETURN END IF #更新產品價格
   END FOREACH
END FUNCTION
 
FUNCTION t400sub_hu1(l_oea)		#客戶信用查核
   DEFINE l_oea RECORD LIKE oea_file.*
   DEFINE l_msg LIKE type_file.chr1000    #MOD-780014 add
#  DEFINE l_oia07 LIKE oia_file.oia07     #FUN-C50136 add
   CALL cl_msg("hu1!")          #No.FUN-640248
   IF l_oea.oea00='0' OR l_oea.oea00="A" THEN RETURN END IF   #No.FUN-610053
   IF g_oaz.oaz122 MATCHES "[12]" THEN
      IF l_oea.oeamksg = 'Y' THEN
         CALL s_ccc_logerr()  
      END IF
#     IF g_oaz.oaz96 = 'N' THEN                      #FUN-C50136 add
         CALL s_ccc(l_oea.oea03,'2',l_oea.oea01)    # Customer Credit Check 客戶信用查核 
      #FUN-C50136#add##str
#     ELSE                    
#        CALL s_ccc_oia07('A',l_oea.oea03) RETURNING l_oia07
#        IF NOT cl_null(l_oia07) AND l_oia07 = '0' THEN
#           CALL s_ccc_oia(l_oea.oea03,'A',l_oea.oea01,0,'') 
#        END IF                                
#     END IF                                           
#     #FUN-C50136##add##end 
      IF g_errno = 'N' THEN
         IF g_oaz.oaz122 = '1'
            THEN # CALL cl_err('ccc','axm-104',1)           #MOD-780014 mark 
                   LET l_msg = cl_getmsg('axm-104',g_lang)  #MOD-780014 add
                   CALL cl_msgany(10,20,l_msg)              #MOD-780014 add
                 LET l_oea.oeahold=g_oaz.oaz11
                 DISPLAY BY NAME l_oea.oeahold
                 UPDATE oea_file SET oeahold=l_oea.oeahold
                        WHERE oea01=l_oea.oea01
            ELSE CALL cl_err('ccc','axm-106',0)
                 LET g_success = 'N' RETURN
         END IF
      END IF
   END IF
   CALL cl_msg("")              #No.FUN-640248 
END FUNCTION
 
FUNCTION t400sub_hu2(l_oea)		#最近交易日
   DEFINE l_occ RECORD LIKE occ_file.*
   DEFINE l_oea RECORD LIKE oea_file.*
   CALL cl_msg("hu2!")          #No.FUN-640248 
   OPEN t400sub_cl2 USING l_oea.oea03 
   IF STATUS THEN
      CALL cl_err("OPEN t400sub_cl2:", STATUS, 1)
      CLOSE t400sub_cl2
      LET g_success = 'N'
      RETURN
   END IF
   FETCH t400sub_cl2 INTO l_occ.*      
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_occ.occ01,SQLCA.sqlcode,0)    
      CLOSE t400sub_cl2 
      LET g_success = 'N'
      RETURN
   END IF
   IF l_occ.occ16 IS NULL THEN LET l_occ.occ16=l_oea.oea02 END IF
   IF l_occ.occ172 IS NULL OR l_occ.occ172 < l_oea.oea02 THEN
      LET l_occ.occ172=l_oea.oea02
   END IF
 
   UPDATE occ_file SET * = l_occ.* WHERE occ01=l_oea.oea03     #FUN-610055
   IF STATUS THEN
      CALL cl_err3("upd","occ_file",l_oea.oea03,"",STATUS,"","u occ",1)  #No.FUN-650108
      CLOSE t400sub_cl2   #MOD-950006
      LET g_success = 'N'
      RETURN
   END IF
 
   CLOSE t400sub_cl2            #MOD-C80218 add
   CALL cl_msg("")              #No.FUN-640248 
 
END FUNCTION
 
FUNCTION t400sub_bu1(l_oea,l_oeb) 				#合約已轉訂單量更新
   DEFINE l_oea RECORD LIKE oea_file.*
   DEFINE l_oeb RECORD LIKE oeb_file.*
   DEFINE l_tot LIKE oeb_file.oeb14
   DEFINE l_oeb05_1 LIKE oeb_file.oeb05  
   DEFINE l_oeb04 LIKE oeb_file.oeb04    
   DEFINE l_oeb05 LIKE oeb_file.oeb05    
   DEFINE l_oeb12 LIKE oeb_file.oeb12    
   DEFINE l_cnt   LIKE type_file.num5
   DEFINE l_factor LIKE ima_file.ima31_fac 
 
   CALL cl_msg("bu1!")          #No.FUN-640248 
 
   IF l_oea.oea11 = '3' THEN #MOD-6A0171 mark OR l_oea.oea11="A" THEN   #No.FUN-610053
      DECLARE oeb12_cs CURSOR FOR
        SELECT oeb04,oeb05,oeb12 FROM oea_file,oeb_file  
         #WHERE oea12 = l_oea.oea12 AND oea00 IN ('1','3','4','6','7')    #mark by guanyao160719
         WHERE oebud02 = l_oeb.oebud02 AND oea00 IN ('1','3','4','6','7')   #add by guanyao160719
           AND oeaconf = 'Y'
           AND oea01 = oeb01
           AND oeb71 = l_oeb.oeb71
      LET l_oeb05_1 = ''
      SELECT oeb05 INTO l_oeb05_1 FROM oeb_file
       # WHERE oeb01 = l_oea.oea12  #mark by guanyao160719
        WHERE oeb01 = l_oeb.oebud02 #add by guanyao160719
          AND oeb03 = l_oeb.oeb71
      LET l_tot = 0 
      FOREACH oeb12_cs INTO l_oeb04,l_oeb05,l_oeb12
        CALL s_umfchk(l_oeb04,l_oeb05,l_oeb05_1) RETURNING l_cnt,l_factor 
        IF l_cnt = 1 THEN LET l_factor = 1 END IF
        LET l_tot = l_tot + (l_oeb12 * l_factor)
      END FOREACH
      IF cl_null(l_tot) THEN
         LET l_tot = 0
      ELSE 
         LET l_tot =s_digqty(l_tot ,l_oeb.oeb05)  #FUN-910088 add
      END IF
 
      UPDATE oeb_file SET oeb24 = l_tot,
                          oebud08 = oeb12-l_tot   #add by guanyao160614
       #WHERE oeb01 = l_oea.oea12   #mark by guanyao160719
       WHERE oeb01 = l_oeb.oebud02  #add by guanyao160719
         AND oeb03 = l_oeb.oeb71
 
      IF STATUS OR SQLCA.SQLCODE THEN
         #LET g_showmsg=l_oea.oea12,"/",l_oeb.oeb71                 #No.FUN-710046  #mark by guanyao160719
         LET g_showmsg=l_oeb.oebud02,"/",l_oeb.oeb71       #add by guanyao160719
         CALL s_errmsg("oeb01,oeb03",g_showmsg,"UPD oeb_file",SQLCA.sqlcode,1)  #No.FUN-710046
         LET g_success = 'N'
         RETURN
      END IF
   END IF
 
   CALL cl_msg("")                    #No.FUN-640248 
 
END FUNCTION
 
FUNCTION t400sub_bu2()
 
   CALL cl_msg("bu2!")                #No.FUN-640248 
   CALL cl_msg("")                    #No.FUN-640248
 
END FUNCTION
 
FUNCTION t400sub_bu3(l_oea,l_oeb) 				#更新產品客戶
   DEFINE l_oea     RECORD LIKE oea_file.*
   DEFINE l_oeb     RECORD LIKE oeb_file.*
   DEFINE l_fac     LIKE ima_file.ima31_fac       #單位換算率 #MOD-540201 add                                                      
   DEFINE l_ima31   LIKE ima_file.ima31           #銷售單位   #MOD-540201 add                                                      
   DEFINE l_rate    LIKE oea_file.oea24           #匯率       #MOD-540201 add                                                      
   DEFINE l_ima33   LIKE ima_file.ima33           #最近售價   #MOD-540201 add                                                      
   DEFINE l_check   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)  #MOD-540201 add
   DEFINE l_obk11   LIKE obk_file.obk11           #TQC-6A0045 add                                                      
   DEFINE l_obk12   LIKE obk_file.obk12           #TQC-6A0045 add                                                      
   DEFINE l_obk13   LIKE obk_file.obk13           #TQC-6A0045 add                                                      
   DEFINE l_obk14   LIKE obk_file.obk14           #TQC-6A0045 add                                                      
   DEFINE l_obkacti LIKE obk_file.obkacti         #No.MOD-740385 add
   DEFINE l_exT     LIKE type_file.chr1
   CALL cl_msg("bu3!")                #No.FUN-640248 
      #MOD-540201----------------------add                                                                                          
      #更新料件主檔的最近售價ima33                                                                                                  
      #==>單位轉換                                                                                                                  
      SELECT ima31 INTO l_ima31 FROM ima_file                                                                                       
       WHERE ima01= l_oeb.oeb04                                                                                                     
      IF l_oeb.oeb05 =l_ima31 THEN                                                                                                  
          LET l_fac = 1                                                                                                             
      ELSE                                                                                                                          
          CALL s_umfchk(l_oeb.oeb04,l_oeb.oeb05,l_ima31)                                                                            
               RETURNING l_check,l_fac                                                                                              
      END IF                                                                                                                        
      #==>幣別匯率轉換                                                                                                              
      IF l_oea.oea23 =g_aza.aza17 THEN                                                                                              
          LET l_rate =1                                                                                                             
      ELSE                                                                                                                          
          IF l_oea.oea08='1' THEN                                                                                                   
             LET l_exT=g_oaz.oaz52                                                                                                    
          ELSE                                                                                                                      
             LET l_exT=g_oaz.oaz70                                                                                                    
          END IF                                                                                                                    
          CALL s_curr3(l_oea.oea23,l_oea.oea02,l_exT)
                      RETURNING l_rate                                                                                              
      END IF                                                                                                                        
      #==>更新料件主檔的最近售價                                                                                                    
      LET l_ima33 = (l_oeb.oeb13/l_fac) * l_rate                                                                                    
      CALL cl_digcut(l_ima33,t_azi03)RETURNING l_ima33     #No.CHI-6A0004
      UPDATE ima_file                                                                                                               
         SET ima33 = l_ima33,
             imadate = g_today     #FUN-C30315 add                                                                                                        
       WHERE ima01 = l_oeb.oeb04                                                                                                    
       #MOD-540201----------------------(end)
 
      IF g_oaz.oaz44 = 'Y' THEN
         LET l_obk11= 'N'
         LET l_obkacti = 'Y'      #No.MOD-740385 add
         UPDATE obk_file SET obk03=l_oeb.oeb11,
                             obk04=l_oea.oea02,
                             obk05=l_oea.oea23,
                             obk06=l_oea.oea21,
                             obk07=l_oeb.oeb05,
                             obk08=l_oeb.oeb13,
                             obk09=l_oeb.oeb12 
         WHERE obk01 = l_oeb.oeb04
           AND obk02 = l_oea.oea03    #FUN-610055
           AND obk05 = l_oea.oea23      #No.FUN-670099
         IF SQLCA.SQLERRD[3] = 0 THEN
           INSERT INTO obk_file (obk01,obk02,
                                 obk03,obk04,obk05,obk06,obk07,obk08,obk09,
                                 obk11,obkacti)  #CHI-9C0060
           VALUES (l_oeb.oeb04,l_oea.oea03,   #FUN-610055
                   l_oeb.oeb11,l_oea.oea02,l_oea.oea23,l_oea.oea21,
                   l_oeb.oeb05, l_oeb.oeb13, l_oeb.oeb12,
                   l_obk11,l_obkacti)        #TQC-6A0045 add     #No.MOD-740385 add   #CHI-9C0060
           #MOD-CB0280 -- add start --
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
              LET g_showmsg = l_oeb.oeb04,"/",l_oea.oea03
              CALL s_errmsg("obk01,obk02",g_showmsg,"INS obk_file",SQLCA.sqlcode,1)
              LET g_success = 'N'
              RETURN
           END IF
           #MOD-CB0280 -- add end --
         END IF
      END IF
   CALL cl_msg("")                    #No.FUN-640248
 
END FUNCTION
 
FUNCTION t400sub_bu4() 				#更新產品價格
   CALL cl_msg("bu4!")                #No.FUN-640248                                                                     
   CALL cl_msg("")                    #No.FUN-640248
 
END FUNCTION
 
FUNCTION t400sub_tqw08_update(p_code,l_oea)
DEFINE  t_oeb      RECORD LIKE oeb_file.*,
        p_code     LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE  l_oea      RECORD LIKE oea_file.*
   DECLARE oeb_conf CURSOR FOR
    SELECT * FROM oeb_file
     WHERE oeb01 = l_oea.oea01
       AND oeb1003='2'
    OPEN oeb_conf
    FOREACH oeb_conf INTO t_oeb.*
      IF STATUS THEN
         CALL cl_err('foreach oeb',STATUS,0)
         LET g_success = 'N'   #FUN-890128
         RETURN 
      END IF  
      IF p_code=1 THEN                                                                                                              
         IF t_oeb.oeb1010='N' THEN                                                                                                  
            UPDATE tqw_file SET tqw08=tqw08+t_oeb.oeb14                                                                             
             WHERE tqw01=t_oeb.oeb1007                                                                                              
         ELSE                                                                                                                       
            UPDATE tqw_file SET tqw08=tqw08+t_oeb.oeb14t                                                                            
             WHERE tqw01=t_oeb.oeb1007                                                                                              
         END IF                                                                                                                     
      ELSE                                                                                                                          
         IF t_oeb.oeb1010='N' THEN                                                                                                  
            UPDATE tqw_file SET tqw08=tqw08-t_oeb.oeb14                                                                             
             WHERE tqw01=t_oeb.oeb1007                                                                                              
         ELSE                                                                                                                       
            UPDATE tqw_file SET tqw08=tqw08-t_oeb.oeb14t                                                                            
             WHERE tqw01=t_oeb.oeb1007                                                                                              
         END IF                                                                                                                     
      END IF  
    END FOREACH
END FUNCTION
 
FUNCTION t400sub_refresh(p_oea01)
  DEFINE p_oea01 LIKE oea_file.oea01
  DEFINE l_oea RECORD LIKE oea_file.*
 
  SELECT * INTO l_oea.* FROM oea_file WHERE oea01 = p_oea01
  RETURN l_oea.*
END FUNCTION
 
 
# 拋轉P/O
FUNCTION t400sub_exp_po(p_oea01,p_tag,p_buf)   #TQC-730022
  DEFINE p_oea01  LIKE oea_file.oea01,   #TQC-730022
         p_tag    LIKE type_file.chr1,   #TQC-730022
         l_buf    LIKE oay_file.oayslip, #TQC-730022
         p_buf    LIKE oay_file.oayslip  #TQC-730022
  DEFINE l_pmm  RECORD LIKE pmm_file.*     #TQC-730022
  DEFINE l_pmm01  LIKE pmm_file.pmm01,
         l_oea40  LIKE oea_file.oea40
  DEFINE l_oeb01  LIKE oeb_file.oeb01
  DEFINE l_oeb03  LIKE oeb_file.oeb03
  DEFINE l_oeb12  LIKE oeb_file.oeb12
  DEFINE l_oeb28  LIKE oeb_file.oeb28
  DEFINE l_sql    STRING 
  DEFINE l_cnt    LIKE type_file.num5 
  DEFINE li_cnt   LIKE type_file.num5
  DEFINE l_ima54  LIKE ima_file.ima54
  DEFINE tm RECORD
         wc       STRING,                  #MOD-960117  
         oeb03    LIKE oeb_file.oeb03,     #FUN-870033
         slip     LIKE oay_file.oayslip  
         END RECORD 
  DEFINE l_pmm01_conf DYNAMIC ARRAY OF  LIKE pmm_file.pmm01  #TQC-730022
  DEFINE l_i,l_n      LIKE type_file.num5  #TQC-730022
  DEFINE l_gfa   RECORD LIKE gfa_file.*    #TQC-730022 
  DEFINE l_oea   RECORD LIKE oea_file.*
  DEFINE l_slip  LIKE oay_file.oayslip
  DEFINE p_row,p_col LIKE type_file.num5
  DEFINE l_prog_t STRING
  DEFINE l_oeb04  LIKE oeb_file.oeb04  #CHI-A80006 add
  DEFINE l_oeb05  LIKE oeb_file.oeb05  #CHI-A80006 add
  DEFINE l_ima25  LIKE ima_file.ima25  #CHI-A80006 add
  DEFINE l_ima44  LIKE ima_file.ima44  #CHI-A80006 add
  DEFINE l_flag   LIKE type_file.num5  #CHI-A80006 add
  DEFINE l_fac    LIKE img_file.img21  #CHI-A80006 add
  DEFINE l_t      LIKE type_file.num5  #TQC-BC0172 add
  DEFINE li_result LIKE type_file.num5 #MOD-C90187 add
 
  WHENEVER ERROR CONTINUE                #忽略一切錯誤  #FUN-730018
 
    #重新讀取資料
    SELECT * INTO l_oea.* FROM oea_file
     WHERE oea01=p_oea01
    IF p_tag = 'A' THEN  #由自動拋轉CALL 的
      #截取單據別
      LET l_buf = s_get_doc_no(l_oea.oea01)
      #取自動化設定值
      SELECT * INTO l_gfa.*  FROM gfa_file
        WHERE gfa01 = '1'   #1:axmt410
          AND gfa02 = l_buf
          AND gfa03 = 'apmt540'
          AND gfaacti = 'Y'
      IF cl_null(l_gfa.gfa05) THEN RETURN END IF  #如果無設定單據自動化的資料就不再往下執行
    END IF
  
   IF l_oea.oea49 = '2' THEN CALL cl_err('','Transfer to PO not allowed!',0)  RETURN END IF   #TQC-AB0132 add
   IF cl_null(l_oea.oea01) THEN RETURN END IF
   IF l_oea.oea00 = '0' AND l_oea.oea00="A" THEN RETURN END IF  
   IF l_oea.oeaconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
  #IF l_oea.oea62 != 0 THEN CALL cl_err('','axm-582',0) RETURN END IF #MOD-D30032 mark
   IF l_oea.oeaconf = 'N' THEN
      CALL cl_err('','axm-184',0)
      RETURN
   END IF
 
  #此訂單已拋請購單,就不可以再次拋轉
   LET li_cnt = 0
   SELECT COUNT(*) INTO li_cnt
     FROM pmk_file,oea_file
    WHERE oea01 = l_oea.oea01
      AND pmk01 = oea40
      AND pmk18 != 'X' #作廢
   IF li_cnt >0  THEN
       CALL cl_err('','axm-001',0)
       RETURN
   END IF
   LET li_cnt = 0
 
   
  #檢查是否都有設定主供應商
   SELECT COUNT(*) INTO li_cnt 
     FROM oeb_file,ima_file
    WHERE ima01 = oeb04 
      AND (ima54 IS NULL OR ima54 = '')
      AND oeb01 = l_oea.oea01
   IF li_cnt > 0 THEN
      CALL cl_err('','apm-571',0)
      RETURN
   END IF
 
   IF p_tag = 'A' THEN
     IF cl_null(p_buf) THEN
       LET l_slip = l_gfa.gfa05
     ELSE
       LET l_slip = p_buf
     END IF
     LET tm.wc = " 1=1"   #No.TQC-920112 add
   ELSE
     LET p_row = 5 LET p_col = 11
  
     OPEN WINDOW t400sub_exp_po AT p_row,p_col WITH FORM "axm/42f/axmt400f"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
  
     CALL cl_ui_locale("axmt400f")
  
      WHILE TRUE           #No.TQC-930021 add
      CONSTRUCT BY NAME tm.wc ON oeb03   
   
      BEFORE CONSTRUCT
   
         ON ACTION controlp
            CASE
               WHEN INFIELD(oeb03) 
                    CALL q_oeb11(TRUE,TRUE,l_oea.oea01)
                   RETURNING g_qryparam.multiret                                                                                      
                    DISPLAY g_qryparam.multiret TO oeb03
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
   
             END CONSTRUCT
             LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      #CHI-A80006 mark --start--
      ##此訂單已拋采購單,就不可以再次拋轉
      #LET l_cnt = 0 
      #LET l_sql ="SELECT COUNT(*)",
      #           "  FROM pmm_file,pmn_file,oeb_file",   #MOD-960202
      #           " WHERE oeb01 = pmn24",
      #           "   AND oeb03 = pmn25",
      #           "   AND oeb01 = '",l_oea.oea01,"'",
      #           "   AND pmm01 = pmn01 ",   #MOD-960202
      #           "   AND pmm18 != 'X' ",   #MOD-960202
      #           "   AND ",tm.wc
      #PREPARE t400sub_sel_pmn FROM l_sql
      #EXECUTE t400sub_sel_pmn INTO l_cnt
      #IF l_cnt >0  THEN
      #   CALL cl_err('','axm-581',0)
      #   CONTINUE WHILE   #MOD-960202
      #ELSE
      #   EXIT WHILE
      #END IF
      #END WHILE
      #CHI-A80006 mark --end--
      #CHI-A80006 add --start--
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW t400sub_exp_po
         RETURN
      END IF
      #TQC-BC0172--begin
      LET l_sql ="SELECT count(*) FROM oeb_file",
                 " WHERE oeb01 = '",l_oea.oea01,"' AND ",tm.wc
      PREPARE t400sub_sel_oeb1 FROM l_sql
      EXECUTE t400sub_sel_oeb1 INTO l_t
      IF l_t=0 THEN
         CALL cl_err('','axm-974',1)
         CONTINUE WHILE
      END IF
      #TQC-BC0172--end
      LET l_sql ="SELECT oeb04,oeb05,oeb12,oeb28 ",
                 "  FROM pmm_file,pmn_file,oeb_file",
                 " WHERE oeb01 = pmn24",
                 "   AND oeb03 = pmn25",
                 "   AND oeb01 = '",l_oea.oea01,"'",
                 "   AND pmm01 = pmn01 ",
                 "   AND pmm18 != 'X' ",
                 "   AND ",tm.wc
      PREPARE t400sub_sel_pmn FROM l_sql
      EXECUTE t400sub_sel_pmn INTO l_oeb04,l_oeb05,l_oeb12,l_oeb28
      SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44
        FROM ima_file WHERE ima01=l_oeb04
      IF SQLCA.sqlcode =100 THEN
         IF l_oeb04 MATCHES 'MISC*' THEN
            SELECT ima25,ima44 INTO l_ima25,l_ima44
              FROM ima_file WHERE ima01='MISC'
         END IF
      END IF
      IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
      CALL s_umfchk(l_oeb04,l_ima44,l_oeb05) RETURNING l_flag,l_fac                                                                             
      IF cl_null(l_fac) THEN LET l_fac=1 END IF
      LET l_oeb28 = l_oeb28 * l_fac
      IF l_oeb12 - l_oeb28 <= 0 THEN
         CALL cl_err('','axm-581',0)
         CONTINUE WHILE
      ELSE
         EXIT WHILE
      END IF
      END WHILE
      #CHI-A80006 add --end--
  
     INPUT BY NAME tm.slip 
       
        AFTER FIELD slip
           IF NOT cl_null(tm.slip) THEN  
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM smy_file
               WHERE smyslip = tm.slip AND smysys = 'apm' AND smykind = '2' 
              IF SQLCA.sqlcode OR cl_null(tm.slip) THEN  
                 LET l_cnt = 0
              END IF
              IF l_cnt = 0 THEN
                 CALL cl_err(tm.slip,'aap-010',0)       
                 NEXT FIELD slip
              END IF
           END IF
           LET l_slip = tm.slip
  
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           CLOSE WINDOW t400sub_exp_po
           RETURN
        END IF
  
        ON ACTION controlp
           CASE
              WHEN INFIELD(slip)
                   CALL q_smy(FALSE,TRUE,tm.slip,'APM','2') RETURNING tm.slip
                   DISPLAY BY NAME tm.slip   
                   NEXT FIELD slip
              OTHERWISE EXIT CASE
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
        CLOSE WINDOW t400sub_exp_po
        RETURN
     END IF
     CLOSE WINDOW t400sub_exp_po
   END IF  #TQC-730022 end
 
   LET g_success = 'Y'  #MOD-8A0086                                               
   BEGIN WORK           #MOD-8A0086                                             
   LET l_oeb12 = 0
   LET l_oeb28 = 0
   LET l_i = 0  #TQC-730022 
   LET l_sql = "SELECT DISTINCT ima54 FROM ima_file,oeb_file ",       #MOD-D30032 mark #MOD-D40031 remark
  #LET l_sql = "SELECT DISTINCT ima54,oeb03 FROM ima_file,oeb_file ", #MOD-D30032 add #MOD-D40031 mark
               " WHERE ima01 = oeb04 ",
               "   AND oeb01 = '",l_oea.oea01 CLIPPED,"'",
               "   AND ",tm.wc                                                   #FUN-870033
   PREPARE ima_pre  FROM l_sql
   DECLARE ima_cur CURSOR FOR ima_pre
   CALL s_showmsg_init()                     #No.FUN-710046
   FOREACH ima_cur INTO l_ima54          #MOD-D30032 mark #MOD-D40031 remark
  #FOREACH ima_cur INTO l_ima54,l_oeb03  #MOD-D30032 add  #MOD-D40031 mark
     IF g_success = "N" THEN                                                                                                        
        LET g_totsuccess = "N"                                                                                                      
        LET g_success = "Y"                                                                                                         
     END IF                                                                                                                         
    #MOD-D30032 add start -----
     IF l_oea.oea62 != 0 THEN
        LET l_cnt=0
       #MOD-D40031 add start -----
        LET l_sql = "SELECT oeb03 FROM oeb_file ", 
                    " WHERE oeb01 = '",l_oea.oea01 CLIPPED,"'",
                    "   AND ",tm.wc 
        PREPARE ima_pre2  FROM l_sql
        DECLARE ima_cur2 CURSOR FOR ima_pre2
        FOREACH ima_cur2 INTO l_oeb03
       #MOD-D40031 add end   -----
           SELECT COUNT(*) INTO l_cnt
             FROM ogb_file,oga_file
            WHERE ogb31=l_oea.oea01
              AND ogb32=l_oeb03
              AND ogb01=oga01
              AND ogaconf != 'X'
           IF l_cnt > 0 THEN
              LET g_showmsg = l_oea.oea01,"/",l_oeb03
              CALL s_errmsg('oea01,oeb03',g_showmsg,'oea01/oeb03','axm-582',1)
              LET g_success = 'N'
           END IF
        END FOREACH #MOD-D40031 add
     END IF
    #MOD-D30032 add end   -----
     CALL t400sub_ins_pmm(l_slip,l_ima54,l_oea.*) RETURNING l_pmm01
     IF g_success = 'Y' THEN
       CALL t400sub_ins_pmn_exp(l_pmm01,l_ima54,l_oea.*,tm.wc)   #MOD-870269
       #FUN-B90101--add--begin--
       IF s_industry("slk") THEN
          IF g_azw.azw04 = '2' THEN   #FUN-C20006 add
             CALL t400sub_ins_pmnslk_exp(l_pmm01,l_oea.oea01)
          END IF                      #FUN-C20006 add    
       END IF
       #FUN-B90101--add--end--
       IF g_success = 'N' THEN  EXIT FOREACH  END IF
         IF p_tag = 'A' AND l_gfa.gfa06 = 'Y' THEN
           LET l_i = l_i + 1
           LET l_pmm01_conf[l_i] = l_pmm01 
         END IF
     ELSE
       EXIT FOREACH
     END IF
   END FOREACH
   #採購單自動確認段
    IF p_tag = 'A' AND l_gfa.gfa06 = 'Y' THEN
      FOR l_n = 1 TO l_i
        SELECT pmm_file.* INTO l_pmm.* 
          FROM pmm_file
         WHERE pmm01 = l_pmm01_conf[l_n]
        CALL t540sub_y_chk(l_pmm.*)          #CALL 原apmt540確認的 check 段
        IF g_success = "Y" THEN
          CALL t540sub_y_upd(l_pmm.pmm01,'') #CALL 原apmt540確認的 update 段
        END IF
      END FOR
    END IF
     IF g_totsuccess="N" THEN                                                                                                       
        LET g_success="N"                                                                                                           
     END IF                                      
    CALL s_showmsg()                                                                                   
   IF g_success = 'Y' THEN
         COMMIT WORK
         LET l_prog_t = g_prog
         LET g_prog = 'apmt540'
         CALL cl_flow_notify(l_pmm01,'I')
         LET g_prog = l_prog_t
         CALL cl_err(l_pmm01,'axm-560',1)                                   #FUN-870033                
   ELSE
         ROLLBACK WORK
   END IF
 
END FUNCTION
 
FUNCTION t400sub_ins_pmm(p_slip,p_ima54,l_oea)
   DEFINE p_ima54  LIKE ima_file.ima54
   DEFINE l_pmm    RECORD LIKE pmm_file.*
   DEFINE li_result LIKE type_file.num5  
   DEFINE l_t1     LIKE type_file.chr5
   DEFINE l_oea    RECORD LIKE oea_file.*
   DEFINE p_slip   LIKE type_file.chr5
   
   WHENEVER ERROR CONTINUE                #忽略一切錯誤  #FUN-730012
   INITIALIZE l_pmm.* TO NULL
          
   CALL s_check_no("apm",p_slip,"","2","pmm_file","pmm01","") #FUN-730018
      RETURNING li_result,l_pmm.pmm01
   CALL s_auto_assign_no("apm",l_pmm.pmm01,g_today,"","pmm_file","pmm01","","","")             #No.FUN-560132
        RETURNING li_result,l_pmm.pmm01
   #MOD-BB0160 ----- start -----
   SELECT smy72 INTO l_pmm.pmm02 FROM smy_file WHERE smyslip = p_slip
   IF l_pmm.pmm02 = 'SUB' OR l_pmm.pmm02 = 'TRI' OR cl_null(l_pmm.pmm02) THEN
   #MOD-BB0160 -----  end  -----
      LET l_pmm.pmm02 = 'REG'       #單號性質
   END IF   #MOD-BB0160 add
   LET l_pmm.pmm03 = '0'         #更動序號
   LET l_pmm.pmm04 = g_today     #採購日期
   LET l_pmm.pmm05 = l_oea.oea46 #專案號碼
   LET l_pmm.pmm09 = p_ima54     #供應商
   SELECT pmc15,pmc16,pmc17,pmc47,pmc49,pmc22 #CHI-A50045 add pmc22
     INTO l_pmm.pmm10,l_pmm.pmm11,l_pmm.pmm20,l_pmm.pmm21,l_pmm.pmm41,l_pmm.pmm22  #CHI-A50045 add l_pmm.pmm22
     FROM pmc_file 
   WHERE pmc01 = p_ima54 AND pmc30 IN ('1','3')
   LET l_pmm.pmm12 = g_user      #採購員
   LET l_pmm.pmm13 = g_grup      #採購部門
   LET l_pmm.pmm18 = 'N'         #確認碼
  #LET l_pmm.pmm22 = l_oea.oea23 #幣別  #CHI-A50045 mark
   LET l_pmm.pmm25 = '0'         #狀況碼:開立
   LET l_pmm.pmm26 = ''          #理由碼
   LET l_pmm.pmm27 = g_today     #異動日 
   LET l_pmm.pmm30 = 'N'         #收貨單列印否
   LET l_pmm.pmm40 = 0           #總金額
   LET l_pmm.pmm401= 0           #代買總金額
   LET l_pmm.pmm40t= 0           #含稅總金額     
  #LET l_pmm.pmm42 = l_oea.oea24 #匯率  #CHI-A50045 mark
   #CHI-A50045 add --start--
   CALL s_curr3(l_pmm.pmm22,l_pmm.pmm04,g_sma.sma904)
        RETURNING l_pmm.pmm42    #匯率
   #CHI-A50045 add --end--
   SELECT gec04 INTO l_pmm.pmm43 FROM gec_file
    WHERE gec01 = l_pmm.pmm21
   LET l_pmm.pmm44 = '1'         #扣抵區分
   LET l_pmm.pmm45 = 'Y'         #可用
   LET l_pmm.pmm46 = 0           #預付比率
   LET l_pmm.pmm47 = 0           #預付金額
   LET l_pmm.pmm48 = 0           #已結帳金額
   #MOD-B50152 add --start--
   LET l_pmm.pmm901 = 'N'         #多角貿易採購單
   LET l_pmm.pmm902 = ' '         #最終採購單否
   LET l_pmm.pmm905 = 'N'         #多角貿易拋轉否 
   LET l_pmm.pmm906 = ' '         #多角貿易來源採購單
   #MOD-B50152 add --end--
   LET l_pmm.pmm909 = '3'        #資料來源:由訂單轉入
   LET l_pmm.pmm99 = ''            #MOD-810063 add
   LET l_t1=s_get_doc_no(l_pmm.pmm01) #FUN-730018
   SELECT smyapr,smysign INTO l_pmm.pmmmksg,l_pmm.pmmsign   
       FROM smy_file
     WHERE smyslip = l_t1    #FUN-730018
   IF SQLCA.sqlcode OR cl_null(l_pmm.pmmmksg) THEN
      LET l_pmm.pmmmksg = 'N'
      LET l_pmm.pmmsign= NULL
   END IF
   LET l_pmm.pmmdays = 0         #簽核天數
   LET l_pmm.pmmsseq = 0         #應簽順序
   LET l_pmm.pmmprno = 0         #列印次數
   LET l_pmm.pmmsseq = 0         #已簽順序
   LET l_pmm.pmmprsw = 'Y'       #列印控制 
   CALL signm_count(l_pmm.pmmsign) RETURNING l_pmm.pmmsmax
   LET l_pmm.pmmacti ='Y'        #有效的資料
   LET l_pmm.pmmuser = g_user    #使用者
   LET g_data_plant = g_plant #FUN-980030
   LET l_pmm.pmmgrup = g_grup    #使用者所屬群
   LET l_pmm.pmmdate = g_today
   LET l_pmm.pmm51 = '1'                #No.FUN-870007
   LET l_pmm.pmmpos='N'                 #No.FUN-870007
   LET l_pmm.pmmplant = l_oea.oeaplant  #No.FUN-870007
   LET l_pmm.pmmlegal = l_oea.oealegal  #No.FUN-870007
   LET l_pmm.pmmoriu = g_user      #No.FUN-980030 10/01/04
   LET l_pmm.pmmorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO pmm_file VALUES(l_pmm.*)     #DISK WRITE
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
       CALL cl_err3("ins","pmm_file",l_pmm.pmm01,"",SQLCA.sqlcode,"","ins pmm",1)  
       LET g_success = 'N'
   END IF         
   RETURN l_pmm.pmm01
END FUNCTION      
 
FUNCTION t400sub_ins_pmn_exp(l_pmm01,l_ima54,l_oea,l_wc)   #MOD-870269
 DEFINE l_pmm01  LIKE pmm_file.pmm01,
        l_ima54  LIKE ima_file.ima54   
 DEFINE l_oeo    RECORD LIKE oeo_file.*
 DEFINE l_oeb03  LIKE oeb_file.oeb03  
 DEFINE l_qty    LIKE oeb_file.oeb12
 DEFINE l_oeb01  LIKE oeb_file.oeb01  
 DEFINE l_oeb    RECORD LIKE oeb_file.*
 DEFINE l_oea    RECORD LIKE oea_file.*
 DEFINE l_sql    STRING   #MOD-870269
 DEFINE l_wc     LIKE type_file.chr1000   #MOD-870269
 
 WHENEVER ERROR CONTINUE                #忽略一切錯誤  #FUN-730012
 
 LET l_oeb03=0   
 LET l_sql = "SELECT oeb_file.* FROM oeb_file,ima_file",
             "   WHERE oeb01 = '",l_oea.oea01,"'",
             "     AND oeb1003!='2'",
             "     AND ima01 = oeb04  AND ima54 = '",l_ima54,"'",
             "     AND ",l_wc,
             "     ORDER BY oeb03 "    #FUN-B90101
 PREPARE t400sub_oeb_pre2 FROM l_sql
 DECLARE t400sub_oeb_curs2 CURSOR FOR t400sub_oeb_pre2 
   FOREACH t400sub_oeb_curs2 INTO l_oeb.*
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('','',"foreach:",SQLCA.sqlcode,1) #No.FUN-710046
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         LET l_oeb03 = l_oeb03+1
         CALL t400sub_ins_pmn(l_pmm01,l_oeb.oeb01,l_oeb03,l_oeb.oeb03,l_oeb.oeb04,   
                           l_oeb.oeb05_fac,l_oeb.oeb12,l_oeb.oeb15,
                           l_oeb.oeb05,l_oeb.oeb06,
                           l_oeb.oeb910,l_oeb.oeb911,l_oeb.oeb912,
                           l_oeb.oeb913,l_oeb.oeb914,l_oeb.oeb915,
                           l_oeb.oeb916,l_oeb.oeb917,l_ima54,l_oeb.* #FUN-730018
                           ) 
         DECLARE oeo_cus2 CURSOR FOR
             SELECT *
               FROM oeo_file
              WHERE oeo01 = l_oea.oea01
                AND oeo03 = l_oeb.oeb03
         FOREACH oeo_cus2 INTO l_oeo.*
              IF SQLCA.SQLCODE THEN
                 CALL s_errmsg('','',"sel oeo:",SQLCA.sqlcode,0)  #No.FUN-710046
              END IF
              LET l_oeb03 = l_oeb03+1
              LET l_qty = l_oeb.oeb12 * l_oeo.oeo06
              #CALL t400sub_ins_pmn(l_pmm01,l_oeb01,l_oeb03,l_oeb.oeb03,l_oeo.oeo04,    #NO.FUN-670007    #MOD-A20119
              CALL t400sub_ins_pmn(l_pmm01,l_oeb.oeb01,l_oeb03,l_oeb.oeb03,l_oeo.oeo04,    #NO.FUN-670007    #MOD-A20119
                                l_oeb.oeb05_fac,l_qty,l_oeb.oeb15,
                                l_oeo.oeo05,l_oeo.oeo04,
                                l_oeb.oeb910,l_oeb.oeb911,l_oeb.oeb912,
                                l_oeb.oeb913,l_oeb.oeb914,l_oeb.oeb915,
                                l_oeb.oeb916,l_oeb.oeb917,l_ima54,l_oeb.*)   #FUN-730018
         END FOREACH
      END FOREACH
      IF g_success = 'Y' THEN
         CALL t400sub_upd_pmm_amount(l_pmm01)
      END IF
END FUNCTION
 
FUNCTION t400sub_upd_pmm_amount(l_pmm01)
  DEFINE l_pmm01  LIKE pmm_file.pmm01
  DEFINE l_tot_pmm40   LIKE pmm_file.pmm40,
         l_tot_pmm40t  LIKE pmm_file.pmm40t
  DEFINE l_pmm22  LIKE pmm_file.pmm22
  DEFINE t_azi04  LIKE azi_file.azi04
 
  SELECT pmm22 INTO l_pmm22 FROM pmm_file WHERE pmm01 = l_pmm01
 
  SELECT SUM(pmn88),SUM(pmn88t)
    INTO l_tot_pmm40,l_tot_pmm40t
    FROM pmn_file
   WHERE pmn01 = l_pmm01
  IF SQLCA.sqlcode OR l_tot_pmm40 IS NULL THEN
     LET l_tot_pmm40 = 0
     LET l_tot_pmm40t= 0   
  END IF
 
  SELECT azi04 INTO t_azi04 FROM azi_file
   WHERE azi01 = l_pmm22 AND aziacti = 'Y'
 
  CALL cl_digcut(l_tot_pmm40,t_azi04) RETURNING l_tot_pmm40  
  CALL cl_digcut(l_tot_pmm40t,t_azi04) RETURNING l_tot_pmm40t  
 
  UPDATE pmm_file SET pmm40 = l_tot_pmm40,  #未稅總金額
                      pmm40t= l_tot_pmm40t  #含稅總金額
    WHERE pmm01 = l_pmm01
  IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","pmm_file",l_pmm01,"",SQLCA.sqlcode,"","update pmm40",0)
      LET g_success = 'N'
  END IF
END FUNCTION
 
FUNCTION t400sub_pmn_ini(p_pmm01)
  DEFINE p_pmm01 LIKE pmm_file.pmm01,
         l_pmm02 LIKE pmm_file.pmm02,
         l_pmm05 LIKE pmm_file.pmm05,
         l_pmm25 LIKE pmm_file.pmm25,
         l_pmn   RECORD LIKE pmn_file.*,
         l_pmm13 LIKE pmm_file.pmm13
  
  
   SELECT pmm02,pmm25,pmm05,pmm13 INTO l_pmm02,l_pmm25,l_pmm05,l_pmm13
     FROM pmm_file WHERE pmm01 = p_pmm01
   LET l_pmn.pmn01  = p_pmm01               
   LET l_pmn.pmn011 = 'REG'
   LET l_pmn.pmn05  = NULL
   LET l_pmn.pmn11  = 'N'
   LET l_pmn.pmn122 = l_pmm05
   LET l_pmn.pmn13  = 0
   LET l_pmn.pmn14  = g_sma.sma886[1,1]     
   LET l_pmn.pmn15  = g_sma.sma886[2,2]
   LET l_pmn.pmn16  = l_pmm25
   LET l_pmn.pmn18  = ''
   LET l_pmn.pmn32  = 0
   LET l_pmn.pmn38  ='Y'
   LET l_pmn.pmn42  ='0'
   LET l_pmn.pmn43  = 0                  
   LET l_pmn.pmn431 = 0
   LET l_pmn.pmn45  = NULL
   LET l_pmn.pmn46  = 0
   LET l_pmn.pmn50  = 0
   LET l_pmn.pmn51  = 0
   LET l_pmn.pmn53  = 0
   LET l_pmn.pmn55  = 0
   LET l_pmn.pmn56  = ''
   LET l_pmn.pmn57  = 0
   LET l_pmn.pmn58  = 0
   LET l_pmn.pmn59  = ''
   LET l_pmn.pmn60  = 0
   LET l_pmn.pmn62  = 1
   LET l_pmn.pmn63  = 'N'
   LET l_pmn.pmn65  = '1'
   LET l_pmn.pmn90  = l_pmn.pmn31
   LET l_pmn.pmn930 = s_costcenter(l_pmm13)
   RETURN l_pmn.*
END FUNCTION
 
FUNCTION t400sub_ins_pmn(p_pmm01, p_oeb01, p_oeb03, p_oeb03_t,p_oeb04, p_oeb05_fac,
                            p_oeb12, p_oeb15, p_oeb05, p_oeb06, p_oeb910,  
                            p_oeb911,p_oeb912,p_oeb913,p_oeb914,p_oeb915,
                            p_oeb916,p_oeb917,p_ima54,l_oeb)
  DEFINE p_pmm01     LIKE pmm_file.pmm01,
         p_oeb01     LIKE oeb_file.oeb01,    
         p_oeb03     LIKE oeb_file.oeb03,
         p_oeb03_t   LIKE oeb_file.oeb03,
         p_oeb04     LIKE oeb_file.oeb04,
         p_oeb05_fac LIKE oeb_file.oeb05_fac,
         p_oeb05     LIKE oeb_file.oeb05,
         p_oeb06     LIKE oeb_file.oeb06,
         p_oeb12     LIKE oeb_file.oeb12,
         p_oeb15     LIKE oeb_file.oeb15,
         p_oeb28     LIKE oeb_file.oeb28,    
         p_oeb24     LIKE oeb_file.oeb24,    
         p_oeb910    LIKE oeb_file.oeb910,
         p_oeb911    LIKE oeb_file.oeb911,
         p_oeb912    LIKE oeb_file.oeb912,
         p_oeb913    LIKE oeb_file.oeb913,
         p_oeb914    LIKE oeb_file.oeb914,
         p_oeb915    LIKE oeb_file.oeb915,
         p_oeb916    LIKE oeb_file.oeb916,
         p_oeb917    LIKE oeb_file.oeb917,
         p_ima54     LIKE ima_file.ima54,
         l_ima01     LIKE ima_file.ima01,
         l_ima02     LIKE ima_file.ima02,
         l_ima05     LIKE ima_file.ima05,
         l_ima15     LIKE ima_file.ima15,
         l_ima25     LIKE ima_file.ima25,
         l_ima27     LIKE ima_file.ima27,
#         l_ima262    LIKE ima_file.ima262, #FUN-A20044
         l_avl_stk,l_avl_stk_mpsmrp,l_unavl_stk    LIKE type_file.num15_3, #FUN-A20044
         l_ima35     LIKE ima_file.ima35,
         l_ima36     LIKE ima_file.ima36,
         l_ima44     LIKE ima_file.ima44,
         l_ima44_fac LIKE ima_file.ima44_fac,
         l_ima45     LIKE ima_file.ima45,
         l_ima46     LIKE ima_file.ima46,
         l_ima49     LIKE ima_file.ima49,
         l_ima491    LIKE ima_file.ima491,
         l_ima913    LIKE ima_file.ima913,   
         l_ima914    LIKE ima_file.ima914,   
         l_pmm09     LIKE pmm_file.pmm09,   
         l_pmm22     LIKE pmm_file.pmm22,   
         l_pmm04     LIKE pmm_file.pmm04,   
         l_pmm21     LIKE pmm_file.pmm21,   
         l_pmm42     LIKE pmm_file.pmm42,   
         l_pmm43     LIKE pmm_file.pmm43,   
         l_pmm51     LIKE pmm_file.pmm51,    #No.FUN-870007
         l_pmmplant  LIKE pmm_file.pmmplant, #No.FUN-870007
         l_pmmlegal  LIKE pmm_file.pmmlegal, #No.FUN-870007
         l_pan       LIKE type_file.num10,   
         l_double    LIKE type_file.num10    
  DEFINE t_azi03     LIKE azi_file.azi03,
         t_azi04     LIKE azi_file.azi04
  DEFINE l_pmn       RECORD LIKE pmn_file.*
  DEFINE l_oeb       RECORD LIKE oeb_file.*
  DEFINE l_pmni      RECORD LIKE pmni_file.*        #No.FUN-7B0018
  DEFINE l_gec07     LIKE gec_file.gec07,           #No.MOD-8B0273 add
         l_flag      LIKE type_file.chr1     #MOD-920385
  DEFINE l_pmm20 LIKE pmm_file.pmm20                #No.FUN-930148
  DEFINE l_pmm41 LIKE pmm_file.pmm41                #No.FUN-930148
 
   CALL t400sub_pmn_ini(p_pmm01) RETURNING l_pmn.*  #FUN-730018
 
   IF p_oeb04[1,4] <> "MISC" THEN
    #   SELECT ima01,ima02,ima05,ima25,ima262,ima27,ima44,ima44_fac, #FUN-A20044
       SELECT ima01,ima02,ima05,ima25,0,ima27,ima44,ima44_fac, #FUN-A20044
              ima45,ima46,ima49,ima491,
              ima913,ima914,ima15,ima35,ima36         
         INTO l_ima01,l_ima02,l_ima05,l_ima25,l_avl_stk,l_ima27,
              l_ima44,l_ima44_fac,l_ima45,l_ima46,l_ima49,l_ima491,
              l_ima913,l_ima914,l_ima15,l_ima35,l_ima36       
         FROM ima_file
        WHERE ima01 = p_oeb04
        CALL s_getstock(p_oeb04,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk
       IF SQLCA.sqlcode THEN
           CALL s_errmsg("ima01",p_oeb04,"SEL ima_file",SQLCA.sqlcode,1)     #No.FUN-710046
           LET g_success = 'N'
           RETURN
       END IF
       LET l_pmn.pmn02 = p_oeb03
       LET l_pmn.pmn04 = l_ima01
       LET l_pmn.pmn61 = l_ima01
       LET l_pmn.pmn64 = l_ima15
       LET l_pmn.pmn041= l_ima02
       LET l_pmn.pmn07 = l_ima44   #MOD-920385
       LET l_pmn.pmn08 = l_ima25
       CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn07,
            l_pmn.pmn08) RETURNING l_flag,l_pmn.pmn09
       IF cl_null(l_pmn.pmn09) THEN LET l_pmn.pmn09=1 END IF
       #先將訂單數量轉換成採購單位數量
       LET l_pmn.pmn121= 1
 
      LET p_oeb12 = p_oeb12 * p_oeb05_fac / l_pmn.pmn09   #MOD-920385
      #CHI-A80006 add --start--
      LET p_oeb28=0
      LET p_oeb24=0
      SELECT oeb28,oeb24 INTO p_oeb28,p_oeb24
        FROM oeb_file
       WHERE oeb01=p_oeb01
        #AND oeb03=p_oeb03    #MOD-B30439
         AND oeb03=p_oeb03_t  #MOD-B30439
      IF cl_null(p_oeb28) THEN LET p_oeb28 = 0 END IF
      IF cl_null(p_oeb24) THEN LET p_oeb24 = 0 END IF
      LET p_oeb12 = (p_oeb12-p_oeb28-p_oeb24)
      #CHI-A80006 add --end--
       #-->考慮最少採購量/倍量
       IF p_oeb12 > 0 THEN        #TQC-750152
           IF p_oeb12 < l_ima46 THEN         #TQC-750152
               LET l_pmn.pmn20 = l_ima46
           ELSE
               IF l_ima45 > 0 THEN
                   LET l_pan = (p_oeb12 * 1000) / (l_ima45 * 1000)
                   IF (l_pan*(l_ima45*1000)) > (p_oeb12 * 1000) THEN
                       LET l_pan=(p_oeb12*1000) -((l_pan-1)*(l_ima45*1000))
                   ELSE
                       LET l_pan=(p_oeb12*1000) -(l_pan*(l_ima45*1000))
                   END IF
 
                   IF l_pan !=0 THEN
                       LET l_double = (p_oeb12/l_ima45) + 1
                   ELSE
                       LET l_double = p_oeb12/l_ima45
                   END IF
                   LET l_pmn.pmn20  = l_double * l_ima45
                   LET l_pmn.pmn20 = s_digqty(l_pmn.pmn20,l_pmn.pmn07)   #No.FUN-BB0086
               ELSE
                   LET l_pmn.pmn20 = p_oeb12
               END IF
           END IF
       ELSE
           LET l_pmn.pmn20 = 0
       END IF
       LET l_pmn.pmn35 = p_oeb15                 #到庫日期
       CALL s_aday(l_pmn.pmn35,-1,l_ima491) RETURNING l_pmn.pmn34 
       CALL s_aday(l_pmn.pmn34,-1,l_ima49) RETURNING l_pmn.pmn33 
       LET l_pmn.pmn52 = l_ima35
       LET l_pmn.pmn53 = 0
       LET l_pmn.pmn54 = l_ima36
   ELSE
       LET l_pmn.pmn02 = p_oeb03
       LET l_pmn.pmn04 = p_oeb04
       LET l_pmn.pmn61 = p_oeb04
       LET l_pmn.pmn64 = 'N'
       LET l_pmn.pmn041= p_oeb06
       LET l_pmn.pmn07 = p_oeb05
       LET l_pmn.pmn08 = p_oeb05
       LET l_pmn.pmn09 = 1
       LET l_pmn.pmn20 = p_oeb12
       LET l_pmn.pmn35 = p_oeb15
       CALL s_aday(l_pmn.pmn35,-1,l_ima491) RETURNING l_pmn.pmn34 
       CALL s_aday(l_pmn.pmn34,-1,l_ima49) RETURNING l_pmn.pmn33  
   END IF
 
   LET l_pmn.pmn122 = l_oeb.oeb41
   LET l_pmn.pmn96  = l_oeb.oeb42
   LET l_pmn.pmn97  = l_oeb.oeb43
#  LET l_pmn.pmn98  = l_oeb.oeb1001  #MOD-C30368 mark
   
   SELECT imb118 INTO l_pmn.pmn30 FROM imb_file WHERE imb01 = l_pmn.pmn04 
    SELECT pmm09,pmm22,pmm04,pmm21,pmm43,pmm42,pmm51,pmm41,pmm20,pmmplant,pmmlegal   #FUN-B90101 add pmm41,pmm20
     INTO l_pmm09,l_pmm22,l_pmm04,l_pmm21,l_pmm43,l_pmm42,l_pmm51,l_pmm41,l_pmm20,   #FUN-B90101 add l_pmm41,l_pmm20 
          l_pmmplant,l_pmmlegal
     FROM pmm_file
    WHERE pmm01 = p_pmm01
 
   LET l_pmn.pmn80 = p_oeb910
   LET l_pmn.pmn81 = p_oeb911
   LET l_pmn.pmn82 = p_oeb912
   LET l_pmn.pmn83 = p_oeb913
   LET l_pmn.pmn84 = p_oeb914
   LET l_pmn.pmn85 = p_oeb915
   IF g_sma.sma116 MATCHES'[13]' THEN
      LET l_pmn.pmn86 = p_oeb916
   ELSE
      LET l_pmn.pmn86 = l_pmn.pmn07
   END IF
   LET g_pmn.* = l_pmn.*
   CALL t400_set_pmn87()
   LET l_pmn.pmn87=g_pmn.pmn87
 
   
   CALL s_defprice_new(l_pmn.pmn04,l_pmm09,l_pmm22,l_pmm04,l_pmn.pmn87,'',l_pmm21,l_pmm43,'1',l_pmn.pmn86,'',
                   l_pmm41,l_pmm20,g_plant)
       RETURNING l_pmn.pmn31,l_pmn.pmn31t,
                 l_pmn.pmn73,l_pmn.pmn74   #TQC-AC0257 add              
 
   IF cl_null(l_pmn.pmn31)  THEN LET l_pmn.pmn31  = 0 END IF
   IF cl_null(l_pmn.pmn31t) THEN LET l_pmn.pmn31t = 0 END IF
   SELECT pmh04,pmh07 
    INTO l_pmn.pmn06,l_pmn.pmn123 
    FROM pmh_file
   WHERE pmh01=l_ima01 and pmh02= p_ima54
     AND pmh21 = " "                                             #CHI-860042                                                        
     AND pmh22 = '1'                                             #CHI-860042
     AND pmh23 = ' '                                             #No.CHI-960033
     AND pmhacti = 'Y'                                           #CHI-910021
 
   SELECT pml01,pml02,pml66,pml67 
     INTO l_pmn.pmn24,l_pmn.pmn25,l_pmn.pmn66,l_pmn.pmn67
     FROM pml_file
    WHERE pml24=p_oeb01 AND pml25 = p_oeb03
   LET l_pmn.pmn68 = ''
   LET l_pmn.pmn69 = ''   #MOD-740282
   LET l_pmn.pmn70 = 0
   LET l_pmn.pmn71 = ''
 
   SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file     
                  WHERE azi01 = l_pmm22  AND aziacti= 'Y'
 
   LET l_pmn.pmn44 = cl_digcut(l_pmn.pmn31*l_pmm42,g_azi03)
#  LET l_pmn.pmn88 = cl_digcut(l_pmn.pmn31*l_pmn.pmn20,t_azi04)     #CHI-B70039 mark
#  LET l_pmn.pmn88t = cl_digcut(l_pmn.pmn31t*l_pmn.pmn20,t_azi04)   #CHI-B70039 mark
   LET l_pmn.pmn88 = cl_digcut(l_pmn.pmn87*l_pmn.pmn31,t_azi04)     #CHI-B70039
   LET l_pmn.pmn88t = cl_digcut(l_pmn.pmn87*l_pmn.pmn31t,t_azi04)   #CHI-B70039
 
   LET l_pmn.pmn24 = p_oeb01
   LET l_pmn.pmn25 = p_oeb03_t
   IF cl_null(l_pmn.pmn02) THEN LET l_pmn.pmn02 = 0 END IF   #TQC-790002 add
   LET l_pmn.pmn90=l_pmn.pmn31 #MOD-960013
  # LET l_pmn.pmn73 = ' '           #No.FUN-870007
   IF cl_null(l_pmn.pmn73) THEN LET l_pmn.pmn73 = '4' END IF  #TQC-AC0257 add
   LET l_pmn.pmnplant = l_pmmplant #No.FUN-870007
   LET l_pmn.pmnlegal = l_pmmlegal #No.FUN-870007
   LET l_pmn.pmn919 = l_oeb.oeb919   #FUN-A90059 add
   IF cl_null(l_pmn.pmn58) THEN LET l_pmn.pmn58 = 0 END IF   #TQC-9B0203
   IF cl_null(l_pmn.pmn012) THEN LET l_pmn.pmn012 = ' ' END IF #FUN-A60076
   LET l_pmn.pmn89 = 'N'   #No.TQC-BB0265
   CALL s_schdat_pmn78(l_pmn.pmn41,l_pmn.pmn012,l_pmn.pmn43,l_pmn.pmn18,   #FUN-C10002
                                     l_pmn.pmn32) RETURNING l_pmn.pmn78      #FUN-C10002
   INSERT INTO pmn_file VALUES(l_pmn.*)
   IF SQLCA.sqlcode THEN
      CALL s_errmsg("pmn01",l_pmn.pmn01,"INS pmn_file",SQLCA.sqlcode,1)     #No.FUN-710046
      LET g_success = 'N'
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_pmni.* TO NULL
         LET l_pmni.pmni01 = l_pmn.pmn01
         LET l_pmni.pmni02 = l_pmn.pmn02
         IF NOT s_ins_pmni(l_pmni.*,'') THEN
            LET g_success = 'N'
         END IF
      END IF
   END IF
    SELECT SUM(pmn20) INTO l_pmn.pmn20 
      FROM pmm_file,pmn_file
     WHERE pmn24 = l_pmn.pmn24
       AND pmn25 = l_pmn.pmn25
       AND pmm01 = pmn01
       AND pmm18 <> 'X'
       AND pmn16 <> '9'
   UPDATE oeb_file SET oeb27 = p_pmm01,
                       oeb28 = l_pmn.pmn20
                 WHERE oeb01 = p_oeb01
                   AND oeb03 = p_oeb03_t  #No.TQC-950014 add
   IF SQLCA.sqlcode THEN
      LET g_showmsg=p_oeb01,"/",p_oeb03       
      CALL s_errmsg("oeb01,oeb03",g_showmsg,"UPD oeb_file",SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
END FUNCTION
 
#FUN-B90101--add--begin--
FUNCTION t400sub_ins_pmnslk_exp(l_pmm01,l_oea01)   #自動產生款號單身
 DEFINE l_pmnslk  RECORD  LIKE pmnslk_file.*
 DEFINE l_pmn02           LIKE pmn_file.pmn02
 DEFINE l_pmn04           LIKE pmn_file.pmn04
 DEFINE l_pmm01           LIKE pmm_file.pmm01
 DEFINE l_oebslk  RECORD  LIKE oebslk_file.*
 DEFINE l_oea01           LIKE oea_file.oea01 

   DECLARE t400_g_pmnslk CURSOR FOR SELECT * FROM oebslk_file
                                     WHERE oebslk01=l_oea01
                                     ORDER BY oebslk03    

   FOREACH t400_g_pmnslk INTO l_oebslk.*
      LET l_pmnslk.pmnslk01=l_pmm01
      SELECT MAX(pmnslk02)+1 INTO l_pmnslk.pmnslk02 FROM pmnslk_file WHERE pmnslk01=l_pmm01
      IF cl_null(l_pmnslk.pmnslk02) THEN
         LET l_pmnslk.pmnslk02=1
      END IF
      LET l_pmnslk.pmnslk04=l_oebslk.oebslk04

      SELECT ima02 INTO l_pmnslk.pmnslk041 FROM ima_file WHERE ima01=l_pmnslk.pmnslk04
      SELECT MIN(pmn02),SUM(pmn20),SUM(pmn88),SUM(pmn88t)
        INTO l_pmn02,l_pmnslk.pmnslk20,
             l_pmnslk.pmnslk88,l_pmnslk.pmnslk88t
        FROM pmn_file,pmni_file,oeb_file,oebi_file
       WHERE pmn01=pmni01
         AND pmn02=pmni02
         AND oeb01=oebi01
         AND oeb03=oebi03
         AND pmn24=oeb01
         AND pmn25=oeb03
         AND pmn01=l_pmm01
         AND pmn24=l_oebslk.oebslk01
         AND oebislk03=l_oebslk.oebslk03

      IF cl_null(l_pmnslk.pmnslk20) THEN
         CONTINUE FOREACH
      END IF

      LET l_pmnslk.pmnslk88 = cl_digcut(l_pmnslk.pmnslk88,t_azi04)
      LET l_pmnslk.pmnslk88t= cl_digcut(l_pmnslk.pmnslk88t,t_azi04)

      SELECT pmn07,pmn08,pmn30,pmn31,pmn33,pmn34,pmn35,pmn44,
             pmn31t,pmn52,pmn54,pmn56,pmn73,pmn74
        INTO l_pmnslk.pmnslk07,l_pmnslk.pmnslk08,
             l_pmnslk.pmnslk30,l_pmnslk.pmnslk31,l_pmnslk.pmnslk33,l_pmnslk.pmnslk34,
             l_pmnslk.pmnslk35,l_pmnslk.pmnslk44,
             l_pmnslk.pmnslk31t,l_pmnslk.pmnslk52,l_pmnslk.pmnslk54,l_pmnslk.pmnslk56,
             l_pmnslk.pmnslk73,l_pmnslk.pmnslk74
        FROM pmn_file,pmni_file,oeb_file,oebi_file
       WHERE pmn01=pmni01
         AND pmn02=pmni02
         AND oeb01=oebi01
         AND oeb03=oebi03
         AND pmn24=oeb01
         AND pmn25=oeb03
         AND pmn01=l_pmm01
         AND pmn24=l_oebslk.oebslk01
         AND oebislk03=l_oebslk.oebslk03
         AND pmn02=l_pmn02

      IF cl_null(l_pmnslk.pmnslk30) THEN
         LET l_pmnslk.pmnslk30=0
      END IF
      IF cl_null(l_pmnslk.pmnslk31) THEN
         LET l_pmnslk.pmnslk31=0
      END IF
      IF cl_null(l_pmnslk.pmnslk31t) THEN
         LET l_pmnslk.pmnslk31t=0
      END IF
      IF cl_null(l_pmnslk.pmnslk44) THEN
         LET l_pmnslk.pmnslk44=0
      END IF
      LET l_pmnslk.pmnslkplant=g_plant
      LET l_pmnslk.pmnslklegal=g_legal
      INSERT INTO pmnslk_file VALUES(l_pmnslk.*)
      IF STATUS THEN
         CALL cl_err3("ins","pmnslk_file","","",SQLCA.sqlcode,"","ins pmnslk",1)
         EXIT FOREACH
      ELSE
         UPDATE pmni_file SET pmnislk02=l_pmnslk.pmnslk04,pmnislk03=l_pmnslk.pmnslk02
           WHERE pmni01=l_pmm01
             AND pmni02 IN (SELECT pmn02 FROM pmn_file,oeb_file,oebi_file
                             WHERE pmn01=pmni01
                               AND pmn02=pmni02
                               AND oeb01=oebi01
                               AND oeb03=oebi03
                               AND pmn24=oeb01
                               AND pmn25=oeb03
                               AND pmn01=l_pmm01
                               AND pmn24=l_oebslk.oebslk01
                               AND oebislk03=l_oebslk.oebslk03)

         IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","pmni_file","","",SQLCA.sqlcode,"","",1)
            EXIT FOREACH
         END IF
      END IF

   END FOREACH  

# DECLARE t400_g_pmnslk CURSOR FOR SELECT MIN(pmn02),SUM(pmn20),SUM(pmn88),SUM(pmn88t)
#                                    FROM pmn_file,pmni_file,imx_file
#                                   WHERE pmn01=pmni01
#                                     AND pmn02=pmni02
#                                     AND pmn04=imx000
#                                     AND pmn01 = l_pmm01
#                                    GROUP BY imx00
# FOREACH t400_g_pmnslk INTO l_pmn02,l_pmnslk.pmnslk20,
#                            l_pmnslk.pmnslk88,l_pmnslk.pmnslk88t
#    LET l_pmnslk.pmnslk01=l_pmm01
#    SELECT MAX(pmnslk02)+1 INTO l_pmnslk.pmnslk02 FROM pmnslk_file WHERE pmnslk01=l_pmm01
#    IF cl_null(l_pmnslk.pmnslk02) THEN
#       LET l_pmnslk.pmnslk02=1
#    END IF
#    SELECT imx00 INTO l_pmnslk.pmnslk04 FROM imx_file,pmn_file
#      WHERE imx000=pmn04 AND pmn01=l_pmm01 AND pmn02=l_pmn02
#    SELECT ima02 INTO l_pmnslk.pmnslk041 FROM ima_file WHERE ima01=l_pmnslk.pmnslk04

#    SELECT pmn07,pmn08,pmn30,pmn31,pmn31t,pmn33,pmn34,pmn35,pmn44,pmn52,pmn54,
#           pmn56,pmn73,pmn74,pmnplant,pmnlegal
#      INTO l_pmnslk.pmnslk07,l_pmnslk.pmnslk08,l_pmnslk.pmnslk30,l_pmnslk.pmnslk31,
#           l_pmnslk.pmnslk31t,l_pmnslk.pmnslk33,l_pmnslk.pmnslk34,l_pmnslk.pmnslk35,
#           l_pmnslk.pmnslk44,l_pmnslk.pmnslk52,l_pmnslk.pmnslk54,l_pmnslk.pmnslk56,
#           l_pmnslk.pmnslk73,l_pmnslk.pmnslk74,l_pmnslk.pmnslkplant,l_pmnslk.pmnslklegal
#      FROM pmn_file
#     WHERE pmn01=l_pmm01 AND pmn02=l_pmn02

#    IF cl_null(l_pmnslk.pmnslk30) THEN
#       LET l_pmnslk.pmnslk30 = 0
#    END IF
#    IF cl_null(l_pmnslk.pmnslk31) THEN
#       LET l_pmnslk.pmnslk31 = 0
#    END IF
#    IF cl_null(l_pmnslk.pmnslk31t) THEN
#       LET l_pmnslk.pmnslk31t = 0
#    END IF  
#    INSERT INTO pmnslk_file VALUES(l_pmnslk.*)
#    IF STATUS THEN
#       CALL cl_err3("ins","pmnslk_file","","",SQLCA.sqlcode,"","ins pmnslk",1)
#       LET g_success = 'N'
#       EXIT FOREACH
#    ELSE
#       UPDATE pmni_file SET pmnislk02=l_pmnslk.pmnslk04,
#                            pmnislk03=l_pmnslk.pmnslk02
#         WHERE pmni01=l_pmm01
#           AND pmni02 IN (SELECT pmn02 FROM pmn_file,imx_file
#                           WHERE pmn01=l_pmm01
#                             AND pmn04=imx000
#                             AND imx00=l_pmnslk.pmnslk04)
#       IF STATUS THEN
#          CALL cl_err3("upd","pmni_file","","",SQLCA.sqlcode,"","",1)
#          LET g_success = 'N'
#          EXIT FOREACH
#       END IF
#    END IF

# END FOREACH

END FUNCTION

FUNCTION t400sub_ins_pmlslk_exp(l_pmk01,l_oea01)   #自動產生款號單身
  DEFINE l_pmlslk  RECORD  LIKE pmlslk_file.*
  DEFINE l_pml02           LIKE pml_file.pml02
  DEFINE l_pml04           LIKE pml_file.pml04
  DEFINE l_pmk01           LIKE pmk_file.pmk01
  DEFINE l_oea01           LIKE oea_file.oea01   
  DEFINE l_oebslk  RECORD  LIKE oebslk_file.*
   
   DECLARE t400_g_pmlslk CURSOR FOR SELECT * FROM oebslk_file
                                     WHERE oebslk01=l_oea01
                                     ORDER BY oebslk03      
   FOREACH t400_g_pmlslk INTO l_oebslk.*
      LET l_pmlslk.pmlslk01=l_pmk01
      SELECT MAX(pmlslk02)+1 INTO l_pmlslk.pmlslk02 FROM pmlslk_file WHERE pmlslk01=l_pmk01
      IF cl_null(l_pmlslk.pmlslk02) THEN
         LET l_pmlslk.pmlslk02=1
      END IF
      LET l_pmlslk.pmlslk04=l_oebslk.oebslk04
      LET l_pmlslk.pmlslk24=l_oebslk.oebslk01
      LET l_pmlslk.pmlslk25=l_oebslk.oebslk03
      SELECT ima02 INTO l_pmlslk.pmlslk041 FROM ima_file WHERE ima01=l_pmlslk.pmlslk04
      SELECT MIN(pml02),SUM(pml20),SUM(pml21),
             SUM(pml88),SUM(pml88t)
        INTO l_pml02,l_pmlslk.pmlslk20,l_pmlslk.pmlslk21,
             l_pmlslk.pmlslk88,l_pmlslk.pmlslk88t
        FROM pml_file,pmli_file,oeb_file,oebi_file
       WHERE pml01=pmli01
         AND pml02=pmli02
         AND oeb01=oebi01
         AND oeb03=oebi03
         AND pml24=oeb01
         AND pml25=oeb03
         AND pml01=l_pmk01
         AND pml24=l_pmlslk.pmlslk24
         AND oebislk03=l_pmlslk.pmlslk25

      IF cl_null(l_pmlslk.pmlslk20) THEN
         CONTINUE FOREACH
      END IF
 
      LET l_pmlslk.pmlslk88 = cl_digcut(l_pmlslk.pmlslk88,t_azi04)
      LET l_pmlslk.pmlslk88t= cl_digcut(l_pmlslk.pmlslk88t,t_azi04)
 
      SELECT pml07,pml08,pml30,pml31,pml33,pml34,pml35,pml44,
             pml31t,pml190,pml191,pml192,pml930,pml90,pml50
        INTO l_pmlslk.pmlslk07,l_pmlslk.pmlslk08,
             l_pmlslk.pmlslk30,l_pmlslk.pmlslk31,l_pmlslk.pmlslk33,l_pmlslk.pmlslk34,
             l_pmlslk.pmlslk35,l_pmlslk.pmlslk44,
             l_pmlslk.pmlslk31t,l_pmlslk.pmlslk190,l_pmlslk.pmlslk191,l_pmlslk.pmlslk192,
             l_pmlslk.pmlslk930,l_pmlslk.pmlslk90,l_pmlslk.pmlslk50
        FROM pml_file,pmli_file,oeb_file,oebi_file
       WHERE pml01=pmli01
         AND pml02=pmli02
         AND oeb01=oebi01
         AND oeb03=oebi03
         AND pml24=oeb01
         AND pml25=oeb03
         AND pml01=l_pmk01
         AND pml24=l_pmlslk.pmlslk24
         AND oebislk03=l_pmlslk.pmlslk25
         AND pml02=l_pml02

      IF cl_null(l_pmlslk.pmlslk30) THEN
         LET l_pmlslk.pmlslk30=0
      END IF
      IF cl_null(l_pmlslk.pmlslk31) THEN
         LET l_pmlslk.pmlslk31=0
      END IF
      IF cl_null(l_pmlslk.pmlslk31t) THEN
         LET l_pmlslk.pmlslk31t=0
      END IF
      IF cl_null(l_pmlslk.pmlslk44) THEN
         LET l_pmlslk.pmlslk44=0
      END IF
      LET l_pmlslk.pmlslkplant=g_plant
      LET l_pmlslk.pmlslklegal=g_legal
      INSERT INTO pmlslk_file VALUES(l_pmlslk.*)
      IF STATUS THEN
         CALL cl_err3("ins","pmlslk_file","","",SQLCA.sqlcode,"","ins pmlslk",1)
         EXIT FOREACH
      ELSE
         UPDATE pmli_file SET pmlislk02=l_pmlslk.pmlslk04,pmlislk03=l_pmlslk.pmlslk02
           WHERE pmli01=l_pmk01
             AND pmli02 IN (SELECT pml02 FROM pml_file,oeb_file,oebi_file
                             WHERE pml01=pmli01
                               AND pml02=pmli02
                               AND oeb01=oebi01
                               AND oeb03=oebi03
                               AND pml24=oeb01
                               AND pml25=oeb03
                               AND pml01=l_pmk01
                               AND pml24=l_pmlslk.pmlslk24
                               AND oebislk03=l_pmlslk.pmlslk25)

         IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","pmli_file","","",SQLCA.sqlcode,"","",1)
            EXIT FOREACH
         END IF
      END IF

      SELECT SUM(pmlslk20) INTO l_pmlslk.pmlslk20
       FROM pmlslk_file,pmk_file
       WHERE pmlslk24 = l_pmlslk.pmlslk24
         AND pmlslk25 = l_pmlslk.pmlslk25
         AND pmlslk01 = pmk01
         AND pmk18 <> 'X'
  #要回寫每張訂單的己拋量和請購單號
      UPDATE oebslk_file SET oebslk28 = l_pmlslk.pmlslk20
                   WHERE oebslk01 = l_pmlslk.pmlslk24
                     AND oebslk03 = l_pmlslk.pmlslk25     

   END FOREACH

#  DECLARE t400_g_pmlslk CURSOR FOR SELECT MAX(pml02),SUM(pml20),SUM(pml21),SUM(pml88),SUM(pml88t)
#                                     FROM pml_file,pmli_file,imx_file
#                                    WHERE pml01=pmli01
#                                      AND pml02=pmli02
#                                      AND pml04=imx000
#                                      AND pml01 = l_pmk01
#                                     GROUP BY imx00
#  FOREACH t400_g_pmlslk INTO l_pml02,l_pmlslk.pmlslk20,l_pmlslk.pmlslk21,
#                             l_pmlslk.pmlslk88,l_pmlslk.pmlslk88t
#     LET l_pmlslk.pmlslk01=l_pmk01
#     SELECT MAX(pmlslk02)+1 INTO l_pmlslk.pmlslk02 FROM pmlslk_file WHERE pmlslk01=l_pmk01
#     IF cl_null(l_pmlslk.pmlslk02) THEN
#        LET l_pmlslk.pmlslk02=1
#     END IF
#     SELECT imx00 INTO l_pmlslk.pmlslk04 FROM imx_file,pml_file
#       WHERE imx000=pml04 AND pml01=l_pmk01 AND pml02=l_pml02
#     SELECT ima02 INTO l_pmlslk.pmlslk041 FROM ima_file WHERE ima01=l_pmlslk.pmlslk04

#     SELECT pml07,pml08,pml30,pml31,pml31t,pml33,pml34,pml35,pml44,pml190,pml191,
#            pml192,pml930,pml24,pml25,pml90,pml50,pmlplant,pmllegal
#       INTO l_pmlslk.pmlslk07,l_pmlslk.pmlslk08,l_pmlslk.pmlslk30,l_pmlslk.pmlslk31,
#            l_pmlslk.pmlslk31t,l_pmlslk.pmlslk33,l_pmlslk.pmlslk34,l_pmlslk.pmlslk35,
#            l_pmlslk.pmlslk44,l_pmlslk.pmlslk190,l_pmlslk.pmlslk191,l_pmlslk.pmlslk192,
#            l_pmlslk.pmlslk930,l_pmlslk.pmlslk24,l_pmlslk.pmlslk25,l_pmlslk.pmlslk90,
#            l_pmlslk.pmlslk50,l_pmlslk.pmlslkplant,l_pmlslk.pmlslklegal
#       FROM pml_file
#      WHERE pml01=l_pmk01 AND pml02=l_pml02

#     SELECT DISTINCT oebislk03 INTO l_pmlslk.pmlslk25 FROM oebi_file 
#        WHERE oebi01=l_pmlslk.pmlslk24 AND oebi03=l_pmlslk.pmlslk25
#     IF cl_null(l_pmlslk.pmlslk30) THEN
#        LET l_pmlslk.pmlslk30=0
#     END IF
#     IF cl_null(l_pmlslk.pmlslk31) THEN
#        LET l_pmlslk.pmlslk31=0
#     END IF
#     IF cl_null(l_pmlslk.pmlslk31t) THEN
#        LET l_pmlslk.pmlslk31t=0
#     END IF
#     IF cl_null(l_pmlslk.pmlslk44) THEN
#        LET l_pmlslk.pmlslk44=0
#     END IF 
#     INSERT INTO pmlslk_file VALUES(l_pmlslk.*)
#     IF STATUS THEN
#        CALL cl_err3("ins","pmlslk_file","","",SQLCA.sqlcode,"","ins pmlslk",1)
#        LET g_success = 'N'
#        EXIT FOREACH
#     ELSE
#        UPDATE pmli_file SET pmlislk02=l_pmlslk.pmlslk04,
#                             pmlislk03=l_pmlslk.pmlslk02
#          WHERE pmli01=l_pmk01
#            AND pmli02 IN (SELECT pml02 FROM pml_file,imx_file
#                            WHERE pml01=l_pmk01
#                              AND pml04=imx000
#                              AND imx00=l_pmlslk.pmlslk04)
#        IF STATUS THEN
#           CALL cl_err3("upd","pmli_file","","",SQLCA.sqlcode,"","",1)
#           LET g_success = 'N'
#           EXIT FOREACH
#        END IF
#     END IF

#     SELECT SUM(pmlslk20) INTO l_pmlslk.pmlslk20
#      FROM pmlslk_file,pmk_file
#      WHERE pmlslk24 = l_pmlslk.pmlslk24
#        AND pmlslk25 = l_pmlslk.pmlslk25
#        AND pmlslk01 = pmk01
#        AND pmk18 <> 'X'
# #要回寫每張訂單的己拋量和請購單號
#     UPDATE oebslk_file SET oebslk28 = l_pmlslk.pmlslk20 
#                  WHERE oebslk01 = l_pmlslk.pmlslk24 
#                    AND oebslk03 = l_pmlslk.pmlslk25
#  END FOREACH
   
END FUNCTION
#FUN-B90101--add--end--
 
FUNCTION t400sub_exp(p_oea01,p_tag,p_buf)   #TQC-730022
  DEFINE p_oea01  LIKE oea_file.oea01,   #TQC-730022
         p_tag    LIKE type_file.chr1,   #TQC-730022
         l_buf    LIKE oay_file.oayslip, #TQC-730022
         p_buf    LIKE oay_file.oayslip  #TQC-730022
  DEFINE l_pmk RECORD LIKE pmk_file.*     #TQC-730022
 
  DEFINE l_pmk01  LIKE pmk_file.pmk01,
         l_oea40  LIKE oea_file.oea40
  DEFINE l_oeb12  LIKE oeb_file.oeb12
  DEFINE l_oeb28  LIKE oeb_file.oeb28
  DEFINE l_oeb24  LIKE oeb_file.oeb24
  DEFINE l_oeb03  LIKE oeb_file.oeb03  #TQC-730022
  DEFINE l_sql    STRING 
  DEFINE l_cnt    LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_cnt1   LIKE type_file.num5    #No.CHI-840016
  DEFINE tm RECORD
         wc       STRING,                 #MOD-960117
         oeb01    LIKE oeb_file.oeb01,
         oeb03    LIKE oeb_file.oeb03,
         slip     LIKE oay_file.oayslip  #No.FUN-680137 VARCHAR(5)
         END RECORD 
  DEFINE l_slip  LIKE oay_file.oayslip #FUN-730018
  DEFINE l_prog_t STRING
  DEFINE l_oea   RECORD LIKE oea_file.*
  DEFINE l_gfa   RECORD LIKE gfa_file.*
  DEFINE p_row,p_col LIKE type_file.num5
  DEFINE li_cnt   LIKE type_file.num5     #No.FUN-870033
  DEFINE li_success   STRING              #No.FUN-870033  
  DEFINE l_chr    STRING              #No.FUN-A80012
  DEFINE l_oeb04  LIKE oeb_file.oeb04  #CHI-A80006 add
  DEFINE l_oeb05  LIKE oeb_file.oeb05  #CHI-A80006 add
  DEFINE l_ima25  LIKE ima_file.ima25  #CHI-A80006 add
  DEFINE l_ima44  LIKE ima_file.ima44  #CHI-A80006 add
  DEFINE l_flag   LIKE type_file.num5  #CHI-A80006 add
  DEFINE l_fac    LIKE img_file.img21  #CHI-A80006 add
  DEFINE l_t      LIKE type_file.num5  #TQC-BC0172 add
  DEFINE l_n      LIKE type_file.num5,  #TQC-C80019  
         p_flag   LIKE type_file.chr1 
  DEFINE li_result LIKE type_file.num5  #MOD-C90187 add
  WHENEVER ERROR CONTINUE                #忽略一切錯誤  #FUN-730018
 
   #重新讀取資料
   SELECT * INTO l_oea.* FROM oea_file
    WHERE oea01=p_oea01
   IF p_tag = 'A' THEN  #由自動拋轉CALL 的
     #截取單據別
     LET l_buf = s_get_doc_no(l_oea.oea01)
     #取自動化設定值
     SELECT * INTO l_gfa.*  FROM gfa_file
       WHERE gfa01 = '1'   #1:axmt410
         AND gfa02 = l_buf
         AND gfa03 = 'apmt420'
         AND gfaacti = 'Y'
     IF cl_null(l_gfa.gfa05) THEN RETURN END IF  #如果無設定單據自動化的資料就不再往下執行
   END IF
 
   IF cl_null(l_oea.oea01) THEN RETURN END IF
   IF l_oea.oea00 = '0' AND l_oea.oea00="A" THEN RETURN END IF  #No.FUN-610053
   IF l_oea.oeaconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   IF l_oea.oeaconf = 'N' THEN
      CALL cl_err('','axm-184',0)
      RETURN
   END IF
 
 
 
  #此訂單已拋採購單,就不可以再次拋轉
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM pmn_file,pmm_file
    WHERE pmn24 = l_oea.oea01
      AND pmm01 = pmn01
      AND pmm18 != 'X' #作廢
   IF l_cnt >0  THEN
       CALL cl_err('','axm-581',0)
       RETURN
   END IF
 
   
  # 單據自動化要產生的且為自動產生的
   IF p_tag='A'  THEN  
     LET l_slip = l_gfa.gfa05
     LET tm.oeb01 = l_oea.oea01
     IF cl_null(p_buf) THEN
       LET tm.slip = l_gfa.gfa05  
     ELSE
       LET tm.slip = p_buf
     END IF
     LET tm.wc = " oeb01 = '", l_oea.oea01 CLIPPED,"'"
   ELSE
      LET p_row = 5 LET p_col = 11
 
      OPEN WINDOW t400sub_exp AT p_row,p_col WITH FORM "axm/42f/axmt400e"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
      #CALL cl_set_comp_visible("a",FALSE)    #TQC-AB0132 add  #FUN-B10047 mark
      CALL cl_set_comp_visible("oeb01",FALSE) 
      CALL cl_ui_locale("axmt400e")
   
   
      WHILE TRUE           #No.MOD-8B0265
      CONSTRUCT BY NAME tm.wc ON oeb01,oeb03    # 螢幕上取單頭條件
   
      BEFORE CONSTRUCT
          LET tm.oeb01 = l_oea.oea01
          DISPLAY tm.oeb01 TO FORMONLY.oeb01
   
         ON ACTION controlp
            CASE
               WHEN INFIELD(oea01) #查詢單据
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_oea11"   #MOD-4A0252
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea01
                    NEXT FIELD oea01
               WHEN INFIELD(oeb03) 
                    CALL q_oeb11(TRUE,TRUE,l_oea.oea01)
                   RETURNING g_qryparam.multiret                                                                                      
                    DISPLAY g_qryparam.multiret TO oeb03
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
   
             END CONSTRUCT
 
#CHI-A80006 mark --start--
#     #此訂單已拋請購單,就不可以再次拋轉                                         
#      LET l_cnt = 0                                                             
#      LET l_sql ="SELECT COUNT(*)",                                             
#                 "  FROM pmk_file,pml_file,oeb_file",   #MOD-960202
#                 " WHERE oeb01 = pml24",                                        
#                 "   AND oeb03 = pml25",                                        
#                 "   AND pmk01 = pml01",   #MOD-960202
#                 "   AND pmk18 != 'X'",    #MOD-960202
#                 "   AND ",tm.wc                                                
#      PREPARE t400sub_sel_pml FROM l_sql                                        
#      EXECUTE t400sub_sel_pml INTO l_cnt                                        
#      IF l_cnt >0  THEN                                                         
#         CALL cl_err('','axm-001',0)                                            
#         CONTINUE WHILE   #MOD-960202
#      ELSE                                                                      
#         EXIT WHILE                                                             
#      END IF         
#CHI-A80006 mark --end--
      #CHI-A80006 add --start--
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW t400sub_exp
         RETURN
      END IF
      #TQC-BC0172--begin
      LET l_sql ="SELECT count(*) FROM oeb_file",
                 " WHERE ",tm.wc
      PREPARE t400sub_sel_oeb FROM l_sql
      EXECUTE t400sub_sel_oeb INTO l_t
      IF l_t=0 THEN 
         CALL cl_err('','axm-974',1)
         CONTINUE WHILE
      END IF            
      #TQC-BC0172--end
      LET l_sql ="SELECT oeb04,oeb05,oeb12,oeb28 ",                                             
                 "  FROM pmk_file,pml_file,oeb_file",
                 " WHERE oeb01 = pml24",                                        
                 "   AND oeb03 = pml25",                                        
                 "   AND pmk01 = pml01",
                 "   AND pmk18 != 'X'",
                 "   AND ",tm.wc                                                
      PREPARE t400sub_sel_pml FROM l_sql                                        
      EXECUTE t400sub_sel_pml INTO l_oeb04,l_oeb05,l_oeb12,l_oeb28                                      
      SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44
        FROM ima_file WHERE ima01=l_oeb04
      IF SQLCA.sqlcode =100 THEN
         IF l_oeb04 MATCHES 'MISC*' THEN
            SELECT ima25,ima44 INTO l_ima25,l_ima44
              FROM ima_file WHERE ima01='MISC'
         END IF
      END IF
      IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
      CALL s_umfchk(l_oeb04,l_ima44,l_oeb05) RETURNING l_flag,l_fac                                                                             
      IF cl_null(l_fac) THEN LET l_fac=1 END IF
      LET l_oeb28 = l_oeb28 * l_fac
      IF l_oeb12 - l_oeb28 <= 0 THEN
         CALL cl_err('','axm-001',0)                                            
         CONTINUE WHILE
      ELSE                                                                      
         EXIT WHILE
      END IF         
      #CHI-A80006 add --end--
      END WHILE    

      LET tm.oeb01 = l_oea.oea01
      DISPLAY tm.oeb01 TO FORMONLY.oeb01
      INPUT BY NAME tm.slip,a  #NO.FUN-670007  #FUN-B10047 add a
        
         #FUN-B10047 add begin ---
         BEFORE INPUT
               LET a = 'N'
               DISPLAY a TO FORMONLY.a
         #FUN-B10047 add end   ---

         AFTER FIELD slip
            IF NOT cl_null(tm.slip) THEN   #NO.FUN-670007
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM smy_file
                WHERE smyslip = tm.slip AND smysys = 'apm' AND smykind = '1' #NO.FUN-670007
               IF SQLCA.sqlcode OR cl_null(tm.slip) THEN  #NO.FUN-670007
                  LET l_cnt = 0
               END IF
               IF l_cnt = 0 THEN
                  CALL cl_err(tm.slip,'aap-010',0)        #NO.FUN-670007
                  NEXT FIELD slip
               END IF
            END IF
            LET l_slip = tm.slip
   
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            CLOSE WINDOW t400sub_exp
            RETURN
         END IF
   
         ON ACTION controlp
            CASE
               WHEN INFIELD(slip)
                    CALL q_smy(FALSE,TRUE,tm.slip,'apm','1') RETURNING tm.slip
                     DISPLAY BY NAME tm.slip         #NO.FUN-670007
                    NEXT FIELD slip
               OTHERWISE EXIT CASE
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
         CLOSE WINDOW t400sub_exp
         RETURN
      END IF
  END IF
 
   LET g_success = 'Y'  #MOD-8A0086
   #MOD-B90127 add ----begin---------
   CREATE TEMP TABLE apm_p470(
       part     LIKE sfa_file.sfa03,
       sfa26    LIKE sfa_file.sfa26,
       sfb25    LIKE sfb_file.sfb25,    #實際開工日
       req_qty  LIKE sfa_file.sfa04,
       al_qty   LIKE sfa_file.sfa04,
       pr_qty   LIKE sfa_file.sfa04,
       po_qty   LIKE sfa_file.sfa04,
       qc_qty   LIKE sfa_file.sfa04,
       wo_qty   LIKE sfa_file.sfa04)

   CREATE UNIQUE INDEX p470_t1
       ON apm_p470 (part,sfa26,sfb25)

   DROP TABLE pml_file_temp
   SELECT * FROM pml_file WHERE 1= 0 #131122
     INTO TEMP pml_file_temp

   DROP TABLE sfamm_file_temp
   SELECT  * FROM SFA_FILE  WHERE 1=0 #131122
     INTO TEMP sfamm_file_temp
   #MOD-B90127 add -----end----------
   BEGIN WORK           #MOD-8A0086
   # -------------------------訂單數量-己轉請購量>0 才可拋轉
   LET l_oeb12 = 0
   LET l_oeb28 = 0
   LET l_oeb24 = 0
 
   LET l_sql = "SELECT oeb03,oeb12,oeb28,oeb24,oeb04,oeb05 ",  #TQC-730022 add oeb03 #CHI-A80006 add oeb04,oeb05
               "  FROM oeb_file ",
               " WHERE ",tm.wc,
               "   ORDER BY oeb03 " 
  
   PREPARE t400sub_exp_pre FROM l_sql
   IF SQLCA.sqlcode THEN CALL cl_err('t400sub_exp_pre',STATUS,1) END IF
   DECLARE t400sub_exp_c CURSOR FOR t400sub_exp_pre
   IF SQLCA.sqlcode THEN CALL cl_err('t400sub_exp_c',STATUS,1) END IF
   LET l_cnt = 1
   #MOD-C90187 add --start--
   CALL s_auto_assign_no("apm",tm.slip,g_today,"","pmk_file","pmk01","","","")
        RETURNING li_result,l_pmk01
   IF (NOT li_result) THEN
      LET g_success ='N'
      ROLLBACK WORK
      CLOSE WINDOW t400sub_exp
      RETURN
   END IF
   #MOD-C90187 add --end--
   CALL s_showmsg_init()                 #No.FUN-710046
   LET g_oeb03 = 0    #MOD-910210
   FOREACH t400sub_exp_c INTO l_oeb03,l_oeb12,l_oeb28,l_oeb24,l_oeb04,l_oeb05  #項次/訂單數量/己轉請購量/己交量/產品編號/銷售單位   #TQC-730022 add oeb03 #CHI-A80006 add oeb04,oeb05
   IF g_success = "N" THEN                                                                                                        
      LET g_totsuccess = "N"                                                                                                      
      LET g_success = "Y"                                                                                                         
   END IF                                                                                                                         
     #CHI-A80006 add --start--
     SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44
       FROM ima_file WHERE ima01=l_oeb04
     IF SQLCA.sqlcode =100 THEN
        IF l_oeb04 MATCHES 'MISC*' THEN
           SELECT ima25,ima44 INTO l_ima25,l_ima44
             FROM ima_file WHERE ima01='MISC'
        END IF
     END IF
     IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
     CALL s_umfchk(l_oeb04,l_ima44,l_oeb05) RETURNING l_flag,l_fac                                                                             
     IF cl_null(l_fac) THEN LET l_fac=1 END IF
     LET l_oeb28 = l_oeb28 * l_fac
     #CHI-A80006 add --end--
     IF l_oeb12 - l_oeb28 <= 0 THEN
         CONTINUE FOREACH
     ELSE
        #有出貨紀錄不可再拋請購單
        IF l_oea.oea62 != 0 THEN 
           LET l_cnt1=0 
           SELECT COUNT(*) INTO l_cnt1
             FROM ogb_file,oga_file
            WHERE ogb31=l_oea.oea01
              AND ogb32=l_oeb03
              AND ogb01=oga01
              AND ogaconf != 'X'
           IF l_cnt1 >0 THEN
            IF g_bgerr THEN
               LET g_showmsg = l_oea.oea01,"/",l_oeb03
               CALL s_errmsg('oea01,oeb03',g_showmsg,'oea01/oeb03','axm-002',1)
            ELSE
               CALL cl_err('l_oea.oea01/l_oeb03','axm-002',1)
            END IF
            LET li_success = 'N'                                    #FUN-870033
              CONTINUE FOREACH 
           END IF
        END IF
         IF l_cnt = 1 THEN
             #CALL t400sub_ins_pmk(tm.slip,l_oea.oea84) RETURNING l_pmk01 #No.FUN-870007   #MOD-C90187 mark
            #CALL t400sub_ins_pmk(l_pmk01,l_oea.oea84)   #MOD-C90187 add #FUN-CC0082 Mark
             CALL t400sub_ins_pmk(l_pmk01,l_oea.oea84,l_oea.oea95)       #FUN-CC0082 Add
#FUN-A80012 --modify
            #CALL t400sub_ins_pml_exp(l_pmk01,p_oea01,l_oeb03)  #TQC-730022加項次避免重覆
            IF a = 'Y' THEN
               LET l_chr = "oea01='",p_oea01,"' AND oeb03=",l_oeb03
               CALL p500("",l_pmk01,l_chr)
            ELSE
               CALL t400sub_ins_pml_exp(l_pmk01,p_oea01,l_oeb03)
            END IF
         ELSE 
            #CALL t400sub_ins_pml_exp(l_pmk01,p_oea01,l_oeb03)  #TQC-730022加項次避免重覆
            IF a = 'Y' THEN
               LET l_chr = "oea01='",p_oea01,"'AND oeb03=",l_oeb03
               CALL p500("",l_pmk01,l_chr)
            ELSE
               CALL t400sub_ins_pml_exp(l_pmk01,p_oea01,l_oeb03)
            END IF 
#FUN-A80012 --end
         END IF
         LET l_cnt = l_cnt + 1
     END IF
   END FOREACH
   IF cl_null(l_pmk01) THEN LET g_success="N" END IF  #MOD-C30604 add  #TQC-C20362 modify
   #TQC-C80019----add begin 120803
   #判斷是否含有備品
    SELECT COUNT(*) INTO l_n FROM oeo_file
     WHERE oeo01 = p_oea01
       AND oeo08 = '2'  #no.7168
    #IF l_n <= 0 THEN RETURN END IF #TQC-C80033 add
    IF l_n > 0 THEN #TQC-C80033 add
       IF  cl_confirm('axm-803') THEN
          IF a='Y' THEN 
              #如果按照bom展開訂單到請購單,取得當前請購單的最大項次
             SELECT MAX(pml02) INTO g_oeb03 FROM pml_file
              WHERE pml01 = l_pmk01
             IF cl_null(g_oeb03) THEN LET g_oeb03 = 0 END IF                 
          END IF
          LET l_sql = "SELECT oeb03 ",
                     "  FROM oeb_file ",
                     " WHERE ",tm.wc,
                     " AND oeb1003!='2'"    
          PREPARE t400sub_exp_pre2 FROM l_sql
          IF SQLCA.sqlcode THEN CALL cl_err('t400sub_exp_pre2',STATUS,1) END IF
          DECLARE t400sub_exp_c2 CURSOR FOR t400sub_exp_pre2
          IF SQLCA.sqlcode THEN CALL cl_err('t400sub_exp_c2',STATUS,1) END IF
          CALL s_showmsg_init()
          FOREACH t400sub_exp_c2 INTO l_oeb03  
             IF g_success = "N" THEN                                                                                                        
                LET g_totsuccess = "N"                                                                                                      
                LET g_success = "Y"                                                                                                         
             END IF        
             #產生備品資料 	
             CALL t400sub_ins_pml2_exp(l_pmk01,p_oea01,l_oeb03)
          END FOREACH            
       END IF   
   END IF  #TQC-C80033 add
   #TQC-C80019----add end 120803
   IF g_totsuccess="N" THEN                                                                                                       
      LET g_success="N"                                                                                                           
   END IF                                                                                                                         
    CALL s_showmsg()         #CHI-840016 add
  #IF li_success = 'N' OR g_success = 'N' THEN                               #FUN-870033   #MOD-C90187 mark
   IF li_success = 'N' OR g_success = 'N' OR l_cnt <= 1 THEN                               #MOD-C90187 add
       ROLLBACK WORK                                                         #MOD-C30604 add
       CALL cl_err('','axm-558',1)                                           #FUN-870033
       CLOSE WINDOW t400sub_exp                                              #FUN-870033
   ELSE                                                                      #FUN-870033                                                                              
   CALL t400sub_upd_oea(l_pmk01,l_oea.oea01)
   IF g_success = 'Y' THEN
      #FUN-B90101--add--begin--
      IF s_industry("slk") THEN
         IF g_azw.azw04 = '2' THEN   #FUN-C20006 add
            CALL t400sub_ins_pmlslk_exp(l_pmk01,l_oea.oea01)
         END IF                      #FUN-C20006 add 
      END IF
      #FUN-B90101--add--end--
       COMMIT WORK
       LET l_prog_t = g_prog
       LET g_prog = 'apmt420'
       CALL cl_flow_notify(l_pmk01,'I')
       LET g_prog = l_prog_t
       #MESSAGE "已轉請購單號:",l_pmk01 #FUN-730018
       IF cl_null(p_tag) THEN  #TQC-730022
             CALL cl_err(l_pmk01,'axm-559',1)                                  #FUN-870033
       ELSE
          IF l_gfa.gfa06 = 'Y'  THEN   #執行請購單自動確認
             SELECT pmk_file.* INTO l_pmk.* 
               FROM pmk_file 
              WHERE pmk01 = l_pmk01
 
             CALL t420sub_y_chk(l_pmk.pmk01)  #CALL 原確認的 check 段
             IF g_success = "Y" THEN
                 CALL t420sub_y_upd(l_pmk.pmk01,'')      #CALL 原確認的 update 段
             END IF
          END IF
       END IF   #TQC-730022 end
   ELSE
       ROLLBACK WORK
       LET l_oea.oea40 = ''
   END IF
   CLOSE WINDOW t400sub_exp
  END IF                                                                     #FUN-870033                            
END FUNCTION
 
FUNCTION t400sub_upd_oea(p_pmk01,l_oea01)
 DEFINE p_pmk01 LIKE pmk_file.pmk01
 DEFINE l_oea40 LIKE oea_file.oea40
 DEFINE l_oea01 LIKE oea_file.oea01
 
   LET l_oea40 = p_pmk01
   UPDATE oea_file SET oea40 = l_oea40
    WHERE oea01 = l_oea01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL s_errmsg("oea01",l_oea01,"UPD oea_file",SQLCA.sqlcode,1)           #No.FUN-710046
      LET g_success = 'N'
   END IF
 
END FUNCTION
 
#FUNCTION t400sub_ins_pmk(l_slip,p_oea84)  #No.FUN-870007   #MOD-C90187 mark
#FUNCTION t400sub_ins_pmk(p_pmk01,p_oea84)  #No.FUN-870007   #MOD-C90187 add  #FUN-CC0082 Mark
FUNCTION t400sub_ins_pmk(p_pmk01,p_oea84,p_oea95)                             #FUN-CC0082 Add
 DEFINE l_pmk    RECORD LIKE pmk_file.*
#DEFINE li_result LIKE type_file.num5    #No.FUN-680137 SMALLINT   #MOD-C90187 mark
#DEFINE l_slip   LIKE type_file.chr5                               #MOD-C90187 mark
 DEFINE p_oea84 LIKE oea_file.oea84  #No.FUN-870007
 DEFINE p_pmk01 LIKE pmk_file.pmk01  ##MOD-C90187 add
 DEFINE p_oea95 LIKE oea_file.oea95  #FUN-CC0082 Add
 
   INITIALIZE l_pmk.* TO NULL
   #MOD-C90187 -- mark start -- 
   #CALL s_auto_assign_no("apm",l_slip,g_today,"","pmk_file","pmk01","","","")             #No.FUN-560132
   #     RETURNING li_result,l_pmk.pmk01
   #MOD-C90187 -- mark end --
   LET l_pmk.pmk01 = p_pmk01      #MOD-C90187 add
   LET l_pmk.pmk02 = 'REG'       #單號性質
   LET l_pmk.pmk03 = '0'
   LET l_pmk.pmk04 = g_today     #請購日期
   LET l_pmk.pmk12 = g_user
   LET l_pmk.pmk13 = g_grup
   LET l_pmk.pmk18 = 'N'
   LET l_pmk.pmk25 = '0'         #開立
   LET l_pmk.pmk27 = g_today
   LET l_pmk.pmk30 = 'Y'
   LET l_pmk.pmk40 = 0           #總金額
   LET l_pmk.pmk401= 0           #總金額
   LET l_pmk.pmk42 = 1           #匯率
   LET l_pmk.pmk43 = 0           #稅率
   LET l_pmk.pmk45 = 'Y'         #可用
   LET l_pmk.pmk50 = p_oea95     #生产门店 #FUN-CC0082 Add
   SELECT smyapr,smysign INTO l_pmk.pmkmksg,l_pmk.pmksign   #NO:5012
     FROM smy_file
    WHERE smyslip = l_slip
   IF SQLCA.sqlcode OR cl_null(l_pmk.pmkmksg) THEN
      LET l_pmk.pmkmksg = 'N'
      LET l_pmk.pmksign= NULL
   END IF
   LET l_pmk.pmkdays = 0         #簽核天數
   LET l_pmk.pmksseq = 0         #應簽順序
   LET l_pmk.pmkprno = 0         #列印次數
   CALL signm_count(l_pmk.pmksign) RETURNING l_pmk.pmksmax
   LET l_pmk.pmkacti ='Y'        #有效的資料
   LET l_pmk.pmkuser = g_user    #使用者
   LET l_pmk.pmkgrup = g_grup    #使用者所屬群
   LET l_pmk.pmkdate = g_today
   IF g_azw.azw04='2' THEN
      LET l_pmk.pmk46='3'
      LET l_pmk.pmk47=p_oea84
   ELSE
      #LET l_pmk.pmk46='1'       #MOD-C10218 mark
      LET l_pmk.pmk46='3'        #MOD-C10218 add
      LET l_pmk.pmk47=''
   END IF
   LET l_pmk.pmkcond= ''             #審核日期
   LET l_pmk.pmkconu= ''             #審核時間
   LET l_pmk.pmkcrat= g_today        #資料創建日
   LET l_pmk.pmkplant = g_plant        #機構別
   LET l_pmk.pmklegal = g_legal        #FUN-980010 add
   LET l_pmk.pmkoriu = g_user      #No.FUN-980030 10/01/04
   LET l_pmk.pmkorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO pmk_file VALUES(l_pmk.*)     #DISK WRITE
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL s_errmsg("pmk01",l_pmk.pmk01,"ins pmk",SQLCA.sqlcode,1)        #No.FUN-710046
      LET g_success = 'N'
   END IF           #NO.FUN-670007  add
  #RETURN l_pmk.pmk01   #MOD-C90187 mark
 
END FUNCTION        #NO.FUN-670007  add
 
FUNCTION t400sub_ins_pml_exp(l_pmk01,p_oea01,p_oeb03)
 DEFINE l_pmk01  LIKE pmk_file.pmk01   
 DEFINE l_oeo    RECORD LIKE oeo_file.*
 DEFINE l_oeb03  LIKE oeb_file.oeb03  #No.+186 add
 DEFINE p_oeb03  LIKE oeb_file.oeb03  #TQC-730022 add
 DEFINE l_qty    LIKE oeb_file.oeb12
 DEFINE l_oeb01  LIKE oeb_file.oeb01  #NO.FUN-670007
 DEFINE l_oeb    RECORD LIKE oeb_file.*
 DEFINE p_oea01  LIKE oea_file.oea01
 
      DECLARE t400sub_oeb_curs1 CURSOR FOR
       SELECT * FROM oeb_file
        WHERE oeb01 = p_oea01
          AND oeb03 = p_oeb03     #TQC-730022 add
          AND oeb1003!='2'   #TQC-640085
      FOREACH t400sub_oeb_curs1 INTO l_oeb.*
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('','',"foreach:",SQLCA.sqlcode,1)  #No.FUN-710046
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         LET g_oeb03 = g_oeb03+1   #MOD-910210
          CALL t400sub_ins_pml(l_pmk01,l_oeb.oeb01,l_oeb.oeb03,l_oeb.oeb04,    #NO.FUN-670007
                            l_oeb.oeb05_fac,l_oeb.oeb12,l_oeb.oeb15,
                            l_oeb.oeb05,l_oeb.oeb06,
                            l_oeb.oeb910,l_oeb.oeb911,l_oeb.oeb912,
                            l_oeb.oeb913,l_oeb.oeb914,l_oeb.oeb915,
                            l_oeb.oeb916,l_oeb.oeb917,
                            l_oeb.oeb41,l_oeb.oeb42,l_oeb.oeb43,l_oeb.oeb1001,   #FUN-810045
                            g_oeb03,l_oeb.oeb44,  #MOD-910210 #No.FUN-870007-add oeb44
                            l_oeb.oeb919                #FUN-A90059 add
                            ) #BugNo:6097
#TQC-C80019 mark begin----120803 
#         DECLARE oeo_cus CURSOR FOR
#             SELECT *
#               FROM oeo_file
#              WHERE oeo01 = p_oea01
#                AND oeo03 = l_oeb.oeb03
#         FOREACH oeo_cus INTO l_oeo.*
#              IF SQLCA.SQLCODE THEN
#                 CALL s_errmsg('','',"sel oeo:",SQLCA.sqlcode,0)   #No.FUN-710046
#              END IF
#              LET g_oeb03 = g_oeb03+1   #MOD-910210
#              LET l_qty = l_oeb.oeb12 * l_oeo.oeo06
#              #CALL t400sub_ins_pml(l_pmk01,l_oeb01,l_oeb.oeb03,l_oeo.oeo04,    #NO.FUN-670007    #MOD-910210   #MOD-A20119
#              CALL t400sub_ins_pml(l_pmk01,l_oeb.oeb01,l_oeb.oeb03,l_oeo.oeo04,    #NO.FUN-670007    #MOD-910210   #MOD-A20119
#                                 l_oeb.oeb05_fac,l_qty,l_oeb.oeb15,
#                                 l_oeo.oeo05,l_oeo.oeo04,
#                                 l_oeb.oeb910,l_oeb.oeb911,l_oeb.oeb912,
#                                 l_oeb.oeb913,l_oeb.oeb914,l_oeb.oeb915,
#                                 l_oeb.oeb916,l_oeb.oeb917,
#                                 l_oeb.oeb41,l_oeb.oeb42,l_oeb.oeb43,l_oeb.oeb1001,   #FUN-810045
#                                 g_oeb03,l_oeb.oeb44,  #MOD-910210 #No.FUN-870007-add oeb44
#                                 l_oeb.oeb919            #FUN-A90059 add
#                                 ) #BugNo:6097
#         END FOREACH
#TQC-C80019 mark end----120803      
      END FOREACH
 
END FUNCTION
 
FUNCTION t400sub_pml_ini(p_pmk01)
  DEFINE p_pmk01 LIKE pmk_file.pmk01,
         l_pmk02 LIKE pmk_file.pmk02,
         l_pmk25 LIKE pmk_file.pmk25,
         l_pmk13 LIKE pmk_file.pmk13
  DEFINE l_pml   RECORD LIKE pml_file.*
 
   INITIALIZE l_pml.* TO NULL     #MOD-720009
   SELECT pmk02,pmk25,pmk13 INTO l_pmk02,l_pmk25,l_pmk13
     FROM pmk_file WHERE pmk01 = p_pmk01
   LET l_pml.pml01 = p_pmk01               LET l_pml.pml011 = l_pmk02
   LET l_pml.pml16 = l_pmk25
   LET l_pml.pml14 = g_sma.sma886[1,1]     LET l_pml.pml15  =g_sma.sma886[2,2]
   LET l_pml.pml23 = 'Y'                   LET l_pml.pml38  ='Y'
   LET l_pml.pml43 = 0                     LET l_pml.pml431 = 0
   LET l_pml.pml11 = 'N'                   LET l_pml.pml13  = 0
   LET l_pml.pml21  = 0
   LET l_pml.pml30 = 0                     LET l_pml.pml32 = 0
   LET l_pml.pml930=s_costcenter(l_pmk13) #FUN-730018
   LET l_pml.pmlplant=g_plant  #No.FUN-870007
   LET l_pml.pmllegal=g_legal  #No.FUN-870007
   RETURN l_pml.*
END FUNCTION
 
FUNCTION t400sub_ins_pml(p_pmk01,p_oeb01,p_oeb03,p_oeb04,p_oeb05_fac,p_oeb12,  #NO.FUN-670007
                         p_oeb15,p_oeb05,p_oeb06,   #NO.FUN-670007
                         p_oeb910,p_oeb911,p_oeb912,p_oeb913,p_oeb914,
                         p_oeb915,p_oeb916,p_oeb917,p_oeb41,p_oeb42,p_oeb43,p_oeb1001,p_oeb03_2,p_oeb44,  #FUN-810045 add oeb41-43/1001   #MOD-910210 增加p_oeb03_2 #No.FUN-870007-add oeb44
                         p_oeb919)              #FUN-A90059 add
  DEFINE p_pmk01     LIKE pmk_file.pmk01,
         p_oeb01     LIKE oeb_file.oeb01,    #NO.FUN-670007
         p_oeb03     LIKE oeb_file.oeb03,
         p_oeb04     LIKE oeb_file.oeb04,
         p_oeb05_fac LIKE oeb_file.oeb05_fac,
         p_oeb05     LIKE oeb_file.oeb05,
         p_oeb06     LIKE oeb_file.oeb06,
         p_oeb12     LIKE oeb_file.oeb12,
         p_oeb15     LIKE oeb_file.oeb15,
         p_oeb28     LIKE oeb_file.oeb28,    #NO.FUN-670007
         p_oeb24     LIKE oeb_file.oeb24,    #NO.FUN-670007 
         p_oeb910    LIKE oeb_file.oeb910,
         p_oeb911    LIKE oeb_file.oeb911,
         p_oeb912    LIKE oeb_file.oeb912,
         p_oeb913    LIKE oeb_file.oeb913,
         p_oeb914    LIKE oeb_file.oeb914,
         p_oeb915    LIKE oeb_file.oeb915,
         p_oeb916    LIKE oeb_file.oeb916,
         p_oeb917    LIKE oeb_file.oeb917,
         p_oeb41     LIKE oeb_file.oeb41,
         p_oeb42     LIKE oeb_file.oeb42,
         p_oeb43     LIKE oeb_file.oeb43,
         p_oeb1001   LIKE oeb_file.oeb1001,
         p_oeb03_2   LIKE oeb_file.oeb03,   #MOD-910210
         p_oeb44     LIKE oeb_file.oeb44,   #No.FUN-870007
         p_oeb919    LIKE oeb_file.oeb919,   #FUN-A90059 add
         l_ima01     LIKE ima_file.ima01,
         l_ima02     LIKE ima_file.ima02,
         l_ima05     LIKE ima_file.ima05,
         l_ima25     LIKE ima_file.ima25,
         l_ima27     LIKE ima_file.ima27,
#         l_ima262    LIKE ima_file.ima262, #FUN-A20044
         l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk    LIKE type_file.num15_3, #FUN-A20044
         l_ima44     LIKE ima_file.ima44,
         l_ima44_fac LIKE ima_file.ima44_fac,
         l_ima45     LIKE ima_file.ima45,
         l_ima46     LIKE ima_file.ima46,
         l_ima49     LIKE ima_file.ima49,
         l_ima491    LIKE ima_file.ima491,
         l_ima913    LIKE ima_file.ima913,   #CHI-6A0016
         l_ima914    LIKE ima_file.ima914,   #CHI-6A0016
         l_pan       LIKE type_file.num10,   #No.FUN-680137 INTEGER
         l_flag      LIKE type_file.chr1,    #No.TQC-740351
         l_double    LIKE type_file.num10    #No.FUN-680137 INTEGER
   DEFINE l_pml      RECORD LIKE pml_file.*  #FUN-730018
   DEFINE l_oeb      RECORD LIKE oeb_file.*  #FUN-730018
   DEFINE l_pmli     RECORD LIKE pmli_file.* #No.FUN-830132 add
   DEFINE l_rty03 LIKE rty_file.rty03        #No.FUN-870007                                                               
   DEFINE l_rty06 LIKE rty_file.rty06        #No.FUN-870007
 
   CALL t400sub_pml_ini(p_pmk01) RETURNING l_pml.* #FUN-730018
 
   LET l_ima913 = 'N'   #MOD-770033 add
   IF p_oeb04[1,4] <> "MISC" THEN
#       SELECT ima01,ima02,ima05,ima25,ima262,ima27,ima44,ima44_fac, #FUN-A20044
       SELECT ima01,ima02,ima05,ima25,0,ima27,ima44,ima44_fac, #FUN-A20044
              ima45,ima46,ima49,ima491,
              ima913,ima914         #CHI-6A0016
         INTO l_ima01,l_ima02,l_ima05,l_ima25,l_avl_stk,l_ima27,
              l_ima44,l_ima44_fac,l_ima45,l_ima46,l_ima49,l_ima491,
              l_ima913,l_ima914       #CHI-6A0016
         FROM ima_file
        WHERE ima01 = p_oeb04
       CALL s_getstock(p_oeb04,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
       IF SQLCA.sqlcode THEN
           CALL s_errmsg("ima01",p_oeb04,"sel ima:",SQLCA.sqlcode,1)     #No.FUN-710046
           LET g_success = 'N'
           RETURN
       END IF
       LET l_pml.pml02 = p_oeb03_2   #MOD-910210
       LET l_pml.pml49 = p_oeb44    #No.FUN-870007
       LET l_pml.pml04 = l_ima01
       LET l_pml.pml041= l_ima02
       LET l_pml.pml05 = NULL      #no.4649(APS單據編號)
       LET l_pml.pml07 = l_ima44      #No.TQC-740351
       LET l_pml.pml08 = l_ima25
       CALL s_umfchk(l_pml.pml04,l_pml.pml07,                                                                                     
            l_pml.pml08) RETURNING l_flag,l_pml.pml09                                                                             
            IF cl_null(l_pml.pml09) THEN LET l_pml.pml09=1 END IF
      #先將訂單數量轉換成請購單位數量                                                                                               
       LET p_oeb12 = p_oeb12 * p_oeb05_fac / l_pml.pml09
       LET p_oeb28=0
       LET p_oeb24=0
       SELECT oeb28,oeb24 INTO p_oeb28,p_oeb24 
         FROM oeb_file
        WHERE oeb01=p_oeb01
          AND oeb03=p_oeb03
       IF cl_null(p_oeb28) THEN LET p_oeb28 = 0 END IF
       IF cl_null(p_oeb24) THEN LET p_oeb24 = 0 END IF
       LET p_oeb12 = (p_oeb12-p_oeb28-p_oeb24) 
       LET l_pml.pml42 = '0'
    IF g_sma.sma115='N' THEN      #No.TQC-740351
       #-->考慮最少採購量/倍量
       IF p_oeb12 > 0 THEN  #FUN-730018
            IF p_oeb12 < l_ima46 THEN #FUN-730018
              #CALL s_sizechk(l_pml.pml04,p_oeb12,g_lang)              #CHI-C10037 mark                                                            
               CALL s_sizechk(l_pml.pml04,p_oeb12,g_lang,l_pml.pml07)  #CHI-C10037 add
                             RETURNING l_pml.pml20
           ELSE
               IF l_ima45 > 0 THEN
                   LET l_pan = (p_oeb12 * 1000) / (l_ima45 * 1000)
                   IF (l_pan*(l_ima45*1000)) > (p_oeb12 * 1000) THEN
                       LET l_pan=(p_oeb12*1000) -((l_pan-1)*(l_ima45*1000))
                   ELSE
                       LET l_pan=(p_oeb12*1000) -(l_pan*(l_ima45*1000))
                   END IF
 
                   IF l_pan !=0 THEN
                       LET l_double = (p_oeb12/l_ima45) + 1
                   ELSE
                       LET l_double = p_oeb12/l_ima45
                   END IF
                   LET l_pml.pml20  = l_double * l_ima45
               ELSE
                   LET l_pml.pml20 = p_oeb12
               END IF
               LET l_pml.pml20 = s_digqty(l_pml.pml20,l_pml.pml07)   #No.FUN-BB0086
           END IF
       ELSE
           LET l_pml.pml20 = 0
       END IF
    ELSE      #No.TQC-740351
       LET l_pml.pml20 = p_oeb12      #No.TQC-740351
    END IF      #No.TQC-740351
       LET l_pml.pml35 = p_oeb15                 #到庫日期
       CALL s_aday(l_pml.pml35,-1,l_ima491) RETURNING l_pml.pml34 #No.TQC-640132
       CALL s_aday(l_pml.pml34,-1,l_ima49) RETURNING l_pml.pml33  #No.TQC-640132
   ELSE
       LET l_pml.pml02 = p_oeb03_2   #MOD-910210
       LET l_pml.pml04 = p_oeb04
       LET l_pml.pml041= p_oeb06
       LET l_pml.pml05 = NULL
       LET l_pml.pml07 = p_oeb05
       LET l_pml.pml08 = p_oeb05
       LET l_pml.pml09 = 1
       LET l_pml.pml42 = '0'
       LET l_pml.pml20 = p_oeb12                     #MOD-830126 cancel mark
       LET l_pml.pml35 = p_oeb15
       CALL s_aday(l_pml.pml35,-1,l_ima491) RETURNING l_pml.pml34  #No.TQC-640132
       CALL s_aday(l_pml.pml34,-1,l_ima49) RETURNING l_pml.pml33   #No.TQC-640132
   END IF
   LET l_pml.pml80 = p_oeb910
   LET l_pml.pml81 = p_oeb911
   LET l_pml.pml82 = p_oeb912
   LET l_pml.pml83 = p_oeb913
   LET l_pml.pml84 = p_oeb914
   LET l_pml.pml85 = p_oeb915
   LET l_pml.pml86 = p_oeb916
   LET l_pml.pml12 = p_oeb41
   LET l_pml.pml121 = p_oeb42
   LET l_pml.pml122 = p_oeb43
#   LET l_pml.pml90 = p_oeb1001     #MOD-C30368 mark
   LET l_pml.pml919 = p_oeb919    #FUN-A90059 add
   IF g_sma.sma116 MATCHES'[13]' THEN
      LET l_pml.pml86 = p_oeb916
   ELSE
      LET l_pml.pml86 = l_pml.pml07
   END IF
   LET g_pml.* = l_pml.*      #No.TQC-740351
   CALL t400_set_pml87()      #No.TQC-740351
   LET l_pml.pml87=g_pml.pml87      #No.TQC-740351
 
 
   LET l_pml.pml190 = l_ima913    #統購否
   LET l_pml.pml191 = l_ima914    #採購成本中心
   LET l_pml.pml192 = 'N'         #拋轉否
 
   LET l_pml.pml24 = p_oeb01
   LET l_pml.pml25 = p_oeb03
   IF g_azw.azw04='2' THEN
      LET l_pml.pml47 = ''
      SELECT rty03,rty06 INTO l_rty03,l_rty06 FROM rty_file                                                                     
       WHERE rty01=g_plant AND rty02=p_oeb04                                                                            
      IF SQLCA.sqlcode=100 THEN                                                                                           
         LET l_rty03=NULL                                                                                                   
         LET l_rty06=NULL                                                                                                   
      END IF                                                                                                              
      LET l_pml.pml49=l_rty06                                                                                                 
      LET l_pml.pml50=l_rty03                                                                                                 
      IF l_pml.pml50='2' THEN                                                                                                 
         LET l_pml.pml51=g_plant                                                                                         
         LET l_pml.pml52=p_pmk01                                                                                          
         LET l_pml.pml53=l_pml.pml02                                                                                    
      ELSE                                                                                                                          
         LET l_pml.pml51=''                                                                                                   
         LET l_pml.pml52=''                                                                                                   
         LET l_pml.pml53=''                                                                                                   
      END IF           
      SELECT rty05 INTO l_pml.pml48 FROM rty_file
       WHERE rty01= (SELECT oea84 FROM oea_file WHERE oea01=p_oeb01)
         AND rtyacti='Y' AND rty02=p_oeb04
      IF SQLCA.sqlcode=100 THEN
         SELECT rty05 INTO l_pml.pml48 FROM rty_file                                                                 
          WHERE rty01=g_plant AND rtyacti='Y' AND rty02=p_oeb04                                                  
         IF SQLCA.sqlcode=100 THEN                                                                                              
            LET l_pml.pml48=null                                                                                          
         END IF  
      END IF                                                                                                                
      LET l_pml.pml54='2'
   ELSE
      LET l_pml.pml47=''
      LET l_pml.pml48=''
      LET l_pml.pml49='1'
      LET l_pml.pml50='1'
      LET l_pml.pml51=''
      LET l_pml.pml52=''
      LET l_pml.pml53=''
      LET l_pml.pml54=' '
   END IF       
#FUN-B90101--add--begin--
  #給初始值
   IF cl_null(l_pml.pml88) THEN
      LET l_pml.pml88 = 0
   END IF
   IF cl_null(l_pml.pml88t) THEN
      LET l_pml.pml88t = 0
   END IF
   IF cl_null(l_pml.pml49) THEN
      LET l_pml.pml49 = ' '
   END IF
   IF cl_null(l_pml.pml50) THEN
      LET l_pml.pml50 = '1'
   END IF
#FUN-B90101--add--end--                                                                                
   LET l_pml.pml56 = '1'  #bnl
  #LET l_pml.pml91 = ' '  #FUN-980010 add 給初始值
   LET l_pml.pml91 = 'N'  #FUN-980010 add 給初始值  #Mod TQC-B30096
   LET l_pml.pml92 = 'N' #FUN-9B0023 
   INSERT INTO pml_file VALUES(l_pml.*)
   IF SQLCA.sqlcode THEN
      CALL s_errmsg("pml01",l_pml.pml01,"INS pml_file",SQLCA.sqlcode,1)          #No.FUN-710046
      LET g_success = 'N'
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_pmli.* TO NULL
         LET l_pmli.pmli01 = l_pml.pml01
         LET l_pmli.pmli02 = l_pml.pml02
#FUN-B90101--add--begin--
         LET l_pmli.pmliplant = l_pml.pmlplant
         LET l_pmli.pmlilegal = l_pml.pmllegal
         INSERT INTO pmli_file VALUES(l_pmli.*)
         IF SQLCA.sqlcode THEN
            CALL s_errmsg("pmli01",l_pmli.pmli01,"INS pmli_file",SQLCA.sqlcode,1)  
            LET g_success = 'N'
         END IF
#FUN-B90101--add--end--
#FUN-B90101--mark--begin--
#        IF NOT s_ins_pmli(l_pmli.*,'') THEN
#           LET g_success = 'N'
#        END IF
#FUN-B90101--mark--end--
      END IF
   END IF
    SELECT SUM(pml20) INTO l_pml.pml20 
      FROM pml_file,pmk_file
     WHERE pml24 = l_pml.pml24
       AND pml25 = l_pml.pml25
       AND pml01 = pmk01
       AND pmk18 <> 'X'
       AND pml16 <> '9'
#要回寫每張訂單的己拋量和請購單號
   UPDATE oeb_file SET oeb27 = p_pmk01,
                       oeb28 = l_pml.pml20
                 WHERE oeb01 = p_oeb01
                   AND oeb03 = p_oeb03                          #TQC-960155
   IF SQLCA.sqlcode THEN
      LET g_showmsg=p_oeb01,"/",p_oeb03                       #No.FUN-710046
      CALL s_errmsg("oeb01,oeb03",g_showmsg,"UPD oeb_file",SQLCA.sqlcode,1)    #No.FUN-710046
      LET g_success = 'N'
   END IF
END FUNCTION
FUNCTION t400_set_pml87()
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima44  LIKE ima_file.ima44,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            g_cnt    LIKE type_file.num5,
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_tot    LIKE img_file.img10,     #計價數量
            l_factor LIKE type_file.num20_6
 
    SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
      FROM ima_file WHERE ima01=g_pml.pml04
    IF SQLCA.sqlcode =100 THEN
       IF g_pml.pml04 MATCHES 'MISC*' THEN
          SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
 
    LET l_fac2=g_pml.pml84
    LET l_qty2=g_pml.pml85
    IF g_sma.sma115 = 'Y' THEN
       LET l_fac1=g_pml.pml81
       LET l_qty1=g_pml.pml82
    ELSE
       LET l_fac1=1
       LET l_qty1=g_pml.pml20
       CALL s_umfchk(g_pml.pml04,g_pml.pml07,l_ima44)
             RETURNING g_cnt,l_fac1
       IF g_cnt = 1 THEN
          LET l_fac1 = 1
       END IF
    END IF
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE l_ima906
          WHEN '1' LET l_tot=l_qty1*l_fac1
          WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
          WHEN '3' LET l_tot=l_qty1*l_fac1
       END CASE
    ELSE  #不使用雙單位
       LET l_tot=l_qty1*l_fac1
    END IF
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
    LET l_factor = 1
    CALL s_umfchk(g_pml.pml04,l_ima44,g_pml.pml86)
          RETURNING g_cnt,l_factor
    IF g_cnt = 1 THEN
       LET l_factor = 1
    END IF
    LET l_tot = l_tot * l_factor
    LET g_pml.pml87 = l_tot
    LET g_pml.pml87 = s_digqty(g_pml.pml87,g_pml.pml86)   #No.FUN-BB0086
END FUNCTION
 
FUNCTION t400_set_pmn87()
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima44  LIKE ima_file.ima44,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            g_cnt    LIKE type_file.num5,
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_tot    LIKE img_file.img10,     #計價數量
            l_factor LIKE type_file.num20_6
 
    SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
      FROM ima_file WHERE ima01=g_pmn.pmn04
    IF SQLCA.sqlcode =100 THEN
       IF g_pmn.pmn04 MATCHES 'MISC*' THEN
          SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
 
    LET l_fac2=g_pmn.pmn84
    LET l_qty2=g_pmn.pmn85
    IF g_sma.sma115 = 'Y' THEN
       LET l_fac1=g_pmn.pmn81
       LET l_qty1=g_pmn.pmn82
       LET l_ima44=g_pmn.pmn80
    ELSE
       LET l_fac1=1
       LET l_qty1=g_pmn.pmn20
       CALL s_umfchk(g_pmn.pmn04,g_pmn.pmn07,l_ima44)
             RETURNING g_cnt,l_fac1
       IF g_cnt = 1 THEN
          LET l_fac1 = 1
       END IF
    END IF
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE l_ima906
          WHEN '1' LET l_tot=l_qty1*l_fac1
          WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
          WHEN '3' LET l_tot=l_qty1*l_fac1
       END CASE
    ELSE  #不使用雙單位
       LET l_tot=l_qty1*l_fac1
    END IF
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
 
    LET l_factor = 1
    CALL s_umfchk(g_pmn.pmn04,l_ima44,g_pmn.pmn86)
          RETURNING g_cnt,l_factor
    IF g_cnt = 1 THEN
       LET l_factor = 1
    END IF
    LET l_tot = l_tot * l_factor
    LET g_pmn.pmn87 = l_tot
    LET g_pmn.pmn87 = s_digqty(g_pmn.pmn87,g_pmn.pmn86)   #No.FUN-BB0086
END FUNCTION
# No.FUN-9C0073 --------------By chenls 10/01/07 

#FUN-BC0071---------------STA
FUNCTION t400_upd_lqe(l_oea)
DEFINE l_oea   RECORD LIKE oea_file.*
DEFINE l_n     LIKE type_file.num5

  SELECT COUNT(*) INTO l_n FROM oeb_file,lpx_file,lqe_file,lqw_file
   WHERE lpx32 = oeb04 AND lpx01 = lqe02
     AND oeb01 = l_oea.oea01
     AND lqw08 = lqe02 AND lqw00 = '01'
     AND lqw01= l_oea.oea01
     AND lqe01 BETWEEN lqw09 AND lqw10
     AND lqe17 IN ('5','2') 
     AND lqe13 = l_oea.oeaplant
  IF l_n > 0 THEN

     UPDATE lqe_file SET  lqe17 = '1',
                          lqe06 = l_oea.oeaplant,
                          lqe07 = g_today 
      WHERE lqe01 IN (SELECT lqe01 FROM oeb_file,lpx_file,lqe_file,lqw_file
                       WHERE lpx32 = oeb04 AND lpx01 = lqe02
                         AND oeb01 = l_oea.oea01
                         AND lqw08 = lqe02 AND lqw00 = '01'
                         AND lqw01= l_oea.oea01
                         AND lqe01 BETWEEN lqw09 AND lqw10
                         AND lqe17 IN ('5','2') 
                         AND lqe13 = l_oea.oeaplant)
     IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("upd","lqe_file",'',"",SQLCA.sqlcode,"","",1)  
        LET g_success = 'N'
        RETURN
     END IF
   END IF          

END FUNCTION 

FUNCTION t400_ins_lsn(l_oea)
DEFINE l_oea    RECORD LIKE oea_file.*
DEFINE l_n      LIKE type_file.num5
DEFINE l_oeb14t LIKE oeb_file.oeb14t
DEFINE l_money  LIKE type_file.num20_6
DEFINE l_lsn07  LIKE lsn_file.lsn07

   SELECT COUNT(*) INTO l_n FROM oeb_file
    WHERE oeb01 = l_oea.oea01 AND oeb04= 'MISCCARD'
   IF l_n >0 THEN
     SELECT SUM(oeb14t) INTO l_oeb14t FROM oeb_file 
      WHERE oeb01 = l_oea.oea01 AND oeb04= 'MISCCARD'
     SELECT SUM(oeb47+oeb14t) INTO l_money FROM oeb_file 
      WHERE oeb01 = l_oea.oea01 AND oeb04= 'MISCCARD'
     UPDATE lpj_file SET lpj06 = lpj06 + l_money,
                         lpjpos = '2'    #FUN-D30007 add
      WHERE lpj03 = l_oea.oea87
     IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("upd","lpj_file",'',"",SQLCA.sqlcode,"","",1)  
        LET g_success = 'N'
        RETURN
     END IF

     IF g_success = 'Y' THEN
        LET l_lsn07 = l_oeb14t/(l_money*100)
       #INSERT INTO lsn_file (lsn01,lsn02,lsn03,lsn04,lsn05,lsn07,lsnplant,lsnlegal,lsn10)                 #FUN-C70045 add lsn10  #FUN-C90102 mark 
        INSERT INTO lsn_file (lsn01,lsn02,lsn03,lsn04,lsn05,lsn07,lsnstore,lsnlegal,lsn10)                 #FUN-C90102 add
         VALUES (l_oea.oea87,'E',l_oea.oea01,l_money,g_today,l_lsn07,l_oea.oeaplant,l_oea.oealegal,'1')    #FUN-C70045 add '1'
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","lsn_file",'',"",SQLCA.sqlcode,"","",1)  
           LET g_success = 'N'
           RETURN
        END IF
     END IF
   END IF 

END FUNCTION

   
#FUN-BC0071 --------------END



#TQC-C80019 add begin 12-8-3 
#copy t400sub_ins_pml_exp()
FUNCTION t400sub_ins_pml2_exp(l_pmk01,p_oea01,p_oeb03)
 DEFINE l_pmk01  LIKE pmk_file.pmk01   
 DEFINE l_oeo    RECORD LIKE oeo_file.*
 DEFINE l_oeb03  LIKE oeb_file.oeb03  #No.+186 add
 DEFINE p_oeb03  LIKE oeb_file.oeb03  #TQC-730022 add
 DEFINE l_qty    LIKE oeb_file.oeb12
 DEFINE l_oeb01  LIKE oeb_file.oeb01  #NO.FUN-670007
 DEFINE l_oeb    RECORD LIKE oeb_file.*
 DEFINE p_oea01  LIKE oea_file.oea01,
        p_flag   LIKE type_file.chr1
 
      DECLARE t400sub_oeb_curs3 CURSOR FOR
       SELECT * FROM oeb_file
        WHERE oeb01 = p_oea01
          AND oeb03 = p_oeb03     #TQC-730022 add
          AND oeb1003!='2'   #TQC-640085
      FOREACH t400sub_oeb_curs3 INTO l_oeb.*
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('','',"foreach:",SQLCA.sqlcode,1)  #No.FUN-710046
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         DECLARE oeo_cus3 CURSOR FOR
             SELECT *
               FROM oeo_file
              WHERE oeo01 = p_oea01
                AND oeo03 = l_oeb.oeb03
         FOREACH oeo_cus3 INTO l_oeo.*
              IF SQLCA.SQLCODE THEN
                 CALL s_errmsg('','',"sel oeo:",SQLCA.sqlcode,0)   #No.FUN-710046
              END IF  
              LET g_oeb03 = g_oeb03+1   #MOD-910210
              LET l_qty = l_oeb.oeb12 * l_oeo.oeo06
               #CALL t400sub_ins_pml(l_pmk01,l_oeb01,l_oeb.oeb03,l_oeo.oeo04,    #NO.FUN-670007    #MOD-910210   #MOD-A20119
               CALL t400sub_ins_pml2(l_pmk01,l_oeb.oeb01,l_oeb.oeb03,l_oeo.oeo04,    #NO.FUN-670007    #MOD-910210   #MOD-A20119
                                 l_oeb.oeb05_fac,l_qty,l_oeb.oeb15,
                                 l_oeo.oeo05,l_oeo.oeo04,
                                 l_oeb.oeb910,l_oeb.oeb911,l_oeb.oeb912,
                                 l_oeb.oeb913,l_oeb.oeb914,l_oeb.oeb915,
                                 l_oeb.oeb916,l_oeb.oeb917,
                                 l_oeb.oeb41,l_oeb.oeb42,l_oeb.oeb43,l_oeb.oeb1001,   #FUN-810045
                                 g_oeb03,l_oeb.oeb44,  #MOD-910210 #No.FUN-870007-add oeb44
                                 l_oeb.oeb919            #FUN-A90059 add
                                 ) #BugNo:6097
         END FOREACH
      END FOREACH
 
END FUNCTION

#copy t400sub_ins_pml()
FUNCTION t400sub_ins_pml2(p_pmk01,p_oeb01,p_oeb03,p_oeb04,p_oeb05_fac,p_oeb12,  #NO.FUN-670007
                         p_oeb15,p_oeb05,p_oeb06,   #NO.FUN-670007
                         p_oeb910,p_oeb911,p_oeb912,p_oeb913,p_oeb914,
                         p_oeb915,p_oeb916,p_oeb917,p_oeb41,p_oeb42,p_oeb43,p_oeb1001,p_oeb03_2,p_oeb44,  #FUN-810045 add oeb41-43/1001   #MOD-910210 增加p_oeb03_2 #No.FUN-870007-add oeb44
                         p_oeb919) #(p_oea01,l_oeb03,l_pmk01)
  DEFINE p_pmk01     LIKE pmk_file.pmk01,
         p_oeb01     LIKE oeb_file.oeb01,    #NO.FUN-670007
         p_oeb03     LIKE oeb_file.oeb03,
         p_oeb04     LIKE oeb_file.oeb04,
         p_oeb05_fac LIKE oeb_file.oeb05_fac,
         p_oeb05     LIKE oeb_file.oeb05,
         p_oeb06     LIKE oeb_file.oeb06,
         p_oeb12     LIKE oeb_file.oeb12,
         p_oeb15     LIKE oeb_file.oeb15,
         p_oeb28     LIKE oeb_file.oeb28,    #NO.FUN-670007
         p_oeb24     LIKE oeb_file.oeb24,    #NO.FUN-670007 
         p_oeb910    LIKE oeb_file.oeb910,
         p_oeb911    LIKE oeb_file.oeb911,
         p_oeb912    LIKE oeb_file.oeb912,
         p_oeb913    LIKE oeb_file.oeb913,
         p_oeb914    LIKE oeb_file.oeb914,
         p_oeb915    LIKE oeb_file.oeb915,
         p_oeb916    LIKE oeb_file.oeb916,
         p_oeb917    LIKE oeb_file.oeb917,
         p_oeb41     LIKE oeb_file.oeb41,
         p_oeb42     LIKE oeb_file.oeb42,
         p_oeb43     LIKE oeb_file.oeb43,
         p_oeb1001   LIKE oeb_file.oeb1001,
         p_oeb03_2   LIKE oeb_file.oeb03,   #MOD-910210
         p_oeb44     LIKE oeb_file.oeb44,   #No.FUN-870007
         p_oeb919    LIKE oeb_file.oeb919,   #FUN-A90059 add
         l_ima01     LIKE ima_file.ima01,
         l_ima02     LIKE ima_file.ima02,
         l_ima05     LIKE ima_file.ima05,
         l_ima25     LIKE ima_file.ima25,
         l_ima27     LIKE ima_file.ima27,
#         l_ima262    LIKE ima_file.ima262, #FUN-A20044
         l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk    LIKE type_file.num15_3, #FUN-A20044
         l_ima44     LIKE ima_file.ima44,
         l_ima44_fac LIKE ima_file.ima44_fac,
         l_ima45     LIKE ima_file.ima45,
         l_ima46     LIKE ima_file.ima46,
         l_ima49     LIKE ima_file.ima49,
         l_ima491    LIKE ima_file.ima491,
         l_ima913    LIKE ima_file.ima913,   #CHI-6A0016
         l_ima914    LIKE ima_file.ima914,   #CHI-6A0016
         l_pan       LIKE type_file.num10,   #No.FUN-680137 INTEGER
         l_flag      LIKE type_file.chr1,    #No.TQC-740351
         l_double    LIKE type_file.num10    #No.FUN-680137 INTEGER
   DEFINE l_pml      RECORD LIKE pml_file.*  #FUN-730018
   DEFINE l_oeb      RECORD LIKE oeb_file.*  #FUN-730018
   DEFINE l_pmli     RECORD LIKE pmli_file.* #No.FUN-830132 add
   DEFINE l_rty03 LIKE rty_file.rty03        #No.FUN-870007                                                               
   DEFINE l_rty06 LIKE rty_file.rty06        #No.FUN-870007
 
   CALL t400sub_pml_ini(p_pmk01) RETURNING l_pml.* #FUN-730018
 
   LET l_ima913 = 'N'   #MOD-770033 add
   IF p_oeb04[1,4] <> "MISC" THEN
#       SELECT ima01,ima02,ima05,ima25,ima262,ima27,ima44,ima44_fac, #FUN-A20044
       SELECT ima01,ima02,ima05,ima25,0,ima27,ima44,ima44_fac, #FUN-A20044
              ima45,ima46,ima49,ima491,
              ima913,ima914         #CHI-6A0016
         INTO l_ima01,l_ima02,l_ima05,l_ima25,l_avl_stk,l_ima27,
              l_ima44,l_ima44_fac,l_ima45,l_ima46,l_ima49,l_ima491,
              l_ima913,l_ima914       #CHI-6A0016
         FROM ima_file
        WHERE ima01 = p_oeb04
       CALL s_getstock(p_oeb04,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
       IF SQLCA.sqlcode THEN
           CALL s_errmsg("ima01",p_oeb04,"sel ima:",SQLCA.sqlcode,1)     #No.FUN-710046
           LET g_success = 'N'
           RETURN
       END IF
       LET l_pml.pml02 = p_oeb03_2   #MOD-910210
       LET l_pml.pml49 = p_oeb44    #No.FUN-870007
       LET l_pml.pml04 = l_ima01
       LET l_pml.pml041= l_ima02
       LET l_pml.pml05 = NULL      #no.4649(APS單據編號)
       LET l_pml.pml07 = l_ima44      #No.TQC-740351
       LET l_pml.pml08 = l_ima25
       CALL s_umfchk(l_pml.pml04,l_pml.pml07,                                                                                     
            l_pml.pml08) RETURNING l_flag,l_pml.pml09                                                                             
            IF cl_null(l_pml.pml09) THEN LET l_pml.pml09=1 END IF
      #先將訂單數量轉換成請購單位數量                                                                                               
       LET p_oeb12 = p_oeb12 * p_oeb05_fac / l_pml.pml09
       LET l_pml.pml42 = '0'
    IF g_sma.sma115='N' THEN      #No.TQC-740351
       #-->考慮最少採購量/倍量
       IF p_oeb12 > 0 THEN  #FUN-730018
            IF p_oeb12 < l_ima46 THEN #FUN-730018
               #CALL s_sizechk(l_pml.pml04,p_oeb12,g_lang) #CHI-C10037 mark
               CALL s_sizechk(l_pml.pml04,p_oeb12,g_lang,l_pml.pml07)  #CHI-C10037 add
                             RETURNING l_pml.pml20
           ELSE
               IF l_ima45 > 0 THEN
                   LET l_pan = (p_oeb12 * 1000) / (l_ima45 * 1000)
                   IF (l_pan*(l_ima45*1000)) > (p_oeb12 * 1000) THEN
                       LET l_pan=(p_oeb12*1000) -((l_pan-1)*(l_ima45*1000))
                   ELSE
                       LET l_pan=(p_oeb12*1000) -(l_pan*(l_ima45*1000))
                   END IF
 
                   IF l_pan !=0 THEN
                       LET l_double = (p_oeb12/l_ima45) + 1
                   ELSE
                       LET l_double = p_oeb12/l_ima45
                   END IF
                   LET l_pml.pml20  = l_double * l_ima45
               ELSE
                   LET l_pml.pml20 = p_oeb12
               END IF
           END IF
       ELSE
           LET l_pml.pml20 = 0
       END IF
    ELSE      #No.TQC-740351
       LET l_pml.pml20 = p_oeb12      #No.TQC-740351
    END IF      #No.TQC-740351
       LET l_pml.pml35 = p_oeb15                 #到庫日期
       CALL s_aday(l_pml.pml35,-1,l_ima491) RETURNING l_pml.pml34 #No.TQC-640132
       CALL s_aday(l_pml.pml34,-1,l_ima49) RETURNING l_pml.pml33  #No.TQC-640132
   ELSE
       LET l_pml.pml02 = p_oeb03_2   #MOD-910210
       LET l_pml.pml04 = p_oeb04
       LET l_pml.pml041= p_oeb06
       LET l_pml.pml05 = NULL
       LET l_pml.pml07 = p_oeb05
       LET l_pml.pml08 = p_oeb05
       LET l_pml.pml09 = 1
       LET l_pml.pml42 = '0'
       LET l_pml.pml20 = p_oeb12                     #MOD-830126 cancel mark
       LET l_pml.pml35 = p_oeb15
       CALL s_aday(l_pml.pml35,-1,l_ima491) RETURNING l_pml.pml34  #No.TQC-640132
       CALL s_aday(l_pml.pml34,-1,l_ima49) RETURNING l_pml.pml33   #No.TQC-640132
   END IF
   LET l_pml.pml80 = p_oeb910
   LET l_pml.pml81 = p_oeb911
   LET l_pml.pml82 = p_oeb912
   LET l_pml.pml83 = p_oeb913
   LET l_pml.pml84 = p_oeb914
   LET l_pml.pml85 = p_oeb915
   LET l_pml.pml86 = p_oeb916
   LET l_pml.pml12 = p_oeb41
   LET l_pml.pml121 = p_oeb42
   LET l_pml.pml122 = p_oeb43
   LET l_pml.pml90 = p_oeb1001
   LET l_pml.pml919 = p_oeb919    #FUN-A90059 add
   IF g_sma.sma116 MATCHES'[13]' THEN
      LET l_pml.pml86 = p_oeb916
   ELSE
      LET l_pml.pml86 = l_pml.pml07
   END IF
   LET g_pml.* = l_pml.*      #No.TQC-740351
   CALL t400_set_pml87()      #No.TQC-740351
   LET l_pml.pml87=g_pml.pml87      #No.TQC-740351
 
 
   LET l_pml.pml190 = l_ima913    #統購否
   LET l_pml.pml191 = l_ima914    #採購成本中心
   LET l_pml.pml192 = 'N'         #拋轉否
 
   LET l_pml.pml24 = p_oeb01
   LET l_pml.pml25 = p_oeb03
   IF g_azw.azw04='2' THEN
      LET l_pml.pml47 = ''
      SELECT rty03,rty06 INTO l_rty03,l_rty06 FROM rty_file                                                                     
       WHERE rty01=g_plant AND rty02=p_oeb04                                                                            
      IF SQLCA.sqlcode=100 THEN                                                                                           
         LET l_rty03=NULL                                                                                                   
         LET l_rty06=NULL                                                                                                   
      END IF                                                                                                              
      LET l_pml.pml49=l_rty06                                                                                                 
      LET l_pml.pml50=l_rty03                                                                                                 
      IF l_pml.pml50='2' THEN                                                                                                 
         LET l_pml.pml51=g_plant                                                                                         
         LET l_pml.pml52=p_pmk01                                                                                          
         LET l_pml.pml53=l_pml.pml02                                                                                    
      ELSE                                                                                                                          
         LET l_pml.pml51=''                                                                                                   
         LET l_pml.pml52=''                                                                                                   
         LET l_pml.pml53=''                                                                                                   
      END IF           
      SELECT rty05 INTO l_pml.pml48 FROM rty_file
       WHERE rty01= (SELECT oea84 FROM oea_file WHERE oea01=p_oeb01)
         AND rtyacti='Y' AND rty02=p_oeb04
      IF SQLCA.sqlcode=100 THEN
         SELECT rty05 INTO l_pml.pml48 FROM rty_file                                                                 
          WHERE rty01=g_plant AND rtyacti='Y' AND rty02=p_oeb04                                                  
         IF SQLCA.sqlcode=100 THEN                                                                                              
            LET l_pml.pml48=null                                                                                          
         END IF  
      END IF                                                                                                                
      LET l_pml.pml54='2'
   ELSE
      LET l_pml.pml47=''
      LET l_pml.pml48=''
      LET l_pml.pml49='1'
      LET l_pml.pml50='1'
      LET l_pml.pml51=''
      LET l_pml.pml52=''
      LET l_pml.pml53=''
      LET l_pml.pml54=' '
   END IF                                                                                       
   LET l_pml.pml56 = '1'  #bnl
  #LET l_pml.pml91 = ' '  #FUN-980010 add 給初始值
   LET l_pml.pml91 = 'N'  #FUN-980010 add 給初始值  #Mod TQC-B30096
   LET l_pml.pml92 = 'N' #FUN-9B0023 
   INSERT INTO pml_file VALUES(l_pml.*)
   IF SQLCA.sqlcode THEN
      CALL s_errmsg("pml01",l_pml.pml01,"INS pml_file",SQLCA.sqlcode,1)          #No.FUN-710046
      LET g_success = 'N'
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_pmli.* TO NULL
         LET l_pmli.pmli01 = l_pml.pml01
         LET l_pmli.pmli02 = l_pml.pml02
         IF NOT s_ins_pmli(l_pmli.*,'') THEN
            LET g_success = 'N'
         END IF
      END IF
   END IF

END FUNCTION 
#TQC-C80019 add end 12-8-3
