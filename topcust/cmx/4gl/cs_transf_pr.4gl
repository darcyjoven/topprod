# Prog. Version..: '5.00.01-07.05.10(00010)'     #
# Pattern name...: cs_transf_pr.4gl
# Descriptions...: ERP将请购单同步给SCM平台组xml函数
# Date & Author..: 16/01/01  By  LGe
# Note           : 传入值:
# ...............: 返回值:  Y-成功; N-失败
#                           code: 0 成功    其他为错误代码
#                           msg:  错误信息  成功，则msg为单号


DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

FUNCTION cs_transf_pr(p_pmk01,p_op)
DEFINE p_op             LIKE type_file.chr1
DEFINE p_pmk01          LIKE pmk_file.pmk01
DEFINE l_ret            RECORD
            success     LIKE type_file.chr1,
            code        LIKE type_file.chr10,
            msg         STRING
                        END RECORD

    INITIALIZE l_ret TO NULL
    LET l_ret.success = 'N'

    IF cl_null(p_pmk01) THEN
        LET l_ret.success = 'N'
        LET l_ret.msg = "无请购单号！"
        RETURN l_ret.*
    END IF

    IF cl_null(p_op) THEN
        LET l_ret.success = 'N'
        LET l_ret.msg = "系统无法判断操作类别！"
        RETURN l_ret.*
    END IF

    CALL cs_transf_pr_deal(p_pmk01,p_op) RETURNING l_ret.*

    RETURN l_ret.*

END FUNCTION 

FUNCTION cs_transf_pr_deal(p_pmk01,p_op)
DEFINE p_pmk01          LIKE pmk_file.pmk01
DEFINE p_op             LIKE type_file.chr1
DEFINE l_ret            RECORD
            success     LIKE type_file.chr1,
            code        LIKE type_file.chr10,
            msg         STRING
                        END RECORD
DEFINE l_cnt            LIKE type_file.num5
DEFINE l_pmk18          LIKE pmk_file.pmk18


    INITIALIZE l_ret TO NULL

    LET l_ret.success = 'Y'

    IF p_op = 'I' OR p_op = 'U' THEN 

        INITIALIZE l_cnt TO NULL

        SELECT COUNT(1) INTO l_cnt FROM pmk_file 
         WHERE pmk01 = p_pmk01
        IF cl_null(l_cnt) THEN 
            LET l_cnt = 0
        END IF 

        IF l_cnt = 0 THEN 
            LET l_ret.success = 'N'
            LET l_ret.msg = "未找到请购单(",p_pmk01 CLIPPED,"),请确认单据是否存在！"
            RETURN l_ret.*
        END IF 

        INITIALIZE l_pmk18 TO NULL
        SELECT pmk18 INTO l_pmk18 FROM pmk_file 
         WHERE pmk01 = p_pmk01
        IF cl_null(l_pmk18) THEN 
            LET l_pmk18 = 'N'
        END IF 

        IF l_pmk18 = 'N' OR l_pmk18 = 'X' THEN 
            LET l_ret.success = 'N'
            LET l_ret.code = ''
            LET l_ret.msg = "请购单(",p_pmk01 CLIPPED,"还未审核或已无效,无法同步SCM系统!"
            RETURN l_ret.*
        END IF 

    END IF 

    CALL cs_transf_pr_create_xml(p_pmk01,p_op) RETURNING l_ret.*

   #IF l_ret.success = 'Y' THEN 
   #    IF p_op = 'I' THEN 
   #        CALL addPurMaterialRequire(l_ret.msg) RETURNING l_ret.code,l_ret.msg
   #    END IF 
   #    IF p_op = 'U' THEN 
   #        CALL updatePurMaterialRequire(l_ret.msg) RETURNING l_ret.code,l_ret.msg
   #    END IF 
   #    IF p_op = 'D' THEN 
   #        CALL deletePurMaterialRequire(l_ret.msg) RETURNING l_ret.code,l_ret.msg
   #    END IF 
   #    IF l_ret.code <> '0' THEN 
   #        LET l_ret.msg = "调取接口失败"
   #        LET l_ret.success = 'N'
   #        RETURN l_ret.*
   #    END IF 
   #    IF cl_null(l_ret.msg) OR l_ret.msg <> 'OK' THEN 
   #        LET l_ret.success = 'N'
   #        LET l_ret.msg = "同步SCM失败!"
   #        LET l_ret.code =''
   #    END IF 
   #END IF 

    RETURN l_ret.*

END FUNCTION 


FUNCTION cs_transf_pr_create_xml(p_pmk01,p_op)
DEFINE p_pmk01          LIKE pmk_file.pmk01
DEFINE p_op             LIKE type_file.chr1
DEFINE l_data           RECORD
          createUserid  LIKE type_file.chr10,
          status        LIKE type_file.chr10,
          createTime    LIKE type_file.chr50,
          demandCompany LIKE type_file.chr50,
          projectCode   LIKE type_file.chr50,
          projectName   LIKE type_file.chr50,
          requireNo     LIKE type_file.chr50,
          requireItem   LIKE type_file.num10,
          requireDate   LIKE type_file.chr20,
       requireProperty  LIKE type_file.chr10,
          productName   LIKE type_file.chr1000,
          materialCode  LIKE type_file.chr50,
          spec          LIKE type_file.chr1000,
          unit          LIKE type_file.chr10,
       requireAmount    LIKE type_file.chr20,
       referenceBrand   LIKE type_file.chr50,
       appointBrand     LIKE type_file.chr50,
    executionStandard   LIKE type_file.chr1000,
       deliveryPlace    LIKE type_file.chr10,
       groupCode        LIKE type_file.chr20,
    demandCompanyCode   LIKE type_file.chr20,
       applyUserCode    LIKE type_file.chr20,
       applyUser        LIKE type_file.chr20,
       applyUserEmail   LIKE type_file.chr100,
       applyUserMobile  LIKE type_file.chr20,
       purLeadTime      LIKE type_file.chr10,
       supplierCode     LIKE type_file.chr20,
       supplierName     LIKE type_file.chr100,
       attr1            LIKE type_file.chr50,
       attr2            LIKE type_file.chr50,
       attr3            LIKE type_file.chr50,
       attr4            LIKE type_file.chr50,
       attr5            LIKE type_file.chr50,
       attr6            LIKE type_file.chr50,
       attr7            LIKE type_file.chr50,
       attr8            LIKE type_file.chr50,
       attr9            LIKE type_file.chr50,
       attr10           LIKE type_file.chr50
                        END RECORD
DEFINE l_str            STRING
DEFINE l_xml            STRING
DEFINE l_sql            STRING
DEFINE l_pmk            RECORD LIKE pmk_file.*
DEFINE l_pml            RECORD LIKE pml_file.*
DEFINE l_ret            RECORD 
            success     LIKE type_file.chr1,
            code        LIKE type_file.chr10,
            msg         STRING 
                        END RECORD

    INITIALIZE l_str TO NULL
    INITIALIZE l_xml TO NULL
    INITIALIZE l_ret TO NULL
    LET l_ret.success = 'Y'

    INITIALIZE l_pmk TO NULL
    SELECT * INTO l_pmk.* FROM pmk_file
     WHERE pmk01 = p_pmk01

    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "获取请购单单头资料失败！SQLERR:",SQLCA.SQLCODE USING '-----'
        LET l_ret.code = SQLCA.SQLCODE USING '-----'
        RETURN l_ret.*
    END IF 

    
    INITIALIZE l_xml TO NULL
    INITIALIZE l_data TO NULL 
    IF p_op = 'D' THEN 
        LET l_data.requireNo = l_pmk.pmk01
        CALL cs_deletePurMaterialRequire_data(l_data.requireNo,l_pmk.pmkplant) RETURNING l_xml
        LET l_xml ="<data>",l_xml.trim(),"</data>"
        CALL deletePurMaterialRequire(l_xml) RETURNING l_ret.code,l_ret.msg
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
    ELSE 

        LET l_sql = "SELECT * FROM pml_file ",
                    " WHERE pml01 = '",l_pmk.pmk01 CLIPPED,"'",
                    "   AND (pmlud06 IS NULL OR pmlud06 = '0')"
        DECLARE cs_transf_get_pmk_cs CURSOR FROM l_sql

        INITIALIZE l_pml TO NULL
        FOREACH cs_transf_get_pmk_cs INTO l_pml.*
            LET l_data.createUserid = "1"
            LET l_data.status = "0"
            LET l_data.createTime = l_pmk.pmkcond USING 'YYYY-MM-DD',"T",l_pmk.pmkcont CLIPPED,"+0800"
            SELECT gem02 INTO l_data.demandCompany FROM gem_file WHERE gem01 = l_pmk.pmk13
            LET l_data.projectCode = ""
            LET l_data.projectName = ""
            LET l_data.requireNo = l_pmk.pmk01
            LET l_data.requireItem = l_pml.pml02
            LET l_data.requireDate = l_pml.pml33 USING 'YYYY-MM-DD'
            LET l_data.requireProperty = l_pmk.pmk02
            LET l_data.productName = l_pml.pml041 
            LET l_data.materialCode = l_pml.pml04 
            SELECT ima02 INTO l_data.spec FROM ima_file WHERE ima01 = l_pml.pml04
            LET l_data.unit = l_pml.pml07
            LET l_data.requireAmount = l_pml.pml20
            LET l_data.referenceBrand = ""
            LET l_data.appointBrand = ""
            LET l_data.executionStandard = ""
            LET l_data.deliveryPlace = "0"
            LET l_data.groupCode = l_pmk.pmkplant
            LET l_data.demandCompanyCode = l_pmk.pmk13 
            LET l_data.applyUserCode = l_pmk.pmk12
            SELECT gen02,gen06,gen08 
              INTO l_data.applyUser,l_data.applyUserEmail,l_data.applyUserMobile
              FROM gen_file 
             WHERE gen01 = l_pmk.pmk12
            SELECT ima48 INTO l_data.purLeadTime FROM ima_file 
             WHERE ima01 = l_pml.pml04
            LET l_data.supplierCode = l_pmk.pmk09
            SELECT pmc081 INTO l_data.supplierName FROM pmc_file 
             WHERE pmc01 = l_pmk.pmk09 
            LET l_data.attr1 = ""
            LET l_data.attr2 = ""
            LET l_data.attr3 = ""
            LET l_data.attr4 = ""
            LET l_data.attr5 = ""
            LET l_data.attr6 = ""
            LET l_data.attr7 = ""
            LET l_data.attr8 = ""
            LET l_data.attr9 = ""
            LET l_data.attr10= ""
            CALL cs_addPurMaterialRequire_data(l_data.*) RETURNING l_xml
            LET l_xml ="<data>",l_xml.trim(),"</data>"
      
            IF p_op = 'I' THEN 
                CALL addPurMaterialRequire(l_xml) RETURNING l_ret.code,l_ret.msg
            END IF 
            IF p_op = 'U' THEN 
                CALL updatePurMaterialRequire(l_xml) RETURNING l_ret.code,l_ret.msg
            END IF

            IF l_ret.code <> '0' THEN 
                LET l_ret.msg = "调取接口失败"
                LET l_ret.success = 'N'
                CONTINUE FOREACH
            END IF 
            IF cl_null(l_ret.msg) OR l_ret.msg <> 'OK' THEN 
                LET l_ret.success = 'N'
                LET l_ret.msg = "同步SCM失败!"
                LET l_ret.code =''
                CONTINUE FOREACH
            ELSE 
                UPDATE pml_file SET pmlud06 = '1'
                 WHERE pml01 = l_pml.pml01
                   AND pml02 = l_pml.pml02
            END IF 
        END FOREACH
    END IF 

    RETURN l_ret.*

END FUNCTION 
