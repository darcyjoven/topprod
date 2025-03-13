# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aws_transXML.4gl
# Descriptions...: TIPTOP標准數據格式(Logic, Single, Join)之間的轉換
# Date & Author..: 2006-07-03 By Lifeng , will , Heartheros and Maven
# Modify.........: 新建 FUN-8A0122 by binbin
# Modify.........: No.MOD-960008 09/06/01 By shengbb hasMoreTokens() bug
# Function Desc..:
# ---------------------------------------------------------------
# aws_Logic2Single   Logic格式向Single格式轉換
# aws_Logic2Join     Logic格式向Join格式轉換
# aws_Single2Logic   Single格式向Logic格式轉換
# aws_Single2Join    Single格式向Join格式轉換
# aws_Join2Single    Join格式向Single格式轉換
# aws_Join2Logic     Join格式向Logic格式轉換
# ---------------------------------------------------------------
#test function
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正
 
DATABASE ds
#全局變量聲明
 
GLOBALS "../../config/top.global"
 
DEFINE g_ze          RECORD LIKE  ze_file.* 
DEFINE   
  s,e       ARRAY[5] OF LIKE type_file.num5,
  aData     DYNAMIC ARRAY OF STRING,
  sOut      base.StringBuffer,
  aMap      DYNAMIC ARRAY OF LIKE type_file.num5
 
{
MAIN
DEFINE
  str,sOutput     STRING,
  sbXml   STRING,
  l_errCode,l_errDesc,l_outString  STRING
    
    CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80064   ADD
       
    LET sbxml = ARG_VAL(1)
    LET str = ARG_VAL(2)
    CASE str
        WHEN 'L2J'
           CALL aws_Logic2Join('BOM',sbXml,'^*^') RETURNING l_errCode,l_errDesc
           #CALL aws_Logic2Join('BOM',sbXml,'|') RETURNING l_errCode,l_errDesc
        WHEN 'S2J'
           CALL aws_Single2Join('BOM',sbXml,'^*^') RETURNING l_errCode,l_errDesc
           #CALL aws_Single2Join('BOM',sbXml,'|') RETURNING l_errCode,l_errDesc
        WHEN 'L2S'
           CALL aws_Logic2Single('BOM',sbXml,'^*^') RETURNING l_errCode,l_errDesc
           #CALL aws_Logic2Single('BOM',sbXml,'|') RETURNING l_errCode,l_errDesc
        WHEN 'S2L'
           CALL aws_Single2Logic('BOM',sbXml,'^*^') RETURNING l_errCode,l_errDesc
           #CALL aws_Single2Logic('BOM',sbXml,'|') RETURNING l_errCode,l_errDesc
        WHEN 'J2S'
           CALL aws_Join2Single('BOM',sbXml,'^*^') RETURNING l_errCode,l_errDesc
           #CALL aws_Join2Single('BOM',sbXml,'|') RETURNING l_errCode,l_errDesc
        WHEN 'J2L'
           CALL aws_Join2Logic('BOM',sbXml,'^*^') RETURNING l_errCode,l_errDesc
           #CALL aws_Join2Logic('BOM',sbXml,'|') RETURNING l_errCode,l_errDesc
    END CASE
    IF NOT cl_null(l_errCode) THEN
       DISPLAY l_errCode,l_errDesc
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80064   ADD
END MAIN
}
FUNCTION aws_Logic2Single(sObjectID,sInput,sDiv)
DEFINE
  #sObjectID STRING,            mark by zqj 06/07/24
  sObjectID  LIKE type_file.chr50,
  sInput    STRING,
  sDiv      STRING,
  sOutput   STRING,
  l_head,l_body,l_detail,l_sdetail LIKE type_file.chr20,  #各個級別表對應的表名 #mark by zqj06/07/24
  f_head,f_body,f_detail,f_sdetail STRING,       #各個級別表所包含的字段列表
  d_head,d_body,d_detail,d_sdetail STRING,       #各個級別表所包含的數據列表
    
  input_xml    STRING,      
  l_cmd,e      STRING,
  r            om.XmlReader,
  a            om.SaxAttributes,
  i,iID        LIKE type_file.num5,
  sID          STRING,
  p_head,p_body,p_detail    STRING,
  sFormat      STRING,
  sTagName     STRING,
  sTemp        STRING
   
  
  #首先根據ObjectID得到Head、Body、Detail和SubDetail對應的表名
  SELECT wab02 INTO l_head    FROM wab_file WHERE wab01 = sObjectID AND wab08 = 'Head'
  SELECT wab02 INTO l_body    FROM wab_file WHERE wab01 = sObjectID AND wab08 = 'Body'
  SELECT wab02 INTO l_detail  FROM wab_file WHERE wab01 = sObjectID AND wab08 = 'Detail'
  SELECT wab02 INTO l_sdetail FROM wab_file WHERE wab01 = sObjectID AND wab08 = 'SubDetail'  
     
  #初始化ID值
  LET iID = 1    
      
  #開始解析XML文件
  #LET r = om.XmlReader.createFileReader(input_xml)
  LET r = om.XmlReader.createFileReader(sInput)
  LET a = r.getAttributes()
  LET e = r.read()
  WHILE e IS NOT NULL
    CASE e
      #當讀到各個節點的時候
      WHEN "StartElement"
        #讀取節點的名稱(Data/DataSet/Head/Body/Detail/SubDetail)
        LET sTagName = r.getTagName()
        CASE sTagName 
          #如果是Data節點，則讀取Format屬性
          WHEN "Data"
            LET sFormat = ''
            FOR i=1 TO a.getLength()
              IF a.getName(i) = 'Format' THEN
                 LET sFormat = a.getValueByIndex(i)
                 EXIT FOR
              END IF
            END FOR
            #校驗：本函數只處理Logic類型的XML文件
            IF sFormat <> 'Logic' THEN 
               LET g_ze.ze03 = cl_getmsg("aws-247", g_lang)
               RETURN 'aws-247',g_ze.ze03
              #RETURN 'aws-247','非法的數據格式'
            END IF
            #初始化返回值
            LET sOutput = '<Data Format="Single">'
          
          #如果是DataSet節點則讀取各個字段列表
          WHEN "DataSet"
            FOR i=1 TO a.getLength()
              IF a.getName(i) = 'Head' THEN
                 LET f_head = a.getValueByIndex(i)
              END IF
              IF a.getName(i) = 'Body' THEN
                 LET f_body = a.getValueByIndex(i)
              END IF
              IF a.getName(i) = 'Detail' THEN
                 LET f_detail = a.getValueByIndex(i)
              END IF
              IF a.getName(i) = 'SubDetail' THEN
                 LET f_sdetail = a.getValueByIndex(i)
              END IF              
            END FOR
            #如果用戶沒有輸入也不要緊，原樣轉換到Single格式中就可以了
            
          #如果是Head節點則添加內容到d_head
          WHEN "Head"
            FOR i=1 TO a.getLength()
              IF a.getName(i) = 'Data' THEN
                 LET sID = iID
                 LET p_Head = sID
                 LET iID = iID + 1
                 LET d_head = d_head,'\n','<Row ID="',sID,'" Parent="" Data="',a.getValueByIndex(i),'" />'
              END IF            
            END FOR
          #如果是Body節點則添加內容到d_body
          WHEN "Body"
            FOR i=1 TO a.getLength()
              IF a.getName(i) = 'Data' THEN
                 LET sID = iID
                 LET p_body = sID
                 LET iID = iID + 1
                 LET d_body = d_body,'\n','<Row ID="',sID,'" Parent="',p_Head,'" Data="',a.getValueByIndex(i),'" />'
              END IF            
            END FOR
          #如果是Detail節點則添加內容到d_detail
          WHEN "Detail"
            FOR i=1 TO a.getLength()
              IF a.getName(i) = 'Data' THEN
                 LET sID = iID
                 LET p_detail = sID
                 LET iID = iID + 1
                 LET d_detail = d_detail,'\n','<Row ID="',sID,'" Parent="',p_Body,'" Data="',a.getValueByIndex(i),'" />'
              END IF            
            END FOR
          #如果是SubDetail節點則添加內容到d_sdetail
          WHEN "SubDetail"
            FOR i=1 TO a.getLength()
              IF a.getName(i) = 'Data' THEN
                 LET sID = iID
                 LET iID = iID + 1
                 LET d_sdetail = d_sdetail,'\n','<Row ID="',sID,'" Parent="',p_Detail,'" Data="',a.getValueByIndex(i),'" />'
              END IF            
            END FOR
        END CASE
 
      WHEN "EndElement"
        #讀取節點的名稱(Data/DataSet/Head/Body/Detail/SubDetail)
        LET sTagName = r.getTagName()
        CASE sTagName 
          #如果是Data節點，則在最后添加結束的</Data>標簽
          WHEN "Data"
            LET sOutput = sOutput,'\n','</Data>'
            
          #如果是DataSet節點，則將本次的DataSet寫入目標XML文件
          #需要注意的是Logic格式中的一個DataSet節點可能會在Single節點中生成多個DataSet節點
          WHEN "DataSet"
            #如果有Head表
            IF NOT cl_null(l_head) THEN
               #合成目標文件中的DataSet標簽
               LET sTemp = '<DataSet Table="',l_head,'" '
               IF NOT cl_null(f_head) THEN 
                  LET sTemp = sTemp,'Field="',f_head,'">'
               ELSE 
               	  LET sTemp = sTemp,'>'             
               END IF                
               #添加前面合成的Head數據并完成當前這個DataSet標簽
               LET sTemp = sTemp,d_head,'\n','</DataSet>'
               #將當前這個DataSet寫入到目標文件中
               LET sOutput = sOutput,'\n',sTemp
            END IF   
            #如果有Body表
            IF NOT cl_null(l_body) THEN
               #合成目標文件中的DataSet標簽
               LET sTemp = '<DataSet Table="',l_body,'" '
               IF NOT cl_null(f_body) THEN 
                  LET sTemp = sTemp,'Field="',f_body,'">'
               ELSE 
               	  LET sTemp = sTemp,'>'
               END IF                
               #添加前面合成的Body數據并完成當前這個DataSet標簽
               LET sTemp = sTemp,d_body,'\n','</DataSet>'
               #將當前這個DataSet寫入到目標文件中
               LET sOutput = sOutput,'\n',sTemp
            END IF   
            #如果有Detail表
            IF NOT cl_null(l_detail) THEN
               #合成目標文件中的DataSet標簽
               LET sTemp = '<DataSet Table="',l_detail,'" '
               IF cl_null(f_detail) THEN 
                  LET sTemp = sTemp,'Field="',f_detail,'">'
               ELSE 
               	  LET sTemp = sTemp,'>'
               END IF                
               #添加前面合成的Detail數據并完成當前這個DataSet標簽
               LET sTemp = sTemp,d_detail,'\n','</DataSet>'
               #將當前這個DataSet寫入到目標文件中
               LET sOutput = sOutput,'\n',sTemp
            END IF   
            #如果有SubDetail表
            IF NOT cl_null(l_sdetail) THEN
               #合成目標文件中的DataSet標簽
               LET sTemp = '<DataSet Table="',l_sdetail,'" '
               IF cl_null(f_sdetail) THEN 
                  LET sTemp = sTemp,'Field="',f_sdetail,'">'
               ELSE 
               	  LET sTemp = sTemp,'>'
               END IF                
               #添加前面合成的SubDetail數據并完成當前這個DataSet標簽
               LET sTemp = sTemp,d_sdetail,'\n','</DataSet>'
               #將當前這個DataSet寫入到目標文件中
               LET sOutput = sOutput,'\n',sTemp
            END IF   
       END CASE 
     END CASE
  #END CASE  marked by zqj 06/07/24
    LET e = r.read()
  END WHILE
  #mod by zqj 06/07/24
  #RETURN 1,sOutput
  RUN "echo '"||sOutput||"' >"||sInput
  RETURN '',''
END FUNCTION
 
FUNCTION aws_Logic2Join(sObjectID,sInput,sDiv)
DEFINE
  sObjectID STRING,
  sInput    STRING,
  sDiv      STRING,
  sOutput   STRING, 
  f_head,f_body,f_detail,f_sdetail STRING,          #各個級別表所包含的字段列表
  d_head,d_body,d_detail,d_sdetail STRING,          #各個級別表所包含的數據列表  
  has_head,has_body,has_detail,has_sdetail STRING,  #是否包含各級數據的數據列表
  v_head,v_body,v_detail,v_sdetail STRING,        #各個級別中的默認數據列表（即只包含標准分隔符，且count等于FieldCount）
  input_xml    STRING,      
  l_cmd,e      STRING,
  r            om.XmlReader,
  a            om.SaxAttributes,
  i,iCount     LIKE type_file.num5,
  sFormat      STRING,
  #l_wac03      LIKE wac_file.wac03,
  tok          base.StringTokenizer,
  sTagName     STRING
       
  #開始解析XML文件
  #LET r = om.XmlReader.createFileReader(input_xml)
  LET r = om.XmlReader.createFileReader(sInput)
  LET a = r.getAttributes()
  LET e = r.read()
  WHILE e IS NOT NULL
    CASE e
      #當讀到各個節點的時候
      WHEN "StartElement"
        #讀取節點的名稱(Data/DataSet/Head/Body/Detail/SubDetail)
        LET sTagName = r.getTagName()
        CASE sTagName 
          #如果是Data節點，則讀取Format屬性
          WHEN "Data"
            LET sFormat = ''
            FOR i=1 TO a.getLength()
              IF a.getName(i) = 'Format' THEN
                 LET sFormat = a.getValueByIndex(i)
                 EXIT FOR
              END IF
            END FOR
            #校驗：本函數只處理Logic類型的XML文件
            IF sFormat <> 'Logic' THEN 
               #mod by zqj 06/07/24
               #RETURN -1,'非法的數據格式'
               LET g_ze.ze03 = cl_getmsg("aws-247", g_lang)
               RETURN 'aws-247',g_ze.ze03
              #RETURN 'aws-247','非法的數據格式'
            END IF
            #初始化返回值
            LET sOutput = '<Data Format="Join">'
            #初始化默認字符列表
            LET v_head    = ''
            LET v_body    = ''
            LET v_detail  = ''
            LET v_sdetail = ''
          
          #如果是DataSet節點則讀取各個字段列表并合成為統一的一個字段列表
          WHEN "DataSet"
            FOR i=1 TO a.getLength()
              IF a.getName(i) = 'Head' THEN
                 LET f_head = a.getValueByIndex(i)
                 LET f_head = f_head.trim()
              END IF
              IF a.getName(i) = 'Body' THEN
                 LET f_body = a.getValueByIndex(i)
                 LET f_body = f_body.trim()
              END IF
              IF a.getName(i) = 'Detail' THEN
                 LET f_detail = a.getValueByIndex(i)
                 LET f_detail = f_detail.trim()
              END IF
              IF a.getName(i) = 'SubDetail' THEN
                 LET f_sdetail = a.getValueByIndex(i)
                 LET f_sdetail = f_sdetail.trim()
              END IF              
            END FOR
            #合成結果XML中的DataSet標簽
            #mod BY zqj 06/07/25 若f_detail為空則多出兩個sDiv顯示
            #LET sOutput = sOutput,'\n','<DataSet Field="',f_head,sDiv,f_body,sDiv,
            #              f_detail,sDiv,f_sdetail,'">'
            LET sOutput = sOutput,'\n','<DataSet Field="'
            IF NOT cl_null(f_head) THEN
               LET sOutput = sOutput||f_head
            END IF
            IF NOT cl_null(f_body) THEN
               LET sOutput = sOutput||sDiv||f_body
            END IF
            IF NOT cl_null(f_detail) THEN
               LET sOutput = sOutput||sDiv||f_detail
            END IF
            IF NOT cl_null(f_sdetail) THEN
               LET sOutput = sOutput||sDiv||f_sdetail
            END IF
            LET sOutput = sOutput,'">'
            #END mod 
            #得到各個級別的默認數據（空的，只包含分隔符的
            LET tok = base.stringTokenizer.createExt(f_head.trim(),sDiv,'',TRUE)
            LET iCount = tok.countTokens()
            FOR i=1 TO iCount - 1    #分隔符的數量＝欄位數量-1
                LET v_head = v_head,sDiv
            END FOR
            LET tok = base.stringTokenizer.createExt(f_body.trim(),sDiv,'',TRUE)
            LET iCount = tok.countTokens()
            FOR i=1 TO iCount - 1    #分隔符的數量＝欄位數量-1
                LET v_body = v_body,sDiv
            END FOR
            LET tok = base.stringTokenizer.createExt(f_detail.trim(),sDiv,'',TRUE)
            LET iCount = tok.countTokens()
            FOR i=1 TO iCount - 1    #分隔符的數量＝欄位數量-1
                LET v_detail = v_detail,sDiv
            END FOR
            LET tok = base.stringTokenizer.createExt(f_sdetail.trim(),sDiv,'',TRUE)
            LET iCount = tok.countTokens()
            FOR i=1 TO iCount - 1    #分隔符的數量＝欄位數量-1
                LET v_sdetail = v_sdetail,sDiv
            END FOR
            #初始化各個段的數據
            LET d_head    = ''
            LET d_body    = ''
            LET d_detail  = ''
            LET d_sdetail = ''
            
            
          #如果是Head節點記錄下當前的Head內容
          WHEN "Head"
            FOR i=1 TO a.getLength()
              IF a.getName(i) = 'Data' THEN
                 LET d_head = a.getValueByIndex(i)
              END IF
            END FOR
            #設置各個標志變量的值
            LET has_head    = TRUE
            LET has_body    = FALSE
            LET has_detail  = FALSE
            LET has_sdetail = FALSE
            #設置各個子段的數據初始值
            LET d_body      = ''
            LET d_detail    = ''
            LET d_sdetail   = ''
             
          #如果是Body節點則添加內容到d_body
          WHEN "Body"
            FOR i=1 TO a.getLength()
              #記錄下當前的Body內容
              IF a.getName(i) = 'Data' THEN
                 LET d_body = a.getValueByIndex(i)
              END IF            
            END FOR
            #設置各個標志變量的值
            LET has_body    = TRUE
            LET has_detail  = FALSE
            LET has_sdetail = FALSE
            #設置各個子段的數據初始值
            LET d_detail    = ''
            LET d_sdetail   = ''    
            
          #如果是Detail節點則添加內容到d_detail
          WHEN "Detail"
            FOR i=1 TO a.getLength()
              IF a.getName(i) = 'Data' THEN
                 LET d_detail = a.getValueByIndex(i)
              END IF            
            END FOR
            #設置各個標志變量的值
            LET has_detail  = TRUE
            LET has_sdetail = FALSE
            #設置各個子段的數據初始值
            LET d_sdetail   = ''
            
          #如果是SubDetail節點則添加內容到d_sdetail
          WHEN "SubDetail"
            FOR i=1 TO a.getLength()
              IF a.getName(i) = 'Data' THEN
                 LET d_sdetail = a.getValueByIndex(i)
              END IF            
            END FOR
            #設置各個標志變量的值
            LET has_sdetail = TRUE
        END CASE
 
      WHEN "EndElement"
        #讀取節點的名稱(Data/DataSet/Head/Body/Detail/SubDetail)
        LET sTagName = r.getTagName()
        CASE sTagName 
          #如果是Data節點，則在最后添加結束的</Data>標簽
          WHEN "Data"
            LET sOutput = sOutput,'\n','</Data>'
 
          #如果是DataSet節點，則將本次的DataSet寫入目標XML文件
          #需要注意的是Logic格式中的一個DataSet節點可能會在Single節點中生成多個DataSet節點
          WHEN "DataSet"
            LET sOutput = sOutput,'\n','</DataSet>'
 
          #在結束一個Head節點的時候，則可能需要向輸出字符串中填充數據
          WHEN "Head"
            #根據FieldList的定義來判斷在返回結果中是否需要包含Head段，如果沒有則忽略該段
            #還有，只有當數據中沒有下級段時才由本級來完成數據的填充
            #IF ( f_head <> '' )AND( NOT has_body ) THEN
            IF (NOT cl_null(f_head)) AND (NOT has_body) THEN 
               #以下的處理過程在 WHEN "Head" / WHEN "Body" / WHEN "Detail" / WHEN "SubDetail"中是完全一樣的
 
               #如果在DataSet中定義了有Head段              
               IF NOT cl_null(f_head) THEN
                  IF  cl_null(d_head) THEN
               #IF f_head<> '' THEN               
                  #IF d_head = '' THEN 
                     LET sOutput = sOutput,'\n','<Row Data="',v_head  #沒有數據則用默認列表
                  ELSE 
                     LET sOutput = sOutput,'\n','<Row Data="',d_head  #有數據則用該數據
                  END IF
               END IF
               #如果在DataSet中定義了有Body段              
               IF NOT cl_null(f_body) THEN
                  IF cl_null(d_body) THEN
               #IF f_body<> '' THEN
                  #IF d_body = ''  THEN
                     LET sOutput = sOutput,sDiv,v_body  #沒有數據則用默認列表
                  ELSE
                     LET sOutput = sOutput,sDiv,d_body  #有數據則用該數據
                  END IF
               END IF
               #如果在DataSet中定義了有Detail段              
               IF NOT cl_null(f_detail) THEN
                  IF cl_null(d_detail) THEN
               #IF f_detail<> '' THEN
                  #IF d_detail = ''  THEN
                     LET sOutput = sOutput,sDiv,v_detail  #沒有數據則用默認列表
                  ELSE
                     LET sOutput = sOutput,sDiv,d_detail  #有數據則用該數據
                  END IF
               END IF
               #如果在DataSet中定義了有SubDetail段              
               IF NOT cl_null(f_sdetail) THEN
                  IF cl_null(d_sdetail) THEN
               #IF f_sdetail<> '' THEN
                  #IF d_sdetail = ''  THEN
                     LET sOutput = sOutput,sDiv,v_sdetail  #沒有數據則用默認列表
                  ELSE
                     LET sOutput = sOutput,sDiv,d_sdetail  #有數據則用該數據
                  END IF
               END IF
 
               LET sOutput = sOutput,'"/>'                           
            END IF
          
          #在結束一個Body節點的時候，則可能需要向輸出字符串中填充數據
          WHEN "Body"
            #根據FieldList的定義來判斷在返回結果中是否需要包含Body段，如果沒有則忽略該段
            #還有，只有當數據中沒有下級段時才由本級來完成數據的填充
            #mod by zqj 06/07/25
            #IF ( f_body <> '' )AND( NOT has_detail ) THEN
             IF NOT cl_null(f_body) AND (NOT has_detail) THEN
               #以下的處理過程在 WHEN "Head" / WHEN "Body" / WHEN "Detail" / WHEN "SubDetail"中是完全一樣的               
               
               #如果在DataSet中定義了有Head段              
               IF NOT cl_null(f_head) THEN
                  IF cl_null(d_head) THEN
               #IF f_head<> '' THEN               
                  #IF d_head = '' THEN 
                     LET sOutput = sOutput,'\n','<Row Data="',v_head  #沒有數據則用默認列表
                  ELSE 
                     LET sOutput = sOutput,'\n','<Row Data="',d_head  #有數據則用該數據
                  END IF
               END IF
               #如果在DataSet中定義了有Body段              
               #mod by zqj 06/07/25
               IF NOT cl_null(f_body) THEN
               #IF f_body<> '' THEN   
                  IF cl_null(d_body) THEN
                  #IF d_body = ''  THEN
                     LET sOutput = sOutput,sDiv,v_body  #沒有數據則用默認列表
                  ELSE
                     LET sOutput = sOutput,sDiv,d_body  #有數據則用該數據
                  END IF
               END IF
               #如果在DataSet中定義了有Detail段              
               IF NOT cl_null(f_detail) THEN
                  IF cl_null(d_detail) THEN
               #IF f_detail<> '' THEN
                  #IF d_detail = ''  THEN
                     LET sOutput = sOutput,sDiv,v_detail  #沒有數據則用默認列表
                  ELSE
                     LET sOutput = sOutput,sDiv,d_detail  #有數據則用該數據
                  END IF
               END IF
               #如果在DataSet中定義了有SubDetail段              
               IF NOT cl_null(f_sdetail) THEN
                  IF cl_null(d_sdetail) THEN
               #IF f_sdetail<> '' THEN
                  #IF d_sdetail = ''  THEN
                     LET sOutput = sOutput,sDiv,v_sdetail  #沒有數據則用默認列表
                  ELSE
                     LET sOutput = sOutput,sDiv,d_sdetail  #有數據則用該數據
                  END IF
               END IF
 
               LET sOutput = sOutput,'"/>'                           
            END IF
            
          #在結束一個Detail節點的時候，則可能需要向輸出字符串中填充數據
          WHEN "Detail"
            #根據FieldList的定義來判斷在返回結果中是否需要包含Detail段，如果沒有則忽略該段
            #還有，只有當數據中沒有下級段時才由本級來完成數據的填充
            #IF ( f_detail <> '' )AND( NOT has_sdetail ) THEN
             IF (NOT cl_null(f_detail))AND( NOT has_sdetail ) THEN
               #以下的處理過程在 WHEN "Head" / WHEN "Body" / WHEN "Detail" / WHEN "SubDetail"中是完全一樣的               
               
               #如果在DataSet中定義了有Head段              
               IF NOT cl_null(f_head) THEN
                  IF cl_null(d_head) THEN
               #IF f_head<> '' THEN               
                  #IF d_head = '' THEN 
                     LET sOutput = sOutput,'\n','<Row Data="',v_head  #沒有數據則用默認列表
                  ELSE 
                     LET sOutput = sOutput,'\n','<Row Data="',d_head  #有數據則用該數據
                  END IF
               END IF
               #如果在DataSet中定義了有Body段
               IF NOT cl_null(f_body) THEN
                  IF cl_null(d_body) THEN              
               #IF f_body<> '' THEN
                  #IF d_body = ''  THEN
                     LET sOutput = sOutput,sDiv,v_body  #沒有數據則用默認列表
                  ELSE
                     LET sOutput = sOutput,sDiv,d_body  #有數據則用該數據
                  END IF
               END IF
               #如果在DataSet中定義了有Detail段              
               IF NOT cl_null(f_detail) THEN
                  IF cl_null(d_detail) THEN
               #IF f_detail<> '' THEN
                  #IF d_detail = ''  THEN
                     LET sOutput = sOutput,sDiv,v_detail  #沒有數據則用默認列表
                  ELSE
                     LET sOutput = sOutput,sDiv,d_detail  #有數據則用該數據
                  END IF
               END IF
               #如果在DataSet中定義了有SubDetail段              
               IF NOT cl_null(f_sdetail) THEN
                  IF cl_null(d_sdetail) THEN
               #IF f_sdetail<> '' THEN
                  #IF d_sdetail = ''  THEN
                     LET sOutput = sOutput,sDiv,v_sdetail  #沒有數據則用默認列表
                  ELSE
                     LET sOutput = sOutput,sDiv,d_sdetail  #有數據則用該數據
                  END IF
               END IF
 
               LET sOutput = sOutput,'"/>'                           
            END IF
 
          #在結束一個SubDetail節點的時候，則可能需要向輸出字符串中填充數據
          WHEN "SubDetail"
            #根據FieldList的定義來判斷在返回結果中是否需要包含SubDetail段，如果沒有則忽略該段
            #IF f_sdetail <> '' THEN
            IF NOT cl_null(f_sdetail) THEN 
               #以下的處理過程在 WHEN "Head" / WHEN "Body" / WHEN "Detail" / WHEN "SubDetail"中是完全一樣的               
               
               #如果在DataSet中定義了有Head段              
               IF NOT cl_null(f_head) THEN
                  IF cl_null(d_head) THEN          
               #IF f_head<> '' THEN               
                  #IF d_head = '' THEN 
                     LET sOutput = sOutput,'\n','<Row Data="',v_head  #沒有數據則用默認列表
                  ELSE 
                     LET sOutput = sOutput,'\n','<Row Data="',d_head  #有數據則用該數據
                  END IF
               END IF
               #如果在DataSet中定義了有Body段              
               IF NOT cl_null(f_body) THEN
                  IF cl_null(d_body) THEN
               #IF f_body<> '' THEN
                  #IF d_body = ''  THEN
                     LET sOutput = sOutput,sDiv,v_body  #沒有數據則用默認列表
                  ELSE
                     LET sOutput = sOutput,sDiv,d_body  #有數據則用該數據
                  END IF
               END IF
               #如果在DataSet中定義了有Detail段              
               IF NOT cl_null(f_detail) THEN
                  IF cl_null(d_detail) THEN
               #IF f_detail<> '' THEN
                 #IF d_detail = ''  THEN
                     LET sOutput = sOutput,sDiv,v_detail  #沒有數據則用默認列表
                  ELSE
                     LET sOutput = sOutput,sDiv,d_detail  #有數據則用該數據
                  END IF
               END IF
               #如果在DataSet中定義了有SubDetail段              
               IF NOT cl_null(f_sdetail) THEN
                  IF cl_null(d_sdetail) THEN
               #IF f_sdetail<> '' THEN
                  #IF d_sdetail = ''  THEN
                     LET sOutput = sOutput,sDiv,v_sdetail  #沒有數據則用默認列表
                  ELSE
                     LET sOutput = sOutput,sDiv,d_sdetail  #有數據則用該數據
                  END IF
               END IF
 
               LET sOutput = sOutput,'"/>'                           
            END IF            
          END CASE 
        END CASE
    #END CASE
    LET e = r.read()
  END WHILE
  
  #added by zqj 06/07/25 
  #把生成返回的xml寫進sInput
  RUN "echo '"||sOutput||"' >"||sInput
  #add end
  #mod by zqj 06/07/25
  #RETURN 1,sOutput
  RETURN '',''
END FUNCTION
 
 
FUNCTION aws_Join2Single(p_objectid,p_xml,p_div)
    DEFINE p_objectid     STRING,
           p_xml          STRING,
           p_div          STRING
    DEFINE sTmpFile       STRING,
           sField         STRING,
           sTable         STRING,
           FieldList      STRING,
           rowData        STRING,
           subData        STRING,
           i,j,id,k       LIKE type_file.num5,
           attField       base.StringBuffer,
           tokFieldList   base.StringTokenizer,
           l_table        LIKE wac_file.wac02,
           l_field        LIKE wac_file.wac03,
           d1,d2          om.DomDocument,
           dataNode1      om.DomNode,
           dataNode2      om.DomNode,
           dataSetNode1   om.DomNode,
           dataSetNode2   om.DomNode,
           rowNode1       om.DomNode,
           rowNode2       om.DomNode,
      #add by zqj for read out.xml to putout
           str,sOutput     STRING,
           sbXml   base.StringBuffer
      #abd add
  DEFINE arr_field           DYNAMIC ARRAY OF STRING
      
    LET d2 = om.DomDocument.create("Data")
    LET dataNode2 = d2.getDocumentElement()
    CALL dataNode2.setAttribute("Format","Single")
 
    #LET d1 = om.DomDocument.createFromXmlFile(sTmpFile)
    LET d1 = om.DomDocument.createFromXmlFile(p_xml)
    LET dataNode1 = d1.getDocumentElement()
    LET dataSetNode1 = dataNode1.getFirstChild()
    LET FieldList = dataSetNode1.getAttribute("Field")
    LET FieldList = ListSort(FieldList,p_div)
    #LET tokFieldList = base.StringTokenizer.create(FieldList,p_div)
    LET i = 0
    LET j = 0
    LET sTable = "none"
    LET attField = base.StringBuffer.create()
   
    #No.MOD-960008 begin 
    CALL aws_Tokenizer(FieldList,p_div,arr_field)
    FOR k = 1 TO arr_field.getLength()
 
    #WHILE tokFieldList.hasMoreTokens()   #No.MOD-960008
    #No.MOD-960008 end
          LET j = j + 1
          #LET sField = tokFieldList.nextToken()
          LET sField = arr_field[k]
          LET l_Field = sField
          SELECT UNIQUE(wac02) INTO l_table FROM wac_file WHERE wac03 = l_Field
          IF SQLCA.sqlcode THEN
             DISPLAY "-1"
          END IF
          IF l_table <> sTable THEN
             IF sTable <> "none" THEN
                CALL dataSetNode2.setAttribute("Field",attField.toString())
                LET e[i] = j - s[i]
             END IF
             LET sTable = l_table
             LET dataSetNode2 = dataNode2.createChild("DataSet")   
             CALL dataSetNode2.setAttribute("Table",sTable)
             CALL attField.clear()
             LET i = i + 1
             LET s[i] = j
          ELSE
             CALL attField.append("^*^")
             #CALL attField.append("|")
          END IF
          CALL attField.append(sField)
    #END WHILE
    END FOR
    CALL dataSetNode2.setAttribute("Field",attField.toString())
    LET e[i] = j - s[i] +1
 
    LET i =1
    LET dataSetNode2 = dataNode2.getFirstChild()
    WHILE dataSetNode2 IS NOT NULL 
        CALL aData.clear()
        LET rowNode1 = dataSetNode1.getFirstChild()
        WHILE rowNode1 IS NOT NULL
            LET rowData = rowNode1.getAttribute("Data")
            LET rowData = DataSort(rowData,p_div)
            LET subData = GetSubData(rowData,i,p_div) 
            IF NOT IsRepeat(subData) THEN
               LET rowNode2 = dataSetNode2.createChild("Row")
               LET id = id + 1
               CALL rowNode2.setAttribute("ID",id)
               IF i = 1 THEN
                  CALL rowNode2.setAttribute("Parent","")
               ELSE
                  CALL rowNode2.setAttribute("Parent",GetParentID(dataSetNode2.getPrevious(),GetSubData(rowData,i-1,p_div)))
               END IF
               CALL rowNode2.setAttribute("Data",subData)
               CALL aData.appendElement()
               LET aData[aData.getLength()] = subData
            END IF
            LET rowNode1 = rowNode1.getNext()
        END WHILE
        LET dataSetNode2 = dataSetNode2.getNext()
        LET i = i + 1
    END WHILE
    #mark by zqj 06/07/25
    #CALL dataNode2.writeXml("out.xml")
    CALL dataNode2.writeXml(p_xml)
    RETURN	'',''
END FUNCTION
 
FUNCTION ListSort(p_list,p_div)
    DEFINE  p_list    STRING,
            p_div     STRING,
            l_cnt     LIKE type_file.num5,
            i, j,k    LIKE type_file.num5,
            s_Field   STRING,
            s_Ret     STRING,
            l_Field   LIKE wac_file.wac03,
            l_table   LIKE wac_file.wac02,
            tokList   base.StringTokenizer,
            aTable    DYNAMIC ARRAY OF STRING,
            aField    DYNAMIC ARRAY OF STRING,
            aF1       DYNAMIC ARRAY OF STRING
    DEFINE arr_field           DYNAMIC ARRAY OF STRING
 
    #LET tokList = base.StringTokenizer.create(p_list,p_div)
    LET l_cnt = 0
    LET j = 0
    
    #No.MOD-960008 begin 
    CALL aws_Tokenizer(p_list,p_div,arr_field)
    FOR k = 1 TO arr_field.getLength()
 
    #WHILE tokList.hasMoreTokens()
    #No.MOD-960008 end
          #LET s_Field = tokList.nextToken()
          LET s_Field = arr_field[k]
          LET j = j + 1
          LET aF1[j] = s_Field
          LET l_Field = s_Field
          SELECT UNIQUE(wac02) INTO l_table FROM wac_file WHERE wac03 = l_Field
          FOR i = 1 TO l_cnt
              IF aTable[i] = l_table THEN
                 LET aField[i] = aField[i],p_div,s_Field
                 EXIT FOR 
              END IF
          END FOR
          IF i > l_cnt THEN
             LET l_cnt = l_cnt + 1
             LET aTable[l_cnt] = l_table
             LET aField[l_cnt] = l_Field
          END IF
    #END WHILE
    END FOR
    LET s_Ret = aField[1]
    FOR i = 2 TO l_cnt
        LET s_Ret = s_Ret,p_div,aField[i]
    END FOR
    
    #No.MOD-960008 begin 
    CALL aMap.clear()
    #LET tokList = base.StringTokenizer.create(s_Ret,p_div)
    LET i = 0
    CALL aws_Tokenizer(s_Ret,p_div,arr_field)
    FOR k = 1 TO arr_field.getLength()
 
    #WHILE tokList.hasMoreTokens()
          LET i = i + 1
          #LET s_Field = tokList.nextToken()
          LET s_Field = arr_field[k]
          FOR j = 1 TO aF1.getLength()
              IF aF1[j] = s_Field THEN
                 LET aMap[j] = i
                 EXIT FOR
              END IF
          END FOR
    #END WHILE
    END FOR
    RETURN s_Ret
END FUNCTION
 
FUNCTION DataSort(p_data,p_div)
    DEFINE  p_data    STRING,
            p_div     STRING,
            tokList   base.StringTokenizer,
            l_cnt,i,k LIKE type_file.num5,
            aRet      DYNAMIC ARRAY OF STRING,
            sRet      STRING
    DEFINE arr_value           DYNAMIC ARRAY OF STRING
        
    #No.MOD-960008 begin 
    #LET tokList = base.StringTokenizer.create(p_data,p_div)
    #LET l_cnt = tokList.countTokens()
    LET i = 1
    CALL aws_Tokenizer(p_data,p_div,arr_value)
    FOR k = 1 TO arr_value.getLength()
    #WHILE tokList.hasMoreTokens()
    #No.MOD-960008 end   
          #LET aRet[aMap[i]]=tokList.nextToken()
          LET aRet[aMap[i]]=arr_value[k]
          LET i = i + 1
    #END WHILE
    END FOR
    LET sRet = aRet[1]
    #FOR i = 2 TO l_cnt
    FOR i = 2 TO arr_value.getLength()
        LET sRet = sRet,p_div,aRet[i]
    END FOR
    RETURN sRet
END FUNCTION
 
FUNCTION GetSubData(p_data,p_idx,p_div)
    DEFINE  p_data    STRING,
            p_idx     LIKE type_file.num5,
            i,j,k     LIKE type_file.num5,
            p_div     STRING
            
    LET j = 0
    LET k = 0
    FOR i = 1 TO s[p_idx] - 1 
       IF j = 0 THEN 
          LET j = p_data.GetIndexOf(p_div,j+1) 
       ELSE
          LET j = p_data.GetIndexOf(p_div,j+p_div.getLength()) 
       END IF
    END FOR
    FOR i = 1 TO e[p_idx]+s[p_idx] - 1 
        LET k = p_data.GetIndexOf(p_div,k+1) 
    END FOR
    IF k = 0 THEN 
       LET k = p_data.getLength() 
    ELSE
       LET k = k -1
    END IF
    IF j = 0 THEN 
       RETURN p_data.subString(j+1,k)
    ELSE
       RETURN p_data.subString(j+p_div.getLength(),k)
    END IF
END FUNCTION
 
FUNCTION IsRepeat(p_data)
    DEFINE p_data    STRING,
           i         LIKE type_file.num5
    FOR i =1 TO aData.getLength()
        IF aData[i] = p_data THEN RETURN 1 END IF
    END FOR
    RETURN 0
END FUNCTION
 
{
FUNCTION IsRepeat(p_data)
    DEFINE p_data    STRING,
           i,l_pos   LIKE type_file.num5
    FOR i =1 TO aData.getLength()
      LET l_pos = aData[i].getIndexof('^*^',1)
      #LET l_pos = aData[i].getIndexof('|',1)
      IF aData[i].subString(1,l_pos) = p_data.subString(1,l_pos) THEN RETURN 1 END IF 
    END FOR
    RETURN 0
END FUNCTION
}
FUNCTION GetParentID(p_dataSetNode,p_data)
    DEFINE  p_dataSetNode   om.DomNode,
            p_data          STRING,
            rowNode         om.DomNode
    LET rowNode = p_dataSetNode.getFirstChild()
    WHILE rowNode IS NOT NULL
        IF p_data = rowNode.getAttribute("Data") THEN
           RETURN rowNode.getAttribute("ID")
        END IF
        LET rowNode = rowNode.getNext() 
    END WHILE 
    RETURN ""
END FUNCTION
 
FUNCTION aws_Single2Join(p_objectid,p_xml,p_div)
    DEFINE p_objectid     STRING,
           p_xml          STRING,
           p_div          STRING
    DEFINE sTmpFile       STRING,
           i              LIKE type_file.num5,
           d              om.DomDocument,
           dataNode       om.DomNode,
           dataSetNode    om.DomNode,
           dataSetList    om.NodeList,
           sOut           base.StringBuffer
 
    LET sOut = base.StringBuffer.create()
    CALL sOut.append('<Data Format="Join" >\n')
    CALL sOut.append('<DataSet Field="')
 
    #LET d = om.DomDocument.createFromXmlFile(sTmpFile)
    LET d = om.DomDocument.createFromXmlFile(p_xml)
    LET dataNode = d.getDocumentElement()
    LET dataSetList = dataNode.selectByTagName("DataSet")
    FOR i = 1 TO dataSetList.getLength()
        LET dataSetNode = dataSetList.item(i)
        IF i > 1 THEN CALL sOut.append(p_div) END IF
        CALL sOut.append(dataSetNode.getAttribute("Field"))
    END FOR
    CALL sOut.append('">\n')
 
    CALL PrintRow("",dataNode.getFirstChild(),"",p_div)
    CALL sOut.append('</DataSet>\n') 
    CALL sOut.append('</Data>\n') 
    RUN "rm -f "||sTmpFile
    DISPLAY sOut.toString()
    #mod by zqj 06/07/25
    #RETURN 1,sOut.toString()
    RUN "echo '"||sOut.toString()||"' >"||p_xml
    RETURN '',''
END FUNCTION
 
FUNCTION PrintRow(p_id,p_data,p_rep,p_div)
    DEFINE p_id     STRING,
           p_div    STRING,
           flag_id  STRING,
           parentId STRING,
           p_rep    STRING,
           sRep     base.StringBuffer,
           p_data   om.DomNode,
           rowNode  om.DomNode
 
    LET sRep = base.StringBuffer.create()
    LET rowNode = p_data.getFirstChild()
    LET flag_id = "-1"
    WHILE rowNode IS NOT NULL
        CALL sRep.clear()
        CALL sRep.append(p_rep)
        LET parentId = rowNode.getAttribute("Parent")
        IF Length(parentId) = 0 OR parentId = p_id THEN
           IF parentId <> flag_id THEN
              LET flag_id = parentId
           ELSE 
              CALL sOut.append(p_rep)
           END IF   
           IF Length(parentId) = 0 THEN 
              CALL sOut.append('<Row Data="')
              CALL sRep.append('<Row Data="')
           ELSE 
              CALL sOut.append(p_div)
              CALL sRep.append(p_div)
           END IF
           CALL sOut.append(rowNode.getAttribute("Data"))
           CALL sRep.append(rowNode.getAttribute("Data"))
           IF p_data.getNext() IS NOT null THEN
              CALL PrintRow(rowNode.getAttribute("ID"),p_data.getNext(),sRep.toString(),p_div)
           ELSE
              CALL sOut.append('" />\n')
           END IF
        END IF
        LET rowNode = rowNode.getNext() 
    END WHILE
    IF flag_id = "-1" THEN
       CALL sOut.append('" />\n')
    END IF
END FUNCTION
 
FUNCTION aws_Single2Logic(p_objectid,p_xml,p_div)
DEFINE     p_objectid     STRING,
           g_objectid     LIKE type_file.chr50,
           p_xml          STRING,
           p_div          STRING,
           i              LIKE type_file.num5,
           l_string       STRING,
           l_table        STRING,
           l_head         LIKE type_file.chr20,
           l_body         LIKE type_file.chr20,
           l_detail       LIKE type_file.chr20,
           l_sdetail      LIKE type_file.chr20,
           sTmpFile       STRING
DEFINE     d              om.DomDocument,
           dataNode       om.DomNode,
           dataSetNode    om.DomNode,
           p_data         om.DomNode,
           dataSetList    om.NodeList
DEFINE     l_ch           base.channel
           
 LET g_objectid = p_objectid
   #首先根據ObjectID得到Head、Body、Detail和SubDetail對應的表名
  SELECT wab02 INTO l_head    FROM wab_file WHERE wab01 = g_objectid AND wab08 = 'Head'
  SELECT wab02 INTO l_body    FROM wab_file WHERE wab01 = g_objectid AND wab08 = 'Body'
  SELECT wab02 INTO l_detail  FROM wab_file WHERE wab01 = g_objectid AND wab08 = 'Detail'
  SELECT wab02 INTO l_sdetail FROM wab_file WHERE wab01 = g_objectid AND wab08 = 'SubDetail'
  
 LET sOut = base.StringBuffer.create()
 CALL sOut.append('<Data Format="Logic" >\n')
 CALL sOut.append('<DataSet ') 
 
 #LET d = om.DomDocument.createFromXmlFile(sTmpFile)
 LET d = om.DomDocument.createFromXmlFile(p_xml)
 LET dataNode = d.getDocumentElement()
 LET dataSetList =dataNode.selectByTagName("DataSet")
 FOR i = 1 TO dataSetList.getLength()
    LET dataSetNode = dataSetList.item(i)
    LET l_table = dataSetNode.getAttribute("Table")
    CASE 
       WHEN l_table=l_head CALL sOut.append('Head="')
       WHEN l_table=l_body CALL sOut.append('Body="')
       WHEN l_table=l_detail CALL sOut.append('Detail="')
       WHEN l_table=l_sdetail CALL sOut.append('Subdetail="')
    END CASE
    CALL sOut.append(dataSetNode.getAttribute("Field"))
    CALL sOut.append('" ')
 END FOR
 CALL sOut.append('>\n')
 LET p_data = dataNode
 CALL PrintDataSetChild(p_data,l_head,l_body,l_detail,l_sdetail)
 CALL sOut.append('</DataSet>\n') 
 CALL sOut.append('</Data>\n') 
 RUN "rm -f "||p_xml
 DISPLAY sOut.toString()
 #2007-06-11 李鋒發現用下面的方法生成文件可能會有特殊字符引起錯誤，改之
 #RUN 'echo "'||sOut.toString()||'" > '||p_xml
 LET l_ch = base.Channel.create()
 CALL l_ch.openFile(p_xml,'w')
 CALL l_ch.WriteLine(sOut.toString())
 CALL l_ch.close()
 RETURN '',''
END FUNCTION 
 
FUNCTION PrintDataSetChild(p_data,l_head,l_body,l_detail,l_sdetail)
 DEFINE   l_table     STRING
 DEFINE   l_string    STRING
 DEFINE    i          LIKE type_file.num5
 DEFINE    l_head         LIKE type_file.chr20,
           l_body         LIKE type_file.chr20,
           l_detail       LIKE type_file.chr20,
           l_sdetail      LIKE type_file.chr20
 DEFINE    p_data    om.DomNode,
           RowNode   om.DomNode,
           RowNode1   om.DomNode,
           RowNode2   om.DomNode,
           RowNode3   om.DomNode,
           n,n1,n2,n3 om.DomNode,
           r         om.DomNode,
           headNodeJ om.DomNode,
           dataSetList    om.NodeList,
           DataSetNode om.DomNode,
           d  om.DomDocument
 DEFINE   b_Found LIKE type_file.num5
 DEFINE   l_buf base.StringBuffer
 
 #LET l_string = base.StringBuffer.create()
 LET dataSetList =p_data.selectByTagName("DataSet")
 FOR i = 1 TO dataSetList.getLength()
    LET dataSetNode = dataSetList.item(i)
    LET l_table = dataSetNode.getAttribute("Table")
    IF l_table=l_head THEN
       EXIT FOR
    END IF
 END FOR
 IF l_table=l_head THEN
    LET RowNode = dataSetNode.getFirstChild()  
    WHILE RowNode IS NOT NULL
       CALL sOut.append('<Head Data="')
       LET l_string= RowNode.getAttribute("Data")   
       LET l_buf = base.StringBuffer.create()
       CALL l_buf.Append(RowNode.getAttribute("Data"))
###       CALL sOut.append(RowNode.getAttribute("Data"))
       CALL l_buf.replace('&','&amp;',0)
       CALL l_buf.replace("'","&apos;",0)
       CALL l_buf.replace('"','&quot;',0)
       CALL l_buf.replace('>','&gt;',0)
       CALL l_buf.replace('<','&lt;',0)
       CALL sOut.append(l_buf.toString())
       CALL sOut.append('"')
 
       LET b_found = FALSE
       FOR i=1 TO dataSetList.getLength()
          LET dataSetNode = dataSetList.item(i)
          LET l_table = dataSetNode.getAttribute("Table")
          IF l_table=l_body THEN
             LET b_found = TRUE
             EXIT FOR
          END IF
       END FOR
       #如果有找到則說明是有下級表的
       IF b_found THEN
          #先完成當前節點的結束標記
          CALL sOut.append('>\n')  
          #進入下級表所在的節點
          LET RowNode1 = dataSetNode.getFirstChild()
          WHILE RowNode1 IS NOT NULL
             IF RowNode1.getAttribute("Parent")=RowNode.getAttribute("ID") THEN
                CALL sOut.append('<Body Data="')
                CALL sOut.append(RowNode1.getAttribute("Data"))
                #CALL sOut.append("/>\n")                      #未能解決<Body></Body>分開的問題
                FOR i=1 TO dataSetList.getLength()
                    LET dataSetNode = dataSetList.item(i)
                    LET l_table = dataSetNode.getAttribute("Table")
                    IF l_table = l_detail THEN
                       EXIT FOR
                    END IF
                END FOR
                #如果沒有發現子表則用封閉標簽，否則用非封閉標簽
                IF l_table <> l_detail OR l_detail IS NULL THEN
                   CALL sOut.append('"/>\n')
                   LET RowNode1=RowNode1.getNext()
                   CONTINUE WHILE
                ELSE
              	   CALL sOut.append('">\n') 
                END IF
                IF l_table=l_detail THEN
                   LET RowNode2 = dataSetNode.getFirstChild()
                   WHILE RowNode2 IS NOT NULL
                      IF  RowNode2.getAttribute("Parent")=RowNode1.getAttribute("ID") THEN
                         CALL sOut.append('<Detail Data="') 
                         CALL sOut.append(RowNode2.getAttribute("Data"))
                         #CALL sOut.append(">\n")
                         FOR i=1 TO dataSetList.getLength()
                            LET dataSetNode = dataSetList.item(i)
                            LET l_table = dataSetNode.getAttribute("Table")
                            IF l_table=l_sdetail THEN
                               EXIT FOR
                            END IF
                         END FOR
                         IF l_table <> l_sdetail OR l_sdetail IS NULL THEN
                            CALL sOut.append('"/>\n') 
                            LET RowNode2=RowNode2.getNext()
                            CONTINUE WHILE
                         ELSE
                            CALL sOut.append('">\n') 
                         END IF
                         IF l_table=l_sdetail THEN
                            LET RowNode3=dataSetNode.getFirstChild()
                            WHILE RowNode3 IS NOT NULL
                               IF  RowNode3.getAttribute("Parent")=RowNode2.getAttribute("ID") THEN
                                  CALL sOut.append('<SubDetail Data="')
                                  CALL sOut.append(RowNode3.getAttribute("Data"))
                                  CALL sOut.append('"/>\n')
                               END IF
                               LET RowNode3=RowNode3.getNext()
                            END WHILE
                            CALL sOut.append("</Detail>")
                         END IF
                      END IF
                      LET RowNode2=RowNode2.getNext()
                   END WHILE
                   CALL sOut.append("</Body>\n")
                END IF
             END IF
             LET RowNode1=RowNode1.getNext()
          END WHILE
          CALL sOut.append("</Head>\n")
       ELSE 
          #如果沒有找到下級節點則本節點應該以/>來結束
          CALL sOut.append("/>\n") 
       END IF
       LET RowNode=RowNode.getNext()
    END WHILE
 END IF
END FUNCTION 
 
FUNCTION aws_Join2Logic(p_objectid,p_xml,p_div)
DEFINE     p_objectid     STRING,
           g_objectid     LIKE type_file.chr50,
           p_xml          STRING,
           p_div          STRING,
           l_errCode      STRING,
           l_errDesc      STRING
           
 CALL aws_Join2Single(p_objectid,p_xml,p_div) RETURNING l_errCode,l_errDesc
 IF NOT cl_null(l_errCode) THEN 
    RETURN l_errCode,l_errDesc
 ELSE 
    CALL aws_Single2Logic(p_objectid,p_xml,p_div) RETURNING l_errCode,l_errDesc       
    RETURN l_errCode,l_errDesc
 END IF 
END FUNCTION
#No.FUN-8A0122
