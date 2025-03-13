# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: p_ldap_login.4gl
# Descriptions...: 讓使用者能透過LDAP認證登入TIPTOP
# Date & Author..: 11/12/13 Jay FUN-BC0080
# Modify.........: No:FUN-C60025 12/06/22 By kevin 取消密碼規則

#import Java class 
#export CLASSPATH=$TOP/ds4gl2/bin/javaad/jar/ldap.jar
IMPORT JAVA java.lang.String
IMPORT JAVA java.lang.StringBuffer
IMPORT JAVA java.security.NoSuchAlgorithmException
IMPORT JAVA java.security.Provider
IMPORT JAVA java.security.Security
IMPORT JAVA javax.net.ssl.SSLContext

IMPORT JAVA com.novell.ldap.LDAPConnection
IMPORT JAVA com.novell.ldap.LDAPEntry
IMPORT JAVA com.novell.ldap.LDAPException
IMPORT JAVA com.novell.ldap.LDAPJSSESecureSocketFactory
IMPORT JAVA com.novell.ldap.LDAPSearchResults
IMPORT JAVA com.novell.ldap.LDAPSocketFactory


DATABASE ds
#FUN-BC0080
GLOBALS "../../config/top.global"

MAIN
    DEFINE l_file_name   STRING                #預備回傳Response結果的檔名
    DEFINE l_ip          STRING
    DEFINE l_port        STRING
    DEFINE l_domain      STRING
    DEFINE l_file        STRING
    DEFINE l_admin_DN    STRING                #AD admin Domain Name
    DEFINE l_filter      STRING                #AD 使用者帳號識別名稱
    DEFINE l_admin_pwd   STRING                #AD 管理者密碼
    DEFINE l_ssl         LIKE type_file.chr1   #是否啟動SSL加/解密機制
    DEFINE l_cnt         LIKE type_file.num10
    DEFINE l_desc        STRING                #驗證後錯誤訊息
    DEFINE l_status      STRING                #騇證後狀態
    DEFINE l_cmd         STRING                #執行FUNCTION命令
    DEFINE l_zx01        LIKE zx_file.zx01     #使用者登入帳號
    DEFINE l_zx10        LIKE zx_file.zx10     #使用者登入密碼
    DEFINE l_admin       LIKE zx_file.zx01     #AD 管理者帳號  
    DEFINE l_pwd         LIKE zx_file.zx10     #AD 管理者密碼
    
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵

    WHENEVER ERROR CALL cl_err_msg_log

    LET l_status = ""
    LET l_desc = ""
    LET l_zx01 = ARG_VAL(1)
    LET l_zx10 = ARG_VAL(2)
    LET l_file_name = ARG_VAL(3)
    
    #檢查準備寫入之response檔案是否存在
    IF cl_null(l_file_name) THEN
       DISPLAY "No response xml file isn't passed on p_ldap_login run time."
       RETURN
    END IF

    LET g_prog = "p_ldap_login" #FUN-C60025
    #抓取環境變數設定之AD資訊
    LET l_ip = FGL_GETENV("AD_ADDR")                 #為AD Serve IP + Port(預設是389)組成
    LET l_domain = FGL_GETENV("AD_DOMAIN")           #AD的Base DN (根網域名稱)
    LET l_admin_DN = FGL_GETENV("AD_ADMIN_ACCOUNT")  #AD管理者的DN
    LET l_filter = FGL_GETENV("AD_ACCOUNT_ATTR")     #搜尋使用者的 LDAP的屬性
    LET l_ssl = FGL_GETENV("AD_SSL_ENABLE")          #是否啟用SSL連線服務
    LET l_admin = FGL_GETENV("AD_ADMIN")             #預設要讀取AD管理者密碼的zx_file帳號名稱
    
    #抓取AD server port
    LET l_port = l_ip.subString(l_ip.getIndexOf(':', 1) + 1, l_ip.getLength())
    #抓取AD server IP
    LET l_ip = l_ip.subString(1, l_ip.getIndexOf(':', 1) - 1)
    
    #因為驗證時需要AD Server的管理者帳號/密碼,而管理者帳號由上面的"AD_ADMIN_ACCOUNT"來設定
    #管理者密碼則存在zx_file裡
    #而zx_file是那筆資料儲存這個密碼的則由"AD_ADMIN"設定zx01這個帳號名稱
    #所這裡是從zx_file取出AD Server的管理者密碼
    SELECT COUNT(*) INTO l_cnt FROM zx_file WHERE LOWER(zx01) = l_admin
    IF l_cnt = 0 THEN
       LET l_status = "12"
       LET l_desc = "AD server admin account does not exist zx_file!(zx01:AD admin)"
       LET l_cmd = "ldap_tree_login_check('", l_zx01, "', '*****', '", l_ip, "', '", l_port, "', '", l_domain, "', '", l_admin_DN, "', '", l_filter, "', '?????', '", l_ssl, "')"
    END IF

    #檢查是否有傳入要驗證之使用者帳號/密碼
    IF cl_null(l_zx01) OR cl_null(l_zx10) THEN
       LET l_status = "13"
       LET l_desc = "User account or password is not passed."
       IF cl_null(l_zx01) THEN
          LET l_zx01 = "?????"
       END IF
       IF cl_null(l_zx10) THEN
          LET l_zx10 = "?????"
       ELSE
          LET l_zx10 = "*****"
       END IF
       
       LET l_cmd = "ldap_tree_login_check('", l_zx01, "', '", l_zx10, "', '", l_ip, "', '", l_port, "', '", l_domain, "', '", l_admin_DN, "', '", l_filter, "', '*****', '", l_ssl, "')"
    END IF

    #將錯誤資訊寫入response file 
    IF NOT cl_null(l_status) THEN
       #將執行命令寫入request
       CALL ldap_writeLog(l_cmd)
       CALL ldap_writeResponseLog(l_file_name, l_status, l_desc)
    END IF
    
    SELECT zx10 INTO l_pwd FROM zx_file WHERE zx01 = l_admin

    LET l_pwd =  cl_ldap_id(l_pwd)          #FUN-C60025

    LET l_cmd = "ldap_tree_login_check('", l_zx01, "', '*****', '", l_ip, "', '", l_port, "', '", l_domain, "', '", l_admin_DN, "', '", l_filter, "', '*****', '", l_ssl, "')"

    #驗證使用者帳號/密碼
    CALL ldap_tree_login_check(l_zx01, l_zx10, l_ip, l_port, l_domain, l_admin_DN, l_filter, l_pwd, l_ssl)
       RETURNING l_status, l_desc

    #將驗證結果寫入response file  
    CALL ldap_writeResponseLog(l_file_name, l_status, l_desc)

    #驗證錯誤,紀錄此筆驗證log
    IF l_status <> "1" THEN
       CALL ldap_writeLog(l_cmd)
    END IF

END MAIN


#------------------------------------------------------------------
#將使用者輸入之帳號、密碼透過由AD SERVER驗證
#傳入參數:p_zx01(使用者AD帳號)
#傳入參數:p_zx10(使用者AD密碼)
#傳入參數:p_ip(AD Server IP)
#傳入參數:p_port(AD Server Port)
#傳入參數:p_base_DN(AD Server BASE DOMAIN NAME)
#傳入參數:p_admin_DN(AD 管理者的 Domain Name)
#傳入參數:p_filter(AD 使用者帳號識別名稱)
#傳入參數:p_pwd(AD 管理者密碼)
#傳入參數:p_ssl(是否啟動SSL加/解密機制)
#傳回結果:l_status:((1)0:失敗. (2)1:成功. (3)還有其他錯誤代碼)
#傳回結果:l_desc:(錯誤描述)
#------------------------------------------------------------------
PRIVATE FUNCTION ldap_tree_login_check(p_zx01, p_zx10, p_ip, p_port, p_base_DN, p_admin_DN, p_filter, p_pwd, p_ssl)
   TYPE   str_array_type     ARRAY [] OF java.lang.String
   DEFINE p_zx01             STRING                    #要驗證之使用者帳號
   DEFINE p_zx10             java.lang.String          #要驗證之使用者密碼
   DEFINE p_ip               STRING                    #AD Server IP位置
   DEFINE p_port             LIKE type_file.num5       #AD Server Port:Windows Windows AD預設是389
   DEFINE p_base_DN          STRING                    #AD Server BASE DOMAIN NAME: dc=xxxx,dc=xx
   DEFINE p_admin_DN         STRING                    #AD 管理者的 Domain Name: cn=xxxxxx,cn=xxxx,dc=xxxx,dc=xx(cn=xxxxxx為 AD帳號)
   DEFINE p_filter           STRING                    #AD 使用者帳號識別名稱
   DEFINE p_pwd              java.lang.String          #AD 管理者密碼
   DEFINE p_ssl              LIKE type_file.chr1       #是否啟動SSL加/解密機制
   DEFINE l_sb               java.lang.StringBuffer    #LDAP URL
   DEFINE l_err              STRING                    #錯誤代碼
   DEFINE l_result           STRING                    #AD 驗證結果,為xml格式
   DEFINE l_ver              LIKE type_file.num10      #LDAP 協定版本
   DEFINE l_status           STRING
   DEFINE l_desc             STRING
   DEFINE l_provider         java.security.Provider
   DEFINE l_SSLContext       javax.net.ssl.SSLContext
   DEFINE l_LDAPConnection   com.novell.ldap.LDAPConnection
   DEFINE l_socketFactory    com.novell.ldap.LDAPSocketFactory
   DEFINE l_ssf              com.novell.ldap.LDAPJSSESecureSocketFactory
   DEFINE l_target           com.novell.ldap.LDAPEntry
   DEFINE l_search_results   com.novell.ldap.LDAPSearchResults
   DEFINE l_retrieve_attr    str_array_type 
   DEFINE l_user             STRING                   #轉換後之使用帳號名稱
   DEFINE l_filter           STRING                   #用來尋找使用者的 LDAP 搜尋過濾器 
   DEFINE l_found            BOOLEAN                  #使用者帳號是否在LDAP中找到
   DEFINE l_verify_success   BOOLEAN                  #使用者帳號是否驗證成功
   
   LET l_status = "0"
   LET l_desc = ""

   IF cl_null(p_port) AND p_ssl = "Y" THEN
      LET p_port = 636   #AS Server如果有啟動SSL機制所預設的port
   END IF

   IF cl_null(p_port) THEN
      LET p_port = 389   #AD Server預設的port
   END IF
   
   #指定LDAP 協定版本
   LET l_ver = LDAPConnection.LDAP_V3

   #檢查是否有輸入LDAP管理者DN
   IF cl_null(p_admin_DN) THEN
      LET l_status = "5"
      LET l_desc = "DN is null of LDAP administrator."
   END IF

   #檢查是否有輸入baseDN名稱
   IF cl_null(p_base_DN) THEN
      LET l_status = "6"
      LET l_desc = "Base DN is null."
   END IF

   IF l_status <> "0" THEN
      RETURN l_status, l_desc
   END IF

   #當AD Server採SSL加/解密制時,LDAPConnection需先預設SSL制度   
   IF p_ssl = "Y" THEN
      TRY
         LET l_SSLContext = SSLContext.getInstance("ssl")
         LET l_provider = l_SSLContext.getProvider()

         IF l_provider IS NULL THEN
            LET l_status = "7"
            LET l_desc = "Can not get SSL provider.Provider is null."
         END IF
      CATCH
         #取得SSL provider失敗
         #讀取驗證錯誤代碼
         LET l_err = ERR_GET(STATUS)
         LET l_status = "7"
         LET l_desc = "Can not get SSL provider."
         LET l_desc = l_desc, ASCII 10, l_err
      END TRY
      
      IF l_status <> "0" THEN
         RETURN l_status, l_desc
      END IF

      #設置安全機制的提供者
      CALL Security.addProvider(l_provider)
      LET l_socketFactory = com.novell.ldap.LDAPJSSESecureSocketFactory.create()
      
      #預設SSL機制給LDAPConnection物件 
      LET l_LDAPConnection = LDAPConnection.create()
      CALL LDAPConnection.setSocketFactory(l_ssf)
   END IF
  
   #開啟一個LDAP的Connection,準備驗證帳號/密碼 
   LET l_LDAPConnection = LDAPConnection.create()

   TRY
      #嘗試連接LDAP Server是否可以成功
      CALL l_LDAPConnection.connect(p_ip, p_port)
   CATCH
      LET l_err = ERR_GET(STATUS)
      LET l_status = "3"
      LET l_desc = "Can not connect LDAP Server. Host = '", p_ip, "', Port ='", p_port,  "'" 
      LET l_desc = l_desc, ASCII 10, l_err
   END TRY

   IF l_status <> "0" THEN
      RETURN l_status, l_desc
   END IF
   
   TRY
      #利用AD管理者身份登入LDAP
      CALL l_LDAPConnection.bind(l_ver, p_admin_DN, p_pwd.getBytes("UTF8"))
   CATCH
      LET l_err = ERR_GET(STATUS)
      LET l_status = "8"
      LET l_desc = "Can not bind admin account on LDAP. admin DN:", p_admin_DN

      IF (NOT cl_null(l_err)) AND (l_err.getIndexOf("data", 1) > 0) THEN
         LET l_status = l_err.subString(l_err.getIndexOf("data", 1) + 5, l_err.getIndexOf("data", 1) + 7)
         IF l_status = "525" THEN
            LET l_status = "9"
            LET l_desc = "Administrator loginDN is error. admin DN:", p_admin_DN 
         END IF

         IF l_status = "52e" THEN
            LET l_status = "10"
            LET l_desc = "Password of loginDN encoding error. admin DN:", p_admin_DN 
         END IF
      END IF
      
      LET l_desc = l_desc, ASCII 10, l_err
   END TRY

   IF l_status <> "0" THEN
      RETURN l_status, l_desc
   END IF

   #檢查帳號是否有特殊字元
   LET l_user = ldap_escaped(p_zx01)

   LET l_sb = StringBuffer.create()
   CALL l_sb.append("(&")
   CALL l_sb.append("(");
   CALL l_sb.append(p_filter);
   CALL l_sb.append("=");
   CALL l_sb.append(l_user);
   CALL l_sb.append(")");
   CALL l_sb.append(")");
  
   LET l_filter = l_sb.toString()
 
   TRY
      #利用AD管理者身份登入LDAP
      #LET l_search_results = LDAPSearchResults.create() 
      #Names of attributes to retrieve. (無屬性)
      LET l_retrieve_attr = str_array_type.create(1)
      LET l_retrieve_attr[1] = LDAPConnection.NO_ATTRS

      #Synchronously performs the search specified by the parameters.指定要搜索的相關屬性
      LET l_search_results = l_LDAPConnection.search(p_base_DN , LDAPConnection.SCOPE_SUB, l_filter, l_retrieve_attr, TRUE)
   CATCH
      LET l_err = ERR_GET(STATUS)
      LET l_status = "11"
      LET l_desc = "LADP search is error... filter: ", l_filter
      LET l_desc = l_desc, ASCII 10, l_err
   END TRY
 
   IF l_status <> "0" THEN
      RETURN l_status, l_desc
   END IF

   LET l_found = FALSE
   LET l_verify_success = FALSE

   WHILE (l_search_results.hasMore() AND (NOT l_verify_success))
      LET l_found = TRUE
      LET l_target = LDAPEntry.create() 

      TRY
         #檢查使用者帳號是否存在
         LET l_target = l_search_results.next() 
      CATCH
         LET l_err = ERR_GET(STATUS)
         LET l_status = "525"           #LDAP user 帳號錯誤
         LET l_desc = "Cannot find target entry... user: ", l_user, " ; filter: ", l_filter
         LET l_desc = l_desc, ASCII 10, l_err
      END TRY
  
      IF l_status <> "0" THEN
         RETURN l_status, l_desc
      END IF

      TRY
         #檢查使用者密碼是否錯誤
         CALL l_LDAPConnection.bind(l_ver, l_target.getDN(), p_zx10.getBytes("UTF8"))
         LET l_verify_success = TRUE
      CATCH
         LET l_err = ERR_GET(STATUS)
         LET l_status = "52e"           #LDAP user 密碼錯誤
         LET l_desc = "Password of LDAPUid error. UserDN: ", l_target.getDN()
         LET l_desc = l_desc, ASCII 10, l_err
      END TRY
  
      IF l_status <> "0" THEN
         RETURN l_status, l_desc
      END IF
   END WHILE

   IF NOT l_found THEN
      LET l_status = "525"         #LDAP user 帳號錯誤
      LET l_desc = "Cannot find target entry... user: ", l_user, " ; filter: ", l_filter
      RETURN l_status, l_desc
   END IF

   IF NOT l_verify_success THEN
      LET l_status = "52e"         #LDAP user 密碼錯誤
      LET l_desc = "Password of LDAPUid error. user: ", l_user, " ; filter: ", l_filter
      RETURN l_status, l_desc
   END IF

   #執行到這裡沒有任何錯誤發生,代表已驗證成功
   LET l_status = "1"   
   LET l_desc = "";
   
   RETURN l_status, l_desc
END FUNCTION

#------------------------------------------------------------------
#將特殊字元轉換
#傳入參數:p_str(要被轉換的字串)
#傳回結果:l_result(轉換後的字串)
#------------------------------------------------------------------
FUNCTION ldap_escaped(p_str)
   DEFINE p_str           STRING                 #要被escaped的字串 
   DEFINE l_result        STRING                 #已經escaped後的字串
   DEFINE l_char          LIKE type_file.chr1
   DEFINE l_cnt           LIKE type_file.num5
   DEFINE l_i             LIKE type_file.num5

   LET l_cnt = p_str.getLength()
   LET l_result = ""
   
   FOR l_i = 1 TO l_cnt
       LET l_char = p_str.getCharAt(l_i)
       
       CASE l_char
       	  WHEN "\\"
       	  	 LET l_result = l_result, "\\\\"
       	  WHEN "?"
       	  	 LET l_result = l_result, "\\?"
       	  WHEN "*"
       	  	 LET l_result = l_result, "\\*"
       	  WHEN "+"
       	  	 LET l_result = l_result, "\\+"
       	  WHEN "&"
       	  	 LET l_result = l_result, "\\&"
       	  WHEN ":"
       	  	 LET l_result = l_result, "\\:"
       	  WHEN "{"
       	  	 LET l_result = l_result, "\\{"
       	  WHEN "}"
       	  	 LET l_result = l_result, "\\}"
       	  WHEN "["
       	  	 LET l_result = l_result, "\\["
       	  WHEN "]"
       	  	 LET l_result = l_result, "\\]"
       	  WHEN "("
       	  	 LET l_result = l_result, "\\("
       	  WHEN ")"
       	  	 LET l_result = l_result, "\\)"
       	  WHEN "^"
       	  	 LET l_result = l_result, "\\^"
       	  WHEN "$"
       	  	 LET l_result = l_result, "\\$"
          OTHERWISE
             LET l_result = l_result, l_char
       END CASE
   END FOR
   
   RETURN l_result
END FUNCTION

#[
# Description....: 寫入服務回傳參數 log 紀錄
# Date & Author..: 2012/12/16 by Jay
# Parameter......: p_cmd(呼叫FUNCTION的內容)
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION ldap_writeLog(p_cmd)
   DEFINE p_cmd      STRING
   DEFINE l_file     STRING
   DEFINE l_str      STRING
   DEFINE channel    base.Channel
   
   #記錄此次呼叫的 method name
   LET l_file = "weblogin_ad-", TODAY USING 'YYYYMMDD', ".log"

   LET channel = base.Channel.create()
   CALL channel.openFile(l_file,  "a")
   IF STATUS = 0 THEN
      CALL channel.setDelimiter("")
      LET l_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
      CALL channel.write(l_str)
      CALL channel.write("")
      LET l_str = "Method: Weblogin AD Certification."
      CALL channel.write(l_str)
      CALL channel.write("")
      LET l_str = "Request:", p_cmd      
      CALL channel.write(l_str)
      CALL channel.write("")
      CALL channel.close()

      LET p_cmd = "chmod 666 ", l_file CLIPPED, " >/dev/null 2>/dev/null"
      RUN p_cmd
   ELSE
      DISPLAY "Can't open log file on p_ldap_login."
   END IF
   
END FUNCTION

#[
# Description....: 寫入服務回傳參數 log 紀錄
# Date & Author..: 2012/12/16 by Jay
# Parameter......: p_cmd(呼叫FUNCTION的內容)
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION ldap_writeResponseLog(p_file_name, p_status, p_desc)
   DEFINE p_file_name    STRING
   DEFINE p_status       STRING
   DEFINE p_desc         STRING
   DEFINE l_xml          STRING
   DEFINE l_ch           base.Channel

   LET l_ch = base.Channel.create()
   CALL l_ch.openFile(p_file_name,  "w")
   IF STATUS = 0 THEN
      LET p_desc = cl_replace_str(p_desc, "\n", " ")
      LET l_xml = ASCII 10, '<response> ', ASCII 10
      LET l_xml = l_xml, '<status>', p_status.trim(), "</status>", ASCII 10 
      LET l_xml = l_xml, '<description>', p_desc.trim(), "</description>", ASCII 10
      LET l_xml = l_xml, '</response> ', ASCII 10
      LET l_xml = cl_replace_str(l_xml, '&', '&amp;')    

      CALL l_ch.setDelimiter("")
      CALL l_ch.write(l_xml)
      CALL l_ch.close()
   ELSE
      DISPLAY "Can't write response log on p_ldap_login."
   END IF
   
END FUNCTION
