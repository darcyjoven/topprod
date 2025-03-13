# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_billing_ap.4gl
# Descriptions...: 提供建立應付請款資料的服務
# Date & Author..: 2010/01/13 by Mandy
# Memo...........:
# Modify.........: 新建立 FUN-A10069
# Modify.........: No:FUN-A30084 2010/03/24 By Mandy 不需要給發票號碼(apa08)
# Modify.........: No:FUN-A30118 2010/03/31 By Mandy 加入產生aapt120單身資料
# Modify.........: No.FUN-AA0022 2010/10/13 By Mandy HR GP5.2 追版
# Modify.........: No:FUN-B10064 2011/03/04 By Mandy HR拋轉AP沒有產生子帳期的問題
# Modify.........: No:FUN-C50126 2012/12/22 By Abby HRM功能改善-僅拋AP時
# Modify.........: No.FUN-CC0142 13/01/11 By Nina HRM改善功能:增加類別E,代表"代扣款(HRM整合專用)"=>改為類別H
#
#}

DATABASE ds

#FUN-A10069

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
GLOBALS "../../aap/4gl/saapt110.global"  #FUN-C50126 add

#FUN-C50126 mark---str---
##FUN-B10064---add----str---
#GLOBALS
#DEFINE g_apa           RECORD LIKE apa_file.*
#END GLOBALS
##FUN-B10064---add----end---
#FUN-C50126 mark---end---

#FUN-C50126---add----str---
DEFINE g_first         LIKE type_file.chr1
DEFINE g_ap_doc        LIKE apa_file.apa01
DEFINE g_delete_apt04  LIKE apa_file.apa01
DEFINE g_azp03         LIKE azp_file.azp03
DEFINE g_bookno1       LIKE aza_file.aza81
DEFINE g_bookno2       LIKE aza_file.aza82
DEFINE g_dbsm          LIKE type_file.chr21
DEFINE g_plantm        LIKE type_file.chr10
DEFINE g_db_type       LIKE type_file.chr3
DEFINE g_db1           LIKE type_file.chr21
DEFINE g_flag1         LIKE type_file.chr1
DEFINE g_ver           LIKE type_file.chr20
#FUN-C50126---add----end---

#[
# Description....: 提供建立應付請款資料的服務(入口 function)
# Date & Author..: 2010/01/13 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_billing_ap()
 
    
    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增應付請款資料                                                           #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_billing_ap_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION


#[
# Description....: 依據傳入資訊新增 ERP 應付請款資料
# Date & Author..: 2010/01/13 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_billing_ap_process()
    DEFINE l_npp       RECORD LIKE npp_file.* #FUN-C50126 add
    DEFINE l_npq       RECORD LIKE npq_file.* #FUN-C50126 add
    DEFINE l_api       RECORD LIKE api_file.* #FUN-C50126 add
    DEFINE l_aph       RECORD LIKE aph_file.* #FUN-C50126 add
    DEFINE l_api03     LIKE api_file.api03    #FUN-C50126 add 項次
    DEFINE l_aph02     LIKE aph_file.aph02    #FUN-C50126 add 項次
    DEFINE l_npq02     LIKE aph_file.aph02    #FUN-C50126 add 項次
    DEFINE l_apb02     LIKE apb_file.apb02    #FUN-C50126 add 項次
    DEFINE l_apptype   LIKE type_file.chr1    #FUN-C50126 add
    DEFINE l_aag05     LIKE aag_file.aag05    #FUN-C50126 add
    DEFINE l_apa01_tmp LIKE apa_file.apa01    #FUN-C50126 add
    DEFINE l_sum_aph05f LIKE aph_file.aph05f  #FUN-C50126 add
    DEFINE l_sum_aph05  LIKE aph_file.aph05f  #FUN-C50126 add
    DEFINE g_bookno   LIKE aaa_file.aaa01
    DEFINE l_aaa03    LIKE aaa_file.aaa03
    DEFINE l_i        LIKE type_file.num10
    DEFINE l_j        LIKE type_file.num10
    DEFINE l_k        LIKE type_file.num10 #FUN-C50126 add
    DEFINE l_sql      STRING        
    DEFINE l_cnt      LIKE type_file.num10
    DEFINE l_cnt1     LIKE type_file.num10
    DEFINE l_cnt2     LIKE type_file.num10
    DEFINE l_apa00    LIKE apa_file.apa00
    DEFINE l_apa01    LIKE apa_file.apa01
    DEFINE l_apa02    LIKE apa_file.apa02
    DEFINE l_apa13    LIKE apa_file.apa13 #FUN-A30118 add
    DEFINE l_apa14    LIKE apa_file.apa14 #FUN-A30118 add
    DEFINE l_apa15    LIKE apa_file.apa15 #FUN-A30118 add
    DEFINE l_apb08    LIKE apb_file.apb08 #FUN-A30118 add
    DEFINE l_apb10    LIKE apb_file.apb10 #FUN-A30118 add
    DEFINE l_apb23    LIKE apb_file.apb23 #FUN-A30118 add
    DEFINE l_apb24    LIKE apb_file.apb24 #FUN-A30118 add
    DEFINE l_borrowtype LIKE npq_file.npq06 #FUN-C50126 add
    DEFINE l_node1    om.DomNode
    DEFINE l_node2    om.DomNode
    DEFINE l_flag     LIKE type_file.num10
    DEFINE l_return   RECORD                           #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                         apa01   STRING                #回傳的欄位名稱
                      END RECORD

        
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的應付請款資料                                      #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("apa_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
    
    #FUN-C50126---add----str---
    #value="NEW":此次功能改善後的版本
    #value=""   :此次功能改善前的版本
    LET g_ver = aws_ttsrv_getParameter("version")
    IF NOT cl_null(g_ver) AND g_ver = "NEW" THEN
        CALL aws_create_billing_ap_cre_tmp()          # 建立本程式所有會用到的TEMP TABLE
    END IF
    SELECT * INTO g_apz.* FROM apz_file WHERE apz00='0'
    SELECT * INTO g_aaz.* FROM aaz_file WHERE aaz00='0'
    #FUN-C50126---add----end---
    BEGIN WORK
    
    LET l_return.apa01 = NULL
    FOR l_i = 1 TO l_cnt1       
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "apa_file")   #目前處理單檔的 XML 節點
        LET l_apa01 = aws_ttsrv_getRecordField(l_node1, "apa01")   #取得此筆單檔資料的欄位值 #帳款編號
        #FUN-C50126---add---str---
        DELETE FROM npq_tmp
        LET g_first = 'N'
        IF NOT cl_null(g_ver) AND g_ver = "NEW" AND l_i = 1 THEN
            LET g_first = "Y"
            #第一筆代表是拋薪資總金額,
            #其單別是以aoos010 整體帳款類別(aza128)設定,
            #再依此帳款類別抓aapi203的AP單別(apt08)
            IF cl_null(g_aza.aza128) THEN
                LET g_status.code = "aws-810"   #TIPTOP 在系統參數設定作業(aoos010)未設定整體帳款類別,請查核!
                EXIT FOR
            END IF
        ELSE
            LET g_first = "N"
        END IF
        #FUN-C50126---add---end---
        IF NOT cl_null(l_apa01) THEN
            SELECT COUNT(*) 
              INTO l_cnt 
              FROM apa_file 
             WHERE apa01 = l_apa01
            IF l_cnt >= 1 THEN
                LET g_status.code = "afa-388"   #此單據已拋轉，不可重覆拋轉!
                EXIT FOR
            END IF
       #FUN-C50126--mark---str---
       #ELSE
       #    LET l_apa01 = g_aza.aza108 #應付單別
       #FUN-C50126--mark---end---
        END IF

        LET l_apa02 = aws_ttsrv_getRecordField(l_node1, "apa02")   #取得此筆單檔資料的欄位值 #帳款日期
        IF cl_null(l_apa02) THEN
            LET l_apa02 = g_today
            CALL aws_ttsrv_setRecordField(l_node1, "apa02", l_apa02)   
        END IF
        
       #FUN-C50126---add----str---
        IF NOT aws_create_billing_ap_default(l_node1) THEN         #給應付請款單頭預設值,並檢查應付請款重要欄位正確否
           EXIT FOR
        END IF
        LET l_apa01 = g_ap_doc #應付單別
       #FUN-C50126---add----end---

        #----------------------------------------------------------------------#
        # 應付請款自動取號                                                       #
        #----------------------------------------------------------------------#       
        CALL s_check_no("aap",l_apa01,"","12","apa_file","apa01","") 
             RETURNING l_flag,l_apa01
        IF NOT l_flag THEN
           LET g_status.code = "agl-247"   #應付請款自動取號失敗!
           EXIT FOR
        END IF
        CALL s_auto_assign_no("aap", l_apa01   , l_apa02   ,'12'       ,"apa_file","apa01","","","")
             RETURNING l_flag, l_apa01
        IF NOT l_flag THEN
           LET g_status.code = "agl-247"   #應付請款自動取號失敗
           EXIT FOR
        END IF
        
        CALL aws_ttsrv_setRecordField(l_node1, "apa01", l_apa01)   #更新 XML 取號完成後的應付請款單號欄位(apa01)

       #FUN-C50126---mark---str---
       #移至自動取號之前
       #IF NOT aws_create_billing_ap_default(l_node1) THEN         #給應付請款單頭預設值,並檢查應付請款重要欄位正確否
       #   EXIT FOR
       #END IF
       #FUN-C50126---mark---end---

        LET l_apa13 = aws_ttsrv_getRecordField(l_node1, "apa13")   #取得此筆單檔資料的欄位值 #幣別 #FUN-A30118 add
        LET l_apa14 = aws_ttsrv_getRecordField(l_node1, "apa14")   #取得此筆單檔資料的欄位值 #匯率 #FUN-A30118 add
        LET l_apa15 = aws_ttsrv_getRecordField(l_node1, "apa15")   #取得此筆單檔資料的欄位值 #稅別 #FUN-A30118 add
        
        LET l_sql = aws_ttsrv_getRecordSql(l_node1, "apa_file", "I", NULL)   #I 表示取得 INSERT SQL
   
        #----------------------------------------------------------------------#
        # 執行單頭 INSERT SQL                                                  #
        #----------------------------------------------------------------------#
        EXECUTE IMMEDIATE l_sql
        IF SQLCA.SQLCODE THEN
           LET g_status.code = SQLCA.SQLCODE
           LET g_status.sqlcode = SQLCA.SQLCODE
           EXIT FOR
        END IF
        LET g_apa.apa01 = l_apa01   #FUN-C50126 add
        LET g_aptype = g_apa.apa00  #FUN-C50126 add
        #FUN-B10064---add----str---
        CALL t110_ins_apc(g_apa.*)
        CALL t110_apc_check('') 
        #FUN-B10064---add----end---
       #FUN-A30118---mark---str---
       #IF l_i = l_cnt1 THEN
       #    LET l_return.apa01 = l_return.apa01 CLIPPED,l_apa01 CLIPPED
       #ELSE
       #    LET l_return.apa01 = l_return.apa01 CLIPPED,l_apa01 CLIPPED,","
       #END IF
       #FUN-A30118---mark---end---
        #FUN-C50126---add---str---
        IF NOT cl_null(g_ver) AND g_ver = 'NEW' THEN
            IF l_i = l_cnt1 THEN
                LET l_return.apa01 = l_return.apa01 CLIPPED,l_apa01 CLIPPED
            ELSE
                LET l_return.apa01 = l_return.apa01 CLIPPED,l_apa01 CLIPPED,","
            END IF
        END IF
        #FUN-C50126---add---end---
        IF cl_null(g_ver) THEN #FUN-C50126 add if 判斷:舊版本才需有單身,新版本不需要
           #FUN-A30118---add----str---
           #----------------------------------------------------------------------#
           # 處理單身資料                                                         #
           #----------------------------------------------------------------------#
           LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "apb_file")       #取得目前單頭共有幾筆單身資料
           IF l_cnt2 = 0 THEN
              LET g_status.code = "arm-034"   #無單身資料!
              EXIT FOR
           END IF
           
           FOR l_j = 1 TO l_cnt2
               LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "apb_file")   #目前單身的 XML 節點
           
               CALL aws_ttsrv_setRecordField(l_node2, "apb01", l_apa01)            #寫入自動編號產生的AP單號  
               CALL aws_ttsrv_setRecordField(l_node2, "apb02", l_j)                #項次
               CALL aws_ttsrv_setRecordField(l_node2, "apb09", 1)                  #數量
         
               LET l_apb23 = aws_ttsrv_getRecordField(l_node2, "apb23")   #取得此筆單檔資料的欄位值 #原幣單價
         
               SELECT azi04 
                 INTO t_azi04 
                 FROM azi_file 
                WHERE azi01 = l_apa13 
         
               SELECT azi03 
                 INTO g_azi03
                 FROM azi_file
                WHERE azi01 IN ( SELECT aza17 
                                   FROM aza_file 
                                  WHERE aza01='0')
         
               #==>原幣金額
               LET l_apb24 = l_apb23 * 1
               LET l_apb24 = cl_digcut(l_apb24,t_azi04)  
         
               #==>本幣單價
               LET l_apb08 = l_apb23 * l_apa14
               LET l_apb08 = cl_digcut(l_apb08,g_azi03)
         
               #==>本幣金額
               LET l_apb10 = l_apb24 * l_apa14        
               LET l_apb10 = cl_digcut(l_apb10,g_azi04) 
         
               CALL aws_ttsrv_setRecordField(l_node2, "apb24", l_apb24) 
               CALL aws_ttsrv_setRecordField(l_node2, "apb08", l_apb08)
               CALL aws_ttsrv_setRecordField(l_node2, "apb081",l_apb08)
               CALL aws_ttsrv_setRecordField(l_node2, "apb10", l_apb10)
               CALL aws_ttsrv_setRecordField(l_node2, "apb101",l_apb10)
               CALL aws_ttsrv_setRecordField(l_node2, "apb34", 'N')      
               CALL aws_ttsrv_setRecordField(l_node2, "apb29", '1')      
               CALL aws_ttsrv_setRecordField(l_node2, "apblegal",g_legal) #FUN-AA0022 add
           
               LET l_sql = aws_ttsrv_getRecordSql(l_node2, "apb_file", "I", NULL)   #I 表示取得 INSERT SQL
               #------------------------------------------------------------------#
               # 執行單身 INSERT SQL                                              #
               #------------------------------------------------------------------#
               EXECUTE IMMEDIATE l_sql
               IF SQLCA.SQLCODE THEN
                  LET g_status.code = SQLCA.SQLCODE
                  LET g_status.sqlcode = SQLCA.SQLCODE
                  EXIT FOR
               END IF
               IF l_i = l_cnt1 AND l_j = l_cnt2 THEN
                   LET l_return.apa01 = l_return.apa01 CLIPPED,l_apa01 CLIPPED
               ELSE
                   LET l_return.apa01 = l_return.apa01 CLIPPED,l_apa01 CLIPPED,","
               END IF
           END FOR
           IF g_status.code != "0" THEN   #如果單身處理有任何錯誤, 則離開
              EXIT FOR
           END IF
           #FUN-A30118---add----end---
        END IF #FUN-C50126 add if 判斷
        #FUN-C50126---add----str---
        IF NOT cl_null(g_ver) AND g_ver = "NEW" THEN  #新流程才會跑下段程式
            #----------------------------------------------------------------------#
            # 處理分錄資料                                                         #
            #----------------------------------------------------------------------#
            LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "npq_file")       #取得目前單頭共有幾筆單身資料
            IF l_cnt2 = 0 THEN
               #薪資總金額:有分錄:有直接付款:有多借方
               #企業負擔  :有分錄:無直接付款:有多借方
               #員工負擔  :無分錄:無直接付款:無多借方
               EXIT FOR
            END IF
            LET l_api03 = 1
            LET l_aph02 = 1
            LET l_npq02 = 0
            FOR l_k = 1 TO l_cnt2
                LET l_node2  = aws_ttsrv_getDetailRecord(l_node1, l_k, "npq_file")   #目前單身的 XML 節點

                #取得此筆npq_file資料的欄位值--------str----
                INITIALIZE l_npq.* TO NULL
                LET l_npq.npq03 = aws_ttsrv_getRecordField(l_node2, "npq03")         #科目
                LET l_npq.npq05 = aws_ttsrv_getRecordField(l_node2, "npq05")         #部門
                LET l_npq.npq06 = aws_ttsrv_getRecordField(l_node2, "npq06")         #借貸別
                LET l_npq.npq07f= aws_ttsrv_getRecordField(l_node2, "npq07f")        #原幣金額
                LET l_npq.npq24 = aws_ttsrv_getRecordField(l_node2, "npq24")         #原幣幣別
                LET l_apptype   = aws_ttsrv_getRecordField(l_node2, "apptype")       #請款單性質
                #取得此筆npq_file資料的欄位值--------end----
                IF g_first = "Y" OR l_apptype = "2" THEN #第一筆資料(g_first='Y'代表"薪資總金額"要拋分錄底稿;
                                                         #後續的資料用"請款單性質(apptype)HRM傳入的欄位"來判斷,
                                                         #apptype:1:不拋傳票==>代表:員工負擔
                                                         #apptype:2:要拋傳票==>代表:企業負擔
                    #==>新增分錄底稿單頭
                    IF l_k = 1 THEN
                        #分錄單頭-------------str----
                        INITIALIZE l_npp.* TO NULL
                        LET l_npp.nppsys  = "AP"     #系統別
                        LET l_npp.npp00   = 1        #類別
                        LET l_npp.npp01   = l_apa01  #單號
                        LET l_npp.npp011  = 1        #異動序號
                        LET l_npp.npp02   = l_apa02  #異動日期
                        LET l_npp.npptype = '0'      #分錄底稿類別,0:主帳別
                        LET l_npp.npplegal= g_legal  #所屬法人
                        INSERT INTO npp_file VALUES(l_npp.*)
                        IF SQLCA.SQLCODE THEN
                           LET g_status.code = SQLCA.SQLCODE
                           LET g_status.sqlcode = SQLCA.SQLCODE
                           EXIT FOR
                        END IF
                        #分錄單頭-------------end----
                        IF NOT aws_create_billing_ap_bookno() THEN
                            LET g_status.code = 'aoo-081' #(aoo-081)抓不到帳別
                            EXIT FOR
                        END IF
                    END IF
                    SELECT aag05 INTO l_aag05 FROM aag_file
                      WHERE aag01 = l_npq.npq03
                        AND aag00 = g_bookno1
                    IF SQLCA.sqlcode THEN
                       LET g_status.code = SQLCA.sqlcode
                       LET g_status.description = "SELECT aag05 Error!"
                       EXIT FOR
                    END IF
                    IF cl_null(l_aag05) OR l_aag05 = 'N' THEN #部門管理
                        LET l_npq.npq05 = ' '
                    END IF
                    INSERT INTO npq_tmp (npq06,npq03,npq05,npq24,npq07f)
                                 VALUES (l_npq.npq06,l_npq.npq03,l_npq.npq05,l_npq.npq24,l_npq.npq07f)
                    IF SQLCA.sqlcode THEN
                       LET g_status.code = SQLCA.sqlcode
                       LET g_status.description = "INSERT INTO npq_tmp Error!"
                       EXIT FOR
                    END IF
                END IF
            END FOR
            IF g_status.code != "0" THEN   #如果單身處理有任何錯誤, 則離開
               EXIT FOR
            END IF
            IF g_first = "Y" OR l_apptype = "2" THEN #第一筆資料(g_first='Y'代表"薪資總金額"要拋分錄底稿;
                                                     #後續的資料用"請款單性質(apptype)HRM傳入的欄位"來判斷,
                                                     #apptype:1:不拋傳票==>代表:員工負擔
                                                     #apptype:2:要拋傳票==>代表:企業負擔

                CALL aws_ttsrv_setRecordField(l_node2, "npqsys"  ,l_npp.nppsys)
                CALL aws_ttsrv_setRecordField(l_node2, "npq00"   ,l_npp.npp00)
                CALL aws_ttsrv_setRecordField(l_node2, "npq01"   ,l_npp.npp01)
                CALL aws_ttsrv_setRecordField(l_node2, "npq011"  ,l_npp.npp011)
                CALL aws_ttsrv_setRecordField(l_node2, "npqtype" ,l_npp.npptype)
                CALL aws_ttsrv_setRecordField(l_node2, "npqlegal",l_npp.npplegal)
                LET l_npq.npq02 = 0
                DECLARE npq_cur CURSOR FOR
                 SELECT npq06,npq03,npq05,npq24,SUM(npq07f)
                   FROM npq_tmp
                  GROUP BY npq06,npq03,npq05,npq24
                FOREACH npq_cur INTO l_npq.npq06,l_npq.npq03,l_npq.npq05,l_npq.npq24,l_npq.npq07f
                    #借貸別 (1.借 2.貸)
                    CALL aws_ttsrv_setRecordField(l_node2, "npq06"   ,l_npq.npq06)

                    #會計科目
                    CALL aws_ttsrv_setRecordField(l_node2, "npq03"   ,l_npq.npq03)

                    #部門編號
                    CALL aws_ttsrv_setRecordField(l_node2, "npq05"   ,l_npq.npq05)

                    #原幣幣別
                    CALL aws_ttsrv_setRecordField(l_node2, "npq24"   ,l_npq.npq24)

                    #項次
                    LET l_npq02 = l_npq02 + 1
                    CALL aws_ttsrv_setRecordField(l_node2, "npq02"   ,l_npq02)

                    #==>原幣金額
                    LET l_npq.npq07f =  cl_digcut(l_npq.npq07f,t_azi04)
                    CALL aws_ttsrv_setRecordField(l_node2, "npq07f",l_npq.npq07f)

                    #==>本幣金額
                    LET l_npq.npq07 = l_npq.npq07f * l_apa14
                    LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
                    CALL aws_ttsrv_setRecordField(l_node2, "npq07",l_npq.npq07)

                    #==>匯率
                    LET l_npq.npq25 = l_apa14
                    CALL aws_ttsrv_setRecordField(l_node2, "npq25",l_npq.npq25)


                    LET l_sql = aws_ttsrv_getRecordSql(l_node2, "npq_file", "I", NULL)   #I 表示取得 INSERT SQL
                    #------------------------------------------------------------------#
                    # 執行單身 INSERT SQL                                              #
                    #------------------------------------------------------------------#
                    EXECUTE IMMEDIATE l_sql
                    IF SQLCA.SQLCODE THEN
                       LET g_status.code = SQLCA.SQLCODE
                       LET g_status.sqlcode = SQLCA.SQLCODE
                       EXIT FOR
                    END IF

                    #資料總金額的AP及企業負擔的AP==>需給多借方api_file
                    IF l_npq.npq06 = '1' THEN               #借貸別:1:借
                        INITIALIZE l_api.* TO NULL
                        LET l_api.api01    = l_apa01        #帳款編號
                        LET l_api.api02    = '1'            #明細種類 #1.多借方  (當apa51='MISC')
                        LET l_api.api03    = l_api03        #項次
                        LET l_api.api04    = l_npq.npq03    #科目編號
                        LET l_api.api05f   = l_npq.npq07f   #原幣金額
                        LET l_api.api05    = l_npq.npq07    #本幣金額
                        LET l_api.api07    = l_npq.npq05    #部門
                        LET l_api.apilegal = l_npp.npplegal #所屬法人
                        INSERT INTO api_file VALUES(l_api.*)
                        IF SQLCA.SQLCODE THEN
                           LET g_status.code = SQLCA.SQLCODE
                           LET g_status.sqlcode = SQLCA.SQLCODE
                           EXIT FOR
                        END IF
                        LET l_api03 = l_api03 + 1
                    END IF

                    #資料總金額的AP,直接付款aph_file
                    IF g_first = "Y" AND                    #第一筆資料(g_first='Y'代表"薪資總金額")
                       l_npq.npq06 = '2' AND                #借貸別:2:貸
                       l_npq.npq03 <> g_delete_apt04 THEN   #剔除同aapi203的貸方科目
                        INITIALIZE l_aph.* TO NULL
                        LET l_aph.aph01    = l_apa01        #帳款編號
                        LET l_aph.aph02    = l_aph02        #項次
                       #LET l_aph.aph03    = 'G'            #性質:G:代扣款(HRM整合用)  #FUN-CC0142 mark
                        LET l_aph.aph03    = 'H'            #性質:H:代扣款(HRM整合用)  #FUN-CC0142 add
                        LET l_aph.aph04    = l_npq.npq03    #貸方科目編號
                        LET l_aph.aph05f   = l_npq.npq07f   #原幣金額
                        LET l_aph.aph05    = l_npq.npq07    #本幣金額
                        LET l_aph.aph13    = l_npq.npq24    #幣別
                        LET l_aph.aph14    = l_npq.npq25    #匯率
                        LET l_aph.aphlegal = l_npp.npplegal #所屬法人
                        LET l_aph.aph17    = 1              #子帳期項次
                        LET l_aph.aph19    = '1'            #收費別
                        INSERT INTO aph_file VALUES(l_aph.*)
                        IF SQLCA.SQLCODE THEN
                           LET g_status.code = SQLCA.SQLCODE
                           LET g_status.sqlcode = SQLCA.SQLCODE
                           EXIT FOR
                        END IF
                        LET l_aph02 = l_aph02 + 1
                    END IF
                END FOREACH

            END IF
            IF g_first = "Y" THEN                   #第一筆資料(g_first='Y'代表"薪資總金額")
                CALL t110_apc_check('w')
                SELECT SUM(aph05f),SUM(aph05)
                  INTO l_sum_aph05f,l_sum_aph05
                  FROM aph_file
                 WHERE aph01 = l_apa01
                   AND aph17 = 1

                UPDATE apa_file
                   SET apa35f = l_sum_aph05f,
                       apa35  = l_sum_aph05
                   WHERE apa01 = l_apa01
                IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
                   IF SQLCA.SQLCODE THEN
                       LET g_status.code = SQLCA.SQLCODE
                       LET g_status.sqlcode = SQLCA.SQLCODE
                       LET g_status.description = 'UPDATE apa_file Error'
                   ELSE
                       LET g_status.code = '9050' #資料更新失敗
                       LET g_status.sqlcode = '9050'
                       LET g_status.description = 'UPDATE apa_file Error!'
                   END IF
                   EXIT FOR
                END IF

                UPDATE apc_file
                   SET apc10 =apc10+l_sum_aph05f,
                       apc11 =apc11+l_sum_aph05 ,
                       apc13 =apc13-l_sum_aph05
                   WHERE apc01 =l_apa01
                     AND apc02 =1
                IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
                   IF SQLCA.SQLCODE THEN
                       LET g_status.code = SQLCA.SQLCODE
                       LET g_status.sqlcode = SQLCA.SQLCODE
                       LET g_status.description = 'UPDATE apc_file Error'
                   ELSE
                       LET g_status.code = '9050' #資料更新失敗
                       LET g_status.sqlcode = '9050'
                       LET g_status.description = 'UPDATE apc_file Error!'
                   END IF
                   EXIT FOR
                END IF

                UPDATE apg_file
                   SET apg05f=apg05f+l_sum_aph05f,
                       apg05 =apg05 +l_sum_aph05
                   WHERE apg01 =l_apa01
                     AND apg02 =1
                IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
                   IF SQLCA.SQLCODE THEN
                       LET g_status.code = SQLCA.SQLCODE
                       LET g_status.sqlcode = SQLCA.SQLCODE
                       LET g_status.description = 'UPDATE apg_file Error'
                   ELSE
                       LET g_status.code = '9050' #資料更新失敗
                       LET g_status.sqlcode = '9050'
                       LET g_status.description = 'UPDATE apg_file Error!'
                   END IF
                   EXIT FOR
                END IF
            END IF
        END IF
        #FUN-C50126---add----end---
    END FOR
    #全部處理都成功才 COMMIT WORK
    IF g_status.code = "0" THEN
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳 ERP 建立的應付請款單號
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
END FUNCTION


#[
# Description....: 應付請款設定欄位預設值
# Date & Author..: 2010/01/13 by Mandy
# Parameter......: p_node   - om.DomNode - 應付請款單頭 XML 節點 
# Return.........: l_status - INTEGER    - TRUE / FALSE 預設值檢查結果
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_billing_ap_default(p_node)
   DEFINE l_apt07     LIKE apt_file.apt07    #FUN-C50126 add
   DEFINE l_apt08     LIKE apt_file.apt08    #FUN-C50126 add
   DEFINE p_node      om.DomNode
   DEFINE l_apa       RECORD LIKE apa_file.*
   DEFINE l_aps       RECORD LIKE aps_file.*
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_gem05     LIKE gem_file.gem05
   DEFINE l_gemacti   LIKE gem_file.gemacti
   DEFINE l_depno     LIKE apa_file.apa22    
   DEFINE l_t1        LIKE apy_file.apyslip  
   DEFINE l_d_actno   LIKE apt_file.apt03    #借方科目
   DEFINE l_d_actno1  LIKE apt_file.apt031   #借方科目二
   DEFINE l_c_actno   LIKE apt_file.apt04    #貸方科目
   DEFINE l_c_actno1  LIKE apt_file.apt041   #貸方科目二
   DEFINE l_pmc03     LIKE pmc_file.pmc03
   DEFINE l_pmc04     LIKE pmc_file.pmc04
   DEFINE l_pmc05     LIKE pmc_file.pmc05
   DEFINE l_pmc17     LIKE pmc_file.pmc17
   DEFINE l_pmc22     LIKE pmc_file.pmc22
   DEFINE l_pmc24     LIKE pmc_file.pmc24
   DEFINE l_pmc26     LIKE pmc_file.pmc26
   DEFINE l_pmc47     LIKE pmc_file.pmc47
   DEFINE l_pmc54     LIKE pmc_file.pmc54
   DEFINE l_pmcacti   LIKE pmc_file.pmcacti
   DEFINE l_aziacti   LIKE azi_file.aziacti  

   LET l_apa.apa01 = aws_ttsrv_getRecordField(p_node,"apa01")
   LET l_apa.apa02 = aws_ttsrv_getRecordField(p_node,"apa02")
   LET l_apa.apa05 = aws_ttsrv_getRecordField(p_node,"apa05")
   LET l_apa.apa08 = aws_ttsrv_getRecordField(p_node,"apa08")
   LET l_apa.apa13 = aws_ttsrv_getRecordField(p_node,"apa13")
   LET l_apa.apa21 = aws_ttsrv_getRecordField(p_node,"apa21")
   LET l_apa.apa22 = aws_ttsrv_getRecordField(p_node,"apa22")
   LET l_apa.apa31f= aws_ttsrv_getRecordField(p_node,"apa31f")
   LET l_apa.apa36 = aws_ttsrv_getRecordField(p_node,"apa36")

   #==>預設值及將數值類變數清成零
   LET l_apa.apa00 = '12'
   IF cl_null(l_apa.apa21) THEN
       LET l_apa.apa21 = g_user
   END IF
   LET l_apa.apa17   = '1'
   LET l_apa.apa171  = '21'
   LET l_apa.apa172  = '1'
   LET l_apa.apa20   = 0
   LET l_apa.apa31   = 0
   LET l_apa.apa32f  = 0
   LET l_apa.apa32   = 0
   LET l_apa.apa65f  = 0
   LET l_apa.apa65   = 0
   LET l_apa.apa34f  = 0
   LET l_apa.apa34   = 0
   LET l_apa.apa35f  = 0
   LET l_apa.apa35   = 0
   LET l_apa.apa33f  = 0
   LET l_apa.apa37f  = 0   
   LET l_apa.apa37   = 0  
   LET l_apa.apa33   = 0
   LET l_apa.apa60f  = 0
   LET l_apa.apa60   = 0
   LET l_apa.apa61f  = 0
   LET l_apa.apa61   = 0
   LET l_apa.apa41   = 'N'
   LET l_apa.apa42   = 'N'
   LET l_apa.apa55   = '1'
   LET l_apa.apa56   = '0'
   LET l_apa.apa57f  = 0
   LET l_apa.apa57   = 0
   LET l_apa.apa74   = 'N'
   LET l_apa.apa75   = 'N'
   LET l_apa.apa63   = '0'
   LET l_apa.apaprno = 0
   LET l_apa.apainpd = g_today
   LET l_apa.apauser = g_user
   LET l_apa.apagrup = g_grup
   LET l_apa.apadate = g_today
   LET l_apa.apaacti = 'Y'              #資料有效
   LET l_apa.apa100  = g_plant   
   LET l_apa.apa930  = s_costcenter(l_apa.apa22)  
#FUN-C50126--add----str---
#搬移至此
   IF g_apz.apz13 = 'Y' THEN #是否依部門區分預設會計科目
      LET l_depno = l_apa.apa22
   ELSE
      LET l_depno = ' '
   END IF
  #FUN-C50126---add---str---
   IF g_first = 'Y' THEN
       #第一筆代表是拋薪資總金額,
       #其單別是以aoos010 整體帳款類別(aza128)設定,
       #再依此帳款類別抓aapi203的AP單別(apt08)
       LET l_apa.apa36 = g_aza.aza128
   END IF
  #FUN-C50126---add---end---

  #IF cl_null(l_apa.apa36) THEN                   #FUN-C50126 mark
   IF cl_null(l_apa.apa36) AND g_first = "N" THEN #FUN-C50126 add
       #ERP端"帳款類別"為必要欄位,請傳入!
       LET g_status.code = "aws-405"
       RETURN FALSE
   ELSE
      #FUN-C50126---mod---str----
      #SELECT     apt03,    apt031,    apt04,    apt041
      #  INTO l_d_actno,l_d_actno1,l_c_actno,l_c_actno1
       SELECT     apt03,    apt031,    apt04,    apt041,  apt07,  apt08 #apt08:AP單別
         INTO l_d_actno,l_d_actno1,l_c_actno,l_c_actno1,l_apt07,l_apt08
      #FUN-C50126---mod---end----
         FROM apt_file
        WHERE apt01 = l_apa.apa36
          AND apt02 = l_depno
       IF SQLCA.sqlcode THEN
           SELECT * INTO l_aps.*
             FROM aps_file
            WHERE aps01 = l_depno
           IF SQLCA.sqlcode THEN
               #ERP的"應付帳款系統部門預設科目維護作業(aapi202)"或"應付帳款系統帳款類別科目維護作業(aapi203)"未做相關設定,請檢核!
               LET g_status.code = 'aws-403'
               RETURN FALSE
           END IF
           LET l_d_actno = l_aps.aps21
           LET l_d_actno1= l_aps.aps211
           LET l_c_actno = l_aps.aps22
           LET l_c_actno1= l_aps.aps221
       END IF
       #FUN-C50126---add----str----
       IF NOT cl_null(g_ver) AND g_ver = "NEW" THEN
           #新流程的AP單別抓aapi203的
           LET g_ap_doc = l_apt08
           IF cl_null(g_ap_doc) THEN
               #TIPTOP 在應付帳款系統帳款類別科目維護作業(aapi203)未設定該帳款類別的AP單別,請查核!
               LET g_status.code = "aws-811"
               LET g_status.description = l_apa.apa36
               RETURN FALSE
           END IF
       ELSE
           #舊流程的AP單別抓aoos010的
           LET g_ap_doc = g_aza.aza108
           IF cl_null(g_ap_doc) THEN
               LET g_status.code = "aws-812"   #TIPTOP 在系統參數設定作業(aoos010)未設定應付單別(aza108),請查核!
               RETURN FALSE
           END IF
       END IF
       #FUN-C50126---add----end----
       IF cl_null(l_apa.apa51) THEN
           LET l_apa.apa51 = l_d_actno
           LET l_apa.apa511= l_d_actno1
       END IF
       IF cl_null(l_apa.apa54) THEN
           LET l_apa.apa54 = l_c_actno
           LET l_apa.apa541= l_c_actno1
       END IF
   END IF
   SELECT apyapr
     INTO l_apa.apamksg
     FROM apy_file
    WHERE apyslip = g_ap_doc
#FUN-C50126--add----end---
   #==>請款人員
   SELECT COUNT(*) INTO l_cnt 
     FROM gen_file 
    WHERE gen01   = l_apa.apa21
      AND genacti = 'Y'
   IF l_cnt = 0 THEN
       #請款人員資料不正確
       LET g_status.code = "aws-404"   
       RETURN FALSE
   END IF
   #FUN-C50126---add---str----
   IF g_first = 'Y' THEN
       LET l_apa.apa05 = l_apt07
   END IF
   #FUN-C50126---add---end----

   #請款廠商-----str---
   SELECT   pmc04,  pmc05,  pmcacti,pmc24
     INTO l_pmc04,l_pmc05,l_pmcacti,l_pmc24
     FROM pmc_file 
    WHERE pmc01 = l_apa.apa05
   CASE
      WHEN l_pmcacti = 'N'            LET g_status.code = 'aws-406' #傳入的"請款廠商"資料已無效,不可使用!
      WHEN l_pmcacti MATCHES '[PH]'   LET g_status.code = 'aws-407' #傳入的"請款廠商"資料的狀況碼非"確認",不可使用!
      WHEN l_pmc05   = '0'            LET g_status.code = 'aws-408' #傳入的"請款廠商"此廠商交易狀況為尚待核准,請查核..!
      WHEN l_pmc05   = '3'            LET g_status.code = 'aws-409' #傳入的"請款廠商"此廠商交易狀況為不准交易,請查核..!
      WHEN STATUS=100                 LET g_status.code = 'aws-410' #ERP端找不到傳入的請款廠商編號,請檢查!
      WHEN SQLCA.SQLCODE != 0         LET g_status.code = SQLCA.SQLCODE USING '-----'
   END CASE
   IF g_status.code <> "0" THEN
       RETURN FALSE
   END IF
   LET l_apa.apa06 = l_pmc04
   LET l_apa.apa18 = l_pmc24
   #請款廠商-----end---

   #付款廠商-----str---
   LET l_pmc03 = ''
   SELECT pmc03,pmc04,pmc05,pmc17,pmc22,pmc24,pmc26,pmc47,pmc54,pmcacti
     INTO l_pmc03,l_pmc04,l_pmc05,l_pmc17,l_pmc22,l_pmc24,
          l_pmc26,l_pmc47,l_pmc54,l_pmcacti
     FROM pmc_file
    WHERE pmc01 = l_apa.apa06
   CASE
      WHEN SQLCA.SQLCODE = 100        LET g_status.code = 'aws-411' #傳入的"請款廠商"其付款廠商資料不正確,請檢核ERP端(apmi600)的資料!
      WHEN l_pmcacti = 'N'            LET g_status.code = 'aws-411'
      WHEN l_pmcacti MATCHES '[PH]'   LET g_status.code = 'aws-411'     
      WHEN l_pmc05   = '0'            LET g_status.code = 'aws-411'
      WHEN l_pmc05   = '3'            LET g_status.code = 'aws-411'
      WHEN SQLCA.SQLCODE != 0         LET g_status.code = SQLCA.SQLCODE USING '-----'
   END CASE
   IF g_status.code <> "0" THEN
       RETURN FALSE
   END IF
   LET l_apa.apa07 = l_pmc03 #付款廠商簡稱
   LET l_apa.apa11 = l_pmc17 #付款條件
   LET l_apa.apa15 = l_pmc47 #稅別
   SELECT       gec04,      gec03,gec031      ,       gec08,       gec06 
     INTO l_apa.apa16,l_apa.apa52,l_apa.apa521,l_apa.apa171,l_apa.apa172        #稅率%
     FROM gec_file 
    WHERE gec01=l_apa.apa15 
      AND gec011='1'  
   #付款廠商-----end---

   #部門----str---
   SELECT   gem05,  gemacti  
     INTO l_gem05,l_gemacti
     FROM gem_file 
    WHERE gem01 = l_apa.apa22
   CASE WHEN SQLCA.SQLCODE = 100 LET g_status.code = 'aws-400' #ERP端找不到傳入的部門編號,請檢查!
        WHEN l_gemacti = 'N'     LET g_status.code = 'aws-401' #傳入的"部門編號"資料已無效,不可使用!
        WHEN l_gem05  = 'N'      LET g_status.code = 'aws-402' #傳入的"部門編號"非會計部門,不可使用!
        WHEN SQLCA.SQLCODE != 0  LET g_status.code = SQLCA.SQLCODE USING '-----'
   END CASE
   IF g_status.code <> "0" THEN
       RETURN FALSE
   END IF
   #部門----end---

#FUN-C50126--mark---str---
#搬移至前面
#  IF g_apz.apz13 = 'Y' THEN #是否依部門區分預設會計科目
#     LET l_depno = l_apa.apa22
#  ELSE
#     LET l_depno = ' '
#  END IF
#  LET l_t1 = s_get_doc_no(l_apa.apa01)
#  SELECT apyapr 
#    INTO l_apa.apamksg 
#    FROM apy_file 
#   WHERE apyslip = l_t1

#  IF cl_null(l_apa.apa36) THEN
#      #ERP端"帳款類別"為必要欄位,請傳入!
#      LET g_status.code = "aws-405"   
#      RETURN FALSE
#  ELSE
#      SELECT     apt03,    apt031,    apt04,    apt041 
#        INTO l_d_actno,l_d_actno1,l_c_actno,l_c_actno1 
#        FROM apt_file          
#       WHERE apt01 = l_apa.apa36 
#         AND apt02 = l_depno
#      IF SQLCA.sqlcode THEN
#          SELECT * INTO l_aps.* 
#            FROM aps_file 
#           WHERE aps01 = l_depno
#          IF SQLCA.sqlcode THEN
#              #ERP的"應付帳款系統部門預設科目維護作業(aapi202)"或"應付帳款系統帳款類別科目維護作業(aapi203)"未做相關設定,請檢核!
#              LET g_status.code = 'aws-403'
#              RETURN FALSE
#          END IF
#          LET l_d_actno = l_aps.aps21
#          LET l_d_actno1= l_aps.aps211          
#          LET l_c_actno = l_aps.aps22
#          LET l_c_actno1= l_aps.aps221         
#      END IF
#      IF cl_null(l_apa.apa51) THEN
#          LET l_apa.apa51 = l_d_actno
#          LET l_apa.apa511= l_d_actno1         
#      END IF
#      IF cl_null(l_apa.apa54) THEN
#          LET l_apa.apa54 = l_c_actno
#          LET l_apa.apa541= l_c_actno1        
#      END IF
#  END IF
#FUN-C50126--mark---end---
   #FUN-C50126---add----str---
   IF g_first = 'Y' THEN
       LET g_delete_apt04 = l_c_actno #第一張"資料總金額"的APS,其產生"直接付款"時,欲剔除的貸方科目
   END IF
   #FUN-C50126---add----end---
   IF cl_null(g_aza.aza63) OR g_aza.aza63 = 'N' THEN #使用多帳別功能
       LET l_apa.apa511 =NULL
       LET l_apa.apa541 =NULL
   END IF
   #幣別==>           
   SELECT azi04 INTO t_azi04
     FROM azi_file 
    WHERE azi01 = l_apa.apa13
      AND aziacti = 'Y'
   IF SQLCA.sqlcode THEN
      LET g_status.code = "agl-251"   #幣別資料不正確
      RETURN FALSE
   END IF
   IF l_apa.apa13 = g_aza.aza17 THEN
       LET l_apa.apa14=1
   ELSE
        SELECT apz33 INTO g_apz.apz33
          FROM apz_file
         WHERE apz00 = '0'
        CALL s_curr3(l_apa.apa13,l_apa.apa02,g_apz.apz33) 
        RETURNING l_apa.apa14 #匯率
   END IF
   LET l_apa.apa32f = l_apa.apa31f * l_apa.apa16 / 100 #原幣稅額
   LET l_apa.apa32f = cl_digcut(l_apa.apa32f,t_azi04)   
   LET l_apa.apa31  = l_apa.apa31f * l_apa.apa14       #本幣未稅
   LET l_apa.apa31  = cl_digcut(l_apa.apa31,g_azi04)   
   LET l_apa.apa32  = l_apa.apa31 * l_apa.apa16 / 100  #本幣稅額
   LET l_apa.apa32  = cl_digcut(l_apa.apa32,g_azi04)

   LET l_apa.apa09 = l_apa.apa02
   CALL s_paydate  ('a','',l_apa.apa09,l_apa.apa02,l_apa.apa11,l_apa.apa06)
        RETURNING l_apa.apa12,l_apa.apa64,l_apa.apa24
   LET l_apa.apa34f = l_apa.apa31f+l_apa.apa32f-l_apa.apa60f-l_apa.apa61f
                                               -l_apa.apa65f+l_apa.apa37f    
   LET l_apa.apa34f = cl_digcut(l_apa.apa34f,t_azi04)   
   LET l_apa.apa34  = l_apa.apa31 +l_apa.apa32 -l_apa.apa60 -l_apa.apa61
                                               -l_apa.apa65 +l_apa.apa37     
   LET l_apa.apa34  = cl_digcut(l_apa.apa34,g_azi04)   
   LET l_apa.apa57  = l_apa.apa31
   LET l_apa.apa57f = l_apa.apa31f
   LET l_apa.apa72  = l_apa.apa14
   LET l_apa.apa73  = l_apa.apa34 - l_apa.apa35 

   IF l_apa.apa32f = 0 THEN
       LET l_apa.apa52 = ''
   END IF
   IF l_apa.apa32 = 0 THEN
       LET l_apa.apa521 = ''
   END IF
  #FUN-A30084--mark---str---
  #LET l_apa.apa08 = YEAR(g_today)  USING '&&&&',
  #                  MONTH(g_today) USING '&&',
  #                  DAY(g_today)   USING '&&','-',
  #                  l_apa.apa08    USING '&&'
   LET l_apa.apa08 = NULL
  #FUN-A30084--mark---end---
  #FUN-AA0022--add----str---
   LET l_apa.apalegal= g_legal
   LET l_apa.apaoriu = g_user
   LET l_apa.apaorig = g_grup
  #FUN-C50126 mod str---
  #LET l_apa.apa79   = '0'
   IF NOT cl_null(g_ver) AND g_ver = 'NEW' THEN
       LET l_apa.apa79   = 'N' #HRM產生(新流程)
   ELSE
       LET l_apa.apa79   = 'O' #HRM產生(舊流程)
   END IF
  #FUN-C50126 mod end---
  #FUN-AA0022--add----end---
 

#-----------------------------------------
   CALL aws_ttsrv_setRecordField(p_node, "apa05"  , l_apa.apa05  ) #FUN-C50126 add
   CALL aws_ttsrv_setRecordField(p_node, "apa36"  , l_apa.apa36  ) #FUN-C50126 add
   CALL aws_ttsrv_setRecordField(p_node, "apa08"  , l_apa.apa08  )
   CALL aws_ttsrv_setRecordField(p_node, "apamksg", l_apa.apamksg)
   CALL aws_ttsrv_setRecordField(p_node, "apa52"  , l_apa.apa52  )
   CALL aws_ttsrv_setRecordField(p_node, "apa521" , l_apa.apa521 )
   CALL aws_ttsrv_setRecordField(p_node, "apa73"  , l_apa.apa73  )
   CALL aws_ttsrv_setRecordField(p_node, "apa72"  , l_apa.apa72  )
   CALL aws_ttsrv_setRecordField(p_node, "apa34f" , l_apa.apa34f )
   CALL aws_ttsrv_setRecordField(p_node, "apa34"  , l_apa.apa34  )
   CALL aws_ttsrv_setRecordField(p_node, "apa57"  , l_apa.apa57  )
   CALL aws_ttsrv_setRecordField(p_node, "apa57f" , l_apa.apa57f )
   CALL aws_ttsrv_setRecordField(p_node, "apa12"  , l_apa.apa12  )
   CALL aws_ttsrv_setRecordField(p_node, "apa64"  , l_apa.apa64  )
   CALL aws_ttsrv_setRecordField(p_node, "apa24"  , l_apa.apa24  )
   CALL aws_ttsrv_setRecordField(p_node, "apa09"  , l_apa.apa09  )
   CALL aws_ttsrv_setRecordField(p_node, "apa14"  , l_apa.apa14  )
   CALL aws_ttsrv_setRecordField(p_node, "apa07"  , l_apa.apa07  )
   CALL aws_ttsrv_setRecordField(p_node, "apa11"  , l_apa.apa11  )
   CALL aws_ttsrv_setRecordField(p_node, "apa15"  , l_apa.apa15  )
   CALL aws_ttsrv_setRecordField(p_node, "apa06"  , l_apa.apa06  )
   CALL aws_ttsrv_setRecordField(p_node, "apa18"  , l_apa.apa18  )
   CALL aws_ttsrv_setRecordField(p_node, "apa51"  , l_apa.apa51  )
   CALL aws_ttsrv_setRecordField(p_node, "apa511" , l_apa.apa511 )
   CALL aws_ttsrv_setRecordField(p_node, "apa54"  , l_apa.apa54  )
   CALL aws_ttsrv_setRecordField(p_node, "apa541" , l_apa.apa541 )
   CALL aws_ttsrv_setRecordField(p_node, "apa00"  , l_apa.apa00  )
   CALL aws_ttsrv_setRecordField(p_node, "apa21"  , l_apa.apa21  )
   CALL aws_ttsrv_setRecordField(p_node, "apa22"  , l_apa.apa22  )
   CALL aws_ttsrv_setRecordField(p_node, "apa14"  , l_apa.apa14  )
   CALL aws_ttsrv_setRecordField(p_node, "apa16"  , l_apa.apa16  )
   CALL aws_ttsrv_setRecordField(p_node, "apa17"  , l_apa.apa17  )
   CALL aws_ttsrv_setRecordField(p_node, "apa171" , l_apa.apa171 )
   CALL aws_ttsrv_setRecordField(p_node, "apa172" , l_apa.apa172 )
   CALL aws_ttsrv_setRecordField(p_node, "apa20"  , l_apa.apa20  )
   CALL aws_ttsrv_setRecordField(p_node, "apa31f" , l_apa.apa31f )
   CALL aws_ttsrv_setRecordField(p_node, "apa31"  , l_apa.apa31  )
   CALL aws_ttsrv_setRecordField(p_node, "apa32f" , l_apa.apa32f )
   CALL aws_ttsrv_setRecordField(p_node, "apa32"  , l_apa.apa32  )
   CALL aws_ttsrv_setRecordField(p_node, "apa65f" , l_apa.apa65f )
   CALL aws_ttsrv_setRecordField(p_node, "apa65"  , l_apa.apa65  )
   CALL aws_ttsrv_setRecordField(p_node, "apa34f" , l_apa.apa34f )
   CALL aws_ttsrv_setRecordField(p_node, "apa34"  , l_apa.apa34  )
   CALL aws_ttsrv_setRecordField(p_node, "apa35f" , l_apa.apa35f )
   CALL aws_ttsrv_setRecordField(p_node, "apa35"  , l_apa.apa35  )
   CALL aws_ttsrv_setRecordField(p_node, "apa33f" , l_apa.apa33f )
   CALL aws_ttsrv_setRecordField(p_node, "apa37f" , l_apa.apa37f )
   CALL aws_ttsrv_setRecordField(p_node, "apa37"  , l_apa.apa37  )
   CALL aws_ttsrv_setRecordField(p_node, "apa33"  , l_apa.apa33  )
   CALL aws_ttsrv_setRecordField(p_node, "apa60f" , l_apa.apa60f )
   CALL aws_ttsrv_setRecordField(p_node, "apa60"  , l_apa.apa60  )
   CALL aws_ttsrv_setRecordField(p_node, "apa61f" , l_apa.apa61f )
   CALL aws_ttsrv_setRecordField(p_node, "apa61"  , l_apa.apa61  )
   CALL aws_ttsrv_setRecordField(p_node, "apa41"  , l_apa.apa41  )
   CALL aws_ttsrv_setRecordField(p_node, "apa42"  , l_apa.apa42  )
   CALL aws_ttsrv_setRecordField(p_node, "apa55"  , l_apa.apa55  )
   CALL aws_ttsrv_setRecordField(p_node, "apa56"  , l_apa.apa56  )
   CALL aws_ttsrv_setRecordField(p_node, "apa57f" , l_apa.apa57f )
   CALL aws_ttsrv_setRecordField(p_node, "apa57"  , l_apa.apa57  )
   CALL aws_ttsrv_setRecordField(p_node, "apa74"  , l_apa.apa74  )
   CALL aws_ttsrv_setRecordField(p_node, "apa75"  , l_apa.apa75  )
   CALL aws_ttsrv_setRecordField(p_node, "apa63"  , l_apa.apa63  )
   CALL aws_ttsrv_setRecordField(p_node, "apaprno", l_apa.apaprno)
   CALL aws_ttsrv_setRecordField(p_node, "apainpd", l_apa.apainpd)
   CALL aws_ttsrv_setRecordField(p_node, "apauser", l_apa.apauser)
   CALL aws_ttsrv_setRecordField(p_node, "apagrup", l_apa.apagrup)
   CALL aws_ttsrv_setRecordField(p_node, "apadate", l_apa.apadate)
   CALL aws_ttsrv_setRecordField(p_node, "apaacti", l_apa.apaacti)
   CALL aws_ttsrv_setRecordField(p_node, "apa100" , l_apa.apa100 )
   CALL aws_ttsrv_setRecordField(p_node, "apa930" , l_apa.apa930 )
   #FUN-AA0022----add----str--
   CALL aws_ttsrv_setRecordField(p_node, "apalegal", l_apa.apalegal)
   CALL aws_ttsrv_setRecordField(p_node, "apaoriu" , l_apa.apaoriu)
   CALL aws_ttsrv_setRecordField(p_node, "apaorig" , l_apa.apaorig)
   CALL aws_ttsrv_setRecordField(p_node, "apa79"   , l_apa.apa79)
   #FUN-AA0022----add----end--
   LET g_apa.* = l_apa.* #FUN-B10064 add
   RETURN TRUE
END FUNCTION

#FUN-C50126---add----str---
FUNCTION aws_create_billing_ap_cre_tmp()          # 建立本程式所有會用到的TEMP TABLE
  DROP TABLE npq_tmp
  CREATE TEMP TABLE npq_tmp(
                           npq06   LIKE  npq_file.npq06,  #借貸別 (1.借 2.貸)
                           npq03   LIKE  npq_file.npq03,  #會計科目
                           npq05   LIKE  npq_file.npq05,  #部門編號
                           npq24   LIKE  npq_file.npq24,  #原幣幣別
                           npq07f  LIKE  npq_file.npq07f) #原幣金額

 CREATE INDEX npq_tmp_01 ON npq_tmp (npq06,npq03,npq05,npq24)
END FUNCTION

FUNCTION aws_create_billing_ap_bookno()
   IF g_apz.apz02='Y' THEN
      LET g_db1 = g_apz.apz02p
   ELSE
      LET g_db1 = g_plant
   END IF
   SELECT azp03 INTO g_azp03 FROM azp_file
    WHERE azp01=g_db1
   LET g_db_type=cl_db_get_database_type()

   LET g_plantm = g_db1
   LET g_dbsm = s_dbstring(g_azp03 CLIPPED)

   CALL s_get_bookno1(YEAR(g_apa.apa02),g_plantm)
        RETURNING g_flag1,g_bookno1,g_bookno2
   IF g_flag1 =  '1' THEN  #(aoo-081)抓不到帳別
       RETURN FALSE
   ELSE
       RETURN TRUE
   END IF
END FUNCTION
#FUN-C50126---add----end---
#FUN-AA0022
