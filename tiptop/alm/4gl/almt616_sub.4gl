# Prog. Version..: '5.30.06-13.03.12(00006)'     #
# Pattern name...: almt616_sub.4gl
# Descriptions...: 換卡產生出貨單/單身稅別明細檔/實際交易稅別明細檔 
# Date & Author..: No:FUN-C30176 12/06/15 by pauline
# Modify.........: No:FUN-C80016 12/09/04 by Lori 補FUN-C50097新增ogb_file欄位的預設值
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No:FUN-CC0057 12/12/18 By xumeimei 付款传值20改为23
# Modify.........: No.FUN-CB0087 12/12/24 By xianghui 倉庫單據理由碼改善

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_no                    LIKE lrw_file.lrw01
DEFINE g_oga01                 LIKE oga_file.oga01
DEFINE g_n                     LIKE type_file.num10 

FUNCTION t616_ins_oga(p_no)
DEFINE p_no          LIKE lrw_file.lrw01 
DEFINE l_oga         RECORD LIKE oga_file.*
DEFINE l_rtz06       LIKE rtz_file.rtz06
DEFINE l_occ02       LIKE occ_file.occ02
DEFINE l_occ42       LIKE occ_file.occ42
DEFINE l_occ41       LIKE occ_file.occ41
DEFINE l_occ08       LIKE occ_file.occ08
DEFINE l_occ44       LIKE occ_file.occ44
DEFINE l_occ45       LIKE occ_file.occ45
DEFINE l_occ68       LIKE occ_file.occ68
DEFINE l_occ69       LIKE occ_file.occ69
DEFINE l_occ67       LIKE occ_file.occ67
DEFINE l_occ43       LIKE occ_file.occ43
DEFINE l_occ47       LIKE occ_file.occ47
DEFINE l_occ48       LIKE occ_file.occ48
DEFINE l_occ49       LIKE occ_file.occ49
DEFINE l_occ50       LIKE occ_file.occ50
DEFINE l_occ65       LIKE occ_file.occ65
DEFINE l_occ71       LIKE occ_file.occ71
DEFINE l_gec04       LIKE gec_file.gec04
DEFINE l_gec05       LIKE gec_file.gec05
DEFINE l_gec07       LIKE gec_file.gec07
DEFINE li_result     LIKE type_file.num5
DEFINE l_n           LIKE type_file.num5

   IF cl_null(p_no) THEN 
      LET g_success = 'N'
      RETURN  ''
   END IF
   LET g_no = p_no

   SELECT rtz06 INTO l_rtz06 FROM rtz_file
    WHERE rtz01 = g_plant
   IF cl_null(l_rtz06) THEN
      CALL cl_err('','alm1594',0)
      LET g_success = 'N'
      RETURN ''
   END IF

   SELECT occ02,occ42,occ41,occ08,occ44,occ45,occ68,occ69,occ67,occ43,occ71,occ65
     INTO l_occ02,l_occ42,l_occ41,l_occ08,l_occ44,l_occ45,l_occ68,l_occ69,l_occ67,l_occ43,l_occ71,l_occ65,l_occ65
     FROM occ_file
    WHERE occ01 = l_rtz06

  #CALL t595_sys()  #取系統參數

   LET l_oga.oga00 = '1'                 #出貨別
   LET l_oga.oga02 = g_today             #出貨日期
   LET l_oga.oga06 = '0'                 #修改版本
   LET l_oga.oga07 = 'N'                 #出貨是否計入未開發票的銷貨待驗收入
   LET l_oga.oga08 = '1'                 #1.內銷 2.外銷  3.視同外銷
   LET l_oga.oga09 = '2'                 #單據別
   LET l_oga.oga161 = 0                  #訂金應收比率
   LET l_oga.oga162 = 100                #出貨應收比率   
   LET l_oga.oga163 = 0                  #尾款應收比率
   LET l_oga.oga30 = 'N'                 #包裝單確認碼
   LET l_oga.oga52 = 0                   #原幣預收訂金轉銷貨收入金額
   LET l_oga.oga53 = 0                   #原幣應開發票未稅金額
   LET l_oga.oga54 = 0                   #原幣已開發票未稅金額
   LET l_oga.oga55 = '1'                 #狀況碼
   LET l_oga.oga57 = '1'                 #發票性質
   LET l_oga.oga65 = 'N'                 #客戶出貨簽收否
   LET l_oga.oga69 = g_today             #輸入日期
   LET l_oga.oga83 = g_plant             #銷貨營運中心
   LET l_oga.oga84 = g_plant             #取貨營運中心
   LET l_oga.oga85 = '1'                 #結算方式
   LET l_oga.oga903 = 'N'                #信用查核放行否
   LET l_oga.oga94 = 'N'                 #POS銷售否 Y-是,N-否
   LET l_oga.oga95 = '0'                 #本次積分
   LET l_oga.ogacond = g_today           #審核日期
   LET l_oga.ogaconf = 'N'               #確認否/作廢碼
   LET l_oga.ogagrup = g_user            #資料所有部門
   LET l_oga.ogalegal = g_legal          #所屬法人
   LET l_oga.ogaorig = g_grup            #資料建立部門
   LET l_oga.ogaoriu = g_user            #資料建立者
   LET l_oga.ogaplant = g_plant          #所屬營運中心
   LET l_oga.ogapost = 'N'               #出貨扣帳否
   LET l_oga.ogaprsw = 0                 #列印次數
   LET l_oga.ogauser = g_user            #資料所有者
   LET l_oga.ogaslk02 = '1'
   #帳款客戶編號,arti200 門店對應散客代號
   LET l_oga.oga03 = l_rtz06

   #帳款客戶簡稱        散客代號對應客戶基本資料檔簡稱
   LET l_oga.oga032 = l_occ02
   LET l_oga.oga04 = l_oga.oga03         #送貨客戶編號
   LET l_oga.oga18 = l_oga.oga03         #收款客戶編號 
   #取帳款客戶對應客戶主檔預設稅別,幣別,銷售分類一,價格條件,收款條件
   LET l_oga.oga21 = l_occ41
   LET l_oga.oga23 = l_occ42
   LET l_oga.oga25 = l_occ43
   LET l_oga.oga31 = l_occ44 
   LET l_oga.oga32 = l_occ45 
  
   #取稅別對應稅率,聯數,含稅否
   SELECT gec04,gec05,gec07 INTO l_oga.oga211,l_oga.oga212,l_oga.oga213
     FROM gec_file
    WHERE gec01 = l_oga.oga21
      AND gec011 = '2'

   #匯率
   CALL s_currm(l_oga.oga23,l_oga.oga02,g_oaz.oaz52,g_plant)
     RETURNING l_oga.oga24

   #出貨單號    自動產生出貨單號, 預設單號抓取 aooi410 的設定
   #FUN-C90050 mark begin---
   #SELECT rye03 INTO l_oga.oga01 FROM rye_file
   # WHERE rye01 = 'axm' AND rye02 = '50'
   #FUN-C90050 mark end-----

   CALL s_get_defslip('axm','50',g_plant,'N')  RETURNING l_oga.oga01    #FUN-C90050 add

   CALL s_auto_assign_no("axm",l_oga.oga01,g_today,"","oga_file","oga01","","","")
     RETURNING li_result,l_oga.oga01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN ''
   END IF
   IF cl_null(l_oga.oga01) THEN
      LET g_success='N'
      RETURN ''
   END IF

   LET g_n = 0
   CALL t616_ins_ogb(l_oga.oga01,l_oga.oga211,l_oga.oga213,l_oga.oga23,l_oga.oga21) 
   IF g_n = 0 THEN
      RETURN ''
   END IF
   IF g_success = 'N' THEN
      RETURN ''
   END IF

   SELECT SUM(ogb14) INTO l_oga.oga50 FROM ogb_file
    WHERE ogb01 = l_oga.oga01
   SELECT SUM(ogb14t) INTO l_oga.oga51 FROM ogb_file
    WHERE ogb01 = l_oga.oga01
   INSERT INTO oga_file VALUES l_oga.*
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("ins","oga_file",l_oga.oga01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN ''
   ELSE
      LET g_oga01 = l_oga.oga01
   END IF
   CALL t616_ins_rx(l_oga.oga01)
   IF g_success = 'Y' THEN
      RETURN l_oga.oga01
   ELSE
      RETURN ''
   END IF 
END FUNCTION

FUNCTION t616_ins_ogb(l_oga01,l_gec04,l_gec07,l_azi01,l_oga21)
DEFINE l_oga01   LIKE oga_file.oga01
DEFINE l_gec04   LIKE gec_file.gec04
DEFINE l_gec07   LIKE gec_file.gec07
DEFINE l_azi01   LIKE azi_file.azi01
DEFINE t_azi04   LIKE azi_file.azi04
DEFINE l_oga21   LIKE oga_file.oga21 
DEFINE l_ogb     RECORD LIKE ogb_file.*
DEFINE l_rxc     RECORD LIKE rxc_file.*
DEFINE l_lrw23   LIKE lrw_file.lrw23
DEFINE l_oga14   LIKE oga_file.oga14   #FUN-CB0087
DEFINE l_oga15   LIKE oga_file.oga15   #FUN-CB0087
   SELECT azi04 INTO t_azi04 FROM azi_file
    WHERE azi01= l_azi01

   SELECT lrw23 INTO l_lrw23 FROM lrw_file 
      WHERE lrw01 = g_no
   LET l_ogb.ogb01 = l_oga01            #出貨單號
   LET l_ogb.ogb04 = 'MISCCARD'         #產品編號
   LET l_ogb.ogb05 = 'PCS'              #銷售單位
   LET l_ogb.ogb05_fac = 1              #銷售/庫存彙總單位換算率
   LET l_ogb.ogb08 = g_plant            #出貨營運中心編號
   LET l_ogb.ogb091 = ' '               #出貨儲位編號
   LET l_ogb.ogb092 = ' '               #出貨批號
   LET l_ogb.ogb1005 = '1'              #作業方式
   LET l_ogb.ogb1006 = '100'            #折扣率
   LET l_ogb.ogb1012 = 'N'              #搭贈
   LET l_ogb.ogb1014 = 'N'              #保稅已放行否
   LET l_ogb.ogb12 = '1'                #實際出貨數量
   LET l_ogb.ogb15_fac = 1              #銷售/庫存明細單位換算率
   LET l_ogb.ogb16 = 1                  #數量
   LET l_ogb.ogb17 = 'N'                #多倉儲批出貨否
   LET l_ogb.ogb18 = '0'                #預計出貨數量
   LET l_ogb.ogb19 = 'N'                #檢驗否
   LET l_ogb.ogb44 = '1'                #經營方式
   LET l_ogb.ogb60 = 0                  #已開發票數量
   LET l_ogb.ogb63 = 0                  #銷退數量
   LET l_ogb.ogb64 = 0                  #銷退數量
   LET l_ogb.ogb916 = 'PCS'             #計價單位
   LET l_ogb.ogb917 = 1                 #計價單位
   LET l_ogb.ogblegal = g_legal         #所屬法人
   LET l_ogb.ogbplant = g_plant         #所屬營運中心
   LET l_ogb.ogb50 = 0                  #開票性質         #FUN-C80016
   LET l_ogb.ogb51 = 0                  #已簽退數量       #FUN-C80016
   LET l_ogb.ogb52 = 0                  #簽退數量         #FUN-C80016
   LET l_ogb.ogb53 = 0                                    #FUN-C80016
   LET l_ogb.ogb54 = 0                                    #FUN-C80016
   LET l_ogb.ogb55 = 0                                    #FUN-C80016
   
   #FUN-C90049 mark begin---
   #SELECT rtz07 INTO l_ogb.ogb09 FROM rtz_file
   # WHERE rtz01 = g_plant
   #FUN-C90049 mark end-----

   CALL s_get_coststore(g_plant,l_ogb.ogb04) RETURNING l_ogb.ogb09    #FUN-C90049 add

   IF l_lrw23 >= 0 THEN #TQC-C30009 ad
      SELECT MAX(ogb03)+1 INTO l_ogb.ogb03 FROM ogb_file
       WHERE ogb01 = l_oga01
      IF l_ogb.ogb03 IS NULL THEN
         LET l_ogb.ogb03 = 1       #項次
      END IF
      #原因碼
      SELECT rcj08 INTO l_ogb.ogb1001 FROM rcj_file
      LET l_ogb.ogb13 = l_lrw23    #原幣單價
      IF l_gec07 = 'Y' THEN
         LET l_ogb.ogb14 = l_lrw23 / (1 + l_gec04/100)  #原幣未稅金額
         LET l_ogb.ogb14t = l_lrw23                     #原幣含稅金額
         CALL cl_digcut(l_ogb.ogb14,t_azi04) RETURNING l_ogb.ogb14
      ELSE
         LET l_ogb.ogb14 = l_lrw23
         LET l_ogb.ogb14t = l_lrw23 * (1 + l_gec04/100)
         CALL cl_digcut(l_ogb.ogb14t,t_azi04) RETURNING l_ogb.ogb14t
      END IF
      LET l_ogb.ogb37 = l_lrw23    #基礎單价
      LET l_ogb.ogb47 = 0          #分攤折價=全部折價欄位值的合計
      #FUN-CB0087---add---str---
      IF g_aza.aza115 = 'Y' THEN
         SELECT oga14,oga15 INTO l_oga14,l_oga15 FROM oga_file WHERE oga01 = l_ogb.ogb01
         CALL s_reason_code(l_ogb.ogb01,l_ogb.ogb31,'',l_ogb.ogb04,
                            l_ogb.ogb09,l_oga14,l_oga15) RETURNING l_ogb.ogb1001
         IF cl_null(l_ogb.ogb1001) THEN
            CALL cl_err(l_ogb.ogb1001,'aim-425',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      #FUN-CB0087---add---end---
      INSERT INTO ogb_file VALUES l_ogb.*
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","ogb_file",l_oga01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN ''
      ELSE
         LET g_n = g_n + 1
      END IF
      CALL t616_ins_ogi('1',l_ogb.ogb01,l_ogb.ogb03,l_oga21,l_gec04,l_gec07,l_ogb.ogb12,l_ogb.ogb13)  #TQC-C30223 add  新增單身稅別明細
   END IF

END FUNCTION

#新增單身稅別明細
FUNCTION t616_ins_ogi(p_type,p_ogi01,p_ogi02,p_ogi04,p_ogi05,p_ogi07,p_ogb12,p_ogb13)
DEFINE p_type              LIKE type_file.chr1  #1.售卡  2.儲值
DEFINE p_ogi01             LIKE ogi_file.ogi01  #單號
DEFINE p_ogi02             LIKE ogi_file.ogi02  #項次
DEFINE p_ogi04             LIKE ogi_file.ogi04  #稅別
DEFINE p_ogi05             LIKE ogi_file.ogi05  #稅率
DEFINE p_ogi07             LIKE ogi_file.ogi07  #含稅否
DEFINE p_ogb12             LIKE ogb_file.ogb12  #數量
DEFINE p_ogb13             LIKE ogb_file.ogb13  #原幣單價
DEFINE l_ogi    RECORD     LIKE ogi_file.*
DEFINE l_sql               STRING
DEFINE l_rte08             LIKE rte_file.rte08
DEFINE l_rtz04             LIKE rtz_file.rtz04
DEFINE l_rvy05             LIKE rvy_file.rvy05

   SELECT MAX(ogi03) INTO l_ogi.ogi03 FROM ogi_file
      WHERE ogi01 = l_ogi.ogi01
   IF cl_null(l_ogi.ogi03) OR l_ogi.ogi03 = 0 THEN
      LET l_ogi.ogi03 = 1
   ELSE
      LET l_ogi.ogi03 = l_ogi.ogi03 + 1
   END IF

   LET l_ogi.ogi01 = p_ogi01
   LET l_ogi.ogi02 = p_ogi02
   IF p_type = '1' THEN
      LET l_ogi.ogi04 = p_ogi04
      LET l_ogi.ogi05 = p_ogi05
   ELSE
      SELECT MAX(gec01) INTO l_ogi.ogi04
        FROM gec_file
          WHERE gec06 = '3'
            AND gec011 = '2'
            AND gecacti = 'Y'
      LET l_ogi.ogi05 = 0
   END IF

   LET l_ogi.ogi06 = 0
   LET l_ogi.ogi08 = 0
   LET l_ogi.ogi07 = p_ogi07

   IF p_type = '1' THEN
      IF l_ogi.ogi07 = 'Y' THEN
         LET l_ogi.ogi08t = p_ogb12 * p_ogb13
         LET l_ogi.ogi08 = l_ogi.ogi08t / (1 + l_ogi.ogi05/100)  #原幣未稅金額
         CALL cl_digcut(l_ogi.ogi08,t_azi04) RETURNING l_ogi.ogi08
      ELSE
         LET l_ogi.ogi08  = p_ogb12 * p_ogb13
         LET l_ogi.ogi08t = l_ogi.ogi08 * (1 + l_ogi.ogi05/100)
         CALL cl_digcut(l_ogi.ogi08t,t_azi04) RETURNING l_ogi.ogi08t
      END IF
   ELSE
      LET l_ogi.ogi08t = p_ogb12 * p_ogb13
      LET l_ogi.ogi08  = p_ogb12 * p_ogb13
   END IF

   LET l_ogi.ogi09 = l_ogi.ogi08t - l_ogi.ogi08
   LET l_ogi.ogidate = g_today
   LET l_ogi.ogigrup = g_grup
   LET l_ogi.ogimodu = g_user
   LET l_ogi.ogiuser = g_user
   LET l_ogi.ogioriu = g_user
   LET l_ogi.ogiorig = g_grup
   LET l_ogi.ogiplant = g_plant
   LET l_ogi.ogilegal = g_legal
   INSERT INTO ogi_file VALUES(l_ogi.*)
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','',l_ogi.ogi01,SQLCA.sqlcode,1)
      LET g_success="N"
      RETURN ''
   END IF
END FUNCTION

#新增交款明細/交款匯總檔
FUNCTION t616_ins_rx(l_oga01)
DEFINE l_oga01     LIKE oga_file.oga01
DEFINE l_rxy03_01  RECORD LIKE rxy_file.*
DEFINE l_rxy03_02  RECORD LIKE rxy_file.*
DEFINE l_rxy03_03  RECORD LIKE rxy_file.*
DEFINE l_rxx03_01  RECORD LIKE rxx_file.*
DEFINE l_rxx03_02  RECORD LIKE rxx_file.*
DEFINE l_rxx03_03  RECORD LIKE rxx_file.*
DEFINE l_rxz       RECORD LIKE rxz_file.*
DEFINE l_sql       STRING
   LET l_sql = " SELECT * FROM rxy_file ",
               #"  WHERE rxy00 = '20' AND rxy01 = '",g_no,"' ",   #FUN-CC0057 mark
               "  WHERE rxy00 = '23' AND rxy01 = '",g_no,"' ",    #FUN-CC0057 add
               "    AND rxy03 = '01' AND rxy04 = '1'"
  #SELECT * INTO l_rxy03_01.*
  #  FROM rxy_file
  # WHERE rxy00 = '20'
  #   AND rxy01 = g_no
  #   AND rxy03 = '01'
  #   AND rxy04 = '1'
   PREPARE t616_db FROM l_sql
   DECLARE t616_cdb CURSOR FOR t616_db
   FOREACH t616_cdb INTO l_rxy03_01.* 
      IF NOT cl_null(l_rxy03_01.rxy00) THEN
         LET l_rxy03_01.rxy00 = '02'
         LET l_rxy03_01.rxy01 = l_oga01
         INSERT INTO rxy_file VALUES l_rxy03_01.*
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
            CALL cl_err3("ins","rxy_file",l_oga01,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            RETURN ''
         END IF
      END IF
   END FOREACH
   SELECT * INTO l_rxx03_01.*
     FROM rxx_file
   # WHERE rxx00 = '20'    #FUN-CC0057 mark
    WHERE rxx00 = '23'     #FUN-CC0057 add
      AND rxx01 = g_no
      AND rxx02 = '01'
      AND rxx03 = '1'
   IF NOT cl_null(l_rxx03_01.rxx00) THEN
      LET l_rxx03_01.rxx00 = '02'
      LET l_rxx03_01.rxx01 = l_oga01
      INSERT INTO rxx_file VALUES l_rxx03_01.*
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
         CALL cl_err3("ins","rxx_file",l_oga01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN ''
      END IF
   END IF

END FUNCTION

#FUN-C30176 add
