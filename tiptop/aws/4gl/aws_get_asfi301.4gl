# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#{
# Program name...: aws_get_asfi301.4gl
# Descriptions...: 获取工单相应信息
# Date & Author..: 2016-05-31 15:32:03 by shenran

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

FUNCTION aws_get_asfi301()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_asfi301_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 

FUNCTION aws_get_asfi301_process()
    DEFINE l_i     LIKE type_file.num10
    DEFINE l_sfa01 LIKE sfa_file.sfa01
    DEFINE l_node  om.DomNode

   #FUN-B90089 add str---
    DEFINE l_wc    STRING
    DEFINE l_str   STRING
    DEFINE l_end   STRING
    DEFINE l_sql   STRING
    DEFINE l_n     LIKE type_file.num10
    DEFINE l_sfv09 LIKE sfv_file.sfv09
    DEFINE l_ima153 LIKE ima_file.ima153
    DEFINE l_ima01  LIKE ima_file.ima01
    DEFINE l_sfb    RECORD 
               sfb01  LIKE sfb_file.sfb01, #工单号
               sfb08  LIKE sfb_file.sfb08, #工单数量
               sfb05  LIKE sfb_file.sfb05, #成品料件
               sfa03  LIKE sfa_file.sfa03, #下阶料件
               sfa05  LIKE sfa_file.sfa05, #应发数量
               sfa06  LIKE sfa_file.sfa06, #已发数量
               ima02  LIKE ima_file.ima02, #品名
               sfa0506 LIKE sfa_file.sfa05 #欠料量
                    END RECORD
    
    LET l_sfa01 = aws_ttsrv_getParameter("sfa01")   #取由呼叫端呼叫時給予的 SQL Condition


    IF cl_null(l_sfa01) THEN 
       LET g_status.code=-1
       LET g_status.description="工单号不能为空！"
       RETURN
    END IF

    LET l_sql = " SELECT sfb01,sfb08,sfb05,sfa03,sfa05,sfa06,ima02,sfa05-sfa06",
                " FROM sfb_file",
                " inner join sfa_file on sfb01 = sfa01",
                " inner join ima_file on ima01 = sfa03",
                " WHERE sfb01='",l_sfa01,"'"
  
    DECLARE occ_cur CURSOR FROM l_sql
   
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    FOREACH occ_cur INTO l_sfb.*
       LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_sfb), "Master")   #加入此筆單檔資料至 Response 中
    
    END FOREACH
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION
	
