# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#{
# Program name...: aws_get_work.4gl
# Descriptions...: 获取工单信息提供给完工入库使用
# Date & Author..: 2016-04-26 10:04:04 by shenran

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

FUNCTION aws_get_work()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_work_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 

FUNCTION aws_get_work_process()
    DEFINE l_i     LIKE type_file.num10
    DEFINE l_sfb081 LIKE sfb_file.sfb081
    DEFINE l_sfb39  LIKE sfb_file.sfb39
    DEFINE l_sfv  RECORD 
           sfb05   LIKE sfb_file.sfb05,
           sfv09   LIKE sfv_file.sfv09,
           sfv09a  LIKE sfv_file.sfv09,
           ima35   LIKE ima_file.ima35,
           ima02   LIKE ima_file.ima02  
                   END RECORD
    DEFINE l_node  om.DomNode

   #FUN-B90089 add str---
    DEFINE l_wc    STRING
    DEFINE l_str   STRING
    DEFINE l_end   STRING
    DEFINE l_sql   STRING
    DEFINE l_sfa01 LIKE sfa_file.sfa01
    DEFINE l_n     LIKE type_file.num10
    DEFINE l_cnt   LIKE type_file.num10
    DEFINE l_sfv09 LIKE sfv_file.sfv09
    DEFINE l_ima153 LIKE ima_file.ima153
    DEFINE l_min_set LIKE sfv_file.sfv09
    
    LET l_sfa01 = aws_ttsrv_getParameter("sfa01")   #取由呼叫端呼叫時給予的 SQL Condition


    IF cl_null(l_sfa01) THEN 
       LET g_status.code=-1
       LET g_status.description="工单号不能为空！"
       RETURN
    END IF
    
       LET l_sql = " SELECT nvl(sum(sfv09),0) FROM sfv_file,sfu_file WHERE sfv11 = '",l_sfa01,"'",
                   " AND sfv01 = sfu01",
                   " AND sfu00 = '1'",
                   " AND sfuconf <> 'X'"
       PREPARE prep_aaaa FROM l_sql
       EXECUTE prep_aaaa INTO l_sfv09

       LET l_sql = " SELECT sfb05,sfb08,'',ima35,ima02,sfb081,sfb39,ima153",
                   " FROM sfb_file left join ima_file on ima01 = sfb05",
                   " WHERE sfb01 = '",l_sfa01,"'",
                   " ORDER BY sfb01 "
  
    DECLARE occ_cur CURSOR FROM l_sql
   
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    FOREACH occ_cur INTO l_sfv.*,l_sfb081,l_sfb39,l_ima153
    IF cl_null(l_sfv.ima35) OR l_sfv.ima35 =' ' THEN
    	 LET g_status.code=-1
       LET g_status.description="默认仓库为空,请至料件基本档维护!"
       RETURN 
    END IF
    CALL s_get_ima153(l_sfv.sfb05) RETURNING l_ima153
    IF cl_null(l_ima153) THEN LET l_ima153=0 END IF 
    #add by shenran 根据扣账方式来判断可入库数量 str
    IF l_sfb39='1' THEN 
      #LET l_sfv.sfv09=l_sfb081-l_sfv09
           SELECT sma73 INTO g_sma.sma73 FROM sma_file
           CALL s_minp(l_sfa01,g_sma.sma73,l_ima153,'','','',g_today)    #FUN-C70037 
                        RETURNING l_cnt,l_min_set
           IF cl_null(l_min_set) THEN LET l_min_set=0 END IF
           LET l_sfv.sfv09 = l_min_set
           LET l_sfv.sfv09 = l_sfv.sfv09-l_sfv09
        
    END IF
    IF l_sfb39='2' THEN
      LET l_sfv.sfv09  = l_sfv.sfv09-l_sfv09
      LET l_sfv.sfv09  = l_sfv.sfv09 + (l_sfv.sfv09*l_ima153/100)
    END IF
    #add by shenran 根据扣账方式来判断可入库数量 end
    
    LET l_sfv.sfv09a = l_sfv.sfv09
    IF l_sfv.sfv09>0 THEN
       LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_sfv), "Master")   #加入此筆單檔資料至 Response 中
    ELSE 
    	 LET g_status.code=-1
       LET g_status.description="无可入库量!"
       RETURN
    END IF
    END FOREACH
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION
	
