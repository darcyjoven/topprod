# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: aws_get_order_info.4gl
# Descriptions...: 提供查詢訂單信息信息的服務
# Date & Author..: No.FUN-CB0104 12/11/23 by xumm
# Modify.........: No.FUN-D10095 13/01/28 By xumm XML格式调整

DATABASE ds 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

#[
# Description....: 提供查詢訂單信息信息的服務(入口 function)
# Date & Author..: 2012/11/23 by xumeimei
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_get_order_info()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序

    #--------------------------------------------------------------------------#
    # 查詢訂單信息                                                          #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_order_info_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION



#[
# Description....: 依據傳入資訊查詢訂單信息
# Date & Author..: 2012/11/23 by xumeimei
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_get_order_info_process()
    DEFINE l_orderno   STRING,                  #訂單編號
           l_shop      LIKE azw_file.azw01,     #門店編號 
           l_oshop     LIKE azw_file.azw01      #下訂門店
    DEFINE l_node      om.DomNode
    DEFINE l_subnode   om.DomNode
    DEFINE l_subnode1  om.DomNode
    DEFINE l_subnode2  om.DomNode
    DEFINE l_sql       STRING,
           l_cnt       LIKE type_file.num5,
           l_j1,l_j2   LIKE type_file.num5,
           l_j3,l_j4   LIKE type_file.num5,
           l_j5,l_j6   LIKE type_file.num5
    DEFINE l_posdbs    LIKE ryg_file.ryg00
    DEFINE l_db_links  LIKE ryg_file.ryg02
    DEFINE l_shop1     LIKE azw_file.azw01
    DEFINE l_ECSFLG    LIKE type_file.chr1
    DEFINE l_master    RECORD                    #回傳值必須宣告為一個 RECORD 變數  
                       Sale_ID                   LIKE rxu_file.rxu01,
                       Shop                      LIKE type_file.chr10,
                       SaleNO                    LIKE type_file.chr20,
                       VER_NUM                   LIKE type_file.chr20,
                       Machine                   LIKE type_file.chr6,                     
                       Bdate                     LIKE type_file.chr8,
                       SquadNO                   LIKE type_file.num10,
                       OPNO                      LIKE type_file.chr10,
                       CardNO                    LIKE type_file.chr30,
                       POINT_QTY                 LIKE type_file.num20_6,
                       TOT_QTY                   LIKE type_file.num20_6,
                       TOT_AMT                   LIKE type_file.num20_6,
                       TOT_UAMT                  LIKE type_file.num20_6,
                       TYPE                      LIKE type_file.num10,
                       OTYPE                     LIKE type_file.num10,
                       OFNO                      LIKE type_file.chr20,
                       MallType                  LIKE type_file.num10,
                       SDate                     LIKE type_file.chr8,
                       STime                     LIKE type_file.chr6,
                       IsPractice                LIKE type_file.chr1,
                       CNFFLG                    LIKE type_file.chr1,
                       e_ShopID                  LIKE rxu_file.rxu01,
                       e_OPID                    LIKE rxu_file.rxu01,
                       e_MemberID                LIKE rxu_file.rxu01,
                       IsBuffer                  LIKE type_file.chr1,
                       OrderShop                 LIKE type_file.chr10,
                       ContMan                   LIKE type_file.chr10,
                       ContTel                   LIKE type_file.chr20,
                       GetMode                   LIKE type_file.chr1,
                       GetShop                   LIKE type_file.chr10,
                       GDate                     LIKE type_file.chr8,
                       GTime                     LIKE type_file.chr6,
                       ShipAdd                   LIKE type_file.chr100,
                       MEMO                      LIKE type_file.chr1000,
                       PAY_AMT                   LIKE type_file.num20_6,
                       ECSFLG                    LIKE type_file.chr1,
                       ECSDATE                   LIKE type_file.chr8,
                       e_GetShopID               LIKE rxu_file.rxu01
                       END RECORD                                                                  
    DEFINE l_detail1   DYNAMIC ARRAY OF RECORD                                                      
                       Sale_Detail_ID            LIKE rxu_file.rxu01, 
                       Sale_ID                   LIKE rxu_file.rxu01,  
                       Old_ID                    LIKE rxu_file.rxu01,
                       Shop                      LIKE type_file.chr10,
                       SaleNO                    LIKE type_file.chr20,
                       Item                      LIKE type_file.num10,
                       ClerkNO                   LIKE type_file.chr10,
                       ACCNO                     LIKE type_file.chr10,
                       PLUNO                     LIKE rxu_file.rxu01, 
                       FeatureNO                 LIKE rxu_file.rxu01,
                       PLUBarcode                LIKE rxu_file.rxu01,  
                       SCANNO                    LIKE rxu_file.rxu01,
                       CounterNO                 LIKE type_file.chr20,
                       Unit                      LIKE type_file.chr4,
                       OldPrice                  LIKE type_file.num20_6,
                       Price                     LIKE type_file.num20_6,
                       QTY                       LIKE type_file.num20_6,
                       DISC                      LIKE type_file.num20_6,
                       AMT                       LIKE type_file.num20_6,
                       UAMT                      LIKE type_file.num20_6,
                       POINT_QTY                 LIKE type_file.num20_6,
                       MNO                       LIKE type_file.chr20,
                       OItem                     LIKE type_file.num10,
                       SDATE                     LIKE type_file.chr8,
                       STIME                     LIKE type_file.chr6,
                       CNFFLG                    LIKE type_file.chr1,
                       e_ShopID                  LIKE rxu_file.rxu01, 
                       e_ClerkID                 LIKE rxu_file.rxu01,
                       e_OPID                    LIKE rxu_file.rxu01,
                       e_PLUID                   LIKE rxu_file.rxu01,
                       e_FeatureID               LIKE rxu_file.rxu01,
                       e_CounterID               LIKE rxu_file.rxu01,
                       e_UnitID                  LIKE rxu_file.rxu01,
                       e_MNOID                   LIKE rxu_file.rxu01,
                       RQTY                      LIKE type_file.num20_6,
                       MEMO                      LIKE type_file.chr1000,
                       Price2                    LIKE type_file.num20_6,
                       Price3                    LIKE type_file.num20_6
                       END RECORD                                                                     
    DEFINE l_detail2   DYNAMIC ARRAY OF RECORD                                 
                       Sale_Detail_Agio_ID       LIKE rxu_file.rxu01, 
                       Sale_Detail_ID            LIKE rxu_file.rxu01,
                       Shop                      LIKE type_file.chr10,
                       SaleNO                    LIKE type_file.chr20,
                       MItem                     LIKE type_file.num10,
                       Item                      LIKE type_file.num10,
                       QTY                       LIKE type_file.num20_6,
                       AMT                       LIKE type_file.num20_6,
                       InputDisc                 LIKE type_file.num20_6,
                       DISC                      LIKE type_file.num20_6,
                       DCTYPE                    LIKE type_file.num10,
                       PMTNO                     LIKE type_file.chr20,
                       CNFFLG                    LIKE type_file.chr1,
                       e_ShopID                  LIKE rxu_file.rxu01,
                       e_GiftID                  LIKE rxu_file.rxu01,
                       e_PMTID                   LIKE rxu_file.rxu01
                       END RECORD                                                                     
    DEFINE l_detail3   DYNAMIC ARRAY OF RECORD                                                        
                       Sale_Pay_ID               LIKE rxu_file.rxu01, 
                       Sale_ID                   LIKE rxu_file.rxu01,
                       Shop                      LIKE type_file.chr10,
                       SaleNO                    LIKE type_file.chr20,
                       Item                      LIKE type_file.num10,
                       PayCode                   LIKE type_file.chr10,
                       PayCodeERP                LIKE type_file.chr10,
                       CTType                    LIKE type_file.chr10,
                       PAYSERNUM                 LIKE type_file.chr20,
                       SerialNO                  LIKE type_file.chr20,
                       DEScore                   LIKE type_file.num20_6,
                       PAY                       LIKE type_file.num20_6,
                       EXTRA                     LIKE type_file.num20_6,
                       CHANGED                   LIKE type_file.num20_6,
                       SDate                     LIKE type_file.chr8,
                       STime                     LIKE type_file.chr6,
                       Isverification            LIKE type_file.chr1,
                       IsOrderPay                LIKE type_file.chr1,
                       ReturnRate                LIKE type_file.num10,
                       CNFFLG                    LIKE type_file.chr1,
                       e_ShopID                  LIKE rxu_file.rxu01, 
                       e_PayID                   LIKE rxu_file.rxu01,
                       e_CTTypeID                LIKE rxu_file.rxu01
                       END RECORD                                                  
    DEFINE l_detail4   DYNAMIC ARRAY OF RECORD                                                        
                       Sale_Pay_Detail_ID        LIKE rxu_file.rxu01, 
                       Sale_ID                   LIKE rxu_file.rxu01,
                       Sale_Pay_ID               LIKE rxu_file.rxu01,
                       Sale_Detail_ID            LIKE rxu_file.rxu01,
                       Shop                      LIKE type_file.chr10,
                       SaleNO                    LIKE type_file.chr20,
                       MItem                     LIKE type_file.num10,
                       Item                      LIKE type_file.num10,
                       PayCode                   LIKE type_file.chr10,
                       PayCodeERP                LIKE type_file.chr10,
                       CTType                    LIKE type_file.chr10,
                       PAYSERNUM                 LIKE type_file.chr20,
                       DEScore                   LIKE type_file.num20_6,
                       PAY                       LIKE type_file.num20_6,
                       SDATE                     LIKE type_file.chr8,
                       STime                     LIKE type_file.chr6,
                       Isverification            LIKE type_file.chr1,
                       CNFFLG                    LIKE type_file.chr1,
                       e_ShopID                  LIKE rxu_file.rxu01, 
                       e_PayID                   LIKE rxu_file.rxu01,
                       e_CTTypeID                LIKE rxu_file.rxu01
                       END RECORD                                                         
    DEFINE l_detail5   DYNAMIC ARRAY OF RECORD                                                        
                       Shop                      LIKE type_file.chr10,
                       Sale_TaxMaster_ID         LIKE rxu_file.rxu01, 
                       Sale_ID                   LIKE rxu_file.rxu01,
                       SaleNo                    LIKE type_file.chr20,
                       BDate                     LIKE type_file.chr8,
                       Item                      LIKE type_file.num10,
                       TaxCode                   LIKE type_file.chr6,
                       TaxRate                   LIKE type_file.num20_6,
                       InclTax                   LIKE type_file.chr1,
                       Amt                       LIKE type_file.num20_6,
                       Uamt                      LIKE type_file.num20_6,
                       Tax                       LIKE type_file.num20_6,
                       AccTax                    LIKE type_file.num20_6
                       END RECORD                                                        
    DEFINE l_detail6   DYNAMIC ARRAY OF RECORD                                                        
                       Shop                      LIKE type_file.chr10,
                       Sale_Detail_TaxDetail_ID  LIKE rxu_file.rxu01, 
                       Sale_Detail_ID            LIKE rxu_file.rxu01,
                       Sale_ID                   LIKE rxu_file.rxu01,
                       SaleNo                    LIKE type_file.chr20,
                       BDate                     LIKE type_file.chr8,
                       Mitem                     LIKE type_file.num10,
                       Item                      LIKE type_file.num10,
                       TaxCode                   LIKE type_file.chr6,
                       TaxRate                   LIKE type_file.num20_6,
                       InclTax                   LIKE type_file.chr1,
                       Amt                       LIKE type_file.num20_6,
                       Uamt                      LIKE type_file.num20_6,
                       Tax                       LIKE type_file.num20_6
                       END RECORD          
    DEFINE l_node1     om.DomNode                #FUN-D10095 Add
                                           
    #取得各項參數
   #FUN-D10095 Mark&Add Begin ---
   #LET l_orderno = aws_ttsrv_getParameter("OrderNO") 
   #LET l_shop = aws_ttsrv_getParameter("Shop")
   #LET l_oshop = aws_ttsrv_getParameter("OrderShop")
    LET l_node1 = aws_ttsrv_getTreeMasterRecord(1,"GetOrderInfo")
    LET l_orderno = aws_ttsrv_getRecordField(l_node1,"OrderNO")
    LET l_shop = aws_ttsrv_getRecordField(l_node1,"Shop")
    LET l_oshop = aws_ttsrv_getRecordField(l_node1,"OrderShop")
   #FUN-D10095 Mark&Add End -----
    #調用基本的檢查
    IF aws_pos_check() = 'N' THEN 
       RETURN 
    END IF 

    SELECT DISTINCT ryg00,ryg02 INTO l_posdbs,l_db_links FROM ryg_file WHERE ryg00 = 'ds_pos1'
    LET l_posdbs = s_dbstring(l_posdbs)
    LET l_db_links = aws_get_dblinks(l_db_links)
    #訂單相關信息檢查
    LET l_sql = " SELECT SHOP,ECSFLG FROM ",l_posdbs,"td_Sale",l_db_links,
                "  WHERE SaleNO = '",l_orderno,"'",
                "    AND SHOP = '",l_oshop,"'",
                "    AND TYPE = '3'"
    PREPARE sel_shop_cs FROM l_sql
    EXECUTE sel_shop_cs INTO l_shop1,l_ECSFLG
    IF SQLCA.sqlcode AND SQLCA.sqlcode <> 100 THEN
       LET g_status.sqlcode = sqlca.sqlcode
       LET g_status.code = sqlca.sqlcode
       RETURN
    END IF
    IF SQLCA.sqlcode = 100 THEN
       #訂單號不存在
       CALL aws_pos_get_code('aws-924',l_orderno,NULL,NULL)
       RETURN
    END IF
    IF l_shop1 <> l_oshop THEN
       #下訂門店沒有此訂單號
       CALL aws_pos_get_code('aws-925',l_orderno,NULL,NULL)
       RETURN
    END IF
    IF l_ECSFLG = 'Y' THEN
       #訂單已結案
       CALL aws_pos_get_code('aws-926',l_orderno,NULL,NULL)
       RETURN
    END IF
    #查詢訂單信息
    TRY 
       LET l_sql = " SELECT CAST(Sale_ID AS VARCHAR2(40)),Shop,SaleNO,VER_NUM,Machine,",
                   "        Bdate,SquadNO,OPNO,CardNO,POINT_QTY,",
                   "        TOT_QTY,TOT_AMT,TOT_UAMT,TYPE,OTYPE,",
                   "        OFNO,MallType,SDate,STime,IsPractice,",
                   "        CNFFLG,CAST(e_ShopID AS VARCHAR2(40)),CAST(e_OPID AS VARCHAR2(40)),CAST(e_MemberID AS VARCHAR2(40)),IsBuffer,",
                   "        OrderShop,ContMan,ContTel,GetMode,GetShop,",
                   "        GDate,GTime,ShipAdd,MEMO,PAY_AMT,",
                   "        ECSFLG,ECSDATE,CAST(e_GetShopID AS VARCHAR2(40))",
                   "   FROM ",l_posdbs,"td_Sale",l_db_links,                         #td_Sale交易单主表
                   "  WHERE SaleNO = '",l_orderno,"'",
                   "    AND SHOP = '",l_oshop,"'",
                   "    AND TYPE = '3'"
       PREPARE sel_td_sale_curs FROM l_sql
       EXECUTE sel_td_sale_curs INTO l_master.*
          IF sqlca.sqlcode THEN
             LET g_status.sqlcode = sqlca.sqlcode
             LET g_status.code = sqlca.sqlcode
             RETURN
          END IF 
          #加入此筆單頭資料至 Response 中
          LET l_node = aws_ttsrv_addTreeMaster(base.TypeInfo.create(l_master), "td_Sale") 
          #加入 [單身 1] 資料至 <Detail1> 中
          CALL l_detail1.clear()
          LET l_j1 = 1
          LET l_sql = " SELECT CAST(Sale_Detail_ID AS VARCHAR2(40)),CAST(Sale_ID AS VARCHAR2(40)),CAST(Old_ID AS VARCHAR2(40)),Shop,SaleNO,",
                      "        Item,ClerkNO,ACCNO,CAST(PLUNO AS VARCHAR2(40)),CAST(FeatureNO AS VARCHAR2(40)),",
                      "        CAST(PLUBarcode AS VARCHAR2(40)),CAST(SCANNO AS VARCHAR2(40)),CounterNO,Unit,OldPrice,",
                      "        Price,QTY,DISC,AMT,UAMT,",
                      "        POINT_QTY,MNO,OItem,SDATE,STIME,",
                      "        CNFFLG,CAST(e_ShopID AS VARCHAR2(40)),CAST(e_ClerkID AS VARCHAR2(40)),CAST(e_OPID AS VARCHAR2(40)),CAST(e_PLUID AS VARCHAR2(40)),",  
                      "        CAST(e_FeatureID AS VARCHAR2(40)),CAST(e_CounterID AS VARCHAR2(40)),CAST(e_UnitID AS VARCHAR2(40)),",
                      "        CAST(e_MNOID AS VARCHAR2(40)),RQTY,MEMO,Price2,Price3",
                      "   FROM ",l_posdbs,"td_Sale_Detail",l_db_links,              #td_Sale_Detail交易单明细文件
                      "  WHERE SaleNO = '",l_orderno,"'",
                      "    AND Shop = '",l_oshop,"'"
          DECLARE sel_td_sale_detail_curs CURSOR FROM l_sql
          FOREACH sel_td_sale_detail_curs INTO l_detail1[l_j1].*
             IF sqlca.sqlcode THEN
                LET g_status.sqlcode = sqlca.sqlcode
                LET g_status.code = sqlca.sqlcode
                EXIT FOREACH 
             END IF 
             LET l_subnode = aws_ttsrv_addTreeDetail(l_node, base.TypeInfo.create(l_detail1[l_j1]), "td_Sale_Detail" , "1" , l_j1 )

             #加入 [子單身 1] 資料至 <Detail2> 中
             CALL l_detail2.clear()
             LET l_j2 = 1
             LET l_sql = " SELECT CAST(Sale_Detail_Agio_ID AS VARCHAR2(40)),CAST(Sale_Detail_ID AS VARCHAR2(40)),Shop,SaleNO,MItem,",
                         "        Item,QTY,AMT,InputDisc,DISC,",
                         "        DCTYPE,PMTNO,CNFFLG,CAST(e_ShopID AS VARCHAR2(40)),CAST(e_GiftID AS VARCHAR2(40)),",
                         "        CAST(e_PMTID AS VARCHAR2(40)) ",
                         "   FROM ",l_posdbs,"td_Sale_Detail_Agio",l_db_links,       #td_Sale_Detail_Agio交易折扣明细文件
                         "  WHERE SaleNO = '",l_orderno,"'",
                         "    AND Shop = '",l_oshop,"'",
                         "    AND CAST(Sale_Detail_ID AS VARCHAR2(40)) = '",l_detail1[l_j1].Sale_Detail_ID,"'"
             DECLARE sel_td_sale_detail_agio_curs CURSOR FROM l_sql
             FOREACH sel_td_sale_detail_agio_curs INTO l_detail2[l_j2].*
                IF sqlca.sqlcode THEN
                   LET g_status.sqlcode = sqlca.sqlcode
                   LET g_status.code = sqlca.sqlcode
                   EXIT FOREACH 
                END IF 
                LET l_subnode1 = aws_ttsrv_addTreeDetail(l_subnode, base.TypeInfo.create(l_detail2[l_j2]), "td_Sale_Detail_Agio" , "1" , l_j2 )
                LET l_j2 = l_j2+1
             END FOREACH
             CALL l_detail2.deleteElement(l_j2)

             #加入 [子單身 2] 資料至 <Detail6> 中
             CALL l_detail6.clear()
             LET l_j6 = 1
             LET l_sql = " SELECT Shop,CAST(Sale_Detail_TaxDetail_ID AS VARCHAR2(40)),CAST(Sale_Detail_ID AS VARCHAR2(40)),",
                         "        CAST(Sale_ID AS VARCHAR2(40)),SaleNo,BDate,Mitem,Item,",
                         "        TaxCode,TaxRate,InclTax,Amt,Uamt,Tax ",
                         "   FROM ",l_posdbs,"td_Sale_Detail_TaxDetail",l_db_links,   #td_Sale_Detail_TaxDetail交易稅別明細檔
                         "  WHERE SaleNO = '",l_orderno,"'",
                         "    AND Shop = '",l_oshop,"'",
                         "    AND CAST(Sale_Detail_ID AS VARCHAR2(40)) = '",l_detail1[l_j1].Sale_Detail_ID,"'"
             DECLARE sel_td_Sale_Detail_TaxDetail_curs CURSOR FROM l_sql
             FOREACH sel_td_Sale_Detail_TaxDetail_curs INTO l_detail6[l_j6].*
                IF sqlca.sqlcode THEN
                   LET g_status.sqlcode = sqlca.sqlcode
                   LET g_status.code = sqlca.sqlcode
                   EXIT FOREACH
                END IF
                LET l_subnode2 = aws_ttsrv_addTreeDetail(l_subnode, base.TypeInfo.create(l_detail6[l_j6]), "td_Sale_Detail_TaxDetail" , "2" , l_j6 )
                LET l_j6 = l_j6+1
             END FOREACH
             CALL l_detail6.deleteElement(l_j6)
             LET l_j1 = l_j1+1
          END FOREACH  
          CALL l_detail1.deleteElement(l_j1)

          #加入 [單身 2] 資料至 <Detail3> 中
          CALL l_detail3.clear()
          LET l_j3 = 1
          LET l_sql = " SELECT CAST(Sale_Pay_ID AS VARCHAR2(40)),CAST(Sale_ID AS VARCHAR2(40)),Shop,SaleNO,Item,",
                      "        PayCode,PayCodeERP,CTType,PAYSERNUM,SerialNO,",
                      "        DEScore,PAY,EXTRA,CHANGED,SDate,",
                      "        STime,Isverification,IsOrderPay,ReturnRate,CNFFLG,CAST(e_ShopID AS VARCHAR2(40)),CAST(e_PayID AS VARCHAR2(40)),",                                             
                      "        CAST(e_CTTypeID AS VARCHAR2(40)) ",
                      "   FROM ",l_posdbs,"td_Sale_Pay",l_db_links,                  #td_Sale_Pay交易收款主表
                      "  WHERE SaleNO = '",l_orderno,"'",
                      "    AND Shop = '",l_oshop,"'"
          DECLARE sel_td_sale_pay_curs CURSOR FROM l_sql
          FOREACH sel_td_sale_pay_curs INTO l_detail3[l_j3].*
             IF sqlca.sqlcode THEN
                LET g_status.sqlcode = sqlca.sqlcode
                LET g_status.code = sqlca.sqlcode
                EXIT FOREACH 
             END IF 
             LET l_subnode = aws_ttsrv_addTreeDetail(l_node, base.TypeInfo.create(l_detail3[l_j3]), "td_Sale_Pay" , "2" , l_j3 )
             LET l_j3 = l_j3+1
          END FOREACH
          CALL l_detail3.deleteElement(l_j3)

          #加入 [單身 3] 資料至 <Detail4> 中
          CALL l_detail4.clear()
          LET l_j4 = 1
          LET l_sql = " SELECT CAST(Sale_Pay_Detail_ID AS VARCHAR2(40)),CAST(Sale_ID AS VARCHAR2(40)),CAST(Sale_Pay_ID AS VARCHAR2(40)),",
                      "        CAST(Sale_Detail_ID AS VARCHAR2(40)),Shop,SaleNO,MItem,Item,",
                      "        PayCode,PayCodeERP,CTType,PAYSERNUM,DEScore,",
                      "        PAY,SDATE,STime,Isverification,CNFFLG,",
                      "        CAST(e_ShopID AS VARCHAR2(40)),CAST(e_PayID AS VARCHAR2(40)),CAST(e_CTTypeID AS VARCHAR2(40))",
                      "   FROM ",l_posdbs,"td_Sale_Pay_Detail",l_db_links,        #td_Sale_Pay_Detail交易收款明细表
                      "  WHERE SaleNO = '",l_orderno,"'",
                      "    AND Shop = '",l_oshop,"'"
          DECLARE sel_td_sale_pay_detail_curs CURSOR FROM l_sql
          FOREACH sel_td_sale_pay_detail_curs INTO l_detail4[l_j4].*
             IF sqlca.sqlcode THEN
                LET g_status.sqlcode = sqlca.sqlcode
                LET g_status.code = sqlca.sqlcode
                EXIT FOREACH 
             END IF 
             LET l_subnode = aws_ttsrv_addTreeDetail(l_node, base.TypeInfo.create(l_detail4[l_j4]), "td_Sale_Pay_Detail" , "3" , l_j4 )
             LET l_j4 = l_j4+1
          END FOREACH
          CALL l_detail4.deleteElement(l_j4)

          #加入 [單身 4] 資料至 <Detail5> 中
          CALL l_detail5.clear()
          LET l_j5 = 1
          LET l_sql = " SELECT Shop,CAST(Sale_TaxMaster_ID AS VARCHAR2(40)),CAST(Sale_ID AS VARCHAR2(40)),SaleNo,BDate,",
                      "        Item,TaxCode,TaxRate,InclTax,Amt,",
                      "        Uamt,Tax,AccTax",
                      "   FROM ",l_posdbs,"td_Sale_TaxMaster",l_db_links,            #td_Sale_TaxMaster交易單主檔實際稅額檔
                      "  WHERE SaleNO = '",l_orderno,"'",
                      "    AND Shop = '",l_oshop,"'"
          DECLARE sel_td_sale_taxmaster_curs CURSOR FROM l_sql
          FOREACH sel_td_sale_taxmaster_curs INTO l_detail5[l_j5].*
             IF sqlca.sqlcode THEN
                LET g_status.sqlcode = sqlca.sqlcode
                LET g_status.code = sqlca.sqlcode
                EXIT FOREACH 
             END IF 
             LET l_subnode = aws_ttsrv_addTreeDetail(l_node, base.TypeInfo.create(l_detail5[l_j5]), "td_Sale_TaxMaster" , "4" , l_j5 )
             LET l_j5 = l_j5+1
          END FOREACH  
          CALL l_detail5.deleteElement(l_j5)
   CATCH 
      IF sqlca.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
      END IF 
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
   END TRY 

END FUNCTION 

FUNCTION aws_get_dblinks(l_db_links)
DEFINE l_db_links LIKE ryg_file.ryg02

  IF l_db_links IS NULL OR l_db_links = ' ' THEN
     RETURN ' '
  ELSE
     LET l_db_links = '@',l_db_links CLIPPED
     RETURN l_db_links
  END IF

END FUNCTION
#No.FUN-CB0104
