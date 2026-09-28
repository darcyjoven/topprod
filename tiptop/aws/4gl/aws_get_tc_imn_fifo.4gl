# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#{
# Program name...: aws_get_tc_imn_fifo.4gl
# Descriptions...: 单物料指定仓库先进先出
# Date & Author..: 20170508 by nihuan

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

FUNCTION aws_get_tc_imn_fifo()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
    	 CALL aws_get_tc_imn_fifo_d001()

    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION

FUNCTION aws_get_tc_imn_fifo_d001()
  DEFINE l_node  om.DomNode		
	DEFINE l_item_no,l_warehouse_no,l_lot_no  LIKE type_file.chr1000
	DEFINE l_qty                     LIKE type_file.num15_3
	DEFINE l_ima01                   LIKE ima_file.ima01
	DEFINE l_img02                   LIKE img_file.img02
	DEFINE l_success                 LIKE type_file.chr1
	DEFINE l_n                       LIKE type_file.num5
	DEFINE l_tlfb05                  LIKE tlfb_file.tlfb05
	DEFINE l_ogb01                   LIKE ogb_file.ogb01
	DEFINE l_issuing_no              LIKE oga_file.oga01
	DEFINE l_imgb   RECORD
        imgb02      LIKE imgb_file.imgb02,  #仓库
        imgb03      LIKE imgb_file.imgb03,  #储位
        imgb04      LIKE imgb_file.imgb04,  #批号
        imgb05      LIKE imgb_file.imgb05,  #库存
        sumimgb05   LIKE imgb_file.imgb05,  #累计库存
        sfa05c      LIKE imgb_file.imgb05,  #需求量
        sfa05d      LIKE imgb_file.imgb05   #实际数量
       END RECORD
  DEFINE l_statu    RECORD                      #返回
            storage_spaces_no	      	LIKE  type_file.chr100,             #库位
            lot_no                    LIKE  type_file.chr100,             #批号
            item_no	                  LIKE  ima_file.ima01,               #料号          
            recommended_qty	          LIKE  tc_imn_file.tc_imn06,         #建议量   
            scan_sumqty	      	      LIKE  tc_imn_file.tc_imn06          #实发量       
                    END RECORD                                 
  DEFINE l_sql   STRING
  DEFINE l_sql1  STRING
  
  WHENEVER ERROR CONTINUE
    DROP TABLE fifo_file

    CREATE TEMP TABLE fifo_file(
            storage_spaces_no	      	LIKE  type_file.chr100,               #储位编号
            lot_no                    LIKE  type_file.chr100,               #批号    
            item_no	                  LIKE  ima_file.ima01,                 #料号         
            recommended_qty	          LIKE  tc_imn_file.tc_imn06,               #建议量   
            scan_sumqty	      	      LIKE  tc_imn_file.tc_imn06 )               #实发量
    
    LET l_issuing_no   = aws_ttsrv_getParameter("issuing_no")             #单号            
    LET l_warehouse_no = aws_ttsrv_getParameter("warehouse_no")   #传入仓库编号
    LET l_ima01        = aws_ttsrv_getParameter("ima01")
    
    SELECT trim(l_issuing_no) INTO l_issuing_no FROM dual 
    SELECT trim(l_warehouse_no) INTO l_img02 FROM dual 
    
    IF cl_null(l_issuing_no) THEN
    	 LET g_status.code = -1
       LET g_status.description = '单号为空,请检查!'
       RETURN
    END IF
    	
    IF cl_null(l_img02) THEN
    	 LET g_status.code = -1
       LET g_status.description = '仓库编号为空,请检查!'
       RETURN
    END IF	
      
    LET l_n=0 
    SELECT COUNT(*) INTO l_n FROM img_file WHERE img02=l_img02
    IF l_n=0 THEN 
       LET g_status.code = -1
       LET g_status.description = '仓库编号不存在，请重新录入！'     
       RETURN 
    END IF
#    LET l_sql = " select tc_imn01,tc_imn05,sum(tc_imn06)",
#                " from tc_imn_file",
#                " where tc_imn01='",l_issuing_no,"'",
#                " group by tc_imn01,tc_imn05"
#                
#     DECLARE prep_sr CURSOR FROM l_sql
#        
#     FOREACH prep_sr INTO l_ogb01,l_ima01,l_qty
#        CALL aws_shipment_item(l_ogb01,l_ima01) RETURNING l_qty             
#        LET l_tlfb05=0
#
#
#        LET l_sql ="select img03,img04,img01,sum(img10) from img_file
#                    where img01='",l_ima01,"'
#                          and img02='",l_img02,"'
#                          group by img03,img04,img01"
#
#         DECLARE prep_nh CURSOR FROM l_sql
#            
#         FOREACH prep_nh INTO l_statu.* 
#        
#               IF l_statu.recommended_qty>=l_qty THEN 
#                  LET l_statu.recommended_qty=l_qty
#                  INSERT INTO fifo_file VALUES(l_statu.*)
#                  EXIT FOREACH 
#               ELSE 
#               	  LET l_qty=l_qty-l_statu.recommended_qty
#               	  INSERT INTO fifo_file VALUES(l_statu.*)
#               END IF 
#               
#         END FOREACH
#     END FOREACH
      LET l_sql = " SELECT a.imgb02,a.imgb03,a.imgb04,a.imgb05,a.sumimgb05,a.tc_imn11,(CASE WHEN a.tc_imn11 > a.imgb05 THEN imgb05 ELSE a.tc_imn11 - a.sumimgb05 + a.imgb05 END) sfa05d ",
                  "   FROM (SELECT tc_imn03,ibb01,ibb06,imgb02,imgb03,imgb04,imgb05,SUM(tc_imn11) tc_imn11, ",
                  "         SUM(imgb05) over (PARTITION BY tc_imn05 ORDER BY tc_imn05,imgb02,imgb03,imgb04,ibb01 ) sumimgb05 ",
                  "           FROM imn_file ",
                  "           INNER JOIN ibb_file ON ibb06=tc_imn05 ",
                  "           INNER JOIN imgb_file ON imgb01=ibb01 AND imgb02='",l_warehouse_no,"' AND imgb05>0 ",
                  "           INNER JOIN ime_file ON ime01 = imgb02 AND ime02 = imgb03 AND ime05 = 'Y'",
                  "           INNER JOIN imd_file ON imd01 = ime01 AND imd20 = '",g_plant CLIPPED,"'",
                  "          WHERE tc_imn11>0 ",
                  "            AND tc_imn01='",l_issuing_no CLIPPED,"'"#,#界面扫描的调拨单号
                  IF NOT cl_null(l_ima01) THEN
                     LET l_sql = l_sql , " AND tc_imn05 = '",l_ima01 CLIPPED,"' "
                  END IF 
                  LET l_sql = l_sql,
                  "          GROUP BY tc_imn03,tc_imn05,ibb01,ibb06,imgb02,imgb03,imgb04,imgb05 ",
                  "          ORDER BY tc_imn05,imgb04 ,ibb01)  a ",
                  "  WHERE a.sumimgb05-a.imgb05<a.tc_imn11"
                  
#     LET l_sql = " select * from fifo_file",
#                 " order by storage_spaces_no"
     DECLARE prep_fifo CURSOR FROM l_sql
        
     FOREACH prep_fifo INTO l_imgb.*
         LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_imgb), "Master")
     END FOREACH
  
       
END FUNCTION