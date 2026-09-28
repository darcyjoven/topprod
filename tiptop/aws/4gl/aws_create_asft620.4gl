# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Descriptions...: 完工入库扫描作业
# Date & Author..: 2016-04-11 13:17:31 shenran


DATABASE ds

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

GLOBALS "../../aba/4gl/barcode.global"



GLOBALS
DEFINE g_sfa01    LIKE sfa_file.sfa01    #工单号
DEFINE g_ima01    LIKE ima_file.ima01    #料件
DEFINE g_ima35    LIKE ima_file.ima35    #仓库
DEFINE g_sfv09a   LIKE sfv_file.sfv09    #数量
DEFINE g_in       LIKE rvv_file.rvv17
DEFINE g_rva01    LIKE rva_file.rva01
DEFINE li_result  LIKE type_file.num5
DEFINE g_yy,g_mm   LIKE type_file.num5 
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
DEFINE g_fun620     RECORD 
        sfu01    LIKE sfu_file.sfu01
                 END RECORD


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
FUNCTION aws_create_asft620()
 
 WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增完工入庫單資料                                                       #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_asft620_process()
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
FUNCTION aws_create_asft620_process()
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
    INITIALIZE g_fun620.* TO NULL
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("Master")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***

    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       LET g_success='N'
       RETURN
    END IF


    FOR l_i = 1 TO l_cnt1
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "Master")       #目前處理單檔的 XML 節點
        
        LET g_sfa01  = aws_ttsrv_getRecordField(l_node1,"sfa01")
        LET g_ima01  = aws_ttsrv_getRecordField(l_node1,"ima01")
        LET g_ima35  = aws_ttsrv_getRecordField(l_node1,"ima35")
        LET g_sfv09a = aws_ttsrv_getRecordField(l_node1,"sfv09a")

    END FOR
    IF g_success = 'Y' THEN 
       CALL app_620_load()
       IF g_success = 'Y' THEN
          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_fun620))
       END IF
    END IF
END FUNCTION
FUNCTION app_620_load()
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_img09     LIKE img_file.img09

   LET g_success = "Y"
   BEGIN WORK
   CALL app_620_ins_sfu()
   IF g_success = "Y" THEN
      COMMIT WORK
   ELSE 
   	  ROLLBACK WORK
   END IF
END FUNCTION
FUNCTION app_620_ins_sfu()   #No.MOD-8A0112 add
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
   DEFINE l_sql       STRING
   DEFINE l_sumsfv09   LIKE sfv_file.sfv09
 
   #----單頭
   INITIALIZE l_sfu.* TO NULL
   INITIALIZE l_sfv.* TO NULL

   LET l_sfu.sfu00 = '1'       #入庫
   LET l_sfu.sfu02 = g_today   #入库日期
   LET l_sfu.sfu14 = g_today   #录入日期
   SELECT tc_codesys06 INTO l_sfu.sfu01 FROM tc_codesys_file       #add by caohp 150930
   CALL s_auto_assign_no("asf",l_sfu.sfu01,l_sfu.sfu02,"1","sfu_file","sfu01","","","")
   RETURNING li_result,l_sfu.sfu01                                  #完工入库单单号
   IF (NOT li_result) THEN
      LET g_success = 'N'
      LET g_status.code = "-1"
      LET g_status.description = "完工入库单号有误,请检查!"
      RETURN
   END IF
   #LET l_sfu.sfu04    = g_sfu04   #部门编码
   LET l_sfu.sfu16    = g_user    #申请人
   SELECT gen03 INTO l_sfu.sfu04 FROM gen_file WHERE gen01=l_sfu.sfu16 #部门编码
   LET l_sfu.sfuplant = g_plant                                       #所属营运中心
   LET l_sfu.sfulegal = g_plant                                       #所属法人   
   LET l_sfu.sfuuser  = g_user                                        #资料所有者
   LET l_sfu.sfugrup  = l_sfu.sfu04                                   #资料所有部门
   LET l_sfu.sfuoriu  = g_user                                        #资料建立者
   LET l_sfu.sfuorig  = l_sfu.sfu04                                   #资料建立部门
   LET l_sfu.sfu15    = '1'                                           #签核状况 开立
   LET l_sfu.sfumksg  = 'N'                                           #是否签核
   LET l_sfu.sfupost  = 'N'      #过账否
   LET l_sfu.sfuconf  = 'Y'      #审核否

   
   INSERT INTO sfu_file VALUES (l_sfu.*)
   IF STATUS THEN
      LET g_status.code = -1
      LET g_status.sqlcode = SQLCA.SQLCODE
      LET g_status.description="产生sfu_file有错误!"
      LET g_success='N'
      RETURN
   END IF

   LET l_sfv.sfv01=l_sfu.sfu01    #完工入库单单号
   SELECT MAX(sfv03) INTO l_sfv.sfv03 FROM sfv_file WHERE sfv01=l_sfv.sfv01 #项次
   IF cl_null(l_sfv.sfv03) THEN 
   	  LET l_sfv.sfv03= 1
   ELSE 
   	  LET l_sfv.sfv03= l_sfv.sfv03+1
   END IF             
   LET l_sfv.sfv04=g_ima01         #料号
   LET l_sfv.sfv05=g_ima35         #仓库
   LET l_sfv.sfv06=' '                        #库位
   LET l_sfv.sfv07=' '                        #批号
  
   SELECT ima25 INTO l_sfv.sfv08              #库存单位
   FROM ima_file WHERE ima01= l_sfv.sfv04
   LET l_sfv.sfv09=g_sfv09a         #库存数量
   LET l_sfv.sfv11=g_sfa01                    #工单单号
   LET l_sfv.sfv16='N'                        #当月是否入联产品
   LET l_sfv.sfv30=l_sfv.sfv08                #单位一
   LET l_sfv.sfv31=1                          #单位一换算率（与生产单位）
   LET l_sfv.sfv32=l_sfv.sfv09                #单位一数量
   LET l_sfv.sfvplant=g_plant                 #所属营运中心
   LET l_sfv.sfvlegal=g_plant                 #所属法人
   LET l_cnt=0
  SELECT COUNT(*) INTO l_cnt FROM img_file
  WHERE img01=l_sfv.sfv04
    AND img02=l_sfv.sfv05
    AND img03=l_sfv.sfv06
    AND img04=l_sfv.sfv07
  IF l_cnt=0 THEN 
  	CALL s_add_img(l_sfv.sfv04,l_sfv.sfv05,l_sfv.sfv06,l_sfv.sfv07,l_sfv.sfv01,l_sfv.sfv03,g_today)
  END IF 
  INSERT INTO sfv_file VALUES(l_sfv.*)
  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
     LET g_status.code = -1
     LET g_status.sqlcode = SQLCA.SQLCODE
     LET g_status.description="产生sfv_file有错误!"
     LET g_success='N'
     RETURN	
  END IF 
   
  IF g_success='Y' THEN
   	 LET g_fun620.sfu01 = l_sfu.sfu01   #赋值传出单号
  END IF
END FUNCTION




	
