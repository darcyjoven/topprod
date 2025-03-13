# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Program name...: sasft620sub_sub.4gl
# Description....: 提供sasft620.src.4gl使用的sub routine
# Date & Author..: 09/05/15 By Carrier (No.FUN-950021)
# Modify.........: No.FUN-940083 09/06/29 By douzh VMI采購欄位賦初值
# Modify.........: No.FUN-960130 09/08/13 By Sunyanchun 零售業的必要欄位賦值
# Modify.........: No.FUN-980008 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980043 09/08/20 By mike 請將abm-731錯誤訊息加上項次與料號   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990194 09/09/29 By Smapmin 多加上LET g_success='N'
# Modify.........: No.           09/10/21 By lilingyu r.c2 fail
# Modify.........: No.FUN-9B0016 09/10/31 By sunyanchun post no
# Modify.........: No:MOD-9A0018 09/11/06 By Pengu 過帳時位lock資料造成tlf_file異常
# Modify.........: No:MOD-940257 09/11/30 By sabrina 調整入庫日其實應判斷是否小於發料日期
# Modify.........: No:TQC-9C0091 09/12/11 By jan 修改傳入s_icdchk的參數
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:FUN-8C0131 10/04/07 by dxfwo  過帳還原時的呆滯日期異動
# Modify.........: No:FUN-A60027 10/06/18 by sunchenxu 製造功能優化-平行制程（批量修改）
# Modify.........: No:FUN-A50066 10/06/24 By kim 平行工艺功能
# Modify.........: No:FUN-A80102 10/09/16 By kim GP5.25號機管理
# Modify.........: No:MOD-A90120 10/09/23 By Summer 將call s_udima()倒數第2參數的g_today改成g_sfu.sfu02
# Modify.........: No:FUN-A90057 10/09/23 By kim GP5.25號機管理
# Modify.........: No.FUN-AB0054 10/11/12 By zhangll 倉庫營運中心權限控管審核段控管
# Modify.........: No:MOD-AB0148 10/11/15 By sabrina 過帳時應抓此工單在別張完工入庫單已過帳的數量，再加上本筆欲過帳的數量後，
#                                                    再來比較是否有超過最小套數
# Modify.........: No:MOD-AC0389 10/12/29 By sabrina 在確認時需判斷此單別是否有做設限倉
# Modify.........: NO.TQC-B20107 11/02/23 By jan asft620過帳時，如果報工單對應的PO單別沒設 則過帳碼='Y'但報工單相應的單據沒產生(for 號機管理)
# Modify.........: No:TQC-B30028 11/03/04 By destiny 审核时应检查部门编号是否存在   
# Modify.........: No:FUN-A80128 11/03/09 By Mandy EasyFlow整合功能
# Modify.........: No:FUN-A70095 11/06/10 By lixh1 INSERT INTO shb_file 之前判斷 shbconf 是否為空
# Modify.........: No:TQC-B60065 11/06/16 By shiwuying 增加虛擬類型rvu27
# Modify.........: No.FUN-B30187 11/06/29 By jason ICD功能修改，增加母批、DATECODE欄位 
# Modify.........: No.TQC-B80005 11/08/03 By jason s_icdpost函數傳入參數
# Modify.........: No.FUN-B80119 11/09/14 By fengrui  增加調用s_icdpost的p_plant參數
# Modify.........: No.TQC-B90247 11/10/11 By houlia 審核時判斷入庫量是否大於可入庫量
# Modify.........: No.MOD-BA0161 11/10/20 By destiny 入库数量计算不正确
# Modify.........: No.FUN-BA0051 11/11/09 By jason 一批號多DATECODE功能
# Modify.........: No.FUN-BB0084 11/12/16 By lixh1 增加數量欄位小數取位
# Modify.........: No:FUN-BB0086 12/01/05 By tanxc 增加數量欄位小數取位
# Modify.........: No.MOD-BB0295 11/11/28 By destiny 变量类型定义错误
# Modify.........: No:MOD-C10077 12/01/17 By ck2yuan 計算工具與機時不判斷sma1435,call t700sub_upd_ecm改成call t700sub_confirm
# Modify.........: No.FUN-BB0001 12/01/17 By pauline 新增rvv22,INSERT/UPDATE rvb22時,同時INSERT/UPDATE rvv22
# Modify.........: No.FUN-BC0104 12/01/18 By xianghui 數量異動回寫qco20
# Modify.........: No.TQC-C20005 12/02/01 By destiny 自动报工时应check一下当前站是否为关键报工点
# Modify.........: No:TQC-C10101 12/01/30 By zhangll shb10赋值
# Modify.........: No.TQC-BB0236 11/11/29 By Carrier 审核时考虑超交率ima153
# Modify.........: No.TQC-C10126 12/02/17 By SunLM 修正發料套數管控的錯誤提示,暫時mark掉
# Modify.........:                                 如果該工單有多個工藝序,每個工藝序都有bonus的話,最終入庫數量肯定會大於發料套數
# Modify.........: No:TQC-C20372 12/02/23 By destiny 工艺工单时如某工艺序存在bonus量时入库数量可以大于发料套数
# Modify.........: No:CHI-C30118 12/04/06 By Sakura 參考來源單號CHI-C30106,批序號維護修改,t620sub_y_chk新增傳入參數 
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:CHI-C20054 12/07/16 By Sakura 將拆併箱整段有用到Transaction的部分都加上p_inTransaction的判斷
# Modify.........: No:MOD-BA0008 12/07/19 By ck2yuan 完工入庫日期無法修改
# Modify.........: No.MOD-BA0192 12/07/19 By ck2yuan 走製程時不應控卡最小發料套數
# Modify.........: No:MOD-C60147 12/07/19 By ck2yuan t700sub_shb081新增參數
# Modify.........: No:MOD-C70013 12/07/19 By ck2yuan 扣帳還原時 如果有已扣帳發料單 則 sfb04 = 4  若無  sfb04=2
# Modify.........: No:MOD-C70211 12/07/25 By ck2yuan 入庫誤差率應該是以工單產生料的誤差率為主,避免聯產品無法輸入
# Modify.........: No.FUN-C70087 12/08/01 By bart 整批寫入img_file
# Modify.........: No:MOD-C70223 12/08/03 By Elise 當aaz90為Y時才作TQC-B30028的判斷
# Modify.........: No:FUN-C70037 12/08/16 By lixh1 CALL s_minp增加傳入日期參數
# Modify.........: No:TQC-C90042 12/09/11 By chenjing 修改確認選否時也能確認成功
# Modify.........: No:TQC-C90031 12/09/17 By chenjing 修改通過生成不經過單身時對工單是否經過FQC的控管
# Modify.........: No:TQC-CA0028 12/10/11 By bart 離開程式前要drop temp table
# Modify.........: No:CHI-C90020 12/10/11 By Elise 確認段增加判斷批號aim-034控卡
# Modify.........: No:CHI-C80010 12/10/30 By bart 扣帳成功時判斷，if 入庫日>sfb18 則回寫
# Modify.........: No:CHI-CB0041 12/11/21 By bart 修改TQC-CA0028問題
# Modify.........: No:MOD-CB0242 12/11/30 By Elise 修改批序號管理錯誤訊息
# Modify.........: No:FUN-CB0087 12/12/11 By qiull 庫存單據理由碼改善, 12/12/20 fengrui 審核處添加非空檢查
# Modify.........: No:CHI-CA0070 13/01/08 By Elise 過帳日期,不可早於工單的開單日期
# Modify.........: No:MOD-CC0233 13/01/08 By Elise 過帳段加入過帳日期,不可早於工單的開單日期
# Modify.........: No:FUN-CC0095 13/01/16 By bart 修改整批寫入img_file
# Modify.........: No:MOD-D30057 13/03/07 By bart 不控卡存在領料單則不給過帳還原
# Modify.........: No:FUN-D30024 13/03/12 By fengrui 負庫存依據imd23判斷
# Modify.........: No:MOD-D20173 13/03/15 By bart 標準工時/標準機時除以生產數量sfb08
# Modify.........: No:MOD-D30167 13/03/19 By bart 將update sfu_file部分搬到下方BEGIN WORK下
# Modify.........: No:FUN-D30065 13/03/20 By lixh1 當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原
# Modify.........: No.DEV-D30040 13/04/01 By Nina 批序號相關程式,當料件使用條碼時(ima930 = 'Y'),確認時,
#                                                 若未輸入批序號資料則不需控卡單據數量與批/序號總數量是否相符 
#                                                 ex:單據數量與批/序號總數量不符，請檢查資料！(aim-011)
# Modify.........: No.CHI-CC0028 13/04/15 By bart 過帳還原需控管"有無此倉儲的過賬權限"
# Modify.........: No.DEV-D40015 13/04/19 By TSD.JIE 若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，需控卡不可直接確認or過帳
# Modify.........: No.DEV-D40013 13/04/22 By Mandy 純過單用
# Modify.........: No.MOD-D70058 13/07/08 By suncx 過賬時增加管控，存在變更日期比入庫日期小的工單變更單則報錯
# Modify.........: No:TQC-D40080 13/08/14 By dongsz 修改過帳還原時，抓取img09的條件


DATABASE ds
 
GLOBALS "../../config/top.global"

GLOBALS
DEFINE g_unit_arr      DYNAMIC ARRAY OF RECORD  #No.FUN-610090          #NO.FUN-9B0016        
                          unit   LIKE ima_file.ima25,                           
                          fac    LIKE img_file.img21,                           
                          qty    LIKE img_file.img10                            
                       END RECORD
#FUN-CC0095---begin
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
#FUN-CC0095---end       
END GLOBALS 
DEFINE g_forupd_sql STRING
 

#作用:lock cursor
#回傳值:無

FUNCTION t620sub_lock_cl()
   LET g_forupd_sql = "SELECT * FROM sfu_file WHERE sfu01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t620sub_cl CURSOR FROM g_forupd_sql
END FUNCTION
 
FUNCTION t620sub_y_chk(p_argv,p_sfu01,p_action_choice) #CHI-C30118 add p_action_choice
   DEFINE p_argv     LIKE type_file.chr1      
   DEFINE p_sfu01    LIKE sfu_file.sfu01
   DEFINE l_sfu      RECORD LIKE sfu_file.*
   DEFINE l_sfv      RECORD LIKE sfv_file.*
   DEFINE l_cnt      LIKE type_file.num10 
   DEFINE l_str      STRING
   #DEFINE l_imaicd08 LIKE imaicd_file.imaicd08   #FUN-BA0051 mark  
   DEFINE l_flag     LIKE type_file.num10       
   DEFINE l_rvbs06   LIKE rvbs_file.rvbs06      
   DEFINE l_date     LIKE type_file.dat    
   DEFINE l_ima918   LIKE ima_file.ima918
   DEFINE l_ima921   LIKE ima_file.ima921   
   DEFINE l_ima930   LIKE ima_file.ima930     #DEV-D30040 add
   DEFINE l_img09    LIKE img_file.img09
   DEFINE l_sfb39    LIKE sfb_file.sfb39
   DEFINE l_i        LIKE type_file.num5
   DEFINE l_fac      LIKE ima_file.ima31_fac
   #TQC-B90247  --begin
  #DEFINE g_min_set  LIKE type_file.num5  #MOD-BB0295
   DEFINE g_min_set  LIKE sfv_file.sfv09  #MOD-BB0295
  #DEFINE tmp_qty    LIKE type_file.num5  #MOD-BB0295  
   DEFINE tmp_qty    LIKE sfv_file.sfv09  #MOD-BB0295
  #DEFINE g_ecm_out  LIKE type_file.num5  #MOD-BB0295
   DEFINE g_ecm_out  LIKE ecm_file.ecm311 #MOD-BB0295
   DEFINE g_ecm311   LIKE ecm_file.ecm311
   DEFINE g_ecm315   LIKE ecm_file.ecm315
   DEFINE g_cnt      LIKE type_file.num5
   DEFINE l_ecm012   LIKE ecm_file.ecm012
   DEFINE l_ecm03    LIKE ecm_file.ecm03
   DEFINE l_sfb      RECORD LIKE sfb_file.*
   DEFINE l_sfb05    LIKE sfb_file.sfb05      #MOD-C70211 add
   #TQC-B90247  --end
   DEFINE l_ima153   LIKE ima_file.ima153    #No.TQC-BB0236
   DEFINE l_sfumksg        LIKE sfu_file.sfumksg  #CHI-C30118 add
   DEFINE l_sfu15          LIKE sfu_file.sfu15    #CHI-C30118 add
   DEFINE p_action_choice  STRING                 #CHI-C30118 add
   DEFINE l_ima159      LIKE ima_file.ima159  #CHI-C90020 add

   WHENEVER ERROR CONTINUE 
   
   LET g_success='Y'
#CHI-C30107 --------------- add ---------------- begin
   SELECT * INTO l_sfu.* FROM sfu_file WHERE sfu01=p_sfu01
   IF l_sfu.sfuconf = 'Y' THEN
      LET g_success='N'
      CALL cl_err(l_sfu.sfu01,'9023',0)
      RETURN
   END IF

   IF l_sfu.sfuconf = 'X' THEN
      LET g_success='N'
      CALL cl_err(l_sfu.sfu01,'9024',0)
      RETURN
   END IF
   IF NOT cl_null(p_action_choice) THEN
      IF p_action_choice <> 'efconfirm' THEN
    #     IF NOT cl_confirm('axm-108') THEN RETURN END IF   #TQC-C90042
         #TQC-C90042--add--
          IF NOT cl_confirm('axm-108') THEN 
             LET g_success='N'
             RETURN 
          END IF
         #TQC-C90042--add--
      END IF
   END IF
#CHI-C30107 ---------------- add --------------- end
   
   SELECT * INTO l_sfu.* FROM sfu_file WHERE sfu01=p_sfu01  
   IF cl_null(l_sfu.sfu01) THEN
      CALL cl_err('','-400',1)
      LET g_success='N'
      RETURN
   END IF
   
   LET l_cnt=0  
   SELECT COUNT(*) INTO l_cnt FROM sfv_file WHERE sfv01 = l_sfu.sfu01
   IF l_cnt = 0 THEN
      CALL cl_err(l_sfu.sfu01,'mfg-009',0) 
      LET g_success='N' 
      RETURN
   END IF
  #MOD-C70223---S---
   IF g_aaz.aaz90 = 'Y' THEN
     #TQC-B30028--begin
      LET l_cnt=0 
      SELECT COUNT(*) INTO l_cnt FROM gem_file WHERE gem01=l_sfu.sfu04 AND gemacti='Y' 
      IF l_cnt=0 THEN 
         CALL cl_err('','asf-624',1)
         LET g_success='N'
         RETURN
      END IF 
     #TQC-B30028--end 
   END IF
  #MOD-C70223---E---

   IF l_sfu.sfuconf = 'Y' THEN
      LET g_success='N'
      CALL cl_err(l_sfu.sfu01,'9023',0)
      RETURN
   END IF
   
   IF l_sfu.sfuconf = 'X' THEN
      LET g_success='N' 
      CALL cl_err(l_sfu.sfu01,'9024',0) 
      RETURN
   END IF
 
#CHI-C30118---add---START
   IF p_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
      p_action_choice CLIPPED = "insert"     
   THEN 
      SELECT sfumksg,sfu15 
        INTO l_sfumksg,l_sfu15
        FROM sfu_file
       WHERE sfu01=p_sfu01
      IF l_sfumksg='Y' THEN #若簽核碼為 'Y' 且狀態碼不為 '1' 已同意
         IF l_sfu15 != '1' THEN
            CALL cl_err('','aws-078',1) #此狀況碼不為「1.已核准」，不可確認!!
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF

#CHI-C30107 ---------------- mark --------------- begin
#  IF NOT cl_null(p_action_choice) THEN
#     IF p_action_choice <> 'efconfirm' THEN
#         IF NOT cl_confirm('axm-108') THEN RETURN END IF
#     END IF
#  END IF      
#CHI-C30107 ---------------- mark --------------- end
#CHI-C30118---add---END
 
   #Cehck 單身 料倉儲批是否存在 img_file
   DECLARE t620sub_y_chk_c CURSOR FOR SELECT * FROM sfv_file
                                   WHERE sfv01=l_sfu.sfu01
   FOREACH t620sub_y_chk_c INTO l_sfv.*
      #FUN-CB0087--add--str--
      IF g_aza.aza115='Y' AND cl_null(l_sfv.sfv44) THEN 
         CALL cl_err('','aim-888',1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      #FUN-CB0087--add--end--
     #MOD-AC0389---add---start---
      IF NOT s_chksmz(l_sfv.sfv04, l_sfu.sfu01,
                      l_sfv.sfv05, l_sfv.sfv06) THEN
         LET g_success = 'N'
         EXIT FOREACH
      END IF
     #MOD-AC0389---add---end---
   
      #Add No.No.FUN-AB0054
      IF NOT s_chk_ware(l_sfv.sfv05) THEN  #检查仓库是否属于当前门店
         LET g_success='N'
         EXIT FOREACH
      END IF
      #End Add No.No.FUN-AB0054
      #-----No.FUN-860045 Begin-----
      SELECT ima918,ima921,ima930 INTO l_ima918,l_ima921,l_ima930 #DEV-D30040 add ima930,l_ima930 
        FROM ima_file
       WHERE ima01 = l_sfv.sfv04
         AND imaacti = "Y"
      
      IF cl_null(l_ima930) THEN LET l_ima930 = 'N' END IF  #DEV-D30040 add

      IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
         SELECT SUM(rvbs06) INTO l_rvbs06
           FROM rvbs_file
          WHERE rvbs00 = g_prog
            AND rvbs01 = l_sfv.sfv01
            AND rvbs02 = l_sfv.sfv03
            AND rvbs09 = 1
            AND rvbs13 = 0
            
         IF cl_null(l_rvbs06) THEN
            LET l_rvbs06 = 0
         END IF
            
         SELECT img09 INTO l_img09 FROM img_file
          WHERE img01=l_sfv.sfv04
            AND img02=l_sfv.sfv05
            AND img03=l_sfv.sfv06
            AND img04=l_sfv.sfv07
 
         CALL s_umfchk(l_sfv.sfv04,l_sfv.sfv08,l_img09) 
             RETURNING l_i,l_fac
 
         IF l_i = 1 THEN LET l_fac = 1 END IF
 
         IF (l_ima930 = 'Y' and l_rvbs06 <> 0) OR l_ima930 = 'N' THEN  #DEV-D30040
            IF (l_sfv.sfv09 * l_fac) <> l_rvbs06 THEN
               LET g_success = "N"
               CALL cl_err(l_sfv.sfv04,"aim-011",1)
               EXIT FOREACH
            END IF
         END IF                                                        #DEV-D30040
      END IF
      #-----No.FUN-860045 END-----
#FUN-C70087---begin mark
#      LET l_cnt=0
# 
#      SELECT COUNT(*) INTO l_cnt FROM img_file WHERE img01=l_sfv.sfv04
#                                                 AND img02=l_sfv.sfv05
#                                                 AND img03=l_sfv.sfv06
#                                                 AND img04=l_sfv.sfv07
#      IF l_cnt=0 THEN
#         LET g_success='N'
#         LET l_str="Item ",l_sfv.sfv03,":"
#         CALL cl_err(l_str,'asf-507',1)
#         EXIT FOREACH
#      END IF
#FUN-C70087---end
      #CHI-910027-begin-add
      SELECT sfb39 INTO l_sfb39 FROM sfb_file WHERE sfb01=l_sfv.sfv11
      IF l_sfb39 != '2' THEN
         #檢查工單最小發料日是否小於入庫日
         SELECT MIN(sfp03) INTO l_date FROM sfe_file,sfp_file  
          WHERE sfe01 = l_sfv.sfv11 AND sfe02 = sfp01
         IF STATUS OR cl_null(l_date) THEN
            SELECT MIN(sfp03) INTO l_date FROM sfs_file,sfp_file
             WHERE sfs03=l_sfv.sfv11 AND sfp01=sfs01
         END IF
       
         IF cl_null(l_date) OR l_date > l_sfu.sfu02 THEN
            LET g_success='N'
            CALL cl_err(l_sfv.sfv11,'asf-824',1)
            EXIT FOREACH
         END IF
     #CHI-CA0070---Begin
      ELSE  
        #工單sfb39=2需檢查入庫日期不可小於工單開立日期
         LET l_date = ''
         SELECT sfb81 INTO l_date FROM sfb_file WHERE sfb01 = l_sfv.sfv11
         IF cl_null(l_date) OR l_date > l_sfu.sfu02 THEN
            LET g_success='N'
            CALL cl_err(l_sfv.sfv11,'asf-342',1)
            EXIT FOREACH
         END IF         
     #CHI-CA0070---End  
      END IF
      #CHI-910027-end-add

      SELECT * INTO l_sfb.* FROM sfb_file        #MOD-BA0192 add
       WHERE sfb01=l_sfv.sfv11                   #MOD-BA0192 add      
  #TQC-C90031--add--start--
      IF l_sfb.sfb94='Y' AND cl_null(l_sfv.sfv17) THEN 
         CALL cl_err(l_sfb.sfb01,'asf-680',1)
         LET g_success='N'
         EXIT FOREACH
      END IF
  #TQC-C90031--add--end--    
      #TQC-B90247  --begin  houlia
      SELECT SUM(sfv09) INTO tmp_qty FROM sfv_file,sfu_file
       WHERE sfv11 = l_sfv.sfv11
         AND sfv01 = sfu01
         AND sfu00 = '1'  
         AND (sfv01 != l_sfu.sfu01 OR                                                                             
             (sfv01 = l_sfu.sfu01 AND sfv03 != l_sfv.sfv03))                                                
         AND sfuconf <> 'X' 
                        
      IF tmp_qty IS NULL OR SQLCA.sqlcode THEN LET tmp_qty=0 END IF
      LET g_min_set = 0
    # CALL s_minp(l_sfv.sfv11,g_sma.sma73,0,'','','')               #FUN-C70037 mark
      CALL s_minp(l_sfv.sfv11,g_sma.sma73,0,'','','',l_sfu.sfu02)   #FUN-C70037
                       RETURNING g_cnt,g_min_set
      #入庫量不可大於最小套數-以keyin 入庫量
      #No.TQC-BB0236  --Begin
      IF g_sma.sma73='Y' THEN
         SELECT sfb05 INTO l_sfb05 FROM sfb_file WHERE sfb01 = l_sfv.sfv11   #MOD-C70211 add
        #CALL s_get_ima153(l_sfv.sfv04) RETURNING l_ima153                   #MOD-C70211 mark
         CALL s_get_ima153(l_sfb05) RETURNING l_ima153                       #MOD-C70211 add
      #  CALL s_minp(l_sfv.sfv11,g_sma.sma73,l_ima153,'','','')   #FUN-A60027 #FUN-C70037 mark
         CALL s_minp(l_sfv.sfv11,g_sma.sma73,l_ima153,'','','',l_sfu.sfu02)   #FUN-C70037
              RETURNING g_cnt,g_min_set
         IF cl_null(g_min_set) THEN LET g_min_set = 0 END IF
      END IF
      #No.TQC-BB0236  --End
      IF l_sfb.sfb93 !='Y' THEN  #TQC-C20372 
         IF g_sma.sma73='Y' AND (l_sfv.sfv09) > (g_min_set-tmp_qty) THEN
            CALL cl_err(l_sfv.sfv09,'asf-675',1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
     #MOD-BA0192---modify---start---
     #END IF #TQC-C20372--end
     #SELECT * INTO l_sfb.* FROM sfb_file
     # WHERE sfb01=l_sfv.sfv11
     #IF l_sfb.sfb93='Y' THEN # 走製程 check 轉出量
      ELSE
     #MOD-BA0192---modify---end--
         LET g_ecm311 = 0   
         LET g_ecm315 = 0
         CALL s_schdat_max_ecm03(l_sfv.sfv11) RETURNING l_ecm012,l_ecm03
         SELECT ecm311,ecm315 INTO g_ecm311,g_ecm315 FROM ecm_file
          WHERE ecm01=l_sfv.sfv11
            AND ecm012= l_ecm012  
            AND ecm03 = l_ecm03   
         IF STATUS THEN LET g_ecm311=0 END IF
         IF STATUS THEN LET g_ecm315=0 END IF
         LET g_ecm_out = g_ecm311 + g_ecm315
         IF cl_null(tmp_qty) THEN LET tmp_qty = 0 END IF
         IF l_sfv.sfv09 > g_ecm_out - tmp_qty THEN  
            IF NOT t620_chk_auto_report(l_sfv.sfv11,l_sfv.sfv09) THEN 
               CALL cl_err(l_sfv.sfv09,'asf-675',1)
                LET g_success = 'N'
                EXIT FOREACH
            END IF
         END IF
#TQC-C10126 mark begin 因為,如果有多個工藝序,每個工藝序都有bonus的話,最終入庫數量肯定會大於發料套數
#        IF g_sma.sma73='Y' AND (l_sfv.sfv09) > (g_min_set+g_ecm315-tmp_qty) THEN   
#           CALL cl_err(l_sfv.sfv09,'asf-675',1)
#           LET g_success = 'N'
#           EXIT FOREACH
#         END IF
#TQC-C10126 mark end 
      END IF
      #TQC-B90247  --end  houlia
      IF s_industry('icd') THEN
         #No.FUN-830061  --BEGIN
         #FUN-BA0051 --START mark--
         #LET l_imaicd08 = NULL
         #SELECT imaicd08 INTO l_imaicd08
         #  FROM imaicd_file WHERE imaicd00 =  l_sfv.sfv04
         #   
         #IF l_imaicd08 = 'Y' THEN
         #FUN-BA0051 --END mark--
         IF s_icdbin(l_sfv.sfv04) THEN   #FUN-BA0051
            IF p_argv = '1' THEN
               CALL s_icdchk(1,l_sfv.sfv04,   #TQC-9C0091
                               l_sfv.sfv05,
                               l_sfv.sfv06,
                               l_sfv.sfv07,  
                               l_sfv.sfv09, 
                               l_sfu.sfu01,l_sfv.sfv03,
                               l_sfu.sfu02,'')  #FUN-B80119--傳入p_plant參數''---
                    RETURNING l_flag
            ELSE  
               CALL s_icdchk(-1,l_sfv.sfv04,                                                                                      
                                l_sfv.sfv05,                                                                                      
                                l_sfv.sfv06,                                                                                      
                                l_sfv.sfv07,                                                                                      
                                l_sfv.sfv09,                                                                                      
                                l_sfu.sfu01,l_sfv.sfv03,                                                                          
                                l_sfu.sfu02,'')  #FUN-B80119--傳入p_plant參數''---                                                                                            
                    RETURNING l_flag
            END IF
            IF l_flag = 0 THEN
               CALL cl_err(l_sfv.sfv03,'aic-056',1) 
               LET g_success = 'N' 
               EXIT FOREACH
            END IF
         END IF 
         #No.FUN-830061  --END
      END IF
 
  #CHI-C90020---add---S
   IF NOT cl_null(l_sfv.sfv04) THEN
      LET l_ima159 = ''
      SELECT ima159 INTO l_ima159 FROM ima_file
       WHERE ima01 = l_sfv.sfv04
      IF l_ima159 = '1' AND cl_null(l_sfv.sfv07) THEN
         CALL cl_err(l_sfv.sfv04,'aim-034',1)
         LET g_success = 'N'
      END IF
   END IF
  #CHI-C90020---add---E

   END FOREACH
      
   IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
 
#carrier Transaction is wrong & popup dialog,how to process
FUNCTION t620sub_y_upd(p_sfu01,p_action_choice,p_inTransaction)
   DEFINE p_sfu01          LIKE sfu_file.sfu01
   DEFINE p_action_choice  STRING
   DEFINE p_inTransaction  LIKE type_file.num5 
   DEFINE l_sfu            RECORD LIKE sfu_file.*
   DEFINE l_sfumksg        LIKE sfu_file.sfumksg  #FUN-A80128 add
   DEFINE l_sfu15          LIKE sfu_file.sfu15    #FUN-A80128 add
 
   LET g_success = 'Y'

#CHI-C30118---mark---START 
#  #FUN-A80128 add---str---
#  IF p_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
#     p_action_choice CLIPPED = "insert"     
#  THEN 
#     SELECT sfumksg,sfu15 
#       INTO l_sfumksg,l_sfu15
#       FROM sfu_file
#      WHERE sfu01=p_sfu01
#     IF l_sfumksg='Y' THEN #若簽核碼為 'Y' 且狀態碼不為 '1' 已同意
#        IF l_sfu15 != '1' THEN
#           CALL cl_err('','aws-078',1) #此狀況碼不為「1.已核准」，不可確認!!
#           LET g_success = 'N'
#           RETURN
#        END IF
#     END IF
#  END IF
#  #FUN-A80128 add---end---

#  IF NOT cl_null(p_action_choice) THEN  #FUN-840012    #carrier
#     IF p_action_choice <> 'efconfirm' THEN #FUN-A80128 add if 判斷
#         IF NOT cl_confirm('axm-108') THEN RETURN END IF
#     END IF                                 #FUN-A80128 add
#  END IF
#CHI-C30118---mark---START   
   
   IF cl_null(p_sfu01) THEN
      CALL cl_err('','-400',1)
      LET g_success='N'
      RETURN
   END IF

   IF NOT p_inTransaction THEN   
      BEGIN WORK    #carrier
   END IF
 
   CALL t620sub_lock_cl() 
   OPEN t620sub_cl USING p_sfu01
   IF STATUS THEN
      CALL cl_err("OPEN t620sub_cl:", STATUS, 1)
      CLOSE t620sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET g_success='N' #FUN-730012 add
      RETURN
   END IF
 
   FETCH t620sub_cl INTO l_sfu.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock sfu:',SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t620sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET g_success='N' #FUN-730012 add
      RETURN
   END IF
 
   CLOSE t620sub_cl
 
   UPDATE sfu_file SET sfuconf = 'Y',
                       sfu15 = '1'  #FUN-A80128 add
    WHERE sfu01=l_sfu.sfu01
   IF STATUS THEN
      CALL cl_err3("upd","sfu_file",l_sfu.sfu01,"",STATUS,"","upd sfuconf",1) 
      LET g_success='N'
   END IF
 
    #--FUN-8C0081--start--
    IF g_success='Y' THEN
       LET l_sfu.sfuconf = "Y"
       IF NOT p_inTransaction THEN COMMIT WORK END IF
       CALL cl_flow_notify(l_sfu.sfu01,'Y')
    ELSE
       LET l_sfu.sfuconf = "N"
       IF NOT p_inTransaction THEN ROLLBACK WORK END IF
    END IF
    #--FUN-8C0081--end--
END FUNCTION
 
FUNCTION t620sub_refresh(p_sfu01)
  DEFINE p_sfu01 LIKE sfu_file.sfu01
  DEFINE l_sfu RECORD LIKE sfu_file.*
 
  SELECT * INTO l_sfu.* FROM sfu_file WHERE sfu01=p_sfu01
  RETURN l_sfu.*
END FUNCTION
 
 
#carrier Transaction is wrong & popup dialog,how to process
FUNCTION t620sub_z(p_sfu01,p_action_choice,p_inTransaction)
   DEFINE p_sfu01          LIKE sfu_file.sfu01
   DEFINE p_action_choice  STRING
   DEFINE p_inTransaction  LIKE type_file.num5 
   DEFINE l_sfu            RECORD LIKE sfu_file.*
 
   LET g_success = 'Y'
 
   SELECT * INTO l_sfu.* FROM sfu_file WHERE sfu01=p_sfu01  
   IF cl_null(l_sfu.sfu01) THEN
      CALL cl_err('','-400',1)
      LET g_success='N'
      RETURN
   END IF
   
   IF l_sfu.sfuconf = 'N' THEN
      LET g_success='N'
      CALL cl_err(l_sfu.sfu01,'9025',0)
      RETURN
   END IF
   
   IF l_sfu.sfuconf = 'X' THEN
      LET g_success='N' 
      CALL cl_err(l_sfu.sfu01,'9024',0) 
      RETURN
   END IF   
   
   IF l_sfu.sfupost = 'Y' THEN
      LET g_success='N' 
      CALL cl_err(l_sfu.sfu01,'afa-106',0) 
      RETURN
   END IF   
 
   IF NOT cl_null(p_action_choice) THEN
      IF NOT cl_confirm('axm-109') THEN RETURN END IF
   END IF
   
   IF NOT p_inTransaction THEN 
      BEGIN WORK    #carrier
   END IF
 
   CALL t620sub_lock_cl() #FUN-730012
   OPEN t620sub_cl USING l_sfu.sfu01
   IF STATUS THEN
      CALL cl_err("OPEN t620sub_cl:", STATUS, 1)
      CLOSE t620sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET g_success='N' 
      RETURN
   END IF
 
   FETCH t620sub_cl INTO l_sfu.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock sfu:',SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t620sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET g_success='N' 
      RETURN
   END IF
   
   CLOSE t620sub_cl
 
   UPDATE sfu_file SET sfuconf = 'N',
                       sfu15 = '0'  #FUN-A80128 add
    WHERE sfu01=l_sfu.sfu01
   IF STATUS THEN
      CALL cl_err3("upd","sfu_file",l_sfu.sfu01,"",STATUS,"","upd sfuconf",1) 
      LET g_success='N'
   END IF
 
    #--FUN-8C0081--start--
    IF g_success='Y' THEN
       LET l_sfu.sfuconf = "N"
       LET l_sfu.sfu15='0'                       #FUN-A80128 add
       IF NOT p_inTransaction THEN COMMIT WORK END IF
    ELSE
       LET l_sfu.sfuconf = "Y"
       LET l_sfu.sfu15='1'                       #FUN-A80128 add
       IF NOT p_inTransaction THEN ROLLBACK WORK END IF
    END IF
    #--FUN-8C0081--end--
END FUNCTION
 
 
#p_argv1 : #1.發料 2.退料 #TQC-890051
#p_inTransaction : IF p_inTransaction=FALSE 會在程式中呼叫BEGIN WORK
#p_ask_post : IF p_ask_post=TRUE 會詢問"是否執行過帳"
FUNCTION t620sub_s(p_sfu01,p_argv,p_inTransaction,p_action_choice)
   DEFINE p_sfu01         LIKE sfu_file.sfu01
   DEFINE p_argv          LIKE type_file.chr1
   DEFINE p_inTransaction LIKE type_file.num5 
   DEFINE p_action_choice STRING   
   DEFINE l_sfu           RECORD LIKE sfu_file.*
   DEFINE l_cnt           LIKE type_file.num5 
   DEFINE l_yy            LIKE type_file.num5
   DEFINE l_mm            LIKE type_file.num5
   DEFINE l_sfu03         LIKE sfu_file.sfu03  
   DEFINE lj_result       LIKE type_file.chr1  #No.FUN-930108 存s_incchk()返回值
   DEFINE l_sfv           RECORD LIKE sfv_file.*
   DEFINE l_sfu02         LIKE sfu_file.sfu02
   DEFINE l_sfu02_new     LIKE sfu_file.sfu02     #MOD-BA0008 add
   #DEFINE l_img_table      STRING                 #FUN-C70087 #FUN-CC0095
   #DEFINE l_imgg_table     STRING                 #FUN-C70087 #FUN-CC0095
   DEFINE l_cnt_img       LIKE type_file.num5     #FUN-C70087
   DEFINE l_cnt_imgg      LIKE type_file.num5     #FUN-C70087
   DEFINE l_flag          LIKE type_file.chr1     #FUN-C70087
   DEFINE l_sql            STRING                 #FUN-C70087
   DEFINE l_date          LIKE type_file.dat,     #MOD-CC0233 add
          l_sfv11         LIKE sfv_file.sfv11     #MOD-CC0233 add
 
   WHENEVER ERROR CONTINUE                #忽略一切錯誤  #FUN-740187
   #CALL s_padd_img_create() RETURNING l_img_table   #FUN-C70087  #FUN-CC0095
   #CALL s_padd_imgg_create() RETURNING l_imgg_table #FUN-C70087  #FUN-CC0095
   LET g_success='Y' #FUN-740187
   
   IF s_shut(0) THEN LET g_success='N' 
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #FUN-CC0095
      RETURN 
   END IF
 
   SELECT * INTO l_sfu.* FROM sfu_file WHERE sfu01=p_sfu01
 
   IF l_sfu.sfu01 IS NULL THEN
      CALL cl_err('',-400,0)
      LET g_success='N' 
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #FUN-CC0095
      RETURN
   END IF
 
   #FUN-660106...............begin
   IF l_sfu.sfuconf = 'N' THEN
      CALL cl_err('','aba-100',1)
      LET g_success='N' 
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #FUN-CC0095
      RETURN
   END IF
   #FUN-660106...............end
 
   #-->已扣帳
   IF l_sfu.sfupost = 'Y' THEN
      CALL cl_err('sfupost=Y','asf-812',1)
      LET g_success='N' 
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #FUN-CC0095
      RETURN
   END IF
 
   IF l_sfu.sfuconf = 'X' THEN  #FUN-660106
      CALL cl_err('','9024',1)
      LET g_success='N' 
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #FUN-CC0095
      RETURN
   END IF
 
   #-----No.FUN-930108--start-----
   DECLARE t620sub_s_c CURSOR FOR
     SELECT * FROM sfv_file WHERE sfv01=l_sfu.sfu01
 
   FOREACH t620sub_s_c INTO l_sfv.*
      IF cl_null(l_sfv.sfv04) THEN
         #LET g_success='N'
         CONTINUE FOREACH
      END IF
      CALL s_incchk(l_sfv.sfv05,l_sfv.sfv06,g_user)
           RETURNING  lj_result
      IF NOT lj_result THEN
         CALL cl_err(l_sfu.sfu01,'axm-399',1)
         LET g_success = 'N'                       #carrier add
         #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #FUN-CC0095
         #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #FUN-CC0095
         RETURN                                    #carrier check with douzh
      END IF
      
      #MOD-D70058 add begin--------------------------
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM snb_file 
       WHERE snb01=l_sfv.sfv11 AND snb022>l_sfu.sfu02
         AND snbconf != 'X'
      IF l_cnt > 0 THEN 
         CALL cl_err(l_sfv.sfv11,'asf1055',1)
         LET g_success = 'N' 
         RETURN
      END IF     
      #MOD-D70058 add end----------------------------
   END FOREACH
   #-----No.FUN930108---end------

   #DEV-D40015 add str--------
   #若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，需控卡不可直接確認or過帳
   IF g_aza.aza131 = 'Y' AND (g_prog = 'asft620') THEN
     #確認是否有符合條件的料件
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM ima_file
       WHERE ima01 IN (SELECT sfv04 FROM sfv_file WHERE sfv01 = l_sfu.sfu01) #料件
         AND ima930 = 'Y'                   #條碼使用否
         AND (ima921 = 'Y' OR ima918 = 'Y') #批號管理否='Y' OR 序號管理否='Y'
	
     #確認是否已有掃描紀錄
      IF l_cnt > 0 THEN
         IF NOT s_chk_barcode_confirm('post','tlfb',l_sfu.sfu01,'','') THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF
   #DEV-D40015 add end--------
   
   #FUN-860069
   LET l_sfu02 = l_sfu.sfu02
 
  #--------------------No:MOD-9A0018 add
   IF NOT p_inTransaction THEN
      BEGIN WORK
   END IF

   CALL t620sub_lock_cl() 
   OPEN t620sub_cl USING l_sfu.sfu01
   IF STATUS THEN
      CALL cl_err("OPEN t620sub_cl:", STATUS, 1)
      CLOSE t620sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #FUN-CC0095
      RETURN
   END IF
  #--------------------No:MOD-9A0018 end

   IF NOT cl_null(p_action_choice) THEN  #FUN-840012
      IF NOT cl_confirm('mfg0176') THEN 
         LET g_success='N' 
        #--------------No:MOD-9A0018  add
         CLOSE t620sub_cl
         IF NOT p_inTransaction THEN ROLLBACK WORK END IF
        #--------------No:MOD-9A0018  end
         #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #FUN-CC0095
         #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #FUN-CC0095
         RETURN 
      END IF
   END IF
   
   IF NOT cl_null(g_action_choice) THEN  #FUN-840012 外部呼叫時
      DISPLAY BY NAME l_sfu.sfu02
      INPUT BY NAME l_sfu.sfu02 WITHOUT DEFAULTS
      
           AFTER FIELD sfu02
               IF NOT cl_null(l_sfu.sfu02) THEN
                  IF g_sma.sma53 IS NOT NULL AND l_sfu.sfu02 <= g_sma.sma53 THEN
                     CALL cl_err('','mfg9999',0) 
                     NEXT FIELD sfu02
                  END IF
                  CALL s_yp(l_sfu.sfu02) RETURNING l_yy,l_mm
                  IF (l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                     CALL cl_err(l_yy,'mfg6090',0) 
                     NEXT FIELD sfu02
                  END IF
                 #MOD-CC0233---add---S
                 #工單sfb39=2需檢查入庫日期不可小於工單開立日期
                  DECLARE t620sub_y_chk_c2 CURSOR FOR SELECT sfv11 FROM sfv_file
                                                       WHERE sfv01=l_sfu.sfu01
                  FOREACH t620sub_y_chk_c2 INTO l_sfv11
                     LET l_date = ''
                     SELECT sfb81 INTO l_date FROM sfb_file WHERE sfb01 = l_sfv.sfv11
                     IF cl_null(l_date) OR l_date > l_sfu.sfu02 THEN
                        LET g_success='N'
                        CALL cl_err(l_sfv.sfv11,'asf-342',1)
                        NEXT FIELD sfu02
                     END IF
                  END FOREACH
                 #MOD-CC0233---add---E
               END IF
               
           AFTER INPUT 
               IF INT_FLAG THEN
                  LET INT_FLAG = 0
                  LET l_sfu.sfu02=l_sfu02
                  DISPLAY BY NAME l_sfu.sfu02
                 #--------------No:MOD-9A0018  add
                  CLOSE t620sub_cl
                  IF NOT p_inTransaction THEN ROLLBACK WORK END IF
                 #--------------No:MOD-9A0018  end
                  #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #FUN-CC0095
                  #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #FUN-CC0095
                  RETURN
               END IF
               IF NOT cl_null(l_sfu.sfu02) THEN
                  IF g_sma.sma53 IS NOT NULL AND l_sfu.sfu02 <= g_sma.sma53 THEN
                     CALL cl_err('','mfg9999',0) 
                     NEXT FIELD sfu02
                  END IF
                  CALL s_yp(l_sfu.sfu02) RETURNING l_yy,l_mm
                  IF (l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                     CALL cl_err(l_yy,'mfg6090',0) 
                     NEXT FIELD sfu02
                  END IF
               ELSE
                  CONTINUE INPUT
               END IF
               
           ON ACTION CONTROLG 
              CALL cl_cmdask()
   
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
      END INPUT
   END IF
   #--
   LET l_sfu02_new = l_sfu.sfu02       #MOD-BA0008 add 

   IF g_sma.sma53 IS NOT NULL AND l_sfu.sfu02 <= g_sma.sma53 THEN
      LET g_success = 'N'
      CALL cl_err('','mfg9999',0) 
     #--------------No:MOD-9A0018  add
      CLOSE t620sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
     #--------------No:MOD-9A0018  end
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #FUN-CC0095
      RETURN
   END IF
 
   CALL s_yp(l_sfu.sfu02) RETURNING l_yy,l_mm
   IF (l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
      LET g_success = 'N'
      CALL cl_err(l_yy,'mfg6090',0) 
     #--------------No:MOD-9A0018  add
      CLOSE t620sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
     #--------------No:MOD-9A0018  end
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #FUN-CC0095
      RETURN
   END IF
 
##No.2987 modify 1998/12/29未過帳之FQC單應不可於此作業作過帳
   IF p_argv<>'3' THEN #FUN-5C0114   #carrier
      SELECT COUNT(DISTINCT sfv17) INTO l_cnt FROM sfv_file,sfu_file
       WHERE sfv01 = l_sfu.sfu01
         AND sfv01 = sfu01
         AND sfv17 IN ( SELECT qcf01 FROM qcf_file
                         WHERE qcf09 = '2' OR qcf14 != 'Y' )
      IF l_cnt > 0 THEN
         CALL cl_err('','asf-711',0)
         LET g_success = 'N'
        #--------------No:MOD-9A0018  add
         CLOSE t620sub_cl
         IF NOT p_inTransaction THEN ROLLBACK WORK END IF
        #--------------No:MOD-9A0018  end
         #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #FUN-CC0095
         #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #FUN-CC0095
         RETURN
      END IF
   END IF
##---------------------------
 
  #--------------------No:MOD-9A0018 mark
  #IF NOT p_inTransaction THEN
  #   BEGIN WORK
  #END IF
 
  #CALL t620sub_lock_cl() #FUN-730012
  #OPEN t620sub_cl USING l_sfu.sfu01
  #IF STATUS THEN
  #   CALL cl_err("OPEN t620sub_cl:", STATUS, 1)
  #   CLOSE t620sub_cl
  #   IF NOT p_inTransaction THEN ROLLBACK WORK END IF
  #   LET g_success='N' 
  #   RETURN
  #END IF
  #--------------------No:MOD-9A0018 end
   #FUN-C70087---begin
   CALL s_padd_img_init()  #FUN-CC0095
   CALL s_padd_imgg_init()  #FUN-CC0095
   
   DECLARE t620_s_c2 CURSOR FOR SELECT * FROM sfv_file
     WHERE sfv01 = l_sfu.sfu01 

   FOREACH t620_s_c2 INTO l_sfv.*
      IF STATUS THEN EXIT FOREACH END IF
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM img_file
       WHERE img01 = l_sfv.sfv04
         AND img02 = l_sfv.sfv05
         AND img03 = l_sfv.sfv06
         AND img04 = l_sfv.sfv07
       IF l_cnt = 0 THEN
          #CALL s_padd_img_data(l_sfv.sfv04,l_sfv.sfv05,l_sfv.sfv06,l_sfv.sfv07,l_sfu.sfu01,l_sfv.sfv03,l_sfu.sfu02,l_img_table) #FUN-CC0095
          CALL s_padd_img_data1(l_sfv.sfv04,l_sfv.sfv05,l_sfv.sfv06,l_sfv.sfv07,l_sfu.sfu01,l_sfv.sfv03,l_sfu.sfu02) #FUN-CC0095
       END IF

       CALL s_chk_imgg(l_sfv.sfv04,l_sfv.sfv05,
                       l_sfv.sfv06,l_sfv.sfv07,
                       l_sfv.sfv30) RETURNING l_flag
       IF l_flag = 1 THEN
          #CALL s_padd_imgg_data(l_sfv.sfv04,l_sfv.sfv05,l_sfv.sfv06,l_sfv.sfv07,l_sfv.sfv30,l_sfu.sfu01,l_sfv.sfv03,l_imgg_table) #FUN-CC0095
          CALL s_padd_imgg_data1(l_sfv.sfv04,l_sfv.sfv05,l_sfv.sfv06,l_sfv.sfv07,l_sfv.sfv30,l_sfu.sfu01,l_sfv.sfv03) #FUN-CC0095
       END IF 
       CALL s_chk_imgg(l_sfv.sfv04,l_sfv.sfv05,
                       l_sfv.sfv06,l_sfv.sfv07,
                       l_sfv.sfv33) RETURNING l_flag
       IF l_flag = 1 THEN
          #CALL s_padd_imgg_data(l_sfv.sfv04,l_sfv.sfv05,l_sfv.sfv06,l_sfv.sfv07,l_sfv.sfv33,l_sfu.sfu01,l_sfv.sfv03,l_imgg_table) #FUN-CC0095
          CALL s_padd_imgg_data1(l_sfv.sfv04,l_sfv.sfv05,l_sfv.sfv06,l_sfv.sfv07,l_sfv.sfv33,l_sfu.sfu01,l_sfv.sfv03) #FUN-CC0095
       END IF 
   END FOREACH 
   #FUN-CC0095---begin mark
   #LET l_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_img_table CLIPPED  #,g_cr_db_str
   #PREPARE cnt_img FROM l_sql
   #LET l_cnt_img = 0
   #EXECUTE cnt_img INTO l_cnt_img
   #
   #LET l_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_imgg_table CLIPPED  #,g_cr_db_str
   #PREPARE cnt_imgg FROM l_sql
   #LET l_cnt_imgg = 0
   #EXECUTE cnt_imgg INTO l_cnt_imgg
   #FUN-CC0095---end    
   LET l_cnt_img = g_padd_img.getLength()  #FUN-CC0095
   LET l_cnt_imgg = g_padd_imgg.getLength()  #FUN-CC0095
   
   IF g_sma.sma892[3,3] = 'Y' AND (l_cnt_img > 0 OR l_cnt_imgg > 0) THEN
      IF cl_confirm('mfg1401') THEN 
         IF l_cnt_img > 0 THEN 
            #IF NOT s_padd_img_show(l_img_table) THEN  #FUN-CC0095
            IF NOT s_padd_img_show1() THEN  #FUN-CC0095
               #CALL s_padd_img_drop(l_img_table) #FUN-CC0095
               LET g_success = 'N'
               #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #CHI-CB0041
               #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #CHI-CB0041
               RETURN 
            END IF
         END IF 
         IF l_cnt_imgg > 0 THEN #FUN-CC0095 
            #IF NOT s_padd_imgg_show(l_imgg_table) THEN  #FUN-CC0095
            IF NOT s_padd_imgg_show1() THEN  #FUN-CC0095
               #CALL s_padd_imgg_drop(l_imgg_table) #FUN-CC0095
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
   END IF
   #CALL s_padd_img_del(l_img_table)  #FUN-CC0095
   #CALL s_padd_imgg_del(l_imgg_table)  #FUN-CC0095
   #FUN-C70087---end
   
   FETCH t620sub_cl INTO l_sfu.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock sfu:',SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t620sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET g_success='N' 
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
      RETURN
   END IF
 
 
   #LET g_success = 'Y'  #marked by carrier
 
   UPDATE sfu_file SET sfupost='Y'  ,
                      #sfu02=l_sfu.sfu02       #MOD-BA0008 mark
                       sfu02=l_sfu02_new       #MOD-BA0008 add
    WHERE sfu01=l_sfu.sfu01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      LET l_sfu.sfu02 = l_sfu02
      LET g_success='N'
   END IF
   
   #FUN-5C0114...............begin
   IF p_argv='3' THEN
      CALL t620sub_upd_sre11("+",l_sfu.sfu01,p_argv)
   ELSE
   #FUN-5C0114...............end
      CALL t620sub_s1(l_sfu.sfu01,p_argv)
   END IF
   #CHI-C80010---begin
   IF g_success = 'Y' THEN
      UPDATE sfb_file SET sfb18 = l_sfu02_new
       WHERE EXISTS(SELECT 1 FROM sfv_file WHERE sfv11 = sfb01 AND sfv01 = l_sfu.sfu01)
         AND (sfb18 < l_sfu02_new OR sfb18 IS NULL)
   END IF 
   #CHI-C80010---end
   IF g_success = 'Y' THEN
      LET l_sfu.sfupost='Y'
      IF NOT p_inTransaction THEN COMMIT WORK END IF
      CALL cl_flow_notify(l_sfu.sfu01,'S')
 
#     IF NOT cl_null(g_action_choice) THEN  #FUN-840012
#        #FUN-680139 begin
#         SELECT COUNT(*) INTO l_cnt FROM sfv_file,sfa_file
#          WHERE sfv01 = l_sfu.sfu01
#            AND sfv11 = sfa01 AND sfa11 = 'E'
#         IF l_cnt > 0 THEN 
#           CALL t620sub_k() 
#         END IF
#        #FUN-680139 end
#     END IF
   ELSE
      LET l_sfu.sfupost='N'
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
   END IF
   #CALL s_padd_img_drop(l_img_table)   #FUN-C70087  #FUN-CC0095
   #CALL s_padd_imgg_drop(l_imgg_table) #FUN-C70087  #FUN-CC0095
END FUNCTION
 
FUNCTION t620sub_upd_sre11(p_opt,p_sfu01,p_argv)
   DEFINE p_opt      LIKE type_file.chr1
   DEFINE p_sfu01    LIKE sfu_file.sfu01
   DEFINE p_argv     LIKE type_file.chr1
   DEFINE l_sfu      RECORD LIKE sfu_file.*
   DEFINE l_sfv      RECORD LIKE sfv_file.*
   DEFINE l_srf03    LIKE srf_file.srf03  #機台
   DEFINE l_srf04    LIKE srf_file.srf04  #班別
   DEFINE l_srf05    LIKE srf_file.srf05  #生產/計畫日
   DEFINE l_sw       LIKE type_file.num5
   DEFINE l_ima918   LIKE ima_file.ima918
   DEFINE l_ima921   LIKE ima_file.ima921    
   DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
   DEFINE l_sql   STRING                                    #NO.FUN-8C0131 
   DEFINE l_i     LIKE type_file.num5                       #NO.FUN-8C0131
   DEFINE l_srg17    LIKE srg_file.srg17                    #No.FUN-BB0086
   DEFINE l_srg04    LIKE srg_file.srg04                    #No.FUN-BB0086
 
   IF g_success='N' THEN RETURN END IF
   SELECT * INTO l_sfu.* FROM sfu_file WHERE sfu01 = p_sfu01
   LET l_sw = 1
   IF p_opt = "+" THEN LET l_sw = 1  END IF
   IF p_opt = "-" THEN LET l_sw = -1 END IF
   
   DECLARE t620sub_upd_cur CURSOR FOR 
    SELECT sfv_file.*,srf03,srf04,srf05
      FROM sfv_file,srg_file,srf_file
     WHERE sfv01=l_sfu.sfu01
       AND srg01=srf01
       AND sfv17=srg01
       AND sfv14=srg02
 
   FOREACH t620sub_upd_cur INTO l_sfv.*,l_srf03,l_srf04,l_srf05
      IF SQLCA.sqlcode THEN
         CALL cl_err('upd sre',SQLCA.sqlcode,1)
         LET g_success='N'
         EXIT FOREACH
      END IF
      IF cl_null(l_sfv.sfv09) THEN LET l_sfv.sfv09 = 0 END IF
      
      UPDATE sre_file set sre11=sre11+l_sfv.sfv09 * l_sw
       WHERE sre03=l_srf03
         AND sre04=l_sfv.sfv11
         AND sre05=l_srf04
         AND sre06=l_srf05
      IF SQLCA.sqlcode THEN
         CALL cl_err('upd sre',SQLCA.sqlcode,1)
         LET g_success='N'
         EXIT FOREACH
      END IF     
      #No.FUN-BB0086--add--begin--
      SELECT srg04 INTO l_srg04 FROM srg_file 
       WHERE srg01=l_sfv.sfv17
         AND srg02=l_sfv.sfv14
      LET l_srg17 = s_digqty(l_sfv.sfv09 * l_sw,l_srg04)
      #No.FUN-BB0086--add--end--
      #FUN-630105...............begin
      UPDATE srg_file set srg17=srg17+ l_srg17    
       WHERE srg01=l_sfv.sfv17
         AND srg02=l_sfv.sfv14
      #FUN-630105...............end
      IF SQLCA.sqlcode THEN
         CALL cl_err('upd sre',SQLCA.sqlcode,1)
         LET g_success='N'
         EXIT FOREACH
      END IF
 
      #MOD-640120...............begin
      IF (p_opt='-') AND (g_success='Y') THEN
  ##NO.FUN-8C0131   add--begin   
        LET l_sql =  " SELECT  * FROM tlf_file ", 
                     " WHERE tlf01 = '",l_sfv.sfv04,"' ", 
                     "   AND tlf036 = '",l_sfv.sfv01,"' AND tlf037= ",l_sfv.sfv03," "
        DECLARE t620_u_tlf_c CURSOR FROM l_sql
        LET l_i = 0 
        CALL la_tlf.clear()
        FOREACH t620_u_tlf_c INTO g_tlf.*  
           LET l_i = l_i + 1
           LET la_tlf[l_i].* = g_tlf.*
        END FOREACH     

  ##NO.FUN-8C0131   add--end
         DELETE FROM tlf_file
          WHERE tlf01 =l_sfv.sfv04
            AND (tlf036=l_sfv.sfv01 AND tlf037=l_sfv.sfv03)
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err('del tlf',STATUS,0)
            LET g_success = 'N'
            RETURN
         END IF
    ##NO.FUN-8C0131   add--begin
         FOR l_i = 1 TO la_tlf.getlength()
            LET g_tlf.* = la_tlf[l_i].*
            IF NOT s_untlf1('') THEN 
               LET g_success='N' RETURN
            END IF 
         END FOR       
  ##NO.FUN-8C0131   add--end 
         #-----No.FUN-810036-----
         #-----No.MOD-840349-----
         SELECT ima918,ima921 INTO l_ima918,l_ima921
           FROM ima_file
          WHERE ima01 = l_sfv.sfv04
            AND imaacti = "Y"
         
         IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
         #-----No.MOD-840349 END-----
            DELETE FROM tlfs_file
             WHERE tlfs01 = l_sfv.sfv04
               AND tlfs10 = l_sfv.sfv01
               AND tlfs11 = l_sfv.sfv03
           
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN    
               CALL cl_err('del tlfs',STATUS,0)
               LET g_success = 'N'
               RETURN
            END IF
         END IF   #No.MOD-840349
         #-----No.FUN-810036 END-----
 
      END IF
      #MOD-640120...............end
      IF (g_sma.sma115 = 'Y') AND (g_success='Y') THEN
         IF l_sfv.sfv32 != 0 OR l_sfv.sfv35 != 0 THEN
            CASE p_opt
               WHEN "+"
                  CALL t620sub_update_du('s',l_sfu.sfu01,l_sfv.sfv03,p_argv)
               WHEN "-"
                  CALL t620sub_update_du('w',l_sfu.sfu01,l_sfv.sfv03,p_argv)
            END CASE
         END IF
      END IF
 
      IF g_success='Y' THEN
         CASE p_opt
            WHEN "+"
               CALL t620sub_update_s(l_sfu.sfu01,l_sfv.sfv03,p_argv)
            WHEN "-"
               CALL t620sub_update_w(l_sfu.sfu01,l_sfv.sfv03,p_argv)
         END CASE
      END IF
   END FOREACH
 
 
END FUNCTION
#FUN-5C0114...............end
 
FUNCTION t620sub_update_du(p_type,p_sfu01,p_sfv03,p_argv)
   DEFINE p_type      LIKE type_file.chr1
   DEFINE p_sfu01     LIKE sfu_file.sfu01
   DEFINE p_sfv03     LIKE sfv_file.sfv03
   DEFINE p_argv      LIKE type_file.chr1
   DEFINE l_sfv       RECORD LIKE sfv_file.*
   DEFINE l_sfu       RECORD LIKE sfu_file.*
   DEFINE l_ima25     LIKE ima_file.ima25
   DEFINE u_type      LIKE type_file.num5
   DEFINE l_ima906    LIKE ima_file.ima906
   DEFINE l_ima907    LIKE ima_file.ima907
 
   IF g_sma.sma115 = 'N' THEN RETURN END IF
 
   IF g_success = 'N' THEN RETURN END IF
   
   IF cl_null(p_sfu01) THEN LET g_success = 'N' RETURN END IF
   IF cl_null(p_sfv03) THEN LET g_success = 'N' RETURN END IF
   
   SELECT * INTO l_sfu.* FROM sfu_file
    WHERE sfu01 = p_sfu01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','sfu_file',p_sfu01,'',SQLCA.sqlcode,'','',1)
      LET g_success = 'N'
      RETURN
   END IF
   
   SELECT * INTO l_sfv.* FROM sfv_file 
    WHERE sfv01 = p_sfu01
      AND sfv03 = p_sfv03
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','sfv_file',p_sfu01,p_sfv03,SQLCA.sqlcode,'','',1)
      LET g_success = 'N'
      RETURN
   END IF
 
   IF p_type = 's' THEN
      CASE WHEN p_argv ='1' LET u_type=+1
           WHEN p_argv ='2' LET u_type=-1
           WHEN p_argv ='3' LET u_type=+1 #FUN-5C0114
      END CASE
   ELSE
      CASE WHEN p_argv ='1' LET u_type=-1
           WHEN p_argv ='2' LET u_type=+1
           WHEN p_argv ='3' LET u_type=-1 #FUN-5C0114
      END CASE
   END IF
 
   SELECT ima906,ima907 INTO l_ima906,l_ima907 FROM ima_file
    WHERE ima01 = l_sfv.sfv04
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','ima_file',l_sfv.sfv04,'',SQLCA.sqlcode,'','',1)
      LET g_success='N' 
      RETURN
   END IF
   
   SELECT ima25 INTO l_ima25 FROM ima_file
    WHERE ima01=l_sfv.sfv04
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','ima_file',l_sfv.sfv04,'',SQLCA.sqlcode,'','',1)
      LET g_success='N' 
      RETURN
   END IF
   IF l_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(l_sfv.sfv33) THEN
         CALL t620sub_upd_imgg('1',l_sfv.sfv04,l_sfv.sfv05,l_sfv.sfv06,
                         l_sfv.sfv07,l_sfv.sfv33,l_sfv.sfv34,l_sfv.sfv35,u_type,'2',l_sfu.sfu02)
         IF g_success='N' THEN RETURN END IF
         IF p_type = 's' THEN
            IF NOT cl_null(l_sfv.sfv35) AND l_sfv.sfv35 <> 0 THEN
               CALL t620sub_tlff(l_sfv.sfv05,l_sfv.sfv06,l_sfv.sfv07,l_ima25,
                              l_sfv.sfv35,0,l_sfv.sfv33,l_sfv.sfv34,u_type,'2',l_sfu.sfu01,l_sfv.sfv03,p_argv)
               IF g_success='N' THEN RETURN END IF
            END IF
         END IF
      END IF
      IF NOT cl_null(l_sfv.sfv30) THEN
         CALL t620sub_upd_imgg('1',l_sfv.sfv04,l_sfv.sfv05,l_sfv.sfv06,
                            l_sfv.sfv07,l_sfv.sfv30,l_sfv.sfv31,l_sfv.sfv32,u_type,'1',l_sfu.sfu02)
         IF g_success='N' THEN RETURN END IF
         IF p_type = 's' THEN
            IF NOT cl_null(l_sfv.sfv32) AND l_sfv.sfv32 <> 0 THEN
               CALL t620sub_tlff(l_sfv.sfv05,l_sfv.sfv06,l_sfv.sfv07,l_ima25,
                              l_sfv.sfv32,0,l_sfv.sfv30,l_sfv.sfv31,u_type,'1',l_sfu.sfu01,l_sfv.sfv03,p_argv)
               IF g_success='N' THEN RETURN END IF
            END IF
         END IF
      END IF
      IF p_type = 'w' THEN
         CALL t620sub_tlff_w(l_sfu.sfu01,l_sfu.sfu02,l_sfv.sfv03,l_sfv.sfv04)
         IF g_success='N' THEN RETURN END IF
      END IF
   END IF
   IF l_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(l_sfv.sfv33) THEN
         CALL t620sub_upd_imgg('2',l_sfv.sfv04,l_sfv.sfv05,l_sfv.sfv06,
                            l_sfv.sfv07,l_sfv.sfv33,l_sfv.sfv34,l_sfv.sfv35,u_type,'2',l_sfu.sfu02)
         IF g_success = 'N' THEN RETURN END IF
         IF p_type = 's' THEN
            IF NOT cl_null(l_sfv.sfv35) AND l_sfv.sfv35 <> 0 THEN
               CALL t620sub_tlff(l_sfv.sfv05,l_sfv.sfv06,l_sfv.sfv07,l_ima25,
                              l_sfv.sfv35,0,l_sfv.sfv33,l_sfv.sfv34,u_type,'2',l_sfu.sfu01,l_sfv.sfv03,p_argv)
               IF g_success='N' THEN RETURN END IF
            END IF
         END IF
      END IF  
      IF p_type = 'w' THEN
         CALL t620sub_tlff_w(l_sfu.sfu01,l_sfu.sfu02,l_sfv.sfv03,l_sfv.sfv04)
         IF g_success='N' THEN RETURN END IF
      END IF
   END IF
 
END FUNCTION
 
 
FUNCTION t620sub_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                       p_imgg09,p_imgg211,p_imgg10,p_type,p_no,p_sfu02)
   DEFINE p_imgg00        LIKE imgg_file.imgg00
   DEFINE p_imgg01        LIKE imgg_file.imgg01
   DEFINE p_imgg02        LIKE imgg_file.imgg02
   DEFINE p_imgg03        LIKE imgg_file.imgg03
   DEFINE p_imgg04        LIKE imgg_file.imgg04
   DEFINE p_imgg09        LIKE imgg_file.imgg09
   DEFINE p_imgg10        LIKE imgg_file.imgg10
   DEFINE p_imgg211       LIKE imgg_file.imgg211
   DEFINE p_no            LIKE type_file.chr1
   DEFINE p_type          LIKE type_file.num10
   DEFINE p_sfu02         LIKE sfu_file.sfu02
   DEFINE l_ima25         LIKE ima_file.ima25
   DEFINE l_ima906        LIKE ima_file.ima906
   DEFINE l_imgg21        LIKE imgg_file.imgg21
   DEFINE l_forupd_sql    STRING
   DEFINE l_cnt           LIKE type_file.num10

    SELECT ima25,ima906 INTO l_ima25,l_ima906
      FROM ima_file WHERE ima01=p_imgg01
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
       CALL cl_err('ima25 null',SQLCA.sqlcode,0)
       LET g_success = 'N' RETURN
    END IF
 
    CALL s_umfchk(p_imgg01,p_imgg09,l_ima25) RETURNING l_cnt,l_imgg21

    IF l_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN
       CALL cl_err('','mfg3075',0)
       LET g_success = 'N' RETURN
    END IF
    CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,p_sfu02,   #FUN-8C0084
          '','','','','','','','','','',l_imgg21,'','','','','','','',p_imgg211)
    IF g_success='N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t620sub_tlff(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,
                   u_type,p_flag,p_sfu01,p_sfv03,p_argv)
   DEFINE p_ware     LIKE img_file.img02       ##倉庫
   DEFINE p_loca     LIKE img_file.img03       ##儲位
   DEFINE p_lot      LIKE img_file.img04       ##批號
   DEFINE p_unit     LIKE img_file.img09
   DEFINE p_qty      LIKE img_file.img10       ##數量
   DEFINE p_img10    LIKE img_file.img10       ##異動後數量
   DEFINE p_uom      LIKE img_file.img09       ##img 單位
   DEFINE p_factor   LIKE img_file.img21       ##轉換率
   DEFINE u_type     LIKE type_file.num5       ##+1:雜收 -1:雜發  0:報廢
   DEFINE p_sfu01    LIKE sfu_file.sfu01
   DEFINE p_sfv03    LIKE sfv_file.sfv03
   DEFINE p_argv     LIKE type_file.chr1
   DEFINE l_sfu      RECORD LIKE sfu_file.*
   DEFINE l_sfv      RECORD LIKE sfv_file.*
   DEFINE p_flag     LIKE type_file.chr1       
   DEFINE l_imgg10   LIKE imgg_file.imgg10
#  DEFINE l_ima262   LIKE ima_file.ima262
   DEFINE l_avl_stk  LIKE type_file.num15_3    ###GP5.2  #NO.FUN-A20044
   DEFINE l_ima25    LIKE ima_file.ima25
   DEFINE l_ima55    LIKE ima_file.ima55
   DEFINE l_ima86    LIKE ima_file.ima86
   DEFINE g_cnt      LIKE type_file.num5   
   
    IF g_success = 'N' THEN RETURN END IF
    IF cl_null(p_sfu01) OR cl_null(p_sfv03) THEN LET g_success = 'N' END IF
    
    SELECT * INTO l_sfu.* FROM sfu_file
     WHERE sfu01 = p_sfu01
    IF SQLCA.sqlcode THEN
       CALL cl_err3('sel','sfu_file',p_sfu01,'',SQLCA.sqlcode,'','','1')
       LET g_success = 'N'
       RETURN
    END IF
    
    SELECT * INTO l_sfv.* FROM sfv_file
     WHERE sfv01 = p_sfu01
       AND sfv03 = p_sfv03
    IF SQLCA.sqlcode THEN
       CALL cl_err3('sel','sfv_file',p_sfu01,p_sfv03,SQLCA.sqlcode,'','','1')
       LET g_success = 'N'
       RETURN
    END IF    
 
#   CALL s_getima(l_sfv.sfv04) RETURNING l_ima262,l_ima25,l_ima55,l_ima86   #NO.FUN-A20044
    CALL s_getima(l_sfv.sfv04) RETURNING l_avl_stk,l_ima25,l_ima55,l_ima86  #NO.FUN-A20044
 
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' '  END IF
    IF cl_null(p_qty)  THEN LET p_qty=0    END IF
 
    IF p_uom IS NULL THEN
       CALL cl_err('p_uom null:','asf-031',1) LET g_success = 'N' RETURN
    END IF
 
    SELECT imgg10 INTO l_imgg10 FROM imgg_file
     WHERE imgg01=l_sfv.sfv04 AND imgg02=p_ware
       AND imgg03=p_loca      AND imgg04=p_lot
       AND imgg09=p_uom
 
    IF cl_null(l_imgg10) THEN LET l_imgg10 = 0 END IF
    INITIALIZE g_tlff.* TO NULL
    LET g_tlff.tlff01=l_sfv.sfv04         #異動料件編號
    IF (p_argv = '1') OR (p_argv = '3') THEN                #完工入庫   #FUN-5C0114 add "OR (g_argv = '3')"
       LET g_tlff.tlff02=60               #資料來源為工單
       LET g_tlff.tlff020=' '
       LET g_tlff.tlff021=' '             #倉庫別
       LET g_tlff.tlff022=' '             #儲位別
       LET g_tlff.tlff023=' '             #批號
    ELSE
       LET g_tlff.tlff02=50               #資料目的為倉庫
       LET g_tlff.tlff020=g_plant
       LET g_tlff.tlff021=p_ware          #倉庫別
       LET g_tlff.tlff022=p_loca          #儲位別
       LET g_tlff.tlff023=p_lot           #入庫批號
    END IF
   #bugno:5393,4839......................................
       LET g_tlff.tlff024=l_imgg10        #異動後庫存數量(同料件主檔之可用量)
       LET g_tlff.tlff025=p_unit          #庫存單位(同料件之庫存單位)
       LET g_tlff.tlff026=l_sfv.sfv11     #單据編號(工單單號)
       LET g_tlff.tlff027=0               #單據項次
   #bugno end............................................
 
    #  Target
    IF (p_argv = '1') OR (p_argv = '3') THEN                #完工入庫   #FUN-5C0114 add "OR (g_argv = '3')"
       LET g_tlff.tlff03=50               #資料目的為倉庫
       LET g_tlff.tlff030=g_plant
       LET g_tlff.tlff031=p_ware          #倉庫別
       LET g_tlff.tlff032=p_loca          #儲位別
       LET g_tlff.tlff033=p_lot           #入庫批號
    ELSE
       LET g_tlff.tlff03=60               #資料來源為工單
       LET g_tlff.tlff030=' '
       LET g_tlff.tlff031=' '             #倉庫別
       LET g_tlff.tlff032=' '             #儲位別
       LET g_tlff.tlff033=' '             #批號
    END IF
   #bugno:5393,4839......................................
       LET g_tlff.tlff034=l_imgg10        #異動後庫存數量(同料件主檔之可用量)
       LET g_tlff.tlff035=p_unit          #生產單位
       LET g_tlff.tlff036=l_sfu.sfu01     #參考號碼
       LET g_tlff.tlff037=l_sfv.sfv03     #項次
   #bugno end............................................
 
    LET g_tlff.tlff04=' '              #工作站
    LET g_tlff.tlff06=l_sfu.sfu02      #入庫日期
    LET g_tlff.tlff07=g_today          #異動資料產生日期
    LET g_tlff.tlff08=TIME             #異動資料產生時:分:秒
    LET g_tlff.tlff09=g_user           #產生人
    LET g_tlff.tlff10=p_qty            #入庫量
    LET g_tlff.tlff11=p_uom            #生產單位
    LET g_tlff.tlff12=p_factor         #發料/庫存轉換率
    #FUN-5C0114...............begin
 
    #IF g_argv = '1' THEN
    #   LET g_tlff.tlff13= 'asft6201'
    #ELSE
    #   LET g_tlff.tlff13= 'asft660'
    #END IF
    CASE p_argv
       WHEN "1"
          LET g_tlff.tlff13= 'asft6201'
       WHEN "2"
          LET g_tlff.tlff13= 'asft660'
       WHEN "3"
          LET g_tlff.tlff13= 'asrt320'
    END CASE
    #FUN-5C0114...............end
    LET g_tlff.tlff14=''               #原因
    LET g_tlff.tlff15=''               #借方會計科目
    LET g_tlff.tlff16=''               #貸方會計科目
    LET g_tlff.tlff17=' '              #非庫存性料件編號
    CALL s_imaQOH(l_sfv.sfv04)
         RETURNING g_tlff.tlff18       #異動後總庫存量
    LET g_tlff.tlff19= ''              #部門
    LET g_tlff.tlff20= l_sfu.sfu06     #project no.
    LET g_tlff.tlff21= ''
    LET g_tlff.tlff61= ''
    LET g_tlff.tlff62= l_sfv.sfv11     #單据編號(工單單號)
    LET g_tlff.tlff63= ''
    LET g_tlff.tlff64= ''
    LET g_tlff.tlff65= ''
    LET g_tlff.tlff66= ''
    LET g_tlff.tlff930=l_sfv.sfv930  #FUN-670103
    IF cl_null(l_sfv.sfv35) OR l_sfv.sfv35=0 THEN
       CALL s_tlff(p_flag,NULL)
    ELSE
       CALL s_tlff(p_flag,l_sfv.sfv33)
    END IF
END FUNCTION
 
FUNCTION t620sub_tlff_w(p_sfu01,p_sfu02,p_sfv03,p_sfv04)
   DEFINE p_sfu01       LIKE sfu_file.sfu01
   DEFINE p_sfu02       LIKE sfu_file.sfu02
   DEFINE p_sfv03       LIKE sfv_file.sfv03
   DEFINE p_sfv04       LIKE sfv_file.sfv04
 
    CALL cl_msg("d_tlff!")
    CALL ui.Interface.refresh()
 
    DELETE FROM tlff_file
     WHERE tlff01 =p_sfv04
       AND ((tlff026=p_sfu01 AND tlff027=p_sfv03) OR
            (tlff036=p_sfu01 AND tlff037=p_sfv03)) #異動單號/項次
       AND tlff06 =p_sfu02 #異動日期
 
    IF STATUS THEN
       CALL cl_err('del tlff:',STATUS,1) LET g_success='N' RETURN
    END IF
END FUNCTION
 
#FUN-540055  --end
 
FUNCTION t620sub_update_s(p_sfu01,p_sfv03,p_argv)
  DEFINE p_sfu01       LIKE sfu_file.sfu01
  DEFINE p_sfv03       LIKE sfv_file.sfv03
  DEFINE p_argv        LIKE type_file.chr1
  DEFINE p_ware        LIKE img_file.img02
  DEFINE p_loca        LIKE img_file.img03
  DEFINE p_lot         LIKE img_file.img04
  DEFINE p_qty         LIKE img_file.img10        ##數量
  DEFINE p_uom         LIKE img_file.img09        ##img 單位
  DEFINE p_factor      LIKE ima_file.ima31_fac    ##轉換率
  DEFINE l_qty         LIKE img_file.img10        ##異動後數量
  DEFINE l_ima01       LIKE ima_file.ima01
  DEFINE l_ima25       LIKE ima_file.ima25
  DEFINE l_ima55       LIKE ima_file.ima55
# DEFINE l_imaqty      LIKE ima_file.ima262
  DEFINE l_imaqty      LIKE type_file.num15_3     ###GP5.2  #NO.FUN-A20044
  DEFINE l_imafac      LIKE img_file.img21
  DEFINE u_type        LIKE type_file.num5        ##+1:入庫 -1:入庫退回
  DEFINE l_img         RECORD
                       img10   LIKE img_file.img10,
                       img16   LIKE img_file.img16,
                       img23   LIKE img_file.img23,
                       img24   LIKE img_file.img24,
                       img09   LIKE img_file.img09,
                       img21   LIKE img_file.img21
                       END RECORD
  DEFINE l_img09       LIKE img_file.img09  
  DEFINE l_sfu         RECORD LIKE sfu_file.*
  DEFINE l_sfv         RECORD LIKE sfv_file.*
  DEFINE l_i           LIKE type_file.num5  
  DEFINE l_ima86       LIKE ima_file.ima86
  DEFINE l_cnt         LIKE type_file.num10
  DEFINE l_sql         STRING
  DEFINE l_msg         STRING                     #FUN-980043      

    IF g_success = 'N' THEN RETURN END IF
    IF cl_null(p_sfu01) OR cl_null(p_sfv03) THEN LET g_success = 'N' END IF
    
    SELECT * INTO l_sfu.* FROM sfu_file
     WHERE sfu01 = p_sfu01
    IF SQLCA.sqlcode THEN
       CALL cl_err3('sel','sfu_file',p_sfu01,'',SQLCA.sqlcode,'','','1')
       LET g_success = 'N'
       RETURN
    END IF
    
    SELECT * INTO l_sfv.* FROM sfv_file
     WHERE sfv01 = p_sfu01
       AND sfv03 = p_sfv03
    IF SQLCA.sqlcode THEN
       CALL cl_err3('sel','sfv_file',p_sfu01,p_sfv03,SQLCA.sqlcode,'','','1')
       LET g_success = 'N'
       RETURN
    END IF 
    
    LET p_ware = l_sfv.sfv05
    LET p_loca = l_sfv.sfv06
    LET p_lot  = l_sfv.sfv07
    LET p_qty  = l_sfv.sfv09
    LET p_uom  = l_sfv.sfv08
     
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' '  END IF
    IF cl_null(p_qty)  THEN LET p_qty=0    END IF
                                   #生產單位
    #No:9697
    IF cl_null(l_sfv.sfv06) THEN LET l_sfv.sfv06=' ' END IF
    IF cl_null(l_sfv.sfv07) THEN LET l_sfv.sfv07=' ' END IF
    #No:9697
 
## No:2572 modify 1998/10/20 ----------------------------------
    SELECT img09 INTO l_img09 FROM img_file
     WHERE img01=l_sfv.sfv04 AND img02=l_sfv.sfv05
       AND img03=l_sfv.sfv06 AND img04=l_sfv.sfv07
    IF STATUS THEN
       CALL cl_err('sel img09',status,1) LET g_success = 'N' RETURN
    END IF
## --------------------------------------------------------------
 
    CALL s_umfchk(l_sfv.sfv04,p_uom,l_img09) RETURNING l_i,p_factor
    IF l_i = 1 THEN
        ###Modify:98/11/15 ----庫存/料號單位無法轉換 ------####
        #CALL cl_err('庫存/料號單位無法轉換',STATUS,1)
       #CALL cl_err('sfv08/img09: ','abm-731',1) #FUN-980043                                                                       
        LET l_msg=p_sfv03,'',l_sfv.sfv04,'','sfv08/img09: ' #FUN-980043                                                                    
        CALL cl_err(l_msg,'abm-731',1)       #FUN-980043  
        LET g_success ='N'
    END IF
    IF p_uom IS NULL THEN
       CALL cl_err('p_uom null:','asf-031',1) LET g_success = 'N' RETURN
    END IF

    # update img_file
    CALL cl_msg("update img_file ...")
 
     LET g_forupd_sql = "SELECT img10,img16,img23,img24,img09,img21 ",  #091021 mark
                       "FROM img_file",
                       " WHERE img01= ? AND img02= ? AND img03= ? AND img04= ? ",
                       " FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img_lock CURSOR FROM g_forupd_sql
 
    OPEN img_lock USING l_sfv.sfv04,p_ware,p_loca, p_lot
    IF STATUS THEN
       CALL cl_err('lock img fail',STATUS,1) LET g_success='N' RETURN
    END IF
 
    FETCH img_lock INTO l_img.*
    IF STATUS THEN
       CALL cl_err('lock img fail',STATUS,1) LET g_success='N' RETURN
    END IF
 
    IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
 
    IF p_argv = '2' THEN    #退回
       LET l_qty= l_img.img10 - p_qty
       IF l_qty < 0 THEN  #庫存不足, Fail
          IF NOT cl_confirm('mfg3469') THEN  LET g_success='N' RETURN END IF
       END IF
    END IF
 
    CASE WHEN p_argv = '1' LET u_type = +1
         WHEN p_argv = '2' LET u_type = -1
         WHEN p_argv = '3' LET u_type = +1 #FUN-5C0114
    END CASE
 
    #FUN-550011................begin
    IF u_type = -1 THEN
      #FUN-D30024--modify--str--
      #IF NOT s_stkminus(l_sfv.sfv04,l_sfv.sfv05,l_sfv.sfv06,l_sfv.sfv07,
      #                  l_sfv.sfv09,p_factor,l_sfu.sfu02,g_sma.sma894[3,3]) THEN
       IF NOT s_stkminus(l_sfv.sfv04,l_sfv.sfv05,l_sfv.sfv06,l_sfv.sfv07,
                         l_sfv.sfv09,p_factor,l_sfu.sfu02) THEN
      #FUN-D30024--modify--end--
          LET g_success='N'
          RETURN
       END IF
    END IF
 
    CALL s_upimg(l_sfv.sfv04,p_ware,p_loca,p_lot,u_type,p_qty*p_factor,g_today,  #FUN-8C0084
                 '','','','',l_sfv.sfv01,l_sfv.sfv03,   #No.MOD-860261
                 '','','','','','','','','','','','')
    IF g_success='N' THEN RETURN END IF

    #update ima_file
    CALL cl_msg("update ima_file ...")
 
    LET g_forupd_sql= "SELECT ima25,ima86 FROM ima_file WHERE ima01= ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE ima_lock CURSOR FROM g_forupd_sql
 
    OPEN ima_lock USING l_sfv.sfv04
    IF STATUS THEN
       CALL cl_err('lock ima fail',STATUS,1) LET g_success='N' RETURN
    END IF
 
    FETCH ima_lock INTO l_ima25,l_ima86
    IF STATUS THEN
       CALL cl_err('lock ima fail',STATUS,1) LET g_success='N' RETURN
    END IF
    IF l_sfv.sfv08=l_ima25 THEN
       LET l_imafac = 1
    ELSE
       CALL s_umfchk(l_sfv.sfv04,l_sfv.sfv08,l_ima25)
                RETURNING l_cnt,l_imafac
    END IF
    IF cl_null(l_imafac)  THEN
       ####Modify:98/11/15 ----庫存/料號無法轉換 -------###
       #CALL cl_err('庫存/料號單位無法轉換',STATUS,1)
      #CALL cl_err('sfv08/ima25: ','abm-731',1) #FUN-980043                                                                      
       LET l_msg=p_sfv03,'',l_sfv.sfv04,'','sfv08/img25: ' #FUN-980043                                                                      
       CALL cl_err(l_msg,'abm-731',1)       #FUN-980043       
       LET g_success ='N'
       ####LET l_imafac = 1
    END IF
    LET l_imaqty = p_qty * l_imafac
    CALL s_udima(l_sfv.sfv04,l_img.img23,l_img.img24,l_imaqty,
                    l_sfu.sfu02,u_type)  RETURNING l_cnt #MOD-A90120 mod g_today->l_sfu.sfu02
    IF g_success='N' THEN RETURN END IF
    #sfv
#------------------------------------------- insert tlf_file
    CALL cl_msg("insert tlf_file ...")
    IF g_success='Y' THEN
       CALL t620sub_tlf(p_factor,l_sfu.sfu01,l_sfv.sfv03,p_argv)
    END IF
    LET l_sql="seq#",l_sfv.sfv03 USING'<<<',' post ok!'
    CALL cl_msg(l_sql)
END FUNCTION
 
 
FUNCTION t620sub_tlf(p_factor,p_sfu01,p_sfv03,p_argv)
  DEFINE p_sfu01       LIKE sfu_file.sfu01
  DEFINE p_sfv03       LIKE sfv_file.sfv03
  DEFINE p_argv        LIKE type_file.chr1
  DEFINE l_sfu         RECORD LIKE sfu_file.*
  DEFINE l_sfv         RECORD LIKE sfv_file.*
# DEFINE l_ima262      LIKE ima_file.ima262
  DEFINE l_avl_stk     LIKE type_file.num15_3    ###GP5.2  #NO.FUN-A20044
  DEFINE l_ima25       LIKE ima_file.ima25
  DEFINE l_ima55       LIKE ima_file.ima55
  DEFINE l_ima86       LIKE ima_file.ima86
  DEFINE p_factor      LIKE ima_file.ima31_fac ##轉換率
  DEFINE p_img10       LIKE img_file.img10     #異動後數量
  DEFINE l_img09       LIKE img_file.img09     #No: MOD-570344 add
  DEFINE l_sfb97       LIKE sfb_file.sfb97
 
    IF g_success = 'N' THEN RETURN END IF
    IF cl_null(p_sfu01) OR cl_null(p_sfv03) THEN LET g_success = 'N' END IF
    
    SELECT * INTO l_sfu.* FROM sfu_file
     WHERE sfu01 = p_sfu01
    IF SQLCA.sqlcode THEN
       CALL cl_err3('sel','sfu_file',p_sfu01,'',SQLCA.sqlcode,'','','1')
       LET g_success = 'N'
       RETURN
    END IF
    
    SELECT * INTO l_sfv.* FROM sfv_file
     WHERE sfv01 = p_sfu01
       AND sfv03 = p_sfv03
    IF SQLCA.sqlcode THEN
       CALL cl_err3('sel','sfv_file',p_sfu01,p_sfv03,SQLCA.sqlcode,'','','1')
       LET g_success = 'N'
       RETURN
    END IF 
 
    INITIALIZE g_tlf.* TO NULL
 
#   CALL s_getima(l_sfv.sfv04) RETURNING l_ima262,l_ima25,l_ima55,l_ima86   #NO.FUN-A20044
    CALL s_getima(l_sfv.sfv04) RETURNING l_avl_stk,l_ima25,l_ima55,l_ima86  #NO.FUN-A20044
   #--No.MOD-570344
    SELECT img09,img10 INTO l_img09,p_img10 FROM img_file
         WHERE img01 = l_sfv.sfv04 AND img02 = l_sfv.sfv05
           AND img03 = l_sfv.sfv06 AND img04 = l_sfv.sfv07
   #--No.MOD-570344 end
  #----------------No.MOD-930013 add
   LET l_sfb97 = NULL
   SELECT sfb97 INTO l_sfb97 FROM sfb_file WHERE sfb01=l_sfv.sfv11
  #----------------No.MOD-930013 end
 
    #  Source
    LET g_tlf.tlf01=l_sfv.sfv04      #異動料件編號
    IF (p_argv = '1') OR (p_argv = '3') THEN                #完工入庫  #FUN-5C0114 add "OR (g_argv = '3')"
       LET g_tlf.tlf02=60               #資料來源為工單
       LET g_tlf.tlf020=' '
       LET g_tlf.tlf021=' '             #倉庫別
       LET g_tlf.tlf022=' '             #儲位別
       LET g_tlf.tlf023=' '             #批號
    ELSE
       LET g_tlf.tlf02=50               #資料目的為倉庫
       LET g_tlf.tlf020=g_plant
       LET g_tlf.tlf021=l_sfv.sfv05     #倉庫別
       LET g_tlf.tlf022=l_sfv.sfv06     #儲位別
       LET g_tlf.tlf023=l_sfv.sfv07     #入庫批號
    END IF
   #bugno:5393,4839......................................
        #---No.MOD-570344 modify
       #LET g_tlf.tlf024=l_ima262        #異動後庫存數量(同料件主檔之可用量)
       #LET g_tlf.tlf025=l_ima25         #庫存單位(同料件之庫存單位)
       LET g_tlf.tlf024=p_img10
       LET g_tlf.tlf025=l_img09
       #--No.MOD-570344 end
       LET g_tlf.tlf026=l_sfv.sfv11     #單据編號(工單單號)
       LET g_tlf.tlf027=0               #單據項次
   #bugno end............................................
 
    #  Target
    IF (p_argv = '1') OR (p_argv = '3') THEN                #完工入庫  #FUN-5C0114 add "OR (g_argv = '3')"
       LET g_tlf.tlf03=50               #資料目的為倉庫
       LET g_tlf.tlf030=g_plant
       LET g_tlf.tlf031=l_sfv.sfv05     #倉庫別
       LET g_tlf.tlf032=l_sfv.sfv06     #儲位別
       LET g_tlf.tlf033=l_sfv.sfv07     #入庫批號
    ELSE
       LET g_tlf.tlf03=60               #資料來源為工單
       LET g_tlf.tlf030=' '
       LET g_tlf.tlf031=' '             #倉庫別
       LET g_tlf.tlf032=' '             #儲位別
       LET g_tlf.tlf033=' '             #批號
    END IF
   #bugno:5393,4839......................................
        #---No.MOD-570344 modify
       #LET g_tlf.tlf034=l_ima262        #異動後庫存數量(同料件主檔之可用量)
       #LET g_tlf.tlf035=l_ima25         #庫存單位(同料件之庫存單位)
       LET g_tlf.tlf034=p_img10
       LET g_tlf.tlf035=l_img09
       #--No.MOD-570344 end
       LET g_tlf.tlf036=l_sfu.sfu01     #參考號碼
       LET g_tlf.tlf037=l_sfv.sfv03     #項次
   #bugno end............................................
 
    LET g_tlf.tlf04=' '              #工作站
    LET g_tlf.tlf06=l_sfu.sfu02      #入庫日期
    LET g_tlf.tlf07=g_today          #異動資料產生日期
    LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
    LET g_tlf.tlf09=g_user           #產生人
    LET g_tlf.tlf10=l_sfv.sfv09      #入庫量
    LET g_tlf.tlf11=l_sfv.sfv08      #生產單位
    LET g_tlf.tlf12=p_factor         #發料/庫存轉換率
    #FUN-5C0114...............begin
 
    #IF g_argv = '1' THEN
    #   LET g_tlf.tlf13= 'asft6201'
    #ELSE
    #   LET g_tlf.tlf13= 'asft660'
    #END IF
    CASE p_argv
       WHEN "1"
          LET g_tlf.tlf13= 'asft6201'
       WHEN "2"
          LET g_tlf.tlf13= 'asft660'
       WHEN "3"
          LET g_tlf.tlf13= 'asrt320'
    END CASE
    #FUN-5C0114...............end
    #LET g_tlf.tlf14=''               #原因  #FUN-CB0087
    LET g_tlf.tlf14=l_sfv.sfv44       #原因  #FUN-CB0087
    LET g_tlf.tlf15=''               #借方會計科目
    LET g_tlf.tlf16=''               #貸方會計科目
    LET g_tlf.tlf17=' '              #非庫存性料件編號
    CALL s_imaQOH(l_sfv.sfv04)
         RETURNING g_tlf.tlf18       #異動後總庫存量
   #start FUN-5B0077
   #LET g_tlf.tlf19= ''              #部門
    SELECT ccz06 INTO g_ccz.ccz06 FROM ccz_file
    IF g_ccz.ccz06 ='2' THEN
       LET g_tlf.tlf19= l_sfu.sfu04  #部門
    END IF
   #end FUN-5B0077
    #LET g_tlf.tlf20= l_sfu.sfu06     #project no.  #FUN-810045
    LET g_tlf.tlf21= ''
    LET g_tlf.tlf61= ''
    LET g_tlf.tlf62= l_sfv.sfv11     #單据編號(工單單號)
    LET g_tlf.tlf63= ''
    LET g_tlf.tlf64= l_sfb97         #No.MOD-930013 modify
    LET g_tlf.tlf65= ''
    LET g_tlf.tlf66= ''
    LET g_tlf.tlf930=l_sfv.sfv930  #FUN-670103
 
   #FUN-810045 add begin
    LET g_tlf.tlf20 = l_sfv.sfv41
    LET g_tlf.tlf41 = l_sfv.sfv42
    LET g_tlf.tlf42 = l_sfv.sfv43
    LET g_tlf.tlf43 = l_sfv.sfv44
   #FUN-810045 add end
 
    CALL s_tlf(1,0)                  #1:需取得標準成本 0:不需詢問原因
END FUNCTION
 
FUNCTION t620sub_update_w(p_sfu01,p_sfv03,p_argv)
  DEFINE p_sfu01       LIKE sfu_file.sfu01
  DEFINE p_sfv03       LIKE sfv_file.sfv03
  DEFINE p_argv        LIKE type_file.chr1  
  DEFINE p_ware        LIKE img_file.img02
  DEFINE p_loca        LIKE img_file.img03
  DEFINE p_lot         LIKE img_file.img04
  DEFINE p_qty         LIKE img_file.img10        ##數量
  DEFINE p_uom         LIKE img_file.img09        ##img 單
  DEFINE u_type        LIKE type_file.num5        ##-1:入庫 +1:入庫退回
  DEFINE p_factor      LIKE ima_file.ima31_fac    ##轉換率
  DEFINE l_qty         LIKE img_file.img10        ##異動後數量
  DEFINE l_ima01       LIKE ima_file.ima01
  DEFINE l_ima25       LIKE ima_file.ima25
  DEFINE l_ima55       LIKE ima_file.ima55
# DEFINE l_imaqty      LIKE ima_file.ima262
  DEFINE l_imaqty      LIKE type_file.num15_3     ###GP5.2  #NO.FUN-A20044
  DEFINE l_imafac      LIKE img_file.img21
  DEFINE l_img         RECORD
                       img10   LIKE img_file.img10,
                       img16   LIKE img_file.img16,
                       img23   LIKE img_file.img23,
                       img24   LIKE img_file.img24,
                       img09   LIKE img_file.img09,
                       img21   LIKE img_file.img21
                       END RECORD
  DEFINE l_img09       LIKE img_file.img09  
  DEFINE l_sfu         RECORD LIKE sfu_file.*
  DEFINE l_sfv         RECORD LIKE sfv_file.*
  DEFINE l_i           LIKE type_file.num5  
  DEFINE l_ima86       LIKE ima_file.ima86
  DEFINE l_cnt         LIKE type_file.num10
  DEFINE l_forupd_sql  STRING
  DEFINE l_msg         STRING                       #FUN-980043        
    IF g_success = 'N' THEN RETURN END IF
    IF cl_null(p_sfu01) OR cl_null(p_sfv03) THEN LET g_success = 'N' END IF
    
    SELECT * INTO l_sfu.* FROM sfu_file
     WHERE sfu01 = p_sfu01
    IF SQLCA.sqlcode THEN
       CALL cl_err3('sel','sfu_file',p_sfu01,'',SQLCA.sqlcode,'','','1')
       LET g_success = 'N'
       RETURN
    END IF
    
    SELECT * INTO l_sfv.* FROM sfv_file
     WHERE sfv01 = p_sfu01
       AND sfv03 = p_sfv03
    IF SQLCA.sqlcode THEN
       CALL cl_err3('sel','sfv_file',p_sfu01,p_sfv03,SQLCA.sqlcode,'','','1')
       LET g_success = 'N'
       RETURN
    END IF 
    
    LET p_ware = l_sfv.sfv05
    LET p_loca = l_sfv.sfv06
    LET p_lot  = l_sfv.sfv07
    LET p_qty  = l_sfv.sfv09
    LET p_uom  = l_sfv.sfv08
 
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' ' END IF
    IF cl_null(p_qty)  THEN LET p_qty=0 END IF
 
   #TQC-D40080--mark--str---
   #SELECT img09 INTO l_img09 FROM img_file
   # WHERE img01=l_sfv.sfv04 AND img02=l_sfv.sfv05
   #   AND img03=l_sfv.sfv06 AND img04=l_sfv.sfv07
   #TQC-D40080--mark--end---
   #TQC-D40080--add--str---
    SELECT img09 INTO l_img09 FROM img_file
     WHERE img01=l_sfv.sfv04 AND img02=p_ware
       AND img03=p_loca AND img04=p_lot
   #TQC-D40080--add--end---
    IF STATUS THEN
       CALL cl_err('sel img09',status,1)
       LET g_success = 'N'
       RETURN
    END IF
 
    CALL s_umfchk(l_sfv.sfv04,p_uom,l_img09) RETURNING l_i,p_factor
    IF l_i = 1 THEN
        ####Modify:98/11/15 ----庫存/料號單位無法轉換-----###
        #CALL cl_err('庫存/料號單位無法轉換',STATUS,1)
       #CALL cl_err('sfv08/img09: ','abm-731',1) #FUN-980043                                                                     
        LET l_msg=p_sfv03,'',l_sfv.sfv04,'','sfv08/img09: ' #FUN-980043                                                                     
        CALL cl_err(l_msg,'abm-731',1)       #FUN-980043 
        LET g_success ='N'
    END IF
 
    IF p_uom IS NULL THEN
       CALL cl_err('p_uom null:','asf-031',1)
       LET g_success = 'N'
       RETURN
    END IF
 
    CALL cl_msg("update img_file ...")
 
    LET g_forupd_sql = "SELECT img10,img16,img23,img24,img09,img21",  #091021 
                       " FROM img_file ",
                       " WHERE img01= ? AND img02 = ? AND img03= ? AND img04= ?",
                       " FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img_lock_w CURSOR FROM g_forupd_sql
 
    OPEN img_lock_w USING l_sfv.sfv04,p_ware,p_loca,p_lot
    IF STATUS THEN
       CALL cl_err('lock img fail',STATUS,1) LET g_success='N' RETURN
    END IF
 
    FETCH img_lock_w INTO l_img.*
    IF STATUS THEN
       CALL cl_err('lock img fail',STATUS,1) LET g_success='N' RETURN
    END IF
 
    IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
    CASE WHEN p_argv = '1' LET u_type = -1
         WHEN p_argv = '2' LET u_type = +1
         WHEN p_argv = '3' LET u_type = -1 #FUN-5C0114
    END CASE
    CALL s_upimg(l_sfv.sfv04,p_ware,p_loca,p_lot,u_type,p_qty*p_factor,g_today,  #FUN-8C0084
                 '','','','',l_sfv.sfv01,l_sfv.sfv03,   #No.MOD-860261
                 '','','','','','','','','','','','')
    IF g_success='N' THEN RETURN END IF
 
    #update ima_file
    CALL cl_msg("update ima_file ...")
 
    LET g_forupd_sql = "SELECT ima25,ima86 FROM ima_file ",
                       " WHERE ima01= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE ima_lock_w CURSOR FROM g_forupd_sql
 
    OPEN ima_lock_w USING l_sfv.sfv04
    IF STATUS THEN
       CALL cl_err('lock ima fail',STATUS,1) LET g_success='N' RETURN
    END IF
 
    FETCH ima_lock_w INTO l_ima25,l_ima86
    IF STATUS THEN
       CALL cl_err('lock ima fail',STATUS,1) LET g_success='N' RETURN
    END IF
 
    IF l_sfv.sfv08=l_ima25 THEN
       LET l_imafac = 1
    ELSE
       CALL s_umfchk(l_sfv.sfv04,l_sfv.sfv08,l_ima25)
                RETURNING l_cnt,l_imafac
    END IF
    IF cl_null(l_imafac)  THEN
       ###Modify:98/11/15 -----單位無法轉換 -----####
      #CALL cl_err('','abm-731',1) #FUN-980043                                                                                      
       LET l_msg=p_sfv03,'',l_sfv.sfv04,'' #FUN-980043                                                                                      
       CALL cl_err(l_msg,'abm-731',1)       #FUN-980043    
       LET g_success ='N'
       ####LET l_imafac = 1
    END IF
 
    LET l_imaqty = p_qty * l_imafac
    CALL s_udima(l_sfv.sfv04,l_img.img23,l_img.img24,l_imaqty,l_sfu.sfu02,u_type) #MOD-A90120 mod g_today->l_sfu.sfu02
         RETURNING l_cnt
    IF g_success='N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t620sub_s1(p_sfu01,p_argv)
  DEFINE p_sfu01    LIKE sfu_file.sfu01
  DEFINE p_argv     LIKE type_file.chr1
  DEFINE l_sfu      RECORD LIKE sfu_file.*
  DEFINE l_sfv      RECORD LIKE sfv_file.*
  DEFINE l_sfb      RECORD LIKE sfb_file.*
  DEFINE l_sfv091   LIKE sfv_file.sfv09,
         l_sfv092   LIKE sfv_file.sfv09,
         l_sfv09    LIKE sfv_file.sfv09,
         l_qcf091   LIKE qcf_file.qcf091,
         l_str      LIKE type_file.chr20,         #No.FUN-680121 SMALLINT #No.MOD-5B0054 add
         l_cnt      LIKE type_file.num5,          #No.MOD-5B0054 add        #No.FUN-680121 SMALLINT
         s_sfv09    LIKE sfv_file.sfv09
  DEFINE l_flag     LIKE type_file.num5                 #FUN-810038
  DEFINE l_ima153   LIKE ima_file.ima153   #FUN-910053 
  DEFINE l_min_set  LIKE sfb_file.sfb08
  DEFINE l_ecm311   LIKE ecm_file.ecm311
  DEFINE l_ecm315   LIKE ecm_file.ecm315
  DEFINE l_ecm_out  LIKE ecm_file.ecm311
  DEFINE l_date     LIKE sfu_file.sfu02    #No:MOD-940257 add
  DEFINE l_sfb39    LIKE sfb_file.sfb39    #No:MOD-940257 add
  DEFINE l_sfb05    LIKE sfb_file.sfb05    #MOD-C70211 add
  DEFINE l_ecm012   LIKE ecm_file.ecm012  #FUN-A50066
  DEFINE l_ecm03    LIKE ecm_file.ecm03   #FUN-A50066 
  DEFINE l_sfvi     RECORD LIKE sfvi_file.*    #TQC-B80005
  
  CALL s_showmsg_init()   #No.FUN-6C0083 
  
  IF g_success='N' THEN RETURN END IF
  SELECT * INTO l_sfu.* FROM sfu_file WHERE sfu01 = p_sfu01
   
  DECLARE t620sub_s1_c CURSOR FOR
   SELECT * FROM sfv_file WHERE sfv01=l_sfu.sfu01
 
  FOREACH t620sub_s1_c INTO l_sfv.*
     IF cl_null(l_sfv.sfv04) THEN
        LET g_success='N'
        CONTINUE FOREACH
     END IF
    #----------------No:MOD-940257 add
     SELECT sfb39 INTO l_sfb39 FROM sfb_file WHERE sfb01=l_sfv.sfv11
     IF l_sfb39 != '2' THEN
        #檢查工單最小發料日是否小於入庫日
        SELECT MIN(sfp03) INTO l_date FROM sfe_file,sfp_file  
         WHERE sfe01 = l_sfv.sfv11 AND sfe02 = sfp01
        IF STATUS OR cl_null(l_date) THEN
           SELECT MIN(sfp03) INTO l_date FROM sfs_file,sfp_file
            WHERE sfs03=l_sfv.sfv11 AND sfp01=sfs01
        END IF
      
        IF cl_null(l_date) OR l_date > l_sfu.sfu02 THEN
           LET g_success='N'
           CALL cl_err(l_sfv.sfv11,'asf-824',1)
           EXIT FOREACH
        END IF
     END IF
    #----------------No:MOD-940257 end
      
     IF l_sfv.sfv16= 'N' THEN   #TQC-630246
#-------No.MOD-5B0054 begin
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt FROM sfb_file
         WHERE sfb01=l_sfv.sfv11 AND sfb05=l_sfv.sfv04
        IF l_cnt <= 0 THEN
           LET l_str ="Line No:",l_sfv.sfv03 USING "<<<<<"
           CALL cl_err(l_str,'asf-968',1)
           LET g_success='N'
           CONTINUE FOREACH
        END IF
#------No.MOD-5B0054 end
     END IF   #TQC-630246 
 
     #---->聯產品
     #認定聯產品的時機點為:2.完工入庫
     IF g_sma.sma105 = '2' THEN
        SELECT COUNT(*) INTO l_cnt
          FROM bmm_file,sfb_file
         WHERE sfb01 = l_sfv.sfv11  #工單編號   #No:7813 modify
           AND bmm01 = sfb05        #主件編號
           AND bmm03 = l_sfv.sfv04  #聯產品料號
           AND bmm05 = 'N'          #無效
        IF l_cnt >= 1 THEN
           #存在無效的聯產品料號,請檢查此完工入庫單資料正確否
           CALL cl_err(l_sfv.sfv04,'aqc-424',1)
           LET g_success = 'N'
           RETURN
        END IF
     END IF
 
     IF l_sfv.sfv09 = 0  THEN  
        CALL cl_err(l_sfv.sfv09,'asf-660',1)
        LET g_success = 'N'
        EXIT FOREACH
     END IF
 
     SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01=l_sfv.sfv11
 
#----No.B363
     IF l_sfb.sfb04='8' THEN
        CALL cl_err(l_sfb.sfb01,'mfg3430',1)
        LET g_success='N'
        EXIT FOREACH
     END IF
#----No.B363 END
 
#----入庫量不可大於FQC量
     IF p_argv = '1' THEN   #入庫
        LET l_sfv09=0     #已 key 之入庫量(不分是否已過帳)
       #應抓取該張工單在別張完工入庫量已過帳的數量並加上此張要過帳的數量後再與最小套數相比
        SELECT SUM(sfv09) INTO l_sfv09 FROM sfv_file,sfu_file
         WHERE sfv11 = l_sfv.sfv11
           AND sfv01 = sfu01
           AND sfu00 = '1'           #完工入庫
           AND sfuconf <> 'X' #FUN-660137
           AND sfupost = 'Y'          #MOD-AB0148 add
           #AND sfu01 != g_sfu.sfu01   #MOD-AB0148 add  #MOD-BA0161
           AND sfu01 != l_sfv.sfv01   #MOD-BA0161
         # AND sfu01 != g_sfu.sfu01   #No.B218 010508 mark
        IF l_sfv09 IS NULL THEN LET l_sfv09 =0 END IF
        LET l_sfv09 = l_sfv09 + l_sfv.sfv09     #MOD-AB0148 add
 
        LET l_min_set=0
        IF l_sfb.sfb39 != '2' THEN
           SELECT sfb05 INTO l_sfb05 FROM sfb_file WHERE sfb01 = l_sfv.sfv11   #MOD-C70211 add
          #CALL s_get_ima153(l_sfv.sfv04) RETURNING l_ima153  #FUN-910053      #MOD-C70211 mark
           CALL s_get_ima153(l_sfb05) RETURNING l_ima153                       #MOD-C70211 add  
           #工單完工方式為'2' pull 不check min_set
           #CALL s_minp(l_sfv.sfv11,g_sma.sma73,g_sma.sma74,'') #FUN-910053
           # CALL s_minp(l_sfv.sfv11,g_sma.sma73,l_ima153,'')    #FUN-910053
        #  CALL s_minp(l_sfv.sfv11,g_sma.sma73,l_ima153,'','','')    #FUN-A60027 #FUN-C70037 mark
           CALL s_minp(l_sfv.sfv11,g_sma.sma73,l_ima153,'','','',l_sfu.sfu02)    #FUN-C70037 
                        RETURNING l_cnt,l_min_set
            IF l_cnt !=0  THEN
               CALL cl_err(l_sfv.sfv09,'asf-549',1)
               LET g_success = 'N'
               CONTINUE FOREACH
            END IF
 
 #W/O 總入庫量大於最小套數 --
            IF l_sfb.sfb93='N' THEN
               IF l_sfv09 > l_min_set THEN
                  IF g_sma.sma73 = 'Y' THEN  #MOD-8B0261 add
                     CALL cl_err(l_sfv.sfv11,'asf-668',1)
                  ELSE                                    #MOD-8B0261 add
                     CALL cl_err(l_sfv.sfv11,'asf-714',1) #MOD-8B0261 add
                  END IF   #MOD-8B0261 add
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
            END IF
        END IF
 
        IF l_sfb.sfb93='Y' # 製程否
           #check 最終製程之總轉出量(良品轉出量+Bonus)
           THEN      #
           CALL s_schdat_max_ecm03(l_sfv.sfv11) RETURNING l_ecm012,l_ecm03  #FUN-A50066
           SELECT ecm311,ecm315 INTO l_ecm311,l_ecm315 FROM ecm_file
            WHERE ecm01=l_sfv.sfv11
             #AND ecm03= (SELECT MAX(ecm03) FROM ecm_file
             #             WHERE ecm01=l_sfv.sfv11)
              AND ecm012= l_ecm012  #FUN-A50066
              AND ecm03 = l_ecm03   #FUN-A50066

           IF STATUS THEN LET l_ecm311=0 LET l_ecm315=0 END IF
           LET l_ecm_out=l_ecm311 + l_ecm315
           IF l_sfv09 > l_ecm_out THEN
              #FUN-A80102(S)
              IF g_sma.sma1434 ='Y' THEN
                 #處理自動報工
                 IF NOT t620sub_gen_shb(l_sfv.*,l_sfu.sfu02,l_sfv.sfv11,l_ecm012,l_ecm03,l_sfv09-l_ecm_out) THEN
                    LET g_totsuccess='N'
                    LET g_success="Y"
                    EXIT FOREACH
                 END IF
              ELSE
              #FUN-A80102(E)
                 CALL cl_err(l_sfv.sfv03,'asf-675',1)
                 LET g_success = 'N'
                 EXIT FOREACH
              END IF
           END IF
         END IF
     END IF
 
#FUN-560195-modify
#IF l_sfb.sfb94='Y' 使用FQC功能
     IF l_sfb.sfb94='Y' AND g_sma.sma896='Y' THEN
        LET l_sfv09 = 0
        SELECT SUM(sfv09) INTO l_sfv09 FROM sfv_file,sfu_file
         WHERE sfv11 = l_sfv.sfv11
           AND sfv01 = sfu01
           AND sfv17 = l_sfv.sfv17             #No.MOD-6C0156 add
           AND sfu00 = '1'   #完工入庫
           AND sfuconf <> 'X' #FUN-660137
        IF l_sfv09 IS NULL THEN LET l_sfv09 =0 END IF
 
        SELECT qcf091 INTO l_qcf091 FROM qcf_file   # QC
         WHERE qcf01 = l_sfv.sfv17        #FUN-550085
           AND qcf09 <> '2'               #accept #NO:6872
           AND qcf14 = 'Y'
        IF l_qcf091 IS NULL THEN LET l_qcf091 = 0 END IF
 
        IF l_sfv09 > l_qcf091 THEN
           CALL cl_err(l_sfv.sfv17,'asf-660',1)
           LET g_success = 'N'
           EXIT FOREACH
        END IF
     END IF
#FUN-560195-end
 
     IF p_argv = '1' OR p_argv = '2' THEN   #完工入庫或入庫退回
        #-----更新sfb_file-----------
        LET l_sfv091 = 0
        LET l_sfv092 = 0
        LET l_sfv09 = 0
 
        SELECT SUM(sfv09) INTO l_sfv091 FROM sfu_file,sfv_file
         WHERE sfv11 = l_sfv.sfv11
           AND sfu01 = sfv01
           AND sfu00 = '1'           #完工入庫
           AND sfupost = 'Y'
 
        SELECT SUM(sfv09) INTO l_sfv092 FROM sfu_file,sfv_file
         WHERE sfv11 = l_sfv.sfv11
           AND sfu01 = sfv01
           AND sfu00 = '2'           #入庫退回
           AND sfupost = 'Y'
 
        LET l_sfv09 = 0
        IF cl_null(l_sfv091) THEN LET l_sfv091 = 0 END IF
        IF cl_null(l_sfv092) THEN LET l_sfv092 = 0 END IF
 
        LET l_sfv09 = l_sfv091 - l_sfv092
 
        IF p_argv = '1' THEN
           UPDATE sfb_file SET sfb09 = l_sfv09,
                               sfb04 = '7'
            WHERE sfb01 = l_sfv.sfv11
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err('upd sfb',STATUS,0)
              LET g_success = 'N'
              RETURN
            END IF
        ELSE
            IF l_sfv09<0 THEN
               CALL cl_err(l_sfv.sfv03,'asf-712',0)
               LET g_success='N'
               RETURN
            END IF
 
            UPDATE sfb_file SET sfb09 = l_sfv09
             WHERE sfb01 = l_sfv.sfv11
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err('upd sfb',STATUS,0)
                LET g_success = 'N'
                RETURN
             END IF
        END IF
     END IF
     IF SQLCA.sqlcode THEN
        CALL cl_err('upd sfb',STATUS,1)
        LET g_success = 'N'
        RETURN
     END IF
 
     IF SQLCA.sqlerrd[3]=0 THEN
        CALL cl_err('upd sfb','mfg0177',1)
        LET g_success = 'N'
        RETURN
     END IF
 
     #------
     IF p_argv = '1' OR p_argv = '2' THEN    #完工入庫或入庫退回
        #------新增工單完工統計資料檔(sfh_file)---
        INSERT INTO sfh_file(sfh01,sfh02,sfh03,sfh04,sfh05,sfh06,sfh07,sfh08,sfh09,
                             sfh10,sfh11,sfh12,sfh13,sfh14,sfh15,sfh16,sfh17,sfh18,
                              sfh91,sfh92, #No.MOD-470041
                              sfhplant,sfhlegal)     #FUN-980008 add
                            VALUES (l_sfv.sfv11,l_sfu.sfu02,'3',l_sfv.sfv04,
                                    ' ',l_sfv.sfv09,l_sfv.sfv08,l_sfv.sfv05,
                                    l_sfv.sfv06,l_sfv.sfv07,' ',' ',l_sfu.sfu01,
                                    l_sfv.sfv03,0,0,0,' ',' ',' ', #NO:7166
                                    g_plant,g_legal) #FUN-980008 add
        IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
           CALL cl_err('ins sfh',STATUS,1) LET g_success = 'N' RETURN
        END IF
     END IF
 
     IF p_argv = '1' OR p_argv = '2' THEN
        #FUN-540055  --begin
        IF g_sma.sma115 = 'Y' THEN
           IF l_sfv.sfv32 != 0 OR l_sfv.sfv35 != 0 THEN
              CALL t620sub_update_du('s',l_sfu.sfu01,l_sfv.sfv03,p_argv)
           END IF
        END IF
        IF g_success='N' THEN 
           #TQC-620156...............begin
           LET g_totsuccess='N'
           LET g_success="Y"
           CONTINUE FOREACH   #No.FUN-6C0083
           #RETURN 
           #TQC-620156...............end
        END IF
        #FUN-540055  --end
        CALL t620sub_update_s(l_sfu.sfu01,l_sfv.sfv03,p_argv)
        IF g_success='N' THEN
           #TQC-620156...............begin
           LET g_totsuccess='N'
           LET g_success="Y"
           CONTINUE FOREACH   #No.FUN-6C0083
           #RETURN 
           #TQC-620156...............end
        END IF
     END IF
     CALL s_updsfb11(l_sfv.sfv11)     #update sfb11
     CALL t620sub_ins_sub_rvv(l_sfu.sfu01,l_sfv.sfv03,p_argv)  #kim:此function看似是多餘的,因為輸入工單編號時會卡不可為委外,故此function進去後一定會跳離
     IF s_industry('icd') THEN
        #FUN-810038................begin
        #完工入庫asft620,若入庫料號(sfv04)之料件狀態(ta_ima040) = '[3-4]', 
        #除原有異動檔處理,需增加tc_tlf_file及更新tc_img_file
        IF p_argv = '1' THEN
           #TQC-B80005 --START--
           SELECT * INTO l_sfvi.* FROM sfvi_file
            WHERE sfvi01 = l_sfv.sfv01 AND sfvi03 = l_sfv.sfv03  
           #TQC-B80005 --END--
           CALL s_icdpost(1,l_sfv.sfv04,l_sfv.sfv05,l_sfv.sfv06,
                            l_sfv.sfv07,l_sfv.sfv08,l_sfv.sfv09,
                            l_sfv.sfv01,l_sfv.sfv03,
                            l_sfu.sfu02,'Y',l_sfv.sfv11,0
                            ,l_sfvi.sfviicd029,l_sfvi.sfviicd028,'') #FUN-B30187 #TQC-B80005  #FUN-B80119--傳入p_plant參數''---
                RETURNING l_flag
           IF l_flag = 0 THEN
              LET g_totsuccess='N'
              LET g_success="Y"
              CONTINUE FOREACH
           END IF
        END IF
        #FUN-810038................end
     END IF
  END FOREACH
 
  IF STATUS THEN
     CALL cl_err('foreach',STATUS,0)
     LET g_success='N'
  END IF
 
  #TQC-620156...............begin
  IF g_totsuccess="N" THEN
     LET g_success="N"
  END IF
 
   CALL s_showmsg()   #No.FUN-6C0083
 
  #TQC-620156...............end
  CALL cl_msg('')
 
END FUNCTION
 
#kim:此function看似是多餘的,因為輸入工單編號時會卡不可為委外,故此function進去後一定會跳離
FUNCTION t620sub_ins_sub_rvv(p_sfu01,p_sfv03,p_argv)
   DEFINE p_sfu01       LIKE sfu_file.sfu01
   DEFINE p_sfv03       LIKE sfv_file.sfv03
   DEFINE p_argv        LIKE type_file.chr1
   DEFINE l_sfu         RECORD LIKE sfu_file.*
   DEFINE l_sfv         RECORD LIKE sfv_file.*
   DEFINE l_pmn		RECORD LIKE pmn_file.*
   DEFINE l_sfb		RECORD LIKE sfb_file.*
   DEFINE l_rva		RECORD LIKE rva_file.*
   DEFINE l_rvb		RECORD LIKE rvb_file.*
   DEFINE l_rvu		RECORD LIKE rvu_file.*
   DEFINE l_rvv		RECORD LIKE rvv_file.*
   DEFINE l_rvvi	RECORD LIKE rvvi_file.*  #No.FUN-7B0018
   DEFINE l_rvbi	RECORD LIKE rvbi_file.*  #No.FUN-7B0018
 
   IF g_success='N' THEN RETURN END IF
   
   SELECT * INTO l_sfu.* FROM sfu_file
    WHERE sfu01 = p_sfu01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','sfu_file',p_sfu01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
   
   SELECT * INTO l_sfv.* FROM sfv_file 
    WHERE sfv01 = p_sfu01
      AND sfv03 = p_sfv03
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','sfv_file',p_sfu01,p_sfv03,SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
 
   SELECT * INTO l_sfb.* FROM sfb_file
    WHERE sfb01=l_sfv.sfv11
   IF STATUS THEN CALL cl_err('s sfb:',STATUS,1) LET g_success='N' RETURN END IF
 
   IF l_sfb.sfb02<>7 THEN RETURN END IF
 
   SELECT * INTO l_pmn.* FROM pmn_file
    WHERE pmn41=l_sfv.sfv11
      AND pmn65='1'
   IF SQLCA.sqlcode  THEN
      CALL cl_err('s pmn:',STATUS,1)
      LET g_success='N'
      RETURN
   END IF
 
   UPDATE pmn_file SET pmn50=l_sfb.sfb09
    WHERE pmn01=l_pmn.pmn01 AND pmn02=l_pmn.pmn02
 
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3('upd','pmn_file',l_pmn.pmn01,l_pmn.pmn02,SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
 
   #---------------------------------------- insert rva_file (入庫時)
   IF l_sfu.sfu00='1' THEN
      INITIALIZE l_rva.* TO NULL
      LET l_rva.rva00='1'                    #FUN-940083
      LET l_rva.rva01=l_sfu.sfu01
      LET l_rva.rva04='N'
      LET l_rva.rva05=l_sfb.sfb82
      LET l_rva.rva06=l_sfu.sfu02
      LET l_rva.rva10='SUB'
      LET l_rva.rvaconf='Y'
      LET l_rva.rvaacti='Y'
      LET l_rva.rvauser=g_user
      LET g_data_plant = g_plant #FUN-980030
      LET l_rva.rvadate=TODAY
      LET l_rva.rva29=' '    #NO.FUN-960130
      LET l_rva.rvaplant = g_plant #FUN-980008 add
      LET l_rva.rvalegal = g_legal #FUN-980008 add
      LET l_rva.rvaoriu = g_user      #No.FUN-980030 10/01/04
      LET l_rva.rvaorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO rva_file VALUES(l_rva.*)
      #---------------------------------------- insert rvb_file (入庫時)
      INITIALIZE l_rvb.* TO NULL
      LET l_rvb.rvb01=l_sfu.sfu01
      LET l_rvb.rvb02=l_sfv.sfv03
      LET l_rvb.rvb03=l_pmn.pmn02
      LET l_rvb.rvb04=l_pmn.pmn01
      LET l_rvb.rvb05=l_sfv.sfv04
      LET l_rvb.rvb06=0
      LET l_rvb.rvb07=l_sfv.sfv09
      LET l_rvb.rvb08=l_sfv.sfv09
      LET l_rvb.rvb09=l_sfv.sfv09
      LET l_rvb.rvb10=l_pmn.pmn31
      LET l_rvb.rvb18='30'
      LET l_rvb.rvb19='1'
      LET l_rvb.rvb22=l_sfv.sfv12
      LET l_rvb.rvb29=0
      LET l_rvb.rvb30=l_sfv.sfv09
      LET l_rvb.rvb31=0
      LET l_rvb.rvb34=l_sfv.sfv11
      LET l_rvb.rvb89='N'          #FUN-940083
      LET l_rvb.rvb35='N'
      LET l_rvb.rvb36=l_sfv.sfv05
      LET l_rvb.rvb37=l_sfv.sfv06
      LET l_rvb.rvb38=l_sfv.sfv07
      LET l_rvb.rvb930=l_sfv.sfv930 #FUN-670103
      LET l_rvb.rvb42 = ' '   #NO.FUN-960130
      LET l_rvb.rvbplant = g_plant #FUN-980008 add
      LET l_rvb.rvblegal = g_legal #FUN-980008 add
      INSERT INTO rvb_file VALUES(l_rvb.*)
      IF STATUS THEN
         CALL cl_err('i rvb:',STATUS,1)
         LET g_success='N'
         RETURN
      END IF
      IF NOT s_industry('std') THEN
         #No.FUN-7B0018 080306 add --begin
         INITIALIZE l_rvbi.* TO NULL
         LET l_rvbi.rvbi01 = l_rvb.rvb01
         LET l_rvbi.rvbi02 = l_rvb.rvb02
         IF NOT s_ins_rvbi(l_rvbi.*,'') THEN
            LET g_success = 'N'
            RETURN
         END IF
         #No.FUN-7B0018 080306 add --end
      END IF
   END IF
   #---------------------------------------- insert rvu_file (入/退庫)
   INITIALIZE l_rvu.* TO NULL
   IF l_sfu.sfu00='1' THEN
      LET l_rvu.rvu00='1'
   ELSE
      LET l_rvu.rvu00='3'
   END IF
 
   LET l_rvu.rvu01=l_sfu.sfu01
   LET l_rvu.rvu02=l_sfu.sfu01
   LET l_rvu.rvu03=l_sfu.sfu02
   LET l_rvu.rvu04=l_sfb.sfb82
   SELECT pmc03 INTO l_rvu.rvu05 FROM pmc_file WHERE pmc01=l_rvu.rvu04
   LET l_rvu.rvu08='SUB'
   LET l_rvu.rvuconf='Y'
   LET l_rvu.rvuacti='Y'
   LET l_rvu.rvuuser=g_user
   LET l_rvu.rvudate=TODAY
   #NO.FUN-960130-----begin-----                                                                                                 
   LET l_rvu.rvu21 = ' '                                                                                                         
   LET l_rvu.rvu900 = '0'                                                                                                        
   LET l_rvu.rvumksg = ' '                                                                                                       
   #NO.FUN-960130-----end-----
   LET l_rvu.rvuplant = g_plant #FUN-980008 add
   LET l_rvu.rvulegal = g_legal #FUN-980008 add
   LET l_rvu.rvuoriu = g_user      #No.FUN-980030 10/01/04
   LET l_rvu.rvuorig = g_grup      #No.FUN-980030 10/01/04
   LET l_rvu.rvu27 = '1'           #TQC-B60065
   INSERT INTO rvu_file VALUES(l_rvu.*)
   #---------------------------------------- insert rvv_file (入/退庫)
   INITIALIZE l_rvv.* TO NULL
   LET l_rvv.rvv01=l_sfu.sfu01
   LET l_rvv.rvv02=l_sfv.sfv03
   IF l_sfu.sfu00='1' THEN
      LET l_rvv.rvv03='1'
   ELSE
      LET l_rvv.rvv03='3'
   END IF
   LET l_rvv.rvv04=l_sfu.sfu01
   LET l_rvv.rvv05=l_sfv.sfv03
   LET l_rvv.rvv06=l_sfb.sfb82
   LET l_rvv.rvv09=l_sfu.sfu02
   LET l_rvv.rvv17=l_sfv.sfv09
   LET l_rvv.rvv18=l_sfv.sfv11
   LET l_rvv.rvv23=0
   LET l_rvv.rvv88=0           #No.TQC-7B0083
   LET l_rvv.rvv25='N'
   LET l_rvv.rvv31=l_sfv.sfv04
   SELECT ima02 INTO l_rvv.rvv031 FROM ima_file WHERE ima01=l_sfv.sfv04
   LET l_rvv.rvv32=l_sfv.sfv05
   LET l_rvv.rvv33=l_sfv.sfv06
   LET l_rvv.rvv34=l_sfv.sfv07
   LET l_rvv.rvv35=l_sfv.sfv08
   LET l_rvv.rvv35_fac=1
   LET l_rvv.rvv36=l_pmn.pmn01
   LET l_rvv.rvv37=l_pmn.pmn02
   LET l_rvv.rvv930=l_sfv.sfv930 #FUN-670103
   LET l_rvv.rvv89='N'           #FUN-940083
   IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02 = 1 END IF  
   LET l_rvv.rvv10 = ' '    #NO.FUN-960130
   LET l_rvv.rvvplant = g_plant #FUN-980008 add
   LET l_rvv.rvvlegal = g_legal #FUN-980008 add
   #流通代銷無收貨單,將發票記錄rvb22同時新增到rvv22內
   LET l_rvv.rvv22 = l_rvb.rvb22        #FUN-BB0001 add
   #FUN-CB0087---add---str---
   IF g_aza.aza115 = 'Y' THEN
      CALL s_reason_code(l_rvv.rvv01,l_rvv.rvv04,'',l_rvv.rvv31,l_rvv.rvv32,l_rvu.rvu07,l_rvu.rvu06) RETURNING l_rvv.rvv26
      IF cl_null(l_rvv.rvv26) THEN
         CALL cl_err('','aim-425',1)
         LET g_success = 'N'
         RETURN 
      END IF
   END IF
   #FUN-CB0087---add---end---
   INSERT INTO rvv_file VALUES(l_rvv.*)
   IF STATUS THEN CALL cl_err('i rvv:',STATUS,1)
      LET g_success='N'
      RETURN
   END IF
   IF NOT s_industry('std') THEN
      #No.FUN-7B0018 080306 add --begin
      INITIALIZE l_rvvi.* TO NULL
      LET l_rvvi.rvvi01 = l_rvv.rvv01
      LET l_rvvi.rvvi02 = l_rvv.rvv02
      IF NOT s_ins_rvvi(l_rvvi.*,'') THEN
         LET g_success = 'N'
         RETURN
      END IF
      #No.FUN-7B0018 080306 add --end
   END IF
 
END FUNCTION
 
FUNCTION t620sub_w(p_sfu01,p_action_choice,p_inTransaction,p_argv)       #過帳還原
   DEFINE p_sfu01            LIKE sfu_file.sfu01
   DEFINE p_action_choice    STRING
   DEFINE p_inTransaction    LIKE type_file.num5 
   DEFINE p_argv             LIKE type_file.chr1
   DEFINE l_sfu              RECORD LIKE sfu_file.* 
   DEFINE l_sfv              RECORD LIKE sfv_file.* 
   DEFINE l_yy               LIKE type_file.num10
   DEFINE l_mm               LIKE type_file.num10
   DEFINE l_imm01            LIKE imm_file.imm01
   DEFINE l_msg              STRING
   DEFINE l_ima906           LIKE ima_file.ima906
   DEFINE l_sfp06            LIKE sfp_file.sfp06  #MOD-D30057
   DEFINE lj_result          LIKE type_file.chr1  #CHI-CC0028
 
   IF s_shut(0) THEN RETURN END IF
   IF g_success='N' THEN RETURN END IF
   
   LET g_success = 'Y'
 
   IF p_sfu01 IS NULL THEN 
      CALL cl_err('',-400,0) 
      LET g_success = 'N' 
      RETURN 
   END IF   
   
   SELECT * INTO l_sfu.* FROM sfu_file
    WHERE sfu01 = p_sfu01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','sfu_file',p_sfu01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
   
   IF l_sfu.sfupost='N' THEN 
      CALL cl_err(l_sfu.sfu01,'mfg0178',1)
      LET g_success = 'N'
      RETURN 
   END IF
 
   IF l_sfu.sfuconf = 'X' THEN 
      CALL cl_err('','9024',0) 
      LET g_success = 'N'
      RETURN 
   END IF #FUN-660137
   #MOD-D30167---begin 搬到下面
   ##MOD-580334...............begin
   #IF NOT cl_null(l_sfu.sfu09) THEN
   #   #MOD-D30057---begin
   #   SELECT sfp06 INTO l_sfp06
   #     FROM sfp_file
   #    WHERE sfp01 = l_sfu.sfu09
   #   IF cl_null(l_sfp06) THEN
   #      IF cl_confirm('asf-451') THEN
   #         UPDATE sfu_file
   #            SET sfu09 = NULL 
   #          WHERE sfu01 = p_sfu01
   #         LET l_sfu.sfu09 = ''
   #         DISPLAY BY NAME l_sfu.sfu09
   #      END IF 
   #   END IF 
   #   IF l_sfp06 <> '4' AND NOT cl_null(l_sfp06) THEN 
   #   #MOD-D30057---end
   #      CALL cl_err('','asf-622',0)
   #      LET g_success = 'N'
   #      RETURN
   #   END IF #MOD-D30057
   #END IF
   ##MOD-580334...............end
   #MOD-D30167---end
 
#FUN-D30065 ----------Begin-------------		
   #當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原 		
   SELECT ccz_file.* INTO g_ccz.* FROM ccz_file WHERE ccz00='0'		
   IF g_ccz.ccz28  = '6' THEN		
      CALL cl_err('','apm-936',1)		
      LET g_success = 'N'
      RETURN		
   END IF 		
#FUN-D30065 ----------End---------------		

   IF g_sma.sma53 IS NOT NULL AND l_sfu.sfu02 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0)
      LET g_success = 'N'
      RETURN
   END IF
 
   CALL s_yp(l_sfu.sfu02) RETURNING l_yy,l_mm
   IF (l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
      CALL cl_err(l_yy,'mfg6090',0)
      LET g_success = 'N'
      RETURN
   END IF
   #CHI-CC0028---begin
   DECLARE t620sub_w_c CURSOR FOR
     SELECT * FROM sfv_file WHERE sfv01=l_sfu.sfu01

   FOREACH t620sub_w_c INTO l_sfv.*
      IF cl_null(l_sfv.sfv04) THEN
         CONTINUE FOREACH
      END IF
      CALL s_incchk(l_sfv.sfv05,l_sfv.sfv06,g_user)
           RETURNING  lj_result
      IF NOT lj_result THEN
         CALL cl_err(l_sfu.sfu01,'axm-399',1)
         LET g_success = 'N'                     
         RETURN                                    #carrier check with douzh
      END IF
   END FOREACH
   #CHI-CC0028---end
 
   IF NOT cl_null(p_action_choice) THEN
      IF NOT cl_confirm('asf-663') THEN RETURN END IF
   END IF
 
   IF NOT p_inTransaction THEN   
      BEGIN WORK    #carrier
   END IF
   #MOD-D30167---begin 搬下來
   IF NOT cl_null(l_sfu.sfu09) THEN
      SELECT sfp06 INTO l_sfp06
        FROM sfp_file
       WHERE sfp01 = l_sfu.sfu09
      IF cl_null(l_sfp06) THEN
         IF cl_confirm('asf-451') THEN
            UPDATE sfu_file
               SET sfu09 = NULL 
             WHERE sfu01 = p_sfu01
            LET l_sfu.sfu09 = ''
            DISPLAY BY NAME l_sfu.sfu09
         END IF 
      END IF 
      IF l_sfp06 <> '4' AND NOT cl_null(l_sfp06) THEN 
         CALL cl_err('','asf-622',0)
         IF NOT p_inTransaction THEN ROLLBACK WORK END IF
         LET g_success = 'N'
         RETURN  
      END IF 
   END IF
   #MOD-D30167---end
   CALL t620sub_lock_cl() 
   OPEN t620sub_cl USING p_sfu01
   IF STATUS THEN
      CALL cl_err("OPEN t620sub_cl:", STATUS, 1)
      CLOSE t620sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET g_success='N' #FUN-730012 add
      RETURN
   END IF
 
   FETCH t620sub_cl INTO l_sfu.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock sfu:',SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t620sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET g_success='N' #FUN-730012 add
      RETURN
   END IF
 
   CLOSE t620sub_cl
 
 
   UPDATE sfu_file SET sfupost='N' WHERE sfu01=l_sfu.sfu01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3('upd','sfu_file',l_sfu.sfu01,'',SQLCA.sqlcode,'','','1')
      LET g_success='N'
   END IF
   #FUN-5C0114...............begin
   IF p_argv='3' THEN
      CALL t620sub_upd_sre11("-",l_sfu.sfu01,p_argv)
   ELSE
   #FUN-5C0114...............end
      CALL t620sub_w1(l_sfu.sfu01,p_argv)
   END IF
   IF sqlca.sqlcode THEN LET g_success='N' END IF
   IF g_success = 'Y' THEN
      LET l_sfu.sfupost='N'
      IF NOT p_inTransaction THEN COMMIT WORK END IF
   ELSE
      LET l_sfu.sfupost='Y'
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
   END IF
 
 
   #carrier check logical
   #-----No.FUN-610090-----
   IF l_sfu.sfupost = "Y" THEN
      DECLARE t620sub_s1_c2 CURSOR FOR SELECT * FROM sfv_file
        WHERE sfv01 = l_sfu.sfu01
 
      LET l_imm01 = ""
      LET g_success = "Y"
 
      CALL s_showmsg_init()   #No.FUN-6C0083 
 
     #BEGIN WORK #CHI-C20054 mark
#CHI-C20054---add---START
      IF NOT p_inTransaction THEN
         BEGIN WORK
      END IF
#CHI-C20054---add-----END
 
      FOREACH t620sub_s1_c2 INTO l_sfv.*
         IF STATUS THEN
            EXIT FOREACH
         END IF
         SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01 = l_sfv.sfv04
 
         IF g_sma.sma115 = 'Y' THEN
            IF l_ima906 = '2' THEN  #子母單位
               LET g_unit_arr[1].unit= l_sfv.sfv30
               LET g_unit_arr[1].fac = l_sfv.sfv31
               LET g_unit_arr[1].qty = l_sfv.sfv32
               LET g_unit_arr[2].unit= l_sfv.sfv33
               LET g_unit_arr[2].fac = l_sfv.sfv34
               LET g_unit_arr[2].qty = l_sfv.sfv35
               CALL s_dismantle(l_sfu.sfu01,l_sfv.sfv03,l_sfu.sfu02,
                                l_sfv.sfv04,l_sfv.sfv05,l_sfv.sfv06,
                                l_sfv.sfv07,g_unit_arr,l_imm01)
                      RETURNING l_imm01
               #TQC-620156...............begin
               IF g_success='N' THEN 
                  LET g_totsuccess='N'
                  LET g_success="Y"
                  CONTINUE FOREACH   #No.FUN-6C0083
                  #RETURN 
               END IF
               #TQC-620156...............end
            END IF
         END IF
      END FOREACH
 
      #TQC-620156...............begin
      IF g_totsuccess="N" THEN
         LET g_success="N"
      END IF
 
      CALL s_showmsg()   #No.FUN-6C0083
 
      #TQC-620156...............end
 
      IF g_success = "Y" AND NOT cl_null(l_imm01) THEN
        #COMMIT WORK #CHI-C20054 mark
         IF NOT p_inTransaction THEN COMMIT WORK END IF #CHI-C20054 add
         LET l_msg="aimt324 '",l_imm01,"'"
         CALL cl_cmdrun_wait(l_msg)
      ELSE
        #ROLLBACK WORK #CHI-C20054 mark
         IF NOT p_inTransaction THEN ROLLBACK WORK END IF #CHI-C20054 add
      END IF
   END IF
   #-----No.FUN-610090 END-----
 
END FUNCTION
 
FUNCTION t620sub_w1(p_sfu01,p_argv)
 DEFINE p_sfu01     LIKE sfu_file.sfu01
 DEFINE p_argv      LIKE type_file.chr1
 DEFINE l_sfv       RECORD LIKE sfv_file.*
 DEFINE l_sfu       RECORD LIKE sfu_file.*
 DEFINE l_sfb       RECORD LIKE sfb_file.*
 DEFINE l_sfv091    LIKE sfv_file.sfv09
 DEFINE l_sfv092    LIKE sfv_file.sfv09
 DEFINE l_sfv09     LIKE sfv_file.sfv09
 DEFINE l_qcf091    LIKE qcf_file.qcf091
 DEFINE s_sfv09     LIKE sfv_file.sfv09
 DEFINE l_sfb04     LIKE sfb_file.sfb04
 DEFINE l_sfb39     LIKE sfb_file.sfb39
 DEFINE l_flag      LIKE type_file.num5 
 DEFINE l_ima918    LIKE ima_file.ima918
 DEFINE l_ima921    LIKE ima_file.ima921
 DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
 DEFINE l_sql   STRING                                    #NO.FUN-8C0131 
 DEFINE l_i     LIKE type_file.num5                       #NO.FUN-8C0131 
 DEFINE l_sfvi  RECORD LIKE sfvi_file.*                   #TQC-B80005
 DEFINE l_cnt   LIKE type_file.num5                       #MOD-C70013 add
 DEFINE l_cnt1  LIKE type_file.num5                       #add by sx211216  问题:asft620删除单据后tlf还在
   IF g_success = 'N' THEN RETURN END IF
   
   IF p_sfu01 IS NULL THEN 
      CALL cl_err('',-400,0) 
      LET g_success = 'N' 
      RETURN 
   END IF   
   
   SELECT * INTO l_sfu.* FROM sfu_file
    WHERE sfu01 = p_sfu01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','sfu_file',p_sfu01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
  
  CALL s_showmsg_init()   #No.FUN-6C0083 
 
  DECLARE t620sub_w1_c CURSOR FOR
   SELECT * FROM sfv_file WHERE sfv01=l_sfu.sfu01
 
  FOREACH t620sub_w1_c INTO l_sfv.*
      IF STATUS THEN EXIT FOREACH END IF
      IF l_sfv.sfv09 = 0 THEN
         CALL cl_err(l_sfv.sfv09,'asf-660',1)   #MOD-990194
         LET g_success='N'   #MOD-990194
         EXIT FOREACH 
      END IF
      IF cl_null(l_sfv.sfv04) THEN CONTINUE FOREACH END IF
 
#----No.B363
      SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01=l_sfv.sfv11
 
      IF l_sfb.sfb04='8' THEN
         CALL cl_err(l_sfb.sfb01,'mfg3430',1)
         LET g_success='N'
         EXIT FOREACH
      END IF
#----No.B363 END
 
     #-----更新sfb_file-----------
      IF p_argv = '1' OR p_argv = '2' THEN
         LET l_sfv091 = 0    LET l_sfv092 = 0  LET l_sfv09 = 0
         SELECT SUM(sfv09) INTO l_sfv091 FROM sfu_file,sfv_file
          WHERE sfv11 = l_sfv.sfv11
            AND sfu01 = sfv01
            AND sfu00 = '1'  #入庫
            AND sfupost = 'Y'
 
         SELECT SUM(sfv09) INTO l_sfv092 FROM sfu_file,sfv_file
          WHERE sfv11 = l_sfv.sfv11
            AND sfu01 = sfv01
            AND sfu00 = '2'  #退回
            AND sfupost = 'Y'
         IF cl_null(l_sfv091) THEN LET l_sfv091 = 0 END IF
         IF cl_null(l_sfv092) THEN LET l_sfv092 = 0 END IF
 
         LET l_sfv09 = l_sfv091 - l_sfv092
 
## No:2627 modify 1998/10/26 -----------
         CASE
            WHEN l_sfv09>0
                 LET l_sfb04='7'
            WHEN l_sfv09=0         #FUN-550085
                 IF l_sfv.sfv17 IS NOT NULL AND l_sfv.sfv17 <> ' ' THEN
                    LET l_sfb04='6'
                 ELSE
                   #FUN-5C0055...............begin
                   LET l_sfb39=' '
                   SELECT sfb39 INTO l_sfb39 FROM sfb_file
                     WHERE sfb01=l_sfv.sfv11
                  #MOD-C70013 str add-----
                   SELECT COUNT(*) INTO l_cnt FROM sfp_file,sfq_file
                    WHERE sfq02=l_sfv.sfv11
                      AND sfq01=sfp01
                      AND sfp04='Y'
                  #MOD-C70013 end add-----
                   IF cl_null(l_sfb39) OR (l_sfb39='1') AND l_cnt > 0 THEN   #MOD-C70013 add AND l_cnt > 0
                     LET l_sfb04 = '4'
                   ELSE
                     LET l_sfb04 = '2'
                   END IF
                   #FUN-5C0055...............end
                 END IF
            WHEN l_sfv09<0
                 CALL cl_err(l_sfu.sfu01,'asf-672',1)
                 LET g_success = 'N'
                 RETURN
         END CASE
         UPDATE sfb_file SET sfb09 = l_sfv09,
                             sfb04 = l_sfb04
          WHERE sfb01 = l_sfv.sfv11
         IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err('upd sfb',STATUS,0)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
     #------
 
      IF p_argv = '1' OR p_argv = '2' THEN
 
         #FUN-540055  --begin
         IF g_sma.sma115 = 'Y' THEN
            IF l_sfv.sfv32 != 0 OR l_sfv.sfv35 != 0 THEN
               CALL t620sub_update_du('w',l_sfu.sfu01,l_sfv.sfv03,p_argv)
            END IF
         END IF
         IF g_success='N' THEN 
            #TQC-620156...............begin
            LET g_totsuccess='N'
            LET g_success="Y"
            CONTINUE FOREACH   #No.FUN-6C0083
            #RETURN 
            #TQC-620156...............end
         END IF
         #FUN-540055  --end
         CALL t620sub_update_w(l_sfu.sfu01,l_sfv.sfv03,p_argv)
         IF g_success='N' THEN 
           #TQC-620156...............begin
           LET g_totsuccess='N'
           LET g_success="Y"
           CONTINUE FOREACH   #No.FUN-6C0083
           #RETURN 
           #TQC-620156...............end
         END IF
      END IF
 
      CALL s_updsfb11(l_sfv.sfv11)     #update sfb11
 
      CALL t620sub_del_sub_rvv(l_sfv.sfv01,l_sfv.sfv03)
  ##NO.FUN-8C0131   add--begin   
        LET l_sql =  " SELECT  * FROM tlf_file ", 
                     " WHERE tlf01 = '",l_sfv.sfv04,"' ", 
                     "   AND tlf036 = '",l_sfv.sfv01,"' AND tlf037= ",l_sfv.sfv03," "
        DECLARE t620_u_tlf_c1 CURSOR FROM l_sql
        LET l_i = 0 
        CALL la_tlf.clear()
        FOREACH t620_u_tlf_c1 INTO g_tlf.*  
           LET l_i = l_i + 1
           LET la_tlf[l_i].* = g_tlf.*
        END FOREACH     

  ##NO.FUN-8C0131   add--end 
      DELETE FROM tlf_file
       WHERE tlf01 =l_sfv.sfv04
         AND (tlf036=l_sfv.sfv01 AND tlf037=l_sfv.sfv03)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err('del tlf',STATUS,0)
         LET g_success = 'N'
         RETURN
      END IF
      #add by sx211216---s asft620删除单据后TLF还在
      LET l_cnt1 = 0        
      SELECT COUNT(*) INTO l_cnt1  FROM tlf_file WHERE tlf01 =l_sfv.sfv04 AND (tlf036=l_sfv.sfv01 AND tlf037=l_sfv.sfv03)
      IF l_cnt1 >0 THEN 
         CALL cl_err('del tlf',STATUS,0)
         LET g_success = 'N'
         RETURN
      END IF 
      #add by sx211216---e
    ##NO.FUN-8C0131   add--begin
      FOR l_i = 1 TO la_tlf.getlength()
         LET g_tlf.* = la_tlf[l_i].*
         IF NOT s_untlf1('') THEN 
            LET g_success='N' RETURN
         END IF 
      END FOR       
  ##NO.FUN-8C0131   add--end 
 
      #-----No.FUN-810036-----
      #-----No.MOD-840216-----
      SELECT ima918,ima921 INTO l_ima918,l_ima921
        FROM ima_file
       WHERE ima01 = l_sfv.sfv04
         AND imaacti = "Y"
      
      IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
      #-----No.MOD-840216 END-----
         DELETE FROM tlfs_file
          WHERE tlfs01 = l_sfv.sfv04
            AND tlfs10 = l_sfv.sfv01
            AND tlfs11 = l_sfv.sfv03
        
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN    
           #CALL cl_err('del tlfs',STATUS,0)     #MOD-CB0242 mark
            CALL cl_err('','aws-720',0)          #MOD-CB0242 
            LET g_success = 'N'
            RETURN
         END IF
      END IF   #No.MOD-840216
      #-----No.FUN-810036 END-----
 
      IF p_argv = '1' OR p_argv = '2' THEN    #完工入庫或入庫退回
         #刪除工單完工統計資料檔(sfh_file)
         DELETE FROM sfh_file WHERE sfh01= l_sfv.sfv11 #工單編號
                                AND sfh13= l_sfu.sfu01 #入庫單號
                                AND sfh14= l_sfv.sfv03 #序次    #NO:7166
         IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err('del sfh',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      IF s_industry("icd") THEN
         #FUN-810038................begin
         #完工入庫asft620,若入庫料號(sfv04)之料件狀態(ta_ima040) = '[3-4]',
         #除原有異動檔處理,需增加tc_tlf_file及更新tc_img_file
         IF p_argv = '1' THEN
            #TQC-B80005 --START--
            SELECT * INTO l_sfvi.* FROM sfvi_file
             WHERE sfvi01 = l_sfv.sfv01 AND sfvi03 = l_sfv.sfv03  
            #TQC-B80005 --END--
            CALL s_icdpost(1,l_sfv.sfv04,l_sfv.sfv05,l_sfv.sfv06,
                             l_sfv.sfv07,l_sfv.sfv08,l_sfv.sfv09,
                             l_sfv.sfv01,l_sfv.sfv03,
                             l_sfu.sfu02,'N',l_sfv.sfv11,0
                             ,l_sfvi.sfviicd029,l_sfvi.sfviicd028,'') #FUN-B30187 #TQC-B80005  #FUN-B80119--傳入p_plant參數''---
                 RETURNING l_flag
            IF l_flag = 0 THEN
               LET g_totsuccess='N'
               LET g_success="Y"
               CONTINUE FOREACH
            END IF
         END IF
         #FUN-810038................end
      END IF
  END FOREACH
  #TQC-620156...............begin
  IF g_totsuccess="N" THEN
     LET g_success="N"
  END IF
 
  CALL s_showmsg()   #No.FUN-6C0083
 
  #TQC-620156...............end
END FUNCTION
 
FUNCTION t620sub_del_sub_rvv(p_sfu01,p_sfv03)
   DEFINE p_sfu01     LIKE sfu_file.sfu01
   DEFINE p_sfv03     LIKE sfv_file.sfv03
   DEFINE l_sfv       RECORD LIKE sfv_file.*
   DEFINE l_sfu       RECORD LIKE sfu_file.*
   DEFINE l_pmn       RECORD LIKE pmn_file.*
   DEFINE l_sfb       RECORD LIKE sfb_file.*
   DEFINE l_rva       RECORD LIKE rva_file.*
   DEFINE l_rvb       RECORD LIKE rvb_file.*
   DEFINE l_rvu       RECORD LIKE rvu_file.*
   DEFINE l_rvv       RECORD LIKE rvv_file.*
   DEFINE l_rvv23     LIKE rvv_file.rvv23
   #FUN-BC0104-add-str--
   DEFINE l_rvv04  LIKE rvv_file.rvv04,
          l_rvv05  LIKE rvv_file.rvv05,
          l_rvv45  LIKE rvv_file.rvv45,
          l_rvv46  LIKE rvv_file.rvv46,
          l_rvv47  LIKE rvv_file.rvv47,
          l_flagg  LIKE type_file.chr1,
          l_rvv02  LIKE rvv_file.rvv02,
          l_qcl05  LIKE qcl_file.qcl05,
          l_type1  LIKE type_file.chr1
   DEFINE l_cn     LIKE  type_file.num5
   DEFINE l_c      LIKE  type_file.num5
   DEFINE l_rvv_a  DYNAMIC ARRAY OF RECORD
          rvv04    LIKE  rvv_file.rvv04,
          rvv05    LIKE  rvv_file.rvv05,
          rvv45    LIKE  rvv_file.rvv45,
          rvv46    LIKE  rvv_file.rvv46,
          rvv47    LIKE  rvv_file.rvv47,
          flagg    LIKE  type_file.chr1
                   END RECORD
   #FUN-BC0104-add-end--
 
   IF g_success = 'N' THEN RETURN END IF
  
   IF p_sfu01 IS NULL THEN 
      CALL cl_err('',-400,0) 
      LET g_success = 'N' 
      RETURN 
   END IF   
   
   SELECT * INTO l_sfu.* FROM sfu_file
    WHERE sfu01 = p_sfu01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','sfu_file',p_sfu01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
 
   SELECT * INTO l_sfv.* FROM sfv_file
    WHERE sfv01 = p_sfu01
      AND sfv03 = p_sfv03
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','sfv_file',p_sfu01,p_sfv03,SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
 
   SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01=l_sfv.sfv11
   IF STATUS THEN CALL cl_err('s sfb:',STATUS,1)LET g_success='N' RETURN END IF
   IF l_sfb.sfb02<>7 THEN RETURN END IF
 
   SELECT * INTO l_pmn.* FROM pmn_file
    WHERE pmn41=l_sfv.sfv11
      AND pmn65='1'
   IF STATUS THEN
      CALL cl_err('s pmn:',STATUS,1)
      LET g_success='N'
      RETURN
   END IF
 
   UPDATE pmn_file SET pmn50=l_sfb.sfb09
    WHERE pmn01=l_pmn.pmn01 AND pmn02=l_pmn.pmn02
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      LET g_success = 'N'
      RETURN
   END IF
 
   LET l_rvv23=0
   SELECT rvv23 INTO l_rvv23 FROM rvv_file
    WHERE rvv01=l_sfv.sfv01 AND rvv02=l_sfv.sfv03
   IF l_rvv23 > 0 THEN
      CALL cl_err('rvv23>0:','aap-172',1)
      LET g_success='N' RETURN
   END IF
 
   DELETE FROM rva_file WHERE rva01=l_sfu.sfu01
   IF SQLCA.sqlcode THEN
      CALL cl_err('d rva:',STATUS,1)
      LET g_success='N' RETURN
   END IF
 
   DELETE FROM rvb_file WHERE rvb01=l_sfu.sfu01
   IF SQLCA.sqlcode THEN
      CALL cl_err('d rvb:',STATUS,1)
      LET g_success='N' RETURN
   END IF
 
   IF NOT s_industry('std') THEN
      #No.FUN-7B0018 080306 add --begin
      IF NOT s_del_rvbi(l_sfu.sfu01,'','') THEN
         LET g_success = 'N'
         RETURN
      END IF
      #No.FUN-7B0018 080306 add --end
   END IF
 
   DELETE FROM rvu_file WHERE rvu01=l_sfu.sfu01
   IF SQLCA.sqlcode THEN
      CALL cl_err('d rvu:',STATUS,1)
      LET g_success='N' RETURN
   END IF

   #FUN-BC0104-add-str--
   LET l_cn =1
   DECLARE upd_qco20 CURSOR FOR
    SELECT rvv02 FROM rvv_file WHERE rvv01=l_sfu.sfu01
   FOREACH upd_qco20 INTO l_rvv02  
      CALL s_iqctype_rvv(l_sfu.sfu01,l_rvv02) RETURNING l_rvv04,l_rvv05,l_rvv45,l_rvv46,l_rvv47,l_flagg
      LET l_rvv_a[l_cn].rvv04 = l_rvv04
      LET l_rvv_a[l_cn].rvv05 = l_rvv05
      LET l_rvv_a[l_cn].rvv45 = l_rvv45
      LET l_rvv_a[l_cn].rvv46 = l_rvv46
      LET l_rvv_a[l_cn].rvv47 = l_rvv47
      LET l_rvv_a[l_cn].flagg = l_flagg
      LET l_cn = l_cn + 1
   END FOREACH
   #FUN-BC0104-add-end-- 
   DELETE FROM rvv_file WHERE rvv01=l_sfu.sfu01
   IF STATUS THEN
      CALL cl_err('d rvv:',STATUS,1)
      LET g_success='N'
      RETURN
   END IF
   #FUN-BC0104-add-str--
   FOR l_c=1 TO l_cn-1
      IF l_rvv_a[l_cn].flagg = 'Y' THEN
         CALL s_qcl05_sel(l_rvv_a[l_c].rvv46) RETURNING l_qcl05
         IF l_qcl05 ='1' THEN LET l_type1 ='5' ELSE LET l_type1 ='1' END IF
         IF NOT s_iqctype_upd_qco20(l_rvv_a[l_c].rvv04,l_rvv_a[l_c].rvv05,l_rvv_a[l_c].rvv45,l_rvv_a[l_c].rvv47,l_type1) THEN
            LET g_success ='N'
            RETURN
         END IF
      END IF
   END FOR
   #FUN-BC0104-add-end--
   
   IF NOT s_industry('std') THEN
      #No.FUN-7B0018 080306 add --begin
      IF NOT s_del_rvvi(l_sfu.sfu01,'','') THEN
         LET g_success = 'N'
         RETURN
      END IF
      #No.FUN-7B0018 080306 add --end
   END IF
END FUNCTION

#FUN-A80102(S)
FUNCTION t620sub_gen_shb(l_sfv,l_sfu02,l_sfv11,l_ecm012,l_ecm03,l_shb111)
   DEFINE l_sfv RECORD LIKE sfv_file.*
   DEFINE l_shb RECORD LIKE shb_file.*
   DEFINE l_ecm RECORD LIKE ecm_file.*
   DEFINE l_sql      STRING
   DEFINE l_t1       LIKE type_file.chr5 
   DEFINE l_sfu02    LIKE sfu_file.sfu02
   DEFINE l_sfv11    LIKE sfv_file.sfv11
   DEFINE l_shb031   LIKE shb_file.shb031
   DEFINE l_ecm012   LIKE ecm_file.ecm012
   DEFINE l_ecm03    LIKE ecm_file.ecm03 
   DEFINE l_shb111   LIKE shb_file.shb111
   DEFINE li_result   LIKE type_file.num5
   DEFINE l_factor    LIKE ecm_file.ecm59
   DEFINE l_ima55     LIKE ima_file.ima55
   DEFINE l_i         LIKE type_file.num5
   DEFINE l_sfb08    LIKE sfb_file.sfb08  #MOD-D20173

   INITIALIZE l_shb.* TO NULL
   SELECT * INTO l_ecm.* FROM ecm_file
    WHERE ecm01  = l_sfv11
      AND ecm012 = l_ecm012
      AND ecm03  = l_ecm03
   #TQC-C20005--begin
   IF l_ecm.ecm66='Y' THEN
      LET g_success='N'
      CALL cl_err(l_ecm03,'asf-797',1)
      RETURN FALSE
   END IF
   #TQC-C20005--end

   LET l_t1 = s_get_doc_no(l_sfv.sfv01)

   LET l_sql = "SELECT smyslip FROM smy_file WHERE smy67 = '",l_t1,"'"
   LET l_t1=NULL
   PREPARE t620_s1_p1 FROM l_sql
   DECLARE t620_s1_c1 CURSOR FOR t620_s1_p1
   OPEN t620_s1_c1
   FETCH t620_s1_c1 INTO l_t1
   CLOSE t620_s1_c1
   IF cl_null(l_t1) THEN
      LET g_success='N'
      CALL cl_err(l_sfv.sfv11,'asf-151',1)
      RETURN FALSE
   END IF
   LET l_shb.shb01  = l_t1
   LET l_shb.shb03  = l_sfu02
   LET l_shb.shb05  = l_sfv.sfv11
   LET l_shb.shb06  = l_ecm.ecm03
   LET l_shb.shb012 = l_ecm.ecm012
   LET l_shb.shb10  = l_ecm.ecm03_par   #TQC-C10101 add
   LET l_shb.shb111 = 0
   LET l_shb.shb113 = 0
   LET l_shb.shb112 = 0
   LET l_shb.shb114 = 0
   LET l_shb.shb115 = 0
   LET l_shb.shb17  = 0
   IF l_ecm.ecm52='Y' THEN  #FUN-A90057
      LET l_shb.shb27  = l_ecm.ecm67
   END IF
   IF l_ecm.ecm62 IS NULL THEN LET l_ecm.ecm62 = 1 END IF
   IF l_ecm.ecm63 IS NULL THEN LET l_ecm.ecm63 = 1 END IF
   LET l_shb.shb02   = g_today
   LET l_shb031 = TIME
   LET l_shb.shb021  = l_shb031[1,5]  #TQC-B20107
   LET l_shb.shb031  = l_shb031[1,5]
   LET l_shb.shb032  = 0  #TQC-B20107
   LET l_shb.shb033  = 0  #TQC-B20107
   LET l_shb.shbinp  = g_today
   LET l_shb.shbacti = 'Y'
   LET l_shb.shbuser = g_user
   LET l_shb.shboriu = g_user
   LET l_shb.shborig = g_grup
   LET g_data_plant = g_plant
   LET l_shb.shbgrup = g_grup
   LET l_shb.shbmodu = ''
   LET l_shb.shbdate = ''
   LET l_shb.shbplant = g_plant
   LET l_shb.shblegal = g_legal
   LET l_shb.shb04 = g_user
   LET l_shb.shb34 = l_ecm.ecm58     #FUN-BB0084

   LET l_shb.shb111 = l_shb111 * l_ecm.ecm62 / l_ecm.ecm63
   LET l_shb.shb111 = s_digqty(l_shb.shb111,l_shb.shb34)    #FUN-BB0084
   
   CALL s_auto_assign_no("asf",l_shb.shb01,l_shb.shb03,"9","shb_file","shb01","","","")
      RETURNING li_result,l_shb.shb01
   IF (NOT li_result) THEN
      RETURN FALSE
   END IF

   LET l_shb.shb012 = l_ecm.ecm012
   LET l_shb.shb06  = l_ecm.ecm03
   LET l_shb.shb081 = l_ecm.ecm04

   IF l_shb.shb012 IS NULL THEN LET l_shb.shb012=' ' END IF

   #將ecm相關欄位帶入shb
  #CALL t700sub_shb081(l_shb.*,l_ecm.*,l_shb.*)        #MOD-C60147 mark
   CALL t700sub_shb081(l_shb.*,l_ecm.*,l_shb.*,'N')    #MOD-C60147 add 
      RETURNING l_i,l_shb.*,l_ecm.*

   IF l_i = 1 THEN  #有錯誤
      RETURN FALSE
   END IF

  #IF g_sma.sma1435='N' THEN   #MOD-C10077 mark
      #MOD-D20173---begin
      #LET l_shb.shb032 = (l_shb.shb111+l_shb.shb112+l_shb.shb113+l_shb.shb114+l_shb.shb115) * l_ecm.ecm14 / 60
      #LET l_shb.shb033 = (l_shb.shb111+l_shb.shb112+l_shb.shb113+l_shb.shb114+l_shb.shb115) * l_ecm.ecm16 / 60
      SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01 = l_shb.shb05 
      LET l_shb.shb032 = (l_shb.shb111+l_shb.shb112+l_shb.shb113+l_shb.shb114+l_shb.shb115) * l_ecm.ecm14 / l_sfb08 / 60
      LET l_shb.shb033 = (l_shb.shb111+l_shb.shb112+l_shb.shb113+l_shb.shb114+l_shb.shb115) * l_ecm.ecm16 / l_sfb08 / 60
      #MOD-D20173---end
  #END IF                      #MOD-C10077 mark

   LET l_shb.shb30 = 'Y'
   CALL t700sub_shb26_31(l_shb.shb05,l_shb.shb012,l_shb.shb06) 
      RETURNING l_shb.shb26,l_shb.shb31
   IF cl_null(l_shb.shbconf) THEN LET l_shb.shbconf = 'N' END IF   #FUN-A70095
   INSERT INTO shb_file VALUES (l_shb.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_shb.shb05,SQLCA.sqlcode,1)
      RETURN FALSE
   END IF

   CALL cl_flow_notify(l_shb.shb01,'I')

   IF g_sma.sma1431='Y' THEN
      CALL t700sub_auto_report(l_shb.*,l_ecm.*)
   END IF

   IF g_success = 'Y' THEN   #TQC-B20107
     #CALL t700sub_upd_ecm('a',l_shb.*)    # Update 製程追蹤檔   #MOD-C10077 mark
     #  RETURNING l_shb.*                                        #MOD-C10077 mark
      CALL t700sub_confirm(l_shb.shb01,l_sfu02)                  #MOD-C10077 add
   END IF

   IF g_success='N' THEN
      RETURN FALSE
   END IF

   IF l_shb.shb112 > 0 THEN    #表示有報廢數量
      SELECT ima55 INTO l_ima55 FROM ima_file 
       WHERE ima01= l_shb.shb10

      CALL s_umfchk(l_shb.shb10,l_ecm.ecm58,l_ima55)                                                   
               RETURNING l_i,l_factor

      IF l_i = '1' THEN                                                                                             
         LET l_factor = 1
      END IF
      UPDATE sfb_file SET sfb12 = sfb12 + (l_shb.shb112 * l_factor)
       WHERE sfb01 = l_shb.shb05 
      IF SQLCA.sqlerrd[3] = 0  THEN 
         CALL cl_err(l_shb.shb05,'asf-861',1)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-A80102(E)
#DEV-D40013 add
