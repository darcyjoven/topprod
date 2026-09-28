# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Descriptions...: 盘点资料上传
# Date & Author..: 2016-06-15 11:27:33 shenran


DATABASE ds

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

GLOBALS "../../aba/4gl/barcode.global"



GLOBALS
DEFINE g_tc_bwb   RECORD LIKE tc_bwb_file.*
DEFINE li_result  LIKE type_file.num5
DEFINE g_yy,g_mm  LIKE type_file.num5 
DEFINE g_img09_t LIKE img_file.img09
DEFINE g_i       LIKE type_file.num5
DEFINE g_ima907  LIKE ima_file.ima907
DEFINE g_gec07   LIKE gec_file.gec07
DEFINE g_sql     STRING
DEFINE g_ima35   LIKE ima_file.ima35
DEFINE g_ima36   LIKE ima_file.ima36
DEFINE g_ima25   LIKE ima_file.ima25
DEFINE g_ima55   LIKE ima_file.ima55
DEFINE g_cnt     LIKE type_file.num10
DEFINE g_rec_b   LIKE type_file.num5
DEFINE g_rec_b_1 LIKE type_file.num5
DEFINE l_ac_t    LIKE type_file.num10
DEFINE li_step   LIKE type_file.num5
DEFINE g_img07   LIKE img_file.img07
DEFINE g_img09   LIKE img_file.img09
DEFINE g_img10   LIKE img_file.img10
DEFINE g_ima906  LIKE ima_file.ima906
DEFINE g_flag    LIKE type_file.chr1
DEFINE g_pmm     RECORD LIKE pmm_file.*
DEFINE g_pmn     RECORD LIKE pmn_file.* 
DEFINE g_rva     RECORD LIKE rva_file.*
DEFINE g_rvb     RECORD LIKE rvb_file.*
DEFINE g_sfu     RECORD LIKE sfu_file.*
DEFINE g_srm_dbs LIKE  type_file.chr50
DEFINE g_success LIKE type_file.chr1
DEFINE g_factor  LIKE sfs_file.sfs31


END GLOBALS

#[
# Description....: 提供建立完工入庫單資料的服務(入口 function)
# Date & Author..: 
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_inventory()
 
 WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增完工入庫單資料                                                       #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_inventory_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序

 
END FUNCTION

#[
# Description....: 依據傳入資訊新增 ERP 完工入庫單資料
# Date & Author..: 
# Parameter......: none
# Return.........: 入庫單號
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_inventory_process()
    DEFINE l_i        LIKE type_file.num10,
           l_j        LIKE type_file.num10,
           l_k        LIKE type_file.num10
    DEFINE l_cnt      LIKE type_file.num10,
           l_cnt1     LIKE type_file.num10,
           l_cnt2     LIKE type_file.num10,
           l_cnt3     LIKE type_file.num10
    DEFINE l_node1    om.DomNode,
           l_node2    om.DomNode,
           l_node3    om.DomNode
    DEFINE l_flag     LIKE type_file.num10
    DEFINE l_pmm     RECORD LIKE pmm_file.*
    DEFINE l_pmn     RECORD LIKE pmn_file.* 
    DEFINE l_rva     RECORD LIKE rva_file.*
    DEFINE l_rvb     RECORD LIKE rvb_file.*
    DEFINE l_yy,l_mm  LIKE type_file.num5       
    DEFINE l_status   LIKE sfu_file.sfuconf
    DEFINE l_cmd      STRING
    DEFINE l_prog     STRING
    DEFINE l_flag1    LIKE type_file.chr1       #FUN-B70074
    DEFINE l_success    CHAR(1)
   DEFINE l_factor     DECIMAL(16,8)
   DEFINE l_img09      LIKE img_file.img09
   DEFINE l_img10      LIKE img_file.img10
   DEFINE l_ima108     LIKE ima_file.ima108
   DEFINE l_n          SMALLINT
   DEFINE l_length     LIKE type_file.num5
   DEFINE p_cmd        LIKE type_file.chr1    #處理狀態
   DEFINE l_t          LIKE type_file.num5
   DEFINE l_inaconf    LIKE ina_file.inaconf
   DEFINE l_ogb04      LIKE ogb_file.ogb04
   DEFINE l_ogb31      LIKE ogb_file.ogb31
   DEFINE l_ogb32      LIKE ogb_file.ogb32
   DEFINE l_sum_ogb12  LIKE ogb_file.ogb12
   DEFINE l_ogb12      LIKE ogb_file.ogb12
   DEFINE l_ogb01a     LIKE ogb_file.ogb01
   DEFINE l_ogb03a     LIKE ogb_file.ogb03
   DEFINE l_ogb01      LIKE ogb_file.ogb01
   DEFINE l_ogb03      LIKE ogb_file.ogb03
   DEFINE l_ima021     LIKE ima_file.ima021   
   DEFINE l_ogb12a     LIKE ogb_file.ogb12
   DEFINE l_sql        STRING
   DEFINE l_pmn04      LIKE pmn_file.pmn04   #料件编码
   DEFINE l_ima02      LIKE ima_file.ima02   #品名
   DEFINE l_pmn07      LIKE pmn_file.pmn07   #单位
   DEFINE l_lotnumber  LIKE type_file.chr50  #批号
   DEFINE l_barcode1   LIKE type_file.chr50  #条码
   DEFINE l_pmn20      LIKE pmn_file.pmn20   #单据数量
   DEFINE l_msg        STRING    #No.FUN-680136 VARCHAR(40)
   DEFINE l_pmn01      LIKE pmn_file.pmn01
   DEFINE l_pmm01      LIKE pmm_file.pmm01
   DEFINE l_pmn02      LIKE pmn_file.pmn02
   DEFINE l_pmn02a     LIKE pmn_file.pmn02
   DEFINE l_pmn20a     LIKE pmn_file.pmn20
   DEFINE l_pmn20ab    LIKE pmn_file.pmn20
   DEFINE l_pmn20b     LIKE pmn_file.pmn20
   DEFINE l_sum        LIKE pmn_file.pmn20
   DEFINE l_sl         LIKE pmn_file.pmn20
   DEFINE l_sr         STRING
   DEFINE l_rvb87      LIKE rvb_file.rvb87
   DEFINE l_rvb29      LIKE rvb_file.rvb29
   DEFINE l_pmn50      LIKE pmn_file.pmn50
   DEFINE l_pmn55      LIKE pmn_file.pmn55
   DEFINE l_pmn58      LIKE pmn_file.pmn58
   DEFINE l_rvb07      LIKE rvb_file.rvb07 

    LET g_success = 'Y'
    INITIALIZE g_tc_bwb.* TO NULL
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("Master")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***

    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF


    FOR l_i = 1 TO l_cnt1
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "Master")       #目前處理單檔的 XML 節點
        
        LET g_tc_bwb.tc_bwb01  = g_today
        LET g_tc_bwb.tc_bwb02  = aws_ttsrv_getRecordField(l_node1,"tc_bwb02")
        LET g_tc_bwb.tc_bwb03  = aws_ttsrv_getRecordField(l_node1,"tc_bwb03")
        LET g_tc_bwb.tc_bwb04  = aws_ttsrv_getRecordField(l_node1,"tc_bwb04")
        LET g_tc_bwb.tc_bwb05  = aws_ttsrv_getRecordField(l_node1,"tc_bwb05")
        LET g_tc_bwb.tc_bwb06  = aws_ttsrv_getRecordField(l_node1,"tc_bwb06")
        LET g_tc_bwb.tc_bwb07  = aws_ttsrv_getRecordField(l_node1,"tc_bwb07")
        LET g_tc_bwb.tc_bwb08  = aws_ttsrv_getRecordField(l_node1,"tc_bwb08")
        LET g_tc_bwb.tc_bwb09  = aws_ttsrv_getRecordField(l_node1,"tc_bwb09")
        IF cl_null(g_tc_bwb.tc_bwb02) THEN
        	 LET g_status.code = "-1"
           LET g_status.description = "批次条码不可为空!"
           RETURN
        END IF
        IF cl_null(g_tc_bwb.tc_bwb03) THEN
        	 LET g_status.code = "-1"
           LET g_status.description = "仓库编码不可为空!"
           RETURN
        END IF
        IF cl_null(g_tc_bwb.tc_bwb04) THEN
        	 LET g_status.code = "-1"
           LET g_status.description = "料号不可为空!"
           RETURN
        END IF
        IF cl_null(g_tc_bwb.tc_bwb05) THEN
        	 LET g_status.code = "-1"
           LET g_status.description = "库位编码不可为空!"
           RETURN
        END IF
        IF cl_null(g_tc_bwb.tc_bwb06) THEN
        	 LET g_status.code = "-1"
           LET g_status.description = "批次不可为空!"
           RETURN
        END IF
        IF cl_null(g_tc_bwb.tc_bwb07) OR g_tc_bwb.tc_bwb07=0  THEN
        	 LET g_status.code = "-1"
           LET g_status.description = "实盘数量不可为空或零!"
           RETURN
        END IF
        IF cl_null(g_tc_bwb.tc_bwb08) THEN
        	 LET g_status.code = "-1"
           LET g_status.description = "盘点人员不可为空!"
           RETURN
        END IF
        IF cl_null(g_tc_bwb.tc_bwb09) THEN
        	 LET g_status.code = "-1"
           LET g_status.description = "盘点计划单号不可为空!"
           RETURN
        END IF
        SELECT COUNT(*) INTO l_n FROM tc_bwb_file WHERE tc_bwb02=g_tc_bwb.tc_bwb02
                                                    AND tc_bwb05=g_tc_bwb.tc_bwb05
                                                    AND tc_bwb09=g_tc_bwb.tc_bwb09
        IF cl_null(l_n) THEN LET l_n=0 END IF
        IF l_n=0 THEN
        	  INSERT INTO tc_bwb_file VALUES (g_tc_bwb.*)
        	    IF SQLCA.SQLCODE OR sqlca.sqlerrd[3]=0 THEN
                  LET g_status.code = '-1'
                  LET g_status.sqlcode = SQLCA.SQLCODE
                  LET g_status.description = "插入tc_bwb_file表有误!"
                  RETURN
              END IF
        ELSE
        	  UPDATE tc_bwb_file SET tc_bwb01=g_today,
        	                         tc_bwb07=tc_bwb07+g_tc_bwb.tc_bwb07,
        	                         tc_bwb08=g_tc_bwb.tc_bwb08
        	    WHERE tc_bwb02=g_tc_bwb.tc_bwb02
                AND tc_bwb05=g_tc_bwb.tc_bwb05
                AND tc_bwb09=g_tc_bwb.tc_bwb09                     
        	    IF SQLCA.SQLCODE OR sqlca.sqlerrd[3]=0 THEN
                  LET g_status.code = '-1'
                  LET g_status.sqlcode = SQLCA.SQLCODE
                  LET g_status.description = "更新tc_bwb_file表有误!"
                  RETURN
              END IF        	                         
        END IF
            	        	        	        	        	
    END FOR

END FUNCTION





	
