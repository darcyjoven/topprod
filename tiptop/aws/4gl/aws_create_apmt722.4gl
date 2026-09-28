# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Descriptions...: 仓退过账作业
# Date & Author..: 2016-09-08 10:55:08 shenran


DATABASE ds

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

GLOBALS "../../aba/4gl/barcode.global"


GLOBALS
DEFINE g_rvu01    LIKE rvu_file.rvu01  #单号
DEFINE g_buf      LIKE type_file.chr2
DEFINE li_result  LIKE type_file.num5
DEFINE g_yy,g_mm   LIKE type_file.num5 
DEFINE g_img09_t LIKE img_file.img09
DEFINE g_i       LIKE type_file.num5
DEFINE g_ima907  LIKE ima_file.ima907
DEFINE g_gec07   LIKE gec_file.gec07
DEFINE g_sql      STRING
DEFINE g_cnt     LIKE type_file.num10
DEFINE g_rec_b   LIKE type_file.num5
DEFINE g_rec_b_1 LIKE type_file.num5
DEFINE l_ac      LIKE type_file.num10
DEFINE l_ac_t    LIKE type_file.num10
DEFINE li_step   LIKE type_file.num5
DEFINE g_img07   LIKE img_file.img07
DEFINE g_img09   LIKE img_file.img09
DEFINE g_img10   LIKE img_file.img10
DEFINE g_ima906  LIKE ima_file.ima906
DEFINE g_flag    LIKE type_file.chr1
DEFINE g_srm_dbs LIKE  type_file.chr50
DEFINE g_success LIKE type_file.chr1

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
FUNCTION aws_create_apmt722()
 
 WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增完工入庫單資料                                                       #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_apmt722_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
     DROP TABLE t722_file
     DROP TABLE t722_file1
     DROP TABLE apmt722_temp
     DROP TABLE tmp 
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
FUNCTION aws_create_apmt722_process()
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
   DEFINE l_msg        LIKE type_file.chr50    #No.FUN-680136 VARCHAR(40)
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
   DEFINE l_t722_file1      RECORD                    #单身
                    rvv02      LIKE rvv_file.rvv02,         #项次
                    rvv17      LIKE rvv_file.rvv17,         #申请数量
                    rvv17a     LIKE rvv_file.rvv17          #匹配数量
                 END RECORD  
  DEFINE  l_t722_file     RECORD
                    barcode    LIKE type_file.chr50,        #条码
                    rvv32      LIKE rvv_file.rvv32,         #仓库
                    rvv33      LIKE rvv_file.rvv33,         #库位
                    batch      LIKE type_file.chr50,        #批号
                    rvv31      LIKE rvv_file.rvv31,         #料件
                    rvv17b     LIKE rvv_file.rvv17          #数量
                 END RECORD
   DROP TABLE t722_file
   DROP TABLE t722_file1 
   DROP TABLE tmp  
   CREATE TEMP TABLE t722_file(
                    barcode    LIKE type_file.chr50,        #条码
                    rvv32      LIKE rvv_file.rvv32,         #仓库
                    rvv33      LIKE rvv_file.rvv33,         #库位
                    batch      LIKE type_file.chr50,        #批号
                    rvv31      LIKE rvv_file.rvv31,         #料件
                    rvv17b     LIKE rvv_file.rvv17)         #数量
   CREATE TEMP TABLE t722_file1( 
                    rvv02      LIKE rvv_file.rvv02,         #项次
                    rvv17      LIKE rvv_file.rvv17,         #申请数量
                    rvv17a     LIKE rvv_file.rvv17)         #匹配数量
   CREATE TEMP TABLE tmp(                                                                                                                 
    a         LIKE oea_file.oea01,                                                                                                
    b         LIKE type_file.chr1000,                                                                                                 
    c         LIKE type_file.num15_3);  #FUN-A20044                
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的完工入庫單資料                                    #
    #--------------------------------------------------------------------------#
    LET g_success = 'Y'
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("Master")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
    
    ##add by nihuan 20170613---start---
    ####apmt722_temp
    CALL aws_apmt722_temp_table()
    ##add by nihuan 20170613---end-----
    
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       LET g_success='N'
       RETURN
    END IF


    FOR l_i = 1 TO l_cnt1
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "Master")       #目前處理單檔的 XML 節點
        
        LET g_rvu01 = aws_ttsrv_getRecordField(l_node1,"rvu01")
        #----------------------------------------------------------------------#
        # 處理單身資料                                                         #
        #----------------------------------------------------------------------#
        LET l_cnt3 = aws_ttsrv_getDetailRecordLength(l_node1, "t722_file1")       #取得目前單頭共有幾筆單身資料
        IF l_cnt3 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           LET g_success='N'
           EXIT FOR
        END IF
        FOR l_k = 1 TO l_cnt3
            INITIALIZE l_t722_file1.* TO NULL
            LET l_node3 = aws_ttsrv_getDetailRecord(l_node1, l_k,"t722_file1")   #目前單身的 XML 節點
            #------------------------------------------------------------------#
            # NODE資料傳到RECORD                                               #
            #------------------------------------------------------------------#
            LET l_t722_file1.rvv02  = aws_ttsrv_getRecordField(l_node3, "rvv02") 
            LET l_t722_file1.rvv17  = aws_ttsrv_getRecordField(l_node3, "rvv17")   
            LET l_t722_file1.rvv17a = aws_ttsrv_getRecordField(l_node3, "rvv17a")
            
            INSERT INTO t722_file1 VALUES (l_t722_file1.*)
        END FOR
        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "t722_file")       #取得目前單頭共有幾筆單身資料
        IF l_cnt2 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           LET g_success='N'
           EXIT FOR
        END IF                
        FOR l_j = 1 TO l_cnt2
            INITIALIZE l_t722_file.* TO NULL
            LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j,"t722_file")   #目前單身的 XML 節點
            #------------------------------------------------------------------#
            # NODE資料傳到RECORD                                               #
            #------------------------------------------------------------------#
            LET l_t722_file.barcode = aws_ttsrv_getRecordField(l_node2, "barcode")
            LET l_t722_file.rvv32   = aws_ttsrv_getRecordField(l_node2, "rvv32")
            LET l_t722_file.rvv33   = aws_ttsrv_getRecordField(l_node2, "rvv33")
            LET l_t722_file.batch   = aws_ttsrv_getRecordField(l_node2, "batch")
            LET l_t722_file.rvv31   = aws_ttsrv_getRecordField(l_node2, "rvv31")
            LET l_t722_file.rvv17b  = aws_ttsrv_getRecordField(l_node2, "rvv17b")
            INSERT INTO t722_file VALUES (l_t722_file.*)
        END FOR
    END FOR
    IF g_success = 'Y' THEN 
       CALL t722_load()
    END IF
END FUNCTION
FUNCTION t722_load()
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_img09     LIKE img_file.img09
   DEFINE l_rvu08     LIKE rvu_file.rvu08
   DEFINE b_rvv       RECORD LIKE rvv_file.*
   DEFINE l_sql       STRING
   DEFINE l_rvv       RECORD                    #单身
                    rvv02      LIKE rvv_file.rvv02,         #项次
                    rvv17      LIKE rvv_file.rvv17,         #申请数量
                    rvv17a     LIKE rvv_file.rvv17          #匹配数量
                 END RECORD
   #add by nihuan 20170613----------start
   DEFINE l_rvv31      LIKE rvv_file.rvv31,
          l_rvv32      LIKE rvv_file.rvv32,
          l_rvv33      LIKE rvv_file.rvv33,
          l_rvv34      LIKE rvv_file.rvv34,
          l_sum        LIKE rvv_file.rvv17
   DEFINE l_rvv1        RECORD LIKE rvv_file.*
   #add by nihuan 20170613----------start               

   LET g_success = "Y"
   BEGIN WORK
   
   ###add by nihuan 20170613----start------
   ####g_rvu01
   LET l_sql="insert into apmt722_temp select * from rvv_file where rvv01='",g_rvu01,"'"
   PREPARE apmt722_temp_ins FROM l_sql
   EXECUTE apmt722_temp_ins
   DELETE FROM rvv_file WHERE rvv01=g_rvu01
#   t722_file(
#                    barcode    LIKE type_file.chr50,        #条码
#                    rvv32      LIKE rvv_file.rvv32,         #仓库
#                    rvv33      LIKE rvv_file.rvv33,         #库位
#                    batch      LIKE type_file.chr50,        #批号
#                    rvv31      LIKE rvv_file.rvv31,         #料件
#                    rvv17b     LIKE rvv_file.rvv17)         #数量
   LET l_sql=" select rvv32,rvv33,batch,rvv31,sum(rvv17b) from t722_file
               group by rvv32,rvv33,batch,rvv31"
    PREPARE t722_file_rvv_nh FROM l_sql
    DECLARE t722_file_rvv_curs_nh CURSOR FOR t722_file_rvv_nh
    FOREACH t722_file_rvv_curs_nh INTO l_rvv32,l_rvv33,l_rvv34,l_rvv31,l_sum
       IF l_sum=0 THEN 
       	  CONTINUE FOREACH 
       END IF 	
       
       LET l_sql=" select * from apmt722_temp 
                   where rvv01='",g_rvu01,"' and rvv31='",l_rvv31,"' and rvv17>0
                   order by rvv02"
       PREPARE t722_file_rvv_hn FROM l_sql
       DECLARE t722_file_rvv_curs_hn CURSOR FOR t722_file_rvv_hn
       FOREACH t722_file_rvv_curs_hn INTO l_rvv1.* 
          IF l_sum=0 THEN    #数量必相等，前端判断
          	 EXIT FOREACH 
          END IF 	
          
          IF l_sum>=l_rvv1.rvv17 THEN 
          	 LET l_sum=l_sum-l_rvv1.rvv17
          	 
          	 UPDATE apmt722_temp SET rvv17=0
          	 WHERE rvv01=l_rvv1.rvv01 AND rvv02=l_rvv1.rvv02
          ELSE 
          	
          	 UPDATE apmt722_temp SET rvv17=l_rvv1.rvv17-l_sum
          	 WHERE rvv01=l_rvv1.rvv01 AND rvv02=l_rvv1.rvv02
          	 LET l_rvv1.rvv17=l_sum
          	 LET l_sum=0
          END IF
          	
          SELECT MAX(nvl(rvv02,0))+1 INTO l_rvv1.rvv02 
          FROM rvv_file WHERE rvv01=g_rvu01
          IF cl_null(l_rvv1.rvv02) THEN 
             LET l_rvv1.rvv02 =1
          END IF 
          
          LET l_rvv1.rvv39  = l_rvv1.rvv17*l_rvv1.rvv38
          LET l_rvv1.rvv39t = l_rvv1.rvv17*l_rvv1.rvv38t
          LET l_rvv1.rvv31=l_rvv31
          LET l_rvv1.rvv32=l_rvv32
          LET l_rvv1.rvv33=l_rvv33
          LET l_rvv1.rvv34=l_rvv34
          
          INSERT INTO rvv_file VALUES(l_rvv1.*)	 	
          IF SQLCA.SQLCODE THEN
             LET g_status.code = SQLCA.SQLCODE
             LET g_status.sqlcode = SQLCA.SQLCODE
             LET g_success='N'
             EXIT FOREACH 
          END IF
       END FOREACH
       
       IF g_success='N' THEN 
       	  EXIT FOREACH 
       END IF 	
    END FOREACH       	
          	               
   ###add by nihuan 20170613----end--------
   
#   LET l_sql =" select * from t722_file1",
#              " order by rvv02"
# PREPARE t722_file_rvv FROM l_sql
# DECLARE t722_file_rvv_curs CURSOR FOR t722_file_rvv
# FOREACH t722_file_rvv_curs INTO l_rvv.*
#     IF STATUS THEN
#       LET g_success = 'N'
#       EXIT FOREACH
#     END IF
#      SELECT * INTO b_rvv.* FROM rvv_file WHERE rvv01=g_rvu01 AND rvv02=l_rvv.rvv02
#      LET b_rvv.rvv39  = l_rvv.rvv17a*b_rvv.rvv38
#      LET b_rvv.rvv39t = l_rvv.rvv17a*b_rvv.rvv38t
#      UPDATE rvv_file SET rvv17   = l_rvv.rvv17a,
#                          rvvud08 = l_rvv.rvv17,
#                          rvv87   = l_rvv.rvv17a,
#                          rvv39   = b_rvv.rvv39,
#                          rvv39t  = b_rvv.rvv39t
#      WHERE rvv01 = g_rvu01
#        AND rvv02 = l_rvv.rvv02
#      
#      IF SQLCA.SQLCODE THEN
#         LET g_status.code = SQLCA.SQLCODE
#         LET g_status.sqlcode = SQLCA.SQLCODE
#         LET g_success='N'
#         RETURN
#      END IF 

#   END FOREACH
   
   
   
   IF g_success='Y' THEN
   	  LET g_prog='apmt722'
   	  SELECT rvu08 INTO l_rvu08 FROM rvu_file WHERE rvu01=g_rvu01
      CALL t720sub_y_upd(g_rvu01,'3','',l_rvu08,'N',TRUE,'Y','N')
      LET g_prog='aws_ttsrv2'
   END IF

   IF g_success='Y' THEN
      CALL t722_ins_ibb(g_rvu01)
      IF g_success = 'N' THEN
         LET g_status.code = '-1'
         LET g_status.description="产生ibb_file有错误!"
      END IF 
   END IF
   IF g_success='Y' THEN
      CALL t722_ins_tlfb(g_rvu01)
      IF g_success = 'N' THEN
         LET g_status.code = '-1'
         LET g_status.description="产生tlfb_file有错误!"
      END IF 
   END IF
#   IF g_success='Y' THEN
#      IF l_rvu08='SUB' THEN
#   	      CALL t722_m(g_rvu01)
#      END IF
#   END IF
   IF g_success = "Y" THEN
      COMMIT WORK
   ELSE 
   	  ROLLBACK WORK
   END IF
END FUNCTION

FUNCTION t722_ins_tlfb(p_rvv01)
	DEFINE l_sql    STRING
	DEFINE p_rvv01  LIKE rvv_file.rvv01
	DEFINE l_rvv31   LIKE rvv_file.rvv31
	DEFINE l_n       LIKE type_file.num5
	INITIALIZE g_tlfb.* TO NULL

             LET l_sql="select * from t722_file"
             PREPARE t722_file_tlfb FROM l_sql
             DECLARE t722_file_tlfb_curs CURSOR FOR t722_file_tlfb
             FOREACH t722_file_tlfb_curs INTO g_tlfb.tlfb01,g_tlfb.tlfb02,g_tlfb.tlfb03,
                g_tlfb.tlfb04,l_rvv31,g_tlfb.tlfb05
                LET g_tlfb.tlfb07 = p_rvv01         #入库单号
                LET g_tlfb.tlfb08 = 0               #项次                              
                LET g_tlfb.tlfb09 = p_rvv01         #入库单号
                LET g_tlfb.tlfb10 = 0               #项次
                LET g_tlfb.tlfb06 = -1               #入库
                LET g_tlfb.tlfb14 = g_today         #扫描日期
                LET g_tlfb.tlfb17 = ' '             #杂收理由码
                LET g_tlfb.tlfb18 = ' '             #产品分类码
                LET g_tlfb.tlfb905 = g_tlfb.tlfb09
                LET g_tlfb.tlfb906 = g_tlfb.tlfb10             
                CALL s_web_tlfb('','','','','')  #更新条码异动档
                 
                 LET g_sql =" SELECT COUNT(*) FROM imgb_file ",
                            "WHERE imgb01='",g_tlfb.tlfb01,"'",
                            " AND imgb04='",g_tlfb.tlfb04,"'",
                            " AND imgb02='",g_tlfb.tlfb02,"'",
                            " AND imgb03='",g_tlfb.tlfb03,"'" 
                 PREPARE t003_imgb_pre FROM g_sql
                 EXECUTE t003_imgb_pre INTO l_n
                 IF l_n = 0 THEN #没有imgb_file，新增imgb_file
                    CALL s_ins_imgb(g_tlfb.tlfb01,
                          g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,g_tlfb.tlfb05,g_tlfb.tlfb06,'')
                    IF g_success = 'N' THEN
                       LET g_status.code = '9052'
                    END IF 
                  ELSE
                    CALL s_up_imgb(g_tlfb.tlfb01,    #更新条码库存档
                     g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,
                     g_tlfb.tlfb05,g_tlfb.tlfb06,'') 
                    IF g_success = 'N' THEN
                       LET g_status.code = '9050'
                    END IF 
                 END IF 
            END FOREACH
END FUNCTION

#FUNCTION t722_m(p_rvu01)                                                                                                                   
#  DEFINE li_result   LIKE type_file.num5
#  DEFINE p_rvu01     LIKE rvu_file.rvu01
#  DEFINE l_sfb39     LIKE sfb_file.sfb39
#  DEFINE g_factor    LIKE type_file.num5
#  DEFINE g_ima25     LIKE ima_file.ima25   
#  DEFINE l_rvv17_sum LIKE rvv_file.rvv17                                                                                      
#  DEFINE l_rvv    RECORD LIKE rvv_file.*,                                                                                           
#         l_sfa    RECORD LIKE sfa_file.*,                                                                                           
#         l_sfs    RECORD LIKE sfs_file.*,                                                                                           
#         l_qpa    LIKE sfa_file.sfa161,                                                                                             
#         l_qty    LIKE sfs_file.sfs05,                                                                                                                                                                                           
#         g_t1     LIKE oay_file.oayslip,                                                                                            
#         l_flag   LIKE type_file.chr1,                                                                                              
#         l_name   LIKE type_file.chr20,                                                                                             
#         l_sfp    RECORD                                                                                                            
#               sfp01   LIKE sfp_file.sfp01,                                                                                         
#               sfp02   LIKE sfp_file.sfp02,                                                                                         
#               sfp03   LIKE sfp_file.sfp03,                                                                                         
#               sfp04   LIKE sfp_file.sfp04,                                                                                         
#               sfp05   LIKE sfp_file.sfp05,                                                                                         
#               sfp06   LIKE sfp_file.sfp06,                                                                                         
#               sfp07   LIKE sfp_file.sfp07                                                                                          
#                  END RECORD,                                                                                                       
#         l_sfb81  LIKE sfb_file.sfb81,                                                                                              
#         l_sfb82  LIKE sfb_file.sfb82,                                                                                              
#         l_bdate  LIKE type_file.dat, 
#         l_edate  LIKE type_file.dat,                                                                                               
#         l_day    LIKE type_file.num5,                                                                                              
#         l_cnt    LIKE type_file.num5                                                                                               
#  DEFINE l_sfv11 LIKE sfv_file.sfv11                                                                                                
#  DEFINE l_msg  LIKE type_file.chr1000                                                                                              
#  DEFINE l_sfb04  LIKE sfb_file.sfb04                                                                                               
#  DEFINE l_sfb02  LIKE sfb_file.sfb02                                                                                               
#  DEFINE l_sfp02  LIKE sfp_file.sfp02                                                                                               
#  DEFINE g_ima55  LIKE ima_file.ima55  
#  DEFINE l_pmn43  LIKE pmn_file.pmn43   #FUN-A60076
#  DEFINE l_pmn012 LIKE pmn_file.pmn012  #FUN-A60076
#  DEFINE g_rvu    RECORD LIKE rvu_file.*
#  
#     SELECT * INTO g_rvu.* FROM rvu_file                                                                           
#     WHERE rvu01 = p_rvu01                                                                                           
##...check是否是倒扣料                                                                    
#    SELECT COUNT(*) INTO l_cnt FROM rvv_file,sfb_file                                                                               
#     WHERE rvv01 = g_rvu.rvu01                                                                                                      
#       AND rvv18 = sfb01                                                    
#    IF l_cnt = 0 THEN RETURN  END IF                                                                                                                                                                                
#                                                                                                                                    
#    LET l_flag =' '                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
#    #新增一筆資料
#    SELECT tc_codesys03 INTO g_rvu.rvu16 FROM tc_codesys_file WHERE tc_codesys00='0'                                                                                                                                                                                                                 
#       CALL s_auto_assign_no("asf",g_rvu.rvu16,g_rvu.rvu03,"","sfp_file","sfp01","","","")                                          
#         RETURNING li_result,g_rvu.rvu16                                                                                            
#       IF (NOT li_result) THEN                                                                                                      
#   	      LET g_status.code = -1
#          LET g_status.sqlcode = SQLCA.SQLCODE
#          LET g_status.description="产生rvu16领料单号有错误!"
#          LET g_success='N'
#          RETURN                                                                                                                    
#       END IF                                                                                                                                                                                                                                                                                                                                   
##      #----先檢查領料單身資料是否已經存在------------                                                                               
##       DECLARE count_cur CURSOR FOR
##           SELECT COUNT(*) FROM sfs_file                                                                                            
##       WHERE sfs01 = g_rvu.rvu16                                                                                                        
##       OPEN count_cur                                                                                                               
##       FETCH count_cur INTO g_cnt                                                                                                   
##       IF g_cnt > 0  THEN  #已存在                                                                                                  
##          LET l_flag ='Y'                                                                                                           
##       ELSE                                                                                                                         
##          LET l_flag ='N'                                                                                                           
##       END IF                                                                                                                       
#       #-----------產生領料資料------------------------                                                                             
#       DECLARE t720_rvv_cur CURSOR  WITH HOLD FOR                                                                                   
#          SELECT *  FROM  rvv_file                                                                                                  
#           WHERE rvv01 = g_rvu.rvu01                                                                                                
#       LET l_cnt = 0                                                                                                                                                                                                            
#       FOREACH t720_rvv_cur INTO l_rvv.*                                                                                            
#         IF STATUS THEN                                                                                                                                                                                                             
#            EXIT FOREACH
#         END IF                                                                                                                     
#         SELECT sfb04,sfb81,sfb02,sfb39                                                                                                   
#           INTO l_sfb04,l_sfb81,l_sfb02,l_sfb39                                                                                            
#           FROM sfb_file                                                                                                            
#          WHERE sfb01 = l_rvv.rvv18                                                                                                                                                                                                                               
#         IF STATUS THEN                                                                                                             
#             LET g_status.code = -1
#             LET g_status.sqlcode = SQLCA.SQLCODE
#             LET g_status.description="入库单中对应工单不存在!"
#             LET g_success='N'
#             RETURN                                                                                                       
#         END IF                                                                                                                     
#                                                                                                                                    
#         IF l_sfb04='1' THEN                                                                                                        
#             CONTINUE FOREACH                                                                     
#         END IF                                                                                                                     
#                                                                                                                                    
#         IF l_sfb04='8' THEN                                                                                                        
#             CONTINUE FOREACH                                                                     
#         END IF                                                                                                                     
#         IF l_sfb39='1' THEN
#         	   CONTINUE FOREACH
#         END IF                                                                                                                            
#                                                                                                                                    
#         IF l_sfb02=13 THEN
#            CONTINUE FOREACH                                                                    
#         END IF                                                                                                                     
#         DECLARE t720_sfs_cur CURSOR WITH HOLD FOR                                                                                  
#         SELECT sfa_file.*,sfb82 FROM sfb_file,sfa_file                                                                             
#          WHERE sfb01 = l_rvv.rvv18   #工單單號                                                                                     
#            AND sfb01 = sfa01                                                                                                       
#            #AND sfa11 = 'E'                                                                                                         
#            ORDER BY sfa26                                                                                                                                                                                                             
#        FOREACH t720_sfs_cur INTO l_sfa.*,l_sfb82                                                                                   
#            INITIALIZE l_sfs.* TO NULL                                                                                              
#            INITIALIZE l_sfp.* TO NULL                                                                                              
#                                                                                                                                    
#        #-------發料單頭--------------                                                                                              
#          LET l_sfp.sfp01 = g_rvu.rvu16                                                                                                 
##領料單月份以完工入庫日期該月的最後一天為領料日                                                                                     
#          LET l_sfp.sfp02 = g_today                                                                                                 
#          LET l_sfp.sfp03 = g_today                                                                                                 
#          IF MONTH(g_today) != MONTH(g_rvu.rvu03) THEN                                                                              
#             IF MONTH(g_rvu.rvu03) = 12 THEN                                                                                        
#                LET l_bdate = MDY(MONTH(g_rvu.rvu03),1,YEAR(g_rvu.rvu03))                                                           
#                LET l_edate = MDY(1,1,YEAR(g_rvu.rvu03)+1)  
#             ELSE                                                                                                                   
#                LET l_bdate = MDY(MONTH(g_rvu.rvu03),1,YEAR(g_rvu.rvu03))                                                           
#                LET l_edate = MDY(MONTH(g_rvu.rvu03)+1,1,YEAR(g_rvu.rvu03))                                                         
#             END IF                                                                                                                 
#             LET l_day = l_edate - l_bdate   #計算最後一天日期                                                                      
#             LET l_sfp.sfp03 = MDY(MONTH(g_rvu.rvu03),l_day,YEAR(g_rvu.rvu03))                                                      
#          END IF                                                                                                                    
#          LET l_sfp.sfp04 = 'N'                                                                                                     
#          LET l_sfp.sfp05 = 'N'                                                                                                     
#          LET l_sfp.sfp06 ='4'                                                                                                      
#          LET l_sfp.sfp07 = l_sfb82
#          #----先檢查領料單身資料是否已經存在------------ 
#          DECLARE count_cur CURSOR FOR
#          SELECT COUNT(*) FROM sfs_file                                                                                            
#          WHERE sfs01 = g_rvu.rvu16                                                                                                        
#          OPEN count_cur                                                                                                               
#          FETCH count_cur INTO g_cnt                                                                                                   
#          IF g_cnt > 0  THEN  #已存在                                                                                                  
#             LET l_flag ='Y'                                                                                                           
#          ELSE                                                                                                                         
#             LET l_flag ='N'                                                                                                           
#          END IF                                                                                                
#          IF l_flag ='Y' THEN                                                 
#            UPDATE sfp_file SET sfp02= l_sfp.sfp02,                                                                                       
#                             sfp04= l_sfp.sfp04,sfp05 = l_sfp.sfp05,                                                                      
#                             sfp06= l_sfp.sfp06,sfp07 = l_sfp.sfp07,                                                                      
#                             sfpgrup=g_grup,sfpconf='Y',                                                                                        
#                             sfpmodu=g_user,sfpdate=g_today 
#            WHERE sfp01 = l_sfp.sfp01                                                                                                    
#            IF SQLCA.sqlcode THEN
#            	 LET g_status.code = -1
#               LET g_status.sqlcode = SQLCA.SQLCODE
#               LET g_status.description="更新发料单头有错误!"
#            	 LET g_success='N'
#            	 RETURN
#            END IF                                                                             
#          ELSE                                                                                                                          
#           INSERT INTO sfp_file(sfp01,sfp02,sfp03,sfp04,sfp05,sfp06,sfp07,sfp09,                                                      
#                              sfpuser,sfpdate,sfpconf,sfpgrup,sfpplant,sfplegal,sfporiu,sfporig)                                                                      
#              VALUES(l_sfp.sfp01,l_sfp.sfp02,l_sfp.sfp03,l_sfp.sfp04,                                                                           
#                     l_sfp.sfp05,l_sfp.sfp06,l_sfp.sfp07,'N',                                                                                
#                     g_user,g_today,'Y',g_grup,g_plant,g_legal, g_user, g_grup)                                                                                           #No.FUN-980030 10/01/04  insert columns oriu, orig
#            IF SQLCA.sqlcode THEN
#            	 LET g_status.code = -1
#               LET g_status.sqlcode = SQLCA.SQLCODE
#               LET g_status.description="插入发料单头有错误!" 
#           	   LET g_success='N'
#           	   RETURN 
#            END IF                                                                             
#          END IF                                                                                
#          SELECT MAX(sfs02) INTO l_cnt FROM sfs_file                                                                                
#           WHERE sfs01 = g_rvu.rvu16                                                                                                    
#          IF l_cnt IS NULL THEN    #項次                                                                                            
#             LET l_cnt = 1                                                                                                          
#          ELSE  LET l_cnt = l_cnt + 1                                                                                            
#          END IF                                                                                                                    
#         #-------發料單身--------------                                                                                             
#          LET l_sfs.sfs01 = g_rvu.rvu16                                                                                                 
#          LET l_sfs.sfs02 = l_cnt                                                                                                   
#          LET l_sfs.sfs03 = l_sfa.sfa01
#          LET l_sfs.sfs04 = l_sfa.sfa03                                                                                             
#          #LET l_sfs.sfs05 = l_rvv.rvv09*l_sfa.sfa161 #已發料量   #MOD-A70228                                                                     
#          LET l_sfs.sfs05 = l_rvv.rvv17*l_sfa.sfa161 #已發料量   #MOD-A70228                                                                     
#          LET l_sfs.sfs06 = l_sfa.sfa12  #發料單位                                                                                  
#          LET l_sfs.sfs07 = l_sfa.sfa30  #倉庫                                                                                      
#          LET l_sfs.sfs08 = l_sfa.sfa31  #儲位                                                                                      
#          LET l_sfs.sfs09 = ' '          #批號                                                                                      
#          LET l_sfs.sfs10 = l_sfa.sfa08  #作業序號                                                                                  
#          LET l_sfs.sfs26 = NULL         #替代碼                                                                      
#          LET l_sfs.sfs27 = NULL         #被替代料號                                                                                
#          LET l_sfs.sfs28 = NULL         #替代率                                                                                    
#          LET l_sfs.sfs930 = l_rvv.rvv930                                                                                           
#          LET l_sfs.sfsplant = g_plant
#          LET l_sfs.sfslegal = g_legal
#          LET l_sfs.sfs012 = l_sfa.sfa012  #FUN-A60076
#          LET l_sfs.sfs013 = l_sfa.sfa013  #FUN-A60076
#         #IF l_sfa.sfa26 MATCHES '[SUT]' THEN      #FUN-A20037 
#          IF l_sfa.sfa26 MATCHES '[SUTZ]' THEN      #FUN-A20037 
#             LET l_sfs.sfs26 = l_sfa.sfa26                                                                                          
#             LET l_sfs.sfs27 = l_sfa.sfa27                                                                                          
#             LET l_sfs.sfs28 = l_sfa.sfa28                                                                                          
#             #FUN-A60076 --------------------------start--------------------- 
#             SELECT pmn43,pmn012 INTO l_pmn43,l_pmn012 FROM pmn_file
#              WHERE pmn01 = l_rvv.rvv36 
#                AND pmn02 = l_rvv.rvv37
#             #FUN-A60076 -------------------------end------------------------ 
#             SELECT (sfa161 * sfa28) INTO l_qpa FROM sfa_file                                                                       
#                WHERE sfa01 = l_sfa.sfa01 AND sfa03 = l_sfa.sfa27                                                                   
#                  AND sfa012 = l_pmn012 AND sfa013  = l_pmn43   #FUN-A60076
#             #LET l_sfs.sfs05 = l_rvv.rvv09*l_qpa   #MOD-A70228                                                                                 
#             LET l_sfs.sfs05 = l_rvv.rvv17*l_qpa   #MOD-A70228                                                                                 
#             SELECT SUM(c) INTO l_qty FROM tmp WHERE a = l_sfa.sfa01                                                                
#                AND b = l_sfa.sfa27                                                                                                 
#             IF l_sfs.sfs05 < l_qty THEN                                                                                            
#                LET l_sfs.sfs05 = 0 
#             ELSE                                                                                                                   
#                LET l_sfs.sfs05 = l_sfs.sfs05 - l_qty                                                                               
#             END IF                                                                                                                 
#          ELSE                                                                                                                      
#             LET l_sfs.sfs27 = l_sfa.sfa27                                                                                          
#          END IF                                                                                                                    
#          CALL t722_chk_ima64(l_sfs.sfs04, l_sfs.sfs05) RETURNING l_sfs.sfs05                                                       
#        #判斷發料是否大於可發料數(sfa05-sfa06)                                                                                      
#          IF l_sfs.sfs05 > (l_sfa.sfa05 - l_sfa.sfa06) THEN                                                                         
#             LET l_sfs.sfs05 = l_sfa.sfa05 - l_sfa.sfa06                                                                            
#          END IF                                                                                                                    
#          IF cl_null(l_sfs.sfs07) AND cl_null(l_sfs.sfs08) THEN                                                                     
#             SELECT ima35,ima36 INTO  l_sfs.sfs07,l_sfs.sfs08                                                                       
#               FROM ima_file                                                                                                        
#              WHERE ima01 = l_sfs.sfs04                                                                                             
#          END IF              
#          SELECT tc_sub02 INTO l_sfs.sfs07 FROM tc_sub_file WHERE tc_sub01=g_rvu.rvu04
#          LET l_sfs.sfs08=' ' 
#          LET l_sfs.sfs09=' '                                                                                                  
#          IF l_sfs.sfs07 IS NULL THEN LET l_sfs.sfs07 = ' ' END IF                                                                  
#          IF l_sfs.sfs08 IS NULL THEN LET l_sfs.sfs08 = ' ' END IF                                                                  
#          IF l_sfs.sfs09 IS NULL THEN LET l_sfs.sfs09 = ' ' END IF                                                                  
#          INSERT INTO tmp                                                                                                           
#            VALUES(l_sfa.sfa01,l_sfa.sfa27,l_sfs.sfs05)                                                                             
#        IF g_sma.sma115 = 'Y' THEN 
#             SELECT ima25,ima55,ima906,ima907                                                                                       
#               INTO g_ima25,g_ima55,g_ima906,g_ima907                                                                               
#               FROM ima_file                                                                                                        
#              WHERE ima01=l_sfs.sfs04                                                                                               
#             IF SQLCA.sqlcode THEN
#             	   LET g_status.code = -1
#                 LET g_status.sqlcode = SQLCA.SQLCODE
#                 LET g_status.description="料件基础数据有误,ima25,ima55,ima906,ima907!" 
#                 LET g_success = 'N'
#                 RETURN                                                                                               
#             END IF                                                                                                                 
#             IF cl_null(g_ima55) THEN LET g_ima55 = g_ima25 END IF                                                                  
#             LET l_sfs.sfs30=l_sfs.sfs06                                                                                            
#             LET g_factor = 1                                                                                                       
#             CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs30,g_ima55)                                                                         
#               RETURNING g_cnt,g_factor                                                                                             
#             IF g_cnt = 1 THEN                                                                                                      
#                LET g_factor = 1                                                                                                    
#             END IF                                                                                                                 
#             LET l_sfs.sfs31=g_factor                                                                                               
#             LET l_sfs.sfs32=l_sfs.sfs05                                                                                            
#             LET l_sfs.sfs33=g_ima907                                                                                               
#             LET g_factor = 1                                                                                                       
#             CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs33,g_ima55) 
#               RETURNING g_cnt,g_factor                                                                                             
#             IF g_cnt = 1 THEN                                                                                                      
#                LET g_factor = 1                                                                                                    
#             END IF                                                                                                                 
#             LET l_sfs.sfs34=g_factor                                                                                               
#             LET l_sfs.sfs35=0                                                                                                      
#             IF g_ima906 = '3' THEN                                                                                                 
#                LET g_factor = 1                                                                                                    
#                CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs30,l_sfs.sfs33)                                                                  
#                  RETURNING g_cnt,g_factor                                                                                          
#                IF g_cnt = 1 THEN                                                                                                   
#                   LET g_factor = 1                                                                                                 
#                END IF                                                                                                              
#                LET l_sfs.sfs35=l_sfs.sfs32*g_factor                                                                                
#             END IF                                                                                                                 
#             IF g_ima906='1' THEN                                                                                                   
#                LET l_sfs.sfs33=NULL                                                                                                
#                LET l_sfs.sfs34=NULL                                                                                                
#                LET l_sfs.sfs35=NULL                                                                                                
#             END IF                                                                                                                 
#        END IF                                                                                            
#        INSERT INTO sfs_file VALUES (l_sfs.*)                                                                                   
#            IF STATUS OR SQLCA.sqlerrd[3]=0 THEN                                                                                    
#               LET g_status.code = -1
#               LET g_status.sqlcode = SQLCA.SQLCODE
#               LET g_status.description="插入发料单身sfs有错误!" 
#           	   LET g_success='N'                                                                                                                                                                                     
#            END IF                                                                                                                     
#         SELECT SUM(rvv17) INTO l_rvv17_sum FROM rvv_file,rvu_file 
#         WHERE rvv18=l_rvv.rvv18 AND rvu01=rvv01 AND rvuconf='Y'
#         
#         UPDATE sfb_file SET sfb081=l_rvv17_sum+l_rvv.rvv17
#         WHERE sfb01=l_rvv.rvv18                                                                                                              
#       END FOREACH                                                                                                                  
#     END FOREACH                                                                                                                                                                                                                       
#                                                                                                   
#                                                                                                   
#        UPDATE rvu_file SET rvu16 = g_rvu.rvu16                                                                                  
#         WHERE rvu01 = g_rvu.rvu01                                                                                                  
#        IF STATUS THEN                                                                                                              
#           CALL cl_err('upd rvu',STATUS,1)                                                                                          
#           LET g_success = 'N'     
#           LET g_status.code = '-1'
#           LET g_status.description = '更新rvu_file失败'                                                                                                 
#        END IF                                                                                                                      
#        #CALL i501sub_s(1,g_rvu.rvu16,TRUE,'N') #add by shenran暂时mark
#                                                                                                                                                                                                                                                
#END FUNCTION                            

FUNCTION t722_chk_ima64(p_part, p_qty)                                                                                        
  DEFINE p_part         LIKE ima_file.ima01                                                                                         
  DEFINE p_qty          LIKE ima_file.ima641                                                                                        
  DEFINE l_ima108       LIKE ima_file.ima108                                                                                        
  DEFINE l_ima64        LIKE ima_file.ima64                                                                                         
  DEFINE l_ima641       LIKE ima_file.ima641                                                                                        
  DEFINE i              LIKE type_file.num10                                                                                        
                                                                                                                                    
  SELECT ima108,ima64,ima641 INTO l_ima108,l_ima64,l_ima641 FROM ima_file
   WHERE ima01=p_part                                                                                                               
  IF STATUS THEN RETURN p_qty END IF                                                                                                
                                                                                                                                    
  IF l_ima108='Y' THEN RETURN p_qty END IF                                                                                          
                                                                                                                                    
  IF l_ima641 != 0 AND p_qty<l_ima641 THEN                                                                                          
     LET p_qty=l_ima641                                                                                                             
  END IF                                                                                                                            
                                                                                                                                    
  IF l_ima64<>0 THEN                                                                                                                
     LET i=p_qty / l_ima64 + 0.999999                                                                                               
     LET p_qty= i * l_ima64                                                                                                         
  END IF                                                                                                                            
  RETURN p_qty                                                                                                                      
END FUNCTION 
	
FUNCTION t722_ins_ibb(p_rvu01)
  DEFINE p_rvu01 LIKE rvu_file.rvu01
  DEFINE l_barcode,l_rvv31,l_lotnumber varchar(100)
  DEFINE l_rvv17 DECIMAL(15,3)
  DEFINE l_sql STRING
  DEFINE l_ibb RECORD LIKE ibb_file.*
  DEFINE l_iba RECORD LIKE iba_file.*
  DEFINE l_n,l_t LIKE type_file.num5

 #增加条码基本档---hxy160510------beg----------
 LET l_barcode=''
 LET l_rvv31=''
 LET l_lotnumber=''
 LET l_rvv17=''
 INITIALIZE l_iba.* TO NULL
 INITIALIZE l_ibb.* TO NULL
 LET l_sql=" select barcode,rvv31,batch,rvv17b",
           " from t722_file "
           PREPARE t722_filee1 FROM l_sql
           DECLARE t722_filee_curs1 CURSOR FOR t722_filee1
           FOREACH t722_filee_curs1 INTO l_barcode,l_rvv31,l_lotnumber,l_rvv17
             IF STATUS THEN
               LET g_status.code = -1
               LET g_status.description="产生iba_file有错误!"
             END IF 
 SELECT COUNT(*) INTO l_n FROM iba_file WHERE iba01=l_barcode
 SELECT COUNT(*) INTO l_t FROM ibb_file WHERE ibb01=l_barcode
 IF cl_null(l_n) THEN LET l_n=0 END IF
 IF cl_null(l_t) THEN LET l_t=0 END IF
 IF l_n=0 AND l_t=0 THEN
    LET l_iba.iba01=l_barcode
    INSERT INTO iba_file VALUES(l_iba.*)
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        LET g_status.code = -1
        LET g_status.sqlcode = SQLCA.SQLCODE
        LET g_status.description="产生iba_file有错误!"
        LET g_success = 'N'
        RETURN
    END IF
    LET l_ibb.ibb01=l_barcode                 #条码编号
    LET l_ibb.ibb02='R'                     #条码产生时机点
    LET l_ibb.ibb03=p_rvu01             #来源单号
    LET l_ibb.ibb04=0                       #来源项次
    LET l_ibb.ibb05=0                       #包号
    LET l_ibb.ibb06=l_rvv31                 #料号
    LET l_ibb.ibb11='Y'                     #使用否
    LET l_ibb.ibb12=0                       #打印次数
    LET l_ibb.ibb13=0                       #检验批号(分批检验顺序)
    LET l_ibb.ibbacti='Y'                   #资料有效码
   # LET l_ibb.ibb17=l_lotnumber                 #批号
   # LET l_ibb.ibb14=l_rvv17                 #数量
   # LET l_ibb.ibb20=g_today                 #生成日期
    INSERT INTO ibb_file VALUES(l_ibb.*)
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        LET g_status.code = -1
        LET g_status.sqlcode = SQLCA.SQLCODE
        LET g_status.description="产生ibb_file有错误!"
        LET g_success = 'N'
       RETURN
    END IF
 END IF
 END FOREACH
 #增加条码基本档---hxy160510------end----------                


END FUNCTION

FUNCTION aws_apmt722_temp_table()
DEFINE l_sql    STRING 
  DROP TABLE apmt722_temp
    LET l_sql ="CREATE GLOBAL TEMPORARY TABLE apmt722_temp AS SELECT * FROM rvv_file WHERE 1=0"
    PREPARE work_tab FROM l_sql
    EXECUTE work_tab 
END FUNCTION


