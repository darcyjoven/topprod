# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: UpdateBOM(p_Param)
# Descriptions...: PDM傳入的參數對TIPTOP中的BOM變更生成相應的ECN單
# Date & Author..: 2006-07-20 by heartheros
# Modify.........: 新建立 FUN-8A0122 binbin
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowi定義規範化
# Modify.........: No.MOD-960008 09/06/01 By shengbb hasMoreTokens() bug
# Modify.........: No.FUN-980009 09/08/21 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.FUN-9A0080 09/10/26 By lilingyu 改寫標準Sql寫法
# Modify.........: No.FUN-A10109 10/03/15 By rainy g_no_sp,g_no_ep抓法改call sub
# Modify.........: No.FUN-A60027 10/06/18 By vealxu 製造功能優化-平行制程（批量修改）
 
DATABASE ds
#引入全局變量
GLOBALS "../../config/top.global"
#UpdataBOM操作全局變量定義區
DEFINE l_errcode           STRING,                 
       i,l_check,j,l_headi       LIKE type_file.num5                #l_headi表示單頭是否已經被插入1,插入，２。未插
 
DEFINE g_bma    RECORD LIKE bma_file.*,                  #從xml中抓出的數據
       g_bma_o  RECORD LIKE bma_file.*,                  #數據庫中抓出的數據用以比對
       g_bma_t  RECORD LIKE bma_file.*,                  #存單頭中異動數據
       #g_bmb_pdm_rowi  LIKE bmb_file.bmb_pdm_rowi,     #傳入的單身數據不在數據庫中存在則失效
       g_bmb_bmb03  LIKE bmb_file.bmb03,                 #傳入的單身數據不在數據庫中存在則失效
       g_bmb    DYNAMIC ARRAY OF RECORD LIKE bmb_file.*, #從xml中抓出的數據
                # l_bmb  RECORD LIKE bmb_file.*
                #END RECORD
       g_bmb_o  RECORD LIKE bmb_file.*,                  #數據庫中抓出的數據用以比對
       g_bmb_t  RECORD LIKE bmb_file.*                   #存有異動的單身數據
DEFINE g_bmx    RECORD LIKE bmx_file.*,
       g_bmy    RECORD LIKE bmy_file.*,
       g_bmz    RECORD LIKE bmz_file.*
DEFINE g_bmy03_t LIKE bmy_file.bmy03
DEFINE g_bmx11   LIKE bmx_file.bmx11
DEFINE g_ze     RECORD LIKE ze_file.* 
#UpdataBOM操作全局變量定義區END
 
#add by binbin for bmb13 begin
DEFINE l_bmt         DYNAMIC ARRAY OF RECORD LIKE bmt_file.*
DEFINE l_bmt06_t     LIKE bmt_file.bmt06 
DEFINE l_bmb13_length,l_bmb13_index,l_bmt_i,l_bmt_n,l_bmt_total       LIKE type_file.num5
DEFINE l_bmb13_sep   LIKE type_file.chr1
DEFINE bmt_arr_data  DYNAMIC ARRAY OF STRING
DEFINE l_bmb13_tmp_data  DYNAMIC ARRAY OF STRING
DEFINE l_bmt_tmp_data,l_bmt_data       STRING
#add by binbin for bmb13 end
 
#UpdateBOM函數區
FUNCTION UpdateBOM(p_Param)
DEFINE 
  l_ObjectID   STRING,
  l_Separator  STRING,
  l_Factory    LIKE azp_file.azp01,
  l_db         LIKE azp_file.azp03,  
  l_User       STRING,
  l_FieldList  STRING,
  l_Condition  STRING,
  l_DataSource STRING,
  l_xmlFile    STRING,
  l_DataFormat STRING,
  l_rexml      STRING,
  l_Format     STRING,
  l_bodyCount  LIKE type_file.num5,
  transfer_xml STRING,
  l_tag       LIKE type_file.num5,
   l_errCode   STRING,
   l_errDesc   STRING,
  headNode    om.DomNode,
  bodyNode    om.DomNode,
  dataNode    om.DomNode,
  dataSetNode om.DomNode,
  transferData om.DomDocument,
  ch    base.channel,
  p_Param    DYNAMIC ARRAY OF RECORD
    Tag       STRING,  
    Attribute STRING,    
    Value     STRING  
              END RECORD,
  l_checkHeadField STRING,
  l_checkBodyField DYNAMIC ARRAY OF RECORD
                     FIELD  STRING
                   END RECORD,
  l_checkHeadData  STRING,
  l_checkBodyData  DYNAMIC ARRAY OF RECORD
                     DATA   STRING
                   END RECORD     
DEFINE
  head_cur,head_old,tmpnode,body_cur,body_old  om.DomNode,
  value_old,value_cur,l_data_att       STRING,
  l_pos                                LIKE type_file.num5
DEFINE 
  h_wac03         LIKE wac_file.wac03,
  h_wac15         LIKE wac_file.wac15,
  b_wac03         LIKE wac_file.wac03,
  b_wac15         LIKE wac_file.wac15,
  hd_field        STRING,
  hd_data         STRING,
  bd_field        STRING,
  bd_data         STRING,
  f_tok           base.StringTokenizer,
  d_tok           base.StringTokenizer,
  l_field         STRING,
  l_data          STRING,
  bf_tok          base.StringTokenizer,
  bd_tok          base.StringTokenizer,
  l_bmb10         LIKE bmb_file.bmb10,
  l_bmb03         LIKE bmb_file.bmb03,
  l_ima25         LIKE ima_file.ima25,
  l_flag          LIKE type_file.chr1,
  l_bmb10_fac     LIKE bmb_file.bmb10_fac,
  b_field         STRING,
  b_data          STRING
  
  #檢查服務私有參數列表中是否包含ObjectId的定義
  #如果沒有則使用全局變量  
  LET l_ObjectID = FindValue("ObjectID",p_Param)
  IF cl_null(l_ObjectID) THEN
     LET l_ObjectID = 'BOM'
  END IF
 
  #檢查服務私有參數列表中是否包含Seperator的定義
  #如果沒有則使用全局變量  
  LET l_Separator = FindValue("Separator",p_Param)
  IF cl_null(l_Separator) THEN
     #LET l_Separator = '|'
     LET l_Separator = '^*^'
     #LET l_Separator = g_Separator
  END IF
 
  #檢查服務私有參數列表中是否包含Factory的定義
  #如果沒有則使用全局變量  
  LET l_Factory = FindValue("Factory",p_Param)
  IF cl_null(l_Factory) THEN
     LET l_Factory = 'DEMO-1'
  END IF
  IF cl_null(l_Factory) THEN
     LET g_ze.ze03 = cl_getmsg("aws-252", g_lang)
     RETURN 'aws-252',g_ze.ze03
    #RETURN 'aws-252','缺少Factory參數'
  END IF
 
  #檢查服務私有參數列表中是否包含User的定義
  #如果沒有則使用全局變量  
  LET l_User = FindValue("User",p_Param)
  IF cl_null(l_User) THEN
     LET l_User = 'tiptop'
  END IF
  IF cl_null(l_User) THEN
     LET g_ze.ze03 = cl_getmsg("aws-253", g_lang)
     RETURN 'aws-253',g_ze.ze03
    #RETURN 'aws-253','缺少User參數'
  ELSE 
     IF l_User='admin' THEN
        LET l_User='tiptop'
     END IF
     LET g_user=l_User 
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
  LET g_bmx11=l_Factory
  LET g_dbs=l_db
  IF l_db <> 'ds' THEN
#     CALL cl_ins_del_sid(2) #FUN-980030  #FUN-990069
     CALL cl_ins_del_sid(2,'') #FUN-980030  #FUN-990069
     CLOSE DATABASE
     DATABASE l_db
#     CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
     CALL cl_ins_del_sid(1,l_Factory) #FUN-980030  #FUN-990069
     IF SQLCA.sqlcode THEN 
        LET g_ze.ze03 = cl_getmsg("aws-257", g_lang)
        RETURN 'aws-257',g_ze.ze03
       #RETURN 'aws-257','切換數據庫發生錯誤'
     END IF 
  END IF 
  
  LET l_FieldList = FindValue("FieldList",p_Param)     #得到FieldList參數
  LET l_Condition = FindValue("Condition",p_Param)     #得到Condition參數
  LET l_DataFormat = FindValue("Format",p_Param)       #得到Format參數
  
  #獲得Data參數(實際上是存放Data的XML文件名)
  LET l_xmlFile = FindValue("Data",p_Param)
  IF cl_null(l_xmlFile) THEN 
     LET g_ze.ze03 = cl_getmsg("aws-206", g_lang)
     RETURN 'aws-206',g_ze.ze03
    #RETURN 'aws-206','缺少Data參數'
  END IF 
 
{  #獲得Data對應的Format參數(前面在TIPTOPGateWay會將它作為一個額外參數填充到p_Param中)
  LET l_Format = FindValue("DATA_FORMAT",p_Param)
  IF cl_null(l_Format) THEN 
     LET g_ze.ze03 = cl_getmsg("aws-207", g_lang)
     RETURN 'aws-207',g_ze.ze03
    #RETURN 'aws-207','缺少Format參數'
  END IF }
 
  #將Data存放的XML文件轉換為Logic格式
  CALL aws_transfer_xml(l_ObjectID,l_xmlFile,l_Separator,'Join','Logic') 
  RETURNING l_errCode,l_errDesc
  IF NOT cl_null(l_errCode) THEN 
     RETURN l_errCode,l_errDesc
  END IF 
    
  #LET l_DataSource = FindValue("Data",p_param)
  LET transferData = om.DomDocument.createFromXmlFile(l_xmlFile) 
  LET dataNode = transferData.getDocumentElement()
  
  #得到dataSet節點
  LET datasetNode = dataNode.getFirstChild()
  WHILE dataSetNode.getTagName() <> "DataSet"
   LET dataSetNode = dataSetNode.getNext()
  END WHILE 
  
  ###############################################################
  #Add By Lifeng , 合并相同主鍵的單身 
  IF dataSetNode IS NULL THEN 
     RETURN 'xxxxxx','dataSet Node cannot be null'
  END IF 
  LET head_old = dataSetNode.getFirstChild()
  LET value_old = head_old.getAttribute('Data')
  #LET l_pos = value_old.getIndexOf('|',1)
  LET l_pos = value_old.getIndexOf('^*^',1)
  LET value_old = value_old.subString(1,l_pos-1)
 
  LET head_cur = head_old.getNext()
  #循環比較每一個Head節點
  WHILE NOT head_cur IS NULL
    LET value_cur = head_cur.getAttribute('Data')
    #LET l_pos = value_cur.getIndexOf('|',1)
    LET l_pos = value_cur.getIndexOf('^*^',1)
    LET value_cur = value_cur.subString(1,l_pos-1)
 
    #比較上一個節點的主鍵值value_old和當前節點的主鍵值是否相同 ，如果相同
    #則進行合并
    IF value_old = value_cur THEN
       #把當前節點的所有子節點的Data值復制到上一個節點的新增子節點中
       LET body_cur = head_cur.getFirstChild()
       WHILE NOT body_cur IS NULL 
          LET l_data_att = body_cur.getAttribute('Data')
 
          #在head_cur中增加一個子節點
          LET body_old = head_old.createChild('Body')
          CALL body_old.setAttribute('Data',l_data_att)
 
          LET body_cur = body_cur.getNext()
       END WHILE
       #先得到下一個Head節點
       LET tmpnode = head_cur.getNext()
       #刪除當前節點
       CALL datasetNode.removeChild(head_cur)
       LET head_cur = tmpnode
    #如果不相同則把當前的主鍵值更新到上一個節點的變量中
    ELSE
      LET head_old = head_cur
      LET value_old = value_cur
      #循環下一個Head節點
      LET  head_cur = head_cur.getNext()
    END IF
 
  END WHILE
      
  CALL dataNode.writeXml('/u1/out/lifeng.xml')
 
  ###############################################################
 
  BEGIN WORK   #add by zqj 060726  
  
{  
  ##add by chenzhong begin
  ##取單頭單身需要給默認值的欄位及相應的默認值
  DECLARE h_default CURSOR FOR
     SELECT wac03,wac15  FROM wac_file
        WHERE wac01 ='BOM' AND wac02='bma_file'
          AND wac09='Y' AND wac15 IS NOT NULL
          
  FOREACH h_default INTO h_wac03,h_wac15
     IF cl_null(hd_field) THEN 
        LET hd_field = h_wac03
        LET hd_data = h_wac15
        IF cl_null(hd_data) THEN 
           LET hd_data = ' '
        END IF 
     ELSE 
     	LET hd_field = hd_field,l_Separator,h_wac03
     	LET hd_data = hd_data,l_Separator,h_wac15
     END IF 
  END FOREACH 
  
  DECLARE b_default CURSOR FOR 
     SELECT wac03,wac15 FROM wac_file
        WHERE wac01 ='BOM' AND wac02 ='bmb_file'
           AND wac09='Y' AND wac15 IS NOT NULL 
  FOREACH b_default INTO b_wac03,b_wac15
     IF cl_null (bd_field) THEN 
        LET bd_field = b_wac03
        LET bd_data = b_wac15
        IF cl_null(bd_data) THEN 
           LET bd_data = ' '
        END IF 
     ELSE 
     	LET bd_field = bd_field,l_Separator,b_wac03
     	LET bd_data = bd_data,l_Separator,b_wac15
     END IF 
  END FOREACH 
  ##add end  
}           
    
  #取單頭單身欄位
  LET l_checkHeadField = dataSetNode.getAttribute("Head")
  LET l_checkBodyField[1].FIELD =dataSetNode.getAttribute("Body")
{  
   ##add by chenzhong begin
   ##在CALL UpdateOpBom之前把需要默認值的欄位l_checkHeadField,l_checkBodyField前面
  IF NOT cl_null (hd_field) THEN 
   LET l_checkHeadField = hd_field,l_Separator,l_checkHeadField
  END IF 
  IF NOT cl_null (bd_field) THEN 
   LET l_checkBodyField[1].FIELD = bd_field,l_Separator,l_checkBodyField[1].FIELD,l_Separator,"bmb04",l_Separator,"bmb10_fac",l_Separator,"bmb10_fac2"
  END IF 
   ##add end 
}      
            
  #取單頭單身欄位對應值
  LET headNode = dataSetNode.getFirstChild()
  WHILE headNode IS NOT NULL
    WHILE headNode.getTagName() <> "Head"
       LET headNode = headNode.getNext()
    END WHILE
    LET l_checkHeadData=''
    CALL l_checkBodyData.CLEAR()
    LET l_checkHeadData = headNode.getAttribute("Data")
    
{  
    ##add by chenzhong
    LET l_checkHeadData = hd_data,l_Separator,l_checkHeadData
    ##add end
     
    ##add by chenzhong  begin 
    ##通過bma05 給bmb04賦值
    LET f_tok = base.StringTokenizer.createExt(l_checkHeadField,l_Separator,"",TRUE)
    LET d_tok = base.StringTokenizer.createExt(l_checkHeadData,l_Separator,"",TRUE)
    WHILE f_tok.hasMoreTokens()   #No.MOD-960008
       LET l_field = f_tok.nextToken()
       LET l_data = d_tok.nextToken()
       IF l_field ='bma05' THEN 
          EXIT WHILE 
       END IF 
    END WHILE
#    LET l_checkBodyField[1].FIELD =l_checkBodyField[1].FIELD,l_Separator,"bmb04"
    ##add end
}      
    LET bodyNode=headNode.getFirstChild()
    LET l_bodyCount=1
    WHILE bodyNode IS NOT NULL
       WHILE bodyNode.getTagName() <> "Body"
          LET bodyNode = bodyNode.getNext()
       END WHILE
       LET l_checkBodyData[l_bodyCount].DATA=bodyNode.getAttribute("Data")
      {##add by chenzhong 
       LET l_checkBodyData[l_bodyCount].DATA=bd_data,l_Separator,l_checkBodyData[l_bodyCount].DATA
       LET l_checkBodyData[l_bodyCount].DATA = l_checkBodyData[l_bodyCount].DATA,l_Separator,l_data
       LET bf_tok =base.StringTokenizer.createExt(l_checkBodyField[1].FIELD,l_Separator,"",TRUE)
       LET bd_tok =base.StringTokenizer.createExt(l_checkBodyData[l_bodyCount].DATA,l_Separator,"",TRUE)
       WHILE bf_tok.hasMoreTokens()
           LET b_field = bf_tok.nextToken()
           LET b_data = bd_tok.nextToken()
           IF b_field ='bmb10' THEN 
              LET l_bmb10 = b_data
           END IF 
        
          IF b_field ='bmb03' THEN 
             LET l_bmb03 = b_data
          END IF  
          
          IF NOT cl_null(l_bmb03) AND NOT cl_null(l_bmb10) THEN 
              SELECT  ima25 INTO l_ima25 FROM ima_file where ima01 =l_bmb03
              CALL s_umfchk(l_bmb03,l_bmb10,l_ima25) RETURNING l_flag,l_bmb10_fac
              IF l_flag=1 THEN 
                 LET l_bmb10_fac=1 
              ELSE
                 LET l_bmb10_fac=1 
              END IF
              EXIT WHILE
          END IF	 
       END WHILE
       LET   l_checkBodyData[l_bodyCount].DATA = l_checkBodyData[l_bodyCount].DATA,l_Separator,l_bmb10_fac,l_Separator,l_bmb10_fac
       ##add end}
       LET l_bodyCount=l_bodyCount+1
       LET bodyNode = bodyNode.getNext()
    END WHILE
        
    CALL UpdateOpBom(l_Separator,'',l_checkHeadField,l_checkHeadData,l_checkBodyField,l_checkBodyData)
    RETURNING l_errCode,l_errDesc                                     #l_tag為0沒有出錯，為-1則出錯，且errcode不為空，為錯誤碼
    IF l_errCode IS NOT NULL THEN
       EXIT WHILE
    ELSE
    	LET HeadNode = HeadNode.getNext()
      CONTINUE WHILE
    END IF
  END WHILE
  IF cl_null(l_errCode) THEN
    COMMIT WORK
  END IF
  RETURN l_errCode,l_errDesc
END FUNCTION
#********************************************************
FUNCTION UpdateOpBom(l_sep,l_checkID,bHeadField,bHeadData,bBodyField,bBodyData)
DEFINE l_fen     LIKE type_file.num5                    #若為１則更改單頭和單身若為2則更改單頭若為3則更改單身不更改單頭
DEFINE l_Operatecode  VARCHAR(20)               
DEFINE g_i         LIKE type_file.num5                  #自動分配單號的錯誤碼
DEFINE l_sep               STRING            #分隔字符
DEFINE l_errCode STRING                      #用以返回錯誤碼，為ze_file中的錯誤碼
DEFINE l_errDesc STRING                      #用以返回錯誤描述，若是系統中有的錯誤，則為錯誤代碼，如mfg0077，若非系統中的錯誤，則為詳細描述
DEFINE bBodyField  DYNAMIC ARRAY OF RECORD   #單身欄位
                     FIELD STRING
                   END RECORD,
       bBodyData   DYNAMIC ARRAY OF RECORD   #單身對應值
                     DATA STRING
                   END RECORD,
       l_checkID   DYNAMIC ARRAY OF RECORD   #標ID 對應傳入的記錄，若有單頭l_checkID[1].ID,其余為單身的ID 
                     ID   STRING
                   END RECORD
DEFINE bHeadField          STRING,
       bHeadData           STRING
DEFINE arr_data    DYNAMIC ARRAY OF RECORD
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
                  
 INITIALIZE g_bmb[1].* TO NULL
 INITIALIZE g_bma.* TO NULL
 INITIALIZE g_bma_o.* TO NULL
 INITIALIZE g_bmb_o.* TO NULL
 INITIALIZE g_bmx.* TO NULL
 INITIALIZE g_bmb_t.* TO NULL
 INITIALIZE g_bma_t.* TO NULL
 LET l_errCode = NULL
 LET l_errDesc = NULL
 
 CALL bmx_default()
##FUN-A10109 modify begin
###Add By chenzhong 20071008
## SELECT * INTO g_aza.* FROM aza_file WHERE aza01='0'
## IF SQLCA.SQLCODE THEN
##    LET g_ze.ze03 = cl_getmsg("aws-227", g_lang)
##    RETURN 'aws-227',g_ze.ze03
##   #RETURN 'aws-227','單別與單號碼數無設定，請到%1(aoos010)設定'
## END IF    
##   CASE g_aza.aza41                    
##      WHEN "1"   LET g_doc_len = 3      
##                 LET g_no_sp = 3 + 2     
##      WHEN "2"   LET g_doc_len = 4        
##                 LET g_no_sp = 4 + 2       
##      WHEN "3"   LET g_doc_len = 5          
##                 LET g_no_sp = 5 + 2         
##   END CASE                                   
##   CASE g_aza.aza42                            
##      WHEN "1"   LET g_no_ep = g_doc_len + 1 + 8
##      WHEN "2"   LET g_no_ep = g_doc_len + 1 + 9
##      WHEN "3"   LET g_no_ep = g_doc_len + 1 + 10
##   END CASE                      
     CALL s_doc_global_setting('ABM',g_plant)
##FUN-A10109 modify end
 
# CALL s_check_no("abm",g_bmx.bmx01,"","1","bmx_file","bmx001","")
#      RETURNING g_i,g_bmx.bmx01 
# IF NOT g_i THEN
#    LET g_ze.ze03 = cl_getmsg("aws-282", g_lang)
#    RETURN 'aws-282',g_ze.ze03
#   #RETURN 'aws-228','單據編號檢查錯誤'
# END IF    
 
 CALL s_auto_assign_no("abm",g_bmx.bmx01,g_bmx.bmx02,"1","bmx_file","bmx01","","","") RETURNING g_i,g_bmx.bmx01 
#End Add
# CALL s_smyauno(g_bmx.bmx01,g_bmx.bmx02) RETURNING g_i,g_bmx.bmx01
 IF NOT g_i THEN
    ROLLBACK WORK
    LET g_ze.ze03 = cl_getmsg("aws-263", g_lang)
    RETURN 'aws-263',g_ze.ze03
   #RETURN 'aws-226','ECN單號自動生成錯誤'
 END IF    
 LET l_headi=2
 LET l_fen=1
 CALL g_bmb.CLEAR()
 CALL bomInit(l_sep,bHeadField,bHeadData,bBodyField,bBodyData)
 
 #若無值
 IF g_bma.bma01 IS NULL AND g_bmb[1].bmb03 IS NULL THEN
    ROLLBACK WORK
    LET g_ze.ze03 = cl_getmsg("aws-264", g_lang)
    RETURN 'aws-264',g_ze.ze03
   #RETURN 'aws-226','主件料號為空且bmb03為空'
 END IF
 
 #若單頭無值
 IF g_bma.bma01 IS NULL AND NOT cl_null(g_bmb[1].bmb03) THEN
    LET l_fen=3
 END IF
 
 #若單身無值單頭有，只修改單頭
 IF g_bma.bma01 IS NOT NULL AND g_bmb[1].bmb03 IS NULL THEN
    LET l_fen=2
 END IF
 
 #若數據庫中不存在穿來的單頭，則調用其他函數新增，不在此處理
 IF NOT cl_null(g_bma.bma01) THEN
    LET i=1
    SELECT COUNT(*) INTO i FROM bma_file WHERE bma01=g_bma.bma01
    IF i=0 THEN
       CALL arr_data.CLEAR()
       LET arr_data[1].tables = "bma_file"
       LET arr_data[1].fields = bHeadField
       LET arr_data[1].data = bHeadData
       LET j=1
       WHILE NOT cl_null(g_bmb[j].bmb03)
          LET arr_data[1].body[j].tables = "bmb_file"
          LET arr_data[1].body[j].fields = bBodyField[1].FIELD
          LET arr_data[1].body[j].data = bBodyData[j].DATA
          LET j=j+1
       END WHILE
       
       #本來用于控制在調用DB_INSERT不傳入空置
       #但DB_INSERT改為可傳空值
       CALL arr_data[1].body.deleteElement(j)           
       CALL BeforeOperation("BOM","INSERT",l_Sep,arr_data,1) RETURNING l_errCode,l_errDesc 
       IF NOT cl_null(l_errCode) THEN
          ROLLBACK WORK
          RETURN l_errCode,l_errDesc
       ELSE
       	  CALL DB_INSERT("BOM",l_Sep,arr_data,1,"YYYY-MM-DD HH24:MI:SS") RETURNING l_errCode,l_errDesc
       	  IF NOT cl_null(l_errCode) THEN
       	     ROLLBACK WORK
       	     RETURN l_errCode,l_errDesc
       	  ELSE
       	     CALL AfterOperation("BOM","INSERT",l_Sep,arr_data,1) RETURNING l_errCode,l_errDesc
       	     IF NOT cl_null(l_errCode) THEN
       	        ROLLBACK WORK
       	        RETURN l_errCode,l_errDesc
       	     END IF
       	     RETURN l_errCode,l_errDesc 
       	  END IF  
       END IF 
    END IF
 END IF
#對調用UpdateBOM刪除的不予處理
#是否UpdateBom的管控END
 CASE l_fen
    WHEN 3       
       LET i=1
       WHILE NOT cl_null(g_bmb[i].bmb03)
       #FOR i=1 TO g_bmb.getLenth()
          IF NOT cl_null(g_bmb[i].bmb03) THEN
             SELECT * INTO g_bmb_o.* FROM bmb_file
              #WHERE bmb_pdm_rowi=g_bmb[i].bmb_pdm_rowi
              WHERE bmb01=g_bmb[i].bmb01 AND bmb03=g_bmb[i].bmb03    #Add By binbin080825
                AND (bmb04<=TODAY OR bmb04 IS NULL)   #Add By binbin080825
                AND (bmb05> TODAY OR bmb05 IS NULL)   #Add By binbin080825
             IF NOT cl_null(SQLCA.SQLCODE) THEN
                CASE SQLCA.SQLCODE
                   WHEN 100
                      LET g_bmy03_t='2'
                      LET g_bmb_t.* =g_bmb[i].*
                      CALL OperateEcn() RETURNING l_Operatecode,l_errcode            #新元件新增
                      IF cl_null(l_errcode) THEN
                         CALL adjustbmt() RETURNING l_errcode,l_errDesc
                      END IF
                      IF cl_null(l_Operatecode) THEN
                         LET i=i+1
                         CONTINUE WHILE
                         #CONTINUE FOR
                         #RETURN 0
                      ELSE
                      	 CALL errZhuhe("bmb_file",bBodyField[1].FIELD,bBodyData[i].DATA,l_errcode,"DB err!")
                      	 RETURNING l_errDesc
                      	 ROLLBACK WORK
                         RETURN 'aws-208',l_errDesc
                      END IF
                   OTHERWISE
                      CALL errZhuhe("bmb_file",bBodyField[1].FIELD,bBodyData[i].DATA,SQLCA.SQLCODE,"DB err!")
                      RETURNING l_errDesc
                      ROLLBACK WORK
                      RETURN 'aws-210',l_errDesc
                END CASE
             END IF
             LET g_bmy03_t='3'
             CALL CompareBomBody(g_bmb[i].*,g_bmb_o.*) RETURNING l_check                            #rowi在tiptop中存在，舊元件更改
             IF l_check==0 THEN
                LET i=i+1
                CONTINUE WHILE
                #CONTINUE FOR
             END IF
             CALL OperateEcn() RETURNING l_Operatecode,l_errcode
             IF cl_null(l_errcode) THEN
                CALL adjustbmt() RETURNING l_Operatecode,l_errcode 
             END IF
             #CALL OperateEcn()　RETURNING l_Operatecode,l_errcode          #利用全局g_bmb_t操作,此時其為更改后的值
             IF cl_null(l_Operatecode) THEN
                LET i=i+1
                CONTINUE WHILE
                #CONTINUE FOR
                #RETURN 0
             ELSE
             	  CALL errZhuhe("bmb_file",bBodyField[1].FIELD,bBodyData[i].DATA,l_errcode,"DB err!")
                RETURNING l_errDesc
                ROLLBACK WORK
                RETURN 'aws-210',l_errDesc
             END IF
          END IF
          LET i=i+1
       END WHILE
       #END FOR
       #若單頭未傳入，不操作                                           #舊元件失效
    WHEN 2
       IF NOT cl_null(g_bma.bma01) THEN
          SELECT * INTO g_bma_o.* FROM bma_file
           WHERE bma01=g_bma.bma01
          IF SQLCA.SQLCODE THEN
             CALL errZhuhe("bma_file",bHeadField,bHeadData,SQLCA.SQLCODE,"DB err!")
             RETURNING l_errDesc
             ROLLBACK WORK       
             RETURN 'aws-210',l_errDesc
          END IF
          CALL CompareBomHead(g_bma.*,g_bma_o.*) RETURNING l_check
          IF l_check==0 THEN
             RETURN 0,''
          END IF
          UPDATE bma_file SET bma_file.*=g_bma_t.*
          IF SQLCA.SQLCODE THEN
             CALL errZhuhe("bma_file",bHeadField,bHeadData,SQLCA.SQLCODE,"DB err!")
             RETURNING l_errDesc
             ROLLBACK WORK
             RETURN 'aws-210',l_errDesc
          ELSE
          	 RETURN 0,''
          END IF
       END IF
    WHEN 1
       WHILE TRUE
          IF NOT cl_null(g_bma.bma01) THEN
             SELECT * INTO g_bma_o.* FROM bma_file
              WHERE bma01=g_bma.bma01
             IF SQLCA.SQLCODE THEN
                CALL errZhuhe("bma_file",bHeadField,bHeadData,SQLCA.SQLCODE,"DB err!")
                RETURNING l_errDesc
                ROLLBACK WORK       
                RETURN 'aws-210',l_errDesc
             END IF
             CALL CompareBomHead(g_bma.*,g_bma_o.*) RETURNING l_check
             IF l_check==0 THEN
                EXIT WHILE
                #RETURN 0,''
             END IF
             #bom頭除主鍵外的小修改
             UPDATE bma_file SET bma02=g_bma_t.bma02,bma03=g_bma_t.bma03,
             bma04=g_bma_t.bma04,bma05=g_bma_t.bma05,bmauser=g_bma_t.bmauser,
             bmagrup=g_bma_t.bmagrup,bmamodu=g_bma_t.bmamodu,bmadate=g_bma_t.bmadate,
             bmaacti=g_bma_t.bmaacti
             WHERE bma01=g_bma_t.bma01
             IF SQLCA.SQLCODE THEN
                CALL errZhuhe("bma_file",bHeadField,bHeadData,SQLCA.SQLCODE,"DB err!")
                RETURNING l_errDesc
                ROLLBACK WORK       
                RETURN 'aws-210',l_errDesc
             ELSE
             	 EXIT WHILE
             	 #RETURN 0,''
             END IF
          END IF
       END WHILE
       LET i=1
       WHILE NOT cl_null(g_bmb[i].bmb03)
       #FOR i=1 TO g_bmb.getLenth()
          IF NOT cl_null(g_bmb[i].bmb03) THEN
             SELECT * INTO g_bmb_o.* FROM bmb_file
              #WHERE bmb_pdm_rowi=g_bmb[i].bmb_pdm_rowi
              WHERE bmb01=g_bmb[i].bmb01 AND bmb03=g_bmb[i].bmb03    #Add By binbin080825
                AND (bmb04<=TODAY OR bmb04 IS NULL)   #Add By binbin080825
                AND (bmb05> TODAY OR bmb05 IS NULL)   #Add By binbin080825
             IF SQLCA.SQLCODE THEN
                CASE SQLCA.SQLCODE
                   WHEN 100
                      LET g_bmy03_t='2'
                      LET g_bmb_t.* =g_bmb[i].*
                      CALL OperateEcn() RETURNING l_Operatecode,l_errcode            #新元件新增
                      IF cl_null(l_errcode) THEN
                         CALL adjustbmt() RETURNING l_Operatecode,l_errcode 
                      END IF
                      IF cl_null(l_Operatecode) THEN
                         LET i=i+1
                         CONTINUE WHILE
                         #CONTINUE FOR
                         #RETURN 0
                      ELSE
                      	 CALL errZhuhe("bmb_file",bBodyField[1].FIELD,bBodyData[i].DATA,l_errcode,"DB err!")
                         RETURNING l_errDesc
                         ROLLBACK WORK
                         RETURN 'aws-210',l_errDesc
                      END IF
                   OTHERWISE
                      CALL errZhuhe("bmb_file",bBodyField[1].FIELD,bBodyData[i].DATA,SQLCA.SQLCODE,"DB err!")
                      RETURNING l_errDesc
                      ROLLBACK WORK
                      RETURN 'aws-210',l_errDesc
                END CASE
             END IF
             LET g_bmy03_t='3'
             CALL CompareBomBody(g_bmb[i].*,g_bmb_o.*) RETURNING l_check  #rowi在tiptop中存在，舊元件更改
             IF l_check==0 THEN                                           
                LET i=i+1                                                 
                CONTINUE WHILE                                            
                #CONTINUE FOR                                             
             END IF                                                       
             CALL OperateEcn() RETURNING l_Operatecode,l_errcode          
             IF cl_null(l_errcode) THEN
                CALL adjustbmt() RETURNING l_Operatecode,l_errcode 
             END IF
             #CALL OperateEcn()　RETURN l_Operatecode,l_errcode           #利用全局g_bmb_t操作,此時其為更改后的值
             IF cl_null(l_Operatecode) THEN
                LET i=i+1
                CONTINUE WHILE
                #CONTINUE FOR
                #RETURN 0
             ELSE
             	  CALL errZhuhe("bmb_file",bBodyField[1].FIELD,bBodyData[i].DATA,l_errcode,"DB err!")
                RETURNING l_errDesc
                ROLLBACK WORK
                RETURN 'aws-210',l_errDesc
             END IF
          END IF
          LET i=i+1
       END WHILE
       #END FOR                            
       #舊元件失效
       #DECLARE bom_curs CURSOR FOR SELECT bmb_pdm_rowi FROM bmb_file
       DECLARE bom_curs CURSOR FOR SELECT bmb03 FROM bmb_file
                                    WHERE bmb01=g_bma.bma01
                                      AND (bmb04 IS NULL OR bmb04<=TODAY)   ##modify by chenzhong
                                      AND (bmb05 IS NULL OR bmb05 >TODAY)   ##modify by chenzhong
          LET i=1    ##by chenzhong 071011
       #FOREACH bom_curs INTO g_bmb_pdm_rowi
       FOREACH bom_curs INTO g_bmb_bmb03 
          LET l_check=1  
          LET i=1   ##by chenzhong 071011
          WHILE NOT cl_null(g_bmb[i].bmb03)
             #IF g_bmb[i].bmb_pdm_rowi=g_bmb_pdm_rowi THEN
             IF g_bmb[i].bmb03=g_bmb_bmb03 THEN
                LET l_check=0
                LET i=i+1  #Add By chenzhong 071011
                EXIT WHILE
             END IF
             LET i=i+1
          END WHILE
 
          IF l_check==1 THEN             #該bmb_pdm_rowi在數據庫中不存在
             LET g_bmy03_t='1'
             SELECT * INTO g_bmb_t.* FROM bmb_file
              #WHERE bmb_pdm_rowi = g_bmb_pdm_rowi    #FUN-9A0080 del 'd'
              WHERE bmb01=g_bma.bma01 AND bmb03=g_bmb_bmb03 
               AND (bmb04 IS NULL OR bmb04<=TODAY)   ##modify by chenzhong
               AND (bmb05 IS NULL OR bmb05 >TODAY)   ##modify by chenzhong
             CALL OperateEcn() RETURNING l_Operatecode,l_errcode
             IF cl_null(l_errcode) THEN
                CALL adjustbmt() RETURNING l_Operatecode,l_errcode 
             END IF
             IF cl_null(l_Operatecode) THEN
                 CONTINUE FOREACH
                 #RETURN 0
             ELSE
             	   CALL errZhuhe("bmb_file",bBodyField[1].FIELD,bBodyData[i].DATA,l_errcode,"DB err!")
                 RETURNING l_errDesc
                 ROLLBACK WORK
                 RETURN 'aws-210',l_errDesc
             END IF
          END IF
       END FOREACH
 END CASE
# COMMIT WORK
 RETURN l_errCode,l_errDesc
END FUNCTION
#************************************************************
FUNCTION OperateEcn()
DEFINE l_OperateCode LIKE type_file.num5
DEFINE l_sql         STRING
DEFINE l_bmz_n       LIKE type_file.num5
 
LET l_OperateCode=NULL
IF l_headi!=1 THEN
   LET g_bmx.bmxlegal = g_legal #FUN-980009
   LET g_bmx.bmxplant = g_plant #FUN-980009
 
   LET g_bmx.bmxoriu = g_user      #No.FUN-980030 10/01/04
   LET g_bmx.bmxorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO bmx_file VALUES(g_bmx.*)
   IF SQLCA.SQLCODE THEN
         LET l_OperateCode=1
         RETURN l_OperateCode,SQLCA.SQLCODE
   END IF
   LET l_headi=1
END IF
CASE 
   WHEN g_bmy03_t='1'
      CALL bmy_default()
      LET g_bmy.bmyplant = g_plant #FUN-980009
      LET g_bmy.bmylegal = g_legal #FUN-980009
      INSERT INTO bmy_file VALUES(g_bmy.*)
      IF SQLCA.SQLCODE THEN
         LET l_OperateCode=1
         RETURN l_OperateCode,SQLCA.SQLCODE
      END IF
      SELECT COUNT(*) INTO l_bmz_n FROM bmz_file WHERE bmz01=g_bmx.bmx01 AND bmz02=g_bma.bma01 
      IF l_bmz_n==0 THEN
         CALL bmz_default()
         LET g_bmz.bmzplant = g_plant #FUN-980009
         LET g_bmz.bmzlegal = g_legal #FUN-980009
         INSERT INTO bmz_file VALUES(g_bmz.*)
         IF SQLCA.SQLCODE THEN
            LET l_OperateCode=1
            RETURN l_OperateCode,SQLCA.SQLCODE
         END IF
      END IF
   WHEN g_bmy03_t='2'
      CALL bmy_default()
      IF cl_null(g_bmy.bmy01) THEN  
         #CALL cl_err('','',1)
         LET l_OperateCode=1
         RETURN l_OperateCode,"ECN NO IS NULL"
      END IF
      LET g_bmy.bmylegal = g_legal #FUN-980009
      LET g_bmy.bmyplant = g_plant #FUN-980009
      INSERT INTO bmy_file VALUES(g_bmy.*)
      IF SQLCA.SQLCODE THEN
         LET l_OperateCode=1
         RETURN l_OperateCode,SQLCA.SQLCODE
      END IF
      SELECT COUNT(*) INTO l_bmz_n FROM bmz_file WHERE bmz01=g_bmx.bmx01 AND bmz02=g_bma.bma01 
      IF l_bmz_n==0 THEN
         CALL bmz_default()
         IF cl_null(g_bmz.bmz01) THEN  
            LET l_OperateCode=1
            RETURN l_OperateCode,"ECN NO IS NULL"
         END IF
         LET g_bmz.bmzplant = g_plant #FUN-980009
         LET g_bmz.bmzlegal = g_legal #FUN-980009
         INSERT INTO bmz_file VALUES(g_bmz.*)
         IF SQLCA.SQLCODE THEN
            LET l_OperateCode=1
            RETURN l_OperateCode,SQLCA.SQLCODE
         END IF
      END IF
   WHEN g_bmy03_t='3'
      CALL bmy_default()
      IF cl_null(g_bmy.bmy01) THEN
         #CALL cl_err('','',1)
         LET l_OperateCode=1
         RETURN l_OperateCode,"ECN NO IS NULL"
      END IF
      LET g_bmy.bmyplant = g_plant #FUN-980009
      LET g_bmy.bmylegal = g_legal #FUN-980009
      INSERT INTO bmy_file VALUES(g_bmy.*)
      IF SQLCA.SQLCODE THEN
         LET l_OperateCode=1
         RETURN l_OperateCode,SQLCA.SQLCODE
      END IF
      SELECT COUNT(*) INTO l_bmz_n FROM bmz_file WHERE bmz01=g_bmx.bmx01 AND bmz02=g_bma.bma01 
      IF l_bmz_n==0 THEN
         CALL bmz_default()
         IF cl_null(g_bmz.bmz01) THEN
            LET l_OperateCode=1
            RETURN l_OperateCode,"ECN NO IS NULL"
         END IF
         LET g_bmz.bmzplant = g_plant #FUN-980009
         LET g_bmz.bmzlegal = g_legal #FUN-980009
         INSERT INTO bmz_file VALUES(g_bmz.*)
         IF SQLCA.SQLCODE THEN
            LET l_OperateCode=1
            RETURN l_OperateCode,SQLCA.SQLCODE
         END IF
      END IF
END CASE
RETURN l_OperateCode,''
END FUNCTION
 
#add by binbin for bmb13 080820 begin
FUNCTION adjustbmt()
DEFINE l_bmt_count         LIKE type_file.num5
DEFINE l_sql,l_errDesc     STRING
 
 IF NOT cl_null(l_bmb13_tmp_data[i]) THEN
    LET l_bmb13_length = l_bmb13_tmp_data[i].getLength()
    IF l_bmb13_length>80 THEN 
       LET l_bmb13_Sep=','
       CALL aws_Tokenizer(l_bmb13_tmp_data[i],l_bmb13_Sep,bmt_arr_data)
       FOR l_bmt_i = 1 TO bmt_arr_data.getLength()
          LET l_bmt_tmp_data = bmt_arr_data[l_bmt_i]
          IF cl_null(l_bmt_data) THEN
             LET l_bmt_data=l_bmt_tmp_data
          ELSE
             LET l_bmt_data=l_bmt_data,",",l_bmt_tmp_data
          END IF 
          IF (l_bmt_i mod 13)==0 AND l_bmt_i!=bmt_arr_data.getLength() THEN 
             LET l_bmt_n=(l_bmt_i/13)
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
                #LET l_bmt_n=0
             END IF 
          END IF 
       END FOR 
    ELSE 
       LET l_bmt_n=1
       LET l_bmt[l_bmt_n].bmt05=(l_bmt_n*10)
       LET l_bmt[l_bmt_n].bmt06=l_bmb13_tmp_data[i]
       LET l_bmb13_Sep=','
       CALL aws_Tokenizer(l_bmb13_tmp_data[i],l_bmb13_Sep,bmt_arr_data)
       LET l_bmt[l_bmt_n].bmt07=bmt_arr_data.getLength()
       LET l_bmt_total=l_bmt_n          #save the total lines of bmt_file to l_bmt_total for use to insert into bmt_file
       #LET l_bmt_n=0
    END IF 
 
    FOR l_bmt_n=1 TO l_bmt_total
       INSERT INTO bmw_file(bmw01,bmw02,bmw03,bmw04,bmw05) VALUES(g_bmy.bmy01,g_bmy.bmy02,l_bmt[l_bmt_n].bmt05,l_bmt[l_bmt_n].bmt06,l_bmt[l_bmt_n].bmt07)
{       SELECT COUNT(*) INTO l_bmt_count FROM bmt_file WHERE bmt01=g_bmb[i].bmb01 AND bmt02=g_bmb[i].bmb02 AND bmt03=g_bmb[i].bmb03 AND bmt04=g_bmb[i].bmb04 AND bmt05=l_bmt[l_bmt_n].bmt05
       IF l_bmt_count=0 THEN
          LET l_sql = "INSERT INTO bmt_file(bmt01,bmt02,bmt03,bmt04,bmt05,bmt06,bmt07,bmt08) values('",g_bmb[i].bmb01,"','",g_bmb[i].bmb02,"','",g_bmb[i].bmb03,"','",g_bmb[i].bmb04,"','",l_bmt[l_bmt_n].bmt05,"','",l_bmt[l_bmt_n].bmt06,"','",l_bmt[l_bmt_n].bmt07,"',' ')"
          PREPARE bmt_cs_insert FROM l_sql
          EXECUTE bmt_cs_insert
          IF SQLCA.sqlcode THEN
             ROLLBACK WORK
            #LET l_errDesc = "插入bmt_file失敗，請檢查bmb13"
             LET l_errDesc = cl_getmsg("aws-265", g_lang)
             RETURN 'aws-265',l_errDesc
          END IF 
       ELSE
          IF l_bmt_count=1 THEN
#FUN-9A0080 --BEGIN--
#             SELECT bmt_file.rowi INTO l_bmt_rowi FROM bmt_file 
#              WHERE bmt01=g_bmb[i].bmb01 AND bmt02=g_bmb[i].bmb02
#                AND bmt03=g_bmb[i].bmb03 AND bmt04=g_bmb[i].bmb04 AND bmt05=l_bmt[l_bmt_n].bmt05
#FUN-9A0080 --END--
             SELECT bmt06 INTO l_bmt06_t FROM bmt_file 
#              WHERE rowi=l_bmt_rowi    #FUN-9A0080
#FUN-9A0080 --BEGIN--
               WHERE bmt01=g_bmb[i].bmb01
                 AND bmt02=g_bmb[i].bmb02
                 AND bmt03=g_bmb[i].bmb03
                 AND bmt04=g_bmb[i].bmb04
                 AND bmt05=l_bmt[i].bmt04
#FUN-9A0080 --END-- 
             IF l_bmt06_t<>l_bmt[l_bmt_n].bmt06 THEN
                DELETE FROM bmt_file
#                WHERE rowi=l_bmt_rowi   #FUN-9A0080
#FUN-9A0080 --BEGIN--
               WHERE bmt01=g_bmb[i].bmb01
                 AND bmt02=g_bmb[i].bmb02
                 AND bmt03=g_bmb[i].bmb03
                 AND bmt04=g_bmb[i].bmb04
                 AND bmt05=l_bmt[i].bmt04
#FUN-9A0080 --END--
                LET l_sql = "INSERT INTO bmt_file(bmt01,bmt02,bmt03,bmt04,bmt05,bmt06,bmt07,bmt08) values('",g_bmb[i].bmb01,"','",g_bmb[i].bmb02,"','",g_bmb[i].bmb03,"','",g_bmb[i].bmb04,"','",l_bmt[l_bmt_n].bmt05,"','",l_bmt[l_bmt_n].bmt06,"','",l_bmt[l_bmt_n].bmt07,"',' ')"
                PREPARE bmt_cs_adjust FROM l_sql
                EXECUTE bmt_cs_adjust
                IF SQLCA.sqlcode THEN
                   ROLLBACK WORK
                   LET l_errDesc = cl_getmsg("aws-266", g_lang)
                  #LET l_errDesc = "調整bmt_file失敗，請檢查bmb13"
                   RETURN 'aws-266',l_errDesc
                END IF 
             END IF 
          END IF
          IF l_bmt_count>1 THEN
             DELETE FROM bmt_file WHERE bmt01=g_bmb[i].bmb01 AND bmt02=g_bmb[i].bmb02 AND bmt03=g_bmb[i].bmb03 AND bmt04=g_bmb[i].bmb04 AND bmt05=l_bmt[l_bmt_n].bmt05
                LET l_sql = "INSERT INTO bmt_file(bmt01,bmt02,bmt03,bmt04,bmt05,bmt06,bmt07,bmt08) values('",g_bmb[i].bmb01,"','",g_bmb[i].bmb02,"','",g_bmb[i].bmb03,"','",g_bmb[i].bmb04,"','",l_bmt[l_bmt_n].bmt05,"','",l_bmt[l_bmt_n].bmt06,"','",l_bmt[l_bmt_n].bmt07,"',' ')"
                PREPARE bmt_adjust FROM l_sql
                EXECUTE bmt_adjust
                IF SQLCA.sqlcode THEN
                   ROLLBACK WORK
                   LET l_errDesc = cl_getmsg("aws-266", g_lang)
                  #LET l_errDesc = "調整bmt_file失敗，請檢查bmb13"
                   RETURN 'aws-266',l_errDesc
                END IF 
          END IF
       END IF
}
    END FOR 
 END IF 
 
 RETURN '',''
 
END FUNCTION
#add by binbin for bmb13 080820 end
 
#************************************************************
FUNCTION bmx_default()
DEFINE li_result STRING
 
 INITIALIZE g_bmx.* TO NULL
 LET g_bmx.bmx02 = TODAY
 LET g_bmx.bmx07 = TODAY
 LET g_bmx.bmx04 = 'N'
 LET g_bmx.bmx06 ='1'
 LET g_bmx.bmx05=''
 LET g_bmx.bmxuser=g_user
 LET g_bmx.bmxoriu = g_user #FUN-980030
 LET g_bmx.bmxorig = g_grup #FUN-980030
 LET g_data_plant = g_plant #FUN-980030
 LET g_bmx.bmxmodu=g_bma.bmauser
 LET g_bmx.bmxgrup=g_grup
 LET g_bmx.bmxdate=g_today
 LET g_bmx.bmxacti='Y'
 LET g_bmx.bmx09='0'
 LET g_bmx.bmx10=g_user
 LET g_bmx.bmx11=g_bmx11
 #先給單頭賦予單號，要求TIPTOP中存在’ECN'單別
 #若不存在會出錯
 LET g_bmx.bmx01='ECN-'
 SELECT smyapr INTO g_bmx.bmxmksg FROM smy_file 
   WHERE smyslip = 'ECN'
END FUNCTION
#******************************************************************
FUNCTION bmy_default()
DEFINE l_bmx01 like bmx_file.bmx01
 INITIALIZE g_bmy.* TO NULL
 LET g_bmy.bmy01=g_bmx.bmx01
 #bmy02項次自動給為項次中最大值
 IF cl_null(g_bmy.bmy02) OR g_bmy.bmy02 = 0 THEN
    SELECT max(bmy02)+1 INTO g_bmy.bmy02
      FROM bmy_file WHERE bmy01 = g_bmx.bmx01
    IF g_bmy.bmy02 IS NULL THEN
       LET g_bmy.bmy02 = 1
    END IF
 END IF
 LET g_bmy.bmy03=g_bmy03_t
#LET g_bmy.bmy04=g_bmb_t.bmb02
 LET g_bmy.bmy05=g_bmb_t.bmb03
 LET g_bmy.bmy06=g_bmb_t.bmb06
 LET g_bmy.bmy07=g_bmb_t.bmb07
 LET g_bmy.bmy08=0
 LET g_bmy.bmy09=''
 LET g_bmy.bmy10=g_bmb_t.bmb10
 LET g_bmy.bmy10_fac=g_bmb_t.bmb10_fac
 LET g_bmy.bmy10_fac2=g_bmb_t.bmb10_fac2
 LET g_bmy.bmy11=g_bmb_t.bmb11
 LET g_bmy.bmy13=g_bmb_t.bmb13
#LET g_bmy.bmy14=g_bma.bma01
 #LET g_bmy.bmy15=g_bmb_t.bmb15
 LET g_bmy.bmy16=g_bmb_t.bmb16
 LET g_bmy.bmy18=g_bmb_t.bmb18
 LET g_bmy.bmy20=g_bmb_t.bmb19
 LET g_bmy.bmy21=g_bmb_t.bmb15
 LET g_bmy.bmy23=g_bmb_t.bmb28
 LET g_bmy.bmy25=g_bmb_t.bmb25
 LET g_bmy.bmy26=g_bmb_t.bmb26
 ##Add by chenzhong
 LET g_bmy.bmy29=' '
 LET g_bmy.bmy33=0
 LET g_bmy.bmy34='N'
 ##End add
# LET g_bmy.bmy_pdm_rowi = g_bmb_t.bmb_pdm_rowi
 IF cl_null(g_bmy.bmy16) THEN LET g_bmy.bmy16 = '0' END IF 
 IF cl_null(g_bmy.bmy07) THEN LET g_bmy.bmy07 = 1 END IF 
 
 DECLARE bmx_cur CURSOR FOR 
   SELECT bmx01 FROM bmy_file,bmx_file WHERE bmx01=bmy01 AND bmx04='N' AND bmy14=g_bmy.bmy14 and bmx01 <> g_bmx.bmx01
 FOREACH bmx_cur INTO l_bmx01 
   UPDATE bmx_file SET bmx04='X',bmx09='9' WHERE bmx01=l_bmx01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN      
   END IF    
 END FOREACH 
END FUNCTION
 
#******************************************************************
FUNCTION bmz_default()
 INITIALIZE g_bmz.* TO NULL
 LET g_bmz.bmz01=g_bmx.bmx01
 LET g_bmz.bmz02=g_bma.bma01
 #LET g_bmz.bmz04=g_bmy.bmy02
 LET g_bmz.bmz05=' '
 LET g_bmz.bmz011 = ' '       #FUN-A60027
 LET g_bmz.bmz012 = ' '       #FUN-A60027
 LET g_bmz.bmz013 = 0         #FUN-A60027 
 #LET g_bmz.bmz03=g_bmz.bmz04 CLIPPED,'1'
END FUNCTION
#************************************************************************
 
#************************************************************************
#l_sep,l_checkID,bHeadField,bHeadData,bBodyField,bBodyData
FUNCTION bomInit(l_sep,bHeadField,bHeadData,bBodyField,bBodyData) 
DEFINE tok   base.StringTokenizer
DEFINE head1    STRING                            #字段屬性
DEFINE count1   LIKE type_file.num5                          
DEFINE l_detail LIKE type_file.num5                          
DEFINE field1,data1  DYNAMIC ARRAY OF STRING      #暫存字段#暫存數據
DEFINE l_sep               STRING                 #分隔字符
DEFINE bBodyField  DYNAMIC ARRAY OF RECORD        #單身欄位
                     FIELD STRING                 
                   END RECORD,                    
       bBodyData   DYNAMIC ARRAY OF RECORD        #單身對應值
                     DATA STRING
                   END RECORD
DEFINE bHeadField          STRING,
       bHeadData           STRING
DEFINE arr_field DYNAMIC ARRAY OF STRING
DEFINE arr_data  DYNAMIC ARRAY OF STRING
 
 #No.MOD-960008 begin
 #LET head1=bHeadField
 #LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
 #LET count1=tok.countTokens()
 #WHILE tok.hasMoreTokens()
 #   LET i = tok.countTokens()
 #   LET field1[i] = tok.nextToken()
 #END WHILE
 #LET head1=bHeadData
 #LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
 #WHILE tok.hasMoreTokens()
 #   LET i = tok.countTokens()
 #   LET data1[i] = tok.nextToken()
 #END WHILE
 
 CALL aws_Tokenizer(bHeadField,l_sep,arr_field)
 CALL aws_Tokenizer(bHeadData,l_Sep,arr_data)
 FOR i = 1 TO arr_field.getLength()
 #No.MOD-960008 end
    LET field1[i] = arr_field[i]
    LET data1[i] = arr_data[i]
 
 #add by zqj 06/07/27若為'%%'則將之置空，就不影響操作
 #FOR i=1 TO count1
    IF data1[i] = '%%' THEN
       LET data1[i] = NULL
    END IF
 #END FOR
 #end add
 
 #給g_bma賦值
 #FOR i=1 TO count1
    CASE field1[i]
       WHEN "bma01"
          LET g_bma.bma01=data1[i]
       WHEN "bma02"
          LET g_bma.bma02=data1[i]
       WHEN "bma03"
          LET g_bma.bma03=data1[i]
       WHEN "bma04"
          LET g_bma.bma04=data1[i]
       WHEN "bma05"
          #LET g_bma.bma05=data1[i]
          LET g_bma.bma05=''
       WHEN "bmauser"
          LET g_bma.bmauser=data1[i]
       WHEN "bmagrup"
          LET g_bma.bmagrup=data1[i]
       WHEN "bmamodu"
          LET g_bma.bmamodu=data1[i]
       WHEN "bmadate"
          LET g_bma.bmadate=data1[i]
       WHEN "bmaacti"
          LET g_bma.bmaacti=data1[i]
    END CASE
 END FOR
 
 #給g_bmb[i]賦值
 CALL field1.CLEAR()
 CALL data1.CLEAR()
 LET l_detail=1
 WHILE(bBodyData[l_detail].DATA IS NOT NULL) 
    #No.MOD-960008 begin
    #LET head1=bBodyField[1].FIELD
    #LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
    #LET count1=tok.countTokens()
    #WHILE tok.hasMoreTokens()
    #   LET i = tok.countTokens()
    #   LET field1[i] = tok.nextToken()
    #END WHILE
    #LET head1=bBodyData[l_detail].DATA
    #LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
    #WHILE tok.hasMoreTokens()
    #   LET i = tok.countTokens()
    #   LET data1[i] = tok.nextToken()
    #END WHILE
    
    CALL aws_Tokenizer(bBodyField[1].FIELD,l_sep,arr_field)
    CALL aws_Tokenizer(bBodyData[l_detail].DATA,l_Sep,arr_data)
    FOR i = 1 TO arr_field.getLength()
    #No.MOD-960008 end
       LET field1[i] = arr_field[i]
       LET data1[i] = arr_data[i]
 
    #add by zqj 06/07/27若為'%%'則將之置空，就不影響操作
    #FOR i=1 TO count1
       IF data1[i] = '%%' THEN
          LET data1[i] = NULL
       END IF
    #END FOR
    #end add
    
    #FOR i=1 TO count1 
       CASE field1[i]
          WHEN "bmb01"
             LET g_bmb[l_detail].bmb01=data1[i]
          WHEN "bmb02"
             LET g_bmb[l_detail].bmb02=data1[i]
          WHEN "bmb03"
             LET g_bmb[l_detail].bmb03=data1[i]
          WHEN "bmb04"
             LET g_bmb[l_detail].bmb04=data1[i]
          WHEN "bmb05"
             LET g_bmb[l_detail].bmb05=data1[i]
          WHEN "bmb06"
             LET g_bmb[l_detail].bmb06=data1[i]
          WHEN "bmb07"
             LET g_bmb[l_detail].bmb07=data1[i]
          WHEN "bmb08"
             LET g_bmb[l_detail].bmb08=data1[i]
#Add By chenzhong
          WHEN "bmb09"
             LET g_bmb[l_detail].bmb09=data1[i]
          WHEN "bmb14"
             LET g_bmb[l_detail].bmb14=data1[i]
          WHEN "bmb15"
             LET g_bmb[l_detail].bmb15=data1[i]
          WHEN "bmb16"
             LET g_bmb[l_detail].bmb16=data1[i]
          WHEN "bmb17"
             LET g_bmb[l_detail].bmb17=data1[i]
          WHEN "bmb18"
             LET g_bmb[l_detail].bmb18=data1[i]
          WHEN "bmb19"
             LET g_bmb[l_detail].bmb19=data1[i]
          WHEN "bmb27"
             LET g_bmb[l_detail].bmb27=data1[i]
          WHEN "bmb28"
             LET g_bmb[l_detail].bmb28=data1[i]
          WHEN "bmb29"
             LET g_bmb[l_detail].bmb29=data1[i]
          WHEN "bmb31"
             LET g_bmb[l_detail].bmb31=data1[i]
          WHEN "bmb10_fac"
             LET g_bmb[l_detail].bmb10_fac=data1[i]
          WHEN "bmb10_fac2"
             LET g_bmb[l_detail].bmb10_fac2=data1[i]
#End Add
          WHEN "bmb10"
             LET g_bmb[l_detail].bmb10=data1[i]
          WHEN "bmb11"
             LET g_bmb[l_detail].bmb11=data1[i]
          WHEN "bmb13"
             LET g_bmb[l_detail].bmb13=data1[i]
             
             #add by binbin for bmb13 080820 begin
             LET l_bmb13_tmp_data[l_detail]=data1[i]
             {LET l_bmb13_length = l_bmb13_tmp_data[l_detail].getLength()
             IF l_bmb13_length>80 THEN 
                LET l_bmb13_Sep=','
                CALL aws_Tokenizer(l_bmb13_tmp_data[l_detail],l_bmb13_Sep,bmt_arr_data)
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
                         LET g_bmb[l_detail].bmb13=l_bmt_data     #now the l_tmp_data is bmt_file first line data bmt06 for insert into bmb13 
                         LET l_bmt_i=bmt_arr_data.getLength()
                      END IF 
                      LET l_bmt_data=''                #clear l_bmt_data for next bmt06
                   ELSE 
                      IF l_bmt_i==bmt_arr_data.getLength() THEN 
                         LET l_bmt_data=''                #clear l_bmt_data for next bmt06
                      END IF 
                   END IF 
                END FOR 
             ELSE 
                LET g_bmb[l_detail].bmb13=data1[i]
             END IF}
             #add by binbin for bmb13 080820 end
 
             
          #WHEN "PDM_rowi"
             #LET g_bmb_rowi=data1[i]
          WHEN "bmbmodu"
             LET g_bmb[l_detail].bmbmodu=data1[i]
          WHEN "bmbdate"
             LET g_bmb[l_detail].bmbdate=data1[i]
          WHEN "bmbcomm"
             LET g_bmb[l_detail].bmbcomm=data1[i]
          #WHEN "bmb_pdm_rowi"
          #   LET g_bmb[l_detail].bmb_pdm_rowi=data1[i]
       END CASE
 
       IF g_bmb[l_detail].bmb10=='G' THEN
          SELECT ima25 INTO g_bmb[l_detail].bmb10 FROM ima_file WHERE ima01=g_bmb[l_detail].bmb03
       END IF
 
    END FOR
    
    LET l_detail=l_detail+1
 END WHILE
END FUNCTION
 
#*************************************************
#g_bmb_t存更改后的數據，返回０無更改，返回１有更改
FUNCTION CompareBomBody(l_bmb1,l_bmb2)
DEFINE l_bmb1    RECORD LIKE bmb_file.*,   #Pdm 資料	
       l_bmb2    RECORD LIKE bmb_file.*    #tiptop數據庫中資料 
DEFINE l_bmb04   VARCHAR(8)                   #add by chenzhong
      
 IF l_bmb1.*==l_bmb2.* THEN
    RETURN 0
 END IF
 
 INITIALIZE g_bmb_t.* TO NULL
 LET g_bmb_t.*=l_bmb2.*	
 IF NOT cl_null(l_bmb1.bmb01) THEN
    IF cl_null(l_bmb2.bmb01) THEN
       LET g_bmb_t.bmb01=l_bmb1.bmb01
    ELSE
    	 IF l_bmb1.bmb01<>l_bmb2.bmb01 THEN 
    	    LET g_bmb_t.bmb01=l_bmb1.bmb01 
    	 END IF
    END IF 
 END IF
 {IF NOT cl_null(l_bmb1.bmb02) THEN
    IF cl_null(l_bmb2.bmb02) THEN
       LET g_bmb_t.bmb02=l_bmb1.bmb02
    ELSE
       IF l_bmb1.bmb02<>l_bmb2.bmb02 THEN 
          LET g_bmb_t.bmb02=l_bmb1.bmb02 
       END IF 
    END IF
 END IF}
 IF NOT cl_null(l_bmb1.bmb03) THEN
    IF cl_null(l_bmb2.bmb03) THEN
       LET g_bmb_t.bmb03=l_bmb1.bmb03
    ELSE
    	 IF l_bmb1.bmb03<>l_bmb2.bmb03 THEN 
    	    LET g_bmb_t.bmb03=l_bmb1.bmb03
    	 END IF 
    END IF
 END IF
{ IF NOT cl_null(l_bmb1.bmb04) THEN         
    IF cl_null(l_bmb2.bmb04) THEN                                   
       LET g_bmb_t.bmb04=l_bmb1.bmb04                               
    ELSE                                                             
       LET l_bmb04=l_bmb2.bmb04                      ###modify by chenzhong 
#    	 IF l_bmb1.bmb04<>l_bmb2.bmb04 THEN          ###modify by chenzhong
    	 IF l_bmb1.bmb04<>l_bmb04 THEN               ###modify by chenzhong
    	    LET g_bmb_t.bmb04=l_bmb1.bmb04 
    	 END IF 
    END IF
 END IF}
 IF NOT cl_null(l_bmb1.bmb05) THEN
    IF cl_null(l_bmb2.bmb05) THEN
       LET g_bmb_t.bmb05=l_bmb1.bmb05
    ELSE
    	 IF l_bmb1.bmb05<>l_bmb2.bmb05 THEN 
    	    LET g_bmb_t.bmb05=l_bmb1.bmb05 
    	 END IF 
    END IF
 END IF
 IF NOT cl_null(l_bmb1.bmb06) THEN 
    IF cl_null(l_bmb2.bmb06) THEN
       LET g_bmb_t.bmb06=l_bmb1.bmb06
    ELSE
    	 IF l_bmb1.bmb06<>l_bmb2.bmb06 THEN 
    	    LET g_bmb_t.bmb06=l_bmb1.bmb06 
    	 END IF 
    END IF
 END IF
 IF NOT cl_null(l_bmb1.bmb07) THEN
    IF cl_null(l_bmb2.bmb07) THEN
       LET g_bmb_t.bmb07=l_bmb1.bmb07
    ELSE
    	 IF l_bmb1.bmb07<>l_bmb2.bmb07 THEN 
    	    LET g_bmb_t.bmb07=l_bmb1.bmb07 
    	 END IF 
    END IF
 END IF         
 IF NOT cl_null(l_bmb1.bmb08) THEN 
    IF cl_null(l_bmb2.bmb08) THEN
       LET g_bmb_t.bmb08=l_bmb1.bmb08
    ELSE
    	 IF l_bmb1.bmb08<>l_bmb2.bmb08 THEN 
    	    LET g_bmb_t.bmb08=l_bmb1.bmb08 
    	 END IF 
    END IF
 END IF
 IF NOT cl_null(l_bmb1.bmb09) THEN 
    IF cl_null(l_bmb2.bmb09) THEN
       LET g_bmb_t.bmb09=l_bmb1.bmb09
    ELSE
    	 IF l_bmb1.bmb09<>l_bmb2.bmb09 THEN 
    	    LET g_bmb_t.bmb09=l_bmb1.bmb09 
    	 END IF 
    END IF
 END IF       
 IF NOT cl_null(l_bmb1.bmb10) THEN
    IF cl_null(l_bmb2.bmb10) THEN
       LET g_bmb_t.bmb10=l_bmb1.bmb10
    ELSE
    	 IF l_bmb1.bmb10<>l_bmb2.bmb10 THEN 
    	    LET g_bmb_t.bmb10=l_bmb1.bmb10 
    	 END IF 
    END IF
 END IF
 IF NOT cl_null(l_bmb1.bmb11) THEN 
    IF cl_null(l_bmb2.bmb11) THEN
       LET g_bmb_t.bmb11=l_bmb1.bmb11
    ELSE
    	 IF l_bmb1.bmb11<>l_bmb2.bmb11 THEN 
    	    LET g_bmb_t.bmb11=l_bmb1.bmb11 
    	 END IF 
    END IF
 END IF
 IF NOT cl_null(l_bmb1.bmb13) THEN
    IF cl_null(l_bmb2.bmb13) THEN
       LET g_bmb_t.bmb13=l_bmb1.bmb13
    ELSE 
    	 IF l_bmb1.bmb13<>l_bmb2.bmb13 THEN 
    	    LET g_bmb_t.bmb13=l_bmb1.bmb13 
    	 END IF 
    END IF
 END IF
 IF NOT cl_null(l_bmb1.bmb16) THEN
    IF cl_null(l_bmb2.bmb16) THEN
       LET g_bmb_t.bmb16=l_bmb1.bmb16
    ELSE 
    	 IF l_bmb1.bmb16<>l_bmb2.bmb16 THEN 
    	    LET g_bmb_t.bmb16=l_bmb1.bmb16 
    	 END IF 
    END IF
 END IF
 
 IF g_bmb_t.*!=l_bmb2.* THEN
    RETURN 1
 ELSE
 	 RETURN 0
 END IF
END FUNCTION
#*******************************************************
FUNCTION CompareBomHead(l_bma1,l_bma2)
DEFINE l_bma1     RECORD LIKE bma_file.*,   #pdm資料
       l_bma2     RECORD LIKE bma_file.*  #tiptop數據資料
 
 IF l_bma1.*=l_bma2.* THEN
    RETURN 0
 END IF
 INITIALIZE g_bma_t.* TO NULL
 LET g_bma_t.*=l_bma2.*
 IF NOT cl_null(l_bma1.bma01) THEN 
    IF l_bma1.bma01<>l_bma2.bma01 THEN 
       LET g_bma_t.bma01=l_bma1.bma01 
    END IF
 END IF
 IF NOT cl_null(l_bma1.bma02) THEN
    IF cl_null(l_bma2.bma02) THEN 
       LET g_bma_t.bma02=l_bma1.bma02 
    ELSE 
       IF l_bma1.bma02!=l_bma2.bma02 THEN 
          LET g_bma_t.bma02=l_bma1.bma02 
       END IF
    END IF
 END IF
 IF NOT cl_null(l_bma1.bma03) THEN
    IF cl_null(l_bma2.bma03) THEN
       LET g_bma_t.bma02=l_bma1.bma03
    ELSE
       IF l_bma1.bma03<>l_bma2.bma03 THEN 
          LET g_bma_t.bma03=l_bma1.bma03
       END IF 
    END IF
 END IF
 IF NOT cl_null(l_bma1.bma04) THEN
    IF cl_null(l_bma2.bma04) THEN
       LET g_bma_t.bma04=l_bma1.bma04
    ELSE
    	 IF l_bma1.bma04<>l_bma2.bma04 THEN
    	    LET g_bma_t.bma04=l_bma1.bma04
    	 END IF
    END IF
  END IF
 IF NOT cl_null(l_bma1.bma05) THEN
    IF cl_null(l_bma2.bma05) THEN
       LET g_bma_t.bma05=l_bma1.bma05
    ELSE
    	 IF l_bma1.bma05<>l_bma2.bma05 THEN
    	    LET g_bma_t.bma05=l_bma1.bma05 
    	 END IF 
    END IF
 END IF
 IF NOT cl_null(l_bma1.bmauser) THEN 
    IF cl_null(l_bma2.bmauser) THEN
       LET g_bma_t.bmauser=l_bma1.bmauser
    ELSE
    	 IF l_bma1.bmauser<>l_bma2.bmauser THEN 
    	    LET g_bma_t.bmauser=l_bma1.bmauser 
    	 END IF 
    END IF
 END IF
 IF NOT cl_null(l_bma1.bmagrup) THEN
    IF cl_null(l_bma2.bmagrup) THEN
       LET g_bma_t.bmagrup=l_bma1.bmagrup
    ELSE
    	 IF l_bma1.bmagrup<>l_bma2.bmagrup THEN 
    	    LET g_bma_t.bmagrup=l_bma1.bmagrup 
    	 END IF 
    END IF
 END IF          
 {IF NOT cl_null(l_bma1.bmadate) THEN
    IF cl_null(l_bma2.bmadate) THEN
       LET g_bma_t.bmadate=l_bma1.bmadate
    ELSE
    	 IF l_bma1.bmadate<>l_bma2.bmadate THEN 
    	    LET g_bma_t.bmadate=l_bma1.bmadate 
    	 END IF 
    END IF
 END IF}
 IF NOT cl_null(l_bma1.bmamodu) THEN
    IF cl_null(l_bma2.bmamodu) THEN
       LET g_bma_t.bmamodu=l_bma1.bmamodu
    ELSE
    	 IF l_bma1.bmamodu<>l_bma2.bmamodu THEN 
    	    LET g_bma_t.bmamodu=l_bma1.bmamodu 
    	 END IF 
    END IF
 END IF      
 IF NOT cl_null(l_bma1.bmaacti) THEN 
    IF cl_null(l_bma2.bmaacti) THEN
       LET g_bma_t.bmaacti=l_bma1.bmaacti
    ELSE
    	 IF l_bma1.bmaacti<>l_bma2.bmaacti THEN 
    	    LET g_bma_t.bmaacti=l_bma1.bmaacti 
    	 END IF 
    END IF
 END IF  
 IF g_bma_t.*!=l_bma2.* THEN
    RETURN 1
 ELSE
    RETURN 0
 END IF
END FUNCTION
#********************************************************      
#此functtion根據錯誤，
#生成類似<Table=”xxx” Field=”xxx|...|xxx” Data=”mmm|...|mmm” Code=”xxx” Desc=”xxx”/>
#的STRING
FUNCTION errZhuhe(table3e,field3e,data3e,code3e,desc3e)
DEFINE table3e     STRING,
       field3e     STRING,
       data3e      STRING,
       code3e      STRING,
       desc3e      STRING
DEFINE errstring   base.StringBuffer
 
 LET errstring = base.StringBuffer.CREATE()
 CALL errstring.append('<Row Table="'||table3e||'" Field="'||field3e||'" Data="'||data3e||'" Error="'||code3e||'" Desc="'||desc3e||'"/>')
 RETURN errstring.toString()
END FUNCTION
#*********************************************************
#********************************************************
FUNCTION GenerateECN(li_sep,li_rec_data,li_index,li_dateformat)
DEFINE l_fen           LIKE type_file.num5                    #若為１則更改單頭和單身若為2則更改單頭若為3則更改單身不更改單頭
DEFINE l_Operatecode   VARCHAR(20)               
DEFINE g_i             LIKE type_file.num5                  #自動分配單號的錯誤碼
DEFINE li_sep          STRING            #分隔字符
DEFINE li_index        LIKE type_file.num5 
DEFINE li_dateformat   STRING 
DEFINE l_errCode       STRING                      #用以返回錯誤碼，為ze_file中的錯誤碼
DEFINE l_errDesc       STRING                      #用以返回錯誤描述，若是系統中有的錯誤，則為錯誤代碼，如mfg0077，若非系統中的錯誤，則為詳細描述
DEFINE bBodyField  DYNAMIC ARRAY OF RECORD   #單身欄位
                     FIELD STRING
                   END RECORD,
       bBodyData   DYNAMIC ARRAY OF RECORD   #單身對應值
                     DATA STRING
                   END RECORD,
       l_checkID   DYNAMIC ARRAY OF RECORD   #標ID 對應傳入的記錄，若有單頭l_checkID[1].ID,其余為單身的ID 
                     ID   STRING
                   END RECORD
DEFINE bHeadField          STRING,
       bHeadData           STRING
DEFINE li_rec_data    DYNAMIC ARRAY OF RECORD
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
                  
 INITIALIZE g_bmb[1].* TO NULL
 INITIALIZE g_bma.* TO NULL
 INITIALIZE g_bma_o.* TO NULL
 INITIALIZE g_bmb_o.* TO NULL
 INITIALIZE g_bmx.* TO NULL
 INITIALIZE g_bmb_t.* TO NULL
 INITIALIZE g_bma_t.* TO NULL
 LET l_errCode = NULL
 LET l_errDesc = NULL
 
 LET bHeadField = li_rec_data[li_index].fields
 LET bHeadData = li_rec_data[li_index].data
 LET j=1
    WHILE NOT cl_null(li_rec_data[li_index].body[j].data)
       LET bBodyField[1].FIELD = li_rec_data[li_index].body[j].fields 
       LET bBodyData[j].DATA = li_rec_data[li_index].body[j].data
       LET j=j+1
    END WHILE
       
 CALL bmx_default()
##FUN-A10109 modify begin
###Add By chenzhong 20071008
## SELECT * INTO g_aza.* FROM aza_file WHERE aza01='0'
## IF SQLCA.SQLCODE THEN
##    LET g_ze.ze03 = cl_getmsg("aws-227", g_lang)
##    RETURN 'aws-227',g_ze.ze03
##   #RETURN 'aws-227','單別與單號碼數無設定，請到%1(aoos010)設定'
## END IF    
##   CASE g_aza.aza41                    
##      WHEN "1"   LET g_doc_len = 3      
##                 LET g_no_sp = 3 + 2     
##      WHEN "2"   LET g_doc_len = 4        
##                 LET g_no_sp = 4 + 2       
##      WHEN "3"   LET g_doc_len = 5          
##                 LET g_no_sp = 5 + 2         
##   END CASE                                   
##   CASE g_aza.aza42                            
##      WHEN "1"   LET g_no_ep = g_doc_len + 1 + 8
##      WHEN "2"   LET g_no_ep = g_doc_len + 1 + 9
##      WHEN "3"   LET g_no_ep = g_doc_len + 1 + 10
##   END CASE                      
     CALL s_doc_global_setting('ABM',g_plant)
##FUN-A10109 modify end
 
 CALL s_auto_assign_no("abm",g_bmx.bmx01,g_bmx.bmx02,"1","bmx_file","bmx01","","","") RETURNING g_i,g_bmx.bmx01 
#End Add
 IF NOT g_i THEN
    ROLLBACK WORK
    LET g_ze.ze03 = cl_getmsg("aws-263", g_lang)
    RETURN 'aws-263',g_ze.ze03
   #RETURN 'aws-226','ECN單號自動生成錯誤'
 END IF    
 LET l_headi=2
 LET l_fen=1
 CALL g_bmb.CLEAR()
 CALL bomInit(li_sep,bHeadField,bHeadData,bBodyField,bBodyData)
 
 #若無值
 IF g_bma.bma01 IS NULL AND g_bmb[1].bmb03 IS NULL THEN
    ROLLBACK WORK
    LET g_ze.ze03 = cl_getmsg("aws-264", g_lang)
    RETURN 'aws-264',g_ze.ze03
   #RETURN 'aws-226','主件料號為空且bmb03為空'
 END IF
 
 #若單頭無值
 IF g_bma.bma01 IS NULL AND NOT cl_null(g_bmb[1].bmb03) THEN
    LET l_fen=3
 END IF
 
 #若單身無值單頭有，只修改單頭
 IF g_bma.bma01 IS NOT NULL AND g_bmb[1].bmb03 IS NULL THEN
    LET l_fen=2
 END IF
 
#對調用UpdateBOM刪除的不予處理
#是否UpdateBom的管控END
 CASE l_fen
    WHEN 3       
       LET i=1
       WHILE NOT cl_null(g_bmb[i].bmb03)
       #FOR i=1 TO g_bmb.getLenth()
          IF NOT cl_null(g_bmb[i].bmb03) THEN
             SELECT * INTO g_bmb_o.* FROM bmb_file
              #WHERE bmb_pdm_rowi=g_bmb[i].bmb_pdm_rowi
              WHERE bmb01=g_bmb[i].bmb01 AND bmb03=g_bmb[i].bmb03    #Add By binbin080825
                AND (bmb04<=TODAY OR bmb04 IS NULL)   #Add By binbin080825
                AND (bmb05> TODAY OR bmb05 IS NULL)   #Add By binbin080825
             IF NOT cl_null(SQLCA.SQLCODE) THEN
                CASE SQLCA.SQLCODE
                   WHEN 100
                      LET g_bmy03_t='2'
                      LET g_bmb_t.* =g_bmb[i].*
                      CALL OperateEcn() RETURNING l_Operatecode,l_errcode            #新元件新增
                      IF cl_null(l_errcode) THEN
                         CALL adjustbmt() RETURNING l_errcode,l_errDesc
                      END IF
                      IF cl_null(l_Operatecode) THEN
                         LET i=i+1
                         CONTINUE WHILE
                         #CONTINUE FOR
                         #RETURN 0
                      ELSE
                      	 CALL errZhuhe("bmb_file",bBodyField[1].FIELD,bBodyData[i].DATA,l_errcode,"DB err!")
                      	 RETURNING l_errDesc
                      	 ROLLBACK WORK
                         RETURN 'aws-208',l_errDesc
                      END IF
                   OTHERWISE
                      CALL errZhuhe("bmb_file",bBodyField[1].FIELD,bBodyData[i].DATA,SQLCA.SQLCODE,"DB err!")
                      RETURNING l_errDesc
                      ROLLBACK WORK
                      RETURN 'aws-210',l_errDesc
                END CASE
             END IF
             LET g_bmy03_t='3'
             CALL CompareBomBody(g_bmb[i].*,g_bmb_o.*) RETURNING l_check                            #rowi在tiptop中存在，舊元件更改
             IF l_check==0 THEN
                LET i=i+1
                CONTINUE WHILE
                #CONTINUE FOR
             END IF
             CALL OperateEcn() RETURNING l_Operatecode,l_errcode
             IF cl_null(l_errcode) THEN
                CALL adjustbmt() RETURNING l_Operatecode,l_errcode 
             END IF
             #CALL OperateEcn()　RETURNING l_Operatecode,l_errcode          #利用全局g_bmb_t操作,此時其為更改后的值
             IF cl_null(l_Operatecode) THEN
                LET i=i+1
                CONTINUE WHILE
                #CONTINUE FOR
                #RETURN 0
             ELSE
             	  CALL errZhuhe("bmb_file",bBodyField[1].FIELD,bBodyData[i].DATA,l_errcode,"DB err!")
                RETURNING l_errDesc
                ROLLBACK WORK
                RETURN 'aws-210',l_errDesc
             END IF
          END IF
          LET i=i+1
       END WHILE
       #END FOR
       #若單頭未傳入，不操作                                           #舊元件失效
    WHEN 2
       IF NOT cl_null(g_bma.bma01) THEN
          SELECT * INTO g_bma_o.* FROM bma_file
           WHERE bma01=g_bma.bma01
          IF SQLCA.SQLCODE THEN
             CALL errZhuhe("bma_file",bHeadField,bHeadData,SQLCA.SQLCODE,"DB err!")
             RETURNING l_errDesc
             ROLLBACK WORK       
             RETURN 'aws-210',l_errDesc
          END IF
          CALL CompareBomHead(g_bma.*,g_bma_o.*) RETURNING l_check
          IF l_check==0 THEN
             RETURN 0,''
          END IF
          UPDATE bma_file SET bma_file.*=g_bma_t.*
          IF SQLCA.SQLCODE THEN
             CALL errZhuhe("bma_file",bHeadField,bHeadData,SQLCA.SQLCODE,"DB err!")
             RETURNING l_errDesc
             ROLLBACK WORK
             RETURN 'aws-210',l_errDesc
          ELSE
          	 RETURN 0,''
          END IF
       END IF
    WHEN 1
       WHILE TRUE
          IF NOT cl_null(g_bma.bma01) THEN
             SELECT * INTO g_bma_o.* FROM bma_file
              WHERE bma01=g_bma.bma01
             IF SQLCA.SQLCODE THEN
                CALL errZhuhe("bma_file",bHeadField,bHeadData,SQLCA.SQLCODE,"DB err!")
                RETURNING l_errDesc
                ROLLBACK WORK       
                RETURN 'aws-210',l_errDesc
             END IF
             CALL CompareBomHead(g_bma.*,g_bma_o.*) RETURNING l_check
             IF l_check==0 THEN
                EXIT WHILE
                #RETURN 0,''
             END IF
             #bom頭除主鍵外的小修改
             UPDATE bma_file SET bma02=g_bma_t.bma02,bma03=g_bma_t.bma03,
             bma04=g_bma_t.bma04,bma05=g_bma_t.bma05,bmauser=g_bma_t.bmauser,
             bmagrup=g_bma_t.bmagrup,bmamodu=g_bma_t.bmamodu,bmadate=g_bma_t.bmadate,
             bmaacti=g_bma_t.bmaacti
             WHERE bma01=g_bma_t.bma01
             IF SQLCA.SQLCODE THEN
                CALL errZhuhe("bma_file",bHeadField,bHeadData,SQLCA.SQLCODE,"DB err!")
                RETURNING l_errDesc
                ROLLBACK WORK       
                RETURN 'aws-210',l_errDesc
             ELSE
             	 EXIT WHILE
             	 #RETURN 0,''
             END IF
          END IF
       END WHILE
       LET i=1
       WHILE NOT cl_null(g_bmb[i].bmb03)
       #FOR i=1 TO g_bmb.getLenth()
          IF NOT cl_null(g_bmb[i].bmb03) THEN
             SELECT * INTO g_bmb_o.* FROM bmb_file
              #WHERE bmb_pdm_rowi=g_bmb[i].bmb_pdm_rowi
              WHERE bmb01=g_bmb[i].bmb01 AND bmb03=g_bmb[i].bmb03    #Add By binbin080825
                AND (bmb04<=TODAY OR bmb04 IS NULL)   #Add By binbin080825
                AND (bmb05> TODAY OR bmb05 IS NULL)   #Add By binbin080825
             IF SQLCA.SQLCODE THEN
                CASE SQLCA.SQLCODE
                   WHEN 100
                      LET g_bmy03_t='2'
                      LET g_bmb_t.* =g_bmb[i].*
                      CALL OperateEcn() RETURNING l_Operatecode,l_errcode            #新元件新增
                      IF cl_null(l_errcode) THEN
                         CALL adjustbmt() RETURNING l_Operatecode,l_errcode 
                      END IF
                      IF cl_null(l_Operatecode) THEN
                         LET i=i+1
                         CONTINUE WHILE
                         #CONTINUE FOR
                         #RETURN 0
                      ELSE
                      	 CALL errZhuhe("bmb_file",bBodyField[1].FIELD,bBodyData[i].DATA,l_errcode,"DB err!")
                         RETURNING l_errDesc
                         ROLLBACK WORK
                         RETURN 'aws-210',l_errDesc
                      END IF
                   OTHERWISE
                      CALL errZhuhe("bmb_file",bBodyField[1].FIELD,bBodyData[i].DATA,SQLCA.SQLCODE,"DB err!")
                      RETURNING l_errDesc
                      ROLLBACK WORK
                      RETURN 'aws-210',l_errDesc
                END CASE
             END IF
             LET g_bmy03_t='3'
             CALL CompareBomBody(g_bmb[i].*,g_bmb_o.*) RETURNING l_check  #rowi在tiptop中存在，舊元件更改
             IF l_check==0 THEN                                           
                LET i=i+1                                                 
                CONTINUE WHILE                                            
                #CONTINUE FOR                                             
             END IF                                                       
             CALL OperateEcn() RETURNING l_Operatecode,l_errcode          
             IF cl_null(l_errcode) THEN
                CALL adjustbmt() RETURNING l_Operatecode,l_errcode 
             END IF
             #CALL OperateEcn()　RETURN l_Operatecode,l_errcode           #利用全局g_bmb_t操作,此時其為更改后的值
             IF cl_null(l_Operatecode) THEN
                LET i=i+1
                CONTINUE WHILE
                #CONTINUE FOR
                #RETURN 0
             ELSE
             	  CALL errZhuhe("bmb_file",bBodyField[1].FIELD,bBodyData[i].DATA,l_errcode,"DB err!")
                RETURNING l_errDesc
                ROLLBACK WORK
                RETURN 'aws-210',l_errDesc
             END IF
          END IF
          LET i=i+1
       END WHILE
       #END FOR                            
       #舊元件失效
       #DECLARE bom1_curs CURSOR FOR SELECT bmb_pdm_rowi FROM bmb_file
       DECLARE bom1_curs CURSOR FOR SELECT bmb03 FROM bmb_file
                                    WHERE bmb01=g_bma.bma01
                                      AND (bmb04 IS NULL OR bmb04<=TODAY)   ##modify by chenzhong
                                      AND (bmb05 IS NULL OR bmb05 >TODAY)   ##modify by chenzhong
          LET i=1    ##by chenzhong 071011
       #FOREACH bom1_curs INTO g_bmb_pdm_rowi
       FOREACH bom1_curs INTO g_bmb_bmb03 
          LET l_check=1  
          LET i=1   ##by chenzhong 071011
          WHILE NOT cl_null(g_bmb[i].bmb03)
             #IF g_bmb[i].bmb_pdm_rowi=g_bmb_pdm_rowi THEN
             IF g_bmb[i].bmb03=g_bmb_bmb03 THEN
                LET l_check=0
                LET i=i+1  #Add By chenzhong 071011
                EXIT WHILE
             END IF
             LET i=i+1
          END WHILE
 
          IF l_check==1 THEN             #該bmb_pdm_rowi在數據庫中不存在
             LET g_bmy03_t='1'
             SELECT * INTO g_bmb_t.* FROM bmb_file
              #WHERE bmb_pdm_rowi = g_bmb_pdm_rowi
              WHERE bmb01=g_bma.bma01 AND bmb03=g_bmb_bmb03 
               AND (bmb04 IS NULL OR bmb04<=TODAY)   ##modify by chenzhong
               AND (bmb05 IS NULL OR bmb05 >TODAY)   ##modify by chenzhong
             CALL OperateEcn() RETURNING l_Operatecode,l_errcode
             IF cl_null(l_errcode) THEN
                CALL adjustbmt() RETURNING l_Operatecode,l_errcode 
             END IF
             IF cl_null(l_Operatecode) THEN
                 CONTINUE FOREACH
                 #RETURN 0
             ELSE
             	   CALL errZhuhe("bmb_file",bBodyField[1].FIELD,bBodyData[i].DATA,l_errcode,"DB err!")
                 RETURNING l_errDesc
                 ROLLBACK WORK
                 RETURN 'aws-210',l_errDesc
             END IF
          END IF
       END FOREACH
 END CASE
# COMMIT WORK
 RETURN l_errCode,l_errDesc
END FUNCTION
#************************************************************
#No.FUN-8A0122
