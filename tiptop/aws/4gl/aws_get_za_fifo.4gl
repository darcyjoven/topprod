# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#{
# Program name...: aws_get_za_fifo.4gl
# Descriptions...: 杂发先进先出
# Date & Author..: 20180428 by caojf

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

FUNCTION aws_get_za_fifo()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
    	 CALL aws_get_za_fifo_process()

    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION

FUNCTION aws_get_za_fifo_process()
    DEFINE l_node  om.DomNode
    define l_n       like type_file.num5	
	DEFINE l_doc_no  LIKE type_file.chr1000
	DEFINE l_warehouse_no LIKE type_file.chr1000 
	DEFINE l_imgb   RECORD
	    item_no      LIKE ima_file.ima01,    #料号
        imgb02       LIKE imgb_file.imgb02,  #仓库		
        warehouse_no LIKE imgb_file.imgb03,  #库位
        lot_no       LIKE imgb_file.imgb04,  #批号
        imgb05       LIKE imgb_file.imgb05,  #库存
        sumimgb05    LIKE imgb_file.imgb05,  #累计库存
		sfa05c       LIKE imgb_file.imgb05,  #需求量
        suggest_qty  LIKE imgb_file.imgb05   #建议量
                   END RECORD                                
    DEFINE l_sql   STRING

   
    LET l_doc_no   = aws_ttsrv_getParameter("doc_no")             #杂发单号            
    LET l_warehouse_no = aws_ttsrv_getParameter("warehouse_no")   #仓库编号
    
    
    SELECT trim(l_doc_no) INTO l_doc_no FROM dual 
    SELECT trim(l_warehouse_no) INTO l_warehouse_no FROM dual 
    
    IF cl_null(l_doc_no) THEN
       LET g_status.code = -1
       LET g_status.description = '杂发单号为空,请检查!'
       RETURN
    END IF
    	
    IF cl_null(l_warehouse_no) THEN
    	 LET g_status.code = -1
       LET g_status.description = '仓库编号为空,请检查!'
       RETURN
    END IF	
      
    LET l_n=0 
    SELECT COUNT(*) INTO l_n FROM img_file WHERE img02=l_warehouse_no
    IF l_n=0 THEN 
       LET g_status.code = -1
       LET g_status.description = '仓库编号不存在，请重新录入！'     
       RETURN 
    END IF

      LET l_sql = " SELECT a.inb04,a.imgb02,a.imgb03,a.imgb04,a.imgb05,a.sumimgb05,a.inb09,(CASE WHEN a.inb09 > a.imgb05 THEN imgb05 ELSE a.inb09 - a.sumimgb05 + a.imgb05 END) sfa05d ",
                  "   FROM (SELECT inb04,inb01,ibb01,ibb06,imgb02,imgb03,imgb04,imgb05,SUM(inb09) inb09, ",
                  "         SUM(imgb05) over (PARTITION BY inb04 ORDER BY inb04,imgb02,imgb03,imgb04,ibb01 ) sumimgb05 ",
                  "           FROM inb_file ",
                  "           INNER JOIN ibb_file ON ibb06=inb04 ",
                  "           INNER JOIN imgb_file ON imgb01=ibb01 AND imgb02='",l_warehouse_no,"' AND imgb05>0 ",
                  "           INNER JOIN ime_file ON ime01 = imgb02 AND ime02 = imgb03 AND ime05 = 'Y'",
                  "           INNER JOIN imd_file ON imd01 = ime01 AND imd20 = '",g_plant CLIPPED,"'",
                  "          WHERE inb09>0 ",
                  "            AND inb01='",l_doc_no CLIPPED,"'" 
                  LET l_sql = l_sql,
                  "          GROUP BY inb01,inb04,ibb01,ibb06,imgb02,imgb03,imgb04,imgb05 ",
                  "          ORDER BY inb04,imgb04 ,ibb01)  a ",
                  "  WHERE a.sumimgb05-a.imgb05<a.inb09"
                  
     DECLARE prep_fifo CURSOR FROM l_sql 
     IF SQLCA.SQLCODE THEN
          LET g_status.code = SQLCA.SQLCODE
          LET g_status.sqlcode = SQLCA.SQLCODE
          RETURN
     END IF 	 
     FOREACH prep_fifo INTO l_imgb.*
      LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_imgb), "Master")
     END FOREACH
  
       
END FUNCTION