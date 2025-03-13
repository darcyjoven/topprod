# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_ttsrv2_lib_recordset.4gl
# Descriptions...: 處理 TIPTOP 服務 XML 交換資料的共用 FUNCTION
# Date & Author..: 2007/02/06 by Brendan
# Memo...........:
# Modify.........: 新建立 FUN-840004
# Modify.........: No.FUN-880012 08/07/09 By kevin 取回Menu Record
# Modify.........: No.FUN-880046 08/08/12 by Echo Genero 2.11 調整
# Modify.........: No.FUN-910058 09/01/13 by Kevin 調整變數名稱
# Modify.........: No.FUN-930132 09/04/14 By Vicky 新增執行報表時的錯誤訊息 aws-364
# Modify.........: No.FUN-A70141 10/08/11 by Jay 取目錄增加zx12判斷
# Modify.........: No.FUN-A90024 10/11/15 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No.FUN-B10019 11/01/13 by Jay 修改組SQL時遇單引號所造成之問題
# Modify.........: No.FUN-B50017 11/05/04 by Jay 在URL傳遞參數時,第一個和第二個參數增加傳遞整合產品名稱 
# Modify.........: No.FUN-B20003 11/07/05 By Mandy 因為aws_ttsrv_getRecordField() 無法分辨出XML包出的欄位為""或無包出欄位
#                                                  新增aws_ttsrv_getRecordField2() 能分辨出XML包出的欄位為""或無包出欄位,有包出欄位值則回傳"Y"
# Modify.........: No.FUN-C40075 12/04/30 by Kevin 判斷 p_zxw 以程式代號設定 menu 權限
# Modify.........: No.FUN-CA0131 12/10/26 by Kevin 在 Response XML 中支持多單身
# Modify.........: No.FUN-D10038 13/01/15 by Kevin 讀取 Request XML 多層單身
#}
 
DATABASE ds
 
#FUN-840004
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
DEFINE g_count   INTEGER           #考慮多筆資料時的 id 序號計數
DEFINE g_respdoc om.DomDocument,   #Response XML Dom Document, #FUN-910058
       g_t_doc   om.DomDocument    #For String to Xml
DEFINE g_dnode   om.DomNode        #<Document> 節點
DEFINE g_snode   om.DomNode        #<Status> 節點
DEFINE g_pnode   om.DomNode        #<Parameter> 節點
 
DEFINE g_mtable   STRING           #單頭 Table Name
DEFINE g_mcolumn  DYNAMIC ARRAY OF RECORD    #單頭欄位列表
                     seq        INTEGER,     #項次
                     name       STRING,      #欄位名稱
                     datatype   STRING,      #欄位型態
                     length     INTEGER      #欄位長度
                  END RECORD
DEFINE g_dtable   STRING          #單身 Table Name
DEFINE g_dcolumn  DYNAMIC ARRAY OF RECORD   #單身欄位列表
                     seq        INTEGER,
                     name       STRING,
                     datatype   STRING,
                     length     INTEGER
                  END RECORD
DEFINE g_sql      STRING
DEFINE g_sql2     STRING
DEFINE g_sql3     STRING
DEFINE g_zx12     LIKE zx_file.zx12          #No.FUN-A70141
DEFINE g_rec_node om.DomNode                 #FUN-CA0131 記錄 <Record> 節點位置
DEFINE g_master_node om.DomNode              #FUN-D10038

#[
# Description....: 於 Response XML 中加入一筆單頭 record set
# Date & Author..: 2007/02/07 by Brendan
# Parameter......: p_record - DomNode    - 單頭 Record Dom Node
#                : p_name   - STRING     - 此筆單頭檔名稱(e.x. Table Name)
# Return.........: l_node   - om.DomNode - 此筆 Master 資料節點
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_addMasterRecord(p_record, p_name)
    DEFINE p_record   om.DomNode,
           p_name     STRING
    DEFINE l_node     om.DomNode
    
    
    WHENEVER ERROR CONTINUE
 
    IF p_record IS NULL THEN
       RETURN NULL
    END IF
        
    LET l_node = g_dnode.createChild("RecordSet")      #於 <Document> 下建立 <RecordSet> 節點
    LET g_count = g_count + 1
    CALL l_node.setAttribute("id", g_count)
 
    LET l_node = l_node.createChild("Master")          #於 <RecordSet> 下建立 <Master> 節點
    IF NOT cl_null(p_name) THEN
       CALL l_node.setAttribute("name", p_name)
    END IF
 
    CALL aws_ttsrv_buildRecord(l_node, p_record)       #依照傳入的資料新增一筆單頭資料
    
    RETURN l_node                                      #回傳此筆單頭資料節點
END FUNCTION
 
 
#[
# Description....: 於 Response XML 中加入單身 record set
# Date & Author..: 2007/02/07 by Brendan
# Parameter......: p_node   - om.DomNode - 指定要加入的單頭節點(CALL aws_ttsrv_addMasterRecord() 回傳)
#                : p_record - DomNode    - 單身 Record Dom Node
#                : p_name   - STRING     - 此筆單身檔名稱(e.x. Table Name)
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_addDetailRecord(p_node, p_record, p_name)
    DEFINE p_node     om.DomNode,
           p_record   om.DomNode,
           p_name     STRING
    DEFINE l_node     om.DomNode
    
    
    IF p_node IS NULL OR p_record IS NULL THEN
       RETURN
    END IF
    
    LET l_node = p_node.getParent()                    #取得 <RecordSet> 父節點
    
    LET l_node = l_node.createChild("Detail")          #於 <RecordSet> 下建立 <Detail> 節點
    IF NOT cl_null(p_name) THEN
       CALL l_node.setAttribute("name", p_name)
    END IF
 
    CALL aws_ttsrv_buildRecord(l_node, p_record)       #依照傳入的資料新增單身資料    
END FUNCTION
 
 
#[
# Description....: 於 Response XML 中加入回傳的變數
# Date & Author..: 2007/02/07 by Brendan
# Parameter......: p_record - om.DomNode - 回傳變數的 Record Dom Node
# Return.........: none
# Memo...........: 當回傳值非為單頭單身等資料時, 呼叫此 function 回傳(e.x. 回傳一計算好的 [客戶信用額度])
# Modify.........:
#
#]
FUNCTION aws_ttsrv_addParameterRecord(p_record)
    DEFINE p_record   om.DomNode
 
    
   IF p_record IS NULL THEN
       RETURN
    END IF
 
    CALL aws_ttsrv_buildRecord(g_pnode, p_record)       #依照傳入的資料新增回傳參數資料  
END FUNCTION
 
 
#[
# Description....: 建立 Response XML Document
# Date & Author..: 2007/02/07 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_createResponse()   
    DEFINE l_node   om.DomNode
    
    
    LET g_respdoc = om.DomDocument.create("Response")     #FUN-910058
    LET g_response_root = g_respdoc.getDocumentElement()  #FUN-910058
    
    LET l_node = g_response_root.createChild("Execution")         #建立 <Execution>
    LET g_snode = l_node.createChild("Status")                    #於 <Execution> 下建立 <Status>
  
    LET l_node = g_response_root.createChild("ResponseContent")   #建立 <ResponseContent>  
    LET g_pnode = l_node.createChild("Parameter")                 #於 <ResponseContent> 下建立 <Parameter> 
    LET g_dnode = l_node.createChild("Document")                  #於 <ResponseContent> 下建立 <Document>
    
    LET g_count = 0                                               #多筆 <RecordSet> 資料時的計數器  
END FUNCTION
 
 
#[
# Description....: 建立 Response XML 的 單頭/單身 Record
# Date & Author..: 2007/02/07 by Brendan
# Parameter......: p_node   - om.DomNode - <Master> / <Detail> 節點
#                : p_record - om.DomNode - 用來參考建立回傳資料的 單頭/單身 資料節點
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_buildRecord(p_node, p_record)
    DEFINE p_node     om.DomNode,
           p_record   om.DomNode
    DEFINE l_list1    om.NodeList,
           l_list2    om.NodeList
    DEFINE l_node     om.DomNode,
           l_child    om.DomNode,
           l_record   om.DomNode,
           l_field    om.DomNode
    DEFINE l_i        INTEGER,
           l_j        INTEGER
    DEFINE l_name     STRING,
           l_value    STRING
 
 
    #--------------------------------------------------------------------------#
    # 輪詢 4GL service function 傳入的資料節點建立 Response XML 的資料         #
    #--------------------------------------------------------------------------#
    LET l_list1 = p_record.selectByTagName("Record")
    FOR l_i = 1 TO l_list1.getLength()
        LET l_record = l_list1.item(l_i)
        
        LET l_node = p_node.createChild("Record")        #於 <Master> / <Detail> / <Parameter>下建立 <Record> 節點
 
        LET l_list2 = l_record.selectbyTagName("Field")
        FOR l_j = 1 TO l_list2.getLength()
            INITIALIZE l_name TO NULL
            INITIALIZE l_value TO NULL
            LET l_field = l_list2.item(l_j)
            LET l_name = l_field.getAttribute("name")
            LET l_value = l_field.getAttribute("value")
            
            LET l_child = l_node.createChild("Field")    #於 <Record> 下建立 <Field> 節點            
            CALL l_child.setAttribute("name", l_name)
            CALL l_child.setAttribute("value", l_value)
        END FOR
        
        #----------------------------------------------------------------------#
        # 若為建立單頭或回傳參數, 原則上應只有一個 <Record> 資料               #
        #----------------------------------------------------------------------#
        IF p_node.getTagName() = "Master" OR p_node.getTagName() = "Parameter" THEN
           EXIT FOR
        END IF 
        
   END FOR

   LET g_rec_node = l_node   #FUN-CA0131 多單身架構取回 <Record> 節點
END FUNCTION
 
 
#[
# Description....: 設定 Response XML 處理狀態值
# Date & Author..: 2007/02/07 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_setStatus()
 
    
    IF g_status.code != "0" AND cl_null(g_status.description) THEN
       LET g_status.description = cl_getmsg(g_status.code, g_lang)   #取得 error code 說明 
    END IF
    
    CALL g_snode.setAttribute("code", g_status.code)
    CALL g_snode.setAttribute("sqlcode", g_status.sqlcode)
    CALL g_snode.setAttribute("description", g_status.description)
END FUNCTION
 
 
#[
# Description....: 取得 Request XML <Parameter> 節點中指定的欄位
# Date & Author..: 2007/02/07 by Brendan
# Parameter......: p_name  - STRING - 欄位名稱
# Return.........: l_value - STRING - 欄位值
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_getParameter(p_name)
    DEFINE p_name    STRING
    DEFINE l_list    om.NodeList
    DEFINE l_node    om.DomNode
    DEFINE l_value   STRING
    
    
    INITIALIZE l_value TO NULL
    
    IF cl_null(p_name) THEN
       RETURN NULL
    END IF
    
    #--------------------------------------------------------------------------#
    # 搜尋 <Parameter> 是否有指定名稱的欄位                                    #
    #--------------------------------------------------------------------------#
    LET l_list = g_request_root.selectByPath("//Parameter/Record/Field[@name=\"" || p_name CLIPPED || "\"]")
    IF l_list.getLength() != 0 THEN
       LET l_node = l_list.item(1)
       LET l_value = l_node.getAttribute("value")
    END IF
    
    #--------------------------------------------------------------------------#
    # Special Case : 若是找 SQL Where Condition 則 Request 無指定時需給預設值  #
    #--------------------------------------------------------------------------#
    IF p_name CLIPPED = "condition" AND cl_null(l_value) THEN
       LET l_value = " 1=1 "
    END IF
    
    RETURN l_value
END FUNCTION
 
 
#[
# Description....: 取得 Request XML <Document> 節點中的單檔筆數個數
# Date & Author..: 2008/03/04 by Brendan
# Parameter......: p_name - STRING  - 單檔名稱
# Return.........: l_cnt  - INTEGER - 單檔筆數
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_getMasterRecordLength(p_name)
    DEFINE p_name   STRING
    DEFINE l_list   om.NodeList
    DEFINE l_cnt    INTEGER
    
    
    #--------------------------------------------------------------------------#
    # 搜尋 <Document> 有多少筆對應的 <Master> 節點                             #
    #--------------------------------------------------------------------------#
    IF cl_null(p_name) THEN
       LET l_list = g_request_root.selectByPath("//Document/RecordSet/Master")     
    ELSE
       LET l_list = g_request_root.selectByPath("//Document/RecordSet/Master[@name=\"" || p_name || "\"]")    
    END IF
    
    LET l_cnt = l_list.getLength()
    RETURN l_cnt
END FUNCTION
 
 
#[
# Description....: 取得 Request XML <Document> 節點中的單身筆數個數
# Date & Author..: 2008/03/04 by Brendan
# Parameter......: p_node - om.DomNode - 目前處理的單頭節點
#                : p_name - STRING     - 單身名稱
# Return.........: l_cnt  - INTEGER    - 單身筆數
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_getDetailRecordLength(p_node, p_name)
    DEFINE p_node    om.DomNode,
           p_name    STRING
    DEFINE l_list    om.NodeList
    DEFINE l_node    om.DomNode
    DEFINE l_cnt     INTEGER
    
    
    IF p_node IS NULL THEN
       RETURN 0
    END IF
    
    LET l_node = p_node.getParent()   #從 <Record> 取 <Master> 父節點
    LET l_node = l_node.getParent()   #再從 <Master> 取 <RecordSet> 父節點
    
    #--------------------------------------------------------------------------#
    # 搜尋 <RecordSet> 有對應的 <Detail> 節點                                  #
    #--------------------------------------------------------------------------#
    IF cl_null(p_name) THEN
       LET l_list = l_node.selectByPath("//Detail/Record")     
    ELSE
       LET l_list = l_node.selectByPath("//Detail[@name=\"" || p_name || "\"]/Record")    
    END IF
    
    LET l_cnt = l_list.getLength()
    RETURN l_cnt
END FUNCTION
 
 
#[
# Description....: 取得 Request XML 中指定的單檔節點 Dom Node
# Date & Author..: 2008/03/04 by Brendan
# Parameter......: p_i    - INTEGER    - 第 N 筆單檔
#                : p_name - STRING     - 單檔名稱
# Return.........: l_node - om.DomNode - 第 N 筆單檔的 Dom Node
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_getMasterRecord(p_i, p_name)
    DEFINE p_i      INTEGER,
           p_name   STRING
    DEFINE l_list   om.NodeList
    DEFINE l_i      INTEGER
    DEFINE l_node   om.DomNode
    
    
    IF cl_null(p_i) OR p_i = 0 THEN
       RETURN NULL
    END IF
    
    IF cl_null(p_name) THEN
       LET l_list = g_request_root.selectByPath("//Document/RecordSet/Master")     
    ELSE
       LET l_list = g_request_root.selectByPath("//Document/RecordSet/Master[@name=\"" || p_name || "\"]")    
    END IF
    FOR l_i = 1 TO l_list.getLength()
        LET l_node = l_list.item(l_i)
        
        #----------------------------------------------------------------------#
        # 若搜尋的 <Master> 節點順序與呼叫時傳入的值相同時                     #
        #----------------------------------------------------------------------#
        IF l_i = p_i THEN
           LET l_node = l_node.getFirstChild()     #往下取得 <Record> 節點回傳
           IF l_node.getTagName() = "@chars" THEN  #需要特別判斷抓到的第一個子節點是否為 Text Node
              LET l_node = l_node.getNext()
           END IF
           EXIT FOR
        END IF
    END FOR
 
    RETURN l_node
END FUNCTION
 
 
#[
# Description....: 取得 Request XML 中指定的單身節點 Dom Node
# Date & Author..: 2008/03/04 by Brendan
# Parameter......: p_node - om.DomNode - 目前單檔資料節點
#                : p_i    - INTEGER    - 第 N 筆單身
#                : p_name - STRING     - 單身名稱
# Return.........: l_node - om.DomNode - 第 N 筆單身的 Dom Node
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_getDetailRecord(p_node, p_i, p_name)
    DEFINE p_node    om.DomNode,
           p_i       INTEGER,
           p_name    STRING
    DEFINE l_node1   om.DomNode,
           l_node2   om.DomNode
    DEFINE l_list    om.NodeList
    DEFINE l_i       INTEGER
    
    
    IF p_node IS NULL OR ( cl_null(p_i) OR p_i = 0 ) THEN
       RETURN NULL
    END IF
 
    LET l_node1 = p_node.getParent()    #取 <Master> 父節點
    LET l_node1 = l_node1.getParent()   #取 <RecordSet> 父節點
    
    IF cl_null(p_name) THEN
       LET l_list = l_node1.selectByPath("//Detail/Record")     
    ELSE
       LET l_list = l_node1.selectByPath("//Detail[@name=\"" || p_name || "\"]/Record")    
    END IF
    FOR l_i = 1 TO l_list.getLength()
        LET l_node2 = l_list.item(l_i)
        
        #----------------------------------------------------------------------#
        # 若搜尋的單身 <Record> 節點順序與呼叫時傳入的值相同時                 #
        #----------------------------------------------------------------------#
        IF l_i = p_i THEN
           EXIT FOR
        END IF
    END FOR
 
    RETURN l_node2
END FUNCTION
 
 
#[
# Description....: 取得指定的 單頭 / 單身 節點中的欄位值
# Date & Author..: 2008/03/04 by Brendan
# Parameter......: p_node  - om.DomNode - 單頭 / 單身 節點
#                : p_name  - STRING     - 欄位名稱
# Return.........: l_value - STRING     - 欄位值
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_getRecordField(p_node, p_name)
    DEFINE p_node    om.DomNode,
           p_name    STRING
    DEFINE l_value   STRING
    DEFINE l_list    om.NodeList
    DEFINE l_node    om.DomNode
        
    
    IF p_node IS NULL OR cl_null(p_name) THEN
       RETURN NULL
    END IF
    
    #--------------------------------------------------------------------------#
    # 接著尋找是否為對應名稱的 <Field> 欄位                                    #
    #--------------------------------------------------------------------------#
    LET l_list = p_node.selectByPath("//Field[@name=\"" || p_name || "\"]")
    IF l_list.getLength() != 0 THEN   #找的到節點才取值
       LET l_node = l_list.item(1)
       LET l_value = l_node.getAttribute("value")
    END IF
    
    RETURN l_value
END FUNCTION
 
 
#[
# Description....: 設定指定的 單頭 / 單身 節點中的欄位值(單一欄位)
# Date & Author..: 2008/03/04 by Brendan
# Parameter......: p_node  - om.DomNode - 單頭 / 單身 節點
#                : p_name  - STRING     - 欄位名稱
#                : p_value - STRING     - 欄位值
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_setRecordField(p_node, p_name, p_value)
    DEFINE p_node    om.DomNode,
           p_name    STRING,
           p_value   STRING
    DEFINE l_list    om.NodeList
    DEFINE l_node    om.DomNode
    
    IF p_node IS NULL OR cl_null(p_name) THEN
       RETURN NULL
    END IF
 
    #--------------------------------------------------------------------------#
    # 接著尋找是否為對應名稱的 <Field> 欄位                                    #
    #--------------------------------------------------------------------------#
    LET l_list = p_node.selectByPath("//Field[@name=\"" || p_name || "\"]")
    IF l_list.getLength() != 0 THEN               #找的到節點
       LET l_node = l_list.item(1)
       CALL l_node.setAttribute("value", p_value)
    ELSE
       LET l_node = p_node.createChild("Field")
       CALL l_node.setAttribute("name", p_name)
       CALL l_node.setAttribute("value", p_value)
    END IF
    
END FUNCTION
 
#[
# Description....: 設定指定的 單頭 / 單身 節點中的欄位值(一筆 Record)
# Date & Author..: 2008/03/04 by Brendan
# Parameter......: p_node  - om.DomNode - 單頭 / 單身 節點
#                : p_record - om.DomNode - 欄位 Record 節點
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_setRecordField_record(p_node, p_record)
    DEFINE p_node       om.DomNode,
           p_record     om.DomNode
    DEFINE l_name       STRING,
           l_value      STRING
    DEFINE l_i          INTEGER
    DEFINE l_list       om.NodeList
    DEFINE l_flist      om.NodeList
    DEFINE l_node       om.DomNode
    DEFINE l_fnode      om.DomNode
        
    
    IF p_node IS NULL OR p_record IS NULL THEN
       RETURN NULL
    END IF
 
    #--------------------------------------------------------------------------#
    # 取得 <Record> 節點中的 <Field>                                           #
    #--------------------------------------------------------------------------#
    LET l_list = p_record.selectByTagName("Field")
    FOR l_i = 1 TO l_list.getLength()
        LET l_node = l_list.item(l_i)
        LET l_name = l_node.getAttribute("name")
        LET l_value = l_node.getAttribute("value")
    
        #----------------------------------------------------------------------#
        # 接著尋找是否為對應名稱的 <Field> 欄位                                #
        #----------------------------------------------------------------------#
        LET l_flist = p_node.selectByPath("//Field[@name=\"" || l_name || "\"]")
        IF l_flist.getLength() != 0 THEN               #找的到節點
           LET l_fnode = l_flist.item(1)
           CALL l_fnode.setAttribute("value", l_value)
        ELSE
           LET l_fnode = p_node.createChild("Field")
           CALL l_fnode.setAttribute("name", l_name)
           CALL l_fnode.setAttribute("value", l_value)
        END IF
    END FOR
END FUNCTION
 
#[
# Description....: 取得寫入 單頭 / 單身 資料的 INSERT / UPDATE 的 SQL 語句
# Date & Author..: 2008/03/04 by Brendan
# Parameter......: p_node  - om.DomNode - 單頭 / 單身 節點
#                : p_table - STRING     - Table Name
#                : p_type  - STRING     - SQL 型態 ; 目前有 I(INSERT) / U(UPDATE) 兩種
#                : p_wc    - STRING     - 主要用於 UPDATE 語句時給予的 WHERE condition (e.x. WHERE ima01 = 'Y0001')
# Return.........: l_sql   - STRING     - SQL 語句
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_getRecordSql(p_node, p_table, p_type, p_wc)
    DEFINE p_node     om.DomNode,
           p_table    STRING,
           p_type     STRING,
           p_wc       STRING
    DEFINE l_sql      STRING
    DEFINE l_i        INTEGER,
           l_j        INTEGER
    DEFINE l_list     om.NodeList
    DEFINE l_node     om.DomNode,
           l_pnode    om.DomNode
    DEFINE l_name     STRING
    DEFINE l_value    STRING
    DEFINE l_column   DYNAMIC ARRAY OF RECORD
                         name    STRING,
                         value   STRING
                      END RECORD
    DEFINE l_flag     INTEGER
    DEFINE l_collist  STRING,
           l_colval   STRING
    DEFINE l_strbuf   base.StringBuffer     #FUN-B10019
 
    
    IF p_node IS NULL OR cl_null(p_table) OR cl_null(p_type) THEN
       RETURN NULL
    END IF
    
    LET p_type = p_type.toUpperCase()
    IF p_type NOT MATCHES "[IU]" THEN
       RETURN NULL
    END IF
 
    #----------------------------------------------------------------------#
    # 由傳入的 XML 資料中讀取他系統欄位與欄位值                            #
    #----------------------------------------------------------------------#
    LET p_node = aws_ttsrv_parseDataSetRecrodField(p_node)
    
    LET l_pnode = p_node.getParent()   #取這筆 Record 的父節點 --- <Master> or <Detail>

    #FUN-A90024 ---start
    #原本getTableColumn()取得欄位資訊改用call cl_query_prt_getlength()
    #所以需先在這裡create temptable
    #CALL cl_query_prt_temptable()   #本來要在這裡先create temptable,因為會影響單頭單身的SQL交易,故移到aws_ttsrv_preprocess()先create
    #FUN-A90024 ---end 
    #--------------------------------------------------------------------------#
    # 若傳入 Table Name 與目前紀錄的相同, 則不需再取得欄位列表以節省處理時間   #
    #--------------------------------------------------------------------------#
    CASE l_pnode.getTagName()
         WHEN "Master"    #單頭檔
               IF cl_null(g_mtable) OR g_mtable != p_table THEN   
                  LET g_mtable = p_table
                  CALL aws_ttsrv_getTableColumn(g_mtable, g_mcolumn)   #取得 Table 欄位列表, 用來驗證 XML 中的欄位是否屬於此 Table
               END IF
          WHEN "Detail"
               IF cl_null(g_dtable) OR g_dtable != p_table THEN   
                  LET g_dtable = p_table
                  CALL aws_ttsrv_getTableColumn(g_dtable, g_dcolumn)   #取得 Table 欄位列表, 用來驗證 XML 中的欄位是否屬於此 Table                 
               END IF               
    END CASE
    
    #--------------------------------------------------------------------------#
    # 取得此 單頭 / 單身 <Record> 節點中的 <Field> 以組成 SQL 語句             #
    #--------------------------------------------------------------------------#
    CALL p_node.writeXML("test.xml")
    CALL l_column.clear()
    LET l_list = p_node.selectByTagName("Field")
    FOR l_i = 1 TO l_list.getLength()
        LET l_node = l_list.item(l_i)
        LET l_name = l_node.getAttribute("name")
        LET l_value = l_node.getAttribute("value")
        IF l_name = "rvb37" THEN DISPLAY "value:",l_value,"==="   END IF
        #----------------------------------------------------------------------#
        # 比對抓到的 Field name 是否為傳入 Table 的欄位 ; 若不是則不納入 SQL   #
        #----------------------------------------------------------------------#
        LET l_flag = FALSE
        CASE l_pnode.getTagName()
             WHEN "Master"
                  FOR l_j = 1 TO g_mcolumn.getLength()
                      IF l_name = g_mcolumn[l_j].name CLIPPED THEN
                         LET l_flag = TRUE
                         EXIT FOR
                      END IF                 
                  END FOR
             WHEN "Detail"
                  FOR l_j = 1 TO g_dcolumn.getLength()
                      IF l_name = g_dcolumn[l_j].name CLIPPED THEN
                         LET l_flag = TRUE
                         EXIT FOR
                      END IF                 
                  END FOR        
        END CASE
        
        #---FUN-B10019-----start----------------------
        LET l_strbuf = base.StringBuffer.create()
        CALL l_strbuf.append(l_value)
        CALL l_strbuf.replace('\'','\'\'',0)
        LET l_value = l_strbuf.toString()
        #---FUN-B10019-----end------------------------
 
        #----------------------------------------------------------------------#
        # 將找到的欄位及其值放入陣列中                                         #
        #----------------------------------------------------------------------#
        IF l_flag THEN
           LET l_j = l_column.getLength() + 1
           LET l_column[l_j].name = l_name
           LET l_column[l_j].value = l_value 
        END IF 
    END FOR
 
    CASE p_type CLIPPED
         WHEN "I"   #組成 INSERT SQL 語句
              FOR l_i = 1 TO l_column.getLength()
                  IF l_i != 1 THEN
                     LET l_collist = l_collist, ", "
                     LET l_colval = l_colval, ", "
                  END IF
                  LET l_collist = l_collist, l_column[l_i].name
                  LET l_colval = l_colval, "'", l_column[l_i].value, "'"
              END FOR
              LET l_sql = "INSERT INTO ", p_table, " (", l_collist, ") VALUES (", l_colval, ")"             
         WHEN "U"   #組成 UPDATE SQL 語句
             FOR l_i = 1 TO l_column.getLength()
                  IF l_i != 1 THEN
                     LET l_collist = l_collist, ", "
                  END IF
                  LET l_collist = l_collist, l_column[l_i].name, " = '", l_column[l_i].value, "'"
              END FOR
              LET l_sql = "UPDATE ", p_table, " SET ", l_collist                    
    END CASE
    IF NOT cl_null(p_wc) THEN
       LET l_sql = l_sql, " WHERE ", p_wc
    END IF
 
    DISPLAY l_sql
    RETURN l_sql
END FUNCTION
 
 
#[
# Description....: 取得 XML 字串的 Root Node, 提供後續作業處理
# Date & Author..: 2007/02/07 by Brendan
# Parameter......: p_xml  - STRING  - XML 字串
# Return.........: l_root - DomNode - XML Root Node
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_stringToXml(p_xml)
    DEFINE p_xml       STRING
    DEFINE l_ch        base.Channel,
           l_xmlFile   STRING,
           l_root      om.DomNode
    
    
    IF cl_null(p_xml) THEN
       RETURN NULL
    END IF
 
    #--------------------------------------------------------------------------#
    # String to XML 暫存檔                                                     #
    #--------------------------------------------------------------------------#
    LET l_ch = base.Channel.create()
    LET l_xmlFile = fgl_getenv("TEMPDIR"), "/", "aws_ttsrv2_", FGL_GETPID() USING '<<<<<<<<<<', ".xml"
    CALL l_ch.openFile(l_xmlFile, "w")
    CALL l_ch.setDelimiter("")       #FUN-880046
    CALL l_ch.write(p_xml)
    CALL l_ch.close()
    
    #--------------------------------------------------------------------------#
    # 讀取 XML File 建立 Dom Node                                              #
    #--------------------------------------------------------------------------#
    LET g_t_doc = om.DomDocument.createFromXmlFile(l_xmlFile)   #用 module variable 才可以後續建立節點( createChild() ...)
    RUN "rm -f " || l_xmlFile || " >/dev/null 2>&1"
    INITIALIZE l_root TO NULL
    IF g_t_doc IS NOT NULL THEN
       LET l_root = g_t_doc.getDocumentElement()
    END IF
    
    RETURN l_root
END FUNCTION
 
 
#[
# Description....: 將 XML 文件轉換成 String 字串
# Date & Author..: 2007/02/14 by Echo
# Parameter......: p_xml - DomNode - XML Root Node
# Return.........: l_str - STRING  - XML 字串
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_xmlToString(p_xml)
    DEFINE p_xml       om.DomNode
    DEFINE l_str       STRING,
           l_xmlFile   STRING,
           l_ch        base.Channel,
           l_buf       STRING,
           l_i         LIKE type_file.num10,
           l_sb        base.StringBuffer
 
    
    IF p_xml IS NULL THEN
       RETURN NULL
    END IF
 
    #--------------------------------------------------------------------------#
    # XML to String 暫存檔                                                     #
    #--------------------------------------------------------------------------#
    LET l_xmlFile = fgl_getenv("TEMPDIR"), "/", "aws_ttsrv2_", FGL_GETPID() USING '<<<<<<<<<<', ".xml"
    CALL p_xml.writeXml(l_xmlFile)
    
    #--------------------------------------------------------------------------#
    # 將 XML File 內容以字串方式回傳                                           #
    #--------------------------------------------------------------------------#    
    LET l_sb = base.StringBuffer.create()
    LET l_ch = base.Channel.create()
    CALL l_ch.openFile(l_xmlFile, "r")
    CALL l_ch.setDelimiter(NULL)
    LET l_i = 1
    WHILE l_ch.read(l_buf)
        IF l_i = 1 THEN   #第一行的 <?xml .... ?> 不抓取
           LET l_i = l_i + 1
           CONTINUE WHILE
        ELSE
           IF l_i != 2 THEN
              CALL l_sb.append("\n")
           END IF
        END IF
 
        CALL l_sb.append(l_buf CLIPPED)
        
        LET l_i = l_i + 1
    END WHILE
    CALL l_ch.close()
    
    RUN "rm -f " || l_xmlFile || " >/dev/null 2>&1"
 
    LET l_str = l_sb.toString()
    
    RETURN l_str
END FUNCTION
 
 
#[
# Description....: 取得 Table 欄位列表及相關資料(型態 / 長度 / ...)
# Date & Author..: 2008/03/10 by Brendan
# Parameter......: p_table  - STRING          - Table Name 
#                : p_column - ARRAY OF RECORD - 欄位列表 ARRAY
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_getTableColumn(p_table, p_column)
    DEFINE p_table     STRING,
           p_column    DYNAMIC ARRAY OF RECORD
                          seq        INTEGER,
                          name       STRING,
                          datatype   STRING,
                          length     INTEGER
                       END RECORD
    DEFINE l_column    RECORD
                          seq        INTEGER,
                          name       VARCHAR(20),
                          datatype   VARCHAR(20),
                          length     INTEGER
                       END RECORD
    DEFINE l_db_type   STRING
    DEFINE l_sql       STRING
    DEFINE l_i         INTEGER
    DEFINE l_zta17     LIKE zta_file.zta17
    DEFINE l_zta01     LIKE zta_file.zta01
 
 
    IF cl_null(p_table) THEN
       RETURN
    END IF
 
    CALL p_column.clear()

    #---FUN-A90024---start-----
    #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
    #目前統一用sch_file紀錄TIPTOP資料結構
    #LET l_db_type = cl_db_get_database_type()   #取得目前資料庫型態(ORA / IFX / MSV / ...)
 
    #LET l_zta01 = p_table 
    #SELECT zta17 INTO l_zta17 FROM zta_file WHERE zta01 = l_zta01 AND zta02 = g_dbs
    #
    #CASE l_db_type                                    
    #     WHEN "IFX"                                          
    #          IF NOT cl_null(l_zta17) THEN
    #             LET l_sql = "SELECT UNIQUE c.colno, c.colname, c.coltype,c. collength ",
    #                         "  FROM ",l_zta17 CLIPPED,":syscolumns c,",
    #                         "       ",l_zta17 CLIPPED,":systables t",
    #                         " WHERE c.tabid=t.tabid AND t.tabname = '", p_table CLIPPED, "'",
    #                         " ORDER BY colno"
    #          ELSE
    #             LET l_sql = "SELECT UNIQUE c.colno, c.colname, c.coltype, c.collength ",
    #                         "  FROM syscolumns c, systables t",
    #                         " WHERE c.tabid=t.tabid AND t.tabname = '", p_table CLIPPED, "'",
    #                         " ORDER BY colno"
    #          END IF
    # 
    #     WHEN "ORA"
    #          IF NOT cl_null(l_zta17) THEN
    #             LET l_sql="SELECT UNIQUE column_id, LOWER(column_name), LOWER(data_type), DECODE(data_type, 'VARCHAR2', data_length, 'DATE', 10, 'NUMBER', data_precision) FROM all_tab_columns",
    #                       " WHERE LOWER(table_name) = '",p_table CLIPPED,"' ",
    #                       " ORDER BY column_id"
    #          ELSE
    #             LET l_sql="SELECT UNIQUE column_id, LOWER(column_name), LOWER(data_type), DECODE(data_type, 'VARCHAR2', data_length, 'DATE', 10, 'NUMBER', data_precision) FROM user_tab_columns",
    #                       " WHERE LOWER(table_name) = '",p_table CLIPPED,"' ",
    #                       " ORDER BY column_id"
    #          END IF
    #     
    #     WHEN "MSV"
    #           #-- MSV block
    #END CASE
    # 
    # 
    #DECLARE col_info CURSOR FROM l_sql
    #IF SQLCA.SQLCODE THEN
    #   RETURN
    #END IF
    #
    #LET l_i = 1
    #FOREACH col_info INTO l_column.*
    #    IF l_db_type = "IFX" THEN
    #       CASE 
    #            WHEN l_column.datatype = '0' OR l_column.datatype = '256'
    #                 LET l_column.datatype = 'char'
    #            WHEN l_column.datatype = '1' OR l_column.datatype = '257'
    #                 LET l_column.datatype = 'smallint'
    #                 LET l_column.length = 5
    #            WHEN l_column.datatype = '2' OR l_column.datatype = '258'
    #                 LET l_column.datatype = 'integer'
    #                 LET l_column.length = 10
    #            WHEN l_column.datatype = '5' OR l_column.datatype = '261'
    #                 LET l_column.datatype = 'decimal'
    #                 LET l_column.length = 20
    #            WHEN l_column.datatype = '7' OR l_column.datatype = '263'
    #                 LET l_column.datatype = 'date'
    #                 LET l_column.length = 10
    #            WHEN l_column.datatype ='13' OR l_column.datatype = '269'   
    #                 LET l_column.datatype = 'char'
    #       END CASE
    #    END IF
    #
    #    LET p_column[l_i].seq = l_column.seq
    #    LET p_column[l_i].name = l_column.name CLIPPED
    #    LET p_column[l_i].datatype = l_column.datatype CLIPPED       
    #    LET p_column[l_i].length = l_column.length
    #    LET l_i = l_i + 1    
    #END FOREACH
    CALL cl_query_prt_getlength(p_table, 'I', 'm', 0)
    DECLARE col_info CURSOR FOR 
      SELECT xabc01, xabc02, xabc06, xabc04 FROM xabc ORDER BY xabc01
    IF SQLCA.SQLCODE THEN
       RETURN
    END IF
    
    LET l_i = 1
    FOREACH col_info INTO l_column.*
        LET p_column[l_i].seq = l_column.seq
        LET p_column[l_i].name = l_column.name CLIPPED
        LET p_column[l_i].datatype = l_column.datatype CLIPPED       
        LET p_column[l_i].length = l_column.length
        LET l_i = l_i + 1    
    END FOREACH
    #---FUN-A90024---end-------
END FUNCTION
 
#[
# Description....: 檢查 cl_cmdrun() 程式處理的狀態值
# Date & Author..: 2007/02/07 by Brendan
# Parameter......: p_prog - STRING    - 程式代碼
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_cmdrun_checkStatus(p_prog)
DEFINE p_prog           STRING
DEFINE l_channel        base.Channel
DEFINE ls_context_file  STRING
DEFINE l_str            STRING
DEFINE ls_server        STRING
DEFINE ls_temp_path     STRING
 
    LET ls_server = fgl_getenv("FGLAPPSERVER")
    IF cl_null(ls_server) THEN
       LET ls_server = fgl_getenv("FGLSERVER")
    END IF
    lET ls_temp_path = FGL_GETENV("TEMPDIR")
    LET ls_context_file = ls_temp_path,"/aws_ttsrv2_" || ls_server CLIPPED || "_" || g_user CLIPPED || "_" || p_prog CLIPPED || ".txt"
    display "(aws)file:", ls_context_file CLIPPED
    IF mi_tpgateway_status > 0 THEN
       #--FUN-930132--start-- 
       CASE g_service
          WHEN "GetReportData"
               LET g_status.code = 'aws-364'
          #若有不同service所需對應不同的錯誤訊息，請新增在此！
          #...
          OTHERWISE
               LET g_status.code = 'aws-086'
       END CASE
       #--FUN-930132--end--
    ELSE
       LET l_channel = base.Channel.create()
       CALL l_channel.openFile(ls_context_file, "r")
       WHILE l_channel.read(l_str)
       END WHILE
       CALL l_channel.close()
       IF NOT cl_null(l_str) THEN
          LET g_status.code = "-1"
          LET g_status.description = l_str
          RUN "rm -f " || ls_context_file ||" 2>/dev/null"
       END IF
    END IF    
END FUNCTION
 
#[
# Description....: 由整合系統傳入的 Request XML 讀取欄位與欄位值
# Date & Author..: 2007/02/07 by Brendan
# Parameter......: p_xml   - DomNode - XML Node (<Request> 中的 <Field> 節點)
# Return.........: p_xml   - DomNode - XML Node (<Request> 中的 <Field> 節點)
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_parseDataSetRecrodField(p_xml)
DEFINE p_xml             om.DomNode
DEFINE l_i               LIKE type_file.num10,
       l_list            om.NodeList,
       l_node            om.DomNode,
       l_child           om.DomNode,
       l_parent_node     om.DomNode,
       l_name            LIKE wss_file.wss06,
       l_value           STRING,
       l_wss04           LIKE wss_file.wss04,
       l_wss05           LIKE wss_file.wss05
DEFINE l_sql             STRING
DEFINE l_table_name      STRING
DEFINE l_parent_name     STRING
DEFINE l_cnt             LIKE type_file.num10
DEFINE l_wss03           LIKE wss_file.wss03
 
    LET l_sql = "SELECT COUNT(*) FROM wss_file ",
                " WHERE wss01 = '",g_service,"'",
                "   AND wss02 = 'S'",
                "   AND wss03 = '",g_access.application CLIPPED,"'"
    PREPARE wss_precount FROM l_sql
    DECLARE wss_count CURSOR FOR wss_precount
    OPEN wss_count
    FETCH wss_count INTO l_cnt
    IF l_cnt = 0 THEN
       LET l_wss03 ='*'
    ELSE 
       LET l_wss03 = g_access.application CLIPPED
    END IF
 
    LET l_sql = "SELECT wss04 FROM wss_file ",
                " WHERE wss01 = '",g_service,"'",
                "   AND wss02 = 'S'",
                "   AND wss03 = '",l_wss03 CLIPPED,"'",
                "   AND wss06 = ? "
    DECLARE wss_cs CURSOR FROM l_sql
 
    #--------------------------------------------------------------------------#
    # 檢查是否有 ERP 欄位 <---> 整合系統欄位的設定關係                         #
    #--------------------------------------------------------------------------#
    LET l_list = p_xml.selectByTagName("Field")
    FOR l_i = 1 TO l_list.getLength()
        LET l_node = l_list.item(l_i)
        LET l_name = l_node.getAttribute("name")
        LET l_value = l_node.getAttribute("value")
 
        OPEN wss_cs USING l_name 
        FETCH wss_cs INTO l_wss04
 
        IF NOT cl_null(l_wss04) THEN
           LET l_name = l_wss04 CLIPPED
        END IF
 
        CALL l_node.setAttribute("name", l_name CLIPPED)
    END FOR
    LET l_sql = "SELECT wss04,wss05 FROM wss_file ",
                " WHERE wss01 = '",g_service,"'",
                "   AND wss02 = 'S'",
                "   AND wss03 = '",l_wss03 CLIPPED,"'"
    DECLARE wss05_cs CURSOR FROM l_sql
 
    FOREACH wss05_cs INTO l_wss04,l_wss05
        LET l_list = p_xml.selectByTagName("Record")
        FOR l_i = 1 TO l_list.getLength()
            LET l_node = l_list.item(l_i)
            LET l_parent_node = l_node.getParent()
           # LET l_table_name = cl_get_table_name(l_wss04 CLIPPED)
           # LET l_parent_name = l_parent_node.getAttribute("name")
           # IF l_table_name = l_parent_name THEN
               LET l_list = l_node.selectByPath("//Field[@name=\"" || l_wss04 CLIPPED || "\"]")
               IF l_list.getLength() > 0 THEN
                  LET l_child = l_list.item(l_i)
                  LET l_value = aws_ttsrv_getRecordField(l_child, l_wss04 CLIPPED)
                  IF cl_null(l_value) AND NOT cl_null(l_wss05) THEN
                     LET l_value = l_wss05 CLIPPED
                     CALL l_child.setAttribute("value", l_value)
                     EXIT FOR
                  END IF
               ELSE
                 LET l_child = l_node.createChild("Field")   
                 CALL l_child.setAttribute("name", l_wss04 CLIPPED)
                 CALL l_child.setAttribute("value", l_wss05 CLIPPED)
               END IF
           # END IF
        END FOR
    END FOREACH
 
    CALL p_xml.writeXML('p_xml_test.xml')
    RETURN p_xml
END FUNCTION
 
#FUN-880012 --start
FUNCTION aws_ttsrv_addMasterMenu(p_record, p_name,p_user)
    DEFINE p_record   om.DomNode,
           p_name     LIKE zm_file.zm01,
           p_user     LIKE zx_file.zx01
    DEFINE l_node     om.DomNode
    DEFINE l_sql      STRING               #FUN-C40075
    
    WHENEVER ERROR CONTINUE
 
    IF p_record IS NULL THEN
       RETURN NULL
    END IF
        
    LET l_node = g_dnode.createChild("RecordSet")      #於 <Document> 下建立 <RecordSet> 節點
    LET g_count = g_count + 1
    CALL l_node.setAttribute("id", g_count)
 
    LET l_node = l_node.createChild("Master")         #於 <RecordSet> 下建立 <Master> 節點
    #IF NOT cl_null(p_name) THEN
    #   CALL l_node.setAttribute("name", p_name)
    #END IF
 
    CALL aws_ttsrv_buildMenuRecord (l_node, p_record)  RETURNING  l_node  #依照傳入的資料新增一筆單頭資料    
     
    #---FUN-A70141---start-----
    SELECT zx12 INTO g_zx12 FROM zx_file WHERE zx01 = p_user

    IF cl_null(g_zx12) THEN
       LET g_zx12 = 'Y'
    END IF
    #---FUN-A70141---end-------

    LET g_sql ="SELECT zm04 FROM zm_file WHERE zm01=? ORDER BY zm03"
    PREPARE zm_sql FROM g_sql
    DECLARE lcurs_zm CURSOR FOR zm_sql
    	
    LET g_sql2 = "SELECT unique 'Y' from zy_file",
                   " where zy02=? ",
                   " AND zy01 in (SELECT zxw04 from zxw_file  where zxw01=? ",
                   " UNION SELECT zx04 from zx_file where zx01=? )"
    PREPARE zy_sql FROM g_sql2
    DECLARE zy_curs CURSOR FOR zy_sql
    	
    #FUN-C40075 start
    LET l_sql = "SELECT 'Y' FROM zxw_file ",
                " WHERE zxw01 = ? AND zxw04 = ? AND zxw03='2' "
    PREPARE zxw_pre FROM l_sql
    DECLARE zxw_curs CURSOR FOR zxw_pre
    #FUN-C40075 end

    LET g_sql3 ="SELECT COUNT(*) FROM zm_file WHERE zm01=?"
    PREPARE zm_precount FROM g_sql3
    DECLARE zm_count CURSOR FOR zm_precount	
    	
    CALL aws_create_menu_tree(g_lang,l_node,p_name,p_user)
    RETURN l_node                                     #回傳此筆單頭資料節點
END FUNCTION
 
FUNCTION aws_create_menu_tree(p_lang, p_parent, p_menu_id,p_user)
   DEFINE   p_lang        LIKE type_file.chr1,         #No.FUN-690005 VARCHAR(1) 
            p_parent      om.DomNode,
            p_menu_id     LIKE zm_file.zm01,
            p_user        LIKE zx_file.zx01
   DEFINE   ls_text       STRING,
            li_cmd_count  LIKE type_file.num5,
            lnode_child   om.DomNode,
            l_url         STRING
   DEFINE   l_zm          RECORD 
   	                         zm04   LIKE zm_file.zm04                        
                          END RECORD
   DEFINE la_zm           DYNAMIC ARRAY OF RECORD
   	                         zm04   LIKE zm_file.zm04                        
                          END RECORD
   DEFINE li_i            LIKE type_file.num5
   DEFINE l_menu     RECORD
                         name   LIKE zm_file.zm04,
                         text   LIKE gaz_file.gaz03,
                         url    LIKE type_file.chr500
                     END RECORD   
   
   LET p_menu_id = p_menu_id CLIPPED
   FOREACH lcurs_zm USING p_menu_id INTO l_zm.*
      IF (SQLCA.SQLCODE) THEN
         EXIT FOREACH
      END IF
 
      LET la_zm[li_i+1].* = l_zm.*
      LET li_i = li_i + 1
   END FOREACH
   
   FOR li_i = 1 TO la_zm.getLength()
      LET ls_text = cl_get_node_text(p_lang, la_zm[li_i].zm04)
      LET ls_text = ls_text.trim()      
      
      OPEN zm_count USING la_zm[li_i].zm04
      FETCH zm_count INTO li_cmd_count 
      CLOSE  zm_count
      IF NOT cl_null(p_user) AND NOT aws_check_auth_menu(p_user,la_zm[li_i].zm04) THEN
      	 CONTINUE FOR
      END IF
      
      IF (li_cmd_count > 0) THEN ##目錄層         
         LET l_menu.name = la_zm[li_i].zm04 CLIPPED
         LET l_menu.text = ls_text
         LET l_menu.url  = ""
         CALL aws_ttsrv_buildMenuRecord(p_parent,base.TypeInfo.create(l_menu)) RETURNING lnode_child       
         CALL aws_create_menu_tree(p_lang, lnode_child, la_zm[li_i].zm04,p_user)
      ELSE         
         LET l_menu.name = la_zm[li_i].zm04 CLIPPED
         LET l_menu.text = ls_text
         #LET l_menu.url  = "$TIPTOPMenuURL?Arg=&Arg=&Arg=$SOK&Arg=$CompanyCode&Arg=",la_zm[li_i].zm04   #FUN-B50017 mark
         LET l_menu.url  = "$TIPTOPMenuURL?Arg=", g_access.application CLIPPED, "&Arg=", g_access.application CLIPPED, "&Arg=$SOK&Arg=$CompanyCode&Arg=",la_zm[li_i].zm04   #FUN-B50017
         CALL aws_ttsrv_buildRecord(p_parent,base.TypeInfo.create(l_menu))         
      END IF        
   END FOR            
         
END FUNCTION
 
FUNCTION aws_ttsrv_buildMenuRecord(p_node, p_record)
    DEFINE p_node     om.DomNode,
           p_record   om.DomNode
    DEFINE l_list1    om.NodeList,
           l_list2    om.NodeList
    DEFINE l_node     om.DomNode,
           l_child    om.DomNode,
           l_record   om.DomNode,
           l_field    om.DomNode
    DEFINE l_i        INTEGER,
           l_j        INTEGER
    DEFINE l_name     STRING,
           l_value    STRING
 
 
    #--------------------------------------------------------------------------#
    # 輪詢 4GL service function 傳入的資料節點建立 Response XML 的資料         #
    #--------------------------------------------------------------------------#
    LET l_list1 = p_record.selectByTagName("Record")
    FOR l_i = 1 TO l_list1.getLength()
        LET l_record = l_list1.item(l_i)
        
        LET l_node = p_node.createChild("Record")        #於 <Master> / <Detail> / <Parameter>下建立 <Record> 節點
 
        LET l_list2 = l_record.selectbyTagName("Field")
        FOR l_j = 1 TO l_list2.getLength()
            INITIALIZE l_name TO NULL
            INITIALIZE l_value TO NULL
            LET l_field = l_list2.item(l_j)
            LET l_name = l_field.getAttribute("name")
            LET l_value = l_field.getAttribute("value")
            
            LET l_child = l_node.createChild("Field")    #於 <Record> 下建立 <Field> 節點            
            CALL l_child.setAttribute("name", l_name)
            CALL l_child.setAttribute("value", l_value)
        END FOR
        LET l_child = l_node.createChild("Items")    #於 <Record> 下建立 <Items> 節點 
        RETURN  l_child
    END FOR
END FUNCTION
 
FUNCTION aws_check_auth_menu(p_user,p_menu_id)  
  DEFINE p_user     LIKE zx_file.zx01
  DEFINE p_menu_id  LIKE zm_file.zm04  
  DEFINE l_zy02     LIKE type_file.chr1
  DEFINE l_sql      STRING 
 
  #---#FUN-A70141---start-----
  IF g_zx12 = 'N' THEN
     RETURN TRUE
  END IF
  #---#FUN-A70141---end------
     
  IF SQLCA.SQLCODE THEN
     LET g_status.code = SQLCA.SQLCODE
     LET g_status.sqlcode = SQLCA.SQLCODE
     RETURN
  END IF
  
  OPEN zy_curs USING p_menu_id,p_user,p_user
  FETCH zy_curs INTO l_zy02 
  CLOSE  zy_curs 
  
  IF l_zy02='Y' THEN
     RETURN TRUE
  ELSE
     #FUN-C40075 start
     OPEN zxw_curs USING p_user,p_menu_id
     FETCH zxw_curs INTO l_zy02
     CLOSE zxw_curs

     IF l_zy02 = 'Y' THEN
        RETURN TRUE
     ELSE
        RETURN FALSE
     END IF
     #FUN-C40075 end
  END IF
  
END FUNCTION
 
 
#FUN-880012 --end

#FUN-B20003---add----str---
#[
# Description....: 取得指定的 單頭 / 單身 節點中的欄位值
#                  並分辦出XML是否有包出,當欄位"有"包回傳"Y"
#                                              "無"      "N"
# Date & Author..: 2011/02/15 by Mandy
# Parameter......: p_node  - om.DomNode - 單頭 / 單身 節點
#                : p_name  - STRING     - 欄位名稱
# Return.........: l_value - STRING     - 欄位值
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_getRecordField2(p_node, p_name)
    DEFINE p_node    om.DomNode,
           p_name    STRING
    DEFINE l_value   STRING
    DEFINE l_list    om.NodeList
    DEFINE l_node    om.DomNode
        
    
    IF cl_null(p_name) THEN 
       RETURN NULL,"N"
    END IF
    
    #--------------------------------------------------------------------------#
    # 接著尋找是否為對應名稱的 <Field> 欄位                                    #
    #--------------------------------------------------------------------------#
    LET l_list = p_node.selectByPath("//Field[@name=\"" || p_name || "\"]")
    IF l_list.getLength() != 0 THEN   #找的到節點才取值
       LET l_node = l_list.item(1)
       LET l_value = l_node.getAttribute("value")
       RETURN l_value,"Y"
    END IF
    RETURN l_value,"N"
END FUNCTION
#FUN-B20003---add----end---

#FUN-CA0131 start
#[
# Description....: 於 Response XML 中加入單頭 Record (For 多單身Tree架構)
# Date & Author..: 2012/10/26 By Kevin
# Parameter......: 
#                : p_record   - DomNode    - 單頭 Record Dom Node
#                : p_name     - STRING     - 此筆單頭檔名稱(e.x. Table Name)
# Return.........: g_rec_node - om.DomNode - 此筆 Master 資料節點
# Memo...........:
# Modify.........:
#
#]

FUNCTION aws_ttsrv_addTreeMaster(p_record, p_name)
    DEFINE p_record   om.DomNode,
           p_name     STRING
    DEFINE l_node     om.DomNode


    WHENEVER ERROR CONTINUE

    IF p_record IS NULL THEN
       RETURN NULL
    END IF

    #FUN-D10038 start
    LET g_count = g_count + 1

    IF g_count = 1 THEN
       LET l_node = g_dnode.createChild("Master")          #於 <Document> 下建立 <Master> 節點
       LET g_master_node = l_node

       IF NOT cl_null(p_name) THEN
          CALL l_node.setAttribute("name", p_name)
          CALL l_node.setAttribute("node_id", g_count)
       END IF
    ELSE
       LET l_node = g_master_node.getLastChild()
       LET l_node = l_node.getParent()
    END IF
    #FUN-D10038 end

    CALL aws_ttsrv_buildRecord(l_node, p_record)       #依照傳入的資料新增一筆單頭資料

    RETURN g_rec_node                                  
END FUNCTION

#[
# Description....: 於 Response XML 中加入Detail (For 多單身Tree架構)
# Date & Author..: 2012/10/26 By Kevin
# Parameter......: p_node   - om.DomNode - 指定要加入的父節點
#                : p_record - DomNode    - 單身 Record Dom Node
#                : p_name   - STRING     - 此筆單身檔名稱(e.x. Table Name)
#                : p_level  - STRING     - 階層碼 (ex:如果是第二單身層則傳入2 )
#                : p_rec_n  - Integer    - 是否為第一筆
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_addTreeDetail(p_node, p_record, p_name , p_level ,p_rec_n )
    DEFINE p_node     om.DomNode,
           p_record   om.DomNode,
           p_name     STRING
    DEFINE l_node     om.DomNode
    DEFINE l_last     om.DomNode
    DEFINE p_level    STRING      #level id
    DEFINE l_node_id  STRING  
    DEFINE l_str      STRING
    DEFINE p_rec_n    LIKE type_file.num5


    IF p_node IS NULL OR p_record IS NULL THEN
       RETURN
    END IF

    LET l_node = p_node.getParent()                    #取得 <RecordSet> 父節點

    LET l_node_id = l_node.getAttribute("node_id")
    
    IF p_rec_n = 1 THEN                                #如果是第一筆
       LET l_node = p_node.createChild("Detail")       #於 <Record> 下建立 <Detail> 節點

       IF NOT cl_null(p_name) THEN
          CALL l_node.setAttribute("name", p_name)
          LET l_str = l_node_id , "_" , p_level CLIPPED
          CALL l_node.setAttribute("node_id", l_str )
       END IF
       CALL aws_ttsrv_buildRecord(l_node, p_record)    #新增單身資料
    ELSE
       LET l_last =  p_node.getLastChild()             
       CALL aws_ttsrv_buildRecord( l_last , p_record)  #append 單身資料
    END IF
   
    RETURN g_rec_node
END FUNCTION

#FUN-CA0131 end

#FUN-D10038 start
#[
# Description....: 取得 Request XML Tree 節點中的單身筆數個數
# Date & Author..: 2013/01/15 by Kevin
# Parameter......: p_node - om.DomNode - 目前處理的單頭節點
#                : p_name - STRING     - 單身名稱
# Return.........: l_cnt  - INTEGER    - 單身筆數
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_getTreeRecordLength(p_node, p_name)
    DEFINE p_node    om.DomNode,
           p_name    STRING
    DEFINE l_list    om.NodeList
    DEFINE l_cnt     INTEGER

    IF p_node IS NULL THEN
       RETURN 0
    END IF

    #--------------------------------------------------------------------------#
    # 搜尋 <Detail> 節點                                                       #
    #--------------------------------------------------------------------------#
    IF cl_null(p_name) THEN
       LET l_list = p_node.selectByPath("//Detail/Record")
    ELSE
       LET l_list = p_node.selectByPath("//Detail[@name=\"" || p_name || "\"]/Record")
    END IF

    LET l_cnt = l_list.getLength()
    RETURN l_cnt
END FUNCTION


#[
# Description....: 取得 Request XML 中指定的單身節點 Dom Node
# Date & Author..: 2013/01/15 by Kevin
# Parameter......: p_node - om.DomNode - 目前單檔資料節點
#                : p_i    - INTEGER    - 第 N 筆單身
#                : p_name - STRING     - 單身名稱
# Return.........: l_node - om.DomNode - 第 N 筆單身的 Dom Node
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_getTreeRecord(p_node, p_i, p_name)
    DEFINE p_node    om.DomNode,
           p_i       INTEGER,
           p_name    STRING
    DEFINE l_node1   om.DomNode,
           l_node2   om.DomNode
    DEFINE l_list    om.NodeList
    DEFINE l_i       INTEGER


    IF p_node IS NULL OR ( cl_null(p_i) OR p_i = 0 ) THEN
       RETURN NULL
    END IF

    IF cl_null(p_name) THEN
       LET l_list = p_node.selectByPath("//Detail/Record")
    ELSE
       LET l_list = p_node.selectByPath("//Detail[@name=\"" || p_name || "\"]/Record")
    END IF

    FOR l_i = 1 TO l_list.getLength()
        LET l_node2 = l_list.item(l_i)

        #----------------------------------------------------------------------#
        # 若搜尋的單身 <Record> 節點順序與呼叫時傳入的值相同時                 #
        #----------------------------------------------------------------------#
        IF l_i = p_i THEN
           EXIT FOR
        END IF
    END FOR

    RETURN l_node2

END FUNCTION

#[
# Description....: 取得 Request XML <Master> 節點中<Record>筆數
# Date & Author..: 2013/01/23 by Kevin
# Parameter......: p_name - STRING  - 單檔名稱
# Return.........: l_cnt  - INTEGER - 單檔筆數
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_getTreeMasterRecordLength(p_name)
    DEFINE p_name   STRING
    DEFINE l_list   om.NodeList
    DEFINE l_cnt    INTEGER

    #--------------------------------------------------------------------------#
    # 搜尋 <Document> 有多少筆對應的 <Master> 節點                             #
    #--------------------------------------------------------------------------#
    IF cl_null(p_name) THEN
       LET l_list = g_request_root.selectByPath("//Document/Master/Record")
    ELSE
       LET l_list = g_request_root.selectByPath("//Document/Master[@name=\"" || p_name || "\"]/Record")
    END IF

    LET l_cnt = l_list.getLength()
    RETURN l_cnt
END FUNCTION

FUNCTION aws_ttsrv_getTreeMasterRecord(p_i, p_name)
    DEFINE p_i      INTEGER,
           p_name   STRING
    DEFINE l_list   om.NodeList
    DEFINE l_i      INTEGER
    DEFINE l_node   om.DomNode


    IF cl_null(p_i) OR p_i = 0 THEN
       RETURN NULL
    END IF

    IF cl_null(p_name) THEN
       LET l_list = g_request_root.selectByPath("//Document/Master")
    ELSE
       LET l_list = g_request_root.selectByPath("//Document/Master[@name=\"" || p_name || "\"]/Record")
    END IF
    FOR l_i = 1 TO l_list.getLength()
        LET l_node = l_list.item(l_i)

        #----------------------------------------------------------------------#
        # 若搜尋的 <Master> 節點順序與呼叫時傳入的值相同時                     #
        #----------------------------------------------------------------------#
        IF l_i = p_i THEN
           LET l_node = l_node.getFirstChild()     #往下取得 <Record> 節點回傳
           IF l_node.getTagName() = "@chars" THEN  #需要特別判斷抓到的第一個子節點是否為 Text Node
              LET l_node = l_node.getNext()
           END IF
           EXIT FOR
        END IF
    END FOR

    LET l_node = l_node.getParent()
    RETURN l_node
END FUNCTION



