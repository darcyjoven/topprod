# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Program name...: aws_pos_ws_sub.4gl
# Descriptions...: 提供POS webservise公用服務
# Date & Author..: 12/06/01 by suncx
# Modify.........: No.FUN-C50138 12/06/01 by suncx 新增程序

DATABASE ds 

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

#[
# Description....: 提供POS webservise信息記錄，寫入rxu_file
# Date & Author..: 2012/05/29 by suncx
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_pos_ins_rxu(p_rxu)
DEFINE p_rxu RECORD LIKE rxu_file.*
   TRY 
      INSERT INTO rxu_file VALUES(p_rxu.*)
      IF sqlca.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
         LET g_status.sqlcode = sqlca.sqlcode
         CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤 
         RETURN 'N'        
      END IF
   CATCH 
      IF sqlca.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
         CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤         
      END IF
      RETURN 'N'
   END TRY  
   RETURN 'Y'
END FUNCTION 

#[
# Description....: 提供POS webservise抓取錯誤信息
# Date & Author..: 2012/05/29 by suncx
# Parameter......: p_code,p_other  错误号，其他错误信息
# Return.........: none
#]
FUNCTION aws_pos_get_code(p_code,p_msg,p_other,p_type)
   DEFINE p_code    LIKE ze_file.ze01    #错误号
   DEFINE p_other   STRING 
   DEFINE p_msg     STRING 
   DEFINE p_type    STRING
   DEFINE l_ze03    LIKE ze_file.ze03    #错误讯息
   DEFINE l_str     STRING 
   DEFINE l_n       INTEGER 
   DEFINE l_prog    LIKE gae_file.gae01
   DEFINE l_field   LIKE gae_file.gae02
   DEFINE l_gae04   LIKE gae_file.gae04

   #抓取錯誤信息
   SELECT ze03 INTO l_ze03 FROM ze_file 
    WHERE ze02 = g_lang AND ze01 = p_code

   LET l_str = l_ze03
   LET l_n = l_str.getIndexOf(':',1)
   LET g_status.code = l_str.subString(1,l_n-1)
   LET g_status.description = l_str.subString(l_n+1,l_str.getLength())
   CALL cl_replace_str(g_status.description,"msg",p_msg) RETURNING g_status.description  
   IF NOT cl_null(p_other) THEN
      CASE p_type 
         WHEN '1'
            LET l_prog = 'almq677' 
            LET l_field = "lqe17_",p_other.trim()
         WHEN '2' 
            LET l_prog = 'almi560' 
            LET l_field = "lpj09_",p_other.trim()
      END CASE
      SELECT DISTINCT gae04 INTO l_gae04 FROM gae_file 
       WHERE gae02 = l_field AND gae03 = g_lang
         AND gae01 = l_prog
      LET g_status.description = g_status.description CLIPPED,l_gae04
   END IF  
END FUNCTION 

#[
# Description....: 提供POS webservise基本檢查邏輯
# Date & Author..: 2012/05/29 by suncx
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_pos_check()
    DEFINE l_list  om.NodeList,
           l_node  om.DomNode
    DEFINE l_sql   STRING,
           l_n     LIKE type_file.num5 
    DEFINE l_shop  LIKE azw_file.azw01,    #門店編號
           l_user  LIKE ryi_file.ryi01,    #收銀員編號
           l_pwd   LIKE ryi_file.ryi03     #密碼
    DEFINE l_ryi RECORD
               ryi03   LIKE ryi_file.ryi03,
               ryiacti LIKE ryi_file.ryiacti,
               ryoacti LIKE ryo_file.ryoacti
               END RECORD 

    LET l_shop = aws_pos_get_ConnectionMsg("shop")
    LET l_user = aws_pos_get_ConnectionMsg("user")
    LET l_pwd  = aws_pos_get_ConnectionMsg("pwd")
    TRY
       SELECT COUNT(*) INTO l_n FROM rtz_file,azw_file 
        WHERE rtz01 = azw01 AND rtz01 = l_shop
       IF l_n = 0 THEN
          CALL aws_pos_get_code('aws-902',NULL,NULL,NULL)   #請求門店不存在
          RETURN 'N'
       END IF 

       LET l_sql = "SELECT ryi03,ryiacti,ryoacti",
                   "  FROM ",cl_get_target_table(l_shop,"ryi_file"),
                   "  LEFT JOIN ",cl_get_target_table(l_shop,"ryo_file"),
                   "    ON ryi01 = ryo01 AND ryo02 = '",l_shop,"'",
                   " WHERE ryi01='",l_user,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       PREPARE sel_ryi01_pre FROM l_sql
       EXECUTE sel_ryi01_pre INTO l_ryi.*
       IF SQLCA.sqlcode = 100 THEN 
          CALL aws_pos_get_code('aws-904',NULL,NULL,NULL)   #用戶名或密碼錯誤
          RETURN 'N'
       END IF 

       IF l_ryi.ryi03 <> l_pwd THEN 
          CALL aws_pos_get_code('aws-904',NULL,NULL,NULL)   #用戶名或密碼錯誤
          RETURN 'N'
       END IF 

       IF l_ryi.ryiacti = 'N' OR l_ryi.ryoacti='N' OR 
          cl_null(l_ryi.ryoacti) THEN
          CALL aws_pos_get_code('aws-903',NULL,NULL,NULL)   #用戶在該門店失效或不存在
          RETURN 'N'
       END IF 
    CATCH
       IF sqlca.sqlcode THEN
          LET g_status.sqlcode = sqlca.sqlcode
          CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤         
       END IF
       RETURN 'N'
    END TRY
    RETURN 'Y'
END FUNCTION 

#獲取Connection下資訊
FUNCTION aws_pos_get_ConnectionMsg(p_name)
    DEFINE p_name    STRING 
    DEFINE l_list    om.NodeList,
           l_node    om.DomNode
    DEFINE l_return  STRING                #返回值
    #--------------------------------------------------------------------------#
    # 讀取 Access下Guid資訊                               #
    #--------------------------------------------------------------------------#
    LET l_list = g_request_root.selectByPath("//Access/Connection")
    IF l_list.getLength() != 0 THEN          
       LET l_node = l_list.item(1)
       LET l_return = l_node.getAttribute(p_name)
    END IF
    RETURN l_return 
END FUNCTION 

FUNCTION aws_pos_addParameterGuid(p_guid)
   DEFINE p_guid  STRING 
   DEFINE l_node  om.DomNode
   DEFINE l_child om.DomNode
   DEFINE l_list  om.NodeList
   LET l_list = g_response_root.selectByPath("//ResponseContent")
   IF l_list.getLength() != 0 THEN          
      LET l_node = l_list.item(1)
      LET l_child = l_node.createChild("Guid")
      CALL l_child.setAttribute("value", p_guid)
   END IF
END FUNCTION 

#[
# Description....: 提供POS webservise查詢是否已經存在傳輸的GUID
# Date & Author..: 2012/05/29 by suncx
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_pos_guid_isExistence(p_guid)
   DEFINE p_guid  LIKE rxu_file.rxu01
   DEFINE l_cnt   LIKE type_file.num5 

   IF cl_null(p_guid) THEN RETURN FALSE END IF 
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM rxu_file 
    WHERE rxu01 = p_guid
   IF sqlca.sqlcode THEN
      LET g_status.sqlcode = sqlca.sqlcode
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤 
      RETURN FALSE        
   END IF
   IF l_cnt > 0 THEN
      RETURN TRUE 
   ELSE 
      RETURN FALSE
   END IF 
END FUNCTION 
#No.FUN-C50138
