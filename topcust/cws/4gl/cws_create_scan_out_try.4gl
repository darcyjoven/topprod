# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: cws_create_scan_out.4gl
# Descriptions...: 扫描退出
# Date & Author..: 16/06/07 By guanyao

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
FUNCTION cws_create_scan_out()
 
   WHENEVER ERROR CONTINUE
 
   CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
 
   #--------------------------------------------------------------------------#
   # 新增订單資料                                                       #
   #--------------------------------------------------------------------------#
   IF g_status.code = "0" THEN
      CALL cws_create_scan_out_process()
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
FUNCTION cws_create_scan_out_process()
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
    DEFINE l_tc_shb12      LIKE tc_shb_file.tc_shb12
    DEFINE l_a             LIKE type_file.chr10
    DEFINE l_tc_shc12      LIKE tc_shc_file.tc_shc12  #add by guanyao160731
    DEFINE l_ta_ecd04      LIKE ecd_file.ta_ecd04     #add by guanyao160806
    DEFINE l_tc_shb12_a    LIKE tc_shb_file.tc_shb12  #add by guanyao160806
    DEFINE l_d             LIKE type_file.chr20 
    DEFINE  l_ta_sgm06     LIKE sgm_file.ta_sgm06    #tianry add 161219
    DEFINE p_tc_shc    RECORD LIKE tc_shc_file.*
    DEFINE l_tttt       LIKE oga_file.oga01
    DEFINE l_sgm03    LIKE sgm_file.sgm03,
           l_sgm04    LIKE sgm_file.sgm04,
           l_ta_ecd06  LIKE ecd_file.ta_ecd06
    DEFINE l_sfbud12   LIKE sfb_file.sfbud12

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
       LET l_node1 = aws_ttsrv_getMasterRecord(l_i,"tc_shc_file")
       LET g_tc_shc.tc_shc01 = aws_ttsrv_getRecordField(l_node1,"tc_shc01") CLIPPED
       IF cl_null(g_tc_shc.tc_shc01) THEN 
          LET g_status.code = '-1'
          LET g_status.description = '没有资料性质'
          LET l_return.code="-1"
          LET l_return.msg = "扫出信息录入失败"
          LET l_return.msg1 = "第'",l_a,"'笔"
          EXIT FOR  
       ELSE
          IF g_tc_shc.tc_shc01<>'2' THEN 
             LET g_status.code = '-1'
             LET g_status.description = '资料类比不是扫出类别'
             LET l_return.code="-1"
             LET l_return.msg = "扫出信息录入失败"
             LET l_return.msg1 = "第'",l_a,"'笔"
             EXIT FOR 
          END IF
       END IF 
       LET g_tc_shc.tc_shc03 = aws_ttsrv_getRecordField(l_node1,"tc_shc03") CLIPPED
       IF cl_null(g_tc_shc.tc_shc03) THEN
          LET g_status.code = '-1'
          LET g_status.description = '没有报工信息',g_tc_shc.tc_shc03
          LET l_return.code="-1"
          LET l_return.msg = "扫出信息录入失败"
          LET l_return.msg1 = "第'",l_a,"'笔"
          EXIT FOR  
       END IF
       LET g_tc_shc.tc_shc06 = aws_ttsrv_getRecordField(l_node1,"tc_shc06") CLIPPED  #mark by guanyao160620
       IF cl_null(g_tc_shc.tc_shc06) THEN   #mark by guanyao160620
       #LET g_tc_shc.tc_shc08 = aws_ttsrv_getRecordField(l_node1,"tc_shc06") CLIPPED  #add by guanyao160620
       #IF cl_null(g_tc_shc.tc_shc08) THEN                                            #add by guanyao160620                               
          LET g_status.code = '-1'
          LET g_status.description = '没有作业编号',g_tc_shc.tc_shc03
          LET l_return.code="-1"
          LET l_return.msg = "扫出信息录入失败"
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
     #     LET g_status.description = '此作业编号为非报工'
     #     LET l_return.code="-1"
     #     LET l_return.msg = "开工信息录入失败"
     #     CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
     #     RETURN
     #  END IF 

       #tianry add end 
       LET g_tc_shc.tc_shc11 = aws_ttsrv_getRecordField(l_node1,"tc_shc11") CLIPPED
       IF cl_null(g_tc_shc.tc_shc11) THEN
          LET g_status.code = '-1'
          LET g_status.description = '没有此员工编号',g_tc_shc.tc_shc03
          LET l_return.code="-1"
          LET l_return.msg = "扫出信息录入失败"
          LET l_return.msg1 = "第'",l_a,"'笔"
          EXIT FOR     
       END IF 
       LET g_tc_shc.tc_shc12 = aws_ttsrv_getRecordField(l_node1,"tc_shc12") CLIPPED
       IF cl_null(g_tc_shc.tc_shc12) OR g_tc_shc.tc_shc12<=0 THEN
          LET g_status.code = '-1'
          LET g_status.description = '没有数量或者数量不能小于等于0',g_tc_shc.tc_shc03
          LET l_return.code="-1"
          LET l_return.msg = "扫出信息录入失败"
          LET l_return.msg1 = "第'",l_a,"'笔"
          EXIT FOR     
       END IF 
       LET g_tc_shc.tc_shc13 = aws_ttsrv_getRecordField(l_node1,"tc_shc13") CLIPPED
       LET g_tc_shc.tc_shcud09 = aws_ttsrv_getRecordField(l_node1,"pnl") CLIPPED
       #str------add by guanyao160806
       SELECT ta_ecd04 INTO l_ta_ecd04 FROM ecd_file,sgm_file 
        WHERE ecd01 = sgm04 
          AND sgm01 = g_tc_shc.tc_shc03
          AND sgm03 = g_tc_shc.tc_shc06
       #end------add by guanyao160806
       #数量的判断，扫出数量不能大余完工数量
       #str-----add by guanyao160731
       SELECT SUM(tc_shc12) INTO l_tc_shc12
          FROM tc_shc_file 
        WHERE tc_shc03 = g_tc_shc.tc_shc03
          AND tc_shc06 = g_tc_shc.tc_shc06
          AND tc_shc01 = '2'
       IF cl_null(l_tc_shc12) THEN 
          LET l_tc_shc12 = 0
       END IF 
       #end-----add by guanyao160731
       SELECT SUM(tc_shb12) INTO l_tc_shb12 
         FROM tc_shb_file 
        WHERE tc_shb03 = g_tc_shc.tc_shc03
          AND tc_shb06 = g_tc_shc.tc_shc06
          AND tc_shb01 = '2'
       #str----add by guanyao160806
       SELECT SUM(tc_shc12) INTO l_tc_shb12_a 
         FROM tc_shc_file 
        WHERE tc_shc03 = g_tc_shc.tc_shc03
          AND tc_shc06 = g_tc_shc.tc_shc06
          AND tc_shc01 = '1'
       #end----add by guanyao160806
       IF l_ta_ecd04='Y' THEN    #add by guanyao160806
          IF cl_null(l_tc_shb12_a) OR l_tc_shb12_a = 0 THEN 
             LET g_status.code = '-1'
             LET g_status.description = '此LOT单是包装单,没有扫入量',g_tc_shc.tc_shc03
             LET l_return.code="-1"
             LET l_return.msg = "扫出信息录入失败"
             LET l_return.msg1 = "第'",l_a,"'笔"
             EXIT FOR
          ELSE
             IF l_tc_shb12_a-l_tc_shc12 < g_tc_shc.tc_shc12 THEN
                LET g_status.code = '-1'
                LET g_status.description = '扫入数量不能小于扫出数量',g_tc_shc.tc_shc03
                LET l_return.code="-1"
                LET l_return.msg = "扫出信息录入失败"
                LET l_return.msg1 = "第'",l_a,"'笔"
                EXIT FOR
             END IF 
          END IF 
       ELSE 
          IF cl_null(l_tc_shb12) OR l_tc_shb12 = 0 THEN 
             LET g_status.code = '-1'
             LET g_status.description = '此LOT单没有完工',g_tc_shc.tc_shc03
             LET l_return.code="-1"
             LET l_return.msg = "扫出信息录入失败"
             LET l_return.msg1 = "第'",l_a,"'笔"
             EXIT FOR
          ELSE
             IF l_tc_shb12-l_tc_shc12< g_tc_shc.tc_shc12 THEN 
                LET g_status.code = '-1'
                LET g_status.description = '完工数量不能小于扫出数量',g_tc_shc.tc_shc03
                LET l_return.code="-1"
                LET l_return.msg = "扫出信息录入失败"
                LET l_return.msg1 = "第'",l_a,"'笔"
                EXIT FOR
             END IF 
          END IF 
       END IF 
      

       #单据编号
       LET l_y =YEAR(g_today)
       LET l_y = l_y[3,4] USING '&&' 
       LET l_m =MONTH(g_today)
       LET l_m = l_m USING '&&' 
       LET l_d =DAY(g_today)
       LET l_d = l_d USING '&&'
       LET l_str='OCB-',l_y clipped,l_m CLIPPED,l_d CLIPPED
       SELECT max(substr(tc_shc02,11,20)) INTO l_tmp FROM tc_shc_file
        WHERE substr(tc_shc02,1,10)=l_str
       IF cl_null(l_tmp) THEN 
          LET l_tmp = '0000000001' 
       ELSE 
          LET l_tmp = l_tmp + 1
          LET l_tmp = l_tmp USING '&&&&&&&&&&'     
       END IF 
       LET g_tc_shc.tc_shc02 = l_str clipped,l_tmp
       IF cl_null(g_tc_shc.tc_shc02) THEN 
           LET g_status.code = '-1'
           LET g_status.description = '没有单据编号',g_tc_shc.tc_shc03
           LET l_return.code="-1"
           LET l_return.msg = "扫出信息录入失败"
           LET l_return.msg1 = "第'",l_a,"'笔"
           EXIT FOR 
       END IF 

       #数量的判断，同一个人，同一个工艺，同一个lot单必须先完工才能继续生成一笔数据
       #IF g_tc_shc.tc_shc01 = '1' THEN 
       #   SELECT tc_shc12 INTO l_tc_shc12_1 FROM tc_shc_file 
       #    WHERE tc_shc03= g_tc_shc.tc_shc03 
       #      AND tc_shc06= g_tc_shc.tc_shc06
       #      AND tc_shc11= g_tc_shc.tc_shc11
       #      AND tc_shc01 = '1'
       #   SELECT tc_shc12 INTO l_tc_shc12_2 FROM tc_shc_file 
       #    WHERE tc_shc03= g_tc_shc.tc_shc03 
       #      AND tc_shc06= g_tc_shc.tc_shc06
       #      AND tc_shc11= g_tc_shc.tc_shc11
       #      AND tc_shc01 = '2'
       #   IF (cl_null(l_tc_shc12_2) OR (l_tc_shc12_2<>l_tc_shc12_1)) AND l_tc_shc12_1>0 THEN
       #      LET g_status.code = '-1'
       #      LET g_status.description = '有未扫描完的资料，清先扫描完此笔资料',g_tc_shc.tc_shc03
       #      LET l_return.code="-1"
       #      LET l_return.msg = "扫出信息录入失败"
       #      LET l_return.msg1 = "第'",l_a,"'笔"
       #      EXIT FOR
       #   END IF 
       #END IF 

        #人员检核
       SELECT COUNT(*) INTO l_cnt FROM gen_file
        WHERE gen01=g_tc_shc.tc_shc11
          AND genacti = 'Y'
       IF l_cnt = 0 THEN
          LET g_status.code = '-1'
          LET g_status.description = '人员资料错误',g_tc_shc.tc_shc03
          LET l_return.code="-1"
          LET l_return.msg = "扫出信息录入失败"
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
          LET l_return.msg = "扫出信息录入失败"
          LET l_return.msg1 = "第'",l_a,"'笔"
          EXIT FOR 
       END IF

       #SELECT shm012,shm05,shm06,ecu03 
       #  INTO g_tc_shc.tc_shc04,g_tc_shc.tc_shc05,g_tc_shc.tc_shc07,g_tc_shc.tc_shc08
       #  FROM shm_file LEFT JOIN ecu_file ON ecu01= shm05 AND ecu02 = shm06
       # WHERE shm01 = g_tc_shc.tc_shc03 
        
       #SELECT sgm52,sgm58 
       #  INTO g_tc_shc.tc_shc10,g_tc_shc.tc_shc16 
       #  FROM sgm_file WHERE sgm01 = g_tc_shc.tc_shc03 AND sgm03 = g_tc_shc.tc_shc06
       #SELECT tc_shc09 INTO g_tc_shc.tc_shc09 
       #  FROM tc_shc_file 
       # WHERE tc_shc01 = '1'
       #   AND tc_shc03 = g_tc_shc.tc_shc03
       #   AND tc_shc06 = g_tc_shc.tc_shc06
       #str-----add by guanyao160617
       SELECT tc_shc04,tc_shc05,tc_shc07,tc_shc08,tc_shc09,tc_shc10,tc_shc16 
         INTO g_tc_shc.tc_shc04,g_tc_shc.tc_shc05,g_tc_shc.tc_shc07,g_tc_shc.tc_shc08,  #add by guanyao160617
              g_tc_shc.tc_shc09,g_tc_shc.tc_shc10,g_tc_shc.tc_shc16 FROM tc_shc_file     #add by guanyao160617
        WHERE tc_shc03 = g_tc_shc.tc_shc03
          AND tc_shc06 = g_tc_shc.tc_shc06 
          AND tc_shc01 = '1'
       #end-----add by guanyao160617
    
       LET g_tc_shc.tc_shc14 = g_today
       LET g_tc_shc.tc_shc15 = TIME 
 
       #----------------------------------------------------------------------#
       # 執行單頭 INSERT SQL                                                  #
       #----------------------------------------------------------------------#
        #  tianry add161128 
        LET l_cnt=0
       SELECT COUNT(*) INTO l_cnt FROM tc_shc_file WHERE tc_shc01='2' AND tc_shc03=g_tc_shc.tc_shc03
       AND tc_shc08=g_tc_shc.tc_shc08 AND tc_shc12=g_tc_shc.tc_shc12 AND tc_shc.tc_shc15=g_tc_shc.tc_shc15
       AND tc_shc06=g_tc_shc.tc_shc06
       IF cl_null(l_cnt) THEN LET l_cnt=0 END IF 
       IF l_cnt>0 THEN   #表明存在相同的数据已经
          INSERT INTO tc_shc_backup VALUES (g_tc_shc.*)  
          CONTINUE FOR
       END IF 
        #tianry add end 
       INSERT INTO tc_shc_file VALUES(g_tc_shc.*)
       IF SQLCA.SQLCODE THEN
          LET g_status.code = SQLCA.SQLCODE
          LET g_status.sqlcode = SQLCA.SQLCODE,g_tc_shc.tc_shc03
          LET l_return.code="-1"
          LET l_return.msg = "扫出信息录入失败"
          LET l_return.msg1 = "第'",l_a,"'笔"
          EXIT FOR 
       END IF
       #tianry add 161220   #本站的扫出  生成不报工工站的扫出
      
       DECLARE sel_tc_shc_cc_cur CURSOR FOR 
       SELECT  sgm03,sgm04,ta_sgm06 from sgm_file WHERE sgm01=g_tc_shc.tc_shc03 AND sgm03>g_tc_shc.tc_shc06
       ORDER BY sgm03
       LET p_tc_shc.*=g_tc_shc.*
       FOREACH sel_tc_shc_cc_cur  INTO l_sgm03,l_sgm04,l_ta_sgm06
         IF l_ta_sgm06='Y' THEN
            EXIT FOREACH 
         END IF
         SELECT ta_ecd04 INTO l_ta_ecd04 FROM ecd_file WHERE ecd01=l_sgm04 
         IF l_ta_ecd04='N' THEN
            LET l_tttt='OCB'
            LET p_tc_shc.tc_shc06=l_sgm03
            LET p_tc_shc.tc_shc08=l_sgm04
            SELECT ecd07 INTO p_tc_shc.tc_shc09  FROM ecd_file WHERE ecd01=l_sgm04   #工作站
            LET p_tc_shc.tc_shcud09=g_tc_shc.tc_shcud09
            SELECT max(tc_shc02) INTO l_tmp FROM tc_shc_file
            WHERE substr(tc_shc02,1,3)=l_tttt
            LET  l_tmp=l_tmp[11,20]
            IF cl_null(l_tmp) THEN
               LET l_tmp = '0000000001'
            ELSE
               LET l_tmp = l_tmp + 1
               LET l_tmp = l_tmp USING '&&&&&&&&&&'
            END IF
            LET p_tc_shc.tc_shc02=p_tc_shc.tc_shc02[1,10] CLIPPED,l_tmp
            INSERT INTO tc_shc_file VALUES (p_tc_shc.*)
            IF STATUS THEN
               LET g_success='N'
               LET g_status.code = '-1'
               LET g_status.sqlcode = '下一站扫入失败'
               LET l_return.code="-1"
               LET l_return.msg = "下一站扫入失败"
               EXIT FOREACH 
            END IF
          END IF 
       END FOREACH 
       #tianry add 
    END FOR 
    IF g_status.code <> '0' THEN 
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       ROLLBACK WORK 
    ELSE 
       LET g_status.code = '0'
       LET g_status.sqlcode = '扫出信息录入成功'
       LET l_return.code="0"
       LET l_return.msg = "扫出信息录入成功"
       LET l_return.msg1 = ""
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       COMMIT WORK 
    END IF 
END FUNCTION

