# Prog. Version..: '5.30.06-13.03.12(00000)'     #
# Program name...: aws_create_issue_return_data.4gl
# Descriptions...: 提供建立退料單資料的服務 asfi528
# Date & Author..: 2008/07/22 by sherry 
# Memo...........:
# Modify.........: 新建立 FUN-870028
#
# Modify.........: No:FUN-880006 08/08/09 By sherry  sfp03扣帳日期預設輸入日期sfp02
# Modify.........: No:FUN-870101 08/09/16 By jamie 作業編號抓備料的作業編號給值 (NULL 給空白),部門 抓 user 所屬部門給值
# Modify.........: No:FUN-890094 08/09/19 By jamie 使用者、部門改由用global變數帶入 
# Modify.........: No:FUN-9A0095 09/12/25 By Lilan 1.當執行過程中,有發生任何錯誤,則TIPTOP系統中若產生單據資料時,需將該單據刪除
#                                                  2.若TIPTOP執行失敗,需回覆MES失敗(含原因),且MES系統也需Rollback
#                                                  3.增加接收[作業編號](sfs10)
# Modify.........: No:FUN-B30167 11/03/29 By Abby  當設定由TIPTOP發起退料單時,控制不可呼叫建立退料單Service
# Modify.........: No:FUN-A10022 11/05/19 By Lilan sfs27(被替代料號)須給值,FOR GP5.25相關調整
# Modify.........: No:FUN-B50136 11/06/03 By Lilan 因應EF整合功能新增的欄位所做的調整
# Modify.........: No:FUN-B70074 11/07/26 By lixh1 增加行業別TABLE(sfsi_file)的處理

DATABASE ds

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

GLOBALS
DEFINE   g_sfp  RECORD LIKE sfp_file.*
DEFINE   g_sfq  RECORD LIKE sfq_file.*
DEFINE   g_sfs  RECORD LIKE sfs_file.*
END GLOBALS

FUNCTION aws_create_issue_return_data()
    
    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增單據資料                                                             #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
    #FUN-B30167 add begin ----------
       IF g_aza.aza96='N' THEN
          LET g_status.code ='aws-608'
       ELSE
    #FUN-B30167 add end ------------
          CALL aws_create_issue_return_data_process()
       END IF         #FUN-B30167 add
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION


# Description....: 依據傳入資訊新增 ERP 退料單資料
# Date & Author..: 
# Parameter......: none
# Return.........: 退料單號
# Memo...........:
# Modify.........:
#
FUNCTION aws_create_issue_return_data_process()
    DEFINE l_i        LIKE type_file.num10,
           l_j        LIKE type_file.num10
    DEFINE l_sql      STRING
    DEFINE l_cnt      LIKE type_file.num10,
           l_cnt1     LIKE type_file.num10,
           l_cnt2     LIKE type_file.num10
    DEFINE l_node1    om.DomNode,
           l_node2    om.DomNode
    DEFINE l_flag     LIKE type_file.num10
    DEFINE l_flag1    LIKE type_file.chr1   #FUN-B70074
    DEFINE l_return   RECORD                           #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                         sfp01   LIKE sfp_file.sfp01   #回傳的欄位名稱
                      END RECORD
    DEFINE l_sfp      RECORD LIKE sfp_file.*
    DEFINE l_sfs      RECORD LIKE sfs_file.*
    DEFINE l_yy,l_mm  LIKE type_file.num5       
    DEFINE l_status   LIKE sfp_file.sfpconf
    DEFINE l_cmd      STRING
    DEFINE l_prog     STRING

    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的退料單資料                                    #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("sfp_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
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
        INITIALIZE l_sfp.* TO NULL
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "sfp_file")        #目前處理單檔的 XML 節點
        LET l_status = aws_ttsrv_getParameter("status")

        LET l_sfp.sfp01 = aws_ttsrv_getRecordField(l_node1, "sfp01")    #取得此筆單檔資料的欄位值
        LET l_sfp.sfp02 = aws_ttsrv_getRecordField(l_node1, "sfp02")
       #LET l_sfp.sfp03 = aws_ttsrv_getRecordField(l_node1, "sfp03")
        LET l_sfp.sfp03 = l_sfp.sfp02 #FUN-880006
        IF NOT cl_null(g_sma.sma53) AND l_sfp.sfp03 <= g_sma.sma53 THEN
           LET g_status.code = "mfg9999"
           EXIT FOR
        END IF

        CALL s_yp(l_sfp.sfp03) RETURNING l_yy,l_mm

        #不可大於現行年月
        IF (l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
           LET g_status.code = 'mfg6091'
           EXIT FOR
        END IF
       #LET l_sfp.sfp07 = aws_ttsrv_getRecordField(l_node1, "sfp07") #FUN-870101 mark

       #FUN-870101---add---str--- 
       #SELECT gen03 INTO l_sfp.sfp07 FROM gen_file   #FUN-890094 mark
       # WHERE gen01= g_user                          #FUN-890094 mark 
        LET l_sfp.sfpuser=g_user
       #LET l_sfp.sfpgrup=l_sfp.sfp07                 #FUN-890094 mark
        LET l_sfp.sfpgrup=g_grup                      #FUN-890094 mod
        LET l_sfp.sfpdate=l_sfp.sfp02
       #FUN-870101---add---end--- 

       #單據編號檢查
       #FUN-9A0095 add begin --------------------------
       #單據編號檢查
       #s_check_no(系統別,新單號,舊單號,單據性質,單據編號是否重複要檢查的table名稱,
       #           單據編號對應要檢查的key欄位名稱,工廠別)
       #Return Code....: li_result      結果(TRUE/FALSE)
       #                 ls_no          單據編號
       #Memo...........: CALL s_check_no("apm",g_pmw.pmw01,g_pmw_o.pmw01,"6","pmw_file","pmw01","") RETURNING li_result,g_pmw.pmw01
        CALL s_check_no("ASF",l_sfp.sfp01,"","4","sfp_file","sfp01","") RETURNING l_flag,l_sfp.sfp01

        IF NOT l_flag THEN
           LET g_status.code = "apm-920"   #退料單自動取號失敗
           EXIT FOR
        END IF

       #自動編號
       #s_auto_assign_no(系統別,單號,日期,單據性質,單據編號是否重複要檢查的table名稱,
       #                 單據編號對應要檢查的key欄位名稱,工廠別,RUNCARD,備用)
       #Return Code....: li_result   結果(TRUE/FALSE)
       #                 ls_no       單據編號
       #Memo...........: CALL s_auto_assign_no("apm",g_pmw.pmw01,g_pmw.pmw06,"","pmw_file","pmw01","","","","","","")
       #                 要使用多工廠必須傳"工廠別";若為runcard，則"RUNCARD"需傳"Y";總帳使用，則"備用"需傳帳別
        CALL s_auto_assign_no("ASF",l_sfp.sfp01,l_sfp.sfp02,"4","sfp_file","sfp01","","","")
         RETURNING l_flag, l_sfp.sfp01

        IF NOT l_flag THEN
           LET g_status.code = "apm-920"   #退料單自動取號失敗
           EXIT FOR
        END IF
       #FUN-9A0095 add end --------------------------------

        #------------------------------------------------------------------#
        # 設定入庫單頭預設值                                               #
        #------------------------------------------------------------------#
        CALL aws_create_set_sfp(l_sfp.*) RETURNING l_sfp.*
        IF NOT cl_null(g_errno) THEN
           LET g_status.code = g_errno
           EXIT FOR
        END IF

        #------------------------------------------------------------------#
        # RECORD資料傳到NODE                                               #
        #------------------------------------------------------------------#
        CALL aws_ttsrv_setRecordField_record(l_node1,base.Typeinfo.create(l_sfp))

        LET l_sql = aws_ttsrv_getRecordSql(l_node1, "sfp_file", "I", NULL)   #I 表示取得 INSERT SQL

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
        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "sfs_file")       #取得目前單頭共有幾筆單身資料
        IF l_cnt2 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           EXIT FOR
        END IF

        CALL cl_flow_notify(l_sfp.sfp01,'I')  #新增資料到 p_flow
        
        FOR l_j = 1 TO l_cnt2
            INITIALIZE l_sfs.* TO NULL
            LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "sfs_file")   #目前單身的 XML 節點

            #------------------------------------------------------------------#
            # NODE資料傳到RECORD                                               #
            #------------------------------------------------------------------#
            LET l_sfs.sfs01 = l_sfp.sfp01
            LET l_sfs.sfs02 = l_j
            LET l_sfs.sfs03 = aws_ttsrv_getRecordField(l_node2, "sfs03")
            LET l_sfs.sfs04 = aws_ttsrv_getRecordField(l_node2, "sfs04")
            LET l_sfs.sfs05 = aws_ttsrv_getRecordField(l_node2, "sfs05")
            LET l_sfs.sfs06 = aws_ttsrv_getRecordField(l_node2, "sfs06")
            LET l_sfs.sfs07 = aws_ttsrv_getRecordField(l_node2, "sfs07")
            LET l_sfs.sfs10 = aws_ttsrv_getRecordField(l_node2, "sfs10")        #FUN-9A0095 add
            LET l_sfs.sfs27 = aws_ttsrv_getRecordField(l_node2, "sfs27")        #FUN-A10022 add
            #------------------------------------------------------------------#
            # 設定欄位預設值                                                   #
            #------------------------------------------------------------------#
            CALL aws_create_set_sfs_def(l_sfp.*,l_sfs.*) 
                 RETURNING l_sfs.*

            #------------------------------------------------------------------#
            # RECORD資料傳到NODE2                                              #
            #------------------------------------------------------------------#
            CALL aws_ttsrv_setRecordField_record(l_node2,base.Typeinfo.create(l_sfs))

            IF cl_null(l_sfs.sfs07) THEN 
               LET l_sfs.sfs07=" "
               CALL aws_ttsrv_setRecordField(l_node2, "sfs07", " ")
            END IF

            IF cl_null(l_sfs.sfs08) THEN 
               LET l_sfs.sfs08=" "
               CALL aws_ttsrv_setRecordField(l_node2, "sfs08", " ")
            END IF

            IF cl_null(l_sfs.sfs09) THEN 
               LET l_sfs.sfs09=" "
               CALL aws_ttsrv_setRecordField(l_node2, "sfs09", " ")
            END IF

           #FUN-9C0057 add str -----
            IF cl_null(l_sfs.sfs10) THEN
              LET l_sfs.sfs10=" "
              CALL aws_ttsrv_setRecordField(l_node2, "sfs10", " ")
            END IF
           #FUN-9C0057 add end -----

           #FUN-A10022  add str -----
            IF cl_null(l_sfs.sfs012) THEN
               LET l_sfs.sfs012=" "
               CALL aws_ttsrv_setRecordField(l_node2, "sfs012", " ")
            END IF
           #FUN-A10022  add end -----

            LET l_sql = aws_ttsrv_getRecordSql(l_node2, "sfs_file", "I", NULL) #I 表示取得 INSERT SQL
            
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
       LET l_return.sfp01 = l_sfp.sfp01
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF

   #IF (l_status='Y') AND (g_status.code = "0") THEN                           #FUN-B50136 mark
    IF (l_status='Y') AND (g_status.code = "0") AND (l_sfp.sfpmksg<>'Y') THEN  #FUN-B50136 add
       LET l_prog = 'asfi528'
      #LET l_cmd=l_prog," '",l_sfp.sfp01 CLIPPED,"' 'stock_post'"       #FUN-A10022 mark
       LET l_cmd=l_prog," '",l_sfp.sfp01 CLIPPED,"' 'stock_post' 'Y'"   #FUN-A10022 add
       CALL cl_cmdrun_wait(l_cmd)
       CALL aws_ttsrv_cmdrun_checkStatus(l_prog)

      #FUN-9A0095 add begin ------------------
       IF g_status.code != "0" THEN
         BEGIN WORK      
       
         DELETE FROM sfp_file WHERE sfp01 = l_sfp.sfp01
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("del","sfp_file",l_sfp.sfp01,"",SQLCA.SQLCODE,"","",1)
         END IF 
        
         DELETE FROM sfs_file WHERE sfs01 = l_sfp.sfp01
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("del","sfs_file",l_sfp.sfp01,"",SQLCA.SQLCODE,"","",1)
       #FUN-B70074 --------------------Begin--------------------
         ELSE
            IF NOT s_industry('std') THEN
               LET l_flag1 = s_del_sfsi(l_sfp.sfp01,'','')
            END IF    
       #FUN-B70074 --------------------End-----------------------  
         END IF
        
         COMMIT WORK
        
         LET g_status.code = 'aws-521'      #TIPTOP執行失敗,回覆MES失敗(含原因)
       END IF
      #FUN-9A0095 add end --------------------
    END IF
    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳自動取號結果
END FUNCTION

#[
# Description....: 退料單設定欄位預設值
# Date & Author..: 
# Parameter......: l_sfp - 入庫單單頭
# Return.........: l_sfp - 入庫單單頭
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_set_sfp(l_sfp)
    DEFINE l_sfp RECORD LIKE sfp_file.*

    LET g_errno=NULL
    #--------------------------------------------------------------------------#
    # 設定退料單單頭欄位預設值                                                 #
    #--------------------------------------------------------------------------#
    LET l_sfp.sfp04  = 'N'
    LET l_sfp.sfp05  = 'N'
    LET l_sfp.sfp06  = '8'
    LET l_sfp.sfp07  = g_grup          #部門  #FUN-A10022 add
    LET l_sfp.sfp09  = 'N'
    LET l_sfp.sfpconf= 'N'
   #FUN-B50136 add str ---------
    LET l_sfp.sfp15  = '0'             #已開立
    LET l_sfp.sfp16  = g_user          #申請人
    LET l_sfp.sfpmksg = g_smy.smyapr   #是否簽核
   #FUN-B50136 add end ---------
    LET l_sfp.sfpplant= g_plant
    LET l_sfp.sfplegal= g_legal

    RETURN l_sfp.*
END FUNCTION

FUNCTION aws_create_set_sfs_def(l_sfp,l_sfs)
  DEFINE l_sfp    RECORD LIKE sfp_file.*
  DEFINE l_sfs    RECORD LIKE sfs_file.*
  DEFINE l_sfa27  LIKE sfa_file.sfa27  #FUN-A10022 add 
  DEFINE l_sfa28  LIKE sfa_file.sfa28  #FUN-A10022 add

   #---------------------------------#
   # 設定退料單單身欄位預設值        #
   #---------------------------------#
   IF cl_null(l_sfs.sfs05) THEN 
      LET l_sfs.sfs05=" "
   END IF
   IF cl_null(l_sfs.sfs06) THEN 
      LET l_sfs.sfs06=" "
   END IF
   IF cl_null(l_sfs.sfs07) THEN 
      LET l_sfs.sfs07=" "
   END IF

   #FUN-A10022 add str -------------
   SELECT sfa27,sfa28 INTO l_sfa27,l_sfa28   #被替代料號、替代率
     FROM sfa_file
    WHERE sfa01 = l_sfs.sfs03  #工單編號
      AND sfa03 = l_sfs.sfs04  #發料料號

   IF cl_null(l_sfs.sfs27) THEN
     LET l_sfs.sfs27 = l_sfa27
   END IF

   LET l_sfs.sfs28 = l_sfa28 
   LET l_sfs.sfs012= ' '      #製程段
   LET l_sfs.sfs013= '0'      #製程序   
   #FUN-A10022 add end -------------

   LET l_sfs.sfsplant= g_plant
   LET l_sfs.sfslegal= g_legal

   RETURN l_sfs.*
END FUNCTION

