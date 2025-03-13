# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Program name...: aws_write_point.4gl
# Descriptions...: 提供POS寫入積分的服務
# Date & Author..: 12/06/04 by suncx
# Modify.........: No.FUN-C50138 12/06/04 by suncx 新增程序
# Modify.........: No.TQC-C80097 12/08/15 by suncx 程序調整
# Modify.........: No.FUN-D10053 13/01/11 By baogc 逻辑调整
# Modify.........: No.FUN-D10095 13/01/25 By xumm XML格式调整

DATABASE ds 

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

DEFINE g_rxu    RECORD LIKE rxu_file.*
DEFINE g_return RECORD             #回傳值必須宣告為一個 RECORD 變數
                success   STRING,  #积分成功否Y/N
                POINT_QTY LIKE lpj_file.lpj12  #积分总额
                END RECORD
#[
# Description....: 提供POS寫入積分的服務(入口 function)
# Date & Author..: 2012/06/04 by suncx
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_write_point()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序

    #--------------------------------------------------------------------------#
    # POS寫入積分信息                                                           #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_write_point_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION

#[
# Description....: 依據傳入資訊POS寫入積分
# Date & Author..: 2012/06/04 by suncx
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_write_point_process()
    DEFINE l_sql   STRING 
    DEFINE l_guid  LIKE rxu_file.rxu01 
    DEFINE l_legal LIKE azw_file.azw02
    DEFINE l_lsm04       LIKE lsm_file.lsm04,  #本次異動積分
           l_lsm02       LIKE lsm_file.lsm02,  #單據类型
           l_lsm15       LIKE lsm_file.lsm15   #單據类型
    DEFINE l_lpj RECORD
                 lpj05   LIKE lpj_file.lpj05,
                 lpj09   LIKE lpj_file.lpj09,
                 lpj12   LIKE lpj_file.lpj12,
                 lpkacti LIKE lpk_file.lpkacti,
                 lph06   LIKE lph_file.lph06,
                 lnk05   LIKE lnk_file.lnk05
                 END RECORD
    DEFINE l_cardno  LIKE lsm_file.lsm01,  #卡号
           l_type    LIKE lsm_file.lsm02,  #销售状态 0、销售单 1、原价退货 2、议价退货3、订单 4、退订单
           l_point   LIKE lsm_file.lsm04,  #本次积分
           l_totamt  LIKE lsm_file.lsm08,  #本单金额
           l_saleno  LIKE lsm_file.lsm03,  #单号信息
           l_dbate   STRING,  #营业日期
           l_shop    LIKE lsm_file.lsm07,  #门店编号
           l_date    LIKE type_file.dat,
           l_num     LIKE type_file.num10
    DEFINE l_node    om.DomNode            #FUN-D10095 Add

    #取得各項參數
   #FUN-D10095 Mark&Add Begin ---
   #LET l_cardno = aws_ttsrv_getParameter("CardNO") 
   #LET l_type   = aws_ttsrv_getParameter("Type")
   #LET l_point  = aws_ttsrv_getParameter("POINT_QTY")
   #LET l_totamt = aws_ttsrv_getParameter("TOT_AMT")
   #LET l_saleno = aws_ttsrv_getParameter("SaleNO")
   #LET l_dbate  = aws_ttsrv_getParameter("BDate")
   #LET l_shop   = aws_ttsrv_getParameter("Shop")
    LET l_node   = aws_ttsrv_getTreeMasterRecord(1,"WritePoint")
    LET l_cardno = aws_ttsrv_getRecordField(l_node,"CardNO")
    LET l_type   = aws_ttsrv_getRecordField(l_node,"Type")
    LET l_point  = aws_ttsrv_getRecordField(l_node,"POINT_QTY")
    LET l_totamt = aws_ttsrv_getRecordField(l_node,"TOT_AMT")
    LET l_saleno = aws_ttsrv_getRecordField(l_node,"SaleNO")
    LET l_dbate  = aws_ttsrv_getRecordField(l_node,"BDate")
    LET l_shop   = aws_ttsrv_getRecordField(l_node,"Shop")
   #FUN-D10095 Mark&Add End -----
    #LET g_return.GUID = aws_pos_get_ConnectionMsg("guid")
    LET l_guid = aws_pos_get_ConnectionMsg("guid")
       
    #調用基本的檢查
    CALL aws_pos_check() RETURNING g_return.success

    IF cl_null(l_guid) THEN 
       LET g_return.success = 'N'
    END IF 
    
    IF g_return.success = 'Y' THEN  
       #按條件查詢會員卡信息
       LET l_sql = " SELECT lpj05,lpj09,lpj12,lpkacti,lph06,lnk05 ",
                   "   FROM ",cl_get_target_table(l_shop,"lpj_file"),
                   "   LEFT JOIN ",cl_get_target_table(l_shop,"lpk_file")," ON lpk01=lpj01 ",
                   "   LEFT JOIN ",cl_get_target_table(l_shop,"lph_file")," ON lph01=lpj02 ",
                   "   LEFT JOIN ",cl_get_target_table(l_shop,"lnk_file")," ON lnk01=lpj02 ",
                   "         AND lnk02 = '1' AND lnk03 ='",l_shop,"'",
                   "  WHERE lpj03 = '",l_cardno,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       TRY
          PREPARE sel_lpj_pre FROM l_sql
          EXECUTE sel_lpj_pre INTO l_lpj.*
       CATCH 
          IF sqlca.sqlcode THEN
             LET g_status.sqlcode = sqlca.sqlcode
          END IF 
          LET g_return.success = "N"
          CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤  
       END TRY 
       IF sqlca.sqlcode AND g_return.success = "Y" THEN 
          LET g_return.success = 'N'
          IF sqlca.sqlcode = 100 THEN 
             CALL aws_pos_get_code('aws-905',l_cardno,NULL,NULL) #卡不存在         
          ELSE 
             LET g_status.sqlcode = sqlca.sqlcode
             CALL aws_pos_get_code('aws-901',NULL,NULL,NULL) #ERP系統錯誤
          END IF 
       END IF
       #判断会员卡在本门店能否使用
       IF (cl_null(l_lpj.lnk05) OR l_lpj.lnk05='N') AND g_return.success = "Y" THEN 
          CALL aws_pos_get_code('aws-906',l_cardno,NULL,NULL)         #会员卡在本门店不能使用  
          LET g_return.success = 'N'            
       END IF
       
       #判断会员卡是否失效
       IF g_return.success = "Y" AND ((NOT cl_null(l_lpj.lpj05) AND l_lpj.lpj05 <= g_today) OR cl_null(l_lpj.lpkacti) OR   
          l_lpj.lpkacti = 'N') THEN 
          CALL aws_pos_get_code('aws-907',l_cardno,NULL,NULL)         #会员卡失效
          LET g_return.success = 'N'            
       END IF 
       #检查会员卡状态
       IF g_return.success = "Y" AND l_lpj.lpj09 <> '2' THEN 
          CALL aws_pos_get_code('aws-908',l_cardno,l_lpj.lpj09,'2')  #会员卡状态不符合
          LET g_return.success = 'N'            
       END IF 
       #检查会员卡是否可积分
       IF g_return.success = "Y" AND (cl_null(l_lpj.lph06) OR l_lpj.lph06 = 'N') THEN 
          CALL aws_pos_get_code('aws-910',l_cardno,NULL,NULL)         #会员卡不可积分
          LET g_return.success = 'N'            
       END IF 
       #檢查積分是否足夠扣減
       IF g_return.success = "Y" AND l_type MATCHES '[12]' THEN 
          IF cl_null(l_lpj.lpj12) OR l_lpj.lpj12 - l_point < 0 THEN
             CALL aws_pos_get_code('aws-909',l_cardno,NULL,NULL)    #积分扣减失败，该卡积分不够扣减
             LET g_return.success = 'N'  
          END IF  
       END IF 
       IF g_return.success = 'Y' THEN 
          IF aws_pos_guid_isExistence(l_guid) THEN 
             LET g_return.success = 'Y'
             SELECT rxu09 INTO g_return.POINT_QTY FROM rxu_file
              WHERE rxu01 = l_guid
             IF sqlca.sqlcode THEN
                LET g_status.sqlcode = sqlca.sqlcode 
                CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤  
                LET g_return.success = "N" 
             END IF 
          ELSE 
             BEGIN WORK
             LET l_lsm15 = '2'
             TRY 
                #更新前鎖資料
                LET l_sql = "SELECT * FROM ",cl_get_target_table(l_shop,"lpj_file"),
                            " WHERE lpj03 = ? FOR UPDATE"
                LET l_sql = cl_forupd_sql(l_sql)
                DECLARE lpj_cl CURSOR FROM l_sql
                OPEN lpj_cl USING l_cardno
                IF STATUS THEN
                   LET g_status.sqlcode = STATUS
                   CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤  
                   LET g_return.success = "N"
                END IF
                IF g_return.success = 'Y' THEN 
                   #更新積分
                   CASE  
                      WHEN l_type MATCHES '[03]'   #積分增加
                         LET l_lsm04 = l_point
                         LET l_totamt = l_totamt
                         IF l_type = '0' THEN LET l_lsm02 = '7' END IF   #銷售單積分
                         IF l_type = '3' THEN LET l_lsm02 = 'X' END IF   #訂單積分 目前先給X
                      WHEN l_type MATCHES '[124]'  #積分減少
                         LET l_lsm04 = -1*l_point
                         LET l_totamt = -1*l_totamt
                         IF l_type MATCHES '[12]' THEN LET l_lsm02 = '8' END IF   #銷退單積分
                         IF l_type = '4' THEN LET l_lsm02 = 'Y' END IF   #退訂單積分 目前先給X
                      OTHERWISE 
                         RETURN 
                   END CASE 
                   LET l_sql = " UPDATE ",cl_get_target_table(l_shop,"lpj_file"),
                               "    SET lpj07 = lpj07 + 1,",
                               "        lpj08 = '",g_today,"',",
                               "        lpj12 = lpj12 + (",l_lsm04,"),",
                               "        lpj14 = lpj14 + (",l_lsm04,"),",   #TQC-C80097 
                               "        lpj15 = lpj15 + (",l_totamt,")",
                               "  WHERE lpj03 = '",l_cardno,"'"
                   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                   PREPARE upd_point_pre FROM l_sql
                   EXECUTE upd_point_pre
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN  
                      LET g_return.success = 'N'
                      LET g_status.sqlcode = sqlca.sqlcode
                      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
                   END IF 
 
                   #寫積分異動檔
                   LET l_date = NULL
                   LET l_num =0 
                   SELECT azw02 INTO l_legal FROM azw_file WHERE azw01 = l_shop
                   LET l_sql = "INSERT INTO ",cl_get_target_table(l_shop,"lsm_file"), 
                               "        (lsm01,lsm02,lsm03,lsm04,lsm05, lsm06,lsm07,lsm08,lsmlegal,lsmplant,", #FUN-D10053 Add
                               "         lsm09,lsm10,lsm11,lsm12,lsm13, lsm14,lsm15,lsmstore)",                #FUN-D10053 Add
                               "  VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?) "                             #FUN-D10053 Add ,?
                   PREPARE insert_lsm_prep FROM  l_sql
                   EXECUTE insert_lsm_prep USING l_cardno,l_lsm02,l_saleno,l_lsm04,g_today,l_date,l_shop,l_totamt,
                                                 l_legal,l_shop,l_num,l_num,l_num,l_num,l_num,l_date,l_lsm15,l_shop #FUN-D10053 Add ,l_shop
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN 
                      LET g_return.success = 'N' 
                      LET g_status.sqlcode = sqlca.sqlcode
                      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
                   END IF 
                   #重新獲取積分
                   LET l_sql = "SELECT lpj12 FROM ",cl_get_target_table(l_shop,"lpj_file"),
                               " WHERE lpj03 = '",l_cardno,"'"
                   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                   PREPARE sel_lpj12_pre FROM l_sql
                   EXECUTE sel_lpj12_pre INTO g_return.POINT_QTY
                   IF SQLCA.sqlcode THEN 
                      LET g_return.success = 'N' 
                      LET g_status.sqlcode = sqlca.sqlcode
                      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
                   END IF 
                 
                   #寫rxu_file
                   IF g_return.success = 'Y' THEN 
                      LET g_rxu.rxu01 = l_guid
                      LET g_rxu.rxu02 = ' '
                      LET g_rxu.rxu03 = l_shop
                      LET g_rxu.rxu04 = l_saleno
                      LET g_rxu.rxu05 = g_service
                      LET g_rxu.rxu06 = '2'
                      LET g_rxu.rxu07 = l_cardno
                      LET g_rxu.rxu08 = l_lpj.lpj12
                      LET g_rxu.rxu09 = g_return.POINT_QTY
                      LET g_rxu.rxu10 = l_lsm04
                      LET g_rxu.rxu11 = g_today
                      LET g_rxu.rxu12 = g_time
                      LET g_rxu.rxu13 = aws_pos_get_ConnectionMsg("mach")
                      LET g_rxu.rxu14 = l_type
                      LET g_rxu.rxu15 = l_totamt
                      LET g_rxu.rxuacti = 'Y'
                      CALL aws_pos_ins_rxu(g_rxu.*) RETURNING g_return.success
                   END IF 
                END IF 
                IF g_return.success = 'N' THEN 
                   ROLLBACK WORK
                ELSE
                   COMMIT WORK
                END IF 
                CLOSE lpj_cl
             CATCH 
                IF sqlca.sqlcode THEN
                   LET g_status.sqlcode = sqlca.sqlcode
                END IF 
                LET g_return.success = "N"
                ROLLBACK WORK 
                CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
             END TRY
          END IF 
       END IF 
    END IF 
    #CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_return))                           #FUN-D10095 Mark
    CALL aws_ttsrv_addTreeMaster(base.TypeInfo.create(g_return), "WritePoint") RETURNING l_node  #FUN-D10095 Add
END FUNCTION 
#No.FUN-C50138
