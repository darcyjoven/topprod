# Prog. Version..: '5.30.06-13.04.24(00010)'     #
# Program name...: sapmt720_sub.4gl                                                                                                 
# Description....: 提供sapmt720.4gl使用的sub routine                                                                                
# Date & Author..: 10/02/05 by jan (FUN-A10130)
# Modify.........: No:MOD-A20094 10/02/24 By Smapmin 增加數量大於0的條件
# Modify.........: No:MOD-A40063 10/04/16 By Smapmin 更新ima91時,要以採購或計價單位為基準
# Modify.........: No:TQC-A40104 10/04/21 By Smapmin 修正MOD-940235
# Modify.........: No:FUN-A50001 10/05/04 By Lilan   EF整合:不為背景呼叫才執行ui
# Modify.........: No:TQC-A50034 10/05/12 By lilingyu OPEN ima_lock處sql筆誤
# Modify.........: No:FUN-A60027 10/06/12 by sunchenxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60076 10/06/25 By huangtao 製造功能優化-平行製程(批量修改)
# Modify.........: No.FUN-A50102 10/07/15 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A70097 10/07/27 By Smapmin 修改錯誤訊息顯示
# Modify.........: No:MOD-A70212 10/07/29 By Smapmin 倉退沒有考慮負庫存的問題
# Modify.........: No:MOD-A40166 10/07/30 By Smapmin 修改倉退時,倉庫一定要登打控管的時機點
# Modify.........: No:TQC-A60044 10/07/30 By Smapmin 修正MOD-A40166,數量為0還是要產生tlf
# Modify.........: No:FUN-A80026 10/08/11 By Carrier 入库单直接产生AP功能
# Modify.........: No:FUN-A80102 10/09/17 By kim GP5.25號機管理
# Modify.........: No:FUN-AA0007 10/10/14 By jan 批號hold，在庫存未入庫之前就先做hold的動作(feature hold) 
# Modify.........: No:MOD-AA0164 10/11/04 By Smapmin MISC料不影響庫存,故不需控卡要打倉庫
# Modify.........: No:MOD-AB0055 10/11/05 By lilingyu apmt111 JIT收貨時,點擊"查詢驗退",審核驗退單時,報錯:更新pmn_file失敗
# Modify.........: No.FUN-AB0058 10/11/08 By yinhy 审核段增加倉庫權限控管
# Modify.........: No.TQC-AC0287 10/12/18 By chenying按下確認功能鍵之後 自動產生暫估立帳,但產生失敗
# Modify.........: No.MOD-AC0333 10/12/27 By Carrier 重取smy74的值
# Modify.........: No.TQC-AC0277 10/12/28 By jan g_success給預設值
# Modify.........: No:MOD-B10171 11/01/24 By Summer 代採逆拋中斷點設在第0站,第0站手動打入庫單時無法帶收貨單的批序號資料
# Modify.........: No:CHI-B10047 11/01/27 By Smapmin 修正錯誤訊息顯示方式
# Modify.........: No:TQC-B20022 11/02/11 By lilingyu 審核時,未check"部門rvu06"欄位值,導致不存在的部門編號也可以審核通過
# Modify.........: No:FUN-AB0092 11/02/12 By jan 批號hold邏輯調整
# Modify.........: No:FUN-A60009 11/02/21 By Lilan EF整合:拆解為檢查段(chk)與確認段(upd)
# Modify.........: No:MOD-B30403 11/03/15 By chenying 修改多角贸易单据產生應付帳款的判斷
# Modify.........: No:MOD-B30556 11/03/17 By chenying 採購單入庫倉退時，收貨單數量有誤---->抓取rvv17時，需加上條件rvu116='2'
# Modify.........: No.MOD-B30545 11/03/18 By chenmoyan 當收貨單單頭的采購單號為空時,抓不到采購人員,導致aapp115拋轉失敗
# Modify.........: No.TQC-B30198 11/03/29 By lilingyu 採購單分批收貨入庫,在驗量pmn51計算有誤 
# Modify.........: No.FUN-B30161 11/03/30 By xianghui 原使用smy74的判斷，改用sma91,CALL aapp115前加判斷，IF sma92='Y' 時，才可執行
# Modify.........: No.MOD-B40007 11/04/01 By lilingyu 收貨作業在審核時,判斷批序號資料時條件寫錯
# Modify.........: No.TQC-B40020 11/04/06 By lilingyu 因32區相關字段未添加,導致r.c2失敗,暫還原FUN-B30161的修改部分
# Modify.........: No:MOD-B40078 11/04/18 By Summer 若是aooi150稅別資料需加串gec011='1'
# Modify.........: No:CHI-B40023 11/04/18 By Smapmin 更新料件成本要素資料時,若資料不存在則用新增的方式
# Modify.........: No:CHI-B40011 11/04/18 By Smapmin 多角採購入庫段加入考量自動拋轉的功能.
# Modify.........: No:TQC-B40148 11/04/19 By lilingyu 全部允收量已經全部入庫,此時手工新增一筆驗退量,仍然可以審核通過
# Modify.........: No:TQC-B40100 11/04/20 By Summer 拿掉tlf_file SQLCA.sqlcode的判斷
# Modify.........: No.FUN-B30161 11/05/23 By lixiang 還原TQC-B40020所改
# Modify.........: No.MOD-B50223 11/05/27 By JoHung 修改錯誤訊息
# Modify.........: No:CHI-AC0016 11/05/30 By Smapmin 若為運輸發票(gec05='T')時,稅額與未稅金額邏輯調整 
# Modify.........: No:MOD-B60036 11/06/03 By zhangll 修正apmt742沒有考慮批序號管理資料
# Modify.........: No:FUN-B30129 11/06/13 By wuxj  取消TQC-B20022控卡
# Modify.........: No:TQC-B60065 11/06/16 By shiwuying 增加虛擬類型rvu27
# Modify.........: No:TQC-B60085 11/06/20 By zhangweib 在審核時加上對人員欄位的檢查
# Modify.........: No:TQC-B60290 11/06/22 By zhangll 暂还原TQC-B40148修改内同
# Modify.........: No:TQC-B60252 11/06/22 By xjll  ma91='y'時，才可產生帳款，有發票執行aapp110，沒發票的判斷sma92='y'執行aapp115，否則不執行
# Modify.........: No.FUN-B30187 11/06/29 By jason ICD功能修改，增加母批、DATECODE欄位 
# Modify.........: No:MOD-B40219 11/07/19 By sabrina imb_file少加四個欄位
# Modify.........: No.TQC-B80005 11/08/03 By jason 新增ICD行業別rvbi條件,s_icdpost函數傳入參數
# Modify.........: No:MOD-B80041 11/08/04 By johung 還原MOD-B40007修改
# Modify.........: No:MOD-B80097 11/08/09 By johung mark t720_gen_ap()中 TQC-B60252的判斷
# Modify.........: No:MOD-B80272 11/09/03 By johung 修改串t720_gen_ap的判斷式
# Modify.........: No.FUN-B80119 11/09/14 By fengrui  增加調用s_icdpost的p_plant參數
# Modify.........: NO:FUN-B90012 11/09/23 By fengrui 修改g_argv3值為'TAP'的處理
# Modify.........: No.FUN-B90104 11/11/29 By huangrh GP5.3服飾版本開發
# Modify.........: No:TQC-BC0075 11/12/16 By suncx 更新sfa_file問題處理
# Modify.........: NO:MOD-B90265 11/12/27 By Summer s_icdchk的第一個參數改為跟s_icdpost一樣用l_type去傳入出庫類別 
# Modify.........: NO:MOD-BB0034 11/12/27 By Summer 確認段自動產生帳款,請直接增加判斷異動類別為入庫單才CALL t720_gen_ap 
# Modify.........: No:FUN-BB0083 11/12/28 By xujing 增加數量欄位小數取位 sfh_file
# Modify.........: No.FUN-BA0051 12/01/02 By jason 一批號多DATECODE功能
# Modify.........: No.FUN-BB0001 12/01/11 By pauline 新增rvv22,INSERT/UPDATE rvb22時,同時INSERT/UPDATE rvv22
# Modify.........: No.TQC-B90236 12/01/11 By zhuhao 原執行s_lotin程式段，改為s_mod_lot,INSERT INTO rvbs_file的程式段 增加判斷
# Modify.........: No:FUN-BB0086 12/01/14 By tanxc 增加數量欄位小數取位 
# Modify.........: NO.FUN-BC0104 12/01/18 By xianghui 數量異動回寫qco20
# Modify.........: NO.FUN-BC0104 12/01/31 By xujing 增加入庫單驗退更新rvv46,rvv47
# Modify.........: NO.FUN-C20064 12/02/13 By xujing 增加撈出SUM(rvv87)
# Modify.........: NO.FUN-BC0062 12/02/15 By lilingyu 當成本計算方式czz28選擇了'6.移動加權平均成本'時,不可進行單據類過賬還原的動作
# Modify.........: NO:TQC-BB0088 12/02/23 by destiny 更新rvbs_file时未考虑apmt111的情况
# Modify.........: No:MOD-B90095 12/03/07 By Summer 入庫單按自動產生應付帳款Action未自動產生帳款 
# Modify.........: No:TQC-C30193 12/03/14 By jason for ICD:TKY工單完工數量應以委外收貨單最終站 收貨數量+不良數+報廢數 + 其它站 不良數+報廢數
# Modify.........: No:MOD-C30471 12/03/15 By zhuhao l_sma131給值
# Modify.........: No:CHI-C30064 12/03/15 By Sakura 程式有用到"aim-011"訊息的地方，改用料倉儲批抓庫存單位(img09)換算
# Modify.........: No:MOD-C30507 12/03/16 By linlin  入庫單確認時,增加判斷是否有控卡批號
# Modify.........: No:MOD-BC0057 12/03/21 By Vampire 控卡倉退日期必須大於入庫日期
# Modify.........: No:MOD-BC0059 12/03/21 By Vampire 錯誤訊息調整
# Modify.........: No:FUN-C30307 12/03/30 By bart 不管是否為TKY不良和報廢都要入完工數量
# Modify.........: No:CHI-C30118 12/04/06 By Sakura 參考來源單號CHI-C30106,批序號維護修改
# Modify.........: No.TQC-C30225 12/04/06 By SunLM 若為運輸發票(gec05='T')時,未稅單價邏輯調整
# Modify.........: No:CHI-C40016 12/04/17 By Sakura 還原CHI-C30118修改,將app-017錯誤訊息那段往上移至FUNCTION t720sub_y_chk一開始處
# Modify.........: No.TQC-C50062 12/05/09 By Sarah FOR ICD:只有當CP時,比較idd數量與入庫單身數量時,應以良品數(idd13)+不良品數(idd26)來比較才對
# Modify.........: No:MOD-BC0262 12/05/11 By Vampire apmt722 單頭有稅別資料時，應以單頭輸入的為主
# Modify.........: No:MOD-C50248 12/05/30 By Summer 產品有取替代時,單位不同會抓不到替代料
# Modify.........: No:MOD-C30074 12/06/07 By Vampire 收貨無批序號管理，驗退單即可免輸入批序號，增加判斷sma90
# Modify.........: No:MOD-C40098 12/06/07 By Vampire 排除入庫時料件編號有做批序號時，仍需控卡數量
# Modify.........: No:FUN-C30166 12/06/14 By bart 控卡不可大於工單備料檔的已發+代買量，以最小套數算
# Modify.........: No:CHI-C60028 12/06/27 By bart 確認時會卡住需維護BIN刻號資料
# Modify.........: No.FUN-C70098 12/07/24 By xjll  服飾流通二維，不可審核數量為零的母單身資料
# Modify.........: No.FUN-C70087 12/08/03 By bart 整批寫入img_file
# Modify.........: No.TQC-C80093 12/08/14 By zhuhao 審核時彈出審核頁簽的位置
# Modify.........: No:MOD-C80049 12/09/27 By Vampire 收貨單自動入庫的則不直接CALL t720sub_ecm串報工單，整個Transaction結束之後再串
# Modify.........: No:TQC-CA0028 12/10/11 By bart 離開程式前要drop temp table
# Modify.........: No:TQC-CA0049 12/10/17 By yuhuabao 如果是分批檢驗的,只能將審核過的批序號資料入庫
# Modify.........: No:CHI-CB0041 12/11/22 By bart 修改TQC-CA0028
# Modify.........: No:CHI-CC0007 12/12/06 By Summer 代採逆拋有中斷點情況,中斷點倉退單判斷未有前站銷退單多角序號不可確認 
# Modify.........: No:FUN-CB0087 12/12/10 By qiull 庫存單據理由碼改善
# Modify.........: No.FUN-CC0013 13/01/15 By Lori aqci106移除性質3.驗退/重工(qcl05=3)選項
# Modify.........: No:FUN-CC0095 13/01/16 By bart 修改整批寫入img_file
# Modify.........: No.FUN-D10063 13/01/17 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today
# Modify.........: No.FUN-D20078 13/02/26 By xujing rvu00='3'的情况,调整异动码tlf13:1)非委外,tlf13='apmt1072'
#                                                                                   2)委外非代买,tlf13='asft6201'
#                                                                                   3)委外代买,tlf13='apmt230'
# Modify.........: No.FUN-D10128 13/02/26 By SunLM 若為農業發票(gec05='A')時,未稅單價邏輯調整
# Modify.........: No.TQC-D30002 13/03/01 By xujing 處理委外倉退問題
# Modify.........: No:MOD-CC0062 13/03/04 By Elise 價格折讓可不須輸入數量與倉儲批
# Modify.........: No:MOD-CA0181 13/03/05 By jt_chen 入庫單確認會詢問apm-270是否將剩餘為入庫量轉為驗退單,選是時,當有走IQC時增加判斷驗退量為0不產生驗退單
# Modify.........: No:MOD-D30083 13/03/08 By Elise (1) apm1067控卡處排除退貨方式為3.折讓
#                                                  (2) mfg1401若倉儲批都為空時不需彈出詢問訊息  
# Modify.........: No:FUN-D30024 13/03/13 By lixh1 負庫存依據imd23判斷
# Modify.........: No.MOD-D30122 13/03/14 By Elise 折讓時不控卡aim-034
# Modify.........: No:MOD-CB0229 13/03/14 By jt_chen 倉退單不需檢核(l_rvv.rvv17 * l_rvv35_fac)是否等於l_rvbs06
# Modify.........: No:MOD-D20109 13/03/15 By Vampire FUN-D10063只針對ima_file調整,不須調整imb_file,且不該更新imadate
# Modify.........: No.DEV-D30026 13/03/20 By Nina GP5.3 追版:DEV-CB0003、DEV-D20002為GP5.25 的單號
# Modify.........: No:DEV-D30045 13/04/01 By TSD.JIE 
#                  1.條碼產生時機點相關程式-增加"條碼查詢"
#                  2.條碼產生時機點相關程式-增加"條碼列印"
#                  3.條碼產生時機點相關程式-增加"條碼產生"
#                  3.調整確認自動產生barcode
#                  4.調整取消確認自動作廢barcode
# Modify.........: No.DEV-D30040 13/04/01 By Nina 批序號相關程式,當料件使用條碼時(ima930 = 'Y'),確認時,
#                                                 若未輸入批序號資料則不需控卡單據數量與批/序號總數量是否相符 
#                                                 ex:單據數量與批/序號總數量不符，請檢查資料！(aim-011)
# Modify.........: No.DEV-D30059 13/04/01 By Nina 批序號相關程式,當料件使用條碼時(ima930 = 'Y'),輸入資料時,
#                                                 不要自動開批序號的Key In畫面(s_mod_lot)
# Modify.........: No.MOD-D40032 13/04/09 By Elise 增加判斷多角入庫單
# Modify.........: No.DEV-D40015 13/04/17 By Nina (1)aimi100有勾選使用條碼&條碼產生時機='E'，確認前，
#                                                    將產生條碼段移至確認chk段前，並CALL s_ibb_ins_rvbs寫入rvbs_file
#                                                 (2)若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，需控卡不可直接確認or過帳
# Modify.........: No.MOD-D40099 13/04/17 By Lori 1.CALL aapp115新增一參數l_purchas_sw;當suv<>'SUB'時傳'1',否則傳'2'
# Modify.........: No.DEV-D30043 13/04/17 By TSD.JIE 調整條碼自動編號(s_gen_barcode2)與條碼手動編號(s_diy_barcode)產生先後順序
# Modify.........: No.DEV-D40020 13/04/23 By Mandy #收貨時有做掃瞄,則入庫不需再掃瞄
# Modify.........: No.MOD-D60109 13/06/13 By SunLM 如果是misc料件，则不进行判断仓库
# Modify.........: No.FUN-D60103 13/06/28 By lixh1 已經結案的委外工單也可以進行委外倉退
# Modify.........: No:FUN-D40103 13/05/08 By lixh1 增加儲位有效性檢查
# Modify.........: No:MOD-D60078 13/06/13 By SunLM 理由码检查,将after field rvv26的那段检查逻辑复制到审核段检查段。
# Modify.........: No.TQC-D80008 13/08/07 By lixh1 調整單價計算邏輯
# Modify.........: No.TQC-D80017 13/08/12 By lixh1 apmt742 多角銷退時使用進項稅率
# Modify.........: No.FUN-D70021 13/08/26 By yangtt aapp115增加传入参数"MISC料号是否立帳"g_a='N'
# Modify.........: No.FUN-D60083 13/08/26 By yangtt aapp115增加传入参数"非成本倉是否立賬"g_b='N'
# Modify.........: No.160523 16/05/23 By guanyao 委外入库生成杂发单，并自动审核过账，并改程序为sapmt720_sub_1

DATABASE ds

#GLOBALS "../../config/top.global"  #mark by guanyao160523
#GLOBALS "../../aba/4gl/barcode.global" #No:DEV-D30026--add#mark by guanyao160523
GLOBALS "../../../tiptop/config/top.global"  #add by guanyao160523
GLOBALS "../../../tiptop/aba/4gl/barcode.global" #No:DEV-D30026--add #add by guanyao160523

#FUN-CC0095---begin
GLOBALS
   DEFINE g_padd_img       DYNAMIC ARRAY OF RECORD
                     img01 LIKE img_file.img01,
                     img02 LIKE img_file.img02,
                     img03 LIKE img_file.img03,
                     img04 LIKE img_file.img04,
                     img05 LIKE img_file.img05,
                     img06 LIKE img_file.img06,
                     img09 LIKE img_file.img09,
                     img13 LIKE img_file.img13,
                     img14 LIKE img_file.img14,
                     img17 LIKE img_file.img17,
                     img18 LIKE img_file.img18,
                     img19 LIKE img_file.img19,
                     img21 LIKE img_file.img21,
                     img26 LIKE img_file.img26,
                     img27 LIKE img_file.img27,
                     img28 LIKE img_file.img28,
                     img35 LIKE img_file.img35,
                     img36 LIKE img_file.img36,
                     img37 LIKE img_file.img37
                           END RECORD

   DEFINE g_padd_imgg      DYNAMIC ARRAY OF RECORD
                    imgg00 LIKE imgg_file.imgg00,
                    imgg01 LIKE imgg_file.imgg01,
                    imgg02 LIKE imgg_file.imgg02,
                    imgg03 LIKE imgg_file.imgg03,
                    imgg04 LIKE imgg_file.imgg04,
                    imgg05 LIKE imgg_file.imgg05,
                    imgg06 LIKE imgg_file.imgg06,
                    imgg09 LIKE imgg_file.imgg09,
                    imgg10 LIKE imgg_file.imgg10,
                    imgg20 LIKE imgg_file.imgg20,
                    imgg21 LIKE imgg_file.imgg21,
                    imgg211 LIKE imgg_file.imgg211,
                    imggplant LIKE imgg_file.imggplant,
                    imgglegal LIKE imgg_file.imgglegal
                            END RECORD
END GLOBALS
#FUN-CC0095---end
#{
#作用:lock cursor
#回傳值:無
#}
FUNCTION t720sub_lock_cl()
   DEFINE l_forupd_sql STRING
   LET l_forupd_sql = "SELECT * FROM rvu_file WHERE rvu01 = ? FOR UPDATE"
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE t720sub_cl CURSOR FROM l_forupd_sql
END FUNCTION

#p_inTransaction : IF p_inTransaction=FALSE 會在程式中呼叫BEGIN WORK
#p_ask_post : IF p_ask_post=TRUE 會詢問"是否執行過帳"
#p_argv1 : 異動狀況  p_argv2 :驗收單號 p_argv3 : 參數-3(性質)
#p_chr : 單據性質
#FUN-A60009 mark str -----------------------------------------------
#FUNCTION t720sub_y(p_rvu01,p_argv1,p_argv2,p_argv3,p_chr,p_inTransaction,p_ask_post)
#  DEFINE  l_a     LIKE type_file.chr1 
#  DEFINE  l_cmd   LIKE type_file.chr1000 
#  DEFINE  l_cnt   LIKE type_file.num5 
#  DEFINE  l_rva99 LIKE rva_file.rva99,
#          p_poz01 LIKE poz_file.poz01,
#          p_poz18 LIKE poz_file.poz18,
#          p_poz19 LIKE poz_file.poz19
#  DEFINE l_rvv36  LIKE rvv_file.rvv36
#  DEFINE l_rvv37  LIKE rvv_file.rvv37
#  DEFINE l_pmn16  LIKE pmn_file.pmn16
#  DEFINE l_status LIKE type_file.chr1
#  DEFINE l_rvv02    LIKE rvv_file.rvv02
#  DEFINE l_rvv32    LIKE rvv_file.rvv32
#  DEFINE l_rvv33    LIKE rvv_file.rvv33
#  DEFINE lj_result  LIKE type_file.chr1
#  DEFINE l_sma131   LIKE sma_file.sma131
#  DEFINE l_pmm02    LIKE pmm_file.pmm02 
#  DEFINE l_poy04  LIKE poy_file.poy04 
#  DEFINE l_azp03  LIKE azp_file.azp03 
#  DEFINE l_gen02  LIKE gen_file.gen02
#  DEFINE l_rvucont LIKE rvu_file.rvucont 
#  DEFINE p_dbs_tra       LIKE azw_file.azw05 
#  DEFINE p_plant_new     LIKE azp_file.azp01 
#  DEFINE p_plant         LIKE azp_file.azp01 
#  DEFINE l_sfb93         LIKE sfb_file.sfb93 
#  DEFINE p_argv1  LIKE rvu_file.rvu00
#  DEFINE p_argv2  LIKE rvu_file.rvu02
#  DEFINE p_argv3  LIKE rvu_file.rvu08
#  DEFINE l_rvu       RECORD LIKE rvu_file.*
#  DEFINE p_rvu01     LIKE rvu_file.rvu01
#  DEFINE l_yy,l_mm   LIKE type_file.num5
#  DEFINE p_inTransaction LIKE type_file.num5 
#  DEFINE p_ask_post  LIKE type_file.chr1
#  DEFINE l_icq       LIKE type_file.chr1
#  DEFINE p_chr       LIKE type_file.chr1
#  DEFINE l_sql       STRING
#  DEFINE l_rva00     LIKE rva_file.rva00
#  DEFINE l_rvv18     LIKE rvv_file.rvv18
#  DEFINE l_rvv17     LIKE rvv_file.rvv17   #MOD-A40166
#  DEFINE l_rvv31     LIKE rvv_file.rvv31   #MOD-AA0164
#  DEFINE l_smy74     LIKE smy_file.smy74   #No.MOD-AC0333
#  DEFINE l_smyslip   LIKE smy_file.smyslip #No.MOD-AC0333
#
#  WHENEVER ERROR CONTINUE                #忽略一切錯誤
#  #TQC-AC0277--begin--add----
#  IF NOT p_inTransaction THEN
#     LET g_totsuccess='Y'
#     LET g_success = 'Y'
#  END IF
#  #TQC-AC0277--end--add-----
#  SELECT sma131 INTO l_sma131 FROM sma_file WHERE sma00 = '0'
#  SELECT * INTO l_rvu.* FROM rvu_file WHERE rvu01=p_rvu01
#  SELECT rva00 INTO l_rva00 FROM rva_file WHERE rva01 = l_rvu.rvu02
#  
#  IF (p_argv1 = '5') AND ( p_ask_post='Y') THEN
#     CALL cl_msg( 'rvu_file:t720_y()')
#
#     IF g_bgjob='N' OR cl_null(g_bgjob) THEN    #FUN-A50001 add
#       CALL ui.Interface.refresh()
#     END IF                                     #FUN-A50001 add
#  END IF
#
#  IF s_shut(0) THEN LET g_success = 'N' RETURN END IF
#
##TQC-B20022 --begin--
#  CALL t720_rvu06_check(l_rvu.rvu06)
#  IF NOT cl_null(g_errno) THEN 
#     CALL cl_err(l_rvu.rvu06,g_errno,0)
#     LET g_success = 'N'
#     RETURN 
#  END IF 
##TQC-B20022 --end--
#
#  # 考慮免檢收貨call 入庫確認
#  IF p_argv1='5' THEN
#     SELECT rvu_file.* INTO l_rvu.*
#       FROM rvu_file
#      WHERE (rvu00 = '1' OR rvu00 = '3')
#        AND rvu02 = p_argv2
#        AND rvuconf != 'X'     #No:MOD-850156 add
#     IF SQLCA.SQLCODE THEN
#        CALL cl_err3("sel","rvu_file","","",SQLCA.sqlcode,"","sel rvu",1)
#        LET g_success = 'N' RETURN
#     END IF
#  END IF
#
#  IF p_argv1='6' THEN
#     SELECT rvu_file.* INTO l_rvu.*
#       FROM rvu_file
#      WHERE rvu01 = p_argv2
#     IF SQLCA.SQLCODE THEN
#        CALL cl_err3("sel","rvu_file","","",SQLCA.sqlcode,"","sel rvu",1)
#        LET g_success = 'N' RETURN
#     END IF
#  END IF
#
#  #無單身資料不可確認
#  LET l_cnt=0
#  SELECT COUNT(*) INTO l_cnt
#    FROM rvv_file
#   WHERE rvv01=l_rvu.rvu01
#  IF l_cnt=0 OR l_cnt IS NULL THEN
#     CALL cl_err('','mfg-009',1)
#     LET g_success = 'N' RETURN
#  END IF
#
#  DECLARE t720_rvv36 CURSOR FOR
#      #SELECT rvv36,rvv37 FROM rvv_file WHERE rvv01 = l_rvu.rvu01   #MOD-A40166
#      SELECT rvv36,rvv37,rvv02,rvv17,rvv32,rvv31 FROM rvv_file WHERE rvv01 = l_rvu.rvu01   #MOD-A40166   #MOD-AA0164 add rvv31
#
#  #FOREACH t720_rvv36 INTO l_rvv36,l_rvv37   #MOD-A40166
#  FOREACH t720_rvv36 INTO l_rvv36,l_rvv37,l_rvv02,l_rvv17,l_rvv32,l_rvv31   #MOD-A40166   #MOD-AA0164 add rvv31
#     #-----MOD-A40166---------
#     IF l_rvu.rvu00='3' AND l_rvv17>0 AND cl_null(l_rvv32) AND  
#        l_rvv31[1,4] <> 'MISC' THEN   #MOD-AA0164
#        CALL cl_err(l_rvv02,'apm1023',0)
#        LET g_success = 'N'
#        RETURN
#     END IF
#     #-----END MOD-A40166-----
#     IF STATUS THEN
#        CALL cl_err('foreach:',SQLCA.sqlcode,0)
#        RETURN
#     END IF
#
#     SELECT pmn16 INTO l_pmn16 FROM pmn_file
#       WHERE pmn01 = l_rvv36
#         AND pmn02 = l_rvv37
#     IF l_pmn16 != '2' AND l_rvu.rvu00<>'3' THEN 
#        #CALL cl_err('','mfg3166',1)   #CHI-B10047
#        CALL cl_err_msg("","apm1054",l_rvv36 CLIPPED|| "|" || l_rvv37 CLIPPED,0)   #CHI-B10047
#        LET g_success = 'N' 
#        RETURN
#     END IF
#  END FOREACH
#
#  DECLARE t720_rvv32 CURSOR FOR
#   SELECT rvv02,rvv32,rvv33 FROM rvv_file WHERE rvv01 = l_rvu.rvu01
#  CALL s_showmsg_init()
#  FOREACH t720_rvv32 INTO l_rvv02,l_rvv32,l_rvv33 
#     IF STATUS THEN
#        CALL cl_err('foreach:',SQLCA.sqlcode,0)
#        LET g_success = 'N' RETURN
#     END IF
#     #No.FUN-AB0058  --Begin
#     IF NOT s_chk_ware(l_rvv32) THEN
#        LET g_success = 'N' RETURN
#     END IF
#     #No.FUN-AB0058  --End 
#     CALL s_incchk(l_rvv32,l_rvv33,g_user) 
#          RETURNING lj_result
#     IF NOT lj_result THEN
#        LET g_totsuccess = 'N'  #TQC-AC0277
#        LET g_showmsg = l_rvv02,"/",l_rvv32,"/",l_rvv33,"/",g_user
#        CALL s_errmsg('rvv02,rvv32,rvv33,inc03',g_showmsg,'','asf-888',1)
#     END IF
#    #CALL s_showmsg()        #TQC-AC0277
#    #IF g_success = 'N' THEN #TQC-AC0277
#    #   RETURN               #TQC-AC0277
#    #END IF                  #TQC-AC0277
#  END FOREACH
#  #TQC-AC0277--begin--add----
#  CALL s_showmsg() 
#  IF g_totsuccess = 'N' THEN
#     LET g_success = 'N'
#     RETURN 
#  END IF
#  #TQC-AC0277--end--add---
#
#  IF cl_null(l_rvu.rvu01) THEN
#     CALL cl_err('',-400,1)
#     LET g_success = 'N' RETURN
#  END IF
#
#  IF l_rvu.rvuconf = 'Y' THEN
#     CALL cl_err('','9023',1)
#     LET g_success = 'N' RETURN
#  END IF
#
#  IF l_rvu.rvuconf = 'X' THEN
#     CALL cl_err('','9024',1)
#     LET g_success = 'N' RETURN
#  END IF
#
#  IF g_sma.sma53 IS NOT NULL AND l_rvu.rvu03 <= g_sma.sma53 THEN
#     CALL cl_err('','mfg9999',1)
#     LET g_success = 'N' RETURN
#  END IF
#
#  CALL s_yp(l_rvu.rvu03) RETURNING l_yy,l_mm
#
#  IF (l_yy*12+l_mm)>(g_sma.sma51*12+g_sma.sma52)THEN #不可大於現行年月
#     CALL cl_err('','mfg6091',1)
#     LET g_success = 'N' RETURN #TQC-AC0277
#  END IF
#
#  IF p_argv3='SUB' THEN
#     LET l_cnt=0
#     SELECT COUNT(*) INTO l_cnt
#       FROM rvu_file,rvv_file,sfb_file
#      WHERE rvv01=rvu01
#        AND sfb01=rvv18
#        AND sfb04='8'
#        AND rvu01=l_rvu.rvu01
#     IF l_cnt>0 THEN
#        CALL cl_err('','asf-070',1)
#        LET g_success = 'N' RETURN
#     END IF
#  END IF
#
#  IF g_azw.azw04 = '2' THEN
#     IF g_prog='apmt742' THEN
#        CALL t720sub_rvu04(l_rvu.rvu04,l_rvu.rvuplant)
#        IF NOT cl_null(g_errno) THEN
#           CALL cl_err(l_rvu.rvu04,g_errno,0)
#           RETURN
#        END IF
#     END IF
#  END IF
#  
#  IF NOT p_argv1 MATCHES '[56]' THEN  #收貨免檢:驗收確認不再詢問 
#     IF p_ask_post='Y' THEN
#        IF NOT cl_confirm('aap-017') THEN
#           LET g_success = 'N' RETURN
#        END IF
#      END IF
#  END IF
#  IF NOT p_inTransaction THEN
#      BEGIN WORK
#  END IF
#
#  LET g_success = 'Y'
#  LET l_icq='Y'
#
#  CALL t720sub_lock_cl()
#  
#  OPEN t720sub_cl USING l_rvu.rvu01
#  IF STATUS THEN
#     CALL cl_err("OPEN t720sub_cl:", STATUS, 1)
#     CLOSE t720sub_cl
#     IF NOT p_inTransaction THEN ROLLBACK WORK END IF
#     LET g_success = 'N' RETURN
#  END IF
#
#  FETCH t720sub_cl INTO l_rvu.*          #鎖住將被更改或取消的資料
#  IF SQLCA.sqlcode THEN
#     CALL cl_err(l_rvu.rvu01,SQLCA.sqlcode,0)      #資料被他人LOCK
#     CLOSE t720sub_cl
#     IF NOT p_inTransaction THEN ROLLBACK WORK END IF
#     LET g_success = 'N' RETURN
#  END IF
#
#  #更新單頭確認碼
#  LET l_rvucont=TIME
#  IF g_success='Y' THEN
#     UPDATE rvu_file SET rvuconf = 'Y',
#                         rvuconu = g_user,
#                         rvucond = g_today,
#                         rvucont = l_rvucont
#                   WHERE rvu01 = l_rvu.rvu01
#  END IF
#
#  IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd rvuconf',status,1)
#     LET g_success='N'
#  ELSE
#     #若為中斷點入庫單回寫對應收貨單的流程序號
#     IF l_rvu.rvu08 = 'TAP' OR l_rvu.rvu08 = 'TRI' THEN
#       SELECT rva99,poz01,poz18,poz19 INTO l_rva99,p_poz01,p_poz18,p_poz19
#         FROM poz_file,rva_file,rvb_file,pmm_file
#        WHERE poz01 = pmm904
#          AND pmm01 = rvb04
#          AND rvb01 = rva01
#          AND rva01 = l_rvu.rvu02
#        LET l_cnt = 0
#        IF p_poz19 = 'Y'  AND g_plant=p_poz18 THEN    #已設立中斷點
#           SELECT COUNT(*) INTO l_cnt   #check poz18設定的中斷營運中心是否存在單身設>
#             FROM poy_file
#           WHERE poy01 = p_poz01
#             AND poy04 = p_poz18
#       END IF
#       IF l_cnt > 0 THEN
#           IF g_success='Y' THEN
#              LET l_rvu.rvu20 = 'Y'
#              IF l_rvu.rvu00 = '3' THEN    #TQC-A40104
#                 SELECT poy04 INTO l_poy04
#                   FROM poy_file
#                  WHERE poy01 = p_poz01 
#                    AND poy02 = (SELECT MAX(poy02) FROM poy_file WHERE poy01 = p_poz01)
#                 
#                 LET l_azp03 = s_getdbs_curr(l_poy04)
#                 
#                #FUN-A50102 ------------------mark start----------------------  
#                #LET g_plant_new = l_poy04
#                #CALL s_getdbs()
#                #LET l_azp03 = g_dbs_new
#                #LET p_plant_new = g_plant_new
#                #CALL s_gettrandbs()
#                #LET p_dbs_tra = g_dbs_tra
#                #FUN-A50102 -----------------mark end------------------------- 
#                 
#                 LET l_sql = "SELECT oha99 ",  
#                           # "  FROM ",p_dbs_tra CLIPPED,"oha_file, ",               #FUN-A50102 mark
#                           #           p_dbs_tra CLIPPED,"ohb_file, ",               #FUN-A50102 mark
#                           #           p_dbs_tra CLIPPED,"oga_file  ",               #FUN-A50102 mark 
#                             "  FROM ",cl_get_target_table(l_poy04,'oha_file'),",",  #FUN-A50102
#                                       cl_get_target_table(l_poy04,'ohb_file'),",",  #FUN-A50102
#                                       cl_get_target_table(l_poy04,'oga_file'),      #FUN-A50102 
#                             " WHERE oha01 = ohb01 AND ohb31 = oga01 ", 
#                             "   AND oga99 = ? "
#                #CALL cl_parse_qry_sql(l_sql,p_plant_new) RETURNING l_sql
#                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
#                 CALL cl_parse_qry_sql(l_sql,l_poy04) RETURNING l_sql       #FUN-A50102
#                 PREPARE t720_p1 FROM l_sql 
#                 DECLARE t720_c1 CURSOR FOR t720_p1
#                 OPEN  t720_c1 USING l_rva99
#                 FETCH t720_c1 INTO l_rvu.rvu99
#              ELSE   #TQC-A40104
#                 LET l_rvu.rvu99 = l_rva99   #TQC-A40104 
#              END IF   #TQC-A40104
#
#              UPDATE rvu_file SET rvu99 = l_rvu.rvu99,
#                                  rvu20 = l_rvu.rvu20
#               WHERE rvu01 = l_rvu.rvu01
#              IF STATUS OR sqlca.sqlerrd[3]=0 THEN
#                 CALL cl_err3("upd","rvu_file",l_rvu.rvu01,"",SQLCA.sqlcode,"","update rvu99",1)
#                 LET g_success='N'
#              END IF
#              IF cl_null(l_rva99) THEN LET g_success='N' END IF
#           END IF
#       END IF
#     END IF
#
#     IF s_industry('icd') THEN
#        IF g_success = 'Y' THEN
#           #委外tky收貨單入庫後的正確性檢查
#            CALL t720sub_ind_icd_chk_tky(l_rvu.*,p_argv3)
#           #委外tky非最終站收貨項次的數量更新
#            CALL t720sub_ind_icd_tky_upd_rvb('y',p_argv3,l_rvu.*,p_argv1)
#        END IF
#     END IF
#
#     IF p_argv1 <> '6' THEN 
#        IF l_rvu.rvu00='1' AND l_rvu.rvu02 IS NOT NULL AND g_success='Y'
#           AND g_qcz.qcz05='Y' THEN
#           LET l_cnt = 0
#           SELECT COUNT(*) INTO l_cnt FROM qcs_file
#            WHERE qcs01=l_rvu.rvu02    #驗收單號
#              AND qcs14='Y'            #確認碼
#              AND qcs09<>'2'           #1.合格 2.退貨 3.特採
#           IF l_cnt>0 THEN
#              CALL t720sub_IQC_return2(l_rvu.*,l_rva00) #將剩餘未入庫量轉為'驗退單'
#           END IF
#        END IF
#     END IF
#     IF g_success='Y' THEN
#        CALL t720sub_s1(l_rvu.*,p_argv3,p_argv1,l_rva00)
#     END IF
#  END IF
#
#    IF g_success = 'Y' THEN
#       IF NOT p_inTransaction THEN COMMIT WORK END IF
#       CALL cl_flow_notify(l_rvu.rvu01,'Y')
#       LET l_rvu.rvuconf='Y'
#       LET l_rvu.rvuconu = g_user
#       LET l_rvu.rvucond = g_today
#       LET l_rvu.rvucont = l_rvucont
#    ELSE
#       IF NOT p_inTransaction THEN ROLLBACK WORK END IF
#       LET l_rvu.rvuconf='N'
#    END IF
#    
#  IF p_argv1 <> '6' THEN 
#     IF l_rvu.rvu00='1' AND l_rvu.rvu02 IS NOT NULL AND g_success='Y' THEN
#        CALL t720sub_IQC_return(l_rvu.*,p_argv1,p_argv3,p_chr,p_inTransaction,p_ask_post,l_rva00)  #將剩餘未入庫量轉為'驗退單'
#     END IF
#  END IF
#  
#  IF g_success = 'Y' THEN
#  IF SQLCA.SQLCODE THEN
#     CALL cl_err('', SQLCA.SQLCODE,1)
#     LET g_success = 'N'
#     RETURN
#  END IF
#  IF l_rva00 = '1' THEN
#     SELECT UNIQUE pmm02
#       INTO l_pmm02
#      FROM pmm_file
#     WHERE pmm01 IN (SELECT rvv36 FROM rvv_file
#                     WHERE rvv01 = l_rvu.rvu01)
#     IF l_pmm02 = 'SUB' AND l_sma131 = 'Y' AND (g_sma.sma1431='N' OR cl_null(g_sma.sma1431)) THEN #為委外入庫單且入庫后自動生成移轉資料  #FUN-A80102
#        LET l_sql = " SELECT rvv18 FROM rvv_file ",
#                    "  WHERE rvv01 = '",l_rvu.rvu01,"'",
#                    "  ORDER BY rvv02 "
#        PREPARE t720sub_p FROM l_sql
#        DECLARE t720sub_curs CURSOR FOR t720sub_p
#        FOREACH t720sub_curs INTO l_rvv18
#          EXIT FOREACH
#        END FOREACH
#        SELECT sfb93 INTO l_sfb93 FROM sfb_file WHERE sfb01=l_rvv18
#        IF l_sfb93='Y' THEN
#           CALL t720sub_ecm(l_rvu.rvu01)
#        END IF
#     END IF
#  END IF
#  END IF
#
#  #No.FUN-A80026  --Begin
#  #No.MOD-AC0333  --Begin
#  #IF g_success = 'Y' AND NOT p_inTransaction AND g_smy.smy74='Y' THEN
#  IF g_success = 'Y' AND NOT p_inTransaction THEN
#     LET l_smyslip = s_get_doc_no(l_rvu.rvu01)
#     SELECT smy74 INTO l_smy74 FROM smy_file WHERE smyslip = l_smyslip
#     IF SQLCA.sqlcode THEN
#        LET l_smy74 = 'N'
#     END IF
#     IF cl_null(l_smy74) THEN LET l_smy74 = 'N' END IF
#     IF l_smy74 = 'Y' THEN
#  #No.MOD-AC0333  --End  
#        CALL t720_gen_ap(l_rvu.rvu01)
#     END IF             #No.MOD-AC0333
#  END IF
#  #No.FUN-A80026  --End
#
#END FUNCTION
#FUN-A60009 mark end ------------------------------------------

#FUN-B30129 ---begin--mark
#TQC-B20022 --begin--
#FUNCTION t720_rvu06_check(p_cmd)
#  DEFINE l_gemacti   LIKE gem_file.gemacti
#  DEFINE p_cmd       LIKE rvu_file.rvu06
#
#  LET g_errno = ''
#  SELECT gemacti INTO l_gemacti FROM gem_file
#   WHERE gem01 = p_cmd
#
#   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'                                   
#        WHEN l_gemacti='N'        LET g_errno = '9028'
#        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
#    END CASE
# 
#END FUNCTION    
##TQC-B20022 --end--
#FUN-B30129 --end---
#委外tky收貨單入庫後的正確性檢查
FUNCTION t720sub_ind_icd_chk_tky(l_rvu,p_argv3)
   DEFINE l_rvv04   LIKE rvv_file.rvv04,
          l_rvv05   LIKE rvv_file.rvv05,
          l_rvv18   LIKE rvv_file.rvv18
   DEFINE l_ecm_cnt LIKE type_file.num5
   DEFINE l_rvb_cnt LIKE type_file.num5
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_rvb33   LIKE rvb_file.rvb33
   DEFINE l_rvv17   LIKE rvv_file.rvv17
   DEFINE p_argv3   LIKE rvu_file.rvu08
   DEFINE l_rvu     RECORD LIKE rvu_file.*

   #只for 委外入庫單做檢查
   IF p_argv3 != 'SUB' THEN  RETURN END IF  
   IF l_rvu.rvu00 != '1' THEN RETURN END IF 

   #取得委外tky單據
   DECLARE chk_tky_cur CURSOR FOR
      SELECT DISTINCT rvv04,rvv05,rvv18 FROM rvv_file,rvb_file,rvbi_file
         WHERE rvv01 = l_rvu.rvu01  #入庫單號
           AND rvv04 = rvb01        #收貨單號
           AND rvv05 = rvb02        #收貨項次
           AND rvbi01 = rvb01
           AND rvbi02 = rvb02
           AND rvbiicd17 IS NOT NULL AND rvbiicd17 != ' '   #委外tky
           AND rvv18 IS NOT NULL       #工單單號
           AND rvbiicd03 IS NOT NULL   #作業編號

   FOREACH chk_tky_cur INTO l_rvv04,l_rvv05,l_rvv18
      #-->若為委外tky非最終站之收貨項次,必須一次入庫,不可分批
      LET l_n = 0 
      SELECT COUNT(*) INTO l_n FROM rvv_file,rvvi_file
        WHERE rvv04 = l_rvv04
          AND rvv05 = l_rvv05
          AND rvvi01= rvv01
          AND rvvi02= rvv02
          AND rvviicd07 = 'Y'
      IF l_n = 1 THEN
         #取得該收貨項次之允收數量
         LET l_rvb33 = 0
         SELECT rvb33 INTO l_rvb33 FROM rvb_file
           WHERE rvb01 = l_rvv04
             AND rvb02 = l_rvv05
         #取得該收貨項次之入庫數量
         LET l_rvv17 = 0
         SELECT SUM(rvv17) INTO l_rvv17 FROM rvv_file
           WHERE rvv04 = l_rvv04
             AND rvv05 = l_rvv05
             AND rvv03 = '1'     #入庫 
         IF l_rvb33 != l_rvv17 THEN
            CALL cl_err('tky qty err:','aic-123',1)
            LET g_success = 'N' 
            RETURN
         END IF
      END IF
      IF l_n > 1 THEN
         CALL cl_err(l_n,'aic-123',1)
         LET g_success = 'N'
         RETURN
      END IF

    #-->檢查若委外tky收貨單第一次做入庫,入庫之作業編號須符合該工單之作業製程站
    #-->檢查若委外tky(無論分批與否),入庫時一定要有最終站收貨資料
      #取得該委外工單的製程站總數
      SELECT COUNT(*) INTO l_ecm_cnt
        FROM ecm_file
       WHERE ecm01 = l_rvv18   #工單單號

      #取得該委外收貨單對應委外工單作業製程站的總數
      SELECT COUNT(*) INTO l_rvb_cnt
         FROM ecm_file,rvv_file,rvb_file,rvbi_file
        WHERE rvv04 = rvb01     #收貨單號
          AND ecm01 = rvv18     #工單單號
          AND ecm04 = rvbiicd03 #作業群組
          AND rvv04 = l_rvv04
          AND rvv05 = l_rvv05
          AND rvbi01=rvb01
          AND rvbi02=rvb02
          AND rvv01 = l_rvu.rvu01
      
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM rvv_file
        WHERE rvv04 = l_rvv04
          AND rvv01 != l_rvu.rvu01
      IF l_n = 0 THEN
         #委外TKY收貨作業站別與委外工單作業製程站別不符或不齊全,請查核!!
         IF l_rvb_cnt != l_ecm_cnt THEN
            CALL cl_err('','aic-121',1)
            LET g_success = 'N'
            RETURN
         END IF
      ELSE
         #委外tky收貨單,入庫時一定要有最終站的資料,請查核!!
         LET l_n = 0 
         SELECT COUNT(*) INTO l_n FROM rvv_file,rvvi_file
           WHERE rvv01 = l_rvu.rvu01
             AND rvviicd07 = 'N'
             AND rvv04 = l_rvv04
             AND rvv05 = l_rvv05
             AND rvvi01 = rvv01
             AND rvvi02 = rvv02
         IF l_n = 0 THEN
            CALL cl_err('','aic-124',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END FOREACH
END FUNCTION

#委外tky非最終站收貨項次的數量更新
FUNCTION t720sub_ind_icd_tky_upd_rvb(p_cmd,p_argv3,l_rvu,p_argv1)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE p_argv3   LIKE rvu_file.rvu08
   DEFINE l_rvu     RECORD LIKE rvu_file.*
   DEFINE l_rvv     RECORD LIKE rvv_file.*
   DEFINE l_rvvi    RECORD LIKE rvvi_file.*
   DEFINE p_argv1   LIKE rvu_file.rvu00
   

   #只for 委外tky非最終站之入庫單做
   IF p_argv3 != 'SUB' THEN RETURN END IF
   IF l_rvu.rvu00 != '1' THEN RETURN END IF

   DECLARE t720_tky_s1_c CURSOR FOR 
      SELECT * FROM rvv_file,rvvi_file
         WHERE rvv01 = l_rvu.rvu01
           AND rvvi01=rvv01
           AND rvvi02=rvv02
           AND rvviicd07 = 'Y'     #委外tky非最終站

   FOREACH t720_tky_s1_c INTO l_rvv.*,l_rvvi.*
      IF STATUS THEN
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      CALL t720sub_u_rvb(p_cmd,l_rvu.*,l_rvv.*,p_argv1)
   END FOREACH
END FUNCTION

FUNCTION t720sub_u_rvb(p_cmd,l_rvu,l_rvv,p_argv1) # Update rvb_file
  DEFINE l_rvb29   LIKE rvb_file.rvb29,
         l_rvb291  LIKE rvb_file.rvb29,
         l_rvb30   LIKE rvb_file.rvb30,
         l_rvb39   LIKE rvb_file.rvb39,
         p_cmd     LIKE type_file.chr1, 
         l_rvb18   LIKE rvb_file.rvb18
  DEFINE l_rvu     RECORD LIKE rvu_file.*
  DEFINE l_rvv     RECORD LIKE rvv_file.*
  DEFINE l_rvvi    RECORD LIKE rvvi_file.*
  DEFINE l_qty     LIKE ima_file.ima26
  DEFINE p_argv1   LIKE rvu_file.rvu00
  DEFINE l_ima918  LIKE ima_file.ima918
  DEFINE l_ima921  LIKE ima_file.ima921 
  DEFINE l_ima930  LIKE ima_file.ima930        #DEV-D30059 add 
  DEFINE l_rvbslk02  LIKE rvbslk_file.rvbslk02 #FUN-B90104 add
  DEFINE l_rvbslk29  LIKE rvbslk_file.rvbslk29 #FUN-B90104 add
  DEFINE l_rvbslk30  LIKE rvbslk_file.rvbslk30 #FUN-B90104 add

      IF l_rvu.rvu00='3' AND l_rvu.rvu08='SUB' THEN RETURN END IF    #Add by zm 131121  委外仓退不需更新rvb相关数量
      CALL cl_msg("upadte rvb_file..") 
      SELECT SUM(rvv17) INTO l_rvb30 FROM rvv_file,rvu_file     #計算已入庫量
       WHERE rvv04=l_rvv.rvv04 AND rvv05=l_rvv.rvv05
         AND rvuconf='Y' AND rvu00='1' AND rvv01=rvu01
      IF cl_null(l_rvb30) THEN LET l_rvb30=0 END IF
      
      SELECT SUM(rvv17) INTO l_rvb29 FROM rvv_file,rvu_file     #計算退(只算
       WHERE rvv04=l_rvv.rvv04 AND rvv05=l_rvv.rvv05            #驗退)
             AND rvuconf='Y' AND rvu00='2' AND rvv01=rvu01
      IF cl_null(l_rvb29) THEN LET l_rvb29=0 END IF
 
      SELECT rvb07 INTO l_qty FROM rvb_file
       WHERE rvb01=l_rvv.rvv04 AND rvb02=l_rvv.rvv05
      IF l_qty<(l_rvb30+l_rvb29) AND p_argv1 <>'2' THEN 
         CALL cl_err('rvb07<rvb29+30:','asf-804',1)   #MOD-A70097 asf-660-->asf-804
         LET g_success = 'N' RETURN
      END IF

      SELECT SUM(rvv17) INTO l_rvb291 FROM rvv_file,rvu_file    #計算倉退
       WHERE rvv04=l_rvv.rvv04 AND rvv05=l_rvv.rvv05
         AND rvuconf='Y' AND rvu00='3' AND rvv01=rvu01
      IF cl_null(l_rvb291) THEN LET l_rvb291=0 END IF

      IF l_rvb30>0 THEN   #有入庫
         LET l_rvb18='30'               #狀況(入「庫存」)
      ELSE
         LET l_rvb18='10'               #狀況(在收貨檢驗區)
      END IF
      SELECT rvb39 INTO l_rvb39
        FROM rvb_file
       WHERE rvb01 = l_rvu.rvu02
         AND rvb02 = l_rvv.rvv05
      IF l_rvb39 = 'Y' THEN
         UPDATE rvb_file SET rvb29 = l_rvb29,          #退貨量
                             rvb30 = l_rvb30,          #入庫量
                             rvb09 = l_rvb30-l_rvb291, #允請量
                             rvb31 = rvb33-l_rvb30,    # 可入庫量  
                             rvb18=l_rvb18
          WHERE rvb01 = l_rvu.rvu02 AND rvb02 = l_rvv.rvv05
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN  #MOD-670098 add sqlerrd[3]
             CALL cl_err3("upd","rvb_file",l_rvu.rvu02,l_rvv.rvv05,9050,"","upd rvb29,rvb09,rvb31:",1)  
             LET g_success = 'N' RETURN
          END IF
      ELSE
         UPDATE rvb_file SET rvb29 = l_rvb29,          #退貨量
                             rvb30 = l_rvb30,          #入庫量
                             rvb09 = l_rvb30-l_rvb291, #允請量
                             rvb31 = rvb07-l_rvb29-l_rvb30,  # 可入庫量
                             rvb18=l_rvb18
          WHERE rvb01 = l_rvu.rvu02 AND rvb02 = l_rvv.rvv05
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN  #MOD-670098 add sqlerrd[3]
             CALL cl_err3("upd","rvb_file",l_rvu.rvu02,l_rvv.rvv05,9050,"","upd rvb29,rvb09,rvb31:",1) 
             LET g_success = 'N' RETURN
          END IF
      END IF
#FUN-B90104----add---begin----
      IF s_industry('slk') THEN
         SELECT rvbislk02 INTO l_rvbslk02 FROM rvbi_file
          WHERE rvbi01=l_rvu.rvu02 AND rvbi02=l_rvv.rvv05

         SELECT SUM(rvb29),SUM(rvb30) INTO l_rvbslk29,l_rvbslk30 FROM rvb_file,rvbi_file
          WHERE rvb01=rvbi01
            AND rvb02=rvbi02
            AND rvb01=l_rvu.rvu02
            AND rvbislk02=l_rvbslk02

         UPDATE rvbslk_file SET rvbslk29=l_rvbslk29,
                                rvbslk30=l_rvbslk30
          WHERE rvbslk01=l_rvu.rvu02
            AND rvbslk02=l_rvbslk02
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","rvbslk_file",l_rvu.rvu02,l_rvbslk02,SQLCA.sqlcode,"","退 upd rvbslk29,rvbslk30:",1)
            LET g_success = 'N'
         END IF
      END IF
#FUN-B90104----add---begin----

      SELECT ima918,ima921 INTO l_ima918,l_ima921 
        FROM ima_file
       WHERE ima01 = l_rvv.rvv31
         AND imaacti = "Y"
      
      IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
         IF g_sma.sma90 = "Y" THEN #MOD-C30074 add
            IF p_cmd = "y" THEN
               CALL t720sub_upd_rvbs(1,l_rvu.rvu01,l_rvu.rvu02,l_rvv.rvv02,l_rvv.rvv05)
            ELSE 
               CALL t720sub_upd_rvbs(-1,l_rvu.rvu01,l_rvu.rvu02,l_rvv.rvv02,l_rvv.rvv05)
            END IF
         END IF #MOD-C30074 add
      END IF
      CALL cl_msg("") 
END FUNCTION

FUNCTION t720sub_upd_rvbs(p_i,p_rvu01,p_rvu02,p_rvv02,p_rvv05)
   DEFINE l_rvbs   RECORD LIKE rvbs_file.*
   DEFINE n_rvbs   RECORD LIKE rvbs_file.*
   DEFINE l_sql    STRING
   DEFINE l_prog   LIKE rvbs_file.rvbs00
   DEFINE p_i      LIKE type_file.num5
   DEFINE p_rvu01  LIKE rvu_file.rvu01
   DEFINE p_rvu02  LIKE rvu_file.rvu02
   DEFINE p_rvv02  LIKE rvv_file.rvv02
   DEFINE p_rvv05  LIKE rvv_file.rvv05
   DEFINE l_prog2  LIKE rvbs_file.rvbs00 #TQC-BB0088

   IF g_sma.sma90 = "N" THEN
      RETURN
   END IF
   #TQC-BB0088--begin
#   IF g_prog = "apmt730" THEN
#      LET l_prog = "apmt200"
#   ELSE
#      LET l_prog = "apmt110"
#   END IF
   IF g_prog = "apmt730" THEN
      LET l_prog = "apmt200"
      LET l_prog2=NULL
   ELSE
      LET l_prog = "apmt110"
      LET l_prog2= "apmt111"
   END IF
   #TQC-BB0088--end

   LET l_sql = "SELECT * FROM rvbs_file",
               " WHERE rvbs00 = '",g_prog,"'",
               "   AND rvbs01 = '",p_rvu01,"'",
               "   AND rvbs02 = ",p_rvv02,
               "   AND rvbs09 = 1"
   
   PREPARE t720_rvbssel FROM l_sql
   
   DECLARE rvbs_curssel CURSOR FOR t720_rvbssel

   FOREACH rvbs_curssel INTO l_rvbs.*
      IF STATUS THEN
         CALL cl_err('foreach rvbs200:',STATUS,1)
         EXIT FOREACH
      END IF

      LET l_sql = "SELECT * FROM rvbs_file",
                  #" WHERE rvbs00 = '",l_prog,"'",  #TQC-BB0088
                  #"   AND rvbs01 = '",p_rvu02,"'", #TQC-BB0088
                  " WHERE rvbs01 = '",p_rvu02,"'",  #TQC-BB0088
                  "   AND rvbs02 = ",p_rvv05,
                  "   AND rvbs03 = '",l_rvbs.rvbs03,"'",
                  "   AND rvbs04 = '",l_rvbs.rvbs04,"'",
                  "   AND rvbs08 = '",l_rvbs.rvbs08,"'",
                  "   AND rvbs09 = 1"
      #TQC-BB0088--begin
      IF NOT cl_null(l_prog2) THEN
         LET l_sql=l_sql," AND ( rvbs00='",l_prog,"' OR rvbs00='",l_prog2,"' ) "
      ELSE
         LET l_sql=l_sql," AND rvbs00 = '",l_prog,"' "
      END IF
      #TQC-BB0088--end
      
      PREPARE t720_rvbsupd FROM l_sql
      
      DECLARE rvbs_cursupd CURSOR FOR t720_rvbsupd

      OPEN rvbs_cursupd 
      IF SQLCA.sqlcode THEN
         CALL cl_err(p_rvu02,SQLCA.sqlcode,0)      #資料被他人LOCK
         CLOSE rvbs_cursupd
         RETURN
      END IF
      FETCH rvbs_cursupd INTO n_rvbs.*
      IF SQLCA.sqlcode THEN
         CALL cl_err(p_rvu02,SQLCA.sqlcode,0)      #資料被他人LOCK
         CLOSE rvbs_cursupd
         RETURN
      END IF

      CASE g_prog
         WHEN "apmt720"
            LET n_rvbs.rvbs11 = n_rvbs.rvbs11 + (l_rvbs.rvbs06 * p_i) 
         WHEN "apmt721"
            LET n_rvbs.rvbs12 = n_rvbs.rvbs12 + (l_rvbs.rvbs06 * p_i)
         WHEN "apmt730"
            LET n_rvbs.rvbs11 = n_rvbs.rvbs11 + (l_rvbs.rvbs06 * p_i)
      END CASE
 

      UPDATE rvbs_file SET rvbs11 = n_rvbs.rvbs11,
                           rvbs12 = n_rvbs.rvbs12
       WHERE rvbs01 = p_rvu02 
         AND rvbs02 = p_rvv05
         AND rvbs03 = l_rvbs.rvbs03
         AND rvbs04 = l_rvbs.rvbs04
         AND rvbs08 = l_rvbs.rvbs08
         AND rvbs09 = 1

      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","rvbs_file",p_rvu02,p_rvv05,SQLCA.sqlcode,"","upd rvbs11,rvbs12",1) 
         LET g_success = 'N'
         RETURN
      END IF

   END FOREACH
      
END FUNCTION

FUNCTION t720sub_IQC_return2(l_rvu,p_rva00)
   DEFINE l_n,l_cnt  LIKE type_file.num5    
   DEFINE l_rvu      RECORD LIKE rvu_file.*
   DEFINE l_rvv      RECORD LIKE rvv_file.*
   DEFINE la_rvv     RECORD LIKE rvv_file.*
   DEFINE l_rvvi     RECORD LIKE rvvi_file.*
   DEFINE l_rvv17    LIKE rvv_file.rvv17
   DEFINE l_rvv85_1,l_rvv85_2    LIKE rvv_file.rvv85 
   DEFINE l_rvv82_1,l_rvv82_2    LIKE rvv_file.rvv82  
   DEFINE l_rvv87_1,l_rvv87_2    LIKE rvv_file.rvv87  
   DEFINE l_qty      LIKE rvv_file.rvv17
   DEFINE l_rvb85    LIKE rvb_file.rvb85 
   DEFINE l_rvb82    LIKE rvb_file.rvb82 
   DEFINE l_rvb87    LIKE rvb_file.rvb87 
   DEFINE l_smy51    LIKE smy_file.smy51 
   DEFINE l_ima906   LIKE ima_file.ima906 
   DEFINE l_imaicd04 LIKE imaicd_file.imaicd04
   DEFINE l_rvv82     LIKE rvv_file.rvv82
   DEFINE l_rvv85     LIKE rvv_file.rvv85
   DEFINE l_bno       LIKE rvbs_file.rvbs08   # #歸屬單號
   DEFINE l_img07     LIKE img_file.img07
   DEFINE l_img10     LIKE img_file.img10
   DEFINE l_img09     LIKE img_file.img09
   DEFINE l_flag      LIKE type_file.chr1
   DEFINE l_ima918    LIKE ima_file.ima918
   DEFINE l_ima921    LIKE ima_file.ima921
   DEFINE l_ima930    LIKE ima_file.ima930   #DEV-D30059 add
   DEFINE l_msg       LIKE ze_file.ze03
   DEFINE l_r         LIKE type_file.chr1
   DEFINE p_rva00     LIKE rva_file.rva00
#FUN-BC0104-add-str--
   DEFINE  l_rvv04  LIKE rvv_file.rvv04,
           l_rvv05  LIKE rvv_file.rvv05,
           l_rvv45  LIKE rvv_file.rvv45,
           l_rvv46  LIKE rvv_file.rvv46,
           l_rvv47  LIKE rvv_file.rvv47,
           l_flagg  LIKE type_file.chr1,
           l_qcl05  LIKE qcl_file.qcl05,
           l_type1  LIKE type_file.chr1
#FUN-BC0104-add-end--
#FUN-C20064---add---str---
   DEFINE  l_rvv87_sum LIKE rvv_file.rvv87, 
           l_rvv86  LIKE rvv_file.rvv86,   
           l_rvv31  LIKE rvv_file.rvv31,  
           l_i      LIKE type_file.num5, 
           l_fac    LIKE rvv_file.rvv35_fac, 
           l_rvv35  LIKE rvv_file.rvv35,    
           l_rvv87  LIKE rvv_file.rvv87
#FUN-C20064---add---end---

   SELECT COUNT(*) INTO l_n FROM rvb_file,rvv_file
    WHERE rvb01=l_rvu.rvu02
      AND rvb07>rvb30        #實收-入庫
      AND rvb01=rvv04
      AND rvb02=rvv05
      AND rvv17>=0            #入庫數量
   IF l_n=0 THEN RETURN END IF           #如果全部入庫

     #FUN-C20064---add---str---
      LET l_rvv87=0
      LET l_rvv87_sum =0
      DECLARE rvv_cur CURSOR FOR 
         SELECT rvv87,rvv86,rvv31,rvv35 FROM rvv_file,qcl_file 
          WHERE rvv01=l_rvu.rvu01
            AND rvv46=qcl01
            AND rvv46 IS NOT NULL
            AND qcl05='1'
          ORDER BY rvv31

     FOREACH rvv_cur INTO l_rvv87,l_rvv86,l_rvv31,l_rvv35
        IF cl_null(l_rvv87) THEN LET l_rvv87=0 END IF
        CALL s_umfchk(l_rvv31,l_rvv86,l_rvv35)
         RETURNING l_i,l_fac
        IF l_i THEN LET l_fac=1 END IF
        LET l_rvv87 = l_rvv87*l_fac
        LET l_rvv87_sum = l_rvv87_sum+l_rvv87
        IF cl_null(l_rvv87_sum) THEN LET l_rvv87_sum=0 END IF
     END FOREACH 
     #FUN-C20064---add---end---

       #----單身
       DECLARE t110_y2 CURSOR WITH HOLD FOR
          SELECT * FROM rvv_file WHERE rvv01=l_rvu.rvu01 AND rvv17>=0
       FOREACH t110_y2 INTO la_rvv.*
          LET l_rvv.*    =la_rvv.*
          LET l_rvv.rvv01=l_rvu.rvu01     #單號
          IF s_industry('icd') THEN
             SELECT * INTO l_rvvi.* 
               FROM rvvi_file 
              WHERE rvvi01=la_rvv.rvv01
                AND rvvi02=la_rvv.rvv02
          END IF
          SELECT SUM(rvv17),SUM(rvv85),SUM(rvv82),SUM(rvv87)  
            INTO l_rvv17,l_rvv85_1,l_rvv82_1,l_rvv87_1 FROM rvv_file  
           WHERE rvv01=l_rvu.rvu01 AND rvv17>=0
             AND rvv04=l_rvv.rvv04
             AND rvv05=l_rvv.rvv05
          IF cl_null(l_rvv17) THEN LET l_rvv17=0 END IF
          IF cl_null(l_rvv85_1) THEN LET l_rvv85_1=0 END IF
          IF cl_null(l_rvv82_1) THEN LET l_rvv82_1=0 END IF 
          IF cl_null(l_rvv87_1) THEN LET l_rvv87_1=0 END IF

          LET l_rvv17=l_rvv17+l_rvv87_sum    #FUN-C20064

          SELECT rvb07-rvb30 INTO l_qty FROM rvb_file    #未入庫量
           WHERE rvb01=la_rvv.rvv04 AND rvb02=la_rvv.rvv05
          LET l_rvv.rvv17=l_qty - l_rvv17
          IF l_rvv.rvv17<=0 THEN CONTINUE FOREACH END IF
          SELECT rvb85,rvb82,rvb87 INTO l_rvb85,l_rvb82,l_rvb87 FROM rvb_file
           WHERE rvb01=la_rvv.rvv04 AND rvb02=la_rvv.rvv05
          IF cl_null(l_rvb85) THEN LET l_rvb85=0 END IF   
          IF cl_null(l_rvb82) THEN LET l_rvb82=0 END IF   
          IF cl_null(l_rvb87) THEN LET l_rvb87=0 END IF   
          SELECT SUM(rvv85),SUM(rvv82),SUM(rvv87) 
           INTO l_rvv85_2,l_rvv82_2,l_rvv87_2 
            FROM rvu_file,rvv_file   
           WHERE rvv01<>l_rvu.rvu01 AND rvv17>=0
             AND rvv04=l_rvv.rvv04
             AND rvv05=l_rvv.rvv05
             AND rvu01=rvv01
             AND rvuconf='Y'
          IF cl_null(l_rvv85_2) THEN LET l_rvv85_2=0 END IF   
          IF cl_null(l_rvv82_2) THEN LET l_rvv82_2=0 END IF   
          IF cl_null(l_rvv87_2) THEN LET l_rvv87_2=0 END IF   
          LET l_rvv.rvv85=l_rvb85-l_rvv85_2-l_rvv85_1 
          LET l_rvv.rvv82=l_rvb82-l_rvv82_2-l_rvv82_1 
          LET l_rvv.rvv87=l_rvb87-l_rvv87_2-l_rvv87_1 

          CALL cl_getmsg('apm-284',g_lang) RETURNING l_msg
          LET l_msg=la_rvv.rvv31 CLIPPED,':',l_msg CLIPPED
          LET INT_FLAG = 0  ######add for prompt bug
          IF NOT cl_prompt(18,10,l_msg) THEN CONTINUE FOREACH END IF

          LET l_rvv.rvv23=0               #已請款匹配數量
          LET l_rvv.rvv88=0               #No.TQC-7B0083
          LET l_rvv.rvv03='1'
          SELECT MAX(rvv02)+1 INTO l_rvv.rvv02
            FROM rvv_file
           WHERE rvv01=l_rvu.rvu01
          IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02=1 END IF
          LET l_rvv.rvv32=g_qcz.qcz051
          LET l_rvv.rvv33=g_qcz.qcz052

         #check 批號是否為專案代號
          LET l_cnt = 0
          SELECT COUNT(*) INTO l_cnt FROM pja_file WHERE pja01=la_rvv.rvv34
          IF l_cnt=0 THEN LET l_rvv.rvv34=' '  END IF

          IF cl_null(l_rvv.rvv32) THEN LET l_rvv.rvv32=' ' END IF
          IF cl_null(l_rvv.rvv33) THEN LET l_rvv.rvv33=' ' END IF
          IF cl_null(l_rvv.rvv34) THEN LET l_rvv.rvv34=' ' END IF

          #-----CHI-8A0016---------
          SELECT img07,img10,img09 INTO l_img07,l_img10,l_img09
            FROM img_file   #採購單位,庫存數量,庫存單位
           WHERE img01=l_rvv.rvv31 AND img02=l_rvv.rvv32
             AND img03=l_rvv.rvv33 AND img04=l_rvv.rvv34
          IF STATUS=100 AND (l_rvv.rvv32 IS NOT NULL AND l_rvv.rvv32 <> ' ') THEN
             IF NOT cl_null(l_rvv.rvv32) OR NOT cl_null(l_rvv.rvv33) OR NOT cl_null(l_rvv.rvv34) THEN   #MOD-D30083 add
                IF g_sma.sma892[3,3] ='Y' THEN
                   IF NOT cl_confirm('mfg1401') THEN
                      CONTINUE FOREACH
                   END IF
                END IF
                CALL s_add_img(l_rvv.rvv31,l_rvv.rvv32,
                               l_rvv.rvv33,l_rvv.rvv34,
                               l_rvu.rvu01,l_rvv.rvv02,l_rvu.rvu03)
                SELECT img07,img10,img09 INTO l_img07,l_img10,l_img09
                  FROM img_file
                 WHERE img01 = l_rvv.rvv31
                   AND img02 = l_rvv.rvv32
                   AND img03 = l_rvv.rvv33
                   AND img04 = l_rvv.rvv34
             END IF  #MOD-D30083 add  
          END IF

          IF NOT cl_null(l_rvv.rvv83) THEN
             CALL s_chk_imgg(l_rvv.rvv31,l_rvv.rvv32,
                             l_rvv.rvv33,l_rvv.rvv34,
                             l_rvv.rvv83) RETURNING l_flag
             IF l_flag = 1 THEN
                IF g_sma.sma892[3,3] ='Y' THEN
                   IF NOT cl_confirm('aim-995') THEN
                      CONTINUE FOREACH
                   END IF
                END IF
                CALL s_add_imgg(l_rvv.rvv31,l_rvv.rvv32,
                                l_rvv.rvv33,l_rvv.rvv34,
                                l_rvv.rvv83,l_rvv.rvv84,
                                l_rvu.rvu01,
                                l_rvv.rvv02,0) RETURNING l_flag
                IF l_flag = 1 THEN
                   CONTINUE FOREACH
                END IF
             END IF
          END IF
          SELECT ima906 INTO l_ima906 FROM ima_file
           WHERE ima01=l_rvv.rvv31
          IF l_ima906 = '2' THEN
             IF NOT cl_null(l_rvv.rvv80) THEN
                CALL s_chk_imgg(l_rvv.rvv31,l_rvv.rvv32,
                                l_rvv.rvv33,l_rvv.rvv34,
                                l_rvv.rvv80) RETURNING l_flag
                IF l_flag = 1 THEN
                   IF g_sma.sma892[3,3] ='Y' THEN
                      IF NOT cl_confirm('aim-995') THEN
                         CONTINUE FOREACH
                      END IF
                   END IF
                   CALL s_add_imgg(l_rvv.rvv31,l_rvv.rvv32,
                                   l_rvv.rvv33,l_rvv.rvv34,
                                   l_rvv.rvv80,l_rvv.rvv81,
                                   l_rvu.rvu01,
                                   l_rvv.rvv02,0) RETURNING l_flag
                   IF l_flag = 1 THEN
                      CONTINUE FOREACH
                   END IF
                END IF
             END IF
          END IF
          #TQC-C30225 add begin
          CALL t720sub_rvv38(la_rvv.rvv36,l_rvv.rvv38,l_rvv.rvv38t,l_rvu.rvu04,l_rvu.rvu01)  #TQC-C30225 add
              RETURNING l_rvv.rvv38,l_rvv.rvv38t
          #TQC-C30225 add end
          LET l_rvv.rvv39=l_rvv.rvv87*l_rvv.rvv38
          LET l_rvv.rvv39t=l_rvv.rvv87*l_rvv.rvv38t
          # 依幣別四捨五入
          LET t_azi04='' 
          IF p_rva00 = '1' THEN 
             SELECT azi04 INTO t_azi04  
               FROM pmm_file,azi_file
              WHERE pmm22=azi01
                AND pmm01 = la_rvv.rvv36 AND pmm18 <> 'X'
          ELSE
              SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = l_rvu.rvu113
          END IF
          IF l_rvv.rvv87 = 0 OR cl_null(t_azi04) THEN 
             SELECT azi04 INTO t_azi04
               FROM pmc_file,azi_file
              WHERE pmc22=azi01
                AND pmc01 = l_rvu.rvu04
          END IF
         IF cl_null(t_azi04) THEN LET t_azi04=0 END IF 
         CALL cl_digcut(l_rvv.rvv39,t_azi04)  
                           RETURNING l_rvv.rvv39
         CALL cl_digcut(l_rvv.rvv39t,t_azi04)  #No.CHI-6A0004
                           RETURNING l_rvv.rvv39t  

         #CALL t720sub_rvv39(la_rvv.rvv36,l_rvv.rvv39,l_rvv.rvv39t,l_rvu.rvu04,l_rvu.rvu02) #MOD-BC0262 mark 
         CALL t720sub_rvv39(la_rvv.rvv36,l_rvv.rvv39,l_rvv.rvv39t,l_rvu.rvu04,l_rvu.rvu01)  #MOD-BC0262 add
              RETURNING l_rvv.rvv39,l_rvv.rvv39t

          LET l_rvv.rvv40 = 'N'  
          LET l_ima906 = NULL
          SELECT ima906 INTO l_ima906 FROM ima_file
           WHERE ima01=l_rvv.rvv31
          IF g_sma.sma115 = 'N' OR cl_null(l_ima906) OR l_ima906 = '1' THEN
             LET l_rvv.rvv80=l_rvv.rvv35
             LET l_rvv.rvv82=l_rvv.rvv17
             LET l_rvv.rvv81=l_rvv.rvv35_fac
          END IF
          IF g_sma.sma116 MATCHES '[02]' THEN  
             LET l_rvv.rvv86=l_rvv.rvv35
             LET l_rvv.rvv87=l_rvv.rvv17
          END IF
          IF (g_sma.sma115 = 'Y' AND l_ima906 MATCHES '[1]')
             OR g_sma.sma115 = 'N' THEN
             LET l_rvv.rvv82=0
             LET l_rvv.rvv85=0
          END IF

          IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02 = 1 END IF
          LET l_rvv.rvv88 = 0  
          LET l_rvv.rvvplant = g_plant 
          LET l_rvv.rvvlegal = g_legal
          IF l_rvv.rvv10 IS NULL THEN LET l_rvv.rvv10 = '4' END IF
      #流通代銷無收貨單,將發票記錄rvb22同時新增到rvv22內
      #FUN-BB0001 add START
          IF NOT cl_null(l_rvv.rvv04) AND NOT cl_null(l_rvv.rvv05) THEN
             SELECT rvb22 INTO l_rvv.rvv22 FROM rvb_file WHERE rvb01 = l_rvv.rvv04 AND rvb02 = l_rvv.rvv05
          END IF
      #FUN-BB0001 add END
      #FUN-CB0087---add---str---
          IF g_aza.aza115 = 'Y' THEN
             CALL s_reason_code(l_rvv.rvv01,l_rvv.rvv04,'',l_rvv.rvv31,l_rvv.rvv32,l_rvu.rvu07,l_rvu.rvu06) RETURNING l_rvv.rvv26
             IF cl_null(l_rvv.rvv26) THEN
                CALL cl_err('','aim-425',1)
                LET g_success='N'
                EXIT FOREACH
                RETURN
             END IF
          END IF
      #FUN-CB0087---add---end---
          INSERT INTO rvv_file VALUES (l_rvv.*)
          IF STATUS THEN
             CALL cl_err3("ins","rvv_file",l_rvv.rvv01,l_rvv.rvv02,STATUS,"","ins rvv:",1)  #No.FUN-660129
             LET g_success='N'
             EXIT FOREACH
             RETURN
          END IF
          IF NOT s_industry('std') THEN
             INITIALIZE l_rvvi.* TO NULL 
             LET l_rvvi.rvvi01 = l_rvv.rvv01
             LET l_rvvi.rvvi02 = l_rvv.rvv02
             #作業編號,datecode , 母體料號, 產品型號,
             SELECT rvbiicd03,rvbiicd08,rvbiicd14,rvbiicd15,
                    #母批    ,Tap Reel
                    rvbiicd16,' '
               INTO l_rvvi.rvviicd01,l_rvvi.rvviicd02,l_rvvi.rvviicd03,
                    l_rvvi.rvviicd04,l_rvvi.rvviicd05,l_rvvi.rvviicd06
               FROM rvbi_file
              WHERE rvbi01 = l_rvv.rvv04 AND rvbi02 = l_rvv.rvv05
             IF NOT s_ins_rvvi(l_rvvi.*,'') THEN
                LET g_success = 'N'
                EXIT FOREACH
                RETURN
             END IF
          END IF
          SELECT ima918,ima921,ima930 INTO l_ima918,l_ima921,l_ima930 #DEV-D30059 add ima930 
            FROM ima_file
           WHERE ima01 = l_rvv.rvv31
             AND imaacti = "Y"
          
          IF cl_null(l_ima930) THEN LET l_ima930 = 'N' END IF  #DEV-D30059 add

          IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
             IF g_sma.sma90 = 'Y' THEN  
                CALL t720sub_ins_rvbs('apmt720_1',l_rvv.rvv01,l_rvv.rvv02,  
                              l_rvv.rvv04,l_rvv.rvv05,l_rvv.rvv31,
                              l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvu.rvu02)
             ELSE
                LET l_bno = ''
                SELECT pmn122 INTO l_bno
                  FROM pmn_file
                 WHERE pmn01 = la_rvv.rvv36
                   AND pmn02 = la_rvv.rvv37
#TQC-B90236---mark---begin--
#               CALL s_lotin(g_prog,l_rvv.rvv01,l_rvv.rvv02,0,
#                            l_rvv.rvv31,l_rvv.rvv35,l_img09,
#                            l_rvv.rvv35_fac,l_rvv.rvv17,l_bno,'MOD')
#                    RETURNING l_r,l_qty
#TQC-B90236---mark---end----
#TQC-B90236---add----begin
                IF l_ima930 = 'N' THEN                                        #DEV-D30059
                   IF l_rvu.rvu00='1' THEN
                      CALL s_mod_lot(g_prog,l_rvv.rvv01,l_rvv.rvv02,0,
                                     l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                                     l_rvv.rvv35,l_img09,l_rvv.rvv35_fac,l_rvv.rvv17,l_bno,'MOD',1)
                           RETURNING l_r,l_qty
                   ELSE
                      CALL s_mod_lot(g_prog,l_rvv.rvv01,l_rvv.rvv02,0,
                                     l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                                     l_rvv.rvv35,l_img09,l_rvv.rvv35_fac,l_rvv.rvv17,l_bno,'MOD',-1)
                           RETURNING l_r,l_qty
                   END IF
                END IF                                                        #DEV-D30059
#TQC-B90236---add----end
                IF l_r = "Y" THEN
                   LET l_qty = s_digqty(l_qty,l_rvv.rvv35)   #No.FUN-BB0086
                   UPDATE rvv_file set rvv17 = l_qty
                    WHERE rvv01 = l_rvv.rvv01
                      AND rvv02 = l_rvv.rvv02
                   #FUN-BC0104-add-str--
                   CALL s_iqctype_rvv(l_rvv.rvv01,l_rvv.rvv02) RETURNING l_rvv04,l_rvv05,l_rvv45,l_rvv46,l_rvv47,l_flagg
                   IF l_flagg = 'Y' THEN
                      CALL s_qcl05_sel(l_rvv46) RETURNING l_qcl05
                      IF l_qcl05 ='1' THEN LET l_type1 = '5' ELSE LET l_type1='1' END IF
                      IF NOT s_iqctype_upd_qco20(l_rvv04,l_rvv05,l_rvv45,l_rvv47,l_type1) THEN
                         LET g_success = 'N'
                         EXIT FOREACH
                         RETURN
                      END IF
                   END IF
                   #FUN-BC0104-add-end--                   
                END IF
             END IF
          END IF
       END FOREACH
{   LET g_argv1= '1'  
   LET g_argv2= l_rvu.rvu02

   CALL t720_show()   #No:MOD-610067
   LET g_argv2= ''}
END FUNCTION

#FUNCTION t720sub_rvv39(p_rvv36,p_rvv39,p_rvv39t,p_rvu04,p_rvu02) #MOD-BC0262 mark
FUNCTION t720sub_rvv39(p_rvv36,p_rvv39,p_rvv39t,p_rvu04,p_rvu01)  #MOD-BC0262 add
  DEFINE    l_gec07   LIKE gec_file.gec07,     #含稅否
            l_gec05   LIKE gec_file.gec05,     #CHI-AC0016
            l_pmm43   LIKE pmm_file.pmm43,     #稅率
            p_rvv36   LIKE rvv_file.rvv36,     #採購單
            p_rvv39   LIKE rvv_file.rvv39,     #未稅金額
            p_rvv39t  LIKE rvv_file.rvv39t,    #含稅金額
            p_rvu04   LIKE rvu_file.rvu04,
            #p_rvu02   LIKE rvu_file.rvu02 #MOD-BC0262 mark
            p_rvu01   LIKE rvu_file.rvu01  #MOD-BC0262 add
  DEFINE l_rva115     LIKE rva_file.rva115
  DEFINE l_rva00      LIKE rva_file.rva00
  DEFINE l_gec04      LIKE gec_file.gec04
  #MOD-BC0262 ----- modify start -----
  DEFINE l_rvu02      LIKE rvu_file.rvu02
  DEFINE l_rvu12      LIKE rvu_file.rvu12

   SELECT rvu02,rvu12 INTO l_rvu02,l_rvu12 FROM rvu_file WHERE rvu01 = p_rvu01
  #MOD-BC0262 ----- modify end -----
  
  IF g_azw.azw04 = '2' AND g_prog='apmt742' THEN
         SELECT gec04 INTO l_gec04 FROM gec_file,pmc_file
          WHERE gec01 = pmc47 AND pmc01 = p_rvu04
            AND gec011 = '1'  #TQC-D80017
         LET p_rvv39t = p_rvv39 *(1 + l_gec04/100)
  ELSE
   #不使用單價*數量=金額, 改以金額回推稅率, 以避免小數位差的問題
    #IF NOT cl_null(p_rvu02) THEN #MOD-BC0262 mark 
    IF NOT cl_null(l_rvu02) THEN  #MOD-BC0262 add
       SELECT rva00,rva115,rva116 INTO l_rva00,l_rva115,l_pmm43 
         #FROM rva_file WHERE rva01 = p_rvu02 #MOD-BC0262 mark
         FROM rva_file WHERE rva01 = l_rvu02  #MOD-BC0262 add
       IF l_rva00 = '2' THEN
          SELECT gec07,gec05 INTO l_gec07,l_gec05 FROM gec_file WHERE gec01 = l_rva115   #CHI-AC0016 add gec05
       ELSE
           #MOD-BC0262 ----- modify satrt -----
           IF cl_null(p_rvv36) THEN
              LET l_pmm43 = l_rvu12
           ELSE
           #MOD-BC0262 ----- modify end -----
              SELECT gec07,gec05,pmm43 INTO l_gec07,l_gec05,l_pmm43 FROM gec_file,pmm_file   #CHI-AC0016 add gec05
               WHERE gec01 = pmm21
                 AND pmm01 = p_rvv36
                 AND gec011 = '1' #MOD-B40078 add
           END IF   #MOD-BC0262 add
       END IF
    ELSE
        #MOD-BC0262 ----- modify satrt -----
        IF cl_null(p_rvv36) THEN
           LET l_pmm43 = l_rvu12
        ELSE
        #MOD-BC0262 ----- modify end -----
           SELECT gec07,gec05,pmm43 INTO l_gec07,l_gec05,l_pmm43 FROM gec_file,pmm_file   #CHI-AC0016 add gec05
             WHERE gec01 = pmm21
               AND pmm01 = p_rvv36
               AND gec011 = '1' #MOD-B40078 add
        END IF #MOD-BC0262 add
    END IF
  END IF
  
   IF SQLCA.SQLCODE = 100 THEN
      CALL cl_err('','mfg3192',0)
      SELECT gec07,gec05,gec04 INTO l_gec07,l_gec05,l_pmm43 FROM gec_file,pmc_file    #CHI-AC0016 add gec05
       WHERE gec01 = pmc47
         AND pmc01 = p_rvu04 
         AND gec011='1'  #進項
      IF cl_null(l_pmm43) THEN LET l_pmm43=0 END IF
 # END IF       #TQC-D80008 mark
      IF l_gec07='Y' THEN
         #-----CHI-AC0016---------
         #LET p_rvv39 = p_rvv39t / ( 1 + l_pmm43/100)
         #LET p_rvv39 = cl_digcut(p_rvv39 , t_azi04)  
        # IF l_gec05 = 'T' THEN
         IF l_gec05  MATCHES '[AT]' THEN  #FUN-D10128
            LET p_rvv39 = p_rvv39t * ( 1 - l_pmm43/100)
            LET p_rvv39 = cl_digcut(p_rvv39 , t_azi04)  
         ELSE
            LET p_rvv39 = p_rvv39t / ( 1 + l_pmm43/100)
            LET p_rvv39 = cl_digcut(p_rvv39 , t_azi04)  
         END IF
         #-----END CHI-AC0016-----
      ELSE
         LET p_rvv39t = p_rvv39 * ( 1 + l_pmm43/100)
         LET p_rvv39t = cl_digcut( p_rvv39t , t_azi04)  
      END IF
   END IF       #TQC-D80008 add    
   RETURN p_rvv39,p_rvv39t
END FUNCTION

FUNCTION t720sub_ins_rvbs(p_rvbs00,p_rvv01,p_rvv02,p_rvv04,p_rvv05,
                          p_rvv31,p_rvv32,p_rvv33,p_rvv34,p_rvu02)
   DEFINE p_rvbs00  LIKE rvbs_file.rvbs00
   DEFINE p_rvv01   LIKE rvv_file.rvv01
   DEFINE p_rvv02   LIKE rvv_file.rvv02
   DEFINE p_rvv04   LIKE rvv_file.rvv04
   DEFINE p_rvv05   LIKE rvv_file.rvv05
   DEFINE p_rvv31   LIKE rvv_file.rvv31
   DEFINE p_rvv32   LIKE rvv_file.rvv32
   DEFINE p_rvv33   LIKE rvv_file.rvv33
   DEFINE p_rvv34   LIKE rvv_file.rvv34
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_imgs    RECORD LIKE imgs_file.*
   DEFINE l_rvbs    RECORD LIKE rvbs_file.*
   DEFINE l_sql     STRING
   DEFINE l_rvbs06  LIKE rvbs_file.rvbs06
   DEFINE p_rvu02   LIKE rvu_file.rvu02
   DEFINE l_ima24   LIKE ima_file.ima24           #TQC-CA0049 add
   DEFINE l_sum_rvbs06 LIKE rvbs_file.rvbs06      #TQC-CA0049 add
   DEFINE l_rvu116  LIKE rvu_file.rvu116          #MOD-CB0229 add 
   

   IF g_sma.sma90 = "N" THEN
      IF p_rvbs00 <> "apmt722" THEN
         RETURN
      END IF
   END IF

   LET l_sql = "SELECT * FROM rvbs_file",
               " WHERE rvbs00 = 'apmt110'",
               "   AND rvbs01 = '",p_rvv04,"'",
               "   AND rvbs02 = ",p_rvv05,
               "   AND rvbs09 = 1"

   PREPARE t720_rvbs110 FROM l_sql
   
   DECLARE rvbs_curs110 CURSOR FOR t720_rvbs110

   LET l_sql = "SELECT * FROM imgs_file",
               " WHERE imgs01 = '",p_rvv31 CLIPPED,"'",
               "   AND imgs02 = '",p_rvv32,"'",
               "   AND imgs03 = '",p_rvv33,"'",
               "   AND imgs04 = '",p_rvv34,"'",
               "   AND imgs11 = ' '",
               "   AND imgs08 > 0 "   #MOD-A20094

   PREPARE t720_imgs720 FROM l_sql
   
   DECLARE imgs_curs720 CURSOR FOR t720_imgs720
     
   LET l_sql = "SELECT rvbs00,rvbs01,rvbs02,rvbs03,rvbs04,rvbs05,SUM(rvbs06),",
               "       rvbs07,rvbs08,rvbs021,rvbs022,rvbs09,rvbs10,rvbs11,",
               "       rvbs12 FROM rvbs_file,rvu_file,rvv_file,rvb_file",  
              #" WHERE rvbs00 = 'apmt720'",                #MOD-D40032 mark
               " WHERE rvbs00 IN ('apmt720','apmt740') ",  #MOD-D40032
               "   AND rvbs01 = rvv01 ",
               "   AND rvbs02 = rvv02 ",
               "   AND rvu01 = rvv01 ",   #MOD-9B0155
               "   AND rvuconf <> 'X' ",  #MOD-9B0155
               "   AND rvv04 = rvb01 ",
               "   AND rvv05 = rvb02 ",
               "   AND rvb01 = '",p_rvv04,"'",
               "   AND rvb02 = ",p_rvv05,
               "   AND rvbs09 = 1",
               " GROUP BY rvbs00,rvbs01,rvbs02,rvbs03,rvbs04,rvbs05,rvbs07,",
               "          rvbs08,rvbs021,rvbs022,rvbs09,rvbs10,rvbs11,rvbs12"

   PREPARE t720_rvbs720 FROM l_sql
   
   DECLARE rvbs_curs720 CURSOR FOR t720_rvbs720
     
   IF p_rvbs00 = "apmt720" THEN
      FOREACH rvbs_curs110 INTO l_rvbs.*
         IF STATUS THEN
            CALL cl_err('foreach rvbs110:',STATUS,1)
            EXIT FOREACH
         END IF
         LET l_rvbs.rvbs00 = p_rvbs00
         LET l_rvbs.rvbs01 = p_rvv01
         LET l_rvbs.rvbs02 = p_rvv02 
      
         IF l_rvbs.rvbs10 > 0 THEN
            #異動數量=允收量-入庫量
            LET l_rvbs.rvbs06 = l_rvbs.rvbs10 - l_rvbs.rvbs11  
         END IF
#TQC-CA0049 -------------------- add ------------------ begin #判斷對應的批序號質量檢驗是否通過審核
         SELECT ima24 INTO l_ima24 FROM ima_file WHERE ima01 = l_rvbs.rvbs021
         IF l_ima24 = 'Y' AND g_sma.sma886[6,6] = 'Y' THEN
            SELECT SUM(rvbs06) INTO l_sum_rvbs06 FROM rvbs_file,qcs_file
             WHERE qcs01 = rvbs01
               AND qcs02 = rvbs02
               AND qcs05 = rvbs13
               AND rvbs00 = p_rvv04
               AND rvbs01 = p_rvv05
               AND rvbs02 = l_rvbs.rvbs02
               AND rvbs022 = l_rvbs.rvbs022
               AND rvbs09 = l_rvbs.rvbs09
               AND qcs14 = 'Y'
               AND qcs09 = '1'
            LET l_rvbs.rvbs06 = l_sum_rvbs06
            IF cl_null(l_rvbs.rvbs06) THEN LET l_rvbs.rvbs06 = 0 END IF
            IF l_rvbs.rvbs06 = 0 THEN CONTINUE FOREACH END IF  #TQC-CA0049 add
            LET l_rvbs.rvbs06 = l_rvbs.rvbs06 - l_rvbs.rvbs11
         END IF
#TQC-CA0049 -------------------- add ------------------ end
         
         LET l_rvbs.rvbs09 = 1       #TQC-B90236 add

         LET l_rvbs.rvbs10 = 0
      
         LET l_rvbs.rvbs11 = 0
      
         LET l_rvbs.rvbs12 = 0
         LET l_rvbs.rvbsplant = g_plant 
         LET l_rvbs.rvbslegal = g_legal 
         INSERT INTO rvbs_file VALUES(l_rvbs.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","rvbs_file",l_rvbs.rvbs01,l_rvbs.rvbs02,SQLCA.sqlcode,"","",1) 
            LET g_success = "N"
            CONTINUE FOREACH
         END IF
      
      END FOREACH
   END IF

   IF p_rvbs00 = "apmt720_1" THEN
      FOREACH rvbs_curs110 INTO l_rvbs.*
         IF STATUS THEN
            CALL cl_err('foreach rvbs110:',STATUS,1)
            EXIT FOREACH
         END IF
      
         LET l_rvbs.rvbs00 = 'apmt720'
         LET l_rvbs.rvbs01 = p_rvv01
         LET l_rvbs.rvbs02 = p_rvv02 

         LET l_rvbs.rvbs06 = l_rvbs.rvbs06 - l_rvbs.rvbs10 
#TQC-CA0049 -------------------- add ------------------ begin #判斷對應的批序號質量檢驗是否通過審核
         SELECT ima24 INTO l_ima24 FROM ima_file WHERE ima01 = l_rvbs.rvbs021
         IF l_ima24 = 'Y' AND g_sma.sma886[6,6] = 'Y' THEN
            SELECT SUM(rvbs06) INTO l_sum_rvbs06 FROM rvbs_file,qcs_file
             WHERE qcs01 = rvbs01
               AND qcs02 = rvbs02
               AND qcs05 = rvbs13
               AND rvbs00 = 'aqct110'
               AND rvbs01 = p_rvv04
               AND rvbs02 = p_rvv05
               AND rvbs022 = l_rvbs.rvbs022
               AND rvbs09 = l_rvbs.rvbs09
               AND qcs14 = 'Y'
               AND qcs09 = '1'
            LET l_rvbs.rvbs06 = l_sum_rvbs06
            IF cl_null(l_rvbs.rvbs06) THEN LET l_rvbs.rvbs06 = 0 END IF
            IF l_rvbs.rvbs06 = 0 THEN  CONTINUE FOREACH END IF  ##TQC-CA0049 add
            LET l_rvbs.rvbs06 = l_rvbs.rvbs06 - l_rvbs.rvbs11
         END IF
#TQC-CA0049 -------------------- add ------------------ end
         LET l_rvbs.rvbs09 = 1  #TQC-B90236 add
         LET l_rvbs.rvbs10 = 0
        
         LET l_rvbs.rvbs11 = 0
      
         LET l_rvbs.rvbs12 = 0
         LET l_rvbs.rvbsplant = g_plant 
         LET l_rvbs.rvbslegal = g_legal
      
         INSERT INTO rvbs_file VALUES(l_rvbs.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","rvbs_file",l_rvbs.rvbs01,l_rvbs.rvbs02,SQLCA.sqlcode,"","",1) 
            LET g_success = "N"
            CONTINUE FOREACH
         END IF
      
      END FOREACH
   END IF

   IF p_rvbs00 = "apmt721" THEN
      FOREACH rvbs_curs110 INTO l_rvbs.*
         IF STATUS THEN
            CALL cl_err('foreach rvbs110:',STATUS,1)
            EXIT FOREACH
         END IF
      
         LET l_rvbs.rvbs00 = p_rvbs00
         LET l_rvbs.rvbs01 = p_rvv01
         LET l_rvbs.rvbs02 = p_rvv02 
      
         #異動數量=實收數量 - 已入庫量 - 已驗退量
         LET l_rvbs.rvbs06 = l_rvbs.rvbs06 - l_rvbs.rvbs11 - l_rvbs.rvbs12 
#TQC-CA0049 -------------------- add ------------------ begin #判斷對應的批序號質量檢驗是否通過審核
         SELECT ima24 INTO l_ima24 FROM ima_file WHERE ima01 = l_rvbs.rvbs021
         IF l_ima24 = 'Y' AND g_sma.sma886[6,6] = 'Y' THEN
            SELECT SUM(rvbs06) INTO l_sum_rvbs06 FROM rvbs_file,qcs_file
             WHERE qcs01 = rvbs01
               AND qcs02 = rvbs02
               AND qcs05 = rvbs13
               AND rvbs00 = 'aqct110'
               AND rvbs01 = p_rvv04
               AND rvbs02 = p_rvv05
               AND rvbs022 = l_rvbs.rvbs022
               AND rvbs09 = l_rvbs.rvbs09
               AND qcs14 = 'Y'
               AND qcs09 = '2'
            LET l_rvbs.rvbs06 = l_sum_rvbs06
            IF cl_null(l_rvbs.rvbs06) THEN LET l_rvbs.rvbs06 = 0 END IF
            IF l_rvbs.rvbs06 = 0 THEN  CONTINUE FOREACH END IF  ##TQC-CA0049 add
            LET l_rvbs.rvbs06 = l_rvbs.rvbs06 - l_rvbs.rvbs12
         END IF
#TQC-CA0049 -------------------- add ------------------ end
         LET l_rvbs.rvbs09 = -1     #TQC-B90236 add
         LET l_rvbs.rvbs10 = 0
      
         LET l_rvbs.rvbs11 = 0
      
         LET l_rvbs.rvbs12 = 0
         LET l_rvbs.rvbsplant = g_plant 
         LET l_rvbs.rvbslegal = g_legal 
      
         INSERT INTO rvbs_file VALUES(l_rvbs.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","rvbs_file",l_rvbs.rvbs01,l_rvbs.rvbs02,SQLCA.sqlcode,"","",1) 
            LET g_success = "N"
            CONTINUE FOREACH
         END IF
      
      END FOREACH
   END IF

   IF p_rvbs00 = "apmt722" THEN
      SELECT rvu116 INTO l_rvu116 FROM rvu_file WHERE rvu01=p_rvv01   #MOD-CB0229 add
      IF NOT cl_null(p_rvu02) THEN  
         FOREACH rvbs_curs720 INTO l_rvbs.*
            IF STATUS THEN
               CALL cl_err('foreach rvbs110:',STATUS,1)
               EXIT FOREACH
            END IF
         
            LET l_rvbs.rvbs00 = p_rvbs00
            LET l_rvbs.rvbs01 = p_rvv01
            LET l_rvbs.rvbs02 = p_rvv02 
         
            SELECT SUM(rvbs06) INTO l_rvbs06
              FROM rvbs_file,rvu_file,rvv_file  
             WHERE rvbs00 = "apmt722"
               AND rvv01 = rvbs01
               AND rvv02 = rvbs02
               AND rvv04 = p_rvv04 
               AND rvv05 = p_rvv05 
               AND rvbs03 = l_rvbs.rvbs03
               AND rvbs04 = l_rvbs.rvbs04
               AND rvbs08 = l_rvbs.rvbs08
               AND rvbs09 = 1
               AND rvu01 = rvv01 
               AND rvuconf <> "X" 
            IF cl_null(l_rvbs06) THEN LET l_rvbs06 = 0 END IF  
         
            LET l_rvbs.rvbs06 = l_rvbs.rvbs06 - l_rvbs06
            LET l_rvbs.rvbs09 = -1    #TQC-B90236 add
            LET l_rvbs.rvbsplant = g_plant
            LET l_rvbs.rvbslegal = g_legal 

            IF l_rvu116 = '3' THEN LET l_rvbs.rvbs06 = '0' END IF   #MOD-CB0229 add

            INSERT INTO rvbs_file VALUES(l_rvbs.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","rvbs_file",l_rvbs.rvbs01,l_rvbs.rvbs02,SQLCA.sqlcode,"","",1) 
               LET g_success = "N"
               CONTINUE FOREACH
            END IF
         END FOREACH
      ELSE
         LET l_cnt = 1
         FOREACH imgs_curs720 INTO l_imgs.*
            IF STATUS THEN
               CALL cl_err('foreach imgs720:',STATUS,1)
               EXIT FOREACH
            END IF
         
            LET l_rvbs.rvbs00 = p_rvbs00
            LET l_rvbs.rvbs01 = p_rvv01
            LET l_rvbs.rvbs02 = p_rvv02 
            LET l_rvbs.rvbs03 = l_imgs.imgs05 
            LET l_rvbs.rvbs04 = l_imgs.imgs06 
            LET l_rvbs.rvbs05 = l_imgs.imgs09 
            LET l_rvbs.rvbs06 = 0
            LET l_rvbs.rvbs07 = l_imgs.imgs10 
            LET l_rvbs.rvbs08 = l_imgs.imgs11 
            LET l_rvbs.rvbs09 = -1    #TQC-B90236 modify rvbs09=1 -> rvbs09=-1
            LET l_rvbs.rvbs021 = l_imgs.imgs01 
            LET l_rvbs.rvbs022 = l_cnt
            LET l_rvbs.rvbs10 = 0
            LET l_rvbs.rvbs11 = 0 
            LET l_rvbs.rvbs12 = 0 
            LET l_rvbs.rvbs13 = 0 
            LET l_rvbs.rvbsplant = g_plant 
            LET l_rvbs.rvbslegal = g_legal 
 
            INSERT INTO rvbs_file VALUES(l_rvbs.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","rvbs_file",l_rvbs.rvbs01,l_rvbs.rvbs02,SQLCA.sqlcode,"","",1) 
               LET g_success = "N"
               CONTINUE FOREACH
            END IF
            LET l_cnt = l_cnt + 1
         END FOREACH
      END IF
   END IF
     
   IF p_rvbs00 = "apmt730" THEN
      LET l_sql = "SELECT * FROM rvbs_file",
                  " WHERE rvbs00 = 'apmt200'",
                  "   AND rvbs01 = '",p_rvv04,"'",
                  "   AND rvbs02 = ",p_rvv05,
                  "   AND rvbs09 = 1"
      
      PREPARE t720_rvbs200 FROM l_sql
      
      DECLARE rvbs_curs200 CURSOR FOR t720_rvbs200
     
      FOREACH rvbs_curs200 INTO l_rvbs.*
         IF STATUS THEN
            CALL cl_err('foreach rvbs200:',STATUS,1)
            EXIT FOREACH
         END IF
      
         LET l_rvbs.rvbs00 = p_rvbs00
         LET l_rvbs.rvbs01 = p_rvv01
         LET l_rvbs.rvbs02 = p_rvv02 
      
         IF l_rvbs.rvbs10 > 0 THEN
            #異動數量=允收量-入庫量
            LET l_rvbs.rvbs06 = l_rvbs.rvbs10 - l_rvbs.rvbs11  
         END IF
         LET l_rvbs.rvbs09 = 1     #TQC-B90236 add
         LET l_rvbs.rvbs10 = 0

         LET l_rvbs.rvbs11 = 0

         LET l_rvbs.rvbs12 = 0
         
         LET l_rvbs.rvbsplant = g_plant
         LET l_rvbs.rvbslegal = g_legal 

         INSERT INTO rvbs_file VALUES(l_rvbs.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","rvbs_file",l_rvbs.rvbs01,l_rvbs.rvbs02,SQLCA.sqlcode,"","",1) 
            LET g_success = "N"
            CONTINUE FOREACH
         END IF
      
      END FOREACH
   END IF

   #MOD-B10171 add --start--
   IF p_rvbs00 = "apmt740" THEN
      LET l_sql = "SELECT * FROM rvbs_file",
                  " WHERE rvbs00 = 'apmt300'",
                  "   AND rvbs01 = '",p_rvv04,"'",
                  "   AND rvbs02 = ",p_rvv05,
                  "   AND rvbs09 = 1"
      
      PREPARE t720_rvbs300 FROM l_sql
      
      DECLARE rvbs_curs300 CURSOR FOR t720_rvbs300
     
      FOREACH rvbs_curs300 INTO l_rvbs.*
         IF STATUS THEN
            CALL cl_err('foreach rvbs300:',STATUS,1)
            EXIT FOREACH
         END IF
      
         LET l_rvbs.rvbs00 = p_rvbs00
         LET l_rvbs.rvbs01 = p_rvv01
         LET l_rvbs.rvbs02 = p_rvv02 
      
         IF l_rvbs.rvbs10 > 0 THEN
            #異動數量=允收量-入庫量
            LET l_rvbs.rvbs06 = l_rvbs.rvbs10 - l_rvbs.rvbs11  
         END IF
         LET l_rvbs.rvbs09 = 1     #TQC-B90236 add
         LET l_rvbs.rvbs10 = 0

         LET l_rvbs.rvbs11 = 0

         LET l_rvbs.rvbs12 = 0

         LET l_rvbs.rvbsplant = g_plant
         LET l_rvbs.rvbslegal = g_legal 

         INSERT INTO rvbs_file VALUES(l_rvbs.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","rvbs_file",l_rvbs.rvbs01,l_rvbs.rvbs02,SQLCA.sqlcode,"","",1) 
            LET g_success = "N"
            CONTINUE FOREACH
         END IF
      
      END FOREACH
   END IF
   #MOD-B10171 add --end--

   #MOD-B60036 add
   IF p_rvbs00 = "apmt742" THEN
      LET l_sql = "SELECT rvbs00,rvbs01,rvbs02,rvbs03,rvbs04,rvbs05,SUM(rvbs06),",
                  "       rvbs07,rvbs08,rvbs021,rvbs022,rvbs09,rvbs10,rvbs11,",
                  "       rvbs12 FROM rvbs_file,rvu_file,rvv_file,rvb_file",
                  " WHERE rvbs00 = 'apmt740'",
                  "   AND rvbs01 = rvv01 ",
                  "   AND rvbs02 = rvv02 ",
                  "   AND rvu01 = rvv01 ",
                  "   AND rvuconf <> 'X' ",
                  "   AND rvv04 = rvb01 ",
                  "   AND rvv05 = rvb02 ",
                  "   AND rvb01 = '",p_rvv04,"'",
                  "   AND rvb02 = ",p_rvv05,
                  "   AND rvbs09 = 1",
                  " GROUP BY rvbs00,rvbs01,rvbs02,rvbs03,rvbs04,rvbs05,rvbs07,",
                  "          rvbs08,rvbs021,rvbs022,rvbs09,rvbs10,rvbs11,rvbs12"

      PREPARE t720_rvbs740 FROM l_sql

      DECLARE rvbs_curs740 CURSOR FOR t720_rvbs740

      FOREACH rvbs_curs740 INTO l_rvbs.*
         IF STATUS THEN
            CALL cl_err('foreach rvbs110:',STATUS,1)
            EXIT FOREACH
         END IF

         LET l_rvbs.rvbs00 = p_rvbs00
         LET l_rvbs.rvbs01 = p_rvv01
         LET l_rvbs.rvbs02 = p_rvv02

         SELECT SUM(rvbs06) INTO l_rvbs06
           FROM rvbs_file,rvu_file,rvv_file
          WHERE rvbs00 = "apmt742"
            AND rvv01 = rvbs01
            AND rvv02 = rvbs02
            AND rvv04 = p_rvv04
            AND rvv05 = p_rvv05
            AND rvbs03 = l_rvbs.rvbs03
            AND rvbs04 = l_rvbs.rvbs04
            AND rvbs08 = l_rvbs.rvbs08
            AND rvbs09 = 1
            AND rvu01 = rvv01
            AND rvuconf <> "X"
         IF cl_null(l_rvbs06) THEN LET l_rvbs06 = 0 END IF

         LET l_rvbs.rvbs06 = l_rvbs.rvbs06 - l_rvbs06
         LET l_rvbs.rvbs09 = -1    #TQC-B90236 add
         LET l_rvbs.rvbsplant = g_plant
         LET l_rvbs.rvbslegal = g_legal
         INSERT INTO rvbs_file VALUES(l_rvbs.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","rvbs_file",l_rvbs.rvbs01,l_rvbs.rvbs02,SQLCA.sqlcode,"","",1)
            LET g_success = "N"
            CONTINUE FOREACH
         END IF
      END FOREACH
   END IF
   #MOD-B60036 add end

END FUNCTION

FUNCTION t720sub_s1(l_rvu,p_argv3,p_argv1,p_rva00)    #確認
  DEFINE p_rvu01  LIKE rvu_file.rvu01
  DEFINE l_msg    LIKE type_file.chr1000, 
         l_cnt    LIKE type_file.num5,   
         l_pmn41  LIKE pmn_file.pmn41,  #W/O
         l_pmn43  LIKE pmn_file.pmn43,  #製程序
         l_pmn18  LIKE pmn_file.pmn18,
         l_pmn32  LIKE pmn_file.pmn32,
         l_pmm04  LIKE pmm_file.pmm04
DEFINE l_rvbs06 LIKE rvbs_file.rvbs06   
DEFINE l_status LIKE type_file.chr1 
DEFINE l_flag   LIKE type_file.num5
DEFINE l_type   LIKE type_file.num5
DEFINE l_t1     LIKE oay_file.oayslip
DEFINE l_rvv    RECORD LIKE rvv_file.*
DEFINE l_rvvi   RECORD LIKE rvvi_file.*
DEFINE l_rvu    RECORD LIKE rvu_file.*
DEFINE p_argv3  LIKE rvu_file.rvu08
DEFINE l_ima25  LIKE ima_file.ima25
DEFINE p_argv1  LIKE rvu_file.rvu00
DEFINE l_ima918 LIKE ima_file.ima918
DEFINE l_ima921 LIKE ima_file.ima921
DEFINE l_str    STRING
DEFINE p_rva00  LIKE rva_file.rva00
DEFINE l_sfbiicd16   LIKE sfbi_file.sfbiicd16 #FUN-AA0007
DEFINE l_sfbiicd17   LIKE sfbi_file.sfbiicd17 #FUN-AA0007
DEFINE l_idc18       LIKE idc_file.idc18        #FUN-AB0092
DEFINE l_imaicd04    LIKE imaicd_file.imaicd04  #FUN-AB0092
DEFINE l_rvbs09      LIKE rvbs_file.rvbs09      #TQC-B90236   
DEFINE l_img09       LIKE img_file.img09        #CHI-C30064 add
DEFINE l_rvv35_fac   LIKE rvv_file.rvv35_fac    #CHI-C30064 add
DEFINE l_rvbs00      LIKE rvbs_file.rvbs00      #TQC-CA0049 add
DEFINE l_ima930      LIKE ima_file.ima930       #DEV-D30040 add
  CALL s_showmsg_init()   

   IF g_aza.aza71 MATCHES '[Yy]' THEN   #判斷是否有勾選〝與GPM整合〞，有則做GPM控管 
      CALL cl_load_act_sys(NULL)
      LET l_t1 = s_get_doc_no(l_rvu.rvu01) 
      SELECT * INTO g_smy.* FROM smy_file
       WHERE smyslip=l_t1
      IF NOT cl_null(g_smy.smy64) THEN                                                                                   
         IF g_smy.smy64 != '0' THEN    #要控管GPM
	          CALL aws_gpmcli_part(l_rvu.rvu01,l_rvu.rvu04,'','8')
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
      END IF
      CALL g_err_msg.clear() 
   END IF    


   DECLARE t720_s1_c CURSOR FOR SELECT * FROM rvv_file
                                WHERE rvv01 = l_rvu.rvu01

   FOREACH t720_s1_c INTO l_rvv.*
      IF STATUS THEN
         LET g_success = 'N' 
         EXIT FOREACH
      END IF
      IF s_industry('icd') THEN
         SELECT * INTO l_rvvi.* FROM rvvi_file 
          WHERE rvvi01 = l_rvv.rvv01
            AND rvvi02 = l_rvv.rvv02
         #排除委外TKY非最終站的資料
         IF l_rvvi.rvviicd07 = 'Y' THEN CONTINUE FOREACH END IF
      END IF

      SELECT ima918,ima921,ima930 INTO l_ima918,l_ima921,l_ima930 #DEV-D30040 add ima930,l_ima930 
        FROM ima_file
       WHERE ima01 = l_rvv.rvv31
         AND imaacti = "Y"
      
      IF cl_null(l_ima930) THEN LET l_ima930 = 'N' END IF  #DEV-D30040 add

      IF l_rvu.rvu116 <> '3' OR cl_null(l_rvu.rvu116) THEN   #MOD-CB0229 add
         IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
   #TQC-B90236  ----add---begin
            IF l_rvu.rvu00='1' THEN 
               LET l_rvbs09 = 1
            ELSE
               LET l_rvbs09 = -1
            END IF 
   #TQC-B90236  ----end--
            #IF g_sma.sma90 = "Y" THEN #MOD-C30074 add #MOD-C40098 mark
            IF NOT (g_sma.sma90 = 'N' AND l_rvu.rvu00 = '2') THEN  #MOD-C40098 add
   #TQC-CA0049 ------------- add ---------------  begin  #自动产生入库或者验退的时候会报aim-011的bug
               IF g_prog = 'apmt110' THEN
                  IF l_rvu.rvu00 = '2'THEN
                     LET l_rvbs00 = 'apmt721'
                  ELSE
                     LET l_rvbs00 = 'apmt720'
                  END IF
               ELSE
                  LET l_rvbs00 = g_prog
               END IF
   #TQC-CA0049 ------------- add ---------------  end
               SELECT SUM(rvbs06) INTO l_rvbs06
                 FROM rvbs_file
                WHERE rvbs00 = l_rvbs00          #TQC-CA0049 modify g_prog -> l_rvbs00
                  AND rvbs01 = l_rvv.rvv01       #MOD-B40007   #MOD-B80041 remark
                  AND rvbs02 = l_rvv.rvv02       #MOD-B40007   #MOD-B80041 remark
   #              AND rvbs01 = l_rvv.rvv04       #MOD-B40007   #MOD-B80041
   #              AND rvbs02 = l_rvv.rvv05       #MOD-B40007   #MOD-B80041
                  AND rvbs13 = 0
                # AND rvbs09 = 1                 #TQC-B90236 mark 
                  AND rvbs09 = l_rvbs09          #TQC-B90236 add  
               IF cl_null(l_rvbs06) THEN
                  LET l_rvbs06 = 0
               END IF
    
           #   CHI-C30064---Start---add
               SELECT img09 INTO l_img09 FROM img_file
                WHERE img01= l_rvv.rvv31 AND img02= l_rvv.rvv32 
                  AND img03= l_rvv.rvv33 AND img04= l_rvv.rvv34
               CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv35,l_img09) RETURNING l_cnt,l_rvv35_fac
               IF l_cnt = '1' THEN LET l_rvv35_fac = 1 END IF             
           #   CHI-C30064---End---add  
           #   IF (l_rvv.rvv17 * l_rvv.rvv35_fac) <> l_rvbs06 THEN
               IF (l_ima930 = 'Y' and l_rvbs06 <> 0) OR l_ima930 = 'N' THEN  #DEV-D30040
                  IF (l_rvv.rvv17 * l_rvv35_fac) <> l_rvbs06 THEN #CHI-C30064
                     LET g_success = "N"
                     CALL cl_err(l_rvv.rvv31,"aim-011",1)
                     CONTINUE FOREACH
                  END IF
               END IF                                                        #DEV-D30040
            END IF #MOD-C30074 add
         END IF
      END IF   #MOD-CB0229 

      IF l_rvv.rvv31[1,4] <> 'MISC' THEN 
         LET l_cnt=0
         SELECT COUNT(*) INTO l_cnt FROM img_file
          WHERE img01 = l_rvv.rvv31   #料號
            AND img02 = l_rvv.rvv32   #倉庫
            AND img03 = l_rvv.rvv33   #儲位
            AND img04 = l_rvv.rvv34   #批號
            AND img18 < l_rvu.rvu03
         IF l_cnt > 0 THEN    #大於有效日期
            call cl_err(l_rvv.rvv32,'aim-400',0)   #須修改
            LET g_success = 'N'
            RETURN
         END IF
      END IF 

      LET l_pmm04 =''
      IF NOT cl_null(l_rvv.rvv36) THEN 
         SELECT pmm04 INTO l_pmm04 FROM pmm_file
          WHERE pmm01 = l_rvv.rvv36
         IF STATUS OR l_pmm04 > l_rvu.rvu03 THEN
            #入庫日期不可小於採購單據日期
            CALL cl_err3("sel","pmm_file",l_rvv.rvv36,"","apm-412","","",1)  
            LET g_success = 'N'
            EXIT FOREACH
         END IF
      END IF

      ## 當為製程委外時不寫 tlf,不 update ima,img ---------
      IF l_rvu.rvu08='SUB' THEN
         SELECT pmn41,pmn43,pmn18,pmn32
           INTO l_pmn41,l_pmn43,l_pmn18,l_pmn32
           FROM pmn_file
          WHERE pmn01 = l_rvv.rvv36
            AND pmn02 = l_rvv.rvv37
         IF STATUS THEN
            CALL cl_err3("sel","pmn_file",l_rvv.rvv36,l_rvv.rvv37,STATUS,"","sel pmn_file",1) 
            LET g_success='N'
            RETURN
         END IF
         IF (NOT cl_null(l_pmn41) AND l_pmn43>0) OR   #W/O<>'' &製程序>0
            (NOT cl_null(l_pmn18) AND l_pmn32>0) THEN #RUN<>'' &製程序>0
            CALL t720sub_u_rvb('y',l_rvu.*,l_rvv.*,p_argv1)  #->更新驗收單單身檔
            CALL t720sub_u_pmn(l_rvv.*,l_rvvi.rvviicd07)     #->更新採購單單身檔
            CONTINUE FOREACH
         END IF
      END IF

      IF l_rvv.rvv31 IS NULL THEN LET  l_rvv.rvv31 = ' ' END IF   #料
      IF cl_null(l_rvv.rvv32) AND l_rvv.rvv31[1,4] <> 'MISC' AND l_rvu.rvu00<>'2' 
         AND NOT (l_rvu.rvu00='3' AND l_rvv.rvv17=0) THEN   #MOD-A40166
         CALL cl_err(l_rvv.rvv31,'apm-259',1)
         LET g_success='N'
         RETURN
      END IF
      IF l_rvv.rvv33 IS NULL THEN LET  l_rvv.rvv33 = ' ' END IF   #儲
      IF l_rvv.rvv34 IS NULL THEN LET  l_rvv.rvv34 = ' ' END IF   #批
      LET l_str = '_s1() read no:',l_rvv.rvv02 USING '#####&','--> parts:',l_rvv.rvv31
      CALL cl_msg(l_str)

      IF g_bgjob='N' OR cl_null(g_bgjob) THEN    #FUN-A50001 add
        CALL ui.Interface.refresh()
      END IF                                     #FUN-A50001 add

      IF cl_null(l_rvv.rvv04) AND l_rvu.rvu00='1' THEN
         CALL cl_err('receive number is empty!','',1)
         LET g_success='N'
         CONTINUE FOREACH
      END IF
      IF l_rvu.rvu00 !='1' AND l_rvv.rvv31[1,4]!='MISC' THEN
         SELECT ima25 INTO l_ima25 FROM ima_file
          WHERE ima01=l_rvv.rvv31
      END IF

      CASE
        WHEN l_rvu.rvu00='1'   # 異動類別:1.入庫
             IF l_rvv.rvv31[1,4]<>'MISC' THEN
                LET l_cnt = 0
                SELECT COUNT(*) INTO l_cnt FROM img_file
                 WHERE img01=l_rvv.rvv31 AND img02=l_rvv.rvv32
                   AND img03=l_rvv.rvv33 AND img04=l_rvv.rvv34
                IF l_cnt=0 THEN
                   LET l_msg=l_rvv.rvv31 CLIPPED,'-',l_rvv.rvv32 CLIPPED,
                             '-',l_rvv.rvv33 CLIPPED
                   CALL cl_err(l_msg,'apm-259',1)
                   LET g_success='N'  EXIT FOREACH RETURN
                END IF
             END IF
             CALL t720sub_t1(l_rvv.*,l_rvu.*,p_argv1,p_rva00)
             IF s_industry('icd') THEN
                LET l_type=1
             END IF
        WHEN l_rvu.rvu00='2'   #2.驗退
             CALL t720sub_uh(1,l_rvv.*,p_argv1,l_rvu.*) 
             CALL t720sub_log(l_rvv.*,l_rvu.rvu00,l_rvu.rvu08,l_ima25,p_rva00)
             CALL t720sub_update_tlff(l_rvv.*,l_rvu.rvu00,l_rvu.rvu08)
             IF s_industry('icd') THEN
                LET l_type=0
             END IF
        WHEN l_rvu.rvu00='3'   #3.倉退
             CALL t720sub_bu(l_rvu.*,l_rvv.*,p_argv1,l_ima25,p_rva00)
             IF s_industry('icd') THEN
                LET l_type=-1
             END IF
      END CASE
      IF s_industry('icd') THEN
         #TQC-B80005 --START--
         SELECT * INTO l_rvvi.* FROM rvvi_file
          WHERE rvvi01 = l_rvv.rvv01 AND rvvi02 = l_rvv.rvv02  
         #TQC-B80005 --END--
         #IF p_argv3<>'TAP' AND l_type IS NOT NULL THEN  #FUN-B90012
         IF l_type IS NOT NULL THEN                      #FUN-B90012
            IF NOT (l_rvu.rvu116='3' AND l_rvu.rvu00 = '3') THEN  #CHI-C60028
               CALL s_icdpost(l_type,l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,
                               l_rvv.rvv34,l_rvv.rvv35,l_rvv.rvv17,
                               l_rvv.rvv01,l_rvv.rvv02,
                               l_rvu.rvu03,'Y',l_rvv.rvv04,l_rvv.rvv05
                               ,l_rvvi.rvviicd05,l_rvvi.rvviicd02,'') #FUN-B30187 #TQC-B80005  #FUN-B80119--傳入p_plant參數''---
                 RETURNING l_flag
               IF l_flag = 0 THEN
                  LET g_success = 'N'
               #FUN-AA0007--begin--add---------------
               ELSE
                  IF NOT cl_null(l_rvv.rvv18) THEN
                    SELECT sfbiicd16,sfbiicd17 INTO l_sfbiicd16,l_sfbiicd17
                      FROM sfbi_file
                     WHERE sfbi01=l_rvv.rvv18
                     LET l_cnt=0
                     IF NOT cl_null(l_sfbiicd16) AND NOT cl_null(l_sfbiicd17) THEN
                       #SELECT count(*) INTO l_cnt FROM sfv_file,idc_file  #FUN-AB0092
                        SELECT DISTINCT idc18 INTO l_idc18 FROM rvv_file,idc_file  #FUN-AB0092
                         WHERE rvv01=l_sfbiicd16
                           AND rvv02=l_sfbiicd17
                           AND rvv31=idc01 AND rvv32=idc02
                           AND rvv33=idc03 AND rvv34=idc04
                          #AND idc18='Y'  #FUN-AB0092
                        SELECT imaicd04 INTO l_imaicd04 FROM imaicd_file WHERE imaicd00=l_rvv.rvv31  #FUN-AB0092
                       #IF l_cnt > 0 THEN   #FUN-AB0092
                        IF l_idc18 = l_imaicd04 AND l_idc18 <> 'N' THEN    #FUN-AB0092
                           UPDATE idc_file SET idc17='Y'
                            WHERE idc01=l_rvv.rvv31 AND idc02=l_rvv.rvv32
                              AND idc03=l_rvv.rvv33 AND idc04=l_rvv.rvv34
                           IF SQLCA.sqlcode THEN
                              CALL cl_err('upd idc:',SQLCA.sqlcode,1)
                              LET g_success ='N'
                           END IF
                        END IF
                        #FUN-AB0092--begin--add-------------
                        IF l_idc18 <>'N' AND l_idc18 <> l_imaicd04 THEN
                           UPDATE idc_file 
                              SET idc18 = l_idc18
                            WHERE idc01=l_rvv.rvv31 
                              AND idc02=l_rvv.rvv32
                              AND idc03=l_rvv.rvv33 
                              AND idc04=l_rvv.rvv34
                           IF SQLCA.sqlcode THEN
                              CALL cl_err('upd idc18:',SQLCA.sqlcode,1)
                              LET g_success ='N'
                           END IF
                        END IF
                        #FUN-AB0092--end--add---------------
                     END IF
                  END IF 
               END IF 
            END IF  #CHI-C60028
            #FUN-AA0007--end--add------------------
          END IF
      END IF
      IF g_success='N' THEN
          LET g_totsuccess="N"
          LET g_success="Y"
          CONTINUE FOREACH 
      END IF
  END FOREACH

  IF g_totsuccess="N" THEN
     LET g_success="N"
  END IF

   CALL s_showmsg()  

END FUNCTION

FUNCTION t720sub_u_pmn(l_rvv,p_rvviicd07)                           #更新P/O已交貨量
 DEFINE l_pmn53 LIKE pmn_file.pmn53
 DEFINE l_pmn51 LIKE pmn_file.pmn51
 DEFINE l_rvv17 LIKE rvv_file.rvv17
 DEFINE l_pmn50 LIKE pmn_file.pmn50
 DEFINE l_pmn55 LIKE pmn_file.pmn55
 DEFINE l_rvv   RECORD LIKE rvv_file.*
 DEFINE p_rvviicd07 LIKE rvvi_file.rvviicd07
 DEFINE l_rvu00   LIKE rvu_file.rvu00
 DEFINE l_rvu08   LIKE rvu_file.rvu08
   
   #Add by zm 131121
   SELECT rvu00,rvu08 INTO l_rvu00,l_rvu08 FROM rvu_file 
    WHERE rvu01=l_rvv.rvv01
   IF l_rvu00='3' AND l_rvu08='SUB' THEN RETURN END IF  
   #End by zm 131121

#-->更新採購單單身檔 ----------------------------------------------
   IF cl_null(l_rvv.rvv36) OR cl_null(l_rvv.rvv37) THEN
      RETURN
   END IF

   IF s_industry('icd') THEN
     #判斷若為委外收貨單TKY,非最後一站的項次,不更新收貨資料
      IF p_rvviicd07 = 'Y' THEN RETURN END IF
   END IF
   IF l_rvv.rvv25='N' THEN
      IF s_industry('icd') THEN
         SELECT SUM(rvb30),SUM(rvb07-rvb29-rvb30),SUM(rvb07),SUM(rvb29)
           INTO l_pmn53,l_pmn51,l_pmn50,l_pmn55
           FROM rvb_file,rva_file,rvbi_file        #計算入庫量,在驗量
          WHERE rvb04=l_rvv.rvv36 AND rvb03=l_rvv.rvv37
            AND rvaconf='Y' AND rvb01=rva01 AND rvb35='N'
            AND rvbi01=rvb01 AND rvbi02=rvb02
          #委外TKY,非最終站的數量不納入
            AND (rvbiicd13 = 'N' OR rvbiicd13 IS NULL OR rvbiicd13 = ' ')
         SELECT SUM(rvv17) INTO l_rvv17     #計算此採購單對應之倉退量
           FROM rvv_file,rvu_file,rvvi_file
          WHERE rvv37=l_rvv.rvv37 AND rvv36=l_rvv.rvv36
            AND rvv25='N' AND rvuconf='Y' AND rvu01=rvv01
            AND rvu00='3'  #倉退
            AND rvvi01=rvv01 AND rvvi02=rvv02
           #委外TKY,非最終站的數量不納入
            AND (rvviicd07 = 'N' OR rvviicd07 IS NULL OR rvviicd07 = ' ')
     ELSE
        SELECT SUM(rvb30),SUM(rvb07-rvb29-rvb30),SUM(rvb07),SUM(rvb29)
          INTO l_pmn53,l_pmn51,l_pmn50,l_pmn55
          FROM rvb_file,rva_file        #計算入庫量,在驗量
         WHERE rvb04=l_rvv.rvv36 AND rvb03=l_rvv.rvv37
           AND rvaconf='Y' AND rvb01=rva01 AND rvb35='N'
        SELECT SUM(rvv17) INTO l_rvv17     #計算此採購單對應之倉退量
          FROM rvv_file,rvu_file
         WHERE rvv37=l_rvv.rvv37 AND rvv36=l_rvv.rvv36
           AND rvv25='N' AND rvuconf='Y' AND rvu01=rvv01
           AND rvu00='3'  #倉退
     END IF

     IF cl_null(l_pmn53) THEN LET l_pmn53=0 END IF
     IF cl_null(l_pmn51) THEN LET l_pmn51=0 END IF
     IF cl_null(l_pmn50) THEN LET l_pmn50=0 END IF
     IF cl_null(l_pmn55) THEN LET l_pmn55=0 END IF
     IF cl_null(l_rvv17) THEN LET l_rvv17=0 END IF

     UPDATE pmn_file
        SET pmn53=l_pmn53,            #入庫量
            pmn51=l_pmn51,            #在驗量
            pmn50=l_pmn50,            #收貨量
            pmn55=l_pmn55             #驗退量
      WHERE pmn01 = l_rvv.rvv36 AND pmn02 = l_rvv.rvv37
     IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL cl_err3("upd","pmn_file",l_rvv.rvv36,"",SQLCA.sqlcode,"","upd pmn53,51 s2:",1)  
         RETURN
     END IF
   END IF
END FUNCTION

FUNCTION t720sub_t1(l_rvv,l_rvu,p_argv1,p_rva00)
   DEFINE l_k             LIKE type_file.num10,   #No.FUN-680136 INTEGER
          l_rvb10         LIKE rvb_file.rvb10,
          l_rvb04         LIKE rvb_file.rvb04, 
          l_rvb29         LIKE rvb_file.rvb29,
          l_rvb33         LIKE rvb_file.rvb33,
          l_rvb39         LIKE rvb_file.rvb39,
          l_sfb05         LIKE sfb_file.sfb05,
          l_ima25         LIKE ima_file.ima25,
          l_ima55         LIKE ima_file.ima55,
          l_pmm02         LIKE pmm_file.pmm02,    #採購單性質
          l_img23         LIKE img_file.img23,    #
          l_img24         LIKE img_file.img24,    #
          l_img30         LIKE img_file.img30,    #直接材料成本
          l_img31         LIKE img_file.img31,    #間接材料成本
          l_img30_update  LIKE img_file.img30,    #更新img30的值
          l_img31_update  LIKE img_file.img31,    #更新img31的值
          l_ima71         LIKE ima_file.ima71,    #有效天數
          l_ima86         LIKE ima_file.ima86,    #成本單位
          l_ima871        LIKE ima_file.ima871,   #間接物料分攤率
          l_unavl_stk     LIKE type_file.num15_3,
          l_avl_stk       LIKE type_file.num15_3,
          l_avl_stk_mpsmrp LIKE type_file.num15_3,
          l_ima91         LIKE ima_file.ima91,    #平均採購單價
          l_ima44_fac     LIKE ima_file.ima44_fac,#採購單位/庫存單位轉換率
          l_ima86_fac     LIKE ima_file.ima86_fac,#成本/庫存單位轉換率
          l_pmn09         LIKE pmn_file.pmn09,    #轉換因子
          l_pmn07         LIKE pmn_file.pmn07,    #採購單位
          l_pmn44         LIKE pmn_file.pmn44,    #本幣單價
          l_imaqty        LIKE img_file.img08,    #
          l_pmn65         LIKE pmn_file.pmn65,    #
          l_ima906        LIKE ima_file.ima906,   #No.FUN-540027
          l_cmd           LIKE type_file.chr1000, #No.FUN-680136 CHAR(100)
          l_pmn46         LIKE pmn_file.pmn46,
          l_factor        LIKE ima_file.ima31_fac,#No.FUN-680136 DEC(16,8)
          l_factor1       LIKE ima_file.ima31_fac,#No.FUN-680136 DEC(16,8)
          l_cost          LIKE oeb_file.oeb13,    #No.FUN-680136 DECIMAL(20,6)  #加權平均單價 #FUN-4C0011
          l_ss            LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          l_qty           LIKE sfh_file.sfh06,
          l_pmm42         LIKE pmm_file.pmm42   #MOD-920018 
   DEFINE l_rvv           RECORD LIKE rvv_file.*
   DEFINE l_sfb           RECORD LIKE sfb_file.*
   DEFINE l_cnt           LIKE type_file.num10
   DEFINE l_rvu           RECORD LIKE rvu_file.*
   DEFINE p_argv1         LIKE rvu_file.rvu00
   DEFINE l_img10         LIKE img_file.img10
   DEFINE l_img26         LIKE img_file.img26
   DEFINE l_rva114        LIKE rva_file.rva114
   DEFINE l_pmm43         LIKE pmm_file.pmm43 
   DEFINE p_rva00         LIKE rva_file.rva00
   DEFINE l_forupd_sql    STRING,
	  l_ima01         LIKE ima_file.ima01,
	  l_ima908        LIKE ima_file.ima908,  #MOD-A40063
	  l_ima44         LIKE ima_file.ima44    #MOD-A40063
   DEFINE l_sfa012 LIKE sfa_file.sfa012    #FUN-A60027 
   DEFINE l_sfa013 LIKE sfa_file.sfa013    #FUN-A60027 
   DEFINE l_cnt1          LIKE type_file.num5    #CHI-B40023
   DEFINE l_sfa06         LIKE sfa_file.sfa06   #No.FUN-BB0086
   DEFINE l_sfb93         LIKE sfb_file.sfb93   #TQC-C30193
   DEFINE l_tky_cnt       LIKE type_file.num5   #TQC-C30193
   DEFINE l_qty1          LIKE type_file.num10   #FUN-C30307
	   #------>多倉管理時更新庫存明細檔
	   IF l_rvv.rvv31[1,4] = 'MISC' THEN
	      CALL t720sub_u_rvb('y',l_rvu.*,l_rvv.*,p_argv1)  #->更新驗收單單身檔
	      IF p_rva00 = '1' THEN
		 CALL t720sub_u_pmn(l_rvv.*,'')     #->更新採購單單身檔
	      END IF
	      RETURN
	   ELSE
	      IF p_rva00 = '1' THEN
		 SELECT pmm02 INTO l_pmm02 FROM pmm_file WHERE pmm01 = l_rvv.rvv36
	 
		 IF SQLCA.sqlcode THEN
		    CALL cl_err('sel pmm:',SQLCA.sqlcode,1)
		    LET g_success ='N' RETURN
		 END IF
	      END IF

	      IF g_sma.sma12 = 'Y' THEN     #多倉管理
		 #-----------------------------------------------------------------
		 # Update 加權平均單價 ima91 (必須在尚未 Call udima 前先做)
		 #    [原加權平均單價*(庫存可用量+庫存不可用量)]+(入庫量*本幣單價)
		 #                       (庫存可用量+庫存不可用量)+(入庫量*轉換因子)
		 #-----------------------------------------------------------------
		 #SELECT ima91,ima261,ima262 INTO l_ima91,l_ima261,l_ima262 #FUN-A20044
		 #SELECT ima91 INTO l_ima91 #FUN-A20044   #MOD-A40063
		 SELECT ima91,ima908,ima44,ima25 INTO l_ima91,l_ima908,l_ima44,l_ima25 #FUN-A20044   #MOD-A40063
		   FROM ima_file
		  WHERE ima01 = l_rvv.rvv31
		 CALL s_getstock(l_rvv.rvv31,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk 
		 IF SQLCA.sqlcode THEN
#		     CALL cl_err3("sel","pmm_file",l_rvv.rvv36,"",SQLCA.sqlcode,"","sel pmm:",1)    #MOD-B50223 mark
                    CALL cl_err3("sel","ima_file",l_rvv.rvv31,"",SQLCA.sqlcode,"","sel ima:",1)     #MOD-B50223
		    LET g_success = 'N'
		 END IF
		 IF p_rva00 = '1' THEN
		    SELECT pmn07,pmn09,pmn44,pmn65 INTO l_pmn07,l_pmn09,l_pmn44,l_pmn65
		      FROM pmn_file
		     WHERE pmn01 = l_rvv.rvv36
		       AND pmn02 = l_rvv.rvv37
		    IF SQLCA.sqlcode THEN
		       CALL cl_err3("sel","pmn_file",l_rvv.rvv36,l_rvv.rvv37,SQLCA.sqlcode,"","Select pmn44:",1)
		       LET g_success = 'N'
		    END IF
		 ELSE
		    SELECT rva114 INTO l_rva114 FROM rva_file WHERE rva01 = l_rvv.rvv04
		    IF l_rva114 IS NULL THEN LET l_rva114 = 0 END IF
		    SELECT rvb10,rvb90,rvb90_fac INTO l_rvb10,l_pmn07,l_pmn09
			FROM rvb_file
		      WHERE rvb01 = l_rvv.rvv04
			AND rvb02 = l_rvv.rvv05
		    IF l_rvb10 IS NULL THEN LET l_rvb10 = 0 END IF
		    LET l_pmn65 = '1'
		    LET l_pmn44 = cl_digcut(l_rvb10*l_rva114,g_azi03) 
		 END IF

		 SELECT rvb10,rvb04 INTO l_rvb10,l_rvb04 FROM rvb_file 
		  WHERE rvb01 = l_rvv.rvv04
		    AND rvb02 = l_rvv.rvv05
		 IF SQLCA.sqlcode THEN
		    CALL cl_err3("sel","rvb_file",l_rvv.rvv04,l_rvv.rvv05,SQLCA.sqlcode,"","Select rvb10",1) 
		    LET g_success = 'N'
		 END IF

		 IF p_rva00 = '1' THEN
		    SELECT pmm42 INTO l_pmm42 FROM pmm_file
		       WHERE pmm01 = l_rvb04 
		 ELSE
		    SELECT rva114 INTO l_pmm42 FROM rva_file WHERE rva01 = l_rvv.rvv04
		 END IF
		 IF STATUS THEN
		    LET l_pmm42 = 1
		 END IF
		 IF cl_null(l_pmm42) THEN
		    LET l_pmm42 = 1
		 END IF  

		 SELECT rvb33,rvb39 INTO l_rvb33,l_rvb39 FROM rvb_file    #允收數量
		  WHERE rvb01 = l_rvv.rvv04
		    AND rvb02 = l_rvv.rvv05

		 IF cl_null(l_rvb33) THEN
		    LET l_rvb33 = 0
		 END IF  

		 IF l_rvb39 = 'Y' THEN   #--檢驗否(Y/N) #no.7143
		    IF l_rvb33 < l_rvv.rvv17 THEN
		       IF g_qcz.qcz05 = 'N' THEN                           #No.8939
			  #入庫數量不可大於允收數量!
			  CALL cl_err(l_rvv.rvv31,'apm-282',1)
			  LET g_success='N'
		       END IF                                              #No.8939
		    END IF
		 END IF

		 IF l_rvv.rvv17=0 THEN     #入庫數量
		    LET l_cost=0
		 ELSE
		    #-----MOD-A40063---------    
		    #LET l_cost = ((l_ima91*(l_ima261+l_ima262))+(l_rvv.rvv17
		    #              * l_pmn44))/((l_ima261+l_ima262)+
		    #              (l_rvv.rvv17*l_rvv.rvv35_fac*l_pmn09))
		    IF cl_null(l_ima908) THEN LET l_ima908 = l_ima44 END IF
		    IF g_sma.sma116 MATCHES '[13]' THEN 
		       LET l_ima44 = l_ima908
		    END IF
		    CALL s_umfchk(l_rvv.rvv31,l_ima25,l_ima44)
			  RETURNING l_cnt,l_factor
		    IF l_cnt THEN
		       LET l_factor = 1
		    END IF
		    LET l_cost = ((l_ima91*((l_unavl_stk+l_avl_stk)*l_factor))+
				  (l_pmn44*(l_rvv.rvv17*l_rvv.rvv35_fac*l_factor)))/
				 (((l_unavl_stk+l_avl_stk)*l_factor)+
				 (l_rvv.rvv17*l_rvv.rvv35_fac*l_factor))
		    #-----END MOD-A40063-----
		 END IF

		 IF cl_null(l_cost) THEN
		    LET l_cost = 0
		 END IF
#        	 LET l_forupd_sql="SELECT ima FROM ima_file",    #TQC-A50034 
		 LET l_forupd_sql="SELECT ima01 FROM ima_file",  #TQC-A50034
				  " WHERE ima01= ? FOR UPDATE " 
		 LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)         
		 DECLARE ima_lock CURSOR FROM l_forupd_sql 
		 OPEN ima_lock USING l_rvv.rvv31
		 IF SQLCA.sqlcode THEN
		    CALL cl_err('lock ima fail',STATUS,1) 
		    LET g_success = 'N'
		    RETURN
		 END IF
		 FETCH ima_lock INTO l_ima01
		 IF SQLCA.sqlcode THEN
            CALL cl_err('lock ima fail',STATUS,1) 
            LET g_success = 'N'
            RETURN
         END IF
   
         UPDATE ima_file SET ima91 = l_cost,imadate=g_today       #FUN-D10063 add imadate=g_today
          WHERE ima01 = l_rvv.rvv31
         IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0  THEN
            CALL cl_err3("upd","ima_file",l_rvv.rvv31,"",SQLCA.sqlcode,"","Update ima91 fail:",1)  
            LET g_success = 'N'
         END IF

         #--------------------------------------------------------------
         # Update 現時採購成本,標準採購成本
         #                             料件庫存           成  本
         # 採購成本 = 採購單價(本幣) * ──── 轉換率 * ──── 轉換率
         #                              採  購           料件庫存
         #--------------------------------------------------------------
         SELECT ima25,ima91,ima44_fac,ima86,ima86_fac
           INTO l_ima25,l_ima91,l_ima44_fac,l_ima86,l_ima86_fac
           FROM ima_file
          WHERE ima01 = l_rvv.rvv31

         IF g_sma.sma25 = '1' THEN
            LET l_cost = l_ima91 / l_ima44_fac * l_ima86_fac
            IF cl_null(l_cost) THEN
               LET l_cost = 0
            END IF
            #-----CHI-B40023---------
            LET l_cnt1 = 0 
            SELECT COUNT(*) INTO l_cnt1 FROM imb_file
              WHERE imb01 = l_rvv.rvv31
            IF cl_null(l_cnt1) THEN LET l_cnt1 = 0 END IF
            IF l_cnt1 = 0 THEN
               CALL t720_insimb(l_rvv.rvv31,l_cost) 
            ELSE
            #-----END CHI-B40023-----
              #UPDATE imb_file SET imb118 = l_cost,imadate=g_today       #FUN-D10063 add imadate=g_today #MOD-D20109 mark
               UPDATE imb_file SET imb118 = l_cost                       #MOD-D20109 add
                WHERE imb01 = l_rvv.rvv31
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
                   CALL cl_err3("upd","imb_file",l_rvv.rvv31,"","apm-720","","",1) 
                  LET g_success = 'N'
               END IF
            END IF   #CHI-B40023
         END IF

         IF g_sma.sma25 = '2' THEN
            LET l_cost = l_rvb10 * l_pmm42 / l_ima44_fac * l_ima86_fac   
            IF cl_null(l_cost) THEN
               LET l_cost = 0
            END IF

            #-----CHI-B40023---------
            LET l_cnt1 = 0 
            SELECT COUNT(*) INTO l_cnt1 FROM imb_file
              WHERE imb01 = l_rvv.rvv31
            IF cl_null(l_cnt1) THEN LET l_cnt1 = 0 END IF
            IF l_cnt1 = 0 THEN
               CALL t720_insimb(l_rvv.rvv31,l_cost) 
            ELSE
            #-----END CHI-B40023-----
               UPDATE imb_file SET imb118 = l_cost
                WHERE imb01 = l_rvv.rvv31
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   CALL cl_err3("upd","imb_file",l_rvv.rvv31,"","apm-720","","",1) 
                  LET g_success = 'N'
               END IF
            END IF   #CHI-B40023
         END IF

         IF p_rva00 = '1' THEN
            SELECT pmn65 INTO l_pmn65
              FROM pmn_file
             WHERE pmn01 = l_rvv.rvv36 AND pmn02 = l_rvv.rvv37
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","pmn_file",l_rvv.rvv36,l_rvv.rvv37,SQLCA.sqlcode,"","Select pmn65:",1) 
               LET g_success = 'N'
            END IF
         ELSE
            LET l_pmn65 = '1'
         END IF

         #---->更新庫存明細檔(img_file)--------------------------------------
         IF l_rvv.rvv32 IS NOT NULL AND l_pmn65='1' THEN
            CALL cl_msg("update img_file ...")

            IF g_bgjob='N' OR cl_null(g_bgjob) THEN    #FUN-A50001 add            
              CALL ui.Interface.refresh()
            END IF                                     #FUN-A50001 add 

            IF cl_null(l_rvv.rvv33) THEN LET  l_rvv.rvv33 = " " END IF               
            IF cl_null(l_rvv.rvv34) THEN LET  l_rvv.rvv34 = " " END IF
            LET l_forupd_sql = " SELECT img01,img02,img03,img04 FROM img_file ",
                               "  WHERE img01= ? ",
                               "    AND img02= ? ",
                               "    AND img03= ? ",
                               "    AND img04= ? ",
                               " FOR UPDATE "
            LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
            DECLARE img_lock_t1 CURSOR FROM l_forupd_sql

            OPEN img_lock_t1 USING l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,
                                   l_rvv.rvv34
            IF STATUS THEN
               CALL cl_err("OPEN img_lock_t1:", STATUS, 1)
               CLOSE img_lock_t1
               LET g_success = 'N' 
               RETURN
            END IF

            FETCH img_lock_t1 INTO l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,
                                   l_rvv.rvv34
            IF STATUS THEN
               CALL cl_err('img_lock_t1 fail',STATUS,1)
               CLOSE img_lock_t1   
               LET g_success = 'N'
               RETURN
            END IF

            IF cl_null(l_rvv.rvv17) THEN
               LET l_rvv.rvv17 = 0
            END IF

            IF cl_null(l_rvv.rvv35_fac) THEN
               LET l_rvv.rvv35_fac = 1
            END IF

            IF g_azw.azw04 = '2' THEN
               #取得采購的稅率
               SELECT pmm43 INTO l_pmm43 FROM pmm_file WHERE pmm01 = l_rvv.rvv36
               IF cl_null(l_pmm43) THEN
                  SELECT gec04 INTO l_pmm43 FROM gec_file,pmc_file
                     WHERE gec01 = pmc47 AND pmc01 = l_rvu.rvu04 AND gec011='1'
               END IF
            ELSE
               LET l_pmm43 = ' '
            END IF
            CALL s_upimg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,+1,l_rvv.rvv17*l_rvv.rvv35_fac, 
                 l_rvu.rvu03,l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,
                 l_rvv.rvv34,l_rvv.rvv01,l_rvv.rvv02,l_pmn07,l_rvv.rvv17,
                 l_ima25,l_rvv.rvv35_fac,1,'','','','','','','')
            IF STATUS OR g_success = 'N' THEN
               CALL cl_err('t1_upimg(+1):','9050',0)
               LET g_success='N'
               RETURN
            END IF

            #####--->Update img30,img31 直接人工成本,間接人工成本
            SELECT img10,img26,img30,img31
              INTO l_img10,l_img26,l_img30,l_img31
              FROM img_file
             WHERE img01 = l_rvv.rvv31
               AND img02 = l_rvv.rvv32
               AND img03 = l_rvv.rvv33
               AND img04 = l_rvv.rvv34
            IF STATUS THEN
              CALL cl_err3("sel","img_file",l_rvv.rvv31,"",STATUS,"","SEL img:",1) 
              LET g_success = 'N' 
            END IF

            IF l_img10+l_rvv.rvv17*l_rvv.rvv35_fac = 0 OR
               l_img10+l_rvv.rvv17*l_rvv.rvv35_fac IS NULL THEN
               LET l_img30_update = 0
               LET l_img31_update = 0
            ELSE
               LET l_img30_update = ((l_img10*l_img30)+(l_rvv.rvv17*l_pmn44))
                                    /(l_img10+l_rvv.rvv17*l_rvv.rvv35_fac)
               LET l_img31_update = (((l_img10*l_img30)+(l_rvv.rvv17*l_pmn44))
                                    /(l_img10+l_rvv.rvv17*l_rvv.rvv35_fac))*l_ima871
            END IF

            UPDATE img_file SET img30 = l_img30_update,
                                img31 = l_img31_update
             WHERE img01 = l_rvv.rvv31
               AND img02 = l_rvv.rvv32
               AND img03 = l_rvv.rvv33
               AND img04 = l_rvv.rvv34
            IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
               CALL cl_err3("upd","img_file",l_rvv.rvv31,"",SQLCA.sqlcode,"","Update img30 fail:",1)  
               LET g_success = 'N'
            END IF
         END IF
         #------>更新料件主檔 ----------------------------------------
         LET l_ss=0

         SELECT img23,img24 INTO l_img23,l_img24 FROM img_file
          WHERE img01 = l_rvv.rvv31
            AND img02 = l_rvv.rvv32
            AND img03 = l_rvv.rvv33
            AND img04 = l_rvv.rvv34
         IF SQLCA.sqlcode THEN
            SELECT ime05,ime06 INTO l_img23,l_img24 FROM ime_file
             WHERE ime01 = l_rvv.rvv32
               AND ime02 = l_rvv.rvv33
              AND imeacti = 'Y'    #FUN-D40103
            IF SQLCA.sqlcode THEN
               SELECT imd11,imd12 INTO l_img23,l_img24 FROM imd_file
                WHERE imd01 = l_rvv.rvv32
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","imd_file",l_rvv.rvv32,"",SQLCA.sqlcode,"","sel img23:",1)  
                  #是否需要g_success = 'N'? 
               END IF
            END IF
         END IF

         CALL s_udima(l_rvv.rvv31,l_img23,l_img24,l_rvv.rvv17*l_rvv.rvv35_fac,
                      l_rvu.rvu03,1) RETURNING l_ss

         IF l_ss THEN
            CALL cl_err('t720_t:s_udima:',9050,1)
            LET g_success = 'N'
            RETURN
         END IF
      ELSE
         CALL s_udima(l_rvv.rvv31,'Y','Y',l_rvv.rvv17,l_rvu.rvu03,1) RETURNING l_ss
         IF l_ss THEN
            CALL cl_err('t720_t:s_udima',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF

   #------->產生一筆異動記錄-------------------------------------------------
   CALL t720sub_log(l_rvv.*,l_rvu.rvu00,l_rvu.rvu08,l_ima25,p_rva00)
   #------->更新驗收單單身檔-------------------------------
   CALL t720sub_u_rvb('y',l_rvu.*,l_rvv.*,p_argv1)
   #--------->更新採購單單身檔 ------------------------------------------
   IF p_rva00 = '1' THEN
      CALL t720sub_u_pmn(l_rvv.*,'')
   END IF
   #------>更新料件主檔之在驗量--------------------------------

   IF g_sma.sma115 = 'Y' THEN
      CALL t720sub_update_imgg(+1,l_rvv.*,l_rvu.rvu03)
      CALL t720sub_update_tlff(l_rvv.*,l_rvu.rvu00,l_rvu.rvu08)
      IF g_success = 'N' THEN
         RETURN
      END IF
   END IF

   IF l_rvv.rvv31[1,4] != 'MISC' THEN
      LET l_imaqty = l_rvv.rvv17 *  l_pmn09
   END IF

   #--->委外更新工單及insert完工入庫檔----------------------
   IF l_rvu.rvu08='SUB' THEN
      INITIALIZE l_sfb.* TO NULL
      SELECT * INTO l_sfb.* FROM sfb_file
       WHERE sfb01=l_rvv.rvv18   #單號
         AND sfb02=7                           #委外
      CALL s_updsfb117(l_rvv.rvv18)
      IF g_success='N' THEN
         CALL cl_err('Update sfb',SQLCA.sqlcode,1)
         RETURN
      END IF

      SELECT sfb05 INTO l_sfb05 FROM sfb_file
       WHERE sfb01=l_rvv.rvv18

      SELECT ima25,ima55 INTO l_ima25,l_ima55 FROM ima_file
       WHERE ima01 = l_rvv.rvv31

      CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv35,l_ima55)   #生產/入庫
            RETURNING l_cnt,l_factor

      IF l_cnt THEN
         CALL cl_err('rvv35/ima55: ','abm-731',1)
         LET g_success ='N'
      END IF

      SELECT pmn65 INTO l_pmn65
        FROM pmn_file
       WHERE pmn01 = l_rvv.rvv36
         AND pmn02 = l_rvv.rvv37
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","pmn_file",l_rvv.rvv36,l_rvv.rvv37,SQLCA.sqlcode,"","Select pmn65:",1) 
         LET g_success = 'N'
      END IF

      IF l_pmn65='1' THEN
         CALL t720sub_chk_sfb(l_rvv.*,l_rvu.rvu08)            
         #TQC-C30193 --START-- TKY工單完工入庫數需加各站不良與報廢數
         IF s_industry('icd') THEN
            SELECT sfb93 INTO l_sfb93 FROM sfb_file 
             WHERE sfb01 = l_rvv.rvv36
            IF l_sfb93 = 'Y' THEN
               CALL t720_tky_sfb09(l_rvv.rvv04)
                     RETURNING l_tky_cnt
               LET l_rvv.rvv17 = l_rvv.rvv17 + l_tky_cnt  
               #FUN-C30307---begin
               ELSE   #非TKY工單,完工入庫數需該項次不良與報廢數
                  LET l_qty1 = 0
                  SELECT (rvbiicd06 + rvbiicd07) INTO l_qty1
                   FROM rvb_file,rvbi_file
                   WHERE rvb01 = rvbi01 AND rvb02 = rvbi02  
                   AND rvb01 = l_rvv.rvv04 AND rvb02 = l_rvv.rvv05
                   LET l_rvv.rvv17 = l_rvv.rvv17 + l_qty1  
               #FUN-C30307---end 
            END IF  
         END IF 
         #TQC-C30193 --END--
         UPDATE sfb_file SET sfb04='7', sfb09 = sfb09 + (l_rvv.rvv17 * l_factor)
          WHERE sfb01 = l_rvv.rvv18
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","sfb_file",l_rvv.rvv18,"",SQLCA.sqlcode,"","Update sfb",1) 
            LET g_success = 'N'
            RETURN
         END IF

         LET l_qty = l_rvv.rvv17 * l_factor
         LET l_qty = s_digqty(l_qty,l_ima55) #FUN-BB0083 add

         # Insert 完工記錄
         INSERT INTO sfh_file(sfh01,sfh02,sfh03,sfh04,sfh05,
                              sfh06,sfh07,sfh08,sfh09,sfh10,
                              sfh11,sfh12,sfh13,sfh14,sfh15,
                              sfh16,sfh17,sfh18,sfh91,sfh92,sfhplant,sfhlegal) #No.MOD-470041
                       VALUES(l_rvv.rvv18,l_rvu.rvu03,'2',l_sfb05,
                              l_rvv.rvv31,l_qty,l_ima55,l_rvv.rvv32,
                              l_rvv.rvv33,l_rvv.rvv34,' ',' ',l_rvu.rvu01,
                              l_rvv.rvv02,0,0,0,' ',' ',' ',g_plant,g_legal)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","sfh_file",l_rvv.rvv18,"",SQLCA.sqlcode,"","INSERT sfh_file",1)  
            LET g_success ='N'
         END IF
      ELSE
         #---代買入庫(update 已發料量)
        #SELECT pmn12 INTO l_sfa012 FROM pmn_file WHERE pmn01=l_rvv.rvv33 AND pmn02=l_rvv.rvv02 #FUN-A60027 add     #FUN-A60076
        #SELECT pmn43 INTO l_sfa013 FROM pmn_file WHERE pmn01=l_rvv.rvv33 AND pmn02=l_rvv.rvv02 #FUN-A60027 add     #FUN-A60076
         SELECT pmn43,pmn012 INTO l_sfa013,l_sfa012 FROM pmn_file WHERE pmn01 = l_rvv.rvv36 AND pmn02 = l_rvv.rvv37 #FUN-A60076 
         IF cl_null(l_sfa013) THEN LET l_sfa013 = 0 END IF   #TQC-BC0075
         LET l_sfa06 = s_digqty(l_rvv.rvv17 * l_factor,l_sfa012)   #No.FUN-BB0086
         UPDATE sfa_file SET sfa06 = sfa06 + l_sfa06
          WHERE sfa01 = l_rvv.rvv18
            AND sfa03 = l_rvv.rvv31
            AND sfa012 = l_sfa012 AND sfa013 = l_sfa013  #FUN-A60027 add
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN #No:7708 確認,和取消確認時控管要一制(加上SQLCA.sqlerrd[3]=0 的條件)
            CALL cl_err3("upd","sfa_file",l_rvv.rvv18,"",SQLCA.sqlcode,"","Update sfb",1) 
            LET g_success = 'N'
            RETURN
         ELSE
            CALL t720sub_log_r(l_rvv.*,l_ima25)
            LET l_ima906 = NULL
            SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=l_rvv.rvv31
            IF g_sma.sma115 = 'Y' AND l_ima906 MATCHES '[23]' THEN
               IF NOT cl_null(l_rvv.rvv83) THEN
                  IF NOT cl_null(l_rvv.rvv85) THEN
                     CALL t720sub_log_r_du('2',l_rvv.rvv83,l_rvv.rvv84,l_rvv.rvv85,l_ima25,l_rvv.*)
                      IF g_success='N' Then
                         RETURN
                      END IF
                  END IF
               END IF
               IF l_ima906 <> '3' THEN
                  IF NOT cl_null(l_rvv.rvv80) THEN
                     IF NOT cl_null(l_rvv.rvv82) THEN
                        CALL t720sub_log_r_du('1',l_rvv.rvv80,l_rvv.rvv81,l_rvv.rvv82,l_ima25,l_rvv.*)
                         IF g_success='N' Then
                            RETURN
                         END IF
                     END IF
                  END IF
               END IF
            END IF
         END IF
      END IF
   END IF

END FUNCTION

#******* 驗退update *********************************************
FUNCTION t720sub_uh(l_i,l_rvv,p_argv1,l_rvu)
DEFINE
    l_pmn011        LIKE pmn_file.pmn011,
    l_pmn51         LIKE pmn_file.pmn51,
    l_pmn55         LIKE pmn_file.pmn55,
    l_rvv17         LIKE rvv_file.rvv17, 
    l_rvb29         LIKE rvb_file.rvb29,
     l_rvb39         LIKE rvb_file.rvb39,
    l_rvb291        LIKE rvb_file.rvb29,
    l_rvb30         LIKE rvb_file.rvb30
DEFINE l_i          LIKE type_file.num5 
DEFINE l_rvv        RECORD LIKE rvv_file.*
DEFINE l_qty        LIKE ima_file.ima26
DEFINE p_argv1      LIKE rvu_file.rvu00
DEFINE l_ima918     LIKE ima_file.ima918
DEFINE l_ima921     LIKE ima_file.ima921
DEFINE l_rvu        RECORD LIKE rvu_file.*
DEFINE l_rva00      LIKE rva_file.rva00
DEFINE l_rvb33      LIKE rvb_file.rvb33    #TQC-B40148

#---------更新驗收單的相關欄位----------------------------------------
      SELECT SUM(rvv17) INTO l_rvb30 FROM rvv_file,rvu_file     #計算已入庫量
       WHERE rvv04=l_rvv.rvv04 AND rvv05=l_rvv.rvv05
         AND rvuconf='Y' AND rvu00='1' AND rvv01=rvu01
      SELECT SUM(rvv17) INTO l_rvb29 FROM rvv_file,rvu_file     #計算驗退
       WHERE rvv04=l_rvv.rvv04 AND rvv05=l_rvv.rvv05
         AND rvuconf='Y' AND rvu00='2' AND rvv01=rvu01
      SELECT SUM(rvv17) INTO l_rvb291 FROM rvv_file,rvu_file     #計算倉退
       WHERE rvv04=l_rvv.rvv04 AND rvv05=l_rvv.rvv05
         AND rvuconf='Y' AND rvu00='3' AND rvv01=rvu01
      IF cl_null(l_rvb30) THEN LET l_rvb30=0 END IF
      IF cl_null(l_rvb29) THEN LET l_rvb29=0 END IF
      IF cl_null(l_rvb291) THEN LET l_rvb291=0 END IF
      SELECT rvb07 INTO l_qty FROM rvb_file
       WHERE rvb01=l_rvv.rvv04 AND rvb02=l_rvv.rvv05
      IF l_qty<(l_rvb30+l_rvb29) AND p_argv1 <>'2' THEN 
         CALL cl_err('rvb07<rvb29+30:','asf-804',1)    #MOD-A70097 asf-660-->asf-804
         LET g_success = 'N' RETURN
      END IF

#Mark TQC-B60290
##TQC-B40148 --begin--
#     SELECT rvb33 INTO l_rvb33 FROM rvb_file
#      WHERE rvb01=l_rvv.rvv04 AND rvb02=l_rvv.rvv05
#     IF cl_null(l_rvb33) THEN LET l_rvb33 = 0 END IF 
#     IF l_rvb29 > (l_rvb33-l_rvb30) AND p_argv1 = '2' THEN 
#        CALL cl_err('','apm-130',0)
#        LET g_success = 'N'
#        RETURN 
#     END IF       
##TQC-B40148 --end--      
#Mark TQC-B60290--end
      
      SELECT rvb39 INTO l_rvb39
        FROM rvb_file
       WHERE rvb01 = l_rvu.rvu02
         AND rvb02 = l_rvv.rvv05
      IF l_rvb39 = 'Y' THEN
          UPDATE rvb_file SET rvb29 = l_rvb29,          #退貨量
                              rvb30 = l_rvb30,          #入庫量
                              rvb09 = l_rvb30-l_rvb291, #允請量
                              rvb31 = rvb33-l_rvb30     # 可入庫量
           WHERE rvb01 = l_rvu.rvu02 AND rvb02 = l_rvv.rvv05
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","rvb_file",l_rvu.rvu02,l_rvv.rvv05,SQLCA.sqlcode,"","退 upd rvb29,rvb09,rvb31:",1)
             LET g_success = 'N' RETURN
          END IF
      ELSE
          UPDATE rvb_file SET rvb29 = l_rvb29,         #退貨量
                              rvb30 = l_rvb30,         #入庫量
                              rvb09 = l_rvb30-l_rvb291, #允請量
                              rvb31 = rvb07-l_rvb29-l_rvb30 # 可入庫量
           WHERE rvb01 = l_rvu.rvu02 AND rvb02 = l_rvv.rvv05
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","rvb_file",l_rvu.rvu02,l_rvv.rvv05,SQLCA.sqlcode,"","退 upd rvb29,rvb09,rvb31:",1)  
             LET g_success = 'N' RETURN
          END IF
      END IF
      SELECT ima918,ima921 INTO l_ima918,l_ima921 
        FROM ima_file
       WHERE ima01 = l_rvv.rvv31
         AND imaacti = "Y"
      
      IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
         IF g_sma.sma90 = "Y" THEN #MOD-C30074 add
            CALL t720sub_upd_rvbs(l_i,l_rvu.rvu01,l_rvu.rvu02,l_rvv.rvv02,l_rvv.rvv05)
         END IF #MOD-C30074 add
      END IF
#-----更新採購單的相關欄位---------------------------------------
#  IF l_rvv.rvv25='N' THEN                                  #MOD-AB0055
   IF l_rvv.rvv25='N' AND NOT cl_null(l_rvv.rvv36) THEN     #MOD-AB0055
   #-- update 該工單全檢數量 -1998/04/02 ----
      IF NOT cl_null(l_rvv.rvv18) AND l_rvu.rvu08 = 'SUB' THEN
         CALL s_updsfb117(l_rvv.rvv18)
         IF g_success='N' THEN
            CALL cl_err('Update sfb',SQLCA.sqlcode,1)
            RETURN
         END IF
      END IF
      SELECT rva00 INTO l_rva00 FROM rva_file WHERE rva01 = l_rvu.rvu02
      IF l_rva00 = '2' THEN RETURN END IF
     SELECT SUM(rvb07-rvb29-rvb30) INTO l_pmn51
       FROM rvb_file,rva_file
      WHERE rvb04=l_rvv.rvv36 AND rvb03=l_rvv.rvv37
           AND rvaconf='Y' AND rvb01=rva01
           AND rvb35 = 'N'  
     IF cl_null(l_pmn51) THEN LET l_pmn51=0 END IF

     SELECT SUM(rvb29) INTO l_pmn55 FROM rvb_file,rva_file
      WHERE rvb04=l_rvv.rvv36 AND rvb03=l_rvv.rvv37
        AND rvaconf='Y' AND rvb01=rva01 AND rvb35='N'
     IF cl_null(l_pmn55) THEN LET l_pmn55=0 END IF

     SELECT SUM(rvv17) INTO l_rvv17     #計算此採購單對應之倉退量
       FROM rvv_file,rvu_file
      WHERE rvv37=l_rvv.rvv37 AND rvv36=l_rvv.rvv36
        AND rvv25='N' AND rvuconf='Y' AND rvu01=rvv01
        AND rvu00='3'  #倉退
     IF cl_null(l_rvv17) THEN LET l_rvv17=0 END IF

     UPDATE pmn_file
       SET pmn51=l_pmn51,                  #在驗量
           pmn55=l_pmn55,                  #驗退量
           pmn58=l_rvv17                   #倉退量
     WHERE pmn01=l_rvv.rvv36 AND pmn02=l_rvv.rvv37
     IF SQLCA.SQLERRD[3]=0 OR SQLCA.SQLCODE THEN
        LET g_success = 'N'
        CALL cl_err3("upd","pmn_file",l_rvv.rvv36,l_rvv.rvv37,SQLCA.sqlcode,"","驗退 pmn51,55:",1) 
        RETURN
     END IF
     CALL s_udpmn57(l_rvv.rvv36,l_rvv.rvv37) #更新超短交量 = 收貨量 - 訂購量
   END IF
END FUNCTION

#--------->新增異動記錄--------------------------------------------------
FUNCTION t720sub_log(l_rvv,p_rvu00,p_rvu08,p_ima25,p_rva00)
  DEFINE l_sta       LIKE type_file.num5,    #No.FUN-680136 SMALLINT
         l_flag      LIKE type_file.num5,    #No.FUN-680136 SMALLINT
         l_ima25_fac LIKE tlf_file.tlf60,
         l_img09     LIKE img_file.img09,       #庫存單位
         l_img10     LIKE img_file.img10,       #庫存數量
         l_img26     LIKE img_file.img26,
         l_pmn65     LIKE pmn_file.pmn65,
         l_return    LIKE rvb_file.rvb30
  DEFINE l_rvv       RECORD LIKE rvv_file.*
  DEFINE p_rvu00     LIKE rvu_file.rvu00
  DEFINE p_rvu08     LIKE rvu_file.rvu08
  DEFINE p_ima25     LIKE ima_file.ima25
  DEFINE l_ima39     LIKE ima_file.ima39
  DEFINE l_ima25     LIKE ima_file.ima25
  DEFINE p_rva00     LIKE rva_file.rva00

  LET l_img09 = ''   #TQC-A60044
  LET l_img10 = ''   #TQC-A60044
  LET l_img26 = ''   #TQC-A60044

  IF l_rvv.rvv31[1,4]!='MISC' AND p_rvu00!='2' 
     AND NOT (p_rvu00='3' AND l_rvv.rvv17=0) THEN   #TQC-A60044
     SELECT img09,img10,img26 INTO l_img09,l_img10,l_img26
       FROM img_file WHERE img01 = l_rvv.rvv31 AND img02 = l_rvv.rvv32
                       AND img03 = l_rvv.rvv33 AND img04 = l_rvv.rvv34
     IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","img_file",l_rvv.rvv31,"",SQLCA.sqlcode,"","ckp#log",1) 
        LET g_success = 'N' RETURN
     END IF
  END IF
  SELECT ima39 INTO l_ima39 FROM ima_file WHERE ima01=l_rvv.rvv31

  INITIALIZE g_tlf.* TO NULL

  LET g_tlf.tlf01  = l_rvv.rvv31             #異動料件編號
  LET g_tlf.tlf020 = g_plant                 #工廠別

  IF p_rvu00 = '1' OR p_rvu00='2' THEN      #入庫
     IF p_rvu08='SUB' THEN
        LET g_tlf.tlf02  = 25                #來源狀況
     ELSE
        LET g_tlf.tlf02  = 20                #來源狀況
     END IF
     LET g_tlf.tlf021 = ' '                  #倉庫別
     LET g_tlf.tlf022 = ' '                  #儲位別
     LET g_tlf.tlf023 = ' '                  #批號
     LET g_tlf.tlf024 = ' '                  #異動後庫存數量
     LET g_tlf.tlf025 = ' '                  #庫存單位(ima_file or img_file)
  ELSE
     LET g_tlf.tlf02 = 50
     LET g_tlf.tlf021 = l_rvv.rvv32          #倉庫別
     LET g_tlf.tlf022 = l_rvv.rvv33          #儲位別
     LET g_tlf.tlf023 = l_rvv.rvv34          #批號
     LET g_tlf.tlf024 = l_img10              #異動後庫存數量
     LET g_tlf.tlf025 = p_ima25
  END IF
  IF p_rvu00='1' THEN
     LET g_tlf.tlf026 = l_rvv.rvv04          #單據號碼(驗收單號)
     LET g_tlf.tlf027 = l_rvv.rvv05          #單據項次(驗收序號)
  ELSE
     LET g_tlf.tlf026 = l_rvv.rvv01
     LET g_tlf.tlf027 = l_rvv.rvv02
  END IF
  CASE
     WHEN p_rvu00='1'
          LET g_tlf.tlf03=50                   #資料目的為倉庫
     WHEN p_rvu00='2'  OR p_rvu00='3'
          LET g_tlf.tlf03=31
  END CASE
  IF p_rvu00='1' OR p_rvu00='2' THEN #入庫
     LET g_tlf.tlf031=l_rvv.rvv32         #倉庫別
     LET g_tlf.tlf032=l_rvv.rvv33         #儲位別
     LET g_tlf.tlf033=l_rvv.rvv34         #批號
  ELSE
       LET g_tlf.tlf031=' '                 #倉庫別
       LET g_tlf.tlf032=' '                 #儲位別
       LET g_tlf.tlf033=' '                 #批號
  END IF
    LET g_tlf.tlf034=l_img10                #異動後存數量
    IF p_rvu00='1' THEN
       LET g_tlf.tlf035=p_ima25             #庫存單位(ima_file or img_file)
       LET g_tlf.tlf036=l_rvv.rvv01         #參考號碼(入庫單號)
       LET g_tlf.tlf037=l_rvv.rvv02
    ELSE
       LET g_tlf.tlf035=' '                 #庫存單位(ima_file or img_file)
       LET g_tlf.tlf036=l_rvv.rvv04         #參考號碼(驗收單號)
       LET g_tlf.tlf037=l_rvv.rvv05
    END IF
#--->異動數量
    LET g_tlf.tlf04=' '                  #工作站
    LET g_tlf.tlf05=' '                  #作業序號
    LET g_tlf.tlf06=l_rvv.rvv09          #日期
    LET g_tlf.tlf07=g_today              #異動資料產生日期
    LET g_tlf.tlf08=TIME                 #異動資料產生時:分:秒
    LET g_tlf.tlf09=g_user               #產生人
    LET g_tlf.tlf10=l_rvv.rvv17          #收料數量
    LET g_tlf.tlf11=l_rvv.rvv35          #收料單位
    LET g_tlf.tlf12=l_rvv.rvv35_fac      #收料/庫存轉換率
    CASE
       WHEN p_rvu00='1' AND p_rvu08!='SUB'
           LET g_tlf.tlf13='apmt150'            #異動命令代號
       WHEN p_rvu00='1' AND p_rvu08='SUB'
           SELECT pmn65 INTO l_pmn65 FROM pmn_file
            WHERE pmn01=l_rvv.rvv36 AND pmn02=l_rvv.rvv37
#FUN-D20078---mark---str---
#          IF l_pmn65='1' THEN
#             LET g_tlf.tlf13='asft6201'        #異動命令代號
#          ELSE
#             LET g_tlf.tlf13='apmt230'         #異動命令代號
#          END IF
#FUN-D20078---mark---end---
#FUN-D20078---add---str---
           IF l_pmn65='2' THEN
              LET g_tlf.tlf13='apmt230'        #異動命令代號
           ELSE
              LET g_tlf.tlf13='asft6201'        #異動命令代號
           END IF
#FUN-D20078---add---end---
       WHEN p_rvu00='2'
           LET g_tlf.tlf13='apmt102'            #異動命令代號
       WHEN p_rvu00='3' AND p_rvu08 != 'SUB' #FUN-D20078 add
           LET g_tlf.tlf13='apmt1072'           #異動命令代號
          #FUN-D20078---add---str---
       WHEN p_rvu00='3' AND p_rvu08 = 'SUB'
            SELECT pmn65 INTO l_pmn65 FROM pmn_file
             WHERE pmn01=l_rvv.rvv36 AND pmn02=l_rvv.rvv37
            IF l_pmn65='2' THEN               #委外非代買
               LET g_tlf.tlf13='apmt230'        #異動命令代號
            ELSE                              #委外代買
               LET g_tlf.tlf13='asft6201'        #異動命令代號
            END IF
          #FUN-D20078---add---end---
    END CASE
    LET g_tlf.tlf14= l_rvv.rvv26
    IF p_rvu00='1' THEN
        IF g_sma.sma12='N' THEN             #是否為使用多倉儲管理
           LET g_tlf.tlf15=l_ima39          #料件會計科目
        ELSE
           LET g_tlf.tlf15=l_img26          #倉儲會計科目
        END IF
    END IF
    LET g_tlf.tlf16=' '                  #貸方
    LET g_tlf.tlf17=' '                  #非庫存性料件編號
    CALL s_imaQOH(l_rvv.rvv31)
         RETURNING g_tlf.tlf18           #異動後總庫存量
    LET g_tlf.tlf19= l_rvv.rvv06         #異動廠商/客戶編號
    LET g_tlf.tlf20= l_rvv.rvv34         #專案號碼

    SELECT ima25       #庫存單位
      INTO l_ima25
      FROM ima_file WHERE ima01=l_rvv.rvv31 AND imaacti='Y'
    CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv35,l_ima25)
         RETURNING l_flag,l_ima25_fac
    IF l_flag THEN
       ###Modify:98/11/15 ----單位換算率抓不到 ------####
       CALL cl_err('rvv35/ima25: ','abm-731',1)
       LET g_success ='N'
       LET l_ima25_fac = 1.0
    END IF
    LET g_tlf.tlf60=l_ima25_fac

    IF p_rvu08='SUB' THEN
       SELECT pmn65 INTO l_pmn65 FROM pmn_file
        WHERE pmn01=l_rvv.rvv36 AND pmn02=l_rvv.rvv37
       IF l_pmn65='1' THEN
          LET g_tlf.tlf62= l_rvv.rvv18
          LET g_tlf.tlf63= ' '
       ELSE
          LET g_tlf.tlf62= ' '
          LET g_tlf.tlf63= ' '
          IF p_rvu00 = '1' OR p_rvu00 = '2' THEN  #入庫
             LET g_tlf.tlf02 = 18
          END IF
          #No.7692(end)
       END IF
    ELSE
       LET g_tlf.tlf62= l_rvv.rvv36
       LET g_tlf.tlf63= l_rvv.rvv37
    END IF
    LET g_tlf.tlf64 = l_rvv.rvv41 
    LET g_tlf.tlf930 = l_rvv.rvv930  
    IF p_rva00 = '1' THEN
       SELECT pmn122,pmn96,pmn97,pmn98
         INTO g_tlf.tlf20,g_tlf.tlf41,g_tlf.tlf42,g_tlf.tlf43
         FROM pmn_file
        WHERE pmn01 = l_rvv.rvv36
          AND pmn02 = l_rvv.rvv37
       IF SQLCA.sqlcode THEN
         LET g_tlf.tlf20 = ' '
         LET g_tlf.tlf41 = ' '
         LET g_tlf.tlf42 = ' '
         LET g_tlf.tlf43 = ' '
       END IF
    ELSE
       LET g_tlf.tlf20 = ' '
       LET g_tlf.tlf41 = ' '
       LET g_tlf.tlf42 = ' '
       LET g_tlf.tlf43 = ' '
    END IF
#FUN-D60130 -----Begin--------
    IF g_prog = 'apmt732' OR g_prog = 'apmt732_icd' THEN
       LET g_tlf.tlf10 = 0
    END IF
#FUN-D60130 -----End----------
    CALL s_tlf(1,0)
END FUNCTION

FUNCTION t720sub_update_tlff(l_rvv,p_rvu00,p_rvu08)
  DEFINE l_ima25   LIKE ima_file.ima25,
         l_ima906  LIKE ima_file.ima906,
         l_ima907  LIKE ima_file.ima907
  DEFINE l_rvv     RECORD LIKE rvv_file.*
  DEFINE p_rvu00   LIKE rvu_file.rvu00
  DEFINE p_rvu08   LIKE rvu_file.rvu08
  DEFINE l_rvv83   LIKE rvv_file.rvv83
  DEFINE l_rvv84   LIKE rvv_file.rvv84
  DEFINE l_rvv85   LIKE rvv_file.rvv85

   IF g_sma.sma115 = 'N' THEN RETURN END IF

   SELECT ima906,ima907,ima25 INTO l_ima906,l_ima907,l_ima25 FROM ima_file
    WHERE ima01 = l_rvv.rvv31
   IF SQLCA.sqlcode THEN
      IF l_rvv.rvv31 MATCHES 'MISC*' THEN
         RETURN
      ELSE
         LET g_success='N' RETURN
      END IF
   END IF

   IF l_ima906 = '1' OR cl_null(l_ima906) THEN RETURN END IF

   IF l_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(l_rvv.rvv83) THEN
         IF NOT cl_null(l_rvv.rvv85) THEN
            LET l_rvv83=l_rvv.rvv83 LET l_rvv84=l_rvv.rvv84 LET l_rvv85=l_rvv.rvv85
            CALL t720sub_tlff('2',l_rvv83,l_rvv84,l_rvv85,l_rvv.*,p_rvu00,p_rvu08,l_ima25,l_ima906)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
      IF NOT cl_null(l_rvv.rvv80) THEN
         IF NOT cl_null(l_rvv.rvv82) THEN   
            LET l_rvv83=l_rvv.rvv80 LET l_rvv84=l_rvv.rvv81 LET l_rvv85=l_rvv.rvv82
            CALL t720sub_tlff('1',l_rvv83,l_rvv84,l_rvv85,l_rvv.*,p_rvu00,p_rvu08,l_ima25,l_ima906)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
   IF l_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(l_rvv.rvv83) THEN
         IF NOT cl_null(l_rvv.rvv85) THEN
            LET l_rvv83=l_rvv.rvv83 LET l_rvv84=l_rvv.rvv84 LET l_rvv85=l_rvv.rvv85
            CALL t720sub_tlff('2',l_rvv83,l_rvv84,l_rvv85,l_rvv.*,p_rvu00,p_rvu08,l_ima25,l_ima906)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF

END FUNCTION

#--------->新增異動記錄--------------------------------------------------
FUNCTION t720sub_tlff(p_flag,p_unit,p_fac,p_qty,l_rvv,p_rvu00,p_rvu08,p_ima25,p_ima906)
  DEFINE p_unit       LIKE imgg_file.imgg09,
         p_flag       LIKE type_file.chr1,    #No.FUN-680136 CHAR(1)
         p_fac        LIKE imgg_file.imgg21,
         p_qty        LIKE imgg_file.imgg10,
         l_sta        LIKE type_file.num5,    #No.FUN-680136 SMALLINT
         l_flag       LIKE type_file.num5,    #No.FUN-680136 SMALLINT
         l_ima25_fac  LIKE tlff_file.tlff60,
         l_imgg09     LIKE imgg_file.imgg09,       #庫存單位
         l_imgg10     LIKE imgg_file.imgg10,       #庫存數量
         l_imgg26     LIKE imgg_file.imgg26,
         l_pmn65      LIKE pmn_file.pmn65,
         l_return     LIKE rvb_file.rvb30
  DEFINE l_rvv        RECORD LIKE rvv_file.*
  DEFINE p_rvu00      LIKE rvu_file.rvu00
  DEFINE p_rvu08      LIKE rvu_file.rvu08
  DEFINE p_ima25      LIKE ima_file.ima25
  DEFINE p_ima906     LIKE ima_file.ima906
  DEFINE l_ima39      LIKE ima_file.ima39
  DEFINE l_ima906     LIKE ima_file.ima906
  DEFINE l_ima907     LIKE ima_file.ima907
  DEFINE l_ima25      LIKE ima_file.ima25

 #IF l_rvv.rvv31[1,4]!='MISC' AND p_rvu00!='2' THEN  #MOD-CC0062 mark
  IF l_rvv.rvv31[1,4]!='MISC' AND p_rvu00!='2'       #MOD-CC0062 add
     AND NOT (p_rvu00='3' AND l_rvv.rvv17=0) THEN    #MOD-CC0062 add
     SELECT imgg10,imgg26 INTO l_imgg10,l_imgg26
       FROM imgg_file WHERE imgg01 = l_rvv.rvv31 AND imgg02 = l_rvv.rvv32
                        AND imgg03 = l_rvv.rvv33 AND imgg04 = l_rvv.rvv34
                        AND imgg09 = p_unit
     IF SQLCA.sqlcode AND NOT (p_ima906='3' AND p_flag = '1') THEN
        CALL cl_err('ckp#log',SQLCA.sqlcode,1) LET g_success = 'N' RETURN
     END IF
  END IF

  SELECT ima39 INTO l_ima39 FROM ima_file WHERE ima01=l_rvv.rvv31

  INITIALIZE g_tlff.* TO NULL

  LET g_tlff.tlff01  = l_rvv.rvv31             #異動料件編號
  LET g_tlff.tlff020 = g_plant                 #工廠別

  IF p_rvu00 = '1' OR p_rvu00='2' THEN      #入庫
     IF p_rvu08='SUB' THEN
        LET g_tlff.tlff02  = 25                #來源狀況
     ELSE
        LET g_tlff.tlff02  = 20                #來源狀況
     END IF
     LET g_tlff.tlff021 = ' '                  #倉庫別
     LET g_tlff.tlff022 = ' '                  #儲位別
     LET g_tlff.tlff023 = ' '                  #批號
     LET g_tlff.tlff024 = ' '                  #異動後庫存數量
     LET g_tlff.tlff025 = ' '                  #庫存單位(ima_file or imgg_file)
  ELSE
     LET g_tlff.tlff02 = 50
     LET g_tlff.tlff021 = l_rvv.rvv32          #倉庫別
     LET g_tlff.tlff022 = l_rvv.rvv33          #儲位別
     LET g_tlff.tlff023 = l_rvv.rvv34          #批號
     LET g_tlff.tlff024 = l_imgg10             #異動後庫存數量
     LET g_tlff.tlff025 = p_ima25
  END IF
  IF p_rvu00='1' THEN
     LET g_tlff.tlff026 = l_rvv.rvv04          #單據號碼(驗收單號)
     LET g_tlff.tlff027 = l_rvv.rvv05          #單據項次(驗收序號)
  ELSE
     LET g_tlff.tlff026 = l_rvv.rvv01
     LET g_tlff.tlff027 = l_rvv.rvv02
  END IF
  CASE
     WHEN p_rvu00='1'
          LET g_tlff.tlff03=50                   #資料目的為倉庫
     WHEN p_rvu00='2'  OR p_rvu00='3'
          LET g_tlff.tlff03=31
  END CASE
  IF p_rvu00='1' OR p_rvu00='2' THEN #入庫
     LET g_tlff.tlff031=l_rvv.rvv32         #倉庫別
     LET g_tlff.tlff032=l_rvv.rvv33         #儲位別
     LET g_tlff.tlff033=l_rvv.rvv34         #批號
  ELSE
       LET g_tlff.tlff031=' '                 #倉庫別
       LET g_tlff.tlff032=' '                 #儲位別
       LET g_tlff.tlff033=' '                 #批號
  END IF
  LET g_tlff.tlff034=l_imgg10                #異動後存數量
  IF p_rvu00='1' THEN
     LET g_tlff.tlff035=p_ima25             #庫存單位(ima_file or imgg_file)
     LET g_tlff.tlff036=l_rvv.rvv01         #參考號碼(入庫單號)
     LET g_tlff.tlff037=l_rvv.rvv02
  ELSE
     LET g_tlff.tlff035=' '                 #庫存單位(ima_file or imgg_file)
     LET g_tlff.tlff036=l_rvv.rvv04         #參考號碼(驗收單號)
     LET g_tlff.tlff037=l_rvv.rvv05
  END IF
#--->異動數量
    LET g_tlff.tlff04=' '                  #工作站
    LET g_tlff.tlff05=' '                  #作業序號
    LET g_tlff.tlff06=l_rvv.rvv09          #日期
    LET g_tlff.tlff07=g_today              #異動資料產生日期
    LET g_tlff.tlff08=TIME                 #異動資料產生時:分:秒
    LET g_tlff.tlff09=g_user               #產生人
    LET g_tlff.tlff10=p_qty                #收料數量
    LET g_tlff.tlff11=p_unit               #收料單位
    LET g_tlff.tlff12=p_fac                #收料/庫存轉換率
    CASE
       WHEN p_rvu00='1' AND p_rvu08!='SUB'
           LET g_tlff.tlff13='apmt150'            #異動命令代號
       WHEN p_rvu00='1' AND p_rvu08='SUB'
           SELECT pmn65 INTO l_pmn65 FROM pmn_file
            WHERE pmn01=l_rvv.rvv36 AND pmn02=l_rvv.rvv37
#TQC-D30002---mark---str---
#          IF l_pmn65='1' THEN
#             LET g_tlff.tlff13='asft6201'        #異動命令代號
#          ELSE
#             LET g_tlff.tlff13='apmt230'         #異動命令代號
#          END IF
#TQC-D30002---mark---end---
#FUN-D20078---add---str---
           IF l_pmn65='2' THEN
              LET g_tlff.tlff13='apmt230'        #異動命令代號
           ELSE
              LET g_tlff.tlff13='asft6201'        #異動命令代號
           END IF
#FUN-D20078---add---end---
       WHEN p_rvu00='2'
           LET g_tlff.tlff13='apmt102'            #異動命令代號
#      WHEN p_rvu00='3'                                            #FUN-D20078 mark
#          LET g_tlff.tlff13='apmt1072'           #異動命令代號    #FUN-D20078 mark
     #FUN-D20078---add---str---    
       WHEN p_rvu00='3' AND p_rvu08 != 'SUB' 
           LET g_tlff.tlff13='apmt1072'           #異動命令代號
       WHEN p_rvu00='3' AND p_rvu08 = 'SUB'
            SELECT pmn65 INTO l_pmn65 FROM pmn_file
             WHERE pmn01=l_rvv.rvv36 AND pmn02=l_rvv.rvv37
            IF l_pmn65='2' THEN                
               LET g_tlff.tlff13='apmt230'        #異動命令代號
            ELSE                              
               LET g_tlff.tlff13='asft6201'        #異動命令代號
            END IF
     #FUN-D20078---add---end---
    END CASE
    LET g_tlff.tlff14= l_rvv.rvv26

    IF p_rvu00='1' THEN
        IF g_sma.sma12='N' THEN               #是否為使用多倉儲管理
           LET g_tlff.tlff15=l_ima39          #料件會計科目
        ELSE
           LET g_tlff.tlff15=l_imgg26          #倉儲會計科目
        END IF
    END IF
    LET g_tlff.tlff16=' '                  #貸方
    LET g_tlff.tlff17=' '                  #非庫存性料件編號
    CALL s_imaQOH(l_rvv.rvv31)
         RETURNING g_tlff.tlff18           #異動後總庫存量
    LET g_tlff.tlff19= l_rvv.rvv06         #異動廠商/客戶編號
    LET g_tlff.tlff20= l_rvv.rvv34         #專案號碼

    LET l_ima906=NULL
    LET l_ima907=NULL
    SELECT ima25,ima906,ima907       #庫存單位
      INTO l_ima25,l_ima906,l_ima907
      FROM ima_file WHERE ima01=l_rvv.rvv31 AND imaacti='Y'
    CALL s_umfchk(l_rvv.rvv31,p_unit,l_ima25)
         RETURNING l_flag,l_ima25_fac
    IF l_flag AND NOT (l_ima906='3' AND p_flag='2') THEN
       ###Modify:98/11/15 ----單位換算率抓不到 ------####
       CALL cl_err('rvv35/ima25: ','abm-731',1)
       LET g_success ='N'
       LET l_ima25_fac = 1.0
    END IF
    LET g_tlff.tlff60=l_ima25_fac
#--------------------------------

    IF p_rvu08='SUB' THEN
       SELECT pmn65 INTO l_pmn65 FROM pmn_file
        WHERE pmn01=l_rvv.rvv36 AND pmn02=l_rvv.rvv37
       IF l_pmn65='1' THEN
          LET g_tlff.tlff62= l_rvv.rvv18
          LET g_tlff.tlff63= ' '
       ELSE
          LET g_tlff.tlff62= ' '
          LET g_tlff.tlff63= ' '
          IF p_rvu00 = '1' OR p_rvu00 = '2' THEN  #入庫
             LET g_tlff.tlff02 = 18
          END IF
       END IF
    ELSE
       LET g_tlff.tlff62= l_rvv.rvv36
       LET g_tlff.tlff63= l_rvv.rvv37
    END IF
    LET g_tlff.tlff64 = l_rvv.rvv41 
    LET g_tlff.tlff930= l_rvv.rvv930   
#FUN-D60130 ------Begin-------
    IF g_prog = 'apmt732' OR g_prog = 'apmt732_icd' THEN
       LET g_tlff.tlff10 = 0
    END IF
#FUN-D60130 ------End---------
    IF cl_null(l_rvv.rvv85) OR l_rvv.rvv85 = 0 THEN
       CALL s_tlff(p_flag,NULL)
    ELSE
       CALL s_tlff(p_flag,l_rvv.rvv83)
    END IF
END FUNCTION

#更新相關的檔案
FUNCTION t720sub_bu(l_rvu,l_rvv,p_argv1,p_ima25,p_rva00)
   DEFINE
      l_img21         LIKE img_file.img21,
      l_img23         LIKE img_file.img23,
      l_img24         LIKE img_file.img24,
      l_pmn07         LIKE pmn_file.pmn07,
      l_sta           LIKE type_file.num5,   #No.FUN-680136 SMALLINT
      l_rvb29         LIKE rvb_file.rvb29,
      l_rvb291        LIKE rvb_file.rvb29,
      l_rvb30         LIKE rvb_file.rvb30,
      l_rvb39         LIKE rvb_file.rvb39,   #MOD-4C0053
      l_qty_ima       LIKE img_file.img10,
      l_qty_img       LIKE img_file.img10,
      l_qty1_ima      LIKE img_file.img10,
      l_qty1_img      LIKE img_file.img10,
      l_qty_rvv17     LIKE rvv_file.rvv17,
      l_rvv17         LIKE rvv_file.rvv17,
      l_ima55         LIKE ima_file.ima55,
      l_factor        LIKE ima_file.ima31_fac, #No.FUN-680136 DEC(16,8)
      l_code          LIKE type_file.chr1    #No.FUN-680136 CHAR(01)
DEFINE l_rvv          RECORD LIKE rvv_file.*
DEFINE l_rvu          RECORD LIKE rvu_file.*
DEFINE l_sfb          RECORD LIKE sfb_file.*
DEFINE p_argv1        LIKE rvu_file.rvu00
DEFINE l_qty          LIKE ima_file.ima26
DEFINE l_ima918       LIKE ima_file.ima918
DEFINE l_ima921       LIKE ima_file.ima921
DEFINE l_cnt          LIKE type_file.num10
DEFINE p_ima25        LIKE ima_file.ima25
DEFINE l_forupd_sql   STRING
DEFINE l_fac          LIKE rvv_file.rvv35_fac
DEFINE p_rva00        LIKE rva_file.rva00
DEFINE l_pmm43     LIKE pmm_file.pmm43
DEFINE l_ima01     LIKE ima_file.ima01
DEFINE l_pmn65        LIKE pmn_file.pmn65   #MOD-A70212

 #-----MOD-A70212---------
  LET l_pmn65 = ''
  SELECT pmn65 INTO l_pmn65 FROM pmn_file   #代買性質 1.一般採購 2.代買採購
   WHERE pmn01=l_rvv.rvv36 AND pmn02=l_rvv.rvv37
  IF l_rvv.rvv31[1,4]!='MISC' THEN  #MOD-D60109
  IF l_pmn65 != '2' OR cl_null(l_pmn65) THEN
  #FUN-D30024 ----------Begin-----------
   # IF NOT s_stkminus(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34, 
   #                   l_rvv.rvv17,l_rvv.rvv35_fac,l_rvu.rvu03,g_sma.sma894[6,6]) THEN
     IF NOT s_stkminus(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                       l_rvv.rvv17,l_rvv.rvv35_fac,l_rvu.rvu03) THEN
  #FUN-D30024 ----------End-------------
        LET g_success='N'
        RETURN
     END IF
  END IF
  END IF #MOD-D60109
 #-----END MOD-A70212-----

 IF l_rvv.rvv31[1,4]!='MISC' 
    AND NOT (l_rvu.rvu00='3' AND l_rvv.rvv17=0) THEN   #MOD-A40166
    CALL cl_msg("update img_file ...")

    IF g_bgjob='N' OR cl_null(g_bgjob) THEN    #FUN-A50001 add
      CALL ui.Interface.refresh()
    END IF                                     #FUN-A50001 add

    LET l_forupd_sql =
          " SELECT img01,img02,img03,img04 FROM img_file ",
          "  WHERE img01= ? ",
          "    AND img02= ? ",
          "    AND img03= ? ",
          "    AND img04= ? ",
          " FOR UPDATE "
    LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
    DECLARE img_lock_bu CURSOR FROM l_forupd_sql

    OPEN img_lock_bu USING l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34
    IF STATUS THEN
       CALL cl_err("OPEN img_lock_bu:", STATUS, 1)
       CLOSE img_lock_bu
       LET g_success = 'N'
       RETURN
    END IF
    FETCH img_lock_bu INTO l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34
    IF STATUS THEN
       CLOSE img_lock_bu 
       CALL cl_err('img_lock_bu fail',STATUS,1) 
       LET g_success='N' 
       RETURN
    END IF

    SELECT img21,img23,img24
      INTO l_img21,l_img23,l_img24 FROM img_file
     WHERE img01=l_rvv.rvv31 AND img02=l_rvv.rvv32
       AND img03=l_rvv.rvv33 AND img04=l_rvv.rvv34
        IF STATUS THEN
           CALL cl_err3("sel","img_file",l_rvv.rvv31,"",SQLCA.sqlcode,"","sel img",1) 
           LET g_success='N'
           RETURN
        END IF

   IF cl_null(l_img21) THEN LET l_img21=1 END IF
   IF g_sma.sma12 ='Y' THEN
      LET l_qty_img=l_rvv.rvv17*l_rvv.rvv35_fac    #退貨總數(img_file)
      LET l_qty_ima = l_qty_img * l_img21          #退貨總數(ima_file)
   ELSE
      LET l_qty_img=l_rvv.rvv17                    #退貨總數(img_file)
      LET l_qty_ima=l_rvv.rvv17                   #退貨總數(ima_file)
   END IF
   LET l_qty1_img = l_rvv.rvv17 * l_rvv.rvv35_fac
   LET l_qty1_ima = l_qty1_img * l_img21
  #FUN-D60130 -----Begin-----
   IF g_prog = 'apmt732' OR g_prog = 'apmt732_icd' THEN
      LET l_qty1_img = 0
      LET l_qty1_ima = 0
   END IF 
  #FUN-D60130 -----End-------
#-----更新倉庫庫存明細資料
   CALL s_upimg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,0,l_qty1_img,l_rvv.rvv09,  
                 '','','','',l_rvv.rvv01,l_rvv.rvv02,'','','','','','','','',0,0,'','')  
   IF g_success = 'N' THEN
      CALL cl_err('bu_upimg(-1)','9050',1) RETURN
   END IF
   # ----鎖ima
   LET l_forupd_sql="SELECT ima01 FROM ima_file", 
                    " WHERE ima01= ? FOR UPDATE " 
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)         
   DECLARE ima_lock_1 CURSOR FROM l_forupd_sql 
   OPEN ima_lock_1 USING l_rvv.rvv31
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock ima fail',STATUS,1) 
      LET g_success = 'N'
      RETURN
   END IF
   FETCH ima_lock_1 INTO l_ima01
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock ima fail',STATUS,1) 
      LET g_success = 'N'
      RETURN 
   END IF
   # end    ----鎖ima

#------若庫存異動後其庫存量小於等於零時將該筆資料刪除
   CALL s_delimg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34)  
#------更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
   IF s_udima(l_rvv.rvv31,l_img23,l_img24,l_qty1_ima,l_rvu.rvu03,0) THEN  
      RETURN
   END IF
   IF g_success = 'N' THEN
      RETURN
   END IF
 END IF

 IF g_sma.sma115 = 'Y' AND l_rvv.rvv31[1,4]!='MISC' 
    AND NOT (l_rvu.rvu00='3' AND l_rvv.rvv17=0) THEN   #MOD-A40166
    CALL t720sub_update_imgg(0,l_rvv.*,l_rvu.rvu03)
 END IF

#--------產生異動記錄
   IF l_rvv.rvv31[1,4]!='MISC' THEN
      #AND NOT (l_rvu.rvu00='3' AND l_rvv.rvv17=0) THEN   #MOD-A40166   #TQC-A60044
      CALL t720sub_log(l_rvv.*,l_rvu.rvu00,l_rvu.rvu08,p_ima25,p_rva00)
      CALL t720sub_update_tlff(l_rvv.*,l_rvu.rvu00,l_rvu.rvu08)
   END IF                            #No.9733
  #TQC-B40100 mark --start--
  #IF SQLCA.sqlcode THEN
  #   CALL cl_err('tlf_file',SQLCA.sqlcode,1)
  #   LET g_success ='N'
  #   RETURN
  #END IF
  #TQC-B40100 mark --end--

   IF l_rvu.rvu00='3' AND l_rvu.rvu08='SUB' THEN RETURN END IF    #Add by zm 131121  委外仓退不需更新rvb/pmn相关数量

   IF l_rvv.rvv36 IS NOT NULL AND l_rvv.rvv36 !=' ' THEN
      SELECT pmn07 INTO l_pmn07 FROM pmn_file
      WHERE pmn01 = l_rvv.rvv36 AND pmn02 = l_rvv.rvv37
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","pmn_file",l_rvv.rvv36,l_rvv.rvv37,SQLCA.sqlcode,"","pmn07(purchase unit not found):",1)  
      END IF
   ELSE
      LET l_pmn07 = l_rvv.rvv35
   END IF
   CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv35,l_pmn07)
             RETURNING l_sta,l_fac
   IF l_sta THEN
     CALL cl_err('rvv35/pmn07: ','abm-731',1)
     LET g_success ='N'
   END IF
   LET l_qty_rvv17 = l_rvv.rvv17 * l_fac
#--------如果有驗收單, 則更新rvb,採購單
   IF NOT cl_null(l_rvu.rvu02) THEN
      SELECT SUM(rvv17) INTO l_rvb30 FROM rvv_file,rvu_file     #計算已入庫量
       WHERE rvv04=l_rvv.rvv04 AND rvv05=l_rvv.rvv05
             AND rvuconf ='Y' AND rvu00='1' AND rvv01=rvu01
      SELECT SUM(rvv17) INTO l_rvb29 FROM rvv_file,rvu_file     #計算驗退
       WHERE rvv04=l_rvv.rvv04 AND rvv05=l_rvv.rvv05
             AND rvuconf ='Y' AND rvu00='2' AND rvv01=rvu01
      SELECT SUM(rvv17) INTO l_rvb291 FROM rvv_file,rvu_file    #計算倉退
       WHERE rvv04=l_rvv.rvv04 AND rvv05=l_rvv.rvv05
             AND rvuconf ='Y' AND rvu00='3' AND rvv01=rvu01
      IF cl_null(l_rvb30) THEN LET l_rvb30=0 END IF
      IF cl_null(l_rvb29) THEN LET l_rvb29=0 END IF
      IF cl_null(l_rvb291) THEN LET l_rvb291=0 END IF
      SELECT rvb07 INTO l_qty FROM rvb_file
       WHERE rvb01=l_rvv.rvv04 AND rvb02=l_rvv.rvv05
      IF l_qty<(l_rvb30+l_rvb29) AND p_argv1 <>'2' THEN #BugNo:5547
         CALL cl_err('rvb07<rvb29+30:','asf-804',1)    #MOD-A70097 asf-660-->asf-804
         LET g_success = 'N' RETURN
      END IF
      SELECT rvb39 INTO l_rvb39
        FROM rvb_file
       WHERE rvb01 = l_rvu.rvu02
         AND rvb02 = l_rvv.rvv05
      IF l_rvb39 = 'Y' THEN
          UPDATE rvb_file SET rvb29 = l_rvb29,         #驗退量
                              rvb30 = l_rvb30,         #入庫量
                              rvb09 = l_rvb30-l_rvb291,#允請量
                              rvb31 = rvb33-l_rvb30    # 可入庫量 
           WHERE rvb01 = l_rvu.rvu02 AND rvb02 = l_rvv.rvv05
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","rvb_file",l_rvu.rvu02,l_rvv.rvv05,SQLCA.sqlcode,"","退 upd rvb29,rvb09,rvb31:",1)
             LET g_success = 'N' RETURN
          END IF
      ELSE
          UPDATE rvb_file SET rvb29 = l_rvb29,         #驗退量
                              rvb30 = l_rvb30,         #入庫量
                              rvb09 = l_rvb30-l_rvb291,#允請量
                              rvb31 = rvb07-l_rvb29-l_rvb30 # 可入庫量
           WHERE rvb01 = l_rvu.rvu02 AND rvb02 = l_rvv.rvv05
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","rvb_file",l_rvu.rvu02,l_rvv.rvv05,SQLCA.sqlcode,"","退 upd rvb29,rvb09,rvb31:",1)  
             LET g_success = 'N' RETURN
          END IF
      END IF
      SELECT ima918,ima921 INTO l_ima918,l_ima921 
        FROM ima_file
       WHERE ima01 = l_rvv.rvv31
         AND imaacti = "Y"
      
      IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
         IF g_sma.sma90 = "Y" THEN #MOD-C30074 add
            CALL t720sub_upd_rvbs(1,l_rvu.rvu01,l_rvu.rvu02,l_rvv.rvv02,l_rvv.rvv05)
         END IF #MOD-C30074 add
      END IF
  END IF 
#---------更新採購單退貨量
      IF NOT cl_null(l_rvv.rvv36) AND l_rvv.rvv25='N' THEN
         SELECT SUM(rvv17) INTO l_rvv17 FROM rvv_file,rvu_file     #計算倉退
          WHERE rvv36=l_rvv.rvv36 AND rvv37=l_rvv.rvv37
            AND rvuconf ='Y' AND rvu00='3' AND rvv01=rvu01 AND rvv25='N'
            AND rvu116='2' #MOD-B30556
         IF cl_null(l_rvv17) THEN LET l_rvv17=0 END IF

         SELECT SUM(rvb29) INTO l_rvb29 FROM rvb_file,rva_file  #計算驗退
          WHERE rvb04=l_rvv.rvv36 AND rvb03=l_rvv.rvv37
            AND rvaconf='Y' AND rvb01=rva01 AND rvb35='N'
         IF cl_null(l_rvb29) THEN LET l_rvb29=0 END IF

         IF l_rvu.rvu116 = '2' AND l_rvu.rvu00 = '3' THEN
            UPDATE pmn_file SET pmn58 = l_rvv17
               WHERE pmn01 = l_rvv.rvv36 AND pmn02 = l_rvv.rvv37
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","pmn_file",l_rvv.rvv36,l_rvv.rvv37,SQLCA.sqlcode,"","upd pmn58:",1)  
               LET g_success = 'N'
            END IF
         END IF
         UPDATE pmn_file SET pmn55 = l_rvb29
            WHERE pmn01 = l_rvv.rvv36 AND pmn02 = l_rvv.rvv37
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","pmn_file",l_rvv.rvv36,l_rvv.rvv37,SQLCA.sqlcode,"","upd pmn55:",1)
            LET g_success = 'N'
         END IF
#--------更新超短交量 = 收貨量 - 訂購量
         CALL s_udpmn57(l_rvv.rvv36,l_rvv.rvv37)
       END IF
### ---委外倉退確認應update sfb09=sfb09-倉退量*轉換率
  #Mark by zm 131121 委外仓退不更新sfb09
 #  IF l_rvu.rvu08='SUB' AND NOT cl_null(l_rvv.rvv18) THEN
 #     INITIALIZE l_sfb.* TO NULL
 #     SELECT * INTO l_sfb.* FROM sfb_file
 #      WHERE sfb01=l_rvv.rvv18   #單號
 #        AND sfb02=7             #委外
 #        AND sfb04<>'8'          #結案
 #     IF l_sfb.sfb05=l_rvv.rvv31 #料件
 #        THEN
 #        SELECT ima55 INTO l_ima55 FROM ima_file
 #         WHERE ima01 = l_rvv.rvv31
 #        CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv35,l_ima55)   #生產/入庫
 #             RETURNING l_cnt,l_factor
 #        IF l_cnt THEN
 #           CALL cl_err('(t720_bu)rvv35/ima55: ','abm-731',1)
 #           LET g_success ='N'
 #           RETURN
 #        END IF
 #        #bugno:5475 add * l_factor
 #        UPDATE sfb_file SET sfb09=sfb09-( l_rvv.rvv17 * l_factor )  #數量
 #         WHERE sfb01 = l_rvv.rvv18
 #        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
 #           CALL cl_err3("upd","sfb_file",l_rvv.rvv18,"",SQLCA.sqlcode,"","Update sfb",1)  
 #           LET g_success = 'N'
 #           RETURN
 #        END IF
 #     END IF
 #  END IF
  #Mark by zm 131121 委外仓退不更新sfb09
END FUNCTION

FUNCTION t720sub_update_imgg(p_type,l_rvv,p_rvu03)
  DEFINE l_ima25   LIKE ima_file.ima25,
         p_type    LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE l_ima906  LIKE ima_file.ima906
  DEFINE l_ima907  LIKE ima_file.ima907
  DEFINE l_rvv     RECORD LIKE rvv_file.*
  DEFINE p_rvu03   LIKE rvu_file.rvu03

   IF g_sma.sma115 = 'N' THEN RETURN END IF

   SELECT ima906,ima907,ima25 INTO l_ima906,l_ima907,l_ima25 FROM ima_file
    WHERE ima01 = l_rvv.rvv31
   IF SQLCA.sqlcode THEN
      LET g_success='N' RETURN
   END IF

   IF l_ima906 = '1' OR cl_null(l_ima906) THEN RETURN END IF

   IF l_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(l_rvv.rvv83) THEN
         CALL t720sub_upd_imgg('1',l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv83,l_rvv.rvv84,l_rvv.rvv85,p_type,'2',p_rvu03)
         IF g_success='N' THEN RETURN END IF
      END IF
      IF NOT cl_null(l_rvv.rvv80) THEN
         CALL t720sub_upd_imgg('1',l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv80,l_rvv.rvv81,l_rvv.rvv82,p_type,'1',p_rvu03)
         IF g_success='N' THEN RETURN END IF
      END IF
   END IF
   IF l_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(l_rvv.rvv83) THEN
         CALL t720sub_upd_imgg('2',l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv83,l_rvv.rvv84,l_rvv.rvv85,p_type,'2',p_rvu03)
         IF g_success='N' THEN RETURN END IF
      END IF
   END IF

END FUNCTION

FUNCTION t720sub_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                       p_imgg09,p_imgg211,p_imgg10,p_type,p_no,p_rvu03)
  DEFINE p_imgg00   LIKE imgg_file.imgg00,
         p_imgg01   LIKE imgg_file.imgg01,
         p_imgg02   LIKE imgg_file.imgg02,
         p_imgg03   LIKE imgg_file.imgg03,
         p_imgg04   LIKE imgg_file.imgg04,
         p_imgg09   LIKE imgg_file.imgg09,
         p_imgg211  LIKE imgg_file.imgg211,
         l_ima25    LIKE ima_file.ima25,
         l_imgg21   LIKE imgg_file.imgg21,
         p_imgg10   LIKE imgg_file.imgg10,
         p_no       LIKE type_file.chr1,  
         p_type     LIKE type_file.num10 
  DEFINE l_ima906   LIKE ima_file.ima906
  DEFINE l_ima907   LIKE ima_file.ima907
  DEFINE p_rvu03    LIKE rvu_file.rvu03
  DEFINE l_cnt      LIKE type_file.num5
  DEFINE l_forupd_sql  STRING

    LET l_forupd_sql =
        "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",
        " WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
        "   AND imgg09= ? FOR UPDATE "
    LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
    DECLARE imgg_lock CURSOR FROM l_forupd_sql

    OPEN imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
    IF STATUS THEN
       CALL cl_err("OPEN imgg_lock:", STATUS, 1)
       LET g_success='N'
       CLOSE imgg_lock
       RETURN
    END IF
    FETCH imgg_lock INTO p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
    IF STATUS THEN
       CALL cl_err('lock imgg fail',STATUS,1)
       LET g_success='N'
       CLOSE imgg_lock
       RETURN
    END IF

    SELECT ima25,ima906,ima907 INTO l_ima25,l_ima906,l_ima907
      FROM ima_file WHERE ima01=p_imgg01
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
       CALL cl_err('ima25 null',SQLCA.sqlcode,0)
       LET g_success = 'N' RETURN
    END IF

    CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
          RETURNING l_cnt,l_imgg21
    IF l_cnt = 1 AND NOT (l_ima906 = '3' AND p_no='2') THEN
       CALL cl_err('','mfg3075',0)
       LET g_success = 'N' RETURN
    END IF
  #FUN-D60130 -----Begin-----
    IF g_prog = 'apmt732' OR g_prog = 'apmt732_icd' THEN
       LET p_imgg10 = 0 
    END IF
  #FUN-D60130 -----End-------
    CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,p_rvu03, 
          p_imgg01,p_imgg02,p_imgg03,p_imgg04,'','','','',p_imgg09,'',l_imgg21,'','','','','','','',p_imgg211)
    IF g_success='N' THEN RETURN END IF

END FUNCTION

FUNCTION t720sub_chk_sfb(l_rvv,p_rvu08)
  DEFINE l_sfb05       LIKE sfb_file.sfb05   #料件編號
  DEFINE l_sfb39       LIKE sfb_file.sfb39   #完工方式
  DEFINE l_sfb93       LIKE sfb_file.sfb93   #制程否
  DEFINE l_min_set     LIKE sfb_file.sfb08
  DEFINE l_pmn07       LIKE pmn_file.pmn07
  DEFINE l_i           LIKE type_file.num5
  DEFINE l_fac         LIKE ima_file.ima31_fac
  DEFINE l_ima55       LIKE ima_file.ima55
  DEFINE l_rvv17_1,l_rvv17_2   LIKE rvv_file.rvv17  
  DEFINE p_rvu08       LIKE rvu_file.rvu08
  DEFINE l_rvv         RECORD LIKE rvv_file.*

  SELECT sfb05,sfb39,sfb93 INTO l_sfb05,l_sfb39,l_sfb93
    FROM sfb_file
   WHERE sfb01 = l_rvv.rvv18
  
  IF l_sfb39 != '2' THEN
     IF p_rvu08 = 'SUB' AND l_sfb05 = l_rvv.rvv31 THEN
        IF l_sfb93 != 'Y' THEN
           CALL t720sub_minp(l_rvv.rvv18,l_rvv.rvv31) RETURNING l_min_set
           SELECT ima55 INTO l_ima55 FROM ima_file
            WHERE ima01 = l_rvv.rvv31
           SELECT pmn07 INTO l_pmn07 FROM pmn_file
            WHERE pmn01 = l_rvv.rvv36 AND pmn02 = l_rvv.rvv37
           CALL s_umfchk(l_rvv.rvv31,l_pmn07,l_ima55)
                RETURNING l_i,l_fac
           IF l_i = 1 THEN
              #採購單位無法與料件的生產單位做換算,預設轉換率為1
              CALL cl_err(l_rvv.rvv31,'apm-120',1)
              LET l_fac = 1
           END IF
           LET l_min_set = l_min_set / l_fac
           LET l_rvv17_1 = 0
           SELECT SUM(rvv17) INTO l_rvv17_1 FROM rvv_file,rvu_file 
             WHERE rvv18 = l_rvv.rvv18 AND rvv01=rvu01
               AND rvu08 = 'SUB' AND rvu00 = '1'
               AND rvuconf = 'Y' 
               AND NOT (rvv01 = l_rvv.rvv01 AND rvv02 = l_rvv.rvv02)
               AND rvv31 = l_sfb05 
           IF cl_null(l_rvv17_1) THEN LET l_rvv17_1 = 0 END IF
           LET l_rvv17_2 = 0
           SELECT SUM(rvv17) INTO l_rvv17_2 FROM rvv_file,rvu_file 
             WHERE rvv18 = l_rvv.rvv18 AND rvv01=rvu01
               AND rvu08 = 'SUB' AND rvu00 = '2'
               AND rvuconf = 'Y' 
               AND NOT (rvv01 = l_rvv.rvv01 AND rvv02 = l_rvv.rvv02)
               AND rvv31 = l_sfb05  
           IF cl_null(l_rvv17_2) THEN LET l_rvv17_2 = 0 END IF
           LET l_min_set = l_min_set - l_rvv17_1 + l_rvv17_2

           IF l_rvv.rvv17 > l_min_set THEN
              #完工入庫數量大于工單發料數量
              CALL cl_err(l_rvv.rvv17,'apm-722',1)
              LET g_success = 'N'
              RETURN
           END IF
        END IF
     END IF
  END IF
END FUNCTION

FUNCTION t720sub_minp(p_rvv18,p_rvv31)
   DEFINE l_sfb08      LIKE sfb_file.sfb05
   DEFINE l_sfa06      LIKE sfa_file.sfa06
   DEFINE l_sfa05      LIKE sfa_file.sfa05
   DEFINE l_sfa062     LIKE sfa_file.sfa062
   DEFINE l_sfa063     LIKE sfa_file.sfa063
   DEFINE l_sfa        RECORD LIKE sfa_file.*      
   DEFINE l_min_set    LIKE sfb_file.sfb08,
          l_min_set_t  LIKE sfb_file.sfb08,
          l_sql        STRING,     
          l_cnt        LIKE type_file.num5
   DEFINE l_over_qty   LIKE sfb_file.sfb08     
   DEFINE l_cnt1       LIKE type_file.num5                                                                       
   DEFINE l_cnt2       LIKE type_file.num5   
   DEFINE l_ima153     LIKE ima_file.ima153 
   DEFINE p_rvv18      LIKE rvv_file.rvv18
   DEFINE p_rvv31      LIKE rvv_file.rvv31
   DEFINE l_sfa065     LIKE sfa_file.sfa065  #FUN-C30166

   LET l_min_set = 0
   LET l_min_set_t=0
   
   #抓取公工單生產數量
    SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01 = p_rvv18
    IF cl_null(l_sfb08) THEN LET l_sfb08 = 0 END IF
   
    LET l_sql = " SELECT * FROM sfa_file ",
                " WHERE sfa01 ='",p_rvv18 CLIPPED,"' ",
                #"   AND sfa065 = 0 ",   #FUN-C30166
                "   AND sfa11 <> 'E' ",
                "   AND sfa161 > 0 "
   PREPARE t720_min_p1 FROM l_sql
   DECLARE t720_min_c1 CURSOR WITH HOLD FOR t720_min_p1
   LET l_cnt = 0
                                                                                                         
   LET l_cnt1=0                                                                                                                     
   LET l_cnt2=0                                                                                                                     
   SELECT COUNT(*) INTO l_cnt1 FROM sfa_file                                                                                        
    WHERE sfa01=p_rvv18 AND sfa26 NOT MATCHES '[SUZ]'                                                                                 
      #AND sfa065=0 AND sfa161>0 AND sfa11<>'E'  #FUN-C30166
      AND sfa161>0 AND sfa11<>'E'  #FUN-C30166
    SELECT COUNT(*) INTO l_cnt2 FROM  sfa_file                                                                                       
     WHERE sfa01=p_rvv18 AND sfa26 NOT MATCHES '[SUZ]'                                                                                
      #AND sfa161>0 AND (sfa11='E'OR sfa065 > 0)   #FUN-C30166 
       AND sfa161>0 AND sfa11='E'  #FUN-C30166                                                                                  
   IF l_cnt1 = 0 THEN                
      IF l_cnt2 > 0 THEN                                                                                                            
         LET l_min_set_t = l_sfb08                                                                                                  
         RETURN l_min_set_t                                                                                                         
      END IF                                                                                                                        
   END IF                                                                                                                           

   FOREACH t720_min_c1 INTO l_sfa.*
      IF l_sfa.sfa26 MATCHES '[348]' THEN
         #SELECT SUM(sfa06/sfa28),SUM(sfa05/sfa28),SUM(sfa062/sfa28),SUM(sfa063/sfa28)  #FUN-C30166
            #INTO l_sfa06,l_sfa05,l_sfa062,l_sfa063 FROM sfa_file   #FUN-C30166
         SELECT SUM(sfa06/sfa28),SUM(sfa05/sfa28),SUM(sfa062/sfa28),SUM(sfa063/sfa28),SUM(sfa065/sfa28)  #FUN-C30166
          INTO l_sfa06,l_sfa05,l_sfa062,l_sfa063,l_sfa065 FROM sfa_file   #FUN-C30166
            WHERE sfa01=l_sfa.sfa01
             AND sfa27=l_sfa.sfa03
             AND sfa08=l_sfa.sfa08
            #AND sfa12=l_sfa.sfa12   #MOD-C50248 mark
             AND sfa012=l_sfa.sfa012 #FUN-A60027
             AND sfa013=l_sfa.sfa013 #FUN-A60027
         LET l_sfa.sfa06  = l_sfa06 
         LET l_sfa.sfa05  = l_sfa05 
         LET l_sfa.sfa062 = l_sfa062
         LET l_sfa.sfa063 = l_sfa063
         LET l_sfa.sfa065 = l_sfa065  #FUN-C30166
      END IF
      IF l_sfa.sfa26 MATCHES '[USZ]' THEN
         CONTINUE FOREACH
      END IF
      LET l_cnt = l_cnt + 1 
      IF l_cnt = 1 THEN 
         #LET l_min_set=((l_sfa.sfa06-l_sfa.sfa063+l_sfa.sfa062)/l_sfa.sfa05)*l_sfb08               #FUN-C30166
         LET l_min_set=((l_sfa.sfa06+l_sfa.sfa065-l_sfa.sfa063+l_sfa.sfa062)/l_sfa.sfa05)*l_sfb08   #FUN-C30166
         IF cl_null(l_sfa.sfa100) THEN LET l_sfa.sfa100 = 0 END If
         IF g_sma.sma899 = 'Y' AND l_sfa.sfa100 <> 100 THEN 
            LET l_min_set = l_min_set * (1+l_sfa.sfa100/100)
         END IF
         IF l_sfa.sfa100 = 100 THEN
            SELECT sfb08 INTO l_min_set FROM sfb_file 
              WHERE sfb01 = l_sfa.sfa01
         END IF
         LET l_min_set_t = l_min_set
      ELSE
         #LET l_min_set=((l_sfa.sfa06-l_sfa.sfa063+l_sfa.sfa062)/l_sfa.sfa05)*l_sfb08               #FUN-C30166
         LET l_min_set=((l_sfa.sfa06+l_sfa.sfa065-l_sfa.sfa063+l_sfa.sfa062)/l_sfa.sfa05)*l_sfb08   #FUN-C30166
         IF cl_null(l_sfa.sfa100) THEN LET l_sfa.sfa100 = 0 END If
         IF g_sma.sma899 = 'Y' AND l_sfa.sfa100 <> 100 THEN 
            LET l_min_set = l_min_set * (1+l_sfa.sfa100/100)
         END IF
         IF l_sfa.sfa100 = 100 THEN
            SELECT sfb08 INTO l_min_set FROM sfb_file 
              WHERE sfb01 = l_sfa.sfa01
         END IF
         IF l_min_set < l_min_set_t THEN
            LET l_min_set_t = l_min_set
         END IF
      END IF
   END FOREACH
  # sma73 工單完工數量是否檢查發料最小套數
  # sma74 工單完工量容許差異百分比
   CALL s_get_ima153(p_rvv31) RETURNING l_ima153 
   LET l_over_qty = 0
   IF g_sma.sma73='Y' THEN
      LET l_over_qty=((l_min_set_t*l_ima153)/100)  
   ELSE
      LET l_over_qty=0
   END IF
   IF l_over_qty IS NULL THEN LET l_over_qty=0 END IF
   LET l_min_set_t = l_min_set_t + l_over_qty
   RETURN l_min_set_t
END FUNCTION

FUNCTION t720sub_log_r(l_rvv,p_ima25)
  DEFINE l_sta       LIKE type_file.num5,
         l_flag      LIKE type_file.num5, 
         l_ima25_fac LIKE tlf_file.tlf60,
         l_img09     LIKE img_file.img09,       #庫存單位
         l_img10     LIKE img_file.img10,       #庫存數量
         l_img26     LIKE img_file.img26,
         l_pmn65     LIKE pmn_file.pmn65,
         p_ima25     LIKE ima_file.ima25
  DEFINE l_rvv       RECORD LIKE rvv_file.*
  DEFINE l_ima39     LIKE ima_file.ima39
  DEFINE l_ima25     LIKE ima_file.ima25

  SELECT img09,img10,img26 INTO l_img09,l_img10,l_img26
    FROM img_file WHERE img01 = l_rvv.rvv31 AND img02 = l_rvv.rvv32
                    AND img03 = l_rvv.rvv33 AND img04 = l_rvv.rvv34
  IF SQLCA.sqlcode THEN
     CALL cl_err3("sel","img_file",l_rvv.rvv31,"",SQLCA.sqlcode,"","ckp#log",1)
     LET g_success = 'N' RETURN
  END IF
  SELECT ima39 INTO l_ima39 FROM ima_file WHERE ima01=l_rvv.rvv31

     LET g_tlf.tlf01  = l_rvv.rvv31       #異動料件編號
     LET g_tlf.tlf020 = g_plant           #工廠別
     LET g_tlf.tlf02  = 50                #來源狀況
     LET g_tlf.tlf021=l_rvv.rvv32         #倉庫別
     LET g_tlf.tlf022=l_rvv.rvv33         #儲位別
     LET g_tlf.tlf023=l_rvv.rvv34         #批號
     LET g_tlf.tlf024=''                  #異動後庫存數量
     LET g_tlf.tlf025=''                  #庫存單位(ima_file or img_file)
     SELECT pmn41 INTO g_tlf.tlf026 FROM pmn_file
        WHERE pmn01=l_rvv.rvv36 AND pmn02=l_rvv.rvv37
     IF STATUS THEN LET g_tlf.tlf026=' ' END IF  #工單單號
     LET g_tlf.tlf027=0       #單據項次
     LET g_tlf.tlf03  = 18                #資料目的為倉庫 No.7692
     LET g_tlf.tlf031=' '                 #倉庫別
     LET g_tlf.tlf032=' '                 #儲位別
     LET g_tlf.tlf033=' '                 #批號
     LET g_tlf.tlf034=l_img10             #異動後存數量
     LET g_tlf.tlf035=p_ima25             #庫存單位(ima_file or img_file)
     LET g_tlf.tlf036=l_rvv.rvv01         #參考號碼(入庫單號)
     LET g_tlf.tlf037=l_rvv.rvv02
#--->異動數量
    LET g_tlf.tlf04=' '                  #工作站
    LET g_tlf.tlf05=' '                  #作業序號
    LET g_tlf.tlf06=l_rvv.rvv09          #日期
    LET g_tlf.tlf07=g_today              #異動資料產生日期
    LET g_tlf.tlf08=TIME                 #異動資料產生時:分:秒
    LET g_tlf.tlf09=g_user               #產生人
    LET g_tlf.tlf10=l_rvv.rvv17          #收料數量
    LET g_tlf.tlf11=l_rvv.rvv35          #收料單位
    LET g_tlf.tlf12=l_rvv.rvv35_fac      #收料/庫存轉換率
    LET g_tlf.tlf13='asfi511'            #異動命令代號
    LET g_tlf.tlf14= l_rvv.rvv26
    IF g_sma.sma12='N' THEN             #借方會計科目
        LET g_tlf.tlf15=l_ima39          #料件會計科目
    ELSE
        LET g_tlf.tlf15=l_img26          #倉儲會計科目
    END IF
    LET g_tlf.tlf16=' '                  #貸方
    LET g_tlf.tlf17=' '                  #非庫存性料件編號
    CALL s_imaQOH(l_rvv.rvv31)
         RETURNING g_tlf.tlf18           #異動後總庫存量
    LET g_tlf.tlf19= l_rvv.rvv06         #異動廠商/客戶編號
    LET g_tlf.tlf20= l_rvv.rvv34         #專案號碼
    SELECT ima25       #庫存單位
      INTO l_ima25
      FROM ima_file WHERE ima01=l_rvv.rvv31 AND imaacti='Y'
    CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv35,l_ima25)
         RETURNING l_flag,l_ima25_fac
    IF l_flag THEN
      ###Modify:98/11/15 ----單位換算率抓不到 -----#####
      CALL cl_err('rvv35/ima25: ','abm-731',1)
      LET g_success ='N'
      LET l_ima25_fac = 1.0
    END IF
    LET g_tlf.tlf60=l_ima25_fac

    LET g_tlf.tlf62= l_rvv.rvv18
    LET g_tlf.tlf63= ' '
    LET g_tlf.tlf64 = l_rvv.rvv41        #手冊編號 
    LET g_tlf.tlf930 = l_rvv.rvv930  

    SELECT pmn122,pmn96,pmn97,pmn98
      INTO g_tlf.tlf20,g_tlf.tlf41,g_tlf.tlf42,g_tlf.tlf43
      FROM pmn_file
     WHERE pmn01 = l_rvv.rvv36
       AND pmn02 = l_rvv.rvv37
    IF SQLCA.sqlcode THEN
      LET g_tlf.tlf20 = ' '
      LET g_tlf.tlf41 = ' '
      LET g_tlf.tlf42 = ' '
      LET g_tlf.tlf43 = ' '
    END IF
#FUN-D60130 -----Begin--------
    IF g_prog = 'apmt732' OR g_prog = 'apmt732_icd' THEN
       LET g_tlf.tlf10 = 0
    END IF  
#FUN-D60130 -----End----------
    CALL s_tlf(1,0)
END FUNCTION

FUNCTION t720sub_log_r_du(p_flag,p_unit,p_fac,p_qty,p_ima25,l_rvv)
  DEFINE p_unit       LIKE imgg_file.imgg09,
         p_fac        LIKE imgg_file.imgg21,
         p_flag       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
         p_qty        LIKE imgg_file.imgg10,
         l_sta        LIKE type_file.num5,    #No.FUN-680136 SMALLINT
         l_flag       LIKE type_file.num5,    #No.FUN-680136 SMALLINT
         l_ima25_fac  LIKE tlff_file.tlff60,
         l_imgg09     LIKE imgg_file.imgg09,       #庫存單位
         l_imgg10     LIKE imgg_file.imgg10,       #庫存數量
         l_imgg26     LIKE imgg_file.imgg26,
         l_pmn65      LIKE pmn_file.pmn65
  DEFINE l_ima25      LIKE ima_file.ima25
  DEFINE l_ima906     LIKE ima_file.ima906
  DEFINE l_ima907     LIKE ima_file.ima907
  DEFINE p_ima25      LIKE ima_file.ima25
  DEFINE l_ima39      LIKE ima_file.ima39
  DEFINE l_rvv        RECORD LIKE rvv_file.*
  

  SELECT imgg10,imgg26 INTO l_imgg10,l_imgg26
    FROM imgg_file WHERE imgg01 = l_rvv.rvv31 AND imgg02 = l_rvv.rvv32
                     AND imgg03 = l_rvv.rvv33 AND imgg04 = l_rvv.rvv34
                     AND imgg09 = p_unit
  IF SQLCA.sqlcode THEN
     CALL cl_err3("sel","imgg_file",l_rvv.rvv31,"",SQLCA.sqlcode,"","ckp#log",1)
     LET g_success = 'N' RETURN
  END IF
  SELECT ima39 INTO l_ima39 FROM ima_file WHERE ima01=l_rvv.rvv31

     LET g_tlff.tlff01  = l_rvv.rvv31       #異動料件編號
     LET g_tlff.tlff020 = g_plant           #工廠別
     LET g_tlff.tlff02  = 50                #來源狀況
     LET g_tlff.tlff021 =l_rvv.rvv32         #倉庫別
     LET g_tlff.tlff022 =l_rvv.rvv33         #儲位別
     LET g_tlff.tlff023 =l_rvv.rvv34         #批號
     LET g_tlff.tlff024 =''                  #異動後庫存數量
     LET g_tlff.tlff025 =''                  #庫存單位(ima_file or imgg_file)
     SELECT pmn41 INTO g_tlff.tlff026 FROM pmn_file
        WHERE pmn01=l_rvv.rvv36 AND pmn02=l_rvv.rvv37
     IF STATUS THEN LET g_tlff.tlff026=' ' END IF  #工單單號
     LET g_tlff.tlff027 =0        #單據項次
     LET g_tlff.tlff03  = 18                #資料目的為倉庫 No.7692
     LET g_tlff.tlff031 =' '                #倉庫別
     LET g_tlff.tlff032 =' '                #儲位別
     LET g_tlff.tlff033 =' '                #批號
     LET g_tlff.tlff034 =l_imgg10           #異動後存數量
     LET g_tlff.tlff035 =p_ima25            #庫存單位(ima_file or imgg_file) #FUN-A10130
     LET g_tlff.tlff036 =l_rvv.rvv01        #參考號碼(入庫單號)
     LET g_tlff.tlff037 =l_rvv.rvv02
#--->異動數量
    LET g_tlff.tlff04=' '                  #工作站
    LET g_tlff.tlff05=' '                  #作業序號
    LET g_tlff.tlff06=l_rvv.rvv09          #日期
    LET g_tlff.tlff07=g_today              #異動資料產生日期
    LET g_tlff.tlff08=TIME                 #異動資料產生時:分:秒
    LET g_tlff.tlff09=g_user               #產生人
    LET g_tlff.tlff10=p_qty                #收料數量
    LET g_tlff.tlff11=p_unit               #收料單位
    LET g_tlff.tlff12=p_fac                #收料/庫存轉換率
    LET g_tlff.tlff13='asfi511'            #異動命令代號
    LET g_tlff.tlff14= l_rvv.rvv26
    IF g_sma.sma12='N' THEN             #借方會計科目
        LET g_tlff.tlff15=l_ima39          #料件會計科目
    ELSE
        LET g_tlff.tlff15=l_imgg26          #倉儲會計科目
    END IF
    LET g_tlff.tlff16=' '                  #貸方
    LET g_tlff.tlff17=' '                  #非庫存性料件編號
    CALL s_imaQOH(l_rvv.rvv31)
         RETURNING g_tlff.tlff18           #異動後總庫存量
    LET g_tlff.tlff19= l_rvv.rvv06         #異動廠商/客戶編號
    LET g_tlff.tlff20= l_rvv.rvv34         #專案號碼
    SELECT ima25,ima906,ima907       #庫存單位
      INTO l_ima25,l_ima906,l_ima907
      FROM ima_file WHERE ima01=l_rvv.rvv31 AND imaacti='Y'
    CALL s_umfchk(l_rvv.rvv31,p_unit,l_ima25)
         RETURNING l_flag,l_ima25_fac
    IF l_flag AND NOT (l_ima906='3' AND p_flag ='2') THEN
      ###Modify:98/11/15 ----單位換算率抓不到 -----#####
      CALL cl_err('rvv35/ima25: ','abm-731',1)
      LET g_success ='N'
      LET l_ima25_fac = 1.0
    END IF
    LET g_tlff.tlff60=l_ima25_fac
#--------------------------------

    LET g_tlff.tlff62= l_rvv.rvv18
    LET g_tlff.tlff63= ' '
    LET g_tlff.tlff64 = l_rvv.rvv41        #手冊編號 no.A050
    LET g_tlff.tlff930= l_rvv.rvv930   
#FUN-D60130 ------Begin-------
    IF g_prog = 'apmt732' OR g_prog = 'apmt732_icd' THEN
       LET g_tlff.tlff10 = 0
    END IF
#FUN-D60130 ------End--------
    IF cl_null(l_rvv.rvv85) OR l_rvv.rvv85 = 0 THEN
       CALL s_tlff(p_flag,NULL)
    ELSE
       CALL s_tlff(p_flag,l_rvv.rvv83)
    END IF
END FUNCTION

FUNCTION t720sub_IQC_return(l_rvu,p_argv1,p_argv3,p_chr,p_inTransaction,p_ask_post,p_rva00)
   DEFINE l_n,l_cnt    LIKE type_file.num5    
   DEFINE l_rvu        RECORD LIKE rvu_file.*
   DEFINE la_rvu       RECORD LIKE rvu_file.*
   DEFINE la_rvv       RECORD LIKE rvv_file.*
   DEFINE lb_rvv       RECORD LIKE rvv_file.*
   DEFINE la_rvvi      RECORD LIKE rvvi_file.*
   DEFINE lb_rvvi      RECORD LIKE rvvi_file.*
   DEFINE l_rvv17      LIKE rvv_file.rvv17
   DEFINE l_smy51,l_slip    LIKE oay_file.oayslip   
   DEFINE l_smy57     LIKE type_file.chr1  
   DEFINE l_ins_rvv_ok LIKE type_file.chr1  
   DEFINE l_ima906     LIKE ima_file.ima906
   DEFINE li_result    LIKE type_file.num5   
   DEFINE l_imaicd04  LIKE imaicd_file.imaicd04
   DEFINE l_rvv82     LIKE rvv_file.rvv82
   DEFINE l_rvv85     LIKE rvv_file.rvv85   
   DEFINE l_rvvi       RECORD LIKE rvvi_file.*  
   DEFINE l_rvb82         LIKE rvb_file.rvb82 
   DEFINE l_rvb85         LIKE rvb_file.rvb85 
   DEFINE l_rvb39         LIKE rvb_file.rvb39 
   DEFINE l_okqty_rvv82   LIKE rvv_file.rvv82 
   DEFINE l_okqty_rvv85   LIKE rvv_file.rvv85 
   DEFINE l_qcs22         LIKE qcs_file.qcs22 
   DEFINE l_qcs091        LIKE qcs_file.qcs091
   DEFINE l_qcs32         LIKE qcs_file.qcs32 
   DEFINE l_qcs35         LIKE qcs_file.qcs35 
   DEFINE l_qcs38         LIKE qcs_file.qcs38 
   DEFINE l_qcs41         LIKE qcs_file.qcs41 
   DEFINE l_ima918        LIKE ima_file.ima918
   DEFINE l_ima921        LIKE ima_file.ima921
   DEFINE l_cmd           LIKE type_file.chr1000
   DEFINE l_msg           LIKE ze_file.ze03
   DEFINE l_factor        LIKE pmn_file.pmn09
   DEFINE p_inTransaction LIKE type_file.num5 
   DEFINE p_ask_post      LIKE type_file.chr1
   DEFINE p_chr           LIKE type_file.chr1
   DEFINE p_argv1         LIKE rvu_file.rvu00
   DEFINE p_argv3         LIKE rvu_file.rvu08
   DEFINE l_rvb07         LIKE rvb_file.rvb07
   DEFINE l_rvb30         LIKE rvb_file.rvb30
   DEFINE l_sql           STRING
   DEFINE p_rva00         LIKE rva_file.rva00
   DEFINE l_smyapr    LIKE smy_file.smyapr    #FUN-A60009 add
   #FUN-BC0104---add---str---
   DEFINE l_qcl05         LIKE qcl_file.qcl05
   DEFINE l_qco03         LIKE qco_file.qco03
   DEFINE l_qco04         LIKE qco_file.qco04
   DEFINE l_sql1          STRING
   DEFINE l_n1            LIKE type_file.num5
   #FUN-BC0104---add---end---

   SELECT rvb07,rvb30 INTO l_rvb07,l_rvb30 FROM rvb_file
    WHERE rvb01=l_rvu.rvu02 AND rvb02=1
   #FUN-BC0104---add---str---
   LET l_n=0
   LET l_sql = "SELECT COUNT(*) FROM rvb_file,rvv_file",
               " WHERE rvb01='",l_rvu.rvu02 CLIPPED,
               "'  AND rvv01='",l_rvu.rvu01 CLIPPED,
               "'  AND rvb07>rvb30 AND rvb01=rvv04",
               "   AND rvb02=rvv05 AND rvv17>0"
   LET l_sql1 = l_sql CLIPPED," AND rvv46 IS NOT NULL"

   PREPARE ins_ln  FROM l_sql
   PREPARE ins_ln1 FROM l_sql1

   EXECUTE ins_ln  INTO l_n
   EXECUTE ins_ln1 INTO l_n1
   IF l_n=0 THEN RETURN END IF

   IF l_n1>0 THEN 
      LET l_n1=0
      SELECT COUNT(*) INTO l_n1 FROM qco_file,rvb_file
       WHERE qco01=l_rvu.rvu02
         AND rvb01=qco01 
         AND rvb02=qco02
         AND qco11>qco20
      IF l_n1 =0 THEN RETURN END IF
   END IF
   #FUN-BC0104---add---end--- 

   #FUN-BC0104---mark---str---
   #SELECT COUNT(*) INTO l_n FROM rvb_file,rvv_file
   # WHERE rvb01=l_rvu.rvu02
   #   AND rvv01=l_rvu.rvu01
   #   AND rvb07>rvb30        #實收-入庫
   #   AND rvb01=rvv04
   #   AND rvb02=rvv05
   #   AND rvv17>=0            #入庫數量
   #IF l_n=0 THEN RETURN END IF           #如果全部入庫
   #FUN-BC0104---mark---end---
   IF p_ask_post='Y' THEN  # 外部呼叫的程式不可出現詢問視窗
      IF NOT cl_confirm('apm-270') THEN RETURN END IF
   END IF
   IF NOT p_inTransaction THEN
     BEGIN WORK
   END IF
   LET la_rvu.*    =l_rvu.*
   LET la_rvu.rvu00='2'           #異動類別
   LET l_msg=l_rvu.rvu01[1,g_doc_len]
   LET l_slip=l_rvu.rvu02[1,g_doc_len]
   LET l_slip = s_get_doc_no(l_rvu.rvu02)     
   SELECT smy51,smy57[3,3] INTO l_smy51,l_smy57
     FROM smy_file WHERE smyslip=l_slip
   IF STATUS OR cl_null(l_smy51) THEN
      CALL cl_err3("sel","smy_file",l_slip,"","apm-274","","",1) 
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF 
      RETURN
   END IF
   IF l_smy57='Y' THEN
      LET la_rvu.rvu01=l_smy51,l_rvu.rvu01[g_no_sp-1,g_no_ep] 
      LET l_cnt = 0  
      SELECT COUNT(*) INTO l_cnt FROM rvu_file WHERE rvu01=la_rvu.rvu01
      IF l_cnt > 0 OR
         MONTH(l_rvu.rvu03) <> MONTH(g_today)   #收貨月份不等於入庫月份時
         THEN
         LET l_msg=l_smy51
         CALL s_auto_assign_no("apm",l_msg,g_today,p_chr,"rvu_file","rvu01","","","")
              RETURNING li_result,la_rvu.rvu01
         IF (NOT li_result) THEN
            IF NOT p_inTransaction THEN ROLLBACK WORK END IF
            LET g_success ='N'
            RETURN
         END IF
       END IF
   ELSE
       LET l_msg=l_smy51
       CALL s_auto_assign_no("apm",l_msg,g_today,p_chr,"rvu_file","rvu01","","","")
            RETURNING li_result,la_rvu.rvu01
       IF (NOT li_result) THEN
          IF NOT p_inTransaction THEN ROLLBACK WORK END IF
          LET g_success ='N'
          RETURN
       END IF
   END IF

       IF la_rvu.rvu21 IS NULL THEN LET la_rvu.rvu21 = ' ' END IF 
       IF la_rvu.rvu900 IS NULL THEN LET la_rvu.rvu900 = ' ' END IF
       IF la_rvu.rvupos IS NULL THEN LET la_rvu.rvupos = 'N' END IF
       IF la_rvu.rvumksg IS NULL THEN LET la_rvu.rvumksg = 'N' END IF

      #FUN-A60009 add str -------
       SELECT smyapr INTO l_smyapr
         FROM smy_file
        WHERE smyslip = l_smy51       #驗退單單別

       LET la_rvu.rvumksg=l_smyapr    #是否簽核
       LET la_rvu.rvu17='0'           #簽核狀況
      #FUN-A60009 add end -------

       LET la_rvu.rvuconf='N'         #確認碼
       LET la_rvu.rvuuser=g_user
       LET la_rvu.rvudate=g_today
       LET la_rvu.rvuplant=g_plant
       LET la_rvu.rvulegal=g_legal
       LET la_rvu.rvuoriu = g_user
       LET la_rvu.rvuorig = g_grup
       LET la_rvu.rvu27 = '1'  #TQC-B60065
       INSERT INTO rvu_file VALUES (la_rvu.*)
       IF STATUS THEN
          CALL cl_err3("ins","rvu_file",la_rvu.rvu01,"",SQLCA.sqlcode,"","ins rvu:",1) 
          IF NOT p_inTransaction THEN ROLLBACK WORK END IF
          RETURN
       END IF
       #----單身

       LET l_ins_rvv_ok = 'N' #MOD-530023
       LET l_sql="SELECT * FROM rvv_file ",
                 " WHERE rvv01='",l_rvu.rvu01,"' AND rvv17>=0"
       IF s_industry('icd') THEN
          LET l_sql="SELECT * FROM rvv_file,rvvi_file ",
                    " WHERE rvv01='",l_rvu.rvu01,"' AND rvv17>=0 ",
                    "   AND rvvi01=rvv01 ",
                    "   AND rvvi02=rvv02 ",
                    #委外tky非最終站之收貨項次不可產生至驗退單
                    "   AND (rvviicd07 = 'N' OR rvviicd07 IS NULL ",
                   "          OR rvviicd07 = ' ')"
       END IF
       DECLARE t110_y1 CURSOR WITH HOLD FROM l_sql          
       FOREACH t110_y1 INTO lb_rvv.*,lb_rvvi.*
          LET la_rvv.*    =lb_rvv.*
          LET la_rvv.rvv01=la_rvu.rvu01     #單號
          #判斷此收貨單號+項次是否已產生過驗退資料,若有產生過,不管數量為何就不再
          SELECT SUM(rvv17) INTO l_rvv17 FROM rvv_file,rvu_file   #防止重覆過帳
           WHERE rvv04=la_rvv.rvv04 #收貨單號
             AND rvv05=la_rvv.rvv05 #收貨項次
             AND rvu00='2'         #驗退
             AND rvuconf <> 'X'
             AND rvu01 = rvv01
           IF l_rvv17>0 THEN
              CALL cl_err(la_rvv.rvv05,'apm-111',1)    
              CONTINUE FOREACH
           END IF

          SELECT rvb07-rvb30 INTO la_rvv.rvv17 FROM rvb_file
           WHERE rvb01=lb_rvv.rvv04 AND rvb02=lb_rvv.rvv05

          IF la_rvv.rvv17<=0 THEN CONTINUE FOREACH END IF
          LET l_ima906 = NULL
          SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=lb_rvv.rvv31
          IF g_sma.sma116 MATCHES '[02]' THEN  
             LET la_rvv.rvv86=la_rvv.rvv35
             LET la_rvv.rvv87=la_rvv.rvv17
          END IF

          SELECT SUM(rvv82),SUM(rvv85) 
            INTO l_okqty_rvv82,l_okqty_rvv85 FROM rvv_file
             WHERE rvv04=lb_rvv.rvv04 AND rvv05=lb_rvv.rvv05
              AND rvv03='1'

          IF cl_null(l_okqty_rvv82) THEN LET l_okqty_rvv82=0 END IF
          IF cl_null(l_okqty_rvv85) THEN LET l_okqty_rvv85=0 END IF

          SELECT rvb82,rvb85,rvb39 
            INTO l_rvb82,l_rvb85,l_rvb39 FROM rvb_file
             WHERE rvb01=lb_rvv.rvv04 AND rvb02=lb_rvv.rvv05

          IF cl_null(l_rvb82) THEN LET l_rvb82=0 END IF
          IF cl_null(l_rvb85) THEN LET l_rvb85=0 END IF

          SELECT SUM(qcs22),SUM(qcs091),SUM(qcs32),
                 SUM(qcs35),SUM(qcs38),SUM(qcs41) 
            INTO l_qcs22,l_qcs091,l_qcs32,l_qcs35,l_qcs38,l_qcs41
             FROM qcs_file WHERE  qcs01 = lb_rvv.rvv04
             AND qcs02 = lb_rvv.rvv05
             AND qcs14 = 'Y'                  #確認否
             
          IF cl_null(l_qcs22) THEN LET l_qcs22 = 0 END IF
          IF cl_null(l_qcs091)THEN LET l_qcs091= 0 END IF
          IF cl_null(l_qcs32) THEN LET l_qcs32 = 0 END IF
          IF cl_null(l_qcs35) THEN LET l_qcs35 = 0 END IF
          IF cl_null(l_qcs38) THEN LET l_qcs38 = 0 END IF
          IF cl_null(l_qcs41) THEN LET l_qcs41 = 0 END IF

          IF l_rvb39='Y' THEN
             IF g_sma.sma886[8,8] = 'Y'  THEN 
             #若勾選允收數與IQC勾稽 , 驗退量以qcs_file為主
             #若不勾選允收數與IQC勾稽 , 驗退量以rvb_file為主
             LET la_rvv.rvv17 = l_qcs22 - l_qcs091
             IF la_rvv.rvv17<=0 THEN CONTINUE FOREACH END IF   #MOD-CA0181 add
             IF g_sma.sma115 = 'Y' AND l_ima906 = '1' THEN
                LET la_rvv.rvv82=l_qcs32-l_qcs38
             END IF
             IF g_sma.sma115 = 'Y' AND l_ima906 MATCHES '[23]' THEN
                LET la_rvv.rvv82=l_qcs32-l_qcs38
                LET la_rvv.rvv85=l_qcs35-l_qcs41
             END IF
             ELSE 
                IF g_sma.sma115 = 'Y' AND l_ima906 = '1' THEN
                   LET la_rvv.rvv82=l_rvb82-l_okqty_rvv82
                END IF
                IF g_sma.sma115 = 'Y' AND l_ima906 MATCHES '[23]' THEN
                   LET la_rvv.rvv82=l_rvb82-l_okqty_rvv82
                   LET la_rvv.rvv85=l_rvb85-l_okqty_rvv85
                END IF
             END IF  
          ELSE
             IF g_sma.sma115 = 'Y' AND l_ima906 = '1' THEN
                LET la_rvv.rvv82=l_rvb82-l_okqty_rvv82
             END IF
             IF g_sma.sma115 = 'Y' AND l_ima906 MATCHES '[23]' THEN
                LET la_rvv.rvv82=l_rvb82-l_okqty_rvv82
                LET la_rvv.rvv85=l_rvb85-l_okqty_rvv85
             END IF
          END IF
          LET la_rvv.rvv23=0               #已請款匹配數量
          LET la_rvv.rvv88=0               #No.TQC-7B0083
          LET la_rvv.rvv03='2'

          SELECT rvb36,rvb37,rvb38                                                                                                  
            INTO la_rvv.rvv32,la_rvv.rvv33,la_rvv.rvv34                                                                                
            FROM rvb_file                                                                                                          
           WHERE rvb01 = la_rvv.rvv04                                                                                               
             AND rvb02 = la_rvv.rvv05          

          #重新計算計價數量，因為此地方用的變數是la_rvv
          #所以無法直接使用t720_set_rvv87()
           LET la_rvv.rvv87 = t720sub_set_iqc_rvv87(la_rvv.*)

            #  單據單位        計價單位
          IF s_industry('icd') THEN
             IF la_rvv.rvv35 != la_rvv.rvv86 THEN
                #單位換算
                LET l_factor = 1
                CALL s_umfchk(la_rvv.rvv31,la_rvv.rvv35,la_rvv.rvv86)
                     RETURNING l_cnt,l_factor
                IF l_cnt = 1 THEN
                   LET l_factor = 1
                END IF
                LET la_rvv.rvv87 = la_rvv.rvv17 * l_factor
                LET la_rvv.rvv87 = s_digqty(la_rvv.rvv87,la_rvv.rvv86)   #No.FUN-BB0086
             ELSE
                LET la_rvv.rvv87 = la_rvv.rvv17
             END IF 
          END IF         
          #TQC-C30225 add begin
          CALL t720sub_rvv38(la_rvv.rvv36,la_rvv.rvv38,la_rvv.rvv38t,l_rvu.rvu04,l_rvu.rvu01)  #TQC-C30225 add 
               RETURNING la_rvv.rvv38,la_rvv.rvv38t
          #TQC-C30225 add end
          LET la_rvv.rvv39=la_rvv.rvv87*la_rvv.rvv38
          LET la_rvv.rvv39t=la_rvv.rvv87*la_rvv.rvv38t 
              LET t_azi04=''  
              IF p_rva00 = '1' THEN 
                 SELECT azi04 INTO t_azi04  
                   FROM pmm_file,azi_file
                  WHERE pmm22=azi01
                    AND pmm01 = lb_rvv.rvv36 AND pmm18 <> 'X'
               ELSE
                  LET t_azi04 = l_rvu.rvu113
               END IF
                IF la_rvv.rvv87 = 0 OR cl_null(t_azi04) THEN   
                   SELECT azi04 INTO t_azi04
                     FROM pmc_file,azi_file
                    WHERE pmc22=azi01
                      AND pmc01 = l_rvu.rvu04
                END IF
              IF cl_null(t_azi04) THEN LET t_azi04=0 END IF  
              CALL cl_digcut(la_rvv.rvv39,t_azi04) 
                                RETURNING la_rvv.rvv39
              CALL cl_digcut(la_rvv.rvv39t,t_azi04)  
                                RETURNING la_rvv.rvv39t 
              #CALL t720sub_rvv39(la_rvv.rvv36,la_rvv.rvv39,la_rvv.rvv39t,l_rvu.rvu04,l_rvu.rvu02) #MOD-BC0262 mark    
              CALL t720sub_rvv39(la_rvv.rvv36,la_rvv.rvv39,la_rvv.rvv39t,l_rvu.rvu04,l_rvu.rvu01)  #MOD-BC0262 add   
                   RETURNING la_rvv.rvv39,la_rvv.rvv39t
          IF cl_null(la_rvv.rvv32) THEN LET la_rvv.rvv32=' ' END IF
          IF cl_null(la_rvv.rvv33) THEN LET la_rvv.rvv33=' ' END IF
          IF cl_null(la_rvv.rvv34) THEN LET la_rvv.rvv34=' ' END IF
          LET la_rvv.rvv40 = 'N'   #no.5748(default非沖暫估)

          IF cl_null(la_rvv.rvv02) THEN LET la_rvv.rvv02 = 1 END IF
          LET la_rvv.rvv88 = 0  
          IF s_industry('icd') THEN
             #取得倉庫批資訊
             SELECT rvb36,rvb37,rvb38 
               INTO la_rvv.rvv32,la_rvv.rvv33,la_rvv.rvv34
               FROM rvb_file
              WHERE rvb01 = la_rvv.rvv04
                AND rvb02 = la_rvv.rvv05
            IF la_rvv.rvv33 IS NULL THEN LET la_rvv.rvv33 = ' ' END IF
            IF la_rvv.rvv34 IS NULL THEN LET la_rvv.rvv34 = ' ' END IF

            INITIALIZE la_rvvi.* TO NULL
                  #作業編號,datecode , 母體料號, 產品型號,
            SELECT rvbiicd03,rvbiicd08,rvbiicd14,rvbiicd15,
                  #母批    ,Tap Reel
                   rvbiicd16,rvbiicd11,rvbiicd13
              INTO la_rvvi.rvviicd01,la_rvvi.rvviicd02,la_rvvi.rvviicd03,
                   la_rvvi.rvviicd04,la_rvvi.rvviicd05,la_rvvi.rvviicd06,
                   la_rvvi.rvviicd07
            FROM rvbi_file
           WHERE rvbi01 = la_rvv.rvv04 
             AND rvbi02 = la_rvv.rvv05

            IF NOT t720sub_ind_icd_chk_icdin_yn(la_rvv.*,la_rvvi.*,
                                            la_rvu.rvu00,la_rvu.rvu08,
                                            l_rvu.rvu02,p_argv1,p_argv3) THEN
               IF NOT p_inTransaction THEN ROLLBACK WORK END IF
               LET g_success = 'N'
               RETURN
            END IF
            #將來源單據(收貨項次)的刻號明細資料複製至本入庫單據
            CALL t720sub_ind_icd_ins_icin(la_rvv.rvv01,la_rvv.rvv02,la_rvv.rvv04,
                                       la_rvv.rvv05,la_rvu.rvu00,la_rvu.rvu03)
          END IF
          LET la_rvv.rvvplant = g_plant  #FUN-980006 add
          LET la_rvv.rvvlegal = g_legal  #FUN-980006 add
          IF la_rvv.rvv10 IS NULL THEN LET la_rvv.rvv10 = '4' END IF 
      #流通代銷無收貨單,將發票記錄rvb22同時新增到rvv22內
      #FUN-BB0001 add START
          IF NOT cl_null(la_rvv.rvv04) AND NOT cl_null(la_rvv.rvv05) THEN
             SELECT rvb22 INTO la_rvv.rvv22 FROM rvb_file WHERE rvb01 = la_rvv.rvv04 AND rvb02 = la_rvv.rvv05
          END IF
      #FUN-BB0001 add END
          #FUN-CC0013 mark begin---
          ##FUN-BC0104---add---str---
          #IF NOT cl_null(la_rvv.rvv46) THEN
          #   DECLARE qco_cur SCROLL CURSOR FOR SELECT qco03,qco04 FROM qco_file,qcl_file 
          #                                      WHERE qco01 = la_rvv.rvv04
          #                                        AND qco02 = la_rvv.rvv05
          #                                        AND qco05 = la_rvv.rvv45
          #                                        AND qcl01 = qco03
          #                                        AND qcl05 = '3'
          #   OPEN qco_cur 
          #   FETCH FIRST qco_cur INTO l_qco03,l_qco04
          #   IF NOT SQLCA.SQLCODE THEN
          #      LET la_rvv.rvv46 = l_qco03
          #      LET la_rvv.rvv47 = l_qco04
          #   ELSE
          #FUN-CC0013 mark end-----
                LET la_rvv.rvv45 = '' 
                LET la_rvv.rvv46 = ''
                LET la_rvv.rvv47 = '' 
          #   END IF     #FUN-CC0013 mark
          #END IF        #FUN-CC0013 mark
        #FUN-CB0087---add---str---
          IF g_aza.aza115 = 'Y' THEN
             CALL s_reason_code(la_rvv.rvv01,la_rvv.rvv04,'',la_rvv.rvv31,la_rvv.rvv32,la_rvu.rvu07,la_rvu.rvu06) RETURNING la_rvv.rvv26
             IF cl_null(la_rvv.rvv26) THEN
                CALL cl_err('','aim-425',1)
                LET g_success = 'N'
                RETURN
             END IF
          END IF
        #FUN-CB0087---add---end---
          #FUN-BC0104---add---end--- 
          INSERT INTO rvv_file VALUES (la_rvv.*)
          IF STATUS THEN
             CALL cl_err3("ins","rvv_file",la_rvv.rvv01,la_rvv.rvv02,STATUS,"","ins rvv:",1) 
             IF NOT p_inTransaction THEN ROLLBACK WORK END IF 
             LET g_success = 'N'
             RETURN
          ELSE 
            #FUN-BC0104--begin--add---
            IF NOT cl_null(la_rvv.rvv46) THEN
               IF NOT s_iqctype_upd_qco20(la_rvv.rvv04,la_rvv.rvv05,la_rvv.rvv45,la_rvv.rvv47,'1') THEN
                  IF NOT p_inTransaction THEN ROLLBACK WORK END IF
                  LET g_success = 'N'
                  RETURN
               END IF
            END IF
            #FUN-BC0104---add---end--- 
            IF NOT s_industry('std') THEN
               LET lb_rvvi.rvvi01 = la_rvv.rvv01
               LET lb_rvvi.rvvi02 = la_rvv.rvv02
               IF NOT s_ins_rvvi(lb_rvvi.*,'') THEN
                  IF NOT p_inTransaction THEN ROLLBACK WORK END IF
                  LET g_success = 'N'
                  RETURN
                END IF
            END IF
            LET l_ins_rvv_ok = 'Y'  

             SELECT ima918,ima921 INTO l_ima918,l_ima921 
               FROM ima_file
              WHERE ima01 = la_rvv.rvv31
                AND imaacti = "Y"
             
             IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
                IF g_sma.sma90 = "Y" THEN #MOD-C30074 add
                   CALL t720sub_ins_rvbs('apmt721',la_rvv.rvv01,la_rvv.rvv02,
                                      la_rvv.rvv04,la_rvv.rvv05,la_rvv.rvv31,
                                      la_rvv.rvv32,la_rvv.rvv33,la_rvv.rvv34,l_rvu.rvu02)
                END IF #MOD-C30074 add
             END IF
          END IF
       END FOREACH
       IF l_ins_rvv_ok = 'Y' THEN
          IF NOT p_inTransaction THEN COMMIT WORK   END IF
       ELSE
          IF NOT p_inTransaction THEN ROLLBACK WORK END IF
          RETURN
       END IF

    LET l_cmd=''
    IF s_industry('icd') THEN
       CASE g_prog
         WHEN "apmt720_icd"
          #LET l_cmd = "apmt721_icd ","'",l_rvu.rvu02 CLIPPED,"' '' '2'"             #FUN-A60009 mark
           LET l_cmd = "apmt721_icd ","'' '' '",l_rvu.rvu02 CLIPPED,"' '2'"          #FUN-A60009 add
         WHEN "apmt730_icd"
          #LET l_cmd = "apmt731_icd ","'",l_rvu.rvu02 CLIPPED,"' '' '2' 'SUB'"       #FUN-A60009 mark
           LET l_cmd = "apmt731_icd ","'' '' '",l_rvu.rvu02 CLIPPED,"' '2' 'SUB'"    #FUN-A60009 add
         WHEN "apmt740_icd"
          #LET l_cmd = "apmt741_icd ","'",l_rvu.rvu02 CLIPPED,"' '' '2'"             #FUN-A60009 mark
           LET l_cmd = "apmt741_icd ","'' '' '",l_rvu.rvu02 CLIPPED,"' '2'"          #FUN-A60009 add
         WHEN "aict042"
          #LET l_cmd = "aict043 ","'",l_rvu.rvu02 CLIPPED,"' '' '2'"                 #FUN-A60009 mark
           LET l_cmd = "aict043 ","'' '' '",l_rvu.rvu02 CLIPPED,"' '2'"              #FUN-A60009 add
       END CASE
    ELSE
       CASE g_prog
         WHEN "apmt720"
          #LET l_cmd = "apmt721 ","'",l_rvu.rvu02 CLIPPED,"' '' '2'"                 #FUN-A60009 mark
           LET l_cmd = "apmt721 ","'' '' '",l_rvu.rvu02 CLIPPED,"' '2'"              #FUN-A60009 add
         WHEN "apmt730"
          #LET l_cmd = "apmt731 ","'",l_rvu.rvu02 CLIPPED,"' '' '2' 'SUB'"           #FUN-A60009 mark
           LET l_cmd = "apmt731 ","'' '' '",l_rvu.rvu02 CLIPPED,"' '2' 'SUB'"        #FUN-A60009 add
         WHEN "apmt740"
          #LET l_cmd = "apmt741 ","'",l_rvu.rvu02 CLIPPED,"' '' '2'"                 #FUN-A60009 mark
           LET l_cmd = "apmt741 ","'' '' '",l_rvu.rvu02 CLIPPED,"' '2'"              #FUN-A60009 add
       END CASE
    END IF
    IF (l_cmd IS NOT NULL) AND ( p_ask_post='Y') THEN
       CALL cl_cmdrun_wait(l_cmd) 
    END IF

END FUNCTION

FUNCTION t720sub_set_iqc_rvv87(p_rvv)
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima25  LIKE ima_file.ima25,     #ima單位 #FUN-A10130
            l_ima44  LIKE ima_file.ima44,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_img09  LIKE img_file.img09,
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_tot    LIKE img_file.img10,     #計價數量
            l_factor LIKE ima_file.ima31_fac
DEFINE      p_rvv    RECORD LIKE rvv_file.*
DEFINE      l_cnt    LIKE type_file.num10

    SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906  
      FROM ima_file WHERE ima01=p_rvv.rvv31
    IF SQLCA.sqlcode = 100 THEN
       IF p_rvv.rvv31 MATCHES 'MISC*' THEN
          SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906  
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44=l_ima25 END IF  

    LET l_fac2=p_rvv.rvv84
    LET l_qty2=p_rvv.rvv85
    IF g_sma.sma115 = 'Y' THEN
       LET l_fac1=p_rvv.rvv81
       LET l_qty1=p_rvv.rvv82
    ELSE
       LET l_fac1=1
       LET l_qty1=p_rvv.rvv17
       CALL s_umfchk(p_rvv.rvv31,p_rvv.rvv35,l_ima44)
             RETURNING l_cnt,l_fac1
       IF l_cnt = 1 THEN
          LET l_fac1 = 1
       END IF
    END IF
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF

    SELECT img09 INTO l_img09 FROM img_file
     WHERE img01=p_rvv.rvv31
       AND img02=p_rvv.rvv32
       AND img03=p_rvv.rvv33
       AND img04=p_rvv.rvv34
    IF l_img09 IS NULL THEN LET l_img09=l_ima44 END IF

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
    CALL s_umfchk(p_rvv.rvv31,l_ima44,p_rvv.rvv86)
          RETURNING l_cnt,l_factor
    IF l_cnt = 1 THEN
       LET l_factor = 1
    END IF
    LET l_tot = l_tot * l_factor

    LET p_rvv.rvv87 = l_tot
    LET p_rvv.rvv87 = s_digqty(p_rvv.rvv87,p_rvv.rvv86) #FUN-BB0086  add
    RETURN p_rvv.rvv87
END FUNCTION

FUNCTION t720sub_ind_icd_chk_icdin_yn(l_rvv,l_rvvi,p_rvu00,p_rvu08,p_rvu02,p_argv1,p_argv3)
   DEFINE p_rvu00        LIKE rvu_file.rvu00,
          p_rvu08        LIKE rvu_file.rvu08,
          l_idd13        LIKE idd_file.idd13,
          l_idd07        LIKE idd_file.idd07,
          l_imaicd04     LIKE imaicd_file.imaicd04,   #FUN-BA0051 mark  #TQC-C50062 remark
          l_imaicd08     LIKE imaicd_file.imaicd08,
          l_imaicd09     LIKE imaicd_file.imaicd09,    #FUN-BA0051
          l_rvv17        LIKE rvv_file.rvv17,
          l_fac          LIKE rvv_file.rvv35
   DEFINE l_rvv          RECORD LIKE rvv_file.*
   DEFINE l_rvvi         RECORD LIKE rvvi_file.*  
   DEFINE l_i            LIKE type_file.num5
   DEFINE l_msg          LIKE ze_file.ze03 
   DEFINE p_rvu02        LIKE rvu_file.rvu02
   DEFINE p_argv1        LIKE rvu_file.rvu00
   DEFINE p_argv3        LIKE rvu_file.rvu08

   IF p_argv1 NOT MATCHES '[01]' THEN RETURN TRUE END IF
   IF p_argv3='TAP' THEN RETURN TRUE END IF
   IF l_rvvi.rvviicd07 = 'Y' THEN RETURN TRUE END IF

   LET l_imaicd04 = NULL   #FUN-BA0051 mark   #TQC-C50062 remark
   LET l_imaicd08 = NULL
   LET l_imaicd09 = NULL    #FUN-BA0051   
  #SELECT imaicd08,imaicd09 INTO l_imaicd08,l_imaicd09   #FUN-BA0051 mark imaicd04 add 09  #TQC-C50062 mark
   SELECT imaicd04,imaicd08,imaicd09 INTO l_imaicd04,l_imaicd08,l_imaicd09                 #TQC-C50062
      FROM imaicd_file,rvb_file
     WHERE rvb05 = imaicd00             #料件編號
       AND rvb01 = p_rvu02          #收貨單號
       AND rvb02 = l_rvv.rvv05          #收貨項次

   #IF l_imaicd04 MATCHES '[0124]' AND l_imaicd08 = 'Y' THEN   #FUN-BA0051 mark
    IF l_imaicd08= 'Y'  OR l_imaicd09 = 'Y' THEN   #FUN-BA0051

      IF p_rvu00 = '1' THEN LET p_rvu00 = 'Y' END IF  #入庫
      IF p_rvu00 = '2' THEN LET p_rvu00 = 'N' END IF  #驗退
      #若為產生入庫資料,則取得該收貨單刻號明細入庫否='Y'的總異動數量
      #若為產生驗退資料,則取得該收貨單刻號明細入庫否='N'的總異動數量

      LET l_idd13 = 0
      LET l_idd07 = NULL
     #str TQC-C50062 add
      IF l_imaicd04 = '2' THEN   #CP
        #SELECT SUM(idd13),idd07 INTO l_idd13,l_idd07              #TQC-C50056 mark
         SELECT SUM(idd13)+SUM(idd26),idd07 INTO l_idd13,l_idd07   #TQC-C50056
           FROM idd_file 
          WHERE idd10 = p_rvu02
            AND idd11 = l_rvv.rvv05
            AND idd24 = p_rvu00        #入庫否
          GROUP BY idd07 
      ELSE
     #end TQC-C50062 add
         SELECT SUM(idd13),idd07 INTO l_idd13,l_idd07
            FROM idd_file
           WHERE idd10 = p_rvu02
             AND idd11 = l_rvv.rvv05
             AND idd24 = p_rvu00        #入庫否
           GROUP BY idd07
      END IF   #TQC-C50062 add
      IF cl_null(l_idd13) THEN LET l_idd13 = 0 END IF
   
      LET l_fac = 0
      IF l_rvv.rvv35 != l_idd07 THEN
         CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv35,l_idd07)
              RETURNING l_i,l_fac
         IF l_i = 1 THEN
            ### ------單位無法轉換--------####
            CALL cl_err('rvv35/idd070: ','abm-731',1)
            RETURN FALSE
         END IF
      END IF
      IF cl_null(l_fac) OR l_fac = 0 THEN LET l_fac = 1 END IF

      LET l_rvv17 = l_rvv.rvv17 * l_fac
      LET l_rvv17 = s_digqty(l_rvv17,l_rvv.rvv35)   #No.FUN-BB0086

      #判斷
      #若是產生入庫資料,則入庫異動數量必須小於等於,
      #    該收貨單刻號明細入庫否='Y'的總異動數量
      #若是產生驗退資料,則驗退異動數量必須小於等於,
      #    該收貨單刻號明細入庫否='N'的總異動數量
      IF l_rvv17 > l_idd13 THEN
         LET l_msg = "[Rec No.",l_rvv.rvv04,"  Line:",
                     l_rvv.rvv05 USING '<<<<<',"]"
         IF p_rvu00 = 'Y' THEN
            CALL cl_err(l_msg CLIPPED,'aic-118',1)
         END IF
         IF p_rvu00 = 'N' THEN
            CALL cl_err(l_msg CLIPPED,'aic-119',1)
         END IF         
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t720sub_ind_icd_ins_icin(p_rvv01,p_rvv02,p_rvv04,p_rvv05,p_rvu00,p_rvu03)
   DEFINE p_rvv01       LIKE rvv_file.rvv01
   DEFINE p_rvv02       LIKE rvv_file.rvv02
   DEFINE p_rvv04       LIKE rvv_file.rvv04
   DEFINE p_rvv05       LIKE rvv_file.rvv05
   DEFINE l_ida         RECORD LIKE ida_file.*
   DEFINE l_idd         RECORD LIKE idd_file.*
   DEFINE p_rvu00       LIKE type_file.chr1     #Y:入庫 N:驗退
   DEFINE p_rvu03       LIKE rvu_file.rvu03   #單據日期   

   IF p_rvu00 = '1' THEN LET p_rvu00 = 'Y' END IF
   IF p_rvu00 = '2' THEN LET p_rvu00 = 'N' END IF
   DECLARE t720_ins_icin_cs CURSOR FOR
     SELECT * INTO l_idd.* FROM idd_file
       WHERE idd10 = p_rvv04
         AND idd11 = p_rvv05
         AND idd12 = 0
         AND idd24 = p_rvu00  #入庫否 
         AND idd12 = 0        #收貨  

   FOREACH t720_ins_icin_cs INTO l_idd.*
      INITIALIZE l_ida.* TO NULL
      LET l_ida.ida01 = l_idd.idd01    #料號
      LET l_ida.ida02 = l_idd.idd02    #倉庫
      LET l_ida.ida03 = l_idd.idd03    #儲位
      LET l_ida.ida04 = l_idd.idd04    #批號
      LET l_ida.ida05 = l_idd.idd05    #刻號
      LET l_ida.ida06 = l_idd.idd06    #BIN
      LET l_ida.ida07 = p_rvv01        #單據編號
      LET l_ida.ida08 = p_rvv02        #單據項次
      LET l_ida.ida09 = p_rvu03        #異動日期
      LET l_ida.ida10 = l_idd.idd13    #實收數量
      LET l_ida.ida11 = l_idd.idd26    #不良數量
      LET l_ida.ida12 = l_idd.idd27    #報廢數量
      LET l_ida.ida13 = l_idd.idd07    #單位
      LET l_ida.ida14 = l_idd.idd15    #母體料號
      LET l_ida.ida15 = l_idd.idd16    #母批
      LET l_ida.ida16 = l_idd.idd17    #DATECODE
      LET l_ida.ida17 = l_idd.idd18    #DIES 數
      LET l_ida.ida18 = l_idd.idd19    #YIELD
      LET l_ida.ida19 = l_idd.idd20    #TEST #
      LET l_ida.ida20 = l_idd.idd21    #DEDUCT
      LET l_ida.ida21 = l_idd.idd22    #PASSBIN
      LET l_ida.ida22 = l_idd.idd23    #接單料號
      LET l_ida.ida27 = 'N'                   #轉入否
      IF p_rvu00 = 'Y' THEN LET l_ida.ida28 = 1 END IF  #入出庫別
      IF p_rvu00 = 'N' THEN LET l_ida.ida28 = 0 END IF
      LET l_ida.ida29 = l_idd.idd25   #備註
      LET l_ida.ida30 = p_rvv04
      LET l_ida.ida31 = p_rvv05
      LET l_ida.idaplant = g_plant
      LET l_ida.idalegal = g_legal
      INSERT INTO ida_file VALUES(l_ida.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('ins ida_file for rvv',SQLCA.sqlcode,1)
         LET g_success='N'
         RETURN
      END IF
  END FOREACH
END FUNCTION

FUNCTION t720sub_rvu04(p_rvu04,p_rvuplant)
DEFINE l_pmc903    LIKE pmc_file.pmc903
DEFINE l_pmc05     LIKE pmc_file.pmc05
DEFINE l_dbs       LIKE azp_file.azp03
DEFINE l_n         LIKE type_file.num5
DEFINE l_sql       STRING
DEFINE p_rvu04     LIKE rvu_file.rvu04
DEFINE p_rvuplant  LIKE rvu_file.rvuplant
   
   LET g_errno = ''
   CALL t720sub_azp(p_rvu04) RETURNING l_dbs 
   IF cl_null(g_errno) THEN
     #LET l_sql = "SELECT pmc05,pmc903 FROM ",l_dbs,".pmc_file",                            #FUN-A50102 mark
      LET l_sql = "SELECT pmc05,pmc903 FROM ",cl_get_target_table(p_rvu04,'pmc_file'),      #FUN-A50102 
                  " WHERE pmc01 = '",p_rvu04,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql                 #FUN-A50102
      CALL cl_parse_qry_sql(l_sql,p_rvu04) RETURNING l_sql         #FUN-A50102 
      PREPARE pmc_cs FROM l_sql
      EXECUTE pmc_cs INTO l_pmc05,l_pmc903
      CASE
        WHEN SQLCA.sqlcode = 100 LET g_errno = 'apm-197'
        WHEN l_pmc05 <> '1'      LET g_errno = 'aap-032'
        WHEN l_pmc903 <> 'Y'     LET g_errno = 'apm-967'
      END CASE 
   END IF
   IF cl_null(g_errno) THEN
      SELECT COUNT(*) INTO l_n FROM azw_file
       WHERE azw01 = p_rvuplant
         AND azw06 = p_rvu04
      IF l_n = 0 THEN
         LET g_errno = 'art-499'
      END IF
   END IF
END FUNCTION

FUNCTION t720sub_azp(l_azp01)
   DEFINE l_azp01  LIKE azp_file.azp01,
          l_azp03  LIKE azp_file.azp03
 
    LET g_errno=' '
    SELECT azp03 INTO l_azp03 FROM azp_file 
     WHERE azp01=l_azp01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-025'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    RETURN l_azp03 CLIPPED
END FUNCTION

#可串 報工單 asft700
FUNCTION t720sub_ecm(p_rvu01)
DEFINE p_rvu01 LIKE rvu_file.rvu01
DEFINE l_cnt   LIKE type_file.num5  
DEFINE l_rvv02 LIKE rvv_file.rvv02
DEFINE l_pmn18 LIKE pmn_file.pmn18 
DEFINE l_pmn46 LIKE pmn_file.pmn46,
       l_ecm01 LIKE ecm_file.ecm01,
       l_ecm53 LIKE ecm_file.ecm53
DEFINE p_row,p_col  LIKE type_file.num5
DEFINE l_cmd        LIKE type_file.chr1000
 
   SELECT COUNT(*) INTO l_cnt FROM rvv_file
    WHERE rvv01= p_rvu01
   IF l_cnt > 1 THEN
      IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
         LET p_row = 5  LET p_col = 22
      ELSE
         LET p_row = 11 LET p_col = 22
      END IF
 
      OPEN WINDOW t720_k_w AT p_row,p_col
                  WITH 1 ROWS, 29 COLUMNS
      CASE g_lang
        WHEN '0'
            LET INT_FLAG = 0  ######add for prompt bug
          PROMPT "請輸入查詢項次:" FOR l_rvv02
           ON IDLE g_idle_seconds
             CALL cl_on_idle()
 
           ON ACTION about         
              CALL cl_about()     
 
           ON ACTION help          
              CALL cl_show_help() 
 
           ON ACTION controlg      
              CALL cl_cmdask()     
 
           END PROMPT
        WHEN '2'
            LET INT_FLAG = 0  ######add for prompt bug
          PROMPT "請輸入查詢項次:" FOR l_rvv02
           ON IDLE g_idle_seconds
             CALL cl_on_idle()
 
           ON ACTION about         
              CALL cl_about()     
 
           ON ACTION help          
              CALL cl_show_help() 
 
           ON ACTION controlg      
              CALL cl_cmdask()     
 
           END PROMPT
        OTHERWISE
            LET INT_FLAG = 0  ######add for prompt bug
          PROMPT "Enter Qry Line #:" FOR l_rvv02
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      #若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，需控卡不可直接確認or過帳
   ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
          END PROMPT
      END CASE
      CLOSE WINDOW t720_k_w
      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   ELSE
      LET l_rvv02 = 1
   END IF
   SELECT UNIQUE pmn18
     INTO l_pmn18
     FROM pmn_file
    WHERE pmn01 IN (SELECT rvv36 FROM rvv_file
                     WHERE rvv01 = p_rvu01)
   #判斷是否有PQC
    SELECT ecm53,ecm01,pmn46
      INTO l_ecm53,l_ecm01,l_pmn46
      FROM ecm_file,rvv_file,pmn_file
     WHERE ecm01=rvv18 AND ecm03=pmn46
       AND rvv01=p_rvu01 
       AND rvv02=l_rvv02
       AND pmn01=rvv36
       AND pmn02=rvv37
       AND ecm012=pmn012                 #FUN-A60076 add 
       
   IF l_ecm53='Y' THEN 
      LET l_cnt = 0
      SELECT SUM(qcm091) INTO l_cnt FROM qcm_file
       WHERE qcm02=l_ecm01   #工單編號
         AND qcm05=l_pmn46   #製程序號
         AND qcm14='Y'  #確認
         AND (qcm09='1' OR qcm09='3')  #判定結果(1.Accept  3.特採) #No:7842,8454
      IF l_cnt = 0 THEN 
         CALL cl_err('','aqc-440',0) 
         RETURN
      END IF  
   END IF 
   IF NOT cl_null(l_pmn18) THEN #若pmn18不是NULL的話就是RunCard委外
       LET l_cmd = "asft730 '",p_rvu01,"' '' '",l_rvv02,"'" clipped 
   ELSE
       LET l_cmd = "asft700 '' '' '",p_rvu01,"' '",l_rvv02,"'" clipped
   END IF
   CALL cl_cmdrun_wait(l_cmd) 
END FUNCTION

#No.FUN-A80026  --Begin
#产生应付帐款
FUNCTION t720_gen_ap(p_rvu01)          
   DEFINE p_rvu01         LIKE rvu_file.rvu01
   DEFINE l_rvu           RECORD LIKE rvu_file.*
   DEFINE l_smyslip       LIKE smy_file.smyslip
   DEFINE l_type          LIKE type_file.chr1    #0.UNAP  1.AP  2.UNAP/AP
   DEFINE l_cnt1          LIKE type_file.num5    #立过发票的发票unique数量
   DEFINE l_cnt2          LIKE type_file.num5    #无立过发票的项次数量
   DEFINE l_rvw01         LIKE rvw_file.rvw01
   DEFINE li_result       LIKE type_file.num5
   DEFINE l_wc            STRING
   DEFINE l_wc1           STRING
   DEFINE l_wc2           STRING     #TQC-AC0287
   DEFINE l_msg           STRING
   DEFINE tm              RECORD
                          a    LIKE apy_file.apyslip,
                          d    LIKE apy_file.apyslip,
                          b    LIKE apr_file.apr01,
                          c    LIKE gec_file.gec01
                          END RECORD
   DEFINE l_pmm12         LIKE pmm_file.pmm12   #TQC-AC0287
   DEFINE l_rva02         LIKE rva_file.rva02   #TQC-AC0287
#  DEFINE l_sma91         LIKE sma_file.sma91   #FUN-B30161   #TQC-B60252
#  DEFINE l_sma92         LIKE sma_file.sma92   #FUN-B30161   #TQC-B60252
   DEFINE l_purchas_sw    LIKE type_file.chr1   #MOD-D40099 add

   IF p_rvu01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO l_rvu.* FROM rvu_file
    WHERE rvu01=p_rvu01
   IF SQLCA.sqlcode THEN 
      CALL cl_err3('sel','rvu_file',p_rvu01,'',SQLCA.sqlcode,'','',1) 
      RETURN
   END IF

   #MOD-D40099 add begin---
   IF l_rvu.rvu08 <> 'SUB' THEN
      LET l_purchas_sw = '1'
   ELSE
      LET l_purchas_sw = '2'
   END IF
   #MOD-D40099 add ene-----

   IF l_rvu.rvuacti = 'N' THEN CALL cl_err('',9028,0) RETURN END IF
   IF l_rvu.rvuconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   IF l_rvu.rvuconf = 'N' THEN CALL cl_err('','mfg3550',0) RETURN END IF

   #仅采购入库才可运行此功能,请检查rvu00的值!
   IF l_rvu.rvu00 <> '1' THEN CALL cl_err(l_rvu.rvu00,'apm-150',0) RETURN END IF
   #多角贸易单据不可运行此功能!
   IF l_rvu.rvu20 <> 'N' THEN CALL cl_err(l_rvu.rvu20,'apm-151',0) RETURN END IF                       

   #检查入库单是否还有量可转AP/UNAP
   SELECT COUNT(*) INTO l_cnt1 FROM apa_file,apb_file
    WHERE apa01 = apb01
      AND apa42 <> 'Y'   #作废
      AND apb21 = l_rvu.rvu01
   IF cl_null(l_cnt1) THEN LET l_cnt1 = 0 END IF
   IF l_cnt1 > 0 THEN
      CALL cl_err(l_rvu.rvu01,'apm-152',0)
      RETURN
   END IF 

  #LET l_smyslip = s_get_doc_no(l_rvu.rvu01)

  #SELECT * INTO g_smy.* FROM smy_file WHERE smyslip = l_smyslip
  #IF SQLCA.sqlcode THEN
  #   CALL cl_err3('sel','smy_file',l_smyslip,'',SQLCA.sqlcode,'','sel smy',1)
  #   RETURN
  #END IF

  #IF cl_null(g_smy.smy74) THEN LET g_smy.smy74 = 'N' END IF
  #IF g_smy.smy74 <> 'Y' THEN 
  #   #参数未设置"自动生成应付帐款",本功能不可使用!
  #   CALL cl_err(g_smy.smy74,'asm-150',0)
  #   RETURN 
  #END IF

   #入库单身中有立发票的收货发票数
   SELECT COUNT(UNIQUE rvb22) INTO l_cnt1 FROM rvb_file
    WHERE rvb01 = l_rvu.rvu02
      AND rvb02 IN (SELECT rvv05 FROM rvv_file WHERE rvv01 = l_rvu.rvu01)
      AND rvb22 IS NOT NULL

   #入库单身中没有立发票的收货项次数
   SELECT COUNT(*) INTO l_cnt2 FROM rvb_file
    WHERE rvb01 = l_rvu.rvu02
      AND rvb02 IN (SELECT rvv05 FROM rvv_file WHERE rvv01 = l_rvu.rvu01)
      AND rvb22 IS NULL

   LET l_rvw01 = NULL
   #没有立过发票
   IF l_cnt1 = 0 THEN
      LET l_type = '0' 
   ELSE
      #入库单中所有项次都有发票
      IF l_cnt2 = 0 THEN 
         LET l_type = '1'
         #仅一张发票
         IF l_cnt1 = 1 THEN
            SELECT UNIQUE rvb22 INTO l_rvw01 FROM rvb_file
             WHERE rvb01 = l_rvu.rvu02
               AND rvb02 IN (SELECT rvv05 FROM rvv_file WHERE rvv01 = l_rvu.rvu01)
               AND rvb22 IS NOT NULL
         END IF
      #入库单中部分项次有发票,部分项次没有发票
      ELSE
        LET l_type = '2' #部分AP,部分UNAP
      END IF
   END IF
#MOD-B80272 -- begin --
#  IF l_type= '0' AND g_sma.sma92= 'N' THEN   # MOD-TQC-B60252
#  RETURN                                     # MOD-TQC-B60252
#  END IF                                     # MOD-TQC-B60252
   IF g_action_choice="confirm" THEN
      IF l_type='1' AND g_sma.sma91='N' THEN RETURN END IF
      IF l_type='0' AND g_sma.sma92='N' THEN RETURN END IF
   END IF
#MOD-B80272 -- end --

   OPEN WINDOW t720_ap_w AT 5,10 WITH FORM "apm/42f/apmt720_ap"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("apmt720_ap")
   IF l_type = '0' THEN   #UNAP
      CALL cl_set_comp_visible('a',FALSE)
   END IF
   IF l_type = '1' THEN   #AP
      CALL cl_set_comp_visible('d,c,gec04,dummy01,dummy02',FALSE)
   END IF
 
   INPUT BY NAME tm.a,tm.d,tm.b,tm.c WITHOUT DEFAULTS
      AFTER FIELD a
         IF NOT cl_null(tm.a) THEN
            CALL s_check_no('aap',tm.a,"",'11',"","","")     
              RETURNING li_result,tm.a
            IF (NOT li_result) THEN
                NEXT FIELD a
            END IF
         END IF

      AFTER FIELD d
         IF NOT cl_null(tm.d) THEN
            CALL s_check_no('aap',tm.d,"",'16',"","","")
              RETURNING li_result,tm.d
            IF (NOT li_result) THEN
                NEXT FIELD d
            END IF
         END IF

      AFTER FIELD b
         IF NOT cl_null(tm.b) THEN
            CALL t720_apr01(tm.b)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.b,g_errno,0)
               NEXT FIELD b
            END IF
         END IF

      AFTER FIELD c
         IF NOT cl_null(tm.c) THEN
            CALL t720_gec01(tm.c)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.c,g_errno,0)
               NEXT FIELD c
            END IF
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(a)
               CALL q_apy(0,0,tm.a,'11','AAP') RETURNING tm.a    
               DISPLAY BY NAME tm.a
            WHEN INFIELD(d)
               CALL q_apy(0,0,tm.d,'16','AAP') RETURNING tm.d
               DISPLAY BY NAME tm.d
            WHEN INFIELD(b)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_apr"
               LET g_qryparam.default1 = tm.b
               CALL cl_create_qry() RETURNING tm.b
               DISPLAY BY NAME tm.b
            WHEN INFIELD(c)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gec7"
               LET g_qryparam.default1 = tm.c
               LET g_qryparam.arg1 = "1"
               CALL cl_create_qry() RETURNING tm.c
               DISPLAY BY NAME tm.c
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
      CLOSE WINDOW t720_ap_w
      RETURN
   END IF
 
   CLOSE WINDOW t720_ap_w

   #进货AP/既有AP又有UNAP

#   SELECT sma91,sma92 INTO l_sma91,l_sma92 FROM sma_file    #TQC-B60252
#      IF SQLCA.sqlcode THEN                                 #TQC-B60252        
#         LET l_sma91= 'N'                                   #TQC-B60252   
#         LET l_sma92= 'N'                                   #TQC-B60252
#      END IF
   #TQC-B60252
#   IF g_sma.sma91 ='Y' THEN    #TQC-B60252   #MOD-B80097 mark
#  IF l_type = '1' OR l_type = '2' THEN                                                             #MOD-B80272 mark
  #IF (g_action_choice = 'confirm' AND (l_type = '1' OR l_type = '2')) OR                           #MOD-B80272 #MOD-B90095 mark
  #   (g_action_choice = 'confirm' AND (l_type = '1' OR l_type = '2') AND g_sma.sma91 = 'Y') THEN   #MOD-B80272 #MOD-B90095 mark
   IF ((g_action_choice = 'confirm' OR g_action_choice = 'gen_ap' ) AND (l_type = '1' OR l_type = '2')) OR                           #MOD-B90095
      ((g_action_choice = 'confirm' OR g_action_choice = 'gen_ap' ) AND (l_type = '1' OR l_type = '2') AND g_sma.sma91 = 'Y') THEN   #MOD-B90095
      LET l_wc = " rvu01 = '",l_rvu.rvu01,"'"
      leT l_wc1= " azp01 = '",g_plant,"'"
      LET l_msg= "aapp110 ",
                 ' "',l_wc CLIPPED,'"',
                 ' "',tm.a ,'"',
                 ' "',l_rvu.rvu03 ,'"',
                 ' "',l_rvu.rvu07 ,'"',
                 ' "',l_rvu.rvu06 ,'"',
                 ' "',tm.b ,'"',
                 ' "Y" ',
                 ' "N" ',
                 ' "2" ',
                 ' "Y" ',
                 ' "',l_rvw01 ,'"',
                 ' "',l_wc1 CLIPPED,'"'
      CALL cl_cmdrun_wait(l_msg CLIPPED)
   END IF
#  END IF #TQC-B60252   #MOD-B80097 mark
#   IF g_sma.sma92 = 'Y' THEN   #TQC-B60252   #MOD-B80097 mark
   #UNAP/既有AP又有UNAP
#  IF l_type = '0' OR l_type = '2' THEN                                                             #MOD-B80272 mark
  #IF (g_action_choice = 'confirm' AND (l_type = '0' OR l_type = '2')) OR                           #MOD-B80272 #MOD-B90095 mark
  #   (g_action_choice = 'confirm' AND (l_type = '0' OR l_type = '2') AND g_sma.sma91 = 'Y') THEN   #MOD-B80272 #MOD-B90095 mark
   IF ((g_action_choice = 'confirm' OR g_action_choice = 'gen_ap' ) AND (l_type = '0' OR l_type = '2')) OR                           #MOD-B90095
      ((g_action_choice = 'confirm' OR g_action_choice = 'gen_ap' ) AND (l_type = '0' OR l_type = '2') AND g_sma.sma91 = 'Y') THEN   #MOD-B90095
     #LET l_wc = "rvu01='",l_rvu.rvu01,"'"    #TQC-AC0287
      LET l_wc = 'rvu01="',l_rvu.rvu01,'"'    #TQC-AC0287
     #LET l_wc1= "azp01='",g_plant,"'"        #TQC-AC0287
      LET l_wc1= 'azp01="',g_plant,'"'        #TQC-AC0287
         
#MOD-B30545 --Begin
#     #TQC-AC0287-----add-------str-------------
#     SELECT rva02 INTO l_rva02 FROM rva_file WHERE rva01 = l_rvu.rvu02
#     SELECT pmm12 INTO l_pmm12 FROM pmm_file WHERE pmm01 = l_rva02
#     LET l_wc2 = 'pmm12="',l_pmm12,'"'   
#     #TQC-AC0287-----add-------end------------
      LET l_wc2 = ' 1=1'
#MOD-B30545 --End
#TQC-AC0287-------mod--------------str-------------- 
#     LET l_msg= "aapp115 ",
#                ' "',l_wc CLIPPED,'"',
#                ' "',tm.d ,'"',
#                ' "',l_rvu.rvu03 ,'"',
#                ' "',l_rvu.rvu07 ,'"',
#                ' "',l_rvu.rvu06 ,'"',
#                ' "',tm.b ,'"',
#                ' "',tm.c ,'"',
#                ' "N" ',
#                ' "3" ',
#                ' "Y" ',
#                ' "',l_wc1 CLIPPED,'"',    
      LET l_msg= "aapp115 ",
                 " '",l_wc CLIPPED,"'",
                 " '",tm.d ,"'",
                 " '",l_rvu.rvu03 ,"'",
                 " '",l_rvu.rvu07 ,"'",
                 " '",l_rvu.rvu06 ,"'",
                 " '",tm.b ,"'",
                 " '",tm.c ,"'",
                 " 'N' ",
                 " '3' ",
                 " 'Y' ",
                 " '",l_wc1 CLIPPED,"'",  
                #" '",l_wc2 ,"'"                   #MOD-D40099 mark
                 " '",l_wc2 CLIPPED,"'",           #MOD-D40099 add
                 " '",l_purchas_sw,"'"             #MOD-D40099 add
                ," 'N'" #FUN-D70021 add
                ," 'N'" #FUN-D60083 add
#TQC-AC0287-------mod--------------end-------------- 
      CALL cl_cmdrun_wait(l_msg CLIPPED)
   END IF
#  END IF     #TQC-B60252   #MOD-B80097 mark
END FUNCTION

FUNCTION t720_apr01(p_apr01)
   DEFINE p_apr01     LIKE apr_file.apr01
   DEFINE l_apr02     LIKE apr_file.apr02
 
   LET g_errno = ' '
 
   SELECT apr02 INTO l_apr02 FROM apr_file
    WHERE apr01 = p_apr01
 
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'aap-044'
      WHEN SQLCA.SQLCODE != 0
         LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
 
   IF NOT cl_null(g_errno) THEN
      LET l_apr02 = ''
   END IF
 
   DISPLAY l_apr02 TO FORMONLY.apr02
 
END FUNCTION

FUNCTION t720_gec01(p_gec01)
    DEFINE p_gec01    LIKE gec_file.gec01
    DEFINE l_gec04    LIKE gec_file.gec04
    DEFINE l_gec05    LIKE gec_file.gec05
    DEFINE l_gec06    LIKE gec_file.gec06
    DEFINE l_gec08    LIKE gec_file.gec08
    DEFINE l_gec011   LIKE gec_file.gec011
    DEFINE l_gecacti  LIKE gec_file.gecacti
 
    LET g_errno = ' '
    SELECT gec04,gec05,gec06,gec08,gec011,gecacti 
      INTO l_gec04,l_gec05,l_gec06,l_gec08,l_gec011,l_gecacti
      FROM gec_file
     WHERE gec01 = p_gec01 
       AND gec011= '1'
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3044'
         WHEN l_gec011    !='1'   LET g_errno = 'axm-989'
         WHEN l_gec05   !='X' OR                        
              cl_null(l_gec05)    LET g_errno = 'aap-977' 
         WHEN l_gec06   !='2'     LET g_errno = 'aap-008'
         WHEN l_gec08   !='XX'    LET g_errno = 'aap-008'
         WHEN l_gecacti  ='N'     LET g_errno = '9028'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF NOT cl_null(g_errno) THEN
       LET l_gec04 = ''
    END IF
    
    DISPLAY l_gec04 TO FORMONLY.gec04
END FUNCTION
#No.FUN-A80026  --End  

#FUN-A60009 add str ----------------------------
FUNCTION t720sub_y_chk(p_rvu01,p_argv1,p_argv2,p_argv3,p_chr,p_ask_post)
   DEFINE l_cnt       LIKE type_file.num5 
   DEFINE l_rvv36     LIKE rvv_file.rvv36
   DEFINE l_rvv37     LIKE rvv_file.rvv37
   DEFINE l_pmn16     LIKE pmn_file.pmn16
   DEFINE l_status    LIKE type_file.chr1
   DEFINE l_rvv02     LIKE rvv_file.rvv02
   DEFINE l_rvv32     LIKE rvv_file.rvv32
   DEFINE l_rvv33     LIKE rvv_file.rvv33
   DEFINE lj_result   LIKE type_file.chr1
   DEFINE l_sma131    LIKE sma_file.sma131
   DEFINE l_pmm02     LIKE pmm_file.pmm02 
   DEFINE l_poy04     LIKE poy_file.poy04 
   DEFINE l_gen02     LIKE gen_file.gen02
   DEFINE l_rvucont   LIKE rvu_file.rvucont 
   DEFINE p_dbs_tra       LIKE azw_file.azw05 
   DEFINE p_plant_new     LIKE azp_file.azp01 
   DEFINE p_plant         LIKE azp_file.azp01 
   DEFINE l_sfb93         LIKE sfb_file.sfb93 
   DEFINE p_argv1     LIKE rvu_file.rvu00
   DEFINE p_argv2     LIKE rvu_file.rvu02
   DEFINE p_argv3     LIKE rvu_file.rvu08
   DEFINE l_rvu       RECORD LIKE rvu_file.*
   DEFINE p_rvu01     LIKE rvu_file.rvu01
   DEFINE l_yy,l_mm   LIKE type_file.num5
   DEFINE p_inTransaction LIKE type_file.num5 
   DEFINE p_ask_post  LIKE type_file.chr1
   DEFINE l_icq       LIKE type_file.chr1
   DEFINE p_chr       LIKE type_file.chr1
   DEFINE l_sql       STRING
   DEFINE l_rva00     LIKE rva_file.rva00
   DEFINE l_rvv18     LIKE rvv_file.rvv18
   DEFINE l_rvv17     LIKE rvv_file.rvv17   #MOD-A40166
   DEFINE l_rvv31     LIKE rvv_file.rvv31   #MOD-AA0164
#  DEFINE l_smy74     LIKE smy_file.smy74   #No.MOD-AC0333  #FUN-B30161 mark  #TQC-B40020 unmark
#  DEFINE l_sma91     LIKE sma_file.sma91   #FUN-B30161   #TQC-B40020   #TQC-B60252
#  DEFINE l_sma92     LIKE sma_file.sma92   #FUN-B30161   #TQC-B40020   #TQC-B60252
   DEFINE l_smyslip   LIKE smy_file.smyslip #No.MOD-AC0333
  #FUN-A60009 add str --------
   DEFINE l_flag      LIKE type_file.num5
   DEFINE l_rvv03     LIKE rvv_file.rvv03,
          l_rvv34     LIKE rvv_file.rvv34
   DEFINE l_rvviicd07 LIKE rvvi_file.rvviicd07
   #DEFINE l_imaicd08  LIKE imaicd_file.imaicd08,   #FUN-BA0051 mark
   #       l_imaicd04  LIKE imaicd_file.imaicd04    #FUN-BA0051 mark
  #FUN-A60009 add end --------
   DEFINE l_genacti   LIKE gen_file.genacti    #TQC-B60085   Add
   DEFINE l_type      LIKE type_file.num5      #MOD-B90265 add
   DEFINE l_ima159     LIKE ima_file.ima159  #MOD-C30507----add
   DEFINE l_rvu03     LIKE rvu_file.rvu03   #MOD-BC0057 add
   DEFINE l_rvv05     LIKE rvv_file.rvv05   #MOD-BC0057 add
   DEFINE l_rvvslk02  LIKE rvvslk_file.rvvslk02   #FUN-C70098
   DEFINE l_rvvslk31  LIKE rvvslk_file.rvvslk31   #FUN-C70098
   DEFINE l_rvvslk17  LIKE rvvslk_file.rvvslk17   #FUN-C70098
   DEFINE l_scan_flag LIKE type_file.chr1         #DEV-D40020 add 收貨時有無掃瞄記錄
   DEFINE l_n       LIKE type_file.num5,  #MOD-D60078 add
          l_flag2    LIKE type_file.chr1,
          l_where   STRING,
          l_azf09   LIKE azf_file.azf09,
          l_rvv26   LIKE rvv_file.rvv26

   WHENEVER ERROR CONTINUE                #忽略一切錯誤
   
   LET g_success = 'Y'                    #FUN-A60009 add
   
   #TQC-AC0277--begin--add----
   IF NOT p_inTransaction THEN
      LET g_totsuccess='Y'
      LET g_success = 'Y'
   END IF
   #TQC-AC0277--end--add-----
   SELECT sma131 INTO l_sma131 FROM sma_file WHERE sma00 = '0'
   SELECT * INTO l_rvu.* FROM rvu_file WHERE rvu01=p_rvu01
   SELECT rva00 INTO l_rva00 FROM rva_file WHERE rva01 = l_rvu.rvu02
#TQC-C80093 -- add -- begin
   IF cl_null(l_rvu.rvu01) THEN
      CALL cl_err('',-400,1)
      LET g_success = 'N' RETURN
   END IF


   IF l_rvu.rvuconf = 'Y' THEN
      CALL cl_err('','9023',1)
      LET g_success = 'N' RETURN
   END IF

   IF l_rvu.rvuconf = 'X' THEN
      CALL cl_err('','9024',1)
      LET g_success = 'N' RETURN
   END IF

   IF l_rvu.rvuacti = 'N' THEN
      CALL cl_err('','mfg0301',1)
      LET g_success = 'N'
      RETURN
   END IF

   IF g_sma.sma53 IS NOT NULL AND l_rvu.rvu03 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',1)
      LET g_success = 'N' RETURN
   END IF

   CALL s_yp(l_rvu.rvu03) RETURNING l_yy,l_mm

   IF (l_yy*12+l_mm)>(g_sma.sma51*12+g_sma.sma52)THEN #不可大於現行年月
      CALL cl_err('','mfg6091',1)
      LET g_success = 'N' RETURN #TQC-AC0277
   END IF
#TQC-C80093 -- add -- end
#CHI-C40016---add---START
   IF NOT p_argv1 MATCHES '[56]' THEN  #收貨免檢:驗收確認不再詢問
      IF p_ask_post='Y' THEN
         IF NOT cl_confirm('aap-017') THEN
            LET g_success = 'N' RETURN
         END IF
       END IF
   END IF
#CHI-C40016---add---END
#CHI-C40016---mark---START-----------------------------------------
#  #CHI-C30118---add---START
#  IF g_action_choice CLIPPED = "confirm" OR      #執行 "確認" 功能(非簽核模式呼叫)
#     g_action_choice CLIPPED = "insert"  THEN
#    IF l_rvu.rvumksg = 'Y' THEN                  #若簽核碼為 'Y' 且狀態碼不為 '1' 已同意
#       IF l_rvu.rvu17 != '1' THEN
#          CALL cl_err('','aws-078',1)
#          LET g_success = 'N'
#          RETURN
#       END IF
#    END IF
#    IF NOT cl_confirm('axm-108') THEN
#       LET g_success = 'N'
#       RETURN
#    END IF
#  END IF   
#  #CHI-C30118---add---END   
#CHI-C40016---mark---END-----------------------------------------
   
   IF (p_argv1 = '5') AND ( p_ask_post='Y') THEN
      CALL cl_msg( 'rvu_file:t720_y()')

      IF g_bgjob='N' OR cl_null(g_bgjob) THEN    #FUN-A50001 add
        CALL ui.Interface.refresh()
      END IF                                     #FUN-A50001 add
   END IF

   IF s_shut(0) THEN LET g_success = 'N' RETURN END IF

#FUN-BC0062 --begin-- mark by lixh1
#  IF g_ccz.ccz28  = '6' THEN
#     CALL cl_err('','apm-936',1)     
#     LET g_success = 'N'
#     RETURN
#  END IF
#FUN-BC0062 --end--

#FUN-B30129 ---begin---mark
#TQC-B20022 --begin--
#  CALL t720_rvu06_check(l_rvu.rvu06)
#  IF NOT cl_null(g_errno) THEN 
#     CALL cl_err(l_rvu.rvu06,g_errno,0)
#     LET g_success = 'N'
#     RETURN 
#  END IF 
#TQC-B20022 --end--
#FUN-B30129 ---end---

#TQC-B60085   ---start   Add
   IF NOT cl_null(l_rvu.rvu07) THEN
      SELECT gen02,genacti INTO l_gen02,l_genacti
        FROM gen_file WHERE gen01 = l_rvu.rvu07
      CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                     LET l_gen02 = NULL
           WHEN l_genacti='N' LET g_errno = '9028'
           OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
      END CASE
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(l_rvu.rvu07,g_errno,0)
         LET g_success = 'N'
         RETURN
      END IF 
   END IF
#TQC-B60085   ---end     Add

   # 考慮免檢收貨call 入庫確認
   IF p_argv1='5' THEN
      SELECT rvu_file.* INTO l_rvu.*
        FROM rvu_file
       WHERE (rvu00 = '1' OR rvu00 = '3')
         AND rvu02 = p_argv2
         AND rvuconf != 'X'     #No:MOD-850156 add
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("sel","rvu_file","","",SQLCA.sqlcode,"","sel rvu",1)
         LET g_success = 'N' RETURN
      END IF
   END IF

   IF p_argv1='6' THEN
      SELECT rvu_file.* INTO l_rvu.*
        FROM rvu_file
       WHERE rvu01 = p_argv2
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("sel","rvu_file","","",SQLCA.sqlcode,"","sel rvu",1)
         LET g_success = 'N' RETURN
      END IF
   END IF

   #無單身資料不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rvv_file
    WHERE rvv01=l_rvu.rvu01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',1)
      LET g_success = 'N' RETURN
   END IF
   #FUN-C70098----add----begin--------------
   IF s_industry("slk") AND g_azw.azw04 = '2' THEN
       DECLARE rvvslk31_curs CURSOR FOR
          SELECT rvvslk02,rvvslk31,rvvslk17 FROM rvvslk_file WHERE rvvslk01 = l_rvu.rvu01 
       CALL s_showmsg_init()
       FOREACH rvvslk31_curs INTO l_rvvslk02,l_rvvslk31,l_rvvslk17 
           IF cl_null(l_rvvslk17) OR l_rvvslk17 = 0 THEN
              CALL s_errmsg('',l_rvu.rvu01 ,l_rvvslk31 ,'axr-034',1)
              LET g_success = 'N'
           END IF
       END FOREACH
       CALL s_showmsg()
       IF g_success = 'N' THEN
          RETURN
       END IF
   END IF
   #FUN-C70098----add----end----------------

   DECLARE t720_rvv36 CURSOR FOR
       #SELECT rvv36,rvv37 FROM rvv_file WHERE rvv01 = l_rvu.rvu01   #MOD-A40166
       #SELECT rvv36,rvv37,rvv02,rvv17,rvv32,rvv31 FROM rvv_file WHERE rvv01 = l_rvu.rvu01   #MOD-A40166   #MOD-AA0164 add rvv31 #MOD-BC0057 mark
       SELECT rvv36,rvv37,rvv02,rvv17,rvv32,rvv31,rvv05 FROM rvv_file WHERE rvv01 = l_rvu.rvu01   #MOD-BC0057 add

   #FOREACH t720_rvv36 INTO l_rvv36,l_rvv37   #MOD-A40166
   #FOREACH t720_rvv36 INTO l_rvv36,l_rvv37,l_rvv02,l_rvv17,l_rvv32,l_rvv31   #MOD-A40166   #MOD-AA0164 add rvv31 #MOD-BC0057 mark
   FOREACH t720_rvv36 INTO l_rvv36,l_rvv37,l_rvv02,l_rvv17,l_rvv32,l_rvv31,l_rvv05   #MOD-BC0057 add
      #-----MOD-A40166---------
      IF l_rvu.rvu00='3' AND l_rvv17>0 AND cl_null(l_rvv32) AND 
         l_rvv31[1,4] <> 'MISC' AND l_rvu.rvu116 <> '3' THEN   #MOD-AA0164 #MOD-D30083 add l_rvu.rvu116
         #CALL cl_err(l_rvv02,'apm1023',0)  #MOD-BC0059 mark
         CALL cl_err(l_rvv02,'apm1067',0)   #MOD-BC0059 add
         LET g_success = 'N'
         RETURN
      END IF
      #-----END MOD-A40166-----
      IF STATUS THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,0)
         RETURN
      END IF

      #MOD-BC0057 ---- modify start -----
      IF NOT cl_null(l_rvu.rvu02) AND l_rvu.rvu00 = 3 THEN
         SELECT rvu03 INTO l_rvu03 FROM rvu_file,rvv_file
          WHERE rvu01 = rvv01 AND rvu00 = 1
            AND rvu02 = l_rvu.rvu02 AND rvv05 = l_rvv05
          ORDER BY rvu03 ASC
         IF l_rvu.rvu03 < l_rvu03 THEN
             CALL cl_err(l_rvu03,'apm1076',0)
             LET g_success = 'N'
             RETURN
         END IF
      END IF
      #MOD-BC0057 ----  modify end  -----

#MOD-C30507----add---begin---    
      IF l_rvu.rvu116 <> '3' THEN  #MOD-D30122 add  
         SELECT ima159 INTO l_ima159 FROM ima_file
          WHERE ima01 = l_rvv31
         SELECT rvv34 INTO l_rvv34 FROM rvv_file WHERE rvv01= l_rvu.rvu01 AND rvv02=l_rvv02
         IF l_ima159 = '1' AND cl_null(l_rvv34) THEN 
            CALL cl_err(l_rvv02,'aim-034',1)
            LET g_success = 'N'
            RETURN 
         END IF
      END IF  #MOD-D30122 add 
#MOD-C30507----add---end---  

      SELECT pmn16 INTO l_pmn16 FROM pmn_file
        WHERE pmn01 = l_rvv36
          AND pmn02 = l_rvv37
      IF l_pmn16 != '2' AND l_rvu.rvu00<>'3' THEN 
         #CALL cl_err('','mfg3166',1)   #CHI-B10047
         CALL cl_err_msg("","apm1054",l_rvv36 CLIPPED|| "|" || l_rvv37 CLIPPED,0)   #CHI-B10047
         LET g_success = 'N' 
         RETURN
      END IF
     #FUN-A60009 add str -----
     #ICD行業別檢查發料量與所維護之數量是否一致
      IF s_industry('icd') THEN
         SELECT rvv03,rvv33,rvv34,rvviicd07
           INTO l_rvv03,l_rvv33,l_rvv34,l_rvviicd07
           FROM rvv_file,rvvi_file
          WHERE rvv01 = l_rvu.rvu01
            AND rvv02 = l_rvv02
            AND rvvi01= rvv01
            AND rvvi02= rvv02

         IF l_rvviicd07<>'Y' AND p_argv3<>'TAP' THEN    #委外tky非最終站不用檢查
            #FUN-BA0051 --START mark--
            #SELECT imaicd08,imaicd04 INTO l_imaicd08,l_imaicd04
            #  FROM imaicd_file
            # WHERE imaicd00 = l_rvv31
            #FUN-BA0051 --END mark-- 

            #MOD-B90265 add --start--
            CASE
              WHEN l_rvu.rvu00='1'   # 異動類別:1.入庫
                      LET l_type=1
              WHEN l_rvu.rvu00='2'   #2.驗退
                      LET l_type=0
              WHEN l_rvu.rvu00='3'   #3.倉退
                      LET l_type=-1
            END CASE
            #MOD-B90265 add --end--
            #IF l_imaicd04 MATCHES '[0124]' AND l_imaicd08 = 'Y' THEN   #FUN-BA0051 mark
            IF s_icdbin(l_rvv31) THEN   #FUN-BA0051
              #CALL s_icdchk(1,l_rvv31,l_rvv32,l_rvv33,l_rvv34,      #MOD-B90265 mark
               CALL s_icdchk(l_type,l_rvv31,l_rvv32,l_rvv33,l_rvv34, #MOD-B90265
                               l_rvv17,l_rvu.rvu01,l_rvv02,l_rvu.rvu03,'')  #FUN-B80119--傳入p_plant參數''---
                    RETURNING l_flag
               IF l_flag = 0 THEN
                  LET g_success = 'N'
                  RETURN
               END IF
            END IF
         END IF
      END IF
     #FUN-A60009 add end -----
   END FOREACH
   #MOD-D60078 add begin--------------------
   DECLARE t720_rvv26 CURSOR FOR
      SELECT rvv02,rvv31,rvv32,rvv26 FROM rvv_file WHERE rvv01 = l_rvu.rvu01
   CALL s_showmsg_init()   
   FOREACH t720_rvv26 INTO l_rvv02,l_rvv31,l_rvv32,l_rvv26 
      IF STATUS THEN
         CALL cl_err('foreach t720_rvv26:',SQLCA.sqlcode,0)
         LET g_success = 'N' 
         RETURN
      END IF     
      IF l_rvu.rvu00 = '3' THEN
         IF cl_null(l_rvv26) THEN
            LET g_showmsg = l_rvv02,"/",l_rvv31
            CALL s_errmsg('rvv02,rvv31',g_showmsg,'','aim-888',1)            
            LET g_success = 'N'
            CONTINUE FOREACH  
         END IF
      END IF
      IF NOT cl_null(l_rvv26) THEN
         LET l_n = 0
         CALL s_get_where(l_rvu.rvu01,l_rvu.rvu02,'',l_rvv31,
                          l_rvv32,l_rvu.rvu07,l_rvu.rvu06) RETURNING l_flag2,l_where
         IF g_aza.aza115='Y' AND l_flag2 THEN
            LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",l_rvv26,"' AND ",l_where
            PREPARE ggc08_pre2 FROM l_sql
            EXECUTE ggc08_pre2 INTO l_n
            IF l_n < 1 THEN
               LET g_showmsg = l_rvv02,"/",l_rvv31,"/",l_rvv26
               CALL s_errmsg('rvv02,rvv31,rvv26',g_showmsg,'','aim-425',1)            
               LET g_success = 'N'
               CONTINUE FOREACH  
            END IF
         ELSE
            IF NOT cl_null(l_rvv26) THEN
                SELECT azf09 INTO l_azf09 FROM azf_file
                 WHERE azf01=l_rvv26 AND azf02='2'
                IF l_azf09 !='7' AND l_rvu.rvu00 = '1' THEN 
                   LET g_showmsg = l_rvv02,"/",l_rvv31,"/",l_rvv26
                   CALL s_errmsg('rvv02,rvv31,rvv26',g_showmsg,'','aoo-406',1)            
                   LET g_success = 'N'
                   CONTINUE FOREACH                         
                END IF
                IF l_azf09 !='5' AND l_rvu.rvu00 <> '1' THEN
                   LET g_showmsg = l_rvv02,"/",l_rvv31,"/",l_rvv26
                   CALL s_errmsg('rvv02,rvv31,rvv26',g_showmsg,'','aoo-406',1)            
                   LET g_success = 'N'
                   CONTINUE FOREACH     
                END IF
            END IF
         END IF  
      END IF 
   END FOREACH 
   CALL s_showmsg() 
   IF g_success = 'N' THEN
      RETURN 
   END IF        
   #MOD-D60078 add end--------------------#
   DECLARE t720_rvv32 CURSOR FOR
    SELECT rvv02,rvv32,rvv33 FROM rvv_file WHERE rvv01 = l_rvu.rvu01
   CALL s_showmsg_init()
   FOREACH t720_rvv32 INTO l_rvv02,l_rvv32,l_rvv33 
      IF STATUS THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,0)
         LET g_success = 'N' RETURN
      END IF
      #TQC-B80005 --START--
      IF s_industry('icd') THEN
         SELECT rvviicd07 INTO l_rvviicd07 FROM rvvi_file
          WHERE rvvi01 = l_rvu.rvu01 AND rvvi02 = l_rvv02
         IF l_rvviicd07 = 'Y' THEN
            CONTINUE FOREACH  
         END IF 
      END IF 
      #TQC-B80005 --END--
      #No.FUN-AB0058  --Begin
      IF NOT s_chk_ware(l_rvv32) THEN
         LET g_success = 'N' RETURN
      END IF
      #No.FUN-AB0058  --End 
      CALL s_incchk(l_rvv32,l_rvv33,g_user) 
           RETURNING lj_result
      IF NOT lj_result THEN
         LET g_totsuccess = 'N'  #TQC-AC0277
         LET g_showmsg = l_rvv02,"/",l_rvv32,"/",l_rvv33,"/",g_user
         CALL s_errmsg('rvv02,rvv32,rvv33,inc03',g_showmsg,'','asf-888',1)
      END IF
     #CALL s_showmsg()        #TQC-AC0277
     #IF g_success = 'N' THEN #TQC-AC0277
     #   RETURN               #TQC-AC0277
     #END IF                  #TQC-AC0277
   END FOREACH
   #TQC-AC0277--begin--add----
   CALL s_showmsg() 
   IF g_totsuccess = 'N' THEN
      LET g_success = 'N'
      RETURN 
   END IF
   #TQC-AC0277--end--add---
#TQC-C80093 -- mark -- begin
#  IF cl_null(l_rvu.rvu01) THEN
#     CALL cl_err('',-400,1)
#     LET g_success = 'N' RETURN
#  END IF


#  IF l_rvu.rvuconf = 'Y' THEN
#     CALL cl_err('','9023',1)
#     LET g_success = 'N' RETURN
#  END IF

#  IF l_rvu.rvuconf = 'X' THEN
#     CALL cl_err('','9024',1)
#     LET g_success = 'N' RETURN
#  END IF

# #FUN-A60009 add str -------------
#  IF l_rvu.rvuacti = 'N' THEN
#     CALL cl_err('','mfg0301',1)
#     LET g_success = 'N'
#     RETURN
#  END IF
# #FUN-A60009 add end -------------

#  IF g_sma.sma53 IS NOT NULL AND l_rvu.rvu03 <= g_sma.sma53 THEN
#     CALL cl_err('','mfg9999',1)
#     LET g_success = 'N' RETURN
#  END IF

#  CALL s_yp(l_rvu.rvu03) RETURNING l_yy,l_mm

#  IF (l_yy*12+l_mm)>(g_sma.sma51*12+g_sma.sma52)THEN #不可大於現行年月
#     CALL cl_err('','mfg6091',1)
#     LET g_success = 'N' RETURN #TQC-AC0277
#  END IF
#TQC-C80093 -- mark -- end
#FUN-D60130 -----Begin------
  #IF p_argv3='SUB' THEN
  #   LET l_cnt=0
  #   SELECT COUNT(*) INTO l_cnt
  #     FROM rvu_file,rvv_file,sfb_file
  #    WHERE rvv01=rvu01
  #      AND sfb01=rvv18
  #      AND sfb04='8'
  #      AND rvu01=l_rvu.rvu01
  #   IF l_cnt>0 THEN
  #      CALL cl_err('','asf-070',1)
  #      LET g_success = 'N' RETURN
  #   END IF
  #END IF
#FUN-D60130 -----End--------

   IF g_azw.azw04 = '2' THEN
      IF g_prog='apmt742' THEN
         CALL t720sub_rvu04(l_rvu.rvu04,l_rvu.rvuplant)
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(l_rvu.rvu04,g_errno,0)
            RETURN
         END IF
      END IF
   END IF

  #DEV-D40015 add str-------------
  #若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，需控卡不可直接確認or過帳
   IF g_aza.aza131 = 'Y' AND (g_prog = 'apmt720' OR g_prog = 'apmt721') THEN
     #確認是否有符合條件的料件
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM ima_file
       WHERE ima01 IN (SELECT rvv31 FROM rvv_file WHERE rvv01 = l_rvu.rvu01) #料件
         AND ima930 = 'Y'                   #條碼使用否
         AND (ima921 = 'Y' OR ima918 = 'Y') #批號管理否='Y' OR 序號管理否='Y'
         AND (ima932 <> 'E')                #條碼產生時機點不等於E(採購入庫)

     #DEV-D40020---add----str---
     CALL t720_chk_scan_in_t110(l_rvu.rvu02) RETURNING l_scan_flag #==>收貨時有無掃瞄記錄
     #DEV-D40020---add----str---
	
     #確認是否已有掃描紀錄
     #IF l_cnt > 0 THEN                       #DEV-D40020 mark
      IF l_cnt > 0 AND l_scan_flag = 'N' THEN #DEV-D40020 add
         IF NOT s_chk_barcode_confirm('confirm','tlfb',l_rvu.rvu01,'','') THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF
  #DEV-D40015 add end-------------
   
#CHI-C40016---mark---START------------般移至一開始處
#  IF NOT p_argv1 MATCHES '[56]' THEN  #收貨免檢:驗收確認不再詢問 
#     IF p_ask_post='Y' THEN
#        IF NOT cl_confirm('aap-017') THEN
#           LET g_success = 'N' RETURN
#        END IF
#      END IF
#  END IF
#CHI-C40016---mark---END-----------------------------------------
END FUNCTION

#p_inTransaction : IF p_inTransaction=FALSE 會在程式中呼叫BEGIN WORK
#p_ask_post : IF p_ask_post=TRUE 會詢問"是否執行過帳"
#p_argv1 : 異動狀況  p_argv2 :驗收單號 p_argv3 : 參數-3(性質)
#p_chr : 單據性質
#FUNCTION t720sub_y_upd(p_rvu01,p_argv1,p_argv2,p_argv3,p_chr,p_inTransaction,p_ask_post)       #MOD-C80049 mark
FUNCTION t720sub_y_upd(p_rvu01,p_argv1,p_argv2,p_argv3,p_chr,p_inTransaction,p_ask_post,p_auto) #MOD-C80049 add
   DEFINE  l_a     LIKE type_file.chr1 
   DEFINE  l_cmd   LIKE type_file.chr1000 
   DEFINE  l_cnt   LIKE type_file.num5 
   DEFINE  l_rva99 LIKE rva_file.rva99,
           p_poz01 LIKE poz_file.poz01,
           p_poz18 LIKE poz_file.poz18,
           p_poz19 LIKE poz_file.poz19
   DEFINE l_rvv36  LIKE rvv_file.rvv36
   DEFINE l_rvv37  LIKE rvv_file.rvv37
   DEFINE l_pmn16  LIKE pmn_file.pmn16
   DEFINE l_status LIKE type_file.chr1
   DEFINE l_rvv02    LIKE rvv_file.rvv02
   DEFINE l_rvv32    LIKE rvv_file.rvv32
   DEFINE l_rvv33    LIKE rvv_file.rvv33
   DEFINE lj_result  LIKE type_file.chr1
   DEFINE l_sma131   LIKE sma_file.sma131
   DEFINE l_pmm02    LIKE pmm_file.pmm02 
   DEFINE l_poy04  LIKE poy_file.poy04 
   DEFINE l_azp03  LIKE azp_file.azp03 
   DEFINE l_gen02  LIKE gen_file.gen02
   DEFINE l_rvucont LIKE rvu_file.rvucont 
   DEFINE p_dbs_tra       LIKE azw_file.azw05 
   DEFINE p_plant_new     LIKE azp_file.azp01 
   DEFINE p_plant         LIKE azp_file.azp01 
   DEFINE l_sfb93         LIKE sfb_file.sfb93 
   DEFINE p_argv1  LIKE rvu_file.rvu00
   DEFINE p_argv2  LIKE rvu_file.rvu02
   DEFINE p_argv3  LIKE rvu_file.rvu08
   DEFINE l_rvu       RECORD LIKE rvu_file.*
   DEFINE p_rvu01     LIKE rvu_file.rvu01
   DEFINE l_yy,l_mm   LIKE type_file.num5
   DEFINE p_inTransaction LIKE type_file.num5 
   DEFINE p_ask_post  LIKE type_file.chr1
   DEFINE l_icq       LIKE type_file.chr1
   DEFINE p_chr       LIKE type_file.chr1
   DEFINE l_sql       STRING
   DEFINE l_rva00     LIKE rva_file.rva00
   DEFINE l_rvv18     LIKE rvv_file.rvv18
   DEFINE l_rvv17     LIKE rvv_file.rvv17   #MOD-A40166
   DEFINE l_rvv31     LIKE rvv_file.rvv31   #MOD-AA0164
#  DEFINE l_smy74     LIKE smy_file.smy74   #No.MOD-AC0333   #FUN-B30161 mark  #TQC-B40020 unmark
#  DEFINE l_sma91     LIKE sma_file.sma91   #FUN-B30161     #TQC-B40020 #TQC-B60252
#  DEFINE l_sma92     LIKE sma_file.sma92   #FUN-B30161    #TQC-B40020 #TQC-B60252 
   DEFINE l_smyslip   LIKE smy_file.smyslip #No.MOD-AC0333
   DEFINE l_msg       LIKE ze_file.ze03      #CHI-B40011
   DEFINE l_rvv       RECORD LIKE rvv_file.*  #FUN-C70087
   #DEFINE l_img_table      STRING             #FUN-C70087  #FUN-CC0095
   #DEFINE l_imgg_table     STRING             #FUN-C70087  #FUN-CC0095
   DEFINE l_cnt_img   LIKE type_file.num5     #FUN-C70087
   DEFINE l_cnt_imgg  LIKE type_file.num5     #FUN-C70087
   DEFINE l_flag      LIKE type_file.chr1     #FUN-C70087
   DEFINE p_auto      LIKE type_file.chr1 #MOD-C80049 add
   DEFINE l_tc_sfp01  LIKE tc_sfp_file.tc_sfp01  #add by guanyao160523
   DEFINE l_rvv02_1   LIKE rvv_file.rvv02        #add by guanyao160523
   DEFINE l_rvv05_1   LIKE rvv_file.rvv05        #add by guanyao160523 

   #CALL s_padd_img_create() RETURNING l_img_table   #FUN-C70087  #FUN-CC0095
   #CALL s_padd_imgg_create() RETURNING l_imgg_table #FUN-C70087  #FUN-CC0095
   #FUN-A60009 add str ----------------------
   LET g_success = 'Y'
   
   SELECT * INTO l_rvu.* FROM rvu_file WHERE rvu01=p_rvu01
   SELECT rva00 INTO l_rva00 FROM rva_file WHERE rva01 = l_rvu.rvu02   #TQC-B30198
   
#CHI-C40016---remark---START-----------------------------------------
#CHI-C30118---mark---START
  IF g_action_choice CLIPPED = "confirm" OR      #執行 "確認" 功能(非簽核模式呼叫)
     g_action_choice CLIPPED = "insert"  THEN
    IF l_rvu.rvumksg = 'Y' THEN                  #若簽核碼為 'Y' 且狀態碼不為 '1' 已同意
       IF l_rvu.rvu17 != '1' THEN
          CALL cl_err('','aws-078',1)
          LET g_success = 'N'
          #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #FUN-CC0095
          #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #FUN-CC0095
          RETURN
       END IF
    END IF
   #IF NOT cl_confirm('axm-108') THEN
   #   LET g_success = 'N'
   #   RETURN
   #END IF
  END IF
  #FUN-A60009 add end ----------------------
#CHI-C30118---mark---END
#CHI-C40016---remark---END-----------------------------------------   

   #DEV-D40015 add begin
   #自動產生barcode
   IF g_success='Y' AND g_prog = 'apmt720' AND g_aza.aza131 = 'Y' THEN
      CALL t720sub_barcode_gen(l_rvu.rvu01,'N')
   END IF
   #DEV-D40015 add end

   IF NOT p_inTransaction THEN
       BEGIN WORK
   END IF

  #LET g_success = 'Y'   #FUN-A60009 mark   
   LET l_icq='Y'

   #FUN-C70087---begin
   CALL s_padd_img_init()  #FUN-CC0095
   CALL s_padd_imgg_init()  #FUN-CC0095
   
   DECLARE t720_u1_c1 CURSOR FOR SELECT * FROM rvv_file
     WHERE rvv01 = l_rvu.rvu01

   FOREACH t720_u1_c1 INTO l_rvv.*
      IF STATUS THEN EXIT FOREACH END IF
      LET l_cnt_img = 0
      SELECT COUNT(*) INTO l_cnt_img
        FROM img_file
       WHERE img01 = l_rvv.rvv31
         AND img02 = l_rvv.rvv32
         AND img03 = l_rvv.rvv33
         AND img04 = l_rvv.rvv34
       IF l_cnt_img = 0 THEN
          #CALL s_padd_img_data(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvu.rvu01,l_rvv.rvv02,l_rvu.rvu03,l_img_table) #FUN-CC0095
          CALL s_padd_img_data1(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvu.rvu01,l_rvv.rvv02,l_rvu.rvu03) #FUN-CC0095
       END IF

       CALL s_chk_imgg(l_rvv.rvv31,l_rvv.rvv32,
                       l_rvv.rvv33,l_rvv.rvv34,
                       l_rvv.rvv80) RETURNING l_flag
       IF l_flag = 1 THEN
          #CALL s_padd_imgg_data(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv80,l_rvu.rvu01,l_rvv.rvv02,l_imgg_table) #FUN-CC0095
          CALL s_padd_imgg_data1(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv80,l_rvu.rvu01,l_rvv.rvv02) #FUN-CC0095
       END IF 
       CALL s_chk_imgg(l_rvv.rvv31,l_rvv.rvv32,
                       l_rvv.rvv33,l_rvv.rvv34,
                       l_rvv.rvv83) RETURNING l_flag
       IF l_flag = 1 THEN
          #CALL s_padd_imgg_data(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv83,l_rvu.rvu01,l_rvv.rvv02,l_imgg_table) #FUN-CC0095
          CALL s_padd_imgg_data1(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv83,l_rvu.rvu01,l_rvv.rvv02) #FUN-CC0095
       END IF 
   END FOREACH 
   #FUN-CC0095---begin mark
   #LET l_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_img_table CLIPPED #,g_cr_db_str
   #PREPARE cnt_img FROM l_sql
   #LET l_cnt_img = 0
   #EXECUTE cnt_img INTO l_cnt_img
   #
   #LET l_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_imgg_table CLIPPED #,g_cr_db_str
   #PREPARE cnt_imgg FROM l_sql
   #LET l_cnt_imgg = 0
   #EXECUTE cnt_imgg INTO l_cnt_imgg
   #FUN-CC0095---end    
   LET l_cnt_img = g_padd_img.getLength()  #FUN-CC0095
   LET l_cnt_imgg = g_padd_imgg.getLength()  #FUN-CC0095
   
   IF g_sma.sma892[3,3] = 'Y' AND (l_cnt_img > 0 OR l_cnt_imgg > 0) THEN
      IF NOT cl_null(l_rvv.rvv32) OR NOT cl_null(l_rvv.rvv33) OR NOT cl_null(l_rvv.rvv34) THEN    #MOD-D30083 add
         IF cl_confirm('mfg1401') THEN 
            IF l_cnt_img > 0 THEN 
               #IF NOT s_padd_img_show(l_img_table) THEN  #FUN-CC0095 
               IF NOT s_padd_img_show1() THEN  #FUN-CC0095
                  #CALL s_padd_img_drop(l_img_table)  #FUN-CC0095
                  LET g_success = 'N'
                  #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #CHI-CB0041
                  #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #CHI-CB0041
                  RETURN 
               END IF 
            END IF 
            IF l_cnt_imgg > 0 THEN #FUN-CC0095 
               #IF NOT s_padd_imgg_show(l_imgg_table) THEN  #FUN-CC0095
               IF NOT s_padd_imgg_show1() THEN  #FUN-CC0095
                  #CALL s_padd_imgg_drop(l_imgg_table)  #FUN-CC0095
                  LET g_success = 'N'
                  #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #CHI-CB0041
                  #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #CHI-CB0041
                  RETURN 
               END IF 
            END IF #FUN-CC0095 
         ELSE
            #CALL s_padd_img_drop(l_img_table)  #FUN-CC0095
            #CALL s_padd_imgg_drop(l_imgg_table)  #FUN-CC0095
            LET g_success = 'N'
            #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #CHI-CB0041
            #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #CHI-CB0041
            RETURN
         END IF
      END IF  #MOD-D30083 add
   END IF

   #CALL s_padd_img_del(l_img_table) #FUN-CC0095
   #CALL s_padd_imgg_del(l_imgg_table)  #FUN-CC0095
   #FUN-C70087---end
   
   CALL t720sub_lock_cl()
   
   OPEN t720sub_cl USING l_rvu.rvu01
   IF STATUS THEN
      CALL cl_err("OPEN t720sub_cl:", STATUS, 1)
      CLOSE t720sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET g_success = 'N' 
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #FUN-CC0095
      RETURN
   END IF

   FETCH t720sub_cl INTO l_rvu.*                    #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_rvu.rvu01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t720sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET g_success = 'N' 
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
      RETURN
   END IF

   #更新單頭確認碼
   LET l_rvucont=TIME
   IF g_success='Y' THEN
      UPDATE rvu_file 
         SET rvuconf = 'Y',
             rvu17 = '1',           #FUN-A60009 add:簽核狀況 = '已核准'
             rvuconu = g_user,
             rvucond = g_today,
             rvucont = l_rvucont
       WHERE rvu01 = l_rvu.rvu01
   END IF

   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err('upd rvuconf',status,1)
      LET g_success='N'
   ELSE
     #FUN-A60009 add str ----------------
      IF l_rvu.rvumksg = 'Y' THEN                 #簽核模式
         CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
              WHEN 0  #呼叫 EasyFlow 簽核失敗
                   LET l_rvu.rvuconf="N"
                   LET g_success = "N"
                   IF NOT p_inTransaction THEN ROLLBACK WORK END IF
                   #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #FUN-CC0095
                   #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #FUN-CC0095
                   RETURN
              WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                   LET l_rvu.rvuconf="N"
                   LET g_success = "N"
                   IF NOT p_inTransaction THEN ROLLBACK WORK END IF
                   #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #FUN-CC0095
                   #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #FUN-CC0095
                   RETURN
         END CASE
      END IF

      LET l_rvu.rvu17='1'                #執行成功, 狀態值顯示為 '1' 已核准
      LET l_rvu.rvuconf='Y'              #執行成功, 確認碼顯示為 'Y' 已確認
     #FUN-A60009 add end ---------------
        
     #若為中斷點入庫單回寫對應收貨單的流程序號
      IF l_rvu.rvu08 = 'TAP' OR l_rvu.rvu08 = 'TRI' THEN
        SELECT rva99,poz01,poz18,poz19 INTO l_rva99,p_poz01,p_poz18,p_poz19
          FROM poz_file,rva_file,rvb_file,pmm_file
         WHERE poz01 = pmm904
           AND pmm01 = rvb04
           AND rvb01 = rva01
           AND rva01 = l_rvu.rvu02
         LET l_cnt = 0
         IF p_poz19 = 'Y'  AND g_plant=p_poz18 THEN    #已設立中斷點
            SELECT COUNT(*) INTO l_cnt   #check poz18設定的中斷營運中心是否存在單身設>
              FROM poy_file
            WHERE poy01 = p_poz01
              AND poy04 = p_poz18
        END IF
        IF l_cnt > 0 THEN
            IF g_success='Y' THEN
               LET l_rvu.rvu20 = 'Y'
               IF l_rvu.rvu00 = '3' THEN    #TQC-A40104
                  SELECT poy04 INTO l_poy04
                    FROM poy_file
                   WHERE poy01 = p_poz01 
                     AND poy02 = (SELECT MAX(poy02) FROM poy_file WHERE poy01 = p_poz01)
                  
                  LET l_azp03 = s_getdbs_curr(l_poy04)
                  
                 #FUN-A50102 ------------------mark start----------------------  
                 #LET g_plant_new = l_poy04
                 #CALL s_getdbs()
                 #LET l_azp03 = g_dbs_new
                 #LET p_plant_new = g_plant_new
                 #CALL s_gettrandbs()
                 #LET p_dbs_tra = g_dbs_tra
                 #FUN-A50102 -----------------mark end------------------------- 
                  
                  LET l_sql = "SELECT oha99 ",  
                            # "  FROM ",p_dbs_tra CLIPPED,"oha_file, ",               #FUN-A50102 mark
                            #           p_dbs_tra CLIPPED,"ohb_file, ",               #FUN-A50102 mark
                            #           p_dbs_tra CLIPPED,"oga_file  ",               #FUN-A50102 mark 
                              "  FROM ",cl_get_target_table(l_poy04,'oha_file'),",",  #FUN-A50102
                                        cl_get_target_table(l_poy04,'ohb_file'),",",  #FUN-A50102
                                        cl_get_target_table(l_poy04,'oga_file'),      #FUN-A50102 
                              " WHERE oha01 = ohb01 AND ohb31 = oga01 ", 
                              "   AND oga99 = ? "
                 #CALL cl_parse_qry_sql(l_sql,p_plant_new) RETURNING l_sql
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
                  CALL cl_parse_qry_sql(l_sql,l_poy04) RETURNING l_sql       #FUN-A50102
                  PREPARE t720_p1 FROM l_sql 
                  DECLARE t720_c1 CURSOR FOR t720_p1
                  OPEN  t720_c1 USING l_rva99
                  FETCH t720_c1 INTO l_rvu.rvu99
                  #CHI-CC0007 add --start--
                  IF cl_null(l_rvu.rvu99) THEN
                     CALL cl_err('','apm1085',1)
                     LET g_success='N'
                  END IF
                  #CHI-CC0007 add --end--
               ELSE   #TQC-A40104
                  LET l_rvu.rvu99 = l_rva99   #TQC-A40104 
               END IF   #TQC-A40104

               UPDATE rvu_file SET rvu99 = l_rvu.rvu99,
                                   rvu20 = l_rvu.rvu20
                WHERE rvu01 = l_rvu.rvu01
               IF STATUS OR sqlca.sqlerrd[3]=0 THEN
                  CALL cl_err3("upd","rvu_file",l_rvu.rvu01,"",SQLCA.sqlcode,"","update rvu99",1)
                  LET g_success='N'
               END IF
               IF cl_null(l_rva99) THEN LET g_success='N' END IF
            END IF
        END IF
      END IF

      IF s_industry('icd') THEN
         IF g_success = 'Y' THEN
            #委外tky收貨單入庫後的正確性檢查
             CALL t720sub_ind_icd_chk_tky(l_rvu.*,p_argv3)
             IF g_success = 'Y' THEN                           #FUN-A60009 add
               #委外tky非最終站收貨項次的數量更新
                CALL t720sub_ind_icd_tky_upd_rvb('y',p_argv3,l_rvu.*,p_argv1)
             END IF                                            #FUN-A60009 add
         END IF
      END IF

      IF p_argv1 <> '6' THEN 
        #不為背景程式呼叫才處理
         IF g_bgjob='N' OR cl_null(g_bgjob) THEN      #FUN-A60009 add
           IF l_rvu.rvu00='1' AND l_rvu.rvu02 IS NOT NULL AND g_success='Y'
              AND g_qcz.qcz05='Y' THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM qcs_file
               WHERE qcs01=l_rvu.rvu02    #驗收單號
                 AND qcs14='Y'            #確認碼
                 AND qcs09<>'2'           #1.合格 2.退貨 3.特採
              IF l_cnt>0 THEN
                 CALL t720sub_IQC_return2(l_rvu.*,l_rva00) #將剩餘未入庫量轉為'驗退單'
              END IF
           END IF
         END IF                                       #FUN-A60009 add
      END IF
      IF g_success='Y' THEN
         CALL t720sub_s1(l_rvu.*,p_argv3,p_argv1,l_rva00)
      END IF
   END IF

   #No:DEV-D30026--add--begin
   IF g_success ='Y' AND l_rvu.rvu00 ='1' AND g_aza.aza131='Y' THEN
      #CALL t720sub_barcode(l_rvu.rvu01,1,p_argv3)   #DEV-D40020 mark
       CALL t720sub_barcode2(l_rvu.rvu01,1,p_argv3)  #DEV-D40020 add==>產生採購入庫掃瞄記錄及異動條碼庫存
   END IF
   #No:DEV-D30026--add--end
#str-------add by guanyao160523
   IF g_prog = 'apmt730' THEN 
      IF g_success = 'Y' THEN 
         LET l_tc_sfp01 = ''
         DECLARE t720_tc_sfp CURSOR FOR 
            SELECT tc_sfp01 INTO l_tc_sfp01 FROM tc_sfp_file,rvv_file,rvu_file 
             WHERE tc_sfp11 = rvu02 
               AND tc_sfp12 = rvv05
               AND rvu01 = rvv01
               AND rvv01=l_rvu.rvu01
               AND tc_sfp00 = '2'
               AND tc_sfp13 = '0'
         FOREACH t720_tc_sfp INTO l_tc_sfp01
            IF NOT cl_null(l_tc_sfp01) THEN 
               CALL t720_ins(l_tc_sfp01)
            END IF 
            IF g_success = 'N' THEN 
               LET g_totsuccess="N"
               LET g_success = 'Y' 
            END IF 
         END FOREACH 
         IF g_totsuccess="N" THEN 
            LET g_success = 'Y' 
         END IF 
      END IF 
   END IF 
#end-------add by guanyao160523   

   IF g_success = 'Y' THEN
      IF NOT p_inTransaction THEN COMMIT WORK END IF
      CALL cl_flow_notify(l_rvu.rvu01,'Y')
      LET l_rvu.rvuconf = 'Y'
      LET l_rvu.rvu17 = '1'        #FUN-A60009 add
      LET l_rvu.rvuconu = g_user
      LET l_rvu.rvucond = g_today
      LET l_rvu.rvucont = l_rvucont
   ELSE
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET l_rvu.rvuconf='N'
   END IF
     
   IF p_argv1 <> '6' THEN 
     #不為背景執行程式才處理
      IF g_bgjob='N' OR cl_null(g_bgjob) THEN      #FUN-A60009 add
        IF l_rvu.rvu00='1' AND l_rvu.rvu02 IS NOT NULL AND g_success='Y' THEN
           CALL t720sub_IQC_return(l_rvu.*,p_argv1,p_argv3,p_chr,p_inTransaction,p_ask_post,l_rva00)  #將剩餘未入庫量轉為'驗退單'
        END IF
      END IF                                       #FUN-A60009 add
   END IF
   
   IF g_success = 'Y' THEN
   IF SQLCA.SQLCODE THEN
      CALL cl_err('', SQLCA.SQLCODE,1)
      LET g_success = 'N'
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #FUN-CC0095
      RETURN
   END IF
   IF l_rva00 = '1' THEN
      SELECT UNIQUE pmm02
        INTO l_pmm02
       FROM pmm_file
      WHERE pmm01 IN (SELECT rvv36 FROM rvv_file
                      WHERE rvv01 = l_rvu.rvu01)
      SELECT sma131 INTO l_sma131 FROM sma_file WHERE sma00 = '0' #MOD-C30471  add
      IF l_pmm02 = 'SUB' AND l_sma131 = 'Y' AND (g_sma.sma1431='N' OR cl_null(g_sma.sma1431)) THEN #為委外入庫單且入庫后自動生成移轉資料  #FUN-A80102
         LET l_sql = " SELECT rvv18 FROM rvv_file ",
                     "  WHERE rvv01 = '",l_rvu.rvu01,"'",
                     "  ORDER BY rvv02 "
         PREPARE t720sub_p FROM l_sql
         DECLARE t720sub_curs CURSOR FOR t720sub_p
         FOREACH t720sub_curs INTO l_rvv18
           EXIT FOREACH
         END FOREACH
         SELECT sfb93 INTO l_sfb93 FROM sfb_file WHERE sfb01=l_rvv18
         #IF l_sfb93='Y' THEN                 #MOD-C80049 mark
         IF l_sfb93='Y' AND p_auto = 'Y' THEN #MOD-C80049 add
            CALL t720sub_ecm(l_rvu.rvu01)
         END IF
      END IF
   END IF
   END IF

   #No.FUN-A80026  --Begin
   #No.MOD-AC0333  --Begin
   #IF g_success = 'Y' AND NOT p_inTransaction AND g_smy.smy74='Y' THEN
   IF g_success = 'Y' AND NOT p_inTransaction THEN

      #FUN-B30161-modify--start--                                #TQC-B40020 mark
 #     LET l_smyslip = s_get_doc_no(l_rvu.rvu01)                            #TQC-B40020 unmark
 #     SELECT smy74 INTO l_smy74 FROM smy_file WHERE smyslip = l_smyslip   #TQC-B40020 unmark
#TQC-B40020 --begin--      
#     SELECT sma91 INTO l_sma91 FROM sma_file          
#      IF SQLCA.sqlcode THEN
#         #LET l_smy74 = 'N'
#         LET l_sma91= 'N'
#      END IF
#TQC-B40020 --end--
 #    IF cl_null(l_smy74) THEN LET l_smy74 = 'N' END IF  #TQC-B40020
 #     IF cl_null(l_sma91) THEN LET l_sma91 = 'N' END IF         #TQC-B40020 
      #FUN-B30161-modify-end--
    
 #    IF l_smy74 = 'Y' THEN                            #TQC-B40020 unmark
 #     SELECT sma92 INTO l_sma92 FROM sma_file        #FUN-B30161     #TQC-B40020
#     IF g_sma.sma91= 'Y' THEN                          #FUN-B30161       #TQC-B40020   #MOD-B80272 mark
   #No.MOD-AC0333  --End  
   #     IF p_argv3 = 'REG' AND l_sma92 = 'Y' THEN      #MOD-B30403 add  #FUN-B30161 add l_sma92的判斷 #TQC-B40020
#        IF l_rvu.rvu08 = 'REG' AND g_sma.sma91 = 'Y' THEN  #FUN-B30161 ##TQC-B60252 #MOD-B80272 mark
 #       IF l_rvu.rvu08='REG' AND (g_sma.sma91='Y' OR g_sma.sma92='Y') THEN          #MOD-B80272 #MOD-BB0034 mark
   #     IF p_argv3 = 'REG' THEN      #MOD-B30403 add  #FUN-B30161 add l_sma92的判斷 #TQC-B40020
         IF l_rvu.rvu08='REG' AND (g_sma.sma91='Y' OR g_sma.sma92='Y') AND l_rvu.rvu00='1' THEN  #MOD-BB0034 #異動類別1.入庫
             CALL t720_gen_ap(l_rvu.rvu01)                      
         END IF                                                  #MOD-B30403 add
#     END IF                                                     #No.MOD-AC0333   #MOD-B80272 mark
  END IF   
   #No.FUN-A80026  --End
   #-----CHI-B40011---------
   IF NOT p_inTransaction THEN 
      SELECT pod05 INTO g_pod.pod05 
        FROM pod_file 
       WHERE pod00 = '0'
      IF p_argv3 = 'TAP' AND p_argv1 <> '2' AND g_pod.pod05 = 'Y' AND 
         l_rvu.rvuconf = 'Y' AND l_rvu.rvu20 = 'N' THEN
         CASE
            WHEN l_rvu.rvu00='1' #入庫
               IF t720sub_chkpoz011(l_rvu.rvu01) THEN
                  LET l_msg="apmp822 '",l_rvu.rvu01,"'"
                  CALL cl_cmdrun_wait(l_msg CLIPPED)
               END IF
            WHEN l_rvu.rvu00='3' #倉退
               IF g_azw.azw04='2' AND g_prog = 'apmt742' THEN
                  CALL t720sub_set_poz(l_rvu.rvu01)  
                  LET l_msg="apmp840 '",l_rvu.rvu01,"'"
                  CALL cl_cmdrun_wait(l_msg CLIPPED)
               ELSE
                  IF t720sub_chkpoz011(l_rvu.rvu01) THEN  
                     LET l_msg="apmp840 '",l_rvu.rvu01,"'"
                     CALL cl_cmdrun_wait(l_msg CLIPPED)
                  END IF
               END IF
         END CASE
         SELECT rvu20,rvu99 INTO l_rvu.rvu20,l_rvu.rvu99 FROM rvu_file
         WHERE rvu01 = l_rvu.rvu01
         DISPLAY BY NAME l_rvu.rvu20
         DISPLAY BY NAME l_rvu.rvu99
      END IF
   END IF
   #-----END CHI-B40011----- 
   #CALL s_padd_img_drop(l_img_table)   #FUN-C70087 #FUN-CC0095
   #CALL s_padd_imgg_drop(l_imgg_table) #FUN-C70087 #FUN-CC0095

   #DEV-D40015 add begin
   #失敗自動作廢barcode
   IF g_prog = 'apmt720' AND g_aza.aza131 = 'Y' THEN
      IF g_success='N' THEN
         CALL t720sub_barcode_z(l_rvu.rvu01,FALSE)
      END IF
   END IF
   #DEV-D40015 add end

  #DEV-D40015 mark str-------
  ##DEV-D30045--add--begin
  ##自動產生barcode
  #IF g_success='Y' AND g_prog = 'apmt720' AND g_aza.aza131 = 'Y' THEN
  #   CALL t720sub_barcode_gen(l_rvu.rvu01,'N')
  #END IF
  ##DEV-D30045--add--end
  #DEV-D40015 mark end-------

END FUNCTION
#FUN-A60009 add end ----------------------------
#-----CHI-B40011---------
#移到sub裡
FUNCTION t720sub_chkpoz011(l_rvu01)  #檢查是否為正拋入庫
 DEFINE l_poz011 LIKE poz_file.poz011
 DEFINE l_rvv36 LIKE rvv_file.rvv36
 DEFINE l_pmm901 LIKE pmm_file.pmm901
 DEFINE l_rvu01  LIKE rvu_file.rvu01

   DECLARE rvv36_curs CURSOR FOR
    SELECT rvv36 FROM rvv_file WHERE rvv01 = l_rvu01
   FOREACH rvv36_curs INTO l_rvv36
      SELECT pmm901 INTO l_pmm901 FROM pmm_file WHERE pmm01 = l_rvv36
      IF cl_null(l_pmm901) OR l_pmm901 = 'N' THEN RETURN 0 END IF
      SELECT poz011 INTO l_poz011 FROM poz_file,pmm_file
       WHERE pmm01 = l_rvv36 AND pmm904 = poz01
      IF SQLCA.sqlcode THEN LET l_poz011 = '' END IF
      IF cl_null(l_poz011) OR l_poz011 = '2' THEN
   RETURN 0
      END IF
   END FOREACH
   RETURN 1
END FUNCTION

FUNCTION t720sub_set_poz(l_rvu01)
DEFINE l_rvu01 LIKE rvu_file.rvu01
DEFINE l_poz   RECORD LIKE poz_file.*
DEFINE l_poy   RECORD LIKE poy_file.*
DEFINE l_pov1   RECORD LIKE pov_file.*
DEFINE l_pov2   RECORD LIKE pov_file.*
DEFINE l_occ   RECORD LIKE occ_file.*
DEFINE l_poz01 LIKE poz_file.poz01
DEFINE l_dbs  LIKE azp_file.azp03
DEFINE l_n,l_cnt LIKE type_file.num5
DEFINE l_pmc   RECORD LIKE pmc_file.*
DEFINE l_sql   STRING
DEFINE l_rvu24 LIKE rvu_file.rvu24
DEFINE l_rvu   RECORD LIKE rvu_file.*
 
    SELECT * INTO l_rvu.* FROM rvu_file WHERE rvu01 = l_rvu01
   
    LET l_sql = "SELECT * FROM pmc_file",
                " WHERE pmc01 = '",l_rvu.rvuplant,"' AND pmc05='1'",
                "   AND pmc903 = 'Y'"
    PREPARE pmc_cs1 FROM l_sql
    EXECUTE pmc_cs1 INTO l_pmc.*
 
    LET l_sql = "SELECT * FROM pov_file",
                " WHERE pov01 = '1' AND pov02 = '",l_rvu.rvuplant,"'"
    PREPARE pov_cs FROM l_sql
    EXECUTE pov_cs INTO l_pov1.*
 
    CALL t720sub_azp(l_rvu.rvu04) RETURNING l_dbs 
    LET l_dbs = s_dbstring(l_dbs CLIPPED)
    LET l_sql = "SELECT * FROM ",cl_get_target_table(l_rvu.rvu04,'pov_file'),  #FUN-A50102
                 " WHERE pov01 = '1'",
                 "   AND pov02 = '",l_rvu.rvu04 CLIPPED,"'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql              
     CALL cl_parse_qry_sql(l_sql,l_rvu.rvu04) RETURNING l_sql  
     PREPARE pov_pre FROM l_sql
     EXECUTE pov_pre INTO l_pov2.*
     
     LET l_sql = "SELECT * FROM ",cl_get_target_table(l_rvu.rvu04,'occ_file'), #FUN-A50102 
                " WHERE pmc01 = '",l_rvu.rvu04 CLIPPED,"'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql               
     CALL cl_parse_qry_sql(l_sql,l_rvu.rvu04) RETURNING l_sql  
     PREPARE occ_cs FROM l_sql
     EXECUTE occ_cs INTO l_occ.*
 
     DECLARE poz_cs CURSOR FOR SELECT poz01 FROM poz_file
                                WHERE poz00 = '2' 
                                  AND poz011='1' AND poz12 = 'Y'
     FOREACH poz_cs INTO l_poz01
       SELECT COUNT(poy02) INTO l_cnt FROM poy_file
        WHERE poy01 = l_poz01
       IF l_cnt=2 THEN
             SELECT COUNT(*) INTO l_n FROM poy_file a,poy_file b
              WHERE a.poy01 = l_poz01
                AND a.poy02 = (SELECT MIN(poy02) FROM poy_file WHERE poy01 = l_poz01)
                AND a.poy04 = l_rvu.rvuplant AND a.poy03 = l_rvu.rvuplant
                AND a.poy01 = b.poy01
                AND b.poy02 = (SELECT MAX(poy02) FROM poy_file WHERE poy01 = l_poz01)
                AND b.poy04 = l_rvu.rvu04 AND b.poy03 = l_rvu.rvu04
             IF l_n > 0 THEN
                LET l_rvu24 = l_poz01
                UPDATE rvu_file SET rvu24 = l_poz01 WHERE rvu01 = l_rvu.rvu01
                EXIT FOREACH
             END IF
       END IF
    END FOREACH
    IF NOT cl_null(l_rvu24) THEN
       RETURN
    END IF
    SELECT MAX(poz01)+1 INTO l_poz.poz01 FROM poz_file
    LET l_poz.poz01 = l_poz.poz01 USING '&&&&&&&&'
    LET l_poz.poz02 = l_rvu.rvuplant CLIPPED,">>",l_rvu.rvu04 CLIPPED
    LET l_poz.poz00 = '2'
    LET l_poz.poz011 = '1'
    LET l_poz.poz12 = 'Y'
    LET l_poz.poz20 = 'N'
    LET l_poz.poz09 = 'N'
    LET l_poz.poz10 = 'N'
    LET l_poz.poz13 = l_rvu.rvuplant
    LET l_poz.poz14 = l_rvu.rvu04
    LET l_poz.pozacti = 'Y'
    LET l_poz.pozuser = g_user
    LET l_poz.pozgrup = g_grup
    LET l_poz.pozmodu = ' '
    LET l_poz.pozdate = g_today
    LET l_poz.poz17 = 'Y'
    LET l_poz.poz18 = ' '
    LET l_poz.poz19 = 'N'
    LET l_poz.pozoriu = g_user      
    LET l_poz.pozorig = g_grup      
    INSERT INTO poz_file VALUES (l_poz.*)
     IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","poz_file",l_poz.poz01,"",SQLCA.sqlcode,"","",1)
        LET g_success = 'N'
        RETURN
     END IF
     #INSRET 第0站
     LET l_poy.poy01 = l_poz.poz01
     LET l_poy.poy02 = 0
     LET l_poy.poy03 = l_rvu.rvuplant
     LET l_poy.poy04 = l_rvu.rvuplant
     LET l_poy.poy05 = l_pmc.pmc22
     LET l_poy.poy06 = l_pmc.pmc17
     LET l_poy.poy07 = ' '
     LET l_poy.poy08 = ' '
     LET l_poy.poy09 = l_pmc.pmc47
     LET l_poy.poy10 = ' '
     LET l_poy.poy11 = l_pov1.pov04
     LET l_poy.poy12 = ' '
     LET l_poy.poy13 = l_pov1.pov07
     LET l_poy.poy14 = ' '
     LET l_poy.poy15 = l_poy.poy05
     LET l_poy.poy16 = ' '
     LET l_poy.poy17 = l_pov1.pov07
     LET l_poy.poy18 = ' '
     LET l_poy.poy19 = g_grup
     LET l_poy.poy20 = ' '
     LET l_poy.poy26 = ' '
     LET l_poy.poy27 = ' '
     LET l_poy.poy28 = ' '
     LET l_poy.poy29 = ' '
     SELECT pmc1913 INTO l_poy.poy30  FROM pmc_file
      WHERE pmc01 = l_pov1.pov27
     LET l_poy.poy31 = ' '
     LET l_poy.poy32 = ' '
     LET l_poy.poy33 = ' '
     LET l_poy.poy34 = ' '
     LET l_poy.poy35 = l_pov1.pov14
     LET l_poy.poy36 = ' '
     LET l_poy.poy37 = l_pov1.pov16
     LET l_poy.poy38 = l_pov1.pov17
     LET l_poy.poy39 = ' '
     LET l_poy.poy40 = l_pov1.pov19
     LET l_poy.poy41 = ' '
     LET l_poy.poy42 = l_pov1.pov21
     LET l_poy.poy43 = ' '
     LET l_poy.poy44 = l_pov1.pov23
     LET l_poy.poy45 = ' '
     LET l_poy.poy46 = l_pov1.pov25
     LET l_poy.poy47 = ' '
     INSERT INTO poy_file VALUES (l_poy.*)
     IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","poy_file",l_poy.poy01,"",SQLCA.sqlcode,"","",1)
        LET g_success = 'N'
        RETURN
     END IF
      #INSRET 第1站
     LET l_poy.poy01 = l_poz.poz01
     LET l_poy.poy02 = 1
     LET l_poy.poy03 = l_rvu.rvu04
     LET l_poy.poy04 = l_rvu.rvu04
     LET l_poy.poy05 = l_pmc.pmc22
     LET l_poy.poy06 = ''
     LET l_poy.poy07 = l_occ.occ45
     LET l_poy.poy08 = l_occ.occ41
     LET l_poy.poy09 = ''
     LET l_poy.poy10 = l_occ.occ43
     LET l_poy.poy11 = l_pov2.pov04
     LET l_poy.poy12 = ''
     LET l_poy.poy13 = ''
     LET l_poy.poy14 = ' '
     LET l_poy.poy15 = l_poy.poy05
     LET l_poy.poy16 = l_pov2.pov06
     LET l_poy.poy17 = ' '
     LET l_poy.poy18 = l_pov2.pov09
     LET l_poy.poy19 = ' '
     LET l_poy.poy20 = l_pov2.pov10
     LET l_poy.poy26 = l_pov2.pov11
     LET l_poy.poy27 = ''
     LET l_poy.poy28 = ''
     LET l_poy.poy29 = ''
     LET l_poy.poy30 = ' '
     LET l_poy.poy31 = l_occ.occ1705
     LET l_poy.poy32 = l_pov2.pov12
     LET l_sql = "SELECT tqk02 FROM ",cl_get_target_table(l_rvu.rvu04,'tqk_file'), #FUN-A50102
                 " WHERE tqk01 = ?"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql              
     CALL cl_parse_qry_sql(l_sql,l_rvu.rvu04) RETURNING l_sql  
     PREPARE tqk_pre  FROM l_sql
     EXECUTE tqk_pre INTO l_poy.poy33 USING l_occ.occ01
     LET l_poy.poy34 = l_pov2.pov13
     LET l_poy.poy35 = ' '
     LET l_poy.poy36 = l_pov2.pov15
     LET l_poy.poy37 = ' '
     LET l_poy.poy38 = ' '
     LET l_poy.poy39 = l_pov2.pov18
     LET l_poy.poy40 = ' '
     LET l_poy.poy41 = l_pov2.pov20
     LET l_poy.poy42 = ' '
     LET l_poy.poy43 = l_pov2.pov22
     LET l_poy.poy44 = ' '
     LET l_poy.poy45 = l_pov2.pov25
     LET l_poy.poy46 = ' '
     LET l_poy.poy47 = l_pov2.pov26
     INSERT INTO poy_file VALUES (l_poy.*)
     IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","poy_file",l_poy.poy01,"",SQLCA.sqlcode,"","",1)
        LET g_success = 'N'
        RETURN
     END IF
     UPDATE rvu_file SET rvu24 = l_poz.poz01 WHERE rvu01 = l_rvu.rvu01
     IF SQLCA.sqlcode THEN
        CALL cl_err3("upd","rvu_file",l_rvu.rvu01,"",SQLCA.sqlcode,"","",1)
        LET g_success = 'N'
        RETURN
     END IF
END FUNCTION
#-----END CHI-B40011-----

#-----CHI-B40023---------
FUNCTION t720_insimb(l_rvv31,l_cost)
  DEFINE  l_imb          RECORD LIKE imb_file.*,
          l_rvv31        LIKE rvv_file.rvv31,
          l_cost         LIKE imb_file.imb118

    INITIALIZE l_imb.* LIKE imb_file.*
    LET l_imb.imb01=l_rvv31
    LET l_imb.imb02='0'  LET l_imb.imb111=0
    LET l_imb.imb112=0   LET l_imb.imb1131=0
    LET l_imb.imb1132=0  LET l_imb.imb114=0
    LET l_imb.imb115=0   LET l_imb.imb116=0
    LET l_imb.imb1151=0
    LET l_imb.imb1171=0  LET l_imb.imb1172=0
    LET l_imb.imb118=l_cost   LET l_imb.imb119=0
    LET l_imb.imb129=0   LET l_imb.imb121=0
    LET l_imb.imb122=0   LET l_imb.imb1231=0
    LET l_imb.imb1232=0  LET l_imb.imb124=0
    LET l_imb.imb125=0   LET l_imb.imb126=0
    LET l_imb.imb1251=0
    LET l_imb.imb1271=0  LET l_imb.imb1272=0
    LET l_imb.imb120=0  LET l_imb.imb130=0
    LET l_imb.imb211=0   LET l_imb.imb212=0
    LET l_imb.imb2131=0  LET l_imb.imb2132=0
    LET l_imb.imb214=0   LET l_imb.imb215=0
    LET l_imb.imb2151=0  
    LET l_imb.imb216=0   LET l_imb.imb2171=0
    LET l_imb.imb2172=0  LET l_imb.imb219=0
    LET l_imb.imb218=0   LET l_imb.imb221=0
    LET l_imb.imb222=0   LET l_imb.imb2231=0
    LET l_imb.imb2232=0  LET l_imb.imb224=0
    LET l_imb.imb225=0   LET l_imb.imb226=0
    LET l_imb.imb2251=0
    LET l_imb.imb2271=0  LET l_imb.imb2272=0
    LET l_imb.imb229=0   LET l_imb.imb311=0
    LET l_imb.imb220=0  LET l_imb.imb230=0
    LET l_imb.imb312=0   LET l_imb.imb3131=0
    LET l_imb.imb3132=0  LET l_imb.imb314=0
    LET l_imb.imb315=0   LET l_imb.imb316=0
    LET l_imb.imb3151=0
    LET l_imb.imb3171=0  LET l_imb.imb3172=0
    LET l_imb.imb319=0   LET l_imb.imb318=0
    LET l_imb.imb321=0   LET l_imb.imb322=0
    LET l_imb.imb3231=0  LET l_imb.imb3232=0
    LET l_imb.imb324=0   LET l_imb.imb325=0
    LET l_imb.imb3251=0
    LET l_imb.imb326=0   LET l_imb.imb3271=0
    LET l_imb.imb3272=0  LET l_imb.imb329=0
    LET l_imb.imb320=0  LET l_imb.imb330=0
   #MOD-B40219---add---start---
    LET l_imb.imbacti ='Y'                   #有效的資料
    LET l_imb.imbuser = g_user
    LET l_imb.imbgrup = g_grup               #使用者所屬群
    LET l_imb.imbdate = g_today
   #MOD-B40219---add---end---
    INSERT INTO imb_file VALUES(l_imb.*)     
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
       CALL cl_err3("ins","imb_file",l_rvv31,"",SQLCA.sqlcode,"","",1) 
       LET g_success = 'N'
    END IF
END FUNCTION
#-----END CHI-B40023-----
#TQC-C30193 --START--
FUNCTION t720_tky_sfb09(l_rvv04)
DEFINE l_rvv18     LIKE rvv_file.rvv18
DEFINE l_rvv04     LIKE rvv_file.rvv36
DEFINE l_rvb       RECORD LIKE rvb_file.*
DEFINE l_rvbi      RECORD LIKE rvbi_file.*
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_tky_cnt   LIKE type_file.num5
DEFINE l_ecdicd01  LIKE ecd_file.ecdicd01
DEFINE l_sfa161    LIKE sfa_file.sfa161

    LET l_tky_cnt = 0
    DECLARE t720_tky_sfb09_1 CURSOR FOR
      SELECT * FROM rvb_file,rvbi_file
       WHERE rvb01 = rvbi01 AND rvb02 = rvbi02  
        AND rvb01 = l_rvv04 

    FOREACH t720_tky_sfb09_1 INTO l_rvb.*,l_rvbi.*
       SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file
        WHERE ecd01 = l_rvbi.rvbiicd03 
       IF l_ecdicd01 = '2' THEN  #CP
          SELECT sfa161 INTO l_sfa161 FROM sfa_file        
           WHERE sfa01 = l_rvb.rvb34  
          IF cl_null(l_sfa161) THEN LET l_sfa161 = 1 END IF           
          LET l_rvbi.rvbiicd06 = l_rvbi.rvbiicd06 / l_sfa161
          LET l_rvbi.rvbiicd07 = l_rvbi.rvbiicd07 / l_sfa161       
       END IF
       LET l_tky_cnt = l_tky_cnt + l_rvbi.rvbiicd06 + l_rvbi.rvbiicd07
    END FOREACH   
    RETURN l_tky_cnt     
END FUNCTION 
#TQC-C30193 --END--


#TQC-C30225 add begin
FUNCTION t720sub_rvv38(p_rvv36,p_rvv38,p_rvv38t,p_rvu04,p_rvu01)  
  DEFINE    l_gec07   LIKE gec_file.gec07,     #含稅否
            l_gec05   LIKE gec_file.gec05,     
            l_pmm43   LIKE pmm_file.pmm43,     #稅率
            p_rvv36   LIKE rvv_file.rvv36,     #採購單
            p_rvv38   LIKE rvv_file.rvv38,     #未稅單價
            p_rvv38t  LIKE rvv_file.rvv38t,    #含稅單價
            p_rvu04   LIKE rvu_file.rvu04,
            p_rvu01   LIKE rvu_file.rvu01     
  DEFINE l_rva115     LIKE rva_file.rva115
  DEFINE l_rva00      LIKE rva_file.rva00
  DEFINE l_gec04      LIKE gec_file.gec04
  DEFINE l_rvu02      LIKE rvu_file.rvu02
  DEFINE l_rvu12      LIKE rvu_file.rvu12
  
   SELECT rvu02,rvu12 INTO l_rvu02,l_rvu12 FROM rvu_file WHERE rvu01 = p_rvu01
   IF g_azw.azw04 = '2' AND g_prog='apmt742' THEN
         SELECT gec04 INTO l_gec04 FROM gec_file,pmc_file
          WHERE gec01 = pmc47 AND pmc01 = p_rvu04
            AND gec011 = '1'  #TQC-D80017
         LET p_rvv38t = p_rvv38 *(1 + l_gec04/100)
   ELSE
     IF NOT cl_null(l_rvu02) THEN  
        SELECT rva00,rva115,rva116 INTO l_rva00,l_rva115,l_pmm43 
          FROM rva_file WHERE rva01 = l_rvu02   
        IF l_rva00 = '2' THEN
           SELECT gec07,gec05 INTO l_gec07,l_gec05 FROM gec_file WHERE gec01 = l_rva115   
        ELSE
           IF cl_null(p_rvv36) THEN
              LET l_pmm43 = l_rvu12
           ELSE
              SELECT gec07,gec05,pmm43 INTO l_gec07,l_gec05,l_pmm43 FROM gec_file,pmm_file
               WHERE gec01 = pmm21
                 AND pmm01 = p_rvv36
                 AND gec011 = '1' 
           END IF   
        END IF
     ELSE
         IF cl_null(p_rvv36) THEN
            LET l_pmm43 = l_rvu12
         ELSE
            SELECT gec07,gec05,pmm43 INTO l_gec07,l_gec05,l_pmm43 FROM gec_file,pmm_file
              WHERE gec01 = pmm21
                AND pmm01 = p_rvv36
                AND gec011 = '1'
          END IF   
     END IF
   END IF  
   IF SQLCA.SQLCODE = 100 THEN
      CALL cl_err('','mfg3192',0)
      SELECT gec07,gec05,gec04 INTO l_gec07,l_gec05,l_pmm43 FROM gec_file,pmc_file   
       WHERE gec01 = pmc47
         AND pmc01 = p_rvu04 
         AND gec011='1'  #進項
      IF cl_null(l_pmm43) THEN LET l_pmm43=0 END IF
 # END IF  #TQC-D80008 mark
      IF l_gec07='Y' THEN 
        # IF l_gec05 = 'T' THEN
         IF l_gec05  MATCHES '[AT]' THEN  #FUN-D10128
            LET p_rvv38 = p_rvv38t * ( 1 - l_pmm43/100)
            LET p_rvv38 = cl_digcut(p_rvv38 , t_azi03)  
         ELSE
            LET p_rvv38 = p_rvv38t / ( 1 + l_pmm43/100)
            LET p_rvv38 = cl_digcut(p_rvv38 , t_azi03)  
         END IF
      ELSE
         LET p_rvv38t = p_rvv38 * ( 1 + l_pmm43/100)
         LET p_rvv38t = cl_digcut( p_rvv38t , t_azi03)  
      END IF      
   END IF  #TQC-D80008 add
   RETURN p_rvv38,p_rvv38t
END FUNCTION
#TQC-C30225 add end

#No:DEV-D30026--add--begin
#生成条码记录--非条码异动

FUNCTION t720sub_barcode(p_rvu01,p_type,p_argv3)
   DEFINE p_rvu01    LIKE  rvu_file.rvu01
   DEFINE p_type     LIKE  type_file.num5    # +1-->加  0-->不异动 -1-->减
   DEFINE p_argv3    LIKE rvu_file.rvu08
   DEFINE l_rvv      RECORD LIKE rvv_file.*
   DEFINE l_imgb05   LIKE imgb_file.imgb05
   DEFINE l_ibb01    LIKE ibb_file.ibb01
   DEFINE l_sql      STRING
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_pdacnt   LIKE type_file.num5  
   #DEV-D40015--add--begin
   DEFINE l_ima918   LIKE ima_file.ima918
   DEFINE l_ima921   LIKE ima_file.ima921
   DEFINE l_ima932   LIKE ima_file.ima932
   DEFINE l_ibb07    LIKE ibb_file.ibb01
   #DEV-D40015--add--end

   #DEV-D40015--mark--begin
   #IF p_argv3 ='TAP' THEN   #避免apmt740
   #   RETURN
   #END IF
   #DEV-D40015--mark--end

   LET l_pdacnt = 0
   SELECT COUNT(*)
     INTO l_pdacnt           #l_pdacnt大於0表示掃描記錄檔已有此入庫單資訊
     FROM tlfb_file
    #DEV-D40015--add--begin
    #WHERE tlfb09 = p_rvu01   #目的單號=入庫單號
     WHERE tlfb07 = p_rvu01   #目的單號=入庫單號
    #DEV-D40015--add--end

   LET l_sql = "SELECT rvv_file.* ",
               "      ,ima932,ima918,ima921",  #DEV-D40015--add
               "  FROM rvv_file,ima_file ",
               " WHERE rvv31 = ima01 ",
               "   AND rvv01 = '",p_rvu01,"' "
              #"   AND ima931 = 'Y' " #不需限制在包號管理否='Y'
              ,"   AND ima932 IN('E','F','G')" #DEV-D40015--add
   #DEV-D40015--add--begin
   #CASE
   #   WHEN p_argv3 != 'SUB' AND p_argv3 != 'TAP'     #apmt720
   #      LET l_sql = l_sql ," AND ima932 = 'F'"
   #   WHEN p_argv3 = 'SUB'                           #apmt730
   #      LET l_sql = l_sql ," AND ima932 = 'G'"
   #   WHEN p_argv3 = 'TAP'                           #apmt740
   #END CASE
   #DEV-D40015--add--end

   PREPARE barcode_prep FROM l_sql
   DECLARE barcode_cs CURSOR FOR barcode_prep
   FOREACH barcode_cs INTO l_rvv.*
                          ,l_ima932,l_ima918,l_ima921 #DEV-D40015--add
      IF STATUS THEN
         CALL s_errmsg('','','foreach barcode_cs:',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

      #DEV-D40015--add--begin
      #如果批號OR序號有打勾,則是透過掃描條碼產生tlfb_file
      IF l_ima932 MATCHES '[FG]' AND
         (l_ima918 = 'Y' OR l_ima921 = 'Y') THEN
         CONTINUE FOREACH
      END IF
      #DEV-D40015--add--end

      #DEV-D40015--mark--begin
      #LET l_sql = "SELECT ibb01 ",
      #            "  FROM ibb_file ",
      #            " WHERE ibb03 = '",l_rvv.rvv36,"' ",
      #            "   AND ibb04 = '",l_rvv.rvv37,"' "
      #CASE
      #   WHEN p_argv3 != 'SUB' AND p_argv3 != 'TAP'     #apmt720
      #      LET l_sql = l_sql ," AND ibb02 = 'F'"
      #   WHEN p_argv3 = 'SUB'                           #apmt730
      #      LET l_sql = l_sql ," AND ibb02 = 'G'"
      #   WHEN p_argv3 = 'TAP'                           #apmt740
      #END CASE
      #DEV-D40015--mark--end

      #DEV-D40015--add--begin
      LET l_sql = "SELECT ibb01,ibb07 ",
                  "  FROM ibb_file",
                  " WHERE ibb11 = 'Y'"
      CASE
         WHEN l_ima932 = 'E' #採購入庫單
            LET l_sql = l_sql,"   AND ibb03 = '",l_rvv.rvv01,"'",
                              "   AND ibb04 =  ",l_rvv.rvv02
         WHEN l_ima932 = 'F' #採購單
            LET l_sql = l_sql,"   AND ibb03 = '",l_rvv.rvv36,"'",
                              "   AND ibb04 =  ",l_rvv.rvv37
         WHEN l_ima932 = 'G' #委外採購單
            LET l_sql = l_sql,"   AND ibb03 = '",l_rvv.rvv36,"'",
                              "   AND ibb04 =  ",l_rvv.rvv37
      END CASE
      #DEV-D40015--add--end

      PREPARE barcode_prep2 FROM l_sql
      DECLARE barcode_cs2 CURSOR FOR barcode_prep2
  
      FOREACH barcode_cs2 INTO l_ibb01
                              ,l_ibb07 #DEV-D40015
         IF STATUS THEN
            CALL s_errmsg('','','foreach barcode_cs:',STATUS,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF

         INITIALIZE g_tlfb.* TO NULL
         LET g_tlfb.tlfb01 = l_ibb01
         LET g_tlfb.tlfb02 = l_rvv.rvv32
         LET g_tlfb.tlfb03 = l_rvv.rvv33
         LET g_tlfb.tlfb04 = l_rvv.rvv34
         #LET g_tlfb.tlfb05 = l_rvv.rvv17 #DEV-D40015--mark
         #DEV-D40015--add--begin
         IF l_ibb01[1,1] MATCHES '[6Z]' THEN
            LET g_tlfb.tlfb05 = l_ibb07
         ELSE
            LET g_tlfb.tlfb05 = l_rvv.rvv17
         END IF
         #DEV-D40015--add--end
         LET g_tlfb.tlfb06 = p_type
         #DEV-D40015--mark--begin
         #LET g_tlfb.tlfb07 = l_rvv.rvv04  #來源單號
         #LET g_tlfb.tlfb08 = l_rvv.rvv05  #來源項次
         #LET g_tlfb.tlfb09 = l_rvv.rvv01
         #LET g_tlfb.tlfb10 = l_rvv.rvv02
         #DEV-D40015--mark--end
         #DEV-D40015--add--begin
         LET g_tlfb.tlfb07 = l_rvv.rvv01  #來源單號
         LET g_tlfb.tlfb08 = l_rvv.rvv02  #來源項次
         #DEV-D40015--add--end
         LET g_tlfb.tlfb11 = 'apmt720'

         IF l_pdacnt = 0 THEN                
            CALL s_tlfb('','','','','')
         END IF                            

         IF g_success = 'Y' THEN
            #DEV-D40015--mark--begin
            #LET l_cnt = 0
            #SELECT COUNT(*) INTO l_cnt FROM imgb_file
            # WHERE imgb01 = l_ibb01
            #   AND imgb02 = l_rvv.rvv32
            #   AND imgb03 = l_rvv.rvv33
            #   AND imgb04 = l_rvv.rvv34
            #IF l_cnt = 0 THEN
            #    CALL s_ins_imgb(l_ibb01,l_rvv.rvv32,
            #      l_rvv.rvv33,l_rvv.rvv34,0,'','')
            #END IF
            #
            #IF g_success = 'Y' THEN
            #   LET l_imgb05 = 0
            #   SELECT imgb05 INTO l_imgb05 FROM imgb_file
            #    WHERE imgb01 = l_ibb01
            #      AND imgb02 = l_rvv.rvv32
            #      AND imgb03 = l_rvv.rvv33
            #      AND imgb04 = l_rvv.rvv34
            #   IF cl_null(l_imgb05) THEN LET l_imgb05 = 0 END IF
            #   IF p_type = -1 AND l_imgb05 < l_rvv.rvv17 THEN
            #      LET g_success = 'N'
            #      CALL cl_err(l_rvv.rvv31,'cpm-013',1)
            #      EXIT FOREACH
            #   ELSE
            #      CALL s_up_imgb(l_ibb01,l_rvv.rvv32,
            #                     l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv17,1,'')
            #   END IF
            #END IF
            #DEV-D40015--mark--end

            #DEV-D40015--add--begin
            #寫入imgb_file
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM imgb_file
             WHERE imgb01 = g_tlfb.tlfb01
               AND imgb02 = g_tlfb.tlfb02
               AND imgb03 = g_tlfb.tlfb03
               AND imgb04 = g_tlfb.tlfb04
            IF l_cnt = 0 THEN #没有imgb_file，新增imgb_file
               CALL s_ins_imgb(g_tlfb.tlfb01,
                               g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,
                               0,'','')
            END IF

            IF g_success = 'Y' THEN
               CALL s_up_imgb(g_tlfb.tlfb01,
                              g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,
                              g_tlfb.tlfb05,g_tlfb.tlfb06,'')
            END IF
            #DEV-D40015--add--end
         END IF

      END FOREACH
   END FOREACH

END FUNCTION
#No:DEV-D30026--add--end   


#DEV-D30045--add--begin
FUNCTION t720sub_barcode_gen(p_rvu01,p_ask)
   DEFINE p_rvu01   LIKE rvu_file.rvu01
   DEFINE p_ask     LIKE type_file.chr1
   DEFINE l_rvu     RECORD LIKE rvu_file.*

   IF cl_null(p_rvu01) THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF

   SELECT * INTO l_rvu.* FROM rvu_file WHERE rvu01 = p_rvu01

   #檢查是否符合產生時機點
   IF NOT s_gen_barcode_chktype('E',l_rvu.rvu01,'','') THEN
      RETURN
   END IF

   IF p_ask = 'Y' THEN    #DEV-D40015 add
   IF l_rvu.rvuconf = 'N' THEN
      CALL cl_err('','sfb-999',0)
      LET g_success = 'N'
      RETURN
   END IF
   END IF                   #DEV-D40015 add

   IF l_rvu.rvuconf = 'X' THEN
      CALL cl_err('','sfb-998',0)
      LET g_success = 'N'
      RETURN
   END IF

   IF NOT s_tlfb_chk(l_rvu.rvu01) THEN
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
   CALL t720sub_lock_cl()

   OPEN t720sub_cl USING l_rvu.rvu01
   IF STATUS THEN
      CALL cl_err("OPEN t720sub_cl:", STATUS, 1)
      LET g_success = 'N'
      CLOSE t720sub_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t720sub_cl INTO l_rvu.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_rvu.rvu01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      LET g_success = 'N'
      CLOSE t720sub_cl
      ROLLBACK WORK
      RETURN
   END IF

   #DEV-D30043--mark--begin
   #IF NOT s_diy_barcode(l_rvu.rvu01,'','','E') THEN
   #   LET g_success = 'N'
   #END IF
   #
   #IF g_success = 'Y' THEN
   #   CALL s_gen_barcode2('E',l_rvu.rvu01,'','')
   #END IF
   #DEV-D30043--mark--end

   #DEV-D30043--add--begin
   IF g_success = 'Y' THEN
      CALL s_gen_barcode2('E',l_rvu.rvu01,'','')
   END IF

   IF g_success = 'Y' THEN
      IF NOT s_diy_barcode(l_rvu.rvu01,'','','E') THEN
         LET g_success = 'N'
      END IF
   END IF
   #DEV-D30043--add--end

  #DEV-D40015 add str-------
   IF g_success = 'Y' THEN
      CALL t720sub_chk_ima(l_rvu.rvu01,'I')
   END IF
  #DEV-D40015 add end-------

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

FUNCTION t720sub_barcode_z(p_rvu01,p_inTransaction) #DEV-D40015--add p_inTransaction
   DEFINE p_rvu01   LIKE rvu_file.rvu01
   DEFINE p_inTransaction LIKE type_file.num5       #DEV-D40015--add
   DEFINE l_rvu     RECORD LIKE rvu_file.*
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

   IF cl_null(p_rvu01) THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF
   SELECT * INTO l_rvu.* FROM rvu_file WHERE rvu01 =p_rvu01 

   #檢查是否符合產生時機點
   IF NOT s_gen_barcode_chktype('E',l_rvu.rvu01,'','') THEN
      RETURN
   END IF

   IF l_rvu.rvuconf = 'X' THEN
      CALL cl_err(' ','9024',0)
      LET g_success = 'N'
      RETURN
   END IF

   IF NOT s_tlfb_chk2(l_rvu.rvu01) THEN
      LET g_success = 'N'
      RETURN
   END IF

   LET g_success = 'Y'
   #DEV-D40015--add--begin
   #BEGIN WORK
   IF NOT p_inTransaction THEN
      BEGIN WORK
   END IF
   #DEV-D40015--add--end
   CALL t720sub_lock_cl()

   OPEN t720sub_cl USING l_rvu.rvu01
   IF STATUS THEN
      CALL cl_err("OPEN t720sub_cl:", STATUS, 1)
      LET g_success = 'N'
      CLOSE t720sub_cl
      #DEV-D40015--add--begin
      #ROLLBACK WORK
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      #DEV-D40015--add--end
      RETURN
   END IF
   FETCH t720sub_cl INTO l_rvu.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_rvu.rvu01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      LET g_success = 'N'
      CLOSE t720sub_cl
      #DEV-D40015--add--begin
      #ROLLBACK WORK
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      #DEV-D40015--add--end
      RETURN
   END IF

   #DEV-D40015--add--begin
   #先刪除,再作廢條碼
   IF g_success='Y' THEN
      CALL t720sub_chk_ima(l_rvu.rvu01,'D')
   END IF
   #DEV-D40015--add--end

   IF g_success='Y' THEN
      CALL s_barcode_x2('E',l_rvu.rvu01,'','')
   END IF

   IF g_success='Y' THEN
      #DEV-D40015--add--begin
      #COMMIT WORK
      IF NOT p_inTransaction THEN
         COMMIT WORK
      END IF
      #DEV-D40015--add--end
      CALL cl_msgany(0,0,'aba-178')
   ELSE
      #DEV-D40015--add--begin
      #ROLLBACK WORK
      IF NOT p_inTransaction THEN
         ROLLBACK WORK
      END IF
      #DEV-D40015--add--end
      CALL cl_msgany(0,0,'aba-179')
   END IF
END FUNCTION
#DEV-D30045--add--end

#DEV-D40015 add str--------
FUNCTION t720sub_chk_ima(p_rvv01,p_type)
   DEFINE p_rvv01    LIKE   rva_file.rva01
   DEFINE p_type     LIKE   rva_file.rva01  #I:新增 D:刪除
   DEFINE l_sql      STRING
   DEFINE l_ima01    LIKE   ima_file.ima01

   LET l_sql = " SELECT DISTINCT b.ima01 ",
               "   FROM rvv_file a         ",
               "  INNER JOIN ima_file b ON a.rvv31 = b.ima01 ",
               "                       AND b.ima930= 'Y' ",
               "                       AND b.ima932= 'E'",
               "  WHERE a.rvv01 = '",p_rvv01,"'"

   PREPARE t720_chkima_pre FROM l_sql
   DECLARE t720_chkima_cur CURSOR FOR t720_chkima_pre

   FOREACH t720_chkima_cur INTO l_ima01
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach t720_chkima_cur:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF

      CASE
         WHEN p_type = 'I'
            CALL s_ibb_ins_rvbs(g_prog,p_rvv01,l_ima01)
         WHEN p_type = 'D'
            CALL s_ibb_del_rvbs(g_prog,p_rvv01,l_ima01)
      END CASE
   END FOREACH
END FUNCTION
#DEV-D40015 add end--------

#DEV-D40020---add----str---
#==>收貨時有做掃瞄,則入庫不需再掃瞄
#==>回傳收貨時是否有掃瞄記錄,若有==>回傳'Y';無==>回傳'N'
FUNCTION t720_chk_scan_in_t110(p_rvu02)
   DEFINE l_ibj_cnt   LIKE type_file.num5   
   DEFINE p_rvu02     LIKE rvu_file.rvu02 #收貨單號

   LET l_ibj_cnt = 0 
   SELECT COUNT(*) INTO l_ibj_cnt
     FROM ibj_file
    WHERE ibj01 = '1'     #收貨
      AND ibj06 = p_rvu02 #來源單號
   IF NOT cl_null(l_ibj_cnt) AND l_ibj_cnt >=1 THEN
       RETURN 'Y' 
   ELSE
       RETURN 'N'
   END IF
END FUNCTION
#DEV-D40020---add----str---

#DEV-D40020---add----str---
#產生採購入庫掃瞄記錄tlfb_file及異動條碼庫存imgb_file
FUNCTION t720sub_barcode2(p_rvu01,p_type,p_argv3)
   DEFINE p_rvu01    LIKE  rvu_file.rvu01
   DEFINE p_type     LIKE  type_file.num5    # +1-->加  0-->不异动 -1-->减
   DEFINE p_argv3    LIKE rvu_file.rvu08
   DEFINE l_rvv      RECORD LIKE rvv_file.*
   DEFINE l_imgb05   LIKE imgb_file.imgb05
   DEFINE l_ibb01    LIKE ibb_file.ibb01
   DEFINE l_sql      STRING
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_pdacnt   LIKE type_file.num5  
   DEFINE l_ima918   LIKE ima_file.ima918
   DEFINE l_ima921   LIKE ima_file.ima921
   DEFINE l_ima932   LIKE ima_file.ima932
   DEFINE l_ibb07    LIKE ibb_file.ibb01
   DEFINE l_ibd10    LIKE ibd_file.ibd10
   DEFINE l_qcs_cnt  LIKE type_file.num5
   DEFINE l_ibj_cnt  LIKE type_file.num5
   DEFINE l_tlfb15   LIKE tlfb_file.tlfb15

   LET l_pdacnt = 0
   SELECT COUNT(*)
     INTO l_pdacnt           #l_pdacnt大於0表示掃描記錄檔已有此入庫單資訊
     FROM tlfb_file
    WHERE tlfb07 = p_rvu01   #來源單號=入庫單號

   LET l_sql = "SELECT rvv_file.* ",
               "      ,ima932,ima918,ima921 ",  
               "  FROM rvv_file,ima_file ",
               " WHERE rvv31 = ima01 ",
               "   AND rvv01 = '",p_rvu01,"'",           #條碼產生時機點(ima932)
               "   AND ima932 IN ('F','G','K','L','E') " #F:採購單(apmt540)
                                                         #G:委外採購單(apmt590)
                                                         #K:採購收貨(apmt110)
                                                         #L:IQC(aqct110)
                                                         #E:採購入庫(apmt720)

   PREPARE barcode_p2 FROM l_sql
   DECLARE barcode_cs21 CURSOR FOR barcode_p2
   FOREACH barcode_cs21 INTO l_rvv.*,l_ima932,l_ima918,l_ima921 
      IF STATUS THEN
         CALL s_errmsg('','','foreach barcode_cs21:',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

      #如果批號OR序號有打勾,則是透過掃描條碼產生tlfb_file
      IF l_ima932 MATCHES '[FGKL]' AND             #條碼產生時機點
         (l_ima918 = 'Y' OR l_ima921 = 'Y') THEN
          #****************************************************#
          #產生採購入庫tlfb_file的說明如下:
          #用收貨單+項次==>反查是否有IQC單
          #IF 有IQC單 THEN
          #    IF IQC無掃瞄記錄 THEN
          #        不產生採購入庫tlfb_file (因為採購入庫掃瞄)
          #    ELSE
          #        IF IQC自動產生入庫單(ibd10='Y') THEN
          #              產生採購入庫tlfb_file
          #        ELSE
          #            不產生採購入庫tlfb_file
          #        END IF
          #    END IF
          #ELSE
          #    F/G ==>  產生採購入庫tlfb_file
          #    K   ==>不產生採購入庫tlfb_file
          #END IF
          #****************************************************#
          LET l_qcs_cnt = 0
          SELECT COUNT(*) 
            INTO l_qcs_cnt
            FROM qcs_file
           WHERE qcs01 = l_rvv.rvv04  #收貨單號
             AND qcs02 = l_rvv.rvv05  #收貨項次
          IF NOT cl_null(l_qcs_cnt) AND l_qcs_cnt >=1 THEN
              #=>有IQC單
              LET l_ibj_cnt = 0
              SELECT COUNT(*)
                INTO l_ibj_cnt
                FROM ibj_file
               WHERE ibj01 = '4'            #掃瞄類型'4:IQC'
                 AND ibj06 = l_rvv.rvv04    #來源單號
                 AND ibj07 = l_rvv.rvv05    #來源項次
              IF cl_null(l_ibj_cnt) OR l_ibj_cnt = 0 THEN
                  #IQC無掃瞄記錄
                  CONTINUE FOREACH
              ELSE
                  SELECT ibd10 INTO l_ibd10 
                    FROM ibd_file 
                   WHERE ibd01 = '0'
                  #IQC有掃瞄記錄
                  IF cl_null(l_ibd10) OR l_ibd10 = 'N' THEN #ibd10:IQC自動產生入庫單否
                      CONTINUE FOREACH
                  END IF
              END IF
          ELSE
              #=>無IQC單
              IF l_ima932 = 'K' THEN #條碼產生時機點
                  CONTINUE FOREACH
              END IF
          END IF
      END IF


      LET l_sql = "SELECT ibb01,ibb07 ",
                  "  FROM ibb_file",
                  " WHERE ibb11 = 'Y'"
      CASE
         WHEN l_ima932 = 'F' #採購單
            LET l_sql = l_sql,"   AND ibb03 = '",l_rvv.rvv36,"'", #採購單號
                              "   AND ibb04 =  ",l_rvv.rvv37      #採購項次
         WHEN l_ima932 = 'G' #委外採購單
            LET l_sql = l_sql,"   AND ibb03 = '",l_rvv.rvv36,"'", #採購單號
                              "   AND ibb04 =  ",l_rvv.rvv37      #採購項次
         WHEN l_ima932 = 'K' #K:採購收貨(apmt110)
            LET l_sql = l_sql,"   AND ibb03 = '",l_rvv.rvv04,"'", #收貨單號
                              "   AND ibb04 =  ",l_rvv.rvv05      #收貨項次
         WHEN l_ima932 = 'E' #採購入庫單
            LET l_sql = l_sql,"   AND ibb03 = '",l_rvv.rvv01,"'", #入庫單號
                              "   AND ibb04 =  ",l_rvv.rvv02      #入庫項次
         WHEN l_ima932 = 'L' #L:IQC(aqct110)
            LET l_sql = l_sql,"   AND ibb03 = '",l_rvv.rvv04,"'", #QC單號
                              "   AND ibb04 =  ",l_rvv.rvv05,"'", #QC項次
                              "   AND ibb13 =  ",l_rvv.rvv45,"'"  #分批順序
      END CASE

      PREPARE barcode_prep22 FROM l_sql
      DECLARE barcode_cs22 CURSOR FOR barcode_prep22
  
      LET l_tlfb15 = ''
      FOREACH barcode_cs22 INTO l_ibb01 ,l_ibb07 
         IF STATUS THEN
            CALL s_errmsg('','','foreach barcode_cs22:',STATUS,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF

         INITIALIZE g_tlfb.* TO NULL
         LET g_tlfb.tlfb01 = l_ibb01
         LET g_tlfb.tlfb02 = l_rvv.rvv32
         LET g_tlfb.tlfb03 = l_rvv.rvv33
         LET g_tlfb.tlfb04 = l_rvv.rvv34
         IF l_ibb01[1,1] MATCHES '[6Z]' THEN
            LET g_tlfb.tlfb05 = l_ibb07
         ELSE
            LET g_tlfb.tlfb05 = l_rvv.rvv17
         END IF
         LET g_tlfb.tlfb06 = p_type
         LET g_tlfb.tlfb07 = l_rvv.rvv01  #來源單號
         LET g_tlfb.tlfb08 = l_rvv.rvv02  #來源項次
         LET g_tlfb.tlfb11 = 'apmt720'
         LET g_tlfb.tlfb15 = l_tlfb15     #時間(時:分:秒.毫秒)

         IF l_pdacnt = 0 THEN                
            CALL s_tlfb('','','','','')
         END IF                            

         IF g_success = 'Y' THEN
            #寫入imgb_file
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM imgb_file
             WHERE imgb01 = g_tlfb.tlfb01
               AND imgb02 = g_tlfb.tlfb02
               AND imgb03 = g_tlfb.tlfb03
               AND imgb04 = g_tlfb.tlfb04
            IF l_cnt = 0 THEN #没有imgb_file，新增imgb_file
               CALL s_ins_imgb(g_tlfb.tlfb01,
                               g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,
                               0,'','')
            END IF

            IF g_success = 'Y' THEN
               CALL s_up_imgb(g_tlfb.tlfb01,
                              g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,
                              g_tlfb.tlfb05,g_tlfb.tlfb06,'')
            END IF
         END IF
         LET l_tlfb15 = g_tlfb.tlfb15
      END FOREACH
   END FOREACH
END FUNCTION
#DEV-D40020---add----end---

#str----add by guanyao160523
FUNCTION t720_ins(p_tc_sfp01)
DEFINE l_tc_sfs    RECORD LIKE tc_sfs_file.*
DEFINE l_ina       RECORD LIKE ina_file.*
DEFINE l_inb       RECORD LIKE inb_file.*
DEFINE li_result   LIKE type_file.num5
DEFINE p_tc_sfp01  LIKE tc_sfp_file.tc_sfp01
DEFINE l_slip      LIKE smy_file.smyslip
DEFINE l_i         LIKE type_file.num5
DEFINE l_to_prog   LIKE type_file.chr10
DEFINE l_x         LIKE type_file.num5

   LET g_success = 'Y'
   SELECT smyslip INTO l_slip FROM smy_file WHERE smysys = 'aim' AND smykind = '1'
   IF cl_null(l_slip) THEN 
      CALL cl_err('','cpm-008',0)
      LET g_success = 'N'
      RETURN 
   END IF 
   CALL s_check_no("aim",l_slip,'','1',"ina_file","ina01","")
      RETURNING li_result,l_ina.ina01
   IF (NOT li_result) THEN
      CALL cl_err('','cpm-009',0)
      LET g_success = 'N'
      RETURN 
   END IF
   LET l_ina.ina02  =g_today
   LET l_ina.ina03  =g_today
   CALL s_auto_assign_no("aim",l_ina.ina01,l_ina.ina03,'1',"ina_file","ina01","","","")
     RETURNING li_result,l_ina.ina01
   IF (NOT li_result) THEN
      CALL cl_err('','cpm-010',0)
      LET g_success = 'N'
      RETURN 
   END IF
   LET l_ina.ina00  ='1'
   LET l_ina.ina04  =g_grup  
   LET l_ina.inapost='N'
   LET l_ina.inaconf='N'     #FUN-660079
   LET l_ina.inaspc ='0'     #FUN-680010
   LET l_ina.inauser=g_user
   LET l_ina.inaoriu = g_user 
   LET l_ina.inaorig = g_grup 
   LET l_ina.inagrup=g_grup
   LET l_ina.inadate=g_today
   LET l_ina.ina08 = '0'           #開立  #FUN-550047
   LET l_ina.inamksg = 'N'         #簽核否#FUN-550047
   LET l_ina.ina12='N'       #No.FUN-870100
   LET l_ina.inapos='N'       #No.FUN-870100
   LET l_ina.inacont=''       #No.FUN-870100
   LET l_ina.inaconu=''       #No.FUN-870100
   LET l_ina.ina11=g_user
   LET l_ina.ina08 = 'N'
   LET l_ina.ina13 = ' '
   LET l_ina.ina10=p_tc_sfp01
   LET l_ina.inaplant = g_plant #FUN-980004 add
   LET l_ina.inalegal = g_legal
   INSERT INTO ina_file VALUES(l_ina.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("ins","ina_file",l_ina.ina01,"",SQLCA.sqlcode,"","ins ina",1)
      LET g_success = 'N'
      RETURN 
   END IF 
   UPDATE tc_sfp_file SET tc_sfp10 = l_ina.ina01
    WHERE tc_sfp01 = l_ina.ina10
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","tc_sfp_file",l_ina.ina10,"",SQLCA.sqlcode,"","ins tc_sfp",1)
      LET g_success = 'N'
      RETURN 
   END IF 
   LET l_i = 1
   DECLARE p610_sub_tc_sfp CURSOR FOR 
         SELECT * FROM tc_sfs_file 
          WHERE tc_sfs01 =p_tc_sfp01 
     FOREACH p610_sub_tc_sfp INTO l_tc_sfs.*
        LET l_inb.inb01= l_ina.ina01
        LET l_inb.inb03= l_i
        LET l_inb.inb04= l_tc_sfs.tc_sfs03
        LET l_inb.inb05='S.0248'
        LET l_inb.inb06=' '
        LET l_inb.inb07=' '
        LET l_inb.inb08=l_tc_sfs.tc_sfs06
        LET l_inb.inb08_fac = '1'
        LET l_inb.inb09 =l_tc_sfs.tc_sfs05
        LET l_inb.inb16 =l_tc_sfs.tc_sfs05
        LET l_inb.inb09 = s_digqty(l_inb.inb09,l_inb.inb08)
        LET l_inb.inb16 = s_digqty(l_inb.inb16,l_inb.inb08)
        SELECT ima24 INTO l_inb.inb10 FROM ima_file WHERE ima01 = l_inb.inb04
        LET l_inb.inb11 = p_tc_sfp01
        LET l_inb.inb12 = ''
        LET l_inb.inb13 = 0
        LET l_inb.inb15 ='002'
        LET l_inb.inb908 = ''
        LET l_inb.inb909 = ''
        LET l_inb.inb132 = 0
        LET l_inb.inb133 = 0
        LET l_inb.inb134 = 0
        LET l_inb.inb135 = 0
        LET l_inb.inb136 = 0
        LET l_inb.inb137 = 0
        LET l_inb.inb138 = 0
        LET l_inb.inblegal = g_legal   #MOD-A50144 add
        LET l_inb.inbplant = g_plant
        INSERT INTO inb_file VALUES(l_inb.*)
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","inb_file","","",SQLCA.sqlcode,"","ins inb",1) 
           LET g_success = 'N' 
           CONTINUE FOREACH 
        END IF 
        LET l_x = 0
        SELECT COUNT(*) INTO l_x FROM img_file 
         WHERE img01=l_inb.inb04
           AND img02=l_inb.inb05
           AND img03=l_inb.inb06
           AND img04=l_inb.inb07
        IF cl_null(l_x) OR l_x = 0 THEN 
           CALL s_add_img(l_inb.inb04,l_inb.inb05,
                          l_inb.inb06,l_inb.inb07,
                          l_ina.ina01,l_inb.inb03,l_ina.ina02)
           IF g_errno='N' THEN
              CALL cl_err('','cpm-011',1)
              LET g_success = 'N'    
           END IF
        END IF 
        LET l_i = l_i +1
     END FOREACH

     LET l_to_prog = g_prog
     LET g_prog = 'aimt301' 
     IF g_success = 'Y' THEN
        CALL t370sub_y_chk(l_ina.ina01,'1','N') #FUN-B50138  #TQC-C40079 add Y
        IF g_success = "Y" THEN
           CALL t370sub_y_upd(l_ina.ina01,'Y',TRUE) #FUN-B50138
           IF g_success = "Y" THEN
              CALL t370sub_s_chk(l_ina.ina01,'Y',TRUE,'')    #CALL 原確認的 check 段 #FUN-B50138
              IF g_success = "Y" THEN
                   CALL t370sub_s_upd(l_ina.ina01,'1',TRUE)       #CALL 原確認的 update 段#FUN-B50138
              END IF
           END IF
        END IF
     END IF 
     LET g_prog=l_to_prog

   
END FUNCTION 
#end----add by guanyao160523

