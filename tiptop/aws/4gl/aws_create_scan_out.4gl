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
FUNCTION aws_create_scan_out()
 
   WHENEVER ERROR CONTINUE
 
   CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
 
   #--------------------------------------------------------------------------#
   # 新增订單資料                                                       #
   #--------------------------------------------------------------------------#
   IF g_status.code = "0" THEN
      CALL aws_create_scan_out_process()
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
FUNCTION aws_create_scan_out_process()
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
          LET g_status.description = '没有报工信息'
          LET l_return.code="-1"
          LET l_return.msg = "扫出信息录入失败"
          LET l_return.msg1 = "第'",l_a,"'笔"
          EXIT FOR  
       END IF
       #LET g_tc_shc.tc_shc06 = aws_ttsrv_getRecordField(l_node1,"tc_shc06") CLIPPED  #mark by guanyao160620
       #IF cl_null(g_tc_shc.tc_shc06) THEN   #mark by guanyao160620
       LET g_tc_shc.tc_shc08 = aws_ttsrv_getRecordField(l_node1,"tc_shc06") CLIPPED  #add by guanyao160620
       IF cl_null(g_tc_shc.tc_shc08) THEN                                            #add by guanyao160620                               
          LET g_status.code = '-1'
          LET g_status.description = '没有作业编号'
          LET l_return.code="-1"
          LET l_return.msg = "扫出信息录入失败"
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
       LET g_tc_shc.tc_shc11 = aws_ttsrv_getRecordField(l_node1,"tc_shc11") CLIPPED
       IF cl_null(g_tc_shc.tc_shc11) THEN
          LET g_status.code = '-1'
          LET g_status.description = '没有此员工编号'
          LET l_return.code="-1"
          LET l_return.msg = "扫出信息录入失败"
          LET l_return.msg1 = "第'",l_a,"'笔"
          EXIT FOR     
       END IF 
       LET g_tc_shc.tc_shc12 = aws_ttsrv_getRecordField(l_node1,"tc_shc12") CLIPPED
       IF cl_null(g_tc_shc.tc_shc12) OR g_tc_shc.tc_shc12<=0 THEN
          LET g_status.code = '-1'
          LET g_status.description = '没有数量或者数量不能小于等于0'
          LET l_return.code="-1"
          LET l_return.msg = "扫出信息录入失败"
          LET l_return.msg1 = "第'",l_a,"'笔"
          EXIT FOR     
       END IF 
       LET g_tc_shc.tc_shc13 = aws_ttsrv_getRecordField(l_node1,"tc_shc13") CLIPPED
       #数量的判断，扫出数量不能大余完工数量
       SELECT SUM(tc_shb12-tc_shb121-tc_shb122) INTO l_tc_shb12 
         FROM tc_shb_file 
        WHERE tc_shb03 = g_tc_shc.tc_shc03
          AND tc_shb06 = g_tc_shc.tc_shc06
          AND tc_shb01 = '2'
       IF cl_null(l_tc_shb12) OR l_tc_shb12 = 0 THEN 
          LET g_status.code = '-1'
          LET g_status.description = '此LOT单没有完工'
          LET l_return.code="-1"
          LET l_return.msg = "扫出信息录入失败"
          LET l_return.msg1 = "第'",l_a,"'笔"
          EXIT FOR
       ELSE
          IF l_tc_shb12< g_tc_shc.tc_shc12 THEN 
             LET g_status.code = '-1'
             LET g_status.description = '完工数量不能小于扫出数量'
             LET l_return.code="-1"
             LET l_return.msg = "扫出信息录入失败"
             LET l_return.msg1 = "第'",l_a,"'笔"
             EXIT FOR
          END IF 
       END IF 

       #单据编号
       LET l_y =YEAR(g_today)
       LET l_y = l_y[3,4] USING '&&' 
       LET l_m =MONTH(g_today)
       LET l_m = l_m USING '&&' 
       LET l_str='OCA-',l_y clipped,l_m CLIPPED
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
           LET l_return.msg = "扫出信息录入失败"
           LET l_return.msg1 = "第'",l_a,"'笔"
           EXIT FOR 
       END IF 

       #数量的判断，同一个人，同一个工艺，同一个lot单必须先完工才能继续生成一笔数据
       IF g_tc_shc.tc_shc01 = '1' THEN 
          SELECT tc_shc12 INTO l_tc_shc12_1 FROM tc_shc_file 
           WHERE tc_shc03= g_tc_shc.tc_shc03 
             AND tc_shc06= g_tc_shc.tc_shc06
             AND tc_shc11= g_tc_shc.tc_shc11
             AND tc_shc01 = '1'
          SELECT tc_shc12 INTO l_tc_shc12_2 FROM tc_shc_file 
           WHERE tc_shc03= g_tc_shc.tc_shc03 
             AND tc_shc06= g_tc_shc.tc_shc06
             AND tc_shc11= g_tc_shc.tc_shc11
             AND tc_shc01 = '2'
          IF (cl_null(l_tc_shc12_2) OR (l_tc_shc12_2<>l_tc_shc12_1)) AND l_tc_shc12_1>0 THEN
             LET g_status.code = '-1'
             LET g_status.description = '有未扫描完的资料，清先扫描完此笔资料'
             LET l_return.code="-1"
             LET l_return.msg = "扫出信息录入失败"
             LET l_return.msg1 = "第'",l_a,"'笔"
             EXIT FOR
          END IF 
       END IF 

        #人员检核
       SELECT COUNT(*) INTO l_cnt FROM gen_file
        WHERE gen01=g_tc_shc.tc_shc11
          AND genacti = 'Y'
       IF l_cnt = 0 THEN
          LET g_status.code = '-1'
          LET g_status.description = '人员资料错误'
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
          LET g_status.description = '班别有错误'
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
       SELECT tc_shb04,tc_shb05,tc_shb07,tc_shb08,tc_shb10,tc_shb16 
         INTO g_tc_shc.tc_shc04,g_tc_shc.tc_shc05,g_tc_shc.tc_shc07,g_tc_shc.tc_shc08,  #add by guanyao160617
              g_tc_shc.tc_shc10,g_tc_shc.tc_shc16 FROM tc_shb_file                      #add by guanyao160617
        WHERE tc_shb03 = g_tc_shc.tc_shc03
          AND tc_shb06 = g_tc_shc.tc_shc06 
          AND tc_shb01 = '1'
       #end-----add by guanyao160617
    
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
          LET l_return.msg = "扫出信息录入失败"
          LET l_return.msg1 = "第'",l_a,"'笔"
          EXIT FOR 
       END IF
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

