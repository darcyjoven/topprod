# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_voucher_data.4gl
# Descriptions...: 提供建立傳票資料的服務
# Date & Author..: 2009/10/28 by Mandy
# Memo...........:
# Modify.........: 新建立 FUN-9A0090
# Modify.........: No:FUN-A30084 2010/03/25 By Mandy 當有做部門管理(agli102)的控管時,拋轉過來的部門不符合,TIPTOP這邊要能擋掉,show出err msg
# Modify.........: No.FUN-AA0022 2010/10/13 By Mandy HR GP5.2 追版
#
#}

DATABASE ds

#FUN-9A0090

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔


#[
# Description....: 提供建立傳票資料的服務(入口 function)
# Date & Author..: 2009/10/28 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_voucher_data()
 
    
    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增傳票資料                                                           #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_voucher_data_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION


#[
# Description....: 依據傳入資訊新增 ERP 傳票資料
# Date & Author..: 2009/10/28 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_voucher_data_process()
    DEFINE g_bookno   LIKE aaa_file.aaa01
    DEFINE l_aaa03    LIKE aaa_file.aaa03
    DEFINE l_i        LIKE type_file.num10
    DEFINE l_j        LIKE type_file.num10
    DEFINE l_sql      STRING        
    DEFINE l_cnt      LIKE type_file.num10
    DEFINE l_cnt1     LIKE type_file.num10
    DEFINE l_cnt2     LIKE type_file.num10
    DEFINE l_aba00    LIKE aba_file.aba00
    DEFINE l_aba01    LIKE aba_file.aba01
    DEFINE l_aba02    LIKE aba_file.aba02
    DEFINE l_aba08    LIKE aba_file.aba08
    DEFINE l_aba09    LIKE aba_file.aba09
    DEFINE l_abb03    LIKE abb_file.abb03
    DEFINE l_abb05    LIKE abb_file.abb05 #FUN-A30084 add
    DEFINE l_abb06    LIKE abb_file.abb06
    DEFINE l_abb24    LIKE abb_file.abb24
    DEFINE l_abb25    LIKE abb_file.abb25
    DEFINE l_abb07    LIKE abb_file.abb07
    DEFINE l_abb07f   LIKE abb_file.abb07f
    DEFINE l_node1    om.DomNode
    DEFINE l_node2    om.DomNode
    DEFINE l_flag     LIKE type_file.num10
    DEFINE l_return   RECORD                           #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                         aba01   LIKE aba_file.aba01   #回傳的欄位名稱
                      END RECORD

        
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的傳票資料                                        #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("aba_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
    
    BEGIN WORK
    
    FOR l_i = 1 TO l_cnt1       
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "aba_file")   #目前處理單檔的 XML 節點
        
        LET l_aba00 = aws_ttsrv_getRecordField(l_node1, "aba00")   #取得此筆單檔資料的欄位值 #帳別
        SELECT COUNT(*) INTO l_cnt 
          FROM aaa_file 
         WHERE aaa01 = l_aba00
        IF l_cnt = 0 THEN
           LET g_status.code = "agl-095"   #無此帳別
           EXIT FOR
        END IF
        LET g_bookno= l_aba00
        LET l_aba01 = aws_ttsrv_getRecordField(l_node1, "aba01")   #取得此筆單檔資料的欄位值 #傳票編號
        SELECT COUNT(*) INTO l_cnt 
          FROM aba_file 
         WHERE aba00 = l_aba00
           AND aba01 = l_aba01
        IF l_cnt >= 1 THEN
           LET g_status.code = "afa-388"   #此單據已拋轉，不可重覆拋轉!
           EXIT FOR
        END IF

        LET l_aba02 = aws_ttsrv_getRecordField(l_node1, "aba02")
        IF cl_null(l_aba02) THEN
            LET l_aba02 = g_today
            CALL aws_ttsrv_setRecordField(l_node1, "aba02", l_aba02)   
        END IF
        
        #----------------------------------------------------------------------#
        # 傳票自動取號                                                       #
        #----------------------------------------------------------------------#       
        CALL s_check_no("agl", l_aba01, "", "*",  "aba_file", "aba01", "") 
             RETURNING l_flag, l_aba01
        IF NOT l_flag THEN
           LET g_status.code = "agl-247"   #傳票自動取號失敗!
           EXIT FOR
        END IF

       #CALL s_auto_assign_no("AGL", l_aba01, l_aba02, ""  , "aba_file", "aba01",g_dbs,"",g_bookno)   #FUN-AA0022 mark
        CALL s_auto_assign_no("AGL", l_aba01, l_aba02, ""  , "aba_file", "aba01",g_plant,"",g_bookno) #FUN-AA0022 add
             RETURNING l_flag, l_aba01
        IF NOT l_flag THEN
           LET g_status.code = "agl-247"   #傳票自動取號失敗
           EXIT FOR
        END IF
        
        CALL aws_ttsrv_setRecordField(l_node1, "aba01", l_aba01)   #更新 XML 取號完成後的傳票單號欄位(aba01)
        
        IF NOT aws_create_voucher_data_default(l_node1) THEN       #給傳票單頭預設值,並檢查傳票重要欄位正確否
           EXIT FOR
        END IF
        
        LET l_sql = aws_ttsrv_getRecordSql(l_node1, "aba_file", "I", NULL)   #I 表示取得 INSERT SQL
   
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
        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "abb_file")       #取得目前單頭共有幾筆單身資料
        IF l_cnt2 = 0 THEN
           LET g_status.code = "arm-034"   #無單身資料!
           EXIT FOR
        END IF
        
        FOR l_j = 1 TO l_cnt2
            LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "abb_file")   #目前單身的 XML 節點
        
            CALL aws_ttsrv_setRecordField(l_node2, "abb01", l_aba01)            #寫入自動編號產生的傳票單號  
        
            #------------------------------------------------------------------#
            # 檢查單身資料是否正確                                         #
            #------------------------------------------------------------------#
            #會計科目==>
            LET l_abb03 = aws_ttsrv_getRecordField(l_node2, "abb03")
            SELECT COUNT(*) INTO l_cnt 
              FROM aag_file 
             WHERE aag01 = l_abb03
               AND aagacti = 'Y'
               AND aag07 <> '1'
               AND aag03 = '2'
            IF l_cnt = 0 THEN
               LET g_status.code = "agl-249"   #會計科目資料不正確
               EXIT FOR
            END IF
            #FUN-A30084---add----str-----
            LET l_abb05 = aws_ttsrv_getRecordField(l_node2, "abb05")
            CALL aws_create_voucher_abb05(l_abb03,l_abb05,g_bookno)
            IF NOT cl_null(g_errno) THEN
                LET g_status.code = g_errno
                EXIT FOR
            END IF
            #FUN-A30084---add----end-----

            #借/貸==>
            LET l_abb06 = aws_ttsrv_getRecordField(l_node2, "abb06")
            IF l_abb06 NOT MATCHES '[12]' THEN
               LET g_status.code = "agl-250"   #借/貨資料不正確
               EXIT FOR
            END IF

            #幣別==>           
            LET l_abb24 = aws_ttsrv_getRecordField(l_node2, "abb24")
            SELECT COUNT(*) INTO l_cnt 
              FROM azi_file 
             WHERE azi01 = l_abb24
               AND aagacti = 'Y'
            IF l_cnt = 0 THEN
               LET g_status.code = "agl-251"   #幣別資料不正確
               EXIT FOR
            END IF

            #原幣金額==>
            LET l_abb07f= aws_ttsrv_getRecordField(l_node2, "abb07f")
            IF cl_null(l_abb07f) OR l_abb07f < 0 THEN
               LET g_status.code = "agl-252"   #原幣金額不可空白，且金額需大於零
               EXIT FOR
            END IF

            #匯率==>
            CALL s_curr3(l_abb24,l_aba02,'M')
                 RETURNING l_abb25

            SELECT aaa03 INTO l_aaa03 
              FROM aaa_file 
             WHERE aaa01 = g_bookno

            IF l_aaa03 = l_abb24 THEN
                LET l_abb25 = 1
                LET l_abb07 = l_abb07f
            END IF

            #原幣金額==>
            SELECT azi04 INTO t_azi04 FROM azi_file  
             WHERE azi01 = l_abb24
            LET l_abb07f = cl_digcut(l_abb07f,t_azi04) 

            #本幣金額==>
            LET l_abb07 = l_abb07f * l_abb25
            SELECT azi04 INTO t_azi04 FROM azi_file 
             WHERE azi01 = l_aaa03  
            LET l_abb07 = cl_digcut(l_abb07,t_azi04)

            CALL aws_ttsrv_setRecordField(l_node2, "abb00" , g_bookno)
            CALL aws_ttsrv_setRecordField(l_node2, "abb25" , l_abb25)
            CALL aws_ttsrv_setRecordField(l_node2, "abb07" , l_abb07)
            CALL aws_ttsrv_setRecordField(l_node2, "abb07f", l_abb07f)
            CALL aws_ttsrv_setRecordField(l_node2, "abblegal",g_legal) #FUN-AA0022 add

            LET l_sql = aws_ttsrv_getRecordSql(l_node2, "abb_file", "I", NULL)   #I 表示取得 INSERT SQL
            
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
        #-->借方合計
        SELECT SUM(abb07) INTO l_aba08 
          FROM abb_file,aag_file
         WHERE abb00 = l_aba00
           AND aag00 = abb00   
           AND abb01 = l_aba01
           AND abb06 = '1' 
           AND aag09 = 'Y' 
           AND abb03 = aag01
          IF SQLCA.sqlcode THEN LET l_aba08 = 0 END IF
        #-->貸方合計
        SELECT SUM(abb07) INTO l_aba09 FROM abb_file,aag_file
         WHERE abb00 = l_aba00
           AND aag00 = abb00   #No.FUN-740020
           AND abb01 = l_aba01
           AND abb06 = '2' 
           AND abb03 = aag01 
           AND aag09 = 'Y'
          IF SQLCA.sqlcode THEN LET l_aba09 = 0 END IF
        IF cl_null(l_aba08) THEN LET l_aba08 = 0 END IF
        IF cl_null(l_aba09) THEN LET l_aba09 = 0 END IF
        UPDATE aba_file  
           SET aba08=l_aba08,
               aba09=l_aba09
         WHERE aba00 = l_aba00
           AND aba01 = l_aba01
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_status.code = "agl-253" #更新本幣借/貸方金額合計欄位失敗
        END IF
    END IF

    #全部處理都成功才 COMMIT WORK
    IF g_status.code = "0" THEN
       LET l_return.aba01 = l_aba01
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳 ERP 建立的傳票單號
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
    
END FUNCTION


#[
# Description....: 傳票設定欄位預設值
# Date & Author..: 2009/10/28 by Mandy
# Parameter......: p_node   - om.DomNode - 傳票單頭 XML 節點 
# Return.........: l_status - INTEGER    - TRUE / FALSE 預設值檢查結果
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_voucher_data_default(p_node)
    DEFINE p_node      om.DomNode
    DEFINE l_aba       RECORD LIKE aba_file.*
    DEFINE l_cnt       LIKE type_file.num5
    DEFINE l_t1        LIKE type_file.chr5
    DEFINE l_aac08     LIKE aac_file.aac08

    LET l_aba.aba02 = aws_ttsrv_getRecordField(p_node, "aba02")
    SELECT azn02      ,azn04 
      INTO l_aba.aba03,l_aba.aba04
      FROM azn_file
     WHERE azn01 = l_aba.aba02
    LET l_aba.aba05   = g_today #輸入日期
    LET l_aba.aba06   = 'CP'    #人事資資
    LET l_aba.aba08   = 0       #借方總金額
    LET l_aba.aba09   = 0       #貸方總金額
    LET l_aba.aba18   = '0'     #版本
    LET l_aba.aba19   ='N'      #確認碼
    LET l_aba.aba20   = 0       #狀態碼 #0:開立
    LET l_aba.aba35   = 'N'     #出納否
    LET l_aba.abasseq = 0
    LET l_aba.abapost = 'N'
    LET l_aba.abaprno = 0
    LET l_aba.abauser = g_user
    LET l_aba.abagrup = g_grup
    LET l_aba.abamodu = g_user
    LET l_aba.abadate = g_today
    LET l_aba.abaacti = 'Y'
    #FUN-AA0022----add----str--
    LET l_aba.abalegal= g_legal
    LET l_aba.abaoriu = g_user
    LET l_aba.abaorig = g_grup
    #FUN-AA0022----add----end--

    #簽核否=>
    LET l_aba.aba01 = aws_ttsrv_getRecordField(p_node, "aba01")
    LET l_t1 = s_get_doc_no(l_aba.aba01)
    SELECT aac08 
      INTO l_aac08
      FROM aac_file 
     WHERE aac01 = l_t1 
       AND aacacti = 'Y' 
       AND aac11='1'
    IF SQLCA.sqlcode THEN
        LET g_status.code = "agl-035" #無此傳票單別，或性質不符，請重新輸入
        RETURN FALSE
    END IF
    LET l_aba.abamksg = l_aac08

    CALL aws_ttsrv_setRecordField(p_node, "aba03", l_aba.aba03)
    CALL aws_ttsrv_setRecordField(p_node, "aba04", l_aba.aba04)
    CALL aws_ttsrv_setRecordField(p_node, "aba05", l_aba.aba05)
    CALL aws_ttsrv_setRecordField(p_node, "aba06", l_aba.aba06)
    CALL aws_ttsrv_setRecordField(p_node, "aba08", l_aba.aba08)
    CALL aws_ttsrv_setRecordField(p_node, "aba09", l_aba.aba09)
    CALL aws_ttsrv_setRecordField(p_node, "aba18", l_aba.aba18)
    CALL aws_ttsrv_setRecordField(p_node, "aba19", l_aba.aba19)
    CALL aws_ttsrv_setRecordField(p_node, "aba20", l_aba.aba20)
    CALL aws_ttsrv_setRecordField(p_node, "aba35", l_aba.aba35)
    CALL aws_ttsrv_setRecordField(p_node, "abasseq", l_aba.abasseq)
    CALL aws_ttsrv_setRecordField(p_node, "abapost", l_aba.abapost)
    CALL aws_ttsrv_setRecordField(p_node, "abaprno", l_aba.abaprno)
    CALL aws_ttsrv_setRecordField(p_node, "abauser", l_aba.abauser)
    CALL aws_ttsrv_setRecordField(p_node, "abagrup", l_aba.abagrup)
    CALL aws_ttsrv_setRecordField(p_node, "abamodu", l_aba.abamodu)
    CALL aws_ttsrv_setRecordField(p_node, "abadate", l_aba.abadate)
    CALL aws_ttsrv_setRecordField(p_node, "abaacti", l_aba.abaacti)
    CALL aws_ttsrv_setRecordField(p_node, "abamksg", l_aba.abamksg)
    #FUN-AA0022----add----str--
    CALL aws_ttsrv_setRecordField(p_node, "abalegal", l_aba.abalegal)
    CALL aws_ttsrv_setRecordField(p_node, "abaoriu" , l_aba.abaoriu)
    CALL aws_ttsrv_setRecordField(p_node, "abaorig" , l_aba.abaorig)
    #FUN-AA0022----add----end--


    #--------------------------------------------------------------------------#
    # 申請人資料是否正確
    #--------------------------------------------------------------------------#
    LET l_aba.aba24 = aws_ttsrv_getRecordField(p_node, "aba24")
    SELECT COUNT(*) INTO l_cnt 
      FROM gen_file 
     WHERE gen01   = l_aba.aba24
       AND genacti = 'Y'
    IF l_cnt = 0 THEN
        LET g_status.code = "agl-248"   #申請人資料不正確
        RETURN FALSE
    END IF

    RETURN TRUE
END FUNCTION

#FUN-A30084--add---str---
FUNCTION aws_create_voucher_abb05(p_abb03,p_abb05,p_bookno)
DEFINE p_bookno        LIKE aaa_file.aaa01
DEFINE p_abb03         LIKE abb_file.abb03
DEFINE p_abb05         LIKE abb_file.abb05
DEFINE l_aaz72         LIKE aaz_file.aaz72
DEFINE l_aaz90         LIKE aaz_file.aaz90
DEFINE l_gem02         LIKE gem_file.gem02,
       l_gem05         LIKE gem_file.gem05,
       l_gemacti       LIKE gem_file.gemacti,
       l_aag05         LIKE aag_file.aag05   

   LET g_errno = ' '
   SELECT aaz72,aaz90 INTO l_aaz72,l_aaz90
     FROM aaz_file
    WHERE aaz00 = '0'
   SELECT aag05 INTO l_aag05 FROM aag_file
     WHERE aag01 = p_abb03
       AND aag00 = p_bookno   
   IF l_aag05 = 'Y' THEN
       IF cl_null(p_abb05) THEN
           LET g_errno = 'aws-604' #要做部門管理,所以傳入部門不可空白
       END IF
      #目前只先做到:部門管理否='Y'時,則傳入的部門不可空白,無做部門設限的控管
      #IF l_aaz90 !='Y' THEN    
      #   CALL s_chkdept(l_aaz72,p_abb03,p_abb05,p_bookno)
      #         RETURNING g_errno
      #   IF NOT cl_null(g_errno) THEN
      #       RETURN
      #   END IF
      #END IF   
   END IF   
   IF NOT cl_null(p_abb05) THEN
       SELECT gem05  ,gemacti
         INTO l_gem05,l_gemacti 
         FROM gem_file
        WHERE gem01 = p_abb05
       CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-003'
            WHEN l_gemacti = 'N'     LET g_errno = '9028'
            WHEN l_gem05  = 'N'      LET g_errno = 'agl-202'
            OTHERWISE           LET g_errno = SQLCA.sqlcode USING '----------'
       END CASE
   END IF
END FUNCTION
#FUN-A30084--add---end---
#FUN-AA0022
