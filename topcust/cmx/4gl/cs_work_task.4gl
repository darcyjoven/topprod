# Prog. Version..: '5.00.01-07.05.10(00010)'     #
# Pattern name...: cs_work_task.4gl
# Descriptions...: 工单同步函数
# Date & Author..: 16/01/01  By  LGe
# Note           : 传入值:
# ...............: 返回值:  Y-成功; N-失败
#                           code: 0 成功    其他为错误代码
#                           msg:  错误信息


DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

FUNCTION cs_work_task(p_op,p_plant,p_sfb01)
DEFINE p_op             LIKE type_file.chr10
DEFINE p_plant          LIKE sfb_file.sfbplant
DEFINE p_sfb01          LIKE sfb_file.sfb01
DEFINE l_ret            RECORD
             success    LIKE type_file.chr1,
             code       LIKE type_file.chr10,
             msg        STRING
                        END RECORD

    INITIALIZE l_ret TO NULL
    LET l_ret.success = 'Y'

    IF p_op = 'INS' THEN 
        CALL cs_add_worktask(p_sfb01) RETURNING l_ret.*
    END IF 

    IF p_op = 'DEL' THEN 

    END IF 

    RETURN l_ret.*

END FUNCTION 

FUNCTION cs_add_worktask(p_sfb01) 
DEFINE p_sfb01          LIKE sfb_file.sfb01
DEFINE l_sfb            RECORD LIKE sfb_file.*
DEFINE l_ret            RECORD 
         success        LIKE type_file.chr1,
         code           LIKE type_file.chr10,
         msg            STRING 
                        END RECORD
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
#DEFINE l_ta_pjfa12      LIKE pjfa_file.ta_pjfa12
#DEFINE l_ta_pjb018      LIKE pjb_file.ta_pjb018
#DEFINE l_ta_pjb019      LIKE pjb_file.ta_pjb019

    INITIALIZE l_ret TO NULL
    LET l_ret.success = 'Y'

    IF cl_null(p_sfb01) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "无工单单号"
        RETURN l_ret.*
    END IF 
    
    INITIALIZE l_sfb TO NULL 
    SELECT * INTO l_sfb.* FROM sfb_file 
     WHERE sfb01 = p_sfb01    
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "获取工单信息失败,SQLERR:",SQLCA.SQLCODE USING '-----'
        LET l_ret.code = SQLCA.SQLCODE USING '-----'
        RETURN l_ret.*
    END IF 

    INITIALIZE l_data TO NULL 
    LET l_data.createUserid = ""
    LET l_data.createTime = g_today USING 'YYYY-MM-DD'
    LET l_data.status = l_sfb.sfb04
    LET l_data.workNo = l_sfb.sfb01
    LET l_data.generateDate = l_sfb.sfb81 USING 'YYYY-MM-DD'
    LET l_data.workType =  l_sfb.sfb02
    LET l_data.accountWay = l_sfb.sfb39
    LET l_data.productCode = l_sfb.sfb05
    SELECT ima02,ima021 INTO l_data.productName,l_data.spec 
      FROM ima_file
     WHERE ima01 = l_sfb.sfb05
    LET l_data.orderNo = l_sfb.sfb22
    LET l_data.orderItem = l_sfb.sfb221
    LET l_data.bom = l_sfb.sfb07
    LET l_data.amount = l_sfb.sfb08
    LET l_data.expectedStartDate = l_sfb.sfb13 USING 'YYYY-MM-DD'
    LET l_data.actualStartDate =   l_sfb.sfb25 USING 'YYYY-MM-DD'
    LET l_data.expectedEndDate =   l_sfb.sfb15 USING 'YYYY-MM-DD'
    LET l_data.actualEndDate =  l_sfb.sfb38 USING 'YYYY-MM-DD'
    LET l_data.sendAmount = l_sfb.sfb081
    LET l_data.finishAmount = l_sfb.sfb09
    LET l_data.scrapAmount =  l_sfb.sfb12
    LET l_data.processCode =  l_sfb.sfb06
    LET l_data.groupCode = l_sfb.sfbplant
    LET l_data.batchNo = ""
   #INITIALIZE l_ta_pjfa12 TO NULL 
   #INITIALIZE l_ta_pjb018 TO NULL
   #INITIALIZE l_ta_pjb019 TO NULL
   #SELECT DISTINCT ta_pjfa12,ta_pjb018,ta_pjb019 
   #  INTO l_ta_pjfa12,l_ta_pjb018,l_ta_pjb019
   #  FROM pjb_file,pjfa_file 
   # WHERE ta_pjfa02 = l_sfb.sfb01
   #   AND pjb02 = pjfa01
   #IF cl_null(l_ta_pjb018) THEN 
   #    LET l_ta_pjb018 = 'N'
   #END IF 
   #IF l_ta_pjb018 = 'Y' THEN 
   #    LET l_data.attr1 =  l_ta_pjb019
   #END IF 
   #LET l_data.attr2 = l_ta_pjfa12

    LET l_ret.msg = cs_addworktask_data(l_data.*)
     
    LET l_ret.msg = "<data>",l_ret.msg.trim(),"</data>"
    CALL addWorkTask(l_ret.msg) RETURNING l_ret.code,l_ret.msg
    IF l_ret.code <> '0' THEN 
        LET l_ret.msg = "调取接口失败"
        LET l_ret.success = 'N'
        RETURN l_ret.*
    END IF 
    IF cl_null(l_ret.msg) OR l_ret.msg <> 'OK' THEN 
        LET l_ret.success = 'N'
    END IF 
    
    RETURN l_ret.*

END FUNCTION 
