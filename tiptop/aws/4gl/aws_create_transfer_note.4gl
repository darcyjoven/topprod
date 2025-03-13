# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_transfer_note.4gl
# Descriptions...: 提供建立倉庫調撥單資料的服務
# Date & Author..: No.FUN-840012 08/05/06 By Nicola
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A60034 11/03/08 By Mandy EasyFlow整合功能外序參數的接收順序交換為：ARG_VAL(1)-->imm01調撥單號； ARG_VAL(2)-->Action ID ； ARG_VAL(3) -->借出管理flag
 
DATABASE ds
 
#No.FUN-840012
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
#[
# Description....: 提供建立倉庫調撥單資料的服務(入口 function)
# Date & Author..: No.FUN-840012 08/05/06 By Nicola
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_transfer_note()
 
   WHENEVER ERROR CONTINUE
 
   CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
 
   #--------------------------------------------------------------------------#
   # 新增倉庫調撥單資料                                                       #
   #--------------------------------------------------------------------------#
   IF g_status.code = "0" THEN
      CALL aws_create_transfer_note_process()
   END IF
 
   CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
 
END FUNCTION
 
#[
# Description....: 依據傳入資訊新增 ERP 倉庫調撥單資料
# Date & Author..: No.FUN-840012 08/05/06 By Nicola
# Parameter......: 
# Return.........: 倉庫調撥單號
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_transfer_note_process()
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
                         imm01   LIKE imm_file.imm01   #回傳的欄位名稱
                      END RECORD
    DEFINE l_imm      RECORD LIKE imm_file.*
    DEFINE l_imn      RECORD LIKE imn_file.*
    DEFINE l_chr      LIKE type_file.chr1
    DEFINE l_status   LIKE type_file.chr1
    DEFINE l_cmd      STRING
    DEFINE l_prog     STRING
 
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的倉庫調撥單資料                                    #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("imm_file")   #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
 
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
 
    SELECT * INTO g_sma.*
      FROM sma_file
     WHERE sma00='0'
 
    BEGIN WORK
 
    FOR l_i = 1 TO l_cnt1
        INITIALIZE l_imm.* TO NULL
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "imm_file")        #目前處理單檔的 XML 節點
        LET l_status = aws_ttsrv_getParameter("status")
 
        LET l_imm.imm01 = aws_ttsrv_getRecordField(l_node1, "imm01") #取得此筆單檔資料的欄位值
        LET l_imm.imm02 = aws_ttsrv_getRecordField(l_node1, "imm02") #調撥日期
        LET l_imm.imm14 = aws_ttsrv_getRecordField(l_node1, "imm14") #部門
 
        #----------------------------------------------------------------------#
        # 檢查單據日期                                                         #
        #----------------------------------------------------------------------#
        CALL aws_create_purchase_stock_check_imm02(l_imm.*)
        IF NOT cl_null(g_errno) THEN
           LET g_status.code = g_errno
           EXIT FOR
        END IF
 
        #----------------------------------------------------------------------#
        # 倉庫調撥單自動取號                                                   #
        #----------------------------------------------------------------------#
        CALL s_check_no("aim",l_imm.imm01,"","4","imm_file","imm01","")
              RETURNING l_flag,l_imm.imm01
        IF NOT l_flag THEN
           LET g_status.code = "apm-920"   #倉庫調撥單自動取號失敗
           EXIT FOR
        END IF
 
        CALL s_auto_assign_no("aim",l_imm.imm01,l_imm.imm02,"","imm_file","imm01","","","")
                    RETURNING l_flag, l_imm.imm01
        IF NOT l_flag THEN
           LET g_status.code = "apm-920"   #倉庫調撥單自動取號失敗
           EXIT FOR
        END IF
 
        #------------------------------------------------------------------#
        # 設定倉庫調撥單頭預設值                                           #
        #------------------------------------------------------------------#
        CALL aws_create_purchase_stock_set_imm(l_imm.*) RETURNING l_imm.*
        IF NOT cl_null(g_errno) THEN
           LET g_status.code = g_errno
           EXIT FOR
        END IF
 
        #------------------------------------------------------------------#
        # RECORD資料傳到NODE                                               #
        #------------------------------------------------------------------#
        CALL aws_ttsrv_setRecordField_record(l_node1,base.Typeinfo.create(l_imm))
 
        LET l_sql = aws_ttsrv_getRecordSql(l_node1, "imm_file", "I", NULL)   #I 表示取得 INSERT SQL
 
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
        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "imn_file")       #取得目前單頭共有幾筆單身資料
        IF l_cnt2 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           EXIT FOR
        END IF
 
        CALL cl_flow_notify(l_imn.imn01,'I')  #新增資料到 p_flow
 
        FOR l_j = 1 TO l_cnt2
            INITIALIZE l_imn.* TO NULL
            LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "imn_file")   #目前單身的 XML 節點
 
            #------------------------------------------------------------------#
            # NODE資料傳到RECORD                                               #
            #------------------------------------------------------------------#
            LET l_imn.imn01=l_imm.imm01   #調撥單號
            LET l_imn.imn02=l_j           #項次
            LET l_imn.imn03 = aws_ttsrv_getRecordField(l_node2, "imn03")  #料件編號
            LET l_imn.imn04 = aws_ttsrv_getRecordField(l_node2, "imn04")  #撥出倉庫
            LET l_imn.imn05 = aws_ttsrv_getRecordField(l_node2, "imn05")  #撥出儲位
            LET l_imn.imn06 = aws_ttsrv_getRecordField(l_node2, "imn06")  #撥出批號
            LET l_imn.imn09 = aws_ttsrv_getRecordField(l_node2, "imn09")  #庫存單位
            LET l_imn.imn10 = aws_ttsrv_getRecordField(l_node2, "imn10")  #撥出數量
            LET l_imn.imn15 = aws_ttsrv_getRecordField(l_node2, "imn15")  #撥入倉庫
            LET l_imn.imn16 = aws_ttsrv_getRecordField(l_node2, "imn16")  #撥入儲位
            LET l_imn.imn17 = aws_ttsrv_getRecordField(l_node2, "imn17")  #撥入批號
            LET l_imn.imn20 = aws_ttsrv_getRecordField(l_node2, "imn20")  #庫存單位
            LET l_imn.imn21 = aws_ttsrv_getRecordField(l_node2, "imn21")  #單位轉換率
            LET l_imn.imn22 = aws_ttsrv_getRecordField(l_node2, "imn22")  #撥入單位
            LET l_imn.imn29 = "N"         #檢驗
 
 
            #------------------------------------------------------------------#
            # 欄位檢查                                                         #
            #------------------------------------------------------------------#
            CALL aws_create_purchase_stock_check_imn(l_imm.*,l_imn.*)
                 RETURNING l_imn.*
            IF NOT cl_null(g_errno) THEN
               LET g_status.code=g_errno
               EXIT FOR
            END IF
 
            #------------------------------------------------------------------#
            # RECORD資料傳到NODE2                                              #
            #------------------------------------------------------------------#
            CALL aws_ttsrv_setRecordField_record(l_node2,base.Typeinfo.create(l_imn))
 
            IF cl_null(l_imn.imn04) THEN 
               LET l_imn.imn04=" "
               CALL aws_ttsrv_setRecordField(l_node2, "imn04", " ")
            END IF
 
            IF cl_null(l_imn.imn05) THEN 
               LET l_imn.imn05=" "
               CALL aws_ttsrv_setRecordField(l_node2, "imn05", " ")
            END IF
 
            IF cl_null(l_imn.imn06) THEN 
               LET l_imn.imn06=" "
               CALL aws_ttsrv_setRecordField(l_node2, "imn06", " ")
            END IF
 
            IF cl_null(l_imn.imn15) THEN 
               LET l_imn.imn15=" "
               CALL aws_ttsrv_setRecordField(l_node2, "imn15", " ")
            END IF
 
            IF cl_null(l_imn.imn16) THEN 
               LET l_imn.imn16=" "
               CALL aws_ttsrv_setRecordField(l_node2, "imn16", " ")
            END IF
 
            IF cl_null(l_imn.imn17) THEN 
               LET l_imn.imn17=" "
               CALL aws_ttsrv_setRecordField(l_node2, "imn17", " ")
            END IF
 
            LET l_sql = aws_ttsrv_getRecordSql(l_node2, "imn_file", "I", NULL) #I 表示取得 INSERT SQL
 
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
       LET l_return.imm01 = l_imm.imm01
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
 
    IF l_status='Y' THEN
       LET l_cmd=NULL
       LET l_prog="aimt324"
      #LET l_cmd=l_prog," '",l_imm.imm01 CLIPPED,"' 'M' ' '" #FUN-A60034 mark
       LET l_cmd=l_prog," '",l_imm.imm01 CLIPPED,"' ' ' 'M'" #FUN-A60034 add
       CALL cl_cmdrun_wait(l_cmd)
       CALL aws_ttsrv_cmdrun_checkStatus(l_prog)
    END IF
 
    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳自動取號結果
 
END FUNCTION
 
#[
# Description....: 倉庫調撥單設定欄位預設值
# Date & Author..: No.FUN-840012 08/05/06 By Nicola
# Parameter......:
# Return.........:
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_purchase_stock_set_imm(l_imm)
    DEFINE l_imm RECORD LIKE imm_file.*
 
    LET g_errno=NULL
    #--------------------------------------------------------------------------#
    # 設定倉庫調撥單單頭欄位預設值                                             #
    #--------------------------------------------------------------------------#
    IF cl_null(l_imm.imm02) OR l_imm.imm02=0 THEN
       LET l_imm.imm02  = g_today
    END IF
 
    LET l_imm.imm03   = "N"
    LET l_imm.imm04   = "N"
    LET l_imm.imm10   = "1"
    LET l_imm.immuser = g_user
    LET g_data_plant = g_plant #FUN-980030
    LET l_imm.immgrup = g_grup
    LET l_imm.immdate = g_today
    LET l_imm.immacti = 'Y'
    LET l_imm.immspc  = '0'
 
    RETURN l_imm.*
 
END FUNCTION
 
#[
# Description....: 檢查單身欄位
# Date & Author..: No.FUN-840012 08/05/06 By Nicola
# Parameter......: l_imm,l_imn - 收貨單頭/單身
# Return.........: no - use g_errno 判斷檢查是否有誤
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_purchase_stock_check_imn(l_imm,l_imn)
  DEFINE l_imm    RECORD LIKE imm_file.*
  DEFINE l_imn    RECORD LIKE imn_file.*
 
  LET g_errno=NULL
 
  #--------------------------------------------------------------------------#
  # 檢查料件編號                                                             #
  #--------------------------------------------------------------------------#
  CALL aws_create_purchase_stock_check_imn03(l_imn.*) RETURNING l_imn.*
  IF NOT cl_null(g_errno) THEN
     RETURN l_imn.*
  END IF
 
  RETURN l_imn.*
 
END FUNCTION
 
 
#檢查料件編號有無存在ima_file
FUNCTION aws_create_purchase_stock_check_imn03(l_imn)
   DEFINE l_imn RECORD LIKE imn_file.*
   DEFINE l_cnt LIKE type_file.num5
 
   LET g_errno=NULL
 
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM ima_file
    WHERE ima01 = l_imn.imn03
      AND imaacti = "Y"
 
   IF l_cnt=0 THEN
      LET g_errno='mfg1201'
      RETURN l_imn.*
   END IF
 
   RETURN l_imn.*
 
END FUNCTION
 
FUNCTION aws_create_purchase_stock_check_imm02(l_imm)
   DEFINE l_imm RECORD LIKE imm_file.*
   DEFINE l_yy LIKE sma_file.sma51
   DEFINE l_mm LIKE sma_file.sma52
 
   LET g_errno=NULL
 
   IF NOT cl_null(l_imm.imm02) THEN
      IF NOT cl_null(g_sma.sma53) AND l_imm.imm02 <= g_sma.sma53 THEN  #關帳日期
         LET g_errno='mfg9999'
         RETURN
      END IF
      CALL s_yp(l_imm.imm02) RETURNING l_yy,l_mm
      IF (l_yy*12+l_mm)>(g_sma.sma51*12+g_sma.sma52)THEN #不可大於現行年月
         LET g_errno='mfg6091'
         RETURN
      END IF
   END IF
 
END FUNCTION
 
