# Prog. Version..: '5.00.01-07.05.10(00010)'     #
# Pattern name...: cs_rvb_ins.4gl
# Descriptions...: 验收单单头产生函数
# Date & Author..: 16/01/01  By  LGe
# Note           : 传入值:
# ...............: 返回值:  Y-成功; N-失败
#                           code: 0 成功    其他为错误代码
#                           msg:  错误信息

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"


FUNCTION cs_ins_qcs(p_rva01,p_rvb02,p_user)
DEFINE p_rva01          LIKE rva_file.rva01
DEFINE p_rvb02          LIKE rvb_file.rvb02
DEFINE l_ret            RECORD
             success    LIKE type_file.chr1,
             code       LIKE type_file.chr10,
             msg        STRING
                        END RECORD
DEFINE l_rva            RECORD LIKE rva_file.*
DEFINE l_rvb            RECORD LIKE rvb_file.*
DEFINE l_qcs            RECORD LIKE qcs_file.*
DEFINE l_qcs22_e        LIKE qcs_file.qcs22       #已送验量
DEFINE l_type           LIKE type_file.chr20
DEFINE l_ecm04          LIKE ecm_file.ecm04
DEFINE l_pmm            RECORD LIKE pmm_file.*
DEFINE l_pmn            RECORD LIKE pmn_file.*
DEFINE p_user           LIKE gen_file.gen01
DEFINE l_user           LIKE gen_file.gen01
DEFINE l_grup           LIKE gem_file.gem01
DEFINE l_ima906         LIKE ima_file.ima906
DEFINE l_ima44          LIKE ima_file.ima44


    INITIALIZE l_ret TO NULL
    LET l_ret.success = 'Y'

    IF cl_null(p_rva01) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "无收货单号！"
        RETURN l_ret.*
    END IF 

    IF cl_null(p_rvb02) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "无收货项次"
    END IF 

    INITIALIZE l_rva TO NULL
    SELECT * INTO l_rva.* FROM rva_file
     WHERE rva01 = p_rva01
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.code = SQLCA.SQLCODE 
        LET l_ret.msg = "cs_ins_qcs() select rva error:",cl_getmsg(SQLCA.SQLCODE,g_lang)
        RETURN l_ret.*
    END IF 

    SELECT * INTO l_rvb.* FROM rvb_file 
     WHERE rvb01 = p_rva01
       AND rvb02 = p_rvb02
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.code = SQLCA.SQLCODE 
        LET l_ret.msg = "cs_ins_qcs() select rvb error:",cl_getmsg(SQLCA.SQLCODE,g_lang)
        RETURN l_ret.*
    END IF 

    IF cl_null(l_rvb.rvb39) THEN 
        LET l_rvb.rvb39 = 'N'
    END IF 
    IF l_rvb.rvb39 = 'N' THEN 
        RETURN l_ret.*
    END IF 

    IF cl_null(p_user) THEN 
        LET l_user = l_rva.rvauser
        LET l_grup = l_rva.rvagrup
    ELSE 
        LET l_user = p_user
        SELECT gen03 INTO l_grup FROM gen_file 
         WHERE gen01 = l_user
    END IF 

    INITIALIZE l_qcs TO NULL 

    LET l_qcs.qcs00 = '1'                        #资料来源
    LET l_qcs.qcs01 = l_rvb.rvb01                #来源单号
    LET l_qcs.qcs02 = l_rvb.rvb02                #来源项次
    LET l_qcs.qcs021= l_rvb.rvb05                #料号    
    LET l_qcs.qcs03 = l_rva.rva05                #供应商编号
    LET l_qcs.qcs04 = g_today                    #检验日期
    LET l_qcs.qcs041= TIME                       #检验时间
    SELECT NVL(MAX(qcs05),0)+1 
      INTO l_qcs.qcs05                           #检验批号
      FROM qcs_file
     WHERE qcs01= l_rva.rva01 
       AND qcs02 = l_rvb.rvb02
   #LET l_qcs.qcs06 =                            #检验量
   #LET l_qcs.qcs061=                            #No use
   #LET l_qcs.qcs062=                            #No use
   #LET l_qcs.qcs071=                            #No use
   #LET l_qcs.qcs072=                            #No use
   #LET l_qcs.qcs081=                            #No use
   #LET l_qcs.qcs082=                            #No use
    LET l_qcs.qcs09 = '1'                        #判定结果    

   #获取已经送检量
    INITIALIZE l_qcs22_e TO NULL
    SELECT SUM(qcs22) 
      INTO l_qcs22_e
      FROM qcs_file
     WHERE qcs00 = '1' 
       AND qcs01 = l_rva.rva01
       AND qcs02 = l_rvb.rvb02 
       AND qcs14 <> 'X'
    IF cl_null(l_qcs22_e) THEN 
        LET l_qcs22_e = 0
    END IF 
    LET l_qcs.qcs22 = l_rvb.rvb07 - l_qcs22_e    #送验量
    IF l_qcs.qcs22 = 0 THEN 
        RETURN l_ret.*
    END IF 
    LET l_qcs.qcs30 = l_rvb.rvb80                #单位一
    LET l_qcs.qcs31 = l_rvb.rvb81                #单位一换算率
    LET l_qcs.qcs32 = l_rvb.rvb82                #单位一数量
    LET l_qcs.qcs33 = l_rvb.rvb83                #单位二
    LET l_qcs.qcs34 = l_rvb.rvb84                #单位二换算率
    LET l_qcs.qcs35 = l_rvb.rvb85                #单位二数量 
    
    SELECT ima906,ima44 INTO l_ima906,l_ima44 FROM ima_file
     WHERE ima01 = l_qcs.qcs021
    IF g_sma.sma115 = 'Y' AND l_qcs22_e <> 0 THEN
        IF l_ima906 = '3' THEN
           LET l_qcs.qcs32 = l_qcs.qcs22
           IF l_qcs.qcs34 <> 0 THEN
              LET l_qcs.qcs35 = l_qcs.qcs22/l_qcs.qcs34
           ELSE
              LET l_qcs.qcs35 = 0
           END IF
        ELSE
           IF l_ima906 = '2' AND NOT cl_null(l_qcs.qcs34) AND l_qcs.qcs34 <>0 THEN  
              LET l_qcs.qcs32 = l_qcs.qcs22 MOD l_qcs.qcs34
              LET l_qcs.qcs35 = (l_qcs.qcs22 - l_qcs.qcs32) / l_qcs.qcs34
           END IF          
        END IF
    END IF

    LET l_qcs.qcs091=  l_qcs.qcs22
    LET l_qcs.qcs36 = l_qcs.qcs30
    LET l_qcs.qcs37 = l_qcs.qcs31
    LET l_qcs.qcs38 = l_qcs.qcs32
    LET l_qcs.qcs39 = l_qcs.qcs33
    LET l_qcs.qcs40 = l_qcs.qcs34
    LET l_qcs.qcs41 = l_qcs.qcs35
    LET l_qcs.qcs091= s_digqty(l_qcs.qcs091,l_ima44)
    LET l_qcs.qcs22 = s_digqty(l_qcs.qcs22,l_ima44)
    LET l_qcs.qcs32 = s_digqty(l_qcs.qcs32,l_qcs.qcs30)
    LET l_qcs.qcs35 = s_digqty(l_qcs.qcs35,l_qcs.qcs33)
    LET l_qcs.qcs38 = s_digqty(l_qcs.qcs38,l_qcs.qcs36)
    LET l_qcs.qcs41 = s_digqty(l_qcs.qcs41,l_qcs.qcs39)

   #LET l_qcs.qcs10 =     
   #LET l_qcs.qcs101=     
   #LET l_qcs.qcs11 =     
   #LET l_qcs.qcs12 =     
    LET l_qcs.qcs13 = l_user                     #检验员
    LET l_qcs.qcs14 = 'N'                        #确认码
   #LET l_qcs.qcs15 =                            #确认日期

    SELECT pmm_file.*,pmn_file.* 
      INTO l_pmm.*,l_pmn.*
      FROM pmm_file,pmn_file
     WHERE pmm01=l_rvb.rvb04 AND pmn02=l_rvb.rvb03
       AND pmm01=pmn01 

    LET l_ecm04=' '    
    LET l_type='1'    

    IF l_pmm.pmm02='SUB' THEN
        LET l_type = '2'
        IF cl_null(l_pmn.pmn43) OR l_pmn.pmn43=0 THEN
            LET  l_ecm04=' '
        ELSE
            SELECT ecm04 INTO l_ecm04 
              FROM ecm_file
             WHERE ecm01=l_pmn.pmn41 
               AND ecm03=l_pmn.pmn43 
               AND ecm012=l_pmn.pmn012                                                                                   
        END IF
    END IF

    SELECT pmn63 
      INTO l_qcs.qcs16                           #急料否
      FROM pmn_file
     WHERE pmn01=l_rvb.rvb04 
       AND pmn02=l_rvb.rvb03

    SELECT pmh16 
      INTO l_qcs.qcs17                           #级数
      FROM pmh_file
     WHERE pmh01=l_qcs.qcs021
       AND pmh02=l_qcs.qcs03
       AND pmh21=l_ecm04
       AND pmh22=l_type
       AND pmh23=' '

    SELECT pmh09 INTO l_qcs.qcs21                #IQC检验类型代码
      FROM pmh_file
     WHERE pmh01=l_qcs.qcs021
       AND pmh02=l_qcs.qcs03
       AND pmh21=l_ecm04
       AND pmh22=l_type
       AND pmh23=' '

   #LET l_qcs.qcs18 =                            #No Use
   #LET l_qcs.qcs19 =                            #No Use
   #LET l_qcs.qcs20 =                            #No Use


    LET l_qcs.qcsprno = 0   
    LET l_qcs.qcsacti = 'Y'
    LET l_qcs.qcsuser = l_user
    LET l_qcs.qcsgrup = l_grup    
   #LET l_qcs.qcsmodu =     
   #LET l_qcs.qcsdate =     
    LET l_qcs.qcsspc  = '0'    
    LET l_qcs.qcsplant= g_plant
    LET l_qcs.qcslegal= g_legal
    LET l_qcs.qcsoriu = l_user
    LET l_qcs.qcsorig = l_grup
   #LET l_qcs.qcsud01 =     
   #LET l_qcs.qcsud02 =     
   #LET l_qcs.qcsud03 =     
   #LET l_qcs.qcsud04 =     
   #LET l_qcs.qcsud05 =     
   #LET l_qcs.qcsud06 =     
   #LET l_qcs.qcsud07 =     
   #LET l_qcs.qcsud08 =     
   #LET l_qcs.qcsud09 =     
   #LET l_qcs.qcsud10 =     
   #LET l_qcs.qcsud11 =     
   #LET l_qcs.qcsud12 =     
   #LET l_qcs.qcsud13 =     
   #LET l_qcs.qcsud14 =     
   #LET l_qcs.qcsud15 =     

    INSERT INTO qcs_file VALUES(l_qcs.*)
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "cs_ins_qcs() insert into qcs_file error: ",cl_getmsg(SQLCA.SQLCODE,g_lang)
        LET l_ret.code = SQLCA.SQLCODE
        RETURN l_ret.*
    END IF 

    #插入检验明细

    RETURN l_ret.*
END FUNCTION 



