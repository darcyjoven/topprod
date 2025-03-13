# Prog. Version..: '5.30.06-13.03.15(00008)'     #
 
# Program name...: cl_fld_doc.4gl
# Descriptions...: Document Management for Form Field(image updated for case)
# Usage..........: CALL cl_fld_doc("ima01")
#                    - Update image binary for this form field
#                  CALL cl_get_fld_doc("ima01")
#                    - Get location for field image(display purpose)
#                  CALL cl_get_fld_pic("ima01","001","ima04","2")
#                    - Get picture location to print
# Date & Author..: 04/07/21 by Brendan
# Modify.........: No.FUN-650080 06/05/26 by Alexstar 新增圖片列印準備功能
# Modify.........: No.TQC-660041 06/06/26 by Alexstar 新增直接刪除圖片相關資料的功能
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-640161 07/01/16 By yiting  cl_err->cl_err3
# Modify.........: No.FUN-780051 07/08/20 By Brendan 新增批次匯入呼叫功能
# Modify.........: No.FUN-790020 07/09/11 By Brendan 修正 GP 5X Primary Key 功能無法新增相關文件
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-890210 08/09/22 By wujie 復制新料件，刪除新料件，舊料件的圖片會被刪除
# Modify.........: No.FUN-B30128 11/03/17 By tsai_yen 觸控
# Modify.........: No.FUN-B50108 11/05/18 By Kevin 維護function的資訊(p_findfunc)
# Modify.........: No.FUN-C40104 12/06/25 By madey 設定action=delete defaultView=yes

DATABASE ds
 
GLOBALS "../../config/top.global"  #FUN-7C0053
 
DEFINE gr_gca        RECORD LIKE gca_file.*,
       gr_gcb        RECORD LIKE gcb_file.*
DEFINE gr_gca_t      RECORD LIKE gca_file.*,
       gr_gcb_t      RECORD LIKE gcb_file.*
DEFINE gs_wc         STRING,
       gs_tempdir    STRING,
       gs_fglasip    STRING
DEFINE gr_key        RECORD
                        gca01 LIKE gca_file.gca01,
                        gca02 LIKE gca_file.gca02,
                        gca03 LIKE gca_file.gca03,
                        gca04 LIKE gca_file.gca04,
                        gca05 LIKE gca_file.gca05
                     END RECORD
DEFINE gs_field      STRING,
       gs_mode       STRING,
       gs_location   STRING
DEFINE gn_node       om.DomNode
DEFINE gi_maintain    LIKE type_file.num10   #No.FUN-690005 INTEGER
DEFINE gi_picPrint    LIKE type_file.num5    #No.FUN-690005 SMALLINT   #FUN-650080
DEFINE gi_printSource LIKE type_file.chr1    #No.FUN-690005 VARCHAR(1)   #FUN-650080
DEFINE gi_slient_mode LIKE type_file.num5    #No.FUN-780051
 
 
# Descriptions...: Document Management for Form Field(image updated for case)
# Input Parameter: ps_field STRING  Name for a Form Field
# Return code....: url STRING       URL location for display purpose
# Date & Author..: 2004/07/21 by Brendan
 
FUNCTION cl_fld_doc(ps_field)
 
  DEFINE ps_field   STRING
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  IF NOT cl_fieldDocumentPrepare(ps_field) THEN
     RETURN
  END IF
 
  LET gi_maintain = TRUE
  IF NOT cl_getFieldDocument() THEN
     CALL cl_err(NULL, "lib-211", 1)
     RETURN
  END IF
 
  IF NOT cl_maintainFieldDocument() THEN
     RETURN
  END IF
 
  #--If user choose "delete" action, then remove record from DB
  #--Otherwise, update new record
  CASE gs_mode
       WHEN "delete"
            IF NOT cl_removeFieldDocumentRecord() THEN
               #CALL cl_err(NULL, "lib-207", 1)
               CALL cl_err3("del","","","","lib-207","","NULL",0)   #No.FUN-640161
            ELSE
               CALL gn_node.setAttribute("value", NULL)
            END IF
            RETURN
       OTHERWISE
            IF NOT cl_maintainFieldDocumentRecord() THEN
               CALL cl_err(NULL, "lib-209", 1)
               RETURN
            END IF
       
  END CASE
  #--
 
  IF cl_getFieldDocumentLocation() THEN
     #--Before display new one to the field, clear "value" first to force re-show the photo later
     IF gs_mode = "modify" THEN
        CALL gn_node.setAttribute("value", NULL)
     END IF
     #--
     CALL gn_node.setAttribute("value", gs_location)
  END IF
END FUNCTION
 
 
#-- No.FUN-780051 BEGIN --------------------------------------------------------
 
# Descriptions...: 新增欄位圖檔功能(批次匯入時呼叫, 需直接指定圖檔路徑)
# Memo...........: 呼叫範例 - CALL cl_fld_doc_s("ima04", "C:/TIPTOP/logo.jpg")
# Input Parameter: ps_field STRING
#                   - 圖檔欄位名稱
#                  ps_location STRING
#                   - 指定檔案路徑(*** 注意, 目前檔案需在 client 端上 ***)
# Return code....: TRUE / FALSE
#                   - 新增圖檔資料成功 or 失敗
# Date & Author..: 2007/08/20 by Brendan
 
FUNCTION cl_fld_doc_s(ps_field, ps_location)
  DEFINE ps_field      STRING,
         ps_location   STRING
 
 
  LET gi_slient_mode = TRUE
 
  IF NOT cl_fieldDocumentPrepare(ps_field) THEN
     LET gi_slient_mode = FALSE
     RETURN FALSE
  END IF
 
  LET gi_maintain = TRUE
  IF NOT cl_getFieldDocument() THEN
     LET gi_slient_mode = FALSE
     RETURN FALSE
  END IF
 
  LET gs_location = ps_location CLIPPED  # ***注意, 傳入檔案需在 client 端 ***
 
  IF NOT cl_maintainFieldDocumentRecord() THEN
     LET gi_slient_mode = FALSE
     RETURN FALSE
  END IF
 
  LET gi_slient_mode = FALSE
  RETURN TRUE
END FUNCTION
#-- No.FUN-780051 END ----------------------------------------------------------
 
 
# Descriptions...: Document Management for Form Field(image updated for case)
# Input Parameter: ps_field STRING
#                   - Name for a Form Field
# Return code....: url STRING
#                   - URL location for display purpose
# Date & Author..: 2004/07/29 by Brendan
 
FUNCTION cl_get_fld_doc(ps_field)
  DEFINE ps_field   STRING
 
 
  IF NOT cl_fieldDocumentPrepare(ps_field) THEN
     RETURN
  END IF
 
  CALL gn_node.setAttribute("value", NULL)
 
  LET gi_maintain = FALSE
  IF NOT cl_getFieldDocument() THEN
#    CALL cl_err(NULL, "lib-211", 1)
     RETURN
  END IF
 
  IF cl_getFieldDocumentLocation() THEN
     CALL gn_node.setAttribute("value", gs_location)
  END IF
END FUNCTION
 
#FUN-650080---start
 
# Descriptions...: Get Picture to print(Use By Report Function)
# Input Parameter: key_Field STRING
#                   - Column for a Form KeyField
#                  key_Value STRING
#                   - Value of KeyField
#                  pic_Field VARCHAR
#                   - Field of pictureLocation
#                  SourceStyle VARCHAR(1)
#                   - File Location from client(2) or server(1)
# Return code....: url STRING
#                   - URL location for Print purpose
# Date & Author..: 2006/06/05 by Alexstar
 
FUNCTION cl_get_fld_pic(key_Field, key_Value, pic_Field, SourceStyle)
  DEFINE key_Field     STRING
  DEFINE key_Value     STRING
  DEFINE pic_Field     STRING
  DEFINE SourceStyle   LIKE type_file.chr1    #No.FUN-690005 VARCHAR(1)
 
  LET g_doc.column1 = key_Field
  LET g_doc.value1  = key_Value
  LET gi_picPrint=1
  LET gi_printSource = SourceStyle
 
  IF NOT cl_fieldDocumentPrepare(pic_Field) THEN
     RETURN ""
  END IF
 
  LET gi_maintain = FALSE
  IF NOT cl_getFieldDocument() THEN
#    CALL cl_err(NULL, "lib-211", 1)
     RETURN ""
  END IF
 
  IF cl_getFieldDocumentLocation() THEN
     RETURN gs_location
  ELSE
     RETURN ""
  END IF
END FUNCTION
#FUN-650080---end---
 
# Private Func...: TRUE              #FUN-B50108
# Descriptions...: 
# Input Parameter: ps_field   STRING 
# Return code....: TRUE/FALSE 
 
FUNCTION cl_fieldDocumentPrepare(ps_field)
  DEFINE ps_field   STRING
  DEFINE lw_curr    ui.Window
  DEFINE lf_curr    ui.Form
  DEFINE ll_node    om.NodeList
  DEFINE ln_form    om.DomNode
 
 
  LET gs_tempdir = FGL_GETENV("TEMPDIR")
  LET gs_fglasip = FGL_GETENV("FGLASIP")
  LET gs_field = ps_field CLIPPED
 
  #--Compose KEY value
  LET gr_key.gca01 = g_doc.column1 CLIPPED || "=" || g_doc.value1 CLIPPED
  LET gr_key.gca02 = g_doc.column2 CLIPPED || "=" || g_doc.value2 CLIPPED
  LET gr_key.gca03 = g_doc.column3 CLIPPED || "=" || g_doc.value3 CLIPPED
  LET gr_key.gca04 = g_doc.column4 CLIPPED || "=" || g_doc.value4 CLIPPED
  LET gr_key.gca05 = g_doc.column5 CLIPPED || "=" || g_doc.value5 CLIPPED
  #--
 
  #--Getting Dom Node for the dedicated field
  IF ( gi_picPrint = FALSE ) OR ( gi_slient_mode = FALSE ) THEN  #FUN-650080, FUN-780051
     LET lw_curr = ui.Window.getCurrent()
     LET lf_curr = lw_curr.getForm()
     LET ln_form = lf_curr.getNode()
     LET ll_node = ln_form.selectByPath("//FormField[@colName=\"" || gs_field || "\"]")
     IF ll_node.getLength() != 0 THEN
        LET gn_node = ll_node.item(1)
     ELSE
        RETURN FALSE
     END IF
  END IF
  #--
  
  RETURN TRUE
END FUNCTION
 
# Private Func...: TRUE
# Descriptions...: 
# Input Parameter: none
# Return code....: 
 
FUNCTION cl_getFieldDocument()
  DEFINE ls_sql   STRING
 
 
  #--Compose WHERE condition for document selection
  LET gs_wc = "gca01 = '", gr_key.gca01 CLIPPED, "'"
  #-- No.FUN-790020 BEGIN ------------------------------------------------------
  # Primary Key 不允許塞入 NULL, 故以空白替代
  #-----------------------------------------------------------------------------
  IF NOT cl_null(gr_key.gca02) THEN
     LET gs_wc = gs_wc, " AND gca02 = '", gr_key.gca02 CLIPPED, "'"
  ELSE
     LET gs_wc = gs_wc, " AND gca02 = ' '"
  END IF
  IF NOT cl_null(gr_key.gca03) THEN
     LET gs_wc = gs_wc, " AND gca03 = '", gr_key.gca03 CLIPPED, "'"
  ELSE
     LET gs_wc = gs_wc, " AND gca03 = ' '"
  END IF
  IF NOT cl_null(gr_key.gca04) THEN
     LET gs_wc = gs_wc, " AND gca04 = '", gr_key.gca04 CLIPPED, "'"
  ELSE
     LET gs_wc = gs_wc, " AND gca04 = ' '"
  END IF
  IF NOT cl_null(gr_key.gca05) THEN
     LET gs_wc = gs_wc, " AND gca05 = '", gr_key.gca05 CLIPPED, "'"
  ELSE
     LET gs_wc = gs_wc, " AND gca05 = ' '"
  END IF
  #-- No.FUN-790020 END --------------------------------------------------------
  LET ls_sql = "SELECT gca_file.* FROM gca_file WHERE ", gs_wc, 
               " AND gca08 = 'FLD'",
               " AND gca09 = '", gs_field, "'",
               " AND gca11 = 'Y'"
  #--
 
  PREPARE fld_doc_pre FROM ls_sql
  IF SQLCA.SQLCODE THEN
     CALL cl_err("prepare fld_doc_cur: ", SQLCA.SQLCODE, 0)
     RETURN FALSE
  END IF
 
  #--Determine if "new adding" or "update existing" mode
  EXECUTE fld_doc_pre INTO gr_gca.* 
  IF ( SQLCA.SQLCODE ) AND ( NOT gi_maintain ) THEN
     RETURN FALSE
  END IF
  CASE SQLCA.SQLCODE
       WHEN 0
            LET gs_mode = "modify"
       WHEN NOTFOUND
            LET gs_mode = "insert"
            INITIALIZE gr_gca.* TO NULL
            INITIALIZE gr_gcb.* TO NULL
       OTHERWISE
            CALL cl_err3("sel","gca_file","","",SQLCA.sqlcode,"","",0)   #No.FUN-640161
            #CALL cl_err("select gca_file: ", SQLCA.SQLCODE, 0)
            RETURN FALSE
  END CASE
  #--
 
  #--Select document information(detail)
  IF gs_mode = "modify" THEN
     LOCATE gr_gcb.gcb09 IN MEMORY
     SELECT gcb_file.* INTO gr_gcb.* FROM gcb_file 
      WHERE gcb01 = gr_gca.gca07 AND
            gcb02 = gr_gca.gca08 AND
            gcb03 = gr_gca.gca09 AND
            gcb04 = gr_gca.gca10
     FREE gr_gcb.gcb09
     IF SQLCA.SQLCODE THEN
        CALL cl_err3("sel","gcb_file","","",SQLCA.sqlcode,"","",0)   #No.FUN-640161
        #CALL cl_err("select gcb_file: ", SQLCA.SQLCODE, 0)
        RETURN FALSE
     END IF
  END IF
  #--
 
  RETURN TRUE
END FUNCTION
 
# Private Func...: TRUE
# Descriptions...: 
# Input Parameter: none
# Return code....: 
 
FUNCTION cl_maintainFieldDocument()
  DEFINE ls_str        STRING,
         ls_file       STRING,
         ls_location   STRING
  #FUN-C40104 --start--
  DEFINE llst_items    om.NodeList,
         li_j          LIKE type_file.num5,
         lnode_item    om.DomNode,
         lnode_root    om.DomNode,
         ls_item_name  STRING
  #FUN-C40104 --end--
  DEFINE   li_test    STRING
 
 
  #--If maintain is "modify" and existing document location is a URL, then let as default location in the prompt window
  IF ( gs_mode = "modify" ) AND ( NOT cl_null(gr_gcb.gcb10) ) THEN
     LET gs_location = gr_gcb.gcb10
  ELSE
     LET gs_location = NULL
  END IF 
  #--
 
  #--"insert" mode only needs "browser" action
  #--"modify" mode needs "browser" and "delete" action
  LET ls_str = cl_getmsg("lib-201", g_lang)
  WHILE TRUE
      LET ls_location = gs_location
      CASE gs_mode
           WHEN "insert"
                PROMPT ls_str CLIPPED FOR gs_location
                    ATTRIBUTE(WITHOUT DEFAULTS)
  
                    ON ACTION accept
                        IF NOT cl_null(gs_location) THEN
                           EXIT WHILE
                        END IF
  
                    ON ACTION cancel
                        LET gs_location = ls_location
                        EXIT WHILE
  
                    ON ACTION browse_document
                        LET ls_file = cl_browse_file()
                        IF ls_file IS NOT NULL THEN
                           LET gs_location = ls_file
                        END IF
  
                    ON IDLE g_idle_seconds
                        CALL cl_on_idle()
                        LET gs_location = ls_location
                        RETURN FALSE
  
                END PROMPT
 
           WHEN "modify"
                #FUN-C40104 -- start --
                LET ls_item_name = ""
                LET lnode_root = ui.Interface.getRootNode()
                LET llst_items = lnode_root.selectByTagName("ActionDefault")
                FOR li_j = 1 TO llst_items.getLength()
                    LET lnode_item = llst_items.item(li_j)
                    LET ls_item_name = lnode_item.getAttribute("name")
                    IF ls_item_name = "delete" THEN
                       LET li_test = lnode_item.getAttribute("delete")
                       CALL lnode_item.setAttribute("defaultView", "yes")
                       LET li_test = lnode_item.getAttribute("delete")
                       EXIT FOR
                    END IF
                END FOR
                #FUN-C40104 -- end --

                PROMPT ls_str CLIPPED FOR gs_location
                    ATTRIBUTE(WITHOUT DEFAULTS)
                                        
                    ON ACTION delete
                        IF cl_delete() THEN
                           LET gs_mode = "delete"
                           CALL lnode_item.setAttribute("defaultView", "auto")#FUN-C40104 
                           EXIT WHILE
                        END IF
 
     
                    ON ACTION accept
                        IF NOT cl_null(gs_location) THEN
                           EXIT WHILE
                        END IF
  
                    ON ACTION cancel
                        LET gs_location = ls_location
                        EXIT WHILE
  
                    ON ACTION browse_document
                        LET ls_file = cl_browse_file()
                        IF ls_file IS NOT NULL THEN
                           LET gs_location = ls_file
                        END IF
  
  
                    ON IDLE g_idle_seconds
                        CALL cl_on_idle()
                        LET gs_location = ls_location
                        RETURN FALSE
  
                END PROMPT
      END CASE
  END WHILE
  #--
 
  IF INT_FLAG THEN
     LET INT_FLAG = FALSE
     RETURN FALSE
  END IF
 
  RETURN TRUE
END FUNCTION
 
# Private Func...: TRUE
# Descriptions...: 
# Input Parameter: none
# Return code....: 
 
FUNCTION cl_maintainFieldDocumentRecord()
  DEFINE li_status     LIKE type_file.num10,  #No.FUN-690005 INTEGER,
         li_min        LIKE type_file.num10   #No.FUN-690005 INTEGER
  DEFINE ls_msg        STRING,
         ls_sql        STRING,
         ls_docNum     STRING,
         ls_time       STRING,
         ls_fname      STRING,
         ls_location   STRING
 
 
  CASE gs_mode
       WHEN "insert"
            #--Sequence for field document is begin with negative and so on
            PREPARE min_pre FROM "SELECT MIN(gca06) - 1 FROM gca_file WHERE " || gs_wc
            EXECUTE min_pre INTO li_min
            IF SQLCA.SQLCODE THEN
               #CALL cl_err("select min(gca06): ", SQLCA.SQLCODE, 0)
               CALL cl_err3("sel","gca_file","","",SQLCA.sqlcode,"","select min(gca06):",0)   #No.FUN-640161
               RETURN FALSE
            END IF
            IF cl_null(li_min) OR li_min >=0 THEN
               LET li_min = -1
            END IF
            #--
         
            #--Get a unique document number
            LET ls_time = TIME
            LET ls_docNum = "FLD-",
                            FGL_GETPID() USING "<<<<<<<<<<", "-",
                            TODAY USING "YYYYMMDD", "-",
                            ls_time.subString(1,2), ls_time.subString(4,5), ls_time.subString(7,8)
            #--
         
            #-- No.FUN-790020 --------------------------------------------------
            # Primary Key 不允許塞入 NULL 值, 故以空白代替
            #-------------------------------------------------------------------
            IF cl_null(gr_key.gca02) THEN
               LET gr_key.gca02 = ' '
            END IF
            IF cl_null(gr_key.gca03) THEN
               LET gr_key.gca03 = ' '
            END IF
            IF cl_null(gr_key.gca04) THEN
               LET gr_key.gca04 = ' '
            END IF
            IF cl_null(gr_key.gca05) THEN
               LET gr_key.gca05 = ' '
            END IF
            #-- No.FUN-790020 END ----------------------------------------------
            LET gr_gca.gca01 = gr_key.gca01
            LET gr_gca.gca02 = gr_key.gca02
            LET gr_gca.gca03 = gr_key.gca03
            LET gr_gca.gca04 = gr_key.gca04
            LET gr_gca.gca05 = gr_key.gca05
            LET gr_gca.gca06 = li_min
            LET gr_gca.gca07 = gr_gcb.gcb01 := ls_docNum
            LET gr_gca.gca08 = gr_gcb.gcb02 := "FLD" 
            LET gr_gca.gca09 = gr_gcb.gcb03 := gs_field 
            LET gr_gca.gca10 = gr_gcb.gcb04 := "001"
            LET gr_gca.gca11 = 'Y'
            LET gr_gca.gca12 = gr_gcb.gcb13 := g_user CLIPPED
            LET gr_gca.gca13 = gr_gcb.gcb14 := g_grup CLIPPED
            LET gr_gca.gca14 = gr_gcb.gcb15 := g_today CLIPPED
 
            LET gr_gcb.gcb11 = "O"
            LET gr_gcb.gcb12 = "U"
       WHEN "modify"
            LET ls_docNum = gr_gcb.gcb01
            LET gr_gcb.gcb07 = NULL
            LET gr_gcb.gcb08 = NULL
            LET gr_gcb.gcb09 = NULL
            LET gr_gcb.gcb10 = NULL
 
            LET gr_gca.gca15 = gr_gcb.gcb16 := g_user CLIPPED
            LET gr_gca.gca16 = gr_gcb.gcb17 := g_grup CLIPPED
            LET gr_gca.gca17 = gr_gcb.gcb18 := g_today CLIPPED
  END CASE
 
  #--If location is a URL format, then store this location directly
  #--Otherwise, store file into DB
  LET ls_location = gs_location.toLowerCase()
  IF ls_location.getIndexOf("http://", 1) THEN
     LET gr_gcb.gcb08 = "F"
     LET gr_gcb.gcb10 = gs_location
  ELSE
     LET ls_fname = gs_tempdir, "/", ls_docNum
     IF NOT cl_upload_file(gs_location, ls_fname) THEN
        CALL cl_err(NULL, "lib-212", 1)
        RETURN FALSE
     END IF
 
     LET gr_gcb.gcb07 = cl_getFieldDocumentName()
     LET gr_gcb.gcb08 = "D"
     LOCATE gr_gcb.gcb09 IN FILE ls_fname
  END IF
  #--
 
  LET li_status = TRUE
  BEGIN WORK
 
  CASE gs_mode
       WHEN "insert"
            LET ls_msg = "insert gca_file: "
            INSERT INTO gca_file VALUES (gr_gca.*)
       WHEN "modify"
            LET ls_msg = "update gca_file: "
            LET ls_sql = "UPDATE gca_file",
                         "   SET gca15 = '", gr_gca.gca15 CLIPPED, "',",
                         "       gca16 = '", gr_gca.gca16 CLIPPED, "',",
                         "       gca17 = '", gr_gca.gca17 CLIPPED, "'",
                         " WHERE ", gs_wc, " AND ",
                         "       gca06 = ", gr_gca.gca06
            EXECUTE IMMEDIATE ls_sql
  END CASE
  IF SQLCA.SQLCODE THEN
     #CALL cl_err(ls_msg, SQLCA.SQLCODE, 0)
     CALL cl_err3("upd","gca_file",gr_gca.gca15,gr_gca.gca16,SQLCA.sqlcode,"",ls_msg,0)   #No.FUN-640161
     LET li_status = FALSE
  ELSE
     CASE gs_mode
          WHEN "insert"
               LET ls_msg = "insert gcb_file: "
               INSERT INTO gcb_file VALUES (gr_gcb.*)
          WHEN "modify"
               LET ls_msg = "update gcb_file: "
               UPDATE gcb_file 
                  SET gcb07 = gr_gcb.gcb07,
                      gcb08 = gr_gcb.gcb08,
                      gcb09 = gr_gcb.gcb09,
                      gcb10 = gr_gcb.gcb10,
                      gcb16 = gr_gcb.gcb16,
                      gcb17 = gr_gcb.gcb17,
                      gcb18 = gr_gcb.gcb18
                WHERE gcb01 = gr_gcb.gcb01 AND
                      gcb02 = gr_gcb.gcb02 AND
                      gcb03 = gr_gcb.gcb03 AND
                      gcb04 = gr_gcb.gcb04
     END CASE
     IF SQLCA.SQLCODE THEN
        #CALL cl_err(ls_msg, SQLCA.SQLCODE, 0)
        CALL cl_err3("upd","gcb_file",gr_gcb.gcb01,gr_gcb.gcb02,SQLCA.sqlcode,"",ls_msg,0)   #No.FUN-640161
        LET li_status = FALSE
     END IF
  END IF
 
  #--Garbage collection   ;)
  IF gr_gcb.gcb08 = "D" THEN
     FREE gr_gcb.gcb09
     RUN "rm -f " || ls_fname 
  END IF
  #--
 
  IF NOT li_status THEN
     ROLLBACK WORK
  ELSE
     COMMIT WORK
  END IF
 
  RETURN li_status 
END FUNCTION
 
#TQC-660041---start
 
# Descriptions...: Delete Picture Immediately
# Input Parameter: key_Field STRING
#                   - Column for a Form KeyField
#                  key_Value STRING
#                   - Value of KeyField
#                  pic_Field VARCHAR
#                   - Field of pictureLocation
# Date & Author..: 2006/06/26 by Alexstar
# Return code....: 
 
FUNCTION cl_del_pic(key_Field, key_Value, pic_Field)
  DEFINE key_Field     STRING
  DEFINE key_Value     STRING
  DEFINE pic_Field     STRING
 
  LET g_doc.column1 = key_Field
  LET g_doc.value1  = key_Value
 
  IF NOT cl_fieldDocumentPrepare(pic_Field) THEN
     RETURN
  END IF
 
  LET gi_maintain = FALSE
  IF NOT cl_getFieldDocument() THEN
#    CALL cl_err(NULL, "lib-211", 1)
     RETURN                          #No.MOD-890210 
  END IF
  
  IF gr_gca.gca06 =0 THEN  #表示無相關圖片資料  
     RETURN  
  END IF
   
  IF cl_removeFieldDocumentRecord() THEN
     RETURN 
  END IF
END FUNCTION
#TQC-660041---end---
 
# Private Func...: TRUE
# Descriptions...: 
# Input Parameter: none
# Return code....: 
 
FUNCTION cl_removeFieldDocumentRecord()
  DEFINE li_status   LIKE type_file.num10   #No.FUN-690005 INTEGER
 
 
  LET li_status = TRUE
  BEGIN WORK
      
  EXECUTE IMMEDIATE "DELETE FROM gca_file WHERE " || gs_wc || " AND gca06 = " || gr_gca.gca06
  IF SQLCA.SQLCODE THEN
     CALL cl_err3("del","gca_file",gs_wc,gr_gca.gca06,SQLCA.sqlcode,"","delete gca_file:",0)   #No.FUN-640161
     #CALL cl_err("delete gca_file: ", SQLCA.SQLCODE, 0)
     LET li_status = FALSE
  ELSE
     DELETE FROM gcb_file
      WHERE gcb01 = gr_gcb.gcb01 AND
            gcb02 = gr_gcb.gcb02 AND
            gcb03 = gr_gcb.gcb03 AND
            gcb04 = gr_gcb.gcb04
     IF SQLCA.SQLCODE THEN
        #CALL cl_err("delete gcb_file: ", SQLCA.SQLCODE, 0)
        CALL cl_err3("del","gcb_file",gr_gcb.gcb01,gr_gcb.gcb02,SQLCA.sqlcode,"","delete gcb_file:",0)   #No.FUN-640161
        LET li_status = FALSE
     END IF
  END IF
  
  IF NOT li_status THEN
     ROLLBACK WORK
  ELSE
     COMMIT WORK
  END IF
 
  RETURN li_status
END FUNCTION
 
# Private Func...: TRUE
# Descriptions...: 
# Input Parameter: none
# Return code....: 
 
FUNCTION cl_getFieldDocumentLocation()
  DEFINE ls_fname   STRING,
         ls_name    STRING
  DEFINE lch_pipe   base.Channel
  DEFINE ls_buf     STRING
  DEFINE ls_cliTemp  STRING   #FUN-650080   client端暫存目錄名稱
  DEFINE ls_clifname STRING   #FUN-650080   client端暫存檔名
  DEFINE ls_ext      STRING   #FUN-650080   圖片副檔名
 
  #--If the field document is refer as URL, then display it directly
  #--Otherwise, fetch binary data from DB, then compose a accessible URL
  CASE gr_gcb.gcb08 
       WHEN "F"
            LET gs_location = gr_gcb.gcb10
       WHEN "D"
             #MOD-490263
            LET ls_name = gr_gcb.gcb01 CLIPPED, ".", cl_getFieldDocumentExtension()
            #--
            LET ls_fname = gs_tempdir, "/", ls_name
            LOCATE gr_gcb.gcb09 IN FILE ls_fname
            SELECT gcb09 INTO gr_gcb.gcb09 FROM gcb_file 
             WHERE gcb01 = gr_gcb.gcb01 AND
                   gcb02 = gr_gcb.gcb02 AND
                   gcb03 = gr_gcb.gcb03 AND
                   gcb04 = gr_gcb.gcb04
            IF SQLCA.SQLCODE THEN
               RUN "rm -f " || ls_fname
               CALL cl_err3("sel","gcb_file",gr_gcb.gcb01,gr_gcb.gcb02,SQLCA.sqlcode,"","select gcb09:",0)   #No.FUN-640161
               #CALL cl_err("select gcb09: ", SQLCA.SQLCODE, 0)
               RETURN FALSE
            ELSE
              #FUN-650080---start---Download picture from server to client Temp Directory
               IF gi_picPrint=TRUE AND gi_printSource="2" THEN
                  LET ls_ext = cl_getFieldDocumentExtension()
                  LET ls_ext = ls_ext.toUpperCase()
                  LET ls_cliTemp = cl_client_env("TEMP")
                  IF cl_null(ls_cliTemp) THEN 
                     LET ls_cliTemp = cl_client_env("TMP")
                  END IF  
                  LET ls_clifname = ls_cliTemp,"\\", ls_name
                  IF NOT cl_download_file(ls_fname,ls_clifname) THEN
                     CALL cl_err(NULL, "lib-350", 1)
                     RETURN FALSE
                  END IF
               END IF
              #FUN-650080---end---
 
               #--Change mode of this file
                  #MOD-490263
               LET lch_pipe = base.Channel.create()
               CALL lch_pipe.openPipe("ls -al " || ls_fname, "r")
               WHILE lch_pipe.read(ls_buf)
               END WHILE
               IF NOT ( ( ls_buf.subString(2, 3) = "rw" ) AND 
                        ( ls_buf.subString(5, 6) = "rw" ) AND 
                        ( ls_buf.subString(8, 9) = "rw" ) ) THEN
                  RUN "chmod 666 " || ls_fname
               END IF
               CALL lch_pipe.close()
                 #--
               #--
               IF gi_picPrint = FALSE THEN    #FUN-650080
                  LET gs_location = gs_fglasip, "/tiptop/out/", ls_name
               #FUN-650080---start---
               ELSE    
                  IF ls_ext = "JPG"  or ls_ext = "JPE"  or ls_ext = "JPEG" or
                     ls_ext = "BMP"  or ls_ext = "PCX" THEN 
                     IF gi_printSource = "2" THEN 
                       LET gs_location = ls_clifname
                     ELSE
                       LET gs_location = ls_fname
                     END IF
                  ELSE
                     LET gs_location = "err"
                  END IF
               END IF 
               #FUN-650080---end---
            END IF
  END CASE
  #--
 
  RETURN TRUE
END FUNCTION 
 
# Private Func...: TRUE
# Descriptions...: 
# Input Parameter: none
# Return code....: 
 
FUNCTION cl_getFieldDocumentName()
  DEFINE lst_tok    base.StringTokenizer
  DEFINE ls_fname   STRING
 
 
  #--Get file name from given file location
  LET lst_tok = base.StringTokenizer.create(gs_location, '/')
  WHILE lst_tok.hasMoreTokens()
      LET ls_fname = lst_tok.nextToken()
  END WHILE
  #--
 
  RETURN ls_fname
END FUNCTION
 
# Private Func...: TRUE
# Descriptions...: 
# Input Parameter: none
# Return code....: 
 
FUNCTION cl_getFieldDocumentExtension()
  DEFINE lst_tok    base.StringTokenizer
  DEFINE ls_name    STRING,
         ls_token   STRING
 
 
  #--Get extension name of file, for doocument openen usage
  LET ls_name = gr_gcb.gcb07 CLIPPED
  LET lst_tok = base.StringTokenizer.create(ls_name, '.')
  IF lst_tok.countTokens() = 1 THEN
     RETURN NULL
  ELSE
     WHILE lst_tok.hasMoreTokens()
         LET ls_token = lst_tok.nextToken()
     END WHILE
     RETURN ls_token
  END IF
  #--
END FUNCTION


###FUN-B30128 START ###
##################################################
# Private Func...: TRUE
# Descriptions...: 批次取得圖片路徑
# Date & Author..: 2011/03/17 By tsai_yen
# Input Parameter: p_doc_key   #doc的key=value組成字串.每組以";"分隔
#                  p_doc_Field #存圖片的欄位
#                  p_SourceStyle    
# Return code....: gs_location
# Usage..........: CALL cl_get_fld_pic2(p_doc_key,p_doc_field,"2")  RETURNING l_str
# Memo...........:
##################################################
FUNCTION cl_get_fld_pic2(p_doc_key, p_doc_Field, p_SourceStyle)
  DEFINE p_doc_key     DYNAMIC ARRAY OF STRING   #doc的key=value組成字串.每組以";"分隔
  DEFINE p_doc_Field   DYNAMIC ARRAY OF STRING   #存圖片的欄位
  DEFINE p_SourceStyle LIKE type_file.chr1

  LET gs_location = ""
  LET gi_picPrint=0
  LET gi_printSource = p_SourceStyle

  LET gs_tempdir = FGL_GETENV("TEMPDIR")
  LET gs_fglasip = FGL_GETENV("FGLASIP")

  LET gi_maintain = FALSE
  CALL cl_getFieldDocument2(p_doc_key,p_doc_Field) RETURNING gs_location

  RETURN gs_location
END FUNCTION


##################################################
# Private Func...: TRUE
# Descriptions...: 從相關文件取得圖片路徑
# Date & Author..: 2011/03/17 By tsai_yen
# Input Parameter: p_doc_key   #doc的key=value組成字串.每組以";"分隔
#                  p_doc_Field #存圖片的欄位   
# Return code....: gs_location
# Usage..........: CALL cl_getFieldDocument2(p_doc_key,p_doc_Field) RETURNING gs_location
# Memo...........:
##################################################
FUNCTION cl_getFieldDocument2(p_doc_key,p_doc_Field)
   DEFINE p_doc_key     DYNAMIC ARRAY OF STRING   #doc的key=value組成字串.每組以";"分隔
   DEFINE p_doc_Field   DYNAMIC ARRAY OF STRING   #存圖片的欄位
   DEFINE l_img_loc     DYNAMIC ARRAY OF STRING   #圖片位置
   DEFINE ls_sql        STRING
   DEFINE l_i           LIKE type_file.num5
   DEFINE l_j           LIKE type_file.num5
   DEFINE l_tok         base.StringTokenizer
   DEFINE l_tmp         STRING
   DEFINE ls_location   STRING
   DEFINE l_gca09       LIKE gca_file.gca09
   
   DEFINE ls_fname   STRING
   DEFINE ls_name    STRING
   DEFINE lch_pipe   base.Channel
   DEFINE ls_buf     STRING
   DEFINE ls_cliTemp  STRING   #client端暫存目錄名稱
   DEFINE ls_clifname STRING   #client端暫存檔名
   DEFINE ls_ext      STRING   #圖片副檔名

   LET ls_sql = "SELECT gca_file.* FROM gca_file",
                " WHERE gca01 = ?  AND gca02 = ? AND gca03 = ?",
                 " AND gca04 = ? AND gca05 = ?",
                 " AND gca08 = 'FLD'",
                 " AND gca09 = ?",
                 " AND gca11 = 'Y'"
   PREPARE fld_doc_pre2 FROM ls_sql
   DECLARE fld_doc_curs2 SCROLL CURSOR FOR fld_doc_pre2
   FOR l_i = 1 TO p_doc_key.getlength()     
      LET gr_key.gca01 = " "   # Primary Key 不允許塞入 NULL, 故以空白替代
      LET gr_key.gca02 = " "
      LET gr_key.gca03 = " "
      LET gr_key.gca04 = " "
      LET gr_key.gca05 = " "
            
      LET g_doc.value1 = " "
      LET g_doc.value2 = " "
      LET g_doc.value3 = " "
      LET g_doc.value4 = " "
      LET g_doc.value5 = " "            
      
      LET l_j = 0
      LET l_tok = base.StringTokenizer.createExt(p_doc_key[l_i] CLIPPED,";","",TRUE)	#指定分隔符號     
      WHILE l_tok.hasMoreTokens()	#依序取得子字串
         LET l_j = l_j + 1
         LET l_tmp=l_tok.nextToken()        
         CASE l_j
            WHEN 1
                 LET gr_key.gca01 = l_tmp
                 CALL cl_str_sepsub(gr_key.gca01,"=",1,1) RETURNING l_tmp
                 LET g_doc.column1 = l_tmp
                 CALL cl_str_sepsub(gr_key.gca01,"=",2,2) RETURNING l_tmp
                 LET g_doc.value1 = l_tmp
            WHEN 2
                 LET gr_key.gca02 = l_tmp
                 CALL cl_str_sepsub(gr_key.gca02,"=",1,1) RETURNING l_tmp
                 LET g_doc.column2 = l_tmp
                 CALL cl_str_sepsub(gr_key.gca02,"=",2,2) RETURNING l_tmp
                 LET g_doc.value2 = l_tmp
            WHEN 3
                 LET gr_key.gca03 = l_tmp
                 CALL cl_str_sepsub(gr_key.gca03,"=",1,1) RETURNING l_tmp
                 LET g_doc.column3 = l_tmp
                 CALL cl_str_sepsub(gr_key.gca03,"=",2,2) RETURNING l_tmp
                 LET g_doc.value3 = l_tmp
            WHEN 4
                 LET gr_key.gca04 = l_tmp
                 CALL cl_str_sepsub(gr_key.gca04,"=",1,1) RETURNING l_tmp
                 LET g_doc.column4 = l_tmp
                 CALL cl_str_sepsub(gr_key.gca04,"=",2,2) RETURNING l_tmp
                 LET g_doc.value4 = l_tmp
            WHEN 5
                 LET gr_key.gca05 = l_tmp
                 CALL cl_str_sepsub(gr_key.gca05,"=",1,1) RETURNING l_tmp
                 LET g_doc.column5 = l_tmp
                 CALL cl_str_sepsub(gr_key.gca05,"=",2,2) RETURNING l_tmp
                 LET g_doc.value5 = l_tmp
         END CASE
      END WHILE      
      LET l_gca09 = p_doc_Field[l_i]
      
      OPEN fld_doc_curs2 USING gr_key.gca01,gr_key.gca02,gr_key.gca03,gr_key.gca04,gr_key.gca05,l_gca09
      FETCH ABSOLUTE 1 fld_doc_curs2 INTO gr_gca.*      
      IF SQLCA.SQLCODE THEN
         LET ls_location = ""
      ELSE
         LOCATE gr_gcb.gcb09 IN MEMORY
         SELECT gcb_file.* INTO gr_gcb.* FROM gcb_file
            WHERE gcb01 = gr_gca.gca07 AND
                  gcb02 = gr_gca.gca08 AND
                  gcb03 = gr_gca.gca09 AND
                  gcb04 = gr_gca.gca10
         FREE gr_gcb.gcb09
         LET ls_location = ""
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("sel","gcb_file","","",SQLCA.sqlcode,"","",0)
            RETURN FALSE
         ELSE
            #CALL cl_getFieldDocumentLocation2()        
            CASE gr_gcb.gcb08
               WHEN "F"
                    LET ls_location = gr_gcb.gcb10
               WHEN "D"
                    LET ls_name = gr_gcb.gcb01 CLIPPED, ".", cl_getFieldDocumentExtension()
                    LET ls_fname = gs_tempdir, "/", ls_name
                    LOCATE gr_gcb.gcb09 IN FILE ls_fname
                    SELECT gcb09 INTO gr_gcb.gcb09 FROM gcb_file
                     WHERE gcb01 = gr_gcb.gcb01 AND
                           gcb02 = gr_gcb.gcb02 AND
                           gcb03 = gr_gcb.gcb03 AND
                           gcb04 = gr_gcb.gcb04
                    IF SQLCA.SQLCODE THEN
                       RUN "rm -f " || ls_fname
                       CALL cl_err3("sel","gcb_file",gr_gcb.gcb01,gr_gcb.gcb02,SQLCA.sqlcode,"","select gcb09:",0)
                       RETURN FALSE
                    ELSE          
                       #--Change mode of this file
                       LET lch_pipe = base.Channel.create()
                       CALL lch_pipe.openPipe("ls -al " || ls_fname, "r")
                       WHILE lch_pipe.read(ls_buf)
                       END WHILE
                       IF NOT ( ( ls_buf.subString(2, 3) = "rw" ) AND
                                ( ls_buf.subString(5, 6) = "rw" ) AND
                                ( ls_buf.subString(8, 9) = "rw" ) ) THEN
                          RUN "chmod 666 " || ls_fname
                       END IF
                       CALL lch_pipe.close()

                       LET ls_location = gs_fglasip, "/tiptop/out/", ls_name #FUN-B30128
                          #http://10.40.40.30/gas/top2o/tiptop/out/FLD-2951-20100618-155420.jpg
                       #LET gs_location = gs_fglasip, gs_tempdir,"/", ls_name #FUN-B30128
                          #http://10.40.40.30/gas/top2o/u7/out2/FLD-2951-20100618-155420.jpg
                    END IF
            END CASE
         END IF
      END IF
      
      LET gs_location = gs_location,",",ls_location       
   END FOR

  IF gs_location.getindexof(",",1) > 0 THEN   #拿掉第一個","
      LET gs_location = gs_location.substring(2,gs_location.getlength())
  END IF
  RETURN gs_location
END FUNCTION

{
FUNCTION cl_getFieldDocumentLocation2()
  DEFINE ls_fname   STRING,
         ls_name    STRING
  DEFINE lch_pipe   base.Channel
  DEFINE ls_buf     STRING
  DEFINE ls_cliTemp  STRING   #client端暫存目錄名稱
  DEFINE ls_clifname STRING   #client端暫存檔名
  DEFINE ls_ext      STRING   #圖片副檔名

  #--Compose KEY value
  LET gr_key.gca01 = g_doc.column1 CLIPPED || "=" || g_doc.value1 CLIPPED
  LET gr_key.gca02 = g_doc.column2 CLIPPED || "=" || g_doc.value2 CLIPPED
  LET gr_key.gca03 = g_doc.column3 CLIPPED || "=" || g_doc.value3 CLIPPED
  LET gr_key.gca04 = g_doc.column4 CLIPPED || "=" || g_doc.value4 CLIPPED
  LET gr_key.gca05 = g_doc.column5 CLIPPED || "=" || g_doc.value5 CLIPPED
  
  #--If the field document is refer as URL, then display it directly
  #--Otherwise, fetch binary data from DB, then compose a accessible URL
  CASE gr_gcb.gcb08
       WHEN "F"
            LET gs_location = gr_gcb.gcb10
       WHEN "D"
            LET ls_name = gr_gcb.gcb01 CLIPPED, ".", cl_getFieldDocumentExtension()
            LET ls_fname = gs_tempdir, "/", ls_name
            LOCATE gr_gcb.gcb09 IN FILE ls_fname
            SELECT gcb09 INTO gr_gcb.gcb09 FROM gcb_file
             WHERE gcb01 = gr_gcb.gcb01 AND
                   gcb02 = gr_gcb.gcb02 AND
                   gcb03 = gr_gcb.gcb03 AND
                   gcb04 = gr_gcb.gcb04
            IF SQLCA.SQLCODE THEN
               RUN "rm -f " || ls_fname
               CALL cl_err3("sel","gcb_file",gr_gcb.gcb01,gr_gcb.gcb02,SQLCA.sqlcode,"","select gcb09:",0)
               #CALL cl_err("select gcb09: ", SQLCA.SQLCODE, 0)
               RETURN FALSE
            ELSE
--               #FUN-650080---start---Download picture from server to client Temp Directory
--                IF gi_picPrint=TRUE AND gi_printSource="2" THEN
--                   LET ls_ext = cl_getFieldDocumentExtension()
--                   LET ls_ext = ls_ext.toUpperCase()
--                   LET ls_cliTemp = cl_client_env("TEMP")
--                   IF cl_null(ls_cliTemp) THEN
--                      LET ls_cliTemp = cl_client_env("TMP")
--                   END IF
--                   LET ls_clifname = ls_cliTemp,"\\", ls_name
--                   IF NOT cl_download_file(ls_fname,ls_clifname) THEN
--                      CALL cl_err(NULL, "lib-350", 1)
--                      RETURN FALSE
--                   END IF
--                END IF
              #FUN-650080---end---

               #--Change mode of this file
                  #MOD-490263
               LET lch_pipe = base.Channel.create()
               CALL lch_pipe.openPipe("ls -al " || ls_fname, "r")
               WHILE lch_pipe.read(ls_buf)
               END WHILE
               IF NOT ( ( ls_buf.subString(2, 3) = "rw" ) AND
                        ( ls_buf.subString(5, 6) = "rw" ) AND
                        ( ls_buf.subString(8, 9) = "rw" ) ) THEN
                  RUN "chmod 666 " || ls_fname
               END IF
               CALL lch_pipe.close()
                 #--
               #--
--                IF gi_picPrint = FALSE THEN    #FUN-650080
--                   LET gs_location = gs_fglasip, "/tiptop/out/", ls_name
--                #FUN-650080---start---
--                ELSE
--                   IF ls_ext = "JPG"  or ls_ext = "JPE"  or ls_ext = "JPEG" or
--                      ls_ext = "BMP"  or ls_ext = "PCX" THEN
--                      IF gi_printSource = "2" THEN
--                        LET gs_location = ls_clifname
--                      ELSE
--                        LET gs_location = ls_fname
--                      END IF
--                   ELSE
--                      LET gs_location = "err"
--                   END IF
--                END IF
               #FUN-650080---end---

               #LET gs_location = gs_fglasip, gs_tempdir,"/", ls_name #FUN-B30128
               #http://10.40.40.30/gas/top2o/u7/out2/FLD-2951-20100618-155420.jpg

               LET gs_location = gs_fglasip, "/tiptop/out/", ls_name #FUN-B30128
               #http://10.40.40.30/gas/top2o/tiptop/out/FLD-2951-20100618-155420.jpg
            END IF
  END CASE
  #--

  RETURN TRUE
END FUNCTION}
###FUN-B30128 END ###
