# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#{
# Program name...: aws_get_asft620.4gl
# Descriptions...: 获取完工入库信息提供给完工入库使用
# Date & Author..: 2016-04-27 14:02:14 shenran

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

FUNCTION aws_get_asft620()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_asft620_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 

FUNCTION aws_get_asft620_process()
    DEFINE l_i     LIKE type_file.num10
    DEFINE l_sfb081 LIKE sfb_file.sfb081
    DEFINE l_sfb39  LIKE sfb_file.sfb39
    DEFINE l_sfu  RECORD 
           sfu02    LIKE sfu_file.sfu02,
           sfu01    LIKE sfu_file.sfu01,
           sfv04    LIKE sfv_file.sfv04,
           ima02    LIKE ima_file.ima02,
           sfv05    LIKE sfv_file.sfv05,
           sfv09    LIKE sfv_file.sfv09,
           sfv09a   LIKE sfv_file.sfv09
                   END RECORD
    DEFINE l_node  om.DomNode

   #FUN-B90089 add str---
    DEFINE l_wc    STRING
    DEFINE l_str   STRING
    DEFINE l_end   STRING
    DEFINE l_sql   STRING
    DEFINE l_sfa01 LIKE sfa_file.sfa01
    DEFINE l_n     LIKE type_file.num10
    DEFINE l_sfv09 LIKE sfv_file.sfv09
    DEFINE l_ima153 LIKE ima_file.ima153
    
    #LET l_sfa01 = aws_ttsrv_getParameter("sfa01")   #取由呼叫端呼叫時給予的 SQL Condition


#    IF cl_null(l_sfa01) THEN 
#       LET g_status.code=-1
#       LET g_status.description="工单号不能为空！"
#       RETURN
#    END IF
     
     LET l_sql=" select sfu02,sfu01,sfv04,ima02,sfv05,sfv09,0",
               " from sfv_file",
               " inner join sfu_file on sfu01=sfv01",
               " inner join ima_file on ima01=sfv04",
               " where sfuconf='Y'",
               " and sfupost='N'",
               " order by sfu02,sfu01"

    DECLARE occ_cur CURSOR FROM l_sql
   
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    FOREACH occ_cur INTO l_sfu.*

       LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_sfu), "Master")   #加入此筆單檔資料至 Response 中

    END FOREACH
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION
	
