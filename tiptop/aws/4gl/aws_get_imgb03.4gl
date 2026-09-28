# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#{
# Program name...: aws_get_imgb03.4gl
# Descriptions...: 根据库位信息获取料件库存信息
# Date & Author..: 2016/7/4 15:09:28 by shenran

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

FUNCTION aws_get_imgb03()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_imgb03_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 

FUNCTION aws_get_imgb03_process()
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
    DEFINE l_imgb03 LIKE img_file.img03
    DEFINE l_imgb3 RECORD 
               imgb01  LIKE imgb_file.imgb01, #物料条码
               imgb02  LIKE imgb_file.imgb02, #仓库
               imgb05  LIKE imgb_file.imgb05, #数量
               ima02   LIKE ima_file.ima02,#品名
               ima021  LIKE ima_file.ima021,#规格
               ima25   LIKE ima_file.ima25 #库存单位
                    END RECORD
    
    LET l_imgb03 = aws_ttsrv_getParameter("imgb03")   #取由呼叫端呼叫時給予的 SQL Condition

    IF cl_null(l_imgb03) THEN 
       LET g_status.code=-1
       LET g_status.description="库位不能为空"
       RETURN
    END IF

    LET l_sql = "select imgb01,imgb02,imgb05,ima02,ima021,ima25",
                " from imgb_file",
                " inner join ibb_file on ibb01=imgb01",
                " inner join ima_file on ima01=ibb06",
                " where imgb03='",l_imgb03,"'",
                " and imgb05<>0",
                " order by imgb01"

    DECLARE occ_cur CURSOR FROM l_sql
   
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    FOREACH occ_cur INTO l_imgb3.*
       LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_imgb3), "Master")   #加入此筆單檔資料至 Response 中
    
    END FOREACH
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION
	

