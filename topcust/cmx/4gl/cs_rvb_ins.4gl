# Prog. Version..: '5.00.01-07.05.10(00010)'     #
# Pattern name...: cs_rvb_ins.4gl
# Descriptions...: 收货单单身产生函数
# Date & Author..: 16/01/01  By  LGe
# Note           : 传入值:  
# ...............: 返回值:  Y-成功; N-失败
#                           code: 0 成功    其他为错误代码
#                           msg:  错误信息  


DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

FUNCTION cs_ins_rvb(p_rva01,p_pmn01,p_pmn02,p_rvb07,p_rvb38,p_pmm21,p_pmm22,p_rvb36,p_rvb37)
DEFINE p_rva01          LIKE rva_file.rva01
DEFINE p_pmn01          LIKE pmn_file.pmn01
DEFINE p_pmn02          LIKE pmn_file.pmn02
DEFINE p_rvb07          LIKE rvb_file.rvb07
DEFINE p_rvb38          LIKE rvb_file.rvb38    #批号
DEFINE p_pmm22          LIKE pmm_file.pmm22
DEFINE p_pmm21          LIKE pmm_file.pmm21
DEFINE l_ret            RECORD 
             success    LIKE type_file.chr1,
             code       LIKE type_file.chr10,
             msg        STRING
                        END RECORD
DEFINE l_rvb            RECORD LIKE rvb_file.*
DEFINE l_pmn            RECORD LIKE pmn_file.*
DEFINE l_cnt            LIKE type_file.num10
DEFINE l_rva06          LIKE rva_file.rva06
DEFINE l_ima24          LIKE ima_file.ima24
DEFINE l_ima25          LIKE ima_file.ima25
DEFINE l_ima35          LIKE ima_file.ima35
DEFINE l_ima36          LIKE ima_file.ima36
DEFINE l_ima159         LIKE ima_file.ima159
DEFINE l_fac            LIKE rvb_file.rvb90_fac
DEFINE l_flag           LIKE type_file.num5
DEFINE p_rvb36          LIKE rvb_file.rvb36   #仓库  
DEFINE p_rvb37          LIKE rvb_file.rvb37   #库位

    INITIALIZE l_ret TO NULL
    LET l_ret.success = 'Y'
    LET l_ret.code = '0'
    
    IF cl_null(p_rva01) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "未传入收货单单号！"
        RETURN l_ret.*
    END IF 
    IF cl_null(p_pmn01) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "未传入采购单号!"
        RETURN l_ret.*
    END IF 
    IF cl_null(p_pmn02) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "未传入采购单项次!"
        RETURN l_ret.*
    END IF 

    INITIALIZE l_cnt TO NULL 
    SELECT COUNT(*) INTO l_cnt FROM pmn_file 
     WHERE pmn01 = p_pmn01
       AND pmn02 = p_pmn02
    IF l_cnt = 0 THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "未能匹配到采购明细！(采购单:",p_pmn01 CLIPPED,"-",p_pmn02,")"  
        RETURN l_ret.*
    END IF 

    IF cl_null(p_rvb07) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "未传入扫描收货数量！"
        RETURN l_ret.*
    END IF 

    IF p_rvb07 = 0 THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "收货数量为0！"
        RETURN l_ret.*
    END IF 

    INITIALIZE l_rva06 TO NULL 
    SELECT rva06
      INTO l_rva06
      FROM rva_file
     WHERE rva01 = p_rva01

    INITIALIZE l_pmn TO NULL 
    SELECT * INTO l_pmn.* FROM pmn_file 
     WHERE pmn01 = p_pmn01 AND pmn02 = p_pmn02

    INITIALIZE l_rvb TO NULL 

    LET l_rvb.rvb01 = p_rva01

    #单身项次
    SELECT nvl(MAX(rvb02),0) + 1 
      INTO l_rvb.rvb02
      FROM rvb_file 
     WHERE rvb01 = l_rvb.rvb01

    LET l_rvb.rvb04 = l_pmn.pmn01          #采购单号
    LET l_rvb.rvb03 = l_pmn.pmn02          #采购项次
    LET l_rvb.rvb05 = l_pmn.pmn04          #料号
    LET l_rvb.rvb06 = 0                    #已请款量
    LET l_rvb.rvb07 = p_rvb07              #实收数量
    LET l_rvb.rvb08 = p_rvb07              #收货数量
    LET l_rvb.rvb09 = p_rvb07              #允请数量
    LET l_rvb.rvb10 = l_pmn.pmn31          #收料单价    原币未税
    LET l_rvb.rvb11 = 0                    #代买项次
    LET l_rvb.rvb12 = l_rva06              #收货应完成日期。  若该物料需检验，则检验需要多少天，以此推算最终完成时间
   #LET l_rvb.rvb13 =                      #厂商批号
   #LET l_rvb.rvb14 =                      #容器编号
    LET l_rvb.rvb15 = 0                    #容器装数
    LET l_rvb.rvb16 = 0                    #容器数目
   #LET l_rvb.rvb17 =                      #检验批号
    LET l_rvb.rvb18 = '10'                 #收货状况
    LET l_rvb.rvb19 = '1'                  #收货性质
   #LET l_rvb.rvb20 =                      #料件无法入库是否继续运行
   #LET l_rvb.rvb21 =                      #保税过账否
   #LET l_rvb.rvb22 =                      #发票编号
   #LET l_rvb.rvb25 =                      #手册编号
   #LET l_rvb.rvb26 =                      #No Use
    LET l_rvb.rvb27 = 0                    #No Use
    LET l_rvb.rvb28 = 0                    #No Use
    LET l_rvb.rvb29 = 0                    #验退量
    LET l_rvb.rvb30 = 0                    #入库量
    LET l_rvb.rvb31 = 0                    #可入库量
    LET l_rvb.rvb32 = 0                    #退扣
    LET l_rvb.rvb33 = 0                    #允收数量
    LET l_rvb.rvb34 = l_pmn.pmn41          #工单单号
    LET l_rvb.rvb35 = 'N'                  #样品否
   
    LET l_rvb.rvb36 = l_pmn.pmn52          #仓库
    LET l_rvb.rvb37 = l_pmn.pmn54          #库位
    LET l_rvb.rvb38 = l_pmn.pmn56          #批号

    INITIALIZE l_ima24 TO NULL
    SELECT ima24,ima25,ima35,ima36,ima159 
      INTO l_ima24,l_ima25,l_ima35,l_ima36,l_ima159
      FROM ima_file 
     WHERE ima01 = l_rvb.rvb05
    IF cl_null(l_ima24) THEN 
        LET l_ima24 = 'N'
    END IF 
    IF cl_null(l_ima35) THEN 
        LET l_ima35 = ' '
    END IF 
    IF cl_null(l_ima36) THEN 
        LET l_ima36 = ' '
    END IF 

    IF cl_null(l_rvb.rvb36) THEN 
        LET l_rvb.rvb36 = l_pmn.pmn52
    END IF 
    IF cl_null(l_rvb.rvb37) THEN 
        LET l_rvb.rvb37 = l_pmn.pmn37
    END IF 

    IF cl_null(l_ima159) THEN 
        LET l_ima159 = '3'
    END IF 
    IF l_ima159 = '2' THEN 
        LET l_rvb.rvb38 = l_pmn.pmn56 
    ELSE
        LET l_rvb.rvb38 = p_rvb38
        IF cl_null(l_rvb.rvb38) THEN 
            LET l_rvb.rvb38 = ' '
        END IF  
    END IF 
   #####################################################
   #注：请在此处增加默认收货仓库、库位。
    IF NOT cl_null(p_rvb36) THEN 
        LET l_rvb.rvb36 = p_rvb36
    END IF 
    IF NOT cl_null(p_rvb37) THEN 
        LET l_rvb.rvb37 = p_rvb37
    END IF 
   #IF NOT cl_null(p_rvb38) THEN 
   #    LET l_rvb.rvb38 = p_rvb38
   #END IF 

   #####################################################

    LET l_rvb.rvb39 = l_ima24                    #检验否

    IF l_rvb.rvb39 = 'N' THEN            
        LET l_rvb.rvb40 =  l_rva06               #检验日期
        LET l_rvb.rvb41 =  'OK'                  #检验结果
    END IF 
    LET l_rvb.rvb80 = l_pmn.pmn80                #单位一
    LET l_rvb.rvb81 = l_pmn.pmn81                #单位一换算率
    LET l_rvb.rvb82 = p_rvb07                    #单位一数量
    LET l_rvb.rvb83 = l_pmn.pmn83                #单位二
    LET l_rvb.rvb84 = l_pmn.pmn84                #单位二换算率
    LET l_rvb.rvb85 = p_rvb07 * l_rvb.rvb84      #单位二数量
    IF cl_null(l_rvb.rvb85) THEN 
        LET l_rvb.rvb85 = 0
    END IF 
    LET l_rvb.rvb86 = l_pmn.pmn86                #计价单位
    LET l_rvb.rvb87 = p_rvb07                    #计价数量
    LET l_rvb.rvb10t= l_pmn.pmn31t               #含税单价
    LET l_rvb.rvb88 = l_rvb.rvb87 * l_rvb.rvb10  #税前金额
    LET l_rvb.rvb88t= l_rvb.rvb87 * l_rvb.rvb10t #含税金额
    LET l_rvb.rvb331= 0                          #允收数量一
    LET l_rvb.rvb332= 0                          #允收数量二
    LET l_rvb.rvb930= l_pmn.pmn930               #成本中心

    LET l_rvb.rvb051= l_pmn.pmn041              #品名规格
    LET l_rvb.rvb89 = l_pmn.pmn89               #VMI收货否
    IF cl_null(l_rvb.rvb89) THEN 
        LET l_rvb.rvb89 = 'N'
    END IF 
    LET l_rvb.rvb90 = l_pmn.pmn07                #收货单位
    CALL s_umfchk(l_rvb.rvb05,l_rvb.rvb90,l_ima25)
       RETURNING l_flag,l_fac
    IF l_flag THEN
        LET l_rvb.rvb90_fac = 1                  #收货单位与库存单位转换率
    ELSE
        LET l_rvb.rvb90_fac = l_fac
    END IF
    LET l_rvb.rvb42 = '4'                        #取价类型
   #LET l_rvb.rvb43 =                            #价格来源
   #LET l_rvb.rvb44 =                            #来源单号
   #LET l_rvb.rvb45 =                            #来源项次
    LET l_rvb.rvbplant = g_plant                 #所属营运中心
    LET l_rvb.rvblegal = g_legal                 #法人
   #LET l_rvb.rvb93 =                            #电子交货序号
    LET l_rvb.rvb919= l_pmn.pmn919               #计划批号
   #LET l_rvb.rvbud01
   #LET l_rvb.rvbud02 
   #LET l_rvb.rvbud03 
   #LET l_rvb.rvbud04 
   #LET l_rvb.rvbud05 
   #LET l_rvb.rvbud06 
   #LET l_rvb.rvbud07 
   #LET l_rvb.rvbud08 
   #LET l_rvb.rvbud09 
   #LET l_rvb.rvbud10 
   #LET l_rvb.rvbud11  
   #LET l_rvb.rvbud12 
   #LET l_rvb.rvbud13 
   #LET l_rvb.rvbud14 
   #LET l_rvb.rvbud15
    
    INSERT INTO rvb_file VALUES(l_rvb.*)
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.code = SQLCA.SQLCODE
        LET l_ret.msg  = cl_getmsg(l_ret.code,g_lang)
    ELSE
        LET l_ret.code = l_rvb.rvb02
        LET l_ret.msg = "rvb ins OK!"
    END IF 
    RETURN l_ret.*

END FUNCTION 


