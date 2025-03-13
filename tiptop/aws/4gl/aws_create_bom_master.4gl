# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_bom_master.4gl
# Descriptions...: 提供建立 BOM 資料的服務
# Date & Author..: 2008/11/03 by kevin
# Memo...........:
# Modify.........: NO.FUN-890113 08/11/03 By kevin  多筆傳送
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
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
FUNCTION aws_create_bom_master()
 
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增 BOM 資料                                                           #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_bom_master_process()
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
FUNCTION aws_create_bom_master_process()
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
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("bma_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
    
    LET l_sql = "SELECT * FROM bma_file WHERE bma01 = ?  AND bma06 = ? FOR UPDATE"
    LET l_sql=cl_forupd_sql(l_sql)

    DECLARE i600_cl CURSOR FROM l_sql
 
#    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
   
 
    BEGIN WORK
 
    FOR l_i = 1 TO l_cnt1       
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "bma_file")        #目前處理單檔的 XML 節點
        
        LET g_bma01 = aws_ttsrv_getRecordField(l_node1, "bma01")         #取得此筆單檔資料的欄位值
        LET g_bma06 = aws_ttsrv_getRecordField(l_node1, "bma06")
        IF g_bma06 IS NULL THEN        # KEY 不可空白
            LET g_bma06 = ' '
        END IF
 
        
        #----------------------------------------------------------------------#
        # 判斷此資料是否已經建立, 若已建立則為 Update                          #
        #----------------------------------------------------------------------#
        SELECT COUNT(*) INTO l_cnt FROM bma_file 
         WHERE bma01 = g_bma01 AND bma06 = g_bma06
 
        IF NOT aws_create_bom_data_default(l_node1,l_cnt) THEN   #檢查 BOM 欄位預設值           
           EXIT FOR
        END IF
 
        IF l_cnt = 0 THEN
           #-------------------------------------------------------------------#
           # RECORD資料傳到NODE                                                #
           #-------------------------------------------------------------------#
           CALL aws_ttsrv_setRecordField_record(l_node1,base.Typeinfo.create(g_bma))
           IF g_bma.bma06 IS NULL OR cl_null(g_bma.bma06) THEN        # KEY 不可空白
               LET g_bma.bma06 = ' '
               CALL aws_ttsrv_setRecordField(l_node1, "bma06", ' ')
           END IF
 
           LET l_sql = aws_ttsrv_getRecordSql(l_node1, "bma_file", "I", NULL)   #I 表示取得 INSERT SQL
        ELSE
           CALL aws_ttsrv_setRecordField(l_node1, "bmamodu", g_user)
           CALL aws_ttsrv_setRecordField(l_node1, "bmadate", g_today)
           IF g_bma.bma06 IS NULL OR cl_null(g_bma.bma06) THEN        # KEY 不可空白
               LET g_bma.bma06 = ' '
               CALL aws_ttsrv_setRecordField(l_node1, "bma06", ' ')
           END IF
 
 
           LET l_wc = " bma01 = '", g_bma01 CLIPPED, "' ",                  #UPDATE SQL 時的 WHERE condition
                      " AND bma06='",g_bma06 CLIPPED,"' "
           LET l_sql = aws_ttsrv_getRecordSql(l_node1, "bma_file", "U", l_wc)   #U 表示取得 UPDATE SQL
 
           #-------------------------------------------------------------------#
           # 鎖住將被更改或取消的資料                                          #
           #-------------------------------------------------------------------#
           IF NOT aws_create_bom_updchk() THEN
              EXIT FOR
           END IF
 
        END IF
    
        #----------------------------------------------------------------------#
        # 執行單頭 INSERT / UPDATE SQL                                         #
        #----------------------------------------------------------------------#
        EXECUTE IMMEDIATE l_sql
        IF SQLCA.SQLCODE THEN
           LET g_status.code = SQLCA.SQLCODE
           LET g_status.sqlcode = SQLCA.SQLCODE
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
# Description....: 鎖住將被更改或取消的資料
# Date & Author..: 2008/07/04 by Echo
# Parameter......: none
# Return.........: l_status - INTEGER - TRUE / FALSE Luck 結果
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_bom_updchk()
DEFINE l_bma   RECORD LIKE bma_file.*       #主件料件
 
  OPEN i600_cl USING g_bma01,g_bma06
  IF STATUS THEN
     LET g_status.code = STATUS
     CLOSE i600_cl
     RETURN FALSE
  END IF
  FETCH i600_cl INTO l_bma.*             # 鎖住將被更改或取消的資料
  IF SQLCA.sqlcode THEN
     LET g_status.code = SQLCA.SQLCODE   # 資料被他人LOCK
     LET g_status.sqlcode = SQLCA.SQLCODE
     CLOSE i600_cl
     RETURN FALSE
  END IF
  RETURN TRUE
END FUNCTION
 
#[
# Description....:  BOM 設定單頭欄位預設值
# Date & Author..: 2008/07/04 by Echo
# Parameter......: p_node   - om.DomNode - BOM 單頭 XML 節點 
#                : p_cnt    - INTEGER    - 資料是否已存在，0:新增
# Return.........: l_status - INTEGER    - TRUE / FALSE 預設值檢查結果
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_bom_data_default(p_node,p_cnt)
    DEFINE p_node      om.DomNode,
           p_cnt       LIKE type_file.num10
    DEFINE l_bma05     LIKE bma_file.bma05
    DEFINE l_bma10     LIKE bma_file.bma10
    DEFINE l_flag      LIKE type_file.chr1
    DEFINE l_imaacti   LIKE ima_file.imaacti
 
    LET g_bma.bma01 = g_bma01
    LET g_bma.bma06 = g_bma06
 
    LET g_bma.bma08 = aws_ttsrv_getRecordField(p_node,"bma08")     #資料來源
    LET g_bma.bmaacti = aws_ttsrv_getRecordField(p_node,"bmaacti") #資料有效否
 
    IF g_bma.bma01 IS NULL THEN
       LET g_status.code = "mfg2634"   #主件料件為 NULL
       RETURN FALSE
    END IF
    IF g_bma.bmaacti ='N' THEN   
       LET g_status.code = "mfg1000"     #資料為無效資料, 不可更改
       RETURN FALSE
    END IF
 
    CALL s_field_chk(g_bma.bma01,'2',g_plant,'bma01') RETURNING l_flag
    IF l_flag = '0' THEN
       LET g_status.code = "aoo-043"   #違反aooi601中欄位新增值設定
       RETURN FALSE
    END IF
 
    SELECT imaacti,ima08 INTO l_imaacti,g_ima08_h 
      FROM ima_file WHERE ima01 = g_bma.bma01
    CASE 
       WHEN SQLCA.SQLCODE = 100  
          LET g_status.code = 'mfg2602'     #無此主件料號
          RETURN FALSE
       WHEN l_imaacti='N' 
          LET g_status.code = '9028'        #此筆資料已無效, 不可使用
          RETURN FALSE
       WHEN l_imaacti  MATCHES '[PH]'
          LET g_status.code = '9038'        #此筆資料的狀況碼非"確認",不可使用!
          RETURN FALSE
    END CASE
 
    IF g_ima08_h ='Z' THEN 
        LET g_status.code = 'mfg2752'       #此料件為Z:雜項料件
        RETURN FALSE
    END IF
 
    #--------------------------------------------------------------------------#
    # 若 p_cnt > 0 ,則表示此資料已建立，必須進行資料控管                       #
    #--------------------------------------------------------------------------#
    display "cnt:",p_cnt
    IF p_cnt = 0 THEN
 
       IF g_bma.bma08 IS NULL THEN        
          LET g_bma.bma08=g_plant            
       END IF
 
       LET g_bma.bma05=''
       LET g_bma.bma03=''
       LET g_bma.bmauser=g_user
       LET g_bma.bmaoriu = g_user #FUN-980030
       LET g_bma.bmaorig = g_grup #FUN-980030
       LET g_bma.bmagrup=g_grup
       LET g_bma.bmadate=g_today
       LET g_bma.bmaacti='Y'              #資料有效
       LET g_bma.bma09=0                  #拋轉次數            
       LET g_bma.bma10 = '0'              #狀態碼
 
    ELSE
       IF NOT s_dc_ud_flag('2',g_bma.bma08,g_plant,'u') THEN
          LET g_status.code = "aoo-045"   #參數設定:不可修改其他營運中心拋轉過來的資料
          RETURN FALSE
       END IF
       SELECT bma05,bma10 INTO l_bma05,l_bma10 FROM bma_file 
        WHERE bma01 = g_bma.bma01 AND bma06 = g_bma.bma06
 
       IF l_bma10 <> '0' THEN
          LET g_status.code = "aim1006"   #此筆資料已確認不可修改!
          RETURN FALSE
       END IF
       IF NOT cl_null(l_bma05) AND g_sma.sma101 = 'N' THEN
          IF g_ima08_h MATCHES '[MPXTS]' THEN  #單頭料件來源碼='MPXT'才control
             LET g_status.code = "abm-120"   #BOM表發放後,不可以修改單身
             RETURN FALSE
          END IF
       END IF
    END IF 
 
    RETURN TRUE
END FUNCTION
