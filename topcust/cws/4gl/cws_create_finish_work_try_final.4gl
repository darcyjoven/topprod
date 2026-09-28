# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: cws_create_finish_work.4gl
# Descriptions...: 创建开工数据
# Date & Author..: 16/06/06 By guanyao
#  Modify  ......: 新增报工精简  完工扫描后自动报工   tianry  161128


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
    DEFINE g_i       LIKE type_file.chr1  #add by guanyao160907
 
#[
# Description....: 提供建立开工資料的服務(入口 function)
# Date & Author..: No.FUN-B10004 16/06/06 By guanyao
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION cws_create_finish_work()
 
   WHENEVER ERROR CONTINUE
 
   CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
 
   #--------------------------------------------------------------------------#
   # 新增订單資料                                                       #
   #--------------------------------------------------------------------------#
   IF g_status.code = "0" THEN
      CALL cws_create_finish_work_process()
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
FUNCTION cws_create_finish_work_process()
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
    DEFINE l_tc_shb06      LIKE tc_shb_file.tc_shb06
    DEFINE l_tc_shb11      LIKE tc_shb_file.tc_shb11
    DEFINE l_tc_shb12      LIKE tc_shb_file.tc_shb12
    DEFINE lst_token base.StringTokenizer     
    DEFINE p_tok1    LIKE type_file.chr1000
    DEFINE l_x        LIKE type_file.num5
    DEFINE l_n        LIKE type_file.num5
    DEFINE l_err      LIKE type_file.chr1
    #str---add by guanyao160831 
    DEFINE l_tc_shc12_x  LIKE tc_shc_file.tc_shc12
    DEFINE l_tc_shc12_y  LIKE tc_shc_file.tc_shc12
    DEFINE l_tc_shb02    LIKE tc_shb_file.tc_shb02
    DEFINE l_sql         STRING 
    #end---add by guanyao160831
    #str---add by guanyao160904
    DEFINE l_tc_shb12_a  LIKE tc_shc_file.tc_shc12
    DEFINE l_tc_shb12_b  LIKE tc_shc_file.tc_shc12
    DEFINE l_tc_shb12_c  LIKE tc_shc_file.tc_shc12
    #end---add by guanyao160904
    DEFINE l_sfbud05     LIKE sfb_file.sfbud05
    DEFINE l_cmd       STRING
 
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
    LET l_tc_shb06 = aws_ttsrv_getParameter("tc_shb06")  #mark by guanyao160620
    IF cl_null(l_tc_shb06) THEN  #mark by guanyao160620
    #LET g_tc_shb.tc_shb08 = aws_ttsrv_getParameter("tc_shb06")  #add by guanyao160620
    #IF cl_null(g_tc_shb.tc_shb08) THEN   #add by guanyao160620
       LET g_status.code = '-1'
       LET g_status.description = '没有作业序号'
       LET l_return.code="-1"
       LET l_return.msg = "完工信息录入失败"
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       RETURN
    ELSE 
       #str----add by guanyao160620
       #SELECT sgm03 INTO l_tc_shb06 FROM sgm_file WHERE sgm01 = l_tc_shb03 AND sgm04 = g_tc_shb.tc_shb08
       #IF cl_null(l_tc_shb06) THEN 
       #   LET g_status.code = '-1'
       #  LET g_status.description = '没有工艺序号'
       #   LET l_return.code="-1"
       #   LET l_return.msg = "扫描信息录入失败"
       #   CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       #   RETURN
       #END IF 
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
       LET g_tc_shb.tc_shbud09 = aws_ttsrv_getParameter("pnl")   #add by guanyao160728
       IF cl_null(g_tc_shb.tc_shbud07)  THEN 
          LET g_status.code = '-1'
          LET g_status.description = '机器数不能为空'
          LET l_return.code="-1"
          LET l_return.msg = "完工信息录入失败"
          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
          RETURN
       END IF 
       IF cl_null(g_tc_shb.tc_shbud08)  THEN 
          LET g_status.code = '-1'
          LET g_status.description = '人数不能为空'
          LET l_return.code="-1"
          LET l_return.msg = "完工信息录入失败"
          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
          RETURN
       END IF 
       IF cl_null(g_tc_shb.tc_shbud09)  THEN 
          LET g_status.code = '-1'
          LET g_status.description = 'pnl量不能为空'
          LET l_return.code="-1"
          LET l_return.msg = "完工信息录入失败"
          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
          RETURN
       END IF
       #str----add by guanyao160727#机器或者人工可以一个为空
       IF (g_tc_shb.tc_shbud07+g_tc_shb.tc_shbud08) <= 0 THEN 
          LET g_status.code = '-1'
          LET g_status.description = '机器和人工总数不能为空'
          LET l_return.code="-1"
          LET l_return.msg = "完工信息录入失败"
          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
          RETURN
       END IF 
       #end----add by guanyao160727
       #end----add by guanyao160617

       #单据编号
       LET l_y =YEAR(g_today)
       LET l_y = l_y[3,4] USING '&&' 
       LET l_m =MONTH(g_today)
       LET l_m = l_m USING '&&' 
       #str---add by guanyao160806
       LET l_d = DAY(g_today)
       LET l_d = l_d USING '&&'
       #end---add by guanyao160806
       LET l_str='WGB-',l_y clipped,l_m CLIPPED,l_d CLIPPED
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
          #IF g_tc_shb.tc_shb12-g_tc_shb.tc_shb121-g_tc_shb.tc_shb122 < = 0 THEN 
          #   LET g_status.code = '-1'
          #   LET g_status.description = '完工数量不能小于等于0'
          #   LET l_return.code="-1"
          #   LET l_return.msg = "完工信息录入失败"
          #   CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
          #   RETURN 
          #END IF  
          IF (l_tc_shb12_2+g_tc_shb.tc_shb12+g_tc_shb.tc_shb121+g_tc_shb.tc_shb122)>l_tc_shb12 THEN
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
            #SELECT COUNT(*) INTO l_n FROM qce_file WHERE qce01 = l_barcode 
             SELECT COUNT(*) INTO l_n FROM qce_file WHERE qce01 = g_tc_shb.tc_shbud01
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
       #str----add by guanyao160831
       LET l_sql = "SELECT tc_shb12,tc_shb02 FROM tc_shb_file WHERE tc_shb03 = '",g_tc_shb.tc_shb03,"'",
                   "   AND tc_shb06 = '",g_tc_shb.tc_shb06,"'",
                   "   AND tc_shb11 = '",g_tc_shb.tc_shb11,"'", 
                   "   AND tc_shb01 = '1'"
       PREPARE l_pre221 FROM l_sql
       DECLARE l_cur221 CURSOR FOR l_pre221
       FOREACH l_cur221 INTO l_tc_shc12_x,l_tc_shb02
          SELECT SUM(tc_shb12+tc_shb121+tc_shb122) INTO l_tc_shc12_y FROM tc_shb_file WHERE tc_shbud02 = l_tc_shb02
          #str---add by guanyao160901
          IF cl_null(l_tc_shc12_y) THEN 
             LET l_tc_shc12_y= 0 
          END IF 
          #end---add by guanyao160901
          IF l_tc_shc12_y<l_tc_shc12_x THEN 
             LET g_tc_shb.tc_shbud02 = l_tc_shb02
          END IF 
       END FOREACH 
       #end----add by guanyao160831
       SELECT tc_shb04,tc_shb05,tc_shb07,tc_shb08,tc_shb09,tc_shb10,tc_shb16 
         INTO g_tc_shb.tc_shb04,g_tc_shb.tc_shb05,g_tc_shb.tc_shb07,g_tc_shb.tc_shb08,  #add by guanyao160617
              g_tc_shb.tc_shb09,g_tc_shb.tc_shb10,g_tc_shb.tc_shb16 FROM tc_shb_file  #add by guanyao160617
        WHERE tc_shb03 = g_tc_shb.tc_shb03
          AND tc_shb06 = g_tc_shb.tc_shb06 
          AND tc_shb01 = '1'

    
       LET g_tc_shb.tc_shb14 = g_today
       LET g_tc_shb.tc_shb15 = TIME 
       #CALL aws_ttsrv_setRecordField_record(l_node1,base.Typeinfo.create(g_tc_shb))

       #str------add by guanyao160903
       SELECT sfbud05 INTO l_sfbud05 FROM sfb_file WHERE sfb01 = g_tc_shb.tc_shb04
       IF cl_null(l_sfbud05) THEN LET l_sfbud05 = 'N' END IF
       #add by donghy 考虑一刀切的工单 160907
       IF g_sma.smaud02 = 'Y' AND l_sfbud05 = 'N' THEN 
          SELECT SUM(tc_shb12+tc_shb121+tc_shb122) INTO l_tc_shb12_a 
            FROM tc_shb_file 
           WHERE tc_shb03 = g_tc_shb.tc_shb03
             AND tc_shb06 = g_tc_shb.tc_shb06
             AND tc_shb01 = '2'
          SELECT SUM(tc_shc12) INTO l_tc_shb12_b 
            FROM tc_shc_file
           WHERE tc_shc03 = g_tc_shb.tc_shb03
             AND tc_shc06 = g_tc_shb.tc_shb06
             AND tc_shc01 = '1'
          IF cl_null(l_tc_shb12_a) THEN 
             LET l_tc_shb12_a = 0
          END IF 
          IF cl_null(l_tc_shb12_b) THEN 
             LET l_tc_shb12_b = 0
          END IF
         #简化报工 ly 180105 
         # LET l_tc_shb12_c = l_tc_shb12_b - l_tc_shb12_a
           LET l_tc_shb12_c = l_tc_shb12_a 
         IF l_tc_shb12_c >0 THEN 
             IF  l_tc_shb12_c >(g_tc_shb.tc_shb12+g_tc_shb.tc_shb121+g_tc_shb.tc_shb122) THEN 
                LET l_tc_shb12_c = g_tc_shb.tc_shb12+g_tc_shb.tc_shb121+g_tc_shb.tc_shb122
             END IF 
             SELECT COUNT(*) INTO l_x FROM sfa_file,sfb_file 
              WHERE sfb01 = g_tc_shb.tc_shb04 
                AND sfb01 = sfa01 
                AND sfa11 = 'E' 
                AND sfa08 = g_tc_shb.tc_shb08
             IF l_x >0 THEN 
                CALL cws_create_finish_work_ins_sfp(g_tc_shb.tc_shb02,g_tc_shb.tc_shb04,g_tc_shb.tc_shb08,g_tc_shb.tc_shb09,l_tc_shb12_c)
             END IF 
          END IF 
          IF g_success = 'N' THEN 
             RETURN 
          END IF 
       END IF 
       #end------add by guanyao160903
 
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
        #  tianry add 161129
       IF g_success='Y' THEN
          LET l_cmd=" csfp730 '",g_tc_shb.tc_shb03,"'  '",g_tc_shb.tc_shb08,"' "
          CALL cl_cmdrun(l_cmd)
          LET l_cmd=" csfp002 '",g_tc_shb.tc_shb03,"'  '",g_tc_shb.tc_shb08,"' "
          CALL cl_cmdrun(l_cmd)
       END IF
       #tianry add end 
END FUNCTION
#str-----add by guanyao160903
FUNCTION cws_create_finish_work_ins_sfp(p_tc_shb02,p_tc_shb04,p_tc_shb08,p_tc_shb09,p_tc_shb12)
DEFINE l_sfp           RECORD LIKE sfp_file.*
DEFINE l_sfs           RECORD LIKE sfs_file.*
DEFINE l_sfa           RECORD LIKE sfa_file.*
DEFINE li_result       LIKE type_file.num5
DEFINE l_t             LIKE sfp_file.sfp01
DEFINE p_tc_shb02      LIKE tc_shb_file.tc_shb02
DEFINE p_tc_shb04      LIKE tc_shb_file.tc_shb04
DEFINE p_tc_shb08      LIKE tc_shb_file.tc_shb08
DEFINE p_tc_shb09      LIKE tc_shb_file.tc_shb09
DEFINE p_tc_shb12      LIKE tc_shb_file.tc_shb12
DEFINE p_nn            LIKE type_file.num10
DEFINE p_nn1           LIKE type_file.num10
DEFINE p_sfs09         LIKE sfs_file.sfs09
DEFINE p_img10         LIKE img_file.img10
DEFINE p_gg            LIKE type_file.chr1
DEFINE l_qty           LIKE sfa_file.sfa05 
DEFINE l_qty1          LIKE sfa_file.sfa05
DEFINE l_qty2          LIKE sfa_file.sfa05 
DEFINE l_qty_sum       LIKE sfa_file.sfa05
DEFINE p_sum3          LIKE img_file.img10
DEFINE p_sql           STRING
DEFINE l_cnt           LIKE type_file.num5
DEFINE l_x             LIKE type_file.num5
DEFINE l_yy,l_mm       LIKE type_file.num10
DEFINE l_fac           LIKE img_file.img34 
DEFINE l_i             LIKE type_file.num5
DEFINE l_ima25         LIKE ima_file.ima25
DEFINE l_in_old        LIKE tc_shb_file.tc_shb12
DEFINE l_in_new        LIKE tc_shb_file.tc_shb12
DEFINE l_need          LIKE sfa_file.sfa06
DEFINE l_str2          STRING   #add by lifang 201117
#add by lifang201117--s
LET l_str2 = " 看走不走cws_create_finish_work_try_final_process  ","\n"
RUN " echo '"||l_str2||"' >> /u1/topprod/topcust/cws/4gl/asfi514_zhangsba_createfinishwork.log"
#add by lifang201117--e


    DROP TABLE tmp_700                                                                                                             
   CREATE TEMP TABLE tmp_700(                                                                                                                 
    a         LIKE oea_file.oea01,                                                                                                
    b         LIKE type_file.chr1000,                                                                                                 
    c         LIKE type_file.num15_3);
    LET g_success = 'Y'
    LET g_i = 'Y'
    BEGIN WORK 
    INITIALIZE l_sfp.* TO NULL
    LET l_sfp.sfp02  =g_today
    LET l_sfp.sfp03  =g_today
    CALL s_yp(l_sfp.sfp03) RETURNING l_yy,l_mm

    IF l_yy > g_sma.sma51 THEN      # 與目前會計年度,期間比較
       LET g_status.code = '-1'
       LET g_status.description = '日期年度大于当前使用会计年度!!!'
       LET g_success = 'N'
       RETURN 
    ELSE
       IF l_yy=g_sma.sma51 AND l_mm > g_sma.sma52 THEN
          LET g_status.code = '-1'
          LET g_status.description = '日期月份大於当前使用会计期间!!!!!!'
          LET g_success = 'N'
          RETURN 
       END IF
    END IF
    LET l_sfp.sfp04  ='N'
    LET l_sfp.sfpconf='N'
    LET l_sfp.sfp05  ='N'
    LET l_sfp.sfp06  ='4'
    LET l_sfp.sfp09  ='N'
    LET l_sfp.sfpuser=g_user  
    LET l_sfp.sfporiu = g_user 
    LET l_sfp.sfporig = g_grup 
    LET l_sfp.sfpgrup=g_grup  
    LET l_sfp.sfpdate=g_today 
    LET l_sfp.sfp07  =g_grup  
    LET l_sfp.sfp15 = '0'     
    LET l_sfp.sfpmksg = "N"
    LET l_sfp.sfp16 = g_user
    LET l_sfp.sfpud04 = p_tc_shb02
    LET l_sfp.sfpplant = g_plant 
    LET l_sfp.sfplegal = g_legal
    SELECT smyslip INTO l_t FROM (SELECT 'N',smyslip,smydesc,smyauno,smydmy5  FROM smy_file WHERE 1=1 AND smyslip NOT IN (SELECT rye04 FROM rye_file WHERE ryeacti = 'Y'
       AND upper(rye01) = 'ASF' AND rye04 IS NOT NULL) AND smyacti='Y' AND upper(smysys) ='ASF' AND smykind ='3' AND  (smy73 <> 'Y' OR smy73 is null) 
             AND smy72='4'  order by dbms_random.value) where rownum=1;
    IF l_t IS NOT NULL THEN
       LET l_sfp.sfp01 = l_t
    ELSE
       #CALL cl_err('',109,0)
       LET g_status.code = '-1'
       LET g_status.description = '没有欠料单单别'
       LET g_success = 'N'
       RETURN
    END IF
    CALL s_auto_assign_no("asf",l_sfp.sfp01,l_sfp.sfp02,"","sfp_file","sfp01","","","")
       RETURNING li_result,l_sfp.sfp01
    IF (NOT li_result) THEN
       #CALL s_errmsg('sfs04',l_sfs.sfs04,'',130,1)
       LET g_status.code = '-1'
       LET g_status.description = '没有欠料单单别'
       LET g_success = 'N'
       RETURN
    END IF
    INSERT INTO sfp_file VALUES(l_sfp.*)
    IF SQLCA.sqlcode THEN                    
       #CALL cl_err3("ins","sfp_file",l_sfp.sfp01,"",SQLCA.sqlcode,"","",1)
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       LET g_success = 'N'
       RETURN 
    END IF

    DECLARE p700sub_sfs_cur CURSOR WITH HOLD FOR                                                                                  
     SELECT sfa_file.* FROM sfb_file,sfa_file                                                                             
      WHERE sfb01 = p_tc_shb04                                                                              
        AND sfb01 = sfa01                                                                                                       
        AND sfa11 = 'E'
        AND sfa08 = p_tc_shb08
      ORDER BY sfa26 
    FOREACH p700sub_sfs_cur INTO l_sfa.*    
       IF l_sfa.sfa05 IS NULL THEN LET l_sfa.sfa05 = 0 END IF
       IF l_sfa.sfa06 IS NULL THEN LET l_sfa.sfa06 = 0 END IF
       LET l_qty1=l_qty2:=l_qty_sum:=0  #by liupeng 141101 add
       LET l_qty2 = l_sfa.sfa05 - l_sfa.sfa06   #料号未发料量
       IF l_qty2 < = 0 THEN                     #不欠料，就不产生领料单
          CONTINUE FOREACH
       ELSE
          SELECT SUM(sfs05) INTO l_qty_sum     #未过账领料单的发料量
           FROM sfs_file,sfp_file
           WHERE sfs01 = sfp01
             AND (sfpconf = 'N' OR (sfpconf = 'Y' AND sfp04 <> 'Y'))
             AND sfs03 = l_sfa.sfa01
             AND sfs04 = l_sfa.sfa03
             AND sfs10 = l_sfa.sfa08
          IF cl_null(l_qty_sum) THEN LET l_qty_sum = 0 END IF #by liupeng 141101 add
          LET l_qty1 = l_qty2 - l_qty_sum       #未产生领料单的数量
          IF l_qty1 < = 0 THEN
             LET g_success = 'N'
             LET g_showmsg = l_sfa.sfa01,'/',l_sfa.sfa03
             #CALL s_errmsg('sfa01,sfa03',g_showmsg,'','csf-010',1)
             LET g_status.code = '-1'
             LET g_status.description = "有未过账的欠料单"
             CONTINUE FOREACH
          END IF
       END IF
       #add by donghy 160905--start
       #部分材料可能通过欠料补料已发，因此需要计算 (工单该作业编号已完工量+工单作业编号本次完工量)/QPA < 该料号已发量
       #l_in_old 当站已完工量;l_in_new当站本次完工量;l_need总入库量应发料件总量; l_sfa06 工单备料已发数量
       SELECT SUM(tc_shb12) INTO l_in_old FROM tc_shb_file 
         WHERE tc_shb04=l_sfa.sfa01 AND tc_shb08=l_sfa.sfa08 AND tc_shb01='2'
       IF cl_null(l_in_old) THEN LET l_in_old = 0 END IF
       IF cl_null(p_tc_shb12) OR p_tc_shb12 = 0 THEN CONTINUE FOREACH END IF
       LET l_in_new = p_tc_shb12
       
       LET l_need = (l_in_old  + l_in_new ) * l_sfa.sfa161
       #当总需求量小于已发数量，则该笔单身不需要产生
       IF l_need < l_sfa.sfa06 THEN
          CONTINUE FOREACH
       END IF
       #add by donghy 160905--end

       INITIALIZE l_sfs.* TO NULL 
       LET l_sfs.sfs01 = l_sfp.sfp01 
       LET l_sfs.sfs03 = l_sfa.sfa01
       LET l_sfs.sfs04 = l_sfa.sfa03
       IF l_sfa.sfa161 IS NULL THEN LET l_sfa.sfa161 = 0 END IF
       LET l_sfs.sfs06 = l_sfa.sfa12  #發料單位 
       LET p_nn = 0  #by liupeng 141101 add 
       SELECT COUNT(*) INTO p_nn FROM img_file    #没有库存
        WHERE img01 = l_sfs.sfs04
          AND img02 = 'XBC'
          AND img03 = p_tc_shb09
          AND img10 > 0
       LET p_sum3 = 0  #by liupeng 141101 add
       SELECT NVL(SUM(img10),0) INTO p_sum3     #库存库存不足
         FROM img_file
        WHERE img01 = l_sfs.sfs04
          AND img02 = 'XBC'
          AND img03 = p_tc_shb09
          AND img18 >= g_today   #add by guanyao160920
       SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = l_sfs.sfs04
       CALL s_umfchk(l_sfs.sfs04,l_ima25,l_sfa.sfa12) 
            RETURNING l_i,l_fac
       #str------add by guanyao160912
       #IF l_i = 1 THEN LET l_fac = 1 END IF
       IF l_i = 1 THEN 
          LET g_status.code = '-1'
          LET g_status.description = "库存单位和发料单位之间没有单位转换'",l_sfs.sfs04,"'"
          LET g_success = 'N'
          CONTINUE FOREACH
       END IF
       #end------add by guanyao160912 
       LET p_sum3 = p_sum3*l_fac
       LET p_tc_shb12 = p_tc_shb12*l_sfa.sfa161
       LET p_tc_shb12=s_digqty(p_tc_shb12,l_sfa.sfa12)
       IF p_nn = 0 OR (p_sum3 < p_tc_shb12) THEN 
          #CALL s_errmsg('sfs04',l_sfs.sfs04,'',129,1)
          LET g_status.code = '-1'
          LET g_status.description = "没有库存'",l_sfs.sfs04,"'"
          LET g_success = 'N'
          CONTINUE FOREACH
       END IF
       LET p_sql = " SELECT img04,img10 from img_file ",
                   " WHERE img01 = '",l_sfs.sfs04,"' ",
                   "   AND img02 = 'XBC' ",
                   "   AND img03 = '",p_tc_shb09,"' ",
                   "   AND img10 > 0",
                   "   AND img18 >= '",g_today,"' ",       #add by guanyao160920
                   " ORDER BY img22 DESC,img22 ASC,img15 ASC"
       PREPARE p700_img5 FROM p_sql
       DECLARE img5_curs CURSOR FOR p700_img5
       FOREACH img5_curs INTO p_sfs09,p_img10
          LET l_sfs.sfs07 = 'XBC'
          LET l_sfs.sfs08 = p_tc_shb09
          LET l_sfs.sfs09 = p_sfs09
          #数量处理例如两个批号个1000的量 工单2张按比例分配为1400,600
          SELECT MAX(sfs02) INTO l_cnt FROM sfs_file                                                                                
           WHERE sfs01 = l_sfp.sfp01
          IF l_cnt IS NULL THEN    #項次                                                                                            
             LET l_cnt = 1                                                                                                          
          ELSE  
             LET l_cnt = l_cnt + 1                                                                                               
          END IF
          LET l_sfs.sfs02 = l_cnt
          IF p_img10 > 0 AND p_img10 >= p_tc_shb12 THEN
             LET p_gg = 'Y'
             LET l_sfs.sfs32= p_tc_shb12
             LET l_sfs.sfs05= p_tc_shb12
          ELSE
             LET p_gg = 'N'
             LET l_sfs.sfs32 = p_img10
             LET l_sfs.sfs05 = p_img10
             LET p_tc_shb12 = p_tc_shb12 - p_img10
          END IF
                                                                                
          LET l_sfs.sfs10 = l_sfa.sfa08  #作業序號                                                                                  
          LET l_sfs.sfs26 = NULL         #替代碼                                                                                    
          LET l_sfs.sfs27 = NULL         #被替代料號                                                                                
          LET l_sfs.sfs28 = NULL         #替代率   
          LET l_sfs.sfsplant = g_plant
          LET l_sfs.sfslegal = g_legal
          LET l_sfs.sfs014 = ' '
          LET l_sfs.sfs012 = l_sfa.sfa012  #FUN-A60076
          LET l_sfs.sfs013 = l_sfa.sfa013  #FUN-A60076
          IF l_sfa.sfa26 MATCHES '[SUTZ]' THEN      #FUN-A20037 
             LET l_sfs.sfs26 = l_sfa.sfa26
             LET l_sfs.sfs27 = l_sfa.sfa27
             LET l_sfs.sfs28 = l_sfa.sfa28
             LET l_sfs.sfs05 = p_tc_shb12*l_sfa.sfa161   #MOD-A70228
             SELECT SUM(c) INTO l_qty FROM tmp_700 WHERE a = l_sfa.sfa01                                                                
                AND b = l_sfa.sfa27                                                                                                 
             IF l_sfs.sfs05 < l_qty THEN                                                                                            
                LET l_sfs.sfs05 = 0 
             ELSE                                                                                                                   
                LET l_sfs.sfs05 = l_sfs.sfs05 - l_qty                                                                               
             END IF                                                                                                                 
          ELSE                                                                                                                      
             LET l_sfs.sfs27 = l_sfa.sfa27                                                                                          
          END IF                                                                                                                    
          CALL p700_chk_ima64(l_sfs.sfs04, l_sfs.sfs05) RETURNING l_sfs.sfs05                                                                                                                         
          IF cl_null(l_sfs.sfs07) AND cl_null(l_sfs.sfs08) THEN                                                                     
             SELECT ima35,ima36 INTO  l_sfs.sfs07,l_sfs.sfs08                                                                       
               FROM ima_file                                                                                                        
              WHERE ima01 = l_sfs.sfs04    
          END IF                                                                                                                    
          IF l_sfs.sfs07 IS NULL THEN LET l_sfs.sfs07 = ' ' END IF                                                                  
          IF l_sfs.sfs08 IS NULL THEN LET l_sfs.sfs08 = ' ' END IF                                                                  
          IF l_sfs.sfs09 IS NULL THEN LET l_sfs.sfs09 = ' ' END IF                                                                  
          INSERT INTO tmp_700 
            VALUES(l_sfa.sfa01,l_sfa.sfa27,l_sfs.sfs05)                                             
            INSERT INTO sfs_file VALUES (l_sfs.*)
            IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
              #CALL cl_err('ins sfs',STATUS,0)
              LET g_status.code = '-1'
              LET g_status.description = '没有欠料单单别'
              LET g_success = 'N'
            END IF
         IF p_gg = 'Y' THEN
            EXIT FOREACH
         END IF
         END FOREACH
    END FOREACH     
    LET l_x = 0
    SELECT COUNT(*) INTO l_x FROM sfs_file WHERE sfs01 = l_sfs.sfs01
    IF cl_null(l_x) OR l_x =0 THEN
      #str---add by guanyao160907
      IF g_success = 'Y' THEN 
         LET g_i = 'N'
         DELETE FROM sfp_file WHERE sfp01 = l_sfp.sfp01
      END IF  
      #end---add by guanyao160907
       #LET g_success = 'N'
    END IF 
    LET g_prog = 'asfi514'
#--add by lifang 201117 begin#
    LET l_str2 = l_sfp.sfp01," chk g_success  ",g_success," g_i ",g_i,"\n"
    RUN " echo '"||l_str2||"' >> /u1/topprod/topcust/cws/4gl/asfi514_zhangsba_createfinishwork.log"
#--add by lifang 201117 end#
    IF g_success = 'Y' AND g_i = 'Y' THEN 
       #CALL i501sub_y_chk(l_sfp.sfp01,"confirm")
       #IF g_success = 'Y' THEN 
#--add by lifang 201117 begin#
    LET l_str2 = l_sfp.sfp01," before i501sub_y_upd ","\n"
    RUN " echo '"||l_str2||"' >> /u1/topprod/topcust/cws/4gl/asfi514_zhangsba_createfinishwork.log"
#--add by lifang 201117 end#
          CALL i501sub_y_upd(l_sfp.sfp01,'confirm',TRUE) 
              RETURNING l_sfp.*      
#--add by lifang 201117 begin#
    LET l_str2 = l_sfp.sfp01," after i501sub_y_upd  g_success=",g_success,"\n"
    RUN " echo '"||l_str2||"' >> /u1/topprod/topcust/cws/4gl/asfi514_zhangsba_createfinishwork.log"
#--add by lifang 201117 end#
          IF g_success = 'Y' THEN 
#--add by lifang 201117 begin#
    LET l_str2 = l_sfp.sfp01," before i501sub_s ","\n"
    RUN " echo '"||l_str2||"' >> /u1/topprod/topcust/cws/4gl/asfi514_zhangsba_createfinishwork.log"
#--add by lifang 201117 end#
             CALL i501sub_s('1',l_sfp.sfp01,TRUE,'N')
#--add by lifang 201117 begin#
    LET l_str2 = l_sfp.sfp01," after i501sub_s g_success=",g_success,"\n"
    RUN " echo '"||l_str2||"' >> /u1/topprod/topcust/cws/4gl/asfi514_zhangsba_createfinishwork.log"
#--add by lifang 201117 end#
          END IF 
       #END IF 
    END IF 

    IF g_success = 'Y' THEN 
       COMMIT WORK 
    ELSE 
       ROLLBACK WORK 
    END IF 

END FUNCTION 

FUNCTION p700_chk_ima64(p_part, p_qty)
  DEFINE p_part		LIKE ima_file.ima01
  DEFINE p_qty		LIKE ima_file.ima641   #No.FUN-680121 DEC(15,3)
  DEFINE l_ima108	LIKE ima_file.ima108
  DEFINE l_ima64	LIKE ima_file.ima64
  DEFINE l_ima641	LIKE ima_file.ima641
  DEFINE i		LIKE type_file.num10   #No.FUN-680121 INTEGER
 
  SELECT ima108,ima64,ima641 INTO l_ima108,l_ima64,l_ima641 FROM ima_file
   WHERE ima01=p_part
  IF STATUS THEN RETURN p_qty END IF
 
  IF l_ima108='Y' THEN RETURN p_qty END IF
 
  IF l_ima641 != 0 AND p_qty<l_ima641 THEN
     LET p_qty=l_ima641
  END IF
 
  IF l_ima64<>0 THEN
     LET i=p_qty / l_ima64 + 0.999999
     LET p_qty= i * l_ima64
  END IF
  RETURN p_qty
 
END FUNCTION
#end-----add by guanyao160903

