# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#{
# Program name...: aws_get_fifo2.4gl
# Descriptions...: 获取调拨fifo建议
# Date & Author..: 2016-06-02 11:59:04 by shenran

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

FUNCTION aws_get_fifo2()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_fifo2_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 

FUNCTION aws_get_fifo2_process()
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
    DEFINE l_imn01 LIKE imn_file.imn01
    DEFINE l_img03 LIKE img_file.img03
    DEFINE l_fifo2    RECORD 
               ibb01  LIKE ibb_file.ibb01,   #料号
               ima02  LIKE ima_file.ima02,   #品名
               imgb03 LIKE imgb_file.imgb03, #规格
               imgb05 LIKE imgb_file.imgb05  #库存单位
                    END RECORD
    
    LET l_imn01 = aws_ttsrv_getParameter("imn01")   #取由呼叫端呼叫時給予的 SQL Condition

    IF cl_null(l_imn01) THEN 
       LET g_status.code=-1
       LET g_status.description="调拨单号不能为空"
       RETURN
    END IF

   LET l_sql=" select a.ibb01,a.ima02,a.imgb03,a.imgb05,a.sumimgb05,a.imn10",
             " from",
             " (select imn03,ima02,",
             " ibb01,ibb06,imgb02,imgb03,substr(ibb01,length(ibb01)-5,6) ,imgb05,imn10,",
             " sum(imgb05) over (PARTITION BY imn03 order by imn03,substr(ibb01,length(ibb01)-5,6),ibb01,imgb03 ) sumimgb05",
             " from imn_file",
             " inner join ibb_file on ibb06=imn03",
             " inner join ima_file on ima01=imn03",
             " inner join imgb_file on imgb01=ibb01 and imgb02=imn04 and imgb05>0",
             " where imn10>0",
             " and imn01='",l_imn01,"'",
             " order by imn03,substr(ibb01,length(ibb01)-5,6) ,ibb01,imgb03)  a",
             " where a.sumimgb05-a.imgb05<=a.imn10"
             #" order by a.ibb01,a.imgb03"

    DECLARE occ_cur CURSOR FROM l_sql
   
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    FOREACH occ_cur INTO l_fifo2.*
       LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_fifo2), "Master")   #加入此筆單檔資料至 Response 中
    
    END FOREACH
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION


