# Prog. Version..: '5.30.10-13.11.15(00010)'     #
#
# Program name...: cl_zmx_json.4gl
# Descriptions...: 各类接口的json格式
# Date & Author..:
# Modify.........: No.2021113001 21/11/30 By jc tc_zmxlog_file调整

DATABASE ds

#GLOBALS "../../config/top.global"
GLOBALS "../../../tiptop/config/top.global"

DEFINE g_jsonstr   LIKE type_file.chr1000,
       g_returnstr   LIKE type_file.chr1000


##############################################
#基础资料同步
##############################################

#部门同步
FUNCTION cl_zmx_json_gem(p_gem01,p_uptime)
DEFINE p_gem01          LIKE gem_file.gem01
DEFINE p_uptime         LIKE type_file.chr100
DEFINE l_ret            RECORD
             success    LIKE type_file.chr1,
             code       LIKE type_file.chr10,
             msg        STRING
                        END RECORD
DEFINE l_gem            RECORD LIKE gem_file.*
DEFINE l_json_str       STRING 
DEFINE l_json_data      STRING 
DEFINE l_sql            STRING 
DEFINE l_cnt            LIKE type_file.num10
DEFINE l_data           RECORD
        createdByCode       LIKE type_file.chr100,
        code                LIKE type_file.chr100,
        _name               LIKE type_file.chr100,
        _status             LIKE type_file.chr1,
        groupIdCode         LIKE type_file.chr100,
        createdOn           LIKE type_file.chr100
                        END RECORD
DEFINE l_returnstatus   LIKE type_file.num5
DEFINE l_returnmsg      String

    INITIALIZE l_ret TO NULL 

    IF cl_null(p_gem01) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "部门编号为空"
        RETURN l_ret.*
    END IF 

    INITIALIZE l_gem TO NULL
    SELECT * INTO l_gem.* FROM gem_file 
     WHERE gem01 = p_gem01 
    
    LET l_data.createdByCode = g_user
    LET l_data.code = l_gem.gem01
    LET l_data._name  = l_gem.gem02
    IF l_gem.gemacti  = 'Y' THEN  
        LET l_data._status  = '1' 
    ELSE 
        LET l_data._status  = '0' 
    END IF 
    LET l_data.groupIdCode = g_plant
    LET l_data.createdOn = p_uptime
    LET l_json_data = cl_getDepartment_data_json(l_data.*)

    LET l_json_str = "{",l_json_data,"}"
    LET l_json_str = cl_replace_str(l_json_str," ","")
    LET l_json_str = cl_replace_str(l_json_str,"`"," ")
    LET l_ret.msg = l_json_str
    DISPLAY "-------------------------json-------departmentReceive------------"
    DISPLAY l_json_str
    DISPLAY "--------------------------------------------------"
    INITIALIZE l_returnstatus TO NULL 
    INITIALIZE l_returnmsg TO NULL
    CALL departmentReceive(l_json_str) RETURNING l_returnstatus,l_returnmsg
    LET g_jsonstr = l_json_str
    LET g_returnstr = l_returnmsg
    IF l_returnstatus = 0 AND l_returnmsg = 'OK' THEN 
    	LET l_ret.success = 'Y' 
    	ELSE 
    	LET l_ret.success = 'N' 
    END IF 
    SELECT COUNT(*) INTO l_cnt FROM tc_zmxlog_file WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'departmentReceive' AND tc_zmxlog05 = p_gem01 AND tc_zmxlog07 = '02'
    IF l_cnt = 0 OR cl_null(l_cnt) THEN 
      INSERT INTO tc_zmxlog_file values(g_plant,'departmentReceive',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),g_user,p_gem01,g_jsonstr,'02',l_ret.success,g_returnstr,1,sysdate)
      ELSE 
      UPDATE tc_zmxlog_file SET tc_zmxlog03 = decode(tc_zmxlog08,'Y',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),tc_zmxlog03),
                                tc_zmxlog04 = decode(tc_zmxlog08,'Y',g_user,tc_zmxlog04),
                                tc_zmxlog06 = g_jsonstr,tc_zmxlog08 = l_ret.success,tc_zmxlog09 = g_returnstr,
                                tc_zmxlog10 = decode(tc_zmxlog08,'Y',1,tc_zmxlog10+1),tc_zmxlog11 = sysdate
      WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'departmentReceive' AND tc_zmxlog05 = p_gem01 AND tc_zmxlog07 = '02'
    END IF 
    IF l_ret.success = 'Y' THEN
       #LET l_ret.success = 'Y'
       LET l_ret.msg = "部门(",l_gem.gem01 CLIPPED,")同步成功"
    ELSE
       #LET l_ret.success = 'N'
       LET l_ret.msg = l_returnmsg
    END IF

    RETURN l_ret.*

END FUNCTION 



 #员工同步
FUNCTION cl_zmx_json_gen(p_gen01,p_uptime)
DEFINE p_gen01          LIKE gen_file.gen01
DEFINE p_uptime         LIKE type_file.chr100
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
DEFINE l_ret            RECORD 
          success       LIKE type_file.chr1,
          code          LIKE type_file.chr10,
          msg           STRING
                        END RECORD
DEFINE l_gen            RECORD LIKE gen_file.*
DEFINE l_json_str       STRING 
DEFINE l_json_data      STRING 
DEFINE l_sql            STRING 
DEFINE l_cnt            LIKE type_file.num10
DEFINE l_returnstatus   LIKE type_file.num5
DEFINE l_returnmsg      String

    INITIALIZE l_ret TO NULL 
    IF cl_null(p_gen01) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "无员工号"
    END IF 

    INITIALIZE l_gen TO NULL 
    SELECT * INTO l_gen.* FROM gen_file 
     WHERE gen01 = p_gen01

    INITIALIZE l_data TO NULL 
    LET l_data.code  = l_gen.gen01
    LET l_data._name  = l_gen.gen02
    LET l_data.departmentIdCode  = l_gen.gen03
    LET l_data.email = l_gen.gen06
    LET l_data.mobile = l_gen.gen08
     IF l_gen.genacti = 'Y' THEN 
            LET l_data._status = '1'
     ELSE
            LET l_data._status = '0'
     END IF   
    LET l_data.groupIdCode= g_plant
    LET l_data.createdOn = p_uptime
    LET l_json_data = cl_getUser_data_json(l_data.*)

    LET l_json_str = "{",l_json_data,"}"
    LET l_json_str = cl_replace_str(l_json_str," ","")
    LET l_json_str = cl_replace_str(l_json_str,"`"," ")
    LET l_ret.msg = l_json_str
    DISPLAY "-------------------------json-------staffReceive------------"
    DISPLAY l_json_str
    DISPLAY "--------------------------------------------------"
    INITIALIZE l_returnstatus TO NULL 
    INITIALIZE l_returnmsg TO NULL
    CALL staffReceive(l_json_str) RETURNING l_returnstatus,l_returnmsg
    LET g_jsonstr = l_json_str
    LET g_returnstr = l_returnmsg
    IF l_returnstatus = '0' AND l_returnmsg = 'OK' THEN 
    	LET l_ret.success = 'Y' 
    	ELSE 
    	LET l_ret.success = 'N' 
    END IF 
    SELECT COUNT(*) INTO l_cnt FROM tc_zmxlog_file WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'staffReceive' AND tc_zmxlog05 = p_gen01 AND tc_zmxlog07 = '03'
    IF l_cnt = 0 OR cl_null(l_cnt) THEN 
      INSERT INTO tc_zmxlog_file values(g_plant,'staffReceive',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),g_user,p_gen01,g_jsonstr,'03',l_ret.success,g_returnstr,1,sysdate)
      ELSE 
      UPDATE tc_zmxlog_file SET tc_zmxlog03 = decode(tc_zmxlog08,'Y',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),tc_zmxlog03),
                                tc_zmxlog04 = decode(tc_zmxlog08,'Y',g_user,tc_zmxlog04),
                                tc_zmxlog06 = g_jsonstr,tc_zmxlog08 = l_ret.success,tc_zmxlog09 = g_returnstr,
                                tc_zmxlog10 = decode(tc_zmxlog08,'Y',1,tc_zmxlog10+1),tc_zmxlog11 = sysdate
      WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'staffReceive' AND tc_zmxlog05 = p_gen01 AND tc_zmxlog07 = '03'
    END IF 
    IF l_ret.success = 'Y' THEN
       #LET l_ret.success = 'Y'
       LET l_ret.msg = "员工(",l_gen.gen01 CLIPPED,")同步成功"
    ELSE
       #LET l_ret.success = 'N'
       LET l_ret.msg = l_returnmsg
    END IF

    RETURN l_ret.*

END FUNCTION 

 #客户同步
FUNCTION cl_zmx_json_occ(p_occ01,p_uptime)
DEFINE p_occ01          LIKE occ_file.occ01
DEFINE p_uptime         LIKE type_file.chr100
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
DEFINE l_ret            RECORD 
          success       LIKE type_file.chr1,
          code          LIKE type_file.chr10,
          msg           STRING
                        END RECORD
DEFINE l_occ            RECORD LIKE occ_file.*
DEFINE l_json_str       STRING 
DEFINE l_json_data      STRING 
DEFINE l_sql            STRING 
DEFINE l_cnt            LIKE type_file.num10
DEFINE l_returnstatus   LIKE type_file.num5
DEFINE l_returnmsg      String

    INITIALIZE l_ret TO NULL 
    IF cl_null(p_occ01) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "无客户编号"
    END IF 

    INITIALIZE l_occ TO NULL 
    SELECT * INTO l_occ.* FROM occ_file 
     WHERE occ01 = p_occ01

    INITIALIZE l_data TO NULL 
    LET l_data.code  = l_occ.occ01
    LET l_data.shortName = l_occ.occ02
    LET l_data._name  = l_occ.occ18
    #LET l_data.categoryCode = l_occ.occ03
    #LET l_data.currencyCode = l_occ.occ42
    LET l_data.telephone = l_occ.occ261
    IF NOT cl_null(l_occ.occ15) THEN LET l_data.staffNum = l_occ.occ15 END IF 
    #LET l_data.taxIdCode = l_occ.occ41
    IF NOT cl_null(l_occ.occ41) THEN 
      SELECT gec04 INTO l_data.rate FROM gec_file WHERE gec01 = l_occ.occ41
    END IF 
    LET l_data.fax = l_occ.occ271
    #LET l_data.parentCompanyCode = l_occ.occ292
    #LET l_data.staffIdCode = l_occ.occ28
    LET l_data.address = l_occ.occ241 CLIPPED,l_occ.occ242 CLIPPED,l_occ.occ243 CLIPPED,l_occ.occ244 CLIPPED,l_occ.occ245 CLIPPED
     IF l_occ.occacti = 'Y' THEN 
            LET l_data._status = '1'
     ELSE
            LET l_data._status = '0'
     END IF   
    LET l_data.groupIdCode= g_plant
    LET l_data.createdOn = p_uptime
    LET l_json_data = cl_getCustomer_data_json(l_data.*)

    LET l_json_str = "{",l_json_data,"}"
    LET l_json_str = cl_replace_str(l_json_str," ","")
    LET l_json_str = cl_replace_str(l_json_str,"`"," ")
    LET l_ret.msg = l_json_str
    DISPLAY "-------------------------json-------customerReceive------------"
    DISPLAY l_json_str
    DISPLAY "--------------------------------------------------"
    INITIALIZE l_returnstatus TO NULL 
    INITIALIZE l_returnmsg TO NULL
    CALL customerReceive(l_json_str) RETURNING l_returnstatus,l_returnmsg
    LET g_jsonstr = l_json_str
    LET g_returnstr = l_returnmsg
    IF l_returnstatus = '0' AND l_returnmsg = 'OK' THEN 
    	LET l_ret.success = 'Y' 
    	ELSE 
    	LET l_ret.success = 'N' 
    END IF 
    SELECT COUNT(*) INTO l_cnt FROM tc_zmxlog_file WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'staffReceive' AND tc_zmxlog05 = p_occ01 AND tc_zmxlog07 = '04'
    IF l_cnt = 0 OR cl_null(l_cnt) THEN 
      INSERT INTO tc_zmxlog_file values(g_plant,'customerReceive',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),g_user,p_occ01,g_jsonstr,'04',l_ret.success,g_returnstr,1,sysdate)
      ELSE 
      UPDATE tc_zmxlog_file SET tc_zmxlog03 = decode(tc_zmxlog08,'Y',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),tc_zmxlog03),
                                tc_zmxlog04 = decode(tc_zmxlog08,'Y',g_user,tc_zmxlog04),
                                tc_zmxlog06 = g_jsonstr,tc_zmxlog08 = l_ret.success,tc_zmxlog09 = g_returnstr,
                                tc_zmxlog10 = decode(tc_zmxlog08,'Y',1,tc_zmxlog10+1),tc_zmxlog11 = sysdate
      WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'staffReceive' AND tc_zmxlog05 = p_occ01 AND tc_zmxlog07 = '04'
    END IF 
    IF l_ret.success = 'Y' THEN
       #LET l_ret.success = 'Y'
       LET l_ret.msg = "客户(",l_occ.occ01 CLIPPED,")同步成功"
    ELSE
       #LET l_ret.success = 'N'
       LET l_ret.msg = l_returnmsg
    END IF

    RETURN l_ret.*

END FUNCTION 

###理由码同步
##
FUNCTION cjc_zmx_json_azf(p_azf01)
DEFINE p_azf01          LIKE azf_file.azf01
DEFINE l_data           RECORD
                            code                LIKE type_file.chr100,
                            _name               LIKE type_file.chr100,
                            _status             LIKE type_file.chr1,
                            groupIdCode         LIKE type_file.chr100
                        END RECORD
DEFINE l_ret            RECORD 
          success       LIKE type_file.chr1,
          code          LIKE type_file.chr10,
          msg           STRING
                        END RECORD
DEFINE l_azf            RECORD LIKE azf_file.*
DEFINE l_json_str       STRING 
DEFINE l_json_data      STRING 
DEFINE l_sql            STRING 
DEFINE l_cnt            LIKE type_file.num10
DEFINE l_returnstatus   LIKE type_file.num5
DEFINE l_returnmsg      String

    INITIALIZE l_ret TO NULL 
    IF cl_null(p_azf01) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "无码别代码"
    END IF 

    INITIALIZE l_azf TO NULL 
    SELECT * INTO l_azf.* FROM azf_file WHERE azf01= p_azf01 AND rownum =1 
     

    INITIALIZE l_data TO NULL 
    LET l_data.code  = l_azf.azf01
    LET l_data._name  = l_azf.azf03
    IF l_azf.azfacti  = 'Y' THEN 
        LET l_data._status = '1'
    ELSE 
        LET l_data._status = '0'
    END IF 
    LET l_data.groupIdCode= g_plant
    #LET l_json_data = cl_getazf_data_json(l_data.*)

    LET l_json_str = "{",l_json_data,"}"

    LET l_ret.msg = l_json_str
    DISPLAY "-------------------------json-------reasonCodeReceive------------"
    DISPLAY l_json_str
    DISPLAY "--------------------------------------------------"
    INITIALIZE l_returnstatus TO NULL 
    INITIALIZE l_returnmsg TO NULL
    CALL reasonCodeReceive(l_json_str) RETURNING l_returnstatus,l_returnmsg
    LET g_jsonstr = l_json_str
    LET g_returnstr = l_returnmsg
    IF l_returnstatus = '0' AND l_returnmsg = 'OK' THEN 
    	LET l_ret.success = 'Y' 
    	ELSE 
    	LET l_ret.success = 'N' 
    END IF 
    SELECT COUNT(*) INTO l_cnt FROM tc_zmxlog_file WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'reasonCodeReceive' AND tc_zmxlog05 = p_azf01 AND tc_zmxlog07 = '051'
    IF l_cnt = 0 OR cl_null(l_cnt) THEN 
      INSERT INTO tc_zmxlog_file values(g_plant,'reasonCodeReceive',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),g_user,p_azf01,g_jsonstr,'051',l_ret.success,g_returnstr,1,sysdate)
      ELSE 
      UPDATE tc_zmxlog_file SET tc_zmxlog03 = decode(tc_zmxlog08,'Y',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),tc_zmxlog03),
                                tc_zmxlog04 = decode(tc_zmxlog08,'Y',g_user,tc_zmxlog04),
                                tc_zmxlog06 = g_jsonstr,tc_zmxlog08 = l_ret.success,tc_zmxlog09 = g_returnstr,
                                tc_zmxlog10 = decode(tc_zmxlog08,'Y',1,tc_zmxlog10+1),tc_zmxlog11 = sysdate
      WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'reasonCodeReceive' AND tc_zmxlog05 = p_azf01 AND tc_zmxlog07 = '051'
    END IF 
    IF l_ret.success = 'Y' THEN
       #LET l_ret.success = 'Y'
       LET l_ret.msg = "理由码(",l_azf.azf01 CLIPPED,")同步成功"
    ELSE
       #LET l_ret.success = 'N'
       LET l_ret.msg = l_returnmsg
    END IF

    RETURN l_ret.*

END FUNCTION 


##供应商同步
#
FUNCTION cl_zmx_json_pmc(p_pmc01,p_uptime)
DEFINE p_pmc01          LIKE pmc_file.pmc01
DEFINE p_uptime         LIKE type_file.chr100
DEFINE l_data           RECORD
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
                            regiCurrencyCode                           LIKE type_file.chr100,                    #注册币种
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
DEFINE l_ret            RECORD 
          success       LIKE type_file.chr1,
          code          LIKE type_file.chr10,
          msg           STRING
                        END RECORD
DEFINE l_pmc            RECORD LIKE pmc_file.*
DEFINE l_json_str       STRING 
DEFINE l_json_data      STRING 
DEFINE l_sql            STRING 
DEFINE l_cnt            LIKE type_file.num10
DEFINE l_returnstatus   LIKE type_file.num5
DEFINE l_returnmsg      String

  INITIALIZE l_ret TO NULL
    LET l_ret.success = 'Y'

    IF cl_null(p_pmc01) THEN
        LET l_ret.success = 'N'
        LET l_ret.msg = "无供应商编号"
        RETURN l_ret.*
    END IF

    SELECT COUNT(1) INTO l_cnt FROM pmc_file
     WHERE pmc01 =  p_pmc01
    IF cl_null(l_cnt) THEN
        LET l_cnt = 0
    END IF
    IF l_cnt = 0 THEN
        LET l_ret.msg = "供应商(",p_pmc01 CLIPPED,")未匹配"
        LET l_ret.success = 'N'
        RETURN l_ret.*
    END IF

    INITIALIZE l_data TO NULL
    INITIALIZE l_json_str TO NULL
    INITIALIZE l_json_data TO NULL
    INITIALIZE l_pmc TO NULL
    SELECT * INTO l_pmc.* FROM pmc_file
     WHERE pmc01 = p_pmc01
    IF SQLCA.SQLCODE THEN
        LET l_ret.success = 'N'
        LET l_ret.msg = "获取供应商(",p_pmc01 CLIPPED,")失败,SQLERR:",SQLCA.SQLCODE USING '-----'
        LET l_ret.code = SQLCA.SQLCODE = '-----'
        RETURN l_ret.*
    END IF

    IF l_pmc.pmc05 <> '1' THEN
        LET l_ret.success = 'N'
        LET l_ret.msg = "供应商资料未审核"
        RETURN l_ret.*
    END IF

    IF l_pmc.pmcacti = 'N' THEN
        LET l_ret.success = 'N'
        LET l_ret.msg = "供应商资料已无效"
        RETURN l_ret.*
    END IF

    INITIALIZE l_data TO NULL
    LET l_data.groupIdCode                             = g_plant    
    LET l_data.createdByCode                            = l_pmc.pmcuser   

    LET l_data.code                                     = l_pmc.pmc01      #供应商编码
    LET l_data.shortName                                = l_pmc.pmc03      #供应商简称
    LET l_data._name                                    = l_pmc.pmc081     #供应商名称
    IF l_pmc.pmcacti = 'Y' THEN 
       LET l_data._status  = '1'
    ELSE
       LET l_data._status  = '0'
    END IF  
    LET l_data.uniformCreditCode                        = l_pmc.pmc24    #统一社会信用代码
    LET l_data.purchaseType                             = l_pmc.pmc30      #采购性质
    LET l_data.supplierType                             = l_pmc.pmc02      #供应商类型
    #LET l_data.regiCapital                              = l_pmc.pmc      #注册资本
    LET l_data.regiCurrencyCode                             = l_pmc.pmc22      #注册币种
    #LET l_data.regiDate                                 = l_pmc.pmc      #注册日期
    LET l_data.telephone                                = l_pmc.pmc10      #电话号码
    LET l_data.fax                                      = l_pmc.pmc11      #传真号
    LET l_data.email                                    = l_pmc.pmc12      #电子邮件
    #LET l_data.webSite                                  = l_pmc.pmc       #网址
    LET l_data.country                                  = l_pmc.pmc07      #国家
    LET l_data.state                                    = l_pmc.pmc908      #省份
    LET l_data.city                                     = l_pmc.pmc06      #城市
    LET l_data.contactAddress                           = l_pmc.pmc091      #地址
    LET l_data.zipCode                                  = l_pmc.pmc904      #邮编
    LET l_data.mobile                                   = l_pmc.pmc10       #手机号码
    #LET l_data.contact                                  = l_pmc.pmc       #联系人
    LET l_data.taxRegistrationNo                        = l_pmc.pmc24      #税务登记号（纳税人识别号）
    LET l_data.tranCurrencyCode                         = l_pmc.pmc22      #交易币种
    LET l_data.tranTaxCode                              = l_pmc.pmc47      #交易税种
    LET l_data.paymentTerm                              = l_pmc.pmc17      #默认付款条件
    LET l_data.priceTermid                              = l_pmc.pmc49      #默认价格条件
    LET l_data.closedDate                               = l_pmc.pmc29      #结账日
    LET l_data.invoiceCreditCode                        = l_pmc.pmc24      #税号
    LET l_data.invoiceTelephone                         = l_pmc.pmc12      #发票电话
    LET l_data.invoiceCompany                           = l_pmc.pmc081     #发票抬头
    LET l_data.invoiceAddress                           = l_pmc.pmc52      #发票地址
    LET l_data.closedDate                               = l_pmc.pmc29      #结账日
    LET l_data.accountNo                                = l_pmc.pmc56      #银行账户
    LET l_data.createdOn                                = p_uptime
    LET l_json_data = cl_getpmc_data_json(l_data.*)

    LET l_json_str = "{",l_json_data,"}"
    LET l_json_str = cl_replace_str(l_json_str," ","")
    LET l_json_str = cl_replace_str(l_json_str,"`"," ")
    LET l_ret.msg = l_json_str


    DISPLAY "-------------------------json-------supplierReceive------------"
    DISPLAY l_json_str
    DISPLAY "--------------------------------------------------"
    INITIALIZE l_returnstatus TO NULL 
    INITIALIZE l_returnmsg TO NULL
    CALL supplierReceive(l_json_str) RETURNING l_returnstatus,l_returnmsg
    LET g_jsonstr = l_json_str
    LET g_returnstr = l_returnmsg
    IF l_returnstatus = '0' AND l_returnmsg = 'OK' THEN 
    	LET l_ret.success = 'Y' 
    	ELSE 
    	LET l_ret.success = 'N' 
    END IF 
    SELECT COUNT(*) INTO l_cnt FROM tc_zmxlog_file WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'supplierReceive' AND tc_zmxlog05 = p_pmc01 AND tc_zmxlog07 = '05'
    IF l_cnt = 0 OR cl_null(l_cnt) THEN 
      INSERT INTO tc_zmxlog_file values(g_plant,'supplierReceive',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),g_user,p_pmc01,g_jsonstr,'05',l_ret.success,g_returnstr,1,sysdate)
      ELSE 
      UPDATE tc_zmxlog_file SET tc_zmxlog03 = decode(tc_zmxlog08,'Y',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),tc_zmxlog03),
                                tc_zmxlog04 = decode(tc_zmxlog08,'Y',g_user,tc_zmxlog04),
                                tc_zmxlog06 = g_jsonstr,tc_zmxlog08 = l_ret.success,tc_zmxlog09 = g_returnstr,
                                tc_zmxlog10 = decode(tc_zmxlog08,'Y',1,tc_zmxlog10+1),tc_zmxlog11 = sysdate
      WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'supplierReceive' AND tc_zmxlog05 = p_pmc01 AND tc_zmxlog07 = '05'
    END IF 
    IF l_ret.success = 'Y' THEN
       #LET l_ret.success = 'Y'
       LET l_ret.msg = "供应商(",l_pmc.pmc01 CLIPPED,")同步成功"
    ELSE
       #LET l_ret.success = 'N'
       LET l_ret.msg = l_returnmsg
    END IF

    RETURN l_ret.*

END FUNCTION 



#料件资料同步
FUNCTION cl_zmx_json_ima(p_ima01,p_uptime)
DEFINE p_ima01          LIKE ima_file.ima01
DEFINE p_uptime         LIKE type_file.chr100
DEFINE l_data           RECORD
                            groupIdCode                      LIKE type_file.chr100,     #营运中心id		
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
                            shelfLife                      LIKE type_file.chr100       #有效期
                        END RECORD
DEFINE l_ret            RECORD
          success       LIKE type_file.chr1,
          code          LIKE type_file.chr10,
          msg           STRING
                        END RECORD
DEFINE l_ima            RECORD LIKE ima_file.*
DEFINE l_json_str       STRING
DEFINE l_json_data      STRING
DEFINE l_sql            STRING
DEFINE l_cnt            LIKE type_file.num10
DEFINE l_returnstatus   LIKE type_file.num5
DEFINE l_returnmsg      String

    INITIALIZE l_ret TO NULL
    LET l_ret.success = 'Y'

    IF cl_null(p_ima01) THEN
        LET l_ret.success = 'N'
        LET l_ret.msg = "无料件编号"
        RETURN l_ret.*
    END IF

    INITIALIZE l_cnt TO NULL
    SELECT COUNT(1) INTO l_cnt FROM ima_file
     WHERE ima01 =  p_ima01
    IF cl_null(l_cnt) THEN
        LET l_cnt = 0
    END IF
    IF l_cnt = 0 THEN
        LET l_ret.msg = "料号(",p_ima01 CLIPPED,")未匹配"
        LET l_ret.success = 'N'
        RETURN l_ret.*
    END IF

    INITIALIZE l_data TO NULL
    INITIALIZE l_json_str TO NULL
    INITIALIZE l_json_data TO NULL
    INITIALIZE l_ima TO NULL
    SELECT * INTO l_ima.* FROM ima_file
     WHERE ima01 = p_ima01
    IF SQLCA.SQLCODE THEN
        LET l_ret.success = 'N'
        LET l_ret.msg = "获取料号(",p_ima01 CLIPPED,")失败,SQLERR:",SQLCA.SQLCODE USING '-----'
        LET l_ret.code = SQLCA.SQLCODE = '-----'
        RETURN l_ret.*
    END IF

    IF l_ima.ima1010 = '0' THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "料件尚未审核"
        RETURN l_ret.*
    END IF 

    IF l_ima.imaacti = 'N' THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "料件已无效"
        RETURN l_ret.*
    END IF 
    select replace(l_ima.ima01,chr(10),'')into l_ima.ima01 from dual
        select replace(l_ima.ima02,'"','\\\"'),replace(l_ima.ima021,'"','\\\"') into l_ima.ima02,l_ima.ima021 from dual
        select replace(l_ima.ima02,'	',''),replace(l_ima.ima021,'	','') into l_ima.ima02,l_ima.ima021 from dual
        select replace(l_ima.ima02,chr(10),''),replace(l_ima.ima021,chr(10),'') into l_ima.ima02,l_ima.ima021 from dual
        LET l_data.groupIdCode                               = g_plant                                               # 营运中心id
        LET l_data.code                                    = l_ima.ima01                                                  # 编码（料号）
        LET l_data._name                                   = l_ima.ima02                                                  # 名称
        IF l_ima.imaacti = 'Y' THEN 
            LET l_data._status                                 = '1'
        ELSE 
            LET l_data._status                                 = '0'
        END IF 
        LET l_data.spec                                    = l_ima.ima021                                                  # 规格
        LET l_data.categoryCode                            = l_ima.ima06                                                  # 分类id ，关联表（GOODS_CATEGORY）
        LET l_data.storeUnitCode                           = l_ima.ima25                                                  # 库存单位id，关联表（UNIT）
        LET l_data.purUnitCode                             = l_ima.ima44                                                  # 采购单位id，关联表（UNIT）
        LET l_data.unitToPut                               = l_ima.ima44_fac                                                  # 采购/库存单位转换率
        LET l_data.saleUnitCode                            = l_ima.ima31                                                  # 销售单位id，关联表（UNIT）
        LET l_data.unitToSale                              = l_ima.ima31_fac                                                  # 销售单位/库存单位转换率
        LET l_data.productionUnitCode                      = l_ima.ima55                                                  # 生产单位id，关联表（UNIT）
        LET l_data.unitToProduction                        = l_ima.ima55_fac                                                  # 生产单位/库存单位转换率
        LET l_data.issueUnitCode                           = l_ima.ima63                                                  # 发料单位id，关联表（UNIT）
        LET l_data.unitToIssue                             = l_ima.ima63_fac                                                  # 发料单位/库存单位转换率
        LET l_data.orderUnitCode                           = l_ima.ima31                                                  # 订货单位id，关联表（UNIT）
        LET l_data.unitToOrder                             = l_ima.ima31_fac                                                  # 订货单位/库存单位转换率
        LET l_data.purBatch                                = l_ima.ima45                                                  # 采购批量
        LET l_data.purMinBatch                             = l_ima.ima46                                                  # 最少采购量
        LET l_data.upperProductStock                       = l_ima.ima271                                                  # 最高生产（线边仓）库存
        LET l_data.lowerProductStock                       = l_ima.ima27                                                  # 最低生产（线边仓）库存
        LET l_data.minSendAmount                           = l_ima.ima561                                                  # 最小发料量
        IF NOT cl_null(l_ima.ima43) THEN 
            SELECT count(*) INTO l_cnt FROM gen_file WHERE genacti = 'Y' AND gen01 =  l_ima.ima43     
            IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
        END IF 
        IF l_cnt >0 THEN 
            LET l_data.buyerCode                               = l_ima.ima43                                                  # 采购员id，关联表（STAFF）
        ELSE 
            LET l_data.buyerCode                               =  ""
        END IF 
        IF NOT cl_null(l_ima.ima23) THEN 
            SELECT count(*) INTO l_cnt FROM gen_file WHERE genacti = 'Y' AND gen01 =  l_ima.ima23     
            IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
        END IF 
        IF l_cnt >0 THEN 
            LET l_data.storerCode                              = l_ima.ima23                                                  # 仓管员id，关联表（STAFF）
        ELSE 
            LET l_data.storerCode                              = "" 
        END IF 
        LET l_data.inspectionGrade                         = l_ima.ima102                                                  # 检验等级
        LET l_data.inspectionDegree                        = l_ima.ima100                                                  # 检验程度
        LET l_data.inspectionLevel                         = l_ima.ima101                                                  # 检验水准
        #LET l_data.matType                                 = l_ima.ima109                                                  # 材料类型
        LET l_data.warehouseCode                           = l_ima.ima35                                                  # 推荐仓库id，关联表（WAREHOUSE）
        LET l_data.cargoLocationCode                       = l_ima.ima36                                                  # 推荐货位id，关联表（CARGO_LOCATION）
        LET l_data.fromCode                                = l_ima.ima08
        IF l_ima.ima159 = '1' THEN 
           LET l_data.otherIsBatchMana = 'Yes' 
        ELSE
           LET l_data.otherIsBatchMana = 'No' 
        END IF 
        
        IF  l_ima.ima24 = 'Y' THEN         
            LET l_data.isFreeCheck                             = 'No'                                                # 是否免检（是 Yes -- 否 No）
        ELSE 
            LET l_data.isFreeCheck                             = 'Yes'  
        END IF 
        LET l_data.isBatchMana                             = l_data.otherIsBatchMana                                    # 是否批次管理（是 Yes -- 否 No）
        IF l_ima.ima921 = 'Y' THEN 
            LET l_data.isBySeries                              = 'Yes'                                                 # 是否序号管理（是 Yes -- 否 No）
        ELSE 
            LET l_data.isBySeries                              = 'No'
        END IF 
        LET l_data.ptName = l_ima.ima02
        LET l_data.createdOn = p_uptime 
        LET l_data.updatedOn = p_uptime
        LET l_data.createdByCode = l_ima.imauser
        LET l_data.updatedByCode = l_ima.imamodu
        LET l_data.shelfLife     = l_ima.ima71 
        IF cl_null(l_data.createdByCode) THEN LET l_data.createdByCode = 'tiptop' END IF 
        IF cl_null(l_data.updatedByCode) THEN LET l_data.updatedByCode = 'tiptop' END IF 
        IF cl_null(l_data.matType) THEN LET l_data.matType = 0 END IF 
        
    LET l_json_data = cl_getMaterial_data_json(l_data.*)
    LET l_json_str = "{",l_json_data,"}"
    LET l_ret.msg = l_json_str

    LET l_json_str = cl_replace_str(l_json_str," ","")
    LET l_json_str = cl_replace_str(l_json_str,"`"," ")
    LET l_json_str = cl_replace_str(l_json_str,"\\","")
    DISPLAY "-------------------------json-------materialReceive-----------"
    DISPLAY l_json_str
    DISPLAY "--------------------------------------------------"
    INITIALIZE l_returnstatus TO NULL 
    INITIALIZE l_returnmsg TO NULL
    CALL materialReceive(l_json_str) RETURNING l_returnstatus,l_returnmsg
    LET g_jsonstr = l_json_str
    LET g_returnstr = l_returnmsg
    DISPLAY "------------g_jsonstr----",g_jsonstr
    DISPLAY "----------g_returnstr----",g_returnstr
    IF l_returnstatus = '0' AND l_returnmsg = 'OK' THEN 
    	LET l_ret.success = 'Y' 
    	ELSE 
    	LET l_ret.success = 'N' 
    END IF 
    SELECT COUNT(*) INTO l_cnt FROM tc_zmxlog_file WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'materialReceive' AND tc_zmxlog05 = p_ima01 AND tc_zmxlog07 = '01'
    IF l_cnt = 0 OR cl_null(l_cnt) THEN 
      INSERT INTO tc_zmxlog_file values(g_plant,'materialReceive',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),g_user,p_ima01,g_jsonstr,'01',l_ret.success,g_returnstr,1,sysdate)
      ELSE 
      UPDATE tc_zmxlog_file SET tc_zmxlog03 = decode(tc_zmxlog08,'Y',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),tc_zmxlog03),
                                tc_zmxlog04 = decode(tc_zmxlog08,'Y',g_user,tc_zmxlog04),
                                tc_zmxlog06 = g_jsonstr,tc_zmxlog08 = l_ret.success,tc_zmxlog09 = g_returnstr,
                                tc_zmxlog10 = decode(tc_zmxlog08,'Y',1,tc_zmxlog10+1),tc_zmxlog11 = sysdate
      WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'materialReceive' AND tc_zmxlog05 = p_ima01 AND tc_zmxlog07 = '01'
    END IF 
    IF l_ret.success = 'Y' THEN
       #LET l_ret.success = 'Y'
       LET l_ret.msg = "料件(",l_ima.ima01 CLIPPED,")同步成功"
       #update t_material set flag =1 where doc_code = l_ima.ima01
    ELSE
       #LET l_ret.success = 'N'
       LET l_ret.msg = l_returnmsg
    END IF

    RETURN l_ret.*
END FUNCTION 

##############################################
#业务单据同步
##############################################

#采购单JSON -- 通过采购单
#传入:p_doc         采购单单号
#返回:string        
FUNCTION cjc_zmx_json_pmmorder(p_doc)
DEFINE p_doc            LIKE pmm_file.pmm01
DEFINE l_ret            RECORD 
             success    LIKE type_file.chr1,
             code       LIKE type_file.chr10,
             msg        STRING 
                        END RECORD
DEFINE l_pmm            RECORD LIKE pmm_file.*
DEFINE l_pmn            RECORD LIKE pmn_file.*
DEFINE l_pmc            RECORD LIKE pmc_file.*
DEFINE l_json_str       STRING 
DEFINE l_json_data      STRING 
DEFINE l_json_detail    STRING 
DEFINE l_sql            STRING 
DEFINE l_cnt            LIKE type_file.num10
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
DEFINE l_returnstatus   LIKE type_file.num5
DEFINE l_returnmsg      String

    INITIALIZE l_ret TO NULL
    LET l_ret.success = 'Y'    

    IF cl_null(p_doc) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "无采购单单号"
       #LET l_ret.msg = cl_getmsg('',g_lang)
        RETURN l_ret.*
    END IF
 
    
    SELECT COUNT(1) INTO l_cnt FROM pmm_file 
     WHERE pmm01 =  p_doc
    IF cl_null(l_cnt) THEN 
        LET l_cnt = 0
    END IF 
    IF l_cnt = 0 THEN 
        LET l_ret.msg = "采购单(",p_doc CLIPPED,")未匹配"
       #LET l_ret.msg = cl_getmsg('',g_lang)
        LET l_ret.success = 'N'
        RETURN l_ret.*
    END IF 

    INITIALIZE l_data TO NULL
    INITIALIZE l_detail TO NULL
    INITIALIZE l_json_str TO NULL 
    INITIALIZE l_json_data TO NULL 
    INITIALIZE l_json_detail TO NULL
    INITIALIZE l_pmm TO NULL
    SELECT * INTO l_pmm.* FROM pmm_file 
     WHERE pmm01 = p_doc
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "获取采购单(",p_doc CLIPPED,")失败,SQLERR:",SQLCA.SQLCODE USING '-----'
       #LET l_ret.msg = cl_getmsg('',g_lang)
        LET l_ret.code = SQLCA.SQLCODE = '-----'
        RETURN l_ret.*
    END IF 
    
    IF not cl_null(l_pmm.pmmud01) THEN
        LET l_ret.success = 'N'
        LET l_ret.msg = "结算采购单或者补料采购单不用抛转(",p_doc CLIPPED,"),SQLERR:",SQLCA.SQLCODE USING '-----'
       #LET l_ret.msg = cl_getmsg('',g_lang)
        LET l_ret.code = SQLCA.SQLCODE = '-----'
        RETURN l_ret.* 
    END IF 
    IF l_pmm.pmm18 = 'N' THEN
        LET l_ret.success = 'N'
        LET l_ret.msg = "采购单(",p_doc CLIPPED,")未审核"
       #LET l_ret.msg = cl_getmsg('',g_lang)
        RETURN l_ret.*
    END IF 

    IF l_pmm.pmm18 = 'X' THEN
        LET l_ret.success = 'N'
        LET l_ret.msg = "采购单(",p_doc CLIPPED,")已作废"
       #LET l_ret.msg = cl_getmsg('',g_lang)
        RETURN l_ret.*
    END IF 
    #add by shawn 201027 --- begin ---- 
    SELECT * INTO l_pmc.* FROM pmc_file WHERE pmc01 = l_pmm.pmm09 
    IF l_pmc.pmcud04 = 'Y' AND NOT cl_null(l_pmc.pmcud04) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "采购单(",p_doc CLIPPED,")对应供应商",l_pmc.pmc01 CLIPPED ,"不需要抛转SCM,若有改动请到apmi600对应供应商资料中维护！"
       #LET l_ret.msg = cl_getmsg('',g_lang)
        RETURN l_ret.*
    END IF  
    #---end --- 

    IF l_pmm.pmm25 <> '2' THEN
        LET l_ret.success = 'N'
        LET l_ret.msg = "采购单(",p_doc CLIPPED,")不是发出状态，不可同步"
       #LET l_ret.msg = cl_getmsg('',g_lang)
        RETURN l_ret.*
    END IF 
        LET l_data.createdBy       =    l_pmm.pmm12                                             #创建人
        LET l_data.code            =    l_pmm.pmm01                                            
        LET l_data.organizationId  =    g_plant 
        LET l_data.documentDate    =    l_pmm.pmm04 USING 'yyyy/mm/dd'                                             #单据日期
        LET l_data.supplierCode    =    l_pmm.pmm09                                             #供应商编码
        LET l_data.userId          =    l_pmm.pmm12                                             #采购员ID
        LET l_data.departmentId    =    l_pmm.pmm13                                             #采购部门ID
        LET l_data.currencyId      =    l_pmm.pmm22                                             #币种ID
        LET l_data.taxId           =    l_pmm.pmm21                                             #税种ID
        LET l_data.paymentMethodId =    l_pmm.pmm20                                             #付款方式
        LET l_data.orderCategory   =    l_pmm.pmm02                                             #采购订单类别（材料采购单 资产采购单 费用类采购）
        LET l_data.packagingReq    =    ''                                                      #包装要求
        LET l_data.remarks         =    ''                                                      #备注
        LET l_data.address         =    l_pmm.pmm10                                             #地址
        IF l_pmm.pmm02 = 'SUB' THEN 
            LET l_data.documentTypeCode  = 'PO3' 
        ELSE 
            LET l_data.documentTypeCode  = 'PO1' 
        END IF 
        SELECT count(*) INTO l_cnt  FROM pmn_file WHERE pmn01= l_pmm.pmm01 AND ((pmn04 LIKE 'M%' OR PMN04 LIKE 'E%' or PMN04 like 'M.MJ%') OR (
          pmn04 IN (SELECT ima01 FROM ima_file WHERE ima71 IS NOT NULL AND ima71>0 AND ima71<800) AND pmn04 LIKE 'H%'
        ))
        #darcy:2024/06/24 add 增加M.MJ料件作为消耗性料件
        IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
        IF l_cnt > 0 THEN 
           LET l_data.materialMark = 'N' 
        ELSE
           LET l_data.materialMark = 'Y' 
        END IF 
    LET l_json_data = cjc_addPurPurchaseOrder_data_json(l_data.*)

    LET l_sql = " SELECT * FROM pmn_file WHERE pmn01 = '",p_doc CLIPPED,"'"
    DECLARE cs_get_pmn_cs CURSOR FROM l_sql

    FOREACH cs_get_pmn_cs INTO l_pmn.*
        
 #      LET l_detail.serialNumber   =    l_pmn.pmn02                                              #序号
 #      LET l_detail.goodsCode      =    l_pmn.pmn04                                              #商品编码
 #      LET l_detail.goodsName      =    l_pmn.pmn041                                             #商品名称
 #      LET l_detail.num            =    l_pmn.pmn20                                              #数量
 #      LET l_detail.unitId         =    l_pmn.pmn07                                              #单位id
 #      LET l_detail.price          =    l_pmn.pmn31t                                             #单价
 #      LET l_detail.amount         =    l_pmn.pmn88t                                             #金额
        IF l_pmn.pmn16 <> '2' THEN 
           CONTINUE FOREACH 
        END IF 
        LET l_detail.serialNumber     = l_pmn.pmn02
        LET l_detail.productCode      = l_pmn.pmn04
        LET l_detail.productName      = l_pmn.pmn041 
        LET l_detail.specifications   = ''
        LET l_detail.quantity         = l_pmn.pmn20 
        LET l_detail.unitPrice2       = l_pmn.pmn31t 
        LET l_detail.amount           = l_pmn.pmn88t 
        LET l_detail.unchargedUPrice  = l_pmn.pmn31 
        LET l_detail.unchargedUAmount = l_pmn.pmn88
        LET l_detail.deliveryDate     = l_pmn.pmn33 USING 'yyyy/mm/dd'
        LET l_detail.unitCode         = l_pmn.pmn07
        LET l_detail.workno           = l_pmn.pmn41 
        
        SELECT nvl(pmn50 - pmn55 - pmn58,0) INTO l_detail.carton FROM pmn_file WHERE pmn01= l_pmn.pmn01
         AND pmn02 = l_pmn.pmn02 
        IF cl_null(l_detail.carton) THEN LET l_detail.carton = 0 END IF  
        

       #LET l_json_detail = cs_addPurPurchaseOrder_detail_json(l_detail.*)
        LET l_json_detail = cjc_addPurPurchaseOrder_detail_json(l_detail.*)

        IF cl_null(l_json_str) THEN 
            LET l_json_str = "{",l_json_detail.trim(),"}"       
        ELSE 
            LET l_json_str = l_json_str.trim(),",{",l_json_detail.trim(),"}"
        END IF 

        
    END FOREACH

    LET l_json_str = "{",l_json_data,',"purchaseOrderDList"',":[",l_json_str.trim(),"]}"

    LET l_json_str = cl_replace_str(l_json_str," ","")
    LET l_json_str = cl_replace_str(l_json_str,"`"," ")

    DISPLAY "-------------------------json-------purchaseReceive--------------"
    DISPLAY l_json_str
    DISPLAY "--------------------------------------------------"
    LET l_ret.msg = l_json_str

    INITIALIZE l_returnstatus TO NULL 
    INITIALIZE l_returnmsg TO NULL
    CALL purchaseReceive(l_json_str) RETURNING l_returnstatus,l_returnmsg
    LET g_jsonstr = l_json_str
    LET g_returnstr = l_returnmsg
    IF l_returnstatus = '0' AND l_returnmsg NOT MATCHES  '*失败*' THEN 
    	LET l_ret.success = 'Y' 
    	ELSE 
    	LET l_ret.success = 'N' 
    END IF 
    SELECT COUNT(*) INTO l_cnt FROM tc_zmxlog_file WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'purchaseReceive' AND tc_zmxlog05 = p_doc AND tc_zmxlog07 = '098'
    IF l_cnt = 0 OR cl_null(l_cnt) THEN 
      INSERT INTO tc_zmxlog_file values(g_plant,'purchaseReceive',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),g_user,p_doc,g_jsonstr,'098',l_ret.success,g_returnstr,1,sysdate)
      ELSE 
      UPDATE tc_zmxlog_file SET tc_zmxlog03 = decode(tc_zmxlog08,'Y',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),tc_zmxlog03),
                                tc_zmxlog04 = decode(tc_zmxlog08,'Y',g_user,tc_zmxlog04),
                                tc_zmxlog06 = g_jsonstr,tc_zmxlog08 = l_ret.success,tc_zmxlog09 = g_returnstr,
                                tc_zmxlog10 = decode(tc_zmxlog08,'Y',1,tc_zmxlog10+1),tc_zmxlog11 = sysdate
      WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'purchaseReceive' AND tc_zmxlog05 = p_doc AND tc_zmxlog07 = '098'
    END IF 
    IF l_ret.success = 'Y' THEN
       #LET l_ret.success = 'Y'
       LET l_ret.msg = "采购单(",p_doc CLIPPED,")同步成功"
       UPDATE pmm_file SET pmmud06 = substrb(g_returnstr,1,40) WHERE pmm01 = p_doc
    ELSE
       #LET l_ret.success = 'N'
       LET l_ret.msg = l_returnmsg
    END IF

    RETURN l_ret.*

END FUNCTION 


#采购变更单JSON -- 变更
#传入:p_doc         采购变更单单号
#返回:string        
FUNCTION cjc_zmx_json_pnaorder(p_doc,p_sn)
DEFINE p_doc            LIKE pna_file.pna01
DEFINE p_sn            LIKE pna_file.pna02
DEFINE l_ret            RECORD 
             success    LIKE type_file.chr1,
             code       LIKE type_file.chr10,
             msg        STRING 
                        END RECORD
DEFINE l_pna            RECORD LIKE pna_file.*
DEFINE l_pmm            RECORD LIKE pmm_file.*
DEFINE l_pmn            RECORD LIKE pmn_file.*
DEFINE l_pnb            RECORD LIKE pnb_file.*
DEFINE l_json_str       STRING 
DEFINE l_json_data      STRING 
DEFINE l_json_detail    STRING 
DEFINE l_sql            STRING 
DEFINE l_cnt            LIKE type_file.num10
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
DEFINE l_returnstatus   LIKE type_file.num5
DEFINE l_returnmsg      String

    INITIALIZE l_ret TO NULL
    LET l_ret.success = 'Y'    

    IF cl_null(p_doc) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "无采购变更单号"
       #LET l_ret.msg = cl_getmsg('',g_lang)
        RETURN l_ret.*
    END IF 
    
    SELECT COUNT(1) INTO l_cnt FROM pna_file 
     WHERE pna01 =  p_doc
    IF cl_null(l_cnt) THEN 
        LET l_cnt = 0
    END IF 
    IF l_cnt = 0 THEN 
        LET l_ret.msg = "采购变更单(",p_doc CLIPPED,")未匹配"
       #LET l_ret.msg = cl_getmsg('',g_lang)
        LET l_ret.success = 'N'
        RETURN l_ret.*
    END IF 

    INITIALIZE l_data TO NULL
    INITIALIZE l_detail TO NULL
    INITIALIZE l_json_str TO NULL 
    INITIALIZE l_json_data TO NULL 
    INITIALIZE l_json_detail TO NULL
    INITIALIZE l_pna TO NULL
    SELECT * INTO l_pna.* FROM pna_file 
     WHERE pna01 = p_doc AND pna02= p_sn
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "获取采购变更单(",p_doc CLIPPED,")失败,SQLERR:",SQLCA.SQLCODE USING '-----'
       #LET l_ret.msg = cl_getmsg('',g_lang)
        LET l_ret.code = SQLCA.SQLCODE = '-----'
        RETURN l_ret.*
    END IF 

    IF l_pna.pna05 = 'N' THEN
        LET l_ret.success = 'N'
        LET l_ret.msg = "采购变更单(",p_doc CLIPPED,")未审核"
       #LET l_ret.msg = cl_getmsg('',g_lang)
        RETURN l_ret.*
    END IF 

    IF l_pna.pna05 = 'X' THEN
        LET l_ret.success = 'N'
        LET l_ret.msg = "采购变更单(",p_doc CLIPPED,")已作废"
       #LET l_ret.msg = cl_getmsg('',g_lang)
        RETURN l_ret.*
    END IF 

    SELECT * INTO l_pmm.* FROM pmm_file WHERE pmm01= l_pna.pna01  

        LET l_data.createdBy       =    l_pna.pna16                                             #创建人
        LET l_data.code            =    l_pna.pna01                                            
        LET l_data.organizationId  =    g_plant 
        LET l_data.documentDate    =    l_pna.pna04 USING 'yyyy/mm/dd'                                             #单据日期
        LET l_data.supplierCode    =    l_pmm.pmm09                                            #供应商编码
        LET l_data.userId          =    l_pmm.pmm12                                             #采购员ID

        LET l_data.departmentId    =    l_pmm.pmm13                                             #采购部门ID
        IF cl_null(l_pna.pna08b) THEN 
            LET l_data.currencyId      =    l_pmm.pmm22                                             #币种ID
        ELSE 
            LET l_data.currencyId      =    l_pna.pna08b                                            #币种ID
        END IF 
        
        LET l_data.taxId           =    l_pmm.pmm21                                             #税种ID
        
        LET l_data.paymentMethodId =    l_pmm.pmm20                                             #付款方式
        LET l_data.orderCategory   =    l_pmm.pmm02                                             #采购订单类别（材料采购变更单 资产采购变更单 费用类采购）
        LET l_data.packagingReq    =    ''                                                      #包装要求
        LET l_data.remarks         =    ''                                                      #备注
        IF NOT cl_null(l_pna.pna11b) THEN 
            LET l_data.address         =    l_pna.pna11b                                             #地址
        ELSE 
            LET l_data.address         =    l_pna.pna11                                             #地址
        END IF 
        IF l_pmm.pmm02 = 'SUB' THEN 
            LET l_data.documentTypeCode  = 'PO3' 
        ELSE 
            LET l_data.documentTypeCode  = 'PO1' 
        END IF 
        SELECT count(*) INTO l_cnt  FROM pmn_file WHERE pmn01= l_pmm.pmm01 AND (pmn04 LIKE 'M%' OR PMN04 LIKE 'E%')
        IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
        IF l_cnt > 0 THEN 
           LET l_data.materialMark = 'N' 
        ELSE
           LET l_data.materialMark = 'Y' 
        END IF 
        
    LET l_json_data = cjc_addPurPurchaseOrder_data_json(l_data.*)

    LET l_sql = " SELECT * FROM pnb_file WHERE pnb01 = '",p_doc CLIPPED,"' and pnb02 = ",p_sn CLIPPED 
    DECLARE cs_get_pnb_cs CURSOR FROM l_sql

    FOREACH cs_get_pnb_cs INTO l_pnb.*
        
 #      LET l_detail.serialNumber   =    l_pnb.pnb03                                              #序号
 #      LET l_detail.goodsCode      =    l_pnb.pnb04a                                              #商品编码
 #      LET l_detail.goodsName      =    l_pnb.pnb04a1                                             #商品名称
 #      LET l_detail.num            =    l_pnb.pnb20                                              #数量
 #      LET l_detail.unitId         =    l_pnb.pnb07                                              #单位id
 #      LET l_detail.price          =    l_pnb.pnb31t                                             #单价
 #      LET l_detail.amount         =    l_pnb.pnb88t                                             #金额
        
 
        LET l_detail.serialNumber     = l_pnb.pnb03
        LET l_detail.productCode      = l_pnb.pnb04a
        LET l_detail.productName      = l_pnb.pnb041a 
        LET l_detail.specifications   = ''
        LET l_detail.quantity         = l_pnb.pnb20a 
        LET l_detail.unitPrice2       = l_pnb.pnb32a 
        LET l_detail.amount           = l_pnb.pnb32a*l_pnb.pnb20a
        LET l_detail.unchargedUPrice  = l_pnb.pnb31a
        LET l_detail.unchargedUAmount = l_pnb.pnb31a*l_pnb.pnb20a
        LET l_detail.deliveryDate     = l_pnb.pnb33a USING 'yyyy/mm/dd'
        IF NOT cl_null(l_pnb.pnb07a) THEN 
            LET l_detail.unitCode         = l_pnb.pnb07a
        ELSE 
            LET l_detail.unitCode         = l_pnb.pnb07b
        END IF 
        SELECT nvl(pmn50 - pmn55 - pmn58,0) INTO l_detail.carton FROM pmn_file WHERE pmn01= l_pmn.pmn01
         AND pmn02 = l_pmn.pmn02 
        IF cl_null(l_detail.carton) THEN LET l_detail.carton = 0 END IF  
       #LET l_json_detail = cs_addPurPurchaseOrder_detail_json(l_detail.*)
        LET l_json_detail = cjc_addPurPurchaseOrder_detail_json(l_detail.*)

        IF cl_null(l_json_str) THEN 
            LET l_json_str = "{",l_json_detail.trim(),"}"       
        ELSE 
            LET l_json_str = l_json_str.trim(),",{",l_json_detail.trim(),"}"
        END IF 

        
    END FOREACH

    LET l_json_str = "{",l_json_data,',"purchaseOrderDList"',":[",l_json_str.trim(),"]}"

    LET l_json_str = cl_replace_str(l_json_str," ","")
    LET l_json_str = cl_replace_str(l_json_str,"`"," ")

    DISPLAY "-------------------------json-------purchaseChange--------------"
    DISPLAY l_json_str
    DISPLAY "--------------------------------------------------"
    LET l_ret.msg = l_json_str

    INITIALIZE l_returnstatus TO NULL 
    INITIALIZE l_returnmsg TO NULL
    CALL purchaseChange(l_json_str) RETURNING l_returnstatus,l_returnmsg
    LET g_jsonstr = l_json_str
    LET g_returnstr = l_returnmsg
    IF l_returnstatus = '0' AND l_returnmsg = 'OK' THEN 
    	LET l_ret.success = 'Y' 
    	ELSE 
    	LET l_ret.success = 'N' 
    END IF 
    SELECT COUNT(*) INTO l_cnt FROM tc_zmxlog_file WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'purchaseChange' AND tc_zmxlog05 = p_doc||'/'||p_sn   #AND tc_zmxlog07 = '02'
    IF l_cnt = 0 OR cl_null(l_cnt) THEN 
      INSERT INTO tc_zmxlog_file values(g_plant,'purchaseChange',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),g_user,p_doc||'/'||p_sn,g_jsonstr,'',l_ret.success,g_returnstr,1,sysdate)
      ELSE 
      UPDATE tc_zmxlog_file SET tc_zmxlog03 = decode(tc_zmxlog08,'Y',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),tc_zmxlog03),
                                tc_zmxlog04 = decode(tc_zmxlog08,'Y',g_user,tc_zmxlog04),
                                tc_zmxlog06 = g_jsonstr,tc_zmxlog08 = l_ret.success,tc_zmxlog09 = g_returnstr,
                                tc_zmxlog10 = decode(tc_zmxlog08,'Y',1,tc_zmxlog10+1),tc_zmxlog11 = sysdate
      WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'purchaseChange' AND tc_zmxlog05 = p_doc||'/'||p_sn   #AND tc_zmxlog07 = '02'
    END IF 
    IF l_ret.success = 'Y' THEN
       #LET l_ret.success = 'Y'
       LET l_ret.msg = "采购变更单(",p_doc CLIPPED,")同步成功"
    ELSE
       #LET l_ret.success = 'N'
       LET l_ret.msg = l_returnmsg
    END IF
    RETURN l_ret.*
END FUNCTION 



#采购结案 
FUNCTION cjc_zmx_json_closepmnorder(p_doc,p_sn,p_status)
DEFINE p_doc           LIKE pmn_file.pmn01
DEFINE p_sn            LIKE pmn_file.pmn02 
DEFINE p_status        LIKE type_file.chr5
DEFINE l_data           RECORD
							          groupIdCode   LIKE type_file.chr100,
							          code          LIKE type_file.chr100,
							          seqNnm        LIKE type_file.chr100,
                                      _status       LIKE type_file.chr100
                        END RECORD
DEFINE p_type       LIKE type_file.chr1 
DEFINE l_ret            RECORD
          success       LIKE type_file.chr1,
          code          LIKE type_file.chr10,
          msg           STRING
                        END RECORD
DEFINE l_json_str       STRING
DEFINE l_json_data      STRING
DEFINE l_sql            STRING
DEFINE l_cnt            LIKE type_file.num10
DEFINE l_returnstatus   LIKE type_file.num5
DEFINE l_returnmsg      String
DEFINE l_pmn            RECORD LIKE pmn_file.*

    INITIALIZE l_ret TO NULL
    LET l_ret.success = 'Y'

    IF cl_null(p_doc) THEN
        LET l_ret.success = 'N'
        LET l_ret.msg = "无采购单号"
       #LET l_ret.msg = cl_getmsg('',g_lang)
        RETURN l_ret.*
    END IF

    INITIALIZE l_data TO NULL
    INITIALIZE l_json_str TO NULL
    INITIALIZE l_json_data TO NULL
    INITIALIZE l_pmn TO NULL
    SELECT * INTO l_pmn.* FROM pmn_file 
     WHERE pmn01 = p_doc AND pmn02= p_sn
    IF SQLCA.SQLCODE THEN
        LET l_ret.success = 'N'
        LET l_ret.msg = "获取采购单(",p_doc CLIPPED,"项次：",p_sn clipped,")失败,SQLERR:",SQLCA.SQLCODE USING '-----'
       #LET l_ret.msg = cl_getmsg('',g_lang)
        LET l_ret.code = SQLCA.SQLCODE = '-----'
        RETURN l_ret.*
    END IF


    INITIALIZE l_data TO NULL
    LET l_data.code  = l_pmn.pmn01        #申请单号      
    LET l_data.seqNnm =  l_pmn.pmn02  
    LET l_data.groupIdCode = g_plant     #营运中心
    LET l_data._status = p_status 



    LET l_json_data = cjc_closepmnorder_data_json(l_data.*)

    LET l_json_str = "{",l_json_data,"}"

    LET l_ret.msg = l_json_str

    DISPLAY "-------------------------json---------purchaseClose-----------"
    DISPLAY l_json_str
    DISPLAY "--------------------------------------------------"
    
    INITIALIZE l_returnstatus TO NULL
    INITIALIZE l_returnmsg TO NULL
    CALL purchaseClose(l_json_str) RETURNING l_returnstatus,l_returnmsg
    LET g_jsonstr = l_json_str
    LET g_returnstr = l_returnmsg
    IF l_returnstatus = '0' AND l_returnmsg = 'OK' THEN 
    	LET l_ret.success = 'Y' 
    	ELSE 
    	LET l_ret.success = 'N' 
    END IF 
    SELECT COUNT(*) INTO l_cnt FROM tc_zmxlog_file WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'purchaseClose' AND tc_zmxlog05 = p_doc||'/'||p_sn #AND tc_zmxlog07 = '02'
    IF l_cnt = 0 OR cl_null(l_cnt) THEN 
      INSERT INTO tc_zmxlog_file values(g_plant,'purchaseClose',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),g_user,p_doc||'/'||p_sn,g_jsonstr,'',l_ret.success,g_returnstr,1,sysdate)
      ELSE 
      UPDATE tc_zmxlog_file SET tc_zmxlog03 = decode(tc_zmxlog08,'Y',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),tc_zmxlog03),
                                tc_zmxlog04 = decode(tc_zmxlog08,'Y',g_user,tc_zmxlog04),
                                tc_zmxlog06 = g_jsonstr,tc_zmxlog08 = l_ret.success,tc_zmxlog09 = g_returnstr,
                                tc_zmxlog10 = decode(tc_zmxlog08,'Y',1,tc_zmxlog10+1),tc_zmxlog11 = sysdate
      WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'purchaseClose' AND tc_zmxlog05 = p_doc||'/'||p_sn #AND tc_zmxlog07 = '02'
    END IF 
    IF l_ret.success = 'Y' THEN
       #LET l_ret.success = 'Y'
       LET l_ret.msg = "采购(",l_pmn.pmn01 CLIPPED,")撤销检查成功"
    ELSE
       #LET l_ret.success = 'N'
       LET l_ret.msg = l_returnmsg
    END IF

    RETURN l_ret.*

END FUNCTION


#采购撤销
FUNCTION cjc_zmx_json_cancelPmmorder(p_doc)
DEFINE p_doc           LIKE pmm_file.pmm01
DEFINE l_data           RECORD
							          groupIdCode   LIKE type_file.chr100,
							          code          LIKE type_file.chr100,
							          docTypeIdCodeIdCode     LIKE type_file.chr100
                        END RECORD
DEFINE p_type       LIKE type_file.chr1 
DEFINE l_ret            RECORD
          success       LIKE type_file.chr1,
          code          LIKE type_file.chr10,
          msg           STRING
                        END RECORD
DEFINE l_json_str       STRING
DEFINE l_json_data      STRING
DEFINE l_sql            STRING
DEFINE l_cnt            LIKE type_file.num10
DEFINE l_returnstatus   LIKE type_file.num5
DEFINE l_returnmsg      String
DEFINE l_pmm            RECORD LIKE pmm_file.*

    INITIALIZE l_ret TO NULL
    LET l_ret.success = 'Y'

    IF cl_null(p_doc) THEN
        LET l_ret.success = 'N'
        LET l_ret.msg = "无采购单号"
       #LET l_ret.msg = cl_getmsg('',g_lang)
        RETURN l_ret.*
    END IF

    INITIALIZE l_data TO NULL
    INITIALIZE l_json_str TO NULL
    INITIALIZE l_json_data TO NULL
    INITIALIZE l_pmm TO NULL
    SELECT * INTO l_pmm.* FROM pmm_file
     WHERE pmm01 = p_doc
    IF SQLCA.SQLCODE THEN
        LET l_ret.success = 'N'
        LET l_ret.msg = "获取采购单(",p_doc CLIPPED,")失败,SQLERR:",SQLCA.SQLCODE USING '-----'
       #LET l_ret.msg = cl_getmsg('',g_lang)
        LET l_ret.code = SQLCA.SQLCODE = '-----'
        RETURN l_ret.*
    END IF

    IF l_pmm.pmm18 <> 'Y' THEN
        LET l_ret.success = 'N'
        LET l_ret.msg = '采购单未审核'
        RETURN l_ret.*
    END IF

    INITIALIZE l_data TO NULL
    LET l_data.code  = l_pmm.pmm01        #申请单号      
    LET l_data.docTypeIdCodeIdCode = ''        #单据类型
    LET l_data.groupIdCode = g_plant     #营运中心



    LET l_json_data = cjc_cancelpmmorder_data_json(l_data.*)

    LET l_json_str = "{",l_json_data,"}"

    LET l_ret.msg = l_json_str

    DISPLAY "-------------------------json---------purchaseDel-----------"
    DISPLAY l_json_str
    DISPLAY "--------------------------------------------------"
    
    INITIALIZE l_returnstatus TO NULL
    INITIALIZE l_returnmsg TO NULL
    CALL purchaseDel(l_json_str) RETURNING l_returnstatus,l_returnmsg
    LET g_jsonstr = l_json_str
    LET g_returnstr = l_returnmsg
    IF l_returnstatus = '0' AND l_returnmsg NOT MATCHES '*失败*' THEN 
    	LET l_ret.success = 'Y' 
    	ELSE 
    	LET l_ret.success = 'N' 
    END IF 
    SELECT COUNT(*) INTO l_cnt FROM tc_zmxlog_file WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'purchaseDel' AND tc_zmxlog05 = p_doc   #AND tc_zmxlog07 = '02'
    IF l_cnt = 0 OR cl_null(l_cnt) THEN 
      INSERT INTO tc_zmxlog_file values(g_plant,'purchaseDel',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),g_user,p_doc,g_jsonstr,'',l_ret.success,g_returnstr,1,sysdate)
      ELSE 
      UPDATE tc_zmxlog_file SET tc_zmxlog03 = decode(tc_zmxlog08,'Y',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),tc_zmxlog03),
                                tc_zmxlog04 = decode(tc_zmxlog08,'Y',g_user,tc_zmxlog04),
                                tc_zmxlog06 = g_jsonstr,tc_zmxlog08 = l_ret.success,tc_zmxlog09 = g_returnstr,
                                tc_zmxlog10 = decode(tc_zmxlog08,'Y',1,tc_zmxlog10+1),tc_zmxlog11 = sysdate
      WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'purchaseDel' AND tc_zmxlog05 = p_doc   #AND tc_zmxlog07 = '02'
    END IF 
    IF l_ret.success = 'Y' THEN
       #LET l_ret.success = 'Y'
       LET l_ret.msg = "采购(",l_pmm.pmm01 CLIPPED,")撤销检查成功"
       UPDATE pmm_file SET pmmud06 = '' WHERE pmm01 = l_pmm.pmm01
    ELSE
       #LET l_ret.success = 'N'
       LET l_ret.msg = l_returnmsg
    END IF

    RETURN l_ret.*

END FUNCTION



#工单-同步
#传入:p_type p_doc         单据类型   单号
#返回:string      
#工单资料同步
FUNCTION cjc_zmx_json_sfb(p_sfb01)
DEFINE p_sfb01          LIKE sfb_file.sfb01
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
                            project_code                             LIKE type_file.chr100,      #版本号
                            _status                                  LIKE type_file.chr100       #状态
                        END RECORD
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
                            flag                                     LIKE type_file.chr100     #来源特性（N一般料件 E消耗性料件，消耗性料件不必捡料，一般由调拨到线边仓，属于倒扣料。V大宗采购料件 U大宗自制料件 R在制料件 X资讯参考 S回收料 C客供料）		
                            #jobCode                                  LIKE type_file.chr100,       #作业编号
                            #actualQpa                                LIKE type_file.chr100        #实际QPA 
                        END RECORD
DEFINE l_detail2        RECORD
           processNo    LIKE type_file.chr100,
           processCode  LIKE type_file.chr100,
           productCode  LIKE type_file.chr100,
           jobCode      LIKE type_file.chr100,
           jobName      LIKE type_file.chr100,
           workstationCode  LIKE type_file.chr100,
           workstationName  LIKE type_file.chr100,
           groupCode    LIKE type_file.chr100,
           workNo       LIKE type_file.chr100,
           materialCode LIKE type_file.chr100,
           machineCode  LIKE type_file.chr100,
           wastage      LIKE type_file.chr100,
           startTime    LIKE type_file.chr100,
           endTime      LIKE type_file.chr100,
           goodIn       LIKE type_file.chr100,
           reworkIn     LIKE type_file.chr100,
           workIn       LIKE type_file.chr100,
           goodOut      LIKE type_file.chr100,
           reworkOut    LIKE type_file.chr100,
           scrap        LIKE type_file.chr100,
           offlines     LIKE type_file.chr100,
           bonusQty     LIKE type_file.chr100,
           workOut      LIKE type_file.chr100,
           ifOutsource  LIKE type_file.chr100,
           processed    LIKE type_file.chr100,
           finished     LIKE type_file.chr100,
           lossRate     LIKE type_file.chr100,
           beforePsCode LIKE type_file.chr100,
           ps_code      LIKE type_file.chr100,
           ifReport     LIKE type_file.chr100,
           outsourceSup LIKE type_file.chr100,
           psDesc       LIKE type_file.chr100,
           nextPsCode   LIKE type_file.chr100,
           attr1        LIKE type_file.chr100,
           attr2        LIKE type_file.chr100,
           attr3        LIKE type_file.chr100,
           attr4        LIKE type_file.chr100,
           attr5        LIKE type_file.chr100,
           attr6        LIKE type_file.chr100,
           attr7        LIKE type_file.chr100,
           attr8        LIKE type_file.chr100,
           attr9        LIKE type_file.chr100,
           attr10       LIKE type_file.chr100
                        END RECORD
DEFINE l_ret            RECORD
          success       LIKE type_file.chr1,
          code          LIKE type_file.chr10,
          msg           STRING
                        END RECORD
DEFINE l_gen            RECORD LIKE gen_file.*
DEFINE l_json_str       STRING
DEFINE l_json_str1      STRING
DEFINE l_json_str2      STRING
DEFINE l_json_data      STRING
DEFINE l_json_detail    STRING
DEFINE l_json_detail2   STRING
DEFINE l_sql            STRING
DEFINE l_cnt            LIKE type_file.num10
DEFINE l_returnstatus   LIKE type_file.num5
DEFINE l_returnmsg      String
DEFINE l_sfb            RECORD LIKE sfb_file.*
DEFINE l_sfa            RECORD LIKE sfa_file.*
DEFINE l_ecm            RECORD LIKE ecm_file.*
DEFINE l_ima02          LIKE ima_file.ima02 
DEFINE l_ima021         LIKE ima_file.ima021 

    INITIALIZE l_ret TO NULL
    LET l_ret.success = 'Y'

    IF cl_null(p_sfb01) THEN
        LET l_ret.success = 'N'
        LET l_ret.msg = "无工单单号"
       #LET l_ret.msg = cjc_getmsg('',g_lang)
        RETURN l_ret.*
    END IF

    SELECT COUNT(1) INTO l_cnt FROM sfb_file
     WHERE sfb01 =  p_sfb01
    IF cl_null(l_cnt) THEN
        LET l_cnt = 0
    END IF
    IF l_cnt = 0 THEN
        LET l_ret.msg = "工单(",p_sfb01 CLIPPED,")未匹配"
       #LET l_ret.msg = cjc_getmsg('',g_lang)
        LET l_ret.success = 'N'
        RETURN l_ret.*
    END IF

    INITIALIZE l_data TO NULL
    INITIALIZE l_detail TO NULL
    INITIALIZE l_json_str TO NULL
    INITIALIZE l_json_str1 TO NULL
    INITIALIZE l_json_str2 TO NULL
    INITIALIZE l_json_data TO NULL
    INITIALIZE l_json_detail TO NULL
    INITIALIZE l_json_detail2 TO NULL
    INITIALIZE l_sfb TO NULL
    SELECT * INTO l_sfb.* FROM sfb_file
     WHERE sfb01 = p_sfb01
    IF SQLCA.SQLCODE THEN
        LET l_ret.success = 'N'
        LET l_ret.msg = "获取工单(",p_sfb01 CLIPPED,")失败,SQLERR:",SQLCA.SQLCODE USING '-----'
       #LET l_ret.msg = cjc_getmsg('',g_lang)
        LET l_ret.code = SQLCA.SQLCODE = '-----'
        RETURN l_ret.*
    END IF

    IF l_sfb.sfb87 <> 'Y' THEN
        LET l_ret.success = 'N'
        LET l_ret.msg = '工单未审核'
        RETURN l_ret.*
    END IF

  {  IF l_sfb.sfb04 > 3 and l_sfb.sfb04 < 8 THEN
        LET l_ret.success = 'N'
        LET l_ret.msg = '工单已发料或已有入库'
        RETURN l_ret.*
    END IF
}
#INITIALIZE l_data.* TO NULL 
    IF l_sfb.sfb04 = '8' THEN
        LET l_ret.success = 'N'
        LET l_ret.msg = '工单已结案'
        RETURN l_ret.*
    END IF
    INITIALIZE l_data TO NULL
    LET l_data.createdByCode                            = l_sfb.sfbuser      #创建人
    LET l_data.updatedByCode                            = l_sfb.sfbmodu      #更新人
    LET l_data.workNo                                   = l_sfb.sfb01      #工单编号
    LET l_data.generateDate                             = l_sfb.sfb13  USING 'yyyy/mm/dd'       #开单日期
    LET l_data.workType                                 = l_sfb.sfb02      #工单类型
    LET l_data.accountWay                               = l_sfb.sfb39      #扣账方式
    LET l_data.productCode                              = l_sfb.sfb05      #成品代码
    SELECT ima02,ima021 INTO l_ima02,l_ima021  FROM ima_file WHERE ima01= l_sfb.sfb05
    select replace(l_ima02,'\\','\\\\'),replace(l_ima021,'\\','\\\\') into l_ima02,l_ima021 from dual 
    select replace(l_ima02,'"','\\\"'),replace(l_ima021,'"','\\\"') into l_ima02,l_ima021 from dual
    select replace(l_ima02,'    ',''),replace(l_ima021,'    ','') into l_ima02,l_ima021 from dual
    select replace(l_ima02,chr(10),''),replace(l_ima021,chr(10),'') into l_ima02,l_ima021 from dual
    LET l_data.productName                              = l_ima02        #品名
    LET l_data.spec                                     = l_ima021        #规格
    LET l_data.orderNo                                  = l_sfb.sfb22      #订单号
    LET l_data.orderItem                                = l_sfb.sfb221      #订单项次
    LET l_data.bom                                      = l_sfb.sfb07      #bom版本
    LET l_data.amount                                   = l_sfb.sfb08      #数量
    LET l_data.expectedStartDate                        = l_sfb.sfb13  USING 'yyyy/mm/dd'     #预计开工日期
    LET l_data.actualStartDate                          = l_sfb.sfb25  USING 'yyyy/mm/dd'    #实际开工日期
    LET l_data.expectedEndDate                          = l_sfb.sfb15  USING 'yyyy/mm/dd'    #预计完工日期
    #LET l_data.actualEndDate                            = l_sfb.sfb      #实际完工日期
    LET l_data.processCode                              = l_sfb.sfb06      #工艺编号
    LET l_data.ifTech                                   = l_sfb.sfb93      #是否工艺工单
    LET l_data.isRework                                 = l_sfb.sfb99      #返工否
    LET l_data.isFqc                                    = l_sfb.sfb94      #FQC否
    LET l_data.groupIdCode                              = g_plant      #营运中心id
    LET l_data.sfb82                                    = l_sfb.sfb82      #部门厂商
    LET l_data.sfbud02                                  = l_sfb.sfbud02      #客户订单号
    LET l_data.sfbud03                                  = l_sfb.sfbud03      #OEM
    LET l_data.sfbud04                                  = l_sfb.sfbud04      #成品编号
    LET l_data.production_line                          = l_sfb.sfb102 
    LET l_data._status = '2'
    
    IF cl_null(l_data.generateDate) THEN LET l_data.generateDate  = g_today USING 'yyyy/mm/dd'  END IF 
    IF cl_null(l_data.expectedStartDate) THEN LET l_data.expectedStartDate = g_today USING 'yyyy/mm/dd'  END IF 
    IF cl_null(l_data.actualStartDate) THEN LET l_data.actualStartDate = g_today USING 'yyyy/mm/dd'  END IF 
    IF cl_null(l_data.expectedEndDate) THEN LET l_data.expectedEndDate = g_today USING 'yyyy/mm/dd'  END IF 
    IF cl_null(l_data.generateDate) THEN LET l_data.generateDate = g_today USING 'yyyy/mm/dd'  END IF 

    SELECT sfb07 INTO l_data.project_code FROM sfb_file WHERE sfb22 = l_sfb.sfb22 AND sfb221 = l_sfb.sfb221
    AND sfb05 = l_sfb.sfbud04 AND rownum = 1 

    LET l_json_data = cjc_addWorkTasksfb_data_json(l_data.*)

    LET l_sql = " SELECT * FROM sfa_file WHERE sfa01 = '",l_sfb.sfb01 CLIPPED,"'"
    DECLARE cs_get_sfb_cs CURSOR FROM l_sql

    INITIALIZE l_detail TO NULL
    INITIALIZE l_sfa TO NULL
    FOREACH cs_get_sfb_cs INTO l_sfa.*
            LET l_detail.workCode                                 = l_sfa.sfa01      #工单编号
            LET l_detail.jobCode                                  = l_sfa.sfa08      #作业编号
            LET l_detail.materialCode                             = l_sfa.sfa03      #料号
            SELECT ima02,ima021 INTO l_ima02,l_ima021  FROM ima_file WHERE ima01= l_sfa.sfa03
            select replace(l_ima02,'\\','\\\\'),replace(l_ima021,'\\','\\\\') into l_ima02,l_ima021 from dual 
            select replace(l_ima02,'"','\\\"'),replace(l_ima021,'"','\\\"') into l_ima02,l_ima021 from dual
            select replace(l_ima02,'    ',''),replace(l_ima021,'    ','') into l_ima02,l_ima021 from dual
            select replace(l_ima02,chr(10),''),replace(l_ima021,chr(10),'') into l_ima02,l_ima021 from dual
            LET l_detail.materialName                             = l_ima02        #品名
            LET l_detail.spec                                     = ''#l_ima021       #规格
            LET l_detail.unit                                     = l_sfa.sfa12       #单位
            LET l_detail.actualQpa                                = l_sfa.sfa161      #实际QPA
            LET l_detail.errorRate                                = l_sfa.sfa100      #误差率
            LET l_detail.needAmount                               = l_sfa.sfa05      #应发量
            LET l_detail.flag                                     = l_sfa.sfa11      #来源特性（N一般料件 E消耗性料件，消耗性料件不必捡料，一般由调拨到线边仓，属于倒扣料。V大宗采购料件 U大宗自制料件 R在制料件 X资讯参考 S回收料 C客供料）
           # LET l_detail.jobCode                                  = l_sfa.sfa08       #作业编号
           # LET l_datail.actualQpa                                = l_sfa.sfa161      #实际QPA  
          # IF l_detail.actualQpa = 0  THEN   #l_sfa.sfa11 <> 'N' OR 
          #     CONTINUE FOREACH 
          # END IF 
          LET l_json_detail = cjc_addWorkTasksfa_detail_json(l_detail.*)

          IF cl_null(l_json_str1) THEN
               LET l_json_str1 = "{",l_json_detail.trim(),"}"
          ELSE
               LET l_json_str1 = l_json_str1.trim(),",{",l_json_detail.trim(),"}"
          END IF
    END FOREACH

    IF l_ret.success = 'N' THEN
        RETURN l_ret.*
    END IF
    LET  l_sfb.sfb93 = 'Y' 
    IF l_sfb.sfb93 = 'Y' THEN 
        LET l_sql = "SELECT * FROM ecm_file WHERE ecm01 = '",l_sfb.sfb01 CLIPPED,"' "
        DECLARE cs_get_ecm_cs CURSOR FROM l_sql

        INITIALIZE l_ecm TO NULL
        INITIALIZE l_detail2 TO NULL
        FOREACH cs_get_ecm_cs INTO l_ecm.*
            LET l_detail2.processNo       = l_ecm.ecm03     #工艺序号
            LET l_detail2.processCode     = l_ecm.ecm11     #工艺编号
            LET l_detail2.productCode     = l_ecm.ecm03_par #产品编号
            LET l_detail2.jobCode         = l_ecm.ecm04     #作业编号
            LET l_detail2.workstationCode = l_ecm.ecm06     #工作站编号
            LET l_detail2.groupCode       = g_plant         #营运中心plant
            LET l_detail2.workNo          = l_ecm.ecm01     #工单编号，类型：varchar
            LET l_detail2.materialCode    = l_ecm.ecm03_par #料件编号 -- 产品编号
            LET l_detail2.machineCode     = l_ecm.ecm05     #机器编号
            LET l_detail2.wastage         = l_ecm.ecm12     #固定损耗率
            LET l_detail2.startTime       = l_ecm.ecm25     #开工时间
            LET l_detail2.endTime         = l_ecm.ecm26     #完工时间
            LET l_detail2.goodIn          = l_ecm.ecm301    #良品转入量
            LET l_detail2.reworkIn        = l_ecm.ecm302    #返工转入量
            LET l_detail2.workIn          = l_ecm.ecm303    #工单转入量
            LET l_detail2.goodOut         = l_ecm.ecm311    #良品转出量
            LET l_detail2.reworkOut       = l_ecm.ecm312    #返工转出量
            LET l_detail2.scrap           = l_ecm.ecm313    #当站报废量
            LET l_detail2.offlines        = l_ecm.ecm314    #当站下线量
            LET l_detail2.bonusQty        = l_ecm.ecm315    #Bonus Qty
            LET l_detail2.workOut         = l_ecm.ecm316    #工单转出量
            LET l_detail2.ifOutsource     = l_ecm.ecm52     #委外否
            LET l_detail2.processed       = l_ecm.ecm321    #委外加工量
            LET l_detail2.finished        = l_ecm.ecm322    #委外完工量
            LET l_detail2.lossRate        = l_ecm.ecm34     #变动损耗率
           #LET l_detail2.beforePsCode    = l_ecm.ecm011    #上工艺段号
           #LET l_detail2.ps_code         = l_ecm.ecm012    #工艺段号
           #LET l_detail2.ifReport        = l_ecm.ecm66     #报工点否
           #LET l_detail2.outsourceSup    = l_ecm.ecm67     #委外厂商
           #LET l_detail2.psDesc          = l_ecm.ecm014    #工艺段说明
           #LET l_detail2.nextPsCode      = l_ecm.ecm015    #下工艺段号
           #LET l_detail2.attr1           = l_ecm.ecm
           #LET l_detail2.attr2           = l_ecm.ecm
           #LET l_detail2.attr3           = l_ecm.ecm
           #LET l_detail2.attr4           = l_ecm.ecm
           #LET l_detail2.attr5           = l_ecm.ecm
           #LET l_detail2.attr6           = l_ecm.ecm
           #LET l_detail2.attr7           = l_ecm.ecm
           #LET l_detail2.attr8           = l_ecm.ecm
           #LET l_detail2.attr9           = l_ecm.ecm
           #LET l_detail2.attr10          = l_ecm.ecm

            #作业名称
            SELECT ecd02 INTO l_detail2.jobName FROM ecd_file
             WHERE ecd01 = l_detail2.jobCode
            IF SQLCA.SQLCODE THEN
                LET l_detail2.jobName = ''
            END IF

            #工作站名称
            SELECT eca02 INTO l_detail2.workstationName FROM eca_file
             WHERE eca01 = l_detail2.machineCode
            IF SQLCA.SQLCODE THEN
                LET l_detail2.workstationName = ''
            END IF

            #LET l_json_detail2 = cjc_addWorkTask_detail2_json(l_detail2.*)

            IF cl_null(l_json_str2) THEN
                LET l_json_str2 = "{",l_json_detail2.trim(),"}"
            ELSE
                LET l_json_str2 = l_json_str2.trim(),",{",l_json_detail2.trim(),"}"
          END IF

        END FOREACH
    END IF

   #LET l_json_str = "{",l_json_data,'"details"',":[",l_json_str1.trim(),"],",'"details2"',":[",l_json_str2.trim(),"]}"
   # IF NOT cl_null(l_json_str2) THEN 
     #   LET l_json_str = "{",l_json_data,',"materialList"',":[",l_json_str1.trim(),"],",'"details2"',":[",l_json_str2.trim(),"]}"
   # ELSE 
     #   LET l_json_str1 = cl_replace_str(l_json_str1," ","")
        LET l_json_str = "{",l_json_data,',"materialList"',":[",l_json_str1.trim(),"]}"
   # END IF 

    LET l_ret.msg = l_json_str
   # DISPLAY  l_json_str
    DISPLAY "-------------------------json-------proWorkTaskReceive--------"
    DISPLAY l_json_str
    DISPLAY "--------------------------------------------------"

    INITIALIZE l_returnstatus TO NULL
    INITIALIZE l_returnmsg TO NULL
    CALL proWorkTaskReceive(l_json_str) RETURNING l_returnstatus,l_returnmsg

    LET g_jsonstr = l_json_str
    LET g_returnstr = l_returnmsg
    IF l_returnstatus = '0' AND l_returnmsg = 'OK' THEN 
    	LET l_ret.success = 'Y' 
    	ELSE 
    	LET l_ret.success = 'N' 
    END IF 
    SELECT COUNT(*) INTO l_cnt FROM tc_zmxlog_file WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'proWorkTaskReceive' AND tc_zmxlog05 = p_sfb01 AND tc_zmxlog07 = '099'
    IF l_cnt = 0 OR cl_null(l_cnt) THEN 
      INSERT INTO tc_zmxlog_file values(g_plant,'proWorkTaskReceive',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),g_user,p_sfb01,g_jsonstr,'099',l_ret.success,g_returnstr,1,sysdate)
      ELSE 
      UPDATE tc_zmxlog_file SET tc_zmxlog03 = decode(tc_zmxlog08,'Y',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),tc_zmxlog03),
                                tc_zmxlog04 = decode(tc_zmxlog08,'Y',g_user,tc_zmxlog04),
                                tc_zmxlog06 = g_jsonstr,tc_zmxlog08 = l_ret.success,tc_zmxlog09 = g_returnstr,
                                tc_zmxlog10 = decode(tc_zmxlog08,'Y',1,tc_zmxlog10+1),tc_zmxlog11 = sysdate
      WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'proWorkTaskReceive' AND tc_zmxlog05 = p_sfb01 AND tc_zmxlog07 = '099'
    END IF 
    IF l_ret.success = 'Y' THEN
       #LET l_ret.success = 'Y'
       LET l_ret.msg = "工单(",l_sfb.sfb01 CLIPPED,")同步成功"
    ELSE
       #LET l_ret.success = 'N'
       LET l_ret.msg = l_returnmsg
    END IF

    RETURN l_ret.*

END FUNCTION



#工单结案
FUNCTION cs_sendSfb_status(p_sfb01)
DEFINE p_sfb01    LIKE sfb_file.sfb01
DEFINE l_status   LIKE sfb_file.sfb28 
DEFINE l_sfb28    LIKE sfb_file.sfb28 
DEFINE l_sfb04    LIKE sfb_file.sfb04
DEFINE l_data           RECORD
            code        LIKE type_file.chr100,
            _status     LIKE type_file.chr100,
            groupIdCode            LIKE type_file.chr100
                        END RECORD
DEFINE l_ret            RECORD
          success       LIKE type_file.chr1,
          code          LIKE type_file.chr10,
          msg           STRING
                        END RECORD
DEFINE l_json_str       STRING
DEFINE l_json_data      STRING
DEFINE l_sql            STRING
DEFINE l_cnt            LIKE type_file.num10
DEFINE l_return_status   LIKE type_file.num5
DEFINE l_returnmsg      String

SELECT sfb28,sfb04 into l_sfb28,l_sfb04 from sfb_file where sfb01=p_sfb01 
if status then
        LET l_ret.success = 'N'
        LET l_ret.msg = "无此工单编号"
        RETURN l_ret.*
end if

IF l_sfb28 = '1' OR l_sfb28='2' OR l_sfb04='8' OR l_sfb28='3' THEN 
   LET l_status = '8'
ELSE 
   LET l_status = l_sfb04
END IF 
 

INITIALIZE l_json_str TO NULL
INITIALIZE l_json_data TO NULL
INITIALIZE l_data TO NULL
LET l_data.code = p_sfb01
LET l_data._status = l_status
LET l_data.groupIdCode  = g_plant 
LET l_json_data = cs_sendSfb_status_data_json(l_data.*)

LET l_json_str = "{",l_json_data,"}"
DISPLAY "-------------------------json------workTaskClose--------------"
DISPLAY l_json_str
DISPLAY "--------------------------------------------------"
LET l_ret.msg = l_json_str

    CALL workTaskClose(l_json_str) RETURNING l_return_status,l_returnmsg
    IF l_returnmsg = 'OK' THEN
       LET l_ret.success = 'Y'
       LET l_ret.msg = "工单(",p_sfb01 CLIPPED,")状态同步成功"
    ELSE
       LET l_ret.success = 'N'
       LET l_ret.msg = l_returnmsg
    END IF

    RETURN l_ret.*

END FUNCTION


#同步IQC结果 
FUNCTION cjc_zmx_json_qcs(p_doc,p_sn,p_flag)
    DEFINE p_doc   LIKE pmm_file.pmm01,
           p_sn     LIKE pmn_file.pmn02 ,
           p_flag   LIKE type_file.chr1 
    DEFINE l_json_str       STRING 
    DEFINE l_json_data      STRING 
    DEFINE l_json_detail     STRING  
    DEFINE l_sql            STRING 
    DEFINE l_cnt            LIKE type_file.num10
    DEFINE l_returnstatus   LIKE type_file.num5
    DEFINE l_returnmsg      STRING
    DEFINE l_pmn      RECORD LIKE pmn_file.* 
    DEFINE l_qcs      RECORD LIKE qcs_file.*
    DEFINE l_rvb07          LIKE rvb_file.rvb07 
    DEFINE l_detail           RECORD
																	sourceCode   LIKE type_file.chr100,     #SCM收货单
																	code   LIKE type_file.chr100,           #ERP收货单
																	serialNum   LIKE type_file.chr100,      #项次
																	checkNum   LIKE type_file.chr100,       #检验结果
																	qualifiedNum   LIKE type_file.chr100,    #合格量
																	returnNum   LIKE type_file.chr100,       #不合格量
																	groupIdCode   LIKE type_file.chr100      #营运中心
                            END RECORD
    DEFINE l_ret            RECORD 
                 success    LIKE type_file.chr1,
                 code       LIKE type_file.chr10,
                 msg        STRING 
                 END RECORD 
        INITIALIZE l_detail TO NULL
        INITIALIZE l_qcs TO NULL 
        INITIALIZE l_json_str TO NULL 
        INITIALIZE l_json_data TO NULL 
        LET l_cnt = 0 

        IF cl_null(p_flag) THEN LET p_flag = 'Y' END IF 
        IF cl_null(p_doc) THEN 
                LET l_ret.msg = p_doc clipped,"ERP收货单号为空,请检查！"
                LET l_ret.success = 'N'
                RETURN l_ret.*
        END IF 
        SELECT * INTO l_qcs.* FROM qcs_file WHERE qcs01 = p_doc AND qcs02=p_sn AND rownum =1 
        IF STATUS THEN
        	      LET l_ret.msg = "抓取检验单信息失败，请检查！"
                LET l_ret.success = 'N'
                RETURN l_ret.*
        END IF 
        SELECT rvaud04 INTO l_detail.code FROM rva_file WHERE rva01 = p_doc
        IF cl_null(l_detail.code) THEN 
                LET l_ret.msg = "ERP收货单",p_doc clipped,"对应的SCM收货单不存在,请检查是否是来自SCM的收货！"
                LET l_ret.success = 'Y'
                RETURN l_ret.*
        END IF 
       # IF l_qcs.qcs14 <>'Y' AND p_flag = 'Y' THEN 
       #         LET l_ret.msg = "检验单",l_qcs.qcs01 clipped,"-",l_qcs.qcs02 CLIPPED,"未审核，请检查！"
       #         LET l_ret.success = 'N'
       #         RETURN l_ret.*
       # END IF 
        
        LET l_detail.sourceCode        =   l_qcs.qcs01
        LET l_detail.serialNum   =   l_qcs.qcs02
        LET l_detail.checkNum    =   l_qcs.qcs09  
        #IF  p_flag = 'N' THEN      #取消审核
        #    LET l_detail.qualifiedNum  =   0
        #    LET l_detail.returnNum =   0
        #ELSE 
        #   LET l_detail.qualifiedNum  =   l_qcs.qcs091
        #    LET l_detail.returnNum =   l_qcs.qcs22 - l_qcs.qcs091
        #END IF 
        SELECT nvl(sum(nvl(qcs091,0)),0),nvl(sum(qcs22 - qcs091),0) INTO l_detail.qualifiedNum,l_detail.returnNum FROM qcs_file 
        WHERE qcs01=l_qcs.qcs01 AND qcs02 = l_qcs.qcs02 AND qcs14 = 'Y'
        IF cl_null(l_detail.qualifiedNum) THEN LET l_detail.qualifiedNum = 0 END IF 
        IF cl_null(l_detail.returnNum) THEN LET l_detail.returnNum = 0 END IF 
        LET l_detail.groupIdCode =   g_plant

        
        LET l_json_data = cjc_getqcs_data_json(l_detail.*)
        LET l_json_str = "{",l_json_data,"}"
        LET l_ret.msg = l_json_str
        DISPLAY "-------------------------json-------purUpReceive------------"
        DISPLAY l_json_str
        DISPLAY "--------------------------------------------------"
        INITIALIZE l_returnstatus TO NULL 
        INITIALIZE l_returnmsg TO NULL
        CALL purUpReceive(l_json_str) RETURNING l_returnstatus,l_returnmsg
        LET g_jsonstr = l_json_str
        LET g_returnstr = l_returnmsg
        IF l_returnstatus = '0' AND l_returnmsg = 'OK' THEN 
        	LET l_ret.success = 'Y' 
        	ELSE 
        	LET l_ret.success = 'N' 
        END IF 
        SELECT COUNT(*) INTO l_cnt FROM tc_zmxlog_file WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'purUpReceive' AND tc_zmxlog05 = p_doc||'/'||p_sn   #AND tc_zmxlog07 = '02'
        IF l_cnt = 0 OR cl_null(l_cnt) THEN 
          INSERT INTO tc_zmxlog_file values(g_plant,'purUpReceive',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),g_user,p_doc||'/'||p_sn,g_jsonstr,'',l_ret.success,g_returnstr,1,sysdate)
          ELSE 
          UPDATE tc_zmxlog_file SET tc_zmxlog03 = decode(tc_zmxlog08,'Y',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),tc_zmxlog03),
                                    tc_zmxlog04 = decode(tc_zmxlog08,'Y',g_user,tc_zmxlog04),
                                    tc_zmxlog06 = g_jsonstr,tc_zmxlog08 = l_ret.success,tc_zmxlog09 = g_returnstr,
                                    tc_zmxlog10 = decode(tc_zmxlog08,'Y',1,tc_zmxlog10+1),tc_zmxlog11 = sysdate
          WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'purUpReceive' AND tc_zmxlog05 = p_doc||'/'||p_sn   #AND tc_zmxlog07 = '02'
        END IF 
        IF l_ret.success = 'Y' THEN
           #LET l_ret.success = 'Y'
           LET l_ret.msg = "收货单(",p_doc CLIPPED,"SCM收货单",l_detail.sourceCode CLIPPED,"项次",p_sn CLIPPED,")检验数据同步成功"
        ELSE
           #LET l_ret.success = 'N'
           LET l_ret.msg = l_returnmsg
        END IF

        RETURN l_ret.*
END FUNCTION 


#同步仓退数据结果 
FUNCTION cjc_zmx_json_back(p_doc,p_sn)
    DEFINE p_doc   LIKE pmm_file.pmm01,
           p_sn     LIKE pmn_file.pmn02 ,
           p_flag   LIKE type_file.chr1 
    DEFINE l_json_str       STRING 
    DEFINE l_json_data      STRING 
    DEFINE l_json_detail     STRING  
    DEFINE l_sql            STRING 
    DEFINE l_cnt            LIKE type_file.num10
    DEFINE l_returnstatus   LIKE type_file.num5
    DEFINE l_returnmsg      STRING
    DEFINE l_pmn      RECORD LIKE pmn_file.* 
    DEFINE l_rvv      RECORD LIKE rvv_file.*
    DEFINE l_detail           RECORD
																	code   LIKE type_file.chr100,           #ERP采购单
																	serialNum   LIKE type_file.chr100,      #项次
																	halfwayNum   LIKE type_file.chr100,       #仓退量
																	groupIdCode   LIKE type_file.chr100      #营运中心
                            END RECORD
    DEFINE l_ret            RECORD 
                 success    LIKE type_file.chr1,
                 code       LIKE type_file.chr10,
                 msg        STRING 
                 END RECORD 
        INITIALIZE l_detail TO NULL
        INITIALIZE l_rvv TO NULL 
        INITIALIZE l_json_str TO NULL 
        INITIALIZE l_json_data TO NULL 
        LET l_cnt = 0 

        IF cl_null(p_doc) THEN 
                LET l_ret.msg = p_doc clipped,"ERP采购单号为空,请检查！"
                LET l_ret.success = 'N'
                RETURN l_ret.*
        END IF 
        IF cl_null(p_sn) THEN 
                LET l_ret.msg = p_sn clipped,"ERP采购单项次为空,请检查！"
                LET l_ret.success = 'N'
                RETURN l_ret.*
        END IF 
        SELECT count(*) INTO l_cnt FROM pmn_file WHERE pmn01= p_doc AND pmn02=p_sn
        IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
        IF l_cnt = 0 THEN 
                LET l_ret.msg = p_doc clipped,"-",p_sn CLIPPED ,"ERP采购单，项次不存在,请检查！"
                LET l_ret.success = 'N'
                RETURN l_ret.*
        END IF 
       
        
        SELECT sum(nvl(rvv17,0)) INTO l_detail.halfwayNum FROM rvv_file,rvu_file WHERE rvu01= rvv01 AND rvu00 = '3' AND rvu116 = '2' AND rvuconf='Y'
        AND rvv36 = p_doc AND rvv37 = p_sn  
        IF g_action_choice = 'undo_confirm' THEN   #取消审核时，仓退量为0 
          LET  l_detail.halfwayNum = 0 
        END IF 

        IF cl_null(l_detail.halfwayNum) THEN LET l_detail.halfwayNum = 0 END IF 
        LET l_detail.code        =   p_doc
        LET l_detail.serialNum   =   p_sn 
        LET l_detail.groupIdCode =   g_plant
        LET l_json_data = cjc_getback_data_json(l_detail.*)
        LET l_json_str = "{",l_json_data,"}"
        LET l_ret.msg = l_json_str
        DISPLAY "-------------------------json-------purUpBack------------"
        DISPLAY l_json_str
        DISPLAY "--------------------------------------------------"
        INITIALIZE l_returnstatus TO NULL 
        INITIALIZE l_returnmsg TO NULL
        CALL purUpBack(l_json_str) RETURNING l_returnstatus,l_returnmsg
        LET g_jsonstr = l_json_str
        LET g_returnstr = l_returnmsg
        IF l_returnstatus = '0' AND l_returnmsg = 'OK' THEN 
        	LET l_ret.success = 'Y' 
        	ELSE 
        	LET l_ret.success = 'N' 
        END IF 
        SELECT COUNT(*) INTO l_cnt FROM tc_zmxlog_file WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'purUpBack' AND tc_zmxlog05 = p_doc||'/'||p_sn     #AND tc_zmxlog07 = '02'
        IF l_cnt = 0 OR cl_null(l_cnt) THEN 
          INSERT INTO tc_zmxlog_file values(g_plant,'purUpBack',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),g_user,p_doc||'/'||p_sn,g_jsonstr,'',l_ret.success,g_returnstr,1,sysdate)
        ELSE 
          UPDATE tc_zmxlog_file SET tc_zmxlog03 = decode(tc_zmxlog08,'Y',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),tc_zmxlog03),
                                    tc_zmxlog04 = decode(tc_zmxlog08,'Y',g_user,tc_zmxlog04),
                                    tc_zmxlog06 = g_jsonstr,tc_zmxlog08 = l_ret.success,tc_zmxlog09 = g_returnstr,
                                    tc_zmxlog10 = decode(tc_zmxlog08,'Y',1,tc_zmxlog10+1),tc_zmxlog11 = sysdate
          WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'purUpBack' AND tc_zmxlog05 = p_doc||'/'||p_sn   #AND tc_zmxlog07 = '02'
        END IF 
        #INSERT INTO tc_zmxlog_file values(g_plant,'purUpBack',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),g_user,'',g_jsonstr,'ERP->SCM',l_ret.success,g_returnstr,1,sysdate)
        IF l_ret.success = 'Y' THEN
           #LET l_ret.success = 'Y'
           LET l_ret.msg = "采购单",p_doc CLIPPED,"项次",p_sn CLIPPED,")仓退数据同步成功"
        ELSE
           #LET l_ret.success = 'N'
           LET l_ret.msg = l_returnmsg
        END IF

        RETURN l_ret.*
END FUNCTION 




#任务单撤销  工单发料\出货通知单\工单\仓退\销退
FUNCTION cjc_zmx_json_cancelWorktask(p_doc,p_type)
DEFINE p_doc           LIKE type_file.chr50
DEFINE p_type          LIKE type_file.chr50
DEFINE l_data           RECORD
							          groupIdCode   LIKE type_file.chr100,
							          code          LIKE type_file.chr100,
							          docTypeIdCode     LIKE type_file.chr100
                        END RECORD 
DEFINE l_ret            RECORD
          success       LIKE type_file.chr1,
          code          LIKE type_file.chr10,
          msg           STRING
                        END RECORD
DEFINE l_json_str       STRING
DEFINE l_json_data      STRING
DEFINE l_sql            STRING
DEFINE l_cnt            LIKE type_file.num10
DEFINE l_returnstatus   LIKE type_file.num5
DEFINE l_returnmsg      String
#DEFINE l_tc_sft           RECORD LIKE tc_sft_file.*
DEFINE l_oga            RECORD LIKE oga_file.*
DEFINE l_sfp            RECORD LIKE sfp_file.* 
DEFINE l_sfb            RECORD LIKE sfb_file.*
DEFINE l_oha            RECORD LIKE oha_file.*
DEFINE l_rvu            RECORD LIKE rvu_file.* 
DEFINE l_tc_sfd            RECORD LIKE tc_sfd_file.* 

    INITIALIZE l_ret TO NULL
    LET l_ret.success = 'Y'

    IF cl_null(p_type) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "无任务单类型"
        RETURN l_ret.*
    END IF 

    IF cl_null(p_doc) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "无任务单号"
        RETURN l_ret.*
    END IF 

    INITIALIZE l_data TO NULL
    INITIALIZE l_json_str TO NULL
    INITIALIZE l_json_data TO NULL
    #工单 
    IF  p_type = 'WT' THEN
        SELECT * INTO l_sfb.* FROM sfb_file
         WHERE sfb01 = p_doc
        IF SQLCA.SQLCODE THEN
            LET l_ret.success = 'N'
            LET l_ret.msg = "获取工单(",p_doc CLIPPED,")失败,SQLERR:",SQLCA.SQLCODE USING '-----'
            LET l_ret.code = SQLCA.SQLCODE = '-----'
            RETURN l_ret.*
        END IF


        INITIALIZE l_data TO NULL
        LET l_data.code  = l_sfb.sfb01       #工单号     
        LET l_data.docTypeIdCode= 'WT'        #单据类型
        LET l_data.groupIdCode = g_plant     #营运中心
    END IF
    #出货通知单
    IF p_type = 'DO2' OR p_type = 'DO3' THEN   #出货通知单
        SELECT * INTO l_oga.* FROM oga_file
         WHERE oga01 = p_doc
        IF SQLCA.SQLCODE THEN
            LET l_ret.success = 'N'
            LET l_ret.msg = "获取出货通知单(",p_doc CLIPPED,")失败,SQLERR:",SQLCA.SQLCODE USING '-----'
            LET l_ret.code = SQLCA.SQLCODE = '-----'
            RETURN l_ret.*
        END IF

        INITIALIZE l_data TO NULL
        LET l_data.code  = l_oga.oga01      #申请单号      
        LET l_data.docTypeIdCode= 'DO2'        #单据类型
        LET l_data.groupIdCode = g_plant     #营运中心
    END IF 
    #销退单
    IF p_type = 'ST1' THEN   
        SELECT * INTO l_oha.* FROM oha_file
         WHERE oha01 = p_doc
        IF SQLCA.SQLCODE THEN
            LET l_ret.success = 'N'
            LET l_ret.msg = "获取销退单(",p_doc CLIPPED,")失败,SQLERR:",SQLCA.SQLCODE USING '-----'
            LET l_ret.code = SQLCA.SQLCODE = '-----'
            RETURN l_ret.*
        END IF

        INITIALIZE l_data TO NULL
        LET l_data.code  = l_oha.oha01      #申请单号      
        LET l_data.docTypeIdCode= 'ST1'        #单据类型
        LET l_data.groupIdCode = g_plant     #营运中心
    END IF 
    #仓退单
    IF p_type = 'PT1' THEN   
        SELECT * INTO l_rvu.* FROM rvu_file
         WHERE rvu01 = p_doc
        IF SQLCA.SQLCODE THEN
            LET l_ret.success = 'N'
            LET l_ret.msg = "获取仓退单(",p_doc CLIPPED,")失败,SQLERR:",SQLCA.SQLCODE USING '-----'
            LET l_ret.code = SQLCA.SQLCODE = '-----'
            RETURN l_ret.*
        END IF

        INITIALIZE l_data TO NULL
        LET l_data.code  = l_rvu.rvu01      #申请单号      
        LET l_data.docTypeIdCode= 'PT1'        #单据类型
        LET l_data.groupIdCode = g_plant     #营运中心
    END IF 
    #倒扣单
    IF p_type = 'DK1' OR p_type = 'OR1' THEN   
        SELECT * INTO l_sfp.* FROM sfp_file
         WHERE sfp01 = p_doc
        IF SQLCA.SQLCODE THEN
            LET l_ret.success = 'N'
            IF p_type = 'DK1' THEN 
              LET l_ret.msg = "获取倒扣单(",p_doc CLIPPED,")失败,SQLERR:",SQLCA.SQLCODE USING '-----'
              ELSE 
              LET l_ret.msg = "获取退料单(",p_doc CLIPPED,")失败,SQLERR:",SQLCA.SQLCODE USING '-----'
            END IF 
            LET l_ret.code = SQLCA.SQLCODE = '-----'
            RETURN l_ret.*
        END IF

        INITIALIZE l_data TO NULL
        LET l_data.code  = l_sfp.sfp01      #申请单号      
        LET l_data.docTypeIdCode= p_type        #单据类型
        LET l_data.groupIdCode = g_plant     #营运中心
    END IF 

        #发料需求单
    IF p_type = 'MR1' THEN   
        SELECT * INTO l_tc_sfd.* FROM tc_sfd_file
         WHERE tc_sfd01 = p_doc
        IF SQLCA.SQLCODE THEN
            LET l_ret.success = 'N'
            LET l_ret.msg = "获取发料需求(",p_doc CLIPPED,")失败,SQLERR:",SQLCA.SQLCODE USING '-----'
            LET l_ret.code = SQLCA.SQLCODE = '-----'
            RETURN l_ret.*
        END IF

        INITIALIZE l_data TO NULL
        LET l_data.code  = l_tc_sfd.tc_sfd01      #申请单号      
        LET l_data.docTypeIdCode= 'MR1'        #单据类型
        LET l_data.groupIdCode = g_plant     #营运中心
    END IF 



    LET l_json_data = cjc_cancelworktask_data_json(l_data.*)

    LET l_json_str = "{",l_json_data,"}"

    LET l_ret.msg = l_json_str

    DISPLAY "-------------------------json---------taskSheetDel----------"
    DISPLAY l_json_str
    DISPLAY "--------------------------------------------------"
    
    INITIALIZE l_returnstatus TO NULL
    INITIALIZE l_returnmsg TO NULL
    CALL taskSheetDel(l_json_str) RETURNING l_returnstatus,l_returnmsg
    LET g_jsonstr = l_json_str
    LET g_returnstr = l_returnmsg
    IF l_returnstatus = '0' AND l_returnmsg = 'OK' THEN 
    	LET l_ret.success = 'Y' 
    	ELSE 
    	LET l_ret.success = 'N' 
    END IF 
    SELECT COUNT(*) INTO l_cnt FROM tc_zmxlog_file WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'taskSheetDel' AND tc_zmxlog05 = p_doc AND tc_zmxlog07 = p_type
    IF l_cnt = 0 OR cl_null(l_cnt) THEN 
      INSERT INTO tc_zmxlog_file values(g_plant,'taskSheetDel',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),g_user,p_doc,g_jsonstr,p_type,l_ret.success,g_returnstr,1,sysdate)
      ELSE 
      UPDATE tc_zmxlog_file SET tc_zmxlog03 = decode(tc_zmxlog08,'Y',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),tc_zmxlog03),
                                tc_zmxlog04 = decode(tc_zmxlog08,'Y',g_user,tc_zmxlog04),
                                tc_zmxlog06 = g_jsonstr,tc_zmxlog08 = l_ret.success,tc_zmxlog09 = g_returnstr,
                                tc_zmxlog10 = decode(tc_zmxlog08,'Y',1,tc_zmxlog10+1),tc_zmxlog11 = sysdate
      WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'taskSheetDel' AND tc_zmxlog05 = p_doc AND tc_zmxlog07 = p_type
    END IF 
    IF l_ret.success = 'Y' THEN
       #LET l_ret.success = 'Y'
       LET l_ret.msg = "(",p_doc CLIPPED,")撤销检查成功"
    ELSE
       #LET l_ret.success = 'N'
       LET l_ret.msg = l_returnmsg
    END IF

    RETURN l_ret.*

END FUNCTION


#任务单-同步
#传入:p_type p_doc         单据类型   单号
#返回:string        
FUNCTION cjc_zmx_json_task(p_type,p_doc)
DEFINE p_type           LIKE type_file.chr10 
DEFINE p_doc            LIKE pmm_file.pmm01
DEFINE l_ret            RECORD 
             success    LIKE type_file.chr1,
             code       LIKE type_file.chr10,
             msg        STRING 
                        END RECORD
DEFINE l_sfb            RECORD LIKE sfb_file.*
DEFINE l_sfp            RECORD LIKE sfp_file.*
DEFINE l_sfe            RECORD LIKE sfe_file.*
DEFINE l_sfa            RECORD LIKE sfa_file.*
DEFINE l_oga            RECORD LIKE oga_file.*
DEFINE l_ogb            RECORD LIKE ogb_file.*
DEFINE l_oha            RECORD LIKE oha_file.*
DEFINE l_ohb            RECORD LIKE ohb_file.*
DEFINE l_rvu            RECORD LIKE rvu_file.*
DEFINE l_rvv            RECORD LIKE rvv_file.*
DEFINE l_tc_sfd         RECORD LIKE tc_sfd_file.*
DEFINE l_tc_sff         RECORD LIKE tc_sff_file.*
DEFINE l_json_str       STRING 
DEFINE l_json_data      STRING 
DEFINE l_json_detail    STRING 
DEFINE l_sql            STRING 
DEFINE l_cnt            LIKE type_file.num10
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
                            outType                                  LIKE type_file.chr100         #出货单单别
                            
                        END RECORD
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
                            sourceSerNo                              LIKE type_file.chr100,     #来源项次
                            remarks                                  LIKE type_file.chr100,      #备注
                            jobName                                  LIKE type_file.chr100,       #作业编号
                            oemCode                                  LIKE type_file.chr100       #OEM编号
                        END RECORD
DEFINE l_ima02          LIKE ima_file.ima02 
DEFINE l_ima021         LIKE ima_file.ima021 
DEFINE l_returnstatus   LIKE type_file.num5
DEFINE l_returnmsg      STRING
DEFINE l_msg            LIKE type_file.chr1000 
DEFINE l_str_json       LIKE type_file.chr1000 

    #初始化
    INITIALIZE l_ret TO NULL
    INITIALIZE l_data TO NULL
    INITIALIZE l_detail TO NULL
    INITIALIZE l_json_str TO NULL 
    INITIALIZE l_json_data TO NULL 
    INITIALIZE l_json_detail TO NULL
    LET l_ret.success = 'Y'    


    IF cl_null(p_type) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "无任务单类型"
        RETURN l_ret.*
    END IF 

    IF cl_null(p_doc) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "无任务单号"
        RETURN l_ret.*
    END IF 
    #
    #出货通知单  --- begin------ 
    IF p_type = 'DO2' OR p_type = 'DO3' THEN   
    #过滤条件
        LET l_ret.success = 'Y'

        SELECT COUNT(1) INTO l_cnt FROM oga_file
        WHERE oga01 =  p_doc
        IF cl_null(l_cnt) THEN
            LET l_cnt = 0
        END IF
        IF l_cnt = 0 THEN
            LET l_ret.msg = "出货通知单(",p_doc CLIPPED,")未匹配"
            LET l_ret.success = 'N'
            RETURN l_ret.*
        END IF
        SELECT * INTO l_oga.* FROM oga_file
        WHERE oga01 = p_doc
        IF SQLCA.SQLCODE THEN
            LET l_ret.success = 'N'
            LET l_ret.msg = "获取出货通知单(",p_doc CLIPPED,")失败,SQLERR:",SQLCA.SQLCODE USING '-----'
            LET l_ret.code = SQLCA.SQLCODE = '-----'
            RETURN l_ret.*
        END IF

        IF l_oga.oga09 <> '1' THEN
            LET l_ret.success = 'N'
            LET l_ret.msg = '非出货通知单，请检查'
            RETURN l_ret.*
        END IF

        IF l_oga.ogaconf <> 'Y' THEN
            LET l_ret.success = 'N'
            LET l_ret.msg = '出货通知单未审核'
            RETURN l_ret.*
        END IF



        #获取任务相关资料-单头
        INITIALIZE l_data TO NULL
        LET l_data.corporationIdCode                        = g_plant 
        #LET l_data.createdOn                                = l_oga.oga      #创建时间
        LET l_data.createdByCode                            = l_oga.ogauser      #创建人
        LET l_data.code                                     = l_oga.oga01      #创建人
        LET l_data.groupIdCode                              = g_plant            #营运中心id
        LET l_data.docTypeIdCode                            = 'DO2'              #单据类型(例如:送货单/收货单...)
        LET l_data.docDate                                  = l_oga.oga69 USING 'yyyy/mm/dd'        #单据日期
        LET l_data.applicantIdCode                          = l_oga.oga14        #申请人ID(取值来源,STAFF[员工表])
        LET l_data.applicantDepartmentIdCode                = l_oga.oga15        #申请部门(取值来源,DEPARTMENT[部门表])
        LET l_data.remarks                                  = ''      #备注
        LET l_data.sourceCode                               = l_oga.oga01      #来源编码
        LET l_data.customerType                             = 'CUSTOMER'      #客商类型
        LET l_data.customerCustomerCode                     = l_oga.oga04      #客户
        LET l_data.currencyIdCode                           = l_oga.oga23      #币种
        LET l_data.taxIdCode                                = l_oga.oga21      #税种
        LET l_data.outType                                  = 'XRD'
        SELECT COUNT(*) INTO l_cnt FROM ogb_file WHERE ogb01 = l_oga.oga01 AND ogb09 = 'WP003' 
        IF cl_null(l_cnt) THEN LET l_cnt = 0  END IF 
        IF l_cnt > 0 THEN 
             LET l_data.outType                                  = 'XRC'
        END IF 
        LET l_json_data = cjc_addWorktask_data_json(l_data.*)
        #获取任务相关资料-单身
        LET l_sql = " SELECT * FROM ogb_file WHERE ogb01 = '",l_oga.oga01 CLIPPED,"'"
        DECLARE cs_get_oga_cs CURSOR FROM l_sql
        INITIALIZE l_detail TO NULL
        INITIALIZE l_ogb TO NULL
        FOREACH cs_get_oga_cs INTO l_ogb.*
                INITIALIZE l_ima02,l_ima021 TO null 
                LET l_detail.groupIdCode                              = g_plant        #营运中心id
                LET l_detail.serialNumber                             = l_ogb.ogb03      #序号
                LET l_detail.materialCode                             = l_ogb.ogb04      #物料编码
                select ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file WHERE ima01=l_ogb.ogb04 
                select replace(l_ima02,'\\','\\\\'),replace(l_ima021,'\\','\\\\') into l_ima02,l_ima021 from dual 
                select replace(l_ima02,'"','\\\"'),replace(l_ima021,'"','\\\"') into l_ima02,l_ima021 from dual
                select replace(l_ima02,'    ',''),replace(l_ima021,'    ','') into l_ima02,l_ima021 from dual
                select replace(l_ima02,chr(10),''),replace(l_ima021,chr(10),'') into l_ima02,l_ima021 from dual
                LET l_detail.materialName                             = l_ima02        #物料名称
                LET l_detail.spec                                     = l_ima021       #规格
                LET l_detail.unitIdCode                               = l_ogb.ogb05    #申请单位ID(取值来源,UNIT[单位表])
                LET l_detail.num                                      = l_ogb.ogb12    #申请数量
                LET l_detail.warehouseIdCode                          = l_ogb.ogb09    #申请仓库ID(取值来源,WAREHOUSE[仓库表])
                LET l_detail.cargoLocationIdCode                      = l_ogb.ogb091    #货位ID(取值来源CARGO_LOCATION[货位表])
                LET l_detail.batchNo                                  = l_ogb.ogb092    #批号
                LET l_detail.sourceCode                               = l_ogb.ogb31    #来源编码-订单
                LET l_detail.sourceSerNo                              = l_ogb.ogb03      #来源项次  ---  通知单项次
                LET l_detail.remarks                                  = l_ogb.ogb1001    #备注


                SELECT oeb11 INTO  l_detail.oemCode FROM oeb_file WHERE oeb01=l_ogb.ogb31 
                AND oeb03=l_ogb.ogb32   
                #LET l_detail.oemCode                                 = ''
                LET l_json_detail = cjc_addWorktask_detail_json(l_detail.*)

                IF cl_null(l_json_str) THEN
                    LET l_json_str = "{",l_json_detail.trim(),"}"
                ELSE
                    LET l_json_str = l_json_str.trim(),",{",l_json_detail.trim(),"}"
                END IF
        END FOREACH
    END IF 
    #----end --- 
   #--发料需求--begin  --- 
    #根据类型获取明细值 
    #物料需求单
    IF p_type MATCHES 'MR1' THEN   
        #过滤条件
        LET l_ret.success = 'Y'

        SELECT COUNT(1) INTO l_cnt FROM tc_sfd_file
        WHERE tc_sfd01 =  p_doc
        IF cl_null(l_cnt) AND p_type MATCHES 'MR1'  THEN
            LET l_cnt = 0
        END IF
        IF l_cnt = 0 THEN
            LET l_ret.msg = "发料需求单(",p_doc CLIPPED,")未匹配"
            LET l_ret.success = 'N'
            RETURN l_ret.*
        END IF
        SELECT * INTO l_tc_sfd.* FROM tc_sfd_file
        WHERE tc_sfd01 = p_doc
        IF SQLCA.SQLCODE THEN
            LET l_ret.success = 'N'
            LET l_ret.msg = "获取发料单(",p_doc CLIPPED,")失败,SQLERR:",SQLCA.SQLCODE USING '-----'
            LET l_ret.code = SQLCA.SQLCODE = '-----'
            RETURN l_ret.*
        END IF

        #ADD BY shawn 2020022801  --- begin ---- 
        IF l_tc_sfd.tc_sfdud03 = 'Y' THEN 
            LET l_ret.success = 'N'
            LET l_ret.msg = '发料需求单已抛转，无需再次抛转'
            RETURN l_ret.*
        END IF 
        #---end ---- 

        IF l_tc_sfd.tc_sfd04 <> 'Y' THEN
            LET l_ret.success = 'N'
            LET l_ret.msg = '发料(退料)单未审核'
            RETURN l_ret.*
        END IF

       { IF l_tc_sfd.tc_sfd04 = 'Y' THEN
            LET l_ret.success = 'N'
            LET l_ret.msg = '发料(退料)单已转发料单'
            RETURN l_ret.*
        END IF}

        #获取任务相关资料-单头
        INITIALIZE l_data TO NULL
        #LET l_data.createdOn                                = l_tc_sfd.tc_sfd02  USING 'yyyy/mm/dd'     #创建时间
        LET l_data.corporationIdCode                        = g_plant 
        LET l_data.createdByCode                            = l_tc_sfd.tc_sfduser      #创建人
        LET l_data.code                                     = l_tc_sfd.tc_sfd01        #单号
        LET l_data.groupIdCode                              = g_plant                  #营运中心id
        LET l_data.docTypeIdCode                            = 'MR1'                    #单据类型(例如:送货单/收货单...)
        LET l_data.docDate                                  = l_tc_sfd.tc_sfd02 USING 'yyyy/mm/dd'        #单据日期
        LET l_data.applicantIdCode                          = l_tc_sfd.tc_sfdud02        #申请人ID(取值来源,STAFF[员工表])
        LET l_data.applicantDepartmentIdCode                = l_tc_sfd.tc_sfd06        #申请部门(取值来源,DEPARTMENT[部门表])
        LET l_data.remarks                                  = l_tc_sfd.tc_sfdud01      #备注
        LET l_data.sourceCode                               = l_tc_sfd.tc_sfd01      #来源编码
        LET l_data.issue_number                             = l_tc_sfd.tc_sfd07      #发料序号
        LET l_json_data = cjc_addWorktask_data_json(l_data.*)
        #获取任务相关资料-单身
        LET l_sql = " SELECT * FROM tc_sff_file WHERE tc_sff01 = '",l_tc_sfd.tc_sfd01 CLIPPED,"'"
        DECLARE cs_get_tc_sfd_cs CURSOR FROM l_sql
        INITIALIZE l_detail TO NULL
        INITIALIZE l_tc_sff TO NULL
        FOREACH cs_get_tc_sfd_cs INTO l_tc_sff.*
                INITIALIZE l_ima02,l_ima021 TO null 
                LET l_detail.groupIdCode                              = g_plant                #营运中心id
                LET l_detail.serialNumber                             = l_tc_sff.tc_sff02      #序号
                LET l_detail.materialCode                             = l_tc_sff.tc_sff04      #物料编码
                select ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file WHERE ima01=l_tc_sff.tc_sff04 
                select replace(l_ima02,'\\','\\\\'),replace(l_ima021,'\\','\\\\') into l_ima02,l_ima021 from dual 
                select replace(l_ima02,'"','\\\"'),replace(l_ima021,'"','\\\"') into l_ima02,l_ima021 from dual
                select replace(l_ima02,'    ',''),replace(l_ima021,'    ','') into l_ima02,l_ima021 from dual
                select replace(l_ima02,chr(10),''),replace(l_ima021,chr(10),'') into l_ima02,l_ima021 from dual
                LET l_detail.materialName                             = l_ima02        #物料名称
                LET l_detail.spec                                     = l_ima021       #规格
                LET l_detail.unitIdCode                               = l_tc_sff.tc_sff06    #申请单位ID(取值来源,UNIT[单位表])
                LET l_detail.num                                      = l_tc_sff.tc_sff05    #申请数量
                LET l_detail.warehouseIdCode                          = ''    #申请仓库ID(取值来源,WAREHOUSE[仓库表])
                LET l_detail.cargoLocationIdCode                      = ''    #货位ID(取值来源CARGO_LOCATION[货位表])
                LET l_detail.batchNo                                  = ''    #批号
                LET l_detail.sourceCode                               = l_tc_sff.tc_sff03    #来源编码-工单
                #LET l_detail.sourceSerNo                             = l_tc_sff.tc_sff      #来源项次
                LET l_detail.remarks                                  = l_tc_sff.tc_sff08    #备注
                LET l_detail.jobName                                  = l_tc_sff.tc_sff07    #作业编号
                LET l_detail.oemCode                                  = ''
                
                LET l_json_detail = cjc_addWorktask_detail_json(l_detail.*)

                IF cl_null(l_json_str) THEN
                    LET l_json_str = "{",l_json_detail.trim(),"}"
                ELSE
                    LET l_json_str = l_json_str.trim(),",{",l_json_detail.trim(),"}"
                END IF
            END FOREACH

          #LET l_json_str = "{",l_json_data,',"sheetDList"',":[",l_json_str.trim(),"]}"

            #LET l_ret.msg = l_json_str
           # LET l_json_str = cl_replace_str(l_json_str," ","")
            #DISPLAY "-------------------------json---------taskSheetReceive-addWorkRequire------------"
           # DISPLAY l_json_str
           # DISPLAY "--------------------------------------------------"
    END IF 
    #--发料需求--end --- 
    #销退  ----- begin --------- 
    IF p_type = 'ST1' THEN   
    #过滤条件
        LET l_ret.success = 'Y'
        SELECT COUNT(1) INTO l_cnt FROM oha_file
        WHERE oha01 =  p_doc
        IF cl_null(l_cnt) THEN
            LET l_cnt = 0
        END IF
        IF l_cnt = 0 THEN
            LET l_ret.msg = "销退单(",p_doc CLIPPED,")未匹配"
            LET l_ret.success = 'N'
            RETURN l_ret.*
        END IF
        SELECT * INTO l_oha.* FROM oha_file
        WHERE oha01 = p_doc
        IF SQLCA.SQLCODE THEN
            LET l_ret.success = 'N'
            LET l_ret.msg = "获取销退单(",p_doc CLIPPED,")失败,SQLERR:",SQLCA.SQLCODE USING '-----'
            LET l_ret.code = SQLCA.SQLCODE = '-----'
            RETURN l_ret.*
        END IF

        IF l_oha.ohaconf <> 'Y' THEN
            LET l_ret.success = 'N'
            LET l_ret.msg = '销退单未审核'
            RETURN l_ret.*
        END IF

        IF l_oha.ohapost <> 'Y' THEN
            LET l_ret.success = 'N'
            LET l_ret.msg = '销退单未过账'
            RETURN l_ret.*
        END IF
        #获取任务相关资料-单头
        INITIALIZE l_data TO NULL
        LET l_data.corporationIdCode                        = g_plant 
        #LET l_data.createdOn                                = l_oha.oha      #创建时间
        LET l_data.createdByCode                            = l_oha.ohauser      #创建人
        LET l_data.code                                     = l_oha.oha01        #单号
        LET l_data.groupIdCode                              = g_plant            #营运中心id
        LET l_data.docTypeIdCode                            = 'ST1'              #单据类型(例如:送货单/收货单...)
        LET l_data.docDate                                  = l_oha.oha02 USING 'yyyy/mm/dd'        #单据日期
        LET l_data.applicantIdCode                          = l_oha.oha14        #申请人ID(取值来源,STAFF[员工表])
        LET l_data.applicantDepartmentIdCode                = l_oha.oha15        #申请部门(取值来源,DEPARTMENT[部门表])
        LET l_data.remarks                                  = l_oha.oha48     #备注
        LET l_data.sourceCode                               = l_oha.oha01      #来源编码
        LET l_data.customerType                             = 'CUSTOMER'      #客商类型
        LET l_data.customerCustomerCode                     = l_oha.oha03     #客户
        LET l_data.currencyIdCode                           = l_oha.oha23          #币种
        LET l_data.taxIdCode                                = l_oha.oha21       #税种

        LET l_json_data = cjc_addWorktask_data_json(l_data.*)
        #获取任务相关资料-单身
        LET l_sql = " SELECT * FROM ohb_file WHERE ohb01 = '",l_oha.oha01 CLIPPED,"'"
        DECLARE cs_get_oha_cs CURSOR FROM l_sql
        INITIALIZE l_detail TO NULL
        INITIALIZE l_ohb TO NULL
        FOREACH cs_get_oha_cs INTO l_ohb.*
                INITIALIZE l_ima02,l_ima021 TO null 
                LET l_detail.groupIdCode                              = g_plant        #营运中心id
                LET l_detail.serialNumber                             = l_ohb.ohb03      #序号
                LET l_detail.materialCode                             = l_ohb.ohb04      #物料编码
                select ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file WHERE ima01=l_ohb.ohb04 
                select replace(l_ima02,'\\','\\\\'),replace(l_ima021,'\\','\\\\') into l_ima02,l_ima021 from dual 
                select replace(l_ima02,'"','\\\"'),replace(l_ima021,'"','\\\"') into l_ima02,l_ima021 from dual
                select replace(l_ima02,'    ',''),replace(l_ima021,'    ','') into l_ima02,l_ima021 from dual
                select replace(l_ima02,chr(10),''),replace(l_ima021,chr(10),'') into l_ima02,l_ima021 from dual
                LET l_detail.materialName                             = l_ima02        #物料名称
                LET l_detail.spec                                     = l_ima021       #规格
                LET l_detail.unitIdCode                               = l_ohb.ohb05    #申请单位ID(取值来源,UNIT[单位表])
                LET l_detail.num                                      = l_ohb.ohb12    #申请数量
                LET l_detail.warehouseIdCode                          = l_ohb.ohb09    #申请仓库ID(取值来源,WAREHOUSE[仓库表])
                LET l_detail.cargoLocationIdCode                      = l_ohb.ohb091    #货位ID(取值来源CARGO_LOCATION[货位表])
                LET l_detail.batchNo                                  = l_ohb.ohb092    #批号
                LET l_detail.sourceCode                               = l_ohb.ohb01    #来源编码-销退单
                LET l_detail.sourceSerNo                              = l_ohb.ohb03      #来源项次  ---  销退单项次
                LET l_detail.remarks                                  = l_ohb.ohb1001    #备注
                LET l_detail.sourceCode                                 = l_ohb.ohb31   #出货单号
                LET l_detail.sourceSerNo                               = l_ohb.ohb32   #出货单项次
                LET l_json_detail = cjc_addWorktask_detail_json(l_detail.*)

                IF cl_null(l_json_str) THEN
                    LET l_json_str = "{",l_json_detail.trim(),"}"
                ELSE
                    LET l_json_str = l_json_str.trim(),",{",l_json_detail.trim(),"}"
                END IF
        END FOREACH       
    END IF 
    #------end ----- 

    #仓退  ----- begin --------- 
    IF p_type = 'PT1' THEN   
    #过滤条件
        LET l_ret.success = 'Y'
        SELECT COUNT(1) INTO l_cnt FROM rvu_file
        WHERE rvu01 =  p_doc
        IF cl_null(l_cnt) THEN
            LET l_cnt = 0
        END IF
        IF l_cnt = 0 THEN
            LET l_ret.msg = "仓退单(",p_doc CLIPPED,")未匹配"
            LET l_ret.success = 'N'
            RETURN l_ret.*
        END IF
        SELECT * INTO l_rvu.* FROM rvu_file
        WHERE rvu01 = p_doc
        IF SQLCA.SQLCODE THEN
            LET l_ret.success = 'N'
            LET l_ret.msg = "获取仓退单(",p_doc CLIPPED,")失败,SQLERR:",SQLCA.SQLCODE USING '-----'
            LET l_ret.code = SQLCA.SQLCODE = '-----'
            RETURN l_ret.*
        END IF

        IF l_rvu.rvuconf <> 'Y' THEN
            LET l_ret.success = 'N'
            LET l_ret.msg = '仓退单未审核'
            RETURN l_ret.*
        END IF


        #获取任务相关资料-单头
        INITIALIZE l_data TO NULL
        LET l_data.corporationIdCode                        = g_plant 
        #LET l_data.createdOn                                = l_rvu.rvu      #创建时间
        LET l_data.createdByCode                            = l_rvu.rvuuser      #创建人
        LET l_data.code                                     = l_rvu.rvu01        #单号
        LET l_data.groupIdCode                              = g_plant            #营运中心id
        LET l_data.docTypeIdCode                            = 'PT1'              #单据类型(例如:送货单/收货单...)
        LET l_data.docDate                                  = l_rvu.rvu03 USING 'yyyy/mm/dd'        #单据日期
        LET l_data.applicantIdCode                          = l_rvu.rvu07        #申请人ID(取值来源,STAFF[员工表])
        LET l_data.applicantDepartmentIdCode                = l_rvu.rvu06        #申请部门(取值来源,DEPARTMENT[部门表])
        LET l_data.remarks                                  = l_rvu.rvuud01     #备注
        LET l_data.sourceCode                               = l_rvu.rvu01     #来源编码-ERP仓退单号
        LET l_data.customerType                             = 'SUPPLIER'       #客商类型
        LET l_data.customerCustomerCode                     = l_rvu.rvu04      #供应商
        LET l_data.currencyIdCode                           = ''          #币种
        LET l_data.taxIdCode                                = ''       #税种

        LET l_json_data = cjc_addWorktask_data_json(l_data.*)
        #获取任务相关资料-单身
        LET l_sql = " SELECT * FROM rvv_file WHERE rvv01 = '",l_rvu.rvu01 CLIPPED,"'"
        DECLARE cs_get_rvu_cs CURSOR FROM l_sql
        INITIALIZE l_detail TO NULL
        INITIALIZE l_rvv TO NULL
        FOREACH cs_get_rvu_cs INTO l_rvv.*
                INITIALIZE l_ima02,l_ima021 TO null 
                LET l_detail.groupIdCode                              = g_plant        #营运中心id
                LET l_detail.serialNumber                             = l_rvv.rvv02      #序号
                LET l_detail.materialCode                             = l_rvv.rvv31      #物料编码
                select ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file WHERE ima01=l_rvv.rvv31 
                select replace(l_ima02,'\\','\\\\'),replace(l_ima021,'\\','\\\\') into l_ima02,l_ima021 from dual 
                select replace(l_ima02,'"','\\\"'),replace(l_ima021,'"','\\\"') into l_ima02,l_ima021 from dual
                select replace(l_ima02,'    ',''),replace(l_ima021,'    ','') into l_ima02,l_ima021 from dual
                select replace(l_ima02,chr(10),''),replace(l_ima021,chr(10),'') into l_ima02,l_ima021 from dual
                LET l_detail.materialName                             = l_ima02        #物料名称
                LET l_detail.spec                                     = l_ima021       #规格
                LET l_detail.unitIdCode                               = l_rvv.rvv35    #申请单位ID(取值来源,UNIT[单位表])
                LET l_detail.num                                      = l_rvv.rvv17    #申请数量
                LET l_detail.warehouseIdCode                          = l_rvv.rvv32    #申请仓库ID(取值来源,WAREHOUSE[仓库表])
                LET l_detail.cargoLocationIdCode                      = l_rvv.rvv33    #货位ID(取值来源CARGO_LOCATION[货位表])
                LET l_detail.batchNo                                  = l_rvv.rvv34   #批号
                LET l_detail.sourceCode                               = l_rvv.rvv01    #来源编码-仓退单
                LET l_detail.sourceSerNo                              = l_rvv.rvv02      #来源项次  ---  仓退单项次
                LET l_detail.remarks                                  = l_rvv.rvv26    #备注-原因
                LET l_detail.sourceCode                                 = l_rvv.rvv36   #采购单号
                LET l_detail.sourceSerNo                               = l_rvv.rvv37   #采购单项次
                #LET l_detail._color                                     = l_rvv.rvvud05   #颜色
                #LET l_detail.weight                                     = l_rvv.rvvud07   #克重
                #LET l_detail.width                                      = l_rvv.rvvud08   #幅宽
                #LET l_detail.rollLength                                 = l_rvv.rvvud09   #卷长
                #LET l_detail.rollWeight                                 = l_rvv.ta_rvv01   #卷重
                #LET l_detail.rollDiameter                                 = l_rvv.ta_rvv02   #卷径               LET l_detail.rollWeight                                 = l_rvv.rvv31   #订单号
                #LET l_detail.grossWeight                                  = l_rvv.ta_rvv04   #毛重
                #LET l_detail.expectNum                                    = l_rvv.ta_rvv06   #预计出货量
                #SELECT oeb11 INTO  l_detail.oemCode FROM oeb_file WHERE oeb01=l_rvv.rvv31 
                #AND oeb03=l_rvv.rvv32   
                #LET l_detail.oemCode                                 = ''

                LET l_json_detail = cjc_addWorktask_detail_json(l_detail.*)

                IF cl_null(l_json_str) THEN
                    LET l_json_str = "{",l_json_detail.trim(),"}"
                ELSE
                    LET l_json_str = l_json_str.trim(),",{",l_json_detail.trim(),"}"
                END IF
        END FOREACH       
    END IF 
    #------end ----- 
    # 倒扣发料同步------ begin ---- 
      IF p_type = 'DK1' OR p_type = 'OR1' THEN   
        #过滤条件
        LET l_ret.success = 'Y'

        SELECT COUNT(1) INTO l_cnt FROM sfp_file
        WHERE sfp01 =  p_doc
        IF cl_null(l_cnt)  THEN
            LET l_cnt = 0
        END IF
        IF l_cnt = 0 THEN
            LET l_ret.msg = "发料(退料)单(",p_doc CLIPPED,")未匹配"
            LET l_ret.success = 'N'
            RETURN l_ret.*
        END IF
        SELECT * INTO l_sfp.* FROM sfp_file
        WHERE sfp01 = p_doc
        IF SQLCA.SQLCODE THEN
            LET l_ret.success = 'N'
            LET l_ret.msg = "获取发料(退料)单(",p_doc CLIPPED,")失败,SQLERR:",SQLCA.SQLCODE USING '-----'
            LET l_ret.code = SQLCA.SQLCODE = '-----'
            RETURN l_ret.*
        END IF

        #获取任务相关资料-单头
        INITIALIZE l_data TO NULL
        #LET l_data.createdOn                                = l_sfp.sfp      #创建时间
        LET l_data.corporationIdCode                        = g_plant 
        LET l_data.createdByCode                            = l_sfp.sfpuser      #创建人
        LET l_data.code                                     = l_sfp.sfp01       #创建人
        LET l_data.groupIdCode                              = g_plant            #营运中心id
        LET l_data.docTypeIdCode                            = p_type             #单据类型(例如:送货单/收货单...)
        LET l_data.docDate                                  = l_sfp.sfp02 USING 'yyyy/mm/dd'        #单据日期
        LET l_data.applicantIdCode                          = l_sfp.sfp16        #申请人ID(取值来源,STAFF[员工表])
        LET l_data.applicantDepartmentIdCode                = l_sfp.sfp07        #申请部门(取值来源,DEPARTMENT[部门表])
        LET l_data.remarks                                  = ''      #备注
        LET l_data.sourceCode                               = l_sfp.sfp01      #来源编码
        LET l_data.issue_number                             = l_sfp.sfp05      #发料序号
        LET l_json_data = cjc_addWorktask_data_json(l_data.*)
        #获取任务相关资料-单身
        LET l_sql = " SELECT * FROM sfe_file WHERE sfe02 = '",l_sfp.sfp01 CLIPPED,"'"
        DECLARE cs_get_sfp_cs CURSOR FROM l_sql
        INITIALIZE l_detail TO NULL
        INITIALIZE l_sfe TO NULL
        FOREACH cs_get_sfp_cs INTO l_sfe.*
                INITIALIZE l_ima02,l_ima021 TO null 
                LET l_detail.groupIdCode                              = g_plant        #营运中心id
                LET l_detail.serialNumber                             = l_sfe.sfe28      #序号
                LET l_detail.materialCode                             = l_sfe.sfe07      #物料编码
                select ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file WHERE ima01=l_sfe.sfe07 
                select replace(l_ima02,'\\','\\\\'),replace(l_ima021,'\\','\\\\') into l_ima02,l_ima021 from dual 
                select replace(l_ima02,'"','\\\"'),replace(l_ima021,'"','\\\"') into l_ima02,l_ima021 from dual
                select replace(l_ima02,'    ',''),replace(l_ima021,'    ','') into l_ima02,l_ima021 from dual
                select replace(l_ima02,chr(10),''),replace(l_ima021,chr(10),'') into l_ima02,l_ima021 from dual
                LET l_detail.materialName                             = l_ima02        #物料名称
                LET l_detail.spec                                     = l_ima021       #规格
                LET l_detail.unitIdCode                               = l_sfe.sfe17    #申请单位ID(取值来源,UNIT[单位表])
                LET l_detail.num                                      = l_sfe.sfe16    #申请数量
                LET l_detail.warehouseIdCode                          = l_sfe.sfe08    #申请仓库ID(取值来源,WAREHOUSE[仓库表])
                LET l_detail.cargoLocationIdCode                      = l_sfe.sfe09    #货位ID(取值来源CARGO_LOCATION[货位表])
                LET l_detail.batchNo                                  = l_sfe.sfe10    #批号
                LET l_detail.sourceCode                               = l_sfe.sfe01    #来源编码-工单
                #LET l_detail.sourceSerNo                              = l_sfe.sfe      #来源项次
                LET l_detail.remarks                                  = l_sfe.sfe11    #备注
                LET l_detail.jobName                                  = l_sfe.sfe14    #作业标号
                LET l_detail.oemCode                                  = ''
                
                LET l_json_detail = cjc_addWorktask_detail_json(l_detail.*)

                IF cl_null(l_json_str) THEN
                    LET l_json_str = "{",l_json_detail.trim(),"}"
                ELSE
                    LET l_json_str = l_json_str.trim(),",{",l_json_detail.trim(),"}"
                END IF
            END FOREACH
    END IF 
    #------ end  ---- 
    LET l_json_str = "{",l_json_data,',"sheetDList"',":[",l_json_str.trim(),"]}"
    LET l_ret.msg = l_json_str
    LET l_json_str = cl_replace_str(l_json_str," ","")
    
    INITIALIZE l_returnstatus TO NULL 
    INITIALIZE l_returnmsg TO NULL
    LET l_json_str = cl_replace_str(l_json_str," ","")
    DISPLAY "-------------------------json---------taskSheetReceive-addoutnote------------"
    DISPLAY l_json_str
    DISPLAY "--------------------------------------------------"
    CALL taskSheetReceive(l_json_str) RETURNING l_returnstatus,l_returnmsg
    LET g_jsonstr = l_json_str
    LET g_returnstr = l_returnmsg
    IF l_returnstatus = '0' AND (l_returnmsg = 'OK' OR  l_returnmsg MATCHES 'DO2*' OR  l_returnmsg MATCHES 'MR1*'  OR l_returnmsg MATCHES 'PT1*' OR  l_returnmsg MATCHES 'OR1*'
      OR  l_returnmsg MATCHES '*已同步*' 
    )  THEN 
    	LET l_ret.success = 'Y' 
    	ELSE 
    	LET l_ret.success = 'N' 
    END IF 
    SELECT COUNT(*) INTO l_cnt FROM tc_zmxlog_file WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'taskSheetReceive' AND tc_zmxlog05 = p_doc AND tc_zmxlog07 = p_type
    IF l_cnt = 0 OR cl_null(l_cnt) THEN 
      INSERT INTO tc_zmxlog_file values(g_plant,'taskSheetReceive',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),g_user,p_doc,g_jsonstr,p_type,l_ret.success,g_returnstr,1,sysdate)
      ELSE 
      UPDATE tc_zmxlog_file SET tc_zmxlog03 = decode(tc_zmxlog08,'Y',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),tc_zmxlog03),
                                tc_zmxlog04 = decode(tc_zmxlog08,'Y',g_user,tc_zmxlog04),
                                tc_zmxlog06 = g_jsonstr,tc_zmxlog08 = l_ret.success,tc_zmxlog09 = g_returnstr,
                                tc_zmxlog10 = decode(tc_zmxlog08,'Y',1,tc_zmxlog10+1),tc_zmxlog11 = sysdate
      WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'taskSheetReceive' AND tc_zmxlog05 = p_doc AND tc_zmxlog07 = p_type
    END IF 
    
    IF l_ret.success = 'Y' THEN
       #LET l_ret.success = 'Y'
       CASE p_type
          WHEN 'MR1'
             #add by shawn 20022801  --- begin  -----  同步成功标示位 --- 
   #          UPDATE tc_sft_file SET tc_sft06 = 'Y' WHERE tc_sft01 =  l_tc_sft.tc_sft01 
             #---end -----  
             LET l_ret.msg = "工单发料需求单(",p_doc CLIPPED,")同步成功"
          WHEN 'MC1'
             LET l_ret.msg = "工单退料单(",p_doc CLIPPED,")同步成功"
         WHEN 'DO2'
             LET l_ret.msg = "出货通知单(",p_doc CLIPPED,")同步成功"          
       END CASE 
    ELSE
       #INSERT INTO tc_zmxlog_file values(g_plant,'taskSheetReceive',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),g_user,'',
       #l_str_json,'',l_returnstatus,l_msg)
       #LET l_ret.success = 'N'
       LET l_ret.msg = l_returnmsg
    END IF

    RETURN l_ret.*

END FUNCTION 


#作业线边仓对应关系同步
FUNCTION cl_zmx_json_ecd(p_ecd01,p_uptime)
DEFINE p_ecd01          LIKE ecd_file.ecd01
DEFINE p_uptime         LIKE type_file.chr100
DEFINE l_ret            RECORD
             success    LIKE type_file.chr1,
             code       LIKE type_file.chr10,
             msg        STRING
                        END RECORD
DEFINE l_ecd            RECORD LIKE ecd_file.*
DEFINE l_json_str       STRING 
DEFINE l_json_data      STRING 
DEFINE l_sql            STRING 
DEFINE l_cnt            LIKE type_file.num10
DEFINE l_data           RECORD
        groupCode       LIKE type_file.chr100,
        workNo          LIKE type_file.chr100,
        workName        LIKE type_file.chr100,
        warehouseCode   LIKE type_file.chr100,
        locationCode    LIKE type_file.chr100,
        _status         LIKE type_file.chr100
                        END RECORD
DEFINE l_returnstatus   LIKE type_file.num5
DEFINE l_returnmsg      String

    INITIALIZE l_ret TO NULL 

    IF cl_null(p_ecd01) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "作业编号为空"
        RETURN l_ret.*
    END IF 

    INITIALIZE l_ecd TO NULL
    SELECT * INTO l_ecd.* FROM ecd_file 
     WHERE ecd01 = p_ecd01 
    
    LET l_data.groupCode = g_plant
    LET l_data.workNo = l_ecd.ecd01
    LET l_data.workName = l_ecd.ecd02
    LET l_data.warehouseCode  = 'XBC'
    LET l_data.locationCode  = l_ecd.ecd07
    IF l_ecd.ecdacti  = 'Y' THEN  
        LET l_data._status  = 'Y' 
    ELSE 
        LET l_data._status  = 'N' 
    END IF 
    LET l_json_data = cl_getEcd_data_json(l_data.*)

    LET l_json_str = "{",l_json_data,"}"
    LET l_json_str = cl_replace_str(l_json_str," ","")
    LET l_json_str = cl_replace_str(l_json_str,"`"," ")
    LET l_ret.msg = l_json_str
    DISPLAY "-------------------------json-------synXBCInfo------------"
    DISPLAY l_json_str
    DISPLAY "--------------------------------------------------"
    INITIALIZE l_returnstatus TO NULL 
    INITIALIZE l_returnmsg TO NULL
    CALL synXBCInfo(l_json_str) RETURNING l_returnstatus,l_returnmsg
    LET g_jsonstr = l_json_str
    LET g_returnstr = l_returnmsg
    IF l_returnstatus = '0' AND l_returnmsg = 'OK' THEN 
    	LET l_ret.success = 'Y' 
    	ELSE 
    	LET l_ret.success = 'N' 
    END IF 
    SELECT COUNT(*) INTO l_cnt FROM tc_zmxlog_file WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'synXBCInfo' AND tc_zmxlog05 = p_ecd01   #AND tc_zmxlog07 = '02'
    IF l_cnt = 0 OR cl_null(l_cnt) THEN 
      INSERT INTO tc_zmxlog_file values(g_plant,'synXBCInfo',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),g_user,p_ecd01,g_jsonstr,'',l_ret.success,g_returnstr,1,sysdate)
      ELSE 
      UPDATE tc_zmxlog_file SET tc_zmxlog03 = decode(tc_zmxlog08,'Y',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),tc_zmxlog03),
                                tc_zmxlog04 = decode(tc_zmxlog08,'Y',g_user,tc_zmxlog04),
                                tc_zmxlog06 = g_jsonstr,tc_zmxlog08 = l_ret.success,tc_zmxlog09 = g_returnstr,
                                tc_zmxlog10 = decode(tc_zmxlog08,'Y',1,tc_zmxlog10+1),tc_zmxlog11 = sysdate
      WHERE tc_zmxlog01 = g_plant AND tc_zmxlog02 = 'synXBCInfo' AND tc_zmxlog05 = p_ecd01   #AND tc_zmxlog07 = '02'
    END IF 
    IF l_ret.success = 'Y' THEN
       #LET l_ret.success = 'Y'
       LET l_ret.msg = "作业(",l_ecd.ecd01 CLIPPED,")同步成功"
    ELSE
       #LET l_ret.success = 'N'
       LET l_ret.msg = l_returnmsg
    END IF

    RETURN l_ret.*

END FUNCTION 

