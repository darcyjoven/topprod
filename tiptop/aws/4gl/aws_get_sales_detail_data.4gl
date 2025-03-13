# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_sales_detail_data.4gl
# Descriptions...: 提供取得 ERP 銷售統計資料服務
# Date & Author..: 2007/06/25 by Mandy
# Memo...........:
# Modify.........: 新建立 FUN-760069
# Modify.........: No.FUN-860037 08/06/20 By Kevin 升級到aws_ttsrv2
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#FUN-760069
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
 
#[
# Description....: 提供取得 ERP 銷售統計資料服務(入口 function)
# Date & Author..: 2007/06/25 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_sales_detail_data()
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 取得ERP銷/退貨明細資料                                                   #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_sales_detail_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 取得ERP銷/退貨明細資料
# Date & Author..: 2007/06/25 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_sales_detail_data_process()
 #----------------------------------------------------------------------------------------------
 #類別  ,日期 ,單據編號,地區別,客戶別,業務人員,產品別,產品編號,品名 ,計價單位,數量  ,本幣金額 
 #fld01 ,fld02,fld03   ,fld04 ,fld05 ,fld06   ,fld07 ,fld08   ,fld09,fld10   ,fld11 ,fld12
 #'出貨',oga02,oga01   ,occ20 ,oga03 ,oga14   ,ima131,ogb04   ,ogb06,ogb916  ,ogb917,ogb14*oga24
 #----------------------------------------------------------------------------------------------
    DEFINE l_fld       RECORD 
              fld01   LIKE type_file.chr20,
              fld02   LikE type_file.dat  ,
              fld03   LIKE oga_file.oga01 ,
              fld04   LIkE occ_file.occ20 ,
              fld05   LIKE oga_file.oga03 ,
              fld06   LIKE oga_file.oga14 ,
              fld07   LIKE ima_file.ima131,      
              fld08   LIKE ogb_file.ogb04 ,
              fld09   LIKE ogb_file.ogb06 ,
              fld10   LIKE ogb_file.ogb916,
              fld11   LIKE ogb_file.ogb917,
              fld12   LIKE type_file.num20_6
           END RECORD 
    DEFINE l_node      om.DomNode
    DEFINE l_sql       STRING
    DEFINE l_wc        STRING
 
    DEFINE l_year       LIKE type_file.num5       #參數現行年
    DEFINE l_month      LIKE type_file.num5       #月份(1~12)
    DEFINE l_oga03      LIKE oga_file.oga03       #客戶別
    DEFINE l_occ20      LIKE occ_file.occ20       #地區別
    DEFINE l_ima131     LIKE ima_file.ima31       #產品別
    DEFINE l_oga14      LIKE oga_file.oga14       #業務員
    DEFINE l_amount_del LIKE type_file.num20_6    #出貨總金額
    DEFINE l_amount_ret LIKE type_file.num20_6    #退貨總金額
 
    #--------------------------------------------------------------------------#
    #依據資料條件(condition),抓取出貨資料                                      #
    #--------------------------------------------------------------------------#
    LET l_year  = aws_ttsrv_getParameter("year")
    LET l_month = aws_ttsrv_getParameter("month")
    LET l_oga03 = aws_ttsrv_getParameter("oga03") 
    LET l_occ20 = aws_ttsrv_getParameter("occ20") 
    LET l_ima131= aws_ttsrv_getParameter("ima131")
    LET l_oga14 = aws_ttsrv_getParameter("oga14")
    #出貨--str------------------------------------------------------
    LET l_wc = ' 1=1'
    IF NOT cl_null(l_month) THEN
       LET l_wc = l_wc CLIPPED," AND MONTH(oga02) = '",l_month,"'"
    END IF
    IF NOT cl_null(l_oga03) THEN
       LET l_wc = l_wc CLIPPED," AND oga03 = '",l_oga03,"'"
    END IF
    IF NOT cl_null(l_occ20) THEN
       LET l_wc = l_wc CLIPPED," AND occ20 = '",l_occ20,"'"
    END IF
    IF NOT cl_null(l_ima131) THEN
       LET l_wc = l_wc CLIPPED," AND ima131 = '",l_ima131,"'"
    END IF
    IF NOT cl_null(l_oga14) THEN
       LET l_wc = l_wc CLIPPED," AND oga14 = '",l_oga14,"'"
    END IF
    LET l_sql = "SELECT '出貨',oga02,oga01,occ20,oga03,oga14,ima131,ogb04,ogb06,ogb916,ogb917,ogb14*oga24 ",
                "  FROM oga_file,occ_file,ogb_file, ",
                " OUTER ima_file ",
                " WHERE ",l_wc CLIPPED,
                "   AND oga09 IN ('2','3','4') ",
                "   AND YEAR(oga02) = '",l_year,"'",
                "   AND occ01       = oga03 ",
                "   AND oga01       = ogb01 ",
                "   AND ima01       = ogb04 ",
                "   AND ogapost     = 'Y' ",
                "   AND ogaconf     = 'Y' ",
                "ORDER BY oga02,oga01,occ20,oga03,oga14,ima131,ogb04 "
 
    DECLARE oga_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    LET l_amount_del = 0
    FOREACH oga_curs INTO l_fld.*
        
        LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_fld), "tmp_file")   #加入此筆單檔資料至 Response 中
        IF cl_null(l_fld.fld12) THEN 
            LET l_fld.fld12 = 0
        END IF
        LET l_amount_del = l_amount_del + l_fld.fld12
    END FOREACH
    #出貨--end------------------------------------------------------
 
    #退貨--str------------------------------------------------------
    LET l_wc = ' 1=1'
    IF NOT cl_null(l_month) THEN
       LET l_wc = l_wc CLIPPED," AND MONTH(oha02) = '",l_month,"'"
    END IF
    IF NOT cl_null(l_oga03) THEN
       LET l_wc = l_wc CLIPPED," AND oha03 = '",l_oga03,"'"
    END IF
    IF NOT cl_null(l_occ20) THEN
       LET l_wc = l_wc CLIPPED," AND occ20 = '",l_occ20,"'"
    END IF
    IF NOT cl_null(l_ima131) THEN
       LET l_wc = l_wc CLIPPED," AND ima131 = '",l_ima131,"'"
    END IF
    IF NOT cl_null(l_oga14) THEN
       LET l_wc = l_wc CLIPPED," AND oha14 = '",l_oga14,"'"
    END IF
    LET l_sql = "SELECT '退貨',oha02,oha01,occ20,oha03,oha14,ima131,ohb04,ohb06,ohb916,ohb917,ohb14*oha24 ",
                "  FROM oha_file,occ_file,ohb_file, ",
                " OUTER ima_file ",
                " WHERE ",l_wc CLIPPED,
                "   AND YEAR(oha02) = '",l_year,"'",
                "   AND occ01       = oha03 ",
                "   AND oha01       = ohb01 ",
                "   AND ima01       = ohb04 ",
                "   AND ohapost     = 'Y' ",
                "   AND ohaconf     = 'Y' ",
                "ORDER BY oha02,oha01,occ20,oha03,oha14,ima131,ohb04 "
 
    DECLARE oha_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    LET l_amount_ret = 0
    FOREACH oha_curs INTO l_fld.*
        
        LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_fld), "tmp_file")   #加入此筆單檔資料至 Response 中
        IF cl_null(l_fld.fld12) THEN 
            LET l_fld.fld12 = 0
        END IF
        LET l_amount_ret = l_amount_ret + l_fld.fld12
        
    END FOREACH
    #退貨--end------------------------------------------------------
    
    #總計--str------------------------------------------------------
     LET l_fld.fld01 = NULL
     LET l_fld.fld02 = NULL
     LET l_fld.fld03 = NULL
     LET l_fld.fld04 = NULL
     LET l_fld.fld05 = NULL
     LET l_fld.fld06 = NULL
     LET l_fld.fld07 = NULL
     LET l_fld.fld08 = NULL
     LET l_fld.fld09 = "總計:"
     LET l_fld.fld10 = NULL
     LET l_fld.fld11 = NULL
     LET l_fld.fld12 = l_amount_del - l_amount_ret
     
     LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_fld), "tmp_file")   #加入此筆單檔資料至 Response 中
    #總計--end------------------------------------------------------
 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION
