# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#{
# Program name...: aws_get_fifo1.4gl
# Descriptions...: 获取发料fifo建议
# Date & Author..: 2016-06-02 11:59:04 by shenran

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

FUNCTION aws_get_fifo1()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_fifo1_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 

FUNCTION aws_get_fifo1_process()
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
    DEFINE l_img03 LIKE img_file.img03
    DEFINE l_fifo1    RECORD 
               ibb01  LIKE ibb_file.ibb01,   #料号
               ima02  LIKE ima_file.ima02,   #品名
               imgb03 LIKE imgb_file.imgb03, #规格
               imgb05 LIKE imgb_file.imgb05  #库存单位
                    END RECORD
    
    LET l_sfa01 = aws_ttsrv_getParameter("sfa01")   #取由呼叫端呼叫時給予的 SQL Condition

    IF cl_null(l_sfa01) THEN 
       LET g_status.code=-1
       LET g_status.description="工单号不能为空"
       RETURN
    END IF

   LET l_sql=" select a.ibb01,a.ima02,a.imgb03,a.imgb05,a.sumimgb05,a.sfa05c",
             " from", 
             " (select sfa03,ima02,",
             " ibb01,ibb06,imgb02,imgb03,substr(ibb01,length(ibb01)-5,6) ,imgb05,(sfa05-sfa06) sfa05c,",
             " sum(imgb05) over (PARTITION BY sfa03 order by sfa03,substr(ibb01,length(ibb01)-5,6),ibb01,imgb03 ) sumimgb05",
             " from sfb_file",
             " inner join sfa_file on sfb01=sfa01",
             " inner join ima_file on ima01=sfa03",
             " inner join ibb_file on ibb06=sfa03",
             " inner join imgb_file on imgb01=ibb01 and imgb05>0",
             " inner join imd_file on imgb02=imd01 and imd10='S'",
             " where sfa05>sfa06", 
             " and sfa01='",l_sfa01,"'",
             " order by sfa03,substr(ibb01,length(ibb01)-5,6) ,ibb01,imgb03) a",
             " where a.sumimgb05-a.imgb05<=a.sfa05c"
             #" order by a.ibb01,a.imgb03"

    DECLARE occ_cur CURSOR FROM l_sql
   
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    FOREACH occ_cur INTO l_fifo1.*
       LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_fifo1), "Master")   #加入此筆單檔資料至 Response 中
    
    END FOREACH
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION


