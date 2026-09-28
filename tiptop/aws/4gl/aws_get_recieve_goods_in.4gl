DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

FUNCTION aws_get_recieve_goods_in()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_recieve_goods_in_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
    #DROP TABLE recieve_goods_file;
END FUNCTION

       
FUNCTION aws_get_recieve_goods_in_process()
    DEFINE l_i     LIKE type_file.num10
    DEFINE l_rvb  RECORD 
           rva06   LIKE rva_file.rva06,  #收货日期
           rvb01   LIKE rvb_file.rvb01,  #收货单号
           rvb02   LIKE rvb_file.rvb02,  #项次
           rvb05   LIKE rvb_file.rvb05,  #料号
           ima02   LIKE ima_file.ima02,  #品名
           ima021  LIKE ima_file.ima021, #规格
           rvb07   LIKE rvb_file.rvb07,  #数量
           rvb29   LIKE rvb_file.rvb29,  #验退数量
           rvb30   LIKE rvb_file.rvb30,  #入库数量
           rvb90   LIKE rvb_file.rvb90,  #收货单位
           rva05   LIKE rva_file.rva05,  #供应商
           pmc03   LIKE pmc_file.pmc03,  #供应商名称  
           rvb36   LIKE rvb_file.rvb36   #收货单位
                   END RECORD
    DEFINE l_node  om.DomNode

   #FUN-B90089 add str---
    DEFINE l_rownum LIKE type_file.num10
    DEFINE l_wc    STRING
    DEFINE l_str   STRING
    DEFINE l_end   STRING
    DEFINE l_sql   STRING
    DEFINE l_n     LIKE type_file.num10 
    DEFINE l_in,l_out,g_in LIKE rvb_file.rvb07
    DEFINE l_rvb33 LIKE rvb_file.rvb33
    DEFINE l_rvb39 LIKE rvb_file.rvb39
    DEFINE l_qcs091 LIKE qcs_file.qcs091
    DEFINE l_odd   LIKE rvb_file.rvb01
    DEFINE l_ima01 LIKE ima_file.ima01
    DEFINE l_ima02 LIKE ima_file.ima02
    DEFINE l_ima021 LIKE ima_file.ima021
    DEFINE l_pagenow LIKE type_file.num10
    DEFINE l_pagesize LIKE type_file.num10
    
#    DROP TABLE recieve_goods_file;
#    CREATE TEMP TABLE recieve_goods_file(                                                                    
#           rva06   LIKE rva_file.rva06,  #收货日期
#           rvb01   LIKE rvb_file.rvb01,  #收货单号
#           rvb02   LIKE rvb_file.rvb02,  #项次
#           rvb05   LIKE rvb_file.rvb05,  #料号
#           ima02   LIKE ima_file.ima02,  #品名
#           ima021  LIKE ima_file.ima021, #规格
#           rvb07   LIKE rvb_file.rvb07,  #数量
#           rvb29   LIKE rvb_file.rvb29,  #验退数量
#           rvb30   LIKE rvb_file.rvb30,  #入库数量
#           rvb90   LIKE rvb_file.rvb90,  #收货单位
#           rva05   LIKE rva_file.rva05,  #供应商
#           pmc03   LIKE pmc_file.pmc03,  #供应商名称  
#           rvb36   LIKE rvb_file.rvb36)  #收货单位 
#   DELETE FROM recieve_goods_file;              
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
    	 LET l_pagesize=5
    END IF
   LET l_sql = " SELECT rva06,rvb01,rvb02,rvb05,ima02,ima021,rvb07,rvb29,rvb30,rvb90,rva05,pmc03,rvb36",
               " FROM rvb_file inner join rva_file ON rva01 = rvb01 LEFT JOIN pmc_file ON pmc01 = rva05 ",
               "  INNER JOIN ima_file ON ima01 = rvb05",
               " WHERE rvaconf = 'Y' AND ((rvb39 = 'N' AND rvb07 > 0) OR (rvb39 = 'Y' AND rvb33 <> 0)) ",
               "  AND rvb07 > (rvb29 + rvb30)",
               " ORDER BY rvb01,rvb02,rva06"
  
    DECLARE occ_cur CURSOR FROM l_sql
   
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
     FOREACH occ_cur INTO l_rvb.*
       IF STATUS THEN
          LET g_status.code = -1
       END IF

       ########################################################################################
         SELECT SUM(rvv17)        
           INTO l_in FROM rvv_file,rvu_file    
          WHERE rvv04=l_rvb.rvb01  #收貨單號
            AND rvv05=l_rvb.rvb02  #收貨項次
            AND rvu01=rvv01
            AND rvu00='1'
            AND rvuconf != 'X'
         SELECT SUM(rvv17)                #MOD-A70160
           INTO l_out FROM rvv_file,rvu_file      #MOD-A70160
          WHERE rvv04=l_rvb.rvb01  #收貨單號
            AND rvv05=l_rvb.rvb02  #收貨項次
            AND rvu01=rvv01
            AND rvu00='2'
            AND rvuconf != 'X'
          IF cl_null(l_in)  THEN  LET l_in = 0 END IF
          IF cl_null(l_out) THEN  LET l_out = 0 END IF
          IF l_rvb.rvb07=l_in+l_out THEN
          	  continue foreach 
          ELSE 
             SELECT SUM(qcs091)
             INTO l_qcs091 FROM qcs_file      #MOD-A70160
             WHERE qcs01 = l_rvb.rvb01
             AND qcs02 = l_rvb.rvb02
             AND qcs14 = 'Y'
             IF cl_null(l_qcs091) THEN LET l_qcs091 = 0 END IF
             LET g_in=l_qcs091 - l_in
             IF cl_null(g_in) THEN LET g_in=0 END IF 
             IF g_sma.sma886[6,6] = 'N' THEN         #免檢驗直接入庫
               LET g_in = l_rvb.rvb07-l_in-l_out    #No.MOD-8C0080 add
             END IF
             IF g_sma.sma886[6,6] = 'Y' AND g_sma.sma886[8,8] = 'N' THEN
             	SELECT rvb33 INTO l_rvb33 FROM rvb_file WHERE rvb01=l_rvb.rvb01 AND rvb02=l_rvb.rvb02
             	IF cl_null(l_rvb33) THEN LET l_rvb33=0 END IF 
               LET g_in  = l_rvb33-l_in
             END IF
             SELECT rvb39 INTO l_rvb39 FROM rvb_file WHERE rvb01=l_rvb.rvb01 AND rvb02=l_rvb.rvb02
             IF l_rvb39 = 'N' THEN   #料件免檢驗入庫，不管上面怎麼算，都直接入庫
               LET g_in = l_rvb.rvb07-l_in-l_out
             END IF
             IF cl_null(g_in) THEN 
                LET g_in=0 
             END IF
             IF g_in <= 0 THEN
                CONTINUE FOREACH
             END IF 
             LET l_rvb.rvb07 = g_in
          END IF
       ########################################################################################
      #    INSERT INTO recieve_goods_file VALUES(l_rvb.*)
      LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_rvb), "Master")   #加入此筆單檔資料至 Response 中
    END FOREACH
#    INITIALIZE l_rvb.* TO NULL
#    LET l_sql="select * from(",
#              " select t.*,rownum item from(",
#              " select * from recieve_goods_file order by rvb01,rvb02,rva06) t )",
#              " where item>('",l_pagenow,"'-1)*'",l_pagesize,"' and item<=('",l_pagenow,"')*'",l_pagesize,"'"
#    DECLARE occ_cur1 CURSOR FROM l_sql
#      IF SQLCA.SQLCODE THEN
#         LET g_status.code = SQLCA.SQLCODE
#         LET g_status.sqlcode = SQLCA.SQLCODE
#         RETURN
#      END IF
#      
#       FOREACH occ_cur1 INTO l_rvb.*
#         IF STATUS THEN
#            LET g_status.code = -1
#         END IF
#         LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_rvb), "Master")	
#       END FOREACH	        
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION
