# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_poreceiving_data.4gl
# Descriptions...: 提供建立採購收貨單資料的服務
# Date & Author..: 2008/04/03 by kim (FUN-840012)
# Memo...........:
# Modify.........: No.CHI-8A0025 08/10/22 By kim mBarcode修改
# Modify.........: No.TQC-8C0092 08/12/31 By kim mBarcode修改
# Modify.........: No.CHI-910021 09/01/15 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-940083 09/05/18 By Cockroach 原可收量(pmn20-pmn50+pmn55)全部改為(pmn20-pmn50+pmn55+pmn58)
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9A0068 09/10/23 by dxfwo VMI测试结果反馈及相关调整
 
DATABASE ds
 
#FUN-840012
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
 
#[
# Description....: 提供建立採購收貨單資料的服務(入口 function)
# Date & Author..: 2008/04/03 by kim
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_poreceiving_data()
 
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增採購收貨單資料                                                       #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_poreceiving_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 依據傳入資訊新增 ERP 採購收貨單資料
# Date & Author..: 2008/04/03 by kim
# Parameter......: none
# Return.........: 收貨單號
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_poreceiving_data_process()
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
                         rva01   LIKE rva_file.rva01   #回傳的欄位名稱
                      END RECORD
    DEFINE l_rva      RECORD LIKE rva_file.*
    DEFINE l_rvb      RECORD LIKE rvb_file.*
    DEFINE l_status   LIKE rva_file.rvaconf
    DEFINE l_cmd      STRING
    DEFINE l_prog     STRING
 
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的採購收貨單資料                                    #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("rva_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
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
        INITIALIZE l_rva.* TO NULL
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "rva_file")        #目前處理單檔的 XML 節點
        LET l_status = aws_ttsrv_getParameter("status")
        
        LET l_rva.rva01 = aws_ttsrv_getRecordField(l_node1, "rva01")         #取得此筆單檔資料的欄位值
        LET l_rva.rva05 = aws_ttsrv_getRecordField(l_node1, "rva05")         #取得此筆單檔資料的欄位值
        LET l_rva.rva06 = aws_ttsrv_getRecordField(l_node1, "rva06")
        
        #----------------------------------------------------------------------#
        # 採購收貨單自動取號                                                   #
        #----------------------------------------------------------------------#      
        IF NOT cl_null(g_sma.sma53) AND l_rva.rva06 <= g_sma.sma53 THEN
           LET g_status.code = "mfg9999"
           EXIT FOR
        END IF
        CALL s_check_no("APM",l_rva.rva01,"","3","rva_file","rva01","")
          RETURNING l_flag,l_rva.rva01
        IF NOT l_flag THEN
           LET g_status.code = "apm-920"   #採購收貨單自動取號失敗
           EXIT FOR
        END IF
        CALL s_auto_assign_no("APM",l_rva.rva01,l_rva.rva06,"3","rva_file","rva01","","","")
             RETURNING l_flag, l_rva.rva01
        IF NOT l_flag THEN
           LET g_status.code = "apm-920"   #採購收貨單自動取號失敗
           EXIT FOR
        END IF
 
        #------------------------------------------------------------------#
        # 設定收貨單頭預設值                                               #
        #------------------------------------------------------------------#
        CALL aws_create_poreceiving_set_rva(l_rva.*) RETURNING l_rva.*
        IF NOT cl_null(g_errno) THEN
           LET g_status.code = g_errno
           EXIT FOR
        END IF
 
 
       #CALL aws_ttsrv_setRecordField(l_node1, "rva01", l_rva.rva01)   #更新 XML 取號完成後的採購收貨單單號欄位(rva01)
 
       #IF NOT aws_create_poreceiving_data_default(l_node1) THEN     #檢查採購收貨單欄位預設值           
       #   EXIT FOR
       #END IF
 
        #------------------------------------------------------------------#
        # RECORD資料傳到NODE                                               #
        #------------------------------------------------------------------#
        CALL aws_ttsrv_setRecordField_record(l_node1,base.Typeinfo.create(l_rva))
 
        LET l_sql = aws_ttsrv_getRecordSql(l_node1, "rva_file", "I", NULL)   #I 表示取得 INSERT SQL
 
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
        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "rvb_file")       #取得目前單頭共有幾筆單身資料
        IF l_cnt2 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           EXIT FOR
        END IF
 
        CALL cl_flow_notify(l_rva.rva01,'I')  #新增資料到 p_flow
        
        FOR l_j = 1 TO l_cnt2
            INITIALIZE l_rvb.* TO NULL
            LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "rvb_file")   #目前單身的 XML 節點
 
 
            #------------------------------------------------------------------#
            # NODE資料傳到RECORD                                               #
            #------------------------------------------------------------------#
            LET l_rvb.rvb01=l_rva.rva01
            LET l_rvb.rvb02=l_j
            LET l_rvb.rvb03 = aws_ttsrv_getRecordField(l_node2, "rvb03")
            LET l_rvb.rvb04 = aws_ttsrv_getRecordField(l_node2, "rvb04")
            LET l_rvb.rvb05 = aws_ttsrv_getRecordField(l_node2, "rvb05")
            LET l_rvb.rvb07 = aws_ttsrv_getRecordField(l_node2, "rvb07")
            LET l_rvb.rvb36 = aws_ttsrv_getRecordField(l_node2, "rvb36")
            LET l_rvb.rvb37 = aws_ttsrv_getRecordField(l_node2, "rvb37")
            LET l_rvb.rvb38 = aws_ttsrv_getRecordField(l_node2, "rvb38")
 
 
            #------------------------------------------------------------------#
            # 設定欄位預設值                                                   #
            #------------------------------------------------------------------#
            CALL aws_create_poreceiving_set_rvb_def(l_rva.*,l_rvb.*) 
                 RETURNING l_rvb.*
 
 
            #------------------------------------------------------------------#
            # 欄位檢查                                                         #
            #------------------------------------------------------------------#
            CALL aws_create_poreceiving_check_rvb(l_rva.*,l_rvb.*) 
                 RETURNING l_rvb.*
            IF NOT cl_null(g_errno) THEN
               LET g_status.code=g_errno
               EXIT FOR
            END IF
 
 
 
            #------------------------------------------------------------------#
            # RECORD資料傳到NODE2                                              #
            #------------------------------------------------------------------#
            CALL aws_ttsrv_setRecordField_record(l_node2,base.Typeinfo.create(l_rvb))
 
            IF cl_null(l_rvb.rvb36) THEN 
               LET l_rvb.rvb36=" "
               CALL aws_ttsrv_setRecordField(l_node2, "rvb36", " ")
            END IF
            IF cl_null(l_rvb.rvb37) THEN 
               LET l_rvb.rvb37=" "
               CALL aws_ttsrv_setRecordField(l_node2, "rvb37", " ")
            END IF
            IF cl_null(l_rvb.rvb38) THEN 
               LET l_rvb.rvb38=" "
               CALL aws_ttsrv_setRecordField(l_node2, "rvb38", " ")
            END IF
 
 
            LET l_sql = aws_ttsrv_getRecordSql(l_node2, "rvb_file", "I", NULL) #I 表示取得 INSERT SQL
            
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
       LET l_return.rva01 = l_rva.rva01
      #CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳 ERP 建立的採購收貨單單號
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
    #CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳自動取號結果
 
    IF (l_status='Y') AND (g_status.code = "0") THEN
       CASE l_rva.rva10
          WHEN "SUB"
             LET l_prog = 'apmt200'
          WHEN "TAP"
             LET l_prog = 'apmt300'
          OTHERWISE
             LET l_prog = 'apmt110'
       END CASE
       LET l_cmd=l_prog," '",l_rva.rva01 CLIPPED,"' ' ' '1'"
       CALL cl_cmdrun_wait(l_cmd)
       CALL aws_ttsrv_cmdrun_checkStatus(l_prog)
    END IF
    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳自動取號結果
END FUNCTION
 
#[
# Description....: 採購收貨單設定欄位預設值
# Date & Author..: 2008/04/07 by kim
# Parameter......: l_rva - 收貨單單頭
# Return.........: l_rva - 收貨單單頭
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_poreceiving_set_rva(l_rva)
    DEFINE l_rva RECORD LIKE rva_file.*
 
    LET g_errno=NULL
    #--------------------------------------------------------------------------#
    # 設定採購收貨單單頭欄位預設值                                             #
    #--------------------------------------------------------------------------#
    IF cl_null(l_rva.rva06) OR l_rva.rva06=0 THEN
       LET l_rva.rva06 = g_today
    END IF
    LET l_rva.rvaprsw = 'Y'
    LET l_rva.rvaprno = 0
    LET l_rva.rva10 ='REG'
    LET l_rva.rva04 = 'N'
    LET l_rva.rvaconf = 'N'
    LET l_rva.rvaspc = '0'
    LET l_rva.rvauser=g_user
    LET g_data_plant = g_plant #FUN-980030
    LET l_rva.rvagrup=g_grup
    LET l_rva.rvadate=g_today
    LET l_rva.rvaacti='Y'
    RETURN l_rva.*
END FUNCTION
 
 
#[
# Description....: 設定單身預設值
# Date & Author..: 2008/04/07 by kim
# Parameter......: l_rvb - 收貨單身
# Return.........: 
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_poreceiving_set_rvb_def(l_rva,l_rvb)
  DEFINE l_rva    RECORD LIKE rva_file.*
  DEFINE l_rvb    RECORD LIKE rvb_file.*
  DEFINE l_ima491 LIKE ima_file.ima491
  
 
   #--------------------------------------------------------------------------#
   # 設定採購收貨單單身欄位預設值  from sapmt110._b().BEFORE INSERT           #
   #--------------------------------------------------------------------------#
   LET l_rvb.rvb35 = 'N'
   LET l_rvb.rvb06 = 0
   IF cl_null(l_rvb.rvb07) THEN
      LET l_rvb.rvb07 = 0
   END IF
   LET l_rvb.rvb08 = 0
   LET l_rvb.rvb09 = 0
   LET l_rvb.rvb10 = 0
   LET l_rvb.rvb82 = 0
   LET l_rvb.rvb85 = 0
   LET l_rvb.rvb87 = 0
   LET l_rvb.rvb06  = 0     #已請數量
   LET l_rvb.rvb09  = 0     #允請數量
   LET l_rvb.rvb10  = 0     
   LET l_rvb.rvb10t = 0     
   LET l_rvb.rvb15  = 0     #容器數量
   LET l_rvb.rvb16  = 0     #容器數目
   LET l_rvb.rvb18  = '10'  #收貨狀況
   LET l_rvb.rvb27  = 0     #NO USE
   LET l_rvb.rvb28  = 0     #NO USE
   LET l_rvb.rvb29  = 0     #退補量
   LET l_rvb.rvb32  = 0     #NO USE
   LET l_rvb.rvb31  = 0     #
   LET l_rvb.rvb30  = 0     #入庫量
   LET l_rvb.rvb33  = 0     #入庫量
   LET l_rvb.rvb331  = 0    #允收量
   LET l_rvb.rvb332  = 0    #允收量
   LET l_rvb.rvb35  = 'N'   #樣品否
   LET l_rvb.rvb40  = ''    #檢驗日期
   LET l_rvb.rvb87 = l_rvb.rvb07
   #暫不考慮委外的情況
   #IF l_rva.rva10 ='SUB' THEN
   #   LET l_sfb24=''
   #   SELECT sfb24 INTO l_sfb24
   #    FROM sfb_file
   #    WHERE sfb01 = l_rvb.rvb34
   #   IF l_sfb24 IS NOT NULL AND l_sfb24='Y' THEN
   #      LET l_ec_sw='Y'
   #   END IF
   #   IF l_ec_sw='Y' THEN
   #      LET l_rvb.rvb36=' '
   #      LET l_rvb.rvb37=' '
   #      LET l_rvb.rvb38=' '
   #   END IF
   #END IF
   LET l_rvb.rvb10 = 0
   IF cl_null(l_rvb.rvb08) OR l_rvb.rvb08 = 0 THEN
      LET l_rvb.rvb08 = l_rvb.rvb07
   END IF
   LET l_rvb.rvb11 = 0
   
   SELECT ima491 INTO l_ima491 FROM ima_file
    WHERE ima01 = l_rvb.rvb05
   IF cl_null(l_ima491) THEN
      LET l_ima491 = 0
   END IF
   IF l_ima491 > 0 THEN
      CALL s_getdate(l_rva.rva06,l_ima491) RETURNING l_rvb.rvb12
   ELSE
      IF cl_null(l_rvb.rvb12) THEN
         LET l_rvb.rvb12 = l_rva.rva06
      END IF
   END IF
   CALL aws_create_poreceiving_get_rvb39(l_rvb.rvb04,l_rvb.rvb05,l_rvb.rvb19,l_rva.rva05) RETURNING l_rvb.rvb39 #CHI-8A0025
 
   RETURN l_rvb.*
END FUNCTION
 
#[
# Description....: 檢查單身欄位
# Date & Author..: 2008/04/07 by kim
# Parameter......: l_rva,l_rvb - 收貨單頭/單身
# Return.........: no - use g_errno 判斷檢查是否有誤
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_poreceiving_check_rvb(l_rva,l_rvb) 
  DEFINE l_rva    RECORD LIKE rva_file.*
  DEFINE l_rvb    RECORD LIKE rvb_file.*
 
  LET g_errno=NULL
 
  #--------------------------------------------------------------------------#
  # 將採購單單身資料帶入收貨單單身  #from sapmt110.t110_rvb03()              #
  #--------------------------------------------------------------------------#
  CALL aws_create_poreceiving_gen_rvb('a',l_rvb.rvb04,l_rvb.rvb03,
                                      l_rva.*,l_rvb.*) RETURNING l_rvb.*
  IF NOT cl_null(g_errno) THEN
     RETURN l_rvb.*
  END IF
  
  #--------------------------------------------------------------------------#
  # 檢查料件編號                                                             #
  #--------------------------------------------------------------------------#
  CALL aws_create_poreceiving_check_rvb05(l_rvb.*)
  IF (NOT cl_null(g_errno)) THEN
     RETURN l_rvb.*
  END IF
 
  #--------------------------------------------------------------------------#
  # 檢查實收數量是否超過                                                     #
  #--------------------------------------------------------------------------#
  CALL aws_create_poreceiving_check_rvb07('a',l_rva.*,l_rvb.*)
     RETURNING l_rvb.*
  IF (NOT cl_null(g_errno)) THEN
     RETURN l_rvb.*
  END IF
 
  #--------------------------------------------------------------------------#
  # 檢查倉儲批                                                               #
  #--------------------------------------------------------------------------#
  CALL aws_create_poreceiving_check_rvb36(l_rva.*,l_rvb.*)
     RETURNING l_rvb.*  
  IF (NOT cl_null(g_errno)) THEN
     RETURN l_rvb.*
  END IF
  RETURN l_rvb.*
END FUNCTION
 
#[
# Description....: 由採購單單身帶資料進收貨單單身
# Date & Author..: 2008/04/07 by kim
# Parameter......: p_cmd-固定傳'a'新增,p_po-採購單號,p_item-採購單項次,
#                  l_rva-收貨單頭,l_rvb - 收貨單身
# Return.........: l_rvb-收貨單單身值 ; use g_errno 判斷檢查是否有誤
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_poreceiving_gen_rvb(p_cmd,p_po,p_item,l_rva,l_rvb)
  DEFINE l_rva    RECORD LIKE rva_file.*
  DEFINE l_rvb    RECORD LIKE rvb_file.*
  DEFINE p_cmd    LIKE type_file.chr1,
         p_po     LIKE pmn_file.pmn01,
         l_pmn04  LIKE pmn_file.pmn04,
         l_no     LIKE ade_file.ade04,
         l_cnt    LIKE type_file.num5,
         p_item   LIKE pmn_file.pmn02,
         l_pmn122 LIKE pmn_file.pmn122,
         l_pmn16  LIKE pmn_file.pmn16,
         l_pmn15  LIKE pmn_file.pmn15,
         l_pmn34  LIKE pmn_file.pmn34,
         l_pmn37  LIKE pmn_file.pmn37,
         l_pmn58  LIKE pmn_file.pmn58,
         l_pmn41  LIKE pmn_file.pmn41,
         l_pmn011 LIKE pmn_file.pmn011,
         l_pmn63  LIKE pmn_file.pmn63,
         l_pmh08  LIKE pmh_file.pmh08,
         l_sfb24  LIKE sfb_file.sfb24,
         l_date   LIKE pmn_file.pmn37,
         l_rvb07  LIKE rvb_file.rvb07,
         l_rvb07s LIKE rvb_file.rvb07,
         l_pmn52  LIKE pmn_file.pmn52,
         l_pmn54  LIKE pmn_file.pmn54,
         l_pmn56  LIKE pmn_file.pmn56,
         l_pmm22  LIKE pmm_file.pmm22,
         l_rvb25  LIKE rvb_file.rvb25,       
         l_alt06,t_alt06 LIKE alt_file.alt06,
         l_msg    LIKE type_file.chr50,      
         l_sw,l_sw1  LIKE type_file.chr1,    
         l_rvb80  LIKE rvb_file.rvb80,
         l_rvb81  LIKE rvb_file.rvb81,
         l_rvb82  LIKE rvb_file.rvb82,
         l_rvb83  LIKE rvb_file.rvb83,
         l_rvb84  LIKE rvb_file.rvb84,
         l_rvb85  LIKE rvb_file.rvb85,
         l_rvb86  LIKE rvb_file.rvb86,
         l_rvb87  LIKE rvb_file.rvb87,
         l_pmn20  LIKE pmn_file.pmn20,
         l_pmn13  LIKE pmn_file.pmn13,
         l_ec_sw  LIKE type_file.chr1
  DEFINE l_gec07  LIKE gec_file.gec07,  #TQC-8C0092
         l_pmn43  LIKE pmn_file.pmn43   #TQC-8C0092
 
   LET g_errno=NULL
   SELECT pmn04,pmn20,pmn16,pmn13,pmn011,
          pmn15,pmn34,pmn37,pmn41,   #TQC-8C0092 add pmn41
         #pmn20-pmn50+pmn55,pmn63,pmn52,pmn54,pmn56,pmn122,pmn71,pmn65,      #FUN-940083 MARK
          pmn20-pmn50+pmn55+pmn58,pmn63,pmn52,pmn54,pmn56,pmn122,pmn71,pmn65, #FUN-940083 ADD 
          pmn80,pmn81,pmn82,pmn83,pmn84,pmn85,pmn86,pmn87,pmm22,
          pmn930,
          pmn31,pmn31t,pmn43  #TQC-8C0092
     INTO l_rvb.rvb05,l_pmn20,l_pmn16,l_pmn13,l_pmn011,
          l_pmn15,l_pmn34,l_pmn37,l_rvb.rvb34,
          l_rvb07,l_pmn63,l_pmn52,l_pmn54,l_pmn56,l_pmn122,l_rvb25,l_rvb.rvb19,
          l_rvb80,l_rvb81,l_rvb82,l_rvb83,l_rvb84,l_rvb85,l_rvb86,l_rvb87,
          l_pmm22,
          l_rvb.rvb930,l_rvb.rvb10,l_rvb.rvb10t,l_pmn43  #TQC-8C0092
      FROM pmn_file,pmm_file
     WHERE pmn01 = p_po
       AND pmn02 = p_item
       AND pmn01=pmm01
       AND pmm18 <> 'X'
 
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'mfg3192'
         LET l_rvb.rvb83 = NULL
         LET l_rvb.rvb84 = NULL
         LET l_rvb.rvb85 = NULL
         LET l_rvb.rvb80 = NULL
         LET l_rvb.rvb81 = NULL
         LET l_rvb.rvb82 = NULL
         LET l_rvb.rvb86 = NULL
         LET l_rvb.rvb87 = NULL
      WHEN l_pmn16 != '2'
         LET g_errno = 'mfg3166'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    #料件多屬性暫不考慮
    #IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN              
    #   SELECT imx00,imx01,imx02,imx03,imx04,imx05,
    #          imx06,imx07,imx08,imx09,imx10 
    #    INTO l_rvb.att00, l_rvb.att01, l_rvb.att02,
    #         l_rvb.att03, l_rvb.att04, l_rvb.att05,
    #         l_rvb.att06, l_rvb.att07, l_rvb.att08,
    #         l_rvb.att09, l_rvb.att10
    #    FROM imx_file
    #     WHERE imx000 = l_rvb.rvb05
    #   #賦值所有屬性
    #   LET l_rvb.att01_c = l_rvb.att01
    #   LET l_rvb.att02_c = l_rvb.att02
    #   LET l_rvb.att03_c = l_rvb.att03
    #   LET l_rvb.att04_c = l_rvb.att04
    #   LET l_rvb.att05_c = l_rvb.att05
    #   LET l_rvb.att06_c = l_rvb.att06
    #   LET l_rvb.att07_c = l_rvb.att07
    #   LET l_rvb.att08_c = l_rvb.att08
    #   LET l_rvb.att09_c = l_rvb.att09
    #   LET l_rvb.att10_c = l_rvb.att10
    #END IF
    IF l_pmn011!=l_rva.rva10 THEN
       LET g_errno='apm-251'
       RETURN l_rvb.*
    END IF
 
    IF l_pmn011='SUB' AND l_rva.rva04='Y' THEN
       LET g_errno='apm-249'
       RETURN l_rvb.*
    END IF
 
    IF l_pmn15 = 'N' THEN
       IF cl_null(l_pmn37) THEN
          LET l_date = l_pmn34
       ELSE LET l_date = l_pmn37
       END IF
       IF l_rva.rva06 < l_date THEN LET g_errno = 'mfg3039' RETURN  END IF
    END IF
    #PDA自行輸入數量
    #IF p_cmd = 'a' THEN
    #   LET l_rvb07s=0
    #   SELECT SUM(rvb07) INTO l_rvb07s FROM rva_file,rvb_file   #未確認也計入
    #    WHERE rva01=rvb01 AND rvb04=l_rvb.rvb04
    #      AND rvb03=l_rvb.rvb03 AND rvaconf='N' AND rvb35='N'
    #   IF cl_null(l_rvb07s) THEN LET l_rvb07s=0 END IF
    #   LET l_rvb.rvb07=l_rvb07-l_rvb07s
    #    LET l_rvb.rvb25 = l_rvb25        #No.MOD-4B0275
    #  #MOD-680004-begin-add
    #   #若為LC收貨，則須檢查數貨不可大於提單數量
    #   IF l_rva.rva04='Y' AND NOT cl_null(l_rvb.rvb22) THEN
    #      SELECT alt06 INTO l_alt06 FROM alt_file
    #       WHERE alt01=l_rvb.rvb22
    #         AND alt14=l_rvb.rvb04
    #         AND alt15=l_rvb.rvb03
    #      IF cl_null(l_alt06) THEN
    #         LET l_alt06 = 0
    #      END IF
    #      SELECT SUM(rvb07) INTO t_alt06 FROM rvb_file
    #       WHERE rvb22=l_rvb.rvb22
    #         AND rvb04=l_rvb.rvb04
    #         AND rvb03=l_rvb.rvb03
    #         AND rvb01!=l_rva.rva01
    #         AND rvb35='N'
    #      IF cl_null(t_alt06) THEN
    #         LET t_alt06 = 0
    #      END IF
    #      LET l_rvb.rvb07 = (l_alt06-t_alt06) 
    #   END IF        
    #  #MOD-680004-end-add
    #END IF
   #IF l_pmn63='Y' THEN              #急料
   #   CALL cl_getmsg('apm-253',g_lang) RETURNING g_msg
   #   MESSAGE g_msg
   #END IF
 
    # 當為製程委外時不寫 tlf,不 update ima,img 所以可不key 倉庫
    LET l_ec_sw = 'N'
    IF l_rva.rva10 ='SUB' THEN
       LET l_sfb24=''
       SELECT sfb24 INTO l_sfb24
         FROM sfb_file
        WHERE sfb01 = l_rvb.rvb34
       IF l_sfb24 IS NOT NULL AND l_sfb24='Y' THEN
          LET l_ec_sw='Y'
       END IF
    END IF
    IF l_ec_sw='N' THEN
       IF cl_null(l_rvb.rvb36) THEN LET l_rvb.rvb36=l_pmn52 END IF
       IF cl_null(l_rvb.rvb37) THEN LET l_rvb.rvb37=l_pmn54 END IF
    END IF
 
    IF NOT cl_null(l_pmn122) THEN
       LET l_rvb.rvb38=l_pmn122  #for專案代號->批號欄位
    ELSE
       IF cl_null(l_rvb.rvb38) AND l_ec_sw='N' THEN
          LET l_rvb.rvb38=l_pmn56
       END IF
    END IF
    IF cl_null(l_rvb.rvb36) THEN
       SELECT pmm22 INTO l_pmm22 FROM pmm_file
        WHERE pmm01=l_rvb.rvb04
       SELECT pmh08 INTO l_pmh08 FROM pmh_file
        WHERE pmh01=l_rvb.rvb05 AND pmh02=l_rva.rva05
          AND pmh13=l_pmm22
          AND pmhacti = 'Y'                                           #CHI-910021
       IF status THEN LET l_pmh08='N' END IF
      #IF l_pmh08='Y' AND l_rvb.rvb05[1,4] !='MISC' AND l_ec_sw='N' THEN
        IF l_rvb.rvb05[1,4] !='MISC' AND l_ec_sw='N' THEN
          SELECT ima35,ima36 INTO l_rvb.rvb36,l_rvb.rvb37
            FROM ima_file
           WHERE ima01=l_rvb.rvb05
          IF cl_null(l_rvb.rvb38) THEN LET l_rvb.rvb38=' ' END IF
       END IF
    END IF
    IF l_rvb.rvb05[1,4]='MISC' OR l_ec_sw='Y' THEN
       LET l_rvb.rvb36=NULL LET l_rvb.rvb36=NULL
       LET l_rvb.rvb37=NULL LET l_rvb.rvb37=NULL
       LET l_rvb.rvb38=NULL LET l_rvb.rvb38=NULL
    END IF
 
    IF g_sma.sma115 = 'Y' THEN
       LET l_rvb.rvb80 = l_rvb80
       LET l_rvb.rvb81 = l_rvb81
       LET l_rvb.rvb82 = l_rvb82
       LET l_rvb.rvb83 = l_rvb83
       LET l_rvb.rvb84 = l_rvb84
       LET l_rvb.rvb85 = l_rvb85
       IF l_rvb07s <> 0 THEN
          LET l_rvb.rvb82=0
          LET l_rvb.rvb85=0
       END IF
    END IF
    LET l_rvb.rvb86 = l_rvb86
    LET l_rvb.rvb87 = l_rvb87
    IF l_rvb07s <> 0 THEN
       LET l_rvb.rvb87=0
    END IF
    LET l_rvb.rvb86 = l_rvb86
    LET l_rvb.rvb87 = l_rvb87
    IF l_rvb07s <> 0 THEN
       LET l_rvb.rvb87=0
    END IF
 
    SELECT azi03 INTO t_azi03 FROM azi_file WHERE azi01 = l_pmm22
    IF cl_null(l_rvb.rvb36) THEN 
       LET l_rvb.rvb36=" "
    END IF
    IF cl_null(l_rvb.rvb37) THEN 
       LET l_rvb.rvb37=" "
    END IF
    IF cl_null(l_rvb.rvb38) THEN 
       LET l_rvb.rvb38=" "
    END IF
    
    #TQC-8C0092
    LET l_rvb.rvb88 =l_rvb.rvb87 * l_rvb.rvb10
    LET l_rvb.rvb88t=l_rvb.rvb87 * l_rvb.rvb10t
    
    #不使用單價*數量=金額, 改以金額回推稅率, 以避免小數位差的問題
    SELECT gec07 INTO l_gec07 FROM gec_file,pmm_file
     WHERE gec01 = pmm21
       AND pmm01 = l_rvb.rvb04
       AND gec011='1'
    IF SQLCA.SQLCODE = 100 THEN
       LET g_errno='mfg3192'
       RETURN l_rvb.*
    END IF
    SELECT azi04 INTO t_azi04 
      FROM pmm_file,azi_file
     WHERE pmm22=azi01
       AND pmm01=l_rvb.rvb04
   #SELECT pmn07,pmn43 INTO l_rvb.rvb86,l_pmn43 FROM pmn_file
   # WHERE pmn01=l_rvb.rvb04
   #   AND pmn02=l_rvb.rvb03
 
    IF l_gec07='Y' THEN
       LET l_rvb.rvb88 = l_rvb.rvb88t / ( 1 + l_pmn43/100)
       LET l_rvb.rvb88 = cl_digcut(l_rvb.rvb88 , t_azi04)  
    ELSE
       LET l_rvb.rvb88t = l_rvb.rvb88 * ( 1 + l_pmn43/100)
       LET l_rvb.rvb88t = cl_digcut( l_rvb.rvb88t , t_azi04)  
    END IF
     
    RETURN l_rvb.*
END FUNCTION
 
#[
# Description....: 檢查實收數量正確性,並計算帶入相關欄位值
# Date & Author..: 2008/04/07 by kim
# Parameter......: p_cmd-固定傳'a'新增,l_rva-收貨單頭,l_rvb - 收貨單身
# Return.........: l_rvb-收貨單單身值 ; use g_errno 用來判斷是否檢查有誤
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_poreceiving_check_rvb07(p_cmd,l_rva,l_rvb)
   DEFINE p_cmd       LIKE type_file.chr1
   DEFINE l_rva       RECORD LIKE rva_file.*
   DEFINE l_rvb       RECORD LIKE rvb_file.*
   DEFINE l_pmn13     LIKE pmn_file.pmn13
   DEFINE l_pmn50_55  LIKE pmn_file.pmn50
   DEFINE l_pmn14     LIKE pmn_file.pmn14
   DEFINE l_pmn20     LIKE pmn_file.pmn20
   DEFINE l_pmn87     LIKE pmn_file.pmn87
   DEFINE l_pmn07     LIKE pmn_file.pmn07
   DEFINE l_alt06     LIKE alt_file.alt06
   DEFINE t_alt06     LIKE alt_file.alt06
   DEFINE l_rvb07     LIKE rvb_file.rvb07
   DEFINE l_rvb07_1   LIKE rvb_file.rvb07
   DEFINE l_rvb07_2   LIKE rvb_file.rvb07
   DEFINE l_rvb07_3   LIKE rvb_file.rvb07
 
   LET g_errno=NULL
   IF NOT cl_null(l_rvb.rvb07) THEN
      IF l_rvb.rvb07 <=0 THEN
         RETURN l_rvb.*
      END IF
      LET l_rvb.rvb08=l_rvb.rvb07
      IF p_cmd = 'a' THEN  #FUN-550195 add if 判斷 避免在修改狀態時,若原本的rvb08已輸入其它數量了,則又被復原跟rvb07一樣
          LET l_rvb.rvb08=l_rvb.rvb07
      END IF
 
#     SELECT pmn13,(pmn50-pmn55),pmn20,pmn14,pmn87,pmn07        #No.FUN-9A0068 mark
      SELECT pmn13,(pmn50-pmn55-pmn58),pmn20,pmn14,pmn87,pmn07  #No.FUN-9A0068   
        INTO l_pmn13,l_pmn50_55,l_pmn20,l_pmn14,l_pmn87,l_pmn07
        FROM pmn_file
       WHERE pmn01=l_rvb.rvb04
         AND pmn02=l_rvb.rvb03
      IF cl_null(l_pmn13) THEN   #超交率
         LET l_pmn13 = 0
      END IF
      IF cl_null(l_pmn50_55) THEN
         LET l_pmn50_55 = 0
      END IF
      IF cl_null(l_pmn20) THEN
         LET l_pmn20 = 0
      END IF
 
      SELECT SUM(rvb07) INTO l_rvb07_3 FROM rvb_file,rva_file
       WHERE rvb04=l_rvb.rvb04
         AND rvb03=l_rvb.rvb03
         AND rvaconf='N'
         AND rva01=rvb01
         AND rvb35='N'
         AND NOT (rvb01=l_rva.rva01 AND rvb02=l_rvb.rvb02)
      IF cl_null(l_rvb07_3) THEN
         LET l_rvb07_3 = 0
      END IF
 
      #計算已交量
      LET l_rvb07=l_pmn50_55+l_rvb07_3+l_rvb.rvb07
      LET l_rvb07_1=(l_pmn20*(100+l_pmn13))/100   #可交貨量
       LET l_rvb07_2=(l_pmn20*(100-l_pmn13))/100     #MOD-530021 #最少可交貨量
 
 
      #若為LC收貨，則須檢查數貨不可大於提單數量
      IF g_sma.sma41 = 'Y' AND l_rva.rva04='Y' THEN
         SELECT alt06 INTO l_alt06 FROM alt_file
          WHERE alt01=l_rvb.rvb22
            AND alt14=l_rvb.rvb04
            AND alt15=l_rvb.rvb03
         IF cl_null(l_alt06) THEN
            LET l_alt06 = 0
         END IF
         SELECT SUM(rvb07) INTO t_alt06 FROM rvb_file
          WHERE rvb22=l_rvb.rvb22
            AND rvb04=l_rvb.rvb04
            AND rvb03=l_rvb.rvb03
            AND rvb01!=l_rva.rva01
            AND rvb35='N'
         IF cl_null(t_alt06) THEN
            LET t_alt06 = 0
         END IF
         IF l_rvb.rvb07 > (l_alt06-t_alt06) THEN
            LET g_errno='apm-305'
            RETURN l_rvb.*
         END IF
      END IF
 
      IF l_pmn13 >= 0 THEN    #MODIFY 超短交控制
         IF l_pmn14 = 'N' THEN   #不能部份交貨, 超短交都控制
             IF l_rvb07_2 > l_rvb07 THEN #短交
               IF g_sma.sma85 MATCHES '[Rr]' THEN
                  LET g_errno='mfg3038'
                  RETURN l_rvb.*
               ELSE
                 #LET g_errno='mfg9120'  #整合不警告
               END IF
            END IF
            ###### 01/10/23 Tommy 樣品不檢查
            IF l_rvb.rvb35 = 'N' AND l_rva.rva10 != 'SUB' THEN  #委外不檢查超交
               IF l_rvb07_1 < l_rvb07 THEN #超交
                  IF g_sma.sma85 MATCHES '[Rr]'  THEN
                      LET g_errno='mfg3037'
                     RETURN l_rvb.*
                  ELSE
                    #LET g_errno='mfg9121' #整合不警告
                  END IF
               END IF
            END IF
            ###### End Tommy
         END IF
         IF l_pmn14 = "Y" THEN    #可部份交貨, 則僅控制超交
            ###### 01/10/23 Tommy 樣品不檢查
            IF l_rvb.rvb35 = 'N' AND l_rva.rva10 != 'SUB' THEN #CHI-6B0019委外不檢查超交
               IF l_rvb07_1 < l_rvb07 THEN #超交
                  IF g_sma.sma85 MATCHES '[Rr]' THEN
                      LET g_errno='mfg3037'
                     RETURN l_rvb.*
                  ELSE
                     #CALL cl_err(l_rvb07_1,'mfg9121',1) #整合不警告
                  END IF
               END IF
            END IF
            ###### End Tommy
         END IF
      END IF
 
      IF l_pmn13 < 0 THEN    #控制超短交
         IF l_pmn14 = 'N' THEN   #不能部份交貨
            IF l_rvb07 - l_pmn20 < 0 THEN      #須>= 訂購量
               LET g_errno='mfg3335'
               RETURN l_rvb.*
            END IF
         END IF
      END IF
 
      #委外暫不考慮
      #NO:4669-->確認之(收貨-退貨)
      #IF l_sfb39 != '2' THEN   #工單完工方式為'2' pull 不check min_set
      #  IF l_rva.rva10 ='SUB' AND l_rvb.rvb05=l_sfb05 THEN
      #   #-----------No.TQC-670091 modify
      #    #AND l_sfb93 != 'Y' THEN  #No.FUN-610101 add判斷走製程時不控管最小發料套數
      #     IF l_sfb93 = 'Y' THEN
      #        CALL t110_minp(l_rvb.rvb03,l_rvb.rvb04,
      #                       l_rvb.rvb34) RETURNING l_min_set
      #
      #       #--------------No.TQC-730059 add
      #        CALL s_umfchk(l_rvb.rvb05,l_pmn07,l_ima55)
      #             RETURNING g_i,l_fac
      #        IF g_i = 1 THEN
      #           #採購單位無法與料件的生產單位做換算,預設轉換率為1
      #           CALL cl_err(l_rvb.rvb05,'apm-120',1)
      #           LET l_fac = 1
      #        END IF
      #        LET l_min_set = l_min_set / l_fac
      #       #--------------No.TQC-730059 end
      #
      #        IF l_rvb.rvb07 > l_min_set THEN
      #           CALL cl_err(l_rvb.rvb07,'apm-307',1)
      #           RETURN l_rvb.*
      #        END IF
      #     ELSE
      #        IF l_rvb.rvb07>g_min_set THEN
      #           #委外實收數不可大於發料最小套數!
      #           CALL cl_err(l_rvb.rvb07,'apm-307',1)
      #           RETURN l_rvb.*
      #        END IF
      #     END IF
      #   #-----------No.TQC-670091 modify
      #  END IF
      #END IF
   END IF
 
   CALL aws_create_poreceiving_set_rvb87(l_rvb.*)
      RETURNING l_rvb.*
   IF g_sma.sma116 MATCHES '[02]' THEN
      LET l_rvb.rvb87 = l_rvb.rvb07
   END IF
   IF l_pmn20 = l_rvb.rvb07  THEN
      LET l_rvb.rvb87 = l_pmn87
   END IF
 
   IF cl_null(l_rvb.rvb86) THEN
      LET l_rvb.rvb86=l_pmn07
      LET l_rvb.rvb87=l_rvb.rvb07
   END IF
   RETURN l_rvb.*
END FUNCTION
 
FUNCTION aws_create_poreceiving_set_rvb87(l_rvb)
 DEFINE    l_item   LIKE img_file.img01,     #料號
           l_ima25  LIKE ima_file.ima25,     #ima單位
           l_ima44  LIKE ima_file.ima44,     #ima單位
           l_ima906 LIKE ima_file.ima906,
           l_fac2   LIKE img_file.img21,     #第二轉換率
           l_qty2   LIKE img_file.img10,     #第二數量
           l_fac1   LIKE img_file.img21,     #第一轉換率
           l_qty1   LIKE img_file.img10,     #第一數量
           l_tot    LIKE img_file.img10,     #計價數量
           l_factor LIKE ima_file.ima31_fac,
           l_cnt    LIKE type_file.num5
  DEFINE   l_rvb    RECORD LIKE rvb_file.*
  DEFINE   l_pmn07  LIKE pmn_file.pmn07
 
   SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
     FROM ima_file WHERE ima01=l_rvb.rvb05
   IF SQLCA.sqlcode = 100 THEN
      IF l_rvb.rvb05 MATCHES 'MISC*' THEN
         SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
           FROM ima_file WHERE ima01='MISC'
      END IF
   END IF
   IF cl_null(l_ima44) THEN LET l_ima44=l_ima25 END IF
 
   LET l_fac2=l_rvb.rvb84
   LET l_qty2=l_rvb.rvb85
   IF g_sma.sma115 = 'Y' THEN
      LET l_fac1=l_rvb.rvb81
      LET l_qty1=l_rvb.rvb82
   ELSE
      LET l_fac1=1
      LET l_qty1=l_rvb.rvb07
#     CALL s_umfchk(l_rvb.rvb04,l_rvb.rvb07,l_ima44)     #No.MOD-6B0162
      SELECT pmn07 INTO l_pmn07 FROM pmn_file
       WHERE pmn01=l_rbv.rbv04
         AND pmn02=l_rbv.rbv03
      CALL s_umfchk(l_rvb.rvb05,l_pmn07,l_ima44)     #No.MOD-6B0162
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
   CALL s_umfchk(l_rvb.rvb05,l_ima44,l_rvb.rvb86)
         RETURNING l_cnt,l_factor
   IF l_cnt = 1 THEN
      LET l_factor = 1
   END IF
   LET l_tot = l_tot * l_factor
 
   LET l_rvb.rvb87 = l_tot
   RETURN l_rvb.*
END FUNCTION
 
FUNCTION aws_create_poreceiving_get_rvb39(p_rvb04,p_rvb05,p_rvb19,p_rva05)
   DEFINE l_pmh08   LIKE pmh_file.pmh08,
          l_pmm22   LIKE pmm_file.pmm22,
          p_rvb04   LIKE rvb_file.rvb04,
          p_rvb05   LIKE rvb_file.rvb05,
          p_rvb19   LIKE rvb_file.rvb19,
          l_rvb39   LIKE rvb_file.rvb39
   DEFINE l_ima915  LIKE ima_file.ima915
   DEFINE p_rva05   LIKE rva_file.rva05
 
  #IF g_sma.sma63='1' THEN #料件供應商控制方式,1: 需作料件供應商管制
  #                        #                   2: 不作料件供應商管制
  #料件供應商控制方式: 0.不管制、1.請購單需管制、2.採購單需管制、3.二者皆需管制       
   SELECT ima915 INTO l_ima915 FROM ima_file
    WHERE ima01=p_rvb05
 
   IF l_ima915='2' OR l_ima915='3' THEN
      SELECT pmm22 INTO l_pmm22 FROM pmm_file
       WHERE pmm01=p_rvb04
 
      SELECT pmh08 INTO l_pmh08 FROM pmh_file
       WHERE pmh01=p_rvb05
         AND pmh02=p_rva05
         AND pmh13=l_pmm22
         AND pmhacti = 'Y'                                           #CHI-910021
 
      IF cl_null(l_pmh08) THEN
         LET l_pmh08 = 'N'
      END IF
 
      IF p_rvb05[1,4] = 'MISC' THEN
         LET l_pmh08='N'
      END IF
   ELSE
      SELECT ima24 INTO l_pmh08 FROM ima_file
       WHERE ima01=p_rvb05
 
      IF cl_null(l_pmh08) THEN
         LET l_pmh08 = 'N'
      END IF
 
      IF p_rvb05[1,4] = 'MISC' THEN
         LET l_pmh08='N'
      END IF
   END IF
 
   IF l_pmh08='N' OR     #免驗料
      (g_sma.sma886[6,6]='N' AND g_sma.sma886[8,8]='N') OR #視同免驗
      p_rvb19='2' THEN #委外代買料
      LET l_rvb39 = 'N'
   ELSE
      LET l_rvb39 = 'Y'
   END IF
 
   RETURN l_rvb39
 
END FUNCTION
 
#檢查料件編號有無存在ima_file & pmn_file
FUNCTION aws_create_poreceiving_check_rvb05(l_rvb)
   DEFINE l_rvb RECORD LIKE rvb_file.*
   DEFINE l_cnt LIKE type_file.num5
   
   LET g_errno=NULL
   
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM pmn_file,ima_file
    WHERE pmn01 = l_rvb.rvb04
      AND pmn02 = l_rvb.rvb03
      AND pmn04 = l_rvb.rvb05
      AND ima01 = pmn04
   IF l_cnt=0 THEN
      LET g_errno='apm-921'
   END IF
   #for GP5.1
   IF NOT cl_null(l_rvb.rvb05) THEN    
      SELECT COUNT(*) INTO l_cnt FROM ima_file
        WHERE ima01 = l_rvb.rvb05
          AND imaacti='Y'
          AND ima151 != 'Y'
      IF l_cnt = 0 THEN 
         LET g_errno='apm-452'
      END IF 
   END IF
END FUNCTION
 
FUNCTION aws_create_poreceiving_check_rvb36(l_rva,l_rvb)
   DEFINE l_rva RECORD LIKE rva_file.*
   DEFINE l_rvb RECORD LIKE rvb_file.*
   DEFINE l_imf04 LIKE imf_file.imf04
   DEFINE l_imf05 LIKE imf_file.imf05
   DEFINE sn1,sn2,l_cnt   LIKE type_file.num5
   DEFINE l_pmn38 LIKE pmn_file.pmn38
 
   IF cl_null(l_rvb.rvb36) THEN LET l_rvb.rvb36=' ' END IF
   IF cl_null(l_rvb.rvb37) THEN LET l_rvb.rvb37=' ' END IF
   IF cl_null(l_rvb.rvb38) THEN LET l_rvb.rvb38=' ' END IF
   IF NOT cl_null(l_rvb.rvb36) THEN
      #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
      IF NOT s_chksmz(l_rvb.rvb05, l_rva.rva01,
                      l_rvb.rvb36, l_rvb.rvb37) THEN
         RETURN l_rvb.*
      END IF
      #------>check-1  檢查該料是否可收至該倉/儲位
      IF NOT s_imfchk(l_rvb.rvb05,l_rvb.rvb36,
                      l_rvb.rvb37) THEN
         LET g_errno='mfg6095'
         RETURN l_rvb.*
      END IF
      #------>check-2  檢查該倉庫/儲位是否存在
      IF l_rvb.rvb37 IS NOT NULL THEN
         CALL s_hqty(l_rvb.rvb05,l_rvb.rvb36,
                     l_rvb.rvb37)
              RETURNING l_cnt,l_imf04,l_imf05
         IF l_imf04 IS NULL THEN
            LET l_imf04 = 0
         END IF
         CALL s_lwyn(l_rvb.rvb36,l_rvb.rvb37)
              RETURNING sn1,sn2    #可用否
         SELECT pmn38 INTO l_pmn38 FROM pmn_file
          WHERE pmn01=l_rvb.rvb04
            AND pmn02=l_rvb.rvb03
         IF sn2 = 2 THEN
            IF l_pmn38 = 'Y' THEN
               LET g_errno='mfg9132'
            END IF
         ELSE
            IF l_pmn38 = 'N' THEN
               LET g_errno='mfg9131'
            END IF
         END IF
         LET sn1=0 LET sn2=0
      END IF
   END IF
   RETURN l_rvb.*
END FUNCTION
