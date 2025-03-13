# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: aws_create_stock_in_data.4gl
# Descriptions...: 提供建立完工入庫單資料的服務(MES)
# Date & Author..: 2008/07/22 by sherry 
# Memo...........:
# Modify.........: 新建立 FUN-870028
# Modify.........: No:MOD-880015 08/08/04 By sherry remove g_cnt
# Modify.........: No:FUN-880006 08/08/09 By cci05 default 0
# Modify.........: No:FUN-870101 08/09/15 By jamie 帶入部門、單位、專案管理資料
# Modify.........: No:FUN-890094 08/09/19 By jamie 使用者、部門改由用global變數帶入 
# Modify.........: No:FUN-9A0095 09/12/25 By Lilan 1.當執行過程中,有發生任何錯誤,則TIPTOP系統中若產生單據資料時,
#                                                    需將該單據刪除
#                                                  2.若TIPTOP執行失敗,需回覆MES失敗(含原因),且MES系統也需Rollback
# Modify.........: No:TQC-AC0335 10/12/24 By Lilan 成品單位,應該要抓成品的生產單位(ima55)
# Modify.........: No:FUN-B10037 11/01/20 By Lilan 因新增"建立ERP報工單"函式,故取消產生工時資訊的功能
# Modify.........: No.FUN-B70074 11/07/22 By fengrui 添加行業別表的新增於刪除
# Modify.........: No:FUN-B80120 11/08/17 By Abby  1.MES拋轉產生入庫單前，需先判斷"料+倉+儲+批"是否存在庫存資料明細檔(img_file)。
#                                                  2.承1.，若不存在，則系統自動新增一筆"料+倉+儲+批"資料。(參照ERP給予預設值的方式)
# Modify.........: No.FUN-BC0104 12/01/29 By xianghui 數量異動回寫qco20

DATABASE ds

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

GLOBALS
DEFINE   g_sfu  RECORD LIKE sfu_file.*
DEFINE   g_sfv  RECORD LIKE sfv_file.*
#DEFINE   g_cnt  LIKE type_file.num5  #MOD-880015
END GLOBALS

#[
# Description....: 提供建立完工入庫單資料的服務(入口 function)
# Date & Author..: 
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_stock_in_data()
    
    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增完工入庫單資料                                                       #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_stock_in_data_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION

#[
# Description....: 依據傳入資訊新增 ERP 完工入庫單資料
# Date & Author..: 
# Parameter......: none
# Return.........: 入庫單號
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_stock_in_data_process()
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
    DEFINE l_cci      RECORD LIKE cci_file.*
    DEFINE l_ccj      RECORD LIKE ccj_file.*
    DEFINE l_yy,l_mm  LIKE type_file.num5       
    DEFINE l_status   LIKE sfu_file.sfuconf
    DEFINE l_cmd      STRING
    DEFINE l_prog     STRING
    DEFINE l_flag1    LIKE type_file.chr1       #FUN-B70074
    #FUN-BC0104-add-str--
    DEFINE l_sfv03  LIKE sfv_file.sfv03,
           l_sfv17  LIKE sfv_file.sfv17,
           l_sfv47  LIKE sfv_file.sfv47,
           l_flagg  LIKE type_file.chr1
    DEFINE l_cn     LIKE  type_file.num5
    DEFINE l_c      LIKE  type_file.num5
    DEFINE l_sfv_a  DYNAMIC ARRAY OF RECORD
           sfv17    LIKE  sfv_file.sfv17,
           sfv47    LIKE  sfv_file.sfv47,
           flagg    LIKE  type_file.chr1
                    END RECORD
    #FUN-BC0104-add-end--

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

    BEGIN WORK

    FOR l_i = 1 TO l_cnt1
        INITIALIZE l_sfu.* TO NULL
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "sfu_file")       #目前處理單檔的 XML 節點
        LET l_status = aws_ttsrv_getParameter("status")

        LET l_sfu.sfu01 = aws_ttsrv_getRecordField(l_node1, "sfu01")   #取得此筆單檔資料的欄位值
        LET l_sfu.sfu02 = aws_ttsrv_getRecordField(l_node1, "sfu02")
        LET l_sfu.sfu14 = l_sfu.sfu02  #FUN-880006
        
       #FUN-870101---add---str--- 
        LET l_sfu.sfuuser=g_user
        LET l_sfu.sfugrup=g_grup                     #FUN-890094 mod 
        LET l_sfu.sfudate=l_sfu.sfu02
       #FUN-870101---add---end--- 

        #----------------------------------------------------------------------#
        # 完工入庫單自動取號                                                   #
        #----------------------------------------------------------------------#      
        IF NOT cl_null(g_sma.sma53) AND l_sfu.sfu02 <= g_sma.sma53 THEN
           LET g_status.code = "mfg9999"
           EXIT FOR
        END IF

        CALL s_yp(l_sfu.sfu02) RETURNING l_yy,l_mm

        #不可大於現行年月a
        IF (l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
           LET g_status.code = 'mfg6091'
           EXIT FOR
        END IF

       #FUN-9A0095 add begin --------------------------
       #單據編號檢查
       #s_check_no(系統別,新單號,舊單號,單據性質,單據編號是否重複要檢查的table名稱,
       #           單據編號對應要檢查的key欄位名稱,工廠別)
       #Return Code....: li_result      結果(TRUE/FALSE)
       #                 ls_no          單據編號
       #Memo...........: CALL s_check_no("apm",g_pmw.pmw01,g_pmw_o.pmw01,"6","pmw_file","pmw01","") RETURNING li_result,g_pmw.pmw01
        CALL s_check_no("ASF",l_sfu.sfu01,"","A","sfu_file","sfu01","") 
            RETURNING l_flag,l_sfu.sfu01

        IF NOT l_flag THEN
           LET g_status.code = "apm-920"   #完工入庫單自動取號失敗
           EXIT FOR
        END IF

       #自動編號
       #s_auto_assign_no(系統別,單號,日期,單據性質,單據編號是否重複要檢查的table名稱,
       #                 單據編號對應要檢查的key欄位名稱,工廠別,RUNCARD,備用)
       #Return Code....: li_result   結果(TRUE/FALSE)
       #                 ls_no       單據編號
       #Memo...........: CALL s_auto_assign_no("apm",g_pmw.pmw01,g_pmw.pmw06,"","pmw_file","pmw01","","","","","","")
       #                 要使用多工廠必須傳"工廠別";若為runcard，則"RUNCARD"需傳"Y";總帳使用，則"備用"需傳帳別
        CALL s_auto_assign_no("ASF",l_sfu.sfu01,l_sfu.sfu02,"A","sfu_file","sfu01","","","")
             RETURNING l_flag, l_sfu.sfu01

        IF NOT l_flag THEN
           LET g_status.code = "apm-920"   #完工入庫單自動取號失敗
           EXIT FOR
        END IF
       #FUN-9A0095 add end --------------------------------

        #------------------------------------------------------------------#
        # 設定入庫單頭預設值                                               #
        #------------------------------------------------------------------#
        CALL aws_create_stockin_set_sfu(l_sfu.*) RETURNING l_sfu.*
        IF NOT cl_null(g_errno) THEN
           LET g_status.code = g_errno
           EXIT FOR
        END IF

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
        
       #FUN-B10037 mark str ------------
       #INITIALIZE l_cci.* TO NULL
       #LET l_cci.cci01 = l_sfu.sfu02
       #LET l_cci.cci02 = l_sfu.sfu04
       #IF cl_null(l_cci.cci02) THEN LET l_cci.cci02=' ' END IF
       #LET l_cci.ccifirm = 'N'
       #LET l_cci.cciinpd = g_today
       #LET l_cci.cciacti = 'Y'
       #LET l_cci.cciuser = l_sfu.sfuuser
       #LET l_cci.ccigrup = l_sfu.sfugrup
       #LET l_cci.ccimodu = l_sfu.sfumodu
       #LET l_cci.ccidate = l_sfu.sfudate
       #LET l_cci.cci05 = 0 #FUN-880006
       #SELECT COUNT(*) INTO l_cnt FROM cci_file #MOD-880015
       # WHERE cci01=l_cci.cci01
       #   AND cci02=l_cci.cci02
       #IF l_cnt=0 THEN #MOD_880015
       #   INSERT INTO cci_file VALUES(l_cci.*)
       #   IF SQLCA.SQLCODE THEN
       #      LET g_status.code = SQLCA.SQLCODE
       #      LET g_status.sqlcode = SQLCA.SQLCODE
       #   END IF
       #END IF
       #FUN-B10037 mark end ------------ 

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
           #LET l_sfv.sfv08 = aws_ttsrv_getRecordField(l_node2, "sfv08")  #FUN-870101 mark
            LET l_sfv.sfv09 = aws_ttsrv_getRecordField(l_node2, "sfv09")
            LET l_sfv.sfv11 = aws_ttsrv_getRecordField(l_node2, "sfv11")  #工單單號 , 可空白

          #TQC-AC0335 mark add --------
          ##FUN-870101---add---str---
          # SELECT sfa12 INTO l_sfv.sfv08 FROM sfa_file,sfb_file  
          #  WHERE sfa01=sfb01 
          #    AND sfb01=l_sfv.sfv11
          # IF g_aza.aza08 ="Y" THEN 
          #    SELECT sfb27,sfb271,sfb50 
          #      INTO l_sfv.sfv41,l_sfv.sfv42,l_sfv.sfv43
          #      FROM sfb_file
          #     WHERE sfb01=l_sfv.sfv11  
          # END IF 
          ##FUN-870101---add---end---
          #TQC-AC0335 mark end --------

           #TQC-AC0335 add str ---
            SELECT ima55 INTO l_sfv.sfv08
              FROM ima_file
             WHERE ima01 = l_sfv.sfv04
           #TQC-AC0335 add end ---

            #------------------------------------------------------------------#
            # 設定欄位預設值                                                   #
            #------------------------------------------------------------------#
            CALL aws_create_stockin_set_sfv_def(l_sfu.*,l_sfv.*) 
                 RETURNING l_sfv.*

           #FUN-B80120 add str---
            IF NOT cl_null(g_errno) THEN
               LET g_status.code = g_errno
               EXIT FOR
            END IF
           #FUN-B80120 add end---

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
    
           #FUN-B10037 mark str ------------
           #產生該單據所耗用的工時資訊於每日工時維護作業(axct200)
           #INITIALIZE l_ccj.* TO NULL
           #LET l_ccj.ccj01 = l_sfu.sfu02
           #LET l_ccj.ccj02 = l_sfu.sfu04
           #IF cl_null(l_ccj.ccj02) THEN LET l_ccj.ccj02=' ' END IF
           #SELECT MAX(ccj03)+1 INTO l_ccj.ccj03 FROM ccj_file
           # WHERE ccj01=l_ccj.ccj01
           #   AND ccj02=l_ccj.ccj02
           #IF cl_null(l_ccj.ccj03) THEN LET l_ccj.ccj03=1   END IF
           #LET l_ccj.ccj04 = l_sfv.sfv11
           #LET l_ccj.ccj06 = l_sfv.sfv09
           #LET l_ccj.ccj05 = aws_ttsrv_getRecordField(l_node2, "ccj05") 
           #LET l_ccj.ccj051= aws_ttsrv_getRecordField(l_node2, "ccj051")
           #LET l_ccj.ccj07 = aws_ttsrv_getRecordField(l_node2, "ccj07") 
           #LET l_ccj.ccj071= aws_ttsrv_getRecordField(l_node2, "ccj071")
           #INSERT INTO ccj_file VALUES(l_ccj.*)
           #IF SQLCA.SQLCODE THEN
           #   LET g_status.code = SQLCA.SQLCODE
           #   LET g_status.sqlcode = SQLCA.SQLCODE
           #END IF
           #FUN-B10037 mark end ------------
        END FOR
        IF g_status.code != "0" THEN   #如果單身處理有任何錯誤, 則離開
           EXIT FOR
        END IF
    END FOR
    
    IF g_status.code = "0" THEN
       LET l_return.sfu01 = l_sfu.sfu01
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF

    IF (l_status='Y') AND (g_status.code = "0") AND (l_sfu.sfumksg<>'Y') THEN
       LET l_prog = 'asft620'
       LET l_cmd=l_prog," '",l_sfu.sfu01 CLIPPED,"' 'stock_post'"

       CALL cl_cmdrun_wait(l_cmd)
       CALL aws_ttsrv_cmdrun_checkStatus(l_prog)

     #FUN-9A0095 add begin ------------
      IF g_status.code != "0" THEN
         BEGIN WORK

        #刪除已新增的入庫單頭
         DELETE FROM sfu_file WHERE sfu01 = l_sfu.sfu01
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("del","sfu_file",l_sfu.sfu01,"",SQLCA.SQLCODE,"","",1)
         END IF

        #FUN-BC0104-add-str--
        LET l_cn = 1
        DECLARE upd_sfv CURSOR FOR
         SELECT sfv03 FROM sfv_file WHERE sfv01 = l_sfu.sfu01
        FOREACH upd_sfv INTO l_sfv03
           CALL s_iqctype_sfv(l_sfu.sfu01,l_sfv03) RETURNING l_sfv17,l_sfv47,l_flagg
           LET l_sfv_a[l_cn].sfv17 = l_sfv17
           LET l_sfv_a[l_cn].sfv47 = l_sfv47
           LET l_sfv_a[l_cn].flagg = l_flagg
           LET l_cn = l_cn + 1
        END FOREACH
        #FUN-BC0104-add-end--    
        #刪除已新增的入庫單身
         DELETE FROM sfv_file WHERE sfv01 = l_sfu.sfu01
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("del","sfv_file",l_sfu.sfu01,"",SQLCA.SQLCODE,"","",1)
#FUN-B70074-add-delete--
         ELSE
            #FUN-BC0104-add-str--
            FOR l_c=1 TO l_cn-1
               IF l_sfv_a[l_c].flagg = 'Y' THEN
                  IF NOT s_iqctype_upd_qco20(l_sfv_a[l_c].sfv17,'','',l_sfv_a[l_c].sfv47,'2') THEN
                     LET g_success ='N'
                     RETURN
                  END IF
               END IF
            END FOR
            #FUN-BC0104-add-end-- 
            IF NOT s_industry('std') THEN 
               LET l_flag1=s_del_sfvi(l_sfu.sfu01,'','')
            END IF
#FUN-B70074-add-end-----
         END IF

       #FUN-B10037 mark str --------------
       ##刪除已新增的投入工時單頭
       # IF l_cnt = 0 THEN                      #l_cnt=0:工時單頭為此次新增才刪除
       #   DELETE FROM cci_file WHERE cci01 = l_cci.cci01 AND cci02 = l_cci.cci02
       #   IF SQLCA.SQLCODE THEN
       #      CALL cl_err3("del","cci_file",l_cci.cci01,l_cci.cci02,SQLCA.SQLCODE,"","",1)
       #   END IF
       # END IF
       #
       ##刪除已新增的投入工時單身
       # DELETE FROM ccj_file
       #  WHERE ccj01 = l_ccj.ccj01
       #    AND ccj02 = l_ccj.ccj02
       #    AND ccj03 = l_ccj.ccj03
       # IF SQLCA.SQLCODE THEN
       #    CALL cl_err3("del","ccj_file",l_ccj.ccj01,l_ccj.ccj02,SQLCA.SQLCODE,"","",1)
       # END IF
       #FUN-B10037 mark end ---------

         COMMIT WORK

         LET g_status.code = 'aws-522'         #TIPTOP執行失敗,回覆MES失敗(含原因)
      END IF
     #FUN-9A0095 add end -------------------------
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
#]
FUNCTION aws_create_stockin_set_sfu(l_sfu)
    DEFINE l_sfu RECORD LIKE sfu_file.*

    LET g_errno=NULL
    #--------------------------------------------------------------------------#
    # 設定完工入庫單單頭欄位預設值                                             #
    #--------------------------------------------------------------------------#
    LET l_sfu.sfu00 = '1'
    LET l_sfu.sfupost='N'
    LET l_sfu.sfuconf='N'
    LET l_sfu.sfuplant= g_plant  
    LET l_sfu.sfulegal= g_legal   
    LET l_sfu.sfu04 = g_grup           #部門
    LET l_sfu.sfu16 = g_user           #申請人
    LET l_sfu.sfu15 = '0'              #開立
    LET l_sfu.sfumksg = g_smy.smyapr   #是否簽核

    RETURN l_sfu.*
END FUNCTION

FUNCTION aws_create_stockin_set_sfv_def(l_sfu,l_sfv)
  DEFINE l_sfu    RECORD LIKE sfu_file.*
  DEFINE l_sfv    RECORD LIKE sfv_file.*
  DEFINE l_cnt    LIKE type_file.num5     #FUN-B80120

   LET g_errno=NULL  #FUN-B80120 add
  
   #--------------------------------------------------------------------------#
   # 設定完工入庫單單身欄位預設值  BEFORE INSERT           #
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

   LET l_sfv.sfvplant= g_plant
   LET l_sfv.sfvlegal= g_legal

  #FUN-B80120 add str---
   SELECT COUNT(*) INTO l_cnt FROM img_file
    WHERE img01=l_sfv.sfv04 AND img02=l_sfv.sfv05
      AND img03=l_sfv.sfv06 AND img04=l_sfv.sfv07
    IF cl_null(l_cnt) OR l_cnt <= 0 THEN
      CALL s_add_img(l_sfv.sfv04,l_sfv.sfv05,
                     l_sfv.sfv06,l_sfv.sfv07,
                     l_sfu.sfu01,l_sfv.sfv03,
                     g_today)
      IF g_errno='N' THEN
         RETURN l_sfv.*
      END IF
   END IF
  #FUN-B80120 add end---

   RETURN l_sfv.*
END FUNCTION

