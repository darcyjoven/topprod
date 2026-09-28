# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_finish_work.4gl
# Descriptions...: 创建开工数据
# Date & Author..: 16/06/06 By guanyao

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
FUNCTION aws_create_finish_work()
 
   WHENEVER ERROR CONTINUE
 
   CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
 
   #--------------------------------------------------------------------------#
   # 新增订單資料                                                       #
   #--------------------------------------------------------------------------#
   IF g_status.code = "0" THEN
      CALL aws_create_finish_work_process()
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
FUNCTION aws_create_finish_work_process()
    DEFINE l_cnt      LIKE type_file.num10
    DEFINE l_node1    om.DomNode
    DEFINE l_tc_shb01   LIKE tc_shb_file.tc_shb01
    DEFINE l_tc_shb03   LIKE tc_shb_file.tc_shb03
    DEFINE l_y       LIKE type_file.chr20 
    DEFINE l_m       LIKE type_file.chr20
    DEFINE l_str       LIKE type_file.chr20
    DEFINE l_tmp       LIKE type_file.chr20
    DEFINE l_tc_shb12_2    LIKE tc_shb_file.tc_shb12
    DEFINE l_tc_shb12_1    LIKE tc_shb_file.tc_shb12
    DEFINE l_tc_shb06      LIKE tc_shb_file.tc_shb06
    DEFINE l_tc_shb11      LIKE tc_shb_file.tc_shb11
    DEFINE l_tc_shb12      LIKE tc_shb_file.tc_shb12
    DEFINE lst_token base.StringTokenizer     
    DEFINE p_tok1    LIKE type_file.chr1000
    DEFINE l_x        LIKE type_file.num5
    DEFINE l_n        LIKE type_file.num5
    DEFINE l_err      LIKE type_file.chr1
    
 
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的订單資料                                    #
    #--------------------------------------------------------------------------#

    LET l_tc_shb01 = aws_ttsrv_getParameter("tc_shb01")
    IF cl_null(l_tc_shb01) THEN 
       LET g_status.code = '-1'
       LET g_status.description = '没有资料性质'
       LET l_return.code="-1"
       LET l_return.msg = "完工信息录入失败"
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       RETURN 
    ELSE 
       IF l_tc_shb01<>'2' THEN 
          LET g_status.code = '-1'
          LET g_status.description = '资料类比不是完工类别'
          LET l_return.code="-1"
          LET l_return.msg = "完工信息录入失败"
          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
          RETURN
       END IF 
    END IF 
    LET l_tc_shb03 = aws_ttsrv_getParameter("tc_shb03")
    IF cl_null(l_tc_shb03) THEN
       LET g_status.code = '-1'
       LET g_status.description = '没有报工信息'
       LET l_return.code="-1"
       LET l_return.msg = "完工信息录入失败"
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       RETURN 
    END IF
    #LET l_tc_shb06 = aws_ttsrv_getParameter("tc_shb06")  #mark by guanyao160620
    #IF cl_null(l_tc_shb06) THEN  #mark by guanyao160620
    LET g_tc_shb.tc_shb08 = aws_ttsrv_getParameter("tc_shb06")  #add by guanyao160620
    IF cl_null(g_tc_shb.tc_shb08) THEN   #add by guanyao160620
       LET g_status.code = '-1'
       LET g_status.description = '没有作业序号'
       LET l_return.code="-1"
       LET l_return.msg = "完工信息录入失败"
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       RETURN
    ELSE 
       #str----add by guanyao160620
       SELECT sgm03 INTO l_tc_shb06 FROM sgm_file WHERE sgm01 = l_tc_shb03 AND sgm04 = g_tc_shb.tc_shb08
       IF cl_null(l_tc_shb06) THEN 
          LET g_status.code = '-1'
          LET g_status.description = '没有工艺序号'
          LET l_return.code="-1"
          LET l_return.msg = "扫描信息录入失败"
          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
          RETURN
       END IF 
       #end----add by guanyao160620
    END IF 
    LET l_tc_shb11 = aws_ttsrv_getParameter("tc_shb11")
    IF cl_null(l_tc_shb11) THEN 
       LET g_status.code = '-1'
       LET g_status.description = '没有员工编号'
       LET l_return.code="-1"
       LET l_return.msg = "完工信息录入失败"
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       RETURN 
    END IF 
    SELECT SUM(tc_shb12) INTO l_tc_shb12 
      FROM tc_shb_file 
     WHERE tc_shb03 = l_tc_shb03 
       AND tc_shb06 = l_tc_shb06
       AND tc_shb11 = l_tc_shb11
       AND tc_shb01 = '1'
    IF cl_null(l_tc_shb12) OR l_tc_shb12 = 0 THEN 
       LET g_status.code = '-1'
       LET g_status.description = '没有开工资料'
       LET l_return.code="-1"
       LET l_return.msg = "完工信息录入失败"
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       RETURN
    END IF 

    INITIALIZE g_tc_shb.* TO NULL

       LET g_tc_shb.tc_shb01 = l_tc_shb01
       LET g_tc_shb.tc_shb03 = l_tc_shb03
       LET g_tc_shb.tc_shb06 = l_tc_shb06
       LET g_tc_shb.tc_shb11 = l_tc_shb11
       LET g_tc_shb.tc_shb12 = aws_ttsrv_getParameter("tc_shb12")
       LET g_tc_shb.tc_shb121 = aws_ttsrv_getParameter("tc_shb121")
       LET g_tc_shb.tc_shb122 = aws_ttsrv_getParameter("tc_shb122")
       LET g_tc_shb.tc_shb13 = aws_ttsrv_getParameter("tc_shb13")
       LET g_tc_shb.tc_shbud01 = aws_ttsrv_getParameter("tc_shbud01")
       #str----add by guanyao160617
       LET g_tc_shb.tc_shbud07 = aws_ttsrv_getParameter("tc_shbud07")
       LET g_tc_shb.tc_shbud08 = aws_ttsrv_getParameter("tc_shbud08")
       IF cl_null(g_tc_shb.tc_shbud07) OR g_tc_shb.tc_shbud07=0 THEN 
          LET g_status.code = '-1'
          LET g_status.description = '机器数不能为空'
          LET l_return.code="-1"
          LET l_return.msg = "完工信息录入失败"
          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
          RETURN
       END IF 
       IF cl_null(g_tc_shb.tc_shbud08) OR g_tc_shb.tc_shbud08=0 THEN 
          LET g_status.code = '-1'
          LET g_status.description = '人数不能为空'
          LET l_return.code="-1"
          LET l_return.msg = "完工信息录入失败"
          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
          RETURN
       END IF 
       #end----add by guanyao160617

       #单据编号
       LET l_y =YEAR(g_today)
       LET l_y = l_y[3,4] USING '&&' 
       LET l_m =MONTH(g_today)
       LET l_m = l_m USING '&&' 
       LET l_str='WGA-',l_y clipped,l_m CLIPPED
       SELECT max(substr(tc_shb02,9,12)) INTO l_tmp FROM tc_shb_file
        WHERE substr(tc_shb02,1,8)=l_str
       IF cl_null(l_tmp) THEN 
          LET l_tmp = '0001' 
       ELSE 
          LET l_tmp = l_tmp + 1
          LET l_tmp = l_tmp USING '&&&&'     
       END IF 
       LET g_tc_shb.tc_shb02 = l_str clipped,l_tmp
       IF cl_null(g_tc_shb.tc_shb02) THEN 
           LET g_status.code = '-1'
           LET g_status.description = '没有单据编号'
           LET l_return.code="-1"
           LET l_return.msg = "完工信息录入失败"
           CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
           RETURN 
       END IF 

       #数量的判断，同一个人，同一个工艺，同一个lot单必须先完工才能继续生成一笔数据
       IF g_tc_shb.tc_shb01 = '2' THEN 
          SELECT SUM(tc_shb12+tc_shb121+tc_shb122) INTO l_tc_shb12_2 FROM tc_shb_file 
           WHERE tc_shb03= g_tc_shb.tc_shb03 
             AND tc_shb06= g_tc_shb.tc_shb06
             AND tc_shb11= g_tc_shb.tc_shb11
             AND tc_shb01 = '2'
          IF cl_null(l_tc_shb12_2) THEN 
             LET l_tc_shb12_2 = 0
          END IF
          IF g_tc_shb.tc_shb12-g_tc_shb.tc_shb121-g_tc_shb.tc_shb122 < = 0 THEN 
             LET g_status.code = '-1'
             LET g_status.description = '完工数量不能小于等于0'
             LET l_return.code="-1"
             LET l_return.msg = "完工信息录入失败"
             CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
             RETURN 
          END IF  
          IF (l_tc_shb12_2+g_tc_shb.tc_shb12-g_tc_shb.tc_shb121-g_tc_shb.tc_shb122)>l_tc_shb12 THEN
             LET g_status.code = '-1'
             LET g_status.description = '完工数量不能大于开工数量'
             LET l_return.code="-1"
             LET l_return.msg = "完工信息录入失败"
             CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
             RETURN 
          END IF 
          IF g_tc_shb.tc_shb12 > l_tc_shb12 OR g_tc_shb.tc_shb121 > l_tc_shb12 OR g_tc_shb.tc_shb122> l_tc_shb12 THEN 
             LET g_status.code = '-1'
             LET g_status.description = '完工数量大于开工数量'
             LET l_return.code="-1"
             LET l_return.msg = "完工信息录入失败"
             CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
             RETURN
          END IF 
       END IF 

        #人员检核
       SELECT COUNT(*) INTO l_cnt FROM gen_file
        WHERE gen01=g_tc_shb.tc_shb11
          AND genacti = 'Y'
       IF l_cnt = 0 THEN
          LET g_status.code = '-1'
          LET g_status.description = '人员资料错误'
          LET l_return.code="-1"
          LET l_return.msg = "完工信息录入失败"
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
          LET l_return.msg = "完工信息录入失败"
          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
          RETURN 
       END IF

       #检查备注
       IF NOT cl_null(g_tc_shb.tc_shbud01) THEN 
          SELECT instr(g_tc_shb.tc_shbud01,'|') INTO l_n FROM dual
          IF l_n > 0 THEN 
             LET lst_token = base.StringTokenizer.create(g_tc_shb.tc_shbud01,"|")
             LET l_n  = 1
             WHILE lst_token.hasMoreTokens()
                LET p_tok1 = lst_token.nextToken()
                SELECT COUNT(*) INTO l_x FROM qce_file WHERE qce01 = p_tok1 
                IF l_x = 0 OR cl_null(l_x) THEN 
                   LET l_err = 'N'
                   EXIT WHILE 
                END IF 
             END WHILE 
             IF l_err = 'N' THEN 
                LET g_status.code = '-1'
                LET g_status.description = '备注信息有错误'
                LET l_return.code="-1"
                LET l_return.msg = "完工信息录入失败"
                CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
                RETURN
             END IF 
          ELSE 
             SELECT COUNT(*) INTO l_n FROM qce_file WHERE qce01 = l_barcode 
             IF l_n = 0 OR cl_null(l_n) THEN 
                LET g_status.code = '-1'
                LET g_status.description = '备注信息有错误'
                LET l_return.code="-1"
                LET l_return.msg = "完工信息录入失败"
                CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
                RETURN
             END IF 
          END IF 
       END IF 

      # SELECT shm012,shm05,shm06,ecu03 
      #   INTO g_tc_shb.tc_shb04,g_tc_shb.tc_shb05,g_tc_shb.tc_shb07,g_tc_shb.tc_shb08
      #   FROM shm_file LEFT JOIN ecu_file ON ecu01= shm05 AND ecu02 = shm06
      #  WHERE shm01 = g_tc_shb.tc_shb03 
       #str----mark by guanyao160617 
       #SELECT sgm52,sgm58 
       #  INTO g_tc_shb.tc_shb10,g_tc_shb.tc_shb16 
       #  FROM sgm_file WHERE sgm01 = g_tc_shb.tc_shb03 AND sgm03 = g_tc_shb.tc_shb06
       #SELECT tc_shc09 INTO g_tc_shb.tc_shb09 FROM tc_shc_file 
       #end----mark by guanyao160617
       SELECT tc_shb04,tc_shb05,tc_shb07,tc_shb08,tc_shb10,tc_shb16,tc_shb02 
         INTO g_tc_shb.tc_shb04,g_tc_shb.tc_shb05,g_tc_shb.tc_shb07,g_tc_shb.tc_shb08,  #add by guanyao160617
              g_tc_shb.tc_shb10,g_tc_shb.tc_shb16,g_tc_shb.tc_shbud02 FROM tc_shb_file  #add by guanyao160617
        WHERE tc_shb03 = g_tc_shb.tc_shb03
          AND tc_shb06 = g_tc_shb.tc_shb06 
          AND tc_shb01 = '1'

    
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
          LET l_return.msg = "完工信息录入失败"
          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
          RETURN 
       ELSE 
          LET l_return.code="0"
          LET l_return.msg = "完工信息录入成功"
          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       END IF
       
END FUNCTION

