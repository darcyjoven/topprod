# Prog. Version..: '5.00.01-07.05.10(00010)'     #
# Pattern name...: cs_transf_po.4gl
# Descriptions...: ERP将采购单同步给SCM平台组xml函数
# Date & Author..: 16/01/01  By  LGe
# Note           : 传入值:
# ...............: 返回值:  Y-成功; N-失败
#                           code: 0 成功    其他为错误代码
#                           msg:  错误信息  成功，则msg为单号


DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

FUNCTION cs_transf_po(p_pmm01,p_op)
DEFINE p_op             LIKE type_file.chr1
DEFINE p_pmm01          LIKE pmm_file.pmm01
DEFINE l_ret            RECORD 
            success     LIKE type_file.chr1,
            code        LIKE type_file.chr10,
            msg         STRING 
                        END RECORD

    INITIALIZE l_ret TO NULL 
    LET l_ret.success = 'N'
    
    IF cl_null(p_pmm01) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "无采购单号！"
        RETURN l_ret.*
    END IF 
 
    IF cl_null(p_op) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "系统无法判断操作类别！"
        RETURN l_ret.*
    END IF 

    CALL cs_transf_deal(p_pmm01,p_op) RETURNING l_ret.*
   
    RETURN l_ret.*

END FUNCTION 


FUNCTION cs_transf_deal(p_pmm01,p_op) 
DEFINE p_pmm01          LIKE pmm_file.pmm01
DEFINE p_op             LIKE type_file.chr1
DEFINE l_ret            RECORD 
            success     LIKE type_file.chr1,
            code        LIKE type_file.chr10,
            msg         STRING 
                        END RECORD
DEFINE l_pmm18          LIKE pmm_file.pmm18
DEFINE l_pmm25          LIKE pmm_file.pmm25
DEFINE l_cnt            LIKE type_file.num5

    INITIALIZE l_ret TO NULL

    LET l_ret.success = 'Y'

    IF p_op = 'I' THEN 
        INITIALIZE l_cnt TO NULL
        SELECT COUNT(1) INTO l_cnt FROM pmm_file 
         WHERE pmm01 = p_pmm01
        IF cl_null(l_cnt) THEN 
            LET l_cnt = 0
        END IF 
        IF l_cnt = 0 THEN 
            LET l_ret.success = 'N'
            LET l_ret.msg = "未找到采购单(",p_pmm01 CLIPPED,"),请确认单据是否存在！"
            RETURN l_ret.*
        END IF 

        SELECT pmm18,pmm25 INTO l_pmm18,l_pmm25 FROM pmm_file 
         WHERE pmm01 = p_pmm01
        IF SQLCA.SQLCODE THEN 
            LET l_ret.success = 'N'
            LET l_ret.code = SQLCA.SQLCODE USING '-----'
            LET l_ret.msg = "获取采购单状态失败,SQLERR:",SQLCA.SQLCODE USING '-----'
            RETURN l_ret.*
        END IF 
        IF l_pmm18 = 'N' THEN 
            LET l_ret.success = 'N'
            LET l_ret.code = ''
            LET l_ret.msg = "采购单(",p_pmm01 CLIPPED,"还未审核,无法同步SCM系统!"
            RETURN l_ret.*
        END IF 
        IF l_pmm25 <> '2' THEN 
            LET l_ret.success = 'N'
            LET l_ret.code = ''
            LET l_ret.msg = "采购单尚未发放!"
            RETURN l_ret.*
        END IF 
    END IF 

    CALL cs_transf_po_create_xml(p_pmm01,p_op) RETURNING l_ret.*

    IF l_ret.success = 'Y' THEN 
        CALL addPurPurchaseOrder(l_ret.msg) RETURNING l_ret.code,l_ret.msg
        IF l_ret.code <> '0' THEN 
            LET l_ret.msg = "调取接口失败"
            LET l_ret.success = 'N'
            RETURN l_ret.*
        END IF 
        IF cl_null(l_ret.msg) OR l_ret.msg <> 'OK' THEN 
            LET l_ret.success = 'N'
            LET l_ret.msg = "同步SCM失败!"
            LET l_ret.code =''
        END IF 
    END IF 

    RETURN l_ret.*

END FUNCTION  

FUNCTION cs_transf_po_create_xml(p_pmm01,p_op)
DEFINE p_pmm01          LIKE pmm_file.pmm01
DEFINE p_op             LIKE type_file.chr1
DEFINE l_data           RECORD
         poNo           LIKE type_file.chr50,
         poDescription  LIKE type_file.chr1000,
         isDeleted      LIKE type_file.chr10,
         poType         LIKE type_file.chr10,
         poFrom         LIKE type_file.chr10,   #默认  40
         purchaseType   LIKE type_file.chr10,
         supplierCode   LIKE type_file.chr50,
         supplierName   LIKE type_file.chr1000,
         totalPrice     LIKE type_file.num20_6,
         currency       LIKE type_file.chr10,
         deliveryDate   LIKE type_file.chr10,
         deliveryPlace  LIKE type_file.chr1000,
         taxDiscription LIKE type_file.chr10,
         paymentMethod  LIKE type_file.chr1000,
         transType      LIKE type_file.chr1000,
         packageRequire LIKE type_file.chr1000,
         remark         LIKE type_file.chr1000,
        buyerName       LIKE type_file.chr100,
        effectiveDate   LIKE type_file.chr50,
        groupCode       LIKE type_file.chr50
                        END RECORD
DEFINE l_detail         RECORD
        demandCompanyId LIKE type_file.chr50,
        demandCompany   LIKE type_file.chr100,
        projectCode     LIKE type_file.chr50,
        projectName     LIKE type_file.chr1000,
        requireDate     LIKE type_file.chr20,
        productName     LIKE type_file.chr1000,
        materialNo      LIKE type_file.chr50,
        spec            LIKE type_file.chr1000,
        unit            LIKE type_file.chr50,
        amount          LIKE type_file.chr50,
        appointBrand    LIKE type_file.chr50,
   executionStandard    LIKE type_file.chr1000,
        remark          LIKE type_file.chr1000,
        deliveryDate    LIKE type_file.chr50,
        unitPrice       LIKE type_file.chr50,
        totalPrice      LIKE type_file.chr50,
        tax             LIKE type_file.chr50,
        serNo           LIKE type_file.chr50,
        requireNo       LIKE type_file.chr20,
        requireItem     LIKE type_file.chr20,
        deliveryPlace   LIKE type_file.chr20
                        END RECORD
DEFINE l_str            STRING
DEFINE l_xml            STRING
DEFINE l_ret            RECORD 
            success     LIKE type_file.chr1,
            code        LIKE type_file.chr10,
            msg         STRING 
                        END RECORD
DEFINE l_pmm            RECORD LIKE pmm_file.*
DEFINE l_pmn            RECORD LIKE pmn_file.*
DEFINE l_sql            STRING

    INITIALIZE l_str TO NULL
    INITIALIZE l_xml TO NULL
    INITIALIZE l_ret TO NULL

    LET l_ret.success = 'Y'

    INITIALIZE l_pmm TO NULL
    SELECT * INTO l_pmm.* FROM pmm_file 
     WHERE pmm01 = p_pmm01
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "获取采购单单头资料失败！SQLERR:",SQLCA.SQLCODE USING '-----'
        LET l_ret.code = SQLCA.SQLCODE USING '-----'
        RETURN l_ret.*
    END IF 
    
    INITIALIZE l_data TO NULL 
    LET l_data.poNo = l_pmm.pmm01
    LET l_data.poDescription = ""
    LET l_data.isDeleted = '0'
    LET l_data.poType = l_pmm.pmm02
    LET l_data.poFrom = '40'
    LET l_data.purchaseType = ""
    LET l_data.supplierCode = l_pmm.pmm09
    SELECT pmc081 INTO l_data.supplierName FROM pmc_file 
     WHERE pmc01 = l_pmm.pmm09
    LET l_data.totalPrice = l_pmm.pmm40t
    LET l_data.currency = l_pmm.pmm22
    LET l_data.deliveryDate = ""
    SELECT pme031 INTO l_data.deliveryPlace FROM pme_file 
     WHERE pme01 = l_pmm.pmm10
    LET l_data.taxDiscription = l_pmm.pmm21
    SELECT pma02 INTO l_data.paymentMethod FROM pma_file 
     WHERE pma01 = l_pmm.pmm20
    SELECT ged02 INTO l_data.transType FROM ged_file 
     WHERE ged01 = l_pmm.pmm16
    LET l_data.packageRequire = ""
    LET l_data.remark = ""
    LET l_data.buyerName = l_pmm.pmm12
    LET l_data.effectiveDate =''
    LET l_data.groupCode = l_pmm.pmmplant

    LET l_xml = cs_addPurPurchaseOrder_data(l_data.*)

    LET l_ret.msg = l_xml.trim()

    LET l_sql = "SELECT * FROM pmn_file WHERE pmn01 = '",p_pmm01 CLIPPED,"'"
    DECLARE cs_transf_get_pmn_cs CURSOR FROM l_sql
    
    INITIALIZE l_pmn TO NULL 
    FOREACH cs_transf_get_pmn_cs INTO l_pmn.*

        INITIALIZE l_detail TO NULL 

       #SELECT gem02 INTO l_detail.demandCompany  FROM gem_file 
       # WHERE gem01 = l_pmm.pmm13
        LET l_detail.demandCompany = l_pmm.pmm13
        LET l_detail.projectCode = ''
        LET l_detail.projectName = ''
        LET l_detail.requireDate = l_pmn.pmn35 USING 'YYYY-MM-DD'
        LET l_detail.productName = l_pmn.pmn041
        LET l_detail.materialNo = l_pmn.pmn04
        SELECT ima021 INTO l_detail.spec FROM ima_file 
         WHERE ima01 = l_pmn.pmn04
        LET l_detail.unit = l_pmn.pmn07
        LET l_detail.amount = l_pmn.pmn20
        LET l_detail.appointBrand = ""
        LET l_detail.executionStandard = ""
        LET l_detail.remark = ""
        LET l_detail.deliveryDate = l_pmn.pmn33 USING 'YYYY-MM-DD'
        LET l_detail.unitPrice = l_pmn.pmn31t
        LET l_detail.totalPrice = l_pmn.pmn88t
        LET l_detail.tax = cl_digcut(l_pmn.pmn88t - l_pmn.pmn88,2)
        LET l_detail.serNo = l_pmn.pmn02
        LET l_detail.requireNo = l_pmn.pmn24
        LET l_detail.requireItem = l_pmn.pmn25
        LET l_detail.deliveryPlace = '0'

        LET l_xml = cs_addPurPurchaseOrder_detail(l_detail.*)
       
        LET l_str = l_str.trim(),"<detail>",l_xml.trim(),"</detail>"
    END FOREACH
    LET l_str = "<details>",l_str.trim(),"</details>"
    LET l_ret.msg = "<data>",l_ret.msg.trim(),l_str.trim(),"</data>"

    RETURN l_ret.*

END FUNCTION 

