# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Descriptions...: 完工入库扫描作业
# Date & Author..: 2016-04-11 13:17:31 shenran


DATABASE ds

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

GLOBALS "../../aba/4gl/barcode.global"



GLOBALS
DEFINE g_sfu01    LIKE sfu_file.sfu01    #入库单号
DEFINE g_sfv04    LIKE sfv_file.sfv04    #料号
DEFINE g_ima02    LIKE ima_file.ima02    #品名
DEFINE g_sfv09    LIKE sfv_file.sfv09    #可入库量
DEFINE g_sfv09a   LIKE sfv_file.sfv09    #实际入库量
DEFINE g_in       LIKE rvv_file.rvv17
DEFINE g_rva01    LIKE rva_file.rva01
DEFINE li_result  LIKE type_file.num5
DEFINE g_yy,g_mm   LIKE type_file.num5 
DEFINE g_img09_t LIKE img_file.img09
DEFINE g_i       LIKE type_file.num5
DEFINE g_ima907  LIKE ima_file.ima907
DEFINE g_gec07   LIKE gec_file.gec07
DEFINE g_sql      STRING
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
FUNCTION aws_update_asft620()
 
 WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增完工入庫單資料                                                       #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_update_asft620_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
     DROP TABLE asft620_file
     DROP TABLE asft620_temp
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
FUNCTION aws_update_asft620_process()
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
   DEFINE l_asft620_file      RECORD                        #单身
                    sfv05      LIKE sfv_file.sfv05,         #仓库
                    sfv06      LIKE sfv_file.sfv06,         #库位
                    ibb01      LIKE ibb_file.ibb01,         #批次条码
                    ima01      LIKE ima_file.ima01,         #料件编码
                    sfv07      LIKE sfv_file.sfv07,         #批次
                    sfv09b     LIKE sfv_file.sfv09          #数量
                 END RECORD
   DROP TABLE asft620_file

   CREATE TEMP TABLE asft620_file(
                    sfv05      LIKE sfv_file.sfv05,         #仓库
                    sfv06      LIKE sfv_file.sfv06,         #库位
                    ibb01      LIKE ibb_file.ibb01,         #批次条码
                    ima01      LIKE ima_file.ima01,         #料件编码
                    sfv07      LIKE sfv_file.sfv07,         #批次
                    sfv09b     LIKE sfv_file.sfv09)         #数量             
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的完工入庫單資料                                    #
    #--------------------------------------------------------------------------#
    LET g_success = 'Y'

    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("Master")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***

    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       LET g_success='N'
       RETURN
    END IF


    FOR l_i = 1 TO l_cnt1
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "Master")       #目前處理單檔的 XML 節點
        
        LET g_sfu01   = aws_ttsrv_getRecordField(l_node1,"sfu01")
        LET g_sfv04   = aws_ttsrv_getRecordField(l_node1,"sfv04")
        LET g_ima02   = aws_ttsrv_getRecordField(l_node1,"ima02")
        LET g_sfv09   = aws_ttsrv_getRecordField(l_node1,"sfv09")
        LET g_sfv09a  = aws_ttsrv_getRecordField(l_node1,"sfv09a")       

        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "Detail")       #取得目前單頭共有幾筆單身資料
        IF l_cnt2 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           LET g_success='N'
           EXIT FOR
        END IF                
        FOR l_j = 1 TO l_cnt2
            INITIALIZE l_asft620_file.* TO NULL
            LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j,"Detail")   #目前單身的 XML 節點

            LET l_asft620_file.sfv05  = aws_ttsrv_getRecordField(l_node2, "sfv05")
            LET l_asft620_file.sfv06  = aws_ttsrv_getRecordField(l_node2, "sfv06")
            LET l_asft620_file.ibb01  = aws_ttsrv_getRecordField(l_node2, "ibb01")
            LET l_asft620_file.ima01  = aws_ttsrv_getRecordField(l_node2, "ima01")
            LET l_asft620_file.sfv07  = aws_ttsrv_getRecordField(l_node2, "sfv07")
            LET l_asft620_file.sfv09b = aws_ttsrv_getRecordField(l_node2, "sfv09b")
            INSERT INTO asft620_file VALUES (l_asft620_file.*)
        END FOR
    END FOR
    IF g_success = 'Y' THEN 
       CALL i620_load()
#       IF g_success = 'Y' THEN
#         
#       ELSE
#       	  IF g_status.code='0' THEN
#            LET g_status.code = "-1"
#            LET g_status.description = "接口程序存在错误，请程序员检查，谢谢!"
#          END IF
#       END IF
    END IF
END FUNCTION
FUNCTION i620_load()
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_img09     LIKE img_file.img09

   LET g_success = "Y"
   BEGIN WORK
   CALL i620_ins_sfu()

   IF g_success = 'Y' THEN
      LET g_prog='asft620'
      CALL t620sub_s(g_sfu01,"1",TRUE,'')  #过账
      IF g_success = 'Y' THEN  #FUN-840012
         SELECT COUNT(*) INTO g_cnt FROM sfv_file,sfa_file
            WHERE sfv01 = g_sfu01
            AND sfv11 = sfa01 AND sfa11 = 'E'
         IF g_cnt > 0 THEN
            CALL t620_k_app()
         END IF  
      ELSE 
      	 LET g_status.code = '-1' 
         LET g_status.description = '入库单过账失败'
      END IF
   END IF
   IF g_success = "Y" THEN
      COMMIT WORK
   ELSE 
   	  ROLLBACK WORK
   END IF
END FUNCTION
FUNCTION i620_ins_sfu()   #No.MOD-8A0112 add
   DEFINE l_sfu       RECORD LIKE sfu_file.*,
          l_sfv       RECORD LIKE sfv_file.*,
          l_iba       RECORD LIKE iba_file.*,
          l_ibb       RECORD LIKE ibb_file.*,
          l_smy57     LIKE type_file.chr1     # Prog. Version..: '5.20.02-10.08.05(01)   #MOD-740033 modify
   DEFINE li_result   LIKE type_file.num5      #No.FUN-540027  #No.FUN-680136 SMALLINT
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_n,l_t     LIKE type_file.num5
   DEFINE p_chr       LIKE type_file.chr1      #No.MOD-8A0112 add
   DEFINE l_rvb01     LIKE rvb_file.rvb01
   DEFINE l_ima01     LIKE ima_file.ima01
   DEFINE l_sfv05     LIKE sfv_file.sfv05
   DEFINE l_sfv09     LIKE sfv_file.sfv09
   DEFINE l_ibb01     LIKE ibb_file.ibb01
   DEFINE l_sfv07     LIKE sfv_file.sfv07
   DEFINE l_sql       STRING
####add by nihuan 20170614------start-----------
   DEFINE l_sfv06     LIKE sfv_file.sfv06,
          l_sfv04     LIKE sfv_file.sfv04,
          l_sum       LIKE sfv_file.sfv09
   DEFINE l_img09     LIKE img_file.img09
   DEFINE l_ima44   LIKE ima_file.ima44      #No.FUN-540027       
####add by nihuan 20170614------end-------------   
   
   DEFINE l_asft620_sr      RECORD                          #单身
                    sfv05      LIKE sfv_file.sfv05,         #仓库
                    sfv06      LIKE sfv_file.sfv06,         #库位
                    ibb01      LIKE ibb_file.ibb01,         #批次条码
                    ima01      LIKE ima_file.ima01,         #料件编码
                    sfv07      LIKE sfv_file.sfv07,         #批次
                    sfv09b     LIKE sfv_file.sfv09          #数量
                 END RECORD
     #----單頭
     INITIALIZE l_sfu.* TO NULL
     INITIALIZE l_sfv.* TO NULL
     INITIALIZE l_asft620_sr.* TO NULL
     INITIALIZE g_tlfb.* TO NULL

     UPDATE sfv_file SET sfv09=g_sfv09a WHERE sfv01=g_sfu01
####add by nihuan 20170614------start------------------------------     
     DROP TABLE asft620_temp
     LET l_sql ="CREATE GLOBAL TEMPORARY TABLE asft620_temp AS SELECT * FROM sfv_file WHERE 1=2"
     PREPARE asft620_work_tab FROM l_sql
     EXECUTE asft620_work_tab
     
     LET l_sql="insert into asft620_temp select * from sfv_file where sfv01='",g_sfu01,"'"
     PREPARE asft620_temp_ins FROM l_sql
     EXECUTE asft620_temp_ins
     
     DELETE FROM sfv_file WHERE sfv01=g_sfu01
#   CREATE TEMP TABLE asft620_file(
#                    sfv05      LIKE sfv_file.sfv05,         #仓库
#                    sfv06      LIKE sfv_file.sfv06,         #库位
#                    ibb01      LIKE ibb_file.ibb01,         #批次条码
#                    ima01      LIKE ima_file.ima01,         #料件编码
#                    sfv07      LIKE sfv_file.sfv07,         #批次
#                    sfv09b     LIKE sfv_file.sfv09)         #数量    
     LET l_sql="select sfv05,sfv06,ibb01,ima01,sfv07,sum(sfv09b) from asft620_file
                group by sfv05,sfv06,ibb01,ima01,sfv07"  
     PREPARE t620_sfv_nh FROM l_sql
     DECLARE t620_sfv_curs_nh CURSOR FOR t620_sfv_nh
     FOREACH t620_sfv_curs_nh INTO l_sfv05,l_sfv06,l_ibb01,l_sfv04,l_sfv07,l_sum
        IF l_sum=0 THEN 
           CONTINUE FOREACH 
        END IF 	
        
        LET l_sql="select * from asft620_temp
                   where sfv01='",g_sfu01,"' and sfv04='",l_sfv04,"' and sfv09>0
                   order by sfv03"
        PREPARE t620_sfv_hn FROM l_sql
        DECLARE t620_sfv_curs_hn CURSOR FOR t620_sfv_hn
        FOREACH t620_sfv_curs_hn INTO l_sfv.*
           IF l_sum=0 THEN #数量必相等
              EXIT FOREACH 
           END IF 	
           
           IF l_sum>=l_sfv.sfv09 THEN 
           	  LET l_sum=l_sum-l_sfv.sfv09
           	  UPDATE asft620_temp SET sfv09=0
           	  WHERE sfv01=l_sfv.sfv01 AND sfv03=l_sfv.sfv03
           ELSE	 
           	  UPDATE asft620_temp SET sfv09=l_sfv.sfv09-l_sum
          	  WHERE sfv01=l_sfv.sfv01 AND sfv03=l_sfv.sfv03
          	  LET l_sfv.sfv09=l_sum
          	  LET l_sum=0
           END IF
           	
           SELECT MAX(nvl(sfv03,0))+1 INTO l_sfv.sfv03
           FROM sfv_file WHERE sfv01=g_sfu01
           IF cl_null(l_sfv.sfv03) THEN 
              LET l_sfv.sfv03 =1
           END IF	 
           
           LET l_sfv.sfv05=l_sfv05    #仓库
           LET l_sfv.sfv06=l_sfv06    #库位
           LET l_sfv.sfv07=l_sfv07    #批号
           
           
           SELECT img09 INTO g_img09_t FROM img_file
           WHERE img01 = l_sfv.sfv04
             AND img02 = l_sfv.sfv05
             AND img03 = l_sfv.sfv06
             AND img04 = l_sfv.sfv07
           IF STATUS=100 AND (l_sfv.sfv05 IS NOT NULL AND l_sfv.sfv05 <> ' ') THEN
              CALL s_add_img(l_sfv.sfv04,
                             l_sfv.sfv05,
                             l_sfv.sfv06,
                             l_sfv.sfv07,
                             l_sfv.sfv01,l_sfv.sfv03,
                             g_today)
           END IF
           LET g_ima906 = NULL
           LET g_ima907 = NULL
           SELECT ima906,ima907 INTO g_ima906,g_ima907 FROM ima_file
            WHERE ima01=l_sfv.sfv04
            
           SELECT ima44 INTO l_ima44 FROM ima_file WHERE ima01=l_sfv.sfv04
           IF g_sma.sma115 = 'Y' AND g_ima906 MATCHES '[23]' THEN
              IF NOT cl_null(l_sfv.sfv33) THEN
                    CALL s_chk_imgg(l_sfv.sfv04,l_sfv.sfv05,
                       l_sfv.sfv06,l_sfv.sfv07,
                       l_sfv.sfv33) RETURNING g_flag
                    IF g_flag = 1 THEN
                       CALL s_add_imgg(l_sfv.sfv04,l_sfv.sfv05,
                                       l_sfv.sfv06,l_sfv.sfv07,
                                       l_sfv.sfv33,l_sfv.sfv34,
                                       l_sfv.sfv01,l_sfv.sfv03,0) RETURNING g_flag
                       IF g_flag = 1 THEN
                       	   LET g_status.code = -1
                           LET g_status.sqlcode = SQLCA.SQLCODE
                           LET g_status.description="产生imgg_file有错误!"
                           LET g_success = 'N'
                           RETURN
                       END IF
                    END IF
              
                    CALL s_du_umfchk(l_sfv.sfv04,'','','',l_ima44,l_sfv.sfv33,g_ima906)
                         RETURNING g_errno,l_sfv.sfv34
              
                    IF NOT cl_null(g_errno) THEN
                    	  LET g_status.code = -1
                        LET g_status.sqlcode = SQLCA.SQLCODE
                        LET g_status.description="单位换算率抓不到!"
                        LET g_success = 'N' 
                        RETURN
                    END IF
              END IF
              
              IF NOT cl_null(l_sfv.sfv30) AND g_ima906 = '2' THEN
                 CALL s_chk_imgg(l_sfv.sfv04,l_sfv.sfv05,
                       l_sfv.sfv06,l_sfv.sfv07,
                       l_sfv.sfv30) RETURNING g_flag
                 IF g_flag = 1 THEN
                    CALL s_add_imgg(l_sfv.sfv04,l_sfv.sfv05,
                                    l_sfv.sfv06,l_sfv.sfv07,
                                    l_sfv.sfv30,l_sfv.sfv31,
                                    l_sfv.sfv01,l_sfv.sfv03,0) RETURNING g_flag
                    IF g_flag = 1 THEN
                    	   LET g_status.code = -1
                        LET g_status.sqlcode = SQLCA.SQLCODE
                        LET g_status.description="产生imgg_file有错误!"
                        LET g_success = 'N'
                        RETURN
                    END IF
                 END IF
                 
                 CALL s_umfchk(l_sfv.sfv04,l_sfv.sfv30,l_ima44)
                      RETURNING g_i,l_sfv.sfv31
                 IF g_i = 1 THEN
                     LET g_status.code = -1
                     LET g_status.sqlcode = SQLCA.SQLCODE
                     LET g_status.description="单位换算率抓不到!"
                     LET g_success = 'N' RETURN
                 END IF
              END IF
              
              IF g_ima906 = '3' THEN
                 IF l_sfv.sfv35 <> 0 THEN
                    LET l_sfv.sfv34=l_sfv.sfv32/l_sfv.sfv35
                 ELSE
                    LET l_sfv.sfv34=0
                 END IF
              END IF
           END IF    	
           
           INSERT INTO sfv_file VALUES(l_sfv.*)
           IF SQLCA.SQLCODE THEN
              LET g_status.code = SQLCA.SQLCODE
              LET g_status.sqlcode = SQLCA.SQLCODE
              LET g_success='N'
              RETURN  
           END IF	
        END FOREACH           	
     END FOREACH 
####add by nihuan 20170614------end--------------------------------      
     
#     LET g_time=TIME
#     UPDATE sfu_file SET sfuud06=g_user,
#                         sfuud14=g_today
#                     WHERE sfu01=g_sfu01
      #增加条码基本档 2016-01-13 13:20:33 沈然str
      LET l_ibb01=''
      LET l_ima01=''
      LET l_sfv07=''
      LET l_sfv09=''
      LET l_sql=" select ibb01,ima01,sfv07,SUM(sfv09b) from asft620_file",
                " group by ibb01,ima01,sfv07"
                PREPARE asft620_file1 FROM l_sql
                DECLARE asft620_file_curs1 CURSOR FOR asft620_file1
                FOREACH asft620_file_curs1 INTO l_ibb01,l_ima01,l_sfv07,l_sfv09
      SELECT COUNT(*) INTO l_n FROM iba_file WHERE iba01=l_ibb01
      SELECT COUNT(*) INTO l_t FROM ibb_file WHERE ibb01=l_ibb01
      IF cl_null(l_n) THEN LET l_n=0 END IF
      IF cl_null(l_t) THEN LET l_t=0 END IF
      IF l_n=0 AND l_t=0 THEN
         LET l_iba.iba01=l_ibb01
         INSERT INTO iba_file VALUES(l_iba.*)
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             LET g_status.code = -1
             LET g_status.sqlcode = SQLCA.SQLCODE
             LET g_status.description="产生iba_file有错误!" 
             LET g_success = 'N'
             RETURN
         END IF
         LET l_ibb.ibb01=l_ibb01                 #条码编号
         LET l_ibb.ibb02='K'                     #条码产生时机点
         LET l_ibb.ibb03=g_sfu01                 #来源单号
         LET l_ibb.ibb04=0                       #来源项次
         LET l_ibb.ibb05=0                       #包号
         LET l_ibb.ibb06=g_sfv04                 #料号
         LET l_ibb.ibb11='Y'                     #使用否         
         LET l_ibb.ibb12=0                       #打印次数
         LET l_ibb.ibb13=0                       #检验批号(分批检验顺序)
         LET l_ibb.ibbacti='Y'                   #资料有效码
  #       LET l_ibb.ibb17=l_sfv07                 #批号
  #       LET l_ibb.ibb14=l_sfv09                 #数量
  #       LET l_ibb.ibb20=g_today                 #生成日期
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
      #条码异动档处理
      LET l_sql="select * from asft620_file"
                PREPARE asft620_file2 FROM l_sql
                DECLARE asft620_file_curs2 CURSOR FOR asft620_file2
                FOREACH asft620_file_curs2 INTO l_asft620_sr.*
      INITIALIZE g_tlfb.* TO NULL
      LET g_tlfb.tlfb01 = l_asft620_sr.ibb01          #条码编号
      LET g_tlfb.tlfb02 = l_asft620_sr.sfv05          #仓库
      LET g_tlfb.tlfb03 = l_asft620_sr.sfv06          #库位
#      SELECT ime01 INTO g_tlfb.tlfb02 FROM ime_file WHERE ime02=g_tlfb.tlfb03  #仓库
      LET g_tlfb.tlfb04 = l_asft620_sr.sfv07          #批号  ibb17
      LET g_tlfb.tlfb05 = l_asft620_sr.sfv09b         #数量
      LET g_tlfb.tlfb06 =  1                          #入库
      SELECT sfv11 INTO g_tlfb.tlfb07 FROM sfv_file WHERE sfv01=g_sfu01 #来源单号
      #LET g_tlfb.tlfb07 = g_sfu01                     #来源单号 
      LET g_tlfb.tlfb08 = 0                           #来源项次 ??工单项次
      LET g_tlfb.tlfb09 = g_sfu01                     #目的单号
      LET g_tlfb.tlfb10 = 0                           #目的项次
      LET g_tlfb.tlfb905= g_sfu01                     #异动单号
      LET g_tlfb.tlfb906= 1                           #异动项次
      LET g_tlfb.tlfb17 = ' '                         #杂收理由码
      LET g_tlfb.tlfb18 = ' '                         #产品分类码 
      CALL s_web_tlfb('','','','','')                 #更新条码异动档
      LET l_n=0
      LET g_sql =" SELECT COUNT(*) FROM imgb_file ",
                "WHERE imgb01='",g_tlfb.tlfb01,"'",
                " AND imgb02='",g_tlfb.tlfb02,"'",
                " AND imgb03='",g_tlfb.tlfb03,"'" ,
                " AND imgb04='",g_tlfb.tlfb04,"'"
      
      PREPARE t018_imgb_pre FROM g_sql
      EXECUTE t018_imgb_pre INTO l_n
      IF l_n = 0 THEN #没有imgb_file，新增imgb_file
        CALL s_ins_imgb(g_tlfb.tlfb01,
              g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,g_tlfb.tlfb05,g_tlfb.tlfb06,'')
      ELSE
        CALL s_up_imgb(g_tlfb.tlfb01,    #更新条码库存档
         g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,
         g_tlfb.tlfb05,g_tlfb.tlfb06,'')
      END IF        

     END FOREACH

END FUNCTION

FUNCTION t620_k_app()
DEFINE li_result   LIKE type_file.num5        #No.FUN-540055        #No.FUN-680121 SMALLINT
  DEFINE l_sfv    RECORD LIKE sfv_file.*,
         l_sfa    RECORD LIKE sfa_file.*,
         l_sfs    RECORD LIKE sfs_file.*,
         l_qpa    LIKE sfa_file.sfa161,        #No:MOD-640013 add
         l_qty    LIKE sfs_file.sfs05,         #No:MOD-640013 add
         g_sfu09  LIKE sfu_file.sfu09,
         g_t1     LIKE oay_file.oayslip, #No.FUN-540055        #No.FUN-680121 CHAR(5)
         l_flag   LIKE type_file.chr1,          #No.FUN-680121 CHAR(1)
         l_name   LIKE type_file.chr20,         #No:FUN-680121 CHAR(12)
         l_sfp    RECORD
               sfp01   LIKE sfp_file.sfp01,
               sfp02   LIKE sfp_file.sfp02,
               sfp03   LIKE sfp_file.sfp03,
               sfp04   LIKE sfp_file.sfp04,
               sfp05   LIKE sfp_file.sfp05,
               sfp06   LIKE sfp_file.sfp06,
               sfp07   LIKE sfp_file.sfp07
                  END RECORD,
         l_sfb82  LIKE sfb_file.sfb82,
         l_bdate  LIKE type_file.dat,           #No:FUN-680121 DATE#bugno:6287 add
         l_edate  LIKE type_file.dat,           #No:FUN-680121 DATE#bugno:6287 add
         l_day    LIKE type_file.num5,          #No:FUN-680121 SMALLINT #bugno:6287 add
         l_cnt    LIKE type_file.num5           #No.FUN-680121 SMALLINT
    DEFINE l_sfv11 LIKE sfv_file.sfv11
    DEFINE l_msg  LIKE type_file.chr1000        #No:FUN-680121 CHAR(300)
    DEFINE l_sfb04  LIKE sfb_file.sfb04
    DEFINE l_sfb81  LIKE sfb_file.sfb81
    DEFINE l_sfb02  LIKE sfb_file.sfb02
    DEFINE l_sfp02  LIKE sfp_file.sfp02
    DEFINE l_smy73  LIKE smy_file.smy73   #TQC-AC0293
    LET g_sfu.sfu01=g_sfu01
    IF g_sfu.sfu01 IS NULL THEN RETURN END IF
    SELECT * INTO g_sfu.* FROM sfu_file
     WHERE sfu01 = g_sfu.sfu01
    IF g_sfu.sfuconf = 'X' THEN 
    	LET g_status.code ='9024'
      LET g_success='N'
    	RETURN 
    END IF #FUN-660137
    IF g_sfu.sfupost = 'N' THEN  #未過帳
       LET g_status.code ='asf-666'
       LET g_success='N'
       RETURN
    END IF
    IF g_sfu.sfu09 IS NOT NULL THEN  #已產生領料單
      # CALL cl_err(g_sfu.sfu09,'asf-826',0)
       LET g_status.code ='asf-826'
       LET g_success='N'
       RETURN
    END IF

#...check單身工單是否有使用消秏性料件 -> 沒有則不可產生領料單
    SELECT COUNT(*) INTO l_cnt FROM sfv_file,sfa_file
     WHERE sfv01 = g_sfu.sfu01
       AND sfv11 = sfa01 AND sfa11 = 'E'
    IF l_cnt = 0 THEN 
    	#CALL cl_err('sel sfa','asf-735',0) 
    	LET g_status.code ='asf-735'
      LET g_success='N'
    	RETURN  
    END IF

    SELECT tc_codesys03 INTO g_sfu09 FROM tc_codesys_file WHERE tc_codesys00='0'
    #新增一筆資料
    IF g_sfu09 IS NOT NULL AND g_sfu.sfupost = 'Y' THEN
   #CALL s_auto_assign_no("asf",g_sfu.sfu09,g_sfu.sfu02,"","sfp_file","sfp01","","","") #MOD-A40051 mark
    CALL s_auto_assign_no("asf",g_sfu09,g_sfu.sfu14,"","sfp_file","sfp01","","","") #MOD-A40051
         RETURNING li_result,g_sfu.sfu09
    IF (NOT li_result) THEN
       #ROLLBACK WORK
       LET g_status.code = "-1"
       LET g_status.description = "产生单号有误，请检查" 
       LET g_success='N'
       RETURN
    END IF
    LET g_sfu09=g_sfu.sfu09
#      #----先檢查領料單身資料是否已經存在------------
#       DECLARE count_cur CURSOR FOR
#           SELECT COUNT(*) FROM sfs_file
#       WHERE sfs01 = g_sfu09
#       OPEN count_cur
#       FETCH count_cur INTO g_cnt
#       IF g_cnt > 0  THEN  #已存在
#          LET l_flag ='Y'
#       ELSE
#          LET l_flag ='N'
#       END IF
#       #-----------產生領料資料------------------------

       DECLARE t620_sfv_cur CURSOR  WITH HOLD FOR
          SELECT *  FROM  sfv_file
           WHERE sfv01 = g_sfu.sfu01
       LET l_cnt = 0
       FOREACH t620_sfv_cur INTO l_sfv.*
         IF STATUS THEN
            CALL cl_err('foreach s:',STATUS,0)
            LET g_success = 'N'    #No:7829
            LET g_status.code = "-1"
            LET g_status.description = "sfv无数据，请检查" 
            RETURN
            #EXIT FOREACH
         END IF
         SELECT sfb04,sfb81,sfb02          #MOD-890168 mark ,sfp02
           INTO l_sfb04,l_sfb81,l_sfb02    #MOD-890168 mark ,l_sfp02 
           FROM sfb_file                   #MOD-8A0031 mark ,sfp_file
          WHERE sfb01 = l_sfv.sfv11


         IF STATUS THEN
            CALL cl_err3("sel","sfb_file",l_sfv.sfv11,"",STATUS,"","sel sfb",1) 
            LET g_success = 'N'    #No:7829
            LET g_status.code = "-1"
            LET g_status.description = "工单无数据，请检查" 
            RETURN
            #CONTINUE FOREACH
         END IF

         IF l_sfb04='1' THEN
            #CALL cl_err('sfb04=1','asf-381',0)
            LET g_success = 'N'    #No:7829
            LET g_status.code = "asf-381"
            RETURN
            #CONTINUE FOREACH
         END IF

         IF l_sfb04='8' THEN
            #CALL cl_err('sfb04=8','asf-345',0) 
            LET g_success = 'N'    #No:7829
            LET g_status.code = "asf-345"
            RETURN
            #CONTINUE FOREACH
         END IF
        

         IF l_sfb02=13 THEN  
            #CALL cl_err('sfb02=13','asf-346',0) 
            LET g_success = 'N'    #No:7829
            LET g_status.code = "asf-346"
            RETURN
            #CONTINUE FOREACH
         END IF
         DECLARE t620_sfs_cur CURSOR WITH HOLD FOR
         SELECT sfa_file.*,sfb82 FROM sfb_file,sfa_file
          WHERE sfb01 = l_sfv.sfv11   #工單單號
            AND sfb01 = sfa01
            AND sfa11 = 'E'
            ORDER BY sfa26       #No:MOD-640013 add

        FOREACH t620_sfs_cur INTO l_sfa.*,l_sfb82
            INITIALIZE l_sfs.* TO NULL
            INITIALIZE l_sfp.* TO NULL

         #-------發料單頭--------------
          LET l_sfp.sfp01 = g_sfu09
#領料單月份已與完工入庫單月份不同時,以完工入庫日期該月的最後一天為領料日
          LET l_sfp.sfp02 = g_today
          LET l_sfp.sfp03 = g_today      #No:MOD-950184 add    
          IF MONTH(g_today) != MONTH(g_sfu.sfu02) THEN
             IF MONTH(g_sfu.sfu02) = 12 THEN
                LET l_bdate = MDY(MONTH(g_sfu.sfu02),1,YEAR(g_sfu.sfu02))
                LET l_edate = MDY(1,1,YEAR(g_sfu.sfu02)+1)
             ELSE
                LET l_bdate = MDY(MONTH(g_sfu.sfu02),1,YEAR(g_sfu.sfu02))
                LET l_edate = MDY(MONTH(g_sfu.sfu02)+1,1,YEAR(g_sfu.sfu02))
             END IF
             LET l_day = l_edate - l_bdate   #計算最後一天日期
             LET l_sfp.sfp03 = MDY(MONTH(g_sfu.sfu02),l_day,YEAR(g_sfu.sfu02))   #No:MOD-950184 add    
          END IF
          LET l_sfp.sfp04 = 'N'
          LET l_sfp.sfp05 = 'N'
          LET l_sfp.sfp06 ='4'
          LET l_sfp.sfp07 = l_sfb82
                #----先檢查領料單身資料是否已經存在------------
          DECLARE count_cur CURSOR FOR
              SELECT COUNT(*) FROM sfs_file
          WHERE sfs01 = g_sfu09
          OPEN count_cur
          FETCH count_cur INTO g_cnt
          IF g_cnt > 0  THEN  #已存在
             LET l_flag ='Y'
          ELSE
             LET l_flag ='N'
          END IF
          IF l_flag ='Y' THEN
            UPDATE sfp_file SET sfp02= l_sfp.sfp02,  #sfp03 = sr.sfp03,
                                sfp04= l_sfp.sfp04,sfp05 = l_sfp.sfp05,
                                 sfp06= l_sfp.sfp06,sfp07 = l_sfp.sfp07,  #MOD-470503
                                 sfpgrup=g_grup,                    #No:MOD-770140 add
                                 sfpmodu=g_user,sfpdate=g_today #MOD-470503 add
               WHERE sfp01 = l_sfp.sfp01
            IF SQLCA.sqlcode THEN LET g_success='N' END IF
          ELSE
           INSERT INTO sfp_file(sfp01,sfp02,sfp03,sfp04,sfp05,sfp06,sfp07,sfp09, #MOD-5A0044 add sfp09
                                sfpuser,sfpdate,sfpconf,sfpgrup, #FUN-660106     #No:MOD-770140 add sfpgrup
                                sfpmksg,sfp15,sfp16,                             #FUN-AB0001 add
                                sfpplant,sfplegal)                               #FUN-980008 add
                         VALUES(l_sfp.sfp01,l_sfp.sfp02,l_sfp.sfp03,l_sfp.sfp04,
                                l_sfp.sfp05,l_sfp.sfp06,l_sfp.sfp07,'N',        #MOD-5A0044 add 'N'
                                g_user,g_today,'N',g_grup,             #FUN-660106       #No:MOD-770140 add g_grup
                                g_smy.smyapr,'0',g_user,               #FUN-AB0001 add
                                g_plant,g_legal)                       #FUN-980008 add
            IF SQLCA.sqlcode THEN LET g_success='N' END IF
          END IF
          SELECT MAX(sfs02) INTO l_cnt FROM sfs_file
           WHERE sfs01 = g_sfu09
          IF l_cnt IS NULL THEN    #項次
             LET l_cnt = 1
          ELSE  LET l_cnt = l_cnt + 1
          END IF
         #-------發料單身--------------
          LET l_sfs.sfs01 = g_sfu09
          LET l_sfs.sfs02 = l_cnt
          LET l_sfs.sfs03 = l_sfa.sfa01
          LET l_sfs.sfs04 = l_sfa.sfa03
          LET l_sfs.sfs05 = l_sfv.sfv09*l_sfa.sfa161 #已發料量
          LET l_sfs.sfs06 = l_sfa.sfa12  #發料單位
         
          SELECT ima35,ima36 INTO g_ima35,g_ima36
             FROM ima_file
            WHERE ima01= l_sfa.sfa03

           LET l_sfs.sfs07 = g_ima35  #倉庫
           LET l_sfs.sfs08 = g_ima36  #儲位
  
          #CHI-A40030 mod --end--
          LET l_sfs.sfs09 = ' '          #批號
          LET l_sfs.sfs10 = l_sfa.sfa08  #作業序號
          LET l_sfs.sfs26 = NULL         #替代碼
          LET l_sfs.sfs27 = NULL         #被替代料號
          LET l_sfs.sfs28 = NULL         #替代率
          LET l_sfs.sfs930 = l_sfv.sfv930 #FUN-670103
          IF l_sfa.sfa26 MATCHES '[SUTZ]' THEN    #bugno:7111 add 'T'  #FUN-A20037 add 'Z'
             LET l_sfs.sfs26 = l_sfa.sfa26
             LET l_sfs.sfs27 = l_sfa.sfa27
             LET l_sfs.sfs28 = l_sfa.sfa28
             SELECT (sfa161 * sfa28) INTO l_qpa FROM sfa_file
                WHERE sfa01 = l_sfa.sfa01 AND sfa03 = l_sfa.sfa27
                  AND sfa012 = l_sfa.sfa012 AND sfa013 = l_sfa.sfa013        #FUN-A60076 
             LET l_sfs.sfs05 = l_sfv.sfv09*l_qpa
             SELECT SUM(c) INTO l_qty FROM tmp WHERE a = l_sfa.sfa01
                AND b = l_sfa.sfa27
             IF l_sfs.sfs05 < l_qty THEN
                LET l_sfs.sfs05 = 0
             ELSE
                LET l_sfs.sfs05 = l_sfs.sfs05 - l_qty
             END IF
          ELSE                               #No:MOD-8B0086 add
             LET l_sfs.sfs27 = l_sfa.sfa27   #No:MOD-8B0086 add
             LET l_sfs.sfs28 = l_sfa.sfa28   #No:MOD-8B0086 add
          END IF
          CALL t620_chk_ima64_app(l_sfs.sfs04, l_sfs.sfs05) RETURNING l_sfs.sfs05  #MOD-850193 add

          IF l_sfs.sfs05 > (l_sfa.sfa05 - l_sfa.sfa06) THEN
             LET l_sfs.sfs05 = l_sfa.sfa05 - l_sfa.sfa06
             IF l_sfs.sfs05 < 0 THEN
                CONTINUE FOREACH
             END IF
          END IF
#add by fxw 120301---(E)
          IF cl_null(l_sfs.sfs07) AND cl_null(l_sfs.sfs08) THEN
             SELECT ima35,ima36 INTO  l_sfs.sfs07,l_sfs.sfs08
               FROM ima_file
              WHERE ima01 = l_sfs.sfs04
            ##Add No.FUN-AA0055  #Mark No.FUN-AB0054 此处不做判断，交予单据审核时控管
            #IF NOT s_chk_ware(l_sfs.sfs07) THEN  #检查仓库是否属于当前门店
            #   LET g_success = 'N'
            #END IF
            ##End Add No.FUN-AA0055
          END IF
          IF l_sfs.sfs07 IS NULL THEN LET l_sfs.sfs07 = ' ' END IF
          IF l_sfs.sfs08 IS NULL THEN LET l_sfs.sfs08 = ' ' END IF
          IF l_sfs.sfs09 IS NULL THEN LET l_sfs.sfs09 = ' ' END IF
          INSERT INTO tmp
            VALUES(l_sfa.sfa01,l_sfa.sfa27,l_sfs.sfs05)
          IF g_sma.sma115 = 'Y' THEN
             SELECT ima25,ima55,ima906,ima907
               INTO g_ima25,g_ima55,g_ima906,g_ima907
               FROM ima_file
              WHERE ima01=l_sfs.sfs04
             IF SQLCA.sqlcode THEN
                CALL cl_err('sel ima',SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
             IF cl_null(g_ima55) THEN LET g_ima55 = g_ima25 END IF
             LET l_sfs.sfs30=l_sfs.sfs06
             LET g_factor = 1
             CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs30,g_ima55)
               RETURNING g_cnt,g_factor
             IF g_cnt = 1 THEN
                LET g_factor = 1
             END IF
             LET l_sfs.sfs31=g_factor
             LET l_sfs.sfs32=l_sfs.sfs05
             LET l_sfs.sfs33=g_ima907
             LET g_factor = 1
             CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs33,g_ima55)
               RETURNING g_cnt,g_factor
             IF g_cnt = 1 THEN
                LET g_factor = 1
             END IF
             LET l_sfs.sfs34=g_factor
             LET l_sfs.sfs35=0
             LET l_sfs.sfsplant = g_plant #TQC-AB0097
             LET l_sfs.sfslegal = g_legal #TQC-AB0097
             IF g_ima906 = '3' THEN
                LET g_factor = 1
                CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs30,l_sfs.sfs33)
                  RETURNING g_cnt,g_factor
                IF g_cnt = 1 THEN
                   LET g_factor = 1
                END IF
                LET l_sfs.sfs35=l_sfs.sfs32*g_factor
             END IF
             IF g_ima906='1' THEN
                LET l_sfs.sfs33=NULL
                LET l_sfs.sfs34=NULL
                LET l_sfs.sfs35=NULL
             END IF
          END IF

#         IF l_flag ='N' THEN

            #LET l_sfv.sfvplant = g_plant #FUN-980008 add  #TQC-AB0097 mark
            #LET l_sfv.sfvlegal = g_legal #FUN-980008 add  #TQC-AB0097 mark
            LET l_sfs.sfsplant = g_plant #TQC-AB0097
            LET l_sfs.sfslegal = g_legal #TQC-AB0097
#FUN-A70125 --begin--
            IF cl_null(l_sfs.sfs012) THEN
               LET l_sfs.sfs012 = ' ' 
            END IF 
            IF cl_null(l_sfs.sfs013) THEN
               LET l_sfs.sfs013 = 0 
            END IF            
#FUN-A70125 --end--

            #add huxy160503------B---------- 
            IF cl_null(l_sfs.sfs014) THEN
               LET l_sfs.sfs014 = ' ' 
            END IF            
            #add huxy160503------E---------- 
            INSERT INTO sfs_file VALUES (l_sfs.*)
            IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
              CALL cl_err('ins sfs',STATUS,0)
              LET g_success = 'N'
              LET g_status.code = "-1"
              LET g_status.description = "插入sfs表有误，请检查"
              RETURN
            END IF
#         ELSE
#            UPDATE sfs_file SET * = l_sfs.* WHERE sfs01 = l_sfs.sfs01
#            IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
#               CALL cl_err('ins sfs',STATUS,0)
#               LET g_success = 'N'
#            END IF
#         END IF
       END FOREACH
     END FOREACH
     IF g_sfu09 IS NOT NULL THEN
        LET g_sfu.sfu09 = g_sfu09
        UPDATE sfu_file SET sfu09 = g_sfu.sfu09
         WHERE sfu01 = g_sfu.sfu01
        IF STATUS THEN
           CALL cl_err('upd sfu',STATUS,1)
           LET g_success = 'N'
           LET g_status.code = "-1"
           LET g_status.description = "更新sfu表有误，请检查"
           RETURN
        END IF

     END IF
    END IF

END FUNCTION

FUNCTION t620_chk_ima64_app(p_part, p_qty)
  DEFINE p_part		LIKE ima_file.ima01
  DEFINE p_qty		LIKE ima_file.ima641   
  DEFINE l_ima108	LIKE ima_file.ima108
  DEFINE l_ima64	LIKE ima_file.ima64
  DEFINE l_ima641	LIKE ima_file.ima641
  DEFINE i		LIKE type_file.num10  

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



	
