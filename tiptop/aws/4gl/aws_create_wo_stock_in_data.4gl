# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_wo_stock_in_data.4gl
# Descriptions...: 提供建立完工入庫單資料的服務
# Date & Author..: 2008/05/12 by kim (FUN-840012)
# Memo...........:
# Modify.........: No.CHI-8B0002 07/11/03 By kim 入庫量的檢查有錯
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60027 10/06/22 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60081 10/06/25 By vealxu MAX(ecm03)相關 
# Modify.........: No:MOD-B80216 12/06/15 By Elise 在判斷是否為聯產品時where條件沒有判斷料號
# Modify.........: No:FUN-C70037 12/08/16 By lixh1 CALL s_minp增加傳入日期參數
 
DATABASE ds
 
#FUN-840012
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
GLOBALS "../../asf/4gl/sasft620.global"
 
GLOBALS
# DEFINE   g_sfb  RECORD LIKE sfb_file.*
DEFINE   g_argv  LIKE type_file.chr1   #1:一般入庫  2:退庫  3:重複性生產入庫
DEFINE   g_combin_fqc  LIKE type_file.chr1 #Y:認定聯產品時機在FQC
DEFINE   g_min_set  LIKE sfb_file.sfb08
DEFINE   g_over_qty LIKE sfb_file.sfb08
END GLOBALS
 
#[
# Description....: 提供建立完工入庫單資料的服務(入口 function)
# Date & Author..: 2008/05/12 by kim
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_wo_stock_in_data()
 
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增完工入庫單資料                                                       #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_wo_stock_in_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 依據傳入資訊新增 ERP 完工入庫單資料
# Date & Author..: 2008/05/12 by kim
# Parameter......: none
# Return.........: 入庫單號
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_wo_stock_in_data_process()
    DEFINE l_i        LIKE type_file.num10,
           l_j        LIKE type_file.num10
    DEFINE l_sql      STRING
    DEFINE l_cnt      LIKE type_file.num10,
           l_cnt1     LIKE type_file.num10,
           l_cnt2     LIKE type_file.num10
    DEFINE l_node1    om.DomNode,
           l_node2    om.DomNode
    DEFINE l_flag     LIKE type_file.num10
    DEFINE l_return   RECORD                           #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                         sfu01   LIKE sfu_file.sfu01   #回傳的欄位名稱
                      END RECORD
    DEFINE l_sfu      RECORD LIKE sfu_file.*
    DEFINE l_sfv      RECORD LIKE sfv_file.*
    DEFINE l_yy,l_mm  LIKE type_file.num5       
    DEFINE l_status   LIKE sfu_file.sfuconf
    DEFINE l_cmd      STRING
    DEFINE l_prog     STRING
 
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的完工入庫單資料                                    #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("sfu_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
 
    SELECT * INTO g_sma.*
      FROM sma_file
     WHERE sma00='0'
 
    LET g_argv='1'
    LET g_combin_fqc='N'
    BEGIN WORK
 
    FOR l_i = 1 TO l_cnt1
        INITIALIZE l_sfu.* TO NULL
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "sfu_file")        #目前處理單檔的 XML 節點
        LET l_status = aws_ttsrv_getParameter("status")
 
        LET l_sfu.sfu01 = aws_ttsrv_getRecordField(l_node1, "sfu01")         #取得此筆單檔資料的欄位值
        LET l_sfu.sfu02 = aws_ttsrv_getRecordField(l_node1, "sfu02")
        LET l_sfu.sfu07 = aws_ttsrv_getRecordField(l_node1, "sfu07")
 
        
        #----------------------------------------------------------------------#
        # 完工入庫單自動取號                                                   #
        #----------------------------------------------------------------------#      
        IF NOT cl_null(g_sma.sma53) AND l_sfu.sfu02 <= g_sma.sma53 THEN
           LET g_status.code = "mfg9999"
           EXIT FOR
        END IF
        CALL s_yp(l_sfu.sfu02) RETURNING l_yy,l_mm
        #不可大於現行年月
        IF (l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
           LET g_status.code = 'mfg6091'
           EXIT FOR
        END IF
        CALL s_check_no("ASF",l_sfu.sfu01,"","A","sfu_file","sfu01","")
          RETURNING l_flag,l_sfu.sfu01
        IF NOT l_flag THEN
           LET g_status.code = "apm-920"   #完工入庫單自動取號失敗
           EXIT FOR
        END IF
        CALL s_auto_assign_no("ASF",l_sfu.sfu01,l_sfu.sfu02,"3","sfu_file","sfu01","","","")
             RETURNING l_flag, l_sfu.sfu01
        IF NOT l_flag THEN
           LET g_status.code = "apm-920"   #完工入庫單自動取號失敗
           EXIT FOR
        END IF
 
        #------------------------------------------------------------------#
        # 設定入庫單頭預設值                                               #
        #------------------------------------------------------------------#
        CALL aws_create_wostockin_set_sfu(l_sfu.*) RETURNING l_sfu.*
        IF NOT cl_null(g_errno) THEN
           LET g_status.code = g_errno
           EXIT FOR
        END IF
 
 
       #CALL aws_ttsrv_setRecordField(l_node1, "sfu01", l_sfu.sfu01)   #更新 XML 取號完成後的完工入庫單單號欄位(sfu01)
 
       #IF NOT aws_create_wo_stock_in_data_default(l_node1) THEN     #檢查完工入庫單欄位預設值           
       #   EXIT FOR
       #END IF
 
        #------------------------------------------------------------------#
        # RECORD資料傳到NODE                                               #
        #------------------------------------------------------------------#
        CALL aws_ttsrv_setRecordField_record(l_node1,base.Typeinfo.create(l_sfu))
 
        LET l_sql = aws_ttsrv_getRecordSql(l_node1, "sfu_file", "I", NULL)   #I 表示取得 INSERT SQL
 
        #----------------------------------------------------------------------#
        # 執行單頭 INSERT SQL                                                  #
        #----------------------------------------------------------------------#
        EXECUTE IMMEDIATE l_sql
        IF SQLCA.SQLCODE THEN
           LET g_status.code = SQLCA.SQLCODE
           LET g_status.sqlcode = SQLCA.SQLCODE
           EXIT FOR
        END IF
        
        #----------------------------------------------------------------------#
        # 處理單身資料                                                         #
        #----------------------------------------------------------------------#
        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "sfv_file")       #取得目前單頭共有幾筆單身資料
        IF l_cnt2 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           EXIT FOR
        END IF
 
        CALL cl_flow_notify(l_sfu.sfu01,'I')  #新增資料到 p_flow
        
        FOR l_j = 1 TO l_cnt2
            INITIALIZE l_sfv.* TO NULL
            LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "sfv_file")   #目前單身的 XML 節點
 
 
            #------------------------------------------------------------------#
            # NODE資料傳到RECORD                                               #
            #------------------------------------------------------------------#
            LET l_sfv.sfv01=l_sfu.sfu01
            LET l_sfv.sfv03=l_j
            LET l_sfv.sfv04 = aws_ttsrv_getRecordField(l_node2, "sfv04")
            LET l_sfv.sfv05 = aws_ttsrv_getRecordField(l_node2, "sfv05")
            LET l_sfv.sfv06 = aws_ttsrv_getRecordField(l_node2, "sfv06")
            LET l_sfv.sfv07 = aws_ttsrv_getRecordField(l_node2, "sfv07")
            LET l_sfv.sfv09 = aws_ttsrv_getRecordField(l_node2, "sfv09")
            LET l_sfv.sfv11 = aws_ttsrv_getRecordField(l_node2, "sfv11")         #工單單號 , 可空白
            LET l_sfv.sfv17 = aws_ttsrv_getRecordField(l_node2, "sfv17")         #FQC單號  , 可空白
 
 
            #------------------------------------------------------------------#
            # 設定欄位預設值                                                   #
            #------------------------------------------------------------------#
            CALL aws_create_wostockin_set_sfv_def(l_sfu.*,l_sfv.*) 
                 RETURNING l_sfv.*
 
 
            #------------------------------------------------------------------#
            # 欄位檢查                                                         #
            #------------------------------------------------------------------#
            CALL aws_create_wostockin_check_sfv(l_sfu.*,l_sfv.*) 
                 RETURNING l_sfv.*
            IF NOT cl_null(g_errno) THEN
               LET g_status.code=g_errno
               EXIT FOR
            END IF
 
 
 
            #------------------------------------------------------------------#
            # RECORD資料傳到NODE2                                              #
            #------------------------------------------------------------------#
            CALL aws_ttsrv_setRecordField_record(l_node2,base.Typeinfo.create(l_sfv))
 
            IF cl_null(l_sfv.sfv05) THEN 
               LET l_sfv.sfv05=" "
               CALL aws_ttsrv_setRecordField(l_node2, "sfv05", " ")
            END IF
            IF cl_null(l_sfv.sfv06) THEN 
               LET l_sfv.sfv06=" "
               CALL aws_ttsrv_setRecordField(l_node2, "sfv06", " ")
            END IF
            IF cl_null(l_sfv.sfv07) THEN 
               LET l_sfv.sfv07=" "
               CALL aws_ttsrv_setRecordField(l_node2, "sfv07", " ")
            END IF
 
 
            LET l_sql = aws_ttsrv_getRecordSql(l_node2, "sfv_file", "I", NULL) #I 表示取得 INSERT SQL
            
            #------------------------------------------------------------------#
            # 執行單身 INSERT SQL                                              #
            #------------------------------------------------------------------#
            EXECUTE IMMEDIATE l_sql
            IF SQLCA.SQLCODE THEN
               LET g_status.code = SQLCA.SQLCODE
               LET g_status.sqlcode = SQLCA.SQLCODE
               EXIT FOR
            END IF
        END FOR
        IF g_status.code != "0" THEN   #如果單身處理有任何錯誤, 則離開
           EXIT FOR
        END IF
    END FOR
    
    IF g_status.code = "0" THEN
       LET l_return.sfu01 = l_sfu.sfu01
      #CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳 ERP 建立的完工入庫單單號
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
    #CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳自動取號結果
 
    IF (l_status='Y') AND (g_status.code = "0") THEN
       LET l_prog = 'asft620'
       LET l_cmd=l_prog," '",l_sfu.sfu01 CLIPPED,"' 'stock_post'"
       CALL cl_cmdrun_wait(l_cmd)
       CALL aws_ttsrv_cmdrun_checkStatus(l_prog)
    END IF
    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳自動取號結果
END FUNCTION
 
#[
# Description....: 完工入庫單設定欄位預設值
# Date & Author..: 2008/04/07 by kim
# Parameter......: l_sfu - 入庫單單頭
# Return.........: l_sfu - 入庫單單頭
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_wostockin_set_sfu(l_sfu)
    DEFINE l_sfu RECORD LIKE sfu_file.*
 
    LET g_errno=NULL
    #--------------------------------------------------------------------------#
    # 設定完工入庫單單頭欄位預設值                                             #
    #--------------------------------------------------------------------------#
    IF cl_null(l_sfu.sfu02) OR l_sfu.sfu02=0 THEN
       LET l_sfu.sfu02 = g_today
    END IF
    LET l_sfu.sfu00 = '1'
    LET l_sfu.sfu02 = g_today
    LET l_sfu.sfu04 = g_grup
    LET l_sfu.sfupost='N'
    LET l_sfu.sfuconf='N'
    LET l_sfu.sfuuser=g_user
    LET g_data_plant = g_plant #FUN-980030
    LET l_sfu.sfugrup=g_grup
    LET l_sfu.sfudate=g_today
    LET l_sfu.sfu04=g_grup
    RETURN l_sfu.*
END FUNCTION
 
 
#[
# Description....: 設定單身預設值
# Date & Author..: 2008/04/07 by kim
# Parameter......: l_sfv - 入庫單身
# Return.........: 
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_wostockin_set_sfv_def(l_sfu,l_sfv)
  DEFINE l_sfu    RECORD LIKE sfu_file.*
  DEFINE l_sfv    RECORD LIKE sfv_file.*
  
 
   #--------------------------------------------------------------------------#
   # 設定完工入庫單單身欄位預設值  from sapmt620._b().BEFORE INSERT           #
   #--------------------------------------------------------------------------#
   LET l_sfv.sfv16  = 'N'
   IF cl_null(l_sfv.sfv05) THEN 
      LET l_sfv.sfv05=" "
   END IF
   IF cl_null(l_sfv.sfv06) THEN 
      LET l_sfv.sfv06=" "
   END IF
   IF cl_null(l_sfv.sfv07) THEN 
      LET l_sfv.sfv07=" "
   END IF
   RETURN l_sfv.*
END FUNCTION
 
#[
# Description....: 檢查單身欄位
# Date & Author..: 2008/04/07 by kim
# Parameter......: l_sfu,l_sfv - 入庫單頭/單身
# Return.........: no - use g_errno 判斷檢查是否有誤
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_wostockin_check_sfv(l_sfu,l_sfv)
  DEFINE l_sfu    RECORD LIKE sfu_file.*
  DEFINE l_sfv    RECORD LIKE sfv_file.*
 
  LET g_errno=NULL
 
  #--------------------------------------------------------------------------#
  # 將FQC資料帶入入庫單單身                                                  #
  #--------------------------------------------------------------------------#
  IF NOT cl_null(l_sfv.sfv17) THEN
     CALL aws_create_wostockin_chk_sfv17('a',l_sfu.*,l_sfv.*) 
        RETURNING l_sfv.*
     IF NOT cl_null(g_errno) THEN
        RETURN l_sfv.*
     END IF
  END IF
  
  #--------------------------------------------------------------------------#
  # 將工單資料帶入入庫單單身                                                 #
  #--------------------------------------------------------------------------#
  CALL aws_create_wostockin_chk_sfv11_1('a',l_sfu.*,l_sfv.*) 
     RETURNING l_sfv.*
  IF NOT cl_null(g_errno) THEN
     RETURN l_sfv.*
  END IF
 
  CALL aws_create_wostockin_chk_sfv11_2('a',l_sfu.*,l_sfv.*) 
     RETURNING l_sfv.*
  IF NOT cl_null(g_errno) THEN
     RETURN l_sfv.*
  END IF
 
  #--------------------------------------------------------------------------#
  # 檢查料件編號                                                             #
  #--------------------------------------------------------------------------#
  CALL aws_create_wostockin_check_sfv04(l_sfv.*) RETURNING l_sfv.*
  IF (NOT cl_null(g_errno)) THEN
     RETURN l_sfv.*
  END IF
 
  #--------------------------------------------------------------------------#
  # 檢查入庫數量是否超過                                                     #
  #--------------------------------------------------------------------------#
  CALL aws_create_wostockin_check_sfv09('a',l_sfu.*,l_sfv.*)
     RETURNING l_sfv.*
  IF (NOT cl_null(g_errno)) THEN
     RETURN l_sfv.*
  END IF
 
  #--------------------------------------------------------------------------#
  # 檢查倉儲批                                                               #
  #--------------------------------------------------------------------------#
  CALL aws_create_wostockin_check_sfv05('a',l_sfu.*,l_sfv.*)
     RETURNING l_sfv.*  
  IF (NOT cl_null(g_errno)) THEN
     RETURN l_sfv.*
  END IF
  RETURN l_sfv.*
  
  
END FUNCTION
 
#[
# Description....: 由工單/FQC資料進入庫單單身
# Date & Author..: 2008/05/12 by kim
# Parameter......: p_cmd-固定傳'a'新增,l_sfu-入庫單頭,l_sfv - 入庫單身
# Return.........: l_sfv-入庫單單身值 ; use g_errno 判斷檢查是否有誤
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_wostockin_chk_sfv17(p_cmd,l_sfu,l_sfv)
 DEFINE l_qcf02   LIKE qcf_file.qcf02,
        l_qcf021  LIKE qcf_file.qcf021,
        l_qcf14   LIKE qcf_file.qcf14,
        l_qcfacti LIKE qcf_file.qcfacti,
        l_qcf09   LIKE qcf_file.qcf09,
        l_qcf36   LIKE qcf_file.qcf36,
        l_qcf37   LIKE qcf_file.qcf37,
        l_qcf38   LIKE qcf_file.qcf38,
        l_qcf39   LIKE qcf_file.qcf39,
        l_qcf40   LIKE qcf_file.qcf40,
        l_qcf41   LIKE qcf_file.qcf41,
        p_cmd     LIKE type_file.chr1 
 DEFINE l_sfu     RECORD LIKE sfu_file.*
 DEFINE l_sfv     RECORD LIKE sfv_file.*
 
   LET g_errno = ''
   SELECT qcf02,qcf021,qcf14,qcfacti,qcf09,
          qcf36,qcf37,qcf38,qcf39,qcf40,qcf41
     INTO l_qcf02,l_qcf021,l_qcf14,l_qcfacti,l_qcf09,
          l_qcf36,l_qcf37,l_qcf38,l_qcf39,l_qcf40,l_qcf41
     FROM qcf_file
    WHERE qcf01 = l_sfv.sfv17
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0044'
        WHEN l_qcfacti='N'        LET g_errno = '9028'
        WHEN l_qcf14='N'          LET g_errno = 'asf-048'
        WHEN l_qcf09='2'          LET g_errno = 'aqc-400'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) THEN
      LET l_sfv.sfv11 = l_qcf02
      LET l_sfv.sfv04 = l_qcf021
      LET l_sfv.sfv30 = l_qcf36
      LET l_sfv.sfv31 = l_qcf37
      LET l_sfv.sfv32 = l_qcf38
      LET l_sfv.sfv33 = l_qcf39
      LET l_sfv.sfv34 = l_qcf40
      LET l_sfv.sfv35 = l_qcf41
     #DISPLAY BY NAME l_sfv.sfv11
     #DISPLAY BY NAME l_sfv.sfv04
     #DISPLAY BY NAME l_sfv.sfv30,l_sfv.sfv31,l_sfv.sfv32
     #DISPLAY BY NAME l_sfv.sfv33,l_sfv.sfv34,l_sfv.sfv35
   END IF
 
    RETURN l_sfv.*
END FUNCTION
 
FUNCTION aws_create_wostockin_chk_sfv11_1(p_cmd,l_sfu,l_sfv)
   DEFINE l_ima02   LIKE ima_file.ima02,
          l_ima021  LIKE ima_file.ima021,
          l_ima25   LIKE ima_file.ima25,
          l_ima35   LIKE ima_file.ima35,
          l_ima36   LIKE ima_file.ima36,
          l_ima55   LIKE ima_file.ima55,
          l_ima55_fac   LIKE ima_file.ima55_fac,
          l_sfv09   LIKE sfv_file.sfv09,
          l_qcf091  LIKE qcf_file.qcf091,
          l_smydesc LIKE smy_file.smydesc,
          l_cnt     LIKE type_file.num5,    
          l_d2      LIKE oea_file.oea01,    
          l_d4      LIKE type_file.chr20,   
          l_no     LIKE type_file.chr5,     
          l_status LIKE type_file.num10,    
          p_cmd    LIKE type_file.chr1,     
          p_ac     LIKE type_file.num5,
          l_sfu    RECORD LIKE sfu_file.*,   
          l_sfv    RECORD LIKE sfv_file.*
 
   INITIALIZE g_sfb.* TO NULL
   LET g_errno=NULL
 
   IF NOT cl_null(l_sfv.sfv17) AND g_sma.sma896='Y' THEN
 
      LET l_qcf091 = 0
      SELECT qcf091 INTO l_qcf091 FROM qcf_file
       WHERE qcf01 = l_sfv.sfv17
         AND qcf02 = l_sfv.sfv11
         AND qcf09 <> '2'                 #NO:6872
         AND qcf14 = 'Y'
      IF SQLCA.sqlcode THEN
         LET g_errno='asf-732'
         RETURN l_sfv.*
      ELSE
         IF cl_null(l_qcf091) THEN
            LET l_qcf091 = 0
         END IF
      END IF
   END IF
 
    LET l_ima02=' '
    LET l_ima021=' '
    LET l_ima25=' '
    LET l_ima35=' '
    LET l_ima36=' '
    LET l_ima55=' '
    LET l_ima55_fac=0
 
    SELECT sfb_file.* INTO g_sfb.* FROM sfb_file
     WHERE sfb01=l_sfv.sfv11
    IF SQLCA.sqlcode THEN
       LET l_status=SQLCA.sqlcode
    ELSE
       LET l_status=0
    END IF
 
    LET l_sfv.sfv04 = g_sfb.sfb05
 
    SELECT ima02,ima021,ima35,ima36,ima55,ima55_fac
      INTO l_ima02,l_ima021,l_ima35,l_ima36,l_ima55,l_ima55_fac
      FROM ima_file
     WHERE ima01 = g_sfb.sfb05
    IF SQLCA.sqlcode THEN
       LET g_errno='asf-677'
       RETURN l_sfv.*
    END IF
 
    CASE
       WHEN l_status = NOTFOUND
            LET g_errno = 'mfg9005'
            INITIALIZE g_sfb.* TO NULL
            LET l_ima02=' '
            LET l_ima021=' '
            LET l_ima35=' '
            LET l_ima36=' '
            LET l_ima55=' '
       WHEN g_sfb.sfbacti='N'
            LET g_errno = '9028'
       WHEN g_argv='0' AND g_sfb.sfb06 IS NULL
            LET g_errno = 'asf-394'
       WHEN g_sfb.sfb04<'2' OR   g_sfb.sfb28='3'
            LET g_errno='mfg9006'
       WHEN g_sfb.sfb04 ='8'
            LET g_errno='mfg3430'
       OTHERWISE
            LET g_errno = l_status USING '-------'
    END CASE
     IF g_sfb.sfb02 MATCHES '[78]' THEN    #委外工單
       LET g_errno='mfg9185'
    END IF
    IF g_sfb.sfb02 = 11 THEN    #拆件式工單
       LET g_errno='asf-709'
    END IF
 
   #FUN-840012
   #IF p_cmd = 'a' THEN
   #   IF g_sfb.sfb30 IS NULL OR g_sfb.sfb30 = ' ' THEN
   #      LET l_sfv.sfv05 = l_ima35
   #   ELSE
   #      LET l_sfv.sfv05 = g_sfb.sfb30
   #   END IF
   #   IF g_sfb.sfb31 IS NULL OR g_sfb.sfb31 = ' ' THEN
   #      LET l_sfv.sfv06 = l_ima36
   #   ELSE
   #      LET l_sfv.sfv06 = g_sfb.sfb31
   #   END IF
   #END IF
 
    LET l_sfv.sfv08  = l_ima55       #生產單位
    LET l_sfv.sfv30  = l_ima55       #生產單位
    LET l_sfv.sfv31  = 1
 
 
#須走FQC流程-合計FQC單總完工入庫量
    IF p_cmd = 'a' THEN  #FUN-540055 add
       IF g_sfb.sfb94 = 'Y' THEN
          SELECT SUM(sfv09) INTO l_sfv09 FROM sfv_file,sfu_file
           WHERE sfv17 = l_sfv.sfv17
             AND (( sfv01 != l_sfu.sfu01 ) OR
                  ( sfv01 = l_sfu.sfu01 AND sfv03 != l_sfv.sfv03 ))
             AND sfv01 = sfu01
             AND sfuconf !='X'
          IF cl_null(l_sfv09) THEN
             LET l_sfv09 = 0
          END IF
          LET l_sfv.sfv32 = l_qcf091 - l_sfv09
       ELSE
          LET l_sfv.sfv32 = g_sfb.sfb081 - g_sfb.sfb09
       END IF
    END IF
    IF g_sma.sma115 = 'Y' THEN
       CALL aws_create_wostockin_du_default(p_cmd,l_sfv.*)
          RETURNING l_sfv.*
    END IF
 
 
    LET l_sfv.sfv930=g_sfb.sfb98
    
    RETURN l_sfv.*
 
    #DISPLAY BY NAME g_sfv[p_ac].sfv930
    #DISPLAY BY NAME g_sfv[p_ac].gem02c
    #DISPLAY BY NAME g_sfv[p_ac].sfv04
    #DISPLAY BY NAME g_sfv[p_ac].ima02
    #DISPLAY BY NAME g_sfv[p_ac].ima021
    #DISPLAY BY NAME g_sfv[p_ac].sfv05
    #DISPLAY BY NAME g_sfv[p_ac].sfv06
    #DISPLAY BY NAME g_sfv[p_ac].sfv07
    #DISPLAY BY NAME g_sfv[p_ac].sfv08
    #DISPLAY BY NAME g_sfv[p_ac].sfv30
    #DISPLAY BY NAME g_sfv[p_ac].sfv31
    #DISPLAY BY NAME g_sfv[p_ac].sfv32
END FUNCTION
 
 
#用于default 雙單位/轉換率/數量
FUNCTION aws_create_wostockin_du_default(p_cmd,l_sfv)
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ware   LIKE img_file.img02,     #倉庫
            l_loc    LIKE img_file.img03,     #儲
            l_lot    LIKE img_file.img04,     #批
            l_ima55  LIKE ima_file.ima55,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_unit2  LIKE img_file.img09,     #第二單位
            l_fac2   LIKE sfv_file.sfv34,     #第二轉換率
            l_qty2   LIKE sfv_file.sfv35,     #第二數量
            l_unit1  LIKE img_file.img09,     #第一單位
            l_fac1   LIKE sfv_file.sfv31,     #第一轉換率
            l_qty1   LIKE sfv_file.sfv32,     #第一數量
            p_cmd    LIKE type_file.chr1,     
            l_errno  LIKE type_file.chr20,    
            l_factor LIKE ima_file.ima31_fac  
  DEFINE    l_sfv    RECORD LIKE sfv_file.*
 
    IF cl_null(l_sfv.sfv04) THEN RETURN END IF
    LET l_item = l_sfv.sfv04
    LET l_ware = l_sfv.sfv05
    LET l_loc  = l_sfv.sfv06
    LET l_lot  = l_sfv.sfv07
 
    SELECT ima55,ima906,ima907 INTO l_ima55,l_ima906,l_ima907
      FROM ima_file WHERE ima01 = l_item
 
    IF l_ima906 = '1' THEN  #不使用雙單位
       LET l_unit2 = NULL
       LET l_fac2  = NULL
       LET l_qty2  = NULL
    ELSE
       LET l_unit2 = l_ima907
       CALL s_du_umfchk(l_item,'','','',l_ima55,l_ima907,l_ima906)
            RETURNING l_errno,l_factor
       IF NOT cl_null(l_errno) THEN LET g_errno =l_errno ENd IF
       LET l_fac2 = l_factor
       LET l_qty2  = 0
    END IF
 
    IF p_cmd = 'a' THEN
       LET l_sfv.sfv33=l_unit2
       LET l_sfv.sfv34=l_fac2
       LET l_sfv.sfv35=l_qty2
    END IF
    RETURN l_sfv.*
END FUNCTION
 
FUNCTION aws_create_wostockin_chk_sfv11_2(p_cmd,l_sfu,l_sfv)
DEFINE p_cmd LIKE type_file.chr1,
    l_ecu04          LIKE ecu_file.ecu04,
    l_ecu05          LIKE ecu_file.ecu05,
    l_msg            LIKE type_file.chr1000,   #No.MOD-6A0009 add
    l_sfv09_o        LIKE sfv_file.sfv09,      #No.MOD-6C0081 add
    l_sfb02          LIKE sfb_file.sfb02,      #FUN-660110 add
    l_qcf091         LIKE qcf_file.qcf091,
    l_bmm03_cnt      LIKE type_file.num10,
    l_n              LIKE type_file.num10,
    l_date           LIKE type_file.dat,
    l_cnt            LIKE type_file.num5
DEFINE
    l_ima            RECORD LIKE ima_file.*,
    l_qcf            RECORD LIKE qcf_file.*,
    l_flag           LIKE type_file.num5,
   #g_min_set        LIKE sfb_file.sfb08,
   #g_over_qty       LIKE sfb_file.sfb08,
   #tmp_qty          LIKE sfb_file.sfb08,  #CHI-8B0002
    l_sfu            RECORD LIKE sfu_file.*,
    l_sfv            RECORD LIKE sfv_file.*,
    l_ima906         LIKE ima_file.ima906,
    l_ima907         LIKE ima_file.ima907,
    l_ima571         LIKE ima_file.ima571
 
   IF (NOT cl_null(l_sfv.sfv11)) AND (g_argv<>'3') THEN
      SELECT sfb02 INTO l_sfb02 FROM sfb_file
       WHERE sfb01=l_sfv.sfv11
      IF l_sfb02 = '15' THEN
         CALL cl_err(l_sfv.sfv11,'asr-047',1)   #所輸入之工單型態不可為試產工單,請重新輸入!
         RETURN l_sfv.*
      END IF
 
      LET l_cnt = 0
      IF NOT cl_null(l_sfv.sfv17) AND g_sma.sma104 = 'Y' THEN #sma104是否使用聯產
         SELECT qcf_file.*,ima_file.* INTO l_qcf.*,l_ima.*
           FROM qcf_file,ima_file
          WHERE qcf01 = l_sfv.sfv17 #FQC單號
            AND qcf021= ima01
         IF g_sma.sma104 = 'Y' AND g_sma.sma105 = '1' THEN #認定聯產品的時機點為:1.FQC
             SELECT COUNT(*) INTO l_cnt
               FROM qde_file
              WHERE qde01 = l_sfv.sfv17
                AND qde02 = l_sfv.sfv11
             IF l_cnt >= 1 THEN
                 LET g_combin_fqc = 'Y'
                 LET l_sfv.sfv16='Y'
                 DISPLAY BY NAME l_sfv.sfv16
             END IF
         END IF
      END IF
 
      LET l_bmm03_cnt = 0
      IF NOT cl_null(l_sfv.sfv11)
         AND NOT cl_null(l_sfv.sfv04)
         AND g_sma.sma104 = 'Y'
         AND g_sma.sma105 = '2'THEN #避免修改時,原本已入聯產品,結果又被蓋掉
         SELECT ima_file.* INTO l_ima.* FROM ima_file,sfb_file
          WHERE ima01 = sfb05
            AND sfb01 = l_sfv.sfv11
         SELECT COUNT(*) INTO l_bmm03_cnt FROM bmm_file
          WHERE bmm03 = l_sfv.sfv04   #聯產品
            AND bmm01 = l_ima.ima01         #主件
      END IF
 
      IF l_cnt = 0 AND l_bmm03_cnt = 0 THEN
        #MOD-6C0081-begin-add
        #IF p_cmd='u' THEN #FUN-840012
        #   LET l_sfv09_o = l_sfv.sfv09 
        #END IF 
        #MOD-6C0081-end-add
         #程式原走法
         IF g_argv = '1' THEN
           #FUN-840012
           #  CALL t620_sfb01(l_ac,p_cmd)
           ##------No.TQC-5B0075 add
           #   IF g_err = 'Y' THEN
           #      RETURN l_sfv.*
           #   END IF
           ##----No.TQC-5B0075 end
 
            #檢查ima906的設定和sma115是否一致
            IF g_sma.sma115 ='Y' THEN
               CALL s_chk_va_setting(l_sfv.sfv04)
                    RETURNING l_flag,l_ima906,l_ima907
               IF l_flag=1 THEN
                  LET g_errno='aim-997'
                  RETURN l_sfv.*
               END IF
               IF l_ima906 = '3' THEN
                  LET l_sfv.sfv33=l_ima907
               END IF
            END IF
 
            IF g_sfb.sfb94='Y' AND
               cl_null(l_sfv.sfv17)  THEN   #No.TQC-5B0075 modify
               CALL cl_err(g_sfb.sfb01,'asf-680',1)
               RETURN l_sfv.*
            END IF
 
            IF g_sfb.sfb94='Y' AND (NOT cl_null(l_sfv.sfv17)) THEN
               SELECT COUNT(*) INTO l_n FROM qcf_file
                WHERE qcf00='1' AND qcf01=l_sfv.sfv17
                  AND qcf02=g_sfb.sfb01 AND qcf14 <> 'X'
               IF l_n=0 THEN
                  LET g_errno='asf-825'
                  RETURN l_sfv.*
               END IF
            END IF
 
            IF g_sfb.sfb39 != '2' THEN
               #檢查工單最小發料日是否小於入庫日
               SELECT MIN(sfp02) INTO l_date FROM sfe_file,sfp_file
                WHERE sfe01 = l_sfv.sfv11 AND sfe02 = sfp01
               IF STATUS OR cl_null(l_date) THEN
                  SELECT MIN(sfp02) INTO l_date FROM sfs_file,sfp_file
                   WHERE sfs03=l_sfv.sfv11 AND sfp01=sfs01
               END IF
             
               IF cl_null(l_date) OR l_date > l_sfu.sfu02 THEN
                  LET g_errno='asf-824'
                  RETURN l_sfv.*
               END IF
 
               #工單完工方式為'2' pull 不check min_set
               #最小套=min_set
               LET g_min_set = 0
 
               #default 時不考慮超限率sma74
              #CALL s_minp(l_sfv.sfv11,g_sma.sma73,0,'','','')   #FUN-A60027 add 2''   #FUN-C70037 mark
               CALL s_minp(l_sfv.sfv11,g_sma.sma73,0,'','','',l_sfu.sfu02)   #FUN-C70037 
                    RETURNING l_cnt,g_min_set
 
               IF l_cnt !=0  THEN
                  LET g_errno='asf-549'
                  RETURN l_sfv.*
               END IF
 
           # sma73 工單完工數量是否檢查發料最小套數
           # sma74 工單完工量容許差異百分比
 
               IF g_sma.sma73='Y' THEN  #
                  LET g_over_qty=((g_min_set*g_sma.sma74)/100)
               ELSE
                  LET g_over_qty=0
               END IF
 
               IF g_over_qty IS NULL THEN LET g_over_qty=0 END IF  #No.MOD-5A0444 add
 
              #CHI-8B0002 mark
              # sum(已存在入庫單入庫數量) by W/O (不管有無過帳)
              #SELECT SUM(sfv09) INTO tmp_qty FROM sfv_file,sfu_file
              # WHERE sfv11 = l_sfv.sfv11
              #   AND sfv01 = sfu01
              #   AND sfu00 = '1'   #類別 1.入庫  2.入庫退回
              #   AND sfuconf <> 'X'
              #
              #IF tmp_qty IS NULL OR SQLCA.sqlcode THEN LET tmp_qty=0 END IF
 
             #FUN-840012
             #IF (p_cmd='a') OR
             # (cl_null(l_sfv.sfv09)) OR
             # (l_sfv.sfv09=0) THEN
             #  LET l_sfv.sfv09=g_min_set - tmp_qty
             #END IF   #CHI-6C0004
               #DISPLAY BY NAME l_sfv.sfv09 #MOD-4A0260
 
               LET g_min_set=g_min_set + g_over_qty
               #----------------------------------------------------------
              #---------No.MOD-6A0009 modify
              #LET g_msg= g_x[1] CLIPPED,
              #           g_min_set USING '####.#'  #最小套數
 
              #CASE WHEN g_sma.sma73='Y' AND g_sma.sma74>0
              #          LET g_msg=g_msg CLIPPED,'(',g_sma.sma74 USING '+++','%)'
              #     WHEN g_sma.sma73='Y' AND g_sma.sma74<0
              #          LET g_msg=g_msg CLIPPED,'(',g_sma.sma74 USING '---','%)'
              #END CASE
 
              #LET g_msg=g_msg CLIPPED,
              #          g_x[2] CLIPPED,tmp_qty USING '####.#',    #已登打入庫量
              #          g_x[3] CLIPPED,
              #          (l_sfv.sfv09 + g_over_qty) USING '####.#' #可入庫量
              
              #FUN-840012
              #LET l_msg = cl_getmsg('asf-205',g_lang)
              #LET g_msg = l_msg CLIPPED,g_min_set USING '####.###'  #最小套數     #No.MOD-770048 modify
              #CASE WHEN g_sma.sma73='Y' AND g_sma.sma74>0
              #          LET g_msg=g_msg CLIPPED,'(',g_sma.sma74 USING '+++','%)'
              #     WHEN g_sma.sma73='Y' AND g_sma.sma74<0
              #          LET g_msg=g_msg CLIPPED,'(',g_sma.sma74 USING '---','%)'
              #END CASE
              #LET l_msg = cl_getmsg('asf-206',g_lang)
              #LET g_msg = g_msg CLIPPED,l_msg CLIPPED,
              #            tmp_qty USING '####.###'         #No.MOD-770048 modify
              #LET l_msg = cl_getmsg('asf-207',g_lang)
              #LET g_msg = g_msg CLIPPED,l_msg CLIPPED,
              #            (l_sfv.sfv09 + g_over_qty) USING '####.###' #可入庫量    #No.MOD-770048 modify
              #            
              #MESSAGE g_msg
              #---------No.MOD-6A0009 end
 
             #FUN-840012
             #  IF g_sfb.sfb93='Y' THEN # 製程否
             #   # 取最終製程之總轉出量(良品轉出量+Bonus)
             #     SELECT ecm311,ecm315 INTO g_ecm311,g_ecm315
             #       FROM ecm_file
             #      WHERE ecm01=l_sfv.sfv11
             #        AND ecm03= (SELECT MAX(ecm03) FROM ecm_file
             #                     WHERE ecm01=l_sfv.sfv11)
             #     IF STATUS THEN LET g_ecm311=0 END IF
             #     IF STATUS THEN LET g_ecm315=0 END IF
             #
             #     LET g_ecm_out=g_ecm311 + g_ecm315
             #
             # #MOD-4B0072:mark IF ..END 若走製程應以製程轉出數為準,而非最小套數
             # #   IF g_min_set>g_ecm_out THEN
             #        LET l_sfv.sfv09=g_ecm_out - tmp_qty
             # #        DISPLAY BY NAME l_sfv.sfv09 #MOD-4A0260
             # #   END IF
             # ##
             #
             #     LET g_msg= g_x[1] CLIPPED,
             #                g_min_set USING '####.###'  #最小套數     #No.MOD-770048 modify
             #
             #     CASE WHEN g_sma.sma73='Y' AND g_sma.sma74>0
             #               LET g_msg=g_msg CLIPPED,'(',g_sma.sma74 USING '+++','%)'
             #          WHEN g_sma.sma73='Y' AND g_sma.sma74<0
             #               LET g_msg=g_msg CLIPPED,'(',g_sma.sma74 USING '---','%)'
             #     END CASE
             #
             #     LET g_msg=g_msg CLIPPED,
             #               g_x[4] CLIPPED,g_ecm_out USING '####.###',#終站總轉出量    #No.MOD-770048 modify
             #               g_x[2] CLIPPED,tmp_qty USING '####.###',  #已登打入庫量    #No.MOD-770048 modify
             #               g_x[3] CLIPPED,(l_sfv.sfv09+g_over_qty)
             #               USING '####.###' #可入庫量      #No.MOD-770048 modify
             #     MESSAGE g_msg
             #
             #  END IF
 
 
             #FUN-840012
             #  #是否使用FQC功能
             #   IF g_sfb.sfb94='Y' AND g_sma.sma896='Y' THEN
             #     #-------------No.MOD-690005 modify
             #      # sum(已存在入庫單入庫數量) by W/O (不管有無過帳)
             #      SELECT SUM(sfv09) INTO tmp_qty FROM sfv_file,sfu_file
             #       WHERE sfv17 = l_sfv.sfv17
             #         AND sfv01 = sfu01
             #         AND sfu00 = '1'   #類別 1.入庫  2.入庫退回
             #         AND sfuconf <> 'X' #FUN-660137
             #
             #      IF tmp_qty IS NULL THEN LET tmp_qty=0 END IF
             #     #-------------No.MOD-690005 end
             #     #---------------No.TQC-760185 add
             #      IF g_sfv_t.sfv09 > 0 AND
             #         g_sfv_t.sfv11=l_sfv.sfv11 THEN
             #         LET tmp_qty=tmp_qty - g_sfv_t.sfv09
             #      END IF
             #     #---------------No.TQC-760185 end
             #
             #      SELECT qcf091 INTO l_qcf091 FROM qcf_file   # QC
             #       WHERE qcf01 = l_sfv.sfv17
             #         AND qcf09 <> '2'   #accept #NO:6872
             #         AND qcf14 = 'Y'
             #      IF STATUS OR l_qcf091 IS NULL THEN
             #         LET l_qcf091 = 0
             #      END IF
             #
             # #FUN-550085 mark
             # #       SELECT SUM(qcf091) INTO ll_qcf091 FROM qcf_file
             # #        WHERE qcf01 != l_sfv.sfv17
             # #          AND qcf02 = l_sfv.sfv11
             # #          AND qcf09 <> '2'   #accept #NO:6872
             # #          AND qcf14 = 'Y'
             # #       IF STATUS OR ll_qcf091 IS NULL THEN
             # #          LET ll_qcf091 = 0
             # #       END IF
             # #       LET l_qcf091=l_qcf091+ll_qcf091
             #
             #   IF g_sma.sma54='Y' AND g_sfb.sfb93='Y' THEN
             #      IF cl_null(g_ecm_out) THEN LET g_ecm_out=0 END IF
             #      IF g_min_set > g_ecm_out THEN
             #         LET l_min_qty= g_ecm_out
             #      ELSE
             #         LET l_min_qty= g_min_set
             #      END IF
             #      IF l_min_qty > l_qcf091 THEN
             #         LET l_sfv.sfv09=l_qcf091-tmp_qty
             #          DISPLAY BY NAME l_sfv.sfv09 #MOD-4A0260
             #      END IF
             #   ELSE
             #      IF g_min_set > l_qcf091 THEN
             #         LET l_sfv.sfv09=l_qcf091-tmp_qty
             #          DISPLAY BY NAME l_sfv.sfv09 #MOD-4A0260
             #      END IF
             #   END IF
             #
             #   LET g_msg= g_x[1] CLIPPED,
             #              g_min_set USING '####.###'  #最小套數     #No.MOD-770048 modify
             #
             #   CASE WHEN g_sma.sma73='Y' AND g_sma.sma74>0
             #             LET g_msg=g_msg CLIPPED,'(',g_sma.sma74 USING '+++','%)'
             #        WHEN g_sma.sma73='Y' AND g_sma.sma74<0
             #             LET g_msg=g_msg CLIPPED,'(',g_sma.sma74 USING '---','%)'
             #   END CASE
             #
             #   LET g_msg=g_msg CLIPPED,
             #             g_x[5] CLIPPED,l_qcf091 USING '####.###',  #FQC量          #No.MOD-770048 modify
             #             g_x[2] CLIPPED,tmp_qty USING '####.###',  #已登打入庫量    #No.MOD-770048 modify
             #             g_x[3] CLIPPED,(l_sfv.sfv09+g_over_qty)
             #                             USING '####.###' #可入庫量                 #No.MOD-770048 modify
             #   MESSAGE g_msg
             #END IF
            END IF
 
         #FUN-840012
         #ELSE   #退庫
         #   CALL t620_sfb011(l_ac)
         #   # sum(已存在退庫單退庫數量) by W/O (不管有無過帳)
         #   SELECT SUM(sfv09) INTO tmp_qty FROM sfv_file,sfu_file
         #    WHERE sfv11 = l_sfv.sfv11
         #      AND sfv01 = sfu01
         #      AND sfu00 = '2'   #類別 1.入庫  2.入庫退回
         #      AND sfuconf <> 'X' #FUN-660137
         #   IF tmp_qty IS NULL THEN LET tmp_qty=0 END IF
         #   LET l_sfv.sfv09= g_sfb.sfb09 - tmp_qty
         #   #FUN-540055  --begin
         #    DISPLAY BY NAME l_sfv.sfv09 #MOD-4A0260
         #   #檢查ima906的設定和sma115是否一致
         #   IF g_sma.sma115 ='Y' THEN
         #      CALL s_chk_va_setting(l_sfv.sfv04)
         #           RETURNING g_flag,l_ima906,l_ima907
         #      IF g_flag=1 THEN
         #         RETURN l_sfv.*
         #      END IF
         #      IF l_ima906 = '3' THEN
         #         LET l_sfv.sfv33=l_ima907
         #      END IF
         #      IF g_sfv_t.sfv11 != l_sfv.sfv11 THEN
         #         CALL t620_set_du_by_origin()
         #      END IF
         #      CALL t620_set_no_entry_b('s')     #No.MOD-790122 modify
         #      CALL t620_set_no_required_b()
         #   END IF
         #   #FUN-540055  --end
         END IF
 
        #FUN-840012
        ##MOD-6C0081-begin-add
        # IF p_cmd='u' THEN
        #    LET l_sfv.sfv09 = l_sfv09_o
        #    DISPLAY BY NAME l_sfv.sfv09
        # END IF 
        ##MOD-6C0081-end-add
 
         IF NOT cl_null(g_errno) THEN
            RETURN l_sfv.*
         END IF
 
         SELECT ima571 INTO l_ima571 FROM ima_file
          WHERE ima01=g_sfb.sfb05
         IF l_ima571 IS NULL THEN LET l_ima571=' ' END IF
 
         LET l_ecu04=0 LET l_ecu05=0
 
         IF g_sfb.sfb93 = 'Y'THEN  #製程否
            SELECT ecu04,ecu05 INTO l_ecu04,l_ecu05 FROM ecu_file
             WHERE ecu01=l_ima571 AND ecu02=g_sfb.sfb06
            IF g_argv MATCHES '[0]' AND l_ecu04=l_ecu05 THEN
               LET g_errno='asf-702'
               RETURN l_sfv.*
            END IF
         END IF
         #---->聯產品 NO:6872
         SELECT * INTO l_ima.* FROM ima_file
           WHERE ima01 = (SELECT sfb05 FROM sfb_file
                           WHERE sfb01 = l_sfv.sfv11)
         IF g_sma.sma104 = 'Y' AND g_sma.sma105 = '2' AND l_ima.ima903 = 'Y' THEN #認定聯產品的時機點為:2.完工入庫
             LET l_cnt=0
             SELECT COUNT(*) INTO l_cnt FROM bmm_file
              WHERE bmm01 = l_ima.ima01
             IF l_cnt >= 1 THEN
                 LET l_sfv.sfv16 = 'Y'
                 #DISPLAY BY NAME l_sfv.sfv16 #MOD-4A0260
             END IF
         END IF
      ELSE
         #---->聯產品 NO:6872
         LET l_sfv.sfv16 = 'Y'
         #DISPLAY BY NAME l_sfv.sfv16 #MOD-4A0260
      END IF
      
   END IF
   #---No.TQC-5B0075 add
      IF g_sfb.sfb94='Y' AND
         cl_null(l_sfv.sfv17)  THEN
         LET g_errno='asf-680'
         RETURN l_sfv.*
      END IF
 
      IF g_sfb.sfb94='Y' AND (NOT cl_null(l_sfv.sfv17)) THEN
         SELECT COUNT(*) INTO l_n FROM qcf_file
          WHERE qcf00='1' AND qcf01=l_sfv.sfv17
            AND qcf02=g_sfb.sfb01 AND qcf14 <> 'X'
         IF l_n=0 THEN
            LET g_errno='asf-825'
            RETURN l_sfv.*
         END IF
      END IF
   #-------No.TQC-5B0075 end
  #DISPLAY BY NAME l_sfv.sfv09  #mandy test
  #DISPLAY BY NAME l_sfv.sfv11  #mandy test
  #DISPLAY BY NAME l_sfv.sfv16  #mandy test
 
   RETURN l_sfv.*
END FUNCTION
 
FUNCTION aws_create_wostockin_check_sfv04(l_sfv)
DEFINE l_sfv RECORD LIKE sfv_file.*
DEFINE l_ima906 LIKE ima_file.ima906
DEFINE l_ima907 LIKE ima_file.ima907
DEFINE l_flag   LIKE type_file.num5
DEFINE l_ima903 LIKE ima_file.ima903
 
 
   IF NOT cl_null(l_sfv.sfv16) THEN
      IF l_sfv.sfv16 = 'Y' THEN
         SELECT ima903 INTO l_ima903 FROM ima_file
          WHERE ima01=l_sfv.sfv04     #MOD-B80216 add
         IF g_sma.sma105 = '1' AND l_ima903 = 'Y' THEN #認定聯產品的時機點為:1.FQC
            CALL aws_create_wostockin_check_sfv04_1('a',l_sfv.*) RETURNING l_sfv.*
         END IF
         IF NOT cl_null(g_errno) THEN
            RETURN l_sfv.*
         END IF
         IF g_sma.sma105 = '2' AND l_ima903 = 'Y' THEN #認定聯產品的時機點為:2.完工入庫
            CALL aws_create_wostockin_check_sfv04_2('a',l_sfv.*) RETURNING l_sfv.*
         END IF
         IF NOT cl_null(g_errno) THEN
            RETURN l_sfv.*
         END IF
      END IF
   END IF
   IF g_sma.sma115 ='Y' THEN
      IF NOT cl_null(l_sfv.sfv04) THEN
         CALL s_chk_va_setting(l_sfv.sfv04)
             RETURNING l_flag,l_ima906,l_ima907
         IF l_flag=1 THEN
            LET g_errno='abm-731'           
            RETURN l_sfv.*
         END IF
         IF l_ima906 = '3' THEN
            LET l_sfv.sfv33=l_ima907
         END IF
      END IF
   END IF
   RETURN l_sfv.*
END FUNCTION
 
FUNCTION aws_create_wostockin_check_sfv04_1(p_cmd,l_sfv)    #聯產品料件號編號
  DEFINE p_cmd       LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
  DEFINE l_sfv       RECORD LIKE sfv_file.*
 
          #單位 ,數量 ,倉   ,儲   ,批                ,備註
    SELECT qde12,      
          #qde09,qde10,qde11,ima02,ima021, #FUN-840012
           qde08
      INTO l_sfv.sfv08,                  
          #l_sfv.sfv05,  #FUN-840012
          #l_sfv.sfv06,
          #l_sfv.sfv07,
          #l_sfv.ima02,
          #l_sfv.ima021,
           l_sfv.sfv12
      FROM qde_file,ima_file
     WHERE qde01 = l_sfv.sfv17
       AND qde02 = l_sfv.sfv11
       AND qde05 = l_sfv.sfv04
       AND qde05 = ima01
    CASE WHEN SQLCA.SQLCODE = 100
                      LET g_errno = 'aqc-423' #在FQC聯產品資料維護作業(aqct403)中並無認定此聯產品料號
       OTHERWISE      LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    RETURN l_sfv.*
END FUNCTION
 
FUNCTION aws_create_wostockin_check_sfv04_2(p_cmd,l_sfv)    #聯產品料件號編號 NO:6872
  DEFINE l_sfv       RECORD LIKE sfv_file.*
  DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
         l_ima02     LIKE ima_file.ima02,
         l_ima021    LIKE ima_file.ima021,
         l_bmm04     LIKE bmm_file.bmm04,
         l_bmm05     LIKE bmm_file.bmm05,
         l_ima01     LIKE ima_file.ima01
 
       #單位,生效否
  SELECT bmm04,bmm05,ima02,ima021
    INTO l_bmm04,l_bmm05,l_ima02,l_ima021
    FROM bmm_file,OUTER ima_file
  #WHERE bmm01 = g_qcf.qcf021      #主件料件編號
   WHERE bmm01 = g_ima.ima01       #主件料件編號
     AND bmm03 = l_sfv.sfv04 #聯產品料件號編號
     AND bmm_file.bmm03 = ima_file.ima01
  CASE WHEN SQLCA.SQLCODE = 100
            SELECT qcf021 INTO l_ima01 FROM gcf_file
             WHERE qcf01 = l_sfv.sfv17
            IF l_ima01 = l_sfv.sfv04 THEN #可建成品料號
                SELECT ima55,ima02,ima021 INTO
                      l_bmm04,l_ima02,l_ima021
                  FROM ima_file
                 WHERE ima01=l_sfv.sfv04
                IF SQLCA.sqlcode = 100 THEN
                    LET g_errno = 'abm-610' #無此聯產品料號!
                    LET l_bmm04 = NULL
                    LET l_bmm05 = NULL
                    LET l_ima02 = NULL
                    LET l_ima021= NULL
                END IF
            ELSE
                LET g_errno = 'abm-610' #無此聯產品料號!
                LET l_bmm04 = NULL
                LET l_bmm05 = NULL
                LET l_ima02 = NULL
                LET l_ima021= NULL
            END IF
       WHEN l_bmm05='N' LET g_errno = '9028'
       OTHERWISE        LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  LET l_sfv.sfv08 = l_bmm04 #聯產品單位
  RETURN l_sfv.*
END FUNCTION
 
FUNCTION aws_create_wostockin_fqc(l_sfv)
  DEFINE l_sfv       RECORD LIKE sfv_file.*
  DEFINE l_qde06     LIKE qde_file.qde06,
         l_sfv09     LIKE sfv_file.sfv09,
         l_sfv09_now LIKE sfv_file.sfv09,
         l_qty_FQC   LIKE sfv_file.sfv09        #No.FUN-680121 DEC(15,3)#允許入庫量
 
    SELECT qde06 INTO l_qde06 #聯產品量
      FROM qde_file
     WHERE qde01 = l_sfv.sfv17
       AND qde02 = l_sfv.sfv11
       AND qde05 = l_sfv.sfv04
 
    # sum(已存在入庫單入庫數量) by W/O (不管有無過帳)
    SELECT SUM(sfv09) INTO l_sfv09 FROM sfv_file,sfu_file
     WHERE sfv11 = l_sfv.sfv11
       AND sfv04 = l_sfv.sfv04
       AND sfv01 = sfu01
       AND sfu00 = '1'   #類別 1.入庫  2.入庫退回
       AND sfuconf <> 'X' #FUN-660137
       AND sfv01 != l_sfu.sfu01
 
    SELECT SUM(sfv09) INTO l_sfv09_now FROM sfv_file
     WHERE sfv01  = l_sfu.sfu01
       AND sfv11  = l_sfv.sfv11
       AND sfv04  = l_sfv.sfv04
       AND sfv03 != l_sfv.sfv03
    IF cl_null(l_sfv09) THEN LET l_sfv09=0 END IF
    IF cl_null(l_sfv09_now) THEN LET l_sfv09_now=0 END IF
    LET l_sfv09 = l_sfv09 + l_sfv09_now
 
    LET l_qty_FQC = l_qde06 - l_sfv09
    RETURN l_sfv09,l_qty_FQC
END FUNCTION
 
FUNCTION aws_create_wostockin_check_sfv09(p_cmd,l_sfu,l_sfv)
DEFINE p_cmd LIKE type_file.chr1
DEFINE l_sfu RECORD LIKE sfu_file.*
DEFINE l_sfv RECORD LIKE sfv_file.*
DEFINE l_sfv09     LIKE sfv_file.sfv09,
       l_qty_FQC   LIKE sfv_file.sfv09
DEFINE l_ecm_out   LIKE sfv_file.sfv09
DEFINE l_ecm311    LIKE ecm_file.ecm311
DEFINE l_ecm315    LIKE ecm_file.ecm315
DEFINE l_fqc_qty   LIKE sfv_file.sfv09
DEFINE l_qty1      LIKE sfv_file.sfv09
DEFINE l_qty2      LIKE sfv_file.sfv09
DEFINE l_sfb08     LIKE sfb_file.sfb08
DEFINE l_qcf091    LIKE qcf_file.qcf091
DEFINE tmp_qty     LIKE sfv_file.sfv09
DEFINE l_ecm03     LIKE ecm_file.ecm03    #FUN-A60081
DEFINE l_ecm012    LIKE ecm_file.ecm012   #FUN-A60081
 
   LET g_errno=NULL
   CALL aws_create_wostockin_fqc(l_sfv.*)
      RETURNING l_sfv09,l_qty_FQC
 
   #------->聯產品
   IF g_combin_fqc = 'Y' THEN
      IF l_sfv.sfv09 > l_qty_FQC THEN
          LET g_errno='asf-675'
          RETURN l_sfv.*
      END IF
   ELSE
   ##-------------
      IF g_argv MATCHES '[12]' THEN   #入庫,退回
         SELECT sfb08,sfb09 INTO l_sfb08,l_sfv09 FROM sfb_file
          WHERE sfb01 = l_sfv.sfv11
         IF l_sfv09 IS NULL THEN LET l_sfv09 = 0 END IF
         IF l_sfb08 IS NULL THEN LET l_sfb08 = 0 END IF
         IF g_argv = '2' THEN   #退庫時不可大於入庫數量
            IF l_sfv.sfv09 > l_sfv09 THEN
               LET g_errno='asf-712'
               RETURN l_sfv.*
            END IF
         END IF
      END IF
 
      #CHI-8B0002
      SELECT SUM(sfv09) INTO tmp_qty FROM sfv_file,sfu_file
       WHERE sfv11 = l_sfv.sfv11
         AND sfv01 = sfu01
         AND sfu00 = '1'   #類別 1.入庫  2.入庫退回
        #----------No.MOD-810123 modify
        #AND sfv01 <> l_sfv.sfv03 
         AND (sfv01 != l_sfu.sfu01 OR 
             (sfv01 = l_sfu.sfu01 AND sfv03 != l_sfv.sfv03))
        #----------No.MOD-810123 end
         AND sfuconf <> 'X' #FUN-660137
      
      IF tmp_qty IS NULL OR SQLCA.sqlcode THEN LET tmp_qty=0 END IF #FUN-840012
 
     #工單完工方式不為'2' pull
      IF g_argv = '1' AND l_sfv.sfv09 > 0  AND
         g_sfb.sfb39 <> '2' THEN
       # check 入庫數量 不可 大於 (生產數量-完工數量)
        #不走製程且也不做FQC
         IF g_sfb.sfb93!='Y' AND g_sfb.sfb94 !='Y' THEN
            IF (l_sfv.sfv09 > l_sfb08 - l_sfv09 + g_over_qty ) THEN
               LET g_errno='asf-714'
               RETURN l_sfv.*
            END IF
            # sma73    工單完工數量是否檢查發料最小套數
            # sma74    工單完工量容許差異百分比
            # sum(已存在入庫單入庫數量) by W/O (不管有無過帳)
            
            #入庫量不可大於最小套數-以keyin 入庫量
            IF g_sma.sma73='Y' AND (l_sfv.sfv09) > (g_min_set-tmp_qty) THEN  #CHI-8B0002
           #IF g_sma.sma73='Y' AND (l_sfv.sfv09) > (g_min_set) THEN #CHI-8B0002 mark
               LET g_errno='asf-675'
               RETURN l_sfv.*
            END IF
         END IF
 
        #-----------No.MOD-830141 modify
        #走製程但不做FQC
        #IF g_sfb.sfb93='Y' THEN # 走製程 check 轉出量
         IF g_sfb.sfb93='Y' AND g_sfb.sfb94 != 'Y' THEN 
            # 取最終製程之總轉出量(良品轉出量+Bonus)
            CALL s_schdat_max_ecm03(l_sfv.sfv11) RETURNING l_ecm012 ,l_ecm03   #FUN-A60081 
            SELECT ecm311,ecm315 INTO l_ecm311,l_ecm315
              FROM ecm_file
             WHERE ecm01=l_sfv.sfv11
              #AND ecm03= (SELECT MAX(ecm03) FROM ecm_file   #FUN-A60081 mark
              #             WHERE ecm01=l_sfv.sfv11)         #FUN-A60081 mark
               AND ecm03 = l_ecm03 AND ecm012 = l_ecm012     #FUN-A60081
            IF STATUS THEN LET l_ecm311=0 END IF
            IF STATUS THEN LET l_ecm315=0 END IF
           
            LET l_ecm_out=l_ecm311 + l_ecm315
 
            IF l_sfv.sfv09 > l_ecm_out - tmp_qty THEN
               LET g_errno='asf-675'
               RETURN l_sfv.*
            END IF
            IF g_sma.sma73='Y' AND (l_sfv.sfv09) > (g_min_set+l_ecm315-tmp_qty) THEN
               LET g_errno='asf-675'
               RETURN l_sfv.*
            END IF
         END IF
 
         IF g_sfb.sfb94 = 'Y' AND g_sma.sma896 = 'Y' THEN
            SELECT qcf091 INTO l_qcf091 FROM qcf_file   
               WHERE qcf01 = l_sfv.sfv17
                 AND qcf09 <> '2'   
                 AND qcf14 = 'Y'
            IF STATUS OR l_qcf091 IS NULL THEN
               LET l_qcf091 = 0
            END IF
            LET l_fqc_qty = 0 
            SELECT SUM(sfv09) INTO l_fqc_qty FROM sfv_file,sfu_file
             WHERE sfv17 = l_sfv.sfv17
               AND sfv01 = sfu01
               AND sfu00 = '1'   #類別 1.入庫  2.入庫退回
               AND (sfv01 != l_sfu.sfu01 OR 
                   (sfv01 = l_sfu.sfu01 AND sfv03 != l_sfv.sfv03))
               AND sfuconf <> 'X'
            
            IF l_fqc_qty IS NULL OR SQLCA.sqlcode THEN LET l_fqc_qty=0 END IF
         END IF
 
         #No.B492
         #IF g_sfb.sfb94='Y' AND #是否使用FQC功能
         IF g_sfb.sfb94='Y' AND g_sma.sma896='Y' AND
            (l_sfv.sfv09) > l_qcf091 - l_fqc_qty
            THEN
            #----FQC No.不為null,入庫量不可大於FQC量-以keyin 入庫量
            LET g_errno='asf-675'
            RETURN l_sfv.*
         END IF
      END IF
     #No:7834      工單完工方式為'2' pull(sfb39='2')&走製程(sfb93='Y')
      IF g_argv = '1' AND l_sfv.sfv09 > 0  AND
         g_sfb.sfb39= '2' THEN
        #check 最終製程之總轉出量(良品轉出量+Bonus)
         CALL s_schdat_max_ecm03(l_sfv.sfv11) RETURNING l_ecm012,l_ecm03    #FUN-A60081
         SELECT ecm311,ecm315 INTO l_ecm311,l_ecm315 FROM ecm_file
          WHERE ecm01=l_sfv.sfv11
           #AND sgm03= (SELECT MAX(ecm03) FROM ecm_file
           #AND ecm03= (SELECT MAX(ecm03) FROM ecm_file  #FUN-A60081  mark
           #             WHERE ecm01=l_sfv.sfv11)        #FUN-A60081  mark
            AND ecm012 = l_ecm012 AND ecm03 = l_ecm03    #FUN-A60081  
         IF SQLCA.sqlcode THEN
            LET l_ecm311=0
            LET l_ecm315=0
         END IF
         LET l_ecm_out=l_ecm311 + l_ecm315
 
        #---------------------------No.TQC-750208 modify
        #LET l_sfv09=0     #已key之入庫量(不分是否已過帳)
        #SELECT SUM(sfv09) INTO l_sfv09 FROM sfv_file,sfu_file
        # WHERE sfv11 = l_sfv.sfv11
        #  #AND sfv01 ! = l_sfu.sfu01    #No.MOD-660106 mark
        #   AND sfv01 = sfu01
        #   AND sfu00 = '1'           #完工入庫
        #   AND sfupost <> 'X'
        #IF l_sfv09 IS NULL THEN LET l_sfv09 =0 END IF
 
        #IF p_cmd = 'a' THEN
        #   LET l_sfv09 = l_sfv09 + l_sfv.sfv09
        #END IF
 
         LET l_sfv09=0     #已key之入庫量(不分是否已過帳)
         SELECT SUM(sfv09) INTO l_qty1 FROM sfv_file,sfu_file
          WHERE sfv11 = l_sfv.sfv11
            AND sfv01 ! = l_sfu.sfu01  
            AND sfv01 = sfu01
            AND sfu00 = '1'           #完工入庫
            AND sfupost <> 'X'
         IF l_qty1 IS NULL THEN LET l_qty1 =0 END IF
 
         SELECT SUM(sfv09) INTO l_qty2 FROM sfv_file,sfu_file
          WHERE sfv11 = l_sfv.sfv11
            AND sfv01 = l_sfu.sfu01   
            AND sfv03!= l_sfv.sfv03
            AND sfv01 = sfu01
            AND sfu00 = '1'           #完工入庫
            AND sfupost <> 'X'
         IF l_qty2 IS NULL THEN LET l_qty2 =0 END IF
 
         LET l_sfv09 = l_qty1 + l_qty2 + l_sfv.sfv09
 
         IF g_sfb.sfb93 = 'Y' THEN
            #入庫量 > 製程最後轉出量
            IF l_sfv09 > l_ecm_out THEN
              #LET g_msg ="(",l_sfv09   USING '######.###','>',
              #           l_ecm_out USING '######.###',")"
               LET g_errno='asf-675'
               RETURN l_sfv.*
            END IF
         ELSE
            #IF l_sfv09 > l_sfb08 THEN
            #   LET g_msg ="(",l_sfv09   USING '######.###','>',
            #              l_sfb08 USING '######.###',")"
           
            IF g_sma.sma73 ='Y' AND
              (l_sfv09 > l_sfb08 * (100+g_sma.sma74) / 100) THEN
              #LET g_msg ="(",l_sfv09   USING '######.###','>',
              #           (l_sfb08*(100+g_sma.sma74)/100) USING '######.###',")"
               LET g_errno='asf-675'
               RETURN l_sfv.*
            END IF
         END IF
      END IF
##
      IF g_argv = '2' AND l_sfv.sfv09 > 0  AND
         l_sfv.sfv09> g_sfb.sfb09
      THEN
         #----退回量不可大於完工入庫量
         LET g_errno='asf-712'
         RETURN l_sfv.*
      END IF
   END IF #--->聯產品END
   
   #FUN-840012
   ##str TQC-740263 add
   ##當入庫單是由asft300生產報工產生的,在修改單身的入庫數量時要檢查
   ##與報工單身的良品數應一致,兩邊若不match則顯示訊息
   #LET l_cnt = 0
   #SELECT COUNT(*) INTO l_cnt FROM srg_file 
   # WHERE srg11=l_sfu.sfu01 AND srg14=l_sfv.sfv04
   #IF l_cnt != 0 THEN
   #   SELECT srg05 INTO l_srg05 FROM srg_file 
   #    WHERE srg11=l_sfu.sfu01 AND srg14=l_sfv.sfv04
   #   IF l_sfv.sfv09 > l_srg05 THEN
   #      CALL cl_err(l_sfv.sfv09,'asr-033',1)
   #      NEXT FIELD sfv09
   #   END IF
   #   IF l_sfv.sfv09 < l_srg05 THEN
   #      CALL cl_err(l_sfv.sfv09,'asr-050',0)
   #   END IF
   #END IF
   ##end TQC-740263 add
   ##FUN-640041...............begin
   #IF (NOT cl_null(l_sfv.sfv09)) AND (g_argv='3') THEN
   #   IF cl_null(l_sfv.sfv03) THEN
   #      NEXT FIELD sfv03
   #   END IF
   #   IF NOT t620_asrchk_sfv09(l_sfv.sfv17,
   #                            l_sfv.sfv14,
   #                            l_sfv.sfv09) THEN
   #      NEXT FIELD sfv17
   #   END IF
   #END IF
   ##FUN-640041...............end
           
  RETURN l_sfv.*
END FUNCTION
 
FUNCTION aws_create_wostockin_check_sfv05(p_cmd,l_sfu,l_sfv)
  DEFINE p_cmd LIKE type_file.chr1
  DEFINE l_sfu RECORD LIKE sfu_file.*
  DEFINE l_sfv RECORD LIKE sfv_file.*
  DEFINE l_cnt LIKE type_file.num5
  DEFINE l_img LIKE img_file.img09
  DEFINE l_factor LIKE type_file.num5
  DEFINE l_ima55 LIKE ima_file.ima55
  DEFINE l_img09 LIKE img_file.img09
 
  IF NOT cl_null(l_sfv.sfv05) THEN
     IF g_argv MATCHES '[123]' THEN 
        LET l_cnt=0
        SELECT count(*) INTO l_cnt FROM imd_file
         WHERE imd01=l_sfv.sfv05 AND imd10='S'
            AND imdacti = 'Y'
        IF l_cnt=0 THEN
           LET g_errno='mfg1100'
           RETURN l_sfv.*
        END IF
     END IF
  ELSE
     LET g_errno='aqc-711'
     RETURN l_sfv.*
  END IF
 
  IF g_argv MATCHES '[123]' THEN
     IF cl_null(l_sfv.sfv06) THEN
        LET l_sfv.sfv06 = ' '
     END IF
     #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
     IF NOT s_chksmz(l_sfv.sfv04, l_sfu.sfu01,
                     l_sfv.sfv05, l_sfv.sfv06) THEN
        LET g_errno='ams-004'
        RETURN l_sfv.*
     END IF
     #-------------------------------------
  END IF
  
  IF g_argv MATCHES '[123]' THEN
     IF cl_null(l_sfv.sfv07) THEN
        LET l_sfv.sfv07 = ' '
     END IF
     IF NOT cl_null(l_sfv.sfv05) THEN
       
       #IF NOT t620_add_img(l_sfv.sfv04,l_sfv.sfv05,
       #                    l_sfv.sfv06,l_sfv.sfv07,
       #                    l_sfu.sfu01,      l_sfv.sfv03,
       #                    g_today) THEN
       #
       #   NEXT FIELD sfv05
       #END IF
       SELECT img09 INTO l_img09 FROM img_file
        WHERE img01=l_sfv.sfv04 AND img02=l_sfv.sfv05
          AND img03=l_sfv.sfv06 AND img04=l_sfv.sfv07
       IF SQLCA.sqlcode THEN
          LET g_errno='asf-507'
          RETURN l_sfv.*
       END IF
       #FUN-540055  --begin
       IF g_sma.sma115 ='N' THEN
          IF cl_null(l_sfv.sfv08) THEN   #若單位空白
             LET l_sfv.sfv08=l_img09
             #DISPLAY BY NAME l_sfv.sfv08 #MOD-4A0260
          END IF
       ELSE
          SELECT COUNT(*) INTO l_cnt FROM img_file
           WHERE img01 = l_sfv.sfv04   #料號
             AND img02 = l_sfv.sfv05   #倉庫
             AND img03 = l_sfv.sfv06   #儲位
             AND img04 = l_sfv.sfv07   #批號
             AND img18 < l_sfu.sfu02   #調撥日期
          IF l_cnt > 0 THEN    #大於有效日期
             LET g_errno='aim-400'
             RETURN l_sfv.*
          END IF
       
         #FUN-550085 - FQC入庫不做雙單位處理
          IF cl_null(l_sfv.sfv17) OR (g_argv='3') THEN
             CALL aws_create_wostockin_du_default(p_cmd,l_sfv.*)
          ELSE
             SELECT ima55 INTO l_ima55 FROM ima_file
              WHERE ima01 = l_sfv.sfv04          
             CALL s_du_umfchk(l_sfv.sfv04,'','','',
                              l_ima55,l_sfv.sfv30,'1')
                  RETURNING g_errno,l_factor
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(l_sfv.sfv30,g_errno,1)
                RETURN l_sfv.*
             END IF
             LET l_sfv.sfv31 = l_factor
            #DISPLAY BY NAME l_sfv.sfv31
          END IF
       END IF
     END IF
  END IF  
           
  RETURN l_sfv.*
END FUNCTION
 
 
 
