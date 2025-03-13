# Prog. Version..: '5.30.06-13.04.01(00010)'     #
#
# Modify.........: No.MOD-480609 04/09/02 ching 處理有錯會直接crash
# Modify.........: No.MOD-530042 05/03/07 By Kitty p_guino及p_guino_o改為用Like的
# Modify.........: No.MOD-530043 05/03/07 By Kitty 匯率欄位開窗及放大
# Modify.........: NO.MOD-5B0118 05/12/13 BY yiting 選取稅別後,其稅金額未自動帶出,需經過金額欄位才會顯示,造成user開窗後未經其金額欄位按確認存檔,其資料會異常
# Modify.........: No.MOD-620077 06/02/23 By Smapmin 修改CALL s_curr3的方式
# Modify.........: No.FUN-640022 06/04/08 By kim GP3.0 匯率參數功能改善
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.MOD-680019 06/08/04 By Smapmin 維護匯率後按確定即必須更新金額與稅額
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.MOD-760141 07/07/03 By Smapmin 不同廠商不可開同一發票
# Modify.........: No.MOD-780129 07/08/20 By kim 發票登入後會有INSERT rvw_file Error
# Modify.........: NO.TQC-790003 07/09/03 BY yiting primary key相關修改
# Modify.........: No.MOD-790036 07/09/10 By Smapmin 樣品不列入發票金額
# Modify.........: No.CHI-790035 07/10/08 By Smapmin 發票金額要抓取入庫調整後的金額
# Modify.........: No.FUN-7B0023 07/11/12 By Sarah 發票維護會將入庫,倉退金額加在一起,而不是減掉
# Modify.........: No.TQC-7B0083 07/12/10 By Carrier 無法帶出金額
# Modify.........: No.MOD-810022 08/01/07 By Smapmin 金額預設有誤
# Modify.........: No.MOD-810067 08/01/16 By Smapmin 排除已作廢單據
# Modify.........: No.MOD-810269 08/03/19 By Smapmin 修改發票未稅金額抓取來源
# Modify.........: No.CHI-830022 08/03/19 By Smapmin 針對修改前發票(舊發票)的處理統一在aapp120.
# Modify.........: No.MOD-840070 08/04/14 By Smapmin 計算發票金額時,應過濾已有發票資料的部份
# Modify.........: No.CHI-850025 08/06/07 By Sarah 當匯率為1時,需檢核原幣與本幣的稅額、金額需相同
# Modify.........: No.MOD-860086 08/06/11 By Sarah CHI-850025的檢核點移到關閉發票視窗前檢核
# Modify.........: No.MOD-950049 09/05/07 By lilingyu 增加AFTER FIELD rvw02邏輯段
# Modify.........: No.FUN-980001 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-980235 09/08/31 By Sarah 稅別若為含稅,需以含稅金額回推未稅金額,稅額=未稅金額*稅率/100
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990033 09/09/09 By Sarah 稅別改變後,需重算稅額
# Modify.........: No.FUN-9B0146 09/11/26 By lutingting rvw_file 去除rvwplant
# Modify.........: No.FUN-9C0072 09/12/16 By vealxu 精簡程式碼
# Modify.........: No:MOD-A60005 10/06/02 By Dido 取消 rvv03 = '2' 驗退條件 
# Modify.........: No.FUN-A60056 10/06/24 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No:MOD-A70126 10/07/23 By Smapmin 稅率為0,稅額不可為0
# Modify.........: No:TQC-B50122 11/05/23 By Sarah 追單MOD-B30017,輸入發票號碼後未檢查發票字軌 
# Modify.........: No:CHI-820005 11/05/26 By zhangweib 檢查發票號碼是否有重複時,應多判斷已存在的發票資料其發票日期年度是否為今年,若是的話才卡住.
# Modfiy.........: No:CHI-B60099 11/07/27 By Polly 修正有小數位差問題，直接SUM(未稅金額rvv39)
# Modify.........: No.FUN-BB0001 11/11/01 By pauline 新增rvv22,INSERT/UPDATE rvb22時,同時INSERT/UPDATE rvv22
# Modify.........: No:MOD-CB0067 12/11/09 By Polly 因入庫單可分批入庫，增加入庫單已確認的條件
# Modify.........: No:MOD-BB0057 12/01/17 By Vampire 『發票L/C#號碼』開窗,須判斷收貨單是否為JIT收貨 
# Modify.........: No:FUN-D10064 13/03/19 By minpp rvw_file新增非空字段rvwacti,给该字段默认值
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#FUNCTION saapt114(p_guino,p_rva01,p_plant)   #FUN-A60056 add p_plant  #FUN-BB0001 mark
FUNCTION saapt114(p_guino,p_rva01,p_plant,p_rvu01)   #FUN-BB0001 add
  DEFINE p_guino    LIKE rvw_file.rvw01     #No.MOD-530042
  DEFINE p_guino_o  LIKE rvw_file.rvw01     #記錄舊的發票號碼才可刪除 MOD-530042
  DEFINE p_rva01    LIKE rva_file.rva01     #No.MOD-530042
  DEFINE p_rvu01    LIKE rvu_file.rvu01     #FUN-BB0001 add
  DEFINE l_pmm21    LIKE pmm_file.pmm21
  DEFINE l_pmm22    LIKE pmm_file.pmm22
  DEFINE l_pmm43    LIKE pmm_file.pmm43
  DEFINE l_rvw	    RECORD LIKE rvw_file.*
  DEFINE l_chr	    LIKE type_file.chr1     #No.FUN-690028 VARCHAR(1)
  DEFINE g_azi04    LIKE azi_file.azi04
  DEFINE g_aza17    LIKE aza_file.aza17
  DEFINE g_rva05    LIKE rva_file.rva05     #MOD-760141
  DEFINE l_cnt      LIKE type_file.num5     #MOD-760141
  DEFINE l_rvw05f_1 LIKE rvw_file.rvw05f    #FUN-7B0023 add
  DEFINE l_rvw05f_2 LIKE rvw_file.rvw05f    #FUN-7B0023 add
  DEFINE l_gec05    LIKE gec_file.gec05     #MOD-810269
  DEFINE l_gec07    LIKE gec_file.gec07     #MOD-980235 add
  DEFINE l_rvw05f   LIKE rvw_file.rvw05     #MOD-810269
  DEFINE l_rvw05f_3 LIKE rvw_file.rvw05     #MOD-810269
  DEFINE l_rvw05f_4 LIKE rvw_file.rvw05     #MOD-810269
  DEFINE l_rvw05f_o LIKE rvw_file.rvw05f    #MOD-810269
  DEFINE p_plant    LIKE azp_file.azp01     #FUN-A60056 
  DEFINE l_sql      STRING                  #FUN-A60056 
#TQC-B50122 add --start--
  DEFINE l_rva06     LIKE rva_file.rva06   
  DEFINE l_gec08     LIKE gec_file.gec08 
  DEFINE l_amb01     LIKE amb_file.amb01
  DEFINE l_amb02     LIKE amb_file.amb02
  DEFINE l_amb03     LIKE amb_file.amb03
  DEFINE g_msg       LIKE type_file.chr1000
  DEFINE g_apz07     LIKE apz_file.apz07
#TQC-B50122 add --end--
  DEFINE l_year     LIKE type_file.num5     #CHI-820005
#MOD-BB0057 ----- start -----
  DEFINE l_rva00      LIKE rva_file.rva00
  DEFINE l_rva115     LIKE rva_file.rva115
  DEFINE l_rva116     LIKE rva_file.rva116
  DEFINE l_rva113     LIKE rva_file.rva113
#MOD-BB0057 -----  end  -----

  WHENEVER ERROR CALL cl_err_msg_log
 
  INITIALIZE l_rvw.* TO NULL
  SELECT * INTO l_rvw.* FROM rvw_file WHERE rvw01 = p_guino

  SELECT aza17 INTO g_aza17 FROM aza_file WHERE aza01='0'
  SELECT azi04 INTO g_azi04 FROM azi_file WHERE azi01 = g_aza17

  LET l_rvw.rvw01 = p_guino
  IF cl_null(l_rvw.rvw02) THEN
    #FUN-A60056--mod--str--
    #SELECT rva06 INTO l_rvw.rvw02 FROM rva_file WHERE rva01 = p_rva01
    #  AND rvaconf ='Y'
     IF NOT cl_null(p_rva01) THEN   #FUN-BB0001 add 
        LET l_sql = "SELECT rva06 FROM ",cl_get_target_table(p_plant,'rva_file'),
                    " WHERE rva01 = '",p_rva01,"'"     
   #FUN-BB0001 add START
     ELSE
        LET l_sql = "SELECT rvu03 FROM ",cl_get_target_table(p_plant,'rvu_file'),
                    " WHERE rvu01 = '",p_rvu01,"'"
     END IF
   #FUN-BB0001 add END
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
     PREPARE sel_rva06_pre FROM l_sql
     EXECUTE sel_rva06_pre INTO l_rvw.rvw02
    #FUN-A60056--mod--end
  END IF
 
  #抓收貨單單身第一筆的採購單幣別
 #FUN-A60056--mod--str--
 #DECLARE pmm_cs CURSOR FOR
 # SELECT UNIQUE pmm21,pmm22,pmm43,azi04
 #   FROM pmm_file,rvb_file,azi_file
 #  WHERE pmm01 = rvb04  AND rvb01 = p_rva01
 #    AND azi01 = pmm22  
 #OPEN pmm_cs 
 #FETCH pmm_cs INTO l_pmm21,l_pmm22,l_pmm43,t_azi04
  IF NOT cl_null(p_rva01) THEN  #FUN-BB0001 add 
      #MOD-BB0057 ----- start -----
      SELECT rva00 INTO l_rva00 FROM rva_file WHERE rva01 = p_rva01

       IF l_rva00 = '1' THEN
      #MOD-BB0057 -----  end  ----- 
          LET l_sql = "SELECT UNIQUE pmm21,pmm22,pmm43,azi04 ",
                      "  FROM ",cl_get_target_table(p_plant,'pmm_file'),",",
                      "       ",cl_get_target_table(p_plant,'rvb_file'),",",
                      "       ",cl_get_target_table(p_plant,'azi_file'), 
                      " WHERE pmm01 = rvb04  AND rvb01 = '",p_rva01,"'",
                      "   AND azi01 = pmm22"
      #MOD-BB0057 ----- start -----
       ELSE
          LET l_sql = "SELECT rva115,rva113,rva116,''",
                      "  FROM ",cl_get_target_table(p_plant,' rva_file'),
                      "  WHERE rva01 = '",p_rva01,"' "
       END IF
      #MOD-BB0057 -----  end  ----- 
  #FUN-BB0001 add START
   ELSE
      LET l_sql = " SELECT DISTINCT pmc47,pmc22,azi04 ",
                  " FROM ",cl_get_target_table(p_plant,'pmc_file'),",",
                  "      ",cl_get_target_table(p_plant,'rvu_file'),",",
                  "      ",cl_get_target_table(p_plant,'azi_file'),
                  " WHERE pmc01 = rvu04 AND rvu01 = '",p_rvu01,"'",
                  "   AND azi01 = pmc22 "
   END IF
  #FUN-BB0001 add END
  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
  CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
  PREPARE sel_pmm21 FROM l_sql 
  EXECUTE sel_pmm21 INTO l_pmm21,l_pmm22,l_pmm43,t_azi04
 #FUN-A60056--mod--end
 
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

     CALL s_curr3(l_rvw.rvw11,l_rvw.rvw02,g_apz.apz33) RETURNING l_rvw.rvw12 #FUN-640022
     IF cl_null(l_rvw.rvw12) THEN LET l_rvw.rvw12 = 1 END IF
  END IF
  SELECT gec04,gec05,gec07 INTO l_rvw.rvw04,l_gec05,l_gec07
    FROM gec_file
   WHERE gec01 = l_rvw.rvw03 AND gec011='1'  #進項
  IF cl_null(l_rvw.rvw05f) OR l_rvw.rvw05f = 0 THEN  #No.TQC-7B0083
 
  #FUN-A60056--mod--str--
  #SELECT SUM(rvv87*rvv38) INTO l_rvw05f_1 FROM rvv_file,rvb_file,rvu_file
  #       WHERE rvb01 = p_rva01 AND rvb35 <> 'Y'
  #         AND rvv04 = rvb01
  #         AND rvv05 = rvb02
  #         AND rvv03 = '1'   #入庫
  #         AND rvu01 = rvv01
  #         AND rvuconf <> 'X'
  #         AND (rvb22 = ' ' OR rvb22 IS NULL)   #MOD-840070
  # SELECT SUM(rvv87*rvv38) INTO l_rvw05f_2 FROM rvv_file,rvb_file,rvu_file
  #       WHERE rvb01 = p_rva01 AND rvb35 <> 'Y'
  #         AND rvv04 = rvb01
  #         AND rvv05 = rvb02
  #        #AND (rvv03 = '2' OR rvv03 = '3')  #驗退、倉退   #MOD-A60005 mark
  #         AND rvv03 = '3'  #倉退                          #MOD-A60005
  #         AND rvu01 = rvv01
  #         AND rvuconf <> 'X'
  #         AND (rvb22 = ' ' OR rvb22 IS NULL)   #MOD-840070
    IF NOT cl_null(p_rva01) THEN  #FUN-BB0001 add
      #LET l_sql = "SELECT SUM(rvv87*rvv38) ",      #CHI-B60099 mark
       LET l_sql = "SELECT SUM(rvv39) ",            #CHI-B60099 add
                   "  FROM ",cl_get_target_table(p_plant,'rvv_file'),",",
                   "       ",cl_get_target_table(p_plant,'rvb_file'),",",
                   "       ",cl_get_target_table(p_plant,'rvu_file'),
                   " WHERE rvb01 = '",p_rva01,"'",
                   "   AND rvb35 <> 'Y' AND rvv04 = rvb01 ",
                   "   AND rvv05 = rvb02 AND rvv03 = '1' ",
                  #"   AND rvu01 = rvv01 AND rvuconf <> 'X' ",       #MOD-CB0067 mark
                   "   AND rvu01 = rvv01 AND rvuconf = 'Y' ",        #MOD-CB0067 add
                   "   AND (rvb22 = ' ' OR rvb22 IS NULL)"
#FUN-BB0001 add START
    ELSE
       LET l_sql = " SELECT SUM(rvv39) ",
                   " FROM ",cl_get_target_table(p_plant,'rvv_file'),",",
                   "      ",cl_get_target_table(p_plant,'rvu_file'),
                   " WHERE rvv01 = '",p_rvu01,"'",
                   "   AND rvv25 <> 'Y' ",
                   "   AND rvv03 = '1' ",
                  #"   AND rvu01 = rvv01 AND rvuconf <> 'X' ",       #MOD-CB0067 mark
                   "   AND rvu01 = rvv01 AND rvuconf = 'Y' ",        #MOD-CB0067 add
                   "   AND (rvv22 = ' ' OR rvv22 IS NULL)"
    END IF
#FUN-BB0001 add END
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
    PREPARE sel_rvv87_pre1 FROM l_sql
    EXECUTE sel_rvv87_pre1 INTO l_rvw05f_1

    IF NOT cl_null(p_rva01) THEN   #FUN-BB0001 add
      #LET l_sql = "SELECT SUM(rvv87*rvv38) ",               #CHI-B60099 mark
       LET l_sql = "SELECT SUM(rvv39) ",                     #CHI-B60099 add
                   "  FROM ",cl_get_target_table(p_plant,'rvv_File'),",",
                   "       ",cl_get_target_table(p_plant,'rvb_file'),",",
                   "       ",cl_get_target_table(p_plant,'rvu_file'),
                   " WHERE rvb01 = '",p_rva01,"' ",
                   "   AND rvb35 <> 'Y' AND rvv04 = rvb01",
                   "   AND rvv05 = rvb02 AND rvv03 = '3' ",
                  #"   AND rvu01 = rvv01 AND rvuconf <> 'X' ",        #MOD-CB0067 mark
                   "   AND rvu01 = rvv01 AND rvuconf = 'Y' ",         #MOD-CB0067 add
                   "   AND (rvb22 = ' ' OR rvb22 IS NULL)"
#FUN-BB0001 add START
    ELSE
       LET l_sql = " SELECT SUM(rvv39) ",
                   " FROM ",cl_get_target_table(p_plant,'rvv_file'),",",
                   "      ",cl_get_target_table(p_plant,'rvu_file'),
                   " WHERE rvv01 = '",p_rvu01,"'",
                   "   AND rvv25 <> 'Y' ",
                   "   AND rvv03 = '3' ",
                  #"   AND rvu01 = rvv01 AND rvuconf <> 'X' ",        #MOD-CB0067 mark
                   "   AND rvu01 = rvv01 AND rvuconf = 'Y' ",         #MOD-CB0067 add
                   "   AND (rvv22 = ' ' OR rvv22 IS NULL)"
    END IF
#FUN-BB0001 add END
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
    CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
    PREPARE sel_rvv87_pre2 FROM l_sql
    EXECUTE sel_rvv87_pre2 INTO l_rvw05f_2
  #FUN-A60056--mod--end
    IF cl_null(l_rvw05f_1) THEN LET l_rvw05f_1 = 0 END IF
    IF cl_null(l_rvw05f_2) THEN LET l_rvw05f_2 = 0 END IF
    LET l_rvw.rvw05f = l_rvw05f_1 - l_rvw05f_2     #入庫-驗退or倉退
    IF cl_null(l_rvw.rvw05f) THEN LET l_rvw.rvw05f = 0 END IF
  #FUN-A60056--mod--str--
  #SELECT SUM(rvv87*rvv38t) INTO l_rvw05f_3 FROM rvv_file,rvb_file,rvu_file
  #       WHERE rvb01 = p_rva01 AND rvb35 <> 'Y'
  #         AND rvv04 = rvb01
  #         AND rvv05 = rvb02
  #         AND rvv03 = '1'   #入庫
  #         AND rvu01 = rvv01
  #         AND rvuconf <> 'X'
  #         AND (rvb22 = ' ' OR rvb22 IS NULL)   #MOD-840070
  # SELECT SUM(rvv87*rvv38t) INTO l_rvw05f_4 FROM rvv_file,rvb_file,rvu_file
  #       WHERE rvb01 = p_rva01 AND rvb35 <> 'Y'
  #         AND rvv04 = rvb01
  #         AND rvv05 = rvb02
  #        #AND (rvv03 = '2' OR rvv03 = '3')  #驗退、倉退   #MOD-A60005 mark
  #         AND rvv03 = '3'  #倉退                          #MOD-A60005
  #         AND rvu01 = rvv01
  #         AND rvuconf <> 'X'
  #         AND (rvb22 = ' ' OR rvb22 IS NULL)   #MOD-840070
    IF NOT cl_null(p_rva01) THEN  #FUN-BB0001 add
      #LET l_sql = "SELECT SUM(rvv87*rvv38t) ",                #CHI-B60099 mark
       LET l_sql = "SELECT SUM(rvv39t) ",                      #CHI-B60099 add
                   "  FROM ",cl_get_target_table(p_plant,'rvv_file'),",",
                   "       ",cl_get_target_table(p_plant,'rvb_file'),",",
                   "       ",cl_get_target_table(p_plant,'rvu_file'),
                   " WHERE rvb01 = '",p_rva01,"' ",
                   "   AND rvb35 <> 'Y' AND rvv04 = rvb01 ",
                   "   AND rvv05 = rvb02 AND rvv03 = '1' ",
                  #"   AND rvu01 = rvv01 AND rvuconf <> 'X' ",        #MOD-CB0067 mark
                   "   AND rvu01 = rvv01 AND rvuconf = 'Y' ",         #MOD-CB0067 add
                   "   AND (rvb22 = ' ' OR rvb22 IS NULL) "
#FUN-BB0001 add START
    ELSE
       LET l_sql = " SELECT SUM(rvv39t) ",
                   " FROM ",cl_get_target_table(p_plant,'rvv_file'),",",
                   "      ",cl_get_target_table(p_plant,'rvu_file'),
                   " WHERE rvv01 = '",p_rvu01,"'",
                   "   AND rvv25 <> 'Y' ",
                   "   AND rvv03 = '1' ",
                  #"   AND rvu01 = rvv01 AND rvuconf <> 'X' ",        #MOD-CB0067 mark
                   "   AND rvu01 = rvv01 AND rvuconf = 'Y' ",         #MOD-CB0067 add
                   "   AND (rvv22 = ' ' OR rvv22 IS NULL)"
    END IF
#FUN-BB0001 add END
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
    PREPARE sel_rvv87_pre3 FROM l_sql
    EXECUTE sel_rvv87_pre3 INTO l_rvw05f_3

    IF NOT cl_null(p_rva01) THEN  #FUN-BB0001 add
      #LET l_sql = "SELECT SUM(rvv87*rvv38t) ",                 #CHI-B60099 mark
       LET l_sql = "SELECT SUM(rvv39t) ",                       #CHI-B60099 add
                   "  FROM ",cl_get_target_table(p_plant,'rvv_file'),",",
                   "       ",cl_get_target_table(p_plant,'rvb_file'),",",
                   "       ",cl_get_target_table(p_plant,'rvu_file'),
                   " WHERE rvb01 = '",p_rva01,"'" ,
                   "   AND rvb35 <> 'Y' AND rvv04 = rvb01 ",
                   "   AND rvv05 = rvb02 AND rvv03 = '3' ",
                  #"   AND rvu01 = rvv01 AND rvuconf <> 'X' ",        #MOD-CB0067 mark
                   "   AND rvu01 = rvv01 AND rvuconf = 'Y' ",         #MOD-CB0067 add
                   "   AND (rvb22 = ' ' OR rvb22 IS NULL)"
#FUN-BB0001 add START
    ELSE
       LET l_sql = " SELECT SUM(rvv39t) ",
                   " FROM ",cl_get_target_table(p_plant,'rvv_file'),",",
                   "      ",cl_get_target_table(p_plant,'rvu_file'),
                   " WHERE rvv01 = '",p_rvu01,"'",
                   "   AND rvv25 <> 'Y' ",
                   "   AND rvv03 = '3' ",
                  #"   AND rvu01 = rvv01 AND rvuconf <> 'X' ",        #MOD-CB0067 mark
                   "   AND rvu01 = rvv01 AND rvuconf = 'Y' ",         #MOD-CB0067 add
                   "   AND (rvv22 = ' ' OR rvv22 IS NULL)"
    END IF
#FUN-BB0001 add END
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
    PREPARE sel_rvv87_pre4 FROM l_sql
    EXECUTE sel_rvv87_pre4 INTO l_rvw05f_4
  #FUN-A60056--mod--end
    IF cl_null(l_rvw05f_3) THEN LET l_rvw05f_3 = 0 END IF
    IF cl_null(l_rvw05f_4) THEN LET l_rvw05f_4 = 0 END IF
    LET l_rvw05f = l_rvw05f_3 - l_rvw05f_4     #入庫-驗退or倉退
    IF cl_null(l_rvw05f) THEN LET l_rvw05f = 0 END IF
    IF l_gec07='Y' THEN   #含稅
       LET l_rvw.rvw05f = l_rvw05f / (1 + l_rvw.rvw04 / 100)
    END IF
    LET l_rvw.rvw05f = cl_digcut(l_rvw.rvw05f,t_azi04)
    LET l_rvw05f = cl_digcut(l_rvw05f,t_azi04)
    LET l_rvw.rvw06f = (l_rvw.rvw05f * l_rvw.rvw04 / 100)   #MOD-980235 add
     LET l_rvw.rvw06f = cl_digcut(l_rvw.rvw06f,t_azi04)       #原幣稅額
     LET l_rvw.rvw05  = l_rvw.rvw05f * l_rvw.rvw12
     LET l_rvw.rvw05  = cl_digcut(l_rvw.rvw05,g_azi04)        #本幣未稅
     LET l_rvw.rvw06  = (l_rvw.rvw05 * l_rvw.rvw04 / 100)
     LET l_rvw.rvw06  = cl_digcut(l_rvw.rvw06,g_azi04)        #本幣稅額 
  END IF
  LET l_rvw05f_o = l_rvw.rvw05f    #MOD-810269
 
 
  OPEN WINDOW t114_w AT 7,25 WITH FORM "aap/42f/aapt114"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aapt114")
                         
  INPUT BY NAME l_rvw.rvw01,l_rvw.rvw02,l_rvw.rvw03 ,l_rvw.rvw04,
                l_rvw.rvw11,l_rvw.rvw12,l_rvw.rvw05f,l_rvw.rvw05,
                l_rvw.rvw06f,l_rvw.rvw06 WITHOUT DEFAULTS
     AFTER FIELD rvw01
      IF NOT cl_null(l_rvw.rvw01) THEN 
        LET g_rva05 = ''
       #FUN-A60056--mod--str--
       #SELECT rva05 INTO g_rva05 FROM rva_file WHERE rva01 = p_rva01
        IF NOT cl_null(p_rva01) THEN    #FUN-BB0001 add
           LET l_sql = "SELECT rva05 FROM ",cl_get_target_table(p_plant,'rva_file'),
                       " WHERE rva01 = '",p_rva01,"'"
     #FUN-BB0001 add START
        ELSE
           LET l_sql = " SELECT rvu04 FROM ",cl_get_target_table(p_plant,'rvu_file'),
                       " WHERE rvu01 = '",p_rvu01,"'"
        END IF
     #FUN-BB0001 add END
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
        PREPARE sel_rva05 FROM l_sql 
        EXECUTE sel_rva05 INTO g_rva05
       #FUN-A60056--mod--end
        LET l_cnt = 0
       #FUN-A60056--mod--str--
       #SELECT COUNT(*) INTO l_cnt FROM rvw_file,rva_file,rvb_file
       #   WHERE rvw01 = l_rvw.rvw01 AND
       #         rvb22 = rvw01 AND
       #         rvb01 = rva01 AND
       #         rva05 <> g_rva05
        LET l_sql = "SELECT COUNT(*) FROM rvw_file,",
                     cl_get_target_table(p_plant,'rva_file'),",",
                     cl_get_target_table(p_plant,'rvb_file'),
                    " WHERE rvw01 = '",l_rvw.rvw01,"'" ,
                    "   AND rvb22 = rvw01 AND rvb01 = rva01",
                    "   AND rva05 <> g_rva05"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
        PREPARE sel_cou FROM l_sql
        EXECUTE sel_cou INTO l_cnt 
       #FUN-A60056--mod--end
        IF l_cnt > 0 THEN
           CALL cl_err(l_rvw.rvw01,'apm-435',0)
           NEXT FIELD rvw01
        END IF
        #TQC-B50122 add --start--
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
           IF NOT cl_null(p_rva01) THEN  #FUN-BB0001 add
              SELECT rva06 INTO l_rva06 FROM rva_file WHERE rva01 = p_rva01
       #FUN-BB0001 add START
           ELSE
              SELECT rvu03 INTO l_rva06 FROM rvu_file WHERE rvu01 = p_rvu01
           END IF
       #FUN-BB0001 add END           
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
           IF NOT cl_null(p_rva01) THEN #FUN-BB0001 add
              SELECT rva05 INTO g_rva05 FROM rva_file WHERE rva01 = p_rva01
       #FUN-BB0001 add START
           ELSE
              SELECT rvu04 INTO g_rva05 FROM rvu_file WHERE rvu01 = p_rvu01
           END IF
       #FUN-BB0001 add END 
           CALL t114_invoice_chk(l_rvw.rvw01,l_rvw.rvw02,'',g_rva05,l_rvw.rvw03)   #CHI-820005   Add ,l_rvw.rvw02
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(l_rvw.rvw01,g_errno,0)
              NEXT FIELD rvw01 
           END IF
        END IF
        #TQC-B50122 add --end--
 
        IF l_rvw.rvw01 <> p_guino THEN
           LET p_guino_o = p_guino       #先記錄舊的發票號碼
           LET p_guino=l_rvw.rvw01
        END IF
      END IF
 
     AFTER FIELD rvw02
          CALL s_curr3(l_rvw.rvw11,l_rvw.rvw02,g_apz.apz33) RETURNING l_rvw.rvw12 
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
           CALL cl_err3("sel","gec_file",l_rvw.rvw03,"",STATUS,"","sel gec:",1)  #No.FUN-660122
           NEXT FIELD rvw03
        END IF
        #TQC-B50122 add --start--
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
           IF NOT cl_null(p_rva01) THEN #FUN-BB0001 add 
              SELECT rva06 INTO l_rva06 FROM rva_file WHERE rva01 = p_rva01
        #FUN-BB0001 add START
           ELSE
              SELECT rvu03 INTO l_rva06 FROM rvu_file WHERE rvu01 = p_rvu01
           END IF
        #FUN-BB0001 add END
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
           IF NOT cl_null(p_rva01) THEN #FUN-BB0001 add
              SELECT rva05 INTO g_rva05 FROM rva_file WHERE rva01 = p_rva01
        #FUN-BB0001 add START
           ELSE
              SELECT rvu04 INTO g_rva05 FROM rvu_file WHERE rvu01 = p_rvu01
           END IF
        #FUN-BB0001 add END
           CALL t114_invoice_chk(l_rvw.rvw01,l_rvw.rvw02,'',g_rva05,l_rvw.rvw03)    #CHI-820005   Add ,l_rvw.rvw02
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(l_rvw.rvw01,g_errno,0)
              NEXT FIELD rvw01 
           END IF
        END IF
        #TQC-B50122 add --end--
        DISPLAY BY NAME l_rvw.rvw04
        IF cl_null(l_rvw.rvw05f) OR l_rvw.rvw05f = 0 THEN  #MOD-840070
         #FUN-A60056--mod--str--
         #SELECT SUM(rvv87*rvv38) INTO l_rvw05f_1 FROM rvv_file,rvb_file,rvu_file
         #      WHERE rvb01 = p_rva01 AND rvb35 <> 'Y'
         #        AND rvv04 = rvb01
         #        AND rvv05 = rvb02
         #        AND rvv03 = '1'   #入庫
         #        AND rvu01 = rvv01
         #        AND rvuconf <> 'X'
         #        AND (rvb22 = ' ' OR rvb22 IS NULL)   #MOD-840070
         #SELECT SUM(rvv87*rvv38) INTO l_rvw05f_2 FROM rvv_file,rvb_file,rvu_file
         #      WHERE rvb01 = p_rva01 AND rvb35 <> 'Y'
         #        AND rvv04 = rvb01
         #        AND rvv05 = rvb02
         #       #AND (rvv03 = '2' OR rvv03 = '3')  #驗退、倉退   #MOD-A60005 mark
         #        AND rvv03 = '3'  #倉退                          #MOD-A60005
         #        AND rvu01 = rvv01
         #        AND rvuconf <> 'X'
         #        AND (rvb22 = ' ' OR rvb22 IS NULL)   #MOD-840070
          IF NOT cl_null(p_rva01) THEN     #FUN-BB0001 add
            #LET l_sql = "SELECT SUM(rvv87*rvv38) ",                  #CHI-B60099 mark
             LET l_sql = "SELECT SUM(rvv39) ",                        #CHI-B60099 add
                         "  FROM ",cl_get_target_table(p_plant,'rvv_file'),",",
                         "       ",cl_get_target_table(p_plant,'rvb_file'),",",
                         "       ",cl_get_target_table(p_plant,'rvu_file'),
                         " WHERE rvb01 = '",p_rva01,"'",
                         "   AND rvb35 <> 'Y' AND rvv04 = rvb01 ",
                         "   AND rvv05 = rvb02 AND rvv03 = '1' ",
                         "   AND rvu01 = rvv01 AND rvuconf <> 'X' ",
                         "   AND (rvb22 = ' ' OR rvb22 IS NULL) "
      #FUN-BB0001 add START
          ELSE
             LET l_sql = " SELECT SUM(rvv39) ",
                         " FROM ",cl_get_target_table(p_plant,'rvv_file'),",",
                         "      ",cl_get_target_table(p_plant,'rvu_file'),
                         " WHERE rvv01 = '",p_rvu01,"'",
                         "   AND rvv25 <> 'Y' ",
                         "   AND rvv03 = '1' ",
                         "   AND rvu01 = rvv01 AND rvuconf <> 'X' ",
                         "   AND (rvv22 = ' ' OR rvv22 IS NULL)"
          END IF
      #FUN-BB0001 add END
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
          PREPARE sel_rvv87_pre5 FROM l_sql
          EXECUTE sel_rvv87_pre5 INTO l_rvw05f_1
 
          IF NOT cl_null(p_rva01) THEN   #FUN-BB0001 add
            #LET l_sql = "SELECT SUM(rvv87*rvv38) ",                    #CHI-B60099 mark
             LET l_sql = "SELECT SUM(rvv39) ",                          #CHI-B60099 add
                         "  FROM ",cl_get_target_table(p_plant,'rvv_file'),",",
                         "       ",cl_get_target_table(p_plant,'rvb_file'),",",
                         "       ",cl_get_target_table(p_plant,'rvu_file'),
                         " WHERE rvb01 = '",p_rva01,"' ",
                         "   AND rvb35 <> 'Y' AND rvv04 = rvb01",
                         "   AND rvv05 = rvb02 AND rvv03 = '3'  ",
                         "   AND rvu01 = rvv01 AND rvuconf <> 'X' ",
                         "   AND (rvb22 = ' ' OR rvb22 IS NULL)   "
      #FUN-BB0001 add START
          ELSE
             LET l_sql = " SELECT SUM(rvv39) ",
                         " FROM ",cl_get_target_table(p_plant,'rvv_file'),",",
                         "      ",cl_get_target_table(p_plant,'rvu_file'),
                         " WHERE rvv01 = '",p_rvu01,"'",
                         "   AND rvv25 <> 'Y' ",
                         "   AND rvv03 = '3' ",
                         "   AND rvu01 = rvv01 AND rvuconf <> 'X' ",
                         "   AND (rvv22 = ' ' OR rvv22 IS NULL)"
          END IF
      #FUN-BB0001 add END
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
          PREPARE sel_rvv87_pre6 FROM l_sql
          EXECUTE sel_rvv87_pre6 INTO l_rvw05f_2
         #FUN-A60056--mod--end
          IF cl_null(l_rvw05f_1) THEN LET l_rvw05f_1 = 0 END IF
          IF cl_null(l_rvw05f_2) THEN LET l_rvw05f_2 = 0 END IF
          LET l_rvw.rvw05f = l_rvw05f_1 - l_rvw05f_2     #入庫-驗退or倉退
          IF cl_null(l_rvw.rvw05f) THEN LET l_rvw.rvw05f = 0 END IF
         #FUN-A60056--mod--str--
         #SELECT SUM(rvv87*rvv38t) INTO l_rvw05f_3 FROM rvv_file,rvb_file,rvu_file
         #      WHERE rvb01 = p_rva01 AND rvb35 <> 'Y'
         #        AND rvv04 = rvb01
         #        AND rvv05 = rvb02
         #        AND rvv03 = '1'   #入庫
         #        AND rvu01 = rvv01
         #        AND rvuconf <> 'X'
         #        AND (rvb22 = ' ' OR rvb22 IS NULL)   #MOD-840070
         #SELECT SUM(rvv87*rvv38t) INTO l_rvw05f_4 FROM rvv_file,rvb_file,rvu_file
         #      WHERE rvb01 = p_rva01 AND rvb35 <> 'Y'
         #        AND rvv04 = rvb01
         #        AND rvv05 = rvb02
         #       #AND (rvv03 = '2' OR rvv03 = '3')  #驗退、倉退   #MOD-A60005 mark
         #        AND rvv03 = '3'  #倉退                          #MOD-A60005
         #        AND rvu01 = rvv01
         #        AND rvuconf <> 'X'
         #        AND (rvb22 = ' ' OR rvb22 IS NULL)   #MOD-840070
          IF NOT cl_null(p_rva01) THEN   #FUN-BB0001 add 
            #LET l_sql = "SELECT SUM(rvv87*rvv38t) ",                 #CHI-B60099 mark
             LET l_sql = "SELECT SUM(rvv39t) ",                       #CHI-B60099 add
                         "  FROM ",cl_get_target_table(p_plant,'rvv_file'),",",
                         "       ",cl_get_target_table(p_plant,'rvb_file'),",",
                         "       ",cl_get_target_table(p_plant,'rvu_file'),
                         " WHERE rvb01 = '",p_rva01,"'",
                         "   AND rvb35 <> 'Y' AND rvv04 = rvb01 ",
                         "   AND rvv05 = rvb02 AND rvv03 = '1' ",
                         "   AND rvu01 = rvv01 AND rvuconf <> 'X'",
                         "   AND (rvb22 = ' ' OR rvb22 IS NULL) "
      #FUN-BB0001 add START
         ELSE
            LET l_sql = " SELECT SUM(rvv39t) ",
                        " FROM ",cl_get_target_table(p_plant,'rvv_file'),",",
                        "      ",cl_get_target_table(p_plant,'rvu_file'),
                        " WHERE rvv01 = '",p_rvu01,"'",
                        "   AND rvv25 <> 'Y' ",
                        "   AND rvv03 = '1' ",
                        "   AND rvu01 = rvv01 AND rvuconf <> 'X' ",
                        "   AND (rvv22 = ' ' OR rvv22 IS NULL)"
         END IF
      #FUN-BB0001 add END
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
          PREPARE sel_rvv87_pre7 FROM l_sql
          EXECUTE sel_rvv87_pre7 INTO l_rvw05f_3

          IF NOT cl_null(p_rva01)  THEN  #FUN-BB0001 add 
            #LET l_sql = "SELECT SUM(rvv87*rvv38t) ",                    #CHI-B60099 mark
             LET l_sql = "SELECT SUM(rvv39t) ",                          #CHI-B60099 add
                         "  FROM ",cl_get_target_table(p_plant,'rvv_file'),",",
                         "       ",cl_get_target_table(p_plant,'rvb_file'),",",
                         "       ",cl_get_target_table(p_plant,'rvu_file'),
                         " WHERE rvb01 = '",p_rva01,"' ",
                         "   AND rvb35 <> 'Y' AND rvv04 = rvb01 ",
                         "   AND rvv05 = rvb02 AND rvv03 = '3' ",
                         "   AND rvu01 = rvv01 AND rvuconf <> 'X' ",
                         "   AND (rvb22 = ' ' OR rvb22 IS NULL)"
      #FUN-BB0001 add START
          ELSE
             LET l_sql = " SELECT SUM(rvv39t) ",
                         " FROM ",cl_get_target_table(p_plant,'rvv_file'),",",
                         "      ",cl_get_target_table(p_plant,'rvu_file'),
                         " WHERE rvv01 = '",p_rvu01,"'",
                         "   AND rvv25 <> 'Y' ",
                         "   AND rvv03 = '3' ",
                         "   AND rvu01 = rvv01 AND rvuconf <> 'X' ",
                         "   AND (rvv22 = ' ' OR rvv22 IS NULL)"
          END IF
      #FUN-BB0001 add END
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
          PREPARE sel_rvv87_pre8 FROM l_sql
          EXECUTE sel_rvv87_pre8 INTO l_rvw05f_4
         #FUN-A60056--mod--end
          IF cl_null(l_rvw05f_3) THEN LET l_rvw05f_3 = 0 END IF
          IF cl_null(l_rvw05f_4) THEN LET l_rvw05f_4 = 0 END IF
          LET l_rvw05f = l_rvw05f_3 - l_rvw05f_4     #入庫-驗退or倉退
          IF cl_null(l_rvw05f) THEN LET l_rvw05f = 0 END IF
          IF l_gec07='Y' THEN   #含稅
             LET l_rvw.rvw05f = l_rvw05f / (1 + l_rvw.rvw04 / 100)
          END IF
          LET l_rvw.rvw05f = cl_digcut(l_rvw.rvw05f,t_azi04)
          LET l_rvw05f = cl_digcut(l_rvw05f,t_azi04)
          LET l_rvw.rvw06f = (l_rvw.rvw05f * l_rvw.rvw04 / 100)   #MOD-980235 add
          LET l_rvw05f_o = l_rvw.rvw05f
          LET l_rvw.rvw06f = cl_digcut(l_rvw.rvw06f,t_azi04)       #原幣稅額
          LET l_rvw.rvw05  = l_rvw.rvw05f * l_rvw.rvw12
          LET l_rvw.rvw05  = cl_digcut(l_rvw.rvw05,g_azi04)        #本幣未稅
          LET l_rvw.rvw06  = (l_rvw.rvw05 * l_rvw.rvw04 / 100)
          LET l_rvw.rvw06  = cl_digcut(l_rvw.rvw06,g_azi04)        #本幣稅額
          DISPLAY BY NAME l_rvw.rvw05f
          DISPLAY BY NAME l_rvw.rvw06f
          DISPLAY BY NAME l_rvw.rvw05
          DISPLAY BY NAME l_rvw.rvw06
      ELSE
         LET l_rvw.rvw06  = (l_rvw.rvw05 * l_rvw.rvw04 / 100)
         LET l_rvw.rvw06  = cl_digcut(l_rvw.rvw06,g_azi04)
         LET l_rvw.rvw06f = (l_rvw.rvw05f * l_rvw.rvw04 / 100)
         LET l_rvw.rvw06f = cl_digcut(l_rvw.rvw06f,t_azi04)
         DISPLAY BY NAME l_rvw.rvw06,l_rvw.rvw06f
      END IF   #MOD-840070
 

     AFTER FIELD rvw11
        SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = l_rvw.rvw11
        IF STATUS THEN
           CALL cl_err3("sel","azi_file",l_rvw.rvw11,"","aap-002","","",1)  #No.FUN-660122
           NEXT FIELD rvw11
        ELSE
           CALL s_curr3(l_rvw.rvw11,l_rvw.rvw02,g_apz.apz33) RETURNING l_rvw.rvw12  #FUN-640022
           DISPLAY BY NAME l_rvw.rvw12
        END IF
 
     AFTER FIELD rvw12
        LET l_rvw.rvw05  = l_rvw.rvw05f * l_rvw.rvw12
        LET l_rvw.rvw05  = cl_digcut(l_rvw.rvw05,g_azi04)        #本幣未稅
        LET l_rvw.rvw06  = (l_rvw.rvw05 * l_rvw.rvw04 / 100)
        LET l_rvw.rvw06  = cl_digcut(l_rvw.rvw06,g_azi04)        #本幣稅額
        DISPLAY BY NAME  l_rvw.rvw05,l_rvw.rvw06
 
     AFTER FIELD rvw05f
        IF l_rvw05f_o != l_rvw.rvw05f THEN
           IF l_gec05 = 'T' OR l_gec05 = 'A' THEN
              LET l_rvw.rvw05f = l_rvw.rvw05f / (1 + l_rvw.rvw04/100)
           END IF
           LET l_rvw05f_o = l_rvw.rvw05f   #MOD-810269
           LET l_rvw.rvw05f = cl_digcut(l_rvw.rvw05f,t_azi04)       #原幣未稅
           LET l_rvw.rvw06f = (l_rvw.rvw05f * l_rvw.rvw04 /100)
           LET l_rvw.rvw06f = cl_digcut(l_rvw.rvw06f,t_azi04)       #原幣稅額
           LET l_rvw.rvw05  = l_rvw.rvw05f * l_rvw.rvw12
           LET l_rvw.rvw05  = cl_digcut(l_rvw.rvw05,g_azi04)        #本幣未稅
           LET l_rvw.rvw06  = (l_rvw.rvw05 * l_rvw.rvw04 / 100)
           LET l_rvw.rvw06  = cl_digcut(l_rvw.rvw06,g_azi04)        #本幣稅額 
           DISPLAY BY NAME l_rvw.rvw05f,l_rvw.rvw05,l_rvw.rvw06f,l_rvw.rvw06
        END IF   #MOD-810269
 
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
       #-----MOD-A70126---------
       IF l_rvw.rvw04 = 0 AND (l_rvw.rvw06 > 0 OR l_rvw.rvw06f > 0) THEN
          CALL cl_err('','aap-902',1)
          LET l_rvw.rvw06 = 0
          LET l_rvw.rvw06f = 0
          DISPLAY BY NAME l_rvw.rvw06,l_rvw.rvw06f
          NEXT FIELD rvw06
       END IF 
       #-----END MOD-A70126-----


     ON ACTION controlp                                                         
        CASE                                                                    
           WHEN INFIELD(rvw11) #查詢幣別資料檔                                  
              CALL cl_init_qry_var()                                            
              LET g_qryparam.form ="q_azi"                                      
              LET g_qryparam.default1 = l_rvw.rvw11                             
              CALL cl_create_qry() RETURNING l_rvw.rvw11                        
              DISPLAY BY NAME l_rvw.rvw11                                       
              NEXT FIELD rvw11                                                  
           WHEN INFIELD(rvw03) #查詢稅別資料檔                                  
              CALL cl_init_qry_var()                                            
              LET g_qryparam.form ="q_gec"                                      
              LET g_qryparam.default1 = l_rvw.rvw03                             
              LET g_qryparam.arg1 = '1'                                         
              CALL cl_create_qry() RETURNING l_rvw.rvw03                        
              DISPLAY BY NAME l_rvw.rvw03                                       
              NEXT FIELD rvw03
           WHEN INFIELD(rvw12)
                CALL s_rate(l_rvw.rvw11,l_rvw.rvw12) RETURNING l_rvw.rvw12
                DISPLAY BY NAME l_rvw.rvw12
                NEXT FIELD rvw12
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
  CLOSE WINDOW t114_w
  IF INT_FLAG THEN RETURN l_rvw.rvw01 END IF
  IF cl_null(l_rvw.rvw08)  THEN
     LET l_rvw.rvw08=' '
  END IF
  IF cl_null(l_rvw.rvw09)  THEN
     LET l_rvw.rvw09=0
  END IF
  IF cl_null(l_rvw.rvw08) THEN LET l_rvw.rvw08 = ' ' END IF  #NO.TQC-790003
  LET l_rvw.rvwlegal=g_legal #FUN-980001 add
  UPDATE rvw_file SET * = l_rvw.* WHERE rvw01 = p_guino #no.7295
  IF STATUS THEN 
  CALL cl_err3("upd","rvw_file",p_guino,"",STATUS,"","upd rvw:",1)  #No.FUN-660122
  RETURN l_rvw.rvw01 END IF
  IF SQLCA.SQLERRD[3] = 0 THEN
     #FUN-D10064----add--str
     IF cl_null(l_rvw.rvwacti) THEN
        LET l_rvw.rvwacti='Y'
     END IF
     #FUN-D10064---add---end
     INSERT INTO rvw_file VALUES (l_rvw.*)
     IF STATUS THEN 
     CALL cl_err3("ins","rvw_file",l_rvw.rvw01,l_rvw.rvw08,STATUS,"","ins rvw:",1)  #No.FUN-660122
     RETURN l_rvw.rvw01 END IF
  END IF
  RETURN l_rvw.rvw01
END FUNCTION
#No.FUN-9C0072 精簡程式碼

#TQC-B50122 add --start--
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
#TQC-B50122 add --end--
