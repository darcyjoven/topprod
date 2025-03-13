# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Library name...: aws_mescli
# Descriptions...: MES Web Service Client 
# Input parameter: 
# Return code....: 
# Usage .........: 
# Date & Author..: No:FUN-870028 08/07/31 By sherry 
# Modify.........: No:FUN-8A0046 08/10/08 By duke MES整合
# Modify.........: No:TQC-8B0011 08/11/05 BY duke 呼叫MES前先判斷aza90必須MATCHE [Yy]
# Modify.........: No:FUN-910092 09/01/21 BY kevin MES 功能不需使用 zx10
# Modify.........: No:TQC-930057 09/03/06 BY DUKE 調整整合拋轉欄位
# Modify.........: No:FUN-950072 09/06/01 By Duke MES整合規格調整
# Modify.........: No:FUN-9A0056 09/06/11 By Duke 調整拋轉MES Stdqty = sfa161,倉庫名稱空白時以倉庫編號取代
# Modify.........: No:FUN-9A0056 09/10/20 By Lilan MES功能補強 
# Modify.........: No:FUN-9A0095 09/10/29 By Lilan MES功能補強
# Modify.........: No:FUN-9C0018 09/12/04 By Lilan MES取消結案/整批結案功能調整
# Modify.........: No:TQC-A10124 10/01/14 By Lilan 因應MES新增替代料件功能所做的調整
# Modify.........: No:FUN-B60041 11/06/07 By Abby MES BUG調整
# Modify.........: No:FUN-C10035 12/01/11 By Lilan 背景執行時(如:EF整合呼叫)不可彈窗

# Modify.........: No:FUN-D40103 13/05/09 By lixh1 增加儲位有效性檢查
#FUN-B70079
IMPORT com  

DATABASE ds

GLOBALS "../4gl/aws_mesgw.inc"
GLOBALS "../4gl/awsef.4gl"
GLOBALS "../../config/top.global"

DEFINE g_result_xml     om.DomNode
DEFINE g_request        om.DomNode
DEFINE g_snode          om.DomNode
DEFINE g_dnode          om.DomNode
DEFINE g_rnode          om.DomNode
DEFINE g_tnode          om.DomNode
DEFINE g_unode          om.DomNode
DEFINE g_vnode          om.DomNode
DEFINE g_wnode          om.DomNode
DEFINE g_xnode          om.DomNode
DEFINE g_req_doc        om.DomDocument
#DEFINE g_passwd         STRING                 #user password                #FUN-910092
DEFINE g_status         LIKE type_file.num10    #aws_mescli() return status
DEFINE g_messoap        STRING                  #MES SOAP URL
DEFINE g_meshttp        STRING                  #MES HTTP URL
DEFINE g_client         STRING                  #MES Client IP (TIPTOP Host)
DEFINE g_messiteip      STRING                  #MES Server IP
DEFINE g_result         STRING                  #MES result XML document
DEFINE g_result_value   STRING                  #MES result value in XML
DEFINE g_result_desc    STRING                  #MES result describe in XML
DEFINE g_ws_status      LIKE type_file.num10    #ws_status                    #No:TQC-760018 
DEFINE g_switch         LIKE type_file.num5
DEFINE g_action         STRING
DEFINE g_key1           LIKE ima_file.ima01
DEFINE g_key2           STRING                  #FUN-950072 ADD
DEFINE g_showmsg        LIKE type_file.num5
DEFINE g_sql            STRING                  #FUN-8A0046 add 
DEFINE g_prog2          STRING                  #FUN-9C0018 add

#------------------------------------------------------------------------------
# Library name...: aws_mescli
# Descriptions...: MES web service client
# Input Parameter: 
# Return code....: -2   Client error
#                  -1   MES return except
#                   0   MES return false
#                   1   MES return true
# Usage .........: call aws_mescli(p_prog,p_action,p_key) returing l_status
#------------------------------------------------------------------------------
FUNCTION aws_mescli(p_prog,p_action,p_key1)
    DEFINE p_prog          STRING
    DEFINE p_action        STRING
    DEFINE p_key1          STRING
    DEFINE l_status        LIKE type_file.num10
    
   #IF g_aza.aza90 <>'Y' THEN RETURN 0 END IF        #FUN-8A0046 add   #TQC-8B0011  MARK
    IF cl_null(g_aza.aza90) or g_aza.aza90<>'Y' THEN  RETURN 0 END IF   #TQC-8B0011  ADD 

    IF cl_null(g_user) THEN LET g_user='TP' END IF    #FUN-8A0046 add
    #FUN-8A0046---mark--str---
    #IF g_aza.aza90 matches '[ Nn]' OR g_aza.aza90 IS NULL THEN 
    #    CALL cl_err('','mfg3564',1)
    #    LET g_status = -2
    #    RETURN g_status
    #END IF
    #FUN-8A0046---mark--end---
		   
     CASE  WHEN  (p_prog='aimi100' AND p_action='insert' ) LET g_switch = 1
           WHEN  (p_prog='aimi100' AND p_action='update' ) LET g_switch = 1
           WHEN  (p_prog='aimi100' AND p_action='delete' ) LET g_switch = 2
           WHEN  (p_prog='axmi121' AND p_action='insert' ) LET g_switch = 3
           WHEN  (p_prog='axmi121' AND p_action='update' ) LET g_switch = 3
           WHEN  (p_prog='axmi121' AND p_action='delete' ) LET g_switch = 4
           WHEN  (p_prog='asfi301' AND p_action='insert' ) LET g_switch = 5  #工單新增
           WHEN  (p_prog='asfi301' AND p_action='delete' ) LET g_switch = 6  #工單刪除
           WHEN  (p_prog='asfi511' AND p_action='insert' ) LET g_switch = 7  #工單發料        
           WHEN  (p_prog='axmi221' AND p_action='insert' ) LET g_switch = 8
           WHEN  (p_prog='axmi221' AND p_action='update' ) LET g_switch = 8
           WHEN  (p_prog='axmi221' AND p_action='delete' ) LET g_switch = 9
           WHEN  (p_prog='aeci600' AND p_action='insert' ) LET g_switch = 10
           WHEN  (p_prog='aeci600' AND p_action='update' ) LET g_switch = 10
           WHEN  (p_prog='aeci600' AND p_action='delete' ) LET g_switch = 11
           WHEN  (p_prog='aimi200' AND p_action='insert' ) LET g_switch = 12
           WHEN  (p_prog='aimi200' AND p_action='update' ) LET g_switch = 12
           WHEN  (p_prog='aimi200' AND p_action='delete' ) LET g_switch = 13
           WHEN  (p_prog='aimi201' AND p_action='insert' ) LET g_switch = 14
           WHEN  (p_prog='aimi201' AND p_action='update' ) LET g_switch = 14
           WHEN  (p_prog='aimi201' AND p_action='delete' ) LET g_switch = 15
           WHEN  (p_prog='aooi030' AND p_action='insert' ) LET g_switch = 16
           WHEN  (p_prog='aooi030' AND p_action='update' ) LET g_switch = 16
           WHEN  (p_prog='aooi030' AND p_action='delete' ) LET g_switch = 17
          #FUN-9A0056 add begin ----------------------------------------------
           WHEN  (p_prog='aeci620' AND p_action='insert' ) LET g_switch = 18  
           WHEN  (p_prog='aeci620' AND p_action='update' ) LET g_switch = 18  
           WHEN  (p_prog='aeci620' AND p_action='delete' ) LET g_switch = 19  
           WHEN  (p_prog='aeci670' AND p_action='insert' ) LET g_switch = 20  
           WHEN  (p_prog='aeci670' AND p_action='update' ) LET g_switch = 20
           WHEN  (p_prog='aeci670' AND p_action='delete' ) LET g_switch = 21  
           WHEN  (p_prog='aeci650' AND p_action='insert' ) LET g_switch = 22
           WHEN  (p_prog='aeci650' AND p_action='update' ) LET g_switch = 22
           WHEN  (p_prog='aeci650' AND p_action='delete' ) LET g_switch = 23
           WHEN  (p_prog='apmi600' AND p_action='insert' ) LET g_switch = 24
           WHEN  (p_prog='apmi600' AND p_action='update' ) LET g_switch = 24
           WHEN  (p_prog='apmi600' AND p_action='delete' ) LET g_switch = 25
           WHEN  (p_prog='apmi254' AND p_action='insert' ) LET g_switch = 26
           WHEN  (p_prog='apmi254' AND p_action='update' ) LET g_switch = 26
           WHEN  (p_prog='apmi254' AND p_action='delete' ) LET g_switch = 27
           WHEN  (p_prog='apmi258' AND p_action='insert' ) LET g_switch = 26
           WHEN  (p_prog='apmi258' AND p_action='update' ) LET g_switch = 26
           WHEN  (p_prog='apmi258' AND p_action='delete' ) LET g_switch = 27
           WHEN  p_prog='asft803'                          LET g_switch = 28 #工單變更　　　
           WHEN  (p_prog='asfp400' OR p_prog='asfp401')    LET g_switch = 29 #工單結案/工單整批結案
          #FUN-9A0056 add end ----------------------------------------------

          #FUN-9A0095 add begin --------------------------------------------
           WHEN  p_prog='asfp410'                          LET g_switch = 30 #工單取消結案 
           WHEN  (p_prog='asfi511' AND p_action='delete' ) LET g_switch = 31 #工單取消發料 
           WHEN  (p_prog='asfi526' AND p_action='insert' ) LET g_switch = 32 #工單退料
           WHEN  (p_prog='asfi526' AND p_action='delete' ) LET g_switch = 33 #工單取消退料       
          #FUN-9A0095 add end ----------------------------------------------

           WHEN  (p_prog='asfi301' AND p_action='update' ) LET g_switch = 28 #工單異動  #TQC-A10124 add
          OTHERWISE LET g_switch=0
     END CASE 			   

   #FUN-950072 MOD --END--------------------------------------------------
    IF g_switch=0 THEN RETURN FALSE END IF
   #FUN-8A0046---mod---end---

    LET g_action = p_action
    LET g_key1    = p_key1
    LET g_key2    = p_key1     #FUN-950072 ADD
    LET g_showmsg = 1
    LET g_prog2   = p_prog     #FUN-9C0018 add

    CALL aws_mescli_1()
    RETURNING l_status
      
    RETURN l_status
END FUNCTION


FUNCTION aws_mescli_1()
    DEFINE buf             base.StringBuffer
    DEFINE l_str           STRING
    DEFINE l_status        LIKE type_file.num10
    DEFINE l_cnt           LIKE type_file.num10
    
    LET g_strXMLInput = NULL
    LET g_result_value = NULL 
    LET g_result_desc = NULL
    LET g_status = 1
    
    CALL aws_mescli_prepareRequest()
    IF g_status <= 0 THEN RETURN g_status END IF
     
    CASE 
    #FUN-950072 MOD --STR---------------------------------
     WHEN  g_switch=1 CALL aws_mescli_CreateMaterial()
     WHEN  g_switch=2 CALL aws_mescli_DelMaterial()
     WHEN  g_switch=3 CALL aws_mescli_CreateProduct()
     WHEN  g_switch=4 CALL aws_mescli_DelProduct()
    #WHEN  g_switch=5 CALL aws_mescli_CreateMO()         #FUN-9A0056 mark
    #WHEN  g_switch=6 CALL aws_mescli_CloseMO()          #FUN-9A0056 mark
     WHEN  g_switch=5 CALL aws_mescli_AddMO()            #FUN-9A0056 add
     WHEN  g_switch=6 CALL aws_mescli_DelMO()            #FUN-9A0056 add
     WHEN  g_switch=7 CALL aws_mescli_AddMaterial2MO()
     WHEN  g_switch=8 CALL aws_mescli_CreateCustomer()
     WHEN  g_switch=9 CALL aws_mescli_DelCustomer()
     WHEN  g_switch=10 CALL aws_mescli_CreateOperation()
     WHEN  g_switch=11 CALL aws_mescli_DelOperation()
     WHEN  g_switch=12 CALL aws_mescli_CreateInventory()
     WHEN  g_switch=13 CALL aws_mescli_DelInventory()
     WHEN  g_switch=14 CALL aws_mescli_CreateLocation()
     WHEN  g_switch=15 CALL aws_mescli_DelLocation()
     WHEN  g_switch=16 CALL aws_mescli_CreateDepartment()
     WHEN  g_switch=17 CALL aws_mescli_DelDepartment()
    #FUN-950072 MOD --END---------------------------------

    #FUN-9A0056 add begin ----------------------------   
     WHEN  g_switch=18 CALL aws_mescli_CreateOPGroup()  
     WHEN  g_switch=19 CALL aws_mescli_DelOPGroup()  
     WHEN  g_switch=20 CALL aws_mescli_CreateEquipment()
     WHEN  g_switch=21 CALL aws_mescli_DelEquipment()   
     WHEN  g_switch=22 CALL aws_mescli_CreateShift()
     WHEN  g_switch=23 CALL aws_mescli_DelShift()
     WHEN  g_switch=24 CALL aws_mescli_CreateVendor()
     WHEN  g_switch=25 CALL aws_mescli_DelVendor()
     WHEN  g_switch=26 CALL aws_mescli_CreateMaterialVendor()
     WHEN  g_switch=27 CALL aws_mescli_DelMaterialVendor()
     WHEN  g_switch=28 CALL aws_mescli_EditMO()
     WHEN  g_switch=29 CALL aws_mescli_CloseMO()
    #FUN-9A0056 add end   ----------------------------
    
    #FUN-9A0095 add begin ----------------------------
     WHEN  g_switch=30 CALL aws_mescli_UndoCloseMO()
     WHEN  g_switch=31 CALL aws_mescli_UndoAddMaterial2MO()
     WHEN  g_switch=32 CALL aws_mescli_ReturnMaterial2MO()
     WHEN  g_switch=33 CALL aws_mescli_UndoReturnMaterial2MO()
    #FUN-9A0095 add end   ----------------------------
    END CASE		
   #FUN-8A0046---modify---end--- 
    
    CALL aws_mescli_processRequest()
    
   #.. & . &amp; 
   #FUN-8A0046---mark---str---
   #LET buf = base.StringBuffer.create()
   #CALL buf.append(g_strXMLInput)
   #CALL buf.replace( "&","&amp;", 0)
   #LET g_strXMLInput = buf.toString()
   #FUN-8A0046---mark---end---

    LET g_strXMLInput = aws_xml_replace(g_strXMLInput)
   #LET mesService_soapServerLocation = g_messoap       #set Soap server location  #FUN-8A0046 mod
    LET mesService_wsERP_wsERPSoapLocation = g_messoap  #set Soap server location  #FUN-8A0046 mod
    CALL fgl_ws_setOption("http_invoketimeout", 60)     #set web service timeout
   #FUN-8A0046---mod---str---
   #CALL mesService_CreateMaterialData(g_strXMLInput)   
   #RETURNING l_status, g_result   

    CASE 
    #FUN-950072 MOD --STR-----------------------------
     WHEN  g_switch=1 CALL mesService_CreateMaterial(g_strXMLInput) RETURNING l_status, g_result
     WHEN  g_switch=2 CALL mesService_DelMaterial(g_strXMLInput) RETURNING l_status, g_result                                                  
     WHEN  g_switch=3 CALL mesService_CreateProduct(g_strXMLInput) RETURNING l_status, g_result                                                                          
     WHEN  g_switch=4 CALL mesService_DelProduct(g_strXMLInput) RETURNING l_status, g_result                                                                          
    #WHEN  g_switch=5 CALL mesService_CreateMO(g_strXMLInput) RETURNING l_status, g_result   #FUN-9A0056 mark
    #WHEN  g_switch=6 CALL mesService_CloseMO(g_strXMLInput) RETURNING l_status, g_result    #FUN-9A0056 mark                                                                                          
     WHEN  g_switch=5 CALL mesService_AddMO(g_strXMLInput) RETURNING l_status, g_result      #FUN-9A0056 add
     WHEN  g_switch=6 CALL mesService_DelMO(g_strXMLInput) RETURNING l_status, g_result      #FUN-9A0056 add      
     WHEN  g_switch=7 CALL mesService_AddMaterial2MO(g_strXMLInput) RETURNING l_status, g_result                                                                                              
     WHEN  g_switch=8 CALL mesService_CreateCustomer(g_strXMLInput) RETURNING l_status, g_result
     WHEN  g_switch=9 CALL mesService_DelCustomer(g_strXMLInput) RETURNING l_status, g_result                                                  
     WHEN  g_switch=10 CALL mesService_CreateOperation(g_strXMLInput) RETURNING l_status, g_result
     WHEN  g_switch=11 CALL mesService_DelOperation(g_strXMLInput) RETURNING l_status, g_result                                                  
     WHEN  g_switch=12 CALL mesService_CreateInventory(g_strXMLInput) RETURNING l_status, g_result
     WHEN  g_switch=13 CALL mesService_DelInventory(g_strXMLInput) RETURNING l_status, g_result                                                  
     WHEN  g_switch=14 CALL mesService_CreateLocation(g_strXMLInput) RETURNING l_status, g_result
     WHEN  g_switch=15 CALL mesService_DelLocation(g_strXMLInput) RETURNING l_status, g_result                                                  
     WHEN  g_switch=16 CALL mesService_CreateDepartment(g_strXMLInput) RETURNING l_status, g_result
     WHEN  g_switch=17 CALL mesService_DelDepartment(g_strXMLInput) RETURNING l_status, g_result                                                  
    #FUN-950072 MOD --END---------------------------------

    #FUN-9A0056 add begin---------------------------------- 
     WHEN  g_switch=18 CALL mesService_CreateOPGroup(g_strXMLInput) RETURNING l_status, g_result 
     WHEN  g_switch=19 CALL mesService_DelOPGroup(g_strXMLInput) RETURNING l_status, g_result    
     WHEN  g_switch=20 CALL mesService_CreateEquipment(g_strXMLInput) RETURNING l_status, g_result
     WHEN  g_switch=21 CALL mesService_DelEquipment(g_strXMLInput) RETURNING l_status, g_result
     WHEN  g_switch=22 CALL mesService_CreateShift(g_strXMLInput) RETURNING l_status, g_result
     WHEN  g_switch=23 CALL mesService_DelShift(g_strXMLInput) RETURNING l_status, g_result
     WHEN  g_switch=24 CALL mesService_CreateVendor(g_strXMLInput) RETURNING l_status, g_result
     WHEN  g_switch=25 CALL mesService_DelVendor(g_strXMLInput) RETURNING l_status, g_result
     WHEN  g_switch=26 CALL mesService_CreateMaterialVendor(g_strXMLInput) RETURNING l_status, g_result
     WHEN  g_switch=27 CALL mesService_DelMaterialVendor(g_strXMLInput) RETURNING l_status, g_result
     WHEN  g_switch=28 CALL mesService_EditMO(g_strXMLInput) RETURNING l_status, g_result
     WHEN  g_switch=29 CALL mesService_CloseMO(g_strXMLInput) RETURNING l_status, g_result
    #FUN-9A0056 add end  ---------------------------------- 

    #FUN-9A0095 add begin----------------------------------
     WHEN  g_switch=30 CALL mesService_UndoCloseMO(g_strXMLInput) RETURNING l_status, g_result
     WHEN  g_switch=31 CALL mesService_UndoAddMaterial2MO(g_strXMLInput) RETURNING l_status, g_result
     WHEN  g_switch=32 CALL mesService_ReturnMaterial2MO(g_strXMLInput) RETURNING l_status, g_result
     WHEN  g_switch=33 CALL mesService_UndoReturnMaterial2MO(g_strXMLInput) RETURNING l_status, g_result
    #FUN-9A0095 add end  ----------------------------------
    END CASE

    LET g_ws_status = l_status 
    
    CALL aws_mescli_logfile()

    IF l_status = 0 THEN
        CALL aws_mescli_processResult(g_showmsg)
    ELSE
      IF fgl_getenv('FGLGUI') = '1' THEN
         LET l_str = "Connection failed:\n\n", 
                     "  [Code]: ", wsError.code, "\n",
                     "  [Action]: ", wsError.action, "\n",
                     "  [Description]: ", wsError.description
      ELSE
         LET l_str = "Connection failed: ", wsError.description
      END IF

      IF g_bgjob='N' OR cl_null(g_bgjob) THEN   #FUN-C10035 add
         CALL cl_err(l_str, '!', 1)   #connection failed
     #FUN-C10035 add str ----
      ELSE
         CALL cl_err(l_str, '!',0)
      END IF
     #FUN-C10035 add end ----
      LET g_status = -2
      RETURN g_status
    END IF
    RETURN g_status

END FUNCTION

#------------------------------------------------------------------------------
# Generate XML Request Header
#------------------------------------------------------------------------------
FUNCTION aws_mescli_prepareRequest()
    DEFINE l_code      LIKE type_file.num5     
    DEFINE l_sendtime  LIKE type_file.chr30      #FUN-8A0046 add
    DEFINE l_transid   LIKE type_file.chr30      #FUN-8A0046 add
    DEFINE l_today     LIKE type_file.chr30      #FUN-8A0046 add
    DEFINE l_time      LIKE type_file.chr30      #FUN-8A0046 add 
    
    CALL aws_mescli_siteinfo() RETURNING l_code
    
    IF l_code = 0 THEN
       LET g_status = -2
       RETURN
    END IF
    
   #FUN-8A0046---add---str---
    IF cl_null(g_user) THEN LET g_user ='TP' END IF 

    LET l_sendtime = TODAY USING 'yyyy/mm/dd',' ',TIME   

    LET l_transid  = CURRENT HOUR TO FRACTION(2)
    LET l_transid  = cl_replace_str(l_transid,':','')   
    LET l_transid  = cl_replace_str(l_transid,'.','')   
    LET l_transid  = TODAY USING 'yyyymmdd',cl_replace_str(l_transid,':','')   

    LET g_strXMLInput =                           #組 XML Header
        "<request>", ASCII 10,
        " <identity>", ASCII 10,
        "   <transactionid>", l_transid CLIPPED, "</transactionid>", ASCII 10,
        "   <moduleid>TP</moduleid>", ASCII 10,
        "   <functionid>SI</functionid>", ASCII 10,
        "   <computername>MES01</computername>", ASCII 10,
        "   <curuserno>", g_user CLIPPED, "</curuserno>", ASCII 10,
        "   <sendtime>", l_sendtime CLIPPED, "</sendtime>", ASCII 10,
        " </identity>", ASCII 10,
        " <parameter>", ASCII 10

   #FUN-8A0046---mark---str---
   #LET g_req_doc = om.DomDocument.create('Request')
   #LET g_rnode = g_req_doc.getDocumentElement()

   #LET g_snode = g_rnode.createChild('Access')
   #LET g_tnode = g_snode.createChild('Authentication')
   #CALL g_tnode.setAttribute('user', 'tiptop')
   #CALL g_tnode.setAttribute('password', 'tiptop')
   #LET g_tnode = g_snode.createChild('Connection')
   #CALL g_tnode.setAttribute('application', 'TIPTOP')
   #CALL g_tnode.setAttribute('source', '127.0.0.1')
   #LET g_tnode = g_snode.createChild('Organization')
   #CALL g_tnode.setAttribute('name', g_plant)
   #LET g_tnode = g_snode.createChild('Locale')
   #CALL g_tnode.setAttribute('language', 'zh_tw')

   #LET g_snode = g_rnode.createChild('RequestContent')
   #LET g_tnode = g_snode.createChild('Parameter')
   #LET g_unode = g_tnode.createChild('Record')

   #LET g_vnode = g_unode.createChild('Field')
   #CALL g_vnode.setAttribute('name', 'action')
   #CALL g_vnode.setAttribute('value', g_action)
   #LET g_tnode = g_snode.createChild('Document')
   #LET g_unode = g_tnode.createChild('RecordSet')
   #CALL g_unode.setAttribute('id', '1')
   #FUN-8A0046---mark---str---
   
END FUNCTION


#FUN-8A0046---add---str---
#------------------------------------------------------------------------------
# Generate XML Request Body 
#------------------------------------------------------------------------------
FUNCTION aws_mescli_AddMaterial()

   DEFINE l_ima         RECORD LIKE ima_file.*
   DEFINE l_xmlbody     STRING
   DEFINE l_i           LIKE type_file.num5

   LET g_sql = " SELECT * FROM ima_file ",
               "  WHERE ima01 = '",g_key1,"'" 
   PREPARE xml_pb1 FROM g_sql
   DECLARE xml_curs1
       CURSOR WITH HOLD FOR xml_pb1
   LET l_i = 1
   FOREACH xml_curs1 INTO l_ima.*
    
   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <materialno>", ASCII 10,
        "    <name>MaterialNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ima.ima01 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </materialno>", ASCII 10,
        "  <materialtype>", ASCII 10,
        "    <name>MaterialType</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
       #"    <value>", l_ima.ima109 CLIPPED, "</value>", ASCII 10, #TQC-930057 MARK
       "    <value></value>", ASCII 10,                            #TQC-930057 ADD
        "    <desc></desc>", ASCII 10,
        "  </materialtype>", ASCII 10,
        "  <materialname>", ASCII 10,
        "    <name>MaterialName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ima.ima02 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </materialname>", ASCII 10,
        "  <materialspec>", ASCII 10,
        "    <name>MaterialSpec</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ima.ima021 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </materialspec>", ASCII 10,
        "  <unitno>", ASCII 10,
        "    <name>UnitNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        #"    <value>", l_ima.ima25 CLIPPED, "</value>", ASCII 10, #TQC-930057 MARK
        "    <value>", l_ima.ima63 CLIPPED, "</value>", ASCII 10,  #TQC-930057 ADD
        "    <desc></desc>", ASCII 10,
        "  </unitno>", ASCII 10,
        "  <creator>", ASCII 10,
        "    <name>Creator</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", g_user CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </creator>", ASCII 10 
   END FOREACH
   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION


FUNCTION aws_mescli_EditMaterial()

   DEFINE l_ima         RECORD LIKE ima_file.*
   DEFINE l_xmlbody     STRING
   DEFINE l_i           LIKE type_file.num5

   LET g_sql = " SELECT * FROM ima_file ",
               "  WHERE ima01 = '",g_key1,"'" 
   PREPARE xml_pb2 FROM g_sql
   DECLARE xml_curs2
       CURSOR WITH HOLD FOR xml_pb2
   LET l_i = 1
   FOREACH xml_curs2 INTO l_ima.*
    
   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <materialno>", ASCII 10,
        "    <name>MaterialNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ima.ima01 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </materialno>", ASCII 10,
        "  <materialtype>", ASCII 10,
        "    <name>MaterialType</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        #"    <value>", l_ima.ima109 CLIPPED, "</value>", ASCII 10,  #TQC-930057 MARK
        "    <value></value>", ASCII 10,                            #TQC-930057 ADD
        "    <desc></desc>", ASCII 10,
        "  </materialtype>", ASCII 10,
        "  <materialname>", ASCII 10,
        "    <name>MaterialName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ima.ima02 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </materialname>", ASCII 10,
        "  <materialspec>", ASCII 10,
        "    <name>MaterialSpec</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ima.ima021 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </materialspec>", ASCII 10,
        "  <unitno>", ASCII 10,
        "    <name>UnitNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        #"    <value>", l_ima.ima25 CLIPPED, "</value>", ASCII 10, #TQC-930057 MARK
        "    <value>", l_ima.ima63 CLIPPED, "</value>", ASCII 10,  #TQC-930057 ADD
        "    <desc></desc>", ASCII 10,
        "  </unitno>", ASCII 10 
   END FOREACH
   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10
END FUNCTION 

#FUN-9A0095 add begin -----------------
#取消工單結案
FUNCTION aws_mescli_UndoCloseMO()
  DEFINE l_xmlbody     STRING
  DEFINE l_sfb01       LIKE sfb_file.sfb01               #工單編號                #FUN-9C0018 add
  DEFINE l_sfbstr      STRING                            #工單編號的集合字串      #FUN-9C0018 add
  DEFINE tok           base.StringTokenizer              #依分隔符號拆解字串      #FUN-9C0018 add

  LET l_sfbstr = g_key2.substring(1,g_key2.getlength()-1)    #去除最後一碼的分隔符號  #FUN-9C0018 add
  LET tok = base.StringTokenizer.create(l_sfbstr,",")

  WHILE tok.hasMoreTokens()                                      #FUN-9C0018 add
    LET l_sfb01 = tok.nextToken()                                #FUN-9C0018 add

    LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
         "  <mono>", ASCII 10,
         "    <name>MONo</name>", ASCII 10,
         "    <type>String</type>", ASCII 10,
        #"    <value>", g_key1 CLIPPED, "</value>", ASCII 10,    #FUN-9C0018 mark
         "    <value>", l_sfb01 CLIPPED, "</value>", ASCII 10,   #FUN-9C0018 add
         "    <desc></desc>", ASCII 10,
         "  </mono>", ASCII 10
  END WHILE                                                      #FUN-9C0018 add

  LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                    " </parameter>", ASCII 10,
                    "</request>", ASCII 10


END FUNCTION
#FUN-9A0095 add end -------------------


#FUN-950072 ADD --STR----------------------
FUNCTION aws_mescli_CreateMaterial()
   DEFINE l_ima         RECORD LIKE ima_file.*
   DEFINE l_xmlbody     STRING
   DEFINE l_i           LIKE type_file.num5

   LET g_sql = " SELECT * FROM ima_file ",
               "  WHERE ima01 = '",g_key1,"'" 
   PREPARE xml_pb01 FROM g_sql
   DECLARE xml_curs01
       CURSOR WITH HOLD FOR xml_pb01
   LET l_i = 1
   FOREACH xml_curs01 INTO l_ima.*
    
   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <materialno>", ASCII 10,
        "    <name>MaterialNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ima.ima01 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </materialno>", ASCII 10,
        "  <materialtype>", ASCII 10,
        "    <name>MaterialType</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value></value>", ASCII 10, 
        "    <desc></desc>", ASCII 10,
        "  </materialtype>", ASCII 10,
        "  <materialname>", ASCII 10,
        "    <name>MaterialName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ima.ima02 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </materialname>", ASCII 10,
        "  <materialspec>", ASCII 10,
        "    <name>MaterialSpec</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ima.ima021 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </materialspec>", ASCII 10,
        "  <unitno>", ASCII 10,
        "    <name>UnitNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ima.ima63 CLIPPED, "</value>", ASCII 10, 
        "    <desc></desc>", ASCII 10,
        "  </unitno>", ASCII 10,
        "  <creator>", ASCII 10,
        "    <name>Creator</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", g_user CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </creator>", ASCII 10 
   END FOREACH
   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION
#FUN-950072 ADD --END----------------------	 

FUNCTION aws_mescli_DelMaterial()

   DEFINE l_ima         RECORD LIKE ima_file.*
   DEFINE l_xmlbody     STRING
   DEFINE l_i           LIKE type_file.num5

   LET g_sql = " SELECT * FROM ima_file ",
               "  WHERE ima01 = '",g_key1,"'" 
   PREPARE xml_pb3 FROM g_sql
   DECLARE xml_curs3
       CURSOR WITH HOLD FOR xml_pb3
   LET l_i = 1
   FOREACH xml_curs3 INTO l_ima.*
    
   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <materialno>", ASCII 10,
        "    <name>MaterialNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        #"    <value>", l_ima.ima01 CLIPPED, "</value>", ASCII 10,	 #FUN-950072 MARK
         "    <value>", g_key1 CLIPPED, "</value>", ASCII 10,        #FUN-950072 ADD
        "    <desc></desc>", ASCII 10,
        "  </materialno>", ASCII 10
   END FOREACH
   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION 

FUNCTION aws_mescli_AddProduct()

   DEFINE l_ima         RECORD LIKE ima_file.*
   DEFINE l_xmlbody     STRING
   DEFINE l_i           LIKE type_file.num5

   LET g_sql = " SELECT * FROM ima_file ",
               "  WHERE ima01 = '",g_key1,"'" 
   PREPARE xml_pb4 FROM g_sql
   DECLARE xml_curs4
       CURSOR WITH HOLD FOR xml_pb4
   LET l_i = 1
   FOREACH xml_curs4 INTO l_ima.*
    
   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <productno>", ASCII 10,
        "    <name>ProductNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ima.ima01 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </productno>", ASCII 10,
        "  <productversion>", ASCII 10,
        "    <name>ProductVersion</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>1</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </productversion>", ASCII 10,
        "  <productname>", ASCII 10,
        "    <name>ProductName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ima.ima02 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </productname>", ASCII 10,
        "  <producttype>", ASCII 10,
        #"    <name>MaterialSpec</name>", ASCII 10,  #TQC-930057 MARK
        "    <name>ProductType</name>", ASCII 10,  #TQC-930057 ADD
        "    <type>String</type>", ASCII 10,
        #"    <value>", l_ima.ima131 CLIPPED, "</value>", ASCII 10, #TQC-930057 MARK
        "    <value></value>", ASCII 10, #TQC-930057 ADD
        "    <desc></desc>", ASCII 10,
        "  </producttype>", ASCII 10,
        "  <unitno>", ASCII 10,
        "    <name>UnitNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        #"    <value>", l_ima.ima25 CLIPPED, "</value>", ASCII 10, #TQC-930057 MARK
        "    <value>", l_ima.ima55 CLIPPED, "</value>", ASCII 10,  #TQC-930057 ADD
        "    <desc></desc>", ASCII 10,
        "  </unitno>", ASCII 10, 
        "  <specno>", ASCII 10,
        "    <name>SpecNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>N/A</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </specno>", ASCII 10, 
        "  <creator>", ASCII 10,
        "    <name>Creator</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", g_user CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </creator>", ASCII 10 
   END FOREACH
   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION

FUNCTION aws_mescli_EditProduct()

   DEFINE l_ima         RECORD LIKE ima_file.*
   DEFINE l_xmlbody     STRING
   DEFINE l_i           LIKE type_file.num5

   LET g_sql = " SELECT * FROM ima_file ",
               "  WHERE ima01 = '",g_key1,"'" 
   PREPARE xml_pb5 FROM g_sql
   DECLARE xml_curs5
       CURSOR WITH HOLD FOR xml_pb5
   LET l_i = 1
   FOREACH xml_curs5 INTO l_ima.*
    
   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <productno>", ASCII 10,
        "    <name>ProductNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ima.ima01 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </productno>", ASCII 10,
        "  <productname>", ASCII 10,
        "    <name>ProductName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ima.ima02 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </productname>", ASCII 10
   END FOREACH
   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION

#FUN-950072 ADD --STR---------------------------
FUNCTION aws_mescli_CreateProduct()

   DEFINE l_ima         RECORD LIKE ima_file.*
   DEFINE l_xmlbody     STRING
   DEFINE l_i           LIKE type_file.num5

   LET g_sql = " SELECT * FROM ima_file ",
               "  WHERE ima01 = '",g_key1,"'" 
   PREPARE xml_pb02 FROM g_sql
   DECLARE xml_curs02
       CURSOR WITH HOLD FOR xml_pb02
   LET l_i = 1
   FOREACH xml_curs02 INTO l_ima.*
    
   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <productno>", ASCII 10,
        "    <name>ProductNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ima.ima01 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </productno>", ASCII 10,
        "  <productversion>", ASCII 10,
        "    <name>ProductVersion</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>1</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </productversion>", ASCII 10,
        "  <productname>", ASCII 10,
        "    <name>ProductName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ima.ima02 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </productname>", ASCII 10,
        "  <producttype>", ASCII 10,
        "    <name>ProductType</name>", ASCII 10,  
        "    <type>String</type>", ASCII 10,
        "    <value></value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </producttype>", ASCII 10,
        "  <unitno>", ASCII 10,
        "    <name>UnitNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ima.ima55 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </unitno>", ASCII 10, 
        "  <specno>", ASCII 10,
        "    <name>SpecNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>N/A</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </specno>", ASCII 10, 
        "  <creator>", ASCII 10,
        "    <name>Creator</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", g_user CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </creator>", ASCII 10 
   END FOREACH
   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION
#FUN-950072 ADD --END---------------------------

FUNCTION aws_mescli_DelProduct()

   DEFINE l_ima         RECORD LIKE ima_file.*
   DEFINE l_xmlbody     STRING
   DEFINE l_i           LIKE type_file.num5

   LET g_sql = " SELECT * FROM ima_file ",
               "  WHERE ima01 = '",g_key1,"'" 
   PREPARE xml_pb6 FROM g_sql
   DECLARE xml_curs6
       CURSOR WITH HOLD FOR xml_pb6
   LET l_i = 1
   FOREACH xml_curs6 INTO l_ima.*
    
   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <productno>", ASCII 10,
        "    <name>ProductNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ima.ima01 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </productno>", ASCII 10,
#FUN-950072 ADD --STR--------------------------
        "  <productversion>", ASCII 10, 
        "     <name>ProductVersion</name>", ASCII 10,
        "     <type>String</type>", ASCII 10,
        "     <value>1</value>", ASCII 10,
        "     <desc></desc>", ASCII 10,
        "  </productversion>", ASCII 10
#FUN-950072 ADD --END------------------------											  
   END FOREACH
   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION

#TIPTOP:確認(發放)工單 → MES:新增工單
FUNCTION aws_mescli_AddMO()

    DEFINE l_xmlbody     STRING
    DEFINE l_xmlbody1    STRING
    DEFINE l_sfb         RECORD LIKE sfb_file.*
    DEFINE l_sfa         RECORD LIKE sfa_file.*
    DEFINE l_i           LIKE type_file.num5
    DEFINE l_j           LIKE type_file.num5
    DEFINE l_oea03       LIKE oea_file.oea03
    DEFINE l_ima08       LIKE ima_file.ima08
    DEFINE l_ima55       LIKE ima_file.ima55
    DEFINE l_putintype   LIKE type_file.chr1
    DEFINE l_motype      LIKE type_file.num5
    DEFINE l_materiallevel LIKE type_file.num5   #TQC-930057 ADD 
  #HEAD
   LET g_sql = " SELECT * FROM sfb_file ",
               "  WHERE sfb01 = '",g_key1,"'" 
   PREPARE xml_pb7 FROM g_sql
   DECLARE xml_curs7
       CURSOR WITH HOLD FOR xml_pb7
 
  #Detail 
   LET g_sql = " SELECT * FROM sfa_file ",
               "  WHERE sfa01 = '",g_key1,"'"
   PREPARE xml_sfa FROM g_sql
   DECLARE xml_curs_sfa
       CURSOR WITH HOLD FOR xml_sfa

   LET l_i = 1
   FOREACH xml_curs7 INTO l_sfb.*

   LET l_oea03='' 
   SELECT UNIQUE(oea03) INTO l_oea03 FROM oea_file,oeb_file 
    WHERE oea01=oeb01 
      AND oea01=l_sfb.sfb22
      AND oeb03=l_sfb.sfb221
              
   LET l_ima55='' 
   SELECT ima55 INTO l_ima55 FROM ima_file
    WHERE ima01=l_sfb.sfb05 

   IF l_sfb.sfb02=1  THEN LET l_motype=0 END IF
   IF l_sfb.sfb02=5  THEN LET l_motype=1 END IF
   IF l_sfb.sfb02=15 THEN LET l_motype=2 END IF
 
   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <mono>", ASCII 10,
        "    <name>MONo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_sfb.sfb01 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </mono>", ASCII 10,
        "  <rono>", ASCII 10,
        "    <name>RONo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_sfb.sfb22 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </rono>", ASCII 10,
        "  <itemno>", ASCII 10,
        "    <name>ItemNo</name>", ASCII 10,
        "    <type>Numeric</type>", ASCII 10,
        "    <value>", l_sfb.sfb221 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </itemno>", ASCII 10,
        "  <customerno>", ASCII 10,
        "    <name>CustomerNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_oea03 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </customerno>", ASCII 10,
        "  <factoryno>", ASCII 10,
        "    <name>FactoryNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", g_plant CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </factoryno>", ASCII 10,
        "  <moqty>", ASCII 10,
        "    <name>MOQty</name>", ASCII 10,
        "    <type>Numeric</type>", ASCII 10,
        "    <value>",l_sfb.sfb08,"</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </moqty>", ASCII 10,
        "  <productno>", ASCII 10,
        "    <name>ItemNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_sfb.sfb05 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </productno>", ASCII 10,
        "  <motypeno>", ASCII 10,
        "    <name>MOTypeNo</name>", ASCII 10,
        "    <type>Numeric</type>", ASCII 10,
        #"    <value>",l_motype,"</value>", ASCII 10,   #TQC-930057 MARK
        "    <value>", l_sfb.sfb02 CLIPPED, "</value>", ASCII 10,  #TQC-930057 ADD
        "    <desc></desc>", ASCII 10,
        "  </motypeno>", ASCII 10,

        #TQC-930057 MARK  --STR--
        #"  <priority>", ASCII 10,
        #"    <name>Priority</name>", ASCII 10,
        #"    <type>Numeric</type>", ASCII 10,
        #"    <value>1</value>", ASCII 10,
        #"    <desc></desc>", ASCII 10,
        #"  </priority>", ASCII 10,
        #TQC-930057 MARK  --END--

        "  <planfinishdate>", ASCII 10,
        "    <name>PlanFinishDate</name>", ASCII 10,
        "    <type>Date</type>", ASCII 10,
        "    <value>", l_sfb.sfb15, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </planfinishdate>", ASCII 10,
        "  <mounitno>", ASCII 10,
        "    <name>MOUnitNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ima55 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </mounitno>", ASCII 10,
       #"  < property >", ASCII 10,             #屬性資料:標準整合時用不到，保留給客製項目使用
       #"  </property >", ASCII 10,
        "  <creator>", ASCII 10,
        "    <name>Creator</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", g_user CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </creator>", ASCII 10, 
        "  <momateriallist>", ASCII 10,
        "    <name>MOMaterialList</name>", ASCII 10,
        "    <type>String</type>", ASCII 10

       LET l_j = 1
       FOREACH xml_curs_sfa INTO l_sfa.*
        
       LET l_ima08='' 
       LET l_putintype=''

       SELECT ima08 INTO l_ima08 FROM ima_file WHERE ima01=l_sfa.sfa03  #FUN-9A0095 add 
 
       IF l_ima08='P' THEN 
          LET l_materiallevel=0
       ELSE 
          LET l_materiallevel=1
       END IF

      #TQC-A10124 mark ---預設值=3
      #IF l_ima08='M' THEN 
      #   LET l_putintype='1' 
      #ELSE 
          LET l_putintype='3' 
      #END IF 

      #TQC-A10124 add str ---
      #取得原BOM的替代比率(標準用量)
       IF l_sfa.sfa26 MATCHES '[SU]' THEN
          LET l_sfa.sfa161 = 1                      #替代比率給予預設值=1
          SELECT bmd07 INTO l_sfa.sfa161 FROM bmd_file
           WHERE bmd08 = l_sfb.sfb05                #主件編號
             AND bmd04 = l_sfa.sfa03                #發料(替代)編號
             AND bmd01 = l_sfa.sfa27                #原BOM料號
       END IF
      #TQC-A10124 add end ---

       IF cl_null(l_sfa.sfa08) THEN LET l_sfa.sfa08=' ' END IF  
      
       LET l_xmlbody1 = l_xmlbody1 CLIPPED,
            "    <value>", ASCII 10,
           #"      <materialno>", l_sfa.sfa03 CLIPPED, "</materialno>", ASCII 10,      #TQC-A10124 mark
            "      <materialno>", l_sfa.sfa27 CLIPPED, "</materialno>", ASCII 10,      #BOM料號    #TQC-A10124 add
           #"      <materialtype></materialtype>", ASCII 10,                           #TQC-930057 MARK
           #"      <materiallevel>0</materiallevel>", ASCII 10,                        #TQC-930057 MARK
            "      <materiallevel>",l_materiallevel,"</materiallevel>", ASCII 10,      #TQC-930057 MARK         
            "      <stdqty>", l_sfa.sfa161 , "</stdqty>", ASCII 10,                    #TQC-930057 MARK  #FUN-9A0056 UNMARK
           #"      <stdqty>", l_sfa.sfa05 , "</stdqty>", ASCII 10,                     #TQC-930057 ADD   #FUN-9A0056 MARK
            "      <unitno>", l_sfa.sfa12 CLIPPED, "</unitno>", ASCII 10,
            "      <opno>", l_sfa.sfa08 CLIPPED, "</opno>", ASCII 10,
            "      <putinplacetype>", l_putintype CLIPPED, "</putinplacetype>", ASCII 10,  
            "      <substitutematerialno>", l_sfa.sfa03 CLIPPED, "</substitutematerialno>", ASCII 10,  #替代料物料編號 #TQC-A10124 add
            "     </value>", ASCII 10
           LET l_j = l_j + 1
       END FOREACH

       LET l_i = l_i + 1
   END FOREACH

   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, l_xmlbody1 CLIPPED, ASCII 10,
                     "  </momateriallist>", ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION

#TIPTOP:取消(發放)工單 → MES:取消工單發放
FUNCTION aws_mescli_DelMO()

   DEFINE l_xmlbody     STRING
   DEFINE l_sfb         RECORD LIKE sfb_file.*
   DEFINE l_sfa         RECORD LIKE sfa_file.*
   DEFINE l_i           LIKE type_file.num5
   DEFINE l_j           LIKE type_file.num5

  LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
       "  <mono>", ASCII 10,
       "    <name>MONo</name>", ASCII 10,
       "    <type>String</type>", ASCII 10,
       "    <value>", g_key1 CLIPPED, "</value>", ASCII 10,
       "    <desc></desc>", ASCII 10,
       "  </mono>", ASCII 10

  LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                    " </parameter>", ASCII 10,
                    "</request>", ASCII 10

END FUNCTION


#TIPTOP / MES:工單變更
FUNCTION aws_mescli_EditMO()

   DEFINE l_xmlbody     STRING
   DEFINE l_xmlbody1    STRING
   DEFINE l_sfb         RECORD LIKE sfb_file.*   #單頭
   DEFINE l_sfa         RECORD LIKE sfa_file.*   #單身
   DEFINE l_i           LIKE type_file.num5
   DEFINE l_j           LIKE type_file.num5
   DEFINE l_oea03       LIKE oea_file.oea03
   DEFINE l_ima08       LIKE ima_file.ima08
   DEFINE l_ima55       LIKE ima_file.ima55
   DEFINE l_putintype   LIKE type_file.chr1
   DEFINE l_motype      LIKE type_file.num5
   DEFINE l_materiallevel LIKE type_file.num5   #TQC-930057 ADD

   LET g_sql = " SELECT * FROM sfb_file ",
               "  WHERE sfb01 = '",g_key1,"'" 
   PREPARE xml_pb8 FROM g_sql
   DECLARE xml_curs8
       CURSOR WITH HOLD FOR xml_pb8
 
  #Detail 
   LET g_sql = " SELECT * FROM sfa_file ",
               "  WHERE sfa01 = '",g_key1,"'"
   PREPARE xml_sfa1 FROM g_sql
   DECLARE xml_curs_sfa1
       CURSOR WITH HOLD FOR xml_sfa1

   LET l_i = 1
   FOREACH xml_curs8 INTO l_sfb.*

   LET l_oea03='' 
   SELECT UNIQUE(oea03) INTO l_oea03 FROM oea_file,oeb_file 
    WHERE oea01=oeb01 
      AND oea01=l_sfb.sfb22
      AND oeb03=l_sfb.sfb221

   LET l_ima55='' 
   SELECT ima55 INTO l_ima55 FROM ima_file
    WHERE ima01=l_sfb.sfb05 
              
   IF l_sfb.sfb02=1  THEN LET l_motype=0 END IF
   IF l_sfb.sfb02=5  THEN LET l_motype=1 END IF
   IF l_sfb.sfb02=15 THEN LET l_motype=2 END IF

   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <mono>", ASCII 10,
        "    <name>MONo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_sfb.sfb01 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </mono>", ASCII 10,
        "  <rono>", ASCII 10,
        "    <name>RONo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_sfb.sfb22 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </rono>", ASCII 10,
        "  <itemno>", ASCII 10,
        "    <name>ItemNo</name>", ASCII 10,
        "    <type>Numeric</type>", ASCII 10,
        "    <value>", l_sfb.sfb221 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </itemno>", ASCII 10,
        "  <customerno>", ASCII 10,
        "    <name>CustomerNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_oea03 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </customerno>", ASCII 10,
        "  <moqty>", ASCII 10,
        "    <name>MOQty</name>", ASCII 10,
        "    <type>Numeric</type>", ASCII 10,
        "    <value>",l_sfb.sfb08,"</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </moqty>", ASCII 10,
        "  <motypeno>", ASCII 10,
        "    <name>MOTypeNo</name>", ASCII 10,
        "    <type>Numeric</type>", ASCII 10,
        "    <value>",l_sfb.sfb02,"</value>", ASCII 10,  
        "    <desc></desc>", ASCII 10,
        "  </motypeno>", ASCII 10,
        "  <planfinishdate>", ASCII 10,
        "    <name>PlanFinishDate</name>", ASCII 10,
        "    <type>Date</type>", ASCII 10,
        "    <value>", l_sfb.sfb15, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </planfinishdate>", ASCII 10,
        "  <mounitno>", ASCII 10,
        "    <name>MOUnitNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ima55 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </mounitno>", ASCII 10,
        "  <momateriallist>", ASCII 10,
        "    <name>MOMaterialList</name>", ASCII 10,
        "    <type>String</type>", ASCII 10

       LET l_j = 1
       FOREACH xml_curs_sfa1 INTO l_sfa.*
        
       LET l_ima08='' 
       LET l_putintype=''

       SELECT ima08 INTO l_ima08 FROM ima_file WHERE ima01=l_sfa.sfa03  

       IF l_ima08='P' THEN 
          LET l_materiallevel=0
       ELSE 
          LET l_materiallevel=1
       END IF

      #TQC-A10124 add str ---
      #取得原BOM的替代比率(標準用量)
       IF l_sfa.sfa26 MATCHES '[SU]' THEN
          LET l_sfa.sfa161 = 1                      #替代比率給予預設值=1
          SELECT bmd07 INTO l_sfa.sfa161 FROM bmd_file
           WHERE bmd08 = l_sfb.sfb05                #主件編號
             AND bmd04 = l_sfa.sfa03                #發料(替代)編號
             AND bmd01 = l_sfa.sfa27                #原BOM料號
       END IF
      #TQC-A10124 add end ---

      #TQC-A10124 mark --帶預設值=3
      #IF l_ima08='M' THEN 
      #   LET l_putintype='1' 
      #ELSE 
          LET l_putintype='3' 
      #END IF 

       LET l_xmlbody1 = l_xmlbody1 CLIPPED,
            "    <value>", ASCII 10,
           #"      <materialno>", l_sfa.sfa03 CLIPPED, "</materialno>", ASCII 10,  #TQC-A10124 mark
            "      <materialno>", l_sfa.sfa27 CLIPPED, "</materialno>", ASCII 10,  #BOM料號 #TQC-A10124 add
            "      <materialtype></materialtype>", ASCII 10,   
            "      <materiallevel>",l_materiallevel,"</materiallevel>", ASCII 10, 
            "      <stdqty>", l_sfa.sfa161, "</stdqty>", ASCII 10,  
            "      <unitno>", l_sfa.sfa12 CLIPPED, "</unitno>", ASCII 10,
            "      <opno>", l_sfa.sfa08 CLIPPED, "</opno>", ASCII 10,
            "      <putinplacetype>", l_putintype CLIPPED, "</putinplacetype>", ASCII 10,  
            "      <substitutematerialno>", l_sfa.sfa03 CLIPPED, "</substitutematerialno>", ASCII 10, #替代料物料編號 #TQC-A10124 add
            "     </value>", ASCII 10
           LET l_j = l_j + 1
       END FOREACH

       LET l_i = l_i + 1
   END FOREACH

   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, l_xmlbody1 CLIPPED, ASCII 10,
                     "  </momateriallist>", ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION


#TIPTOP / MES:工單結案
FUNCTION aws_mescli_CloseMO()
   DEFINE l_xmlbody     STRING
   DEFINE l_sfb01       LIKE sfb_file.sfb01       #工單編號                #FUN-9C0018 add
   DEFINE l_sfbstr      STRING                    #工單編號的集合字串      #FUN-9C0018 add
   DEFINE tok           base.StringTokenizer      #依分隔符號拆解字串      #FUN-9C0018 add

  #FUN-9C0018 add str -------
   IF g_prog2 = 'asfp401' THEN
     LET l_sfbstr = g_key2.substring(1,g_key2.getlength()-1)    #去除最後一碼的分隔符號  
     LET tok = base.StringTokenizer.create(l_sfbstr,",")
 
     WHILE tok.hasMoreTokens()                                
       LET l_sfb01 = tok.nextToken()                          

       LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
           "  <mono>", ASCII 10,
           "    <name>MONo</name>", ASCII 10,
           "    <type>String</type>", ASCII 10,
           "    <value>", l_sfb01 CLIPPED, "</value>", ASCII 10,   
           "    <desc></desc>", ASCII 10,
           "  </mono>", ASCII 10
     END WHILE      
   ELSE
  #FUN-9C0018 add end -------
      LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
           "  <mono>", ASCII 10,
           "    <name>MONo</name>", ASCII 10,
           "    <type>String</type>", ASCII 10,
           "    <value>", g_key1 CLIPPED, "</value>", ASCII 10,
           "    <desc></desc>", ASCII 10,
           "  </mono>", ASCII 10
   END IF 

   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10
END FUNCTION


#工單發料  #FUN-9A0095 add
FUNCTION aws_mescli_AddMaterial2MO()   
  DEFINE l_xmlbody     STRING   
  DEFINE l_xmlbody1    STRING   
  DEFINE l_sfp         RECORD LIKE sfp_file.*   
  DEFINE l_sfs         RECORD LIKE sfs_file.*   
  DEFINE l_i           LIKE type_file.num5   
  DEFINE l_j           LIKE type_file.num5   
  DEFINE l_putintype   LIKE type_file.chr1   
  DEFINE l_today       LIKE type_file.chr30   
  DEFINE l_sfe         RECORD LIKE sfe_file.*   
  DEFINE l_qty         LIKE sfs_file.sfs05   
  DEFINE l_ima08       LIKE ima_file.ima08      #FUN-9A0095 add
  DEFINE l_materiallevel LIKE type_file.num5    #FUN-9A0095 add

  LET l_today = TODAY USING "yyyy/mm/dd"  

 #Head   
  LET g_sql = " SELECT * FROM sfp_file ",               
              "  WHERE sfp01 = '",g_key1,"'"    

  PREPARE xml_pb10 FROM g_sql   
  DECLARE xml_curs10       
  CURSOR WITH HOLD FOR xml_pb10  

 #Detail   
 #IF g_action = 'delete' THEN                    #過帳還原     
 #   LET g_sql = " SELECT * FROM sfs_file ",                 
 #               "  WHERE sfs01 = '",g_key1,"'"        
 #   PREPARE xml_sfs FROM g_sql   
 #   DECLARE xml_curs_sfs    
 #   CURSOR WITH HOLD FOR xml_sfs   
 #ELSE                                           #庫存過帳     
     LET g_sql = " SELECT * FROM sfe_file ",                 
                 "  WHERE sfe02 = '",g_key1,"'"   
     PREPARE xml_sfe FROM g_sql
     DECLARE xml_curs_sfe
     CURSOR WITH HOLD FOR xml_sfe
 #END IF      


  LET l_i = 1   
  
  FOREACH xml_curs10 INTO l_sfp.*      
    LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,          
            "  <materialinno>", ASCII 10,          
            "    <name>MaterialINNo</name>", ASCII 10,          
            "    <type>String</type>", ASCII 10,          
            "    <value>", l_sfp.sfp01 CLIPPED, "</value>", ASCII 10,          
            "    <desc></desc>", ASCII 10,          
            "  </materialinno>", ASCII 10,          
            "  <materialinlist>", ASCII 10,          
            "    <name>MaterialInList</name>", ASCII 10,          
            "    <type>String</type>", ASCII 10       

    LET l_j = 1      

   #IF g_action = 'delete' THEN        
   #  #過帳還原
   #   FOREACH xml_curs_sfs INTO l_sfs.*                    
   #      LET l_qty = l_sfs.sfs05 * (-1)

   #      LET l_xmlbody1 = l_xmlbody1 CLIPPED,              
   #             "    <value>", ASCII 10,              
   #             "      <mono>", l_sfs.sfs03 CLIPPED, "</mono>", ASCII 10,                   #工單編號                
   #             "      <materialno>", l_sfs.sfs04 CLIPPED, "</materialno>", ASCII 10,       #料號              
   #             "      <materiallotno>", l_sfs.sfs09 CLIPPED, "</materiallotno>", ASCII 10, #物料批號              
   #             "      <unitno>", l_sfs.sfs06 CLIPPED, "</unitno>", ASCII 10,               #單位              
   #             "      <qty>", l_qty , "</qty>", ASCII 10,                                  #過帳數量              
   #             "      <materiallevel></materiallevel>", ASCII 10,              
   #             "      <inputdate>", l_today CLIPPED, "</inputdate>", ASCII 10,              
   #             "     </value>", ASCII 10            

   #      LET l_j = l_j + 1                  
   #   END FOREACH      
   #ELSE   

      
      #庫存過帳          
       FOREACH xml_curs_sfe INTO l_sfe.*                    
          #FUN-9A0095 add str---------
          SELECT ima08 INTO l_ima08 FROM ima_file WHERE ima01=l_sfe.sfe07  
          IF l_ima08 MATCHES '[PV]' THEN
             LET l_materiallevel=0       #原料
          ELSE
             LET l_materiallevel=1       #主件
          END IF
         #FUN-9A0095 add end---------

          LET l_xmlbody1 = l_xmlbody1 CLIPPED,              
                 "    <value>", ASCII 10,              
                 "      <mono>", l_sfe.sfe01 CLIPPED, "</mono>", ASCII 10,                   #工單編號
                 "      <materialno>", l_sfe.sfe07 CLIPPED, "</materialno>", ASCII 10,       #料號
                 "      <materiallotno>", l_sfe.sfe10 CLIPPED, "</materiallotno>", ASCII 10, #物料批號              
                 "      <unitno>", l_sfe.sfe17 CLIPPED, "</unitno>", ASCII 10,               #單位              
                 "      <qty>", l_sfe.sfe16 , "</qty>", ASCII 10,                            #過帳數量              
                 "      <materiallevel>", l_materiallevel CLIPPED, "</materiallevel>", ASCII 10,              
                 "      <inputdate>", l_today CLIPPED, "</inputdate>", ASCII 10,     
                 "      <substitutematerialno>", l_sfe.sfe27 CLIPPED, "</substitutematerialno>", ASCII 10,  #被替代料號 #TQC-A10124 add        
                 "     </value>", ASCII 10            

          LET l_j = l_j + 1                  
       END FOREACH      
   #END IF            

    LET l_i = l_i + 1       
  END FOREACH                 

  LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, l_xmlbody1 CLIPPED, ASCII 10,                     
                     "  </materialinlist>", ASCII 10,
                     " </parameter>", ASCII 10,                     
                     "</request>", ASCII 10
END FUNCTION

#工單取消發料  #FUN-9A0095 add
FUNCTION aws_mescli_UndoAddMaterial2MO()
  DEFINE l_xmlbody     STRING
  DEFINE l_xmlbody1    STRING
  DEFINE l_sfp         RECORD LIKE sfp_file.*
  DEFINE l_sfs         RECORD LIKE sfs_file.*
  DEFINE l_i           LIKE type_file.num5
  DEFINE l_j           LIKE type_file.num5
  DEFINE l_putintype   LIKE type_file.chr1
  DEFINE l_today       LIKE type_file.chr30
  DEFINE l_ima08       LIKE ima_file.ima08      #FUN-9A0095 add
  DEFINE l_materiallevel LIKE type_file.num5    #FUN-9A0095 add

  LET l_today = TODAY USING "yyyy/mm/dd"

 #Head
  LET g_sql = " SELECT * FROM sfp_file ",
              "  WHERE sfp01 = '",g_key1,"'"

  PREPARE xml_pb22 FROM g_sql
  DECLARE xml_curs22
  CURSOR WITH HOLD FOR xml_pb22

  LET g_sql = " SELECT * FROM sfs_file ",
              "  WHERE sfs01 = '",g_key1,"'"
  PREPARE xml_sfs FROM g_sql
  DECLARE xml_curs_sfs
  CURSOR WITH HOLD FOR xml_sfs
 
  LET l_i = 1

  FOREACH xml_curs22 INTO l_sfp.*
    LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
            "  <materialinno>", ASCII 10,
            "    <name>MaterialINNo</name>", ASCII 10,
            "    <type>String</type>", ASCII 10,
            "    <value>", l_sfp.sfp01 CLIPPED, "</value>", ASCII 10,
            "    <desc></desc>", ASCII 10,
            "  </materialinno>", ASCII 10,
            "  <materialinlist>", ASCII 10,
            "    <name>MaterialInList</name>", ASCII 10,
            "    <type>String</type>", ASCII 10

    LET l_j = 1
    FOREACH xml_curs_sfs INTO l_sfs.*
      #FUN-9A0095 add str--------- 
       SELECT ima08 INTO l_ima08 FROM ima_file WHERE ima01=l_sfs.sfs04  
       IF l_ima08 MATCHES '[PV]' THEN
          LET l_materiallevel=0       #原料
       ELSE
          LET l_materiallevel=1       #主件
       END IF
      #FUN-9A0095 add end---------

       LET l_xmlbody1 = l_xmlbody1 CLIPPED,
              "    <value>", ASCII 10,
              "      <mono>", l_sfs.sfs03 CLIPPED, "</mono>", ASCII 10,                   #工單>
              "      <materialno>", l_sfs.sfs04 CLIPPED, "</materialno>", ASCII 10,       #料號
              "      <materiallotno>", l_sfs.sfs09 CLIPPED, "</materiallotno>", ASCII 10, #物料>
              "      <unitno>", l_sfs.sfs06 CLIPPED, "</unitno>", ASCII 10,               #單位
              "      <qty>", l_sfs.sfs05 , "</qty>", ASCII 10,                            #過帳>
              "      <materiallevel>", l_materiallevel CLIPPED, "</materiallevel>", ASCII 10,
              "      <inputdate>", l_today CLIPPED, "</inputdate>", ASCII 10,
              "      <substitutematerialno>", l_sfs.sfs27 CLIPPED, "</substitutematerialno>", ASCII 10,  #被替代料號 #TQC-A10124 add
              "     </value>", ASCII 10

       LET l_j = l_j + 1
    END FOREACH

    LET l_i = l_i + 1
  END FOREACH

  LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, l_xmlbody1 CLIPPED, ASCII 10,
                    "  </materialinlist>", ASCII 10,
                    " </parameter>", ASCII 10,
                    "</request>", ASCII 10  
END FUNCTION


#工單退料  #FUN-9A0095 add
FUNCTION aws_mescli_ReturnMaterial2MO()
  DEFINE l_xmlbody     STRING   
  DEFINE l_xmlbody1    STRING   
  DEFINE l_sfp         RECORD LIKE sfp_file.*
  DEFINE l_sfs         RECORD LIKE sfs_file.*
  DEFINE l_i           LIKE type_file.num5
  DEFINE l_j           LIKE type_file.num5
  DEFINE l_putintype   LIKE type_file.chr1
  DEFINE l_today       LIKE type_file.chr30
  DEFINE l_sfe         RECORD LIKE sfe_file.*   
  DEFINE l_qty         LIKE sfs_file.sfs05
  DEFINE l_ima08       LIKE ima_file.ima08      #FUN-9A0095 add
  DEFINE l_materiallevel LIKE type_file.num5    #FUN-9A0095 add
        
  LET l_today = TODAY USING "yyyy/mm/dd"  
        
 #Head       
  LET g_sql = " SELECT * FROM sfp_file ",
              "  WHERE sfp01 = '",g_key1,"'"

  PREPARE xml_pb25 FROM g_sql
  DECLARE xml_curs25
  CURSOR WITH HOLD FOR xml_pb25

 #Detail
  LET g_sql = " SELECT * FROM sfe_file ",
              "  WHERE sfe02 = '",g_key1,"'"
  PREPARE xml_sfe2 FROM g_sql
  DECLARE xml_curs_sfe2
  CURSOR WITH HOLD FOR xml_sfe2

  LET l_i = 1

  FOREACH xml_curs25 INTO l_sfp.*
    LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
            "  <materialinno>", ASCII 10,
            "    <name>MaterialINNo</name>", ASCII 10,
            "    <type>String</type>", ASCII 10,
            "    <value>", l_sfp.sfp01 CLIPPED, "</value>", ASCII 10,
            "    <desc></desc>", ASCII 10,
            "  </materialinno>", ASCII 10,
            "  <materialinlist>", ASCII 10,
            "    <name>MaterialInList</name>", ASCII 10,
            "    <type>String</type>", ASCII 10

    LET l_j = 1
    FOREACH xml_curs_sfe2 INTO l_sfe.*
      #FUN-9A0095 add str---------
       SELECT ima08 INTO l_ima08 FROM ima_file WHERE ima01=l_sfe.sfe07  
       IF l_ima08 MATCHES '[PV]' THEN
          LET l_materiallevel=0       #原料
       ELSE
          LET l_materiallevel=1       #主件
       END IF
      #FUN-9A0095 add end---------
       LET l_xmlbody1 = l_xmlbody1 CLIPPED,
              "    <value>", ASCII 10,
              "      <mono>", l_sfe.sfe01 CLIPPED, "</mono>", ASCII 10,                   #工單編號
              "      <materialno>", l_sfe.sfe07 CLIPPED, "</materialno>", ASCII 10,       #料號
              "      <materiallotno>", l_sfe.sfe10 CLIPPED, "</materiallotno>", ASCII 10, #物料
              "      <unitno>", l_sfe.sfe17 CLIPPED, "</unitno>", ASCII 10,               #單位
              "      <qty>", l_sfe.sfe16 , "</qty>", ASCII 10,                            #過帳數量
              "      <materiallevel>", l_materiallevel CLIPPED, "</materiallevel>", ASCII 10,
              "      <inputdate>", l_today CLIPPED, "</inputdate>", ASCII 10,
              "     </value>", ASCII 10
   
       LET l_j = l_j + 1
    END FOREACH

    LET l_i = l_i + 1
  END FOREACH

  LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, l_xmlbody1 CLIPPED, ASCII 10,
                    "  </materialinlist>", ASCII 10,
                    " </parameter>", ASCII 10,
                    "</request>", ASCII 10
END FUNCTION


#工單取消退料  #FUN-9A0095 add
FUNCTION aws_mescli_UndoReturnMaterial2MO()
  DEFINE l_xmlbody     STRING
  DEFINE l_xmlbody1    STRING
  DEFINE l_sfp         RECORD LIKE sfp_file.*
  DEFINE l_sfs         RECORD LIKE sfs_file.*
  DEFINE l_i           LIKE type_file.num5
  DEFINE l_j           LIKE type_file.num5
  DEFINE l_putintype   LIKE type_file.chr1
  DEFINE l_today       LIKE type_file.chr30
  DEFINE l_ima08       LIKE ima_file.ima08      #FUN-9A0095 add
  DEFINE l_materiallevel LIKE type_file.num5    #FUN-9A0095 add

  LET l_today = TODAY USING "yyyy/mm/dd"

 #Head
  LET g_sql = " SELECT * FROM sfp_file ",
              "  WHERE sfp01 = '",g_key1,"'"

  PREPARE xml_pb26 FROM g_sql
  DECLARE xml_curs26
  CURSOR WITH HOLD FOR xml_pb26

  LET g_sql = " SELECT * FROM sfs_file ",
              "  WHERE sfs01 = '",g_key1,"'"
  PREPARE xml_sfs2 FROM g_sql
  DECLARE xml_curs_sfs2
  CURSOR WITH HOLD FOR xml_sfs2

  LET l_i = 1

  FOREACH xml_curs26 INTO l_sfp.*
    LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
            "  <materialinno>", ASCII 10,
            "    <name>MaterialINNo</name>", ASCII 10,
            "    <type>String</type>", ASCII 10,
            "    <value>", l_sfp.sfp01 CLIPPED, "</value>", ASCII 10,
            "    <desc></desc>", ASCII 10,
            "  </materialinno>", ASCII 10,
            "  <materialinlist>", ASCII 10,
            "    <name>MaterialInList</name>", ASCII 10,
            "    <type>String</type>", ASCII 10

    LET l_j = 1
    FOREACH xml_curs_sfs2 INTO l_sfs.*
      #FUN-9A0095 add str---------
       SELECT ima08 INTO l_ima08 FROM ima_file WHERE ima01=l_sfs.sfs04 
       IF l_ima08 MATCHES '[PV]' THEN
          LET l_materiallevel=0       #原料
       ELSE
          LET l_materiallevel=1       #主件
       END IF
      #FUN-9A0095 add end---------
       LET l_xmlbody1 = l_xmlbody1 CLIPPED,
              "    <value>", ASCII 10,
              "      <mono>", l_sfs.sfs03 CLIPPED, "</mono>", ASCII 10,                   #工單編號
              "      <materialno>", l_sfs.sfs04 CLIPPED, "</materialno>", ASCII 10,       #料號
              "      <materiallotno>", l_sfs.sfs09 CLIPPED, "</materiallotno>", ASCII 10, #物料
              "      <unitno>", l_sfs.sfs06 CLIPPED, "</unitno>", ASCII 10,               #單位
              "      <qty>", l_sfs.sfs05 , "</qty>", ASCII 10,                            #過帳數量
              "      <materiallevel>", l_materiallevel CLIPPED, "</materiallevel>", ASCII 10,
              "      <inputdate>", l_today CLIPPED, "</inputdate>", ASCII 10,
              "     </value>", ASCII 10

       LET l_j = l_j + 1
    END FOREACH

    LET l_i = l_i + 1
  END FOREACH

  LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, l_xmlbody1 CLIPPED, ASCII 10,
                    "  </materialinlist>", ASCII 10,
                    " </parameter>", ASCII 10,
                    "</request>", ASCII 10
END FUNCTION



FUNCTION aws_mescli_AddCustomer()

   DEFINE l_occ         RECORD LIKE occ_file.*
   DEFINE l_xmlbody     STRING
   DEFINE l_i           LIKE type_file.num5

   LET g_sql = " SELECT * FROM occ_file ",
               "  WHERE occ01 = '",g_key1,"'" 
   PREPARE xml_pb11 FROM g_sql
   DECLARE xml_curs11
       CURSOR WITH HOLD FOR xml_pb11
   LET l_i = 1
   FOREACH xml_curs11 INTO l_occ.*
    
   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <customerno>", ASCII 10,
        "    <name>CustomerNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_occ.occ01 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </customerno>", ASCII 10,
        "  <customername>", ASCII 10,
        "    <name>CustomerName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_occ.occ18 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </customername>", ASCII 10,
        "  <customersname>", ASCII 10,
        "    <name>CustomerSName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_occ.occ02 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </customersname>", ASCII 10,
        "  <creator>", ASCII 10,
        "    <name>Creator</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", g_user CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </creator>", ASCII 10 
   END FOREACH
   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION

FUNCTION aws_mescli_EditCustomer()

   DEFINE l_occ         RECORD LIKE occ_file.*
   DEFINE l_xmlbody     STRING
   DEFINE l_i           LIKE type_file.num5

   LET g_sql = " SELECT * FROM occ_file ",
               "  WHERE occ01 = '",g_key1,"'" 
   PREPARE xml_pb12 FROM g_sql
   DECLARE xml_curs12
       CURSOR WITH HOLD FOR xml_pb12
   LET l_i = 1
   FOREACH xml_curs12 INTO l_occ.*

   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <customerno>", ASCII 10,
        "    <name>CustomerNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_occ.occ01 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </customerno>", ASCII 10,
        "  <customername>", ASCII 10,
        "    <name>CustomerName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_occ.occ18 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </customername>", ASCII 10,
        "  <customersname>", ASCII 10,
        "    <name>CustomerSName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_occ.occ02 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </customersname>", ASCII 10
   END FOREACH
   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10
    
END FUNCTION 

#FUN-950072 ADD --STR----------------------------
FUNCTION aws_mescli_CreateCustomer()

   DEFINE l_occ         RECORD LIKE occ_file.*
   DEFINE l_xmlbody     STRING
   DEFINE l_i           LIKE type_file.num5

   LET g_sql = " SELECT * FROM occ_file ",
               "  WHERE occ01 = '",g_key1,"'" 
   PREPARE xml_pb04 FROM g_sql
   DECLARE xml_curs04
       CURSOR WITH HOLD FOR xml_pb04
   LET l_i = 1
   FOREACH xml_curs04 INTO l_occ.*
    
   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <customerno>", ASCII 10,
        "    <name>CustomerNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_occ.occ01 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </customerno>", ASCII 10,
        "  <customername>", ASCII 10,
        "    <name>CustomerName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_occ.occ18 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </customername>", ASCII 10,
        "  <customersname>", ASCII 10,
        "    <name>CustomerSName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_occ.occ02 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </customersname>", ASCII 10,
        "  <creator>", ASCII 10,
        "    <name>Creator</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", g_user CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </creator>", ASCII 10 
   END FOREACH
   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION
#FUN-950072 ADD --END-----------------------------

FUNCTION aws_mescli_DelCustomer()

   DEFINE l_occ         RECORD LIKE occ_file.*
   DEFINE l_xmlbody     STRING
   DEFINE l_i           LIKE type_file.num5

   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <customerno>", ASCII 10,
        "    <name>CustomerNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", g_key1 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </customerno>", ASCII 10
   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10
    
END FUNCTION 

FUNCTION aws_mescli_AddOperation()

   DEFINE l_ecd         RECORD LIKE ecd_file.*
   DEFINE l_xmlbody     STRING
   DEFINE l_i           LIKE type_file.num5

   LET g_sql = " SELECT * FROM ecd_file ",
               "  WHERE ecd01 = '",g_key1,"'" 
   PREPARE xml_pb14 FROM g_sql
   DECLARE xml_curs14
       CURSOR WITH HOLD FOR xml_pb14
   LET l_i = 1
   FOREACH xml_curs14 INTO l_ecd.*
    
   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <opno>", ASCII 10,
        "    <name>OPNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ecd.ecd01 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </opno>", ASCII 10,
        "  <opname>", ASCII 10,
        "    <name>OPName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ecd.ecd02 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </opname>", ASCII 10,
        "  <optype>", ASCII 10,
        "    <name>OPType</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value></value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </optype>", ASCII 10,
        "  <opclass>", ASCII 10,
        "    <name>OPClass</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>0</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </opclass>", ASCII 10,
        "  <opshortname>", ASCII 10,
        "    <name>OPShortName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value></value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </opshortname>", ASCII 10,
        "  <oporder>", ASCII 10,
        "    <name>OPOrder</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value></value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </oporder>", ASCII 10,
        "  <stdunitruntime>", ASCII 10,
        "    <name>STDUnitRunTime</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value></value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </stdunitruntime>", ASCII 10,
        "  <countopunitqty>", ASCII 10,
        "    <name>CountOPUnitQTY</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value></value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </countopunitqty>", ASCII 10,
        "  <stdqueuetime>", ASCII 10,
        "    <name>stdqueutime</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value></value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </stdqueuetime>", ASCII 10,
        "  <creator>", ASCII 10,
        "    <name>Creator</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", g_user CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </creator>", ASCII 10 
   END FOREACH
   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION

FUNCTION aws_mescli_EditOperation()

   DEFINE l_ecd         RECORD LIKE ecd_file.*
   DEFINE l_xmlbody     STRING
   DEFINE l_i           LIKE type_file.num5

   LET g_sql = " SELECT * FROM ecd_file ",
               "  WHERE ecd01 = '",g_key1,"'" 
   PREPARE xml_pb15 FROM g_sql
   DECLARE xml_curs15
       CURSOR WITH HOLD FOR xml_pb15
   LET l_i = 1
   FOREACH xml_curs15 INTO l_ecd.*
    
   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <opno>", ASCII 10,
        "    <name>OPNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ecd.ecd01 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </opno>", ASCII 10,
        "  <opname>", ASCII 10,
        "    <name>OPName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ecd.ecd02 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </opname>", ASCII 10,
        "  <opshortname>", ASCII 10,
        "    <name>OPShortName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value></value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </opshortname>", ASCII 10

   END FOREACH
   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION


#FUN-9A0056 add begin --------------------------





#TIPTOP : 班次(aeci650) →  MES : 班別
FUNCTION aws_mescli_CreateShift()

  DEFINE l_ecg       RECORD LIKE ecg_file.*
  DEFINE l_xmlbody   STRING
  DEFINE l_i         LIKE type_file.num5
  
  LET g_sql = " SELECT * FROM ecg_file ",
              "  WHERE ecg01 = '",g_key1,"'"
  PREPARE xml_pb13 FROM g_sql
  DECLARE xml_curs13
  CURSOR WITH HOLD FOR xml_pb13
  LET l_i = 1
  FOREACH xml_curs13 INTO l_ecg.*
  
  LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <departmentno>", ASCII 10,
        "    <name>DepartmentNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>*</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </departmentno>", ASCII 10,
        "  <shiftno>", ASCII 10,
        "    <name>ShiftNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ecg.ecg01 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </shiftno>", ASCII 10,
        "  <shiftname>", ASCII 10,
        "    <name>ShiftName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ecg.ecg02 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </shiftname>", ASCII 10,
        "  <fromtime>", ASCII 10,
        "    <name>FromTime</name>", ASCII 10,
        "    <type>Date</type>", ASCII 10,
        "    <value>2000/01/01 00:00:00</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </fromtime>", ASCII 10,               
        "  <totime>", ASCII 10,
        "    <name>ToTime</name>", ASCII 10,
        "    <type>Date</type>", ASCII 10,
        "    <value>2000/01/01 00:00:00</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </totime>", ASCII 10
  END FOREACH

  LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                    " </parameter>", ASCII 10,
                    "</request>", ASCII 10
END FUNCTION

FUNCTION aws_mescli_DelShift()

  DEFINE l_ecg        RECORD LIKE ecg_file.*
  DEFINE l_xmlbody    STRING
  DEFINE l_i          LIKE type_file.num5
  
  LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
     "  <shiftno>", ASCII 10,
     "    <name>ShiftNo</name>", ASCII 10,
     "    <type>String</type>", ASCII 10,
     "    <value>", g_key1 CLIPPED, "</value>", ASCII 10,
     "    <desc></desc>", ASCII 10,
     "  </shiftno>", ASCII 10
    
  LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
     " </parameter>", ASCII 10,
     "</request>", ASCII 10
END FUNCTION


FUNCTION aws_mescli_CreateMaterialVendor()

  DEFINE l_pmh         RECORD LIKE pmh_file.*
  DEFINE l_xmlbody     STRING
  DEFINE l_i           LIKE   type_file.num5
  DEFINE l_pmh01       LIKE   pmh_file.pmh01
  DEFINE l_pmh02       LIKE   pmh_file.pmh02
  DEFINE p_str         STRING
  DEFINE p_sep         STRING
  DEFINE p_arr         DYNAMIC ARRAY OF STRING
  DEFINE l_seplen      LIKE type_file.num5
  DEFINE l_pos         LIKE type_file.num5
  DEFINE l_j           LIKE type_file.num5
  DEFINE l_start       LIKE type_file.num5
  
  CALL p_arr.clear()
  LET p_str = g_key2
  LET p_sep = '{+}'
  LET l_seplen = p_sep.getLength()

  IF l_seplen = 0 THEN
     LET p_arr[1] = p_str
  END IF
  
  LET l_j = 1
  LET l_start = 1
  LET l_pos = p_str.getIndexOf(p_sep,1)

  WHILE l_pos > 0
    LET p_arr[l_j] = p_str.subString(l_start,l_pos-1)
    LET l_pos = l_pos + l_seplen
    LET l_start = l_pos
    LET l_pos = p_str.getIndexOf(p_sep,l_pos)
    LET l_j = l_j + 1
  END WHILE

  LET p_arr[l_j] = p_str.subString(l_start,LENGTH(p_str))

  LET l_pmh01 = p_arr[1]
  LET l_pmh02 = p_arr[2]

  LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
       "  <vendorno>", ASCII 10,
       "    <name>VendorNo</name>", ASCII 10,
       "    <type>String</type>", ASCII 10,
       "    <value>", l_pmh02 CLIPPED, "</value>", ASCII 10,
       "    <desc></desc>", ASCII 10,
       "  </vendorno>", ASCII 10,
       "  <materialno>", ASCII 10,
       "    <name>Materialno</name>", ASCII 10,
       "    <type>String</type>", ASCII 10,
       "    <value>", l_pmh01 CLIPPED, "</value>", ASCII 10,
       "    <desc></desc>", ASCII 10,
       "  </materialno>", ASCII 10,
       "  <description>", ASCII 10,
       "    <name>Description</name>", ASCII 10,
       "    <type>String</type>", ASCII 10,
       "    <value></value>", ASCII 10,
       "    <desc></desc>", ASCII 10,
       "  </description>", ASCII 10
       
  LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                    " </parameter>", ASCII 10,
                    "</request>", ASCII 10

END FUNCTION


FUNCTION aws_mescli_DelMaterialVendor()

  DEFINE l_pmh         RECORD LIKE pmh_file.*
  DEFINE l_xmlbody     STRING
  DEFINE l_i           LIKE type_file.num5
  DEFINE l_pmh01       LIKE pmh_file.pmh01
  DEFINE l_pmh02       LIKE pmh_file.pmh02
  DEFINE p_str         STRING
  DEFINE p_sep         STRING
  DEFINE p_arr         DYNAMIC ARRAY OF STRING
  DEFINE l_seplen      LIKE type_file.num5
  DEFINE l_pos         LIKE type_file.num5
  DEFINE l_j           LIKE type_file.num5
  DEFINE l_start       LIKE type_file.num5

  CALL p_arr.clear()

  LET p_str = g_key2
  LET p_sep = '{+}'
  LET l_seplen = p_sep.getLength()

  IF l_seplen = 0 THEN
     LET p_arr[1] = p_str
  END IF

  LET l_j = 1
  LET l_start = 1
  LET l_pos = p_str.getIndexOf(p_sep,1)

  WHILE l_pos > 0
    LET p_arr[l_j] = p_str.subString(l_start,l_pos-1)
    LET l_pos = l_pos + l_seplen
    LET l_start = l_pos
    LET l_pos = p_str.getIndexOf(p_sep,l_pos)
    LET l_j = l_j + 1
  END WHILE

  LET p_arr[l_j] = p_str.subString(l_start,LENGTH(p_str))

  LET l_pmh01 = p_arr[1]
  LET l_pmh02 = p_arr[2]

  LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
       "  <vendorno>", ASCII 10,
       "    <name>VendorNo</name>", ASCII 10,
       "    <type>String</type>", ASCII 10,
       "    <value>", l_pmh02 CLIPPED, "</value>", ASCII 10,
       "    <desc></desc>", ASCII 10,
       "  </vendorno>", ASCII 10,
       "  <materialno>", ASCII 10,
       "    <name>Materialno</name>", ASCII 10,
       "    <type>String</type>", ASCII 10,
       "    <value>", l_pmh01 CLIPPED, "</value>", ASCII 10,
       "    <desc></desc>", ASCII 10,
       "  </materialno>", ASCII 10

  LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                    " </parameter>", ASCII 10,
                    "</request>", ASCII 10
END FUNCTION


#TIPTOP : 機器(aeci670) →  MES : 設備
FUNCTION aws_mescli_CreateEquipment()

  DEFINE l_eci       RECORD LIKE eci_file.*
  DEFINE l_xmlbody   STRING
  DEFINE l_i         LIKE type_file.num5
  
  LET g_sql = " SELECT * FROM eci_file ",
              "  WHERE eci01 = '",g_key1,"'"
  PREPARE xml_pb16 FROM g_sql
  DECLARE xml_curs16
  CURSOR WITH HOLD FOR xml_pb16
  LET l_i = 1
  FOREACH xml_curs16 INTO l_eci.*
  
  LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <equipmentno>", ASCII 10,
        "    <name>EquipmentNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_eci.eci01 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </equipmentno>", ASCII 10,
        "  <equipmenttype>", ASCII 10,
        "    <name>EquipmentType</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>EQPTYPE</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </equipmenttype>", ASCII 10,
        "  <vendorno>", ASCII 10,
        "    <name>VendorNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>N/A</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </vendorno>", ASCII 10
  END FOREACH
  LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                    " </parameter>", ASCII 10,
                    "</request>", ASCII 10
END FUNCTION


FUNCTION aws_mescli_DelEquipment()

  DEFINE l_eci        RECORD LIKE eci_file.*
  DEFINE l_xmlbody    STRING
  DEFINE l_i          LIKE type_file.num5
  
  LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
     "  <equipmentno>", ASCII 10,
     "    <name>EquipmentNo</name>", ASCII 10,
     "    <type>String</type>", ASCII 10,
     "    <value>", g_key1 CLIPPED, "</value>", ASCII 10,
     "    <desc></desc>", ASCII 10,
     "  </equipmentno>", ASCII 10
     
  LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
     " </parameter>", ASCII 10,
     "</request>", ASCII 10
END FUNCTION


#TIPTOP : 供應商(apmi600) →  MES : 供應商
FUNCTION aws_mescli_CreateVendor()
  DEFINE l_pmc       RECORD LIKE pmc_file.*
  DEFINE l_xmlbody   STRING
  DEFINE l_i         LIKE type_file.num5
  
  LET g_sql = " SELECT * FROM pmc_file ",
              "  WHERE pmc01 = '",g_key1,"'"

  PREPARE xml_pb09 FROM g_sql
  DECLARE xml_curs09
  CURSOR WITH HOLD FOR xml_pb09
  LET l_i = 1
  FOREACH xml_curs09 INTO l_pmc.*
  
  LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <vendorno>", ASCII 10,
        "    <name>VendorNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_pmc.pmc01 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </vendorno>", ASCII 10,
        "  <vendorname>", ASCII 10,
        "    <name>VendorName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_pmc.pmc03 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </vendorname>", ASCII 10,
        "  <description>", ASCII 10,
        "    <name>Description</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value></value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </description>", ASCII 10
  END FOREACH
  LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                    " </parameter>", ASCII 10,
                    "</request>", ASCII 10
END FUNCTION

FUNCTION aws_mescli_DelVendor()
  DEFINE l_pmc        RECORD LIKE pmc_file.*
  DEFINE l_xmlbody    STRING
  DEFINE l_i          LIKE type_file.num5
  
  LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
     "  <vendorno>", ASCII 10,
     "    <name>VendorNo</name>", ASCII 10,
     "    <type>String</type>", ASCII 10,
     "    <value>", g_key1 CLIPPED, "</value>", ASCII 10,
     "    <desc></desc>", ASCII 10,
     "  </vendorno>", ASCII 10
     
  LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
     " </parameter>", ASCII 10,
     "</request>", ASCII 10
END FUNCTION


#TIPTOP : 作業(aeci620) →  MES : 作業群組
FUNCTION aws_mescli_CreateOPGroup()

 DEFINE l_ecd       RECORD LIKE ecd_file.*
 DEFINE l_xmlbody   STRING
 DEFINE l_i         LIKE type_file.num5
 
 LET g_sql = " SELECT * FROM ecd_file ",
             "  WHERE ecd01 = '",g_key1,"'"
 PREPARE xml_pb19 FROM g_sql
 DECLARE xml_curs19
 CURSOR WITH HOLD FOR xml_pb19
 LET l_i = 1
 FOREACH xml_curs19 INTO l_ecd.*
 
 LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
    "  <opgroupno>", ASCII 10,
    "    <name>OPGroupNo</name>", ASCII 10,
    "    <type>String</type>", ASCII 10,
    "    <value>", l_ecd.ecd01 CLIPPED, "</value>", ASCII 10,
    "    <desc></desc>", ASCII 10,
    "  </opgroupno>", ASCII 10,
    "  <opgroupname>", ASCII 10,
    "    <name>OPGroupName</name>", ASCII 10,
    "    <type>String</type>", ASCII 10,
    "    <value>", l_ecd.ecd02 CLIPPED, "</value>", ASCII 10,
    "    <desc></desc>", ASCII 10,
    "  </opgroupname>", ASCII 10,
    "  <psno>", ASCII 10,
    "    <name>PSNo</name>", ASCII 10,
    "    <type>String</type>", ASCII 10,
    "    <value></value>", ASCII 10,
    "    <desc></desc>", ASCII 10,
    "  </psno>", ASCII 10
 END FOREACH
 LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                   " </parameter>", ASCII 10,
                   "</request>", ASCII 10

END FUNCTION


FUNCTION aws_mescli_DelOPGroup()

 DEFINE l_ecd         RECORD LIKE ecd_file.*
 DEFINE l_xmlbody     STRING
 DEFINE l_i           LIKE type_file.num5

 LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
      "  <opgroupno>", ASCII 10,
      "    <name>OPGroupNo</name>", ASCII 10,
      "    <type>String</type>", ASCII 10,
      "    <value>", g_key1 CLIPPED, "</value>", ASCII 10,
      "    <desc></desc>", ASCII 10,
      "  </opgroupno>", ASCII 10

 LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                   " </parameter>", ASCII 10,
                   "</request>", ASCII 10
END FUNCTION
#FUN-9A0056 add end ----------------------------------------------


#FUN-950072 ADD --STR----------------------------
#TIPTOP : 工作站(aeci600)  →  MES : 作業
FUNCTION aws_mescli_CreateOperation()

   DEFINE l_eca         RECORD LIKE eca_file.*
   DEFINE l_xmlbody     STRING
   DEFINE l_i           LIKE type_file.num5

   LET g_sql = " SELECT * FROM eca_file ",
               "  WHERE eca01 = '",g_key1,"'" 
   PREPARE xml_pb05 FROM g_sql
   DECLARE xml_curs05
       CURSOR WITH HOLD FOR xml_pb05
   LET l_i = 1
   FOREACH xml_curs05 INTO l_eca.*
    
   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <opno>", ASCII 10,
        "    <name>OPNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_eca.eca01 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </opno>", ASCII 10,
        "  <opname>", ASCII 10,
        "    <name>OPName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_eca.eca02 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </opname>", ASCII 10,
        "  <optype>", ASCII 10,
        "    <name>OPType</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value></value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </optype>", ASCII 10,
        "  <opclass>", ASCII 10,
        "    <name>OPClass</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>0</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </opclass>", ASCII 10,
        "  <opshortname>", ASCII 10,
        "    <name>OPShortName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value></value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </opshortname>", ASCII 10,
        "  <oporder>", ASCII 10,
        "    <name>OPOrder</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value></value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </oporder>", ASCII 10,
        "  <stdunitruntime>", ASCII 10,
        "    <name>STDUnitRunTime</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value></value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </stdunitruntime>", ASCII 10,
        "  <countopunitqty>", ASCII 10,
        "    <name>CountOPUnitQTY</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value></value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </countopunitqty>", ASCII 10,
        "  <stdqueuetime>", ASCII 10,
        "    <name>stdqueutime</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value></value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </stdqueuetime>", ASCII 10,
        "  <creator>", ASCII 10,
        "    <name>Creator</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", g_user CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </creator>", ASCII 10 
   END FOREACH
   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION
#FUN-950072 ADD --END----------------------------

FUNCTION aws_mescli_DelOperation()

   DEFINE l_eca         RECORD LIKE eca_file.*
   DEFINE l_xmlbody     STRING
   DEFINE l_i           LIKE type_file.num5

   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <opno>", ASCII 10,
        "    <name>OPNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", g_key1 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </opno>", ASCII 10

   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION

FUNCTION aws_mescli_AddInventory()

   DEFINE l_imd         RECORD LIKE imd_file.*
   DEFINE l_xmlbody     STRING
   DEFINE l_i           LIKE type_file.num5

   LET g_sql = " SELECT * FROM imd_file ",
               "  WHERE imd01 = '",g_key1,"'" 
   PREPARE xml_pb17 FROM g_sql
   DECLARE xml_curs17
       CURSOR WITH HOLD FOR xml_pb17
   LET l_i = 1
   FOREACH xml_curs17 INTO l_imd.*
    
   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <inventoryno>", ASCII 10,
        "    <name>InventoryNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_imd.imd01 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </inventoryno>", ASCII 10,
        "  <inventoryname>", ASCII 10,
        "    <name>InventoryName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_imd.imd02 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </inventoryname>", ASCII 10,
        "  <inventorytype>", ASCII 10,
        "    <name>InventoryType</name>", ASCII 10,
        "    <type>Number</type>", ASCII 10,
        "    <value>0</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </inventorytype>", ASCII 10,
        "  <inventoryclass>", ASCII 10,
        "    <name>InventoryClass</name>", ASCII 10,
        "    <type>Number</type>", ASCII 10,
        "    <value>0</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </inventoryclass>", ASCII 10,
        "  <factoryno>", ASCII 10,
        "    <name>FactoryNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", g_plant CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </factoryno>", ASCII 10,
        "  <creator>", ASCII 10,
        "    <name>Creator</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", g_user CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </creator>", ASCII 10 
   END FOREACH
   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION

FUNCTION aws_mescli_EditInventory()

   DEFINE l_imd         RECORD LIKE imd_file.*
   DEFINE l_xmlbody     STRING
   DEFINE l_i           LIKE type_file.num5

   LET g_sql = " SELECT * FROM imd_file ",
               "  WHERE imd01 = '",g_key1,"'" 
   PREPARE xml_pb18 FROM g_sql
   DECLARE xml_curs18
       CURSOR WITH HOLD FOR xml_pb18
   LET l_i = 1
   FOREACH xml_curs18 INTO l_imd.*
    
   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <inventoryno>", ASCII 10,
        "    <name>InventoryNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_imd.imd01 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </inventoryno>", ASCII 10,
        "  <inventoryname>", ASCII 10,
        "    <name>InventoryName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_imd.imd02 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </inventoryname>", ASCII 10
   END FOREACH
   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION

#FUN-950072 ADD --STR-----------------------------
FUNCTION aws_mescli_CreateInventory()

   DEFINE l_imd         RECORD LIKE imd_file.*
   DEFINE l_xmlbody     STRING
   DEFINE l_i           LIKE type_file.num5

   LET g_sql = " SELECT * FROM imd_file ",
               "  WHERE imd01 = '",g_key1,"'" 
   PREPARE xml_pb06 FROM g_sql
   DECLARE xml_curs06
       CURSOR WITH HOLD FOR xml_pb06
   LET l_i = 1
   FOREACH xml_curs06 INTO l_imd.*
   #FUN-9A0056 ADD --STR---------------------
   IF cl_null(l_imd.imd02) THEN
      LET l_imd.imd02 = l_imd.imd01
   END IF 
   #FUN-9A0056 ADD --END---------------------
   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <inventoryno>", ASCII 10,
        "    <name>InventoryNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_imd.imd01 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </inventoryno>", ASCII 10,
        "  <inventoryname>", ASCII 10,
        "    <name>InventoryName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_imd.imd02 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </inventoryname>", ASCII 10,
        "  <inventorytype>", ASCII 10,
        "    <name>InventoryType</name>", ASCII 10,
        "    <type>Number</type>", ASCII 10,
        "    <value>0</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </inventorytype>", ASCII 10,
        "  <inventoryclass>", ASCII 10,
        "    <name>InventoryClass</name>", ASCII 10,
        "    <type>Number</type>", ASCII 10,
        "    <value>0</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </inventoryclass>", ASCII 10,
        "  <factoryno>", ASCII 10,
        "    <name>FactoryNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", g_plant CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </factoryno>", ASCII 10,
        "  <creator>", ASCII 10,
        "    <name>Creator</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", g_user CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </creator>", ASCII 10 
   END FOREACH
   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION
#FUN-950072 ADD --END-----------------------------

FUNCTION aws_mescli_DelInventory()

   DEFINE l_imd         RECORD LIKE imd_file.*
   DEFINE l_xmlbody     STRING
   DEFINE l_i           LIKE type_file.num5

   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <inventoryno>", ASCII 10,
        "    <name>InventoryNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", g_key1 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </inventoryno>", ASCII 10

   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION

FUNCTION aws_mescli_AddLocation()
   DEFINE l_ime         RECORD LIKE ime_file.*
   DEFINE l_xmlbody     STRING
   DEFINE l_i           LIKE type_file.num5

   LET g_sql = " SELECT * FROM ime_file ",
               "  WHERE ime02 = '",g_key1,"'",
                  "    AND imeacti = 'Y' "        #FUN-D40103  
   PREPARE xml_pb20 FROM g_sql
   DECLARE xml_curs20
       CURSOR WITH HOLD FOR xml_pb20
   LET l_i = 1
   FOREACH xml_curs20 INTO l_ime.*

   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <locatorno>", ASCII 10,
        "    <name>LocatorNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ime.ime02 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </locatorno>", ASCII 10,
        "  <inventoryno>", ASCII 10,
        "    <name>InventoryNo</name>", ASCII 10,
        "    <type>Number</type>", ASCII 10,
        "    <value>", l_ime.ime01 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </inventoryno>", ASCII 10,
        "  <creator>", ASCII 10,
        "    <name>Creator</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", g_user CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </creator>", ASCII 10 
     EXIT FOREACH
   END FOREACH
   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION

FUNCTION aws_mescli_EditLocation()
   DEFINE l_xmlbody     STRING
   DEFINE l_i           LIKE type_file.num5

   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <locatorno>", ASCII 10,
        "    <name>LocatorNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", g_key1 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </locatorno>", ASCII 10

   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION

#FUN-950072 ADD --STR----------------------------
FUNCTION aws_mescli_CreateLocation()
   DEFINE l_ime       RECORD LIKE ime_file.*
   DEFINE l_xmlbody   STRING
   DEFINE l_i         LIKE type_file.num5
   DEFINE l_ime02     LIKE ime_file.ime02
   DEFINE l_imd01     LIKE imd_file.imd01
   DEFINE l_ime02_t   LIKE ime_file.ime02
   DEFINE p_str       STRING
   DEFINE p_sep       STRING
   DEFINE p_arr       DYNAMIC ARRAY OF STRING 
   DEFINE l_seplen    LIKE type_file.num5
   DEFINE l_pos       LIKE type_file.num5
   DEFINE l_j         LIKE type_file.num5
   DEFINE l_start     LIKE type_file.num5

   CALL p_arr.clear()
   LET p_str = g_key2
   LET p_sep = '{+}'
   LET l_seplen = p_sep.getLength()
   IF l_seplen = 0 THEN
      LET p_arr[1] = p_str
   END IF

   LET l_j = 1
   LET l_start = 1
   LET l_pos = p_str.getIndexOf(p_sep,1)
   WHILE l_pos > 0
     LET p_arr[l_j] = p_str.subString(l_start,l_pos-1)
     LET l_pos = l_pos + l_seplen
     LET l_start = l_pos
     LET l_pos = p_str.getIndexOf(p_sep,l_pos)
     LET l_j = l_j + 1
   END WHILE

   LET p_arr[l_j] = p_str.subString(l_start,LENGTH(p_str))

   LET l_imd01 = p_arr[1]
   LET l_ime02 = p_arr[2]
   LET l_ime02_t = p_arr[3]
  
  #FUN-9A0056 add begin ---------
  #當舊值為空值時,直接將新值傳入MES作新增
   IF l_ime02_t = ' ' OR cl_null(l_ime02_t) THEN
      LET l_ime02_t = l_ime02
   END IF
  #FUN-9A0056 add end -----------

   LET g_sql = " SELECT * FROM ime_file ",
               "  WHERE ime02 = '",l_ime02,"'",
               "    AND ime01 = '",l_imd01,"'",
                "    AND imeacti = 'Y' "      #FUN-D40103 
   PREPARE xml_pb07 FROM g_sql
   DECLARE xml_curs07
       CURSOR WITH HOLD FOR xml_pb07
   LET l_i = 1
   FOREACH xml_curs07 INTO l_ime.*

   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <locatorno>", ASCII 10,    #儲位編號
        "    <name>LocatorNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ime02_t CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </locatorno>", ASCII 10,
        "  <newlocatorno>", ASCII 10,    #新的儲位編號
        "    <name>NewLocatorNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_ime.ime02 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </newlocatorno>", ASCII 10,
        "  <inventoryno>", ASCII 10,
        "    <name>InventoryNo</name>", ASCII 10,
        "    <type>Number</type>", ASCII 10,
        "    <value>", l_ime.ime01 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </inventoryno>", ASCII 10,
        "  <creator>", ASCII 10,
        "    <name>Creator</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", g_user CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </creator>", ASCII 10 
     EXIT FOREACH
   END FOREACH
   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION
#FUN-950072 ADD --END----------------------------

#FUN-950072 MOD --STR---------------------------
#FUNCTION aws_mescli_DelLocation()
#
#
#   DEFINE l_xmlbody     STRING
#   DEFINE l_i           LIKE type_file.num5
#    
#   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
#        "  <locatorno>", ASCII 10,
#        "    <name>LocatorNo</name>", ASCII 10,
#        "    <type>String</type>", ASCII 10,
#        "    <value>", g_key1 CLIPPED, "</value>", ASCII 10,
#        "    <desc></desc>", ASCII 10,
#        "  </locatorno>", ASCII 10
#
#   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
#                     " </parameter>", ASCII 10,
#                     "</request>", ASCII 10
#
#END FUNCTION
				 
FUNCTION aws_mescli_DelLocation()

   DEFINE l_ime       RECORD LIKE ime_file.*
   DEFINE l_xmlbody   STRING
   DEFINE l_i         LIKE type_file.num5
   DEFINE l_ime02     LIKE ime_file.ime02
   DEFINE l_imd01     LIKE imd_file.imd01
   DEFINE p_str       STRING
   DEFINE p_sep       STRING
   DEFINE p_arr       DYNAMIC ARRAY OF STRING 
   DEFINE l_seplen    LIKE type_file.num5
   DEFINE l_pos       LIKE type_file.num5
   DEFINE l_j         LIKE type_file.num5
   DEFINE l_start     LIKE type_file.num5

   CALL p_arr.clear()
   LET p_str = g_key2
   LET p_sep = '{+}'
   LET l_seplen = p_sep.getLength()
   IF l_seplen = 0 THEN
      LET p_arr[1] = p_str
   END IF

   LET l_j = 1
   LET l_start = 1
   LET l_pos = p_str.getIndexOf(p_sep,1)
   WHILE l_pos > 0
     LET p_arr[l_j] = p_str.subString(l_start,l_pos-1)
     LET l_pos = l_pos + l_seplen
     LET l_start = l_pos
     LET l_pos = p_str.getIndexOf(p_sep,l_pos)
     LET l_j = l_j + 1
   END WHILE

   LET p_arr[l_j] = p_str.subString(l_start,LENGTH(p_str))

   LET l_imd01 = p_arr[1]
   LET l_ime02 = p_arr[2]

   #LET g_sql = " SELECT * FROM ime_file ",
   #            "  WHERE ime02 = '",l_ime02,"'",
   #            "    AND ime01 = '",l_imd01,"'" 
   #PREPARE xml_pb201 FROM g_sql
   #DECLARE xml_curs201
   #    CURSOR WITH HOLD FOR xml_pb201
   #LET l_i = 1
   #FOREACH xml_curs201 INTO l_ime.*
    
     LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
          "  <locatorno>", ASCII 10,
          "    <name>LocatorNo</name>", ASCII 10,
          "    <type>String</type>", ASCII 10,
          "    <value>", l_ime02 CLIPPED, "</value>", ASCII 10,
          "    <desc></desc>", ASCII 10,
          "  </locatorno>", ASCII 10,
          "  <inventoryno>", ASCII 10,
          "    <name>InventoryNo</name>", ASCII 10,
          "    <type>Number</type>", ASCII 10,
          "    <value>", l_imd01 CLIPPED, "</value>", ASCII 10,
          "    <desc></desc>", ASCII 10,
          "  </inventoryno>", ASCII 10
     #EXIT FOREACH
   #END FOREACH

   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION
#FUN-950072 MOD --END--------------------------- 

FUNCTION aws_mescli_AddDepartment()

   DEFINE l_gem         RECORD LIKE gem_file.*
   DEFINE l_xmlbody     STRING
   DEFINE l_i           LIKE type_file.num5

   LET g_sql = " SELECT * FROM gem_file ",
               "  WHERE gem01 = '",g_key1,"'" 
   PREPARE xml_pb23 FROM g_sql
   DECLARE xml_curs23
       CURSOR WITH HOLD FOR xml_pb23
   LET l_i = 1
   FOREACH xml_curs23 INTO l_gem.*
    
   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <departmentno>", ASCII 10,
        "    <name>DepartmentNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_gem.gem01 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </departmentno>", ASCII 10,
        "  <departmentname>", ASCII 10,
        "    <name>DepartmentName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        #"    <value>", l_gem.gem02 CLIPPED, "</value>", ASCII 10,  #TQC-930057
        "    <value>", l_gem.gem03 CLIPPED, "</value>", ASCII 10, #TQC-930057 ADD
        "    <desc></desc>", ASCII 10,
        "  </departmentname>", ASCII 10,
        "  <departmentsname>", ASCII 10,
        "    <name>DepartmentSName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        #"    <value></value>", ASCII 10,   #TQC-930057 MARK
        "    <value>", l_gem.gem02 CLIPPED, "</value>", ASCII 10,  #TQC-930057 ADD
        "    <desc></desc>", ASCII 10,
        "  </departmentsname>", ASCII 10,
        "  <creator>", ASCII 10,
        "    <name>Creator</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", g_user CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </creator>", ASCII 10 
   END FOREACH
   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION

FUNCTION aws_mescli_EditDepartment()

   DEFINE l_gem         RECORD LIKE gem_file.*
   DEFINE l_xmlbody     STRING
   DEFINE l_i           LIKE type_file.num5

   LET g_sql = " SELECT * FROM gem_file ",
               "  WHERE gem01 = '",g_key1,"'" 
   PREPARE xml_pb24 FROM g_sql
   DECLARE xml_curs24
       CURSOR WITH HOLD FOR xml_pb24
   LET l_i = 1
   FOREACH xml_curs24 INTO l_gem.*
    
   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <departmentno>", ASCII 10,
        "    <name>DepartmentNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_gem.gem01 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </departmentno>", ASCII 10,
        "  <departmentname>", ASCII 10,
        "    <name>DepartmentName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        #"    <value>", l_gem.gem02 CLIPPED, "</value>", ASCII 10,  #TQC-930057 MARK
        "    <value>", l_gem.gem03 CLIPPED, "</value>", ASCII 10, #TQC-930057 ADD
        "    <desc></desc>", ASCII 10,
        "  </departmentname>", ASCII 10,
        "  <departmentsname>", ASCII 10,
        "    <name>DepartmentSName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        #"    <value></value>", ASCII 10,   #TQC-930057 MARK
        "    <value>", l_gem.gem02 CLIPPED, "</value>", ASCII 10,  #TQC-930057 ADD
        "    <desc></desc>", ASCII 10,
        "  </departmentsname>", ASCII 10
   END FOREACH
   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION

#FUN-950072 ADD --STR-----------------------
FUNCTION aws_mescli_CreateDepartment()

   DEFINE l_gem         RECORD LIKE gem_file.*
   DEFINE l_xmlbody     STRING
   DEFINE l_i           LIKE type_file.num5

   LET g_sql = " SELECT * FROM gem_file ",
               "  WHERE gem01 = '",g_key1,"'" 
   PREPARE xml_pb08 FROM g_sql
   DECLARE xml_curs08
       CURSOR WITH HOLD FOR xml_pb08
   LET l_i = 1
   FOREACH xml_curs08 INTO l_gem.*
    
   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <departmentno>", ASCII 10,
        "    <name>DepartmentNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_gem.gem01 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </departmentno>", ASCII 10,
        "  <departmentname>", ASCII 10,
        "    <name>DepartmentName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_gem.gem03 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </departmentname>", ASCII 10,
        "  <departmentsname>", ASCII 10,
        "    <name>DepartmentSName</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", l_gem.gem02 CLIPPED, "</value>", ASCII 10, 
        "    <desc></desc>", ASCII 10,
        "  </departmentsname>", ASCII 10,
        "  <creator>", ASCII 10,
        "    <name>Creator</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", g_user CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </creator>", ASCII 10 
   END FOREACH
   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION
#FUN-950072 ADD --END-----------------------

FUNCTION aws_mescli_DelDepartment()

   DEFINE l_gem         RECORD LIKE gem_file.*
   DEFINE l_xmlbody     STRING
   DEFINE l_i           LIKE type_file.num5

   LET l_xmlbody = l_xmlbody CLIPPED,  ASCII 10,
        "  <departmentno>", ASCII 10,
        "    <name>DepartmentNo</name>", ASCII 10,
        "    <type>String</type>", ASCII 10,
        "    <value>", g_key1 CLIPPED, "</value>", ASCII 10,
        "    <desc></desc>", ASCII 10,
        "  </departmentno>", ASCII 10

   LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, ASCII 10,
                     " </parameter>", ASCII 10,
                     "</request>", ASCII 10

END FUNCTION

#FUN-8A0046---add---end---

#------------------------------------------------------------------------------
# Generate XML Request Body 
#------------------------------------------------------------------------------
FUNCTION aws_mescli_CreateMaterialData()

    DEFINE l_ima         RECORD LIKE ima_file.*

    LET g_vnode = g_unode.createChild('Master')
    CALL g_vnode.setAttribute('name', 'ima_file')
    LET g_wnode = g_vnode.createChild('Record')
    
    INITIALIZE l_ima.* TO NULL
    SELECT * INTO l_ima.* FROM ima_file WHERE ima01=g_key1  

    LET g_xnode = g_wnode.createChild('Field')
    CALL g_xnode.setAttribute('name', 'ima01')
    CALL g_xnode.setAttribute('value', l_ima.ima01)

    LET g_xnode = g_wnode.createChild('Field')
    CALL g_xnode.setAttribute('name', 'ima02')
    CALL g_xnode.setAttribute('value', l_ima.ima02)

END FUNCTION
						  
#FUN-950072 MARK --STR--------------------
#FUNCTION aws_mescli_CreateMO()
#
#    DEFINE l_sfb         RECORD LIKE sfb_file.*
#    DEFINE l_sfa         RECORD LIKE sfa_file.*
#    DEFINE l_cnt         LIKE type_file.num5
#
#    LET g_vnode = g_unode.createChild('Master')
#    CALL g_vnode.setAttribute('name', 'sfb_file')
#    LET g_wnode = g_vnode.createChild('Record')
#    
#    INITIALIZE l_sfb.* TO NULL
#    SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01=g_key1  
#
#    LET g_xnode = g_wnode.createChild('Field')
#    CALL g_xnode.setAttribute('name', 'sfb01')
#    CALL g_xnode.setAttribute('value', l_sfb.sfb01)
#
#    LET g_xnode = g_wnode.createChild('Field')
#    CALL g_xnode.setAttribute('name', 'sfb02')
#    CALL g_xnode.setAttribute('value', l_sfb.sfb02)
# 
#    LET l_cnt=0
#    DECLARE mescli_sfa_cs CURSOR FOR
#      SELECT * FROM sfa_file WHERE sfa01=g_key1
#    FOREACH mescli_sfa_cs INTO l_sfa.*
#       LET l_cnt=l_cnt+1
#       IF l_cnt=1 THEN
#          LET g_vnode = g_unode.createChild('Detail')
#          CALL g_vnode.setAttribute('name', 'sfa_file')
#       END IF
#       LET g_wnode = g_vnode.createChild('Record')
#       LET g_xnode = g_wnode.createChild('Field')
#       CALL g_xnode.setAttribute('name', 'sfa01')
#       CALL g_xnode.setAttribute('value', l_sfa.sfa01)
#
#       LET g_xnode = g_wnode.createChild('Field')
#       CALL g_xnode.setAttribute('name', 'sfa03')
#       CALL g_xnode.setAttribute('value', l_sfa.sfa03)
#
#       LET g_xnode = g_wnode.createChild('Field')
#       CALL g_xnode.setAttribute('name', 'sfa08')
#       CALL g_xnode.setAttribute('value', l_sfa.sfa08)
#
#       LET g_xnode = g_wnode.createChild('Field')
#       CALL g_xnode.setAttribute('name', 'sfa12')
#       CALL g_xnode.setAttribute('value', l_sfa.sfa12)
#
#       LET g_xnode = g_wnode.createChild('Field')
#       CALL g_xnode.setAttribute('name', 'sfa27')
#       CALL g_xnode.setAttribute('value', l_sfa.sfa27)
#
#    END FOREACH
#
#END FUNCTION
#FUN-950072 MARK --END------------------------

FUNCTION aws_mescli_CreateDispatch()

    DEFINE l_sfp         RECORD LIKE sfp_file.*
    DEFINE l_sfs         RECORD LIKE sfs_file.*
    DEFINE l_cnt         LIKE type_file.num5

    LET g_vnode = g_unode.createChild('Master')
    CALL g_vnode.setAttribute('name', 'sfp_file')
    LET g_wnode = g_vnode.createChild('Record')
    
    INITIALIZE l_sfp.* TO NULL
    SELECT * INTO l_sfp.* FROM sfp_file WHERE sfp01=g_key1  

    LET g_xnode = g_wnode.createChild('Field')
    CALL g_xnode.setAttribute('name', 'sfp01')
    CALL g_xnode.setAttribute('value', l_sfp.sfp01)

    LET g_xnode = g_wnode.createChild('Field')
    CALL g_xnode.setAttribute('name', 'sfp02')
    CALL g_xnode.setAttribute('value', l_sfp.sfp02)
 
    LET l_cnt=0
    DECLARE mescli_sfs_cs CURSOR FOR
      SELECT * FROM sfs_file WHERE sfs01=g_key1
    FOREACH mescli_sfs_cs INTO l_sfs.*
       LET l_cnt=l_cnt+1
       IF l_cnt=1 THEN
          LET g_vnode = g_unode.createChild('Detail')
          CALL g_vnode.setAttribute('name', 'sfs_file')
       END IF
       LET g_wnode = g_vnode.createChild('Record')
       LET g_xnode = g_wnode.createChild('Field')
       CALL g_xnode.setAttribute('name', 'sfs01')
       CALL g_xnode.setAttribute('value', l_sfs.sfs01)

       LET g_xnode = g_wnode.createChild('Field')
       CALL g_xnode.setAttribute('name', 'sfs02')
       CALL g_xnode.setAttribute('value', l_sfs.sfs02)

    END FOREACH

END FUNCTION
#------------------------------------------------------------------------------
# DOM to xml string
#------------------------------------------------------------------------------
FUNCTION aws_mescli_processRequest()
    DEFINE l_msg      STRING
    DEFINE l_status   STRING
    DEFINE l_ch       base.Channel
    DEFINE l_buf      STRING
    DEFINE l_i        LIKE type_file.num10
    DEFINE l_file     STRING
    DEFINE l_handle   om.SaxDocumentHandler

    LET l_file = fgl_getenv("TEMPDIR"), "/", fgl_getpid() USING '<<<<<<<<<<', ".xml"
    LET l_handle = om.XmlWriter.createFileWriter(l_file)
    CALL l_handle.setIndent(FALSE)
    #CALL g_rnode.write(l_handle)  #FUN-870151 mark
    #CALL g_rnode.writeXml(l_file)
    LET l_ch = base.Channel.create()
    CALL l_ch.openFile(l_file, "r")
    CALL l_ch.setDelimiter(NULL)
    LET l_i = 1
    WHILE l_ch.read(l_buf)
        IF l_i != 1 THEN
            LET g_strXMLInput = g_strXMLInput, '\n'
        END IF
        LET g_strXMLInput = g_strXMLInput, l_buf CLIPPED
        LET l_i = l_i + 1
    END WHILE
    CALL l_ch.close()
   #RUN "\rm -f " || l_file  #FUN-B60041 mark
    RUN "rm -f " || l_file || " >/dev/null 2>&1"  #FUN-B60041 add

END FUNCTION

#------------------------------------------------------------------------------
# get response xml string and parsing xml content
#------------------------------------------------------------------------------
FUNCTION aws_mescli_processResult(p_showmsg)
    DEFINE p_showmsg    LIKE type_file.num5
    DEFINE l_ch         base.Channel
    DEFINE l_file       STRING
    DEFINE l_doc        om.DomDocument
    DEFINE l_node_list  om.NodeList
    DEFINE l_snode      om.DomNode
    DEFINE l_str        STRING
    DEFINE l_result     STRING  #FUN-8A0046 add
    DEFINE l_result1    STRING  #FUN-8A0046 add
    DEFINE ln_node      om.DomNode

    #--------------------------------------------------------------------------
    # generate temp xml file
    #--------------------------------------------------------------------------
   #FUN-8A0046---mod---str---
   #LET l_file = fgl_getenv("TEMPDIR"), "/", fgl_getpid() USING '<<<<<<<<<<', ".xml"
   #LET l_ch = base.Channel.create()
   #CALL l_ch.openFile(l_file, "w")
   #CALL l_ch.setDelimiter(NULL)
   #CALL l_ch.write(g_result)
   #CALL l_ch.close()

   #LET l_doc = om.DomDocument.createFromXmlFile(l_file)
   #RUN "rm -f " || l_file
   #IF l_doc IS NULL THEN
   #      CALL cl_err(l_doc, 'IS NULL', 1)   #....
   #END IF
   #
   #LET g_result_xml = l_doc.getDocumentElement()

   #LET l_node_list = g_result_xml.selectByTagName("Status")
   #LET l_snode = l_node_list.item(1)
   #LET g_result_value = l_snode.getAttribute("result")
   #LET g_result_value = g_result_value.trim()
   #LET g_result_desc = l_snode.getAttribute("desc")
   #LET g_result_desc = g_result_desc.trim()
    
   #CASE g_result_value
   #    WHEN 'true'
   #        LET g_status = 1
   #    WHEN 'false'
   #        LET g_status = 0
   #    OTHERWISE
   #        LET g_status = -1
   #END CASE
    
   #jamie
    LET g_result_desc = ''
    LET g_result_value = aws_xml_getTag(g_result,"result")

    CASE g_result_value
        WHEN 'success'
            LET g_status = 1
        WHEN 'fail'
            LET g_status = 0
        OTHERWISE
            LET g_status = -1
    END CASE

    CASE g_status
        WHEN 1  #success
            IF NOT cl_null(aws_xml_getTag(g_result,"mtype")) THEN
               LET g_result_desc = aws_xml_getTag(g_result,"mtype") CLIPPED
            END IF 
            IF NOT cl_null(aws_xml_getTag(g_result,"mmsg")) THEN 
               LET g_result_desc = g_result_desc,aws_xml_getTag(g_result,"mmsg") CLIPPED
            END IF 
        WHEN 0  #fail
            IF NOT cl_null(aws_xml_getTag(g_result,"sysmsg")) THEN
               LET g_result_desc = aws_xml_getTag(g_result,"sysmsg") CLIPPED
            END IF 
            IF NOT cl_null(aws_xml_getTag(g_result,"mesmsg")) THEN 
               LET g_result_desc = g_result_desc,aws_xml_getTag(g_result,"mesmsg") CLIPPED
            END IF 
    END CASE

   #FUN-8A0046---mod---end---

    IF p_showmsg != 1 THEN
        LET p_showmsg = 0
    END IF
         
    IF g_status = -1 THEN
        IF fgl_getenv('FGLGUI') = '1' THEN
              LET l_str = "MES return error:\n\n", g_result_desc                   
        ELSE
              LET l_str = "MES return error: ", g_result_desc                      
        END IF

        IF g_bgjob='N' OR cl_null(g_bgjob) THEN   #FUN-C10035 add
           CALL cl_err(l_str, '!', 1)    #MES Server return except
       #FUN-C10035 add str ----
        ELSE
           CALL cl_err(l_str, '!',0)
        END IF
       #FUN-C10035 add end ----

    ELSE
        LET l_str = g_result_desc     
       # ...........

       #CALL cl_err(l_str, '!', p_showmsg)        #FUN-C10035 mark
        IF g_bgjob='N' OR cl_null(g_bgjob) THEN   #FUN-C10035 add
           CALL cl_err(l_str, '!', 1)
       #FUN-C10035 add str ----
        ELSE
           CALL cl_err(l_str, '!',0)
        END IF
       #FUN-C10035 add end ----        
        
       #CALL FGL_WINMESSAGE(g_result_value, g_result_desc, "ok")
        
    END IF
END FUNCTION

FUNCTION aws_mescli_siteinfo()
    DEFINE l_code  LIKE type_file.num5
    DEFINE l_wge02 LIKE wge_file.wge02
    DEFINE l_wge03 LIKE wge_file.wge03    
    DEFINE l_wge08 LIKE wge_file.wge08
    #DEFINE l_zx10  LIKE zx_file.zx10   #FUN-910092
    
    LET l_code = 1
    
    SELECT wge02,wge03,wge08 INTO l_wge02,l_wge03,l_wge08
      FROM wge_file WHERE wge01 = 'M' AND wge06 = g_plant
        AND wge05 = '*' AND wge07 = '*'
    IF l_wge02 IS NULL THEN
        IF g_bgjob='N' OR cl_null(g_bgjob) THEN   #FUN-C10035 add
           CALL cl_err3('sel','wge_file',g_plant,'',100,'','',1)
        #FUN-C10035 add str ----
        ELSE
           CALL cl_err3('sel','wge_file',g_plant,'',100,'','',0)
        END IF
        #FUN-C10035 add end ----
        LET l_code = 0
        RETURN l_code
    ELSE
        LET g_messoap = l_wge03 CLIPPED       #MES SOAP URL
        LET g_messiteip = l_wge02 CLIPPED     #MES Server IP
        LET g_meshttp = l_wge08 CLIPPED       #MES HTTP URL
    END IF
   
    #FUN-910092 --start 
    #SELECT zx10 INTO l_zx10 FROM zx_file WHERE zx010 = g_user
    #IF l_zx10 IS NULL THEN
    #    CALL cl_err3('sel','zx_file',g_user,'',100,'','',1)
    #    LET l_code = 0
    #     RETURN l_code
    #ELSE
    #    LET g_passwd = l_zx10 CLIPPED #User Password
    #END IF
    #FUN-910092 --end 
    
    LET g_client = cl_getClientIP()       #Client IP
    RETURN l_code
END FUNCTION

#------------------------------------------------------------------------------
# write xml to log
#------------------------------------------------------------------------------
FUNCTION aws_mescli_logfile()
    DEFINE l_str    STRING
    DEFINE l_file   STRING
    DEFINE l_cmd    STRING
    DEFINE l_ch     base.Channel
    
    LET l_file = fgl_getenv("TEMPDIR"), "/aws_mescli-", TODAY USING 'YYYYMMDD', ".log"
    LET l_ch = base.Channel.create()
    CALL l_ch.openFile(l_file, "a")
    CALL l_ch.setDelimiter("")
    IF STATUS = 0 THEN
        LET l_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
        CALL l_ch.write(l_str)
        CALL l_ch.write("")
        LET l_str = "Program: ", g_prog CLIPPED
        CALL l_ch.write(l_str)
        
        CALL l_ch.write("Request XML:")
        CALL l_ch.write(g_strXMLInput)
        CALL l_ch.write("")
        
        CALL l_ch.write("Response XML:")
        #No:TQC-760018 --start--
        IF g_ws_status = 0 THEN
            CALL l_ch.write(g_result)
            CALL l_ch.write("")
        ELSE
            CALL l_ch.write("")
            IF fgl_getenv('FGLGUI') = '1' THEN
                LET l_str = "   Connection failed:\n\n",
                            "     [Code]: ", wserror.code, "\n",
                            "     [Action]: ", wserror.action, "\n",
                            "     [Description]: ", wserror.description
            ELSE
                LET l_str = "   Connection failed: ", wserror.description
            END IF
            CALL l_ch.write(l_str)
            CALL l_ch.write("")
        END IF
        CALL l_ch.write("#------------------------------------------------------------------------------#")
        CALL l_ch.write("")
        CALL l_ch.write("")
        CALL l_ch.close()
        
        LET l_cmd = "chmod 666 ", l_file CLIPPED, " >/dev/null 2>&1"
        RUN l_cmd
    ELSE
        DISPLAY "Can't open log file."
    END IF
END FUNCTION
#FUN-B70079
