# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#{
# Program name...: cws_get_lot.4gl
# Descriptions...: 刷新产品信息
# Date & Author..: 2016/08/05 by guanyao
 
 
DATABASE ds
 
 
GLOBALS "../../../tiptop/config/top.global"
 
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
#[
# Description....: 提供取得 ERP 客戶編號列表服務(入口 function)
# Date & Author..: 2015/11/04 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]

DEFINE l_return   RECORD 
           tc_shc03        LIKE tc_shc_file.tc_shc03,                
           tc_shc06        LIKE tc_shc_file.tc_shc06,              
           flag            LIKE type_file.chr1,   
           tc_shc01        LIKE type_file.chr10,
           tc_shc08        LIKE type_file.chr100,  
           tc_shc14        LIKE tc_shc_file.tc_shc14,
           gen02           LIKE gen_file.gen02,
           tc_shc12        LIKE tc_shc_file.tc_shc12,
           tc_shbud09      LIKE tc_shb_file.tc_shbud09,
           tc_shb121       LIKE tc_shb_file.tc_shb121,
           tc_shb122       LIKE tc_shb_file.tc_shb122,
           tc_shc16        LIKE tc_shc_file.tc_shc16                           
           END RECORD
                   
FUNCTION cws_get_lot()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL cws_get_lot_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 检验逻辑
# Date & Author..: 2015/11/04 by huxya
# Parameter......: none
# Return.........: none
# Memo...........:
#
#]
FUNCTION cws_get_lot_process()
    DEFINE l_lot            LIKE shm_file.shm01
    DEFINE l_node           om.DomNode
    DEFINE l_plant          LIKE ogb_file.ogbplant
    DEFINE l_statuscode     LIKE type_file.chr10
    DEFINE l_msg            string
    DEFINE l_item           STRING
    DEFINE l_code           LIKE ecd_file.ecd01
    DEFINE sr       RECORD 
           tc_shc03        LIKE tc_shc_file.tc_shc03,                
           tc_shc06        LIKE tc_shc_file.tc_shc06,              
           flag            LIKE type_file.chr1,   
           tc_shc01        LIKE type_file.chr10,
           tc_shc08        LIKE type_file.chr100,  
           tc_shc14        LIKE tc_shc_file.tc_shc14,
           gen02           LIKE gen_file.gen02,
           tc_shc12        LIKE tc_shc_file.tc_shc12,
           tc_shbud09      LIKE tc_shb_file.tc_shbud09,
           tc_shb121       LIKE tc_shb_file.tc_shb121,
           tc_shb122       LIKE tc_shb_file.tc_shb122,
           tc_shc16        LIKE tc_shc_file.tc_shc16
        END RECORD 
    
    DEFINE l_sql   STRING
    DEFINE l_chk_pasword VARCHAR(100)
    
    DELETE FROM item_tab;
    DROP TABLE item_tab;
    CREATE TEMP TABLE item_tab(
    tc_shc03        CHAR(20),                
    tc_shc06        DECIMAL(5),            
    flag            CHAR(1),  
    tc_shc01        CHAR(10), 
    tc_shc08        CHAR(100), 
    tc_shc14        DATE,
    gen02           CHAR(40),
    tc_shc12        DECIMAL(15,3),
    tc_shbud09      DECIMAL(15,3),
    tc_shb121       DECIMAL(15,3),
    tc_shb122       DECIMAL(15,3),
    tc_shc16        CHAR(4)
    );
    
    INITIALIZE sr.* TO NULL
    LET l_statuscode = '0'                  #初始化状况码
    LET l_msg = ''

    LET l_lot = aws_ttsrv_getParameter("lot")        #取由呼叫端呼叫時給予的 SQL Condition
    LET l_code = aws_ttsrv_getParameter("code")      #取由呼叫端呼叫時給予的 SQL Condition


    IF cl_null(l_code) OR l_code = 'null' THEN
       LET l_sql = "SELECT tc_shc03,tc_shc06,CASE tc_shc01 WHEN '1' THEN '1' ELSE '4' END,",
                   "       CASE tc_shc01 WHEN '1' THEN '扫入' ELSE '扫出' END,tc_shc08||'|'||ecd02,tc_shc14,",
                   "       gen02,tc_shc12,tc_shcud09,0,0,tc_shc16",
                   "  FROM tc_shc_file LEFT JOIN gen_file ON gen01 = tc_shc11",
                   "                   LEFT JOIN ecd_file ON ecd01 = tc_shc08",
                   " WHERE tc_shc03 = '",l_lot,"'",
                   " UNION ALL",
                   " SELECT tc_shb03,tc_shb06,CASE tc_shb01 WHEN '1' THEN '2' ELSE '3' END,",
                   "        CASE tc_shb01 WHEN '1' THEN '开工' ELSE '完工' END,tc_shb08||'|'||ecd02,tc_shb14,",
                   "        gen02,tc_shb12,tc_shbud09,NVL(tc_shb121,0),NVL(tc_shb122,0),tc_shb16",
                   "  FROM tc_shb_file LEFT JOIN gen_file ON gen01 = tc_shb11",
                   "                   LEFT JOIN ecd_file ON ecd01 = tc_shb08",
                   " WHERE tc_shb03 = '",l_lot,"'"
    ELSE
       LET l_sql = "SELECT tc_shc03,tc_shc06,CASE tc_shc01 WHEN '1' THEN '1' ELSE '4' END,",
                   "       CASE tc_shc01 WHEN '1' THEN '扫入' ELSE '扫出' END,tc_shc08||'|'||ecd02,tc_shc14,",
                   "       gen02,tc_shc12,tc_shcud09,0,0,tc_shc16",
                   "  FROM tc_shc_file LEFT JOIN gen_file ON gen01 = tc_shc11",
                   "                   LEFT JOIN ecd_file ON ecd01 = tc_shc08",
                   " WHERE tc_shc03 = '",l_lot,"'",
                   "   AND tc_shc08 = '",l_code,"'",
                   " UNION ALL",
                   " SELECT tc_shb03,tc_shb06,CASE tc_shb01 WHEN '1' THEN '2' ELSE '3' END,",
                   "        CASE tc_shb01 WHEN '1' THEN '开工' ELSE '完工' END,tc_shb08||'|'||ecd02,tc_shb14,",
                   "        gen02,tc_shb12,tc_shbud09,NVL(tc_shb121,0),NVL(tc_shb122,0),tc_shb16",
                   "  FROM tc_shb_file LEFT JOIN gen_file ON gen01 = tc_shb11",
                   "                   LEFT JOIN ecd_file ON ecd01 = tc_shb08",
                   " WHERE tc_shb03 = '",l_lot,"'",
                   "   AND tc_shb08 = '",l_code,"'"
    END IF
    PREPARE item_pre FROM l_sql
    DECLARE get_item CURSOR FOR item_pre
    FOREACH get_item INTO sr.*
       INSERT INTO item_tab VALUES(sr.*)
    END FOREACH
    INITIALIZE sr.* TO NULL
	DECLARE get_item1 CURSOR FOR SELECT * FROM item_tab ORDER BY tc_shc06,flag
	FOREACH get_item1 INTO sr.*   
	   IF SQLCA.sqlcode THEN
          LET l_statuscode = '-1'
          LET l_msg = '无报工信息'
          CALL cws_get_lot_return(sr.*)
          EXIT FOREACH
       END IF
	   LET l_statuscode = '0'
	   LET l_msg = '刷新成功！'  
 	   CALL cws_get_lot_return(sr.*)
	   LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_return), "Master")   #加入此筆單檔資料至 Response 中
	END FOREACH
    IF l_msg IS NULL OR l_msg = '' THEN
       LET l_statuscode = '-1'
       LET l_msg = '无商品资料！'
       CALL cws_get_lot_return(sr.*)
    END IF
    LET g_status.code = l_statuscode
    LET g_status.description = l_msg
    	    
END FUNCTION

		
FUNCTION cws_get_lot_return(p_sr)
	DEFINE p_statuscode      LIKE type_file.chr1,               #状况码：Y，成功；N，失败
           p_msg             string                              #状况码说明
    DEFINE p_sr       RECORD 
           tc_shc03        LIKE tc_shc_file.tc_shc03,                
           tc_shc06        LIKE tc_shc_file.tc_shc06,              
           flag            LIKE type_file.chr1,   
           tc_shc01        LIKE type_file.chr10,
           tc_shc08        LIKE type_file.chr100,  
           tc_shc14        LIKE tc_shc_file.tc_shc14,
           gen02           LIKE gen_file.gen02,
           tc_shc12        LIKE tc_shc_file.tc_shc12,
           tc_shbud09      LIKE tc_shb_file.tc_shbud09,
           tc_shb121       LIKE tc_shb_file.tc_shb121,
           tc_shb122       LIKE tc_shb_file.tc_shb122,
           tc_shc16        LIKE tc_shc_file.tc_shc16
        END RECORD 
	
	LET l_return.tc_shc03=p_sr.tc_shc03
	LET l_return.tc_shc06=p_sr.tc_shc06
	LET l_return.flag = p_sr.flag
	LET l_return.tc_shc01=p_sr.tc_shc01
	LET l_return.tc_shc08=p_sr.tc_shc08
    LET l_return.tc_shc14=p_sr.tc_shc14
	LET l_return.gen02=p_sr.gen02
	LET l_return.tc_shc12 = p_sr.tc_shc12
	LET l_return.tc_shbud09=p_sr.tc_shbud09
	LET l_return.tc_shb121=p_sr.tc_shb121
    LET l_return.tc_shb122=p_sr.tc_shb122
	LET l_return.tc_shc16=p_sr.tc_shc16
	
END FUNCTION 	
	
