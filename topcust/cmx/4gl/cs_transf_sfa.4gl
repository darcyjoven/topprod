# Prog. Version..: '5.00.01-07.05.10(00010)'     #
# Pattern name...: cs_transf_sfa.4gl
# Descriptions...: 工单备料信息发送
# Date & Author..: 16/01/01  By  LGe
# Note           : 传入值:
# ...............: 返回值:  Y-成功; N-失败
#                           code: 0 成功    其他为错误代码
#                           msg:  错误信息  成功，则msg为单号

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

FUNCTION cs_transf_sfa(p_sfb01,p_op)
DEFINE p_sfb01          LIKE sfb_file.sfb01
DEFINE p_op             LIKE type_file.chr1
DEFINE l_ret            RECORD
            success     LIKE type_file.chr1,
            code        LIKE type_file.chr10,
            msg         STRING
                        END RECORD

    INITIALIZE l_ret TO NULL
    LET l_ret.success = 'N'

    IF cl_null(p_sfb01) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "无工单单号！"
        RETURN l_ret.*
    END IF 

    IF cl_null(p_op) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "系统无法判断操作类别！"
        RETURN l_ret.*
    END IF 

    CALL cs_transf_sfa_deal(p_sfb01,p_op) RETURNING l_ret.*

    RETURN l_ret.*


END FUNCTION 

FUNCTION cs_transf_sfa_deal(p_sfb01,p_op)
DEFINE p_sfb01          LIKE sfb_file.sfb01
DEFINE p_op             LIKE type_file.chr1
DEFINE l_ret            RECORD
            success     LIKE type_file.chr1,
            code        LIKE type_file.chr10,
            msg         STRING
                        END RECORD
DEFINE l_cnt            LIKE type_file.num10

    INITIALIZE l_ret TO NULL

    LET l_ret.success = 'Y'


    IF p_op = 'I' THEN
        INITIALIZE l_cnt TO NULL 
         SELECT COUNT(1) INTO l_cnt FROM sfb_file
         WHERE sfb01 = p_sfb01
        IF cl_null(l_cnt) THEN
            LET l_cnt = 0
        END IF
        IF l_cnt = 0 THEN
            LET l_ret.success = 'N'
            LET l_ret.msg = "未找到工单(",p_sfb01 CLIPPED,"),请确认单据是否存在！"
            RETURN l_ret.*
        END IF

        

    END IF 

    CALL cs_transf_sfb_create_xml(p_sfb01,p_op) RETURNING l_ret.*
    
    IF l_ret.success = 'Y' THEN
        CALL addMaterialRequire(l_ret.msg) RETURNING l_ret.code,l_ret.msg
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

FUNCTION cs_transf_sfb_create_xml(p_sfb01,p_op)
DEFINE p_sfb01          LIKE sfb_file.sfb01
DEFINE p_op             LIKE type_file.chr1
DEFINE l_data           RECORD
           createUserid LIKE gen_file.gen01,     #创建人
           createTime   LIKE type_file.chr20,      #创建时间
           docCode      LIKE type_file.chr20,    #单据编号
           busiType     LIKE type_file.chr10,    #发料类型
        appCompanyCode  LIKE gem_file.gem01,     #申请部门
        appCompanyName  LIKE gem_file.gem02,     #部门名称
        appUserCode     LIKE gen_file.gen01,     #申请人员
        appUserName     LIKE gen_file.gen02,     #人员名称
        operUserCode    LIKE gen_file.gen01,     #操作人员
        operUserName    LIKE gen_file.gen02,     #人员名称
        storeCode       LIKE type_file.chr20,    #仓库编号
        storeName       LIKE type_file.chr100,    #仓库名称
        companyCode     LIKE type_file.chr20,    #货权公司代码
        companyName     LIKE type_file.chr100,   #公司名称
        productLines    LIKE type_file.chr20,    #产线
        workTeam        LIKE type_file.chr20,    #班组
        groupCode       LIKE type_file.chr20,    #营运中心
        attr1           LIKE type_file.chr20,    #最终备料日期
        status          LIKE type_file.chr10     #状态
                        END RECORD
DEFINE l_detail         RECORD
         docCode        LIKE type_file.chr20,       #备料单号
         workCode       LIKE type_file.chr20,       #工单号
         jobCode        LIKE type_file.chr20,       #工序号
         materialCode   LIKE ima_file.ima01,        #料号
         materialName   LIKE ima_file.ima02,        #品名
         spec           LIKE ima_file.ima021,       #规格
         unit           LIKE type_file.chr10,       #单位
         needAmount     LIKE type_file.num15_3,     #需求量
         sendAmount     LIKE type_file.num15_3,     #已发量
         qpaAmount      LIKE sfa_file.sfa161,       #实际QPA
         warehouseCode  LIKE type_file.chr20,       #仓库代码
         warehouseName  LIKE type_file.chr100,       #仓库名称
         groupCode      LIKE type_file.chr20,       #营运中心
         projectCode    LIKE type_file.chr20,       #小项目号
   masterProjectCode    LIKE type_file.chr20,       #项目编号
   masterProjectName    LIKE type_file.chr100        #项目名称
                        END RECORD
DEFINE l_xml_data       STRING
DEFINE l_xml_detail     STRING
DEFINE l_ret            RECORD
            success     LIKE type_file.chr1,
            code        LIKE type_file.chr10,
            msg         STRING
                        END RECORD
DEFINE l_cnt            LIKE type_file.num10
DEFINE l_sfb            RECORD LIKE sfb_file.*
DEFINE l_sfa            RECORD LIKE sfa_file.*
DEFINE l_msg            STRING 


    INITIALIZE l_ret TO NULL 
    LET l_ret.success = 'Y'
   
    INITIALIZE l_cnt TO NULL 
    SELECT COUNT(1) INTO l_cnt FROM sfa_file 
     WHERE sfa01 = p_sfb01

    IF cl_null(l_cnt) THEN 
        LET l_cnt = 0
    END IF 

    IF l_cnt =0 THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "工单无备料信息！"
        RETURN l_ret.*
    END IF 

    INITIALIZE l_sfa TO NULL 
    SELECT * INTO l_sfb.* FROM sfb_file 
     WHERE sfb01 = p_sfb01
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "获取工单信息失败！"
        RETURN l_ret.*
    END IF 

    LET l_xml_data = ""
    LET l_data.createUserid = ""
    LET l_data.createTime = l_sfb.sfb81 USING 'YYYY-MM-DD'
    LET l_data.docCode = l_sfb.sfb01
    LET l_data.busiType = ""
    LET l_data.appCompanyCode = g_grup 
    
    SELECT gem02 
      INTO l_data.appCompanyName
      FROM gem_file
     WHERE gem01 = l_data.appCompanyCode

   #LET l_data.appCompanyName = l_sfp.sfp004
    LET l_data.appUserCode = g_user
    SELECT gen02 INTO l_data.appUserName
      FROM gen_file
     WHERE gen01 = g_user
   #LET l_data.appUserName = l_sfp.sfp006
   #LET l_data.operUserCode = l_sfp.sfp005
   #LET l_data.operUserName = l_sfp.sfp006
    LET l_data.operUserCode = ""
    LET l_data.operUserName = ""
    LET l_data.storeCode = ""
    LET l_data.storeName = ""
    LET l_data.companyCode = ""
    LET l_data.companyName = ""
    LET l_data.productLines = ""
    LET l_data.workTeam = l_sfb.sfb82
    LET l_data.groupCode = g_plant
    LET l_data.attr1 = l_sfb.sfb13 USING 'YYYY-MM-DD'
    LET l_data.status = "20"
    LET l_xml_data = cs_addmaterialrequire_data(l_data.*)

    DECLARE cs_get_sfa_cs CURSOR FOR 
     SELECT * FROM sfa_file WHERE sfa01 = p_sfb01

    FOREACH cs_get_sfa_cs INTO l_sfa.*

         LET l_msg = ""
          LET l_detail.docCode = l_sfb.sfb01
          LET l_detail.workCode = l_sfb.sfb01
          LET l_detail.jobCode = ""
          LET l_detail.materialCode = l_sfa.sfa03
          SELECT ima02,ima021 INTO l_detail.materialName,l_detail.spec 
            FROM ima_file 
           WHERE ima01 = l_detail.materialCode
          LET l_detail.unit = l_sfa.sfa12
          LET l_detail.needAmount = l_sfa.sfa05
          LET l_detail.sendAmount = l_sfa.sfa05
         #LET l_detail.qpaAmount = g_sfa[l_i].sfa161
          LET l_detail.qpaAmount = l_sfa.sfa161
          LET l_detail.warehouseCode = ""
          LET l_detail.warehouseName = ""
          LET l_detail.groupCode = g_plant
         #LET l_detail.projectCode = l_sfs.sfs015
         #LET l_detail.masterProjectCode =  l_sfs.sfs013
         #LET l_detail.masterProjectName =  ""

          LET l_msg = cs_addmaterialrequire_detail(l_detail.*)
          LET l_msg = "<detail>",l_msg.trim(),"</detail>"
          LET l_xml_detail = l_xml_detail.trim(),l_msg.trim()


    END FOREACH


    LET l_ret.msg = "<data>",l_xml_data.trim(),"<details>",l_xml_detail.trim(),"</details></data>"

    RETURN l_ret.*

END FUNCTION 
