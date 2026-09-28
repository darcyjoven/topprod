# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Descriptions...: 产线条码领用(tlfb_file)
# Date & Author..: 2016-04-28 20:04:35 shenran


DATABASE ds

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

GLOBALS "../../aba/4gl/barcode.global"



GLOBALS
DEFINE g_sfa01        LIKE sfa_file.sfa01         #工单号
DEFINE g_tlfb01       LIKE tlfb_file.tlfb01       #批次条码
DEFINE g_ima01        LIKE ima_file.ima01         #料号
DEFINE g_batch        LIKE tlfb_file.tlfb04       #批次
DEFINE g_tlfb05       LIKE tlfb_file.tlfb05       #数量
DEFINE g_in           LIKE rvv_file.rvv17
DEFINE g_rva01        LIKE rva_file.rva01
DEFINE li_result      LIKE type_file.num5
DEFINE g_yy,g_mm      LIKE type_file.num5 
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
FUNCTION aws_create_tlfb100()
 
 WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增完工入庫單資料                                                       #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_tlfb100_process()
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
FUNCTION aws_create_tlfb100_process()
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
   DEFINE l_n          SMALLINT
   DEFINE l_length     LIKE type_file.num5
   DEFINE p_cmd        LIKE type_file.chr1    #處理狀態
   DEFINE l_t          LIKE type_file.num5
   DEFINE l_msg        LIKE type_file.chr50    #No.FUN-680136 VARCHAR(40)
   DEFINE l_sr         STRING
   DEFINE l_rvb87      LIKE rvb_file.rvb87
   DEFINE l_rvb29      LIKE rvb_file.rvb29
   DEFINE l_pmn50      LIKE pmn_file.pmn50
   DEFINE l_pmn55      LIKE pmn_file.pmn55
   DEFINE l_pmn58      LIKE pmn_file.pmn58
   DEFINE l_rvb07      LIKE rvb_file.rvb07
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
        
        LET g_sfa01    = aws_ttsrv_getRecordField(l_node1,"sfa01")
        LET g_tlfb01   = aws_ttsrv_getRecordField(l_node1,"tlfb01")
        LET g_ima01    = aws_ttsrv_getRecordField(l_node1,"ima01")
        LET g_batch    = aws_ttsrv_getRecordField(l_node1,"batch")
        LET g_tlfb05   = aws_ttsrv_getRecordField(l_node1,"tlfb05")
     
    END FOR
    IF g_success = 'Y' THEN 
       CALL tlfb100_load()
    END IF
END FUNCTION
FUNCTION tlfb100_load()
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_img09     LIKE img_file.img09

   BEGIN WORK
   CALL tlfb100_ins_tlfb()

   IF g_success = "Y" THEN
      COMMIT WORK
   ELSE 
   	  ROLLBACK WORK
   END IF
END FUNCTION
FUNCTION tlfb100_ins_tlfb()   #No.MOD-8A0112 add
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
     INITIALIZE l_iba.* TO NULL
     INITIALIZE l_ibb.* TO NULL


      SELECT COUNT(*) INTO l_n FROM iba_file WHERE iba01=g_tlfb01
      SELECT COUNT(*) INTO l_t FROM ibb_file WHERE ibb01=g_tlfb01
      IF cl_null(l_n) THEN LET l_n=0 END IF
      IF cl_null(l_t) THEN LET l_t=0 END IF
      IF l_n=0 AND l_t=0 THEN
         LET l_iba.iba01=g_tlfb01
         INSERT INTO iba_file VALUES(l_iba.*)
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             LET g_status.code = -1
             LET g_status.sqlcode = SQLCA.SQLCODE
             LET g_status.description="产生iba_file有错误!" 
             LET g_success = 'N'
             RETURN
         END IF
         LET l_ibb.ibb01=g_tlfb01                #条码编号
         LET l_ibb.ibb02='K'                     #条码产生时机点
         LET l_ibb.ibb03=' '                     #来源单号
         LET l_ibb.ibb04=0                       #来源项次
         LET l_ibb.ibb05=0                       #包号
         LET l_ibb.ibb06=g_ima01                 #料号
         LET l_ibb.ibb11='Y'                     #使用否         
         LET l_ibb.ibb12=0                       #打印次数
         LET l_ibb.ibb13=0                       #检验批号(分批检验顺序)
         LET l_ibb.ibbacti='Y'                   #资料有效码
#         LET l_ibb.ibb17=g_batch                 #批号
#         LET l_ibb.ibb14=g_tlfb05                #数量
#         LET l_ibb.ibb20=g_today                 #生成日期
         INSERT INTO ibb_file VALUES(l_ibb.*)
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             LET g_status.code = -1
             LET g_status.sqlcode = SQLCA.SQLCODE
             LET g_status.description="产生ibb_file有错误!" 
             LET g_success = 'N'
            RETURN
         END IF
      END IF
     #插入tlfb_file异动档
      LET g_tlfb.tlfb01 = g_tlfb01                    #条码编号
      LET g_tlfb.tlfb03 = ' '                         #库位
      LET g_tlfb.tlfb02 = ' '                         #仓库
      LET g_tlfb.tlfb04 = ' '                         #批号  ibb17
      LET g_tlfb.tlfb05 = g_tlfb05                    #数量
      LET g_tlfb.tlfb06 =  -1                         #出库
      LET g_tlfb.tlfb07 = ''                          #来源单号 
      LET g_tlfb.tlfb08 = ''                          #来源项次 ??工单项次
      LET g_tlfb.tlfb09 = ''                          #目的单号
      LET g_tlfb.tlfb10 = ''                          #目的项次
      LET g_tlfb.tlfb905= ''                          #异动单号
      LET g_tlfb.tlfb906= ''                          #异动项次
      LET g_tlfb.tlfb17 = ' '                         #杂收理由码
      LET g_tlfb.tlfb18 = ' '                         #产品分类码
      LET g_tlfb.tlfb19 ='R'
      CALL s_web_tlfb('','','','','')                 #更新条码异动档


END FUNCTION



