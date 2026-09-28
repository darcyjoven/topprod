# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#{
# Program name...: aws_get_img.4gl
# Descriptions...: 获取料件库存信息
# Date & Author..: 2016-05-31 15:32:03 by shenran

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

FUNCTION aws_get_img()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_img_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 

FUNCTION aws_get_img_process()
    DEFINE l_i     LIKE type_file.num10
    DEFINE l_cnt   LIKE type_file.num10
    DEFINE l_sfa01 LIKE sfa_file.sfa01
    DEFINE l_node  om.DomNode

   #FUN-B90089 add str---
    DEFINE l_wc    STRING
    DEFINE l_str   STRING
    DEFINE l_end   STRING
    DEFINE l_sql   STRING
    DEFINE l_n     LIKE type_file.num10
    DEFINE l_sfv09 LIKE sfv_file.sfv09
    DEFINE l_img01 LIKE img_file.img01
    DEFINE l_img03 LIKE img_file.img03
    DEFINE l_img    RECORD 
               ima01  LIKE ima_file.ima01, #料号
               ima02  LIKE ima_file.ima02, #品名
               ima021 LIKE ima_file.ima021,#规格
               ima25  LIKE ima_file.ima25, #库存单位
               img02  LIKE img_file.img02, #仓库
               img03  LIKE img_file.img03, #库位
               img10  LIKE img_file.img10  #数量
                    END RECORD
    
    LET l_img01 = aws_ttsrv_getParameter("img01")   #取由呼叫端呼叫時給予的 SQL Condition
    LET l_img03 = aws_ttsrv_getParameter("img03")   #取由呼叫端呼叫時給予的 SQL Condition

    IF cl_null(l_img01) THEN 
       LET g_status.code=-1
       LET g_status.description="料件不能为空"
       RETURN
    END IF

    IF cl_null(l_img03) THEN 
       LET l_sql = " SELECT ima01,ima02,ima021,ima25,imd01,img03,SUM(img10)",
                   " FROM imd_file,img_file",
                   " LEFT JOIN ima_file on ima01 = img01",
                   " WHERE imd01=img02 and imd10<>'I'",
                   " AND img01='",l_img01,"'",
                   " AND img10>0",
                   " GROUP BY ima01,ima02,ima021,ima25,imd01,img03"
    ELSE 
       LET l_sql = " SELECT ima01,ima02,ima021,ima25,imd01,img03,SUM(img10)",
                   " FROM ime_file,img_file",
                   " LEFT JOIN ima_file on ima01 = img01",
                   " LEFT JOIN imd_file on imd01=img02 AND imd10<>'I'",
                   " WHERE ime01=img02",
                   " AND img01='",l_img01,"'",
                   " AND ime01=imd01",
                   " AND ime02='",l_img03,"'",
                   " AND img10>0",
                   " GROUP BY ima01,ima02,ima021,ima25,imd01,img03"	 
    END IF

    DECLARE occ_cur CURSOR FROM l_sql
   
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    FOREACH occ_cur INTO l_img.*
       LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_img), "Master")   #加入此筆單檔資料至 Response 中
    
    END FOREACH
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION
	

