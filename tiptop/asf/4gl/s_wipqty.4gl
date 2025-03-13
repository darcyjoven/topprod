# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name ..: s_wipqty
# DESCRIPTION....: 在製量的計算
# Parmeter.......: p_no      ->工單號碼
#                  p_item    ->料件編號
#                  p_qpa     ->實際QPA
#                  p_bomitem ->BOM料號
# Date & Autor...: 00/06/02 BY Kammy
# Modify.........: No.MOD-5A0198 05/10/19 By pengu  1.須給l_qty初始值，否則當select不出資料時wip會有誤
# Modify.........: No.MOD-670011 06/07/14 By Claire 1.RUN CARD完工入庫單也要計算QPA值
#                                                   2.傳入工單性質(一般/重工)
# Modify.........: No.FUN-680121 06/09/01 By huchenghao 類型轉換
# Modify.........: No.MOD-8B0152 08/11/14 By sherry 工單在制量沒有將聯產品入庫量和報廢量考慮在內
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A70016 10/07/02 By Sarah 增加傳入BOM料號(sfa27),不然若不同元件替代成同一個料時,在製量是錯的
# Modify.........: No:MOD-A70043 10/07/06 By Sarah 當工單分批完工入庫,會造成報廢數量重複計算
# Modify.........: No:MOD-A70221 10/08/17 By Carrier asfr400的明细资料和s_wipqty的计算量不一致
#                                                    1.下阶报废不算在制 2.上阶报废不影响下阶的数量
# Modify.........: No:MOD-BA0052 12/06/18 By ck2yuan 試產性工單不作是否有取替代資料在sfe_file的檢查
#                                                    aimt303/aimt313報廢應算是入庫

DATABASE ds
GLOBALS "../../config/top.global"
  DEFINE l_wipqty  LIKE sfa_file.sfa04         #No.FUN-680121 DEC(13,3)

#FUNCTION s_wipqty(p_no,p_item,p_qpa)          #MOD-670011 mark
FUNCTION s_wipqty(p_no,p_item,p_qpa,p_chr,p_bomitem)  #MOD-670011 modfiy  #MOD-A70016 add p_bomitem
   DEFINE p_no       LIKE sfb_file.sfb01
   DEFINE p_item     LIKE sfa_file.sfa03
   DEFINE p_qpa      LIKE sfa_file.sfa161
   DEFINE p_chr      LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)#MOD-670011 add
   DEFINE p_bomitem  LIKE sfa_file.sfa27          #MOD-A70016 add
   DEFINE l_qty      LIKE sfa_file.sfa04          #No.FUN-680121 DEC(13,3)
   DEFINE l_sql      LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(300)
   DEFINE l_sfb12    LIKE sfb_file.sfb12          #MOD-8B0152 add
   DEFINE l_sfb02    LIKE sfb_file.sfb02          #MOD-BA0052 add
   DEFINE l_cnt      LIKE type_file.num5          #MOD-A70016 add
   DEFINE sr  RECORD
              tlf01  LIKE tlf_file.tlf01,         #料件編號
              tlf905 LIKE tlf_file.tlf905,        #單據編號
              tlf906 LIKE tlf_file.tlf906,        #單據項次   #MOD-A70016 add
              tlf907 LIKE tlf_file.tlf907,        #入出庫(+-)
              tlf62  LIKE tlf_file.tlf62,         #工單編號
              tlf10  LIKE tlf_file.tlf10,         #異動數量
              tlf13  LIKE tlf_file.tlf13          #異動命令
              END RECORD

   #MOD-8B0152---Begin
   #   #MOD-670011-begin --## 若為重工工單時..發料不計算完工料號的發料只算扣除完工
   #    LET l_sql=''
   #    IF p_chr = 'Y' THEN
   #       LET l_sql = " AND (tlf13 = 'asft6201' OR tlf13 = 'asft6231' ",
   #                   "  OR  tlf13 = 'asft660'  OR tlf13 = 'asft670') "
   #    END IF
   #   #MOD-670011-end

   #LET l_wipqty = 0
   #LET l_sql = " SELECT tlf01,tlf905,tlf907,tlf62,tlf10,tlf13 ",
   #            "   FROM tlf_file ",
   #            "  WHERE tlf01 = '",p_item,"'",
   #            "    AND tlf62 = '",p_no,"'"
   #           , l_sql CLIPPED                    #MOD-670011 add
   LET l_sql=''
   LET l_wipqty = 0
   IF p_chr = 'Y' THEN
      LET l_sql = " SELECT tlf01,tlf905,tlf906,tlf907,tlf62,tlf10,tlf13 ",  #MOD-A70016 add tlf906
                  "   FROM tlf_file ",
                  "  WHERE tlf62 = '",p_no,"'",
                  " AND (tlf13 = 'asft6201' OR tlf13 = 'asft6231' ",
                #asft670为下阶料报废数量,p_chr='Y'为主料的数量统计
                # "  OR  tlf13 = 'asft660'  OR tlf13 = 'asft670') "         #No.MOD-A70221
                  "  OR  tlf13 = 'asft660') "                               #No.MOD-A70221
   ELSE
      LET l_sql = " SELECT tlf01,tlf905,tlf906,tlf907,tlf62,tlf10,tlf13 ",  #MOD-A70016 add tlf906
                  "   FROM tlf_file ",
                  "  WHERE tlf01 = '",p_item,"'",
                  "    AND tlf62 = '",p_no,"'"
   END IF
   #MOD-8B0152---End
   PREPARE tlf_pre FROM l_sql
   DECLARE tlf_cs CURSOR FOR tlf_pre
  #MOD-BA0052 -- begin --
   SELECT sfb02 INTO l_sfb02 FROM sfb_file
    WHERE sfb01 = p_no
  #MOD-BA0052 -- end --
   #No.MOD-A70221  --Begin
   LET l_sfb12 = 0 
   ##str MOD-A70043 mod
   ##移到FOREACH前,以免重複抓取報廢數量
   # SELECT sfb12 INTO l_sfb12 FROM sfb_file WHERE sfb01=p_no        #MOD-8B0152 add
   # IF cl_null(l_sfb12) THEN LET l_sfb12 = 0 END IF                 #MOD-8B0152 add
   ##end MOD-A70043 mod
   #No.MOD-A70221  --End  
   FOREACH tlf_cs INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('tlf_cs',SQLCA.sqlcode,0) EXIT FOREACH
      END IF
      LET l_qty = 0         #No.MOD-5A0198
      #-- 若為工單入庫退回或工單入庫量則需乘上 QPA ----#
      #           入庫為減項，出庫為加項               #
     #str MOD-A70043 mark
     #移到FOREACH前,以免重複抓取報廢數量
     #SELECT sfb12 INTO l_sfb12 FROM sfb_file WHERE sfb01=p_no        #MOD-8B0152 add
     #IF cl_null(l_sfb12) THEN LET l_sfb12 = 0 END IF                 #MOD-8B0152 add
     #end MOD-A70043 mark
      CASE sr.tlf13
        WHEN 'asft6201'
              LET sr.tlf10 = sr.tlf10 + l_sfb12     #MOD-8B0152 add
              LET l_qty = sr.tlf10 * p_qpa * (-1)
              #報廢數量抓一次就好,用完就將變數清空
              LET l_sfb12 = 0   #MOD-A70043 add
        WHEN 'asft6231' LET l_qty = sr.tlf10 * p_qpa * (-1)  #MOD-670011 RUN CAR完工入庫
        WHEN 'asft660'  LET l_qty = sr.tlf10 * p_qpa
        WHEN 'asft670'  LET l_qty = sr.tlf10 * (-1) #報廢
        WHEN 'aimt303'  LET l_qty = sr.tlf10 * (-1)   #MOD-BA0052 add
        WHEN 'aimt313'  LET l_qty = sr.tlf10 * (-1)   #MOD-BA0052 add
        OTHERWISE
           IF l_sfb02 != '15' THEN   #MOD-BA0052 add
            #str MOD-A70016 add
            #若元件有做取替代,需判斷此筆tlf資料是否為該元件的替代料在製量
             LET l_cnt=0
             SELECT COUNT(*) INTO l_cnt FROM sfe_file
              WHERE sfe01=p_no
                AND sfe07=p_item    AND sfe27=p_bomitem
                AND sfe02=sr.tlf905 AND sfe28=sr.tlf906
             IF cl_null(l_cnt) THEN LET l_cnt=0 END IF
             IF l_cnt = 0 THEN CONTINUE FOREACH END IF
            #end MOD-A70016 add
           END IF                    #MOD-BA0052 add
             IF sr.tlf907 = 1 THEN LET l_qty = sr.tlf10 * (-1) END IF
             IF sr.tlf907 =-1 THEN LET l_qty = sr.tlf10 END IF
      END CASE

      LET l_wipqty = l_wipqty + l_qty

   END FOREACH
   RETURN l_wipqty
END FUNCTION
