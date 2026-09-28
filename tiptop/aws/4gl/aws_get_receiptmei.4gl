#{
# Program name...: aws_get_receiptmei.4gl
# Descriptions...: 提供取得ERP收货单资料信息
# Date & Author..: 2016/4/19 16:42:42 shenran
# Memo...........:
#
#}



DATABASE ds
 
GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv_global.4gl" 

FUNCTION aws_get_receiptmei()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()                                                        
    
    IF g_status.code = "0" THEN
       CALL aws_get_receiptmei_process()        #提供取得ERP收货 单资料服务
    END IF
 
    CALL aws_ttsrv_postprocess()        
END FUNCTION


FUNCTION aws_get_receiptmei_process()
    DEFINE l_i     LIKE type_file.num10
    DEFINE l_rvb    RECORD 
                      rvb01   LIKE rvb_file.rvb01,     #收货单号
                      rvb02   LIKE rvb_file.rvb02,     #收货项次
                      rvb05   LIKE rvb_file.rvb05,     #料件编号
                      ima02   LIKE ima_file.ima02,     #料件名称
                      rvb07   LIKE rvb_file.rvb07,     #可入库量
                      rvb07a  LIKE rvb_file.rvb07,     #入库数量
                      rva06   LIKE rva_file.rva06,     #收货日期
                      ima35   LIKE ima_file.ima35,     #仓库
                      pmc03   LIKE pmc_file.pmc03      #供应商名称
                   END RECORD
    DEFINE l_rvba   RECORD 
                      rvb01   LIKE rvb_file.rvb01,     #收货单号
                      rvb02   LIKE rvb_file.rvb02,     #收货项次
                      rvb05   LIKE rvb_file.rvb05,     #料件编号
                      ima02   LIKE ima_file.ima02,     #料件名称
                      rvb07   LIKE rvb_file.rvb07,     #可入库量
                      rvb07a  LIKE rvb_file.rvb07,     #入库数量
                      rva06   LIKE rva_file.rva06,     #收货日期
                      ima35   LIKE ima_file.ima35,     #仓库
                      pmc03   LIKE pmc_file.pmc03      #供应商名称
                   END RECORD      
    DEFINE l_num INTEGER,
    			 l_in     LIKE rvv_file.rvv17,               #入库数量
    			 l_out    LIKE rvv_file.rvv17,               #验退数量
    			 g_in     LIKE rvv_file.rvv17,               #允许入库量
    			 l_ibb03  LIKE ibb_file.ibb03,               #来源单号
    			 l_qcs091 LIKE qcs_file.qcs091,              #合格量
    			 l_rvb33  LIKE rvb_file.rvb33,
    			 l_rvb39  LIKE rvb_file.rvb39 

   #FUN-B90089 add str---
    DEFINE l_node   om.DomNode
    DEFINE l_rownum LIKE type_file.num10
    DEFINE l_spare  LIKE type_file.chr50                #备用字段
    DEFINE l_str   STRING
    DEFINE l_sql   STRING
    
    INITIALIZE l_rvb.* TO NULL 
    LET l_spare = aws_ttsrv_getParameter("spare")   #SQL Condition 备用字段

#    LET l_sql = " select rvb01,rvb02,rvb05,ima02,rvb07,'',rva06,pmc03",
#                " from rvb_file",
#                " inner join rva_file on rva01=rvb01",
#                " left join ima_file on ima01=rvb05",
#                " left join pmc_file on pmc01=rva05",
#                " where rvaconf='Y'",
#                " and((rvb39='N' and rvb07>0) or (rvb39='Y' and rvb33<>0))",
#                " and rvb07>(rvb29+rvb30)",
#                " order by rva06,rvb01"
    LET l_sql = "select rvbtemp.rvb01,rvbtemp.rvb02 ,rvbtemp.rvb05 ,rvbtemp.ima02,",
                " rvbtemp.rvb07 ,'',rvbtemp.rva06,rvbtemp.ima35,rvbtemp.pmc03",
                " from (",
                " select rva06 ,rvb01,rvb02 ,rvb05 ,ima02,",
                " rvb07 ,ima35,pmc03",
                " from rvb_file",
                " inner join rva_file on rva01=rvb01",
                " inner join ima_file on ima01=rvb05",
                " left join pmc_file on pmc01=rva05",
                " where rvaconf='Y'",
                " and (rvb39='N' and rvb07>0)",
                " union all",
                " select rva06 ,rvb01 ,rvb02 ,rvb05 ,ima02,",
                " rvb33 rvb07 ,ima35,pmc03",
                " from rvb_file",
                " inner join rva_file on rva01=rvb01",
                " inner join ima_file on ima01=rvb05",
                " inner join qcs_file on qcs01=rvb01 and qcs02=rvb02 and qcs14='Y' and qcs09='1'",
                " left join pmc_file on pmc01=rva05",
                " where rvaconf='Y'",
                " and(rvb39='Y' and rvb33<>0)",
                " and rvb07>(rvb29+rvb30)",
                " union all", 
                " select rva06,rvb01,rvb02,rvb05,ima02,",
                " qcsud07 rvb07,ima35,pmc03",
                " from rvb_file",
                " inner join rva_file on rva01=rvb01",
                " inner join ima_file on ima01=rvb05",
                " inner join qcs_file on qcs01=rvb01 and qcs02=rvb02 and qcs14='Y' and qcs09='3' and qcsud07>0",
                " left join pmc_file on pmc01=rva05",
                " where rvaconf='Y'",
                " and not exists(select * from rvv_file where rvv04=rvb01 and rvv05=rvb02 and rvv03='1' and ima35=rvv32)",
                " union all", 
                " select rva06 ,rvb01 ,rvb02 ,rvb05 ,ima02,",
                " qcsud08 rvb07 ,imaud05 ima35 ,pmc03",
                " from rvb_file",
                " inner join rva_file on rva01=rvb01",
                " inner join ima_file on ima01=rvb05",
                " inner join qcs_file on qcs01=rvb01 and qcs02=rvb02 and qcs14='Y' and qcs09='3' and qcsud08>0",
                " left join pmc_file on pmc01=rva05",
                " where rvaconf='Y'",
                " and qcsud08>0",
                " and not exists(select * from rvv_file where rvv04=rvb01 and rvv05=rvb02 and rvv03='1' and imaud05=rvv32)",
                " ) rvbtemp",
                " order by rvbtemp.rva06,rvbtemp.rvb01,rvbtemp.ima35"

    PREPARE rvb_pre FROM l_sql
    DECLARE rvb_cur CURSOR FOR rvb_pre
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = -1
       LET g_status.sqlcode = SQLCA.SQLCODE
       LET g_status.description="发生语法错误"
       RETURN
    END IF
    	
    FOREACH rvb_cur INTO l_rvb.* 
    		
    		IF STATUS THEN
        	EXIT FOREACH
        END IF
        LET l_rvb.rvb07a=l_rvb.rvb07
        SELECT SUM(rvv17)                         #检查入库数量                
        INTO l_in FROM rvv_file,rvu_file       
        WHERE rvv04=l_rvb.rvb01 
        AND rvv05=l_rvb.rvb02    
        AND rvu01=rvv01
        AND rvu00='1'
        AND rvuconf != 'X'
        
        SELECT SUM(rvv17)                         #检查验退数量
        INTO l_out FROM rvv_file,rvu_file     
        WHERE rvv04=l_rvb.rvb01      
        AND rvv05=l_rvb.rvb02        
        AND rvu01=rvv01
        AND rvu00='2'
        AND rvuconf != 'X'
        
        IF cl_null(l_in) THEN LET l_in = 0 END IF
        
        IF cl_null(l_out) THEN LET l_out = 0 END IF
        
        IF l_rvb.rvb07=l_in+l_out THEN
        	CONTINUE FOREACH 
        ELSE 
        	SELECT SUM(qcs091)                     #检查合格数量
          INTO l_qcs091 FROM qcs_file      
          WHERE qcs01 =l_rvb.rvb01
          AND qcs02 =l_rvb.rvb02
          AND qcs14 = 'Y'
          
          IF cl_null(l_qcs091) THEN LET l_qcs091 = 0 END IF
          
          LET g_in=l_qcs091 - l_in
          
          IF cl_null(g_in) THEN LET g_in=0 END IF 
          
          IF g_sma.sma886[6,6] = 'N' THEN         
          	LET g_in =l_rvb.rvb07-l_in-l_out   
          END IF
          
          IF g_sma.sma886[6,6] = 'Y' AND g_sma.sma886[8,8] = 'N' THEN
          	SELECT rvb33 INTO l_rvb33 FROM rvb_file 
          	WHERE rvb01=l_rvb.rvb01 AND rvb02=l_rvb.rvb02
            
            IF cl_null(l_rvb33) THEN LET l_rvb33=0 END IF 
            
            LET g_in  = l_rvb33-l_in
          END IF
          
          SELECT rvb39 INTO l_rvb39 FROM rvb_file 
          WHERE rvb01=l_rvb.rvb01 AND rvb02=l_rvb.rvb02
          
          IF l_rvb39 = 'N' THEN                 
          	LET g_in = l_rvb.rvb07-l_in-l_out
          END IF
          
          IF cl_null(g_in) THEN LET g_in=0 END IF
          
          IF g_in<=0 THEN
       			CONTINUE FOREACH  
          ELSE 
          	LET l_rvb.rvb07 = g_in
          	LET l_rvb.rvb07a= g_in
          	LET l_rvba.* = l_rvb.*
          END IF
        
        END IF 
        
        LET l_node= aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_rvb), "Master")   
    
    END FOREACH

END FUNCTION
	
