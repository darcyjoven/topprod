# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: aws_spcfld
# Descriptions...: 
# Input parameter: 
# Return code....: 
# Usage .........:
# Date & Author..: 
# Modify.........: No.FUN-680130 06/09/15 By Xufeng 字段類型定義改為LIKE     
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/awsef.4gl"
GLOBALS "../4gl/aws_spcgw.inc"
 
FUNCTION aws_spcfld(p_qc_prog,p_qc_table,p_qry_pass,p_send)
DEFINE p_qc_prog              STRING
DEFINE p_qc_table             STRING
DEFINE p_qry_pass             STRING
DEFINE p_send                 STRING
DEFINE dom_doc                om.DomDocument
DEFINE l_recordset            om.DomNode
DEFINE l_parent               om.DomNode
DEFINE l_key1                 STRING
DEFINE l_key2                 STRING
DEFINE l_key3                 STRING
DEFINE l_key4                 STRING
DEFINE l_key5                 STRING
DEFINE l_cnt                  LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE ls_temp_path           STRING
DEFINE l_sql                  STRING,
       l_cols                 STRING,
       l_vals                 STRING,
       l_keys                 STRING,
       l_value                STRING
DEFINE ls_server              STRING
DEFINE l_xml_file             STRING
DEFINE l_i                    LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_j                    LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_wcb                  RECORD LIKE wcb_file.*
DEFINE l_wcc02                LIKE wcc_file.wcc02
DEFINE l_wcc03                LIKE wcc_file.wcc03
DEFINE l_value2               STRING
DEFINE l_str                  STRING
    WHENEVER ERROR CALL cl_err_msg_log
    
    LET l_wcb.wcb01 = p_qc_prog
    SELECT * INTO l_wcb.* FROM wcb_file WHERE wcb01 = l_wcb.wcb01
 
    LET ls_temp_path = FGL_GETENV("TEMPDIR")
    LET ls_server = fgl_getenv("FGLAPPSERVER")
    IF cl_null(ls_server) THEN
       LET ls_server = fgl_getenv("FGLSERVER")
    END IF
   
    LET l_xml_file = ls_temp_path,"/aws_spcsrv_xml_" || ls_server CLIPPED || "_" || g_user CLIPPED || "_" || p_qc_prog || ".txt"
    LET dom_doc = om.DomDocument.createFromXmlFile(l_xml_file)
    LET l_recordset = dom_doc.getDocumentElement()
       
    IF NOT cl_null(l_wcb.wcb03) THEN
       LET l_key1 = aws_xml_getTagAttribute(l_recordset,"Row", l_wcb.wcb03 CLIPPED)
    END IF
    IF NOT cl_null(l_wcb.wcb04) THEN
       LET l_key2 = aws_xml_getTagAttribute(l_recordset,"Row", l_wcb.wcb04 CLIPPED)
    END IF
    IF NOT cl_null(l_wcb.wcb05) THEN
       LET l_key3 = aws_xml_getTagAttribute(l_recordset,"Row", l_wcb.wcb05 CLIPPED)
    END IF
    IF NOT cl_null(l_wcb.wcb06) THEN
       LET l_key4 = aws_xml_getTagAttribute(l_recordset,"Row", l_wcb.wcb06 CLIPPED)
    END IF
    IF NOT cl_null(l_wcb.wcb07) THEN
       LET l_key5 = aws_xml_getTagAttribute(l_recordset,"Row", l_wcb.wcb07 CLIPPED)
    END IF
 
    IF NOT cl_null(l_wcb.wcb03) THEN
       LET l_keys = l_wcb.wcb03 CLIPPED ,"='",l_key1,"'"
    END IF
    IF NOT cl_null(l_wcb.wcb04) THEN
       LET l_keys = l_keys," AND ", l_wcb.wcb04 CLIPPED ,"='",l_key2,"'"
    END IF
    IF NOT cl_null(l_wcb.wcb05) THEN
       LET l_keys = l_keys," AND ", l_wcb.wcb05 CLIPPED ,"='",l_key3,"'"
    END IF
    IF NOT cl_null(l_wcb.wcb06) THEN
       LET l_keys = l_keys," AND ", l_wcb.wcb06 CLIPPED ,"='",l_key4,"'"
    END IF
    IF NOT cl_null(l_wcb.wcb07) THEN
       LET l_keys = l_keys," AND ", l_wcb.wcb07 CLIPPED ,"='",l_key5,"'"
    END IF
 
    #--------------------------------------------------------------------------
    # 依據 SPC 傳遞欄位, 組合 Update 動作的 SQL syntax
    #--------------------------------------------------------------------------
    LET l_j = 0
    LET l_vals = ""
    FOR l_i = 1 TO l_recordset.getAttributesCount()
        LET l_wcc02 = l_recordset.getAttributeName(l_i)
        LET l_wcc03 = ""
        SELECT wcc03 INTO l_wcc03 FROM wcc_file 
          WHERE wcc01= l_wcb.wcb01 AND wcc02 = l_wcc02
        IF l_wcc03 = 'Y' THEN 
           IF l_j = 1 THEN
              LET l_vals = l_vals, ", "
           ELSE
              LET l_j = 1
           END IF
 
           LET l_vals = l_vals, l_wcc02 CLIPPED,
                        "='", l_recordset.getAttributeValue(l_i), "'"
        END IF
    END FOR
    LET l_vals = l_vals,", ", l_wcb.wcb09 CLIPPED, "='1' "
    LET l_sql = "UPDATE ",p_qc_table ," set ",l_vals," WHERE ",l_keys 
 
    EXECUTE IMMEDIATE l_sql
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
       LET l_str = "upd ",p_qc_table," failed"
       CALL cl_err(l_str,SQLCA.sqlcode,1)
       RETURN 0,'',''
    END IF
    IF NOT cl_null(p_qry_pass)  AND NOT cl_null(p_send)  
    THEN  
       LET l_value  = aws_xml_getTagAttribute(l_recordset,"Row", p_qry_pass)
       LET l_value2 = aws_xml_getTagAttribute(l_recordset,"Row", p_send)
       RETURN 1,l_value,l_value2
    END IF
 
    RETURN 1,'',''
END FUNCTION
