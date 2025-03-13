# Prog. Version..: '5.30.06-13.04.01(00010)'     #
#
# Descriptions...:
# Modify.........: 02/09/12 By Kammy  no.5954
#                  增加欄位-->付款幣別rvw11 、匯率    rvw12
#                             原幣未稅rvw05f、原幣稅額rvw06f
# Modify.........: No.FUN-4B0051 04/11/24 By Mandy 匯率加開窗功能
# Modify.........: No.MOD-530042 05/03/07 By Kitty p_guino,p_guino_o改為用LIKE的
# Modify.........: No.MOD-530687 05/03/26 By Elva  修正大陸版運輸發票的算法 
# Modify.........: No.FUN-560080 05/06/17 By Mandy 補登發票時,數量改用計價數量
# Modify.........: No.MOD-590104 05/10/20 By Nicola 修改錯誤訊息
# Modify.........: No.TQC-630050 06/03/28 By pengu 按放棄OR取消時不insert rvw_file與update rvb22
# Modify.........: No.FUN-640012 06/04/07 By kim GP3.0 匯率參數功能改善
# Modify.........: No.FUN-630068 06/04/09 By Ray 修改‘A'性質稅種的稅額計算方法，同’T'性質稅種
# Modify.........: No.FUN-660129 06/06/19 By rayven cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.CHI-6A0004 06/10/25 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.MOD-760141 07/07/03 By Smapmin 不同廠商不可開同一發票
# Modify.........: NO.TQC-790003 07/09/03 BY yiting insert into前給予預設值
# Modify.........: No.MOD-790036 07/09/10 By Smapmin 樣品不列入發票金額
# Modify.........: No.MOD-810269 08/03/19 By Smapmin 修改發票未稅金額抓取來源
# Modify.........: No.MOD-840070 08/04/14 By Smapmin 計算發票金額時,應過濾已有發票資料的部份
# Modify.........: No.MOD-860006 08/06/02 By Smapmin 修正CHI-6A0004,g_azi04必須重新抓取
# Modify.........: No.CHI-850025 08/06/07 By Sarah 當匯率為1時,需檢核原幣與本幣的稅額、金額需相同
# Modify.........: No.MOD-860086 08/06/11 By Sarah CHI-850025的檢核點移到關閉發票視窗前檢核
# Modify.........: No.MOD-860268 08/06/25 By Smapmin 修改發票內容,應依發票日取匯率;修改完匯率後,本幣金額要能重新計算
# Modify.........: No.MOD-940342 09/04/27 By Dido 若已有入庫單立帳只可顯示,不可維護
# Modify.........: No.MOD-950049 09/05/07 By lilingyu 增加AFTER FIELD rvw02邏輯段
# Modify.........: No.FUN-980006 09/08/17 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-980235 09/08/31 By Sarah 稅別若為含稅,需以含稅金額回推未稅金額,稅額=未稅金額*稅率/100
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990033 09/09/09 By Sarah 稅別改變後,需重算稅額
# Modify.........: No.FUN-9B0146 09/11/26 By lutingting去除rvw_file的 rvwplant
# Modify.........: No.FUN-9C0071 09/12/16 By huangrh  精简程式
# Modify.........: No:MOD-9C0434 10/01/08 By Smapmin 修改已存在的發票號碼後馬上按確認,金額都會變0  
# Modify.........: No:MOD-A60038 10/06/08 By Smapmin 新增收貨單身時維護發票號碼,不應出現沒有匯率的錯誤訊息
# Modify.........: No:CHI-A70002 10/07/05 By Summer 補登發票時，"稅額"與"金額*稅率"的差異不可大於100
# Modify.........: No:MOD-A70126 10/07/23 By Smapmin 稅率為0,稅額不可為0
# Modify.........: No:MOD-A90125 10/10/22 By Smapmin 當不為L/C收貨且發票聯數為2或3碼,發票號碼要控管長度為10碼
# Modify.........: No:MOD-B30017 11/03/04 By Summer 輸入發票號碼後未檢查發票字軌 
# Modify.........: No:CHI-820005 11/05/26 By zhangweib 檢查發票號碼是否有重複時,應多判斷已存在的發票資料其發票日期年度是否為今年,若是的話才卡住.
# Modify.........: No:CHI-B60099 11/07/27 By Polly 修正有小數位差問題，直接SUM(rvb88)
# Modify.........: No:MOD-BB0141 11/11/21 By Vampire apmt110已經會依項次update發票號碼,故請mark掉sapmt114.4gl的621行~625行
# Modify.........: No:MOD-BB0109 11/12/28 By Summer 將TQC-790003的修改搬到597行讓INSERT跟UPDATE欄位值為null時都要給預設值 
# Modify.........: No:MOD-BB0057 12/01/17 By Vampire 按下『補登發票』鈕，幣別跟匯率並無自動帶入 
# Modify.........: No:MOD-C80019 13/03/07 By jt_chen 請改依畫面單身筆數更新
# Modify.........: No:FUN-D10064 13/03/18 By minpp 给新增非空字段rvwacti默认值‘Y’
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sapmt110.global"   #MOD-BB0141 add
 
FUNCTION sapmt114(p_guino,p_rva01)
  DEFINE p_guino      LIKE rvw_file.rvw01       #No.MOD-530042
  DEFINE p_guino_o    LIKE rvw_file.rvw01       #記錄舊發票號   #No.MOD-530042
  DEFINE p_rva01      LIKE rva_file.rva01       #No.MOD-530042
  DEFINE l_pmm21      LIKE pmm_file.pmm21
  DEFINE l_pmm22      LIKE pmm_file.pmm22
  DEFINE l_pmm43      LIKE pmm_file.pmm43
  DEFINE l_rvw        RECORD LIKE rvw_file.*
  DEFINE l_rva        RECORD LIKE rva_file.*
  DEFINE l_gec05      LIKE gec_file.gec05       #No.MOD-530687                             
  DEFINE l_gec07      LIKE gec_file.gec07       #MOD-980235 add
  DEFINE l_rvw05f_o   LIKE rvw_file.rvw05f      #No.MOD-530687 
  DEFINE l_chr	      LIKE type_file.chr1       #No.FUN-680136 VARCHAR(1)
  DEFINE l_errno      LIKE ze_file.ze01         #No.FUN-680136 VARCHAR(10)
  DEFINE l_cnt	      LIKE type_file.num5       #No.FUN-680136 SMALLINT
  DEFINE l_flag       LIKE type_file.chr1       #No.FUN-680136 VARCHAR(1)
  DEFINE g_azi04      LIKE azi_file.azi04
  DEFINE t_azi04      LIKE azi_file.azi04
  DEFINE g_aza17      LIKE aza_file.aza17
  DEFINE g_rva05 LIKE rva_file.rva05   #MOD-760141
  DEFINE l_rvw05f LIKE rvw_file.rvw05  #MOD-810269
  DEFINE l_rvw06f_1   LIKE rvw_file.rvw06f  #CHI-A70002 add
  DEFINE l_rvw06_1    LIKE rvw_file.rvw06   #CHI-A70002 add
  DEFINE l_num        LIKE type_file.num5   #MOD-A90125
#MOD-B30017 add --start--
  DEFINE l_rva06     LIKE rva_file.rva06   
  DEFINE l_gec08     LIKE gec_file.gec08 
  DEFINE l_amb01     LIKE amb_file.amb01
  DEFINE l_amb02     LIKE amb_file.amb02
  DEFINE l_amb03     LIKE amb_file.amb03
  DEFINE g_msg       LIKE type_file.chr1000
  DEFINE g_apz07     LIKE apz_file.apz07
#MOD-B30017 add --end--
#MOD-BB0057 ----- start -----
  DEFINE l_rva00      LIKE rva_file.rva00 
  DEFINE l_rva115     LIKE rva_file.rva115 
  DEFINE l_rva116     LIKE rva_file.rva116 
  DEFINE l_rva113     LIKE rva_file.rva113 
  DEFINE l_rva114     LIKE rva_file.rva114 
#MOD-BB0057 -----  end  -----
  DEFINE l_i          LIKE type_file.num5   #MOD-BB0141 add
 
  INITIALIZE l_rvw.* TO NULL
  LET l_flag='N'
 
  SELECT * INTO l_rvw.* FROM rvw_file WHERE rvw01 = p_guino
  IF STATUS THEN LET l_flag='N' ELSE LET l_flag='Y' END IF
 
  SELECT aza17 INTO g_aza17 FROM aza_file WHERE aza01='0'
  SELECT azi04 INTO g_azi04 FROM azi_file WHERE azi01 = g_aza17   #No.CHI-6A0004   #MOD-860006 取消mark
  
  LET l_rvw.rvw01 = p_guino
  IF l_rvw.rvw02 IS NULL THEN
     #MOD-BB0057 ----- start -----
     #SELECT rva06 INTO l_rvw.rvw02 FROM rva_file,pmm_file 
     # WHERE rva01 = p_rva01  AND rva02 = pmm01 AND pmm18 !='X'
     SELECT rva06 INTO l_rvw.rvw02 FROM rva_file 
      WHERE rva01 = p_rva01
     #MOD-BB0057 -----  end  -----
        AND rvaconf !='X'
  END IF
  #MOD-BB0057 ----- start -----
  SELECT rva00,rva115,rva116,rva113,rva114 
    INTO l_rva00,l_rva115,l_rva116,l_rva113,l_rva114
    FROM rva_file 
   WHERE rva01 = p_rva01

  IF l_rva00 = '1' THEN
  #MOD-BB0057 -----  end  -----
     #抓收貨單單身第一筆的採購單幣別
     DECLARE pmm_cs CURSOR FOR
      SELECT UNIQUE pmm21,pmm22,pmm43,azi04
        FROM pmm_file,rvb_file,azi_file
       WHERE pmm01 = rvb04  AND rvb01 = p_rva01
         AND azi01 = pmm22  
     OPEN pmm_cs 
     FETCH pmm_cs INTO l_pmm21,l_pmm22,l_pmm43,t_azi04
 
     IF cl_null(l_rvw.rvw03) THEN
        LET l_rvw.rvw03 = l_pmm21
     END IF
     IF cl_null(l_rvw.rvw04) THEN
        LET l_rvw.rvw04 = l_pmm43
     END IF
 
     IF cl_null(l_rvw.rvw11) THEN   #add幣別
        LET l_rvw.rvw11 = l_pmm22
     END IF
 
     IF cl_null(l_rvw.rvw12) THEN   #add匯率
        IF NOT cl_null(l_rvw.rvw11) THEN   #MOD-A60038
           CALL s_curr3(l_rvw.rvw11,l_rvw.rvw02,g_sma.sma904) RETURNING l_rvw.rvw12 #FUN-640012
        END IF   #MOD-A60038
        IF cl_null(l_rvw.rvw12) THEN LET l_rvw.rvw12 = 1 END IF
     END IF
  #MOD-BB0057 ----- start -----
  ELSE
     LET l_rvw.rvw03 = l_rva115
     LET l_rvw.rvw04 = l_rva116
     LET l_rvw.rvw11 = l_rva113
     LET l_rvw.rvw12 = l_rva114
  END IF
  #MOD-BB0057 -----  end  -----
  SELECT gec04,gec05,gec07 INTO l_rvw.rvw04,l_gec05,l_gec07
    FROM gec_file
   WHERE gec01 = l_rvw.rvw03 AND gec011='1'  #進項
  IF cl_null(l_rvw.rvw05f) THEN
    #SELECT SUM(rvb87*rvb10) INTO l_rvw.rvw05f FROM rvb_file        #CHI-B60099 mark
     SELECT SUM(rvb88) INTO l_rvw.rvw05f FROM rvb_file              #CHI-B60099 add
      WHERE rvb01 = p_rva01 AND rvb35 <> 'Y'
        AND (rvb22 = ' ' OR rvb22 IS NULL)   #MOD-840070
     IF cl_null(l_rvw.rvw05f) THEN LET l_rvw.rvw05f = 0 END IF
    #SELECT SUM(rvb87*rvb10t) INTO l_rvw05f FROM rvb_file           #CHI-B60099 mark
     SELECT SUM(rvb88t) INTO l_rvw05f FROM rvb_file                 #CHI-B60099 add
      WHERE rvb01 = p_rva01 AND rvb35 <> 'Y'
        AND (rvb22 = ' ' OR rvb22 IS NULL)   #MOD-840070
     IF cl_null(l_rvw05f) THEN LET l_rvw05f = 0 END IF
     LET l_rvw.rvw05f = cl_digcut(l_rvw.rvw05f,t_azi04)
     LET l_rvw05f = cl_digcut(l_rvw05f,t_azi04)
     IF l_gec07='Y' THEN   #含稅
        LET l_rvw.rvw05f = l_rvw05f / (1 + l_rvw.rvw04 / 100)
        LET l_rvw.rvw05f = cl_digcut(l_rvw.rvw05f,t_azi04)
     END IF
     LET l_rvw.rvw06f = (l_rvw.rvw05f * l_rvw.rvw04 / 100)   #MOD-980235 add
     LET l_rvw.rvw06f = cl_digcut(l_rvw.rvw06f,t_azi04)       #原幣稅額
     LET l_rvw.rvw05  = l_rvw.rvw05f * l_rvw.rvw12
     LET l_rvw.rvw05  = cl_digcut(l_rvw.rvw05,g_azi04)        #本幣未稅
     LET l_rvw.rvw06  = (l_rvw.rvw05 * l_rvw.rvw04 / 100)
     LET l_rvw.rvw06  = cl_digcut(l_rvw.rvw06,g_azi04)        #本幣稅額 
  END IF
  LET l_rvw05f_o = l_rvw.rvw05f    #MOD-810269
 
  SELECT * INTO l_rva.* FROM rva_file 
   WHERE rva01 = p_rva01 AND rvaconf !='X'
  
  #判斷該發票在AP是否已立帳, 若已立帳, 則不可修改發票資料
  LET l_cnt = 0
  IF NOT cl_null(p_guino) THEN
     SELECT COUNT(*) INTO l_cnt
       FROM apb_file
      WHERE apb11 IS NOT NULL AND apb11<>' '
        AND apb11=p_guino
     IF SQLCA.SQLCODE<> 0 OR l_cnt = 0 OR l_cnt IS NULL THEN
        SELECT COUNT(*) INTO l_cnt
          FROM apk_file                          #MOD-940342  add
         WHERE apk03=p_guino                     #MOD-940342  add
        IF SQLCA.SQLCODE <> 0 OR l_cnt IS NULL THEN
           LET l_cnt=0
        END IF
     END IF
  END IF
 
  #99.11.11若為外購, 則判斷外購是否已立帳
  IF l_cnt = 0 AND l_rva.rva04 = 'Y' THEN
     IF NOT cl_null(p_guino) THEN
        #判斷是否已到貨
        SELECT COUNT(*) INTO l_cnt
          FROM alk_file
         WHERE alk01 = p_guino
        IF SQLCA.SQLCODE <> 0 OR l_cnt IS NULL THEN
           LET l_cnt=0
        END IF
      END IF
   END IF
 
  IF cl_null(l_cnt) THEN LET l_cnt=0 END IF
  OPEN WINDOW t114_w AT 7,25 WITH FORM "apm/42f/apmt114"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("apmt114")
 
  #LET l_rvw05f_o = 0  #NO.MOD-530687   #MOD-810269
  IF l_cnt = 0 THEN
  INPUT BY NAME l_rvw.rvw01,l_rvw.rvw02,l_rvw.rvw03 ,l_rvw.rvw04,
                l_rvw.rvw11,l_rvw.rvw12,l_rvw.rvw05f,l_rvw.rvw05,
                l_rvw.rvw06f,l_rvw.rvw06 WITHOUT DEFAULTS
     AFTER FIELD rvw01
        IF cl_null(l_rvw.rvw01) THEN NEXT FIELD rvw01 END IF
        #若為外購, 則檢核不能超收進口編號的數量及訂單必須存在進口編號
        IF l_rva.rva04 = 'Y' THEN
            LET l_errno=' '
            CALL t114_rvw01(l_rvw.rvw01,p_rva01) RETURNING l_errno
            IF NOT cl_null(l_errno) THEN
               CALL cl_err('sel rvw01',l_errno,0)
               NEXT FIELD rvw01
            END IF
        END IF
        IF NOT cl_null(l_rvw.rvw01) THEN
           LET g_rva05 = ''
           SELECT rva05 INTO g_rva05 FROM rva_file WHERE rva01 = p_rva01
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt FROM rvw_file,rva_file,rvb_file
              WHERE rvw01 = l_rvw.rvw01 AND
                    rvb22 = rvw01 AND
                    rvb01 = rva01 AND
                    rva05 <> g_rva05
           IF l_cnt > 0 THEN
              CALL cl_err(l_rvw.rvw01,'apm-435',0)
              NEXT FIELD rvw01
           END IF
           #-----MOD-A90125---------
           IF (l_rva.rva04 = 'N' OR l_rva.rva04 IS NULL) 
              AND g_aza.aza26 = '0' THEN 
              LET l_gec05 = NULL
              SELECT gec05 INTO l_gec05 FROM gec_file 
                WHERE gec01 = l_rvw.rvw03 
                  AND gec011 = '1'
              LET l_num = LENGTH(l_rvw.rvw01)
              IF l_num <> 10 AND l_gec05 MATCHES '[23]' THEN 
                 CALL cl_err(l_rvw.rvw10,'amd-010',0)
                 NEXT FIELD CURRENT
              END IF
           END IF
           #-----END MOD-A90125-----
           #MOD-B30017 add --start--
           IF NOT cl_null(l_rvw.rvw01) THEN
               LET l_gec05 = '' LET l_gec08 = ''
              SELECT gec05,gec08 INTO l_gec05,l_gec08 FROM gec_file 
                WHERE gec01 = l_rvw.rvw03 
                  AND gec011 = '1'
              IF l_gec05 != 'X' THEN
                 IF NOT t114_chk(l_rvw.rvw01,l_gec05) THEN 
                    CALL cl_err(l_rvw.rvw01,'sub-005',0)
                    NEXT FIELD rvw01
                 END IF
              END IF
              LET l_rva06 = ''
              SELECT rva06 INTO l_rva06 FROM rva_file WHERE rva01 = p_rva01
              LET l_amb03=l_rvw.rvw01[1,2]
              IF l_rva06 != l_rvw.rvw02 THEN
                 LET l_amb01=YEAR(l_rvw.rvw02)
                 LET l_amb02=MONTH(l_rvw.rvw02)
              ELSE
                 LET l_amb01=YEAR(l_rva06)
                 LET l_amb02=MONTH(l_rva06)
              END IF
              LET g_msg = "" 
              SELECT apz07 INTO g_apz07 FROM apz_file
              IF g_apz07 = 'Y' AND (l_gec05 = '2' OR l_gec05 = '3') AND 
                 g_aza.aza26!= '2' THEN 
                 CALL s_apkchk(l_amb01,l_amb02,l_amb03,l_gec08)
                      RETURNING g_errno,g_msg
              END IF 
              IF NOT cl_null(g_msg) THEN
                 CALL cl_getmsg(g_msg,g_lang) RETURNING g_msg
                 ERROR g_msg clipped,' invoice =',l_rvw.rvw01,' SQLCODE=',g_errno
                  IF cl_confirm('aap-766') THEN 
                     IF NOT cl_null(g_errno) THEN
                        NEXT FIELD rvw01
                     END IF
                 END IF
              END IF

              LET g_rva05 = ''
              SELECT rva05 INTO g_rva05 FROM rva_file WHERE rva01 = p_rva01
              CALL t114_invoice_chk(l_rvw.rvw01,l_rvw.rvw02,'',g_rva05,l_rvw.rvw03)   #CHI-820005   Add ,l_rvw.rvw02
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(l_rvw.rvw01,g_errno,0)
                 NEXT FIELD rvw01 
              END IF
           END IF
           #MOD-B30017 add --end--
        END IF
        IF l_rvw.rvw01 <> p_guino THEN
           LET p_guino_o = p_guino       #先記錄舊的發票號碼
           LET p_guino=l_rvw.rvw01
        END IF
 
     AFTER FIELD rvw02
          IF NOT cl_null(l_rvw.rvw11) THEN   #MOD-A60038
             CALL s_curr3(l_rvw.rvw11,l_rvw.rvw02,g_sma.sma904) RETURNING l_rvw.rvw12 
          END IF   #MOD-A60038
          IF cl_null(l_rvw.rvw12) THEN LET l_rvw.rvw12 = 1 END IF
          DISPLAY BY NAME l_rvw.rvw12
          LET l_rvw.rvw05  = l_rvw.rvw05f * l_rvw.rvw12
          LET l_rvw.rvw05  = cl_digcut(l_rvw.rvw05,g_azi04)
          LET l_rvw.rvw06  = (l_rvw.rvw05 * l_rvw.rvw04 / 100)
          LET l_rvw.rvw06  = cl_digcut(l_rvw.rvw06,g_azi04)
          DISPLAY BY NAME  l_rvw.rvw05,l_rvw.rvw06 
 
     AFTER FIELD rvw03
        SELECT gec04,gec05,gec07 INTO l_rvw.rvw04,l_gec05,l_gec07   #MOD-980235 add gec07
          FROM gec_file
         WHERE gec01 = l_rvw.rvw03 AND gec011='1'  #進項
        IF STATUS THEN 
           CALL cl_err3("sel","gec_file",l_rvw.rvw03,"",STATUS,"","sel gec:",1) #No.FUN-660129
           NEXT FIELD rvw03 END IF
        #-----MOD-A90125---------
        IF (l_rva.rva04 = 'N' OR l_rva.rva04 IS NULL) 
           AND g_aza.aza26 = '0' THEN 
           LET l_num = LENGTH(l_rvw.rvw01)
           IF l_num <> 10 AND l_gec05 MATCHES '[23]' THEN 
              CALL cl_err(l_rvw.rvw10,'amd-010',0)
              NEXT FIELD rvw01
           END IF
        END IF
        #-----END MOD-A90125-----
        #MOD-B30017 add --start--
        IF NOT cl_null(l_rvw.rvw01) THEN
            LET l_gec05 = '' LET l_gec08 = ''
           SELECT gec05,gec08 INTO l_gec05,l_gec08 FROM gec_file 
             WHERE gec01 = l_rvw.rvw03 
               AND gec011 = '1'
           IF l_gec05 != 'X' THEN
              IF NOT t114_chk(l_rvw.rvw01,l_gec05) THEN 
                 CALL cl_err(l_rvw.rvw01,'sub-005',0)
                 NEXT FIELD rvw01
              END IF
           END IF
           LET l_rva06 = ''
           SELECT rva06 INTO l_rva06 FROM rva_file WHERE rva01 = p_rva01
           LET l_amb03=l_rvw.rvw01[1,2]
           IF l_rva06 != l_rvw.rvw02 THEN
              LET l_amb01=YEAR(l_rvw.rvw02)
              LET l_amb02=MONTH(l_rvw.rvw02)
           ELSE
              LET l_amb01=YEAR(l_rva06)
              LET l_amb02=MONTH(l_rva06)
           END IF
           LET g_msg = "" 
           SELECT apz07 INTO g_apz07 FROM apz_file
           IF g_apz07 = 'Y' AND (l_gec05 = '2' OR l_gec05 = '3') AND 
              g_aza.aza26!= '2' THEN 
              CALL s_apkchk(l_amb01,l_amb02,l_amb03,l_gec08)
                   RETURNING g_errno,g_msg
           END IF 
           IF NOT cl_null(g_msg) THEN
              CALL cl_getmsg(g_msg,g_lang) RETURNING g_msg
              ERROR g_msg clipped,' invoice =',l_rvw.rvw01,' SQLCODE=',g_errno
               IF cl_confirm('aap-766') THEN 
                  IF NOT cl_null(g_errno) THEN
                     NEXT FIELD rvw01
                  END IF
              END IF
           END IF

           LET g_rva05 = ''
           SELECT rva05 INTO g_rva05 FROM rva_file WHERE rva01 = p_rva01
           CALL t114_invoice_chk(l_rvw.rvw01,l_rvw.rvw02,'',g_rva05,l_rvw.rvw03)    #CHI-820005   Add ,l_rvw.rvw02
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(l_rvw.rvw01,g_errno,0)
              NEXT FIELD rvw01 
           END IF
        END IF
        #MOD-B30017 add --end--
        DISPLAY BY NAME l_rvw.rvw04
        LET l_rvw.rvw06  = (l_rvw.rvw05 * l_rvw.rvw04 / 100)
        LET l_rvw.rvw06  = cl_digcut(l_rvw.rvw06,g_azi04)
        LET l_rvw.rvw06f = (l_rvw.rvw05f * l_rvw.rvw04 / 100)
        LET l_rvw.rvw06f = cl_digcut(l_rvw.rvw06f,t_azi04)
        DISPLAY BY NAME l_rvw.rvw06,l_rvw.rvw06f
    
     AFTER FIELD rvw11
        SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = l_rvw.rvw11
        IF STATUS THEN
           CALL cl_err3("sel","azi_file",l_rvw.rvw11,"","aap-002","","",1)  #No.FUN-660129
           NEXT FIELD rvw11
        ELSE
           CALL s_curr3(l_rvw.rvw11,l_rvw.rvw02,g_sma.sma904) RETURNING l_rvw.rvw12 #FUN-640012   #MOD-860268
           DISPLAY BY NAME l_rvw.rvw12
        END IF
 
     AFTER FIELD rvw12
        LET l_rvw.rvw05  = l_rvw.rvw05f * l_rvw.rvw12
        LET l_rvw.rvw05  = cl_digcut(l_rvw.rvw05,g_azi04)        #本幣未稅
        LET l_rvw.rvw06  = (l_rvw.rvw05 * l_rvw.rvw04 / 100)
        LET l_rvw.rvw06  = cl_digcut(l_rvw.rvw06,g_azi04)        #本幣稅額
        DISPLAY BY NAME  l_rvw.rvw05,l_rvw.rvw06
 
     BEFORE FIELD rvw05f                                                        
        IF l_gec05 = 'T' OR l_gec05 = 'A' THEN     #FUN-630068
           CALL cl_err(0,'aoo-009',0) 
        END IF 
 
     AFTER FIELD rvw05f
        IF l_rvw05f_o != l_rvw.rvw05f THEN    #MOD-810269
           IF l_gec05 = 'T' OR l_gec05 = 'A' THEN      #FUN-630068                                             
                 LET l_rvw.rvw05f = l_rvw.rvw05f / (1 + l_rvw.rvw04/100)   #MOD-810269
                 LET l_rvw.rvw05f = cl_digcut(l_rvw.rvw05f,t_azi04)       #原幣未稅
                 LET l_rvw.rvw06f = (l_rvw.rvw05f * l_rvw.rvw04 /100)  #MOD-810269
                 LET l_rvw.rvw06f = cl_digcut(l_rvw.rvw06f,t_azi04)       #原幣稅額
                 LET l_rvw.rvw05  = l_rvw.rvw05f * l_rvw.rvw12                     
                 LET l_rvw.rvw05  = cl_digcut(l_rvw.rvw05,g_azi04)        #本幣未稅
                 LET l_rvw.rvw06  = (l_rvw.rvw05*l_rvw.rvw04/100)   #MOD-810269
                 LET l_rvw.rvw06  = cl_digcut(l_rvw.rvw06,g_azi04)        #本幣稅額
           ELSE     
              LET l_rvw.rvw05f = cl_digcut(l_rvw.rvw05f,t_azi04)       #原幣未稅   
              LET l_rvw.rvw06f = (l_rvw.rvw05f * l_rvw.rvw04 /100)                 
              LET l_rvw.rvw06f = cl_digcut(l_rvw.rvw06f,t_azi04)       #原幣稅額   
              LET l_rvw.rvw05  = l_rvw.rvw05f * l_rvw.rvw12                        
              LET l_rvw.rvw05  = cl_digcut(l_rvw.rvw05,g_azi04)        #本幣未稅   
              LET l_rvw.rvw06  = (l_rvw.rvw05 * l_rvw.rvw04 / 100)                 
              LET l_rvw.rvw06  = cl_digcut(l_rvw.rvw06,g_azi04)        #本幣稅額   
           END IF                                                                  
        END IF   #MOD-810269
        LET l_rvw05f_o = l_rvw.rvw05f                                           
        DISPLAY BY NAME l_rvw.rvw05f,l_rvw.rvw05,l_rvw.rvw06f,l_rvw.rvw06
 
     AFTER FIELD rvw06f	
        IF NOT cl_null(l_rvw.rvw06f) THEN
           LET l_rvw.rvw06f = cl_digcut(l_rvw.rvw06f,t_azi04)    #原幣稅額
           DISPLAY BY NAME l_rvw.rvw06f
        END IF
 
     AFTER FIELD rvw05
           LET l_rvw.rvw06 = (l_rvw.rvw05 * l_rvw.rvw04 / 100)
           LET l_rvw.rvw05 = cl_digcut(l_rvw.rvw05,g_azi04)
           LET l_rvw.rvw06 = cl_digcut(l_rvw.rvw06,g_azi04)
        DISPLAY BY NAME l_rvw.rvw05,l_rvw.rvw06
 
     AFTER FIELD rvw06
        IF NOT cl_null(l_rvw.rvw06) THEN
           LET l_rvw.rvw06 = cl_digcut(l_rvw.rvw06,g_azi04)
           DISPLAY BY NAME l_rvw.rvw06
        END IF
 
     AFTER INPUT
        IF INT_FLAG THEN
           EXIT INPUT
        END IF
       #當匯率為1時,需檢核原幣與本幣的稅額、金額需相同
        IF l_rvw.rvw12 = 1 THEN
           IF l_rvw.rvw05f != l_rvw.rvw05 OR l_rvw.rvw06f != l_rvw.rvw06 THEN
              CALL cl_err('','apm-988',1)
              NEXT FIELD rvw05f
           END IF
        END IF
        #CHI-A70002 add --start--
        LET l_rvw06f_1 = cl_digcut((l_rvw.rvw05f * l_rvw.rvw04 / 100),t_azi04) - l_rvw.rvw06f
        IF l_rvw06f_1 < 0 THEN LET l_rvw06f_1 = l_rvw06f_1 * -1 END IF
        IF l_rvw06f_1 > 100 THEN
           CALL cl_err('','apm-114',1)
           NEXT FIELD rvw06f
        END IF
        LET l_rvw06_1 = cl_digcut((l_rvw.rvw05 * l_rvw.rvw04 / 100),g_azi04) - l_rvw.rvw06
        IF l_rvw06_1 < 0 THEN LET l_rvw06_1 = l_rvw06_1 * -1 END IF
        IF l_rvw06_1 > 100 THEN
           CALL cl_err('','apm-114',1)
           NEXT FIELD rvw06
        END IF
        #CHI-A70002 add --end--
       #-----MOD-A70126---------
       IF l_rvw.rvw04 = 0 AND (l_rvw.rvw06 > 0 OR l_rvw.rvw06f > 0) THEN
          CALL cl_err('','aap-902',1)
          LET l_rvw.rvw06 = 0
          LET l_rvw.rvw06f = 0
          DISPLAY BY NAME l_rvw.rvw06,l_rvw.rvw06f
          NEXT FIELD rvw06
       END IF 
       #-----END MOD-A70126-----
 
     ON ACTION CONTROLP
        CASE WHEN INFIELD(rvw11) #查詢幣別資料檔
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azi" 
                  LET g_qryparam.default1 = l_rvw.rvw11
                  CALL cl_create_qry() RETURNING l_rvw.rvw11
                  DISPLAY BY NAME l_rvw.rvw11 
                  NEXT FIELD rvw11
                WHEN INFIELD(rvw12)
                   CALL s_rate(l_rvw.rvw11,l_rvw.rvw12) RETURNING l_rvw.rvw12
                   DISPLAY BY NAME l_rvw.rvw12
                   NEXT FIELD rvw12
             WHEN INFIELD(rvw03) #查詢稅別資料檔
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gec"
                  LET g_qryparam.arg1 = "1"
                  LET g_qryparam.default1 = l_rvw.rvw03
                  LET g_qryparam.construct='N'
                  CALL cl_create_qry() RETURNING l_rvw.rvw03
                  DISPLAY BY NAME l_rvw.rvw03
                  NEXT FIELD rvw03
        END CASE
  
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
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
  ELSE
     DISPLAY BY NAME l_rvw.rvw01,l_rvw.rvw02,l_rvw.rvw03 ,l_rvw.rvw04,
                     l_rvw.rvw11,l_rvw.rvw12,l_rvw.rvw05f,l_rvw.rvw05,
                     l_rvw.rvw06,l_rvw.rvw06f
     CALL cl_err('','apm-241',1)
            LET INT_FLAG = 0  ######add for prompt bug
  END IF
  IF INT_FLAG THEN 
     CALL cl_err('','apm-433',1)
     INITIALIZE l_rvw.* TO NULL
     CLOSE WINDOW t114_w 
     RETURN p_guino
  END IF
  CLOSE WINDOW t114_w
 
  LET l_rvw.rvwlegal=g_legal #FUN-980006 add 
  LET l_rvw.rvwacti = 'Y'    #FUN-D10064 
#  IF (cl_null(l_rvw.rvw01) AND l_rvw.rvw01<>p_guino) OR # 新發票號!=舊發票號   #MOD-9C0434
#     cl_null(p_guino) OR l_flag='N' THEN   #MOD-9C0434
     #MOD-BB0109 add --start--
     IF cl_null(l_rvw.rvw08) THEN LET l_rvw.rvw08 = ' ' END IF
     IF cl_null(l_rvw.rvw09) THEN LET l_rvw.rvw09 = 0 END IF
     #MOD-BB0109 add --end--
     SELECT COUNT(*) INTO l_cnt FROM rvw_file 
      WHERE rvw01=l_rvw.rvw01
     IF l_cnt=0 THEN  
       #MOD-BB0109 mark --start--
       #IF cl_null(l_rvw.rvw08) THEN LET l_rvw.rvw08 = ' ' END IF
       #IF cl_null(l_rvw.rvw09) THEN LET l_rvw.rvw09 = 0 END IF
       #MOD-BB0109 mark --end--
        INSERT INTO rvw_file VALUES (l_rvw.*)
        IF STATUS THEN 
           CALL cl_err3("ins","rvw_file",l_rvw.rvw01,"",STATUS,"","ins rvw:",1)  RETURN p_guino #No.FUN-660129
        ELSE
           RETURN l_rvw.rvw01
        END IF
     ELSE
        UPDATE rvw_file SET * = l_rvw.* WHERE rvw01 = p_guino
        IF STATUS THEN
           CALL cl_err3("upd","rvw_file",p_guino,"",STATUS,"","upd rvw",1) #No.FUN-660129
           RETURN p_guino END IF
     END IF
     IF NOT cl_null(p_guino_o) THEN
        #MOD-BB0141 ----- add start -----
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt FROM rvb_file
         WHERE rvb01 = g_rva.rva01 
           AND rvb22 = p_guino_o
        IF l_cnt > 0 THEN
           IF cl_confirm('apm1066') THEN
        #MOD-BB0141 -----  add end  -----
              DELETE FROM rvw_file WHERE rvw01=p_guino_o
             #MOD-C80019 mark start -----
             #UPDATE rvb_file SET rvb22=p_guino
             # WHERE rvb22=p_guino_o
             #MOD-C80019 mark end   -----
        #MOD-BB0141 ----- add start -----
             #MOD-C80019 mark start -----
             #SELECT COUNT(*) INTO l_cnt FROM rvb_file WHERE rvb22 = g_rva.rva01 
             #FOR l_i = 1 TO l_cnt
             #MOD-C80019 mark end   -----
              #MOD-C80019 add start -----
              FOR l_i = 1 TO g_rvb.getLength()
                  UPDATE rvb_file SET rvb22=p_guino
                   WHERE rvb01=g_rva.rva01 AND rvb02=g_rvb[l_i].rvb02
              #MOD-C80019 add end   -----
                  LET g_rvb[l_i].rvb22 = p_guino
              END FOR
           END IF
        END IF
        #MOD-BB0141 ----- add end  -----
     END IF
#-----MOD-9C0434---------
  #ELSE
  #   UPDATE rvw_file SET * = l_rvw.* WHERE rvw01 = p_guino
  #   IF STATUS THEN 
  #      CALL cl_err3("upd","rvw_file",p_guino,"",STATUS,"","upd rvw",1) #No.FUN-660129
  #      RETURN p_guino END IF
  #END IF
#-----END MOD-9C0434-----
 
  RETURN l_rvw.rvw01
END FUNCTION
 
FUNCTION t114_rvw01(l_rvw01,l_rva01)
   DEFINE l_rvw01  LIKE rvw_file.rvw01
   DEFINE l_rvb    RECORD LIKE rvb_file.*,
          l_rva    RECORD LIKE rva_file.*,
          l_rva01  LIKE rva_file.rva01,
          l_als05  LIKE als_file.als05,
          l_als21  LIKE als_file.als21,
          l_alt06  LIKE alt_file.alt06,
          t_alt06  LIKE alt_file.alt06,
          l_errno  LIKE ze_file.ze01     	#No.FUN-680136 VARCHAR(10)
  
   LET l_errno=' '
   #讀取驗收單單頭檔
   SELECT * INTO l_rva.*
     FROM rva_file
    WHERE rva01= l_rva01 AND rvaconf !='X'
   IF SQLCA.SQLCODE THEN
      LET l_errno=SQLCA.SQLCODE
      RETURN l_errno
   END IF
   IF l_rva.rva04 = 'Y' THEN
      #輸入之發票號碼必須存在提單資料檔中
      SELECT als05,als21 INTO l_als05,l_als21 
        FROM als_file
       WHERE als01 = l_rvw01
      IF SQLCA.SQLCODE THEN
         LET l_errno='apm-269'
         RETURN l_errno
      END IF
      #check廠商必須相同
      IF l_als05 <> l_rva.rva05  THEN
         LET l_errno='apm-290'
         RETURN l_errno
      END IF
   ELSE
      RETURN ' '
   END IF
 
   DECLARE t114_c1 CURSOR FOR
      SELECT  * FROM rvb_file WHERE rvb01 = l_rva01
 
   FOREACH t114_c1 INTO l_rvb.*
      IF SQLCA.SQLCODE THEN 
         CALL cl_err('',SQLCA.SQLCODE,1)    #No.FUN-660129
         EXIT FOREACH 
      END IF
      #判斷若為LC收貨則輸入之PO必須存在提單檔中
      IF l_rva.rva04='Y' THEN
         CALL t114_alt(l_rvw01,l_rvb.rvb04,l_rvb.rvb03)
                         RETURNING l_errno
         IF NOT cl_null(l_errno) THEN 
            RETURN l_errno
         END IF
      END IF
      #讀取提單數量
      LET l_alt06=0
      SELECT alt06 INTO l_alt06 
        FROM alt_file
       WHERE alt01 = l_rvw01
         AND alt14 = l_rvb.rvb04   
         AND alt15 = l_rvb.rvb03   
      IF SQLCA.SQLCODE THEN
         LET l_errno='apm-290'
         RETURN l_errno
      END IF
      #記錄該提單已交貨量
      LET t_alt06=0
      SELECT SUM(rvb07) INTO t_alt06
        FROM rvb_file
       WHERE rvb04=l_rvb.rvb04 
         AND rvb03=l_rvb.rvb03
         AND rvb22=l_rvw01 
         AND NOT (rvb01=l_rva.rva01 AND rvb02=l_rvb.rvb02)
      IF SQLCA.SQLCODE OR cl_null(t_alt06) THEN
         LET t_alt06=0
      END IF
      IF l_rvb.rvb07 > (l_alt06-t_alt06) THEN
         LET l_errno='apm-297'
         RETURN l_errno
      END IF 
   END FOREACH
   RETURN ' '
END FUNCTION
 
#99.11.11檢核LC收貨時, PO是否存在提單資料中
FUNCTION t114_alt(l_rvb22,l_alt14,l_alt15)   
  DEFINE l_alt   RECORD LIKE alt_file.*
  DEFINE l_rvb22  LIKE rvb_file.rvb22,    #到單號碼
         l_alt14  LIKE alt_file.alt14,    #採購單號
         l_alt15  LIKE alt_file.alt15     #採購單號
  DEFINE l_errno  LIKE ze_file.ze01       #No.FUN-680136 VARCHAR(10)
 
   LET l_errno = " "
   IF cl_null(l_alt15) THEN
      SELECT UNIQUE alt14
        FROM alt_file 
       WHERE alt01 = l_rvb22    #到單號碼
         AND alt14 = l_alt14    #採購單號
      IF SQLCA.SQLCODE THEN
         LET l_errno='apm-289'
      END IF
   ELSE
      SELECT UNIQUE alt14
        FROM alt_file 
       WHERE alt01 = l_rvb22    #到單號碼
         AND alt14 = l_alt14    #採購單號
         AND alt15 = l_alt15
      IF SQLCA.SQLCODE THEN
         LET l_errno='apm-290'
      END IF
   END IF
   RETURN l_errno
 
END FUNCTION
#No.FUN-9C0071 ---------------- 精简程式------------------------------

#MOD-B30017 add --start--
FUNCTION t114_chk(p_rvw01,p_gec05)
   DEFINE p_rvw01 LIKE apa_file.apa08
   DEFINE p_gec05 LIKE gec_file.gec05 
   DEFINE g_apz07     LIKE apz_file.apz07
   
   #大陸版發票輸入時不需檢查字軌
   IF g_aza.aza26 = '2' THEN RETURN 1 END IF 

   SELECT apz07 INTO g_apz07 FROM apz_file
   IF g_apz07 = 'N' THEN RETURN 1 END IF   #發票輸入時檢查字軌

   #發票為2/3聯時檢查
   IF (p_gec05 !='2' AND p_gec05 !='3') THEN 
      RETURN 1 
   END IF
   
   #台灣版才做下面的檢查
   IF g_aza.aza26 = '0' THEN 
      IF p_rvw01[1,1] MATCHES '[A-Z]' AND p_rvw01[2,2] MATCHES '[A-Z]' AND
         p_rvw01[3,3] MATCHES '[0-9]' AND p_rvw01[4,4] MATCHES '[0-9]' AND
         p_rvw01[5,5] MATCHES '[0-9]' AND p_rvw01[6,6] MATCHES '[0-9]' AND
         p_rvw01[7,7] MATCHES '[0-9]' AND p_rvw01[8,8] MATCHES '[0-9]' AND
         p_rvw01[9,9] MATCHES '[0-9]' AND p_rvw01[10,10] MATCHES '[0-9]' THEN
         RETURN 1
      ELSE
         RETURN 0
      END IF
   ELSE
      RETURN 1
   END IF
END FUNCTION

FUNCTION t114_invoice_chk(p_no,p_date,p_tax,p_rva05,p_rvw03)    #CHI-820005   Add ,p_date
   DEFINE p_no      LIKE apk_file.apk03 
   DEFINE p_date    LIKE apk_file.apk05 #CHI-820005   Add 
   DEFINE p_tax     LIKE gec_file.gec01 
   DEFINE p_rva05   LIKE rva_file.rva05 
   DEFINE p_rvw03   LIKE rvw_file.rvw03 
   DEFINE l_gec08   LIKE gec_file.gec08 
   DEFINE l_gec05   LIKE gec_file.gec05 
   DEFINE l_n1,l_n2 LIKE type_file.num5,
          l_idx     LIKE type_file.num5 
         ,l_year    LIKE type_file.num5    #CHI-820005   Add
   DEFINE g_apz07   LIKE apz_file.apz07

   LET g_errno = ''
   LET l_year = YEAR(p_date)USING '&&&&'  #CHI-820005   Add

   IF p_no IS NULL THEN                 
      LET g_errno = 'aap-099'
      RETURN
   END IF
   IF p_no != 'MISC' AND p_no != 'UNAP' THEN
      SELECT gec05,gec08 INTO l_gec05,l_gec08 FROM gec_file 
        WHERE gec01 = p_rvw03 AND gec011 = '1'
      IF status THEN LET l_gec05='' LET l_gec08='' END IF
   ELSE
      SELECT gec05,gec08 INTO l_gec05,l_gec08 FROM gec_file
       WHERE gec01 = p_tax AND gec011 = '1'
      IF status THEN LET l_gec05='' LET l_gec08='' END IF
   END IF
   IF l_gec08 = 'XX' THEN RETURN END IF
   IF l_gec08 = '22' THEN RETURN END IF 
   IF l_gec05='2' OR l_gec05='3' THEN
      FOR l_idx = 3 TO 10
         IF cl_null(p_no[l_idx,l_idx]) THEN
            LET g_errno='aap-760'
            EXIT FOR
         END IF
      END FOR
   END IF
   IF g_aza.aza26 = '1' THEN 
      SELECT COUNT(*) INTO l_n1 FROM apa_file WHERE apa08 = p_no  
             AND apa05 = p_rva05
             AND YEAR(apa09) = l_year   #CHI-820005
      SELECT COUNT(*) INTO l_n2 FROM apk_file,apa_file WHERE apk03 = p_no
              AND apk171 !='23' AND apk171 != '24'  
              AND apk01 = apa01 AND apa05 = p_rva05 
              AND YEAR(apk05) = l_year   #CHI-820005   Add
   ELSE
      SELECT COUNT(*) INTO l_n1 FROM apa_file WHERE apa08 = p_no
             AND YEAR(apa09) = l_year   #CHI-820005
      SELECT COUNT(*) INTO l_n2 FROM apk_file WHERE apk03 = p_no
              AND apk171 !='23' AND apk171 != '24' 
              AND YEAR(apk05) = l_year   #CHI-820005   Add
   END IF 

   IF (l_n1+l_n2) > 0 THEN
      LET g_errno = 'aap-034'
      RETURN
   END IF

   SELECT apz07 INTO g_apz07 FROM apz_file
   IF g_apz07 != 'Y' THEN
      RETURN
   END IF

   RETURN
END FUNCTION
#MOD-B30017 add --end--
