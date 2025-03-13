# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_bom_data.4gl
# Descriptions...: 提供建立 BOM 資料的服務
# Date & Author..: 2008/07/02 by Echo
# Memo...........:
# Modify.........: 新建立 FUN-850147
# Modify.........: No:FUN-A70134 10/09/27 By Mandy 
#                  1.CreateBOMData 增加自動確認功能
#                  2.增加傳多單身,可同時傳插件位置資料
# Modify.........: No:FUN-AA0018 10/10/08 By Mandy
#                  (1)當status='Y'時,要自動確認且發放
#                  (2)bmb01(主件料號)需檢查是否存在料件主檔
#                  (3)多階拋轉時,只有第一筆有自動確認,其他筆沒有確認成功
# Modify.........: No:FUN-AA0035 10/10/27 By Mandy
#                  (1)若有錯誤,錯誤訊息內加上錯誤的Key值
# Modify.........: No:FUN-AB0038 10/11/15 By Mandy 單身項次為4時程序會卡死
# Modify.........: No:FUN-AC0026 10/12/13 By Mandy PLM-資料中心功能
# Modify.........: No:FUN-B20003 11/02/10 By Mandy PLM-調整
# Modify.........: No:MOD-B50214 11/05/25 By Abby  增加取得bmb10_fac,bmb10_fac2欄位值
#-------------------------------------------------------------------------------------
# Modify.........: No:FUN-A70134 11/07/05 By Mandy GP5.25 PLM 追版,以上單號為GP5.1 單號
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
#-------------------------------------------------------------------------------------
#}
# Modify.........: No.CHI-D10044 13/03/04 By bart s_uima146()參數變更

DATABASE ds

#FUN-850147

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

DEFINE g_bma01    LIKE bma_file.bma01,
       g_bma06    LIKE bma_file.bma06
DEFINE g_bma      RECORD LIKE bma_file.*       #主件料件
DEFINE g_bmb      RECORD LIKE bmb_file.*
DEFINE g_ima08_h  LIKE ima_file.ima08        
DEFINE g_ima08_b  LIKE ima_file.ima08
#FUN-A70134--add----str--
DEFINE g_bmt      RECORD LIKE bmt_file.*
#FUN-A70134--add----end--
DEFINE g_msg      STRING                #FUN-AA0035 add
DEFINE g_msg_flag LIKE type_file.chr20  #FUN-AA0035 add

#[
# Description....: 提供建立 BOM 資料的服務(入口 function)
# Date & Author..: 2007/02/09 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_bom_data()
 
    
    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增 BOM 資料                                                           #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_bom_data_process()
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
FUNCTION aws_create_bom_data_process()
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
    DEFINE l_status  LIKE type_file.chr1     #FUN-A70134 add
    DEFINE l_commit  LIKE type_file.chr1     #FUN-AA0018 add
    DEFINE l_msg     STRING                  #FUN-AC0026 add
    
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的 BOM 資料                                        #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("bma_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
    
    LET l_sql =
       "SELECT * FROM bma_file WHERE bma01 = ?  AND bma06 = ? FOR UPDATE " #FUN-A70134(110705) mod
    LET l_sql=cl_forupd_sql(l_sql) #FUN-A70134(110705) add
    DECLARE i600_cl CURSOR FROM l_sql

    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'

    CALL s_decl_bmb()
   #FUN-AC0026---add----str---
    #建立臨時表,用于存放拋轉的資料
   #CALL s_dc_cre_temp_table("bma_file") RETURNING g_dc_tabname     #FUN-B20003 mark
    CALL s_dc_cre_temp_table("bma_file") RETURNING g_dc_tabname_bma #FUN-B20003 add
    
    #建立歷史資料拋轉的臨時表
    CALL s_dc_cre_temp_table("gex_file") RETURNING g_dc_hist_tab
   #FUN-AC0026---add----str---

    BEGIN WORK

    FOR l_i = 1 TO l_cnt1       
        LET l_commit = 'N' #FUN-AA0018
        LET g_msg_flag = 'bma_file' #FUN-AA0035 add
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "bma_file")        #目前處理單檔的 XML 節點
        LET l_status = aws_ttsrv_getParameter("status")                 #FUN-A70134 add
        LET g_bma01 = aws_ttsrv_getRecordField(l_node1, "bma01")        #取得此筆單檔資料的欄位值
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
        
        #----------------------------------------------------------------------#
        # 處理單身資料                                                         #
        #----------------------------------------------------------------------#
        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "bmb_file")       #取得目前單頭共有幾筆單身資料
        IF l_cnt2 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           EXIT FOR
        END IF
        LET g_msg_flag = 'bmb_file'     #FUN-AA0035 add
        FOR l_j = 1 TO l_cnt2
            LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "bmb_file")   #目前單身的 XML 節點
        
            LET g_bmb.bmb01 = g_bma.bma01
            LET g_bmb.bmb29 = g_bma.bma06

            #------------------------------------------------------------------#
            # 單身檔(bmb_file) Insert 動作                                     #
            #------------------------------------------------------------------#
            IF l_j = 1 THEN
               CALL aws_create_bom_b_delete()
            END IF 

            IF NOT aws_create_bom_b_default(l_node2,l_cnt) THEN   #檢查 BOM 單身欄位預設值           
               EXIT FOR
            END IF
 
            #-------------------------------------------------------------------#
            # RECORD資料傳到NODE                                                #
            #-------------------------------------------------------------------#
            #CALL aws_ttsrv_setRecordField_record(l_node2,base.Typeinfo.create(g_bmb))
            #FUN-A70134---add---str---
            CALL aws_ttsrv_setRecordField(l_node2, "bmb10",g_bmb.bmb10 )
            IF g_bmb.bmb01 IS NULL OR cl_null(g_bmb.bmb01) THEN        # KEY 不可空白
                LET g_bmb.bmb01 = g_bma.bma01
                CALL aws_ttsrv_setRecordField(l_node2, "bmb01",g_bmb.bmb01 )
            END IF
            IF g_bmb.bmb33 IS NULL OR cl_null(g_bmb.bmb33) THEN        # KEY 不可空白
                LET g_bmb.bmb33 = '0'
                CALL aws_ttsrv_setRecordField(l_node2, "bmb33",g_bmb.bmb33 )
            END IF
            #FUN-A70134---add---str---
            
            IF g_bmb.bmb29 IS NULL OR cl_null(g_bmb.bmb29) THEN        # KEY 不可空白
               #FUN-A70134--mod---str---
               #LET g_bmb.bmb29 = ' '
               #CALL aws_ttsrv_setRecordField(l_node2, "bmb29", ' ')
                LET g_bmb.bmb29 = g_bma.bma06
                CALL aws_ttsrv_setRecordField(l_node2, "bmb29", g_bmb.bmb29)
               #FUN-A70134--mod---end---
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
        #FUN-AA0035---add-----str---
        IF g_status.code <> '0' THEN
            EXIT FOR
        END IF
        #FUN-AA0035---add-----end---

        #FUN-A70134--add---str---
        #----------------------------------------------------------------------#
        # 處理第二單身插件位置資料(bmt_file)                                   #
        #----------------------------------------------------------------------#
        LET g_msg_flag = 'bmt_file'     #FUN-AA0035 add
        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "bmt_file")       #取得目前單頭共有幾筆單身資料
        
        FOR l_j = 1 TO l_cnt2
            LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "bmt_file")   #目前單身的 XML 節點
        

            #------------------------------------------------------------------#
            # 單身檔(bmt_file) Insert 動作                                     #
            #------------------------------------------------------------------#
            IF l_j = 1 THEN
               CALL aws_create_bom_b_delete2()
            END IF 

            IF NOT aws_create_bom_b_default2(l_node2,l_cnt) THEN   #檢查 BOM 單身欄位預設值           
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
        #FUN-A70134--add---end---

        IF g_status.code != "0" THEN   #如果單身處理有任何錯誤, 則離開
           EXIT FOR
        END IF
        
   #END FOR #FUN-AA0018 mark
   #FUN-A70134--mark--str---
   ##全部處理都成功才 COMMIT WORK
   #IF g_status.code = "0" THEN
   #   COMMIT WORK
   #ELSE
   #   ROLLBACK WORK
   #END IF
   #FUN-A70134--mark--end---

   #FUN-AA0018--mark--str---
   #FUN-A70134--add---str---
   #IF g_status.code = "0" THEN
   #    IF l_status = 'Y' THEN #執行確認段否
   #        CALL i600sub_y_chk(g_bma.bma01,g_bma.bma06)
   #        IF g_success = 'N' THEN
   #            LET g_status.code = g_errno
   #            ROLLBACK WORK
   #        ELSE
   #            CALL i600sub_y_upd(g_bma.bma01,g_bma.bma06)
   #            IF g_success = 'N' THEN
   #                LET g_status.code = g_errno
   #                ROLLBACK WORK
   #            ELSE
   #                COMMIT WORK
   #            END IF
   #        END IF
   #    ELSE
   #        COMMIT WORK
   #    END IF
   #ELSE
   #    ROLLBACK WORK
   #END IF
   #FUN-A70134--add---end---
   #FUN-AA0018--mark--end---

   #FUN-AA0018--add---str---
        IF g_status.code = "0" THEN
            LET g_msg_flag = 'bma_file' #FUN-AA0035 add
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
                           #FUN-AC0026----add----str---
                            ELSE
                                CALL i600sub_carry(g_bma.bma01,g_bma.bma06)
                                IF g_err_msg.getLength() <> 0 THEN
                                    LET g_status.code = 'aws-607'
                                    CALL cl_get_err_msg() RETURNING l_msg
                                    EXIT FOR
                                END IF
                           #FUN-AC0026----add----end---
                            END IF
                        END IF
                    END IF
                END IF
            END IF
        ELSE
            EXIT FOR
        END IF
        LET l_commit = 'Y'
    END FOR
    IF l_commit = 'N' THEN
        #FUN-AA0035--add----str---
        LET g_status.description = cl_getmsg(g_status.code, g_lang)   #取得error code
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
        #FUN-AC0026---add---str---
        IF g_status.code = 'aws-607' THEN
            LET g_status.description = g_status.description,"==>",l_msg
        END IF
        #FUN-AC0026---add---end---
        #FUN-AA0035--add----end---
        ROLLBACK WORK
    ELSE
        COMMIT WORK
    END IF

   #FUN-AA0018--add---end---
    #FUN-AC0026---add----str---
    CALL s_dc_drop_temp_table(g_dc_tabname)
    CALL s_dc_drop_temp_table(g_dc_hist_tab)
    #FUN-AC0026---add----end---
    
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
FUNCTION aws_create_bom_b_default(p_node,p_cnt)
    DEFINE p_node       om.DomNode,
           p_cnt        LIKE type_file.num10
    DEFINE l_imaacti    LIKE ima_file.imaacti
    DEFINE l_ima140     LIKE ima_file.ima140
    DEFINE l_ima1401    LIKE ima_file.ima1401
    DEFINE l_ima151     LIKE ima_file.ima151
    DEFINE l_ima63      LIKE ima_file.ima63       #FUN-A70134 add
    DEFINE l_ima25      LIKE ima_file.ima25       #MOD-B50214 add
    DEFINE l_ima86      LIKE ima_file.ima86       #MOD-B50214 add
    DEFINE l_bmb10_fac  LIKE bmb_file.bmb10_fac   #MOD-B50214 add
    DEFINE l_bmb10_fac2 LIKE bmb_file.bmb10_fac2  #MOD-B50214 add 
    DEFINE g_sw         LIKE type_file.num5       #MOD-B50214 add

    LET g_bmb.bmb02 = aws_ttsrv_getRecordField(p_node,"bmb02")    
    LET g_bmb.bmb03 = aws_ttsrv_getRecordField(p_node,"bmb03")    
    LET g_bmb.bmb04 = aws_ttsrv_getRecordField(p_node,"bmb04")    
    LET g_bmb.bmb05 = aws_ttsrv_getRecordField(p_node,"bmb05")    
    LET g_bmb.bmb30 = aws_ttsrv_getRecordField(p_node,"bmb30") 
    LET g_bmb.bmb01 = aws_ttsrv_getRecordField(p_node,"bmb01") #FUN-A70134 add
    LET g_bmb.bmb10 = aws_ttsrv_getRecordField(p_node,"bmb10") #FUN-A70134 add
    LET g_bmb.bmb29 = aws_ttsrv_getRecordField(p_node,"bmb29") #FUN-A70134 add
    LET g_bmb.bmb33 = aws_ttsrv_getRecordField(p_node,"bmb33") #FUN-A70134 add
    LET g_bmb.bmb10_fac = aws_ttsrv_getRecordField(p_node,"bmb10_fac")      #MOD-B50214 add
    LET g_bmb.bmb10_fac2 = aws_ttsrv_getRecordField(p_node,"bmb10_fac2")    #MOD-B50214 add


    #FUN-A70134---add----str---
    IF cl_null(g_bmb.bmb02) THEN 
        LET g_status.code = "mfg6138" #重要欄位不可空白
        RETURN FALSE
    END IF
    IF cl_null(g_bmb.bmb03) THEN 
        LET g_status.code = "mfg6138" #重要欄位不可空白
        RETURN FALSE
    END IF
    IF cl_null(g_bmb.bmb04) THEN 
        LET g_status.code = "mfg6138" #重要欄位不可空白
        RETURN FALSE
    END IF
    #FUN-A70134---add----end---
    #FUN-AA0035---add----str---
    IF cl_null(g_bmb.bmb01) THEN
        LET g_bmb.bmb01 = g_bma01
        CALL aws_ttsrv_setRecordField(p_node, "bmb01", g_bmb.bmb01)
    END IF
    #FUN-AA0035---add----end---
    #FUN-AA0018---add----str---
    LET l_imaacti = NULL
    SELECT imaacti
      INTO l_imaacti
      FROM ima_file 
     WHERE ima01 = g_bmb.bmb01
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
    #FUN-AA0018---add----end---

    SELECT imaacti,ima08,ima140,ima1401,ima151,ima63,ima25,ima86                    #FUN-A70134 add ima63  #MOD-B50214 add ima25,ima86
      INTO l_imaacti,g_ima08_b,l_ima140,l_ima1401,l_ima151,l_ima63,l_ima25,l_ima86  #FUN-A70134 add ima63  #MOD-B50214 add ima25,ima86
      FROM ima_file WHERE ima01 = g_bmb.bmb03
    CASE
       WHEN SQLCA.SQLCODE = 100
          LET g_status.code = 'mfg3021'     #無此元件料號,請重新輸入 #FUN-AA0018 mod
          RETURN FALSE
       WHEN l_imaacti='N'
          LET g_status.code = '9028'        #此筆資料已無效, 不可使用
       WHEN l_imaacti  MATCHES '[PH]'
          LET g_status.code = '9038'        #此筆資料的狀況碼非"確認",不可使>
          RETURN FALSE
    END CASE
    #FUN-A70134--add---str---
    IF cl_null(g_bmb.bmb10) THEN #單位預設
        LET g_bmb.bmb10 = l_ima63
    END IF
    #FUN-A70134--add---end---

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
   #FUN-A70134 mark---str---
   #DELETE FROM bmt_file                                    
   #   WHERE bmt01 = g_bmb.bmb01 AND bmt08 = g_bmb.bmb29
   #FUN-A70134 mark---end---

END FUNCTION

#FUN-A70134---add----str----
#[
# Description.....  BOM 設定單身(bmt_file)欄位預設值
# Date & Author..: 2010/07/28 by Mandy
# Parameter......: p_node   - om.DomNode - BOM 單身 XML 節點 
#                : p_cnt    - INTEGER    - 資料是否已存在，0:新增
# Return.........: l_status - INTEGER    - TRUE / FALSE 預設值檢查結果
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_bom_b_default2(p_node,p_cnt)
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
    RETURN TRUE
END FUNCTION

#[
# Description..... 刪除 BOM 單身插件位置(bmt_file)相關資料 
# Date & Author..: 2010/07/28 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_bom_b_delete2()

    DELETE FROM bmt_file                                    
       WHERE bmt01 = g_bmb.bmb01 AND bmt08 = g_bmb.bmb29

END FUNCTION
#FUN-A70134---add----end----
