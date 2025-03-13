# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Library name...: aws_bicli
# Descriptions...: 透過 Web Services 將 TIPTOP 表單與 V-Point Express 整合
# Input parameter:
# Return code....:  
#                  
# Usage .........: call aws_bicli()
# Date & Author..: 96/05/04 By Echo FUN-740207
# Modify.........: No.FUN-840065 08/04/16 By kevin 增加 BI 銷售智慧的報表清單
# Modify.........: No.FUN-850029 08/05/06 By kevin 判斷name 是否有"V-Point Express"
# Modify.........: No.FUN-880046 08/08/12 by Echo Genero 2.11 調整
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-960052 09/06/08 by Echo TIPTOP & V-Point5 整合
#
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-C20087 12/03/06 By Abby 新增CROSS平台整合

IMPORT os   #No.FUN-9C0009 
IMPORT com
IMPORT xml         #No:FUN-960052
 
DATABASE ds
#No.FUN-740207
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_bigw.inc"
GLOBALS "../4gl/aws_bigw2.inc"        #No:FUN-960052
GLOBALS "../4gl/aws_crossgw.inc"      #FUN-C20087

DEFINE channel base.Channel
DEFINE g_wap RECORD LIKE wap_file.*   #FUN-C20087
DEFINE g_reportlist_in RECORD
          user     STRING,       #系統帳號
          pwd     STRING         #系統密碼
       END RECORD
 
 
FUNCTION aws_bicli(p_gcf,p_gch)
    DEFINE p_gch        RECORD LIKE gch_file.* ,
                        # l_gch 存取用戶設定SQL Server連線參數
           p_gcf        RECORD LIKE gcf_file.*
                        # l_gcf 匯入Tiptop工廠與Express對應DB之關聯
    DEFINE l_root       om.DomNode
    DEFINE l_gci        RECORD LIKE gci_file.* # 截取字串
    DEFINE l_zz01       LIKE zz_file.zz01,
           l_zz02       LIKE zz_file.zz02,
           l_zz08       LIKE zz_file.zz08
    DEFINE l_zm04       LIKE zm_file.zm04
    DEFINE l_ze03       LIKE ze_file.ze03
    DEFINE l_gaz        DYNAMIC ARRAY OF RECORD
                         gaz01  LIKE gaz_file.gaz01,   #程式代號
                         gaz03  LIKE gaz_file.gaz03    #程式名稱
                        END RECORD
    DEFINE l_i,l_j      LIKE type_file.num10,
           l_zm_tag     LIKE type_file.num5
    DEFINE l_status	LIKE type_file.num10,  #No.FUN-680130 INTEGER
           l_cnt        LIKE type_file.num10,
           l_zm_cnt     LIKE type_file.num10,
           l_str        STRING,
           l_str2       STRING,                #FUN-C20087
           l_type       STRING,
           l_Result	STRING,
           l_cmd        STRING,
           l_msg        STRING,
           l_sql        STRING,
           lch_cmd      base.Channel
    DEFINE n_category   om.DomNode
    DEFINE n_report     om.DomNode
    DEFINE n_parent     om.DomNode
    DEFINE nl_category  om.NodeList
    DEFINE nl_report    om.NodeList
    DEFINE l_cross_status   LIKE type_file.num5  #FUN-C20087
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    LET g_reportlist_in.user = p_gch.gch12 CLIPPED
    LET g_reportlist_in.pwd = p_gch.gch13 CLIPPED
    IF cl_null(g_reportlist_in.pwd) THEN
       LET g_reportlist_in.pwd = ""
    END IF
 
    #No:FUN-960052 -- start --
    #LET BI_ListenerService_ListenerPortLocation = p_gch.gch11  CLIPPED #FUN-840065 #指定 Soap server location
    #CALL BI_GetCatelog4ReportList(g_reportlist_in.user,g_reportlist_in.pwd)                   #連接 V-Point Express SOAP server
    #     RETURNING l_status, l_Result
   #FUN-C20087 add str-----
    SELECT wap02 INTO g_wap.wap02 FROM wap_file
    #---------------------------------------------------------------------#
    # TIPTOP 與 CROSS 整合: 透過 CROSS 平台呼叫 BI                        #
    #---------------------------------------------------------------------#
    IF g_wap.wap02 = 'Y' THEN  #使用CROSS整合平台
       LET l_str = "BI"
       LET l_str2 = "pUserName|",g_reportlist_in.user CLIPPED,",pPassword|",g_reportlist_in.pwd CLIPPED
       DISPLAY "l_str2:",l_str2
       #呼叫 CROSS 平台發出整合活動請求
       CALL aws_cross_invokeSrv(l_str,"GetCatelogReportList","sync",l_str2)
            RETURNING l_cross_status, l_status, l_Result
       IF NOT l_cross_status  THEN
          RETURN
       END IF
    ELSE
   #FUN-C20087 add end-----
       CALL fgl_ws_setOption("http_invoketimeout", 60)         #若 60 秒內無回應則放棄
       CASE p_gcf.gcf10
          WHEN 'Y'      #V-Point4 Express
             LET BI_ListenerService_ListenerPortLocation = p_gch.gch11  CLIPPED #FUN-840065 #指定 Soap server location
             CALL BI_GetCatelog4ReportList(g_reportlist_in.user,g_reportlist_in.pwd)        #連接 V-Point Express SOAP server
                  RETURNING l_status, l_Result
     
          WHEN 'U'      #V-Point5 Express
             LET BI2_VpWebServiceImplService_VpWebServiceImplPortLocation = p_gch.gch11  CLIPPED #FUN-840065 #指定 Soap server location
             CALL BI2_GetCatelogReportList(g_reportlist_in.user,g_reportlist_in.pwd)        #連接 V-Point Express SOAP server
                  RETURNING l_status, l_Result
     
          OTHERWISE
       END CASE
    END IF  #FUN-C20087 add
    #END No:FUN-960052 -- start --

    #紀錄傳入 V-Point Express 的字串
    CALL aws_bicli_log(l_status,l_Result)
 
    IF l_status = 0 THEN
       #取得 XML 字串的 Root Node, 
       LET l_root = aws_bicli_stringToXml(l_Result)
       IF l_root IS NULL THEN
          #No:FUN-960052 -- start --
          IF fgl_getenv('FGLGUI') = '1' THEN
             LET l_str = "XML parser error:\n\n", l_str
          ELSE
             LET l_str = "XML parser error: ", l_str
          END IF
          LET l_str = l_str, l_Result
          CALL cl_err(l_str,'!','1')
          #No:FUN-960052 -- end --

          RETURN
       END IF
       SELECT ze03 INTO l_ze03 FROM ze_file
        WHERE ze01 = 'lib-353' AND ze02 = g_lang
       LET l_msg = l_ze03 CLIPPED,"\n"
 
       BEGIN WORK
 
       LET l_cmd = "SELECT gaz01,gaz03 FROM zm_file,gaz_file  ",
                   " WHERE zm01 = 'mbo' AND zm04 = gaz01 AND gaz02 = '0'",
                   "   ORDER BY gaz03"
       PREPARE gaz_pre FROM l_cmd
       DECLARE gaz_curs CURSOR FOR gaz_pre
       LET l_cnt = 1
       FOREACH gaz_curs INTO l_gaz[l_cnt].gaz01,l_gaz[l_cnt].gaz03
             LET l_cnt = l_cnt + 1
       END FOREACH
       CALL l_gaz.deleteElement(l_cnt)
 
       # 顯示讀取進度
       DELETE FROM gci_file WHERE 1=1
       DELETE FROM zz_file WHERE zz01 LIKE "bo%"
       DELETE FROM gaz_file WHERE gaz01 LIKE "bo%"
       LET l_cnt = 0
       #LET nl_category = l_root.selectByPath("//Category[@name=\"V-Point Express\"]")       
       LET nl_category = l_root.selectByPath("//Category[@cuid=\"AdeDB1s8oh5Oo2.gJYi3Ox0\"]") #FUN-840065      
       #FUN-850029 --start
       IF nl_category.getLength() = 0 THEN
          LET nl_category = l_root.selectByPath("//Category[@name=\"V-Point Express\"]")
       END IF
       #FUN-850029 --end
       LET n_category = nl_category.item(1)       
       
       IF n_category IS NOT NULL THEN
          LET nl_report = n_category.selectByTagName("Report")
          LET l_cnt = nl_report.getLength()
       END IF
       IF cl_null(l_cnt) OR l_cnt = 0 THEN
          CALL cl_err('','azz-135',1)
          ROLLBACK WORK
          RETURN
       END IF
       FOR l_i = 1 to l_cnt
           LET n_report = nl_report.item(l_i)
           LET l_type = n_report.getAttribute("type")
           CASE l_type
             WHEN "Webi"
               LET l_gci.gci01 = "web"
             WHEN "FullClient"
               LET l_gci.gci01 = "rep"
           END CASE
 
           LET l_gci.gci02 = n_report.getAttribute("id")
           LET l_gci.gci03 = n_report.getAttribute("name")
           LET n_parent = n_report.getParent()
           LET n_parent = n_parent.getParent()
           LET l_gci.gci04 = n_parent.getAttribute("name")
           LET l_gci.gci05 = n_report.getAttribute("cuid")
           
           INSERT INTO gci_file(gci01,gci02,gci03,gci04,gci05,gci07) #FUN-840065
              	   VALUES(l_gci.gci01,l_gci.gci02,l_gci.gci03,
                               l_gci.gci04,l_gci.gci05,'Y')
           
           # 未成功導入報表清單
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
              CALL cl_err(l_gci.gci03,SQLCA.sqlcode,0)
           ELSE 
              #更新設定關聯的報表ID
              LET l_zz01 = "bo",l_gci.gci01 CLIPPED,l_gci.gci02 CLIPPED 
              LET l_zz02 = l_gci.gci03 CLIPPED
              LET l_zz08 = "$FGLRUN $AZZi/p_express 'S' ",l_gci.gci02 CLIPPED,
              	     " '",l_gci.gci01 CLIPPED,"' ''"
 
              UPDATE gcg_file SET gcg08 = l_zz01 
                WHERE gcg07=l_gci.gci03 AND gcg11 = l_gci.gci01
           
              INSERT INTO zz_file(zz01,zz011,zz03,zz05,zz06,zz08,zz13,zz15,
              		    zz25,zz26,zz27,zz28,zz29,zz30,
              		    zzuser,zzgrup,zzmodu,zzdate,zzoriu,zzorig)
                   VALUES (l_zz01,"AZZ","R","N","1",l_zz08,"N","N",
              	     "N","N","sm1","3","1",0,g_user,g_grup,"",g_today, g_user, g_grup) #FUN-840065 zz28      #No.FUN-980030 10/01/04  insert columns oriu, orig
           
              INSERT INTO gaz_file(gaz01,gaz02,gaz03,gaz05,gazoriu,gazorig) VALUES(l_zz01,'2',l_zz02,'N', g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
              INSERT INTO gaz_file(gaz01,gaz02,gaz03,gaz05,gazoriu,gazorig) VALUES(l_zz01,'0',l_zz02,'N', g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
              IF STATUS THEN 
                 CALL cl_err(l_gci.gci03,SQLCA.sqlcode,0)
              END IF
           
              # 成功導入報表清單
              LET l_msg = l_msg CLIPPED,l_gci.gci03 CLIPPED,
                          "(",l_gci.gci01 CLIPPED,")\n"
           END IF
       END FOR
       
       #FUN-840065 start       
       DELETE FROM zz_file WHERE zz01 LIKE "bi%"
       DELETE FROM gaz_file WHERE gaz01 LIKE "bi%"
       IF p_gcf.gcf09="Y" THEN
          LET l_cnt = 0
          #以 "cuid來判斷 "BI 銷售模組
          LET nl_category = l_root.selectByPath("//Category[@cuid=\"AXOt5BhJpShNrKLud10mwP0\"]")
          LET n_category = nl_category.item(1)
          IF n_category IS NOT NULL THEN
             LET nl_report = n_category.selectByTagName("Report")
             LET l_cnt = nl_report.getLength()
          END IF
          IF cl_null(l_cnt) OR l_cnt = 0 THEN
             CALL cl_err('','azz-135',1)
             ROLLBACK WORK
             RETURN
          END IF
          FOR l_i = 1 to l_cnt
              LET n_report = nl_report.item(l_i)
              LET l_type = n_report.getAttribute("type")
              CASE l_type
                WHEN "Webi"
                  LET l_gci.gci01 = "web"
                WHEN "FullClient"
                  LET l_gci.gci01 = "rep"
              END CASE
          
              LET l_gci.gci02 = n_report.getAttribute("id")
              LET l_gci.gci03 = n_report.getAttribute("name")
              LET n_parent = n_report.getParent()
              LET n_parent = n_parent.getParent()
              LET l_gci.gci04 = n_parent.getAttribute("name")
              LET l_gci.gci05 = n_report.getAttribute("cuid")
              
              INSERT INTO gci_file(gci01,gci02,gci03,gci04,gci05,gci07) 
                 	   VALUES(l_gci.gci01,l_gci.gci02,l_gci.gci03,
                                  l_gci.gci04,l_gci.gci05,'N')
              
              # 未成功導入報表清單
              IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                 CALL cl_err(l_gci.gci03,SQLCA.sqlcode,0)
              ELSE 
                 #更新設定關聯的報表ID
                 LET l_zz01 = "bi",l_gci.gci01 CLIPPED,l_gci.gci02 CLIPPED 
                 LET l_zz02 = l_gci.gci03 CLIPPED
                 LET l_zz08 = "$FGLRUN $AZZi/p_express 'S' ",l_gci.gci02 CLIPPED,
                 	     " '",l_gci.gci01 CLIPPED,"' ''"
          
                 UPDATE gcg_file SET gcg08 = l_zz01 
                   WHERE gcg07=l_gci.gci03 AND gcg11 = l_gci.gci01
              
                 INSERT INTO zz_file(zz01,zz011,zz03,zz05,zz06,zz08,zz13,zz15,
                 		    zz25,zz26,zz27,zz28,zz29,zz30,
                 		    zzuser,zzgrup,zzmodu,zzdate,zzoriu,zzorig)
                      VALUES (l_zz01,"AZZ","R","N","1",l_zz08,"N","N",
                 	     "N","N","sm1","3","1",0,g_user,g_grup,"",g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
              
                 INSERT INTO gaz_file(gaz01,gaz02,gaz03,gaz05,gazoriu,gazorig) VALUES(l_zz01,'2',l_zz02,'N', g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
                 INSERT INTO gaz_file(gaz01,gaz02,gaz03,gaz05,gazoriu,gazorig) VALUES(l_zz01,'0',l_zz02,'N', g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
                 IF STATUS THEN 
                    CALL cl_err(l_gci.gci03,SQLCA.sqlcode,0)
                 END IF
              
                 # 成功導入報表清單
                 LET l_msg = l_msg CLIPPED,l_gci.gci03 CLIPPED,
                             "(",l_gci.gci01 CLIPPED,")\n"
              END IF
          END FOR
       END IF   
       #FUN-840065 end
       
       LET l_zm_tag = 0
 
       LET l_sql = "SELECT gci01,gci02,gci03 FROM gci_file ORDER BY gci03"
 
       PREPARE aws_bicli_pre FROM l_sql
       DECLARE aws_bicli_cs CURSOR FOR aws_bicli_pre
       FOREACH aws_bicli_cs INTO l_gci.gci01,l_gci.gci02,l_gci.gci03 
          FOR l_j = 1 TO l_gaz.getLength()
              LET l_zz01 = "bo",l_gci.gci01 CLIPPED,l_gci.gci02 CLIPPED 
              IF l_gaz[l_j].gaz03 = l_gci.gci03 AND l_gaz[l_j].gaz01 <> l_zz01
               AND l_gaz[l_j].gaz01[3,5] = l_gci.gci01[1,3]
              THEN
                  LET l_zm_tag = 1 
                  EXIT FOREACH
              ELSE
                   IF l_gaz[l_j].gaz03 = l_gci.gci03 THEN
                      LET l_zm_tag = 3 
                      EXIT FOR
                   END IF
              END IF
          END FOR
       END FOREACH
       IF l_zm_tag != 3 THEN
          CALL aws_bicli_auto_menu(p_gcf.gcf09) #FUN-840065
       END IF
      
       COMMIT WORK
        
       IF NOT cl_null(l_msg) THEN 
         LET l_cmd = 'rm -f p_bi.out'
         RUN l_cmd
         LET channel = base.Channel.create()
         CALL channel.openFile("p_bi.out","a" )
         CALL channel.setDelimiter("")
         CALL channel.write(l_msg)
         CALL channel.close()
#        LET l_cmd = "chmod 777 p_bi.out 2>/dev/null" #MOD-530271       #No.FUN-9C0009
#        RUN l_cmd                                      #No.FUN-9C0009  
         IF os.Path.chrwx("p_bi.out",511) THEN END IF   #No.FUN-9C0009  add by dxfwo 
         LET l_msg = "p_view p_bi.out"
         CALL cl_cmdrun_wait(l_msg)
         LET l_cmd = 'rm -f p_bi.out'
         RUN l_cmd
      
         #CALL cl_err(l_msg,l_msg,1)
      
       END IF
    ELSE
       IF fgl_getenv('FGLGUI') = '1' THEN
          LET l_str = "Connection failed:\n\n", 
                   "  [Code]: ", wserror.code, "\n",
                   "  [Action]: ", wserror.action, "\n",
                   "  [Description]: ", wserror.description
       ELSE
          LET l_str = "Connection failed: ", wserror.description
       END IF
       CALL cl_err(l_str, '!', 1)   #連接失敗
    END IF
END FUNCTION
 
FUNCTION aws_bicli_token(p_gch)
    DEFINE p_gch        RECORD LIKE gch_file.* 
                        # l_gch 存取用戶設定SQL Server連線參數
    DEFINE l_root       om.DomNode
    DEFINE l_status	LIKE type_file.num10,  #No.FUN-680130 INTEGER
           l_Result	STRING,
           l_str        STRING,
           l_str2       STRING                   #FUN-C20087
    DEFINE l_cross_status   LIKE type_file.num5  #FUN-C20087
    DEFINE l_gcf10      LIKE gcf_file.gcf10    #No:FUN-960052

    WHENEVER ERROR CALL cl_err_msg_log
 
    LET g_reportlist_in.user = p_gch.gch12 CLIPPED
    LET g_reportlist_in.pwd = p_gch.gch13 CLIPPED
    LET BI_ListenerService_ListenerPortLocation = p_gch.gch11 CLIPPED #FUN-840065 #指定 Soap server location
 
    #No:FUN-960052 -- start --
    #CALL fgl_ws_setOption("http_invoketimeout", 60)         #若 60 秒內無回應則放棄
    #CALL BI_GetLogonToken(g_reportlist_in.user,g_reportlist_in.pwd)                   #連接 V-Point Express SOAP server
    #     RETURNING l_status, l_Result
   #FUN-C20087 add str-----
    SELECT wap02 INTO g_wap.wap02 FROM wap_file
    #---------------------------------------------------------------------#
    # TIPTOP 與 CROSS 整合: 透過 CROSS 平台呼叫 BI                        #
    #---------------------------------------------------------------------#
    IF g_wap.wap02 = 'Y' THEN  #使用CROSS整合平台
       LET l_str = "BI"
       LET l_str2 = "pUserName|",g_reportlist_in.user CLIPPED,",pPassword|",g_reportlist_in.pwd CLIPPED
       DISPLAY "l_str2:",l_str2
       #呼叫 CROSS 平台發出整合活動請求
       CALL aws_cross_invokeSrv(l_str,"GetLogonToken","sync",l_str2)
            RETURNING l_cross_status, l_status, l_Result
       IF NOT l_cross_status  THEN
          RETURN
       END IF
    ELSE
   #FUN-C20087 add end-----
       CALL fgl_ws_setOption("http_invoketimeout", 60)         #若 60 秒內無回應則放棄
       SELECT UNIQUE gcf10 INTO l_gcf10 FROM gcf_file 
       CASE l_gcf10
          WHEN 'Y'      #V-Point4 Express
             LET BI_ListenerService_ListenerPortLocation = p_gch.gch11 CLIPPED #FUN-840065  #指定 Soap server location
             CALL BI_GetLogonToken(g_reportlist_in.user,g_reportlist_in.pwd)                #連接 V-Point Express SOAP server
                  RETURNING l_status, l_Result
     
          WHEN 'U'      #V-Point5 Express
             LET BI2_VpWebServiceImplService_VpWebServiceImplPortLocation = p_gch.gch11  CLIPPED #FUN-840065 #指定 Soap server location
             CALL BI2_GetLogonToken(g_reportlist_in.user,g_reportlist_in.pwd)                   #連接 V-Point Express SOAP server
                  RETURNING l_status, l_Result
     
          OTHERWISE
       END CASE
    END IF  #FUN-C20087
    #No:FUN-960052 -- end --
 
    #紀錄傳入 V-Point Express 的字串
    CALL aws_bicli_log(l_status,l_Result)
 
    IF l_status = 0 THEN
       IF cl_null(l_Result) THEN
         CALL cl_err('', 'aws-097', 1)   #XML 字串有問題
         RETURN ''
       ELSE
         #No:FUN-960052 -- start --
         IF l_Result.getIndexOf('@',1) > 0 THEN
            RETURN l_Result
         ELSE
            IF fgl_getenv('FGLGUI') = '1' THEN
               LET l_str = "XML parser error:\n\n", l_str
            ELSE
               LET l_str = "XML parser error: ", l_str
            END IF
            LET l_str = l_str, l_Result
            CALL cl_err(l_str,'!','1')
            RETURN ''
         END IF
         #No:FUN-960052 -- end --
       END IF
    ELSE
       IF fgl_getenv('FGLGUI') = '1' THEN
          LET l_str = "Connection failed:\n\n", 
                   "  [Code]: ", wserror.code, "\n",
                   "  [Action]: ", wserror.action, "\n",
                   "  [Description]: ", wserror.description
       ELSE
          LET l_str = "Connection failed: ", wserror.description
       END IF
       CALL cl_err(l_str, '!', 1)   #連接失敗
       RETURN ''
    END IF
END FUNCTION
 
FUNCTION aws_bicli_stringToXml(p_xml)
   DEFINE p_xml       STRING
   DEFINE l_ch        base.Channel,
          l_xmlFile   STRING,
          l_doc       om.DomDocument,
          l_root      om.DomNode
 
 
   WHENEVER ERROR CONTINUE
 
   IF cl_null(p_xml) THEN
      RETURN NULL
   END IF
 
   #--------------------------------------------------------------------------#
   # 產生 XML 暫存檔                                                          #
   #--------------------------------------------------------------------------#
   LET l_ch = base.Channel.create()
   LET l_xmlFile = fgl_getenv("TEMPDIR"), "/",
                   "aws_bicli_", FGL_GETPID() USING '<<<<<<<<<<', ".xml"
   CALL l_ch.openFile(l_xmlFile, "w")
   CALL l_ch.setDelimiter("")               #FUN-880046
   CALL l_ch.write(p_xml)
   CALL l_ch.close()
 
   #--------------------------------------------------------------------------#
   # 讀取 XML 文件                                                            #
   #--------------------------------------------------------------------------#
   LET l_doc = om.DomDocument.createFromXmlFile(l_xmlFile)
   RUN "rm -f " || l_xmlFile || " >/dev/null 2>&1"
   INITIALIZE l_root TO NULL
   IF l_doc IS NOT NULL THEN
      LET l_root = l_doc.getDocumentElement()
   END IF
 
   RETURN l_root
END FUNCTION
 
FUNCTION aws_bicli_log(p_status,p_result)
    DEFINE p_status	LIKE type_file.num10
    DEFINE p_result     STRING
    DEFINE l_file       STRING,                #FUN-520020
           l_str        STRING
    DEFINE l_i          LIKE type_file.num10
 
    LET channel = base.Channel.create()
    LET l_file = fgl_getenv("TEMPDIR"), "/",
                 "aws_bicli-", TODAY USING 'YYYYMMDD', ".log"
 
    CALL channel.openFile(l_file, "a")
    #CALL channel.openFile("aws_bicli.log", "w")
 
    IF STATUS = 0 THEN
       CALL channel.setDelimiter("")
       LET l_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
       CALL channel.write(l_str)
       CALL channel.write("")
       CALL channel.write("Request XML:")
       LET l_str = "User:",g_reportlist_in.user
       CALL channel.write(l_str)
 
       LET l_str = "Pwd : "
       FOR l_i = 1 TO g_reportlist_in.pwd.getLength()
           LET l_str = l_str, "*"
       END FOR
 
       CALL channel.write(l_str)
       CALL channel.write("")
       CALL channel.write("Response XML:")
 
       IF p_status = 0 THEN
          CALL channel.write(p_Result)
       ELSE
          CALL channel.write("")
          IF fgl_getenv('FGLGUI') = '1' THEN
             LET l_str = "   Connection failed:\n\n",
                      "     [Code]: ", wserror.code, "\n",
                      "     [Action]: ", wserror.action, "\n",
                      "     [Description]: ", wserror.description
          ELSE
             LET l_str = "   Connection failed: ", wserror.description
          END IF
          CALL channel.write(l_str)
          CALL channel.write("")
       END IF
 
       CALL channel.write("")
       CALL channel.write("#------------------------------------------------------------------------------#")
       CALL channel.close()
#      RUN "chmod 666 " || l_file || " >/dev/null 2>&1"   #No.FUN-9C0009
       IF os.Path.chrwx(l_file CLIPPED,438) THEN END IF   #No.FUN-9C0009
    ELSE
       DISPLAY "Can't open log file."
    END IF
 
END FUNCTION
 
FUNCTION aws_bicli_auto_menu(p_gcf09)
DEFINE p_gcf09   LIKE gcf_file.gcf09
#FUN-840065 start
{DEFINE l_cnt    LIKE type_file.num10                          #FUN-680135 
DEFINE l_zz01   LIKE zz_file.zz01
DEFINE l_gaz03  LIKE gaz_file.gaz03                           #FUN-740207
DEFINE l_sql    STRING
 
   BEGIN WORK
 
   SELECT COUNT(*) INTO l_cnt FROM gci_file 
   IF l_cnt = 0 THEN
         RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM zm_file where zm01='mbo' 
   IF l_cnt = 0 THEN
       IF NOT cl_confirm("azz-131") THEN
              RETURN
       END IF   
   ELSE
       IF NOT cl_confirm("azz-132") THEN
              RETURN
       END IF   
       DELETE FROM zm_file where zm01='mbo'
       IF SQLCA.sqlcode THEN  #No.FUN-660081
           CALL cl_err3("del","zm_file","mbo",'',SQLCA.sqlcode,"","",1) #No.FUN-660081
           ROLLBACK WORK
           RETURN
       END IF
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM zm_file where zm01='menu' AND zm04='mbo'
   IF l_cnt = 0 THEN
      SELECT MAX(zm03) INTO l_cnt FROM zm_file where zm01='menu'
      IF l_cnt IS NULL THEN
          LET l_cnt = 1
      END IF
      LET l_cnt = l_cnt + 1
      INSERT INTO zm_file VALUES('menu',l_cnt,'mbo')
      IF SQLCA.sqlcode THEN  #No.FUN-660081
          CALL cl_err3("ins","zm_file",'mbo','',SQLCA.sqlcode,"","",1) #No.FUN-660081
          ROLLBACK WORK
          RETURN
      END IF
   END IF 
   LET l_cnt = 0
   #FUN-740207
   #LET g_sql = "SELECT zz01 FROM zz_file where zz01 like 'bo%'"
   LET l_sql = "SELECT zz01,gaz03 FROM zz_file,gaz_file where zz01 like 'bo%'",
               "   AND gaz01=zz01 AND gaz02='",g_lang,"' ORDER BY gaz03"
   #END FUN-740207
   PREPARE p_bi_menu FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','zz_file','','',SQLCA.sqlcode,'','',1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80064   ADD
      EXIT PROGRAM
   END IF
   DECLARE p_bi_menu_cs CURSOR FOR p_bi_menu
   FOREACH p_bi_menu_cs INTO l_zz01,l_gaz03
     IF SQLCA.sqlcode THEN
        CALL cl_err3('sel','zz_file','','',SQLCA.sqlcode,'','',1) 
        EXIT FOREACH
     END IF
     LET l_cnt=l_cnt+1
     INSERT INTO zm_file VALUES('mbo',l_cnt,l_zz01)
     IF SQLCA.sqlcode THEN  #No.FUN-660081
         CALL cl_err3("ins","zm_file",l_zz01,'',SQLCA.sqlcode,"","",1) #No.FUN-660081
         ROLLBACK WORK
         RETURN
     END IF
   END FOREACH
   }   
   
   #產生BI 銷售模組 menu
   CALL auto_menu("mbo")
   IF p_gcf09='Y' THEN
      CALL auto_menu("mbi")
   ELSE
    	DELETE FROM zm_file where zm01='mbi'
      IF SQLCA.sqlcode THEN  #No.FUN-660081
           CALL cl_err3("del","zm_file",'mbi','',SQLCA.sqlcode,"","",1) #No.FUN-660081
           ROLLBACK WORK
           RETURN
      END IF
   END IF
#FUN-840065 end
   #COMMIT WORK
   CALL cl_ora_redo_menu()              #重新產生menu
 
END FUNCTION
 
FUNCTION auto_menu(p_menu_id)
DEFINE p_menu_id  LIKE zm_file.zm01
DEFINE l_cnt    LIKE type_file.num10                          #FUN-680135 
DEFINE l_zz01   LIKE zz_file.zz01
DEFINE l_gaz03  LIKE gaz_file.gaz03                           #FUN-740207
DEFINE l_sql    STRING
DEFINE l_type    STRING
DEFINE l_msgid   STRING
 
   BEGIN WORK
 
   SELECT COUNT(*) INTO l_cnt FROM gci_file 
   IF l_cnt = 0 THEN
         RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM zm_file where zm01=p_menu_id 
   IF l_cnt = 0 THEN
   	   #FUN-840065 start
   	   IF p_menu_id='mbo' THEN
   	   	  LET l_msgid = "azz-131"
   	   ELSE
   	   		LET l_msgid = "azz-147"
   	   END IF
   	   #FUN-840065 end
       IF NOT cl_confirm(l_msgid) THEN
              RETURN
       END IF   
   ELSE
   	   #FUN-840065 start
   	   IF p_menu_id='mbo' THEN
   	   	  LET l_msgid = "azz-132"
   	   ELSE
   	   		LET l_msgid = "azz-146"
   	   END IF
   	   #FUN-840065 end
       IF NOT cl_confirm(l_msgid) THEN
              RETURN
       END IF   
       DELETE FROM zm_file where zm01=p_menu_id
       IF SQLCA.sqlcode THEN  #No.FUN-660081
           CALL cl_err3("del","zm_file",p_menu_id,'',SQLCA.sqlcode,"","",1) #No.FUN-660081
           ROLLBACK WORK
           RETURN
       END IF
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM zm_file where zm01='menu' AND zm04=p_menu_id
   IF l_cnt = 0 THEN
      SELECT MAX(zm03) INTO l_cnt FROM zm_file where zm01='menu'
      IF l_cnt IS NULL THEN
          LET l_cnt = 1
      END IF
      LET l_cnt = l_cnt + 1
      INSERT INTO zm_file VALUES('menu',l_cnt,p_menu_id)
      IF SQLCA.sqlcode THEN  #No.FUN-660081
          CALL cl_err3("ins","zm_file",p_menu_id,'',SQLCA.sqlcode,"","",1) #No.FUN-660081
          ROLLBACK WORK
          RETURN
      END IF
   END IF 
   LET l_cnt = 0
   #FUN-740207
   #LET g_sql = "SELECT zz01 FROM zz_file where zz01 like 'bo%'"
   #FUN-840065 start
   IF p_menu_id='mbo' THEN
   	  LET l_type ="bo"
   ELSE
   	  LET l_type ="bi"
   END IF
   #FUN-840065 end
   
   LET l_sql = "SELECT zz01,gaz03 FROM zz_file,gaz_file where zz01 like '",l_type,"%'",
               "   AND gaz01=zz01 AND gaz02='",g_lang,"' ORDER BY gaz03"
   #END FUN-740207
   PREPARE p_bi_menu FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','zz_file','','',SQLCA.sqlcode,'','',1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80064   ADD
      EXIT PROGRAM
   END IF
   DECLARE p_bi_menu_cs CURSOR FOR p_bi_menu
   FOREACH p_bi_menu_cs INTO l_zz01,l_gaz03
     IF SQLCA.sqlcode THEN
        CALL cl_err3('sel','zz_file','','',SQLCA.sqlcode,'','',1) 
        EXIT FOREACH
     END IF
     LET l_cnt=l_cnt+1
     INSERT INTO zm_file VALUES(p_menu_id,l_cnt,l_zz01)
     IF SQLCA.sqlcode THEN  #No.FUN-660081
         CALL cl_err3("ins","zm_file",l_zz01,'',SQLCA.sqlcode,"","",1) #No.FUN-660081
         ROLLBACK WORK
         RETURN
     END IF
   END FOREACH
   COMMIT WORK
END FUNCTION   
