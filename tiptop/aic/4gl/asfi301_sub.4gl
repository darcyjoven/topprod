# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name...: asfi301_sub.4gl
# Description....: 提供asfi301.4gl使用的sub routine
# Date & Author..: 07/03/22 by kim (FUN-730012)
# Modify.........: No.TQC-730022 07/03/28 rainy 流程自動化
# Modify.........: No.MOD-740060 07/04/26 By pengu 訂單轉工單判斷訂單是否已開立工單應排除5.再加工工單或8.重工委外工單
# Modify.........: No.FUN-740034 07/05/14 By kim 確認過帳不使用rowid,改用單號
# Modify.........: No.CHI-710050 07/06/04 By jamie 若單身備料皆為消耗性料件時,則提醒完工方式應為2.領料(事後領料)
# Modify.........: No.MOD-790106 07/09/28 By Pengu 將5716行的QLCA.SQLCODE判斷往上移
# Modify.........: No.FUN-810038 08/02/22 By kim GP5.1 ICD
# Modify.........: No.CHI-830025 08/02/22 By kim GP5.1 ICD
# Modify.........: No.CHI-830032 08/03/31 By kim GP5.1整合測試修改
# Modify.........: No.MOD-840274 08/04/20 By kim GP5.1顧問測試修改
# Modify.........: No.MOD-840419 08/04/21 By Pengu 委外工單確認後按委外採購,第一次不會顯示委外採購資訊
# Modify.........: No.MOD-860016 08/06/02 By claire 一對多的委外工單拋轉後的委外採購單, 簽核否依單別設定
# Modify.........: No.MOD-840586 08/07/10 By Pengu 工單來源為訂單時在確認時未考慮訂單與工單之間的單位換算率
# Modify.........: No.FUN-870117 08/07/25 by ve007 工單審核時判斷制程是否審核
# Modify.........: No.CHI-7B0034 08/07/31 By sherry 增加被替代料(sfa27)為Key值
# Modify.........: No.MOD-880016 08/08/04 By ve007 
# Modify.........: No.FUN-870092 08/08/14 By Mandy 平行加工
# Modify.........: No.MOD-890023 08/09/04 By chenyu ICD功能測試
# Modify.........: No.MOD-870265 08/10/02 By claire 單位換算率的變數定義小數位放大減少誤差值
# Modify.........: No.FUN-8A0143 08/10/30 By Carrier 取價時，應該把'作業編號'傳入，配合apmi264的功能
# Modify.........: No.MOD-8B0086 08/11/10 By chenyu 工單沒有取替代料號時，讓sfs27=sfa27
# Modify.........: No.MOD-8B0151 08/11/14 By Sarah 當錯誤訊息為asf-899時,需Return不可確認
# Modify.........: No.MOD-8B0273 08/11/28 By chenyu 生成委外采購單時，單價和金額算法邏輯改變
# Modify.........: No.TQC-8C0034 08/12/18 By Mandy 確認時,若整體設定為機器,改成卡機器or機器群組有一筆資料即可
# Modify.........: No.FUN-910077 09/02/17 By kim for ICD-工單確認時所產生的發料單要自動過帳
# Modify.........: No.FUN-920054 09/02/24 By jan isnert 發料底稿單頭(sfp_file) 時增加對sfpconf的賦值;修改SQL語法錯誤
# Modify.........: No.FUN-920190 09/02/26 By kim 接續FUN-920054的修改，處理ICD工單取消確認和作廢，連同相關單據的處理
# Modify.........: No.FUN-8C0081 09/03/06 By sabrina 將確認段(i301sub_firm1)拆成check段(i301sub_firm1_chk)、update段(i301sub_firm1_upd)
# Modify.........: No.FUN-930148 09/03/26 By ve007 采購取價和定價
# Modify.........: No.FUN-940008 09/04/20 By hongmei 工單確認后不回寫工單工藝首站的投入量ecm301 
# Modify.........: No.FUN-950021 09/05/26 By Carrier 其他作業呼叫時transaction會被打破，改寫此作業的transaction方式
# Modify.........: No.FUN-960130 09/08/13 By Sunyanchun 零售業的必要欄位賦值
# Modify.........: No.TQC-980183 09/08/26 By xiaofeizhu 還原MOD-8B0273修改的內容
# Modify.........: No.FUN-980008 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-960317 09/09/04 By Carrier 修正GP5.2 shell產生的問題
# Modify.........: No.MOD-990117 09/10/08 By Smapmin asfi301_icd開委外工單產生委外採購單時，若有委外代買料，採購單不會自動確認
# Modify.........: No.MOD-9A0044 09/10/12 By Pengu 取消aic-144的控管
# Modify.........: No.CHI-980013 09/11/02 By jan 程式調整(修改產生發料底稿單身sql條件)
# Modify.........: No.CHI-980072 09/11/03 By jan 送簽之前先檢查若工藝編號不存在于aeci100,則出錯返回
# Modify.........: No.FUN-9B0016 09/10/31 By sunyanchun post no
# Modify.........: No.FUN-980033 09/11/11 By jan asfi301_icd新增時,打線圖/PKG type可以不必輸入
# Modify.........: No.TQC-9B0079 09/11/19 By Carrier VMI 赋值
# Modify.........: No.TQC-9B0094 09/11/19 By Carrier 错误处理机制
# Modify.........: No.TQC-9B0199 09/11/24 By sherry 1、修正無法轉采購單的問題 
#                                                   2、開單自動審核時，不需要再開窗詢問
# Modify.........: No:MOD-9B0157 09/11/25 By lilingyu asfp200整批審核時,選擇多筆單身資料,仍然需一筆一筆的確認
# Modify.........: No.TQC-9B0203 09/11/25 By douzh pmn58為NULL時賦初始值0
# Modify.........: No:MOD-960340 09/11/27 By sabrina 調整IF l_sfb.sfb22[1,3] != 'MRP'的判斷式
# Modify.........: No:TQC-9B0214 09/11/25 By Sunyanchun  s_defprice --> s_defprice_new
# Modify.........: No.FUN-B20095 11/07/01 By lixh1 新增sfq012(製程段號)

DATABASE ds
 
#FUN-740034
 
GLOBALS "../../config/top.global"
 
DEFINE g_pmm22 LIKE pmm_file.pmm22  #FUN-810038
DEFINE g_pmm42 LIKE pmm_file.pmm42  #FUN-810038
 
#{
#作用:lock cursor
#回傳值:無
#}
FUNCTION i301sub_lock_cl()
   DEFINE l_forupd_sql STRING

   LET l_forupd_sql = "SELECT * FROM sfb_file WHERE sfb01 = ? FOR UPDATE"
   LET l_forupd_sql=cl_forupd_sql(l_forupd_sql)

   DECLARE i301sub_cl CURSOR FROM l_forupd_sql
END FUNCTION
 
FUNCTION i301sub_firm1_chk(l_sfb01,p_inTransaction)      #FUN-8C0081   #No.FUN-950021
   DEFINE p_inTransaction    LIKE type_file.num5         #原來是否在transaction中     #No.FUN-950021 
   DEFINE l_vmn08  LIKE vmn_file.vmn08     #TQC-8C0034 add
   DEFINE l_ecm     RECORD LIKE ecm_file.* #FUN-870092 add
   DEFINE l_vlj_err LIKE type_file.chr1    #FUN-870092 add
   DEFINE l_sfb01 LIKE sfb_file.sfb01
   DEFINE l_sfb    RECORD LIKE sfb_file.*
   DEFINE l_pmn01  LIKE pmn_file.pmn01    #FUN-8C0081 mark
   DEFINE l_cause  LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)   #No:7315 add
   DEFINE l_qty    LIKE sfb_file.sfb08   #bugno:5512
   DEFINE l_oeb12  LIKE oeb_file.oeb12   #bugno:5512
   DEFINE l_cnt    LIKE type_file.num5   #No.FUN-680121 LIKE type_file.num5
   DEFINE l_cnt1   LIKE type_file.num5   #CHI-710050 add #No.FUN-680121 LIKE type_file.num5
   DEFINE l_ima55  LIKE ima_file.ima55
   DEFINE l_ima562 LIKE ima_file.ima562  #No.MOD-6C0105 add
   DEFINE l_oeb05  LIKE oeb_file.oeb05   #No.MOD-6C0105 add
   DEFINE l_factor LIKE ima_file.ima31_fac  #No.FUN-680121 DEC(16,8)
   DEFINE l_ima910 LIKE ima_file.ima910     #FUN-550112
   DEFINE l_sfa27  LIKE sfa_file.sfa27      #MOD-540194
   DEFINE l_sfa26  LIKE sfa_file.sfa26      #MOD-540194
   DEFINE l_sfbi   RECORD LIKE sfbi_file.*
   DEFINE l_ica04  LIKE ica_file.ica04      #FUN-810038
   DEFINE l_ima01  LIKE ima_file.ima01      #FUN-810038
   DEFINE l_imaicd01  LIKE imaicd_file.imaicd01      #FUN-810038
   DEFINE l_imx00   LIKE imx_file.imx00,        #No.FUN-870117
          l_ecu10   LIKE ecu_file.ecu10         #No.FUN-870117 
   DEFINE l_ecm03    LIKE ecm_file.ecm03         #CHI-980072
 
   WHENEVER ERROR CALL cl_err_msg_log   #No.TQC-9B0094

   LET g_success='Y'
   IF cl_null(p_inTransaction) THEN
      LET p_inTransaction = FALSE
   END IF

   SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01=l_sfb01  #FUN-730012
   IF cl_null(l_sfb.sfb01) THEN
      CALL cl_err('','-400',1)
      LET g_success='N'
      RETURN
   END IF
   LET l_cnt=0  #FUN-730012 add
   SELECT COUNT(*) INTO l_cnt FROM sfa_file WHERE sfa01 = l_sfb.sfb01
   IF l_cnt = 0 THEN
      #CALL cl_err('','mfg-009',0)         #TQC-730022
      CALL cl_err(l_sfb.sfb01,'mfg-009',0) #TQC-730022
      LET g_success='N' #FUN-730012 add
      RETURN
   END IF
   IF l_sfb.sfb87 = 'Y' THEN
      LET g_success='N' #FUN-730012 add
      #CALL cl_err('','9023',0)          #TQC-730022
      CALL cl_err(l_sfb.sfb01,'9023',0)  #TQC-730022
      RETURN
   END IF #No.TQC-6C0114
   IF l_sfb.sfb87 = 'X' THEN
      LET g_success='N' #FUN-730012 add
      #CALL cl_err('','9024',0)          #TQC-730022
      CALL cl_err(l_sfb.sfb01,'9024',0)  #TQC-730022
      RETURN
   END IF
   #CHI-980072--begin--add--
   IF l_sfb.sfb93 = 'Y' THEN
      LET l_ecm03 = 0
      SELECT MIN(ecm03) INTO l_ecm03
        FROM ecm_file
       WHERE ecm01 = l_sfb.sfb01
      IF STATUS THEN LET l_ecm03 = 0 END IF
      IF cl_null(l_ecm03) OR l_ecm03 = 0 THEN
         CALL cl_err('','sdf-349',1)
          RETURN 
      END IF
   END IF
   #CHI-980072--end--add--
   #No.FUN-870117  --begin--
   IF s_industry('slk') THEN        
  #SELECT imx00 INTO l_imx00 FROM imx_file WHERE imx000= l_sfb05      #FUN-8C0081 mark
   SELECT imx00 INTO l_imx00 FROM imx_file WHERE imx000= l_sfb.sfb05  #FUN-8C0081 add
   SELECT ecu10 INTO l_ecu10 FROM ecu_FILE
       WHERE ecu02 = l_sfb.sfb06   #FUN-8C0081 add
      #WHERE ecu02 = l_sfb06       #FUN-8C0081 mark
         AND ecu01 = l_imx00
   IF l_ecu10 !='Y'  THEN 
      LET g_success = 'N'   #FUN-950021
      CALL cl_err('','asf-425',1)
      RETURN   
   END IF 
   END IF 
   #No.FUN-870117 --end--
   
  #FUN-810038................begin
  IF s_industry('icd') THEN
     #合理性檢查
     SELECT * INTO l_sfbi.* FROM sfbi_file WHERE sfbi01=l_sfb01
     CALL i301sub_ind_icd_chk('a',l_sfb.*,l_sfbi.*)  #檢查ICD的資料正確否,不正確則 let g_success= N
        RETURNING l_sfbi.*
     IF g_success = 'N' THEN RETURN END IF
 
     #當工單確認時，若單頭無母工單編號，則將單身料號的母體更改回單頭母體欄位
     IF cl_null(l_sfb.sfb86) THEN
        DECLARE upd_sfbiicd14_cs CURSOR FOR #CHI-830025
           SELECT sfa03 FROM sfa_file 
            WHERE sfa01=l_sfb.sfb01
        FOREACH upd_sfbiicd14_cs INTO l_ima01
            EXIT FOREACH
        END FOREACH
        IF NOT cl_null(l_ima01) THEN
           SELECT imaicd01 INTO l_imaicd01
             FROM imaicd_file
            WHERE imaicd00 = l_ima01
           
           LET l_sfbi.sfbiicd14 = l_imaicd01
           UPDATE sfbi_file SET sfbiicd14 = l_sfbi.sfbiicd14 WHERE sfbi01=l_sfb.sfb01 #MOD-840274
        END IF
     END IF
 
     IF l_sfb.sfb02 MATCHES '[78]' AND l_sfb.sfb100 = '1' THEN  #一對一委外
        IF NOT p_inTransaction THEN   #No.FUN-950021
           BEGIN WORK
        END IF                        #No.FUN-950021
       #----------------No.MOD-840419 modify
       #CALL i301sub_ins_pmm(l_sfb.*)      #產生委外採購單
        CALL i301sub_ins_pmm(l_sfb.*) RETURNING l_pmn01
       #----------------No.MOD-840419 end
        IF g_success = 'Y' THEN 
           IF NOT p_inTransaction THEN   #No.FUN-950021
              COMMIT WORK 
           END IF                        #No.FUN-950021
        ELSE 
           IF NOT p_inTransaction THEN   #No.FUN-950021
              ROLLBACK WORK 
           END IF                        #No.FUN-950021
        END IF
     END IF
 
     IF g_success = 'Y' THEN CALL i301sub_ind_icd_upd_pmm18(l_sfb.*) END IF   #委外採購自動確認
     IF g_success = 'N' THEN RETURN END IF
  END IF
  #FUN-810038................end
   #MOD-650080-begin
   IF cl_null(l_sfb.sfb100) THEN
      #CALL i301_sfb100()    #TQC-730022
      CALL i301sub_sfb100(l_sfb.*) RETURNING l_sfb.sfb100  #TQC-730022
      IF cl_null(l_sfb.sfb100) THEN
          LET l_sfb.sfb100='1'
      END IF
      UPDATE sfb_file SET sfb100 = l_sfb.sfb100 WHERE sfb01=l_sfb.sfb01
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
#        CALL cl_err('upd sfb100',STATUS,0)   #No.FUN-660128
         CALL cl_err3("upd","sfb_file",l_sfb.sfb01,"",STATUS,"","upd sfb100",1)  #No.FUN-660128 #FUN-730012
         LET g_success='N'
      END IF
      #DISPLAY BY NAME l_sfb.sfb100 #FUN-730012 mark 改在做完確認後CALL _show()來重新顯示
   END IF
   #MOD-650080-end
 
 #FUN-6A0043 remark--begin
   #IF l_sfb.sfb02 MATCHES '[78]'  AND l_sfb.sfb100='1' THEN   #6961
   #    LET g_pmn01 = NULL
   #    SELECT MAX(pmn01) INTO g_pmn01 FROM pmn_file WHERE pmn41=l_sfb.sfb01
   #    DISPLAY g_pmn01 TO smydesc
   #    IF g_pmn01 IS NULL THEN CALL cl_err('pmn01:','mfg3502',0)
   #       RETURN
   #    END IF
   #    #NO:6961
   #    SELECT ima55 INTO l_ima55 FROM ima_file
   #     WHERE ima01=l_sfb.sfb05
 
   #    DECLARE i301_ch0 CURSOR FOR
   #        SELECT pmn20,pmn07 FROM pmm_file,pmn_file     #採購單單身單位NO:5074
   #         WHERE pmn41=l_sfb.sfb01
   #           AND pmm01=pmn01
   #           AND pmn04=l_sfb.sfb05
   #           AND pmm18<>'X'
   #    LET l_tot=0
   #    FOREACH i301_ch0 INTO l_pmn20,l_pmn07             #預防主料在P/O打多筆時
   #        IF cl_null(l_pmn20) THEN LET l_pmn20=0 END IF
   #        CALL s_umfchk(l_sfb.sfb05,l_pmn07,l_ima55)
   #              RETURNING g_sw,l_pmn09
   #        IF cl_null(l_pmn09) THEN LET l_pmn09=0 END IF
   #        LET l_qty=l_pmn20*l_pmn09
   #        IF cl_null(l_qty) THEN LET l_qty=0 END IF
   #        LET l_tot=l_tot+l_qty
   #    END FOREACH
   #    CASE WHEN (l_tot > l_sfb.sfb08)
   #              CALL cl_err(l_sfb.sfb05,'asf-946',1)
   #              RETURN
   #         WHEN (l_tot < l_sfb.sfb08)
   #              CALL cl_err(l_sfb.sfb05,'asf-950',1)
   #              RETURN
   #    END CASE
 
   #    DECLARE i301_ch CURSOR FOR
   #        SELECT sfa03,sfa05,sfa065,sfa12 FROM sfa_file
   #         WHERE sfa01=l_sfb.sfb01
   #    FOREACH i301_ch INTO l_sfa03,l_sfa05,l_sfa065,l_sfa12   #check 每一筆單身跟採購單
   #       IF l_sfb.sfb02='8' AND l_sfb.sfb05=l_sfa03 THEN
   #          CONTINUE FOREACH
   #       END IF
   #       IF NOT cl_null(l_sfa065) THEN                        #的料號數量是否相同
   #          DECLARE i301_ch1 CURSOR FOR
   #              SELECT pmn20,pmn07                            #採購單單身單位NO:5074
   #                FROM pmm_file,pmn_file
   #               WHERE pmn41=l_sfb.sfb01
   #                 AND pmm01=pmn01
   #                 AND pmn04=l_sfa03
   #                 AND pmm18<>'X'
   #                 AND pmn65='2'
   #          LET l_tot=0
   #          FOREACH i301_ch1 INTO l_pmn20,l_pmn07             #若P/O料號打多張時sum
   #              IF cl_null(l_pmn20) THEN LET l_pmn20=0 END IF
   #              CALL s_umfchk(l_sfa03,l_pmn07,l_sfa12)
   #                   RETURNING g_sw,l_pmn09
   #              LET l_qty=l_pmn20*l_pmn09
   #              LET l_tot=l_tot+l_qty
   #          END FOREACH
   #          IF NOT cl_null(l_sfa065) THEN                     #代買部份
   #              CASE WHEN (l_tot > l_sfa065)
   #                        CALL cl_err(l_sfa03,'asf-954',1)
   #                        RETURN
   #                   WHEN (l_tot < l_sfa065)
   #                        CALL cl_err(l_sfa03,'asf-956',1)
   #                        RETURN
   #                   WHEN (l_tot = l_sfa065)
   #                        CONTINUE FOREACH
   #              END CASE
   #          END IF
   #        END IF
   #    END FOREACH
   #    #NO:6961
 
   #   ##No.B355 010420 BY ANN CHEN
   #   SELECT COUNT(*) INTO l_n
   #     FROM pmm_file,pmn_file
   #    WHERE pmn41=l_sfb.sfb01
   #      AND pmm01=pmn01
   #      AND pmn16<'6'
   #      AND (pmm04 IS NOT NULL OR pmm04<>'')
   #      AND (pmm20 IS NOT NULL OR pmm20<>'')
   #      AND (pmm21 IS NOT NULL OR pmm21<>'')
   #      AND (pmm22 IS NOT NULL OR pmm22<>'')
   #   IF l_n = 0 THEN CALL cl_err(l_sfb.sfb01,'asf-955',0)
   #      RETURN
   #   END IF
   #   #No.B355 END
   #   #No.B356 010426 by linda add 檢查是否有相對應之委外採購單
   #   LET l_chk='N'
   #   SELECT COUNT(*) INTO l_n   #NO:6961
   #     FROM pmn_file
   #    WHERE pmn41=l_sfb.sfb01
   #      AND pmn04=l_sfb.sfb05
   #      AND pmn65='1'
   #   IF l_n=0 THEN              #NO:6961
   #       LET l_chk='Y'
   #   END IF
   #   DECLARE i301_chk_pmn CURSOR FOR
   #      SELECT * FROM sfa_file WHERE sfa01=l_sfb.sfb01 AND sfa065>0
   #   FOREACH i301_chk_pmn INTO l_sfa.*
   #       SELECT SUM(pmn20) INTO l_pmn20
   #         FROM pmn_file
   #        WHERE pmn41=l_sfb.sfb01
   #          AND pmn04=l_sfa.sfa03
   #          AND pmn65='2'
   #       IF SQLCA.SQLCODE THEN
   #           LET l_chk='Y'
   #           EXIT FOREACH
   #       END IF
   #   END FOREACH
   #   IF l_chk='Y' THEN
   #      CALL cl_err('','mfg-018',0)
   #      RETURN
   #   END IF
   #   #No.B356 end----
   #END IF
#FUN-6A0043 remark--end
 
   #MOD-540194...............begin
   DECLARE i301sub_chksfa26 CURSOR FOR
       SELECT sfa27,sfa26 FROM sfa_file
        WHERE sfa01=l_sfb.sfb01
   FOREACH i301sub_chksfa26 INTO l_sfa27,l_sfa26
      IF l_sfa26 NOT MATCHES '[0125]' THEN  #MOD-580229 012->0125
        IF NOT i301sub_chk_sfa26(l_sfb.sfb01,l_sfa27,l_sfa26) THEN
           LET g_success='N' #FUN-730012 add
           RETURN
        END IF
     END IF
   END FOREACH
   #MOD-540194...............end
 
   #MOD-4C0034 add ------
   IF g_sma.sma26 !='1' THEN
      IF l_sfb.sfb93 = 'Y' AND l_sfb.sfb24 = 'Y' THEN
         LET l_cnt = 0
         SELECT count(*) INTO l_cnt FROM sfa_file
          WHERE sfa01 = l_sfb.sfb01
            AND (sfa08 !=' ' OR sfa08 !='' )
            AND sfa08 NOT IN (
                SELECT UNIQUE ecm04 FROM ecm_file
                 WHERE ecm01 = l_sfb.sfb01 )
         IF l_cnt > 0 THEN
            #CALL cl_err('','aim-801',1)         #TQC-730022
            CALL cl_err(l_sfb.sfb01,'aim-801',1) #TQC-730022
            LET g_success='N' #FUN-730012 add
            RETURN
         END IF
         #FUN-870092--add---str-
         #有跟APS串多控管以下
         IF NOT cl_null(g_sma.sma901) AND g_sma.sma901 = 'Y' THEN
             CALL s_showmsg_init()   
             DECLARE i301sub_chk_vlj CURSOR FOR
              SELECT *  
               FROM ecm_file
              WHERE ecm01 = l_sfb.sfb01
             LET l_vlj_err = 'N'
             FOREACH i301sub_chk_vlj INTO l_ecm.*
                 IF g_sma.sma917 = 1 THEN #機器編號
                     #TQC-8C0034---add---str---
                     SELECT vmn08 INTO l_vmn08 
                       FROM vmn_file
                      WHERE vmn01  = l_sfb.sfb05
                        AND vmn02  = l_sfb.sfb01
                        AND vmn03  = l_ecm.ecm03
                        AND vmn04  = l_ecm.ecm04
                     #TQC-8C0034---add---str---
                     #TQC-8C0034--mod---str---
                     IF cl_null(l_ecm.ecm05) AND cl_null(l_vmn08) THEN
                        #CALL cl_getmsg('aps-021',g_lang) RETURNING g_showmsg 
                         #整體參數資源型態設機器時,機器編號和資源群組編號(機器),至少要有一個欄位有值!
                         CALL cl_getmsg('aps-033',g_lang) RETURNING g_showmsg 
                     #TQC-8C0034--mod---end---
                         LET g_showmsg = l_ecm.ecm03,'==>',g_showmsg
                         CALL s_errmsg('ecm03',g_showmsg,l_ecm.ecm01,STATUS,1)
                         LET l_vlj_err = 'Y'
                     END IF
                 END IF
                 IF  l_ecm.ecm61 = 'Y' THEN #平行加工否 = 'Y'
                      SELECT COUNT(*) INTO l_cnt 
                        FROM vlj_file
                       WHERE vlj01 = l_ecm.ecm01
                         AND vlj02 = g_sma.sma917
                         AND vlj03 = l_ecm.ecm03
                         AND vlj05 <> 0
                      IF l_cnt <= 0 THEN
                          CALL cl_getmsg('aps-017',g_lang) RETURNING g_showmsg #該製程序的平行加工資料尚未維護!
                          LET g_showmsg = l_ecm.ecm03,'==>',g_showmsg
                          CALL s_errmsg('ecm03',g_showmsg,l_ecm.ecm01,STATUS,1)
                          LET l_vlj_err = 'Y'
                      END IF
                 END IF
                #SELECT SUM(vne06) INTO l_sum_vne06 FROM vne_file
                #WHERE vne01 = l_ecm.ecm01
                #  and vne02 = l_ecm.ecm01
                #  and vne03 = l_ecm.ecm03
                #  and vne04 = l_ecm.ecm04
                #IF l_sum_vne06 <> l_sfb.sfb08 THEN
                #    CALL cl_getmsg('aps-023',g_lang) RETURNING g_showmsg #APS銷定使用設備內的未完成總量和工單生產數量不符,請檢核!
                #    LET g_showmsg = l_ecm.ecm03,'==>',g_showmsg
                #    CALL s_errmsg('ecm03',g_showmsg,l_ecm.ecm01,STATUS,1)
                #    LET l_vlj_err = 'Y'
                #END IF
             END FOREACH
             IF l_vlj_err = 'Y' THEN
                 CALL s_showmsg()   
                 LET g_success = 'N'
                 RETURN
             END IF
         END IF
         #FUN-870092--add---end-
      END IF
   END IF
   #MOD-4C0034 end ------
 
 #-------------No.MOD-640245 mark
 # #FUN-550112
 # LET l_ima910=''
 # SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=l_sfb.sfb05
 # IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
 # #--
 #-------------No.MOD-640245 end
  #No.B474 010507 by plum add 若此BOM尚未發放,不可用
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM bma_file
    WHERE bma01=l_sfb.sfb05
     #AND bma06 = l_ima910   #FUN-550112   #No.MOD-640245 mark
      AND bma06 = l_sfb.sfb95 #No.MOD-640245 add
   IF l_cnt >0 AND l_sfb.sfb02 !=15 THEN   #NO:7112 此判斷應剔除 '15'試產性工單
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM bma_file
       WHERE bma05 IS NOT NULL AND bma05 <=l_sfb.sfb071
        AND bma01=l_sfb.sfb05
       #AND bma06 = l_ima910   #FUN-550112   #No.MOD-640245 mark
        AND bma06 = l_sfb.sfb95 #No.MOD-640245 add
      IF l_cnt =0 THEN
         CALL cl_err(l_sfb.sfb071,'abm-005',0)
         LET g_success='N' #FUN-730012 add
         RETURN
      END IF
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM bma_file
      WHERE bma05 IS NOT NULL AND bma05 <=l_sfb.sfb81
        AND bma01=l_sfb.sfb05
       #AND bma06 = l_ima910   #FUN-550112     #No.MOD-640245 mark
        AND bma06 = l_sfb.sfb95 #No.MOD-640245 add
      IF l_cnt =0 THEN
         CALL cl_err(l_sfb.sfb81,'abm-006',0)
         LET g_success='N' #FUN-730012 add
         RETURN
      END IF
   END IF
  #No.B474...end
 
  #No.+230 010629 add by linda check 若有產生製程檔時,其最後一站轉出單位
  #        必須與生產料號的生產單位相同
   IF i301sub_chk_ecm(l_sfb.sfb01,l_sfb.sfb24) THEN
      LET g_success='N' #FUN-730012 add
      RETURN
   END IF
   #No.+230 end-----
 
#bugno:5512 add......................................................
   #check 總開工數 <= 訂單數量 (避免工單作廢後->取消作廢 造成總開工數 > 訂單量 )
   #select 總開工數
   SELECT SUM(sfb08) INTO l_qty FROM sfb_file
    WHERE sfb22 = l_sfb.sfb22 AND sfb221 = l_sfb.sfb221
      AND (sfb04 <> '8' OR (sfb04 = '8' AND sfb08 = sfb09))
      AND sfb02 !='5' AND sfb02 !='8'     #No.MOD-740060 add
      AND sfb87 !='X'
 
#No:7315 modify............................................
   LET l_cause = 'Y'
 
  #select 訂單數量
 
#--------------No.MOD-640197 modify
IF NOT cl_null(l_sfb.sfb22) AND NOT cl_null(l_sfb.sfb221) THEN  #No:MOD-960340 add
 #判斷來源若為MRP時不做check
  IF l_sfb.sfb22[1,3] != 'MRP' THEN
#--------------No.MOD-640197 end
    #----------------------No.MOD-790106 modify
     #------------No.MOD-6C0105 modify
     #SELECT oeb12*oeb05_fac*ima55_fac*(1+ima562)      #MOD-670107
     #  INTO l_oeb12 FROM oeb_file LEFT OUTER JOIN ima_file ON oeb04=ima01       #MOD-540073
     # WHERE oeb01=l_sfb.sfb22 AND oeb03=l_sfb.sfb221
     #   AND oeb70='N'
     #    AND oeb04=ima01     #MOD-540073
 
       SELECT oeb12,oeb05,ima55,(ima562+1) INTO l_oeb12,l_oeb05,l_ima55,l_ima562
        FROM oeb_file LEFT OUTER JOIN ima_file ON oeb04=ima01 
           WHERE oeb01 = l_sfb.sfb22 AND oeb03 = l_sfb.sfb221
           AND oeb70 = 'N'
 
      #check MPS 計劃的生產數量
      IF SQLCA.sqlcode OR cl_null(l_oeb12) THEN
          LET l_cause = 'N'
 
          SELECT msb05*ima55_fac INTO l_oeb12
            FROM msb_file LEFT OUTER JOIN ima_file ON msb03=ima01 ,msa_file
           WHERE msb01=l_sfb.sfb22 AND msb02=l_sfb.sfb221
             AND msb01=msa01 AND msa03 = 'N'
            #AND msb03=ima01            #FUN-730012
          IF STATUS THEN LET l_oeb12 = 0 END IF
      #-------------No.MOD-840586 modify
        ELSE
           CALL s_umfchk(l_sfb.sfb05,l_oeb05,l_ima55) RETURNING l_cnt,l_factor
           IF l_cnt = 1 THEN LET l_factor=1 END IF
            LET l_oeb12=l_oeb12*l_factor*l_ima562    
      #-------------No.MOD-840586 end
       END IF
       IF cl_null(l_qty)   THEN LET l_qty = 0 END IF
       IF cl_null(l_oeb12) THEN LET l_oeb12 = 0 END IF
       IF NOT cl_null(l_sfb.sfb22) AND NOT cl_null(l_sfb.sfb221) THEN
          IF l_qty > l_oeb12 THEN
             IF l_sfb.sfb02 NOT MATCHES '[58]' THEN    #MOD-740060 add
                #FUN-810038................begin
                IF s_industry('icd') THEN
                   IF l_cause = 'N' THEN
                      CALL cl_err(l_sfb.sfb01,'asf-011',1)
                      LET g_success='N'
                      RETURN
                   END IF
                   SELECT ica04 INTO l_ica04
                     FROM ica_file
                    WHERE ica00='0'
                   IF l_ica04 = 'Y' THEN
                      CALL cl_err(l_sfb.sfb01,'asf-005',1)
                      LET g_success='N'
                      RETURN
                   END IF
                ELSE
                #FUN-810038................end
                   IF l_cause = 'Y' THEN
                     #CALL cl_err('','asf-005',1)          #TQC-730022
                      CALL cl_err(l_sfb.sfb01,'asf-005',1)  #TQC-730022
                   ELSE
                      CALL cl_err(l_sfb.sfb01,'asf-011',1)
                   END IF
                   LET g_success='N' #FUN-730012 add
                   RETURN
               END IF
 
             END IF             #MOD-740060 add
          END IF
       END IF
     ELSE
       IF l_oeb12 IS NULL THEN LET l_oeb12=0 END IF
       CALL s_umfchk(l_sfb.sfb05,l_oeb05,l_ima55) RETURNING l_cnt,l_factor
       IF l_cnt = 1 THEN LET l_factor=1 END IF
       LET l_oeb12=l_oeb12*l_factor*l_ima562
     #------------No.MOD-6C0105 end
     END IF      #No.MOD-640197 end
    END IF      #No.MOD-960340 add 
  #----------------------No.MOD-790106 end
##
#bugno:5512 end......................................................
 
   #CHI-710050---add---str---
    IF l_sfb.sfb39='1' THEN
       LET l_cnt=0
       SELECT COUNT(*) INTO l_cnt
         FROM sfa_file
        WHERE sfa01 = l_sfb.sfb01
 
       LET l_cnt1=0
       SELECT COUNT(*) INTO l_cnt1
         FROM sfa_file
        WHERE sfa01 = l_sfb.sfb01
          AND sfa11 = 'E'
 
       IF l_cnt <> 0 THEN
          IF l_cnt = l_cnt1 THEN
             CALL cl_err('','asf-899',1)
             LET g_success='N'  #MOD-8B0151 add
             RETURN             #MOD-8B0151 add
          END IF
       END IF
    END IF
   #CHI-710050---add---end---
END FUNCTION      #FUN-8C0081 add
 
FUNCTION i301sub_firm1_upd(l_sfb01,l_action_choice,p_inTransaction)  #FUN-8C0081 add  #No.FUN-950021
 #FUN-8C0081---start---
  DEFINE p_inTransaction  LIKE type_file.num5    #No.FUN-950021
  DEFINE l_action_choice  STRING,
         l_sfb01          LIKE sfb_file.sfb01,
         l_sfbmksg        LIKE sfb_file.sfbmksg,
         l_sfb43          LIKE sfb_file.sfb43,
         l_sfb   RECORD   LIKE sfb_file.*,
         l_pmn01          LIKE pmn_file.pmn01,
         l_pmm18          LIKE pmm_file.pmm18,
         l_pmn02          LIKE pmn_file.pmn02,
         l_cnt            LIKE type_file.num5,
         l_ecm03          LIKE ecm_file.ecm03,
         l_ima55          LIKE ima_file.ima55,
         l_ecm57          LIKE ecm_file.ecm57,
         l_flag           LIKE type_file.num5,
         l_factorx        LIKE type_file.num26_10,
         l_ecm301         LIKE ecm_file.ecm301,
         l_ima56          LIKE ima_file.ima56,
         l_double         LIKE type_file.num10,
         l_mesg           LIKE type_file.chr1000
 #FUN-8C0081---end--
 
   #No.FUN-950021  --Begin
   IF cl_null(p_inTransaction) THEN
      LET p_inTransaction = FALSE
   END IF
   #No.FUN-950021  --End
   LET g_success = 'Y'   #FUN-8C0081 add
   SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01=l_sfb01  #FUN-8C0081 add
 
  #FUN-8C0081---mark---start---
  #IF NOT cl_null(l_action_choice) THEN  #TQC-730022 add
  #   IF NOT cl_confirm('axm-108') THEN
  #      LET g_success='N' #FUN-730012 add
  #      RETURN
  #   END IF
  #END IF #TQC-730022 add
  #FUN-8C0081---mark---end---
 
  #FUN-8C0081---add---start---
   IF l_action_choice CLIPPED = "confirm" OR  #執行"確認"功能(非簽核模式呼叫)
      l_action_choice CLIPPED = "insert"
   THEN
      SELECT sfbmksg,sfb43 INTO l_sfbmksg,l_sfb43
        FROM sfb_file WHERE sfb01 = l_sfb01
      IF l_sfbmksg = "Y" THEN     #若簽核碼為'Y'且簽核狀況碼不為'1'已核准
         IF l_sfb43 != "1" THEN
            CALL cl_err('','aws-078',1)
            LET g_success = "N"
            RETURN
         END IF
      END IF
      IF NOT cl_null(l_action_choice) THEN  #TQC-9B0199 add
        IF g_b_confirm = 'Y' THEN ELSE   #MOD-9B0157
         IF NOT cl_confirm('axm-108') THEN
            LET g_success='N' #FUN-730012 add
            RETURN
         END IF
        END IF  #MOD-9B0157
      END IF  #TQC-9B0199 add
   END IF
  #FUN-8C0081---add---end---
 
   #CALL i301sub_create_tmp()  #4298  #No.FUN-950021
   LET g_success='Y'
 
   IF NOT p_inTransaction THEN  #No.FUN-950021
      BEGIN WORK
   END IF                       #No.FUN-950021
   
   CALL i301sub_lock_cl() #FUN-730012
   OPEN i301sub_cl USING l_sfb.sfb01
   IF STATUS THEN
      CALL cl_err("OPEN i301sub_cl:", STATUS, 1)
      CLOSE i301sub_cl
      IF NOT p_inTransaction THEN  #No.FUN-950021
         ROLLBACK WORK
      END IF                       #No.FUN-950021
      LET g_success='N' #FUN-730012 add
      RETURN
   END IF
 
   FETCH i301sub_cl INTO l_sfb.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock sfb:',SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE i301sub_cl
      IF NOT p_inTransaction THEN  #No.FUN-950021
         ROLLBACK WORK
      END IF                       #No.FUN-950021
      LET g_success='N' #FUN-730012 add
      RETURN
   END IF
 
 #MOD-560225-modify
   #IF l_sfb.sfb02 NOT MATCHES '[78]'  THEN  #FUN-6A0043 remark
   UPDATE sfb_file SET sfb87 = 'Y' WHERE sfb01=l_sfb.sfb01
   IF STATUS THEN
#     CALL cl_err('upd sfb87',STATUS,0)   #No.FUN-660128
      CALL cl_err3("upd","sfb_file",l_sfb.sfb01,"",STATUS,"","upd sfb87",1)  #No.FUN-660128 #FUN-730012
      LET g_success='N'
   END IF
#FUN-6A0073 remark--begin
   #ELSE
   #  #1對1委外工單要檢查是否委外的採購單已發出才可確認
   #  IF l_sfb.sfb100 = '1' THEN
   #     SELECT COUNT(*) INTO l_cnt FROM pmm_file
   #      WHERE pmm18 = 'Y'
   #        AND pmm25 = '2'
   #        AND pmm01 IN ( SELECT UNIQUE pmn41 FROM pmn_file
   #                       WHERE pmn41 = l_sfb.sfb01 )
   #     IF l_cnt = 0 THEN
   #        CALL cl_err('upd sfb87','aap-198',1)
   #        LET g_success = 'N'
   #     ELSE
   #        UPDATE sfb_file SET sfb87 = 'Y'
   #         WHERE sfb01=l_sfb.sfb01
   #        IF STATUS THEN
#  #           CALL cl_err('upd sfb87_sfb100',STATUS,0)   #No.FUN-660128
   #           CALL cl_err3("upd","sfb_file",l_sfb_t.sfb01,"",STATUS,"","upd sfb87_sfb100",1)  #No.FUN-660128
   #           LET g_success='N'
   #        END IF
   #     END IF
   #  END IF
   #END IF
#FUN-6A0043--remark--end
 #MOD-560225-end
 
   UPDATE sfb_file SET sfb87 = 'Y' WHERE sfb01=l_sfb.sfb01
   IF STATUS THEN
#     CALL cl_err('upd sfb87',STATUS,0) #No.FUN-660128
      CALL cl_err3("upd","sfb_file",l_sfb.sfb01,"",STATUS,"","upd sfb87",1)  #No.FUN-660128 #FUN-730012
      LET g_success='N'
   END IF
   #已產生備料 and 工單狀態:1.確認生產工單(firm plan)
   IF g_sma.sma27 MATCHES '[13]' AND l_sfb.sfb23='Y' AND l_sfb.sfb04='1' THEN
      UPDATE sfb_file SET sfb04 = '2',sfb43='1' WHERE sfb01=l_sfb.sfb01  #FUN-8C0081 add sfb43
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
#        CALL cl_err('upd sfb04',STATUS,0)  #No.FUN-660128
         CALL cl_err3("upd","sfb_file",l_sfb.sfb01,"",STATUS,"","upd sfb04",1)  #No.FUN-660128 #FUN-730012
           LET g_success='N'   #No.FUN-660128
      ELSE
         LET l_sfb.sfb04 ='2'                               #No.TQC-710006
#        LET l_sfb.sfb04 ='2' DISPLAY BY NAME  l_sfb.sfb04  #No.TQC-710006
         LET l_sfb.sfb43 = '1'   #FUN-8C0081 add
      END IF
#     DISPLAY g_buf TO sfb04_d
      IF l_sfb.sfb02 MATCHES '[78]' AND l_sfb.sfb100='1' THEN   #委外工單 NO:6961 ,NO:7075
      #  DELETE FROM i301sub_tmp      #No.FUN-950021
         DECLARE upd_pmn_cs CURSOR FOR
            SELECT pmn01,pmn02 FROM pmn_file WHERE pmn41=l_sfb.sfb01
 
         FOREACH upd_pmn_cs INTO l_pmn01,l_pmn02
              SELECT pmm18 INTO l_pmm18 FROM pmm_file   #NO:6961
               WHERE pmm01=l_pmn01
              IF l_pmm18='X' THEN CONTINUE FOREACH END IF
              #no.7231 參數設定單價不可為零
              IF g_sma.sma112= 'N' THEN
                 LET l_cnt=0
                  #FUN-810038................begin
                  IF s_industry('icd') THEN
                    #       一般代採買且作業群組為6.TKY的資料不受此限
                    SELECT COUNT(*) INTO l_cnt FROM pmn_file,pmni_file
                     WHERE pmn01  = l_pmn01
                       AND pmni01 = pmn01
                       AND pmni02 = pmn02
                       AND (pmn31 <=0 OR pmn44 <=0 )
                       #委外代採買　或 一般委外且作業群組<>'6'
                       AND (pmn65 = '2' OR
                            (pmn65 = '1' AND pmniicd03 NOT IN
                             (SELECT ecd01 FROM ecd_file WHERE ecdicd01 = '6')))
                 ELSE
                 #FUN-810038................end
                    SELECT COUNT(*) INTO l_cnt FROM pmn_file
                     WHERE pmn01 = l_pmn01
                       AND (pmn31 <=0 OR pmn44 <=0 )
                END IF
                 IF l_cnt > 0 THEN
                    CALL cl_err('Confirm PO:','mfg3525',1)
                    LET g_success ='N' EXIT FOREACH
                 END IF
              END IF
              #no.7231(end)
 #MOD-560225-mark
#             UPDATE pmm_file SET pmm25='2',pmm18='Y'
#              WHERE pmm01=l_pmn01
#             IF STATUS THEN
#                CALL cl_err('',STATUS,0) LET g_success='N' EXIT FOREACH
#             END IF
#             SELECT * INTO g_cnt FROM i301sub_tmp WHERE pmm01 = l_pmn01
#             IF g_cnt = 0 THEN
#                INSERT INTO i301sub_tmp VALUES(l_pmn01)
#             END IF
#             UPDATE pmn_file SET pmn16='2' WHERE pmn01=l_pmn01
#             IF STATUS THEN
#                CALL cl_err('',STATUS,0) LET g_success='N' EXIT FOREACH
#             END IF
 #MOD-560225-end
          END FOREACH
        # CALL i301sub_firm1_other()   #No.FUN-950021
          #--------------------------------------------------------------
       ELSE
          IF l_sfb.sfb02 MATCHES '[78]' AND l_sfb.sfb100='2' THEN   #NO:6961,NO:7075
              LET l_cnt=0
              SELECT COUNT(*) INTO l_cnt
                FROM pmn_file
               WHERE pmn41=l_sfb.sfb01
              IF l_cnt >0 THEN
                   CALL cl_err(l_sfb.sfb01,'asf-933',0) LET g_success='N'
              ELSE
                 UPDATE sfb_file SET sfb87 = 'Y' WHERE sfb01=l_sfb.sfb01
                 IF STATUS THEN
#                    CALL cl_err('upd sfb87:',STATUS,1)   #No.FUN-660128
                     CALL cl_err3("upd","sfb_file",l_sfb.sfb01,"",STATUS,"","upd sfb87:",1)  #No.FUN-660128
                     LET g_success='N'
                 END IF
              END IF
          END IF
       END IF
     END IF
 
#No.FUN-940008 ---Begin mark
#     #=========================================================
#     #No.B524 010531 BY ANN CHEN
#     #第一站投入量[ecm301]改在工單確認時才掛上
#     #
#     IF l_sfb.sfb93='Y' THEN
#        LET l_ecm03=0
#        SELECT MIN(ecm03) INTO l_ecm03
#          FROM ecm_file
#         WHERE ecm01=l_sfb.sfb01
#        IF STATUS THEN LET l_ecm03=0 END IF
#
#        #---------------- 單位換算
#      # SELECT ima55 INTO l_ima55 FROM ima_file WHERE ima01=l_sfb.sfb05 #MOD-6B0065
#        SELECT ima55,ima56 INTO l_ima55,l_ima56 FROM ima_file WHERE ima01=l_sfb.sfb05 #MOD-6B0065
#        IF STATUS THEN LET l_ima55=' ' END IF
#        SELECT ecm57 INTO l_ecm57 FROM ecm_file WHERE ecm01=l_sfb.sfb01
#                                                  AND ecm03=l_ecm03
#        IF STATUS THEN LET l_ecm57=' ' END IF
#        CALL s_umfchk(l_sfb.sfb05,l_ima55,l_ecm57)
#             RETURNING l_flag,l_factorx              #MOD-870265 modify l_factor->l_factorx
#        IF l_flag=1 THEN
#         #---No.MOD-5A0008 add
#           LET l_mesg=NULL
#           LET l_mesg =l_sfb.sfb05,"(ima55/ecm57):"
#           CALL cl_err(l_mesg,'abm-731',1)
#           #CALL cl_err('ima55/ecm57: ','abm-731',1)
#         #--end
#           LET g_success ='N'  #RETURN  bugno:5512 marked .....
#        END IF
#      #------- No.MOD-6A0086 modify
#       #UPDATE ecm_file SET ecm301=l_sfb.sfb08*l_factor
#       #   WHERE ecm01=l_sfb.sfb01 AND ecm03=l_ecm03
#        IF l_ima56 != 0 THEN
#           LET l_double=(l_sfb.sfb08*l_factorx/l_ima56)+ 0.999999  #MOD-870265 modify l_factor->l_factorx
#           LET l_ecm301=l_double*l_ima56
#        ELSE
#           LET l_ecm301 = l_sfb.sfb08*l_factorx                    #MOD-870265 modify l_factor->l_facotrx
#        END IF
#        UPDATE ecm_file SET ecm301=l_ecm301
#           WHERE ecm01=l_sfb.sfb01 AND ecm03=l_ecm03
#      #------- No.MOD-6A0086 end
#        IF STATUS THEN
#         #   CALL cl_err('upd ecm301',STATUS,0) #No.FUN-660128
#             CALL cl_err3("upd","ecm_file",l_sfb.sfb01,l_ecm03,STATUS,"","upd ecm301",1)  #No.FUN-660128 #FUN-730012
#              LET g_success='N'
#        END IF
#     END IF
#     #No.B524 END ================================================
#No.FUN-940008 ---End
 
     #--FUN-8C0081--start--
     IF g_success='Y' THEN
        IF l_sfb.sfbmksg = "Y" AND l_sfb.sfb87 = "N" THEN         #簽核模式
           CASE aws_efapp_formapproval()    #呼叫EF簽核功能
                WHEN 0   #呼叫EF簽核失敗
                   LET l_sfb.sfb87 = "N"
                   LET g_success = "N"
                   IF NOT p_inTransaction THEN  #No.FUN-950021
                      ROLLBACK WORK
                   END IF                       #No.FUN-950021
                   RETURN
                WHEN 2   #當最後一關有2個以上簽核者且此次簽核完成後尚未結案
                   LET l_sfb.sfb87 = "N"
                   IF NOT p_inTransaction THEN  #No.FUN-950021
                      ROLLBACK WORK
                   END IF                       #No.FUN-950021
                   RETURN
           END CASE
        END IF
        IF g_success ="Y" THEN
           LET l_sfb.sfb43 = "1"
           LET l_sfb.sfb87 = "Y"
           IF NOT p_inTransaction THEN  #No.FUN-950021
              COMMIT WORK
           END IF                       #No.FUN-950021
           CALL cl_flow_notify(l_sfb.sfb01,'Y')
           #DISPLAY BY NAME l_sfb.sfb87                 #FUN-730012 改在做完確認後 CALL _show()來重新顯示
           #DISPLAY BY NAME l_sfb.sfb04 #No.TQC-710006  #FUN-730012 改在做完確認後 CALL _show()來重新顯示
        ELSE
           LET l_sfb.sfb87 = "N"
           LET g_success = "N"
           IF NOT p_inTransaction THEN  #No.FUN-950021
              ROLLBACK WORK
           END IF                       #No.FUN-950021
        END IF
     ELSE
        LET l_sfb.sfb87 = "N"
        LET g_success = "N"
        IF NOT p_inTransaction THEN  #No.FUN-950021
           ROLLBACK WORK
        END IF                       #No.FUN-950021
     END IF
     #--FUN-8C0081--end--
END FUNCTION
 
#MOD-540194
FUNCTION i301sub_chk_sfa26(p_sfa01,p_sfa27,p_sfa26)
DEFINE l_cnt   LIKE type_file.num10   #No.FUN-680121 LIKE type_file.num10
DEFINE p_sfa01 LIKE sfa_file.sfa01
DEFINE p_sfa27 LIKE sfa_file.sfa27
DEFINE p_sfa26,l_sfa26 LIKE sfa_file.sfa26
DEFINE l_result        LIKE type_file.num5     #No.FUN-680121 LIKE type_file.num5
 
 LET l_result=TRUE
 LET l_cnt = 0
 CASE
    WHEN p_sfa26 MATCHES '[34]'
       SELECT COUNT(*) INTO l_cnt FROM sfa_file
          WHERE sfa01=p_sfa01
            AND sfa27=p_sfa27
            AND (sfa26='S' OR sfa26='U')
    WHEN p_sfa26 MATCHES '[SU]'
       SELECT COUNT(*) INTO l_cnt FROM sfa_file
          WHERE sfa01=p_sfa01
            AND sfa27=p_sfa27
            AND (sfa26='3' OR sfa26='4')
    WHEN p_sfa26 MATCHES '[6]' #MOD-5A0032改成 WHEN p_sfa26 MATCHES '[6]'
       SELECT COUNT(*) INTO l_cnt FROM sfa_file
          WHERE sfa01=p_sfa01
           #AND sfa27=p_sfa27 #mark by MOD-5A0032
            AND sfa26='T'
    WHEN p_sfa26='T'
       SELECT COUNT(*) INTO l_cnt FROM sfa_file
          WHERE sfa01=p_sfa01
           #AND sfa27=p_sfa27 #mark by MOD-5A0032
            AND (sfa26='5' OR sfa26='6')
    OTHERWISE
       LET l_cnt=0
  END CASE
  IF l_cnt=0 THEN
    CALL cl_err('chk sfa26','asf-304',1)
    LET l_result=FALSE
  END IF
  RETURN l_result
END FUNCTION
 
#No.+230 010629 add by linda check 最後一站轉出單位必須同sfb05之生產單位
FUNCTION i301sub_chk_ecm(p_sfb01,p_sfb24)
  DEFINE l_ecm03 LIKE ecm_file.ecm03,
         l_ecm58 LIKE ecm_file.ecm58,
         l_ima55 LIKE ima_file.ima55,
         p_sfb01 LIKE sfb_file.sfb01,
         p_sfb24 LIKE sfb_file.sfb24
 
   IF p_sfb24 ='N' THEN RETURN 0 END IF
   LET l_ecm03=''  LET l_ecm58=''
   DECLARE ecm_chk CURSOR FOR
      SELECT ecm03,ecm58
        FROM ecm_file
       WHERE ecm01 = p_sfb01
        ORDER BY ecm03 DESC
   FOREACH ecm_chk INTO l_ecm03,l_ecm58
     IF SQLCA.SQLCODE THEN
        CALL cl_err('ecm chk:',SQLCA.SQLCODE,0)
        EXIT FOREACH
     END IF
     EXIT FOREACH
   END FOREACH
   #讀取生產料號之生產單位
   SELECT ima55 INTO l_ima55
    FROM sfb_file,ima_file
    WHERE sfb05=ima01
     AND sfb01=p_sfb01
   IF l_ecm58 <> l_ima55 THEN
      CALL cl_err(l_ecm03,'mfg-054',0)
      RETURN 1
   END IF
   RETURN 0
END FUNCTION
#No.+230 end---
 
#--------- add in 99/10/11 BY Kammy NO:0681 ----------------
FUNCTION i301sub_create_tmp()
   DROP TABLE i301sub_tmp
#NO.FUN-680121-BEGIN
   CREATE TEMP TABLE i301sub_tmp(
   pmm01  LIKE pmm_file.pmm01)
#NO.FUN-680121-END
END FUNCTION
 
#若為委外，多張工單對一張採購單，則每張工單也要一併做確認
FUNCTION i301sub_firm1_other()
  DEFINE l_pmn01     LIKE pmn_file.pmn01
  DEFINE l_pmn41     LIKE pmn_file.pmn41
  DEFINE l_sfb       RECORD LIKE sfb_file.*
 
  DECLARE i301sub_tmp_cs CURSOR FOR SELECT * FROM i301sub_tmp
  FOREACH i301sub_tmp_cs INTO l_pmn01
     DECLARE i301sub_pmn_cs CURSOR FOR
      SELECT pmn41 FROM pmn_file WHERE pmn01=l_pmn01
     FOREACH i301sub_pmn_cs INTO l_pmn41
          IF l_pmn41 = l_sfb.sfb01 THEN CONTINUE FOREACH END IF
          SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01=l_pmn41
          IF STATUS THEN
#            CALL cl_err('sel sfb(chk#1):',STATUS,1)   #No.FUN-660128
             CALL cl_err3("sel","sfb_file",l_pmn41,"",STATUS,"","sel sfb(chk#1):",1)  #No.FUN-660128
             LET g_success='N'
             EXIT FOREACH
          END IF
          IF l_sfb.sfb87 = 'Y' THEN CONTINUE FOREACH END IF  #已確認
          UPDATE sfb_file SET sfb87 = 'Y' WHERE sfb01=l_sfb.sfb01
          IF STATUS THEN
#            CALL cl_err('upd sfb(chk#2):',STATUS,1)   #No.FUN-660128
             CALL cl_err3("upd","sfb_file",l_sfb.sfb01,"",STATUS,"","upd sfb(chk#2):",1)  #No.FUN-660128
             LET g_success='N'
             EXIT FOREACH
          END IF
          IF g_sma.sma27 MATCHES '[13]' AND l_sfb.sfb23 = 'Y'
             AND l_sfb.sfb04='1' THEN
             UPDATE sfb_file SET sfb04='2',sfb43='1' WHERE sfb01=l_sfb.sfb01  #FUN-8C0081 add sfb43
             IF STATUS THEN
#               CALL cl_err('upd sfb(chk#3):',STATUS,1)   #No.FUN-660128
                CALL cl_err3("upd","sfb_file",l_sfb.sfb01,"",STATUS,"","upd sfb(chk#3):",1)  #No.FUN-660128
                LET g_success='N'
                EXIT FOREACH
             END IF
          END IF
     END FOREACH
     IF g_success='N' THEN EXIT FOREACH END IF
  END FOREACH
END FUNCTION
 
FUNCTION i301sub_refresh(p_sfb01)
  DEFINE p_sfb01 LIKE sfb_file.sfb01
  DEFINE l_sfb RECORD LIKE sfb_file.*
 
  SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01=p_sfb01
  RETURN l_sfb.*
END FUNCTION
 
#TQC-730022
FUNCTION i301sub_sfb100(p_sfb)    #委外型態
    DEFINE p_sfb   RECORD LIKE sfb_file.*
    DEFINE l_smy57 LIKE smy_file.smy57
    DEFINE l_sfb01 LIKE sfb_file.sfb01   #FUN-640044 add
 
    LET g_errno=" "
    LET l_sfb01 = p_sfb.sfb01[1,g_doc_len]   #FUN-640044 add
    SELECT smy57 INTO l_smy57 FROM smy_file
        #WHERE smyslip = p_sfb.sfb01   #FUN-640044 mark
         WHERE smyslip = l_sfb01       #FUN-640044
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3045'
                                  LET l_smy57 = NULL
         OTHERWISE
    END CASE
    IF cl_null(g_errno) THEN
       LET p_sfb.sfb100 = l_smy57[6,6]
       IF cl_null(p_sfb.sfb100) THEN LET p_sfb.sfb100='1' END IF
    END IF
    RETURN p_sfb.sfb100
END FUNCTION
#TQC-730022 -end
 
#FUN-810038 由asfi301.4gl移過來
FUNCTION i301sub_ins_pmm(l_sfb)
   DEFINE l_pmm         RECORD LIKE pmm_file.*
   DEFINE l_pmn         RECORD LIKE pmn_file.*
   DEFINE l_sfa         RECORD LIKE sfa_file.*
   DEFINE l_umf         LIKE pmn_file.pmn09
   DEFINE l_sfa05       LIKE sfa_file.sfa05
   DEFINE l_ima55       LIKE ima_file.ima55
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
   DEFINE l_formid      LIKE oay_file.oayslip  #No.FUN-680121 VARCHAR(5) #MOD-590272
   DEFINE l_sfb         RECORD LIKE sfb_file.*    #FUN-810038
   DEFINE l_pmn01       LIKE pmn_file.pmn01       #FUN-810038
   DEFINE l_ima908      LIKE ima_file.ima908      #FUN-810038
   DEFINE l_mesg        LIKE type_file.chr1000    #FUN-810038
   DEFINE l_ima25       LIKE ima_file.ima25       #FUN-810038
   DEFINE l_ima44       LIKE ima_file.ima44       #FUN-810038
   DEFINE l_ima906      LIKE ima_file.ima906      #FUN-810038
   DEFINE l_ima907      LIKE ima_file.ima907      #FUN-810038
   DEFINE l_cnt1        LIKE type_file.num5       #FUN-810038
   DEFINE l_factor      LIKE ima_file.ima31_fac   #FUN-810038
   DEFINE l_ecdicd01    LIKE ecd_file.ecdicd01    #FUN-810038
   DEFINE l_imaicd01    LIKE imaicd_file.imaicd01 #FUN-810038
   DEFINE l_pmni        RECORD LIKE pmni_file.*   #FUN-810038
   DEFINE l_sfbiicd04   LIKE sfbi_file.sfbiicd04  #FUN-810038
   DEFINE l_pmnislk01   LIKE pmni_file.pmnislk01  #NO.FUN-870117
   DEFINE l_task        LIKE sfb_file.sfb06       #No.FUN-8A0143
   DEFINE l_gec07       LIKE gec_file.gec07       #No.MOD-8B0273 add
   DEFINE l_sfbi        RECORD LIKE sfbi_file.*    #FUN-980033
 
   LET g_success = 'Y'
   SELECT MAX(pmn01) INTO l_pmn01 FROM pmn_file WHERE pmn41=l_sfb.sfb01
 
 #MOD-470493(9785)
   #No.B356 避免有單頭無單身之採購單存在
   IF NOT cl_null(l_pmn01) THEN
      RETURN l_pmn01          #No.MOD-840419 modify
   ELSE
      SELECT pmm01 INTO l_pmn01 FROM pmm_file WHERE pmm01=l_sfb.sfb01
      IF NOT cl_null(l_pmn01) THEN
         LET g_success='N'
         RETURN l_pmn01          #No.MOD-840419 modify
   ELSE
      END IF
   END IF
 #MOD-470493(9785) end --
 
   IF l_pmn01 IS NOT NULL THEN RETURN l_pmn01 END IF    #No.MOD-840419 add
   #---------------------------------------------------------------------------
   INITIALIZE l_pmm.* TO NULL
   LET l_pmm.pmm01 =l_sfb.sfb01
   LET l_pmm.pmm02 ='SUB'
   LET l_pmm.pmm04 =TODAY
    #MOD-510023
   SELECT azn02,azn04 INTO l_pmm.pmm31,l_pmm.pmm32
     FROM azn_file WHERE azn01 = l_pmm.pmm04
   #--
 
   LET l_pmm.pmm09 =l_sfb.sfb82
   SELECT pmc15,pmc16,pmc17,pmc47,pmc22,pmc49
     INTO l_pmm.pmm10,l_pmm.pmm11,l_pmm.pmm20,l_pmm.pmm21,l_pmm.pmm22,
          l_pmm.pmm41
           FROM pmc_file
          WHERE pmc01=l_pmm.pmm09
   LET l_pmm.pmm12 =g_user
   SELECT gen03 INTO l_pmm.pmm13 FROM gen_file WHERE gen01= l_pmm.pmm12
   LET l_pmm.pmm18 ='N'
   LET l_pmm.pmm25 ='0'
 
   #FUN-810038................begin
   IF NOT cl_null(g_pmm22) AND s_industry('icd') THEN
      LET l_pmm.pmm22 = g_pmm22
      LET l_pmm.pmm42 = g_pmm42
   ELSE
   #FUN-810038................end
      #BugNO:3522 01/09/10 mandy
      IF g_aza.aza17 = l_pmm.pmm22 THEN   #本幣
          LET l_pmm.pmm42 = 1
      ELSE
          CALL s_curr3(l_pmm.pmm22,l_pmm.pmm04,'S')
              RETURNING l_pmm.pmm42
      END IF
   END IF
 
  #SELECT gec04 INTO l_pmm.pmm43 FROM gec_file                #No.MOD-8B0273 mark
   SELECT gec04,gec07 INTO l_pmm.pmm43,l_gec07 FROM gec_file  #No.MOD-8B0273 add
          WHERE gec01= l_pmm.pmm21 AND gec011='1'
   IF SQLCA.SQLCODE THEN LET l_pmm.pmm43 = 0
   ELSE IF cl_null(l_pmm.pmm43) THEN LET l_pmm.pmm43 = 0 END IF END IF
   LET l_pmm.pmm30 = 'N' #MOD-530617
   LET l_pmm.pmm45 ='N'   #FUN-690047 modify #'Y'
   LET l_formid = s_get_doc_no(l_sfb.sfb01) #MOD-590272
   #MOD-580101-begin
   #IF g_sfb.sfb100='1' THEN      #一對一   #MOD-860016 mark
      SELECT smyapr INTO l_pmm.pmmmksg FROM smy_file
     #WHERE smyslip=substr(l_sfb.sfb01,1,3) #MOD-590272
      WHERE smyslip=l_formid
   #ELSE                         #MOD-860016 mark
   #   LET l_pmm.pmmmksg ='N'    #MOD-860016 mark
   #END IF                       #MOD-860016 mark
   #MOD-580101-end
   LET l_pmm.pmmacti ='Y'
   LET l_pmm.pmmprsw ='Y'
   LET l_pmm.pmmuser =g_user
   LET l_pmm.pmmoriu = g_user #FUN-980030   #No.MOD-960317
   LET l_pmm.pmmorig = g_grup #FUN-980030   #No.MOD-960317
   LET g_data_plant = g_plant #FUN-980030
   LET l_pmm.pmmgrup =g_grup
   LET l_pmm.pmmdate =TODAY
   LET l_pmm.pmm51 = ' '     #NO.FUN-960130   #NO.FUN-9B0016
   LET l_pmm.pmmpos = 'N'    #NO.FUN-960130
 
   LET l_pmm.pmmplant = g_plant    #FUN-980008  add
   LET l_pmm.pmmlegal = g_legal    #FUN-980008  add
 
   INSERT INTO pmm_file VALUES(l_pmm.*)
   IF STATUS THEN
  #   CALL cl_err('ins pmm:',STATUS,1)  #No.FUN-660128
     CALL cl_err3("ins","pmm_file",l_pmm.pmm01,"",STATUS,"","ins pmm:",1)  #No.FUN-660128
        LET g_success='N' RETURN l_pmn01 END IF     #No.MOD-840419 modify
 
   #---------------------------------------------------------------------------
   INITIALIZE l_pmn.* TO NULL
   LET l_pmn.pmn01 =l_sfb.sfb01
   LET l_pmn.pmn011='SUB'
   LET l_pmn.pmn02 =1
   LET l_pmn.pmn04 =l_sfb.sfb05
 
  #-------No.MOD-6A0071 modify
  #SELECT ima02,ima44,ima25,ima55
  #  INTO l_pmn.pmn041,l_pmn.pmn07,l_pmn.pmn08,l_ima55
   SELECT ima02,ima44,ima25,ima55,ima15,ima908                                #MOD-730044 modify
     INTO l_pmn.pmn041,l_pmn.pmn07,l_pmn.pmn08,l_ima55,l_pmn.pmn64,l_ima908   #MOD-730044 modify
     FROM ima_file WHERE ima01=l_pmn.pmn04
  #-------No.MOD-6A0071 end
   CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn07,l_pmn.pmn08)
        RETURNING l_flag,l_pmn.pmn09      #取換算率(採購對庫存)
   IF l_flag=1 THEN
      #單位換算率抓不到
       #---No.MOD-5A0008 add
      LET l_mesg = NULL
      LET l_mesg =l_pmn.pmn04,"(pmn07/pmn08):"
      CALL cl_err(l_mesg,'abm-731',1)
      #CALL cl_err('pmn07/pmn08: ','abm-731',1)
    #--end
      LET g_success ='N'
      RETURN l_pmn01          #No.MOD-840419 modify
   END IF
 # LET l_pmn.pmn09 =1
   LET l_pmn.pmn11 ='N'
   LET l_pmn.pmn13 =0
   CALL s_overate(l_pmn.pmn04) RETURNING l_pmn.pmn13  #MOD-7B0024
   LET l_pmn.pmn14 ='Y'
   LET l_pmn.pmn15 ='Y'
   LET l_pmn.pmn16 ='0'
 
  #NO.3524 add By Carol:取換算率(生管對採購)
   CALL s_umfchk(l_pmn.pmn04,l_ima55,l_pmn.pmn07)
        RETURNING l_flag,l_umf
   IF l_flag=1 THEN
      #單位換算率抓不到
  #---No.MOD-5A0008 add
      LET l_mesg=NULL
      LET l_mesg =l_pmn.pmn04,"(ima55/pmn07):"
      CALL cl_err(l_mesg,'abm-731',1)
      #CALL cl_err('ima55/pmn07: ','abm-731',1)
   #--end
      LET g_success ='N'
      RETURN l_pmn01          #No.MOD-840419 modify
   END IF
   #FUN-810038................begin
   IF s_industry('icd') THEN
   #若l_sfb.sfb08沒有值,則取l_sfbi.sfbiicd04
      IF NOT cl_null(l_sfb.sfb08) THEN
         LET l_pmn.pmn20 =l_sfb.sfb08 * l_umf  #生管數量*換算率=應採購量
      ELSE
         SELECT sfbiicd04 INTO l_sfbiicd04
           FROM sfbi_file
          WHERE sfbi01=g_sfb.sfb01
         IF cl_null(l_sfbiicd04) OR l_sfbiicd04=0 THEN
            LET l_sfbiicd04=1
         END IF
         LET l_pmn.pmn20 =l_sfbiicd04 * l_umf  #生管數量*換算率=應採購量
      END IF
   ELSE
   #FUN-810038................end
      LET l_pmn.pmn20 =l_sfb.sfb08 * l_umf  #生管數量*換算率=應採購量
   END IF
  #...............................................................
 
  #No.B549 010517 add by linda
  #LET l_pmn.pmn31 =0
  #MOD-730044-begin-mark
  # #No.FUN-610018 --start--
  # CALL s_defprice(l_pmn.pmn04,l_pmm.pmm09,l_pmm.pmm22,l_pmm.pmm04,l_pmn.pmn20,'',l_pmm.pmm21,l_pmm.pmm43,'2') #NO:7178  #No.FUN-670099
  #    RETURNING l_pmn.pmn31,l_pmn.pmn31t
  # IF cl_null(l_pmn.pmn31) THEN
  #    LET l_pmn.pmn31=0
  #    LET l_pmn.pmn31t=0
  # END IF
  #MOD-730044-end-mark
  #No.B549 END
  #BugNo.7259
  # LET l_pmn.pmn31t=l_pmn.pmn31*(1.0+l_pmm.pmm43/100.0)
  #BugNo.7259 END
   #No.FUN-610018 --end--
   LET l_pmn.pmn33 =l_sfb.sfb15
   LET l_pmn.pmn34 =l_sfb.sfb15
   LET l_pmn.pmn35 =l_sfb.sfb15
   LET l_pmn.pmn38 ='N'   #FUN-690047 modify  #'Y'
   LET l_pmn.pmn41 =l_sfb.sfb01
   LET l_pmn.pmn42 ='0'
   LET l_pmn.pmn43 =0
   LET l_pmn.pmn431=0
   LET l_pmn.pmn50 =0
   LET l_pmn.pmn51 =0
   LET l_pmn.pmn53 =0
   LET l_pmn.pmn55 =0
   LET l_pmn.pmn57 =0
   LET l_pmn.pmn61 =l_pmn.pmn04
   LET l_pmn.pmn62 =1
   LET l_pmn.pmn63 = 'N'   #00/05/19 modify
  #LET l_pmn.pmn64 = 'N'   #No.MOD-6A0071 mark
   LET l_pmn.pmn65 ='1'
   LET l_pmn.pmn122 = l_sfb.sfb27    #MOD-750080 add  #專案代號
#FUN-810045 add begin
   LET l_pmn.pmn96 = l_sfb.sfb271  #WBS代號
   LET l_pmn.pmn97 = l_sfb.sfb50   #活動
   LET l_pmn.pmn98 = l_sfb.sfb51   #理由碼
#FUN-810045 add end
   LET l_pmn.pmn90 =l_pmn.pmn31   #CHI-690043 add
 
{
 #MOD-470493(9785) mark
   #NO:6961
   IF l_sfb.sfb02='8' THEN          #8.重工委外要卡單身應發數量 < 0 不可轉到採購單
       SELECT sfa05 INTO l_sfa05 FROM sfa_file,sfb_file
        WHERE sfa01 = sfb01
          AND sfb01 = l_sfb.sfb01   #工單單號
          AND sfa03 = l_pmn.pmn04   #料號
       IF cl_null(l_sfa05) THEN LET l_sfa05=0 END IF
       IF l_sfa05 > 0 THEN
           INSERT INTO pmn_file VALUES(l_pmn.*)
           IF STATUS THEN CALL cl_err('ins pmn:',STATUS,1) 
              LET g_success='N' 
              RETURN l_pmn01          #No.MOD-840419 modify
           END IF
       ELSE
           LET l_pmn.pmn02=0
       END IF
   ELSE
}
       #No.FUN-560084  -begin
       IF g_sma.sma115 = 'Y' THEN
          SELECT ima25,ima44,ima906,ima907
            INTO l_ima25,l_ima44,l_ima906,l_ima907
            FROM ima_file WHERE ima01=l_pmn.pmn04
          IF SQLCA.sqlcode =100 THEN
             IF l_pmn.pmn04 MATCHES 'MISC*' THEN
                SELECT ima25,ima44,ima906,ima907
                  INTO l_ima25,l_ima44,l_ima906,l_ima907
                  FROM ima_file WHERE ima01='MISC'
             END IF
          END IF
          IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
          LET l_pmn.pmn80=l_pmn.pmn07
          LET l_factor = 1
          CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn80,l_ima44)
               RETURNING l_cnt1,l_factor
          IF l_cnt1 = 1 THEN
             LET l_factor = 1
          END IF
          LET l_pmn.pmn81=l_factor
          LET l_pmn.pmn82=l_pmn.pmn20
          LET l_pmn.pmn83=l_ima907
          LET l_factor = 1
          CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn83,l_ima44)
               RETURNING l_cnt1,l_factor
          IF l_cnt1 = 1 THEN
             LET l_factor = 1
          END IF
          LET l_pmn.pmn84=l_factor
          LET l_pmn.pmn85=0
          IF l_ima906 = '3' THEN
             LET l_factor = 1
             CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn80,l_pmn.pmn83)
               RETURNING l_cnt1,l_factor
             IF l_cnt1 = 1 THEN
                LET l_factor = 1
             END IF
             LET l_pmn.pmn85=l_pmn.pmn82*l_factor
          END IF
       END IF
       LET l_pmn.pmn86=l_pmn.pmn07
       LET l_pmn.pmn87=l_pmn.pmn20
       LET l_pmn.pmn90=l_pmn.pmn31   #CHI-690043 add
       #No.FUN-560084  -end
 
      #MOD-730044-beign-add
       #No.FUN-8A0143  --Begin
       #CALL s_defprice(l_pmn.pmn04,l_pmm.pmm09,l_pmm.pmm22,l_pmm.pmm04,
       #                l_pmn.pmn87,'',l_pmm.pmm21,l_pmm.pmm43,"2",
       #                l_pmn.pmn86,'') #NO:7178  #MOD-730044
       #   RETURNING l_pmn.pmn31,l_pmn.pmn31t
 
       #FUN-980033--begin--add--
       IF s_industry('icd') THEN
          SELECT sfbi_file.* ,ecdicd01 INTO l_sfbi.*,l_ecdicd01
            FROM sfbi_file LEFT OUTER JOIN ecd_file ON sfbiicd09=ecd01
           WHERE sfbi01=l_sfb.sfb01
       END IF
       IF s_industry('icd') AND l_ecdicd01 MATCHES '[23456]' THEN  
          CALL i301sub_icd_price(l_sfb.*,l_sfbi.*,l_ecdicd01,l_pmm.pmm04, 
                                 l_pmm.pmm22,l_pmm.pmm21,l_pmm.pmm43,l_pmn.pmn86,l_pmm.pmm41,l_pmm.pmm20)
          RETURNING l_pmn.pmn31,l_pmn.pmn31t
       ELSE
       #FUN-980033--end--add--
       LET l_task = l_sfb.sfb06
       IF cl_null(l_task) THEN LET l_task = ' ' END IF
       #TQC-9B0214-------start-------
       #CALL s_defprice(l_pmn.pmn04,l_pmm.pmm09,l_pmm.pmm22,l_pmm.pmm04,
       #               l_pmn.pmn87,l_task,l_pmm.pmm21,l_pmm.pmm43,"2",
       #               l_pmn.pmn86,'',l_pmm.pmm41,l_pmm.pmm20) #NO:7178  #MOD-730044   #No.FUN-930148 add-pmm20,pmm41
       #  RETURNING l_pmn.pmn31,l_pmn.pmn31t
       CALL s_defprice_new(l_pmn.pmn04,l_pmm.pmm09,l_pmm.pmm22,l_pmm.pmm04,
                       l_pmn.pmn87,l_task,l_pmm.pmm21,l_pmm.pmm43,"2",
                       l_pmn.pmn86,'',l_pmm.pmm41,l_pmm.pmm20,g_plant)
          RETURNING l_pmn.pmn31,l_pmn.pmn31t
       #TQC-9B0214-------end-------
       END IF #FUN-980033
       #No.FUN-8A0143  --End  
       IF cl_null(l_pmn.pmn31) THEN
          LET l_pmn.pmn31=0
          LET l_pmn.pmn31t=0
       END IF
      #MOD-730044-end-add
 
       #FUN-670061...............begin
       IF NOT (cl_null(l_pmn.pmn24) AND cl_null(l_pmn.pmn25)) THEN
          SELECT pml930 INTO l_pmn.pmn930 FROM pml_file
                                         WHERE pml01=l_pmn.pmn24
                                           AND pml02=l_pmn.pmn25
          IF SQLCA.sqlcode THEN
             LET l_pmn.pmn930=NULL
          END IF
       ELSE
          LET l_pmn.pmn930=s_costcenter(l_pmm.pmm13)
       END IF
       #FUN-670061...............end
 
      #CHI-680014 add--begin
       #SELECT azi04 INTO t_azi04 FROM azi_file                #No.MOD-8B0273 mark
        SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file  #No.MOD-8B0273 add
         WHERE azi01 = l_pmm.pmm22  AND aziacti= 'Y'  #原幣
        LET l_pmn.pmn88 = cl_digcut(l_pmn.pmn31  * l_pmn.pmn87 ,t_azi04)
        LET l_pmn.pmn88t= cl_digcut(l_pmn.pmn31t * l_pmn.pmn87 ,t_azi04)
        LET l_pmn.pmn930 = l_sfb.sfb98    #No.FUN-870117
      #CHI-680014 add--end
      #No.TQC-980183--Mark--Begin--#
      #No.MOD-8B0273 add --begin
#      IF l_gec07 = 'N' THEN 
#         LET l_pmn.pmn88  = cl_digcut(l_pmn.pmn88,t_azi04)
#         LET l_pmn.pmn88t = l_pmn.pmn88 * ( 1 + l_pmm.pmm43/100)
#      ELSE
#         LET l_pmn.pmn88t = cl_digcut(l_pmn.pmn88t,t_azi04)
#         LET l_pmn.pmn88  = l_pmn.pmn88t / ( 1 + l_pmm.pmm43/100)
#         LET l_pmn.pmn88  = cl_digcut(l_pmn.pmn88,t_azi04)
#         IF NOT cl_null(l_pmn.pmn87) AND l_pmn.pmn87 != 0 THEN
#            LET l_pmn.pmn31  = l_pmn.pmn88 / l_pmn.pmn87
#            LET l_pmn.pmn31  = cl_digcut(l_pmn.pmn31,t_azi03)
#         END IF
#      END IF
      #No.MOD-8B0273 add --end
      #No.TQC-980183--Mark--End--#
       IF cl_null(l_pmn.pmn02) THEN LET l_pmn.pmn02 = 0 END IF   #TQC-790002 add
       #FUN-810038................begin
       IF s_industry('icd') THEN
          CALL i301sub_ind_icd_ins_pmni(l_sfb.*,l_pmm.*,l_pmn.*)
             RETURNING l_pmn.*,l_pmni.*
       END IF
       #FUN-810038................end
       #No.FUN-870117 --begin--
       IF s_industry('slk') THEN 
        SELECT sfcislk01 INTO l_pmni.pmnislk01  FROM  sfci_file
         WHERE sfci01 = l_sfb.sfb85 
       END IF                              
       #No.FUN-870117 --end--
       LET l_pmn.pmn73 = ' '   #NO.FUN-960130
 
       LET l_pmn.pmnplant = g_plant    #FUN-980008  add
       LET l_pmn.pmnlegal = g_legal    #FUN-980008  add
       LET l_pmn.pmn89 = 'N'           #No.TQC-9B0079
       IF cl_null(l_pmn.pmn58) THEN LET l_pmn.pmn58 = 0 END IF  #TQC-9B0203 
 
       INSERT INTO pmn_file VALUES(l_pmn.*)
       IF STATUS THEN
#         CALL cl_err('ins pmn:',STATUS,1)   #No.FUN-660128
          CALL cl_err3("ins","pmn_file",l_pmn.pmn02,"",STATUS,"","ins pmn:",1)  #No.FUN-660128
          LET g_success='N'
          RETURN l_pmn01          #No.MOD-840419 modify
 #MOD-470493(9785) add
       ELSE
          IF SQLCA.SQLERRD[3]=0  THEN
             DELETE FROM pmm_file where pmm01=l_sfb.sfb01
             IF STATUS THEN
              #   CALL cl_err('delete pmm:',STATUS,1)   #No.FUN-660128
                CALL cl_err3("del","pmm_file",l_sfb.sfb01,"",STATUS,"","delete pmm:",1)  #No.FUN-660128
                LET g_success='N'
                RETURN l_pmn01          #No.MOD-840419 modify
             END IF
          ELSE
             #FUN-810038................begin
             IF NOT s_industry('std') THEN
                LET l_pmni.pmni01=l_pmn.pmn01
                LET l_pmni.pmni02=l_pmn.pmn02
                IF NOT s_ins_pmni(l_pmni.*,'') THEN
                   LET g_success='N'
                   RETURN l_pmn01          #No.MOD-840419 modify
                END IF
             END IF
             #FUN-810038................end
          END IF
      END IF
##
 #  END IF        #MOD-470493(9785) mark
   #NO:6961
   #---------------------------------------------------------------------------
   DECLARE i301_ins_pmn_c CURSOR FOR
         SELECT * FROM sfa_file
          WHERE sfa01=l_sfb.sfb01
             AND sfa065>0 AND sfa05 > 0 #MOD-470493(9785) sfa05>0產生採購單才有意義
   FOREACH i301_ins_pmn_c INTO l_sfa.*
{
 #MOD-470493(9785) mark
      IF l_sfb.sfb02='8' THEN     #NO:69618.重工委外要卡單身應發數量 < 0 不可轉到採購單
          IF l_sfa.sfa05 < 0 THEN
             CONTINUE FOREACH
          END IF
      END IF
}
      LET l_pmn.pmn02 =l_pmn.pmn02 + 1
      LET l_pmn.pmn04 =l_sfa.sfa03
      SELECT ima02,ima44,ima25,ima55
        INTO l_pmn.pmn041,l_pmn.pmn07,l_pmn.pmn08,l_ima55
        FROM ima_file WHERE ima01=l_pmn.pmn04
     #NO.3524 add By Carol.........................................
      CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn07,l_pmn.pmn08)
           RETURNING l_flag,l_pmn.pmn09      #取換算率(採購對庫存)
      IF l_flag=1 THEN
         #單位換算率抓不到
     #---No.MOD-5A0008 add
         LET l_mesg=NULL
         LET l_mesg =l_pmn.pmn04,"(pmn07/pmn08):"
         CALL cl_err(l_mesg,'abm-731',1)
         #CALL cl_err('sfa:pmn07/pmn08: ','abm-731',1)
      #---end
 
         LET g_success ='N'
         RETURN l_pmn01          #No.MOD-840419 modify
      END IF
      CALL s_umfchk(l_pmn.pmn04,l_ima55,l_pmn.pmn07)
           RETURNING l_flag,l_umf            #取換算率(生管對採購)
      IF l_flag=1 THEN
         #單位換算率抓不到
     #---No.MOD-5A0008 add
         LET l_mesg=NULL
         LET l_mesg =l_pmn.pmn04,"(ima55/pmn07):"
         CALL cl_err(l_mesg,'abm-731',1)
         #CALL cl_err('sfa:ima55/pmn07: ','abm-731',1)
      #---end
 
         LET g_success ='N'
         RETURN l_pmn01          #No.MOD-840419 modify
      END IF
      LET l_pmn.pmn20 =l_sfa.sfa065 * l_umf
     #..............................................................
      #BugNo:4522
     #MOD-730044-beign-mark
     # #No.FUN-610018 --start--
     # CALL s_defprice(l_pmn.pmn04,l_pmm.pmm09,l_pmm.pmm22,l_pmm.pmm04,l_pmn.pmn20,'',l_pmm.pmm21,l_pmm.pmm43,'2') #NO:7178  #No.FUN-670099
     #    RETURNING l_pmn.pmn31,l_pmn.pmn31t
     # IF cl_null(l_pmn.pmn31) THEN
     #    LET l_pmn.pmn31=0
     #    LET l_pmn.pmn31t=0
     # END IF
     #MOD-730044-end-mark
      #LET l_pmn.pmn31t=l_pmn.pmn31+(1.0/l_pmm.pmm43/100.0)  #BugNo.7259
      #No.FUN-610018 --end--
      LET l_pmn.pmn61 =l_pmn.pmn04
      LET l_pmn.pmn62 =1
      LET l_pmn.pmn65 ='2'
       #No.FUN-560084  -begin
       IF g_sma.sma115 = 'Y' THEN
          SELECT ima44,ima906,ima907 INTO l_ima44,l_ima906,l_ima907
            FROM ima_file WHERE ima01=l_pmn.pmn04
          LET l_pmn.pmn80=l_pmn.pmn07
          LET l_factor = 1
          CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn80,l_ima44)
               RETURNING l_cnt1,l_factor
          IF l_cnt1 = 1 THEN
             LET l_factor = 1
          END IF
          LET l_pmn.pmn81=l_factor
          LET l_pmn.pmn82=l_pmn.pmn20
          LET l_pmn.pmn83=l_ima907
          LET l_factor = 1
          CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn83,l_ima44)
               RETURNING l_cnt1,l_factor
          IF l_cnt1 = 1 THEN
             LET l_factor = 1
          END IF
          LET l_pmn.pmn84=l_factor
          LET l_pmn.pmn85=0
          IF l_ima906 = '3' THEN
             LET l_factor = 1
             CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn80,l_pmn.pmn83)
               RETURNING l_cnt1,l_factor
             IF l_cnt1 = 1 THEN
                LET l_factor = 1
             END IF
             LET l_pmn.pmn85=l_pmn.pmn82*l_factor
          END IF
       END IF
       LET l_pmn.pmn86=l_pmn.pmn07
       LET l_pmn.pmn87=l_pmn.pmn20
       LET l_pmn.pmn90=l_pmn.pmn31   #CHI-690043 add
       #No.FUN-560084  -end
       #FUN-670061...............begin
       IF NOT (cl_null(l_pmn.pmn24) AND cl_null(l_pmn.pmn25)) THEN
          SELECT pml930 INTO l_pmn.pmn930 FROM pml_file
                                         WHERE pml01=l_pmn.pmn24
                                           AND pml02=l_pmn.pmn25
       ELSE
          LET l_pmn.pmn930=s_costcenter(l_pmm.pmm13)
       END IF
       #FUN-670061...............end
 
      #MOD-730044-begin-add
       IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
          LET l_pmn.pmn86=l_ima908
       END IF
       IF cl_null(l_pmn.pmn87) THEN LET l_pmn.pmn87 = 0 END IF
       LET l_factor = 1
       CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn07,l_pmn.pmn86)
             RETURNING l_cnt1,l_factor
       IF l_cnt1 = 1 THEN
          LET l_factor = 1
       END IF
       LET l_pmn.pmn87 = l_pmn.pmn87  * l_factor
       #carrier 080924  --begin
       #可以BY作業編號來取價
       #CALL s_defprice(l_pmn.pmn04,l_pmm.pmm09,l_pmm.pmm22,l_pmm.pmm04,
       #                l_pmn.pmn87,'',l_pmm.pmm21,l_pmm.pmm43,"2",l_pmn.pmn86,'') #NO:7178  #MOD-730044 modify
       #   RETURNING l_pmn.pmn31,l_pmn.pmn31t
       #No.FUN-8A0143  --Begin
       LET l_task = l_sfa.sfa08
       IF cl_null(l_task) THEN 
          LET l_task = l_sfb.sfb06
       END IF
       IF cl_null(l_task) THEN LET l_task = ' ' END IF
       #CALL s_defprice(l_pmn.pmn04,l_pmm.pmm09,l_pmm.pmm22,l_pmm.pmm04,
       #                l_pmn.pmn87,l_sfa.sfa08,l_pmm.pmm21,l_pmm.pmm43,"2",l_pmn.pmn86,'') #NO:7178  #MOD-730044 modify
       #   RETURNING l_pmn.pmn31,l_pmn.pmn31t
       #TQC-9B0214-------start-------
       #CALL s_defprice(l_pmn.pmn04,l_pmm.pmm09,l_pmm.pmm22,l_pmm.pmm04,
       #                 l_pmn.pmn87,l_task,l_pmm.pmm21,l_pmm.pmm43,"2",l_pmn.pmn86,'',l_pmm.pmm41,l_pmm.pmm20) #NO:7178  #MOD-730044 modify  #No.FUN-930148 add-pmm20,pmm41
       #   RETURNING l_pmn.pmn31,l_pmn.pmn31t
       CALL s_defprice_new(l_pmn.pmn04,l_pmm.pmm09,l_pmm.pmm22,l_pmm.pmm04,
                        l_pmn.pmn87,l_task,l_pmm.pmm21,l_pmm.pmm43,"2",l_pmn.pmn86,'',l_pmm.pmm41,l_pmm.pmm20,g_plant)
          RETURNING l_pmn.pmn31,l_pmn.pmn31t
       #TQC-9B0214-------end-------
       #No.FUN-8A0143  --End  
       #carrier 080924  --End  
       IF cl_null(l_pmn.pmn31) THEN
          LET l_pmn.pmn31=0
          LET l_pmn.pmn31t=0
       END IF
      #MOD-730044-end-add
 
     #CHI-680014 add--begin
      #SELECT azi04 INTO t_azi04 FROM azi_file                #No.MOD-8B0273 mark
       SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file  #No.MOD-8B0273 add
        WHERE azi01 = l_pmm.pmm22  AND aziacti= 'Y'  #原幣
       LET l_pmn.pmn88 = cl_digcut(l_pmn.pmn31  * l_pmn.pmn87 ,t_azi04)
       LET l_pmn.pmn88t= cl_digcut(l_pmn.pmn31t * l_pmn.pmn87 ,t_azi04)
     #CHI-680014 add--end
     #No.TQC-980183--Mark--Begin--#
     #No.MOD-8B0273 add --begin
#      IF l_gec07 = 'N' THEN 
#         LET l_pmn.pmn88  = cl_digcut(l_pmn.pmn88,t_azi04)
#         LET l_pmn.pmn88t = l_pmn.pmn88 * ( 1 + l_pmm.pmm43/100)
#      ELSE
#         LET l_pmn.pmn88t = cl_digcut(l_pmn.pmn88t,t_azi04)
#         LET l_pmn.pmn88  = l_pmn.pmn88t / ( 1 + l_pmm.pmm43/100)
#         LET l_pmn.pmn88  = cl_digcut(l_pmn.pmn88,t_azi04)
#         IF NOT cl_null(l_pmn.pmn87) AND l_pmn.pmn87 != 0 THEN
#            LET l_pmn.pmn31  = l_pmn.pmn88 / l_pmn.pmn87
#            LET l_pmn.pmn31  = cl_digcut(l_pmn.pmn31,t_azi03)
#         END IF
#      END IF
     #No.MOD-8B0273 add --end
     #No.TQC-980183--Mark--End--#
      IF cl_null(l_pmn.pmn02) THEN LET l_pmn.pmn02 = 0 END IF   #TQC-790002 add
      LET l_pmn.pmn930 = l_sfb.sfb98    #No.FUN-870117
      #No.FUN-870117 --begin--
       IF s_industry('slk') THEN 
        SELECT sfcislk01 INTO l_pmni.pmnislk01  FROM  sfci_file
         WHERE sfci01 = l_sfb.sfb85
       END IF                              
       #No.FUN-870117 --end--
      LET l_pmn.pmn73 = ' '   #NO.FUN-960130
      LET l_pmn.pmnplant = g_plant    #FUN-980008  add
      LET l_pmn.pmnlegal = g_legal    #FUN-980008  add
      LET l_pmn.pmn89 = 'N'           #No.TQC-9B0079
      IF cl_null(l_pmn.pmn58) THEN LET l_pmn.pmn58 = 0 END IF  #TQC-9B0203 
 
      INSERT INTO pmn_file VALUES(l_pmn.*)
      IF STATUS THEN
        CALL cl_err('ins pmn:',STATUS,1)   #No.FUN-660128
        CALL cl_err3("ins","pmn_file",l_pmn.pmn01,l_pmn.pmn02,STATUS,"","ins pmn:",1)  #No.FUN-660128
      #FUN-810038................begin
      ELSE
         IF NOT s_industry('std') THEN
            LET l_pmni.pmni01=l_pmn.pmn01
            LET l_pmni.pmni02=l_pmn.pmn02
            LET l_cnt1=s_ins_pmni(l_pmni.*,'')
         END IF
      END IF      
      #FUN-810038................end
   END FOREACH
   LET l_pmn01=l_sfb.sfb01
 
   #BugNO:3321
   #No.FUN-610018
   SELECT SUM(pmn31*pmn20),SUM(pmn31t*pmn20)
     INTO l_pmm.pmm40,l_pmm.pmm40t
     FROM pmn_file
    WHERE pmn01 = l_sfb.sfb01
   LET l_pmm.pmm40 = cl_digcut(l_pmm.pmm40,g_azi04)
   LET l_pmm.pmm40t = cl_digcut(l_pmm.pmm40t,g_azi04)
   UPDATE pmm_file
      SET pmm40 = l_pmm.pmm40,
          pmm40t= l_pmm.pmm40t
    WHERE pmm01 = l_sfb.sfb01
    RETURN l_pmn01            #No.MOD-840419 add
END FUNCTION
 
#ICD begin
#FUN-810038................begin
#檢查ICD的資料正確否,不正確則 let g_success= N
FUNCTION i301sub_ind_icd_chk(p_cmd,l_sfb,l_sfbi)
   DEFINE l_ecd07     LIKE ecd_file.ecd07,
          l_ecdacti   LIKE ecd_file.ecdacti,
          l_ecdicd01  LIKE ecd_file.ecdicd01
   DEFINE p_cmd       LIKE type_file.chr1
   DEFINE l_sfb       RECORD LIKE sfb_file.*
   DEFINE l_sfbi      RECORD LIKE sfbi_file.*
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_icr01     LIKE icr_file.icr01
   DEFINE l_icr02     LIKE icr_file.icr02
 
   IF NOT cl_null(l_sfbi.sfbiicd09) THEN
      SELECT ecd07,ecdicd01,ecdacti 
        INTO l_ecd07,l_ecdicd01,l_ecdacti
        FROM ecd_file
       WHERE ecd01 = l_sfbi.sfbiicd09
      CASE WHEN SQLCA.SQLCODE = 100
                CALL cl_err(l_sfbi.sfbiicd09,'aec-015',1)
                LET g_success = 'N' RETURN l_sfbi.*
           WHEN l_ecdacti <> 'Y'
                CALL cl_err(l_sfbi.sfbiicd09,'9028',1)
                LET g_success = 'N' RETURN l_sfbi.*
           WHEN l_ecdicd01 = '1'
                CALL cl_err(l_sfbi.sfbiicd09,'aic-127',1)
                LET g_success = 'N' RETURN l_sfbi.*
      END CASE
   END IF
 
   #除了作業群組=3.DS 或 4.ASS ,其餘作業群組不允工單確認後生產數量(sfb08)為空白
   IF cl_null(l_sfb.sfb08) THEN
      IF cl_null(l_sfbi.sfbiicd09) THEN
         CALL cl_err(l_sfb.sfb01,'aic-143',1)
         LET g_success = 'N'
         RETURN l_sfbi.*
      ELSE
         IF l_ecdicd01 NOT MATCHES '[34]' THEN
            CALL cl_err(l_sfb.sfb01,'aic-143',1)
            LET g_success = 'N'
            RETURN l_sfbi.*
         END IF
      END IF
   END IF
 
   IF l_ecdicd01 MATCHES '[46]' THEN
      #Date Code(sfbiicd07):若作業群組=4.ASS或6.TKY,且在料件備註檔
      #DateCode否(imaicd09)='Y',Wafer廠商(sfbiicd02)或Wafer廠別(sfbiicd03)或
      #廠商主檔中不存在,則無法產生DateCode,
      #出現錯誤訊息,並不允許確認
 
      #wafer廠商/wafer廠別(sfbiicd02/sfbiicd03):若作業群組=4.ASS或6.TKY,
      #若該欄位為空白,則出現錯誤訊息,並不允許確認
     #---------------No.MOD-9A0044 mark
     #IF cl_null(l_sfbi.sfbiicd02) OR cl_null(l_sfbi.sfbiicd03) THEN
     #   CALL cl_err(l_sfb.sfb01,'aic-144',1)
     #   LET g_success = 'N' RETURN l_sfbi.*
     #END IF
     #---------------No.MOD-9A0044 end
 
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM ima_file,imaicd_file
       WHERE ima01 = l_sfb.sfb05
         AND ima01=imaicd00
         AND imaicd09 = 'Y'
      IF l_cnt > 0 THEN
         IF cl_null(l_sfb.sfb82) THEN
            CALL cl_err(l_sfb.sfb01,'aic-145',1)
            LET g_success = 'N' RETURN l_sfbi.*
         END IF
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM pmc_file
          WHERE pmc01 = l_sfb.sfb82
         IF l_cnt = 0 THEN
            CALL cl_err(l_sfb.sfb01,'aic-145',1)
            LET g_success = 'N' RETURN l_sfbi.*
         END IF
      END IF
 
     #FUN-980033--begin--mark--
     ##打線圖(sfbiicd11):若作業群組=4.ASS或6.TKY,若該欄位為空白
     ##則出現錯誤訊息,並不允許確認
     #IF cl_null(l_sfbi.sfbiicd11) THEN
     #   CALL cl_err(l_sfb.sfb01,'aic-146',1)
     #   LET g_success = 'N' RETURN l_sfbi.*
     #END IF
 
     ##PKG(sfbiicd12):若作業群組=4.ASS或6.TKY,若該欄位為空白
     ##則出現錯誤訊息,並不允許確認
     #IF cl_null(l_sfbi.sfbiicd12) THEN
     #   CALL cl_err(l_sfb.sfb01,'aic-144',1)
     #   LET g_success = 'N' RETURN l_sfbi.*
     #END IF
     #FUN-980033--end--mark--
   END IF
   #部門廠商(sfb82):若工單性質=7.委外或8.委外重工,若該欄位為空白
   #則出現錯誤訊息,並不允許確認
   IF l_sfb.sfb02 MATCHES '[78]' THEN
      IF cl_null(l_sfb.sfb82) THEN
         CALL cl_err(l_sfb.sfb01,'aic-147',1)
         LET g_success = 'N' RETURN l_sfbi.*
      END IF
   END IF
 
  #CHI-830032...............begin #pkg此處先不卡,發料確認時會檢查  
  ##倉庫(sfa30)/儲位(sfa31)/批號(sfaiicd03):若發料(sfa03)之狀態(imaicd04)=0-4,
  ##則倉庫/儲位/批號三個欄位不可為空白,若為空白則出現錯誤訊息,並不允許確認
  #LET l_cnt = 0
  #SELECT COUNT(*) INTO l_cnt FROM sfa_file,ima_file
  # WHERE sfa01 = l_sfb.sfb01
  #   AND (sfa30 IS NULL OR sfa31 IS NULL OR sfaiicd03 IS NULL OR
  #        sfa30 = ' '  OR sfaiicd03 = ' ')  #倉/批一定要有值
  #   AND sfa03 = ima01 AND imaicd04 IN ('0','1','2','3','4')
  #IF l_cnt > 0 THEN
  #   CALL cl_err(l_sfb.sfb01,'aic-148',1)
  #   LET g_success = 'N' RETURN l_sfbi.*
  #END IF
  #CHI-830032...............end
 
   IF p_cmd = 'a' THEN RETURN l_sfbi.* END IF
 
   #以上為正確性檢查處理邏輯
   #----------------------------------------------------------------------#
   #以下為產生/更新資料處理邏輯
 
   #Date Code(sfbiicd07): 若該料號若該料號之作業群組 = '4.ASS' or '6.TKY'
   #且在料件主檔DateCode否(imaicd09) ='Y',
   #傳參數至 cl_datecode(單據號碼，廠商sfb82，iBody，Wafer Site, Wafer廠商),
   #                                      (iBody:先用單頭sfbiicd14)
   #若產生失敗, 則不允許作生產確認
   IF l_ecdicd01 MATCHES '[46]' THEN
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM ima_file,imaicd_file
       WHERE ima01 = l_sfb.sfb05
         AND ima01 = imaicd00
         AND imaicd09 = 'Y'
      IF l_cnt > 0 THEN
         LET l_icr02='5'
         CALL s_aic_auto_no_set(l_icr02) RETURNING l_icr01
         IF cl_null(l_icr01) THEN
            LET g_success = 'N' RETURN l_sfbi.*
         END IF
         CALL s_aic_auto_no(l_icr01,l_icr02,l_sfb.sfb01)
              RETURNING l_sfbi.sfbiicd07
         IF l_sfbi.sfbiicd07 = 'Error' OR cl_null(l_sfbi.sfbiicd07) THEN
            #產生失敗(為Error或NULL)
            LET g_success = 'N' RETURN l_sfbi.*
         ELSE
            #產生成功,更新委外採購單的(pmniicd11)
            UPDATE pmni_file SET pmniicd11 = l_sfbi.sfbiicd07
             WHERE pmni01||pmni02 = (SELECT pmn01||pmn02 FROM pmn_file WHERE
             pmn41 = l_sfb.sfb01)
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err('upd pmniicd11:',SQLCA.sqlcode,1)
               LET g_success = 'N' RETURN l_sfbi.*
            END IF
            #產生成功,更新工單的datecode(sfbiicd07)
            UPDATE sfbi_file SET sfbiicd07 = l_sfbi.sfbiicd07
             WHERE sfbi01 = l_sfb.sfb01
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err('upd datecode(sfbiicd07):',SQLCA.sqlcode,1)
               LET g_success = 'N' RETURN l_sfbi.*
            END IF
         END IF
      END IF
   END IF
 
   #產生生產備註資訊(ico_file)
   CALL i301sub_ind_icd_gen_ico(l_sfb.*,l_sfbi.*)
   IF g_success = 'N' THEN RETURN l_sfbi.* END IF
 
   #判斷是否有製程資訊(ecm_file)
   IF l_sfb.sfb02 MATCHES '[78]' AND l_ecdicd01 = '6' AND
      NOT cl_null(l_sfb.sfb06) THEN
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM ecm_file WHERE ecm01 = l_sfb.sfb01
      IF l_cnt = 0 THEN
         CALL cl_err(l_sfb.sfb01,'sdf-349',1)
         LET g_success = 'N' RETURN l_sfbi.*
      END IF
   END IF
 
   #回貨批號
   CALL i301sub_ind_icd_upd_sfbiicd13(l_sfb.*,l_sfbi.*) RETURNING l_sfbi.*
   RETURN l_sfbi.*   
END FUNCTION
 
#only for aicp046 call 工單確認
FUNCTION i301sub_ind_icd_set_pmm(p_pmm22,p_pmm42)
   DEFINE p_pmm22 LIKE pmm_file.pmm22
   DEFINE p_pmm42 LIKE pmm_file.pmm42
 
   LET g_pmm22=p_pmm22
   LET g_pmm42=p_pmm42
END FUNCTION
 
#若採購單上的必要欄位有值且取成功,則狀態='Y'(確認);反之='N'
FUNCTION i301sub_ind_icd_upd_pmm18(l_sfb)
   DEFINE l_pmm       RECORD LIKE pmm_file.*,
          l_pmn       RECORD LIKE pmn_file.*,
          l_pmhacti   LIKE pmh_file.pmhacti,
          l_pmh05     LIKE pmh_file.pmh05,
          l_ima906    LIKE ima_file.ima906,
          l_imaicd01  LIKE imaicd_file.imaicd01,
          l_ecdicd01  LIKE ecd_file.ecdicd01,
          l_i         LIKE type_file.num10,
          l_sfb       RECORD LIKE sfb_file.*,
          l_pmni      RECORD LIKE pmni_file.*
 
   IF l_sfb.sfb02 NOT MATCHES '[78]' THEN RETURN END IF
 
   #SELECT pmm_file.* INTO l_pmm.* FROM pmm_file,pmn_file   #MOD-990117
   SELECT DISTINCT pmm_file.* INTO l_pmm.* FROM pmm_file,pmn_file   #MOD-990117
    WHERE pmm01 = pmn01 AND pmn41 = l_sfb.sfb01
      AND pmm02 = 'SUB' AND pmm18 = 'N' AND pmmacti = 'Y'  #有效委外未確認
   IF SQLCA.sqlcode THEN RETURN END IF
 
   #判斷必KEY欄位
   IF cl_null(l_pmm.pmm02) OR cl_null(l_pmm.pmm04) OR
      cl_null(l_pmm.pmm09) OR cl_null(l_pmm.pmm18) OR
      cl_null(l_pmm.pmm20) OR cl_null(l_pmm.pmm21) OR
      cl_null(l_pmm.pmm22) OR cl_null(l_pmm.pmm25) OR
      cl_null(l_pmm.pmm30) OR cl_null(l_pmm.pmm45) OR
      #cl_null(l_pmm.pmm905) 原本PKG轉來就沒值
      cl_null(l_pmm.pmmmksg) OR cl_null(l_pmm.pmm02) THEN
      CALL cl_err('pmm_file','mfg6138','1')
      LET g_success = 'N' RETURN
   END IF
 
   DECLARE pmn_cs CURSOR FOR
    SELECT pmn_file.* FROM pmm_file,pmn_file
     WHERE pmm01 = pmn01 AND pmn41 = l_sfb.sfb01
       AND pmm02 = 'SUB' AND pmm18 = 'N' AND pmmacti = 'Y'  #有效委外未確認
   LET l_i = 0
   #判斷必KEY欄位
   FOREACH pmn_cs INTO l_pmn.*
      #重取單位使用方式/母體料號
      LET l_ima906 = NULL
      LET l_imaicd01 = NULL
      SELECT ima906,imaicd01 INTO l_ima906,l_imaicd01 FROM ima_file,imaicd_file
       WHERE ima01 = l_pmn.pmn04
         AND ima01=imaicd00
 
      SELECT * INTO l_pmni.* FROM pmni_file 
       WHERE pmni01=l_pmn.pmn01 
         AND pmni02=l_pmn.pmn02
 
      #重取作業群組
      LET l_ecdicd01 = NULL
      IF NOT cl_null(l_pmni.pmniicd03) THEN
         SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file
          WHERE ecd01 = l_pmni.pmniicd03
      END IF
      IF cl_null(l_pmn.pmn02) OR cl_null(l_pmn.pmn20) OR
         cl_null(l_pmn.pmn31) OR cl_null(l_pmn.pmn33) OR
         cl_null(l_pmn.pmn41) OR cl_null(l_pmn.pmn42) OR
         cl_null(l_pmn.pmn63) OR cl_null(l_pmn.pmn64) THEN
         CALL cl_err('pmn_file','mfg6138','1')
         LET g_success = 'N' RETURN
      END IF
      #雙單位的必KEY欄位資料判斷
      IF g_sma.sma115 = 'Y' THEN
         IF l_ima906 = '3' THEN
            IF cl_null(l_pmn.pmn83) OR cl_null(l_pmn.pmn85) OR
               cl_null(l_pmn.pmn80) OR cl_null(l_pmn.pmn82) THEN
               CALL cl_err('pmn_file','mfg6138','1')
               LET g_success = 'N' RETURN
            END IF
         END IF
      END IF
 
      #單位不同,轉換率,數量必KEY
      IF NOT cl_null(l_pmn.pmn80) THEN
         IF cl_null(l_pmn.pmn82) THEN
            CALL cl_err('pmn82','mfg6138','1')
            LET g_success = 'N' RETURN
         END IF
      END IF
      IF NOT cl_null(l_pmn.pmn86) THEN
         IF cl_null(l_pmn.pmn87) THEN
            CALL cl_err('pmn87','mfg6138','1')
            LET g_success = 'N' RETURN
         END IF
      END IF
 
      LET l_i = l_i + 1
   END FOREACH
 
   IF l_i = 0 THEN #無單身不可確認
      CALL cl_err('SUB PO','mfg-009',1)
      LET g_success = 'N' RETURN
   END IF
   #--------------------------------------------------------------
   CALL t540sub_y_chk(l_pmm.*)          #CALL 原確認的 check 段
   IF g_success = "Y" THEN
      CALL t540sub_y_upd(l_pmm.pmm01,'')
   END IF
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION
 
FUNCTION i301sub_ind_icd_ins_pmni(l_sfb,l_pmm,l_pmn)
   DEFINE l_sfb   RECORD LIKE sfb_file.*
   DEFINE l_sfbi  RECORD LIKE sfbi_file.*
   DEFINE l_pmn   RECORD LIKE pmn_file.*
   DEFINE l_pmni  RECORD LIKE pmni_file.*
   DEFINE l_ecdicd01 LIKE ecd_file.ecdicd01
   DEFINE l_imaicd01 LIKE imaicd_file.imaicd01
   DEFINE l_ima908   LIKE ima_file.ima908
   DEFINE l_pmm      RECORD LIKE pmm_file.*
 
   IF NOT cl_null(l_sfb.sfb22) AND NOT cl_null(l_sfb.sfb221) THEN
      LET l_pmni.pmniicd01 = l_sfb.sfb22    #--訂單單號
      LET l_pmni.pmniicd02 = l_sfb.sfb221   #--訂單項次
   END IF
 
   SELECT * INTO l_sfbi.*
     FROM sfbi_file
    WHERE sfbi01=l_sfb.sfb01
 
   LET l_pmni.pmniicd03 = l_sfbi.sfbiicd09   #--ICD作業編號
 
   DECLARE pmniicd04_cs CURSOR FOR
    SELECT pmniicd04 FROM pmm_file,pmn_file,pmni_file
     WHERE pmm01 = pmn01 
       AND pmm02 = 'WB2'
       AND pmni01= pmn01
       AND pmni02= pmn02
       AND pmniicd01 = l_sfb.sfb22
       AND pmniicd02 = l_sfb.sfb221
       AND pmm04 IN   #取採購日期最小的資料
           (SELECT MIN(pmm04) FROM pmm_file,pmn_file,pmni_file
             WHERE pmm01 = pmn01 AND pmm02 = 'WB2'
               AND pmni01= pmn01
               AND pmni02= pmn02
               AND pmniicd01 = l_sfb.sfb22
               AND pmniicd02 = l_sfb.sfb221)
   OPEN pmniicd04_cs
   FETCH pmniicd04_cs INTO l_pmni.pmniicd04 #--New Code
   CLOSE pmniicd04_cs
 
   SELECT oebiicd09,oebiicd05,oeb04
     INTO l_pmni.pmniicd05,                 #--Low yield
          l_pmni.pmniicd08,                 #--Multi die
          l_pmni.pmniicd15                  #--最終料號
     FROM oeb_file,oebi_file
    WHERE oeb01 = l_sfb.sfb22
      AND oeb03 = l_sfb.sfb221
      AND oebi01=oeb01
      AND oebi03=oeb03
 
   IF cl_null(l_pmni.pmniicd15)THEN
      LET l_pmni.pmniicd15 = l_sfbi.sfbiicd08
   END IF
 
   LET l_pmni.pmniicd06 = ' '                 #--metal layer
   LET l_pmni.pmniicd07 = 0                   #--FST片數
   #LET l_pmni.pmniicd09 = l_sfbi.sfbiicd05   #--reference die
   SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file
    WHERE ecd01 = l_sfbi.sfbiicd09
   IF l_ecdicd01 = '2' THEN
      LET l_pmn.pmn85 = l_sfbi.sfbiicd06
      LET l_pmni.pmniicd09 = l_sfbi.sfbiicd06
 
      #取得GROSSDIE
      IF cl_null(l_pmn.pmn85) THEN
         SELECT icb05 INTO l_pmn.pmn85
           FROM icb_file,imaicd_file
          WHERE icb01 = imaicd01
            AND imaicd00 = l_sfb.sfb05
          LET l_pmn.pmn85 = l_pmn.pmn85 * l_pmn.pmn20
      END IF
   ELSE
      #TQC-9B0199---begin
      #LET l_pmn.pmn85 = NULL
      #LET l_pmni.pmniicd09 = NULL
      LET l_pmni.pmniicd09 = l_pmn.pmn85
      #TQC-9B0199---end
   END IF
   LET l_pmni.pmniicd10 = ' '                #--已轉完採購單否
   LET l_pmni.pmniicd11 = l_sfbi.sfbiicd07   #--Datecode
   LET l_pmni.pmniicd12 = l_sfbi.sfbiicd03   #--WAFER SITE
   LET l_pmni.pmniicd13 = 0                  #--已轉WAFER START採購單數量
   LET l_pmni.pmniicd14 = l_sfbi.sfbiicd14   #--內編母體
   DECLARE sfaiicd03_cs CURSOR FOR           #--母批
    SELECT sfaiicd03 FROM sfa_file,sfai_file 
     WHERE sfa01  = l_sfb.sfb01
       AND sfai01 = sfa01
       AND sfai03 = sfa03
       AND sfai08 = sfa08
       AND sfai12 = sfa12
       AND sfai27 = sfa27 #CHI-7B0034
     ORDER BY sfa08,sfa27,sfa26
   OPEN sfaiicd03_cs
   FETCH sfaiicd03_cs INTO l_pmni.pmniicd16
   LET l_pmni.pmniicd17 = l_sfbi.sfbiicd02   #--Wafer廠商
   LET l_pmni.pmniicd18 = l_sfbi.sfbiicd01   #--下階廠商
 
   #--未稅單價(pmn31)
   #--含稅單價(pmn31t)
   IF NOT cl_null(l_sfbi.sfbiicd09) THEN
      SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file
       WHERE ecd01 = l_sfbi.sfbiicd09
 
       SELECT imaicd01 INTO l_imaicd01
         FROM imaicd_file
        WHERE imaicd00 = l_pmn.pmn04
 
       SELECT ima908 INTO l_ima908 FROM ima_file
        WHERE ima01=l_imaicd01
 
       LET l_pmn.pmn31 = 0
       LET l_pmn.pmn31t = 0
 
       #FUN-980033--begin--add--
       IF s_industry('icd') THEN
          SELECT sfbi_file.* ,ecdicd01 INTO l_sfbi.*,l_ecdicd01
            FROM sfbi_file LEFT OUTER JOIN ecd_file ON sfbiicd09=ecd01
           WHERE sfbi01=l_sfb.sfb01
       END IF
       IF s_industry('icd') AND l_ecdicd01 MATCHES '[23456]' THEN  
          CALL i301sub_icd_price(l_sfb.*,l_sfbi.*,l_ecdicd01,l_pmm.pmm04, 
                                 l_pmm.pmm22,l_pmm.pmm21,l_pmm.pmm43,l_pmn.pmn86,l_pmm.pmm41,l_pmm.pmm20)
          RETURNING l_pmn.pmn31,l_pmn.pmn31t
       ELSE
       #FUN-980033--end--add--
     #No.MOD-890023 modify --begin
       #TQC-9B0214-------start-------
       #CALL s_defprice(l_imaicd01,l_pmm.pmm09,l_pmm.pmm22,l_pmm.pmm04,
       #               l_pmn.pmn20,l_pmni.pmniicd03,l_pmm.pmm21,
       #              l_pmm.pmm43,'2',l_ima908,'',l_pmm.pmm41,l_pmm.pmm20)   #No.FUN-930148 add-pmm20,pmm41
       #     RETURNING l_pmn.pmn31,l_pmn.pmn31t
       CALL s_defprice_new(l_imaicd01,l_pmm.pmm09,l_pmm.pmm22,l_pmm.pmm04,
                       l_pmn.pmn20,l_pmni.pmniicd03,l_pmm.pmm21,
                      l_pmm.pmm43,'2',l_ima908,'',l_pmm.pmm41,l_pmm.pmm20,g_plant) 
             RETURNING l_pmn.pmn31,l_pmn.pmn31t
       #TQC-9B0214-------end-------
       END IF   #FUN-980033
     #CASE
     #   WHEN l_ecdicd01 = '2' OR l_ecdicd01 = '3'
     #        CALL s_defprice(l_imaicd01,l_pmm.pmm09,l_pmm.pmm22,l_pmm.pmm04,
     #                        l_pmn.pmn20,l_pmni.pmniicd03,l_pmm.pmm21,
     #                        l_pmm.pmm43,'2',l_ima908,'')
     #             RETURNING l_pmn.pmn31,l_pmn.pmn31t
     #   WHEN l_ecdicd01 = '4' OR l_ecdicd01 = '5'
     #        CALL s_defprice(l_pmn.pmn04,l_pmm.pmm09,l_pmm.pmm22,l_pmm.pmm04,
     #                        l_pmn.pmn20,l_pmni.pmniicd03,l_pmm.pmm21,
     #                        l_pmm.pmm43,'2',l_pmn.pmn86,'')
     #             RETURNING l_pmn.pmn31,l_pmn.pmn31t
     #   WHEN l_ecdicd01 = '6'
     #        LET l_pmn.pmn31  = 0
     #        LET l_pmn.pmn31t = 0
     #END CASE
     #No.MOD-890023 modify --begin
   END IF
   RETURN l_pmn.*,l_pmni.*
END FUNCTION
 
#更新回貨批號(sfbiicd13)
FUNCTION i301sub_ind_icd_upd_sfbiicd13(l_sfb,l_sfbi)
  DEFINE l_sfa       RECORD LIKE sfa_file.*,
         l_int       LIKE type_file.num10,
         l_idl02     LIKE idl_file.idl02,
         l_sfb09     LIKE sfb_file.sfb09,
         l_ima55     LIKE ima_file.ima55,
         l_img09     LIKE img_file.img09,
         l_img10     LIKE img_file.img10,
         l_rvv32     LIKE rvv_file.rvv32,      #倉(rvv32)
         l_rvv33     LIKE rvv_file.rvv33,      #儲(rvv33)
         l_rvv34     LIKE rvv_file.rvv34,      #批(rvv34)
         l_rvv35     LIKE rvv_file.rvv35,      #單位(rvv35)
         l_rvv17     LIKE rvv_file.rvv17,      #數量(rvv17)
         l_sfb       RECORD LIKE sfb_file.*,
         l_sfbi      RECORD LIKE sfbi_file.*,
         l_cnt       LIKE type_file.num5,
         l_factor    LIKE ima_file.ima31_fac,
         l_sfai      RECORD LIKE sfai_file.*,
         l_msg       LIKE type_file.chr1000
 
  #料件狀態(imaicd04)=0-4時才做回貨批號
  LET l_cnt = 0
  SELECT COUNT(*) INTO l_cnt FROM imaicd_file
   WHERE imaicd00 = l_sfb.sfb05 
     AND imaicd04 IN ('0','1','2','3','4')
  IF l_cnt = 0 THEN RETURN l_sfbi.* END IF
 
  #若已有資料,就不再取回貨批號
  IF NOT cl_null(l_sfbi.sfbiicd13) THEN RETURN l_sfbi.* END IF
 
  DECLARE sfbiicd13_cs CURSOR FOR  #取第一筆備料的批號資料
   SELECT * FROM sfa_file WHERE sfa01 = l_sfb.sfb01
    ORDER BY sfa08,sfa27,sfa26
 
  OPEN sfbiicd13_cs
  FETCH sfbiicd13_cs INTO l_sfa.*
  IF SQLCA.sqlcode THEN
     CALL cl_err("fetch sfbiicd13_cs:", SQLCA.sqlcode, 1)
     CLOSE sfbiicd13_cs
     LET g_success = 'N' RETURN l_sfbi.*
  END IF
  CLOSE sfbiicd13_cs
 
  #若有入庫單/項次,先撈取入庫單/項 的倉,儲,批,數,量,單位,供後面比較
  IF NOT cl_null(l_sfbi.sfbiicd16) AND NOT cl_null(l_sfbi.sfbiicd17) THEN
     SELECT rvv32,rvv33,rvv34,rvv17,rvv35
       INTO l_rvv32,l_rvv33,l_rvv34,l_rvv17,l_rvv35
       FROM rvu_file,rvv_file
      WHERE rvu01 = rvv01 AND rvu00 = '1' AND rvuconf = 'Y'
        AND rvv01 = l_sfbi.sfbiicd16
        AND rvv02 = l_sfbi.sfbiicd17
  END IF
 
  SELECT * INTO l_sfai.*
    FROM sfai_file
   WHERE sfai01 = l_sfa.sfa01
     AND sfai03 = l_sfa.sfa03
     AND sfai08 = l_sfa.sfa08
     AND sfai12 = l_sfa.sfa12
     AND sfai27 = l_sfa.sfa27 #CHI-7B0034
         
  #若該料號分批作委外, 則須賦予回貨批號, 即發料批號+'.01',以此類推
  CASE
     WHEN NOT cl_null(l_sfbi.sfbiicd16)  AND  #1 若入庫單號 <> 空白 且
          NOT cl_null(l_sfbi.sfbiicd17)  AND  #    入庫項次 <> 空白 且
          l_rvv32 = l_sfa.sfa30 AND           #  同倉儲批
          l_rvv33 = l_sfa.sfa31 AND
          l_rvv34 = l_sfai.sfaiicd03
          #比對回貨數量入庫數量是否和本工單之發料數是否相同
          IF l_sfa.sfa12 <> l_rvv35 THEN
             CALL s_umfchk(l_sfa.sfa03,l_rvv35,l_sfa.sfa12)
             RETURNING l_cnt,l_factor
             IF l_cnt = 1 THEN
                LET l_msg = l_rvv35,'/',l_sfa.sfa12
                CALL cl_err(l_msg,'abm-731',1)
                LET g_success = 'N' RETURN l_sfbi.*
             END IF
             LET l_rvv17 = l_rvv17 * l_factor
          END IF
          IF l_rvv17 = l_sfa.sfa05 THEN
             #1.1 若相同,則回貨批號 = 發料批號,
             LET l_sfbi.sfbiicd13 = l_sfai.sfaiicd03
          ELSE
             #1.2 若不同,則至回貨批號檔(idl_file)取目前最大號碼,
             SELECT MAX(idl02) INTO l_idl02 FROM idl_file
              WHERE idl01 = l_sfai.sfaiicd03
             IF cl_null(l_idl02) THEN
                #1.2.1 若取不到則從'01'開始編,
                LET l_idl02 = '01'
                LET l_sfbi.sfbiicd13 = l_sfai.sfaiicd03 CLIPPED,'.',l_idl02
                #取號後, 須回寫回貨批號檔(idl_file)  用發料批號串idl01
                INSERT INTO idl_file(idl01,idl02)
                       VALUES(l_sfai.sfaiicd03,l_idl02)
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   CALL cl_err('ins idl_file:',SQLCA.sqlcode,1)
                   LET g_success = 'N' RETURN l_sfbi.*
                END IF
             ELSE
                #1.2.2 若取得到idl02,
                #      則回貨批號 = 回貨批號 + '.'+ to_str(MAX(idl02)+1)
                #取號後, 須回寫回貨批號檔(idl_file)  用發料批號串idl01
                LET l_int = l_idl02
                LET l_int = l_int + 1
                LET l_idl02 = l_int USING '&&'
                LET l_sfbi.sfbiicd13 = l_sfai.sfaiicd03 CLIPPED,'.',l_idl02
                UPDATE idl_file SET idl02 = l_idl02
                 WHERE idl01 = l_sfai.sfaiicd03
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   CALL cl_err('upd idl_file:',SQLCA.sqlcode,1)
                   LET g_success = 'N' RETURN l_sfbi.*
                END IF
             END IF
          END IF
     WHEN cl_null(l_sfbi.sfbiicd16) OR cl_null(l_sfbi.sfbiicd17) OR
          (NOT cl_null(l_sfbi.sfbiicd16) AND NOT cl_null(l_sfbi.sfbiicd17) AND
           NOT(l_rvv32 = l_sfa.sfa30 AND   #2 入庫單號 = 空白 OR 入庫項次=空白
               l_rvv33 = l_sfa.sfa31 AND   #  或雖入庫單號/項次 <> 空白
               l_rvv34 = l_sfai.sfaiicd03)) #  但不同倉儲批
 
          #比對庫存該批號數量是否和本工單之發料數是否相同
          SELECT img09,img10 INTO l_img09,l_img10 FROM img_file
           WHERE img01 = l_sfa.sfa03 AND img02 = l_sfa.sfa30
             AND img03 = l_sfa.sfa31 AND img04 = l_sfai.sfaiicd03
          #若無庫存該批號數量, 則回貨批號 = 發料批號
          IF SQLCA.sqlcode = 100 OR l_img10 = 0 THEN
             LET l_sfbi.sfbiicd13 = l_sfai.sfaiicd03
          ELSE
             IF l_img10 = l_sfa.sfa05 THEN
                #2.1 若相同, 則回貨批號 = 發料批號
                LET l_sfbi.sfbiicd13 = l_sfai.sfaiicd03
             ELSE
                #2.2 若不同,則至回貨批號檔(idl_file)取目前最大號碼,
                SELECT MAX(idl02) INTO l_idl02 FROM idl_file
                 WHERE idl01 = l_sfai.sfaiicd03
                IF cl_null(l_idl02) THEN
                   #2.2.1 若取不到則從'01'開始編,
                   LET l_idl02 = '01'
                   LET l_sfbi.sfbiicd13 = l_sfai.sfaiicd03 CLIPPED,'.',l_idl02
                   #取號後, 須回寫回貨批號檔(idl_file)  用發料批號串idl01
                   INSERT INTO idl_file(idl01,idl02)
                          VALUES(l_sfai.sfaiicd03,l_idl02)
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                      CALL cl_err('ins idl_file:',SQLCA.sqlcode,1)
                      LET g_success = 'N' RETURN l_sfbi.*
                   END IF
                ELSE
                   #2.2.2 若取得到idl02,
                   #      則回貨批號 = 回貨批號 + '.'+ to_str(MAX(idl02)+1)
                   LET l_int = l_idl02
                   LET l_int = l_int + 1
                   LET l_idl02 = l_int USING '&&'
                   LET l_sfbi.sfbiicd13 = l_sfai.sfaiicd03 CLIPPED,'.',l_idl02
                   #取號後, 須回寫回貨批號檔(idl_file)  用發料批號串idl01
                   UPDATE idl_file SET idl02 = l_idl02
                    WHERE idl01 = l_sfai.sfaiicd03
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                      CALL cl_err('upd idl_file:',SQLCA.sqlcode,1)
                      LET g_success = 'N' RETURN l_sfbi.*
                   END IF
                END IF
             END IF
          END IF
  END CASE
  #回寫update 回貨批號(sfbiicd13)
  UPDATE sfbi_file SET sfbiicd13 = l_sfbi.sfbiicd13
   WHERE sfb01 = l_sfb.sfb01
  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
     CALL cl_err('upd sfbiicd13:',SQLCA.sqlcode,1)
     LET g_success = 'N' RETURN l_sfbi.*
  END IF
END FUNCTION
 
#產生生產資訊(ico_file)
FUNCTION i301sub_ind_icd_gen_ico(l_sfb,l_sfbi)
   DEFINE l_ecdicd01 LIKE ecd_file.ecdicd01,
          l_ico    RECORD LIKE ico_file.*
   DEFINE l_cnt    LIKE type_file.num5
   DEFINE l_sfb    RECORD LIKE sfb_file.*
   DEFINE l_sfbi   RECORD LIKE sfbi_file.*
 
   #若已有資料則不新增(類別要為0,1,2,3,4任一)
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM ico_file
    WHERE ico01 =  l_sfb.sfb01
 
   IF l_cnt > 0 THEN
      #如果沒有ico03=0,1,2,3,4的資料,要再從icl_file copy資料吆
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM ico_file
       WHERE ico01 = l_sfb.sfb01
         AND ico03 IN ('0','1','2','3','4')
      IF l_cnt = 0 THEN
         CALL i301sub_ind_icd_gen_ico2(l_sfb.*,l_sfbi.*)
         IF g_success = 'N' THEN RETURN END IF
      END IF
   ELSE
      IF NOT cl_null(l_sfbi.sfbiicd09) THEN
         SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file
          WHERE ecd01 = l_sfbi.sfbiicd09
      END IF
 
      CASE
         WHEN NOT cl_null(l_sfb.sfb86)
         #1.若母工單號<>空白,複製該張母工單號生產資訊(ico_file)至本張工單
         #  若作業群組=4.ASS或6.TKY,且生產資訊檔中Date Code否(ico05) = Y,
         #  則將備註(ico06)中[DATECODE]字樣置換成Date Code(sfbiicd07)之值
              DECLARE ico_cs1 CURSOR FOR
               SELECT * FROM ico_file
                WHERE ico01 = l_sfb.sfb86
                  AND ico02 = 0
              FOREACH ico_cs1 INTO l_ico.*
                IF SQLCA.sqlcode THEN
                   CALL cl_err('foreach ico_cs1',SQLCA.sqlcode,0)
                   LET g_success = 'N'
                   RETURN
                END IF
                LET l_ico.ico01 = l_sfb.sfb01
                LET l_ico.icouser = g_user
                LET l_ico.icogrup = g_grup
                LET l_ico.icodate = g_today
                LET l_ico.icomodu = NULL
                LET l_ico.icoacti = 'Y'
                IF l_ecdicd01 MATCHES '[46]' AND l_ico.ico05 = 'Y' THEN
                   CALL cl_replace_str(l_ico.ico06,'[DATECODE]',
                                       l_sfbi.sfbiicd07)
                        RETURNING l_ico.ico06
                END IF
                LET l_ico.icooriu = g_user      #No.FUN-980030 10/01/04
                LET l_ico.icoorig = g_grup      #No.FUN-980030 10/01/04
                INSERT INTO ico_file VALUES(l_ico.*)
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   CALL cl_err('ins ico_file:',SQLCA.sqlcode,1)
                   LET g_success = 'N' RETURN
                END IF
              END FOREACH
              #如果沒有ico03=0,1,2,3,4的資料,要再從icl_file copy資料吆
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM ico_file
               WHERE ico01 = l_sfb.sfb01
                 AND ico03 IN ('0','1','2','3','4')
              IF l_cnt = 0 THEN
                 CALL i301sub_ind_icd_gen_ico2(l_sfb.*,l_sfbi.*)
                 IF g_success = 'N' THEN RETURN END IF
              END IF
 
         WHEN NOT cl_null(l_sfb.sfb22)
         #2.若訂單單號<>空白,複製該張定單單號生產資訊(ico_file)至本張工單
         #  若作業群組=4.ASS或6.TKY,若生產資訊檔中Date Code 否(ico05)=Y
         #  則將備註(ico06)中[DATECODE]字樣置換成Date Code(sfbiicd07)之值
              DECLARE ico_cs2 CURSOR FOR
               SELECT * FROM ico_file
                WHERE ico01 = l_sfb.sfb22
                  AND ico02 = l_sfb.sfb221
              FOREACH ico_cs2 INTO l_ico.*
                IF SQLCA.sqlcode THEN
                   CALL cl_err('foreach ico_cs2',SQLCA.sqlcode,0)
                   LET g_success = 'N'
                   RETURN
                END IF
                LET l_ico.ico01 = l_sfb.sfb01
                LET l_ico.ico02 = 0
                LET l_ico.icouser = g_user
                LET l_ico.icogrup = g_grup
                LET l_ico.icodate = g_today
                LET l_ico.icomodu = NULL
                LET l_ico.icoacti = 'Y'
                IF l_ecdicd01 MATCHES '[46]' AND l_ico.ico05 = 'Y' THEN
                   CALL cl_replace_str(l_ico.ico06,'[DATECODE]',
                                       l_sfbi.sfbiicd07)
                        RETURNING l_ico.ico06
                END IF
                INSERT INTO ico_file VALUES(l_ico.*)
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   CALL cl_err('ins ico_file:',SQLCA.sqlcode,1)
                   LET g_success = 'N' RETURN
                END IF
              END FOREACH
              #如果沒有ico03=0,1,2,3,4的資料,要再從icl_file copy資料吆
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM ico_file
               WHERE ico01 = l_sfb.sfb01
                 AND ico03 IN ('0','1','2','3','4')
              IF l_cnt = 0 THEN
                 CALL i301sub_ind_icd_gen_ico2(l_sfb.*,l_sfbi.*)
                 IF g_success = 'N' THEN RETURN END IF
              END IF
         OTHERWISE
              CALL i301sub_ind_icd_gen_ico2(l_sfb.*,l_sfbi.*)
      END CASE
   END IF
END FUNCTION
 
#由icl_file產生生產資訊(ico_file)
FUNCTION i301sub_ind_icd_gen_ico2(l_sfb,l_sfbi)
   DEFINE l_ecdicd01 LIKE ecd_file.ecdicd01,
          l_ico    RECORD LIKE ico_file.*,
          l_icl    RECORD LIKE icl_file.*,
          l_icl01  LIKE icl_file.icl01,
          l_sfb    RECORD LIKE sfb_file.*,
          l_sfbi   RECORD LIKE sfbi_file.*,
          l_cnt    LIKE type_file.num5
 
   IF NOT cl_null(l_sfbi.sfbiicd09) THEN
      SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file
       WHERE ecd01 = l_sfbi.sfbiicd09
   END IF
 
   #用料號串正背印檔(icl_file) ,
   #複製類別= [0. Logo],[1.正印],[2.背印],[3.正印備註],[4.背印備註];
   #若作業群組=4.ASS或6.TKY,若生產資訊檔中Date Code 否(ico05)=Y
   #則將備註(ico06)中[DATECODE]字樣置換成Date Code(sfbiicd07)之值
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM icl_file
    WHERE icl01 = l_sfb.sfb05 AND icl02 IN ('0','1','2','3','4')
 
   CASE
      WHEN l_cnt > 0
          #1.若用料號串icl_file有資料
           LET l_icl01 = l_sfb.sfb05
      WHEN l_cnt = 0
          #2.若用料號串icl_file沒有資料,改用母體料號(sfbiicd14)
           LET l_icl01 = l_sfbi.sfbiicd14
   END CASE
 
   DECLARE icl_cs CURSOR FOR
    SELECT * FROM icl_file
     WHERE icl01 = l_icl01 AND icl02 IN ('0','1','2','3','4')
   FOREACH icl_cs INTO l_icl.*
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach icl_cs',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN
     END IF
     INITIALIZE l_ico.* TO NULL
     LET l_ico.ico01 = l_sfb.sfb01
     LET l_ico.ico02 = 0
     LET l_ico.ico03 = l_icl.icl02
     LET l_ico.ico04 = l_icl.icl03
     LET l_ico.ico05 = l_icl.icl04
     LET l_ico.ico06 = l_icl.icl05
     LET l_ico.ico07 = NULL
     LET l_ico.icouser = g_user
     LET l_ico.icogrup = g_grup
     LET l_ico.icodate = g_today
     LET l_ico.icomodu = NULL
     LET l_ico.icoacti = 'Y'
     IF l_ecdicd01 MATCHES '[46]' AND l_ico.ico05 = 'Y' THEN
        CALL cl_replace_str(l_ico.ico06,'[DATECODE]',l_sfbi.sfbiicd07)
             RETURNING l_ico.ico06
     END IF
     LET l_ico.icooriu = g_user      #No.FUN-980030 10/01/04
     LET l_ico.icoorig = g_grup      #No.FUN-980030 10/01/04
     INSERT INTO ico_file VALUES(l_ico.*)
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err('ins ico_file:',SQLCA.sqlcode,1)
        LET g_success = 'N' RETURN
     END IF
   END FOREACH
END FUNCTION
 
#工單領料
FUNCTION i301sub_ind_icd_material_collect(p_sfb01,p_slip,p_sfp03,p_action_choice)
   DEFINE p_slip  STRING,
          p_sfb01 LIKE sfb_file.sfb01,
          p_sfp03 LIKE sfp_file.sfp03,
          l_no    LIKE sfp_file.sfp01
   DEFINE p_row,p_col  LIKE type_file.num5
   DEFINE li_result    LIKE type_file.num5
   DEFINE p_action_choice STRING
   DEFINE l_sfb   RECORD LIKE sfb_file.*
   DEFINE l_cnt   LIKE type_file.num5
   DEFINE l_msg   LIKE type_file.chr1000
 
   IF s_shut(0) THEN RETURN NULL END IF
 
   SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01 = p_sfb01
 
   IF l_sfb.sfb01 IS NULL THEN CALL cl_err(p_sfb01,-400,1) RETURN NULL END IF
   #不可作廢
   IF l_sfb.sfb87 = 'X' THEN CALL cl_err(p_sfb01,'9024',1) RETURN NULL END IF
   #不可未確認
   IF l_sfb.sfb87 = 'N' THEN CALL cl_err(p_sfb01,'aap-717',1) RETURN NULL END IF
   #不可未發放
   IF l_sfb.sfb04 = '1' THEN CALL cl_err(p_sfb01,'asf-381',1) RETURN NULL END IF
   #不可已結案
   IF l_sfb.sfb04 = '8' THEN CALL cl_err(p_sfb01,'9004',1) RETURN NULL END IF 
 
  #FUN-910077 mark 移到後面處理
  ##檢查有發料單存在否
  #LET l_cnt = 0
  #SELECT COUNT(*) INTO l_cnt FROM sfp_file,sfq_file
  # WHERE sfq02 = l_sfb.sfb01 AND sfp04 <> 'X' AND sfp01 = sfq01
  #
  #IF l_cnt > 0 THEN
  #   #有發料單存在,開窗帶出發料單
  #   DECLARE sfp_cs CURSOR FOR 
  #    SELECT sfp01 FROM sfp_file,sfq_file
  #     WHERE sfq02 = l_sfb.sfb01 AND sfp04 <> 'X' AND sfp01 = sfq01
  #   OPEN sfp_cs
  #   FETCH sfp_cs INTO l_no
  #   CLOSE sfp_cs     
  #  #LET l_msg="asfi510 '1' '",l_no,"' "      #CHI-830032
  #   LET l_msg="asfi510_icd '1' '",l_no,"' "  #CHI-830032
  #   CALL cl_cmdrun_wait(l_msg)
  #   RETURN l_no
  #END IF
   
   IF cl_null(p_slip) THEN  #由asfi301串接p_slip=null,由aicp046串接p_slip<>null
      LET p_row = 10
      LET p_col = 35
 
      OPEN WINDOW asfi301d_w AT p_row,p_col
             WITH FORM "asf/42f/asfi301d"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
      CALL cl_ui_locale("asfi301d")
 
      INPUT p_slip WITHOUT DEFAULTS FROM smyslip
         AFTER FIELD smyslip
            IF NOT cl_null(p_slip) THEN
               LET l_cnt = 0
               CALL s_check_no("asf",p_slip,"","","sfp_file","sfp01","")
                    RETURNING li_result,p_slip
               DISPLAY p_slip TO smyslip
               IF (NOT li_result) THEN
                   NEXT FIELD smyslip
               END IF
            END IF
 
         ON ACTION CONTROLP
            CALL q_smy(FALSE,TRUE,p_slip,'asf','3') RETURNING p_slip
            DISPLAY p_slip TO smyslip
            NEXT FIELD smyslip
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG 
            CALL cl_cmdask()
 
      END INPUT
      CLOSE WINDOW asfi301d_w
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN NULL
      END IF
      IF NOT cl_null(p_action_choice) THEN
         IF NOT cl_confirm('afa-347') THEN
            RETURN NULL
         END IF
      END IF
         
 
   END IF
 
   BEGIN WORK
   LET g_success = 'Y'
   
   IF cl_null(p_sfp03) OR p_sfp03=0 THEN
      LET p_sfp03=g_today
   END IF
   # isnert 發料底稿單頭(sfp_file)
   CALL i301sub_ind_icd_ins_sfp(p_slip,p_sfp03,l_sfb.sfb81) RETURNING l_no
   
   # isnert 發料底稿單身(sfq_file)
   IF g_success = 'Y' THEN CALL i301sub_ind_icd_ins_sfq(l_no,l_sfb.sfb01) END IF
   
   # isnert 發料底稿單身(sfs_file)
   IF g_success = 'Y' THEN CALL i301sub_ind_icd_ins_sfs(l_no,l_sfb.sfb01) END IF
   
   IF g_success = 'Y' THEN
     #CALL cl_err('','abm-019',1)  #FUN-910077 mark
      COMMIT WORK        
     #FUN-910077 mark
     #IF NOT cl_null(g_action_choice) THEN
     #  #LET l_msg="asfi510 '1' '",l_no,"' "      #CHI-830032
     #   LET l_msg="asfi510_icd '1' '",l_no,"' "  #CHI-830032
     #   CALL cl_cmdrun_wait(l_msg)
     #END IF
   ELSE
      CALL cl_err('','abm-020',1)
      ROLLBACK WORK
   END IF
   
   #檢查有發料單存在否,若存在則自動過帳(這段先不做放到aicp046作),因為沒刻號/BIN資料所以過帳會失敗
   LET g_success='Y'
   #FUN-910077...............begin
   #IF NOT cl_null(l_no) THEN
   #   BEGIN WORK
   #   CALL i501sub_y_chk(l_no)
   #   IF g_success = "Y" THEN
   #      CALL i501sub_y_upd(l_no,NULL,TRUE)
   #        RETURNING l_sfp.*
   #   END IF
   #   
   #   LET l_o_prog = g_prog
   #   CASE l_sfp.sfp06
   #      WHEN "1" LET g_prog='asfi511'
   #      WHEN "2" LET g_prog='asfi512'
   #      WHEN "3" LET g_prog='asfi513'
   #      WHEN "4" LET g_prog='asfi514'
   #      WHEN "6" LET g_prog='asfi526'
   #      WHEN "7" LET g_prog='asfi527'
   #      WHEN "8" LET g_prog='asfi528'
   #      WHEN "9" LET g_prog='asfi529'
   #   END CASE
   #   
   #   IF g_success = "Y" THEN
   #      CALL i501sub_s('1',l_sfp.sfp01,TRUE,'N')
   #   END IF
   #   LET g_prog = l_o_prog
   #   
   #   IF g_success='Y' THEN
   #      COMMIT WORK
   #   ELSE
   #      ROLLBACK WORK
   #   END IF
   #END IF
   #FUN-910077...............end
   
   RETURN l_no
   
END FUNCTION
 
# isnert 發料底稿單頭(sfp_file)
FUNCTION i301sub_ind_icd_ins_sfp(p_slip,p_sfp03,p_sfb81)
    DEFINE p_slip       STRING,
           p_sfp03      LIKE sfp_file.sfp03
    DEFINE li_result    LIKE type_file.num5
    DEFINE l_sfp        RECORD LIKE sfp_file.*
    define p_sfb81      LIKE sfb_file.sfb81
 
    #取得單號
    CALL s_auto_assign_no("asf",p_slip,p_sfb81,"",
                          "sfp_file","sfp01","","","")
         RETURNING li_result,l_sfp.sfp01
    IF (NOT li_result) THEN
       LET g_success = 'N'
       RETURN l_sfp.sfp01
    END IF
    LET l_sfp.sfp02  =p_sfp03                                               
    LET l_sfp.sfp03  =p_sfp03
    LET l_sfp.sfp04  ='N'
    LET l_sfp.sfp05  ='N'
    LET l_sfp.sfp06  ='1'
    LET l_sfp.sfp09  ='N'
    LET l_sfp.sfpconf = 'N' #FUN-920054
    LET l_sfp.sfpuser=g_user
    LET l_sfp.sfpgrup=g_grup
    LET l_sfp.sfpdate=p_sfp03
 
    LET l_sfp.sfpplant=g_plant  #FUN-980008 add
    LET l_sfp.sfplegal=g_legal  #FUN-980008 add
 
    LET l_sfp.sfporiu = g_user      #No.FUN-980030 10/01/04
    LET l_sfp.sfporig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO sfp_file VALUES (l_sfp.*)
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       CALL cl_err('ins sfp:',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN l_sfp.sfp01
    END IF
    RETURN l_sfp.sfp01
END FUNCTION
 
# isnert 發料底稿單身(sfq_file)
FUNCTION i301sub_ind_icd_ins_sfq(p_no,l_sfb01)
   DEFINE p_no        LIKE sfp_file.sfp01
   DEFINE l_sfq       RECORD LIKE sfq_file.*
   DEFINE l_sfb01     LIKE sfb_file.sfb01
   DEFINE l_sfb08     LIKE sfb_file.sfb08
   DEFINE l_sfbiicd04 LIKE sfbi_file.sfbiicd04
   DEFINE l_sfq04     LIKE sfq_file.sfq04  #CHI-830032
 
   SELECT sfb08,sfbiicd04 INTO l_sfb08,l_sfbiicd04
     FROM sfb_file,sfbi_file
    WHERE sfb01  = l_sfb01
      AND sfbi01 = sfb01
 
   LET l_sfq.sfq01 = p_no
   LET l_sfq.sfq02 = l_sfb01
   IF NOT cl_null(l_sfb08) THEN
      LET l_sfq.sfq03 = l_sfb08 #全數發料
   ELSE
      LET l_sfq.sfq03 = l_sfbiicd04 #全數發料
   END IF
   #CHI-830032................begin
  #LET l_sfq.sfq04 = ' '
  #LET l_sfq.sfq05 = ' '
   #取得第一筆備料單之作業編號,ICD只會有一筆備料
   DECLARE ind_icd_ins_sfq CURSOR FOR
      SELECT sfa08,sfa012 FROM sfa_file,sfb_file           #FUN-B20095  add sfa012
                  WHERE sfa01 = sfb01 
                    AND sfb01 = l_sfb01
   FOREACH ind_icd_ins_sfq INTO l_sfq.sfq04,l_sfq.sfq012   #FUN-B20095  add sfa012
      EXIT FOREACH
   END FOREACH 
   IF cl_null(l_sfq.sfq04) THEN
      LET l_sfq.sfq04 = ' '
   END IF
#FUN-B20095 --------------Begin---------------
   IF cl_null(l_sfq.sfq012) THEN
      LET l_sfq.sfq012 = ' '
   END IF
#FUN-B20095 --------------End-----------------
   LET l_sfq.sfq05 = g_today  #CHI-830032
   #CHI-830032................end
   LET l_sfq.sfq06 = NULL
   LET l_sfq.sfqplant=g_plant  #FUN-980008 add
   LET l_sfq.sfqlegal=g_legal  #FUN-980008 add
 
   INSERT INTO sfq_file VALUES (l_sfq.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err('ins sfq:',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION
 
# isnert 發料底稿單身(sfs_file)
FUNCTION i301sub_ind_icd_ins_sfs(p_no,l_sfb01)
   DEFINE p_no  LIKE sfp_file.sfp01
   DEFINE l_sfb01 LIKE sfb_file.sfb01
   DEFINE l_sql STRING
   DEFINE l_sfa RECORD LIKE sfa_file.*
   DEFINE l_sfs RECORD LIKE sfs_file.*
   DEFINE l_gfe03 LIKE gfe_file.gfe03
   DEFINE l_imaicd04   LIKE imaicd_file.imaicd04,
          l_ima906     LIKE ima_file.ima906,
          l_qty        LIKE sfs_file.sfs05,
          l_factor     LIKE ima_file.ima31_fac
   DEFINE l_sfai       RECORD LIKE sfai_file.*
 
   LET l_sql = "SELECT * FROM sfa_file ",
               " WHERE sfa01 = '",l_sfb01,"' ",
               "   AND sfa05 > sfa06 ",
              #"   AND (sfa11 <> 'E' OR sfa11 IS NULL)",           #CHI-980013 
               "   AND (sfa11 NOT IN ('E','X') OR sfa11 IS NULL)", #CHI-980013 
               "   AND (sfa05 - sfa065) > 0 ",  #應發-委外代買量>0
               " ORDER BY sfa27,sfa03 "
   PREPARE ins_sfs_pre FROM l_sql
   DECLARE ins_sfs_cs CURSOR FOR ins_sfs_pre
   LET l_sfs.sfs02 = 0
   FOREACH ins_sfs_cs INTO l_sfa.*
      LET l_gfe03 = NULL     LET l_factor = NULL
      LET l_ima906 = NULL    LET l_imaicd04 = NULL
 
      #取料件單位使用方式(ima906),料件狀態(imaicd04)
      SELECT ima906,imaicd04 INTO l_ima906,l_imaicd04
        FROM ima_file,imaicd_file 
       WHERE ima01 = l_sfa.sfa03
         AND imaicd00 = ima01
 
      #取料單位小數位數
      SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01=l_sfa.sfa12
      IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03=0 END IF
 
      SELECT * INTO l_sfai.*
        FROM sfai_file
       WHERE sfai01 = l_sfa.sfa01 #FUN-920054 add l_sfa.
         AND sfai03 = l_sfa.sfa03 #FUN-920054 add l_sfa.
         AND sfai08 = l_sfa.sfa08 #FUN-920054 add l_sfa.
         AND sfai12 = l_sfa.sfa12 #FUN-920054 add l_sfa.
         AND sfai27 = l_sfa.sfa27 #FUN-920054 add l_sfa.
 
     #CHI-830032...............begin #pkg此處先不卡,發料確認時會檢查  
     ##若料件狀態(imaicd04) = 0-4,則倉庫/儲位/批號不可為空白
     #IF l_sfa.sfa30 IS NULL OR l_sfa.sfa31 IS NULL OR 
     #   l_sfai.sfaiicd03 IS NULL OR l_sfa.sfa30 = ' ' OR 
     #   l_sfai.sfaiicd03 = ' ' THEN
     #   IF l_imaicd04 MATCHES '[01234]' THEN
     #      CALL cl_err(l_sfa.sfa03,'aic-148',1)
     #      LET g_success = 'N' RETURN
     #   END IF
     #END IF
     #CHI-830032...............end
 
      LET l_sfa.sfa05 = l_sfa.sfa05 - l_sfa.sfa065
      LET l_qty = (l_sfa.sfa05 - l_sfa.sfa06)
      CALL i301sub_ind_icd_chk_ima64(l_sfa.sfa03, l_qty) RETURNING l_qty
 
      LET l_sfs.sfs01=p_no
      LET l_sfs.sfs02=l_sfs.sfs02+1
      LET l_sfs.sfs03=l_sfb01
      LET l_sfs.sfs04=l_sfa.sfa03
      #LET l_sfs.sfs05=cl_digcut(l_qty,l_gfe03)
      LET l_sfs.sfs05=l_qty
      LET l_sfs.sfs06=l_sfa.sfa12
      LET l_sfs.sfs07=l_sfa.sfa30
      LET l_sfs.sfs08=l_sfa.sfa31
      LET l_sfs.sfs09=l_sfai.sfaiicd03
      LET l_sfs.sfs10=l_sfa.sfa08
      LET l_sfs.sfs26=NULL
      LET l_sfs.sfs27=NULL
      LET l_sfs.sfs28=NULL
      IF l_sfa.sfa26 MATCHES '[SUT]' THEN
         LET l_sfs.sfs26=l_sfa.sfa26
         LET l_sfs.sfs27=l_sfa.sfa27
         LET l_sfs.sfs28=l_sfa.sfa28
      ELSE                            #No.MOD-8B0086 add
         LET l_sfs.sfs27=l_sfa.sfa27  #No.MOD-8B0086 add
      END IF
      IF l_sfs.sfs07 IS NULL THEN LET l_sfs.sfs07 = ' ' END IF
      IF l_sfs.sfs08 IS NULL THEN LET l_sfs.sfs08 = ' ' END IF
      IF l_sfs.sfs09 IS NULL THEN LET l_sfs.sfs09 = ' ' END IF
      LET l_sfs.sfs30 = NULL
      LET l_sfs.sfs31 = NULL
      LET l_sfs.sfs32 = NULL
      LET l_sfs.sfs33 = NULL
      LET l_sfs.sfs34 = NULL
      LET l_sfs.sfs35 = NULL
 
      #處理雙單位
      IF g_sma.sma115 = 'Y' THEN
         LET l_sfs.sfs30 = l_sfs.sfs06
         #與工單備料檔中的備料單位轉換
         CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs06,l_sfa.sfa12)
            RETURNING g_errno,l_factor
         LET l_sfs.sfs31 = l_factor
         LET l_sfs.sfs32 = l_sfs.sfs05 / l_factor
 
         IF l_ima906 = '1' THEN  #不使用雙單位
            LET l_sfs.sfs33 = NULL
            LET l_sfs.sfs34 = NULL
            LET l_sfs.sfs35 = NULL
         ELSE
            LET l_sfs.sfs33 = l_sfai.sfaiicd02
            #與工單備料檔中的備料單位轉換
            CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs33,l_sfa.sfa12)
               RETURNING g_errno,l_factor
            LET l_sfs.sfs34 = l_factor
            LET l_sfs.sfs35 = l_sfai.sfaiicd01 - l_sfai.sfaiicd04
         END IF
      END IF
      LET l_sfs.sfsplant=g_plant  #FUN-980008 add
      LET l_sfs.sfslegal=g_legal  #FUN-980008 add
 
      INSERT INTO sfs_file VALUES(l_sfs.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('ins sfs:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH
   IF l_sfs.sfs02 = 0 THEN
      CALL cl_err(l_sfb01,'asf-348',1)
      LET g_success = 'N'
   END IF
END FUNCTION
 
FUNCTION i301sub_ind_icd_chk_ima64(p_part, p_qty)
  DEFINE p_part         LIKE ima_file.ima01
  DEFINE p_qty          DEC(15,3)
  DEFINE l_ima108       LIKE ima_file.ima108
  DEFINE l_ima64        LIKE ima_file.ima64
  DEFINE l_ima641       LIKE ima_file.ima641
  DEFINE i              INTEGER
                                                                                
  SELECT ima108,ima64,ima641 INTO l_ima108,l_ima64,l_ima641 
    FROM ima_file WHERE ima01=p_part 
  IF STATUS THEN RETURN p_qty END IF
  
  IF l_ima108='Y' THEN RETURN p_qty END IF
 
  IF l_ima641 != 0 AND p_qty<l_ima641 THEN
     LET p_qty=l_ima641
  END IF
 
  IF l_ima64<>0 THEN
     LET i=p_qty / l_ima64 + 0.999999 
     LET p_qty= i * l_ima64
  END IF
  RETURN p_qty
END FUNCTION
#FUN-810038................end
#ICD end

#FUN-980033--begin--add--
FUNCTION i301sub_icd_price(l_sfb,l_sfbi,l_ecdicd01,l_pmm04,l_pmm22,l_pmm21,l_pmm43,l_pmn86,l_pmm41,l_pmm20)
DEFINE     l_ecdicd01 LIKE ecd_file.ecdicd01,
           l_pmn31     LIKE pmn_file.pmn31,
           l_pmn31t    LIKE pmn_file.pmn31t,
           l_pmm21     LIKE pmm_file.pmm21,
           l_pmm22     LIKE pmm_file.pmm22,
           l_pmm43     LIKE pmm_file.pmm43,
           l_ecb06     LIKE ecb_file.ecb06,
           l_imaicd01  LIKE imaicd_file.imaicd01,
           l_pmn86     LIKE pmn_file.pmn86,
           l_pmm04     LIKE pmm_file.pmm04,
           l_pmm41     LIKE pmm_file.pmm41, 
           l_pmm20     LIKE pmm_file.pmm20,
           l_sfb       RECORD LIKE sfb_file.*,
           l_sfbi      RECORD LIKE sfbi_file.*
          


    CASE WHEN l_ecdicd01 = '2' OR l_ecdicd01 = '3'
              #1 若料號之作業群組 = '2.CP' or '3.DS' ,
              #  則採購單價以母體料號取價,
              IF g_sma.sma841 = '8' THEN #依Body取價  
                 SELECT imaicd01 INTO l_imaicd01 FROM imaicd_file
                  WHERE imaicd00 = l_sfb.sfb05
              ELSE                                    
                 LET l_imaicd01 = l_sfb.sfb05
              END IF
              #TQC-9B0214-------start-------
              #CALL s_defprice(l_imaicd01,l_sfb.sfb82,l_pmm22,
              #               l_pmm04,l_sfb.sfb08,
              #               l_sfbi.sfbiicd09,l_pmm21,
              #               l_pmm43,'2',l_pmn86,'',l_pmm41,l_pmm20) 
              #RETURNING l_pmn31,l_pmn31t
              CALL s_defprice_new(l_imaicd01,l_sfb.sfb82,l_pmm22,
                              l_pmm04,l_sfb.sfb08,
                              l_sfbi.sfbiicd09,l_pmm21,
                              l_pmm43,'2',l_pmn86,'',l_pmm41,l_pmm20,g_plant) 
              RETURNING l_pmn31,l_pmn31t
              #TQC-9B0214-------end-------
         WHEN l_ecdicd01 = '4' OR l_ecdicd01 = '5'
              #2 若料號之作業群組 = '4.ASS' or '5.FT' ,
              #TQC-9B0214-------start-------
              #CALL s_defprice(l_sfbi.sfbiicd08,l_sfb.sfb82,
              #                l_pmm22,l_pmm04,l_sfb.sfb08,
              #                l_sfbi.sfbiicd09,l_pmm21,
              #                l_pmm43,'2',l_pmn86,'',l_pmm41,l_pmm20)
              #RETURNING l_pmn31,l_pmn31t
              CALL s_defprice_new(l_sfbi.sfbiicd08,l_sfb.sfb82,
                              l_pmm22,l_pmm04,l_sfb.sfb08,
                              l_sfbi.sfbiicd09,l_pmm21,
                              l_pmm43,'2',l_pmn86,'',l_pmm41,l_pmm20,g_plant)
              RETURNING l_pmn31,l_pmn31t
              #TQC-9B0214-------end------- 
         WHEN l_ecdicd01 = '6'
              DECLARE ecb_dec CURSOR FOR
               SELECT ecb06 FROM ecb_file
                WHERE ecb01 = l_sfb.sfb05 
                  AND ecb02 = l_sfb.sfb06
              FOREACH ecb_dec INTO l_ecb06
                #TQC-9B0214-------start-------
                #CALL s_defprice(l_sfbi.sfbiicd08,l_sfb.sfb82,
                #                l_pmm22,l_pmm04,l_sfb.sfb08,l_ecb06,l_pmm21,
                #                l_pmm43,'2',l_pmn86,'',l_pmm41,l_pmm20)
                #RETURNING l_pmn31,l_pmn31t
                CALL s_defprice_new(l_sfbi.sfbiicd08,l_sfb.sfb82,
                                l_pmm22,l_pmm04,l_sfb.sfb08,l_ecb06,l_pmm21,
                                l_pmm43,'2',l_pmn86,'',l_pmm41,l_pmm20,g_plant)
                RETURNING l_pmn31,l_pmn31t
                #TQC-9B0214-------start-------
              END FOREACH
    END CASE
 
    RETURN l_pmn31,l_pmn31t
END FUNCTION
#FUN-980033--end--add--

#NO.MOD-880016
#FUN-920190
