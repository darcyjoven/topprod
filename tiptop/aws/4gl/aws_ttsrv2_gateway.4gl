# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: aws_ttsrv_gateway.4gl                                               
# Descriptions...: TIPTOP 通用集成接口                                    
# Date & Author..: 2005/12/19 by Li Feng  #FUN-8A0122                                               
# Modify.........: No.FUN-930132 09/03/20 by Vicky (Portal職能別報表) GetReport 服務增加參數"CRtype"(取得報表型式)
# Modify.........: No.MOD-960008 09/06/01 by shengbb PDM bug
# Modify.........: No.FUN-980025 09/09/27 By dxfwo DB 切換
# Modify.........: No.FUN-9C0008 09/12/02 By alex 調整環境變量
# Modify.........: No.FUN-9C0073 10/01/11 By chenls 程序精簡
# Modify.........: No:FUN-A50022 10/05/10 By Jay 增加他系統代碼欄位wad06, wae14
# Modify.........: No:FUN-A60057 10/06/18 By Jay 增加GetReport Condition條件參數傳遞 
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-B90032 11/09/05 By minpp 程序撰写规范修改
IMPORT com 
IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl" #TIPTOP Service Gateway 使用的全域變數檔
 
DEFINE g_logtime     STRING            #用作臨時文件中的時間部分                       
DEFINE g_ze          RECORD LIKE  ze_file.* 
DEFINE g_fieldlist   STRING            #MOD-960008
 
#服務入口函數，解析傳入字符串中的全局參數
FUNCTION aws_ttsrv2_GateWay()
DEFINE 
    tmpXmlFile  STRING,
    tmp_File    STRING,    #add by binbin080723
    svName      STRING,
    l_i,l_j     LIKE type_file.num5,
    doc         om.DomDocument,
    nRoot       om.DomNode,
    node1       om.DomNode,
    nService    om.DomNode,
    nParam      om.DomNode,
    nValue      om.DomNode,
    l_begin     LIKE type_file.num5,   
    l_end       LIKE type_file.num5,  
    LstNode     om.NodeList,
    l_Format    STRING,
    l_address   STRING,
    l_DataStr   STRING,
    l_ServiceID STRING,
    l_TagType   STRING,
    flag_file   STRING,
    l_result    STRING,
    l_ch        base.Channel,
    sortNode    om.NodeList,
    sortdom     om.DomNode,
    sorttype    STRING,
    l_cmd       STRING,
    l_cmd_bin   STRING,              #add by binbin080723
    l_lang      STRING,              #FUN-930132 add
    l_db        LIKE azp_file.azp01  #FUN-930132 add
    
 
  LET g_logtime = YEAR(CURRENT) USING "####", MONTH(CURRENT) USING "&&",DAY(CURRENT) USING "&&","-", TIME(CURRENT)
 
  LET tmpXmlFile = "g_request_",g_logtime,".xml"                            #FUN-9C0008
  LET tmpXmlFile = os.Path.join(FGL_GETENV('TEMPDIR'),tmpXmlFile CLIPPED)

 
  LET doc = om.DomDocument.createFromString(g_request.request)
  IF doc IS NULL THEN
     RUN "echo '"||g_request.request||"' > "||tmpXmlFile      #FUN-930132
     LET g_response.response = '<STD_OUT origin="TIPTOP">\n','<Service>\n',
       '<Status>Request is not a valid XML document!</Status>\n','<OperDate>',g_logtime,
       '</OperDate>\n','</Service>\n','</STD_OUT>\n'
  ELSE  
     LET nRoot = doc.getDocumentElement()   #根節點
     CALL nRoot.writeXml( tmpXmlFile )
                        
     #3.1版集成接口功能新增，新接口規范中根節點標簽為STD_IN/STD_OUT，而舊規范中標簽為
     #TTP_IN/TTP_OUT，這里為了兼容舊規范，特記下傳入的標簽種類，如果是TTP_IN那么返回的仍是
     #TTP_OUT，否則為STD_OUT
     LET l_TagType = nRoot.getTagName()
 
     #抓取xml全局參數
     #使用下面方法的目的是找到全局性質的變量(因為每個Service內也可能有相同的標簽)
     LET LstNode = nRoot.selectByTagName("ObjectID")
     FOR l_i =1 TO LstNode.getLength()    
       LET node1 = LstNode.item(l_i)  
       IF node1.getParent() = nRoot THEN    
          LET node1 = node1.getFirstChild() 
          LET g_ObjectID = node1.getAttributeValue(1)   
       END IF 
     END FOR
 
     LET LstNode = nRoot.selectByTagName("Separator")
     FOR l_i =1 TO LstNode.getLength()    
       LET node1 = LstNode.item(l_i)  
       IF node1.getParent() = nRoot THEN    
          LET node1 = node1.getFirstChild() 
          LET g_Separator = node1.getAttributeValue(1)   
       END IF 
     END FOR
     IF cl_null(g_Separator) THEN
        LET g_Separator = "^*^"
     END IF
 
     LET LstNode = nRoot.selectByTagName("Lang")
     FOR l_i =1 TO LstNode.getLength()    
       LET node1 = LstNode.item(l_i)  
       IF node1.getParent() = nRoot THEN    
          LET node1 = node1.getFirstChild() 
          LET l_lang = node1.getAttributeValue(1)   #FUN-930132
       END IF 
     END FOR
     #--FUN-930132--start--
     IF cl_null(l_lang) THEN
        LET l_lang = "en_us"
     END IF
     CALL aws_ttsrv_setLanguage(l_lang)
     #--FUN-930132--end--
 
     LET LstNode = nRoot.selectByTagName("IgnoreError")
     FOR l_i =1 TO LstNode.getLength()    
       LET node1 = LstNode.item(l_i)  
       IF node1.getParent() = nRoot THEN    
          LET node1 = node1.getFirstChild() 
          LET g_IgnoreError = node1.getAttributeValue(1)   
       END IF 
     END FOR
     IF cl_null(g_IgnoreError) THEN
        LET g_IgnoreError = "Y"
     END IF
 
     LET LstNode = nRoot.selectByTagName("Factory")
     FOR l_i =1 TO LstNode.getLength()    
       LET node1 = LstNode.item(l_i)  
       IF node1.getParent() = nRoot THEN    
          LET node1 = node1.getFirstChild() 
          LET g_Factory = node1.getAttributeValue(1)   
       END IF 
     END FOR
     #--FUN-930132-start--
     IF cl_null(g_Factory) THEN 
        SELECT azp01 INTO l_db FROM azp_file WHERE azp03='ds'
        LET g_Factory = l_db
     END IF
     LET g_plant = g_Factory
     #--FUN-930132-end--
 
     LET LstNode = nRoot.selectByTagName("DateFormat")
     FOR l_i =1 TO LstNode.getLength()    
       LET node1 = LstNode.item(l_i)  
       IF node1.getParent() = nRoot THEN    
          LET node1 = node1.getFirstChild() 
          LET g_DateFormat = node1.getAttributeValue(1)   
       END IF 
     END FOR
     IF cl_null(g_DateFormat) THEN
        LET g_DateFormat = "YYYY-MM-DD HH24:MI:SS"
     END IF
 
     LET LstNode = nRoot.selectByTagName("User")
     FOR l_i =1 TO LstNode.getLength()    
       LET node1 = LstNode.item(l_i)  
       IF node1.getParent() = nRoot THEN    
          LET node1 = node1.getFirstChild() 
          LET g_user = node1.getAttributeValue(1)   
          IF cl_null(g_user) THEN     #FUN-930132
             LET g_user = 'tiptop'
          END IF 
       END IF 
     END FOR
 
     #合成傳出參數的開始部分
     #3.1版本新增的規范并兼容舊規范
     IF l_TagType = 'TTP_IN' THEN 
        LET g_response.response = '<TTP_OUT>\n'
     ELSE 
        LET g_response.response = '<STD_OUT origin="TIPTOP">\n'
     END IF 
  
     LET l_ServiceID = ''
  
     LET LstNode = nRoot.selectByTagName("Service")
 
     #循環本次<STD_IN>中包含的每一個Service
     FOR l_i=1 TO LstNode.getLength()
       LET nService =  LstNode.item(l_i)             #Service節點
       LET svName = nService.getAttribute("Name")
       CALL SParam.clear()
 
       #循環當前Service中的每一個參數并填充到全局變量SParam中
       LET nParam = nService.getFirstChild()
       FOR l_j=1 TO nService.getChildCount()
           LET SParam[l_j].Tag = nParam.getTagName()
           #如果讀到了Data標簽，則對數據進行分析
           IF SParam[l_j].Tag = "Data" THEN
              #得到Data標簽的Format屬性
              LET l_address = nParam.getAttribute("Address") 
              LET l_Format = nParam.getAttribute("Format")

              #將整個Data標簽保存到xml中(注意這樣可以保証保存的是當前Service內包含的Data信息)   #FUN-9C0008
              LET tmpXmlFile = "ttp_svr_recvdata_",g_logtime,".xml"
              LET tmpXmlFile = os.Path.join(FGL_GETENV('TEMPDIR'),tmpXmlFile CLIPPED)
              LET tmp_File = "ttp_svr_recvdata_",g_logtime,".tmp"
              LET tmp_File = os.Path.join(FGL_GETENV('TEMPDIR'),tmp_File CLIPPED)
 
              IF NOT cl_null(l_address) THEN
                 LET l_cmd="export FGLGUI=1;export FGLSERVER=192.168.100.80;$FGLRUN $AWSi/aws_gfile ",l_address," ",tmpXmlFile
                 RUN l_cmd
              ELSE  
                 CALL nParam.writeXml(tmpXmlFile)
              END IF 
 
   
              #CALL nParam.writeXml(tmpXmlFile)
              #將該Data參數的Value值設置為文件名
              LET SParam[l_j].Value = tmpXmlFile
#             #同時將Format作為第nService.getChildCount + 1個參數 ( 在SetData函數里面用到 )
 
           #如果讀到了Condition標簽，則對數據進行分析
           ELSE 
              IF SParam[l_j].Tag = "Condition" THEN
                 #將整個Condition標簽保存到xml中(注意這樣可以保証保存的是當前Service內包含的Condition信息)
                 LET tmpXmlFile = "ttp_svr_recvcond_",g_logtime,".xml"     #FUN-9C0008
                 LET tmpXmlFile = os.Path.join(FGL_GETENV('TEMPDIR'),tmpXmlFile CLIPPED)
                 CALL nParam.writeXml(tmpXmlFile)
                 #將該Condition參數的Value值設置為文件名
                 LET SParam[l_j].Value = tmpXmlFile
              ELSE
                 LET nValue = nParam.getFirstChild()
                 #--FUN-930132--start-- 
                 IF nValue IS NOT NULL THEN
                    #如果得到ServiceId，則保存一個在變量中用于原樣返回
                    IF SParam[l_j].Tag = "ServiceId" THEN 
                       LET l_ServiceID = nValue.getAttributeValue(1)
                    END IF 
                    #得到該標簽的值(Value)
                    LET SParam[l_j].Value = nValue.getAttributeValue(1) 
                    IF SParam[l_j].Tag = "Lang" THEN
                       LET l_lang = nValue.getAttributeValue(1)
                       CALL aws_ttsrv_setLanguage(l_lang)
                    END IF
                 END IF
                 IF SParam[l_j].Tag ="Sort" THEN
                    LET sortNode = nRoot.selectByTagName("Sort")
                    LET sortdom =  sortNode.item(1)
                    LET sorttype = sortdom.getAttribute("Type")
                    LET SParam[l_j].attribute=sorttype
                 END IF 
                 #--FUN-930132--end--
              END IF
           END IF 
           LET nParam = nParam.getNext()
       END FOR

       RUN "echo 'bbbb' > "|| os.Path.join(FGL_GETENV("TEMPDIR"),"cz.txt" )   #FUN-9C0008
       CALL DispatchService(svName, SParam, l_ServiceId)
       #清空中間變量，免得和下個Service混淆
       LET l_ServiceId = ''
     END FOR
  
     #合成傳出參數的結尾部分(各個Service的返回值在DispatchService里面填充完畢了)
     IF l_TagType = 'TTP_IN' THEN 
        LET g_response.response = g_response.response || "</TTP_OUT>\n"
     ELSE 
        LET g_response.response = g_response.response || "</STD_OUT>\n"
     END IF 
  
  END IF

  LET l_cmd = "g_response_",g_logtime CLIPPED,".xml"    #FUN-9C0008
  RUN "echo \'"||g_response.response||"\' > "|| os.Path.join(FGL_GETENV('TEMPDIR'),l_cmd CLIPPED)
  
  #這兩句話是測試用的
  
END FUNCTION       
  
   
#按照傳入的服務名稱來調用對應的服務函數
FUNCTION DispatchService(p_name,p_Param,p_ServiceID)
DEFINE 
  p_name      STRING,
  p_Param     DYNAMIC ARRAY OF RECORD   
    Tag       STRING,  
    Attribute STRING,    
    Value     STRING  
  END RECORD,
  p_ServiceID STRING,
  l_errCode   STRING,
  l_errDesc   STRING,
  l_dataDesc  STRING,
  l_Out       base.stringBuffer
  
  #初始化返回狀態碼
  LET l_errCode = ''
  LET l_errDesc = ''
  LET l_dataDesc = ''
  
  #初始化傳出字符串     
  LET l_Out = base.StringBuffer.create()
  CALL l_Out.append('<Service Name="'||p_name||'">\n')
  IF NOT cl_null(p_ServiceID) THEN 
     CALL l_Out.append('<ServiceId>'||p_ServiceID||'</ServiceId>\n')
  END IF 
 
  RUN "echo '1' > "|| os.Path.join(FGL_GETENV("TEMPDIR"),"a.txt" )   #test    #FUN-9C0008
  #根據服務名稱調用具體的服務函數
  CASE p_name
    WHEN "CheckConnection"  CALL Server_CheckConnection()
    WHEN "GetObjectList"    CALL Server_GetObjectList(p_Param) RETURNING l_errCode,l_errDesc,l_dataDesc
    WHEN "GetTemplate"      CALL Server_GetTemplate(p_Param) RETURNING l_errCode,l_errDesc,l_dataDesc
    WHEN "GetData"          CALL Server_GetData(p_Param) RETURNING l_errCode,l_errDesc,l_dataDesc
    WHEN "SetData"          CALL Server_SetData(p_Param) RETURNING l_errCode,l_errDesc
    WHEN "UpdateBOM"        CALL UpdateBOM(p_Param) RETURNING l_errCode,l_errDesc
    WHEN "GetReport"        CALL Server_GetReport(p_Param) RETURNING l_errCode,l_errDesc,l_dataDesc
    #新增的服務請在此增加
    #......
    
    OTHERWISE 
      LET l_errCode = 'aws-201'
      LET l_errDesc = cl_getmsg(l_errCode,g_lang)
      #LET l_errDesc = '無法識別的Service名稱'
  END CASE 
  
  #根據返回狀態碼合成Status部分
  IF NOT cl_null(l_errCode) THEN
     CALL l_Out.append("<Status>"||l_errCode||"</Status>\n")
  ELSE
     CALL l_Out.append("<Status>0</Status>\n")
  END IF
  #如果有數據信息則添加到返回值中
  IF NOT cl_null(l_dataDesc) THEN
     #對GetData和GetTemplate接口的返回值要特殊處理，因為不需要外層的Data標簽(它們有自己的Data標簽定義)
     IF ( p_name = 'GetData' )OR( p_name = 'GetTemplate' ) THEN
        IF NOT cl_null(l_dataDesc) THEN      
           CALL l_Out.append(l_dataDesc)
        END IF 
     ELSE 
        CALL l_Out.append("<Data>"||l_dataDesc||"</Data>\n")
     END IF 
  END IF 
  #如果有錯誤信息則添加到返回值中
  IF NOT cl_null(l_errDesc) THEN
     CALL l_Out.append("<Error>"||l_errDesc||"</Error>\n")
  END IF 
  
  CALL l_Out.append("<OperDate>"||g_logtime||"</OperDate>\n")   ##add by shine   070807
  
  CALL l_Out.append("</Service>\n")
  LET g_response.response = g_response.response || l_Out.toString()
END FUNCTION
 
#----------------------------------------Server端服務函數-----------------------------------------------
 
#檢查連接
FUNCTION Server_CheckConnection() 
  #什么都不干
END FUNCTION
 
#得到系統對象列表
FUNCTION Server_GetObjectList(p_Param)
DEFINE 
  l_obj    LIKE waa_file.waa01,  #對象標識
  l_name   LIKE waa_file.waa02,  #對象名稱    
  l_sep    STRING,               #分隔符
  l_first  LIKE type_file.num5,
  p_Param     DYNAMIC ARRAY OF RECORD   
    Tag       STRING,  
    Attribute STRING,    
    Value     STRING  
  END RECORD,
  l_Out   STRING
  
  #檢查一下在服務的私有參數列表中是否有分隔符的定義
  #如果沒有則使用全局的分隔符
  LET l_sep = FindValue("Separator",p_Param)
  IF cl_null(l_sep) THEN
     LET l_sep = g_Separator
  END IF
 
  #從waa_file中取得所有系統對象的定義信息并填充傳出字符串
  LET l_first = TRUE
  DECLARE c_obj CURSOR FROM "SELECT waa01,waa02 FROM waa_file"
  FOREACH c_obj INTO l_obj,l_name       
    IF cl_null(l_name) THEN
       LET l_name = "NULL"
    END IF
    IF l_first THEN        
       LET l_Out = l_obj || ':' || l_name
    ELSE
       LET l_Out = l_Out || l_sep || l_obj || ':' || l_name
    END IF                     
    LET l_first = FALSE          
  END FOREACH
  IF SQLCA.sqlcode THEN
     RETURN '-3','內部錯誤',''
  END IF
  RETURN '','',l_Out
END FUNCTION
 
#3.1版本新增,將選項列表信息由原來放在一個字段里改為現在放在一個單獨的表(wak_file)里面,
#所以用一個函數來從數據表中抓取所需的資料并合成GetTemplate需要的字符串
#返回規則，如果既有選項也有說明，則返回格式為︰“選項A:說明,選項B:說明,..."
#          如果只有選項，則返回格式為︰“選項A,選項B,..."
FUNCTION aws_GetOptionList(p_Object,p_Table,p_Field)
DEFINE
  p_Object LIKE wak_file.wak01,
  p_Table  LIKE wak_file.wak02,
  p_Field  LIKE wak_file.wak03,
  l_opt    LIKE wak_file.wak04,
  l_desc   LIKE wak_file.wak05,
  l_result STRING
  
  #選取指定欄位所屬的列表
  DECLARE c_option CURSOR FOR
    SELECT wak04,wak05 FROM wak_file WHERE wak01 = p_Object AND wak02 = p_Table 
    AND wak03 = p_Field ORDER BY wak04
 
  LET l_result = ''
  
  #將各行記錄拼成一個字符串      
  FOREACH c_option INTO l_opt,l_desc
    IF cl_null(l_result) THEN 
       IF cl_null(l_desc) THEN 
          LET l_result = l_opt CLIPPED
       ELSE 
       	  LET l_result = l_opt CLIPPED,':',l_desc CLIPPED
       END IF    
    ELSE 
       IF cl_null(l_desc) THEN 
          LET l_result = l_result,',',l_opt CLIPPED 
       ELSE 
       	  LET l_result = l_result,',',l_opt CLIPPED,':',l_desc CLIPPED
       END IF 
    END IF    
  END FOREACH
  
  RETURN l_result
END FUNCTION 
 
#得到指定對象的定義信息
FUNCTION Server_GetTemplate(p_Param)
DEFINE 
  l_id        LIKE waa_file.waa01,
  l_sep       STRING,
  g_waa       RECORD LIKE waa_file.*,    
  g_wac       RECORD LIKE wac_file.*,
  g_waa_t     RECORD LIKE waa_file.*,   
  g_wac_t     RECORD LIKE wac_file.*,
  l_line1     STRING,                
  l_line      STRING,
  p_Param     DYNAMIC ARRAY OF RECORD   
    Tag       STRING,  
    Attribute STRING,    
    Value     STRING  
  END RECORD,
  l_errCode   STRING,
  l_errDesc   STRING,
  l_dataDesc  STRING,
  l_sql       STRING     
  
 
  #檢查服務私有參數列表中是否包含ObjectID的定義
  #如果沒有則使用全局變量
  LET l_id = FindValue("ObjectID",p_Param)
  IF cl_null(l_id) THEN
     LET l_id = g_ObjectID
  END IF
 
  #檢查服務私有參數列表中是否包含Seperator的定義
  #如果沒有則使用全局變量
  LET l_sep = FindValue("Separator",p_Param)
  IF cl_null(l_sep) THEN
     LET l_sep = g_Separator
  END IF
 
  #檢查對象標識是否合法
  CALL CheckObjectID(l_id) RETURNING l_errCode,l_errDesc
  IF NOT cl_null(l_errCode) THEN
     RETURN l_errCode,l_errDesc,''
  END IF
 
  #根據對象標識取出系統中三個相關表waa_file,wab_file和wac_file中的值
  LET l_sql = "SELECT waa_file.*,wac_file.*",   
              "  FROM waa_file,wac_file",   
              " WHERE waa01 = '",l_id,"'",      
              "   AND waa01 = wac01",
              " ORDER BY waa01,wac03"   
  DECLARE c_info CURSOR FROM l_sql   
  INITIALIZE g_waa_t.* TO NULL   
     
  FOREACH c_info INTO g_waa.*,g_wac.*
    #輸出第一行Data標記         
    IF g_waa_t.waa01 IS NULL THEN       
       LET l_line = '<Object ID="',g_waa.waa01,'" Name="',g_waa.waa02,   
                    '" Desc="',g_waa.waa03,'" Insert="',g_waa.waa04,'" Edit="',g_waa.waa06,      
                    '" Delete="',g_waa.waa05,'" IsMultiChild="',g_waa.waa07,'">\n'
 
       LET l_dataDesc = l_dataDesc, l_line
    END IF  
  
    #關于取值列表的定義規則︰簡單的列表存放于wak_file中(需要進行Mapping），特殊的SQL列表存放于
    #wac_file.wac14中，在GetTemplate的時候首先檢查wac14,如果有內容則使用宏解析函數處理并得到列表
    #否則從wak_file中取得列表的定義
    IF NOT cl_null(g_wac.wac14) THEN
       LET g_wac.wac14 = aws_transMacroWords(g_wac.wac14)
    ELSE 
       #如果取值列表中沒有值，則從wak_file中來取對應的列表
       LET g_wac.wac14 = aws_GetOptionList(g_wac.wac01,g_wac.wac02,g_wac.wac03)
    END IF 
  
    #輸出<Col>標記   
    LET l_line = '<Property>',g_wac.wac04,l_sep,g_wac.wac05,l_sep,  
                 g_wac.wac03,l_sep,g_wac.wac06,l_sep,    
                 g_wac.wac07,l_sep,g_wac.wac09,l_sep,   
                 g_wac.wac11,l_sep,g_wac.wac10,l_sep,
                 g_wac.wac12,l_sep,g_wac.wac13,l_sep,
                 g_wac.wac14,l_sep,g_wac.wac15,'</Property>\n'     
    LET l_dataDesc = l_dataDesc, l_line
     
    LET g_waa_t.* = g_waa.*    
  END FOREACH  
  LET l_dataDesc = l_dataDesc, '</Object>\n'
 
  #執行成功，返回結果集
  RETURN '','',l_dataDesc
   
END FUNCTION       
       
#按對象從系統中獲取數據,本函數供服務端調用，根據傳入的請求字符串拆解出所需要的條件并調用
#傳入的標簽中FieldList為TIPTOP中發布的屬性列表而非欄位列表，需要做一個從屬性到欄位的映射
#傳入的Condition是一個標准條件XML子句,其定義是以服務器端屬性為基礎的,要根據其生成一個可執行
#的SQL條件子句(即以服務器端欄位為基礎的)
#另外,在Condition中出現的屬性,如果為日期型,則根據傳入的DateFormat參數來解析,如果沒有指定,
#則默認為Oracle默認的數據格式YYYY-MM-DD HH24:MI:SS
#底層函數aws_ReadData返回對應的XML數據集
FUNCTION Server_GetData(p_Param)
DEFINE 
  l_ObjectID   STRING,
  l_Separator  STRING,
  l_Factory    LIKE azp_file.azp01,
  l_db         LIKE azp_file.azp03,  
  l_User       STRING,
  l_PropList   STRING,
  l_FieldList  STRING,
  l_Condition  STRING,
  l_DateFormat STRING,   
  l_wac04      LIKE wac_file.wac04,    
  p_Param      DYNAMIC ARRAY OF RECORD   
    Tag        STRING,  
    Attribute  STRING,    
    Value      STRING  
  END RECORD,
  l_errCode    STRING,
  l_errDesc    STRING,
  l_dataDesc   STRING,
  l_sql        STRING,
  l_tempfile   STRING,
  i            LIKE type_file.num5,
  l_orderList  STRING,
  l_orderFieldList  STRING,
  l_type            STRING,
  l_strbuf          base.StringBuffer
 
  #檢查服務私有參數列表中是否包含ObjectId的定義
  #如果沒有則使用全局變量  
  LET l_ObjectID = FindValue("ObjectID",p_Param)
  IF cl_null(l_ObjectID) THEN
     LET l_ObjectID = g_ObjectID
  END IF
  IF cl_null(l_ObjectID) THEN
     LET l_errCode = 'aws-203'
     LET l_errDesc = cl_getmsg(l_errCode,g_lang)
     RETURN l_errCode,l_errDesc,''
  END IF
 
  #檢查服務私有參數列表中是否包含Seperator的定義
  #如果沒有則使用全局變量  
  LET l_Separator = FindValue("Separator",p_Param)
  IF cl_null(l_Separator) THEN
     LET l_Separator = g_Separator
  END IF
 
  #檢查服務私有參數列表中是否包含Factory的定義
  #如果沒有則使用全局變量  
  LET l_Factory = FindValue("Factory",p_Param)
  IF cl_null(l_Factory) THEN
     LET l_Factory = g_Factory
  END IF
  IF cl_null(l_Factory) THEN
     #RETURN 'aws-252','缺少Factory參數',''
     LET l_errCode = 'aws-252'
     LET l_errDesc = cl_getmsg(l_errCode,g_lang)
     RETURN l_errCode,l_errDesc,''
  END IF
  LET g_Factory = l_Factory
 
  #檢查服務私有參數列表中是否包含User的定義
  #如果沒有則使用全局變量  
  LET l_User = FindValue("User",p_Param)
  IF cl_null(l_User) THEN
     IF g_user = 'admin' THEN    
        LET g_user = 'tiptop'
     END IF 
     LET l_User = g_user
  END IF
  IF cl_null(l_User) THEN
     #RETURN 'aws-253','缺少User參數',''
     LET l_errCode = 'aws-253'
     LET l_errDesc = cl_getmsg(l_errCode,g_lang)
     RETURN l_errCode,l_errDesc,''
  END IF
  IF l_User = 'admin' THEN    
     LET l_User = 'tiptop'
  END IF 
  LET g_user = l_User   
  SELECT zx03 INTO g_grup FROM zx_file WHERE zx01 = g_user
 
  #檢查服務私有參數列表中是否包含DateFormat的定義
  #如果沒有則使用全局變量  
  LET l_DateFormat = FindValue("DateFormat",p_Param)
  IF cl_null(l_DateFormat) THEN
     LET l_DateFormat = g_DateFormat
  END IF
    
  #檢查指定用戶是否有權限操作該數據庫
  CALL aws_check_db_right(l_User,l_Factory) RETURNING l_errCode,l_errDesc
  IF NOT cl_null(l_errCode) THEN 
     RETURN l_errCode,l_errDesc,''
  END IF 
 
  #切換數據庫
  SELECT azp03 INTO l_db FROM azp_file WHERE
    azp01 = l_Factory
  IF l_db <> 'ds' THEN
     CALL cl_ins_del_sid(2,'') #FUN-980025
     CLOSE DATABASE
     DATABASE l_db
     CALL cl_ins_del_sid(1,l_Factory) #FUN-980025
     IF SQLCA.sqlcode THEN 
        #RETURN 'aws-257','切換數據庫發生錯誤',''
        LET l_errCode = 'aws-257'
        LET l_errDesc = cl_getmsg(l_errCode,g_lang)
        RETURN l_errCode,l_errDesc,''
     END IF 
  END IF 
  
  LET l_strbuf = base.StringBuffer.create()
  LET l_orderList = FindValue("Sort",p_Param)
  IF NOT cl_null(l_orderList) THEN 
     CALL aws_GetFieldByProperty(l_objectid,l_orderList,l_Separator) RETURNING l_errCode,l_errDesc,l_orderFieldList
     CALL l_strbuf.append(l_orderFieldList)
     CALL l_strbuf.replace(l_Separator,",",0)
     LET l_orderFieldList = l_strbuf.toString()
     IF NOT cl_null(l_errCode) THEN 
        RETURN l_errCode,l_errDesc,''
     END IF
  
     LET l_type = FindAttribute("Sort",p_Param)
  END IF 
    
  LET l_PropList = FindValue("PropertyList",p_Param)     #得到PropertyList參數
  IF cl_null(l_PropList) THEN
     LET l_PropList = '%'      #沒有PropertyList理解為所有欄位
  ELSE     #MOD-960008
     IF l_ObjectID="FACTORY" THEN
        LET g_fieldlist=l_PropList
     END IF
  END IF
  
  LET l_Condition = FindValue("Condition",p_Param)     #得到Condition參數  
  
  
  #檢查傳入對象標識是否合法
  CALL CheckObjectID(l_ObjectID) RETURNING l_errCode,l_errDesc
  IF NOT cl_null(l_errCode) THEN 
     RETURN l_errCode,l_errDesc,''
  END IF
  
  #如果PropList標簽傳入%，表示選取該對象所有的屬性
  IF l_PropList = "%" THEN
     LET l_PropList = NULL
     LET l_sql = " SELECT DISTINCT wac04 FROM wac_file ", 
                 "  WHERE wac01 = '",l_ObjectID,"'"
     DECLARE cur_prop CURSOR FROM l_sql
     LET i=1
     FOREACH cur_prop INTO l_wac04
       IF i=1 THEN
          LET l_PropList = l_PropList.append(l_wac04)
          LET i=2
       ELSE
          LET l_PropList = l_PropList.append(g_Separator||l_wac04)
       END IF
     END FOREACH 
  END IF 
  #根據屬性列表生成欄位列表
  CALL aws_GetFieldByProperty(l_objectid,l_PropList,l_Separator) RETURNING l_errCode,l_errDesc,l_FieldList
  IF NOT cl_null(l_errCode) THEN 
     RETURN l_errCode,l_errDesc,''
  END IF
 
  #根據傳入的XML格式Condition生成可執行的SQL子句
  CALL aws_GetConditionByXML(l_objectid,l_Condition,l_DateFormat,l_Separator) RETURNING l_errCode,l_errDesc,l_Condition
  IF NOT cl_null(l_errCode) THEN 
     RETURN l_errCode,l_errDesc,''
  END IF
  IF NOT cl_null(l_orderFieldList) THEN 
     LET l_Condition = l_condition," ORDER BY ",l_orderFieldList," ",l_type
  END IF 
  CALL aws_ReadData(l_ObjectID,l_PropList,l_FieldList,l_Condition,l_Separator,FALSE,'',l_dateformat) 
       RETURNING l_errCode,l_errDesc,l_DataDesc
  RETURN l_errCode,l_errDesc,l_DataDesc
  
END FUNCTION
 
#按對象更新系統數據
#目前支持以下四種更新操作
#INSERT 新增對象，如果要新增的對象主鍵已存在則返回錯誤
#DELETE 刪除對象
#UPDATE 更新對象，如果被更新對象不存在則不更新
#SYNC   同步對象，目標對象不存在則新增，存在則更新
FUNCTION Server_SetData(p_Param)
DEFINE 
  l_ObjectID       LIKE waa_file.waa01,
  l_Factory        LIKE azp_file.azp01,
  l_db             LIKE azp_file.azp03,
  l_User           STRING,
  i                LIKE type_file.num5,
  ch1              base.Channel,
  l_status         LIKE type_file.num5,
  l_errCode        STRING,
  l_errDesc        STRING,   #單條錯誤的描述信息
  l_errTot         STRING,   #當IgnoreError='Y'是所有的描述信息
  l_Ignore         STRING,
  l_waa04          LIKE waa_file.waa04,
  l_waa05          LIKE waa_file.waa05,
  l_waa06          LIKE waa_file.waa06,
  l_Sep            STRING,
  l_Operate        STRING,
  l_FieldList      STRING,
  l_DataList       STRING,
  p_Param          DYNAMIC ARRAY OF RECORD   
    Tag            STRING,  
    Attribute      STRING,    
    Value          STRING  
  END RECORD,     
  l_xmlFile        STRING,
  l_DateFormat     STRING
        
  #檢查服務私有參數列表中是否包含ObjectId的定義
  #如果沒有則使用全局變量  
  LET l_ObjectID = FindValue("ObjectID",p_Param)    
  IF cl_null(l_ObjectID) THEN             
     LET l_ObjectID = g_ObjectID         
  END IF                                
  IF cl_null(l_ObjectID) THEN
     #RETURN 'aws-203','缺少ObjectID參數'
     LET l_errCode = 'aws-203'
     LET l_errDesc = cl_getmsg(l_errCode,g_lang)
     RETURN l_errCode,l_errDesc
  END IF
 
  #檢查服務私有參數列表中是否包含Seperator的定義
  #如果沒有則使用全局變量  
  LET l_Sep = FindValue("Separator",p_Param) 
  IF cl_null(l_Sep) THEN    
     LET l_Sep = g_Separator    
  END IF 
 
  #檢查服務私有參數列表中是否包含IgnoreError的定義
  #如果沒有則使用全局變量  
  LET l_Ignore = FindValue("IgnoreError",p_Param) 
  IF cl_null(l_Ignore) THEN    
     LET l_Ignore = g_IgnoreError   
  END IF 
 
  #檢查服務私有參數列表中是否包含Factory的定義
  #如果沒有則使用全局變量  
  LET l_Factory = FindValue("Factory",p_Param)
  IF cl_null(l_Factory) THEN
     LET l_Factory = g_Factory
  END IF
  IF cl_null(l_Factory) THEN
     #RETURN 'aws-252','缺少Factory參數'
     LET l_errCode = 'aws-252'
     LET l_errDesc = cl_getmsg(l_errCode,g_lang)
     RETURN l_errCode,l_errDesc
  ELSE
     LET g_plant = l_Factory
  END IF
  LET g_Factory = l_Factory
 
  #檢查服務私有參數列表中是否包含DateFormat的定義
  #如果沒有則使用全局變量  
  LET l_DateFormat = FindValue("DateFormat",p_Param)
  IF cl_null(l_DateFormat) THEN
     LET l_DateFormat = g_DateFormat
  END IF
 
  #檢查服務私有參數列表中是否包含User的定義
  #如果沒有則使用全局變量  
  LET l_User = FindValue("User",p_Param)
  IF cl_null(l_User) THEN
     IF g_user = 'admin' THEN    
        LET g_user = 'tiptop'
     END IF 
     LET l_User = g_user
  END IF
  IF cl_null(l_User) THEN
     #RETURN 'aws-253','缺少User參數'
     LET l_errCode = 'aws-253'
     LET l_errDesc = cl_getmsg(l_errCode,g_lang)
     RETURN l_errCode,l_errDesc
  ELSE
     IF l_User = 'admin' THEN    
        LET l_User = 'tiptop'
     END IF 
     LET g_user = l_User   
     SELECT zx03 INTO g_grup FROM zx_file WHERE zx01=g_user
     LET g_today=TODAY
  END IF
 
  #檢查指定用戶是否有權限操作該數據庫
  CALL aws_check_db_right(l_User,l_Factory) RETURNING l_errCode,l_errDesc
  IF NOT cl_null(l_errCode) THEN 
     RETURN l_errCode,l_errDesc
  END IF 
    
  #切換數據庫
  SELECT azp03 INTO l_db FROM azp_file WHERE
    azp01 = l_Factory
  IF l_db <> 'ds' THEN
     CALL cl_ins_del_sid(2,'') #FUN-980025
     CLOSE DATABASE
     DATABASE l_db
     CALL cl_ins_del_sid(1,l_Factory) #FUN-980025
     IF SQLCA.sqlcode THEN 
        #RETURN 'aws-257','切換數據庫發生錯誤'
        LET l_errCode = 'aws-257'
        LET l_errDesc = cl_getmsg(l_errCode,g_lang)
        RETURN l_errCode,l_errDesc
     END IF 
  END IF     
    
  #獲得Operate操作類型參數
  LET l_Operate = FindValue("Operate",p_Param)
  IF cl_null(l_Operate) THEN 
     #RETURN 'aws-204','缺少Operate參數'
     LET l_errCode = 'aws-204'
     LET l_errDesc = cl_getmsg(l_errCode,g_lang)
     RETURN l_errCode,l_errDesc
  ELSE
     IF ( l_Operate <> 'INSERT' )AND( l_Operate <> 'DELETE' )AND
        ( l_Operate <> 'UPDATE' )AND( l_Operate <> 'SYNC' )AND
        ( l_Operate <> 'ADJUST' ) THEN
        #RETURN 'aws-205','無法識別的操作類型'
        LET l_errCode = 'aws-205'
        LET l_errDesc = cl_getmsg(l_errCode,g_lang)
        RETURN l_errCode,l_errDesc
     END IF
  END IF          
 
  #獲得Data參數(實際上是存放Data的XML文件名)
  LET l_xmlFile = FindValue("Data",p_Param)
  IF cl_null(l_xmlFile) THEN 
     #RETURN 'aws-206','缺少Data參數'
     LET l_errCode = 'aws-206'
     LET l_errDesc = cl_getmsg(l_errCode,g_lang)
     RETURN l_errCode,l_errDesc
  END IF 
  #檢查操作權限是否正確
  SELECT waa04,waa05,waa06 INTO l_waa04,l_waa05,l_waa06
    FROM waa_file
   WHERE waa01=l_ObjectID 
  IF SQLCA.sqlcode THEN
     #RETURN 'aws-111','ObjectId can not map from target system'
     LET l_errCode = 'aws-111'
     LET l_errDesc = cl_getmsg(l_errCode,g_lang)
     RETURN l_errCode,l_errDesc
  END IF
  IF l_Operate="INSERT" AND l_waa04="N" THEN  #waa04 該對象是否允許新增
     #RETURN 'aws-208','該對象不允許執行新增操作'
     LET l_errCode = 'aws-208'
     LET l_errDesc = cl_getmsg(l_errCode,g_lang)
     RETURN l_errCode,l_errDesc
  END IF
  IF l_Operate="DELETE" AND l_waa05="N" THEN  #waa05 該對象是否允許刪除
     #RETURN 'aws-209','該對象不允許執行刪除操作'
     LET l_errCode = 'aws-209'
     LET l_errDesc = cl_getmsg(l_errCode,g_lang)
     RETURN l_errCode,l_errDesc
  END IF    
  IF (( l_Operate="UPDATE" )OR( l_Operate="SYNC" )) AND l_waa06="N" THEN   #waa06 該對象是否允許更新
     #RETURN 'aws-210','該對象不允許執行更新操作'
     LET l_errCode = 'aws-210'
     LET l_errDesc = cl_getmsg(l_errCode,g_lang)
     RETURN l_errCode,l_errDesc
  END IF
  RUN "echo '2' > "|| os.Path.join(FGL_GETENV("TEMPDIR"), "b.txt" )        #test   #FUN-9C0008
  #調用標准寫函數將數據按照特定的要求更新回數據表中
  CALL aws_WriteData(l_ObjectID,l_xmlFile,l_Sep,l_Operate,l_Ignore,l_DateFormat) RETURNING l_errCode,l_errDesc
  
  RETURN l_errCode,l_errDesc
END FUNCTION
 
#-------------------------------------------Client端服務函數-----------------------------------------------
 
#從目標系統導入數據
#p_sysid為目標系統標識
#p_object為TIPTOP中定義的對象
#p_fieldlist為TIPTOP中的欄位列表
#p_condition為以TIPTOP欄位列表為基礎的條件式
#CALL aws_importData('CRM','BOM','bma01|bma02|bmb01','((bma01,IN,CK-101|CK-102|CK-103)AND(bma02,=,Y))'
#RETURNING l_errCode,l_errDesc
FUNCTION aws_importData(p_sysid,p_object,p_fieldlist,p_condition)
DEFINE
   p_sysid            LIKE wah_file.wah01,
   p_object           LIKE waa_file.waa01,
   l_targetobject     LIKE wah_file.wah02,
   p_fieldlist        STRING,
   l_fieldlist        STRING,
   l_proplist         STRING,
   l_tables           STRING,
   p_condition        STRING,
   l_errcode          STRING,
   l_errdesc          STRING,
   l_idx,l_idx2       LIKE type_file.num5,
   l_str              STRING,
   ls_xml             STRING,
   l_xmlfile          STRING,
   l_cmd              STRING,
   ls_xmlbuf          base.StringBuffer,
   l_dateformat       STRING
 
   WHENEVER ERROR CONTINUE
 
   LET l_dateformat = 'yyyy-mm-dd hh24:mi:ss'
 
   #要根據我們的對象映射一個對方的對象
   SELECT DISTINCT wah02 INTO l_targetobject FROM wah_file
    WHERE wah01 = p_sysid AND wah08 = p_object
   IF SQLCA.sqlcode THEN
      #RETURN 'aws-444','ObjectId can not map in target system'
      LET l_errCode = 'aws-444'
      LET l_errDesc = cl_getmsg(l_errCode,g_lang)
      RETURN l_errCode,l_errDesc
   END IF
 
  #如果沒有傳入字段列表選取該對象中所有能夠和目標系統中對應對象Mapping上的tiptop欄位作為字段列表
  #并同時返回對應的目標對象的屬性列表
  IF cl_null(p_fieldlist) THEN 
     #這里不傳日期格式表示不需要對字段列表中的日期型字段添加to_char包裝(因為后面要根據欄位名進行比對)
     CALL aws_GetAllMappingField(p_sysid,p_object,g_Separator) RETURNING l_errCode,l_errDesc,p_fieldlist,l_proplist
     IF NOT cl_null(l_errCode) THEN 
        RETURN l_errCode,l_errDesc
     END IF
  END IF 
  
  #如果對方屬性列表為空（只有當用戶傳入了欄位列表的時候才可能出現這樣的情況）
  #則將tiptop的字段列表轉換為目標對象中的屬性列表
  IF cl_null(l_proplist) THEN 
     CALL aws_FieldToProperty(p_sysid,p_object,p_fieldlist) RETURNING l_errCode,l_errDesc,l_proplist
     IF NOT cl_null(l_errCode) THEN 
        RETURN l_errCode,l_errDesc
     END IF
  END IF 
  
  #g根據傳入參數解析出Condition標准XML串
  CALL aws_GetXMLByCondition(p_sysid,p_object,p_condition,g_Separator) RETURNING l_errCode,l_errDesc,p_condition
  IF NOT cl_null(l_errCode) THEN 
     RETURN l_errCode,l_errDesc
  END IF
  
  # 組xml字符串并發送
  LET ls_xml = '<STD_IN Origin="TIPTOP">\n',
               '  <Service Name="GetData">\n',
               '    <ObjectID>',l_targetobject,'</ObjectID>\n',
               '    <PropertyList>',l_proplist,'</PropertyList>\n',
               '    <DateFormat>',l_dateformat,'</DateFormat>\n',
               p_condition,
               '    <Format>Join</Format>\n',
               '    <ServiceId>TIPTOP</ServiceId>\n',
               '    <Seperator>',g_Separator,'</Seperator>\n',
               '    <User>',g_user,'</User>\n',
               '    <Factory>Unknown</Factory>\n',
               '  </Service>\n',
               '</STD_IN>'
 
   # 調用服務端請求
###   CALL GateWay(p_sysid,ls_xml) RETURNING l_errcode,l_errdesc,ls_xml
   IF l_errCode THEN
      RETURN l_errcode,l_errdesc
   END IF
 
   #分析一下返回的字符串，看看是成功了還是失敗了
   CALL aws_AnalyzeOutput(ls_xml) RETURNING l_errCode,l_errDesc
   IF NOT cl_null(l_errCode) THEN
      RETURN l_errcode,l_errdesc
   END IF
   
   #從返回值中拆解出Data域
   LET l_idx = ls_xml.getIndexOf('<Data',1)
   LET l_idx2 = ls_xml.getIndexOf('</Data>',1)
   LET ls_xml = ls_xml.subString(l_idx,l_idx2+6)
   
   LET ls_xmlbuf = base.StringBuffer.create()
   CALL ls_xmlbuf.append(ls_xml)
   # 查Status
   LET l_idx = 1
   # 替換Fieldlist
   LET l_idx = ls_xmlbuf.getIndexOf("<DataSet",l_idx)
   LET l_idx = ls_xmlbuf.getIndexOf("Field",l_idx)
   LET l_idx = ls_xmlbuf.getIndexOf('"',l_idx)
   LET l_idx2 = ls_xmlbuf.getIndexOf('"',l_idx+1)
   LET l_fieldlist = ls_xmlbuf.subString(l_idx+1, l_idx2-1)
   CALL aws_MappingFieldFromTarget(p_sysid,l_targetobject,l_fieldlist,g_Separator)
     RETURNING l_errcode,l_errdesc,l_str
   IF NOT cl_null(l_errCode) THEN
      RETURN l_errcode,l_errdesc
   END IF    
   CALL ls_xmlbuf.replaceAt(l_idx+1,l_idx2-l_idx-1,l_str)
   # 開始值替換
   WHILE TRUE
     LET l_idx = ls_xmlbuf.getIndexOf("<Row",l_idx) 
     IF l_idx = 0 THEN
        EXIT WHILE
     END IF
     LET l_idx = ls_xmlbuf.getIndexOf("Data",l_idx) 
     LET l_idx = ls_xmlbuf.getIndexOf('"',l_idx)
     LET l_idx2 = ls_xmlbuf.getIndexOf('"',l_idx+1)
     LET l_str = ls_xmlbuf.subString(l_idx+1, l_idx2-1)
     CALL aws_MappingValueFromTarget(p_sysid,l_targetobject,l_fieldlist,l_str,g_Separator)     
        RETURNING l_errcode,l_errdesc,l_str
     IF NOT cl_null(l_errCode) THEN
        RETURN l_errcode,l_errdesc
     END IF
 
     CALL ls_xmlbuf.replaceAt(l_idx+1,l_idx2-l_idx-1,l_str)
   END WHILE
 
   LET l_XmlFile = "ttp_clt_recdata_",g_logtime,".xml"
   LET l_XmlFile = os.Path.join(FGL_GETENV('TEMPDIR'), l_XmlFile CLIPPED)  #FUN-9C0008
   LET l_cmd = "echo '",ls_xmlbuf.toString(),"' > ",l_xmlFile
   RUN l_cmd
        
   #Import進來的數據默認會被ADJUST到數據庫中
   CALL aws_WriteData(p_object,l_xmlFile,g_Separator,'ADJUST','N',l_dateformat) RETURNING l_errCode,l_errDesc
   RETURN l_errCode,l_errDesc
END FUNCTION
 
#本函數用于從TIPTOP中選取符合要求的對象記錄并將其發送給目標系統，其中的所有參數均為TIPTOP變量
#對于對象的選取是基于該對象所有能夠與目標系統Mapping上的記錄進行的，不允許只選取部分欄位
#本函數調用底層函數aws_ReadData完成取數據的工作，傳出的是一個Join格式的數據集
#本函數還要將其進行欄位名和選項值的映射，使之成為服務端可以識別的Join格式
FUNCTION aws_exportData(p_sysid,p_objectid,p_field,p_operate,p_condition)
DEFINE
  p_sysid                       LIKE wah_file.wah01,
  p_objectid                    LIKE wah_file.wah08,    #TIPTOP中的對象
  p_field                       STRING,
  p_condition                   STRING,
  p_operate                     STRING,
  l_targetobject                LIKE wah_file.wah02,    #目標系統中的對象
  l_errCode,l_errDesc           STRING,
  l_tables,l_DataDesc,l_xml     STRING,
  l_tempfile,l_temp             STRING,
  l_ttpField,l_tgtProp          STRING,
  l_ttpValue,l_tgtValue         STRING,
  soapStatus                    LIKE type_file.num5,
  soapDesc,l_output             STRING,
  l_dateformat                  STRING
 
  WHENEVER ERROR CONTINUE
 
  LET l_dateformat = 'yyyy-mm-dd hh24:mi:ss'
 
  #首先根據我們的對象取得對方系統中的對象ID
  SELECT wah02 INTO l_targetobject FROM wah_file 
    WHERE wah01 = p_sysid AND wah08 = p_objectid
  IF cl_null(l_targetobject) THEN 
     #RETURN 'aws-445','無法找到對應的目標系統對象'
     LET l_errCode = 'aws-445'
     LET l_errDesc = cl_getmsg(l_errCode,g_lang)
     RETURN l_errCode,l_errDesc
  END IF 
  
  #如果沒有傳入字段列表則選取該對象中所有能夠和目標系統中對應對象Mapping上的TIPTOP欄位以及對應的屬性欄位
  #這里注意︰相同含義的字段(比如bma01,bmb01,bmc01)將只取其一
  IF cl_null(p_field) THEN 
     CALL aws_GetAllMappingField(p_sysid,p_objectid,g_Separator) RETURNING l_errCode,l_errDesc,p_field,l_tgtProp
     IF NOT cl_null(l_errCode) THEN 
        RETURN l_errCode,l_errDesc
     END IF
  END IF
 
  #如果對方屬性列表為空（只有當用戶傳入了欄位列表的時候才可能出現這樣的情況）
  #則將tiptop的字段列表轉換為目標對象中的屬性列表
  IF cl_null(l_tgtProp) THEN 
     CALL aws_FieldToProperty(p_sysid,p_objectid,p_field) RETURNING l_errCode,l_errDesc,l_tgtProp
     IF NOT cl_null(l_errCode) THEN 
        RETURN l_errCode,l_errDesc
     END IF
  END IF 
     
  #調用底層函數讀取數據
  CALL aws_ReadData(p_objectid,l_tgtProp,p_field,p_condition,g_Separator,TRUE,p_sysid,l_dateformat)
       RETURNING l_errCode,l_errDesc,l_DataDesc
 
  #合成一個SetData字符串
  IF cl_null(g_user) THEN 
     LET g_user = 'default' 
  END IF 
  LET l_xml = '<STD_IN Origin="TIPTOP">\n',
              '  <Service Name="SetData">\n',
              '    <ObjectID>',l_targetobject CLIPPED,'</ObjectID>\n',
              '    <ServiceId>TIPTOP</ServiceId>\n',
              '    <Operate>',p_operate,'</Operate>\n',
              '    <Seperator>',g_Separator,'</Seperator>\n',
              '    <User>',g_user,'</User>\n',
              '    <Factory>Unknown</Factory>\n',
              '    <IgnoreError>N</IgnoreError>\n',
              l_DataDesc,
              '  </Service>\n',
              '</STD_IN>'
              
  #調用GateWay發送Web Service請求并接收操作結果
###  CALL GateWay(p_sysid,l_xml) RETURNING soapStatus,soapDesc,l_output
  #如果SOAP操作正確則分析返回的字符串，看看是不是操作成功了
  IF soapStatus = 0 THEN
     #分析一下返回的字符串，看看是成功了還是失敗了
     CALL aws_AnalyzeOutput(l_output) RETURNING l_errCode,l_errDesc
     RETURN l_errCode,l_errDesc
  ELSE 
     RETURN soapStatus,soapDesc 
  END IF                
  
END FUNCTION   
  
#-------------------------------------------數據讀寫引擎------------------------------------------------------  
  
#系統底層函數，可供服務方GetData調用和客戶方exportData調用，用于從TIPTOP系統中選取指定的數據
#并組成一個標准格式的XML數據集字符串
#p_objectid為TIPTOP系統中定義的對象ID
#p_PropList為屬性列表，可能是TIPTOP系統中的屬性列表，也可能是目標系統中的屬性列表，該參數只作Join格式的Field顯示用
#p_FieldList為欄位列表，是TIPTOP中的欄位，本函數將選取這些欄位來合并數據集
#p_Condition為條件列表，是已經翻譯為以TIPTOP欄位為基礎的SQL條件子句
#p_sep為標准分隔符
#p_mapping表示是否需要對值進行映射
#p_sysid表示目標系統標識，如果前面p_mapping選擇False，那么這個參數可以傳入一個空值
#p_dateformat表示日期格式
FUNCTION aws_ReadData(p_objectid,p_PropList,p_FieldList,p_Condition,p_sep,p_mapping,p_sysid,p_dateformat)
DEFINE 
  p_objectid    LIKE waa_file.waa01,
  p_PropList    STRING,
  p_FieldList   STRING,
  p_Condition   STRING,  
  p_sep         STRING,
  p_mapping     LIKE type_file.num5,
  p_sysid       LIKE wag_file.wag01,
  p_dateformat  STRING,
  l_tables      STRING,
  l_tmp         STRING,
  l_first       LIKE type_file.num5,
  i,j           LIKE type_file.num5,   
  l_data        LIKE type_file.chr1000,
  l_wab07       LIKE wab_file.wab07,    
  l_table       DYNAMIC ARRAY OF STRING,   
  l_TableList   base.StringTokenizer,    
  l_tok         base.StringTokenizer,
  l_fields      base.StringBuffer,
  l_errCode     STRING,
  l_errDesc     STRING,
  l_dataDesc    STRING,
  l_sql         STRING,
  l_temp        STRING,
  l_wac03       LIKE wac_file.wac03,
  l_wac06       LIKE wac_file.wac06,
  l_fieldlist   STRING,
  l_i           LIKE type_file.num5 
  DEFINE arr_test DYNAMIC ARRAY OF STRING
  DEFINE arr_tt   DYNAMIC ARRAY OF STRING
  DEFINE arr_wac03 DYNAMIC ARRAY OF STRING
  
  #根據欄位列表生成其所屬的表列表
  CALL aws_GetTablesByFields(p_objectid,p_FieldList,p_sep) RETURNING l_errCode,l_errDesc,l_tables
  IF NOT cl_null(l_errCode) THEN 
     RETURN l_errCode,l_errDesc,''
  END IF
  
  #需要抓取多個表的數據的時候，去抓取多個表之間的關系
  LET l_TableList = base.StringTokenizer.createExt(l_tables,',','',TRUE)
  IF l_TableList.countTokens() != 1 THEN
     LET i=1
     WHILE l_TableList.hasMoreTokens()
       LET l_table[i] = l_TableList.nextToken()
       LET i=i+1
     END WHILE
     LET i = i-1
     LET l_sql = "SELECT wab07 FROM wab_file ",
                 " WHERE wab01 ='",p_objectid,"'",
                 " AND wab02 IN ('"
     FOR j = 1 TO i
       IF j = i THEN
          LET l_sql = l_sql,l_table[j],"') AND wab05 IN ('"
       ELSE
          LET l_sql = l_sql,l_table[j],"','"
       END IF
     END FOR
     FOR j=1 TO i
       IF j=i THEN
          LET l_sql = l_sql,l_table[j],"')"
       ELSE
          LET l_sql = l_sql,l_table[j],"','"
       END IF
     END FOR
     DECLARE l_wab07 CURSOR FROM l_sql
     FOREACH l_wab07 INTO l_wab07
       IF cl_null(p_Condition) THEN
          LET p_Condition = p_Condition.append(l_wab07)
       ELSE
           LET p_Condition = l_wab07," AND ",p_Condition   ###modify by shine
       END IF
     END FOREACH
  END IF
 
  #為了能直接從SQL結果中得到符合要求的'xxx|xxxx|xxx'型數據，先對
  #l_fields進行一下處理，將SQL語句整理成SELECT field1||"|"||field2這樣的形式                
  #同時整理一下p_FieldList,把其中的日期型欄位整理成to_char這樣的格式
  LET l_fieldlist = ''
   CALL aws_Tokenizer(p_FieldList,p_sep,arr_wac03)
   FOR l_i = 1 TO arr_wac03.getLength()
       LET l_wac03 = arr_wac03[l_i]
    SELECT wac06 INTO l_wac06 FROM wac_file 
      WHERE wac01 = p_objectid AND wac03 = l_wac03
  
    IF l_wac06 = 'D' THEN 
       IF cl_null(l_fieldlist) THEN 
          #LET l_fieldlist = "to_char(",l_wac03 CLIPPED,",'",p_dateformat,"')"
       ELSE 
          #LET l_fieldlist = l_fieldlist,"||'",p_sep,"'||","to_char(",l_wac03 CLIPPED,",'",p_dateformat,"')"
       END IF 
    ELSE 
       IF cl_null(l_fieldlist) THEN 
          LET l_fieldlist = l_wac03 CLIPPED
       ELSE 
          LET l_fieldlist = l_fieldlist,"||'",p_sep,"'||",l_wac03 CLIPPED
       END IF        
    END IF 
  END FOR 
  IF p_objectid="FACTORY" THEN   #MOD-960008
     LET l_fieldlist = g_fieldlist
     LET p_PropList = g_fieldlist
  END IF 
  #合成查詢數據使用的SQL語句
  LET l_sql = "SELECT ",l_fieldlist," FROM ",l_tables
  
  IF NOT cl_null(p_Condition) THEN
     LET l_sql = l_sql," WHERE ",p_Condition
  END IF          
              
  #SQL查詢的結果是一個Join格式的數據集
  Let l_first = TRUE           
  DECLARE c_data CURSOR FROM l_sql   
  FOREACH c_data INTO l_data        
    #根據XML標准，對數據中包含的XML保留字進行替換，以保証調用方能夠正常解析結果集
    LET l_data = aws_transXMLwords(l_data)
    IF l_first THEN                
       LET l_dataDesc = l_dataDesc.append('    <Data Format="Join" >\n')
       LET l_dataDesc = l_dataDesc.append('      <DataSet Field="'||p_PropList||'" >\n')
       LET l_first = FALSE
    END IF 
    #如果設定了要對欄位進行映射則調用相應函數處理
    IF p_mapping THEN 
       CALL aws_MappingValueToTarget(p_sysid,p_objectid,p_FieldList,l_data) RETURNING l_errCode,l_errDesc,l_data
       IF NOT cl_null(l_errCode) THEN 
          RETURN l_errCode,l_errDesc,''
       END IF        
    END IF 
    LET l_dataDesc = l_dataDesc.append('        <Row Data="'||l_data||'" />\n')
  END FOREACH
  IF SQLCA.sqlcode THEN  
     RETURN '-6','sql語句錯誤',''
  ELSE
     IF NOT cl_null(l_dataDesc) THEN 
        LET l_dataDesc = l_dataDesc.append("      </DataSet>\n    </Data>\n")
     END IF     
  END IF      
 
  #如果成功則返回結果集
  IF NOT cl_null(l_dataDesc) THEN RETURN '','',l_dataDesc
     ELSE RETURN '1','沒有找到符合條件的數據',''
  END IF    
 
END FUNCTION  
 
FUNCTION aws_WriteData(p_objectid,p_xmlFile,p_sep,p_Operate,p_Ignore,p_DateFormat)
DEFINE
  p_objectid       LIKE waa_file.waa01,
  p_Ignore         STRING,
  p_sep            STRING,
  p_Operate        LIKE wam_file.wam02,
  p_xmlFile        STRING,
  p_DateFormat     STRING,
  i,n              LIKE type_file.num5,
  l_errCode        STRING,
  l_errDesc        STRING,   #單條錯誤的描述信息
  l_errTot         STRING,    #當IgnoreError='Y'是所有的描述信息
  l_status         LIKE type_file.num5,
  l_errCode_i      STRING,
  l_errDesc_data   STRING,
  l_flag           STRING 
 
  #對數據進行預處理，該擴展的擴展
  CALL aws_MappingDataByProp(p_objectid,p_xmlfile,p_sep) RETURNING l_errCode,l_errDesc
  IF NOT cl_null(l_errCode) THEN 
     RETURN l_errCode,l_errDesc
  END IF 
  #將數據從XML文件中讀到pub_data中
  CALL aws_AnalyzeData(p_objectid,p_xmlFile,p_sep) RETURNING l_errCode,l_errDesc
  IF NOT cl_null(l_errCode) THEN 
     RETURN l_errCode,l_errDesc
  END IF 
 
  #對傳入的pub_data進行整理
  #1.檢查數據合理性(欄位有沒有少，必填欄位和主鍵欄位都傳了嗎)
  #2.將數據中的%%按照系統邏輯進行替換(詳細邏輯參考函數中的說明)
  CALL AnalyzeList(p_objectid,p_sep,p_dateformat) RETURNING l_errCode_i,l_errDesc_data
  IF NOT cl_null(l_errCode_i) THEN 
     RETURN l_errCode_i,l_errDesc_data
  END IF
 
  SELECT COUNT(*) INTO n FROM wam_file WHERE wam01=p_objectid AND wam02=p_Operate 
  IF n>0 THEN 
     #Modified by David Lee 2008/12/02
     CALL aws_ttsrv2_case(p_objectid,p_Operate) RETURNING l_errCode,l_errDesc
     RETURN l_errCode,l_errDesc
  ELSE 
     #在事務性操作之前，啟動一個Transaction
     BEGIN WORK
     LET l_errTot = ''
     #循環處理每一個對象
     FOR i=1 TO pub_data.getLength()
         #調用Before接口進行外部檢查 
   #     IF p_ibjectid ="OrderChange" THEN
   #        CALL BeforeOrderChange(l_ObjectID,l_Sep,rec_data,p_index,p_dateformat) RETURNING l_errCode,l_errDesc
   #     END IF 
         #如果在外部檢查過程中出現錯誤
   #      CALL BeforeOperation(p_ObjectID,p_Operate,p_Sep,pub_data,i) RETURNING l_errCode,l_errDesc
       # LET l_flag = i,","
       #  LET l_flag = l_flag.trim()
       #  LET l_flag = ",",l_flag
       #  CALL aws_notin(l_errCode_i,l_flag) RETURNING l_status
       #  IF l_status = '0' THEN 
         IF NOT cl_null(l_errCode) THEN 
            #向返回值中記錄錯誤信息
            LET l_errTot = l_errTot,l_errDesc
         
            #回滾上次BEGIN WORK之后做的修改(如果是IgnoreError = 'N',那么上一次BEGIN WORK
            #應該是進入循環前定義的那個，也就意味著回滾本次SetData所做的所有操作，反之
            #上一次BEGIN WORK應該是上一次對象操作完成之后，也就意味著回滾對本對象所進行的操作
            ROLLBACK WORK 
            LET l_errCode =''
            
            #如果定義為不忽略錯誤，則ROLLBACK后直接退出SetData，即不進行后續的操作
            IF p_Ignore = 'N' THEN
               RETURN l_errCode,l_errTot
            ELSE 
               #如果定義為忽略錯誤，則在ROLLBACK后再開一次新的事務，并繼續循環下一個對象
               BEGIN WORK
            END IF
         ELSE 
         	 #如果前面通過檢查
            #根據操作類型調用對應的處理函數
            CASE p_Operate
              WHEN "INSERT"
#                  RUN "echo 'SetData' > /u1/out/ttp_test/writedata5"
                CALL DB_INSERT(p_objectid,p_sep,pub_data,i,p_DateFormat) RETURNING l_errCode,l_errDesc
              WHEN "DELETE"
                CALL DB_DELETE(p_objectid,p_sep,pub_data,i,p_DateFormat) RETURNING l_errCode,l_errDesc
              WHEN "UPDATE"
                IF p_objectid='BOM' THEN
                   CALL DB_ADJUST(p_objectid,p_sep,pub_data,i,p_DateFormat)   RETURNING l_errCode,l_errDesc
                ELSE
                   CALL DB_UPDATE(p_objectid,p_sep,pub_data,i,p_DateFormat) RETURNING l_errCode,l_errDesc
                END IF
              WHEN "SYNC"
                CALL DB_SYNC(p_objectid,p_sep,pub_data,i,p_DateFormat)   RETURNING l_errCode,l_errDesc
              WHEN "ADJUST"
                CALL DB_ADJUST(p_objectid,p_sep,pub_data,i,p_DateFormat)   RETURNING l_errCode,l_errDesc
            END CASE
            #如果在操作過程中出現錯誤
            IF NOT cl_null(l_errCode) THEN 
               #向返回值中記錄錯誤信息
               LET l_errTot = l_errTot,l_errDesc
         
               #回滾上次BEGIN WORK之后做的修改(如果是IgnoreError = 'N',那么上一次BEGIN WORK
               #應該是進入循環前定義的那個，也就意味著回滾本次SetData所做的所有操作，反之
               #上一次BEGIN WORK應該是上一次對象操作完成之后，也就意味著回滾對本對象所進行的操作
               ROLLBACK WORK 
               LET l_errCode =''
               
               #如果定義為不忽略錯誤，則ROLLBACK后直接退出SetData，即不進行后續的操作
               IF p_Ignore = 'N' THEN
                  RETURN l_errCode,l_errTot
               ELSE 
                  #如果定義為忽略錯誤，則在ROLLBACK后再開一次新的事務，并繼續循環下一個對象
                  BEGIN WORK
               END IF
            ELSE            
               #如果前面的操作執行正確
               #調用After接口進行附加操作
               CALL AfterOperation(p_objectid,p_Operate,p_sep,pub_data,i) RETURNING l_errCode,l_errDesc
               #如果在附加操作過程中出現錯誤
               IF NOT cl_null(l_errCode) THEN 
                  #向返回值中記錄錯誤信息
                  LET l_errTot = l_errTot,l_errDesc
         
                  #回滾上次BEGIN WORK之后做的修改(如果是IgnoreError = 'N',那么上一次BEGIN WORK
                  #應該是進入循環前定義的那個，也就意味著回滾本次SetData所做的所有操作，反之
                  #上一次BEGIN WORK應該是上一次對象操作完成之后，也就意味著回滾對本對象所進行的操作
                  ROLLBACK WORK 
                  LET l_errCode =''
                  
                  #如果定義為不忽略錯誤，則ROLLBACK后直接退出SetData，即不進行后續的操作
                  IF p_Ignore = 'N' THEN
                     RETURN l_errCode,l_errTot
                  ELSE 
                     #如果定義為忽略錯誤，則在ROLLBACK后再開一次新的事務，并繼續循環下一個對象
                     BEGIN WORK
                  END IF
               ELSE 
                  #當允許忽略錯誤的時候，每一筆記錄結束的時候都要提交一下	 
                  IF p_Ignore = 'Y' THEN 
                     #如果本次的所有操作均成功，則提交之
                     COMMIT WORK
                     #然后重新開始一個新的事務供下一次使用
                     BEGIN WORK
                  END IF    
               END IF 
            END IF 
         END IF     
        # ELSE 
        #    CONTINUE FOR 
        # END IF  
     END FOR 
  
     #走到這里，可能有兩種情況︰1︰IgnoreError = 'N'時，說明整個操作中沒有任何錯誤，
     #2:IgnoreError = 'Y'時，所有操作循環結束，不管有沒有錯誤，當前都是處于BEGIN WORK狀態
     #所以都要提交本次的事務(但是要根據l_errTot中有沒有數據來判斷本次是否發生了錯誤)
     COMMIT WORK
     #返回一個正確的結果和可能有的錯誤
     IF NOT cl_null(l_errTot) THEN 
        RETURN 'aws-260',l_errTot
     ELSE 
        RETURN '',''
     END IF 
  END IF     
     
END FUNCTION
 
#-------------------------------------------底層服務函數----------------------------------------------------
 
#子函數,供AnalyzeList調用,功能是檢查某一行的數據合理性
FUNCTION aws_AnalyzeRow(p_objectid,p_table,p_fieldlist,p_valuelist,p_sep,p_dateformat)
DEFINE 
  p_objectid              LIKE wac_file.wac01,
  p_table                 LIKE wac_file.wac02,
  l_wac03                 LIKE wac_file.wac03,
  l_wac06                 LIKE wac_file.wac06,
  p_fieldlist             STRING,
  p_valuelist             STRING,
  p_sep                   STRING,
  p_dateformat            STRING,
  ls_field,ls_data        base.StringTokenizer,
  l_where                 STRING,
  l_found,l_count,l_first LIKE type_file.num5,
  l_field,l_data,l_dtmp   STRING,
  l_errCode,l_errDesc     STRING,
  l_field_out,l_value_out STRING,
  l_wac15                   LIKE wac_file.wac15,
  l_oeb14t                LIKE oeb_file.oeb14t,                                                                                     
  l_oeb14t1               STRING
  DEFINE l_i              LIKE type_file.num5
  DEFINE arr_value         DYNAMIC ARRAY OF STRING
  DEFINE arr_field           DYNAMIC ARRAY OF STRING
 
  #檢查流程︰
  #1.首先檢查FieldList數量是否和DataList數量一致
  #2.檢查對應表中的每個主鍵欄位是否都給了，不能為空，也不能為%%
  #3.根據主鍵在對應的表中進行查詢，看是否存在相應的記錄
  #4.如果存在相應的記錄，則將%%理解為忽略該欄位，把Data為%%的欄位從FieldList中清除出去
  #5.如果不存在相應記錄，則遇到時將從wac_file中尋找默認值進行替換
  #6.如果不存在相應記錄，還要在上面的替換過程結束后檢測是否所有必填欄位都提供了，且對應的值不是空
 
  #第一步(FieldList數量和DataList數量是否一致)
 
  #第二步，判定該筆主鍵的記錄是否存在，如果存在，則將Data中包含的所有%%欄位全部從Field和Data列表中清除
  #如果不存在，則用wac_file中定義的默認值取代相應Data中的%%位置
   
  #要找到Head表對應的主鍵以及數據集中傳遞的對應Value并按其合成DELETE語句的Where條件子句
  LET l_where = ''
  DECLARE sel_hkey_cs CURSOR FOR 
    SELECT wac03,wac06 FROM wac_file WHERE wac01 = p_objectid AND wac02 = p_table AND wac08 = 'Y'
  #循環每一個主鍵欄位，合成查詢所需的WHERE條件  
  FOREACH sel_hkey_cs INTO l_wac03,l_wac06
    #初始化是否找到主鍵標識
    LET l_found = FALSE
     CALL aws_Tokenizer(p_fieldlist,g_Separator,arr_field)
     CALL aws_Tokenizer(p_valuelist,g_Separator,arr_value)
     FOR l_i = 1 TO arr_field.getLength()
       LET l_field = arr_field[l_i]
       LET l_data = arr_value[l_i]
       
      #找到主鍵欄位，生成一個"欄位＝值"的語句并將其添加到Where條件中去
      IF l_field = l_wac03 THEN
         #如果主鍵欄位為空或給放了一個%%也算錯誤(主鍵欄位是不允許取默認值的)	
         LET l_data = l_data.trim()
         IF (cl_null(l_data))OR(l_data = '%%') THEN
            LET l_errCode = "aws-233"
            LET l_errDesc = aws_MakeErrorXML(p_table,p_fieldlist,p_valuelist,l_errCode,cl_replace_err_msg( cl_getmsg(l_errCode,g_lang),l_wac03))
            RETURN l_errCode,l_errDesc,'',''         
         ELSE  
            #如果正確了則根據這個合成WHERE條件
            LET l_where = aws_MakeSubStr(l_where,l_field,l_data,l_wac06,'AND','=',p_dateformat)
            #當前主鍵找到了，標志設置為TRUE
            LET l_found = TRUE
            #退出當前循環
            EXIT FOR 
         END IF       	   
      END IF 
     END FOR 
    #如果標志位為FALSE表示有某個主鍵欄位沒有在FieldList中給出
    #此處說明︰從理論上講這個錯誤是不應該出現的，因為主鍵欄位肯定同時也是必填欄位，但為了防止某些菜鳥
    #          給設漏了，所以這里還是加一個判別，以避免不必要的風險
    IF NOT l_found THEN 
       LET l_errCode = "aws-262"
       LET l_errDesc = aws_MakeErrorXML(p_table,p_fieldlist,p_valuelist,l_errCode,cl_getmsg(l_errCode,g_lang)||l_wac03 CLIPPED)
       RETURN l_errCode,l_errDesc,'',''
    END IF  
  END FOREACH 
 
  #第三步，根據上面找出的主鍵查一下(能走到這里說明l_where里面肯定有值）
  LET l_where = 'SELECT COUNT(*) FROM ',p_table,' WHERE ',l_where
  PREPARE cs_hcount FROM l_where
  EXECUTE cs_hcount INTO l_count
  FREE cs_hcount
  
  #沒找到說明該Head記錄應該按照新增規則來進行替換
  #IF l_count = 0  THEN     ####baoyan
     #如果在Data中發現了"%%"字符，則進行替換
     IF p_valuelist.getIndexOf('%%',1) > 0 THEN
        LET l_data = ''
        LET l_first = TRUE
        #循環找到含有%%的欄位       
         CALL aws_Tokenizer(p_fieldlist,p_sep,arr_field)
         CALL aws_Tokenizer(p_valuelist,p_sep,arr_value)
         FOR l_i = 1 TO arr_field.getLength()
            LET l_field = arr_field[l_i]
            LET l_dtmp = arr_value[l_i]            
          #如果該欄位的值為%%則將值改為對應的Template默認值
          IF l_dtmp = '%%' THEN
             LET l_dtmp = GetTemplateDefault(p_objectid,l_field)
          END IF
          #將Data值合成到DataList中 
          IF l_first THEN  #之所以不用IF cl_null(l_data)來判斷的原因是如果第一個欄位的data值是空，則會導致本來應該添加的|缺失
             LET l_data = l_dtmp
             LET l_first = FALSE 
          ELSE 
             LET l_data = l_data,p_sep,l_dtmp 
          END IF       
        END FOR  
        #用更新以后的Data替換原來的Data
        LET p_valuelist = l_data
     END IF  
     
     #替換完成以后回頭來檢查必填欄位是否都在FieldList中，且每個必填欄位都有非空的值
     #因為前面進行了%%的替換，所以這里只需要檢查是否為空就可以了
     LET p_table = p_table
     DECLARE sel_hreq_cs CURSOR FOR 
       SELECT wac03 FROM wac_file WHERE wac01 = p_objectid AND wac02 = p_table AND wac09 = 'Y'
     #循環每一個必填欄位看看是否存在  
     FOREACH sel_hreq_cs INTO l_wac03
       #初始化是否找到必填欄位標識
       LET l_found = FALSE
       CALL aws_Tokenizer(p_fieldlist,p_sep,arr_field) 
       CALL aws_Tokenizer(p_valuelist,p_sep,arr_value)
       FOR l_i =1 TO arr_field.getLength()
           LET l_field = arr_field[l_i]
           LET l_data = arr_value[l_i]  
         #找到必填欄位標志設置為TRUE
         IF l_field = l_wac03 THEN 
            LET l_found = TRUE              
            #還要檢查其對應的data有沒有東西
            LET l_data = l_data.trim()
            IF cl_null(l_data) THEN 
               #如果必填欄位沒有輸東西則報一個錯誤
               LET l_errCode = "aws-232"
               LET l_errDesc = aws_MakeErrorXML(p_table,p_fieldlist,p_valuelist,l_errCode,cl_replace_err_msg( cl_getmsg(l_errCode,g_lang),l_wac03))
               RETURN l_errCode,l_errDesc,'',''
            END IF 
            #退出當前循環
            EXIT FOR 	   
         END IF 
       END FOR 
       #如果標志位為FALSE表示有某個必填欄位沒有在FieldList中給出
       IF NOT l_found THEN
          SELECT wac15 INTO l_wac15 FROM wac_file WHERE wac01 =p_objectid AND                                                       
                 wac03=l_wac03                                                                                                      
          IF cl_null(l_wac15) THEN 
           LET l_errCode = "aws-234"
           LET l_errDesc = aws_MakeErrorXML(p_table,p_fieldlist,p_valuelist,l_errCode,cl_replace_err_msg( cl_getmsg(l_errCode,g_lang),l_wac03))
           RETURN l_errCode,l_errDesc,'',''
          END IF
           LET p_fieldlist = p_fieldlist,p_sep,l_wac03                                                                                 
          LET p_valuelist = p_valuelist,p_sep,l_wac15
       END IF  
     END FOREACH 
  
  RETURN '','',p_fieldlist,p_valuelist
END FUNCTION
 
#從從p_Param存放的參數列表中找到所有名稱等于p_tag的參數，返回對象的值
#如果存在多個同名參數則返回第一個參數的值
FUNCTION FindValue(p_tag,p_Param)
DEFINE 
  p_tag       STRING,
  i           LIKE type_file.num5,
  p_Param     DYNAMIC ARRAY OF RECORD   
    Tag       STRING,  
    Attribute STRING,    
    Value     STRING  
  END RECORD
 
  FOR i=1 TO p_Param.getLength()
    IF p_Param[i].Tag = p_tag THEN
       RETURN p_Param[i].Value
    END IF
  END FOR
  RETURN ''
  
END FUNCTION
FUNCTION FindAttribute(p_tag,p_Param)
DEFINE 
  p_tag       STRING,
  i           LIKE type_file.num5,
  p_Param     DYNAMIC ARRAY OF RECORD   
    Tag       STRING,  
    Attribute STRING,    
    Value     STRING  
  END RECORD
 
  FOR i=1 TO p_Param.getLength()
    IF p_Param[i].Tag = p_tag THEN
       RETURN p_Param[i].Attribute
    END IF
  END FOR
  RETURN ''
  
END FUNCTION
 
#檢查傳入的企業對象標識是否存在于系統中
FUNCTION CheckObjectID(p_id)     
DEFINE 
  p_id   LIKE waa_file.waa01,
  l_cnt  LIKE type_file.num5    
                           
  SELECT COUNT(*) INTO l_cnt FROM waa_file WHERE waa01 = p_id 
  IF l_cnt != 1 THEN  
     RETURN '-4','企業對象名錯誤'
  ELSE
     RETURN '',''
  END IF                                                                        
END FUNCTION
 
#根據FieldList中的字段獲知相關的表
FUNCTION aws_GetTablesByFields(p_id,p_fdl,p_sep)
DEFINE       
  p_id       STRING,
  p_fdl      STRING,
  p_sep      STRING,
  l_tok      base.StringTokenizer,
  l_field    LIKE wac_file.wac03,
  l_tab      LIKE wac_file.wac02,
  l_tables   base.StringBuffer,
  l_errCode  STRING,
  l_errDesc  STRING,
  l_dataDesc STRING,
  l_sql      STRING
DEFINE l_i        LIKE type_file.num5
DEFINE arr_field  DYNAMIC ARRAY OF STRING
 
  LET l_sql = "SELECT wac02 FROM wac_file WHERE wac01 = '",
              p_id,"' AND wac03 = ?"
  PREPARE sp FROM l_sql
 
  LET l_tables = base.StringBuffer.create()
  CALL aws_Tokenizer(p_fdl,p_sep,arr_field)
  FOR l_i = 1 TO arr_field.getLength()
      LET l_field = arr_field[l_i]
    LET l_tab = ''    
    EXECUTE sp USING l_field INTO l_tab
    IF cl_null(l_tab) THEN      
       RETURN '-5','字段'||l_field||'所屬表不在企業對象中',''
    ELSE
       IF l_tables.getIndexOf(l_tab,1) = 0 THEN
          CALL l_tables.append(l_tab||",")
       END IF
    END IF    
  END FOR 
  FREE sp
  RETURN '','',l_tables.subString(1,l_tables.getLength()-1)
END FUNCTION
       
#根據自己的屬性列表得到欄位列表，因為一個屬性可能對應到多個欄位，所以只取其中一個欄位
FUNCTION aws_GetFieldByProperty(p_object,p_prop,p_sep)
DEFINE 
   p_prop         STRING,
   p_object       LIKE wac_file.wac01,
   p_sep          STRING,
   l_tok          base.StringTokenizer,
   l_errCode      STRING,
   l_errDesc      STRING,
   l_sql          STRING,
   l_field         STRING,
   l_wac03        LIKE wac_file.wac03,    #欄位名
   l_wac04        LIKE wac_file.wac04     #屬性名
DEFINE l_i        LIKE type_file.num5
DEFINE arr_wac04  DYNAMIC ARRAY OF STRING     
 
   LET l_errCode = ''
   LET l_errDesc = ''   
   #p_prop可能是一個列表，需要拆解
   #p_prop對應到wac04，返回其對應的wac03
    CALL aws_Tokenizer(p_prop,p_sep,arr_wac04)
    FOR l_i = 1 TO arr_wac04.getLength()
      LET l_wac04 = arr_wac04[l_i]
      LET l_sql ="SELECT wac03  FROM wac_file ",
                 " WHERE wac04 ='",l_wac04,"'",
                 " AND wac01= '",p_object,"'"
      PREPARE l_presqlo  FROM l_sql
      DECLARE l_srollcurs SCROLL CURSOR FOR l_presqlo
      OPEN l_srollcurs
      FETCH FIRST l_srollcurs INTO l_wac03
        IF SQLCA.sqlcode THEN 
           LET l_errCode = "aws-121"
           LET l_errDesc = cl_replace_err_msg( cl_getmsg(l_errCode,g_lang),l_wac04)
           LET l_field = ''
           EXIT FOR 
        ELSE 
           IF cl_null(l_field) THEN 
              LET l_field = l_wac03
           ELSE 
             LET l_field = l_field,p_sep,l_wac03
           END IF 
        END IF     	    
      CLOSE l_srollcurs
    END FOR 
    
    RETURN l_errCode,l_errDesc,l_field               
       
END FUNCTION       
       
#尋找TIPTOP對象中能和目標系統進行Mapping的所有欄位的列表(具有相同屬性的比如bma01,bmb01,bmc02只取一)
#p_sysid表示目標系統標識
#p_object表示TIPTOP系統對象標識
#p_sep表示標准分隔符
#p_dateformat標識日期格式,如果傳入了表示需要把日期型欄位前后增加to_char(給aws_exportData用的),否則就不添加(給aws_importData用的)
FUNCTION aws_GetAllMappingField(p_sysid,p_objectid,p_sep)
DEFINE
  p_sysid                           LIKE wah_file.wah01,
  p_objectid                        LIKE wah_file.wah08,
  p_sep                             STRING,
  l_errCode,l_errDesc               STRING,
  l_wai04                           LIKE wai_file.wai04,
  l_wai05                           LIKE wai_file.wai05,
  l_i,l_j                           LIKE type_file.num5,
  l_fieldlist,l_proplist            STRING,
  l_found                           LIKE type_file.num5,
  arr_list  DYNAMIC ARRAY OF RECORD
    wai04  LIKE wai_file.wai04,
    wai05  LIKE wai_file.wai05
  END RECORD
  
  DECLARE cur_map_all CURSOR FOR 
    SELECT wai04,wai05 FROM wai_file,wah_file
    WHERE (NOT ( wai05 IS NULL )) AND (NOT ( wai04 IS NULL ))  #映射兩邊都有值
          AND wah01 = p_sysid AND wai01 = p_sysid
          AND wah08 = p_objectid AND wai02 = p_objectid 
          AND wah02 = wai03
    ORDER BY wai04  #同一個表中的欄位排在一起
  
  LET l_j = 1        
  FOREACH cur_map_all INTO l_wai04,l_wai05
    #要看看有沒有多個欄位映射到一個對方屬性上的情況
    LET l_found = FALSE
    FOR l_i = 1 TO arr_List.getLength()
        IF arr_List[l_i].wai05 = l_wai05 THEN 
           LET l_found = TRUE
           EXIT FOR
        END IF
    END FOR
    IF NOT l_found THEN  
      LET arr_list[l_j].wai04 = l_wai04
      LET arr_list[l_j].wai05 = l_wai05
      LET l_j = l_j + 1
    END IF 
  END FOREACH 
  #現在DYNAMIC ARRAY里面的可以保証是唯一字段列表的了，可以拼接返回字段列表了
  FOR l_i = 1 TO arr_list.getLength() 
      IF NOT cl_null(arr_list[l_i].wai04) THEN 
         IF cl_null(l_fieldlist) THEN 
            LET l_fieldlist = arr_list[l_i].wai04
            LET l_proplist = arr_list[l_i].wai05       
         ELSE 
            LET l_fieldlist = l_fieldlist,p_sep,arr_list[l_i].wai04
            LET l_proplist = l_proplist,p_sep,arr_list[l_i].wai05
         END IF   
      END IF 
  END FOR 
 
  IF cl_null(l_fieldlist) THEN 
     #RETURN 'aws-xxx','無法找到Mapping欄位，請確認是否維護了指定對象的Mapping信息','',''
     LET l_errCode = "aws-122"
     LET l_errDesc = cl_getmsg(l_errCode,g_lang)
     RETURN l_errCode,l_errDesc,'',''
  ELSE 
     RETURN '','',l_fieldlist,l_proplist
  END IF   
  
END FUNCTION
 
#分析從對方系統中傳遞回來的XML字符串中表示的含義
FUNCTION aws_AnalyzeOutput(p_output)
DEFINE 
  p_output               STRING,
  l_start,l_end          LIKE type_file.num5,
  l_status,l_error       STRING
  
  LET p_output = p_output.trim()
  
  #在傳入字符串中定位<Status>標簽
  LET l_start = p_output.getIndexOf('<Status>',1)
  LET l_end = p_output.getIndexOf('</Status>',l_start)
  IF ( l_start = 0 )OR( l_end = 0 ) THEN 
     #RETURN 'aws-xxx','解析返回值錯誤，未發現<Status>標簽'
     LET g_ze.ze01 = "aws-123"
     SELECT ze03 INTO g_ze.ze03 FROM ze_file WHERE ze01=g_ze.ze01 AND ze02=g_lang
     RETURN 'aws-123',g_ze.ze03
  END IF 
  LET l_status = p_output.substring(l_start+8,l_end-1)
  #Status = 0 表示操作正確
  IF l_status = '0' THEN 
     RETURN '',''
  ELSE 
     #否則需要去解析<Error>域
     LET l_start = p_output.getIndexOf('<Error>',1)
     LET l_end = p_output.getIndexOf('</Error>',l_start)
     IF ( l_start = 0 )OR( l_end = 0 ) THEN 
        #RETURN 'aws-xxx','解析返回值錯誤，未發現<Error>標簽'
        LET g_ze.ze01 = "aws-124"
        SELECT ze03 INTO g_ze.ze03 FROM ze_file WHERE ze01=g_ze.ze01 AND ze02=g_lang
        RETURN 'aws-124',g_ze.ze03
     END IF 
     LET l_error = p_output.substring(l_start+7,l_end-1)
     RETURN l_status,l_error
  END IF    
END FUNCTION 
 
#本函數將Data中出現的%%替換為Template中定義的默認值，直接操作pub_data公共數組
FUNCTION AnalyzeList(p_objectid,p_sep,p_dateformat)
DEFINE
  p_objectid                              LIKE wac_file.wac01,
  p_sep                                   STRING,
  p_dateformat                            STRING,
  i,j,k,l                                 LIKE type_file.num5,
  l_errCode                               STRING,
  l_errDesc                               STRING,
  l_errcod                                STRING,
  l_errdes                                STRING,
  l_errC                                  STRING 
  
  #----------------------循環pub_data中的每一筆單頭------------------------------
  FOR i=1 TO pub_data.getLength()
      CALL aws_AnalyzeRow(p_objectid,pub_data[i].tables,pub_data[i].fields,pub_data[i].data,p_sep,p_dateformat)
           RETURNING l_errCode,l_errDesc,pub_data[i].fields,pub_data[i].data
      IF NOT cl_null(l_errCode) THEN 
         LET l_errC = i            
         LET l_errC = l_errC.trim()
         IF cl_null(l_errcod) THEN 
            LET l_errcod = ",",l_errC
         ELSE 
            LET l_errcod = l_errcod,",",l_errC
         END IF 
         IF cl_null(l_errdes) THEN 
            LET l_errdes = l_errDesc
         ELSE 
            LET l_errdes = l_errdes,l_errDesc
         END IF 
         CONTINUE FOR 
      END IF     
    #-----------------------循環pub_data[i]中的每一筆單身--------------------------------
    FOR j=1 TO pub_data[i].body.getLength() 
        CALL aws_AnalyzeRow(p_objectid,pub_data[i].body[j].tables,pub_data[i].body[j].fields,pub_data[i].body[j].data,p_sep,p_dateformat)
             RETURNING l_errCode,l_errDesc,pub_data[i].body[j].fields,pub_data[i].body[j].data
        IF NOT cl_null(l_errCode) THEN 
           LET l_errC = i            
           LET l_errC = l_errC.trim()
           IF cl_null(l_errcod) THEN 
              LET l_errcod = ",",l_errC
           ELSE 
              LET l_errcod = l_errcod,",",l_errC
           END IF 
           IF cl_null(l_errdes) THEN 
              LET l_errdes = l_errDesc
           ELSE 
              LET l_errdes = l_errdes,l_errDesc
           END IF 
           CONTINUE FOR 
        END IF     
      #----------------------循環pub_data[i].body[j]中的每一筆子單身---------------------------
      FOR k=1 TO pub_data[i].body[j].detail.getLength() 
          CALL aws_AnalyzeRow(p_objectid,pub_data[i].body[j].detail[k].tables,pub_data[i].body[j].detail[k].fields,pub_data[i].body[j].detail[k].data,p_sep,p_dateformat)
               RETURNING l_errCode,l_errDesc,pub_data[i].body[j].detail[k].fields,pub_data[i].body[j].detail[k].data
          IF NOT cl_null(l_errCode) THEN 
             LET l_errC = i            
             LET l_errC = l_errC.trim()
             IF cl_null(l_errcod) THEN 
                LET l_errcod = ",",l_errC
             ELSE 
                LET l_errcod = l_errcod,",",l_errC
             END IF 
             IF cl_null(l_errdes) THEN 
                LET l_errdes = l_errDesc
             ELSE 
                LET l_errdes = l_errdes,l_errDesc
             END IF 
             CONTINUE FOR 
          END IF     
        #--------------------循環pub_data[i].body[j].detail[k]中的每一筆子子單身-----------------------
        FOR l=1 TO pub_data[i].body[j].detail[k].subdetail.getLength() 
            CALL aws_AnalyzeRow(p_objectid,pub_data[i].body[j].detail[k].subdetail[l].tables,pub_data[i].body[j].detail[k].subdetail[l].fields,pub_data[i].body[j].detail[k].subdetail[l].data,p_sep,p_dateformat)
                 RETURNING l_errCode,l_errDesc,pub_data[i].body[j].detail[k].subdetail[l].fields,pub_data[i].body[j].detail[k].subdetail[l].data
            IF NOT cl_null(l_errCode) THEN 
               RETURN l_errCode,l_errDesc
            END IF     
        END FOR 
      END FOR 
    END FOR 
  END FOR 
  
  #成功則返回
  RUN "echo '5' > "|| os.Path.join(FGL_GETENV("TEMPDIR"),"e.txt" )    #FUN-9C0008 
  RETURN l_errcod,l_errdes 
END FUNCTION
 
#得到某個欄位在模版定義中的默認值
FUNCTION GetTemplateDefault(p_obj,p_field)
DEFINE 
  p_obj      LIKE wac_file.wac01,
  p_field    LIKE wac_file.wac03,
  l_default  LIKE wac_file.wac15
  
  SELECT wac15 INTO l_default FROM wac_file WHERE wac01 = p_obj AND wac03 = p_field
  RETURN l_default
END FUNCTION 
 
#外部接口，執行操作前的實務性檢查
FUNCTION BeforeOperation(l_ObjectID,l_Operate,l_Sep,rec_data,p_index)
DEFINE
  l_ObjectID      STRING,
  l_Operate       STRING,
  l_Sep           STRING,
  l_errCode       STRING,
  l_errDesc       STRING,
  p_index         LIKE type_file.num5,
 
  rec_data        DYNAMIC ARRAY OF RECORD
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
 
  CASE l_Operate
    WHEN "INSERT"
      CALL BeforeInsert(l_ObjectID,l_Sep,rec_data,p_index) RETURNING l_errCode,l_errDesc
    WHEN "DELETE"
      CALL BeforeDelete(l_ObjectID,l_Sep,rec_data,p_index) RETURNING l_errCode,l_errDesc
    WHEN "UPDATE"
      CALL BeforeUpdate(l_ObjectID,l_Sep,rec_data,p_index) RETURNING l_errCode,l_errDesc
     WHEN "SYNC"  
      CALL BeforeSync(l_ObjectID,l_Sep,rec_data,p_index)  RETURNING l_errCode,l_errDesc
     WHEN "ADJUST"  
      CALL BeforeAdjust(l_ObjectID,l_Sep,rec_data,p_index)  RETURNING l_errCode,l_errDesc
  END CASE 
  
  RETURN l_errCode,l_errDesc
END FUNCTION
 
#外部接口，執行操作后的附加性操作
FUNCTION AfterOperation(l_ObjectID,l_Operate,l_Sep,rec_data,p_index)
DEFINE
  l_ObjectID      STRING,
  l_Operate       STRING,
  l_Sep           STRING,
  l_errCode       STRING,
  l_errDesc       STRING,
  p_index         LIKE type_file.num5,
 
  rec_data        DYNAMIC ARRAY OF RECORD
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
 
  CASE l_Operate
    WHEN "INSERT"
      CALL AfterInsert(l_ObjectID,l_Sep,rec_data,p_index) RETURNING l_errCode,l_errDesc
    WHEN "DELETE"
      CALL AfterDelete(l_ObjectID,l_Sep,rec_data,p_index) RETURNING l_errCode,l_errDesc
    WHEN "UPDATE"
      CALL AfterUpdate(l_ObjectID,l_Sep,rec_data,p_index) RETURNING l_errCode,l_errDesc
    WHEN "SYNC"
      CALL AfterSync(l_ObjectID,l_Sep,rec_data,p_index)  RETURNING l_errCode,l_errDesc
    #ADJUST的After動作要放到DB_ADJUST函數里面來做，原因請看函數里面的說明
#    WHEN "ADJUST"
#      CALL AfterAdjust(l_ObjectID,l_Sep,rec_data,p_index)  RETURNING l_errCode,l_errDesc
  END CASE 
  
  RETURN l_errCode,l_errDesc
END FUNCTION
 
#這個函數有問題，肯定是通不過的
FUNCTION BeforeAdjust(l_ObjectID,l_Sep,rec_data,p_index)
DEFINE
  l_ObjectID      LIKE wac_file.wac01,
  l_Sep           STRING,
  l_errCode       STRING,
  l_errDesc       STRING,
  p_index         LIKE type_file.num5,
  l_htable        LIKE wac_file.wac02,
  l_where         LIKE type_file.chr1000,
  l_tok_field     base.stringTokenizer,
  l_tok_data      base.stringTokenizer,
  l_data          STRING,
  l_field         STRING,
  l_found         LIKE type_file.num5,
  l_count         LIKE type_file.num5,
  l_wac03         LIKE wac_file.wac03,
  l_wac06         LIKE wac_file.wac06,
 
  rec_data        DYNAMIC ARRAY OF RECORD
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
  
DEFINE l_i        LIKE type_file.num5
DEFINE arr_field DYNAMIC ARRAY OF STRING
DEFINE arr_data  DYNAMIC ARRAY OF STRING
 
  #原則，根據傳入的記錄判斷本次操作將會是DB_INSERT還是DB_UPDATE，然后分別調用相應的Check函數
  #要找到Head表對應的主鍵以及數據集中傳遞的對應Value并按其合成查詢所需的Where條件子句
  LET l_where = ''
  LET l_htable = rec_data[p_index].tables
  DECLARE sel_key_cs CURSOR FOR 
    SELECT wac03,wac06 FROM wac_file WHERE wac01 = l_ObjectID AND wac02 = l_htable AND wac08 = 'Y'
  #循環每一個主鍵欄位，合成查詢所需的WHERE條件  
  FOREACH sel_key_cs INTO l_wac03,l_wac06
    #初始化是否找到主鍵標識
    LET l_found = FALSE
    CALL aws_Tokenizer(rec_data[p_index].fields,l_sep,arr_field)
    CALL aws_Tokenizer(rec_data[p_index].data,l_Sep,arr_data)
    FOR l_i = 1 TO arr_field.getLength()
        LET l_field = arr_field[l_i]
        LET l_data = arr_data[l_i]
      #找到主鍵欄位，生成一個"欄位＝值"的語句并將其添加到Where條件中去
      IF l_field = l_wac03 THEN
         #如果主鍵欄位為空或給放了一個%%也算錯誤(主鍵欄位是不允許取默認值的)	
         LET l_data = l_data.trim()
         IF cl_null(l_data) THEN
            LET l_errCode = "aws-233"
            LET l_errDesc = '\n<Row Table="',rec_data[p_index].tables,'" Field="',rec_data[p_index].fields, 
              '" Data="',rec_data[p_index].data,'" Error="aws-233" Desc="',cl_replace_err_msg( cl_getmsg(l_errCode,g_lang),l_wac03),'" />\n'
            RETURN l_errCode,l_errDesc         
         ELSE  
            IF l_data = '%%' THEN 
               LET l_errCode = "aws-233"
               LET l_errDesc = '\n<Row Table="',rec_data[p_index].tables,'" Field="',rec_data[p_index].fields, 
                 '" Data="',rec_data[p_index].data,'" Error="aws-233" Desc="',cl_replace_err_msg( cl_getmsg(l_errCode,g_lang),l_wac03),'" />\n'
               RETURN l_errCode,l_errDesc         
            ELSE 
               #如果正確了
               IF l_wac06 = 'C'  THEN 
                  LET l_where = l_where," AND ",l_field,"='",l_data,"' "
               ELSE 
               	  IF l_wac06 = 'D' THEN
#No.FUN-9C0073 ---BEGIN
#               	     LET l_where = l_where," AND ",l_field,"= to_date('",l_data,"','yyyy-mm-dd HH24:mi:ss') "
                     LET l_where = l_where," AND ",l_field,"= CAST('",l_data,"' AS DATETIME)"
#No.FUN-9C0073 ---END
                  ELSE
                     LET l_where = l_where,' AND ',l_field,'=',l_data,' '
                  END IF 
               END IF 
               #當前主鍵找到了，標志設置為TRUE
               LET l_found = TRUE
               #退出當前循環
               EXIT FOR 
            END IF 
         END IF       	   
      END IF 
    END FOR 
    #如果標志位為FALSE表示有某個主鍵欄位沒有在FieldList中給出
    #此處說明︰從理論上講這個錯誤是不應該出現的，因為主鍵欄位肯定同時也是必填欄位，但為了防止某些菜鳥
    #          給設漏了，所以這里還是加一個判別，以避免不必要的風險
    IF NOT l_found THEN 
        LET l_errCode = "aws-262"
        LET l_errDesc = '\n<Row Table="',rec_data[p_index].tables,'" Field="',rec_data[p_index].fields, 
          '" Data="',rec_data[p_index].data,'" Error="aws-262" Desc="',cl_getmsg(l_errCode,g_lang),'" />\n'
        RETURN l_errCode,l_errDesc         
    END IF  
  END FOREACH 
 
  #第三步，根據上面找出的主鍵查一下(能走到這里說明l_where里面肯定有值）
  LET l_where = 'SELECT COUNT(*) FROM ',rec_data[p_index].tables,' WHERE 1=1 ',l_where
  PREPARE cs_count FROM l_where
  EXECUTE cs_count INTO l_count
  FREE cs_count
  
END FUNCTION 
 
#這個函數有問題，肯定是通不過的
FUNCTION BeforeSync(l_ObjectID,l_Sep,rec_data,p_index)
DEFINE
  l_ObjectID      STRING,
  l_Sep           STRING,
  l_errCode       STRING,
  l_errDesc       STRING,
  p_index         LIKE type_file.num5,
 
  rec_data        DYNAMIC ARRAY OF RECORD
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
 
  CALL BeforeDelete(l_ObjectID,l_Sep,rec_data,p_index) RETURNING l_errCode,l_errDesc
  IF NOT cl_null(l_errCode) THEN 
     RETURN l_errCode,l_errDesc
  END IF 
  CALL BeforeUpdate(l_ObjectID,l_Sep,rec_data,p_index) RETURNING l_errCode,l_errDesc
  RETURN l_errCode,l_errDesc  
END FUNCTION 
 
#這個函數也一樣有問題
FUNCTION AfterSync(l_ObjectID,l_Sep,rec_data,p_index)
DEFINE
  l_ObjectID      STRING,
  l_Sep           STRING,
  l_errCode       STRING,
  l_errDesc       STRING,
  p_index         LIKE type_file.num5,
 
  rec_data        DYNAMIC ARRAY OF RECORD
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
 
  CALL AfterDelete(l_ObjectID,l_Sep,rec_data,p_index) RETURNING l_errCode,l_errDesc
  IF NOT cl_null(l_errCode) THEN 
     RETURN l_errCode,l_errDesc
  END IF 
  CALL AfterUpdate(l_ObjectID,l_Sep,rec_data,p_index) RETURNING l_errCode,l_errDesc
  RETURN l_errCode,l_errDesc  
END FUNCTION 
 
#按對象插入數據
FUNCTION DB_INSERT(l_ObjectID,l_Sep,rec_data,p_index,p_dateformat)
DEFINE
  l_ObjectID       LIKE waa_file.waa01,
  l_Sep            STRING,
  l_errDesc        STRING,
  i,j,k,l          LIKE type_file.num5,
  l_sql            STRING,
  p_index          LIKE type_file.num5,
  p_dateformat     STRING,
  
  def_field        STRING,
  def_data         STRING,
  l_field          STRING,
  l_data           STRING,
  l_tmp_field      LIKE type_file.chr30,
  l_tmp_data       STRING,
  l_type           LIKE wac_file.wac06,
  l_tok_field      base.StringTokenizer,
  l_tok_data       base.StringTokenizer,
  
  rec_data        DYNAMIC ARRAY OF RECORD
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
  
DEFINE 
  l_str_buf     base.StringBuffer,
  l_str_buf1    base.StringBuffer,
  l_str_buf2    base.StringBuffer,
  l_str_buf3    base.StringBuffer,
  l_ima06       LIKE ima_file.ima06,
  l_ima08       LIKE ima_file.ima08 
DEFINE l_i        LIKE type_file.num5
DEFINE arr_field DYNAMIC ARRAY OF STRING
DEFINE arr_data  DYNAMIC ARRAY OF STRING
DEFINE l_bmb01       LIKE bmb_file.bmb01
DEFINE l_bmb02       LIKE bmb_file.bmb02
DEFINE l_bmb03       LIKE bmb_file.bmb03
DEFINE l_bmb04       LIKE bmb_file.bmb04
DEFINE l_bmt         DYNAMIC ARRAY OF RECORD LIKE bmt_file.*
DEFINE l_bmb13_length,l_bmb13_index,l_bmt_i,l_bmt_n,l_bmt_total       LIKE type_file.num5
DEFINE l_bmb13_sep   LIKE type_file.chr1
DEFINE bmt_arr_data  DYNAMIC ARRAY OF STRING
DEFINE l_bmb13_tmp_data,l_bmt_tmp_data,l_bmt_data       STRING
 
  #------------------插入Head表---------------------
  LET def_field = ''
  LET def_data = ''
  LET l_field = ''
  LET l_data = ''
  
  CALL aws_default_data(l_ObjectID,'head',l_Sep,rec_data,p_index,p_dateformat) RETURNING def_field,def_data
  
 
  CALL aws_Tokenizer(rec_data[p_index].fields,l_sep,arr_field)
  CALL aws_Tokenizer(rec_data[p_index].data,l_Sep,arr_data)
  FOR l_i = 1 TO arr_field.getLength()
    LET l_tmp_field = arr_field[l_i]
    LET l_tmp_data = arr_data[l_i]
  
    IF l_tmp_field = "ima06" THEN                         
       LET l_ima06 = l_tmp_data                             
       IF cl_null(l_ima06) THEN 
          LET l_errDesc = '<Row Table="ima_file" Field="ima06" Data="" Error="aws-334" Desc="',cl_getmsg("aws-334",g_lang),'" />'
          RETURN 'aws-334',l_errDesc
       END IF 
       SELECT imz08 INTO l_ima08 FROM imz_file WHERE imz01 = l_ima06
       IF cl_null(l_ima08) THEN 
          LET l_errDesc = '<Row Table="ima_file" Field="ima06" Data="" Error="aws-335" Desc="',cl_getmsg("aws-335",g_lang),'" />'
          RETURN 'aws-335',l_errDesc
       END IF 
    END IF
 
 
    
    
    #根據欄位名稱找到欄位類型,如果該欄位是字符串,則在對應的value前后加上',否則不作處理,日期型則在前后增加to_date轉換函數
    SELECT wac06 INTO l_type FROM wac_file 
      WHERE wac01 = l_ObjectID AND wac03 = l_tmp_field
   IF l_type <>'D' THEN
       IF l_type = 'C' THEN 
          IF l_tmp_data.getIndexOf("'",1) THEN     #adjust by binbin for special char: '
             LET l_tmp_data = "\"",l_tmp_data ,"\""
          ELSE 
             LET l_tmp_data = "'",l_tmp_data ,"'"
          END IF 
       ELSE 
          LET l_tmp_data = "'",l_tmp_data ,"'"
       END IF 
    ELSE 
       IF l_type = 'D' THEN
#No.FUN-9C0073 ---BEGIN 
#          LET l_tmp_data = "to_date('",l_tmp_data,"','",p_dateformat,"')"
              LET l_tmp_data = "CAST('",l_tmp_data,"' AS '",p_dateformat,"')"
#No.FUN-9C0073 ---END
       END IF 
    END IF 
    #組成欄位列表和值列表
    IF cl_null(l_field) THEN 
       LET l_field = l_tmp_field
       LET l_data = l_tmp_data
    ELSE 
       LET l_field = l_field,",",l_tmp_field
       LET l_data = l_data,",",l_tmp_data
    END IF     
  END FOR 
  
  IF NOT cl_null(def_field) AND NOT cl_null(def_data) THEN 
     LET l_field = l_field,",",def_field
     LET l_data = l_data,",",def_data
  END IF 
 
 
  LET l_sql = "INSERT INTO ",rec_data[p_index].tables,"(",l_field,") VALUES(",l_data,")"
  PREPARE head_cs FROM l_sql
  EXECUTE head_cs
 
  IF SQLCA.sqlcode THEN
     #對Head部分的-239(主鍵重復)錯誤進行特殊處理，返回一個單獨的錯誤號aws-261
     #這是專門給ADJUST方法的,DB_ADJUST得到這個錯誤號之后，就會轉而調用DB_UPDATE方法
     IF SQLCA.sqlcode = -239 THEN
        LET l_errDesc = '\n<Row Table="',rec_data[p_index].tables,'" Field="',rec_data[p_index].fields,
                        '" Data="',rec_data[p_index].data,'" Error="',SQLCA.sqlcode,'" Desc="',cl_getmsg("aws-261",g_lang),'" />\n'
        RETURN 'aws-261',l_errDesc       
     ELSE
        LET l_errDesc = '\n<Row Table="',rec_data[p_index].tables,'" Field="',rec_data[p_index].fields,
                        '" Data="',rec_data[p_index].data,'" Error="',SQLCA.sqlcode,'" Desc="',cl_getmsg("aws-211",g_lang),'" />\n'
        RETURN 'aws-211',l_errDesc
     END IF   
  END IF 
 
  #------------------插入Body表---------------------
  FOR i=1 TO rec_data[p_index].body.getLength()       
    LET def_field = ''
    LET def_data = ''
    LET l_field = ''
    LET l_data = ''
    CALL aws_default_data(l_ObjectID,'body',l_Sep,rec_data,p_index,p_dateformat) RETURNING def_field,def_data
   CALL aws_Tokenizer(rec_data[p_index].body[i].fields,l_Sep,arr_field)
   CALL aws_Tokenizer(rec_data[p_index].body[i].data,l_Sep,arr_data)
   FOR l_i = 1 TO arr_field.getLength()
       LET l_tmp_field = arr_field[l_i]
       LET l_tmp_data = arr_data[l_i]
 
     IF l_ObjectID='BOM' THEN 
       IF l_tmp_field = "bmb01" THEN
          LET l_bmb01=l_tmp_data
       END IF 
       IF l_tmp_field = "bmb02" THEN
          LET l_bmb02=l_tmp_data
       END IF
       IF l_tmp_field = "bmb03" THEN
          LET l_bmb03=l_tmp_data
       END IF
       IF l_tmp_field = "bmb04" THEN
          LET l_bmb04=l_tmp_data
       END IF
       IF l_tmp_field = "bmb13" AND l_tmp_data=='%%' THEN
          LET l_tmp_data=''
          LET l_bmb13_tmp_data=l_tmp_data
       END IF
       IF l_tmp_field = "bmb13" AND NOT cl_null(l_tmp_data) THEN
          LET l_bmb13_tmp_data=l_tmp_data
          LET l_bmb13_length = l_bmb13_tmp_data.getLength()
          IF l_bmb13_length>80 THEN 
             LET l_bmb13_Sep=','
                CALL aws_Tokenizer(l_bmb13_tmp_data,l_bmb13_Sep,bmt_arr_data)
                FOR l_bmt_i = 1 TO bmt_arr_data.getLength()
                   LET l_bmt_tmp_data = bmt_arr_data[l_bmt_i]
                   IF cl_null(l_bmt_data) THEN
                      LET l_bmt_data=l_bmt_tmp_data
                   ELSE
                      LET l_bmt_data=l_bmt_data,",",l_bmt_tmp_data
                   END IF 
                   IF (l_bmt_i mod 13)==0 AND l_bmt_i!=bmt_arr_data.getLength() THEN 
                      LET l_bmt_n=(l_bmt_i/13)
                      IF l_bmt_n==1 THEN 
                         LET l_tmp_data=l_bmt_data     #now the l_tmp_data is bmt_file first line data bmt06 for insert into bmb13 
                      END IF 
                      LET l_bmt[l_bmt_n].bmt06=l_bmt_data
                      LET l_bmt[l_bmt_n].bmt07=13
                      LET l_bmt[l_bmt_n].bmt05=(l_bmt_n*10)
                      LET l_bmt_data=''                #clear l_bmt_data for next bmt06
                   ELSE 
                      IF l_bmt_i==bmt_arr_data.getLength() THEN 
                         LET l_bmt_n=l_bmt_n+1
                         LET l_bmt[l_bmt_n].bmt06=l_bmt_data
                         LET l_bmt[l_bmt_n].bmt07=(l_bmt_i mod 13)
                         LET l_bmt[l_bmt_n].bmt05=(l_bmt_n*10)
                         LET l_bmt_data=''                #clear l_bmt_data for next bmt06
                         LET l_bmt_total=l_bmt_n          #save the total lines of bmt_file to l_bmt_total for use to insert into bmt_file
                         LET l_bmt_n=0
                      END IF 
                   END IF 
                END FOR 
          ELSE 
             LET l_bmt_n=1
             LET l_bmt[l_bmt_n].bmt05=(l_bmt_n*10)
             LET l_bmt[l_bmt_n].bmt06=l_tmp_data
             LET l_bmb13_Sep=','
             CALL aws_Tokenizer(l_bmb13_tmp_data,l_bmb13_Sep,bmt_arr_data)
             LET l_bmt[l_bmt_n].bmt07=bmt_arr_data.getLength()
             LET l_bmt_total=l_bmt_n          #save the total lines of bmt_file to l_bmt_total for use to insert into bmt_file
             LET l_bmt_n=0
          END IF 
       END IF 
     END IF 
 
      #根據欄位名稱找到欄位類型,如果該欄位是字符串,則在對應的value前后加上',否則不作處理,日期型則在前后增加to_date轉換函數
      SELECT wac06 INTO l_type FROM wac_file 
        WHERE wac01 = l_ObjectID AND wac03 = l_tmp_field
      IF l_type <>'D' THEN
         IF l_type = 'C' THEN 
            IF l_tmp_data.getIndexOf("'",1) THEN   #adjust by binbin for special char: '
               LET l_tmp_data = "\"",l_tmp_data ,"\""
            ELSE 
               LET l_tmp_data = "'",l_tmp_data ,"'"
            END IF 
         ELSE 
            LET l_tmp_data = "'",l_tmp_data ,"'"
         END IF 
      ELSE 
         IF l_type = 'D' THEN
#No.FUN-9C0073 ----BEGIN
#            LET l_tmp_data = "to_date('",l_tmp_data,"','",p_dateformat,"')"
            LET l_tmp_data = "CAST('",l_tmp_data,"' AS '",p_dateformat,"')"
#No.FUN-9C0073 ----END
         END IF 
      END IF 
      #組成欄位列表和值列表
      IF cl_null(l_field) THEN 
         LET l_field = l_tmp_field
         LET l_data = l_tmp_data
      ELSE 
         LET l_field = l_field,",",l_tmp_field
         LET l_data = l_data,",",l_tmp_data
      END IF     
    END FOR 
    
    IF NOT cl_null(def_field) AND NOT cl_null(def_data) THEN 
       LET l_field = l_field,",",def_field
       LET l_data = l_data,",",def_data
    END IF 
 
    #因為UpdateBOM中間可能會傳一些什么都沒有的空記錄，為了避免錯誤，所以這里要加一個判別來忽略這些東西
    IF ( NOT cl_null(rec_data[p_index].body[i].tables)) AND ( NOT cl_null(l_field)) AND (NOT cl_null(l_data)) THEN 
       LET l_sql = "INSERT INTO ",rec_data[p_index].body[i].tables,"(",l_field,") VALUES(",l_data,")"
       PREPARE body_cs FROM l_sql
       EXECUTE body_cs
 
        
       IF SQLCA.sqlcode THEN
          LET l_errDesc = '\n<Row Table="',rec_data[p_index].body[i].tables,'" Field="',rec_data[p_index].body[i].fields,
                          '" Data="',rec_data[p_index].body[i].data,'" Error="',SQLCA.sqlCode,'" Desc="',cl_getmsg("aws-255",g_lang),'" />\n'  
          RETURN 'aws-225',l_errDesc
       END IF
       
       IF l_ObjectID='BOM' AND SQLCA.sqlcode==0 AND NOT cl_null(l_bmb13_tmp_data) THEN 
          FOR l_bmt_n=1 TO l_bmt_total
             IF l_bmt[l_bmt_n].bmt05 THEN
                LET l_sql = "INSERT INTO bmt_file(bmt01,bmt02,bmt03,bmt04,bmt05,bmt06,bmt07,bmt08) values('",l_bmb01,"','",l_bmb02,"','",l_bmb03,"','",l_bmb04,"','",l_bmt[l_bmt_n].bmt05,"','",l_bmt[l_bmt_n].bmt06,"','",l_bmt[l_bmt_n].bmt07,"',' ')"
                PREPARE bmt_cs FROM l_sql
                EXECUTE bmt_cs
                IF SQLCA.sqlcode THEN
                   LET l_errDesc = cl_getmsg("aws-451",g_lang),"SQLCA.sqlcode=",SQLCA.sqlcode
                   RETURN 'aws-451',l_errDesc
                END IF 
             END IF
          END FOR 
       END IF 
       
    END IF 
 
    
    #------------------插入Detail表---------------------
    FOR j=1 TO rec_data[p_index].body[i].detail.getLength()
      LET def_field = ''
      LET def_data = ''
      LET l_field = ''
      LET l_data = ''
      CALL aws_default_data(l_ObjectID,'detail',l_Sep,rec_data,p_index,p_dateformat) RETURNING def_field,def_data
      CALL aws_Tokenizer(rec_data[p_index].body[i].detail[j].fields,l_Sep,arr_field)
      CALL aws_Tokenizer(rec_data[p_index].body[i].detail[j].data,l_Sep,arr_data)
      FOR l_i = 1 TO arr_field.getLength()
          LET l_tmp_field = arr_field[l_i]
          LET l_tmp_data = arr_data[l_i]
        #根據欄位名稱找到欄位類型,如果該欄位是字符串,則在對應的value前后加上',否則不作處理,日期型則在前后增加to_date轉換函數
        SELECT wac06 INTO l_type FROM wac_file 
          WHERE wac01 = l_ObjectID AND wac03 = l_tmp_field
        IF l_type <>'D' THEN 
           IF l_type = 'C' THEN 
              IF l_tmp_data.getIndexOf("'",1) THEN #adjust by binbin for special char: '
                 LET l_tmp_data = "\"",l_tmp_data ,"\""
              ELSE 
                 LET l_tmp_data = "'",l_tmp_data ,"'"
              END IF 
           ELSE 
              LET l_tmp_data = "'",l_tmp_data ,"'"
           END IF 
        ELSE 
           IF l_type = 'D' THEN
#No.FUN-9C0073 ---BEGIN
#              LET l_tmp_data = "to_date('",l_tmp_data,"','",p_dateformat,"')"
              LET l_tmp_data = "CAST('",l_tmp_data,"' AS '",p_dateformat,"')"
#No.FUN-9C0073 ---END
           END IF 
        END IF 
        #組成欄位列表和值列表
        IF cl_null(l_field) THEN 
           LET l_field = l_tmp_field
           LET l_data = l_tmp_data
        ELSE 
           LET l_field = l_field,",",l_tmp_field
           LET l_data = l_data,",",l_tmp_data
        END IF     
      END FOR 
      
      IF NOT cl_null(def_field) AND NOT cl_null(def_data) THEN 
         LET l_field = l_field,",",def_field
         LET l_data = l_data,",",def_data
      END IF 
 
      #因為UpdateBOM中間可能會傳一些什么都沒有的空記錄，為了避免錯誤，所以這里要加一個判別來忽略這些東西
      IF ( NOT cl_null(rec_data[p_index].body[i].detail[j].tables)) AND ( NOT cl_null(l_field)) AND (NOT cl_null(l_data)) THEN 
         LET l_sql = "INSERT INTO ",rec_data[p_index].body[i].detail[j].tables,"(",l_field,") values(",l_data,")"
         PREPARE detail_cs FROM l_sql
         EXECUTE detail_cs
         IF SQLCA.sqlcode THEN
            LET l_errDesc = '\n<Row Table="',rec_data[p_index].body[i].detail[j].tables,'" Field="',rec_data[p_index].body[i].detail[j].fields,
                            '" Data="',rec_data[p_index].body[i].detail[j].data,'" Error="',SQLCA.sqlCode,'" Desc="',cl_getmsg("aws-229",g_lang),'" />\n'
            RETURN 'aws-229',l_errDesc
         END IF
      END IF
      
      #------------------插入SubDetail表---------------------
      FOR k=1 TO rec_data[p_index].body[i].detail[j].subdetail.getLength()
        LET def_field = ''
        LET def_data = ''
        LET l_field = ''
        LET l_data = ''
        CALL aws_default_data(l_ObjectID,'subdetail',l_Sep,rec_data,p_index,p_dateformat) RETURNING def_field,def_data
       CALL aws_Tokenizer(rec_data[p_index].body[i].detail[j].subdetail[k].fields,l_Sep,arr_field)
       CALL aws_Tokenizer(rec_data[p_index].body[i].detail[j].subdetail[k].data,l_Sep,arr_data)
       FOR l_i = 1 TO arr_field.getLength()
           LET l_tmp_field = arr_field[l_i]
           LET l_tmp_data = arr_data[l_i]
          #根據欄位名稱找到欄位類型,如果該欄位是字符串,則在對應的value前后加上',否則不作處理,日期型則在前后增加to_date轉換函數
          SELECT wac06 INTO l_type FROM wac_file 
            WHERE wac01 = l_ObjectID AND wac03 = l_tmp_field
          IF l_type <>'D' THEN 
             IF l_type = 'C' THEN 
                IF l_tmp_data.getIndexOf("'",1) THEN  #adjust by binbin for special char: '
                   LET l_tmp_data = "\"",l_tmp_data ,"\""
                ELSE 
                   LET l_tmp_data = "'",l_tmp_data ,"'"
                END IF 
             ELSE 
                LET l_tmp_data = "'",l_tmp_data ,"'"
             END IF 
          ELSE 
             IF l_type = 'D' THEN
#No.FUN-9C0073 ---BEGIN
#                LET l_tmp_data = "to_date('",l_tmp_data,"','",p_dateformat,"')"
                LET l_tmp_data = "CAST('",l_tmp_data,"' AS '",p_dateformat,"')"
#No.FUN-9C0073 ---END
             END IF 
          END IF 
          #組成欄位列表和值列表
          IF cl_null(l_field) THEN 
             LET l_field = l_tmp_field
             LET l_data = l_tmp_data
          ELSE 
             LET l_field = l_field,",",l_tmp_field
             LET l_data = l_data,",",l_tmp_data
          END IF   
        END FOR   
        
        IF NOT cl_null(def_field) AND NOT cl_null(def_data) THEN 
           LET l_field = l_field,",",def_field
           LET l_data = l_data,",",def_data
        END IF 
        
        #因為UpdateBOM中間可能會傳一些什么都沒有的空記錄，為了避免錯誤，所以這里要加一個判別來忽略這些東西
        IF ( NOT cl_null(rec_data[p_index].body[i].detail[j].subdetail[k].tables)) AND ( NOT cl_null(l_field)) AND (NOT cl_null(l_data)) THEN 
           LET l_sql = "INSERT INTO ",rec_data[p_index].body[i].detail[j].subdetail[k].tables,"(",l_field,") values(",l_data,")"
           PREPARE sdetail_cs FROM l_sql
           EXECUTE sdetail_cs
           IF SQLCA.sqlcode THEN
              LET l_errDesc = '\n<Row Table="',rec_data[p_index].body[i].detail[j].subdetail[k].tables,'" Field="',rec_data[p_index].body[i].detail[j].subdetail[k].fields,
                              '" Data="',rec_data[p_index].body[i].detail[j].subdetail[k].data,'" Error="',SQLCA.sqlCode,'" Desc="',cl_getmsg("aws-230",g_lang),'" />\n'
              RETURN 'aws-230',l_errDesc
           END IF
        END IF 
      END FOR        
    END FOR   
  END FOR   
 
  #成功了
  RETURN '',''
END FUNCTION
 
#按對象刪除數據
#解法解密︰拼成一個如下的sql語句
#DELETE FROM c_file WHERE rowi IN ( SELECT c_file.rowi from c_file,b_file,a_file where c001 = b001 and c002 = b002 and b001 = a001 and a like 'C%');
FUNCTION DB_DELETE(p_objectid,l_Sep,rec_data,p_index,p_DateFormat)
DEFINE
  p_DateFormat     STRING,
  p_objectid       STRING,
  v_ObjectID       LIKE waa_file.waa01,
  l_Sep            STRING,
  l_errDesc        STRING,
  i,j,k,l          LIKE type_file.num5,
  l_sql            STRING,
  p_index          LIKE type_file.num5,
  sb_field         base.stringTokenizer,
  sb_data          base.stringTokenizer,
  l_wab02          LIKE wab_file.wab02,     #表名稱
  l_wac03          LIKE wac_file.wac03,     #欄位名稱
  l_wac06          LIKE wac_file.wac06,     #欄位數據類型
  l_field          STRING,
  l_data           STRING,
  l_where          STRING,
  l_htable         LIKE wab_file.wab05,
  l_btable         LIKE wab_file.wab05,
  l_dtable         LIKE wab_file.wab05,
  l_sdtable        LIKE wab_file.wab05,
 
  #各表之間的關聯欄位
  l_brelation      LIKE wab_file.wab07,    #Head -> Body
  l_drelation      LIKE wab_file.wab07,    #Body -> Detail
  l_sdrelation     LIKE wab_file.wab07,    #Detail -> SubDetail
  
  rec_data        DYNAMIC ARRAY OF RECORD
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
 
DEFINE l_i        LIKE type_file.num5
DEFINE arr_field DYNAMIC ARRAY OF STRING
DEFINE arr_data  DYNAMIC ARRAY OF STRING
    
    
  LET v_ObjectID = p_objectid  
  #說明︰DELETE操作的執行過程比較特殊了，實際上用戶只需要傳入主表中的鍵值，就可以完成刪除動作，
  #而且刪除語句大部分的拼接都可以通過wab,wac兩個表中的關聯得到
    
  #要找到Head表對應的主鍵以及數據集中傳遞的對應Value并按其合成DELETE語句的Where條件子句
  LET l_where = ''
  LET l_htable = rec_data[p_index].tables
  DECLARE sel_cs CURSOR FOR 
    SELECT wac03,wac06 FROM wac_file WHERE wac01 = v_ObjectID AND wac02 = l_htable AND wac08 = 'Y'
  #循環每一個主鍵欄位，合成DELETE預計中的WHERE條件  
  FOREACH sel_cs INTO l_wac03,l_wac06
    CALL aws_Tokenizer(rec_data[p_index].fields,l_Sep,arr_field)
    CALL aws_Tokenizer(rec_data[p_index].data,l_Sep,arr_data)
    FOR l_i = 1 TO arr_field.getLength()
       LET l_field = arr_field[l_i]
       LET l_data = arr_data[l_i]
   
      #找到主鍵欄位，生成一個“欄位＝值”的語句并將其添加到Where條件中去
      IF l_field = l_wac03 THEN 
         LET l_where = aws_MakeSubStr(l_where,l_field,l_data,l_wac06,'AND','=',p_dateformat)
         EXIT FOR 	   
      END IF 
    END FOR 
  END FOREACH 
  
  #DELETE語句不允許不下條件，避免誤刪除所有數據
  IF cl_null(l_where) THEN 
     LET l_errDesc = cl_getmsg("aws-224",g_lang)
     RETURN 'aws-224',l_errDesc
    #RETURN 'aws-224','DELETE操作不能忽略條件'
  ELSE 
     LET l_where = ' WHERE ',l_where
  END IF 
 
  #刪除記錄要倒著來，從SubDetail往上走，一直到Head
 
  #得到該對象的Body表和從Head到Body的關系
  SELECT wab05,wab07 INTO l_btable,l_brelation FROM wab_file WHERE wab01 = v_ObjectID AND wab08 = 'Head'
  #如果有Body表(且有對應的關聯欄位)才繼續向下尋找
  IF (NOT cl_null(l_btable))AND(NOT cl_null(l_brelation)) THEN 
     #得到該對象的Detail表和從Body到Detail的關系
     SELECT wab05,wab07 INTO l_dtable,l_drelation FROM wab_file WHERE wab01 = v_ObjectID AND wab08 = 'Body'
     #如果有Detail表(且有對應的關聯欄位)才繼續向下尋找
     IF (NOT cl_null(l_dtable))AND(NOT cl_null(l_drelation)) THEN 
        #得到該對象的SubDetail表和從Detail到SubDetail的關系
        SELECT wab05,wab07 INTO l_sdtable,l_sdrelation FROM wab_file WHERE wab01 = v_ObjectID AND wab08 = 'Detail'

        #如果有SubDetail表(且有對應的關聯欄位)則先從該表中刪除數據
        IF (NOT cl_null(l_sdtable))AND(NOT cl_null(l_sdrelation)) THEN 
           #LET l_sql = 'DELETE FROM ',l_sdtable,' WHERE Rowid in ( SELECT ',l_sdtable,'.rowid ',
           #                                                        ' FROM ',l_htable,',',l_btable,',',l_dtable,',',l_sdtable,
           #                                                                 l_where,
           #                                                         ' AND ',l_brelation,
           #                                                         ' AND ',l_drelation,
           #                                                         ' AND ',l_sdrelation,')'
           PREPARE del_sdetail_cs FROM l_sql
           EXECUTE del_sdetail_cs
           IF SQLCA.sqlcode THEN         
              LET l_errDesc = '\n<Row Table="',l_htable,'" Field="',rec_data[p_index].fields,
                              '" Data="',rec_data[p_index].data,'" Error="',SQLCA.sqlCode,'" Desc="',cl_getmsg("aws-223",g_lang),'" />\n'
              RETURN 'aws-223',l_errDesc
           END IF   
        END IF                          
        #刪除Detail表中的記錄
        #LET l_sql = 'DELETE FROM ',l_dtable,' WHERE rowid in ( SELECT ',l_dtable,'.rowid FROM ',l_htable,',',
        #            l_btable,',',l_dtable,l_where,' AND ',l_brelation,' AND ',l_drelation,')'
        PREPARE del_detail_cs FROM l_sql
        EXECUTE del_detail_cs
        IF SQLCA.sqlcode THEN         
           LET l_errDesc = '\n<Row Table="',l_htable,'" Field="',rec_data[p_index].fields,
                           '" Data="',rec_data[p_index].data,'" Error="',SQLCA.sqlCode,'" Desc="',cl_getmsg("aws-222",g_lang),'" />\n'
           RETURN 'aws-222',l_errDesc
        END IF            
     END IF 
     #刪除Body表中的記錄
     #LET l_sql = 'DELETE FROM ',l_btable,' WHERE rowid in ( SELECT ',l_btable,'.rowid FROM ',l_htable,',',
     #            l_btable,l_where,' AND ',l_brelation,')'
     PREPARE del_body_cs FROM l_sql
     EXECUTE del_body_cs
     IF SQLCA.sqlcode THEN         
        LET l_errDesc = '\n<Row Table="',l_htable,'" Field="',rec_data[p_index].fields,
                        '" Data="',rec_data[p_index].data,'" Error="',SQLCA.sqlCode,'" Desc="',cl_getmsg("aws-221",g_lang),'" />\n'
        RETURN 'aws-221',l_errDesc
     END IF 
  END IF 
 
  #刪除Head表中的記錄
  LET l_sql = 'DELETE FROM ',l_htable,l_where
  PREPARE del_head_cs FROM l_sql
  EXECUTE del_head_cs
  IF SQLCA.sqlcode THEN         
     LET l_errDesc = '\n<Row Table="',l_htable,'" Field="',rec_data[p_index].fields,
                     '" Data="',rec_data[p_index].data,'" Error="',SQLCA.sqlCode,'" Desc="',cl_getmsg("aws-228",g_lang),'" />\n'
     RETURN 'aws-228',l_errDesc
  END IF              	
  
  #成功了
  RETURN '',''
 
END FUNCTION

#No.FUN-9C0073 ----ADD BEGIN
{
FUNCTION aws-get_pk(l.zta01)
   DEFINE l_zta01  LIKE zta_file.zta01
   DEFINE  l_column_name   LIKE ztd_file.ztd13
   DEFINE  l_position      LIKE ztd_file.ztd14
   DEFINE  l_cnt           LIKE type_file.num5
   DEFINE l_sql    STRING

         #取得 Constraint 資料
   LET l_cnt = 1
      LET l_sql = "SELECT LOWER(CONSTRAINT_NAME),CONSTRAINT_TYPE,DELETE_RULE,",
                  "       STATUS,DEFERRABLE,DEFERRED,VALIDATED, ",
                  "       LOWER(R_OWNER), LOWER(R_CONSTRAINT_NAME), ",
                  "       SEARCH_CONDITION ",
                  "  FROM ALL_CONSTRAINTS ",
#                  " WHERE LOWER(OWNER)='",l_schema,"' ",
                  " WHERE LOWER(OWNER)='",g_plant,"' ",
                  "   AND LOWER(TABLE_NAME)='", l_zta01 CLIPPED,"'",
                   "  AND CONSTRAINT_NAME NOT like \"SYS_%\""

      DECLARE p_ztd1_cs CURSOR FROM l_sql
      FOREACH p_ztd1_cs INTO g_ztd[l_cnt].ztd03
#                           ,g_ztd[l_cnt].ztd04,l_ztd.ztd08,
#                           l_ztd.ztd09,l_ztd.ztd10,l_deferred,l_ztd.ztd11,
#                           g_ztd[l_cnt].ztd06,g_ztd[l_cnt].ztd07,g_ztd[l_cnt].ztd05

         #取得 PrimaryKey Columns 及 position
         LET l_sql = "SELECT LOWER(COLUMN_NAME),LOWER(POSITION) FROM ALL_CONS_COLUMNS",
#                     " WHERE LOWER(OWNER)='",l_schema,"' ",
                     " WHERE LOWER(OWNER)='",g_plant,"' ",
                     "   AND LOWER(TABLE_NAME) ='",l_zta01 CLIPPED,"' ",
                     "   AND LOWER(CONSTRAINT_NAME) ='",g_ztd[l_cnt].ztd03 CLIPPED,"' ",
                     " ORDER BY POSITION "

         DECLARE p_ztd4_cs CURSOR FROM l_sql
         FOREACH p_ztd4_cs INTO l_column_name,l_position
             IF cl_null(g_ztd[l_cnt].ztd13) THEN
                LET g_ztd[l_cnt].ztd13 = l_column_name CLIPPED
                LET g_ztd[l_cnt].into = "l_",l_column_name CLIPPED
                
             ELSE
                LET g_ztd[l_cnt].ztd13 = g_ztd[l_cnt].ztd13 CLIPPED,",",l_column_name CLIPPED
                LET g_ztd[l_cnt].into = g_ztd[l_cnt].into CLIPPED,",","l_",l_column_name CLIPPED
             END IF

             IF cl_null(g_ztd[l_cnt].ztd14) THEN
                LET g_ztd[l_cnt].ztd14 = l_position
             ELSE
                LET g_ztd[l_cnt].ztd14 = g_ztd[l_cnt].ztd14 CLIPPED,",",l_position
             END IF

         END FOREACH
         LET l_cnt = l_cnt + 1
      END FOREACH
      CALL g_ztd.deleteElement(l_cnt)

END FUNCTION
}
#No.FUN-9C0073 ----ADD END

 
#根據數據類型來組合 xxx = XXX AND yyy = 'YYY'這樣的子句的函數
#以上面的例子為例
#p_origin為初始的字符串
#p_field為xxx和yyy
#p_data為XXX和YYY
#p_type分別為N或C
#p_conn為AND
#p_oper為=
FUNCTION aws_MakeSubStr(p_origin,p_field,p_data,p_type,p_conn,p_oper,p_dateformat)
DEFINE
  p_origin       STRING,
  p_field        STRING,
  p_data         STRING,
  p_type         STRING,
  p_conn         STRING,
  p_oper         STRING,
  p_dateformat   STRING
  
  CASE p_type 
    WHEN 'C'
      IF cl_null(p_origin) THEN 
         IF p_data.getIndexOf("'",1) THEN    #adjust by binbin for special char: '  
            LET p_origin = p_field,' ',p_oper," \"",p_data,"\""
         ELSE 
            LET p_origin = p_field,' ',p_oper," '",p_data,"'"
         END IF 
      ELSE
         IF p_data.getIndexOf("'",1) THEN     #adjust by binbin for special char: '
            LET p_origin = p_field,' ',p_oper," \"",p_data,"\""
         ELSE 
            LET p_origin = p_field,' ',p_oper," '",p_data,"'"
         END IF 
      END IF 
    WHEN 'D'  
      IF cl_null(p_origin) THEN
#No.FUN-9C0073 ---BEGIN
#         LET p_origin = p_field,' ',p_oper," to_date('",p_data,"','",p_dateformat,"')"
         LET p_origin = p_field,' ',p_oper," CAST('",p_data,"' AS '",p_dateformat,"')"
#No.FUN-9C0073 ---END
      ELSE
#No.FUN-9C0073 ---BEGIN
#         LET p_origin = p_origin,' ',p_conn,' ',p_field,' ',p_oper," to_date('",p_data,"','",p_dateformat,"')"
          LET p_origin = p_origin,' ',p_conn,' ',p_field,' ',p_oper," CAST('",p_data,"' AS '",p_dateformat,"')"
#No.FUN-9C0073 ---END
      END IF 
    OTHERWISE 
      IF cl_null(p_origin) THEN 
         LET p_origin = p_field,' ',p_oper,' ',p_data
      ELSE
         LET p_origin = p_origin,' ',p_conn,' ',p_field,' ',p_oper,' ',p_data
      END IF 
  END CASE 
  
  RETURN p_origin
END FUNCTION 
 
#按對象更新數據
#處理邏輯:從列表中拆解出每一個欄位及其對應的值,并在SET子句中組合成"欄位=值"這樣的樣式
#在組合的時候要考慮字符串,日期型的轉換問題,同時要看該欄位是不是主鍵,如果是的話則要把對應
#的"欄位=值"添加到WHERE子句中去
#對于Head,Body,Detail和SubDetail四個級別的數組分別循環做同樣的事情
FUNCTION DB_UPDATE(p_objectid,p_sep,rec_data,p_index,p_dateformat)
DEFINE
  p_objectid            LIKE wac_file.wac01,
  p_sep                 STRING,
  p_index               LIKE type_file.num5,
  p_dateformat          STRING,
  k,l,m                 LIKE type_file.num5,
 
  l_errCode,l_errDesc   STRING,
  lst_field,lst_value   base.stringTokenizer,
  l_field               LIKE wac_file.wac03,
  l_value               STRING,
  l_set,l_where,l_sql   STRING,
 
  l_wac06               LIKE wac_file.wac06,
  l_wac08               LIKE wac_file.wac08,
  
  rec_data        DYNAMIC ARRAY OF RECORD
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
 
 
DEFINE l_i        LIKE type_file.num5
DEFINE arr_field DYNAMIC ARRAY OF STRING
DEFINE arr_data  DYNAMIC ARRAY OF STRING
  #-----------更新Head表-----------------
 
  #依次循環分析每一筆欄位和對應的值
  CALL aws_Tokenizer(rec_data[p_index].fields,p_Sep,arr_field)
  CALL aws_Tokenizer(rec_data[p_index].data,p_Sep,arr_data)
  FOR l_i = 1 TO arr_field.getLength()
     LET l_field = arr_field[l_i]
     LET l_value = arr_data[l_i]
    
    #首先處理SET子句部分
    #如果碰到欄位值設置成%%，則需要把sql組成"欄位=欄位"的形式,即保持欄位現有的值不變
    IF l_value = "%%" THEN
       LET l_set = aws_MakeSubStr(l_set,l_field,l_field,'Not Need',',','=','Not Need')
    ELSE 
       #如果欄位值不是%%則用把sql組成"欄位=值"的形式
       SELECT wac06,wac08 INTO l_wac06,l_wac08 FROM wac_file 
         WHERE wac01 = p_objectid AND wac03 = l_field
       #根據欄位的類型來分別處理SET子句的樣式  
       LET l_set = aws_MakeSubStr(l_set,l_field,l_value,l_wac06,',','=',p_dateformat)
    END IF 
    
    #判斷該欄位是不是主鍵欄位,如果是,則加入到WHERE子句中去
    IF l_wac08 = 'Y' THEN 
       LET l_where = aws_MakeSubStr(l_where,l_field,l_value,l_wac06,'AND','=',p_dateformat)
    END IF     
  END FOR 
  
  #將各個子句拼接成一個完整的UPDATE語句
  LET l_sql = "UPDATE ",rec_data[p_index].tables," SET ",l_set," WHERE ",l_where
  PREPARE update_cs FROM l_sql
  #執行該SQL語句對Head表進行更新
  EXECUTE update_cs
  IF SQLCA.sqlcode THEN
     LET l_errDesc = '\n<Row Table="',rec_data[p_index].tables,'" Field="',rec_data[p_index].fields,
                     '" Data="',rec_data[p_index].data,'" Error="',SQLCA.sqlCode,'" Desc="',cl_getmsg("aws-248",g_lang),'" />\n'
     RETURN 'aws-248',l_errDesc
  END IF
  
  #-----------更新Body表-----------------
  FOR k = 1 TO rec_data[p_index].body.getLength() 
    #依次循環分析每一筆欄位和對應的值
    CALL aws_Tokenizer(rec_data[p_index].body[k].fields,p_Sep,arr_field)
    CALL aws_Tokenizer(rec_data[p_index].body[k].data,p_Sep,arr_data)
    FOR l_i = 1 TO arr_field.getLength()
       LET l_field = arr_field[l_i]
       LET l_value = arr_data[l_i]
      
      #首先處理SET子句部分
      #如果碰到欄位值設置成%%，則需要把sql組成"欄位=欄位"的形式,即保持欄位現有的值不變
      IF l_value = "%%" THEN
         LET l_set = aws_MakeSubStr(l_set,l_field,l_field,'Not Need',',','=','Not Need')
      ELSE 
         #如果欄位值不是%%則用把sql組成"欄位=值"的形式
         SELECT wac06,wac08 INTO l_wac06,l_wac08 FROM wac_file 
           WHERE wac01 = p_objectid AND wac03 = l_field
         #根據欄位的類型來分別處理SET子句的樣式  
         LET l_set = aws_MakeSubStr(l_set,l_field,l_value,l_wac06,',','=',p_dateformat)
      END IF 
      
      #判斷該欄位是不是主鍵欄位,如果是,則加入到WHERE子句中去
      IF l_wac08 = 'Y' THEN 
         LET l_where = aws_MakeSubStr(l_where,l_field,l_value,l_wac06,'AND','=',p_dateformat)
      END IF  
     END FOR    
  
    #將各個子句拼接成一個完整的UPDATE語句
    LET l_sql = "UPDATE ",rec_data[p_index].body[k].tables," SET ",l_set," WHERE ",l_where 
    PREPARE update_cs_body FROM l_sql
    EXECUTE update_cs_body
    IF SQLCA.sqlcode THEN
       LET l_errDesc = '\n<Row Table="',rec_data[p_index].body[k].tables,'" Field="',rec_data[p_index].body[k].fields,
                       '" Data="',rec_data[p_index].body[k].data,'" Error="',SQLCA.sqlCode,'" Desc="',cl_getmsg("aws-249",g_lang),'" />\n'
       RETURN 'aws-249',l_errDesc
    END IF
    
    #-----------更新Detail表-----------------
    FOR l = 1 TO rec_data[p_index].body[k].detail.getLength()
      #依次循環分析每一筆欄位和對應的值
     
      CALL aws_Tokenizer(rec_data[p_index].body[k].detail[l].fields,p_Sep,arr_field)
      CALL aws_Tokenizer(rec_data[p_index].body[k].detail[l].data,p_sep,arr_data)
      FOR l_i = 1 TO arr_field.getLength()
          LET l_field = arr_field[l_i]
          LET l_value = arr_data[l_i] 
        #首先處理SET子句部分
        #如果碰到欄位值設置成%%，則需要把sql組成"欄位=欄位"的形式,即保持欄位現有的值不變
        IF l_value = "%%" THEN
           LET l_set = aws_MakeSubStr(l_set,l_field,l_field,'Not Need',',','=','Not Need')
        ELSE 
           #如果欄位值不是%%則用把sql組成"欄位=值"的形式
           SELECT wac06,wac08 INTO l_wac06,l_wac08 FROM wac_file 
             WHERE wac01 = p_objectid AND wac03 = l_field
           #根據欄位的類型來分別處理SET子句的樣式  
           LET l_set = aws_MakeSubStr(l_set,l_field,l_value,l_wac06,',','=',p_dateformat)
        END IF 
        
        #判斷該欄位是不是主鍵欄位,如果是,則加入到WHERE子句中去
        IF l_wac08 = 'Y' THEN 
           LET l_where = aws_MakeSubStr(l_where,l_field,l_value,l_wac06,'AND','=',p_dateformat)
        END IF     
      END FOR 
      
      #將各個子句拼接成一個完整的UPDATE語句
      LET l_sql = "UPDATE ",rec_data[p_index].body[k].detail[l].tables," SET ",l_set," WHERE ",l_where
      PREPARE update_cs_detail FROM l_sql
      EXECUTE update_cs_detail
      IF SQLCA.sqlcode THEN
         LET l_errDesc = '\n<Row Table="',rec_data[p_index].body[k].detail[l].tables,'" Field="',rec_data[p_index].body[k].detail[l].fields,
                         '" Data="',rec_data[p_index].body[k].detail[l].data,'" Error="',SQLCA.sqlCode,'" Desc="',cl_getmsg("aws-250",g_lang),'" />\n'
         RETURN 'aws-250',l_errDesc
      END IF
      
      #-----------更新SubDetail表-----------------
      FOR m = 1 TO rec_data[p_index].body[k].detail[l].subdetail.getLength()
        #依次循環分析每一筆欄位和對應的值
        CALL aws_Tokenizer(rec_data[p_index].body[k].detail[l].subdetail[m].fields,p_Sep,arr_field)
        CALL aws_Tokenizer(rec_data[p_index].body[k].detail[l].subdetail[m].data,p_sep,arr_data)
        FOR l_i = 1 TO arr_field.getLength()
            LET l_field = arr_field[l_i]
            LET l_value = arr_data[l_i]
          
          #首先處理SET子句部分
          #如果碰到欄位值設置成%%，則需要把sql組成"欄位=欄位"的形式,即保持欄位現有的值不變
          IF l_value = "%%" THEN
             LET l_set = aws_MakeSubStr(l_set,l_field,l_field,'Not Need',',','=','Not Need')
          ELSE 
             #如果欄位值不是%%則用把sql組成"欄位=值"的形式
             SELECT wac06,wac08 INTO l_wac06,l_wac08 FROM wac_file 
               WHERE wac01 = p_objectid AND wac03 = l_field
             #根據欄位的類型來分別處理SET子句的樣式  
             LET l_set = aws_MakeSubStr(l_set,l_field,l_value,l_wac06,',','=',p_dateformat)
          END IF 
          
          #判斷該欄位是不是主鍵欄位,如果是,則加入到WHERE子句中去
          IF l_wac08 = 'Y' THEN 
             LET l_where = aws_MakeSubStr(l_where,l_field,l_value,l_wac06,'AND','=',p_dateformat)
          END IF     
        END FOR 
        
        #將各個子句拼接成一個完整的UPDATE語句
        LET l_sql = "UPDATE ",rec_data[p_index].body[k].detail[l].subdetail[m].tables," SET ",l_set," WHERE ",l_where
        PREPARE update_cs_subdetail FROM l_sql
        EXECUTE update_cs_subdetail
        IF SQLCA.sqlcode THEN
           LET l_errDesc = '\n<Row Table="',rec_data[p_index].body[k].detail[l].subdetail[m].tables,'" Field="',rec_data[p_index].body[k].detail[l].subdetail[m].fields,
                           '" Data="',rec_data[p_index].body[k].detail[l].subdetail[m].data,'" Error="',SQLCA.sqlCode,'" Desc="',cl_getmsg("aws-251",g_lang),'" />\n'
           RETURN 'aws-251',l_errDesc
        END IF
      END FOR
    END FOR
  END FOR
 
  RETURN '',''
         
END FUNCTION
 
#按對象同步數據(說白了就是先刪除后添加)
FUNCTION DB_SYNC(p_objectid,l_Sep,rec_data,p_index,p_dateformat)
DEFINE
  p_dateformat     STRING,
  p_objectid       STRING,
  l_Sep            STRING,
  l_errCode        STRING,
  l_errDesc        STRING,
  i,j,k,l          LIKE type_file.num5,
  l_sql            STRING,
  p_index          LIKE type_file.num5,
  
  sb_field         base.stringBuffer,
  sb_data          base.stringBuffer,
  l_field          STRING,
  l_data           STRING,
  
  rec_data        DYNAMIC ARRAY OF RECORD
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
  
  #先刪除該對象
  CALL DB_DELETE(p_objectid,l_Sep,rec_data,p_index,p_dateformat) RETURNING l_errCode,l_errDesc
  IF NOT cl_null(l_errCode) THEN
     RETURN l_errCode,l_errDesc
  END IF 
  
  #先再新增該對象
  CALL DB_INSERT(p_objectid,l_Sep,rec_data,p_index,p_dateformat) RETURNING l_errCode,l_errDesc
  IF NOT cl_null(l_errCode) THEN
     RETURN l_errCode,l_errDesc
  END IF 
  
  #成功了
  RETURN '',''
END FUNCTION   
  
#按對象調整數據(如果不存在，則新增，存在則修改，與SYNC不同的是因為不做刪除動作，所以凡未
#被指定的欄位將保持原值而不是被初始化)
FUNCTION DB_ADJUST(p_objectid,l_Sep,rec_data,p_index,p_dateformat)
DEFINE
  p_objectid       STRING,
  p_dateformat     STRING,
  l_Sep            STRING,
  l_errCode        STRING,
  l_errDesc        STRING,
  i,j,k,l          LIKE type_file.num5,
  l_sql            STRING,
  p_index          LIKE type_file.num5,
  
  sb_field         base.stringBuffer,
  sb_data          base.stringBuffer,
  l_field          STRING,
  l_data           STRING,
  
  rec_data        DYNAMIC ARRAY OF RECORD
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
  
  #先試著插入該對象
  CALL DB_INSERT(p_objectid,l_Sep,rec_data,p_index,p_dateformat) RETURNING l_errCode,l_errDesc
  IF NOT cl_null(l_errCode) THEN
     #如果發現單頭主鍵重復則試著更新該對象
     IF l_errCode = 'aws-261' THEN 
        IF p_objectid='BOM' THEN
           CALL GenerateECN(l_Sep,rec_data,p_index,p_dateformat) RETURNING l_errCode,l_errDesc
        ELSE 
           CALL DB_UPDATE(p_objectid,l_Sep,rec_data,p_index,p_dateformat) RETURNING l_errCode,l_errDesc
        END IF 
        IF NOT cl_null(l_errCode) THEN
           RETURN l_errCode,l_errDesc
        ELSE 
           #執行AfterUpdate檢查
           CALL AfterUpdate(p_objectid,l_Sep,rec_data,p_index) RETURNING l_errCode,l_errDesc
           #如果After操作有錯，則直接返回了
           IF NOT cl_null(l_errCode) THEN
              RETURN l_errCode,l_errDesc
           END IF             	     
        END IF 
     ELSE
        RETURN l_errCode,l_errDesc
     END IF
  ELSE 
     #說明︰此處要在函數里面調用AfterInsert函數，因為對于DB_UPDATE動作而言，一旦操作執行完了，數據表中
     #肯定是有記錄的了，就沒有辦法分清本次實際執行的到底是Insert操作還是Update操作
     #只有這個點才能知道到底執行的是什么操作
     CALL AfterInsert(p_objectid,l_Sep,rec_data,p_index) RETURNING l_errCode,l_errDesc
     #如果After操作有錯，則直接返回了
     IF NOT cl_null(l_errCode) THEN
        RETURN l_errCode,l_errDesc
     END IF             	
  END IF 
  
  #成功了
  RETURN '',''
END FUNCTION   
 
#執行以下三個判別
#1.傳入的用戶名是否有效
#2.傳入的工廠名是否有效
#3.傳入的用戶是否有操作對應工廠數據的權限
FUNCTION aws_check_db_right(p_User,p_DB)
DEFINE
  p_User        LIKE zx_file.zx01,
  p_DB          LIKE azp_file.azp03,
  l_errCode     STRING,
  l_errDesc     STRING,
  l_cnt         LIKE type_file.num5
  
  #檢查用戶名是否有效
  SELECT COUNT(*) INTO l_cnt FROM zx_file WHERE 
    zx01 = p_User
  IF l_cnt = 0 THEN 
     LET l_errDesc = cl_getmsg("aws-255",g_lang)
     RETURN 'aws-255',l_errDesc
    #RETURN 'aws-255','傳入的用戶名無效'
  END IF   
    
  #檢查用戶名是否有效
  SELECT COUNT(*) INTO l_cnt FROM azp_file WHERE 
    azp01 = p_DB
  IF l_cnt = 0 THEN 
     LET l_errDesc = cl_getmsg("aws-256",g_lang)
     RETURN 'aws-256',l_errDesc
    #RETURN 'aws-256','傳入的數據庫無效'
  END IF   
    
  #檢查用戶是否有權限操作數據庫
  SELECT COUNT(*) INTO l_cnt FROM zxy_file WHERE 
    zxy01 = p_User AND (zxy03='ALL' OR zxy03='all' OR zxy03=p_DB)
  IF l_cnt = 0 THEN 
     LET l_errDesc = cl_getmsg("aws-254",g_lang)
     RETURN 'aws-254',l_errDesc
    #RETURN 'aws-254','該用戶無操作指定數據庫的權限'
  END IF   
  
  
  #通過檢查則返回正確結果
  RETURN '',''  
  
END FUNCTION
 
FUNCTION Server_GetReport(p_Param)
DEFINE l_Factory      LIKE azp_file.azp01,
       l_db           LIKE azp_file.azp03,
       l_User         LIKE zx_file.zx01,
       l_ReportID     LIKE zaw_file.zaw01,  #FUN-930132 STRING => zaw_file.zaw01
       l_FieldList    STRING, 
       l_Condition    STRING,
       l_SystemID     LIKE wag_file.wag01,
       l_TargetIP     LIKE wag_file.wag08,
       l_TargetPath   LIKE wag_file.wag09,
       l_name         STRING,
       l_cmd          STRING,
       l_errCode      STRING,
       l_errDesc      STRING,
       l_wae02        LIKE wae_file.wae02,
       l_wae03        LIKE wae_file.wae03,
       l_tokField     base.stringTokenizer,
       l_tokcond      base.stringTokenizer,
       l_tmpname      STRING,
       l_tmpvalue     STRING,
       i              LIKE type_file.num5,
       l_flag         LIKE type_file.num5,
       l_ch           base.Channel,
       lc_tty_no      LIKE type_file.chr37,
       l_param        DYNAMIC ARRAY OF RECORD
                      name    STRING,
                      value   STRING
       END RECORD,    
       l_sql          STRING,
       p_Param        DYNAMIC ARRAY OF RECORD   
         Tag          STRING,  
         Attribute    STRING,    
         Value        STRING  
       END RECORD,    
       l_tb           base.StringBuffer,
       l_sep          STRING,
       l_old,l_new    STRING
DEFINE l_i            LIKE type_file.num5
DEFINE arr_name       DYNAMIC ARRAY OF STRING
DEFINE arr_value      DYNAMIC ARRAY OF STRING
#--FUN-930132--start--
DEFINE l_CRtype       STRING,
       l_cnt          LIKE type_file.num5,
       l_cnt2         LIKE type_file.num5,
       l_cnt3         LIKE type_file.num5,     # FUN-A50022
       l_cnt4         LIKE type_file.num5,     # FUN-A50022
       l_wae12        LIKE wae_file.wae12,
       l_wae13        LIKE wae_file.wae13,
       l_wae14        LIKE wae_file.wae14,     # FUN-A50022 新增wae14欄位
       l_zaw03        LIKE zaw_file.zaw03,
       l_zaw08        LIKE zaw_file.zaw08,
       l_zaw10        LIKE zaw_file.zaw10,
       l_logFile      STRING,
       l_log          STRING,
       l_server       STRING,
       l_context_file STRING,
       l_str          STRING,
       l_hardcode_str STRING,
       l_template     LIKE zaa_file.zaa11
#--FUN-930132--end--
DEFINE l_nodeDocu     om.DomDocument,          # FUN-A60057 
       l_node         om.DomNode               # FUN-A60057 

 
  #檢查服務私有參數列表中是否包含Seperator的定義
  #如果沒有則使用全局變量
  LET l_sep = FindValue("Separator",p_Param)
  IF cl_null(l_sep) THEN
     LET l_sep = g_Separator
  END IF
   
  LET l_ReportID = FindValue("ReportID",p_Param)
  IF cl_null(l_ReportID) THEN
     LET l_errDesc = cl_getmsg("aws-218",g_lang)
     RETURN 'aws-218',l_errDesc,''
    #RETURN 'aws-218','缺少ReportID參數',''
  END IF
 
  #--FUN-930132--start-- 
  #抓取 CRtype參數，指定取得報表型式為 URL 或 XML
  LET l_CRtype = FindValue("CRtype",p_Param) CLIPPED
  LET l_CRtype = l_CRtype.toUpperCase()
  IF cl_null(l_CRtype) OR (l_CRtype<>"URL" AND l_CRtype<>"XML") THEN
     LET l_CRtype = "URL"
  END IF
  CALL FGL_SETENV("CRTYPE",l_CRtype)
  #--FUN-930132--end--
 
# MOD-AWS001 Added By Johnson 061024 固化PDM服務器IP
#  LET l_TargetIP = '192.168.0.80'
#
  #檢查服務私有參數列表中是否包含Factory的定義
  #如果沒有則使用全局變量  
  LET l_Factory = FindValue("Factory",p_Param)
  IF cl_null(l_Factory) THEN
     LET l_Factory = g_Factory
  END IF
  IF cl_null(l_Factory) THEN
     LET l_errDesc = cl_getmsg("aws-252",g_lang)
     RETURN 'aws-252',l_errDesc,''
    #RETURN 'aws-252','缺少Factory參數',''
  END IF
  LET g_plant = l_Factory    #FUN-930132 add
 
  #檢查服務私有參數列表中是否包含User的定義
  #如果沒有則使用全局變量  
  LET l_User = FindValue("User",p_Param)
  IF cl_null(l_User) THEN
     LET l_User = 'tiptop'      #FUN-930132 add
  END IF
  IF cl_null(l_User) THEN
     LET l_errDesc = cl_getmsg("aws-253",g_lang)
     RETURN 'aws-253',l_errDesc,''
  END IF
  LET g_user = l_User    #FUN-930132 add
 
  #--FUN-930132--start--
  #檢查指定用戶是否有權限操作該數據庫
  CALL aws_check_db_right(l_User,l_Factory) RETURNING l_errCode,l_errDesc
  IF NOT cl_null(l_errCode) THEN 
     RETURN l_errCode,l_errDesc,''
  END IF 
  #切換指定資料庫
  IF NOT aws_ttsrv_changeDatabase() THEN
     LET l_errDesc = cl_getmsg("aws-257",g_lang)
         RETURN 'aws-257',l_errDesc,''
        #RETURN 'aws-257','切換數據庫發生錯誤',''
  END IF
 
  #取得行業別設定
  SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
 
  #取得使用者權限
  SELECT zx04 INTO g_clas FROM zx_file where zx01 = g_user
 
  #檢查指定的報表是否在整合報表維護作業(awsi004)已存在
  LET l_SystemID = FindValue("SystemID",p_Param)            # FUN-A50022
  SELECT COUNT(*) INTO l_cnt FROM wae_file
   WHERE wae01 = l_ReportID AND wae13 = g_user AND 
          wae14 = l_SystemID                                # FUN-A50022 新增wae14欄位
  IF l_cnt = 0 THEN 
     SELECT COUNT(*) INTO l_cnt2 FROM wae_file
      WHERE wae01 = l_ReportID AND wae13 = "default"  AND   # FUN-A50022
            wae14 = l_SystemID                              # FUN-A50022 新增wae14欄位
     IF l_cnt2 = 0 THEN
     
        #----------FUN-A50022 modify start---------------------------------------------
        SELECT COUNT(*) INTO l_cnt3 FROM wae_file
          WHERE wae01 = l_ReportID AND wae13 = g_user  AND 
                wae14 = "default"                              
        IF l_cnt3 = 0 THEN
           SELECT COUNT(*) INTO l_cnt4 FROM wae_file
             WHERE wae01 = l_ReportID AND wae13 = "default"  AND 
                   wae14 = "default"
           IF l_cnt4 = 0 THEN 
        #----------FUN-A50022 modify end-----------------------------------------------
        
              LET l_errDesc = cl_getmsg("aws-215",g_lang)
              RETURN 'aws-215',l_errDesc,''        
        #----------FUN-A50022 modify start---------------------------------------------
           ELSE
              LET l_wae13 = "default"
              LET l_wae14 = "default"       
           END IF
        ELSE
           LET l_wae13 = g_user
           LET l_wae14 = "default"       
        END IF
        #----------FUN-A50022 modify end-----------------------------------------------   
     ELSE
        LET l_wae13 = "default"                             # FUN-A50022
        LET l_wae14 = l_SystemID                            # FUN-A50022 新增wae14欄位
     END IF
  ELSE
     LET l_wae13 = g_user
     LET l_wae14 = l_SystemID                               # FUN-A50022 新增wae14欄位
  END IF
  
  #----------FUN-A60057 modify start--------------------------------------------
  LET g_condition = FindValue("Condition",p_Param)
  IF NOT cl_null(g_condition) THEN
     #讀取 xml 檔中 Condition 的值
     LET l_nodeDocu = om.DomDocument.createFromXmlFile(g_condition)
     LET l_node = l_nodeDocu.getDocumentElement()
     LET l_node = l_node.getFirstChild()
     LET g_condition = l_node.getAttributeValue(1)
  ELSE
     LET g_condition = " 1=1 "
  END IF
  #----------FUN-A60057 modify end----------------------------------------------

  #抓取維護作業所設定的參數
  LET l_template = ""
  LET l_sql = "SELECT wae02,wae03,wae12 FROM wae_file",
              " WHERE wae01 = '", l_ReportID, "'",
                " AND wae13 = '", l_wae13, "'",
                " AND wae14 = '", l_wae14, "' ORDER BY wae02 "   # FUN-A50022 新增wae14欄位
  DECLARE c_wae CURSOR FROM l_sql
  FOREACH c_wae INTO l_wae02,l_wae03,l_wae12
     LET l_param[l_wae02].name = l_wae03
     #抓取CR樣板名稱
     IF l_param[l_wae02].name = "g_rpt_name" AND cl_null(l_wae12) THEN
        IF cl_null(l_template) THEN
           LET l_template = l_ReportID
        END IF
        #先判斷是否有客製以及行業別設定的資料
        LET l_zaw03 = "Y"
        LET l_zaw10 = g_sma.sma124
        SELECT COUNT(*) INTO l_cnt FROM zaw_file
         WHERE zaw01 = l_ReportID   AND zaw02 = l_template
           AND zaw03 = l_zaw03      AND zaw06 = g_lang
           AND zaw10 = l_zaw10
           AND ((zaw04='default' AND zaw05='default')
            OR zaw04 = g_clas OR zaw05 = g_user)
        IF l_cnt = 0 THEN
           LET l_zaw03 = "N"
           LET l_zaw10 = g_sma.sma124
           SELECT COUNT(*) INTO l_cnt FROM zaw_file
            WHERE zaw01 = l_ReportID   AND zaw02 = l_template
              AND zaw03 = l_zaw03      AND zaw06 = g_lang
              AND zaw10 = l_zaw10
              AND((zaw04='default' AND zaw05='default')
                   OR zaw04 = g_clas   OR zaw05=g_user)
           IF l_cnt = 0 THEN
              LET l_zaw03 = "Y"
              LET l_zaw10 = "std"
              SELECT COUNT(*) INTO l_cnt FROM zaw_file
               WHERE zaw01 = l_ReportID   AND zaw02 = l_template
                 AND zaw03 = l_zaw03      AND zaw06 = g_lang
                 AND zaw10 = l_zaw10
                 AND ((zaw04='default' AND zaw05='default')
                       OR zaw04 = g_clas   OR zaw05=g_user)
              IF l_cnt = 0 THEN
                 LET l_zaw03 = "N"
                 LET l_zaw10 = "std"
                 SELECT COUNT(*) INTO l_cnt FROM zaw_file
                  WHERE zaw01 = l_ReportID   AND zaw02 = l_template
                    AND zaw03 = l_zaw03      AND zaw06 = g_lang
                    AND zaw10 = l_zaw10
                    AND ((zaw04='default' AND zaw05='default')
                          OR zaw04 = g_clas   OR zaw05=g_user)
              END IF
           END IF
        END IF
        IF l_cnt >= 1 THEN
           SELECT COUNT(*) INTO l_cnt2 FROM zaw_file
            WHERE zaw01 = l_ReportID   AND zaw02 = l_template
              AND zaw03 = l_zaw03      AND zaw06 = g_lang
              AND zaw10 = l_zaw10
              AND zaw05 = g_user
           IF l_cnt2 > 0 THEN    #優先考慮抓g_user資料
              LET l_str = "SELECT zaw08 FROM zaw_file",
                          " WHERE zaw01='",l_ReportID,"' AND zaw02='",l_template,
                           "' AND zaw03='",l_zaw03,"' AND zaw06='",g_lang,
                           "' AND zaw10='",l_zaw10,"' AND zaw05='",g_user,"'"
           ELSE
              SELECT COUNT(*) INTO l_cnt2 FROM zaw_file
               WHERE zaw01 = l_ReportID   AND zaw02 = l_template
                 AND zaw03 = l_zaw03      AND zaw06 = g_lang
                 AND zaw10 = l_zaw10
                 AND zaw04 = g_clas
              IF l_cnt2 > 0 THEN   #否則抓此user所屬權限資料
                 LET l_str = "SELECT zaw08 FROM zaw_file",
                             " WHERE zaw01='",l_ReportID,"' AND zaw02='",l_template,
                              "' AND zaw03='",l_zaw03,"' AND zaw06='",g_lang,
                              "' AND zaw10='",l_zaw10,"' AND zaw04='",g_clas,"'"
              ELSE                 #若無g_user也無該權限資料，一律抓default資料
                 LET l_str = "SELECT zaw08 FROM zaw_file",
                             " WHERE zaw01='",l_ReportID,"' AND zaw02='",l_template,
                              "' AND zaw03='",l_zaw03,"' AND zaw06='",g_lang,
                              "' AND zaw10='",l_zaw10,"' AND zaw04='default",
                              "' AND zaw05='default'"
              END IF
           END IF
        END IF
        DISPLAY "sma124:",g_sma.sma124
        DISPLAY "Get CR:",l_str
        PREPARE pre_zaw08 FROM l_str
        EXECUTE pre_zaw08 INTO l_zaw08
        LET l_param[l_wae02].value = l_zaw08
     ELSE
        LET l_param[l_wae02].value = aws_defaultTranslate(l_wae12)
        IF l_param[l_wae02].name = "g_template" THEN
           LET l_template = l_param[l_wae02].value
        END IF
     END IF
  END FOREACH
 
  #抓取 hardcode 程式預設值
  CALL aws_get_report_hardcode(l_ReportID) RETURNING l_hardcode_str
  FOR i = 1 TO l_param.getLength()
      LET l_wae12 = aws_xml_getTag(l_hardcode_str,l_param[i].name)
      IF NOT cl_null(l_wae12) THEN
         LET l_param[i].value = l_wae12
      END IF
  END FOR
 
  #配置語言別為client端指定的語言
  UPDATE zx_file SET zx06 = g_lang WHERE zx01 = g_user
 
  #增加判斷當 CRtype 為 URL 或 XML 時，不 export FGLSERVER 和 TARGETPATH
  IF (l_CRtype = "URL") OR (l_CRtype = "XML") THEN
     LET l_cmd = l_ReportID
  ELSE
     #整合屬於背景執行時，FGLGUI 為 0
     CALL FGL_SETENV("FGLGUI",0)                        #FUN-9C0008
     CALL FGL_SETENV("FGLSERVER",l_TargetIP CLIPPED)
     CALL FGL_SETENV("TARGETPATH",l_TargetPath CLIPPED)
     IF os.Path.chdir(FGL_GETENV("TEMPDIR")) THEN END IF 
     LET l_cmd = "exe2 ",l_ReportID    
  END IF
  #將欲傳入之參數依序填上
  FOR i = 1 TO l_param.getLength()
      #LET l_cmd = l_cmd, " '", l_param[i].value, "'"     #FUN-A60057 mark
      LET l_cmd = l_cmd, ' "', l_param[i].value, '"'      #FUN-A60057
  END FOR
 
  DISPLAY "CRtype:",l_CRtype
  DISPLAY "l_cmd:",l_cmd
 
  IF l_CRtype = "URL" OR l_CRtype = "XML" THEN
     #指定 URL 及 XML 要寫入檔案
     LET l_logFile = "GetReport-",FGL_GETPID() USING '<<<<<<<<<<',".log"      #FUN-9C0008
     LET l_logFile = os.Path.join(FGL_GETENV("TEMPDIR"),l_logFile CLIPPED )  
     CALL FGL_SETENV("XMLFILE",l_logFile)
 
     LET mi_tpgateway_trigger = "1"
     CALL cl_cmdrun_wait(l_cmd)
 
     #檢查 cmdrun 的過程中是否出錯
     LET l_str = ""
     IF mi_tpgateway_status > 0 THEN
        LET l_errDesc = cl_getmsg("aws-364",g_lang)
        RETURN 'aws-364',l_errDesc,''
     ELSE
        LET l_server = FGL_GETENV("FGLAPPSERVER")
        IF cl_null(l_server) THEN
           LET l_server = FGL_GETENV("FGLSERVER")
        END IF
        LET l_context_file = "aws_ttsrv2_" || l_server CLIPPED || "_" || g_user CLIPPED || "_" || l_ReportID CLIPPED || ".txt"
        LET l_context_file = os.Path.join(FGL_GETENV("TEMPDIR"),l_context_file CLIPPED)   #FUN-9C0008
        LET l_ch = base.Channel.create()
        CALL l_ch.openFile(l_context_file, "r")
        WHILE l_ch.read(l_str)
        END WHILE
        CALL l_ch.close()
        IF NOT cl_null(l_str) THEN    #若有錯則回傳錯誤訊息
          #RUN "rm -f " || l_context_file || " 2>/dev/null"          #FUN-9C0008
           IF os.Path.delete( l_context_file CLIPPED ) THEN END IF
           RETURN '-1',l_str,''
        ELSE                          #否則讀取 XMLFILE
           LET l_tb = base.StringBuffer.create()
           LET l_ch = base.Channel.create()
           CALL l_ch.openFile(l_logFile, "r")
           CALL l_ch.setDelimiter("")
           WHILE l_ch.read(l_name)
              IF l_CRtype = "URL" THEN
                 CALL l_tb.append(l_name CLIPPED)
              ELSE
                 CALL l_tb.append("\n")
                 CALL l_tb.append(l_name CLIPPED)
              END IF
           END WHILE
           CALL l_ch.close()
           LET l_log = l_tb.toString()
          #RUN "rm -f " || l_logFile || " 2>/dev/null 2>&1"
           IF os.Path.delete( l_logFile CLIPPED ) THEN END IF
           RETURN '','',l_log
        END IF
     END IF
  END IF
  #--FUN-930132--end--

  LET l_ch = base.Channel.create()
  CALL l_ch.openPipe(l_cmd,"r")
  WHILE l_ch.read(l_name)
  END WHILE
   CALL l_ch.close()   #No:FUN-B90032
  IF l_name.subString(1,3) = "OK|" THEN
     RETURN '','',l_name.subString(4,l_name.getLength())
  ELSE
     LET l_errDesc = cl_getmsg("aws-212",g_lang)
     RETURN 'aws-212',l_errDesc,''
    #RETURN 'aws-212','報表打印過程出現錯誤',''
  END IF
END FUNCTION

#--FUN-930132--start-- 
#將預設值以代號表示的參數予以轉換
#如：g_pdate 的預設值為"#g_today#"，則將 g_pdate 帶 g_today 的值
FUNCTION aws_defaultTranslate(p_value)
  DEFINE p_value     STRING,     #傳入預設值
         l_value     STRING,
         l_index     LIKE type_file.num10
 
  LET l_value = p_value
  LET l_index = l_value.getIndexOf("#",1)
  IF l_index <> 0 THEN
     LET l_value = cl_replace_str(l_value,"#g_user#",g_user)
     LET l_value = cl_replace_str(l_value,"#g_today#",g_today)
     LET l_value = cl_replace_str(l_value,"#g_lang#",g_lang)
     LET l_value = cl_replace_str(l_value,"#g_plant#",g_plant)
     LET l_value = cl_replace_str(l_value,"#condition#",g_condition)     # FUN-A60057
     #新增欲轉換參數請加在此...
     #...
 
     #若還有 "#"表示預設值設定錯誤，
     #或有新增欲轉換的參數但未調整程式，故回傳原值
     LET l_index = l_value.getIndexOf("#",1)
     IF l_index<> 0 THEN
        LET l_value = p_value
     END IF
  END IF
 
  RETURN l_value
END FUNCTION
#--FUN-930132--end--
 
#替換掉XML數據中的標准保留字
FUNCTION aws_transXMLwords(p_data)
DEFINE
  p_data        STRING,
  l_sb          base.stringBuffer
  
  LET l_sb = base.stringBuffer.create()
  CALL l_sb.append(p_data)
  
  CALL l_sb.replace('&','&amp;',0)         #FUN-930132
  CALL l_sb.replace('<','&lt;',0)
  CALL l_sb.replace('>','&gt;',0)
  CALL l_sb.replace("'",'&apos;',0)
  CALL l_sb.replace('"','&quot;',0)
  
  RETURN l_sb.toString()
END FUNCTION 
 
#替換掉字符串中的宏
FUNCTION aws_transMacroWords(p_data)
DEFINE
  p_data        STRING,
  l_sql         LIKE type_file.chr1000,
  l_id          LIKE type_file.chr1000,
  l_desc        LIKE type_file.chr1000,
  l_output      STRING
  
  #解析"#SQL"宏，執行對應的SQL語句，用結果列表來取代原有的內容
  IF p_data.subString(1,5)='#SQL=' THEN
     LET l_sql = p_data.subString(6,p_data.getLength())
     IF NOT cl_null(l_sql) THEN 
        DECLARE c_sql CURSOR FROM l_sql        
        FOREACH c_sql INTO l_id,l_desc
          IF STATUS THEN
             RETURN ''
          END IF 
          
          IF cl_null(l_output) THEN 
             LET l_output = l_id,':',l_desc
          ELSE 
             LET l_output = l_output,',',l_id,':',l_desc
          END IF 
        END FOREACH         
     END IF
  ELSE 
     LET l_output = p_data 
  END IF 
  
  RETURN l_output
END FUNCTION 
 
#從對方的屬性取值列表映射到我們的欄位取值列表
FUNCTION aws_MappingValueFromTarget(p_sysid,p_targetobjectid,p_targetfieldlist,p_targetvaluelist,p_sep)
DEFINE 
  p_sysid              LIKE waj_file.waj01,
  p_targetobjectid     LIKE waj_file.waj02,
  p_targetfieldlist    STRING,
  p_targetvaluelist    STRING,
  p_sep                STRING,
  l_field              LIKE waj_file.waj04,
  l_value              LIKE type_file.chr1000,
  l_mapping            LIKE type_file.chr1000,
  l_token_field        base.StringTokenizer, 
  l_token_value        base.StringTokenizer,
  lst_value            STRING,
  l_errCode            STRING,
  l_errDesc            STRING,
  l_count              LIKE type_file.num5,
  l_first              LIKE type_file.num5
DEFINE  l_i            LIKE type_file.num5,
        arr_field      DYNAMIC ARRAY OF STRING,
        arr_value      DYNAMIC ARRAY OF STRING
    
    SELECT  COUNT(*) INTO l_count FROM wai_file WHERE wai01 = p_sysid AND wai03 = p_targetobjectid 
    IF l_count =0 THEN
      #RETURN 'aws-xxx','找不到傳入的系統別或該系統別下傳入的企業對象ID不存在',''
       LET l_errDesc = cl_getmsg("aws-125",g_lang)
       RETURN 'aws-125',l_errDesc,''
    END IF     
    
    LET l_first = TRUE
     CALL aws_Tokenizer(p_targetfieldlist,p_sep,arr_field)
     CALL aws_Tokenizer(p_targetvaluelist,p_sep,arr_value)
     FOR l_i =1 TO arr_field.getLength()
         LET l_field = arr_field[l_i]
         LET l_value = arr_value[l_i]
          LET l_mapping = ''
          SELECT waj07 INTO l_mapping FROM waj_file WHERE  waj05 = l_value 
            AND waj04 =(SELECT wai04 FROM wai_file
               WHERE wai01 =p_sysid AND wai02 = p_targetobjectid AND wai05 = l_field)   
          IF cl_null(l_mapping) THEN
             LET l_mapping = l_value
          END IF
          IF l_first THEN  #不用cl_null(lst_value)判斷的原因是如果第一個段為空的話轉換以后就被遺失了
             LET lst_value = l_mapping CLIPPED
             LET l_first = FALSE 
          ELSE
             LET lst_value = lst_value,p_sep,l_mapping CLIPPED
          END IF
       END FOR    
    
    RETURN '','',lst_value
   
END FUNCTION
 
#從我們的欄位值列表映射到對方的屬性取值列表
FUNCTION aws_MappingValueToTarget(p_sysid,p_tiptopobjectid,p_tiptopfieldlist,p_tiptopvaluelist)
DEFINE 
  p_sysid                     LIKE waj_file.waj01,
  p_tiptopobjectid            LIKE wai_file.wai02,
  p_tiptopfieldlist           STRING,
  p_tiptopvaluelist           STRING,
  l_field                     LIKE wai_file.wai04, 
  l_value                     LIKE type_file.chr1000,
  l_token_field               base.StringTokenizer, 
  l_token_value               base.StringTokenizer,
  lst_value                   STRING,
  l_errCode                   STRING,
  l_errDesc                   STRING, 
  l_col                       LIKE wai_file.wai04,
  l_mapping                   LIKE type_file.chr1000,
  l_first                     LIKE type_file.num5
DEFINE  l_i                   LIKE type_file.num5, 
        arr_field      DYNAMIC ARRAY OF STRING,
        arr_value      DYNAMIC ARRAY OF STRING
             
    
  CALL aws_Tokenizer(p_tiptopfieldlist,g_Separator,arr_field)
  CALL aws_Tokenizer(p_tiptopvaluelist,g_Separator,arr_value)
  FOR l_i = 1 TO arr_field.getLength()
     LET l_field = arr_field[l_i]
     LET l_value = arr_value[l_i]
     LET l_first = TRUE
        LET l_mapping = ''
        SELECT waj05 INTO l_mapping FROM waj_file,wai_file WHERE waj01 = p_sysid AND waj02 = wai03
          AND waj07 = l_value AND wai01 = waj01 AND wai05 = waj04 AND wai02 = p_tiptopobjectid
        IF cl_null(l_mapping) THEN
           LET l_mapping = l_value
        END IF
        IF l_first THEN
           LET lst_value = l_mapping CLIPPED
           LET l_first = FALSE 
        ELSE
           LET lst_value = lst_value,g_Separator,l_mapping CLIPPED
        END IF
    END FOR     
  
  RETURN '','',lst_value
    
END FUNCTION
 
#從對方的屬性列表映射到我們的欄位列表
FUNCTION aws_MappingFieldFromTarget(p_sysid,p_targetobjectid,p_targetproplist,p_sep)
   DEFINE  p_sysid              LIKE wai_file.wai01
   DEFINE  p_targetobjectid     LIKE wai_file.wai02
   DEFINE  p_targetproplist    STRING
   DEFINE  p_sep                STRING
   DEFINE  lst_field            base.StringTokenizer 
   DEFINE  ls_field             LIKE wai_file.wai05
   DEFINE  l_n                  LIKE type_file.num5 
   DEFINE  l_ac                 LIKE type_file.num5
   DEFINE  l_i                  LIKE type_file.num5 
   DEFINE  ls_tiptop            LIKE wai_file.wai04 
   DEFINE  lst_tiptop           STRING
   DEFINE  l_errCode            LIKE ze_file.ze01
   DEFINE  l_errDesc            STRING
   DEFINE  l_a                  LIKE type_file.num5 
   DEFINE  arr_field            DYNAMIC ARRAY OF STRING
   
    IF cl_null(p_targetproplist) THEN 
       LET l_errDesc = cl_getmsg("aws-127",g_lang)
       RETURN 'aws-127',l_errDesc,''
      #RETURN 'aws-xxx','需要映射的對方屬性列表不能為空',''
    END IF
     	
    #開始解析“p_targetproplist”,并替換,重組LIST.
    CALL aws_Tokenizer(p_targetproplist,p_sep,arr_field)
    FOR l_a = 1 TO arr_field.getLength()
       LET ls_field = arr_field[l_a]
       LET ls_field = ls_field CLIPPED 
      
       SELECT DISTINCT wai04 INTO ls_tiptop FROM wai_file
         WHERE wai01 = p_sysid
           AND wai03 = p_targetobjectid
           AND wai05 = ls_field
            
       IF cl_null(ls_tiptop) THEN 
          LET l_errCode = 'aws-120'
          LET l_errDesc = cl_getmsg("aws-120",g_lang)
         #LET l_errDesc = '傳入的列表中有字段未找到對應的TIPTOP字段'
          LET lst_tiptop = ''
          EXIT FOR  
       ELSE   
       	  LET l_errCode = ''
       	  LET l_errDesc = ''
          IF cl_null(lst_tiptop) THEN 
            LET lst_tiptop = ls_tiptop
          ELSE 
            LET lst_tiptop = lst_tiptop,p_sep,ls_tiptop
          END IF 
       END IF  
    END FOR     	          
           
    RETURN l_errCode,l_errDesc,lst_tiptop
    
END FUNCTION  
 
#從我們的欄位列表映射到對方的屬性列表
FUNCTION aws_FieldToProperty(p_sysid,p_tiptopobjectid,p_tiptopfieldlist) 
   DEFINE  p_sysid              LIKE wai_file.wai01
   DEFINE  p_tiptopobjectid     LIKE wai_file.wai02
   DEFINE  p_tiptopfieldlist    STRING
   DEFINE  lst_field            base.StringTokenizer 
   DEFINE  ls_field             LIKE wai_file.wai04
   DEFINE  l_ac                 LIKE type_file.num5
   DEFINE  l_i                  LIKE type_file.num5 
   DEFINE  ls_target            LIKE wai_file.wai05
   DEFINE  lst_target           STRING
   DEFINE  l_errCode            LIKE ze_file.ze01
   DEFINE  l_errDesc            STRING   
   DEFINE  l_a                  LIKE type_file.num5 
   DEFINE  arr_field            DYNAMIC ARRAY OF STRING
 
    
     IF cl_null(p_tiptopfieldlist) THEN 
        LET l_errDesc = cl_getmsg("aws-128",g_lang)
        RETURN 'aws-128',l_errDesc,''
       #RETURN 'aws-xxx','需要映射的TIPTOP欄位列表不能為空',''
     END IF
     	
     #開始解析“p_tiptopfieldlist”
     CALL aws_Tokenizer(p_tiptopfieldlist,g_Separator,arr_field)
     FOR l_a = 1 TO arr_field.getLength()
        LET ls_field = arr_field[l_a]
        LET ls_field = ls_field CLIPPED   
             
         SELECT wai05 INTO ls_target FROM wai_file 
           WHERE wai01 = p_sysid 
             AND wai04 = ls_field
             AND wai02 = p_tiptopobjectid
 
        IF cl_null(ls_target) THEN 
            LET l_errCode = 'aws-129'
            LET l_errDesc = cl_getmsg("aws-129",g_lang)
            LET lst_target = ''
            EXIT FOR 
        ELSE          
            LET l_errCode = ''
            LET l_errDesc = '' 	
            IF cl_null(lst_target) THEN 
               LET lst_target = ls_target
            ELSE 
               LET lst_target = lst_target,g_Separator,ls_target
            END IF
        END IF       
    END FOR   	               
             
     RETURN l_errCode,l_errDesc,lst_target
    
END FUNCTION                                        
 
#處理SetData接收到的數據，用于完成從我們自己的屬性向我們自己的欄位之間的轉換
#包括數據也進行轉換,中間要進行欄位拓展，是在調用aws_AnalyzeData前進行的預處理
#另外,本函數也要處理對超過長度的傳入值進行截斷的工作
#對選項值的映射也要放在這個函數里面來做,否則一旦進行了截斷就面目全非,無法再映射選項值了
FUNCTION aws_MappingDataByProp(p_objectid,p_xmlfile,p_sep)
DEFINE
  p_objectid                    LIKE wac_file.wac01,     
  p_xmlfile                     STRING,
  p_sep                         STRING,
  doc                           om.DomDocument,
  dataNode,dataSetNode,rowNode  om.DomNode,
  l_proplist,l_valuelist        STRING,
  l_fieldlist,l_replacelist     STRING,
  l_sql                         STRING,
  l_count                       LIKE type_file.num5,
  l_tokcount,l_rowtok           LIKE type_file.num5,
  l_i,l_j,l_k,l_m               LIKE type_file.num5,
  l_prop                        LIKE wac_file.wac04,
  l_field                       LIKE wac_file.wac03,
  l_datatype                    LIKE wac_file.wac06,
  l_len                         LIKE wac_file.wac07,
  l_value                       STRING,
  l_tok_prop,l_tok_value        base.stringTokenizer,
  arr_div                       DYNAMIC ARRAY OF RECORD
    len                         LIKE type_file.num5,            #該欄位的長度
    divcount                    LIKE type_file.num5             #該屬性對應的欄位數量
  END RECORD,
  l_first,l_found               LIKE type_file.num5,
  l_errCode,l_errDesc           STRING,
  l_str_buf                     base.StringBuffer
DEFINE l_a                      LIKE type_file.num5, 
       arr_prop                 DYNAMIC ARRAY OF STRING,
       arr_value                DYNAMIC ARRAY OF STRING
  
  #將屬性列表轉換成對應的欄位列表，包括其對應的值列表也進行轉換
  #為什么要這樣，是因為類似于bma01,bmb01,bmc01這樣的用于維護關聯關系的欄位在屬性列表中
  #是屬于同一個屬性，因此從對方傳進來的數據集中也只會包含一個屬性，但是我們在執行SetData
  #動作的時候，是要求每個表中間這樣的欄位都是完全存在的，所以需要對其進行拆解，一個分三個
  #對應的值也要一個分三個（但是內容一樣）
 
  #首先讀取文件
  LET doc = om.DomDocument.createFromXmlFile(p_xmlfile)
  LET dataNode = doc.getDocumentElement()
  LET dataSetNode = dataNode.getFirstChild()
  LET l_proplist = dataSetNode.getAttribute("Field")
 
  LET l_sql = "SELECT wac03,wac06,wac07 FROM wac_file WHERE wac01 = '",
              p_objectid,"' AND wac04 = ?"
  PREPARE sp_check FROM l_sql
  DECLARE cp_check CURSOR FOR sp_check
  
  #分析其中哪些屬性需要拆解的，并把拆解規則記錄下來
  LET l_i = 0
  LET l_j = 0
  LET l_fieldlist= ''  
# #記錄下FieldList中包含的Token數，用于和其后的每一筆Row進行校驗
  LET l_first = TRUE
  CALL aws_Tokenizer(l_proplist,p_sep,arr_prop)
  FOR l_a = 1 TO arr_prop.getLength()
      LET l_prop = arr_prop[l_a]
    LET l_i = l_i + 1
    LET l_count = 0
    LET l_len = 0
    LET l_found = FALSE 
    FOREACH cp_check USING l_prop INTO l_field,l_datatype,l_len
      LET l_found = TRUE 
      LET l_count = l_count + 1
      IF l_first THEN 
         LET l_fieldlist= l_field
         LET l_first = FALSE 
      ELSE 
         LET l_fieldlist = l_fieldlist,p_sep,l_field 
      END IF 
    END FOREACH 
    #Debug的時候發現,如果這個欄位在對方系統那邊給錯了,在直接調用SetData的情況下,是不會經過前面
    #哪些校驗,而且FOREACH的時候也不會有錯誤,但是會因此遺漏一個欄位造成后續的錯誤:欄位數量和數據數量不一致
    IF ( NOT l_found ) OR ( SQLCA.sqlcode <> 0 ) THEN 
       LET l_errDesc = cl_replace_err_msg( cl_getmsg('aws-130',g_lang),l_prop)
       RETURN 'aws-130',l_errDesc
      #RETURN 'aws-xxx','輸入的屬性'||l_prop||'或欄位'||l_field||'在TIPTOP中未定義'
    END IF
    
    #記錄這個屬性被擴展后的欄位個數（1表示不用替換)
    LET arr_div[l_i].divcount = l_count
    
    #記錄對應欄位的長度(只有字符型欄位才需要考慮)
    IF l_datatype = 'C' THEN
       LET arr_div[l_i].len = l_len
    ELSE 
       LET arr_div[l_i].len = 0
    END IF 
  END FOR 
  
  #最后將替換的結果更新到DataSet的Field屬性中
  CALL dataSetNode.setAttribute("Field",l_fieldlist)
 
  #循環每個數據節點
  LET rowNode = dataSetNode.getFirstChild()
  WHILE rowNode IS NOT NULL
    LET l_valuelist = rowNode.getAttribute('Data')
    LET l_str_buf = base.StringBuffer.create()
 
    
    
    LET l_k = 1
    #逐個段進行擴展（以arr_div中對應的數目為依據）
    CALL aws_Tokenizer(l_valuelist,p_sep,arr_value)
    FOR l_i = 1 TO arr_value.getLength()
       LET l_found = FALSE
       LET l_value = arr_value[l_i]
      
      #根據該欄位的長度進行截取(如果len值=0表示該欄位不需要進行截取,可能是數值型這樣的      
      IF ( arr_div[l_k].len > 0 )AND( arr_div[l_k].len < l_value.getLength()) THEN 
         LET l_value = l_value.substring(1,arr_div[l_k].len)
      END IF 
     
     FOR l_m = 1 TO arr_div[l_k].divcount
       IF ( NOT l_found )AND( l_k = 1 ) THEN LET 
           l_replacelist = l_value
           LET l_found = TRUE
        ELSE 
           LET l_replacelist = l_replacelist,p_sep,l_value
        END IF 
      END FOR
      
      LET l_k = l_k + 1
    END FOR 
      
    #將替換結果回寫到當前節點的Data屬性中
    CALL rowNode.setAttribute('Data',l_replacelist)
    LET rowNode = rowNode.getNext()
  END WHILE    
  
  #將結果回寫到XML文件中去
  CALL dataNode.writeXml(p_xmlFile)  
  RETURN '',''
  RUN "echo '3' > "|| os.Path.join(FGL_GETENV("TEMPDIR"),"c.txt" )    #FUN-9C0008
END FUNCTION
 
#返回指定系統的整合參數
FUNCTION aws_GetSystemInfo(p_sysid)
DEFINE
  p_sysid     LIKE wag_file.wag01,
  l_srv       LIKE wag_file.wag04,
  l_url       LIKE wag_file.wag03,
  l_ns        LIKE wag_file.wag05,
  l_act       LIKE wag_file.wag06,   
  l_pns       LIKE wag_file.wag07
 
DEFINE l_count     LIKE type_file.num5,
       l_sysid     LIKE wag_file.wag01,
       l_sysid2    LIKE wag_file.wag01,
       l_str       STRING
 
 # DATABASE ds     #FUN-B80064   MARK
 
  LET l_sysid = p_sysid
  LET l_sysid2 = "CRM"
  IF l_sysid = l_sysid2 THEN
     DISPLAY "aa"
  ELSE
     DISPLAY "dd"
  END IF
  SELECT wag04,wag03,wag05,wag07,wag06 INTO l_srv,l_url,l_ns,l_pns,l_act
  FROM wag_file WHERE wag01 = l_sysid2
 
  SELECT wag04,wag03,wag05,wag07,wag06 INTO l_srv,l_url,l_ns,l_pns,l_act
  FROM wag_file WHERE wag01 = l_sysid
 
  SELECT COUNT(*) INTO l_count 
  FROM wag_file WHERE wag01 = p_sysid
 
 
  RETURN l_srv,l_url,l_ns,l_pns,l_act
END FUNCTION
 
#測試到目標系統的連接
FUNCTION aws_GetObjectList(p_sysid)
DEFINE
  p_sysid                  LIKE wag_file.wag01,
  p_input,l_output         STRING,
  soapStatus               LIKE type_file.num5,
  soapDesc                 STRING
 
  LET p_input = '<STD_IN Origin="TIPTOP"><Service Name="GetObjectList"/></STD_IN>'
  IF soapStatus = 0 THEN RETURN TRUE,l_output 
     ELSE RETURN FALSE,soapDesc 
  END IF
END FUNCTION
 
FUNCTION aws_GetTemplate(p_sysid,p_objectid)
 
DEFINE
   p_sysid             LIKE wah_file.wah02,
   p_objectid          LIKE wai_file.wai02,
   p_input,l_output    STRING,
   soapStatus          LIKE type_file.num5,
   soapDesc            STRING
   
       LET p_input = '<STD_IN Origin="TIPTOP"><Service Name="GetTemplate"><ObjectID>',p_objectid,'</ObjectID></Service></STD_IN>'
       IF soapStatus = 0 THEN
          RETURN TRUE ,l_output
       ELSE
          RETURN FALSE,soapDesc
       END IF
END FUNCTION
 
#********************************************************      
#此functtion根據錯誤，
#生成類似<Table=”xxx” Field=”xxx|...|xxx” Data=”mmm|...|mmm” Code=”xxx” Desc=”xxx”/>
#的STRING
FUNCTION aws_MakeErrorXML(p_tablename,p_field,p_value,p_errcode,p_errdesc)
DEFINE p_tablename     STRING,
       p_field         STRING,
       p_value         STRING,
       p_errcode       STRING,
       p_errdesc       STRING
DEFINE errstring   base.StringBuffer
 
 LET errstring = base.StringBuffer.CREATE()
 CALL errstring.append('\n<Row Table="'||p_tablename||'" Field="'||p_field||'" Data="'||p_value||'" Code="'||p_errcode||'" Desc="'||p_errdesc||'"/>\n')
 RETURN errstring.toString()
END FUNCTION
#*********************************************************
 
#游瑩寫的巨牛的函數
#把一個Join格式存放的數據集填充到全局數組pub_data中供WriteData使用，Join數據集中的列表已經被轉換為欄位列表，但是其欄位
#的排列以及記錄的排列均不規整，但本函數會進行整理并放在數組中合適的位置
FUNCTION aws_AnalyzeData(p_objectid,p_xmlfile,p_sep)
DEFINE  l_wac03char           LIKE wac_file.wac03
DEFINE  p_sep,l_data          STRING
DEFINE  p_xmlfile             STRING
DEFINE  p_objectid            LIKE waa_file.waa01
DEFINE  nodeDocu              om.DomDocument
DEFINE  node,datanode         om.DomNode
DEFINE  l_flag                DYNAMIC ARRAY OF STRING
DEFINE  l_wac02               LIKE wac_file.wac02
DEFINE  l_wab04,l_wab04t      LIKE wab_file.wab04
DEFINE  l_wab05               LIKE wab_file.wab05
DEFINE  l_wab08               LIKE wab_file.wab08
DEFINE  l_wac03list           base.StringTokenizer
DEFINE  l_datalist            base.StringTokenizer 
DEFINE  l_Strt,l_Strt1,l_Strt2 base.StringTokenizer 
DEFINE  l_zero,l_zero1,l_zero2 LIKE type_file.num5 
DEFINE  l_wac03               STRING
DEFINE  i,j,o,p,n,m           LIKE type_file.num5
DEFINE  l_headdata            STRING
DEFINE  l_bodydata            STRING
DEFINE  l_detaildata          STRING
DEFINE  l_subdetaildata       STRING
DEFINE  l_a,l_b,l_c,l_d,l_e   LIKE type_file.num5
DEFINE  a,b,c,d,e             LIKE type_file.num5
DEFINE  num1,num,num2         LIKE type_file.num5
DEFINE  str,str1,str2         STRING
DEFINE  l_node                STRING
DEFINE  l_body                DYNAMIC ARRAY OF RECORD
         tables       STRING,
         fields       STRING,
         data         STRING,
         detail         DYNAMIC ARRAY OF RECORD
            tables       STRING,
            fields       STRING,
            data         STRING,
            subdetail      DYNAMIC ARRAY OF RECORD
             tables         STRING,
             fields         STRING,
             data           STRING    
          END RECORD
        END RECORD
      END RECORD
DEFINE
  l_bodyfields   STRING,
  l_bodytables   STRING,
  l_detailfields STRING,
  l_detailtables STRING,
  l_subdetailfields STRING,
  l_subdetailtables STRING,
  l_insert       STRING
DEFINE 
  l_i            LIKE type_file.num5,
  arr_wac03      DYNAMIC ARRAY OF STRING,
  arr_data       DYNAMIC ARRAY OF STRING 
  
 
   CALL pub_data.clear()
  LET nodeDocu = om.DomDocument.createFromXmlFile(p_xmlfile)
  LET node = nodeDocu.getDocumentElement()
  LET node = node.getFirstChild()
  LET l_wac03 = node.getAttribute("Field")
  CALL aws_Tokenizer(l_wac03,p_sep,arr_wac03)
  LET n = 1
  LET a = 1
  LET b = 1
  LET c = 1
  FOR l_i = 1 TO arr_wac03.getLength()
      LET l_wac03 = arr_wac03[l_i]
    LET l_wac03char = l_wac03
    SELECT wac02 INTO l_wac02 FROM wac_file 
     WHERE wac01 = p_objectid 
       AND wac03 = l_wac03char
    
    DECLARE c1 SCROLL CURSOR FOR SELECT wab05,wab08  FROM wab_file
     WHERE wab01 = p_objectid
       AND wab02 = l_wac02
    OPEN c1
    FETCH FIRST c1 INTO l_wab05,l_wab08      
    IF l_wab08 = "Head" THEN
       LET pub_data[1].tables = l_wac02
       IF pub_data[1].fields IS NULL THEN
          LET pub_data[1].fields = l_wac03 CLIPPED 
       ELSE
       	  LET pub_data[1].fields = pub_data[1].fields CLIPPED,p_sep CLIPPED,l_wac03 CLIPPED
       END IF
       LET l_flag[n] = 'H'      
       LET n = n+1
    END IF
    IF l_wab08 = "Body" THEN
       LET l_insert = 'N'
       FOR d = 1 TO l_body.getLength()  #處理多個單身
          IF l_body[d].tables = l_wac02 THEN
             IF l_body[d].fields IS NULL THEN
                LET l_body[d].fields = l_wac03 CLIPPED
             ELSE 
                LET l_body[d].fields = l_body[d].fields CLIPPED,p_sep CLIPPED,l_wac03 CLIPPED
             END IF
             LET l_insert = 'Y'
             EXIT FOR            
          END IF
       END FOR         
       IF l_insert = 'N' THEN
          IF d != 1 THEN
             LET d = d
          END IF
          LET l_body[d].tables = l_wac02
          LET l_body[d].fields = l_wac03 CLIPPED  
          LET l_insert = 'Y' 
       END IF       
 
       LET str = d 
       LET l_flag[n] = '0',str.trim(),'00'    
       LET n = n+1  
    END IF   
    IF l_wab08 = "Detail" THEN
       LET l_insert = 'N' 
       SELECT wab04 INTO l_wab04 FROM wab_file
        WHERE wab01 = p_objectid
          AND wab02 = l_wac02
       FOR d = 1 TO l_body.getLength()  #利用上游表來找到對應的位置
         IF l_body[d].tables = l_wab04 THEN
            FOR a = 1 TO l_body[d].detail.getLength()
                IF l_body[d].detail[a].tables = l_wac02 THEN   #找到表的位置，組欄位信息
                   IF l_body[d].detail[a].fields IS NULL THEN
                      LET l_body[d].detail[a].fields = l_wac03 CLIPPED
                   ELSE
                      LET l_body[d].detail[a].fields = l_body[d].detail[a].fields CLIPPED,p_sep CLIPPED,l_wac03 CLIPPED
                   END IF
                   LET l_insert = 'Y'
                   EXIT FOR
                END IF
            END FOR
            IF l_insert = 'N' THEN
               IF a !=1 THEN
                  LET a = a-1
               END IF
               LET l_body[d].detail[a].tables = l_wac02
               LET l_body[d].detail[a].fields = l_wac03 CLIPPED
               LET l_insert = 'Y' 
            END IF
            LET str = d
            LET str1 = a 
            LET l_flag[n] = '0',str.trim(),str1.trim(),'0'
         END IF          	 
       END FOR
       IF l_insert = 'N' THEN
          LET l_body[1].tables = l_wab04
          LET l_body[1].detail[1].tables = l_wac02
          IF l_body[1].detail[1].fields IS NULL THEN
             LET l_body[1].detail[1].fields = l_wac03 CLIPPED
          ELSE
             LET l_body[1].detail[1].fields = l_body[1].detail[1].fields CLIPPED,p_sep CLIPPED,l_wac03 CLIPPED
          END IF  
          LET l_flag[n] = '0110'         
          LET l_insert = 'Y'
        END IF
 
       LET n = n+1  
    END IF 
    IF l_wab08 = "SubDetail" THEN
       LET l_insert = 'N' 
       SELECT wab04 INTO l_wab04 FROM wab_file
        WHERE wab01 = p_objectid
          AND wab02 = l_wac02
       SELECT wab04 INTO l_wab04t FROM wab_file
        WHERE wab01 = p_objectid
          AND wab02 = l_wab04
       FOR d = 1 TO l_body.getLength()  #利用上游表來找到對應的位置
         LET b = l_body[d].detail.getLength()
         IF l_body[d].tables = l_wab04t THEN
            IF b != 0 THEN
               FOR c = 1 TO b    
                 IF l_body[d].detail[c].tables = l_wab04 THEN              
                    FOR a = 1 TO l_body[d].detail[c].subdetail.getLength()
                      IF l_body[d].detail[c].subdetail[a].tables = l_wac02 THEN   #找到表的位置，組欄位信息
                         IF l_body[d].detail[c].subdetail[a].fields IS NULL THEN
                            LET l_body[d].detail[c].subdetail[a].fields = l_wac03 CLIPPED
                         ELSE
                            LET l_body[d].detail[c].subdetail[a].fields =l_body[d].detail[c].subdetail[a].fields CLIPPED,p_sep CLIPPED,l_wac03 CLIPPED
                         END IF
                         LET l_insert = 'Y'
                         EXIT FOR
                      END IF
                    END FOR
                    IF l_insert = 'N' THEN
                       IF a != 1 THEN
                          LET a = a-1
                       END IF
                       LET l_body[d].detail[c].subdetail[a].tables = l_wac02
                       LET l_body[d].detail[c].subdetail[a].fields = l_wac03 CLIPPED
                       LET l_insert = 'Y' 
                    END IF
                    LET str = d
                    LET str1 = c
                    LET str2 = a 
                    LET l_flag[n] = '0',str.trim(),str1.trim(),str2.trim()
                 END IF 
               END FOR 
            END IF 
         END IF       	 
       END FOR 
       IF l_insert = 'N' AND d = 1 THEN
          LET l_body[1].tables = l_wab04t
          LET l_body[1].detail[1].tables = l_wab04
          LET l_body[1].detail[1].subdetail[1].tables = l_wac02
          IF l_body[1].detail[1].subdetail[1].fields IS NULL THEN
             LET l_body[1].detail[1].subdetail[1].fields = l_wac03 CLIPPED
          ELSE
             LET l_body[1].detail[1].subdetail[1].fields = l_body[1].detail[1].subdetail[1].fields CLIPPED,p_sep CLIPPED,l_wac03 CLIPPED
          END IF  
          LET l_flag[n] = '0111'         
          LET l_insert = 'Y'
       ELSE
       	  IF l_insert = 'N' THEN
             LET l_body[d].tables = l_wab04t
             LET l_body[d].detail[1].tables = l_wab04
             LET l_body[d].detail[1].subdetail[1].tables = l_wac02
             IF l_body[d].detail[1].subdetail[1].fields IS NULL THEN
                LET l_body[d].detail[1].subdetail[1].fields = l_wac03 CLIPPED
             ELSE
                LET l_body[d].detail[1].subdetail[1].fields = l_body[d].detail[1].subdetail[1].fields CLIPPED,p_sep CLIPPED,l_wac03 CLIPPED
             END IF  
             LET str = d
             LET l_flag[n] = '0',str.trim(),'11'         
             LET l_insert = 'Y'  
          END IF     	  
       END IF    
       LET n = n+1  
    END IF 
  END FOR 
  
                      
  LET i = node.getChildCount()
  IF i = 0 THEN           #沒有傳入數據的情況
     LET g_ze.ze03 = cl_getmsg("aws-132",g_lang)
     RETURN 'aws-132',g_ze.ze03
    #RETURN 'aws-XXX','沒有傳入數據'
  ELSE 
     LET n = n-1
     FOR j = 1 TO i 
       LET datanode =node.getChildByIndex(j)
       LET l_data = datanode.getAttribute("Data")
       CALL aws_Tokenizer(l_data,p_sep,arr_data)
       LET p = 1
       LET l_insert = 'N'
       FOR l_i = 1 TO arr_data.getLength()
         IF l_flag[p] = 'H' THEN
            IF l_headdata IS NULL THEN
               LET l_headdata = arr_data[l_i]
            ELSE
            	 LET l_headdata = l_headdata CLIPPED,p_sep CLIPPED,arr_data[l_i]
            END IF
         ELSE
            LET l_c = l_flag[p].getCharAt(2) 
            IF l_c IS NOT NULL THEN
               LET l_d = l_flag[p].getCharAt(3)
               LET num = l_c
               IF l_d = '0' THEN
                  LET l_node = arr_data[l_i]
                  IF l_body[num].data IS NULL  AND l_node != ' ' THEN
                     LET l_body[num].data = l_node
                  ELSE
                  	     LET l_body[num].data = l_body[num].data CLIPPED,p_sep CLIPPED,l_node CLIPPED 
                  END IF   
               ELSE
               	  LET l_e = l_flag[p].getCharAt(4)
               	  IF l_e = '0' THEN
               	     LET num1 = l_d
               	     LET l_node = arr_data[l_i]
               	     IF l_body[num].detail[num1].data IS NULL AND l_node != ' ' THEN
               	        LET l_body[num].detail[num1].data = l_node 
                     ELSE
                     	  IF l_node != ' ' THEN
                  	       LET l_body[num].detail[num1].data = l_body[num].detail[num1].data CLIPPED,p_sep CLIPPED,l_node CLIPPED 
                  	    END IF
                     END IF
                  ELSE
                     LET num1 = l_d
                     LET num2 = l_e
                     LET l_node = arr_data[l_i]
                     IF l_body[num].detail[num1].subdetail[num2].data IS NULL  AND l_node != ' ' THEN
               	        LET l_body[num].detail[num1].subdetail[num2].data = l_node 
                     ELSE
                     	  IF l_node != ' ' THEN
                  	       LET l_body[num].detail[num1].subdetail[num2].data = l_body[num].detail[num1].subdetail[num2].data CLIPPED,p_sep CLIPPED,l_node CLIPPED 
                        END IF
                     END IF
                  END IF
               END IF
            END IF  
         END IF  
         LET p = p+1
       END FOR 
       LET l_a = l_body.getLength()
       FOR l_a = 1 TO l_body.getLength()
           LET l_insert = 'N'
           LET l_bodydata = l_body[l_a].data
           LET l_bodytables = l_body[l_a].tables
           LET l_bodyfields = l_body[l_a].fields
           LET l_body[l_a].data = NULL
           LET l_Strt = base.StringTokenizer.createExt(l_bodydata,p_sep,NULL,FALSE)
           LET l_zero = l_Strt.countTokens()
           IF l_zero != 0 THEN 
              FOR l_b = 1 TO l_body[l_a].detail.getLength()
                LET l_detaildata = l_body[l_a].detail[l_b].data
                LET l_detailtables = l_body[l_a].detail[l_b].tables
                LET l_detailfields = l_body[l_a].detail[l_b].fields
                LET l_body[l_a].detail[l_b].data = NULL
                LET l_Strt1 = base.StringTokenizer.createExt(l_detaildata,p_sep,NULL,FALSE)
                LET l_zero1 = l_Strt1.countTokens()
                IF l_zero1 != 0 THEN
                   FOR l_c = 1 TO l_body[l_a].detail[l_b].subdetail.getLength()
                       LET l_subdetailtables = l_body[l_a].detail[l_b].subdetail[l_c].tables
                       LET l_subdetailfields = l_body[l_a].detail[l_b].subdetail[l_c].fields
                       LET l_subdetaildata = l_body[l_a].detail[l_b].subdetail[l_c].data
                       LET l_body[l_a].detail[l_b].subdetail[l_c].data = NULL
                       LET l_Strt2 = base.StringTokenizer.createExt(l_subdetaildata,p_sep,NULL,FALSE)
                       LET l_zero2 = l_Strt2.countTokens()
                       IF l_zero2 != 0 THEN
                          IF l_subdetaildata IS NOT NULL THEN
                            CALL aws_AnayzeData_insert(l_headdata,l_bodydata,l_detaildata,l_subdetaildata,l_bodytables,l_bodyfields,l_detailtables,l_detailfields,l_subdetailtables,l_subdetailfields)
                            LET l_insert ='Y'  
                          END IF 
                       ELSE
                       	  LET l_subdetaildata = NULL
                       END IF           
                   END FOR
                   IF l_insert = 'N' AND l_detaildata IS NOT NULL THEN
                      CALL aws_AnayzeData_insert(l_headdata,l_bodydata,l_detaildata,l_subdetaildata,l_bodytables,l_bodyfields,l_detailtables,l_detailfields,l_subdetailtables,l_subdetailfields)
                      LET l_insert = 'Y' 
                   END IF
                ELSE 
                   LET l_detaildata = NULL
           	   LET l_subdetaildata = NULL
                END IF
              END FOR
              IF l_insert = 'N' THEN
                 CALL aws_AnayzeData_insert(l_headdata,l_bodydata,l_detaildata,l_subdetaildata,l_bodytables,l_bodyfields,l_detailtables,l_detailfields,l_subdetailtables,l_subdetailfields)
                 LET l_insert = 'Y' 
              END IF
           ELSE
           	  LET l_bodydata = NULL 
           	  LET l_detaildata = NULL
           	  LET l_subdetaildata = NULL
           	  LET l_insert = 'Y'
           END IF
        END FOR        
        IF l_insert = 'N' THEN
           CALL aws_AnayzeData_insert(l_headdata,l_bodydata,l_detaildata,l_subdetaildata,l_bodytables,l_bodyfields,l_detailtables,l_detailfields,l_subdetailtables,l_subdetailfields)
           LET l_insert = 'Y' 
        END IF 
        LET l_headdata = NULL
        LET l_bodydata = NULL 
        LET l_detaildata = NULL
        LET l_subdetaildata = NULL    
     END FOR
     RUN "echo '4' > "|| os.Path.join(FGL_GETENV("TEMPDIR"),"d.txt" )     #FUN-9C0008
     RETURN "",""
  END IF
     
 
 
END FUNCTION 
 
FUNCTION aws_AnayzeData_insert(p_headdata,p_bodydata,p_detaildata,p_subdetaildata,p_bodytables,p_bodyfields,p_detailtables,p_detailfields,p_subdetailtables,p_subdetailfields)
DEFINE 
  p_headdata       STRING,
  p_bodydata       STRING,
  p_detaildata     STRING, 
  p_subdetaildata  STRING,
  p_bodytables,p_bodyfields,p_detailtables,p_detailfields,p_subdetailtables,p_subdetailfields         STRING,
  p_num,n,m,o,p,a    LIKE type_file.num5,
  l_insert         STRING       
       
       LET l_insert = 'N'
       IF pub_data[1].data IS NULL THEN  #插入第一筆數據
          LET pub_data[1].data = p_headdata
          IF p_bodydata IS NOT NULL THEN
             LET pub_data[1].body[1].data = p_bodydata
             LET pub_data[1].body[1].tables = p_bodytables
             LET pub_data[1].body[1].fields = p_bodyfields
          END IF
          IF p_detaildata IS NOT NULL THEN
             LET pub_data[1].body[1].detail[1].data = p_detaildata
             LET pub_data[1].body[1].detail[1].tables = p_detailtables
             LET pub_data[1].body[1].detail[1].fields = p_detailfields
          END IF
          IF p_subdetaildata IS NOT NULL THEN
             LET pub_data[1].body[1].detail[1].subdetail[1].data = p_subdetaildata
             LET pub_data[1].body[1].detail[1].subdetail[1].tables = p_subdetailtables
             LET pub_data[1].body[1].detail[1].subdetail[1].fields = p_subdetailfields           
          END IF
       ELSE
       	  FOR n = 1 TO pub_data.getLength()
       	      IF p_headdata = pub_data[n].data THEN
       	         IF p_bodydata IS NOT NULL THEN
       	            FOR m = 1 TO pub_data[n].body.getLength() 
       	                IF p_bodydata = pub_data[n].body[m].data THEN
       	                   IF p_detaildata IS NOT NULL THEN
       	                      LET a = pub_data[n].body[m].detail.getLength()  
       	                      FOR o = 1 TO a
       	                          IF p_detaildata = pub_data[n].body[m].detail[o].data THEN
       	                             IF p_subdetaildata IS NOT NULL THEN  
       	                                LET p = pub_data[n].body[m].detail[o].subdetail.getLength() 
       	                                LET pub_data[n].body[m].detail[o].subdetail[p+1].tables = p_subdetailtables 
       	                                LET pub_data[n].body[m].detail[o].subdetail[p+1].fields = p_subdetailfields
       	                                LET pub_data[n].body[m].detail[o].subdetail[p+1].data = p_subdetaildata
       	                                LET l_insert = 'Y' 
       	                             END IF
       	                          END IF
       	                      END FOR
       	                      LET o = o-1
       	                      IF l_insert = 'N' THEN
       	                         LET pub_data[n].body[m].detail[o+1].tables = p_detailtables 
       	                         LET pub_data[n].body[m].detail[o+1].fields = p_detailfields 
       	                         LET pub_data[n].body[m].detail[o+1].data = p_detaildata
       	                         IF p_subdetaildata IS NOT NULL THEN
                                    LET pub_data[n].body[m].detail[o+1].subdetail[1].data = p_subdetaildata
                                    LET pub_data[n].body[m].detail[o+1].subdetail[1].tables = p_subdetailtables
                                    LET pub_data[n].body[m].detail[o+1].subdetail[1].fields = p_subdetailfields            
                                 END IF      
       	                         LET l_insert = 'Y' 
       	                      END IF
       	                   END IF
       	                END IF
       	            END FOR
       	            LET m = m-1
       	            IF l_insert = 'N' THEN
       	               LET pub_data[n].body[m+1].tables = p_bodytables  
       	               LET pub_data[n].body[m+1].fields = p_bodyfields
       	               LET pub_data[n].body[m+1].data = p_bodydata
       	               IF p_detaildata IS NOT NULL THEN
                          LET pub_data[n].body[m+1].detail[1].data = p_detaildata
                          LET pub_data[n].body[m+1].detail[1].tables = p_detailtables
                          LET pub_data[n].body[m+1].detail[1].fields = p_detailfields
                       END IF
                       IF p_subdetaildata IS NOT NULL THEN
                          LET pub_data[n].body[m+1].detail[1].subdetail[1].data = p_subdetaildata
                          LET pub_data[n].body[m+1].detail[1].subdetail[1].tables = p_subdetailtables
                          LET pub_data[n].body[m+1].detail[1].subdetail[1].fields = p_subdetailfields             
                       END IF       	     
       	               LET l_insert = 'Y' 
       	            END IF 
       	         END IF
       	      END IF
       	  END FOR
       	  LET n = n-1
       	  IF l_insert = 'N' THEN 
       	     LET pub_data[n+1].tables = pub_data[n].tables
       	     LET pub_data[n+1].fields = pub_data[n].fields
       	     LET pub_data[n+1].data = p_headdata
       	  END IF
       END IF
               
END FUNCTION
   
#----------------------下面是Condition字符串解析相關的函數---------------------------
   
#把SQL條件轉換成邏輯條件以避免>,<等符號和XML保留字沖突,在aws_GetXMLByCondition中會用到
FUNCTION aws_TransSqlToStandard(p_sql) 
DEFINE
  p_sql     STRING
  
  CASE p_sql
    WHEN ">"
      LET p_sql = "BigThan"
    WHEN ">="
      LET p_sql = "BigEqualThan"
    WHEN "="
      LET p_sql = "Equal"
    WHEN "<>"
      LET p_sql = "NotEqual"
    WHEN "<"
      LET p_sql = "LessThan"
    WHEN "<="
      LET p_sql = "LessEqualThan"
    OTHERWISE 
      LET p_sql = p_sql
  END CASE 
  RETURN UPSHIFT(p_sql)
END FUNCTION 
 
#把邏輯條件轉換成SQL條件以避免>,<等符號和XML保留字沖突,在aws_GetConditionByXML中會用到
FUNCTION aws_TransStandardToSql(p_sql) 
DEFINE
  p_sql     STRING
  
  LET p_sql = UPSHIFT(p_sql)
  CASE p_sql
    WHEN "BIGTHAN"
      LET p_sql = ">"
    WHEN "BIGEQUALTHAN"
      LET p_sql = ">="
    WHEN "EQUAL"
      LET p_sql = "="
    WHEN "NOTEQUAL"
      LET p_sql = "<>"
    WHEN "LESSTHAN"
      LET p_sql = "<"
    WHEN "LESSEQUALTHAN"
      LET p_sql = "<="
    OTHERWISE 
      LET p_sql = p_sql
  END CASE 
  RETURN p_sql
END FUNCTION 
   
   
#根據傳入的參數拼接一個最簡單的條件子句
#首先要根據傳入的屬性對應到欄位
#然后要把對應的日期值進行轉換
#再根據條件類型生成最后的結果,樣式比如: ima01 = '23' 這樣,不帶外面的括號
#非系統中支持的條件種類(=,<>,>,<,>=,<=,LIKE,IN,BETWEEN,IS NULL,IS NOT NULL)則不支持
FUNCTION aws_MakePropStr(p_objectid,p_sep,p_dateformat,p_propname,p_proptype,p_value)
DEFINE
  p_objectid      LIKE wac_file.wac01,
  p_propname      LIKE wac_file.wac04,
  p_dateformat    STRING,
  p_proptype      STRING,
  p_value         STRING,
  p_sep           STRING,
  l_fieldname     LIKE wac_file.wac03,
  l_datatype      LIKE wac_file.wac06,
  l_result        STRING,
  l_sepidx        LIKE type_file.num5,
  l_leftstr       STRING,
  l_rightstr      STRING,
  l_tok           base.StringTokenizer,
  l_tempstr       STRING,
  l_i             LIKE type_file.num5,
  arr_value       DYNAMIC ARRAY OF STRING,
  arr_str         DYNAMIC ARRAY OF STRING
    
  #得到該字段的類型
  SELECT wac03,wac06 INTO l_fieldname,l_datatype FROM wac_file 
    WHERE wac01 = p_objectid AND wac04 = p_propname
  IF cl_null(l_fieldname) THEN 
     LET g_ze.ze03 = cl_replace_err_msg(cl_getmsg("aws-121",g_lang),p_propname)
     RETURN 'aws-121',g_ze.ze03,''
    #RETURN 'aws-xxx','屬性'||p_propname||'沒有找到對應的欄位',''
  END IF 
  
  #將條件全部轉換為大寫(比如IN,LIKE,BETWEEN)
  LET p_proptype = UPSHIFT(p_proptype) 
  
  #判斷條件類型
  IF ( p_proptype = 'EQUAL' )OR( p_proptype = 'BIGTHAN' )OR( p_proptype = 'LESSTHAN' )OR( p_proptype = 'NOTEQUAL' )OR
     ( p_proptype = 'BIGEQUALTHAN' )OR( p_proptype = 'LESSEQUALTHAN' ) THEN
     LET p_proptype = aws_TransStandardToSql(p_proptype)
     CASE l_datatype 
       WHEN 'C'
         LET l_result = l_fieldname,p_proptype,"'",p_value,"'"
       WHEN 'D'
#No.FUN-9C0073 ---BEGIN
#         LET l_result = l_fieldname,p_proptype,"to_date('",p_value,"','",p_dateformat,"')"
          LET l_result = l_fieldname,p_proptype,"CAST('",p_value,"' AS '",p_dateformat,"')"
#No.FUN-9C0073 ---END
       OTHERWISE
         LET l_result = l_fieldname,p_proptype,p_value
     END CASE
  ELSE
    IF p_proptype = 'LIKE' THEN
       LET l_result = l_fieldname,' ',p_proptype," '",p_value,"'"
    ELSE
       IF p_proptype = 'BETWEEN' THEN
          LET l_sepidx = p_value.getIndexOf(p_sep,1)
          IF l_sepidx = 0 THEN 
             LET g_ze.ze03 = cl_replace_err_msg(cl_getmsg("aws-134",g_lang),p_propname|| "|" ||p_proptype|| "|" ||p_value)
             RETURN 'aws-134',g_ze.ze03,''
            #RETURN 'aws-xxx','條件'||p_propname||','||p_proptype||','||p_value||'沒有找到BETWEEN語句所需的分隔符',''
          ELSE
             LET l_leftstr = p_value.substring(1,l_sepidx-1)
             IF cl_null(l_leftstr) THEN
                LET g_ze.ze03 = cl_replace_err_msg(cl_getmsg("aws-135",g_lang),p_propname|| "|" ||p_proptype|| "|" ||p_value)
                RETURN 'aws-135',g_ze.ze03,''
               #RETURN 'aws-xxx','條件'||p_propname||','||p_proptype||','||p_value||'傳入BETWEEN語句所需的起始值為空',''
             END IF 
             LET l_rightstr = p_value.substring(l_sepidx+1,p_value.getLength())
             IF cl_null(l_rightstr) THEN
                LET g_ze.ze03 = cl_replace_err_msg(cl_getmsg("aws-136",g_lang),p_propname|| "|" ||p_proptype|| "|" ||p_value)
                RETURN 'aws-136',g_ze.ze03,''
               #RETURN 'aws-xxx','條件'||p_propname||','||p_proptype||','||p_value||'傳入BETWEEN語句所需的截止值為空',''
             END IF 
             
             CASE l_datatype
                WHEN 'C'
                 LET l_result = l_fieldname," BETWEEN '",l_leftstr,"' AND '",l_rightstr,"'"
               WHEN 'D'
#No.FUN-9C0073 ---BEGIN
#                 LET l_result = l_fieldname," BETWEEN to_date('",l_leftstr,"','",p_dateformat,
#                                "') AND to_date('",l_rightstr,"','",p_dateformat,"')"
                 LET l_result = l_fieldname," BETWEEN CAST('",l_leftstr,"' AS '",p_dateformat,
                                 "') AND CAST('",l_rightstr,"' AS '",p_dateformat,"')"
#No.FUN-9C0073 ---END
               OTHERWISE
                 LET l_result = l_fieldname," BETWEEN ",l_leftstr," AND ",l_rightstr
             END CASE            
          END IF 
       ELSE
       	  IF p_proptype = 'IN' THEN
       	     CALL aws_tokenizer(p_value,p_sep,arr_value)
       	     FOR l_i = 1 TO arr_value.getLength()
       	       LET l_tempstr = arr_str[l_i]
               CASE l_datatype
                 WHEN 'C'
                   IF cl_null(l_result) THEN 
                      LET l_result = "'",l_tempstr,"'"
                   ELSE 
                      LET l_result = l_result,",'",l_tempstr,"'"
                   END IF 
                 WHEN 'D'
                   IF cl_null(l_result) THEN
#No.FUN-9C0073 ---BEGIN
#                      LET l_result = "to_date('",l_tempstr,"','",p_dateformat,"')"
                      LET l_result = "CAST('",l_tempstr,"' AS '",p_dateformat,"')"
#No.FUN-9C0073 ---END
                   ELSE
#No.FUN-9C0073 ---BEGIN
#                   	  LET l_result = l_result,",to_date('",l_tempstr,"','",p_dateformat,"')"
                      LET l_result = l_result,",CAST('",l_tempstr,"' AS '",p_dateformat,"')"
#No.FUN-9C0073 ---END
                   END IF   
                 OTHERWISE
                   IF cl_null(l_result) THEN 
                      LET l_result = l_tempstr
                   ELSE 
                      LET l_result = l_result,',',l_tempstr
                   END IF 
               END CASE      
             END FOR              	           	       
       	     IF cl_null(l_result) THEN 
                LET g_ze.ze03 = cl_replace_err_msg(cl_getmsg("aws-137",g_lang),p_propname|| "|" ||p_proptype|| "|" ||p_value)
                RETURN 'aws-137',g_ze.ze03,''
       	       #RETURN 'aws-xxx','條件'||p_propname||','||p_proptype||','||p_value||'未找到IN語句所需的取值列表',''
       	     ELSE 
       	     	LET l_result = l_fieldname," IN(",l_result,")"
       	     END IF 
       	  ELSE 
       	     IF ( p_proptype = 'IS NULL' )OR( p_proptype = 'IS NOT NULL' ) THEN
                LET l_result = l_fieldname,' ',p_proptype
             END IF 
       	  END IF 
       END IF 
    END IF 
  END IF
  
  RETURN '','',l_result
   
END FUNCTION 
 
#遞歸調用解析Group節點的函數
FUNCTION aws_MakeGroupStr(p_objectid,p_sep,p_dateformat,p_node)
DEFINE 
  p_objectid                LIKE wac_file.wac01,
  p_propname                LIKE wac_file.wac03,
  p_sep                     STRING,
  p_dateformat              STRING,
  p_node                    om.DomNode,
  l_node                    om.DomNode,
  l_i                       LIKE type_file.num5,
  l_grptype                 STRING,
  l_propname                STRING,
  l_proptype                STRING,
  l_propvalue               STRING,
  l_result,l_propstr        STRING,
  l_errCode,l_errDesc       STRING
  
  
  LET l_result = '('
  LET l_grptype = p_node.getAttribute('Type')
  FOR l_i = 1 TO p_node.getChildCount() 
      LET l_node = p_node.getChildByIndex(l_i)
      #如果當前下級節點是Group型節點則進行遞歸調用   
      IF l_node.getTagName() = 'Group' THEN 
         CALL aws_MakeGroupStr(p_objectid,p_sep,p_dateformat,l_node)
              RETURNING l_errCode,l_errDesc,l_propstr
         IF NOT cl_null(l_errCode) THEN 
            RETURN l_errCode,l_errDesc,''
         END IF 
         LET l_result = l_result,l_propstr
 
         #如果當前子節點不是傳入節點的最后一個節點，則還要處理節點之間的關系AND/OR
         IF l_i < p_node.getChildCount() THEN
            LET l_result = l_result,l_grptype
         END IF  	    
      ELSE 
      	 #否則，如果是Property型節點則進行解析，其他類型節點則忽略
      	 IF l_node.getTagName() = 'Property' THEN 
            LET l_result = l_result,'('
 
            LET l_propname =  l_node.getAttribute('Name')
            LET l_proptype =  l_node.getAttribute('Type')
            LET l_propvalue = l_node.getAttribute('Value')
 
            #調用一個函數來生成這個條件子句
            CALL aws_MakePropStr(p_objectid,p_sep,p_dateformat,l_propname,l_proptype,l_propvalue) 
                 RETURNING l_errCode,l_errDesc,l_propstr
            IF NOT cl_null(l_errCode) THEN 
               RETURN l_errCode,l_errDesc,''
            END IF 
            LET l_result = l_result,l_propstr
            
            #如果當前子節點不是傳入節點的最后一個節點，則還要處理節點之間的關系AND/OR
            IF l_i < p_node.getChildCount() THEN
               LET l_result = l_result,')',l_grptype
            ELSE 
            	 LET l_result = l_result,')'
            END IF  	    
      	 END IF 
      END IF 
  END FOR
  LET l_result = l_result,')' 
  
  RETURN '','',l_result
END FUNCTION 
 
FUNCTION aws_GetConditionByXML(p_object,p_condition,p_dateformat,p_sep)
DEFINE 
   p_object             LIKE wac_file.wac01, 
   p_condition          STRING,
   p_dateformat         STRING, 
   p_sep                STRING,
   doc                  om.DomDocument,
   condNode             om.DomNode,
   grpNode              om.DomNode,
   l_result             STRING,
   l_errCode,l_errDesc  STRING
  
  
  #首先讀取文件
  LET doc = om.DomDocument.createFromXmlFile(p_condition)
  #如果沒有發現文件，即沒有傳入Condition參數，則返回一個空值
  IF doc IS NULL THEN 
     RETURN '','',''
  ELSE 
     LET condNode = doc.getDocumentElement()
     LET grpNode = condNode.getFirstChild()
     IF grpNode IS NULL THEN
        RETURN '','',''
     ELSE
     	#調用子函數來遞歸解析條件語句
     	CALL aws_MakeGroupStr(p_object,p_sep,p_dateformat,grpNode)
     	     RETURNING l_errCode,l_errDesc,l_result
     	RETURN l_errCode,l_errDesc,l_result
     END IF
  END IF  
END FUNCTION
 
#傳入一個"Field,Operator,Value"類型的字符串,返回拆解完畢的三個段
FUNCTION aws_DivideFieldInfo(p_sysid,p_object,p_fieldstr) 
DEFINE
  p_sysid                   LIKE wai_file.wai01,
  p_object                  LIKE wai_file.wai02,
  p_fieldstr                STRING,
  l_start,l_end             LIKE type_file.num5,
  l_field,l_oper,l_value    STRING,
  l_fieldlist               STRING,
  l_errCode,l_errDesc       STRING,
  l_tok                     base.StringTokenizer,
  l_i                       LIKE type_file.num5
 
  LET p_fieldstr = p_fieldstr.trim()
  #分析并填充相應的字段
  LET l_end = p_fieldstr.getIndexOf(',',1)
  IF l_end = 0 THEN 
     LET g_ze.ze03 = cl_replace_err_msg( cl_getmsg("aws-138",g_lang),p_fieldstr)
     RETURN 'aws-138',g_ze.ze03,'','',''
    #RETURN 'aws-xxx','條件解析錯誤,Property ('||p_fieldstr||')里未包含","分段信息','','',''
  END IF 
  LET l_field = p_fieldstr.subString(1,l_end-1)
  LET l_field = l_field.trim()
  IF cl_null(l_field) THEN 
     LET g_ze.ze03 = cl_replace_err_msg( cl_getmsg("aws-139",g_lang),p_fieldstr)
     RETURN 'aws-139',g_ze.ze03,'','',''
    #RETURN 'aws-xxx','條件解析錯誤,Property ('||p_fieldstr||')里未包含條件欄位信息','','',''
  ELSE 
     #將我們的欄位轉換成對方的屬性
     CALL aws_FieldToProperty(p_sysid,p_object,l_field) RETURNING l_errCode,l_errDesc,l_field
     IF NOT cl_null(l_errCode) THEN 
        RETURN l_errCode,l_errDesc,'','',''
     END IF
  END IF 
 
  LET l_start = l_end + 1
  #第二段:OPERATOR
  LET l_end = p_fieldstr.getIndexOf(',',l_start)
  IF l_end = 0 THEN 
     LET g_ze.ze03 = cl_replace_err_msg( cl_getmsg("aws-140",g_lang),p_fieldstr)
     RETURN 'aws-140',g_ze.ze03,'','',''
    #RETURN 'aws-xxx','條件解析錯誤,Property ('||p_fieldstr||')里","分段數目不足',''
  END IF 
  LET l_oper = p_fieldstr.subString(l_start,l_end-1)
  LET l_oper = aws_TransSqlToStandard(l_oper.trim())
  IF cl_null(l_oper) THEN 
     LET g_ze.ze03 = cl_replace_err_msg( cl_getmsg("aws-141",g_lang),p_fieldstr)
     RETURN 'aws-141',g_ze.ze03,'','',''
    #RETURN 'aws-xxx','條件解析錯誤,Property ('||p_fieldstr||')里未包含條件關系信息','','',''
  END IF   
  
  #如果操作符為IS NULL或IS NOT NULL則不需要第三段了
  LET l_oper = UPSHIFT(l_oper)
  IF ( l_oper = 'IS NULL' )OR( l_oper = 'IS NOT NULL' ) THEN  
     RETURN '','',l_field,l_oper,''
  END IF 
  
  LET l_start = l_end + 1
  #第三段
  LET l_value = p_fieldstr.subString(l_start,p_fieldstr.getLength())
  LET l_value = l_value.trim()
  IF cl_null(l_value) THEN 
     LET g_ze.ze03 = cl_replace_err_msg( cl_getmsg("aws-142",g_lang),p_fieldstr)
     RETURN 'aws-142',g_ze.ze03,'','',''
    #RETURN 'aws-xxx','條件解析錯誤,Property ('||p_fieldstr||')里未包含條件值信息','','',''
  END IF 
 
  #進行可能的選項值替換
  #這里要進行一個處理,因為在Mapping函數中的field和value是一一對應的,而當Condition里面出現IN或BETWEEN
  #子句的時候field和value是一對多關系,所以要復制一個field列表和value對應以正常調用Mapping函數
  LET l_fieldlist = l_field
  LET l_tok = base.StringTokenizer.createExt(l_value,g_Separator,'',TRUE)
  FOR l_i = 1 TO l_tok.countTokens()
      LET l_fieldlist = l_fieldlist,g_Separator,l_field
  END FOR 
  
  CALL aws_MappingValueToTarget(p_sysid,p_object,l_fieldlist,l_value) RETURNING l_errCode,l_errDesc,l_value
  IF NOT cl_null(l_errCode) THEN 
     RETURN l_errCode,l_errDesc,'','',''
  END IF        
 
  RETURN '','',l_field,l_oper,l_value
END FUNCTION 
 
#將傳入的((field,operator,value)AND(...))OR((...))這樣的字符串轉換成為Condition標准XML串
#設計思路︰在Condition字符串中從左至右定位分組標志符(或)，比較本次和上次的分組符類型（初始時上次分組符為''）
#則有以下几種組合︰
# ' ' -> '(' : 第一個分組的起始，記錄一下l_foundA位置即可
# ' ' -> ')' : 出現語法錯誤
# '(' -> ')' : 當前節點是一個Property節點
# '(' -> '(' : 上一個起始符代表一個Group節點，并且現在進入一個下級節點
# ')' -> ')' : 返回上一級的Group節點
# ')' -> '(' : 遇到了兩個節點之間的分組關系，需要填充到上一個節點的屬性中
#對以上的六種情況分別進行處理即可得到返回的XML字符串
FUNCTION aws_GetXMLByCondition(p_sysid,p_object,p_condition,p_sep)
DEFINE
  p_sysid                  LIKE wai_file.wai01,
  p_object                 LIKE wac_file.wac01, 
  p_condition              STRING,
  p_sep                    STRING,                           
  l_result                 STRING,
  l_errCode,l_errDesc      STRING,
  l_parent                 LIKE type_file.num5,
  arr_group                DYNAMIC ARRAY OF RECORD  #存放每一個Group標簽開始位置的數組，用來定義對應的TYPE屬性位置
     type                  STRING,     #該Group的Type屬性(AND或OR)
     typepos               LIKE type_file.num5    #該節點中Type屬性中需被替換的XXX的起始位置
  END RECORD,
  l_fname,l_foper,l_fvalue STRING,
  l_foundA                 STRING,     #上一次找到的關鍵字和本次找到的關鍵字，用于進行邏輯判斷
  l_relation               STRING,     #最近的兩個分組之間的關系 AND/OR
  l_curType                STRING,     #當前節點類型,取值為Property或Group,當讀到)的時候記錄,給)(的時候用
  l_start                  LIKE type_file.num5,   #當前的起始搜索位置
  l_ident,l_propstr        STRING,     #當前的縮進值
  l_nextstart,l_nextend    LIKE type_file.num5    #距離l_start最近的一個(和)的位置
    
    
  LET p_condition = p_condition.trim()
  IF cl_null(p_condition) THEN 
     RETURN '','','' 
  END IF  
  #設置初始的返回值,默認給一個Group,這樣的話類似(xxx)AND(YYY)這樣的語句就可以自動支持了(本來正確的語法應該是
  #((xxx)AND(YYY))的,相當于我們在外層先預加了一層套套
  LET p_condition = '(',p_condition,')'
  #為循環設置初始條件
  LET l_foundA = ''      
  LET l_start = 1
  #開始循環定義下一個分組標識“（”或“）”
  WHILE TRUE 
    LET l_nextend   = p_condition.getIndexOf(')',l_start)
    LET l_nextstart = p_condition.getIndexOf('(',l_start)
    
    #下面進行邏輯判斷
    #首先，如果什么都沒有找到
    IF ( l_nextstart = 0 )AND( l_nextend = 0 ) THEN 
       #如果是第一次尋找，則將整個p_condition作為一個大的Field域來處理
       IF cl_null(l_foundA) THEN 
          CALL aws_DivideFieldInfo(p_sysid,p_object,p_condition) RETURNING l_errCode,l_errDesc,l_fname,l_foper,l_fvalue
          IF NOT cl_null(l_errCode) THEN 
             RETURN l_errCode,l_errDesc,''
          END IF 
          LET l_result = l_result,
                    '      <Group Type="">\n',
                    '        <Property Name="',l_fname,'" Type="',l_foper,'" Value="',l_fvalue,'" />\n',
                    '      </Group>\n'
          #不用再循環了          
          EXIT WHILE 
       ELSE
       	  #否則要判斷（）是否成對出現       
          IF arr_group.getLength() > 1 THEN 
             LET g_ze.ze03 = cl_getmsg("aws-143",g_lang)
             RETURN 'aws-143',g_ze.ze03,''
            #RETURN 'aws-xxx','條件解析錯誤,分組符號（）必須成對出現',''
          ELSE 
             #如果是成對出現則正常結束循環
             EXIT WHILE
          END IF 
       END IF
    #如果至少找到了一個分組符    
    ELSE 
       #如果是“（”比較靠前，則要結合前一個字符（即l_foundA）來判斷
       IF ( l_nextstart > 0 )AND( l_nextstart < l_nextend ) THEN 
          #如果前一個是""，即第一個分組的起始標志，則記錄這個分組的相關信息
          IF cl_null(l_foundA) THEN 
             LET l_foundA = '('
             LET l_ident = '      '    #設置初始的縮進值
          ELSE 
             #如果前一個是"("，即 ( -> ( ，這種情況說明遇到了下級節點，前一個節點被理解為一個Group節點
             IF l_foundA = '(' THEN 
                #記錄前一個節點的位置,以及對應的縮進等情況
                LET l_result = l_result,l_ident,'<Group Type="XXX">\n'
                LET l_ident = l_ident,'  '   #進入下一級節點縮進量要增加
                #向堆棧中壓前一個(表示的Group中需替換的Type屬性的位置值 
                CALL arr_group.appendElement()
                LET arr_group[arr_group.getLength()].typepos = l_result.getLength() - 5        #是-4還是-5需要測試
             ELSE 
                #如果前一個是")"，即 ) -> ( ，這種情況說明遇到了兩個平級節點之間的關系，要記載并更新到其父節點的Type屬性中
                LET l_relation = p_condition.subString(l_start,l_nextstart-1)
                LET l_relation = l_relation.trim()
                LET l_relation = UPSHIFT(l_relation)
                IF (cl_null(l_relation))OR(( l_relation <> 'AND' )AND( l_relation <> 'OR' )) THEN 
                   LET g_ze.ze03 = cl_getmsg("aws-144",g_lang)
                   RETURN 'aws-144',g_ze.ze03,''
                  #RETURN 'aws-xxx','條件解析錯誤,分組之間必須有AND或OR的關系',''
                END IF 
                #如果此時沒有發現父節點,則說明一定是Group出錯了
                IF arr_group.getLength() = 0 THEN 
                   LET g_ze.ze03 = cl_getmsg("aws-145",g_lang)
                   RETURN 'aws-145',g_ze.ze03,''
                  #RETURN 'aws-xxx','條件解析錯誤,分組標識不正確',''
                END IF 
                #判斷其父節點的類型
                #說明:堆棧中的最頂層節點一定是當前節點的父節點,所以無需再用一個變量來進行記錄
                IF cl_null(arr_group[arr_group.getLength()].type) THEN 
                   #如果當前沒有內容則把本次找到的關系填充進去
                   LET arr_group[arr_group.getLength()].type = l_relation
                ELSE
                   #否則,如果當前的Type內容和本次不一樣,則要報錯(同一個Group中只允許一種關系)
                   #如果一樣就什么也不用做了
                   IF arr_group[arr_group.getLength()].type <> l_relation THEN 
                      LET g_ze.ze03 = cl_getmsg("aws-146",g_lang)
                      RETURN 'aws-146',g_ze.ze03,''
                     #RETURN 'aws-xxx','條件解析錯誤,同一分組下只能包含一種關系',''
                   END IF 
                END IF 
             END IF 
          END IF 
        
          #設置l_foundA標志以及下次搜索起始位置
          LET l_foundA = '('
          LET l_start = l_nextstart + 1
          
       #否則，即“）”比較靠前，也要結合前一個字符（即l_foundA）來判斷
       ELSE
          #如果前一個是""，則表示出現了語法錯誤
          IF cl_null(l_foundA) THEN 
             LET g_ze.ze03 = cl_getmsg("aws-147",g_lang)
             RETURN 'aws-147',g_ze.ze03,''
            #RETURN 'aws-xxx','條件解析錯誤，沒有分組開始符"("',''
          ELSE 
             #如果前一個是"("，即 ( -> ) ，這種情況說明遇到一個Property節點
             IF l_foundA = '(' THEN 
                LET l_propstr = p_condition.subString(l_start,l_nextend - 1)
                CALL aws_DivideFieldInfo(p_sysid,p_object,l_propstr) RETURNING l_errCode,l_errDesc,l_fname,l_foper,l_fvalue
                IF NOT cl_null(l_errCode) THEN 
                   RETURN l_errCode,l_errDesc,''
                END IF 
                LET l_result = l_result,l_ident,
                               '<Property Name="',l_fname,'" Type="',l_foper,'" Value="',l_fvalue,'" />\n'
             ELSE 
       	        #如果前一個是")"，即 ) -> ) ，這種情況說明從當前分組返回了上級分組
                LET l_ident = l_ident.substring(1,l_ident.getLength()-2)  #首先縮減縮進值
                LET l_result = l_result,l_ident,'</Group>\n'            #增加一個屬性結束標志                
                #根據當前的type內容更新XML字符串中對應的Type="XXX"
                LET l_result = l_result.subString(1,arr_group[arr_group.getLength()].typepos-1),arr_group[arr_group.getLength()].type,
                               l_result.subString(arr_group[arr_group.getLength()].typepos+3,l_result.getLength())
                CALL arr_group.deleteElement(arr_group.getLength())     #把當前的Group從堆棧中彈出來
             END IF 
          END IF 
          
          #設置l_foundA標志以及下次搜索起始位置
          LET l_foundA = ')'
          LET l_start = l_nextend + 1
          
       END IF 
    END IF 
 
  END WHILE
  
  #返回合成的XML字符串
  LET l_result = '    <Condition>\n',l_result,'    </Condition>\n'
  RETURN '','',l_result
 
END FUNCTION
 
 
 
FUNCTION aws_Tokenizer(p_str,p_sep,p_arr)
DEFINE
  p_str     STRING,
  p_sep     STRING,
  p_arr     DYNAMIC ARRAY OF STRING,
  l_seplen  LIKE type_file.num5,
  l_pos     LIKE type_file.num5,
  l_i       LIKE type_file.num5,
  l_start   LIKE type_file.num5
 
  CALL p_arr.clear()
  LET l_seplen = p_sep.getLength()
  IF l_seplen = 0 THEN
     LET p_arr[1] = p_str 
     RETURN 
  END IF
 
  LET l_i = 1
  LET l_start = 1
  LET l_pos = p_str.getIndexOf(p_sep,1)
  WHILE l_pos > 0 
    LET p_arr[l_i] = p_str.subString(l_start,l_pos-1)
    LET l_pos = l_pos + l_seplen
    LET l_start = l_pos
    LET l_pos = p_str.getIndexOf(p_sep,l_pos)
    LET l_i = l_i + 1
  END WHILE  
  LET p_arr[l_i] = p_str.subString(l_start,LENGTH(p_str)) 
 
END FUNCTION
 
FUNCTION aws_notin(p_value,p_find)
   DEFINE  p_value    STRING
   DEFINE  p_sep      STRING
   DEFINE  l_num      LIKE type_file.num5  
   DEFINE  p_find     STRING
   
   LET l_num = p_value.getIndexOf(p_find,1)
   
   RETURN l_num 
   
END FUNCTION  
 
 
FUNCTION aws_transfer_xml(p_object,p_xmlFile,p_sep,p_from,p_to)
DEFINE 
  p_object          STRING,
  p_xmlFile         STRING,
  p_sep             STRING,
  p_from            STRING,
  p_to              STRING,
  
  l_errCode         STRING,
  l_errDesc         STRING
  
  IF p_from.trim() = p_to.trim() THEN 
     RETURN '',''
  END IF 
  
  IF p_from = 'Single' THEN
     IF p_to = 'Join'  THEN 
        CALL aws_Single2Join(p_object,p_xmlFile,p_sep) RETURNING l_errCode,l_errDesc
     ELSE 
     	IF p_to = 'Logic' THEN 
     	   CALL aws_Single2Logic(p_object,p_xmlFile,p_sep) RETURNING l_errCode,l_errDesc 
        ELSE 
           LET l_errCode = 'aws-202' 
           LET l_errDesc = cl_replace_err_msg( cl_getmsg(l_errCode,g_lang),p_to)
        END IF 
     END IF 
  ELSE 
     IF p_from = 'Join' THEN
        IF p_to = 'Logic'  THEN 
           CALL aws_Join2Logic(p_object,p_xmlFile,p_sep) RETURNING l_errCode,l_errDesc
        ELSE 
           IF p_to = 'Single' THEN 
              CALL aws_Join2Single(p_object,p_xmlFile,p_sep) RETURNING l_errCode,l_errDesc 
           ELSE 
              LET l_errCode = 'aws-202' 
              LET l_errDesc = cl_replace_err_msg( cl_getmsg(l_errCode,g_lang),p_to)
           END IF 
        END IF 
     ELSE 
        IF p_from = 'Logic' THEN
           IF p_to = 'Single'  THEN 
              CALL aws_Logic2Single(p_object,p_xmlFile,p_sep) RETURNING l_errCode,l_errDesc
           ELSE 
              IF p_to = 'Join' THEN 
                 CALL aws_Logic2Join(p_object,p_xmlFile,p_sep) RETURNING l_errCode,l_errDesc 
              ELSE 
                 LET l_errCode = 'aws-202' 
                 LET l_errDesc = cl_replace_err_msg( cl_getmsg(l_errCode,g_lang),p_to)
              END IF 
           END IF 
        ELSE 
           LET l_errCode = 'aws-219' 
           LET l_errDesc = cl_replace_err_msg( cl_getmsg(l_errCode,g_lang),p_from)
     	END IF 
     END IF 
  END IF 
     	
  RETURN l_errCode, l_errDesc
END FUNCTION 
 
FUNCTION aws_default_data(li_objectid,li_type,li_sep,li_rec_data,li_index,p_dateformat)
DEFINE 
  li_objectid      LIKE wac_file.wac01,
  li_type          LIKE wab_file.wab08,
  li_sep           STRING,
  li_i             LIKE type_file.num5,
  li_sql           STRING,
  ll_sql           STRING,
  li_index         LIKE type_file.num5,
  p_dateformat     STRING,
  li_field         STRING,
  li_data          STRING,
  li_tmp_field     LIKE wac_file.wac03,
  li_tmp_data      STRING, 
  li_wac06         LIKE wac_file.wac06,
  li_wac15         LIKE wac_file.wac15,
 
  li_rec_data     DYNAMIC ARRAY OF RECORD
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
 
  LET li_field = ''
  LET li_data = ''
  CASE li_type
     WHEN "head"
        LET li_sql="SELECT wac03,wac15 FROM wac_file WHERE wac01='",li_objectid,"' AND wac02='",li_rec_data[li_index].tables,"' AND wac15 IS NOT NULL"
        LET ll_sql="SELECT wac03 FROM wac_file WHERE wac01='",li_objectid,"' AND wac02='",li_rec_data[li_index].tables,"' AND wac15 IS NULL AND wac09='Y'"
     WHEN "body"
        LET li_sql="SELECT wac03,wac15 FROM wac_file WHERE wac01='",li_objectid,"' AND wac02='",li_rec_data[li_index].body[1].tables,"' AND wac15 IS NOT NULL"
        LET ll_sql="SELECT wac03 FROM wac_file WHERE wac01='",li_objectid,"' AND wac02='",li_rec_data[li_index].body[1].tables,"' AND wac15 IS NULL AND wac09='Y'"
     WHEN "detail"
        LET li_sql="SELECT wac03,wac15 FROM wac_file WHERE wac01='",li_objectid,"' AND wac02='",li_rec_data[li_index].body[1].detail[1].tables,"' AND wac15 IS NOT NULL"
        LET ll_sql="SELECT wac03 FROM wac_file WHERE wac01='",li_objectid,"' AND wac02='",li_rec_data[li_index].body[1].detail[1].tables,"' AND wac15 IS NULL AND wac09='Y'"
     WHEN "subdetail"
        LET li_sql="SELECT wac03,wac15 FROM wac_file WHERE wac01='",li_objectid,"' AND wac02='",li_rec_data[li_index].body[1].detail[1].subdetail[1].tables,"' AND wac15 IS NOT NULL"
        LET ll_sql="SELECT wac03 FROM wac_file WHERE wac01='",li_objectid,"' AND wac02='",li_rec_data[li_index].body[1].detail[1].subdetail[1].tables,"' AND wac15 IS NULL AND wac09='Y'"
     OTHERWISE 
        LET li_sql="SELECT wac03,wac15 FROM wac_file WHERE wac01='ITEM' AND wac02='ima_file' AND wac15 IS NOT NULL"
        LET ll_sql="SELECT wac03 FROM wac_file WHERE wac01='ITEM' AND wac02='ima_file' AND wac15 IS NULL AND wac09='Y'"
  END CASE
  PREPARE wac_m FROM li_sql
  DECLARE wac_m_curs         #SCROLL CURSOR
    CURSOR FOR wac_m
 
  FOREACH wac_m_curs INTO li_tmp_field,li_wac15
    LET li_tmp_data = li_wac15
    CASE li_type
       WHEN "head"
          LET li_i=li_rec_data[li_index].fields.getIndexOf(li_tmp_field,1)
       WHEN "body"
          LET li_i=li_rec_data[li_index].body[1].fields.getIndexOf(li_tmp_field,1)
       WHEN "detail"
          LET li_i=li_rec_data[li_index].body[1].detail[1].fields.getIndexOf(li_tmp_field,1)
       WHEN "subdetail"
          LET li_i=li_rec_data[li_index].body[1].detail[1].subdetail[1].fields.getIndexOf(li_tmp_field,1)
       OTHERWISE
          LET li_i=1
    END CASE
    IF li_i<=0 THEN 
       CASE li_tmp_data
          WHEN "@g_user"
             LET li_tmp_data=g_user
          WHEN "@g_today"
             LET li_tmp_data=g_today
          WHEN "@g_grup"
             LET li_tmp_data=g_grup
          WHEN "@g_plant"
             LET li_tmp_data=g_plant
          WHEN "@blank"
             LET li_tmp_data=' '
          OTHERWISE
             LET li_tmp_data=li_tmp_data
       END CASE
       SELECT wac06 INTO li_wac06 FROM wac_file 
        WHERE wac01 = li_objectid AND wac03 = li_tmp_field
       IF li_wac06 <>'D' THEN 
          IF li_wac06 = 'N' THEN 
             LET li_tmp_data = "'",li_tmp_data CLIPPED,"'"
          END IF 
          IF li_wac06 = 'C' THEN 
             LET li_tmp_data = "'",li_tmp_data,"'"
          END IF 
       ELSE 
          IF li_wac06 = 'D' THEN
#No.FUN-9C0073 ---BEGIN
#             LET li_tmp_data = "to_date('",li_tmp_data,"','",li_dateformat,"')"
             LET li_tmp_data = "CAST('",li_tmp_data,"' AS '",p_dateformat,"')"
#No.FUN-9C0073 ---END
          END IF 
       END IF 
       IF cl_null(li_field) THEN 
          LET li_field = li_tmp_field
          LET li_data = li_tmp_data
       ELSE 
          LET li_field = li_field,",",li_tmp_field
          LET li_data = li_data,",",li_tmp_data
       END IF     
    END IF     
  END FOREACH
  IF SQLCA.sqlcode THEN
     LET li_field = ''
     LET li_data = ''
  END IF
 
  PREPARE wac_n FROM ll_sql
  DECLARE wac_n_curs         #SCROLL CURSOR
    CURSOR FOR wac_n
 
  FOREACH wac_n_curs INTO li_tmp_field
    CASE li_type
       WHEN "head"
          LET li_i=li_rec_data[li_index].fields.getIndexOf(li_tmp_field,1)
       WHEN "body"
          LET li_i=li_rec_data[li_index].body[1].fields.getIndexOf(li_tmp_field,1)
       WHEN "detail"
          LET li_i=li_rec_data[li_index].body[1].detail[1].fields.getIndexOf(li_tmp_field,1)
       WHEN "subdetail"
          LET li_i=li_rec_data[li_index].body[1].detail[1].subdetail[1].fields.getIndexOf(li_tmp_field,1)
       OTHERWISE
          LET li_i=1
    END CASE
    IF li_i<=0 THEN 
       SELECT wac06 INTO li_wac06 FROM wac_file 
        WHERE wac01 = li_objectid AND wac03 = li_tmp_field
       IF li_wac06 <>'D' THEN 
          IF li_wac06 = 'N' THEN 
             LET li_tmp_data = "'0'"
          END IF 
          IF li_wac06 = 'C' THEN 
             LET li_tmp_data = "' '"
          END IF 
       ELSE 
          IF li_wac06 = 'D' THEN 
             LET li_tmp_data = "''"
          END IF 
       END IF 
       IF cl_null(li_field) THEN 
          LET li_field = li_tmp_field
          LET li_data = li_tmp_data
       ELSE 
          LET li_field = li_field,",",li_tmp_field
          LET li_data = li_data,",",li_tmp_data
       END IF     
    END IF     
  END FOREACH
  IF SQLCA.sqlcode THEN
     RETURN '',''
  ELSE                      
     RETURN li_field,li_data  
  END IF
 
END FUNCTION
#No.FUN-9C0073 ----------------By chenls 10/01/11
