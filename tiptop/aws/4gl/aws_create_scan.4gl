# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: cws_create_scan.4gl
# Descriptions...: 扫描进入
# Date & Author..: 16/06/06 By guanyao
# 160607: 16/06/07 By guanyao同一个LOT号，必须按照项次进行扫入，当第一个LOT号有扫出的时候才能扫入第二个，数量小于扫出的数量
# 160617: 16/06/17 By guanyao 1、同一个工单对应的多个LOT单，必须按顺序扫入，如果前一张LOT单没有扫出，那么不能扫入，
#                                一张LOT单的第一道工艺如果没有扫出，即不能进行下一道工艺的扫入，
#                             2、数量的控制，第一张第一道工艺数量小于等于最小发料套数或者生（产数量-完工数量）,下面的工艺则，小于上一道工艺扫出数量的合

DATABASE ds
 
#No.FUN-B10004
 
GLOBALS "../../../tiptop/config/top.global"
 
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
DEFINE g_cnt    LIKE type_file.num5
    DEFINE g_tc_shc      RECORD LIKE tc_shc_file.*
    DEFINE l_return   RECORD 
           code       LIKE type_file.chr10,
           msg        LIKE type_file.chr100,
           msg1       LIKE type_file.chr100
    END RECORD
 
#[
# Description....: 提供建立扫描資料的服務(入口 function)
# Date & Author..: No.FUN-B10004 16/06/06 By guanyao
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_scan()
 
   WHENEVER ERROR CONTINUE
 
   CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
 
   #--------------------------------------------------------------------------#
   # 新增订單資料                                                       #
   #--------------------------------------------------------------------------#
   IF g_status.code = "0" THEN
      CALL aws_create_scan_process()
   END IF
 
   CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
 
END FUNCTION
 
#[
# Description....: 扫描数据
# Date & Author..: 16/06/06 By guanyao
# Parameter......: 
# Return.........: 
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_scan_process()
    DEFINE l_cnt1     LIKE type_file.num10
    DEFINE l_i        LIKE type_file.num10
    DEFINE l_cnt      LIKE type_file.num10
    DEFINE l_node1    om.DomNode
    DEFINE l_tc_shc01   LIKE tc_shc_file.tc_shc01
    DEFINE l_tc_shc03   LIKE tc_shc_file.tc_shc03
    DEFINE l_y       LIKE type_file.chr20 
    DEFINE l_m       LIKE type_file.chr20
    DEFINE l_str       LIKE type_file.chr20
    DEFINE l_tmp       LIKE type_file.chr20
    DEFINE l_tc_shc12_2    LIKE tc_shc_file.tc_shc12
    DEFINE l_tc_shc12_1    LIKE tc_shc_file.tc_shc12
    DEFINE l_sgm03         LIKE sgm_file.sgm03
    DEFINE l_tc_shc12_a    LIKE tc_shc_file.tc_shc12
    DEFINE l_sgm62         LIKE sgm_file.sgm62
    DEFINE l_sgm63         LIKE sgm_file.sgm63
    DEFINE l_shm08         LIKE shm_file.shm08
    DEFINE l_a             LIKE type_file.chr10
    #str---add by guanyao160617
    DEFINE l_ima153        LIKE ima_file.ima153
    DEFINE l_over_qty      LIKE sfv_file.sfv09
    DEFINE l_c,l_x         LIKE type_file.num5
    DEFINE l_sum           LIKE tc_shc_file.tc_shc12
    DEFINE l_sum1          LIKE tc_shc_file.tc_shc12
    DEFINE l_shm01         LIKE shm_file.shm01
    DEFINE l_max_sgm03     LIKE sgm_file.sgm03
    DEFINE l_tc_shc12_b    LIKE tc_shc_file.tc_shc12
    #str---add by guanyao160617
 
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的订單資料                                    #
    #--------------------------------------------------------------------------#

    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("tc_shc_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       LET l_return.code="-1"
       LET l_return.msg = "完工信息录入失败"
       LET l_return.msg1 = ""
       RETURN
    END IF
    BEGIN WORK 
    FOR l_i = 1 TO l_cnt1 
       LET l_a = l_i
       INITIALIZE g_tc_shc.* TO NULL
       LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "tc_shc_file")
       LET g_tc_shc.tc_shc01 = aws_ttsrv_getRecordField(l_node1,"tc_shc01") CLIPPED
       IF cl_null(g_tc_shc.tc_shc01) THEN 
          LET g_status.code = '-1'
          LET g_status.description = '没有资料性质'
          LET l_return.code="-1"
          LET l_return.msg = "扫描信息录入失败"
          LET l_return.msg1 = "第'",l_a,"'笔"
          EXIT FOR  
       ELSE
          IF g_tc_shc.tc_shc01<>'1' THEN 
             LET g_status.code = '-1'
             LET g_status.description = '资料类比不是扫描类别'
             LET l_return.code="-1"
             LET l_return.msg = "扫描信息录入失败"
             LET l_return.msg1 = "第'",l_a,"'笔"
             EXIT FOR 
          END IF
       END IF 
       LET g_tc_shc.tc_shc03 = aws_ttsrv_getRecordField(l_node1,"tc_shc03") CLIPPED
       IF cl_null(g_tc_shc.tc_shc03) THEN
          LET g_status.code = '-1'
          LET g_status.description = '没有报工信息'
          LET l_return.code="-1"
          LET l_return.msg = "扫描信息录入失败"
          LET l_return.msg1 = "第'",l_a,"'笔"
          EXIT FOR  
       END IF
       #LET g_tc_shc.tc_shc06 = aws_ttsrv_getRecordField(l_node1,"tc_shc06") CLIPPED  #mark by guanyao160620
       #IF cl_null(g_tc_shc.tc_shc06) THEN #mark by guanyao160620
       LET g_tc_shc.tc_shc08 = aws_ttsrv_getRecordField(l_node1,"tc_shc06") CLIPPED  #mark by guanyao160620
       IF cl_null(g_tc_shc.tc_shc08) THEN 
          LET g_status.code = '-1'
          LET g_status.description = '没有作业编号'
          LET l_return.code="-1"
          LET l_return.msg = "扫描信息录入失败"
          LET l_return.msg1 = "第'",l_a,"'笔"
          EXIT FOR
       ELSE 
          #str----add by guanyao160620
          SELECT sgm03 INTO g_tc_shc.tc_shc06 FROM sgm_file WHERE sgm01 = g_tc_shc.tc_shc03 AND sgm04 = g_tc_shc.tc_shc08
          IF cl_null(g_tc_shc.tc_shc06) THEN 
             LET g_status.code = '-1'
             LET g_status.description = '没有工艺序号'
             LET l_return.code="-1"
             LET l_return.msg = "扫描信息录入失败"
             LET l_return.msg1 = "第'",l_a,"'笔"
             EXIT FOR
          END IF 
          #end----add by guanyao160620
       END IF 
       LET g_tc_shc.tc_shc10 = aws_ttsrv_getRecordField(l_node1,"tc_shc09") CLIPPED
       LET g_tc_shc.tc_shc11 = aws_ttsrv_getRecordField(l_node1,"tc_shc11") CLIPPED
       IF cl_null(g_tc_shc.tc_shc11) THEN
          LET g_status.code = '-1'
          LET g_status.description = '没有此员工编号'
          LET l_return.code="-1"
          LET l_return.msg = "扫描信息录入失败"
          LET l_return.msg1 = "第'",l_a,"'笔"
          EXIT FOR     
       END IF 
       LET g_tc_shc.tc_shc12 = aws_ttsrv_getRecordField(l_node1,"tc_shc12") CLIPPED
       IF cl_null(g_tc_shc.tc_shc12) OR g_tc_shc.tc_shc12<=0 THEN
          LET g_status.code = '-1'
          LET g_status.description = '没有数量或者数量不能小于等于0'
          LET l_return.code="-1"
          LET l_return.msg = "扫描信息录入失败"
          LET l_return.msg1 = "第'",l_a,"'笔"
          EXIT FOR     
       END IF 
       LET g_tc_shc.tc_shc13 = aws_ttsrv_getRecordField(l_node1,"tc_shc13") CLIPPED
#str-----mark by guanyao160617
#str-----add by guanyao160607
      # LET l_sgm03 = ''
      # SELECT MAX(sgm03) INTO l_sgm03 FROM sgm_file WHERE sgm01 = g_tc_shc.tc_shc03 AND sgm03<g_tc_shc.tc_shc06
      # SELECT (shm08-shm09) INTO l_shm08 FROM shm_file WHERE shm01 =g_tc_shc.tc_shc03
      # IF cl_null(l_sgm03) OR l_sgm03 =0 THEN #第一笔判断
      #    SELECT sgm62,sgm63 INTO l_sgm62,l_sgm63 FROM sgm_file WHERE sgm01 = g_tc_shc.tc_shc03 AND sgm03=g_tc_shc.tc_shc06
      #    LET l_shm08 = l_sgm62/l_sgm63*l_shm08
      #    IF (l_shm08-l_sum) < g_tc_shc.tc_shc12 THEN 
      #       LET g_status.code = '-1'
      #       LET g_status.description = '扫入的数量大于lot单的数量'
      #       LET l_return.code="-1"
      #       LET l_return.msg = "扫描信息录入失败"
      #       LET l_return.msg1 = "第'",l_a,"'笔"
      #       EXIT FOR
      #    END IF 
      # ELSE 
      #    SELECT tc_shc12 INTO l_tc_shc12_a FROM tc_shc_file 
      #     WHERE tc_shc01 = '2' 
      #       AND tc_shc03 = g_tc_shc.tc_shc03
      #       AND tc_shc06 = l_sgm03
      #    IF cl_null(l_tc_shc12_a) OR l_tc_shc12_a = 0 THEN 
      #       LET g_status.code = '-1'
      #       LET g_status.description = '前一道工艺没有扫出，不能进行下一道工艺'
      #       LET l_return.code="-1"
      #       LET l_return.msg = "扫描信息录入失败"
      #       LET l_return.msg1 = "第'",l_a,"'笔"
      #       EXIT FOR
      #    ELSE
      #       LET l_tc_shc12_a = l_sgm62/l_sgm63*l_tc_shc12_a
      #       IF l_tc_shc12_a < g_tc_shc.tc_shc12 THEN 
      #          LET g_status.code = '-1'
      #          LET g_status.description = '扫入的数量大于前一道工艺扫出数量'
      #          LET l_return.code="-1"
      #          LET l_return.msg = "扫描信息录入失败"
      #          LET l_return.msg1 = "第'",l_a,"'笔"
      #          EXIT FOR
      #       END IF 
      #    END IF 
      # END IF 
#end-----add by guanyao160607
#str-----mark by guanyao160617

       #单据编号
       LET l_y =YEAR(g_today)
       LET l_y = l_y[3,4] USING '&&' 
       LET l_m =MONTH(g_today)
       LET l_m = l_m USING '&&' 
       LET l_str='SMA-',l_y clipped,l_m CLIPPED
       SELECT max(substr(tc_shc02,9,12)) INTO l_tmp FROM tc_shc_file
        WHERE substr(tc_shc02,1,8)=l_str
       IF cl_null(l_tmp) THEN 
          LET l_tmp = '0001' 
       ELSE 
          LET l_tmp = l_tmp + 1
          LET l_tmp = l_tmp USING '&&&&'     
       END IF 
       LET g_tc_shc.tc_shc02 = l_str clipped,l_tmp
       IF cl_null(g_tc_shc.tc_shc02) THEN 
           LET g_status.code = '-1'
           LET g_status.description = '没有单据编号'
           LET l_return.code="-1"
           LET l_return.msg = "扫描信息录入失败"
           LET l_return.msg1 = "第'",l_a,"'笔"
           EXIT FOR 
       END IF 

       #数量的判断，同一个人，同一个工艺，同一个lot单必须先完工才能继续生成一笔数据
       #str-----mark by guanyao160617
       --IF g_tc_shc.tc_shc01 = '1' THEN 
          --SELECT tc_shc12 INTO l_tc_shc12_1 FROM tc_shc_file 
           --WHERE tc_shc03= g_tc_shc.tc_shc03 
             --AND tc_shc06= g_tc_shc.tc_shc06
             --AND tc_shc11= g_tc_shc.tc_shc11
             --AND tc_shc01 = '1'
          --SELECT tc_shc12 INTO l_tc_shc12_2 FROM tc_shc_file 
           --WHERE tc_shc03= g_tc_shc.tc_shc03 
             --AND tc_shc06= g_tc_shc.tc_shc06
             --AND tc_shc11= g_tc_shc.tc_shc11
             --AND tc_shc01 = '2'
          --IF (cl_null(l_tc_shc12_2) OR (l_tc_shc12_2<>l_tc_shc12_1)) AND l_tc_shc12_1>0 THEN
             --LET g_status.code = '-1'
             --LET g_status.description = '有未扫描完的资料，清先扫描完此笔资料'
             --LET l_return.code="-1"
             --LET l_return.msg = "扫描信息录入失败"
             --LET l_return.msg1 = "第'",l_a,"'笔"
             --EXIT FOR
          --END IF 
       --END IF
       #end-----mark by guanyao160617 

        #人员检核
       SELECT COUNT(*) INTO l_cnt FROM gen_file
        WHERE gen01=g_tc_shc.tc_shc11
          AND genacti = 'Y'
       IF l_cnt = 0 THEN
          LET g_status.code = '-1'
          LET g_status.description = '人员资料错误'
          LET l_return.code="-1"
          LET l_return.msg = "扫描信息录入失败"
          LET l_return.msg1 = "第'",l_a,"'笔"
          EXIT FOR 
       END IF

       #班别检核
       SELECT COUNT(*) INTO l_cnt FROM ecg_file 
        WHERE ecg01 = g_tc_shc.tc_shc13
          AND ecgacti = 'Y'
       IF l_cnt = 0 THEN
          LET g_status.code = '-1'
          LET g_status.description = '班别有错误'
          LET l_return.code="-1"
          LET l_return.msg = "扫描信息录入失败"
          LET l_return.msg1 = "第'",l_a,"'笔"
          EXIT FOR 
       END IF

       SELECT shm012,shm05,shm06
         INTO g_tc_shc.tc_shc04,g_tc_shc.tc_shc05,g_tc_shc.tc_shc07
         FROM shm_file 
        WHERE shm01 = g_tc_shc.tc_shc03 
        
       #SELECT sgm52,sgm58                            #mark by guanyao160617
       #  INTO g_tc_shc.tc_shc10,g_tc_shc.tc_shc16    #mark by guanyao160617
       SELECT sgm58,sgm06 INTO g_tc_shc.tc_shc16,g_tc_shc.tc_shc09    #add by guanyao160617
         FROM sgm_file WHERE sgm01 = g_tc_shc.tc_shc03 AND sgm03 = g_tc_shc.tc_shc06

#str----add by guanyao160617 #工单扫入的时候必须按照LOT单号的顺序，前一张LOT单号有扫出之后才能进行下一个LOT单号的扫入'
       LET l_shm01 = ''
       LET l_sgm62 = ''
       LET l_sgm63 = ''
       LET l_cnt = 0
       LET l_over_qty = 0
       LET l_shm08 = 0
       SELECT MAX(shm01) INTO l_shm01 FROM shm_file WHERE shm01 <g_tc_shc.tc_shc03 AND shm012 = g_tc_shc.tc_shc04
       SELECT (shm08-shm09) INTO l_shm08 FROM shm_file WHERE shm01 =g_tc_shc.tc_shc03
       IF cl_null(l_shm08) THEN   #求出是否是前一张LOT单是否已经扫出，如果扫出，减去扫出的数量
          LET l_shm08 = 0
       END IF
       IF NOT cl_null(l_shm01) THEN 
          LET l_max_sgm03 = 0
          SELECT MAX(sgm03) INTO l_max_sgm03 FROM sgm_file WHERE sgm01 = l_shm01
          IF cl_null(l_max_sgm03) THEN 
             LET g_status.code = '-1'
             LET g_status.description = '检查前一笔LOT单是否有单身'
             LET l_return.code="-1"
             LET l_return.msg = "扫描信息录入失败"
             LET l_return.msg1 = "第'",l_a,"'笔"
             EXIT FOR
          END IF 
          LET l_tc_shc12_a = 0
          SELECT SUM(tc_shc12) INTO l_tc_shc12_a 
            FROM tc_shc_file 
           WHERE tc_shc03 = l_shm01 
             AND tc_shc06= l_max_sgm03
             AND tc_shc01 = '2'
          IF cl_null(l_tc_shc12_a) OR l_tc_shc12_a = 0 THEN 
             LET g_status.code = '-1'
             LET g_status.description = '前一张LOT工艺没有完成'
             LET l_return.code="-1"
             LET l_return.msg = "扫描信息录入失败"
             LET l_return.msg1 = "第'",l_a,"'笔"
             EXIT FOR
          END IF 
       ELSE
          LET l_tc_shc12_a = 0
       END IF  
       LET l_sgm03 = ''
       SELECT MAX(sgm03) INTO l_sgm03 FROM sgm_file WHERE sgm01 = g_tc_shc.tc_shc03 AND sgm03<g_tc_shc.tc_shc06
       IF cl_null(l_sgm03) THEN  #第一道工艺是的数量小于最小发料套数或者此张lot单标准产出量
          LET l_sum = 0
          SELECT SUM(tc_shc12) INTO l_sum FROM tc_shc_file   #此道LOT单工艺已经扫出数量
           WHERE tc_shc03 = g_tc_shc.tc_shc03 
             AND tc_shc06 = g_tc_shc.tc_shc06
             AND tc_shc01 = '2' 
          IF cl_null(l_sum) OR l_sum=0 THEN 
             LET l_x = 0
             SELECT COUNT(*) INTO l_x FROM tc_shc_file   
              WHERE tc_shc03 = g_tc_shc.tc_shc03 
                AND tc_shc06 = g_tc_shc.tc_shc06
                AND tc_shc01 = '1'
             IF l_x > 0 THEN 
                LET g_status.code = '-1'
                LET g_status.description = '此道工艺有扫入，没有扫出'
                LET l_return.code="-1"
                LET l_return.msg = "扫描信息录入失败"
                LET l_return.msg1 = "第'",l_a,"'笔"
                EXIT FOR
             ELSE
                LET l_sum1 = 0
                SELECT SUM(tc_shc12) INTO l_sum1 FROM tc_shc_file   
                 WHERE tc_shc03 = g_tc_shc.tc_shc03 
                   AND tc_shc06 = g_tc_shc.tc_shc06
                   AND tc_shc01 = '1'
                IF cl_null(l_sum1) THEN 
                   LET l_sum1 = 0
                END IF 
             END IF 
          ELSE 
             LET l_sum1 = 0
             SELECT SUM(tc_shc12) INTO l_sum1 FROM tc_shc_file   
              WHERE tc_shc03 = g_tc_shc.tc_shc03 
                AND tc_shc06 = g_tc_shc.tc_shc06
                AND tc_shc01 = '1'
             IF cl_null(l_sum1) THEN 
                LET l_sum1 = 0
             END IF
          END IF 
          IF g_sma.sma73 = 'Y' THEN  #求出最小发料套数
             CALL s_get_ima153(g_tc_shc.tc_shc05) RETURNING l_ima153
             CALL s_minp(g_tc_shc.tc_shc04,g_sma.sma73,l_ima153,'','','',g_today)
                RETURNING l_cnt,l_over_qty
             IF cl_null(l_over_qty) THEN LET l_over_qty = 0 END IF
             IF l_cnt !=0  THEN
                LET g_status.code = '-1'
                LET g_status.description = 'asf-549'
                LET l_return.code="-1"
                LET l_return.msg = "扫描信息录入失败"
                LET l_return.msg1 = "第'",l_a,"'笔"
                EXIT FOR
             END IF
          END IF
          SELECT sgm62,sgm63 INTO l_sgm62,l_sgm63 FROM sgm_file WHERE sgm01 = g_tc_shc.tc_shc03 AND sgm03 =g_tc_shc.tc_shc06
          IF cl_null(l_sgm62) OR cl_null(l_sgm63) OR l_sgm62 = 0 OR l_sgm63 = 0 THEN 
             LET g_status.code = '-1'
             LET g_status.description = '此张lot单没有单位换算'
             LET l_return.code="-1"
             LET l_return.msg = "扫描信息录入失败"
             LET l_return.msg1 = "第'",l_a,"'笔"
             EXIT FOR 
          END IF 
          LET l_shm08 = l_sgm62/l_sgm63*l_shm08
          LET l_over_qty = l_sgm62/l_sgm63*(l_over_qty-l_tc_shc12_a)
          IF (l_shm08-l_sum) < g_tc_shc.tc_shc12 THEN 
             LET g_status.code = '-1'
             LET g_status.description = '扫入的数量大于lot单的数量'
             LET l_return.code="-1"
             LET l_return.msg = "扫描信息录入失败"
             LET l_return.msg1 = "第'",l_a,"'笔"
             EXIT FOR
          END IF 
          IF (l_shm08-l_sum1) < g_tc_shc.tc_shc12 THEN 
             LET g_status.code = '-1'
             LET g_status.description = '扫入的数量总和大于LOT单数量'
             LET l_return.code="-1"
             LET l_return.msg = "扫描信息录入失败"
             LET l_return.msg1 = "第'",l_a,"'笔"
             EXIT FOR
          END IF 
          IF (l_over_qty-l_sum) < g_tc_shc.tc_shc12 THEN 
             LET g_status.code = '-1'
             LET g_status.description = '扫入的数量大于最小发料套数'
             LET l_return.code="-1"
             LET l_return.msg = "扫描信息录入失败"
             LET l_return.msg1 = "第'",l_a,"'笔"
             EXIT FOR
          END IF  
       ELSE 
          SELECT SUM(tc_shc12) INTO l_tc_shc12_b FROM tc_shc_file 
           WHERE tc_shc01 = '2' 
             AND tc_shc03 = g_tc_shc.tc_shc03
             AND tc_shc06 = l_sgm03
          IF cl_null(l_tc_shc12_b) OR l_tc_shc12_b = 0 THEN 
             LET g_status.code = '-1'
             LET g_status.description = '前一道工艺没有扫出，不能进行下一道工艺'
             LET l_return.code="-1"
             LET l_return.msg = "扫描信息录入失败"
             LET l_return.msg1 = "第'",l_a,"'笔"
             EXIT FOR
          ELSE
             LET l_sgm62 = ''
             LET l_sgm63 = ''
             SELECT sgm62,sgm63 INTO l_sgm62,l_sgm63 FROM sgm_file WHERE sgm01 = g_tc_shc.tc_shc03 AND sgm03 =l_sgm03
             IF cl_null(l_sgm62) OR cl_null(l_sgm63) OR l_sgm62 = 0 OR l_sgm63 = 0 THEN 
                LET g_status.code = '-1'
                LET g_status.description = '此张lot单没有单位换算'
                LET l_return.code="-1"
                LET l_return.msg = "扫描信息录入失败"
                LET l_return.msg1 = "第'",l_a,"'笔"
                EXIT FOR 
             END IF 
             LET l_tc_shc12_b = l_sgm62/l_sgm63*l_tc_shc12_b
             IF l_tc_shc12_b < g_tc_shc.tc_shc12 THEN 
                LET g_status.code = '-1'
                LET g_status.description = '扫入的数量大于前一道工艺扫出数量'
                LET l_return.code="-1"
                LET l_return.msg = "扫描信息录入失败"
                LET l_return.msg1 = "第'",l_a,"'笔"
                EXIT FOR
             END IF 
          END IF            
       END IF        
#end----add by guanyao160617
    
       LET g_tc_shc.tc_shc14 = g_today
       LET g_tc_shc.tc_shc15 = TIME 
 
       #----------------------------------------------------------------------#
       # 執行單頭 INSERT SQL                                                  #
       #----------------------------------------------------------------------#
       INSERT INTO tc_shc_file VALUES(g_tc_shc.*)
       IF SQLCA.SQLCODE THEN
          LET g_status.code = SQLCA.SQLCODE
          LET g_status.sqlcode = SQLCA.SQLCODE
          LET l_return.code="-1"
          LET l_return.msg = "扫描信息录入失败"
          LET l_return.msg1 = "第'",l_a,"'笔"
          EXIT FOR 
       END IF
    END FOR 
    IF g_status.code <> '0' THEN 
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       ROLLBACK WORK 
    ELSE 
       LET g_status.code = '0'
       LET g_status.sqlcode = '扫描数据成功'
       LET l_return.code="0"
       LET l_return.msg = "扫描数据成功"
       LET l_return.msg1 = ""
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       COMMIT WORK 
    END IF 
END FUNCTION

