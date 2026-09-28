# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Descriptions...: 采购扫描入库作业
# Date & Author..: 2016-03-16 杨兰


DATABASE ds

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

GLOBALS "../../aba/4gl/barcode.global"


GLOBALS
DEFINE g_rvv32    LIKE rvv_file.rvv32    #仓库
DEFINE g_barcode  LIKE type_file.chr50   #批次条码
DEFINE g_rvv17    LIKE rvv_file.rvv17    #本次数量
DEFINE g_in       LIKE rvv_file.rvv17
DEFINE g_rva01    LIKE rva_file.rva01
DEFINE g_buf      LIKE type_file.chr2
DEFINE li_result  LIKE type_file.num5
DEFINE g_yy,g_mm   LIKE type_file.num5 
DEFINE g_img09_t LIKE img_file.img09
DEFINE g_i       LIKE type_file.num5
DEFINE g_ima907  LIKE ima_file.ima907
DEFINE g_gec07   LIKE gec_file.gec07
DEFINE g_sql      STRING
DEFINE o_pmn     DYNAMIC ARRAY OF RECORD                    #单身
                    pmn04a     LIKE pmn_file.pmn04,         #料件編號
                    pmn20a     LIKE pmn_file.pmn20,         #需求数量
                    pmn20b     LIKE pmn_file.pmn20          #已匹配数量
                 END RECORD

DEFINE o_pmn_t   RECORD                     #第一单身
                    pmn04a     LIKE pmn_file.pmn04,         #料件編號
                    pmn20a     LIKE pmn_file.pmn20,         #需求数量
                    pmn20b     LIKE pmn_file.pmn20          #已匹配数量
                 END RECORD

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
DEFINE g_pmm     RECORD LIKE pmm_file.*
DEFINE g_pmn     RECORD LIKE pmn_file.* 
DEFINE g_rva     RECORD LIKE rva_file.*
DEFINE g_rvb     RECORD LIKE rvb_file.*
DEFINE g_srm_dbs LIKE  type_file.chr50
DEFINE g_success LIKE type_file.chr1
DEFINE g_sr     RECORD 
        rvu01    LIKE rvu_file.rvu01
                 END RECORD
DEFINE m_mt_dlv   RECORD
            tc_sia01  LIKE tc_sia_file.tc_sia01,       #SRM 发货单号
            tc_sia03  LIKE tc_sia_file.tc_sia03,       #SRM 发货日期
            tc_sia09  LIKE tc_sia_file.tc_sia09,       #SRM 订单类型 REG:普通  SUB:委外
            tc_sia02  LIKE tc_sia_file.tc_sia02,       #ERP 供应商编码
            tc_sia06  LIKE tc_sia_file.tc_sia06,       #ERP 收货单号
            tc_sia08  LIKE tc_sia_file.tc_sia08        #SRM 单据状态 1：草稿 2：发放 3：已收货                  
               END RECORD


#DEFINE   g_cnt  LIKE type_file.num5  #MOD-880015
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
FUNCTION aws_create_apmt720()
 
 WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增完工入庫單資料                                                       #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_apmt720_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
     DROP TABLE t003_file
     DROP TABLE t003_file1
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
FUNCTION aws_create_apmt720_process()
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
    DEFINE l_return   RECORD                           #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                         sfu01   LIKE sfu_file.sfu01   #回傳的欄位名稱
                      END RECORD
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
   DEFINE l_t003_file1      RECORD                    #单身
                    rvb01      LIKE rvb_file.rvb01,         #收货单号
                    rvb02      LIKE rvb_file.rvb02,         #收货单项次
                    rvb05      LIKE rvb_file.rvb05,         #物料
                    rvb07      LIKE rvb_file.rvb07,         #允收数量
                    rvv17a     LIKE rvv_file.rvv17          #本次数量
                 END RECORD  
  DEFINE  l_t003_file     RECORD
                    rvb01      LIKE rvb_file.rvb01,         #收货单号
                    rvv32      LIKE rvv_file.rvv32,         #仓库
                    rvv33      LIKE rvv_file.rvv33,         #储位   #add by sunll 170725
                    barcode    LIKE type_file.chr50,        #条码
                    lotnumber  LIKE type_file.chr50,        #批号
                    rvb05      LIKE rvb_file.rvb05,         #料件
                    rvv17      LIKE rvv_file.rvv17          #数量
                 END RECORD
   DROP TABLE t003_file
   DROP TABLE t003_file1 
   DROP TABLE tmp  
   CREATE TEMP TABLE t003_file(
                    rvb01      LIKE rvb_file.rvb01,         #收货单号
                    rvv32      LIKE rvv_file.rvv32,         #仓库
                    rvv33      LIKE rvv_file.rvv33,         #储位 #add by sunll 170725
                    barcode    LIKE type_file.chr50,        #条码
                    lotnumber  LIKE type_file.chr50,        #批号
                    rvb05      LIKE rvb_file.rvb05,         #料件
                    rvv17      LIKE rvv_file.rvv17)         #数量
   CREATE TEMP TABLE t003_file1(
                    rvb01      LIKE rvb_file.rvb01,         #收货单号
                    rvb02      LIKE rvb_file.rvb02,         #收货单项次
                    rvb05      LIKE rvb_file.rvb05,         #物料
                    rvb07      LIKE rvb_file.rvb07,         #允收数量
                    rvv17a     LIKE rvv_file.rvv17)         #本次数量
   CREATE TEMP TABLE tmp(                                                                                                                 
    a         LIKE oea_file.oea01,                                                                                                
    b         LIKE type_file.chr1000,                                                                                                 
    c         LIKE type_file.num15_3);  #FUN-A20044                
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的完工入庫單資料                                    #
    #--------------------------------------------------------------------------#
    LET g_success = 'Y'
    INITIALIZE g_sr.* TO NULL
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("Master")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***

    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       LET g_success='N'
       RETURN
    END IF


    FOR l_i = 1 TO l_cnt1
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "Master")       #目前處理單檔的 XML 節點
        
        LET g_rva01 = aws_ttsrv_getRecordField(l_node1,"rva01")
        #----------------------------------------------------------------------#
        # 處理單身資料                                                         #
        #----------------------------------------------------------------------#
        LET l_cnt3 = aws_ttsrv_getDetailRecordLength(l_node1, "t003_file1")       #取得目前單頭共有幾筆單身資料
        IF l_cnt3 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           LET g_success='N'
           EXIT FOR
        END IF
        FOR l_k = 1 TO l_cnt3
            INITIALIZE l_t003_file1.* TO NULL
            LET l_node3 = aws_ttsrv_getDetailRecord(l_node1, l_k,"t003_file1")   #目前單身的 XML 節點
            #------------------------------------------------------------------#
            # NODE資料傳到RECORD                                               #
            #------------------------------------------------------------------#
            LET l_t003_file1.rvb01  = g_rva01
            LET l_t003_file1.rvb02  = aws_ttsrv_getRecordField(l_node3, "rvb02")
            LET l_t003_file1.rvb05  = aws_ttsrv_getRecordField(l_node3, "rvb05") 
            LET l_t003_file1.rvb07  = aws_ttsrv_getRecordField(l_node3, "rvb07")   
            LET l_t003_file1.rvv17a = aws_ttsrv_getRecordField(l_node3, "rvv17a")
            
            INSERT INTO t003_file1 VALUES (l_t003_file1.rvb01,l_t003_file1.rvb02,l_t003_file1.rvb05,
            l_t003_file1.rvb07,l_t003_file1.rvv17a)
        END FOR
        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "t003_file")       #取得目前單頭共有幾筆單身資料
        IF l_cnt2 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           LET g_success='N'
           EXIT FOR
        END IF                
        FOR l_j = 1 TO l_cnt2
            INITIALIZE l_t003_file.* TO NULL
            LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j,"t003_file")   #目前單身的 XML 節點
            #------------------------------------------------------------------#
            # NODE資料傳到RECORD                                               #
            #------------------------------------------------------------------#
            LET l_t003_file.rvb01=g_rva01
            LET l_t003_file.rvv32 = aws_ttsrv_getRecordField(l_node2, "rvv32")
            LET l_t003_file.rvv33 = aws_ttsrv_getRecordField(l_node2, "rvv33")     #add by sunll 170725 
            LET l_t003_file.barcode = aws_ttsrv_getRecordField(l_node2, "barcode")
            LET l_t003_file.lotnumber = aws_ttsrv_getRecordField(l_node2, "lotnumber")
            LET l_t003_file.rvb05 = aws_ttsrv_getRecordField(l_node2, "rvb05")
            LET l_t003_file.rvv17 = aws_ttsrv_getRecordField(l_node2, "rvv17")
            INSERT INTO t003_file VALUES (l_t003_file.rvb01,l_t003_file.rvv32,l_t003_file.rvv33,l_t003_file.barcode,
            l_t003_file.lotnumber,l_t003_file.rvb05,l_t003_file.rvv17)
        END FOR
    END FOR
    IF g_success = 'Y' THEN 
       CALL t003_load()
       IF g_success = 'Y' THEN
          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_sr))
       ELSE
       	  IF g_status.code='0' THEN
            LET g_status.code = "-1"
            LET g_status.description = "接口程序存在错误，请程序员检查，谢谢!"
          END IF
       END IF
    END IF
END FUNCTION
FUNCTION t003_load()
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_img09     LIKE img_file.img09

   LET g_success = "Y"
   BEGIN WORK
   CALL t003_ins_rvu()
   IF g_success = "Y" THEN
      COMMIT WORK
     # CALL moer_apmt720()
   ELSE 
   	  ROLLBACK WORK
   END IF
END FUNCTION
FUNCTION t003_ins_rvu()   #No.MOD-8A0112 add
   DEFINE l_rvu       RECORD LIKE rvu_file.*,
          l_smy57     LIKE type_file.chr1,     # Prog. Version..: '5.20.02-10.08.05(01)   #MOD-740033 modify
          l_t         LIKE smy_file.smyslip    #No.FUN-680136 VARCHAR(5)  #No.FUN-540027
   DEFINE li_result   LIKE type_file.num5      #No.FUN-540027  #No.FUN-680136 SMALLINT
   DEFINE p_chr       LIKE type_file.chr1      #No.MOD-8A0112 add
   DEFINE l_rvb01     LIKE rvb_file.rvb01
 
   #----單頭
   INITIALIZE l_rvu.* TO NULL
   SELECT DISTINCT rvb01 INTO l_rvb01 FROM t003_file1
   SELECT * INTO g_rva.* FROM rva_file WHERE rva01 = l_rvb01
   LET l_rvu.rvu00='1'   #入庫
   LET l_rvu.rvu02=g_rva.rva01   #驗收單號
   LET l_rvu.rvu03=g_today       #異動日期
   #若入庫日小於收貨日                                                                                                              
   IF l_rvu.rvu03<g_rva.rva06 THEN                                                                                                  
       LET g_status.code = -1
       LET g_status.sqlcode = SQLCA.SQLCODE
       LET g_status.description="入库日期小于收货日期!"                                                                      
       LET g_success='N'                                                                                                       
       RETURN                                                                                                             
   END IF
   #日期<=關帳日期
   IF NOT cl_null(g_sma.sma53) AND l_rvu.rvu03 <= g_sma.sma53 THEN
       LET g_status.code = -1
       LET g_status.sqlcode = SQLCA.SQLCODE
       LET g_status.description="异动日期不可小于关账日期, 请重新录入!"
      LET g_success = 'N'
      RETURN
   END IF
 
   CALL s_yp(l_rvu.rvu03) RETURNING g_yy,g_mm
   IF (g_yy*12+g_mm)>(g_sma.sma51*12+g_sma.sma52)THEN #不可大於現行年月
      LET g_status.code = -1
      LET g_status.sqlcode = SQLCA.SQLCODE
      LET g_status.description="您所录入的日期其月份大於当前使用会计期间!"
      LET g_success = 'N'
      RETURN
   END IF
 
   LET l_t = s_get_doc_no(g_rva.rva01)       #No.FUN-540027
  #用傳入的參數來判斷
   SELECT smy52,smy57[3,3] INTO l_rvu.rvu01,l_smy57 FROM smy_file
   WHERE smyslip=l_t
 
   IF l_rvu.rvu01 IS NULL THEN
      LET g_status.code = -1
      LET g_status.sqlcode = SQLCA.SQLCODE
      LET g_status.description="收料单别未设置对应入库单别,无法自动生成入库单!"
      LET g_success = 'N'
      RETURN
   END IF
   IF l_rvu.rvu00='1' THEN
      IF l_smy57='Y' THEN
         LET l_rvu.rvu01[g_no_sp-1,g_no_ep]=g_rva.rva01[g_no_sp-1,g_no_ep] #No.FUN-540027
         SELECT COUNT(*) INTO g_cnt
           FROM rvu_file
          WHERE rvu01=l_rvu.rvu01
            AND rvuconf !='X'
         IF g_cnt > 0 THEN   # OR MONTH(g_rva.rva08) <> MONTH(g_today)
                             #原有考慮收貨月份不等於入庫月份時應以 g_today產生單號
                             #此狀況改以原收貨月份產生單號)
 
            LET l_t = l_rvu.rvu01[1,g_doc_len]        #No.FUN-560060
            CALL s_auto_assign_no("apm",l_t,g_rva.rva06,"","","","","","")
                 RETURNING li_result,l_rvu.rvu01
            IF (NOT li_result) THEN
            	   LET g_status.code = -1
                 LET g_status.sqlcode = SQLCA.SQLCODE
                 LET g_status.description="产生入库单号有错误!"
                 LET g_success='N'
                 RETURN 
            END IF
         END IF
      ELSE
         LET l_t = l_rvu.rvu01[1,g_doc_len]        #No.FUN-560060
         CALL s_auto_assign_no("apm",l_t,l_rvu.rvu03,"","","","","","")
              RETURNING li_result,l_rvu.rvu01
         IF (NOT li_result) THEN
         	   LET g_status.code = -1
             LET g_status.sqlcode = SQLCA.SQLCODE
             LET g_status.description="产生入库单号有错误!"
             LET g_success='N'
             RETURN
         END IF
      END IF
   END IF
 
   LET l_rvu.rvu04=g_rva.rva05   #廠商編號
   SELECT pmc03 INTO l_rvu.rvu05 FROM pmc_file  #簡稱
    WHERE pmc01=g_rva.rva05
   LET l_rvu.rvu06=g_grup        #部門
   LET l_rvu.rvu07=g_user        #人員
   LET l_rvu.rvu08=g_rva.rva10   #性質
   LET l_rvu.rvu09=NULL
   LET l_rvu.rvu20='N'           #三角貿易拋轉否no.4475
   LET l_rvu.rvuconf='N'         #確認碼
   LET l_rvu.rvuacti='Y'
   LET l_rvu.rvuuser=g_rva.rvauser
   LET l_rvu.rvugrup=g_rva.rvagrup
   LET l_rvu.rvumodu=' '
#  LET l_rvu.rvudate=g_today  #TQC-A60021 -mark
   LET l_rvu.rvucrat=g_today  #TQC-A60021 -add
   LET l_rvu.rvu21 = g_rva.rva29 
   LET l_rvu.rvuplant = g_rva.rvaplant
   LET l_rvu.rvulegal = g_rva.rvalegal
   LET l_rvu.rvu22 = g_rva.rva30
   LET l_rvu.rvu23 = g_rva.rva31
   LET l_rvu.rvucrat = g_today
   LET l_rvu.rvu900 = '0'
   LET l_rvu.rvumksg = 'N'
   LET l_rvu.rvupos = 'N'
   IF l_rvu.rvu21 IS NULL THEN LET l_rvu.rvu21 = '1' END IF
   LET l_rvu.rvuplant = g_plant #NO.FUN-980006 jarlin add
   LET l_rvu.rvulegal = g_legal #NO.FUN-980006 jarlin add
   LET l_rvu.rvuoriu = g_user #TQC-9B0226
   LET l_rvu.rvuorig = g_grup #TQC-9B0226
   LET l_rvu.rvu101=g_rva.rva08   #CHI-A50012 add 
   LET l_rvu.rvu102=g_rva.rva21   #CHI-A50012 add 
   LET l_rvu.rvu100=g_rva.rva100  #CHI-A50012 add
   LET l_rvu.rvu17='0'
   LET l_rvu.rvu27=" "

   INSERT INTO rvu_file VALUES (l_rvu.*)
   IF STATUS THEN
      LET g_status.code = -1
      LET g_status.sqlcode = SQLCA.SQLCODE
      LET g_status.description="产生rvu_file有错误!"
      LET g_success='N'
      RETURN
   ELSE
   	  LET g_sr.rvu01 = l_rvu.rvu01  #赋值传出单号
   END IF
   IF g_success='Y' THEN
      CALL t003_ins_rvv(l_rvu.rvu01) #NO:7143單身  #FUN-810038
   END IF
   IF g_success='Y' THEN
      CALL t720sub_y_upd(l_rvu.rvu01,'1','',l_rvu.rvu08,'N',TRUE,'Y','N')
   END IF
   	
   IF g_success='Y' THEN
      CALL t720_ins_ibb(l_rvu.rvu01)
      IF g_success = 'N' THEN
         LET g_status.code = '-1'
         LET g_status.description="产生ibb_file有错误!"
      END IF 
   END IF
   		
   IF g_success='Y' THEN
      CALL t003_ins_tlfb(l_rvu.rvu01)
   END IF
   IF g_success='Y' THEN
      IF l_rvu.rvu08='SUB' THEN
   	      CALL t003_m(l_rvu.rvu01)
      END IF
   END IF
 
END FUNCTION

FUNCTION t003_ins_rvv(p_rvv01)     #FUN-810038
 DEFINE l_ima44   LIKE ima_file.ima44      #No.FUN-540027
 DEFINE l_rvv     RECORD LIKE rvv_file.*,
        l_rvuconf LIKE rvu_file.rvuconf,
        l_smy57   LIKE type_file.chr1,     #MOD-740033 add
        l_t       LIKE smy_file.smyslip,   #MOD-740033 add
        p_rvv01   LIKE rvv_file.rvv01
 DEFINE p_rvu00   LIKE rvu_file.rvu00      #FUN-810038
 DEFINE l_flag    LIKE type_file.num5      #FUN-810038
 DEFINE l_sql     STRING  #No.FUN-810036
 DEFINE l_rvbs    RECORD LIKE rvbs_file.*  #No.FUN-810036
 DEFINE l_pmm43   LIKE pmm_file.pmm43      #CHI-830033
 DEFINE l_cnt     LIKE type_file.num5      #MOD-840263
 DEFINE b_rvb     RECORD LIKE rvb_file.*
 DEFINE l_rvb01   LIKE rvb_file.rvb01
 DEFINE l_rvb02   LIKE rvb_file.rvb02
 DEFINE l_rvb05   LIKE rvb_file.rvb05
 DEFINE l_rvb07   LIKE rvb_file.rvb07
 DEFINE l_rvv17a  LIKE rvv_file.rvv17
 DEFINE l_rvv32   LIKE rvv_file.rvv32  #仓库  #add by sunll 170725
 DEFINE l_rvv33   LIKE rvv_file.rvv33  #储位
 DEFINE l_rvv34   LIKE rvv_file.rvv34  #批号
 DEFINE l_sum     LIKE rvv_file.rvv17  #
 DEFINE l_barcode LIKE type_file.chr100
            
 
 LET l_rvv.rvv01 = p_rvv01
 
 LET l_sql ="select rvb01,rvv32,rvv33,barcode,lotnumber,rvb05,sum(rvv17) 
             from t003_file
             group by rvb01,rvv32,rvv33,barcode,lotnumber,rvb05"
 PREPARE t003_file_rvv1 FROM l_sql
 DECLARE t003_file_rvv_curs1 CURSOR FOR t003_file_rvv1
 FOREACH t003_file_rvv_curs1 INTO l_rvb01,l_rvv32,l_rvv33,l_barcode,l_rvv34,l_rvb05,l_sum
    IF l_sum=0 THEN 
       CONTINUE FOREACH 
    END IF 	
  
 LET l_sql =" select * from t003_file1",
            " where rvv17a>0 and rvb05='",l_rvb05,"' and rvb01='",l_rvb01,"'",
            " order by rvb01,rvb02"
 PREPARE t003_file_rvv FROM l_sql
 DECLARE t003_file_rvv_curs CURSOR FOR t003_file_rvv
 FOREACH t003_file_rvv_curs INTO l_rvb01,l_rvb02,l_rvb05,l_rvb07,l_rvv17a
     IF STATUS THEN
       EXIT FOREACH
     END IF
     	###add by nihuan 20170613------start-------
     	
     IF l_sum=0 THEN 
        EXIT FOREACH 
     END IF 		
     IF l_sum>=l_rvv17a THEN
     	  LET l_rvv.rvv17 = l_rvv17a
     	  LET l_sum=l_sum-l_rvv17a
     	  UPDATE t003_file1 SET rvv17a=0
     	  WHERE rvb05=l_rvb05 AND rvb01=l_rvb01 AND rvb02=l_rvb02
     ELSE 
     	  LET l_rvv.rvv17 =	l_sum
     	  
     	  UPDATE t003_file1 SET rvv17a=l_rvv17a-l_sum
     	  WHERE rvb05=l_rvb05 AND rvb01=l_rvb01 AND rvb02=l_rvb02
     	  LET l_sum=0
     END IF
   # SELECT ime01 INTO l_rvv.rvv32 FROM ime_file  WHERE ime02=l_rvv33
     LET l_rvv.rvv32=l_rvv32     #仓库
     LET l_rvv.rvv33=l_rvv33     #儲位
     LET l_rvv.rvv34=l_rvv34     #批號	 
     	###add by nihuan 20170613------end---------	
     SELECT tc_ibb21 INTO l_rvv.rvvud13 FROM tc_ibb_file where tc_ibb01=l_barcode   #add by sunll 170804
     		
     SELECT * INTO b_rvb.* FROM rvb_file WHERE rvb01=l_rvb01 AND rvb02=l_rvb02
     SELECT MAX(rvv02)+1 INTO l_rvv.rvv02 FROM rvv_file   #序號
     WHERE rvv01=l_rvv.rvv01
     IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02=1 END IF
      LET l_rvv.rvv03='1'                                  #異動類別
#      LET l_rvv.rvv17 = l_rvv17a            #数量       #No.MOD-8A0112 add
      LET l_rvv.rvv86=b_rvb.rvb86
      LET l_rvv.rvv87=b_rvb.rvb87

      LET l_rvv.rvv04=g_rva.rva01     #驗收單號
      LET l_rvv.rvv05=b_rvb.rvb02     #驗收項次
      LET l_rvv.rvv06=g_rva.rva05     #廠商
      LET l_rvv.rvv09=g_today         #異動日
      LET l_rvv.rvv18=b_rvb.rvb34     #工單編號
      LET l_rvv.rvv23=0               #已請款匹配數量
      LET l_rvv.rvv88=0               #No.TQC-7B0083
      LET l_rvv.rvv24=NULL
      LET l_rvv.rvv25=b_rvb.rvb35     #樣品
      LET l_rvv.rvv26=NULL
      LET l_rvv.rvv31=b_rvb.rvb05     #料號
      
      LET l_rvv.rvv89=b_rvb.rvb89     #FUN-940083 VMI收貨否 --add
      
      IF cl_null(l_rvv.rvv89) THEN
         LET l_rvv.rvv89 = 'N' 
      END IF
      
      SELECT ima44 INTO l_ima44 FROM ima_file WHERE ima01=l_rvv.rvv31
      
      IF b_rvb.rvb05[1,4]='MISC' THEN      #品名
         LET l_rvv.rvv031 = b_rvb.rvb051
      ELSE
         SELECT ima02 INTO l_rvv.rvv031 FROM ima_file
          WHERE ima01=b_rvb.rvb05
      END IF
#      SELECT rvv32 INTO l_rvv32 FROM t003_file WHERE rvb01=l_rvb01 AND rvb05=l_rvb05 AND rownum=1
#      SELECT ime01 INTO l_rvv32 FROM ime_file  WHERE ime02=l_rvv32
#      LET l_rvv.rvv32=l_rvv32         #倉庫
#      LET l_rvv.rvv33=b_rvb.rvb37     #儲位
#      LET l_rvv.rvv34=b_rvb.rvb38     #批號
      IF cl_null(l_rvv.rvv32) THEN LET l_rvv.rvv32=' ' END IF
      IF cl_null(l_rvv.rvv33) THEN LET l_rvv.rvv33=' ' END IF
      IF cl_null(l_rvv.rvv34) THEN LET l_rvv.rvv34=' ' END IF
      
      LET l_rvv.rvv35 = b_rvb.rvb90
      LET l_rvv.rvv35_fac = b_rvb.rvb90_fac
      
      #Add by ZDJ110118  --begin
      IF cl_null(l_rvv.rvv35_fac) THEN
         SELECT pmn09 INTO l_rvv.rvv35_fac 
          FROM pmn_file
          WHERE pmn01 = b_rvb.rvb04
            AND pmn02 = b_rvb.rvb03
      END IF
      #Add by ZDJ110118  --end
      
      
      IF g_sma.sma115='Y' THEN
         CALL t110sub_set_rvv87(l_rvv.rvv31,l_rvv.rvv84,l_rvv.rvv85,   #FUN-A10130
                             l_rvv.rvv81,l_rvv.rvv82,l_rvv.rvv86,0,'')
              RETURNING l_rvv.rvv87
      ELSE
         CALL t110sub_set_rvv87(l_rvv.rvv31,1,0,1,l_rvv.rvv17, #FUN-A10130
                             l_rvv.rvv86,1,l_rvv.rvv35)
              RETURNING l_rvv.rvv87
      END IF
      
      LET l_flag=TRUE
 
#不須檢查img_file的合理性
   IF NOT cl_null(l_rvv.rvv32) THEN  #FUN-810038  AND (g_sma.sma886[7,7] = 'Y')
      SELECT img09 INTO g_img09_t FROM img_file
       WHERE img01 = l_rvv.rvv31
         AND img02 = l_rvv.rvv32
         AND img03 = l_rvv.rvv33
         AND img04 = l_rvv.rvv34
        IF STATUS=100 AND (l_rvv.rvv32 IS NOT NULL AND l_rvv.rvv32 <> ' ') THEN
           CALL s_add_img(l_rvv.rvv31,l_rvv.rvv32,
                          l_rvv.rvv33,l_rvv.rvv34,
                          l_rvv.rvv01,l_rvv.rvv02,
                          g_today)
        END IF
 
      LET g_ima906 = NULL
      LET g_ima907 = NULL
      SELECT ima906,ima907 INTO g_ima906,g_ima907 FROM ima_file
       WHERE ima01=l_rvv.rvv31
 
      IF g_sma.sma115 = 'Y' AND g_ima906 MATCHES '[23]' THEN
         IF NOT cl_null(l_rvv.rvv83) THEN
            CALL s_chk_imgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                            l_rvv.rvv83) RETURNING g_flag
            IF g_flag = 1 THEN
               CALL s_add_imgg(l_rvv.rvv31,l_rvv.rvv32,
                               l_rvv.rvv33,l_rvv.rvv34,
                               l_rvv.rvv83,l_rvv.rvv84,
                               l_rvv.rvv01,l_rvv.rvv02,0) RETURNING g_flag
               IF g_flag = 1 THEN
               	   LET g_status.code = -1
                   LET g_status.sqlcode = SQLCA.SQLCODE
                   LET g_status.description="产生imgg_file有错误!"
                   LET g_success = 'N'
                   RETURN
               END IF
            END IF
 
            CALL s_du_umfchk(l_rvv.rvv31,'','','',l_ima44,l_rvv.rvv83,g_ima906)
                 RETURNING g_errno,l_rvv.rvv84
 
            IF NOT cl_null(g_errno) THEN
            	  LET g_status.code = -1
                LET g_status.sqlcode = SQLCA.SQLCODE
                LET g_status.description="单位换算率抓不到!"
                LET g_success = 'N' 
                RETURN
            END IF
         END IF
 
         IF NOT cl_null(l_rvv.rvv80) AND g_ima906 = '2' THEN
            CALL s_chk_imgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                            l_rvv.rvv80) RETURNING g_flag
            IF g_flag = 1 THEN
               CALL s_add_imgg(l_rvv.rvv31,l_rvv.rvv32,
                               l_rvv.rvv33,l_rvv.rvv34,
                               l_rvv.rvv80,l_rvv.rvv81,
                               l_rvv.rvv01,l_rvv.rvv02,0) RETURNING g_flag
               IF g_flag = 1 THEN
               	   LET g_status.code = -1
                   LET g_status.sqlcode = SQLCA.SQLCODE
                   LET g_status.description="产生imgg_file有错误!"
                   LET g_success = 'N'
                   RETURN
               END IF
            END IF
 
            CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv80,l_ima44)
                 RETURNING g_i,l_rvv.rvv81
            IF g_i = 1 THEN
                LET g_status.code = -1
                LET g_status.sqlcode = SQLCA.SQLCODE
                LET g_status.description="单位换算率抓不到!"
                LET g_success = 'N' RETURN
            END IF
         END IF
 
         IF g_ima906 = '3' THEN
            IF l_rvv.rvv85 <> 0 THEN
               LET l_rvv.rvv84=l_rvv.rvv82/l_rvv.rvv85
            ELSE
               LET l_rvv.rvv84=0
            END IF
         END IF
      END IF
 
      IF g_sma.sma115='Y' THEN
          CALL t110sub_set_rvv87(l_rvv.rvv31,l_rvv.rvv84,l_rvv.rvv85,   #FUN-A10130
                                l_rvv.rvv81,l_rvv.rvv82,l_rvv.rvv86,0,'')
               RETURNING l_rvv.rvv87
      ELSE
          CALL t110sub_set_rvv87(l_rvv.rvv31,1,0,1,l_rvv.rvv17,  #FUN-A10130
                                l_rvv.rvv86,1,l_rvv.rvv35)
                RETURNING l_rvv.rvv87
      END IF
   END IF
 
   IF cl_null(l_rvv.rvv86) THEN
      LET l_rvv.rvv86 = l_rvv.rvv35
      LET l_rvv.rvv87 = l_rvv.rvv17
   ELSE
   #入庫量=實收量,收貨計價數量給予入庫數量,避免計價數量在來源是調整後的值
   #而在入庫時又重推值
    IF l_rvv.rvv17=b_rvb.rvb07  THEN
       LET l_rvv.rvv87=b_rvb.rvb87
    END IF 
   END IF
 
   LET l_rvv.rvv36=b_rvb.rvb04     #採購單號
   LET l_rvv.rvv37=b_rvb.rvb03     #採購單序號
   LET l_rvv.rvv38=b_rvb.rvb10
   LET l_rvv.rvv38t=b_rvb.rvb10t   #No.FUN-550117
   LET l_rvv.rvv39=l_rvv.rvv87*l_rvv.rvv38
   LET l_rvv.rvv39t=l_rvv.rvv87*l_rvv.rvv38t   #No.FUN-540027
   LET l_rvv.rvv41=b_rvb.rvb25     #手冊編號 no.A050
   LET l_rvv.rvv930=b_rvb.rvb930  #成本中心 #FUN-670051
   LET l_rvv.rvv10 = b_rvb.rvb42
   LET l_rvv.rvv11 = b_rvb.rvb43
   LET l_rvv.rvv12 = b_rvb.rvb44
   LET l_rvv.rvv13 = b_rvb.rvb45
   IF l_rvv.rvv10 IS NULL THEN LET l_rvv.rvv10 = '1' END IF
   LET t_azi04=''            #No.CHI-6A0004
 
      SELECT azi04 INTO t_azi04  #No.CHI-6A0004
        FROM pmm_file,azi_file
       WHERE pmm22=azi01
         AND pmm01 = l_rvv.rvv36 #採購單號
         AND pmm18 <> 'X' 
   IF cl_null(t_azi04) THEN  #No.CHI-6A0004
      LET t_azi04=0   #No.CHI-6A0004
   END IF
 
   CALL cl_digcut(l_rvv.rvv39,t_azi04) RETURNING l_rvv.rvv39   #No.CHI-6A0004
   CALL cl_digcut(l_rvv.rvv39t,t_azi04) RETURNING l_rvv.rvv39t #MOD-860297
 
  #不使用單價*數量=金額, 改以金額回推稅率, 以避免小數位差的問題
  SELECT gec07,pmm43 INTO g_gec07,l_pmm43 FROM gec_file,pmm_file
   WHERE gec01 = pmm21
     AND pmm01 = l_rvv.rvv36
  IF SQLCA.SQLCODE = 100 THEN
      LET g_status.code = -1
      LET g_status.sqlcode = SQLCA.SQLCODE
      LET g_status.description="无此采购单项次,请重新录入!"
      LET g_success = 'N'
      RETURN
  END IF
  IF g_gec07='Y' THEN
     LET l_rvv.rvv39 = l_rvv.rvv39t / ( 1 + l_pmm43/100)
     LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)  
  ELSE
     LET l_rvv.rvv39t = l_rvv.rvv39 * ( 1 + l_pmm43/100)
     LET l_rvv.rvv39t = cl_digcut( l_rvv.rvv39t , t_azi04)  
  END IF
  
   LET l_rvv.rvv40 = 'N'
   IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02 = 1 END IF
 
 
   LET l_rvv.rvv88 = 0  #No.TQC-7B0083
   LET l_rvv.rvvlegal = g_rva.rvalegal
   LET l_rvv.rvvplant = g_plant #NO.FUN-980006 jarlin add
   LET l_rvv.rvvlegal = g_legal #NO.FUN-980006 jarlin add
   INSERT INTO rvv_file VALUES (l_rvv.*)
   IF STATUS THEN
   	  LET g_status.code = -1
      LET g_status.sqlcode = SQLCA.SQLCODE
      LET g_status.description="插入rvv_file有错误!"
      LET g_success='N'
      RETURN
   END IF
   END FOREACH
   
   END FOREACH 
END FUNCTION
	
FUNCTION t720_ins_ibb(p_rvu01)
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
 
 LET l_sql=" select barcode,rvb05,lotnumber,rvv17",
           " from t003_file "
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
#    LET l_ibb.ibb17=l_lotnumber                 #批号
#    LET l_ibb.ibb14=l_rvv17                 #数量
#    LET l_ibb.ibb20=g_today                 #生成日期
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
	
FUNCTION t003_ins_tlfb(p_rvv01)
	DEFINE l_sql    STRING
	DEFINE p_rvv01  LIKE rvv_file.rvv01
	DEFINE l_rvb05   LIKE rvb_file.rvb05
	DEFINE l_n       LIKE type_file.num5
             LET l_sql="select * from t003_file"
             PREPARE t003_file_tlfb FROM l_sql
             DECLARE t003_file_tlfb_curs CURSOR FOR t003_file_tlfb
             FOREACH t003_file_tlfb_curs INTO g_tlfb.tlfb07,g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb01,
                                              g_tlfb.tlfb04,l_rvb05,g_tlfb.tlfb05
                SELECT ime01 INTO g_tlfb.tlfb02 FROM ime_file WHERE ime02=g_tlfb.tlfb03
                LET g_tlfb.tlfb09 = p_rvv01         #入库单号
                LET g_tlfb.tlfb06 = 1               #入库
                LET g_tlfb.tlfb14 = g_today         #扫描日期
                LET g_tlfb.tlfb17 = ' '             #杂收理由码
                LET g_tlfb.tlfb18 = ' '             #产品分类码
    #            LET g_tlfb.tlfb905 = g_tlfb.tlfb09
    #            LET g_tlfb.tlfb906 = g_tlfb.tlfb10             
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
                          g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,g_tlfb.tlfb05,1,'')
                  ELSE
                    CALL s_up_imgb(g_tlfb.tlfb01,    #更新条码库存档
                     g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,
                     g_tlfb.tlfb05,1,'') 
                 END IF 
            END FOREACH
END FUNCTION

FUNCTION t003_m(p_rvu01)                                                                                                                   
  DEFINE li_result   LIKE type_file.num5
  DEFINE p_rvu01     LIKE rvu_file.rvu01
  DEFINE l_sfb39     LIKE sfb_file.sfb39
  DEFINE g_factor    LIKE type_file.num5
  DEFINE g_ima25     LIKE ima_file.ima25   
  DEFINE l_rvv17_sum LIKE rvv_file.rvv17                                                                                      
  DEFINE l_rvv    RECORD LIKE rvv_file.*,                                                                                           
         l_sfa    RECORD LIKE sfa_file.*,                                                                                           
         l_sfs    RECORD LIKE sfs_file.*,                                                                                           
         l_qpa    LIKE sfa_file.sfa161,                                                                                             
         l_qty    LIKE sfs_file.sfs05,                                                                                                                                                                                           
         g_t1     LIKE oay_file.oayslip,                                                                                            
         l_flag   LIKE type_file.chr1,                                                                                              
         l_name   LIKE type_file.chr20,                                                                                             
         l_sfp    RECORD                                                                                                            
               sfp01   LIKE sfp_file.sfp01,                                                                                         
               sfp02   LIKE sfp_file.sfp02,                                                                                         
               sfp03   LIKE sfp_file.sfp03,                                                                                         
               sfp04   LIKE sfp_file.sfp04,                                                                                         
               sfp05   LIKE sfp_file.sfp05,                                                                                         
               sfp06   LIKE sfp_file.sfp06,                                                                                         
               sfp07   LIKE sfp_file.sfp07                                                                                          
                  END RECORD,                                                                                                       
         l_sfb81  LIKE sfb_file.sfb81,                                                                                              
         l_sfb82  LIKE sfb_file.sfb82,                                                                                              
         l_bdate  LIKE type_file.dat, 
         l_edate  LIKE type_file.dat,                                                                                               
         l_day    LIKE type_file.num5,                                                                                              
         l_cnt    LIKE type_file.num5                                                                                               
  DEFINE l_sfv11 LIKE sfv_file.sfv11                                                                                                
  DEFINE l_msg  LIKE type_file.chr1000                                                                                              
  DEFINE l_sfb04  LIKE sfb_file.sfb04                                                                                               
  DEFINE l_sfb02  LIKE sfb_file.sfb02                                                                                               
  DEFINE l_sfp02  LIKE sfp_file.sfp02                                                                                               
  DEFINE g_ima55  LIKE ima_file.ima55  
  DEFINE l_pmn43  LIKE pmn_file.pmn43   #FUN-A60076
  DEFINE l_pmn012 LIKE pmn_file.pmn012  #FUN-A60076
  DEFINE g_rvu    RECORD LIKE rvu_file.*
  
     SELECT * INTO g_rvu.* FROM rvu_file                                                                           
     WHERE rvu01 = p_rvu01                                                                                           
#...check是否是倒扣料                                                                    
    SELECT COUNT(*) INTO l_cnt FROM rvv_file,sfb_file                                                                               
     WHERE rvv01 = g_rvu.rvu01                                                                                                      
       AND rvv18 = sfb01                                                    
    IF l_cnt = 0 THEN RETURN  END IF                                                                                                                                                                                
                                                                                                                                    
    LET l_flag =' '                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    #新增一筆資料
    SELECT tc_codesys03 INTO g_rvu.rvu16 FROM tc_codesys_file WHERE tc_codesys00='0'                                                                                                                                                                                                                 
       CALL s_auto_assign_no("asf",g_rvu.rvu16,g_rvu.rvu03,"","sfp_file","sfp01","","","")                                          
         RETURNING li_result,g_rvu.rvu16                                                                                            
       IF (NOT li_result) THEN                                                                                                      
   	      LET g_status.code = -1
          LET g_status.sqlcode = SQLCA.SQLCODE
          LET g_status.description="产生rvu16领料单号有错误!"
          LET g_success='N'
          RETURN                                                                                                                    
       END IF                                                                                                                                                                                                                                                                                                                                   
#      #----先檢查領料單身資料是否已經存在------------                                                                               
#       DECLARE count_cur CURSOR FOR
#           SELECT COUNT(*) FROM sfs_file                                                                                            
#       WHERE sfs01 = g_rvu.rvu16                                                                                                        
#       OPEN count_cur                                                                                                               
#       FETCH count_cur INTO g_cnt                                                                                                   
#       IF g_cnt > 0  THEN  #已存在                                                                                                  
#          LET l_flag ='Y'                                                                                                           
#       ELSE                                                                                                                         
#          LET l_flag ='N'                                                                                                           
#       END IF                                                                                                                       
       #-----------產生領料資料------------------------                                                                             
       DECLARE t720_rvv_cur CURSOR  WITH HOLD FOR                                                                                   
          SELECT *  FROM  rvv_file                                                                                                  
           WHERE rvv01 = g_rvu.rvu01                                                                                                
       LET l_cnt = 0                                                                                                                                                                                                            
       FOREACH t720_rvv_cur INTO l_rvv.*                                                                                            
         IF STATUS THEN                                                                                                                                                                                                             
            EXIT FOREACH
         END IF                                                                                                                     
         SELECT sfb04,sfb81,sfb02,sfb39                                                                                                   
           INTO l_sfb04,l_sfb81,l_sfb02,l_sfb39                                                                                            
           FROM sfb_file                                                                                                            
          WHERE sfb01 = l_rvv.rvv18                                                                                                                                                                                                                               
         IF STATUS THEN                                                                                                             
             LET g_status.code = -1
             LET g_status.sqlcode = SQLCA.SQLCODE
             LET g_status.description="入库单中对应工单不存在!"
             LET g_success='N'
             RETURN                                                                                                       
         END IF                                                                                                                     
                                                                                                                                    
         IF l_sfb04='1' THEN                                                                                                        
             CONTINUE FOREACH                                                                     
         END IF                                                                                                                     
                                                                                                                                    
         IF l_sfb04='8' THEN                                                                                                        
             CONTINUE FOREACH                                                                     
         END IF                                                                                                                     
         IF l_sfb39='1' THEN
         	   CONTINUE FOREACH
         END IF                                                                                                                            
                                                                                                                                    
         IF l_sfb02=13 THEN
            CONTINUE FOREACH                                                                    
         END IF                                                                                                                     
         DECLARE t720_sfs_cur CURSOR WITH HOLD FOR                                                                                  
         SELECT sfa_file.*,sfb82 FROM sfb_file,sfa_file                                                                             
          WHERE sfb01 = l_rvv.rvv18   #工單單號                                                                                     
            AND sfb01 = sfa01                                                                                                       
            #AND sfa11 = 'E'                                                                                                         
            ORDER BY sfa26                                                                                                                                                                                                             
        FOREACH t720_sfs_cur INTO l_sfa.*,l_sfb82                                                                                   
            INITIALIZE l_sfs.* TO NULL                                                                                              
            INITIALIZE l_sfp.* TO NULL                                                                                              
                                                                                                                                    
        #-------發料單頭--------------                                                                                              
          LET l_sfp.sfp01 = g_rvu.rvu16                                                                                                 
#領料單月份以完工入庫日期該月的最後一天為領料日                                                                                     
          LET l_sfp.sfp02 = g_today                                                                                                 
          LET l_sfp.sfp03 = g_today                                                                                                 
          IF MONTH(g_today) != MONTH(g_rvu.rvu03) THEN                                                                              
             IF MONTH(g_rvu.rvu03) = 12 THEN                                                                                        
                LET l_bdate = MDY(MONTH(g_rvu.rvu03),1,YEAR(g_rvu.rvu03))                                                           
                LET l_edate = MDY(1,1,YEAR(g_rvu.rvu03)+1)  
             ELSE                                                                                                                   
                LET l_bdate = MDY(MONTH(g_rvu.rvu03),1,YEAR(g_rvu.rvu03))                                                           
                LET l_edate = MDY(MONTH(g_rvu.rvu03)+1,1,YEAR(g_rvu.rvu03))                                                         
             END IF                                                                                                                 
             LET l_day = l_edate - l_bdate   #計算最後一天日期                                                                      
             LET l_sfp.sfp03 = MDY(MONTH(g_rvu.rvu03),l_day,YEAR(g_rvu.rvu03))                                                      
          END IF                                                                                                                    
          LET l_sfp.sfp04 = 'N'                                                                                                     
          LET l_sfp.sfp05 = 'N'                                                                                                     
          LET l_sfp.sfp06 ='4'                                                                                                      
          LET l_sfp.sfp07 = l_sfb82
          #----先檢查領料單身資料是否已經存在------------ 
          DECLARE count_cur CURSOR FOR
          SELECT COUNT(*) FROM sfs_file                                                                                            
          WHERE sfs01 = g_rvu.rvu16                                                                                                        
          OPEN count_cur                                                                                                               
          FETCH count_cur INTO g_cnt                                                                                                   
          IF g_cnt > 0  THEN  #已存在                                                                                                  
             LET l_flag ='Y'                                                                                                           
          ELSE                                                                                                                         
             LET l_flag ='N'                                                                                                           
          END IF                                                                                                
          IF l_flag ='Y' THEN                                                 
            UPDATE sfp_file SET sfp02= l_sfp.sfp02,                                                                                       
                             sfp04= l_sfp.sfp04,sfp05 = l_sfp.sfp05,                                                                      
                             sfp06= l_sfp.sfp06,sfp07 = l_sfp.sfp07,                                                                      
                             sfpgrup=g_grup,sfpconf='Y',                                                                                        
                             sfpmodu=g_user,sfpdate=g_today 
            WHERE sfp01 = l_sfp.sfp01                                                                                                    
            IF SQLCA.sqlcode THEN
            	 LET g_status.code = -1
               LET g_status.sqlcode = SQLCA.SQLCODE
               LET g_status.description="更新发料单头有错误!"
            	 LET g_success='N'
            	 RETURN
            END IF                                                                             
          ELSE                                                                                                                          
           INSERT INTO sfp_file(sfp01,sfp02,sfp03,sfp04,sfp05,sfp06,sfp07,sfp09,                                                      
                              sfpuser,sfpdate,sfpconf,sfpgrup,sfpplant,sfplegal,sfporiu,sfporig)                                                                      
              VALUES(l_sfp.sfp01,l_sfp.sfp02,l_sfp.sfp03,l_sfp.sfp04,                                                                           
                     l_sfp.sfp05,l_sfp.sfp06,l_sfp.sfp07,'N',                                                                                
                     g_user,g_today,'Y',g_grup,g_plant,g_legal, g_user, g_grup)                                                                                           #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
            	 LET g_status.code = -1
               LET g_status.sqlcode = SQLCA.SQLCODE
               LET g_status.description="插入发料单头有错误!" 
           	   LET g_success='N'
           	   RETURN 
            END IF                                                                             
          END IF                                                                                
          SELECT MAX(sfs02) INTO l_cnt FROM sfs_file                                                                                
           WHERE sfs01 = g_rvu.rvu16                                                                                                    
          IF l_cnt IS NULL THEN    #項次                                                                                            
             LET l_cnt = 1                                                                                                          
          ELSE  LET l_cnt = l_cnt + 1                                                                                            
          END IF                                                                                                                    
         #-------發料單身--------------                                                                                             
          LET l_sfs.sfs01 = g_rvu.rvu16                                                                                                 
          LET l_sfs.sfs02 = l_cnt                                                                                                   
          LET l_sfs.sfs03 = l_sfa.sfa01
          LET l_sfs.sfs04 = l_sfa.sfa03                                                                                             
          #LET l_sfs.sfs05 = l_rvv.rvv09*l_sfa.sfa161 #已發料量   #MOD-A70228                                                                     
          LET l_sfs.sfs05 = l_rvv.rvv17*l_sfa.sfa161 #已發料量   #MOD-A70228                                                                     
          LET l_sfs.sfs06 = l_sfa.sfa12  #發料單位                                                                                  
          LET l_sfs.sfs07 = l_sfa.sfa30  #倉庫                                                                                      
          LET l_sfs.sfs08 = l_sfa.sfa31  #儲位                                                                                      
          LET l_sfs.sfs09 = ' '          #批號                                                                                      
          LET l_sfs.sfs10 = l_sfa.sfa08  #作業序號                                                                                  
          LET l_sfs.sfs26 = NULL         #替代碼                                                                      
          LET l_sfs.sfs27 = NULL         #被替代料號                                                                                
          LET l_sfs.sfs28 = NULL         #替代率                                                                                    
          LET l_sfs.sfs930 = l_rvv.rvv930                                                                                           
          LET l_sfs.sfsplant = g_plant
          LET l_sfs.sfslegal = g_legal
          LET l_sfs.sfs012 = l_sfa.sfa012  #FUN-A60076
          LET l_sfs.sfs013 = l_sfa.sfa013  #FUN-A60076
         #IF l_sfa.sfa26 MATCHES '[SUT]' THEN      #FUN-A20037 
          IF l_sfa.sfa26 MATCHES '[SUTZ]' THEN      #FUN-A20037 
             LET l_sfs.sfs26 = l_sfa.sfa26                                                                                          
             LET l_sfs.sfs27 = l_sfa.sfa27                                                                                          
             LET l_sfs.sfs28 = l_sfa.sfa28                                                                                          
             #FUN-A60076 --------------------------start--------------------- 
             SELECT pmn43,pmn012 INTO l_pmn43,l_pmn012 FROM pmn_file
              WHERE pmn01 = l_rvv.rvv36 
                AND pmn02 = l_rvv.rvv37
             #FUN-A60076 -------------------------end------------------------ 
             SELECT (sfa161 * sfa28) INTO l_qpa FROM sfa_file                                                                       
                WHERE sfa01 = l_sfa.sfa01 AND sfa03 = l_sfa.sfa27                                                                   
                  AND sfa012 = l_pmn012 AND sfa013  = l_pmn43   #FUN-A60076
             #LET l_sfs.sfs05 = l_rvv.rvv09*l_qpa   #MOD-A70228                                                                                 
             LET l_sfs.sfs05 = l_rvv.rvv17*l_qpa   #MOD-A70228                                                                                 
             SELECT SUM(c) INTO l_qty FROM tmp WHERE a = l_sfa.sfa01                                                                
                AND b = l_sfa.sfa27                                                                                                 
             IF l_sfs.sfs05 < l_qty THEN                                                                                            
                LET l_sfs.sfs05 = 0 
             ELSE                                                                                                                   
                LET l_sfs.sfs05 = l_sfs.sfs05 - l_qty                                                                               
             END IF                                                                                                                 
          ELSE                                                                                                                      
             LET l_sfs.sfs27 = l_sfa.sfa27                                                                                          
          END IF                                                                                                                    
          CALL t720_chk_ima64(l_sfs.sfs04, l_sfs.sfs05) RETURNING l_sfs.sfs05                                                       
        #判斷發料是否大於可發料數(sfa05-sfa06)                                                                                      
          IF l_sfs.sfs05 > (l_sfa.sfa05 - l_sfa.sfa06) THEN                                                                         
             LET l_sfs.sfs05 = l_sfa.sfa05 - l_sfa.sfa06                                                                            
          END IF                                                                                                                    
          IF cl_null(l_sfs.sfs07) AND cl_null(l_sfs.sfs08) THEN                                                                     
             SELECT ima35,ima36 INTO  l_sfs.sfs07,l_sfs.sfs08                                                                       
               FROM ima_file                                                                                                        
              WHERE ima01 = l_sfs.sfs04                                                                                             
          END IF              
          SELECT tc_sub02 INTO l_sfs.sfs07 FROM tc_sub_file WHERE tc_sub01=g_rvu.rvu04
          LET l_sfs.sfs08=' ' 
          LET l_sfs.sfs09=' '                                                                                                  
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
             	   LET g_status.code = -1
                 LET g_status.sqlcode = SQLCA.SQLCODE
                 LET g_status.description="料件基础数据有误,ima25,ima55,ima906,ima907!" 
                 LET g_success = 'N'
                 RETURN                                                                                               
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
        INSERT INTO sfs_file VALUES (l_sfs.*)                                                                                   
            IF STATUS OR SQLCA.sqlerrd[3]=0 THEN                                                                                    
               LET g_status.code = -1
               LET g_status.sqlcode = SQLCA.SQLCODE
               LET g_status.description="插入发料单身sfs有错误!" 
           	   LET g_success='N'                                                                                                                                                                                     
            END IF                                                                                                                     
         SELECT SUM(rvv17) INTO l_rvv17_sum FROM rvv_file,rvu_file 
         WHERE rvv18=l_rvv.rvv18 AND rvu01=rvv01 AND rvuconf='Y'
         
         UPDATE sfb_file SET sfb081=l_rvv17_sum+l_rvv.rvv17
         WHERE sfb01=l_rvv.rvv18                                                                                                              
       END FOREACH                                                                                                                  
     END FOREACH                                                                                                                                                                                                                       
                                                                                                   
                                                                                                   
        UPDATE rvu_file SET rvu16 = g_rvu.rvu16                                                                                  
         WHERE rvu01 = g_rvu.rvu01                                                                                                  
        IF STATUS THEN                                                                                                              
           CALL cl_err('upd rvu',STATUS,1)                                                                                          
           LET g_success = 'N'                                                                                                      
        END IF                                                                                                                      
        #CALL i501sub_s(1,g_rvu.rvu16,TRUE,'N') #add by shenran暂时mark
                                                                                                                                                                                                                                                
END FUNCTION                            

FUNCTION t720_chk_ima64(p_part, p_qty)                                                                                              
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

#FUNCTION moer_apmt720()
#  DEFINE l_receiptString   STRING
#  DEFINE l_line            STRING
#  DEFINE l_sql             STRING
#  DEFINE l_rvv31           LIKE rvv_file.rvv31  #料号
#  DEFINE l_rvv17           LIKE rvv_file.rvv17  #数量
#  DEFINE l_rvu01           LIKE rvu_file.rvu01  #单号
#  DEFINE l_rvu04           LIKE rvu_file.rvu04  #供应商
#  DEFINE l_rvu03           LIKE rvu_file.rvu03  #日期
#  DEFINE l_rvv32           LIKE rvv_file.rvv32  #仓库
#  DEFINE l_statu           LIKE type_file.chr1
#  DEFINE l_response        STRING
#  
#  LET l_receiptString=''
#  LET l_line=''
#  LET l_rvv31=''
#  LET l_rvv17=''
#  LET l_sql = " select rvv31,rvv17 from rvv_file",
#              " where rvv01='",g_sr.rvu01,"'"
#          PREPARE moer_apmt720 FROM l_sql
#          DECLARE moer_apmt720_curs CURSOR FOR moer_apmt720
#          FOREACH moer_apmt720_curs INTO l_rvv31,l_rvv17
#           IF STATUS THEN
#             EXIT FOREACH
#           END IF
#              LET l_line=l_line,"<Line ItemCode=\"",l_rvv31,"\" TargetQty=\"",l_rvv17,"\"/>"
#              
#          END FOREACH   
#          LET l_receiptString="<receipt No=\"",g_sr.rvu01,"\">",l_line,"</receipt>"
#          DISPLAY l_receiptString
#          CALL CreateReceipt(l_receiptString) RETURNING l_statu,l_response
#   LET l_rvv31=''
#   LET l_rvv17=''
#   LET l_rvu01=''
#   LET l_rvu04=''
#   LET l_rvu03=''
#   LET l_rvv32=''
#   LET l_sql = "select rvu01,rvv31,rvu04,rvu03,rvv17,rvv32 from rvu_file,rvv_file",
#               " where rvu01=rvv01",
#               " and rvv01='",g_sr.rvu01,"'"
#          PREPARE moer_apmt7201 FROM l_sql
#          DECLARE moer_apmt720_curs1 CURSOR FOR moer_apmt7201
#          FOREACH moer_apmt720_curs1 INTO l_rvu01,l_rvv31,l_rvu04,l_rvu03,l_rvv17,l_rvv32
#           IF STATUS THEN
#             EXIT FOREACH
#           END IF
#           CALL SaveReceipt(l_rvu01,l_rvv31,l_rvu04,l_rvu03,l_rvv17,l_rvv32) RETURNING l_statu,l_response
#          END FOREACH
#                     
#END FUNCTION




	
