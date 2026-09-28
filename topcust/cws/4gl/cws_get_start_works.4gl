# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#{
# Program name...: cws_get_start_works.4gl
# Descriptions...: 获取开工资料
# Date & Author..: 2016/06/03 by guanyao
# Modify.........: No.160728 16/07/28 By guanyao不需要管控一张工单LOT单的顺序
# Modify .......: 同一工序 可不同人 做开工完工  ly 180528
 
 
DATABASE ds
 
 
GLOBALS "../../../tiptop/config/top.global"
 
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
#[
# Description....: 提供取得 ERP 客戶編號列表服務(入口 function)
# Date & Author..: 2015/11/04 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]

                   
FUNCTION cws_get_start_works()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL cws_get_start_works_process()
    END IF
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 检验逻辑
# Date & Author..: 2016/06/03 by guanyao
# Parameter......: none
# Return.........: none
# Memo...........:
#
#]
FUNCTION cws_get_start_works_process()
    DEFINE l_barcode     LIKE shm_file.shm01
    DEFINE l_lot         LIKE shm_file.shm01   #add by guanyao160718
    DEFINE l_step        LIKE type_file.num5   #add by guanyao160718
    DEFINE l_user        LIKE shm_file.shmuser #add by guanyao160718 
    DEFINE l_sql   STRING
    DEFINE l_node  om.DomNode
    DEFINE l_statuscode     LIKE type_file.chr10
    DEFINE l_msg            STRING
    DEFINE l_n        LIKE type_file.num10
    DEFINE l_return1   RECORD 
           statu      LIKE type_file.chr1,     #状况码
           shm01      LIKE shm_file.shm01,     #LOT单号
           shm012     LIKE shm_file.shm012,    #工单号
           shm05      LIKE shm_file.shm05,     #料号
           ima02      LIKE ima_file.ima02      #品名
         END RECORD 
    DEFINE l_return2   RECORD    
           statu      LIKE type_file.chr1,     #状况码
           sgm04      LIKE sgm_file.sgm04,     #工艺编号
           sgm58      LIKE sgm_file.sgm58,     #单位
           sgm03      LIKE sgm_file.sgm03,     #工艺序号
           sgm45      LIKE sgm_file.sgm45,     #工艺名称
           sgm06      LIKE sgm_file.sgm06,     #工作站编号
           eca02      LIKE eca_file.eca02      #工作站名称
           ,number    LIKE tc_shc_file.tc_shc12  #add by guanyao160718
           ,pnl       LIKE type_file.num10     #add by guanyao160727
           ,change    LIKE type_file.chr1        #add by guanyao160727
           ,lv        LIKE ima_file.imaud10     #add by guanyao160727
         END RECORD
    DEFINE l_return3  RECORD 
           statu      LIKE type_file.chr1,        #状况码
           gen01      LIKE gen_file.gen01,        #报工人员
           gen02      LIKE gen_file.gen02         #人员名称
         END RECORD 
    DEFINE l_return4  RECORD 
           statu      LIKE type_file.chr1,     #状况码
           ecg01      LIKE ecg_file.ecg01,     #班别
           ecg02      LIKE ecg_file.ecg02      #班别班别
         END RECORD  
    #str----add by guanyao160718
    DEFINE l_return5  RECORD 
           statu      LIKE type_file.chr1,     #状况码
           eca01      LIKE eca_file.eca01,     #班别
           eca02      LIKE eca_file.eca02      #班别班别
         END RECORD 
    #end----add by guanyao160718
    DEFINE l_ta_shm02 LIKE shm_file.ta_shm02  #add by guanyao160720
    DEFINE l_flag     LIKE type_file.chr1         #add by guanyao160720
    DEFINE l_shm012   LIKE shm_file.shm012        #add by guanyao160720
    DEFINE l_ta_ecd04 LIKE ecd_file.ta_ecd04      #add by guanyao160806
    DEFINE l_sfb04    LIKE sfb_file.sfb04          #tianry add 161207    
    DEFINE l_ta_sgm06  LIKE sgm_file.ta_sgm06
    DEFINE  l_sfbud11  LIKE sfb_file.sfbud11
 

    LET l_statuscode = '0'                  
    LET l_msg = ''

    LET l_barcode = aws_ttsrv_getParameter("barcode")
    LET l_lot     = aws_ttsrv_getParameter("lot") #add by guanyao160718
    LET l_step    = aws_ttsrv_getParameter("step") #add by guanyao160718
    LET l_user = g_user   #add by guanyao160718
    
    IF cl_null(l_barcode) THEN 
       LET g_status.code = -1
       LET g_status.description = '条码为空,请检查!'
       RETURN
    END IF 
    #str-----add by guanyao160928
    IF g_sma.smaud03 = 'Y' THEN  
       LET g_status.code = -1
       LET g_status.description = '盘点中不能报工'
       RETURN
    END IF 
    
    #end-----add by guanyao160928
    #LOT单号
    SELECT COUNT(*) INTO l_n FROM shm_file WHERE shm01=l_barcode 
    IF l_n=1 THEN
         #str----add by guanyao160720
         LET l_ta_shm02 = ''
         LET l_shm012 = ''
         SELECT ta_shm02,shm012 INTO l_ta_shm02,l_shm012 FROM shm_file WHERE shm01=l_barcode 
         IF l_ta_shm02 = 'N' THEN 
            LET g_status.code = -1
            LET g_status.description = '此LOT单号已被挂起'
            RETURN 
         END IF 
         #tianry add 161207
         SELECT sfb04 INTO l_sfb04 FROM sfb_file,shm_file WHERE sfb01=shm012 AND shm01=l_barcode
         IF l_sfb04='8' THEN
            LET g_status.code = -1
            LET g_status.description = '此工单已经结案'
            RETURN
         END IF

         #tianry add end
         #str----mark by guanyao160728
         # CALL cws_get_start_s(l_barcode,l_shm012) RETURNING l_flag    #mark by guanyao160728
         # IF l_flag = '1' THEN 
         #    LET g_status.code = -1
         #    LET g_status.description = '检查前一笔LOT单是否有单身'
         #    RETURN 
         # END IF 
         # IF l_flag = '2' THEN 
         #    LET g_status.code = '-1'
         #    LET g_status.description = '前一张LOT工艺没有完成'
         #    RETURN 
         # END IF 
         #end----mark by guanyao160728
         #end----add by guanyao160720
    	 SELECT '1',shm01,shm012,shm05,ima02 INTO l_return1.* 
           FROM shm_file LEFT JOIN ima_file ON ima01 = shm05
          WHERE shm01=l_barcode 
    	 LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_return1), "Master")
    ELSE 
       #工艺编号
       SELECT COUNT(*) INTO l_n FROM sgm_file WHERE sgm04 =l_barcode
       IF l_n > 0 THEN
          IF NOT cl_null(l_lot) THEN 
             #str------add by guanyao160806
             LET l_ta_ecd04 = ''
             SELECT ta_ecd04 INTO l_ta_ecd04 FROM ecd_file WHERE ecd01 = l_barcode
             IF l_ta_ecd04 = 'Y' THEN 
                #IF l_step = '2' OR l_step = '3' THEN   #mark by guanyao160808
                IF l_step = '1' OR l_step = '4' THEN 
                   LET g_status.code = -1
                   #LET g_status.description = '此作业编号不需要开工和完工'
                   LET g_status.description = '此作业编号不需要扫入和扫出'
                   RETURN  
                END IF 
             END IF  
             #end------add by guanyao160806
               #tianry add 161225
             SELECT ta_sgm06 INTO l_ta_sgm06 FROM sgm_file
             WHERE sgm01=l_lot AND sgm04=l_barcode
             SELECT sfbud11 INTO l_sfbud11 FROM sfb_file,shm_file  WHERE sfb01=shm012
             AND shm01=l_lot   
             
             IF (cl_null(l_ta_sgm06) OR l_ta_sgm06='N')  AND NOT cl_null(l_sfbud11) THEN
                LET g_status.code = -1
                LET g_status.description = '此作业编号无需扫描'
                RETURN
             END IF

              #tianry add end 161225

             LET l_n =0
             SELECT COUNT(*) INTO l_n FROM sgm_file 
              WHERE sgm04=l_barcode
                AND sgm01 = l_lot
             IF l_n =1 THEN 
                #tianry add 161207
                SELECT sfb04 INTO l_sfb04 FROM sfb_file,shm_file WHERE sfb01=shm012 AND shm01=l_lot
                IF l_sfb04='8' THEN
                   LET g_status.code = -1
                   LET g_status.description = '此工单已经结案'
                   RETURN
                END IF
               #tianry add 161207
                SELECT DISTINCT '2',sgm04,sgm58,sgm03,sgm45,sgm06,eca02,0,0,ta_ecd03,
             #                  CASE ta_ecd03 WHEN 'N' THEN 1 ELSE imaud10 END IF  #add by guanyao160727
                                CASE ta_ecd03 WHEN 'N' THEN 1 ELSE sfbud10 END CASE  #add by guanyao160929
                  INTO l_return2.*
                  FROM sgm_file LEFT JOIN eca_file ON eca01 = sgm06,
                       #ecd_file,shm_file,ima_file#add by guanyao160727
                       ecd_file,shm_file,sfb_file #add by guanyao160929
                 WHERE sgm04=l_barcode
                   AND sgm01 = l_lot   #add by guanyao160718
                   AND sgm04 = ecd01   #add by guanyao160727
                   AND sgm01 = shm01   #add by guanyao160727
                   #AND shm05 = ima01   #add by guanyao160727
                   AND sfb01 =shm012   #add by guanyao160929                
                CALL get_start_works_sum(l_lot,l_barcode,l_user,l_step,l_ta_ecd04)         #add by guanyao160718
                   RETURNING l_return2.number
                #str----add by guanyao160808
                IF  g_status.code = -1 THEN 
                   RETURN 
                END IF 
                #end=----add by guanyao160808
                #str-----add by guanyao160727#增加三个栏位PNL量,转换否,转换率
                IF cl_null(l_return2.lv) OR l_return2.lv = 0 THEN 
                   LET g_status.code = -1
                   LET g_status.description = '没有排版数'
                   RETURN 
                END IF  
                LET l_return2.pnl = l_return2.number/l_return2.lv   #add by guanyao160728
                SELECT ceil(l_return2.pnl) INTO l_return2.pnl FROM dual #add by guanyao160728
                #end-----add by guanyao160727
                LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_return2), "Master")
             ELSE 
                LET g_status.code = -1
                LET g_status.description = '此LOT单号没有此作业编号'
             END IF 
          ELSE 
             LET g_status.code = -1
             LET g_status.description = '没有工艺，无法确认工序'
          END IF 
       ELSE 
          #报工人员
          #SELECT count(*) INTO l_n FROM gen_file WHERE gen01=l_barcode
          #IF l_n = 1 THEN 
          #   SELECT '3',gen01,gen02 INTO l_return3.* FROM gen_file WHERE gen01 = l_barcode
          #   LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_return3), "Master")
          #ELSE 
             #班别
             SELECT COUNT(*) INTO l_n FROM ecg_file WHERE ecg01 = l_barcode
             IF l_n = 1 THEN 
                SELECT '4',ecg01,ecg02 INTO l_return4.* FROM ecg_file WHERE ecg01 = l_barcode
                LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_return4), "Master")
             ELSE 
                #工作站
                #str-----add by guanyao160718
                SELECT COUNT(*) INTO l_n FROM eca_file WHERE eca01 = l_barcode
                IF l_n >0 THEN 
                   SELECT '5',eca01,eca02 INTO l_return5.* FROM eca_file WHERE eca01  = l_barcode
                   LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_return5), "Master")
                ELSE
                #end-----add by guanyao160718                
                   LET g_status.code = -1
                   LET g_status.description = '没有开工资料'
                   RETURN
                END IF 
             END IF 
          #END IF 
       END IF 
    END IF 
    	    
END FUNCTION

#str----add by guanyao160718
FUNCTION get_start_works_sum(p_lot,p_barcode,p_user,p_step,p_ta_ecd04)         #add by guanyao160718
DEFINE p_lot           LIKE shm_file.shm01
DEFINE p_barcode       LIKE shm_file.shm01
DEFINE p_user          LIKE shm_file.shmuser
DEFINE p_step          LIKE type_file.num5
DEFINE l_shm012        LIKE shm_file.shm012
DEFINE l_shm05         LIKE shm_file.shm05
DEFINE l_shm08         LIKE shm_file.shm08 
DEFINE l_sgm03         LIKE sgm_file.sgm03
DEFINE l_a_sgm03       LIKE sgm_file.sgm03
DEFINE l_over_qty      LIKE sfv_file.sfv09
DEFINE l_c,l_x         LIKE type_file.num5
DEFINE l_sum           LIKE tc_shc_file.tc_shc12
DEFINE l_sum1          LIKE tc_shc_file.tc_shc12
DEFINE l_shm01         LIKE shm_file.shm01
DEFINE l_max_sgm03     LIKE sgm_file.sgm03
DEFINE l_tc_shc12_a    LIKE tc_shc_file.tc_shc12
DEFINE l_tc_shc12_b    LIKE tc_shc_file.tc_shc12
DEFINE l_tc_shc12_1    LIKE tc_shc_file.tc_shc12
DEFINE l_tc_shc12_2    LIKE tc_shc_file.tc_shc12
DEFINE l_tc_shc12      LIKE tc_shc_file.tc_shc12
DEFINE l_sgm62         LIKE sgm_file.sgm62
DEFINE l_sgm63         LIKE sgm_file.sgm63
DEFINE l_cnt           LIKE type_file.num10
DEFINE l_ima153        LIKE ima_file.ima153
DEFINE l_tc_shb12_a    LIKE tc_shb_file.tc_shb12
DEFINE l_tc_shb12_b    LIKE tc_shb_file.tc_shb12
DEFINE l_ta_shm04      LIKE shm_file.ta_shm04    #add by guanyao160801
DEFINE l_sgm301        LIKE sgm_file.sgm301      #add by guanyao160801
DEFINE p_ta_ecd04      LIKE ecd_file.ta_ecd04    #add by guanyao160806
DEFINE l_tc_shb12      LIKE tc_shb_file.tc_shb12 #add by guanyao160808
DEFINE l_ta_ecd04      LIKE ecd_file.ta_ecd04    #add by guanyao160808
DEFINE l_tc_shb12_f    LIKE tc_shb_file.tc_shb12 #add by guanyao160808
DEFINE l_yong          LIKE tc_shb_file.tc_shb12 #add by guanyao160904
DEFINE l_sfbud05       LIKE sfb_file.sfbud05     #add by guanyao160907
DEFINE l_sfbud05_1     LIKE sfb_file.sfbud05     #add by guanyao160928

      LET l_shm012 = ''
      LET l_shm05 = ''
      LET l_a_sgm03 = ''
      LET l_shm01 = ''
      LET l_sgm62 = ''
      LET l_sgm63 = ''
      LET l_cnt = 0
      LET l_over_qty = 0
      LET l_shm08 = 0
      SELECT sgm03 INTO l_a_sgm03 FROM sgm_file WHERE sgm01 = p_lot AND sgm04 = p_barcode #工艺序号
      SELECT DISTINCT shm012,shm05 INTO l_shm012,l_shm05 FROM shm_file WHERE shm01 = p_lot     #工单号 
      SELECT sfbud05 INTO l_sfbud05 FROM sfb_file WHERE sfb01 = l_shm012 #新旧工单 
      IF cl_null(l_sfbud05) THEN 
         LET l_sfbud05 = 'N'
      END IF 
      IF p_step = 1 THEN 
         LET l_sfbud05_1 = 'Y'   #add by guanyao160928 #扫入不管控发料默认成旧工单
         LET l_sgm03 = 0
         #SELECT MAX(shm01) INTO l_shm01 FROM shm_file WHERE shm01 <p_lot AND shm012 = l_shm012
         SELECT shm08 INTO l_shm08 FROM shm_file WHERE shm01 =p_lot
         IF cl_null(l_shm08) THEN   #求出是否是前一张LOT单是否已经扫出，如果扫出，减去扫出的数量
            LET l_shm08 = 0
         END IF
         #str------add by guanyao160801  #当时期初的时候
         LET l_ta_shm04 = ''
         SELECT ta_shm04 INTO l_ta_shm04 FROM shm_file WHERE shm01 = p_lot
         IF l_ta_shm04  = 'Y' THEN 
            IF l_sfbud05_1 = 'Y' THEN  #add by guanyao160907   旧工单不管
               RETURN l_shm08
            ELSE 
            IF g_sma.smaud02 = 'Y' THEN #add by guanyao160903 勾稽为Y之后执行报工扫入检查最小发料套数
               IF g_sma.sma73 = 'Y' THEN  #求出最小发料套数
                  CALL s_get_ima153(l_shm05) RETURNING l_ima153
                  CALL cs_minp2(l_shm012,g_sma.sma73,l_ima153,p_barcode,'','',g_today)
                     RETURNING l_cnt,l_over_qty
                  IF cl_null(l_over_qty) THEN LET l_over_qty = 0 END IF
                  LET l_yong = 0
                  SELECT SUM(tc_shc12) INTO l_yong FROM tc_shc_file WHERE tc_shc04 = l_shm012 AND tc_shc08 = p_barcode AND tc_shc01 = '2'
                  
                  IF cl_null(l_yong) THEN 
                     LET l_yong = 0
                  END IF 
                  #tianry add end   161208
                 # IF (l_yong-l_over_qty)/l_over_qty<0.001 THEN LET l_over_qty=l_over_qty END IF 
                  #tianry add end 
                  LET l_over_qty = l_over_qty -l_yong
               END IF
               IF l_shm08 < l_over_qty THEN 
                  RETURN l_shm08
               ELSE 
                  RETURN l_over_qty
               END IF 
            ELSE 
               RETURN l_shm08
            END IF   #add by guanyao160903
            END IF 
         END IF 
         #end------add by guanyao160801
         #str------mark by guanyao160728#不用管前一站
         #IF NOT cl_null(l_shm01) THEN 
         #   LET l_max_sgm03 = 0
         #   SELECT MAX(sgm03) INTO l_max_sgm03 FROM sgm_file WHERE sgm01 = l_shm01
         #   LET l_tc_shc12_a = 0
         #   SELECT SUM(tc_shc12) INTO l_tc_shc12_a 
         #     FROM tc_shc_file 
         #    WHERE tc_shc03 = l_shm01 
         #      AND tc_shc06= l_max_sgm03
         #      AND tc_shc01 = '2'
         #   IF cl_null(l_tc_shc12_a) THEN 
         #      LET l_tc_shc12_a = 0
         #   END IF  
         #ELSE
         #   LET l_tc_shc12_a = 0
         #END IF  
         #end------mark by guanyao160728
         LET l_sgm03 = ''
         SELECT MAX(sgm03) INTO l_sgm03 FROM sgm_file WHERE sgm01 = p_lot AND sgm03<l_a_sgm03
         IF cl_null(l_sgm03) THEN  #第一道工艺是的数量小于最小发料套数或者此张lot单标准产出量
            #str----add by guanyao160801
            LET l_sgm301 = ''
            SELECT sgm301 INTO l_sgm301 FROM sgm_file WHERE sgm01 = p_lot AND sgm03 = l_a_sgm03
            IF l_sgm301 = 0 OR cl_null(l_sgm301) THEN 
               RETURN 0
            END IF 
            #end----add by guanyao160801
            #str------add by guanyao160728 #已经扫入扫入的数量，只有第一站会考虑（扫入的数量不能大于最小发料套数-已经扫入的数量）
            SELECT SUM(tc_shc12) INTO l_tc_shc12_a 
              FROM tc_shc_file 
             WHERE tc_shc04 = l_shm012 
               AND tc_shc01 = '1' 
               AND tc_shc06 = l_a_sgm03
            IF cl_null(l_tc_shc12_a) THEN 
               LET l_tc_shc12_a = 0
            END IF 
            #end------add by guanyao160728
            LET l_sum1 = 0
            SELECT SUM(tc_shc12) INTO l_sum1 FROM tc_shc_file  #此LOT已经扫入的数量 
             WHERE tc_shc03 = p_lot 
               AND tc_shc06 = l_a_sgm03
               AND tc_shc01 = '1'
            IF cl_null(l_sum1) THEN 
               LET l_sum1 = 0
            END IF
            LET l_sum = 0
            SELECT SUM(tc_shc12) INTO l_sum FROM tc_shc_file   #此道LOT单工艺已经扫出数量
             WHERE tc_shc03 = p_lot 
               AND tc_shc06 = l_a_sgm03
               AND tc_shc01 = '2' 
            IF l_sum1>0 AND (cl_null(l_sum) OR l_sum = 0) THEN 
               RETURN 0
            END IF 
            #str-----mark by guanyao160728  冗余
            #IF cl_null(l_sum) OR l_sum=0 THEN 
            #   LET l_sum1 = 0
            #   SELECT SUM(tc_shc12) INTO l_sum1 FROM tc_shc_file   
            #    WHERE tc_shc03 = p_lot 
            #      AND tc_shc06 = l_a_sgm03
            #      AND tc_shc01 = '1'
            #   IF cl_null(l_sum1) THEN 
            #      LET l_sum1 = 0
            #   END IF 
            #ELSE 
            #   LET l_sum1 = 0
            #   SELECT SUM(tc_shc12) INTO l_sum1 FROM tc_shc_file   
            #    WHERE tc_shc03 = p_lot 
            #      AND tc_shc06 = l_a_sgm03
            #      AND tc_shc01 = '1'
            #   IF cl_null(l_sum1) THEN 
            #      LET l_sum1 = 0
            #   END IF
            #END IF 
            #str-----mark by guanyao160728
            IF l_sfbud05_1 = 'Y' THEN   #add by guanyao160907
            ELSE 
            IF g_sma.smaud02 = 'Y' THEN   #add by guanyao160903 勾稽为Y之后执行报工扫入检查最小发料套数
               IF g_sma.sma73 = 'Y' THEN  #求出最小发料套数
                  CALL s_get_ima153(l_shm05) RETURNING l_ima153
                  CALL cs_minp2(l_shm012,g_sma.sma73,l_ima153,p_barcode,'','',g_today)
                     RETURNING l_cnt,l_over_qty
                  IF cl_null(l_over_qty) THEN LET l_over_qty = 0 END IF
                  LET l_yong = 0
                  SELECT SUM(tc_shc12) INTO l_yong FROM tc_shc_file WHERE tc_shc04 = l_shm012 AND tc_shc08 = p_barcode  AND tc_shc01 = '2'
                  IF cl_null(l_yong) THEN 
                     LET l_yong = 0
                  END IF
                   #tianry add end   161208
                 # IF (l_yong-l_over_qty)/l_over_qty<0.001 THEN LET l_over_qty=l_over_qty END IF
                  #tianry add end 
                  LET l_over_qty = l_over_qty -l_yong
               END IF
            END IF 
            END IF 
            SELECT sgm62,sgm63 INTO l_sgm62,l_sgm63 FROM sgm_file WHERE sgm01 = p_lot AND sgm03 =l_a_sgm03
            IF cl_null(l_sgm63) OR cl_null(l_sgm62) THEN 
               LET l_shm08 = 0
               IF l_sfbud05_1 = 'Y' THEN   #add by guanyao160907
               ELSE 
               IF g_sma.smaud02 = 'Y' THEN  #add by guanyao160903 勾稽为Y之后执行报工扫入检查最小发料套数
                  LET l_over_qty= 0  
               END IF 
               END IF 
            ELSE 
               LET l_shm08 = (l_sgm62/l_sgm63)*l_shm08
               IF l_sfbud05_1 = 'Y' THEN   #add by guanyao160907
               ELSE 
               IF g_sma.smaud02 = 'Y' THEN  #add by guanyao160903 勾稽为Y之后执行报工扫入检查最小发料套数
                  #LET l_over_qty = (l_sgm62/l_sgm63)*l_over_qty-l_tc_shc12_a   
                  LET l_over_qty = (l_sgm62/l_sgm63)*l_over_qty
               END IF 
               END IF  
            END IF 
            IF cl_null(l_sum) THEN 
               LET l_sum = 0 
            END IF 
            IF cl_null(l_sum1) THEN 
               LET l_sum1 = 0 
            END IF
            #str------add by guanyao160728
            IF l_sfbud05_1 = 'Y' THEN   #add by guanyao160907
               RETURN l_shm08-l_sum1
            ELSE 
            IF g_sma.smaud02 = 'Y' THEN  #add by guanyao160903 勾稽为Y之后执行报工扫入检查最小发料套数
               IF l_shm08-l_sum1<l_over_qty THEN  
                  RETURN l_shm08-l_sum1
               ELSE                                 
                  RETURN l_over_qty
               END IF 
            ELSE 
               RETURN l_shm08-l_sum1
            END IF
            END IF 
            #end------add by guanyao160728 
            #str------mark by guanyao160728
            #IF l_shm08-l_sum < l_shm08-l_sum1 THEN    
            #   IF l_shm08-l_sum <l_over_qty-l_sum THEN 
            #      RETURN l_shm08-l_sum
            #   ELSE 
            #      RETURN l_over_qty-l_sum
            #   END IF  
            #ELSE 
            #   IF l_shm08-l_sum1 <l_over_qty-l_sum THEN 
            #      RETURN l_shm08-l_sum1
            #   ELSE 
            #      RETURN l_over_qty-l_sum
            #   END IF 
            #END IF 
            #end------mark by guanyao160728
         ELSE 
            #str----add by guanyao160904
            IF l_sfbud05_1 = 'Y' THEN   #add by guanyao160907
            ELSE 
            IF g_sma.smaud02 = 'Y' THEN   #add by guanyao160903 勾稽为Y之后执行报工扫入检查最小发料套数（工单+工艺序号）
               IF g_sma.sma73 = 'Y' THEN  #求出最小发料套数
                  CALL s_get_ima153(l_shm05) RETURNING l_ima153
                  CALL cs_minp2(l_shm012,g_sma.sma73,l_ima153,p_barcode,'','',g_today)
                     RETURNING l_cnt,l_over_qty
                  IF cl_null(l_over_qty) THEN LET l_over_qty = 0 END IF
                  LET l_yong = 0
                  SELECT SUM(tc_shc12) INTO l_yong FROM tc_shc_file WHERE tc_shc04 = l_shm012 AND tc_shc08 = p_barcode  AND tc_shc01 = '2'
                  IF cl_null(l_yong) THEN 
                     LET l_yong = 0
                  END IF
                   #tianry add end   161208
                #  IF (l_yong-l_over_qty)/l_over_qty<0.001 THEN LET l_over_qty=l_over_qty END IF
                  #tianry add end 
                  LET l_over_qty = l_over_qty -l_yong
               END IF
            END IF
            END IF 
            #end----add by guanyao160904
            #str-----add by guanyao160731    #扫入过后不能再次扫入
            #str-----add by guanyao160808
               LET l_ta_ecd04 = ''
               SELECT ta_ecd04 INTO l_ta_ecd04 FROM ecd_file,tc_shb_file 
                WHERE tc_shb08 = ecd01 
                  AND tc_shb03 = p_lot
                  AND tc_shb06 = l_sgm03
               IF cl_null(l_ta_ecd04) THEN 
                  LET l_ta_ecd04 = 'N'
               END IF 
            IF l_ta_ecd04 ='Y' THEN 
               #SELECT SUM(tc_shb12+tc_shb121+tc_shb121) INTO l_tc_shc12_b FROM tc_shb_file  #mark by guanyao161007
               SELECT SUM(tc_shb12) INTO l_tc_shc12_b FROM tc_shb_file #add by guanyao161007
                WHERE tc_shb01 = '2' 
                  AND tc_shb03 = p_lot
                  AND tc_shb06 = l_sgm03
            ELSE
               SELECT SUM(tc_shc12) INTO l_tc_shc12_b FROM tc_shc_file 
                WHERE tc_shc01 = '2' 
                  AND tc_shc03 = p_lot
                  AND tc_shc06 = l_sgm03
            END IF 
            #end-----add by guanyao160808
            SELECT SUM(tc_shc12) INTO l_tc_shc12_a FROM tc_shc_file
             WHERE tc_shc01 = '1' 
               AND tc_shc03 = p_lot
               AND tc_shc06 = l_a_sgm03
            IF cl_null(l_tc_shc12_a) THEN 
               LET l_tc_shc12_a = 0
            END IF 
            #end-----add by guanyao160731
            IF cl_null(l_tc_shc12_b)  THEN 
               LET l_tc_shc12_b = 0
            ELSE
               LET l_sgm62 = ''
               LET l_sgm63 = ''
               SELECT sgm62,sgm63 INTO l_sgm62,l_sgm63 FROM sgm_file WHERE sgm01 = p_lot AND sgm03 =l_sgm03
               LET l_tc_shc12_b = l_sgm62/l_sgm63*l_tc_shc12_b
            END IF  
            #str-----add by guanyao160731
            LET l_tc_shc12_b= l_tc_shc12_b - l_tc_shc12_a 
            IF l_tc_shc12_b< = 0 THEN 
               LET l_tc_shc12_b = 0
            END IF 
            #end-----add by guanyao160731
            #str-----add by guanyao160904
            IF l_sfbud05_1 = 'Y' THEN   #add by guanyao160907
               RETURN l_tc_shc12_b
            ELSE 
            IF g_sma.smaud02 ='Y' THEN 
               IF l_over_qty >l_tc_shc12_b THEN 
                  RETURN l_tc_shc12_b
               ELSE 
                  RETURN l_over_qty
               END IF 
            ELSE 
               RETURN l_tc_shc12_b
            END IF 
            END IF 
            #RETURN l_tc_shc12_b
            #end-----add by guanyao160904
         END IF
      END IF 
      
      IF p_step = 2 THEN 
         ################算出已开工数量以及判断此人是否还有未完工数量----str
         SELECT SUM(tc_shb12) INTO l_tc_shb12 FROM tc_shb_file  #已开工的数量
          WHERE tc_shb01 = '1'
            AND tc_shb03 = p_lot
            AND tc_shb06 = l_a_sgm03
         IF cl_null(l_tc_shb12) THEN 
            LET l_tc_shb12 = 0
         END IF 
         IF l_tc_shb12 >0 THEN   
            SELECT SUM(tc_shb12) INTO l_tc_shc12_1 FROM tc_shb_file  #已开工的数量大于的时候需要判断此人开工量和完工量是否相同
             WHERE tc_shb01 = '1'
               AND tc_shb03 = p_lot
               AND tc_shb06 = l_a_sgm03
          #     AND tc_shb11 = p_user  同一工序可不同人报工  ly 180528
            IF cl_null(l_tc_shc12_1) THEN 
               LET l_tc_shc12_1 = 0
            END IF                
            #IF l_tc_shb12_a >0 THEN  #mark by guanyao160921
            IF l_tc_shc12_1>0 THEN    #add by guanyao160921
            #   SELECT SUM(tc_shb12+tc_shb121+tc_shb122) INTO l_tc_shc12_2 FROM tc_shb_file 
         SELECT SUM(tc_shb12+nvl(tc_shb121,0)+nvl(tc_shb122,0)) INTO l_tc_shc12_2 FROM tc_shb_file
     
           WHERE tc_shb01 = '2'
                  AND tc_shb03 = p_lot
                  AND tc_shb06 = l_a_sgm03
               #   AND tc_shb11 = p_user    同一工序可不同人报工  ly 180528
               IF cl_null(l_tc_shc12_2) THEN 
                  LET l_tc_shc12_2 = 0
               END IF 
               IF l_tc_shc12_2 < l_tc_shc12_1 THEN 
                  LET g_status.code = '-1'
                  LET g_status.description = '有未完工的资料，请先完工此笔资料'
                  RETURN 0 
               END IF 
            END IF 
         END IF
         SELECT SUM(tc_shb122) INTO l_tc_shb12_f FROM tc_shb_file  #此笔工艺返工量
          WHERE tc_shb03= p_lot 
            AND tc_shb06= l_a_sgm03
            AND tc_shb01 = '2'
         IF cl_null(l_tc_shb12_f) THEN  
            LET l_tc_shb12_f = 0
         END IF 
         ################算出已开工数量以及判断此人是否还有未完工数量----end
         LET l_sgm03 = ''
         LET l_ta_ecd04 = ''
         SELECT MAX(sgm03) INTO l_sgm03 FROM sgm_file WHERE sgm01 = p_lot AND sgm03<l_a_sgm03 #求出是否是第一道工艺 
         IF cl_null(l_sgm03) THEN  #第一道工艺
            IF p_ta_ecd04 = 'Y' THEN   #总数量扫入
               SELECT shm08 INTO l_shm08 FROM shm_file WHERE shm01 =p_lot  #此张LOT剩余数量
               IF cl_null(l_shm08) THEN   
                  LET g_status.code = '-1'
                  LET g_status.description = 'LOT单上没有数量'
                  RETURN 0
               END IF
               #str----add by guanyao160904
               IF l_sfbud05 = 'Y' THEN   #add by guanyao160907
               ELSE 
               IF g_sma.smaud02 = 'Y' THEN   #add by guanyao160903 勾稽为Y之后执行报工扫入检查最小发料套数
                  IF g_sma.sma73 = 'Y' THEN  
                     CALL s_get_ima153(l_shm05) RETURNING l_ima153
                     CALL cs_minp2(l_shm012,g_sma.sma73,l_ima153,p_barcode,'','',g_today)
                       RETURNING l_cnt,l_over_qty
                     IF cl_null(l_over_qty) THEN LET l_over_qty = 0 END IF
                     LET l_yong = 0
                     SELECT SUM(tc_shb12) INTO l_yong FROM tc_shb_file WHERE tc_shb04 = l_shm012 AND tc_shb08 = p_barcode  AND tc_shb01 = '2'
                     IF cl_null(l_yong) THEN 
                        LET l_yong = 0
                     END IF
                      #tianry add end   161208
               #   IF (l_yong-l_over_qty)/l_over_qty<0.001 THEN LET l_over_qty=l_over_qty END IF
                  #tianry add end 
                     LET l_over_qty = l_over_qty -l_yong
                  END IF
                  IF l_over_qty = 0 THEN 
                     LET g_status.code = '-1'
                     LET g_status.description = '开工工序主料未齐套发料'
                     RETURN 0
                  END IF 
               END IF 
               END IF 
               #end----add by guanyao160904
               LET l_ta_shm04 = ''
               SELECT ta_shm04 INTO l_ta_shm04 FROM shm_file WHERE shm01 = p_lot
               IF cl_null(l_ta_shm04) THEN 
                  LET l_ta_shm04 = 'N'
               END IF 
               IF l_ta_shm04  = 'Y' THEN #期初
                  IF l_sfbud05 = 'Y' THEN   #add by guanyao160907
                     RETURN l_shm08
                  ELSE 
                  IF g_sma.smaud02 = 'Y' THEN 
                     IF l_shm08<l_over_qty THEN 
                        RETURN l_shm08
                     ELSE 
                        RETURN l_over_qty
                     END IF 
                  ELSE 
                     RETURN l_shm08
                  END IF 
                  END IF 
                  #RETURN l_ta_shm04
               ELSE 
                  RETURN l_shm08+l_tc_shb12_f-l_tc_shb12
               END IF 
            ELSE 
               SELECT SUM(tc_shc12) INTO l_tc_shc12 FROM tc_shc_file
                WHERE tc_shc03= p_lot
                  AND tc_shc06= l_a_sgm03
                  AND tc_shc01 = '1'
               IF cl_null(l_tc_shc12) THEN 
                  LET l_tc_shc12 = 0
               END IF  
               #str-----add by guanyao160928
               IF l_sfbud05 = 'Y' THEN  
               ELSE 
                  IF g_sma.smaud02 = 'Y' THEN   # 勾稽为Y之后执行报工扫入检查最小发料套数
                     IF g_sma.sma73 = 'Y' THEN  
                        CALL s_get_ima153(l_shm05) RETURNING l_ima153
                        CALL cs_minp2(l_shm012,g_sma.sma73,l_ima153,p_barcode,'','',g_today)
                          RETURNING l_cnt,l_over_qty
                        IF cl_null(l_over_qty) THEN LET l_over_qty = 0 END IF
                        LET l_yong = 0
                        SELECT SUM(tc_shb12) INTO l_yong FROM tc_shb_file WHERE tc_shb04 = l_shm012 AND tc_shb08 = p_barcode  AND tc_shb01 = '2'
                        IF cl_null(l_yong) THEN 
                           LET l_yong = 0
                        END IF
                         #tianry add end   161208
               #   IF (l_yong-l_over_qty)/l_over_qty<0.001 THEN LET l_over_qty=l_over_qty END IF
                  #tianry add end 
                        LET l_over_qty = l_over_qty -l_yong
                     END IF
                     IF l_over_qty = 0 THEN 
                        LET g_status.code = '-1'
                        LET g_status.description = '开工工序主料未齐套发料'
                        RETURN 0
                     END IF 
                  END IF 
               END IF 
               #end-----add by guanyao160928
               IF l_tc_shc12 <=0 THEN 
                  LET g_status.code = '-1'
                  LET g_status.description = '没有扫入数量'
                  RETURN 0
               END IF
               #str-----add by guanyao160928####扫入不考虑本道工艺是否发料
               IF l_sfbud05 = 'Y' THEN   
                  RETURN l_tc_shc12+l_tc_shb12_f-l_tc_shb12
               ELSE 
                  IF g_sma.smaud02 = 'Y' THEN 
                     IF l_tc_shc12+l_tc_shb12_f-l_tc_shb12<l_over_qty THEN 
                        RETURN l_tc_shc12+l_tc_shb12_f-l_tc_shb12
                     ELSE 
                        RETURN l_over_qty
                     END IF 
                  ELSE 
                     RETURN l_tc_shc12+l_tc_shb12_f-l_tc_shb12
                  END IF 
               END IF 
               #end-----add by guanyao160928
                  #RETURN l_tc_shc12+l_tc_shb12_f-l_tc_shb12                  
            END IF 
         ELSE#非第一道工艺
            LET l_ta_ecd04 = ''
            SELECT ta_ecd04 INTO l_ta_ecd04 FROM ecd_file,tc_shb_file
             WHERE ecd01 = tc_shb08 
               AND tc_shb03 = p_lot
               AND tc_shb06 = l_sgm03
            IF cl_null(l_ta_ecd04) THEN 
               LET l_ta_ecd04 = 'N'
            END IF 
            IF p_ta_ecd04 ='Y' THEN 
               #str----add by guanyao160904
               IF l_sfbud05 = 'Y' THEN   #add by guanyao160907
               ELSE
               IF g_sma.smaud02 = 'Y' THEN   #add by guanyao160903 勾稽为Y之后执行报工扫入检查最小发料套数
                  IF g_sma.sma73 = 'Y' THEN  
                     CALL s_get_ima153(l_shm05) RETURNING l_ima153
                     CALL cs_minp2(l_shm012,g_sma.sma73,l_ima153,p_barcode,'','',g_today)
                        RETURNING l_cnt,l_over_qty
                     IF cl_null(l_over_qty) THEN LET l_over_qty = 0 END IF
                     LET l_yong = 0
                     SELECT SUM(tc_shb12) INTO l_yong FROM tc_shb_file WHERE tc_shb04 = l_shm012 AND tc_shb08 = p_barcode  AND tc_shb01 = '2'
                     IF cl_null(l_yong) THEN 
                        LET l_yong = 0
                     END IF
                      #tianry add end   161208
                #  IF (l_yong-l_over_qty)/l_over_qty<0.001 THEN LET l_over_qty=l_over_qty END IF
                  #tianry add end 
                     LET l_over_qty = l_over_qty -l_yong
                  END IF
                  IF l_over_qty = 0 THEN 
                     LET g_status.code = '-1'
                     LET g_status.description = '开工工序主料未齐套发料'
                     RETURN 0
                  END IF 
               END IF 
               END IF 
               #end----add by guanyao160904
               LET l_shm08 = ''
               SELECT shm08 INTO l_shm08 FROM shm_file WHERE shm01 =p_lot  #此张LOT剩余数量
               IF cl_null(l_shm08) THEN   
                  LET g_status.code = '-1'
                  LET g_status.description = 'LOT单上没有数量'
                  RETURN 0
               END IF
               LET l_ta_shm04 = ''
               SELECT ta_shm04 INTO l_ta_shm04 FROM shm_file WHERE shm01 = p_lot
               IF cl_null(l_ta_shm04) THEN LET l_ta_shm04 = 'N' END IF 
               IF l_ta_shm04  = 'Y' THEN     #期初
                  #str----add by guanyao160904
                  IF l_sfbud05 = 'Y' THEN   #add by guanyao160907
                     RETURN l_shm08
                  ELSE
                  IF g_sma.smaud02 = 'Y' THEN 
                     IF  l_over_qty>l_shm08 THEN 
                        RETURN l_shm08
                     ELSE
                        RETURN l_over_qty
                     END IF 
                  ELSE 
                     RETURN l_shm08
                  END IF 
                  END IF 
                  #RETURN l_shm08
                  #end----add by guanyao160904
               ELSE    #非期初，前一道工艺是包装
                  IF l_ta_ecd04 = 'Y' THEN
                     
                    
                     # SELECT SUM(tc_shb12+tc_shb121+tc_shb122) INTO l_tc_shc12 FROM tc_shb_file
                     # SELECT SUM(tc_shb12+nvl(tc_shb121,0)+nvl(tc_shb122,0)) INTO l_tc_shc12 FROM tc_shb_file
                     SELECT SUM(tc_shb12) INTO l_tc_shc12 FROM tc_shb_file
                      WHERE tc_shb01 = '2'  #mod ly 180104 1 --2
                        AND tc_shb03 = p_lot
                        AND tc_shb06 = l_sgm03
                     IF cl_null(l_tc_shc12) OR l_tc_shc12 = 0 THEN 
                        LET g_status.code = '-1'
                        LET g_status.description = '前一道工艺没有完工量'
                        RETURN 0 
                     END IF 
                     #str----add by guanyao160904
                     IF l_sfbud05 = 'Y' THEN   #add by guanyao160907
                        RETURN l_tc_shb12_f+ l_tc_shc12-l_tc_shb12
                     ELSE
                     IF g_sma.smaud02 = 'Y' THEN 
                        IF  l_over_qty>(l_tc_shb12_f+ l_tc_shc12-l_tc_shb12) THEN 
                           RETURN l_tc_shb12_f+ l_tc_shc12-l_tc_shb12
                        ELSE
                           RETURN l_over_qty
                        END IF 
                     ELSE 
                        RETURN l_tc_shb12_f+ l_tc_shc12-l_tc_shb12
                     END IF 
                     END IF 
                     #end----add by guanyao160904
                     #RETURN l_tc_shb12_f+ l_tc_shc12-l_tc_shb12
                  ELSE #非期初，前一道工艺是非包装
                     SELECT SUM(tc_shc12) INTO l_tc_shc12 FROM tc_shc_file
                      WHERE tc_shc01 = '2'
                        AND tc_shc03 = p_lot
                        AND tc_shc06 = l_sgm03
                     IF cl_null(l_tc_shc12) OR l_tc_shc12 =0 THEN 
                        LET g_status.code = '-1'
                        LET g_status.description = '前一道工艺没有扫出'
                        RETURN 0
                     END IF
                     #str----add by guanyao160904
                     IF l_sfbud05 = 'Y' THEN   #add by guanyao160907
                        RETURN l_tc_shb12_f+ l_tc_shc12-l_tc_shb12
                     ELSE
                     IF g_sma.smaud02 = 'Y' THEN 
                        IF  l_over_qty>(l_tc_shb12_f+ l_tc_shc12-l_tc_shb12) THEN 
                           RETURN l_tc_shb12_f+ l_tc_shc12-l_tc_shb12 
                        ELSE
                           RETURN l_over_qty
                        END IF 
                     ELSE 
                        RETURN l_tc_shb12_f+ l_tc_shc12-l_tc_shb12
                     END IF
                     END IF 
                     #RETURN l_tc_shb12_f+ l_tc_shc12-l_tc_shb12 
                     #end----add by guanyao160904
                  END IF 
               END IF 
            ELSE #本道工艺不是包装
               SELECT SUM(tc_shc12) INTO l_tc_shc12 FROM tc_shc_file
                WHERE tc_shc01 = '1'
                  AND tc_shc03 = p_lot
                  AND tc_shc06 = l_a_sgm03
               IF cl_null(l_tc_shc12) OR l_tc_shc12 = 0 THEN 
                  LET g_status.code = '-1'
                  LET g_status.description = '没有扫入'
                  RETURN 0
               ELSE 
                  #str----add by guanyao160928  #扫入不考虑发料，开工考虑
                  IF l_sfbud05 = 'Y' THEN
                     RETURN l_tc_shc12-l_tc_shb12+l_tc_shb12_f 
                  ELSE
                     IF g_sma.smaud02 = 'Y' THEN   #勾稽为Y之后执行报工扫入检查最小发料套数
                        IF g_sma.sma73 = 'Y' THEN  
                           CALL s_get_ima153(l_shm05) RETURNING l_ima153
                           CALL cs_minp2(l_shm012,g_sma.sma73,l_ima153,p_barcode,'','',g_today)
                              RETURNING l_cnt,l_over_qty
                           IF cl_null(l_over_qty) THEN LET l_over_qty = 0 END IF
                           LET l_yong = 0
                           SELECT SUM(tc_shb12) INTO l_yong FROM tc_shb_file WHERE tc_shb04 = l_shm012 AND tc_shb08 = p_barcode  AND tc_shb01 = '2'
                           IF cl_null(l_yong) THEN 
                              LET l_yong = 0
                           END IF 
                            #tianry add end   161208
                  IF (l_tc_shc12-(l_over_qty-l_yong))/l_tc_shc12<0.01 THEN LET l_over_qty=l_tc_shc12+l_yong END IF
                  #tianry add end 
              #             LET l_over_qty = l_over_qty -l_yong
                        END IF
                        IF l_over_qty = 0 THEN 
                           LET g_status.code = '-1'
                           LET g_status.description = '开工工序主料未齐套发料'
                           RETURN 0
                        END IF 
                        IF l_tc_shc12-l_tc_shb12+l_tc_shb12_f >= l_over_qty THEN 
                           RETURN l_over_qty
                        ELSE 
                           RETURN l_tc_shc12-l_tc_shb12+l_tc_shb12_f
                        END IF 
                     ELSE
                        RETURN l_tc_shc12-l_tc_shb12+l_tc_shb12_f
                     END IF 
                  END IF 
                  #end----add by guanyao160928
                  #RETURN l_tc_shc12-l_tc_shb12+l_tc_shb12_f
               END IF 
             END IF 
          END IF 
      END IF  

      IF p_step = 3 THEN   
         LET l_tc_shb12_a = 0
         SELECT SUM(tc_shb12) INTO l_tc_shb12_a #当前人的开工
           FROM tc_shb_file 
          WHERE tc_shb03 = p_lot 
            AND tc_shb06 = l_a_sgm03
            AND tc_shb01 = '1'
         #   AND tc_shb11= p_user  
         IF  cl_null(l_tc_shb12_a) THEN 
            LET l_tc_shb12_a = 0
         END IF 
        #  SELECT SUM(tc_shb12+tc_shb121+tc_shb122) INTO l_tc_shb12_b FROM tc_shb_file #当前人的完工
 
         SELECT SUM(tc_shb12+nvl(tc_shb121,0)+nvl(tc_shb122,0)) INTO l_tc_shb12_b FROM tc_shb_file #当前人的完工
          WHERE tc_shb03= p_lot
            AND tc_shb06= l_a_sgm03
          #  AND tc_shb11= p_user  同一工序可不同人报工  ly 180528
            AND tc_shb01 = '2'
         IF cl_null(l_tc_shb12_b) THEN 
             LET l_tc_shb12_b = 0
         END IF
         LET l_tc_shb12_a = l_tc_shb12_a - l_tc_shb12_b
         RETURN l_tc_shb12_a
      END IF 

      IF p_step = 4 THEN 
         
         LET l_tc_shc12_1 = 0
         LET l_tc_shc12_2 = 0
         
         SELECT sum(tc_shb12) INTO l_tc_shc12_1 FROM tc_shb_file 
           WHERE tc_shb03= p_lot
             AND tc_shb06= l_a_sgm03
             #AND tc_shb11= p_user   #mark by guanyao160818
             AND tc_shb01 = '2'
          SELECT sum(tc_shc12) INTO l_tc_shc12_2 FROM tc_shc_file 
           WHERE tc_shc03= p_lot
             AND tc_shc06= l_a_sgm03
             #AND tc_shc11= p_user   #mark by guanyao160806
             AND tc_shc01 = '2'
          #str----add by guanyao160806
          #SELECT SUM(tc_shc12) INTO l_tc_shb12_a FROM tc_shc_file 
          # WHERE tc_shc03= p_lot
          #   AND tc_shc06= l_a_sgm03
          #   AND tc_shc01 = '1'
          #IF cl_null(l_tc_shb12_a) THEN 
          #   LET l_tc_shb12_a = 0
          #END IF 
          #end----add by guanyao160806
          IF cl_null(l_tc_shc12_1) THEN 
             LET l_tc_shc12_1 =0
          END IF 
          IF cl_null(l_tc_shc12_2) THEN 
             LET l_tc_shc12_2 =0
          END IF
          #str----add by guanyao160806
          #IF p_ta_ecd04 = 'Y' THEN 
          #   LET l_tc_shc12 =  l_tc_shb12_a -l_tc_shc12_2
          #ELSE 
          #end----add by guanyao160806
             LET l_tc_shc12 =l_tc_shc12_1 - l_tc_shc12_2
          #END IF 
          RETURN l_tc_shc12
      END IF 
      
END FUNCTION 
#end----add by guanyao160718
#str-----add by guanyao160720
FUNCTION cws_get_start_s(p_shm01,p_shm012)
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
     RETURN '0'

     
END FUNCTION 
#end-----add by guanyao160720
