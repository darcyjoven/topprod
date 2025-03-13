# Prog. Version..: '5.00.01-07.05.10(00010)'     #
# Pattern name...: cs_create_zm_xml.4gl
# Descriptions...: xml文档产生函数
# Date & Author..: 16/01/01  By  LGe


DATABASE ds

GLOBALS "../../../tiptop/config/top.global"


#***************************************************************
#Interface:addStoreEntry
#Descriptions:入库单资料上传
#***************************************************************
FUNCTION cs_addstoreentry_data_xml(l_data)
DEFINE l_data           RECORD 
           createUserid LIKE gen_file.gen01,     #创建人
           createTime   LIKE type_file.chr20,      #创建时间
           status       LIKE type_file.chr1,     #状态
           docCode      LIKE type_file.chr100,   #入库单，仓退单
           docDate      LIKE type_file.chr20,      #制单日期
           docType      LIKE type_file.chr1,     #单据类型
           purchaseType LIKE type_file.chr20,     #采购性质
           poNo         LIKE pmm_file.pmm01,     #采购订单号
           receiptNo    LIKE rva_file.rva01,     #收货单号
           supplierCode LIKE pmc_file.pmc01,     #供应商代码
           supplierName LIKE pmc_file.pmc03,     #供应商名称
           tax          LIKE pmm_file.pmm21,     #税种
           groupCode    LIKE pmm_file.pmmplant   #所属集团代码
                        END RECORD
DEFINE l_str            STRING 

    INITIALIZE l_str TO NULL

    LET l_str = l_str.trim(),"<createUserid>",l_data.createUserid CLIPPED,"</createUserid>"
    LET l_str = l_str.trim(),"<createTime>",l_data.createTime CLIPPED,"</createTime>"
    LET l_str = l_str.trim(),"<status>",l_data.status CLIPPED,"</status>"
    LET l_str = l_str.trim(),"<docCode>",l_data.docCode CLIPPED,"</docCode>"
    LET l_str = l_str.trim(),"<docDate>",l_data.docDate CLIPPED,"</docDate>"
    LET l_str = l_str.trim(),"<docType>",l_data.docType CLIPPED,"</docType>"
    LET l_str = l_str.trim(),"<purchaseType>",l_data.purchaseType CLIPPED,"</purchaseType>"
    LET l_str = l_str.trim(),"<poNo>",l_data.poNo CLIPPED,"</poNo>"
    LET l_str = l_str.trim(),"<receiptNo>",l_data.receiptNo CLIPPED,"</receiptNo>"
    LET l_str = l_str.trim(),"<supplierCode>",l_data.supplierCode CLIPPED,"</supplierCode>"
    LET l_str = l_str.trim(),"<supplierName>",l_data.supplierName CLIPPED,"</supplierName>"
    LET l_str = l_str.trim(),"<tax>",l_data.tax CLIPPED,"</tax>"
    LET l_str = l_str.trim(),"<groupCode>",l_data.groupCode CLIPPED,"</groupCode>"

    RETURN l_str

END FUNCTION 


FUNCTION cs_addstoreentry_detail_xml(l_detail)
DEFINE l_detail         RECORD 
           docType      LIKE type_file.chr1,      #单据类型: 1.入库单；2.验退单
           entryNo      LIKE rvu_file.rvu01,      #入库单号
           poSer        LIKE type_file.num10,     #入库项次
           receiptNo    LIKE type_file.num10,     #收货单号
           poNo         LIKE pmm_file.pmm01,      #订单号
           materialCode LIKE ima_file.ima01,      #物料编号
           batchNo      LIKE type_file.chr100,    #收货单批次号(物料相同批号相同)
           materialName LIKE ima_file.ima02,      #品名
           spec         LIKE ima_file.ima021,     #规格
           unit         LIKE pmn_file.pmn07,      #单位
           amount       LIKE pmn_file.pmn20,      #数量
           current      LIKE pmm_file.pmm22,      #币种代码
           unitPrice    LIKE pmn_file.pmn31t,     #含税单价
           warehouse    LIKE pmn_file.pmn52,      #仓库名称
           location     LIKE type_file.chr10,     #库位描述
           companyId    LIKE type_file.num10,     #货权公司ID
           companyCode  LIKE type_file.chr100,    #货权公司代码
           companyName  LIKE type_file.chr100,    #货权公司名称
           projectCode  LIKE type_file.chr100,    #小项目号
     masterProjectCode  LIKE type_file.chr100,    #大项目号
     masterProjectName  LIKE type_file.chr100,    #大项目名称
           groupCode    LIKE type_file.chr100,    #所属集团代码
           attr1        LIKE type_file.chr1,      #托盘入库否
           tax          LIKE pmm_file.pmm21       #税种
                        END RECORD
DEFINE l_str            STRING 

    INITIALIZE l_str TO NULL

    LET l_str = l_str.trim(),"<docType>",l_detail.docType CLIPPED,"</docType>"
    LET l_str = l_str.trim(),"<entryNo>",l_detail.entryNo CLIPPED,"</entryNo>"
    LET l_str = l_str.trim(),"<poSer>",l_detail.poSer CLIPPED,"</poSer>"
    LET l_str = l_str.trim(),"<receiptNo>",l_detail.receiptNo CLIPPED,"</receiptNo>"
    LET l_str = l_str.trim(),"<poNo>",l_detail.poNo CLIPPED,"</poNo>"
    LET l_str = l_str.trim(),"<materialCode>",l_detail.materialCode CLIPPED,"</materialCode>"
    LET l_str = l_str.trim(),"<batchNo>",l_detail.batchNo CLIPPED,"</batchNo>"
    LET l_str = l_str.trim(),"<materialName>",l_detail.materialName CLIPPED,"</materialName>"
    LET l_str = l_str.trim(),"<spec>",l_detail.spec CLIPPED,"</spec>"
    LET l_str = l_str.trim(),"<unit>",l_detail.unit CLIPPED,"</unit>"
    LET l_str = l_str.trim(),"<amount>",l_detail.amount CLIPPED,"</amount>"
    LET l_str = l_str.trim(),"<current>",l_detail.current CLIPPED,"</current>"
    LET l_str = l_str.trim(),"<unitPrice>",l_detail.unitPrice CLIPPED,"</unitPrice>"
    LET l_str = l_str.trim(),"<warehouse>",l_detail.warehouse CLIPPED,"</warehouse>"
    LET l_str = l_str.trim(),"<location>",l_detail.location CLIPPED,"</location>"
    LET l_str = l_str.trim(),"<companyId>",l_detail.companyId CLIPPED,"</companyId>"
    LET l_str = l_str.trim(),"<companyCode>",l_detail.companyCode CLIPPED,"</companyCode>"
    LET l_str = l_str.trim(),"<companyName>",l_detail.companyName CLIPPED,"</companyName>"
    LET l_str = l_str.trim(),"<projectCode>",l_detail.projectCode CLIPPED,"</projectCode>"
    LET l_str = l_str.trim(),"<masterProjectCode>",l_detail.masterProjectCode CLIPPED,"</masterProjectCode>"
    LET l_str = l_str.trim(),"<masterProjectName>",l_detail.masterProjectName CLIPPED,"</masterProjectName>"
    LET l_str = l_str.trim(),"<groupCode>",l_detail.groupCode CLIPPED,"</groupCode>"
    LET l_str = l_str.trim(),"<attr1>",l_detail.attr1 CLIPPED,"</attr1>"
    LET l_str = l_str.trim(),"<tax>",l_detail.tax CLIPPED,"</tax>"

    RETURN l_str
END FUNCTION 

#***************************************************************
#Interface:delStoreEntry
#Descriptions:入库单资料上传
#***************************************************************
FUNCTION cs_delstoreentry_data(p_docCode,p_groupCode)
DEFINE p_docCode        LIKE type_file.chr20
DEFINE p_groupCode      LIKE type_file.chr20
DEFINE l_str            STRING

    INITIALIZE l_str TO NULL 

    LET l_str = l_str.trim(),"<docCode>",p_docCode CLIPPED,"</docCode>"
    LET l_str = l_str.trim(),"<groupCode>",p_groupCode CLIPPED,"</groupCode>"

    RETURN l_str
   
END FUNCTION 

#***************************************************************
#Interface:addWorkTask
#Descriptions:新增工单
#***************************************************************
FUNCTION cs_addworktask_data(l_data)
DEFINE l_data           RECORD 
           createUserid LIKE gen_file.gen01,     #创建人
           createTime   LIKE type_file.chr20,    #创建时间
           status       LIKE type_file.chr1,     #状态
           workNo       LIKE sfb_file.sfb01,     #工单单号
           generateDate LIKE type_file.chr20,    #开单日期
           workType     LIKE sfb_file.sfb02,     #工单类型
           accountWay   LIKE sfb_file.sfb39,     #领料方式,扣账方式
           productCode  LIKE sfb_file.sfb05,     #料件编号
           productName  LIKE ima_file.ima02,     #品名
           spec         LIKE ima_file.ima021,    #规格
           orderNo      LIKE sfb_file.sfb22,     #订单号
           orderItem    LIKE sfb_file.sfb221,    #订单项次
           bom          LIKE sfb_file.sfb07,     #bom版本
           amount       LIKE sfb_file.sfb08,     #数量
    expectedStartDate   LIKE type_file.chr20,     #预计开工日
    actualStartDate     LIKE type_file.chr20,     #实际开工日
    expectedEndDate     LIKE type_file.chr20,     #预计完工日           
    actualEndDate       LIKE type_file.chr20,     #实际完工日
           sendAmount   LIKE sfb_file.sfb081,    #发货量
           finishAmount LIKE sfb_file.sfb09,     #完工量
           scrapAmount  LIKE sfb_file.sfb12,     #报废数量
           processCode  LIKE sfb_file.sfb06,     #工艺编号
           groupCode    LIKE pmm_file.pmmplant,  #所属集团代码
           batchNo      LIKE type_file.chr100,   #成品批号
           attr1        LIKE type_file.chr100,   #研发项目号
           attr2        LIKE type_file.chr100    #流水号
                        END RECORD
DEFINE l_str            STRING 

    INITIALIZE l_str TO NULL

    LET l_str = l_str.trim(),"<createUserid>",l_data.createUserid CLIPPED,"</createUserid>"
    LET l_str = l_str.trim(),"<createTime>",l_data.createTime CLIPPED,"</createTime>"
    LET l_str = l_str.trim(),"<status>",l_data.status CLIPPED,"</status>"
    LET l_str = l_str.trim(),"<workNo>",l_data.workNo CLIPPED,"</workNo>"
    LET l_str = l_str.trim(),"<generateDate>",l_data.generateDate CLIPPED,"</generateDate>"
    LET l_str = l_str.trim(),"<workType>",l_data.workType CLIPPED,"</workType>"
    LET l_str = l_str.trim(),"<accountWay>",l_data.accountWay CLIPPED,"</accountWay>"
    LET l_str = l_str.trim(),"<productCode>",l_data.productCode CLIPPED,"</productCode>"
    LET l_str = l_str.trim(),"<productName>",l_data.productName CLIPPED,"</productName>"
    LET l_str = l_str.trim(),"<spec>",l_data.spec CLIPPED,"</spec>"
    LET l_str = l_str.trim(),"<orderNo>",l_data.orderNo CLIPPED,"</orderNo>"
    LET l_str = l_str.trim(),"<orderItem>",l_data.orderItem CLIPPED,"</orderItem>"
    LET l_str = l_str.trim(),"<bom>",l_data.bom CLIPPED,"</bom>"
    LET l_str = l_str.trim(),"<amount>",l_data.amount CLIPPED,"</amount>"
    LET l_str = l_str.trim(),"<expectedStartDate>",l_data.expectedStartDate CLIPPED,"</expectedStartDate>"
    LET l_str = l_str.trim(),"<actualStartDate>",l_data.actualStartDate CLIPPED,"</actualStartDate>"
    LET l_str = l_str.trim(),"<expectedEndDate>",l_data.expectedEndDate CLIPPED,"</expectedEndDate>"
    LET l_str = l_str.trim(),"<actualEndDate>",l_data.actualEndDate CLIPPED,"</actualEndDate>"
    LET l_str = l_str.trim(),"<sendAmount>",l_data.sendAmount CLIPPED,"</sendAmount>"
    LET l_str = l_str.trim(),"<finishAmount>",l_data.finishAmount CLIPPED,"</finishAmount>"
    LET l_str = l_str.trim(),"<scrapAmount>",l_data.scrapAmount CLIPPED,"</scrapAmount>"
    LET l_str = l_str.trim(),"<processCode>",l_data.processCode CLIPPED,"</processCode>"
    LET l_str = l_str.trim(),"<groupCode>",l_data.groupCode CLIPPED,"</groupCode>"
    LET l_str = l_str.trim(),"<batchNo>",l_data.batchNo CLIPPED,"</batchNo>"
    LET l_str = l_str.trim(),"<attr1>",l_data.attr1 CLIPPED,"</attr1>"
    LET l_str = l_str.trim(),"<attr2>",l_data.attr2 CLIPPED,"</attr2>"

    RETURN l_str
END FUNCTION





#***************************************************************
#Interface:addMaterialRequire
#Descriptions:新增备料单
#***************************************************************
FUNCTION cs_addmaterialrequire_data(l_data)
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
DEFINE l_str            STRING

    INITIALIZE l_str TO NULL

    LET l_str = l_str.trim(),"<createUserid>",l_data.createUserid CLIPPED,"</createUserid>"
    LET l_str = l_str.trim(),"<createTime>",l_data.createTime CLIPPED,"</createTime>"
    LET l_str = l_str.trim(),"<docCode>",l_data.docCode CLIPPED,"</docCode>"
    LET l_str = l_str.trim(),"<busiType>",l_data.busiType CLIPPED,"</busiType>"
    LET l_str = l_str.trim(),"<appCompanyCode>",l_data.appCompanyCode CLIPPED,"</appCompanyCode>"
    LET l_str = l_str.trim(),"<appCompanyName>",l_data.appCompanyName CLIPPED,"</appCompanyName>"
    LET l_str = l_str.trim(),"<appUserCode>",l_data.appUserCode CLIPPED,"</appUserCode>"
    LET l_str = l_str.trim(),"<appUserName>",l_data.appUserName CLIPPED,"</appUserName>"
    LET l_str = l_str.trim(),"<operUserCode>",l_data.operUserCode CLIPPED,"</operUserCode>"
    LET l_str = l_str.trim(),"<operUserName>",l_data.operUserName CLIPPED,"</operUserName>"
    LET l_str = l_str.trim(),"<storeCode>",l_data.storeCode CLIPPED,"</storeCode>"
    LET l_str = l_str.trim(),"<storeName>",l_data.storeName CLIPPED,"</storeName>"
    LET l_str = l_str.trim(),"<companyCode>",l_data.companyCode CLIPPED,"</companyCode>"
    LET l_str = l_str.trim(),"<companyName>",l_data.companyName CLIPPED,"</companyName>"
    LET l_str = l_str.trim(),"<productLines>",l_data.productLines CLIPPED,"</productLines>"
    LET l_str = l_str.trim(),"<workTeam>",l_data.workTeam CLIPPED,"</workTeam>"
    LET l_str = l_str.trim(),"<groupCode>",l_data.groupCode CLIPPED,"</groupCode>"
    LET l_str = l_str.trim(),"<attr1>",l_data.attr1 CLIPPED,"</attr1>"
    LET l_str = l_str.trim(),"<status>",l_data.status CLIPPED,"</status>"

    RETURN l_str

END FUNCTION 

FUNCTION cs_addmaterialrequire_detail(l_detail)
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
DEFINE l_str            STRING 

    INITIALIZE l_str TO NULL

    LET l_str = l_str.trim(),"<docCode>",l_detail.docCode CLIPPED,"</docCode>"
    LET l_str = l_str.trim(),"<workCode>",l_detail.workCode CLIPPED,"</workCode>"
    LET l_str = l_str.trim(),"<jobCode>",l_detail.jobCode CLIPPED,"</jobCode>"
    LET l_str = l_str.trim(),"<materialCode>",l_detail.materialCode CLIPPED,"</materialCode>"
    LET l_str = l_str.trim(),"<materialName>",l_detail.materialName CLIPPED,"</materialName>"
    LET l_str = l_str.trim(),"<spec>",l_detail.spec CLIPPED,"</spec>"
    LET l_str = l_str.trim(),"<unit>",l_detail.unit CLIPPED,"</unit>"
    LET l_str = l_str.trim(),"<needAmount>",l_detail.needAmount CLIPPED,"</needAmount>"
    LET l_str = l_str.trim(),"<sendAmount>",l_detail.sendAmount CLIPPED,"</sendAmount>"
    LET l_str = l_str.trim(),"<qpaAmount>",l_detail.qpaAmount CLIPPED,"</qpaAmount>"
    LET l_str = l_str.trim(),"<warehouseCode>",l_detail.warehouseCode CLIPPED,"</warehouseCode>"
    LET l_str = l_str.trim(),"<warehouseName>",l_detail.warehouseName CLIPPED,"</warehouseName>"
    LET l_str = l_str.trim(),"<groupCode>",l_detail.groupCode CLIPPED,"</groupCode>"
    LET l_str = l_str.trim(),"<projectCode>",l_detail.projectCode CLIPPED,"</projectCode>"
    LET l_str = l_str.trim(),"<masterProjectCode>",l_detail.masterProjectCode CLIPPED,"</masterProjectCode>"
    LET l_str = l_str.trim(),"<masterProjectName>",l_detail.masterProjectName CLIPPED,"</masterProjectName>"
  
    RETURN l_str

END FUNCTION 

#***************************************************************
#Interface:updateMaterialRequire
#Descriptions:更新备料单
#***************************************************************

#***************************************************************
#Interface:delMaterialRequire
#Descriptions:删除备料单
#***************************************************************
FUNCTION cs_delmaterialrequire_data(l_data)
DEFINE l_data           RECORD 
           docCode      LIKE type_file.chr20,  #备料单号
           groupCode    LIKE type_file.chr20   #营运中心
                        END RECORD
DEFINE l_str            STRING 


    INITIALIZE l_str TO NULL 

    LET l_str = l_str.trim(),"<docCode>",l_data.docCode CLIPPED,"</docCode>"
    LET l_str = l_str.trim(),"<groupCode>",l_data.groupCode CLIPPED,"</groupCode>"

    RETURN l_str
END FUNCTION


#***************************************************************
#Interface:addStoreOut
#Descriptions:出货通知单
#***************************************************************
FUNCTION cs_addstoreout_data(l_data)
DEFINE l_data           RECORD 
              status    LIKE type_file.chr10,     #状态
              docCode   LIKE type_file.chr50,     #出货单号
              docDate   LIKE type_file.chr20,     #出库时间
              docType   LIKE type_file.chr10,     #出货类型
              busiType  LIKE type_file.chr10,     #10-原物料；20-成品
              orderNo   LIKE type_file.chr50,     #客户订单号
          customerCode  LIKE type_file.chr50,     #客户代号
          customerName  LIKE type_file.chr100,    #客户名称
       deliveryAddress  LIKE type_file.chr1000,   #送货地址(销售) 
             storeCode  LIKE type_file.chr20,     #仓库代码
             storeName  LIKE type_file.chr100,    #仓库名称
           appUserCode  LIKE type_file.chr10,     #申请人工号
           appUserName  LIKE type_file.chr20,     #员工姓名
          operUserCode  LIKE type_file.chr10,     #操作人员
          operUserName  LIKE type_file.chr20,     #人员名称
             fromDocNo  LIKE type_file.chr50,     #来源单号
           companyCode  LIKE type_file.chr20,     #货权公司代码
           companyName  LIKE type_file.chr100,    #公司名称
      allocationFinish  LIKE type_file.chr10,     #调拨完成   #1.
             groupCode  LIKE type_file.chr20      #所属集团代码
                        END RECORD 
DEFINE l_str            STRING 


    INITIALIZE l_str TO NULL 
    LET l_str = l_str.trim(),"<status>",l_data.status ,"</status>"
    LET l_str = l_str.trim(),"<docCode>",l_data.docCode ,"</docCode>"
    LET l_str = l_str.trim(),"<docDate>",l_data.docDate ,"</docDate>"
    LET l_str = l_str.trim(),"<docType>",l_data.docType ,"</docType>"
    LET l_str = l_str.trim(),"<busiType>",l_data.busiType ,"</busiType>"
    LET l_str = l_str.trim(),"<orderNo>",l_data.orderNo ,"</orderNo>"
    LET l_str = l_str.trim(),"<customerCode>",l_data.customerCode ,"</customerCode>"
    LET l_str = l_str.trim(),"<customerName>",l_data.customerName ,"</customerName>"
    LET l_str = l_str.trim(),"<deliveryAddress>",l_data.deliveryAddress ,"</deliveryAddress>"
    LET l_str = l_str.trim(),"<storeCode>",l_data.storeCode ,"</storeCode>"
    LET l_str = l_str.trim(),"<storeName>",l_data.storeName ,"</storeName>"
    LET l_str = l_str.trim(),"<appUserCode>",l_data.appUserCode ,"</appUserCode>"
    LET l_str = l_str.trim(),"<appUserName>",l_data.appUserName ,"</appUserName>"
    LET l_str = l_str.trim(),"<operUserCode>",l_data.operUserCode ,"</operUserCode>"
    LET l_str = l_str.trim(),"<operUserName>",l_data.operUserName ,"</operUserName>"
    LET l_str = l_str.trim(),"<fromDocNo>",l_data.fromDocNo ,"</fromDocNo>"
    LET l_str = l_str.trim(),"<companyCode>",l_data.companyCode ,"</companyCode>"
    LET l_str = l_str.trim(),"<companyName>",l_data.companyName ,"</companyName>"
    LET l_str = l_str.trim(),"<allocationFinish>",l_data.allocationFinish ,"</allocationFinish>"
    LET l_str = l_str.trim(),"<groupCode>",l_data.groupCode ,"</groupCode>"
   
    RETURN l_str

END FUNCTION 

FUNCTION cs_addstoreout_detail(l_detail)
DEFINE l_detail         RECORD  
           outCode      LIKE type_file.chr50,   #出库单号
      materialCode      LIKE type_file.chr50,   #物料编号
      materialName      LIKE type_file.chr50,   #品名
           batchNo      LIKE type_file.chr50,   #出货批次号
              spec      LIKE type_file.chr50,   #规格
              unit      LIKE type_file.chr10,   #单位
            amount      LIKE type_file.num15_3, #数量
       currentCode      LIKE type_file.chr10,   #币种
       unitPrice        LIKE type_file.num20_6, #单价
       totalPrice       LIKE type_file.num20_6, #总价
       poNo             LIKE type_file.chr50,   #销售订单
       poItem           LIKE type_file.num10,   #订单项次
    warehouseCode       LIKE type_file.chr10,   #仓库编号
    warehouseName       LIKE type_file.chr50,   #仓库名称
    locationCode        LIKE type_file.chr10,   #库位编号
    locationDesc        LIKE type_file.chr50,   #库位名称
       groupCode        LIKE type_file.chr50,   #营运中心
           attr2        LIKE type_file.num10,   #出货项次
           attr3        LIKE type_file.chr50,   #项目编号
           attr4        LIKE type_file.chr100,  #项目名称
           attr5        LIKE type_file.chr50    #小项目号
                        END RECORD 
DEFINE l_str            STRING 

    LET l_str = l_str.trim(),"<outCode>",l_detail.outCode CLIPPED,"</outCode>"
    LET l_str = l_str.trim(),"<materialCode>",l_detail.materialCode CLIPPED,"</materialCode>"
    LET l_str = l_str.trim(),"<materialName>",l_detail.materialName CLIPPED,"</materialName>"
    LET l_str = l_str.trim(),"<batchNo>",l_detail.batchNo CLIPPED,"</batchNo>"
    LET l_str = l_str.trim(),"<spec>",l_detail.spec CLIPPED,"</spec>"
    LET l_str = l_str.trim(),"<unit>",l_detail.unit CLIPPED,"</unit>"
    LET l_str = l_str.trim(),"<amount>",l_detail.amount CLIPPED,"</amount>"
    LET l_str = l_str.trim(),"<currentCode>",l_detail.currentCode CLIPPED,"</currentCode>"
    LET l_str = l_str.trim(),"<unitPrice>",l_detail.unitPrice CLIPPED,"</unitPrice>"
    LET l_str = l_str.trim(),"<totalPrice>",l_detail.totalPrice CLIPPED,"</totalPrice>"
    LET l_str = l_str.trim(),"<poNo>",l_detail.poNo CLIPPED,"</poNo>"
    LET l_str = l_str.trim(),"<poItem>",l_detail.poItem CLIPPED,"</poItem>"
    LET l_str = l_str.trim(),"<warehouseCode>",l_detail.warehouseCode CLIPPED,"</warehouseCode>"
    LET l_str = l_str.trim(),"<warehouseName>",l_detail.warehouseName CLIPPED,"</warehouseName>"
    LET l_str = l_str.trim(),"<locationCode>",l_detail.locationCode CLIPPED,"</locationCode>"
    LET l_str = l_str.trim(),"<locationDesc>",l_detail.locationDesc CLIPPED,"</locationDesc>"
    LET l_str = l_str.trim(),"<groupCode>",l_detail.groupCode CLIPPED,"</groupCode>"
    LET l_str = l_str.trim(),"<attr2>",l_detail.attr2 CLIPPED,"</attr2>"
    LET l_str = l_str.trim(),"<attr3>",l_detail.attr3 CLIPPED,"</attr3>"
    LET l_str = l_str.trim(),"<attr4>",l_detail.attr4 CLIPPED,"</attr4>"
    LET l_str = l_str.trim(),"<attr5>",l_detail.attr5 CLIPPED,"</attr5>"
    RETURN l_str

END FUNCTION 
 


#***************************************************************
#Interface:updateFinAccountInvoice
#Descriptions:更新平台发票对账单号上的ERP账款单号及已付金额
#***************************************************************

FUNCTION cs_updatefinaccountinvoice_data(l_data)
DEFINE l_data           RECORD 
         erpAccountCode LIKE type_file.chr50,
         acCode         LIKE type_file.chr50,
         payAmount      LIKE type_file.num20_6,
         groupCode      LIKE type_file.chr20
                        END RECORD
DEFINE l_str            STRING  

    LET l_str = l_str.trim(),"<erpAccountCode>",l_data.erpAccountCode CLIPPED,"</erpAccountCode>"
    LET l_str = l_str.trim(),"<acCode>",l_data.acCode CLIPPED,"</acCode>"
    LET l_str = l_str.trim(),"<payAmount>",l_data.payAmount CLIPPED,"</payAmount>"
    LET l_str = l_str.trim(),"<groupCode>",l_data.groupCode CLIPPED,"</groupCode>"

    RETURN l_str
END FUNCTION 


#***************************************************************
#Interface:addPurPurchaseOrder
#Descriptions:向SCM同步ERP采购订单
#***************************************************************

FUNCTION cs_addPurPurchaseOrder_data(l_data)
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
DEFINE l_str            STRING 


    LET l_str = l_str.trim(),"<poNo>",l_data.poNo CLIPPED,"</poNo>"
    LET l_str = l_str.trim(),"<poDescription>",l_data.poDescription CLIPPED,"</poDescription>"
    LET l_str = l_str.trim(),"<isDeleted>",l_data.isDeleted CLIPPED,"</isDeleted>"
    LET l_str = l_str.trim(),"<poType>",l_data.poType CLIPPED,"</poType>"
    LET l_str = l_str.trim(),"<poFrom>",l_data.poFrom CLIPPED,"</poFrom>"
    LET l_str = l_str.trim(),"<purchaseType>",l_data.purchaseType CLIPPED,"</purchaseType>"
    LET l_str = l_str.trim(),"<supplierCode>",l_data.supplierCode CLIPPED,"</supplierCode>"
    LET l_str = l_str.trim(),"<supplierName>",l_data.supplierName CLIPPED,"</supplierName>"
    LET l_str = l_str.trim(),"<totalPrice>",l_data.totalPrice CLIPPED,"</totalPrice>"
    LET l_str = l_str.trim(),"<currency>",l_data.currency CLIPPED,"</currency>"
    LET l_str = l_str.trim(),"<deliveryDate>",l_data.deliveryDate CLIPPED,"</deliveryDate>"
    LET l_str = l_str.trim(),"<deliveryPlace>",l_data.deliveryPlace CLIPPED,"</deliveryPlace>"
    LET l_str = l_str.trim(),"<taxDiscription>",l_data.taxDiscription CLIPPED,"</taxDiscription>"
    LET l_str = l_str.trim(),"<paymentMethod>",l_data.paymentMethod CLIPPED,"</paymentMethod>"
    LET l_str = l_str.trim(),"<transType>",l_data.transType CLIPPED,"</transType>"
    LET l_str = l_str.trim(),"<packageRequire>",l_data.packageRequire CLIPPED,"</packageRequire>"
    LET l_str = l_str.trim(),"<remark>",l_data.remark CLIPPED,"</remark>"
    LET l_str = l_str.trim(),"<buyerName>",l_data.buyerName CLIPPED,"</buyerName>"
    LET l_str = l_str.trim(),"<effectiveDate>",l_data.effectiveDate CLIPPED,"</effectiveDate>"
    LET l_str = l_str.trim(),"<groupCode>",l_data.groupCode CLIPPED,"</groupCode>"

    RETURN l_str

END FUNCTION 

FUNCTION cs_addPurPurchaseOrder_detail(l_detail)
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

    LET l_str = l_str.trim(),"<demandCompany>",l_detail.demandCompany CLIPPED,"</demandCompany>"
    LET l_str = l_str.trim(),"<projectCode>",l_detail.projectCode CLIPPED,"</projectCode>"
    LET l_str = l_str.trim(),"<projectName>",l_detail.projectName CLIPPED,"</projectName>"
    LET l_str = l_str.trim(),"<requireDate>",l_detail.requireDate CLIPPED,"</requireDate>"
    LET l_str = l_str.trim(),"<productName>",l_detail.productName CLIPPED,"</productName>"
    LET l_str = l_str.trim(),"<materialNo>",l_detail.materialNo CLIPPED,"</materialNo>"
    LET l_str = l_str.trim(),"<spec>",l_detail.spec CLIPPED,"</spec>"
    LET l_str = l_str.trim(),"<unit>",l_detail.unit CLIPPED,"</unit>"
    LET l_str = l_str.trim(),"<amount>",l_detail.amount CLIPPED,"</amount>"
    LET l_str = l_str.trim(),"<appointBrand>",l_detail.appointBrand CLIPPED,"</appointBrand>"
    LET l_str = l_str.trim(),"<executionStandard>",l_detail.executionStandard CLIPPED,"</executionStandard>"
    LET l_str = l_str.trim(),"<remark>",l_detail.remark CLIPPED,"</remark>"
    LET l_str = l_str.trim(),"<deliveryDate>",l_detail.deliveryDate CLIPPED,"</deliveryDate>"
    LET l_str = l_str.trim(),"<unitPrice>",l_detail.unitPrice CLIPPED,"</unitPrice>"
    LET l_str = l_str.trim(),"<totalPrice>",l_detail.totalPrice CLIPPED,"</totalPrice>"
    LET l_str = l_str.trim(),"<tax>",l_detail.tax CLIPPED,"</tax>"
    LET l_str = l_str.trim(),"<serNo>",l_detail.serNo CLIPPED,"</serNo>"
    LET l_str = l_str.trim(),"<requireNo>",l_detail.requireNo CLIPPED,"</requireNo>"
    LET l_str = l_str.trim(),"<requireItem>",l_detail.requireItem CLIPPED,"</requireItem>"
    LET l_str = l_str.trim(),"<deliveryPlace>",l_detail.deliveryPlace CLIPPED,"</deliveryPlace>"

    RETURN l_str

END FUNCTION 


#***************************************************************
#Interface:addPurMaterialRequire
#Descriptions:请购单从ERP同步给SCM,新增
#***************************************************************
FUNCTION cs_addPurMaterialRequire_data(l_data)
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

    LET l_str = l_str.trim(),"<createUserid>",l_data.createUserid CLIPPED,"</createUserid>"
    LET l_str = l_str.trim(),"<status>",l_data.status CLIPPED,"</status>"
    LET l_str = l_str.trim(),"<createTime>",l_data.createTime CLIPPED,"</createTime>"
    LET l_str = l_str.trim(),"<demandCompany>",l_data.demandCompany CLIPPED,"</demandCompany>"
    LET l_str = l_str.trim(),"<projectCode>",l_data.projectCode CLIPPED,"</projectCode>"
    LET l_str = l_str.trim(),"<projectName>",l_data.projectName CLIPPED,"</projectName>"
    LET l_str = l_str.trim(),"<requireNo>",l_data.requireNo CLIPPED,"</requireNo>"
    LET l_str = l_str.trim(),"<requireItem>",l_data.requireItem CLIPPED,"</requireItem>"
    LET l_str = l_str.trim(),"<requireDate>",l_data.requireDate CLIPPED,"</requireDate>"
    LET l_str = l_str.trim(),"<requireProperty>",l_data.requireProperty CLIPPED,"</requireProperty>"
    LET l_str = l_str.trim(),"<productName>",l_data.productName CLIPPED,"</productName>"
    LET l_str = l_str.trim(),"<materialCode>",l_data.materialCode CLIPPED,"</materialCode>"
    LET l_str = l_str.trim(),"<spec>",l_data.spec CLIPPED,"</spec>"
    LET l_str = l_str.trim(),"<unit>",l_data.unit CLIPPED,"</unit>"
    LET l_str = l_str.trim(),"<requireAmount>",l_data.requireAmount CLIPPED,"</requireAmount>"
    LET l_str = l_str.trim(),"<referenceBrand>",l_data.referenceBrand CLIPPED,"</referenceBrand>"
    LET l_str = l_str.trim(),"<appointBrand>",l_data.appointBrand CLIPPED,"</appointBrand>"
    LET l_str = l_str.trim(),"<executionStandard>",l_data.executionStandard CLIPPED,"</executionStandard>"
    LET l_str = l_str.trim(),"<deliveryPlace>",l_data.deliveryPlace CLIPPED,"</deliveryPlace>"
    LET l_str = l_str.trim(),"<groupCode>",l_data.groupCode CLIPPED,"</groupCode>"
    LET l_str = l_str.trim(),"<demandCompanyCode>",l_data.demandCompanyCode CLIPPED,"</demandCompanyCode>"
    LET l_str = l_str.trim(),"<applyUserCode>",l_data.applyUserCode CLIPPED,"</applyUserCode>"
    LET l_str = l_str.trim(),"<applyUser>",l_data.applyUser CLIPPED,"</applyUser>"
    LET l_str = l_str.trim(),"<applyUserEmail>",l_data.applyUserEmail CLIPPED,"</applyUserEmail>"
    LET l_str = l_str.trim(),"<applyUserMobile>",l_data.applyUserMobile CLIPPED,"</applyUserMobile>"
    LET l_str = l_str.trim(),"<purLeadTime>",l_data.purLeadTime CLIPPED,"</purLeadTime>"
    LET l_str = l_str.trim(),"<supplierCode>",l_data.supplierCode CLIPPED,"</supplierCode>"
    LET l_str = l_str.trim(),"<supplierName>",l_data.supplierName CLIPPED,"</supplierName>"
    LET l_str = l_str.trim(),"<attr1>",l_data.attr1 CLIPPED,"</attr1>"
    LET l_str = l_str.trim(),"<attr2>",l_data.attr2 CLIPPED,"</attr2>"
    LET l_str = l_str.trim(),"<attr3>",l_data.attr3 CLIPPED,"</attr3>"
    LET l_str = l_str.trim(),"<attr4>",l_data.attr4 CLIPPED,"</attr4>"
    LET l_str = l_str.trim(),"<attr5>",l_data.attr5 CLIPPED,"</attr5>"
    LET l_str = l_str.trim(),"<attr6>",l_data.attr6 CLIPPED,"</attr6>"
    LET l_str = l_str.trim(),"<attr7>",l_data.attr7 CLIPPED,"</attr7>"
    LET l_str = l_str.trim(),"<attr8>",l_data.attr8 CLIPPED,"</attr8>"
    LET l_str = l_str.trim(),"<attr9>",l_data.attr9 CLIPPED,"</attr9>"
    LET l_str = l_str.trim(),"<attr10>",l_data.attr10 CLIPPED,"</attr10>"

    RETURN l_str

END FUNCTION



#***************************************************************
#Interface:deletePurMaterialRequire
#Descriptions:请购单从ERP同步给SCM,删除
#***************************************************************
FUNCTION cs_deletePurMaterialRequire_data(l_data)
DEFINE l_data           RECORD
             requireNo  LIKE type_file.chr50,
             groupCode  LIKE type_file.chr20
                        END RECORD
DEFINE l_str            STRING

    LET l_str = l_str.trim(),"<requireNo>",l_data.requireNo CLIPPED,"</requireNo>"
    LET l_str = l_str.trim(),"<groupCode>",l_data.groupCode CLIPPED,"</groupCode>"

    RETURN l_str

END FUNCTION 

