# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_bom_detail.4gl
# Descriptions...: 提供建立 BOM 資料的服務
# Date & Author..: 2008/11/03 by kevin
# Memo...........:
# Modify.........: NO.FUN-890113 08/11/03 By kevin  多筆傳送
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-AB0038 11/07/05 By Mandy 單身項次為4時程序會卡死
# Modify.........: No.CHI-D10044 13/03/04 By bart s_uima146()參數變更

DATABASE ds
 
#FUN-890113
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
DEFINE g_bma01    LIKE bma_file.bma01,
       g_bma06    LIKE bma_file.bma06
DEFINE g_bma      RECORD LIKE bma_file.*       #主件料件
DEFINE g_bmb      RECORD LIKE bmb_file.*
DEFINE g_ima08_h  LIKE ima_file.ima08        
DEFINE g_ima08_b  LIKE ima_file.ima08        
 
#[
# Description....: 提供建立 BOM 資料的服務(入口 function)
# Date & Author..: 2007/02/09 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_bom_detail()
 
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增 BOM 資料                                                           #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_bom_detail_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 依據傳入資訊新增 ERP  BOM 資料
# Date & Author..: 2007/02/09 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_bom_detail_process()
    DEFINE l_i        LIKE type_file.num10,
           l_j        LIKE type_file.num10
    DEFINE l_sql      STRING        
    DEFINE l_wc       STRING        
    DEFINE l_cnt      LIKE type_file.num10,
           l_cnt1     LIKE type_file.num10,
           l_cnt2     LIKE type_file.num10
    DEFINE l_node1    om.DomNode,
           l_node2    om.DomNode
    DEFINE l_flag     LIKE type_file.num10
    
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的 BOM 資料                                        #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("bmb_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF    
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
 
    CALL s_decl_bmb()
 
    BEGIN WORK
 
    FOR l_j = 1 TO l_cnt1       
        LET l_node2 = aws_ttsrv_getMasterRecord(l_j, "bmb_file")        #目前處理單檔的 XML 節點
        
        LET g_bmb.bmb01 = aws_ttsrv_getRecordField(l_node2, "bmb01")         #取得此筆單檔資料的欄位值
        LET g_bmb.bmb29 = aws_ttsrv_getRecordField(l_node2, "bmb29")
        IF g_bmb.bmb29 IS NULL THEN        # KEY 不可空白
            LET g_bmb.bmb29 = ' '
        END IF
 
        
        #----------------------------------------------------------------------#
        # 判斷此資料單頭是否已經建立                                           #
        #----------------------------------------------------------------------#
        SELECT COUNT(*) INTO l_cnt FROM bma_file 
         WHERE bma01 = g_bmb.bmb01 AND bma06 = g_bmb.bmb29
 
        IF l_cnt = 0 THEN
        	 LET g_status.code = "-2"
           LET g_status.description = "No BOM header !"
           EXIT FOR        	 
        END IF 
 
            #------------------------------------------------------------------#
            # 單身檔(bmb_file) Insert 動作                                     #
            #------------------------------------------------------------------#
            IF l_j = 1 THEN
               CALL aws_create_bom_b_delete()
               
               SELECT * INTO g_bma.* FROM bma_file 
                WHERE bma01 = g_bmb.bmb01 AND bma06 = g_bmb.bmb29
            END IF
 
            IF NOT aws_create_bom_b_default(l_node2) THEN   #檢查 BOM 單身欄位預設值           
               EXIT FOR
            END IF
 
            #-------------------------------------------------------------------#
            # RECORD資料傳到NODE                                                #
            #-------------------------------------------------------------------#
            #CALL aws_ttsrv_setRecordField_record(l_node2,base.Typeinfo.create(g_bmb))
            
            IF g_bmb.bmb29 IS NULL OR cl_null(g_bmb.bmb29) THEN        # KEY 不可空白
                LET g_bmb.bmb29 = ' '
                CALL aws_ttsrv_setRecordField(l_node2, "bmb29", ' ')
            END IF
            IF g_bmb.bmb30 IS NULL OR cl_null(g_bmb.bmb30) THEN 
               IF g_sma.sma118 != 'Y' THEN
                   LET g_bmb.bmb30 = ' '
                   CALL aws_ttsrv_setRecordField(l_node2, "bmb30", ' ')
               ELSE
                   LET g_bmb.bmb30 = '1'
                   CALL aws_ttsrv_setRecordField(l_node2, "bmb30", '1')
               END IF
            END IF
 
            LET l_sql = aws_ttsrv_getRecordSql(l_node2, "bmb_file", "I", NULL)   #I 表示取得 INSERT SQL
 
            #------------------------------------------------------------------#
            # 執行單身 INSERT SQL                                              #
            #------------------------------------------------------------------#
            EXECUTE IMMEDIATE l_sql
            IF SQLCA.SQLCODE THEN
               LET g_status.code = SQLCA.SQLCODE
               LET g_status.sqlcode = SQLCA.SQLCODE
               EXIT FOR
            END IF
 
            IF g_sma.sma845='Y' THEN  #低階碼可否部份重計
                LET g_success='Y'
                #CALL s_uima146(g_bmb.bmb03)  #CHI-D10044
                CALL s_uima146(g_bmb.bmb03,0)  #CHI-D10044
                IF g_success='N' THEN
                   LET g_status.code = 'abm-002'
                   EXIT FOR
                END IF
            END IF
      
        IF g_status.code != "0" THEN   #如果單身處理有任何錯誤, 則離開
           EXIT FOR
        END IF
        
    END FOR
    
    #全部處理都成功才 COMMIT WORK
    IF g_status.code = "0" THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
    
END FUNCTION
 
#[
# Description....:  BOM 設定單身欄位預設值
# Date & Author..: 2008/07/04 by Echo
# Parameter......: p_node   - om.DomNode - BOM 單身 XML 節點 
#                : p_cnt    - INTEGER    - 資料是否已存在，0:新增
# Return.........: l_status - INTEGER    - TRUE / FALSE 預設值檢查結果
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_bom_b_default(p_node)
    DEFINE p_node      om.DomNode
           #p_cnt       LIKE type_file.num10
    DEFINE l_imaacti   LIKE ima_file.imaacti
    DEFINE l_ima140    LIKE ima_file.ima140
    DEFINE l_ima1401   LIKE ima_file.ima1401
    DEFINE l_ima151   LIKE ima_file.ima151
  
 
    LET g_bmb.bmb02 = aws_ttsrv_getRecordField(p_node,"bmb02")    
    LET g_bmb.bmb03 = aws_ttsrv_getRecordField(p_node,"bmb03")    
    LET g_bmb.bmb04 = aws_ttsrv_getRecordField(p_node,"bmb04")    
    LET g_bmb.bmb05 = aws_ttsrv_getRecordField(p_node,"bmb05")    
    LET g_bmb.bmb30 = aws_ttsrv_getRecordField(p_node,"bmb30") 
 
    SELECT imaacti,ima08,ima140,ima1401,ima151 
      INTO l_imaacti,g_ima08_b,l_ima140,l_ima1401,l_ima151
      FROM ima_file WHERE ima01 = g_bmb.bmb03
    CASE
       WHEN SQLCA.SQLCODE = 100
          LET g_status.code = 'mfg2602'     #無此主件料號
          RETURN FALSE
       WHEN l_imaacti='N'
          LET g_status.code = '9028'        #此筆資料已無效, 不可使用
       WHEN l_imaacti  MATCHES '[PH]'
          LET g_status.code = '9038'        #此筆資料的狀況碼非"確認",不可使>
          RETURN FALSE
    END CASE
 
    IF g_ima08_b ='Z' THEN
        LET g_status.code = 'mfg2752'       #此料件為Z:雜項料件
        RETURN FALSE
    END IF
 
    IF l_ima140  ='Y' AND l_ima1401 <= g_today THEN
       LET g_status.code = 'aim-809'        #料件已Phase Out! 
       RETURN FALSE
    END IF
 
    IF s_bomchk(g_bma.bma01,g_bmb.bmb03,g_ima08_h,g_ima08_b) THEN
       LET g_status.code = g_errno
       RETURN FALSE
    END IF
 
    IF s_industry('slk') THEN     #FUN-AB0038 add if 判斷
       #IF g_bmb.bmb02 = '1' THEN #FUN-AB0038 mark
        IF g_bmb.bmb30 = '1' THEN #FUN-AB0038 add
          IF  l_ima151 = 'Y' THEN
             LET g_status.code = "abm-645"       #單身計算方式若選擇款式,元件料號字段應只可輸入母料件
             RETURN FALSE
          END IF
        END IF
       #IF g_bmb.bmb02 = '4' THEN #FUN-AB0038 mark
        IF g_bmb.bmb30 = '4' THEN #FUN-AB0038 add
          IF  l_ima151 <> 'Y' THEN
             LET g_status.code = "abm-646"       #單身計算方式若選擇固定，只可輸入非母料件的一般料件
             RETURN FALSE
          END IF
        END IF
    END IF #FUN-AB0038 add
 
    IF g_bmb.bmb05 < g_bmb.bmb04 THEN
       LET g_status.code = "mfg2604"         #失效日期不可小於生效日期
       RETURN FALSE
    END IF
 
    RETURN TRUE
END FUNCTION
 
 
#[
# Description....: 刪除 BOM 單身相關資料 
# Date & Author..: 2008/07/04 by Echo
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_bom_b_delete()
 
    DELETE FROM bmb_file
       WHERE bmb01 = g_bmb.bmb01 AND bmb29 = g_bmb.bmb29
 
    DELETE FROM bmt_file
       WHERE bmt01 = g_bmb.bmb01 AND bmt08 = g_bmb.bmb29
 
END FUNCTION
 
