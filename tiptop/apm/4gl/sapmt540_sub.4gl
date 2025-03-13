# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Program name...: sapmt540_sub.4gl
# Description....: 提供sapmt540.4gl使用的sub routine
# Date & Author..: 07/03/21 by kim (FUN-730012)
# Modify.........: No.TQC-730022 07/03/22 By rainy 流程自動化
# Modify.........: No.TQC-740164 07/04/22 By Nicola 抓供應商時，加入pmh21,pmh22條件
# Modify.........: No.TQC-740250 07/04/22 By Nicola t540sub_pmh()多一個參數
# Modify.........: No.TQC-770031 07/07/06 By chenl   審核時增加對采購日期與交貨日期的判斷。
# Modify.........: No.FUN-710060 07/08/08 By jamie 料件供應商管制建議依品號設定;程式中原判斷sma63=1者改為判斷ima915=2 OR 3
# Modify.........: NO.MOD-7B0085 07/11/09 BY yiting check pmh_file時，應依一般採購或委外採購做判斷
# Modify.........: NO.CHI-7B0035 07/11/22 BY kim 補過單
# Modify.........: NO.MOD-7B0239 07/11/28 By claire l_argv3沒有傳值,造成委外採購發出串成apmp554
# Modify.........: NO.MOD-7B0255 07/11/29 By claire l_pmm.*值未傳入造成值為null
# Modify.........: NO.MOD-7C0169 07/12/25 By claire FUN-7B0085不調整,一般委外po及製程委外po仍check apmi264
# Modify.........: NO.FUN-810038 08/01/21 BY kim GP5.1 ICD
# Modify.........: No.FUN-830161 08/04/01 By Carrier 項目預算控管
# Modify.........: No.MOD-840328 08/04/20 By rainy 錯誤訊息修正
# Modify.........: No.MOD-850224 08/05/22 By Smapmin 調整錯誤訊息 
# Modify.........: No.MOD-870002 08/07/02 By Smapmin 修改錯誤訊息
# Modify.........: No.MOD-860017 08/07/14 By Pengu 多角採購單確認時再檢核1次單頭之幣別和多角流程所設定之幣別是否一致
# Modify.........: NO.FUN-880016 08/08/07 By Yiting 確認時增加GPM控管
# Modify.........: No.MOD-890159 08/09/17 By chenyu 確認的時候，要判斷是否已轉完采購單
# Modify.........: No.FUN-870158 08/09/18 By xiaofeizhu 把原"采購發出"時，透過java mail發mail通知廠商的功能，改寫為新的透過cr以附件方式發出mail通知廠商
# Modify.........: No.MOD-890239 08/09/24 By chenyu 修改MOD-890159，在update之前加一個判斷
# Modify.........: No.FUN-890128 08/10/08 By Vicky 確認段_chk()與異動資料_upd()若只需顯示提示訊息不可用cl_err()寫法,應改為cl_getmsg()
# Modify.........: No.FUN-8A0054 08/10/13 By sabrina 若沒勾選〝與GPM整合〞，則不做GPM控管
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.CHI-920024 09/02/06 By jan imaicd-->imaicd01
# Modify.........: No.CHI-920026 09/02/06 By jan 38區[DS4] Blank PO- WEB11-0902000001,無法被第二張Code Relase PO(WEB21-0902000001)衝銷 (程序BUG)
# Modify.........: No.FUN-920175 09/02/24 By kim 取消確認/作廢段程式拆解到_sub.4gl中，以便後續程序呼叫
# Modify.........: No.FUN-920190 09/02/25 By kim ICD工單取消確認時一並將委外採購單作廢
# Modify.........: No.TQC-930010 09/03/03 By chenyu 訂單轉過來的采購單，在整筆刪除的時候，沒有回寫訂單單身的采購單號和轉采購量
# Modify.........: No.TQC-910033 09/02/12 by ve007 抓取作業編號時，委外要區分制程和非制程
# Modify.........: No.CHI-920042 09/03/05 by jan 修正衝銷部分的BUG
# Modify.........: No.FUN-930148 09/03/26 By ve007 采購取價和定價
# Modify.........: No.MOD-950284 09/06/03 By Smapmin 使用利潤中心功能時,預算控管的部門應抓取利潤中心
# Modify.........: No.TQC-910033 09/06/08 By chenmoyan t540sub_pmh中增加一個參數pmh18
# Modify.........: No.CHI-960016 09/06/08 By mike 于確認段時再利用FOREACH回圈判斷單身采購數量是否有為0的                            
# Modify.........: No.TQC-970120 09/07/13 By sherry 重新過單
# Modify.........: No.FUN-940071 09/07/11 By chenmoyan 當pmd08='Y'時,才可以發mail
# Modify.........: No.FUN-960130 09/08/11 By sunyanchun 流通零售
# Modify.........: No.FUN-980006 09/08/21 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-970002 09/08/25 By Smapmin 採購單取消作廢時,若對應的請購單不為已確認,皆不可取消作廢.
# Modify.........: No.MOD-980151 09/08/19 By Carrier 單據作廢,在做請購等做判斷前,應該加入單據來源,若并非請購來源,則不得于請購做比較                   
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990131 09/09/14 By mike apmt590_icd委外采購單時,發出時,會卡未發料前不可做采購發出..應跟apmt590控管一致,未>
# Modify.........: No.MOD-990227 09/09/24 By Smapmin 確認段upd時,transaction有問題
# Modify.........: No.CHI-960051 09/10/13 By jan (_r()中)的那段 update pmm_file 應該要mark掉
# Modify.........: No.MOD-990206 09/10/15 By Smapmin 作廢/取消作廢後,請購單單身若有已轉採購量且狀態<=2,狀態要update為'2'
# Modify.........: No.MOD-990207 09/10/15 By Smapmin 修改取消作廢後,update請購單單頭狀態的條件
# Modify.........: No.FUN-9B0016 09/11/02 By Sunyanchun post no 
# Modify.........: No.FUN-980033 09/08/10 By jan aict040不檢查光罩群組之metal layer一定有一筆為'Y'
# Modify.........: No:TQC-9B0214 09/11/25 By Sunyanchun  s_defprice --> s_defprice_new
# Modify.........: No.FUN-9C0046 09/12/09 By chenls    刪除前判斷資料來源是否為電子採購
# Modify.........: No:FUN-9C0071 10/01/06 By huangrh 精簡程式
# Modify.........: No:MOD-A10033 10/01/08 By Smapmin 於確認段再次的檢核單頭稅率與單身未稅/含稅單價間的稅率是否不符.
# Modify.........: No:MOD-A10046 10/01/08 By Smapmin 確認時回寫確認人
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No.FUN-A50054 10/05/31 By chenmoyan 增加服饰版二维功能 
# Modify.........: No:CHI-A40021 10/06/04 By Summer 用agli102科目是否有做專案控管的參數,
#                                                   做為抓取預算資料時是否要以專案為條件
# Modify.........: No:FUN-A60011 10/06/07 By Carrier ecm321更新时,要检查是否对ecm52做更新
# Modify.........: No.FUN-A60076 10/06/30 By vealxu 製造功能優化-平行制程 
# Modify.........: No.FUN-A60095 10/07/14 By jan sgm321更新時，要檢查是否對sgm52做更新 
# Modify.........: No:MOD-A70186 10/07/27 By Smapmin 刪除時要一併刪除相關文件
# Modify.........: No:MOD-A50210 10/07/30 By Smapmin 由訂單轉入時,整張單據作廢/刪除等動作要回寫oeb27/oeb28
# Modify.........: No.FUN-A80087 10/08/31 By Lilan 當與EF整合時,確認人應是EF最後一關簽核人員
#                                                  但若EF最後一關簽核人員代號不存在於p_zx,則預設單據開單者
# Modify.........: No:MOD-A80213 10/09/03 By lilingyu 當採購單類型為3:依訂單轉入時,點擊作廢功能鈕,報錯更新請購單失敗
# Modify.........: No.FUN-A90009 10/09/07 By destiny b2b
# Modify.........: No.FUN-A80102 10/09/17 By destiny b2b
# Modify.........: No:MOD-AB0100 10/11/10 By Smapmin 取消確認判斷是否存在收貨單時,要排除作廢的收貨單
# Modify.........: No:FUN-AB0066 10/11/18 By lilingyu 審核段增加倉庫權限控管
# Modify.........: No:MOD-AA0150 10/11/23 By sabrina bank po沖銷時，在確認段會多扣一次採購量，造成無法確認
# Modify.........: No.TQC-AC0257 10/12/22 By suncx s_defprice_new.4gl返回值新增兩個參數
# Modify.........: No:MOD-AC0411 11/01/05 By Smapmin 將預算控管移至_y_chk()
# Modify.........: No:CHI-B10025 11/01/12 By Smapmin 確認時再次檢核委外採購的供應商是否與工單相同
# Modify.........: No:TQC-B10228 11/02/11 By lilingyu 審核時沒有對"採購員"欄位進行控管;點擊修改功能時,經過此欄位,如果沒有更改原來的值,也沒有進行check
# Modify.........: No:CHI-B10040 11/07/20 By Pengu 當採購已結案則不允許發出
# Modify.........: No:MOD-B70152 11/07/20 By suncx  審核檢查核價檔未稅金額bug
# Modify.........: No:MOD-B60102 11/07/20 By JoHung 判斷單頭的資料來源如果是人工輸入/請購單轉入才去做請採勾稽
# Modify.........: No:TQC-B70156 11/07/20 By suncx  MOD-B70152問題修復
# Modify.........: No:TQC-B70161 11/07/21 By suncx  還原MOD-B70152和TQC-B70156的處理
# Modify.........: No:MOD-B80057 11/08/04 By suncx  程序check時，會將本身單据的金額在多加一次導致采購單審核時，報錯超預算，但是實際没有超預算
# Modify.........: No:TQC-B90037 11/09/05 By lilingyu 有發料單時,委外採購單不可取消審核
# Modify.........: No.MOD-B90094 11/09/13 By suncx   修改取消作廢後,update請購單單頭狀態的條件
# Modify.........: No.TQC-BA0169 11/10/28 By qiaozy 電子採購流程中：1.apmt540刪除時,更新wpc_file/wpd_file關聯條件應該分別是wpc01=pmn99/wpd01=pmn99
# Modify.........: No.FUN-B90103 11/11/14 By xjll   修改服飾二維刪除出現錯誤 delete ata_file
# Modify.........: No.FUN-910088 12/01/17 By chenjing 增加數量欄位小數取位
# Modify.........: No.FUN-C20006 12/02/03 By xjll  增加業態g_azw.azw04='2' 判斷
# Modify.........: No:MOD-C10218 12/02/08 By jt_chen 作廢還原時控卡已轉數量不可大於來源單據數量
# Modify.........: No:MOD-C10151 12/02/08 By Vampire 不限制要先有發料單或先有採購單
# Modify.........: No:MOD-BC0168 12/02/08 By Summer 調整回寫請購單狀況碼問題 
# Modify.........: No:TQC-C10045 12/02/15 By suncx 只有制程委外,傳入的l_type參數才為’2’
# Modify.........: No:MOD-C30366 12/03/16 By yuhuabao 回寫的時候，如果存在替代則應先進行數量轉換
# Modify.........: No:TQC-C30225 12/04/06 By SunLM 若為運輸發票(gec05='T')時,未稅單價邏輯調整
# Modify.........: No:FUN-C40089 12/04/30 By bart 原先以參數sma112來判斷採購單價可否為0的程式,全部改成判斷採購價格條件(apmi110)的pnz08
# Modify.........: No:FUN-C50076 12/05/18 By bart 更改錯誤訊息代碼mfg3522->axm-627
# Modify.........: No:FUN-C50116 12/05/25 By bart 當pnz08='N'時,才做aic-097的檢核
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.TQC-C60178 12/06/27 By zhuhao 審核時採購部門編號需有效
# Modify.........: No:MOD-C60115 12/07/03 By Elise 將更新狀況碼pmn16的地方移到單身FOREACH段處理
# Modify.........: No:FUN-C30085 12/07/04 By nanbing CR改串GR
# Modify.........: No.FUN-C70098 12/07/24 By xjll  服飾流通二維，不可審核數量為零的母單身資料
# Modify.........: No:MOD-C80061 12/08/15 By Vampire (1) 確認時afa-978的控卡請排除替代碼為【2:主料, 有副料可替代】
#                                                    (2) AFTER FIELD pmn20 替代碼為【2:主料, 有副料可替代】不控卡 mfg3331
# Modify.........: No.FUN-D20025 13/02/21 By nanbing 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:CHI-CB0069 13/02/25 By jt_chen 單頭的訊息增加提供單號,單身的訊息增加提供單號項次
# Modify.........: No.FUN-D10128 13/02/26 By SunLM 若為農業發票(gec05='A')時,未稅單價邏輯調整
# Modify.........: No:MOD-D10103 13/03/12 By jt_chen (1) 調整跳出訊提的處理,不能一直彈出訊息無法離開
#                                                    (2) 訊息提示:採購單價格條件設定不能人工輸入,且採購參數設定採購單價不可為零,請調整價格條件或核定取價
#                                                    (3) 採購參數採購單價不可為零的控卡不分一般採購、委外採購,皆須依參數設定
# Modify.........: No:CHI-C80072 13/03/27 By xumm 取消审核赋值审核异动日期和审核异动人员
# Modify.........: No:DEV-D30045 13/04/01 By TSD.JIE 1.調整確認自動產生barcode
#                                                    2.調整取消確認自動作廢barcode
# Modify.........: No:TQC-D40036 13/04/16 By chenjing 取消审核赋值审核异动日期和审核异动人员
# Modify.........: No.DEV-D30043 13/04/17 By TSD.JIE 調整條碼自動編號(s_gen_barcode2)與條碼手動編號(s_diy_barcode)產生先後順序
# Modify.........: No.DEV-D40015 13/04/18 By Nina 調整取消確認時條碼作廢的檢核與Transaction
# Modify.........: No.MOD-D60026 13/06/04 By SunLM 如果採購參數設定sma112='Y',而價格條件設定價格不允許為0,那麼審核報錯
# Modify.........: No.MOD-D70041 13/07/08 By SunLM 調整TQC-C10045的修改内容
# Modify.........: No:TQC-D50088 13/07/15 By qirl 修改'g_errno'錯誤 工藝委外和委外採購都是去檢核apmi264
# Modify.........: No:MOD-D80026 13/08/05 By SunLM 调整ta_ecd010字段为ecdicd01作业群组，ta_pmn030字段调整为pmn78作业编号
# Modify.........: No:MOD-D90100 13/09/22 By SunLM 在审核段逻辑，增加请购数量和采购数量差异的审核判断 

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE l_ecm04  LIKE ecm_file.ecm04     #No.TQC-910033
DEFINE g_pnz08  LIKE pnz_file.pnz08    #FUN-C40089
DEFINE lc_gaq03 LIKE gaq_file.gaq03     #CHI-CB0069


 
FUNCTION t540sub_y_chk(l_pmm)
  DEFINE l_flag   LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)
  DEFINE l_cnt    LIKE type_file.num5      #No.FUN-680136 SMALLINT
  DEFINE l_pmn04  LIKE pmn_file.pmn04      #MOD-640074 add   #NO.FUN-9B0016
  DEFINE l_pmm      RECORD LIKE pmm_file.*
  DEFINE l_poz      RECORD LIKE poz_file.*        #No.MOD-860017 add
  DEFINE l_poy      RECORD LIKE poy_file.*        #No.MOD-860017 add
  DEFINE l_argv3  LIKE pmm_file.pmm02
  DEFINE l_ima915 LIKE ima_file.ima915     #FUN-710060 add
  DEFINE l_pmn43  LIKE pmn_file.pmn43      #NO.MOD-7B0085
  DEFINE l_pmn41  LIKE pmn_file.pmn41      #NO.MOD-7B0085
  DEFINE l_pmn18  LIKE pmn_file.pmn18      #No.TQC-910033
  DEFINE l_status LIKE type_file.chr1      #no.FUN-880016
  DEFINE l_t1     LIKE smy_file.smyslip    #NO.FUN-880016 
  DEFINE l_pmn02  LIKE pmn_file.pmn02      #CHI-960016                                                                              
  DEFINE l_pmn20  LIKE pmn_file.pmn20      #CHI-960016 
  DEFINE l_pmn012 LIKE pmn_file.pmn012     #No.FUN-A60011
  #-----MOD-A10033---------
  DEFINE l_gec07               LIKE gec_file.gec07,
         l_pmn31_1,l_pmn31_2   LIKE pmn_file.pmn31,
         l_pmn31t_1,l_pmn31t_2 LIKE pmn_file.pmn31t
  #-----END MOD-A10033-----
  
  DEFINE l_pmn52               LIKE pmn_file.pmn52        #FUN-AB0066
  DEFINE l_sfb82   LIKE sfb_file.sfb82,   #CHI-B10025
         l_sfb100  LIKE sfb_file.sfb100,  #CHI-B10025
         l_sfb02   LIKE sfb_file.sfb02,   #TQC-D50088 add
         l_sfb93   LIKE sfb_file.sfb93    #TQC-C10045
  DEFINE l_gec05   LIKE gec_file.gec05    #TQC-C30225 add
  DEFINE l_gemacti LIKE gem_file.gemacti  #TQC-C60178

  DEFINE l_pmnslk02 LIKE pmnslk_file.pmnslk02   #FUN-C70098
  DEFINE l_pmnslk04 LIKE pmnslk_file.pmnslk04   #FUN-C70098
  DEFINE l_pmnslk20 LIKE pmnslk_file.pmnslk20   #FUN-C70098
  DEFINE l_msg      LIKE type_file.chr1000 #CHI-CB0069 add
  DEFINE l_pmn01    LIKE pmn_file.pmn01       #add by guanyao160510
  DEFINE l_x        LIKE type_file.num5       #add by guanyao160510

  WHENEVER ERROR CONTINUE                #忽略一切錯誤  #FUN-730012
  LET g_success = 'Y'
  #MOD-D90100 add begin-------
  # check 請購量+容許量
  IF g_sma.sma32='Y' THEN   #請購與採購是否要互相勾稽   
     CALL t540sub_y_chk_qty(l_pmm.*)
     IF g_success = 'N' THEN 
        RETURN 
     END IF 
  END IF  
  #MOD-D90100 add end---------
#str-----add by guanyao160510
  IF l_pmm.pmm02 = "SUB" THEN 
     DECLARE pmnud03_curs CURSOR FOR
          SELECT pmn01,pmn02 FROM pmn_file WHERE pmn01 = l_pmm.pmm01 AND pmnud03 = 'Y'
       CALL s_showmsg_init()
       FOREACH pmnud03_curs INTO l_pmn01,l_pmn02
          LET l_x = 0
          SELECT COUNT(*) INTO l_x FROM tc_ecb_file WHERE tc_ecb02 = l_pmn01 AND tc_ecb03 = l_pmn02
          IF cl_null(l_x) OR l_x = 0 THEN
             CALL s_errmsg('', l_pmm.pmm01 ,l_pmn02 ,'cpm-003',1)
             LET g_success = 'N'
          END IF
       END FOREACH 
       CALL s_showmsg()
       IF g_success = 'N' THEN
          RETURN
       END IF
  END IF 
#end-----add by guanyao160510

  IF cl_null(l_pmm.pmm01) THEN
     CALL cl_err('','-400',1)  #MOD-640492 0->1
     LET g_success = 'N'   #FUN-580113
     RETURN
  END IF
#TQC-C60178 -- add -- begin
  SELECT gemacti INTO l_gemacti FROM gem_file
   WHERE gem01 = l_pmm.pmm13
  IF l_gemacti <> 'Y' THEN
     CALL cl_err(l_pmm.pmm13,'apm1079',0)
     LET g_success = 'N'
     RETURN
  END IF
#TQC-C60178 -- add -- end
#CHI-C30107 -------------- add --------------- begin
 
  IF l_pmm.pmm18='Y' THEN
    #CALL cl_err('','9023',1)  #MOD-640492 0->1    #CHI-CB0069 mark
     CALL cl_err(l_pmm.pmm01,'9023',1)             #CHI-CB0069 add
     LET g_success = 'N'   #FUN-580113
     RETURN
  END IF

  IF l_pmm.pmm18='X' THEN
    #CALL cl_err('','9024',1)   #MOD-640492 0->1   #CHI-CB0069 mark
     CALL cl_err(l_pmm.pmm01,'9024',1)             #CHI-CB0069 add
     LET g_success = 'N'   #FUN-580113
     RETURN
  END IF

  IF l_pmm.pmmmksg='Y'   THEN
  END IF
  IF l_pmm.pmmacti='N' THEN
    #CALL cl_err('','mfg0301',1)                   #CHI-CB0069 mark
     CALL cl_err(l_pmm.pmm01,'mfg0301',1)          #CHI-CB0069 add
     LET g_success = 'N'   #FUN-580113
     RETURN
  END IF
  IF g_action_choice CLIPPED = "confirm" OR      #執行 "確認" 功能(非簽核模式呼叫)
     g_action_choice CLIPPED = "insert"  THEN
     IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF
  END IF
#CHI-C30107 -------------- add --------------- end
  SELECT * INTO l_pmm.* FROM pmm_file WHERE pmm01=l_pmm.pmm01
  LET l_argv3=l_pmm.pmm02 #FUN-730012
  IF l_pmm.pmm18='Y' THEN
    #CALL cl_err('','9023',1)  #MOD-640492 0->1   #CHI-CB0069 mark
     CALL cl_err(l_pmm.pmm01,'9023',1)            #CHI-CB0069 add
     LET g_success = 'N'   #FUN-580113
     RETURN
  END IF
 
  IF l_pmm.pmm18='X' THEN
    #CALL cl_err('','9024',1)   #MOD-640492 0->1  #CHI-CB0069 mark
     CALL cl_err(l_pmm.pmm01,'9024',1)            #CHI-CB0069 add
     LET g_success = 'N'   #FUN-580113
     RETURN
  END IF
 
  IF l_pmm.pmmmksg='Y'   THEN
  END IF
  IF l_pmm.pmmacti='N' THEN
    #CALL cl_err('','mfg0301',1)                  #CHI-CB0069 mark
     CALL cl_err(l_pmm.pmm01,'mfg0301',1)         #CHI-CB0069 add
     LET g_success = 'N'   #FUN-580113
     RETURN
  END IF
 
  #---------No:CHI-B10040 add
   IF l_pmm.pmm25 = '6' THEN 
     #CALL cl_err('','apm-143',1)                 #CHI-CB0069 mark
      CALL cl_err(l_pmm.pmm01,'apm-143',1)        #CHI-CB0069 add 
      LET g_success = 'N'     
      RETURN 
   END IF     
  #---------No:CHI-B10040 end

  LET l_flag='N'
  IF cl_null(l_pmm.pmm09) THEN
     LET l_flag = 'Y'
  END IF
  IF cl_null(l_pmm.pmm04) THEN
     LET l_flag = 'Y'
  END IF
  IF cl_null(l_pmm.pmm20) THEN
     LET l_flag = 'Y'
  END IF
  IF cl_null(l_pmm.pmm21) THEN
     LET l_flag = 'Y'
  END IF
  IF cl_null(l_pmm.pmm02) THEN
     LET l_flag = 'Y'
  END IF
  IF l_flag='Y' THEN
     DISPLAY BY NAME l_pmm.pmm09
     DISPLAY BY NAME l_pmm.pmm04
     DISPLAY BY NAME l_pmm.pmm20
     DISPLAY BY NAME l_pmm.pmm21
     DISPLAY BY NAME l_pmm.pmm02
    #CALL cl_err('','mfg6138',1)                  #CHI-CB0069 mark
     CALL cl_err(l_pmm.pmm01,'mfg6138',1)         #CHI-CB0069 add
     LET g_success = 'N'   #FUN-580113
     RETURN
  END IF
  IF l_pmm.pmm02='TAP' AND cl_null(l_pmm.pmm904) THEN
    #CALL cl_err('','apm-017',1)                  #CHI-CB0069 mark
     CALL cl_err(l_pmm.pmm01,'apm-017',1)         #CHI-CB0069 add
     LET g_success = 'N'   #FUN-580113
     RETURN
  END IF
  
#TQC-B10228 --begin--
  CALL t590_pmm12_check(l_pmm.pmm12)
  IF NOT cl_null(g_errno) THEN 
     CALL cl_err(l_pmm.pmm12,g_errno,0)
     LET g_success = 'N'
     RETURN 
  END IF 
#TQC-B10228 --end--
  
  IF l_pmm.pmm02='TAP' THEN
     SELECT * INTO l_poz.* FROM poz_file
      WHERE poz01 = l_pmm.pmm904 AND pozacti = 'Y'
 
     SELECT * INTO l_poy.* FROM poy_file
     WHERE poy01 = l_pmm.pmm904 AND poy02 = 1  
 
     IF l_poy.poy03 <> l_pmm.pmm09 THEN
       #CALL cl_err('','apm-007',1)               #CHI-CB0069 mark
        CALL cl_err(l_pmm.pmm01,'apm-007',1)      #CHI-CB0069 add 
        LET g_success = 'N'  
        RETURN
     END IF
     #No.7920 若不指定幣別，則不用對應流程代碼的幣別
     IF l_poz.poz09 = 'Y' THEN
        IF l_poy.poy05 <> l_pmm.pmm22 THEN
          #CALL cl_err('','apm-008',1)            #CHI-CB0069 mark
           CALL cl_err(l_pmm.pmm01,'apm-008',1)   #CHI-CB0069 add 
           LET g_success = 'N'  
           RETURN
        END IF
     END IF
  END IF
  #no.7231 參數設定單價不可為零
  #FUN-C40089---begin
  SELECT pnz08 INTO g_pnz08 FROM pnz_file WHERE pnz01 = l_pmm.pmm41
  IF cl_null(g_pnz08) THEN 
     LET g_pnz08 = 'Y'
  END IF 
 # IF g_pnz08 = 'N' AND l_argv3 != 'SUB' THEN  #MOD-D60026 mark
  IF g_pnz08 = 'N' THEN  #MOD-D60026
 #IF g_sma.sma112= 'N' AND l_argv3 != 'SUB' THEN      #No.TQC-690086 modify
  #FUN-C40089---end
    # IF g_sma.sma112= 'N' THEN      #MOD-D10103 add #MOD-D60026 mark
     IF g_sma.sma112= 'Y' THEN    #MOD-D60026 add
        IF s_industry('icd') AND l_pmm.pmm02 = 'SUB' THEN
           SELECT COUNT(*) INTO l_cnt FROM pmn_file
            WHERE pmn01 = l_pmm.pmm01
              AND (pmn31 <=0 OR pmn44 <=0)
              AND (pmn65 = '2' OR    #委外代採
                 # (pmn65 = '1' AND ta_pmn030 NOT IN #一般代採買且作業群組不為6.TKY #MOD-D80026 mark
                 # (SELECT ecd01 FROM ecd_file WHERE ta_ecd010 = '6'))) #MOD-D80026 mark
                 (pmn65 = '1' AND pmn78 NOT IN #一般代採買且作業群組不為6.TKY MOD-D80026 add
                 (SELECT ecd01 FROM ecd_file WHERE ecdicd01 = '6'))) #MOD-D80026 add
        ELSE
           SELECT COUNT(*) INTO l_cnt FROM pmn_file
            WHERE pmn01 = l_pmm.pmm01
              AND (pmn31 <=0 OR pmn44 <=0 )
        END IF
        IF l_cnt > 0 THEN
          #CALL cl_err('','axm-627',1)    #MOD-840328 #FUN-C50076   #CHI-CB0069 mark
           CALL cl_err(l_pmm.pmm01,'axm-627',1)                     #CHI-CB0069 add
           LET g_success = 'N'   #FUN-580113
           RETURN
        END IF
     END IF   #MOD-D10103 add
  END IF
 
#---MODNO:7379---無單身資料不可確認
  LET l_cnt=0
  SELECT COUNT(*) INTO l_cnt
    FROM pmn_file
   WHERE pmn01=l_pmm.pmm01
  IF l_cnt=0 OR l_cnt IS NULL THEN
    #CALL cl_err('','mfg-009',1)  #MOD-640492 0->1               #CHI-CB0069 mark
     CALL cl_err(l_pmm.pmm01,'mfg-009',1)                        #CHI-CB0069 add
     LET g_success = 'N'   #FUN-580113
     RETURN
  END IF
#FUN-C70098----add----begin--------------
  IF s_industry("slk")  AND g_azw.azw04 = '2' THEN
       DECLARE pmnslk04_curs CURSOR FOR
          SELECT pmnslk02,pmnslk04,pmnslk20 FROM pmnslk_file WHERE pmnslk01 = l_pmm.pmm01 
       CALL s_showmsg_init()
       FOREACH pmnslk04_curs INTO l_pmnslk02,l_pmnslk04,l_pmnslk20
           IF cl_null(l_pmnslk20) OR l_pmnslk20 = 0 THEN
              CALL s_errmsg('', l_pmm.pmm01 ,l_pmnslk04 ,'alm1496',1)
              LET g_success = 'N'
           END IF
       END FOREACH
       CALL s_showmsg()
       IF g_success = 'N' THEN
          RETURN
       END IF
   END IF
   #FUN-C70098----add----end----------------

#FUN-AB0066 --begin--
  DECLARE t540_sub_pmn52 CURSOR FOR 
   SELECT pmn52 FROM pmn_file  
    WHERE pmn01 = l_pmm.pmm01
  FOREACH t540_sub_pmn52 INTO l_pmn52
     IF NOT s_chk_ware(l_pmn52) THEN 
        LET g_success = 'N'
        RETURN 
     END IF 
  END FOREACH     
#FUN-AB0066 --end--

  IF g_smy.smy59='Y' AND g_success='Y' THEN CALL t540sub_budchk(l_pmm.pmm01) END IF   #MOD-AC0411
 
IF g_aza.aza71 MATCHES '[Yy]' THEN   #FUN-8A0054 判斷是否有勾選〝與GPM整合〞，有則做GPM控
   LET l_t1 = s_get_doc_no(l_pmm.pmm01) 
   SELECT * INTO g_smy.* FROM smy_file
    WHERE smyslip=l_t1
   IF g_smy.smy64 != '0' THEN    #要控管
      CALL s_showmsg_init()
      CALL aws_gpmcli_part(l_pmm.pmm01,l_pmm.pmm09,'','1')
           RETURNING l_status
      IF l_status = '1' THEN   #回傳結果為失敗
         IF g_smy.smy64 = '1' THEN
            CALL s_showmsg()
         END IF
         IF g_smy.smy64 = '2' THEN   
             LET g_success = 'N'
             CALL s_showmsg()
             RETURN
         END IF
      END IF
   END IF
END IF         #FUN-8A0054
 
#交貨日不可空白
  LET l_cnt=0
  SELECT COUNT(*) INTO l_cnt FROM pmn_file
   WHERE pmn01 = l_pmm.pmm01
     AND pmn33 IS NULL
  IF l_cnt > 0 THEN
    #CALL cl_err('','mfg3226',1)            #CHI-CB0069 mark
     CALL cl_err(l_pmm.pmm01,'mfg3226',1)   #CHI-CB0069 add
     LET g_success = 'N'   #FUN-580113
     RETURN
  END IF
  #-----CHI-B10025---------
  IF l_pmm.pmm02 = 'SUB' THEN
    #SELECT sfb82,sfb100 INTO l_sfb82,l_sfb100
    #SELECT sfb82,sfb100,sfb93 INTO l_sfb82,l_sfb100,l_sfb93 #TQC-C10045 add sfb93  #TQC-D50088 mark--
     SELECT sfb82,sfb100,sfb93,sfb02 INTO l_sfb82,l_sfb100,l_sfb93,l_sfb02 #TQC-C10045 add sfb93   #TQC-D50088 add l_sfb02
       FROM sfb_file,pmn_file
      WHERE pmn01 = l_pmm.pmm01
        AND sfb01 = pmn41
        AND sfb87 != 'X'
        AND (pmn43 IS NULL OR pmn43= 0) 
     IF NOT s_industry('icd') THEN
         IF l_sfb100 <> '2' AND NOT cl_null(l_sfb82) THEN 
            IF l_pmm.pmm09 <> l_sfb82 THEN
               #CALL cl_err('','apm-038',1)            #CHI-CB0069 mark
               CALL cl_err(l_pmm.pmm01,'apm-038',1)    #CHI-CB0069 add 
                LET g_success = 'N'
                RETURN
            END IF
         END IF
     END IF
  END IF
  #-----END CHI-B10025-----
  #交貨日期不可小于采購日期。
  CALL t540_chk_date(l_pmm.pmm01,l_pmm.pmm04)
  IF g_success ='N' THEN
     RETURN
  END IF
 
  #採購料件/供應商控制
      DECLARE pmn_cur_pmn04 CURSOR FOR
         SELECT pmn04,pmn41,pmn43,pmn18,pmn012,pmn02  #NO.TQC-910033   #No.FUN-A60011                                         #CHI-CB0069 add ,pmn02
           FROM pmn_file
          WHERE pmn01=l_pmm.pmm01
      FOREACH pmn_cur_pmn04 INTO l_pmn04,l_pmn41,l_pmn43,l_pmn18,l_pmn012,l_pmn02     #No.TQC-910033 MARK  #No.FUN-A60011     #CHI-CB0069 add ,l_pmn02
         SELECT ima915 INTO l_ima915 FROM ima_file
          WHERE ima01=l_pmn04
         IF l_ima915='2' OR l_ima915='3' THEN
             IF (l_pmn04[1,4] != 'MISC') THEN #MOD-650030 add if 判
                 IF l_pmm.pmm02 = 'SUB' THEN  #MOD-D70041 recovery
                 #IF l_pmm.pmm02 = 'SUB' AND (l_sfb93 = 'Y' OR l_sfb02 = '7') THEN  #TQC-C10045 add sfb93
                   #TQC-D50088 add OR l_sfb02 = '7' #MOD-D70041 mark
                    CALL t540sub_pmh(l_pmn04,l_pmn41,l_pmn43,l_pmn18,l_pmn012,l_pmm.*,'2') #NO.TQC-910033  #No.FUN-A60011
                 ELSE
                    CALL t540sub_pmh(l_pmn04,l_pmn41,l_pmn43,l_pmn18,l_pmn012,l_pmm.*,'1') #No.TQC-910033   #No.FUN-A60011
                 END IF
                 IF NOT cl_null(g_errno) THEN
                    #CALL cl_err(l_pmn04,g_errno,1)   #CHI-CB0069 mark
                    #CHI-CB0069 -- add start --
                    CALL cl_get_feldname('pmn01',g_lang) RETURNING lc_gaq03
                    LET l_msg = lc_gaq03,":",l_pmm.pmm01," "
                    CALL cl_get_feldname('pmn02',g_lang) RETURNING lc_gaq03
                    LET l_msg = l_msg,lc_gaq03,":",l_pmn02," "
                    CALL cl_get_feldname('pmn04',g_lang) RETURNING lc_gaq03
                    LET l_msg = l_msg,lc_gaq03,":",l_pmn04
                #   CALL cl_err(l_msg,'g_errno',1)  #TQC-D50088-mark--
                    CALL cl_err(l_msg,g_errno,1)  #TQC-D50088-add--
                    #CHI-CB0069 -- add end --
                     LET g_success = 'N'
                     EXIT FOREACH
                 END IF
             END IF #MOD-650030 add
         END IF     #FUN-710060 add
      END FOREACH
 
     #確保每一筆資料的采購量不為0                                                                                                   
      DECLARE t540_pmn20_cs CURSOR FOR                                                                                              
       #SELECT pmn02,pmn20 FROM pmn_file   #MOD-A10033                                                                                          
       SELECT pmn02,pmn20,pmn31,pmn31t FROM pmn_file   #MOD-A10033                                                                                          
        WHERE pmn01=l_pmm.pmm01                                                                                                     
          AND pmn42 != '2' #MOD-C80061 add
      #FOREACH t540_pmn20_cs INTO l_pmn02,l_pmn20   #MOD-A10033                                                                                 
      FOREACH t540_pmn20_cs INTO l_pmn02,l_pmn20,l_pmn31_1,l_pmn31t_1   #MOD-A10033                                                                                 
         IF l_pmn20=0 THEN                                                                                                          
           #CALL cl_err(l_pmn20,'afa-978',1)     #CHI-CB0069 mark
            #CHI-CB0069 -- add start --
            CALL cl_get_feldname('pmn01',g_lang) RETURNING lc_gaq03
            LET l_msg = lc_gaq03,":",l_pmm.pmm01," "
            CALL cl_get_feldname('pmn02',g_lang) RETURNING lc_gaq03
            LET l_msg = l_msg,lc_gaq03,":",l_pmn02," "
            CALL cl_get_feldname('pmn20',g_lang) RETURNING lc_gaq03
            LET l_msg = l_msg,lc_gaq03,":",l_pmn20
            CALL cl_err(l_msg,'afa-978',1)
            #CHI-CB0069 -- add end -- 
            LET g_success='N'                                                                                                       
            EXIT FOREACH                                                                                                            
         END IF                                                                                                                     
         #-----MOD-A10033---------
         SELECT gec07,gec05 INTO l_gec07,l_gec05 FROM gec_file  #TQC-C30225 add gec05 
            WHERE gec01 = l_pmm.pmm21 AND gec011 = '1' 
         SELECT azi03 INTO t_azi03 FROM azi_file 
            WHERE azi01 = l_pmm.pmm22
         IF l_gec07 = 'N' THEN
            LET l_pmn31t_2 = l_pmn31_1 * (1.00+l_pmm.pmm43 / 100.0)  #MOD-B70152 mark  #TQC-B70161 還原MOD-B70152的處理
            LET l_pmn31t_2 = cl_digcut(l_pmn31t_2,t_azi03)           #MOD-B70152 mark  #TQC-B70161 還原MOD-B70152的處理
            #LET l_pmn31t_2 = cl_digcut(l_pmn31_1 * (1.00+l_pmm.pmm43 / 100.0),t_azi03)    #MOD-B70152
            IF l_pmn31t_1 <> l_pmn31t_2 THEN
              #CALL cl_err(l_pmn20,'apm-625',1)   #CHI-CB0069 mark
               #CHI-CB0069 -- add start --
               CALL cl_get_feldname('pmn01',g_lang) RETURNING lc_gaq03
               LET l_msg = lc_gaq03,":",l_pmm.pmm01," "
               CALL cl_get_feldname('pmn02',g_lang) RETURNING lc_gaq03
               LET l_msg = l_msg,lc_gaq03,":",l_pmn02," "
               CALL cl_get_feldname('pmn20',g_lang) RETURNING lc_gaq03
               LET l_msg = l_msg,lc_gaq03,":",l_pmn20
               CALL cl_err(l_msg,'apm-625',1)
               #CHI-CB0069 -- add end --
               LET g_success='N'
               EXIT FOREACH
            END IF
         ELSE
            LET l_pmn31_2 = l_pmn31t_1/(1.00+l_pmm.pmm43/100.0)    #MOD-B70152 mark   #TQC-B70161 還原MOD-B70152的處理                                                                
            LET l_pmn31_2 = cl_digcut(l_pmn31_2,t_azi03)           #MOD-B70152 mark   #TQC-B70161 還原MOD-B70152的處理
           #LET l_pmn31t_2 = cl_digcut(l_pmn31_1 * (1.00+l_pmm.pmm43 / 100.0),t_azi03)    #MOD-B70152
           #LET l_pmn31_2 = cl_digcut(l_pmn31t_1 / (1.00+l_pmm.pmm43 / 100.0),t_azi03)    #TQC-B70156
            #TQC-C30225 add begin
            #IF l_gec05 = 'T' THEN 
            IF l_gec05  MATCHES '[AT]' THEN  #FUN-D10128
               LET l_pmn31_2 = l_pmn31t_1 * (1.00 - l_pmm.pmm43/100.0)
               LET l_pmn31_2 = cl_digcut(l_pmn31_2,t_azi03)
            END IF 
            #TQC-C30225 add end
            IF l_pmn31_1 <> l_pmn31_2 THEN
              #CALL cl_err(l_pmn20,'apm-625',1)   #CHI-CB0069 mark
               #CHI-CB0069 -- add start --
               CALL cl_get_feldname('pmn01',g_lang) RETURNING lc_gaq03
               LET l_msg = lc_gaq03,":",l_pmm.pmm01," "
               CALL cl_get_feldname('pmn02',g_lang) RETURNING lc_gaq03
               LET l_msg = l_msg,lc_gaq03,":",l_pmn02," "
               CALL cl_get_feldname('pmn20',g_lang) RETURNING lc_gaq03
               LET l_msg = l_msg,lc_gaq03,":",l_pmn20
               CALL cl_err(l_msg,'apm-625',1)
               #CHI-CB0069 -- add end --
               LET g_success='N'
               EXIT FOREACH
            END IF
         END IF
         #-----END MOD-A10033-----
      END FOREACH                                                                                                                   
 
  IF s_industry('icd') THEN
     CALL t540_ind_icd_sub_upd(l_pmm.pmm01,l_pmm.pmm02,l_pmm.pmm09,l_pmm.pmm43)
  END IF
END FUNCTION

#TQC-B10228 --begin--
FUNCTION t590_pmm12_check(p_cmd)  
 DEFINE p_cmd       LIKE pmm_file.pmm12
 DEFINE l_genacti   LIKE gen_file.genacti
 
   LET g_errno = ' '
   SELECT genacti INTO l_genacti FROM gen_file 
    WHERE gen01 = p_cmd
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'                                    
        WHEN l_genacti='N'        LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   
END FUNCTION
#TQC-B10228 --end--
 
#系統參數設料件/供應商須存在
FUNCTION t540sub_pmh(l_part,l_pmn41,l_pmn43,l_pmn18,l_pmn012,l_pmm,l_type)      #NO.TQC-910033  #No.FUN-A60011
 DEFINE l_pmhacti LIKE pmh_file.pmhacti,
        l_pmh05   LIKE pmh_file.pmh05,
        l_part    LIKE pmh_file.pmh01,
        l_pmm     RECORD LIKE pmm_file.*
 DEFINE l_type    LIKE pmh_file.pmh22    #No.TQC-740250
 DEFINE l_pmn41   LIKE pmn_file.pmn41    #NO.MOD-7B0085
 DEFINE l_pmn43   LIKE pmn_file.pmn43    #NO.MOD-7B0085
 DEFINE l_pmn18   LIKE pmn_file.pmn18    #No.TQC-910033
 DEFINE l_pmn012  LIKE pmn_file.pmn012   #No.FUN-A60011
 DEFINE l_ecm04   LIKE ecm_file.ecm04    #NO.MOD-7B0085
 DEFINE l_pmn     RECORD LIKE pmn_file.*   #No.TQC-910033
 
 
 LET g_errno = " "
     IF l_type = '1' THEN      #NO.MOD-7B0085
         SELECT pmhacti,pmh05 INTO l_pmhacti,l_pmh05 FROM pmh_file
          WHERE pmh01=l_part AND pmh02=l_pmm.pmm09
           AND pmh13=l_pmm.pmm22 
           AND pmh21 = " " AND pmh22 = l_type   #No.TQC-740164       
           AND pmhacti = 'Y'                                           #CHI-910021
     ELSE
         #委外製程時，找出製程作業編號
         IF l_pmn43 =0 OR cl_null(l_pmn43) THEN     #No.TQC-910033
           LET l_ecm04 = ' '                        #No.TQC-910033
         ELSE                                       #No.TQC-910033
           IF NOT cl_null(l_pmn18) THEN                                         
              SELECT sgm04 INTO l_ecm04  FROM sgm_file                          
               WHERE sgm01 = l_pmn18                                            
                 AND sgm02 = l_pmn41                                            
                 AND sgm03 = l_pmn43                                            
                 AND sgm012 = l_pmn012  #No.FUN-A60076 
           ELSE                                                                 
                 #委外制程時，找出制程作業編號                                  
              SELECT ecm04 INTO l_ecm04                                         
                FROM ecm_file                                                   
               WHERE ecm01 = l_pmn41                                            
                 AND ecm03 = l_pmn43                                            
                 AND ecm012= l_pmn012   #No.FUN-A60011
           END IF                                                               
         IF cl_null(l_ecm04) THEN LET l_ecm04 = ' ' END IF
         END IF                                     #No.TQC-910033
         SELECT pmhacti,pmh05 INTO l_pmhacti,l_pmh05 FROM pmh_file
          WHERE pmh01=l_part AND pmh02=l_pmm.pmm09
           AND pmh13=l_pmm.pmm22
           AND pmh21 = l_ecm04 AND pmh22 = l_type   #No.TQC-740164       
           AND pmhacti = 'Y'                                           #CHI-910021
     END IF
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0031'
                                   LET l_pmhacti = NULL
         WHEN l_pmhacti='N'        LET g_errno = 'apm-068'   #MOD-850224
         WHEN l_pmh05 MATCHES '[12]' LET g_errno = 'mfg3043'   #00/03/07 add
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 

#作用:lock cursor
#回傳值:無
FUNCTION t540sub_lock_cl()
   DEFINE l_forupd_sql STRING
   LET l_forupd_sql = "SELECT * FROM pmm_file WHERE pmm01 = ? FOR UPDATE"
   LET l_forupd_sql=cl_forupd_sql(l_forupd_sql)

   DECLARE t540sub_cl CURSOR FROM l_forupd_sql
END FUNCTION
 
FUNCTION t540sub_y_upd(l_pmm01,p_action_choice)
  DEFINE l_pmm01 LIKE pmm_file.pmm01,
         p_action_choice STRING,
         l_cnt  LIKE type_file.num5,
         l_pmm RECORD LIKE pmm_file.*,
         l_sta  LIKE ze_file.ze03,
         l_pmmmksg LIKE pmm_file.pmmmksg,
         l_pmm25   LIKE pmm_file.pmm25
 
  WHENEVER ERROR CONTINUE #FUN-730012
 
  LET g_success = 'Y'
  IF p_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
     p_action_choice CLIPPED = "insert"     #FUN-640184
  THEN
     SELECT pmmmksg,pmm25
       INTO l_pmmmksg,l_pmm25
       FROM pmm_file
      WHERE pmm01=l_pmm01
     IF l_pmmmksg='Y'   THEN
        IF l_pmm25 != '1' THEN
           CALL cl_err('','aws-078',1)
           LET g_success = 'N'
           RETURN
        END IF
     END IF
#    IF NOT cl_confirm('axm-108') THEN RETURN END IF   #FUN-580113 #CHI-C30107 mark
  END IF
  
  IF NOT cl_null(p_action_choice) THEN   #FUN-A80102
     BEGIN WORK
  END IF
  LET g_success = 'Y'
  CALL t540sub_lock_cl() #FUN-730012
  OPEN t540sub_cl USING l_pmm01
  IF STATUS THEN
     CALL cl_err("OPEN t540sub_cl:", STATUS, 1)
     CLOSE t540sub_cl
     IF NOT cl_null(p_action_choice) THEN   #FUN-A80102
        ROLLBACK WORK
     END IF
     RETURN
  END IF
  FETCH t540sub_cl INTO l_pmm.*               # 對DB鎖定
  IF SQLCA.sqlcode THEN
     CALL cl_err(l_pmm.pmm01,SQLCA.sqlcode,1)   #MOD-640492 0->1
     IF NOT cl_null(p_action_choice) THEN   #FUN-A80102     
        ROLLBACK WORK
     END IF
     RETURN
  END IF
  #----檢查Blanket P/O是否為 null  -----
  IF g_smy.smy57[4,4] = 'Y' THEN
     LET l_cnt=0
     SELECT COUNT(*) INTO l_cnt FROM pmn_file
      WHERE pmn01 = l_pmm.pmm01
        AND ((pmn68 IS NULL OR pmn68 = ' ') OR
             (pmn69 IS NULL OR pmn69 = ' '))
     IF l_cnt > 0 THEN
         CALL cl_err('','apm-906',1)   #No.MOD-4A0356
        LET g_success='N'
        IF NOT cl_null(p_action_choice) THEN   #FUN-A80102     
           ROLLBACK WORK
        END IF
        RETURN
     END IF
  END IF
 
  CALL t540sub_y1(l_pmm.*)
 
# Update ecm_file if exist
  IF g_sma.sma54='Y' THEN #是否使用製程
     CALL t540sub_upd_ecm('+',l_pmm.pmm01)
  END IF
  IF l_pmm.pmm02='SUB' THEN
     CALL t540sub_upd_sgm('+',l_pmm.pmm01)
  END IF
  #--------------------------------- 請採購預算控管 00/03/29 By Melody
  #IF g_smy.smy59='Y' AND g_success='Y' THEN CALL t540sub_budchk(l_pmm.pmm01) END IF   #MOD-AC0411
  IF g_success = 'Y' THEN
     IF l_pmm.pmmmksg= 'Y' THEN #簽核模式
        CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
            WHEN 0  #呼叫 EasyFlow 簽核失敗
                 LET l_pmm.pmm18="N"
                 LET g_success = "N"
                 IF NOT cl_null(p_action_choice) THEN   #FUN-A80102
                    ROLLBACK WORK
                 END IF
                 RETURN
            WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                 LET l_pmm.pmm18="N"
                 IF NOT cl_null(p_action_choice) THEN   #FUN-A80102
                    ROLLBACK WORK
                 END IF
                 RETURN
        END CASE
     END IF
 
     IF s_industry('icd') THEN
        IF NOT t540sub_icd_upd_data1(l_pmm.pmm01) THEN   #CHI-920042 add 參數l_pmm.pmm01
           LET g_success = 'N' 
        END IF
     END IF
 
     LET l_cnt=0
     SELECT COUNT(*) INTO l_cnt FROM pmn_file
      WHERE pmn01 = l_pmm.pmm01
     IF l_cnt = 0 AND l_pmm.pmmmksg = 'Y' THEN
        CALL cl_err(' ','aws-065',1)  #MOD-640492 0->1
        LET g_success = 'N'
     END IF
     IF g_success = 'Y' THEN
        LET l_pmm.pmm25='1'         #執行成功, 狀態值顯示為 '1' 已核准
        UPDATE pmm_file SET pmm25 = l_pmm.pmm25 WHERE pmm01=l_pmm.pmm01
        IF SQLCA.sqlerrd[3]=0 THEN
           LET g_success='N'
           LET l_pmm.pmm18='N'   #MOD-990227
        ELSE   #MOD-990227
           LET l_pmm.pmm18='Y'   #MOD-990227
        END IF
 
        IF NOT cl_null(p_action_choice) THEN   #FUN-A80102
           COMMIT WORK
        END IF
        CALL cl_flow_notify(l_pmm.pmm01,'Y')
        DISPLAY BY NAME l_pmm.pmm25
        CALL s_pmmsta('pmm',l_pmm.pmm25,l_pmm.pmm18,l_pmm.pmmmksg)
                      RETURNING l_sta
        IF NOT cl_null(p_action_choice) THEN   #FUN-A80102  #TQC-730022
           DISPLAY BY NAME l_pmm.pmm18
        END IF
     ELSE
        LET l_pmm.pmm18 = 'N'
        IF NOT cl_null(p_action_choice) THEN   #FUN-A80102
           ROLLBACK WORK
        END IF
     END IF
  ELSE
     LET l_pmm.pmm18='N'
     ROLLBACK WORK
  END IF
  ##CKP

   #DEV-D30045--add--begin
   #自動產生barcode
   IF g_success='Y' AND (g_prog = 'apmt540' OR g_prog = 'apmt590') AND
      g_aza.aza131 = 'Y' THEN
      CALL t540sub_barcode_gen(l_pmm.pmm01,'N')
   END IF
   #DEV-D30045--add--end

END FUNCTION
 
FUNCTION t540sub_y1(l_pmm)
   DEFINE l_pmm     RECORD LIKE pmm_file.*
   DEFINE l_cmd     LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(400)
   DEFINE l_str     LIKE gsb_file.gsb05     #No.FUN-680136 VARCHAR(04)
   DEFINE l_wc      LIKE type_file.chr1000  #No.TQC-610085 add  #No.FUN-680136 VARCHAR(400)
   DEFINE l_pmn04   LIKE pmn_file.pmn04
   DEFINE l_imaacti LIKE ima_file.imaacti
   DEFINE l_ima140  LIKE ima_file.ima140
   DEFINE l_ima1401 LIKE ima_file.ima1401   #FUN-6A0036 add
   DEFINE l_user    STRING                  #FUN-A80087 add
   DEFINE l_zx01    LIKE zx_file.zx01       #FUN-A80087 add
   DEFINE l_cnt     LIKE type_file.num5     #FUN-A80087 add
 

    ###### 01/10/29 Tommy 無效料件或Phase Out者不可以請購
    DECLARE pmn_cur1 CURSOR FOR
       SELECT pmn04
         FROM pmn_file
        WHERE pmn01=l_pmm.pmm01
    FOREACH pmn_cur1 INTO l_pmn04
       LET l_str = l_pmn04[1,4]  #No:7225
       IF l_str = 'MISC' THEN CONTINUE FOREACH END IF #No:7225
       SELECT imaacti,ima140,ima1401
         INTO l_imaacti,l_ima140,l_ima1401  #FUN-6A0036(add ima1401)
         FROM ima_file
        WHERE ima01 = l_pmn04
       IF SQLCA.sqlcode THEN
          IF l_pmn04[1,4] <>'MISC' THEN  #NO:6808
              LET l_imaacti = 'N'
              LET l_ima140 = 'Y'
          END IF
       END IF
       IF l_imaacti = 'N' OR (l_ima140 = 'Y' AND l_ima1401 <= l_pmm.pmm04)  THEN    #FUN-6A0036
          CALL cl_err(l_pmn04,'apm-006',1)  #MOD-640492 0->1
          LET g_success = 'N'
        RETURN
       END IF
    END FOREACH
    IF l_pmm.pmmmksg='N' AND l_pmm.pmm25='0' THEN
       LET l_pmm.pmm25='1'
       UPDATE pmn_file SET pmn16=l_pmm.pmm25
        WHERE pmn01=l_pmm.pmm01
          AND pmn16 ='0'         #MOD-630039
       IF STATUS THEN
          CALL cl_err3("upd","pmn_file",l_pmm.pmm01,"",STATUS,"","upd pmn16",1)  #No.FUN-660129
          LET g_success = 'N' RETURN
       END IF
    END IF
 
   #FUN-A80087 add str --------------
    IF g_action_choice = "efconfirm" THEN
       CALL aws_efapp_getEFLogonID() RETURNING l_user
       LET l_zx01 = l_user
 
       SELECT count(*) INTO l_cnt
         FROM zx_file
        WHERE zxacti = 'Y'
          AND zx01 = l_zx01
       IF l_cnt = 0 THEN
          LET l_zx01 = l_pmm.pmmuser
       END IF
    ELSE
       LET l_zx01 = g_user
    END IF
   #FUN-A80087 add end --------------
 
   LET l_pmm.pmmcont=TIME
   UPDATE pmm_file 
      SET pmm25 = l_pmm.pmm25
         ,pmm18 = 'Y'
        #,pmm15 = g_user            #MOD-A10046 #FUN-A80087mark
         ,pmm15 = l_zx01            #FUN-A80087 add
         ,pmmconu = g_user
         ,pmmcond = g_today
         ,pmmcont = l_pmm.pmmcont 
    WHERE pmm01 = l_pmm.pmm01
 
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","pmm_file",l_pmm.pmm01,"",STATUS,"","upd pmn18",1)  #No.FUN-660129
      LET g_success = 'N' RETURN
   END IF
   IF g_aza.aza09='Y' AND l_pmm.pmmmksg='Y' THEN
      LET l_wc='pmm01="',l_pmm.pmm01,'"'
      LET l_cmd = "apmrx02 ",
                  " '",g_today CLIPPED,"' ''",
                  " '",g_lang CLIPPED,"' 'Y' '' '1'",
                  " '",l_wc CLIPPED,"' "
      CALL cl_cmdrun(l_cmd)
   END IF
END FUNCTION
 
#更新資料（確認回寫）
FUNCTION t540sub_icd_upd_data1(l_pmm01)  #CHI-920042 add l_pmm01
   DEFINE l_pmn          RECORD LIKE pmn_file.*,
          l_qty          LIKE pmn_file.pmn20,
          l_blanket_qty  LIKE pmn_file.pmn20,
          l_pmn20        LIKE pmn_file.pmn20,
          l_pmniicd13    LIKE pmni_file.pmniicd13,
          l_msg          LIKE type_file.chr50
   DEFINE l_pmm01        LIKE pmm_file.pmm01            #CHI-920042
 
   DECLARE blanket_cs CURSOR FOR
    SELECT * FROM pmn_file WHERE pmn01 = l_pmm01        #CHI-920042
 
   FOREACH blanket_cs INTO l_pmn.*
      IF cl_null(l_pmn.pmn68) OR cl_null(l_pmn.pmn69) THEN
         CONTINUE FOREACH
      END IF
 
      LET l_qty = l_pmn.pmn20 / l_pmn.pmn62 * l_pmn.pmn70
 
      SELECT pmn20 INTO l_pmn20 FROM pmn_file
       WHERE pmn01 = l_pmn.pmn68 AND pmn02 = l_pmn.pmn69
      SELECT pmniicd13 INTO l_pmniicd13 FROM pmni_file
       WHERE pmni01 = l_pmn.pmn68 AND pmni02 = l_pmn.pmn69
      LET l_blanket_qty = l_pmn20 - l_pmniicd13
     #LET l_blanket_qty = l_blanket_qty - l_qty           #MOD-AA0150 mark
 
      IF l_blanket_qty < 0 THEN
         LET l_msg = l_pmn.pmn68,'(',l_pmn.pmn69,')'
         CALL cl_err(l_msg,'apm-905',1)
         RETURN FALSE 
      ELSE
         IF l_blanket_qty = 0 THEN
            UPDATE pmni_file SET pmniicd10 = 'Y'
             WHERE pmni01 = l_pmn.pmn68 AND pmni02 = l_pmn.pmn69
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               LET l_msg = 'UPDATE blanket PO :',l_pmn.pmn68,
                           '(',l_pmn.pmn69,')'
               CALL cl_err(l_msg,SQLCA.sqlcode,1)
               RETURN FALSE 
            END IF
         END IF 
      END IF
   END FOREACH
   RETURN TRUE
END FUNCTION
 
#------- 請採購預算控管 00/03/29 By Melody
FUNCTION t540sub_budchk(p_pmm01)
   DEFINE p_pmm01  LIKE pmm_file.pmm01
   DEFINE l_pmn    RECORD LIKE pmn_file.*
   DEFINE l_bud    LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE over_amt LIKE afc_file.afc06 #MOD-530190
   DEFINE last_amt LIKE afc_file.afc06 #MOD-530190
   DEFINE l_msg    LIKE ze_file.ze03  #No.FUN-680136 VARCHAR(30)
   DEFINE l_imaacti LIKE ima_file.imaacti
   DEFINE l_ima140  LIKE ima_file.ima140
   DEFINE l_ima1401 LIKE ima_file.ima1401  #FUN-6A0036
   DEFINE l_msg1    LIKE ze_file.ze03      #No.FUN-680136 VARCHAR(30)
   DEFINE l_bud1    LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE over_amt1 LIKE afc_file.afc06
   DEFINE last_amt1 LIKE afc_file.afc06
   DEFINE l_pmm RECORD LIKE pmm_file.*
   DEFINE p_sum1    LIKE afc_file.afc07
   DEFINE p_sum2    LIKE afc_file.afc07
   DEFINE l_flag    LIKE type_file.num5
   DEFINE l_over    LIKE afc_file.afc07
   DEFINE l_bookno1 LIKE aaa_file.aaa01
   DEFINE l_bookno2 LIKE aaa_file.aaa01
 
   SELECT * INTO l_pmm.* FROM pmm_file WHERE pmm01=p_pmm01  #MOD-7B0255
   DECLARE bud_cur CURSOR FOR
      SELECT * FROM pmn_file WHERE pmn01=p_pmm01
   FOREACH bud_cur INTO l_pmn.*
      ###### 01/10/29 Tommy 無效料件或Phase Out者不可以請購
      SELECT imaacti,ima140,ima1401 INTO l_imaacti,l_ima140,l_ima1401  #FUN-6A0036(add ima1401)
      FROM ima_file
       WHERE ima01 = l_pmn.pmn04
      IF SQLCA.sqlcode THEN LET l_imaacti = 'N' LET l_ima140 = 'Y' END IF
      IF l_imaacti = 'N' OR (l_ima140 = 'Y' AND l_ima1401 <= l_pmm.pmm04) THEN    #FUN-6A0036
         #CALL cl_err(l_pmn.pmn04,'apm-006',1) #MOD-530331    #CHI-CB0069 mark
         #CHI-CB0069 -- add start --
         CALL cl_get_feldname('pmn01',g_lang) RETURNING lc_gaq03
         LET l_msg = lc_gaq03,":",l_pmn.pmn01," "
         CALL cl_get_feldname('pmn02',g_lang) RETURNING lc_gaq03
         LET l_msg = l_msg,lc_gaq03,":",l_pmn.pmn02," "
         CALL cl_get_feldname('pmn04',g_lang) RETURNING lc_gaq03
         LET l_msg = l_msg,lc_gaq03,":",l_pmn.pmn04
         CALL cl_err(l_msg,'apm-006',1)
         #CHI-CB0069 -- add end --
         LET g_success = 'N'
       RETURN
      END IF
      IF g_aza.aza08 = 'N' THEN
         LET l_pmn.pmn122 = ' '
         LET l_pmn.pmn96= ' '
      END IF
      CALL s_get_bookno(l_pmm.pmm31) RETURNING l_flag,l_bookno1,l_bookno2
      LET p_sum1 = l_pmn.pmn87 * l_pmn.pmn44
      LET p_sum2 = l_pmn.pmn87 * l_pmn.pmn44
      IF cl_null(p_sum1) THEN LET p_sum1 = 0 END IF
      IF cl_null(p_sum2) THEN LET p_sum2 = 0 END IF
      IF g_aaz.aaz90 = 'Y' THEN
         CALL t540sub_bud(l_bookno1,l_pmn.pmn98,l_pmn.pmn40,
                       l_pmm.pmm31,l_pmn.pmn96,
                       l_pmn.pmn930,l_pmn.pmn122,
                      #l_pmm.pmm32,'0','a',0,p_sum2,'1')
                       l_pmm.pmm32,'0',' ',0,p_sum2,'1')   #MOD-B80057
      ELSE
         CALL t540sub_bud(l_bookno1,l_pmn.pmn98,l_pmn.pmn40,
                       l_pmm.pmm31,l_pmn.pmn96,
                       l_pmn.pmn67,l_pmn.pmn122,
                      #l_pmm.pmm32,'0','a',0,0,'1')       #MOD-950284 mark
                      #l_pmm.pmm32,'0','a',0,p_sum2,'1')   #MOD-950284
                       l_pmm.pmm32,'0',' ',0,p_sum2,'1')   #MOD-950284  #MOD-B80057
      END IF   #MOD-950284
      IF g_aza.aza63 = 'Y' THEN
         IF g_aaz.aaz90 = 'Y' THEN
            CALL t540sub_bud(l_bookno2,l_pmn.pmn98,l_pmn.pmn401,
                             l_pmm.pmm31,l_pmn.pmn96,
                             l_pmn.pmn930,l_pmn.pmn122,
                            #l_pmm.pmm32,'1','a',0,p_sum2,'1')
                             l_pmm.pmm32,'1',' ',0,p_sum2,'1')  #MOD-B80057
         ELSE
            CALL t540sub_bud(l_bookno2,l_pmn.pmn98,l_pmn.pmn401,
                             l_pmm.pmm31,l_pmn.pmn96,
                             l_pmn.pmn67,l_pmn.pmn122,
                            #l_pmm.pmm32,'1','a',0,0,'1')      #MOD-950284 mark
                            #l_pmm.pmm32,'1','a',0,p_sum2,'1')   #MOD-950284
                             l_pmm.pmm32,'1',' ',0,p_sum2,'1')   #MOD-950284   #MOD-B80057
         END IF   #MOD-950284
      END IF
      IF g_success = 'Y' THEN
         #同一筆單據中,有相同的預算資料
         #因為沒有確認..故耗用..會算不到其他單身中的金額,故此處卡總量
         SELECT SUM(pmn87*pmn44) INTO p_sum1 FROM pmn_file
          WHERE pmn01 = l_pmn.pmn01
            AND pmn98 = l_pmn.pmn98
            AND pmn40 = l_pmn.pmn40
            AND (pmn96 = l_pmn.pmn96 OR pmn96 IS NULL)
            AND pmn67 = l_pmn.pmn67
            AND (pmn122 = l_pmn.pmn122 OR pmn122 IS NULL)
         IF cl_null(p_sum1) THEN LET p_sum1 = 0 END IF
         IF g_aaz.aaz90 = 'Y' THEN
            CALL t540sub_bud(l_bookno1,l_pmn.pmn98,l_pmn.pmn40,
                             l_pmm.pmm31,l_pmn.pmn96,
                             l_pmn.pmn930,l_pmn.pmn122,
                            #l_pmm.pmm32,'0','a',0,p_sum1,'2')
                             l_pmm.pmm32,'0',' ',0,p_sum1,'2')   #MOD-B80057
         ELSE
            CALL t540sub_bud(l_bookno1,l_pmn.pmn98,l_pmn.pmn40,
                             l_pmm.pmm31,l_pmn.pmn96,
                             l_pmn.pmn67,l_pmn.pmn122,
                            #l_pmm.pmm32,'0','a',0,0,'2')       #MOD-950284 mark
                            #l_pmm.pmm32,'0','a',0,p_sum1,'2')   #MOD-950284
                             l_pmm.pmm32,'0',' ',0,p_sum1,'2')   #MOD-950284  #MOD-B80057
         END IF   #MOD-950284
 
         IF g_aza.aza63 = 'Y' THEN
            SELECT SUM(pmn87*pmn44) INTO p_sum1 FROM pmn_file
             WHERE pmn01 = l_pmn.pmn01
               AND pmn98 = l_pmn.pmn98
               AND pmn401= l_pmn.pmn401
               AND (pmn96 = l_pmn.pmn96 OR pmn96 IS NULL)
               AND pmn67 = l_pmn.pmn67
               AND (pmn122 = l_pmn.pmn122 OR pmn122 IS NULL)
            IF cl_null(p_sum1) THEN LET p_sum1 = 0 END IF
            IF g_aaz.aaz90 = 'Y' THEN
               CALL t540sub_bud(l_bookno2,l_pmn.pmn98,l_pmn.pmn401,
                                l_pmm.pmm31,l_pmn.pmn96,
                                l_pmn.pmn930,l_pmn.pmn122,
                               #l_pmm.pmm32,'1','a',0,p_sum1,'2')
                                l_pmm.pmm32,'1',' ',0,p_sum1,'2')  #MOD-B80057
            ELSE
               CALL t540sub_bud(l_bookno2,l_pmn.pmn98,l_pmn.pmn401,
                                l_pmm.pmm31,l_pmn.pmn96,
                                l_pmn.pmn67,l_pmn.pmn122,
                               #l_pmm.pmm32,'1','a',0,0,'2')    #MOD-950284   mark
                               #l_pmm.pmm32,'1','a',0,p_sum1,'2')   #MOD-950284
                                l_pmm.pmm32,'1',' ',0,p_sum1,'2')   #MOD-950284 #MOD-B80057
            END IF   #MOD-950284
         END IF
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION t540sub_upd_ecm(p_type,p_pmm01)
DEFINE p_type     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
DEFINE p_pmm01    LIKE pmm_file.pmm01
DEFINE l_pmn      RECORD LIKE pmn_file.*
DEFINE l_ecm54    LIKE ecm_file.ecm54,
       l_ecm321   LIKE ecm_file.ecm321,
       l_wip      LIKE ecm_file.ecm311,
       l_wip_1    LIKE ecm_file.ecm311,   # wip qty (工單不作check-in)
       l_wip_2    LIKE ecm_file.ecm311    # wip qty (要 check in)
DEFINE l_flag     LIKE type_file.num5    #No.FUN-A60011
 
     DECLARE t540sub_upd_ecm CURSOR FOR
      SELECT pmn_file.* FROM pmn_file,sfb_file #FUN-730012
       WHERE pmn01=p_pmm01
         AND pmn41 IS NOT NULL   #工單號碼
         AND pmn41=sfb01 AND sfb93='Y' AND sfb87!='X'
         AND pmn46 >0            #製程序
     FOREACH t540sub_upd_ecm INTO l_pmn.*
        IF p_type='-'   #取消確認時
           THEN
           UPDATE ecm_file SET ecm321=ecm321-l_pmn.pmn20       #委外加工量
             WHERE ecm01=l_pmn.pmn41   #工單單號
               AND ecm03=l_pmn.pmn46   #本製程序
               AND ecm012=l_pmn.pmn012   #No.FUN-A60011
        ELSE            #確認時
           SELECT ecm54,ecm321,
                  (ecm301+ecm302-(ecm311+ecm312)-ecm313-ecm314),
                  (ecm291-(ecm311+ecm312)-ecm313-ecm314)
             INTO l_ecm54,l_ecm321,l_wip_1,l_wip_2
             FROM ecm_file
            WHERE ecm01=l_pmn.pmn41
              AND ecm03=l_pmn.pmn46
              AND ecm012=l_pmn.pmn012   #No.FUN-A60011
           IF STATUS THEN
              CALL cl_err3("sel","ecm_file",l_pmn.pmn41,l_pmn.pmn46,STATUS,"","sel ecm",1)  #No.FUN-660129
              LET g_success='N' RETURN
           END IF
 
           IF l_ecm54 = 'N' THEN    #工單不作check-in
              LET l_wip = l_wip_1
           ELSE
              LET l_wip = l_wip_2
           END IF
 
           IF cl_null(l_wip) THEN LET l_wip = 0 END IF
 
           IF l_pmn.pmn20 >l_wip THEN
              #該筆採購確認後工單製程委外加工數量將大於WIP量
              CALL cl_err(l_pmn.pmn41,'apm-301',1)  #MOD-640492 0->1
              LET g_success='N'
              RETURN
           END IF
 
           UPDATE ecm_file SET ecm321=ecm321+l_pmn.pmn20       #委外加工量
             WHERE ecm01=l_pmn.pmn41   #工單單號
               AND ecm03=l_pmn.pmn46   #本製程序
               AND ecm012=l_pmn.pmn012   #No.FUN-A60011
        END IF
        IF STATUS OR SQLCA.SQLERRD[3]=0
           THEN
           CALL cl_err3("upd","ecm_file",l_pmn.pmn41,l_pmn.pmn46,STATUS,"","Update ecm_file:",1) #No.FUN-660129
           LET g_success='N'
        END IF
        #No.FUN-A60011  --Begin
        CALL s_update_ecm52(l_pmn.pmn41,l_pmn.pmn012,l_pmn.pmn46)
             RETURNING l_flag
        IF NOT l_flag THEN
           LET g_success = 'N'
           CALL cl_err3('upd','ecm_file',l_pmn.pmn41,l_pmn.pmn46,SQLCA.sqlcode,'','update ecm52',1)
        END IF
        #No.FUN-A60011  --End  
    END FOREACH
    IF STATUS THEN
       CALL cl_err('foreach pmn',STATUS,1)  #MOD-640492 0->1
       LET g_success='N'
       RETURN
    END IF
END FUNCTION
 
FUNCTION t540sub_upd_sgm(p_type,p_pmm01)
DEFINE p_type     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
DEFINE p_pmm01    LIKE pmm_file.pmm01
DEFINE l_pmn      RECORD LIKE pmn_file.*
DEFINE l_sgm54    LIKE sgm_file.sgm54,
       l_sgm321   LIKE sgm_file.sgm321,
       l_wip      LIKE sgm_file.sgm311,
       l_wip_1    LIKE sgm_file.sgm311,   # wip qty (工單不作check-in)
       l_wip_2    LIKE sgm_file.sgm311    # wip qty (要 check in)
DEFINE l_flag     LIKE type_file.num5     #FUN-A60095
 
   DECLARE t540sub_upd_sgm CURSOR FOR
    SELECT pmn_file.* FROM pmn_file,shm_file #FUN-730012
     WHERE pmn01=p_pmm01
       AND pmn18 IS NOT NULL   #runcard號碼
       AND pmn18=shm01 AND shm28!='Y'
       AND pmn32 >0            #製程序
   FOREACH t540sub_upd_sgm INTO l_pmn.*
      IF NOT cl_null(l_pmn.pmn18) THEN 
         SELECT sgm04 INTO l_ecm04  FROM sgm_file
          WHERE sgm01 = l_pmn.pmn18
            AND sgm02 = l_pmn.pmn41
            AND sgm03 = l_pmn.pmn43 
            AND sgm012 = l_pmn.pmn012 #No.FUN-A60076
      ELSE
      	 SELECT ecm04 INTO l_ecm04 
      	   FROM ecm_file
      	  WHERE ecm01 = l_pmn.pmn41
      	    AND ecm03 = l_pmn.pmn43 
            AND ecm012= l_pmn.pmn012  #No.FUN-A60011
      END IF 	  
      IF p_type='-'   #取消確認時
         THEN
         UPDATE sgm_file SET sgm321=sgm321-l_pmn.pmn20       #委外加工量
           WHERE sgm01=l_pmn.pmn18   #工單單號
             AND sgm03=l_pmn.pmn32   #本製程序
             AND sgm012 = l_pmn.pmn012  #FUN-A60076
      ELSE            #確認時
         SELECT sgm54,sgm321,
                (sgm301+sgm302+sgm303+sgm304-sgm311-sgm312-sgm313-sgm314-sgm316-sgm317),
                (sgm291-sgm311-sgm312-sgm313-sgm314-sgm316-sgm317)
           INTO l_sgm54,l_sgm321,l_wip_1,l_wip_2
           FROM sgm_file
          WHERE sgm01=l_pmn.pmn18
            AND sgm03=l_pmn.pmn32
            AND sgm012 = l_pmn.pmn012   #FUN-A60076	
         IF STATUS THEN
            CALL cl_err3("sel","sgm_file",l_pmn.pmn18,l_pmn.pmn32,STATUS,"","sel sgm",1)  #No.FUN-660129
            LET g_success='N' RETURN
         END IF
 
         IF l_sgm54 = 'N' THEN    #工單不作check-in
            LET l_wip = l_wip_1
         ELSE
            LET l_wip = l_wip_2
         END IF
 
         IF cl_null(l_wip) THEN LET l_wip = 0 END IF
 
         IF l_pmn.pmn20 >l_wip THEN
            #該筆採購確認後製程委外加工數量將大於WIP量
            CALL cl_err(l_pmn.pmn18,'apm-301',1)   #MOD-640484
            LET g_success='N'
            RETURN
         END IF
 
         UPDATE sgm_file SET sgm321=sgm321+l_pmn.pmn20       #委外加工量
           WHERE sgm01=l_pmn.pmn18   #runcard單號
             AND sgm03=l_pmn.pmn32   #本製程序
             AND sgm012 = l_pmn.pmn012   #FUN-A60076
      END IF
      IF STATUS OR SQLCA.SQLERRD[3]=0
         THEN
         CALL cl_err3("upd","sgm_file",l_pmn.pmn18,l_pmn.pmn32,STATUS,"","Update sgm_file:",1) #No.FUN-660129
         LET g_success='N'
      END IF
      #FUN-A60095--begin--add-------------------------
      CALL s_update_sgm52(l_pmn.pmn18,l_pmn.pmn012,l_pmn.pmn32)
           RETURNING l_flag
      IF NOT l_flag THEN
         LET g_success = 'N'
         CALL cl_err3('upd','sgm_file',l_pmn.pmn18,l_pmn.pmn32,SQLCA.sqlcode,'','update sgm52',1)
      END IF
      #FUN-A60095--end--add----------------------------
   END FOREACH
   IF STATUS THEN
      CALL cl_err('foreach pmn',STATUS,1)  #MOD-640484
      LET g_success='N'
      RETURN
   END IF
END FUNCTION
 
FUNCTION t540sub_refresh(p_pmm01)
   DEFINE p_pmm01 LIKE pmm_file.pmm01
   DEFINE l_pmm RECORD LIKE pmm_file.*
 
   SELECT * INTO l_pmm.* FROM pmm_file WHERE pmm01=p_pmm01
   RETURN l_pmm.*
END FUNCTION
 
#p_flag=TRUE =>開窗詢問是否執行  ;  p_flag=FALSE=>不詢問直接執行
FUNCTION t540sub_issue(p_pmm01,p_flag)
   DEFINE l_cmd       LIKE type_file.chr1000   #No.FUN-680136 VARCHAR(200)
   DEFINE l_pmm       RECORD LIKE pmm_file.*   #FUN-730012
   DEFINE p_flag      LIKE type_file.num5      #FUN-730012
   DEFINE p_pmm01     LIKE pmm_file.pmm01      #FUN-730012
   DEFINE l_argv3     LIKE pmm_file.pmm02      #FUN-730012
   DEFINE l_cnt       LIKE type_file.num5      #FUN-810038
   DEFINE l_pml20     LIKE pml_file.pml20      #No.FUN-A90009
   DEFINE l_pml21     LIKE pml_file.pml21      #No.FUN-A90009 
   DEFINE l_pmn24     LIKE pmn_file.pmn24      #No.FUN-A90009
   DEFINE l_pmn25     LIKE pmn_file.pmn25      #No.FUN-A90009    
   DEFINE l_success   LIKE type_file.chr1      #No.FUN-A90009  
   DEFINE l_msg       LIKE type_file.chr1000   #CHI-CB0069 add   

  IF cl_null(p_pmm01) THEN CALL cl_err('','-400',1) RETURN END IF  #MOD-640492 0->1
  SELECT * INTO l_pmm.* FROM pmm_file WHERE pmm01=p_pmm01 #FUN-730012
 
 #IF l_pmm.pmm18 = 'N' THEN CALL cl_err('pmm18=N','aap-717',1) RETURN END IF  #MOD-640492 0->1                                      #CHI-CB0069 mark
  #CHI-CB0069 -- add start --
  IF l_pmm.pmm18 = 'N' THEN
     CALL cl_get_feldname('pmn01',g_lang) RETURNING lc_gaq03
     LET l_msg = lc_gaq03,":",l_pmm.pmm01," "
     CALL cl_get_feldname('pmm18',g_lang) RETURNING lc_gaq03
     LET l_msg = l_msg,lc_gaq03," = 'N'"
     CALL cl_err(l_msg,'aap-717',1)
     RETURN
  END IF
  #CHI-CB0069 -- add end --
 #IF l_pmm.pmm25 != '1' THEN CALL cl_err('pmm25 != 1','apm-299',1) RETURN END IF  #No.MOD-540007   #MOD-640492 0->1   #MOD-870002   #CHI-CB0069 mark
  #CHI-CB0069 -- add start --
  IF l_pmm.pmm25 != '1' THEN
     CALL cl_get_feldname('pmn01',g_lang) RETURNING lc_gaq03
     LET l_msg = lc_gaq03,":",l_pmm.pmm01," "
     CALL cl_get_feldname('pmm25',g_lang) RETURNING lc_gaq03
     LET l_msg = l_msg,lc_gaq03," != 1"
     CALL cl_err(l_msg,'apm-299',1)
     RETURN
  END IF
  #CHI-CB0069 -- add end --
 
  IF (s_industry('icd')) AND (l_pmm.pmm02 = 'SUB') THEN
     #工單未確認，委外採購單不可發出
     LET l_cnt = 0
     SELECT count(*) INTO  l_cnt
       FROM sfb_file
      WHERE sfb01 = p_pmm01
        AND sfb87 = 'Y'
 
       IF l_cnt = 0 AND l_pmm.pmm02 = 'SUB' THEN
         #CALL cl_err('','aic-025',1)              #CHI-CB0069 mark
          CALL cl_err(l_pmm.pmm01,'aic-025',1)     #CHI-CB0069 add
          RETURN
       END IF
       LET l_cnt = 0
 
     #若生產料號之作業群組=3.DST,生產數量必須有值及>0
     LET l_cnt = 0
     SELECT COUNT(*) INTO l_cnt
       FROM pmn_file,pmni_file,sfb_file,ecd_file
      WHERE pmn01 = p_pmm01
        AND pmni01= pmn01
        AND pmni02= pmn02
        AND sfb01 = pmn41
        AND sfb08 = 0
        AND ecd01 = pmniicd03
        AND ecdicd01='3'
     IF l_cnt>0 THEN
       #CALL cl_err('','aic-075',1)               #CHI-CB0069 mark
        CALL cl_err(l_pmm.pmm01,'aic-075',1)      #CHI-CB0069 add
        RETURN
     END IF
    ##委外工單發出時需卡領料單是否已扣帳
  END IF
 
  #NO.3453 01/09/07 By Carol:委外採購單供應商未輸入不可發出.........
  IF cl_null(l_pmm.pmm09) THEN
    #CALL cl_err('','apm-197',1) RETURN END IF            #CHI-CB0069 mark
     CALL cl_err(l_pmm.pmm01,'apm-197',1) RETURN END IF   #CHI-CB0069 add
 
  IF p_flag THEN
     IF NOT cl_confirm('mfg2747') THEN
        RETURN
     END IF
  END IF
  #No.FUN-A90009--begin 
  LET l_success='Y' 
  DECLARE t540sub_pmn24 CURSOR FOR SELECT pmn24,pmn25 FROM pmn_file WHERE pmn01=p_pmm01
  FOREACH t540sub_pmn24 INTO l_pmn24,l_pmn25
     SELECT pml20,pml21 INTO l_pml20,l_pml21 FROM pml_file WHERE pml01=l_pmn24 
     AND pml02=l_pmn25 
     IF l_pml21<l_pml20 THEN 
        UPDATE pml_file SET pml92='N',pml93=' ' 
         WHERE pml01=l_pmn24 
           AND pml02=l_pmn25 
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
           CALL cl_err3("upd","pml_file","","",SQLCA.sqlcode,"","",1)   
           LET l_success='N'         
           #ROLLBACK WORK
           #RETURN
           EXIT FOREACH 
        END IF
     END IF 
  END FOREACH 
  IF l_success='N' THEN 
     ROLLBACK WORK
  ELSE 
  	 COMMIT WORK 
  END IF 
  #No.FUN-A90009--end  
  DISPLAY " confirm in"
  DISPLAY " l_argv3=,",l_argv3
  LET l_argv3=l_pmm.pmm02   #MOD-7B0239
  IF l_argv3='SUB' THEN
     LET l_cmd = "apmp610 '",l_pmm.pmm01,"' "
  ELSE
     LET l_cmd = "apmp554 '",l_pmm.pmm01 CLIPPED,"' ",
                         "'",l_pmm.pmm04 CLIPPED,"' ",
                         "'",l_pmm.pmm09 CLIPPED,"' "
  END IF
  DISPLAY "l_cmd=,",l_cmd
  CALL cl_cmdrun_wait(l_cmd CLIPPED)
  DISPLAY "STATUS=",STATUS
 
  CALL t540sub_mail(l_pmm.*)  #FUN-6A0023
 
  SELECT pmm25 INTO l_pmm.pmm25 FROM pmm_file WHERE pmm01 = l_pmm.pmm01
  ###### 01/11/06 Tommy 採購發出後拋轉流程單據
  IF l_pmm.pmm25 = '2' AND l_pmm.pmm906 = 'Y'
     AND g_pod.pod05 = 'Y' THEN         #FUN-670007
     LET l_cmd = "apmp801 '",l_pmm.pmm01,"'"
     CALL cl_cmdrun_wait(l_cmd)
  END IF
END FUNCTION
 
FUNCTION  t540sub_mail(l_pmm)
  DEFINE l_cmd          LIKE type_file.chr1000
  DEFINE l_pmc912       LIKE   pmc_file.pmc912  #是否mail
  DEFINE l_pmd02        LIKE   pmd_file.pmd02
  DEFINE l_pmd07        LIKE   pmd_file.pmd07
  DEFINE l_zo02         LIKE   zo_file.zo02
  DEFINE l_subject      STRING   #主旨
  DEFINE l_body         STRING   #內文路徑
  DEFINE l_recipient    STRING   #收件者
  DEFINE l_cnt          LIKE   type_file.num5    #SMALLINT
  DEFINE l_wc           STRING
  DEFINE l_sql          STRING
  DEFINE ls_context        STRING
  DEFINE ls_temp_path      STRING
  DEFINE ls_context_file   STRING
  DEFINE l_pmm          RECORD LIKE pmm_file.*
  DEFINE i              LIKE type_file.num5      #FUN-870158  
 
  #廠商基本資料中如勾選要發mail給廠商，則依連絡人發mail
  SELECT pmc912 INTO l_pmc912
    FROM pmc_file
   WHERE pmc01 = l_pmm.pmm09
  IF SQLCA.sqlcode THEN
     CALL cl_err3("sel","pmc_file",l_pmm.pmm09,"",SQLCA.sqlcode,"","",0)
  ELSE
    IF l_pmc912 = 'Y' THEN #要發mail
      SELECT COUNT(*) INTO l_cnt FROM pmd_file
       WHERE pmd01 = l_pmm.pmm09  AND  pmd07 IS NOT NULL
         AND pmd08 = 'Y'                        #FUN-940071
      IF l_cnt >0 THEN
       #主旨
        SELECT zo02 INTO l_zo02  FROM zo_file  WHERE zo01 = g_lang
        LET l_subject = cl_getmsg("apm-795",g_lang) CLIPPED,l_zo02 CLIPPED,
                        cl_getmsg("apm-796",g_lang) CLIPPED,l_pmm.pmm01
        LET g_xml.subject = l_subject
 
       #內文
        LET ls_context = cl_getmsg("apm-799",g_lang) CLIPPED
        LET ls_temp_path = FGL_GETENV("TEMPDIR")
        LET ls_context_file = ls_temp_path,"/report_context_" || FGL_GETPID() || ".txt"
        LET l_cmd = "echo '" || ls_context || "' > " || ls_context_file
        RUN l_cmd WITHOUT WAITING
        LET g_xml.body = ls_context_file
 
       #收件者
         LET l_recipient = ''
         DECLARE t540sub_pmd_c CURSOR FOR
                 SELECT pmd02,pmd07 FROM pmd_file
                   WHERE pmd01 = l_pmm.pmm09
                     AND pmd07 IS NOT NULL
                     AND pmd08 = 'Y'                         #No.FUN-940071
                   ORDER BY pmd02
         LET i = 0                                           #FUN-870158                   
         FOREACH t540sub_pmd_c INTO l_pmd02,l_pmd07
           LET i = i + 1
           IF i = 1 THEN
              LET l_recipient = l_recipient CLIPPED,l_pmd07 CLIPPED,":",l_pmd02 CLIPPED ,":","1" CLIPPED
           ELSE
              LET l_recipient = l_recipient CLIPPED ,";",l_pmd07 CLIPPED,":",l_pmd02 CLIPPED ,":","1" CLIPPED
           END IF
         END FOREACH
         LET g_xml.recipient = l_recipient
 
         LET l_wc = "pmm01='",l_pmm.pmm01 CLIPPED,"'",
                    " AND pmm04='",l_pmm.pmm04 CLIPPED,"'",
                    " AND pmm12='",l_pmm.pmm12 CLIPPED,"'"
         LET l_wc = cl_replace_str(l_wc,"'","\"")
         CALL FGL_SETENV("MAIL_TO",l_recipient)               #FUN-870158
        # LET l_cmd = "apmr900 '", #FUN-C30085 mark
         LET l_cmd = "apmg900 '", #FUN-C30085 add
                      g_today,"' '",g_user CLIPPED,"' '",
                      g_lang,"' 'Y' 'A' '1' '",l_wc CLIPPED,
                      "' 'N' 'Y' '0' 'default' 'default' 'default' '",
                     #  g_xml.subject,"' '",g_xml.body,"' '",g_xml.recipient,"' 'apmr900_0_std' ''"    #FUN-870158  #FUN-C30085 mark 
                      g_xml.subject,"' '",g_xml.body,"' '",g_xml.recipient,"' 'apmg900' ''"  #FUN-C30085 add
         CALL cl_cmdrun(l_cmd)
      END IF
    END IF
  END IF
END FUNCTION
 
FUNCTION t540_chk_date(l_pmm01,l_pmm04)
DEFINE   l_pmn33  LIKE pmn_file.pmn33
DEFINE   l_pmn02  LIKE pmn_file.pmn02
DEFINE   l_pmm04  LIKE pmm_file.pmm04
DEFINE   l_pmm01  LIKE pmm_file.pmm01
DEFINE   l_msg    LIKE type_file.chr1000
 
     DECLARE t540_cs CURSOR FOR
         SELECT pmn02,pmn33 FROM pmn_file WHERE pmn01=l_pmm01
 
     FOREACH t540_cs INTO l_pmn02,l_pmn33
         IF l_pmn33 < l_pmm04 THEN
           #LET l_msg = l_pmm01,'-',l_pmn02   #CHI-CB0069 mark
            #CHI-CB0069 -- add start --
            CALL cl_get_feldname('pmm01',g_lang) RETURNING lc_gaq03
            LET l_msg = lc_gaq03,":",l_pmm01," "
            CALL cl_get_feldname('pmn02',g_lang) RETURNING lc_gaq03
            LET l_msg = l_msg,lc_gaq03,":",l_pmn02
            #CHI-CB0069 -- add end --
            CALL cl_err(l_msg,'apm-029',1)
            LET g_success='N'
            EXIT FOREACH
         END IF
     END FOREACH
 
END FUNCTION
 
FUNCTION t540_ind_icd_chk_pre_po_qty(p_pmm02,p_pmn20,p_pmn68,p_pmn69,p_pmn70)
   DEFINE p_pmm02     LIKE pmm_file.pmm02
   DEFINE p_pmn20     LIKE pmn_file.pmn20
   DEFINE p_pmn68     LIKE pmn_file.pmn68
   DEFINE p_pmn69     LIKE pmn_file.pmn69
   DEFINE p_pmn70     LIKE pmn_file.pmn70
   DEFINE l_pmniicd13 LIKE pmni_file.pmniicd13
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_blk_pmn20 LIKE pmn_file.pmn20    #CHI-920026
 
   IF (p_pmn20=0) OR cl_null(p_pmn20) OR
      cl_null(p_pmn68) OR cl_null(p_pmn69) OR cl_null(p_pmn70) THEN
     RETURN TRUE
   END IF
 
   #輸入之數量不可大於Blanket P/O 或採購單 之
   IF p_pmm02 = 'WB2' THEN  #其餘不檢查
      #申請數量-已轉數量(pmn20-pmniicd13(已轉WAFER START採購單數量))
      LET l_pmniicd13=0
      SELECT pmniicd13 INTO l_pmniicd13
        FROM pmni_file
       WHERE pmni01 = p_pmn68
         AND pmni02 = p_pmn69
      SELECT pmn20 INTO l_blk_pmn20 FROM pmn_file
       WHERE pmn01 = p_pmn68
         AND pmn02 = p_pmn69
      IF cl_null(l_blk_pmn20) THEN LET l_blk_pmn20 = 0 END IF
      IF p_pmn20 * p_pmn70 >
         l_blk_pmn20 - l_pmniicd13 THEN    #CHI-920026 p_pmn20-->l_blk_pmn20
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
#取得作業編號之作業群組
FUNCTION t540_ind_icd_ecdicd01(p_pmniicd03)
   DEFINE p_pmniicd03 LIKE pmni_file.pmniicd03
   DEFINE l_ecdicd01 LIKE ecd_file.ecdicd01
 
   LET l_ecdicd01=NULL
   SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file WHERE ecd01 = p_pmniicd03
   RETURN l_ecdicd01
END FUNCTION
 
#取價格
FUNCTION t540_ind_icd_new_price(p_pmm01,p_pmm43,p_pmn04,p_pmn20,p_pmniicd03,p_pmn86)
   DEFINE p_pmn04     LIKE pmn_file.pmn04,        #料號
          p_pmn20     LIKE pmn_file.pmn20,        #數量
          p_pmniicd03 LIKE pmni_file.pmniicd03,   #ICD作業編號
          l_imaicd01  LIKE imaicd_file.imaicd01,  #母體料號
          l_imaicd10  LIKE imaicd_file.imaicd10,  #作業群組
          l_ecdicd01  LIKE ecd_file.ecdicd01,     #作業群組
          l_pmn31     LIKE pmn_file.pmn31,        #未稅單價
          l_pmn31t    LIKE pmn_file.pmn31t,       #含稅單價
          l_pmn73     LIKE pmn_file.pmn73,        #取價類型   #TQC-AC0257 add
          l_pmn74     LIKE pmn_file.pmn74         #價格來源   #TQC-AC0257 add
   DEFINE l_pmm       RECORD LIKE pmm_file.*
   DEFINE l_type      LIKE type_file.chr1
   DEFINE l_ima908    LIKE ima_file.ima908
   DEFINE p_pmm01     LIKE pmm_file.pmm01
   DEFINE p_pmm43     LIKE pmm_file.pmm43
   DEFINE p_pmn86     LIKE pmn_file.pmn86
 
   #      母體料號 , 作業群組
   IF g_sma.sma841 = '8' THEN  #依BODY取價 #FUN-980033
      SELECT imaicd01,imaicd10 INTO l_imaicd01,l_imaicd10
        FROM imaicd_file
        WHERE imaicd00 = p_pmn04
   ELSE                                     #FUN-980033  
       LET l_imaicd01 = p_pmn04             #FUN-980033
   END IF                                   #FUN-980033
   SELECT ima908 INTO l_ima908 FROM ima_file
                              WHERE ima01=l_imaicd01
   LET l_pmn31 = 0   LET l_pmn31t = 0
 
   #取得作業群組(ecdicd01)
   CALL t540_ind_icd_ecdicd01(p_pmniicd03) RETURNING l_ecdicd01
   SELECT * INTO l_pmm.* FROM pmm_file
                        WHERE pmm01=p_pmm01
   IF l_pmm.pmm02='SUB' THEN
      LET l_type='2'
   ELSE
      LET l_type='1'
   END IF
 
   CASE
       WHEN l_ecdicd01 = '2' OR l_ecdicd01 = '3'
            CALL s_defprice_new(l_imaicd01,l_pmm.pmm09,l_pmm.pmm22,l_pmm.pmm04,
                            p_pmn20,p_pmniicd03,l_pmm.pmm21,p_pmm43,l_type,
                            l_ima908,'',l_pmm.pmm41,l_pmm.pmm20,g_plant)
                 RETURNING l_pmn31,l_pmn31t,l_pmn73,l_pmn74   #TQC-AC0257 add l_pmn73,l_pmn74
       WHEN l_ecdicd01 = '4' OR l_ecdicd01 = '5'
            CALL s_defprice_new(p_pmn04,l_pmm.pmm09,l_pmm.pmm22,l_pmm.pmm04,
                           p_pmn20,p_pmniicd03,l_pmm.pmm21,p_pmm43,l_type,
                           p_pmn86,'',l_pmm.pmm41,l_pmm.pmm20,g_plant)
                RETURNING l_pmn31,l_pmn31t,l_pmn73,l_pmn74   #TQC-AC0257 add l_pmn73,l_pmn74
       WHEN l_ecdicd01 = '6'
            LET l_pmn31  = 0
            LET l_pmn31t = 0
   END CASE
   RETURN l_pmn31,l_pmn31t
END FUNCTION
 
FUNCTION t540_ind_icd_chk_pmn68(p_pmm02,p_pmn04,p_pmn68)
   DEFINE p_pmm02    LIKE pmm_file.pmm02
   DEFINE p_pmn04    LIKE pmn_file.pmn04
   DEFINE p_pmn68    LIKE pmn_file.pmn68
   DEFINE li_result  LIKE type_file.num5
   DEFINE l_pmm02    LIKE pmm_file.pmm02
   DEFINE l_pmm25    LIKE pmm_file.pmm25
   DEFINE l_pmmacti  LIKE pmm_file.pmmacti
 
   LET li_result=TRUE
   IF p_pmm02='WB3' THEN #Bank PO不可有Bank PO
      CALL cl_err('','aic-081',1)
      RETURN FALSE
   END IF
   IF cl_null(p_pmn04) THEN
      CALL cl_err('','aic-085',1)
      RETURN FALSE
   END IF
   SELECT pmm02,pmm25,pmmacti
     INTO l_pmm02,l_pmm25,l_pmmacti
     FROM pmm_file
    WHERE pmm01=p_pmn68
   CASE
      WHEN SQLCA.sqlcode<>0
         CALL cl_err3("sel","pmm_file",p_pmn68,"",SQLCA.sqlcode,"","",1)
         LET li_result=FALSE
      WHEN l_pmmacti<>'Y'
         CALL cl_err('','apm-800',1)
         LET li_result=FALSE
      WHEN p_pmm02='WB1' AND l_pmm02<>'WB3' #Wafer Star的Bank PO只能為 WB3
         CALL cl_err('','aic-079',1)
         LET li_result=FALSE
      WHEN NOT (l_pmm02='WB1' OR l_pmm02='WB3') #WB1/WB3 以外的PO的Bank PO可為 WB1或WB3
         CALL cl_err('','aic-080',1)
         LET li_result=FALSE
      OTHERWISE
         LET li_result=TRUE
   END CASE
   RETURN li_result
END FUNCTION
 
FUNCTION t540_ind_icd_chk_pmn69(p_pmm02,p_pmn04,p_pmn68,p_pmn69)
   DEFINE p_pmn04    LIKE pmn_file.pmn04
   DEFINE l_pmn04    LIKE pmn_file.pmn04
   DEFINE p_pmm02    LIKE pmm_file.pmm02
   DEFINE p_pmn68    LIKE pmn_file.pmn68
   DEFINE p_pmn69    LIKE pmn_file.pmn69
   DEFINE li_result  LIKE type_file.num5
   DEFINE l_imaicd01a LIKE imaicd_file.imaicd01
   DEFINE l_imaicd01b LIKE imaicd_file.imaicd01
 
   IF cl_null(p_pmn04) THEN
      CALL cl_err('','aic-085',1)
      RETURN FALSE
   END IF
   IF cl_null(p_pmn68) THEN
      CALL cl_err('','aic-086',1)
      RETURN FALSE
   END IF
 
   LET li_result=t540_ind_icd_chk_pmn68(p_pmm02,p_pmn04,p_pmn68)
   IF NOT li_result THEN
      RETURN FALSE
   END IF
 
   LET li_result=TRUE
   SELECT pmn04 INTO l_pmn04
     FROM pmm_file,pmn_file
    WHERE pmm01=pmn01
      AND pmm01=p_pmn68
      AND pmn02=p_pmn69
      AND pmm25='2'
      AND pmmacti='Y'
   CASE
      WHEN SQLCA.sqlcode<>0
         CALL cl_err3("sel","pmn_file",p_pmn68,p_pmn69,100,"","",1)
         LET li_result=FALSE
      OTHERWISE
         #母體料號相同才能沖消
         SELECT imaicd01 INTO l_imaicd01a  #CHI-920024
           FROM imaicd_file
          WHERE imaicd00=p_pmn04
         SELECT imaicd01 INTO l_imaicd01b  #CHI-920024
           FROM imaicd_file
          WHERE imaicd00=l_pmn04
         IF l_imaicd01a<>l_imaicd01b THEN
            CALL cl_err('','aic-087',1)
            LET li_result=FALSE
         END IF
   END CASE
   RETURN li_result
END FUNCTION
 
FUNCTION t540_ind_icd_ins_ico(p_pmm02,p_pmn01,p_pmn02)
   DEFINE p_pmm02 LIKE pmm_file.pmm02
   DEFINE p_pmn01 LIKE pmn_file.pmn01,
          p_pmn02 LIKE pmn_file.pmn02
   DEFINE l_ico RECORD LIKE ico_file.*,
          l_icl RECORD LIKE icl_file.*
   DEFINE l_oeb01 LIKE oeb_file.oeb01
   DEFINE l_oeb03 LIKE oeb_file.oeb03
 
   IF NOT (p_pmm02='WB0' OR
           p_pmm02='WB1' OR
           p_pmm02='WB2') THEN
      RETURN
   END IF
 
   CALL s_get_so(p_pmn01,p_pmn02) RETURNING l_oeb01,l_oeb03
   IF cl_null(l_oeb01) THEN
      DECLARE icl_cs CURSOR FOR
       SELECT * FROM icl_file WHERE icl01  = g_pmn2.pmn04
      FOREACH icl_cs INTO l_icl.*
         LET l_ico.ico01  = p_pmn01
         LET l_ico.ico02  = p_pmn02
         LET l_ico.ico03  = l_icl.icl02
         LET l_ico.ico04  = l_icl.icl03
         LET l_ico.ico05  = l_icl.icl04
         LET l_ico.ico06  = l_icl.icl05
         LET l_ico.icouser = g_user
         LET l_ico.icogrup = g_grup
         LET l_ico.icomodu = ''
         LET l_ico.icodate = g_today
         LET l_ico.icoacti = 'Y'
         LET l_ico.icooriu = g_user      #No.FUN-980030 10/01/04
         LET l_ico.icoorig = g_grup      #No.FUN-980030 10/01/04
         INSERT INTO ico_file VALUES(l_ico.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err('ins ico_file:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
      END FOREACH
   ELSE
      DECLARE ico_cs CURSOR FOR
       SELECT * FROM ico_file WHERE ico01  = l_oeb01
                                AND ico02  = l_oeb03
      FOREACH ico_cs INTO l_ico.*
         LET l_ico.ico01  = p_pmn01
         LET l_ico.ico02  = p_pmn02
         LET l_ico.icouser = g_user
         LET l_ico.icogrup = g_grup
         LET l_ico.icomodu = ''
         LET l_ico.icodate = g_today
         LET l_ico.icoacti = 'Y'
         INSERT INTO ico_file VALUES(l_ico.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err('ins ico_file:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
      END FOREACH
   END IF
END FUNCTION
 
FUNCTION t540_ind_icd_del_ico(p_pmn01,p_pmn02)
   DEFINE l_cnt LIKE type_file.num5
   DEFINE p_pmn01 LIKE pmn_file.pmn01,
          p_pmn02 LIKE pmn_file.pmn02
 
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM ico_file
    WHERE ico01 = p_pmm01
      AND ico02 = p_pmn02
   IF l_cnt > 0 THEN
      DELETE FROM ico_file WHERE ico01 = p_pmm01
                             AND ico02 = p_pmm02
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         LET g_success = 'N'
         CALL cl_err("del ico_file:",SQLCA.sqlcode,1)
      END IF
   END IF
END FUNCTION
 
#塞wafer/ic資料
#由工單產生 pmni_file 的資料
FUNCTION t540_ind_icd_set_wo_value(p_pmn04,p_pmn41)
   DEFINE p_pmn04 LIKE pmn_file.pmn04
   DEFINE p_pmn41 LIKE pmn_file.pmn41
   DEFINE l_oeb01 LIKE oeb_file.oeb01
   DEFINE l_oeb03 LIKE oeb_file.oeb03
   DEFINE l_sfbi  RECORD LIKE sfbi_file.*
   DEFINE l_pmni  RECORD LIKE pmni_file.*
   DEFINE l_cnt   LIKE type_file.num5
 
   #New Code:pmn04 若存在於 icw13 或 icx03 則為 'Y' , 否則為'N'
 
   INITIALIZE l_pmni.* TO NULL
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM icw_file WHERE icw13=p_pmn04
   IF l_cnt=0 THEN
      SELECT COUNT(*) INTO l_cnt
        FROM icx_file WHERE icx03=p_pmn04
   END IF
   IF l_cnt>0 THEN
      LET l_pmni.pmniicd04='Y'
   ELSE
      LET l_pmni.pmniicd04='N'
   END IF
 
   SELECT sfb22,sfb221
     INTO l_oeb01,l_oeb03
     FROM sfb_file
    WHERE sfb01=p_pmn41
 
   SELECT oebiicd05,oeb04
     INTO l_pmni.pmniicd08,               #Multi die
          l_pmni.pmniicd15                #最終料號
     FROM oeb_file
    WHERE oeb01 = l_oeb01
      AND oeb03 = l_oeb03
 
   SELECT * INTO l_sfbi.*
     FROM sfbi_file
    WHERE sfbi01=p_pmn41
 
   LET l_pmni.pmniicd14 = l_sfbi.sfbiicd14  #母體料號
   LET l_pmni.pmniicd09 = l_sfbi.sfbiicd05  #參考數量
   LET l_pmni.pmniicd03 = l_sfbi.sfbiicd09  #作業編號
   LET l_pmni.pmniicd11 = l_sfbi.sfbiicd07  #Date Code
 
   DECLARE sfai03_cs CURSOR FOR              #母批
   #SELECT sfai03 FROM sfa_file WHERE sfa01 = p_pmn41  #No.FUN-A60011
    SELECT sfa03  FROM sfa_file WHERE sfa01 = p_pmn41  #No.FUN-A60011
   OPEN sfai03_cs
   FETCH sfai03_cs INTO l_pmni.pmniicd16
   CLOSE sfai03_cs
 
   LET l_pmni.pmniicd12 = l_sfbi.sfbiicd03   #WAFER SITE
   LET l_pmni.pmniicd17 = l_sfbi.sfbiicd02   #Wafer廠商
   RETURN l_pmni.*
END FUNCTION
 
FUNCTION t540_ind_icd_chk_pmn04(p_pmm02,p_pmn04)
   DEFINE p_pmm02 LIKE pmm_file.pmm02
   DEFINE p_pmn04 LIKE pmn_file.pmn04
   DEFINE l_cnt   LIKE type_file.num5
 
   IF NOT (p_pmm02='WB0' OR
           p_pmm02='WB1' OR
           p_pmm02='WB2') THEN
      RETURN
   END IF
   IF cl_null(g_errno) THEN
      # 1.料號需不可為icb06 ='2'
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM icb_file
       WHERE icb01  = p_pmn04 AND icb06  = '2'
      IF l_cnt > 0  THEN
         LET g_errno = 'aic-095'
      END IF
   END IF
END FUNCTION
 
#確認時檢查單價,供應商
FUNCTION t540_ind_icd_sub_upd(p_pmm01,p_pmm02,p_pmm09,p_pmm43)
   DEFINE l_pmn     RECORD LIKE pmn_file.*,
          l_sfb82   LIKE sfb_file.sfb82,
          p_pmm01   LIKE pmm_file.pmm01,
          p_pmm02   LIKE pmm_file.pmm02,
          p_pmm09   LIKE pmm_file.pmm09,
          p_pmm43   LIKE pmm_file.pmm43,
          l_pmniicd03 LIKE pmni_file.pmniicd03,
          l_pnz08   LIKE pnz_file.pnz08   #FUN-C50116
 
   IF p_pmm02 <> 'SUB' THEN
      RETURN
   END IF
 
   DECLARE sub_upd_cs CURSOR FOR
    SELECT pmn_file.*,pmniicd03
      FROM pmn_file,pmni_file
     WHERE pmn01=p_pmm01
       AND pmn01=pmni01
       AND pmn02=pmni02
       AND pmn65 = '1'  #一般採購
 
   FOREACH sub_upd_cs INTO l_pmn.*,l_pmniicd03
      IF SQLCA.sqlcode THEN
         CALL cl_err('sub_upd_cs:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
      IF cl_null(l_pmn.pmn41) THEN    #委外必須有工單NO
         CALL cl_err('','asf-967',1)
         LET g_success = 'N'
         RETURN
      END IF
 
      #檢查供應商和工單的供應商相同否,不同要重新取價,並回寫update工單上的廠商
      SELECT sfb82 INTO l_sfb82 FROM sfb_file WHERE sfb01 = l_pmn.pmn41
      IF SQLCA.sqlcode THEN
         CALL cl_err('select supplier from W/O',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
      #供應商和工單的供應商不相同
      IF cl_null(l_sfb82) OR l_sfb82 <> p_pmm09 THEN
         #1. 重新取價
         CALL t540_ind_icd_new_price(p_pmm01,p_pmm43,l_pmn.pmn04,l_pmn.pmn20,l_pmniicd03,l_pmn.pmn86)
              RETURNING l_pmn.pmn31,l_pmn.pmn31t
         IF g_success = 'N' THEN RETURN END IF
         UPDATE pmn_file SET pmn31 = l_pmn.pmn31,pmn31t = l_pmn.pmn31t
          WHERE pmn01 = l_pmn.pmn01 AND pmn02 = l_pmn.pmn02
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err('update price OF P/O',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
 
         #2. 回寫update工單上的廠商
         UPDATE sfb_file SET sfb82 = p_pmm09 WHERE sfb01 = l_pmn.pmn41
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err('update supplier of W/O',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
         #FUN-C50116---begin
         SELECT pnz08 INTO l_pnz08
           FROM pnz_file,pmc_file
          WHERE pnz01 = pmc49
            AND pmc01 = p_pmm09
      ELSE
         SELECT pnz08 INTO l_pnz08
           FROM pnz_file,pmm_file
          WHERE pnz01 = pmm41
            AND pmm01 = p_pmm01
         #FUN-C50116---end
      END IF
      #FUN-C50116---begin
      IF cl_null(l_pnz08) THEN LET l_pnz08 = 'Y' END IF 
      IF l_pnz08 = 'N' THEN 
      #FUN-C50116---end
         #檢查單價,除了料號之作業群組為6.TKY外,其它不可為0
         IF l_pmn.pmn31 = 0 OR l_pmn.pmn31t = 0 THEN
            IF t540_ind_icd_ecdicd01(l_pmniicd03) <> '6' THEN
               CALL cl_err(l_pmn.pmn04,'aic-097',1)
               LET g_success = 'N'
               RETURN
            END IF
         END IF
      END IF  #FUN-C50116
   END FOREACH
END FUNCTION
 
FUNCTION t540sub_bud(p_afc00,p_afc01,p_afc02,p_afc03,p_afc04,p_afc041,
                     p_afc042,p_afc05,p_flag,p_cmd,p_sum1,p_sum2,p_flag1)
  DEFINE p_afc00     LIKE afc_file.afc00  #帳套編號
  DEFINE p_afc01     LIKE afc_file.afc01  #費用原因
  DEFINE p_afc02     LIKE afc_file.afc02  #會計科目
  DEFINE p_afc03     LIKE afc_file.afc03  #會計年度
  DEFINE p_afc04     LIKE afc_file.afc04  #WBS
  DEFINE p_afc041    LIKE afc_file.afc041 #部門編號
  DEFINE p_afc042    LIKE afc_file.afc042 #項目編號
  DEFINE p_afc05     LIKE afc_file.afc05  #期別
  DEFINE p_flag      LIKE type_file.chr1  #0.第一科目 1.第二科目
  DEFINE p_flag1     LIKE type_file.chr1  #1.單筆檢查 2.單身total檢查
  DEFINE p_cmd       LIKE type_file.chr1
  DEFINE p_sum1      LIKE afc_file.afc06 
  DEFINE p_sum2      LIKE afc_file.afc06 
  DEFINE l_flag      LIKE type_file.num5
  DEFINE l_afb07     LIKE afb_file.afb07
  DEFINE l_over      LIKE afc_file.afc07
  DEFINE l_msg       LIKE ze_file.ze03      #FUN-890128
  DEFINE l_aag23     LIKE aag_file.aag23  #CHI-A40021 add
  DEFINE l_afc04     LIKE afc_file.afc04  #CHI-A40021 add
  DEFINE l_afc042    LIKE afc_file.afc042 #CHI-A40021 add

  #CHI-A40021 add --start--
  SELECT aag23 INTO l_aag23 FROM  aag_file
   WHERE aag00=p_afc00
     AND aag01=p_afc02
  IF l_aag23='Y' THEN
     LET l_afc04 = p_afc04
     LET l_afc042 = p_afc042
  ELSE
     LET l_afc04 = ' '
     LET l_afc042 = ' '
  END IF
  #CHI-A40021 add --end--

      CALL s_budchk1(p_afc00,p_afc01,p_afc02,p_afc03,l_afc04,  #CHI-A40021 mod p_afc04->l_afc04        
                     p_afc041,l_afc042,p_afc05,p_flag,p_cmd,p_sum1,p_sum2)  #CHI-A40021 mod p_afc042->l_afc042
          RETURNING l_flag,l_afb07,l_over
      IF l_flag = FALSE THEN
         LET g_success = 'N'
         LET g_showmsg = p_afc00,'/',p_afc01,'/',p_afc02,'/',
                         p_afc03 USING "<<<&",'/',l_afc04,'/', #CHI-A40021 mod p_afc04->l_afc04
                         p_afc041,'/',l_afc042,'/',  #CHI-A40021 mod p_afc042->l_afc042
                         p_afc05 USING "<&",p_sum2,'/',l_over
         IF p_flag1 = '2' THEN
            LET g_errno = 'agl-232'
         END IF
         IF g_bgerr THEN
            CALL s_errmsg('afc00,afc01,afc02,afc03,afc04,afc041,afc042,afc05,npl05,npl05',g_showmsg,'t420sub_bud',g_errno,1)
         ELSE
            CALL cl_err(g_showmsg,g_errno,1)
         END IF
      ELSE
         IF l_afb07 = '2' AND l_over < 0 THEN
            IF p_flag1 = '2' THEN
               LET g_errno = 'agl-232'
            END IF
            LET g_showmsg = p_afc00,'/',p_afc01,'/',p_afc02,'/',
                            p_afc03 USING "<<<&",'/',l_afc04,'/', #CHI-A40021 mod p_afc04->l_afc04
                            p_afc041,'/',l_afc042,'/',  #CHI-A40021 mod p_afc042->l_afc042
                            p_afc05 USING "<&",p_sum2,'/',l_over
            IF g_bgerr THEN
               CALL s_errmsg('afc00,afc01,afc02,afc03,afc04,afc041,afc042,afc05,npl05,npl05',g_showmsg,'t420sub_bud',g_errno,1)
            ELSE
               LET l_msg = cl_getmsg(g_errno,g_lang)
               LET l_msg = g_showmsg CLIPPED, l_msg CLIPPED
               CALL cl_msgany(10,20,l_msg)
            END IF
            LET g_errno = ' '
         END IF
      END IF
END FUNCTION
 
FUNCTION t540sub_z(p_pmm01,p_action_choice,p_call_transaction)       # when g_pmk.pmk18='Y' (Turn to 'N')
   DEFINE p_pmm01         LIKE pmm_file.pmm01
   DEFINE p_action_choice STRING
   DEFINE p_call_transaction LIKE type_file.num5 #WHEN TRUE -> CALL BEGIN/ROLLBACK/COMMIT WORK
   DEFINE l_pmm RECORD    LIKE pmm_file.*
   DEFINE l_cnt           LIKE type_file.chr10
   DEFINE l_pmmcont       LIKE pmm_file.pmmcont  #CHI-C80072 Add
#MOD-C10151 ----- mark start -----
##TQC-B90037 --begin--
#   DEFINE l_pmn41         LIKE pmn_file.pmn41
#   DEFINE l_n             LIKE type_file.num5
##TQC-B90037 --end--
#MOD-C10151 ----- mark end -----
   
   LET g_success='Y'
 
   IF cl_null(p_pmm01) THEN CALL cl_err('','-400',1) LET g_success='N' RETURN END IF
   
   SELECT * INTO l_pmm.* FROM pmm_file
                        WHERE pmm01=p_pmm01
   
   IF l_pmm.pmm25 = 'S' THEN
      CALL cl_err(l_pmm.pmm25,'apm-030',1)
      LET g_success='N'
      RETURN
   END IF
 
#MOD-C10151 ----- mark start -----
##TQC-B90037 --begin--
#   IF l_pmm.pmm02 = 'SUB' THEN
#      LET l_n = 0 
#      
#      DECLARE t590_cus CURSOR FOR
#       SELECT pmn41 FROM pmn_file WHERE pmn01 = l_pmm.pmm01
#      
#      FOREACH t590_cus INTO l_pmn41
#        SELECT COUNT(*) INTO l_n FROM sfq_file
#         WHERE sfq02 = l_pmn41
#        IF l_n > 0 THEN
#           CALL cl_err('','apm-180',0)
#           LET g_success = 'N'
#           RETURN
#        END IF  
#      END FOREACH   
#      
#   END IF 
##TQC-B90037 --end--
#MOD-C10151 ----- mark end -----

   SELECT COUNT(*) INTO l_cnt FROM apb_file
   WHERE apb06=l_pmm.pmm01
   IF l_cnt>0 THEN
      CALL cl_err(l_pmm.pmm01,'apm-026',1)  #MOD-640492 0->1
      LET g_success='N'
      RETURN
   END IF
 
   SELECT * INTO l_pmm.* FROM pmm_file WHERE pmm01=l_pmm.pmm01
   IF l_pmm.pmm18='N' THEN  RETURN LET g_success='N' END IF               #FUN-550038
   IF l_pmm.pmm18='X' THEN CALL cl_err('','9024',1) LET g_success='N' RETURN END IF  #MOD-640492 0->1
   IF l_pmm.pmm02 = 'ICT' THEN LET g_success='N' RETURN END IF  #MOD-4A0334
  #---------No:CHI-B10040 add
   IF l_pmm.pmm25 = '6' THEN 
      CALL cl_err('','apm-056',1) 
      LET g_success = 'N'     
      RETURN 
   END IF     
  #---------No:CHI-B10040 end
   IF g_prog='apmt570' OR g_prog = 'apmt590' THEN #已發出採購 #FUN-920175
      IF l_pmm.pmm25 not matches '[01]' THEN RETURN END IF   #MOD-540061
      #-----MOD-AB0100---------
      #SELECT COUNT(*) INTO l_cnt FROM rvb_file
      #WHERE rvb04=l_pmm.pmm01
      SELECT COUNT(*) INTO l_cnt FROM rva_file,rvb_file
      WHERE rvb04=l_pmm.pmm01
        AND rva01=rvb01
        AND rvaconf <> 'X'
      #-----END MOD-AB0100-----
      IF l_cnt>0 THEN
         CALL cl_err(l_pmm.pmm01,'apm-275',1)   #MOD-640492 0->1
         LET g_success='N'
         RETURN         
      END IF
   ELSE
       IF l_pmm.pmm25 not matches '[01RW]' THEN   #MOD-540061
         CALL cl_err('','apm-337',1)         #MOD-640492 0->1
         LET g_success='N' 
         RETURN
      END IF
   END IF
   IF NOT cl_null(p_action_choice) THEN   #FUN-A80102
      IF NOT cl_confirm('axm-109') THEN LET g_success='N' RETURN END IF
   END IF
   IF p_call_transaction THEN
      BEGIN WORK 
   END IF
   
   LET g_success = 'Y'
 
   CALL t540sub_lock_cl()
   
   OPEN t540sub_cl USING l_pmm.pmm01
   IF STATUS THEN
      CALL cl_err("OPEN t540sub_cl:", STATUS, 1)
      CLOSE t540sub_cl
      IF p_call_transaction THEN
         ROLLBACK WORK
      END IF
      LET g_success='N' 
      RETURN
   END IF
   FETCH t540sub_cl INTO l_pmm.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_pmm.pmm01,SQLCA.sqlcode,1)
      IF p_call_transaction THEN
         ROLLBACK WORK
      END IF
      LET g_success='N'
      RETURN
   END IF
 
  #FUN-920175本段由_z1()合併過來 begin
      LET l_pmm.pmm25=0
 
   IF s_industry('icd') THEN
      IF NOT t540sub_icd_upd_data2(l_pmm.pmm01) THEN 
         LET g_success = 'N'
      END IF
   END IF
 
   UPDATE pmn_file SET #No:4803
          pmn16 = '0'  #開立
    WHERE pmn01 = l_pmm.pmm01
      AND pmn16 = '1'  #MOD-630039
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","pmn_file",l_pmm.pmm01,"",STATUS,"","upd pmn16",1)  #No.FUN-660129
      LET g_success = 'N' RETURN
   END IF

   LET l_pmmcont = TIME  #CHI-C80072 Add 
   UPDATE pmm_file SET pmm03=l_pmm.pmm03, pmm18='N',
                       pmm25=l_pmm.pmm25,
                       pmmsseq=0,
                      #CHI-C80072 Mark&Add Str
                      #pmmcont='',   #FUN-870007
                      #pmmconu='',   #FUN-870007
                      #pmmcond='',   #FUN-870007
                       pmm15 = g_user, #TQC-D40036
                       pmmcont=l_pmmcont,
                       pmmconu=g_user,
                       pmmcond=g_today,
                      #CHI-C80072 Mark&Add End
                       pmmpos='N'    #FUN-870007
          WHERE pmm01 = l_pmm.pmm01
 
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","pmm_file",l_pmm.pmm01,"",STATUS,"","upd pmn18",1)  #No.FUN-660129
      LET g_success = 'N' RETURN
   ELSE
     # 將簽核資料還原
     IF l_pmm.pmmmksg MATCHES '[Yy]'  THEN
        LET l_pmm.pmmsseq = 0
        DELETE FROM azd_file WHERE azd01 = l_pmm.pmm01 AND azd02 = 3
        IF STATUS  THEN LET g_success = 'N' RETURN
        ELSE
           CALL s_signm(6,34,g_lang,'2',l_pmm.pmm01,3,l_pmm.pmmsign,
                        l_pmm.pmmdays,l_pmm.pmmprit,l_pmm.pmmsmax,l_pmm.pmmsseq)
        END IF
     END IF
   END IF
  #FUN-920175本段由_z1()合併過來 end
 
# Update ecm_file if exist
   IF g_sma.sma54='Y'  #是否使用製程
      THEN   #
      CALL t540sub_upd_ecm('-',l_pmm.pmm01)
   END IF
   IF l_pmm.pmm02='SUB' THEN
      CALL t540sub_upd_sgm('-',l_pmm.pmm01)
   END IF

   #DEV-D30045--add--begin
   #自動作廢barcode
   IF g_success='Y' AND (g_prog = 'apmt540' OR g_prog = 'apmt590') AND
      g_aza.aza131 = 'Y' THEN
      CALL t540sub_barcode_z(l_pmm.pmm01)
   END IF
   #DEV-D30045--add--end

   IF g_success = 'Y' THEN 
      IF p_call_transaction THEN
         COMMIT WORK
      END IF
      
   ELSE 
      IF p_call_transaction THEN
         ROLLBACK WORK
      END IF
   END IF

END FUNCTION
 
#更新資料(取消確認回寫)
FUNCTION t540sub_icd_upd_data2(p_pmm01)
   DEFINE l_pmn   RECORD LIKE pmn_file.*
   DEFINE p_pmm01 LIKE pmm_file.pmm01
   DEFINE l_msg   LIKE type_file.chr50
 
   DECLARE blanket_cs2 CURSOR FOR
    SELECT * FROM pmn_file WHERE pmn01 = p_pmm01
 
   FOREACH blanket_cs2 INTO l_pmn.*
      IF cl_null(l_pmn.pmn68) OR cl_null(l_pmn.pmn69) THEN
         CONTINUE FOREACH
      END IF
 
      UPDATE pmni_file SET pmniicd10 = 'N'
       WHERE pmni01 = l_pmn.pmn68 AND pmni02 = l_pmn.pmn69
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         LET l_msg = 'UPDATE blanket PO :',l_pmn.pmn68,
                     '(',l_pmn.pmn69,')'
         CALL cl_err(l_msg,SQLCA.sqlcode,1)
         RETURN FALSE 
      END IF
   END FOREACH
   RETURN TRUE
END FUNCTION
 
#FUNCTION t540sub_x(p_pmm01,p_action_choice,p_call_transaction) #FUN-D20025 mark
FUNCTION t540sub_x(p_pmm01,p_action_choice,p_call_transaction,p_type) #FUN-D20025 add
    DEFINE p_pmm01         LIKE pmm_file.pmm01
    DEFINE p_action_choice STRING
    DEFINE p_call_transaction LIKE type_file.num5 #WHEN TRUE -> CALL BEGIN/ROLLBACK/COMMIT WORK
    DEFINE l_pmm RECORD    LIKE pmm_file.*
#    DEFINE l_qty      LIKE ima_file.ima26       #No.FUN-680136 DECIMAL(15,3) #FUN-A20044
    DEFINE l_qty      LIKE  type_file.num15_3       #No.FUN-680136 DECIMAL(15,3) #FUN-A20044
    DEFINE l_pmn41      LIKE pmn_file.pmn41
    DEFINE l_sfb87      LIKE sfb_file.sfb87
    DEFINE l_pmn      RECORD LIKE pmn_file.*
    DEFINE l_pml20      LIKE pml_file.pml20     #No.MOD-850011
    DEFINE l_pml21      LIKE pml_file.pml21     #No.MOD-850011
    DEFINE l_pmn20      LIKE pmn_file.pmn20     #No.MOD-850011
    DEFINE l_msg        STRING                  #No.MOD-850011
    DEFINE l_cnt        LIKE type_file.num5       #MOD-970002
    DEFINE l_pmn02      LIKE pmn_file.pmn02     #MOD-A50210
    DEFINE l_pmlslk02   LIKE pmlslk_file.pmlslk02   #FUN-B90103
    DEFINE l_pmlslk21   LIKE pmlslk_file.pmlslk21   #FUN-B90103 
    DEFINE l_pon07      LIKE pon_file.pon07     #FUN-910088--add--
    DEFINE l_pml07      LIKE pml_file.pml07     #FUN-910088--add--
    DEFINE l_pml16      LIKE pml_file.pml16     #MOD-BC0168 add
    DEFINE p_type       LIKE type_file.chr1  #FUN-D20025 add   
   LET l_msg = NULL                             #No.MOD-850011
 
   LET g_success='Y'  #FUN-920175
   IF s_shut(0) THEN LET g_success='N' RETURN END IF
   SELECT * INTO l_pmm.* FROM pmm_file WHERE pmm01=p_pmm01
   IF l_pmm.pmm01 IS NULL THEN CALL cl_err('',-400,1) LET g_success='N' RETURN END IF      #MOD-640492 0->1
   IF l_pmm.pmm18 = 'Y'  THEN CALL cl_err('','axm-101',1) LET g_success='N' RETURN END IF  #MOD-640492 0->1
   #FUN-D20025---begin 
   IF p_type = 1 THEN 
      IF l_pmm.pmm18='X' THEN RETURN END IF
   ELSE
      IF l_pmm.pmm18<>'X' THEN RETURN END IF
   END IF 
   #FUN-D20025---end 
   #狀況為開立及取消時才可執行作廢or取消
   IF l_pmm.pmm25 NOT MATCHES '[0RW9]' THEN LET g_success='N' RETURN END IF    #FUN-550038
   #NO:6961 check 若此為委外單且工單已確認.不可取消作廢
   DECLARE t540_x CURSOR FOR SELECT pmn41 FROM pmn_file WHERE pmn01=l_pmm.pmm01
   FOREACH t540_x INTO l_pmn41
      IF NOT cl_null(l_pmn41) THEN
         SELECT sfb87 INTO l_sfb87 FROM sfb_file
          WHERE sfb01=l_pmn41
            AND sfb02 IN ('8','7')
            AND sfb100='1'
         CASE WHEN l_sfb87='Y'
                   IF s_industry('icd') THEN
                      EXIT CASE  #FUN-920190 ICD的工單在取消確認時,會一併將委外採購單作廢,故此處不卡
                   END IF
                   CALL cl_err(l_pmn41,'asf-945',1)
                   LET g_success='N' 
                   RETURN
                   EXIT FOREACH
              WHEN l_sfb87='X'
                   CALL cl_err(l_pmn41,'asf-947',1)
                   LET g_success='N' 
                   RETURN
                   EXIT FOREACH
              OTHERWISE CONTINUE FOREACH
         END CASE
      END IF
   END FOREACH
   IF p_call_transaction THEN
      BEGIN WORK
   END IF
   LET g_success='Y'
 
   CALL t540sub_lock_cl()
   
   OPEN t540sub_cl USING l_pmm.pmm01
   IF STATUS THEN
      CALL cl_err("OPEN t540sub_cl:", STATUS, 1)
      CLOSE t540sub_cl
      IF p_call_transaction THEN
         ROLLBACK WORK
      END IF
      LET g_success='N'
      RETURN
   END IF
   FETCH t540sub_cl INTO l_pmm.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_pmm.pmm01,SQLCA.sqlcode,1)
      IF p_call_transaction THEN
         ROLLBACK WORK
      END IF
      LET g_success='N'
      RETURN
   END IF
 
   #NO:3225 modify by Carol:add 作廢取消
   IF NOT cl_null(p_action_choice) THEN
      IF NOT cl_void(0,0,l_pmm.pmm18) THEN
         IF p_call_transaction THEN
            ROLLBACK WORK
         END IF
         LET g_success='N'
         RETURN
      END IF
   END IF
   
   IF l_pmm.pmm18 ='N' THEN
       LET l_pmm.pmm18='X'
       LET l_pmm.pmm25='9'
       #-----MOD-A50210---------
       IF l_pmm.pmm909 = '3' THEN 
          DECLARE t540_x2_c CURSOR FOR
             SELECT pmn02 FROM pmn_file
              WHERE pmn01=l_pmm.pmm01
          FOREACH t540_x2_c INTO l_pmn02
             CALL t540_upd_oeb28('x',l_pmn02,l_pmm.pmm01)  
          END FOREACH 
       END IF
       #-----END MOD-A50210-----
   ELSE
       LET l_pmm.pmm18='N'
       LET l_pmm.pmm25='0'
       #-----MOD-A50210---------
       IF l_pmm.pmm909 = '3' THEN 
          DECLARE t540_x3_c CURSOR FOR
             SELECT pmn02 FROM pmn_file
              WHERE pmn01=l_pmm.pmm01
          FOREACH t540_x3_c INTO l_pmn02
             CALL t540_upd_oeb28('z',l_pmn02,l_pmm.pmm01)  
          END FOREACH 
       END IF
       #-----END MOD-A50210-----
   END IF
   UPDATE pmm_file SET
          pmm18= l_pmm.pmm18,
          pmm25= l_pmm.pmm25,
          pmmmodu=g_user,
          pmmpos = 'N',       #FUN-870007
          pmmdate=TODAY
    WHERE pmm01 = l_pmm.pmm01
   IF STATUS THEN
      CALL cl_err3("upd","pmm_file",l_pmm.pmm01,"",STATUS,"","upd pmm18:",1) #No.FUN-660129
      LET g_success='N' END IF
  #MOD-C60115----mark-----
  #UPDATE pmn_file SET pmn16=l_pmm.pmm25
  # WHERE pmn01 = l_pmm.pmm01
  #IF STATUS THEN
  #   CALL cl_err3("upd","pmn_file",l_pmm.pmm01,"",STATUS,"","upd pmm16:",1) #No.FUN-660129
  #   LET g_success='N' 
  #END IF
  #MOD-C60115----mark-----

#IF l_pmm.pmm909 != '3' THEN     #MOD-A80213    #MOD-B60102 mark
 IF l_pmm.pmm909 MATCHES '[128]' THEN           #MOD-B60102
    #No.B411 010420 by linda add 回寫請購單之已轉採購量
   DECLARE t540_x_c CURSOR FOR
           SELECT * FROM pmn_file WHERE pmn01=l_pmm.pmm01
   FOREACH t540_x_c INTO l_pmn.*
     #MOD-C60115----S----
      UPDATE pmn_file SET pmn16=l_pmm.pmm25
       WHERE pmn01 = l_pmn.pmn01
         AND pmn02 = l_pmn.pmn02
      IF STATUS THEN
         CALL cl_err3("upd","pmn_file",l_pmn.pmn01,l_pmn.pmn02,STATUS,"","upd pmm16:",1)
         LET g_success='N'
      END IF
     #MOD-C60115----E----
      IF NOT cl_null(l_pmn.pmn24) AND l_pmm.pmm909 MATCHES '[12]'  AND l_pmn.pmn24 <> " " THEN   #No.MOD-980151 #FUN-B90103-addl_pmn.pmn24 <> " " 
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM pmk_file
           WHERE pmk01 = l_pmn.pmn24 AND pmk18 ='Y'
         IF l_pmm.pmm18 = 'N' AND l_cnt = 0 THEN
            CALL cl_err(l_pmn.pmn24,'apm-115',1)
            LET g_success = 'N'
            EXIT FOREACH    #FUN-B90103--add
         END IF
      END IF
      IF l_pmn.pmn24 IS NOT NULL AND l_pmm.pmm909 MATCHES '[12]' AND l_pmn.pmn24<> " " THEN   # 更新請購已轉採購量#MOD-8C0140#FUN-B90103-addl_pmn.pmn24 <> " " 
         #MOD-BC0168 add --start--
         SELECT pml16 INTO l_pml16 
           FROM pml_file
          WHERE pml01=l_pmn.pmn24 AND pml02=l_pmn.pmn25
         #MOD-BC0168 add --end--
         SELECT SUM(pmn20/pmn62*pmn121) INTO l_qty FROM pmn_file
           WHERE pmn24=l_pmn.pmn24 AND pmn25=l_pmn.pmn25
             AND pmn16<>'9'        #取消(Cancel)
         IF STATUS OR l_qty IS NULL THEN LET l_qty=0 END IF
         #FUN-910088--add--start--
         SELECT pml07 INTO l_pml07 FROM pml_file
          WHERE pml01=l_pmn.pmn24 AND pml02= l_pmn.pmn25
         LET l_qty = s_digqty(l_qty,l_pml07)   
         #FUN-910088--add--end--
         IF l_pmm.pmm18='N' THEN
            SELECT pmn20/pmn62*pmn121 INTO l_pmn20 FROM pmn_file
             WHERE pmn01 = l_pmn.pmn01 AND pmn02=l_pmn.pmn02
            LET l_pmn20 = s_digqty(l_pmn20,l_pml07)   #FUN-910088--add--
            IF cl_null(l_pmn20) THEN LET l_pmn20 = 0 END IF
            SELECT pml20,pml21 INTO l_pml20,l_pml21 FROM pml_file
             WHERE pml01=l_pmn.pmn24 AND pml02= l_pmn.pmn25
            IF cl_null(l_pml20) THEN LET l_pml20 = 0 END IF 
            IF cl_null(l_pml21) THEN LET l_pml21 = 0 END IF 
            IF l_pmn20 > l_pml20-l_pml21 THEN
               LET l_msg = l_pmn.pmn01,'-',l_pmn.pmn02,' '
               CALL cl_err(l_msg,'axm-611',1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF 
         END IF
         #MOD-BC0168 add --start--
         IF l_pml16 NOT MATCHES '[678]' THEN 
            IF l_qty=0 THEN 
               LET l_pml16 ='1'
            ELSE
               LET l_pml16 ='2'
            END IF
         END IF
         #MOD-BC0168 add --end--
        #IF l_qty=0 THEN                   # modi by kitty 96-05-24 #MOD-BC0168 mark
           #UPDATE pml_file SET pml21=l_qty,pml16='1'      #MOD-BC0168 mark  
            UPDATE pml_file SET pml21=l_qty,pml16=l_pml16  #MOD-BC0168
             WHERE pml01=l_pmn.pmn24 AND pml02=l_pmn.pmn25
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
               CALL cl_err3("upd","pml_file",l_pmn.pmn24,l_pmn.pmn25,SQLCA.sqlcode,"","upd pml",1)  #No.FUN-660129
               LET g_success='N'
            END IF
        #MOD-BC0168 mark --start--
        #ELSE
        #   UPDATE pml_file SET pml21=l_qty,pml16='2'   #MOD-990206
        #    WHERE pml01=l_pmn.pmn24 AND pml02=l_pmn.pmn25
        #      AND pml16 <= '2'   #MOD-990206
        #   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
        #      CALL cl_err3("upd","pml_file",l_pmn.pmn24,l_pmn.pmn25,SQLCA.sqlcode,"","upd pml:",1)  #No.FUN-660129
        #      LET g_success='N'
        #   END IF
        #END IF
        #MOD-BC0168 mark --end--
#FUN-B90103---------------add----------------
          IF s_industry("slk") THEN
             IF g_azw.azw04='2' THEN    #FUN-C20006--add
                SELECT pmlislk03 INTO l_pmlslk02 FROM pmli_file
                  WHERE pmli01=l_pmn.pmn24 AND pmli02=l_pmn.pmn25   #請購單母料件項次
 
                SELECT SUM(pml21) INTO l_pmlslk21 FROM pml_file     #統計已轉請購數量
                  WHERE pml01=l_pmn.pmn24
                    AND pml02 IN(SELECT pml02 FROM pml_file,pmli_file
                                 WHERE pml01=pmli01
                                   AND pml02=pmli02
                                   AND pmlislk03=l_pmlslk02
                                   AND pmli01=l_pmn.pmn24)
               UPDATE pmlslk_file SET pmlslk21=l_pmlslk21 WHERE pmlslk01=l_pmn.pmn24
                 AND pmlslk02=l_pmlslk02
            END IF
         END IF    #FUN-C20006--add
#FUN-B90103---------------end----------------
         #----- 當單身狀況碼皆為1時,update單頭狀況碼96-05-24
         IF l_pmm.pmm18 ='X' THEN
            UPDATE pmk_file SET pmk25='1'
             WHERE pmk01=l_pmn.pmn24 AND pmk01 NOT IN
             (SELECT pml01 FROM pml_file WHERE pml01=l_pmn.pmn24
                           AND pml16 NOT IN ('1'))   
               AND pmk25 != '6'
         END IF
         IF l_pmm.pmm18 ='N' THEN
            UPDATE pmk_file SET pmk25='2'
            #WHERE pmk01=l_pmn.pmn24 AND pmk01 NOT IN   #MOD-B90094 mark
             WHERE pmk01=l_pmn.pmn24 AND pmk01 IN       #MOD-B90094 add
             (SELECT pml01 FROM pml_file WHERE pml01=l_pmn.pmn24
                           #AND pml16 NOT IN ('1'))   #MOD-990207
                          #AND pml16 IN ('1'))   #MOD-990207 #MOD-BC0168 mark
                           AND pml16 IN ('1','2'))   #MOD-BC0168 加2,因取消作廢時,單身已經先更新為已轉採購,只抓1會抓不到
               AND pmk25 != '6'
         END IF
         IF SQLCA.SQLCODE  THEN
            CALL cl_err3("upd","pmk_file",l_pmn.pmn24,"",SQLCA.sqlcode,"","upd pmk:",1)  #No.FUN-660129
            LET g_success='N'
         END IF
      END IF
      IF NOT cl_null(l_pmn.pmn68) THEN             # 更新已轉Blanket量
         SELECT SUM(pmn20/pmn62*pmn70) INTO l_qty FROM pmn_file,pmm_file     #No:MOD-AA0150 add pmm_file 
           WHERE pmn68=l_pmn.pmn68 AND pmn69=l_pmn.pmn69
             AND pmm01 = pmn01 AND pmm18 != 'X'                              #No:MOD-AA0150 add
             AND pmn16<>'9'        #取消(Cancel)
         IF STATUS OR cl_null(l_qty) THEN LET l_qty=0 END IF
       #FUN-910088--add--start--
         SELECT pon07 INTO l_pon07 FROM pon_file
          WHERE pon01=l_pmn.pmn68 AND pon02=l_pmn.pmn69
         LET l_qty = s_digqty(l_qty,l_pon07) 
       #FUN-910088--add--end--
         IF l_qty=0 THEN                   # modi by kitty 96-05-24
            IF NOT s_industry('icd') THEN                 #No:MOD-AA0150 add
               UPDATE pon_file SET pon21=l_qty,pon16='1'
                WHERE pon01=l_pmn.pmn68 AND pon02=l_pmn.pmn69
           #--------------No:MOD-AA0150 add
            ELSE
               UPDATE pmni_file SET pmniicd13=l_qty
                WHERE pmni01=l_pmn.pmn68 AND pmni02=l_pmn.pmn69
               UPDATE pmn_file SET pmn16='1'
                WHERE pmn01=l_pmn.pmn68 AND pmn02=l_pmn.pmn69
            END IF
           #--------------No:MOD-AA0150 end
         ELSE
            IF NOT s_industry('icd') THEN                 #No:MOD-AA0150 add
               UPDATE pon_file SET pon21=l_qty
                WHERE pon01=l_pmn.pmn68 AND pon02=l_pmn.pmn69
           #------------------No:MOD-AA0150 add
            ELSE
               UPDATE pmni_file SET pmniicd13=l_qty
                WHERE pmni01=l_pmn.pmn68 AND pmni02=l_pmn.pmn69
            END IF
           #------------------No:MOD-AA0150 end
         END IF
        #-------------------No:MOD-AA0150 add
         IF l_pmm.pmm18 = 'N' THEN
            IF NOT s_industry('icd') THEN    
               UPDATE pon_file SET pon16 = '2'
                WHERE pon01=l_pmn.pmn68 AND pon02=l_pmn.pmn69
            ELSE
               UPDATE pmn_file SET pmn16 = '2'
                WHERE pmn01=l_pmn.pmn68 AND pmn02=l_pmn.pmn69
            END IF
         END IF
        #-------------------No:MOD-AA0150 end
         #----- 當單身狀況碼皆為1時,update單頭狀況碼96-05-24
         UPDATE pom_file SET pom25='1'
          WHERE pom01=l_pmn.pmn68 AND pom01 NOT IN
          (SELECT pon01 FROM pon_file WHERE pon01=l_pmn.pmn68
                        AND pon16 NOT MATCHES '[1]')
      END IF
   END FOREACH
END IF              #MOD-A80213 
   IF g_success='Y' THEN
       IF p_call_transaction THEN
          COMMIT WORK
       END IF
       CALL cl_flow_notify(l_pmm.pmm01,'V')
   ELSE
       IF p_call_transaction THEN
          ROLLBACK WORK
       END IF
   END IF
 
END FUNCTION
 
FUNCTION t540sub_r(p_pmm01,p_action_choice,p_call_transaction)
    DEFINE l_chr,l_sure         LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
#    DEFINE l_qty                LIKE ima_file.ima26    #No.FUN-680136 DECIMAL(15,3) #FUN-A20044
    DEFINE l_qty                LIKE type_file.num15_3    #No.FUN-680136 DECIMAL(15,3) #FUN-A20044
    DEFINE l_pmn                RECORD LIKE pmn_file.*
    DEFINE l_pmn_1              RECORD LIKE pmn_file.*   #No.FUN-9C0046
    DEFINE l_cmd                LIKE type_file.chr1000   #No.FUN-720043 add
    DEFINE p_pmm01              LIKE pmm_file.pmm01      #FUN-920190
    DEFINE p_action_choice      STRING                   #FUN-920190
    DEFINE p_call_transaction   LIKE type_file.chr1      #FUN-920190 #WHEN TRUE -> CALL BEGIN/ROLLBACK/COMMIT WORK
    DEFINE l_pmm                RECORD LIKE pmm_file.*   #FUN-920190
    DEFINE l_cnt                LIKE type_file.num5
    DEFINE l_msg                LIKE type_file.chr30
    DEFINE l_pmn02              LIKE pmn_file.pmn02      #MOD-A50210
    DEFINE l_pml20              LIKE pml_file.pml20      #No.FUN-A90009
    DEFINE l_pml21              LIKE pml_file.pml21      #No.FUN-A90009
    DEFINE l_pmlslk02           LIKE pmlslk_file.pmlslk02  #FUN-B90103--add
    DEFINE l_pmlslk21           LIKE pmlslk_file.pmlslk21  #FUN-B90103--add
    DEFINE l_pon07      LIKE pon_file.pon07     #FUN-910088--add--
    DEFINE l_pml07      LIKE pml_file.pml07     #FUN-910088--add--
    DEFINE l_pml16              LIKE pml_file.pml16      #MOD-BC0168 add
    
    LET g_success='Y'  #FUN-920190
    IF s_shut(0) THEN LET g_success='N' RETURN END IF
    IF cl_null(p_pmm01) THEN CALL cl_err('','-400',1) LET g_success='N' RETURN END IF  #MOD-640492 0->1
    SELECT * INTO l_pmm.* FROM pmm_file
     WHERE pmm01=p_pmm01
    IF l_pmm.pmm18='Y' THEN CALL cl_err('','axm-101',1) LET g_success='N' RETURN END IF #MOD-640492 0->1
    IF l_pmm.pmm18='X' THEN CALL cl_err('','9024',1) LET g_success='N' RETURN END IF    #MOD-640492 0->1
    IF l_pmm.pmm01 IS NULL THEN CALL cl_err('',-400,1) LET g_success='N' RETURN END IF  #MOD-640492 0->1
    IF l_pmm.pmm25 = '2' THEN CALL cl_err('','axm-101',1) LET g_success='N' RETURN END IF  #MOD-640492 0->1
    IF l_pmm.pmm25 matches '[Ss1]' THEN          #FUN-550038
        CALL cl_err("","mfg3557",1)  #MOD-640492 0->1
        LET g_success='N' RETURN
    END IF
    #請購分配單不可刪除
    IF l_pmm.pmm909='6' THEN CALL cl_err('','art-246',0) RETURN END IF

    IF l_pmm.pmm909 = '8' THEN
       IF NOT cl_confirm("apm1025") THEN
          LET g_success='N'
          ROLLBACK WORK
          RETURN
       END IF
       DECLARE t540_r_c_1 CURSOR FOR
           SELECT * FROM pmn_file WHERE pmn01=l_pmm.pmm01
       FOREACH t540_r_c_1 INTO l_pmn_1.*
          IF NOT cl_null(l_pmn_1.pmn24) AND NOT cl_null(l_pmn_1.pmn25) THEN
             UPDATE wpd_file SET wpd10='',wpd11='N' WHERE wpd01=l_pmn_1.pmn99 #MODIFY---TQC-BA0169-----
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                CALL cl_err3("upd","wpd_file","","",SQLCA.sqlcode,"","",1)
                LET g_success='N'
                ROLLBACK WORK
                RETURN
             END IF
             UPDATE wpc_file SET wpc09='N' WHERE wpc01=l_pmn_1.pmn99 #MODIFY---TQC-BA0169-----
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                CALL cl_err3("upd","wpc_file","","",SQLCA.sqlcode,"","",1)
                LET g_success='N'
                ROLLBACK WORK
                RETURN
             END IF
             ##No.FUN-A90009--begin 
             #SELECT pml20,pml21 INTO l_pml20,l_pml21 FROM pml_file WHERE pml01=l_pmn_1.pmn24 
             #AND pml02=l_pmn_1.pmn25 
             #IF l_pml21<l_pml20 THEN 
             #   UPDATE pml_file SET pml92='N',pml93=' ' 
             #    WHERE pml01=l_pmn_1.pmn24 
             #      AND pml02=l_pmn_1.pmn25 
             #   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
             #      CALL cl_err3("upd","pml_file","","",SQLCA.sqlcode,"","",1)
             #      LET g_success='N'
             #      ROLLBACK WORK
             #      RETURN
             #   END IF
             #END IF 
             ##No.FUN-A90009--end 
          END IF
       END FOREACH
     END IF

    IF NOT cl_null(p_action_choice) THEN
       IF NOT cl_delh(20,16) THEN
          LET g_success='N' RETURN
       END IF
    END IF
 
    IF p_call_transaction THEN
       BEGIN WORK
    END IF
 
    CALL t540sub_lock_cl()
 
    OPEN t540sub_cl USING l_pmm.pmm01
    IF STATUS THEN
       CALL cl_err("OPEN t540sub_cl:", STATUS, 1)
       CLOSE t540sub_cl
       IF p_call_transaction THEN
          ROLLBACK WORK
       END IF
       CLOSE t540sub_cl
       LET g_success='N'
       RETURN
    END IF
    FETCH t540sub_cl INTO l_pmm.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(l_pmm.pmm01,SQLCA.sqlcode,1)
       IF p_call_transaction THEN
          ROLLBACK WORK
       END IF
       CLOSE t540sub_cl
       LET g_success='N'
       RETURN
    END IF

    #-----MOD-A50210---------
    IF l_pmm.pmm909 = '3' THEN 
       DECLARE t540_r2_c CURSOR FOR
          SELECT pmn02 FROM pmn_file
           WHERE pmn01=l_pmm.pmm01
       FOREACH t540_r2_c INTO l_pmn02
          CALL t540_upd_oeb28('r',l_pmn02,l_pmm.pmm01)  
       END FOREACH 
    END IF
    #-----END MOD-A50210-----

    CALL cl_msg("Delete pmm,pmn,pmz,pmo,pmp!")
    DELETE FROM pmm_file WHERE pmm01 = l_pmm.pmm01
    IF SQLCA.SQLERRD[3]=0
         THEN CALL cl_err3("del","pmm_file",l_pmm.pmm01,"",SQLCA.sqlcode,"","No pmm deleted",1)  #No.FUN-660129
            IF p_call_transaction THEN
               ROLLBACK WORK
            END IF
            CLOSE t540sub_cl
            LET g_success='N' 
            RETURN
    END IF
    #FUN-B90103-----add-------------------
     IF s_industry("slk") THEN
        IF g_azw.azw04='2' THEN      #FUN-C20006--add--
           DELETE FROM pmnslk_file WHERE pmnslk01 =l_pmm.pmm01
           DELETE FROM pmni_file WHERE pmni01 = l_pmm.pmm01
        END IF                      #FUN-C20006--add--
     END IF                        
    #FUN-B90103-----end------------------- 
    #-----MOD-A70186---------
    INITIALIZE g_doc.* TO NULL         
    LET g_doc.column1 = "pmm01"         
    LET g_doc.value1 = l_pmm.pmm01     
    CALL cl_del_doc()                  
    #-----END MOD-A70186-----
    IF g_sma.sma901 = 'Y' THEN
        LET l_cmd = " DELETE FROM vmz_file ",                      #NO.FUN-7C0002 add
                    "  WHERE vmz01 MATCHES '",l_pmm.pmm01,"*'"     #NO.FUN-7C0002 add
        PREPARE t420_del_aps_spm FROM l_cmd
        EXECUTE t420_del_aps_spm
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","vmz_file",l_pmm.pmm01,'',SQLCA.sqlcode,"","",1)  #NO.FUN-7C0002 add
            IF p_call_transaction THEN
               ROLLBACK WORK
            END IF
            CLOSE t540sub_cl
            LET g_success='N' RETURN
        END IF
    END IF
    DECLARE t540_r_c CURSOR FOR
        SELECT * FROM pmn_file WHERE pmn01=l_pmm.pmm01
    FOREACH t540_r_c INTO l_pmn.*
       DELETE FROM pmn_file
            WHERE pmn01=l_pmn.pmn01 AND pmn02=l_pmn.pmn02
       IF SQLCA.SQLERRD[3]=0          #modi by kitty96-05-24
            THEN CALL cl_err3("del","pmn_file",l_pmn.pmn01,l_pmn.pmn02,SQLCA.sqlcode,"","No pmn deleted",1)  #No.FUN-660129
            IF p_call_transaction THEN
               ROLLBACK WORK
            END IF
            CLOSE t540sub_cl
            LET g_success='N' RETURN
       END IF
       #FUN-B90103--------------mark------begin--------------------    
      ##FUN-A50054---Begin add       
      #IF s_industry('slk') THEN 
      #   DELETE FROM ata_file WHERE ata00 = g_prog AND ata01= g_pmm.pmm01
      #   IF STATUS THEN 
      #      CALL cl_err('',STATUS,1)
      #   END IF
      #END IF
      ##FUN-A50054---End 
      #FUN-B90103---------------mark------------end----------------
       #-----MOD-A50210---------
       #IF l_pmm.pmm909 = '3' THEN      #訂單轉入
       #   IF NOT cl_null(l_pmn.pmn24) AND NOT cl_null(l_pmn.pmn25) THEN
       #      UPDATE oeb_file SET oeb27 = NULL,
       #                          oeb28 = 0
       #       WHERE oeb01 = l_pmn.pmn24 AND oeb03 = l_pmn.pmn25
       #      IF SQLCA.SQLCODE  THEN
       #         CALL cl_err3("upd","oeb_file",l_pmn.pmn24,"",SQLCA.sqlcode,"","upd oeb:",1)
       #         LET g_success='N'
       #         RETURN
       #      END IF
       #   END IF
       #END IF
       #-----END MOD-A50210-----
       IF NOT s_industry('std') THEN
          IF NOT s_del_pmni(l_pmn.pmn01,l_pmn.pmn02,'') THEN
             IF p_call_transaction THEN
                ROLLBACK WORK
             END IF
             CLOSE t540sub_cl
             LET g_success='N' RETURN
          END IF
       END IF
#      IF l_pmm.pmm909 <>'3' THEN    #TQC-730022    #MOD-B60102 mark
       IF l_pmm.pmm909 MATCHES '[128]' THEN         #MOD-B60102
       IF NOT cl_null(l_pmn.pmn24)  AND l_pmn.pmn24<> " " THEN            # 更新請購已轉採購量  #FUN-B90103--add-l_pmn.pmn24<> " "
          #MOD-BC0168 add --start--
          SELECT pml16 INTO l_pml16 
            FROM pml_file
           WHERE pml01=l_pmn.pmn24 AND pml02=l_pmn.pmn25
          #MOD-BC0168 add --end--
          SELECT SUM(pmn20/pmn62*pmn121) INTO l_qty FROM pmn_file
            WHERE pmn24=l_pmn.pmn24 AND pmn25=l_pmn.pmn25
              AND pmn16<>'9'        #取消(Cancel)
          IF STATUS OR cl_null(l_qty) THEN LET l_qty=0 END IF
          #MOD-BC0168 add --start--
          IF l_pmm.pmm909<>'8' THEN 
             IF l_pml16 NOT MATCHES '[678]' THEN 
                IF l_qty=0 THEN 
                   LET l_pml16 ='1'
                END IF
             END IF
             #MOD-BC0168 add --end--
             #FUN-910088--add--start--
               SELECT pml07 INTO l_pml07 FROM pml_file
                WHERE pml01=l_pmn.pmn24 AND pml02=l_pmn.pmn25
               LET l_qty = s_digqty(l_qty,l_pml07)   
             #FUN-910088--add--end--
              #IF l_qty=0 THEN                   # modi by kitty 96-05-24 #MOD-BC0168 mark
                 #UPDATE pml_file SET pml21=l_qty,pml16='1'     #MOD-BC0168 mark
                  UPDATE pml_file SET pml21=l_qty,pml16=l_pml16 #MOD-BC0168
                   WHERE pml01=l_pmn.pmn24 AND pml02=l_pmn.pmn25
              #MOD-BC0168 mark --start--
              #ELSE
              #   UPDATE pml_file SET pml21=l_qty
              #    WHERE pml01=l_pmn.pmn24 AND pml02=l_pmn.pmn25
              #END IF
              #MOD-BC0168 mark --end--
   #FUN-B90103---------------add----------------
             IF s_industry("slk") THEN
                IF g_azw.azw04='2' THEN     #FUN-C20006--add
                   SELECT pmlislk03 INTO l_pmlslk02 FROM pmli_file 
                     WHERE pmli01=l_pmn.pmn24 AND pmli02=l_pmn.pmn25   #請購單母料件項次
                               
                   SELECT SUM(pml21) INTO l_pmlslk21 FROM pml_file     #統計已轉請購數量
                     WHERE pml01=l_pmn.pmn24
                       AND pml02 IN(SELECT pml02 FROM pml_file,pmli_file
                                  WHERE pml01=pmli01
                                    AND pml02=pmli02
                                    AND pmlislk03=l_pmlslk02
                                    AND pmli01=l_pmn.pmn24)
                  UPDATE pmlslk_file SET pmlslk21=l_pmlslk21 WHERE pmlslk01=l_pmn.pmn24
                    AND pmlslk02=l_pmlslk02 
                END IF                     #FUN-C20006--add
             END IF  
   #FUN-B90103---------------end----------------
          #----- 當單身狀況碼皆為1時,update單頭狀況碼96-05-24
              UPDATE pmk_file SET pmk25='1'
               WHERE pmk01=l_pmn.pmn24 AND pmk01 NOT IN
               (SELECT pml01 FROM pml_file WHERE pml01=l_pmn.pmn24
                             AND pml16 <>'1')
                             AND pmk25 != '6' #MOD-BC0168 add
          END IF   #MOD-BC0168 add 
       END IF
       END IF   #TQC-730022
       IF NOT cl_null(l_pmn.pmn68) THEN            # 更新已轉Blanket量
          SELECT SUM(pmn20/pmn62*pmn70) INTO l_qty FROM pmn_file
            WHERE pmn68=l_pmn.pmn68 AND pmn69=l_pmn.pmn69
              AND pmn16<>'9'        #取消(Cancel)
          IF STATUS OR cl_null(l_qty) THEN LET l_qty=0 END IF
        #FUN-910088--add--start--
          SELECT pon07 INTO l_pon07 FROM pon_file
           WHERE pon01=l_pmn.pmn68 AND pon02=l_pmn.pmn69
          LET l_qty = s_digqty(l_qty,l_pon07)   
        #FUN-910088--add--end--
          IF l_qty=0 THEN                   # modi by kitty 96-05-24
             IF NOT s_industry('icd') THEN
                UPDATE pon_file SET pon21=l_qty,pon16='1'
                 WHERE pon01=l_pmn.pmn68 AND pon02=l_pmn.pmn69
             ELSE
                UPDATE pmni_file SET pmniicd13=l_qty
                 WHERE pmni01=l_pmn.pmn68 AND pmni02=l_pmn.pmn69
                UPDATE pmn_file SET pmn16='1'
                 WHERE pmn01=l_pmn.pmn68 AND pmn02=l_pmn.pmn69
             END IF
          ELSE
             IF NOT s_industry('icd') THEN
                UPDATE pon_file SET pon21=l_qty
                 WHERE pon01=l_pmn.pmn68 AND pon02=l_pmn.pmn69
             ELSE
                UPDATE pmni_file SET pmniicd13=l_qty
                 WHERE pmni01=l_pmn.pmn68 AND pmni02=l_pmn.pmn69
             END IF
          END IF
          #----- 當單身狀況碼皆為1時,update單頭狀況碼96-05-24
 
          IF NOT s_industry('icd') THEN
             UPDATE pom_file SET pom25='1'
              WHERE pom01=l_pmn.pmn68 AND pom01 NOT IN
              (SELECT pon01 FROM pon_file WHERE pon01=l_pmn.pmn68
                            AND pon16 <>'1')
          ELSE
          END IF
       END IF
    END FOREACH
 
    IF s_industry('icd') THEN
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt FROM ico_file
        WHERE ico01 = l_pmm.pmm01
       IF l_cnt > 0 THEN
          DELETE FROM ico_file WHERE ico01 = l_pmm.pmm01
       END IF
    END IF
 
    DELETE FROM pmz_file WHERE pmz01 = l_pmm.pmm01
    DELETE FROM pmo_file WHERE pmo01 = l_pmm.pmm01
    DELETE FROM pmp_file WHERE pmp01 = l_pmm.pmm01
    LET l_msg=TIME
    INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980006 add
       VALUES ('apmt540',g_user,g_today,l_msg,l_pmm.pmm01,'delete',g_plant,g_legal) #FUN-980006 add
 
    CLOSE t540sub_cl
    IF p_call_transaction THEN
       IF g_success='Y' THEN
          COMMIT WORK
       ELSE
          ROLLBACK WORK
       END IF
    END IF
    CALL cl_flow_notify(l_pmm.pmm01,'D')
 
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
#-----MOD-A50210---------
FUNCTION t540_upd_oeb28(l_cmd,l_pmn02,l_pmm01)
    DEFINE l_sql      STRING,
           l_oeb28    LIKE oeb_file.oeb28,
           l_oeb28_o  LIKE oeb_file.oeb28,   #MOD-C10218
           l_pmn02    LIKE pmn_file.pmn02,
           l_pmm01    LIKE pmm_file.pmm01,
           l_pmn20    LIKE pmn_file.pmn20,
           l_pmn24    LIKE pmn_file.pmn24,
           l_pmn25    LIKE pmn_file.pmn25,
           l_pmn42    LIKE pmn_file.pmn42,   #MOD-C30366
           l_pmn62    LIKE pmn_file.pmn62,   #MOD-C30366
           l_cmd      LIKE type_file.chr5,
           l_oeb27    LIKE oeb_file.oeb27,
           l_oeb12    LIKE oeb_file.oeb12,   #MOD-C10218
           l_msg      STRING                 #MOD-C10218

   LET l_pmn20 = 0
   LET l_pmn24 = ''
   LET l_pmn25 = ''
   LET l_sql = "SELECT pmn20,pmn24,pmn25,pmn42,pmn62 ",     #MOD-C30366 add pmn42,pmn62                    
                " FROM pmn_file ",   
                " WHERE pmn01= '",l_pmm01,"'",              
                "   AND pmn02= '",l_pmn02,"'"
   PREPARE t540_pmn_b FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE t540_pmn_bc CURSOR FOR t540_pmn_b
   OPEN t540_pmn_bc
   FETCH t540_pmn_bc INTO l_pmn20,l_pmn24,l_pmn25,l_pmn42,l_pmn62   #MOD-C30366 add l_pmn42,l_pmn62
   IF l_pmn42 = 'S' THEN                 #MOD-C30366 add
      LET l_pmn20 = l_pmn20/l_pmn62      #MOD-C30366 add
   END IF                                #MOD-C30366 add
   IF cl_null(l_pmn24) AND (cl_null(l_pmn25) OR l_pmn25=0) THEN 
      RETURN 
   END IF 
      LET l_oeb28 = 0
      SELECT SUM(pmn20) INTO l_oeb28 
        FROM pmn_file,pmm_file
       WHERE pmn24 = l_pmn24
         AND pmn25 = l_pmn25
         AND pmn01 = pmm01
         AND pmm18 <> 'X'
         AND pmn16 <> '9'
      IF cl_null(l_oeb28) THEN LET l_oeb28 = 0 END IF   
      SELECT oeb12 INTO l_oeb12 FROM oeb_file
       WHERE oeb01 = l_pmn24 AND oeb03 = l_pmn25        #MOD-C10218
   CASE
      WHEN l_cmd = 'z'
           LET l_oeb28_o = l_oeb28           #MOD-C10218 add
           LET l_oeb28 = l_oeb28 + l_pmn20  
           #MOD-C10218 -- add start --
           IF l_oeb28 > l_oeb12 THEN
              LET l_oeb28 = l_oeb28_o
              LET l_msg = l_pmm01,'-',l_pmn02,' '
               CALL cl_err(l_msg,'axm-615',1)
               LET g_success = 'N'
           END IF
           #MOD-C10218 -- add end --
      WHEN l_cmd <> 'b'
           LET l_oeb28 = l_oeb28 - l_pmn20   
   END CASE
   IF l_cmd MATCHES '[rdx]' THEN
      LET l_oeb27 = NULL
   ELSE
      LET l_oeb27 = l_pmm01
   END IF
   UPDATE oeb_file set oeb27 = l_oeb27,
                       oeb28 = l_oeb28
                 WHERE oeb01 = l_pmn24
                   AND oeb03 = l_pmn25
   IF SQLCA.sqlcode OR sqlca.sqlerrd[3]=0 THEN
      CALL cl_err3("upd","oeb_file",l_pmm01,"",SQLCA.sqlcode,"","NO pmm deleted from Order",0)
      LET g_success ='N'
      RETURN
   END IF
END FUNCTION
#-----END MOD-A50210-----


#DEV-D30045--add--begin
FUNCTION t540sub_barcode_gen(p_pmm01,p_ask)
   DEFINE p_pmm01   LIKE pmm_file.pmm01
   DEFINE p_ask     LIKE type_file.chr1
   DEFINE l_pmm     RECORD LIKE pmm_file.*
   DEFINE l_chr     LIKE type_file.chr1

   IF cl_null(p_pmm01) THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF

   SELECT * INTO l_pmm.* FROM pmm_file WHERE pmm01 = p_pmm01

   CASE
      WHEN g_prog[1,7] = "apmt540" LET l_chr = 'F'
      WHEN g_prog[1,7] = "apmt590" LET l_chr = 'G'
   END CASE

   #檢查是否符合產生時機點
   IF NOT s_gen_barcode_chktype(l_chr,l_pmm.pmm01,'','') THEN
      RETURN
   END IF

   IF l_pmm.pmm18 = 'N' THEN
      CALL cl_err('','sfb-999',0)
      LET g_success = 'N'
      RETURN
   END IF

   IF l_pmm.pmm18 = 'X' THEN
      CALL cl_err('','sfb-998',0)
      LET g_success = 'N'
      RETURN
   END IF

   IF NOT s_tlfb_chk(l_pmm.pmm01) THEN
      LET g_success = 'N'
      RETURN
   END IF

   IF p_ask = 'Y' THEN   
      IF NOT cl_confirm('azz1276') THEN
         LET g_success='N'
         RETURN
      END IF
   END IF

   LET g_success = 'Y'
   CALL s_showmsg_init()
   BEGIN WORK
   CALL t540sub_lock_cl()

   OPEN t540sub_cl USING l_pmm.pmm01
   IF STATUS THEN
      CALL cl_err("OPEN t540sub_cl:", STATUS, 1)
      LET g_success = 'N'
      CLOSE t540sub_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t540sub_cl INTO l_pmm.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_pmm.pmm01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      LET g_success = 'N'
      CLOSE t540sub_cl
      ROLLBACK WORK
      RETURN
   END IF

   #DEV-D30043--mark--begin
   #IF NOT s_diy_barcode(l_pmm.pmm01,'','',l_chr) THEN
   #   LET g_success = 'N'
   #END IF
 
   #IF g_success = 'Y' THEN
   #   CALL s_gen_barcode2(l_chr,l_pmm.pmm01,'','')
   #END IF
   #DEV-D30043--mark--end

   #DEV-D30043--add--begin
   IF g_success = 'Y' THEN
      CALL s_gen_barcode2(l_chr,l_pmm.pmm01,'','')
   END IF

   IF g_success = 'Y' THEN
      IF NOT s_diy_barcode(l_pmm.pmm01,'','',l_chr) THEN
         LET g_success = 'N'
      END IF
   END IF
   #DEV-D30043--add--end

   CALL s_showmsg()
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_msgany(0,0,'aba-001')
   ELSE
      ROLLBACK WORK
      #CALL cl_msgany(0,0,'aba-002')    #DEV-D40015--mark
      CALL cl_err('','aba-002',0)       #DEV-D40015--mod
   END IF
END FUNCTION

FUNCTION t540sub_barcode_z(p_pmm01)
   DEFINE p_pmm01   LIKE pmm_file.pmm01
   DEFINE l_pmm     RECORD LIKE pmm_file.*
   DEFINE l_srg02   LIKE srg_file.srg02
   DEFINE l_srg03   LIKE srg_file.srg03
   DEFINE l_srg05   LIKE srg_file.srg05
   DEFINE l_ima918  LIKE ima_file.ima918
   DEFINE l_ima919  LIKE ima_file.ima919
   DEFINE l_ima920  LIKE ima_file.ima920
   DEFINE l_ima921  LIKE ima_file.ima921
   DEFINE l_ima922  LIKE ima_file.ima922
   DEFINE l_ima923  LIKE ima_file.ima923
   DEFINE l_ima931  LIKE ima_file.ima931
   DEFINE l_ima933  LIKE ima_file.ima933
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_sql     STRING
   DEFINE l_chr     LIKE type_file.chr1

   IF cl_null(p_pmm01) THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF

   SELECT * INTO l_pmm.* FROM pmm_file WHERE pmm01 =p_pmm01 

   CASE
      WHEN g_prog[1,7] = "apmt540" LET l_chr = 'F'
      WHEN g_prog[1,7] = "apmt590" LET l_chr = 'G'
   END CASE

   #檢查是否符合產生時機點
   IF NOT s_gen_barcode_chktype(l_chr,l_pmm.pmm01,'','') THEN
      LET g_success  = 'Y'       #DEV-D40015 add
      RETURN
   END IF

   IF l_pmm.pmm18 = 'X' THEN
      CALL cl_err(' ','9024',0)
      LET g_success = 'N'
      RETURN
   END IF

   IF NOT s_tlfb_chk2(l_pmm.pmm01) THEN
      LET g_success = 'N'
      RETURN
   END IF

  #LET g_success = 'Y'           #DEV-D40015 mark
  #BEGIN WORK                    #DEV-D40015 mark
   CALL t540sub_lock_cl()

   OPEN t540sub_cl USING l_pmm.pmm01
   IF STATUS THEN
      CALL cl_err("OPEN t540sub_cl:", STATUS, 1)
      LET g_success = 'N'
      CLOSE t540sub_cl
     #ROLLBACK WORK              #DEV-D40015 mark
      RETURN
   END IF
   FETCH t540sub_cl INTO l_pmm.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_pmm.pmm01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      LET g_success = 'N'
      CLOSE t540sub_cl
     #ROLLBACK WORK              #DEV-D40015 mark
      RETURN
   END IF

   IF g_success='Y' THEN
      CALL s_barcode_x2(l_chr,l_pmm.pmm01,'','')
   END IF

   IF g_success='Y' THEN
     #COMMIT WORK                #DEV-D40015 mark
      CALL cl_msgany(0,0,'aba-178')
   ELSE
     #ROLLBACK WORK              #DEV-D40015 mark
      CALL cl_msgany(0,0,'aba-179')
   END IF
END FUNCTION
#DEV-D30045--add--end


#MOD-D90100 add begin---------
FUNCTION t540sub_y_chk_qty(l_pmm)

DEFINE l_pmm      RECORD LIKE pmm_file.*
DEFINE l_pmn      RECORD LIKE pmn_file.*

   DECLARE t540_pmn20_qty CURSOR FOR
   SELECT * FROM pmn_file                                                                                             
        WHERE pmn01=l_pmm.pmm01                                                                                                     
      FOREACH t540_pmn20_qty INTO l_pmn.*       
         IF t540sub_available_qty(l_pmn.pmn09*l_pmn.pmn20,l_pmn.pmn24,l_pmn.pmn25,l_pmn.pmn04,l_pmn.*) THEN 
            LET g_success = 'N'
            RETURN 
         END IF
      END FOREACH   


END FUNCTION



FUNCTION t540sub_available_qty(p_qty,p_pmn24,p_pmn25,p_item,l_pmn)
DEFINE   p_pmn24  LIKE  pmn_file.pmn24
DEFINE   p_pmn25  LIKE  pmn_file.pmn25
DEFINE   p_item   LIKE  pmn_file.pmn04
DEFINE   p_qty    LIKE  pmn_file.pmn20,
         l_pmn20  LIKE  pmn_file.pmn20,
         l_over   LIKE  type_file.num15_3,   
         l_ima07  LIKE  ima_file.ima07,
         l_ima25  LIKE  ima_file.ima25,
         l_pml20  LIKE  pml_file.pml20
DEFINE l_pmn      RECORD LIKE pmn_file.*         
 
   LET l_pmn20 = 0
   SELECT SUM(pmn20/pmn62*pmn09) INTO l_pmn20 FROM pmn_file
    WHERE pmn24=p_pmn24     #請購單
      AND pmn25=p_pmn25     #請購序號
      AND pmn16<>'9'        #取消(Cancel)
      AND pmn01<>l_pmn.pmn01
   IF STATUS OR cl_null(l_pmn20) THEN LET l_pmn20 = 0 END IF
 #----------------與請購互相勾稽 -------------------------------------
   SELECT ima07,ima25 INTO l_ima07,l_ima25 FROM ima_file  #select ABC code
    WHERE ima01=p_item
 
   SELECT pml20*pml09 INTO l_pml20 FROM pml_file
    WHERE pml01=p_pmn24
      AND pml02=p_pmn25
       
 
   LET l_pmn20 = s_digqty(l_pmn20,l_ima25)   
   LET l_pml20 = s_digqty(l_pml20,l_ima25)   
   IF cl_null(l_pml20) THEN LET l_pml20 = 0 END IF
   IF cl_null(g_sma.sma341) THEN LET g_sma.sma341 = 0 END IF
   IF cl_null(g_sma.sma342) THEN LET g_sma.sma342 = 0 END IF
   IF cl_null(g_sma.sma343) THEN LET g_sma.sma343 = 0 END IF
   CASE
   WHEN l_ima07='A'  #計算可容許的數量
        LET l_over=l_pml20 * (g_sma.sma341/100)
   WHEN l_ima07='B'
        LET l_over=l_pml20 * (g_sma.sma342/100)
   WHEN l_ima07='C'
        LET l_over=l_pml20 * (g_sma.sma343/100)
   OTHERWISE
        LET l_over=0
   END CASE
   IF p_qty+l_pmn20>    #本筆採購量+已轉採購量
      (l_pml20+l_over) THEN   #請購量+容許量
      CALL cl_err(p_qty||' '||l_ima25,'mfg3425',1)
      IF g_sma.sma33='R'    #reject
         THEN
         RETURN -1
      END IF
   END IF
   RETURN 0
END FUNCTION

#MOD-D90100 add end-----------

