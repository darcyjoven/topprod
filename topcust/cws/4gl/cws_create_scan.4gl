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
FUNCTION cws_create_scan()
 
   WHENEVER ERROR CONTINUE
 
   CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
 
   #--------------------------------------------------------------------------#
   # 新增订單資料                                                       #
   #--------------------------------------------------------------------------#
   IF g_status.code = "0" THEN
      CALL cws_create_scan_process()
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
FUNCTION cws_create_scan_process()
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
    DEFINE l_tc_shc12      LIKE tc_shc_file.tc_shc12
    #str---add by guanyao160617
    DEFINE l_flag          LIKE type_file.chr1
    DEFINE l_ta_shm04      LIKE shm_file.ta_shm04  #add by guanyao160801
    DEFINE l_d             LIKE type_file.chr10
    DEFINE l_ta_ecd04      LIKE ecd_file.ta_ecd04  #add by guanyao160808
    DEFINE l_yong          LIKE tc_shb_file.tc_shb12  #add by guanyao160904
    DEFINE l_sfbud05       LIKE sfb_file.sfbud05     #add by guanyao160907
    DEFINE  l_ta_sgm06     LIKE sgm_file.ta_sgm06    #tianry add 161219   
    DEFINE  l_sql          STRING
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
          LET g_status.description = '没有报工信息',g_tc_shc.tc_shc03
          LET l_return.code="-1"
          LET l_return.msg = "扫描信息录入失败"
          LET l_return.msg1 = "第'",l_a,"'笔"
          EXIT FOR  
       END IF
       LET g_tc_shc.tc_shc06 = aws_ttsrv_getRecordField(l_node1,"tc_shc06") CLIPPED  #mark by guanyao160620
       IF cl_null(g_tc_shc.tc_shc06) THEN 
          LET g_status.code = '-1'
          LET g_status.description = '没有作业编号',g_tc_shc.tc_shc03
          LET l_return.code="-1"
          LET l_return.msg = "扫描信息录入失败"
          LET l_return.msg1 = "第'",l_a,"'笔"
          EXIT FOR
       ELSE 
          #str----add by guanyao160620
          #SELECT sgm03 INTO g_tc_shc.tc_shc06 FROM sgm_file WHERE sgm01 = g_tc_shc.tc_shc03 AND sgm04 = g_tc_shc.tc_shc08
          #IF cl_null(g_tc_shc.tc_shc06) THEN 
          #   LET g_status.code = '-1'
          #   LET g_status.description = '没有工艺序号'
          #   LET l_return.code="-1"
          #   LET l_return.msg = "扫描信息录入失败"
          #   LET l_return.msg1 = "第'",l_a,"'笔"
          #   EXIT FOR
          #END IF 
          #end----add by guanyao160620
       END IF 
        #tianry add 161219
     #  SELECT ta_sgm06 INTO l_ta_sgm06 FROM sgm_file WHERE sgm01=g_tc_shc.tc_shc03 AND sgm03=g_tc_shc.tc_shc06
     #  IF cl_null(l_ta_sgm06) OR l_ta_sgm06='N' THEN
     #     LET g_status.code = '-1'
     ##     LET g_status.description = '此作业编号为非报工'
     #     LET l_return.code="-1"
     #     LET l_return.msg = "开工信息录入失败"
     #     CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
     #     RETURN
     #  END IF 
             
     #tianry add end 161219

       LET g_tc_shc.tc_shc10 = aws_ttsrv_getRecordField(l_node1,"tc_shc09") CLIPPED
       LET g_tc_shc.tc_shc11 = aws_ttsrv_getRecordField(l_node1,"tc_shc11") CLIPPED
       IF cl_null(g_tc_shc.tc_shc11) THEN
          LET g_status.code = '-1'
          LET g_status.description = '没有此员工编号',g_tc_shc.tc_shc03
          LET l_return.code="-1"
          LET l_return.msg = "扫描信息录入失败"
          LET l_return.msg1 = "第'",l_a,"'笔"
          EXIT FOR     
       END IF 
       LET g_tc_shc.tc_shc12 = aws_ttsrv_getRecordField(l_node1,"tc_shc12") CLIPPED
       IF cl_null(g_tc_shc.tc_shc12) OR g_tc_shc.tc_shc12<=0 THEN
          LET g_status.code = '-1'
          LET g_status.description = '没有数量或者数量不能小于等于0',g_tc_shc.tc_shc03
          LET l_return.code="-1"
          LET l_return.msg = "扫描信息录入失败"
          LET l_return.msg1 = "第'",l_a,"'笔"
          EXIT FOR     
       END IF 
       LET g_tc_shc.tc_shc13 = aws_ttsrv_getRecordField(l_node1,"tc_shc13") CLIPPED
       LET g_tc_shc.tc_shcud09 = aws_ttsrv_getRecordField(l_node1,"pnl") CLIPPED  #add by guanyao160728
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
       #str---add by guanyao160806
       LET l_d = DAY(g_today)
       LET l_d = l_d USING '&&'
       #end---add by guanyao160806
        #随即抓取扫入单别
       LET l_sql=" select bg02  from bg_file  sample(1) where  rownum=1 and bg01=1 "
       PREPARE  cre_scan_pre FROM l_sql
       DECLARE  cre_scan_cur CURSOR FOR cre_scan_pre
       OPEN cre_scan_cur 
       FETCH cre_scan_cur INTO l_str
       CLOSE cre_scan_cur
       
     
 
       LET l_str=l_str CLIPPED,l_y clipped,l_m CLIPPED,l_d CLIPPED  
       SELECT max(substr(tc_shc02,12,20)) INTO l_tmp FROM tc_shc_file
        WHERE substr(tc_shc02,1,11)=l_str
       IF cl_null(l_tmp) THEN 
          LET l_tmp = '000000001' 
       ELSE 
          LET l_tmp = l_tmp + 1
          LET l_tmp = l_tmp USING '&&&&&&&&&'     
       END IF 
       LET g_tc_shc.tc_shc02 = l_str clipped,l_tmp
       IF cl_null(g_tc_shc.tc_shc02) THEN 
           LET g_status.code = '-1'
           LET g_status.description = '没有单据编号',g_tc_shc.tc_shc03
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
          LET g_status.description = '人员资料错误',g_tc_shc.tc_shc03
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
          LET g_status.description = '班别有错误',g_tc_shc.tc_shc03
          LET l_return.code="-1"
          LET l_return.msg = "扫描信息录入失败"
          LET l_return.msg1 = "第'",l_a,"'笔"
          EXIT FOR 
       END IF

       SELECT shm012,shm05,shm06
         INTO g_tc_shc.tc_shc04,g_tc_shc.tc_shc05,g_tc_shc.tc_shc07
         FROM shm_file 
        WHERE shm01 = g_tc_shc.tc_shc03 
       #str----add by guanyao160907
       SELECT sfbud05 INTO l_sfbud05 FROM sfb_file WHERE sfb01 = g_tc_shc.tc_shc04 
       IF cl_null(l_sfbud05) THEN
          LET l_sfbud05 = 'N'
       END IF 
       LET l_sfbud05 = 'Y'  #add by guanyao160928 扫入不需要考虑发料，当做旧工单
       #end----add by guanyao160907
        
       #SELECT sgm52,sgm58                            #mark by guanyao160617
       #  INTO g_tc_shc.tc_shc10,g_tc_shc.tc_shc16    #mark by guanyao160617
       SELECT sgm58,sgm06,sgm04 INTO g_tc_shc.tc_shc16,g_tc_shc.tc_shc09,g_tc_shc.tc_shc08    #add by guanyao160617
         FROM sgm_file WHERE sgm01 = g_tc_shc.tc_shc03 AND sgm03 = g_tc_shc.tc_shc06

#str----add by guanyao160617 #工单扫入的时候必须按照LOT单号的顺序，前一张LOT单号有扫出之后才能进行下一个LOT单号的扫入'
       LET l_shm01 = ''
       LET l_sgm62 = ''
       LET l_sgm63 = ''
       LET l_cnt = 0
       LET l_over_qty = 0
       LET l_shm08 = 0
       #SELECT MAX(shm01) INTO l_shm01 FROM shm_file WHERE shm01 <g_tc_shc.tc_shc03 AND shm012 = g_tc_shc.tc_shc04  #mark by guanyao160728
       SELECT shm08 INTO l_shm08 FROM shm_file WHERE shm01 =g_tc_shc.tc_shc03
       IF cl_null(l_shm08) THEN   #求出是否是前一张LOT单是否已经扫出，如果扫出，减去扫出的数量
          LET l_shm08 = 0
       END IF
       #str------mark by guanyao160728
       #IF NOT cl_null(l_shm01) THEN 
       #   #str-----add by guanyao160720
       #   CALL cws_create_scan_s(g_tc_shc.tc_shc03,g_tc_shc.tc_shc04) RETURNING l_flag 
       #   IF l_flag = '1' THEN 
       #      LET g_status.code = '-1'
       #      LET g_status.description = '检查前一笔LOT单是否有单身',g_tc_shc.tc_shc03
       #      LET l_return.code="-1"
       #      LET l_return.msg = "扫描信息录入失败"
       #      LET l_return.msg1 = "第'",l_a,"'笔"
       #      EXIT FOR
       #   END IF 
       #   IF l_flag = '2' THEN 
       #      LET g_status.code = '-1'
       #      LET g_status.description = '前一张LOT工艺没有完成',g_tc_shc.tc_shc03
       #      LET l_return.code="-1"
       #      LET l_return.msg = "扫描信息录入失败"
       #      LET l_return.msg1 = "第'",l_a,"'笔"
       #      EXIT FOR
       #   END IF 
       #   #end-----add by guanyao160720
       #   LET l_max_sgm03 = 0
       #   SELECT MAX(sgm03) INTO l_max_sgm03 FROM sgm_file WHERE sgm01 = l_shm01
       #   IF cl_null(l_max_sgm03) THEN 
       #      LET g_status.code = '-1'
       #      LET g_status.description = '检查前一笔LOT单是否有单身',g_tc_shc.tc_shc03
       #      LET l_return.code="-1"
       #      LET l_return.msg = "扫描信息录入失败"
       #      LET l_return.msg1 = "第'",l_a,"'笔"
       #      EXIT FOR
       #   END IF 
       #   LET l_tc_shc12_a = 0
       #   SELECT SUM(tc_shc12) INTO l_tc_shc12_a 
       #     FROM tc_shc_file 
       #    WHERE tc_shc03 = l_shm01 
       #      AND tc_shc06= l_max_sgm03
       #      AND tc_shc01 = '2'
       #   IF cl_null(l_tc_shc12_a) OR l_tc_shc12_a = 0 THEN 
       #      LET g_status.code = '-1'
       #      LET g_status.description = '前一张LOT工艺没有完成',g_tc_shc.tc_shc03
       #      LET l_return.code="-1"
       #      LET l_return.msg = "扫描信息录入失败"
       #      LET l_return.msg1 = "第'",l_a,"'笔"
       #      EXIT FOR
       #   END IF 
       #ELSE
       #   LET l_tc_shc12_a = 0
       #END IF  
       #end------mark by guanyao160728
       #str----add by guanyao160801
       SELECT ta_shm04 INTO l_ta_shm04 FROM shm_file WHERE shm01 = g_tc_shc.tc_shc03
       IF cl_null(l_ta_shm04) THEN 
          LET l_ta_shm04 = 'N'
       END IF  
       IF l_ta_shm04= 'Y' THEN #如果是你期初的话，可以跨工艺，之后不可以，将期初资料更新成N
         #str----mark by guanyao160805  临时取消
          IF l_sfbud05 = 'Y' THEN 
          ELSE 
          IF g_sma.smaud02 = 'Y' THEN    #add by guanyao160903 勾稽为Y之后执行报工扫入检查最小发料套数
             IF g_sma.sma73 = 'Y' THEN  #求出最小发料套数
                CALL s_get_ima153(g_tc_shc.tc_shc05) RETURNING l_ima153
                CALL s_minp(g_tc_shc.tc_shc04,g_sma.sma73,l_ima153,g_tc_shc.tc_shc08,'','',g_today)
                   RETURNING l_cnt,l_over_qty
                IF cl_null(l_over_qty) THEN LET l_over_qty = 0 END IF
                #str----add by guanyao160905
                LET l_yong = 0
                SELECT SUM(tc_shc12) INTO l_yong FROM tc_shc_file WHERE tc_shc04 = g_tc_shc.tc_shc04 AND tc_shc08 = g_tc_shc.tc_shc08 AND tc_shc01 = '2'
                IF cl_null(l_yong) THEN 
                   LET l_yong = 0
                END IF 
                LET l_over_qty = l_over_qty-l_yong
                #end----add by guanyao160905
                IF l_cnt !=0  THEN
                   LET g_status.code = '-1'
                   LET g_status.description = 'asf-549',g_tc_shc.tc_shc03
                   LET l_return.code="-1"
                   LET l_return.msg = "扫描信息录入失败"
                   LET l_return.msg1 = "第'",l_a,"'笔"
                   EXIT FOR
                END IF
             END IF
          END IF 
          END IF 
          #IF l_ta_shm04 <l_over_qty THEN 
         #end----mark by guanyao160805
         #str----add by guanyao160903 勾稽为Y之后执行报工扫入检查最小发料套数
         #str----add by guanyao160907
          IF l_sfbud05 = 'Y' THEN 
             IF g_tc_shc.tc_shc12 >l_shm08 THEN
                LET g_status.code = '-1'
                LET g_status.description = '录入数量大于开工量',g_tc_shc.tc_shc03
                LET l_return.code="-1"
                LET l_return.msg = "扫描信息录入失败"
                LET l_return.msg1 = "第'",l_a,"'笔"
                EXIT FOR 
             END IF 
          ELSE 
          #end----add by guanyao160907
          IF g_sma.smaud02 = 'Y' THEN     
             IF l_ta_shm04 <l_over_qty THEN
                IF g_tc_shc.tc_shc12 >l_shm08 THEN
                   LET g_status.code = '-1'
                   LET g_status.description = '录入数量大于开工量',g_tc_shc.tc_shc03
                   LET l_return.code="-1"
                   LET l_return.msg = "扫描信息录入失败"
                   LET l_return.msg1 = "第'",l_a,"'笔"
                   EXIT FOR 
                END IF 
             ELSE 
                IF g_tc_shc.tc_shc12 >l_over_qty THEN 
                   LET g_status.code = '-1'
                   LET g_status.description = '录入数量大于发料量',g_tc_shc.tc_shc03
                   LET l_return.code="-1"
                   LET l_return.msg = "扫描信息录入失败"
                   LET l_return.msg1 = "第'",l_a,"'笔"
                   EXIT FOR
                END IF                 
             END IF 
          ELSE 
          #end----add by guanyao160903 勾稽为Y之后执行报工扫入检查最小发料套数
             IF g_tc_shc.tc_shc12 >l_shm08 THEN
                LET g_status.code = '-1'
                LET g_status.description = '录入数量大于开工量',g_tc_shc.tc_shc03
                LET l_return.code="-1"
                LET l_return.msg = "扫描信息录入失败"
                LET l_return.msg1 = "第'",l_a,"'笔"
                EXIT FOR 
             END IF 
          END IF 
          END IF  
         #str----mark by guanyao160805  临时取消
         # ELSE 
         #    IF g_tc_shc.tc_shc12 >l_over_qty THEN 
         #       LET g_status.code = '-1'
         #       LET g_status.description = '录入数量大于发料量',g_tc_shc.tc_shc03
         #       LET l_return.code="-1"
         #       LET l_return.msg = "扫描信息录入失败"
         #       LET l_return.msg1 = "第'",l_a,"'笔"
         #       EXIT FOR
         #    END IF 
         # END IF 
         #end----mark by guanyao160805  临时取消
       ELSE 
       #end----add by guanyao160801
       LET l_sgm03 = ''
       SELECT MAX(sgm03) INTO l_sgm03 FROM sgm_file WHERE sgm01 = g_tc_shc.tc_shc03 AND sgm03<g_tc_shc.tc_shc06
       IF cl_null(l_sgm03) THEN  #第一道工艺是的数量小于最小发料套数或者此张lot单标准产出量
          LET l_sum = 0
          SELECT SUM(tc_shc12) INTO l_sum FROM tc_shc_file   #此道LOT单工艺已经扫出数量
           WHERE tc_shc03 = g_tc_shc.tc_shc03 
             AND tc_shc06 = g_tc_shc.tc_shc06
             AND tc_shc01 = '2' 
          IF cl_null(l_sum) OR l_sum=0 THEN 
             LET l_sum = 0
             LET l_x = 0
             SELECT COUNT(*) INTO l_x FROM tc_shc_file   
              WHERE tc_shc03 = g_tc_shc.tc_shc03 
                AND tc_shc06 = g_tc_shc.tc_shc06
                AND tc_shc01 = '1'
             IF l_x > 0 THEN 
                LET g_status.code = '-1'
                LET g_status.description = '此道工艺有扫入，没有扫出',g_tc_shc.tc_shc03
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
          #str-----mark by guanyao160805  临时取消
          IF l_sfbud05 = 'Y' THEN   #add by guanyao160907
          ELSE 
          IF g_sma.smaud02 = 'Y' THEN   #add by guanyao160903 勾稽为Y之后执行报工扫入检查最小发料套数
             IF g_sma.sma73 = 'Y' THEN  #求出最小发料套数
                CALL s_get_ima153(g_tc_shc.tc_shc05) RETURNING l_ima153
                CALL s_minp(g_tc_shc.tc_shc04,g_sma.sma73,l_ima153,g_tc_shc.tc_shc08,'','',g_today)
                   RETURNING l_cnt,l_over_qty
                IF cl_null(l_over_qty) THEN LET l_over_qty = 0 END IF
                #str----add by guanyao160905
                LET l_yong = 0
                SELECT SUM(tc_shc12) INTO l_yong FROM tc_shc_file WHERE tc_shc04 = g_tc_shc.tc_shc04 AND tc_shc08 = g_tc_shc.tc_shc08 AND tc_shc01 = '2'
                IF cl_null(l_yong) THEN 
                   LET l_yong = 0
                END IF 
                LET l_over_qty = l_over_qty-l_yong
                #end----add by guanyao160905
                IF l_cnt !=0  THEN
                   LET g_status.code = '-1'
                   #LET g_status.description = 'asf-549',g_tc_shc.tc_shc03              #mark by guanyao160903
                   LET g_status.description = '开工工序主料未齐套发料',g_tc_shc.tc_shc03    #add by guanyao160903
                   LET l_return.code="-1"
                   LET l_return.msg = "扫描信息录入失败"
                   LET l_return.msg1 = "第'",l_a,"'笔"
                   EXIT FOR
                END IF
             END IF
          END IF 
          END IF 
          #end-----mark by guanyao160805  临时取消
          SELECT sgm62,sgm63 INTO l_sgm62,l_sgm63 FROM sgm_file WHERE sgm01 = g_tc_shc.tc_shc03 AND sgm03 =g_tc_shc.tc_shc06
          IF cl_null(l_sgm62) OR cl_null(l_sgm63) OR l_sgm62 = 0 OR l_sgm63 = 0 THEN 
             LET g_status.code = '-1'
             LET g_status.description = '此张lot单没有单位换算',g_tc_shc.tc_shc03  
             LET l_return.code="-1"
             LET l_return.msg = "扫描信息录入失败"
             LET l_return.msg1 = "第'",l_a,"'笔"
             EXIT FOR 
          END IF 
          LET l_shm08 = (l_sgm62/l_sgm63)*l_shm08
          IF l_sfbud05 = 'Y' THEN   #add by guanyao160907
          ELSE
          IF g_sma.smaud02 = 'Y' THEN #add by guanyao勾稽为Y之后执行报工扫入检查最小发料套数
             LET l_over_qty = (l_sgm62/l_sgm63)*l_over_qty-l_tc_shc12_a  #mark by guanyao160805
          END IF 
          END IF 
             #str-----mark by guanyao160728
             IF (l_shm08-l_sum) < g_tc_shc.tc_shc12 THEN 
                LET g_status.code = '-1'
                LET g_status.description = '扫入的数量大于lot单的数量',g_tc_shc.tc_shc03
                LET l_return.code="-1"
                LET l_return.msg = "扫描信息录入失败"
                LET l_return.msg1 = "第'",l_a,"'笔"
                EXIT FOR
             END IF 
          #end-----mark by guanyao160728
          #END IF 
          IF (l_shm08-l_sum1) < g_tc_shc.tc_shc12 THEN 
             LET g_status.code = '-1'
             LET g_status.description = '扫入的数量总和大于LOT单数量',g_tc_shc.tc_shc03
             LET l_return.code="-1"
             LET l_return.msg = "扫描信息录入失败"
             LET l_return.msg1 = "第'",l_a,"'笔"
             EXIT FOR
          END IF 
          IF l_sfbud05 = 'Y' THEN   #add by guanyao160907
          ELSE
          IF g_sma.smaud02 = 'Y' THEN #add by guanyao勾稽为Y之后执行报工扫入检查最小发料套数
          #str----mark by guanyao160805  临时取消
             IF l_over_qty < g_tc_shc.tc_shc12 THEN 
                LET g_status.code = '-1'
                #LET g_status.description = '扫入的数量大于最小发料套数',g_tc_shc.tc_shc03
                LET g_status.description = '开工工序主料未齐套发料',g_tc_shc.tc_shc03  
                LET l_return.code="-1"
                LET l_return.msg = "扫描信息录入失败"
                LET l_return.msg1 = "第'",l_a,"'笔"
                EXIT FOR
             END IF  
          #end----mark by guanyao160805
          END IF 
          END IF 
       ELSE #扫入数量不能大于已存在的数量
          #str-----mark by guanyao160905  
          IF l_sfbud05 = 'Y' THEN   #add by guanyao160907
          ELSE
          IF g_sma.smaud02 = 'Y' THEN   #勾稽为Y之后执行报工扫入检查最小发料套数
             IF g_sma.sma73 = 'Y' THEN  #求出最小发料套数
                CALL s_get_ima153(g_tc_shc.tc_shc05) RETURNING l_ima153
                CALL s_minp(g_tc_shc.tc_shc04,g_sma.sma73,l_ima153,g_tc_shc.tc_shc08,'','',g_today)
                   RETURNING l_cnt,l_over_qty
                IF cl_null(l_over_qty) THEN LET l_over_qty = 0 END IF
                LET l_yong = 0
                SELECT SUM(tc_shc12) INTO l_yong FROM tc_shc_file WHERE tc_shc04 = g_tc_shc.tc_shc04 AND tc_shc08 = g_tc_shc.tc_shc08 AND tc_shc01 = '2'
                IF cl_null(l_yong) THEN 
                   LET l_yong = 0
                END IF 
                LET l_over_qty = l_over_qty-l_yong
                IF l_cnt !=0  THEN
                   LET g_status.code = '-1'
                   LET g_status.description = '开工工序主料未齐套发料',g_tc_shc.tc_shc03    #add by guanyao160903
                   LET l_return.code="-1"
                   LET l_return.msg = "扫描信息录入失败"
                   LET l_return.msg1 = "第'",l_a,"'笔"
                   EXIT FOR
                END IF
                IF l_over_qty<g_tc_shc.tc_shc12  THEN
                   LET g_status.code = '-1'
                   LET g_status.description = '开工工序主料未齐套发料',g_tc_shc.tc_shc03    #add by guanyao160903
                   LET l_return.code="-1"
                   LET l_return.msg = "扫描信息录入失败"
                   LET l_return.msg1 = "第'",l_a,"'笔"
                   EXIT FOR
                END IF
             END IF
          END IF 
          END IF 
          #end-----mark by guanyao160905  
          #str-----add by guanyao160808
          LET l_ta_ecd04 = ''
          SELECT ta_ecd04 INTO l_ta_ecd04 FROM ecd_file,tc_shb_file 
           WHERE ecd01= tc_shb08 
             AND tc_shb03 = g_tc_shc.tc_shc03
             AND tc_shb06 = l_sgm03 
          IF cl_null(l_ta_ecd04) THEN 
             LET l_ta_ecd04 = 'N'
          END IF 
          IF l_ta_ecd04 = 'Y' THEN 
             #SELECT SUM(tc_shb12+tc_shb121+tc_shb122) INTO l_tc_shc12_b FROM tc_shb_file   #mark by guanyao161007
             SELECT SUM(tc_shb12) INTO l_tc_shc12_b FROM tc_shb_file  #add by guanyao161007
              WHERE tc_shb01 = '2' 
                AND tc_shb03 = g_tc_shc.tc_shc03
                AND tc_shb06 = l_sgm03
          ELSE 
             SELECT SUM(tc_shc12) INTO l_tc_shc12_b FROM tc_shc_file   #tianry mark 161220
              WHERE tc_shc01 = '2' 
                AND tc_shc03 = g_tc_shc.tc_shc03
                AND tc_shc06 = l_sgm03
          END IF 
         #end-----add by guanyao160808
       #   SELECT SUM(tc_shc12) INTO l_tc_shc12_b FROM tc_shc_file 
       #    WHERE tc_shc01 = '2' 
       #      AND tc_shc03 = g_tc_shc.tc_shc03
       #      AND tc_shc06 = l_sgm03
          IF cl_null(l_tc_shc12_b) OR l_tc_shc12_b = 0 THEN 
             LET g_status.code = '-1'
             LET g_status.description = '前一道工艺没有扫出，或者完工',g_tc_shc.tc_shc03
             LET l_return.code="-1"
             LET l_return.msg = "扫描信息录入失败"
             LET l_return.msg1 = "第'",l_a,"'笔"
             EXIT FOR
          ELSE
             #str-----add by guanyao160719
             SELECT SUM(tc_shc12) INTO l_tc_shc12 FROM tc_shc_file 
              WHERE tc_shc01 = '1' 
                AND tc_shc03 = g_tc_shc.tc_shc03
                AND tc_shc06 = g_tc_shc.tc_shc06
             IF cl_null(l_tc_shc12) THEN 
                LET l_tc_shc12 = 0
             END IF 
             #end-----add by guanyao160719
             LET l_sgm62 = ''
             LET l_sgm63 = ''
             SELECT sgm62,sgm63 INTO l_sgm62,l_sgm63 FROM sgm_file WHERE sgm01 = g_tc_shc.tc_shc03 AND sgm03 =l_sgm03
             IF cl_null(l_sgm62) OR cl_null(l_sgm63) OR l_sgm62 = 0 OR l_sgm63 = 0 THEN 
                LET g_status.code = '-1'
                LET g_status.description = '此张lot单没有单位换算',g_tc_shc.tc_shc03
                LET l_return.code="-1"
                LET l_return.msg = "扫描信息录入失败"
                LET l_return.msg1 = "第'",l_a,"'笔"
                EXIT FOR 
             END IF 
             LET l_tc_shc12_b = l_sgm62/l_sgm63*l_tc_shc12_b
             IF l_tc_shc12_b-l_tc_shc12 < g_tc_shc.tc_shc12 THEN 
                LET g_status.code = '-1'
                LET g_status.description = '扫入的数量大于前一道工艺扫出数量',g_tc_shc.tc_shc03
                LET l_return.code="-1"
                LET l_return.msg = "扫描信息录入失败"
                LET l_return.msg1 = "第'",l_a,"'笔"
                EXIT FOR
             END IF 
          END IF            
       END IF        
       END IF #add by guanyao160801
#end----add by guanyao160617
    
       LET g_tc_shc.tc_shc14 = g_today
       LET g_tc_shc.tc_shc15 = TIME 
 
       #----------------------------------------------------------------------#
       # 執行單頭 INSERT SQL                                                  #
       #----------------------------------------------------------------------#
       INSERT INTO tc_shc_file VALUES(g_tc_shc.*)
       IF SQLCA.SQLCODE THEN
          LET g_status.code = SQLCA.SQLCODE
          LET g_status.sqlcode = SQLCA.SQLCODE,g_tc_shc.tc_shc03
          LET l_return.code="-1"
          LET l_return.msg = "扫描信息录入失败"
          LET l_return.msg1 = "第'",l_a,"'笔"
          EXIT FOR 
       END IF
       #str-----add by guanyao160801
       IF l_ta_shm04 = 'Y' THEN 
          UPDATE shm_file SET ta_shm04 = 'N'  
                        WHERE shm01 = g_tc_shc.tc_shc03 
          IF SQLCA.SQLCODE THEN
             LET g_status.code = SQLCA.SQLCODE
             LET g_status.sqlcode = SQLCA.SQLCODE,g_tc_shc.tc_shc03
             LET l_return.code="-1"
             LET l_return.msg = "扫描信息录入失败"
             LET l_return.msg1 = "第'",l_a,"'笔"
             EXIT FOR 
          END IF
       END IF 
       #end-----add by guanyao160801
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

#str-----add by guanyao160720
FUNCTION cws_create_scan_s(p_shm01,p_shm012)
DEFINE p_shm01     LIKE shm_file.shm01 
DEFINE p_shm012    LIKE shm_file.shm012
DEFINE l_sql       STRING 
DEFINE l_shm01     LIKE shm_file.shm01
DEFINE l_ta_shm02  LIKE shm_file.ta_shm02 
DEFINE l_sgm03     LIKE sgm_file.sgm03
DEFINE l_tc_shc12  LIKE tc_shc_file.tc_shc12

     LET l_sql ="SELECT shm01 FROM shm_file WHERE shm01 < '",p_shm01,"' AND shm012 = '",p_shm012,"'",
                " order by shm01 desc"
     PREPARE cws_p FROM l_sql
     DECLARE cws_c CURSOR FOR cws_p 
     FOREACH cws_c INTO l_shm01
        LET l_ta_shm02 = ''
        SELECT ta_shm02 INTO l_ta_shm02 FROM shm_file WHERE shm01 = l_shm01
        IF l_ta_shm02 = 'N' THEN 
           CONTINUE FOREACH 
        END IF 
        LET l_sgm03 = ''
        SELECT MAX(sgm03) INTO l_sgm03 FROM sgm_file WHERE sgm01 = l_shm01
        IF cl_null(l_sgm03) OR l_sgm03 = 0 THEN 
           RETURN '1'
        END IF   
        LET l_tc_shc12 = ''
        SELECT SUM(tc_shc12) INTO l_tc_shc12 FROM tc_shc_file WHERE tc_shc03 = l_shm01 AND tc_shc06 = l_sgm03 AND tc_shc01 = '2'
        IF cl_null(l_tc_shc12) OR l_tc_shc12= 0 THEN 
           RETURN '2'
        END IF 
        RETURN '3'
     END FOREACH 
     RETURN '1'

     
END FUNCTION 
#end-----add by guanyao160720
