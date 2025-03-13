# Prog. Version..: '5.00.01-07.05.10(00010)'     #
# Pattern name...: cs_rva_ins.4gl
# Descriptions...: 收货单产生函数
# Date & Author..: 16/01/01  By  LGe
# Note           : 传入值:  rva_file.*
# ...............: 返回值:  Y-成功; N-失败
#                           code: 0 成功    其他为错误代码
#                           msg:  错误信息  成功，则msg为单号


DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

FUNCTION cs_ins_rva(p_pmm02,p_pmm09,p_rva07,p_rva33)
DEFINE l_rva            RECORD LIKE rva_file.*
DEFINE l_ret            RECORD
              success   LIKE type_file.chr1,
              code      STRING,
              msg       STRING 
                        END RECORD
DEFINE p_pmm02          LIKE pmm_file.pmm02           #采购类型
DEFINE p_pmm09          LIKE pmm_file.pmm09           #供应商
DEFINE p_rva07          LIKE rva_file.rva07           #送货单单号
DEFINE p_rva33          LIKE rva_file.rva33           #申请人
DEFINE l_gem01          LIKE gem_file.gem01
DEFINE li_result        LIKE type_file.num5

    INITIALIZE l_ret TO NULL
    LET l_ret.success = 'Y'
    LET l_ret.code = '0'
    
    #若未给单别，则按原则取值
   #IF cl_null(l_rva.rva01) THEN 
        LET l_rva.rva01 = 'HC31'
   #END IF 

    #获取申请人的申请部门
    INITIALIZE l_gem01 TO NULL
    SELECT gen03 INTO l_gem01 FROM gen_file WHERE gen01 = p_rva33

   #LET l_rva.rva02 = ''               #采购单号     本作业会合并多张采购单，故单头采购单号不维护
   #LET l_rva.rva03 = ''
    LET l_rva.rva04 = 'N'
    LET l_rva.rva05 = p_pmm09          #供应商
    LET l_rva.rva06 = g_today          #当天     收货单产生之日
    LET l_rva.rva07 = p_rva07          #送货单单号
   #LET l_rva.rva08 =                  #进口报单
   #LET l_rva.rva09 =                  #进口号码
    LET l_rva.rva10 = p_pmm02          #采购类型
    LET l_rva.rvaprsw = 'Y'            #是否需要打印收货单
   #LET l_rva.rva20 =                  #No Use
   #LET l_rva.rva21 =                  #进口日期
   #LET l_rva.rva22 =                  #附带打印缺料销单否
   #LET l_rva.rva23 =                  #缺料销单截止日期
   #LET l_rva.rva24 =                  #No Use
   #LET l_rva.rva25 =                  #No Use
   #LET l_rva.rva26 =                  #异动原因
   #LET l_rva.rva27 =                  #No Use
   #LET l_rva.rva28 =                  #最后打印日期
   #LET l_rva.rva99 =                  #多角贸易流程序号
    LET l_rva.rvaconf = 'N'            #资料审核码
    LET l_rva.rvaprno = 0              #资料打印次数
    LET l_rva.rvaacti = 'Y'            #资料有效否
    LET l_rva.rvauser = p_rva33        #资料所有者
    LET l_rva.rvagrup = l_gem01        #资料所有部门
   #LET l_rva.rvamodu =                #资料更改者
    LET l_rva.rvadate = g_today        #最近更改日
    LET l_rva.rvaspc  = '0'            #SPC抛转码
   #LET l_rva.rva100  =                #保税异动原因代码
    LET l_rva.rva00   = '1'            #收货类别
   #LET l_rva.rva111  =                #付款方式
   #LET l_rva.rva112  =                #价格条件
   #LET l_rva.rva113  =                #币种
   #LET l_rva.rva114  =                #汇率
   #LET l_rva.rva115  =                #税种
   #LET l_rva.rva116  =                #税率
   #LET l_rva.rva117  =                #VMI发料单号
    LET l_rva.rva29   = '1'            #经营方式
   #LET l_rva.rva30   =                #采购营运中心
   #LET l_rva.rva31   =                #配送中心
   #LET l_rva.rvacond = ''             #审核日期
   #LET l_rva.rvaconu = ''             #审核人员
    LET l_rva.rvacrat = g_today        #资料创建日
    LET l_rva.rvaplant= g_plant        #所属营运中心
    LET l_rva.rvalegal= g_legal        #所属法人
    LET l_rva.rvaoriu = l_rva.rvauser
    LET l_rva.rvaorig = l_rva.rvagrup
    LET l_rva.rva32   = '0'
    LET l_rva.rva33   = p_rva33        #申请人
    LET l_rva.rvamksg = 'N'            #签核否
   #LET l_rva.rvacont =                #审核时间
   #LET l_rva.rva34   = ''             #POS单号
   #LET l_rva.rvaud01
   #LET l_rva.rvaud02
   #LET l_rva.rvaud03
   #LET l_rva.rvaud04
   #LET l_rva.rvaud05
   #LET l_rva.rvaud06
   #LET l_rva.rvaud07
   #LET l_rva.rvaud08
   #LET l_rva.rvaud09
   #LET l_rva.rvaud10
   #LET l_rva.rvaud11
   #LET l_rva.rvaud12
   #LET l_rva.rvaud13
   #LET l_rva.rvaud14
   #LET l_rva.rvaud15
    CALL s_auto_assign_no("apm",l_rva.rva01,l_rva.rva06,'3',"rva_file","rva01","","","")
        RETURNING li_result,l_rva.rva01
    IF (NOT li_result) THEN
        LET l_ret.success = 'N'
        LET l_ret.msg = "单号产生失败！"
        RETURN l_ret.*
    END IF

    INSERT INTO rva_file VALUES(l_rva.*)
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.code = SQLCA.SQLCODE
        LET l_ret.msg = cl_getmsg(SQLCA.SQLCODE,g_lang)
    ELSE 
        LET l_ret.msg = l_rva.rva01
    END IF 
    
    RETURN l_ret.*

END FUNCTION 

