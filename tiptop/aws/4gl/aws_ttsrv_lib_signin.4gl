# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_ttsrv_lib_signin.4gl
# Descriptions...: 處理 TIPTOP 服務登入訊息的共用 FUNCTION
# Date & Author..: 2007/02/06 by Brendan
# Memo...........:
# Modify.........: 新建立 FUN-720021
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
 
DATABASE ds
 
#FUN-720021
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
 
#[
# Description....: 檢查登入資訊並切換指定的資料庫
# Date & Author..: 2007/02/06 by Brendan
# Parameter......: p_signIn - STRING - 登入資訊
# Return.........: TRUE/FALSE
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_checkSignIn(p_signIn)
    DEFINE p_signIn     STRING
    DEFINE l_root       om.DomNode,
           l_list       om.NodeList,
           l_node       om.DomNode,
           l_azp01      LIKE azp_file.azp01,
           l_zx01       LIKE zx_file.zx01
    DEFINE l_status     LIKE type_file.num5
    
    WHENEVER ERROR CONTINUE
 
    LET l_status = TRUE
 
    IF cl_null(p_signIn) THEN
       LET l_status = FALSE
    END IF
   
    IF l_status THEN
       LET l_root = aws_ttsrv_stringToXml(p_signIn)
       IF l_root IS NULL THEN
          LET l_status = FALSE
       END IF
       
       IF l_status THEN
          #--------------------------------------------------------------------#
          # 讀取登入資訊內容                                                   #
          #--------------------------------------------------------------------#
          LET l_list = l_root.selectByTagName("Account")
          LET l_node = l_list.item(1)
          LET g_signIn.userId = l_node.getattribute("userId")
          LET g_signIn.password = l_node.getattribute("password")    
          LET l_list = l_root.selectByTagName("Connection")
          LET l_node = l_list.item(1)
          LET g_signIn.from = l_node.getattribute("from")
          LET g_signIn.organization = l_node.getattribute("organization")
          LET g_signIn.systemId = l_node.getattribute("systemId")
          
       END IF
    END IF
 
    #--------------------------------------------------------------------#
    # 未指定營運中心時, 預設帶以 'ds' 資料庫的營運中心                   #
    #--------------------------------------------------------------------#
    IF cl_null(g_signIn.organization) THEN
       SELECT azp01 INTO l_azp01 FROM azp_file WHERE azp03 = 'ds'
       LET g_signIn.organization = l_azp01 CLIPPED
    END IF    
    
    IF NOT aws_ttsrv_changeDatabase(g_signIn.organization) THEN
       LET l_status = FALSE
    END IF
    
    #--------------------------------------------------------------------------#
    # 依照登入者 userId 設定語言別(抓取錯誤訊息時使用)                         #
    #--------------------------------------------------------------------------#
    LET l_zx01 = g_signIn.userId
    IF cl_null(l_zx01) THEN
       LET l_zx01 = 'tiptop'
    END IF
    SELECT zx06 INTO g_lang FROM zx_file WHERE zx01 = l_zx01
    IF SQLCA.SQLCODE OR cl_null(g_lang) THEN   #若抓取不到使用者語言別, 則預設為英文
       LET g_lang = "1"
    END IF
    
    IF NOT l_status THEN   #登入檢查錯誤 OR 切換資料庫失敗
       RETURN FALSE
    END IF
 
    #---------------------------------------------------------------------------
    # 抓取對應資料庫 aza.* 資料, 單據編號格式設定
    #---------------------------------------------------------------------------
    SELECT * INTO g_aza.* FROM aza_file WHERE aza01='0'
    IF SQLCA.SQLCODE THEN
       RETURN FALSE
    END IF
    CASE g_aza.aza41
       WHEN "1"   LET g_doc_len = 3
                  LET g_no_sp = 3 + 2
       WHEN "2"   LET g_doc_len = 4
                  LET g_no_sp = 4 + 2
       WHEN "3"   LET g_doc_len = 5
                  LET g_no_sp = 5 + 2
    END CASE
    CASE g_aza.aza42
       WHEN "1"   LET g_no_ep = g_doc_len + 1 + 8
       WHEN "2"   LET g_no_ep = g_doc_len + 1 + 9
       WHEN "3"   LET g_no_ep = g_doc_len + 1 + 10
    END CASE
 
 
    RETURN TRUE
END FUNCTION
 
 
#[
# Description....: 切換指定的資料庫
# Date & Author..: 2007/02/06 by Brendan
# Parameter......: p_azp01 - STRING - 營運中心代碼
# Return.........: TRUE/FALSE
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_changeDatabase(p_azp01)
    DEFINE p_azp01   LIKE azp_file.azp01
    DEFINE l_azp03   LIKE azp_file.azp03
 
    
    IF cl_null(p_azp01) THEN
       RETURN FALSE
    END IF 
    
    SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = p_azp01
    IF SQLCA.SQLCODE THEN
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN FALSE
    END IF
    
 #   CALL cl_ins_del_sid(2) #FUN-980030  #FUN-990069
    CALL cl_ins_del_sid(2,'') #FUN-980030  #FUN-990069
    CLOSE DATABASE
 
    #切換資料庫
    DATABASE l_azp03
 #   CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
    CALL cl_ins_del_sid(1,p_azp01) #FUN-980030  #FUN-990069
    IF SQLCA.SQLCODE THEN
       LET g_status.sqlcode = SQLCA.SQLCODE
 
#       CALL cl_ins_del_sid(2) #FUN-980030  #FUN-990069
       CALL cl_ins_del_sid(2,'') #FUN-980030  #FUN-990069
       CLOSE DATABASE
       DATABASE ds
#       CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
       CALL cl_ins_del_sid(1,'') #FUN-980030  #FUN-990069
 
       RETURN FALSE
    END IF
    
    RETURN TRUE
END FUNCTION
