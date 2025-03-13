# Prog. Version..: '5.30.10-13.11.15(00010)'     #
#
# Program name...: cl_zmx_createjson.4gl
# Descriptions...: 创建JSON格式
# Date & Author..:
# Modify.........: 

DATABASE ds

#GLOBALS "../../config/top.global"
GLOBALS "../../../tiptop/config/top.global"

##***************************************************************
##Interface:gerDepartment
##Descriptions:部门资料同步
##***************************************************************
FUNCTION cl_getDepartment_data_json(l_data)
DEFINE l_data           RECORD
        createdByCode       LIKE type_file.chr100,
        code                LIKE type_file.chr100,
        _name               LIKE type_file.chr100,
        _status             LIKE type_file.chr1,
        groupIdCode         LIKE type_file.chr100,
        createdOn           LIKE type_file.chr100
                        END RECORD
DEFINE l_str            STRING 
    
    LET l_str = #'"createdByCode":"',l_data.createdByCode,'",',
                '"code":"',l_data.code,'",',
                '"name":"',l_data._name,'",',
                '"status":"',l_data._status,'",',
                '"groupIdCode":"',l_data.groupIdCode,'",',
                '"companyIdCode":"',l_data.groupIdCode,'",',
                '"createdOn":"',l_data.createdOn,'",',
                #'"updatedByCode":"',l_data.createdByCode,'",',
                '"updatedOn":"',l_data.createdOn,'"'
    RETURN l_str

END FUNCTION 

#***************************************************************
#Interface:staffReceive
#Descriptions:员工资料同步
#***************************************************************
FUNCTION cl_getUser_data_json(l_data)
DEFINE l_data           RECORD
                            groupIdCode          LIKE     type_file.chr100,
                            code                 LIKE     type_file.chr100,
                            _name                LIKE     type_file.chr100,
                            departmentIdCode     LIKE     type_file.chr100,
                            _status              LIKE     type_file.chr100,
                            email                LIKE     type_file.chr100,
                            mobile               LIKE     type_file.chr100,
                            createdOn            LIKE     type_file.chr100
                        END RECORD
DEFINE l_str            STRING 
    
    LET l_str = '"code":"',l_data.code,'",',
                '"name":"',l_data._name,'",',
                '"departmentIdCode":"',l_data.departmentIdCode,'",',
                '"status":"',l_data._status,'",',
                '"companyIdCode":"',l_data.groupIdCode,'",',
                '"groupIdCode":"',l_data.groupIdCode,'",',
                '"email":"',l_data.email,'",',
                '"mobile":"',l_data.mobile,'",',
                '"phoneNum":"',l_data.mobile,'",',
                '"createdOn":"',l_data.createdOn,'",',
                '"updatedOn":"',l_data.createdOn,'"'
    RETURN l_str

END FUNCTION 

#***************************************************************
#Interface:customerReceive
#Descriptions:客户资料同步
#***************************************************************
FUNCTION cl_getCustomer_data_json(l_data)
DEFINE l_data           RECORD
                            groupIdCode          LIKE     type_file.chr100,
                            code                 LIKE     type_file.chr100,
                            shortName            LIKE     type_file.chr100,
                            _name                LIKE     occ_file.occ18,
                            #categoryCode         LIKE     type_file.chr100,
                            #currencyCode         LIKE     type_file.chr100,
                            telephone            LIKE     type_file.chr100,
                            staffNum             LIKE     type_file.chr100,
                            #taxIdCode            LIKE     type_file.chr100,
                            rate                 LIKE     type_file.chr100,
                            fax                  LIKE     type_file.chr100,
                            #parentCompanyCode    LIKE     type_file.chr100,
                            #staffIdCode          LIKE     type_file.chr100,
                            address              LIKE     type_file.chr1000,
                            _status              LIKE     type_file.chr100,
                            createdOn            LIKE     type_file.chr100
                        END RECORD
DEFINE l_str            STRING 
    
    LET l_str = '"code":"',l_data.code,'",',
                '"name":"',l_data._name,'",',
                '"shortName":"',l_data.shortName,'",',
                '"status":"',l_data._status,'",',
                #'"categoryCode":"',l_data.categoryCode,'",',
                #'"currencyCode":"',l_data.currencyCode,'",',
                '"telephone":"',l_data.telephone,'",',
                '"staffNum":"',l_data.staffNum CLIPPED,'",',
                #'"taxIdCode":"',l_data.taxIdCode,'",',
                '"rate":"',l_data.rate,'",',
                '"fax":"',l_data.fax,'",',
                #'"parentCompanyCode":"',l_data.parentCompanyCode,'",',
                #'"staffIdCode":"',l_data.staffIdCode,'",',
                '"groupIdCode":"',l_data.groupIdCode,'",',
                '"address":"',l_data.address,'",',
                '"createdOn":"',l_data.createdOn,'",',
                '"updatedOn":"',l_data.createdOn,'"'
    RETURN l_str

END FUNCTION 


##***************************************************************
##Interface:
##Descriptions:理由码
##***************************************************************
#FUNCTION cl_getazf_data_json(l_data)
#DEFINE l_data           RECORD
#        code                LIKE type_file.chr100,
#        _name               LIKE type_file.chr100,
#        _status             LIKE type_file.chr1,
#        groupIdCode         LIKE type_file.chr100
#                        END RECORD
#DEFINE l_str            STRING 
#    
#    LET l_str = '"code":"',l_data.code,'",',
#                '"name":"',l_data._name,'",',
#                '"status":"',l_data._status,'",',
#                '"groupIdCode":"',l_data.groupIdCode,'"'
#    RETURN l_str
#
#END FUNCTION 
##***************************************************************
##Interface:addPurPurchaseOrder
##Descriptions:采购单
##***************************************************************
#
##单头
#FUNCTION cl_addPurPurchaseOrder_data_json(l_data)
#DEFINE l_data           RECORD 
#            createdBy            LIKE type_file.chr100,     #
#            code                 LIKE type_file.chr100,
#            documentDate         LIKE type_file.chr100,
#            organizationId       LIKE type_file.chr100,
#            supplierCode         LIKE type_file.chr100,
#            userId               LIKE type_file.chr100,
#            departmentId         LIKE type_file.chr100,
#            currencyId           LIKE type_file.chr100,
#            taxId                LIKE type_file.chr100,
#            paymentMethodId      LIKE type_file.chr100,
#            orderCategory        LIKE type_file.chr100,
#            packagingReq         LIKE type_file.chr100,
#            remarks              LIKE type_file.chr100,
#            address              LIKE type_file.chr100,
#            documentTypeCode     LIKE type_file.chr100
#                        END RECORD
#DEFINE l_str            STRING 
#
#    INITIALIZE l_str TO NULL
#
#    LET l_str = '"createdByCode":"',          l_data.createdBy,'",',
#                '"code":"',          l_data.code,'",',
#                '"documentDate":"',          l_data.documentDate,'",',
#                '"groupIdCode":"',          l_data.organizationId,'",',
#                '"organizationIdCode":"',          l_data.organizationId,'",',
#                '"supplierCode":"',     l_data.supplierCode CLIPPED,'",',
#                '"userIdCode":"',     l_data.userId CLIPPED,'",',
#                '"departmentIdCode":"',     l_data.departmentId CLIPPED,'",',
#                '"currencyIdCode":"',     l_data.currencyId CLIPPED,'",',
#                '"taxIdCode":"',     l_data.taxId CLIPPED,'",',
#                #'"currencyIdCode":"',     l_data.currencyId CLIPPED,'",',
#                '"orderCategory":"',     l_data.orderCategory CLIPPED,'",',
#                '"packagingReq":"', l_data.packagingReq,'",',
#                '"remarks":"',l_data.remarks,'",',
#                '"address":"',l_data.address,'",',
#                '"documentTypeCode":"',l_data.documentTypeCode,'"'
#
#    RETURN l_str
#
#END FUNCTION 
#
##单身明细
#FUNCTION cl_addPurPurchaseOrder_detail_json(l_detail)
#DEFINE l_detail         RECORD 
#                            serialNumber    LIKE type_file.chr100,
#                            productCode     LIKE type_file.chr100,
#                            productName     LIKE type_file.chr100,
#                            specifications  LIKE type_file.chr100,
#                            quantity        LIKE type_file.chr100,
#                            unitPrice2      LIKE type_file.chr100,
#                            amount          LIKE type_file.chr100,
#                            unchargedUPrice LIKE type_file.chr100,
#                            unchargedUAmount LIKE type_file.chr100,
#                            deliveryDate    LIKE type_file.chr100,
#                            unitCode        LIKE type_file.chr100,
#                            workno          LIKE type_file.chr100
#                        END RECORD
#DEFINE l_str             STRING 
#
#
#
#    INITIALIZE l_str TO NULL       
#
#    LET l_str ='"serialNumber":"',    l_detail.serialNumber,'",',     
#               '"productCode":"',     l_detail.productCode,'",',      
#               '"productName":"',     l_detail.productName,'",',      
#               '"specifications":"',  l_detail.specifications,'",',   
#               '"quantity":"',        l_detail.quantity,'",',         
#               '"unitPrice2":"',      l_detail.unitPrice2,'",',       
#               '"amount":"',          l_detail.amount,'",',           
#               '"unchargedUPrice":"', l_detail.unchargedUPrice,'",',  
#               '"unchargedUAmount":"',l_detail.unchargedUAmount,'",',    
#               '"deliveryDate":"',    l_detail.deliveryDate,'",',
#                '"unitCode":"',        l_detail.unitCode,'",',  
#                '"workNo":"',        l_detail.workno,'"' 
#
#    RETURN l_str
#
#END FUNCTION 


FUNCTION cl_getMaterial_data_json(l_data)
DEFINE l_data           RECORD 
                            groupIdCode                    LIKE type_file.chr100,     #营运中心id		
                            code                           LIKE type_file.chr100,     #编码（料号）		
                            _name                          LIKE type_file.chr100,     #名称		
                            _status                        LIKE type_file.chr100,     #状态		
                            spec                           LIKE type_file.chr100,     #规格		
                            categoryCode                   LIKE type_file.chr100,     #分类id ，关联表（GOODS_CATEGORY）		
                            storeUnitCode                  LIKE type_file.chr100,     #库存单位id，关联表（UNIT）		
                            purUnitCode                    LIKE type_file.chr100,     #采购单位id，关联表（UNIT）		
                            unitToPut                      LIKE type_file.chr100,     #采购/库存单位转换率		
                            saleUnitCode                   LIKE type_file.chr100,     #销售单位id，关联表（UNIT）		
                            unitToSale                     LIKE type_file.chr100,     #销售单位/库存单位转换率		
                            productionUnitCode             LIKE type_file.chr100,     #生产单位id，关联表（UNIT）		
                            unitToProduction               LIKE type_file.chr100,     #生产单位/库存单位转换率		
                            issueUnitCode                  LIKE type_file.chr100,     #发料单位id，关联表（UNIT）		
                            unitToIssue                    LIKE type_file.chr100,     #发料单位/库存单位转换率		
                            orderUnitCode                  LIKE type_file.chr100,     #订货单位id，关联表（UNIT）		
                            unitToOrder                    LIKE type_file.chr100,     #订货单位/库存单位转换率		
                            purBatch                       LIKE type_file.chr100,     #采购批量		
                            purMinBatch                    LIKE type_file.chr100,     #最少采购量		
                            upperProductStock              LIKE type_file.chr100,     #最高生产（线边仓）库存		
                            lowerProductStock              LIKE type_file.chr100,     #最低生产（线边仓）库存		
                            minSendAmount                  LIKE type_file.chr100,     #最小发料量		
                            buyerCode                      LIKE type_file.chr100,     #采购员id，关联表（STAFF）		
                            storerCode                     LIKE type_file.chr100,     #仓管员id，关联表（STAFF）		
                            inspectionGrade                LIKE type_file.chr100,     #检验等级		
                            inspectionDegree               LIKE type_file.chr100,     #检验程度		
                            inspectionLevel                LIKE type_file.chr100,     #检验水准		
                            matType                        LIKE type_file.chr100,     #材料类型		
                            warehouseCode                  LIKE type_file.chr100,     #推荐仓库id，关联表（WAREHOUSE）		
                            cargoLocationCode              LIKE type_file.chr100,     #推荐货位id，关联表（CARGO_LOCATION）		
                            otherIsBatchMana               LIKE type_file.chr100,     #ERP是否按照批次管理 （是 Yes -- 否 No）		
                            isFreeCheck                    LIKE type_file.chr100,     #是否免检（是 Yes -- 否 No）		
                            isBatchMana                    LIKE type_file.chr100,     #是否批次管理（是 Yes -- 否 No）		
                            isConsumable                   LIKE type_file.chr100,     #是否消耗性料件（是 Yes -- 否 No）		
                            isBySeries                     LIKE type_file.chr100,      #是否序号管理（是 Yes -- 否 No）	
                            fromCode                       LIKE type_file.chr100,       #来源码 
                            ptName                         LIKE type_file.chr1000,    #品名
                            createdOn                      LIKE type_file.chr100,      #更新时间
                            createdByCode                  LIKE type_file.chr100,      #创建人
                            updatedOn                      LIKE type_file.chr100,      #更新时间
                            updatedByCode                  LIKE type_file.chr100,      #更新人
                            shelfLife                      LIKE type_file.chr100        #保质期
                        END RECORD
DEFINE l_str            STRING 

    INITIALIZE l_str TO NULL

    LET l_str = '"groupIdCode":"',l_data.groupIdCode,'",',
                '"code":"',l_data.code,'",',
                '"name":"',l_data._name,'",',
                '"status":"',l_data._status,'",',
                '"spec":"',l_data.spec,'",',
                '"categoryCode":"',l_data.categoryCode,'",',
                '"storeUnitCode":"',l_data.storeUnitCode,'",',
                '"purUnitCode":"',l_data.purUnitCode,'",',
                '"unitToPut":"',l_data.unitToPut,'",',
                '"saleUnitCode":"',l_data.saleUnitCode,'",',
                '"unitToSale":"',l_data.unitToSale,'",',
                '"productionUnitCode":"',l_data.productionUnitCode,'",',
                '"unitToProduction":"',l_data.unitToProduction,'",',
                '"issueUnitCode":"',l_data.issueUnitCode,'",',
                '"unitToIssue":"',l_data.unitToIssue,'",',
                '"orderUnitCode":"',l_data.orderUnitCode,'",',
                '"unitToOrder":"',l_data.unitToOrder,'",',
                '"purBatch":"',l_data.purBatch,'",',
                '"purMinBatch":"',l_data.purMinBatch,'",',
                '"upperProductStock":"',l_data.upperProductStock,'",',
                '"lowerProductStock":"',l_data.lowerProductStock,'",',
                '"minSendAmount":"',l_data.minSendAmount,'",',
                '"buyerCode":"',l_data.buyerCode,'",',
                '"storerCode":"',l_data.storerCode,'",',
                '"inspectionGrade":"',l_data.inspectionGrade,'",',
                '"inspectionDegree":"',l_data.inspectionDegree,'",',
                '"inspectionLevel":"',l_data.inspectionLevel,'",',
                '"matType":"',l_data.matType,'",',
                '"warehouseCode":"',l_data.warehouseCode,'",',
                '"cargoLocationCode":"',l_data.cargoLocationCode,'",',
                '"otherIsBatchMana":"',l_data.otherIsBatchMana,'",',
                '"isFreeCheck":"',l_data.isFreeCheck,'",',
                '"isBatchMana":"',l_data.isBatchMana,'",',
                '"isConsumable":"',l_data.isConsumable,'",',
                '"isBySeries":"',l_data.isBySeries,'",',
                '"fromCode":"',l_data.fromCode,'",',
                '"ptName":"',l_data.ptName,'",',
                '"createdOn":"',l_data.createdOn,'",',
                #'"createdByCode":"',l_data.createdByCode,'",',
                '"updatedOn":"',l_data.updatedOn,'",',
                '"shelfLife":"',l_data.shelfLife,'"'
    RETURN l_str

END FUNCTION 


#FUNCTION cl_addWorktask_data_json(l_data)
#DEFINE l_data           RECORD
#                           # createdOn                                LIKE type_file.chr100,     #创建时间
#                            corporationIdCode                        LIKE type_file.chr100,     #营运中心id
#                            createdByCode                            LIKE type_file.chr100,     #创建人
#                            code                                     LIKE type_file.chr100,     #创建人
#                            groupIdCode                              LIKE type_file.chr100,     #营运中心id
#                            docTypeIdCode                            LIKE type_file.chr100,     #单据类型(例如:送货单/收货单...)
#                            docDate                                  LIKE type_file.chr100,     #单据日期
#                            applicantIdCode                          LIKE type_file.chr100,     #申请人ID(取值来源,STAFF[员工表])
#                            applicantDepartmentIdCode                LIKE type_file.chr100,     #申请部门(取值来源,DEPARTMENT[部门表])
#                            remarks                                  LIKE type_file.chr100,     #备注
#                            sourceCode                               LIKE type_file.chr100,      #来源编码
#                            issue_number                             LIKE type_file.chr100       #发料序号
#                        END RECORD
#DEFINE l_str            STRING 
#
#    INITIALIZE l_str TO NULL
#
#    LET l_str =
#                '"corporationIdCode":"',l_data.corporationIdCode,'",',  
#                #'"createdOn":"',l_data.createdOn,'",',
#                '"createdByCode":"',l_data.createdByCode,'",',
#                '"code":"',l_data.code,'",',
#                '"groupIdCode":"',l_data.groupIdCode,'",',
#                '"docTypeIdCode":"',l_data.docTypeIdCode,'",',
#                '"docDate":"',l_data.docDate,'",',
#                '"applicantIdCode":"',l_data.applicantIdCode,'",',
#                '"applicantDepartmentIdCode":"',l_data.applicantDepartmentIdCode,'",',
#                '"remarks":"',l_data.remarks,'",',
#                '"sourceCode":"',l_data.sourceCode,'",',
#                '"issue_number":"',l_data.issue_number,'"'
#    RETURN l_str
#END FUNCTION 
#
#
#
#FUNCTION cl_addWorktask_detail_json(l_detail)
#DEFINE l_detail         RECORD
#                            groupIdCode                              LIKE type_file.chr100,     #营运中心id
#                            serialNumber                             LIKE type_file.chr100,     #序号
#                            materialCode                             LIKE type_file.chr100,     #物料编码
#                            materialName                             LIKE type_file.chr100,     #物料名称
#                            spec                                     LIKE type_file.chr100,     #规格
#                            unitIdCode                               LIKE type_file.chr100,     #申请单位ID(取值来源,UNIT[单位表])
#                            num                                      LIKE type_file.chr100,     #申请数量
#                            warehouseIdCode                          LIKE type_file.chr100,     #申请仓库ID(取值来源,WAREHOUSE[仓库表])
#                            cargoLocationIdCode                      LIKE type_file.chr100,     #货位ID(取值来源CARGO_LOCATION[货位表])
#                            batchNo                                  LIKE type_file.chr100,     #批号
#                            sourceCode                               LIKE type_file.chr100,     #来源编码
#                            sourceSerNo                              LIKE type_file.chr100,      #来源项次
#                            remarks                                  LIKE type_file.chr100,      #备注
#                            jobName                                  LIKE type_file.chr100,       #作业编号
#                            oemCode                                  LIKE type_file.chr100 
#                            
#                        END RECORD
#DEFINE l_str            STRING 
#
#    INITIALIZE l_str TO NULL
#
#    LET l_str = '"groupIdCode":"',l_detail.groupIdCode,'",',
#                '"serialNumber":"',l_detail.serialNumber,'",',
#                '"materialCode":"',l_detail.materialCode,'",',
#                '"materialName":"',l_detail.materialName,'",',
#                '"spec":"',l_detail.spec,'",',
#                '"unitIdCode":"',l_detail.unitIdCode,'",',
#                '"num":"',l_detail.num,'",',
#                '"warehouseIdCode":"',l_detail.warehouseIdCode,'",',
#                '"cargoLocationIdCode":"',l_detail.cargoLocationIdCode,'",',
#                '"batchNo":"',l_detail.batchNo,'",',
#                '"sourceCode":"',l_detail.sourceCode,'",',
#                '"sourceSerNo":"',l_detail.sourceSerNo,'",',
#                '"remarks":"',l_detail.remarks,'",',
#                '"jobName":"',l_detail.jobName,'",',
#                '"oemCode":"',l_detail.oemCode,'"'
#                
#    RETURN l_str
#END FUNCTION 


FUNCTION cl_getpmc_data_json(l_data)
DEFINE l_data        RECORD
                            groupIdCode                               LIKE type_file.chr100,                    #
                            createdByCode                             LIKE type_file.chr100,                    #创建人
                            code                                      LIKE type_file.chr100,                    #供应商编码
                            shortName                                 LIKE type_file.chr100,                    #供应商简称
                            _name                                      LIKE type_file.chr100,                    #供应商名称
                            _status                                    LIKE type_file.chr100,                    #状态
                            uniformCreditCode                         LIKE type_file.chr100,                    #统一社会信用代码
                            purchaseType                              LIKE type_file.chr100,                    #采购性质
                            supplierType                              LIKE type_file.chr100,                    #供应商类型
                            regiCapital                               LIKE type_file.chr100,                    #注册资本
                            regiCurrencyCode                          LIKE type_file.chr100,                    #注册币种
                            regiDate                                  LIKE type_file.chr100,                    #注册日期
                            telephone                                 LIKE type_file.chr100,                    #电话号码
                            fax                                       LIKE type_file.chr100,                    #传真号
                            email                                     LIKE type_file.chr100,                    #电子邮件
                            webSite                                   LIKE type_file.chr100,                    #网址
                            country                                   LIKE type_file.chr100,                    #国家
                            state                                     LIKE type_file.chr100,                    #省份
                            city                                      LIKE type_file.chr100,                    #城市
                            contactAddress                            LIKE type_file.chr100,                    #地址
                            zipCode                                   LIKE type_file.chr100,                    #邮编
                            mobile                                    LIKE type_file.chr100,                    #手机号码
                            contact                                   LIKE type_file.chr100,                    #联系人
                            taxRegistrationNo                         LIKE type_file.chr100,                    #税务登记号（纳税人识别号）
                            tranCurrencyCode                          LIKE type_file.chr100,                    #交易币种
                            tranTaxCode                               LIKE type_file.chr100,                    #交易税种
                            paymentTerm                               LIKE type_file.chr100,                    #默认付款条件
                            priceTermid                               LIKE type_file.chr100,                    #默认价格条件
                            closedDate                                LIKE type_file.chr100,                    #结账日
                            invoiceCreditCode                         LIKE type_file.chr100,                    #税号
                            invoiceCompany                            LIKE type_file.chr100,                    #发票抬头
                            invoiceAddress                            LIKE type_file.chr100,                    #发票地址
                            invoiceTelephone                          LIKE type_file.chr100,                    #发票电话
                            accountNo                                 LIKE type_file.chr100,                    #银行账户
                            createdOn                                 LIKE type_file.chr100
                        END RECORD
DEFINE l_str            STRING 

    INITIALIZE l_str TO NULL

LET l_str = '"groupIdCode":"',l_data.groupIdCode,'",',#供应商编码
            '"createdByCode":"',l_data.createdByCode,'",',#供应商简称
            '"code":"',l_data.code,'",',#供应商编码
            '"shortName":"',l_data.shortName,'",',#供应商简称
            '"name":"',l_data._name,'",',#供应商名称
            '"status":"',l_data._status,'",',#状态
            '"uniformCreditCode":"',l_data.uniformCreditCode,'",',#统一社会信用代码
            '"purchaseType":"',l_data.purchaseType,'",',#采购性质
            '"supplierType":"',l_data.supplierType,'",',#供应商类型
            #'"regiCapital":"',l_data.regiCapital,'",',#注册资本
            '"regiCurrencyCode":"',l_data.regiCurrencyCode,'",',#注册币种
            #'"regiDate":"',l_data.regiDate,'",',#注册日期
            '"telephone":"',l_data.telephone,'",',#电话号码
            '"fax":"',l_data.fax,'",',#传真号
            '"email":"',l_data.email,'",',#电子邮件
            #'"webSite":"',l_data.webSite,'",',#网址
            '"country":"',l_data.country,'",',#国家
            '"state":"',l_data.state,'",',#省份
            '"city":"',l_data.city,'",',#城市
            '"contactAddress":"',l_data.contactAddress,'",',#地址
            '"zipCode":"',l_data.zipCode,'",',#邮编
            '"mobile":"',l_data.mobile,'",',#手机号码
            #'"contact":"',l_data.contact,'",',#联系人
            '"taxRegistrationNo":"',l_data.taxRegistrationNo,'",',#税务登记号（纳税人识别号）
            '"tranCurrencyCode":"',l_data.tranCurrencyCode,'",',#交易币种
            '"tranTaxCode":"',l_data.tranTaxCode,'",',#交易税种
            '"paymentTerm":"',l_data.paymentTerm,'",',#默认付款条件
            '"priceTermid":"',l_data.priceTermid,'",',#默认价格条件
            '"closedDate":"',l_data.closedDate,'",',#结账日
            '"invoiceCreditCode":"',l_data.invoiceCreditCode,'",',#税号
            '"invoiceCompany":"',l_data.invoiceCompany,'",',#发票抬头
            '"invoiceAddress":"',l_data.invoiceAddress,'",',#发票地址
            '"invoiceTelephone":"',l_data.invoiceTelephone,'",',#发票电话
            '"accountNo":"',l_data.accountNo,'",',#银行账户
            '"createdOn":"',l_data.createdOn,'",',
            '"updatedByCode":"',l_data.createdByCode,'",',
            '"updatedOn":"',l_data.createdOn,'"'

    RETURN l_str
END FUNCTION 


#***************************************************************
#Interface:addPurPurchaseOrder
#Descriptions:采购单
#***************************************************************

#单头
FUNCTION cjc_addPurPurchaseOrder_data_json(l_data)
DEFINE l_data           RECORD 
            createdBy            LIKE type_file.chr100,     #
            code                 LIKE type_file.chr100,
            documentDate         LIKE type_file.chr100,
            organizationId       LIKE type_file.chr100,
            supplierCode         LIKE type_file.chr100,
            userId               LIKE type_file.chr100,
            departmentId         LIKE type_file.chr100,
            currencyId           LIKE type_file.chr100,
            taxId                LIKE type_file.chr100,
            paymentMethodId      LIKE type_file.chr100,
            orderCategory        LIKE type_file.chr100,
            packagingReq         LIKE type_file.chr100,
            remarks              LIKE type_file.chr100,
            address              LIKE type_file.chr100,
            documentTypeCode     LIKE type_file.chr100,
            materialMark         LIKE type_file.chr100
                        END RECORD
DEFINE l_str            STRING 

    INITIALIZE l_str TO NULL

    LET l_str = '"createdByCode":"',          l_data.createdBy,'",',
                '"code":"',          l_data.code,'",',
                '"documentDate":"',          l_data.documentDate,'",',
                '"groupIdCode":"',          l_data.organizationId,'",',
                '"organizationIdCode":"',          l_data.organizationId,'",',
                '"supplierCode":"',     l_data.supplierCode CLIPPED,'",',
                '"userIdCode":"',     l_data.userId CLIPPED,'",',
                '"departmentIdCode":"',     l_data.departmentId CLIPPED,'",',
                '"currencyIdCode":"',     l_data.currencyId CLIPPED,'",',
                '"taxIdCode":"',     l_data.taxId CLIPPED,'",',
                #'"currencyIdCode":"',     l_data.currencyId CLIPPED,'",',
                '"orderCategory":"',     l_data.orderCategory CLIPPED,'",',
                '"packagingReq":"', l_data.packagingReq,'",',
                '"remarks":"',l_data.remarks,'",',
                '"address":"',l_data.address,'",',
                '"documentTypeCode":"',l_data.documentTypeCode,'",',
                '"materialMark":"',l_data.materialMark,'"'

    RETURN l_str

END FUNCTION 

#单身明细
FUNCTION cjc_addPurPurchaseOrder_detail_json(l_detail)
DEFINE l_detail         RECORD 
                            serialNumber    LIKE type_file.chr100,
                            productCode     LIKE type_file.chr100,
                            productName     LIKE type_file.chr100,
                            specifications  LIKE type_file.chr100,
                            quantity        LIKE type_file.chr100,
                            unitPrice2      LIKE type_file.chr100,
                            amount          LIKE type_file.chr100,
                            unchargedUPrice LIKE type_file.chr100,
                            unchargedUAmount LIKE type_file.chr100,
                            deliveryDate    LIKE type_file.chr100,
                            unitCode        LIKE type_file.chr100,
                            workno          LIKE type_file.chr100,
                            carton          LIKE type_file.chr100
                        END RECORD
DEFINE l_str             STRING 



    INITIALIZE l_str TO NULL       

    LET l_str ='"serialNumber":"',    l_detail.serialNumber,'",',     
               '"productCode":"',     l_detail.productCode,'",',      
               '"productName":"',     l_detail.productName,'",',      
               '"specifications":"',  l_detail.specifications,'",',   
               '"quantity":"',        l_detail.quantity,'",',         
               '"unitPrice2":"',      l_detail.unitPrice2,'",',       
               '"amount":"',          l_detail.amount,'",',           
               '"unchargedUPrice":"', l_detail.unchargedUPrice,'",',  
               '"unchargedUAmount":"',l_detail.unchargedUAmount,'",',    
               '"deliveryDate":"',    l_detail.deliveryDate,'",',
                '"unitCode":"',        l_detail.unitCode,'",',  
                '"workNo":"',        l_detail.workno,'",',
                '"carton":"',        l_detail.carton,'"'
                

    RETURN l_str

END FUNCTION 




#***************************************************************
#Interface:addPurPurchaseOrder
#Descriptions:任务单
#***************************************************************
# 任务单单头
FUNCTION cjc_addWorktask_data_json(l_data)
DEFINE l_data           RECORD
                           # createdOn                                LIKE type_file.chr100,     #创建时间
                            corporationIdCode                        LIKE type_file.chr100,     #营运中心id
                            createdByCode                            LIKE type_file.chr100,     #创建人
                            code                                     LIKE type_file.chr100,     #创建人
                            groupIdCode                              LIKE type_file.chr100,     #营运中心id
                            docTypeIdCode                            LIKE type_file.chr100,     #单据类型(例如:送货单/收货单...)
                            docDate                                  LIKE type_file.chr100,     #单据日期
                            applicantIdCode                          LIKE type_file.chr100,     #申请人ID(取值来源,STAFF[员工表])
                            applicantDepartmentIdCode                LIKE type_file.chr100,     #申请部门(取值来源,DEPARTMENT[部门表])
                            remarks                                  LIKE type_file.chr100,     #备注
                            sourceCode                               LIKE type_file.chr100,      #来源编码
                            issue_number                             LIKE type_file.chr100,       #发料序号
                            customerType                             LIKE type_file.chr100,       #客商类型
                            customerCustomerCode                     LIKE type_file.chr100,       #客户
                            currencyIdCode                           LIKE type_file.chr100,       #币种
                            taxIdCode                                LIKE type_file.chr100,        #税种
                            outType                                  LIKE type_file.chr100          #出货单别
                        END RECORD
DEFINE l_str            STRING 

    INITIALIZE l_str TO NULL

    LET l_str =
                '"corporationIdCode":"',l_data.corporationIdCode,'",',  
                #'"createdOn":"',l_data.createdOn,'",',
                '"createdByCode":"',l_data.createdByCode,'",',
                '"code":"',l_data.code,'",',
                '"groupIdCode":"',l_data.groupIdCode,'",',
                '"docTypeIdCode":"',l_data.docTypeIdCode,'",',
                '"docDate":"',l_data.docDate,'",',
                '"applicantIdCode":"',l_data.applicantIdCode,'",',
                '"applicantDepartmentIdCode":"',l_data.applicantDepartmentIdCode,'",',
                '"remarks":"',l_data.remarks,'",',
                '"sourceCode":"',l_data.sourceCode,'",',
                '"issue_number":"',l_data.issue_number,'",',
                '"customerType":"',l_data.customerType,'",',
                '"customerCustomerCode":"',l_data.customerCustomerCode,'",',
                '"currencyIdCode":"',l_data.currencyIdCode,'",',
                '"taxIdCode":"',l_data.taxIdCode,'",',
                '"outType":"',l_data.outType,'"'
    RETURN l_str
END FUNCTION 


# 任务单单身
FUNCTION cjc_addWorktask_detail_json(l_detail)
DEFINE l_detail         RECORD
                            groupIdCode                              LIKE type_file.chr100,     #营运中心id
                            serialNumber                             LIKE type_file.chr100,     #序号
                            materialCode                             LIKE type_file.chr100,     #物料编码
                            materialName                             LIKE type_file.chr100,     #物料名称
                            spec                                     LIKE type_file.chr100,     #规格
                            unitIdCode                               LIKE type_file.chr100,     #申请单位ID(取值来源,UNIT[单位表])
                            num                                      LIKE type_file.chr100,     #申请数量
                            warehouseIdCode                          LIKE type_file.chr100,     #申请仓库ID(取值来源,WAREHOUSE[仓库表])
                            cargoLocationIdCode                      LIKE type_file.chr100,     #货位ID(取值来源CARGO_LOCATION[货位表])
                            batchNo                                  LIKE type_file.chr100,     #批号
                            sourceCode                               LIKE type_file.chr100,     #来源编码
                            sourceSerNo                              LIKE type_file.chr100,      #来源项次
                            remarks                                  LIKE type_file.chr100,      #备注
                            jobName                                  LIKE type_file.chr100,       #作业编号
                            oemCode                                  LIKE type_file.chr100 
                            
                        END RECORD
DEFINE l_str            STRING 

    INITIALIZE l_str TO NULL

    LET l_str = '"groupIdCode":"',l_detail.groupIdCode,'",',
                '"serialNumber":"',l_detail.serialNumber,'",',
                '"materialCode":"',l_detail.materialCode,'",',
                '"materialName":"',l_detail.materialName,'",',
                '"spec":"',l_detail.spec,'",',
                '"unitIdCode":"',l_detail.unitIdCode,'",',
                '"num":"',l_detail.num,'",',
                '"warehouseIdCode":"',l_detail.warehouseIdCode,'",',
                '"cargoLocationIdCode":"',l_detail.cargoLocationIdCode,'",',
                '"batchNo":"',l_detail.batchNo,'",',
                '"sourceCode":"',l_detail.sourceCode,'",',
                '"sourceSerNo":"',l_detail.sourceSerNo,'",',
                '"remarks":"',l_detail.remarks,'",',
                '"jobName":"',l_detail.jobName,'",',
                '"oemCode":"',l_detail.oemCode,'"'
                
    RETURN l_str
END FUNCTION 
#工单单头
FUNCTION cjc_addWorkTasksfb_data_json(l_data)
DEFINE l_data           RECORD
                            createdByCode                            LIKE type_file.chr100,     #创建人
                            updatedByCode                            LIKE type_file.chr100,     #更新人
                            workNo                                   LIKE type_file.chr100,     #工单编号
                            generateDate                             LIKE type_file.chr100,     #开单日期
                            workType                                 LIKE type_file.chr100,     #工单类型
                            accountWay                               LIKE type_file.chr100,     #扣账方式
                            productCode                              LIKE type_file.chr100,     #成品代码
                            productName                              LIKE type_file.chr100,     #品名
                            spec                                     LIKE type_file.chr100,     #规格
                            orderNo                                  LIKE type_file.chr100,     #订单号
                            orderItem                                LIKE type_file.chr100,     #订单项次
                            bom                                      LIKE type_file.chr100,     #bom版本
                            amount                                   LIKE type_file.chr100,     #数量
                            expectedStartDate                        LIKE type_file.chr100,     #预计开工日期
                            actualStartDate                          LIKE type_file.chr100,     #实际开工日期
                            expectedEndDate                          LIKE type_file.chr100,     #预计完工日期
                            actualEndDate                            LIKE type_file.chr100,     #实际完工日期
                            processCode                              LIKE type_file.chr100,     #工艺编号
                            ifTech                                   LIKE type_file.chr100,     #是否工艺工单
                            isRework                                 LIKE type_file.chr100,     #返工否
                            isFqc                                    LIKE type_file.chr100,     #FQC否
                            groupIdCode                              LIKE type_file.chr100,     #营运中心id
                            sfb82                                    LIKE type_file.chr100,     #部门厂商
                            sfbud02                                  LIKE type_file.chr100,     #客户订单号
                            sfbud03                                  LIKE type_file.chr100,     #OEM
                            sfbud04                                  LIKE type_file.chr100,     #成品编号
                            production_line                          LIKE type_file.chr100,      #产线
                            project_code                             LIKE type_file.chr100,
                            _status                                  LIKE type_file.chr100
                        END RECORD
DEFINE l_str             STRING 



    INITIALIZE l_str TO NULL       

    LET l_str ='"createdByCode":"',l_data.createdByCode,'",',
                '"updatedByCode":"',l_data.updatedByCode,'",',
                '"workNo":"',l_data.workNo,'",',
                '"generateDate":"',l_data.generateDate,'",',
                '"workType":"',l_data.workType,'",',
                '"accountWay":"',l_data.accountWay,'",',
                '"productCode":"',l_data.productCode,'",',
                '"productName":"',l_data.productName,'",',
                '"spec":"',l_data.spec,'",',
                '"orderNo":"',l_data.orderNo,'",',
                '"orderItem":"',l_data.orderItem,'",',
                '"bom":"',l_data.bom,'",',
                '"amount":"',l_data.amount,'",',
                '"expectedStartDate":"',l_data.expectedStartDate,'",',
                '"actualStartDate":"',l_data.actualStartDate,'",',
                '"expectedEndDate":"',l_data.expectedEndDate,'",',
              #  '"actualEndDate":"',l_data.actualEndDate,'",',
                '"processCode":"',l_data.processCode,'",',
                '"ifTech":"',l_data.ifTech,'",',
                '"isRework":"',l_data.isRework,'",',
                '"isFqc":"',l_data.isFqc,'",',
                '"groupIdCode":"',l_data.groupIdCode,'",',
                '"sfb82":"',l_data.sfb82,'",',
                '"sfbud02":"',l_data.sfbud02,'",',
                '"sfbud03":"',l_data.sfbud03,'",',
                '"sfbud04":"',l_data.sfbud04,'",',
                '"productionLine":"',l_data.production_line,'",',
                '"projectCode":"',l_data.project_code,'",',
                '"status":"',l_data._status,'"'

    RETURN l_str

END FUNCTION 


#工单单身明细
FUNCTION cjc_addWorkTasksfa_detail_json(l_detail)
DEFINE l_detail         RECORD 
                            workCode                                 LIKE type_file.chr100,     #工单编号		
                            jobCode                                  LIKE type_file.chr100,     #作业编号		
                            materialCode                             LIKE type_file.chr100,     #料号		
                            materialName                             LIKE type_file.chr100,     #品名		
                            spec                                     LIKE type_file.chr100,     #规格		
                            unit                                     LIKE type_file.chr100,     #单位		
                            actualQpa                                LIKE type_file.chr100,     #实际QPA		
                            errorRate                                LIKE type_file.chr100,     #误差率		
                            needAmount                               LIKE type_file.chr100,     #应发量		
                            flag                                     LIKE type_file.chr100     #来源特性（N一般料件 E消耗性料件，
                            #jobCode                                  LIKE type_file.chr100,     #作业编号
                            #actualQpa                                LIKE type_file.chr100      #实际QPA 
                        END RECORD
DEFINE l_str             STRING 



    INITIALIZE l_str TO NULL       

    LET l_str ='"workCode":"',l_detail.workCode,'",',
                '"jobCode":"',l_detail.jobCode,'",',
                '"materialCode":"',l_detail.materialCode,'",',
                '"materialName":"',l_detail.materialName,'",',
                '"spec":"',l_detail.spec,'",',
                '"unitIdCode":"',l_detail.unit,'",',
                '"actualQpa":"',l_detail.actualQpa,'",',
                '"errorRate":"',l_detail.errorRate,'",',
                '"needAmount":"',l_detail.needAmount,'",',
                '"flag":"',l_detail.flag,'"'
                #'"jobCode":"',l_detail.jobCode,'",',
                #'"actualQpa":"',l_detail.actualQpa,'"'
    RETURN l_str

END FUNCTION 

#***************************************************************
#Descriptions:采购单撤销
#***************************************************************
FUNCTION cjc_cancelpmmorder_data_json(l_data)
DEFINE l_data       RECORD
							          groupIdCode   LIKE type_file.chr100,
							          code          LIKE type_file.chr100,
							          docTypeIdCodeIdCode     LIKE type_file.chr100
                    END RECORD
DEFINE l_str        STRING

    LET l_str = '"groupIdCode": "',         l_data.groupIdCode         CLIPPED,'",',
                '"code": "',         l_data.code         CLIPPED,'",',
                '"docTypeIdCodeIdCode": "',            l_data.docTypeIdCodeIdCode            CLIPPED,'"'
    RETURN l_str

END FUNCTION

#***************************************************************
#Descriptions:采购单结案
#***************************************************************
FUNCTION cjc_closepmnorder_data_json(l_data)
DEFINE l_data           RECORD
							          groupIdCode   LIKE type_file.chr100,
							          code          LIKE type_file.chr100,
							          seqNnm        LIKE type_file.chr100,
                                      _status       LIKE type_file.chr100
                        END RECORD
DEFINE l_str        STRING

    LET l_str = '"groupIdCode": "',         l_data.groupIdCode         CLIPPED,'",',
                '"code": "',         l_data.code         CLIPPED,'",',
                '"seqNnm": "',            l_data.seqNnm            CLIPPED,'",',
                '"status": "',            l_data._status             CLIPPED,'"'
    RETURN l_str

END FUNCTION


#***************************************************************
#Descriptions:IQC同步
#***************************************************************
FUNCTION cjc_purchaseIqc_data_json(l_data)
DEFINE l_data       RECORD
							        #  groupIdCode   LIKE type_file.chr100,
                                         userCode   LIKE gen_file.gen01,    #操作人员
                                        checkCode   LIKE type_file.chr100,  #检验单号
                                        checkTime   LIKE type_file.chr100,  #检验日期时间
                                        receiptNo   LIKE type_file.chr100,  #收货单号
                                      checkAmount   LIKE type_file.num15_3, #检验量
                                      checkResult   LIKE type_file.chr10,   #检验结果
                                  qualifiedAmount   LIKE type_file.num15_3, #合格量
                                unqualifiedAmount   LIKE type_file.num15_3, #不合格量
                                         passRate   LIKE type_file.num15_3, #
                                       dealResult   LIKE type_file.chr10,   #
                                     acceptAmount   LIKE type_file.num15_3, #
                                     refuseAmount   LIKE type_file.num15_3, #
                                        freeCheck   LIKE type_file.chr1,    #
                                        groupCode   LIKE type_file.chr100,  #所属集团代码
                                            serNo   LIKE type_file.num10,   #收货单项次
                                     checkBatchNo   LIKE type_file.num5,    #检验批号
                                      checkerCode   LIKE gen_file.gen01,    #检验员
                                          urgency   LIKE type_file.chr1,    #急料否
                                            level   LIKE type_file.num5,    #级数
                                        checkType   LIKE type_file.chr10,   #检验类型代码
                                       sendAmount   LIKE type_file.num15_3  #送验量
                    END RECORD
DEFINE l_str        STRING
DEFINE l_rvb        RECORD LIKE rvb_file.*
    SELECT * INTO l_rvb.* FROM rvb_file WHERE rvb01=l_data.receiptNo AND rvb02=l_data.serNo
    
    LET l_str = #'"groupIdCode": "',         g_plant         CLIPPED,'",',
                '"userCode": "',         l_data.userCode         CLIPPED,'",',
                '"checkCode": "',         l_data.checkCode         CLIPPED,'",',
                '"checkTime": "',         l_data.checkTime         CLIPPED,'",',
                '"receiptNo": "',         l_data.receiptNo        CLIPPED,'",',
                '"checkAmount": "',         l_data.checkAmount         CLIPPED,'",',
                '"checkResult": "',         l_data.checkResult         CLIPPED,'",',          
                '"qualifiedAmount": "',         l_data.qualifiedAmount       CLIPPED,'",',
                '"unqualifiedAmount": "',         l_data.unqualifiedAmount         CLIPPED,'",',
                '"passRate": "',         l_data.passRate         CLIPPED,'",',
                '"dealResult": "',         l_data.dealResult         CLIPPED,'",',
                 '"acceptAmount": "',         l_data.acceptAmount         CLIPPED,'",',
                '"refuseAmount": "',         l_data.refuseAmount         CLIPPED,'",',          
                '"freeCheck": "',         l_data.freeCheck       CLIPPED,'",',
                '"groupCode": "',         l_data.groupCode         CLIPPED,'",',
                '"serNo": "',         l_data.serNo         CLIPPED,'",',
                '"checkBatchNo": "',         l_data.checkBatchNo         CLIPPED,'",',  
                '"checkerCode": "',         l_data.checkerCode       CLIPPED,'",',
                '"urgency": "',         l_data.urgency        CLIPPED,'",',
                '"level": "',         l_data.level          CLIPPED,'",',  
                '"checkType": "',         l_data.checkType       CLIPPED,'",',
                '"sendAmount": "',         l_data.sendAmount          CLIPPED,'",',
                '"purchaseOrderCode": "',         l_rvb.rvb04      CLIPPED,'",',
                '"purchaseSerno": "',         l_rvb.rvb03         CLIPPED,'"'
    RETURN l_str

END FUNCTION


#***************************************************************
#Descriptions:任务单撤销
#***************************************************************
FUNCTION cjc_cancelworktask_data_json(l_data)
DEFINE l_data       RECORD
							          groupIdCode   LIKE type_file.chr100,
							          code          LIKE type_file.chr100,
							          docTypeIdCode     LIKE type_file.chr100
                    END RECORD
DEFINE l_str        STRING

    LET l_str = '"groupIdCode": "',         l_data.groupIdCode         CLIPPED,'",',
                '"code": "',         l_data.code         CLIPPED,'",',
                '"docTypeIdCode": "',            l_data.docTypeIdCode           CLIPPED,'"'
    RETURN l_str

END FUNCTION

{"groupIdCode":"HYT","workTaskNo":"HD15-190800099","entryNum":"500"}

#***************************************************************
#Descriptions:获取工单可完工量
#***************************************************************
FUNCTION cjc_getworktasknum_data_json(l_data)
DEFINE l_data       RECORD
							          groupIdCode   LIKE type_file.chr100,
							          workTaskNo         LIKE type_file.chr100,
							          entryNum     LIKE type_file.chr100
                    END RECORD
DEFINE l_str        STRING

    LET l_str = '"groupIdCode": "',         l_data.groupIdCode         CLIPPED,'",',
                '"workTaskNo": "',         l_data.workTaskNo         CLIPPED,'",',
                '"entryNum": "',            l_data.entryNum           CLIPPED,'"'
    RETURN l_str

END FUNCTION


#***************************************************************
#Descriptions:获取工单可退料量
#***************************************************************
FUNCTION cjc_getWorkTaskBack_data_json(l_data)
DEFINE l_data       RECORD
							groupIdCode   LIKE type_file.chr100,
							workTaskNo         LIKE type_file.chr100,
							num              LIKE type_file.chr100
                    END RECORD
DEFINE l_str        STRING

    LET l_str = '"groupIdCode": "',         l_data.groupIdCode         CLIPPED,'",',
                '"workTaskNo": "',         l_data.workTaskNo         CLIPPED,'",',
                '"num": "',            l_data.num           CLIPPED,'"'
    RETURN l_str

END FUNCTION



#***************************************************************
#Interface:cs_sendSfbStatus_data_json
#Descriptions:工单状态同步
#***************************************************************
FUNCTION cs_sendSfb_status_data_json(l_data)
DEFINE l_data           RECORD
            code        LIKE type_file.chr100,
            _status     LIKE type_file.chr100,
            groupIdCode            LIKE type_file.chr100
                        END RECORD
DEFINE l_str            STRING


    LET l_str =  '"code": "',           l_data.code           CLIPPED,'",',
                 '"status": "',          l_data._status           CLIPPED,'",',
                 '"groupIdCode": "',         l_data.groupIdCode        CLIPPED,'"'

    RETURN l_str

END FUNCTION


#抓取IQC检验数据
FUNCTION cjc_getqcs_data_json(l_data)
DEFINE l_data           RECORD
																	sourceCode   LIKE type_file.chr100,     #SCM收货单
																	code   LIKE type_file.chr100,           #ERP收货单
																	serialNum   LIKE type_file.chr100,      #项次
																	checkNum   LIKE type_file.chr100,       #检验结果
																	qualifiedNum   LIKE type_file.chr100,    #合格量
																	returnNum   LIKE type_file.chr100,       #不合格量
																	groupIdCode   LIKE type_file.chr100      #营运中心
                        END RECORD
DEFINE l_str            STRING 
    
    LET l_str = '"sourceCode":"',l_data.sourceCode,'",',
                '"code":"',l_data.code,'",',
                '"serialNum":"',l_data.serialNum,'",',
                '"checkNum":"',l_data.checkNum,'",',
                '"qualifiedNum":"',l_data.qualifiedNum,'",',
                '"returnNum":"',l_data.returnNum,'",',
                '"groupIdCode":"',l_data.groupIdCode,'"'
    RETURN l_str

END FUNCTION 


#抓取IQC检验数据
FUNCTION cjc_getback_data_json(l_data)
DEFINE l_data           RECORD
																	code   LIKE type_file.chr100,           #ERP采购单
																	serialNum   LIKE type_file.chr100,      #项次
																	halfwayNum   LIKE type_file.chr100,       #仓退量
																	groupIdCode   LIKE type_file.chr100      #营运中心
                        END RECORD
DEFINE l_str            STRING 
    
    LET l_str = 
                '"code":"',l_data.code,'",',
                '"serialNum":"',l_data.serialNum,'",',
                '"halfwayNum":"',l_data.halfwayNum,'",',
                '"groupIdCode":"',l_data.groupIdCode,'"'
    RETURN l_str

END FUNCTION 


##***************************************************************
##Interface:gerEcd
##Descriptions:作业编号仓库对应关系资料同步
##***************************************************************
FUNCTION cl_getEcd_data_json(l_data)
DEFINE l_data           RECORD
        groupCode       LIKE type_file.chr100,
        workNo          LIKE type_file.chr100,
        workName        LIKE type_file.chr100,
        warehouseCode   LIKE type_file.chr100,
        locationCode    LIKE type_file.chr100,
        _status         LIKE type_file.chr100
                        END RECORD
DEFINE l_str            STRING 
    
    LET l_str = 
                '"groupCode":"',l_data.groupCode,'",',
                '"workNo":"',l_data.workNo,'",',
                '"workName":"',l_data.workName,'",',
                '"warehouseCode":"',l_data.warehouseCode,'",',
                '"locationCode":"',l_data.locationCode,'",',
                '"_status":"',l_data._status,'"'
    RETURN l_str

END FUNCTION 

















