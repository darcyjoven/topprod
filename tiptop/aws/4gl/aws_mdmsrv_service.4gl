# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_mdmsrv_service.4gl
# Descriptions...: 處理各種 TIPTOP 服務
# Date & Author..: 08/06/05 By Echo FUN-850147
# Memo...........:
# Modify.........: NO.FUN-860036 08/06/11 By kim 加入MDM的相關服務
# Modify.........: NO.FUN-890113 08/10/03 By kevin  多筆傳送
#
#}
IMPORT com
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#FUN-850147
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"
GLOBALS "../4gl/aws_mdmsrv_global.4gl"
DEFINE l_record_cnt       LIKE type_file.num10 #FUN-890113
DEFINE l_i                LIKE type_file.num10 #FUN-890113
 
FUNCTION aws_mdmsrv_service()
DEFINE  l_mddTableName  STRING
DEFINE  l_action        STRING
 
   display "loginUser:",syncMasterData_in.in0.loginUser
 
   #定義抓取他系統欄位的 cursor
   CALL aws_mdmsrv_lib_wss_cs("DSCMDM")
 
   #判斷 Action 是否為新增(insert)、修改(update)、刪除(delete)
   LET l_action = syncMasterData_in.in0.action.toLowerCase()
   IF NOT (l_action = 'insert' OR l_action = 'update' OR l_action = 'delete' OR l_action = 'multi') THEN
      LET g_status.code = "403" 
      LET g_status.description = cl_getmsg(g_status.code, '0')
      RETURN
   END IF
 
   LET l_mddTableName = syncMasterData_in.in0.mddTableName.toLowerCase()
   CASE l_mddTableName 
      WHEN "customer"      #客戶主檔
           CALL aws_mdmsrv_customer()
      WHEN "bom_head"           # BOM 單頭  
           CALL aws_mdmsrv_bom_master()     
      WHEN "bom_body"           # BOM 單身      	  
           CALL aws_mdmsrv_bom_detail()           
      WHEN "item_master"    #料件主檔      #FUN-860036
           CALL aws_mdmsrv_itemmaster()   #FUN-860036
      WHEN "supplier"        #廠商主檔      #FUN-860036
           CALL aws_mdmsrv_vendor()       #FUN-860036
      WHEN "employee"      #員工主檔      #FUN-860036
           CALL aws_mdmsrv_employee()     #FUN-860036
      WHEN "customer_site"       #客戶其他地址  #FUN-860036
           CALL aws_mdmsrv_address()      #FUN-860036
      #FUN-890113 start
      WHEN "user"          #使用者主檔  
           CALL aws_mdmsrv_user()
      WHEN "department"    #部門主檔
           CALL aws_mdmsrv_department()      
      #FUN-890113 end
OTHERWISE
   END CASE
END FUNCTION
 
 
#FUN-890113 start
#提供處理使用者主檔資料
FUNCTION aws_mdmsrv_user()
DEFINE  l_action        STRING
   LET g_service = "CreateUserData"       #指定此次呼叫的 function
   
   #--------------------------------------------------------------------------#
   # 將傳入參數轉換成 TIPTOP Services Gateway 2.0 參數格式                    #
   #--------------------------------------------------------------------------#
    CALL aws_mdmsrv_trans_ttsrv('zx_file','','','','')
    #---------------------------------------------------------------------------#
   # 進行資料處理，action: insert(新增)、update(修改)、delete(刪除)            #
   #---------------------------------------------------------------------------#
   
   
   LET l_record_cnt = syncMasterData_in.in0.records.Record.getLength()
   FOR l_i = 1 TO l_record_cnt
       LET l_action = syncMasterData_in.in0.records.Record[l_i].action.toLowerCase() 
       
       CASE
         WHEN l_action = 'insert' OR l_action = 'update'
            #----------------------------------------------------------------------#
            # 建立使用基本資料 (與 TIPTOP Service GateWay 2.0 版本共用程式)        #
            #----------------------------------------------------------------------#
             CALL aws_create_user_data()
       
       END CASE 
   END FOR
   
END FUNCTION
 
FUNCTION aws_mdmsrv_department()
DEFINE  l_action        STRING
   LET g_service = "CreateDepartmentData"       #指定此次呼叫的 function
   
   #--------------------------------------------------------------------------#
   # 將傳入參數轉換成 TIPTOP Services Gateway 2.0 參數格式                    #
   #--------------------------------------------------------------------------#
    CALL aws_mdmsrv_trans_ttsrv('gem_file','','','','')
    #---------------------------------------------------------------------------#
   # 進行資料處理，action: insert(新增)、update(修改)、delete(刪除)            #
   #---------------------------------------------------------------------------#
   
   
   LET l_record_cnt = syncMasterData_in.in0.records.Record.getLength()
   FOR l_i = 1 TO l_record_cnt
       LET l_action = syncMasterData_in.in0.records.Record[l_i].action.toLowerCase() 
       
       CASE
         WHEN l_action = 'insert' OR l_action = 'update'
            #----------------------------------------------------------------------#
            # 建立部門基本資料 (與 TIPTOP Service GateWay 2.0 版本共用程式)        #
            #----------------------------------------------------------------------#
             CALL aws_create_department_data()
       
       END CASE
   END FOR
   
END FUNCTION
#FUN-890113 end
 
#提供處理客戶主檔資料
FUNCTION aws_mdmsrv_customer()
DEFINE  l_action        STRING
 
   LET g_service = "CreateCustomerData"       #指定此次呼叫的 function
 
   #--------------------------------------------------------------------------#
   # 將傳入參數轉換成 TIPTOP Services Gateway 2.0 參數格式                    #
   #--------------------------------------------------------------------------#
    CALL aws_mdmsrv_trans_ttsrv('occ_file','','','','')
 
   #---------------------------------------------------------------------------#
   # 進行資料處理，action: insert(新增)、update(修改)、delete(刪除)            #
   #---------------------------------------------------------------------------#
   #FUN-890113 start
   #LET l_action = syncMasterData_in.in0.action.toLowerCase()   
   LET l_record_cnt = syncMasterData_in.in0.records.Record.getLength()
   FOR l_i = 1 TO l_record_cnt
       LET l_action = syncMasterData_in.in0.records.Record[l_i].action.toLowerCase() 
       
       CASE
         WHEN l_action = 'insert' OR l_action = 'update'
            #----------------------------------------------------------------------#
            # 建立客戶基本資料 (與 TIPTOP Service GateWay 2.0 版本共用程式)        #
            #----------------------------------------------------------------------#
             CALL aws_create_customer_data()
       
             IF g_status.code = "0" THEN
                CALL aws_mdmsrv_wsw("occ_file","occ01",0)
             END IF
       
         #WHEN l_action = "delete" 
         #    CALL aws_mdmsrv_delete("occ_file","occ01","","","","")
       
       END CASE 
   END FOR
   #FUN-890113 end
 
END FUNCTION
 
#提供處理 BOM 主檔資料
FUNCTION aws_mdmsrv_bom_master()
DEFINE  l_action        STRING
DEFINE  l_bma06         STRING
DEFINE  l_bmb29         STRING
 
   LET g_service = "CreateBOMMasterData"       #指定此次呼叫的 function
 
   #--------------------------------------------------------------------------#
   # 將傳入參數轉換成 TIPTOP Services Gateway 2.0 參數格式                    #
   #--------------------------------------------------------------------------#
    CALL aws_mdmsrv_trans_ttsrv('bma_file','bmb_file','','','')
 
   #---------------------------------------------------------------------------#
   # 進行資料處理，action: insert(新增)、update(修改)、delete(刪除)            #
   #---------------------------------------------------------------------------#
   #FUN-890113 start
   #LET l_action = syncMasterData_in.in0.action.toLowerCase()   
   LET l_record_cnt = syncMasterData_in.in0.records.Record.getLength()
   FOR l_i = 1 TO l_record_cnt
       LET l_action = syncMasterData_in.in0.records.Record[l_i].action.toLowerCase()
        
       CASE
         WHEN l_action = 'insert' OR l_action = 'update'
            #----------------------------------------------------------------------#
            # 建立 BOM 基本資料 (與 TIPTOP Service GateWay 2.0 版本共用程式)       #
            #----------------------------------------------------------------------#
             CALL aws_create_bom_master()
       
         #WHEN l_action = "delete" 
         #
         #    #取得欄位的 WHERE 條件式
         #    LET l_bma06 = aws_mdmsrv_wss("1","bma06")
         #    IF l_bma06 = 'bma06' THEN
         #       LET l_bma06 = "bma06 = ' '"
         #    END IF
         #    LET l_bmb29 = aws_mdmsrv_wss("1","bmb29")
         #    IF l_bmb29 = 'bmb29' THEN
         #       LET l_bmb29 = "bmb29 = ' '"
         #    END IF
         #    CALL aws_mdmsrv_delete("bma_file","bma01",l_bma06,"","","")
         #    CALL aws_mdmsrv_delete("bmb_file","bmb01",l_bmb29,"","","")
         #
       END CASE 
   END FOR
   #FUN-890113 end
END FUNCTION
 
#提供處理 BOM 主檔資料
FUNCTION aws_mdmsrv_bom_detail()
DEFINE  l_action        STRING
DEFINE  l_bma06         STRING
DEFINE  l_bmb29         STRING
 
   LET g_service = "CreateBOMDetailData"       #指定此次呼叫的 function
 
   #--------------------------------------------------------------------------#
   # 將傳入參數轉換成 TIPTOP Services Gateway 2.0 參數格式                    #
   #--------------------------------------------------------------------------#
    CALL aws_mdmsrv_trans_ttsrv('bmb_file','','','','')
 
   #---------------------------------------------------------------------------#
   # 進行資料處理，action: insert(新增)、update(修改)、delete(刪除)            #
   #---------------------------------------------------------------------------#
   #FUN-890113 start   
   LET l_record_cnt = syncMasterData_in.in0.records.Record.getLength()
   FOR l_i = 1 TO l_record_cnt
       LET l_action = syncMasterData_in.in0.records.Record[l_i].action.toLowerCase()
      display l_action        
       CASE
         WHEN l_action = 'insert' OR l_action = 'update'
            #----------------------------------------------------------------------#
            # 建立 BOM 基本資料 (與 TIPTOP Service GateWay 2.0 版本共用程式)       #
            #----------------------------------------------------------------------#
             CALL aws_create_bom_detail()       
       END CASE 
   END FOR
   #FUN-890113 end
END FUNCTION
 
#FUN-860036
#提供處理料件主檔資料
FUNCTION aws_mdmsrv_itemmaster()
DEFINE  l_action        STRING
 
   LET g_service = "CreateItemMasterData"       #指定此次呼叫的 function
 
   #--------------------------------------------------------------------------#
   # 將傳入參數轉換成 TIPTOP Services Gateway 2.0 參數格式                    #
   #--------------------------------------------------------------------------#
    CALL aws_mdmsrv_trans_ttsrv('ima_file','','','','')
 
   #---------------------------------------------------------------------------#
   # 進行資料處理，action: insert(新增)、update(修改)、delete(刪除)            #
   #---------------------------------------------------------------------------#
   #FUN-890113 start
   #LET l_action = syncMasterData_in.in0.action.toLowerCase()   
   LET l_record_cnt = syncMasterData_in.in0.records.Record.getLength()
   FOR l_i = 1 TO l_record_cnt
       LET l_action = syncMasterData_in.in0.records.Record[l_i].action.toLowerCase() 
       
       CASE
         WHEN l_action = 'insert' OR l_action = 'update'
            #----------------------------------------------------------------------#
            # 建立料件基本資料 (與 TIPTOP Service GateWay 2.0 版本共用程式)        #
            #----------------------------------------------------------------------#
             CALL aws_create_itemmaster_data()
       
         #WHEN l_action = "delete" 
         #    CALL aws_mdmsrv_delete("ima_file","ima01","","","","")
       
       END CASE 
   END FOR
   #FUN-890113 end
END FUNCTION
 
#FUN-860036
#提供處理廠商主檔資料
FUNCTION aws_mdmsrv_vendor()
DEFINE  l_action        STRING
 
   LET g_service = "CreateVendorData"       #指定此次呼叫的 function
 
   #--------------------------------------------------------------------------#
   # 將傳入參數轉換成 TIPTOP Services Gateway 2.0 參數格式                    #
   #--------------------------------------------------------------------------#
    CALL aws_mdmsrv_trans_ttsrv('pmc_file','','','','')
 
   #---------------------------------------------------------------------------#
   # 進行資料處理，action: insert(新增)、update(修改)、delete(刪除)            #
   #---------------------------------------------------------------------------#
   #FUN-890113 start
   #LET l_action = syncMasterData_in.in0.action.toLowerCase()   
   LET l_record_cnt = syncMasterData_in.in0.records.Record.getLength()
   FOR l_i = 1 TO l_record_cnt
       LET l_action = syncMasterData_in.in0.records.Record[l_i].action.toLowerCase() 
       
       CASE
         WHEN l_action = 'insert' OR l_action = 'update'
            #----------------------------------------------------------------------#
            # 建立廠商基本資料 (與 TIPTOP Service GateWay 2.0 版本共用程式)        #
            #----------------------------------------------------------------------#
             CALL aws_create_vendor_data()
       
         #WHEN l_action = "delete" 
         #    CALL aws_mdmsrv_delete("pmc_file","pmc01","","","","")
       
       END CASE 
   END FOR
   #FUN-890113 end
END FUNCTION
 
#FUN-860036
#提供處理員工主檔資料
FUNCTION aws_mdmsrv_employee()
DEFINE  l_action        STRING
 
   LET g_service = "CreateEmployeeData"       #指定此次呼叫的 function
 
   #--------------------------------------------------------------------------#
   # 將傳入參數轉換成 TIPTOP Services Gateway 2.0 參數格式                    #
   #--------------------------------------------------------------------------#
    CALL aws_mdmsrv_trans_ttsrv('gen_file','','','','')
 
   #---------------------------------------------------------------------------#
   # 進行資料處理，action: insert(新增)、update(修改)、delete(刪除)            #
   #---------------------------------------------------------------------------#
   #FUN-890113 start
   #LET l_action = syncMasterData_in.in0.action.toLowerCase()   
   LET l_record_cnt = syncMasterData_in.in0.records.Record.getLength()
   FOR l_i = 1 TO l_record_cnt
       LET l_action = syncMasterData_in.in0.records.Record[l_i].action.toLowerCase()  
   	
       CASE
         WHEN l_action = 'insert' OR l_action = 'update'
            #----------------------------------------------------------------------#
            # 建立員工基本資料 (與 TIPTOP Service GateWay 2.0 版本共用程式)        #
            #----------------------------------------------------------------------#
             CALL aws_create_employee_data()
       
         #WHEN l_action = "delete" 
         #    CALL aws_mdmsrv_delete("gen_file","gen01","","","","")
       
       END CASE 
   END FOR
   #FUN-890113 end
END FUNCTION
 
#FUN-860036
#提供處理客戶其他地址資料
FUNCTION aws_mdmsrv_address()
DEFINE  l_action        STRING
 
   LET g_service = "CreateAddressData"       #指定此次呼叫的 function
 
   #--------------------------------------------------------------------------#
   # 將傳入參數轉換成 TIPTOP Services Gateway 2.0 參數格式                    #
   #--------------------------------------------------------------------------#
    CALL aws_mdmsrv_trans_ttsrv('ocd_file','','','','')
 
   #---------------------------------------------------------------------------#
   # 進行資料處理，action: insert(新增)、update(修改)、delete(刪除)            #
   #---------------------------------------------------------------------------#
   #FUN-890113 start
   #LET l_action = syncMasterData_in.in0.action.toLowerCase()   
   LET l_record_cnt = syncMasterData_in.in0.records.Record.getLength()
   FOR l_i = 1 TO l_record_cnt
       LET l_action = syncMasterData_in.in0.records.Record[l_i].action.toLowerCase()   	
       CASE
         WHEN l_action = 'insert' OR l_action = 'update'
            #----------------------------------------------------------------------#
            # 建立客戶其他地址資料 (與 TIPTOP Service GateWay 2.0 版本共用程式)    #
            #----------------------------------------------------------------------#
             CALL aws_create_address_data()
       
         #WHEN l_action = "delete" 
         #    CALL aws_mdmsrv_delete("ocd_file","ocd01","ocd02","","","")
       END CASE 
   END FOR
   #FUN-890113 end
END FUNCTION
