# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_ttsrv2_global.4gl
# Descriptions...: TIPTOP Services 服務全域變數檔
# Date & Author..: 2007/02/06 by Brendan
# Memo...........:
# Modify.........: 新建立 FUN-840004
# Modify.........: No.FUN-880012 08/09/05 By kevin 可以不用指定營運中心
# Modify.........: No.FUN-8A0122 08/12/01 By David Fluid Lee 整合TIPTOP通用集成接口
# Modify.........: No:FUN-A60057 10/06/18 By Jay 增加GetReport Condition條件參數傳遞
# Modify.........: No:FUN-B10003 11/01/04 By Jay 增加讀取XML裡source標籤的資料傳遞
#}
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-D10092 13/01/23 By Lilan 增加儲存單號的全域變數(DigiWinPLM)
 
DATABASE ds
 
#FUN-840004
GLOBALS
 
    #--------------------------------------------------------------------------#
    # Service Request String(XML)                                              #
    #--------------------------------------------------------------------------#
    DEFINE g_request RECORD
              request        STRING       #呼叫 TIPTOP 服務時傳入的 XML
           END RECORD
    DEFINE g_request_root    om.DomNode   #Request XML Dom Node
 
 
    #--------------------------------------------------------------------------#
    # Service Response String(XML)                                             #
    #--------------------------------------------------------------------------#
    DEFINE g_response RECORD
              response       STRING       #TIPTOP 服務處理後回傳的 XML
           END RECORD
    DEFINE g_response_root   om.DomNode   #Response XML Dom Node
 
    #No.FUN-8A0122 Begin->
    #--------------------------------------------------------------------------#
    #TIPTOP通用集成接口公共參數
    #--------------------------------------------------------------------------#
    DEFINE g_ObjectID    LIKE waa_file.waa01        #企業對象ID                                
    DEFINE g_IgnoreError STRING                     #是否忽略錯誤標記                                
    DEFINE g_Separator   STRING                     #分隔符                                
    DEFINE g_Factory     STRING                     #工廠別                                
    DEFINE g_DateFormat  STRING                     #日期型數據格式                                
 
    #--------------------------------------------------------------------------#
    #TIPTOP通用集成接口服務參數                                               
    #--------------------------------------------------------------------------#
    DEFINE 
      SParam    DYNAMIC ARRAY OF RECORD                                           
    	Tag       STRING,                                                           
    	Attribute STRING,                                                           
    	Value     STRING                                                            
      END RECORD
 
    #--------------------------------------------------------------------------#
    #TIPTOP通用集成接口公共數據集
    #--------------------------------------------------------------------------#
    DEFINE                                                                          
      pub_data        DYNAMIC ARRAY OF RECORD                                       
        tables        STRING,                                                       
        fields        STRING,                                                       
        data          STRING,                                                       
        body            DYNAMIC ARRAY OF RECORD                                     
          tables        STRING,                                                     
          fields        STRING,                                                     
          data          STRING,                      
          detail           DYNAMIC ARRAY OF RECORD                                  
            tables         STRING,                                                  
            fields         STRING,                                                  
            data           STRING,                 
            subdetail        DYNAMIC ARRAY OF RECORD                                
              tables           STRING,                                              
              fields           STRING,                                              
              data             STRING                                               
            END RECORD                                                              
          END RECORD                                                                
        END RECORD                                                                  
      END RECORD            
    #No.FUN-8A0122 <-End
 
    #--------------------------------------------------------------------------#
    # 執行狀態                                                                 #
    #--------------------------------------------------------------------------#
    
    DEFINE g_status RECORD
              code           STRING,      #訊息代碼
              sqlcode        STRING,      #SQL ERROR CODE
              description    STRING       #訊息說明
           END RECORD 
   
    
    #--------------------------------------------------------------------------#
    # 存取資訊                                                                 #
    #--------------------------------------------------------------------------#
    DEFINE g_access RECORD
              user           STRING,      #使用者帳號
              password       STRING,      #使用者密碼
              application    STRING,      #呼叫端系統名稱代號(CRM / GPM / PDM / ...)
              source         STRING       #呼叫端來源 IP or Host   #FUN-B10003
           END RECORD
 
 
    #--------------------------------------------------------------------------#
    # 服務名稱(ERP 服務程式必須指定)                                           #
    #--------------------------------------------------------------------------#
    DEFINE g_service   STRING             #TIPTOP 服務名稱
 
    #--------------------------------------------------------------------------#
    # 抓取呼叫 cl_err() 的錯誤代碼及訊息                                       #
    #--------------------------------------------------------------------------#
    DEFINE gi_err_code           STRING
    DEFINE gi_err_msg            STRING
    DEFINE mi_tpgateway_status   LIKE type_file.num10,   
           mi_tpgateway_trigger  LIKE type_file.num10
 
    #--------------------------------------------------------------------------#
    # 記錄處理時發生錯誤的筆數及原因                                           #
    #--------------------------------------------------------------------------#
    DEFINE g_err_array DYNAMIC ARRAY OF RECORD
              record_id    STRING,      #Record ID
              code         STRING       #訊息代碼
           END RECORD
 
    #--------------------------------------------------------------------------#
    # 可以不用指定營運中心                                                     #
    #--------------------------------------------------------------------------#
    DEFINE g_non_plant STRING #FUN-880012

    #--------------------------------------------------------------------------#
    # 取得的報表資料時, 可傳入限制條件, 表示給於一 SQL 執行的 Where condition
    #--------------------------------------------------------------------------#
    DEFINE g_condition STRING    #FUN-A60057


    #--------------------------------------------------------------------------#
    # 資料庫是否已有交易(BEGIN WORK)
    #--------------------------------------------------------------------------#
    DEFINE g_transaction   LIKE type_file.chr1
    DEFINE g_return_keyno  STRING               #FUN-D10092
    DEFINE g_barcode_n    RECORD 
          imd01   LIKE imd_file.imd01,     #仓库编号
          imd02   LIKE imd_file.imd02,     #仓库名称
          ime02   LIKE ime_file.ime02,     #储位编号
          ime03   LIKE ime_file.ime03,     #储位ing成
          ima01   LIKE ima_file.ima01,     #料号
          ima02   LIKE ima_file.ima02,     #品名
          ima021  LIKE ima_file.ima021,    #规格
          ima25   LIKE ima_file.ima25,     #单位
          pihao  LIKE imgb_file.imgb04,   #批号
          err_det LIKE type_file.chr1000,  #错误信息
          stat    LIKE type_file.chr1      #1.仓库；2.物料
     END RECORD 
 
END GLOBALS
