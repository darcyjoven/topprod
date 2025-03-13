# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_purchase_stock_in.4gl
# Descriptions...: 提供建立收貨入庫單資料的服務
# Date & Author..: 2008/04/08 by kim (FUN-840012)
# Memo...........:
#
#}
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A60009 10/10/25 By Lilan 變更傳入的參數順序與個數

 
DATABASE ds
 
#FUN-840012
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
 
#[
# Description....: 提供建立收貨入庫單資料的服務(入口 function)
# Date & Author..: 2008/04/08 by kim
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_purchase_stock_in()
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
 
    #--------------------------------------------------------------------------#
    # 新增收貨入庫單資料                                                       #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_purchase_stock_in_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
FUNCTION aws_create_purchase_stock_in_process()
    CALL aws_create_purchase_stock_process('1')
END FUNCTION
 
#[
# Description....: 依據傳入資訊新增 ERP 收貨入庫/驗退/倉退單資料
# Date & Author..: 2008/04/08 by kim
# Parameter......: p_rvu00 - '1':入庫 ; '2':驗退 ;'3':倉退
# Return.........: 收貨入庫單號
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_purchase_stock_process(p_rvu00)
    DEFINE p_rvu00    LIKE rvu_file.rvu00
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
                         rvu01   LIKE rvu_file.rvu01   #回傳的欄位名稱
                      END RECORD
    DEFINE l_rvu      RECORD LIKE rvu_file.*
    DEFINE l_rvv      RECORD LIKE rvv_file.*
    DEFINE l_chr      LIKE type_file.chr1
    DEFINE l_status   LIKE type_file.chr1
    DEFINE l_cmd      STRING
    DEFINE l_prog     STRING
 
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的收貨入庫單資料                                    #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("rvu_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
 
    SELECT * INTO g_sma.*
      FROM sma_file
     WHERE sma00='0'
 
    SELECT * INTO g_qcz.* FROM qcz_file WHERE qcz00 ='0'
 
    BEGIN WORK
 
    FOR l_i = 1 TO l_cnt1
        INITIALIZE l_rvu.* TO NULL
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "rvu_file")        #目前處理單檔的 XML 節點
        LET l_status = aws_ttsrv_getParameter("status")
 
        LET l_rvu.rvu00 = p_rvu00
        LET l_rvu.rvu01 = aws_ttsrv_getRecordField(l_node1, "rvu01")         #取得此筆單檔資料的欄位值
        LET l_rvu.rvu02 = aws_ttsrv_getRecordField(l_node1, "rvu02")         #收貨單號
        LET l_rvu.rvu03 = aws_ttsrv_getRecordField(l_node1, "rvu03")         #單據日期
        LET l_rvu.rvu04 = aws_ttsrv_getRecordField(l_node1, "rvu04")         #廠商
 
        #----------------------------------------------------------------------#
        # 檢查單據日期                                                         #
        #----------------------------------------------------------------------#
        CALL aws_create_purchase_stock_check_rvu03(l_rvu.*)
        IF NOT cl_null(g_errno) THEN
           LET g_status.code = g_errno
           EXIT FOR
        END IF
 
        #----------------------------------------------------------------------#
        # 收貨入庫單自動取號                                                   #
        #----------------------------------------------------------------------#
        CASE WHEN l_rvu.rvu00 ='1' LET l_chr='7' #入庫
             WHEN l_rvu.rvu00 ='2' LET l_chr='4' #驗退
             WHEN l_rvu.rvu00 ='3' LET l_chr='4' #倉退
        END CASE
        CALL s_check_no("APM",l_rvu.rvu01,"",l_chr,"rvu_file","rvu01","")
          RETURNING l_flag,l_rvu.rvu01
        IF NOT l_flag THEN
           LET g_status.code = "apm-920"   #收貨入庫單自動取號失敗
           EXIT FOR
        END IF
 
        CALL s_auto_assign_no("APM",l_rvu.rvu01,l_rvu.rvu03,l_chr,"rvu_file","rvu01","","","")
             RETURNING l_flag, l_rvu.rvu01
        IF NOT l_flag THEN
           LET g_status.code = "apm-920"   #收貨入庫單自動取號失敗
           EXIT FOR
        END IF
 
        #------------------------------------------------------------------#
        # 設定收貨入庫單頭預設值                                           #
        #------------------------------------------------------------------#
        CALL aws_create_purchase_stock_set_rvu(l_rvu.*) RETURNING l_rvu.*
        IF NOT cl_null(g_errno) THEN
           LET g_status.code = g_errno
           EXIT FOR
        END IF
 
       #CALL aws_ttsrv_setRecordField(l_node1, "rvu01", l_rvu.rvu01)   #更新 XML 取號完成後的收貨入庫單單號欄位(rvu01)
 
       #IF NOT aws_create_purchase_stock_in_default(l_node1) THEN     #檢查收貨入庫單欄位預設值
       #   EXIT FOR
       #END IF
 
        #------------------------------------------------------------------#
        # RECORD資料傳到NODE                                               #
        #------------------------------------------------------------------#
        CALL aws_ttsrv_setRecordField_record(l_node1,base.Typeinfo.create(l_rvu))
 
        LET l_sql = aws_ttsrv_getRecordSql(l_node1, "rvu_file", "I", NULL)   #I 表示取得 INSERT SQL
 
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
        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "rvv_file")       #取得目前單頭共有幾筆單身資料
        IF l_cnt2 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           EXIT FOR
        END IF
 
        CALL cl_flow_notify(l_rvu.rvu01,'I')  #新增資料到 p_flow
 
        FOR l_j = 1 TO l_cnt2
            INITIALIZE l_rvv.* TO NULL
            LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "rvv_file")   #目前單身的 XML 節點
 
            #------------------------------------------------------------------#
            # NODE資料傳到RECORD                                               #
            #------------------------------------------------------------------#
            LET l_rvv.rvv01=l_rvu.rvu01
            LET l_rvv.rvv02=l_j
            LET l_rvv.rvv04 = aws_ttsrv_getRecordField(l_node2, "rvv04")
            LET l_rvv.rvv05 = aws_ttsrv_getRecordField(l_node2, "rvv05")
            LET l_rvv.rvv17 = aws_ttsrv_getRecordField(l_node2, "rvv17")
            LET l_rvv.rvv31 = aws_ttsrv_getRecordField(l_node2, "rvv31")
            LET l_rvv.rvv32 = aws_ttsrv_getRecordField(l_node2, "rvv32")
            LET l_rvv.rvv33 = aws_ttsrv_getRecordField(l_node2, "rvv33")
            LET l_rvv.rvv34 = aws_ttsrv_getRecordField(l_node2, "rvv34")
 
 
            #------------------------------------------------------------------#
            # 設定欄位預設值                                                   #
            #------------------------------------------------------------------#
           #CALL aws_create_purchase_stock_set_rvv_def(l_rvu.*,l_rvv.*)
           #     RETURNING l_rvv.*
 
 
            #------------------------------------------------------------------#
            # 欄位檢查+設定欄位預設值                                          #
            #------------------------------------------------------------------#
            CALL aws_create_purchase_stock_check_rvv(l_rvu.*,l_rvv.*)
                 RETURNING l_rvv.*
            IF NOT cl_null(g_errno) THEN
               LET g_status.code=g_errno
               EXIT FOR
            END IF
 
 
            #------------------------------------------------------------------#
            # 新增前最後檢查                                                   #
            #------------------------------------------------------------------#
            CALL aws_create_purchase_stock_bef_ins_rvv(l_rvu.*,l_rvv.*)
                 RETURNING l_rvv.*
            IF NOT cl_null(g_errno) THEN
               LET g_status.code=g_errno
               EXIT FOR
            END IF
            
            #------------------------------------------------------------------#
            # RECORD資料傳到NODE2                                              #
            #------------------------------------------------------------------#
            CALL aws_ttsrv_setRecordField_record(l_node2,base.Typeinfo.create(l_rvv))
 
            IF cl_null(l_rvv.rvv32) THEN 
               LET l_rvv.rvv32=" "
               CALL aws_ttsrv_setRecordField(l_node2, "rvv32", " ")
            END IF
            IF cl_null(l_rvv.rvv33) THEN 
               LET l_rvv.rvv33=" "
               CALL aws_ttsrv_setRecordField(l_node2, "rvv33", " ")
            END IF
            IF cl_null(l_rvv.rvv34) THEN 
               LET l_rvv.rvv34=" "
               CALL aws_ttsrv_setRecordField(l_node2, "rvv34", " ")
            END IF
 
            LET l_sql = aws_ttsrv_getRecordSql(l_node2, "rvv_file", "I", NULL) #I 表示取得 INSERT SQL
 
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
 
    #全部處理都成功才 COMMIT WORK
    IF g_status.code = "0" THEN
       LET l_return.rvu01 = l_rvu.rvu01
      #CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳 ERP 建立的收貨入庫單單號
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
    IF (l_status='Y') AND (g_status.code = "0") THEN
       LET l_cmd=NULL
       CASE l_rvu.rvu00
          WHEN "1"  #1:入庫
             CASE l_rvu.rvu08
                WHEN "SUB"
                   LET l_prog="apmt730"
                WHEN "TAP"
                   LET l_prog="apmt740"
                OTHERWISE
                   LET l_prog="apmt720"
             END CASE
          WHEN "2"  #2:驗退
             CASE l_rvu.rvu08
                WHEN "SUB"
                   LET l_prog="apmt731"
                WHEN "TAP"
                   LET l_prog="apmt741"
                OTHERWISE
                   LET l_prog="apmt721"
             END CASE
          WHEN "3"  #3:倉退
             CASE l_rvu.rvu08
                WHEN "SUB"
                   LET l_prog="apmt732"
                WHEN "TAP"
                   LET l_prog="apmt742"
                OTHERWISE
                   LET l_prog="apmt722"
             END CASE
       END CASE
      #LET l_cmd=l_prog," '",l_rvu.rvu01 CLIPPED,"' ' ' '6'"     #FUN-A60009 mark
       LET l_cmd=l_prog," '",l_rvu.rvu01 CLIPPED,"' '' '' '6'"   #FUN-A60009 add       
       CALL cl_cmdrun_wait(l_cmd)
       CALL aws_ttsrv_cmdrun_checkStatus(l_prog)
    END IF
    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳自動取號結果
END FUNCTION
 
#[
# Description....: 收貨入庫單設定欄位預設值
# Date & Author..: 2008/04/07 by kim
# Parameter......: l_rvu - 收貨單單頭
# Return.........: l_rvu - 收貨單單頭
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_purchase_stock_set_rvu(l_rvu)
    DEFINE l_rvu RECORD LIKE rvu_file.*
 
    LET g_errno=NULL
    #--------------------------------------------------------------------------#
    # 設定收貨入庫單單頭欄位預設值                                             #
    #--------------------------------------------------------------------------#
    IF cl_null(l_rvu.rvu03) OR l_rvu.rvu03=0 THEN
       LET l_rvu.rvu03  = g_today
    END IF
    LET l_rvu.rvu07   = g_user
    LET l_rvu.rvu06   = g_grup
    LET l_rvu.rvu08   = 'REG'
    LET l_rvu.rvu10   = 'N'
    LET l_rvu.rvu20   = 'N'     #三角貿易拋轉否 no.4475
    LET l_rvu.rvuconf = 'N'
    LET l_rvu.rvuuser = g_user
    LET g_data_plant = g_plant #FUN-980030
    LET l_rvu.rvugrup = g_grup
    LET l_rvu.rvudate = g_today
    LET l_rvu.rvuacti = 'Y'
    RETURN l_rvu.*
END FUNCTION
 
 
#[
# Description....: 設定單身預設值
# Date & Author..: 2008/04/07 by kim
# Parameter......: l_rvv - 收貨單身
# Return.........:
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_purchase_stock_set_rvv_def(l_rvu,l_rvv)
  DEFINE l_rvu    RECORD LIKE rvu_file.*
  DEFINE l_rvv    RECORD LIKE rvv_file.*
  DEFINE l_ima491 LIKE ima_file.ima491
  DEFINE l_gec07  LIKE gec_file.gec07
  DEFINE l_pmn43  LIKE pmn_file.pmn43
 
 
   #--------------------------------------------------------------------------#
   # 設定收貨入庫單單身欄位預設值                                             #
   #--------------------------------------------------------------------------#
   LET l_rvv.rvv03=l_rvu.rvu00     #異動類別
   #LET l_rvv.rvv04=l_rvv.rvv04     #驗收單號
   LET l_rvv.rvv06=l_rvu.rvu04     #廠商單號
   LET l_rvv.rvv09=l_rvu.rvu03     #異動日期
   IF cl_null(l_rvv.rvv23) THEN LET l_rvv.rvv23=0 END IF              #已請款匹配量
   IF cl_null(l_rvv.rvv88) THEN LET l_rvv.rvv88=0 END IF
   IF cl_null(l_rvv.rvv24) THEN LET l_rvv.rvv24='N' END IF            #拋轉保稅系統否
   IF cl_null(l_rvv.rvv35_fac) THEN LET l_rvv.rvv35_fac=1  END IF   #轉換率
   LET l_rvv.rvv17=0
   LET l_rvv.rvv82=0
   LET l_rvv.rvv85=0
   LET l_rvv.rvv87=0
   LET l_rvv.rvv38=0
   LET l_rvv.rvv38t=0
   LET l_rvv.rvv25='N'       #樣品
   LET l_rvv.rvv81=1
   LET l_rvv.rvv84=1         
   SELECT ima02 INTO l_rvv.rvv031
     FROM ima_file
    WHERE ima01=l_rvv.rvv31
   RETURN l_rvv.*
END FUNCTION
 
#[
# Description....: 檢查單身欄位
# Date & Author..: 2008/04/07 by kim
# Parameter......: l_rvu,l_rvv - 收貨單頭/單身
# Return.........: no - use g_errno 判斷檢查是否有誤
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_purchase_stock_check_rvv(l_rvu,l_rvv)
  DEFINE l_rvu    RECORD LIKE rvu_file.*
  DEFINE l_rvv    RECORD LIKE rvv_file.*
 
  LET g_errno=NULL
 
  #--------------------------------------------------------------------------#
  # 將收貨單單身資料帶入收貨入庫單單身                                       #
  #--------------------------------------------------------------------------#
  CALL aws_create_purchase_stock_gen_rvv(l_rvu.*,l_rvv.*) RETURNING l_rvv.*
  IF NOT cl_null(g_errno) THEN
     RETURN l_rvv.*
  END IF
 
  #--------------------------------------------------------------------------#
  # 檢查料件編號                                                             #
  #--------------------------------------------------------------------------#
  CALL aws_create_purchase_stock_check_rvv31(l_rvv.*) RETURNING l_rvv.*
  IF NOT cl_null(g_errno) THEN
     RETURN l_rvv.*
  END IF
 
  #--------------------------------------------------------------------------#
  # 檢查實收數量是否超過                                                     #
  #--------------------------------------------------------------------------#
  CALL aws_create_purchase_stock_check_rvv17(l_rvu.*,l_rvv.*)
     RETURNING l_rvv.*
  IF NOT cl_null(g_errno) THEN
     RETURN l_rvv.*
  END IF
 
  #--------------------------------------------------------------------------#
  # 檢查倉儲批                                                               #
  #--------------------------------------------------------------------------#
  CALL aws_create_purchase_stock_check_rvv32(l_rvu.*,l_rvv.*)
     RETURNING l_rvv.*  
  IF NOT cl_null(g_errno) THEN
     RETURN l_rvv.*
  END IF
  RETURN l_rvv.*
END FUNCTION
 
#[
# Description....: 由採購單單身帶資料進收貨單單身
# Date & Author..: 2008/04/07 by kim
# Parameter......: l_rvu-收貨入庫單頭,l_rvv - 收貨入庫單身
# Return.........: l_rvv-收貨入庫單單身值 ; use g_errno 判斷檢查是否有誤
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_purchase_stock_gen_rvv(p_rvu,p_rvv)
  DEFINE p_rvu      RECORD LIKE rvu_file.*
  DEFINE p_rvv      RECORD LIKE rvv_file.*
  DEFINE l_rvv      RECORD LIKE rvv_file.*
  DEFINE l_rvb331   LIKE rvb_file.rvb331
  DEFINE l_rvb332   LIKE rvb_file.rvb332
  DEFINE l_rvb07    LIKE rvb_file.rvb07 
  DEFINE l_rvb33    LIKE rvb_file.rvb33
  DEFINE l_rvb39    LIKE rvb_file.rvb39
  DEFINE l_rvb40    LIKE rvb_file.rvb40
  DEFINE l_rvb25    LIKE rvb_file.rvb25
  DEFINE l_ima906   LIKE ima_file.ima906
  DEFINE l_rvv82    LIKE rvv_file.rvv82 
  DEFINE l_rvv85    LIKE rvv_file.rvv85 
  DEFINE l_rvv87_o  LIKE rvv_file.rvv87 
  DEFINE l_img09    LIKE img_file.img09 
  DEFINE l_i        LIKE type_file.num5
  DEFINE l_sql      STRING
 
    LET g_errno=NULL
    LET l_sql = "SELECT rvb25,rvb39,rvb40,rvb33,rvb331,rvb332, ",
               "       ' ',' ','1',rvb01,rvb02,' ',' ',",
               "       rvb31,rvb34,0,' ',rvb35,",
               "       ' ',rvb05,ima02,rvb36,rvb37,rvb38,pmn07,",
               "       pmn09,rvb04,rvb03,rvb10,'','','','','', ",
               "       rvb80,rvb81,rvb82,rvb83,rvb84,rvb85,rvb86,rvb87,'',rvb10t,",
               "       rvb930,0,rvb07",
               "  FROM rvb_file,OUTER pmn_file,OUTER ima_file",
               " WHERE rvb01 = '",p_rvv.rvv04 CLIPPED,"'",
               "   AND rvb02 = ",p_rvv.rvv05,
               "   AND rvb_file.rvb04=pmn_file.pmn01 ",
               "   AND rvb_file.rvb03=pmn_file.pmn02 ",
               "   AND rvb_file.rvb05=ima_file.ima01 "
    DECLARE gen_rvv_cur CURSOR FROM l_sql
    OPEN gen_rvv_cur
    FETCH gen_rvv_cur INTO l_rvb25,l_rvb39,l_rvb40,l_rvb33,l_rvb331,l_rvb332,l_rvv.*,l_rvb07
    IF STATUS THEN LET g_errno=STATUS RETURN l_rvv.* END IF
    CLOSE gen_rvv_cur
        
    LET l_rvv.rvv17 = p_rvv.rvv17
    LET l_rvv.rvv31 = p_rvv.rvv31
    LET l_rvv.rvv32 = p_rvv.rvv32
    LET l_rvv.rvv33 = p_rvv.rvv33
    LET l_rvv.rvv34 = p_rvv.rvv34
 
    LET l_rvv87_o = l_rvv.rvv87
    SELECT max(rvv02)+1 INTO l_rvv.rvv02 FROM rvv_file
     WHERE rvv01 = p_rvu.rvu01
    IF l_rvv.rvv02 IS NULL THEN LET l_rvv.rvv02 = 1 END IF
    LET l_rvv.rvv01=p_rvu.rvu01
    LET l_rvv.rvv09=p_rvu.rvu03
    LET l_rvv.rvv06=p_rvu.rvu04     #廠商單號
    IF l_rvv.rvv31[1,4]='MISC' THEN
       SELECT pmn041 INTO l_rvv.rvv031 FROM pmn_file
        WHERE pmn01=l_rvv.rvv36 AND pmn02=l_rvv.rvv37
    END IF
    IF NOT cl_null(l_rvv.rvv32) THEN
       SELECT img09 INTO l_img09 FROM img_file
           WHERE img01 = l_rvv.rvv31
             AND img02 = l_rvv.rvv32
             AND img03 = l_rvv.rvv33
             AND img04 = l_rvv.rvv34
       CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv35,l_img09)
           RETURNING l_i,l_rvv.rvv35_fac
       IF l_i = 1 THEN
          CALL cl_err('rvv35/img09: ','abm-731',1)
          RETURN
       END IF
    END IF
    IF l_rvb39 = 'Y' THEN          #-->檢驗
       IF NOT cl_null(l_rvb33) AND l_rvb33 > 0 THEN
         IF l_rvv.rvv17 > l_rvb33 THEN
            LET l_rvv.rvv17=l_rvb33
         END IF
       END IF
    END IF
    LET l_ima906 = NULL
    SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=l_rvv.rvv31
    IF (g_sma.sma115 = 'Y') AND (l_ima906 MATCHES '[2,3]') THEN
       SELECT SUM(rvv82),SUM(rvv85) 
             INTO l_rvv82,l_rvv85 
             FROM rvu_file,rvv_file 
            WHERE rvu01=rvv01 
              AND rvuconf<>'X'
              AND rvuacti='Y'
              AND rvv04=p_rvu.rvu02
              AND rvv05=l_rvv.rvv05
              AND rvv82 IS NOT NULL
              AND rvv85 IS NOT NULL
 
       IF cl_null(l_rvv82) THEN
          LET l_rvv82=0
       END IF
       IF cl_null(l_rvv85) THEN
          LET l_rvv85=0
       END IF
       LET l_rvv.rvv82=l_rvb331-l_rvv82
       LET l_rvv.rvv85=l_rvb332-l_rvv85
       IF l_rvv.rvv82<0 THEN
          LET l_rvv.rvv82=0
       END IF
       IF l_rvv.rvv85<0 THEN
          LET l_rvv.rvv85=0
       END IF
    END IF
    CALL aws_create_purchase_stock_set_rvv87(l_rvv.*) RETURNING l_rvv.*
    IF g_sma.sma116 MATCHES '[02]' THEN
       LET l_rvv.rvv87 = l_rvv.rvv17
    END IF
    IF cl_null(l_rvb07) THEN LET l_rvb07=0 END IF
    IF l_rvv.rvv17= l_rvb07 THEN
       LET l_rvv.rvv87 = l_rvv87_o
    END IF 
    IF cl_null(l_rvv.rvv32) THEN
        SELECT ima35,ima36
          INTO l_rvv.rvv32,l_rvv.rvv33
          FROM ima_file
         WHERE ima01 = l_rvv.rvv031
        LET l_rvv.rvv34 = ' '
    END IF
    IF l_rvv.rvv17>0 THEN
       LET l_rvv.rvv39=l_rvv.rvv17*l_rvv.rvv38
       LET l_rvv.rvv39t=l_rvv.rvv17*l_rvv.rvv38t
            #No.+090 010430 add by linda 依幣別四捨五入
            LET t_azi04=''    #No.CHI-6A0004
            SELECT azi04 INTO t_azi04
              FROM pmm_file,azi_file
             WHERE pmm22=azi01
               AND pmm01 = l_rvv.rvv36 AND pmm18 <> 'X'
            IF cl_null(t_azi04) THEN LET t_azi04=0 END IF
            CALL cl_digcut(l_rvv.rvv39,t_azi04)
                              RETURNING l_rvv.rvv39
            CALL cl_digcut(l_rvv.rvv39t,t_azi04)
                              RETURNING l_rvv.rvv39t
            CALL aws_create_purchase_stock_get_rvv39(l_rvv.rvv36,l_rvv.rvv39,l_rvv.rvv39t)  
                 RETURNING l_rvv.rvv39,l_rvv.rvv39t
    END IF
    #計價數量計算
    IF l_rvv.rvv17>0 THEN
       LET l_rvv.rvv39=l_rvv.rvv87*l_rvv.rvv38
       LET l_rvv.rvv39t=l_rvv.rvv87*l_rvv.rvv38t
            #依幣別四捨五入
            LET t_azi04=''
            SELECT azi04 INTO t_azi04
              FROM pmm_file,azi_file
             WHERE pmm22=azi01
               AND pmm01 = l_rvv.rvv36 AND pmm18 <> 'X'
            IF cl_null(t_azi04) THEN LET t_azi04=0 END IF
            CALL cl_digcut(l_rvv.rvv39,t_azi04)
                              RETURNING l_rvv.rvv39
            CALL cl_digcut(l_rvv.rvv39t,t_azi04)
                              RETURNING l_rvv.rvv39t
            CALL aws_create_purchase_stock_get_rvv39(l_rvv.rvv36,l_rvv.rvv39,l_rvv.rvv39t)  
                 RETURNING l_rvv.rvv39,l_rvv.rvv39t
    END IF
    LET l_rvv.rvv40 = 'N'            #no.5748(default非沖暫估)
    LET l_rvv.rvv41 = l_rvb25        #no.A050(add 手冊編號)
    IF cl_null(l_rvv.rvv32) THEN LET l_rvv.rvv32=' ' END IF
    IF cl_null(l_rvv.rvv33) THEN LET l_rvv.rvv33=' ' END IF
    IF cl_null(l_rvv.rvv34) THEN LET l_rvv.rvv34=' ' END IF
    IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02 = 1 END IF
    LET l_rvv.rvv88 = 0
 
    RETURN l_rvv.*
END FUNCTION
 
#[
# Description....: 檢查實收數量正確性,並計算帶入相關欄位值
# Date & Author..: 2008/04/07 by kim
# Parameter......: p_cmd-固定傳'a'新增,l_rvu-收貨單頭,l_rvv - 收貨單身
# Return.........: l_rvv-收貨單單身值 ; use g_errno 用來判斷是否檢查有誤
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_purchase_stock_check_rvv17(l_rvu,l_rvv)
   DEFINE l_rvu       RECORD LIKE rvu_file.*
   DEFINE l_rvv       RECORD LIKE rvv_file.*
   DEFINE l_rvb07     LIKE rvb_file.rvb07
   DEFINE l_rvb87     LIKE rvb_file.rvb87
   DEFINE l_inqty     LIKE rvb_file.rvb31
   DEFINE l_rvb33     LIKE rvb_file.rvb33
   DEFINE l_rvb30     LIKE rvb_file.rvb30
   DEFINE l_rvb39     LIKE rvb_file.rvb39
   DEFINE l_rvb33_tol     LIKE rvb_file.rvb33
   DEFINE l_rvv17_1_other LIKE rvv_file.rvv17
   DEFINE l_rvv17_2_other LIKE rvv_file.rvv17
   DEFINE l_rvv17_3_other LIKE rvv_file.rvv17
   DEFINE l_rvv17_2       LIKE rvv_file.rvv17
   DEFINE l_rvv17_3       LIKE rvv_file.rvv17
   DEFINE l_rvv17_return  LIKE rvv_file.rvv17
   DEFINE l_qcs091    LIKE qcs_file.qcs091
   DEFINE l_qcs22     LIKE qcs_file.qcs22 
   DEFINE l_okqty     LIKE rvb_file.rvb33
   DEFINE l_rvv39     LIKE rvv_file.rvv39
   DEFINE l_rvv39t    LIKE rvv_file.rvv39t
 
   LET g_errno=NULL
   IF (l_rvu.rvu00 != '3') AND (l_rvv.rvv17 = 0) THEN
      LET g_errno='afa-978'
      RETURN l_rvv.*
   END IF
 
   LET l_rvb07 = 0
   SELECT rvb07,rvb87 INTO l_rvb07,l_rvb87 FROM rvb_file
    WHERE rvb01=l_rvv.rvv04 
      AND rvb02=l_rvv.rvv05
   IF l_rvb07 = l_rvv.rvv17 THEN
      LET l_rvv.rvv87 = l_rvb87 
   END IF
   IF l_rvu.rvu00='1' THEN
      SELECT rvb31,rvb07,rvb87 INTO l_inqty,l_rvb07,l_rvb87 
        FROM rvb_file,rva_file  #由收貨單帶計價數量
       WHERE rvb01=l_rvv.rvv04 AND rvb02=l_rvv.rvv05
         AND rvb01 = rva01
         AND rvaconf !='X' #作廢資料要剔除
      IF l_rvv.rvv17 > l_inqty THEN  #異動數量不可大於可入庫量
         LET g_errno='mfg3252'
         RETURN l_rvv.*
      END IF
   END IF
   ##-入庫數量不可大於允收量
   IF l_rvu.rvu00='1' THEN
      #檢驗碼改單身
      SELECT rvb33,rvb39 INTO l_rvb33,l_rvb39 FROM rvb_file
       WHERE rvb01=l_rvv.rvv04 AND rvb02=l_rvv.rvv05
      IF l_rvb39 = 'Y' THEN
         IF cl_null(l_rvb33) THEN LET l_rvb33 = 0 END IF
         IF (l_rvv.rvv17 > l_rvb33) THEN
            IF g_qcz.qcz05 = 'N' THEN
               LET g_errno='apm-282'
               RETURN l_rvv.*
            END IF
         END IF
      END IF
      #本張單據,其他屬於此收貨項次的入庫數量
        SELECT SUM(rvv17) INTO l_rvv17_1_other FROM rvv_file,rvu_file
         WHERE rvv04=l_rvv.rvv04 AND rvv05=l_rvv.rvv05
           AND rvv03='1'
           AND rvv01 =l_rvu.rvu01
           AND rvv01=rvu01
           AND rvv02 !=l_rvv.rvv02
           AND rvuconf !='X'
       IF cl_null(l_rvv17_1_other) THEN
          LET l_rvv17_1_other=0
       END IF
       LET l_rvv17_1_other = l_rvv17_1_other+ l_rvv.rvv17
       #總允收數量
       SELECT SUM(rvb33) INTO l_rvb33_tol FROM rvb_file
          WHERE rvb01=l_rvv.rvv04 AND rvb02=l_rvv.rvv05
            AND rvb39 = 'Y'
         IF g_qcz.qcz05='Y' THEN
           SELECT SUM(rvv17) INTO l_rvv17_return FROM rvv_file,rvu_file
            WHERE rvv04=l_rvv.rvv04 AND rvv05=l_rvv.rvv05
              AND rvv03='1'
              AND rvv01 =l_rvu.rvu01
              AND rvv01=rvu01
              AND rvv02 !=l_rvv.rvv02
              AND rvuconf !='X'
              AND rvv32 = g_qcz.qcz051
              AND rvv33 = g_qcz.qcz052
           IF cl_null(l_rvv17_return) THEN
              LET l_rvv17_return=0
           END IF
           #加上當筆屬於不合格品入庫部份
           IF l_rvv.rvv32=g_qcz.qcz051 AND 
              l_rvv.rvv33=g_qcz.qcz052  THEN
              LET l_rvv17_return=l_rvv17_return + l_rvv.rvv17
           END IF 
         END IF   
        IF l_rvv17_1_other > (l_rvb33_tol+l_rvv17_return) THEN
          LET g_errno='apm-306'
          RETURN l_rvv.*
       END IF
 
   END IF
   
   #退貨不可大於庫存量
   IF l_rvu.rvu00='3' THEN
      IF NOT cl_null(l_rvv.rvv04) THEN
         SELECT SUM(rvv17) INTO l_rvv17_3 FROM rvv_file,rvu_file
          WHERE rvv04=l_rvv.rvv04 AND rvv05=l_rvv.rvv05
            AND rvv03='3' AND rvv01 !=l_rvu.rvu01 AND rvv01=rvu01
            AND rvuconf !='X'
         IF cl_null(l_rvv17_3) THEN LET l_rvv17_3=0 END IF
         #本張單據,其他屬於此收貨項次的數量
         SELECT SUM(rvv17) INTO l_rvv17_3_other FROM rvv_file,rvu_file
          WHERE rvv04=l_rvv.rvv04 AND rvv05=l_rvv.rvv05
            AND rvv03='3'
            AND rvv01 =l_rvu.rvu01
            AND rvv01=rvu01
            AND rvv02 !=l_rvv.rvv02
            AND rvuconf !='X'
         IF cl_null(l_rvv17_3_other) THEN
            LET l_rvv17_3_other=0
         END IF
         SELECT rvb30 INTO l_inqty FROM rvb_file,rva_file
          WHERE rvb01=l_rvv.rvv04 AND rvb02=l_rvv.rvv05
            AND rvb01=rva01
            AND rvaconf !='X' #作廢資料要剔除 BugNo:3816
         IF cl_null(l_inqty) THEN LET l_inqty=0 END IF
         #異動數量不可大於入庫量-倉退量
         #No.9786
         #IF l_rvv.rvv17 > (l_inqty-l_rvv17_3) THEN
         IF l_rvv.rvv17 > (l_inqty-l_rvv17_3-l_rvv17_3_other ) THEN
            LET g_errno='apm-254'
            RETURN l_rvv.*
         END IF
         #No.9786(end)
      END IF
   END IF
 
   #驗退不可大於(收貨量-已輸入之驗退量)
   IF l_rvu.rvu00='2' THEN
      IF NOT cl_null(l_rvv.rvv04) THEN
         SELECT SUM(rvv17) INTO l_rvv17_2 FROM rvv_file,rvu_file
          WHERE rvv04=l_rvv.rvv04 AND rvv05=l_rvv.rvv05
            AND rvv03='2'
            AND rvv01 !=l_rvu.rvu01
            AND rvv01=rvu01
            AND rvuconf !='X'
        IF cl_null(l_rvv17_2) THEN LET l_rvv17_2=0 END IF
        #本張單據,其他屬於此收貨項次的數量
        SELECT SUM(rvv17) INTO l_rvv17_2_other FROM rvv_file,rvu_file
         WHERE rvv04=l_rvv.rvv04 AND rvv05=l_rvv.rvv05
           AND rvv03='2'
           AND rvv01 =l_rvu.rvu01
           AND rvv01=rvu01
           AND rvv02 !=l_rvv.rvv02
           AND rvuconf !='X'
         IF cl_null(l_rvv17_2_other) THEN
            LET l_rvv17_2_other=0
         END IF
        #修改可驗退數量控管
        #1.若走IQC   可驗退量=SUM(IQC送驗量) - SUM(IQC合格量) - 已驗退量
        #2.若不走IQC 可驗退量=實收數量 - 已入庫量 - 已驗退量
 
         SELECT rvb07,rvb33,rvb30,rvb39 INTO l_inqty,l_okqty,
            l_rvb30,l_rvb39  FROM rvb_file,rva_file 
         WHERE rvb01=l_rvv.rvv04 AND rvb02=l_rvv.rvv05
           AND rvb01=rva01
           AND rvaconf !='X' #作廢資料要剔除 MODNO:3816
 
         IF cl_null(l_inqty) THEN LET l_inqty=0 END IF
         IF cl_null(l_okqty) THEN LET l_okqty=0 END IF
         IF cl_null(l_rvb30) THEN LET l_rvb30=0 END IF
 
         IF l_rvb39 = 'N' THEN
            #IF l_rvv.rvv17 > (l_inqty-l_rvv17_2-l_rvv17_2_other-l_okqty) THEN
            #   #可驗退量應<=收貨量rvb07-允收量rvb33                          
            #   #CALL cl_err(l_rvv.rvv31,'apm-254',1)                         
            #    CALL cl_err(l_rvv.rvv31,'apm-721',1)                         
            #  RETURN l_rvv.*
            #END IF
 
            #不走IQC
             IF l_rvv.rvv17 > (l_inqty-l_rvv17_2-l_rvv17_2_other-l_rvb30) THEN    
                 LET g_errno='apm-730'
               RETURN l_rvv.*
             END IF
          ELSE
            #走IQC
             SELECT SUM(qcs091),SUM(qcs22) INTO l_qcs091,l_qcs22 
                FROM qcs_file WHERE  qcs01 = l_rvv.rvv04
                AND qcs02 = l_rvv.rvv05
                AND qcs14 = 'Y'               #確認否
 
             IF cl_null(l_qcs091) THEN LET l_qcs091 = 0 END IF
             IF cl_null(l_qcs22)  THEN LET l_qcs22 = 0 END IF
 
             IF l_rvv.rvv17 > (l_qcs22-l_rvv17_2-l_rvv17_2_other-l_qcs091) THEN    
                 LET g_errno='apm-730'
               RETURN l_rvv.*
             END IF
         END IF
      END IF
   END IF
   IF l_rvv.rvv17>0 THEN
      LET l_rvv.rvv39=l_rvv.rvv17*l_rvv.rvv38
      LET l_rvv.rvv39t=l_rvv.rvv17*l_rvv.rvv38t
      #依幣別四捨五入
      LET t_azi04=''                           
      SELECT azi04 INTO t_azi04                
        FROM pmm_file,azi_file
       WHERE pmm22=azi01
         AND pmm01 = l_rvv.rvv36 AND pmm18 <> 'X'
      IF cl_null(t_azi04) THEN LET t_azi04=0 END IF
      CALL cl_digcut(l_rvv.rvv39,t_azi04) RETURNING l_rvv.rvv39
      CALL cl_digcut(l_rvv.rvv39t,t_azi04) RETURNING l_rvv.rvv39t 
      CALL aws_create_purchase_stock_get_rvv39(l_rvv.rvv36,l_rvv.rvv39,l_rvv.rvv39t)  
           RETURNING l_rvv.rvv39,l_rvv.rvv39t
   END IF
   IF l_rvv.rvv17 > 0 THEN
      LET l_rvv39=l_rvv.rvv17*l_rvv.rvv38
      LET l_rvv39t=l_rvv.rvv17*l_rvv.rvv38t   #No.FUN-610018
   END IF
   #依幣別四捨五入
   LET t_azi04=''
   SELECT azi04 INTO t_azi04
     FROM pmm_file,azi_file
    WHERE pmm22=azi01
      AND pmm01 = l_rvv.rvv36 AND pmm18 <> 'X'
    IF l_rvv.rvv17 = 0 AND cl_null(t_azi04) THEN
       SELECT azi04 INTO t_azi04
         FROM pmc_file,azi_file
        WHERE pmc22=azi01
          AND pmc01 = l_rvu.rvu04
    END IF  
   IF cl_null(t_azi04) THEN LET t_azi04=0 END IF  #No.CHI-6A0004
   CALL cl_digcut(l_rvv39,t_azi04)  #No.CHI-6A0004
                     RETURNING l_rvv39
   CALL cl_digcut(l_rvv39t,t_azi04) #No.CHI-6A0004
                     RETURNING l_rvv39t   #No.FUN-610018
   CALL aws_create_purchase_stock_get_rvv39(l_rvv.rvv36,l_rvv.rvv39,l_rvv.rvv39t)  
        RETURNING l_rvv.rvv39,l_rvv.rvv39t
   IF g_sma.sma116 MATCHES '[02]' THEN #不使用計價單位時,計價單位/數量給原單據單位/數量
      LET l_rvv.rvv86=l_rvv.rvv35
      LET l_rvv.rvv87=l_rvv.rvv17
   END IF
   CALL aws_create_purchase_stock_set_rvv87(l_rvv.*) RETURNING l_rvv.*
 
   RETURN l_rvv.*
END FUNCTION
 
FUNCTION aws_create_purchase_stock_set_rvv87(l_rvv)
 DEFINE    l_ima25  LIKE ima_file.ima25,     #ima單位
           l_ima44  LIKE ima_file.ima44,     #ima單位
           l_ima906 LIKE ima_file.ima906,
           l_fac2   LIKE img_file.img21,     #第二轉換率
           l_qty2   LIKE img_file.img10,     #第二數量
           l_fac1   LIKE img_file.img21,     #第一轉換率
           l_qty1   LIKE img_file.img10,     #第一數量
           l_tot    LIKE img_file.img10,     #計價數量
           l_factor LIKE ima_file.ima31_fac,
           l_cnt    LIKE type_file.num5
  DEFINE   l_rvv    RECORD LIKE rvv_file.*
  DEFINE   l_pmn07  LIKE pmn_file.pmn07
 
   LET g_errno=NULL
   SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
     FROM ima_file WHERE ima01=l_rvv.rvv05
   IF SQLCA.sqlcode = 100 THEN
      IF l_rvv.rvv05 MATCHES 'MISC*' THEN
         SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
           FROM ima_file WHERE ima01='MISC'
      END IF
   END IF
   IF cl_null(l_ima44) THEN LET l_ima44=l_ima25 END IF
 
   LET l_fac2=l_rvv.rvv84
   LET l_qty2=l_rvv.rvv85
   IF g_sma.sma115 = 'Y' THEN
      LET l_fac1=l_rvv.rvv81
      LET l_qty1=l_rvv.rvv82
   ELSE
      LET l_fac1=1
      LET l_qty1=l_rvv.rvv17
      SELECT pmn07 INTO l_pmn07 FROM pmn_file
       WHERE pmn01=l_rbv.rbv04
         AND pmn02=l_rbv.rbv03
      CALL s_umfchk(l_rvv.rvv05,l_pmn07,l_ima44)
            RETURNING l_cnt,l_fac1
      IF l_cnt = 1 THEN
         LET l_fac1 = 1
      END IF
   END IF
   IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
   IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
   IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
   IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
   IF g_sma.sma115 = 'Y' THEN
      CASE l_ima906
         WHEN '1' LET l_tot=l_qty1*l_fac1
         WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
         WHEN '3' LET l_tot=l_qty1*l_fac1
      END CASE
   ELSE  #不使用雙單位
      LET l_tot=l_qty1*l_fac1
   END IF
   IF cl_null(l_tot) THEN LET l_tot = 0 END IF
   LET l_factor = 1
   CALL s_umfchk(l_rvv.rvv05,l_ima44,l_rvv.rvv86)
         RETURNING l_cnt,l_factor
   IF l_cnt = 1 THEN
      LET l_factor = 1
   END IF
   LET l_tot = l_tot * l_factor
 
   LET l_rvv.rvv87 = l_tot
   RETURN l_rvv.*
END FUNCTION
 
FUNCTION aws_create_purchase_stock_get_rvv39(p_rvv36,p_rvv39,p_rvv39t)
  DEFINE    l_gec07   LIKE gec_file.gec07,     #含稅否
            l_pmm43   LIKE pmm_file.pmm43,     #稅率
            p_rvv36   LIKE rvv_file.rvv36,     #採購單
            p_rvv39   LIKE rvv_file.rvv39,     #未稅金額
            p_rvv39t  LIKE rvv_file.rvv39t     #含稅金額
 
   LET g_errno=NULL
 
   #不使用單價*數量=金額, 改以金額回推稅率, 以避免小數位差的問題
   SELECT gec07,pmm43 INTO l_gec07,l_pmm43 FROM gec_file,pmm_file
    WHERE gec01 = pmm21
      AND pmm01 = p_rvv36
   IF SQLCA.SQLCODE = 100 THEN
      LET g_errno='mfg3192'
      RETURN p_rvv39,p_rvv39t
   END IF
   IF l_gec07='Y' THEN
      LET p_rvv39 = p_rvv39t / ( 1 + l_pmm43/100)
      LET p_rvv39 = cl_digcut(p_rvv39 , t_azi04)  
   ELSE
      LET p_rvv39t = p_rvv39 * ( 1 + l_pmm43/100)
      LET p_rvv39t = cl_digcut( p_rvv39t , t_azi04)  
   END IF
      
   RETURN p_rvv39,p_rvv39t
 
END FUNCTION
 
#檢查料件編號有無存在ima_file & rvb_file
FUNCTION aws_create_purchase_stock_check_rvv31(l_rvv)
   DEFINE l_rvv RECORD LIKE rvv_file.*
   DEFINE l_cnt LIKE type_file.num5
   DEFINE l_ima906 LIKE ima_file.ima906
   DEFINE l_ima907 LIKE ima_file.ima907
   DEFINE l_ima908 LIKE ima_file.ima908
   DEFINE l_flag LIKE type_file.num5
   DEFINE l_ima25 LIKE ima_file.ima25
 
   LET g_errno=NULL
 
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM rvb_file,ima_file
    WHERE rvb01 = l_rvv.rvv04
      AND rvb02 = l_rvv.rvv05
      AND rvb05 = l_rvv.rvv31
      AND ima01 = rvb05
   IF l_cnt=0 THEN
      LET g_errno='apm-921'
      RETURN l_rvv.*
   END IF
   IF g_sma.sma115 = 'Y' THEN
      SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=l_rvv.rvv31
      CALL s_chk_va_setting(l_rvv.rvv31)
           RETURNING l_flag,l_ima906,l_ima907
      IF l_flag=1 THEN
         LET g_errno='atm-263'
         RETURN l_rvv.*
      END IF
      CALL s_chk_va_setting1(l_rvv.rvv31)
           RETURNING l_flag,l_ima908
      IF l_flag=1 THEN
         LET g_errno='atm-263'
         RETURN l_rvv.*
      END IF
      IF l_ima906 = '3' THEN
         LET l_rvv.rvv83=l_ima907
      END IF
      IF g_sma.sma116 MATCHES '[13]' THEN
         IF cl_null(l_rvv.rvv86) THEN
            LET l_rvv.rvv86=l_ima908
         END IF
      END IF
   END IF
   IF g_sma.sma115 = 'Y' THEN
      #單位一
      IF cl_null(l_rvv.rvv80) THEN
          LET l_rvv.rvv80 = l_ima25
      END IF
 
      #單位二
      IF cl_null(l_rvv.rvv83) THEN
          LET l_rvv.rvv83 = l_ima907
      END IF
 
      #計價單位
      IF cl_null(l_rvv.rvv86) THEN
          IF g_sma.sma116 MATCHES '[13]' THEN
              LET l_rvv.rvv86 = l_ima908
          ELSE
              LET l_rvv.rvv86 = l_rvv.rvv80
          END IF
      END IF
   ELSE
      IF cl_null(l_rvv.rvv35) THEN
          LET l_rvv.rvv35=l_ima25
      END IF
   END IF
   IF NOT cl_null(l_rvv.rvv31) AND l_rvv.rvv31[1,4]!='MISC'
      AND cl_null(l_rvv.rvv04) THEN
      SELECT pmh12,pmh19
        INTO l_rvv.rvv38,l_rvv.rvv38t
        FROM pmh_file
       WHERE pmh01 = l_rvv.rvv31 
         AND pmh05 = '0' 
         AND pmh02 = l_rvu.rvu04 
         AND pmhacti = 'Y'
   END IF
 
   RETURN l_rvv.*
END FUNCTION
 
FUNCTION aws_create_purchase_stock_check_rvu03(l_rvu)
   DEFINE l_rvu RECORD LIKE rvu_file.*
   DEFINE l_yy LIKE sma_file.sma51
   DEFINE l_mm LIKE sma_file.sma52
   DEFINE l_rvb40 LIKE rvb_file.rvb40
   DEFINE l_rva06 LIKE rva_file.rva06
   DEFINE l_cnt LIKE type_file.num5
 
   LET g_errno=NULL
   IF NOT cl_null(l_rvu.rvu03) THEN
      IF NOT cl_null(g_sma.sma53) AND l_rvu.rvu03 <= g_sma.sma53 THEN
         LET g_errno='mfg9999' RETURN  #關帳日期
      END IF
      CALL s_yp(l_rvu.rvu03) RETURNING l_yy,l_mm
      IF (l_yy*12+l_mm)>(g_sma.sma51*12+g_sma.sma52)THEN #不可大於現行年月
         LET g_errno='mfg6091' RETURN
      END IF
 
      SELECT rva06 INTO l_rva06 FROM rva_file
       WHERE rva01 = l_rvv.rvv04
      #檢驗否相關資料改抓單身
      SELECT COUNT(*) INTO l_cnt FROM rvb_file
       WHERE rvb01 = l_rvu.rvu01 AND rvb39 = 'Y'
      IF l_cnt > 0 THEN  #表收貨單有須檢驗的料號
         SELECT MAX(rvb40) INTO l_rvb40 FROM rvb_file
          WHERE rvb01 = l_rvu.rvu01 AND rvb39 = 'Y'
         IF l_rvu.rvu03 < l_rvb40 THEN
             #異動日期必須大於檢驗日(rvb43)
             LET g_errno='apm-416'
             RETURN
         END IF
      ELSE
         IF l_rvu.rvu03 < l_rva06 THEN
            #異動日期必須大於收貨日(rva06)
            LET g_errno='apm-417'
            RETURN
         END IF
      END IF
   END IF
END FUNCTION
 
FUNCTION aws_create_purchase_stock_rvv39(p_rvv36,p_rvv39,p_rvv39t)
  DEFINE    l_gec07   LIKE gec_file.gec07,     #含稅否
            l_pmm43   LIKE pmm_file.pmm43,     #稅率
            p_rvv36   LIKE rvv_file.rvv36,     #採購單
            p_rvv39   LIKE rvv_file.rvv39,     #未稅金額
            p_rvv39t  LIKE rvv_file.rvv39t     #含稅金額
   LET g_errno=NULL
   #不使用單價*數量=金額, 改以金額回推稅率, 以避免小數位差的問題
   SELECT gec07,pmm43 INTO l_gec07,l_pmm43 FROM gec_file,pmm_file
    WHERE gec01 = pmm21
      AND pmm01 = p_rvv36
   IF SQLCA.SQLCODE = 100 THEN
      LET g_errno='mfg3192'
   END IF
   IF l_gec07='Y' THEN
      LET p_rvv39 = p_rvv39t / ( 1 + l_pmm43/100)
      LET p_rvv39 = cl_digcut(p_rvv39 , t_azi04)  
   ELSE
      LET p_rvv39t = p_rvv39 * ( 1 + l_pmm43/100)
      LET p_rvv39t = cl_digcut( p_rvv39t , t_azi04)  
   END IF      
 
   RETURN p_rvv39,p_rvv39t
END FUNCTION
 
FUNCTION aws_create_purchase_stock_check_rvv32(l_rvu,l_rvv)
   DEFINE l_rvu RECORD LIKE rvu_file.*
   DEFINE l_rvv RECORD LIKE rvv_file.*
   DEFINE l_cnt   LIKE type_file.num5
   DEFINE l_imf04 LIKE imf_file.imf04
   DEFINE l_imf05 LIKE imf_file.imf05
   DEFINE sn1,sn2 LIKE type_file.num5
   DEFINE l_pmn38 LIKE pmn_file.pmn38
 
   LET g_errno=NULL
   IF cl_null(l_rvv.rvv32) THEN
      LET l_rvv.rvv32 = ' '
   END IF
   IF cl_null(l_rvv.rvv33) THEN
      LET l_rvv.rvv33 = ' '
   END IF
   IF cl_null(l_rvv.rvv34) THEN
      LET l_rvv.rvv34 = ' '
   END IF
   IF l_rvv.rvv31[1,4] != 'MISC' AND l_rvu.rvu00!='2' THEN
   #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
      IF NOT s_chksmz(l_rvv.rvv31, l_rvu.rvu01,
                      l_rvv.rvv32, l_rvv.rvv33) THEN
          RETURN l_rvv.*
      END IF
      #------>check-1  檢查該料是否可收至該倉/儲位
      IF NOT s_imfchk(l_rvv.rvv31,l_rvv.rvv32,
                      l_rvv.rvv33) THEN
         LET g_errno='mfg6095' RETURN l_rvv.*
      END IF
      #------>check-2  檢查該倉庫/儲位是否存在
      IF l_rvv.rvv33 IS NOT NULL THEN
         CALL s_hqty(l_rvv.rvv31,l_rvv.rvv32,
                     l_rvv.rvv33)
              RETURNING l_cnt,l_imf04,l_imf05
         IF l_imf04 IS NULL THEN LET l_imf04=0 END IF
         SELECT pmn38 INTO l_pmn38 FROM pmn_file
          WHERE pmn01=l_rvv.rvv36
            AND pmn02=l_rvv.rvv37
         CALL s_lwyn(l_rvv.rvv32,l_rvv.rvv33)
              RETURNING sn1,sn2    #可用否
         IF sn2 = 2 THEN
            IF l_pmn38 = 'Y' THEN LET g_errno='mfg9132' END IF
         ELSE
            IF l_pmn38 = 'N' THEN LET g_errno='mfg9131' END IF
         END IF
         LET sn1=0 LET sn2=0
      END IF
   END IF
   RETURN l_rvv.*
END FUNCTION
 
FUNCTION aws_create_purchase_stock_bef_ins_rvv(l_rvu,l_rvv)
   DEFINE l_rvu RECORD LIKE rvu_file.*
   DEFINE l_rvv RECORD LIKE rvv_file.*
   DEFINE l_ima906 LIKE ima_file.ima906
   DEFINE l_ima907 LIKE ima_file.ima907
   DEFINE l_ima908 LIKE ima_file.ima908
   DEFINE l_flag   LIKE type_file.num5
   DEFINE l_img09  LIKE img_file.img09
   DEFINE l_pmm43  LIKE pmm_file.pmm43
 
   LET g_errno=NULL
   IF g_sma.sma115 = 'Y' THEN
      CALL s_chk_va_setting(l_rvv.rvv31)
           RETURNING l_flag,l_ima906,l_ima907
      IF l_flag=1 THEN
         RETURN l_rvv.*
      END IF
      CALL s_chk_va_setting1(l_rvv.rvv31)
           RETURNING l_flag,l_ima908
      IF l_flag=1 THEN
         RETURN l_rvv.*
      END IF
      CALL aws_create_purchase_stock_du_data_to_correct(l_rvv.*)
         RETURNING l_rvv.*
      CALL aws_create_purchase_stock_set_origin_field(l_rvv.*)
         RETURNING l_rvv.*
   END IF
 
 
    IF NOT cl_null(l_rvv.rvv31) THEN
      SELECT img09 INTO l_img09 FROM img_file
      WHERE img01=l_rvv.rvv31 AND img02=l_rvv.rvv32
        AND img03=l_rvv.rvv33 AND img04=l_rvv.rvv34
     IF (l_rvu.rvu00='1' AND STATUS=100) OR 
        (l_rvu.rvu00='3' AND STATUS=100) THEN
         #整合不提示
        #IF g_sma.sma892[3,3] ='Y' THEN
        #   IF NOT cl_confirm('mfg1401') THEN RETURN l_rvv.* END IF
        #END IF
         #整合不處理
         #CALL s_add_img(l_rvv.rvv31,l_rvv.rvv32,
         #               l_rvv.rvv33,l_rvv.rvv34,
         #               l_rvu.rvu01,      l_rvv.rvv02,
         #               l_rvu.rvu03)
     ELSE
       CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv35,l_img09)
       RETURNING l_flag,l_rvv.rvv35_fac
       IF l_flag THEN
         LET g_errno='apm-258'
         RETURN l_rvv.*
       END IF
     END IF
   END IF  
   IF g_sma.sma116 MATCHES '[02]' THEN#MOD-630031 add #不使用計價單位時,計價單位/數量給原單據單位/數量
      LET l_rvv.rvv86 = l_rvv.rvv35
      LET l_rvv.rvv87 = l_rvv.rvv17
   END IF
 
   #FUN-5B0144 add  #數量為0時重新計算含稅金額
   IF l_rvv.rvv87 > 0 THEN
      LET l_rvv.rvv39 = l_rvv.rvv87 * l_rvv.rvv38
      LET l_rvv.rvv39t= l_rvv.rvv87 * l_rvv.rvv38t   #No.FUN-610018
      LET l_rvv.rvv39t= l_rvv.rvv87 * l_rvv.rvv38t
   ELSE
      LET l_pmm43='' #MOD-7A0180 add
      SELECT pmm43 INTO l_pmm43 FROM pmm_file WHERE pmm01 = l_rvv.rvv36
      IF l_rvv.rvv87=0 AND cl_null(l_pmm43) THEN 
         LET l_rvv.rvv39t = l_rvv.rvv39t    # 退倉無數量且無採購單可參考時
      ELSE
      IF cl_null(l_pmm43) THEN
         SELECT gec04 INTO l_pmm43 FROM gec_file,pmc_file 
          WHERE gec01 = pmc47
            AND pmc01 = l_rvu.rvu04 
            AND gec011='1'  #進項
      END IF
        IF cl_null(l_pmm43) THEN LET l_pmm43=0 END IF
        IF cl_null(l_rvv.rvv39t) THEN
           LET l_rvv.rvv39t= l_rvv.rvv39 * (1+l_pmm43/100)  #No.FUN-610018
           LET l_rvv.rvv39t = l_rvv.rvv39 * (1+l_pmm43/100)
        ELSE 
           LET l_rvv.rvv39t = l_rvv.rvv39t
        END IF  
      END IF  #MOD-7A0180 
   END IF
   IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02 = 1 END IF
   LET l_rvv.rvv88 = 0
   CALL aws_create_purchase_stock_rvv39(l_rvv.rvv36,l_rvv.rvv39,l_rvv.rvv39t)  
        RETURNING l_rvv.rvv39,l_rvv.rvv39t
   RETURN l_rvv.*
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION aws_create_purchase_stock_du_data_to_correct(l_rvv)
   DEFINE l_rvv RECORD LIKE rvv_file.*
 
   IF cl_null(l_rvv.rvv83) THEN
      LET l_rvv.rvv84 = NULL
      LET l_rvv.rvv85 = NULL
   END IF
 
   IF cl_null(l_rvv.rvv80) THEN
      LET l_rvv.rvv81 = NULL
      LET l_rvv.rvv82 = NULL
   END IF
   RETURN l_rvv.*
END FUNCTION
 
#對原來數量/換算率/單位的賦值
FUNCTION aws_create_purchase_stock_set_origin_field(l_rvv)
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_img09  LIKE img_file.img09,     #img單位
            l_ima25  LIKE ima_file.ima25,
            l_ima44  LIKE ima_file.ima44,
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE rvv_file.rvv84,
            l_qty2   LIKE rvv_file.rvv85,
            l_fac1   LIKE rvv_file.rvv81,
            l_qty1   LIKE rvv_file.rvv82,
            l_factor LIKE ima_file.ima31_fac,
            l_rvv    RECORD LIKE rvv_file.*,
            l_cnt    LIKE type_file.num5
 
   LET g_errno=NULL
    IF g_sma.sma115='N' THEN RETURN l_rvv.* END IF
    SELECT ima25,ima44 INTO l_ima25,l_ima44,l_ima906 FROM ima_file
     WHERE ima01=l_rvv.rvv31
    IF SQLCA.sqlcode = 100 THEN
       IF l_rvv.rvv31 MATCHES 'MISC*' THEN
          SELECT ima25,ima44 INTO l_ima25,l_ima44 FROM ima_file
           WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44=l_ima25 END IF
 
    SELECT img09 INTO l_img09 FROM img_file
     WHERE img01=l_rvv.rvv31
       AND img02=l_rvv.rvv32
       AND img03=l_rvv.rvv33
       AND img04=l_rvv.rvv34
    IF l_img09 IS NULL THEN LET l_img09=l_ima44 END IF
    LET l_fac2=l_rvv.rvv84
    LET l_qty2=l_rvv.rvv85
    LET l_fac1=l_rvv.rvv81
    LET l_qty1=l_rvv.rvv82
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE l_ima906
          WHEN '1' LET l_rvv.rvv35=l_rvv.rvv80
                   LET l_rvv.rvv17=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET l_rvv.rvv35=l_ima44
                   LET l_rvv.rvv17=l_tot
          WHEN '3' LET l_rvv.rvv35=l_rvv.rvv80
                   LET l_rvv.rvv17=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET l_rvv.rvv84=l_qty1/l_qty2
                   ELSE
                      LET l_rvv.rvv84=0
                   END IF
       END CASE
    END IF
    LET l_factor = 1
    CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv35,l_ima25)
          RETURNING l_cnt,l_factor
    IF l_cnt = 1 THEN
       LET l_factor = 1
    END IF
    LET l_rvv.rvv35_fac = l_factor
    RETURN l_rvv.*
END FUNCTION
