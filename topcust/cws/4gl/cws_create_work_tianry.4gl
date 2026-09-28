# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: cws_create_work.4gl
# Descriptions...: 创建开工数据
# Date & Author..: 16/06/06 By guanyao
# 160617: 16/06/17 By guanyao

DATABASE ds
 
#No.FUN-B10004
 
GLOBALS "../../../tiptop/config/top.global"
 
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
DEFINE g_cnt    LIKE type_file.num5
    DEFINE g_tc_shb      RECORD LIKE tc_shb_file.*
    DEFINE l_return   RECORD 
           code       LIKE type_file.chr10,
           msg        LIKE type_file.chr100
    END RECORD
 
#[
# Description....: 提供建立开工資料的服務(入口 function)
# Date & Author..: No.FUN-B10004 16/06/06 By guanyao
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION cws_create_work()
 
   WHENEVER ERROR CONTINUE
 
   CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
 
   #--------------------------------------------------------------------------#
   # 新增订單資料                                                       #
   #--------------------------------------------------------------------------#
   IF g_status.code = "0" THEN
      CALL cws_create_work_process()
   END IF
 
   CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
 
END FUNCTION
 
#[
# Description....: 开工数据
# Date & Author..: 16/06/06 By guanyao
# Parameter......: 
# Return.........: 
# Memo...........:
# Modify.........:
#
#]
FUNCTION cws_create_work_process()
    DEFINE l_cnt      LIKE type_file.num10
    DEFINE l_node1    om.DomNode
    DEFINE l_tc_shb01   LIKE tc_shb_file.tc_shb01
    DEFINE l_tc_shb03   LIKE tc_shb_file.tc_shb03
    DEFINE l_y       LIKE type_file.chr20 
    DEFINE l_m       LIKE type_file.chr20
    DEFINE l_d       LIKE type_file.chr20
    DEFINE l_str       LIKE type_file.chr20
    DEFINE l_tmp       LIKE type_file.chr20
    DEFINE l_tc_shb12_2    LIKE tc_shb_file.tc_shb12
    DEFINE l_tc_shb12_1    LIKE tc_shb_file.tc_shb12
    DEFINE l_tc_shc12      LIKE tc_shc_file.tc_shc12
    DEFINE l_tc_shb12      LIKE tc_shb_file.tc_shb12  #add by guanyao160731
    #str-----add by guanyao160808
    DEFINE l_tc_shb12_f        LIKE tc_shb_file.tc_shb12
    DEFINE l_sgm03             LIKE sgm_file.sgm03
    DEFINE l_ta_ecd04          LIKE ecd_file.ta_ecd04
    DEFINE l_shm08             LIKE shm_file.shm08
    DEFINE l_ta_shm04          LIKE shm_file.ta_shm04
    DEFINE l_tc_shb12_a        LIKE tc_shb_file.tc_shb12
    DEFINE l_ta_ecd04_b        LIKE ecd_file.ta_ecd04
    #end-----add by guanyao160808
    #str----add by guanyao160903
    DEFINE l_ima153        LIKE ima_file.ima153
    DEFINE l_over_qty      LIKE sfv_file.sfv09
    #end----add by guanyao160903
    DEFINE l_yong          LIKE tc_shb_file.tc_shb12  #add by guanyao160904
    DEFINE l_sfbud05       LIKE sfb_file.sfbud05     #add by guanyao160907
    DEFINE l_ta_sgm06      LIKE sgm_file.ta_sgm06    #tianry add 161219
    DEFINE p_tc_shb        RECORD LIKE tc_shb_file.*   
    DEFINE l_tttt       LIKE oga_file.oga01
    DEFINE l_sgm04      LIKE sgm_file.sgm04 


    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的订單資料                                    #
    #--------------------------------------------------------------------------#
    INITIALIZE g_tc_shb.* TO NULL
    LET l_tc_shb01 = aws_ttsrv_getParameter("tc_shb01")
    IF cl_null(l_tc_shb01) THEN 
       LET g_status.code = '-1'
       LET g_status.description = '没有资料性质'
       LET l_return.code="-1"
       LET l_return.msg = "开工信息录入失败"
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       RETURN 
    ELSE
       IF l_tc_shb01<>'1' THEN 
          LET g_status.code = '-1'
          LET g_status.description = '资料类比不是开工类别'
          LET l_return.code="-1"
          LET l_return.msg = "开工信息录入失败"
          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
          RETURN
       END IF
    END IF 
    LET l_tc_shb03 = aws_ttsrv_getParameter("tc_shb03")
    IF cl_null(l_tc_shb03) THEN
       LET g_status.code = '-1'
       LET g_status.description = '没有报工信息'
       LET l_return.code="-1"
       LET l_return.msg = "开工信息录入失败"
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       RETURN 
    END IF 
    LET g_tc_shb.tc_shb06 = aws_ttsrv_getParameter("tc_shb06")   #mark by guanyao160620
    IF cl_null(g_tc_shb.tc_shb06) THEN  #mark by guanyao160620
    #LET g_tc_shb.tc_shb08 = aws_ttsrv_getParameter("tc_shb06") #add by guanyao160620
    #IF cl_null(g_tc_shb.tc_shb08) THEN  #add by guanyao160620
       LET g_status.code = '-1'
       LET g_status.description = '没有作业编号'
       LET l_return.code="-1"
       LET l_return.msg = "开工信息录入失败"
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       RETURN 
    ELSE 
       #str----add by guanyao160620
       #SELECT sgm03 INTO g_tc_shb.tc_shb06 FROM sgm_file WHERE sgm01 = l_tc_shb03 AND sgm04 = g_tc_shb.tc_shb08
       #IF cl_null(g_tc_shb.tc_shb06) THEN 
       #   LET g_status.code = '-1'
       #   LET g_status.description = '没有工艺序号'
       #   LET l_return.code="-1"
       #   LET l_return.msg = "扫描信息录入失败"
       #   CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       #   RETURN
       #END IF 
       #end----add by guanyao160620
    END IF
    LET g_tc_shb.tc_shb11 = aws_ttsrv_getParameter("tc_shb11")
    IF cl_null(g_tc_shb.tc_shb11) THEN
       LET g_status.code = '-1'
       LET g_status.description = '没有报工人员编号'
       LET l_return.code="-1"
       LET l_return.msg = "开工信息录入失败"
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       RETURN 
    END IF
    LET g_tc_shb.tc_shb12 = aws_ttsrv_getParameter("tc_shb12")
    IF cl_null(g_tc_shb.tc_shb12) OR g_tc_shb.tc_shb12< = 0 THEN
       LET g_status.code = '-1'
       LET g_status.description = '没有数量或者数量小于等于0'
       LET l_return.code="-1"
       LET l_return.msg = "开工信息录入失败"
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       RETURN 
    END IF
    
    LET g_tc_shb.tc_shb01 = l_tc_shb01
    LET g_tc_shb.tc_shb03 = l_tc_shb03
    LET g_tc_shb.tc_shb13 = aws_ttsrv_getParameter("tc_shb13")
    LET g_tc_shb.tc_shbud09 = aws_ttsrv_getParameter("pnl")  #add by guanyao160728
    #str------mark by guanyao160808
    --SELECT SUM (tc_shc12) INTO l_tc_shc12
      --FROM tc_shc_file 
     --WHERE tc_shc03 = g_tc_shb.tc_shb03
       --AND tc_shc06 = g_tc_shb.tc_shb06
       --AND tc_shc01 = '1'
    --IF cl_null(l_tc_shc12) OR l_tc_shc12=0 THEN 
       --LET g_status.code = '-1'
       --LET g_status.description = '没有扫描数据'
       --LET l_return.code="-1"
       --LET l_return.msg = "开工信息录入失败"
       --CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       --RETURN
    --ELSE
       --IF  l_tc_shc12 < g_tc_shb.tc_shb12 THEN 
          --LET g_status.code = '-1'
          --LET g_status.description = '开工数量不能大于扫描数量'
          --LET l_return.code="-1"
          --LET l_return.msg = "开工信息录入失败"
          --CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
          --RETURN 
       --END IF 
    --END IF 
    #end------mark by guanyao160808
       
     #tianry add 161219
   # SELECT ta_sgm06 INTO l_ta_sgm06 FROM sgm_file WHERE sgm01=l_tc_shb03 AND sgm03=g_tc_shb.tc_shb06
   # IF cl_null(l_ta_sgm06) OR l_ta_sgm06='N' THEN
   #    LET g_status.code = '-1'
   #    LET g_status.description = '此作业编号为非报工'
   #    LET l_return.code="-1"
   #    LET l_return.msg = "开工信息录入失败"
   #    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
   #    RETURN
   # END IF 

     #tianry add end 161219

    #单据编号
    LET l_y =YEAR(g_today)
    LET l_y = l_y[3,4] USING '&&' 
    LET l_m =MONTH(g_today)
    LET l_m = l_m USING '&&' 
    #str---add by guanyao160806
    LET l_d = DAY(g_today)
    LET l_d = l_d USING '&&'
    #end---add by guanyao160806
    LET l_str='KGB-',l_y clipped,l_m CLIPPED,l_d CLIPPED
    SELECT max(substr(tc_shb02,11,20)) INTO l_tmp FROM tc_shb_file
    WHERE substr(tc_shb02,1,10)=l_str
    IF cl_null(l_tmp) THEN 
       LET l_tmp = '0000000001' 
    ELSE 
       LET l_tmp = l_tmp + 1
       LET l_tmp = l_tmp USING '&&&&&&&&&&'     
    END IF 
    LET g_tc_shb.tc_shb02 = l_str clipped,l_tmp
    IF cl_null(g_tc_shb.tc_shb02) THEN 
       LET g_status.code = '-1'
       LET g_status.description = '没有单据编号'
       LET l_return.code="-1"
       LET l_return.msg = "开工信息录入失败"
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       RETURN 
    END IF 

    #数量的判断，同一个人，同一个工艺，同一个lot单必须先完工才能继续生成一笔数据
    #1、同一个人的完工+返工+报废  = 开工才可以再次开工
    #2、返工可以不同的人进行返工,判断0<数量 =<(扫入量-开工+返工) 
    #end-----add by guanyao160808
    --IF g_tc_shb.tc_shb01 = '1' THEN 
       #str------add by guanyao160731  #总返工量
       --SELECT SUM(tc_shb122) INTO l_tc_shb12 FROM tc_shb_file
        --WHERE tc_shb03= g_tc_shb.tc_shb03 
          --AND tc_shb06= g_tc_shb.tc_shb06
          --AND tc_shb01 = '2'
       --IF cl_null(l_tc_shb12) THEN  
          --LET l_tc_shb12 = 0
       --END IF 
       #end------add by guanyao160731
       --SELECT tc_shb12 INTO l_tc_shb12_1 FROM tc_shb_file 
        --WHERE tc_shb03= g_tc_shb.tc_shb03 
          --AND tc_shb06= g_tc_shb.tc_shb06
          --AND tc_shb11= g_tc_shb.tc_shb11
          --AND tc_shb01 = '1'
       --SELECT SUM(tc_shb12+tc_shb121+tc_shb122) INTO l_tc_shb12_2 FROM tc_shb_file 
        --WHERE tc_shb03= g_tc_shb.tc_shb03 
          --AND tc_shb06= g_tc_shb.tc_shb06
          --AND tc_shb11= g_tc_shb.tc_shb11
          --AND tc_shb01 = '2'
       --IF ((cl_null(l_tc_shb12_2) OR (l_tc_shb12_2<>l_tc_shb12_1)) AND l_tc_shb12_1>0) 
          --OR (cl_null(l_tc_shb12_1) AND l_tc_shb12_1= 0 AND l_tc_shb12_2>0 ) THEN  #add by guanyao160731
          --LET g_status.code = '-1'
          --LET g_status.description = '有未完工的资料，请先完工此笔资料'
          --LET l_return.code="-1"
          --LET l_return.msg = "开工信息录入失败"
          --CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
          --RETURN 
       --END IF 
       #str-----add by guanyao160731
       --IF l_tc_shc12 - l_tc_shb12_1+ l_tc_shb12 <g_tc_shb.tc_shb12 THEN 
          --LET g_status.code = '-1'
          --LET g_status.description = '数量大于扫入量+返工量-开工量'
          --LET l_return.code="-1"
          --LET l_return.msg = "开工信息录入失败"
          --CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
          --RETURN 
       --END IF 
       #end-----add by guanyao160731
    --END IF 

    #人员检核
    SELECT COUNT(*) INTO l_cnt FROM gen_file
     WHERE gen01=g_tc_shb.tc_shb11
       AND genacti = 'Y'
    IF l_cnt = 0 THEN
       LET g_status.code = '-1'
       LET g_status.description = '人员资料错误'
       LET l_return.code="-1"
       LET l_return.msg = "开工信息录入失败"
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       RETURN 
    END IF

    #班别检核
    SELECT COUNT(*) INTO l_cnt FROM ecg_file 
     WHERE ecg01 = g_tc_shb.tc_shb13
       AND ecgacti = 'Y'
    IF l_cnt = 0 THEN
       LET g_status.code = '-1'
       LET g_status.description = '班别有错误'
       LET l_return.code="-1"
       LET l_return.msg = "开工信息录入失败"
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       RETURN 
    END IF
    #str----add by guanyao160617
    #SELECT shm012,shm05,shm06,ecu03 
    #  INTO g_tc_shb.tc_shb04,g_tc_shb.tc_shb05,g_tc_shb.tc_shb07,g_tc_shb.tc_shb08
    #  FROM shm_file LEFT JOIN ecu_file ON ecu01= shm05 AND ecu02 = shm06
    # WHERE shm01 = g_tc_shb.tc_shb03 
    #SELECT sgm52,sgm58    #mark by guanyao160617
    #  INTO g_tc_shb.tc_shb10,g_tc_shb.tc_shb16 #mark by guanyao160617
    # SELECT sgm58 INTO g_tc_shb.tc_shb16   #add by guanyao160617
    #  FROM sgm_file WHERE sgm01 = g_tc_shb.tc_shb03 AND sgm03 = g_tc_shb.tc_shb06
    #SELECT tc_shc10,tc_shc16 INTO g_tc_shb.tc_shb10,g_tc_shb.tc_shb16 FROM tc_shc_file   
    # WHERE tc_shc03 = g_tc_shb.tc_shb03
    #   AND tc_shc06 = g_tc_shb.tc_shb06 
    #   AND tc_shc01 = '1'
    #end----add by guanyao160617

    #str----add by guanyao160617
    SELECT shm012,sgm03_par,shm06,sgm04,sgm06,sgm52,sgm58 
         INTO g_tc_shb.tc_shb04,g_tc_shb.tc_shb05,g_tc_shb.tc_shb07,g_tc_shb.tc_shb08,  #add by guanyao160617
              g_tc_shb.tc_shb09,g_tc_shb.tc_shb10,g_tc_shb.tc_shb16 FROM sgm_file,shm_file                      #add by guanyao160617
        WHERE sgm01 = g_tc_shb.tc_shb03
          AND sgm03 = g_tc_shb.tc_shb06 
          AND sgm01 = shm01
    #end----add by guanyao160617

    #str----add by guanyao160907
    SELECT sfbud05 INTO l_sfbud05 FROM sfb_file WHERE sfb01 = g_tc_shb.tc_shb04 
    IF cl_null(l_sfbud05) THEN 
       LET l_sfbud05 = 'N'
    END IF 
    #end----add by guanyao160907

    #str------add by guanyao160808
    ################算出已开工数量以及判断此人是否还有未完工数量----str
    SELECT SUM(tc_shb12) INTO l_tc_shb12 FROM tc_shb_file  #已开工的数量
     WHERE tc_shb01 = '1'
       AND tc_shb03 = g_tc_shb.tc_shb03
       AND tc_shb06 = g_tc_shb.tc_shb06
    IF cl_null(l_tc_shb12) THEN 
       LET l_tc_shb12 = 0
    END IF 
    IF l_tc_shb12 >0 THEN   
       SELECT SUM(tc_shb12) INTO l_tc_shb12_1 FROM tc_shb_file  #已开工的数量大于的时候需要判断此人开工量和完工量是否相同
        WHERE tc_shb01 = '1'
          AND tc_shb03 = g_tc_shb.tc_shb03
          AND tc_shb06 = g_tc_shb.tc_shb06
          AND tc_shb11 = g_tc_shb.tc_shb11
       IF cl_null(l_tc_shb12_1) THEN 
          LET l_tc_shb12_1 = 0
       END IF                
       IF l_tc_shb12_1 >0 THEN
          SELECT SUM(tc_shb12+tc_shb121+tc_shb122) INTO l_tc_shb12_2 FROM tc_shb_file 
           WHERE tc_shb01 = '2'
             AND tc_shb03 = g_tc_shb.tc_shb03
             AND tc_shb06 = g_tc_shb.tc_shb06
             AND tc_shb11 = g_tc_shb.tc_shb11
          IF cl_null(l_tc_shb12_2) THEN 
             LET l_tc_shb12_2 = 0
          END IF 
          #IF l_tc_shb12_2 < l_tc_shb12_1 IS NULL  THEN  #mark by guanyao160921
          IF l_tc_shb12_2 < l_tc_shb12_1   THEN    #add by guanyao160921
             LET g_status.code = '-1'
             LET g_status.description = '有未完工的资料，请先完工此笔资料'
             LET l_return.code="-1"
             LET l_return.msg = "开工信息录入失败"
             CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
             RETURN 
          END IF 
       END IF 
    END IF
    SELECT SUM(tc_shb122) INTO l_tc_shb12_f FROM tc_shb_file  #此笔工艺返工量
     WHERE tc_shb03= g_tc_shb.tc_shb03 
       AND tc_shb06= g_tc_shb.tc_shb06
       AND tc_shb01 = '2'
    IF cl_null(l_tc_shb12_f) THEN  
       LET l_tc_shb12_f = 0
    END IF 
    #str-----add by guanyao160831#返工的需要确定一下
    #IF l_tc_shb12_f>0 THEN 
    #   SELECT SUM(tc_shc12) INTO l_tc_shb12_a FROM tc_shc_file 
    #    WHERE tc_shc03 = g_tc_shb.tc_shb03
    #      AND tc_shc06 = g_tc_shb.tc_shb06 
    #      AND tc_shc01 = '1'
    #   IF NOT cl_null(l_tc_shb12_a) THEN 
    #      IF l_tc_shb12 > l_tc_shb12_a THEN 
    #         LET g_tc_shb.tc_shbud04 = 'Y'
    #      END IF 
    #   END IF 
    #END IF 
    #end-----add by guanyao160831
    ################算出已开工数量以及判断此人是否还有未完工数量----end
    LET l_sgm03 = ''
    LET l_ta_ecd04 = ''
    SELECT MAX(sgm03) INTO l_sgm03 FROM sgm_file WHERE sgm01 = g_tc_shb.tc_shb03 AND sgm03<g_tc_shb.tc_shb06 #求出是否是第一道工艺
    SELECT ta_ecd04 INTO l_ta_ecd04 FROM ecd_file,sgm_file 
     WHERE ecd01 = sgm04
       AND sgm01 = g_tc_shb.tc_shb03
       AND sgm03 = g_tc_shb.tc_shb06
    IF cl_null(l_ta_ecd04) THEN 
       LET l_ta_ecd04 = 'N'
    END IF 
    IF cl_null(l_sgm03) THEN  #第一道工艺
       IF l_ta_ecd04 = 'Y' THEN   #总数量扫入
          #str-----add by guanyao160903  勾稽为Y之后执行报工扫入检查最小发料套数
          IF l_sfbud05 = 'Y' THEN  #add by guanyao160908
          ELSE 
          IF g_sma.smaud02 = 'Y' THEN  
             IF g_sma.sma73 = 'Y' THEN  #求出最小发料套数  临时取消
                CALL s_get_ima153(g_tc_shb.tc_shb05) RETURNING l_ima153
                CALL s_minp(g_tc_shb.tc_shb04,g_sma.sma73,l_ima153,g_tc_shb.tc_shb08,'','',g_today)
                   RETURNING l_cnt,l_over_qty
                IF cl_null(l_over_qty) THEN LET l_over_qty = 0 END IF
                #str---add by guanyao160904
                LET l_yong = 0
                SELECT SUM(tc_shb12) INTO l_yong FROM tc_shb_file 
                 WHERE tc_shb04 = g_tc_shb.tc_shb04 
                   AND tc_shb08 = g_tc_shb.tc_shb08
                   AND tc_shb01 = '2'
                IF cl_null(l_yong) THEN 
                   LET l_yong = 0
                END IF
                LET  l_over_qty = l_over_qty-l_yong
                #end---add by guanyao160904
             END IF
             IF l_over_qty<g_tc_shb.tc_shb12 THEN 
                LET g_status.code = '-1'
                LET g_status.description = '数量大于齐套发料量'
                LET l_return.code="-1"
                LET l_return.msg = "开工信息录入失败"
                CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
                RETURN 
             END IF 
          END IF 
          END IF 
          #end-----add by guanyao160903
          SELECT shm08 INTO l_shm08 FROM shm_file WHERE shm01 =g_tc_shb.tc_shb03  #此张LOT剩余数量
          IF cl_null(l_shm08) THEN   
             LET g_status.code = '-1'
             LET g_status.description = 'LOT单上没有数量'
             LET l_return.code="-1"
             LET l_return.msg = "开工信息录入失败"
             CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
             RETURN 
          END IF
          LET l_ta_shm04 = ''
          SELECT ta_shm04 INTO l_ta_shm04 FROM shm_file WHERE shm01 = g_tc_shb.tc_shb03
          IF cl_null(l_ta_shm04) THEN 
             LET l_ta_shm04 = 'N'
          END IF 
          IF l_ta_shm04  = 'Y' THEN #期初
             IF g_tc_shb.tc_shb12 > l_shm08 THEN 
                LET g_status.code = '-1'
                LET g_status.description = '录入数量大于lot单数量'
                LET l_return.code="-1"
                LET l_return.msg = "开工信息录入失败"
                CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
                RETURN 
             END IF 
          ELSE 
             IF g_tc_shb.tc_shb12>(l_shm08+l_tc_shb12_f-l_tc_shb12) THEN  #非期初要减去已开工数量
                LET g_status.code = '-1'
                LET g_status.description = '开工数量大于可开工量'
                LET l_return.code="-1"
                LET l_return.msg = "开工信息录入失败"
                CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
                RETURN 
             END IF 
          END IF 
       ELSE 
          SELECT SUM(tc_shc12) INTO l_tc_shc12 FROM tc_shc_file
           WHERE tc_shc03= g_tc_shb.tc_shb03 
             AND tc_shc06= g_tc_shb.tc_shb06
             AND tc_shc01 = '1'
          IF cl_null(l_tc_shc12) THEN 
             LET l_tc_shc12 = 0
          END IF  
          IF l_tc_shc12 <=0 THEN 
             LET g_status.code = '-1'
             LET g_status.description = '没有扫描数量'
             LET l_return.code="-1"
             LET l_return.msg = "开工信息录入失败"
             CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
             RETURN 
          END IF 
          IF g_tc_shb.tc_shb12 >(l_tc_shc12+l_tc_shb12_f-l_tc_shb12) THEN #不是包装要减去已开工数量
             LET g_status.code = '-1'
             LET g_status.description = '数量大于开工数量1'
             LET l_return.code="-1"
             LET l_return.msg = "开工信息录入失败"
             CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
             RETURN 
          END IF 
          #str-----add by guanyao160928  勾稽为Y之后执行报工扫入检查最小发料套数##########现在扫入不管控数量，开工管控
          IF l_sfbud05 = 'Y' THEN  #add by guanyao160908
          ELSE 
             IF g_sma.smaud02 = 'Y' THEN  
                IF g_sma.sma73 = 'Y' THEN  #求出最小发料套数  临时取消
                   CALL s_get_ima153(g_tc_shb.tc_shb05) RETURNING l_ima153
                   CALL s_minp(g_tc_shb.tc_shb04,g_sma.sma73,l_ima153,g_tc_shb.tc_shb08,'','',g_today)
                      RETURNING l_cnt,l_over_qty
                   IF cl_null(l_over_qty) THEN LET l_over_qty = 0 END IF
                   #str---add by guanyao160904
                   LET l_yong = 0
                   SELECT SUM(tc_shb12) INTO l_yong FROM tc_shb_file 
                    WHERE tc_shb04 = g_tc_shb.tc_shb04 
                      AND tc_shb08 = g_tc_shb.tc_shb08
                      AND tc_shb01 = '2'
                   IF cl_null(l_yong) THEN 
                      LET l_yong = 0
                   END IF
                   LET  l_over_qty = l_over_qty-l_yong
                   #end---add by guanyao160904
                END IF
                IF l_over_qty>0 THEN 
                   IF l_over_qty<g_tc_shb.tc_shb12 THEN 
                    #tianry add 161110
                      IF (g_tc_shb.tc_shb12-l_over_qty <= 5) OR ((g_tc_shb.tc_shb12-l_over_qty)/l_over_qty <=0.001) THEN
                      ELSE

                          LET g_status.code = '-1'
                          LET g_status.description = '数量大于齐套发料量'
                          LET l_return.code="-1"
                          LET l_return.msg = "开工信息录入失败"
                          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
                          RETURN 
                      END IF 
                   END IF 
                ELSE
                   LET g_status.code = '-1'
                    LET g_status.description = '数量大于齐套发料量' 
                    LET l_return.code="-1"
                    LET l_return.msg = "开工信息录入失败" 
                    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
                    RETURN 
                END IF
             END IF 
          END IF 
          #end-----add by guanyao160928
       END IF 
    ELSE#非第一道工艺
       LET l_ta_ecd04_b = ''
       SELECT ta_ecd04 INTO l_ta_ecd04_b FROM ecd_file,tc_shb_file
        WHERE ecd01 = tc_shb08 
          AND tc_shb03 = g_tc_shb.tc_shb03
          AND tc_shb06 = l_sgm03
       IF cl_null(l_ta_ecd04_b) THEN 
          LET l_ta_ecd04_b = 'N'
       END IF 
       IF l_ta_ecd04 ='Y' THEN 
          #str-----add by guanyao160903  勾稽为Y之后执行报工扫入检查最小发料套数
          IF l_sfbud05 = 'Y' THEN   #add by guanyao160908
          ELSE 
          IF g_sma.smaud02 = 'Y' THEN  
             IF g_sma.sma73 = 'Y' THEN  #求出最小发料套数  临时取消
                CALL s_get_ima153(g_tc_shb.tc_shb05) RETURNING l_ima153
                CALL s_minp(g_tc_shb.tc_shb04,g_sma.sma73,l_ima153,g_tc_shb.tc_shb08,'','',g_today)
                  RETURNING l_cnt,l_over_qty
                IF cl_null(l_over_qty) THEN LET l_over_qty = 0 END IF
                #str---add by guanyao160904
                LET l_yong = 0
                SELECT SUM(tc_shb12) INTO l_yong FROM tc_shb_file 
                 WHERE tc_shb04 = g_tc_shb.tc_shb04 
                   AND tc_shb08 = g_tc_shb.tc_shb08
                   AND tc_shb01 = '2'
                IF cl_null(l_yong) THEN 
                   LET l_yong = 0
                END IF
                LET  l_over_qty = l_over_qty-l_yong
                #end---add by guanyao160904
             END IF
             IF l_over_qty<g_tc_shb.tc_shb12 THEN 
                LET g_status.code = '-1'
                LET g_status.description = '数量大于齐套发料量'
                LET l_return.code="-1"
                LET l_return.msg = "开工信息录入失败"
                CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
                RETURN 
             END IF 
          END IF 
          END IF 
          #end-----add by guanyao160903
          LET l_shm08 = ''
          SELECT shm08 INTO l_shm08 FROM shm_file WHERE shm01 =g_tc_shb.tc_shb03  #此张LOT剩余数量
          IF cl_null(l_shm08) THEN   
             LET g_status.code = '-1'
             LET g_status.description = 'LOT单上没有数量'
             LET l_return.code="-1"
             LET l_return.msg = "开工信息录入失败"
             CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
             RETURN 
          END IF
          LET l_ta_shm04 = ''
          SELECT ta_shm04 INTO l_ta_shm04 FROM shm_file WHERE shm01 = g_tc_shb.tc_shb03
          IF cl_null(l_ta_shm04) THEN LET l_ta_shm04 = 'N' END IF 
          IF l_ta_shm04  = 'Y' THEN     #期初
             IF g_tc_shb.tc_shb12 > l_shm08 THEN 
                LET g_status.code = '-1'
                LET g_status.description = '录入数量大于lot单数量'
                LET l_return.code="-1"
                LET l_return.msg = "开工信息录入失败"
                CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
                RETURN 
             END IF 
          ELSE    #非期初，前一道工艺是包装
             IF l_ta_ecd04_b = 'Y' THEN 
                SELECT SUM(tc_shb12+tc_shb121+tc_shb122) INTO l_tc_shc12 FROM tc_shb_file
                 WHERE tc_shb01 = '1'
                   AND tc_shb03 = g_tc_shb.tc_shb03
                   AND tc_shb06 = l_sgm03
                IF cl_null(l_tc_shc12) OR l_tc_shc12 = 0 THEN 
                   LET g_status.code = '-1'
                   LET g_status.description = '前一道工艺没有完工量'
                   LET l_return.code="-1"
                   LET l_return.msg = "开工信息录入失败"
                   CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
                   RETURN 
                END IF 
                IF g_tc_shb.tc_shb12 >l_tc_shb12_f+ l_tc_shc12-l_tc_shb12 THEN #上一站完工数量+返工数量-已开工数量
                   LET g_status.code = '-1'
                   LET g_status.description = '数量大于开工数量2'
                   LET l_return.code="-1"
                   LET l_return.msg = "开工信息录入失败"
                   CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
                   RETURN 
                END IF 
             ELSE #非期初，前一道工艺是非包装
                SELECT SUM(tc_shc12) INTO l_tc_shc12 FROM tc_shc_file
                 WHERE tc_shc01 = '2'
                   AND tc_shc03 = g_tc_shb.tc_shb03
                   AND tc_shc06 = l_sgm03
                IF cl_null(l_tc_shc12) OR l_tc_shc12 =0 THEN 
                   LET g_status.code = '-1'
                   LET g_status.description = '前一道工艺没有扫出'
                   LET l_return.code="-1"
                   LET l_return.msg = "开工信息录入失败"
                   CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
                   RETURN
                END IF
                IF g_tc_shb.tc_shb12 >l_tc_shb12_f+ l_tc_shc12-l_tc_shb12 THEN #上一站扫出数量+返工数量-已开工数量
                   LET g_status.code = '-1'
                   LET g_status.description = '数量大于开工数量3'
                   LET l_return.code="-1"
                   LET l_return.msg = "开工信息录入失败"
                   CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
                   RETURN
                END IF 
             END IF 
          END IF 
       ELSE #本道工艺不是包装
          SELECT SUM(tc_shc12) INTO l_tc_shc12 FROM tc_shc_file
           WHERE tc_shc01 = '1'
             AND tc_shc03 = g_tc_shb.tc_shb03
             AND tc_shc06 = g_tc_shb.tc_shb06
          IF cl_null(l_tc_shc12) OR l_tc_shc12 = 0 THEN 
             LET g_status.code = '-1'
             LET g_status.description = '没有扫入'
             LET l_return.code="-1"
             LET l_return.msg = "开工信息录入失败"
             CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
             RETURN
          ELSE 
             IF g_tc_shb.tc_shb12 > l_tc_shc12-l_tc_shb12+l_tc_shb12_f THEN #扫出数量+返工数量-已开工数量
                LET g_status.code = '-1'
                   LET g_status.description = '数量大于开工数量4'
                   LET l_return.code="-1"
                   LET l_return.msg = "开工信息录入失败"
                   CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
                   RETURN
             END IF 
          END IF
          #str-----add by guanyao160928  勾稽为Y之后执行报工扫入检查最小发料套数##########现在扫入不管控数量，开工管控
          IF l_sfbud05 = 'Y' THEN   
          ELSE 
             IF g_sma.smaud02 = 'Y' THEN  
                IF g_sma.sma73 = 'Y' THEN  #求出最小发料套数  临时取消
                   CALL s_get_ima153(g_tc_shb.tc_shb05) RETURNING l_ima153
                   CALL s_minp(g_tc_shb.tc_shb04,g_sma.sma73,l_ima153,g_tc_shb.tc_shb08,'','',g_today)
                     RETURNING l_cnt,l_over_qty
                   IF cl_null(l_over_qty) THEN LET l_over_qty = 0 END IF
                   #str---add by guanyao160904
                   LET l_yong = 0
                   SELECT SUM(tc_shb12) INTO l_yong FROM tc_shb_file 
                    WHERE tc_shb04 = g_tc_shb.tc_shb04 
                      AND tc_shb08 = g_tc_shb.tc_shb08
                      AND tc_shb01 = '2'
                   IF cl_null(l_yong) THEN 
                      LET l_yong = 0
                   END IF
                   #tianry add 161208
                   IF (g_tc_shb.tc_shb12-(l_over_qty-l_yong))/g_tc_shb.tc_shb12<=0.01 THEN LET l_over_qty=g_tc_shb.tc_shb12+l_yong END IF
                   #tianry add end
                   LET  l_over_qty = l_over_qty-l_yong
                END IF
                IF l_over_qty<g_tc_shb.tc_shb12 THEN 
                   LET g_status.code = '-1'
                   LET g_status.description = '数量大于齐套发料量'
                   LET l_return.code="-1"
                   LET l_return.msg = "开工信息录入失败"
                   CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
                   RETURN 
                END IF 
             END IF 
          END IF 
          #end-----add by guanyao160928 
       END IF 
    END IF 
    
    
    LET g_tc_shb.tc_shb14 = g_today
    LET g_tc_shb.tc_shb15 = TIME 
    #CALL aws_ttsrv_setRecordField_record(l_node1,base.Typeinfo.create(g_tc_shb))

    #----------------------------------------------------------------------#
    # 執行單頭 INSERT SQL                                                  #
    #----------------------------------------------------------------------#
    INSERT INTO tc_shb_file VALUES(g_tc_shb.*)
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       LET l_return.code="-1"
       LET l_return.msg = "开工信息录入失败"
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       RETURN 
    ELSE 
       LET l_return.code="0"
       LET l_return.msg = "开工信息录入成功"
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
   
       
 

       #tianry add end 
    END IF
    #tianry add 161222   #开工资料完全写入下一站的不报工工序的 开工资料
    LET p_tc_shb.*=g_tc_shb.*
    DECLARE sel_sgm_cur CURSOR FOR
      SELECT  sgm03,sgm04,ta_sgm06 from sgm_file WHERE sgm01=g_shb.shb16 AND sgm03>g_shb.shb06
      ORDER BY sgm03
      FOREACH sel_sgm_cur  INTO l_sgm03,l_sgm04,l_ta_sgm06
        IF l_ta_sgm06='Y' THEN #表明下一站是报工的 不能自动生成报工单
           EXIT FOREACH
        END IF
        LET l_tttt=p_tc_shb.tc_shb02[1,3]
        LET p_tc_shb.tc_shb06=l_sgm03
        LET p_tc_shb.tc_shb08=l_sgm04
        SELECT ecd07 INTO p_tc_shb.tc_shb09 FROM ecd_file WHERE ecd01=l_sgm04
        SELECT max(tc_shb02) INTO l_tmp FROM tc_shb_file
        WHERE substr(tc_shb02,1,3)=l_tttt 
        LET l_tmp=l_tmp[11,20]
        IF cl_null(l_tmp) THEN
           LET l_tmp = '0000000001'
        ELSE
           LET l_tmp = l_tmp + 1
           LET l_tmp = l_tmp USING '&&&&&&&&&&'
        END IF
        LET p_tc_shb.tc_shb02=p_tc_shb.tc_shb02[1,10] CLIPPED,l_tmp
        INSERT INTO tc_shb_file VALUES (p_tc_shb.*)
        IF STATUS THEN
           LET g_status.code = SQLCA.SQLCODE
           LET g_status.sqlcode = SQLCA.SQLCODE
           LET l_return.code="-1"
           LET l_return.msg = "下站开工资料产生失败"  
           EXIT FOREACH
        END IF
      END FOREACH 

   #tianry add 161220
  
    #    
END FUNCTION

