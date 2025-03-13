# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Program name...: aws_mod_password.4gl
# Descriptions...: 提供修改POS收銀員密碼的服務
# Date & Author..: 12/05/29 by suncx
# Modify.........: No.FUN-C50138 12/05/29 by suncx 新增程序
# Modify.........: No.TQC-C80097 12/08/16 By suncx 更新已傳pos否欄位
# Modify.........: No.FUN-D10095 13/01/25 By xumm XML格式调整

DATABASE ds 

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

DEFINE g_rxu    RECORD LIKE rxu_file.*
DEFINE g_return RECORD                  #回傳值必須宣告為一個 RECORD 變數
                success   STRING        #回傳的執行成功否
                END RECORD
#[
# Description....: 提供建立使用者基本資料的服務(入口 function)
# Date & Author..: 2012/05/29 by suncx
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_mod_password()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序

    #--------------------------------------------------------------------------#
    # 修改POS收銀員密碼                                                            #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_mod_password_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION



#[
# Description....: 依據傳入資訊修改POS收銀員密碼
# Date & Author..: 2012/05/29 by suncx
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_mod_password_process()
    DEFINE l_shop   LIKE azw_file.azw01,  #門店編號
           l_opno   LIKE ryi_file.ryi01,  #POS收銀員
           l_npsw   LIKE ryi_file.ryi03,  #POS收銀員密碼
           l_guid   LIKE rxu_file.rxu01   #傳輸編號
    DEFINE l_sql    STRING
    DEFINE l_azw01  LIKE azw_file.azw01
    DEFINE l_ryi    RECORD LIKE ryi_file.*, #收銀員資料
           l_ryo    RECORD LIKE ryo_file.*  #收銀員生效範圍資料
    DEFINE l_node    om.DomNode             #FUN-D10095 Add
    
    #取得各項參數
   #FUN-D10095 Mark&Add Begin ---
   #LET l_shop = aws_ttsrv_getParameter("Shop")
   #LET l_opno = aws_ttsrv_getParameter("OPNO")
   #LET l_npsw = aws_ttsrv_getParameter("npsw")
    LET l_node = aws_ttsrv_getTreeMasterRecord(1,"ModPassWord")
    LET l_shop = aws_ttsrv_getRecordField(l_node,"Shop")
    LET l_opno = aws_ttsrv_getRecordField(l_node,"OPNO")
    LET l_npsw = aws_ttsrv_getRecordField(l_node,"npsw")
   #FUN-D10095 Mark&Add End -----
    #LET l_guid = aws_ttsrv_getParameter("GUID")
    LET l_guid = aws_pos_get_ConnectionMsg("guid")
    
    CALL aws_pos_check() RETURNING g_return.success
    IF cl_null(g_return.success) THEN LET g_return.success = 'N' END IF 
    IF g_return.success = 'Y' THEN 
       IF NOT cl_null(l_guid) THEN   #傳輸編號不為空
          #查詢POS收銀員資料
          LET l_sql = "SELECT * FROM ",cl_get_target_table(l_shop,"ryi_file"),
                      "  LEFT JOIN ",cl_get_target_table(l_shop,"ryo_file"),
                      "    ON ryo01 = ryi01 AND ryo02 = '",l_shop,"'",     
                      " WHERE ryi01 = '",l_opno,"' "
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
          TRY
             PREPARE sel_ryi01_pre FROM l_sql
             EXECUTE sel_ryi01_pre INTO l_ryi.*,l_ryo.*
          CATCH 
             IF sqlca.sqlcode THEN
                LET g_status.sqlcode = sqlca.sqlcode
             END IF 
             LET g_return.success = "N"
             CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤  
             RETURN 
          END TRY
          IF sqlca.sqlcode = 100 THEN       #收銀員不存在
             CALL aws_pos_get_code('aws-904',NULL,NULL,NULL) 
             LET g_return.success = "N"
          ELSE 
             IF l_ryi.ryiacti = "Y" AND l_ryo.ryoacti = "Y" THEN    #判斷POS收銀員及收銀員生效範圍是否有效
                TRY 
                   IF aws_pos_guid_isExistence(l_guid) THEN 
                      LET g_return.success = "Y"
                   ELSE 
                      BEGIN WORK   #開始更新密碼事務
                      #鎖住需要修改的資料
                      LET l_sql = "SELECT * FROM ",cl_get_target_table(l_shop,"ryi_file"),
                                  " WHERE ryi01 = ? FOR UPDATE"
                      LET l_sql = cl_forupd_sql(l_sql)
                      DECLARE ryi_cl CURSOR FROM l_sql
                      OPEN ryi_cl USING l_opno
                      IF STATUS THEN
                         LET g_status.sqlcode = STATUS
                         CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤  
                         LET g_return.success = "N"
                      END IF
                      IF g_return.success = 'Y' THEN 
                         LET l_sql = " UPDATE ",cl_get_target_table(l_shop,"ryi_file"),
                                     "    SET ryi03 = '",l_npsw,"',",
                                     "        ryipos = '2'",    #TQC-C80097 add
                                     "  WHERE ryi01 = '",l_opno,"'"
                         CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
                         PREPARE upd_password_pre FROM l_sql
                         EXECUTE upd_password_pre 
                         IF sqlca.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN 
                            LET g_return.success = "N"
                         END IF
                      END IF 
                      IF g_return.success = 'Y' THEN 
                         #寫rxu_file
                         LET g_rxu.rxu01 = l_guid
                         LET g_rxu.rxu02 = ' '
                         LET g_rxu.rxu03 = l_shop
                         LET g_rxu.rxu04 = ' '
                         LET g_rxu.rxu05 = g_service
                         LET g_rxu.rxu06 = '1'
                         LET g_rxu.rxu07 = l_ryi.ryi01
                         LET g_rxu.rxu08 = l_ryi.ryi03
                         LET g_rxu.rxu09 = l_npsw
                         LET g_rxu.rxu10 = NULL
                         LET g_rxu.rxu11 = g_today
                         LET g_rxu.rxu12 = g_time
                         LET g_rxu.rxu13 = aws_pos_get_ConnectionMsg("mach")
                         LET g_rxu.rxu14 = ' '
                         LET g_rxu.rxu15 = 0
                         LET g_rxu.rxuacti = 'Y'
                         CALL aws_pos_ins_rxu(g_rxu.*) RETURNING g_return.success
                      END IF 
                      IF g_return.success = 'Y' THEN 
                         COMMIT WORK 
                      ELSE 
                         ROLLBACK WORK 
                      END IF
                      CLOSE ryi_cl
                   END IF 
                CATCH 
                   IF sqlca.sqlcode THEN
                      LET g_status.sqlcode = sqlca.sqlcode
                   END IF
                   CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤  
                   LET g_return.success = "N"
                   ROLLBACK WORK
                   CLOSE ryi_cl
                END TRY
             ELSE 
                LET g_return.success = "N"
                CALL aws_pos_get_code('aws-903',NULL,NULL,NULL) #收銀員失效
             END IF 
          END IF 
       ELSE
          LET g_return.success = "N"
       END IF 
    END IF 
    #CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_return))                            #FUN-D10095 Mark
    CALL aws_ttsrv_addTreeMaster(base.TypeInfo.create(g_return), "ModPassWord") RETURNING l_node  #FUN-D10095 Add
END FUNCTION 
#No.FUN-C50138
