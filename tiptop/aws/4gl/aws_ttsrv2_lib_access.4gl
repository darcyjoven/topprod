# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_ttsrv2_lib_access.4gl
# Descriptions...: 處理 TIPTOP 服務登入訊息的共用 FUNCTION
# Date & Author..: 2007/02/06 by Brendan
# Memo...........:
# Modify.........: 新建立 FUN-840004
# Modify.........: No.FUN-880012 08/09/05 By kevin 可以不用指定營運中心
# Modify.........: No.FUN-930132 09/06/29 By Vicky 增加抓取使用者權限類別
# Modify.........: No.FUN-980014 09/08/04 By rainy GP5.2 新增抓取 g_legal 值
# Modify.........: No.FUN-980025 09/09/27 By dxfwo 資料庫切換
# Modify.........: No.FUN-A90002 10/09/01 By Jay 新增抓取g_legal值
# Modify.........: No:FUN-B10003 11/01/04 By Jay 增加讀取XML裡source標籤的資料傳遞
# Modify.........: No:FUN-B20032 11/02/15 By Jay 增加抓取今天日期值(g_today)
#}
 
DATABASE ds
 
#FUN-840004
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
 
#[
# Description....: 檢查 Request 存取資訊
# Date & Author..: 2007/02/06 by Brendan
# Parameter......: none
# Return.........: TRUE / FALSE
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_checkAccess()
    DEFINE l_list       om.NodeList,
           l_node       om.DomNode
    DEFINE l_lang       STRING
 
    
    WHENEVER ERROR CONTINUE
    
    LET g_today = TODAY      #FUN-B20032 
    #--------------------------------------------------------------------------#
    # 讀取 <Authentication> 節點內存取內容                                     #
    # *** 現階段暫時不控管使用者權限 ***                                       #
    #--------------------------------------------------------------------------#
    LET l_list = g_request_root.selectByPath("//Access/Authentication")
    IF l_list.getLength() = 0 THEN           #若沒有指定使用者身份則視為錯誤
       DISPLAY "No user specified!"
       RETURN FALSE
    END IF
    LET l_node = l_list.item(1)
    LET g_access.user = l_node.getAttribute("user")
 
    #FUN-880012 --start
    IF NOT cl_null(g_access.user) THEN
       LET g_user = g_access.user
       SELECT zx03 INTO g_grup FROM zx_file WHERE zx01=g_user
       SELECT zx04 INTO g_clas FROM zx_file WHERE zx01=g_user   #FUN-930132
    END IF
    #FUN-880012 --end
    LET g_access.password = l_node.getAttribute("password")    
 
    #--------------------------------------------------------------------------#
    # 讀取 <Connection> 節點內存取內容                                         #
    #--------------------------------------------------------------------------#
    LET l_list = g_request_root.selectByPath("//Access/Connection")
    IF l_list.getLength() != 0 THEN          #若有提供 <Connection> 節點時就抓取
       LET l_node = l_list.item(1)
       LET g_access.application = l_node.getAttribute("application")
       LET g_access.source = l_node.getAttribute("source")           #FUN-B10003
    END IF
    IF cl_null(g_access.application) THEN    #若沒有指定來源的系統別, 預設為標準 "*"
       LET g_access.application = "*"
    END IF
 
    #--------------------------------------------------------------------------#
    # 讀取 <Organization> 節點內存取內容                                       #
    #--------------------------------------------------------------------------#
    LET l_list = g_request_root.selectByPath("//Access/Organization") 
    IF l_list.getLength() = 0 THEN           #若沒有指定存取的 ERP 資料庫則視為錯誤
       DISPLAY "No ERP organization specified!"
       RETURN FALSE
    END IF
    LET l_node = l_list.item(1)
    LET g_plant = l_node.getAttribute("name")
    IF NOT aws_ttsrv_changeDatabase() THEN   #依照 Reqeust 需求切換資料庫
       RETURN FALSE
    END IF
 
    #--------------------------------------------------------------------------#
    # 讀取 <Locale> 節點內存取內容                                             #
    #--------------------------------------------------------------------------#
    LET l_list = g_request_root.selectByPath("//Access/Locale")
    IF l_list.getLength() != 0 THEN          #若有提供 <Locale> 節點時就抓取
       LET l_node = l_list.item(1)
       LET l_lang = l_node.getAttribute("language")
    END IF
    CALL aws_ttsrv_setLanguage(l_lang)       #指定 ERP 語言別
 
    RETURN TRUE
END FUNCTION
 
 
#[
# Description....: 依據 Request XML 指定的語言別 mapping 成 ERP 的語言別代碼
# Date & Author..: 2007/02/06 by Brendan
# Parameter......: none
# Return.........: TRUE / FALSE
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_setLanguage(p_lang)
    DEFINE p_lang   STRING
    
    
    LET p_lang = p_lang.toUpperCase()
    CASE p_lang
         WHEN "ZH_TW"   LET g_lang = "0"
         WHEN "EN_US"   LET g_lang = "1"
         WHEN "ZH_CN"   LET g_lang = "2"
         
         #---------------------------------------------------------------------#         
         # 有新語系需要對應時請擴充                                            #
         # 語系可參考 UNIX 'locale -a' 指令結果, e.x. 'zh_tw.big5' 則取 zh_tw  #
         #---------------------------------------------------------------------#         
         
         OTHERWISE      LET g_lang = "1"   #當沒有任何對應時預設為英文
    END CASE
END FUNCTION
 
 
#[
# Description....: 切換指定的營運中心(資料庫)
# Date & Author..: 2007/02/06 by Brendan
# Parameter......: none
# Return.........: TRUE / FALSE
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_changeDatabase()
 
    #FUN-880012 --start
    IF cl_null(g_plant) THEN
    	 IF g_non_plant = "Y" THEN
    	 	  LET g_dbs = 'ds'
          SELECT azp01 INTO g_plant FROM azp_file WHERE azp03=g_dbs
          #SELECT azw02 INTO g_legal FROM azw_file WHERE azw01=g_plant    #FUN-980014 add(抓出該營運中心所屬法人)   #FUN-A90002 mark
    	 ELSE
    	 	  DISPLAY "No ERP organization specified!"
          RETURN FALSE
       END IF       
    END IF
    #FUN-880012 --end
    SELECT azw02 INTO g_legal FROM azw_file WHERE azw01=g_plant     #FUN-A90002    
    SELECT azp03 INTO g_dbs FROM azp_file WHERE azp01 = g_plant
    IF SQLCA.SQLCODE THEN
       DISPLAY "No such ERP organization exist!"
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN FALSE
    END IF
    
    CALL cl_ins_del_sid(2,'') #FUN-980025
    CLOSE DATABASE
 
    DATABASE g_dbs
    CALL cl_ins_del_sid(1,g_plant) #FUN-980025
    IF SQLCA.SQLCODE THEN
       DISPLAY "Switch ERP organization fail!"
       LET g_status.sqlcode = SQLCA.SQLCODE
 
       CALL cl_ins_del_sid(2,'') #FUN-980025
       CLOSE DATABASE
       DATABASE ds
       CALL cl_ins_del_sid(1,'') #FUN-980025
 
       RETURN FALSE
    END IF
    
    RETURN TRUE
END FUNCTION
