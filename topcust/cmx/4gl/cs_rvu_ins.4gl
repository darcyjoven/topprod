# Prog. Version..: '5.00.01-07.05.10(00010)'     #
# Pattern name...: cs_rvu_ins.4gl
# Descriptions...: 入库单单头产生函数
# Date & Author..: 16/01/01  By  LGe
# Note           : 传入值:  rva_file.*

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

FUNCTION cs_ins_rvu(p_rva01,p_rvu01,p_gen01)
DEFINE l_rvu            RECORD LIKE rvu_file.*
DEFINE l_ret            RECORD
              success   LIKE type_file.chr1,
              code      STRING,
              msg       STRING
                        END RECORD
DEFINE p_rva01          LIKE rva_file.rva01
DEFINE p_rvu01          LIKE rvu_file.rvu01           #入库单单别
DEFINE p_gen01          LIKE gen_file.gen01
DEFINE l_rva            RECORD LIKE rva_file.*
DEFINE l_user           LIKE gen_file.gen01
DEFINE l_grup           LIKE gem_file.gem01
DEFINE li_result        LIKE type_file.num5
    
    INITIALIZE l_ret TO NULL 

    LET l_ret.success = 'Y'
    LET l_ret.code    = '0'

    IF cl_null(p_rva01) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "未传入收货单单头，无法产生入库单单头！"
        RETURN l_ret.*
    END IF 

    INITIALIZE l_rva TO NULL 
    SELECT * INTO l_rva.* FROM rva_file 
     WHERE rva01 = p_rva01
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "获取收货单资料失败！"
        RETURN l_ret.*
    END IF 

    #是否有操作人员传入
    INITIALIZE l_user TO NULL 
    INITIALIZE l_grup TO NULL
    IF cl_null(p_gen01) THEN 
        LET l_user = l_rva.rvauser
        LET l_grup = l_rva.rvagrup
    ELSE 
        LET l_user = p_gen01
        SELECT gen03 INTO l_grup FROM gen_file 
         WHERE gen01 = l_user
    END IF 

    INITIALIZE l_rvu TO NULL 
   
    LET l_rvu.rvu00 = '1'                        #异动类别
    IF NOT cl_null(p_rvu01) THEN 
        LET l_rvu.rvu01 = p_rvu01                #入库单号
    END IF 

    #可在此处根据实际情况调整入库单单别取值方式
   #IF cl_null(l_rvu.rvu01) THEN 
       #LET l_rvu.rvu01 = 'PI01'
        LET l_rvu.rvu01 = 'HC71'
   #END IF 

    LET l_rvu.rvu02 = l_rva.rva01                #收货单号
    LET l_rvu.rvu03 = g_today                    #异动日期
    LET l_rvu.rvu04 = l_rva.rva05                #厂商编号
    SELECT pmc03 INTO l_rvu.rvu05 FROM pmc_file  #厂商简称
     WHERE pmc01 = l_rvu.rvu04
    LET l_rvu.rvu07 = l_rva.rva33                #人员
    SELECT gen03 INTO l_rvu.rvu06 FROM gen_file  #部门
     WHERE gen01 = l_rvu.rvu07
    LET l_rvu.rvu08 = l_rva.rva10                #采购性质
    LET l_rvu.rvu09 = NULL                       #取回日期
    LET l_rvu.rvu10 = 'N'                        #开立折让否
   #LET l_rvu.rvu11 =                            #折让单日期
   #LET l_rvu.rvu12 =                            #税率
   #LET l_rvu.rvu13 =                            #折让单税前金额
   #LET l_rvu.rvu14 =                            #折让单税额
   #LET l_rvu.rvu15 =                            #折让原发票号码
    LET l_rvu.rvu20 = 'N'                        #多角贸易抛转否
   #LET l_rvu.rvu99 =                            #多角贸易流程序号
    LET l_rvu.rvuconf = 'N'                      #确认码
    LET l_rvu.rvuacti = 'Y'                      #有效码
    LET l_rvu.rvuuser = l_user                   #资料所有者
    LET l_rvu.rvugrup = l_grup                   #资料所有部门
   #LET l_rvu.rvumodu =                          #资料更改者
    LET l_rvu.rvudate = g_today                  #最近修改日期
   #LET l_rvu.rvu100=                            #保税异动原因代码
   #LET l_rvu.rvu101=                            #保税进口报单
   #LET l_rvu.rvu102=                            #保税进口报单日期
   #LET l_rvu.rvu16 =                            #领料单号
   #LET l_rvu.rvu111=                            #付款方式
   #LET l_rvu.rvu112=                            #价格条件
   #LET l_rvu.rvu113=                            #币种
   #LET l_rvu.rvu114=                            #汇率
   #LET l_rvu.rvu115=                            #税种
   #LET l_rvu.rvu116=                            #退货方式
   #LET l_rvu.rvu117=                            #VMI发/退料单号
    LET l_rvu.rvu21 = l_rva.rva29                #经营方式
   #LET l_rvu.rvu22 =                            #采购中心
   #LET l_rvu.rvu23 =                            #配送中心
   #LET l_rvu.rvu24 =                            #多角贸易流程代码
    LET l_rvu.rvu900= '0'                        #状况码
   #LET l_rvu.rvucond =                          #审核日期
   #LET l_rvu.rvucont =                          #审核时间
   #LET l_rvu.rvuconu =                          #审核人员
    LET l_rvu.rvucrat = g_today                  #资料创建日
   #LET l_rvu.rvudays =                          #签核完成天数
    LET l_rvu.rvumksg = 'N'                      #是否签核
   #LET l_rvu.rvuprit =                          #签核优先等级
   #LET l_rvu.rvusign =                          #签核等级
   #LET l_rvu.rvusmax =                          #应签核顺序
   #LET l_rvu.rvusseq =                          #已签核顺序
    LET l_rvu.rvupos= 'N'                        #已传POS
    LET l_rvu.rvuplant= l_rva.rvaplant           #所属营运中心
    LET l_rvu.rvulegal= l_rva.rvalegal           #所属法人
    LET l_rvu.rvuoriu = l_user                   #资料建立者
    LET l_rvu.rvuorig = l_grup                   #资料建立部门
   #LET l_rvu.rvu25 =                            #来源单号
    LET l_rvu.rvu17 = '0'                        #签核状况
   #LET l_rvu.rvu26 =                            #申请单号
    LET l_rvu.rvu27 = ' '                        #虚拟类型
   #LET l_rvu.rvuud01 =                          #自定义
   #LET l_rvu.rvuud02 =  
   #LET l_rvu.rvuud03 =  
   #LET l_rvu.rvuud04 =  
   #LET l_rvu.rvuud05 =  
   #LET l_rvu.rvuud06 =  
   #LET l_rvu.rvuud07 =  
   #LET l_rvu.rvuud08 =  
   #LET l_rvu.rvuud09 =  
   #LET l_rvu.rvuud10 =  
   #LET l_rvu.rvuud11 =  
   #LET l_rvu.rvuud12 =  
   #LET l_rvu.rvuud13 =  
   #LET l_rvu.rvuud14 =  
   #LET l_rvu.rvuud15 =  

    CALL s_auto_assign_no("apm",l_rvu.rvu01,l_rvu.rvu03,'7',"rvu_file","rvu01","","","")
         RETURNING li_result,l_rvu.rvu01
    IF (NOT li_result) THEN
        LET l_ret.success = 'N'
        LET l_ret.msg = "单号产生失败！"
        RETURN l_ret.*
    END IF

    INSERT INTO rvu_file VALUES(l_rvu.*)
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.code = SQLCA.SQLCODE 
        LET l_ret.msg = "cs_rvu_ins() insert rvu_file error:",cl_getmsg(SQLCA.SQLCODE,g_lang)
    ELSE 
        LET l_ret.msg = l_rvu.rvu01
    END IF 

    RETURN l_ret.*
END FUNCTION 

