# Prog. Version..: '5.00.01-07.05.10(00010)'     #
# Pattern name...: cs_rvv_ins.4gl
# Descriptions...: 入库单单身产生函数
# Date & Author..: 16/01/01  By  LGe
# Note           : 传入值:  
# ...............: 返回值:  Y-成功; N-失败
#                           code: 0 成功    其他为错误代码
#                           msg:  错误信息  成功，则msg为单号

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

FUNCTION cs_ins_rvv(p_rvu01,p_rva01,p_rvb02,p_rvb07,p_imd01,p_ime01,p_rvb38)
DEFINE l_ret            RECORD
             success    LIKE type_file.chr1,
             code       LIKE type_file.chr10,
             msg        STRING
                        END RECORD
DEFINE l_rvv            RECORD LIKE rvv_file.*
DEFINE p_rvu01          LIKE rvu_file.rvu01      #入库单单头
DEFINE p_rva01          LIKE rva_file.rva01
DEFINE p_rvb02          LIKE rvb_file.rvb02
DEFINE p_rvb07          LIKE rvb_file.rvb07      
DEFINE p_imd01          LIKE imd_file.imd01      #仓库
DEFINE p_ime01          LIKE ime_file.ime01      #库位
DEFINE p_rvb38          LIKE rvb_file.rvb38      #批号
DEFINE l_rvb07          LIKE rvb_file.rvb07
DEFINE l_imd01          LIKE imd_file.imd01      #仓库
DEFINE l_ime01          LIKE ime_file.ime01      #库位
DEFINE l_rvu            RECORD LIKE rvu_file.*
DEFINE l_rva            RECORD LIKE rva_file.*
DEFINE l_rvb            RECORD LIKE rvb_file.*
DEFINE l_pmm21          LIKE pmm_file.pmm21      #税种
DEFINE l_pmm22          LIKE pmm_file.pmm22      #币种
DEFINE l_azi04          LIKE azi_file.azi04      #金额位数
DEFINE l_img09          LIKE img_file.img09      #库存单位
DEFINE l_i              LIKE type_file.num5
DEFINE l_flag           LIKE type_file.num5
DEFINE l_ima906         LIKE ima_file.ima906
DEFINE l_ima44          LIKE ima_file.ima44
DEFINE l_cnt            LIKE type_file.num10


    INITIALIZE l_ret TO NULL 
    LET l_ret.success = 'Y'
    LET l_ret.code = '0'

    IF cl_null(p_rvu01) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "cs_ins_rvv() 无入库单单号！"
        RETURN l_ret.*
    END IF 

    IF cl_null(p_rva01) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "cs_ins_rvv() 无收货单单号！"
        RETURN l_ret.*
    END IF 

    IF cl_null(p_rvb02) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "cs_ins_rvv() 无收货单项次！"
        RETURN l_ret.*
    END IF 

    LET l_rvb07 = p_rvb07
    IF cl_null(l_rvb07) THEN 
        LET l_rvb07 = 0
    END IF 

    LET l_imd01 = p_imd01
    LET l_ime01 = p_ime01

    INITIALIZE l_rvu TO NULL 
    SELECT * INTO l_rvu.* FROM rvu_file WHERE rvu01 = p_rvu01
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.code = SQLCA.SQLCODE 
        LET l_ret.msg = "cs_ins_rvv() select get rvu_file.* error:",cl_getmsg(SQLCA.SQLCODE,g_lang)
        RETURN l_ret.*
    END IF 

    INITIALIZE l_rva TO NULL 
    SELECT * INTO l_rva.* FROM rva_file WHERE rva01 = p_rva01
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.code = SQLCA.SQLCODE 
        LET l_ret.msg = "cs_ins_rvv() select get rva_file.* error:",cl_getmsg(SQLCA.SQLCODE,g_lang)
        RETURN l_ret.*
    END IF 

    INITIALIZE l_rvb TO NULL 
    SELECT * INTO l_rvb.* FROM rvb_file WHERE rvb01 = p_rva01 AND rvb02 = p_rvb02
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.code = SQLCA.SQLCODE 
        LET l_ret.msg = "cs_ins_rvv() select get rvb_file.* error:",cl_getmsg(SQLCA.SQLCODE,g_lang)
        RETURN l_ret.*
    END IF 

    IF l_rvb07 = 0 THEN 
        LET l_rvb07 = l_rvb.rvb07
    END IF 

   #IF cl_null(l_imd01) THEN 
        LET l_imd01 = l_rvb.rvb36
   #END IF 
   #IF cl_null(l_ime01) THEN 
        LET l_ime01 = l_rvb.rvb37
   #END IF 

   #临时处理下：
    INITIALIZE l_rvv TO NULL 

    LET l_rvv.rvv01 = p_rvu01                    #入库单单号
    SELECT NVL(MAX(rvv02),0)+1                   #入库单项次
      INTO l_rvv.rvv02
      FROM rvv_file 
     WHERE rvv01 = l_rvv.rvv01
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.code = SQLCA.SQLCODE 
        LET l_ret.msg = "cs_ins_rvv() select max rvv02 error:",cl_getmsg(SQLCA.SQLCODE,g_lang)
        RETURN l_ret.*
    END IF 
    LET l_rvv.rvv03 = l_rvu.rvu00                #异动类别
    LET l_rvv.rvv04 = l_rvb.rvb01                #收货单号
    LET l_rvv.rvv05 = l_rvb.rvb02                #收货项次
    LET l_rvv.rvv06 = l_rva.rva05                #送货厂商
    LET l_rvv.rvv09 = l_rvu.rvu03                #异动日期
    LET l_rvv.rvv17 = l_rvb07                    #数量
    LET l_rvv.rvv18 = l_rvb.rvb34                #工单编号
    LET l_rvv.rvv23 = 0                          #已请款匹配量
   #LET l_rvv.rvv24 =                            #保税过账否
    LET l_rvv.rvv25 = l_rvb.rvb35                #样品否
   #LET l_rvv.rvv26 =                            #退货理由
    LET l_rvv.rvv31 = l_rvb.rvb05                #料号
    LET l_rvv.rvv031= l_rvb.rvb051               #料名
   #SELECT ima35,ima36 INTO l_imd01,l_ime01 FROM ima_file 
   # WHERE ima01 = l_rvv.rvv31
    IF cl_null(l_ime01) THEN 
        LET l_ime01 = ' '
    END IF 
    IF cl_null(l_imd01) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "仓库为空！"
        RETURN l_ret.*
    END IF 

    LET l_rvv.rvv32 = l_imd01                    #仓库
    LET l_rvv.rvv33 = l_ime01                    #库位
    LET l_rvv.rvv34 = l_rvb.rvb38                #批号

    IF cl_null(l_rvv.rvv32) THEN 
        LET l_rvv.rvv32 = ' '
    END IF 
    IF cl_null(l_rvv.rvv33) THEN 
        LET l_rvv.rvv33 = ' '
    END IF 
    IF cl_null(l_rvv.rvv34) THEN 
        LET l_rvv.rvv34 = ' '
    END IF 

    LET l_rvv.rvv35 = l_rvb.rvb90                #单位
    LET l_rvv.rvv35_fac= l_rvb.rvb90_fac         #转换率
    IF cl_null(l_rvv.rvv35_fac) THEN 
        LET l_rvv.rvv35_fac = 1
    END IF 
    LET l_rvv.rvv36 = l_rvb.rvb04                #采购单号
    LET l_rvv.rvv37 = l_rvb.rvb03                #采购项次
    #根据采购单单号，获取币种和税种
    SELECT pmm21,pmm22,azi04 
      INTO l_pmm21,l_pmm22,l_azi04
      FROM pmm_file,azi_file
     WHERE pmm22 = azi01 
       AND pmm01 = l_rvv.rvv36

    LET l_rvv.rvv38 = l_rvb.rvb10                #单价
    LET l_rvv.rvv38t= l_rvb.rvb10t               #含税单价
    IF l_rvv.rvv17 = l_rvb.rvb07 THEN            #若数量相等，则以收货单数量为准
        LET l_rvv.rvv39 = l_rvb.rvb88
        LET l_rvv.rvv39t= l_rvb.rvb88t
    ELSE 
        LET l_rvv.rvv39 = cl_digcut((l_rvb.rvb10 * l_rvv.rvv17),l_azi04)    #金额
        LET l_rvv.rvv39t= cl_digcut((l_rvb.rvb10t* l_rvv.rvv17),l_azi04)    #含税金额
    END IF 
    LET l_rvv.rvv40 = 'N'                        #冲暂估否
   #LET l_rvv.rvv41 =                            #手册编号
   #LET l_rvv.rvv42 =                            #No Use
   #LET l_rvv.rvv43 =                            #No Use
    IF g_sma.sma115 = 'Y' THEN    #使用双单位
        LET l_rvv.rvv80 = l_rvb.rvb80
        LET l_rvv.rvv81 = l_rvb.rvb81
        LET l_rvv.rvv82 = l_rvb.rvb82
        LET l_rvv.rvv83 = l_rvb.rvb83
        LET l_rvv.rvv84 = l_rvb.rvb84
        LET l_rvv.rvv85 = l_rvb.rvb85
    END IF 
    LET l_rvv.rvv86 = l_rvb.rvb86                #计价单位
    LET l_rvv.rvv87 = l_rvb07                    #计价数量
    LET l_rvv.rvv930= l_rvb.rvb930               #成本中心
    LET l_rvv.rvv88 = 0                          #暂估数量
    LET l_rvv.rvv89 = 'N'                        #VMI退货否
    LET l_rvv.rvv10 = l_rvb.rvb42                #取价类型
    LET l_rvv.rvv11 = l_rvb.rvb43                #价格来源
    LET l_rvv.rvv12 = l_rvb.rvb44                #来源单号
    LET l_rvv.rvv13 = l_rvb.rvb45                #来源项次
    LET l_rvv.rvvplant=g_plant                   #所属营运中心
    LET l_rvv.rvvlegal=g_legal                   #所属法人
    LET l_rvv.rvv919= l_rvb.rvb919               #计划批号
    LET l_rvv.rvv22 = l_rvb.rvb22                #发票编号
   #LET l_rvv.rvv45 =                            #检验批号
   #LET l_rvv.rvv46 =                            #QC判定结果编码
   #LET l_rvv.rvv47 =                            #QC判定结果项次
   #LET l_rvv.rvvud01=
   #LET l_rvv.rvvud02=
   #LET l_rvv.rvvud03=
   #LET l_rvv.rvvud04=
   #LET l_rvv.rvvud05=
   #LET l_rvv.rvvud06=
   #LET l_rvv.rvvud07=
   #LET l_rvv.rvvud08=
   #LET l_rvv.rvvud09=
   #LET l_rvv.rvvud10=
   #LET l_rvv.rvvud11=
   #LET l_rvv.rvvud12=
   #LET l_rvv.rvvud13=
   #LET l_rvv.rvvud14=
   #LET l_rvv.rvvud15=
    #仓库不为空 且 仓库不为' ' 且非MISC 料件
    IF NOT cl_null(l_rvv.rvv32) AND l_rvv.rvv32 <> ' ' AND l_rvv.rvv31[1,4] <> 'MISC' THEN


        #
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt FROM img_file
         WHERE img01 = l_rvv.rvv31
           AND img02 = l_rvv.rvv32
           AND img03 = l_rvv.rvv33
           AND img04 = l_rvv.rvv34
        IF l_cnt = 0 THEN 
            CALL s_add_img(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,
                           l_rvv.rvv34,l_rvv.rvv01,l_rvv.rvv02,
                           l_rvu.rvu03)
        END IF 

     
        SELECT img09 INTO l_img09     #库存单位
          FROM img_file
         WHERE img01=l_rvv.rvv31 
           AND img02=l_rvv.rvv32
           AND img03=l_rvv.rvv33 
           AND img04=l_rvv.rvv34

        CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv35,l_img09)
            RETURNING l_i,l_rvv.rvv35_fac

        IF l_i = 1 THEN
            LET l_ret.success = 'N'
            LET l_ret.msg = "获取单位转换率失败！"
            RETURN l_ret.*
        END IF
  
        SELECT ima906,ima44
          INTO l_ima906,l_ima44
          FROM ima_file 
         WHERE ima01 = l_rvv.rvv31

        #sma115 使用双单位   ima906  单位使用方式    
        IF g_sma.sma115 = 'Y' AND l_ima906 MATCHES '[23]' THEN
            IF NOT cl_null(l_rvv.rvv83) THEN
                CALL s_chk_imgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv83) RETURNING l_flag

                IF l_flag = 1 THEN
                  CALL s_add_imgg(l_rvv.rvv31,l_rvv.rvv32,
                                  l_rvv.rvv33,l_rvv.rvv34,
                                  l_rvv.rvv83,l_rvv.rvv84,
                                  l_rvv.rvv01,l_rvv.rvv02,0) RETURNING l_flag
                    IF l_flag = 1 THEN
                        LET l_ret.success = 'N'
                        LET l_ret.msg = "cs_rvv_ins() s_add_img() error"
                        RETURN l_ret.*
                    END IF
                END IF
                CALL s_du_umfchk(l_rvv.rvv31,'','','',l_ima44,l_rvv.rvv83,l_ima906)
                     RETURNING g_errno,l_rvv.rvv84
                IF NOT cl_null(g_errno) THEN
                    LET l_ret.success = 'N'
                    LET l_ret.msg = "cs_rvv_ins() CALL s_du_umfchk error!"
                    RETURN l_ret.*
                END IF
            END IF

            IF NOT cl_null(l_rvv.rvv80) AND l_ima906 = '2' THEN
                CALL s_chk_imgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                                l_rvv.rvv80) RETURNING l_flag
                IF l_flag = 1 THEN
                  CALL s_add_imgg(l_rvv.rvv31,l_rvv.rvv32,
                                  l_rvv.rvv33,l_rvv.rvv34,
                                  l_rvv.rvv80,l_rvv.rvv81,
                                  l_rvv.rvv01,l_rvv.rvv02,0) RETURNING l_flag
                   IF l_flag = 1 THEN
                       LET l_ret.success = 'N'
                       LET l_ret.msg = "cs_rvv_ins() s_add_img() error"
                       RETURN l_ret.*
                   END IF
                END IF
                CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv80,l_ima44)
                     RETURNING l_i,l_rvv.rvv81
                IF l_i = 1 THEN
                    LET l_ret.success = 'N'
                    LET l_ret.msg = "cs_rvv_ins() CALL s_umfchk error!"
                    RETURN l_ret.*
                END IF
            END IF

            IF l_ima906 = '3' THEN
               IF l_rvv.rvv85 <> 0 THEN
                  LET l_rvv.rvv84=l_rvv.rvv82/l_rvv.rvv85
               ELSE
                  LET l_rvv.rvv84=0
               END IF
            END IF
        END IF
    END IF 

    INSERT INTO rvv_file VALUES(l_rvv.*) 
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.code = SQLCA.SQLCODE 
        LET l_ret.msg = "cs_rvv_ins() insert into rvv_file error:",cl_getmsg(SQLCA.SQLCODE,g_lang)
    ELSE 
        LET l_ret.code = l_rvv.rvv02
    END IF 

    RETURN l_ret.*





END FUNCTION 


