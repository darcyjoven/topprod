DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

FUNCTION aws_get_check_goods_in()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_check_goods_in_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
       
FUNCTION aws_get_check_goods_in_process()
    DEFINE l_i     LIKE type_file.num10
    DEFINE l_rvb  RECORD 
           rvb01   LIKE rvb_file.rvb01,  #收货单号
           rvb02   LIKE rvb_file.rvb02,  #项次
           rva06   LIKE rva_file.rva06,  #收货日期
           rvb05   LIKE rvb_file.rvb05,  #料号
           ima02   LIKE ima_file.ima02,  #品名
           ima021  LIKE ima_file.ima021, #规格
           rvb07   LIKE rvb_file.rvb07,  #实收数量
           rva05   LIKE rva_file.rva05,  #供应商
           pmc03   LIKE pmc_file.pmc03   #供应商名称  
                   END RECORD
    DEFINE l_node  om.DomNode

   #FUN-B90089 add str---
    DEFINE l_rownum LIKE type_file.num10
    DEFINE l_wc    STRING
    DEFINE l_str   STRING
    DEFINE l_end   STRING
    DEFINE l_sql   STRING
    DEFINE l_n     LIKE type_file.num10 
    DEFINE l_odd   LIKE rvb_file.rvb01
    DEFINE l_ima01 LIKE ima_file.ima01
    DEFINE l_ima02 LIKE ima_file.ima02
    DEFINE l_ima021 LIKE ima_file.ima021
    DEFINE l_pagenow LIKE type_file.num10
    DEFINE l_pagesize LIKE type_file.num10
    
    INITIALIZE l_rvb.* TO NULL
    LET l_odd=''
    LET l_ima01=''
    LET l_ima02=''
    LET l_ima021=''
    LET l_pagenow=''
    LET l_pagesize=''
    LET l_odd    = aws_ttsrv_getParameter("odd")     #单号
    LET l_ima01  = aws_ttsrv_getParameter("ima01")   #料号 SQL Condition
    LET l_ima02  = aws_ttsrv_getParameter("ima02")   #品名 SQL Condition
    LET l_ima021 = aws_ttsrv_getParameter("ima021")  #规格
    LET l_pagenow = aws_ttsrv_getParameter("pagenow")#当前页
    LET l_pagesize = aws_ttsrv_getParameter("pagesize") #每页笔数
    IF cl_null(l_pagenow) THEN
    	 LET l_pagenow=1
    END IF
    IF cl_null(l_pagesize) THEN
    	 LET l_pagesize=10
    END IF
    #分页写法
    LET l_sql =" SELECT * FROM(",
               " SELECT t.*,rownum item FROM(",	
               " SELECT rvb01,rvb02,rva06,rvb05,ima02,ima021,rvb07,rva05,pmc03",
               " FROM rva_file",
               " INNER JOIN pmc_file ON pmc01 = rva05",
               " INNER JOIN rvb_file ON rva01 = rvb01",
               " INNER JOIN ima_file ON ima01 = rvb05",
               " WHERE rvaconf = 'Y' AND rvb39 = 'Y' AND rvb40 IS NULL AND rvb41 IS NULL"
     IF NOT cl_null(l_odd) THEN
     	  LET l_sql = l_sql," AND rva01 LIKE '%",l_odd,"%'"
     END IF
     IF NOT cl_null(l_ima01) THEN
     	  LET l_sql = l_sql," AND rvb05 LIKE '%",l_ima01,"%'"
     END IF
     IF NOT cl_null(l_ima02) THEN
     	  LET l_sql = l_sql," AND ima02 LIKE '%",l_ima02,"%'"
     END IF
     IF NOT cl_null(l_ima021) THEN
     	  LET l_sql = l_sql," AND ima021 LIKE '%",l_ima021,"%'"
     END IF
     LET l_sql = l_sql," ORDER BY rvb01,rvb02,rva06) t) WHERE item>('",l_pagenow,"'-1)*'",l_pagesize,"' and item<=('",l_pagenow,"')*'",l_pagesize,"'"
     #不分页写法
#    LET l_sql =" SELECT rvb01,rvb02,rva06,rvb05,ima02,ima021,rvb07,rva05,pmc03",
#               " FROM rva_file LEFT JOIN pmc_file ON pmc01 = rva05, rvb_file LEFT JOIN ima_file ON ima01 = rvb05",
#               " WHERE rvaconf = 'Y' AND rvb39 = 'Y' AND rvb40 IS NULL AND rvb41 IS NULL AND rva01 = rvb01",
#               " ORDER BY rvb01,rvb02,rva06"
    DECLARE occ_cur CURSOR FROM l_sql
   
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
     FOREACH occ_cur INTO l_rvb.*

      LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_rvb), "Master")   #加入此筆單檔資料至 Response 中
    END FOREACH
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION