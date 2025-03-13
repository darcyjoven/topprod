# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_plm_bom_data.4gl
# Descriptions...: 提供建立 BOM 資料的服務
# Date & Author..: 2011/02/09 by Mandy
# Memo...........:
# Modify.........: 新建立 FUN-B20003
# Modify.......... No.FUN-B30104 11/03/29 By Mandy aws_diff_bmt() #在比對BOM 插件位置資料(bmt_file)時,需加上生效日期(bmt04)條件
# Modify.........: No:MOD-B50214 11/05/25 By Abby  增加取得bmb10_fac,bmb10_fac2欄位值
#}
# Modify.........: No:FUN-B20003 11/07/05 By Mandy PLM GP5.1追版至GP5.25以上為GP5.1單號----------
# Modify.........: No:FUN-D10092 13/01/23 By Abby  PLM GP5.3追版str------------------------------
# Modify.........: No:FUN-B70076 11/07/21 By Mandy (1)bmy_file NOT NULL的欄位給default
#                                                  (2)bmy25 若s_chk_ware() 檢查不過,則bmy25給''
#                                                  (3) 給bmb081,bmb082 default
# Modify.........: No:FUN-C20081 12/02/14 By Mandy PLM BOM項次一致問題
# Modify.........: No:DEV-C40005 12/04/26 By Mandy 調整CreatePLMBOMData,刪除BOM時的處理
# Modify.........: No:DEV-C40005 12/04/27 By Mandy FOR DigiWinPLM整合
# Modify.........: No:FUN-C50033 12/05/08 By Mandy 因應abmi720_sub在確認段會檢查新增元件相關欄位不可空白的控管(abm-093),故增加相關欄位的預設
# Modify.........: No:FUN-C50033(2)                PLM BOM項次一致問題,判斷比對BOM單身資料是否為新增的條件KEY值改為PLM KEY + 元件
# Modify.........: No.TQC-C50229 12/05/31 By Mandy (1)錯誤訊息顯示的加強
#                                                  (2)當第一次拋BOM資料時,增加處理"BOM單身bmb_file合理性判斷"
# Modify.........: No.FUN-C70063 12/07/16 By Mandy 變動損耗率%(bmb08) 若PLM不拋值過來,原本程式會預設1,調整改為0
# Modify.........: No.FUN-C70083 12/07/19 By Mandy (1)程式在判斷失效時有誤,目前僅用元件(bmb03)判斷,未加上PLM KEY(bmb37)
#                                                  (2)元件僅異動PLM BOM項次(bmb36)時,未異動成功
# Modify.........: No:TQC-C80022 12/08/06 By Abby  新增了NOT NULL欄位(bmy35),故增加相關欄位的預設
# Modify.........: No:FUN-D10092 13/01/23 By Abby  PLM GP5.3追版end------------------------------
# Modify.........: No:FUN-D20018 13/02/05 By Abby  PLM BOM項次欄位bmy36改成bmy361
# Modify.........: No.CHI-D10044 13/03/04 By bart s_uima146()參數變更
# Modify.........: No:FUN-D40103 13/05/09 By lixh1 增加儲位有效性檢查

DATABASE ds

#FUN-850147

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

DEFINE g_bma01       LIKE bma_file.bma01,
       g_bma06       LIKE bma_file.bma06
DEFINE g_bma         RECORD LIKE bma_file.*       #主件料件
DEFINE g_bmb         RECORD LIKE bmb_file.*
DEFINE g_bmx         RECORD LIKE bmx_file.*       #ECN單頭
DEFINE g_bmy         RECORD LIKE bmy_file.*       #ECN單身
DEFINE g_bmw         RECORD LIKE bmw_file.*       #ECN插件位置
DEFINE g_ima08_h     LIKE ima_file.ima08        
DEFINE g_ima08_b     LIKE ima_file.ima08
DEFINE g_bmt         RECORD LIKE bmt_file.*
DEFINE g_msg         STRING                
DEFINE g_msg_flag    LIKE type_file.chr20  
DEFINE g_ins_bmx_ok  LIKE type_file.chr1
DEFINE g_ecn         LIKE type_file.chr1
DEFINE g_del_bom     LIKE type_file.chr1 #DEV-C40005 add "Y":代表單階BOM要做刪除
DEFINE g_smyslip     LIKE smy_file.smyslip
DEFINE g_bmx10       LIKE bmx_file.bmx10
DEFINE g_plm_bmt_cnt LIKE type_file.num10
DEFINE g_diff_bmt    LIKE type_file.chr1
DEFINE g_upd_bmb09   LIKE type_file.chr1
DEFINE g_upd_bmb11   LIKE type_file.chr1
DEFINE g_upd_bmb25   LIKE type_file.chr1
DEFINE g_upd_bmb26   LIKE type_file.chr1


#[
# Description....: 提供建立 BOM 資料的服務(入口 function)
# Date & Author..: 2011/02/09 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_plm_bom_data()
 
    
    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增 BOM 資料                                                           #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_plm_bom_data_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION


#[
# Description....: 依據傳入資訊新增 ERP  BOM 資料
# Date & Author..: 2011/02/09 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_plm_bom_data_process()
    DEFINE l_i        LIKE type_file.num10,
           l_j        LIKE type_file.num10
    DEFINE l_sql      STRING        
    DEFINE l_wc       STRING        
    DEFINE l_cnt      LIKE type_file.num10,
           l_cnt1     LIKE type_file.num10,
           l_cnt2     LIKE type_file.num10,
           l_cnt3     LIKE type_file.num10
    DEFINE l_node1    om.DomNode,
           l_node2    om.DomNode
    DEFINE l_flag     LIKE type_file.num10
    DEFINE l_status  LIKE type_file.chr1     
    DEFINE l_commit  LIKE type_file.chr1     
    DEFINE l_msg     STRING                  
    DEFINE l_return   RECORD                           #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                         bmx01   STRING                #回傳的欄位名稱
                      END RECORD
    DEFINE l_acttype LIKE type_file.chr3 #DEV-C40005 add #當欲刪除BOM時,則欄位值為"DEL"
    DEFINE l_description STRING          #TQC-C50229 add
    
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的 BOM 資料                                         #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("bma_file")    
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
    
    LET l_sql =
       "SELECT * FROM bma_file WHERE bma01 = ?  AND bma06 = ? FOR UPDATE " #FUN-B20003(110705) mod
    LET l_sql = cl_forupd_sql(l_sql)                                       #FUN-B20003(110705) add
    DECLARE i600_cl CURSOR FROM l_sql

    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'

    CALL s_decl_bmb()
    #建立臨時表,用于存放拋轉的資料
    CALL s_dc_cre_temp_table("bma_file") RETURNING g_dc_tabname_bma
    
    #建立歷史資料拋轉的臨時表
    CALL s_dc_cre_temp_table("gex_file") RETURNING g_dc_hist_tab

    #建立臨時表,用于存放拋轉的資料
    CALL s_dc_cre_temp_table("bmx_file") RETURNING g_dc_tabname_bmx

    # 建立本程式所有會用到的TEMP TABLE
    CALL aws_plm_cre_tmp()          

    LET g_ins_bmx_ok = 'N'

    BEGIN WORK

    LET l_status = aws_ttsrv_getParameter("status")                 
    LET g_smyslip= aws_ttsrv_getParameter("smyslip")                 
    LET g_bmx10  = aws_ttsrv_getParameter("bmx10")                 
    DISPLAY "測試啦!!!"
    LET g_return_keyno = NULL   #DEV-C40005 add
    FOR l_i = 1 TO l_cnt1       
        DELETE FROM plm_bmb WHERE 1=1
        LET g_ecn = 'N'
        LET l_commit = 'N' 
        LET g_msg_flag = 'bma_file' 
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "bma_file")        #目前處理單檔的 XML 節點
        LET g_bma01 = aws_ttsrv_getRecordField(l_node1, "bma01")        #取得此筆單檔資料的欄位值
        LET g_bma06 = aws_ttsrv_getRecordField(l_node1, "bma06")
        #DEV-C40005--add----str---
        LET l_acttype= aws_ttsrv_getRecordField(l_node1,"acttype") 
        IF NOT cl_null(l_acttype) AND l_acttype = 'DEL' THEN
            LET g_del_bom = 'Y'
        ELSE
            LET g_del_bom = 'N'
        END IF
        #DEV-C40005--add----end---
        IF g_bma06 IS NULL THEN        # KEY 不可空白
            LET g_bma06 = ' '
        END IF


        #----------------------------------------------------------------------#
        # 判斷此資料是否已經建立, 
        # 若已建立BOM 未發放則為 Update                          #
        # 若          已發放則走 ECN
        #----------------------------------------------------------------------#
        SELECT COUNT(*) INTO l_cnt FROM bma_file 
         WHERE bma01 = g_bma01 
           AND bma06 = g_bma06
        IF l_cnt > 0 THEN
           LET l_cnt3 = 0
           SELECT COUNT(*) INTO l_cnt3 FROM bma_file
            WHERE bma01 = g_bma01 
              AND bma06 = g_bma06
              AND bma10 = '2' #發放
           IF l_cnt3 > 0 THEN
               LET g_ecn = 'Y' #走ECN
               INITIALIZE g_bma.* TO NULL
               SELECT * INTO g_bma.* FROM bma_file 
                WHERE bma01 = g_bma01 
                  AND bma06 = g_bma06
           END IF
        END IF

        IF g_ecn = 'N' THEN
            IF NOT aws_create_plm_bom_data_default(l_node1,l_cnt) THEN   #檢查 BOM 欄位預設值           
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
               IF NOT aws_create_plm_bom_updchk() THEN
                  EXIT FOR
               END IF
            
            END IF
            
            IF g_del_bom = 'N' THEN #DEV-C40005 add if 判斷
                #----------------------------------------------------------------------#
                # 執行單頭 INSERT / UPDATE SQL                                         #
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
                LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "bmb_file")       #取得目前單頭共有幾筆單身資料
                IF l_cnt2 = 0 THEN
                   LET g_status.code = "mfg-009"   #必須有單身資料
                   EXIT FOR
                END IF
                LET g_msg_flag = 'bmb_file'    
                FOR l_j = 1 TO l_cnt2
                    LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "bmb_file")   #目前單身的 XML 節點
               
                    INITIALIZE g_bmb.* TO NULL      #FUN-C20081 add
                    LET g_bmb.bmb01 = g_bma.bma01
                    LET g_bmb.bmb29 = g_bma.bma06
                    #------------------------------------------------------------------#
                    # 單身檔(bmb_file) Insert 動作                                     #
                    #------------------------------------------------------------------#
                    IF l_j = 1 THEN
                       CALL aws_create_plm_bom_b_delete()
                    END IF 
                
                    IF NOT aws_create_plm_bom_b_default(l_node2,l_cnt) THEN   #檢查 BOM 單身欄位預設值           
                       EXIT FOR
                    END IF
                
                    #-------------------------------------------------------------------#
                    # RECORD資料傳到NODE                                                #
                    #-------------------------------------------------------------------#
                    CALL aws_ttsrv_setRecordField_record(l_node2,base.Typeinfo.create(g_bmb))
                    CALL aws_ttsrv_setRecordField(l_node2, "bmb10",g_bmb.bmb10 )
                    IF g_bmb.bmb01 IS NULL OR cl_null(g_bmb.bmb01) THEN        # KEY 不可空白
                        LET g_bmb.bmb01 = g_bma.bma01
                        CALL aws_ttsrv_setRecordField(l_node2, "bmb01",g_bmb.bmb01 )
                    END IF
                    IF g_bmb.bmb29 IS NULL OR cl_null(g_bmb.bmb29) THEN        # KEY 不可空白
                        LET g_bmb.bmb29 = g_bma.bma06
                        CALL aws_ttsrv_setRecordField(l_node2, "bmb29", g_bmb.bmb29)
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
               
                    CALL aws_ttsrv_setRecordField(l_node2, "bmb10_fac",g_bmb.bmb10_fac)   #MOD-B50214 add
                    CALL aws_ttsrv_setRecordField(l_node2, "bmb10_fac2",g_bmb.bmb10_fac2) #MOD-B50214 add
                
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
                END FOR
                IF g_status.code <> '0' THEN
                    EXIT FOR
                END IF
                
                #----------------------------------------------------------------------#
                # 處理第二單身插件位置資料(bmt_file)                                   #
                #----------------------------------------------------------------------#
                LET g_msg_flag = 'bmt_file'     
                LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "bmt_file")       #取得目前單頭共有幾筆單身資料
                
                FOR l_j = 1 TO l_cnt2
                    LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "bmt_file")   #目前單身的 XML 節點
                
                
                    #------------------------------------------------------------------#
                    # 單身檔(bmt_file) Insert 動作                                     #
                    #------------------------------------------------------------------#
                    IF l_j = 1 THEN
                       CALL aws_create_plm_bom_b_delete2()
                    END IF 
                
                    IF NOT aws_create_plm_bom_b_default2(l_node2,l_cnt) THEN   #檢查 BOM 單身欄位預設值           
                       EXIT FOR
                    END IF
                
                    #-------------------------------------------------------------------#
                    # RECORD資料傳到NODE                                                #
                    #-------------------------------------------------------------------#
                    #CALL aws_ttsrv_setRecordField_record(l_node2,base.Typeinfo.create(g_bmb))
                    
                    IF cl_null(g_bmt.bmt01) THEN        # KEY 不可空白
                        LET g_bmt.bmt01 = g_bma.bma01
                        CALL aws_ttsrv_setRecordField(l_node2, "bmt01",g_bmt.bmt01)
                    END IF
                    IF cl_null(g_bmt.bmt08) THEN        # KEY 不可空白
                        LET g_bmt.bmt08 = g_bma.bma06
                        CALL aws_ttsrv_setRecordField(l_node2, "bmt08",g_bmt.bmt08)
                    END IF
                
                    LET l_sql = aws_ttsrv_getRecordSql(l_node2, "bmt_file", "I", NULL)   #I 表示取得 INSERT SQL
                
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
                
                IF g_status.code = "0" THEN
                    LET g_msg_flag = 'bma_file' 
                    IF l_status = 'Y' THEN #執行確認段否
                        CALL i600sub_y_chk(g_bma.bma01,g_bma.bma06)
                        IF g_success = 'N' THEN
                            LET g_status.code = g_errno
                            EXIT FOR
                        ELSE
                            CALL i600sub_y_upd(g_bma.bma01,g_bma.bma06)
                            IF g_success = 'N' THEN
                                LET g_status.code = g_errno
                                EXIT FOR
                            ELSE
                                CALL i600sub_j_chk(g_bma.bma01,g_bma.bma06)
                                IF g_success = 'N' THEN
                                    LET g_status.code = g_errno
                                    EXIT FOR
                                ELSE
                                    CALL i600sub_j_upd(g_bma.bma01,g_bma.bma06,g_today)
                                    IF g_success = 'N' THEN
                                        LET g_status.code = g_errno
                                        EXIT FOR
                                    ELSE
                                        CALL i600sub_carry(g_bma.bma01,g_bma.bma06)
                                        IF g_err_msg.getLength() <> 0 THEN
                                            LET g_status.code = 'aws-552'
                                            CALL cl_get_err_msg() RETURNING l_msg
                                            EXIT FOR
                                        END IF
                                    END IF
                                END IF
                            END IF
                        END IF
                    END IF
                ELSE
                    EXIT FOR
                END IF
            #DEV-C40005---add---str---
            ELSE
                LET g_bmb.bmb01 = g_bma.bma01
                LET g_bmb.bmb29 = g_bma.bma06
                CALL aws_create_plm_bom_a_delete()
                CALL aws_create_plm_bom_b_delete()
                CALL aws_create_plm_bom_b_delete2()
            END IF 
            #DEV-C40005---add---end---
        ELSE
            #走ECN單段的處理
            #----------------------------------------------------------------------#
            # 處理單身資料(bmb_file)                                                         #
            #----------------------------------------------------------------------#
            LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "bmb_file")       #取得目前單頭共有幾筆單身資料
            IF l_cnt2 = 0 THEN
               LET g_status.code = "mfg-009"   #必須有單身資料
               EXIT FOR
            END IF
            IF g_del_bom = 'N' THEN #DEV-C40005 add if 
                LET g_msg_flag = 'bmb_file'    
                #----------------------------------------------------------------------#
                # 處理第二單身插件位置資料(bmt_file)                                   #
                #----------------------------------------------------------------------#
                LET g_plm_bmt_cnt = aws_ttsrv_getDetailRecordLength(l_node1, "bmt_file")       #取得目前單頭共有幾筆單身資料
                DELETE FROM plm_bmt WHERE 1=1
                FOR l_j = 1 TO g_plm_bmt_cnt
                    LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "bmt_file")   #目前單身的 XML 節點
                    IF NOT aws_create_plm_bom_b_default2(l_node2,l_cnt) THEN   #檢查 BOM 單身欄位預設值           
                       EXIT FOR
                    END IF
                END FOR
                
                FOR l_j = 1 TO l_cnt2
                    LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "bmb_file")   #目前單身的 XML 節點
                
                    INITIALIZE g_bmb.* TO NULL      #FUN-C20081 add
                    LET g_bmb.bmb01 = g_bma.bma01
                    LET g_bmb.bmb29 = g_bma.bma06
                    IF NOT aws_create_plm_bom_b_default(l_node2,l_cnt) THEN   #檢查 BOM 單身欄位預設值           
                       EXIT FOR
                    END IF
                
                    INITIALIZE g_bmy.* TO NULL
                   #FUN-C20081---mod---str---
                   #CALL aws_diff_bmb() RETURNING g_bmy.bmy03 #比對BOM單身資料
                    IF cl_null(g_bmb.bmb37) THEN #PLM KEY
                        CALL aws_diff_bmb() RETURNING g_bmy.bmy03     #比對BOM單身資料
                    ELSE
                        CALL aws_diff_bmb_new() RETURNING g_bmy.bmy03 #比對BOM單身資料
                    END IF
                   #FUN-C20081---mod---end---
                    IF g_bmy.bmy03 = '0' THEN #無異動 
                        CALL aws_diff_bmt() RETURNING g_diff_bmt #比對BOM插件位置資料
                        IF g_diff_bmt = 'Y' THEN
                            LET g_bmy.bmy03 = '3' #舊元件修改
                        ELSE
                            CONTINUE FOR
                        END IF
                    END IF
                    IF g_ins_bmx_ok = 'N' THEN
                        #所有BOM的異動,只放在同一張ECN單,所以建立ECN單頭資料只做一次
                        IF NOT aws_ins_bmx() THEN #建立 ECN 單頭資料
                           EXIT FOR
                        END IF
                    END IF
                    CALL aws_def_bmy()
                    IF NOT aws_ins_bmy() THEN #check 並建立 ECN 單身資料
                       EXIT FOR
                    END IF
                END FOR
            END IF #DEV-C40005 add
            IF g_status.code <> '0' THEN
                EXIT FOR
            END IF
            IF NOT aws_get_old_item_void() THEN #取得1:舊元件失效 資料
                   EXIT FOR
            END IF
        END IF
        LET l_commit = 'Y'
    END FOR
    IF l_commit = 'N' THEN
       #TQC-C50229--mod---str---
       #LET g_status.description = cl_getmsg(g_status.code, g_lang)   #取得error code
        LET l_description = cl_getmsg(g_status.code, g_lang)          #取得error code
        IF NOT cl_null(g_status.description) THEN
            LET g_status.description = g_status.description CLIPPED,":",l_description CLIPPED
        ELSE
            LET g_status.description = l_description CLIPPED
        END IF
       #TQC-C50229--mod---end---
        CASE g_msg_flag
             WHEN 'bma_file' 
                   LET g_msg = cl_mut_get_feldname('bma01',g_bma01,'bma06',g_bma06,
                                                   '','','','','','','','')
             WHEN 'bmb_file'
                   LET g_msg = cl_mut_get_feldname('bmb01',g_bmb.bmb01,
                                                   'bmb29',g_bmb.bmb29,
                                                   'bmb02',g_bmb.bmb02,
                                                   'bmb03',g_bmb.bmb03,
                                                   'bmb04',g_bmb.bmb04,
                                                   '','')
             WHEN 'bmt_file'
                   LET g_msg = cl_mut_get_feldname('bmt01',g_bmt.bmt01,
                                                   'bmt02',g_bmt.bmt02,
                                                   'bmt03',g_bmt.bmt03,
                                                   'bmt04',g_bmt.bmt04,
                                                   'bmt05',g_bmt.bmt05,
                                                   'bmt08',g_bmt.bmt08)
             OTHERWISE EXIT CASE
        END CASE
        LET g_status.description = g_msg CLIPPED,"==>",g_status.description
        IF g_status.code = 'aws-552' THEN
            LET g_status.description = g_status.description,"==>",l_msg
        END IF
        ROLLBACK WORK
    ELSE
        IF g_ins_bmx_ok = 'N' THEN
            LET l_return.bmx01 = NULL
        ELSE
            LET l_return.bmx01 = g_bmx.bmx01
        END IF
        LET g_return_keyno = l_return.bmx01     #DEV-C40005 add
        IF g_ins_bmx_ok = 'Y' AND l_status = 'Y' THEN
            CALL i720sub_y_chk(g_bmx.bmx01)   
            IF g_success = "Y" THEN
                CALL i720sub_y_upd(g_bmx.bmx01,'Y')
            END IF
            IF g_err_msg.getLength() <> 0 THEN
                LET g_status.code = 'aws-553'
                CALL cl_get_err_msg() RETURNING l_msg
                LET g_status.description = cl_getmsg(g_status.code, g_lang)   #取得error code
                LET g_status.description = g_status.description,"==>",l_msg
                ROLLBACK WORK
            ELSE
                CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳 ERP 建立的單一主件工程變異單單號
                COMMIT WORK
            END IF
        ELSE
            CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳 ERP 建立的單一主件工程變異單單號
            COMMIT WORK
        END IF
    END IF

    CALL s_dc_drop_temp_table(g_dc_tabname_bma)
    CALL s_dc_drop_temp_table(g_dc_hist_tab)
    CALL s_dc_drop_temp_table(g_dc_tabname_bmx)
    
END FUNCTION

#[
# Description....: 鎖住將被更改或取消的資料
# Date & Author..: 2011/02/09 by Mandy
# Parameter......: none
# Return.........: INTEGER - TRUE / FALSE Luck 結果
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_plm_bom_updchk()
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
# Date & Author..: 2011/02/09 by Mandy
# Parameter......: p_node   - om.DomNode - BOM 單頭 XML 節點 
#                : p_cnt    - INTEGER    - 資料是否已存在，0:新增
# Return.........: INTEGER  - TRUE / FALSE 預設值檢查結果
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_plm_bom_data_default(p_node,p_cnt)
    DEFINE p_node      om.DomNode,
           p_cnt       LIKE type_file.num10
    DEFINE l_bma05     LIKE bma_file.bma05
    DEFINE l_bma10     LIKE bma_file.bma10
    DEFINE l_flag      LIKE type_file.chr1
    DEFINE l_imaacti   LIKE ima_file.imaacti

    INITIALIZE g_bma.* TO NULL #FUN-C20081 add

    LET g_bma.bma01 = g_bma01
    LET g_bma.bma06 = g_bma06

    LET g_bma.bma08 = aws_ttsrv_getRecordField(p_node,"bma08")     #資料來源
    LET g_bma.bmaacti = aws_ttsrv_getRecordField(p_node,"bmaacti") #資料有效否

    IF g_bma.bma01 IS NULL THEN
       LET g_status.code = "mfg2634"   #主件料件為 NULL
       LET g_status.description = "bma01:",g_bma.bma01 #TQC-C50229 add
       RETURN FALSE
    END IF
    IF g_bma.bmaacti ='N' THEN   
       LET g_status.code = "mfg1000"     #資料為無效資料, 不可更改
       LET g_status.description = "bmaacti:",g_bma.bmaacti #TQC-C50229 add
       RETURN FALSE
    END IF

    CALL s_field_chk(g_bma.bma01,'2',g_plant,'bma01') RETURNING l_flag
    IF l_flag = '0' THEN
       LET g_status.code = "aoo-043"   #違反aooi601中欄位新增值設定
       LET g_status.description = "bma01:",g_bma.bma01,"+g_plant:",g_plant #TQC-C50229 add
       RETURN FALSE
    END IF

    SELECT imaacti,ima08 INTO l_imaacti,g_ima08_h 
      FROM ima_file WHERE ima01 = g_bma.bma01
    CASE 
       WHEN SQLCA.SQLCODE = 100  
          LET g_status.code = 'mfg2602'     #無此主件料號
          LET g_status.description = "bma01:",g_bma.bma01 #TQC-C50229 add
          RETURN FALSE
       WHEN l_imaacti='N' 
          LET g_status.code = '9028'        #此筆資料已無效, 不可使用
          LET g_status.description = "bma01:",g_bma.bma01 #TQC-C50229 add
          RETURN FALSE
       WHEN l_imaacti  MATCHES '[PH]'
          LET g_status.code = '9038'        #此筆資料的狀況碼非"確認",不可使用!
          LET g_status.description = "bma01:",g_bma.bma01 #TQC-C50229 add
          RETURN FALSE
    END CASE

    IF g_ima08_h ='Z' THEN 
        LET g_status.code = 'mfg2752'       #此料件為Z:雜項料件
        LET g_status.description = "bma01:",g_bma.bma01,"+ima08:",g_ima08_h #TQC-C50229 add
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
       LET g_bma.bmagrup=g_grup
       LET g_bma.bmadate=g_today
       LET g_bma.bmaacti='Y'              #資料有效
       LET g_bma.bma09=0                  #拋轉次數            
       LET g_bma.bma10 = '0'              #狀態碼
       LET g_bma.bmaoriu = g_user #FUN-C20081 add
       LET g_bma.bmaorig = g_grup #FUN-C20081 add

    ELSE
       IF NOT s_dc_ud_flag('2',g_bma.bma08,g_plant,'u') THEN
          LET g_status.code = "aoo-045"   #參數設定:不可修改其他營運中心拋轉過來的資料
          LET g_status.description = "bma08:",g_bma.bma08,"+g_plant:",g_plant #TQC-C50229 add
          RETURN FALSE
       END IF
       SELECT bma05,bma10 INTO l_bma05,l_bma10 FROM bma_file 
        WHERE bma01 = g_bma.bma01 AND bma06 = g_bma.bma06
           
       IF l_bma10 <> '0' THEN
           LET g_status.code = "aim1006"   #此筆資料已確認不可修改!
           LET g_status.description = "bma10:",l_bma10 #TQC-C50229 add
           RETURN FALSE
       END IF
       IF NOT cl_null(l_bma05) AND g_sma.sma101 = 'N' THEN
          IF g_ima08_h MATCHES '[MPXTS]' THEN  #單頭料件來源碼='MPXT'才control
             LET g_status.code = "abm-120"   #BOM表發放後,不可以修改單身
             LET g_status.description = "bma05:",l_bma05  #TQC-C50229 add
             RETURN FALSE
          END IF
       END IF
    END IF 

    RETURN TRUE
END FUNCTION

#[
# Description....:  BOM 設定單身欄位預設值
# Date & Author..: 2011/02/09 by Mandy
# Parameter......: p_node   - om.DomNode - BOM 單身 XML 節點 
#                : p_cnt    - INTEGER    - 資料是否已存在，0:新增
# Return.........: INTEGER  - TRUE / FALSE 預設值檢查結果
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_plm_bom_b_default(p_node,p_cnt)
    DEFINE p_node      om.DomNode,
           p_cnt       LIKE type_file.num10
    DEFINE l_imaacti   LIKE ima_file.imaacti
    DEFINE l_ima140    LIKE ima_file.ima140
    DEFINE l_ima1401   LIKE ima_file.ima1401
    DEFINE l_ima151    LIKE ima_file.ima151
    DEFINE l_ima63     LIKE ima_file.ima63    #FUN-A70134 add
    DEFINE l_ima25      LIKE ima_file.ima25       #MOD-B50214 add
    DEFINE l_ima86      LIKE ima_file.ima86       #MOD-B50214 add
    DEFINE l_bmb10_fac  LIKE bmb_file.bmb10_fac   #MOD-B50214 add
    DEFINE l_bmb10_fac2 LIKE bmb_file.bmb10_fac2  #MOD-B50214 add
    DEFINE g_sw         LIKE type_file.num5       #MOD-B50214 add


    LET g_bmb.bmb01 = aws_ttsrv_getRecordField(p_node,"bmb01") 
    LET g_bmb.bmb02 = aws_ttsrv_getRecordField(p_node,"bmb02")    
    LET g_bmb.bmb03 = aws_ttsrv_getRecordField(p_node,"bmb03")    
    LET g_bmb.bmb04 = aws_ttsrv_getRecordField(p_node,"bmb04")    
    LET g_bmb.bmb05 = aws_ttsrv_getRecordField(p_node,"bmb05")    
    LET g_bmb.bmb06 = aws_ttsrv_getRecordField(p_node,"bmb06")    
    LET g_bmb.bmb07 = aws_ttsrv_getRecordField(p_node,"bmb07")    
    LET g_bmb.bmb08 = aws_ttsrv_getRecordField(p_node,"bmb08")    
    LET g_upd_bmb09 = 'N'
    CALL aws_ttsrv_getRecordField2(p_node,"bmb09") RETURNING g_bmb.bmb09,g_upd_bmb09
    LET g_bmb.bmb10 = aws_ttsrv_getRecordField(p_node,"bmb10") 
    LET g_bmb.bmb10_fac = aws_ttsrv_getRecordField(p_node,"bmb10_fac") 
    LET g_bmb.bmb10_fac2 = aws_ttsrv_getRecordField(p_node,"bmb10_fac2") 
    LET g_upd_bmb11 = 'N'
    CALL aws_ttsrv_getRecordField2(p_node,"bmb11") RETURNING g_bmb.bmb11,g_upd_bmb11
    LET g_bmb.bmb14 = aws_ttsrv_getRecordField(p_node,"bmb14") 
    LET g_bmb.bmb15 = aws_ttsrv_getRecordField(p_node,"bmb15") 
    LET g_bmb.bmb16 = aws_ttsrv_getRecordField(p_node,"bmb16") 
    LET g_bmb.bmb17 = aws_ttsrv_getRecordField(p_node,"bmb17") 
    LET g_bmb.bmb18 = aws_ttsrv_getRecordField(p_node,"bmb18") 
    LET g_bmb.bmb19 = aws_ttsrv_getRecordField(p_node,"bmb19") 
    LET g_bmb.bmb23 = aws_ttsrv_getRecordField(p_node,"bmb23") 
    LET g_upd_bmb25 = 'N'
    CALL aws_ttsrv_getRecordField2(p_node,"bmb25") RETURNING g_bmb.bmb25,g_upd_bmb25
    LET g_upd_bmb26 = 'N'
    CALL aws_ttsrv_getRecordField2(p_node,"bmb26") RETURNING g_bmb.bmb26,g_upd_bmb26
    LET g_bmb.bmb28 = aws_ttsrv_getRecordField(p_node,"bmb28")
    LET g_bmb.bmb30 = aws_ttsrv_getRecordField(p_node,"bmb30") 
    LET g_bmb.bmb31 = aws_ttsrv_getRecordField(p_node,"bmb31") 
    LET g_bmb.bmb33 = aws_ttsrv_getRecordField(p_node,"bmb33") 
    LET g_bmb.bmb36 = aws_ttsrv_getRecordField(p_node,"bmb36")  #FUN-C20081 add
    LET g_bmb.bmb37 = aws_ttsrv_getRecordField(p_node,"bmb37")  #FUN-C20081 add
    LET g_bmb.bmbcomm = aws_ttsrv_getRecordField(p_node,"bmbcomm") 
    LET g_bmb.bmb10_fac = aws_ttsrv_getRecordField(p_node,"bmb10_fac")      #MOD-B50214 add
    LET g_bmb.bmb10_fac2 = aws_ttsrv_getRecordField(p_node,"bmb10_fac2")    #MOD-B50214 add
    
    #FUN-B70076--add----str---
    LET g_bmb.bmb081  = aws_ttsrv_getRecordField(p_node,"bmb081")           
    LET g_bmb.bmb082  = aws_ttsrv_getRecordField(p_node,"bmb082")          
    IF cl_null(g_bmb.bmb081) THEN
        LET g_bmb.bmb081 = 0
    END IF
    IF cl_null(g_bmb.bmb082) THEN
        LET g_bmb.bmb082 = 1
    END IF
    #FUN-B70076--add----end---

    IF cl_null(g_bmb.bmb02) THEN 
        LET g_status.code = "mfg6138" #重要欄位不可空白
        LET g_status.description = "bmb02"  #TQC-C50229 add
        RETURN FALSE
    END IF
    IF cl_null(g_bmb.bmb03) THEN 
        LET g_status.code = "mfg6138" #重要欄位不可空白
        LET g_status.description = "bmb03"  #TQC-C50229 add
        RETURN FALSE
    END IF
    IF cl_null(g_bmb.bmb04) THEN 
        LET g_status.code = "mfg6138" #重要欄位不可空白
        LET g_status.description = "bmb04"  #TQC-C50229 add
        RETURN FALSE
    END IF
    IF cl_null(g_bmb.bmb01) THEN
        LET g_bmb.bmb01 = g_bma01
        CALL aws_ttsrv_setRecordField(p_node, "bmb01", g_bmb.bmb01)
    END IF
    LET l_imaacti = NULL
    SELECT imaacti
      INTO l_imaacti
      FROM ima_file 
     WHERE ima01 = g_bmb.bmb01
    CASE
       WHEN SQLCA.SQLCODE = 100
          LET g_status.code = 'mfg2602'     #無此主件料號
          LET g_status.description = "bmb01:",g_bmb.bmb01  #TQC-C50229 add
          RETURN FALSE
       WHEN l_imaacti='N'
          LET g_status.code = '9028'        #此筆資料已無效, 不可使用
          LET g_status.description = "bmb01:",g_bmb.bmb01  #TQC-C50229 add
       WHEN l_imaacti  MATCHES '[PH]'
          LET g_status.code = '9038'        #此筆資料的狀況碼非"確認",不可使>
          LET g_status.description = "bmb01:",g_bmb.bmb01  #TQC-C50229 add
          RETURN FALSE
    END CASE

    SELECT imaacti,ima08,ima140,ima1401,ima151,ima63,ima25,ima86                     #MOD-B50214 add ima25,ima86               
      INTO l_imaacti,g_ima08_b,l_ima140,l_ima1401,l_ima151,l_ima63,l_ima25,l_ima86   #MOD-B50214 add ima25,ima86
      FROM ima_file WHERE ima01 = g_bmb.bmb03
    CASE
       WHEN SQLCA.SQLCODE = 100
          LET g_status.code = 'mfg3021'     #無此元件料號,請重新輸入 
          LET g_status.description = "bmb03:",g_bmb.bmb03  #TQC-C50229 add
          RETURN FALSE
       WHEN l_imaacti='N'
          LET g_status.code = '9028'        #此筆資料已無效, 不可使用
          LET g_status.description = "bmb03:",g_bmb.bmb03  #TQC-C50229 add
       WHEN l_imaacti  MATCHES '[PH]'
          LET g_status.code = '9038'        #此筆資料的狀況碼非"確認",不可使>
          LET g_status.description = "bmb03:",g_bmb.bmb03  #TQC-C50229 add
          RETURN FALSE
    END CASE
    IF cl_null(g_bmb.bmb10) THEN #單位預設
        LET g_bmb.bmb10 = l_ima63
    END IF

    #MOD-B50214 add str------------------------------
    IF g_bmb.bmb10 <> l_ima25 THEN
       CALL s_umfchk(g_bmb.bmb03,g_bmb.bmb10,l_ima25) RETURNING g_sw,l_bmb10_fac   #發料/庫存單位
       CALL s_umfchk(g_bmb.bmb03,g_bmb.bmb10,l_ima86) RETURNING g_sw,l_bmb10_fac2  #發料/成本單位
    ELSE
       LET l_bmb10_fac = 1
       LET l_bmb10_fac2 = 1
    END IF

    IF cl_null(g_bmb.bmb10_fac) THEN
        LET g_bmb.bmb10_fac = l_bmb10_fac
    END IF

    IF cl_null(g_bmb.bmb10_fac2) THEN
        LET g_bmb.bmb10_fac2 = l_bmb10_fac2
    END IF
    #MOD-B50214 add end-------------------------------

    IF g_ima08_b ='Z' THEN
        LET g_status.code = 'mfg2752'       #此料件為Z:雜項料件
        LET g_status.description = "bmb03:",g_bmb.bmb03  #TQC-C50229 add
        RETURN FALSE
    END IF

    IF l_ima140  ='Y' AND l_ima1401 <= g_today THEN
       LET g_status.code = 'aim-809'        #料件已Phase Out! 
       LET g_status.description = "bmb03:",g_bmb.bmb03  #TQC-C50229 add
       RETURN FALSE
    END IF

    IF s_bomchk(g_bma.bma01,g_bmb.bmb03,g_ima08_h,g_ima08_b) THEN
       LET g_status.code = g_errno
       LET g_status.description = "bmb01:",g_bmb.bmb01,"+bmb03:",g_bmb.bmb03  #TQC-C50229 add
       RETURN FALSE
    END IF

    IF s_industry('slk') THEN     
        IF g_bmb.bmb30 = '1' THEN 
          IF  l_ima151 = 'Y' THEN
             LET g_status.code = "abm-645"       #單身計算方式若選擇款式,元件料號字段應只可輸入母料件
             LET g_status.description = "bmb03:",g_bmb.bmb03 #TQC-C50229 add
             RETURN FALSE
          END IF
        END IF
        IF g_bmb.bmb30 = '4' THEN 
          IF  l_ima151 <> 'Y' THEN
             LET g_status.code = "abm-646"       #單身計算方式若選擇固定，只可輸入非母料件的一般料件
             LET g_status.description = "bmb03:",g_bmb.bmb03 #TQC-C50229 add
             RETURN FALSE
          END IF
        END IF
    END IF #FUN-AB0038 add

    IF g_bmb.bmb05 < g_bmb.bmb04 THEN
       LET g_status.code = "mfg2604"         #失效日期不可小於生效日期
       LET g_status.description = "bmb04:",g_bmb.bmb04,"+bmb05:",g_bmb.bmb05 #TQC-C50229 add
       RETURN FALSE
    END IF
    LET g_bmb.bmbmodu = g_user  #FUN-C20081 add
    LET g_bmb.bmbdate = g_today #FUN-C20081 add
    IF cl_null(g_bmb.bmb23) THEN LET g_bmb.bmb23 = 100 END IF #FUN-C20081 add
    IF g_ecn = 'N' THEN
        #欄位給預設值
        IF cl_null(g_bmb.bmb06) THEN LET g_bmb.bmb06 = 1 END IF
        IF cl_null(g_bmb.bmb07) THEN LET g_bmb.bmb07 = 1 END IF
       #IF cl_null(g_bmb.bmb08) THEN LET g_bmb.bmb08 = 1 END IF  #FUN-C70063 mark
        IF cl_null(g_bmb.bmb08) THEN LET g_bmb.bmb08 = 0 END IF  #FUN-C70063 add
        IF cl_null(g_bmb.bmb10_fac) THEN LET g_bmb.bmb10_fac = 1 END IF
        IF cl_null(g_bmb.bmb10_fac2) THEN LET g_bmb.bmb10_fac2 = 1 END IF
        IF cl_null(g_bmb.bmb14) THEN LET g_bmb.bmb14 = '0' END IF
        IF cl_null(g_bmb.bmb15) THEN LET g_bmb.bmb15 = 'N' END IF
        IF cl_null(g_bmb.bmb16) THEN LET g_bmb.bmb16 = '0' END IF
        IF cl_null(g_bmb.bmb17) THEN LET g_bmb.bmb17 = 'N' END IF
        IF cl_null(g_bmb.bmb18) THEN LET g_bmb.bmb18 = '0' END IF
        IF cl_null(g_bmb.bmb19) THEN LET g_bmb.bmb19 = '1' END IF
        IF cl_null(g_bmb.bmb28) THEN LET g_bmb.bmb28 = 0 END IF
        IF cl_null(g_bmb.bmb31) THEN LET g_bmb.bmb31 = 'N' END IF
        IF cl_null(g_bmb.bmb33) THEN LET g_bmb.bmb33 = 0 END IF
        IF cl_null(g_bmb.bmbcomm) THEN LET g_bmb.bmbcomm = 'abmi600' END IF
        #TQC-C50229--add---str---
        IF NOT aws_create_plm_bom_bmb_chk() THEN #BOM單身bmb_file合理性判斷
            RETURN FALSE
        END IF
        #TQC-C50229--add---end---
    ELSE
       #FUN-C70083---mod---str---
       #INSERT INTO plm_bmb (bmb03)
       #             VALUES (g_bmb.bmb03)
        INSERT INTO plm_bmb (bmb03,bmb37)
                     VALUES (g_bmb.bmb03,g_bmb.bmb37)
       #FUN-C70083---mod---end---
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
           LET g_status.code = "aws-554" 
           RETURN FALSE
        END IF
    END IF
    RETURN TRUE
END FUNCTION


#[
# Description....: 刪除 BOM 單身相關資料 
# Date & Author..: 2011/02/09 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_plm_bom_b_delete()

    DELETE FROM bmb_file
       WHERE bmb01 = g_bmb.bmb01 AND bmb29 = g_bmb.bmb29
    #DEV-C40005---add---str---
    IF SQLCA.SQLCODE THEN
        LET g_errno = SQLCA.SQLCODE USING '-------'
    END IF
    #DEV-C40005---add---end---

END FUNCTION

#[
# Description.....  BOM 設定單身(bmt_file)欄位預設值
# Date & Author..: 2011/02/09 by Mandy
# Parameter......: p_node   - om.DomNode - BOM 單身 XML 節點 
#                : p_cnt    - INTEGER    - 資料是否已存在，0:新增
# Return.........: INTEGER  - TRUE / FALSE 預設值檢查結果
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_plm_bom_b_default2(p_node,p_cnt)
    DEFINE p_node      om.DomNode,
           p_cnt       LIKE type_file.num10
    DEFINE l_imaacti   LIKE ima_file.imaacti
    DEFINE l_ima140    LIKE ima_file.ima140
    DEFINE l_ima1401   LIKE ima_file.ima1401
    DEFINE l_ima151   LIKE ima_file.ima151
  

    LET g_bmt.bmt01 = aws_ttsrv_getRecordField(p_node,"bmt01")    
    LET g_bmt.bmt02 = aws_ttsrv_getRecordField(p_node,"bmt02")    
    LET g_bmt.bmt03 = aws_ttsrv_getRecordField(p_node,"bmt03")    
    LET g_bmt.bmt04 = aws_ttsrv_getRecordField(p_node,"bmt04")    
    LET g_bmt.bmt05 = aws_ttsrv_getRecordField(p_node,"bmt05")    
    LET g_bmt.bmt06 = aws_ttsrv_getRecordField(p_node,"bmt06")    
    LET g_bmt.bmt07 = aws_ttsrv_getRecordField(p_node,"bmt07")    
    LET g_bmt.bmt08 = aws_ttsrv_getRecordField(p_node,"bmt08")    

    IF cl_null(g_bmt.bmt02) THEN 
        LET g_status.code = "mfg6138" #重要欄位不可空白
        RETURN FALSE
    END IF
    IF cl_null(g_bmt.bmt03) THEN 
        LET g_status.code = "mfg6138" #重要欄位不可空白
        RETURN FALSE
    END IF
    IF cl_null(g_bmt.bmt04) THEN 
        LET g_status.code = "mfg6138" #重要欄位不可空白
        RETURN FALSE
    END IF
    IF cl_null(g_bmt.bmt05) THEN 
        LET g_status.code = "mfg6138" #重要欄位不可空白
        RETURN FALSE
    END IF
    IF g_ecn = 'Y' THEN
        LET g_bmt.bmt01 = g_bma.bma01
        LET g_bmt.bmt08 = g_bma.bma06
        INSERT INTO plm_bmt (bmt01,bmt02,bmt03,bmt04,bmt05,bmt06,bmt07,bmt08)
                     VALUES (g_bmt.bmt01,g_bmt.bmt02,g_bmt.bmt03,g_bmt.bmt04,
                             g_bmt.bmt05,g_bmt.bmt06,g_bmt.bmt07,g_bmt.bmt08)
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
           LET g_status.code = "aws-555" 
           RETURN FALSE
        END IF
    END IF
    RETURN TRUE
END FUNCTION

#[
# Description..... 刪除 BOM 單身插件位置(bmt_file)相關資料 
# Date & Author..: 2011/02/09 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_plm_bom_b_delete2()

    DELETE FROM bmt_file                                    
       WHERE bmt01 = g_bmb.bmb01 AND bmt08 = g_bmb.bmb29
    #DEV-C40005---add---str---
    IF SQLCA.SQLCODE THEN
        LET g_errno = SQLCA.SQLCODE USING '-------'
    END IF
    #DEV-C40005---add---end---

END FUNCTION

#ECN----------------------------------------------str----------------

FUNCTION aws_ins_bmx() #建立 ECN 單頭資料
  DEFINE l_flag     LIKE type_file.num10
  DEFINE l_genacti  LIKE gen_file.genacti
  
   INITIALIZE g_bmx.* TO NULL
   LET g_bmx.bmx01   = g_smyslip
   LET g_bmx.bmx02   = TODAY
   LET g_bmx.bmx04   = "N"
   LET g_bmx.bmx06   = "2"
   LET g_bmx.bmx07   = TODAY
   LET g_bmx.bmx09   = "0"
   LET g_bmx.bmx10   = g_bmx10
   IF cl_null(g_bmx.bmx10) THEN
       LET g_bmx.bmx10 = g_user
   ELSE
       LET g_errno = ' '
       SELECT genacti INTO l_genacti    
         FROM gen_file
        WHERE gen01 = g_bmx.bmx10
       CASE
          WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg1312'
                                   LET l_genacti = NULL
          WHEN l_genacti = 'N'  LET g_errno = '9028'
          OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
       IF NOT cl_null(g_errno) THEN
           LET g_errno = NULL
           LET g_bmx.bmx10 = g_user
       END IF
   END IF
   LET g_bmx.bmx11   = g_plant
   LET g_bmx.bmxuser = g_user
   LET g_bmx.bmxgrup = g_grup
   LET g_bmx.bmxdate = g_today
   LET g_bmx.bmxacti = "Y"
   LET g_bmx.bmxmksg = "N"
   #FUN-B20003--add---str--
   LET g_bmx.bmxplant = g_plant 
   LET g_bmx.bmxlegal = g_legal
   LET g_bmx.bmxoriu = g_user 
   LET g_bmx.bmxorig = g_grup 
   SELECT gen03 INTO g_bmx.bmx13 #申請部門
     FROM gen_file
    WHERE gen01 = g_bmx.bmx10
   LET g_bmx.bmx50 = '1'
   #FUN-B20003--add---end--
   #單據一律是新增
   #----------------------------------------------------------------------#
   # 單一主件工程變異單自動取號                                                       #
   #----------------------------------------------------------------------#       
   CALL s_check_no("abm",g_bmx.bmx01,"","1","bmx_file","bmx01","") 
        RETURNING l_flag,g_bmx.bmx01
   IF NOT l_flag THEN
       LET g_status.code = "aws-383"   #ECN單別不正確!
       RETURN FALSE
   END IF
   CALL s_auto_assign_no("abm",g_bmx.bmx01,g_bmx.bmx02,"1","bmx_file","bmx01","","","")
        RETURNING l_flag, g_bmx.bmx01
   IF NOT l_flag THEN
       LET g_status.code = "aws-384"   #ECN單號自動取號失敗!
       RETURN FALSE
   END IF
   INSERT INTO bmx_file VALUES (g_bmx.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       LET g_status.code = "aws-550"
       RETURN FALSE
   END IF
   LET g_ins_bmx_ok = 'Y'
   RETURN TRUE

END FUNCTION

FUNCTION aws_diff_bmb() #比對BOM單身資料
DEFINE l_bmb      RECORD LIKE bmb_file.*
DEFINE l_cnt      LIKE type_file.num10
  
    #=>變異別(bmy03)
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt
      FROM bmb_file
     WHERE bmb01 = g_bmb.bmb01
       AND bmb03 = g_bmb.bmb03
       AND bmb29 = g_bmb.bmb29
       AND (bmb05 > g_today OR bmb05 IS NULL)
    IF l_cnt = 0 THEN
        RETURN '2' #新元件新增生效
    ELSE
        INITIALIZE l_bmb.* TO NULL
        SELECT * INTO l_bmb.*
          FROM bmb_file
         WHERE bmb01 = g_bmb.bmb01
           AND bmb03 = g_bmb.bmb03
           AND bmb29 = g_bmb.bmb29
           AND (bmb05 > g_today OR bmb05 IS NULL)

        #=>(bmb09)作業編號
        IF NOT cl_null(g_bmb.bmb09) THEN
            IF NOT cl_null(l_bmb.bmb09) THEN
                IF g_bmb.bmb09 <> l_bmb.bmb09 THEN
                    RETURN '3' #舊元件修改
                END IF
            ELSE
                RETURN '3' #舊元件修改
            END IF
        ELSE
            IF NOT cl_null(l_bmb.bmb09) THEN
                IF g_upd_bmb09 = 'Y' THEN
                    RETURN '3' #舊元件修改
                END IF
            END IF
        END IF
        #=>(bmb11)工程圖號
        IF NOT cl_null(g_bmb.bmb11) THEN
            IF NOT cl_null(l_bmb.bmb11) THEN
                IF g_bmb.bmb11 <> l_bmb.bmb11 THEN
                    RETURN '3' #舊元件修改
                END IF
            ELSE
                RETURN '3' #舊元件修改
            END IF
        ELSE
            IF NOT cl_null(l_bmb.bmb11) THEN
                IF g_upd_bmb11 = 'Y' THEN
                    RETURN '3' #舊元件修改
                END IF
            END IF
        END IF
        #=>(bmb25)倉庫別
        IF NOT cl_null(g_bmb.bmb25) THEN
            IF NOT cl_null(l_bmb.bmb25) THEN
                IF g_bmb.bmb25 <> l_bmb.bmb25 THEN
                    RETURN '3' #舊元件修改
                END IF
            ELSE
                RETURN '3' #舊元件修改
            END IF
        ELSE
            IF NOT cl_null(l_bmb.bmb25) THEN
                IF g_upd_bmb25 = 'Y' THEN
                    RETURN '3' #舊元件修改
                END IF
            END IF
        END IF
        #=>(bmb26)存放位置
        IF NOT cl_null(g_bmb.bmb26) THEN
            IF NOT cl_null(l_bmb.bmb26) THEN
                IF g_bmb.bmb26 <> l_bmb.bmb26 THEN
                    RETURN '3' #舊元件修改
                END IF
            ELSE
                RETURN '3' #舊元件修改
            END IF
        ELSE
            IF NOT cl_null(l_bmb.bmb26) THEN
                IF g_upd_bmb26 = 'Y' THEN
                    RETURN '3' #舊元件修改
                END IF
            END IF
        END IF
        IF g_bmb.bmb06 <> l_bmb.bmb06 OR
           g_bmb.bmb07 <> l_bmb.bmb07 OR 
           g_bmb.bmb08 <> l_bmb.bmb08 OR
           g_bmb.bmb10 <> l_bmb.bmb10 OR
           g_bmb.bmb18 <> l_bmb.bmb18 OR
           g_bmb.bmb19 <> l_bmb.bmb19 OR
           g_bmb.bmb15 <> l_bmb.bmb15 OR
           g_bmb.bmb28 <> l_bmb.bmb28 OR
           g_bmb.bmb30 <> l_bmb.bmb30 OR
           g_bmb.bmb31 <> l_bmb.bmb31 THEN
           RETURN '3' #舊元件修改
        ELSE
           RETURN '0' #無異動
        END IF
    END IF
END FUNCTION

FUNCTION aws_diff_bmb_new() #比對BOM單身資料
DEFINE l_bmb      RECORD LIKE bmb_file.*
DEFINE l_cnt      LIKE type_file.num10
  
    #=>變異別(bmy03)
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt
      FROM bmb_file
     WHERE bmb01 = g_bmb.bmb01 #主件料件編號
       AND bmb37 = g_bmb.bmb37 #PLM KEY
       AND bmb03 = g_bmb.bmb03 #元件 #FUN-C50033(2) add (因為KEY值改為PLM KEY + 元件)
    IF l_cnt = 0 THEN
        RETURN '2' #新元件新增生效
    ELSE
        INITIALIZE l_bmb.* TO NULL
        SELECT * INTO l_bmb.*
          FROM bmb_file
         WHERE bmb01 = g_bmb.bmb01
           AND bmb03 = g_bmb.bmb03
           AND bmb29 = g_bmb.bmb29
           AND (bmb05 > g_today OR bmb05 IS NULL)
           AND bmb37 = g_bmb.bmb37 #PLM KEY

        #=>(bmb09)作業編號
        IF NOT cl_null(g_bmb.bmb09) THEN
            IF NOT cl_null(l_bmb.bmb09) THEN
                IF g_bmb.bmb09 <> l_bmb.bmb09 THEN
                    RETURN '3' #舊元件修改
                END IF
            ELSE
                RETURN '3' #舊元件修改
            END IF
        ELSE
            IF NOT cl_null(l_bmb.bmb09) THEN
                IF g_upd_bmb09 = 'Y' THEN
                    RETURN '3' #舊元件修改
                END IF
            END IF
        END IF
        #=>(bmb11)工程圖號
        IF NOT cl_null(g_bmb.bmb11) THEN
            IF NOT cl_null(l_bmb.bmb11) THEN
                IF g_bmb.bmb11 <> l_bmb.bmb11 THEN
                    RETURN '3' #舊元件修改
                END IF
            ELSE
                RETURN '3' #舊元件修改
            END IF
        ELSE
            IF NOT cl_null(l_bmb.bmb11) THEN
                IF g_upd_bmb11 = 'Y' THEN
                    RETURN '3' #舊元件修改
                END IF
            END IF
        END IF
        #=>(bmb25)倉庫別
        IF NOT cl_null(g_bmb.bmb25) THEN
            IF NOT cl_null(l_bmb.bmb25) THEN
                IF g_bmb.bmb25 <> l_bmb.bmb25 THEN
                    RETURN '3' #舊元件修改
                END IF
            ELSE
                RETURN '3' #舊元件修改
            END IF
        ELSE
            IF NOT cl_null(l_bmb.bmb25) THEN
                IF g_upd_bmb25 = 'Y' THEN
                    RETURN '3' #舊元件修改
                END IF
            END IF
        END IF
        #=>(bmb26)存放位置
        IF NOT cl_null(g_bmb.bmb26) THEN
            IF NOT cl_null(l_bmb.bmb26) THEN
                IF g_bmb.bmb26 <> l_bmb.bmb26 THEN
                    RETURN '3' #舊元件修改
                END IF
            ELSE
                RETURN '3' #舊元件修改
            END IF
        ELSE
            IF NOT cl_null(l_bmb.bmb26) THEN
                IF g_upd_bmb26 = 'Y' THEN
                    RETURN '3' #舊元件修改
                END IF
            END IF
        END IF
        IF g_bmb.bmb06 <> l_bmb.bmb06 OR
           g_bmb.bmb07 <> l_bmb.bmb07 OR 
           g_bmb.bmb08 <> l_bmb.bmb08 OR
           g_bmb.bmb10 <> l_bmb.bmb10 OR
           g_bmb.bmb18 <> l_bmb.bmb18 OR
           g_bmb.bmb19 <> l_bmb.bmb19 OR
           g_bmb.bmb15 <> l_bmb.bmb15 OR
           g_bmb.bmb28 <> l_bmb.bmb28 OR
           g_bmb.bmb30 <> l_bmb.bmb30 OR
           g_bmb.bmb36 <> l_bmb.bmb36 OR #FUN-C70083(2) add
           g_bmb.bmb31 <> l_bmb.bmb31 THEN
           RETURN '3' #舊元件修改
        ELSE
           RETURN '0' #無異動
        END IF
    END IF
END FUNCTION

FUNCTION aws_diff_bmt() #比對BOM 插件位置資料
   DEFINE l_bmt_cnt         LIKE type_file.num10
   DEFINE l_plm_bmt_cnt     LIKE type_file.num10
   DEFINE l_diff_bmt_cnt    LIKE type_file.num10
   DEFINE l_plm_bmt         RECORD LIKE bmt_file.*
   DEFINE l_bmt             RECORD LIKE bmt_file.*
   DEFINE l_bmb             RECORD LIKE bmb_file.* 

   #因為要用現在BOM未失效的項次,去抓bmt_file內的資料
   INITIALIZE l_bmb.* TO NULL
   SELECT * INTO l_bmb.*
     FROM bmb_file
    WHERE bmb01 = g_bmb.bmb01
      AND bmb03 = g_bmb.bmb03
      AND bmb29 = g_bmb.bmb29
      AND (bmb05 > g_today OR bmb05 IS NULL)

   LET l_plm_bmt_cnt = 0
   SELECT COUNT(*) INTO l_plm_bmt_cnt
     FROM plm_bmt
    WHERE bmt01 = g_bmb.bmb01
      AND bmt02 = g_bmb.bmb02
      AND bmt03 = g_bmb.bmb03

   LET l_bmt_cnt = 0
   SELECT COUNT(*) INTO l_bmt_cnt
     FROM bmt_file
    WHERE bmt01 = l_bmb.bmb01
      AND bmt02 = l_bmb.bmb02
      AND bmt03 = l_bmb.bmb03
      AND bmt04 = l_bmb.bmb04 #FUN-B30104 add

   IF l_bmt_cnt = 0 AND l_plm_bmt_cnt = 0 THEN
       RETURN 'N' #無插件位置,所以無異動插件位置
   END IF
   IF l_bmt_cnt <> l_plm_bmt_cnt THEN
       RETURN 'Y' #插件位置筆數已不同,所以已異動插件位置
   END IF

   LET l_diff_bmt_cnt = 0
   SELECT COUNT(*) INTO l_diff_bmt_cnt
     FROM bmt_file
    WHERE bmt01 = l_bmb.bmb01
      AND bmt02 = l_bmb.bmb02
      AND bmt03 = l_bmb.bmb03
      AND bmt04 = l_bmb.bmb04 #FUN-B30104 add
      AND bmt06 NOT IN (SELECT bmt06 FROM plm_bmt
                         WHERE bmt01 = g_bmb.bmb01
                           AND bmt02 = g_bmb.bmb02
                           AND bmt03 = g_bmb.bmb03)
   IF l_diff_bmt_cnt >=1 THEN
       RETURN 'Y' #BOM插件位置不存在PLM插件位置
   END IF

   LET l_diff_bmt_cnt = 0
   SELECT COUNT(*) INTO l_diff_bmt_cnt
     FROM plm_bmt
    WHERE bmt01 = g_bmb.bmb01
      AND bmt02 = g_bmb.bmb02
      AND bmt03 = g_bmb.bmb03
      AND bmt06 NOT IN (SELECT bmt06 FROM bmt_file
                         WHERE bmt01 = l_bmb.bmb01
                           AND bmt02 = l_bmb.bmb02
                           AND bmt03 = l_bmb.bmb03
                           AND bmt04 = l_bmb.bmb04 ) #FUN-B30104 add
   IF l_diff_bmt_cnt >=1 THEN
       RETURN 'Y' #PLM插件位置不存在BOM插件位置
   END IF

   #一一檢查PLM傳過來的插件位置
   IF l_plm_bmt_cnt >=1 THEN
       DECLARE get_plm_bmt_cur CURSOR FOR
        SELECT * 
          FROM plm_bmt
         WHERE bmt01 = g_bmb.bmb01
           AND bmt02 = g_bmb.bmb02
           AND bmt03 = g_bmb.bmb03
          ORDER BY bmt05
       FOREACH get_plm_bmt_cur INTO l_plm_bmt.*
           LET l_bmt_cnt = 0 
           SELECT COUNT(*) INTO l_bmt_cnt
             FROM bmt_file
            WHERE bmt01 = l_plm_bmt.bmt01
              AND bmt02 = l_bmb.bmb02
              AND bmt03 = l_plm_bmt.bmt03
              AND bmt04 = l_bmb.bmb04      #FUN-B30104 add
              AND bmt06 = l_plm_bmt.bmt06
           IF l_bmt_cnt = 0 THEN
               RETURN 'Y' #代表PLM傳過來的插件位置,不存在TIPTOP的bmt_file
           ELSE
               SELECT * INTO l_bmt.*
                 FROM bmt_file
                WHERE bmt01 = l_plm_bmt.bmt01
                  AND bmt02 = l_bmb.bmb02
                  AND bmt03 = l_plm_bmt.bmt03
                  AND bmt04 = l_bmb.bmb04      #FUN-B30104 add
                  AND bmt06 = l_plm_bmt.bmt06
               IF l_plm_bmt.bmt07 <> l_bmt.bmt07 THEN
                   RETURN 'Y' #代表PLM傳過來的插件位置其組成用量已異動
               END IF
           END IF
       END FOREACH
   END IF
   RETURN 'N' #無異動
END FUNCTION

FUNCTION aws_get_old_item_void() #取得1:舊元件失效 資料
DEFINE l_bmb      RECORD LIKE bmb_file.*
DEFINE l_cnt      LIKE type_file.num10
DEFINE l_sql      STRING        #DEV-C40005 add

   #DEV-C40005 --mark---str---
   # LET l_cnt = 0
   # SELECT COUNT(*) INTO l_cnt
   #   FROM bmb_file
   #  WHERE bmb01 = g_bmb.bmb01
   #    AND (bmb05 > g_today OR bmb05 IS NULL)
   #    AND bmb03 NOT IN (SELECT bmb03 FROM plm_bmb)
   #IF l_cnt = 0 THEN
   #    RETURN TRUE
   #END IF

   #IF g_ins_bmx_ok = 'N' THEN
   #    #所有BOM的異動,只放在同一張ECN單,所以建立ECN單頭資料只做一次
   #    IF NOT aws_ins_bmx() THEN #建立 ECN 單頭資料
   #        RETURN FALSE
   #    END IF
   #END IF
   #
   #DECLARE get_old_item_void_cur CURSOR FOR
   # SELECT * 
   #   FROM bmb_file
   #  WHERE bmb01 = g_bmb.bmb01
   #    AND (bmb05 > g_today OR bmb05 IS NULL)
   #    AND bmb03 NOT IN (SELECT bmb03 FROM plm_bmb)
   #DEV-C40005 --mark---end---
   #DEV-C40005 --add----str---
    LET l_sql = "SELECT * ",
                "  FROM bmb_file",
                " WHERE bmb01 = '",g_bma.bma01,"'",
                "   AND (bmb05 > '",g_today,"'"," OR bmb05 IS NULL)"
    IF g_del_bom = 'N' THEN
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt
          FROM bmb_file
         WHERE bmb01 = g_bma.bma01
           AND (bmb05 > g_today OR bmb05 IS NULL)
          #AND bmb03 NOT IN (SELECT bmb03 FROM plm_bmb)                                                     #FUN-C70083 mark
           AND NVL(bmb03,'0')||NVL(bmb37,'0') NOT IN (SELECT NVL(bmb03,'0')||NVL(bmb37,'0') FROM plm_bmb)   #FUN-C70083 add
        IF l_cnt = 0 THEN
            RETURN TRUE
        END IF
       #LET l_sql = l_sql CLIPPED,"   AND bmb03 NOT IN (SELECT bmb03 FROM plm_bmb) "                                                    #FUN-C70083 mark
        LET l_sql = l_sql CLIPPED,"   AND NVL(bmb03,'0')||NVL(bmb37,'0') NOT IN (SELECT NVL(bmb03,'0')||NVL(bmb37,'0') FROM plm_bmb) "  #FUN-C70083 add
    END IF

    PREPARE get_old_item_void_pre FROM l_sql
    DECLARE get_old_item_void_cur CURSOR FOR get_old_item_void_pre
    
    IF g_ins_bmx_ok = 'N' THEN
        #所有BOM的異動,只放在同一張ECN單,所以建立ECN單頭資料只做一次
        IF NOT aws_ins_bmx() THEN #建立 ECN 單頭資料
            RETURN FALSE
        END IF
    END IF
   #DEV-C40005 --add----end---
    FOREACH get_old_item_void_cur INTO l_bmb.*
        INITIALIZE g_bmy.* TO NULL
        #=>單號(bmy01)
        LET g_bmy.bmy01 = g_bmx.bmx01

        #=>項次(bmy02)
        IF cl_null(g_bmy.bmy02) OR g_bmy.bmy02 = 0 THEN
            SELECT MAX(bmy02)+1 INTO g_bmy.bmy02
               FROM bmy_file WHERE bmy01 = g_bmx.bmx01
            IF cl_null(g_bmy.bmy02) THEN
                LET g_bmy.bmy02 = 1
            END IF
        END IF

        #=>變異別(bmy03)
        LET g_bmy.bmy03 = '1'         #1:舊元件失效
        LET g_bmy.bmy05 = l_bmb.bmb03 #元件編號
        LET g_bmy.bmy06 = l_bmb.bmb06
        LET g_bmy.bmy07 = l_bmb.bmb07
        LET g_bmy.bmy14 = l_bmb.bmb01 #主件編號
        LET g_bmy.bmy16 = l_bmb.bmb16
        LET g_bmy.bmy33 = '0'
        LET g_bmy.bmy34 = l_bmb.bmb31
        #FUN-B70076---add---str---
        LET g_bmy.bmy081 = l_bmb.bmb081
        LET g_bmy.bmy082 = l_bmb.bmb082
        IF cl_null(g_bmy.bmy081) THEN
            LET g_bmy.bmy081 = 0
        END IF
        IF cl_null(g_bmy.bmy082) THEN
            LET g_bmy.bmy082 = 1
        END IF
        #FUN-B70076---add---end---
        LET g_bmy.bmyplant = g_plant #FUN-B20003 add
        LET g_bmy.bmylegal = g_legal #FUN-B20003 add
       #LET g_bmy.bmy36 = l_bmb.bmb36 #FUN-C20081 add   #FUN-D20018 mark
        LET g_bmy.bmy361 = l_bmb.bmb36 #FUN-C20081 add  #FUN-D20018 add
        LET g_bmy.bmy37 = l_bmb.bmb37 #FUN-C20081 add
        LET g_bmy.bmy35 = l_bmb.bmb14 #元件使用特性   #TQC-C80022 add

        INSERT INTO bmy_file VALUES (g_bmy.*)
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_status.code = "aws-551"
            RETURN FALSE
        END IF
    END FOREACH
    RETURN TRUE
END FUNCTION

FUNCTION aws_def_bmy() #default ECN 單身資料
  
   LET g_bmy.bmy05 = g_bmb.bmb03 #元件編號
   LET g_bmy.bmy14 = g_bmb.bmb01 #主件編號
   IF g_bmy.bmy03 = '2' THEN
       LET g_bmy.bmy16 = '0'
   ELSE
       IF g_bmb.bmb16 IS NOT NULL THEN LET g_bmy.bmy16 = g_bmb.bmb16 END IF
   END IF
   IF g_bmb.bmb19 IS NOT NULL THEN LET g_bmy.bmy20 = g_bmb.bmb19 END IF
   IF g_bmb.bmb15 IS NOT NULL THEN 
       LET g_bmy.bmy15 = g_bmb.bmb15 
       LET g_bmy.bmy21 = g_bmb.bmb15 
   END IF
   IF g_bmb.bmb28 IS NOT NULL THEN LET g_bmy.bmy23 = g_bmb.bmb28 END IF
   IF g_bmb.bmb31 IS NOT NULL THEN LET g_bmy.bmy34 = g_bmb.bmb31 END IF

   IF g_bmb.bmb06 IS NOT NULL THEN LET g_bmy.bmy06 = g_bmb.bmb06 END IF
   IF g_bmb.bmb07 IS NOT NULL THEN LET g_bmy.bmy07 = g_bmb.bmb07 END IF
   IF g_bmb.bmb08 IS NOT NULL THEN LET g_bmy.bmy08 = g_bmb.bmb08 END IF
   IF g_bmb.bmb10 IS NOT NULL THEN LET g_bmy.bmy10 = g_bmb.bmb10 END IF
   IF g_bmb.bmb13 IS NOT NULL THEN LET g_bmy.bmy13 = g_bmb.bmb13 END IF
   IF g_bmb.bmb18 IS NOT NULL THEN LET g_bmy.bmy18 = g_bmb.bmb18 END IF
   IF g_bmb.bmb30 IS NOT NULL THEN LET g_bmy.bmy30 = g_bmb.bmb30 END IF
   IF g_bmb.bmb33 IS NOT NULL THEN LET g_bmy.bmy33 = g_bmb.bmb33 END IF
  #IF g_bmb.bmb36 IS NOT NULL THEN LET g_bmy.bmy36 = g_bmb.bmb36 END IF #FUN-C20081 add   #FUN-D20018 mark
   IF g_bmb.bmb36 IS NOT NULL THEN LET g_bmy.bmy361 = g_bmb.bmb36 END IF #FUN-C20081 add  #FUN-D20018 add
   IF g_bmb.bmb37 IS NOT NULL THEN LET g_bmy.bmy37 = g_bmb.bmb37 END IF #FUN-C20081 add

   LET g_bmy.bmy29 = g_bmb.bmb29
   IF cl_null(g_bmy.bmy33) THEN LET g_bmy.bmy33 = '0' END IF

   IF g_upd_bmb09 = 'Y' THEN LET g_bmy.bmy09 = g_bmb.bmb09 END IF
   IF g_upd_bmb11 = 'Y' THEN LET g_bmy.bmy11 = g_bmb.bmb11 END IF
   IF g_upd_bmb25 = 'Y' THEN LET g_bmy.bmy25 = g_bmb.bmb25 END IF
   IF g_upd_bmb26 = 'Y' THEN LET g_bmy.bmy26 = g_bmb.bmb26 END IF

END FUNCTION

FUNCTION aws_ins_bmy() #check 並建立 ECN 單身資料
  DEFINE l_cnt         LIKE type_file.num10
  DEFINE l_item        LIKE ima_file.ima01
  DEFINE l_sw          LIKE type_file.chr1
  DEFINE l_bmy10_fac   LIKE bmy_file.bmy10_fac
  DEFINE l_bmy10_fac2  LIKE bmy_file.bmy10_fac2
  DEFINE l_bmb         RECORD LIKE bmb_file.*
  DEFINE l_ima         RECORD LIKE ima_file.*
  DEFINE l_plm_bmt     RECORD LIKE bmt_file.*

        INITIALIZE l_bmb.* TO NULL      
        INITIALIZE l_ima.* TO NULL      
        #=>單號(bmy01)
        LET g_bmy.bmy01 = g_bmx.bmx01
     

        #=>項次(bmy02)
        IF cl_null(g_bmy.bmy02) OR g_bmy.bmy02 = 0 THEN
            SELECT MAX(bmy02)+1 INTO g_bmy.bmy02
               FROM bmy_file WHERE bmy01 = g_bmx.bmx01
            IF cl_null(g_bmy.bmy02) THEN
                LET g_bmy.bmy02 = 1
            END IF
        END IF

        #=>變異別(bmy03)
        IF g_bmy.bmy03 NOT MATCHES '[12345]'THEN  
            LET g_status.code = "aws-385"   #變異別不正確!
            RETURN FALSE
        END IF

        #=>組成用量(bmy06)
        IF NOT cl_null(g_bmy.bmy06) THEN
           IF g_bmy.bmy06 <= 0 THEN
               LET g_status.code = "mfg2614"   #組成用量不可小於零
               RETURN FALSE
           END IF
        END IF

        #=>底數(bmy07)
        IF NOT cl_null(g_bmy.bmy07) THEN
           IF g_bmy.bmy07 <= 0 THEN
               LET g_status.code = "mfg2615"   #主件底數不可小於等於零
               RETURN FALSE
           END IF
        END IF

        #=>主件編號(bmy14)
        IF NOT cl_null(g_bmy.bmy14) THEN
            IF NOT cl_null(g_bmy.bmy05) THEN #元件編號
                IF g_bmy.bmy03 MATCHES '[1345]' THEN #變異碼
                    LET l_cnt = 0
                    IF NOT cl_null(g_bmy.bmy04) THEN #產品結構項次
                        SELECT COUNT(*) INTO l_cnt FROM bmb_file
                         WHERE bmb01 = g_bmy.bmy14
                           AND bmb02 = g_bmy.bmy04
                           AND bmb03 = g_bmy.bmy05
                           AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                           AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                    ELSE
                        SELECT COUNT(*) INTO l_cnt FROM bmb_file
                         WHERE bmb01 = g_bmy.bmy14
                           AND bmb03 = g_bmy.bmy05
                           AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                           AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                    END IF
                    IF  l_cnt = 0 THEN
                         LET g_status.code = "mfg2631"   #產品結構單身檔無此元件編號
                         RETURN FALSE
                    END IF
                END IF
            END IF
            CALL aws_plm_ima01_chk(g_bmy.bmy14,'3')
            IF NOT cl_null(g_errno) THEN
                LET g_status.code = g_errno  
                RETURN FALSE
            ELSE
                SELECT ima05 INTO g_bmy.bmy171 FROM ima_file
                 WHERE ima01 = g_bmy.bmy14
            END IF
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM bma_file
             WHERE bma01 = g_bmy.bmy14
               AND (bma05 IS NULL OR bma05 >g_bmx.bmx07)
               AND bma06 = g_bmy.bmy29
            IF l_cnt> 0 THEN
                LET g_status.code = "abm-005" #有效日期不可小於發放日期,或此BOM的發放日期為空白,請查核..!
                RETURN FALSE
            END IF
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM bma_file
               WHERE bma01=g_bmy.bmy14 
                 AND bmaacti='Y'
                 AND bma06=g_bmy.bmy29
            IF l_cnt =0 THEN
                LET g_status.code = "abm-742" #無此產品結構資料!
                RETURN FALSE
            END IF
            IF g_bmy.bmy03 = '2' THEN #變異碼:2: 新元件新增生效
                IF NOT cl_null(g_bmy.bmy04) THEN #產品結構項次
                    LET l_cnt=0
                    SELECT COUNT(*) INTO l_cnt FROM bmb_file
                     WHERE bmb01 = g_bmy.bmy14
                       AND bmb02 = g_bmy.bmy04
                       AND bmb29 = g_bmy.bmy29       
                       AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                       AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                    IF l_cnt> 0 THEN
                        LET g_status.code = "mfg-015" #該主件料號+項次已存在產品結構中, 請重新輸入!
                        RETURN FALSE
                    END IF
                 END IF
            END IF
            LET l_cnt=0
            SELECT COUNT(*) INTO l_cnt FROM bma_file
             WHERE bma01  = g_bmy.bmy14
            IF l_cnt = 0 THEN
                LET g_status.code = "abm-748" #欲更新的資料主件不存在產品結構主檔的bma_file中
                RETURN FALSE
            END IF
        END IF

        #=>元件編號(bmy05)
        IF NOT cl_null(g_bmy.bmy05) THEN
            CALL aws_ima01_chk(g_bmy.bmy05,'1')
            IF NOT cl_null(g_errno) THEN
                LET g_status.code = g_errno  
                RETURN FALSE
            END IF
            IF g_bmy.bmy03 != '1' THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt
                 FROM ima_file
                WHERE ima01=g_bmy.bmy05
                  AND (ima140='N'
                  OR (ima140='Y' AND ima1401 > g_bmx.bmx07))  
               IF l_cnt = 0 THEN
                   LET g_status.code = "aim-809" #料件已Phase Out!
                   RETURN FALSE
               END IF
               IF g_bmy.bmy05 = g_bmy.bmy14 THEN 
                   LET g_status.code = "mfg2633" #元件料號不可與主件料號相同
                   RETURN FALSE
               END IF
            END IF
            IF g_bmy.bmy03 MATCHES '[13]'  THEN 
                 SELECT bmb31 INTO l_bmb.bmb31 FROM bmb_file
                    WHERE bmb01 = g_bmy.bmy14
                      AND bmb03 = g_bmy.bmy05
                      AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                      AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                 IF cl_null(g_bmy.bmy34) THEN
                     LET g_bmy.bmy34 = l_bmb.bmb31
                 END IF
            END IF          
            IF g_bmy.bmy03 MATCHES '[245]' THEN  
                IF cl_null(g_bmy.bmy34) THEN
                    LET g_bmy.bmy34 = 'N'
                END IF
            END IF             
            IF g_bmy.bmy03 MATCHES '[1345]' THEN   
                LET l_cnt = 0
                IF NOT cl_null(g_bmy.bmy04) THEN
                    SELECT COUNT(*) INTO l_cnt FROM bmb_file
                     WHERE bmb01 = g_bmy.bmy14
                       AND bmb02 = g_bmy.bmy04
                       AND bmb03 = g_bmy.bmy05
                       AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                       AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                ELSE
                    SELECT COUNT(*) INTO l_cnt FROM bmb_file
                     WHERE bmb01 = g_bmy.bmy14
                       AND bmb03 = g_bmy.bmy05
                       AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                       AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                END IF
                IF  l_cnt = 0 THEN
                    LET g_status.code = "mfg2631" #產品結構單身檔無此元件編號
                    RETURN FALSE
                END IF
            END IF
            #Default 底數、組成用量
            IF g_bmy.bmy03 MATCHES '[1345]' THEN  
                IF g_bmy.bmy03 MATCHES '[134]' THEN
                    IF cl_null(g_bmy.bmy04) THEN
                       #SELECT bmb06,bmb07,bmb16 INTO l_bmb.bmb06,l_bmb.bmb07,l_bmb.bmb16 FROM bmb_file #TQC-C80022 mark
                        SELECT bmb06,bmb07,bmb16,bmb14,bmb30 INTO l_bmb.bmb06,l_bmb.bmb07,l_bmb.bmb16,l_bmb.bmb14 FROM bmb_file #TQC-C80022 add
                         WHERE bmb01 = g_bmy.bmy14
                           AND bmb03 = g_bmy.bmy05
                           AND bmb04 = (SELECT MAX(bmb04) FROM bmb_file
                                         WHERE bmb01 = g_bmy.bmy14
                                           AND bmb03 = g_bmy.bmy05)
                           AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                           AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                    ELSE
                       #SELECT bmb06,bmb07,bmb16 INTO l_bmb.bmb06,l_bmb.bmb07,l_bmb.bmb16 FROM bmb_file #TQC-C80022 mark
                        SELECT bmb06,bmb07,bmb16,bmb14,bmb30 INTO l_bmb.bmb06,l_bmb.bmb07,l_bmb.bmb16,l_bmb.bmb14 FROM bmb_file #TQC-C80022 add
                         WHERE bmb01 = g_bmy.bmy14
                           AND bmb03 = g_bmy.bmy05
                           AND bmb02 = g_bmy.bmy04
                           AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                           AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                    END IF
                    IF cl_null(g_bmy.bmy06) THEN
                        LET g_bmy.bmy06 = l_bmb.bmb06
                    END IF
                    IF cl_null(g_bmy.bmy07) THEN 
                        LET g_bmy.bmy07 = l_bmb.bmb07
                    END IF
                    IF g_bmy.bmy03 MATCHES '[13]' THEN  
                        IF cl_null(g_bmy.bmy16) THEN
                            LET g_bmy.bmy16 = l_bmb.bmb16   
                        END IF
                    END IF   #CHI-960004
                ELSE
                    IF cl_null(g_bmy.bmy06) THEN
                        LET g_bmy.bmy06 = 1
                    END IF
                    IF cl_null(g_bmy.bmy07) THEN
                        LET g_bmy.bmy07 = 1
                    END IF
                END IF
            ELSE
                IF cl_null(g_bmy.bmy06) THEN
                    LET g_bmy.bmy06 = 1
                END IF
            END IF
        END IF

        #TQC-C80022 add str---
         IF g_bmy.bmy03 MATCHES '[134]' THEN
            LET g_bmy.bmy35 = l_bmb.bmb14
         END IF
        #TQC-C80022 add end---

        #=>替代特性(bmy16)
        IF g_bmy.bmy16 NOT MATCHES '[01245]' THEN
             LET g_status.code = "aws-386" #取替代特性不正確!
             RETURN FALSE
        END IF
        IF g_bmy.bmy03 MATCHES '[1123]' THEN
            IF cl_null(g_bmy.bmy16) THEN
                IF g_bmy.bmy03 = '2' THEN
                    LET g_bmy.bmy16 = '0'
                ELSE
                    SELECT bmb16 INTO g_bmy.bmy16
                      FROM bmb_file
                     WHERE bmb01 = g_bmy.bmy14
                       AND bmb02 = g_bmy.bmy04
                       AND bmb29 = g_bmy.bmy29
                       AND (bmb04 IS NULL OR bmb04<=g_bmx.bmx07)
                       AND (bmb05 IS NULL OR bmb05 >g_bmx.bmx07)
                END IF
            END IF
        END IF
        IF g_bmy.bmy03 = '5' THEN
           IF g_bmy.bmy16 NOT MATCHES '[25]' THEN 
              LET g_status.code = "abm-033" #當變異碼(bmy03)為"5:替代"時，取替(bmy16)一定要為"2:可被替代"或"5:可被set替代".
              RETURN FALSE
           END IF
        END IF

        #=>新料料號(bmy27)
        IF NOT cl_null(g_bmy.bmy27) THEN
            CALL aws_ima01_chk(g_bmy.bmy27,'4')
            IF NOT cl_null(g_errno) THEN
                LET g_status.code = g_errno  
                RETURN FALSE
            END IF
            IF g_bmy.bmy03 != '1' THEN
                LET l_cnt = 0 
                SELECT COUNT(*) INTO l_cnt
                  FROM ima_file
                 WHERE ima01 = g_bmy.bmy27
                   AND (ima140 = 'N'
                    OR (ima140 = 'Y' AND ima1401 > g_bmx.bmx07)) 
                IF l_cnt = 0 THEN
                    LET g_status.code = "aim-809" #料件已Phase Out!
                    RETURN FALSE
                END IF
                IF g_bmy.bmy05 = g_bmy.bmy14 THEN 
                    LET g_status.code = "mfg2633" #元件料號不可與主件料號相同
                    RETURN FALSE
                END IF
            END IF
            IF g_bmy.bmy03 = '5' THEN
                #檢查替代料是否一存在于bmd_file
                LET l_cnt = 0
                SELECT COUNT(*) INTO l_cnt FROM bmd_file
                 WHERE bmd08 = g_bmy.bmy14
                   AND bmd01 = g_bmy.bmy05
                   AND bmd04 = g_bmy.bmy27
                   AND bmd02 = '2'
                IF l_cnt > 0 THEN
                    LET g_status.code = "abm-034" #此替代料關係已經存在
                    RETURN FALSE
                END IF
            END IF
        END IF
        IF g_bmy.bmy03 = '4' THEN
           IF cl_null(g_bmy.bmy27) THEN
               LET g_status.code = "aws-389" #變異碼為'4:取代'時,新料料號不可空白!
               RETURN FALSE
           END IF
           IF g_bmy.bmy05 = g_bmy.bmy27 THEN 
               LET g_status.code = "abm-619" #ECN變易方式選擇4.取代時，應控管變異元件料號不可與新元件料號相同!
               RETURN FALSE
           END IF              
        END IF

        #=>損耗率(bmy08)
        IF NOT cl_null(g_bmy.bmy08) THEN
            IF g_bmy.bmy08 < 0 OR g_bmy.bmy08 > 100 THEN
                LET g_status.code = "mfg4063" #本欄位之值不可小於零或大於 100, 請重新輸入
                RETURN FALSE
            END IF
        END IF

        #=>倉庫(bmy25)
        IF NOT cl_null(g_bmy.bmy25) THEN
            SELECT * FROM imd_file
             WHERE imd01 = g_bmy.bmy25
               AND imdacti = 'Y'
            IF SQLCA.SQLCODE THEN
                LET g_status.code = "mfg1100" #無此倉庫或性質不符!
                RETURN FALSE
            END IF
        END IF

        #=>存放位置(bmy26)
        IF NOT cl_null(g_bmy.bmy25) AND g_bmy.bmy26 IS NOT NULL THEN
            SELECT * FROM ime_file
             WHERE ime01 = g_bmy.bmy25
               AND ime02 = g_bmy.bmy26
               AND imeacti = 'Y'     #FUN-D40103
            IF SQLCA.SQLCODE THEN
                LET g_status.code = "asm-020" #無此倉庫+儲位資料
                RETURN FALSE
            END IF
        END IF

        #=>作業編號(bmy09)
        IF NOT cl_null(g_bmy.bmy09) THEN
            SELECT * FROM ecd_file
             WHERE ecd01 = g_bmy.bmy09
            IF SQLCA.SQLCODE THEN
                LET g_status.code = "aec-099" #無此作業編號
                RETURN FALSE
            END IF
        END IF

        #=>發料單位(bmy10)
        IF NOT cl_null(g_bmy.bmy10) THEN
            SELECT * FROM gfe_file
             WHERE gfe01 = g_bmy.bmy10
            IF STATUS THEN
                LET g_status.code = "afa-319" #此單位不存在請重新輸入
                RETURN FALSE
            END IF
            IF g_bmy.bmy03 = '4' THEN
               LET l_item = g_bmy.bmy27
            ELSE
               LET l_item = g_bmy.bmy05
            END IF
            INITIALIZE l_ima.* TO NULL      
            SELECT ima25,ima86 INTO l_ima.ima25,l_ima.ima86
              FROM ima_file
             WHERE ima01 = l_item 
            IF NOT cl_null(g_bmy.bmy10) AND g_bmy.bmy10 <> l_ima.ima25 THEN
                CALL s_umfchk(l_item,g_bmy.bmy10,l_ima.ima25)
                     RETURNING l_sw,l_bmy10_fac  #發料/庫存單位
                IF l_sw THEN
                    LET g_status.code = "mfg2721" #發料單位對庫存單位無轉換率
                    RETURN FALSE
                END IF
            END IF
            IF NOT cl_null(g_bmy.bmy10) AND g_bmy.bmy10 <> l_ima.ima86 THEN
                CALL s_umfchk(l_item,g_bmy.bmy10,l_ima.ima86)
                     RETURNING l_sw,l_bmy10_fac2
                IF l_sw THEN
                    LET g_status.code = "mfg2722" #發料單位對成本單位無轉換率
                    RETURN FALSE
                END IF
            END IF
        END IF

        #工單開立展開選項(bmy20)
        IF NOT cl_null(g_bmy.bmy20) THEN
            IF g_bmy.bmy20 NOT MATCHES '[1234]' THEN
                LET g_status.code = "aws-390" #工單開立選項不正確!
                RETURN FALSE
            END IF
        END IF

        #=>新原件明細
        INITIALIZE l_ima.* TO NULL      
        IF g_bmy.bmy03 = '4' THEN #取代
           SELECT ima25,ima86,ima110 INTO l_ima.ima25,l_ima.ima86,l_ima.ima110 FROM ima_file
            WHERE ima01=g_bmy.bmy27
        ELSE
           SELECT ima25,ima86,ima110 INTO l_ima.ima25,l_ima.ima86,l_ima.ima110 FROM ima_file
            WHERE ima01=g_bmy.bmy05
           IF g_bmy.bmy03 = '2' THEN #新增
               IF cl_null(g_bmy.bmy20) THEN
                   LET g_bmy.bmy20 = l_ima.ima110
               END IF
           END IF
        END IF
        IF g_bmy.bmy03 = '4' THEN
           LET l_item = g_bmy.bmy27
        ELSE
           LET l_item = g_bmy.bmy05
        END IF
        IF g_bmy.bmy03 MATCHES '[2345]' AND cl_null(g_bmy.bmy10) THEN  
            INITIALIZE l_bmb.* TO NULL      
            IF NOT cl_null(g_bmy.bmy04) THEN
                SELECT * INTO l_bmb.* FROM bmb_file
                 WHERE bmb01 = g_bmy.bmy14
                   AND bmb02 = g_bmy.bmy04
            ELSE
                SELECT * INTO l_bmb.* FROM bmb_file
                 WHERE bmb01 = g_bmy.bmy14
                   AND bmb03 = g_bmy.bmy05
                   AND bmb29 = g_bmy.bmy29
                   AND (bmb05 > g_bmx.bmx07 OR bmb05 IS NULL)
            END IF
            IF cl_null(g_bmy.bmy18) THEN #投料時距
                IF NOT cl_null(l_bmb.bmb18) THEN
                    LET g_bmy.bmy18 = l_bmb.bmb18 
                ELSE
                    LET g_bmy.bmy18 = 0
                END IF
            END IF
            IF cl_null(g_bmy.bmy08) THEN #損耗率
                IF NOT cl_null(l_bmb.bmb08) THEN
                    LET g_bmy.bmy08 = l_bmb.bmb08
                ELSE
                    LET g_bmy.bmy08 = 0
                END IF
            END IF
            IF cl_null(g_bmy.bmy09) THEN #作業編號
                IF NOT cl_null(l_bmb.bmb09) THEN
                    LET g_bmy.bmy09 = l_bmb.bmb09
                ELSE
                    LET g_bmy.bmy09 = ' '
                END IF
            END IF
            INITIALIZE l_ima.* TO NULL      
            SELECT ima63      ,ima63_fac      ,ima25
              INTO l_ima.ima63    ,l_ima.ima63_fac    ,l_ima.ima25
              FROM ima_file 
             WHERE ima01 = l_item
            IF cl_null(g_bmy.bmy10) THEN 
                LET g_bmy.bmy10 = l_ima.ima63
            END IF
            CALL s_umfchk(l_item,g_bmy.bmy10,l_ima.ima25)
                  RETURNING l_sw,l_ima.ima63_fac  #發料/庫存單位
            IF l_sw THEN 
                LET l_ima.ima63_fac = 1 
            END IF
            IF cl_null(g_bmy.bmy10_fac) THEN 
                LET g_bmy.bmy10_fac = l_ima.ima63_fac
            END IF
            IF cl_null(g_bmy.bmy20) THEN 
                LET g_bmy.bmy20 = l_bmb.bmb19
            END IF
        END IF 
        IF g_bmy.bmy03 MATCHES '[245]' THEN       
           INITIALIZE l_ima.* TO NULL      
           SELECT ima04,ima136,ima137,ima70,ima562
             INTO l_ima.ima04,l_ima.ima136,l_ima.ima137,l_ima.ima70,l_ima.ima562
             FROM ima_file 
            WHERE ima01=l_item
           IF cl_null(g_bmy.bmy11) THEN
               LET g_bmy.bmy11 = l_ima.ima04 
           END IF
           IF cl_null(g_bmy.bmy25) THEN
               LET g_bmy.bmy25 = l_ima.ima136    
           END IF
           #FUN-B70076---add----str----
           IF NOT cl_null(g_bmy.bmy25) THEN
              IF NOT s_chk_ware(g_bmy.bmy25) THEN  #检查仓库是否属于当前门店
                  LET g_bmy.bmy25 = ''
              END IF
           END IF
           #FUN-B70076---add----end----
           IF cl_null(g_bmy.bmy26) THEN
               LET g_bmy.bmy26 = l_ima.ima137  
           END IF
           IF cl_null(g_bmy.bmy21) THEN
               LET g_bmy.bmy21 = l_ima.ima70    
               IF cl_null(g_bmy.bmy21) THEN #元件消耗特性
                   LET g_bmy.bmy21 = 'N'  
               END IF
           END IF
           IF cl_null(g_bmy.bmy23) THEN 
               LET g_bmy.bmy23 = 0 
           END IF 
        END IF 
        LET g_bmy.bmy33 = '0'        #FUN-B70076 add
        LET g_bmy.bmyplant = g_plant #FUN-B70076 add
        LET g_bmy.bmylegal = g_legal #FUN-B70076 add
        #FUN-B70076---add---str---
        IF cl_null(g_bmy.bmy081) THEN
            LET g_bmy.bmy081 = 0
        END IF
        IF cl_null(g_bmy.bmy082) THEN
            LET g_bmy.bmy082 = 1
        END IF
        #FUN-B70076---add---end---
        #FUN-C20081---add---str---
        IF g_bmy.bmy03 = '1' THEN #新增                       
            IF cl_null(g_bmy.bmy07) THEN LET g_bmy.bmy07 = 1 END IF           #底數
            IF cl_null(g_bmy.bmy35) THEN LET g_bmy.bmy35 = '0' END IF         #元件使用特性
            IF cl_null(g_bmy.bmy18) THEN LET g_bmy.bmy18 = 0 END IF           #投料時距
            IF cl_null(g_bmy.bmy10_fac) THEN LET g_bmy.bmy10_fac = 1 END IF   #發料/料件庫存單位換算率
        END IF
        #FUN-C20081---add---end---
        #FUN-C50033-------add---str---
        IF g_bmy.bmy03 = '2' THEN 
            IF cl_null(g_bmy.bmy07) THEN LET g_bmy.bmy07 = 1 END IF           #底數
            IF cl_null(g_bmy.bmy08) THEN LET g_bmy.bmy08 = 0   END IF         #損耗率
            IF cl_null(g_bmy.bmy10_fac) THEN LET g_bmy.bmy10_fac = 1 END IF   #發料/料件庫存單位換算率
            IF cl_null(g_bmy.bmy18) THEN LET g_bmy.bmy18 = 0 END IF           #投料時距
            IF cl_null(g_bmy.bmy20) THEN 
                INITIALIZE l_ima.* TO NULL      
                SELECT ima25,ima86,ima110 
                  INTO l_ima.ima25,l_ima.ima86,l_ima.ima110
                  FROM ima_file
                WHERE ima01=g_bmy.bmy05
                LET g_bmy.bmy20 = l_ima.ima110
                IF cl_null(g_bmy.bmy20) THEN
                    LET g_bmy.bmy20 = '1' #工單開立展開選項 #1.不展開 
                END IF
            END IF
            IF cl_null(g_bmy.bmy35) THEN LET g_bmy.bmy35 = '0' END IF         #元件使用特性
        END IF
        #FUN-C50033-------add---end---

        INSERT INTO bmy_file VALUES (g_bmy.*)
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_status.code = "aws-551"
            RETURN FALSE
        END IF
        DECLARE get_plm_bmt_cur2 CURSOR FOR
         SELECT * 
           FROM plm_bmt
          WHERE bmt01 = g_bmb.bmb01
            AND bmt02 = g_bmb.bmb02
            AND bmt03 = g_bmb.bmb03
           ORDER BY bmt05
        FOREACH get_plm_bmt_cur2 INTO l_plm_bmt.*
            INITIALIZE g_bmw.* TO NULL
            LET g_bmw.bmw01 = g_bmy.bmy01
            LET g_bmw.bmw02 = g_bmy.bmy02
            LET g_bmw.bmw03 = l_plm_bmt.bmt05
            LET g_bmw.bmw04 = l_plm_bmt.bmt06
            LET g_bmw.bmw05 = l_plm_bmt.bmt07
            LET g_bmw.bmwplant = g_plant #FUN-B20003 add
            LET g_bmw.bmwlegal = g_legal #FUN-B20003 add
            INSERT INTO bmw_file VALUES (g_bmw.*)
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                LET g_status.code = "aws-556"
                RETURN FALSE
            END IF
        END FOREACH
        RETURN TRUE
END FUNCTION                                                      

FUNCTION aws_plm_ima01_chk(p_ima01,p_type)
   DEFINE  p_ima01   LIKE ima_file.ima01
   DEFINE  p_type    LIKE type_file.chr1 #'1':檢核bmy05元件 ,'3':檢核bmy14主件,'4':檢核bmy27新料
   DEFINE  l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT imaacti
      INTO l_imaacti
      FROM ima_file 
     WHERE ima01 = p_ima01
    IF SQLCA.SQLCODE = 100 THEN
        CASE p_type
              WHEN '1' 
                  LET g_errno = 'aws-194' #元件編號不存在料件主檔(ima_file)中!
              WHEN '3' 
                  LET g_errno = 'aws-196' #主件編號不存在料件主檔(ima_file)中!
              WHEN '4' 
                  LET g_errno = 'aws-387' #新料料號不存在料件主檔(ima_file)中!
        END CASE
        RETURN 
    END IF
    IF SQLCA.SQLCODE THEN
        LET g_errno = SQLCA.SQLCODE USING '-------'
        RETURN 
    END IF
    IF l_imaacti <>'Y' THEN LET g_errno = '9029'
        CASE p_type
              WHEN '1' 
                  LET g_errno = 'aws-197' #元件編號資料尚未確認,不可使用!
              WHEN '3' 
                  LET g_errno = 'aws-199' #主件編號資料尚未確認,不可使用!
              WHEN '4' 
                  LET g_errno = 'aws-388' #新料料號資料尚未確認,不可使用!
        END CASE
        RETURN 
    END IF
    LET g_errno = SQLCA.SQLCODE USING '-------'
END FUNCTION

FUNCTION aws_plm_cre_tmp()          # 建立本程式所有會用到的TEMP TABLE
  DROP TABLE plm_bmb
  CREATE TEMP TABLE plm_bmb(
                           bmb03   LIKE  bmb_file.bmb03,
                           bmb37   LIKE  bmb_file.bmb37) #FUN-C70083 add

  DROP TABLE plm_bmt
  CREATE TEMP TABLE plm_bmt(
                           bmt01   LIKE bmt_file.bmt01,
                           bmt02   LIKE bmt_file.bmt02,
                           bmt03   LIKE bmt_file.bmt03,
                           bmt04   LIKE bmt_file.bmt04,
                           bmt05   LIKE bmt_file.bmt05,
                           bmt06   LIKE bmt_file.bmt06,
                           bmt07   LIKE bmt_file.bmt07,
                           bmt08   LIKE bmt_file.bmt08)
 CREATE INDEX plm_bmt_01 ON plm_bmt (bmt01,bmt02,bmt03,bmt04,bmt05,bmt08)
END FUNCTION
#FUN-B20003
#DEV-C40005---add----str---
FUNCTION aws_create_plm_bom_a_delete()

    DELETE FROM bma_file
       WHERE bma01 = g_bma.bma01 AND bma06 = g_bma.bma06
    IF SQLCA.SQLCODE THEN
        LET g_errno = SQLCA.SQLCODE USING '-------'
    END IF
END FUNCTION
#DEV-C40005---add----end---
#TQC-C50229---add----str---
FUNCTION aws_create_plm_bom_bmb_chk() #BOM單身bmb_file合理性判斷
   DEFINE    l_ima25        LIKE ima_file.ima25
   DEFINE    l_ima86        LIKE ima_file.ima86
   DEFINE    l_bmb10_fac    LIKE bmb_file.bmb10_fac   
   DEFINE    l_bmb10_fac2   LIKE bmb_file.bmb10_fac2 
   DEFINE    l_sw           LIKE type_file.chr1

        #=>組成用量(bmb06)
        #組成用量不可小于零
          IF NOT cl_null(g_bmb.bmb06) THEN
             IF g_bmb.bmb14 <> '2' THEN
                IF g_bmb.bmb06 <= 0 THEN
                    LET g_status.code = "mfg2614" #組成用量不可小於零
                    LET g_status.description = "bmb06:",g_bmb.bmb06
                    RETURN FALSE
                END IF
             ELSE
                IF g_bmb.bmb06 >= 0 THEN        
                    LET g_status.code = "asf-603" #當為回收料時,組成用量應<0
                    LET g_status.description = "bmb06:",g_bmb.bmb06
                    RETURN FALSE
                END IF
             END IF
          END IF

        #=>底數(bmb07)
        IF NOT cl_null(g_bmb.bmb07) THEN
           IF g_bmb.bmb07 <= 0 THEN
               LET g_status.code = "mfg2615"   #主件底數不可小於等於零
               LET g_status.description = "bmb07:",g_bmb.bmb07
               RETURN FALSE
           END IF
        END IF

        #=>替代特性(bmb16)
        IF g_bmb.bmb16 NOT MATCHES '[01245]' THEN
            LET g_status.code = "aws-386" #取替代特性不正確!
            LET g_status.description = "bmb16:",g_bmb.bmb16
            RETURN FALSE
        END IF

        #=>損耗率(bmb08)
        IF NOT cl_null(g_bmb.bmb08) THEN
            IF g_bmb.bmb08 < 0 OR g_bmb.bmb08 > 100 THEN
                LET g_status.code = "mfg4063" #本欄位之值不可小於零或大於 100, 請重新輸入
                LET g_status.description = "bmb08:",g_bmb.bmb08
                RETURN FALSE
            END IF
        END IF

        #=>倉庫(bmb25)
        IF NOT cl_null(g_bmb.bmb25) THEN
            SELECT * FROM imd_file
             WHERE imd01 = g_bmb.bmb25
               AND imdacti = 'Y'
            IF SQLCA.SQLCODE THEN
                LET g_status.code = "mfg1100" #無此倉庫或性質不符!
                LET g_status.description = "bmb25:",g_bmb.bmb25
                RETURN FALSE
            END IF
        END IF

        #=>存放位置(bmb26)
        IF NOT cl_null(g_bmb.bmb25) AND g_bmb.bmb26 IS NOT NULL THEN
            SELECT * FROM ime_file
             WHERE ime01 = g_bmb.bmb25
               AND ime02 = g_bmb.bmb26
               AND imeacti = 'Y'      #FUN-D40103
            IF SQLCA.SQLCODE THEN
                LET g_status.code = "asm-020" #無此倉庫+儲位資料
                LET g_status.description = "bmb25:",g_bmb.bmb25,"+bmb26:",g_bmb.bmb26
                RETURN FALSE
            END IF
        END IF

        #=>作業編號(bmb09)
        IF NOT cl_null(g_bmb.bmb09) THEN
            SELECT * FROM ecd_file
             WHERE ecd01 = g_bmb.bmb09
            IF SQLCA.SQLCODE THEN
                LET g_status.code = "aec-099" #無此作業編號
                LET g_status.description = "bmb09:",g_bmb.bmb09
                RETURN FALSE
            END IF
        END IF

        #=>發料單位(bmb10)
        IF NOT cl_null(g_bmb.bmb10) THEN
            SELECT * FROM gfe_file
             WHERE gfe01 = g_bmb.bmb10
            IF STATUS THEN
                LET g_status.code = "afa-319" #此單位不存在請重新輸入
                LET g_status.description = "bmb10:",g_bmb.bmb10
                RETURN FALSE
            END IF
            LET l_ima25=""
            LET l_ima86=""
            SELECT ima25,ima86 INTO l_ima25,l_ima86
              FROM ima_file
             WHERE ima01 = g_bmb.bmb03
            IF NOT cl_null(g_bmb.bmb10) AND g_bmb.bmb10 <> l_ima25 THEN
                CALL s_umfchk(g_bmb.bmb03,g_bmb.bmb10,l_ima25)
                     RETURNING l_sw,l_bmb10_fac  #發料/庫存單位
                IF l_sw THEN
                    LET g_status.code = "mfg2721" #發料單位對庫存單位無轉換率
                    LET g_status.description = "bmb10:",g_bmb.bmb10
                    RETURN FALSE
                END IF
            END IF
            IF NOT cl_null(g_bmb.bmb10) AND g_bmb.bmb10 <> l_ima86 THEN
                CALL s_umfchk(g_bmb.bmb03,g_bmb.bmb10,l_ima86)
                     RETURNING l_sw,l_bmb10_fac2
                IF l_sw THEN
                    LET g_status.code = "mfg2722" #發料單位對成本單位無轉換率
                    LET g_status.description = "bmb10:",g_bmb.bmb10
                    RETURN FALSE
                END IF
            END IF
        END IF

        #工單開立展開選項(bmb19)
        IF NOT cl_null(g_bmb.bmb19) THEN
            IF g_bmb.bmb19 NOT MATCHES '[1234]' THEN
                LET g_status.code = "aws-390" #工單開立選項不正確!
                LET g_status.description = "bmb19:",g_bmb.bmb19
                RETURN FALSE
            END IF
        END IF
        RETURN TRUE
END FUNCTION
#TQC-C50229---add----end---
#FUN-D10092
